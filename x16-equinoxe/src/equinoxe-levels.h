

// #include "equinoxe-types.h"
#include "equinoxe-level-types.h"
// #include "equinoxe-defines.h"

#pragma data_seg(BRAM_ENGINE_FLIGHT)

// __export volatile sprite_bram_t sprite_t001 = { "t001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_p001 = { "p001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_n001 = { "n001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0101 = { "e0101", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0102 = { "e0102", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0201 = { "e0201", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0202 = { "e0202", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0301 = { "e0301", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0302 = { "e0302", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0401 = { "e0401", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0501 = { "e0501", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0502 = { "e0502", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0601 = { "e0601", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0602 = { "e0602", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0701 = { "e0701", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0702 = { "e0702", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0703 = { "e0703", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_b001 = { "b001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_b002 = { "b002", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_b003 = { "b003", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_b004 = { "b004", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };


#define t001 0
#define p001 1
#define n001 2
#define e0701 3
#define e0102 4
#define e0201 5
#define e0202 6
#define e0301 7
#define e0302 8
#define e0401 9
#define e0501 10
#define e0502 11
#define e0601 12
#define e0602 13
#define e0101 14
#define e0702 15
#define e0703 16
#define b001 17
#define b002 18
#define b003 19
#define b004 20

__export sprite_t sprites = {

    {   "t001",  "p001",  "n001",  "e0701", 
        "e0102", "e0201", "e0202", "e0301", 
        "e0302", "e0401", "e0501", "e0502", 
        "e0601", "e0602", "e0101", "e0702", 
        "e0703", "b001", "b002", "b003",
        "b004" 
    }, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}
};


#pragma data_seg(BRAM_ENGINE_FLOOR)

// FLOOR

__export floor_bram_tiles_t mars_land_bram = { 0, "marsland", 94, 16*16*94, 128, 0 };
__export floor_bram_tiles_t mars_sand_bram = { 0, "marssand", 4, 16*16*4, 128, 0 };
__export floor_bram_tiles_t mars_sea_bram = { 0, "marssea", 16, 16*16*16, 128, 0 };
__export floor_bram_tiles_t metal_yellow_bram = {0, "metalyellow", 42, 16*16*45, 128, 0 };
__export floor_bram_tiles_t metal_red_bram = {0, "metalred", 1, 16*16*1, 128, 0 };
__export floor_bram_tiles_t metal_grey_bram = {0, "metalgrey", 1, 16*16*1, 128, 0 };


__export volatile floor_parts_t mars_parts = {
        { 0 }, { 0 }, { 0 }, { 0 }, { 0 }
};

__export volatile floor_layer_t mars_land = {
    0,
    { 35, { 0 }, { 0 } },
    {
        { 0b0000, { 00, 00, 00, 00 } }, // 00 - 0000
        { 0b0001, { 00, 26, 08, 27 } }, // 01 - 0001
        { 0b0001, { 84, 00, 85, 86 } }, // 01 - 0001
        { 0b0010, { 00, 00, 28, 00 } }, // 02 - 0010
        { 0b0011, { 00, 00, 22, 23 } }, // 03 - 0011
        { 0b0011, { 00, 00, 44, 45 } }, // 03 - 0011
        { 0b0011, { 00, 00, 78, 79 } }, // 03 - 0011
        { 0b0011, { 82, 83, 80, 81 } }, // 03 - 0011
        { 0b0100, { 00, 32, 00, 00 } }, // 04 - 0100
        { 0b0100, { 00, 46, 00, 00 } }, // 04 - 0100
        { 0b0101, { 72, 70, 73, 71 } }, // 05 - 0101
        { 0b0101, { 42, 43, 47, 48 } }, // 05 - 0101
        { 0b0101, { 11, 12, 14, 15 } }, // 05 - 0101
        { 0b0101, { 74, 75, 76, 77 } }, // 05 - 0101
        { 0b0110, { 39, 34, 40, 41 } }, // 06 - 0110
        { 0b0111, { 18, 19, 24, 25 } }, // 07 - 0111
        { 0b0111, { 87, 88, 89, 90 } }, // 07 - 0111
        { 0b1000, { 33, 00, 00, 00 } }, // 08 - 1000
        { 0b1000, { 49, 00, 00, 00 } }, // 08 - 1000
        { 0b1001, { 35, 36, 37, 38 } }, // 09 - 1001
        { 0b1010, { 10, 00, 13, 00 } }, // 10 - 1010
        { 0b1010, { 50, 00, 51, 00 } }, // 10 - 1010
        { 0b1010, { 91, 00, 92, 00 } }, // 10 - 1010
        { 0b1010, { 93, 00, 94, 00 } }, // 10 - 1010
        { 0b1011, { 16, 17, 20, 21 } }, // 11 - 1011
        { 0b1100, { 03, 04, 00, 00 } }, // 12 - 1100
        { 0b1100, { 52, 53, 00, 00 } }, // 12 - 1100
        { 0b1101, { 05, 06, 08, 09 } }, // 13 - 1101
        { 0b1101, { 05, 06, 00, 57 } }, // 13 - 1101
        { 0b1110, { 01, 02, 07, 00 } }, // 14 - 1110
        { 0b1110, { 01, 54, 58, 59 } }, // 14 - 1110
        { 0b1111, { 29, 30, 31, 29 } }, // 15 - 1111
        { 0b1111, { 55, 56, 60, 61 } }, // 15 - 1111
        { 0b1111, { 62, 63, 64, 65 } }, // 15 - 1111
        { 0b1111, { 69, 66, 67, 68 } }, // 15 - 1111
    }
};

