// Example program for the Commander X16




#include <cx16.h>
#include <cx16-veralib.h>
#include <cx16-veramem.h>
#include <cx16-mouse.h>
#include <kernal.h>
#include <6502.h>
#include <conio.h>
#include <printf.h>
#include <stdio.h>
#include <division.h>
#include <mos6522.h>
#include <multiply.h>

#include "flightengine.h"





volatile byte j = 0;
volatile byte a = 4;
volatile word row = 8;
volatile byte s = 1;
volatile word vscroll = 8*64;
volatile word prev_mousex = 0;
volatile word prev_mousey = 0;
volatile byte sprite_player = 3;
volatile byte sprite_player_moved = 0;
volatile byte sprite_engine_flame = 0;
volatile byte scroll_action = 4;
volatile byte sprite_action = 0;

struct sprite_bullet {
    byte active;
    signed int x;
    signed int y;
    signed char dx;
    signed char dy;
};

struct sprite_enemy {
    byte active;
    byte SpriteType;
    byte state_behaviour;
    byte state_animation;
    byte speed_animation;
    signed int x;
    signed int y;
    signed char dx;
    signed char dy;
};

struct sprite_bullet sprite_bullets[11] = {0};
volatile byte sprite_bullet_count = 0;
volatile byte sprite_bullet_pause = 0;
volatile byte sprite_bullet_switch = 0;



struct sprite_enemy sprite_enemies[33] = {0};
volatile byte sprite_enemy_count = 0;

volatile byte sprite_collided = 0;


volatile byte state_game = 0;

byte const SPRITE_OFFSET_PLAYER = 1;
byte const SPRITE_OFFSET_ENGINE = 2;
byte const SPRITE_OFFSET_ENEMY = 3;
byte const SPRITE_OFFSET_BULLET = 64;

byte const HEAP_FLOOR_MAP = 1;
byte const HEAP_FLOOR_TILE = 2;
byte const HEAP_PETSCII = 3;

const dword VRAM_PETSCII_MAP = 0x1B000;
const dword VRAM_PETSCII_TILE = 0x1F000;

__mem dword bram_sprites_base;
__mem dword bram_sprites_ceil;
__mem dword bram_tiles_base;
__mem dword bram_ceil;
__mem dword bram_palette;

volatile dword vram_floor_map;

const char FILE_PALETTES[] = "PALETTES";


void sprite_cpy_vram(byte segmentid, struct Sprite *Sprite) {
    dword bsrc = Sprite->BRAM_Address;
    byte SpriteCount = Sprite->SpriteCount;
    word SpriteSize = Sprite->SpriteSize;
    byte SpriteOffset = Sprite->SpriteOffset;
    for(byte s=0;s<SpriteCount;s++) {
        dword vaddr = vera_heap_malloc(segmentid, SpriteSize);
        dword baddr = bsrc+mul16u((word)s,SpriteSize);
        vera_cpy_bank_vram(baddr, vaddr, SpriteSize);
        Sprite->VRAM_Address[s] = vaddr;
    }
}

dword sprite_load( struct Sprite *Sprite, dword bram_address) {
    char status = cx16_load_ram_banked(1, 8, 0, Sprite->File, bram_address);
    if(status!=$ff) printf("error file %s: %x\n", Sprite->File, status);
    Sprite->BRAM_Address = bram_address;
    word SpriteSize = Sprite->TotalSize;
    // printf("SpriteSize = %u", SpriteSize);
    return bram_address + SpriteSize;
    // return bram_address + Sprite->Size; // TODO: fragment
}

void sprite_create(byte sprite, byte SpriteOffset) {

    // Copy sprite palette to VRAM
    // Copy 8* sprite attributes to VRAM
    struct Sprite *Sprite = SpriteDB[sprite];
    vera_sprite_bpp(SpriteOffset, Sprite->BPP);
    vera_sprite_height(SpriteOffset, Sprite->Height);
    vera_sprite_width(SpriteOffset, Sprite->Width);
    vera_sprite_hflip(SpriteOffset, Sprite->Hflip);
    vera_sprite_vflip(SpriteOffset, Sprite->Vflip);
    vera_sprite_palette_offset(SpriteOffset, Sprite->PaletteOffset);
}

