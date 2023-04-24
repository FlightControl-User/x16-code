
#include "equinoxe.h"
#include "equinoxe-bank.h"
#include "equinoxe-levels.h"
#include "equinoxe-palette-lib.h"
#include "equinoxe-stage.h"
#include "equinoxe-types.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-animate-lib.h"
#include <cx16-file.h>
#include <cx16-veraheap-lib.h>
#include <cx16-bramheap-lib.h>




#pragma data_seg(DATA_SPRITE_CACHE)
// Cache to manage sprite control data fast, unbanked as making this banked will make things very, very complicated.
fe_sprite_cache_t sprite_cache;

#pragma data_seg(DATA_ENGINE_FLIGHT)
flight_t flight;

fe_t fe;  // Flight engine control.
vera_sprite_offset sprite_offsets[127] = { 0 };

#pragma data_seg(CODE_ENGINE_FLIGHT)

// #pragma var_model(zp)

flight_index_t flight_add(flight_type_t type) {

    unsigned char f = flight.index;
    while (flight.used[f]) {
        f = (f + 1) % 128;
    }
    flight.index = f;

    flight.type = type;
    
    flight.used[f] = 1;
    flight.enabled[f] = 0;


    return f;
}

void flight_remove(flight_index_t f) {

    if (flight.used[f]) {
        vera_sprite_offset sprite_offset = flight.sprite_offset[f];
        sprite_free_offset(sprite_offset);
        vera_sprite_disable(sprite_offset);
        palette_unuse_vram(sprite_cache.palette_offset[flight.sprite[f]]);
        fe_sprite_cache_free(flight.sprite[f]);
        flight.used[p] = 0;
        flight.enabled[p] = 0;
        flight.collided[p] = 1;
    }
}

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

    printf("pool %2x", fe.sprite_cache_pool);
    gotoxy(0, 3);
    printf("ca bram used file           offs size wi he");

    for (unsigned int c = 0; c < FE_CACHE; c++) {
        gotoxy(0, (char)c + 4);
        printf("%02x %04p %02x %16s %4u %4u %02x %02x", c, sprite_cache.sprite_bram[c], sprite_cache.used[c], 
        &sprite_cache.file[c * 16], sprite_cache.offset[c], sprite_cache.size[c], sprite_cache.width[c], sprite_cache.height[c]
        );
    }

    gotoxy(x, y);
}

vera_sprite_image_offset sprite_image_cache_vram(fe_sprite_index_t fe_sprite_index, unsigned char fe_sprite_image_index)
{
    // check if the image in vram is in use where the fe_sprite_vram_image_index is pointing to.
    // if this vram_image_used is false, that means that the image in vram is not in use anymore (not displayed or destroyed).

    unsigned int image_index = sprite_cache.offset[fe_sprite_index] + fe_sprite_image_index;

    // We declare temporary variables for the vram memory handles.
    // lru_cache_data_t vram_handle;
    // vram_bank_t vram_bank;
    // vram_offset_t vram_offset;

    char x = (image_index / 32)*20;
    char y = (char)10+(char)(image_index % 32);

#ifdef __DEBUG_LRU_CACHE
    gotoxy(x,y);
    printf("%03u           ", image_index);
    gotoxy(x+4,y);
#endif

    // We check if there is a cache hit?
    lru_cache_index_t vram_index = lru_cache_index(image_index);
    // lru_cache_data_t lru_cache_data;
    vera_sprite_image_offset sprite_offset;
    if (vram_index != 0xFF) {

#ifdef __DEBUG_LRU_CACHE
        printf("h ");
#endif

        // So we have a cache hit, so we can re-use the same image from the cache and we win time!
        lru_cache_data_t vram_handle = lru_cache_get(vram_index);

        // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
        // Dynamic allocation of sprites in vera vram.
        vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle));
        vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle));

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
        bool lru_cache_max = lru_cache_is_max();

        char f = 0;

        // Free up the lru_cache and vram memory until the requested size is available!
        // This ensures that vram has sufficient place to allocate the new sprite image. 
        while (lru_cache_max || !vram_has_free) {

            // If the cache is at it's maximum, before we can add a new element, we must remove the least used image.
            // We search for the least used image in vram.
            lru_cache_key_t vram_last = lru_cache_find_last();

            // We delete the least used image from the vram cache, and this function returns the stored vram handle obtained by the vram heap manager.
            lru_cache_data_t vram_handle = lru_cache_delete(vram_last);
            if (vram_handle == 0xFFFF) {
#ifdef __INCLUDE_PRINT
                gotoxy(0, 59);
                printf("error! vram_handle is nothing!");
#endif
            }

            f++;

            // And we free the vram heap with the vram handle that we received.
            // But before we can free the heap, we must first convert back from the sprite offset to the vram address.
            // And then to a valid vram handle :-).
            vera_heap_free(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle));
            vram_has_free = vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required);
            lru_cache_max = lru_cache_is_max();
        }

