// Space flight engine for a space game written in kickc for the Commander X16.

#pragma link("equinoxe.ld")

#pragma encoding(petscii_mixed)

#pragma var_model(mem)

#include "equinoxe-flightengine.h"

#include <6502.h>
#include <conio.h>
#include <cx16-bitmap.h>
#include <cx16-conio.h>
#include <cx16-fb.h>
#include <cx16-mouse.h>
#include <cx16-veraheap.h>
#include <cx16-veralib.h>
#include <cx16.h>
#include <division.h>
#include <kernal.h>
#include <lru-cache.h>
#include <mos6522.h>
#include <multiply.h>
#include <printf.h>
#include <stdio.h>
#include <stdlib.h>

#include "equinoxe-bank.h"
// #include "levels/equinoxe-levels.h"
#include "equinoxe-palette.h"
#include "equinoxe-stage.h"
#include "equinoxe-types.h"
#include "equinoxe.h"

// Allocate the hash table to capture the cache of objects currently in vram and in use in main memory.
// This is an array of 512 bytes.
#pragma data_seg(Data)
lru_cache_table_t sprite_cache_vram;

#pragma data_seg(SpriteControlEnemies)
fe_enemy_t enemy;

#pragma data_seg(SpriteControlPlayer)
fe_player_t player;

#pragma data_seg(SpriteControlEngine)
fe_engine_t engine;

#pragma data_seg(SpriteControlBullets)
fe_bullet_t bullet;

#pragma data_seg(fe_sprite_cache)
// Cache to manage sprite control data fast, unbanked as making this banked will make things very, very complicated.
fe_sprite_cache_t fe_sprite;

#pragma data_seg(Data)
fe_t fe;  // Flight engine control.

void fe_init(bram_bank_t bram_bank) {
    fe.bram_bank = bram_bank;

    player_init();
    enemy_init();
    bullet_init();

#ifdef __FLIGHT

    // Sprite Control
    fe.bram_sprite_control = BRAM_SPRITE_CONTROL;
    unsigned int bytes = load_file(1, 8, 0, "sprites.bin", BRAM_SPRITE_CONTROL, (bram_ptr_t)0xA000);
    printf("sprite control loaded, %x bytes\n", bytes);

    bank_push_set_bram(fe.bram_sprite_control);

    // Loading the sprites in bram.
    unsigned char i = 0;
    sprite_bram_t* sprite;
    unsigned int sprite_offset = 0;
    while (sprite = sprite_DB[i]) {
        sprite_offset = fe_sprite_bram_load(sprite, sprite_offset);
        i++;
    }

    bank_pull_bram();

    // Initialize the cache in vram for the sprite animations.
    lru_cache_init(&sprite_cache_vram);
#endif
}

void fe_sprite_debug() {
    char x = wherex();
    char y = wherey();

    printf("pool %2x", fe.sprite_pool);

    for (unsigned int c = 0; c < FE_CACHE; c++) {
        gotoxy(0, (char)c + 4);
        printf("%02x %04p %02x %16s %4u %4u", c, fe_sprite.sprite_bram[c], fe_sprite.used[c], &fe_sprite.file[c * 16], fe_sprite.offset[c], fe_sprite.size[c]);
    }

    gotoxy(x, y);
}

