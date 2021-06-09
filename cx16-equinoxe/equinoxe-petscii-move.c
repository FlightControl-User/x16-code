    // Memory is managed as follows:
    // ------------------------------------------------------------------------
    //
    // HEAP SEGMENT                     VRAM                  BRAM
    // -------------------------        -----------------     -----------------
    // HEAP_SEGMENT_VRAM_PETSCII        01/B000 - 01/F800     01/A000 - 01/A400
    // HEAP_SEGMENT_VRAM_SPRITES        00/0000 - 01/B000     01/A400 - 01/C000
    // HEAP_SEGMENT_BRAM_SPRITES                              02/A000 - 20/C000
    // HEAP_SEGMENT_BRAM_PALETTE                              3F/A000 - 3F/C000

