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

	while(enemy.used[enemy.pool]) {
		enemy.pool = (enemy.pool++)%FE_ENEMY;
	}
	
	enemy.used[enemy.pool] = 1;

	enemy.type[enemy.pool] = entity_type_enemy;
	enemy.side[enemy.pool] = SIDE_ENEMY;
	enemy.move[enemy.pool] = 0;
	enemy.moved[enemy.pool] = 0;
	enemy.flight[enemy.pool] = 0;
	enemy.angle[enemy.pool] = 0;
	enemy.speed[enemy.pool] = 0;
	enemy.step[enemy.pool] = 0;
	enemy.turn[enemy.pool] = 0;
	enemy.radius[enemy.pool] = 0;
	enemy.baseangle[enemy.pool] = 0;
	enemy.reload[enemy.pool] = 0;
	enemy.wait_animation[enemy.pool] = 4;
	enemy.speed_animation[enemy.pool] = 4;
	enemy.state_animation[enemy.pool] = 12;
	enemy.health[enemy.pool] = 1;
	enemy.delay[enemy.pool] = 0;
	enemy.tx[enemy.pool] = MAKELONG(x, 0);
	enemy.ty[enemy.pool] = MAKELONG(y, 0);
	enemy.tdx[enemy.pool] = 0;
	enemy.tdy[enemy.pool] = 0;

	enemy.sprite_type[enemy.pool] = &SpriteEnemy01;
	enemy.sprite_offset[enemy.pool] = NextOffset(SPRITE_OFFSET_ENEMY_START, SPRITE_OFFSET_ENEMY_END, &stage.sprite_enemy, &stage.sprite_enemy_count);

	sprite_configure(enemy.sprite_offset[enemy.pool], enemy.sprite_type[enemy.pool]);

	enemy.pool = (enemy.pool++)%FE_ENEMY;

}

void RemoveEnemy(unsigned char e) 
{
	vera_sprite_offset sprite_offset = enemy.sprite_offset[e];
    FreeOffset(sprite_offset, &stage.sprite_enemy_count);
    vera_sprite_disable(sprite_offset);
    enemy.used[e] = 0;
    enemy.enabled[e] = 0;
}

void MoveEnemy( unsigned char e, unsigned int flight, unsigned char turn, unsigned char speed) {
	enemy.move[e] = 1;
	if(speed) flight >>= (speed-1);
	enemy.flight[e] = flight;
	enemy.angle[e] = enemy.angle[e] + turn;
	enemy.speed[e] = speed;
	enemy.step[e]++;
}

void ArcEnemy( unsigned char e, unsigned char turn, unsigned char radius, unsigned char speed) {
	enemy.move[e] = 2;
	enemy.turn[e] = sgn_u8(turn);
	enemy.radius[e] = radius;
	enemy.delay[e] = 0;
	enemy.flight[e] = mul8u(abs_u8((unsigned char)turn), radius);
	enemy.baseangle[e] = enemy.angle[e];
	enemy.speed[e] = speed;
	enemy.step[e]++;
}


void LogicEnemies() {

	if (!enemy.pool) return;

	for(unsigned char e=0; e<64; e++) {

    #ifdef debug_scanlines
	    vera_display_set_border_color(1);
    #endif

		if(enemy.used[e] && enemy.side[e] == SIDE_ENEMY) {	

			if(!enemy.flight[e]) {
				switch(enemy.step[e]) {
				case 0:
					MoveEnemy(e, 530, 32, 2);
					break;
				case 1:
					ArcEnemy(e, -32, 2, 2);
					break;
				case 2:
					MoveEnemy(e, 440, 0, 2);
					break;
				case 3:
					ArcEnemy(e, -32, 2, 2);
					break;
				case 4:
					MoveEnemy(e, 440, 0, 2);
					enemy.step[e] = 1;
					break;
				}
			}

			if(enemy.flight[e]) {
				enemy.flight[e]--;
				if(enemy.move[e] == 1) {
					enemy.tdx[e] = vecx(enemy.angle[e], enemy.speed[e]);
					enemy.tdy[e] = vecy(enemy.angle[e], enemy.speed[e]);
				}

				if(enemy.move[e] == 2) {
					// Calculate current angle based on flight from x,y and angle startpoint.
					if(!enemy.delay[e]) {
						enemy.angle[e] += enemy.turn[e];
						enemy.angle[e] %= 64;
						enemy.delay[e] = enemy.radius[e];
						enemy.tdx[e] = vecx(enemy.angle[e], enemy.speed[e]);
						enemy.tdy[e] = vecy(enemy.angle[e], enemy.speed[e]);
					}
					enemy.delay[e]--;
				}
			} else {
				enemy.move[e] = 0;
			}

			enemy.tx[e] += enemy.tdx[e];
			enemy.ty[e] += enemy.tdy[e];



#ifdef debug_scanlines
			vera_display_set_border_color(2);
#endif

#ifdef __collision
			signed int x = (signed int)WORD1(enemy.tx[e]);
			signed int y = (signed int)WORD1(enemy.ty[e]);

			if(x>=0 && x<=640-32 && x>=0 && x<=480-32) {
				grid_insert(&ht_collision, 2, BYTE0(x>>2), BYTE0(y>>2), e);
			}
#endif

#ifdef debug_scanlines
			vera_display_set_border_color(3);
#endif

			if (enemy.reload[e] > 0) {
				enemy.reload[e]--;
			}

			if (!enemy.wait_animation[e]) {
				enemy.wait_animation[e] = enemy.speed_animation[e];
				if(!enemy.state_animation[e])
					enemy.state_animation[e] = 12;
				enemy.state_animation[e]--;
			}
			enemy.wait_animation[e]--;


			// gotoxy(0, 32);
			// printf("l=%5u a=%4u x=%4i y=%4i dx=%4i dy=%4i    ", loop++, enemy.angle[e], enemy.x[e], enemy.y[e], enemy.dx[e], enemy.dy[e]);
			// printf("a=%u, x=%i, y=%i, s=%u, m=%u, f=%u      ", 
			// 	enemy.angle[e], enemy.x[e], enemy.y[e], enemy.step[e], enemy.move[e], enemy.flight[e]
			// );

			// if(x > -64 && x < 640) {
				// if(!fighter.enabled[e]) {
					// EnableFighter(e);
					
				// }
				vera_sprite_offset sprite_offset = enemy.sprite_offset[e];
				Sprite* sprite = enemy.sprite_type[e];
				if(!enemy.enabled[e]) {
			    	vera_sprite_zdepth(sprite_offset, sprite->Zdepth);
					enemy.enabled[e] = 1;
				}
				// sprite_animate(sprite_offset, sprite, fighter.state_animation[e], fighter.wait_animation[e]);
				if(enemy.wait_animation[e]) {
					vera_sprite_set_xy(sprite_offset, x, y);
				} else {
					vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite->offset_image[enemy.state_animation[e]]);
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

