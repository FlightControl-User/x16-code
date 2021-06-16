
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


// File declarations
const char FILE_PALETTES_SPRITE01[] = "PALSPRITE01";
const char FILE_PALETTES_FLOOR01[] = "PALFLOOR01";

// Sprite constants
const byte SPRITE_OFFSET_PLAYER = 1;
const byte SPRITE_OFFSET_ENGINE = 2;
const byte SPRITE_OFFSET_ENEMY = 3;
const byte SPRITE_OFFSET_BULLET = 64;

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

struct sprite_bullet {
    byte active;
    signed int x;
    signed int y;
    signed char dx;
    signed char dy;
    byte energy;
};

struct sprite_enemy {
    byte active;
    byte SpriteType;
    byte state_behaviour;
    byte state_animation;
    byte speed_animation;
    byte health;
    byte strength;
    signed int x;
    signed int y;
    signed char dx;
    signed char dy;
};

struct sprite_bullet sprite_bullets[11] = {0};
volatile byte sprite_bullet_count = 0;
volatile byte sprite_bullet_pause = 0;
volatile byte sprite_bullet_switch = 0;

struct sprite_enemy sprite_enemies[33] = {0};
volatile byte sprite_enemy_count = 0;

volatile byte sprite_collided = 0;


volatile byte state_game = 0;