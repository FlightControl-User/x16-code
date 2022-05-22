#ifndef equinoxe_types_h
#define equinoxe_types_h

#pragma var_model(mem)

#include <cx16.h>
#include <string.h>
#include <ht.h>
#include <fp3.h>
#include <cx16-fb.h>
#include <cx16-veralib.h>
#include <cx16-veraheap-typedefs.h>

#include "equinoxe-palette-types.h"
#include "equinoxe-flightengine-types.h"
#include "equinoxe-stage-types.h"
#include "equinoxe-enemy-types.h"


// This frees up the maximum space in VERA VRAM available for graphics.
const word VRAM_PETSCII_MAP_SIZE = 128*64*2;

// HEAP SEGMENTS
const byte HEAP_SEGMENT_BRAM_SPRITES = 0;
const byte HEAP_SEGMENT_BRAM_TILES = 1;
const byte HEAP_SEGMENT_BRAM_PALETTES = 2;
const byte HEAP_SEGMENT_VRAM_PETSCII = 3;
const byte HEAP_SEGMENT_VRAM_SPRITES = 4;
const byte HEAP_SEGMENT_VRAM_FLOOR_MAP = 5;
const byte HEAP_SEGMENT_VRAM_FLOOR_TILE = 6;
const byte HEAP_SEGMENT_BRAM_ENTITIES = 7;

const byte HEAP_SEGMENT_BRAM_SPRITES_BANK = 5;
const byte HEAP_SEGMENT_BRAM_SPRITES_BANKS = 10;
const byte HEAP_SEGMENT_BRAM_ENTITIES_BANK = 30;
const byte HEAP_SEGMENT_BRAM_ENTITIES_BANKS = 1;


const bram_bank_t   BRAM_PALETTE_BANK = 63;
const bram_ptr_t    BRAM_PALETTE_PTR = (bram_ptr_t)0XA000;


// sprite_t constants
const unsigned char SPRITE_MOUSE = 0;
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

volatile word floor_scroll_vertical = 16*32;
volatile int prev_mousex = 0;
volatile int prev_mousey = 0;
volatile byte floor_scroll_action = 2;

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
    int curr_mousex;
    int curr_mousey;
    int prev_mousex;
    int prev_mousey;
    char status_mouse;
    unsigned char ticksync;
    unsigned char tickstage;
} Game;




vera_sprite_offset sprite_offsets[127] = {0};


volatile unsigned char sprite_collided = 0;


volatile byte state_game = 0;


volatile fb_heap_handle_t player_handle;
volatile fb_heap_handle_t enemy_handle;
volatile fb_heap_handle_t engine_handle;

volatile Game game;

// #pragma data_seg(Heap)

static fb_heap_segment_t heap_64; static fb_heap_segment_t* bin64 = &heap_64;
static fb_heap_segment_t heap_128; static fb_heap_segment_t* bin128 = &heap_128;
static fb_heap_segment_t heap_256; static fb_heap_segment_t* bin256 = &heap_256;
static fb_heap_segment_t heap_512; static fb_heap_segment_t* bin512 = &heap_512;
static fb_heap_segment_t heap_1024; static fb_heap_segment_t* bin1024 = &heap_1024;

static heap_structure heap; static heap_structure* bins = &heap;


#pragma data_seg(Data)

#endif
