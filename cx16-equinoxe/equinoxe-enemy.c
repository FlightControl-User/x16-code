#include <cx16-heap.h>
#include <cx16-mouse.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-stage.h"
#include "equinoxe-enemy.h"

void AddEnemy(byte enemy_type, unsigned int x, unsigned int y) {

	enemy_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, sizeof(Enemy)); ///< Global
	// printf("init - ph = %x, *p = %x, b = %u\n", enemy_handle, (word)enemy, cx16_bram_bank_get());

    heap_handle enemy_list = stage.fighter_list;
    stage.fighter_list = enemy_handle;

	Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);
	memset(enemy, 0, sizeof(Enemy));

	enemy->next = enemy_list;
	enemy->health = 1;
	enemy->x = x << 4;
	enemy->y = y << 4;
	enemy->sprite_type = &SpriteEnemy01;
	enemy->sprite_offset = NextOffset();
	enemy->speed_animation = 8;
	enemy->wait_animation = enemy->speed_animation;
	enemy->state_animation = 12;
	enemy->moved = 2;
	enemy->firegun = 0;

	enemy->side = SIDE_ENEMY;

	sprite_create(enemy->sprite_type, enemy->sprite_offset);
}


void LogicEnemies() {

    heap_handle enemy_handle = stage.fighter_list;
    heap_handle prev_handle = stage.fighter_list;
    
	while (enemy_handle)
    {	
		Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);

		if(enemy->side == SIDE_ENEMY) {

			// printf("logic - ph = %x, *p = %x, b = %u\n", player_handle, (word)enemy, bank);
			enemy->dx = 0;
			enemy->dy = 2;

			unsigned int x = enemy->x;
			unsigned int y = enemy->y;
			x += enemy->dx;
			y += enemy->dy;
			enemy->x = x;
			enemy->y = y;
		
			if (enemy->reload > 0) {
				enemy->reload--;
			}

			if (!enemy->wait_animation--) {
				enemy->wait_animation = enemy->speed_animation;
				if(!enemy->state_animation--)
				enemy->state_animation += 12;
			}

			// gotoxy(0, 3);
			// printf("pl x=%i,y=%i, m=%u, s=%x      ", enemy->x, enemy->y, enemy->moved, enemy->state_animation);
		}
		enemy_handle = enemy->next;
	}
}