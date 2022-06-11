#include <cx16-fb.h>
#include <cx16-vera.h>
#include <cx16-veralib.h>
#include "cx16-veraheap-typedefs.h"
#include <fp3.h>
#include <ht.h>

typedef unsigned char fe_sprite_index_t;

typedef struct {
    unsigned char used[16];
    void* sprite_bram[16];
    unsigned char count[16];
    unsigned int size[16];
    unsigned char zdepth[16];
    unsigned char bpp[16];
    unsigned char width[16];
    unsigned char height[16];
    unsigned char hflip[16];
    unsigned char vflip[16];
    unsigned char reverse[16];
    unsigned char palette_offset[16];
    unsigned char file[16*16];
    vera_sprite_image_offset image[16*16];
    vera_heap_handle_t vram_handle[16*16];
    unsigned char aabb[16*4];
} fe_sprite_cache_t;


typedef struct {
    char file[16];
    unsigned char count;
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
    fb_heap_handle_t bram_handle[16];
    fe_sprite_index_t sprite_cache;
} sprite_bram_t;


typedef struct {

    FP tx[4];
    FP ty[4];
    FP tdx[4];
    FP tdy[4];

    unsigned char used[4];

    unsigned char moved[4];
    unsigned char enabled[4];
    unsigned char engine[4];

    unsigned char firegun[4];
    unsigned char reload[4];
    signed char health[4];

    vera_sprite_offset sprite_offset[4];

    unsigned char wait_animation[4];
    unsigned char speed_animation[4];
    unsigned char state_animation[4];

    fe_sprite_index_t sprite[4];

} fe_player_t;

typedef struct {

    unsigned char used[4];

    vera_sprite_offset sprite_offset[4];

    unsigned char wait_animation[4];
    unsigned char speed_animation[4];
    unsigned char state_animation[4];

    fe_sprite_index_t sprite[4];

} fe_engine_t;



// To store the position of the control blocks in the engine parts.
typedef struct {
    bram_bank_t bram_bank;
    bram_bank_t bram_sprite_control;
    unsigned char sprite_pool;
    unsigned char enemy_pool;
    unsigned char player_pool;
    unsigned char engine_pool;
    unsigned char bullet_pool;
} fe_t;
