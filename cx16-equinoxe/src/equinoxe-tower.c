// Space tile scrolling engine for a space game written in kickc for the Commander X16.


#include <cx16.h>
#include <conio.h>
#include <cx16-conio.h>
#include <stdio.h>
#include <division.h>
#include <multiply.h>

#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-stage.h"
// #include "equinoxe-palette.h"
#include "equinoxe-floorengine.h"
#include "equinoxe-flightengine.h"

#include "equinoxe-tower.h"

#pragma data_seg(TileControlTowers)
tower_t towers;

#pragma data_seg(Data)


unsigned char tower_add( 
    sprite_bram_t* turret, 
    unsigned char x, 
    unsigned char y,
    unsigned int tx,
    unsigned int ty,
    unsigned char anim_speed, 
    unsigned char palette_index ) 
{

    bank_push_set_bram(BRAM_ENGINE_TOWERS);

	unsigned char t = stage.tower_pool;

	while(towers.used[t]) {
		t = (t+1) % TOWERS_TOTAL;
	}

	towers.used[t] = 1;
    towers.offset[t] = 0;

	towers.side[t] = SIDE_ENEMY;

    fe_sprite_index_t s = fe_sprite_cache_copy(turret);
    towers.sprite[t] = s;

	towers.sprite_offset[t] = NextOffset(SPRITE_OFFSET_ENEMY_START, SPRITE_OFFSET_ENEMY_END, &stage.sprite_enemy, &stage.sprite_enemy_count);
	fe_sprite_configure(towers.sprite_offset[t], s);

    // printf("towers t=%u", t);
    // printf(", offset=%6u", towers.sprite_offset[t]);



	towers.anim_wait[t] = anim_speed;
	towers.anim_speed[t] = anim_speed;

    towers.palette[t] = palette16_use(palette_index);

	towers.health[t] = 100;

    towers.tx[t] = tx;
    towers.ty[t] = ty;
    towers.x[t] = x;
    towers.y[t] = y;

	stage.tower_pool = (t+1)%TOWERS_TOTAL;
    stage.tower_count++;

    enemies_resource();

    bank_pull_bram();

    unsigned char ret = 1;
    return ret;
}

unsigned char tower_remove(unsigned char t) 
{

    bank_push_set_bram(BRAM_ENGINE_TOWERS);

    vera_sprite_offset sprite_offset = towers.sprite_offset[t];
    FreeOffset(sprite_offset, &stage.sprite_enemy_count);
    vera_sprite_disable(sprite_offset);
    palette16_unuse(sprite_cache.palette_offset[towers.sprite[t]]);
    fe_sprite_cache_free(towers.sprite[t]);

    towers.used[t] = 0;
    towers.enabled[t] = 0;

    bank_pull_bram();

    unsigned char ret = 1;
    return ret;
}


void tower_paint(sprite_bram_t* turret, unsigned char tx, unsigned char ty) 
{

    bank_push_set_bram(BRAM_ENGINE_TOWERS);

    for(unsigned char x=0; x<12; x++) {
        for(unsigned char y=0; y<16; y++) {

            unsigned char rnd = BYTE0(rand());

            byte slab = (BYTE0(rand()) & 0x0F);

            unsigned char floor_slab = floor_cache[y].floor_segment[x];

            if( floor_slab == 15 ) {
                if( rnd <= 128 ) {
                    if( stage.tower_count < TOWERS_TOTAL) {
                        tower_add(turret, x, y, (unsigned int)x*64+tx, (unsigned int)y*64+ty, 4, 4);
                        floor_draw_slab(stage.towers, 0, x, y);
                    }
                }
            }
        }
    }

    bank_pull_bram();
}

void tower_animate(unsigned char t) {

    // bank_push_set_bram(BRAM_ENGINE_TOWERS);

    if(towers.used[t] && towers.side[t] == SIDE_ENEMY) {	

        switch(towers.state[t]) {
            case 0:
                unsigned char rnd = rand();
                if(rnd<=5) towers.state[t] = 1;
                break;
            case 1:
                towers.anim_start[t] = 0;
                towers.anim_stop[t] = 11;
                towers.anim_wait[t] = 0;
                towers.state[t] = 2;
                break;
            case 2:
                if(!towers.anim_wait[t]) {
                    towers.anim_wait[t] = towers.anim_speed[t];
                    if(towers.anim_state[t] >= towers.anim_stop[t]) {
                        towers.anim_wait[t] = 255;
                        towers.state[t] = 3;
                    } else {
                        towers.anim_state[t] += 1;
                    }
                } else {
                    towers.anim_wait[t]--;
                }
                break;
            case 3:
                // Shoot
                if(!towers.anim_wait[t]) {
                    towers.anim_wait[t] = 0;
                    towers.state[t] = 4;
                } else {
                    towers.anim_wait[t] = 0;
                }
                break;   
            case 4:
                if(!towers.anim_wait[t]) {
                    towers.anim_wait[t] = towers.anim_speed[t];
                    if(towers.anim_state[t] <= towers.anim_start[t]) {
                        towers.state[t] = 0;
                    } else {
                        towers.anim_state[t] -= 1;
                    }
                }
                towers.anim_wait[t]--;
                break;
            default:
        }
    }

    // bank_pull_bram();
}

void tower_logic() {

    bank_push_set_bram(BRAM_ENGINE_TOWERS);

	for(unsigned char t=0; t<TOWERS_TOTAL; t++) {
		if(towers.used[t] && towers.side[t] == SIDE_ENEMY) {	
            if(game.row == 32) {
                if (towers.y[t] < 8) {
                    tower_remove(t);
                    // printf("unusing tower t=%u, row=%u", t, game.row);
                }
            }

            if(game.row == 0) {
                if (towers.y[t] >= 8) {
                    tower_remove(t);
                    // printf("unusing tower t=%u, row=%u", t, game.row);
                }
            }
		}

        tower_animate(t);

		if(towers.used[t] && towers.side[t] == SIDE_ENEMY) {
            // todo i need to review this statement as it compiles wrongly like this:
            // signed int py = (signed int)((unsigned int)towers.y[t] * 64) - (signed int)game.screen_vscroll; // the screen_vscroll contains the current scroll position.
            unsigned int y = (unsigned int)towers.ty[t];
            signed int py = (signed int)y - (signed int)game.screen_vscroll; // the screen_vscroll contains the current scroll position.
            signed int px = (signed int)towers.tx[t];
            // floor_draw_slab(stage.towers, 0, towers.x[t], towers.y[t]);
            vera_sprite_offset sprite_offset = towers.sprite_offset[t];
            vera_sprite_zdepth_in_front(sprite_offset);
            vera_sprite_set_xy_and_image_offset(sprite_offset, px, py, sprite_image_cache_vram(towers.sprite[t], towers.anim_state[t]));
            // printf("tower logic: t=%u, towers x[t]=%3u, y[t]=%3u", t, towers.x[t], y, towers.y[t]);
            // printf("vscroll=%4u, px=%i, py=%i, y=%u\n", game.screen_vscroll, px, py, y);
        }
	}
    bank_pull_bram();
}

#pragma data_seg(Data)