__export volatile floor_layer_t mars_sand = {
    94,
    { 2, { 0 }, { 0 } },
    {
        { 0b0000, { 00, 00, 00, 00 } }, // 00 - 0000
        { 0b1111, { 01, 02, 03, 04 } }, // 15 - 1111
    }
};

__export volatile floor_layer_t mars_sea = {
    98,
    { 5, { 0 }, { 0 } },
    {
        { 0b0000, { 00, 00, 00, 00 } }, // 00 - 0000
        { 0b1111, { 01, 02, 05, 01 } }, // 15 - 1111
        { 0b1111, { 03, 04, 07, 08 } }, // 15 - 1111
        { 0b1111, { 09, 10, 13, 14 } }, // 15 - 1111
        { 0b1111, { 11, 12, 15, 16 } }, // 15 - 1111
    }
};

__export volatile floor_layer_t metal_yellow = {
    114,
    { 32, { 0 }, { 0 } },
    {
        { 0b00000, { 00, 00, 00, 00 } }, // 00 - 0000
        { 0b00001, { 29, 42, 42, 41 } }, // 01 - 0001
        { 0b00010, { 41, 22, 42, 41 } }, // 02 - 0010
        { 0b00011, { 25, 26, 42, 41 } }, // 03 - 0011
        { 0b00100, { 41, 42, 11, 41 } }, // 04 - 0100
        { 0b00101, { 17, 42, 19, 41 } }, // 05 - 0101
        { 0b00110, { 37, 34, 35, 40 } }, // 06 - 0110
        { 0b00111, { 42, 14, 07, 37 } }, // 07 - 0111
        { 0b01000, { 41, 42, 42, 04 } }, // 08 - 1000
        { 0b01001, { 41, 14, 42, 16 } }, // 09 - 1001
        { 0b01010, { 13, 14, 15, 16 } }, // 0A - 1010
        { 0b01011, { 17, 41, 38, 08 } }, // 0B - 1011
        { 0b01100, { 42, 41, 07, 08 } }, // 0C - 1100
        { 0b01101, { 25, 39, 41, 16 } }, // 0D - 1101
        { 0b01110, { 40, 26, 19, 42 } }, // 0E - 1110
        { 0b01111, { 41, 42, 42, 41 } }, // 0F - 1111
        { 0b10000, { 00, 00, 00, 00 } }, // 10 - 0000
        { 0b10001, { 41, 30, 31, 32 } }, // 11 - 0001
        { 0b10010, { 21, 42, 23, 24 } }, // 12 - 0010
        { 0b10011, { 41, 42, 27, 28 } }, // 13 - 0011
        { 0b10100, { 09, 10, 42, 12 } }, // 14 - 0100
        { 0b10101, { 41, 18, 42, 20 } }, // 15 - 0101
        { 0b10110, { 37, 34, 35, 40 } }, // 16 - 0110
        { 0b10111, { 33, 42, 42, 41 } }, // 17 - 0111
        { 0b11000, { 01, 02, 03, 41 } }, // 18 - 1000
        { 0b11001, { 13, 42, 15, 41 } }, // 19 - 1001
        { 0b11010, { 13, 42, 15, 41 } }, // 1A - 1010
        { 0b11011, { 42, 34, 42, 41 } }, // 1B - 1011
        { 0b11100, { 05, 06, 42, 41 } }, // 1C - 1100
        { 0b11101, { 41, 42, 35, 41 } }, // 1D - 1101
        { 0b11110, { 41, 42, 42, 36 } }, // 1E - 1110
        { 0b11111, { 41, 42, 42, 41 } }, // 1F - 1111
    }
};

