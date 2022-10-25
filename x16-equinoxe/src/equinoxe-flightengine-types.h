#include <cx16-heap-bram-fb.h>
#include <cx16-vera.h>
#include <cx16-veralib.h>
#include "cx16-veraheap-typedefs.h"
#include <fp3.h>
#include <ht.h>

typedef unsigned char fe_sprite_index_t;

typedef struct {
    char file[16];
    unsigned char   loaded;
    unsigned char   count;
    unsigned int    SpriteSize;
    unsigned char   Height;
    unsigned char   Width;
    unsigned char   Zdepth;
    unsigned char   Hflip;
    unsigned char   Vflip;
    unsigned char   BPP;
    unsigned char   PaletteOffset; 
    unsigned char   reverse;
    unsigned char   aabb[4];
    unsigned int    offset;
    unsigned char   loop;
    fe_sprite_index_t sprite_cache;
} sprite_bram_t;

typedef heap_bram_fb_handle_t sprite_bram_handles_t;

typedef struct {
    unsigned char count;
    unsigned int size;
    unsigned char width;
    unsigned char height;
    unsigned char zdepth;
    unsigned char hflip;
    unsigned char vflip;
    unsigned char bpp;
    unsigned char collision;
    unsigned char reverse;
    unsigned char palette_offset;
    unsigned char loop;
} sprite_file_header_t;


typedef struct {
    unsigned char used[128];
    vera_sprite_image_offset vram_image_offset[128];
    vera_heap_handle_t vram_handle[128];
    unsigned int id[128];
} fe_vram_sprite_cache_t;

typedef struct {
    unsigned char used[16];
    void* sprite_bram[16]; // TODO: I need to get rid of this ...
    unsigned char count[16];
    unsigned int offset[16];
    unsigned int size[16];
    unsigned char zdepth[16];
    unsigned char bpp[16];
    unsigned char width[16];
    unsigned char height[16];
    unsigned char hflip[16];
    unsigned char vflip[16];
    unsigned char reverse[16];
    unsigned char speed[16];
    unsigned char loop[16];
    unsigned char palette_offset[16];
    unsigned char file[16*16];
    unsigned char aabb[16*4];
} fe_sprite_cache_t;



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
    unsigned char sprite_cache_pool;
} fe_t;
