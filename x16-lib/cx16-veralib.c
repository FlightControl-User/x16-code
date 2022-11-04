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
#include <cx16-veralib.h>



// --- VERA function encapsulation ---

// --- VERA layer management ---


// --- VERA addressing ---

char* vera_address_to_ptr( unsigned long address ) {
    return (char*)WORD0(address);
}

char vera_address_to_bank( unsigned long address ) {
    return BYTE2(address);
}

/**
 * @brief Configure data port 0 of the vera using bank and offset.
 *
 * @param bank The 8 bit bank of the vera to set.
 * @param offset The 16 bit offset of the vera to set.
 * @param inc_dec The vera increment/decrement enum.
 */
void vera_vram_data0_bank_offset(vram_bank_t bank, vram_offset_t offset, enum vera_inc_dec inc_dec) {
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
void vera_vram_data1_bank_offset(vram_bank_t bank, vram_offset_t offset, enum vera_inc_dec inc_dec) {
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
void vera_vram_data0_address(unsigned long bankaddr, enum vera_inc_dec inc_dec) {
    vera_vram_data0_bank_offset( BYTE2(bankaddr), WORD0(bankaddr), inc_dec );
}

/**
 * @brief Configure data port 1 of the vera using an address structure.
 *
 * @param bankaddr The packed address containing the bank and offset, possibly aligned to x bytes in vera memory.
 * @param inc_dec The vera increment/decrement enum.
 */
void vera_vram_data1_address(unsigned long bankaddr, enum vera_inc_dec inc_dec) {
    vera_vram_data1_bank_offset( BYTE2(bankaddr), WORD0(bankaddr), inc_dec );
}


/// @section VERA DISPLAY MANAGEMENT

/**
 * @brief Disable all scaling of the vera display.
 *
 */
void vera_display_set_scale_none() {
    *VERA_DC_HSCALE = 128;
    *VERA_DC_VSCALE = 128;
}

/**
 * @brief Double scaling of the vera display.
 * The characters and graphics will work at a 320x240 resolution.
 *
 */
void vera_display_set_scale_double() {
    *VERA_DC_HSCALE = 64;
    *VERA_DC_VSCALE = 64;
}

/**
 * @brief Triple scaling of the vera display.
 * Never tried this. TODO.
 *
 */
void vera_display_set_scale_triple() {
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
    for(char s=1;s<=3;s++) {
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
    for(char s=1;s<=3;s++) {
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
 * @brief Set the border color of the vera display.
 *
 * @return void
 */
void vera_display_set_border_color(char color) {

    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_BORDER = color;
}


/**
 * @brief Set the horizontal start line of the vera display.
 *
 * @return void
 */
void vera_display_set_hstart(char start) {

    *VERA_CTRL |= VERA_DCSEL;
    *VERA_DC_HSTART = start;
}


/**
 * @brief Set the horizontal stop line of the vera display.
 *
 * @return void
 */
void vera_display_set_hstop(char stop) {

    *VERA_CTRL |= VERA_DCSEL;
    *VERA_DC_HSTOP = stop;
}


/**
 * @brief Set the vertical start line of the vera display.
 *
 * @return void
 */
void vera_display_set_vstart(char start) {

    *VERA_CTRL |= VERA_DCSEL;
    *VERA_DC_VSTART = start;
}


/**
 * @brief Set the vertical stop line of the vera display.
 *
 * @return void
 */
void vera_display_set_vstop(char stop) {

    *VERA_CTRL |= VERA_DCSEL;
    *VERA_DC_VSTOP = stop;
}



/**
 * @section VERA LAYER MANAGEMENT
 */

/**
 * @brief Set the configuration of the layer.
 *
 * @param config Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
 */
void vera_layer0_set_config(char config) {
    *VERA_L0_CONFIG = config;
}

void vera_layer1_set_config(char config) {
    *VERA_L1_CONFIG = config;
}

/**
 * @brief Get the configuration of the layer.
 *
 * @return vera_config Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
 */
vera_config vera_layer0_get_config() {
    return *VERA_L0_CONFIG;
}

vera_config vera_layer1_get_config() {
    return *VERA_L1_CONFIG;
}

/**
 * @brief Set the configuration of the layer text color mode.
 *
 * @param color_mode Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
 */
void vera_layer0_set_text_color_mode(vera_color_mode color_mode) {
    *VERA_L0_CONFIG &= ~VERA_LAYER_CONFIG_256C;
    *VERA_L0_CONFIG |= color_mode;
}

void vera_layer1_set_text_color_mode(vera_color_mode color_mode) {
    *VERA_L1_CONFIG &= ~VERA_LAYER_CONFIG_256C;
    *VERA_L1_CONFIG |= color_mode;
}


/**
 * @brief Set the configuration of layer 0 to bitmap mode.
 */
void vera_layer0_set_bitmap_mode() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_CONFIG_MODE_BITMAP;
    *VERA_L0_CONFIG |= VERA_LAYER_CONFIG_MODE_BITMAP;
}

/**
 * @brief Set the configuration of layer 1 to bitmap mode.
 */
void vera_layer1_set_bitmap_mode() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_CONFIG_MODE_BITMAP;
    *VERA_L1_CONFIG |= VERA_LAYER_CONFIG_MODE_BITMAP;
}


/**
 * @brief Set the configuration of the layer 0 to tilemap mode.
 */
void vera_layer0_set_tilemap_mode() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_CONFIG_MODE_BITMAP;
    *VERA_L0_CONFIG |= VERA_LAYER_CONFIG_MODE_TILE;
}

/**
 * @brief Set the configuration of the layer 1 to tilemap mode.
 */
void vera_layer1_set_tilemap_mode() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_CONFIG_MODE_BITMAP;
    *VERA_L1_CONFIG |= VERA_LAYER_CONFIG_MODE_TILE;
}


/**
 * @brief Set the map width of the layer to 32 characters.
 */
void vera_layer0_set_width_32() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_WIDTH_MASK;
    *VERA_L0_CONFIG |= VERA_LAYER_WIDTH_32;
}