vera_sprite_image_offset sprite_image_cache_vram(fe_sprite_index_t fe_sprite_index, unsigned char fe_sprite_image_index) {
    // check if the image in vram is in use where the fe_sprite_vram_image_index is pointing to.
    // if this vram_image_used is false, that means that the image in vram is not in use anymore (not displayed or destroyed).


    unsigned int image_index = fe_sprite.offset[fe_sprite_index] + fe_sprite_image_index;

    // We retrieve the image from BRAM from the sprite_control bank.
    // TODO: what if there are more sprite control data than that can fit into one CX16 bank?
    bank_push_set_bram(fe.bram_sprite_control);
    fb_heap_handle_t handle_bram = sprite_bram_handles[image_index];
    bank_pull_bram();

    // We declare temporary variables for the vram memory handles.
    lru_cache_data_t vram_handle;
    vram_bank_t vram_bank;
    vram_offset_t vram_offset;

    // We check if there is a cache hit?
    lru_cache_index_t vram_index = lru_cache_index(&sprite_cache_vram, image_index);
    lru_cache_data_t lru_cache_data;
    vera_sprite_image_offset sprite_offset;
    if (vram_index != 0xFF) {

        // So we have a cache hit, so we can re-use the same image from the cache and we win time!
        vram_handle = lru_cache_get(&sprite_cache_vram, vram_index);

        // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
        // Dynamic allocation of sprites in vera vram.
        vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, vram_handle);
        vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, vram_handle);

        sprite_offset = vera_sprite_get_image_offset(vram_bank, vram_offset);
    } else {

        // We check if the vram cache is at it's maximum, and if it is, we must delete the least used image.
        if (lru_cache_max(&sprite_cache_vram)) {
            // If the cache is at it's maximum, before we can add a new element, we must remove the least used image.
            // We search for the least used image in vram.
            lru_cache_key_t vram_last = lru_cache_last(&sprite_cache_vram);
            // We delete the least used image from the vram cache, and this function returns the stored vram handle obtained by the vram heap manager.
            vram_handle = lru_cache_delete(&sprite_cache_vram, vram_last);
            if(vram_handle==0xFF) {
                gotoxy(0,59);
                printf("error! vram_handle is nothing!");
            }
            // And we free the vram heap with the vram handle that we received.
            // But before we can free the heap, we must first convert back from teh sprite offset to the vram address.
            // And then to a valid vram handle :-).
            vera_heap_free(VERA_HEAP_SEGMENT_SPRITES, vram_handle);
        }

        // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
        // Dynamic allocation of sprites in vera vram.
        vram_handle = vera_heap_alloc(VERA_HEAP_SEGMENT_SPRITES, (unsigned long)fe_sprite.size[fe_sprite_index]);
        vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, vram_handle);
        vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, vram_handle);

        memcpy_vram_bram(vram_bank, vram_offset, handle_bram.bank, (bram_ptr_t)handle_bram.ptr, fe_sprite.size[fe_sprite_index]);

        sprite_offset = vera_sprite_get_image_offset(vram_bank, vram_offset);
        lru_cache_insert(&sprite_cache_vram, image_index, vram_handle);
    }

    // We return the image offset in vram of the sprite to be drawn.
    // This offset is used by the vera image set offset function to directly change the image displayed of the sprite!
    return sprite_offset;
}

// todo, need to detach vram allocation from cache management.
fe_sprite_index_t fe_sprite_cache_copy(sprite_bram_t* sprite_bram) {
    bank_push_set_bram(fe.bram_sprite_control);


    // printf("alloc cache %s", sprite_bram->file);

    unsigned int c = sprite_bram->sprite_cache;
    sprite_bram_t* cache_bram = (sprite_bram_t*)fe_sprite.sprite_bram[c];

    // printf(", %u", s);

    // If it is a new cache entry (never seen the sprite before)
    // or it is an existing cache entry but it is unused and the bram points to a different sprite,
    // Allocate, otherwise reuse the existing sprite.
    if (cache_bram != sprite_bram) {
        if (fe_sprite.used[c]) {
            while (fe_sprite.used[fe.sprite_pool]) {
                fe.sprite_pool = (fe.sprite_pool + 1) % FE_CACHE;
            }
            c = fe.sprite_pool;
        }

        unsigned int co = c * FE_CACHE;

        // printf(", bram %p", s, fe_sprite.sprite_bram[s]);

        sprite_bram->sprite_cache = c;
        fe_sprite.sprite_bram[c] = sprite_bram;

        fe_sprite.count[c] = sprite_bram->count;
        fe_sprite.offset[c] = sprite_bram->offset;
        fe_sprite.size[c] = sprite_bram->SpriteSize;
        fe_sprite.zdepth[c] = sprite_bram->Zdepth;
        fe_sprite.bpp[c] = sprite_bram->BPP;
        fe_sprite.height[c] = sprite_bram->Height;
        fe_sprite.width[c] = sprite_bram->Width;
        fe_sprite.hflip[c] = sprite_bram->Hflip;
        fe_sprite.vflip[c] = sprite_bram->Vflip;
        fe_sprite.reverse[c] = sprite_bram->reverse;
        fe_sprite.palette_offset[c] = sprite_bram->PaletteOffset;
        memcpy(&fe_sprite.file[co], sprite_bram->file, 16);

        fe_sprite.aabb[co] = sprite_bram->aabb[0];
        fe_sprite.aabb[co + 1] = sprite_bram->aabb[1];
        fe_sprite.aabb[co + 2] = sprite_bram->aabb[2];
        fe_sprite.aabb[co + 3] = sprite_bram->aabb[3];


        // for (unsigned int si=0; si < fe_sprite.count[c]; si++) {

        //     unsigned int coi = co+si;

        //     fb_heap_handle_t handle_bram = sprite_bram->bram_handle[si];

        //     // Only if the vram_handle is occupied, we clean the vram, otherwise we can just use the existing vram handle ...
        //     if(fe_sprite.vram_handle[coi])
        //         vera_heap_free(VERA_HEAP_SEGMENT_SPRITES, fe_sprite.vram_handle[coi]);

        //     // Dynamic allocation of sprites in vera vram.
        //     vera_heap_handle_t vram_handle = vera_heap_alloc(VERA_HEAP_SEGMENT_SPRITES, (unsigned long)fe_sprite.size[c]);
        //     vram_bank_t   vram_bank   = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, vram_handle);
        //     vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, vram_handle);

        //     fe_sprite.vram_handle[coi] = vram_handle;

        //     // printf(", vram bank = %x, offset = %x", vram_bank, vram_offset);

        //     fe_sprite.image[coi] = vera_sprite_get_image_offset(vram_bank, vram_offset);

        //     memcpy_vram_bram(vram_bank, vram_offset, handle_bram.bank, (bram_ptr_t)handle_bram.ptr, fe_sprite.size[c]);
        // }
    }

    fe_sprite.used[c]++;
    // printf(", used %u. ", fe_sprite.used[s]);

    bank_pull_bram();


    return c;
}

