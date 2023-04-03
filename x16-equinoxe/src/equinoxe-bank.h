 
    // VERA Memory is managed as follows:
    // ------------------------------------------------------------------------
    //
    // SEGMENT                          VRAM                  BRAM
    // -------------------------        -----------------     -----------------
    // FLOOR MAP                        00:0000 - 00:2000     
    // FLOOR TILE                       00:2000 - 00:A000
    // SPRITES                          00:A000 - 01:B000
    // PETSCII                          01:B000 - 01:F800     


//      BRAM ID                     BANK
//      --------------------------------
#define BRAM_VERAHEAP               0x01
#define BRAM_FLIGHTENGINE           0x02
#define BRAM_ENGINE_TOWERS          0x02
#define BRAM_ENGINE_STAGES          0x03
#define BRAM_SPRITE_CONTROL         0x04
#define BRAM_FLOOR_CONTROL          0x05
#define BRAM_PALETTE                0x06
#define BRAM_ENGINE_BULLETS         0x07
#define BRAM_ENGINE_ENEMIES         0x08
#define BRAM_ENGINE_FLOOR           0x09
#define BRAM_HEAP_BRAM_BLOCKED      0x0F


//      SEGMENTS                    LINKER ID
//      --------------------------- ---------------------
#define SEGM_ENGINE_STAGES          segm_engine_stages
#define SEGM_ENGINE_ENEMIES         segm_engine_enemies
#define SEGM_ENGINE_BULLETS         segm_engine_bullets
#define SEGM_ENGINE_FLOOR           segm_engine_floor


// todo to move into vera memory addressing define
#define FLOOR_MAP0_BANK_VRAM        0x00
#define FLOOR_MAP0_OFFSET_VRAM      0x0000

#define FLOOR_MAP1_BANK_VRAM        0x01
#define FLOOR_MAP1_OFFSET_VRAM      0xB000

#define FLOOR_TILE_BANK_VRAM        0x00
#define FLOOR_TILE_OFFSET_VRAM      0x2000

#define SPRITE_BANK_VRAM            0x00
#define SPRITE_OFFSET_VRAM          0x4000
