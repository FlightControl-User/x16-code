#pragma once

/**
 * @file equinoxe-palette-lib.h
 * @author your name (you@domain.com)
 * @brief 
 * @version 0.1
 * @date 2022-05-03
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <cx16.h>
#include "equinoxe-palette-types.h"

extern __stackcall __library(palette) void palette_init(bram_bank_t bram_bank);

extern __stackcall __library(palette) palette_ptr_t palette_ptr_bram(palette_index_t palette_index);
extern __stackcall __library(palette) palette_index_t palette_alloc_bram();
extern __stackcall __library(palette) void palette_free_bram(palette_index_t palette_index);

extern __stackcall __library(palette) unsigned char palette_alloc_vram();
extern __stackcall __library(palette) palette_index_t palette_use_vram(palette_index_t palette_index);
extern __stackcall __library(palette) void palette_unuse_vram(unsigned int bram_index);
extern __stackcall __library(palette) void palette_free_vram(unsigned int bram_index);
