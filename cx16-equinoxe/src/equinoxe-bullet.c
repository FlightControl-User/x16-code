#include <cx16-mouse.h>
#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-bullet.h"
#include "equinoxe-collision.h"
#include "equinoxe-math.h"
#include "equinoxe-stage.h"

void bullet_init()
{
    bank_push_bram(FE_BULLET_BANK);
    memset(&bullet, 0, sizeof(fe_bullet_t));
    bank_pull_bram();
}

void FireBullet(unsigned char p, char reload)
{
    bank_push_bram(FE_BULLET_BANK);

    if(stage.sprite_bullet_count<FE_BULLET) {

        printf("player bullet=%03u. ", stage.sprite_bullet_count);

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

        sprite_t* sprite = &SpriteBullet01;
        bullet.sprite_type[b] = sprite;
        sprite_vram_allocate(sprite, vera_heap_segment_sprites);

        bullet.sprite_offset[b] = NextOffset(SPRITE_OFFSET_BULLET_START, SPRITE_OFFSET_BULLET_END, &stage.sprite_bullet, &stage.sprite_bullet_count);
        sprite_configure(bullet.sprite_offset[b], bullet.sprite_type[b]);

        bullet.sprite_palette[b] = sprite->PaletteOffset;
        sprite_palette(bullet.sprite_offset[b], bullet.sprite_palette[b]);

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
    bank_pull_bram();
}

void FireBulletEnemy(unsigned char e)
{
    bank_push_bram(FE_BULLET_BANK);

    if(stage.sprite_bullet_count<FE_BULLET) {


    
        unsigned char b = bullet_pool;

        printf("enemy bullet=%03u, b=%u, bram=%u. ", stage.sprite_bullet_count, b, bank_get_bram());
    
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

        sprite_t* sprite = &SpriteBullet02;

        bullet.sprite_type[b] = sprite;
        sprite_vram_allocate(sprite, vera_heap_segment_sprites);

        bullet.sprite_offset[b] = NextOffset(SPRITE_OFFSET_BULLET_START, SPRITE_OFFSET_BULLET_END, &stage.sprite_bullet, &stage.sprite_bullet_count);
        sprite_configure(bullet.sprite_offset[b], bullet.sprite_type[b]);

        bullet.sprite_palette[b] = sprite->PaletteOffset;
        sprite_palette(bullet.sprite_offset[b], bullet.sprite_palette[b]);

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
    bank_pull_bram();
}


void RemoveBullet(unsigned char b) 
{
    bank_push_bram(FE_BULLET_BANK);

    vera_sprite_offset sprite_offset = bullet.sprite_offset[b];
    FreeOffset(sprite_offset, &stage.sprite_bullet_count);
    vera_sprite_disable(sprite_offset);
    palette16_unuse(bullet.sprite_palette[b]);
    sprite_vram_free(bullet.sprite_type[b], vera_heap_segment_sprites);
    bullet.used[b] = 0;
    bullet.enabled[b] = 0;

    bank_pull_bram();
}


void LogicBullets()
{
    bank_push_bram(FE_BULLET_BANK);

    for(unsigned char b=0; b<FE_BULLET; b++) {

        if(bullet.used[b]) {
            vera_sprite_offset sprite_offset = bullet.sprite_offset[b];
            sprite_t* sprite = bullet.sprite_type[b];


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
                vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite->vram_image_offset[bullet.state_animation[b]]);
				grid_insert(&ht_collision, 3, BYTE0(x>>2), BYTE0(y>>2), b);
            }

            // gotoxy(0,21);
            // printf("bullet count=%2u, #=%2u", stage.sprite_bullet_count, stage.sprite_bullet);

        }
        
    }

    bank_pull_bram();
}
