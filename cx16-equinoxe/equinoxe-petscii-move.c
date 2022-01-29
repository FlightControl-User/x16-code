heap_address petscii() {

    heap_address vram_floor_petscii = heap_segment_vram_ceil(
        HEAP_SEGMENT_VRAM_PETSCII, 
        heap_vram_pack(1, 0xF800),
        heap_size_pack(VRAM_PETSCII_MAP_SIZE + VERA_PETSCII_TILE_SIZE),
        heap_bram_pack(1, (bram_ptr_t)0xA000), 
        heap_size_pack(16*8)
        );

    // Tiles must be aligned to 2048 bytes, to allocate the tile map first. Note that the size parameter does the actual alignment to 2048 bytes.
    heap_handle handle_vram_petscii_tile = heap_alloc(HEAP_SEGMENT_VRAM_PETSCII, VERA_PETSCII_TILE_SIZE);

    // Maps must be aligned to 512 bytes, so allocate the map second.
    heap_handle handle_vram_petscii_map = heap_alloc(HEAP_SEGMENT_VRAM_PETSCII, VRAM_PETSCII_MAP_SIZE);

    //vera_cpy_vram_vram(VERA_PETSCII_TILE, VRAM_PETSCII_TILE, VERA_PETSCII_TILE_SIZE);
    heap_vram_offset ptr_vram_petscii_map = (heap_vram_offset)heap_data_ptr(handle_vram_petscii_map); // TODO: rework to offset API call.
    heap_bank bank_vram_petscii_map = heap_data_bank(handle_vram_petscii_map);
    heap_vram_offset ptr_vram_petscii_tile = (heap_vram_offset)heap_data_ptr(handle_vram_petscii_tile);
    heap_bank bank_vram_petscii_tile = heap_data_bank(handle_vram_petscii_tile);

    memcpy_vram_vram(bank_vram_petscii_tile, (word)ptr_vram_petscii_tile, 0, VERA_PETSCII_TILE, VERA_PETSCII_TILE_SIZE);

    dword vram_petscii_map = vera_ptr_to_address(bank_vram_petscii_map, (char*)ptr_vram_petscii_map);
    dword vram_petscii_tile = vera_ptr_to_address(bank_vram_petscii_tile, (char*)ptr_vram_petscii_tile); 

    // printf("vram_floor_petscii = %x:%x\n", cx16_vram_unpack_bank(vram_floor_petscii), cx16_vram_unpack_offset(vram_floor_petscii));
    // printf("handle_vram_petscii_map = %x\n", handle_vram_petscii_map);
    // printf("ptr_vram_petscii_map = %x\n", ptr_vram_petscii_map);
    // printf("bank_vram_petscii_map = %x\n", bank_vram_petscii_map);
    // printf("handle_vram_petscii_map = %x\n", handle_vram_petscii_tile);
    // printf("ptr_vram_petscii_tile = %x\n", ptr_vram_petscii_tile);
    // printf("bank_vram_petscii_tile = %x\n", bank_vram_petscii_tile);
    // printf("vram_petscii_map = %x\n", vram_petscii_map);
    // printf("vram_petscii_tile = %x\n", vram_petscii_tile);

    // while(!kbhit());

    vera_layer_mode_tile(1, vram_petscii_map, vram_petscii_tile, 128, 64, 8, 8, 1);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    return vram_floor_petscii;
}

