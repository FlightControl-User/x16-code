// Space flight engine for a space game written in kickc for the Commander X16.

// #ifndef __CC65__
    #pragma var_model(mem)
// #endif

// #define __FLOOR 1

#include <cx16.h>
#include <cx16-heap.h>
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
#include <ht.h>

#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-floorengine.h"
#include "equinoxe-player.h"
#include "equinoxe-enemy.h"
#include "equinoxe-fighters.h"
#include "equinoxe-bullet.h"

void sprite_cpy_vram_from_bram(Sprite* sprite) {

    heap_ptr ptr_bram_sprite = heap_data_ptr(sprite->BRAM_Handle);
    heap_bank bank_bram_sprite = heap_data_bank(sprite->BRAM_Handle);

    byte SpriteCount = sprite->SpriteCount;
    word SpriteSize = sprite->SpriteSize;
    byte SpriteOffset = sprite->SpriteOffset;

    for (byte s = 0;s < SpriteCount;s++) {

        heap_handle handle_vram_sprite = heap_alloc(HEAP_SEGMENT_VRAM_SPRITES, SpriteSize);
        heap_bank bank_vram_sprite = heap_data_bank(handle_vram_sprite);
        heap_vram_offset offset_vram_sprite = (heap_vram_offset)heap_data_ptr(handle_vram_sprite);

        memcpy_vram_bram(bank_vram_sprite, (word)offset_vram_sprite, bank_bram_sprite, (byte*)ptr_bram_sprite, SpriteSize);

        sprite->offset_image[s] = vera_sprite_get_image_offset(bank_vram_sprite, offset_vram_sprite);
        ptr_bram_sprite = bank_bram_ptr_inc(bank_bram_sprite, ptr_bram_sprite, SpriteSize);
        bank_bram_sprite = bank_get_bram();
    }
}

// Load the sprite into bram using the new cx16 heap manager.
heap_handle sprite_load(Sprite* sprite) {

    heap_handle handle_bram_sprite = heap_alloc(HEAP_SEGMENT_BRAM_SPRITES, sprite->TotalSize);  // Reserve enough memory on the heap for the sprite loading.
    heap_ptr ptr_bram_sprite = heap_data_ptr(handle_bram_sprite);
    heap_bank bank_bram_sprite = heap_data_bank(handle_bram_sprite);
    heap_handle data_handle_bram_sprite = heap_data_get(handle_bram_sprite);

    unsigned int bytes_loaded = load_bram(1, 8, 0, sprite->File, bank_bram_sprite, ptr_bram_sprite);
    if (!bytes_loaded) printf("error file %s\n", sprite->File);

    sprite->BRAM_Handle = handle_bram_sprite;
    return handle_bram_sprite;
}

