#ifndef equinoxe_flightengine_h
#define equinoxe_flightengine_h

#include <cx16-fb.h>
#include <cx16-vera.h>
#include <cx16-veralib.h>
#include <fp3.h>
#include <ht.h>

// #pragma data_seg(Sprite)

#pragma data_seg(SpriteControl)

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
    unsigned char aabb[4];
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
    "player01", 
    SPRITE_PLAYER01_COUNT, 
    0, 32*32*SPRITE_PLAYER01_COUNT/2, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 9, {2,2,32-2,32-2}, {0x0}, {0x0} 
};
heap_handle sprite_player_01[SPRITE_PLAYER01_COUNT];

#define SPRITE_ENEMY01_COUNT 12
Sprite SpriteEnemy01 =       { 
    "enemy01", SPRITE_ENEMY01_COUNT, 
    7, 32*32*SPRITE_ENEMY01_COUNT/2, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 10, {2,2,32-2,32-2}, {0x0}, { 0x0 } 
};
heap_handle sprite_enemy_01[SPRITE_ENEMY01_COUNT];

#define SPRITE_ENGINE01_COUNT 16
Sprite SpriteEngine01 =       { 
    "engine01", SPRITE_ENGINE01_COUNT, 
    7+12, 16*16*SPRITE_ENGINE01_COUNT/2, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 11, {0,0,0,0}, {0x0}, { 0x0 } 
};
heap_handle sprite_engine_01[SPRITE_ENGINE01_COUNT];

#define SPRITE_BULLET01_COUNT 1
Sprite SpriteBullet01 =       { 
    "bullet01", SPRITE_BULLET01_COUNT, 
    7+12+16, 16*16*SPRITE_BULLET01_COUNT/2, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 12, {0,0,1,4}, {0x0}, { 0x0 } };
heap_handle sprite_bullet_01[SPRITE_BULLET01_COUNT];


byte const SPRITE_TYPES = 4;
byte const SPRITE_PLAYER01 = 0;
byte const SPRITE_ENEMY01 = 1;
byte const SPRITE_ENGINE01 = 2;
byte const SPRITE_BULLET01 = 3;

Sprite *SpriteDB[4] = { &SpritePlayer01, &SpriteEnemy01, &SpriteEngine01, &SpriteBullet01 };



// Work variables

byte const SPRITE_COUNT = SPRITE_PLAYER01_COUNT + SPRITE_ENEMY01_COUNT + SPRITE_ENGINE01_COUNT + SPRITE_BULLET01_COUNT; 


enum entity_types {
    entity_type_player,
    entity_type_enemy,
    entity_type_bullet
};

const unsigned char entity_size = 120U;

const unsigned char FE_PLAYER = 4;
const unsigned char FE_ENEMY = 64;
const unsigned char FE_BULLET = 32;

const unsigned char FE_ENGINE = 4;
const unsigned char FE_ENGINE_LO = 0;
const unsigned char FE_ENGINE_HI = 3;

#pragma data_seg(SpriteControlEnemies)
typedef struct {

    FP tx[64];
    FP ty[64];
    FP tdx[64];
    FP tdy[64];

    unsigned char aabb_min_x[64];
    unsigned char aabb_min_y[64];
    unsigned char aabb_max_x[64];
    unsigned char aabb_max_y[64];

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

#pragma data_seg(SpriteControlPlayer)

typedef struct {

    FP tx[4];
    FP ty[4];
    FP tdx[4];
    FP tdy[4];

    unsigned char aabb_min_x[4];
    unsigned char aabb_min_y[4];
    unsigned char aabb_max_x[4];
    unsigned char aabb_max_y[4];

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

#pragma data_seg(SpriteControlEngine)

typedef struct {

    unsigned char used[4];

    unsigned char wait_animation[4];
    unsigned char speed_animation[4];
    unsigned char state_animation[4];

    Sprite* sprite_type[4];
    vera_sprite_offset sprite_offset[4];

} fe_engine_t;

fe_engine_t engine;

#pragma data_seg(SpriteControlBullets)

typedef struct {

    FP tx[32];
    FP ty[32];
    FP tdx[32];
    FP tdy[32];

    unsigned char aabb_min_x[32];
    unsigned char aabb_min_y[32];
    unsigned char aabb_max_x[32];
    unsigned char aabb_max_y[32];

    unsigned char used[32];

    unsigned char type[32];
    unsigned char side[32];

    unsigned char move[32];
    unsigned char moved[32];
    unsigned char enabled[32];

    unsigned char step[32];
    unsigned int flight[32];
    unsigned char delay[32];

    unsigned char angle[32];
    unsigned char speed[32];
    unsigned char turn[32];
    unsigned char radius[32];
    unsigned char baseangle[32];

    unsigned char reload[32];
    unsigned char health[32];

    unsigned char wait_animation[32];
    unsigned char speed_animation[32];
    unsigned char state_animation[32];

    Sprite* sprite_type[32];
    vera_sprite_offset sprite_offset[32];

} fe_bullet_t;

fe_bullet_t bullet;

#pragma data_seg(Data)


volatile unsigned char enemy_pool;
volatile unsigned char player_pool;
volatile unsigned char engine_pool;
volatile unsigned char bullet_pool;

void Logic();
// void Draw();

void sprite_animate(vera_sprite_offset sprite_offset, Sprite* sprite, byte index, byte animate);
void sprite_position(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y);
void sprite_configure(vera_sprite_offset sprite_offset, Sprite* sprite);
void sprite_enable(vera_sprite_offset sprite_offset, Sprite* sprite);
void sprite_disable(vera_sprite_offset sprite_offset);
void sprite_collision(vera_sprite_offset sprite_offset, byte mask);


#endif