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
#include "equinoxe-animate.h"
#include "equinoxe-palette.h"

// #pragma var_model(mem)

#ifdef __BANKING
#pragma code_seg(SEGM_ENGINE_BULLETS)
#pragma data_seg(SEGM_ENGINE_BULLETS)
#pragma bank(ram,BRAM_ENGINE_BULLETS)
#endif

fe_bullet_t bullet; // This memory area is banked and must always be reached by local routines in the same bank for efficiency!

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
    unsigned char a = animate_add();
    bullet.animate[b] = a;

    animate.used[a] = 1;
    animate.wait[a] = 0;
    animate.speed[a] = 0;
    animate.state[a] = 0;
    animate.reverse[a] = sprite_cache.reverse[s];
    animate.loop[a] = sprite_cache.loop[s];
    animate.count[a] = sprite_cache.count[s];
    if(animate.count[a]>1)
        animate.direction[a] = 1;
    else
        animate.direction[a] = 0;

    // printf("b=%3u, a=%3u", b, a);

    return a;
}

void bullet_sprite_animate_del(unsigned char b)
{
    unsigned char a = bullet.animate[b];
    animate.used[a] = 0;
    stage.animate_count--;
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

        bullet.energy[b] = -10;

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

        bullet.energy[b] = -25;

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

        bullet.energy[b] = -50;

        stage.bullet_pool = (b+1)%FE_BULLET;
    }
}


void bullet_remove(unsigned char b) 
{
    if(bullet.used[b]) {
        vera_sprite_offset sprite_offset = bullet.sprite_offset[b];
        vera_sprite_disable(sprite_offset);
        sprite_free_offset(sprite_offset);
        palette16_unuse(sprite_cache.palette_offset[bullet.sprite[b]]);
        fe_sprite_cache_free(bullet.sprite[b]);
        bullet.used[b] = 0;
        bullet.enabled[b] = 0;
        bullet.sprite[b] = 255;

        stage.bullet_count--;
        bullet_sprite_animate_del(b);
    }
}

signed char bullet_energy_get(unsigned char b) {
    signed char energy = bullet.energy[b];
    return energy;
}

void bullet_logic()
{
    for(unsigned char b=0; b<FE_BULLET; b++) {

        if(bullet.used[b]) {
            vera_sprite_offset sprite_offset = bullet.sprite_offset[b];

            bullet.tx[b] += bullet.tdx[b];
            bullet.ty[b] += bullet.tdy[b];

            volatile signed int x = (signed int)WORD1(bullet.tx[b]);
            volatile signed int y = (signed int)WORD1(bullet.ty[b]);


            if(y>-32 && x>-32 && x<640 && y<480) {
                if(!bullet.enabled[b]) {
                    vera_sprite_zdepth(sprite_offset, sprite_cache.zdepth[bullet.sprite[b]]);
                    bullet.enabled[b] = 1;
                }
                unsigned char volatile a = bullet.animate[b];
				if(animate.wait[a]) {
					vera_sprite_set_xy(sprite_offset, x, y);
				} else {
					// vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_cache.vram_image_offset[(unsigned int)bullet.sprite[b]*16+bullet.state_animation[b]]);
					vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_image_cache_vram(bullet.sprite[b], animate.state[a]));
				}
                animate_logic(a);
				collision_insert(&ht_collision, BYTE0(x>>2), BYTE0(y>>2), COLLISION_BULLET | b);
            } else {
                bullet_remove(b);
            }
        }
    }
}

// Unbanked functions

#pragma code_seg(Code)
#pragma data_seg(Data)
#pragma nobank(dummy)


inline void bullet_bank() {
    bank_push_set_bram(BRAM_ENGINE_BULLETS);
}

inline void bullet_unbank() {
    bank_pull_bram();
}


// #pragma var_model(mem)
