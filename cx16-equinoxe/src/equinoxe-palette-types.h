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
} PALETTE_16;

typedef struct {
    unsigned char palette[128]; // 128 palette bytes.
} PALETTE_64;

typedef struct {
    PALETTE_16 palette_16[64]; // Map 64 palette entries of each 32 bytes.
    PALETTE_64 palette_64[16]; // Map 16 palette entries of each 128 bytes.
} PALETTE_BRAM;

typedef struct {
    unsigned char vram_index[64];
} PALETTE_BRAM_INDEX;

// Manage used and free palette offsets for dynamic palette loading and switching in vram from bram palette data.
typedef struct {
    unsigned char bram_index[16];
    unsigned char used[16];
    vram_offset_t offset[16];
} PALETTE_VRAM_INDEX;



// Definition of file names for palette loading. 
// The PALETTE_FILES type will be declared as an array representing levels.
// For each level there will be one PALETTE_FILE entry.
typedef struct {
    char* file_palette16;
    char* file_palette64;
} PALETTE_FILES;