void fe_sprite_cache_free(fe_sprite_index_t fe_sprite_index) {
    fe_sprite.used[fe_sprite_index]--;

#ifdef __CACHE_DEBUG
    fe_sprite_debug();
#endif
}

// Load the sprite into bram using the new cx16 heap manager.
unsigned int fe_sprite_bram_load(sprite_bram_t* sprite, unsigned int sprite_offset) {
    bank_push_set_bram(fe.bram_sprite_control);

    printf("loading sprites %s\n", sprite->file);
    printf("spritecount=%x, spritesize=%x", sprite->count, sprite->SpriteSize);
    // printf(", opening\n");

    unsigned int status = open_file(1, 8, 0, sprite->file);
    if (status) printf("error opening file %s\n", sprite->file);

    // printf("spritecount = %u\n", sprite->count);

    unsigned int total_loaded = 0;

    sprite->offset = sprite_offset;
    printf(", spriteoffset=%x", sprite->offset);
    for (unsigned char s = 0; s < sprite->count; s++) {
        // printf("allocating");
        fb_heap_handle_t handle_bram = heap_alloc(bins, sprite->SpriteSize);
        printf(" %1x%04p", handle_bram.bank, handle_bram.ptr);
        unsigned int bytes_loaded = load_file_bram(1, 8, 0, handle_bram.bank, handle_bram.ptr, sprite->SpriteSize);
        if (!bytes_loaded) {
            printf("error loading file %s\n", sprite->file);
            break;
        }
        sprite_bram_handles[sprite_offset] = handle_bram;
        total_loaded += bytes_loaded;
        sprite_offset++;
    }
    printf(", %x bytes loaded", total_loaded);

    status = close_file(1, 8, 0);
    if (status) printf("error closing file %s\n", sprite->file);

    printf(", done\n");
    bank_pull_bram();

    return sprite_offset;
}

void fe_sprite_configure(vera_sprite_offset sprite_offset, fe_sprite_index_t s) {
    vera_sprite_bpp(sprite_offset, fe_sprite.bpp[s]);
    vera_sprite_height(sprite_offset, fe_sprite.height[s]);
    vera_sprite_width(sprite_offset, fe_sprite.width[s]);
    vera_sprite_hflip(sprite_offset, fe_sprite.hflip[s]);
    vera_sprite_vflip(sprite_offset, fe_sprite.vflip[s]);
    vera_sprite_palette_offset(sprite_offset, palette16_use(fe_sprite.palette_offset[s]));
}

inline void sprite_position(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y) {
    // vera_sprite_buffer_xy((vera_sprite_buffer_item_t *)sprite_offset, x, y);
    vera_sprite_set_xy(sprite_offset, x, y);
}

inline void sprite_enable(vera_sprite_offset sprite_offset, sprite_bram_t* sprite) {
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
