/**
 * @file cx16-veralib.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Commander X16 vera library for the kickc compiler.
 * Commander X16 VERA (Versatile Embedded Retro Adapter) Video and Audio Processor
 * [https://github.com/commanderx16/x16-docs/blob/master/VERA%20Programmer's%20Reference.md]()
 * @version 0.1
 * @date 2021-06-14
 * 
 * @copyright Copyright (c) 2021
 * 
 */


#include <cx16.h>
#include "cx16-veralib.h"

__mem volatile word  vera_mapbase_offset[2] = {0,0};
__mem volatile byte  vera_mapbase_bank[2] = {0,0};
__mem volatile dword vera_mapbase_address[2] = {0,0};

__mem volatile word  vera_tilebase_offset[2] = {0,0};
__mem volatile byte  vera_tilebase_bank[2] = {0,0};
__mem volatile dword vera_tilebase_address[2] = {0,0};

__mem volatile byte vera_layer_rowshift[2] = {0,0};
__mem volatile word vera_layer_rowskip[2] = {0,0};

const byte vera_layer_hflip[2] = {0,0x04};
const byte vera_layer_vflip[2] = {0,0x08};


const byte* vera_layer_config[2] = {(byte*)VERA_L0_CONFIG, (byte*)VERA_L1_CONFIG};
const byte vera_layer_enable[2] = { VERA_LAYER0_ENABLE, VERA_LAYER1_ENABLE };

const byte* vera_layer_mapbase[2] = {VERA_L0_MAPBASE, VERA_L1_MAPBASE};
const byte* vera_layer_tilebase[2] = {VERA_L0_TILEBASE, VERA_L1_TILEBASE};
const byte* vera_layer_vscroll_l[2] = {VERA_L0_VSCROLL_L, VERA_L1_VSCROLL_L};
const byte* vera_layer_vscroll_h[2] = {VERA_L0_VSCROLL_H, VERA_L1_VSCROLL_H};
const byte* vera_layer_hscroll_l[2] = {VERA_L0_HSCROLL_L, VERA_L1_HSCROLL_L};
const byte* vera_layer_hscroll_h[2] = {VERA_L0_HSCROLL_H, VERA_L1_HSCROLL_H};

__mem volatile byte vera_layer_textcolor[2] = {WHITE, WHITE};
__mem volatile byte vera_layer_backcolor[2] = {BLUE, BLUE};

const byte hscale[4] = {0,128,64,32};


// --- VERA function encapsulation ---

// --- VERA layer management ---


// --- VERA addressing ---

dword vera_ptr_to_address( byte bank, char* ptr ) {
    dword r = (word)ptr;
    r += bank?(dword)0x10000:(dword)0;
    return r;
}

char* vera_address_to_ptr( dword address ) {
    return (char*)(<address);
}

char vera_address_to_bank( dword address ) {
    return <(>address);
}

/**
 * @brief Configure data port 0 of the vera using bank and offset.
 * 
 * @param bank The 8 bit bank of the vera to set.
 * @param offset The 16 bit offset of the vera to set.
 * @param inc_dec The vera increment/decrement enum.
 */
inline void vera_vram_data0_bank_offset(cx16_bank bank, cx16_vram_offset offset, enum vera_inc_dec inc_dec) {
    *VERA_CTRL &= ~VERA_ADDRSEL;     // Select DATA0
    *VERA_ADDRX_L = BYTE0(offset); 
    *VERA_ADDRX_M = BYTE1(offset);
    *VERA_ADDRX_H = bank | inc_dec;
}

/**
 * @brief Configure data port 1 of the vera using bank and offset.
 * 
 * @param bank The 8 bit bank of the vera to set.
 * @param offset The 16 bit offset of the vera to set.
 * @param inc_dec The vera increment/decrement enum.
 */
inline void vera_vram_data1_bank_offset(cx16_bank bank, cx16_vram_offset offset, enum vera_inc_dec inc_dec) {
    *VERA_CTRL |= VERA_ADDRSEL;     // Select DATA1
    *VERA_ADDRX_L = BYTE0(offset); 
    *VERA_ADDRX_M = BYTE1(offset);
    *VERA_ADDRX_H = bank | inc_dec;
}

/**
 * @brief Configure data port 0 of the vera using an address structure.
 * 
 * @param bankaddr The packed address containing the bank and offset, possibly aligned to x bytes in vera memory.
 * @param inc_dec The vera increment/decrement enum.
 */
inline void vera_vram_data0_address(dword bankaddr, enum vera_inc_dec inc_dec) {
    vera_vram_data0_bank_offset( BYTE2(bankaddr), WORD0(bankaddr), inc_dec );
}

/**
 * @brief Configure data port 1 of the vera using an address structure.
 * 
 * @param bankaddr The packed address containing the bank and offset, possibly aligned to x bytes in vera memory.
 * @param inc_dec The vera increment/decrement enum.
 */
