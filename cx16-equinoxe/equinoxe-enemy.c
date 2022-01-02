#include <cx16-heap.h>
#include <cx16-mouse.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-stage.h"
#include "equinoxe-enemy.h"

void AddEnemy(byte enemy_type, int x, int y) {

	enemy_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, sizeof(Enemy)); 
	Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);
	memset(enemy, 0, sizeof(Enemy));

	heap_data_list_insert(&stage.fighter_list, enemy_handle);

	enemy->health = 1;
	enemy->x = x;
	enemy->y = y;
	enemy->dx = -16;
	enemy->dy = 0;
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

	if (!stage.fighter_list) return;

    heap_handle enemy_handle = stage.fighter_list;
    heap_handle last_handle = stage.fighter_list;
    	
	do {

		Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);

		if(enemy->side == SIDE_ENEMY) {

			// printf("logic - ph = %x, *p = %x, b = %u\n", player_handle, (word)enemy, bank);


			if(enemy->x <= 0) {
				enemy->dx = 16;
			}

			if(enemy->x >= 640) {
				enemy->dx = -16;
			}

			if(enemy->y <= 0) {
				enemy->dx = 2;
			}

			if(enemy->y >= 480) {
				enemy->dy = -2;
			}

			signed char fx = enemy->fx;
			signed char fy = enemy->fy;
			fx += enemy->dx;
			fy += enemy->dy;

			if(fx>=16) {
				signed char x = fx >> 4;
				enemy->x += x;
				fx &= 0x0F;
			}

			if(fx<=-16) {
				signed char x = fx >> 4;
				enemy->x += x;
				fx = -(-fx & 0x0F);
			}

			if(fy>=16) {
				signed char y = fy >> 4;
				enemy->y += y;
				fy &= 0x0F;
			}

			if(fy<=-16) {
				signed char y = fy >> 4;
				enemy->y += y;
				fy = -(-fy & 0x0F);
			}

			enemy->fx = fx;
			enemy->fy = fy;

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
	} while (enemy_handle != last_handle);

}