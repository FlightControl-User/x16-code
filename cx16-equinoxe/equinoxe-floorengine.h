
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



byte const TILE_FLOOR01_COUNT = 30;
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

// Glue the tile segments, in order to do fast selection of possible tile combinations and randomization.

struct TileGlue {
    byte CountGlue;
    byte *GlueSegment;
};


byte const GLN00[] = {09,07,06,05,11,25,24,23}; const struct TileGlue GSN00 = { 8, GLN00 };
byte const GLE00[] = {09,01,08,07,13,19,26,25}; const struct TileGlue GSE00 = { 8, GLE00 };
byte const GLS00[] = {09,01,02,03,15,19,20,21}; const struct TileGlue GSS00 = { 8, GLS00 };
byte const GLW00[] = {09,03,04,05,17,21,22,23}; const struct TileGlue GSW00 = { 8, GLW00 };

byte const GLN01[] = {00,02,16,15,14,34,33,32}; const struct TileGlue GSN01 = { 8, GLN01 };
byte const GLE01[] = {00,04,10,17,16,28,35,34}; const struct TileGlue GSE01 = { 8, GLE01 };
byte const GLS01[] = {00,06,10,11,12,28,29,30}; const struct TileGlue GSS01 = { 8, GLS01 };
byte const GLW01[] = {00,08,12,13,14,30,31,32}; const struct TileGlue GSW01 = { 8, GLW01 };

byte const GLN02[] = {18,20}; const struct TileGlue GSN02 = { 2, GLN02 };
byte const GLE02[] = {18,22}; const struct TileGlue GSE02 = { 2, GLE02 };
byte const GLS02[] = {18,24}; const struct TileGlue GSS02 = { 2, GLS02 };
byte const GLW02[] = {18,26}; const struct TileGlue GSW02 = { 2, GLW02 };

byte const GLN03[] = {27,29}; const struct TileGlue GSN03 = { 2, GLN03 };
byte const GLE03[] = {27,31}; const struct TileGlue GSE03 = { 2, GLE03 };
byte const GLS03[] = {27,33}; const struct TileGlue GSS03 = { 2, GLS03 };
byte const GLW03[] = {27,35}; const struct TileGlue GSW03 = { 2, GLW03 };

byte const GLN10[] = (byte*)0x00;             const struct TileGlue GSN10 = { 0, 0x00 };
byte const GLE10[] = {02,03,15,14};    const struct TileGlue GSE10 = { 4, GLE10 };
byte const GLS10[] = (byte*)0x00;             const struct TileGlue GSS10 = { 0, 0x00 };
byte const GLW10[] = {01,02,16,15};    const struct TileGlue GSW10 = { 4, GLW10 };

byte const GLN11[] = {03,04,10,17};    const struct TileGlue GSN11 = { 4, GLN11 };
byte const GLE11[] = (byte*)0x00;             const struct TileGlue GSE11 = { 0, 0x00 };
byte const GLS11[] = {04,05,17,16};    const struct TileGlue GSS11 = { 4, GLS11 };
byte const GLW11[] = (byte*)0x00;             const struct TileGlue GSW11 = { 0, 0x00 };

byte const GLN12[] = (byte*)0x00;             const struct TileGlue GSN12 = { 0, 0x00 };
byte const GLE12[] = {05,06,12,11};    const struct TileGlue GSE12 = { 4, GLE12 };
byte const GLS12[] = (byte*)0x00;             const struct TileGlue GSS12 = { 0, 0x00 };
byte const GLW12[] = {07,06,10,11};    const struct TileGlue GSW12 = { 4, GLW12 };

byte const GLN13[] = {01,08,12,13};    const struct TileGlue GSN13 = { 4, GLN13 };
byte const GLE13[] = (byte*)0x00;             const struct TileGlue GSE13 = { 0, 0x00 };
byte const GLS13[] = {08,07,13,14};    const struct TileGlue GSS13 = { 4, GLS13 };
byte const GLW13[] = (byte*)0x00;             const struct TileGlue GSW13 = { 0, 0x00 };

byte const GLN20[] = (byte*)0x00;             const struct TileGlue GSN20 = { 0, 0x00 };
byte const GLE20[] = {20,21};          const struct TileGlue GSE20 = { 2, GLE20 };
byte const GLS20[] = (byte*)0x00;             const struct TileGlue GSS20 = { 0, 0x00 };
byte const GLW20[] = {19,20};          const struct TileGlue GSW20 = { 2, GLW20 };

byte const GLN21[] = {21,22};          const struct TileGlue GSN21 = { 2, GLN21 };
byte const GLE21[] = (byte*)0x00;             const struct TileGlue GSE21 = { 0, 0x00 };
byte const GLS21[] = {22,23};          const struct TileGlue GSS21 = { 2, GLS21 };
byte const GLW21[] = (byte*)0x00;             const struct TileGlue GSW21 = { 0, 0x00 };

