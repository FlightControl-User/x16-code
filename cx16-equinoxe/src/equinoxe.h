#include "equinoxe-bank.h"

// #define __NOVSYNC

#define __CPULINES
// #define __FILE

#define __PALETTE

// #define __FLOOR

#define __FLIGHT
#define __STAGE
#define __COLLISION

#define __PLAYER
#define __BULLET
#define __ENEMY
#define __ENGINE

#define __CACHE_DEBUG
#define __LRU_CACHE_DEBUG
// #define __WAVE_DEBUG
// #define __ENGINE_DEBUG
// #define __FLOOR_DEBUG

// #define __HEAP_DEBUG

const vera_heap_segment_index_t VERA_HEAP_SEGMENT_TILES = 0;
const vera_heap_segment_index_t VERA_HEAP_SEGMENT_SPRITES = 1;

extern lru_cache_table_t sprite_cache_vram;