inline void vera_vram_data1_address(dword bankaddr, enum vera_inc_dec inc_dec) {
    vera_vram_data1_bank_offset( BYTE2(bankaddr), WORD0(bankaddr), inc_dec );
}


/// @section VERA DISPLAY MANAGEMENT

/**
 * @brief Disable all scaling of the vera display.
 * 
 */
inline void vera_display_set_scale_none() {
    *VERA_DC_HSCALE = 128;
    *VERA_DC_VSCALE = 128;
}

/**
 * @brief Double scaling of the vera display.  
 * The characters and graphics will work at a 320x240 resolution.
 * 
 */
inline void vera_display_set_scale_double() {
    *VERA_DC_HSCALE = 64;
    *VERA_DC_VSCALE = 64;
}

/**
 * @brief Triple scaling of the vera display.
 * Never tried this. TODO.
 * 
 */
inline void vera_display_set_scale_triple() {
    *VERA_DC_HSCALE = 32;
    *VERA_DC_VSCALE = 32;
}

/**
 * @brief Return the current horizonal scale of the vera display.
 * 
 * @return vera_scale 
 */
vera_scale vera_display_get_hscale() {
    vera_scale hscale[4] = {0,128,64,32};
    vera_scale scale = 0;
    for(byte s:1..3) {
        if(*VERA_DC_HSCALE==hscale[s]) {
            scale = s;
            break;
        }
    }
    return scale;
}

/**
 * @brief Return the current vertical scale of the vera display.
 * 
 * @return vera_scale 
 */
vera_scale vera_display_get_vscale() {
    vera_scale vscale[4] = {0,128,64,32};
    vera_scale scale = 0;
    for(byte s:1..3) {
        if(*VERA_DC_VSCALE==vscale[s]) {
            scale = s;
            break;
        }
    }
    return scale;
}

/**
 * @brief Return the current height of the vera display.
 * 
 * @return vera_height 
 */
vera_height vera_display_get_height() {
    vera_scale scale = vera_display_get_vscale();
    *VERA_CTRL = *VERA_CTRL | VERA_DCSEL;
    vera_height height = (vera_height)(*VERA_DC_VSTOP - *VERA_DC_VSTART);
    switch( scale ) {
        case 2:
            height = height >> 1;
            break;
        case 3:
            height = height >> 2;
            break;
    }
    *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL;
    return height<<1;
}

/**
 * @brief Return the current width of the vera display.
 * 
 * @return vera_width 
 */
vera_width vera_display_get_width() {
    vera_scale scale = vera_display_get_hscale();
    *VERA_CTRL = *VERA_CTRL | VERA_DCSEL;
    vera_width width = (vera_width)(*VERA_DC_HSTOP - *VERA_DC_HSTART);
    switch( scale ) {
        case 2:
            width = width >> 1;
            break;
        case 3:
            width = width >> 2;
            break;
    }
    *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL;
    return width<<1;
}

/**
 * @section VERA LAYER MANAGEMENT 
 */

/**
 * @brief Set the configuration of the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @param config Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
 */
void vera_layer_set_config(vera_layer layer, byte config) {
    byte* addr = vera_layer_config[layer];
    *addr = config;
}

/**
 * @brief Get the configuration of the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_config Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
 */
vera_config vera_layer_get_config(vera_layer layer) {
    byte* config = vera_layer_config[layer];
    return *config;
}


/**
 * @brief Set the configuration of the layer text color mode.
 * 
 * @param layer The layer of the vera 0/1.
 * @param color_mode Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
 */
void vera_layer_set_text_color_mode(vera_layer layer, vera_color_mode color_mode) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_256C;
    *addr |= color_mode;
}


/**
 * @brief Set the configuration of the layer to bitmap mode.
 * 
 * @param layer The layer of the vera 0/1.
 */
void vera_layer_set_bitmap_mode(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_MODE_BITMAP;
    *addr |= VERA_LAYER_CONFIG_MODE_BITMAP;
}


/**
 * @brief Set the configuration of the layer to tilemap mode.
 * 
 * @param layer The layer of the vera 0/1.
 */
void vera_layer_set_tilemap_mode( vera_layer layer ) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_MODE_BITMAP;
    *addr |= VERA_LAYER_CONFIG_MODE_TILE;
}


