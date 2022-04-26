#include <cx16-mouse.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-bullet.h"
#include "equinoxe-stage.h"
#include "equinoxe-collision.h"
#include "equinoxe-math.h"

void FireBullet(unsigned char p, char reload)
{

    if(stage.sprite_bullet_count<FE_BULLET) {

        gotoxy(0,2);
        printf("bullet count = %03u", stage.sprite_bullet_count);

        unsigned char b = bullet_pool;

        while(bullet.used[b]) {
            b = (b+1)%FE_BULLET;
        }

        unsigned int x = (unsigned int)game.curr_mousex;
        unsigned int y = (unsigned int)game.curr_mousey;

        if(player.firegun[p])
            x += (signed char)16;

        player.reload[p] = reload;
        player.firegun[p] = player.firegun[p]^1;

        bullet.used[b] = 1;
        bullet.enabled[b] = 0;
        bullet.side[b] = SIDE_PLAYER;


        bullet.sprite_offset[b] = NextOffset(SPRITE_OFFSET_BULLET_START, SPRITE_OFFSET_BULLET_END, &stage.sprite_bullet, &stage.sprite_bullet_count);
        bullet.sprite_type[b] = &SpriteBullet01;
        sprite_configure(bullet.sprite_offset[b], bullet.sprite_type[b]);

        bullet.tx[b] = MAKELONG(x, 0);
        bullet.ty[b] = MAKELONG(y, 0);
        bullet.tdx[b] = MAKELONG(0, 0);
        bullet.tdy[b] = MAKELONG(0xFFF8, 0x0000);

        bullet.aabb_min_x[b] = SpriteBullet01.aabb[0];
        bullet.aabb_min_y[b] = SpriteBullet01.aabb[1];
        bullet.aabb_max_x[b] = SpriteBullet01.aabb[2];
        bullet.aabb_max_y[b] = SpriteBullet01.aabb[3];

        bullet.energy[b] = -50;

        bullet_pool = (b+1)%FE_BULLET;
    }
}

void FireBulletEnemy(unsigned char e)
{
    if(stage.sprite_bullet_count<FE_BULLET) {

        gotoxy(0,2);
        printf("bullet count = %03u", stage.sprite_bullet_count);

        unsigned char b = bullet_pool;

        while(bullet.used[b]) {
            b = (b+1)%FE_BULLET;
        }

        unsigned int ex = (unsigned int)WORD1(enemy.tx[e]);
        unsigned int ey = (unsigned int)WORD1(enemy.ty[e]);
        unsigned int px = (unsigned int)game.curr_mousex;
        unsigned int py = (unsigned int)game.curr_mousey;

        bullet.used[b] = 1;
        bullet.enabled[b] = 0;
        bullet.side[b] = SIDE_ENEMY;

        bullet.sprite_offset[b] = NextOffset(SPRITE_OFFSET_BULLET_START, SPRITE_OFFSET_BULLET_END, &stage.sprite_bullet, &stage.sprite_bullet_count);
        bullet.sprite_type[b] = &SpriteBullet02;
        sprite_configure(bullet.sprite_offset[b], bullet.sprite_type[b]);

        bullet.tx[b] = MAKELONG(ex, 0);
        bullet.ty[b] = MAKELONG(ey, 0);

        unsigned char angle = math_atan2(BYTE0(ex>>2), BYTE0(px>>2), BYTE0(ey>>2), BYTE0(py>>2));

        bullet.tdx[b] = math_vecx(angle-16, 3);
        bullet.tdy[b] = math_vecy(angle-16, 3); 

        bullet.aabb_min_x[b] = SpriteBullet01.aabb[0];
        bullet.aabb_min_y[b] = SpriteBullet01.aabb[1];
        bullet.aabb_max_x[b] = SpriteBullet01.aabb[2];
        bullet.aabb_max_y[b] = SpriteBullet01.aabb[3];

        bullet.energy[b] = -25;

        bullet_pool = (b+1)%FE_BULLET;
    }
}


void RemoveBullet(unsigned char b) 
{
    vera_sprite_offset sprite_offset = bullet.sprite_offset[b];
    FreeOffset(sprite_offset, &stage.sprite_bullet_count);
    vera_sprite_disable(sprite_offset);
    bullet.used[b] = 0;
    bullet.enabled[b] = 0;
}


inline void LogicBullets()
{
    if(!stage.sprite_bullet_count) return;

    for(unsigned char b=0; b<FE_BULLET-1; b++) {

        if(bullet.used[b]) {
            vera_sprite_offset sprite_offset = bullet.sprite_offset[b];
            Sprite* sprite = bullet.sprite_type[b];


            bullet.tx[b] += bullet.tdx[b];
            bullet.ty[b] += bullet.tdy[b];

            signed int x = (signed int)WORD1(bullet.tx[b]);
            signed int y = (signed int)WORD1(bullet.ty[b]);

            if(y < -32 || x < -32 || x > 640 || y > 480) {
                RemoveBullet(b);
            } else {
                if(!bullet.enabled[b]) {
                    vera_sprite_zdepth(sprite_offset, sprite->Zdepth);
                    bullet.enabled[b] = 1;
                }            
                vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite->offset_image[0]);
				grid_insert(&ht_collision, 3, BYTE0(x>>2), BYTE0(y>>2), b);
            }

            // gotoxy(0,21);
            // printf("bullet count=%2u, #=%2u", stage.sprite_bullet_count, stage.sprite_bullet);

        }
        
    }
}
