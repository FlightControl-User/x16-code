#include <division.h>
#include <multiply.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-enemy.h"
#include "equinoxe-math.h"

void AddEnemy(char t, signed int x, signed int y) {

	Enemy enemy_ram;
	Enemy* enemy = &enemy_ram;
	memset_fast(enemy, 0, sizeof(Enemy));

	enemy->health = 1;
	enemy->x = x;
	enemy->y = y;
	fp3_set(&enemy->tx, x, 0);
	fp3_set(&enemy->ty, y, 0);
	enemy->speed_animation = 4;
	enemy->wait_animation = enemy->speed_animation;
	enemy->state_animation = 12;
	enemy->moved = 2;
	enemy->side = SIDE_ENEMY;

	enemy->sprite_type = &SpriteEnemy01;
	enemy->sprite_offset = NextOffset(SPRITE_OFFSET_ENEMY_START, SPRITE_OFFSET_ENEMY_END, &stage.sprite_enemy);
	sprite_configure(enemy->sprite_offset, enemy->sprite_type);

	enemy_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, sizeof(Enemy));
	Enemy* enemy_bram = (Enemy*)heap_data_ptr(enemy_handle);
	memcpy_fast(enemy_bram, enemy, sizeof(Enemy));
	heap_data_list_insert(&stage.fighter_list, enemy_handle);
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

void MoveEnemy( Enemy* enemy, unsigned int flight, signed char turn, unsigned char speed) {
	enemy->move = 1;
	flight >>= speed;
	enemy->flight = flight;
	enemy->angle = enemy->angle + turn;
	enemy->speed = speed;
}

void ArcEnemy( Enemy* enemy, signed char turn, unsigned char radius, unsigned char speed) {
	enemy->move = 2;
	enemy->turn = turn;
	enemy->radius = radius;
	enemy->delay = 0;
	enemy->flight = mul8u(abs_u8((unsigned char)turn), radius);
	enemy->baseangle = enemy->angle;
	enemy->speed = speed;
}


void LogicEnemies() {

	if (!stage.fighter_list) return;

    heap_handle enemy_handle = stage.fighter_list;
    heap_handle last_handle = stage.fighter_list;
	unsigned int loop = 0;

	// Enemy enemy_ram;
	// Enemy* enemy = &enemy_ram;

	do {

		Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);

		if(enemy->side == SIDE_ENEMY) {

			if(!enemy->flight) {
				switch(enemy->step) {
				case 0:
					// MoveEnemy(enemy, 320, 16, 5);
					MoveEnemy(enemy, 160, 16, 1);
					enemy->step++;
					break;
				case 1:
					// ArcEnemy(enemy, -64, 12, 4);
					ArcEnemy(enemy, -64, 4, 1);
					enemy->step++;
					break;
				case 2:
					// MoveEnemy(enemy, 80, 0, 4);
					MoveEnemy(enemy, 80, 0, 1);
					enemy->step++;
					break;
				case 3:
					// ArcEnemy(enemy, 64, 9, 4);
					ArcEnemy(enemy, 64, 4, 1);
					enemy->step++;
					break;
				case 4:
					// ArcEnemy(enemy, 8, 12, 3);
					ArcEnemy(enemy, 8, 4, 1);
					enemy->step++;
					break;
				case 5:
					// MoveEnemy(enemy, 160, 0, 3);
					MoveEnemy(enemy, 160, 0, 1);
					enemy->step++;
					break;
				case 6:
					// ArcEnemy(enemy, 16, 12, 3);
					ArcEnemy(enemy, 16, 4, 1);
					enemy->step++;
					break;
				case 7:
					// ArcEnemy(enemy, 16, 12, 2);
					ArcEnemy(enemy, 16, 4, 1);
					enemy->step++;
					break;
				case 8:
					// MoveEnemy(enemy, 80, 0, 2);
					MoveEnemy(enemy, 80, 0, 1);
					enemy->step++;
					break;
				case 9:
					// ArcEnemy(enemy, 24, 12, 4);
					ArcEnemy(enemy, 24, 4, 1);
					enemy->step++;
					break;
				case 10:
					// MoveEnemy(enemy, 160, 0, 4);
					MoveEnemy(enemy, 160, 0, 1);
					enemy->step++;
					break;
				case 11:
					enemy_handle = RemoveEnemy(enemy_handle);
					continue;
				}
			}

			if(enemy->flight) {
				enemy->flight--;
				if(enemy->move == 1) {
					vecx(&enemy->tdx, enemy->angle, enemy->speed);
					vecy(&enemy->tdy, enemy->angle, enemy->speed);
					// dx = vecx(enemy->angle, enemy->speed);
					// dy = vecy(enemy->angle, enemy->speed);
				}

				if(enemy->move == 2) {
					// Calculate current angle based on flight from x,y and angle startpoint.
					if(!enemy->delay) {
						enemy->angle += sgn_u8((unsigned char)enemy->turn);
						enemy->angle %= 64;
						enemy->delay = enemy->radius;
						vecx(&enemy->tdx, enemy->angle, enemy->speed);
						vecy(&enemy->tdy, enemy->angle, enemy->speed);
					}
					enemy->delay--;
				}
			} else {
				enemy->move = 0;
			}

			// fx += tdx.f;
			// fy += tdy.f;

			// if(fx>=16) {
			// 	signed char vx = fx >> 4;
			// 	x += vx;
			// 	fx &= 0x0F;
			// }

			// if(fx<=-16) {
			// 	fx = -fx;
			// 	signed char vx = fx >> 4;
			// 	x -= vx;
			// 	fx = fx & 0x0F;
			// 	fx = -fx;
			// }

			// if(fy>=16) {
			// 	signed char vy = fy >> 4;
			// 	y += vy;
			// 	fy &= 0x0F;
			// }

			// if(fy<=-16) {
			// 	fy = -fy;
			// 	signed char vy = fy >> 4;
			// 	y -= vy;
			// 	fy = fy & 0x0F;
			// 	fy = -fy;
			// }


			// tx = fp3_set(20,2);
			// ty = fp3_set(30,2);

			fp3_add(&enemy->tx, &enemy->tdx);
			fp3_add(&enemy->ty, &enemy->tdy);


			if (enemy->reload > 0) {
				enemy->reload--;
			}

			if (!enemy->wait_animation--) {
				enemy->wait_animation = enemy->speed_animation;
				if(!enemy->state_animation--)
				enemy->state_animation += 12;
			}

			// gotoxy(0, 32);
			// printf("l=%5u a=%4u x=%4i y=%4i dx=%4i dy=%4i    ", loop++, enemy->angle, enemy->x, enemy->y, enemy->dx, enemy->dy);
			// printf("a=%u, x=%i, y=%i, s=%u, m=%u, f=%u      ", 
			// 	enemy->angle, enemy->x, enemy->y, enemy->step, enemy->move, enemy->flight
			// );

		}

		enemy_handle = enemy->next;

	} while (enemy_handle != stage.fighter_list);

}

unsigned char SpawnEnemies(unsigned char t, signed int x, signed int y) {

	AddEnemy(t, x, y);
	return 1;
}