/**
 * @brief Set the map width of the layer to 32 characters.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_set_width_32(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_WIDTH_MASK;
    *addr |= VERA_LAYER_WIDTH_32;
}


/**
 * @brief Set the map width of the layer to 64 characters.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_set_width_64(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    //*addr &= (~VERA_CONFIG_WIDTH_MASK) | VERA_CONFIG_WIDTH_64;
    *addr &= ~VERA_LAYER_WIDTH_MASK;
    *addr |= VERA_LAYER_WIDTH_64;
}


/**
 * @brief Set the map width of the layer to 128 characters.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_set_width_128(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_WIDTH_MASK;
    *addr |= VERA_LAYER_WIDTH_128;
}

/**
 * @brief Set the map width of the layer to 256 characters.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_set_width_256(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_WIDTH_MASK;
    *addr |= VERA_LAYER_WIDTH_256;
}

/**
 * @brief Set the map height of the layer to 32 characters.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_set_height_32(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_HEIGHT_MASK;
    *addr |= VERA_LAYER_HEIGHT_32;
}

/**
 * @brief Set the map height of the layer to 64 characters.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_set_height_64(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_HEIGHT_MASK;
    *addr |= VERA_LAYER_HEIGHT_64;
}

/**
 * @brief Set the map height of the layer to 128 characters.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_set_height_128(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_HEIGHT_MASK;
    *addr |= VERA_LAYER_HEIGHT_128;
}

/**
 * @brief Set the map height of the layer to 256 characters.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_set_height_256(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_HEIGHT_MASK;
    *addr |= VERA_LAYER_HEIGHT_256;
}


/**
 * @brief Get the map width of the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_width  
 */
inline vera_width vera_layer_get_width(vera_layer layer) {
    byte* config = vera_layer_config[layer];
    return VERA_LAYER_WIDTH[ (*config & VERA_LAYER_WIDTH_MASK) >> 4];
}


/**
 * @brief Get the map width of the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_height  
 */
inline vera_height vera_layer_get_height(vera_layer layer) {
    byte* config = vera_layer_config[layer];
    return VERA_LAYER_HEIGHT[ (*config & VERA_LAYER_HEIGHT_MASK) >> 6];
}


/**
 * @brief Set the color depth of the layer in bit per pixel (BPP) to 1.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_set_color_depth_1BPP(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_1BPP;
}

/**
 * @brief Set the color depth of the layer in bit per pixel (BPP) to 2.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_set_color_depth_2BPP(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_2BPP;
}

/**
 * @brief Set the color depth of the layer in bit per pixel (BPP) to 4.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_set_color_depth_4BPP(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_4BPP;
}

/**
 * @brief Set the color depth of the layer in bit per pixel (BPP) to 8.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_set_color_depth_8BPP(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_8BPP;
}


/**
 * @brief Get the color depth of the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_color_depth 0 = 1 color, 1 = 2 colors, 2 = 4 colors or 3 = 8 colors.
 */
inline vera_color_depth vera_layer_get_color_depth(vera_layer layer) {
    byte* config = vera_layer_config[layer];
    return (*config & VERA_LAYER_COLOR_DEPTH_MASK);
}


/**
 * @brief Enable the layer to be displayed on the screen.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_show(vera_layer layer) {
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO |= vera_layer_enable[layer];
}


/**
 * @brief Hide the layer to be displayed from the screen.
 * 
 * @param layer The layer of the vera 0/1.
 */
inline void vera_layer_hide(vera_layer layer) {
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO &= ~vera_layer_enable[layer];
}


/**
 * @brief Is the layer shown on the screen?
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_layer_visible 1 if layer is displayed on the screen, 0 if not.
 */
inline vera_layer_visible vera_layer_is_visible(vera_layer layer) {
    *VERA_CTRL &= ~VERA_DCSEL;
    return *VERA_DC_VIDEO & vera_layer_enable[layer];
}


/**
 * @brief Set the base of the map layer with which the conio will interact.
 * 
 * @param layer The layer of the vera 0/1.
 * @param mapbase Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:9 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
 * 
 */
void vera_layer_set_mapbase(vera_layer layer, vera_map_offset mapbase) {
    byte* addr = vera_layer_mapbase[layer];
    *addr = mapbase;
}

// Set the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - mapbase_address: a dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
void vera_layer_set_mapbase_address(vera_layer layer, dword mapbase_address) {

    mapbase_address = mapbase_address & 0x1FF00; // Aligned to 2048 bit zones.
    byte bank_mapbase = (byte)>mapbase_address;
    word offset_mapbase = <mapbase_address;

    vera_mapbase_address[layer] = mapbase_address;
    vera_mapbase_offset[layer] = offset_mapbase;
    vera_mapbase_bank[layer] = bank_mapbase;

    byte mapbase = >(<(mapbase_address>>1));
    vera_layer_set_mapbase(layer,mapbase);
}

// Get the map base address of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Specifies the map base address of the layer, which is returned as a dword.
//   Note that the register only specifies bits 16:9 of the 17 bit address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes!
dword vera_layer_get_mapbase_address(vera_layer layer) {
    return vera_mapbase_address[layer];
}


/**
 * @brief Get the map base bank of the tiles for the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_bank Bank in vera vram.
 */
