#include <cx16-mouse.h>

#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-flightengine-types.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"
#include "equinoxe-stage.h"
#include "equinoxe-player.h"
#include "equinoxe-bullet.h"
#include "levels/equinoxe-levels.h"


#ifdef __PLAYER

void player_init()
{
    bank_push_set_bram(fe.bram_bank);

    memset(&player, 0, sizeof(fe_player_t));
    memset(&engine, 0, sizeof(fe_engine_t));

    bank_pull_bram();
}

void player_add() 
{

    bank_push_bram(); bank_set_bram(fe.bram_bank);

	// player
	unsigned char p = fe.player_pool;

	while(player.used[p]) {
		p = (p+1)%FE_PLAYER;
	}
	
	player.used[p] = 1;
	player.enabled[p] = 0;

	player.moved[p] = 2;

	player.firegun[p] = 0;
	player.reload[p] = 0;

	player.speed_animation[p] = 8;
	player.wait_animation[p] = player.speed_animation[p];
	player.state_animation[p] = 3;

    unsigned char s = fe_sprite_cache_copy(&sprite_player_01);
    player.sprite[p] = s;

	player.sprite_offset[p] = NextOffset(SPRITE_OFFSET_PLAYER_START, SPRITE_OFFSET_PLAYER_END, &stage.sprite_player, &stage.sprite_player_count);
	fe_sprite_configure(player.sprite_offset[p], s);


	player.tx[p] = MAKELONG(320, 0);
	player.ty[p] = MAKELONG(200, 0);
	player.tdx[p] = 0;
	player.tdy[p] = 0;

    player.health[p] = 100;

	fe.player_pool = (p+1)%FE_PLAYER;

	// Engine
	while(engine.used[fe.engine_pool]) {
		fe.engine_pool = (fe.engine_pool++)%FE_ENGINE;
	}

	unsigned char n = fe.engine_pool;

	player.engine[p] = n;

	engine.used[p] = 1;

	engine.speed_animation[n] = 1;
	engine.wait_animation[n] = engine.speed_animation[n];

    unsigned char cn = fe_sprite_cache_copy(&sprite_engine_01);
    engine.sprite[n] = cn;

	engine.sprite_offset[n] = NextOffset(SPRITE_OFFSET_PLAYER_START, SPRITE_OFFSET_PLAYER_END, &stage.sprite_player, &stage.sprite_player_count);
	fe_sprite_configure(engine.sprite_offset[n], cn);

	fe.engine_pool = (fe.engine_pool++)%FE_ENGINE;

    // stage.player_xor = player_checkxor();

    bank_pull_bram();

}

void player_remove(unsigned char p, unsigned char b) 
{

    bank_push_bram(); bank_set_bram(fe.bram_bank);

    player.health[p] += bullet.energy[b];

    if(player.health[p] <= 0) {

        vera_sprite_offset sprite_offset = player.sprite_offset[p];
        FreeOffset(sprite_offset, &stage.sprite_player_count);
        vera_sprite_disable(sprite_offset);
        palette16_unuse(sprite_cache.palette_offset[player.sprite[p]]);
        fe_sprite_cache_free(player.sprite[p]);
        player.used[p] = 0;
        player.enabled[p] = 0;

        unsigned char n = player.engine[p];
        sprite_offset = engine.sprite_offset[n];
        FreeOffset(sprite_offset, &stage.sprite_player_count);
        vera_sprite_disable(sprite_offset);
        palette16_unuse(sprite_cache.palette_offset[engine.sprite[n]]);
        fe_sprite_cache_free(engine.sprite[n]);
        engine.used[n] = 0;

        stage.lives--;
        stage.respawn = 64;
    }

    // stage.player_xor = player_checkxor();

    bank_pull_bram();
}


