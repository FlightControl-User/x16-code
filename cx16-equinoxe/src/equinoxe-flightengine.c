// Space flight engine for a space game written in kickc for the Commander X16.

#pragma link("equinoxe.ld")

#pragma encoding(petscii_mixed)

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
vera_sprite_offset sprite_offsets[127] = { 0 };


void fe_init(bram_bank_t bram_bank) {
    fe.bram_bank = bram_bank;

#ifdef __PLAYER
    player_init();
#endif

#ifdef __ENEMY
    enemy_init();
#endif

#ifdef __BULLET
    bullet_init();
#endif

#ifdef __FLIGHT

    // Sprite Control
    fe.bram_sprite_control = BRAM_SPRITE_CONTROL;
    unsigned int bytes = load_file(1, 8, 0, "sprites.bin", BRAM_SPRITE_CONTROL, (bram_ptr_t)0xA000);

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

vera_sprite_offset NextOffset(vera_sprite_id sprite_start, vera_sprite_id sprite_end, vera_sprite_id* sprite_id, unsigned char* count)
{
	while(sprite_offsets[*sprite_id]) {
		*sprite_id = ((*sprite_id) >= sprite_end)?sprite_start:(*sprite_id)+1;
	}

	(*count)++;
	vera_sprite_offset sprite_offset = vera_sprite_get_offset(*sprite_id); 
	sprite_offsets[*sprite_id] = sprite_offset;
	return sprite_offset;
}


void FreeOffset(vera_sprite_offset sprite_offset, unsigned char* count)
{
	vera_sprite_id sprite_id = vera_sprite_get_id(sprite_offset);
	sprite_offsets[sprite_id] = 0;
	(*count)--;
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

    unsigned int c = sprite_bram->sprite_cache;
    sprite_bram_t* cache_bram = (sprite_bram_t*)fe_sprite.sprite_bram[c];

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

    }

    fe_sprite.used[c]++;
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

    printf("loading sprites %s, ", sprite->file);
    printf("spritecount=%x, spritesize=%x, ", sprite->count, sprite->SpriteSize);

    unsigned int status = open_file(1, 8, 0, sprite->file);
    if (status) printf("error opening file %s\n", sprite->file);

    unsigned int total_loaded = 0;

    sprite->offset = sprite_offset;
    for (unsigned char s = 0; s < sprite->count; s++) {
        // printf("allocating");
        fb_heap_handle_t handle_bram = heap_alloc(bins, sprite->SpriteSize);
        unsigned char status = load_file_bram(1, 8, 0, handle_bram.bank, handle_bram.ptr, sprite->SpriteSize);
        if (status) {
            break;
        }
        sprite_bram_handles[sprite_offset] = handle_bram;
        total_loaded += sprite->SpriteSize;
        sprite_offset++;
    }

    status = close_file(1, 8, 0);
    if (status) printf("error closing file %s\n", sprite->file);

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