vera_bank vera_layer_get_mapbase_bank(vera_layer layer) {
    return vera_mapbase_bank[layer];
}


/**
 * @brief Get the map base lower 16-bit address (offset) of the tiles for the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_offset Offset in vera vram of the specified bank.
 */
vera_offset vera_layer_get_mapbase_offset(vera_layer layer) {
    return vera_mapbase_offset[layer];
}


/**
 * @brief Get the base of the map layer with which the conio will interact.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_map_offset Returns the base address of the tile map.
 * Note that the register is a byte, specifying only bits 16:9 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
 */
vera_map_offset vera_layer_get_mapbase(vera_layer layer) {
    byte* mapbase = vera_layer_mapbase[layer];
    return *mapbase;
}


/**
 * @brief Set the base of the tiles for the layer with which the conio will interact.
 * 
 * @param layer The layer of the vera 0/1.
 * @param tilebase Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:11 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
 */
void vera_layer_set_tilebase(vera_layer layer, byte tilebase) {
    byte* addr = vera_layer_tilebase[layer];
    *addr = tilebase;
}


/**
 * @brief Get the base of the tiles for the layer with which the conio will interact.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_tile_offset Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:11 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
 */
vera_tile_offset vera_layer_get_tilebase(vera_layer layer) {
    byte* tilebase = vera_layer_tilebase[layer];
    return *tilebase;
}


// Set the base address of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - tilebase_address: a dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
void vera_layer_set_tilebase_address(vera_layer layer, dword tilebase_address) {

    tilebase_address = tilebase_address & 0x1FC00; // Aligned to 2048 bit zones.
    byte bank_tilebase = (byte)>tilebase_address;
    word word_tilebase = <tilebase_address;

    vera_tilebase_address[layer] = tilebase_address;
    vera_tilebase_offset[layer] = word_tilebase;
    vera_tilebase_bank[layer] = bank_tilebase;

    byte* vera_tilebase = vera_layer_tilebase[layer];
    byte tilebase = >(<(tilebase_address>>1));
    tilebase &= VERA_LAYER_TILEBASE_MASK; // Ensure that only tilebase is blanked, but keep the rest!
    //printf("tilebase = %x\n",tilebase);
    //while(!kbhit());
    tilebase = tilebase | ( *vera_tilebase & ~VERA_LAYER_TILEBASE_MASK );

    vera_layer_set_tilebase(layer,tilebase);
}

// Get the tile base address of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Specifies the base address of the tile map, which is calculated as an unsigned long int.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
dword vera_layer_get_tilebase_address(vera_layer layer) {
    byte tilebase = *vera_layer_tilebase[layer];
    dword address = tilebase;
    address &= $FC;
    address <<= 8;
    address <<= 1;
    return address;
}

/// @section VERA color management

/**
 * @brief Set the front color for text output. The old front text color setting is returned.
 * 
 * @param layer The layer of the vera 0/1.
 * @param color a 4 bit value ( decimal between 0 and 15) when the VERA works in 16x16 color text mode.
 * An 8 bit value (decimal between 0 and 255) when the VERA works in 256 text mode.
 * Note that on the VERA, the transparent color has value 0.
 * @return vera_forecolor 
 */
vera_forecolor vera_layer_set_textcolor(vera_layer layer, byte color) {
    byte old = vera_layer_textcolor[layer];
    vera_layer_textcolor[layer] = color;
    return old;
}


/**
 * @brief Get the front color for text output. The old front text color setting is returned.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_forecolor A 4 bit value ( decimal between 0 and 15).
 * This will only work when the VERA is in 16 color mode!
 * Note that on the VERA, the transparent color has value 0.
 */
vera_forecolor vera_layer_get_textcolor(vera_layer layer) {
    return vera_layer_textcolor[layer];
}

/**
 * @brief Set the back color for text output. The old back text color setting is returned.
 * 
 * @param layer The layer of the vera 0/1.
 * @param color a 4 bit value ( decimal between 0 and 15).
 * This will only work when the VERA is in 16 color mode!
 * Note that on the VERA, the transparent color has value 0.
 * @return vera_backcolor 
 */
vera_backcolor vera_layer_set_backcolor(vera_layer layer, vera_backcolor color) {
    byte old = vera_layer_backcolor[layer];
    vera_layer_backcolor[layer] = color;
    return old;
}


/**
 * @brief Get the back color for text output. The old back text color setting is returned.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_backcolor a 4 bit value ( decimal between 0 and 15).
 * This will only work when the VERA is in 16 color mode!
 * Note that on the VERA, the transparent color has value 0.
 */
vera_backcolor vera_layer_get_backcolor(vera_layer layer) {
    return vera_layer_backcolor[layer];
}


/**
 * @brief Get the text and back color for text output in 16 color mode.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_textcolor an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
 * This will only work when the VERA is in 16 color mode!
 * Note that on the VERA, the transparent color has value 0.
 */
