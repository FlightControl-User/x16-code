



// const byte TILE_FLOOR01_COUNT = 30;
// tile_t TileFloor01 = { 
//     "floor01.bin", 
//     TILE_FLOOR01_COUNT, 
//     0, 
//     32*32*TILE_FLOOR01_COUNT, 
//     1024, 
//     0, 
//     { 0 }, { 0 } 
// };

// #define TILE_TYPES  1
// tile_t* const TileDB[1] = { &TileFloor01 };


// floor_parts_t TilePartDB = {
//     { 
//         &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, 
//         &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, 
//         &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, 
//         &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01
//     }, 
//     {
//         00*4, 01*4, 02*4, 03*4, 04*4, 05*4, 06*4, 07*4, 
//         08*4, 09*4, 10*4, 11*4, 12*4, 13*4, 14*4, 15*4, 
//         16*4, 17*4, 18*4, 19*4, 20*4, 21*4, 22*4, 23*4, 
//         24*4, 25*4, 26*4, 27*4, 28*4, 29*4
//     }
// };

// struct TileComposition {
//     byte segment[4];
// };

// struct TileSegment {
//     byte weight[64];
//     byte composition[256];
// };

// struct TileSegment TileSegmentDB = {
//     { 
//         16, 02, 
//         02, 12, 
//         02, 02, 
//         12, 02,   
//         02, 12,   
//         02, 02,  
//         12, 02,  
//         02, 16
//     },  
//     {
//         00, 00, 00, 00, 00, 00, 04, 00,
//         00, 00, 00, 01, 00, 00, 02, 02,
//         00, 06, 00, 08, 00, 06, 03, 08,
//         00, 04, 00, 04, 00, 14, 02, 18, 
//         07, 00, 08, 00, 05, 00, 05, 00,
//         07, 00, 08, 01, 13, 00, 16, 02,
//         11, 11, 08, 08, 10, 11, 13, 08,
//         11, 12, 09, 14, 15, 15, 15, 15
//     }
// };

// struct TileWeight {
//     byte Weight;
//     byte Count;
//     byte TileSegment[15];
// };

// byte const TILE_WEIGHTS = 5;
// struct TileWeight TileWeightDB[5] = {
//     { 5, 4, { 10, 11, 13, 14 } },
//     { 8, 2, { 03, 12 } },
//     { 9, 2, { 06, 09 } },
//     { 10, 6, { 01, 02, 04, 05, 07, 08 } },
//     { 15, 1, { 15 } }
// };

// Work variables


// typedef struct {
//     char floortile[16];
// } tilefloor_t;


#pragma data_seg(Data)

unsigned char const TILES = 16;

// todo to make obscolete through dynamic loading
#define TILE_FLOOR_COUNT 22

// The tile size is fixed in this game for the floor objects to 16x16 at 4pp.
#define FLOOR_TILE_SIZE 128

__mem volatile unsigned char TileFloorIndex = 0;
__mem volatile tilefloor_t TileFloor[2];

// This is a performance improvement tactic.
unsigned char const FLOOR_SCROLL_START = 32*16; // 32 rows of 16 lines (the height of the tiles is 16 pixels).
unsigned char const FLOOR_ROW_63 = 63;
unsigned char const FLOOR_TILE_ROW_31 = 31;
unsigned char const FLOOR_TILE_COLUMN_16 = 16;
unsigned int const FLOOR_CPY_MAP_63 = FLOOR_MAP_OFFSET_VRAM+(FLOOR_ROW_63+1)*64*2;
unsigned int const FLOOR_CPY_MAP_31 = FLOOR_MAP_OFFSET_VRAM+(FLOOR_TILE_ROW_31+1)*64*2;

__mem volatile unsigned int floor_cpy_map_dst = FLOOR_CPY_MAP_63;
__mem volatile unsigned int floor_cpy_map_src = FLOOR_CPY_MAP_31;
__mem volatile unsigned char floor_tile_row = FLOOR_TILE_ROW_31;
__mem volatile unsigned char floor_tile_column = 16;

__mem volatile unsigned int floor_scroll_vertical = 16*32;
__mem volatile unsigned char floor_scroll_action = 2;


void floor_init();
void floor_paint_clear();

void floor_paint_background(floor_t* floor);
void floor_paint_tiles(floor_t* floor_segment, unsigned char row, unsigned char column);

void floor_vram_copy(unsigned char part, floor_t* floor, vera_heap_segment_index_t segment); 
unsigned int floor_bram_load(unsigned int part, floor_t* floor, floor_bram_tiles_t * floor); 


