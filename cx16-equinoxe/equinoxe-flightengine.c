// Space flight engine for a space game written in kickc for the Commander X16.

// #ifndef __CC65__
    // #pragma var_model(mem)
// #endif

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
        *vram_sprites = heap_handle_add(*vram_sprites, SpriteSize);
    }
}

// Load the sprite into bram using the new cx16 heap manager.
void sprite_load(Sprite* sprite) 
{

    unsigned int status = open_file(1, 8, 0, sprite->File);
    if (!status) printf("error opening file %s\n", sprite->File);

    printf("spritecount = %u\n", sprite->SpriteCount);

    for(char s=0; s<sprite->SpriteCount; s++) {
        heap_handle handle = heap_alloc(bins, sprite->SpriteSize);
        unsigned int bytes_loaded = load_file_bram(1, 8, 0, handle.bank, handle.ptr, sprite->SpriteSize);
        if (!bytes_loaded) {
            printf("error loading file %s\n", sprite->File);
            break;
        }
        sprite->bram_handle[s] = handle; // TODO: rework this to map into banked memory.
    }

    status = close_file(1, 8, 0);
    if (!status) printf("error closing file %s\n", sprite->File);

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
    vera_sprite_set_collision_mask(sprite_offset, sprite->CollisionMask);
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


inline void Logic(void) {
    LogicPlayer();
    LogicBullets();
    LogicEnemies();
}

unsigned int collisions = 0;

//VSYNC Interrupt Routine

__interrupt(rom_sys_cx16) void irq_vsync() {

    bram_bank_t oldbank = bank_get_bram();


    #ifdef debug_scanlines
    vera_display_set_border_color(3);
    #endif

    ht_reset(&ht_collision);

    char cx16_mouse_status = cx16_mouse_get();

    game.prev_mousex = game.curr_mousex;
    game.prev_mousey = game.curr_mousey;
    game.curr_mousex = cx16_mousex;
    game.curr_mousey = cx16_mousey;
    game.status_mouse = cx16_mouse_status;
    if(!(game.ticksync & 0x01)) {
        LogicStage();
        game.tickstage++;
    }
    game.ticksync++;

    // volatile void (*fn)();
    // fn = game.delegate.Logic;
    // (*fn)();
    // fn = game.delegate.Draw;
    // (*fn)();

    #ifdef debug_scanlines
    vera_display_set_border_color(7);
    #endif
    LogicPlayer();

    #ifdef debug_scanlines
    vera_display_set_border_color(6);
    #endif
    LogicBullets();

    #ifdef debug_scanlines
    vera_display_set_border_color(1);
    #endif
    LogicEnemies();

    // // Check if collision interrupt
    // if(vera_sprite_is_collision()) {
    //     sprite_collided = vera_sprite_get_collision();
    //     vera_sprite_collision_clear();
    // } else {
    //     if(sprite_collided) {
            // check which bullet collides with which enemy ...

           
        vera_display_set_border_color(2);

        // Check player collisions
        // {
            
        //     heap_handle handle_entityA = player_handle;
        //     entity_t* entityA = (entity_t*)heap_data_ptr(handle_entityA);
        //     signed int xA = entityA->tx.i;
        //     signed int yA = entityA->ty.i;

        //     unsigned xmin = (unsigned int)xA;
        //     unsigned ymin = (unsigned int)yA;
        //     unsigned int xmax = (xmin + 32) & 0b1111111111000000; 
        //     unsigned int ymax = (ymin + 32) & 0b1111111111000000; 

        //     xmin = xmin & 0b1111111111000000;
        //     ymin = ymin & 0b1111111111000000;

        //     unsigned char grid = 0;

        //     for(unsigned int gx=xmin; gx<=xmax; gx+=64) {
        //         for(unsigned int gy=ymin; gy<=ymax; gy+=64) {

        //             ht_key_t ht_keyB = grid_key(0b01000000,(unsigned int)gx,(unsigned int)gy);
        //             ht_item_t* ht_itemB = ht_get(ht_collision, ht_size_collision, ht_keyB);
        //             // gotoxy(0,20);
        //             // printf("       %4p",ht_itemB);
        //             while(ht_itemB) {
        //                 heap_handle handle_entityB = ht_itemB->data;
        //                 entity_t* entityB = (entity_t*)heap_data_ptr(handle_entityB);
        //                 signed int xB = entityB->tx.i;
        //                 signed int yB = entityB->ty.i;
        //                 // printf("keyB = %4x, xA = %i, xB = %i, yA = %i, yB = %i, ", ht_keyB, xA, xB, yA, yB);
        //                 if(xA > xB+32 || xA+32 < xB || yA > yB+32 || yB+32 < yB) {
                            
        //                 } else {
        //                     // printf("\ncollisions = %u", collisions++);
        //                 }
        //                 // TODO: This crashes the compiler - ht_item_t* ht_itemB = ht_get_next(ht_collision, ht_size_collision, ht_key, ht_itemB);
        //                 ht_itemB = ht_get_next(ht_collision, ht_size_collision, ht_keyB, ht_itemB);
        //                 // gotoxy(0,20);
        //                 // printf("%4p ",ht_itemB);
        //             }
        //         }
        //     }
        // }

        #ifdef debug_scanlines
        vera_display_set_border_color(9);
        #endif

        // Check player bullet collisions

        if(stage.sprite_bullet_count) {

            for(unsigned char gx=0; gx<640>>2; gx+=64>>2) {
                for(unsigned char gy=0; gy<480>>2; gy+=64>>2) {

                    ht_key_t ht_key_bullet = grid_key(3, gx, gy);
                    ht_index_t ht_index_bullet = ht_get(&ht_collision, ht_key_bullet);

                    ht_key_t ht_key_enemy = grid_key(2, gx, gy);

                    while(ht_index_bullet) {
                        unsigned char b = (unsigned char)ht_get_data(ht_index_bullet);

                        if(bullet.used[b]) {
                            signed int x_bullet = (signed int)WORD1(bullet.tx[b]);
                            signed int y_bullet = (signed int)WORD1(bullet.ty[b]);

                            ht_index_t ht_index_enemy = ht_get(&ht_collision, ht_key_enemy);

                            while(ht_index_enemy) {
                                unsigned char e = (unsigned char)ht_get_data(ht_index_enemy);

                                if(enemy.used[e]) {
                                    signed int x_enemy = (signed int)WORD1(enemy.tx[e]);
                                    signed int y_enemy = (signed int)WORD1(enemy.ty[e]);

                                    if(x_bullet > x_enemy+32 || y_bullet > y_enemy+32 || 
                                       x_bullet+1 < x_enemy || y_bullet+8 < y_enemy) {
                                    } else {
                                        RemoveBullet(b);
                                        RemoveEnemy(e);
                                        break;
                                    }
                                }
                                ht_index_enemy = ht_get_next(ht_index_enemy);
                            }
                        }
                        ht_index_bullet = ht_get_next(ht_index_bullet);
                    }
                }   
            }       
        }

    //         sprite_collided = 0;
    //     }
    // }

    vera_display_set_border_color(8);


#ifndef __FLOOR

    // background scrolling
    if(!scroll_action--) {
        scroll_action = 2;
            
        // Check every 16 vscroll movements if something needs to be done.
        // 0b11110000 is the mask for testing every 16 iterations based on vscroll value.
        if((BYTE0(vscroll) & 0xF0)==BYTE0(vscroll) ) {

            if(row%4==3) {
                floor_draw();
            }

            vera_tile_row(row);

            if(row<=31) {
                // unsigned int dest_row = FLOOR_MAP_OFFSET_VRAM+(((row)+32)*64*2); // TODO: To change in increments and counters for performance.
                // unsigned int src_row = FLOOR_MAP_OFFSET_VRAM+((row)*64*2); // TODO: To change in increments and counters for performance.
                memcpy8_vram_vram(FLOOR_MAP_BANK_VRAM, tilerowdst, FLOOR_MAP_BANK_VRAM, tilerowsrc, 64*2); // Copy one row.
            }

            if(!vscroll) {
                vscroll=16*32;
            }

            if(!row) {
                row=31;
                tilerowdst = FLOOR_MAP_OFFSET_VRAM_DST_63;
                tilerowsrc = FLOOR_MAP_OFFSET_VRAM_SRC_31;
            } else {
                row--;
                tilerowsrc-=64*2;
                tilerowdst-=64*2;
            }
        }

        vera_layer0_set_vertical_scroll(vscroll);
        vscroll--;
       
    }

#endif

    // vera_layer_set_horizontal_scroll(0, (unsigned int)cx16_mousex*2);

    #ifdef debug_scanlines
    vera_display_set_border_color(1);
    #endif

    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
    // vera_sprites_collision_on();

    // vera_sprite_buffer_write(sprite_buffer);

    bank_set_bram(oldbank);
    // gotoxy(curx, cury);

    vera_display_set_border_color(0);
}

void main() {

    ht_init(&ht_collision);

    // vera_sprite_buffer_read(sprite_buffer);

    // We are going to use only the kernal on the X16.
    bank_set_brom(CX16_ROM_KERNAL);

    // We create the heap blocks in BRAM using the Fixed Block Heap Memory Manager.
    heap_segment_define(bins, bin64, 64, 128, 64*128);
    heap_segment_define(bins, bin128, 128, 64, 128*364);
    heap_segment_define(bins, bin256, 256, 64, 256*64);
    heap_segment_define(bins, bin512, 512, 64, 512*64);

    // Memory is managed as follows:
    // ------------------------------------------------------------------------
    //
    // SEGMENT                          VRAM                  BRAM
    // -------------------------        -----------------     -----------------
    // FLOOR MAP                        00:0000 - 00:2000     
    // FLOOR TILE                       00:2000 - 00:A000
    // SPRITES                          01:0000 - 01:B000
    // PETSCII                          01:B000 - 01:F800     
    // 
    // HEAP_SEGMENT_BRAM_SPRITES                              02/A000 - 20/C000
    // PALETTE                                                3F:A000 - 3F:C000

    petscii();

    vera_layer0_mode_bitmap( 
        0, 0x0000, 
        VERA_TILEBASE_WIDTH_16,
        VERA_LAYER_COLOR_DEPTH_1BPP
    );

    vera_layer0_show();

    bitmap_init(0, 0x00000);
    bitmap_clear();

    // Allocate the segment for the tiles in vram.
    const word VRAM_FLOOR_MAP_SIZE = 64*64*2;
    const word VRAM_FLOOR_TILE_SIZE = TILE_FLOOR_COUNT*32*32/2;

    // Load the palettes in main banked memory.
    heap_handle handle_bram_palettes = {63, (bram_ptr_t)0xA000}; // size = 0x2000;

    unsigned int palette_loaded = 0;

    unsigned int floor_palette_loaded = load_file(1, 8, 0, FILE_PALETTES_FLOOR01, handle_bram_palettes.bank, handle_bram_palettes.ptr+palette_loaded);
    if(!floor_palette_loaded) printf("error file_palettes");
    palette_loaded += floor_palette_loaded;
    heap_handle_ptr ptr_bram_palettes_floor = heap_ptr(handle_bram_palettes)+palette_loaded;

    unsigned int sprite_palette_loaded = load_file(1, 8, 0, FILE_PALETTES_SPRITE01, handle_bram_palettes.bank, handle_bram_palettes.ptr+palette_loaded);
    if(!sprite_palette_loaded) printf("error file_palettes");
    palette_loaded += sprite_palette_loaded;
    heap_handle_ptr ptr_bram_palettes_sprite = heap_ptr(handle_bram_palettes)+palette_loaded;

    memcpy_vram_bram(VERA_PALETTE_BANK, (word)VERA_PALETTE_PTR+(word)32, handle_bram_palettes.bank, handle_bram_palettes.ptr, palette_loaded);

    // Tested

#ifndef __FLOOR
    // // TILE INITIALIZATION 

    // // Initialize the bram heap for tile loading.
    // heap_address bram_floor_tile = heap_segment_bram(
    //     HEAP_SEGMENT_BRAM_TILES,
    //     heap_bram_pack(33,(heap_ptr)0xA000),
    //     heap_size_pack(0x2000*8)
    //     );

    // // gotoxy(0, 10);

    // // Loading the graphics in main banked memory.
    // for(i=0; i<TILE_TYPES;i++) {
    //     tile_load(TileDB[i]);
    // }

    // // Now we activate the tile mode.
    // for(i=0;i<TILE_TYPES;i++) {
    //     tile_cpy_vram_from_bram(TileDB[i]);
    // }


    // vera_layer0_mode_tile( 
    //     FLOOR_MAP_BANK_VRAM, FLOOR_MAP_OFFSET_VRAM, 
    //     0, 0x2000, 
    //     VERA_LAYER_WIDTH_64, VERA_LAYER_HEIGHT_64,
    //     VERA_TILEBASE_WIDTH_16, VERA_TILEBASE_HEIGHT_16, 
    //     VERA_LAYER_COLOR_DEPTH_8BPP
    // );


    // tile_background();

    // vera_layer0_show();
    // vera_layer1_show();

#endif

    vera_sprites_show();

    // Loading the sprites in bram.
    for (byte i = 0; i < SPRITE_TYPES;i++) {
        sprite_load(SpriteDB[i]);
    }

    heap_handle handle_vram_sprites = {1, (heap_handle_ptr)0x0000}; // size = 0xB000;

    // Now we copy the sprites from bram to vram.
    for (byte i = 0;i < SPRITE_TYPES;i++) {
        sprite_cpy_vram_from_bram(SpriteDB[i], &handle_vram_sprites);
    }


    // Initialize stage
    StageInit();

    #ifdef debug_scanlines
    // Set border to measure scan lines
    vera_display_set_hstart(2);
    vera_display_set_hstop(158);
    vera_display_set_vstart(2);
    vera_display_set_vstop(236);
    #endif

    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC;
    // vera_sprites_collision_on();
    CLI();

    cx16_mouse_config(0xFF, 1);

    char cx16_mouse_status = cx16_mouse_get();
    game.prev_mousex = cx16_mousex;
    game.prev_mousey = cx16_mousey;
    game.curr_mousex = cx16_mousex;
    game.curr_mousey = cx16_mousey;

    while (!getin()) {
        // SEI();
        // gotoxy(0,0);
        // grid_print(&ht_collision);
        // CLI();
    }; 

    // Back to basic.
    bank_set_brom(CX16_ROM_BASIC);

}

