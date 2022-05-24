#ifndef __CX16_VERALIB_H__
#define __CX16_VERALIB_H__

/**
 * @file cx16-veralib.h
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Commander X16 vera library for the kickc compiler.
 * Commander X16 VERA (Versatile Embedded Retro Adapter) Video and Audio Processor
 * https://github.com/commanderx16/x16-docs/blob/master/VERA%20Programmer's%20Reference.md
 * @version 0.1
 * @date 2021-06-14
 *
 * @copyright Copyright (c) 2021
 *
 */


#include <cx16-vera.h>

/// vera increment / decrement enumeration to be used in @ref vera addressing.
enum vera_inc_dec {
    vera_inc_0 = 0,
    vera_inc_1 = 16,
    vera_inc_2 = 32,
    vera_inc_4 = 48,
    vera_inc_8 = 64,
    vera_inc_16 = 80,
    vera_inc_32 = 96,
    vera_inc_64 = 112,
    vera_inc_128 = 128,
    vera_inc_256 = 144,
    vera_inc_512 = 160,
    vera_inc_40 = 176,
    vera_inc_80 = 192,
    vera_inc_160 = 208,
    vera_inc_320 = 224,
    vera_inc_640 = 240,
    vera_dec_0 = 8,
    vera_dec_1 = 24,
    vera_dec_2 = 40,
    vera_dec_4 = 56,
    vera_dec_8 = 72,
    vera_dec_16 = 88,
    vera_dec_32 = 104,
    vera_dec_64 = 120,
    vera_dec_128 = 136,
    vera_dec_256 = 152,
    vera_dec_512 = 168,
    vera_dec_40 = 184,
    vera_dec_80 = 200,
    vera_dec_160 = 216,
    vera_dec_320 = 232,
    vera_dec_640 = 248
};

typedef struct VERA_SPRITE          vera_sprite_buffer_item_t;
typedef struct VERA_SPRITE          *vera_sprite_buffer_t;
typedef unsigned int                vera_sprite_buffer_index_t;

typedef char vera_bank; ///< Expresses a bank in vera memory.
typedef unsigned int vera_offset; ///< Expresses an offset in vera memory.
typedef char vera_scale; ///< Expresses a scale of the display.
typedef unsigned int vera_height; ///< Expresses a height.
typedef unsigned int vera_width; ///< Expresses a width.
typedef char vera_layer; ///< Expresses a layer of the vera display.
typedef char vera_config; ///< Expresses the configuration register value of the vera.
typedef char vera_color_mode; ///< Expresses the vera color mode.
typedef char vera_color_depth; ///< Expresses the vera color depth.
typedef char vera_layer_visible; ///< Expresses the visibility of a layer.
typedef unsigned int vera_map_offset; ///< Expresses the map base of a layer.
typedef unsigned int vera_tile_offset; ///< Expresses the tile base of a layer.
typedef char vera_forecolor; ///< Expresses the foreground color of the text.
typedef char vera_backcolor; ///< Expresses the background color of the text.
typedef char vera_textcolor; ///< Expresses the foreground and background color of the text.
typedef char vera_scroll; ///< Expresses a scroll position of a layer.
typedef unsigned char vera_sprite_id; ///< Expresses a sprite identifier.
typedef unsigned int vera_sprite_offset; ///< Expresses a sprite offset in vera memory.
typedef unsigned int vera_sprite_image_offset; ///< Expresses a sprite image offset in vera memory, aligned to 32 chars.
typedef signed int vera_sprite_coordinate; ///< Expresses a sprite coordinate or position on the display.
typedef char vera_palette_offset; ///< Expresses a palette offset, which is a number between 0 and 15.
typedef char vera_collision_mask; ///< Expresses the collision mask, with the lower 4 bits indicating the selection of the 4 groups to perform the collision detection.

/* inline */ void vera_vram_data0_address(unsigned long bankaddr, enum vera_inc_dec inc_dec);
/* inline */ void vera_vram_data1_address(unsigned long bankaddr, enum vera_inc_dec inc_dec);
/* inline */ void vera_vram_data0_bank_offset(vera_bank bank, vera_offset offset, enum vera_inc_dec inc_dec);
/* inline */ void vera_vram_data1_bank_offset(vera_bank bank, vera_offset offset, enum vera_inc_dec inc_dec);

/// --- VERA active display management ---

// #define vera_vram_data0_bank_offset(bank, offset, inc_dec) *VERA_CTRL &= ~VERA_ADDRSEL; *VERA_ADDRX_L = BYTE0(offset); *VERA_ADDRX_M = BYTE1(offset); *VERA_ADDRX_H = bank | inc_dec;



/* inline */ void vera_display_set_scale_none();
/* inline */ void vera_display_set_scale_double();
/* inline */ void vera_display_set_scale_triple();
vera_scale vera_display_get_hscale();
vera_scale vera_display_get_vscale();
vera_height vera_display_get_height();
vera_width vera_display_get_width();
/* inline */ void vera_display_set_border_color(char color);
/* inline */ void vera_display_set_hstart(char start);
/* inline */ void vera_display_set_hstop(char stop);
/* inline */ void vera_display_set_vstart(char start);
/* inline */ void vera_display_set_vstop(char stop);


