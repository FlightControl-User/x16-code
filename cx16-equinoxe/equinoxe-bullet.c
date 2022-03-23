#include <cx16-mouse.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-bullet.h"
#include "equinoxe-stage.h"
#include "equinoxe-collision.h"

void FireBullet(unsigned char p, char reload)
{

	unsigned char b = bullet.pool;

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

    bullet.pool = (b+1)%FE_BULLET;
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
    if(!bullet.pool) return;

    for(unsigned char b=FE_BULLET_LO; b<FE_BULLET; b++) {

        if(bullet.used[b]) {
            vera_sprite_offset sprite_offset = bullet.sprite_offset[b];
            Sprite* sprite = bullet.sprite_type[b];


            bullet.tx[b] += bullet.tdx[b];
            bullet.ty[b] += bullet.tdy[b];

            signed int x = (signed int)WORD1(bullet.tx[b]);
            signed int y = (signed int)WORD1(bullet.ty[b]);

            if(y < -32) {
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
