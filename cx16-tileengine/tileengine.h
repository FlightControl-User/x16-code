
struct Tile {
    char File[16];
    word Offset;
    byte TileCount;
    word TotalSize;
    word TileSize;
    byte PaletteOffset; 
    byte PaletteSize;
    dword BRAM_Address;
    dword VRAM_Addresses[24];
};



byte const TILE_BORDER_COUNT = 24;
word const TILE_BORDER_OFFSET = 0;
struct Tile TileBorder =       { "BORDER", TILE_BORDER_OFFSET, TILE_BORDER_COUNT, 32*32*TILE_BORDER_COUNT/2, 512, 1, 16, 0x0, {0} };

byte const TILE_SQUAREMETAL_COUNT = 16;
word const TILE_SQUAREMETAL_OFFSET = TILE_BORDER_OFFSET + TILE_BORDER_COUNT * 4;
struct Tile TileSquareMetal =  { "SQUAREMETAL", TILE_SQUAREMETAL_OFFSET, TILE_SQUAREMETAL_COUNT, 32*32*TILE_SQUAREMETAL_COUNT/2, 512, 2, 16, 0x0, {0} };

byte const TILE_SQUARERASTER_COUNT = 16;
word const TILE_SQUARERASTER_OFFSET = TILE_SQUAREMETAL_OFFSET + TILE_SQUAREMETAL_COUNT * 4;
struct Tile TileSquareRaster = { "SQUARERASTER", TILE_SQUARERASTER_OFFSET, TILE_SQUARERASTER_COUNT, 32*32*TILE_SQUARERASTER_COUNT/2, 512, 3, 16, 0x0, {0} };

byte const TILE_INSIDEMETAL_COUNT = 1;
word const TILE_INSIDEMETAL_OFFSET = TILE_SQUARERASTER_OFFSET + TILE_SQUARERASTER_COUNT * 4;
struct Tile TileInsideMetal =    { "INSIDEMETAL", TILE_INSIDEMETAL_OFFSET,  TILE_INSIDEMETAL_COUNT, 32*32*TILE_INSIDEMETAL_COUNT/2, 512, 4, 16, 0x0, {0} };

byte const TILE_INSIDEDARK_COUNT = 1;
word const TILE_INSIDEDARK_OFFSET = TILE_INSIDEMETAL_OFFSET + TILE_INSIDEMETAL_COUNT * 4;
struct Tile TileInsideDark =    { "INSIDEDARK", TILE_INSIDEDARK_OFFSET,  TILE_INSIDEDARK_COUNT, 32*32*TILE_INSIDEDARK_COUNT/2, 512, 5, 16, 0x0, {0} };

byte const TILE_TYPES = 5;
__mem struct Tile *TileDB[5] = { &TileBorder, &TileSquareMetal, &TileSquareRaster, &TileInsideMetal, &TileInsideDark };


// Glue the tile segments, in order to do fast selection of possible tile combinations and randomization.

struct TileGlue {
    byte CountGlue;
    byte *GlueSegment;
};


byte const GLN00[] = {04,05,06,09,18,19,22,23,24}; const struct TileGlue GSN00 = { 9, GLN00 };
byte const GLE00[] = {00,06,07,11,16,18,20,22,24}; const struct TileGlue GSE00 = { 9, GLE00 };
byte const GLS00[] = {00,01,02,13,16,17,20,21,24}; const struct TileGlue GSS00 = { 9, GLS00 };
byte const GLW00[] = {02,03,04,15,17,19,21,23,24}; const struct TileGlue GSW00 = { 9, GLW00 };

byte const GLN01[] = {01,12,13,14,25}; const struct TileGlue GSN01 = { 5, GLN01 };
byte const GLE01[] = {03,08,14,15,25}; const struct TileGlue GSE01 = { 5, GLE01 };
byte const GLS01[] = {05,08,09,10,25}; const struct TileGlue GSS01 = { 5, GLS01 };
byte const GLW01[] = {07,10,11,12,25}; const struct TileGlue GSW01 = { 5, GLW01 };

byte const GLN10[] = 0x00;             const struct TileGlue GSN10 = { 0, 0x00 };
byte const GLE10[] = {01,02,12,13};    const struct TileGlue GSE10 = { 4, GLE10 };
byte const GLS10[] = 0x00;             const struct TileGlue GSS10 = { 0, 0x00 };
byte const GLW10[] = {00,01,13,14};    const struct TileGlue GSW10 = { 4, GLW10 };