inline void sprite_create(Sprite* sprite, vera_sprite_offset sprite_offset) {
    // Copy sprite palette to VRAM
    // Copy 8* sprite attributes to VRAM
    vera_sprite_bpp(sprite_offset, sprite->BPP);
    vera_sprite_width(sprite_offset, sprite->Width);
    vera_sprite_height(sprite_offset, sprite->Height);
    vera_sprite_hflip(sprite_offset, sprite->Hflip);
    vera_sprite_vflip(sprite_offset, sprite->Vflip);
    vera_sprite_palette_offset(sprite_offset, sprite->PaletteOffset);
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

void sprite_animate(vera_sprite_offset sprite_offset, Sprite* sprite, byte index, byte animate) {
    byte SpriteCount = sprite->SpriteCount;
    index = (index >= SpriteCount) ? index - SpriteCount : index;
    if(!animate) {
        vera_sprite_set_image_offset(sprite_offset, sprite->offset_image[index]);
    }
    // vera_sprite_buffer_set_image_offset((vera_sprite_buffer_item_t *)sprite_offset, sprite->offset_image[index]);
}

void sprite_position(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y) {
    // vera_sprite_buffer_xy((vera_sprite_buffer_item_t *)sprite_offset, x, y);
    vera_sprite_xy(sprite_offset, x, y);
}

void sprite_enable(vera_sprite_offset sprite_offset, Sprite* sprite) {
    // vera_sprite_buffer_zdepth((vera_sprite_buffer_item_t *)sprite_offset, sprite->Zdepth);
    vera_sprite_zdepth(sprite_offset, sprite->Zdepth);
}

void sprite_disable(vera_sprite_offset sprite_offset) {
    // vera_sprite_buffer_disable((vera_sprite_buffer_item_t *)sprite_offset);
    vera_sprite_disable(sprite_offset);
}


void sprite_collision(vera_sprite_offset sprite_offset, byte mask) {
    // vera_sprite_collision_mask(sprite_offset, mask);
    vera_sprite_collision_mask(sprite_offset, mask);
}


inline void Logic(void) {
    LogicPlayer();
    LogicBullets();
    LogicEnemies();
}



//VSYNC Interrupt Routine

/* __interrupt(rom_sys_cx16) */ void irq_vsync() {

    vera_display_set_border_color(1);

    bram_bank_t oldbank = bank_get_bram();

    // Check if collision interrupt
    if (vera_sprite_is_collision()) {
        gotoxy(0, 20);
        sprite_collided = 1;
        vera_sprite_collision_clear();
    } else {
        if (sprite_collided) {
            sprite_collided = 0;
            // check which bullet collides with which enemy ...
           
            for(unsigned char cx=0;cx<10;cx++) {
                if(!grid.columns) continue;
                for(unsigned char cy=0;cy<8;cy++) {
                    if(!grid.column[cx].rows) continue;
                    unsigned char entities = grid.column[cx].row[cy].entities;
                    ht_key_t ht_key = (((unsigned int)cx << 4 + (unsigned int)cy)<<8);
                    for(unsigned char k=0; k<entities; k++) {
                        ht_item_t* ht_item = ht_get(ht_collision, ht_size_collision, ht_key+k);
                        heap_handle handle_entityA = ht_item->data;
                        entity_t* entityA = heap_data_ptr(handle_entityA);
                        signed int xA = entityA->tx.i;
                        signed int yA = entityA->ty.i;
                        for(unsigned char l=k+1; l<entities; l++) {
                            ht_item_t* ht_item = ht_get(ht_collision, ht_size_collision, ht_key+l);
                            heap_handle handle_entityB = ht_item->data;
                            entity_t* entityB = heap_data_ptr(handle_entityA);
                            signed int xB = entityB->tx.i;
                            signed int yB = entityB->ty.i;
                            if( xA > xB+32 || xA+32 < xB || yA > yB+32 || yB+32 < yB ) {
                                
                            } else {
                                vera_display_set_border_color(2);
                            }
                        }
                    }
                }
            }
        }
    }


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

    LogicPlayer();
    LogicBullets();
    LogicEnemies();

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

    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
    // vera_sprites_collision_on();

    // vera_sprite_buffer_write(sprite_buffer);

    bank_set_bram(oldbank);
    // gotoxy(curx, cury);

    vera_display_set_border_color(0);
}

void main() {

    ht_init(ht_collision, ht_size_collision);

    // vera_sprite_buffer_read(sprite_buffer);

    // We are going to use only the kernal on the X16.
    bank_set_brom(CX16_ROM_KERNAL);


    // Memory is managed as follows:
    // ------------------------------------------------------------------------
    //
    // HEAP SEGMENT                     VRAM                  BRAM
    // -------------------------        -----------------     -----------------
    // HEAP_SEGMENT_VRAM_PETSCII        01/B000 - 01/F800     01/A000 - 01/A400
    // HEAP_SEGMENT_VRAM_SPRITES        00/0000 - 01/B000     01/A400 - 01/C000
    // HEAP_SEGMENT_BRAM_SPRITES                              02/A000 - 20/C000
    // HEAP_SEGMENT_BRAM_PALETTE                              3F/A000 - 3F/C000

    heap_address vram_petscii = petscii();

    // Allocate the segment for the tiles in vram.
    const word VRAM_FLOOR_MAP_SIZE = 64*64*2;
    const word VRAM_FLOOR_TILE_SIZE = TILE_FLOOR_COUNT*32*32/2;

    // *** TILE MEMORY ALLOCATION ***

    // Allocate the segment for the floor map in vram.
    heap_vram_packed vram_floor_map = heap_segment_vram_floor(
        HEAP_SEGMENT_VRAM_FLOOR_MAP, 
        heap_vram_pack(FLOOR_MAP_BANK_VRAM, FLOOR_MAP_OFFSET_VRAM), 
        heap_size_pack(0x2000), 
        heap_bram_pack(1, (heap_ptr)0xA400), 
        0
        );



    //heap_segment_id segment_vram_floor_map = heap_segment_vram(HEAP_SEGMENT_VRAM_FLOOR_MAP, 1, 0x2000, 1, 0x0000, 1, 0xA400, 0);

    heap_vram_packed vram_floor_tile = heap_segment_vram_floor(
        HEAP_SEGMENT_VRAM_FLOOR_TILE, 
        heap_vram_pack(FLOOR_TILE_BANK_VRAM, FLOOR_TILE_OFFSET_VRAM), 
        heap_size_pack(0x8000), 
        heap_bram_pack(1, (bram_ptr_t)0xA400), 
        0x100
        );

    //heap_segment_id segment_vram_floor_tile = heap_segment_vram(HEAP_SEGMENT_VRAM_FLOOR_TILE, 1, 0xA000, 1, 0x2000, 1, 0xA400, 0x100);

    // Load the palettes in main banked memory.
    heap_address bram_palettes = heap_segment_bram(
        HEAP_SEGMENT_BRAM_PALETTES, 
        heap_bram_pack(63, (heap_ptr)0xA000), 
        heap_size_pack(0x2000)
        );

    // Allocate the segment for the sprites in vram.
    heap_vram_packed vram_sprites = heap_segment_vram_ceil(
        HEAP_SEGMENT_VRAM_SPRITES,
        vram_petscii,
        vram_petscii,
        heap_bram_pack(2, (heap_ptr)0xA000),
        heap_size_pack(0x2000)
    );

    heap_handle handle_bram_palettes = heap_alloc(HEAP_SEGMENT_BRAM_PALETTES, 8192);
    heap_ptr ptr_bram_palettes = heap_data_ptr(handle_bram_palettes);
    heap_bank bank_bram_palettes = heap_data_bank(handle_bram_palettes);

    unsigned int palette_loaded = 0;


    unsigned int floor_palette_loaded = load_bram(1, 8, 0, FILE_PALETTES_FLOOR01, bank_bram_palettes, ptr_bram_palettes+palette_loaded);
    if(!floor_palette_loaded) printf("error file_palettes");
    palette_loaded += floor_palette_loaded;
    heap_ptr ptr_bram_palettes_floor = heap_data_ptr(handle_bram_palettes)+palette_loaded;

    unsigned int sprite_palette_loaded = load_bram(1, 8, 0, FILE_PALETTES_SPRITE01, bank_bram_palettes, ptr_bram_palettes+palette_loaded);
    if(!sprite_palette_loaded) printf("error file_palettes");
    palette_loaded += sprite_palette_loaded;
    heap_ptr ptr_bram_palettes_sprite = heap_data_ptr(handle_bram_palettes)+palette_loaded;


    memcpy_vram_bram(VERA_PALETTE_BANK, (word)VERA_PALETTE_PTR+(word)32, bank_bram_palettes, ptr_bram_palettes, palette_loaded);
    // Tested

#ifndef __FLOOR
    // TILE INITIALIZATION 

    // Initialize the bram heap for tile loading.
    heap_address bram_floor_tile = heap_segment_bram(
        HEAP_SEGMENT_BRAM_TILES,
        heap_bram_pack(33,(heap_ptr)0xA000),
        heap_size_pack(0x2000*8)
        );

    // gotoxy(0, 10);

    // Loading the graphics in main banked memory.
    for(i=0; i<TILE_TYPES;i++) {
        tile_load(TileDB[i]);
    }

    // Now we activate the tile mode.
    for(i=0;i<TILE_TYPES;i++) {
        tile_cpy_vram_from_bram(TileDB[i]);
    }


    vera_layer0_mode_tile( 
        FLOOR_MAP_BANK_VRAM, FLOOR_MAP_OFFSET_VRAM, 
        0, 0x2000, 
        VERA_LAYER_WIDTH_64, VERA_LAYER_HEIGHT_64,
        VERA_TILEBASE_WIDTH_16, VERA_TILEBASE_HEIGHT_16, 
        VERA_LAYER_COLOR_DEPTH_8BPP
    );


    tile_background();

    vera_layer0_show();
    vera_layer1_show();

#endif





    // Initialize the bram heap for sprite loading.
    heap_bram_packed bram_sprites = heap_segment_bram(
        HEAP_SEGMENT_BRAM_SPRITES,
        heap_bram_pack(HEAP_SEGMENT_BRAM_SPRITES_BANK, (heap_ptr)0xA000),
        heap_size_pack(0x2000 * HEAP_SEGMENT_BRAM_SPRITES_BANKS)
    );

    // Initialize the bram heap for dynamic allocation of the entities.
    heap_bram_packed bram_entities = heap_segment_bram(
        HEAP_SEGMENT_BRAM_ENTITIES,
        heap_bram_pack(HEAP_SEGMENT_BRAM_ENTITIES_BANK, (heap_ptr)0xA000),
        heap_size_pack(0x2000 * HEAP_SEGMENT_BRAM_ENTITIES_BANKS)
    );

    // gotoxy(0, 0);
    // printf("bram_entities = %x, ", bram_entities);
    // printf("bram_sprites = %x, ", bram_sprites);
    vera_sprites_show();

    // Loading the graphics in main banked memory.
    for (byte i = 0; i < SPRITE_TYPES;i++) {
        sprite_load(SpriteDB[i]);
    }

    // Now we activate the tile mode.
    for (byte i = 0;i < SPRITE_TYPES;i++) {
        sprite_cpy_vram_from_bram(SpriteDB[i]);
    }

    // for (byte sprite = 64;sprite < 64 + 10;sprite++) {
    //     sprite_create(SpriteDB[3], sprite); // Player bullets
    // }



    // Initialize stage

    StageInit();

    // gotoxy(0,0);

    vera_display_set_hstart(2);
    vera_display_set_hstop(158);
    vera_display_set_vstart(2);
    vera_display_set_vstop(236);

    while(!getin());

    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC;
    // vera_sprites_collision_on();
    CLI();


    cx16_mouse_config(0xFF, 1);

    while (!getin()) {
        // SEI();
        // gotoxy(0,0);
        // ht_display(ht_collision, ht_size_collision);
        // CLI();
    }; 

    // Back to basic.
    bank_set_brom(CX16_ROM_BASIC);

}

