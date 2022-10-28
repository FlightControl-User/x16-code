// Space flight engine for a space game written in kickc for the Commander X16.

#pragma link("equinoxe.ld")
#pragma encoding(petscii_mixed)
// #pragma cpu(mos6502)


#pragma var_model(mem, global_mem)

// #pragma var_model(mem)

#define __MAIN

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

#include <ht.h>
#include <lru-cache.h>

#pragma var_model(mem)

#include <cx16.h>
#include <cx16-conio.h>
#include <cx16-heap-bram-fb.h>
#include <cx16-veraheap.h>
#include <cx16-veralib.h>
#include <cx16-mouse.h>

#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-flightengine.h"

#ifdef __FLOOR
#include "equinoxe-floorengine.h"
#endif

#include "equinoxe-palette.h"
#include "equinoxe-stage.h"
#include "equinoxe-bullet.h"
#include "equinoxe-fighters.h"
#include "equinoxe-enemy.h"
#include "equinoxe-player.h"
#include "equinoxe-tower.h"
#include "equinoxe-levels.h"


#include "equinoxe-petscii.c"



#pragma data_seg(Heap)

heap_structure_t heap; const heap_structure_t* heap_bram_blocked = &heap;

fb_heap_segment_t heap_64; const fb_heap_segment_t* bin64 = &heap_64;
fb_heap_segment_t heap_128; const fb_heap_segment_t* bin128 = &heap_128;
fb_heap_segment_t heap_256; const fb_heap_segment_t* bin256 = &heap_256;
fb_heap_segment_t heap_512; const fb_heap_segment_t* bin512 = &heap_512;
fb_heap_segment_t heap_1024; const fb_heap_segment_t* bin1024 = &heap_1024;
fb_heap_segment_t heap_1152; const fb_heap_segment_t* bin1152 = &heap_1152;
fb_heap_segment_t heap_2048; const fb_heap_segment_t* bin2048 = &heap_2048;



#pragma data_seg(Data)

equinoxe_game_t game = {0, 0, 0, 2, 0};

void equinoxe_init() {

#ifdef __PLAYER
    player_init();
#endif

#ifdef __ENEMY
    enemy_init();
#endif

#ifdef __BULLET
    bullet_init();
#endif

    unsigned bytes = 0;

	memset(&stage, 0, sizeof(stage_t));
    animate_init();
    
    bytes = fload_bram(1, 8, 2, "levels.bin", BRAM_LEVELS, (bram_ptr_t) 0xA000);
    bytes = fload_bram(1, 8, 2, "sprites.bin", BRAM_SPRITE_CONTROL, (bram_ptr_t)0xA000);
    bytes = fload_bram(1, 8, 2, "floors.bin", BRAM_FLOOR_CONTROL, (bram_ptr_t)0xA000);

    // Initialize the cache in vram for the sprite animations.
    lru_cache_init(&sprite_cache_vram);

}

volatile    unsigned char floor_tile_row = 0;
volatile    unsigned char floor_tile_column = 0;


#ifdef __FLOOR
void equinoxe_scrollfloor() {


    // We only will execute the scroll logic when a scroll action needs to be done.
    if(!game.screen_vscroll_wait--) {
        game.screen_vscroll_wait = 4;

        floor_tile_row = (game.screen_vscroll-16) / 16;
        floor_tile_row %= 32;

        // There are 16 scroll iterations as the height of the tiles is 16 pixels.
        // Each segment is 4 tiles on the x axis, so the total amount of tiles are 64 tiles of 16 pixels wide.
        // So there are 16 segments to be painted on each row.
        // That allows to paint a segment per scroll action!
        // We decrease the column for tiling, and ensure that we never go above 16.
        floor_tile_column = (game.screen_vscroll-16) % 16;

        // We paint from bottom to top. Each paint segment is 64 pixels on the y axis, so we must paint every 4 rows.
        // We paint when the row is the bottom row of the paint segment, so row 3. Row 0 is the top row of the segment.
        if(floor_tile_row%4==3) {
            #ifdef __TOWER
                floor_paint(floor_tile_row/4, floor_tile_column);
                tower_paint(floor_tile_row/4, floor_tile_column);
            #else
                floor_paint(floor_tile_row/4, floor_tile_column);
            #endif
        }

        // Now that the segment for the respective floor_tile_row and floor_tile_column has been painted,
        // we can draw a cell from the painted segment. Note that when floor_tile_row is 0, 1 or 2,
        // all paint segments will have been painted on the paint buffer, and the tiling will just pick
        // row 2, 1 or 0 from the paint segment...
        floor_draw_row(0, stage.floor, floor_tile_row, floor_tile_column);
        #ifdef __LAYER1
        floor_draw_row(1, stage.towers, floor_tile_row, floor_tile_column);
        #endif

        #ifdef __TOWER
        tower_move();
        #endif

        // Now we set the vertical scroll to the required scroll position.
        vera_layer0_set_vertical_scroll(game.screen_vscroll);
        #ifdef __LAYER1
        vera_layer1_set_vertical_scroll(game.screen_vscroll);
        #endif
        game.screen_vscroll--;
    }
}
#endif

