#ifndef equinoxe_flightengine_h
#define equinoxe_flightengine_h

#include <cx16-fb.h>
#include <cx16-vera.h>
#include <cx16-veralib.h>
#include <fp3.h>
#include <ht.h>

#include "equinoxe-flightengine-types.h"

// #pragma data_seg(sprite_t)

#pragma data_seg(SpriteControl)

#define SPRITE_PLAYER01_COUNT 7
#define SPRITE_ENEMY01_COUNT 12
#define SPRITE_ENEMY03_COUNT 6
#define SPRITE_ENGINE01_COUNT 16
#define SPRITE_BULLET01_COUNT 1
#define SPRITE_BULLET02_COUNT 1


// vera_heap_index_t player01_vera_heap_index[SPRITE_PLAYER01_COUNT];
// vera_heap_index_t enemy01_vera_heap_index[SPRITE_ENEMY01_COUNT];
// vera_heap_index_t enemy03_vera_heap_index[SPRITE_ENEMY03_COUNT];
// vera_heap_index_t engine01_vera_heap_index[SPRITE_ENGINE01_COUNT];
// vera_heap_index_t bullet01_vera_heap_index[SPRITE_BULLET01_COUNT];
// vera_heap_index_t bullet02_vera_heap_index[SPRITE_BULLET02_COUNT];

// vera_sprite_image_offset player01_vram_image_offset[SPRITE_PLAYER01_COUNT];
// vera_sprite_image_offset enemy01_vram_image_offset[SPRITE_ENEMY01_COUNT];
// vera_sprite_image_offset enemy03_vram_image_offset[SPRITE_ENEMY03_COUNT];
// vera_sprite_image_offset engine01_vram_image_offset[SPRITE_ENGINE01_COUNT];
// vera_sprite_image_offset bullet01_vram_image_offset[SPRITE_BULLET01_COUNT];
// vera_sprite_image_offset bullet02_vram_image_offset[SPRITE_BULLET02_COUNT];


sprite_t SpritePlayer01 =       { 
    "player01.bin", SPRITE_PLAYER01_COUNT, 
    32*32*SPRITE_PLAYER01_COUNT/2, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 0, 
    0, {2,2,32-2,32-2}, 0, 
    {0x0}, {0x0}, {0x0} 
    // &player01_vera_heap_index, &player01_vram_image_offset 
};

sprite_t SpriteEnemy01 =       { 
    "enemy01.bin", SPRITE_ENEMY01_COUNT, 
    32*32*SPRITE_ENEMY01_COUNT/2, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 1, 
    0, {2,2,32-2,32-2}, 0, 
    {0x0}, {0x0}, {0x0} 
    // &enemy01_vera_heap_index, &enemy01_vram_image_offset 
};

sprite_t SpriteEnemy03 =       { 
    "enemy03.bin", SPRITE_ENEMY03_COUNT, 
    32*32*SPRITE_ENEMY03_COUNT/2, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 2, 
    1, {6,5,25,26}, 0, 
    {0x0}, {0x0}, {0x0} 
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

sprite_t SpriteEngine01 =       { 
    "engine01.bin", SPRITE_ENGINE01_COUNT, 
    16*16*SPRITE_ENGINE01_COUNT/2, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 3, 
    0, {0,0,0,0}, 0, 
    {0x0}, {0x0}, {0x0} 
    // &engine01_vera_heap_index, &engine01_vram_image_offset 
};

sprite_t SpriteBullet01 =       { 
    "bullet01.bin", SPRITE_BULLET01_COUNT, 
    16*16*SPRITE_BULLET01_COUNT/2, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 4, 
    0, {0,0,1,4}, 0, 
    {0x0}, {0x0}, {0x0} 
    // &bullet01_vera_heap_index, &bullet01_vram_image_offset 
};

#define SPRITE_BULLET02_COUNT 1
sprite_t SpriteBullet02 =       { 
    "bullet02.bin", SPRITE_BULLET02_COUNT, 
    16*16*SPRITE_BULLET02_COUNT/2, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 5, 
    0, {0,0,1,4}, 0, 
    {0x0}, {0x0}, {0x0} 
    // &bullet02_vera_heap_index, &bullet02_vram_image_offset 
};

byte const SPRITE_TYPES = 6;

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



extern fe_t fe; // used for storing the positions of the control blocks pools.

void Logic();
// void Draw();

void fe_init(bram_bank_t bram_bank);

// void sprite_animate(vera_sprite_offset sprite_offset, sprite_t* sprite, byte index, byte animate);
void sprite_position(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y);
void sprite_configure(vera_sprite_offset sprite_offset, sprite_t* sprite);
void sprite_palette(vera_sprite_offset sprite_offset, unsigned char bram_index);
void sprite_enable(vera_sprite_offset sprite_offset, sprite_t* sprite);
void sprite_disable(vera_sprite_offset sprite_offset);
void sprite_collision(vera_sprite_offset sprite_offset, byte mask);

void sprite_vram_allocate(sprite_t* sprite, vera_heap_segment_index_t segment);
void sprite_vram_free(sprite_t* sprite, vera_heap_segment_index_t segment);

#endif
