void petscii() {

    // Tiles must be aligned to 2048 bytes, to allocate the tile map first. Note that the size parameter does the actual alignment to 2048 bytes.
    fb_heap_handle_t handle_vram_petscii_tile = {1, (fb_heap_handle_ptr_t)0xF000};

    // Maps must be aligned to 512 bytes, so allocate the map second.
    fb_heap_handle_t handle_vram_petscii_map =  {1, (fb_heap_handle_ptr_t)0xB000};

    // memcpy_vram_vram(handle_vram_petscii_tile.bank, (word)handle_vram_petscii_tile.ptr, 0, VERA_PETSCII_TILE, VERA_PETSCII_TILE_SIZE);

    vera_layer1_mode_tile(
        handle_vram_petscii_map.bank, (vram_offset_t)handle_vram_petscii_map.ptr, 
        handle_vram_petscii_tile.bank, (vram_offset_t)handle_vram_petscii_tile.ptr, 
        VERA_LAYER_WIDTH_128, VERA_LAYER_HEIGHT_64, 
        VERA_TILEBASE_WIDTH_8, VERA_TILEBASE_HEIGHT_8, 
        VERA_LAYER_COLOR_DEPTH_1BPP
    );

    screenlayer1();
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();
    vera_layer1_show();
    vera_layer0_hide();
    scroll(0);

}

