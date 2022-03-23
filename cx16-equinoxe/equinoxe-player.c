#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-stage.h"
#include "equinoxe-bullet.h"
#include "equinoxe-collision.h"

void InitPlayer() {

	// player
	unsigned char p = player.pool;

	while(player.used[p]) {
		p = (p+1)%FE_PLAYER;
	}
	
	player.used[p] = 1;
	player.enabled[p] = 0;

	player.moved[p] = 2;

	player.health[p] = 1;
	player.firegun[p] = 0;
	player.reload[p] = 0;

	player.speed_animation[p] = 8;
	player.wait_animation[p] = player.speed_animation[p];
	player.state_animation[p] = 3;

	player.sprite_type[p] = &SpritePlayer01;
	player.sprite_offset[p] = NextOffset(SPRITE_OFFSET_PLAYER_START, SPRITE_OFFSET_PLAYER_END, &stage.sprite_player, &stage.sprite_player_count);
	sprite_configure(player.sprite_offset[p], player.sprite_type[p]);

	player.tx[p] = MAKELONG(320, 0);
	player.ty[p] = MAKELONG(200, 0);
	player.tdx[p] = 0;
	player.tdy[p] = 0;

	player.aabb_min_x[p] = SpritePlayer01.aabb[0];
	player.aabb_min_y[p] = SpritePlayer01.aabb[1];
	player.aabb_max_x[p] = SpritePlayer01.aabb[2];
	player.aabb_max_y[p] = SpritePlayer01.aabb[3];

	player.pool = (p+1)%FE_PLAYER;

	// Engine
	while(engine.used[engine.pool]) {
		engine.pool = (engine.pool++)%FE_ENGINE;
	}

	unsigned char n = engine.pool;

	player.engine[p] = n;

	engine.used[p] = 1;

	engine.speed_animation[n] = 1;
	engine.wait_animation[n] = engine.speed_animation[n];

	engine.sprite_type[n] = &SpriteEngine01;
	engine.sprite_offset[n] = NextOffset(SPRITE_OFFSET_PLAYER_START, SPRITE_OFFSET_PLAYER_END, &stage.sprite_player, &stage.sprite_player_count);
	sprite_configure(engine.sprite_offset[n], engine.sprite_type[n]);

	engine.pool = (engine.pool++)%FE_ENGINE;

}

void LogicPlayer() {

	if (player.pool) {

		for(char p=FE_PLAYER_LO; p<FE_PLAYER_HI; p++) {

			byte bank = bank_get_bram();

			if(player.used[p]) {

				if (player.reload[p] > 0) {
					player.reload[p]--;
				}

				if (!player.wait_animation[p]) {
					player.wait_animation[p] = player.speed_animation[p];
					if (game.curr_mousex < game.prev_mousex && player.state_animation[p] > 0) {
						// Added fragment
						player.state_animation[p] -= 1;
						player.moved[p] = 2;
					}
					if (game.curr_mousex > game.prev_mousex && player.state_animation[p] < 6) {
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


				// player.tdx[p] = MAKELONG((word)(game.curr_mousex - game.prev_mousex),0);
				// player.tdy[p] = MAKELONG((word)(game.curr_mousey - game.prev_mousey),0);
				
				// // Added fragment
				// player.tx[p] += player.tdx[p];
				// player.ty[p] += player.tdy[p];

				player.tx[p] = MAKELONG((word)(game.curr_mousex),0);
				player.ty[p] = MAKELONG((word)(game.curr_mousey),0);

				signed int playerx = (signed int)WORD1(player.tx[p]);
				signed int playery = (signed int)WORD1(player.ty[p]);

				#ifdef __collision
				if(playerx>=0 && playerx<640-32 && playery>=0 && playery<480-32) {
					grid_insert(&ht_collision, 1, BYTE0(playerx>>2), BYTE0(playery>>2), p);
				}
				#endif

				unsigned char n = player.engine[p];

				if (!engine.wait_animation[n]) {
					engine.state_animation[n]++;
					engine.state_animation[n] &= 0xF;
					engine.wait_animation[n] = engine.speed_animation[n];
				}
				engine.wait_animation[n]--;
				
				if (game.status_mouse == 1 && player.reload[p] <= 0)
				{
					FireBullet(p, 8);
				}
				
				vera_sprite_offset player_sprite_offset = player.sprite_offset[p];
				Sprite* player_sprite = player.sprite_type[p];

				vera_sprite_offset engine_sprite_offset = engine.sprite_offset[n];
				Sprite* engine_sprite = engine.sprite_type[n];
				if(playerx > -64 && playerx < 640) {
					if(!player.enabled[p]) {
				    	vera_sprite_zdepth(player_sprite_offset, player_sprite->Zdepth);
				    	vera_sprite_zdepth(engine_sprite_offset, engine_sprite->Zdepth);
						player.enabled[p] = 1;
					}
					if(player.wait_animation[p]) {
						vera_sprite_set_xy(player_sprite_offset, playerx, playery);
					} else {
						vera_sprite_set_xy_and_image_offset(player_sprite_offset, playerx, playery, player_sprite->offset_image[player.state_animation[p]]);
					}
					if(engine.wait_animation[p]) {
						vera_sprite_set_xy(engine_sprite_offset, playerx+8, playery+22);
					} else {
						vera_sprite_set_xy_and_image_offset(engine_sprite_offset, playerx+8, playery+22, engine_sprite->offset_image[engine.state_animation[n]]);
					}
					// DrawFighter(player_handle);
				} else {
					if(player.enabled[p]) {
				    	vera_sprite_disable(player_sprite_offset);
				    	vera_sprite_disable(engine_sprite_offset);
						player.enabled[p] = 0;
					}
				}
			}
		}
	}
}
