#ifndef equinoxe_flightengine_types_h
#define equinoxe_flightengine_types_h

#include <cx16-fb.h>
#include <cx16-vera.h>
#include <cx16-veralib.h>
#include <fp3.h>
#include <ht.h>

typedef struct {
    char file[16];
    unsigned char count;
    unsigned char offset;
    unsigned int TotalSize;
    unsigned int SpriteSize;
    unsigned char Height;
    unsigned char Width;
    unsigned char Zdepth;
    unsigned char Hflip;
    unsigned char Vflip;
    unsigned char BPP;
    unsigned char PaletteOffset; 
    unsigned char reverse;
    unsigned char aabb[4];
    heap_handle bram_handle[16];
    vera_sprite_image_offset offset_image[16];
} sprite_t;


typedef struct {
    heap_handle next;
    heap_handle prev;
    heap_handle handle;
    vera_sprite_image_offset offset;
} sprite_list;

typedef struct {

    FP tx[4];
    FP ty[4];
    FP tdx[4];
    FP tdy[4];

    unsigned char aabb_min_x[4];
    unsigned char aabb_min_y[4];
    unsigned char aabb_max_x[4];
    unsigned char aabb_max_y[4];

    unsigned char used[4];

    unsigned char moved[4];
    unsigned char enabled[4];
    unsigned char engine[4];

    unsigned char firegun[4];
    unsigned char reload[4];
    signed char health[4];

    unsigned char wait_animation[4];
    unsigned char speed_animation[4];
    unsigned char state_animation[4];

    sprite_t* sprite_type[4];
    vera_sprite_offset sprite_offset[4];
    unsigned char sprite_palette[4];

} fe_player_t;

typedef struct {

    unsigned char used[4];

    unsigned char wait_animation[4];
    unsigned char speed_animation[4];
    unsigned char state_animation[4];

    sprite_t* sprite_type[4];
    vera_sprite_offset sprite_offset[4];
    unsigned char sprite_palette[4];

} fe_engine_t;

#endif
