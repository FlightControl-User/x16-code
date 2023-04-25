#include <cx16.h>
#include <cx16-mouse.h>
#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-bullet.h"
#include "equinoxe-collision.h"
#include "equinoxe-math.h"
#include "equinoxe-stage.h"
#include "equinoxe-levels.h"
#include "equinoxe-tower.h"
#include "equinoxe-animate-lib.h"
#include "equinoxe-palette-lib.h"

// #pragma var_model(mem)

#ifdef __BANKING
#pragma code_seg(CODE_ENGINE_BULLETS)
#pragma data_seg(CODE_ENGINE_BULLETS)
#pragma bank(cx16_ram,BANK_ENGINE_BULLETS)
#endif

void bullet_init()
{
}



void bullet_sprite_offset_set(unsigned char b, unsigned char s)
{
    vera_sprite_offset offset = sprite_next_offset();
    flight.sprite_offset[b] = offset;
    fe_sprite_configure(offset, s);
}


unsigned char bullet_sprite_animate_add(unsigned char b, unsigned char s)
{
    unsigned char a = animate_add(sprite_cache.count[s], 0, sprite_cache.loop[s], 0, 1, sprite_cache.reverse[s]);
    flight.animate[b] = a;

    return a;
}

void bullet_sprite_animate_del(unsigned char b)
{
    unsigned char a = flight.animate[b];
    animate_del(a);
}

void bullet_add(unsigned int sx, unsigned int sy, unsigned int tx, unsigned int ty, unsigned char speed, flight_side_t side, sprite_index_t sprite_bullet)
{
    stage.bullet_count++;

    flight_index_t b = flight_add(FLIGHT_BULLET, side, sprite_bullet);

    unsigned char asx = BYTE0(sx >> 2);
    unsigned char asy = BYTE0(sy >> 2);
    unsigned char atx = BYTE0(tx >> 2); 
    unsigned char aty = BYTE0(ty >> 2);

    unsigned char angle = math_atan2(asx, atx, asy, aty);

    flight.tdx[b] = math_vecx(angle-16, speed);
    flight.tdy[b] = math_vecy(angle-16, speed);

    flight.tx[b] = MAKELONG(sx, 0);
    flight.ty[b] = MAKELONG(sy, 0);

    flight.speed[b] = speed; 
    flight.impact[b] = -100;

    flight.animate[b] = animate_add(
        sprite_cache.count[flight.sprite[b]], 
        0, 
        sprite_cache.loop[flight.sprite[b]], 
        1, 
        1, 
        sprite_cache.reverse[flight.sprite[b]]);
}

/*
void FireBulletTower(unsigned char t)
{
    if(stage.bullet_count<FE_BULLET) {

        stage.bullet_count++;

        unsigned char b = stage.bullet_pool;

        while(flight.used[b]) {
            b = (b+1)%FE_BULLET;
        }

        flight.used[b] = 1;
        flight.enabled[b] = 0;
        flight.side[b] = SIDE_ENEMY;

        fe_sprite_index_t s = bullet_sprite_cache(b, b003);
        bullet_sprite_offset_set(b, s);

        
        // signed int volatile ex = towers.tx[t] + towers.fx[t];
        // signed int volatile ey = towers.ty[t] + towers.fy[t];

        // printf("ex=%i, ey=%i ", ex, ey);

        flight.tx[b] = MAKELONG((unsigned int)((unsigned int)towers.tx[t] + (unsigned int)towers.fx[t]), 0);
        flight.ty[b] = MAKELONG((unsigned int)((unsigned int)towers.ty[t] + (unsigned int)towers.fy[t]), 0);

        unsigned char angle = 90;

        flight.tdx[b] = 0;
        flight.tdy[b] = MAKELONG((unsigned int)8, 0); 

        bullet_sprite_animate_add(b, s);

        flight.impact[b] = -50;

        stage.bullet_pool = (b+1)%FE_BULLET;
    }
}
*/

void bullet_remove(flight_index_t b) 
{
    if(flight.used[b]) {
        flight_remove(b);

        bullet_sprite_animate_del(b);
        stage.bullet_count--;
    }
}

void bullet_logic()
{
    for(unsigned char b=0; b<FLIGHT_OBJECTS; b++) {

        if(flight.type[b] == FLIGHT_BULLET && flight.used[b]) {

            vera_sprite_offset sprite_offset = flight.sprite_offset[b];

            flight.tx[b] += flight.tdx[b];
            flight.ty[b] += flight.tdy[b];

            unsigned int x = WORD1(flight.tx[b]);
            unsigned int y = WORD1(flight.ty[b]);

            if(x<640 && y<480 && y<0xFFFF-32 && x<0xFFFF-32) {

                if(!flight.enabled[b]) {
                    vera_sprite_zdepth(sprite_offset, sprite_cache.zdepth[flight.sprite[b]]);
                    flight.enabled[b] = 1;
                }

                unsigned char volatile a = flight.animate[b];
				if(animate_is_waiting(a)) {
					vera_sprite_set_xy(sprite_offset, (signed int)x, (signed int)y);
				} else {
					// vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_cache.vram_image_offset[(unsigned int)flight.sprite[b]*16+flight.state_animation[b]]);
					vera_sprite_set_xy_and_image_offset(sprite_offset, (signed int)x, (signed int)y, sprite_image_cache_vram(flight.sprite[b], animate_get_state(a)));
				}
                animate_logic(a);

                unsigned char cx = BYTE0(x >> 2);
                unsigned char cy = BYTE0(y >> 2);
                flight.cx[b] = cx;
                flight.cy[b] = cy;

                flight.collided[b] = 0;
				collision_insert(cx, cy, b);
            } else {
                bullet_remove(b);
            }
        }
    }
}

// Unbanked functions

#pragma code_seg(Code)
#pragma data_seg(Data)
#pragma nobank


inline void bullet_bank() {
    bank_push_set_bram(BANK_ENGINE_BULLETS);
}

inline void bullet_unbank() {
    bank_pull_bram();
}

signed char bullet_impact(unsigned char b) {
    signed char impact = flight.impact[b];
    return impact;
}


// This will need rework
unsigned char bullet_has_collided(unsigned char b) {
	unsigned char collided = flight.collided[b];
	return collided;
}


// #pragma var_model(mem)