void vera_layer1_set_width_32() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_WIDTH_MASK;
    *VERA_L1_CONFIG |= VERA_LAYER_WIDTH_32;
}

/**
 * @brief Set the map width of the layer to 64 characters.
 */
void vera_layer0_set_width_64() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_WIDTH_MASK;
    *VERA_L0_CONFIG |= VERA_LAYER_WIDTH_64;
}

void vera_layer1_set_width_64() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_WIDTH_MASK;
    *VERA_L1_CONFIG |= VERA_LAYER_WIDTH_64;
}

/**
 * @brief Set the map width of the layer to 128 characters.
 */
void vera_layer0_set_width_128() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_WIDTH_MASK;
    *VERA_L0_CONFIG |= VERA_LAYER_WIDTH_128;
}

void vera_layer1_set_width_128() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_WIDTH_MASK;
    *VERA_L1_CONFIG |= VERA_LAYER_WIDTH_128;
}

/**
 * @brief Set the map width of the layer to 256 characters.
 */
void vera_layer0_set_width_256() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_WIDTH_MASK;
    *VERA_L0_CONFIG |= VERA_LAYER_WIDTH_256;
}

void vera_layer1_set_width_256() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_WIDTH_MASK;
    *VERA_L1_CONFIG |= VERA_LAYER_WIDTH_256;
}

/**
 * @brief Set the map height of the layer to 32 characters.
 */
void vera_layer0_set_height_32() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_HEIGHT_MASK;
    *VERA_L0_CONFIG |= VERA_LAYER_HEIGHT_32;
}

void vera_layer1_set_height_32() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_HEIGHT_MASK;
    *VERA_L1_CONFIG |= VERA_LAYER_HEIGHT_32;
}

/**
 * @brief Set the map height of the layer to 64 characters.
 */
void vera_layer0_set_height_64() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_HEIGHT_MASK;
    *VERA_L0_CONFIG |= VERA_LAYER_HEIGHT_64;
}

void vera_layer1_set_height_64() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_HEIGHT_MASK;
    *VERA_L1_CONFIG |= VERA_LAYER_HEIGHT_64;
}

/**
 * @brief Set the map height of the layer to 128 characters.
 */
void vera_layer0_set_height_128() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_HEIGHT_MASK;
    *VERA_L0_CONFIG |= VERA_LAYER_HEIGHT_128;
}

void vera_layer1_set_height_128() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_HEIGHT_MASK;
    *VERA_L1_CONFIG |= VERA_LAYER_HEIGHT_128;
}




/**
 * @brief Set the map height of the layer to 256 characters.
 */
void vera_layer0_set_height_256() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_HEIGHT_MASK;
    *VERA_L0_CONFIG |= VERA_LAYER_HEIGHT_256;
}

void vera_layer1_set_height_256() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_HEIGHT_MASK;
    *VERA_L1_CONFIG |= VERA_LAYER_HEIGHT_256;
}

/**
 * @brief Set the map width of layer 0.
 */
void vera_layer0_set_width(char mapwidth) {
    *VERA_L0_CONFIG &= ~VERA_LAYER_WIDTH_MASK;
    *VERA_L0_CONFIG |= mapwidth;
    char index = (mapwidth>>4);
}

/**
 * @brief Set the map width of layer 1.
 */
void vera_layer1_set_width(char mapwidth) {
    *VERA_L1_CONFIG &= ~VERA_LAYER_WIDTH_MASK;
    *VERA_L1_CONFIG |= mapwidth;
}

/**
 * @brief Set the map height of layer 0.
 */
void vera_layer0_set_height(char mapheight) {
    *VERA_L0_CONFIG &= ~VERA_LAYER_HEIGHT_MASK; 
    *VERA_L0_CONFIG |= mapheight;
}

/**
 * @brief Set the map height of layer 1.
 */
void vera_layer1_set_height(char mapheight) {
    *VERA_L1_CONFIG &= ~VERA_LAYER_HEIGHT_MASK;
    *VERA_L1_CONFIG |= mapheight;
}



/**
 * @brief Get the map width of the layer.
 *
 * @return vera_width
 */
