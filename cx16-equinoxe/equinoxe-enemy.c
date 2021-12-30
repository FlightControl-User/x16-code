#include <cx16-heap.h>
#include <cx16-mouse.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"

void InitEnemies() {
	enemy_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, sizeof(Enemy)); ///< Global
	// printf("init - ph = %x, *p = %x, b = %u\n", enemy_handle, (word)enemy, cx16_bram_bank_get());

    heap_handle enemy_list = stage.fighter_head;
    stage.fighter_head = enemy_handle;

	Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);
	memset(enemy, 0, sizeof(Enemy));

	enemy->next = enemy_list;
	enemy->health = 1;
	enemy->x = 20;
	enemy->y = 100;
	enemy->sprite_type = &SpriteEnemy01;
	enemy->sprite_offset = 1;
	enemy->speed_animation = 8;
	enemy->wait_animation = enemy->speed_animation;
	enemy->state_animation = 12;
	enemy->moved = 2;
	enemy->firegun = 0;

	enemy->side = SIDE_ENEMY;

	sprite_create(enemy->sprite_type, enemy->sprite_offset);
}

void LogicEnemies() {

	if (enemy_handle) {
		
		Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);
		byte bank = cx16_bram_bank_get();
		// printf("logic - ph = %x, *p = %x, b = %u\n", player_handle, (word)enemy, bank);
		enemy->dx = enemy->dy = 1;

		if (enemy->reload > 0) {
			enemy->reload--;
		}

		if (!enemy->wait_animation--) {
			enemy->wait_animation = enemy->speed_animation;
			if(!enemy->state_animation--)
			enemy->state_animation += 12;
		}

		// Added fragment
		// enemy->x = enemy->x + 1;
		enemy->y = 100;

		// gotoxy(0, 3);
		// printf("pl x=%i,y=%i, m=%u, s=%x      ", enemy->x, enemy->y, enemy->moved, enemy->state_animation);

	}
}