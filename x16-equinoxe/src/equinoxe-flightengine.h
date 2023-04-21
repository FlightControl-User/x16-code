#include <cx16-bramheap-lib.h>
#include <cx16-vera.h>
#include <cx16-veralib.h>
#include <fp3.h>
#include <ht.h>
#include <lru-cache-lib.h>

#include "equinoxe-flightengine-types.h"


const unsigned char FE_PLAYER = 4;
const unsigned char FE_ENEMY = 64;
const unsigned char FE_BULLET = 32;
const unsigned char FE_ENGINE = 4;
const unsigned char FE_CACHE = 16;



extern fe_t fe; // used for storing the positions of the control blocks pools.

extern fe_player_t player;
extern fe_engine_t engine;
extern fe_enemy_t enemy;
extern fe_sprite_cache_t sprite_cache;
// extern lru_cache_table_t sprite_cache_vram;

extern vera_sprite_offset sprite_offsets[127];


fe_sprite_index_t fe_sprite_cache_copy(sprite_index_t sprite_bram);
void fe_sprite_cache_free(unsigned char s);
vera_sprite_image_offset sprite_image_cache_vram(fe_sprite_index_t fe_sprite_index,  unsigned char fe_sprite_image_index);

vera_sprite_offset sprite_next_offset();
void sprite_free_offset(vera_sprite_offset sprite_offset);


unsigned int fe_sprite_bram_load(sprite_index_t sprite, unsigned int sprite_offset);

void fe_sprite_configure(vera_sprite_offset sprite_offset, fe_sprite_index_t s);

