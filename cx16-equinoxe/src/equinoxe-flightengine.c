// Space flight engine for a space game written in kickc for the Commander X16.

#pragma link("equinoxe.ld")

#pragma encoding(petscii_mixed)

#pragma var_model(mem)


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
#include <cx16-veraheap.h>

#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-palette.h"
#include "equinoxe-stage.h"
#include "equinoxe-flightengine.h"

#include <ht.h>

#pragma data_seg(SpriteControlEnemies)
fe_enemy_t enemy;

#pragma data_seg(SpriteControlPlayer)
fe_player_t player;

#pragma data_seg(SpriteControlEngine)
fe_engine_t engine;

#pragma data_seg(SpriteControlBullets)
fe_bullet_t bullet;

#pragma data_seg(Data)
fe_t fe; // Flight engine control.



void fe_init(bram_bank_t bram_bank)
{
    fe.bram_bank = bram_bank;

    player_init();
    enemy_init();
    bullet_init();
}

void sprite_vram_allocate(sprite_t* sprite, vera_heap_segment_index_t segment)
{

    // printf("sprite alloc = %s", sprite->file);

    if(!sprite->used) {

        unsigned char sprite_count = sprite->count;
        unsigned int sprite_size = sprite->SpriteSize;

        for (unsigned char sprite_index=0; sprite_index < sprite_count; sprite_index++) {

            fb_heap_handle_t handle_bram = sprite->bram_handle[sprite_index];


            // Dynamic allocation of sprites in vera vram.
            sprite->vera_heap_index[sprite_index] = vera_heap_alloc(segment, sprite_size);
            vram_bank_t   vram_bank   = vera_heap_data_get_bank(segment, sprite->vera_heap_index[sprite_index]);
            vram_offset_t vram_offset = vera_heap_data_get_offset(segment, sprite->vera_heap_index[sprite_index]);
            // printf(", bank = %x, offset = %x", vram_bank, vram_offset);

            sprite->vram_image_offset[sprite_index] = vera_sprite_get_image_offset(vram_bank, vram_offset);

            // printf(", image offset=%x", sprite->vram_image_offset[sprite_index]);

            // vera_heap_dump(VERA_HEAP_SEGMENT_SPRITES, 0, 20);

            memcpy_vram_bram(vram_bank, vram_offset, handle_bram.bank, (bram_ptr_t)handle_bram.ptr, sprite_size);
        }
    }
    sprite->used++;
    // printf(", used=%x. ", sprite->used);
}


void sprite_vram_free(sprite_t* sprite, vera_heap_segment_index_t segment)
{

    sprite->used--;

    // printf("sprite free=%s", sprite->file);
    
    if(!sprite->used) {
        unsigned char sprite_count = sprite->count;
        unsigned int sprite_size = sprite->SpriteSize;

        // printf("sprite free=%s, used=%x          ", sprite->file, sprite->used);

        for (unsigned char sprite_index=0; sprite_index < sprite_count; sprite_index++) {

            fb_heap_handle_t handle_bram = sprite->bram_handle[sprite_index];
            vera_heap_free(segment, sprite->vera_heap_index[sprite_index]);
            sprite->vera_heap_index[sprite_index] = 0;
        }
    }
    // printf(", used=%x. ", sprite->used);
}



// Load the sprite into bram using the new cx16 heap manager.
void sprite_load(sprite_t* sprite) 
{

    printf("loading sprites %s\n", sprite->file);
    printf("spritecount=%x, spritesize=%x", sprite->count, sprite->SpriteSize);
    // printf(", opening\n");


    unsigned int status = open_file(1, 8, 0, sprite->file);
    if (status) printf("error opening file %s\n", sprite->file);

    // printf("spritecount = %u\n", sprite->count);

    unsigned int total_loaded = 0;

    for(unsigned char s=0; s<sprite->count; s++) {
        // printf("allocating");
        fb_heap_handle_t handle_bram = heap_alloc(bins, sprite->SpriteSize);
        printf(" %1x%04p", handle_bram.bank, handle_bram.ptr);
        unsigned int bytes_loaded = load_file_bram(1, 8, 0, handle_bram.bank, handle_bram.ptr, sprite->SpriteSize);
        if (!bytes_loaded) {
            printf("error loading file %s\n", sprite->file);
            break;
        }
        sprite->bram_handle[s] = handle_bram; // TODO: rework this to map into banked memory.
        total_loaded += bytes_loaded;
    }
    printf(", %x bytes loaded", total_loaded);

    status = close_file(1, 8, 0);
    if (status) printf("error closing file %s\n", sprite->file);

    printf(", done\n");
}



void sprite_configure(vera_sprite_offset sprite_offset, sprite_t* sprite) {
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
}

void sprite_palette(vera_sprite_offset sprite_offset, unsigned char bram_index)
{
    vera_sprite_palette_offset(sprite_offset, palette16_use(bram_index));
}

// inline void sprite_animate(vera_sprite_offset sprite_offset, sprite_t* sprite, byte index, byte animate) {
//     byte count = sprite->count;
//     if(index >= count) 
//         index = index - count;
//     if(!animate) {
//         vera_sprite_set_image_offset(sprite_offset, sprite->offset_image[index]);
//     }
//     // vera_sprite_buffer_set_image_offset((vera_sprite_buffer_item_t *)sprite_offset, sprite->offset_image[index]);
// }

inline void sprite_position(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y) {
    // vera_sprite_buffer_xy((vera_sprite_buffer_item_t *)sprite_offset, x, y);
    vera_sprite_set_xy(sprite_offset, x, y);
}

inline void sprite_enable(vera_sprite_offset sprite_offset, sprite_t* sprite) {
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


