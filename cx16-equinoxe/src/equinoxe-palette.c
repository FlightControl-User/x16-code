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
#include <cx16-fb.h>
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
__address(0xA000) PALETTE_BRAM palette_bram; // List of palettes in bram bank 63! Dynamically loaded!
#pragma data_seg(Data)

// Definition of palette files per level.
PALETTE_FILES palette_files[] = {
    { "palsprite01.bin", "palfloor01.bin" }
};

PALETTE_VRAM_INDEX palette_vram_index;
PALETTE_BRAM_INDEX palette_bram_index;

volatile unsigned char palette_index;

void palette_vram_init()
{
    for(unsigned int i=0; i<16; i++) {
        palette_vram_index.offset[i] = (vram_offset_t)(VERA_PALETTE_PTR+(i*32));
        palette_vram_index.used[i] = 0;
    }
    palette_vram_index.used[0] = 1;

    palette_index = 5;
}

void palette_load(unsigned char level)
{

    printf("%s, %s, ", palette_files[level].file_palette64, palette_files[level].file_palette16);

    // Load the palettes in main banked memory.
    unsigned int floor_palette_loaded = load_file(1, 8, 0, palette_files[level].file_palette64, BRAM_PALETTE_BANK, (bram_ptr_t)palette_bram.palette_64);
    unsigned int sprite_palette_loaded = load_file(1, 8, 0, palette_files[level].file_palette16, BRAM_PALETTE_BANK, (bram_ptr_t)palette_bram.palette_16);

    printf("%u, %u\n", floor_palette_loaded, sprite_palette_loaded);
}


unsigned char palette16_alloc()
{
    for(unsigned char i=5; i<16; i++) {
        if(palette_index >= 16)
            palette_index=5;
        if(!palette_vram_index.used[palette_index])
            return palette_index; // We use the free palette slot.
        palette_index++;
    }
    return 0;
}

unsigned int palette16_use(char bram_index)
{
    unsigned char vram_index = palette_bram_index.vram_index[bram_index];
    if(!vram_index) {
        vram_index = palette16_alloc();
        if(vram_index) {
            memcpy_vram_bram(VERA_PALETTE_BANK, palette_vram_index.offset[vram_index], BRAM_PALETTE_BANK, (bram_ptr_t)&palette_bram.palette_16[bram_index], 32);
            palette_bram_index.vram_index[bram_index] = vram_index;
        }
    }

    palette_vram_index.used[vram_index]++;
    gotoxy(40, 10+vram_index);
    printf("memcpy v=%03u, us=%03u, b=%03u, i=%03u", vram_index, palette_vram_index.used[vram_index], bram_index, palette_bram_index.vram_index[bram_index]);
    return vram_index;
}

void palette16_unuse(char bram_index)
{
    unsigned char vram_index = palette_bram_index.vram_index[bram_index];
    palette_vram_index.used[vram_index]--;
    gotoxy(40, 10+vram_index);
    printf("memcpy v=%03u, us=%03u, b=%03u, i=%03u", vram_index, palette_vram_index.used[vram_index], bram_index, palette_bram_index.vram_index[bram_index]);
}

void palette64_use(char bram_index)
{
    memcpy_vram_bram(VERA_PALETTE_BANK, palette_vram_index.offset[1], BRAM_PALETTE_BANK, (bram_ptr_t)&palette_bram.palette_64[bram_index], 32*4);
}

void palette16_free(char bram_index)
{
    unsigned char vram_index = palette_bram_index.vram_index[bram_index];
    palette_vram_index.used[vram_index] = 0;
    palette_bram_index.vram_index[bram_index] = 0;
}

