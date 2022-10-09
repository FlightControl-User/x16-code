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
// #include <cx16-fb.h>
#include <cx16-veralib.h>
#include <cx16-mouse.h>
#include <stdlib.h>
#include <kernal.h>
#include <6502.h>
#include <conio.h>
#include <cx16-conio.h>
#include <printf.h>
#include <stdio.h>
#include <division.h>
#include <mos6522.h>
#include <multiply.h>
#include <cx16-bitmap.h>

#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-palette.h"
#include "equinoxe-stage.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-floorengine.h"
#include "equinoxe-enemy.h"
#include "equinoxe-bullet.h"
#include "equinoxe-fighters.h"
#include "equinoxe-enemy.h"
#include "equinoxe-player.h"
#include "equinoxe-math.h"

#include <ht.h>

#pragma data_seg(Palette)
palette_bram_t palette_bram; // List of palettes in bram bank 63! Dynamically loaded!

#pragma data_seg(Data)

// Definition of palette files per level.
palette_files_t palette_files[] = {
    { "palsprite01.bin", "palfloor01.bin" }
};

palette_t palette;
// palette.vram_index_t palette.vram_index;
// palette.bram_index_t palette.bram_index;

void palette_init(bram_bank_t bram_bank)
{
    palette.bram_bank = bram_bank;

    for(unsigned int i=0; i<16; i++) {
        palette.vram_index.offset[i] = (vram_offset_t)(VERA_PALETTE_PTR+(i*32));
        palette.vram_index.used[i] = 0;
    }
    palette.vram_index.used[0] = 1;

    palette.index = 5; // this needs to be revisited, a hardcoding that is meant to skip the tiles, but this will vary during play.
}

void palette_load(unsigned char level)
{

    #ifdef __DEBUG_FILE
    printf("%s, %s, ", palette_files[level].file_palette64, palette_files[level].file_palette16);
    #endif

    // Load the palettes in main banked memory.
    unsigned int floor_palette_loaded = file_load_bram(1, 8, 2, palette_files[level].file_palette64, BRAM_PALETTE, (bram_ptr_t)palette_bram.palette_64);
    unsigned int sprite_palette_loaded = file_load_bram(1, 8, 2, palette_files[level].file_palette16, BRAM_PALETTE, (bram_ptr_t)palette_bram.palette_16);

    #ifdef __DEBUG_FILE
    printf("%u, %u\n", floor_palette_loaded, sprite_palette_loaded);
    #endif
}


unsigned char palette16_alloc()
{
    for(unsigned char i=5; i<16; i++) {
        if(palette.index >= 16)
            palette.index=5;
        #ifdef __DEBUG_PALETTE
        gotoxy(40,9);
        printf("alloc i=%03u, u=%03u", palette.index, palette.vram_index.used[palette.index]);
        #endif
        if(!palette.vram_index.used[palette.index]) {
            return palette.index; // We use the free palette slot.
        }
        palette.index++;
    }
    return 0;
}

unsigned int palette16_use(unsigned int bram_index)
{
    unsigned char vram_index = palette.bram_index.vram_index[bram_index];
    if(!vram_index) {
        vram_index = palette16_alloc();
        if(vram_index) {
            if(palette.vram_index.bram_index[vram_index])
                palette.bram_index.vram_index[palette.vram_index.bram_index[vram_index]] = 0;
            palette.vram_index.bram_index[vram_index] = bram_index;
            memcpy_vram_bram(VERA_PALETTE_BANK, palette.vram_index.offset[vram_index], BRAM_PALETTE, (bram_ptr_t)&palette_bram.palette_16[bram_index], 32);
            palette.bram_index.vram_index[bram_index] = vram_index;
        }
    }

    palette.vram_index.used[vram_index]++;
    #ifdef __DEBUG_PALETTE
    gotoxy((unsigned char)40, (unsigned char)10+vram_index);
    printf("memcpy v=%03u, u=%03u, b=%03u, i=%03u", vram_index, palette.vram_index.used[vram_index], bram_index, palette.bram_index.vram_index[bram_index]);
    #endif
    return vram_index;
}

void palette16_unuse(unsigned int bram_index)
{
    unsigned char vram_index = palette.bram_index.vram_index[bram_index];
    palette.vram_index.used[vram_index]--;
    #ifdef __DEBUG_PALETTE
    gotoxy(40, 10+vram_index);
    printf("memcpy v=%03u, u=%03u, b=%03u, i=%03u", vram_index, palette.vram_index.used[vram_index], bram_index, palette.bram_index.vram_index[bram_index]);
    #endif
}

void palette64_use(unsigned int bram_index)
{
    memcpy_vram_bram(VERA_PALETTE_BANK, palette.vram_index.offset[1], BRAM_PALETTE, (bram_ptr_t)&palette_bram.palette_64[bram_index], 32*4);
}

void palette16_free(unsigned int bram_index)
{
    unsigned char vram_index = palette.bram_index.vram_index[bram_index];
    palette.vram_index.used[vram_index] = 0;
    palette.bram_index.vram_index[bram_index] = 0;
}
