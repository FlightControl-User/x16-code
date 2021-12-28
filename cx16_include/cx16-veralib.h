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
typedef char vera_map_offset; ///< Expresses the map base of a layer.
typedef char vera_tile_offset; ///< Expresses the tile base of a layer.
typedef char vera_forecolor; ///< Expresses the foreground color of the text.
typedef char vera_backcolor; ///< Expresses the background color of the text.
typedef char vera_textcolor; ///< Expresses the foreground and background color of the text.
typedef char vera_scroll; ///< Expresses a scroll position of a layer.
typedef char vera_sprite; ///< Expresses a sprite identifier.
typedef signed int vera_sprite_coordinate; ///< Expresses a sprite coordinate or position on the display.
typedef char vera_palette_offset; ///< Expresses a palette offset, which is a number between 0 and 15.
typedef char vera_collision_mask; ///< Expresses the collision mask, with the lower 4 bits indicating the selection of the 4 groups to perform the collision detection.

dword vera_ptr_to_address(byte bank, char* ptr);

inline void vera_vram_data0_address(dword bankaddr, enum vera_inc_dec inc_dec);
inline void vera_vram_data1_address(dword bankaddr, enum vera_inc_dec inc_dec);
inline void vera_vram_data0_bank_offset(vera_bank bank, vera_offset offset, enum vera_inc_dec inc_dec);
inline void vera_vram_data1_bank_offset(vera_bank bank, vera_offset offset, enum vera_inc_dec inc_dec);

// --- VERA active display management ---

inline void vera_display_set_scale_none();
inline void vera_display_set_scale_double();
inline void vera_display_set_scale_triple();
vera_scale vera_display_get_hscale();
vera_scale vera_display_get_vscale();
vera_height vera_display_get_height();
vera_width vera_display_get_width();

// --- VERA LAYERS ---

void vera_layer_set_config(vera_layer layer, vera_config config);
vera_config vera_layer_get_config(vera_layer layer);
void vera_layer_set_text_color_mode(vera_layer layer, vera_color_mode color_mode);
void vera_layer_set_bitmap_mode(vera_layer layer );
void vera_layer_set_tilemap_mode(vera_layer layer );
inline void vera_layer_set_width_32(vera_layer layer);
inline void vera_layer_set_width_64(vera_layer layer);
inline void vera_layer_set_width_128(vera_layer layer);
inline void vera_layer_set_width_256(vera_layer layer);
inline void vera_layer_set_height_32(vera_layer layer);
inline void vera_layer_set_height_64(vera_layer layer);
inline void vera_layer_set_height_128(vera_layer layer);
inline void vera_layer_set_height_256(vera_layer layer);
inline word vera_layer_get_width(vera_layer layer);
inline word vera_layer_get_height(vera_layer layer);
inline void vera_layer_set_color_depth_1BPP(vera_layer layer);
inline void vera_layer_set_color_depth_2BPP(vera_layer layer);
inline void vera_layer_set_color_depth_4BPP(vera_layer layer);
inline void vera_layer_set_color_depth_8BPP(vera_layer layer);
inline byte vera_layer_get_color_depth(vera_layer layer);
inline void vera_layer_show(vera_layer layer);
inline void vera_layer_hide(vera_layer layer);
inline byte vera_layer_is_visible(vera_layer layer);
void vera_layer_set_mapbase(vera_layer layer, byte mapbase);
void vera_layer_set_mapbase_address(vera_layer layer, dword mapbase_address);
byte vera_layer_get_mapbase(vera_layer layer);
dword vera_layer_get_mapbase_address(vera_layer layer);
byte vera_layer_get_mapbase_bank(vera_layer layer);
word vera_layer_get_mapbase_offset(vera_layer layer);
void vera_layer_set_tilebase(vera_layer layer, byte tilebase);
void vera_layer_set_tilebase_address(vera_layer layer, dword tilebase_address);
byte vera_layer_get_tilebase(vera_layer layer);
dword vera_layer_get_tilebase_address(vera_layer layer);
byte vera_layer_set_textcolor(vera_layer layer, byte color);
byte vera_layer_get_textcolor(vera_layer layer);
byte vera_layer_set_backcolor(vera_layer layer, byte color);
byte vera_layer_get_backcolor(vera_layer layer);
byte vera_layer_get_color(vera_layer layer);
inline void vera_layer_set_horizontal_scroll(vera_layer layer, word scroll);
inline void vera_layer_set_vertical_scroll(vera_layer layer, word scroll);
byte vera_layer_get_rowshift(vera_layer layer);
word vera_layer_get_rowskip(vera_layer layer);
void vera_layer_mode_tile(vera_layer layer, dword mapbase_address, dword tilebase_address, word mapwidth, word mapheight, byte tilewidth, byte tileheight, byte color_depth );
void vera_layer_mode_text(vera_layer layer, dword mapbase_address, dword tilebase_address, word mapwidth, word mapheight, byte tilewidth, byte tileheight, word color_mode );
void vera_layer_mode_bitmap(vera_layer layer, dword bitmap_address, word mapwidth, word color_depth );

