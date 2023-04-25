#pragma once

/**
 * @file equinoxe-palette-types.h
 * @author your name (you@domain.com)
 * @brief Typedefs for palette management
 * @version 0.1
 * @date 2022-05-03
 * 
 * @copyright Copyright (c) 2022
 * 
 */

typedef struct {
    unsigned char palette[32]; // 32 palette bytes.
} palette_16_t;

typedef struct {
    unsigned char palette[128]; // 128 palette bytes.
} palette_64_t;

typedef struct {
    palette_16_t palette_16[64]; // Map 64 palette entries of each 32 bytes.
    palette_64_t palette_64[16]; // Map 16 palette entries of each 128 bytes.
} palette_bram_t;

typedef struct {
    unsigned char vram_index[64];       // Indicates if the palette is allocated in vram.
    unsigned char used[64];             // Indicates if this is a free slot to load a palette in bram.
} palette_bram_index_t;

// Manage used and free palette offsets for dynamic palette loading and switching in vram from bram palette data.
typedef struct {
    unsigned char bram_index[16];
    unsigned char used[16];
    vram_offset_t offset[16];
} palette_vram_index_t;



// Definition of file names for palette loading. 
// The palette_files_t type will be declared as an array representing levels.
// For each level there will be one PALETTE_FILE entry.
typedef struct {
    char* file_palette_sprites;
    char* file_palette_floor;
    char* file_palette_tower;
} palette_files_t;

typedef unsigned char palette_index_t;
typedef struct {
    bram_bank_t bram_bank;
    palette_index_t pool;
    palette_index_t vram_index;
    palette_vram_index_t vram;
    palette_bram_index_t bram;
} palette_t;

typedef palette_16_t* palette_ptr_t;
