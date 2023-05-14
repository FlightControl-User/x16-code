// Space flight engine for a space game written in kickc for the Commander X16.

#pragma link("equinoxe.ld")
#pragma encoding(petscii_mixed)
// #pragma cpu(mos6502)
#pragma var_model(zp)
#pragma zp_reserve(0x00..0x10, 0x80..0xA8)

#include "equinoxe.h"
#include "equinoxe-petscii.c"

#pragma data_seg(Debug)
volatile char buffer[256];

#pragma data_seg(Data)
#pragma nobank
#pragma var_model(mem)

equinoxe_game_t game = {0, 0, 0, 0, 127, 64, 2};

void equinoxe_init() {

    // Load all banks with data and code!
    unsigned bytes = 0;
    bytes = fload_bram("stages.bin", BANK_ENGINE_STAGES, (bram_ptr_t)0xA000);
    bytes = fload_bram("bramflight1.bin", BANK_ENGINE_SPRITES, (bram_ptr_t)0xA000);
    bytes = fload_bram("bramfloor1.bin", BANK_ENGINE_FLOOR, (bram_ptr_t)0xA000);

    flight_init();

#ifdef __PLAYER
    bytes = fload_bram("players.bin", BANK_ENGINE_PLAYERS, (bram_ptr_t)0xA000);
#endif

#ifdef __ENEMY
    bytes = fload_bram("enemies.bin", BANK_ENGINE_ENEMIES, (bram_ptr_t)0xA000);
#endif

#ifdef __TOWER
    bytes = fload_bram("towers.bin", BANK_ENGINE_TOWERS, (bram_ptr_t)0xA000);
#endif

#ifdef __BULLET
    bytes = fload_bram("bullets.bin", BANK_ENGINE_BULLETS, (bram_ptr_t)0xA000);
#endif

    animate_init();

	memset(&stage, 0, sizeof(stage_t));

    // Initialize the cache in vram for the sprite animations.
    lru_cache_init();
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

    collision_init();

#ifdef __FLOOR
    #ifdef __CPULINES
    vera_display_set_border_color(GREY);
    #endif
    floor_scroll();

#endif


    // cx16_mouse_scan(); 
    cx16_mouse_get();

#ifdef __STAGE 

    unsigned char tickupdate = game.ticksync & 0x01;
    if(!tickupdate) {
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
            vera_display_set_border_color(BROWN);
        #endif
        tower_logic();
    #endif

    #ifdef __COLLISION
    #ifdef __CPULINES
        vera_display_set_border_color(WHITE);
    #endif
    collision_detect();
    #endif // __COLLISION

#endif // __FLIGHT

    // BREAKPOINT
    vera_display_set_border_color(GREY);
    flight_draw();

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
        printf("player %2x, %2x bullet %2x, %2x enemy %2x, %2x ", stage.player_pool, stage.player_count, stage.bullet_pool, stage.bullet_count, stage.enemy_pool, stage.enemy_count);

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

/// @brief game startup
void main() {


    {kickasm {{
        jsr bramheap.__start
        jsr veraheap.__start
        jsr lru_cache.__start
    }}}

    cx16_k_screen_set_charset(3, (char *)0);

    // We are going to use only the kernal on the X16.
    bank_set_brom(CX16_ROM_KERNAL);

    petscii();
    scroll(1);

    #ifndef __LAYER1
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();
    #endif


    // We initialize the Commander X16 BRAM heap manager. This manages dynamically the memory space in banked ram as a real heap.
    bram_heap_bram_bank_init(BANK_HEAP_BRAM);
    // BREAKPOINT
    bram_heap_segment_init(1, 0x10, (bram_ptr_t)0xA000, 0x39, (bram_ptr_t)0xA000);

    // We intialize the Commander X16 VERA heap manager. This manages dynamically the memory space in vera ram as a real heap.
    vera_heap_bram_bank_init(BANK_VERA_HEAP);
    vera_heap_segment_init(VERA_HEAP_SEGMENT_TILES, FLOOR_TILE_BANK_VRAM, FLOOR_TILE_OFFSET_VRAM, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM); // FLOOR_TILE segment for tiles of various sizes and types
    vera_heap_segment_init(VERA_HEAP_SEGMENT_SPRITES, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM, FLOOR_MAP1_BANK_VRAM, FLOOR_MAP1_OFFSET_VRAM); // SPRITES segment for sprites of various sizes

    equinoxe_init();

#if defined(__FLIGHT) || defined(__FLOOR)
    stage_reset();
#endif

#ifdef __DEBUG_HEAP_BRAM
    heap_print(heap_bram_blocked);
    while(!kbhit());
#endif

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
    while(!kbhit());
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

    while(!kbhit());


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

    unsigned char ch = kbhit();
    while (ch != 'x') {
        #ifdef __NOVSYNC
            irq_vsync();
        #endif

        #ifdef __DEBUG_SPRITE_CACHE
            SEI();
            fe_sprite_debug();
            CLI();
        #endif

        #ifdef __DEBUG_COLLISION_HASH
            collision_debug();
        #endif

        // #ifdef __DEBUG_STAGE
        //     SEI();
        //     stage_display();
        //     CLI();
        // #endif

        #ifdef __NOVSYNC
        SEI();
        #endif
        ch=kbhit();
        #ifdef __NOVSYNC
        CLI();
        #endif
    }; 

    // Back to basic.
    bank_set_brom(CX16_ROM_BASIC);

}

#ifndef __INTELLISENSE__
__export char VERAHEAP[] = kickasm(resource "../../target/cx16-veraheap/veraheap.asm") {{
    #define __veraheap__
    #import "veraheap.asm"
}};

__export char BRAMHEAP[] = kickasm(resource "../../target/cx16-bramheap/bramheap.asm") {{
    #define __bramheap__
    #import "bramheap.asm" 
}};

__export char LRU_CACHE[] = kickasm(resource "../../target/cx16-lru-cache/lru-cache.asm") {{
    #define __lru_cache__
    #import "lru-cache.asm"
}};

__export char ANIMATE[] = kickasm(resource "../../target/x16-equinoxe/asm/animate.asm") {{
    #define __animate__
    #import "animate.asm"
}};

__export char PALETTE[] = kickasm(resource "../../target/x16-equinoxe/asm/palette.asm") {{
    #define __palette__
    #import "palette.asm"
}};
#endif