void show_memory_map() {
    for(byte i=0;i<SPRITE_TYPES;i++) {
        struct Sprite *Sprite = SpriteDB[i];
        byte offset = Sprite->SpriteOffset;
        gotoxy(0, 30+i);
        printf("s:%u bram:%x, vram:", i, Sprite->BRAM_Address);
        for(byte j=0;j<Sprite->SpriteCount;j++) {
            printf("%x ", Sprite->VRAM_Address[j]);
        }
    }
}

void show_sprite_config(byte sprite, byte x, byte y) {
    struct VERA_SPRITE SpriteAttributes;
    vera_sprite_attributes_get(sprite, &SpriteAttributes);
    gotoxy(x, y);
    printf("s:%u ", sprite );
    printf("%x %x ", SpriteAttributes.CTRL1, SpriteAttributes.CTRL2);
}

void main() {


    // We are going to use only the kernal on the X16.
    cx16_rom_bank(CX16_ROM_KERNAL);

    // Handle the relocation of the CX16 petscii character set and map to the most upper corner in VERA VRAM.
    // This frees up the maximum space in VERA VRAM available for graphics.
    const word VRAM_PETSCII_MAP_SIZE = 128*64*2;
    vera_heap_segment_init(HEAP_PETSCII, 0x1B000, VRAM_PETSCII_MAP_SIZE + VERA_PETSCII_TILE_SIZE);
    dword vram_petscii_map = vera_heap_malloc(HEAP_PETSCII, VRAM_PETSCII_MAP_SIZE);
    dword vram_petscii_tile = vera_heap_malloc(HEAP_PETSCII, VERA_PETSCII_TILE_SIZE);
    vera_cpy_vram_vram(VERA_PETSCII_TILE, VRAM_PETSCII_TILE, VERA_PETSCII_TILE_SIZE);
    vera_layer_mode_tile(1, vram_petscii_map, vram_petscii_tile, 128, 64, 8, 8, 1);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(DARK_GREY);
    clrscr();

    gotoxy(0, 30);
    // Loading the graphics in main banked memory.
    bram_ceil = 0x02000;
    for(byte i=0; i<SPRITE_TYPES;i++) {
        bram_ceil = sprite_load(SpriteDB[i], bram_ceil);
    }

    // Load the palettes in main banked memory.
    bram_palette = 0x24000;
    byte status = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, bram_palette);
    if(status!=$ff) printf("error file_palettes = %u",status);

    // Set the vera heap parameters.
    word const VRAM_SPRITES_SIZE = 64*32*32/2; // Issue to solve: 128 sprites in heap manager seems not to work correctly, but will 127?
    __mem dword vram_segment_sprites = vera_heap_segment_init(HEAP_SPRITES, 0x00000, VRAM_SPRITES_SIZE);

    // Now we activate the tile mode.
    for(byte i=0;i<SPRITE_TYPES;i++) {
        sprite_cpy_vram(HEAP_SPRITES, SpriteDB[i]);
    }

    // Load the palette in VERA palette registers, but keep the first 16 colors untouched.
    vera_cpy_bank_vram(bram_palette, VERA_PALETTE+32, (dword)32*15);

    sprite_create(0, 1); // Player ship
    sprite_create(1, 2); // Player thrust
    for( byte Sprite=64;Sprite<64+10;Sprite++) {
        sprite_create(3, Sprite); // Player bullets
    }

    show_memory_map();
    vera_sprites_show();

    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC; 
    vera_sprites_collision_on();
    CLI();

    cx16_mouse_config(0xFF,1);
    while(!getin()) {
    };

    // Back to basic.
    cx16_rom_bank(CX16_ROM_BASIC);

}

void sprite_animate(byte SpriteOffset, byte SpriteType, byte Index) {
    struct Sprite *Sprite = SpriteDB[SpriteType];
    byte SpriteCount = Sprite->SpriteCount;
    Index = (Index>=SpriteCount)?Index-SpriteCount:Index;
    vera_sprite_address(SpriteOffset, Sprite->VRAM_Address[Index]);
}

