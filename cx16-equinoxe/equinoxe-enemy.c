#include <cx16-heap.h>
#include <cx16-mouse.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-stage.h"
#include "equinoxe-enemy.h"

void AddEnemy(char t, signed int x, signed int y, signed char dx, signed char dy) {

	enemy_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, sizeof(Enemy)); 
	Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);
	memset(enemy, 0, sizeof(Enemy));

	heap_data_list_insert(&stage.fighter_list, enemy_handle);

	enemy->health = 1;
	enemy->x = x;
	enemy->y = y;
	enemy->dx = dx;
	enemy->dy = dy;
	enemy->sprite_type = &SpriteEnemy01;
	enemy->sprite_offset = NextOffset();
	enemy->speed_animation = 4;
	enemy->wait_animation = enemy->speed_animation;
	enemy->state_animation = 12;
	enemy->moved = 2;
	enemy->firegun = 0;
	enemy->flight = 0;

	enemy->side = SIDE_ENEMY;

	sprite_create(enemy->sprite_type, enemy->sprite_offset);
}

heap_handle RemoveEnemy(heap_handle handle_remove) {

	heap_handle handle_next = ((Enemy*)heap_data_ptr(handle_remove))->next;

	// clrscr();
	// gotoxy(0,0);
	heap_data_list_remove(&stage.fighter_list, handle_remove);
	// heap_dump(HEAP_SEGMENT_BRAM_ENTITIES);
	heap_free(HEAP_SEGMENT_BRAM_ENTITIES, handle_remove); 
	// heap_dump(HEAP_SEGMENT_BRAM_ENTITIES);

	// {
    // heap_handle enemy_handle = stage.fighter_list;
	// printf("stage fighter list = %x\n", stage.fighter_list);
	// do {

	// 	Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);
	// 	printf("enemy = %p, enemy_handle = %x, next = %x, prev = %x\n", enemy, enemy_handle, enemy->next, enemy->prev);
	// 	enemy_handle = enemy->next;
	// } while (enemy_handle != stage.fighter_list);
	// }

	return handle_next;
}


void LogicEnemies() {

	if (!stage.fighter_list) return;

    heap_handle enemy_handle = stage.fighter_list;
    heap_handle last_handle = stage.fighter_list;
	unsigned int loop = 0;
    	
	do {

		Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);

		if(enemy->side == SIDE_ENEMY) {

			// printf("logic - ph = %x, *p = %x, b = %u\n", player_handle, (word)enemy, bank);


			if(enemy->flight == 320 ) {
				enemy->dx = 16;
			}

			if(enemy->flight == 320+80 ) {
				enemy->dx = 8;
			}

			if(enemy->flight == 320+80+80) {
				enemy->dx = 16;
			}

			if(enemy->flight == 320+80+80+80) {
				enemy->dx = 32;
			}

			if(enemy->flight == 320+80+80+80+80+160) {
				enemy_handle = RemoveEnemy(enemy_handle);
				continue;
			}

			signed char fx = enemy->fx;
			signed char fy = enemy->fy;
			fx += enemy->dx;
			fy += enemy->dy;

			if(fx>=16) {
				signed char x = fx >> 4;
				enemy->x += x;
				enemy->flight++;
				fx &= 0x0F;
			}

			if(fx<=-16) {
				signed char x = fx >> 4;
				enemy->x += x;
				enemy->flight++;
				fx = -(-fx & 0x0F);
			}

			if(fy>=16) {
				signed char y = fy >> 4;
				enemy->y += y;
				enemy->flight++;
				fy &= 0x0F;
			}

			if(fy<=-16) {
				signed char y = fy >> 4;
				enemy->y += y;
				enemy->flight++;
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
	} while (enemy_handle != stage.fighter_list);

}