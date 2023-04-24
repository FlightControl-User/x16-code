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

fe_bullet_t bullet; ///< This memory area is banked and must always be reached by local routines in the same bank for efficiency!

#ifdef __BANKING
#pragma code_seg(CODE_ENGINE_BULLETS)
#pragma data_seg(CODE_ENGINE_BULLETS)
#pragma bank(cx16_ram,BANK_ENGINE_BULLETS)
#endif

void bullet_init()
{
    memset(&bullet, 0, sizeof(fe_bullet_t));
}

unsigned char bullet_sprite_cache(unsigned char b, sprite_index_t sprite)
{
    fe_sprite_index_t s = fe_sprite_cache_copy(sprite);
    bullet.sprite[b] = s;
    return s;
}


void bullet_sprite_offset_set(unsigned char b, unsigned char s)
{
    vera_sprite_offset offset = sprite_next_offset();
    bullet.sprite_offset[b] = offset;
    fe_sprite_configure(offset, s);
}


unsigned char bullet_sprite_animate_add(unsigned char b, unsigned char s)
{
    unsigned char a = animate_add(sprite_cache.count[s], sprite_cache.loop[s], 0, 1, sprite_cache.reverse[s]);
    bullet.animate[b] = a;

    return a;
}

void bullet_sprite_animate_del(unsigned char b)
{
    unsigned char a = bullet.animate[b];
    animate_del(a);
}

void bullet_player_fire(unsigned int x, unsigned int y)
{
    if(stage.bullet_count<FE_BULLET) {

        stage.bullet_count++;

        unsigned char b = stage.bullet_pool;

        while(bullet.used[b]) {
            b = (b+1)%FE_BULLET;
        }


        bullet.used[b] = 1;
        bullet.enabled[b] = 0;
        bullet.side[b] = SIDE_PLAYER;

        fe_sprite_index_t s = bullet_sprite_cache(b, b001);
        bullet_sprite_offset_set(b, s);


        bullet.tx[b] = MAKELONG(x, 0);
        bullet.ty[b] = MAKELONG(y, 0);

        // unsigned char angle = math_atan2(BYTE0(px>>2), BYTE0(tx>>2), BYTE0(py>>2), BYTE0(ty>>2));

        // bullet.tdx[b] = math_vecx(angle-16, 3);
        // bullet.tdy[b] = math_vecy(angle-16, 3); 

        bullet.tdx[b] = MAKELONG(0, 0);
        bullet.tdy[b] = MAKELONG(0xFFF8, 0x0000);

        bullet_sprite_animate_add(b, s);

        
        bullet.impact[b] = -100;

        stage.bullet_pool = (b+1)%FE_BULLET;
    }
}

void bullet_enemy_fire(unsigned int x, unsigned int y)
{
    if(stage.bullet_count<FE_BULLET) {

        stage.bullet_count++;

        unsigned char b = stage.bullet_pool;

        while(bullet.used[b]) {
            b = (b+1)%FE_BULLET;
        }

        unsigned int ex = x;
        unsigned int ey = y;
        unsigned int px = (unsigned int)cx16_mouse.x;
        unsigned int py = (unsigned int)cx16_mouse.y;

        bullet.used[b] = 1;
        bullet.enabled[b] = 0;
        bullet.side[b] = SIDE_ENEMY;


        fe_sprite_index_t s = bullet_sprite_cache(b, b002);
        bullet_sprite_offset_set(b, s);

        bullet.tx[b] = MAKELONG(ex, 0);
        bullet.ty[b] = MAKELONG(ey, 0);

        unsigned char angle = math_atan2(BYTE0(ex>>2), BYTE0(px>>2), BYTE0(ey>>2), BYTE0(py>>2));

        bullet.tdx[b] = math_vecx(angle-16, 3);
        bullet.tdy[b] = math_vecy(angle-16, 3); 

        bullet_sprite_animate_add(b, s);

        bullet.impact[b] = -25;

        stage.bullet_pool = (b+1)%FE_BULLET;
    }
}