vera_width vera_layer0_get_width() {
    return VERA_LAYER_WIDTH[ (*VERA_L0_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4];
}

vera_width vera_layer1_get_width() {
    return VERA_LAYER_WIDTH[ (*VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4];
}


/**
 * @brief Get the map width of the layer.
 *
 * @return vera_height
 */
vera_height vera_layer0_get_height() {
    return VERA_LAYER_HEIGHT[ (*VERA_L0_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6];
}

vera_height vera_layer1_get_height() {
    return VERA_LAYER_HEIGHT[ (*VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6];
}


/**
 * @brief Set the color depth of the layer in bit per pixel (BPP) to 1.
 */
void vera_layer0_set_color_depth_1BPP() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *VERA_L0_CONFIG |= VERA_LAYER_COLOR_DEPTH_1BPP;
}

void vera_layer1_set_color_depth_1BPP() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *VERA_L1_CONFIG |= VERA_LAYER_COLOR_DEPTH_1BPP;
}

/**
 * @brief Set the color depth of the layer in bit per pixel (BPP) to 2.
 */
void vera_layer0_set_color_depth_2BPP() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *VERA_L0_CONFIG |= VERA_LAYER_COLOR_DEPTH_2BPP;
}

void vera_layer1_set_color_depth_2BPP() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *VERA_L1_CONFIG |= VERA_LAYER_COLOR_DEPTH_2BPP;
}


/**
 * @brief Set the color depth of the layer in bit per pixel (BPP) to 4.
 */
void vera_layer0_set_color_depth_4BPP() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *VERA_L0_CONFIG |= VERA_LAYER_COLOR_DEPTH_4BPP;
}

void vera_layer1_set_color_depth_4BPP() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *VERA_L1_CONFIG |= VERA_LAYER_COLOR_DEPTH_4BPP;
}


/**
 * @brief Set the color depth of the layer in bit per pixel (BPP) to 8.
 */
void vera_layer0_set_color_depth_8BPP() {
    *VERA_L0_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *VERA_L0_CONFIG |= VERA_LAYER_COLOR_DEPTH_8BPP;
}

void vera_layer1_set_color_depth_8BPP() {
    *VERA_L1_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *VERA_L1_CONFIG |= VERA_LAYER_COLOR_DEPTH_8BPP;
}


/**
 * @brief Set the color depth of layer 0 in bit per pixel (BPP).
 */
void vera_layer0_set_color_depth(char bpp) {
    *VERA_L0_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *VERA_L0_CONFIG |= bpp;
}

/**
 * @brief Set the color depth of layer 1 in bit per pixel (BPP).
 */
void vera_layer1_set_color_depth(char bpp) {
    *VERA_L1_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *VERA_L1_CONFIG |= bpp;
}

/**
 * @brief Get the color depth of the layer.
 *
 * @return vera_color_depth 0 = 1 color, 1 = 2 colors, 2 = 4 colors or 3 = 8 colors.
 */
vera_color_depth vera_layer0_get_color_depth() {
    return (*VERA_L0_CONFIG & VERA_LAYER_COLOR_DEPTH_MASK);
}

vera_color_depth vera_layer1_get_color_depth() {
    return (*VERA_L1_CONFIG & VERA_LAYER_COLOR_DEPTH_MASK);
}

/**
 * @brief Enable the layer 0 to be displayed on the screen.
 */
void vera_layer0_show() {
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO |= VERA_LAYER0_ENABLE;
}

/**
 * @brief Enable the layer 1 to be displayed on the screen.
 */
void vera_layer1_show() {
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO |= VERA_LAYER1_ENABLE;
}


/**
 * @brief Hide the layer 0 to be displayed from the screen.
 */
void vera_layer0_hide() {
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO &= ~VERA_LAYER0_ENABLE;
}

/**
 * @brief Hide the layer 1 to be displayed from the screen.
 */
void vera_layer1_hide() {
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO &= ~VERA_LAYER1_ENABLE;
}


/**
 * @brief Is the layer 0 shown on the screen?
 * 
 * @return vera_layer_visible 1 if layer is displayed on the screen, 0 if not.
 */
vera_layer_visible vera_layer0_is_visible() {
    *VERA_CTRL &= ~VERA_DCSEL;
    return *VERA_DC_VIDEO & VERA_LAYER0_ENABLE;
}

/**
 * @brief Is the layer 1 shown on the screen?
 *
 * @return vera_layer_visible 1 if layer is displayed on the screen, 0 if not.
 */
vera_layer_visible vera_layer1_is_visible() {
    *VERA_CTRL &= ~VERA_DCSEL;
    return *VERA_DC_VIDEO & VERA_LAYER1_ENABLE;
}


/**
 * @brief Set the base of the map layer 0.
 *
 * @param mapbase_offset Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:9 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
 *
 */
void vera_layer0_set_mapbase(vera_bank mapbase_bank, vera_offset mapbase_offset) {
    *VERA_L0_MAPBASE = (mapbase_bank<<7) | (BYTE1(mapbase_offset)>>1);
}

/**
 * @brief Set the base of the map layer 1.
 *
 * @param mapbase_offset Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:9 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
 *
 */
void vera_layer1_set_mapbase(vera_bank mapbase_bank, vera_offset mapbase_offset) {
    *VERA_L1_MAPBASE = (mapbase_bank<<7) | (BYTE1(mapbase_offset)>>1);
}


/**
 * @brief Get the map base bank of the tiles for layer 0.
 *
 * @return vera_bank Bank in vera vram.
 */
vera_bank vera_layer0_get_mapbase_bank() {
    return (*VERA_L0_MAPBASE)>>7;
}