vera_textcolor vera_layer_get_color(vera_layer layer) {
    byte* addr = vera_layer_config[layer];
    if( *addr & VERA_LAYER_CONFIG_256C )
        return (vera_layer_textcolor[layer]);
    else
        return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
}


/**
 * @brief Scroll the horizontal (X) axis of the layer visible area over the layer tile map area.
 * 
 * @param layer The layer of the vera 0/1.
 * @param scroll A value between 0 and 4096.
 */
inline void vera_layer_set_horizontal_scroll(vera_layer layer, word scroll) {
    *vera_layer_hscroll_l[layer] = <scroll;
    *vera_layer_hscroll_h[layer] = >scroll;
}

/**
 * @brief Scroll the vertical (Y) axis of the layer visible area over the layer tile map area.
 * 
 * @param layer The layer of the vera 0/1.
 * @param scroll A value between 0 and 4096.
 */
inline void vera_layer_set_vertical_scroll(vera_layer layer, word scroll) {
    *vera_layer_vscroll_l[layer] = <scroll;
    *vera_layer_vscroll_h[layer] = >scroll;
}


// Get the bit shift value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
byte vera_layer_get_rowshift(vera_layer layer) {
    return vera_layer_rowshift[layer];
}

// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
word vera_layer_get_rowskip(vera_layer layer) {
    return vera_layer_rowskip[layer];
}



// Set a vera layer in tile mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// - mapwidth: The width of the map in number of tiles.
// - mapheight: The height of the map in number of tiles.
// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
// - tileheight: The height of a tile, which can be 8 or 16 pixels.
// - color_depth: The color depth in bits per pixel (BPP), which can be 1, 2, 4 or 8.
void vera_layer_mode_tile(vera_layer layer, dword mapbase_address, dword tilebase_address, word mapwidth, word mapheight, byte tilewidth, byte tileheight, byte color_depth ) {
    // config

    byte config = 0x00;
    switch(color_depth) {
        case 1:
            config |= VERA_LAYER_COLOR_DEPTH_1BPP;
            break;
        case 2:
            config |= VERA_LAYER_COLOR_DEPTH_2BPP;
            break;
        case 4:
            config |= VERA_LAYER_COLOR_DEPTH_4BPP;
            break;
        case 8:
            config |= VERA_LAYER_COLOR_DEPTH_8BPP;
            break;
    }

    switch(mapwidth) {
        case 32:
            config |= VERA_LAYER_WIDTH_32;
            vera_layer_rowshift[layer] = 6;
            vera_layer_rowskip[layer] = 64;
            break;
        case 64:
            config |= VERA_LAYER_WIDTH_64;
            vera_layer_rowshift[layer] = 7;
            vera_layer_rowskip[layer] = 128;
            break;
        case 128:
            config |= VERA_LAYER_WIDTH_128;
            vera_layer_rowshift[layer] = 8;
            vera_layer_rowskip[layer] = 256;
            break;
        case 256:
            config |= VERA_LAYER_WIDTH_256;
            vera_layer_rowshift[layer] = 9;
            vera_layer_rowskip[layer] = 512;
            break;
    }
    switch(mapheight) {
        case 32:
            config |= VERA_LAYER_HEIGHT_32;
            break;
        case 64:
            config |= VERA_LAYER_HEIGHT_64;
            break;
        case 128:
            config |= VERA_LAYER_HEIGHT_128;
            break;
        case 256:
            config |= VERA_LAYER_HEIGHT_256;
            break;
    }
    vera_layer_set_config(layer, config);

    // mapbase
    vera_mapbase_offset[layer] = <mapbase_address;
    vera_mapbase_bank[layer] = (byte)(>mapbase_address);
    vera_mapbase_address[layer] = mapbase_address;

    mapbase_address = mapbase_address >> 1;
    byte mapbase = >(<mapbase_address);
    vera_layer_set_mapbase(layer,mapbase);

    // tilebase
    vera_tilebase_offset[layer] = <tilebase_address;
    vera_tilebase_bank[layer] = (byte)>tilebase_address;
    vera_tilebase_address[layer] = tilebase_address;

    tilebase_address = tilebase_address >> 1;
    byte tilebase = >(<tilebase_address);
    tilebase &= VERA_LAYER_TILEBASE_MASK;
    switch(tilewidth) {
        case 8:
            tilebase |= VERA_TILEBASE_WIDTH_8;
            break;
        case 16:
            tilebase |= VERA_TILEBASE_WIDTH_16;
            break;
    }
    switch(tileheight) {
        case 8:
            tilebase |= VERA_TILEBASE_HEIGHT_8;
            break;
        case 16:
            tilebase |= VERA_TILEBASE_HEIGHT_16;
            break;
    }
    vera_layer_set_tilebase(layer,tilebase);
}