#ifdef __COLLISION

/**
 * @brief Equinoxe main collision detection routine.
 * 
 * A spacial grid approach is implemented in the equinoxe gaming engine, to ensure 
 * blazing performance during collision detection between all the game objects on the screen.  
 * 
 * Previously, at each frame, we have executed the during the object logic, 
 * the movement calculations and image animations for the screen.
 * As part of this object logic, we have also created a spacial grid, using the grid_insert routines.
 * The grid_ routines uses the routine set ht.h, which is a set of routines to create a has table.
 * 
 * This equinoxe_collision detection routine, uses the created spacial grid to efficiently compare the positions of each
 * object relative to each other, and will only compare those objects which have opposite party sides.
 * 
 * Each cell in the spacial grid is 64x64 pixels wide in terms of screen dimensions.
 * The dimensions of our screen is 640x480, so there are 10 spacial grid cells on the x axis and 8 spacial grid cells on the y axis.
 * For efficiency reasons to store the spacial grid into memory and to optimize the utilization of the byte architecture of the 6502, 
 * we reduced the spacial grid resolution with 2 bits to the right, so we divided by 4 both the x and y coordinates,
 * resulting in the spacial grid dimension to be 160x120. Now the spacial grid has table can
 * be built up using only byte values, not integers. So the x and y coordinate in the spacial grid can now be stored in 4 bits each,
 * where the x coordinate takes the lower nibble of the coordinate byte, and the y coordinate the higher nibble of the coordinate byte.
 * 
 * So the spacial grid coordinate system **is stored in a hash table** with the x and y coordinates as the key, which is one byte wide!
 * This results in a very fast calculation algorithm for the 6502, where searching through the has table only requires one byte to be hashed.
 * For further efficiency reasons, the has table implements for duplicate keys a linked list, where the links are stored in a pre-defined
 * array of again only byte sized indexes. Again very efficient for the 6502! the spacial grid uses only absolute addressiing,
 * so pointers are completely avoided, which results in fast processing on the 6502.
 * 
 * Because the coordinates in the spacial grid are they in the spacial grid hash table, 
 * each object stored in the grid cell will result in a linked list to be built up in the spacial grid hash table!
 * So again very efficient, as now we can take the first element of a spacial grid cell linked list, and iterate through that list to 
 * verify each object in that list!
 * 
 * The collision detection loops through each cell in the spacial grid. Thus, it will loop horizontally 10 cells and vertically 8 cells.
 * 80 cells in total, however this loop is very efficient as it is only on byte level.
 * 
 * During each spacial grid cell evaluation, it performs an outer and an inner loop, 
 * where it compares the positions and the properties of the objects in the spacial grid cell against each other 
 * using the linked list in the spacial grid hash table.
 * 
 * And it does it in a special way, so that no object will be compared twice! 
 * The outer loop will loop the complete linked list of the hashed grid cell.
 * The inner loop will only loop from the start position of the outer loop and taking the next element in that list as the start.
 * 
 * For example, consider we have in the spacial grid cell the following objects A, B, C, D, E.
 * Then the outer loop will loop from A to E, while the inner loop will take for each element of the outer loop the next starting position.
 * So it will loop as follows:
 * 
 *   | LOOP ITERATION | 1       | 2     | 3   | 4 |
 *   | -------------: | :-----: | :---: | :-: | - |
 *   | OUTER LOOP     | A       | B     | C   | D |
 *   | INNER LOOP     | B C D E | C D E | D E | E |
 *  
 * This results in the minimal sets of objects to be compared witḣ each other, and thus, the most optimizal performance!
 * 
 * On top of this comparison the properties of each object are evaluated. Each object as a coalition side, 
 * which can be SIDE_FRIENDLY or SIDE_ENEMY. The game setup will only require objects to be compared with different coalitions.
 * So objects of the same coalition are never compared. SIDE_FRIENDLY is never compared with SIDE_FRIENDLY and SIDE_ENEMY is never compared with SIDE_ENEMY. 
 * 
 * Each object has an AABB or bounding box defined, that contains the dimensions of each object to be taken into account when comparing
 * the bounding box overlap between the objects in the spacial grid cell.
 * 
 * 
 */
