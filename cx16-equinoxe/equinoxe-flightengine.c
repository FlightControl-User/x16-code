// Space flight engine for a space game written in kickc for the Commander X16.


#pragma var_model(mem)

#include <cx16.h>
#include <cx16-veralib.h>
#include <cx16-heap.h>
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

#include "equinoxe.h"
#include "equinoxe-flightengine.h"

void sprite_cpy_vram_from_bram(struct Sprite *Sprite) {

    heap_ptr ptr_bram_sprite = heap_data_ptr(Sprite->BRAM_Handle);
    heap_bank bank_bram_sprite = heap_data_bank(Sprite->BRAM_Handle);

    byte SpriteCount = Sprite->SpriteCount;
    word SpriteSize = Sprite->SpriteSize;
    byte SpriteOffset = Sprite->SpriteOffset;

    for(byte s=0;s<SpriteCount;s++) {

        heap_handle handle_vram_sprite = heap_alloc(HEAP_SEGMENT_VRAM_SPRITES, SpriteSize);
        heap_bank bank_vram_sprite = heap_data_bank(handle_vram_sprite);
        heap_ptr ptr_vram_sprite = heap_data_ptr(handle_vram_sprite);

        cx16_cpy_vram_from_bram(bank_vram_sprite, (word)ptr_vram_sprite, bank_bram_sprite, (byte*)ptr_bram_sprite, SpriteSize);

        Sprite->VRAM_Handle[s] = handle_vram_sprite;
        ptr_bram_sprite = cx16_bram_ptr_inc(bank_bram_sprite, ptr_bram_sprite, SpriteSize);
        bank_bram_sprite = cx16_bram_bank_get();
    }
}

// Load the sprite into bram using the new cx16 heap manager.
heap_handle sprite_load( struct Sprite *Sprite) {

    heap_handle handle_bram_sprite = heap_alloc(HEAP_SEGMENT_BRAM_SPRITES, Sprite->TotalSize);  // Reserve enough memory on the heap for the sprite loading.
    heap_ptr ptr_bram_sprite = heap_data_ptr(handle_bram_sprite);
    heap_bank bank_bram_sprite = heap_data_bank(handle_bram_sprite);
    heap_handle data_handle_bram_sprite = heap_data_handle(handle_bram_sprite);

    cx16_ptr ptr_end = cx16_load_ram_banked(1, 8, 0, Sprite->File, bank_bram_sprite, ptr_bram_sprite);
    if(!ptr_end) printf("error file %s\n", Sprite->File);

    Sprite->BRAM_Handle = handle_bram_sprite;
    return handle_bram_sprite;
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
    gotoxy(0, 30);
    for(byte i=0;i<SPRITE_TYPES;i++) {
        struct Sprite *Sprite = SpriteDB[i];
        byte offset = Sprite->SpriteOffset;
        printf("s:%u bram: %x/%p, vram: ", i, heap_data_bank(Sprite->BRAM_Handle), heap_data_ptr(Sprite->BRAM_Handle));
        for(byte j=0;j<Sprite->SpriteCount;j++) {
            printf("%x/%p ", heap_data_bank(Sprite->VRAM_Handle[j]), heap_data_ptr(Sprite->VRAM_Handle[j]));
        }
        printf("\n");
    }
}

void show_sprite_config(byte sprite, byte x, byte y) {
    struct VERA_SPRITE SpriteAttributes;
    vera_sprite_attributes_get(sprite, &SpriteAttributes);
    gotoxy(x, y);
    printf("s:%u ", sprite );
    printf("%x %x ", SpriteAttributes.CTRL1, SpriteAttributes.CTRL2);
}

#include "equinoxe-petscii-move.c"


void main() {


    // We are going to use only the kernal on the X16.
    cx16_brom_bank_set(CX16_ROM_KERNAL);

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


    // Allocate the segment for the sprites in vram.
    cx16_vram_packed vram_sprites = heap_segment_vram_ceil(
        HEAP_SEGMENT_VRAM_SPRITES, 
        vram_petscii, 
        vram_petscii, 
        cx16_bram_pack(1, (heap_ptr)0xA200), 
        0x02c0
        );

    #include "equinoxe-palettes.c"

    // Initialize the bram heap for sprite loading.
    cx16_bram_packed bram_sprites = heap_segment_bram(
        HEAP_SEGMENT_BRAM_SPRITES, 
        cx16_bram_pack(2, (heap_ptr)0xA000),
        cx16_size_pack(0x2000*30)
        );

    gotoxy(0, 10);
    vera_sprites_show();

    // Loading the graphics in main banked memory.
    for(byte i=0; i<SPRITE_TYPES;i++) {
        sprite_load(SpriteDB[i]);
    }


 
    // Now we activate the tile mode.
    for(byte i=0;i<SPRITE_TYPES;i++) {
        sprite_cpy_vram_from_bram(SpriteDB[i]);
    }

    sprite_create(0, 1); // Player ship
    sprite_create(1, 2); // Player thrust
    for( byte Sprite=64;Sprite<64+10;Sprite++) {
        sprite_create(3, Sprite); // Player bullets
    }

    // show_memory_map();

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
    cx16_brom_bank_set(CX16_ROM_BASIC);

}

void sprite_animate(byte SpriteOffset, byte SpriteType, byte Index) {
    struct Sprite *Sprite = SpriteDB[SpriteType];
    byte SpriteCount = Sprite->SpriteCount;
    Index = (Index>=SpriteCount)?Index-SpriteCount:Index;
    heap_bank bank_vram_sprite = heap_data_bank(Sprite->VRAM_Handle[Index]);
    heap_ptr ptr_vram_sprite = heap_data_ptr(Sprite->VRAM_Handle[Index]);
    vera_sprite_ptr(SpriteOffset, bank_vram_sprite, ptr_vram_sprite);
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
                                sprite_bullet_count--;
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
                    enemy->health = 0xff;
                    enemy->strength = 0x0f;
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
                        bullet->energy = 1;
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
