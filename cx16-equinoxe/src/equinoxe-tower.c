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


unsigned char tower_add( sprite_bram_t* turret, unsigned char x, unsigned char y, unsigned char animation_speed, unsigned char animation_count, unsigned char palette_index ) 
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


	towers.wait_animation[t] = animation_speed;
	towers.speed_animation[t] = animation_speed;
	towers.state_animation[t] = 0;
    towers.start_animation[t] = 0;
    towers.stop_animation[t] = animation_count;
    towers.direction_animation[t] = 1;
    towers.palette[t] = palette16_use(palette_index);

	towers.health[t] = 100;

    towers.x[t] = x;
    towers.y[t] = y;

	stage.tower_pool = (t+1)%TOWERS_TOTAL;

    enemies_resource();

    bank_pull_bram();

    unsigned char ret = 1;
    return ret;
}

unsigned char tower_remove(unsigned char t) 
{

    bank_push_set_bram(BRAM_ENGINE_TOWERS);

    palette16_unuse(towers.palette[t]);
    towers.used[t] = 0;
    towers.enabled[t] = 0;

    bank_pull_bram();

    unsigned char ret = 1;
    return ret;
}

// void enemies_resource() {

//     bank_push_set_bram(fe.bram_bank);

// 	for(unsigned char t=0; t<TOWERS_TOTAL; t++) {

// 		if(towers.used[t] && towers.side[t] == SIDE_ENEMY) {	

// 			if (!towers.wait_animation[t]) {
// 				towers.wait_animation[t] = towers.speed_animation[t];
//                 if(towers.direction_animation[t]>0) {
//                     if(towers.state_animation[t] >= towers.stop_animation[t]) {
//                         if(towers.reverse_animation[t]) {
//                             towers.direction_animation[t] = -1;                            
//                         } else {
//                             towers.state_animation[t] = towers.start_animation[t];
//                         }
//                     }
//                 }
 
//                 if(towers.direction_animation[t]<0) {
//                     if(towers.state_animation[t] <= towers.start_animation[t]) {
//                         towers.direction_animation[t] = 1;                            
//                     }
//                 }
//                 towers.state_animation[t] += towers.direction_animation[t];
// 			}
// 			towers.wait_animation[t]--;
//         }
//     }

//     bank_pull_bram();
// }

void tower_paint(sprite_bram_t* turret) 
{

    bank_push_set_bram(BRAM_ENGINE_TOWERS);

    for(unsigned char x=0; x<16; x++) {
        for(unsigned char y=0; y<16; y++) {

            unsigned char rnd = BYTE0(rand());

            byte slab = (BYTE0(rand()) & 0x0F);

            unsigned char floor_slab = floor_cache[y].floor_segment[x];

            if( floor_slab == 15 ) {
                if( rnd < 128 ) {
                    if( stage.tower_count < TOWERS_TOTAL) {
                        tower_add(turret, x, y, 4, 1, 4);
                        stage.tower_count++;
                    }
                }
            }
        }
    }

    bank_pull_bram();
}

void tower_logic() {

    bank_push_set_bram(BRAM_ENGINE_TOWERS);

	for(unsigned char t=0; t<TOWERS_TOTAL; t++) {
		if(towers.used[t] && towers.side[t] == SIDE_ENEMY) {	
            if(game.row == 32) {
                if (towers.y[t] < 8) {
                    towers.used[t] = 0;
                    towers.enabled[t] = 0;
                }
            }

            if(game.row == 0) {
                if (towers.y[t] >= 8) {
                    towers.used[t] = 0;
                    towers.enabled[t] = 0;
                }
            }
		}

		if(towers.used[t] && towers.side[t] == SIDE_ENEMY) {
            signed int py = (signed int)game.screen_vscroll - ((signed int)((unsigned int)towers.y[t])*64); // the screen_vscroll contains the current scroll position.
            signed int px = (signed int)towers.x[t]*64;
            floor_draw_slab(stage.towers, 0, towers.x[t], towers.y[t]);
            vera_sprite_offset sprite_offset = towers.sprite_offset[t];
            vera_sprite_zdepth_in_front(sprite_offset);
            vera_sprite_set_xy_and_image_offset(sprite_offset, px, py, sprite_image_cache_vram(towers.sprite[t], towers.state_animation[t]));
        }
	}
    bank_pull_bram();
}


#pragma data_seg(Data)
