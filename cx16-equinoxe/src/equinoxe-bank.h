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

const bram_bank_t BRAM_VERAHEAP = 1;
const bram_bank_t BRAM_FLIGHTENGINE = 2;
const bram_bank_t BRAM_STAGE = 3;
const bram_bank_t BRAM_SPRITE_CONTROL = 4;
const bram_bank_t BRAM_LOAD_AREA = 5;
const bram_bank_t BRAM_PALETTE = 7;

