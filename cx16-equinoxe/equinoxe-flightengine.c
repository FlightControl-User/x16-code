// Space flight engine for a space game written in kickc for the Commander X16.

#pragma link("equinoxe.ld")

#pragma encoding(petscii_mixed)

#pragma var_model(mem)

#define __FLOOR
#define __FLIGHT
#define __PALETTE
// #define __FILE

#include <stdlib.h>
#include <cx16.h>
#include <cx16-fb.h>
#include <cx16-veralib.h>
#include <cx16-mouse.h>
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

#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-floorengine.h"
#include "equinoxe-player.h"
#include "equinoxe-enemy.h"
#include "equinoxe-fighters.h"
#include "equinoxe-bullet.h"

#include <ht.h>

void sprite_cpy_vram_from_bram(Sprite* sprite, heap_handle* vram_sprites) {

    unsigned char SpriteCount = sprite->SpriteCount;
    unsigned int SpriteSize = sprite->SpriteSize;

    for (unsigned char s=0; s<SpriteCount; s++) {

        heap_handle handle_bram = sprite->bram_handle[s];

        memcpy_vram_bram(vram_sprites->bank, (vram_offset_t)vram_sprites->ptr, handle_bram.bank, (bram_ptr_t)handle_bram.ptr, SpriteSize);

        sprite->offset_image[s] = vera_sprite_get_image_offset(vram_sprites->bank, (vram_offset_t)vram_sprites->ptr);
        *vram_sprites = heap_handle_add_vram(*vram_sprites, SpriteSize);
    }
}

// Load the sprite into bram using the new cx16 heap manager.
void sprite_load(Sprite* sprite) 
{

    printf("loading sprites %s\n", sprite->File);
    printf("spritecount=%u, spritesize=%u", sprite->SpriteCount, sprite->SpriteSize);
    printf(", opening\n");


    unsigned int status = open_file(1, 8, 0, sprite->File);
    if (status) printf("error opening file %s\n", sprite->File);

    // printf("spritecount = %u\n", sprite->SpriteCount);

    for(unsigned char s=0; s<sprite->SpriteCount; s++) {
        printf("allocating");
        heap_handle handle_bram = heap_alloc(bins, sprite->SpriteSize);
        printf(", bram=%02x:%04p", handle_bram.bank, handle_bram.ptr);
        printf(", loading");
        unsigned int bytes_loaded = load_file_bram(1, 8, 0, handle_bram.bank, handle_bram.ptr, sprite->SpriteSize);
        if (!bytes_loaded) {
            printf("error loading file %s\n", sprite->File);
            break;
        }
        printf(" %u bytes\n", bytes_loaded);
        sprite->bram_handle[s] = handle_bram; // TODO: rework this to map into banked memory.
    }

    status = close_file(1, 8, 0);
    if (status) printf("error closing file %s\n", sprite->File);

    printf(", done\n");
}


#include "equinoxe-petscii-move.c"

void sprite_configure(vera_sprite_offset sprite_offset, Sprite* sprite) {
    // vera_sprite_buffer_bpp((vera_sprite_buffer_item_t *)sprite_offset, sprite->BPP);
    // vera_sprite_buffer_height((vera_sprite_buffer_item_t *)sprite_offset, sprite->Height);
    // vera_sprite_buffer_width((vera_sprite_buffer_item_t *)sprite_offset, sprite->Width);
    // vera_sprite_buffer_hflip((vera_sprite_buffer_item_t *)sprite_offset, sprite->Hflip);
    // vera_sprite_buffer_vflip((vera_sprite_buffer_item_t *)sprite_offset, sprite->Vflip);
    // vera_sprite_buffer_palette_offset((vera_sprite_buffer_item_t *)sprite_offset, sprite->PaletteOffset);
    vera_sprite_bpp(sprite_offset, sprite->BPP);
    vera_sprite_height(sprite_offset, sprite->Height);
    vera_sprite_width(sprite_offset, sprite->Width);
    vera_sprite_hflip(sprite_offset, sprite->Hflip);
    vera_sprite_vflip(sprite_offset, sprite->Vflip);
    vera_sprite_palette_offset(sprite_offset, sprite->PaletteOffset);
}

inline void sprite_animate(vera_sprite_offset sprite_offset, Sprite* sprite, byte index, byte animate) {
    byte SpriteCount = sprite->SpriteCount;
    if(index >= SpriteCount) 
        index = index - SpriteCount;
    if(!animate) {
        vera_sprite_set_image_offset(sprite_offset, sprite->offset_image[index]);
    }
    // vera_sprite_buffer_set_image_offset((vera_sprite_buffer_item_t *)sprite_offset, sprite->offset_image[index]);
}

inline void sprite_position(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y) {
    // vera_sprite_buffer_xy((vera_sprite_buffer_item_t *)sprite_offset, x, y);
    vera_sprite_set_xy(sprite_offset, x, y);
}

inline void sprite_enable(vera_sprite_offset sprite_offset, Sprite* sprite) {
    // vera_sprite_buffer_zdepth((vera_sprite_buffer_item_t *)sprite_offset, sprite->Zdepth);
    vera_sprite_zdepth(sprite_offset, sprite->Zdepth);
}

void sprite_disable(vera_sprite_offset sprite_offset) {
    // vera_sprite_buffer_disable((vera_sprite_buffer_item_t *)sprite_offset);
    vera_sprite_disable(sprite_offset);
}


void sprite_collision(vera_sprite_offset sprite_offset, byte mask) {
    // vera_sprite_collision_mask(sprite_offset, mask);
    vera_sprite_set_collision_mask(sprite_offset, mask);
}


