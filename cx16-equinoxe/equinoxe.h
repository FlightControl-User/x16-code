

#include <cx16.h>
#include <string.h>
#include <cx16-heap.h>
#include "equinoxe-flightengine.h"

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
volatile byte a = 4;
volatile word row = 8;
volatile byte s = 1;
volatile word vscroll = 8*64;
volatile int prev_mousex = 0;
volatile int prev_mousey = 0;
volatile byte sprite_player = 3;
volatile byte sprite_player_moved = 0;
volatile byte sprite_engine_flame = 0;
volatile byte scroll_action = 2;
volatile byte sprite_action = 0;

volatile unsigned int debug_count = 0; 


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
    heap_handle next;
    heap_handle prev;
    signed int x;
    signed int y;
    signed char fx;
    signed char fy;
    signed char dx;
    signed char dy;
    byte active;
    byte SpriteType;
    byte state_behaviour;
    byte state_animation;
    byte wait_animation;
    byte speed_animation;
    byte health;
    byte gun;
    byte strength;
    byte reload;
    byte moved;
    byte side;
    byte firegun;
    unsigned int flight;
    unsigned char move;
    unsigned char step;
    unsigned char angle;
    unsigned char baseangle;
    unsigned char radius;
    unsigned char delay;
    signed char turn;
    unsigned char speed;
    Sprite* sprite_type;
    vera_sprite_offset sprite_offset;

    heap_handle engine_handle;
} Entity;

typedef Entity Enemy;
typedef Entity Bullet;

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


Entity sprite_enemies[33] = {0};
volatile byte sprite_enemy_count = 0;

volatile byte sprite_collided = 0;


volatile byte state_game = 0;


volatile heap_handle player_handle;
volatile heap_handle enemy_handle;
volatile heap_handle engine_handle;

volatile Game game;


inline void sprite_create(Sprite* sprite, vera_sprite_offset sprite_offset);
void sprite_animate(vera_sprite_offset sprite_offset, Sprite* sprite, byte index);
inline void sprite_position(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y);
inline void sprite_configure(vera_sprite_offset sprite_offset, Sprite* sprite);
inline void sprite_enable(vera_sprite_offset sprite_offset, Sprite* sprite);
inline void sprite_disable(vera_sprite_offset sprite_offset);


void Logic();


void Draw();


