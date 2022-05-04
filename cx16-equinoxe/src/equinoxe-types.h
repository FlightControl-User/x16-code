#ifndef equinoxe_types_h
#define equinoxe_types_h

#pragma var_model(mem)

#include <cx16.h>
#include <string.h>
#include <ht.h>
#include <fp3.h>
#include <cx16-fb.h>
#include <cx16-veralib.h>

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


volatile heap_handle player_handle;
volatile heap_handle enemy_handle;
volatile heap_handle engine_handle;

volatile Game game;

// #pragma data_seg(Heap)

static heap_segment heap_64; static heap_segment* bin64 = &heap_64;
static heap_segment heap_128; static heap_segment* bin128 = &heap_128;
static heap_segment heap_256; static heap_segment* bin256 = &heap_256;
static heap_segment heap_512; static heap_segment* bin512 = &heap_512;
static heap_segment heap_1024; static heap_segment* bin1024 = &heap_1024;

static heap_structure heap; static heap_structure* bins = &heap;


#pragma data_seg(Data)

#endif
