/**
 * @file cx16-vera-sprite.h
 * @author your name (you@domain.com)
 * @brief Type definitions
 * @version 0.1
 * @date 2022-10-08
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <cx16-heap-bram-fb.h>
#include <cx16-veralib.h>

typedef struct {
    unsigned char r[8];
} sprite_registers_t;

typedef struct {
    unsigned int offset;
} sprite_offsets_t;

typedef struct {
    unsigned char count;
    unsigned int  size;
    unsigned char width;
    unsigned char height;
    unsigned char zdepth;
    unsigned char hflip;
    unsigned char vflip;
    unsigned char bpp;
    unsigned char collision;
    unsigned char reverse;
    unsigned char palette_offset;
} sprite_file_header_t;

typedef struct {
    char file[32];
    unsigned int    size;
    unsigned char   height;
    unsigned char   width;
    unsigned char   zdepth;
    unsigned char   hflip;
    unsigned char   vflip;
    unsigned char   bpp;
    unsigned char   palette; 
    heap_bram_fb_handle_t bram;
    vera_sprite_image_offset vram;
} sprite_t;

typedef struct {
    char* file;
} sprite_file_t;