__export volatile floor_layer_t metal_red = {
    134,
    { 02, { 0 }, { 0 } },
    {
        { 0b0000, { 00, 00, 00, 00 } }, // 00 - 0000
        { 0b1111, { 01, 01, 01, 01 } }, // 15 - 1111
    }
};

__export volatile floor_t mars = {
    &mars_parts,
    {&mars_land, &mars_sea, &mars_sand, &metal_yellow, &metal_red},
    {
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {00, 00, 00, 00} } } }, // 00 - 0000 - 0000
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {01, 03, 05, 15} } } }, // 01 - 0001 - 0001
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {03, 02, 15, 10} } } }, // 02 - 0010 - 0010
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {03, 03, 15, 15} } } }, // 03 - 0011 - 0011
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {05, 15, 04, 12} } } }, // 04 - 0100 - 0100
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {05, 15, 05, 15} } } }, // 05 - 0101 - 0101
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {07, 15, 15, 14} } } }, // 06 - 0110 - 0110
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {07, 15, 15, 15} } } }, // 07 - 0111 - 0111
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {15, 10, 12, 08} } } }, // 08 - 1000 - 1000
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {15, 11, 13, 15} } } }, // 09 - 1001 - 1001
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {15, 10, 15, 10} } } }, // 10 - 1010 - 1010
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {15, 11, 15, 15} } } }, // 11 - 1011 - 1011
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {15, 15, 12, 12} } } }, // 12 - 1100 - 1100
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {15, 15, 13, 15} } } }, // 13 - 1101 - 1101
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {15, 15, 15, 14} } } }, // 14 - 1110 - 1110
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {15, 15, 15, 15} } } }, // 15 - 1111 - 1111
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {00, 00, 00, 00} } } }, // 00 - 0000 - 0000
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {01, 03, 05, 15} } } }, // 01 - 0001 - 0001
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {03, 02, 15, 10} } } }, // 02 - 0010 - 0010
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {03, 03, 15, 15} } } }, // 03 - 0011 - 0011
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {05, 15, 04, 12} } } }, // 04 - 0100 - 0100
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {05, 15, 05, 15} } } }, // 05 - 0101 - 0101
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {07, 15, 15, 14} } } }, // 06 - 0110 - 0110
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {07, 15, 15, 15} } } }, // 07 - 0111 - 0111
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {15, 10, 12, 08} } } }, // 08 - 1000 - 1000
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {15, 11, 13, 15} } } }, // 09 - 1001 - 1001
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {15, 10, 15, 10} } } }, // 10 - 1010 - 1010
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {15, 11, 15, 15} } } }, // 11 - 1011 - 1011
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {15, 15, 12, 12} } } }, // 12 - 1100 - 1100
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {15, 15, 13, 15} } } }, // 13 - 1101 - 1101
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {15, 15, 15, 14} } } }, // 14 - 1110 - 1110
        { { { &mars_sand, {15, 15, 15, 15} }, { &mars_land, {15, 15, 15, 15} } } },  // 15 - 1111 - 1111
        { { { &metal_yellow, {0x0F, 0x0F, 0x0F, 0x0F} }, { &mars_land, {00, 00, 00, 00} } } }, // 00 - 0000 - 0000
        { { { &metal_yellow, {0x1E, 0x13, 0x15, 0x0E} }, { &mars_land, {00, 00, 00, 01} } } }, // 01 - 0001 - 0001
        { { { &metal_yellow, {0x13, 0x1B, 0x0D, 0x1A} }, { &mars_land, {00, 00, 02, 00} } } }, // 02 - 0010 - 0010
        { { { &metal_yellow, {0x13, 0x13, 0x03, 0x03} }, { &mars_land, {00, 00, 03, 03} } } }, // 03 - 0011 - 0011
        { { { &metal_yellow, {0x15, 0x0B, 0x1B, 0x1C} }, { &mars_land, {00, 04, 00, 00} } } }, // 04 - 0100 - 0100
        { { { &metal_yellow, {0x15, 0x05, 0x15, 0x05} }, { &mars_land, {00, 05, 00, 05} } } }, // 05 - 0101 - 0101
        { { { &metal_yellow, {0x11, 0x0B, 0x0D, 0x18} }, { &mars_land, {00, 04, 02, 00} } } }, // 06 - 0110 - 0110
        { { { &metal_yellow, {0x11, 0x05, 0x03, 0x01} }, { &mars_land, {00, 05, 03, 07} } } }, // 07 - 0111 - 0111
        { { { &metal_yellow, {0x07, 0x1A, 0x1C, 0x17} }, { &mars_land, {08, 00, 00, 00} } } }, // 08 - 1000 - 1000
        { { { &metal_yellow, {0x07, 0x12, 0x14, 0x0E} }, { &mars_land, {08, 00, 00, 01} } } }, // 09 - 1001 - 1001
        { { { &metal_yellow, {0x0A, 0x1A, 0x0A, 0x1A} }, { &mars_land, {10, 00, 10, 00} } } }, // 0A - 1010 - 1010
        { { { &metal_yellow, {0x0A, 0x12, 0x02, 0x03} }, { &mars_land, {10, 00, 11, 03} } } }, // 0B - 1011 - 1011
        { { { &metal_yellow, {0x0C, 0x0C, 0x1C, 0x1C} }, { &mars_land, {12, 12, 00, 00} } } }, // 0C - 1100 - 1100
        { { { &metal_yellow, {0x0C, 0x04, 0x14, 0x05} }, { &mars_land, {12, 13, 00, 05} } } }, // 0D - 1101 - 1101
        { { { &metal_yellow, {0x08, 0x0C, 0x0A, 0x18} }, { &mars_land, {14, 12, 10, 00} } } }, // 0E - 1110 - 1110
        { { { &metal_yellow, {0x0F, 0x0F, 0x0F, 0x0F} }, { &mars_land, {15, 15, 15, 15} } } }, // 0F - 1111 - 1111
    },
    0
};