#ifdef __DEBUG_LRU_CACHE
        printf("f%u ", f);
        printf("n ");
#endif

        // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
        // Dynamic allocation of sprites in vera vram.
        lru_cache_data_t vram_handle = vera_heap_alloc(VERA_HEAP_SEGMENT_SPRITES, (unsigned long)sprite_cache.size[fe_sprite_index]);
        vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle));
        vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle));

        // We retrieve the image from BRAM from the sprite_control bank.
        // TODO: what if there are more sprite control data than that can fit into one CX16 bank?
        bank_push_set_bram(BANK_ENGINE_SPRITES);
        sprite_bram_handles_t handle_bram = sprite_bram_handles[image_index];
        bank_pull_bram();

        bram_bank_t sprite_bank = bram_heap_data_get_bank(1, handle_bram);
        bram_ptr_t  sprite_ptr = bram_heap_data_get_offset(1, handle_bram);
        unsigned int sprite_size = sprite_cache.size[fe_sprite_index];
        memcpy_vram_bram(vram_bank, vram_offset, sprite_bank, sprite_ptr, sprite_size);

        sprite_offset = vera_sprite_get_image_offset(vram_bank, vram_offset);
        lru_cache_insert(image_index, vram_handle);

#ifdef __CPULINES
        vera_display_set_border_color(BLACK);
#endif
    }

    // We return the image offset in vram of the sprite to be drawn.
    // This offset is used by the vera image set offset function to directly change the image displayed of the sprite!
    return sprite_offset;
}

