/**
 * @file equinoxe-palette.c
 * @author your name (you@domain.com)
 * @brief 
 * @version 0.1
 * @date 2022-05-03
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <cx16.h>
// // #include <cx16-fb.h>
// #include <cx16-veralib.h>
// #include <cx16-mouse.h>
// #include <stdlib.h>
// #include <kernal.h>
// #include <6502.h>
// #include <conio.h>
// #include <cx16-conio.h>
// #include <printf.h>
// #include <stdio.h>
// #include <division.h>
// #include <mos6522.h>
// #include <multiply.h>
// #include <cx16-bitmap.h>
// #include <cx16-file.h>

// #include "equinoxe-types.h"
// #include "equinoxe.h"
// #include "equinoxe-palette.h"
// #include "equinoxe-stage.h"
// #include "equinoxe-flightengine.h"
// #include "equinoxe-floorengine.h"
// #include "equinoxe-enemy.h"
// #include "equinoxe-bullet.h"
// #include "equinoxe-fighters.h"
// #include "equinoxe-enemy.h"
// #include "equinoxe-player.h"
// #include "equinoxe-math.h"

// #include "equinoxe-defines.h"

// #include <ht.h>

#include <cx16-vera.h>
#include "../src/equinoxe-palette-types.h"

#pragma zp_reserve(0x00..0xFF, 0x80..0xA8)

#pragma data_seg(BramEnginePalette)
palette_bram_t palette_bram; // List of palettes in bram! Dynamically loaded!

#pragma data_seg(DataEnginePalette)
palette_t palette;

void palette_init(bram_bank_t bram_bank)
{
    palette.bram_bank = bram_bank;

    // Doubled to save zeropage...
    for(unsigned char i=0; i<16; i++) {
        palette.vram.offset[i] = (vram_offset_t)(VERA_PALETTE_PTR+(unsigned int)((unsigned int)i*(unsigned int)32));
        palette.vram.used[i] = 0;
    }
    palette.vram.used[0] = 1;

    palette.vram_index = 1; // this needs to be revisited, a hardcoding that is meant to skip the tiles, but this will vary during play.
    palette.pool = 0;
}

/**
 * @brief Return the address of palette slot in bram. 
 * 
 * @return palette_ptr_t The address in bram. Note that the bank must be properly set to use the data behind the pointer.
 */
palette_ptr_t palette_ptr_bram(palette_index_t palette_index) {

    return (palette_ptr_t)&palette_bram.palette_16[(unsigned int)palette_index];
}

palette_index_t palette_alloc_bram()
{
    // Search for an empty slot.
    // There are a maximum of 64 different palettes that can be loaded in bram.
    while(palette.bram.used[palette.pool]) {
        palette.pool = (palette.pool + 1) % 64;
    }

    palette.bram.used[palette.pool] = 1;
    return palette.pool;
}

void palette_free_bram(palette_index_t palette_index) {

    palette_free_vram(palette_index);

    palette.bram.used[palette_index] = 0;
}


palette_index_t palette_alloc_vram()
{
    for(unsigned char vram_index=1; vram_index<16; vram_index++) {
        if(palette.vram_index >= 16)
            palette.vram_index=1;
        #ifdef __DEBUG_PALETTE
        gotoxy(40,9);
        printf("alloc i=%03u, u=%03u", palette.vram_index, palette.vram.used[palette.vram_index]);
        #endif
        if(!palette.vram.used[palette.vram_index]) {
            return palette.vram_index; // We use the free palette slot.
        }
        palette.vram_index++;
    }
    return 0;
}

palette_index_t palette_use_vram(palette_index_t palette_index)
{
    unsigned char vram_index = palette.bram.vram_index[palette_index];
    if(!vram_index) {
        vram_index = palette_alloc_vram();
        if(vram_index) {
            if(palette.vram.bram_index[vram_index])
                palette.bram.vram_index[palette.vram.bram_index[vram_index]] = 0;
            palette.vram.bram_index[vram_index] = palette_index;
            memcpy_vram_bram_fast(VERA_PALETTE_BANK, palette.vram.offset[vram_index], palette.bram_bank, (bram_ptr_t)palette_ptr_bram(palette_index), 32);
            palette.bram.vram_index[palette_index] = vram_index;
        }
    }

    palette.vram.used[vram_index]++;
    #ifdef __DEBUG_PALETTE
    gotoxy((unsigned char)40, (unsigned char)10+vram_index);
    printf("memcpy v=%03u, u=%03u, b=%03u, i=%03u", vram_index, palette.vram.used[vram_index], palette_index, palette.bram.vram_index[palette_index]);
    #endif
    return vram_index;
}

void palette_unuse_vram(unsigned int bram_index)
{
    unsigned char vram_index = palette.bram.vram_index[bram_index];
    palette.vram.used[vram_index]--;
    #ifdef __DEBUG_PALETTE
    gotoxy(40, 10+vram_index);
    printf("memcpy v=%03u, u=%03u, b=%03u, i=%03u", vram_index, palette.vram.used[vram_index], bram_index, palette.bram.vram_index[bram_index]);
    #endif
}

void palette_free_vram(unsigned int bram_index)
{
    unsigned char vram_index = palette.bram.vram_index[bram_index];
    palette.vram.used[vram_index] = 0;
    palette.bram.vram_index[bram_index] = 0;
}

// must be inline
inline void palette_bank() {
    bank_push_set_bram(palette.bram_bank);
}

inline void palette_unbank() {
    bank_pull_bram();
}

#pragma data_seg(Data)
#pragma code_seg(Code)