void equinoxe_collision() {

    bank_push_set_bram(BRAM_FLIGHTENGINE);

    #ifdef __DEBUG_COLLISION
    #ifndef __CONIO_BSOUT
    clrscr();
    #endif
    #endif

    for(unsigned char gy=0; gy<(480>>2); gy+=64>>2) {

        for(unsigned char gx=0; gx<640>>(2+4); gx+=64>>(2+4)) {

            ht_key_t ht_key_outer = grid_key(gx, gy);
            ht_index_t ht_index_outer = ht_get(&ht_collision, ht_key_outer);

            while(ht_index_outer) {


                ht_index_t ht_index_inner = ht_get_next(ht_index_outer);

                // We only execute the outer calculations if there is an inner grid part, otherwise we just skip anyway.
                // This is done to make the collision detection as short as possible.
                if(ht_index_inner) {

                    unsigned char outer = (unsigned char)ht_get_data(ht_index_outer);

                    unsigned char outer_type = outer & COLLISION_MASK;
                    outer = outer & ~COLLISION_MASK;

                    unsigned int outer_x, outer_y;
                    unsigned int outer_min_x, outer_min_y, outer_max_x, outer_max_y;
                    unsigned char outer_side;
                    unsigned char outer_c, outer_co;

                    switch(outer_type) {
                        case COLLISION_BULLET:
                            outer_side = bullet.side[outer];
                            outer_x = (unsigned int)WORD1(bullet.tx[outer]);
                            outer_y = (unsigned int)WORD1(bullet.ty[outer]);
                            outer_c = bullet.sprite[outer]; // Which sprite is it in the cache...
                            break;    
                        case COLLISION_PLAYER:
                            outer_side = SIDE_PLAYER;
                            outer_x = (unsigned int)WORD1(player.tx[outer]);
                            outer_y = (unsigned int)WORD1(player.ty[outer]);
                            outer_c = player.sprite[outer]; // Which sprite is it in the cache...
                            break;    
                        case COLLISION_ENEMY:
                            outer_side = SIDE_ENEMY;
                            outer_x = (unsigned int)WORD1(enemy.tx[outer]);
                            outer_y = (unsigned int)WORD1(enemy.ty[outer]);
                            outer_c = enemy.sprite[outer]; // Which sprite is it in the cache...
                            break;    
                        case COLLISION_TOWER:
                            outer_side = towers.side[outer];
                            outer_x = (unsigned int)towers.tx[outer];
                            outer_y = (unsigned int)towers.ty[outer];
                            outer_c = towers.sprite[outer]; // Which sprite is it in the cache...
                            break;    
                    }

                    outer_co = outer_c*16;
                    outer_min_x = outer_x + sprite_cache.aabb[outer_co];
                    outer_min_y = outer_y + sprite_cache.aabb[outer_co+1];
                    outer_max_x = outer_x + sprite_cache.aabb[outer_co+2];
                    outer_max_y = outer_y + sprite_cache.aabb[outer_co+3];

                    while(ht_index_inner) {

                        unsigned char inner = (unsigned char)ht_get_data(ht_index_inner);
                        unsigned char inner_type = inner & COLLISION_MASK;
                        inner = inner & ~COLLISION_MASK;

                        unsigned int inner_x, inner_y; 
                        unsigned int inner_min_x, inner_min_y, inner_max_x, inner_max_y;
                        unsigned char inner_side;
                        unsigned char inner_c, inner_co;

                        switch(inner_type) {
                            case COLLISION_BULLET:
                                inner_side = bullet.side[inner];
                                inner_x = (unsigned int)WORD1(bullet.tx[inner]);
                                inner_y = (unsigned int)WORD1(bullet.ty[inner]);
                                inner_c = bullet.sprite[inner]; // Which sprite is it in the cache...
                                break;    
                            case COLLISION_PLAYER:
                                inner_side = SIDE_PLAYER;
                                inner_x = (unsigned int)WORD1(player.tx[inner]);
                                inner_y = (unsigned int)WORD1(player.ty[inner]);
                                inner_c = player.sprite[inner]; // Which sprite is it in the cache...
                                break;    
                            case COLLISION_ENEMY:
                                inner_side = SIDE_ENEMY;
                                inner_x = (unsigned int)WORD1(enemy.tx[inner]);
                                inner_y = (unsigned int)WORD1(enemy.ty[inner]);
                                inner_c = enemy.sprite[inner]; // Which sprite is it in the cache...
                                break;    
                            case COLLISION_TOWER:
                                inner_side = towers.side[inner];
                                inner_x = (unsigned int)towers.tx[inner];
                                inner_y = (unsigned int)towers.ty[inner];
                                inner_c = towers.sprite[inner]; // Which sprite is it in the cache...
                                break;    
                        }

                        inner_co = inner_c*16;
                        inner_min_x = inner_x + sprite_cache.aabb[inner_co];
                        inner_min_y = inner_y + sprite_cache.aabb[inner_co+1];
                        inner_max_x = inner_x + sprite_cache.aabb[inner_co+2];
                        inner_max_y = inner_y + sprite_cache.aabb[inner_co+3];

                        // Now comes the collision test!

                        #ifdef __DEBUG_COLLISION
                        printf("inner_x=%04u, inner_y=%04u\n", inner_x, inner_y);
                        printf("outer_x=%04u, outer_y=%04u\n", outer_x, outer_y);
                        printf("os=%u, is=%u, ", outer_side, inner_side);
                        printf("outer_type=%02x, inner_type=%02x\n", outer_type, inner_type);
                        #endif

                        if( outer_side != inner_side ) {

                            #ifdef __DEBUG_COLLISION
                            printf("outer_min_x=%04x, inner_min_x=%04x \n", outer_min_x, inner_min_x);
                            printf("outer_min_y=%04x, inner_min_y=%04x \n", outer_min_y, inner_min_y);
                            printf("outer_max_x=%04x, inner_max_x=%04x \n", outer_max_x, inner_max_x);
                            printf("outer_max_y=%04x, inner_max_y=%04x \n", outer_max_y, inner_max_y);
                            #endif

                            if( inner_min_x > outer_max_x   || 
                                inner_min_y > outer_max_y   || 
                                inner_max_x < outer_min_x   || 
                                inner_max_y < outer_min_y) {
                                // no collision
                            } else {

                                // Collision happened
                                if(outer_side == SIDE_ENEMY) {
                                    switch(outer_type) {
                                        case COLLISION_BULLET:
                                            #ifdef __DEBUG_COLLISION
                                            printf(", bullet %u -> ", outer );
                                            #endif
                                            if(inner_type == COLLISION_PLAYER) {
                                                #ifdef __DEBUG_COLLISION
                                                printf("player %u", inner);
                                                #endif
                                                bullet_remove(outer);
                                                player_remove(inner, outer);
                                            }
                                            break;

                                        case COLLISION_ENEMY:
                                            #ifdef __DEBUG_COLLISION
                                            printf(", enemy %u -> ", outer);
                                            #endif
                                            if(inner_type == COLLISION_BULLET) {
                                                #ifdef __DEBUG_COLLISION
                                                printf("bullet %u", inner);
                                                #endif
                                                bullet_remove(inner);
                                                stage_enemy_hit(enemy.wave[outer], outer, inner);
                                            }
                                            if(inner_type == COLLISION_PLAYER) {
                                                #ifdef __DEBUG_COLLISION
                                                printf("player %u", inner);
                                                #endif
                                                stage_enemy_hit(enemy.wave[outer], outer, inner);
                                                player_remove(inner, outer);
                                            }
                                            break;
                                        case COLLISION_TOWER:
                                            #ifdef __DEBUG_COLLISION
                                            printf(", tower %u -> ", outer);
                                            #endif
                                            if(inner_type == COLLISION_BULLET) {
                                                #ifdef __DEBUG_COLLISION
                                                printf("bullet %u", inner);
                                                #endif
                                                bullet_remove(inner);
                                                tower_hit(outer, inner);
                                            }
                                            break;
                                    }
                                } else {
                                    // Friendly
                                    switch(outer_type) {
                                        case COLLISION_BULLET:
                                            #ifdef __DEBUG_COLLISION
                                            printf(", bullet %u -> ", outer );
                                            #endif
                                            if(inner_type == COLLISION_ENEMY) {
                                                #ifdef __DEBUG_COLLISION
                                                printf("enemy %u", inner);
                                                #endif
                                                bullet_remove(outer);
                                                stage_enemy_hit(enemy.wave[outer], outer, inner);
                                            }
                                            if(inner_type == COLLISION_TOWER) {
                                                #ifdef __DEBUG_COLLISION
                                                printf("tower %u", inner);
                                                #endif
                                                bullet_remove(outer);
                                                tower_hit(inner, outer);
                                            }
                                            break;

                                        case COLLISION_PLAYER:
                                            #ifdef __DEBUG_COLLISION
                                            printf(", enemy %u -> ", outer);
                                            #endif
                                            if(inner_type == COLLISION_ENEMY) {
                                                #ifdef __DEBUG_COLLISION
                                                printf("bullet %u", inner);
                                                #endif
                                                stage_enemy_hit(enemy.wave[outer], outer, inner);
                                                player_remove(inner, outer);
                                            }
                                            break;
                                    }
                                }
                            }
                        }
                        ht_index_inner = ht_get_next(ht_index_inner);
                    }
                }
                ht_index_outer = ht_get_next(ht_index_outer);
            }
        }   
    }
    bank_pull_bram();
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

#ifdef __DEBUG_ENGINE

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

#if defined(__FLIGHT) || defined(__FLOOR)

    #ifdef __CPULINES
        vera_display_set_border_color(BLUE);
    #endif

    ht_reset(&ht_collision);

#ifdef __FLOOR
    #ifdef __CPULINES
    vera_display_set_border_color(GREY);
    #endif
    equinoxe_scrollfloor();

#endif


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
            vera_display_set_border_color(LIGHT_BLUE);
        #endif
        player_logic();
    #endif

    #ifdef __BULLET
        #ifdef __CPULINES
            vera_display_set_border_color(YELLOW);
        #endif
        bullet_logic();
    #endif


    #ifdef __ENEMY
        #ifdef __CPULINES
            vera_display_set_border_color(PINK);
        #endif
        enemy_logic();
    #endif

    #ifdef __TOWER
        #ifdef __CPULINES
            vera_display_set_border_color(LIGHT_GREEN);
        #endif
        tower_logic();
    #endif



    #ifdef __CPULINES
        vera_display_set_border_color(GREY);
    #endif

    #ifdef __TOWER
        tower_animate();
    #endif

    #ifdef __ENEMY
        #ifdef __CPULINES
            vera_display_set_border_color(GREY);
        #endif
        enemy_animate();
    #endif

    #ifdef __BULLET
        // bullets_resource();
    #endif


    #ifdef __PLAYER
        // player_resource();
    #endif

    #ifdef __COLLISION
    #ifdef __CPULINES
        vera_display_set_border_color(WHITE);
    #endif
    equinoxe_collision();
    #endif // __COLLISION

#endif // __FLIGHT


#ifndef __NOVSYNC
    // Reset the VSYNC interrupt
    *VERA_ISR = 1;
#endif

#ifdef __DEBUG_ENGINE

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
        printf("player %2x, %2x bullet %2x, %2x enemy %2x, %2x ", stage.sprite_player, stage.player_count, stage.sprite_bullet, stage.bullet_count, stage.sprite_enemy, stage.enemy_count);

        gotoxy(0,56);
        printf("enemy xor %x size %05u", stage.enemy_xor, sizeof(fe_enemy_t));

        gotoxy(x,y);
        }