void sprite_position(byte SpriteOffset, word x, word y) {
    vera_sprite_xy(SpriteOffset, x, y);
}

void sprite_enable(byte SpriteOffset, byte SpriteType) {
    struct Sprite *Sprite = SpriteDB[SpriteType];
    vera_sprite_zdepth(SpriteOffset, Sprite->Zdepth);
    vera_sprite_bpp(SpriteOffset, Sprite->BPP);
    vera_sprite_height(SpriteOffset, Sprite->Height);
    vera_sprite_width(SpriteOffset, Sprite->Width);
    vera_sprite_hflip(SpriteOffset, Sprite->Hflip);
    vera_sprite_vflip(SpriteOffset, Sprite->Vflip);
    vera_sprite_palette_offset(SpriteOffset, Sprite->PaletteOffset);
}

void sprite_disable(byte SpriteOffset) {
    vera_sprite_disable(SpriteOffset);
}

void sprite_collision(byte SpriteOffset, byte mask) {
    vera_sprite_collision_mask(SpriteOffset, mask);
}

//VSYNC Interrupt Routine

__interrupt(rom_sys_cx16) void irq_vsync() {

    // Check if collision interrupt
    if(vera_sprite_is_collision()) {
        gotoxy(0, 20);
        printf("irq: %x", *VERA_ISR );
        sprite_collided = 1;
        vera_sprite_collision_clear();
    } else {


        char cx16_mouse_status = cx16_mouse_get();

        // background scrolling
        if(!scroll_action--) {
            scroll_action = 4;
            // gotoxy(0,2);
            // printf("i:%02u",i);
        }

        if(sprite_collided) {
            // check which bullet collides with which enemy ...
            for(byte b=0;b<10;b++) {
                struct sprite_bullet *bullet = &sprite_bullets[b];
                if(bullet->active) {
                    signed int bx = bullet->x;
                    signed int by = bullet->y;
                    for(byte e=0;e<32;e++) {
                        struct sprite_enemy *enemy = &sprite_enemies[e];
                        if(enemy->active) {
                            signed int ex = enemy->x;
                            signed int ey = enemy->y;
                            byte collided = 1;
                            if(bx<ex || bx+16>ex+32) {
                                collided = 0;
                            }
                            if(by<ey || by+16>ey+32) {
                                collided = 0;
                            }
                            if(collided) {
                                enemy->active = 0;
                                bullet->active = 0;
                                sprite_disable(SPRITE_OFFSET_ENEMY+e);
                                sprite_disable(SPRITE_OFFSET_BULLET+b);
                            }
                        }
                    }
                }
            }
        sprite_collided = 0;
        }

        // Handle game state evolution over time ...
        switch(state_game) {
            case 0:
                for(byte e=0; e<8; e++) {
                    sprite_enable(SPRITE_OFFSET_ENEMY+e, SPRITE_ENEMY01); // Enemy01
                    struct sprite_enemy *enemy = &sprite_enemies[e];
                    enemy->x = 20+(signed int)e*36;
                    enemy->y = 100;
                    enemy->dx = 0;
                    enemy->dy = 0;
                    sprite_position(SPRITE_OFFSET_ENEMY+e, (word)enemy->x, (word)enemy->y);
                    enemy->state_animation = 0;
                    enemy->state_behaviour = 0;
                    enemy->speed_animation = 4;
                    enemy->active = 1;
                    enemy->SpriteType = SPRITE_ENEMY01;
                    sprite_collision(SPRITE_OFFSET_ENEMY+e, 0x03);
                }
                state_game = 1;
                break;
        }

        if(!sprite_action--) {
            sprite_action = 8;
            if(cx16_mousex<prev_mousex && sprite_player>0) {
                sprite_player -= 1;
                sprite_player_moved = 2;
            }
            if(cx16_mousex>prev_mousex && sprite_player<6) {
                sprite_player += 1;
                sprite_player_moved = 2;
            }
            if(sprite_player_moved==1) {
                if(sprite_player<3) sprite_player+=1;
                if(sprite_player>3) sprite_player-=1;
                if(sprite_player==3) sprite_player_moved=0;
            } else {
                sprite_player_moved--;
            }
            prev_mousex = cx16_mousex;
        }
        sprite_engine_flame++;
        sprite_engine_flame&=0x0F;
        sprite_enable(SPRITE_OFFSET_PLAYER, SPRITE_PLAYER01);
        sprite_enable(SPRITE_OFFSET_ENGINE, SPRITE_ENGINE01);
        sprite_animate(SPRITE_OFFSET_PLAYER, SPRITE_PLAYER01, sprite_player);
        sprite_position(SPRITE_OFFSET_PLAYER, cx16_mousex, cx16_mousey);
        sprite_animate(SPRITE_OFFSET_ENGINE, SPRITE_ENGINE01, sprite_engine_flame);
        sprite_position(SPRITE_OFFSET_ENGINE, cx16_mousex+8, cx16_mousey+22);
        gotoxy(0,10);
        printf("mouse: %u %u %u %u       ", cx16_mousex, cx16_mousey, prev_mousex, (unsigned int)cx16_mouse_status);

        // Enemies
        for(byte e=0;e<32;e++) {
            struct sprite_enemy *enemy = &sprite_enemies[e];
            if(enemy->active) {
                switch(enemy->SpriteType) {
                    case SPRITE_ENEMY01:
                        if(!enemy->speed_animation--) {
                            enemy->state_animation = enemy->state_animation<11?enemy->state_animation+1:0;
                            enemy->speed_animation = 3;
                        }
                        sprite_animate(SPRITE_OFFSET_ENEMY+e, SPRITE_ENEMY01, enemy->state_animation);
                        signed char dx = enemy->dx;
                        signed char dy = enemy->dy;
                        signed int x = enemy->x;
                        signed int y = enemy->y;
                        x += dx;
                        y += dy;
                        enemy->x = x;
                        enemy->y = y;
                        break;
                }
            }
        }


        // Player Bullets
        sprite_bullet_pause = (sprite_bullet_pause>0)?sprite_bullet_pause-1:0;
        gotoxy(0,11);
        printf("bullet: %u %u        ", sprite_bullet_pause, sprite_bullet_count);
        if(cx16_mouse_status==1 && !sprite_bullet_pause) {
            // the mouse button was pressed
            if(sprite_bullet_count<10) {
                for(byte b=0;b<10;b++) {
                    struct sprite_bullet *bullet = &sprite_bullets[b];
                    if(!bullet->active) {
                        signed word x = (signed word)cx16_mousex;
                        x += (signed word)(sprite_bullet_switch?16:0);
                        bullet->x = x; 
                        bullet->y = (signed word)cx16_mousey;
                        bullet->dx = 0;
                        bullet->dy = -8;
                        sprite_bullet_pause = 6;
                        bullet->active = 1;
                        sprite_bullet_count++;
                        sprite_bullet_switch = sprite_bullet_switch?0:1;
                        sprite_enable(SPRITE_OFFSET_BULLET+b, SPRITE_BULLET01);
                        sprite_collision(SPRITE_OFFSET_BULLET+b, 0x03);
                        b=10;
                        break;
                    }
                }
            }
        }
        for(byte b=0;b<10;b++) {
            struct sprite_bullet *bullet = &sprite_bullets[b];
            // gotoxy(0,12+b);
            // printf("bullet %u: %u %d %d                           ", b, bullet->active, bullet->x, bullet->y);
            if(bullet->active) {
                // TODO: new fragments needed
                signed char dx = bullet->dx;
                signed char dy = bullet->dy;
                signed int x = bullet->x;
                signed int y = bullet->y;
                x += dx;
                y += dy;
                bullet->x = x;
                bullet->y = y;
                if(y>0) { 
                    sprite_animate(SPRITE_OFFSET_BULLET+b, SPRITE_BULLET01, 0);
                    sprite_position(SPRITE_OFFSET_BULLET+b, (word)x, (word)y);
                } else {
                    bullet->active = 0;
                    sprite_bullet_count--;
                    sprite_disable(SPRITE_OFFSET_BULLET+b);
                }
            }
        }

    }
    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
    vera_sprites_collision_on();

}