// --- SPRITES ---

inline void vera_sprite_address(vera_sprite sprite, dword address);
inline void vera_sprite_bank_offset(vera_sprite sprite, vera_bank bank, vera_offset offfset);
inline void vera_sprite_xy(vera_sprite sprite, vera_sprite_coordinate x, vera_sprite_coordinate y);
inline void vera_sprite_4bpp(vera_sprite sprite);
inline void vera_sprite_8bpp(vera_sprite sprite);
inline void vera_sprite_bpp(vera_sprite sprite, byte bpp);
inline void vera_sprite_hflip_on(vera_sprite sprite);
inline void vera_sprite_hflip_off(vera_sprite sprite);
void vera_sprite_hflip(vera_sprite sprite, byte hflip);
inline void vera_sprite_vflip_on(vera_sprite sprite);
inline void vera_sprite_vflip_off(vera_sprite sprite);
void vera_sprite_vflip(vera_sprite sprite, byte vflip);
inline void vera_sprite_disable(vera_sprite sprite);
inline void vera_sprite_zdepth_between_background_and_layer0(vera_sprite sprite);
inline void vera_sprite_zdepth_between_layer0_and_layer1(vera_sprite sprite);
inline void vera_sprite_zdepth_in_front(vera_sprite sprite);
void vera_sprite_zdepth(vera_sprite sprite, byte zdepth);
inline void vera_sprite_width_8(vera_sprite sprite);
inline void vera_sprite_width_16(vera_sprite sprite);
inline void vera_sprite_width_32(vera_sprite sprite);
inline void vera_sprite_width_64(vera_sprite sprite);
void vera_sprite_width(vera_sprite sprite, byte width);
inline void vera_sprite_height_8(vera_sprite sprite);
inline void vera_sprite_height_16(vera_sprite sprite);
inline void vera_sprite_height_32(vera_sprite sprite);
inline void vera_sprite_height_64(vera_sprite sprite);
void vera_sprite_height(vera_sprite sprite, byte height);
inline void vera_sprite_attributes_set(vera_sprite sprite, struct VERA_SPRITE sprite_attr);
inline void vera_sprite_attributes_get(vera_sprite sprite, struct VERA_SPRITE *sprite_attr);
inline void vera_sprite_palette_offset(vera_sprite sprite, vera_palette_offset palette_offset);
inline void vera_sprite_collision_mask(vera_sprite sprite, vera_collision_mask mask);
inline void vera_sprites_show();
inline void vera_sprites_hide();

inline void vera_sprites_collision_on();
inline void vera_sprites_collision_off();
inline bool vera_sprite_is_collision();
inline void vera_sprite_collision_clear();

void vera_cpy_vram_vram(dword vsrc, dword vdest, dword num );
