#include "equinoxe.h"

#pragma data_seg(DATA_SPRITE_CACHE)
// Cache to manage sprite control data fast, unbanked as making this banked will make things very, very complicated.
fe_sprite_cache_t sprite_cache;

#pragma data_seg(DATA_ENGINE_FLIGHT)
flight_t flight;

volatile fe_t sprite_cache_pool; // Flight engine control.
vera_sprite_offset flight_sprite_offsets[127] = {0};

volatile sprite_bram_handles_t sprite_bram_handles[256];

volatile unsigned char flight_sprite_offset_pool = 1;

#pragma code_seg(CODE_ENGINE_FLIGHT)

void flight_init() {
    memset_fast(sprite_cache.sprite_bram, 255, 16);
    flight_sprite_offset_pool = 1;
    memset_fast(flight.root, 0, 10);
    memset_fast(flight.count, 0, 10);
}

flight_index_t flight_add(flight_type_t type, flight_side_t side, sprite_index_t sprite) {

    unsigned char f = flight.index % FLIGHT_OBJECTS;
    while (!f || flight.used[f]) {
        f = (f + 1) % FLIGHT_OBJECTS;
    }
    flight.index = f;

    // p.r = 3 => f[3].n = 2, f[2].n = 1, f[1].n = -
    //         => f[3].p = -, f[2].p = 3, f[1].p = 2
    // Add 4
    // p.r = 4 => f[4].n = 3, f[3].n = 2, f[2].n = 1, f[1].n = -
    // p.r = 4 => f[4].p = -, f[3].p = 4, f[2].p = 3, f[1].p = 2

    flight_index_t r = flight.root[type];
    flight.next[f] = r;
    flight.prev[f] = NULL;
    if (r)
        flight.prev[r] = f;
    flight.root[type] = f;
    flight.count[type]++;

    flight.type[f] = type;
    flight.side[f] = side;

    flight.used[f] = 1;
    flight.enabled[f] = 0;

    flight.move[f] = 0;
    flight.moved[f] = 0;
    flight.moving[f] = 0;
    flight.angle[f] = 0;
    flight.speed[f] = 0;
    flight.action[f] = 0;
    flight.turn[f] = 0;
    flight.radius[f] = 0;
    flight.reload[f] = 0;
    flight.delay[f] = 0;

    unsigned char s = fe_sprite_cache_copy(sprite);
    flight.cache[f] = s;

    flight.sprite_offset[f] = flight_sprite_next_offset();
    fe_sprite_configure(flight.sprite_offset[f], s);

    return f;
}

void flight_remove(flight_type_t type, flight_index_t f) {

    if (flight.used[f]) {
        flight.used[f] = 0;
        flight.enabled[f] = 0;
        flight.collided[f] = 1;

        flight.count[type]--;

        // p.r = 4 => f[4].n = 3, f[3].n = 2, f[2].n = 1, f[1].n = -
        // p.r = 4 => f[4].p = -, f[3].p = 4, f[2].p = 3, f[1].p = 2
        // Remove 4
        // p.r = 3 => f[3].n = 2, f[2].n = 1, f[1].n = -
        //         => f[3].p = -, f[2].p = 3, f[1].p = 2
        flight_index_t r = flight.root[type];
        if(!flight.next[r]) {
            flight.root[type] = NULL;
        } else {
            flight_index_t n = flight.next[f];
            flight_index_t p = flight.prev[f];
            if (n) {
                flight.prev[n] = p;
            }
            if (p) {
                flight.next[p] = n;
            }
            if (r == f) {
                flight.root[type] = n;
            }
        }
        flight.next[f] = NULL;
        flight.prev[f] = NULL;

        vera_sprite_offset sprite_offset = flight.sprite_offset[f];
        flight_sprite_free_offset(sprite_offset);
        vera_sprite_disable(sprite_offset);
        palette_unuse_vram(sprite_cache.palette_offset[flight.cache[f]]);
        fe_sprite_cache_free(flight.cache[f]);
    }
}

flight_index_t flight_root(flight_type_t type) { return flight.root[type]; }

flight_index_t flight_next(flight_index_t i) { return flight.next[i]; }

signed char flight_hit(unsigned char f, signed char impact) {
    flight.health[f] += impact;
    if(flight.health[f] <= 0) {
		flight.collided[f] = 1;
		return 1;
    }
    return 0;
}

