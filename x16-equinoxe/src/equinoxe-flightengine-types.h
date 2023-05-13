
#pragma once

// #include <cx16-vera.h>
// #include <cx16-veralib.h>
#include "cx16-veraheap-typedefs.h"
// #include <fp3.h>
// #include <ht.h>
#include <cx16-bramheap-typedefs.h>
#include "equinoxe-animate-types.h"

#define FLIGHT_OBJECTS 64

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
typedef unsigned char flight_side_t;

#include <cx16-veralib.h>
#include "equinoxe-level-types.h"
typedef struct {

    fe_sprite_index_t cache[FLIGHT_OBJECTS];            // Internal link field.
    vera_sprite_offset sprite_offset[FLIGHT_OBJECTS];   // An internal field that holds the calculated offset in vera.
    unsigned char used[FLIGHT_OBJECTS];                 // Is the sprite used, so free or not.
    unsigned char enabled[FLIGHT_OBJECTS];              // Is the sprite enabled (visible or not)?
    unsigned char collided[FLIGHT_OBJECTS];             // Has the sprite collided during the collision detection routine.

    flight_type_t type[FLIGHT_OBJECTS];                 // The type of flight object.
    flight_side_t side[FLIGHT_OBJECTS];                 // The type of flight object.

    unsigned char cx[FLIGHT_OBJECTS];                   // x-axis coordinate at collision precision.
    unsigned char cy[FLIGHT_OBJECTS];                   // y-axis coordinate at collision precision.

    unsigned char xf[FLIGHT_OBJECTS];                   // Fractional current x coordinate.
    unsigned char yf[FLIGHT_OBJECTS];                   // Fractional current x coordinate.
    unsigned int xi[FLIGHT_OBJECTS];                    // Integer current x coordinate.
    unsigned int yi[FLIGHT_OBJECTS];                    // Integer current y coordinate.
    unsigned int xd[FLIGHT_OBJECTS];                    // Fixed delta x.
    unsigned int yd[FLIGHT_OBJECTS];                    // Fixed delta y.
    unsigned char xs[FLIGHT_OBJECTS];                   // Integer shoot x relative to xi.
    unsigned char ys[FLIGHT_OBJECTS];                   // Integer shoot y relative to xy.

    unsigned char move[FLIGHT_OBJECTS]; 
    unsigned char moved[FLIGHT_OBJECTS];               // Has the sprite moved?
    unsigned int moving[FLIGHT_OBJECTS]; // 1536
    unsigned char delay[FLIGHT_OBJECTS];

    unsigned char engine[FLIGHT_OBJECTS];              // Does the sprite have an engine sprite?

    unsigned char firegun[FLIGHT_OBJECTS];             // Models the armament.
    unsigned char reload[FLIGHT_OBJECTS];              // Does the armament need reloading?          


    unsigned char angle[FLIGHT_OBJECTS];                    // The angle of movement.
    unsigned char speed[FLIGHT_OBJECTS];                // The speed of movement.
    unsigned char turn[FLIGHT_OBJECTS];                 // The turn ratio.
    unsigned char radius[FLIGHT_OBJECTS];               // The radius of the turn.

    signed char health[FLIGHT_OBJECTS];                // The health of the object.
    signed char impact[FLIGHT_OBJECTS];                // The impact in energy that the object makes when colliding with an other object. 
    
    unsigned char animate[FLIGHT_OBJECTS];                // Models the animation of the sprite.

    unsigned char action[FLIGHT_OBJECTS]; 
    stage_flightpath_t* flightpath[FLIGHT_OBJECTS]; 
    unsigned char initpath;

    unsigned char wave[FLIGHT_OBJECTS]; 

    unsigned char next[FLIGHT_OBJECTS];
    unsigned char prev[FLIGHT_OBJECTS];
    unsigned char root[10];
    unsigned char count[10];

    flight_index_t index;

} flight_t;

/*
typedef struct {

    unsigned char wave[64]; 

    unsigned char move[64]; // FLIGHT_OBJECTSGHT_OBJECTS0
    unsigned char moved[64]; // 1344
    unsigned char enabled[64]; // 1408

    unsigned int moving[64]; // 1536
    unsigned char delay[64]; // 1600

    unsigned char angle[64]; // 1664
    unsigned char speed[64]; // 1728
    unsigned char turn[64]; // 1792
    unsigned char radius[64]; // 1856
    unsigned char baseangle[64]; // 1920

    signed char health[64]; // 2048
    signed char impact[64];

    vera_sprite_offset sprite_offset[64]; // 2176

    unsigned char wait_animation[64]; // 2240
    unsigned char speed_animation[64]; // 2304
    unsigned char state_animation[64]; // 2368
    unsigned char reverse_animation[64]; // 2432
    signed char direction_animation[64]; // 2496
    unsigned char start_animation[64]; // 2560
    unsigned char stop_animation[64]; // 2624

    unsigned char action[64]; // 2688
    stage_flightpath_t* flightpath[64]; // 2816
    unsigned char initpath; // 2217

    fe_sprite_index_t sprite[64]; // 2881

} fe_enemy_t;

*/

/*
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

*/

// To store the position of the control blocks in the engine parts.
typedef unsigned char fe_t;
