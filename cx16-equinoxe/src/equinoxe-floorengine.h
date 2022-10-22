

#pragma data_seg(Data)

unsigned char const TILES = 16;

// todo to make obscolete through dynamic loading
#define TILE_FLOOR_COUNT 22

// The tile size is fixed in this game for the floor objects to 16x16 at 4pp.
#define FLOOR_TILE_SIZE 128

// This is a performance improvement tactic.
unsigned int const FLOOR_SCROLL_START = 32*16; // 32 rows of 16 lines (the height of the tiles is 16 pixels).
unsigned char const FLOOR_ROW_63 = 63;
unsigned char const FLOOR_TILE_ROW_31 = 31;
unsigned char const FLOOR_TILE_COLUMN_16 = 16;
unsigned int const FLOOR_CPY_MAP_63 = FLOOR_MAP0_OFFSET_VRAM+(FLOOR_ROW_63+1)*64*2;
unsigned int const FLOOR_CPY_MAP_31 = FLOOR_MAP0_OFFSET_VRAM+(FLOOR_TILE_ROW_31+1)*64*2;

__mem volatile unsigned int floor_cpy_map_dst = FLOOR_CPY_MAP_63;
__mem volatile unsigned int floor_cpy_map_src = FLOOR_CPY_MAP_31;
__mem volatile unsigned char floor_tile_row = FLOOR_TILE_ROW_31;
__mem volatile unsigned char floor_tile_column = 16;


void floor_init();

unsigned char FLOOR_CACHE(unsigned char layer, unsigned char row, unsigned char column);

void floor_paint(unsigned char row, unsigned char column);

void floor_draw_clear(unsigned char layer, floor_t* floor);
void floor_clear_row(unsigned char layer, floor_t* floor, unsigned char x, unsigned char y);
void floor_draw_row(unsigned char layer, floor_t* floor, unsigned char row, unsigned char column);

void floor_draw_background(unsigned char layer, floor_t* floor);
void floor_paint_background(unsigned char layer, floor_t* floor);

void floor_vram_copy(unsigned int part, floor_t* floor, vera_heap_segment_index_t segment); 
unsigned int floor_bram_load(unsigned int part, floor_t* floor, floor_bram_tiles_t * floor); 


