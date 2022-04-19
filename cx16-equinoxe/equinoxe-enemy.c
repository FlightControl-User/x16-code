#include <division.h>
#include <multiply.h>
#include <stdlib.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-enemy.h"
#include "equinoxe-math.h"
#include "equinoxe-stage.h"
#include "equinoxe-fighters.h"
#include "equinoxe-collision.h"
#include "equinoxe-bullet.h"
#include <ht.h>

volatile unsigned char shoot = 12;

void AddEnemy(char t, unsigned int x, unsigned int y) {

	unsigned char e = enemy_pool;

	while(enemy.used[e]) {
		e = (e+1)%FE_ENEMY;
	}
	
	enemy.used[e] = 1;
	enemy.enabled[e] = 0;

	enemy.type[e] = entity_type_enemy;
	enemy.side[e] = SIDE_ENEMY;
	enemy.move[e] = 0;
	enemy.moved[e] = 0;
	enemy.flight[e] = 0;
	enemy.angle[e] = 0;
	enemy.speed[e] = 0;
	enemy.step[e] = 0;
	enemy.turn[e] = 0;
	enemy.radius[e] = 0;
	enemy.baseangle[e] = 0;
	enemy.reload[e] = 0;
	enemy.wait_animation[e] = 4;
	enemy.speed_animation[e] = 4;
	enemy.state_animation[e] = 12;
	enemy.health[e] = 1;
	enemy.delay[e] = 0;

	enemy.sprite_type[e] = &SpriteEnemy01;
	enemy.sprite_offset[e] = NextOffset(SPRITE_OFFSET_ENEMY_START, SPRITE_OFFSET_ENEMY_END, &stage.sprite_enemy, &stage.sprite_enemy_count);

	sprite_configure(enemy.sprite_offset[e], enemy.sprite_type[e]);

	enemy.tx[e] = MAKELONG(x, 0);
	enemy.ty[e] = MAKELONG(y, 0);
	enemy.tdx[e] = 0;
	enemy.tdy[e] = 0;
	
	enemy.aabb_min_x[e] = SpriteEnemy01.aabb[0];
	enemy.aabb_min_y[e] = SpriteEnemy01.aabb[1];
	enemy.aabb_max_x[e] = SpriteEnemy01.aabb[2];
	enemy.aabb_max_y[e] = SpriteEnemy01.aabb[3];

	enemy_pool = (e+1)%FE_ENEMY;

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

	if (!enemy_pool) return;

	for(unsigned char e=0; e<FE_ENEMY-1; e++) {

		if(enemy.used[e] && enemy.side[e] == SIDE_ENEMY) {	

    #ifdef debug_scanlines
	    vera_display_set_border_color(1);
    #endif

			// FP tdx = enemy.tdx[e];
			// FP tdy = enemy.tdy[e];

			if(!enemy.flight[e]) {
				switch(enemy.step[e]) {
				case 0:
					shoot++;
					if(shoot>22) shoot=10;
					MoveEnemy(e, modr16u(rand(),400,0)+120, shoot, 2);
					break;
				case 1:
					ArcEnemy(e, -32, 2, 2);
					break;
				case 2:
					MoveEnemy(e, 40, 0, 2);
					break;
				case 3:
					ArcEnemy(e, -36, 2, 2);
					break;
				case 4:
					MoveEnemy(e, 40, 0, 2);
                    // FireBulletEnemy()
					enemy.step[e] = 1;
					break;
				}
			} else {
				enemy.flight[e]--;

				if( enemy.move[e]) {
					if(enemy.move[e] == 1) {
						enemy.tdx[e] = vecx(enemy.angle[e], enemy.speed[e]);
						enemy.tdy[e] = vecy(enemy.angle[e], enemy.speed[e]);
						enemy.move[e] = 0;
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
				}
			}

			enemy.tx[e] += enemy.tdx[e];
			enemy.ty[e] += enemy.tdy[e];

			// enemy.tdx[e] = tdx;
			// enemy.tdy[e] = tdy;

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


			signed int x = (signed int)WORD1(enemy.tx[e]);
			signed int y = (signed int)WORD1(enemy.ty[e]);

			vera_sprite_offset sprite_offset = enemy.sprite_offset[e];
			Sprite* sprite = enemy.sprite_type[e];

			if(x>=-31 && x<640 && y>=-31 && y<480) {
#ifdef debug_scanlines
			vera_display_set_border_color(2);
#endif
				grid_insert(&ht_collision, 2, BYTE0(x>>2), BYTE0(y>>2), e);
#ifdef debug_scanlines
			vera_display_set_border_color(3);
#endif
				if(!enemy.enabled[e]) {
			    	vera_sprite_zdepth(sprite_offset, sprite->Zdepth);
					enemy.enabled[e] = 1;
				}
				if(enemy.wait_animation[e]) {
					vera_sprite_set_xy(sprite_offset, x, y);
				} else {
					vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite->offset_image[enemy.state_animation[e]]);
				}
				unsigned int r = rand();
				if(r>=65200) {
					FireBulletEnemy(e);
				}
			} else {
				if(enemy.enabled[e]) {
			    	vera_sprite_disable(sprite_offset);
					enemy.enabled[e] = 0;
				}
			}
		}
	}
}

unsigned char SpawnEnemies(unsigned char t, unsigned int x, unsigned int y) {

	AddEnemy(t, x, y);
	return 1;
}