/**
 * @brief Get the map base bank of the tiles for layer 1.
 *
 * @return vera_bank Bank in vera vram.
 */
vera_bank vera_layer1_get_mapbase_bank() {
    return (*VERA_L1_MAPBASE)>>7;
}


/**
 * @brief Get the map base lower 16-bit address (offset) of the tiles for layer 0.
 *
 * @return vera_offset Offset in vera vram of the specified bank.
 */
vera_map_offset vera_layer0_get_mapbase_offset() {
    return MAKEWORD((*VERA_L0_MAPBASE)<<1,0);
}


/**
 * @brief Get the map base lower 16-bit address (offset) of the tiles for layer 1.
 *
 * @return vera_offset Offset in vera vram of the specified bank.
 */
vera_map_offset vera_layer1_get_mapbase_offset() {
    return MAKEWORD((*VERA_L1_MAPBASE)<<1,0);
}



/**
 * @brief Set the base of the tiles for the layer 0.
 *
 * @param tilebase_offset Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:11 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
 */
void vera_layer0_set_tilebase(vera_bank tilebase_bank, vera_offset tilebase_offset) {
    *VERA_L0_TILEBASE &= ~VERA_LAYER_TILEBASE_MASK; 
    *VERA_L0_TILEBASE |= ((tilebase_bank << 7) | BYTE1(tilebase_offset)>>1);
}

/**
 * @brief Set the base of the tiles for the layer 1.
 *
 * @param tilebase_offset Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:11 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
 */
void vera_layer1_set_tilebase(vera_bank tilebase_bank, vera_offset tilebase_offset) {
    *VERA_L1_TILEBASE &= ~VERA_LAYER_TILEBASE_MASK; 
    *VERA_L1_TILEBASE |= ((tilebase_bank << 7) | BYTE1(tilebase_offset)>>1);
}

/**
 * @brief Set the tileheight of layer 0.
 *
 * @param tileheight Specifies the height of each tile in the tile map.
 */
void vera_layer0_set_tile_height(char tileheight) {
    *VERA_L0_TILEBASE &= ~VERA_TILEBASE_HEIGHT_MASK; 
    *VERA_L0_TILEBASE |= tileheight;
}

/**
 * @brief Set the tileheight of layer 1.
 *
 * @param tileheight Specifies the height of each tile in the tile map.
 */
void vera_layer1_set_tile_height(char tileheight) {
    *VERA_L1_TILEBASE &= ~VERA_TILEBASE_HEIGHT_MASK;
    *VERA_L1_TILEBASE |= tileheight;
}

/**
 * @brief Set the tilewidth of layer 0.
 *
 * @param tilewidth Specifies the width of each tile in the tile map.
 */
void vera_layer0_set_tile_width(char tilewidth) {
    *VERA_L0_TILEBASE &= ~VERA_TILEBASE_WIDTH_MASK;
    *VERA_L0_TILEBASE |= tilewidth;
}

/**
 * @brief Set the tilewidth of layer 1.
 *
 * @param tilewidth Specifies the width of each tile in the tile map.
 */
void vera_layer1_set_tile_width(char tilewidth) {
    *VERA_L1_TILEBASE &= ~VERA_TILEBASE_WIDTH_MASK;
    *VERA_L1_TILEBASE |= tilewidth;
}


/**
 * @brief Get the base of the tiles for the layer 0.
 *
 * @return vera_tile_offset Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:11 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
 */
vera_tile_offset vera_layer0_get_tilebase() {
    return *VERA_L0_TILEBASE & VERA_LAYER_TILEBASE_MASK;
}

/**
 * @brief Get the base of the tiles for the layer 1.
 *
 * @return vera_tile_offset Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:11 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
 */
vera_tile_offset vera_layer1_get_tilebase() {
    return *VERA_L1_TILEBASE & VERA_LAYER_TILEBASE_MASK;
}




/**
 * @brief Scroll the horizontal (X) axis of the layer 0 visible area over the layer tile map area.
 *
 * @param scroll A value between 0 and 4096.
 */
void vera_layer0_set_horizontal_scroll(unsigned int scroll) {
    *VERA_L0_VSCROLL_L = BYTE0(scroll);
    *VERA_L0_VSCROLL_H = BYTE1(scroll);
}

/**
 * @brief Scroll the horizontal (X) axis of the layer 1 visible area over the layer tile map area.
 *
 * @param scroll A value between 0 and 4096.
 */
void vera_layer1_set_horizontal_scroll(unsigned int scroll) {
    *VERA_L1_VSCROLL_L = BYTE0(scroll);
    *VERA_L1_VSCROLL_H = BYTE1(scroll);
}


/**
 * @brief Scroll the vertical (Y) axis of the layer 0 visible area over the layer tile map area.
 *
 * @param scroll A value between 0 and 4096.
 */
void vera_layer0_set_vertical_scroll(unsigned int scroll) {
    *VERA_L0_VSCROLL_L = BYTE0(scroll);
    *VERA_L0_VSCROLL_H = BYTE1(scroll);
}

/**
 * @brief Scroll the vertical (Y) axis of the layer 1 visible area over the layer tile map area.
 *
 * @param scroll A value between 0 and 4096.
 */
