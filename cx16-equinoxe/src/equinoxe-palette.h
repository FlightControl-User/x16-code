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

#include "equinoxe-palette-types.h"

extern palette_bram_t palette_bram; // List of palette definitions.

extern palette_files_t palette_files[16];

void palette_vram_init();
void palette_load(unsigned char level);
unsigned char palette16_alloc();
unsigned int palette16_use(unsigned char bram_index);
void palette16_unuse(unsigned char bram_index);
void palette64_use(unsigned char bram_index);
void palette16_free(unsigned char bram_index);
