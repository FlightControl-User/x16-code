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
#include "equinoxe-bank.h"

#include <vram_cache.h>

// Hash table to capture the cache of objects currently in vram and in use.
vram_cache_item_t vram_cache;


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
fe_vram_sprite_cache_t vram_sprite_cache;

#pragma data_seg(Data)
fe_t fe; // Flight engine control.



void fe_init(bram_bank_t bram_bank)
{
    fe.bram_bank = bram_bank;

    player_init();
    enemy_init();
    bullet_init();

    
    #ifdef __FLIGHT

    // Sprite Control
    fe.bram_sprite_control = BRAM_SPRITE_CONTROL;
    unsigned int bytes = load_file(1,8,0, "sprites.bin", BRAM_SPRITE_CONTROL, (bram_ptr_t) 0xA000);
    printf("sprite control loaded, %x bytes\n", bytes);

    bank_push_bram(); bank_set_bram(fe.bram_sprite_control);
    // Loading the sprites in bram.
    unsigned char i = 0;
    sprite_bram_t* sprite;
    while(sprite = sprite_DB[i]) {
        fe_sprite_bram_load(sprite);
        i++;
    }
    bank_pull_bram();

#endif

}


void fe_sprite_debug()
{

    char x = wherex();
    char y = wherey();

    printf("pool %2x", fe.sprite_pool);

    for(unsigned int c=0; c<FE_CACHE; c++) {
        gotoxy(0, (char)c+4);
        printf("%02x %04p %02x %s", c, fe_sprite.sprite_bram[c], fe_sprite.used[c], &fe_sprite.file[c*16]);
    }

    gotoxy(x,y);
}


vera_sprite_image_offset fe_sprite_vram_image_copy(fe_sprite_index_t fe_sprite_index,  unsigned char fe_sprite_image_index) {

    // check if the image in vram is in use where the fe_sprite_vram_image_index is pointing to.
    // if this vram_image_used is false, that means that the image in vram is not in use anymore (not displayed or destroyed).

    unsigned int image_index = fe_sprite_index*16+fe_sprite_image_index; 

    if(!fe_sprite.vram_image_used[fe_sprite_image_index]) {

        // in this case, we can allocate on the vram heap a new image with the required dimensions.
        // and we copy from bram the image to vram.

        fb_heap_handle_t handle_bram = fe_sprite.sprite_bram[fe_sprite_index]->bram_handle[fe_sprite_image_index];

        // Dynamic allocation of sprites in vera vram.
        vera_heap_handle_t vram_handle = vera_heap_alloc(VERA_HEAP_SEGMENT_SPRITES, (unsigned long)fe_sprite.size[fe_sprite_index]);
        vram_bank_t   vram_bank   = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, vram_handle);
        vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, vram_handle);

        fe_sprite.vram_handle[image_index] = vram_handle;

        // printf(", vram bank = %x, offset = %x", vram_bank, vram_offset);

        fe_sprite.vram_image_offset[image_index] = vera_sprite_get_image_offset(vram_bank, vram_offset);

        memcpy_vram_bram(vram_bank, vram_offset, handle_bram.bank, (bram_ptr_t)handle_bram.ptr, fe_sprite.size[fe_sprite_index]);

        fe_sprite.vram_image_used[image_index] = 1;

    }
}

// todo, need to detach vram allocation from cache management.
fe_sprite_index_t fe_sprite_cache_copy(sprite_bram_t* sprite_bram)
{

    bank_push_bram(); bank_set_bram(fe.bram_sprite_control);

    // printf("alloc cache %s", sprite_bram->file);

    unsigned int c = sprite_bram->sprite_cache;
    sprite_bram_t* cache_bram = (sprite_bram_t*)fe_sprite.sprite_bram[c];

    // printf(", %u", s);

    // If it is a new cache entry (never seen the sprite before)
    // or it is an existing cache entry but it is unused and the bram points to a different sprite,
    // Allocate, otherwise reuse the existing sprite.
    if(cache_bram != sprite_bram) {

        if(fe_sprite.used[c]) {
            while(fe_sprite.used[fe.sprite_pool]) {
                fe.sprite_pool = (fe.sprite_pool+1)%FE_CACHE;
            }
            c = fe.sprite_pool;
        }

        unsigned int co = c*FE_CACHE;

        // printf(", bram %p", s, fe_sprite.sprite_bram[s]);

        sprite_bram->sprite_cache = c;
        fe_sprite.sprite_bram[c] = sprite_bram;

        fe_sprite.count[c] = sprite_bram->count;
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
    	fe_sprite.aabb[co+1] = sprite_bram->aabb[1];
	    fe_sprite.aabb[co+2] = sprite_bram->aabb[2];
	    fe_sprite.aabb[co+3] = sprite_bram->aabb[3];

        for (unsigned int si=0; si < fe_sprite.count[c]; si++) {

            unsigned int coi = co+si;

            fb_heap_handle_t handle_bram = sprite_bram->bram_handle[si];

            // Only if the vram_handle is occupied, we clean the vram, otherwise we can just use the existing vram handle ...
            if(fe_sprite.vram_handle[coi])
                vera_heap_free(VERA_HEAP_SEGMENT_SPRITES, fe_sprite.vram_handle[coi]);

            // Dynamic allocation of sprites in vera vram.
            vera_heap_handle_t vram_handle = vera_heap_alloc(VERA_HEAP_SEGMENT_SPRITES, (unsigned long)fe_sprite.size[c]);
            vram_bank_t   vram_bank   = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, vram_handle);
            vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, vram_handle);

            fe_sprite.vram_handle[coi] = vram_handle;

            // printf(", vram bank = %x, offset = %x", vram_bank, vram_offset);

            fe_sprite.image[coi] = vera_sprite_get_image_offset(vram_bank, vram_offset);

            memcpy_vram_bram(vram_bank, vram_offset, handle_bram.bank, (bram_ptr_t)handle_bram.ptr, fe_sprite.size[c]);
        }

    }

    fe_sprite.used[c]++;
    // printf(", used %u. ", fe_sprite.used[s]);

    bank_pull_bram();

#ifdef __CACHE_DEBUG
    fe_sprite_debug();
#endif

    return c;
}


void fe_sprite_cache_free(fe_sprite_index_t fe_sprite_index)
{
    fe_sprite.used[fe_sprite_index]--;

#ifdef __CACHE_DEBUG
    fe_sprite_debug();
#endif
}




// Load the sprite into bram using the new cx16 heap manager.
void fe_sprite_bram_load(sprite_bram_t* sprite) 
{
    bank_push_bram(); bank_set_bram(fe.bram_sprite_control);
    
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
    bank_pull_bram();
}



void fe_sprite_configure(vera_sprite_offset sprite_offset, fe_sprite_index_t s) 
{
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


