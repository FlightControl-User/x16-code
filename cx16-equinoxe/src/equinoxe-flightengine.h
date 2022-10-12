#include <cx16-heap-bram-fb.h>
#include <cx16-vera.h>
#include <cx16-veralib.h>
#include <fp3.h>
#include <ht.h>

#include "equinoxe-flightengine-types.h"

// #pragma data_seg(sprite_t)

// #pragma data_seg(SpriteControl)


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


void fe_init();

fe_sprite_index_t fe_sprite_cache_copy(sprite_bram_t* sprite_bram);
void fe_sprite_cache_free(unsigned char s);
vera_sprite_image_offset sprite_image_cache_vram(fe_sprite_index_t fe_sprite_index,  unsigned char fe_sprite_image_index);

vera_sprite_offset NextOffset(vera_sprite_id sprite_start, vera_sprite_id sprite_end, vera_sprite_id* sprite_id, unsigned char* count);
void FreeOffset(vera_sprite_offset sprite_offset, unsigned char* count);


unsigned int fe_sprite_bram_load(sprite_bram_t* sprite, unsigned int sprite_offset);

void fe_sprite_configure(vera_sprite_offset sprite_offset, fe_sprite_index_t s);

