#pragma once

#include <cx16-bramheap-lib.h>
// #include <cx16-vera.h>
// #include <cx16-veralib.h>
#include <fp3.h>
#include <ht.h>
#include <lru-cache-lib.h>

#include "equinoxe-flightengine-types.h"

const unsigned char FE_CACHE = 16;


#define FLIGHT_PLAYER       (0x01)
#define FLIGHT_ENEMY        (0x02)
#define FLIGHT_TOWER        (0x04)
#define FLIGHT_BULLET       (0x08)
#define FLIGHT_ENGINE       (0x10)
#define FLIGHT_EXPLOSION    (0x20)
#define FLIGHT_MASK         (0x2F)

#define SIDE_ENEMY          (0x01)
#define SIDE_PLAYER         (0x02)
#define SIDE_SCENERY        (0x04)


extern flight_t flight;

extern fe_sprite_cache_t sprite_cache;
// extern lru_cache_table_t sprite_cache_vram;

extern vera_sprite_offset flight_sprite_offsets[127];

flight_index_t flight_add(flight_type_t type, flight_side_t side, sprite_index_t sprite);
void flight_remove(flight_index_t f);


fe_sprite_index_t fe_sprite_cache_copy(sprite_index_t sprite_bram);
void fe_sprite_cache_free(unsigned char s);
vera_sprite_image_offset sprite_image_cache_vram(fe_sprite_index_t fe_sprite_index,  unsigned char fe_sprite_image_index);

vera_sprite_offset flight_sprite_next_offset();
void flight_sprite_free_offset(vera_sprite_offset sprite_offset);


unsigned int fe_sprite_bram_load(sprite_index_t sprite, unsigned int sprite_offset);

void fe_sprite_configure(vera_sprite_offset sprite_offset, fe_sprite_index_t s);

