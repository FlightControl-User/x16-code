
#include "equinoxe.h"
#include "equinoxe-bank.h"
#include "equinoxe-levels.h"
#include "equinoxe-palette.h"
#include "equinoxe-stage.h"
#include "equinoxe-types.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-animate.h"
#include <cx16-file.h>
#include <cx16-veraheap.h>

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

#pragma data_seg(sprite_animate_control)
sprite_animate_t animate;


#pragma data_seg(fe_sprite_cache)
// Cache to manage sprite control data fast, unbanked as making this banked will make things very, very complicated.
fe_sprite_cache_t sprite_cache;

#pragma data_seg(Data)
fe_t fe;  // Flight engine control.
vera_sprite_offset sprite_offsets[127] = { 0 };

// #pragma var_model(zp)

void fe_init()
{}

vera_sprite_offset sprite_next_offset()
{
    while (sprite_offsets[stage.sprite_cache_pool]) {
        stage.sprite_cache_pool = (stage.sprite_cache_pool >= 127) ? 1 : stage.sprite_cache_pool + 1;
    }

    stage.sprite_count++;
    vera_sprite_offset sprite_offset = vera_sprite_get_offset(stage.sprite_cache_pool);
    sprite_offsets[stage.sprite_cache_pool] = sprite_offset;
    return sprite_offset;
}


void sprite_free_offset(vera_sprite_offset sprite_offset)
{
    vera_sprite_id sprite_id = vera_sprite_get_id(sprite_offset);
    sprite_offsets[sprite_id] = 0;
    stage.sprite_count--;
}


void fe_sprite_debug()
{
    char x = wherex();
    char y = wherey();

#ifdef __INCLUDE_PRINT
    printf("pool %2x", fe.sprite_cache_pool);
#endif

    for (unsigned int c = 0; c < FE_CACHE; c++) {
        gotoxy(0, (char)c + 4);
#ifdef __INCLUDE_PRINT
        printf("%02x %04p %02x %16s %4u %4u", c, sprite_cache.sprite_bram[c], sprite_cache.used[c], &sprite_cache.file[c * 16], sprite_cache.offset[c], sprite_cache.size[c]);
#endif
    }

    gotoxy(x, y);
}

vera_sprite_image_offset sprite_image_cache_vram(fe_sprite_index_t fe_sprite_index, unsigned char fe_sprite_image_index)
{
    // check if the image in vram is in use where the fe_sprite_vram_image_index is pointing to.
    // if this vram_image_used is false, that means that the image in vram is not in use anymore (not displayed or destroyed).

    unsigned int image_index = sprite_cache.offset[fe_sprite_index] + fe_sprite_image_index;

    // We retrieve the image from BRAM from the sprite_control bank.
    // TODO: what if there are more sprite control data than that can fit into one CX16 bank?
    bank_push_set_bram(BRAM_SPRITE_CONTROL);
    heap_bram_fb_handle_t handle_bram = sprite_bram_handles[image_index];
    bank_pull_bram();

    // We declare temporary variables for the vram memory handles.
    // lru_cache_data_t vram_handle;
    // vram_bank_t vram_bank;
    // vram_offset_t vram_offset;

    // We check if there is a cache hit?
    lru_cache_index_t vram_index = lru_cache_index(&sprite_cache_vram, image_index);
    // lru_cache_data_t lru_cache_data;
    vera_sprite_image_offset sprite_offset;
    if (vram_index != 0xFF) {

        // So we have a cache hit, so we can re-use the same image from the cache and we win time!
        lru_cache_data_t vram_handle = lru_cache_get(&sprite_cache_vram, vram_index);

        // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
        // Dynamic allocation of sprites in vera vram.
        vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, vram_handle);
        vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, vram_handle);

        sprite_offset = vera_sprite_get_image_offset(vram_bank, vram_offset);
    } else {

#ifdef __CPULINES
        vera_display_set_border_color(RED);
#endif

        // The idea of this section is to free up lru_cache and/or vram memory until there is sufficient space available.
        // The size requested contains the required size to be allocated on vram.
        vera_heap_size_int_t vram_size_required = sprite_cache.size[fe_sprite_index];

        // We check if the vram heap has sufficient memory available for the size requested.
        // We also check if the lru cache has sufficient elements left to contain the new sprite image.
        bool vram_has_free = vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required);
        bool lru_cache_max = lru_cache_is_max(&sprite_cache_vram);

        printf("vram_has_free = %u, lru_cache_max = %u", (char)vram_has_free, (char)lru_cache_max);
        while(!getin());

        // Free up the lru_cache and vram memory until the requested size is available!
        // This ensures that vram has sufficient place to allocate the new sprite image. 
        while (lru_cache_max || !vram_has_free) {

            // If the cache is at it's maximum, before we can add a new element, we must remove the least used image.
            // We search for the least used image in vram.
            lru_cache_key_t vram_last = lru_cache_find_last(&sprite_cache_vram);

            // We delete the least used image from the vram cache, and this function returns the stored vram handle obtained by the vram heap manager.
            lru_cache_data_t vram_handle = lru_cache_delete(&sprite_cache_vram, vram_last);
            if (vram_handle == 0xFFFF) {
#ifdef __INCLUDE_PRINT
                gotoxy(0, 59);
                printf("error! vram_handle is nothing!");
#endif
            }

            // And we free the vram heap with the vram handle that we received.
            // But before we can free the heap, we must first convert back from teh sprite offset to the vram address.
            // And then to a valid vram handle :-).
            vera_heap_free(VERA_HEAP_SEGMENT_SPRITES, vram_handle);
            vram_has_free = vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required);
            lru_cache_max = lru_cache_is_max(&sprite_cache_vram);
        }

        // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
        // Dynamic allocation of sprites in vera vram.
        lru_cache_data_t vram_handle = vera_heap_alloc(VERA_HEAP_SEGMENT_SPRITES, (unsigned long)sprite_cache.size[fe_sprite_index]);
        vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, vram_handle);
        vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, vram_handle);

        memcpy_vram_bram(vram_bank, vram_offset, heap_bram_fb_bank_get(handle_bram), (bram_ptr_t)heap_bram_fb_ptr_get(handle_bram), sprite_cache.size[fe_sprite_index]);

        sprite_offset = vera_sprite_get_image_offset(vram_bank, vram_offset);
        lru_cache_insert(&sprite_cache_vram, image_index, vram_handle);

