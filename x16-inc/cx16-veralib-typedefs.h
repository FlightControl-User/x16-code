#pragma once

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

typedef unsigned char vera_sprite_width_t;
typedef unsigned char vera_sprite_height_t;
typedef unsigned char vera_sprite_zdepth_t;
typedef unsigned char vera_sprite_bpp_t;
typedef unsigned char vera_sprite_hflip_t;
typedef unsigned char vera_sprite_vflip_t;