// TOWER

__export floor_bram_tiles_t tower_bram = { 0, "tower01", 16, 16*16*16, 128, 0 };

__export volatile floor_parts_t tower_parts_01 = {
        { 0 }, { 0 }, { 0 }, { 0 }, { 0 }
};

__export volatile floor_layer_t tower = {
    0,
    { 5, { 0 }, { 0 } },
    {
        { 0b0000, { 00, 00, 00, 00 } }, // 00
        { 0b0001, { 01, 02, 05, 06 } }, // 01
        { 0b0010, { 03, 04, 07, 08 } }, // 02
        { 0b0011, { 09, 10, 13, 14 } }, // 03
        { 0b0100, { 11, 12, 15, 16 } }, // 04 
    },
};

__export volatile floor_t tower_01 = {
    &tower_parts_01,
    {&mars_sea, &mars_land},
    {
        { { { &mars_sea, {15, 15, 15, 15} }, { &mars_land, {00, 00, 00, 00} } } }, // 00 - 0000 - 0000
        // 00, 00, 00, 00, // 00
        // 01, 02, 03, 04 // 00
    },
    0
};

// TODO: rework to byte level addressing
#define TILE_WEIGHTS 5
tile_weight_t TileWeightDB[TILE_WEIGHTS] = {
    { 1, 4, { 10, 11, 13, 14 } },
    { 1, 2, { 03, 12 } },
    { 1, 2, { 06, 09 } },
    { 1, 6, { 01, 02, 04, 05, 07, 08 } },
    { 15, 1, { 15 } }
};


#pragma data_seg(BRAM_ENGINE_STAGES)

__export volatile stage_bullet_t stage_bullet_fireball = { b002 };
__export volatile stage_bullet_t stage_bullet_vertical_laser = { b003 };

