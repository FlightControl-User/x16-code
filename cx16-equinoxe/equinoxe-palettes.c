    // Load the palettes in main banked memory.
    heap_segment segment_bram_palettes = heap_segment_bram(HEAP_SEGMENT_BRAM_PALETTES, 62, 0xC000, 62, 0xA000);
    heap_handle handle_bram_palettes = heap_alloc(segment_bram_palettes, 8192);
    heap_ptr ptr_bram_palettes = heap_data_ptr(handle_bram_palettes);
    heap_bank bank_bram_palettes = heap_data_bank(handle_bram_palettes);

    byte status = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, bank_bram_palettes, ptr_bram_palettes);
    if(status!=$ff) printf("error file_palettes = %u",status);

    // Load the palette in VERA palette registers, but keep the first 16 colors untouched.
    // vera_cpy_bank_vram(bram_palette, VERA_PALETTE+32, (dword)32*15);
    cx16_cpy_vram_from_bram(VERA_PALETTE_BANK, (word)VERA_PALETTE_PTR+32, bank_bram_palettes, ptr_bram_palettes, 32*15);
