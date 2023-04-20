/**
 * @file equinoxe-palette.h
 * @author your name (you@domain.com)
 * @brief 
 * @version 0.1
 * @date 2022-05-03
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <cx16.h>
#include <cx16-vera.h>
#include "../src/equinoxe-palette-types.h"

extern palette_bram_t palette_bram; // List of palette definitions.

void palette_init(bram_bank_t bram_bank);

palette_ptr_t palette_ptr_bram(palette_index_t palette_index);
palette_index_t palette_alloc_bram();
void palette_free_bram(palette_index_t palette_index);

unsigned char palette_alloc_vram();
palette_index_t palette_use_vram(palette_index_t palette_index);
void palette_unuse_vram(unsigned int bram_index);
void palette_free_vram(unsigned int bram_index);

inline void palette_bank();
inline void palette_unbank();