void vera_layer1_set_vertical_scroll(unsigned int scroll) {
    *VERA_L1_VSCROLL_L = BYTE0(scroll);
    *VERA_L1_VSCROLL_H = BYTE1(scroll);
}


// Get the bit shift value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
unsigned char vera_layer0_get_rowshift() {
    // *VERA_L1_CONFIG &= ~VERA_LAYER_WIDTH_MASK;
    // *VERA_L1_CONFIG |= mapwidth;
    // char index = (mapwidth>>4);
    // vera_layer_rowshift[1] = 6+index;
    // vera_layer_rowskip[1] = skip[index];
    return (((*VERA_L0_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4)+6;
}

// Get the bit shift value required to skip a whole line fast.
// Lowest is 32 characters * 2 = shift minimally with 6. Then add the value of with map
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
unsigned char vera_layer1_get_rowshift() {
    return (((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4)+6;
    // return vera_layer_rowshift[1];
}

// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
unsigned int vera_layer0_get_rowskip() {
    return VERA_LAYER_SKIP[((*VERA_L0_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4];
    // return vera_layer_rowskip[0];
}

// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
unsigned int vera_layer1_get_rowskip() {
    return VERA_LAYER_SKIP[((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4];
}




void vera_layer0_mode_tile(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char bpp ) {

    vera_layer0_set_color_depth(bpp);
    vera_layer0_set_width(mapwidth);
    vera_layer0_set_height(mapheight);

    // mapbase
    vera_layer0_set_mapbase(mapbase_bank, mapbase_offset);

    // tilebase
    vera_layer0_set_tilebase(tilebase_bank, tilebase_offset);

    vera_layer0_set_tile_width(tilewidth);
    vera_layer0_set_tile_height(tileheight);
}

void vera_layer1_mode_tile(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char bpp ) {

    vera_layer1_set_color_depth(bpp);
    vera_layer1_set_width(mapwidth);
    vera_layer1_set_height(mapheight);

    // mapbase
    vera_layer1_set_mapbase(mapbase_bank, mapbase_offset);

    // tilebase
    vera_layer1_set_tilebase(tilebase_bank, tilebase_offset);

    vera_layer1_set_tile_width(tilewidth);
    vera_layer1_set_tile_height(tileheight);
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
void vera_layer0_mode_text(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char color_mode) {
    vera_layer0_mode_tile( mapbase_bank, mapbase_offset, tilebase_bank, tilebase_offset, mapwidth, mapheight, tilewidth, tileheight, VERA_LAYER_COLOR_DEPTH_1BPP);
    vera_layer0_set_text_color_mode( color_mode );
}

void vera_layer1_mode_text(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char color_mode) {
    vera_layer1_mode_tile( mapbase_bank, mapbase_offset, tilebase_bank, tilebase_offset, mapwidth, mapheight, tilewidth, tileheight, VERA_LAYER_COLOR_DEPTH_1BPP);
    vera_layer1_set_text_color_mode( color_mode );
}

/**
 * @brief Resets the vera back to default settings.
 * Show Layer 1, hide layer 0.
 * Map from bank 1, offset 0xB000, tile from bank 1, offset 0xF000.
 * Mapbase width 128, mapbase height 64.
 * Tilebase width 8, tilebase height 8.
 * Color depth 4 bpp.
 * Color mode 16C.
 */
void vera_layers_reset() 
{
    vera_layer1_mode_tile( 1, 0xB000, 1, 0XF000, VERA_LAYER_WIDTH_128, VERA_LAYER_HEIGHT_64, VERA_TILEBASE_WIDTH_8, VERA_SPRITE_HEIGHT_8, VERA_LAYER_COLOR_DEPTH_1BPP);
    vera_layer1_set_text_color_mode( VERA_LAYER_CONFIG_16C );
    vera_layer1_show();
    vera_layer0_hide();
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
void vera_layer0_mode_bitmap(char tilebase_bank, unsigned int tilebase_offset, char tilewidth, char color_depth ) {

    *VERA_L0_CONFIG = *VERA_L0_CONFIG | VERA_LAYER_CONFIG_MODE_BITMAP;

    // tilebase
    vera_layer0_set_tile_width(tilewidth);
    vera_layer0_set_tilebase(tilebase_bank, tilebase_offset);
    vera_layer0_set_color_depth(color_depth);
    if(tilewidth==VERA_TILEBASE_WIDTH_8) {
        vera_display_set_scale_double();
    }
}   
 


void vera_layer1_mode_bitmap(char tilebase_bank, unsigned int tilebase_offset, char tilewidth, char color_depth ) {

    *VERA_L1_CONFIG = *VERA_L1_CONFIG | VERA_LAYER_CONFIG_MODE_BITMAP;

    // tilebase
    vera_layer1_set_tile_width(tilewidth);
    vera_layer1_set_tilebase(tilebase_bank, tilebase_offset);
    vera_layer1_set_color_depth(color_depth);
    if(tilewidth==VERA_TILEBASE_WIDTH_8) {
        vera_display_set_scale_double();
    }
}

// --- SPRITE STRUCTURE ---


// --- SPRITE FUNCTIONS ---

/// The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
vera_sprite_offset vera_sprite_get_offset(vera_sprite_id sprite_id) {
    return WORD0(VERA_SPRITE_ATTR)+(((unsigned int)sprite_id) << 3);
}

/// The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
vera_sprite_id vera_sprite_get_id(vera_sprite_offset sprite_offset) {
    return BYTE0((sprite_offset - WORD0(VERA_SPRITE_ATTR)) >> 3);
}

/// Obtain the offset of the image, aligned with the sprite control data structure.
vera_sprite_image_offset vera_sprite_get_image_offset(vera_bank bank, vera_offset offset) {
    vera_sprite_image_offset sprite_image_offset = offset >> 5;
    sprite_image_offset |= ((unsigned int)bank << 11);
    return sprite_image_offset;
}

/// Obtain the offset of the image, aligned with the sprite control data structure.
vera_sprite_image_offset vera_sprite_get_vram(vera_bank bank, vera_offset offset) {
    vera_sprite_image_offset sprite_image_offset = offset >> 5;
    sprite_image_offset |= ((unsigned int)bank << 11);
    return sprite_image_offset;
}

void vera_sprite_set_image_offset(vera_sprite_offset sprite_offset, vera_sprite_image_offset sprite_image_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset, vera_inc_1);
    *VERA_DATA0 = BYTE0(sprite_image_offset);
    *VERA_DATA0 = BYTE1(sprite_image_offset);
}

void vera_sprite_address(vera_sprite_offset sprite_offset, unsigned long address) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset, vera_inc_1);
    *VERA_DATA0 = BYTE0(WORD0(address)>>5);
    *VERA_DATA0 = (BYTE1(WORD0(address))>>5)|(BYTE0(WORD1(address))<<3);
}

/**
 * @brief Set a sprite offset in vera memory.
 *
 * @param sprite_offset The sprite offset in vera ram.
 * @param bank The bank in vera memory.
 * @param offset The offset in vera memory.
 */
void vera_sprite_bank_offset(vera_sprite_offset sprite_offset, vera_bank bank, vera_offset offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset, vera_inc_1);
    *VERA_DATA0 = BYTE0((unsigned int)offset>>5);
    *VERA_DATA0 = ((BYTE1((unsigned int)offset))>>5)|(bank<<3);
}

/**
 * @brief Set a sprite position on the display.
 * Note that the x and y coordinates are expressed in 2s complement, so a negative position will hide a sprite on the top or left border!
 *
 * @param sprite_offset The sprite offset in vera ram.
 * @param x The x coordinate.
 * @param y The y coordinate.
 */
void vera_sprite_set_xy(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+2, vera_inc_1);
    *VERA_DATA0 = BYTE0(x);
    *VERA_DATA0 = BYTE1(x);
    *VERA_DATA0 = BYTE0(y);
    *VERA_DATA0 = BYTE1(y);
}

vera_sprite_coordinate vera_sprite_x_get(vera_sprite_offset sprite_offset) 
{
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+2, vera_inc_1);
    unsigned char lo = *VERA_DATA0;
    unsigned char hi = *VERA_DATA0;
    return (vera_sprite_coordinate)MAKEWORD(hi, lo);
}

vera_sprite_coordinate vera_sprite_y_get(vera_sprite_offset sprite_offset) 
{
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+4, vera_inc_1);
    unsigned char lo = *VERA_DATA0;
    unsigned char hi = *VERA_DATA0;
    return (vera_sprite_coordinate)MAKEWORD(hi, lo);
}

/**
 * @brief Set a sprite position on the display and animate the sprite shape.
 * Note that the x and y coordinates are expressed in 2s complement, so a negative position will hide a sprite on the top or left border!
 *
 * @param sprite_offset The sprite offset in vera ram.
 * @param x The x coordinate.
 * @param y The y coordinate.
 */
void vera_sprite_set_xy_and_image_offset(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y, vera_sprite_image_offset sprite_image_offset) 
{
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset, vera_inc_1);
    *VERA_DATA0 = BYTE0(sprite_image_offset);
    *VERA_DATA0 = BYTE1(sprite_image_offset);
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+2, vera_inc_1);
    *VERA_DATA0 = BYTE0(x);
    *VERA_DATA0 = BYTE1(x);
    *VERA_DATA0 = BYTE0(y);
    *VERA_DATA0 = BYTE1(y);
}


/**
 * @brief Set the color depth of a sprite to 4 bits per pixel (16 color).
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_4bpp(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+1, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_8BPP;
}


/**
 * @brief Set the color depth of a sprite to 8 bits per pixel (256 color).
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_8bpp(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+1, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 | VERA_SPRITE_8BPP;
}


/**
 * @brief Set the sprite bits per pixel.
 *
 * @param sprite_offset The sprite offset in vera ram.
 * @param bpp Bits per pixel of the sprite graphics color depth, which can be a value of 4 or 8.
 */
void vera_sprite_bpp(vera_sprite_offset sprite_offset, char bpp) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+1, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_8BPP; 
    *VERA_DATA0 |= bpp;
}

