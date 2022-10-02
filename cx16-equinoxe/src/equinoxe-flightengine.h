#include <cx16-heap-bram-fb.h>
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
extern fe_sprite_cache_t sprite_cache;

extern vera_sprite_offset sprite_offsets[127];


void fe_init(bram_bank_t bram_bank);

fe_sprite_index_t fe_sprite_cache_copy(sprite_bram_t* sprite_bram);
void fe_sprite_cache_free(unsigned char s);
vera_sprite_image_offset sprite_image_cache_vram(fe_sprite_index_t fe_sprite_index,  unsigned char fe_sprite_image_index);

vera_sprite_offset NextOffset(vera_sprite_id sprite_start, vera_sprite_id sprite_end, vera_sprite_id* sprite_id, unsigned char* count);
void FreeOffset(vera_sprite_offset sprite_offset, unsigned char* count);


unsigned int fe_sprite_bram_load(sprite_bram_t* sprite, unsigned int sprite_offset);

void fe_sprite_configure(vera_sprite_offset sprite_offset, fe_sprite_index_t s);

