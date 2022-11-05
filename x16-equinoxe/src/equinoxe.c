// Space flight engine for a space game written in kickc for the Commander X16.

#pragma link("equinoxe.ld")
#pragma encoding(petscii_mixed)
#pragma target(CX16)
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

    ht_init(&ht_collision);

#ifdef __FLOOR
    #ifdef __CPULINES
    vera_display_set_border_color(GREY);
    #endif
    floor_scroll();

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
    collision_detect();
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