signed char flight_impact(unsigned char f) {
    signed char impact = flight.impact[f];
    return impact;
}


// This will need rework
unsigned char flight_has_collided(unsigned char f) {
	unsigned char collided = flight.collided[f];
    flight.collided[f] = 1;
	return collided;
}

void flight_draw() {

    // BREAKPOINT

    for (unsigned char f = 0; f < FLIGHT_OBJECTS; f++) {

        if (flight.used[f]) {

            unsigned int x = flight.xi[f];
            unsigned int y = flight.yi[f];

            vera_sprite_offset sprite_offset = flight.sprite_offset[f];

            // BREAKPOINT

            // if( x<640+68 && y<480+68 && (signed int)x>-68 && (signed int)y>-68 ) {

            unsigned char a = flight.animate[f];
            unsigned char s = animate_get_image(a);
            volatile unsigned char i = flight.cache[f]; // This variable needs to be volatile or the kickc optimizer kills it.
            if (animate_is_waiting(a)) {
                *VERA_CTRL &= ~VERA_ADDRSEL; // Select DATA0
                *VERA_ADDRX_H = 1 | VERA_INC_1;
                *VERA_ADDRX_M = BYTE1(sprite_offset + 2); // Normally the +2 should not be an issue.
                *VERA_ADDRX_L = BYTE0(sprite_offset + 2);
            } else {
                vera_sprite_image_offset sprite_image_offset = sprite_image_cache_vram(i, s);
                if(sprite_image_offset==0x0) {
                    BREAKPOINT
                }
                // gotoxy(0,0);
                // printf("%02x %04x, ", f, sprite_image_offset);

                *VERA_CTRL &= ~VERA_ADDRSEL; // Select DATA0
                *VERA_ADDRX_H = 1 | VERA_INC_1;
                *VERA_ADDRX_M = BYTE1(sprite_offset); // Normally the +2 should not be an issue.
                *VERA_ADDRX_L = BYTE0(sprite_offset);
                *VERA_DATA0 = BYTE0(sprite_image_offset);
                *VERA_DATA0 = BYTE1(sprite_image_offset);
                // }
            }
            *VERA_DATA0 = BYTE0(x);
            *VERA_DATA0 = BYTE1(x);
            *VERA_DATA0 = BYTE0(y);
            *VERA_DATA0 = BYTE1(y);
            *VERA_ADDRX_H = 1 | VERA_INC_0;
            *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | sprite_cache.zdepth[flight.cache[f]];
        }
    }
}

// void flight_debug(unsigned char i) {
//     gotoxy(0,51);
//     printf("i: %02x ", flight.index);
//     printf("p: %02x %02x ", flight.root[FLIGHT_PLAYER], flight.count[FLIGHT_PLAYER]);
//     printf("e: %02x %02x ", flight.root[FLIGHT_ENEMY], flight.count[FLIGHT_ENEMY]);
//     printf("b: %02x %02x ", flight.root[FLIGHT_BULLET], flight.count[FLIGHT_BULLET]);

//     char x =  (i / 32) * 16;
//     char y = i % 32;
//     gotoxy(x, y);
//     printf("i:%02x n:%02x p:%02x t:%01x", i, flight.next[i], flight.prev[i], flight.type[i]);
// }

vera_sprite_offset flight_sprite_next_offset() {
    while (!flight_sprite_offset_pool || flight_sprite_offsets[flight_sprite_offset_pool]) {
        flight_sprite_offset_pool = (flight_sprite_offset_pool + 1) % 128;
    }

    stage.sprite_count++;
    vera_sprite_offset sprite_offset = vera_sprite_get_offset(flight_sprite_offset_pool);
    flight_sprite_offsets[flight_sprite_offset_pool] = sprite_offset;
    return sprite_offset;
}

void flight_sprite_free_offset(vera_sprite_offset sprite_offset) {
    vera_sprite_id sprite_id = vera_sprite_get_id(sprite_offset);
    flight_sprite_offsets[sprite_id] = 0;
    stage.sprite_count--;
}

#ifdef __DEBUG_SPRITE_CACHE