/// --- VERA LAYERS ---

void vera_layers_reset();

void vera_layer0_mode_tile(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char bpp );
void vera_layer1_mode_tile(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char bpp );

void vera_layer0_mode_text(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char color_mode);
void vera_layer1_mode_text(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char color_mode);

void vera_layer0_mode_bitmap(char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char color_depth);
void vera_layer1_mode_bitmap(char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char color_depth);

/* inline */ void vera_layer0_set_mapbase(vera_bank mapbase_bank, vera_offset mapbase_offset);
/* inline */ void vera_layer1_set_mapbase(vera_bank mapbase_bank, vera_offset mapbase_offset);
/* inline */ void vera_layer0_set_tilebase(vera_bank tilebase_bank, vera_offset tilebase_offset);
/* inline */ void vera_layer1_set_tilebase(vera_bank tilebase_bank, vera_offset tilebase_offset);

/* inline */ void vera_layer0_set_bitmap_mode();
/* inline */ void vera_layer1_set_bitmap_mode();

/* inline */ void vera_layer0_set_tilemap_mode();
/* inline */ void vera_layer1_set_tilemap_mode();


/* inline */ void vera_layer0_set_tile_height(char tileheight);
/* inline */ void vera_layer1_set_tile_height(char tileheight);
/* inline */ void vera_layer0_set_tile_width(char tilewidth);
/* inline */ void vera_layer1_set_tile_width(char tilewidth);

/* inline */ void vera_layer0_set_config(vera_config config);
/* inline */ void vera_layer1_set_config(vera_config config);
vera_config vera_layer0_get_config();
vera_config vera_layer1_get_config();

void vera_layer0_set_text_color_mode(vera_color_mode color_mode);
void vera_layer1_set_text_color_mode(vera_color_mode color_mode);

/* inline */ void vera_layer0_set_width_32();
/* inline */ void vera_layer0_set_width_64();
/* inline */ void vera_layer0_set_width_128();
/* inline */ void vera_layer0_set_width_256();
/* inline */ void vera_layer1_set_width_32();
/* inline */ void vera_layer1_set_width_64();
/* inline */ void vera_layer1_set_width_128();
/* inline */ void vera_layer1_set_width_256();
/* inline */ void vera_layer0_set_width(char mapwidth);
/* inline */ void vera_layer1_set_width(char mapwidth);

/* inline */ void vera_layer0_set_height_32();
/* inline */ void vera_layer0_set_height_64();
/* inline */ void vera_layer0_set_height_128();
/* inline */ void vera_layer0_set_height_256();
/* inline */ void vera_layer1_set_height_32();
/* inline */ void vera_layer1_set_height_64();
/* inline */ void vera_layer1_set_height_128();
/* inline */ void vera_layer1_set_height_256();
/* inline */ void vera_layer0_set_height(char mapheight);
/* inline */ void vera_layer1_set_height(char mapheight);

/* inline */ unsigned int vera_layer0_get_width();
/* inline */ unsigned int vera_layer0_get_height();
/* inline */ unsigned int vera_layer1_get_width();
/* inline */ unsigned int vera_layer1_get_height();

/* inline */ void vera_layer0_set_color_depth_1BPP();
/* inline */ void vera_layer0_set_color_depth_2BPP();
/* inline */ void vera_layer0_set_color_depth_4BPP();
/* inline */ void vera_layer0_set_color_depth_8BPP();
/* inline */ char vera_layer0_get_color_depth();
/* inline */ void vera_layer1_set_color_depth_1BPP();
/* inline */ void vera_layer1_set_color_depth_2BPP();
/* inline */ void vera_layer1_set_color_depth_4BPP();
/* inline */ void vera_layer1_set_color_depth_8BPP();
/* inline */ char vera_layer1_get_color_depth();
/* inline */ void vera_layer0_set_color_depth(char bpp);
/* inline */ void vera_layer1_set_color_depth(char bpp);

  
/* inline */ void vera_layer0_show();
/* inline */ void vera_layer1_show();
/* inline */ void vera_layer0_hide();
/* inline */ void vera_layer1_show();
char vera_layer0_is_visible();
char vera_layer1_is_visible();

char vera_layer0_get_mapbase_bank();
unsigned int vera_layer0_get_mapbase_offset();
char vera_layer1_get_mapbase_bank();
unsigned int vera_layer1_get_mapbase_offset();

vera_tile_offset vera_layer0_get_tilebase();
vera_tile_offset vera_layer1_get_tilebase();

/* inline */ void vera_layer0_set_horizontal_scroll(unsigned int scroll);
/* inline */ void vera_layer1_set_horizontal_scroll(unsigned int scroll);
/* inline */ void vera_layer0_set_vertical_scroll(unsigned int scroll);
/* inline */ void vera_layer1_set_vertical_scroll(unsigned int scroll);