// Set a vera layer in text mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// - mapwidth: The width of the map in number of tiles.
// - mapheight: The height of the map in number of tiles.
// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
// - tileheight: The height of a tile, which can be 8 or 16 pixels.
// - color_mode: The color mode, which can be 16 or 256.
void vera_layer_mode_text(vera_layer layer, dword mapbase_address, dword tilebase_address, word mapwidth, word mapheight, byte tilewidth, byte tileheight, word color_mode ) {
    vera_layer_mode_tile( layer, mapbase_address, tilebase_address, mapwidth, mapheight, tilewidth, tileheight, 1 );
    switch(color_mode) {
        case 16:
            vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C );
            break;
        case 256:
            vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_256C );
            break;
    }
}

// Set a vera layer in bitmap mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - mapwidth: The width of the map, which can be 320 or 640.
// - color_depth: The color color depth, which can have values 1, 2, 4, 8, for 1 color, 4 colors, 16 colors or 256 colors respectively.
void vera_layer_mode_bitmap(vera_layer layer, dword bitmap_address, word mapwidth, word color_depth ) {


    // config
    byte config = 0x00;
    switch(color_depth) {
        case 1:
            config |= VERA_LAYER_COLOR_DEPTH_1BPP;
            break;
        case 2:
            config |= VERA_LAYER_COLOR_DEPTH_2BPP;
            break;
        case 4:
            config |= VERA_LAYER_COLOR_DEPTH_4BPP;
            break;
        case 8:
            config |= VERA_LAYER_COLOR_DEPTH_8BPP;
            break;
    }
    config = config | VERA_LAYER_CONFIG_MODE_BITMAP;

    // tilebase
    vera_tilebase_offset[layer] = <bitmap_address;
    vera_tilebase_bank[layer] = (byte)>bitmap_address;
    vera_tilebase_address[layer] = bitmap_address;

    bitmap_address = bitmap_address >> 1;
    byte tilebase = >(<bitmap_address);
    tilebase &= VERA_LAYER_TILEBASE_MASK;

    // mapwidth
    switch(mapwidth) {
        case 320:
            vera_display_set_scale_double();
            tilebase |= VERA_TILEBASE_WIDTH_8;
            break;
        case 640:
            vera_display_set_scale_none();
            tilebase |= VERA_TILEBASE_WIDTH_16;
            break;
    }

    vera_layer_set_config(layer, config);
    vera_layer_set_tilebase(layer,tilebase);
}

// --- SPRITE STRUCTURE ---


// --- SPRITE FUNCTIONS ---

inline void vera_sprite_address(vera_sprite sprite, dword address) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset, vera_inc_1);
    *VERA_DATA0 = <((<address)>>5);
    *VERA_DATA0 = ((>(<address))>>5)|((<(>address))<<3);
}

/**
 * @brief Set a sprite offset in vera memory.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 * @param bank The bank in vera memory.
 * @param offset The offset in vera memory.
 */
inline void vera_sprite_bank_offset(vera_sprite sprite, vera_bank bank, vera_offset offset) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset, vera_inc_1);
    *VERA_DATA0 = <((word)offset>>5);
    *VERA_DATA0 = ((>(word)offset)>>5)|(bank<<3);
}

/**
 * @brief Set a sprite position on the display.
 * Note that the x and y coordinates are expressed in 2s complement, so a negative position will hide a sprite on the top or left border!
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 * @param x The x coordinate.
 * @param y The y coordinate.
 */
inline void vera_sprite_xy(vera_sprite sprite, vera_sprite_coordinate x, vera_sprite_coordinate y) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+2, vera_inc_1);
    *VERA_DATA0 = <x;
    *VERA_DATA0 = >x;
    *VERA_DATA0 = <y;
    *VERA_DATA0 = >y;
}


/**
 * @brief Set the color depth of a sprite to 4 bits per pixel (16 color).
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_4bpp(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+1, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~>VERA_SPRITE_8BPP;
}


/**
 * @brief Set the color depth of a sprite to 8 bits per pixel (256 color).
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_8bpp(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+1, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 | >VERA_SPRITE_8BPP;
}


/**
 * @brief Set the sprite bits per pixel.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 * @param bpp Bits per pixel of the sprite graphics color depth, which can be a value of 4 or 8.
 */
inline void vera_sprite_bpp(vera_sprite sprite, byte bpp) {
    if(bpp==4) {
        vera_sprite_4bpp(sprite);
    } else {
        vera_sprite_8bpp(sprite);
    }
}