void player_logic() {

    bank_push_set_bram(fe.bram_bank);

    // unsigned char xor = player_checkxor();
    // if(stage.player_xor != xor) {
    //     printf("p-xor %02x<>%02x", xor, stage.player_xor);
    // }


    for(char p=0; p<FE_PLAYER; p++) {

#ifdef debug_scanlines
        vera_display_set_border_color(6);
#endif

        if(player.used[p]) {

            if(player.reload[p] > 0) {
                player.reload[p]--;
            }

            if(!player.wait_animation[p]) {
                player.wait_animation[p] = player.speed_animation[p];
                if(cx16_mouse.x < cx16_mouse.px && player.state_animation[p] > 0) {
                    // Added fragment
                    player.state_animation[p] -= 1;
                    player.moved[p] = 2;
                }
                if (cx16_mouse.x > cx16_mouse.px && player.state_animation[p] < 6) {
                    player.state_animation[p] += 1;
                    player.moved[p] = 2;
                }

                if (player.moved[p] == 1) {
                    if (player.state_animation[p] < 3) {
                        player.state_animation[p] += 1;
                    }
                    if (player.state_animation[p] > 3) {
                        player.state_animation[p] -= 1;
                    }
                    if (player.state_animation[p] == 3) {
                        player.moved[p] = 0;
                    }
                }

                if(player.moved[p] == 2) {
                    player.moved[p]--;
                }
            }
            player.wait_animation[p]--;

            unsigned char n = player.engine[p];

            if (!engine.wait_animation[n]) {
                engine.state_animation[n]++;
                engine.state_animation[n] &= 0xF;
                engine.wait_animation[n] = engine.speed_animation[n];
            }
            engine.wait_animation[n]--;
            
#ifdef __BULLET
            if (cx16_mouse.status == 1 && player.reload[p] <= 0)
            {
                FireBullet(p, 8);
            }
#endif

            // player.tdx[p] = MAKELONG((word)(cx16_mouse.x - cx16_mouse.px),0);
            // player.tdy[p] = MAKELONG((word)(cx16_mouse.y - game.prev_mousey),0);
            
            // // Added fragment
            // player.tx[p] += player.tdx[p];
            // player.ty[p] += player.tdy[p];

            player.tx[p] = MAKELONG((word)(cx16_mouse.x),0);
            player.ty[p] = MAKELONG((word)(cx16_mouse.y),0);

            signed int playerx = (signed int)WORD1(player.tx[p]);
            signed int playery = (signed int)WORD1(player.ty[p]);

            vera_sprite_offset player_sprite_offset = player.sprite_offset[p];
            vera_sprite_offset engine_sprite_offset = engine.sprite_offset[n];

            if(playerx>-32 && playerx<640-32 && playery>-32 && playery<480-32) {
#ifdef __COLLISION
                grid_insert(&ht_collision, 1, BYTE0(playerx>>2), BYTE0(playery>>2), p);
#endif

                unsigned char player_sprite = player.sprite[p];
                unsigned char engine_sprite = engine.sprite[n];

                if(!player.enabled[p]) {
                    vera_sprite_zdepth(player_sprite_offset, sprite_cache.zdepth[player_sprite]);
                    vera_sprite_zdepth(engine_sprite_offset, sprite_cache.zdepth[engine_sprite]);
                    player.enabled[p] = 1;
                }

                if(player.wait_animation[p]) {
                    vera_sprite_set_xy(player_sprite_offset, playerx, playery);
                } else {
                    // printf("player image offset: s=%x, p=%x, a=%x, o=%x. ", player_sprite_offset, p, player.state_animation[p], player_sprite->vram_image[player.state_animation[p]]);
                    // vera_sprite_set_xy_and_image_offset(player_sprite_offset, playerx, playery, sprite_cache.vram_image_offset[(unsigned int)player.sprite[p]*16+player.state_animation[p]]);
					vera_sprite_set_xy_and_image_offset(player_sprite_offset, playerx, playery, sprite_image_cache_vram(player_sprite, player.state_animation[p]));
                }
#ifdef __ENGINE
                if(engine.wait_animation[n]) {
                    vera_sprite_set_xy(engine_sprite_offset, playerx+8, playery+22);
                } else {
                    // vera_sprite_set_xy_and_image_offset(engine_sprite_offset, playerx+8, playery+22, sprite_cache.vram_image_offset[(unsigned int)engine.sprite[n]*16+engine.state_animation[n]]);
					vera_sprite_set_xy_and_image_offset(engine_sprite_offset, playerx+8, playery+22, sprite_image_cache_vram(engine_sprite, engine.state_animation[n]));
                }
#endif
            } else {
                if(player.enabled[p]) {
                    vera_sprite_disable(player_sprite_offset);
                    vera_sprite_disable(engine_sprite_offset);
                    player.enabled[p] = 0;
                }
            }
        }
    }

    // stage.player_xor = player_checkxor();

    bank_pull_bram();
}

char player_checkxor()
{
    bank_push_bram(); bank_set_bram(fe.bram_bank);
    unsigned char xor = 0;
    unsigned char* p = (char*)&player;
    unsigned int s = sizeof(fe_player_t);
    for(unsigned int i=0; i<s; i++) {
        xor ^= (unsigned char)*p;
        p++;
    }
    bank_pull_bram();
    return xor;
}


#endif // __PLAYER