vera_sprite_bpp_t vera_sprite_bpp_get(vera_sprite_offset sprite_offset) 
{
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+1, vera_inc_0);
    return *VERA_DATA0 & VERA_SPRITE_8BPP;
}

/**
 * @brief Flip the sprite horizontally.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_hflip_on(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 | VERA_SPRITE_HFLIP;
}


/**
 * @brief Put the sprite back in normal horizontal form.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_hflip_off(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HFLIP;
}


void vera_sprite_hflip(vera_sprite_offset sprite_offset, char hflip) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = (*VERA_DATA0 & ~VERA_SPRITE_HFLIP); 
    *VERA_DATA0 |= hflip;
}


/**
 * @brief Flip the sprite vertically.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_vflip_on(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 | VERA_SPRITE_VFLIP;
}


/**
 * @brief Put the sprite back in normal vertical form.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_vflip_off(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_VFLIP;
}

void vera_sprite_vflip(vera_sprite_offset sprite_offset, char vflip) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = (*VERA_DATA0 & ~VERA_SPRITE_VFLIP);
    *VERA_DATA0 |= vflip;
}

/**
 * @brief Hide a sprite.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_disable(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK;
}


/**
 * @brief Position the z depth of the sprite between the background and layer 0.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_zdepth_between_background_and_layer0(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0;
}


/**
 * @brief Position the z depth of the sprite between layer 0 and layer 1.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_zdepth_between_layer0_and_layer1(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1;
}


/**
 * @brief Position the z depth of the sprite in front of everything.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_zdepth_in_front(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_IN_FRONT;
}

void vera_sprite_zdepth(vera_sprite_offset sprite_offset, unsigned char zdepth) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | zdepth;
}


/**
 * @brief Set the width of the sprite to 8 pixels.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_width_8(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_8;
}


/**
 * @brief Set the width of the sprite to 16 pixels.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_width_16(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_16;
}


/**
 * @brief Set the width of the sprite to 32 pixels.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_width_32(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_32;
}


/**
 * @brief Set the width of the sprite to 64 pixels.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_width_64(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_64;
}

void vera_sprite_width(vera_sprite_offset sprite_offset, char width) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK;
    *VERA_DATA0 |= width;
}

vera_sprite_width_t vera_sprite_width_get(vera_sprite_offset sprite_offset) 
{
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    return *VERA_DATA0 & VERA_SPRITE_WIDTH_MASK;
}

vera_sprite_width_t vera_sprite_width_get_bitmap(char width) 
{
    switch(width)  {
        case 8:
            return VERA_SPRITE_WIDTH_8;
        case 16:
            return VERA_SPRITE_WIDTH_16;
        case 32:
            return VERA_SPRITE_WIDTH_32;
        case 64:
            return VERA_SPRITE_WIDTH_64;
        other:
    }
    return 0;
}

unsigned char vera_sprite_width_get_value(vera_sprite_width_t width) 
{
    switch(width)  {
        case VERA_SPRITE_WIDTH_8:
            return 8;
        case VERA_SPRITE_WIDTH_16:
            return 16;
        case VERA_SPRITE_WIDTH_32:
            return 32;
        case VERA_SPRITE_WIDTH_64:
            return 64;
        other:
    }
    return 0;
}

vera_sprite_height_t vera_sprite_height_get_bitmap(char height) 
{
    switch(height) {
        case 8:
            return VERA_SPRITE_HEIGHT_8;
        case 16:
            return VERA_SPRITE_HEIGHT_16;
        case 32:
            return VERA_SPRITE_HEIGHT_32;
        case 64:
            return VERA_SPRITE_HEIGHT_64;
        other:
    }
    return 0;
}

unsigned char vera_sprite_height_get_value(vera_sprite_height_t height) 
{
    switch(height) {
        case VERA_SPRITE_HEIGHT_8:
            return 8;
        case VERA_SPRITE_HEIGHT_16:
            return 16;
        case VERA_SPRITE_HEIGHT_32:
            return 32;
        case VERA_SPRITE_HEIGHT_64:
            return 64;
        other:
    }
    return 0;
}

vera_sprite_zdepth_t vera_sprite_zdepth_get_bitmap(char zdepth) 
{
    switch(zdepth) {
        case 0:
            return VERA_SPRITE_ZDEPTH_DISABLED;
        case 1:
            return VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0;
        case 2:
            return VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1;
        case 3:
            return VERA_SPRITE_ZDEPTH_IN_FRONT;
        other:
    }
    return 0;
}

unsigned char vera_sprite_zdepth_get_value(vera_sprite_zdepth_t zdepth) 
{
    switch(zdepth) {
        case VERA_SPRITE_ZDEPTH_DISABLED:
            return 0;
        case VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0:
            return 1;
        case VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1:
            return 2;
        case VERA_SPRITE_ZDEPTH_IN_FRONT:
            return 3;
        other:
    }
    return 0;
}

vera_sprite_hflip_t vera_sprite_hflip_get_bitmap(char hflip) 
{
    switch(hflip) {
        case 0:
            return VERA_SPRITE_NFLIP;
        case 1:
            return VERA_SPRITE_HFLIP;
        other:
    }
    return 0;
}

unsigned char vera_sprite_hflip_get_value(vera_sprite_hflip_t hflip) 
{
    switch(hflip) {
        case VERA_SPRITE_NFLIP:
            return 0;
        case VERA_SPRITE_HFLIP:
            return 1;
        other:
    }
    return 0;
}

vera_sprite_vflip_t vera_sprite_vflip_get_bitmap(char vflip) 
{
    switch(vflip) {
        case 0:
            return VERA_SPRITE_NFLIP;
        case 1:
            return VERA_SPRITE_VFLIP;
        other:
    }
    return 0;
}

unsigned char vera_sprite_vflip_get_value(vera_sprite_vflip_t vflip) 
{
    switch(vflip) {
        case VERA_SPRITE_NFLIP:
            return 0;
        case VERA_SPRITE_VFLIP:
            return 1;
        other:
    }
    return 0;
}

vera_sprite_bpp_t vera_sprite_bpp_get_bitmap(char bpp) 
{
    switch(bpp) {
        case 4:
            return VERA_SPRITE_4BPP;
        case 8:
            return VERA_SPRITE_8BPP;
        other:
    }
    return 0;
}

unsigned char vera_sprite_bpp_get_value(vera_sprite_bpp_t bpp) 
{
    switch(bpp) {
        case VERA_SPRITE_4BPP:
            return 4;
        case VERA_SPRITE_8BPP:
            return 8;
        other:
    }
    return 0;
}

/**
 * @brief Set the height of the sprite to 8 pixels.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_height_8(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_8;
}


/**
 * @brief Set the height of the sprite to 16 pixels.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_height_16(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_16;
}


/**
 * @brief Set the height of the sprite to 32 pixels.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_height_32(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_32;
}

/**
 * @brief Set the height of the sprite to 64 pixels.
 *
 * @param sprite_offset The sprite offset in vera ram.
 */