/**
 * @brief Flip the sprite horizontally.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_hflip_on(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 | VERA_SPRITE_HFLIP;
}


/**
 * @brief Put the sprite back in normal horizontal form.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_hflip_off(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HFLIP;
}


void vera_sprite_hflip(vera_sprite sprite, byte hflip) {
    if(hflip) {
        vera_sprite_hflip_on(sprite);
    } else {
        vera_sprite_hflip_off(sprite);
    }
}


/**
 * @brief Flip the sprite vertically.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_vflip_on(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 | VERA_SPRITE_VFLIP;
}


/**
 * @brief Put the sprite back in normal vertical form.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_vflip_off(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_VFLIP;
}

void vera_sprite_vflip(vera_sprite sprite, byte vflip) {
    if(vflip) {
        vera_sprite_vflip_on(sprite);
    } else {
        vera_sprite_vflip_off(sprite);
    }
}

/**
 * @brief Hide a sprite.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_disable(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK;
}


/**
 * @brief Position the z depth of the sprite between the background and layer 0.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_zdepth_between_background_and_layer0(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0;
}


/**
 * @brief Position the z depth of the sprite between layer 0 and layer 1.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_zdepth_between_layer0_and_layer1(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1;
}


/**
 * @brief Position the z depth of the sprite in front of everything.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_zdepth_in_front(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_IN_FRONT;
}

void vera_sprite_zdepth(vera_sprite sprite, byte zdepth) {
    switch(zdepth) {
        case 3:
            vera_sprite_zdepth_in_front(sprite);
            break;
        case 2:
            vera_sprite_zdepth_between_layer0_and_layer1(sprite);
            break;
        case 1:
            vera_sprite_zdepth_between_background_and_layer0(sprite);
            break;
        case 0:
            vera_sprite_disable(sprite);
            break;
    }
}


/**
 * @brief Set the width of the sprite to 8 pixels.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_width_8(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_8;
}


/**
 * @brief Set the width of the sprite to 16 pixels.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_width_16(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_16;
}


/**
 * @brief Set the width of the sprite to 32 pixels.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_width_32(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_32;
}


/**
 * @brief Set the width of the sprite to 64 pixels.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_width_64(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_64;
}

void vera_sprite_width(vera_sprite sprite, byte width) {
    switch(width) {
        case 8:
            vera_sprite_width_8(sprite);
            break;
        case 16:
            vera_sprite_width_16(sprite);
            break;
        case 32:
            vera_sprite_width_32(sprite);
            break;
        case 64:
            vera_sprite_width_64(sprite);
            break;
    }
}


/**
 * @brief Set the height of the sprite to 8 pixels.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_height_8(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_8;
}


/**
 * @brief Set the height of the sprite to 16 pixels.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_height_16(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_16;
}


/**
 * @brief Set the height of the sprite to 32 pixels.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_height_32(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_32;
}


/**
 * @brief Set the height of the sprite to 64 pixels.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 */
inline void vera_sprite_height_64(vera_sprite sprite) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_64;
}

inline void vera_sprite_height(vera_sprite sprite, byte height) {
    switch(height) {
        case 8:
            vera_sprite_height_8(sprite);
            break;
        case 16:
            vera_sprite_height_16(sprite);
            break;
        case 32:
            vera_sprite_height_32(sprite);
            break;
        case 64:
            vera_sprite_height_64(sprite);
            break;
    }
}

/**
 * @brief Set the palette offset of the sprite.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 * @param palette_offset The palette offset, a byte between 0 and 15.
 */
inline void vera_sprite_palette_offset(vera_sprite sprite, vera_palette_offset palette_offset) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK | palette_offset;
}

/**
 * @brief Set the collision mask for a sprite.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 * @param mask The collision mask, a byte containing 4 bits in the lower tetrade indicating the groups for which collision detection will be performed.
 */
inline void vera_sprite_collision_mask(vera_sprite sprite, vera_collision_mask mask) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_COLLISION_MASK | mask << 4;
}


/**
 * @brief Set all the sprite attributes in one go using the struct VERA_SPRITE. 
 * When configuring a lot of attributes for a sprite, this is faster than calling each individual function.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 * @param sprite_attr The sprite attributes contained in a VERA_SPRITE structure.
 */
inline void vera_sprite_attributes_set(vera_sprite sprite, struct VERA_SPRITE sprite_attr) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    cx16_cpy_vram_from_ram(1, (word)sprite_offset, (unsigned char*)&sprite_attr, sizeof(sprite_attr));
}


/**
 * @brief Get all the sprite attributes in one go, returning the VERA_SPRITE structure.
 * 
 * @param sprite The sprite id, a byte between 0 and 127.
 * @param sprite_attr A pointer to a VERA_SPRITE structure containing the sprite attributes to be returned.
 */
inline void vera_sprite_attributes_get(vera_sprite sprite, struct VERA_SPRITE *sprite_attr) {
    word sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3; // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    cx16_cpy_ram_from_vram(sprite_attr, 1, sprite_offset, sizeof(struct VERA_SPRITE));
}


/**
 * @brief Show all sprites.
 * 
 */
