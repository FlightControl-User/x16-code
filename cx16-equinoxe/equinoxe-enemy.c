#include <division.h>
#include <multiply.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-enemy.h"
#include "equinoxe-math.h"
#include "equinoxe-stage.h"
#include "equinoxe-fighters.h"
#include "equinoxe-collision.h"
#include <ht.h>

void AddEnemy(char t, signed int x, signed int y) {

	enemy_handle = heap_alloc(bins, entity_size);
	Enemy* enemy = (Enemy*)heap_ptr(enemy_handle);
	memset_fast(enemy, 0, entity_size);

	enemy->type = entity_type_enemy;
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

	heap_list_insert(&stage.fighter_list, enemy_handle);
}

heap_handle RemoveEnemy(heap_handle handle_remove) {

	heap_handle handle_next = ((Enemy*)heap_ptr(handle_remove))->next;

	// clrscr();
	// gotoxy(0,0);
	heap_list_remove(&stage.fighter_list, handle_remove);
	// heap_dump(HEAP_SEGMENT_BRAM_ENTITIES);
	heap_free(bins, handle_remove); 
	// heap_dump(HEAP_SEGMENT_BRAM_ENTITIES);

	// {
    // heap_handle enemy_handle = stage.fighter_list;
	// printf("stage fighter list = %x\n", stage.fighter_list);
	// do {

	// 	Enemy* enemy = (Enemy*)heap_ptr(enemy_handle);
	// 	printf("enemy = %p, enemy_handle = %x, next = %x, prev = %x\n", enemy, enemy_handle, enemy->next, enemy->prev);
	// 	enemy_handle = enemy->next;
	// } while (enemy_handle != stage.fighter_list);
	// }

	return handle_next;
}

void MoveEnemy( Enemy* enemy, unsigned int flight, signed char turn, unsigned char speed) {
	enemy->move = 1;
	if(speed) flight >>= speed;
	enemy->flight = flight;
	enemy->angle = enemy->angle + turn;
	enemy->speed = speed;
	enemy->step++;
}

void ArcEnemy( Enemy* enemy, signed char turn, unsigned char radius, unsigned char speed) {
	enemy->move = 2;
	enemy->turn = turn;
	enemy->radius = radius;
	enemy->delay = 0;
	enemy->flight = mul8u(abs_u8((unsigned char)turn), radius);
	enemy->baseangle = enemy->angle;
	enemy->speed = speed;
	enemy->step++;
}




// Prepare MEM pointers for operations using MEM
inline void fp3_prep(FP3* fp3_num, FP3* fp3_add) {
	fp3 = BYTE0(fp3_num);
	fp3hi = BYTE1(fp3_num);
	add = BYTE0(fp3_add);
	addhi = BYTE1(fp3_add);
}



