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

void AddEnemy(char t, unsigned int x, unsigned int y) {

	while(fighter.used[fighter.pool]) {
		fighter.pool = (fighter.pool++)%64;
	}
	
	fighter.used[fighter.pool] = 1;

	fighter.type[fighter.pool] = entity_type_enemy;
	fighter.side[fighter.pool] = SIDE_ENEMY;
	fighter.move[fighter.pool] = 0;
	fighter.moved[fighter.pool] = 0;
	fighter.flight[fighter.pool] = 0;
	fighter.angle[fighter.pool] = 0;
	fighter.speed[fighter.pool] = 0;
	fighter.step[fighter.pool] = 0;
	fighter.turn[fighter.pool] = 0;
	fighter.radius[fighter.pool] = 0;
	fighter.baseangle[fighter.pool] = 0;
	fighter.reload[fighter.pool] = 0;
	fighter.wait_animation[fighter.pool] = 4;
	fighter.speed_animation[fighter.pool] = 4;
	fighter.state_animation[fighter.pool] = 12;
	fighter.health[fighter.pool] = 1;
	fighter.delay[fighter.pool] = 0;
	fighter.tx[fighter.pool] = MAKELONG(x,0);
	fighter.ty[fighter.pool] = MAKELONG(y,0);
	fighter.tdx[fighter.pool] = 0;
	fighter.tdy[fighter.pool] = 0;

	fighter.sprite_type[fighter.pool] = &SpriteEnemy01;
	fighter.sprite_offset[fighter.pool] = NextOffset(SPRITE_OFFSET_ENEMY_START, SPRITE_OFFSET_ENEMY_END, &stage.sprite_enemy);

	sprite_configure(fighter.sprite_offset[fighter.pool], fighter.sprite_type[fighter.pool]);

	fighter.pool = (fighter.pool++)%64;

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

void MoveEnemy( unsigned char e, unsigned int flight, unsigned char turn, unsigned char speed) {
	fighter.move[e] = 1;
	if(speed) flight >>= speed;
	fighter.flight[e] = flight;
	fighter.angle[e] = fighter.angle[e] + turn;
	fighter.speed[e] = speed;
	fighter.step[e]++;
}

void ArcEnemy( unsigned char e, unsigned char turn, unsigned char radius, unsigned char speed) {
	fighter.move[e] = 2;
	fighter.turn[e] = sgn_u8(turn);
	fighter.radius[e] = radius;
	fighter.delay[e] = 0;
	fighter.flight[e] = mul8u(abs_u8((unsigned char)turn), radius);
	fighter.baseangle[e] = fighter.angle[e];
	fighter.speed[e] = speed;
	fighter.step[e]++;
}


void LogicEnemies() {

	if (!fighter.pool) return;

	for(unsigned char e=0; e<64; e++) {

    #ifdef debug_scanlines
	    vera_display_set_border_color(1);
    #endif

		if(fighter.used[e] && fighter.side[e] == SIDE_ENEMY) {	

			if(!fighter.flight[e]) {
				switch(fighter.step[e]) {
				case 0:
					MoveEnemy(e, 530, 32, 1);
					break;
				case 1:
					ArcEnemy(e, -32, 2, 1);
					break;
				case 2:
					MoveEnemy(e, 440, 0, 1);
					break;
				case 3:
					ArcEnemy(e, -32, 2, 1);
					break;
				case 4:
					MoveEnemy(e, 440, 0, 1);
					fighter.step[e] = 1;
					break;
				}
			}

			if(fighter.flight[e]) {
				fighter.flight[e]--;
				if(fighter.move[e] == 1) {
					fighter.tdx[e] = vecx(fighter.angle[e], fighter.speed[e]);
					fighter.tdy[e] = vecy(fighter.angle[e], fighter.speed[e]);
				}

				if(fighter.move[e] == 2) {
					// Calculate current angle based on flight from x,y and angle startpoint.
					if(!fighter.delay[e]) {
						fighter.angle[e] += fighter.turn[e];
						fighter.angle[e] %= 64;
						fighter.delay[e] = fighter.radius[e];
						fighter.tdx[e] = vecx(fighter.angle[e], fighter.speed[e]);
						fighter.tdy[e] = vecy(fighter.angle[e], fighter.speed[e]);
					}
					fighter.delay[e]--;
				}
			} else {
				fighter.move[e] = 0;
			}

			fighter.tx[e] += fighter.tdx[e];
			fighter.ty[e] += fighter.tdy[e];



#ifdef debug_scanlines
			vera_display_set_border_color(2);
#endif

#ifdef __collision
			unsigned int x = WORD1(fighter.tx[e]);
			unsigned int y = WORD1(fighter.ty[e]);

			if(x>=0 && x<=640-32 && x>=0 && x<=480-32) {
				grid_insert(0b01000000, BYTE0(x>>2), BYTE0(y>>2), (unsigned int)e);
			}
#endif

#ifdef debug_scanlines
			vera_display_set_border_color(3);
#endif

			if (fighter.reload[e] > 0) {
				fighter.reload[e]--;
			}

			if (!fighter.wait_animation[e]) {
				fighter.wait_animation[e] = fighter.speed_animation[e];
				if(!fighter.state_animation[e])
					fighter.state_animation[e] = 12;
				fighter.state_animation[e]--;
			}
			fighter.wait_animation[e]--;


			// gotoxy(0, 32);
			// printf("l=%5u a=%4u x=%4i y=%4i dx=%4i dy=%4i    ", loop++, enemy.angle[e], enemy.x[e], enemy.y[e], enemy.dx[e], enemy.dy[e]);
			// printf("a=%u, x=%i, y=%i, s=%u, m=%u, f=%u      ", 
			// 	enemy.angle[e], enemy.x[e], enemy.y[e], enemy.step[e], enemy.move[e], enemy.flight[e]
			// );

			// if(x > -64 && x < 640) {
				// if(!fighter.enabled[e]) {
					// EnableFighter(e);
					
				// }
				vera_sprite_offset sprite_offset = fighter.sprite_offset[e];
				Sprite* sprite = fighter.sprite_type[e];
				if(!fighter.enabled[e]) {
			    	vera_sprite_zdepth(sprite_offset, sprite->Zdepth);
					fighter.enabled[e] = 1;
				}
				// sprite_animate(sprite_offset, sprite, fighter.state_animation[e], fighter.wait_animation[e]);
				if(fighter.wait_animation[e]) {
					vera_sprite_set_xy(sprite_offset, x, y);
				} else {
					vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite->offset_image[fighter.state_animation[e]]);
				}

				// sprite_collision(fighter.sprite_offset[e], 0b10000000);
				// DrawFighter(e);
			// } else {
			// 	if(fighter.enabled[e]) {
			// 		DisableFighter(e);
			// 		fighter.enabled[e] = 0;
			// 	}
			// }
		}

	}

}

unsigned char SpawnEnemies(unsigned char t, unsigned int x, unsigned int y) {

	AddEnemy(t, x, y);
	return 1;
}

