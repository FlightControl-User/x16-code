    // Load the palettes in main banked memory.
    heap_address bram_palettes = heap_segment_bram(
        HEAP_SEGMENT_BRAM_PALETTES, 
        cx16_bram_pack(63, (heap_ptr)0xA000), 
        cx16_size_pack(0x2000)
        );

    heap_handle handle_bram_palettes = heap_alloc(HEAP_SEGMENT_BRAM_PALETTES, 8192);
    heap_ptr ptr_bram_palettes = heap_data_ptr(handle_bram_palettes);
    heap_bank bank_bram_palettes = heap_data_bank(handle_bram_palettes);

    cx16_ptr ptr_bram_end = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES_FLOOR01, bank_bram_palettes, ptr_bram_palettes);
    if(!ptr_bram_end) printf("error file_palettes");
    
    cx16_cpy_vram_from_bram(VERA_PALETTE_BANK, (word)VERA_PALETTE_PTR+32, bank_bram_palettes, ptr_bram_palettes, (ptr_bram_end-ptr_bram_palettes));

    ptr_bram_palettes = ptr_bram_end;
    ptr_bram_end = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES_SPRITE01, bank_bram_palettes, ptr_bram_palettes);
    if(!ptr_bram_end) printf("error file_palettes");
    cx16_cpy_vram_from_bram(VERA_PALETTE_BANK, (word)(VERA_PALETTE_PTR+((word)ptr_bram_end-(word)0xa000))+32, bank_bram_palettes, ptr_bram_palettes, (ptr_bram_end-ptr_bram_palettes));

    ptr_bram_palettes = ptr_bram_end;