void vera_sprite_height_64(vera_sprite_offset sprite_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_64;
}

void vera_sprite_height(vera_sprite_offset sprite_offset, char height) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK;
    *VERA_DATA0 |= height;
}

vera_sprite_height_t vera_sprite_height_get(vera_sprite_offset sprite_offset) 
{
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    return *VERA_DATA0 & VERA_SPRITE_HEIGHT_MASK;
}

/**
 * @brief Set the palette offset of the sprite.
 *
 * @param sprite_offset The sprite offset in vera ram.
 * @param palette_offset The palette offset, a byte between 0 and 15.
 */
void vera_sprite_palette_offset(vera_sprite_offset sprite_offset, vera_palette_offset palette_offset) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK; 
    *VERA_DATA0 |= palette_offset;
}

/**
 * @brief Set the collision mask for a sprite.
 *
 * @param sprite_offset The sprite offset in vera ram.
 * @param mask The collision mask, a byte containing 4 bits in the higher tetrade indicating the groups for which collision detection will be performed.
 */
void vera_sprite_set_collision_mask(vera_sprite_offset sprite_offset, vera_collision_mask mask) {
    vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0);
    *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_COLLISION_MASK;
    *VERA_DATA0 |= mask;
}


/**
 * @brief Set all the sprite attributes in one go using the struct VERA_SPRITE.
 * When configuring a lot of attributes for a sprite, this is faster than calling each individual function.
 *
 * @param sprite_offset The sprite offset in vera ram.
 * @param sprite_attr The sprite attributes contained in a VERA_SPRITE structure.
 */