byte const GLN11[] = {02,03,08,15};    const struct TileGlue GSN11 = { 4, GLN11 };
byte const GLE11[] = 0x00;             const struct TileGlue GSE11 = { 0, 0x00 };
byte const GLS11[] = {03,04,14,15};    const struct TileGlue GSS11 = { 4, GLS11 };
byte const GLW11[] = 0x00;             const struct TileGlue GSW11 = { 0, 0x00 };

byte const GLN12[] = 0x00;             const struct TileGlue GSN12 = { 0, 0x00 };
byte const GLE12[] = {04,05,09,10};    const struct TileGlue GSE12 = { 4, GLE12 };
byte const GLS12[] = 0x00;             const struct TileGlue GSS12 = { 0, 0x00 };
byte const GLW12[] = {05,06,08,09};    const struct TileGlue GSW12 = { 4, GLW12 };

byte const GLN13[] = {00,07,10,11};    const struct TileGlue GSN13 = { 4, GLN13 };
byte const GLE13[] = 0x00;             const struct TileGlue GSE13 = { 0, 0x00 };
byte const GLS13[] = {06,07,11,12};    const struct TileGlue GSS13 = { 4, GLS13 };
byte const GLW13[] = 0x00;             const struct TileGlue GSW13 = { 0, 0x00 };

byte const GLN30[] = 0x00;             const struct TileGlue GSN30 = { 0, 0x00 };
byte const GLE30[] = {17};             const struct TileGlue GSE30 = { 1, GLE30 };
byte const GLS30[] = 0x00;             const struct TileGlue GSS30 = { 0, 0x00 };
byte const GLW30[] = {16};             const struct TileGlue GSW30 = { 1, GLW30 };

byte const GLN31[] = {17};             const struct TileGlue GSN31 = { 1, GLN31 };
byte const GLE31[] = 0x00;             const struct TileGlue GSE31 = { 0, 0x00 };
byte const GLS31[] = {19};             const struct TileGlue GSS31 = { 1, GLS31 };
byte const GLW31[] = 0x00;             const struct TileGlue GSW31 = { 0, 0x00 };

byte const GLN32[] = 0x00;             const struct TileGlue GSN32 = { 0, 0x00 };
byte const GLE32[] = {19};             const struct TileGlue GSE32 = { 1, GLE32 };
byte const GLS32[] = 0x00;             const struct TileGlue GSS32 = { 0, 0x00 };
byte const GLW32[] = {18};             const struct TileGlue GSW32 = { 1, GLW32 };

byte const GLN33[] = {16};             const struct TileGlue GSN33 = { 1, GLN33 };
byte const GLE33[] = 0x00;             const struct TileGlue GSE33 = { 0, 0x00 };
byte const GLS33[] = {18};             const struct TileGlue GSS33 = { 1, GLS33 };
byte const GLW33[] = 0x00;             const struct TileGlue GSW33 = { 0, 0x00 };

byte const GLN34[] = 0x00;             const struct TileGlue GSN34 = { 0, 0x00 };
byte const GLE34[] = {21};             const struct TileGlue GSE34 = { 1, GLE34 };
byte const GLS34[] = 0x00;             const struct TileGlue GSS34 = { 0, 0x00 };
byte const GLW34[] = {20};             const struct TileGlue GSW34 = { 1, GLW34 };

byte const GLN35[] = {21};             const struct TileGlue GSN35 = { 1, GLN35 };
byte const GLE35[] = 0x00;             const struct TileGlue GSE35 = { 0, 0x00 };
byte const GLS35[] = {23};             const struct TileGlue GSS35 = { 1, GLS35 };
byte const GLW35[] = 0x00;             const struct TileGlue GSW35 = { 0, 0x00 };

byte const GLN36[] = 0x00;             const struct TileGlue GSN36 = { 0, 0x00 };
byte const GLE36[] = {23};             const struct TileGlue GSE36 = { 1, GLE36 };
byte const GLS36[] = 0x00;             const struct TileGlue GSS36 = { 0, 0x00 };
byte const GLW36[] = {22};             const struct TileGlue GSW36 = { 1, GLW36 };

byte const GLN37[] = {20};             const struct TileGlue GSN37 = { 1, GLN37 };
byte const GLE37[] = 0x00;             const struct TileGlue GSE37 = { 0, 0x00 };
byte const GLS37[] = {22};             const struct TileGlue GSS37 = { 1, GLS37 };
byte const GLW37[] = 0x00;             const struct TileGlue GSW37 = { 0, 0x00 };

