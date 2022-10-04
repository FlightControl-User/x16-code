// Space flight engine for a space game written in kickc for the Commander X16.

#pragma link("equinoxe.ld")
#pragma encoding(petscii_mixed)
// #pragma cpu(mos6502)


#pragma var_model(zp, global_mem, local_zp)

// #pragma var_model(mem)

#include "equinoxe-defines.h"

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <6502.h>
#include <kernal.h>
#include <printf.h>
#include <division.h>
#include <mos6522.h>
#include <multiply.h>

#include <cx16.h>
#include <ht.h>
#include <lru-cache.h>

#pragma var_model(mem)

#include <cx16-veraheap.h>
#include "equinoxe-palette.h"
#include <cx16-veralib.h>
#include <cx16-mouse.h>
#include <cx16-conio.h>
#include <cx16-heap-bram-fb.h>
#include "equinoxe-types.h"
#include "equinoxe-stage.h"
#include "equinoxe-flightengine.h"

#ifdef __FLOOR
#include "equinoxe-floorengine.h"
#endif

#include "equinoxe-bullet.h"
#include "equinoxe-fighters.h"
#include "equinoxe-enemy.h"
#include "equinoxe-player.h"
#include "levels/equinoxe-levels.h"
#include "equinoxe.h"


#include "equinoxe-petscii.c"

equinoxe_game_t game;

#pragma data_seg(Heap)

heap_structure_t heap; const heap_structure_t* heap_bram_blocked = &heap;

fb_heap_segment_t heap_64; const fb_heap_segment_t* bin64 = &heap_64;
fb_heap_segment_t heap_128; const fb_heap_segment_t* bin128 = &heap_128;
fb_heap_segment_t heap_256; const fb_heap_segment_t* bin256 = &heap_256;
fb_heap_segment_t heap_512; const fb_heap_segment_t* bin512 = &heap_512;
fb_heap_segment_t heap_1024; const fb_heap_segment_t* bin1024 = &heap_1024;
fb_heap_segment_t heap_2048; const fb_heap_segment_t* bin2048 = &heap_2048;

#pragma data_seg(Data)

#ifdef __FLOOR

