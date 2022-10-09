void petscii() {

    vera_layer1_mode_tile(
        // Maps must be aligned to 512 bytes, so allocate the map second.
        1, (vram_offset_t)0xB000, 
        // Tiles must be aligned to 2048 bytes, to allocate the tile map first. Note that the size parameter does the actual alignment to 2048 bytes.
        1, (vram_offset_t)0xF000, 
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

