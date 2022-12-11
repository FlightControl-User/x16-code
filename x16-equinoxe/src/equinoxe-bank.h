 
    // Memory is managed as follows:
    // ------------------------------------------------------------------------
    //
    // SEGMENT                          VRAM                  BRAM
    // -------------------------        -----------------     -----------------
    // FLOOR MAP                        00:0000 - 00:2000     
    // FLOOR TILE                       00:2000 - 00:A000
    // SPRITES                          00:A000 - 01:B000
    // PETSCII                          01:B000 - 01:F800     
    // 
    // BRAM_VERAHEAP                                          01:A000 - 01:BFFF
    // BRAM_FLIGHTENGINE                                      02:A000 - 02:BFFF
    // BRAM_STAGE                                             03:A000 - 03:BFFF
    // BRAM_SPRITE_CONTROL                                    04:A000 - 04:BFFF
    // BRAM_PALETTE                                           3F:A000 - 3F:BFFF

#define BRAM_VERAHEAP           1
#define BRAM_FLIGHTENGINE       2
#define BRAM_ENGINE_TOWERS      2
#define BRAM_STAGE              3
#define BRAM_SPRITE_CONTROL     4
#define BRAM_FLOOR_CONTROL      5
#define BRAM_PALETTE            6
#define BRAM_FREE               7

#define BRAM_HEAP_BRAM_BLOCKED  8

// todo to move into vera memory addressing define
#define FLOOR_MAP0_BANK_VRAM 0
#define FLOOR_MAP0_OFFSET_VRAM  0x0000

#define FLOOR_MAP1_BANK_VRAM 1
#define FLOOR_MAP1_OFFSET_VRAM  0xB000

#define FLOOR_TILE_BANK_VRAM 0
#define FLOOR_TILE_OFFSET_VRAM 0x2000

#define SPRITE_BANK_VRAM 0
#define SPRITE_OFFSET_VRAM 0x4000
