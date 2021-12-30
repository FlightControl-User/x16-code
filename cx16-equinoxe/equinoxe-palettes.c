    // Load the palettes in main banked memory.
    heap_address bram_palettes = heap_segment_bram(
        HEAP_SEGMENT_BRAM_PALETTES, 
        heap_bram_pack(63, (heap_ptr)0xA000), 
        heap_size_pack(0x2000)
        );

    heap_handle handle_bram_palettes = heap_alloc(HEAP_SEGMENT_BRAM_PALETTES, 8192);
    heap_ptr ptr_bram_palettes = heap_data_ptr(handle_bram_palettes);
    heap_bank bank_bram_palettes = heap_data_bank(handle_bram_palettes);

    unsigned int palette_loaded = 0;

    unsigned int floor_palette_loaded = cx16_bram_load(1, 8, 0, FILE_PALETTES_FLOOR01, bank_bram_palettes, ptr_bram_palettes);
    if(!floor_palette_loaded) printf("error file_palettes");
    palette_loaded += floor_palette_loaded;
    
    unsigned int sprite_palette_loaded = cx16_bram_load(1, 8, 0, FILE_PALETTES_SPRITE01, bank_bram_palettes, ptr_bram_palettes+palette_loaded);
    if(!sprite_palette_loaded) printf("error file_palettes");
    palette_loaded += sprite_palette_loaded;

    cx16_cpy_vram_from_bram(VERA_PALETTE_BANK, (word)VERA_PALETTE_PTR+32, bank_bram_palettes, ptr_bram_palettes, ptr_bram_palettes+palette_loaded);