__export volatile stage_enemy_t stage_enemy_e0101 = { e0701, e0701, &stage_bullet_fireball, 8, 0 };
__export volatile stage_enemy_t stage_enemy_e0102 = { e0102, e0102, &stage_bullet_fireball, 8, 0 };
__export volatile stage_enemy_t stage_enemy_e0201 = { e0201, e0201, &stage_bullet_fireball, 8, 0 };
__export volatile stage_enemy_t stage_enemy_e0202 = { e0202, e0202, &stage_bullet_fireball, 8, 0 };
__export volatile stage_enemy_t stage_enemy_e0301 = { e0301, e0301, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0302 = { e0302, e0302, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0401 = { e0401, e0401, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0501 = { e0501, e0501, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0502 = { e0502, e0502, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0601 = { e0601, e0601, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0602 = { e0602, e0602, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0701 = { e0701, e0701, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0702 = { e0702, e0702, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0703 = { e0703, e0703, &stage_bullet_fireball, 8, 1 };

__export volatile stage_engine_t stage_player_engine = { n001 };

__export volatile stage_bullet_t stage_player_bullet = { b001 };

__export volatile stage_player_t stage_player = { p001, &stage_player_engine, &stage_player_bullet };

// const stage_action_move_t     action_move_00                  = { 480+64, 16, 3 };
// const stage_action_move_t     action_move_left_480_01         = { 320+160, 32, 3 };
// const stage_action_move_t     action_move_02                  = { 80, 0, 3 };
// const stage_action_move_t     action_move_right_480_03        = { 320+160, 0, 3 };
// const stage_action_move_t     action_move_04                  = { 768, 32, 4 };
// const stage_action_move_t     action_move_05                  = { 768, 32, 2 };
// const stage_action_move_t     action_move_06                  = { 768, 0, 2 };

// const stage_action_turn_t     action_turn_00                  = { -24, 4, 3 };
// const stage_action_turn_t     action_turn_01                  = { 24, 4, 3 };
// const stage_action_turn_t     action_turn_02                  = { 32, 2, 2 };

// const stage_action_end_t      action_end                      = { 0 };

#define  action_move_00                 { 480+64, 16, 3 }
#define  action_move_left_480_01        { 320+160, 32, 3 }
#define  action_move_02                 { 80, 0, 3 }
#define  action_move_right_480_03       { 320+160, 0, 3 }
#define  action_move_04                 { 768, 32, 4 }
#define  action_move_05                 { 768, 32, 2 }
#define  action_move_06                 { 768, 0, 2 }

#define  action_turn_00                 { -24, 4, 3 }
#define  action_turn_01                 { 24, 4, 3 }
#define  action_turn_02                 { 32, 2, 2 }

#define  action_end                     { 0 }

const stage_flightpath_t action_flightpath_000[] = {
    { { .move = {320, 16, 0} },    STAGE_ACTION_MOVE,         0 }
};

const stage_flightpath_t action_flightpath_001[] = {
    { { .move = action_move_00 },    STAGE_ACTION_MOVE,        1 },
    { { .end = action_end },        STAGE_ACTION_END,         0 }
};

const stage_flightpath_t action_flightpath_left_circle_002[] = {
    { { .move = action_move_left_480_01 },    STAGE_ACTION_MOVE,        1 },
    { { .turn = action_turn_00 },    STAGE_ACTION_TURN,        2 },
    { { .move = action_move_02 },    STAGE_ACTION_MOVE,        1 }
};

const stage_flightpath_t action_flightpath_right_circle_003[] = {
    { { .move = action_move_right_480_03 },    STAGE_ACTION_MOVE,        1 },
    { { .turn = action_turn_01 },    STAGE_ACTION_TURN,        2 },
    { { .move = action_move_02 },    STAGE_ACTION_MOVE,        1 }
};

const stage_flightpath_t action_flightpath_004[] = {
    { { .move = action_move_04 },    STAGE_ACTION_MOVE,        1 },
    { { .end = action_end },        STAGE_ACTION_END,         0 },
};


const stage_flightpath_t action_flightpath_005[] = {
    { { .move = action_move_05 },    STAGE_ACTION_MOVE,        1 },
    { { .end = action_end },        STAGE_ACTION_END,         0 },
};

const stage_flightpath_t action_flightpath_006[] = {
    { { .move = { 768, 0, 2 } },    STAGE_ACTION_MOVE,        1 },
    { { .end = action_end },        STAGE_ACTION_END,         0 },
};

const stage_scenario_t stage_scenario_01_b[32] = {
//    ct, sp, enemy_xxx,            action_flightpath_xxx,                  xstrt,  ystrt,  xinc,   yinc,   ival,   wait,   prv,    fill    
    {  1,  1, &stage_enemy_e0401,   action_flightpath_000,                  320,    160,    0,      0,      4,      10,     255,    0 }, // 0
    {  1,  1, &stage_enemy_e0701,   action_flightpath_000,                  160,    160,    0,      0,      4,      20,     0,      0 }, // 1
    {  1,  1, &stage_enemy_e0702,   action_flightpath_000,                  480,    160,    0,      0,      4,      30,     0,      0 }, // 2
    { 16, 16, &stage_enemy_e0201,   action_flightpath_005,                  704,    32,     0,      0,      14,     20,     2,      0 }, // 3
    { 16, 16, &stage_enemy_e0201,   action_flightpath_006,                  -64,    96,     0,      0,      16,     20,     2,      0 }, // 4
    { 16, 16, &stage_enemy_e0201,   action_flightpath_005,                  704,    160,    0,      0,      18,     20,     2,      0 }, // 5
    {  8,  8, &stage_enemy_e0401,   action_flightpath_006,                  -64,    32,     0,      0,      8,      20,     5,      0 }, // 6
    {  8,  8, &stage_enemy_e0401,   action_flightpath_005,                  704,    96,     0,      0,      8,      20,     5,      0 }, // 7
    {  8,  8, &stage_enemy_e0301,   action_flightpath_006,                  -64,    160,    0,      0,      8,      20,     5,      0 }, // 8
    {  8,  8, &stage_enemy_e0302,   action_flightpath_005,                  704,    224,    0,      0,      8,      20,     8,      0 }, // 9
    {  8,  8, &stage_enemy_e0401,   action_flightpath_006,                  -64,    32,     0,      32,     4,      20,     8,      0 }, // 10
    {  8,  8, &stage_enemy_e0501,   action_flightpath_005,                  704,    32,     0,      32,     2,      20,     10,     0 }, // 11
    {  8,  8, &stage_enemy_e0601,   action_flightpath_006,                  -64,    32,     0,      32,     2,      20,     10,     0 }, // 12
    {  8,  8, &stage_enemy_e0701,   action_flightpath_005,                  704,    32,     0,      32,     6,      20,     12,     0 }, // 13
    {  8,  8, &stage_enemy_e0702,   action_flightpath_006,                  -64,    32,     0,      32,     8,      20,     12,     0 }, // 14
    {  8,  8, &stage_enemy_e0703,   action_flightpath_005,                  704,    32,     0,      32,     10,     20,     12,     0 }, // 15
    {  8,  8, &stage_enemy_e0101,   action_flightpath_left_circle_002,      704,    32,     0,      32,     6,      20,     15,     0 }, // 16
    {  8,  8, &stage_enemy_e0202,   action_flightpath_right_circle_003,     -64,    32,     0,      32,     8,      20,     15,     0 }, // 17
    {  8,  8, &stage_enemy_e0401,   action_flightpath_right_circle_003,     704,    32,     0,      32,     10,     20,     17,     0 }, // 18
    {  8,  8, &stage_enemy_e0401,   action_flightpath_left_circle_002,      704,    32,     0,      32,     10,     20,     17,     0 }  // 19
};

__export volatile stage_floor_bram_tiles_t stage_floor_bram_tiles_01[] = {
    { &mars_land_bram }, 
    { &mars_sand_bram }, 
    { &mars_sea_bram }, 
    { &metal_yellow_bram }, 
    { &metal_red_bram }, 
    { &metal_grey_bram }, 
};

__export volatile
stage_floor_t stage_floor_01 = {
    6, stage_floor_bram_tiles_01, &mars
};

__export volatile stage_floor_bram_tiles_t stage_tower_bram_tiles_01[] = {
    { &tower_bram },
    { &mars_sea_bram }
};


__export volatile
stage_tower_t stage_towers_01 = {
    2, stage_tower_bram_tiles_01, &tower_01, t001, 
    16, 16, 8, 8,
    &stage_bullet_vertical_laser
};

// PLAYBOOK

// This models the playbook of all the different levels in the game.
// The embedded level field in the playbook is a pointer to a level composition.
__export volatile stage_playbook_t stage_playbooks_b[] = {
    { 19, stage_scenario_01_b, &stage_player, &stage_floor_01, 1, &stage_towers_01 }
};

__export volatile
stage_script_t stage_script_b = {
    1, stage_playbooks_b
};

#pragma data_seg(Data)

