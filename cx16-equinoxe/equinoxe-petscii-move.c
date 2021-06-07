    // Memory is managed as follows:
    // ------------------------------------------------------------------------
    //
    // HEAP SEGMENT                     VRAM                  BRAM
    // -------------------------        -----------------     -----------------
    // HEAP_SEGMENT_VRAM_PETSCII        01/B000 - 01/F800     01/A000 - 01/A400
    // HEAP_SEGMENT_VRAM_SPRITES        00/0000 - 01/B000     01/A400 - 01/C000
    // HEAP_SEGMENT_BRAM_SPRITES                              02/A000 - 20/C000
    // HEAP_SEGMENT_BRAM_PALETTE                              3F/A000 - 3F/C000


    // Handle the relocation of the CX16 petscii character set and map to the most upper corner in VERA VRAM.
    heap_segment segment_vram_petscii = heap_segment_vram(HEAP_SEGMENT_VRAM_PETSCII, 1, 0xF800, 1, (0xF800-VRAM_PETSCII_MAP_SIZE-VERA_PETSCII_TILE_SIZE), 1, 0xA000, 16);
    cx16_cpy_vram_from_vram(1, 0xF000, 0, 0xF800, 800);
    vera_layer_mode_tile(1, 0x1B000, 0x1F000, 128, 64, 8, 8, 1);
    screenlayer(1);
    textcolor(WHITE);
    bgcolor(DARK_GREY);
    clrscr();