#ifdef __CPULINES
        vera_display_set_border_color(BLACK);
#endif
    }

    // We return the image offset in vram of the sprite to be drawn.
    // This offset is used by the vera image set offset function to directly change the image displayed of the sprite!
    return sprite_offset;
}

// todo, need to detach vram allocation from cache management.
fe_sprite_index_t fe_sprite_cache_copy(sprite_bram_t* sprite_bram)
{

    bank_push_set_bram(BRAM_SPRITE_CONTROL);

    unsigned int c = sprite_bram->sprite_cache;
    sprite_bram_t* cache_bram = (sprite_bram_t*)sprite_cache.sprite_bram[c];

    // If it is a new cache entry (never seen the sprite before)
    // or it is an existing cache entry but it is unused and the bram points to a different sprite,
    // Allocate, otherwise reuse the existing sprite.
    if (cache_bram != sprite_bram) {
        if (sprite_cache.used[c]) {
            while (sprite_cache.used[fe.sprite_cache_pool]) {
                fe.sprite_cache_pool = (fe.sprite_cache_pool + 1) % FE_CACHE;
            }
            c = fe.sprite_cache_pool;
        }

        unsigned int co = c * FE_CACHE;

        sprite_bram->sprite_cache = c;
        sprite_cache.sprite_bram[c] = sprite_bram;

        sprite_cache.count[c] = sprite_bram->count;
        sprite_cache.offset[c] = sprite_bram->offset;
        sprite_cache.size[c] = sprite_bram->SpriteSize;
        sprite_cache.zdepth[c] = sprite_bram->Zdepth;
        sprite_cache.bpp[c] = sprite_bram->BPP;
        sprite_cache.height[c] = sprite_bram->Height;
        sprite_cache.width[c] = sprite_bram->Width;
        sprite_cache.hflip[c] = sprite_bram->Hflip;
        sprite_cache.vflip[c] = sprite_bram->Vflip;
        sprite_cache.reverse[c] = sprite_bram->reverse;
        sprite_cache.palette_offset[c] = sprite_bram->PaletteOffset;
        sprite_cache.loop[c] = sprite_bram->loop;
        memcpy(&sprite_cache.file[co], sprite_bram->file, 16);

        sprite_cache.aabb[co] = sprite_bram->aabb[0];
        sprite_cache.aabb[co + 1] = sprite_bram->aabb[1];
        sprite_cache.aabb[co + 2] = sprite_bram->aabb[2];
        sprite_cache.aabb[co + 3] = sprite_bram->aabb[3];

    }

    sprite_cache.used[c]++;
    bank_pull_bram();
    return c;
}

void fe_sprite_cache_free(fe_sprite_index_t fe_sprite_index)
{
    sprite_cache.used[fe_sprite_index]--;

#ifdef __DEBUG_SPRITE_CACHE
    fe_sprite_debug();
#endif
}

