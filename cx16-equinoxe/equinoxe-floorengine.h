
#pragma data_seg(TileControl)

unsigned char const FLOOR_MAP_BANK_VRAM = 0;
unsigned int const  FLOOR_MAP_OFFSET_VRAM = 0x0000;
unsigned long const FLOOR_MAP_ADDRESS_VRAM = 0x00000;

unsigned char const FLOOR_TILE_BANK_VRAM = 0;
unsigned int const  FLOOR_TILE_OFFSET_VRAM = 0x2000;
unsigned long const FLOOR_TILE_ADDRESS_VRAM = 0x02000;


typedef struct {
    char File[16];
    byte TileCount;
    byte TileOffset;
    word TotalSize;
    word TileSize;
    byte PaletteOffset; 
    heap_handle handle_bram[64];
} tile_t;



const byte TILE_FLOOR01_COUNT = 30;
tile_t TileFloor01 = { 
    "floor01", 
    TILE_FLOOR01_COUNT, 
    0, 
    32*32*TILE_FLOOR01_COUNT, 
    1024, 
    0, 
    {0x0} 
};

byte const TILE_TYPES = 1;
__mem tile_t *TileDB[1] = { &TileFloor01 };

struct TilePart {
    tile_t *Tile[64];
    word TileOffset[64];
};

struct TilePart TilePartDB = {
    { 
        &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, 
        &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, 
        &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, 
        &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01, &TileFloor01
    }, 
    {
        00*4, 01*4, 02*4, 03*4, 04*4, 05*4, 06*4, 07*4, 
        08*4, 09*4, 10*4, 11*4, 12*4, 13*4, 14*4, 15*4, 
        16*4, 17*4, 18*4, 19*4, 20*4, 21*4, 22*4, 23*4, 
        24*4, 25*4, 26*4, 27*4, 28*4, 29*4
    }
};

struct TileComposition {
    byte segment[4];
};

struct TileSegment {
    byte weight[64];
    byte composition[256];
};

struct TileSegment TileSegmentDB = {
    { 
        16, 02, 
        02, 12, 
        02, 02, 
        12, 02,   
        02, 12,   
        02, 02,  
        12, 02,  
        02, 16
    },  
    {
        00, 00, 00, 00, 00, 00, 03, 00,
        00, 00, 00, 01, 00, 00, 02, 02,
        00, 06, 00, 08, 00, 06, 03, 08,
        00, 04, 00, 04, 00, 14, 02, 18, 
        07, 00, 08, 00, 05, 00, 05, 00,
        07, 00, 08, 01, 13, 00, 16, 02,
        11, 11, 08, 08, 10, 11, 13, 08,
        11, 12, 09, 14, 15, 15, 15, 15
    }
};

struct TileWeight {
    byte Weight;
    byte Count;
    byte TileSegment[10];
};

byte const TILE_WEIGHTS = 5;
struct TileWeight TileWeightDB[5] = {
    { 01, 6, { 01, 02, 04, 05, 07, 08 } },
    { 04, 4, { 10, 11, 13, 14 } },
    { 08, 2, { 03, 12 } },
    { 12, 2, { 06, 09 } },
    { 16, 1, { 15 } }
};

// Work variables

unsigned char const TILE_FLOOR_COUNT = TILE_FLOOR01_COUNT; 

unsigned char const TILES = 16; 
volatile unsigned char TileFloorIndex = 0;
typedef struct {
    char floortile[16];
} tilefloor_t;

volatile tilefloor_t TileFloor[2];

// This is a performance improvement tactic.
unsigned char const ROW_BOTTOM = 63;
unsigned char const ROW_MIDDLE = 31;
unsigned int const FLOOR_MAP_OFFSET_VRAM_DST_63 = FLOOR_MAP_OFFSET_VRAM+(ROW_BOTTOM+1)*64*2;
unsigned int const FLOOR_MAP_OFFSET_VRAM_SRC_31 = FLOOR_MAP_OFFSET_VRAM+(ROW_MIDDLE+1)*64*2;
volatile unsigned int tilerowdst = FLOOR_MAP_OFFSET_VRAM_DST_63;
volatile unsigned int tilerowsrc = FLOOR_MAP_OFFSET_VRAM_SRC_31;
volatile unsigned char row = ROW_MIDDLE;
volatile unsigned char column = 16;

#pragma data_seg(Data)

void vera_tile_cell(unsigned char row, unsigned char column);
void tile_cpy_vram_from_bram(tile_t *tile, heap_handle handle_vram);
void tile_load(tile_t *tile);


