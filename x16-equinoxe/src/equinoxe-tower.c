// Space tile scrolling engine for a space game written in kickc for the Commander X16.


#include <cx16.h>
#include <conio.h>
#include <cx16-conio.h>
#include <stdio.h>
#include <division.h>
#include <multiply.h>

#include "equinoxe-defines.h"
#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-stage.h"
#include "equinoxe-bullet.h"
// #include "equinoxe-palette-lib.h"
#include "equinoxe-floorengine.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"

#include "equinoxe-tower.h"

#pragma data_seg(CodeEngineTowers)
tower_t towers;

#pragma data_seg(Data)


unsigned char tower_add( 
    sprite_index_t turret, 
    unsigned char x, 
    unsigned char y,
    signed int tx,
    signed int ty,
    signed char fx,
    signed char fy,
    unsigned char anim_speed, 
    unsigned char palette_index ) 
{

    bank_push_set_bram(BANK_ENGINE_TOWERS);

	unsigned char t = stage.tower_pool;

	while(towers.used[t]) {
		t = (t+1) % TOWERS_TOTAL;
	}
    stage.tower_count++;

	towers.used[t] = 1;
    towers.offset[t] = 0;

	towers.side[t] = SIDE_ENEMY;

    fe_sprite_index_t s = fe_sprite_cache_copy(turret);
    towers.sprite[t] = s;

	towers.sprite_offset[t] = sprite_next_offset();
	fe_sprite_configure(towers.sprite_offset[t], s);

    // printf("towers t=%u", t);
    // printf(", offset=%6u", towers.sprite_offset[t]);



	towers.anim_wait[t] = anim_speed;
	towers.anim_speed[t] = anim_speed;

    towers.palette[t] = palette_use_vram(palette_index);

	towers.health[t] = 100;

    towers.tx[t] = tx;
    towers.ty[t] = ty;
    towers.fx[t] = fx;
    towers.fy[t] = fy;
    towers.x[t] = x;
    towers.y[t] = y;

	stage.tower_pool = (t+1)%TOWERS_TOTAL;

    bank_pull_bram();

    unsigned char ret = 1;
    return ret;
}

unsigned char tower_remove(unsigned char t)
{
    bank_push_set_bram(BANK_ENGINE_TOWERS);

    if(towers.used[t]) {
        vera_sprite_offset sprite_offset = towers.sprite_offset[t];
        vera_sprite_disable(sprite_offset);
        sprite_free_offset(sprite_offset);
        palette_unuse_vram(sprite_cache.palette_offset[towers.sprite[t]]);
        fe_sprite_cache_free(towers.sprite[t]);

        towers.used[t] = 0;
        towers.enabled[t] = 0;
        towers.sprite[t] = 255;

        stage.tower_count--;
    }

    bank_pull_bram();

    unsigned char ret = 1;
    return ret;
}

unsigned char tower_hit(unsigned char t, unsigned char b) 
{
    bank_push_set_bram(BANK_ENGINE_FLIGHT);

    towers.health[t] += bullet_impact(b);
    if(towers.health[t] <= 0) {
        bank_pull_bram();
        return tower_remove(t);
    }

    bank_pull_bram();
    return 0;
}

void tower_paint(unsigned char row, unsigned char column) 
{
    bank_push_set_bram(BANK_ENGINE_TOWERS);
    unsigned char cache;

    unsigned char rnd = BYTE0(rand());
    unsigned char cache_floor = FLOOR_CACHE(0, row, column);
    unsigned char cache_tower = FLOOR_CACHE(1, row, column);
    unsigned char floor_slab = floor_cache[cache_floor];
    floor_cache[cache_tower] = 0;
    if( floor_slab == 15 ) {
        if( rnd <= 255 ) {
            if( stage.tower_count < TOWERS_TOTAL) {
                floor_cache[cache_tower] = 1;
                bank_push_set_bram(BANK_ENGINE_STAGES);
                stage_tower_t* st = stage.current_playbook.stage_towers;
                sprite_index_t turret = st->turret;
                signed char tx = st->turret_x;
                signed char ty = st->turret_y;
                signed char fx = st->fire_x;
                signed char fy = st->fire_y;
                bank_pull_bram();
                tower_add(turret, column, row, (signed int)column*64+tx, (signed int)ty-(signed int)64-(signed int)(game.screen_vscroll % 16), fx, fy, 4, 4);
            }
        }
    }

    bank_pull_bram();
}

void tower_animate()
{

    bank_push_set_bram(BANK_ENGINE_TOWERS);

	for(unsigned char t=0; t<TOWERS_TOTAL; t++) {
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
                            towers.anim_wait[t] = 40;
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
                        towers.anim_wait[t]--;
                    }
                    break;   
                case 4:
                    // Shot fired
                    towers.state[t] = 5;
                    towers.anim_wait[t] = 0;
                    break;   
                case 5:
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
    }

    bank_pull_bram();
}

void tower_move()
{
    bank_push_set_bram(BANK_ENGINE_TOWERS);

	for(unsigned char t=0; t<TOWERS_TOTAL; t++) {
		if(towers.used[t] && towers.side[t] == SIDE_ENEMY) {
            // todo i need to review this statement as it compiles wrongly like this:
            // signed int py = (signed int)((unsigned int)towers.y[t] * 64) - (signed int)game.screen_vscroll; // the screen_vscroll contains the current scroll position.
            signed int volatile y = towers.ty[t];
            y++;
            towers.ty[t] = y;
        }
	}
    bank_pull_bram();
}

void tower_logic() 
{

    bank_push_set_bram(BANK_ENGINE_TOWERS);

	for(unsigned char t=0; t<TOWERS_TOTAL; t++) {

		if(towers.used[t] && towers.side[t] == SIDE_ENEMY) {

            towers.cx[t] = BYTE0(towers.tx[t] >> 2);
            towers.cy[t] = BYTE0(towers.ty[t] >> 2);

            signed int volatile y = towers.ty[t];
            signed int volatile x = towers.tx[t];
            if(y > 32*16) {
                tower_remove(t);
            } else {
                vera_sprite_offset sprite_offset = towers.sprite_offset[t];
                vera_sprite_zdepth_in_front(sprite_offset);
                vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_image_cache_vram(towers.sprite[t], towers.anim_state[t]));
                // printf("tower logic: t=%u, towers gx=%04u, gy=%04u\n", t, gx, gy);
                collision_insert(towers.cx[t], towers.cy[t], COLLISION_TOWER | t);
                if(towers.anim_state[t] == 3) {
                    #ifdef __BULLET                
                    signed int volatile py = towers.ty[t];
                    if(py>0) {
                        unsigned char rnd = rand();
                        if( rnd < 32 ) {
                            FireBulletTower(t);
                        }
                    }
                    #endif
                }
            }

        }
	}
    bank_pull_bram();
}

#pragma data_seg(Data)