byte const GLN22[] = (byte*)0x00;             const struct TileGlue GSN22 = { 0, 0x00 };
byte const GLE22[] = {24,23};          const struct TileGlue GSE22 = { 2, GLE22 };
byte const GLS22[] = (byte*)0x00;             const struct TileGlue GSS22 = { 0, 0x00 };
byte const GLW22[] = {25,24};          const struct TileGlue GSW22 = { 2, GLW22 };

byte const GLN23[] = {19,26};          const struct TileGlue GSN23 = { 2, GLN23 };
byte const GLE23[] = (byte*)0x00;             const struct TileGlue GSE23 = { 0, 0x00 };
byte const GLS23[] = {26,25};          const struct TileGlue GSS23 = { 2, GLS23 };
byte const GLW23[] = (byte*)0x00;             const struct TileGlue GSW23 = { 0, 0x00 };

byte const GLN30[] = (byte*)0x00;             const struct TileGlue GSN30 = { 0, 0x00 };
byte const GLE30[] = {29,30};          const struct TileGlue GSE30 = { 2, GLE30 };
byte const GLS30[] = (byte*)0x00;             const struct TileGlue GSS30 = { 0, 0x00 };
byte const GLW30[] = {28,29};          const struct TileGlue GSW30 = { 2, GLW30 };

byte const GLN31[] = {30,31};          const struct TileGlue GSN31 = { 2, GLN31 };
byte const GLE31[] = (byte*)0x00;             const struct TileGlue GSE31 = { 0, 0x00 };
byte const GLS31[] = {31,32};          const struct TileGlue GSS31 = { 2, GLS31 };
byte const GLW31[] = (byte*)0x00;             const struct TileGlue GSW31 = { 0, 0x00 };

byte const GLN32[] = (byte*)0x00;             const struct TileGlue GSN32 = { 0, 0x00 };
byte const GLE32[] = {32,33};          const struct TileGlue GSE32 = { 2, GLE32 };
byte const GLS32[] = (byte*)0x00;             const struct TileGlue GSS32 = { 0, 0x00 };
byte const GLW32[] = {34,33};          const struct TileGlue GSW32 = { 2, GLW32 };

byte const GLN33[] = {28,35};          const struct TileGlue GSN33 = { 2, GLN33 };
byte const GLE33[] = (byte*)0x00;             const struct TileGlue GSE33 = { 0, 0x00 };
byte const GLS33[] = {35,34};          const struct TileGlue GSS33 = { 2, GLS33 };
byte const GLW33[] = (byte*)0x00;             const struct TileGlue GSW33 = { 0, 0x00 };

struct TileSegment {
    byte Weight;
    byte Composition[4];
    struct TileGlue *Glue[4];
};

struct TileSegment TileSegmentDB[16] = {
    { 16, { 00, 00, 00, 00 }, { &GSN01, &GSE01, &GSS01, &GSW01 } }, // 00 -  
    { 08, { 00, 00, 03, 00 }, { &GSN00, &GSE10, &GSS13, &GSW00 } }, // 01 - 
    { 08, { 00, 00, 00, 01 }, { &GSN00, &GSE10, &GSS01, &GSW10 } }, // 02 - 
    { 08, { 00, 00, 02, 02 }, { &GSN00, &GSE00, &GSS11, &GSW10 } }, // 03 - 
    { 08, { 00, 06, 00, 08 }, { &GSN11, &GSE00, &GSS11, &GSW01 } }, // 04 - 
    { 08, { 00, 00, 00, 00 }, { &GSN11, &GSE00, &GSS00, &GSW12 } }, // 05 - 
    { 08, { 00, 04, 00, 04 }, { &GSN01, &GSE12, &GSS00, &GSW12 } }, // 06 - 
    { 08, { 00, 14, 02, 18 }, { &GSN13, &GSE12, &GSS00, &GSW00 } }, // 07 - 
    { 08, { 07, 00, 08, 00 }, { &GSN13, &GSE01, &GSS13, &GSW00 } }, // 08 - 
    { 32, { 05, 00, 05, 00 }, { &GSN00, &GSE00, &GSS00, &GSW00 } }, // 09 - 
    { 02, { 00, 00, 00, 00 }, { &GSN01, &GSE12, &GSS11, &GSW01 } }, // 10 -
    { 04, { 13, 00, 16, 02 }, { &GSN01, &GSE12, &GSS00, &GSW12 } }, // 11 -
    { 02, { 11, 11, 08, 08 }, { &GSN01, &GSE01, &GSS13, &GSW12 } }, // 12 -
    { 04, { 10, 11, 13, 08 }, { &GSN13, &GSE01, &GSS13, &GSW00 } }, // 13 -
    { 02, { 11, 12, 09, 14 }, { &GSN13, &GSE01, &GSS01, &GSW10 } }, // 14 -
    { 04, { 15, 15, 15, 15 }, { &GSN00, &GSE10, &GSS01, &GSW10 } }  // 15 -
};


// Work variables

byte const TILE_FLOOR_COUNT = TILE_FLOOR01_COUNT; 

byte const TILES = 10; 
byte TileFloorNew[TILES];
byte TileFloorOld[TILES];
