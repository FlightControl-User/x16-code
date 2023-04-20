#include <division.h>
#include <multiply.h>
#include <stdlib.h>
#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-enemy.h"
#include "equinoxe-bullet.h"
#include "equinoxe-math.h"
#include "equinoxe-stage.h"
#include "equinoxe-fighters.h"
#include "equinoxe-collision.h"
#include "equinoxe-bullet.h"
#include <ht.h>


#pragma data_seg(DATA_ENGINE_ENEMIES)
fe_enemy_t enemy; ///< This memory area is banked and must always be reached by local routines in the same bank for efficiency!

#ifdef __BANKING
#pragma code_seg(CODE_ENGINE_ENEMIES)
#pragma data_seg(CODE_ENGINE_ENEMIES)
#pragma bank(cx16_ram,BANK_ENGINE_ENEMIES)
#endif


void enemy_init()
{
    memset(&enemy, 0, sizeof(fe_enemy_t));
}

unsigned char enemy_add(unsigned char w, sprite_index_t enemy_sprite) 
{

    stage.enemy_count++;

	unsigned char e = stage.enemy_pool;

	while(enemy.used[e]) {
		e = (e+1)%FE_ENEMY;
	}
	
	enemy.used[e] = 1;
	enemy.enabled[e] = 0;

    enemy.wave[e] = w;

    fe_sprite_index_t s = fe_sprite_cache_copy(enemy_sprite);
    enemy.sprite[e] = s;

	enemy.side[e] = SIDE_ENEMY;
	enemy.move[e] = 0;
	enemy.moved[e] = 0;
	enemy.flight[e] = 0;
	enemy.angle[e] = 0;
	enemy.speed[e] = 0;
	enemy.action[e] = 0;
	enemy.turn[e] = 0;
	enemy.radius[e] = 0;
	enemy.baseangle[e] = 0;
	enemy.reload[e] = 0;

	enemy.wait_animation[e] = wave.animation_speed[w];
	enemy.speed_animation[e] = wave.animation_speed[w];
	enemy.state_animation[e] = 0;
    enemy.reverse_animation[e] = wave.animation_reverse[w];
    enemy.start_animation[e] = 0;
    enemy.stop_animation[e] = sprite_cache.count[s]-1;
    enemy.direction_animation[e] = 1;

	enemy.health[e] = 100;
	enemy.delay[e] = 0;

    stage_flightpath_t* flightpath = wave.enemy_flightpath[w];
    enemy.flightpath[e] = flightpath;

	enemy.sprite_offset[e] = sprite_next_offset();
	fe_sprite_configure(enemy.sprite_offset[e], s);

    signed int x = wave.x[w];
    signed int y = wave.y[w];

	enemy.tx[e] = MAKELONG((unsigned int)x, 0);
	enemy.ty[e] = MAKELONG((unsigned int)y, 0);
	enemy.tdx[e] = 0;
	enemy.tdy[e] = 0;
	
	stage.enemy_pool = (e+1)%FE_ENEMY;

    enemy_animate();

    unsigned char ret = 1;
    return ret;
}

void enemy_remove(unsigned char e) 
{
    if(enemy.used[e]) {
		// gotoxy(0, e);
		// printf("%02u -     ", e);
        enemy.used[e] = 0;
        enemy.enabled[e] = 0;
        vera_sprite_offset sprite_offset = enemy.sprite_offset[e];
        sprite_free_offset(sprite_offset);
        vera_sprite_disable(sprite_offset);
        palette_unuse_vram(sprite_cache.palette_offset[enemy.sprite[e]]);
        fe_sprite_cache_free(enemy.sprite[e]);

    }
}


unsigned char enemy_hit(unsigned char e, unsigned char b) 
{
    enemy.health[e] += bullet_energy_get(b); // unbanked to BRAM_ENGINE_BULLET
    if(enemy.health[e] <= 0) {
		return 1;
    }

    return 0;
}

void enemy_move( unsigned char e, unsigned int flight, unsigned char turn, unsigned char speed)
{
	enemy.move[e] = 1;
	if(speed>1) flight >>= (speed-1);
	enemy.flight[e] = flight;
	enemy.angle[e] = enemy.angle[e] + turn;
	enemy.speed[e] = speed;
}

void enemy_arc( unsigned char e, unsigned char turn, unsigned char radius, unsigned char speed)
{
	enemy.move[e] = 2;
	enemy.turn[e] = sgn_u8(turn);
	enemy.radius[e] = radius;
	enemy.delay[e] = 0;
	enemy.flight[e] = mul8u(abs_u8((unsigned char)turn), radius);
	enemy.baseangle[e] = enemy.angle[e];
	enemy.speed[e] = speed;
}

void enemy_animate() {

	for(unsigned char e=0; e<FE_ENEMY; e++) {

		if(enemy.used[e] && enemy.side[e] == SIDE_ENEMY) {	

			if (!enemy.wait_animation[e]) {
				enemy.wait_animation[e] = enemy.speed_animation[e];
                if(enemy.direction_animation[e]>0) {
                    if(enemy.state_animation[e] >= enemy.stop_animation[e]) {
                        if(enemy.reverse_animation[e]) {
                            enemy.direction_animation[e] = -1;                            
                        } else {
                            enemy.state_animation[e] = enemy.start_animation[e];
                        }
                    }
                }
 
                if(enemy.direction_animation[e]<0) {
                    if(enemy.state_animation[e] <= enemy.start_animation[e]) {
                        enemy.direction_animation[e] = 1;                            
                    }
                }
                enemy.state_animation[e] += enemy.direction_animation[e];
			}
			enemy.wait_animation[e]--;
        }
    }
}

