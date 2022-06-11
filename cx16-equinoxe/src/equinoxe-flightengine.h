#include <cx16-fb.h>
#include <cx16-vera.h>
#include <cx16-veralib.h>
#include <fp3.h>
#include <ht.h>

#include "equinoxe-flightengine-types.h"

// #pragma data_seg(sprite_t)

// #pragma data_seg(SpriteControl)



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



const unsigned char FE_PLAYER = 4;
const unsigned char FE_ENEMY = 64;
const unsigned char FE_BULLET = 32;
const unsigned char FE_ENGINE = 4;
const unsigned char FE_CACHE = 16;



extern fe_t fe; // used for storing the positions of the control blocks pools.

extern fe_player_t player;
extern fe_engine_t engine;
extern fe_enemy_t enemy;
extern fe_bullet_t bullet;
extern fe_sprite_cache_t fe_sprite;

void fe_init(bram_bank_t bram_bank);

void fe_sprite_bram_load(sprite_bram_t* sprite);

// void sprite_animate(vera_sprite_offset sprite_offset, sprite_bram_t* sprite, byte index, byte animate);
void sprite_position(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y);
void fe_sprite_configure(vera_sprite_offset sprite_offset, fe_sprite_index_t s);
void sprite_enable(vera_sprite_offset sprite_offset, sprite_bram_t* sprite);
void sprite_disable(vera_sprite_offset sprite_offset);
void sprite_collision(vera_sprite_offset sprite_offset, byte mask);

fe_sprite_index_t fe_sprite_vram_allocate(sprite_bram_t* sprite_bram);
void fe_sprite_vram_free(unsigned char s);