void sprite_map_header(sprite_file_header_t* sprite_file_header, sprite_bram_t* sprite)
{
    sprite->count = sprite_file_header->count;
    sprite->SpriteSize = sprite_file_header->size;
    sprite->Width = vera_sprite_width_get_bitmap(sprite_file_header->width);
    sprite->Height = vera_sprite_height_get_bitmap(sprite_file_header->height);
    sprite->Zdepth = vera_sprite_zdepth_get_bitmap(sprite_file_header->zdepth);
    sprite->Hflip = vera_sprite_hflip_get_bitmap(sprite_file_header->hflip);
    sprite->Vflip = vera_sprite_vflip_get_bitmap(sprite_file_header->vflip);
    sprite->BPP = vera_sprite_bpp_get_bitmap(sprite_file_header->bpp);
    sprite->reverse = sprite_file_header->reverse;
    sprite->aabb[0] = sprite_file_header->collision;
    sprite->aabb[1] = sprite_file_header->collision;
    sprite->aabb[2] = sprite_file_header->width - sprite_file_header->collision;
    sprite->aabb[3] = sprite_file_header->height - sprite_file_header->collision;
    sprite->PaletteOffset = sprite_file_header->palette_offset;
    sprite->loop = sprite_file_header->loop;
    sprite->sprite_cache = 0;
}

// Load the sprite into bram using the new cx16 heap manager.
unsigned int fe_sprite_bram_load(sprite_bram_t* sprite, unsigned int sprite_offset)
{

    bank_push_set_bram(BRAM_SPRITE_CONTROL);


    if (!sprite->loaded) {

        char filename[16];
        strcpy(filename, sprite->file);
        strcat(filename, ".bin");

#ifdef __DEBUG_LOAD
        printf("\n%10s : ", filename);
#endif

        FILE* fp = fopen(1, 8, 2, filename);
        if (!fp) {
#ifdef __INCLUDE_PRINT
            if (status) printf("error opening file %s\n", filename);
#endif
        } else {
            sprite_file_header_t sprite_file_header;

            // Read the header of the file into the sprite_file_header structure.
            unsigned int read = fgets((char*)&sprite_file_header, 16, fp);

            if (!read) {
#ifdef __INCLUDE_PRINT
                if (end) {
                    printf("error loading file %s, status = %u\n", filename, status);
                }
#endif

            } else {

                sprite_map_header(&sprite_file_header, sprite);

#ifdef __DEBUG_LOAD
                printf("%2x %4x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x: ",
                    sprite->count, sprite->SpriteSize, sprite->Width, sprite->Height, sprite->BPP, sprite->Hflip, sprite->Vflip,
                    sprite->aabb[0], sprite->aabb[1], sprite->aabb[2], sprite->aabb[3], sprite->loop, sprite->reverse);
#endif

                unsigned int sprite_size = sprite->SpriteSize;

                unsigned int total_loaded = 0;

                // Set palette offset of sprites
                sprite->PaletteOffset = sprite->PaletteOffset + stage.palette;

                sprite->offset = sprite_offset;
                for (unsigned char s = 0; s < sprite->count; s++) {
                    heap_bram_fb_handle_t handle_bram = heap_alloc(heap_bram_blocked, sprite_size);
#ifdef __DEBUG_LOAD
                    cputc('.');
#endif
                    bank_push_set_bram(heap_bram_fb_bank_get(handle_bram));
                    unsigned int read = fgets(heap_bram_fb_ptr_get(handle_bram), sprite_size, fp);
                    bank_pull_bram();
                    if (!read) {
#ifdef __INCLUDE_PRINT
                        if (!read) {
                            printf("error loading file %s, status = %u\n", filename, status);
                            break;
                        }
#endif
                    } else {
                        sprite_bram_handles[sprite_offset] = handle_bram;
                        total_loaded += sprite->SpriteSize;
                        sprite_offset++;
                    }
                }
                if (fclose(fp)) {
#ifdef __INCLUDE_PRINT
                    if (status) printf("error closing file %s\n", sprite->file);
#endif
                } else {
                    sprite->loaded = 1;
                }
            }
        }
    }

    bank_pull_bram();
    return sprite_offset;
}

void fe_sprite_configure(vera_sprite_offset sprite_offset, fe_sprite_index_t s)
{
    vera_sprite_bpp(sprite_offset, sprite_cache.bpp[s]);
    vera_sprite_height(sprite_offset, sprite_cache.height[s]);
    vera_sprite_width(sprite_offset, sprite_cache.width[s]);
    vera_sprite_hflip(sprite_offset, sprite_cache.hflip[s]);
    vera_sprite_vflip(sprite_offset, sprite_cache.vflip[s]);
    vera_sprite_palette_offset(sprite_offset, palette16_use(sprite_cache.palette_offset[s]));
}

// #pragma var_model(mem)
