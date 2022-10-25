#include "equinoxe-bank.h"
#include <lru-cache.h>
#include "equinoxe-types.h"

#define VERA_HEAP_SEGMENT_TILES     (vera_heap_segment_index_t)0
#define VERA_HEAP_SEGMENT_SPRITES   (vera_heap_segment_index_t)1

// todo move to flightengine
extern lru_cache_table_t sprite_cache_vram;

extern equinoxe_game_t game;
