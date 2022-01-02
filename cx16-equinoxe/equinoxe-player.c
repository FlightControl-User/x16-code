#include <cx16-heap.h>
#include <cx16-mouse.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-stage.h"

void InitPlayer() {
	player_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, sizeof(Entity)); ///< Global
	Entity* player = (Entity*)heap_data_ptr(player_handle);
	memset(player, 0, sizeof(Entity));
	// printf("init - ph = %x, *p = %x, b = %u\n", player_handle, (word)player, cx16_bram_bank_get());

	heap_data_list_insert(&stage.fighter_list, player_handle);

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

	heap_handle engine_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, sizeof(Entity)); ///< Global
	((Entity*)heap_data_ptr(player_handle))->engine_handle = engine_handle;
	Entity* engine = (Entity*)heap_data_ptr(engine_handle);
	// printf("init - engine_handle = %x, *engine = %p\n", engine_handle, engine);
	engine->health = 1;
	engine->x = 0;
	engine->y = 0;
	engine->sprite_type = &SpriteEngine01;
	engine->sprite_offset = NextOffset();
	engine->speed_animation = 1;
	engine->wait_animation = engine->speed_animation;
	engine->state_animation = 0;
	engine->side = SIDE_PLAYER;
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

		// We need to use the x and y coordinate of the player for the engine position.
		// Remember that this is banked memory, so we need to keep these variables in local memory!
        int playerx = player->x;
        int playery = player->y;

		// gotoxy(0, 3);
		// printf("pl x=%i,y=%i, m=%u, s=%x      ", player->x, player->y, player->moved, player->state_animation);

		heap_handle engine_handle = player->engine_handle;

		Entity* engine = (Entity*)heap_data_ptr(engine_handle);

		// printf("logic - engine_handle = %x, *engine = %p\n", engine_handle, engine);

		if (engine->wait_animation--) {
			engine->state_animation++;
			engine->state_animation &= 0xF;
			engine->wait_animation = engine->speed_animation;
		}

		engine->x = playerx + 8;
		engine->y = playery + 22;

		// gotoxy(40, 3);
		// printf("engine logic x = %i, y = %i       ", ((Entity*)heap_data_ptr(engine_handle))->x, ((Entity*)heap_data_ptr(engine_handle))->y);

		if (game.status_mouse == 1 && player->reload <= 0)
		{
			FireBullet();
		}
	}
}