void enemy_logic() {

	for(unsigned char e=0; e<FE_ENEMY; e++) {

		if(enemy.used[e] && enemy.side[e] == SIDE_ENEMY) {	

			if(!enemy.flight[e]) {

				// gotoxy(0, e);
				// printf("%02u - used", e);

				stage_flightpath_t* enemy_flightpath = enemy.flightpath[e];
				unsigned char enemy_action = enemy.action[e];
                stage_action_t* action = stage_get_flightpath_action(enemy_flightpath, enemy_action);
                unsigned char type = stage_get_flightpath_type(enemy_flightpath, enemy_action);
                unsigned char next = stage_get_flightpath_next(enemy_flightpath, enemy_action);

				// printf("efp=%p, ac=%03u, ty=%03u, ne=%03u - ", enemy_flightpath, enemy_action, type, next );

				unsigned int flight = 0;
				signed char turn = 0;
				unsigned char speed = 0;
				unsigned char radius = 0;

				switch(type) {

				case STAGE_ACTION_MOVE:
                    flight = stage_get_flightpath_action_move_flight(action);
                    turn = stage_get_flightpath_action_move_turn(action);
                    speed = stage_get_flightpath_action_move_speed(action);
                    // printf("move f=%03u, t=%03d, s=%03u, a=%03u - ", flight, turn, speed, next );

					enemy_move(e, flight, (unsigned char)turn, speed);
                    enemy.action[e] = next;
					break;

				case STAGE_ACTION_TURN:
                    turn = stage_get_flightpath_action_turn_turn(action);
                    radius = stage_get_flightpath_action_turn_radius(action);
                    speed = stage_get_flightpath_action_turn_speed(action);
                    // printf("turn t=%03d, r=%03u, s=%03u, a=%03u - ", turn, radius, speed, next );

					enemy_arc( e, (unsigned char)turn, radius, speed);
                    enemy.action[e] = next;
					break;
        

				case STAGE_ACTION_END:

                    // printf("end.");


                    stage_enemy_remove(e);
					break;
                    
				}
			} else {
				enemy.flight[e]--;

				if( enemy.move[e]) {
					if(enemy.move[e] == 1) {
						enemy.tdx[e] = math_vecx(enemy.angle[e], enemy.speed[e]);
						enemy.tdy[e] = math_vecy(enemy.angle[e], enemy.speed[e]);
						enemy.move[e] = 0;
					}
					if(enemy.move[e] == 2) {
						// Calculate current angle based on flight from x,y and angle startpoint.
						if(!enemy.delay[e]) {
							enemy.angle[e] += enemy.turn[e];
							enemy.angle[e] %= 64;
							enemy.delay[e] = enemy.radius[e];
							enemy.tdx[e] = math_vecx(enemy.angle[e], enemy.speed[e]);
							enemy.tdy[e] = math_vecy(enemy.angle[e], enemy.speed[e]);
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



			signed int x = (signed int)WORD1(enemy.tx[e]);
			signed int y = (signed int)WORD1(enemy.ty[e]);

			vera_sprite_offset sprite_offset = enemy.sprite_offset[e];

            // printf("x=%05i, y=%05i, offset=%04x", x, y, sprite_offset);

			if(x>=-68 && x<640+68 && y>=-68 && y<480+68) {

				if(!enemy.enabled[e]) {
			    	vera_sprite_zdepth(sprite_offset, sprite_cache.zdepth[enemy.sprite[e]]);
					enemy.enabled[e] = 1;
				}

			// gotoxy(0, e);
			// printf("%02u - wait=%u", e, enemy.wait_animation[e]);


				if(enemy.wait_animation[e]) {
					vera_sprite_set_xy(sprite_offset, x, y);
				} else {
					// vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_cache.vram_image_offset[(unsigned int)enemy.sprite[e]*16+enemy.state_animation[e]]);
					vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_image_cache_vram(enemy.sprite[e], enemy.state_animation[e]));
				}

#ifdef __BULLET                
				unsigned int r = rand();
				if(r>=65300) {
					bullet_enemy_fire((unsigned int)x, (unsigned int)y);
				}
#endif
				collision_insert(&ht_collision, BYTE0(x>>2), BYTE0(y>>2), COLLISION_ENEMY | e);
			} else {
				if(enemy.enabled[e]) {
			    	vera_sprite_disable(sprite_offset);
					enemy.enabled[e] = 0;
				}
			}
		}
	}
}

unsigned char enemy_get_wave(unsigned char e) {
	return enemy.wave[e];
}

#pragma code_seg(Code)
#pragma data_seg(Data)
#pragma nobank


inline void enemy_bank() {
    bank_push_set_bram(BANK_ENGINE_ENEMIES);
}

inline void enemy_unbank() {
    bank_pull_bram();
}

