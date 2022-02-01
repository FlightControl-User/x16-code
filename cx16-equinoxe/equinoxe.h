#include <cx16.h>
#include <string.h>
#include <ht.h>

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

// File declarations
const char FILE_PALETTES_SPRITE01[] = "PALSPRITE01";
const char FILE_PALETTES_FLOOR01[] = "PALFLOOR01";

// Sprite constants
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

volatile byte i = 0;
volatile byte j = 0;
volatile word vscroll = 16*32;
volatile int prev_mousex = 0;
volatile int prev_mousey = 0;
volatile byte scroll_action = 2;

ht_size_t ht_size_collision = 512;
ht_item_t ht_collision[512];

// vera_sprite_buffer_item_t sprite_buffer[128];



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



typedef struct {
    heap_handle fighter_list;
    heap_handle fighter_tail;
    heap_handle bullet_tail;
    heap_handle bullet_list;
    vera_sprite_id sprite_player; // Keep track of the last player sprite allocated.
    vera_sprite_id sprite_bullet; // Keep track of the last bullet sprite allocated.
    vera_sprite_id sprite_enemy;  // Keep track of the last enemy sprite allocated.
    unsigned char level;
    unsigned char phase;
    unsigned char spawnenemycount;
    unsigned char spawnenemytype;
} Stage;

volatile Stage stage;
volatile vera_sprite_offset sprite_offsets[127] = {0};


volatile byte sprite_collided = 0;


volatile byte state_game = 0;


volatile heap_handle player_handle;
volatile heap_handle enemy_handle;
volatile heap_handle engine_handle;

volatile Game game;