#endif // __DEBUG_ENGINE



#ifdef __VERAHEAP_DEBUG
    gotoxy(40, 0);
    vera_heap_dump(VERA_HEAP_SEGMENT_SPRITES, 40, 0);
#endif


    bank_pull_bram();

    #ifdef __CPULINES
        vera_display_set_border_color(BLACK);
    #endif
}

void main() {

    // We are going to use only the kernal on the X16.
    bank_set_brom(CX16_ROM_KERNAL);

    petscii();
    scroll(1);

    #ifndef __LAYER1
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();
    #endif

    ht_init(&ht_collision);

    // We create the heap blocks in BRAM using the Fixed Block Heap Memory Manager.
    heap_segment_base(heap_bram_blocked, BRAM_HEAP_BRAM_BLOCKED, (heap_bram_fb_ptr_t)0xA000); // We set the heap to start in BRAM, bank 8. 
    heap_segment_define(heap_bram_blocked, bin64, 64, 128, 64*128);
    heap_segment_define(heap_bram_blocked, bin128, 128, 64, 128*64);
    heap_segment_define(heap_bram_blocked, bin256, 256, 64, 256*64);
    heap_segment_define(heap_bram_blocked, bin512, 512, 256, 512*(256));
    heap_segment_define(heap_bram_blocked, bin1024, 1024, 64, 1024*64);
    heap_segment_define(heap_bram_blocked, bin2048, 2048, 96, 2048*96);
    
    vera_heap_bram_bank_init(BRAM_VERAHEAP);

    vera_heap_segment_init(VERA_HEAP_SEGMENT_TILES, FLOOR_TILE_BANK_VRAM, FLOOR_TILE_OFFSET_VRAM, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM); // FLOOR_TILE segment for tiles of various sizes and types
    vera_heap_segment_init(VERA_HEAP_SEGMENT_SPRITES, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM, FLOOR_MAP1_BANK_VRAM, FLOOR_MAP1_OFFSET_VRAM); // SPRITES segment for sprites of various sizes

    equinoxe_init();



#if defined(__FLIGHT) || defined(__FLOOR)
    stage_reset();
#endif

#ifdef __DEBUG_HEAP_BRAM
    heap_print(heap_bram_blocked);
    while(!getin());
#endif

    while(!getin());

#ifdef __CPULINES
    // Set border to measure scan lines
    vera_display_set_hstart(1);
    vera_display_set_hstop(159);
    vera_display_set_vstart(0);
    vera_display_set_vstop(238);
#endif

#ifdef __FLOOR
    vera_layer0_mode_tile( 
        FLOOR_MAP0_BANK_VRAM, (vram_offset_t)FLOOR_MAP0_OFFSET_VRAM, 
        FLOOR_TILE_BANK_VRAM, (vram_offset_t)FLOOR_TILE_OFFSET_VRAM, 
        VERA_LAYER_WIDTH_64, VERA_LAYER_HEIGHT_32,
        VERA_TILEBASE_WIDTH_16, VERA_TILEBASE_HEIGHT_16, 
        VERA_LAYER_COLOR_DEPTH_4BPP
    );
    vera_layer0_show();

    #ifdef __LAYER1
    vera_layer1_mode_tile( 
        FLOOR_MAP1_BANK_VRAM, (vram_offset_t)FLOOR_MAP1_OFFSET_VRAM, 
        FLOOR_TILE_BANK_VRAM, (vram_offset_t)FLOOR_TILE_OFFSET_VRAM, 
        VERA_LAYER_WIDTH_64, VERA_LAYER_HEIGHT_32,
        VERA_TILEBASE_WIDTH_16, VERA_TILEBASE_HEIGHT_16, 
        VERA_LAYER_COLOR_DEPTH_4BPP
    );
    vera_layer1_show();
    #endif
#endif


#ifdef __FLOOR
    // TILE INITIALIZATION 

#ifdef __DEBUG_HEAP_BRAM
    heap_print(heap_bram_blocked);
    while(!getin());
#endif

    floor_draw_clear(0);
    floor_draw_clear(1);
    
    floor_paint_background(0, stage.floor);
    floor_draw_background(0, stage.floor);

    game.screen_vscroll = 16; // This is important, as we need to be exactly at the right spot of the floor_cache.
    vera_layer0_set_vertical_scroll(16);
    vera_layer1_set_vertical_scroll(0);
   
#endif


#if defined(__FLIGHT) || defined(__FLOOR)
    stage_logic();
#endif

    scroll(0);


#ifndef __NOVSYNC
    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    cx16_kernal_irq(&irq_vsync);
    // *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC | 0x80;
    *VERA_IRQLINE_L = 0xFF;
    CLI();
#endif

    cx16_mouse_config(0xFF, 80, 60);
    cx16_mouse_get();

    vera_sprites_show();

    __mem unsigned char ch = getin();
    while (ch != 'x') {
        #ifdef __NOVSYNC
            irq_vsync();
        #endif

        switch(ch) {
            case 'x':
            break;
            
            #ifdef __DEBUG_LRU_CACHE
            case 'l':
            SEI();
            gotoxy(0, 30);
            lru_cache_display(&sprite_cache_vram);
            CLI();
            break;
            #endif

        }

        #ifdef __DEBUG_SPRITE_CACHE
            SEI();
            fe_sprite_debug();
            CLI();
        #endif

        #ifdef __DEBUG_COLLISION_HASH
            gotoxy(0,0);
            ht_display(&ht_collision);
        #endif

        #ifdef __DEBUG_STAGE
            SEI();
            stage_display();
            CLI();
        #endif

        SEI();
        ch=getin();
        CLI();
    }; 

    // Back to basic.
    bank_set_brom(CX16_ROM_BASIC);

}