struct TileSegment {
    struct Tile *Tile;
    byte Composition[4];
    struct TileGlue *Glue[4];
};

struct TileSegment TileSegmentDB[26] = {
    { &TileBorder,        { 08, 14, 13, 00 }, { &GSN00, &GSE10, &GSS13, &GSW00 } }, // 00
    { &TileBorder,        { 14, 14, 06, 06 }, { &GSN00, &GSE10, &GSS01, &GSW10 } }, // 01
    { &TileBorder,        { 14, 09, 01, 12 }, { &GSN00, &GSE00, &GSS11, &GSW10 } }, // 02
    { &TileBorder,        { 04, 12, 04, 12 }, { &GSN11, &GSE00, &GSS11, &GSW01 } }, // 03
    { &TileBorder,        { 03, 12, 15, 11 }, { &GSN11, &GSE00, &GSS00, &GSW12 } }, // 04
    { &TileBorder,        { 07, 07, 15, 15 }, { &GSN01, &GSE12, &GSS00, &GSW12 } }, // 05
    { &TileBorder,        { 13, 02, 10, 15 }, { &GSN13, &GSE12, &GSS00, &GSW00 } }, // 06
    { &TileBorder,        { 13, 05, 13, 05 }, { &GSN13, &GSE01, &GSS13, &GSW00 } }, // 07
    { &TileBorder,        { 20, 07, 04, 16 }, { &GSN01, &GSE12, &GSS11, &GSW01 } }, // 08
    { &TileBorder,        { 07, 07, 15, 15 }, { &GSN01, &GSE12, &GSS00, &GSW12 } }, // 09
    { &TileBorder,        { 07, 21, 17, 05 }, { &GSN01, &GSE01, &GSS13, &GSW12 } }, // 10
    { &TileBorder,        { 13, 05, 13, 05 }, { &GSN13, &GSE01, &GSS13, &GSW00 } }, // 11
    { &TileBorder,        { 19, 05, 06, 23 }, { &GSN13, &GSE01, &GSS01, &GSW10 } }, // 12
    { &TileBorder,        { 14, 14, 06, 06 }, { &GSN00, &GSE10, &GSS01, &GSW10 } }, // 13
    { &TileBorder,        { 04, 18, 22, 06 }, { &GSN11, &GSE10, &GSS01, &GSW01 } }, // 14
    { &TileBorder,        { 04, 12, 04, 12 }, { &GSN11, &GSE00, &GSS11, &GSW01 } }, // 15
    { &TileSquareMetal,   { 00, 01, 02, 03 }, { &GSN00, &GSE30, &GSS33, &GSW00 } }, // 16
    { &TileSquareMetal,   { 04, 05, 06, 07 }, { &GSN00, &GSE00, &GSS31, &GSW30 } }, // 17
    { &TileSquareMetal,   { 08, 09, 10, 11 }, { &GSN33, &GSE32, &GSS00, &GSW00 } }, // 18
    { &TileSquareMetal,   { 12, 13, 14, 15 }, { &GSN31, &GSE00, &GSS00, &GSW32 } }, // 19
    { &TileSquareRaster,  { 00, 01, 02, 03 }, { &GSN00, &GSE34, &GSS37, &GSW00 } }, // 20
    { &TileSquareRaster,  { 04, 05, 06, 07 }, { &GSN00, &GSE00, &GSS35, &GSW34 } }, // 21
    { &TileSquareRaster,  { 08, 09, 10, 11 }, { &GSN37, &GSE36, &GSS00, &GSW00 } }, // 22
    { &TileSquareRaster,  { 12, 13, 14, 15 }, { &GSN35, &GSE00, &GSS00, &GSW36 } }, // 23
    { &TileInsideMetal,   { 00, 00, 00, 00 }, { &GSN00, &GSE00, &GSS00, &GSW00 } }, // 24
    { &TileInsideDark,    { 00, 00, 00, 00 }, { &GSN01, &GSE01, &GSS01, &GSW01 } }  // 25
};


// Work variables

byte const TILE_FLOOR_COUNT = TILE_BORDER_COUNT + TILE_SQUAREMETAL_COUNT + TILE_SQUARERASTER_COUNT + TILE_INSIDEMETAL_COUNT + TILE_INSIDEDARK_COUNT; 

byte const TILES = 10; 
byte TileFloorNew[TILES];
byte TileFloorOld[TILES];
