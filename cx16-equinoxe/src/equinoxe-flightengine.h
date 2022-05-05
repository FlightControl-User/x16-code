#ifndef equinoxe_flightengine_h
#define equinoxe_flightengine_h

#include <cx16-fb.h>
#include <cx16-vera.h>
#include <cx16-veralib.h>
#include <fp3.h>
#include <ht.h>

#include "equinoxe-flightengine-types.h"

// #include "equinoxe-enemy.h"

// #pragma data_seg(sprite_t)

#pragma data_seg(SpriteControl)

#define SPRITE_PLAYER01_COUNT 7

sprite_t SpritePlayer01 =       { 
    "player01.bin", 
    SPRITE_PLAYER01_COUNT, 
    0, 32*32*SPRITE_PLAYER01_COUNT/2, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 0, 
    0, {2,2,32-2,32-2}, {0x0}, {0x0} 
};
heap_handle sprite_player_01[SPRITE_PLAYER01_COUNT];

#define SPRITE_ENEMY01_COUNT 12
sprite_t SpriteEnemy01 =       { 
    "enemy01.bin", SPRITE_ENEMY01_COUNT, 
    7, 32*32*SPRITE_ENEMY01_COUNT/2, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 1, 
    0, {2,2,32-2,32-2}, {0x0}, { 0x0 } 
};
heap_handle sprite_enemy_01[SPRITE_ENEMY01_COUNT];

#define SPRITE_ENEMY03_COUNT 6
sprite_t SpriteEnemy03 =       { 
    "enemy03.bin", SPRITE_ENEMY03_COUNT, 
    7+12, 32*32*SPRITE_ENEMY03_COUNT/2, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 2, 
    1, {6,5,25,26}, {0x0}, {0x0} 
};
heap_handle sprite_enemy_03[SPRITE_ENEMY03_COUNT];

#define SPRITE_ENGINE01_COUNT 16
sprite_t SpriteEngine01 =       { 
    "engine01.bin", SPRITE_ENGINE01_COUNT, 
    7+12+6, 16*16*SPRITE_ENGINE01_COUNT/2, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 3, 
    0, {0,0,0,0}, {0x0}, { 0x0 } 
};
heap_handle sprite_engine_01[SPRITE_ENGINE01_COUNT];

#define SPRITE_BULLET01_COUNT 1
sprite_t SpriteBullet01 =       { 
    "bullet01.bin", SPRITE_BULLET01_COUNT, 
    7+12+16+16, 16*16*SPRITE_BULLET01_COUNT/2, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 3, 
    0, {0,0,1,4}, {0x0}, { 0x0 } };
heap_handle sprite_bullet_01[SPRITE_BULLET01_COUNT];

#define SPRITE_BULLET02_COUNT 1
sprite_t SpriteBullet02 =       { 
    "bullet02.bin", SPRITE_BULLET02_COUNT, 
    7+12+16+16+1, 16*16*SPRITE_BULLET02_COUNT/2, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 5, 
    0, {0,0,1,4}, {0x0}, { 0x0 } };
heap_handle sprite_bullet_02[SPRITE_BULLET02_COUNT];

byte const SPRITE_TYPES = 6;
byte const SPRITE_PLAYER01 = 0;
byte const SPRITE_ENEMY01 = 1;
byte const SPRITE_ENEMY03 = 2;
byte const SPRITE_ENGINE01 = 3;
byte const SPRITE_BULLET01 = 4;
byte const SPRITE_BULLET02 = 5;

sprite_t *SpriteDB[SPRITE_TYPES] = { 
    &SpritePlayer01, 
    &SpriteEnemy01, 
    &SpriteEnemy03, 
    &SpriteEngine01, 
    &SpriteBullet01, 
    &SpriteBullet02 
    };



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




volatile unsigned char enemy_pool;
volatile unsigned char player_pool;
volatile unsigned char engine_pool;
volatile unsigned char bullet_pool;

volatile unsigned char bullet_count = 0;
volatile unsigned char player_count = 0;

void Logic();
// void Draw();

void sprite_animate(vera_sprite_offset sprite_offset, sprite_t* sprite, byte index, byte animate);
void sprite_position(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y);
void sprite_configure(vera_sprite_offset sprite_offset, sprite_t* sprite);
void sprite_palette(vera_sprite_offset sprite_offset, unsigned char bram_index);
void sprite_enable(vera_sprite_offset sprite_offset, sprite_t* sprite);
void sprite_disable(vera_sprite_offset sprite_offset);
void sprite_collision(vera_sprite_offset sprite_offset, byte mask);


#endif
