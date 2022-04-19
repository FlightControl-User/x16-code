// Space flight engine for a space game written in kickc for the Commander X16.

#pragma link("equinoxe.ld")

#pragma encoding(petscii_mixed)

#pragma var_model(mem)

// #define __FLOOR
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



inline void Logic(void) {
    LogicPlayer();
    LogicBullets();
    LogicEnemies();
}

unsigned int collisions = 0;

//VSYNC Interrupt Routine

__interrupt(rom_sys_cx16) void irq_vsync() {

    // This is essential, the BRAM bank is set to 0, because the sprite control blocks are located between address A8000 till BFFF.
    bram_bank_t oldbank = bank_get_bram();

    bank_set_bram(0);
    bank_set_brom(CX16_ROM_KERNAL);

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

#ifdef __FLIGHT

    #ifdef debug_scanlines
    vera_display_set_border_color(3);
    #endif

    ht_reset(&ht_collision);

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

           
    vera_display_set_border_color(2);

    #ifdef debug_scanlines
    vera_display_set_border_color(9);
    #endif

    // Check player bullet collisions

    if(stage.sprite_bullet_count) {

        for(unsigned char gx=0; gx<640>>2; gx+=64>>2) {
            for(unsigned char gy=0; gy<480>>2; gy+=64>>2) {

                ht_key_t ht_key_bullet = grid_key(3, gx, gy);
                ht_index_t ht_index_bullet_init = ht_get(&ht_collision, ht_key_bullet);

                ht_key_t ht_key_enemy = grid_key(2, gx, gy);
                ht_index_t ht_index_enemy_init = ht_get(&ht_collision, ht_key_enemy);

                ht_index_t ht_index_bullet = ht_index_bullet_init;
                while(ht_index_bullet) {
                    unsigned char b = (unsigned char)ht_get_data(ht_index_bullet);

                    if(bullet.used[b] && bullet.side[b] == SIDE_PLAYER) {

                        signed int x_bullet = (signed int)WORD1(bullet.tx[b]);
                        signed int y_bullet = (signed int)WORD1(bullet.ty[b]);

                        unsigned char bullet_aabb_min_x = bullet.aabb_min_x[b];
                        unsigned char bullet_aabb_min_y = bullet.aabb_min_y[b];
                        unsigned char bullet_aabb_max_x = bullet.aabb_max_x[b];
                        unsigned char bullet_aabb_max_y = bullet.aabb_max_y[b];

                        ht_index_t ht_index_enemy = ht_index_enemy_init;
                        while(ht_index_enemy) {
                            unsigned char e = (unsigned char)ht_get_data(ht_index_enemy);

                            if(enemy.used[e]) {

                                signed int x_enemy = (signed int)WORD1(enemy.tx[e]);
                                signed int y_enemy = (signed int)WORD1(enemy.ty[e]);

                                unsigned char enemy_aabb_min_x = enemy.aabb_min_x[e];
                                unsigned char enemy_aabb_min_y = enemy.aabb_min_y[e];
                                unsigned char enemy_aabb_max_x = enemy.aabb_max_x[e];
                                unsigned char enemy_aabb_max_y = enemy.aabb_max_y[e];

                                if(x_bullet+bullet_aabb_min_x > x_enemy+enemy_aabb_max_x || 
                                    y_bullet+bullet_aabb_min_y > y_enemy+enemy_aabb_max_y || 
                                    x_bullet+bullet_aabb_max_x < x_enemy+enemy_aabb_min_x || 
                                    y_bullet+bullet_aabb_max_y < y_enemy+enemy_aabb_min_y) {
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



#endif

#ifdef __FLOOR

    vera_display_set_border_color(8);

    // We only will execute the scroll logic when a scroll action needs to be done.
    if(!floor_scroll_action--) {
        floor_scroll_action = 4;

        // Check every 16 floor_scroll_vertical the logic to initialize the scroll variables.
        if(!(BYTE0(floor_scroll_vertical) % 16) ) {

            // If the floor_scroll_vertical position has reached it's top position,
            // then we flip to the start position, which is 32 rows * 16 pixels height per row, which is 512.
            // Note that the player won't notice, as the tiles that were painted at each row,
            // were copied to the row + 32 ...
            if(!floor_scroll_vertical) {
                floor_scroll_vertical = FLOOR_SCROLL_START;
            }

            if(!floor_tile_row) {
                floor_tile_row = FLOOR_TILE_ROW_31;
                floor_cpy_map_dst = FLOOR_CPY_MAP_63;
                floor_cpy_map_src = FLOOR_CPY_MAP_31;
            } else {
                floor_tile_row--;
            }

            floor_tile_column = FLOOR_TILE_COLUMN_16;
        }

        // There are 16 scroll iterations as the height of the tiles is 16 pixels.
        // Each segment is 4 tiles on the x axis, so the total amount of tiles are 64 tiles of 16 pixels wide.
        // So there are 16 segments to be painted on each row.
        // That allows to paint a segment per scroll action!
        // We decrease the column for tiling, and ensure that we never go above 16.
        floor_tile_column--;
        floor_tile_column %= 16;

        // We paint from bottom to top. Each paint segment is 64 pixels on the y axis, so we must paint every 4 rows.
        // We paint when the row is the bottom row of the paint segment, so row 3. Row 0 is the top row of the segment.
        if(floor_tile_row%4==3) {
            floor_paint_segment(floor_tile_row, floor_tile_column);
        }

        // Now that the segment for the respective floor_tile_row and floor_tile_column has been painted,
        // we can draw a cell from the painted segment. Note that when floor_tile_row is 0, 1 or 2,
        // all paint segments will have been painted on the paint buffer, and the tiling will just pick
        // row 2, 1 or 0 from the paint segment...
        vera_tile_cell(floor_tile_row, floor_tile_column);

        // This handles the smooth scrolling and enables seamless frame flipping.
        // Copy each cell of the current floor_tile_row, that has been tiled, to the bottom floor_tile_row (source floor_tile_row + 32),
        // so that when the scrolling position reaches 0, the scrolling position can be safely repositioned
        // to 16 lines * 32 rows = 512, and the display will look exactly the same!
        // In order to not blow up the performance of the frames, we do a copy of 1/16th of a floor_tile_row when
        // the scrolling even happens, so that we don't below up the frame performance. There is very
        // limited time painting each frame!
        floor_cpy_map_src-=4*2;
        floor_cpy_map_dst-=4*2;
        if(floor_tile_row<=FLOOR_TILE_ROW_31) {
            memcpy8_vram_vram(FLOOR_MAP_BANK_VRAM, floor_cpy_map_dst, FLOOR_MAP_BANK_VRAM, floor_cpy_map_src, 8*2); // Copy one cell.
        }

        // Now we set the vertical scroll to the required scroll position.
        vera_layer0_set_vertical_scroll(floor_scroll_vertical);
        floor_scroll_vertical--;
        
    }

#endif

    // vera_layer_set_horizontal_scroll(0, (unsigned int)cx16_mousex*2);

    #ifdef debug_scanlines
    vera_display_set_border_color(0);
    #endif

    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
    // vera_sprites_collision_on();

    // vera_sprite_buffer_write(sprite_buffer);

    bank_set_bram(oldbank);
    // gotoxy(curx, cury);
}

void main() {

    // We are going to use only the kernal on the X16.
    bank_set_brom(CX16_ROM_KERNAL);

    ht_init(&ht_collision);

    // We create the heap blocks in BRAM using the Fixed Block Heap Memory Manager.
    heap_segment_base(bins, 32, (heap_handle_ptr)0xA000); // We set the heap to start in BRAM, bank 32. 
    heap_segment_define(bins, bin64, 64, 128, 64*128);
    heap_segment_define(bins, bin128, 128, 64, 128*364);
    heap_segment_define(bins, bin256, 256, 64, 256*64);
    heap_segment_define(bins, bin512, 512, 64, 512*64);
    heap_segment_define(bins, bin1024, 1024, 63, 1024*63);

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
    // SpriteControlEnemies                                   00:A800 - 00:B2FF
    // SpriteControlBullets                                   00:B300 - 00:B87F
    // SpriteControlP²layer                                    00:B900 - 00:B987
    // SpriteControlEngine                                    00:BA00 - 00:BA1F
    // Palette                                                3F:A000 - 3F:BFFF

    petscii();
    // vera_layer1_show();

    // vera_layer0_mode_bitmap( 
    //     0, 0x0000, 
    //     VERA_TILEBASE_WIDTH_16,
    //     VERA_LAYER_COLOR_DEPTH_1BPP
    // );


    // bitmap_init(0, 0x00000);
    // bitmap_clear();

    // for(unsigned int x=0; x<640; x+=64) {
    //     for(unsigned int y=0; y<480; y+=4) {
    //         bitmap_plot(x, y, 1);
    //     }
    // }

    // for(unsigned int y=0; y<480; y+=64) {
    //     for(unsigned int x=0; x<640; x+=4) {
    //         bitmap_plot(x, y, 1);
    //     }
    // }

    // Allocate the segment for the tiles in vram.
    const word VRAM_FLOOR_MAP_SIZE = 64*64*2;
    const word VRAM_FLOOR_TILE_SIZE = TILE_FLOOR_COUNT*32*32/2;

#ifdef __PALETTE
    // Load the palettes in main banked memory.
    heap_handle handle_bram_palettes = {63, (bram_ptr_t)0xA000}; // size = 0x2000;

    unsigned int palette_loaded = 0;

    unsigned int floor_palette_loaded = load_file(1, 8, 0, FILE_PALETTES_FLOOR01, handle_bram_palettes.bank, handle_bram_palettes.ptr+palette_loaded);
    if(!floor_palette_loaded) printf("error file_palettes");
    palette_loaded += floor_palette_loaded;

    unsigned int sprite_palette_loaded = load_file(1, 8, 0, FILE_PALETTES_SPRITE01, handle_bram_palettes.bank, handle_bram_palettes.ptr+palette_loaded);
    if(!sprite_palette_loaded) printf("error file_palettes");
    palette_loaded += sprite_palette_loaded;

    memcpy_vram_bram(VERA_PALETTE_BANK, (word)VERA_PALETTE_PTR+(word)32, handle_bram_palettes.bank, handle_bram_palettes.ptr, palette_loaded);

#endif

#ifdef __FLIGHT

    // Loading the sprites in bram.
    for (byte i = 0; i < SPRITE_TYPES;i++) {
        sprite_load(SpriteDB[i]);
    }

    // Now we copy the sprites from bram to vram.
    heap_handle handle_vram_sprites = {1, (heap_handle_ptr)0x0000}; // size = 0xB000;
    for (byte i = 0;i < SPRITE_TYPES;i++) {
        sprite_cpy_vram_from_bram(SpriteDB[i], &handle_vram_sprites);
    }

#endif

    // Tested

#ifdef __FLOOR
    // TILE INITIALIZATION 

    // Loading the graphics in main banked memory.
    for(unsigned char type=0; type<TILE_TYPES; type++) {
        tile_load(TileDB[type]);
    }

    while(!getin());
    clrscr();

    // TODO: rework handle_vram_tiles to const
    heap_handle handle_vram_tiles = {0, (heap_handle_ptr)FLOOR_TILE_OFFSET_VRAM}; // size = 0xB000;
    for(unsigned char type=0; type<TILE_TYPES; type++) {
        tile_cpy_vram_from_bram(TileDB[type], handle_vram_tiles);
    }

    while(!getin());
    clrscr();

    vera_layer0_mode_tile( 
        FLOOR_MAP_BANK_VRAM, (vram_offset_t)FLOOR_MAP_OFFSET_VRAM, 
        FLOOR_TILE_BANK_VRAM, (vram_offset_t)FLOOR_TILE_OFFSET_VRAM, 
        VERA_LAYER_WIDTH_64, VERA_LAYER_HEIGHT_64,
        VERA_TILEBASE_WIDTH_16, VERA_TILEBASE_HEIGHT_16, 
        VERA_LAYER_COLOR_DEPTH_8BPP
    );

    vera_layer0_show();
    vera_layer1_show();

    vera_tile_clear();
    tile_background();

    floor_tile_column = 16;
    floor_tile_row = 31;

#endif

    vera_sprites_show();

    bank_set_bram(0);

    // Initialize stage

#ifdef __FLIGHT

    StageInit();

#endif

    #ifdef debug_scanlines
    // Set border to measure scan lines
    vera_display_set_hstart(2);
    vera_display_set_hstop(158);
    vera_display_set_vstart(2);
    vera_display_set_vstop(236);
    #endif

    while(!getin());
    clrscr();

    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC;
    // vera_sprites_collision_on();
    CLI();

    cx16_mouse_config(0xFF, 80, 60);

    char cx16_mouse_status = cx16_mouse_get();
    game.prev_mousex = cx16_mousex;
    game.prev_mousey = cx16_mousey;
    game.curr_mousex = cx16_mousex;
    game.curr_mousey = cx16_mousey;

    vera_layer0_set_vertical_scroll(0);

    while (!getin()) {
        // gotoxy(0,0);
        // grid_print(&ht_collision);
        // SEI();
        // printf("floor_scroll_vertical:%02u\n",floor_scroll_vertical);
        // CLI();
    }; 

    // Back to basic.
    bank_set_brom(CX16_ROM_BASIC);

}

