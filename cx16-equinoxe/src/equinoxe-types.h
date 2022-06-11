#ifndef equinoxe_types_h
#define equinoxe_types_h

#include <cx16.h>
#include <string.h>
#include <ht.h>
#include <fp3.h>
#include <cx16-fb.h>
#include <cx16-veralib.h>
#include <cx16-veraheap-typedefs.h>

#include "equinoxe-bank.h"
#include "equinoxe-palette-types.h"
#include "equinoxe-flightengine-types.h"
#include "equinoxe-stage-types.h"
#include "equinoxe-enemy-types.h"
#include "equinoxe-bullet-types.h"


// sprite_bram_t constants
const unsigned char SPRITE_OFFSET_PLAYER_START = 1;
const unsigned char SPRITE_OFFSET_PLAYER_END = 4;
const unsigned char SPRITE_OFFSET_ENEMY_START = 5;
const unsigned char SPRITE_OFFSET_ENEMY_END = 63;
const unsigned char SPRITE_OFFSET_BULLET_START = 64;
const unsigned char SPRITE_OFFSET_BULLET_END = 95;

// Side constants to determine the coalition.
const byte SIDE_PLAYER = 0;
const byte SIDE_ENEMY = 1;

// Joint global variables.

struct sprite_bullet {
    byte active;
    signed int x;
    signed int y;
    signed char dx;
    signed char dy;
    byte energy;
};

typedef struct {
    void (*Logic)(void);
    void (*Draw)(void);
} Delegate;



typedef struct {
	Delegate delegate;
    unsigned char ticksync;
    unsigned char tickstage;
} Game;




vera_sprite_offset sprite_offsets[127] = { 0 };


volatile unsigned char sprite_collided = 0;


volatile byte state_game = 0;


volatile fb_heap_handle_t player_handle;
volatile fb_heap_handle_t enemy_handle;
volatile fb_heap_handle_t engine_handle;

volatile Game game;

#pragma data_seg(Heap)

heap_structure_t heap; heap_structure_t* bins = &heap;

fb_heap_segment_t heap_64; fb_heap_segment_t* bin64 = &heap_64;
fb_heap_segment_t heap_128; fb_heap_segment_t* bin128 = &heap_128;
fb_heap_segment_t heap_256; fb_heap_segment_t* bin256 = &heap_256;
fb_heap_segment_t heap_512; fb_heap_segment_t* bin512 = &heap_512;
fb_heap_segment_t heap_1024; fb_heap_segment_t* bin1024 = &heap_1024;



#pragma data_seg(Data)

#endif