void equinoxe_scrollfloor() {

    // We only will execute the scroll logic when a scroll action needs to be done.
    if(!floor_scroll_action--) {
        floor_scroll_action = 1;

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

}
#endif

#ifdef __COLLISION
void equinoxe_collision() {

    if(stage.sprite_bullet_count) {

        // For each cell on the grid, check the collisions that are relevant to the objects.
        // We reduce the resolution with 2 bits to the right, so we divide by 4.
        // So the total screen dimension is 160x120.
        // Each "grid" cell is 16x16 pixels.
        // Note that this resolution reduction is ONLY for the spacial grid map, to base
        // the collision calculations on 8 bits instead of 16 bit numbers.

        bank_push_bram(); bank_set_bram(fe.bram_bank);

        for(unsigned char gx=0; gx<640>>(2+4); gx+=64>>(2+4)) {
            for(unsigned char gy=0; gy<480>>2; gy+=64>>2) {

                ht_key_t ht_key_bullet = grid_key(3, gx, gy);
                ht_index_t ht_index_bullet_init = ht_get(&ht_collision, ht_key_bullet);

                if(ht_index_bullet_init) {

                    ht_key_t ht_key_enemy = grid_key(2, gx, gy);
                    ht_index_t ht_index_enemy_init = ht_get(&ht_collision, ht_key_enemy);

                    ht_key_t ht_key_player = grid_key(1, gx, gy);
                    ht_index_t ht_index_player_init = ht_get(&ht_collision, ht_key_player);

                    ht_index_t ht_index_bullet = ht_index_bullet_init;
                    while(ht_index_bullet) {
                        unsigned char b = (unsigned char)ht_get_data(ht_index_bullet);

                        if(bullet.used[b]) {

                            signed int x_bullet = (signed int)WORD1(bullet.tx[b]);
                            signed int y_bullet = (signed int)WORD1(bullet.ty[b]);

                            unsigned char bc = bullet.sprite[b]; // Which sprite is it in the cache...
                            unsigned char bco = bc*16;

                            // unsigned char bullet_aabb_min_x = sprite_cache.aabb[bco];
                            // unsigned char bullet_aabb_min_y = sprite_cache.aabb[bco+1];
                            // unsigned char bullet_aabb_max_x = sprite_cache.aabb[bco+2];
                            // unsigned char bullet_aabb_max_y = sprite_cache.aabb[bco+3];

                            if(bullet.side[b] == SIDE_PLAYER) {

                                ht_index_t ht_index_enemy = ht_index_enemy_init;
                                while(ht_index_enemy) {
                                    unsigned char e = (unsigned char)ht_get_data(ht_index_enemy);

                                    if(enemy.used[e]) {

                                        signed int x_enemy = (signed int)WORD1(enemy.tx[e]);
                                        signed int y_enemy = (signed int)WORD1(enemy.ty[e]);

                                        unsigned char ec = enemy.sprite[e]; // Which sprite is it in the cache...
                                        unsigned char eco = ec*16;

                                        // unsigned char enemy_aabb_min_x = sprite_cache.aabb[eco];
                                        // unsigned char enemy_aabb_min_y = sprite_cache.aabb[eco+1];
                                        // unsigned char enemy_aabb_max_x = sprite_cache.aabb[eco+2];
                                        // unsigned char enemy_aabb_max_y = sprite_cache.aabb[eco+3];

                                        if(x_bullet+sprite_cache.aabb[bco] > x_enemy+sprite_cache.aabb[eco+2] || 
                                           y_bullet+sprite_cache.aabb[bco+1] > y_enemy+sprite_cache.aabb[eco+3] || 
                                           x_bullet+sprite_cache.aabb[bco+2] < x_enemy+sprite_cache.aabb[eco] || 
                                           y_bullet+sprite_cache.aabb[bco+3] < y_enemy+sprite_cache.aabb[eco+1]) {
                                        } else {
                                            bullet_remove(b);
                                            stage_enemy_hit(enemy.wave[e], e, b);
                                            break;
                                        }
                                    }
                                    ht_index_enemy = ht_get_next(ht_index_enemy);
                                }
                            }

                            if(bullet.side[b] == SIDE_ENEMY) {

                                ht_index_t ht_index_player = ht_index_player_init;
                                while(ht_index_player) {

                                    unsigned char p = (unsigned char)ht_get_data(ht_index_player);
                                    if(player.used[p]) {

                                        signed int x_player = (signed int)WORD1(player.tx[p]);
                                        signed int y_player = (signed int)WORD1(player.ty[p]);

                                        unsigned char pc = player.sprite[p]; // Which sprite is it in the cache...
                                        unsigned char pco = pc*16;

                                        // unsigned char player_aabb_min_x = sprite_cache.aabb[pco];
                                        // unsigned char player_aabb_min_y = sprite_cache.aabb[pco+1];
                                        // unsigned char player_aabb_max_x = sprite_cache.aabb[pco+2];
                                        // unsigned char player_aabb_max_y = sprite_cache.aabb[pco+3];

                                        if(x_bullet+sprite_cache.aabb[bco] > x_player+sprite_cache.aabb[pco+2] || 
                                            y_bullet+sprite_cache.aabb[bco+1] > y_player+sprite_cache.aabb[pco+3] || 
                                            x_bullet+sprite_cache.aabb[bco+2] < x_player+sprite_cache.aabb[pco] || 
                                            y_bullet+sprite_cache.aabb[bco+3] < y_player+sprite_cache.aabb[pco+1]) {
                                        } else {
                                            bullet_remove(b);
                                            player_remove(p, b);
                                            break;
                                        }
                                    }
                                    ht_index_player = ht_get_next(ht_index_player);
                                }
                            }

                        }
                        ht_index_bullet = ht_get_next(ht_index_bullet);
                    }
                }
            }   
        }
        bank_pull_bram();
    }
}
#endif

//VSYNC Interrupt Routine

#ifndef __NOVSYNC
__interrupt(rom_sys_cx16) void irq_vsync() {
#else
void irq_vsync() {
#endif

    // This is essential, the BRAM bank is set to 0, because the sprite control blocks are located between address A8000 till BFFF.
    bank_set_brom(CX16_ROM_KERNAL);
    bank_push_set_bram(255);

#ifdef __VERAHEAP_DEBUG
    gotoxy(0, 0);
    vera_heap_dump(VERA_HEAP_SEGMENT_SPRITES, 0, 0);
    for(unsigned char i=0;i<25;i++) {
        gotoxy(0, 30+i);
        clearline();
    }
    gotoxy(0,30);
#endif

#ifdef __ENGINE_DEBUG

    char stack_entry;
    {
    char x = wherex();
    char y = wherey();
    gotoxy(0,58);

    __mem char stack_max = 0;
    __mem char stack_min = 255;
    #ifndef __INTELLISENSE__
        asm {
            tsx
            stx stack_entry
        }
    #endif
    printf("stack %x", stack_entry);
    if(stack_min>stack_entry) stack_min=stack_entry;
    printf(", min %x", stack_min);
    if(stack_max<stack_entry) stack_max=stack_entry;
    printf(", max %x", stack_max);
    printf(", bram %x", bank_get_bram());
    gotoxy(x,y);
    }

#endif

#ifdef __FLOOR
    #ifdef __CPULINES
    vera_display_set_border_color(GREY);
    #endif
    equinoxe_scrollfloor();
#endif

#ifdef __FLIGHT

    #ifdef __CPULINES
        vera_display_set_border_color(BLUE);
    #endif

    ht_reset(&ht_collision);

    // cx16_mouse_scan();
    cx16_mouse_get();

#ifdef __STAGE
    if(!(game.ticksync & 0x01)) {
        stage_logic();
        game.tickstage++;
    }
    game.ticksync++;
#endif

    #ifdef __PLAYER
        #ifdef __CPULINES
            vera_display_set_border_color(GREEN);
        #endif
        player_logic();
    #endif

    #ifdef __BULLET
        #ifdef __CPULINES
            vera_display_set_border_color(CYAN);
        #endif
        LogicBullets();
    #endif


    #ifdef __ENEMY
        #ifdef __CPULINES
            vera_display_set_border_color(RED);
        #endif
        LogicEnemies();
    #endif


    #ifdef __COLLISION
        #ifdef __CPULINES
            vera_display_set_border_color(CYAN);
        #endif
        equinoxe_collision();
    #endif // __COLLISION


    #ifdef __CPULINES
        vera_display_set_border_color(CYAN);
    #endif

    #ifdef __ENEMY
        #ifdef __CPULINES
            vera_display_set_border_color(RED);
        #endif
        enemies_resource();
    #endif

    #ifdef __BULLET
        #ifdef __CPULINES
            vera_display_set_border_color(CYAN);
        #endif
        // bullets_resource();
    #endif


    #ifdef __PLAYER
        #ifdef __CPULINES
            vera_display_set_border_color(GREEN);
        #endif
        // player_resource();
    #endif

#endif // __FLIGHT

#ifndef __NOVSYNC
    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
#endif

#ifdef __ENGINE_DEBUG

    #ifdef __CPULINES
        vera_display_set_border_color(LIGHT_GREY);
    #endif
        __mem char stack_diff = 0;
        __mem char stack_diff_max = 0;
        __mem char stack_diff_min = 255;

        {
        char x = wherex();
        char y = wherey();
        gotoxy(0,59);

        char stack_exit;
        __mem char stack_max = 0;
        __mem char stack_min = 255;
    #ifndef __INTELLISENSE__
        asm {
            tsx
            stx stack_exit
        }
    #endif
        printf("stack %x", stack_exit);
        if(stack_min>stack_exit) stack_min=stack_exit;
        printf(", min %x", stack_min);
        if(stack_max<stack_exit) stack_max=stack_exit;
        printf(", max %x", stack_max);
        printf(", bram %x", bank_get_bram());
        stack_diff = stack_entry - stack_exit;
        if(stack_diff_min>stack_diff) stack_diff_min = stack_diff;
        if(stack_diff_max<stack_diff) stack_diff_max = stack_diff;

        printf(", diff %u", stack_entry - stack_exit);
        printf(", min %u", stack_diff_min);
        printf(", max %u", stack_diff_max);

        gotoxy(0,57);
        printf("player %2x, %2x bullet %2x, %2x enemy %2x, %2x ", stage.sprite_player, stage.sprite_player_count, stage.sprite_bullet, stage.sprite_bullet_count, stage.sprite_enemy, stage.sprite_enemy_count);

        gotoxy(0,56);
        printf("enemy xor %x size %05u", stage.enemy_xor, sizeof(fe_enemy_t));

        gotoxy(x,y);
        }
#endif // __ENGINE_DEBUG

#ifdef __LRU_CACHE_DEBUG
    gotoxy(0, 30);
    lru_cache_display(&sprite_cache_vram);
#endif

#ifdef __VERAHEAP_DEBUG
    gotoxy(40, 0);
    vera_heap_dump(VERA_HEAP_SEGMENT_SPRITES, 40, 0);
#endif


    bank_pull_bram();

    #ifdef __CPULINES
        vera_display_set_border_color(BLACK);
    #endif
}
#pragma var_model(mem)

void main() {

    // We are going to use only the kernal on the X16.
    bank_set_brom(CX16_ROM_KERNAL);

    petscii();
    scroll(1);

    ht_init(&ht_collision);

    #ifdef __DEBUG_HEAP_BLOCKED
    clrscr();
    #endif
    // We create the heap blocks in BRAM using the Fixed Block Heap Memory Manager.
    heap_segment_base(heap_bram_blocked, 8, (heap_bram_fb_ptr_t)0xA000); // We set the heap to start in BRAM, bank 8. 
    heap_segment_define(heap_bram_blocked, bin64, 64, 128, 64*128);
    heap_segment_define(heap_bram_blocked, bin128, 128, 64, 128*64);
    // heap_segment_define(heap_bram_blocked, bin256, 256, 64, 256*64);
    heap_segment_define(heap_bram_blocked, bin512, 512, 127, 512*127);
    // heap_segment_define(heap_bram_blocked, bin1024, 1024, 20, 1024*64);
    heap_segment_define(heap_bram_blocked, bin2048, 2048, 20, 2048*96);
    
    vera_heap_bram_bank_init(BRAM_VERAHEAP);

    vera_heap_segment_init(VERA_HEAP_SEGMENT_TILES, 0, 0x2000, 0, 0xA000); // FLOOR_TILE segment for tiles of various sizes and types
    vera_heap_segment_init(VERA_HEAP_SEGMENT_SPRITES, 0, 0xA000, 1, 0xB000); // SPRITES segment for sprites of various sizes

#ifdef __PALETTE
    palette_init(BRAM_PALETTE);
    palette_load(0); // Todo, what is this level thing ... All palettes to be loaded.
#endif

#ifdef __FLIGHT
    fe_init(BRAM_FLIGHTENGINE);
#endif


#if defined(__FLIGHT) || defined(__FLOOR)

    // Initialize stage
    stage_init(BRAM_STAGE);
#endif

    // Allocate the segment for the tiles in vram.
    const word VRAM_FLOOR_MAP_SIZE = 64*64*2;
    const word VRAM_FLOOR_TILE_SIZE = TILE_FLOOR_COUNT*32*32/2;

#ifdef __FLOOR
    // TILE INITIALIZATION 

    // Loading the graphics in main banked memory.
    for(unsigned char type=0; type<TILE_TYPES; type++) {
        tile_load(TileDB[type]);
    }

    while(!getin());
    clrscr();

    for(unsigned char type=0; type<TILE_TYPES; type++) {
        tile_vram_allocate(TileDB[type], VERA_HEAP_SEGMENT_TILES);
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

#ifdef __DEBUG_HEAP_BRAM
    clrscr();
    heap_print(heap_bram_blocked);
    while(!getin());
#endif

    vera_sprites_show();

#ifdef __CPULINES
    // Set border to measure scan lines
    vera_display_set_hstart(1);
    vera_display_set_hstop(159);
    vera_display_set_vstart(0);
    vera_display_set_vstop(238);
#endif

    scroll(0);

    clrscr();

#if defined(__FLIGHT) || defined(__FLOOR)
    // Initialize stage
    stage_reset();
    stage_logic();

#endif

    palette64_use(0);

    while(!getin());

#ifndef __NOVSYNC
    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC | 0x80;
    *VERA_IRQLINE_L = 0xFF;
    CLI();
#endif

    cx16_mouse_config(0xFF, 80, 60);
    // memset_vram(1, 0x0000, 0, 16);

    cx16_mouse_get();

    vera_layer0_set_vertical_scroll(0);

    while (!getin()) {
        #ifdef __NOVSYNC
            irq_vsync();
        #endif
        #ifdef __DEBUG_SPRITE_CACHE
            SEI();
            fe_sprite_debug();
            CLI();
        #endif

        #ifdef __NOVSYNC
            while(!getin());
        #endif
    }; 

    // Back to basic.
    bank_set_brom(CX16_ROM_BASIC);

}

