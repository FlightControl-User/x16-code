#include <cx16-mouse.h>
#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-bullet.h"
#include "equinoxe-collision.h"
#include "equinoxe-math.h"
#include "equinoxe-stage.h"
#include "equinoxe-levels.h"

void bullet_init()
{
    bank_push_bram(); bank_set_bram(fe.bram_bank);
    memset(&bullet, 0, sizeof(fe_bullet_t));
    bank_pull_bram();
}

void FireBullet(unsigned char p, char reload)
{
    bank_push_bram(); bank_set_bram(fe.bram_bank);

    if(stage.sprite_bullet_count<FE_BULLET) {

        unsigned char b = fe.bullet_pool;

        while(bullet.used[b]) {
            b = (b+1)%FE_BULLET;
        }

        unsigned int x = (unsigned int)cx16_mouse.x;
        unsigned int y = (unsigned int)cx16_mouse.y;

        if(player.firegun[p])
            x += (signed char)16;

        player.reload[p] = reload;
        player.firegun[p] = player.firegun[p]^1;

        bullet.used[b] = 1;
        bullet.enabled[b] = 0;
        bullet.side[b] = SIDE_PLAYER;


        fe_sprite_index_t s = fe_sprite_cache_copy(&sprite_b001);
        bullet.sprite[b] = s;

        bullet.sprite_offset[b] = NextOffset(SPRITE_OFFSET_BULLET_START, SPRITE_OFFSET_BULLET_END, &stage.sprite_bullet, &stage.sprite_bullet_count);
        fe_sprite_configure(bullet.sprite_offset[b], s);

        bullet.tx[b] = MAKELONG(x, 0);
        bullet.ty[b] = MAKELONG(y, 0);
        bullet.tdx[b] = MAKELONG(0, 0);
        bullet.tdy[b] = MAKELONG(0xFFF8, 0x0000);

        bullet.wait_animation[b] = 2;
        bullet.speed_animation[b] = 4;
        bullet.state_animation[b] = 0;
        bullet.reverse_animation[b] = sprite_cache.reverse[s];
        bullet.start_animation[b] = 0;
        bullet.stop_animation[b] = sprite_cache.count[s]-1;
        bullet.direction_animation[b] = 1;

        bullet.energy[b] = -50;

        fe.bullet_pool = (b+1)%FE_BULLET;
    }
    bank_pull_bram();
}

void FireBulletEnemy(unsigned char e)
{
    bank_push_bram(); bank_set_bram(fe.bram_bank);

    if(stage.sprite_bullet_count<FE_BULLET) {

        unsigned char b = fe.bullet_pool;

        while(bullet.used[b]) {
            b = (b+1)%FE_BULLET;
        }

        unsigned int ex = (unsigned int)WORD1(enemy.tx[e]);
        unsigned int ey = (unsigned int)WORD1(enemy.ty[e]);
        unsigned int px = (unsigned int)cx16_mouse.x;
        unsigned int py = (unsigned int)cx16_mouse.y;

        bullet.used[b] = 1;
        bullet.enabled[b] = 0;
        bullet.side[b] = SIDE_ENEMY;

        fe_sprite_index_t s = fe_sprite_cache_copy(&sprite_b002);
        bullet.sprite[b] = s;

        bullet.sprite_offset[b] = NextOffset(SPRITE_OFFSET_BULLET_START, SPRITE_OFFSET_BULLET_END, &stage.sprite_bullet, &stage.sprite_bullet_count);
        fe_sprite_configure(bullet.sprite_offset[b], s);

        bullet.tx[b] = MAKELONG(ex, 0);
        bullet.ty[b] = MAKELONG(ey, 0);

        unsigned char angle = math_atan2(BYTE0(ex>>2), BYTE0(px>>2), BYTE0(ey>>2), BYTE0(py>>2));

        bullet.tdx[b] = math_vecx(angle-16, 3);
        bullet.tdy[b] = math_vecy(angle-16, 3); 

        bullet.wait_animation[b] = 2;
        bullet.speed_animation[b] = 4;
        bullet.state_animation[b] = 0;
        bullet.reverse_animation[b] = sprite_cache.reverse[s];
        bullet.start_animation[b] = 0;
        bullet.stop_animation[b] = sprite_cache.count[s]-1;
        bullet.direction_animation[b] = 1;

        bullet.energy[b] = -25;

        fe.bullet_pool = (b+1)%FE_BULLET;
    }
    bank_pull_bram();
}


void bullet_remove(unsigned char b) 
{
    bank_push_bram(); bank_set_bram(fe.bram_bank);

    vera_sprite_offset sprite_offset = bullet.sprite_offset[b];
    FreeOffset(sprite_offset, &stage.sprite_bullet_count);
    vera_sprite_disable(sprite_offset);
    palette16_unuse(sprite_cache.palette_offset[bullet.sprite[b]]);
    fe_sprite_cache_free(bullet.sprite[b]);
    bullet.used[b] = 0;
    bullet.enabled[b] = 0;
    bullet.sprite[b] = 255;

    bank_pull_bram();
}


void LogicBullets()
{
    bank_push_bram(); bank_set_bram(fe.bram_bank);

    for(unsigned char b=0; b<FE_BULLET; b++) {

        if(bullet.used[b]) {
            vera_sprite_offset sprite_offset = bullet.sprite_offset[b];

            bullet.tx[b] += bullet.tdx[b];
            bullet.ty[b] += bullet.tdy[b];

            signed int x = (signed int)WORD1(bullet.tx[b]);
            signed int y = (signed int)WORD1(bullet.ty[b]);

			if (!bullet.wait_animation[b]) {
				bullet.wait_animation[b] = bullet.speed_animation[b];
                bullet.state_animation[b] += bullet.direction_animation[b];
                if(bullet.direction_animation[b]>0) {
                    if(bullet.state_animation[b] >= bullet.stop_animation[b]) {
                        if(bullet.reverse_animation[b]) {
                            bullet.direction_animation[b] = -1;                            
                        } else {
                            bullet.state_animation[b] = bullet.start_animation[b];
                        }
                    }
                }
 
                if(bullet.direction_animation[b]<0) {
                    if(bullet.state_animation[b] <= bullet.start_animation[b]) {
                        bullet.direction_animation[b] = 1;                            
                    }
                }
			}
			bullet.wait_animation[b]--;

            if(y < -32 || x < -32 || x > 640 || y > 480) {
                bullet_remove(b);
            } else {
                if(!bullet.enabled[b]) {
                    vera_sprite_zdepth(sprite_offset, sprite_cache.zdepth[bullet.sprite[b]]);
                    bullet.enabled[b] = 1;
                }
				if(bullet.wait_animation[b]) {
					vera_sprite_set_xy(sprite_offset, x, y);
				} else {
					// vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_cache.vram_image_offset[(unsigned int)bullet.sprite[b]*16+bullet.state_animation[b]]);
					vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_image_cache_vram(bullet.sprite[b], bullet.state_animation[b]));
				}
				grid_insert(&ht_collision, 3, BYTE0(x>>2), BYTE0(y>>2), b);
            }

        }
        
    }

    bank_pull_bram();
}