void LogicEnemies() {

	if (heap_handle_is_null(stage.fighter_list)) return;

    heap_handle enemy_handle = stage.fighter_list;
    heap_handle last_handle = stage.fighter_list;
	unsigned int loop = 0;

	do {

    #ifdef debug_scanlines
	    vera_display_set_border_color(1);
    #endif

		Enemy* enemy = (Enemy*)heap_ptr(enemy_handle);

		if(enemy->side == SIDE_ENEMY) {	


			// grid_remove(enemy);

			if(!enemy->flight) {
				unsigned char step = enemy->step;
				switch(step) {
				case 0:
					// MoveEnemy(enemy, 320, 16, 5);
					MoveEnemy(enemy, 160, 0, 0);
					break;
				case 1:
					// ArcEnemy(enemy, -64, 12, 4);
					ArcEnemy(enemy, -64, 4, 0);
					break;
				case 2:
					// MoveEnemy(enemy, 80, 0, 4);
					MoveEnemy(enemy, 80, 0, 0);
					break;
				case 3:
					// ArcEnemy(enemy, 64, 9, 4);
					ArcEnemy(enemy, 64, 4, 0);
					break;
				case 4:
					// ArcEnemy(enemy, 8, 12, 3);
					ArcEnemy(enemy, 8, 4, 0);
					break;
				case 5:
					// MoveEnemy(enemy, 160, 0, 3);
					MoveEnemy(enemy, 160, 0, 0);
					break;
				case 6:
					// ArcEnemy(enemy, 16, 12, 3);
					ArcEnemy(enemy, 16, 4, 0);
					break;
				case 7:
					// ArcEnemy(enemy, 16, 12, 2);
					ArcEnemy(enemy, 16, 4, 0);
					break;
				case 8:
					// MoveEnemy(enemy, 80, 0, 2);
					MoveEnemy(enemy, 80, 0, 0);
					break;
				case 9:
					// ArcEnemy(enemy, 24, 12, 4);
					ArcEnemy(enemy, 24, 4, 0);
					break;
				case 10:
					// MoveEnemy(enemy, 160, 0, 4);
					MoveEnemy(enemy, 160, 0, 0);
					break;
				case 11:
					ArcEnemy(enemy, 16, 4, 0);
					enemy->step--;
					// enemy_handle = RemoveEnemy(enemy_handle);
					// continue;
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

			// fp3_add(&enemy->tx, &enemy->tdx);
			// fp3_add(&enemy->ty, &enemy->tdy);

			fp3_prep(&enemy->tx, &enemy->tdx);

			kickasm( uses fp3, uses fp3hi, uses add, uses addhi) {{
				clc
				ldy #0
				lda (fp3),y
				adc (add),y
				sta (fp3),y
				iny
				lda (fp3),y
				adc (add),y
				sta (fp3),y
				iny
				lda (fp3),y
				adc (add),y
				sta (fp3),y
			}}


			// fp3_prep(&fp3x, &fp3dx);
			fp3_prep(&enemy->tx, &enemy->tdx);

			kickasm( uses fp3, uses fp3hi, uses add, uses addhi) {{
				clc
				ldy #0
				lda (fp3),y
				adc (add),y
				sta (fp3),y
				iny
				lda (fp3),y
				adc (add),y
				sta (fp3),y
				iny
				lda (fp3),y
				adc (add),y
				sta (fp3),y
			}}

			// For collision, update collision hash table


#ifdef debug_scanlines
			vera_display_set_border_color(2);
#endif

#ifdef __collision
			if(enemy->tx.fp3fi.i>=0 && enemy->tx.fp3fi.i<=640-32 && enemy->ty.fp3fi.i>=0 && enemy->ty.fp3fi.i<=480-32) {
				grid_insert(enemy, 0b01000000, BYTE0(enemy->ty.fp3fi.i>>2), BYTE0(enemy->ty.fp3fi.i>>2), enemy_handle);
			}
#endif

#ifdef debug_scanlines
			vera_display_set_border_color(3);
#endif

			if (enemy->reload > 0) {
				enemy->reload--;
			}

			if (!enemy->wait_animation) {
				enemy->wait_animation = enemy->speed_animation;
				if(!enemy->state_animation--)
				enemy->state_animation += 12;
			}
			enemy->wait_animation--;

			// gotoxy(0, 32);
			// printf("l=%5u a=%4u x=%4i y=%4i dx=%4i dy=%4i    ", loop++, enemy->angle, enemy->x, enemy->y, enemy->dx, enemy->dy);
			// printf("a=%u, x=%i, y=%i, s=%u, m=%u, f=%u      ", 
			// 	enemy->angle, enemy->x, enemy->y, enemy->step, enemy->move, enemy->flight
			// );

			if(enemy->tx.fp3fi.i > -64 && enemy->tx.fp3fi.i < 640) {
				if(!enemy->enabled) {
					EnableFighter(enemy_handle);
					enemy->enabled = 1;
				}
				DrawFighter(enemy_handle);
			} else {
				if(enemy->enabled) {
					DisableFighter(enemy_handle);
					enemy->enabled = 0;
				}
			}
		}

		enemy_handle = enemy->next;

	} while (heap_handle_ne_handle(enemy_handle, stage.fighter_list));

}

unsigned char SpawnEnemies(unsigned char t, signed int x, signed int y) {

	AddEnemy(t, x, y);
	return 1;
}

