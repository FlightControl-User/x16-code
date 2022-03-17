#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-stage.h"
#include "equinoxe-bullet.h"
#include "equinoxe-collision.h"

void InitPlayer() {

	player_handle = heap_alloc(bins, entity_size); 
	entity_t* player = (entity_t*)heap_ptr(player_handle);
	memset_fast(player, 0, entity_size);

	player->type = entity_type_player;
	player->health = 1;
	player->tx.fp3fi.i = 320;
	player->ty.fp3fi.i = 200;
	player->speed_animation = 8;
	player->wait_animation = player->speed_animation;
	player->state_animation = 3;
	player->moved = 2;
	player->firegun = 0;
	player->side = SIDE_PLAYER;

	player->sprite_type = &SpritePlayer01;
	player->sprite_offset = NextOffset(SPRITE_OFFSET_PLAYER_START, SPRITE_OFFSET_PLAYER_END, &stage.sprite_player);
	sprite_configure(player->sprite_offset, player->sprite_type);

	heap_handle engine_handle = heap_alloc(bins, entity_size);
	entity_t* engine = (entity_t*)heap_ptr(engine_handle);
	memset_fast(engine, 0, entity_size);

	engine->health = 1;
	engine->speed_animation = 1;
	engine->wait_animation = engine->speed_animation;
	engine->side = SIDE_PLAYER;

	engine->sprite_type = &SpriteEngine01;
	engine->sprite_offset = NextOffset(SPRITE_OFFSET_PLAYER_START, SPRITE_OFFSET_PLAYER_END, &stage.sprite_player);
	sprite_configure(engine->sprite_offset, engine->sprite_type);

	player = (entity_t*)heap_ptr(player_handle);
	player->engine_handle = engine_handle;

	heap_list_insert(&stage.fighter_list, player_handle);

}

void LogicPlayer() {

	if (heap_handle_is_not_null(player_handle)) {

		entity_t* player = (entity_t*)heap_ptr(player_handle);

		byte bank = bank_get_bram();
		// printf("logic - ph = %x, *p = %x, b = %u\n", player_handle, (word)player, bank);

		// grid_remove(player);

		if (player->reload > 0) {
			player->reload--;
		}

		if (!player->wait_animation) {
			player->wait_animation = player->speed_animation;
			if (game.curr_mousex < game.prev_mousex && player->state_animation > 0) {
				// Added fragment
				player->state_animation -= 1;
				player->moved = 2;
			}
			if (game.curr_mousex > game.prev_mousex && player->state_animation < 6) {
				player->state_animation += 1;
				player->moved = 2;
			}

			if (player->moved == 1) {
				if (player->state_animation < 3) {
					player->state_animation += 1;
				}
				if (player->state_animation > 3) {
					player->state_animation -= 1;
				}
				if (player->state_animation == 3) {
					player->moved = 0;
				}
			}

			if(player->moved == 2) {
				player->moved--;
			}
		}
		player->wait_animation--;


		// Added fragment
		player->tx.fp3fi.i = game.curr_mousex;
		player->ty.fp3fi.i = game.curr_mousey;

		signed int playerx = player->tx.fp3fi.i;
		signed int playery = player->ty.fp3fi.i;

		volatile unsigned int x = (unsigned int)player->tx.fp3fi.i;
		volatile unsigned int y = (unsigned int)player->ty.fp3fi.i;

		#ifdef __collision
		if(playerx>=0 && playerx<640-32 && playery>=0 && playery<480-32) {
			grid_insert(player, 0b10000000, BYTE0(x>>2), BYTE0(y>>2), player_handle);
		}
		#endif

		heap_handle engine_handle = player->engine_handle;
		entity_t* engine = (entity_t*)heap_ptr(engine_handle);

		if (!engine->wait_animation) {
			engine->state_animation++;
			engine->state_animation &= 0xF;
			engine->wait_animation = engine->speed_animation;
		}
		engine->wait_animation--;
		
		engine->tx.fp3fi.i = playerx + 8;
		engine->ty.fp3fi.i = playery + 22;

		if (game.status_mouse == 1 && player->reload <= 0)
		{
			FireBullet(player, 4);
		}

		
		if(playerx > -64 && playerx < 640) {
			if(!player->enabled) {
				EnableFighter(player_handle);
				player->enabled = 1;
			}
			DrawFighter(player_handle);
		} else {
			if(player->enabled) {
				DisableFighter(player_handle);
				player->enabled = 0;
			}
		}
	}
}