/* inline */ unsigned char vera_layer0_get_rowshift();
/* inline */ unsigned int vera_layer0_get_rowskip();
/* inline */ unsigned char vera_layer1_get_rowshift();
/* inline */ unsigned int vera_layer1_get_rowskip();

// --- SPRITES ---

/* inline */ vera_sprite_offset vera_sprite_get_offset(vera_sprite_id sprite_id);
/* inline */ vera_sprite_id vera_sprite_get_id(vera_sprite_offset sprite_offset);
/* inline */ vera_sprite_image_offset vera_sprite_get_image_offset(vera_bank bank, vera_offset offset);
/* inline */ void vera_sprite_set_image_offset(vera_sprite_offset sprite_offset, vera_sprite_image_offset sprite_image_offset);

/* inline */ void vera_sprite_address(vera_sprite_offset sprite_offset, unsigned long address);
/* inline */ void vera_sprite_bank_offset(vera_sprite_offset sprite_offset, vera_bank bank, vera_offset offfset);
/* inline */ void vera_sprite_set_xy(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y);
/* inline */ void vera_sprite_set_xy_and_image_offset(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y, vera_sprite_image_offset sprite_image_offset);
/* inline */ void vera_sprite_4bpp(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_8bpp(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_bpp(vera_sprite_offset sprite_offset, char bpp);

/* inline */ void vera_sprite_hflip_on(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_hflip_off(vera_sprite_offset sprite_offset);
void vera_sprite_hflip(vera_sprite_offset sprite_offset, char hflip);

/* inline */ void vera_sprite_vflip_on(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_vflip_off(vera_sprite_offset sprite_offset);
void vera_sprite_vflip(vera_sprite_offset sprite_offset, char vflip);

/* inline */ void vera_sprite_disable(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_zdepth_between_background_and_layer0(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_zdepth_between_layer0_and_layer1(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_zdepth_in_front(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_zdepth(vera_sprite_offset sprite_offset, unsigned char zdepth);
/* inline */ void vera_sprite_width_8(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_width_16(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_width_32(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_width_64(vera_sprite_offset sprite_offset);
void vera_sprite_width(vera_sprite_offset sprite_offset, char width);
/* inline */ void vera_sprite_height_8(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_height_16(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_height_32(vera_sprite_offset sprite_offset);
/* inline */ void vera_sprite_height_64(vera_sprite_offset sprite_offset);
void vera_sprite_height(vera_sprite_offset sprite_offset, char height);
/* inline */ void vera_sprite_palette_offset(vera_sprite_offset sprite_offset, vera_palette_offset palette_offset);
/* inline */ void vera_sprite_set_collision_mask(vera_sprite_offset sprite_offset, vera_collision_mask mask);
/* inline */ void vera_sprites_show();
/* inline */ void vera_sprites_hide();

/* inline */ void vera_sprites_collision_on();
/* inline */ void vera_sprites_collision_off();
/* inline */ char vera_sprite_is_collision();
/* inline */ void vera_sprite_collision_clear();
/* inline */ unsigned char vera_sprite_get_collision();


/* inline */ void vera_sprite_buffer_read(vera_sprite_buffer_t sprite_buffer);
/* inline */ void vera_sprite_buffer_write(vera_sprite_buffer_t sprite_buffer);

/* inline */ void vera_sprite_buffer_bpp(vera_sprite_buffer_item_t *sprite_offset, char bpp);
/* inline */ void vera_sprite_buffer_set_image_offset(vera_sprite_buffer_item_t *sprite_offset, vera_sprite_image_offset sprite_image_offset);
/* inline */ void vera_sprite_buffer_xy(vera_sprite_buffer_item_t *sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y);
/* inline */ void vera_sprite_buffer_zdepth(vera_sprite_buffer_item_t *sprite_offset, unsigned char zdepth);
/* inline */ void vera_sprite_buffer_disable(vera_sprite_buffer_item_t *sprite_offset);
void vera_sprite_buffer_width(vera_sprite_buffer_item_t *sprite_offset, char width);
void vera_sprite_buffer_height(vera_sprite_buffer_item_t *sprite_offset, char height);
void vera_sprite_buffer_hflip(vera_sprite_buffer_item_t *sprite_offset, char hflip);
void vera_sprite_buffer_vflip(vera_sprite_buffer_item_t *sprite_offset, char vflip);
/* inline */ void vera_sprite_buffer_palette_offset(vera_sprite_buffer_item_t *sprite_offset, vera_palette_offset palette_offset);

/* inline */ void vera_sprite_attributes_set(vera_sprite_offset sprite_offset, struct VERA_SPRITE sprite_attr);
/* inline */ void vera_sprite_attributes_get(vera_sprite_offset sprite_offset, struct VERA_SPRITE *sprite_attr);

#endif