void fe_sprite_debug() {
    char x = wherex();
    char y = wherey();

    printf("pool %2x", sprite_cache_pool);
    gotoxy(0, 3);
    printf("ca bram used file           offs size wi he");

    for (unsigned int c = 0; c < FE_CACHE; c++) {
        gotoxy(0, (char)c + 4);
        printf("%02x %04p %02x %16s %4u %4u %02x %02x", c, sprite_cache.sprite_bram[c], sprite_cache.used[c], &sprite_cache.file[c * 16],
               sprite_cache.offset[c], sprite_cache.size[c], sprite_cache.width[c], sprite_cache.height[c]);
    }

    gotoxy(x, y);
}
#endif

vera_sprite_image_offset sprite_image_cache_vram(fe_sprite_index_t sprite_cache_index, unsigned char fe_sprite_image_index) {
    // check if the image in vram is in use where the fe_sprite_vram_image_index is pointing to.
    // if this vram_image_used is false, that means that the image in vram is not in use anymore (not displayed or destroyed).

    
    

    unsigned int image_index = sprite_cache.offset[sprite_cache_index] + fe_sprite_image_index;

    // We declare temporary variables for the vram memory handles.
    // lru_cache_data_t vram_handle;
    // vram_bank_t vram_bank;
    // vram_offset_t vram_offset;

#ifdef __DEBUG_LRU_CACHE
    char x = (image_index / 32) * 16;
    char y = (char)(image_index % 32);

    // gotoxy(0, 0);
    // printf("%02x %02x %04x               ", fe_sprite_index, fe_sprite_image_index, image_index);
    // gotoxy(x, y);
    printf("%04x ", image_index);
    // gotoxy(x + 6, y);
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
        vera_heap_index_t vram_handle = (vera_heap_index_t)lru_cache_get(vram_index);

        // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
        // Dynamic allocation of sprites in vera vram.
        vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle));
        vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle));

        // We have extended the vera heap manager to also keep the offset of the sprite image, instead of calculating.
        // sprite_offset = vera_sprite_get_image_offset(vram_bank, vram_offset);
        sprite_offset = vera_heap_get_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle);
    } else {

#ifdef __CPULINES
        vera_display_set_border_color(RED);
#endif

        // NO CACHE HIT -> allocate new image.

        // BREAKPOINT
        // vera_heap_dump(VERA_HEAP_SEGMENT_SPRITES,0,0);

        // The idea of this section is to free up lru_cache and/or vram memory until there is sufficient space available.
        // The size requested contains the required size to be allocated on vram.
        vera_heap_size_int_t vram_size_required = sprite_cache.size[sprite_cache_index];

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
#endif

        // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
        // Dynamic allocation of sprites in vera vram.
        vera_heap_index_t vram_handle = vera_heap_alloc(VERA_HEAP_SEGMENT_SPRITES, (unsigned long)sprite_cache.size[sprite_cache_index]);
        vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle));
        vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle));

        // We retrieve the image from BRAM from the sprite_control bank.
        // TODO: what if there are more sprite control data than that can fit into one CX16 bank?
        bank_push_set_bram(BANK_ENGINE_SPRITES);
        sprite_bram_handles_t handle_bram = sprite_bram_handles[image_index];
        bank_pull_bram();

        bram_bank_t sprite_bank = bram_heap_data_get_bank(0, handle_bram);
        bram_ptr_t sprite_ptr = bram_heap_data_get_offset(0, handle_bram);
        unsigned int sprite_size = sprite_cache.size[sprite_cache_index];

#ifdef __DEBUG_LRU_CACHE
        printf("b:%02x p:%04p s:%04x ", sprite_bank, sprite_ptr, sprite_size);
#endif

        memcpy_vram_bram(vram_bank, vram_offset, sprite_bank, sprite_ptr, sprite_size);

        // Calculate the vera sprite offset, and store it in the vera heap manager.
        sprite_offset = vera_sprite_get_image_offset(vram_bank, vram_offset);
        vera_heap_set_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle, sprite_offset);

        lru_cache_insert(image_index, (lru_cache_data_t)vram_handle);

#ifdef __CPULINES
        vera_display_set_border_color(BLACK);
#endif
    }

#ifdef __DEBUG_LRU_CACHE
        printf("%04x \n", vram_offset);
#endif

    // We return the image offset in vram of the sprite to be drawn.
    // This offset is used by the vera image set offset function to directly change the image displayed of the sprite!
    return sprite_offset;
}

