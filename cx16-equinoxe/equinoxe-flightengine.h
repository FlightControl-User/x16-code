#ifndef equinoxe_flightengine_h
#define equinoxe_flightengine_h

#include <cx16-fb.h>
#include <cx16-vera.h>
#include <cx16-veralib.h>
#include <fp3.h>
#include <ht.h>

typedef struct _sprite {
    char File[16];
    unsigned char SpriteCount;
    unsigned char SpriteOffset;
    unsigned int TotalSize;
    unsigned int SpriteSize;
    unsigned char Height;
    unsigned char Width;
    unsigned char Zdepth;
    unsigned char Hflip;
    unsigned char Vflip;
    unsigned char BPP;
    unsigned char PaletteOffset; 
    unsigned char CollisionMask;
    heap_handle bram_handle[16];
    vera_sprite_image_offset offset_image[16];
} Sprite;

typedef struct {
    heap_handle next;
    heap_handle prev;
    heap_handle handle;
    vera_sprite_image_offset offset;
} sprite_list;


#define SPRITE_PLAYER01_COUNT 7
Sprite SpritePlayer01 =       { 
    "PLAYER01", 
    SPRITE_PLAYER01_COUNT, 
    0, 32*32*SPRITE_PLAYER01_COUNT/2, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 9, 0b10000000, {0x0}, {0x0} 
};
heap_handle sprite_player_01[SPRITE_PLAYER01_COUNT];

#define SPRITE_ENEMY01_COUNT 12
Sprite SpriteEnemy01 =       { 
    "ENEMY01", SPRITE_ENEMY01_COUNT, 
    7, 32*32*SPRITE_ENEMY01_COUNT/2, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 10, 0b11000000, {0x0}, { 0x0 } 
};
heap_handle sprite_enemy_01[SPRITE_ENEMY01_COUNT];

#define SPRITE_ENGINE01_COUNT 16
Sprite SpriteEngine01 =       { 
    "ENGINE01", SPRITE_ENGINE01_COUNT, 
    7+12, 16*16*SPRITE_ENGINE01_COUNT/2, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 11, 0b00000000, {0x0}, { 0x0 } 
};
heap_handle sprite_engine_01[SPRITE_ENGINE01_COUNT];

#define SPRITE_BULLET01_COUNT 1
Sprite SpriteBullet01 =       { 
    "BULLET01", SPRITE_BULLET01_COUNT, 
    7+12+16, 16*16*SPRITE_BULLET01_COUNT/2, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 12, 0b01000000, {0x0}, { 0x0 } };
heap_handle sprite_bullet_01[SPRITE_BULLET01_COUNT];


byte const SPRITE_TYPES = 4;
byte const SPRITE_PLAYER01 = 0;
byte const SPRITE_ENEMY01 = 1;
byte const SPRITE_ENGINE01 = 2;
byte const SPRITE_BULLET01 = 3;
__mem Sprite *SpriteDB[4] = { &SpritePlayer01, &SpriteEnemy01, &SpriteEngine01, &SpriteBullet01 };


// Work variables

byte const SPRITE_COUNT = SPRITE_PLAYER01_COUNT + SPRITE_ENEMY01_COUNT + SPRITE_ENGINE01_COUNT + SPRITE_BULLET01_COUNT; 

enum entity_types {
    entity_type_player,
    entity_type_enemy,
    entity_type_bullet
};

const unsigned char entity_size = 120U;

const unsigned char FE_PLAYER = 4;
const unsigned char FE_PLAYER_LO = 0;
const unsigned char FE_PLAYER_HI = 3;
const unsigned char FE_ENEMY = 64;
const unsigned char FE_ENEMY_LO = 0;
const unsigned char FE_ENEMY_HI = 63;
const unsigned char FE_BULLET = 64;
const unsigned char FE_BULLET_LO = 0;
const unsigned char FE_BULLET_HI = 63;

const unsigned char FE_ENGINE = 4;
const unsigned char FE_ENGINE_LO = 0;
const unsigned char FE_ENGINE_HI = 3;

typedef struct {

    FP tx[64];
    FP ty[64];
    FP tdx[64];
    FP tdy[64];

    unsigned char pool;
    unsigned char used[64];

    unsigned char type[64];
    unsigned char side[64];

    unsigned char move[64];
    unsigned char moved[64];
    unsigned char enabled[64];

    unsigned char step[64];
    unsigned int flight[64];
    unsigned char delay[64];

    unsigned char angle[64];
    unsigned char speed[64];
    unsigned char turn[64];
    unsigned char radius[64];
    unsigned char baseangle[64];

    unsigned char reload[64];
    unsigned char health[64];

    unsigned char wait_animation[64];
    unsigned char speed_animation[64];
    unsigned char state_animation[64];

    Sprite* sprite_type[64];
    vera_sprite_offset sprite_offset[64];

} fe_enemy_t;

fe_enemy_t enemy;

typedef struct {

    FP tx[4];
    FP ty[4];
    FP tdx[4];
    FP tdy[4];

    unsigned char pool;
    unsigned char used[4];

    unsigned char moved[4];
    unsigned char enabled[4];
    unsigned char engine[4];

    unsigned char firegun[4];
    unsigned char reload[4];
    unsigned char health[4];

    unsigned char wait_animation[4];
    unsigned char speed_animation[4];
    unsigned char state_animation[4];

    Sprite* sprite_type[4];
    vera_sprite_offset sprite_offset[4];

} fe_player_t;

fe_player_t player;

typedef struct {

    unsigned char pool;
    unsigned char used[4];

    unsigned char wait_animation[4];
    unsigned char speed_animation[4];
    unsigned char state_animation[4];

    Sprite* sprite_type[4];
    vera_sprite_offset sprite_offset[4];

} fe_engine_t;

fe_engine_t engine;


typedef struct {

    FP tx[64];
    FP ty[64];
    FP tdx[64];
    FP tdy[64];

    unsigned char pool;
    unsigned char used[64];

    unsigned char type[64];
    unsigned char side[64];

    unsigned char move[64];
    unsigned char moved[64];
    unsigned char enabled[64];

    unsigned char step[64];
    unsigned int flight[64];
    unsigned char delay[64];

    unsigned char angle[64];
    unsigned char speed[64];
    unsigned char turn[64];
    unsigned char radius[64];
    unsigned char baseangle[64];

    unsigned char reload[64];
    unsigned char health[64];

    unsigned char wait_animation[64];
    unsigned char speed_animation[64];
    unsigned char state_animation[64];

    Sprite* sprite_type[64];
    vera_sprite_offset sprite_offset[64];

} fe_bullet_t;

fe_bullet_t bullet;


typedef struct entity_s {
    heap_handle next;
    heap_handle prev;

    signed int x;
    signed int y;
    unsigned char type;
    unsigned char collision_mask;
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
    unsigned char enabled;
    Sprite* sprite_type;
    vera_sprite_offset sprite_offset;

    heap_handle engine_handle;
    FP3 tx;
    FP3 ty;
    FP3 tdx;
    FP3 tdy;
} entity_t;

void Logic();
// void Draw();


void sprite_animate(vera_sprite_offset sprite_offset, Sprite* sprite, byte index, byte animate);
void sprite_position(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y);
void sprite_configure(vera_sprite_offset sprite_offset, Sprite* sprite);
void sprite_enable(vera_sprite_offset sprite_offset, Sprite* sprite);
void sprite_disable(vera_sprite_offset sprite_offset);
void sprite_collision(vera_sprite_offset sprite_offset, byte mask);


#endif