

#pragma data_seg(Data)

// todo to make obscolete through dynamic loading
#define TILE_FLOOR_COUNT 22

// The tile size is fixed in this game for the floor objects to 16x16 at 4pp.
#define FLOOR_TILE_SIZE 128

extern floor_layer_t floor_layer[2];

extern floor_cache_t floor_cache[FLOOR_CACHE_LAYERS*FLOOR_CACHE_ROWS*FLOOR_CACHE_COLUMNS];


void floor_init();

unsigned char FLOOR_CACHE(unsigned char layer, unsigned char row, unsigned char column);

void floor_paint(unsigned char row, unsigned char column);

void floor_draw_clear(unsigned char layer, floor_t* floor);
void floor_clear_row(unsigned char layer, floor_t* floor, unsigned char x, unsigned char y);
void floor_draw_row(unsigned char layer, floor_t* floor, unsigned char row, unsigned char column);

void floor_draw_background(unsigned char layer, floor_t* floor);
void floor_paint_background(unsigned char layer, floor_t* floor);

void floor_part_memset_vram(unsigned char part, floor_t* floor, vera_heap_segment_index_t segment, unsigned char pattern);
void floor_part_memcpy_vram_bram(unsigned char part, floor_t* floor, vera_heap_segment_index_t segment);
unsigned int floor_parts_load_bram(unsigned int part, floor_t* floor, floor_bram_tiles_t * floor_bram_tile); 


