#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-stage.h"
#include "equinoxe-bullet.h"

void InitPlayer() {

	Entity player_ram;
	Entity* player = &player_ram;
	memset_fast(player, 0, sizeof(Entity));

	player->health = 1;
	player->x = 320;
	player->y = 200;
	player->sprite_type = &SpritePlayer01;
	player->sprite_offset = NextOffset();
	player->speed_animation = 8;
	player->wait_animation = player->speed_animation;
	player->state_animation = 3;
	player->moved = 2;
	player->firegun = 0;
	player->side = SIDE_PLAYER;
	sprite_create(player->sprite_type, player->sprite_offset);
	sprite_configure(player->sprite_offset, player->sprite_type);


	Entity engine_ram;
	Entity* engine = &engine_ram;
	memset_fast(engine, 0, sizeof(Entity));

	engine->health = 1;
	engine->x = 0;
	engine->y = 0;
	engine->sprite_type = &SpriteEngine01;
	engine->sprite_offset = NextOffset();
	engine->speed_animation = 1;
	engine->wait_animation = engine->speed_animation;
	engine->state_animation = 0;
	engine->side = SIDE_PLAYER;
	sprite_configure(engine->sprite_offset, engine->sprite_type);

	heap_handle engine_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, sizeof(Entity));
	player->engine_handle = engine_handle;

	player_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, sizeof(Entity)); 
	Entity* player_bram = (Entity*)heap_data_ptr(player_handle);
	memcpy_fast(player_bram, player, sizeof(Entity));

	Entity* engine_bram = (Entity*)heap_data_ptr(engine_handle);
	memcpy_fast(engine_bram, engine, sizeof(Entity));

	heap_data_list_insert(&stage.fighter_list, player_handle);
	
}

void LogicPlayer() {

	if (player_handle) {

		Entity* player = (Entity*)heap_data_ptr(player_handle);

		byte bank = cx16_bram_bank_get();
		// printf("logic - ph = %x, *p = %x, b = %u\n", player_handle, (word)player, bank);
		player->dx = player->dy = 0;

		if (player->reload > 0) {
			player->reload--;
		}

		if (!player->wait_animation--) {
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


		// Added fragment
		player->x = game.curr_mousex;
		player->y = game.curr_mousey;

		signed int playerx = player->x;
		signed int playery = player->y;

		heap_handle engine_handle = player->engine_handle;
		Entity* engine = (Entity*)heap_data_ptr(engine_handle);

		if (engine->wait_animation--) {
			engine->state_animation++;
			engine->state_animation &= 0xF;
			engine->wait_animation = engine->speed_animation;
		}

		engine->x = playerx + 8;
		engine->y = playery + 22;

		if (game.status_mouse == 1 && player->reload <= 0)
		{
			FireBullet(player, 4);
		}
	}
}