// todo, need to detach vram allocation from cache management.
fe_sprite_index_t fe_sprite_cache_copy(sprite_index_t sprite_index)
{

    bank_push_set_bram(BANK_ENGINE_SPRITES);

    unsigned char c = sprites.sprite_cache[sprite_index];
    sprite_index_t cache_bram = (sprite_index_t)sprite_cache.sprite_bram[c];

    // If it is a new cache entry (never seen the sprite before)
    // or it is an existing cache entry but it is unused and the bram points to a different sprite,
    // Allocate, otherwise reuse the existing sprite.
    if (cache_bram != sprite_index) {
        if (sprite_cache.used[c]) {
            while (sprite_cache.used[fe.sprite_cache_pool]) {
                fe.sprite_cache_pool = (fe.sprite_cache_pool + 1) % FE_CACHE;
            }
            c = fe.sprite_cache_pool;
        }

        unsigned char co = c * FE_CACHE;

        sprites.sprite_cache[sprite_index] = c;
        sprite_cache.sprite_bram[c] = sprite_index;

        sprite_cache.count[c] = sprites.count[sprite_index];
        sprite_cache.offset[c] = sprites.offset[sprite_index];
        sprite_cache.size[c] = sprites.SpriteSize[sprite_index];
        sprite_cache.zdepth[c] = sprites.Zdepth[sprite_index];
        sprite_cache.bpp[c] = sprites.BPP[sprite_index];
        sprite_cache.height[c] = sprites.Height[sprite_index];
        sprite_cache.width[c] = sprites.Width[sprite_index];
        sprite_cache.hflip[c] = sprites.Hflip[sprite_index];
        sprite_cache.vflip[c] = sprites.Vflip[sprite_index];
        sprite_cache.reverse[c] = sprites.reverse[sprite_index];
        sprite_cache.palette_offset[c] = sprites.PaletteOffset[sprite_index];
        sprite_cache.loop[c] = sprites.loop[sprite_index];
        strcpy(&sprite_cache.file[co], sprites.file[sprite_index]);

        sprite_cache.xmin[c] = sprites.aabb[sprite_index].xmin >> 2;
        sprite_cache.ymin[c] = sprites.aabb[sprite_index].ymin >> 2;
        sprite_cache.xmax[c] = sprites.aabb[sprite_index].xmax >> 2;
        sprite_cache.ymax[c] = sprites.aabb[sprite_index].ymax >> 2;
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

void sprite_map_header(sprite_file_header_t* sprite_file_header, sprite_index_t sprite)
{
    sprites.count[sprite] = sprite_file_header->count;
    sprites.SpriteSize[sprite] = sprite_file_header->size;
    sprites.Width[sprite] = vera_sprite_width_get_bitmap(sprite_file_header->width);
    sprites.Height[sprite] = vera_sprite_height_get_bitmap(sprite_file_header->height);
    sprites.Zdepth[sprite] = vera_sprite_zdepth_get_bitmap(sprite_file_header->zdepth);
    sprites.Hflip[sprite] = vera_sprite_hflip_get_bitmap(sprite_file_header->hflip);
    sprites.Vflip[sprite] = vera_sprite_vflip_get_bitmap(sprite_file_header->vflip);
    sprites.BPP[sprite] = vera_sprite_bpp_get_bitmap(sprite_file_header->bpp);
    sprites.reverse[sprite] = sprite_file_header->reverse;
    sprites.aabb[sprite].xmin = sprite_file_header->collision;
    sprites.aabb[sprite].ymin = sprite_file_header->collision;
    sprites.aabb[sprite].xmax = sprite_file_header->width - sprite_file_header->collision;
    sprites.aabb[sprite].ymax = sprite_file_header->height - sprite_file_header->collision;
    sprites.PaletteOffset[sprite] = 0;
    sprites.loop[sprite] = sprite_file_header->loop;
    sprites.sprite_cache[sprite] = 255;
}

// Load the sprite into bram using the new cx16 heap manager.
unsigned int fe_sprite_bram_load(sprite_index_t sprite_index, unsigned int sprite_offset)
{

    bank_push_set_bram(BANK_ENGINE_SPRITES);


    if (!sprites.loaded[sprite_index]) {

        char filename[16];
        strcpy(filename, sprites.file[sprite_index]);
        strcat(filename, ".bin");

#ifdef __DEBUG_LOAD
        printf("\n%10s : ", filename);
#endif

        FILE* fp = fopen(filename,"r");
        if (!fp) {
#ifdef __INCLUDE_PRINT
            if (status) printf("error opening file %s\n", filename);
#endif
        } else {
            sprite_file_header_t sprite_file_header;

            // Read the header of the file into the sprite_file_header structure.
            unsigned int read = fgets((char*)&sprite_file_header, sizeof(sprite_file_header_t), fp);

            if (!read) {
#ifdef __INCLUDE_PRINT
                if (end) {
                    printf("error loading file %s, status = %u\n", filename, status);
                }
#endif

            } else {

                sprite_map_header(&sprite_file_header, sprite_index);

                // BREAKPOINT
                // The palette data, which we load and index using the palette library.
                palette_index_t palette_index = palette_alloc_bram();
                palette_ptr_t palette_ptr = palette_ptr_bram(palette_index);
                bank_push_set_bram(BANK_ENGINE_PALETTE);
                read = fgets((char*)palette_ptr, 32, fp);
                bank_pull_bram();
                sprites.PaletteOffset[sprite_index] = palette_index;

                sprites.offset[sprite_index] = sprite_offset;
                unsigned int sprite_size = sprites.SpriteSize[sprite_index];
                unsigned int total_loaded = 0;

#ifdef __DEBUG_LOAD
                printf("%02x %04x %2x %4x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x: ",
                    sprite_index, sprites.offset[sprite_index], sprites.count[sprite_index], sprites.SpriteSize[sprite_index], sprites.Width[sprite_index], sprites.Height[sprite_index], sprites.BPP[sprite_index], sprites.Hflip[sprite_index], sprites.Vflip[sprite_index],
                    sprites.aabb[sprite_index].xmin, sprites.aabb[sprite_index].ymin, sprites.aabb[sprite_index].xmax, sprites.aabb[sprite_index].ymax, sprites.loop[sprite_index], sprites.reverse[sprite_index]);
#endif
                for (unsigned char s = 0; s < sprites.count[sprite_index]; s++) {
                    bram_heap_handle_t handle_bram = bram_heap_alloc(1, sprite_size);
#ifdef __DEBUG_LOAD
                    cputc('.');
#endif
      
                    bram_bank_t sprite_bank = bram_heap_data_get_bank(1, handle_bram);
                    bram_ptr_t  sprite_ptr = bram_heap_data_get_offset(1, handle_bram);
                    bank_push_set_bram(sprite_bank);
                    unsigned int read = fgets(sprite_ptr, sprite_size, fp);
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
                        total_loaded += sprites.SpriteSize[sprite_index];
                        sprite_offset++;
                    }
                }


                
                // Now we have read everything and we close the file.
                if (fclose(fp)) {
#ifdef __INCLUDE_PRINT
                    if (status) printf("error closing file %s\n", sprites.file);
#endif
                } else {
                    sprites.loaded[sprite_index] = 1;
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
    vera_sprite_palette_offset(sprite_offset, palette_use_vram(sprite_cache.palette_offset[s]));
}

// #pragma var_model(mem)
#pragma data_seg(Data)
#pragma data_seg(Code)

