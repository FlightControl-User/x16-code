#include <cx16-vera.h>
#include <cx16-veralib.h>
#include "cx16-veraheap-typedefs.h"
#include <fp3.h>
#include <ht.h>
#include <cx16-bramheap-typedefs.h>
#include "equinoxe-animate-types.h"

typedef unsigned char fe_sprite_index_t;

typedef struct {
    unsigned char xmin;
    unsigned char ymin;
    unsigned char xmax;
    unsigned char ymax;
} aabb_t;

#define SPRITES 32
typedef struct {
    char*           file[SPRITES];
    unsigned char   loaded[SPRITES];
    unsigned char   count[SPRITES];
    unsigned int    SpriteSize[SPRITES];
    unsigned char   Height[SPRITES];
    unsigned char   Width[SPRITES];
    unsigned char   Zdepth[SPRITES];
    unsigned char   Hflip[SPRITES];
    unsigned char   Vflip[SPRITES];
    unsigned char   BPP[SPRITES];
    unsigned char   PaletteOffset[SPRITES]; 
    unsigned char   reverse[SPRITES];
    aabb_t          aabb[SPRITES];
    unsigned int    offset[SPRITES];
    unsigned char   loop[SPRITES];
    fe_sprite_index_t sprite_cache[SPRITES];
} sprite_t;
typedef unsigned char sprite_index_t;

typedef bram_heap_handle_t sprite_bram_handles_t;

// This header identifies the sprite behaviour in each sprite file.
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
    unsigned char loop;
    unsigned char dummy1;
    unsigned char dummy2;
    unsigned char dummy3;
    unsigned char dummy4;
} sprite_file_header_t;


// A structure for fast sprite information retrieval while floating.
// This cache is managed in low memory.
typedef struct {
    unsigned char used[16];
    sprite_index_t sprite_bram[16]; // TODO: I need to get rid of this ...
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
    unsigned char xmin[16];
    unsigned char ymin[16];
    unsigned char xmax[16];
    unsigned char ymax[16];
} fe_sprite_cache_t;

typedef unsigned char flight_index_t;
typedef unsigned char flight_type_t;

typedef struct {

    flight_type_t type[128];                // The type of flight object.

    unsigned char cx[128];                  // x-axis coordinate at collision precision.
    unsigned char cy[128];                  // y-axis coordinate at collision precision.

    FP tx[128];                             // Fixed point current x coordinate.
    FP ty[128];                             // Fixed point current y coordinate.
    FP tdx[128];                            // Fixed point delta x.
    FP tdy[128];                            // Fixed point delta y.

    unsigned char used[128];                // Is the sprite used, so free or not.
    unsigned char collided[128];            // Has the sprite collided during the collision detection routine.

    unsigned char moved[128];               // Has the sprite moved?
    unsigned char enabled[128];             // Is the sprite enabled (visible or not)?
    unsigned char engine[128];              // Does the sprite have an engine sprite?

    unsigned char firegun[128];             // Models the armament.
    unsigned char reload[128];              // Does the armament need reloading?          

    signed char health[128];                // The health of the object.
    signed char impact[128];                // The impact in energy that the object makes when colliding with an other object. 
    
    sprite_animate_t animation;             // Models the animation of the sprite.

    fe_sprite_index_t sprite[128];          // Internal link field.
    vera_sprite_offset sprite_offset[128];  // An internal field that holds the calculated offset in vera.

    flight_index_t index;

} flight_t;

typedef struct {

    FP tx[4];
    FP ty[4];
    FP tdx[4];
    FP tdy[4];

    unsigned char cx[4];
    unsigned char cy[4];

    unsigned char used[4];
    unsigned char collided[4];

    unsigned char moved[4];
    unsigned char enabled[4];
    unsigned char engine[4];

    unsigned char firegun[4];
    unsigned char reload[4];

    signed char health[4];
    signed char impact[4];

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