void FireBulletTower(unsigned char t)
{
    if(stage.bullet_count<FE_BULLET) {

        stage.bullet_count++;

        unsigned char b = stage.bullet_pool;

        while(bullet.used[b]) {
            b = (b+1)%FE_BULLET;
        }

        bullet.used[b] = 1;
        bullet.enabled[b] = 0;
        bullet.side[b] = SIDE_ENEMY;

        fe_sprite_index_t s = bullet_sprite_cache(b, b003);
        bullet_sprite_offset_set(b, s);

        
        // signed int volatile ex = towers.tx[t] + towers.fx[t];
        // signed int volatile ey = towers.ty[t] + towers.fy[t];

        // printf("ex=%i, ey=%i ", ex, ey);

        bullet.tx[b] = MAKELONG((unsigned int)((unsigned int)towers.tx[t] + (unsigned int)towers.fx[t]), 0);
        bullet.ty[b] = MAKELONG((unsigned int)((unsigned int)towers.ty[t] + (unsigned int)towers.fy[t]), 0);

        unsigned char angle = 90;

        bullet.tdx[b] = 0;
        bullet.tdy[b] = MAKELONG((unsigned int)8, 0); 

        bullet_sprite_animate_add(b, s);

        bullet.impact[b] = -50;

        stage.bullet_pool = (b+1)%FE_BULLET;
    }
}


void bullet_remove(unsigned char b) 
{
    if(bullet.used[b]) {
        
        vera_sprite_offset sprite_offset = bullet.sprite_offset[b];
        vera_sprite_disable(sprite_offset);
        sprite_free_offset(sprite_offset);
        palette_unuse_vram(sprite_cache.palette_offset[bullet.sprite[b]]);
        fe_sprite_cache_free(bullet.sprite[b]);
        bullet.used[b] = 0;
        bullet.enabled[b] = 0;
        bullet.collided[b] = 1;
        bullet.sprite[b] = 255;

        bullet_sprite_animate_del(b);
        stage.bullet_count--;
    }
}

void bullet_logic()
{
    for(unsigned char b=0; b<FE_BULLET; b++) {

        if(bullet.used[b]) {
            vera_sprite_offset sprite_offset = bullet.sprite_offset[b];

            bullet.tx[b] += bullet.tdx[b];
            bullet.ty[b] += bullet.tdy[b];

            bullet.cx[b] = BYTE0(WORD1(bullet.tx[b]) >> 2);
            bullet.cy[b] = BYTE0(WORD1(bullet.ty[b]) >> 2);

            volatile signed int x = (signed int)WORD1(bullet.tx[b]);
            volatile signed int y = (signed int)WORD1(bullet.ty[b]);



            if(y>-32 && x>-32 && x<640 && y<480) {
                if(!bullet.enabled[b]) {
                    vera_sprite_zdepth(sprite_offset, sprite_cache.zdepth[bullet.sprite[b]]);
                    bullet.enabled[b] = 1;
                }
                unsigned char volatile a = bullet.animate[b];
				if(animate_is_waiting(a)) {
					vera_sprite_set_xy(sprite_offset, x, y);
				} else {
					// vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_cache.vram_image_offset[(unsigned int)bullet.sprite[b]*16+bullet.state_animation[b]]);
					vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_image_cache_vram(bullet.sprite[b], animate_get_state(a)));
				}
                animate_logic(a);
                bullet.collided[b] = 0;
				collision_insert(bullet.cx[b], bullet.cy[b], COLLISION_BULLET | b);
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
    
	bullet_bank();
    signed char impact = bullet.impact[b];
	bullet_unbank();
    return impact;
}


// This will need rework
unsigned char bullet_has_collided(unsigned char b) {
	bullet_bank();
	unsigned char collided = bullet.collided[b];
	bullet_unbank();
	return collided;
}


// #pragma var_model(mem)