void vera_sprite_attributes_set(vera_sprite_offset sprite_offset, struct VERA_SPRITE sprite_attr) {
    memcpy_vram_ram(1, (unsigned int)sprite_offset, (unsigned char*)&sprite_attr, sizeof(sprite_attr));
}


/**
 * @brief Get all the sprite attributes in one go, returning the VERA_SPRITE structure.
 *
 * @param sprite_offset The sprite offset in vera ram.
 * @param sprite_attr A pointer to a VERA_SPRITE structure containing the sprite attributes to be returned.
 */
void vera_sprite_attributes_get(vera_sprite_offset sprite_offset, struct VERA_SPRITE *sprite_attr) {
    memcpy_ram_vram((ram_ptr_t)sprite_attr, 1, sprite_offset, sizeof(struct VERA_SPRITE));
}


/**
 * @brief Show all sprites.
 *
 */
void vera_sprites_show() {
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE;
}


/**
 * @brief Hide all sprites.
 *
 */
void vera_sprites_hide() {
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO &= ~VERA_SPRITES_ENABLE;
}


/**
 * @brief Switch collision detection on for all sprites.
 *
 */
void vera_sprites_collision_on() {
    *VERA_IEN |= VERA_SPRITES_COLLISIONS;
}

/**
 * @brief Switch collision detection off for all sprites.
 *
 */
void vera_sprites_collision_off() {
    *VERA_IEN &= ~VERA_SPRITES_COLLISIONS;
}


/**
 * @brief Returns if collission detection is on or off.
 *
 * @return true collision detection is switched on.
 * @return false collision detection is switched off.
 */
char vera_sprite_is_collision() {
    return(char)(*VERA_ISR & VERA_SPRITES_COLLISIONS);
}


/**
 * @brief Returns the groups in collision.
 *
 * @return Groups in collision, which are the upper 4 bits of ISR.
 */
unsigned char vera_sprite_get_collision() {
    return(unsigned char)(*VERA_ISR & 0b11110000);
}


/**
 * @brief Clear all collision detection grouping.
 *
 */
void vera_sprite_collision_clear() {
    *VERA_ISR &= VERA_SPRITES_COLLISIONS;
}

