#include <cx16-mouse.h>

#include "equinoxe-defines.h"
#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-flightengine-types.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"
#include "equinoxe-stage.h"
#include "equinoxe-player.h"
#include "equinoxe-bullet.h"



// #pragma var_model(zp)

void player_init()
{
    bank_push_set_bram(BRAM_FLIGHTENGINE);

    memset(&player, 0, sizeof(fe_player_t));
    memset(&engine, 0, sizeof(fe_engine_t));

    bank_pull_bram();
}

void player_add(sprite_index_t sprite_player, sprite_index_t sprite_engine) 
{

    bank_push_set_bram(BRAM_FLIGHTENGINE);

    stage.player_count++;

	// player
	unsigned char p = stage.player_pool;

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

    unsigned char s = fe_sprite_cache_copy(sprite_player);
    player.sprite[p] = s;

	player.sprite_offset[p] = sprite_next_offset();
	fe_sprite_configure(player.sprite_offset[p], s);


	player.tx[p] = MAKELONG(320, 0);
	player.ty[p] = MAKELONG(200, 0);
	player.tdx[p] = 0;
	player.tdy[p] = 0;

    player.health[p] = 100;

	stage.player_pool = (p+1)%FE_PLAYER;

	// Engine
	while(engine.used[stage.engine_pool]) {
		stage.engine_pool = (stage.engine_pool++)%FE_ENGINE;
	}

	unsigned char n = stage.engine_pool;

	player.engine[p] = n;

	engine.used[p] = 1;

	engine.speed_animation[n] = 1;
	engine.wait_animation[n] = engine.speed_animation[n];

    unsigned char cn = fe_sprite_cache_copy(sprite_engine);
    engine.sprite[n] = cn;

	engine.sprite_offset[n] = sprite_next_offset();
	fe_sprite_configure(engine.sprite_offset[n], cn);

	stage.engine_pool = (stage.engine_pool++)%FE_ENGINE;

    // stage.player_xor = player_checkxor();

    bank_pull_bram();

}

void player_remove(unsigned char p, unsigned char b) 
{

    bank_push_set_bram(BRAM_FLIGHTENGINE);

    player.health[p] += bullet_energy_get(b);

    if(player.health[p] <= 0) {

        vera_sprite_offset sprite_offset = player.sprite_offset[p];
        sprite_free_offset(sprite_offset);
        vera_sprite_disable(sprite_offset);
        palette16_unuse(sprite_cache.palette_offset[player.sprite[p]]);
        fe_sprite_cache_free(player.sprite[p]);
        player.used[p] = 0;
        player.enabled[p] = 0;

        unsigned char n = player.engine[p];
        sprite_offset = engine.sprite_offset[n];
        sprite_free_offset(sprite_offset);
        vera_sprite_disable(sprite_offset);
        palette16_unuse(sprite_cache.palette_offset[engine.sprite[n]]);
        fe_sprite_cache_free(engine.sprite[n]);
        engine.used[n] = 0;

        stage.player_count--;

        stage.lives--;
        stage.respawn = 64;
    }

    // stage.player_xor = player_checkxor();

    bank_pull_bram();
}


void player_logic() {

    bank_push_set_bram(BRAM_FLIGHTENGINE);

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
            if (cx16_mouse.status == 1 && player.reload[p] <= 0) {
                unsigned int x = WORD1(player.tx[p]);
                unsigned int y = WORD1(player.ty[p]);        
                if(player.firegun[p]) {
                    x += (signed char)16;
                }
                player.firegun[p] = player.firegun[p]^1;
                player.reload[p] = 8;
                bullet_player_fire(x, y);
            }
#endif

            // player.tdx[p] = MAKELONG((word)(cx16_mouse.x - cx16_mouse.px),0);
            // player.tdy[p] = MAKELONG((word)(cx16_mouse.y - game.prev_mousey),0);
            
            // // Added fragment
            // player.tx[p] += player.tdx[p];
            // player.ty[p] += player.tdy[p];

            player.tx[p] = MAKELONG((word)(cx16_mouse.x),0);
            player.ty[p] = MAKELONG((word)(cx16_mouse.y),0);

            volatile signed int playerx = (signed int)WORD1(player.tx[p]);
            volatile signed int playery = (signed int)WORD1(player.ty[p]);

            vera_sprite_offset player_sprite_offset = player.sprite_offset[p];
            vera_sprite_offset engine_sprite_offset = engine.sprite_offset[n];

            if(playerx > 640-32) playerx = 640-32;
            if(playerx < 0) playerx = 0;
            if(playery > 480-32) playery = 480-32;
            if(playery < 0) playery = 0;

            #ifdef __COLLISION
            collision_insert(&ht_collision, BYTE0((unsigned int)playerx>>2), BYTE0((unsigned int)playery>>2), COLLISION_PLAYER | p);
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
                vera_sprite_set_xy_and_image_offset(player_sprite_offset, playerx, playery, sprite_image_cache_vram(player_sprite, player.state_animation[p]));
            }
            #ifdef __ENGINE
            if(engine.wait_animation[n]) {
                vera_sprite_set_xy(engine_sprite_offset, playerx+8, playery+22);
            } else {
                vera_sprite_set_xy_and_image_offset(engine_sprite_offset, playerx+8, playery+22, sprite_image_cache_vram(engine_sprite, engine.state_animation[n]));
            }
            #endif
        }
    }

    // stage.player_xor = player_checkxor();

    bank_pull_bram();
}

char player_checkxor()
{
    bank_push_set_bram(BRAM_FLIGHTENGINE);
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

// #pragma var_model(mem)