// todo, need to detach vram allocation from cache management.
fe_sprite_index_t fe_sprite_cache_copy(sprite_index_t sprite_index) {

    bank_push_set_bram(BANK_ENGINE_SPRITES);

    unsigned char c = sprites.sprite_cache[sprite_index];
    sprite_index_t cache_bram = (sprite_index_t)sprite_cache.sprite_bram[c];

    // If it is a new cache entry (never seen the sprite before)
    // or it is an existing cache entry but it is unused and the bram points to a different sprite,
    // Allocate, otherwise reuse the existing sprite.
    if (cache_bram != sprite_index) {
        if (sprite_cache.used[c]) {
            while (sprite_cache.used[sprite_cache_pool]) {
                sprite_cache_pool = (sprite_cache_pool + 1) % FE_CACHE;
            }
            c = sprite_cache_pool;
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

void fe_sprite_cache_free(fe_sprite_index_t fe_sprite_index) {
    sprite_cache.used[fe_sprite_index]--;

#ifdef __DEBUG_SPRITE_CACHE
    fe_sprite_debug();
#endif
}

void sprite_map_header(sprite_file_header_t *sprite_file_header, sprite_index_t sprite) {
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
    sprites.sprite_cache[sprite] = 0;
}

// Load the sprite into bram using the new cx16 heap manager.
unsigned int fe_sprite_bram_load(sprite_index_t sprite_index, unsigned int sprite_offset) {

    bank_push_set_bram(BANK_ENGINE_SPRITES);

    if (!sprites.loaded[sprite_index]) {

        char filename[16];
        strcpy(filename, sprites.file[sprite_index]);
        strcat(filename, ".bin");

#ifdef __DEBUG_LOAD
        printf("\n%10s : ", filename);
#endif

        FILE *fp = fopen(filename, "r");
        if (!fp) {
#ifdef __INCLUDE_PRINT
            if (status)
                printf("error opening file %s\n", filename);
#endif
        } else {
            sprite_file_header_t sprite_file_header;

            // Read the header of the file into the sprite_file_header structure.
            unsigned int read = fgets((char *)&sprite_file_header, sizeof(sprite_file_header_t), fp);

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
                read = fgets((char *)palette_ptr, 32, fp);
                bank_pull_bram();
                sprites.PaletteOffset[sprite_index] = palette_index;

                sprites.offset[sprite_index] = sprite_offset;
                unsigned int sprite_size = sprites.SpriteSize[sprite_index];
                unsigned int total_loaded = 0;

#ifdef __DEBUG_LOAD
                printf("%02x %04x %2x %4x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x: ", sprite_index, sprites.offset[sprite_index], sprites.count[sprite_index],
                       sprites.SpriteSize[sprite_index], sprites.Width[sprite_index], sprites.Height[sprite_index], sprites.BPP[sprite_index],
                       sprites.Hflip[sprite_index], sprites.Vflip[sprite_index], sprites.aabb[sprite_index].xmin, sprites.aabb[sprite_index].ymin,
                       sprites.aabb[sprite_index].xmax, sprites.aabb[sprite_index].ymax, sprites.loop[sprite_index], sprites.reverse[sprite_index]);
#endif
                for (unsigned char s = 0; s < sprites.count[sprite_index]; s++) {
                    bram_heap_handle_t handle_bram = bram_heap_alloc(0, sprite_size);
#ifdef __DEBUG_HEAP_BRAM
                    gotoxy(40,0);
                    printf("handle_bram = %u\n", handle_bram);
#endif
#ifdef __DEBUG_LOAD
                    cputc('.');
#endif

                    bram_bank_t sprite_bank = bram_heap_data_get_bank(0, handle_bram);
#ifdef __DEBUG_HEAP_BRAM
                    gotoxy(40,1);
                    printf("sprite_bank = %u\n", sprite_bank);
#endif
                    bram_ptr_t sprite_ptr = bram_heap_data_get_offset(0, handle_bram);
#ifdef __DEBUG_HEAP_BRAM
                    gotoxy(40,2);
                    printf("sprite_ptr = %p\n", sprite_ptr);
                    bram_heap_dump(0,0,2);
                    // bram_heap_dump_stats(0);
                    while(!kbhit());
#endif
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
                    if (status)
                        printf("error closing file %s\n", sprites.file);
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

void fe_sprite_configure(vera_sprite_offset sprite_offset, fe_sprite_index_t s) {
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
