
unsigned char const FLOOR_MAP_BANK_VRAM = 0;
unsigned int const  FLOOR_MAP_OFFSET_VRAM = 0x0000;
unsigned long const FLOOR_MAP_ADDRESS_VRAM = 0x00000;

unsigned char const FLOOR_TILE_BANK_VRAM = 0;
unsigned int const  FLOOR_TILE_OFFSET_VRAM = 0x2000;
unsigned long const FLOOR_TILE_ADDRESS_VRAM = 0x02000;


struct Tile {
    char File[16];
    byte TileCount;
    byte TileOffset;
    word TotalSize;
    word TileSize;
    byte PaletteOffset; 
    heap_handle BRAM_Handle;
};



const byte TILE_FLOOR01_COUNT = 30;
struct Tile TileFloor01 =       { "FLOOR01", TILE_FLOOR01_COUNT, 0, 32*32*TILE_FLOOR01_COUNT, 1024, 0, 0x0 };

byte const TILE_TYPES = 1;
__mem struct Tile *TileDB[1] = { &TileFloor01 };

struct TilePart {
    struct Tile *Tile;
    word TileOffset;
    heap_handle VRAM_Handle;
};

struct TilePart TilePartDB[30] = {
    { &TileFloor01, 00*4, 0x00 }, // 00
    { &TileFloor01, 01*4, 0x00 }, // 01
    { &TileFloor01, 02*4, 0x00 }, // 02
    { &TileFloor01, 03*4, 0x00 }, // 03
    { &TileFloor01, 04*4, 0x00 }, // 04
    { &TileFloor01, 05*4, 0x00 }, // 05
    { &TileFloor01, 06*4, 0x00 }, // 06
    { &TileFloor01, 07*4, 0x00 }, // 07
    { &TileFloor01, 08*4, 0x00 }, // 08
    { &TileFloor01, 09*4, 0x00 }, // 09
    { &TileFloor01, 10*4, 0x00 }, // 10
    { &TileFloor01, 11*4, 0x00 }, // 11
    { &TileFloor01, 12*4, 0x00 }, // 12
    { &TileFloor01, 13*4, 0x00 }, // 13
    { &TileFloor01, 14*4, 0x00 }, // 14
    { &TileFloor01, 15*4, 0x00 }, // 15
    { &TileFloor01, 16*4, 0x00 }, // 16
    { &TileFloor01, 17*4, 0x00 }, // 17
    { &TileFloor01, 18*4, 0x00 }, // 18
    { &TileFloor01, 19*4, 0x00 }, // 19
    { &TileFloor01, 20*4, 0x00 }, // 20
    { &TileFloor01, 21*4, 0x00 }, // 21
    { &TileFloor01, 22*4, 0x00 }, // 22
    { &TileFloor01, 23*4, 0x00 }, // 23
    { &TileFloor01, 24*4, 0x00 }, // 24
    { &TileFloor01, 25*4, 0x00 }, // 25
    { &TileFloor01, 26*4, 0x00 }, // 26
    { &TileFloor01, 27*4, 0x00 }, // 27
    { &TileFloor01, 28*4, 0x00 }, // 28
    { &TileFloor01, 29*4, 0x00 } // 29
};


struct TileSegment {
    byte Weight;
    byte Composition[4];
};

struct TileSegment TileSegmentDB[16] = {
    { 16, { 00, 00, 00, 00 } }, // 00 -  
    { 02, { 00, 00, 03, 00 } }, // 01 - 
    { 02, { 00, 00, 00, 01 } }, // 02 - 
    { 12, { 00, 00, 02, 02 } }, // 03 - 
    { 02, { 00, 06, 00, 08 } }, // 04 - 
    { 02, { 00, 06, 03, 08 } }, // 05 - 
    { 12, { 00, 04, 00, 04 } }, // 06 - 
    { 02, { 00, 14, 02, 18 } }, // 07 - 
    { 02, { 07, 00, 08, 00 } }, // 08 - 
    { 12, { 05, 00, 05, 00 } }, // 09 - 
    { 02, { 07, 00, 08, 01 } }, // 10 -
    { 02, { 13, 00, 16, 02 } }, // 11 -
    { 12, { 11, 11, 08, 08 } }, // 12 -
    { 02, { 10, 11, 13, 08 } }, // 13 -
    { 02, { 11, 12, 09, 14 } }, // 14 -
    { 16, { 15, 15, 15, 15 } }  // 15 -
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
    { 12, 3, { 06, 09, 00 } },
    { 16, 1, { 15 } }
};

// Work variables

byte const TILE_FLOOR_COUNT = TILE_FLOOR01_COUNT; 

byte const TILES = 16; 
volatile unsigned char TileFloorBufferNew[TILES];
volatile unsigned char TileFloorBufferOld[TILES];
volatile unsigned char* TileFloor;
volatile unsigned char* TileFloorNew = TileFloorBufferNew;
volatile unsigned char* TileFloorOld = TileFloorBufferOld;

// This is a performance improvement tactic.
#define FLOOR_MAP_OFFSET_VRAM_SRC_64 FLOOR_MAP_OFFSET_VRAM+(31+32)*64*2
#define FLOOR_MAP_OFFSET_VRAM_DST_32 FLOOR_MAP_OFFSET_VRAM+31*64*2
volatile unsigned int tilerowsrc = FLOOR_MAP_OFFSET_VRAM_SRC_64;
volatile unsigned int tilerowdst = FLOOR_MAP_OFFSET_VRAM_DST_32;

