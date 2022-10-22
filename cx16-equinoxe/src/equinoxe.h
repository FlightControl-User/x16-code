#include "equinoxe-bank.h"
#include <lru-cache.h>
#include "equinoxe-types.h"


extern unsigned char volatile floor_index;
extern volatile floor_cache_t floor_cache[FLOOR_CACHE_LAYERS*FLOOR_CACHE_ROWS*FLOOR_CACHE_COLUMNS];


const vera_heap_segment_index_t VERA_HEAP_SEGMENT_TILES = 0;
const vera_heap_segment_index_t VERA_HEAP_SEGMENT_SPRITES = 1;

extern lru_cache_table_t sprite_cache_vram;

extern equinoxe_game_t game;
