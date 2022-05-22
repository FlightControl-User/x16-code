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
    unsigned char vram_index[64];
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
    char* file_palette16;
    char* file_palette64;
} palette_files_t;