inline void vera_sprites_show() {
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE;
}


/**
 * @brief Hide all sprites.
 * 
 */
inline void vera_sprites_hide() {
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO &= ~VERA_SPRITES_ENABLE;
}


/**
 * @brief Switch collision detection on for all sprites.
 * 
 */
inline void vera_sprites_collision_on() {
    *VERA_IEN |= VERA_SPRITES_COLLISIONS;
}

/**
 * @brief Switch collision detection off for all sprites.
 * 
 */
inline void vera_sprites_collision_off() {
    *VERA_IEN &= ~VERA_SPRITES_COLLISIONS;
}


/**
 * @brief Returns if collission detection is on or off.
 * 
 * @return true collision detection is switched on.
 * @return false collision detection is switched off. 
 */
inline bool vera_sprite_is_collision() {
    return(bool)(*VERA_ISR & VERA_SPRITES_COLLISIONS);
}


/**
 * @brief Clear all collision detection grouping.
 * 
 */
inline void vera_sprite_collision_clear() {
    *VERA_ISR &= VERA_SPRITES_COLLISIONS;
}

/// VERA TILING

void vera_tile_area(vera_layer layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset) {

    dword mapbase = vera_mapbase_address[layer];
    byte shift = vera_layer_rowshift[layer];
    word rowskip = (word)1 << shift;
    hflip = vera_layer_hflip[hflip];
    vflip = vera_layer_vflip[vflip];
    offset = offset << 4;
    byte index_l = <tileindex;
    byte index_h = >tileindex;
    index_h |= hflip;
    index_h |= vflip;
    index_h |= offset;
    mapbase += ((word)y << shift);
    mapbase += (x << 1);
    for(byte r=0; r<h; r++) {
        vera_vram_data0_address(mapbase,VERA_INC_1);
        for(byte c=0; c<w; c++) {
            *VERA_DATA0 = index_l;
            *VERA_DATA0 = index_h;
        }
        mapbase += rowskip;
    }

}

/// @section vera_copy

// Copy block of memory (from VRAM to VRAM)
// Copies the values from the location pointed by src to the location pointed by dest.
// The method uses the VERA access ports 0 and 1 to copy data from and to in VRAM.
// - vdest: pointer to the location to copy to. Note that the address is a dword value!
// - vsrc: pointer to the location to copy from. Note that the address is a dword value!
// - num: The number of bytes to copy
void vera_cpy_vram_vram(dword vsrc, dword vdest, dword num ) {

    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <(<vsrc);
    *VERA_ADDRX_M = >(<vsrc);
    *VERA_ADDRX_H = <(>vsrc);
    *VERA_ADDRX_H |= VERA_INC_1;

    // Select DATA1
    *VERA_CTRL |= VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <(<vdest);
    *VERA_ADDRX_M = >(<vdest);
    *VERA_ADDRX_H = <(>vdest);
    *VERA_ADDRX_H |= VERA_INC_1;

    // Transfer the data efficiently, we make different loops for byte, word and dword size!
    if( >num == 0x0000 ) {
        if( >(<num) == 0x00 ) {
            // the size is only a byte, this is the fastest loop!
            byte c = <(<num);
            for(byte i=0; i<c; i++) {
                *VERA_DATA1 = *VERA_DATA0;
            }
        } else {
            // the size is a word.
            word c = <num;
            for(word i=0; i<c; i++) {
                *VERA_DATA1 = *VERA_DATA0;
            }
        } 
    } else {
        // the size is a dword.
        dword c = num;
        for(dword i=0; i<c; i++) {
            *VERA_DATA1 = *VERA_DATA0;
        }
    }
}

// Copy block of banked internal memory (256 banks at A000-BFFF) to VERA VRAM.
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vdest: absolute address in VERA VRAM
// - bsrc: absolute address in the banked RAM of the CX16
// - num: dword of the number of bytes to copy
// Note: This function can switch RAM bank during copying to copy data from multiple RAM banks.
void vera_cpy_bank_vram(dword bsrc, dword vdest, dword num ) {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <(<vdest);
    *VERA_ADDRX_M = >(<vdest);
    *VERA_ADDRX_H = <(>vdest);
    *VERA_ADDRX_H |= VERA_INC_1;

    byte bank = (byte)(((((word)<(>bsrc)<<8)|>(<bsrc))>>5)+((word)<(>bsrc)<<3));

    byte* addr = (byte*)((<bsrc)&0x1FFF); // strip off the top 3 bits, which are representing the bank of the word!
    addr += 0xA000;
    cx16_bram_bank_set(bank); // select the bank
    for(dword i=0; i<num; i++) {
        if(addr == 0xC000) {
            bank++;
            cx16_bram_bank_set(bank); // select the bank
            addr = (byte*)0xA000;
        }
        *VERA_DATA0 = *addr;
        addr++;
    }
}
