
struct Tile {
    char File[16];
    byte TileCount;
    byte TileOffset;
    word TotalSize;
    word TileSize;
    byte PaletteOffset; 
    heap_handle BRAM_Handle;
};



byte const TILE_FLOOR01_01_COUNT = 20;
struct Tile TileFloor01 =       { "FLOOR01", TILE_FLOOR01_01_COUNT, 0, 32*32*TILE_FLOOR01_01_COUNT/2, 512, 1, 0x0 };

byte const TILE_FLOOR01_02_COUNT = 4;
struct Tile TileFloor02 =       { "FLOOR02", TILE_FLOOR01_02_COUNT, 20, 32*32*TILE_FLOOR01_02_COUNT/2, 512, 2, 0x0 };

byte const TILE_FLOOR01_03_COUNT = 16;
struct Tile TileFloor03 =       { "FLOOR03", TILE_FLOOR01_03_COUNT, 24, 32*32*TILE_FLOOR01_03_COUNT/2, 512, 3, 0x0 };

byte const TILE_FLOOR01_04_COUNT = 16;
struct Tile TileFloor04 =       { "FLOOR04", TILE_FLOOR01_04_COUNT, 40, 32*32*TILE_FLOOR01_04_COUNT/2, 512, 4, 0x0 };

byte const TILE_TYPES = 4;
__mem struct Tile *TileDB[4] = { &TileFloor01, &TileFloor02, &TileFloor03, &TileFloor04 };

struct TilePart {
    struct Tile *Tile;
    word Offset;
    heap_handle VRAM_Handle;
};

