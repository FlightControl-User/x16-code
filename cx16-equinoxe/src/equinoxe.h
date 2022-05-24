#include "equinoxe-bank.h"

volatile unsigned int floor_scroll_vertical = 16*32;
volatile signed int prev_mousex = 0;
volatile signed int prev_mousey = 0;
volatile unsigned char floor_scroll_action = 2;

const vera_heap_segment_index_t VERA_HEAP_SEGMENT_TILES = 0;
const vera_heap_segment_index_t VERA_HEAP_SEGMENT_SPRITES = 1;