struct TilePart TilePartDB[56] = {
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
    { &TileFloor02, 20*4, 0x00 }, // 20
    { &TileFloor02, 21*4, 0x00 }, // 21
    { &TileFloor02, 22*4, 0x00 }, // 22
    { &TileFloor02, 23*4, 0x00 }, // 23
    { &TileFloor03, 24*4, 0x00 }, // 24
    { &TileFloor03, 25*4, 0x00 }, // 25
    { &TileFloor03, 26*4, 0x00 }, // 26
    { &TileFloor03, 27*4, 0x00 }, // 27
    { &TileFloor03, 28*4, 0x00 }, // 28
    { &TileFloor03, 29*4, 0x00 }, // 29
    { &TileFloor03, 30*4, 0x00 }, // 30
    { &TileFloor03, 31*4, 0x00 }, // 31
    { &TileFloor03, 32*4, 0x00 }, // 32
    { &TileFloor03, 33*4, 0x00 }, // 33
    { &TileFloor03, 34*4, 0x00 }, // 34
    { &TileFloor03, 35*4, 0x00 }, // 35
    { &TileFloor03, 36*4, 0x00 }, // 36
    { &TileFloor03, 37*4, 0x00 }, // 37
    { &TileFloor03, 38*4, 0x00 }, // 38
    { &TileFloor03, 39*4, 0x00 }, // 39
    { &TileFloor04, 40*4, 0x00 }, // 40
    { &TileFloor04, 41*4, 0x00 }, // 41
    { &TileFloor04, 42*4, 0x00 }, // 42
    { &TileFloor04, 43*4, 0x00 }, // 43
    { &TileFloor04, 44*4, 0x00 }, // 44
    { &TileFloor04, 45*4, 0x00 }, // 45
    { &TileFloor04, 46*4, 0x00 }, // 46
    { &TileFloor04, 47*4, 0x00 }, // 47
    { &TileFloor04, 48*4, 0x00 }, // 48
    { &TileFloor04, 49*4, 0x00 }, // 49
    { &TileFloor04, 50*4, 0x00 }, // 50
    { &TileFloor04, 51*4, 0x00 }, // 51
    { &TileFloor04, 52*4, 0x00 }, // 52
    { &TileFloor04, 53*4, 0x00 }, // 53
    { &TileFloor04, 54*4, 0x00 }, // 54
    { &TileFloor04, 55*4, 0x00 }  // 55
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

byte const GLN10[] = 0x00;             const struct TileGlue GSN10 = { 0, 0x00 };
byte const GLE10[] = {02,03,15,14};    const struct TileGlue GSE10 = { 4, GLE10 };
byte const GLS10[] = 0x00;             const struct TileGlue GSS10 = { 0, 0x00 };
byte const GLW10[] = {01,02,16,15};    const struct TileGlue GSW10 = { 4, GLW10 };

byte const GLN11[] = {03,04,10,17};    const struct TileGlue GSN11 = { 4, GLN11 };
byte const GLE11[] = 0x00;             const struct TileGlue GSE11 = { 0, 0x00 };
byte const GLS11[] = {04,05,17,16};    const struct TileGlue GSS11 = { 4, GLS11 };
byte const GLW11[] = 0x00;             const struct TileGlue GSW11 = { 0, 0x00 };

byte const GLN12[] = 0x00;             const struct TileGlue GSN12 = { 0, 0x00 };
byte const GLE12[] = {05,06,12,11};    const struct TileGlue GSE12 = { 4, GLE12 };
byte const GLS12[] = 0x00;             const struct TileGlue GSS12 = { 0, 0x00 };
byte const GLW12[] = {07,06,10,11};    const struct TileGlue GSW12 = { 4, GLW12 };

byte const GLN13[] = {01,08,12,13};    const struct TileGlue GSN13 = { 4, GLN13 };
byte const GLE13[] = 0x00;             const struct TileGlue GSE13 = { 0, 0x00 };
byte const GLS13[] = {08,07,13,14};    const struct TileGlue GSS13 = { 4, GLS13 };
byte const GLW13[] = 0x00;             const struct TileGlue GSW13 = { 0, 0x00 };

byte const GLN20[] = 0x00;             const struct TileGlue GSN20 = { 0, 0x00 };
byte const GLE20[] = {20,21};          const struct TileGlue GSE20 = { 2, GLE20 };
byte const GLS20[] = 0x00;             const struct TileGlue GSS20 = { 0, 0x00 };
byte const GLW20[] = {19,20};          const struct TileGlue GSW20 = { 2, GLW20 };

byte const GLN21[] = {21,22};          const struct TileGlue GSN21 = { 2, GLN21 };
byte const GLE21[] = 0x00;             const struct TileGlue GSE21 = { 0, 0x00 };
byte const GLS21[] = {22,23};          const struct TileGlue GSS21 = { 2, GLS21 };
byte const GLW21[] = 0x00;             const struct TileGlue GSW21 = { 0, 0x00 };

byte const GLN22[] = 0x00;             const struct TileGlue GSN22 = { 0, 0x00 };
byte const GLE22[] = {24,23};          const struct TileGlue GSE22 = { 2, GLE22 };
byte const GLS22[] = 0x00;             const struct TileGlue GSS22 = { 0, 0x00 };
byte const GLW22[] = {25,24};          const struct TileGlue GSW22 = { 2, GLW22 };

byte const GLN23[] = {19,26};          const struct TileGlue GSN23 = { 2, GLN23 };
byte const GLE23[] = 0x00;             const struct TileGlue GSE23 = { 0, 0x00 };
byte const GLS23[] = {26,25};          const struct TileGlue GSS23 = { 2, GLS23 };
byte const GLW23[] = 0x00;             const struct TileGlue GSW23 = { 0, 0x00 };

byte const GLN30[] = 0x00;             const struct TileGlue GSN30 = { 0, 0x00 };
byte const GLE30[] = {29,30};          const struct TileGlue GSE30 = { 2, GLE30 };
byte const GLS30[] = 0x00;             const struct TileGlue GSS30 = { 0, 0x00 };
byte const GLW30[] = {28,29};          const struct TileGlue GSW30 = { 2, GLW30 };

byte const GLN31[] = {30,31};          const struct TileGlue GSN31 = { 2, GLN31 };
byte const GLE31[] = 0x00;             const struct TileGlue GSE31 = { 0, 0x00 };
byte const GLS31[] = {31,32};          const struct TileGlue GSS31 = { 2, GLS31 };
byte const GLW31[] = 0x00;             const struct TileGlue GSW31 = { 0, 0x00 };

byte const GLN32[] = 0x00;             const struct TileGlue GSN32 = { 0, 0x00 };
byte const GLE32[] = {32,33};          const struct TileGlue GSE32 = { 2, GLE32 };
byte const GLS32[] = 0x00;             const struct TileGlue GSS32 = { 0, 0x00 };
byte const GLW32[] = {34,33};          const struct TileGlue GSW32 = { 2, GLW32 };

byte const GLN33[] = {28,35};          const struct TileGlue GSN33 = { 2, GLN33 };
byte const GLE33[] = 0x00;             const struct TileGlue GSE33 = { 0, 0x00 };
byte const GLS33[] = {35,34};          const struct TileGlue GSS33 = { 2, GLS33 };
byte const GLW33[] = 0x00;             const struct TileGlue GSW33 = { 0, 0x00 };

struct TileSegment {
    byte Weight;
    byte Composition[4];
    struct TileGlue *Glue[4];
};

struct TileSegment TileSegmentDB[36] = {
    { 16, { 07, 08, 11, 12 }, { &GSN01, &GSE01, &GSS01, &GSW01 } }, // 00 - Black rock middle
    { 8, { 00, 02, 10, 12 }, { &GSN00, &GSE10, &GSS13, &GSW00 } }, // 01 - white outer wall NW
    { 8, { 01, 02, 11, 12 }, { &GSN00, &GSE10, &GSS01, &GSW10 } }, // 02 - white outer wall N
    { 8, { 01, 03, 11, 13 }, { &GSN00, &GSE00, &GSS11, &GSW10 } }, // 03 - white outer wall NE
    { 8, { 07, 09, 11, 13 }, { &GSN11, &GSE00, &GSS11, &GSW01 } }, // 04 - white outer wall E
    { 8, { 07, 09, 17, 19 }, { &GSN11, &GSE00, &GSS00, &GSW12 } }, // 05 - white outer wall SE
    { 8, { 07, 08, 17, 18 }, { &GSN01, &GSE12, &GSS00, &GSW12 } }, // 06 - white outer wall S
    { 8, { 06, 08, 16, 18 }, { &GSN13, &GSE12, &GSS00, &GSW00 } }, // 07 - white outer wall SW
    { 8, { 06, 08, 10, 12 }, { &GSN13, &GSE01, &GSS13, &GSW00 } }, // 08 - white outer wall W
    { 32, { 20, 21, 22, 23 }, { &GSN00, &GSE00, &GSS00, &GSW00 } }, // 09 - Concrete inner
    { 2, { 07, 08, 11, 04 }, { &GSN01, &GSE12, &GSS11, &GSW01 } }, // 10 - white inner wall NW
    { 4, { 07, 08, 17, 18 }, { &GSN01, &GSE12, &GSS00, &GSW12 } }, // 11 - white inner wall N
    { 2, { 07, 08, 05, 12 }, { &GSN01, &GSE01, &GSS13, &GSW12 } }, // 12 - white inner wall NE
    { 4, { 06, 08, 10, 12 }, { &GSN13, &GSE01, &GSS13, &GSW00 } }, // 13 - white inner wall E
    { 2, { 15, 08, 11, 12 }, { &GSN13, &GSE01, &GSS01, &GSW10 } }, // 14 - white inner wall SE
    { 4, { 01, 02, 11, 12 }, { &GSN00, &GSE10, &GSS01, &GSW10 } }, // 15 - white inner wall S
    { 2, { 07, 14, 11, 12 }, { &GSN11, &GSE10, &GSS01, &GSW01 } }, // 16 - white inner wall SW
    { 4, { 07, 09, 11, 13 }, { &GSN11, &GSE00, &GSS11, &GSW01 } }, // 17 - white inner wall W
    { 16, { 29, 30, 33, 34 }, { &GSN02, &GSE02, &GSS02, &GSW02 } }, // 18 - brown rock inner
    { 2, { 24, 26, 32, 34 }, { &GSN00, &GSE20, &GSS23, &GSW00 } }, // 19 - concrete brown rock NW
    { 4, { 25, 26, 33, 34 }, { &GSN00, &GSE20, &GSS02, &GSW20 } }, // 20 - concrete brown rock N
    { 2, { 25, 27, 33, 35 }, { &GSN00, &GSE00, &GSS21, &GSW20 } }, // 21 - concrete brown rock NE
    { 3, { 29, 31, 33, 35 }, { &GSN21, &GSE00, &GSS21, &GSW02 } }, // 22 - concrete brown rock E
    { 2, { 29, 31, 37, 39 }, { &GSN21, &GSE00, &GSS00, &GSW22 } }, // 23 - concrete brown rock SE
    { 4, { 29, 30, 37, 38 }, { &GSN02, &GSE22, &GSS00, &GSW22 } }, // 24 - concrete brown rock S
    { 2, { 28, 30, 36, 38 }, { &GSN23, &GSE22, &GSS00, &GSW00 } }, // 25 - concrete brown rock SW
    { 3, { 28, 30, 32, 34 }, { &GSN23, &GSE02, &GSS23, &GSW00 } }, // 26 - concrete brown rock W
    { 16, { 45, 46, 49, 50 }, { &GSN03, &GSE03, &GSS03, &GSW03 } }, // 27 - grass inner
    { 2, { 40, 42, 48, 50 }, { &GSN01, &GSE30, &GSS33, &GSW01 } }, // 28 - concrete grass NW
    { 4, { 41, 42, 49, 50 }, { &GSN01, &GSE30, &GSS03, &GSW30 } }, // 29 - concrete grass N
    { 2, { 41, 43, 49, 51 }, { &GSN01, &GSE01, &GSS31, &GSW30 } }, // 30 - concrete grass NE
    { 3, { 45, 47, 49, 51 }, { &GSN31, &GSE01, &GSS31, &GSW03 } }, // 31 - concrete grass E
    { 2, { 45, 47, 53, 55 }, { &GSN31, &GSE01, &GSS01, &GSW32 } }, // 32 - concrete grass SE
    { 4, { 45, 46, 53, 54 }, { &GSN03, &GSE32, &GSS01, &GSW32 } }, // 33 - concrete grass S
    { 2, { 44, 46, 52, 54 }, { &GSN33, &GSE32, &GSS01, &GSW01 } }, // 34 - concrete grass SW
    { 3, { 44, 46, 48, 50 }, { &GSN33, &GSE03, &GSS33, &GSW01 } }  // 35 - concrete grass W
};


// Work variables

byte const TILE_FLOOR_COUNT = TILE_FLOOR01_01_COUNT + TILE_FLOOR01_02_COUNT + TILE_FLOOR01_03_COUNT + TILE_FLOOR01_04_COUNT; 

byte const TILES = 10; 
byte TileFloorNew[TILES];
byte TileFloorOld[TILES];

volatile unsigned long vram_floor_map_ulong;