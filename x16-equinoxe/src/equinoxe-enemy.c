#include <division.h>
#include <multiply.h>
#include <stdlib.h>
#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-enemy.h"
#include "equinoxe-math.h"
#include "equinoxe-stage.h"
#include "equinoxe-fighters.h"
#include "equinoxe-collision.h"
#include "equinoxe-bullet.h"
#include <ht.h>

// #pragma var_model(zp)

void enemy_init()
{
    bank_push_set_bram(BRAM_FLIGHTENGINE);
    
    memset(&enemy, 0, sizeof(fe_enemy_t));

    enemy.cs1 = 255;
    enemy.cs2 = 255;
    enemy.cs3 = 255;
    enemy.cs4 = 255;

    bank_pull_bram();
}


unsigned char enemy_add(unsigned char w) 
{

    bank_push_set_bram(BRAM_FLIGHTENGINE);

    stage.enemy_count++;

	unsigned char e = stage.enemy_pool;

	while(enemy.used[e]) {
		e = (e+1)%FE_ENEMY;
	}
	
	enemy.used[e] = 1;
	enemy.enabled[e] = 0;

    enemy.wave[e] = w;

    fe_sprite_index_t s = fe_sprite_cache_copy(wave.enemy_sprite[w]);

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

    // stage.enemy_xor = enemy_checkxor();

    enemy_animate();

    bank_pull_bram();
    unsigned char ret = 1;
    return ret;
}

unsigned char enemy_remove(unsigned char e) 
{
    bank_push_set_bram(BRAM_FLIGHTENGINE);

    if(enemy.used[e]) {
        vera_sprite_offset sprite_offset = enemy.sprite_offset[e];
        sprite_free_offset(sprite_offset);
        vera_sprite_disable(sprite_offset);
        palette16_unuse(sprite_cache.palette_offset[enemy.sprite[e]]);
        fe_sprite_cache_free(enemy.sprite[e]);
        enemy.used[e] = 0;
        enemy.enabled[e] = 0;

        stage.enemy_count--;
    }

    bank_pull_bram();

    unsigned char ret = 1;
    return ret;
}

unsigned char enemy_hit(unsigned char e, unsigned char b) 
{
    bank_push_set_bram(BRAM_FLIGHTENGINE);

    enemy.health[e] += bullet.energy[b];
    if(enemy.health[e] <= 0) {
        bank_pull_bram();
        return enemy_remove(e);
    }

    bank_pull_bram();
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

    bank_push_set_bram(BRAM_FLIGHTENGINE);

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

    bank_pull_bram();
}

void enemy_logic() {

    bank_push_set_bram(BRAM_FLIGHTENGINE);

	for(unsigned char e=0; e<FE_ENEMY; e++) {

		if(enemy.used[e] && enemy.side[e] == SIDE_ENEMY) {	

			if(!enemy.flight[e]) {
                stage_flightpath_t* flightpath = enemy.flightpath[e];
                unsigned char action = enemy.action[e];
                bank_push_bram(); bank_set_bram(BRAM_LEVELS);
                stage_flightpath_t flightnode = flightpath[action];
                unsigned char type = flightnode.type;
                unsigned char next = flightnode.next;
                bank_pull_bram();

				switch(type) {

				case STAGE_ACTION_MOVE: {

                    bank_push_bram(); bank_set_bram(BRAM_LEVELS);
                    stage_action_move_t* action_move = (stage_action_move_t*)flightnode.action;
                    unsigned int flight = action_move->flight;
                    signed char turn = action_move->turn;
                    unsigned char speed = action_move->speed;
                    // printf(", move f=%03u, t=%03u, s=%03u", action_move->flight, (unsigned char)action_move->turn, action_move->speed );
                    bank_pull_bram();

					enemy_move(e, flight, (unsigned char)turn, speed);
                    enemy.action[e] = next;
					break;
                    }

				case STAGE_ACTION_TURN: {

                    bank_push_bram(); bank_set_bram(BRAM_LEVELS);
                    stage_action_turn_t* action_turn = (stage_action_turn_t*)flightnode.action;
                    signed char turn = action_turn->turn;
                    unsigned char radius = action_turn->radius;
                    unsigned char speed = action_turn->speed;
                    // printf(", move t=%03u, r=%03u, s=%03u    ", (unsigned char)action_turn->turn, action_turn->radius, action_turn->speed );
                    bank_pull_bram();

					enemy_arc( e, (unsigned char)turn, radius, speed);
                    enemy.action[e] = next;
					break;
                    }

				case STAGE_ACTION_END: {

                    bank_push_bram(); bank_set_bram(BRAM_LEVELS);
                    stage_action_end_t* action_end = (stage_action_end_t*)flightnode.action;
                    // printf(", end e=%03u    ", action_end->explode );
                    bank_pull_bram();

                    stage_enemy_remove(enemy.wave[e], e);
					break;
                    }
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

				if(enemy.wait_animation[e]) {
					vera_sprite_set_xy(sprite_offset, x, y);
				} else {
					// vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_cache.vram_image_offset[(unsigned int)enemy.sprite[e]*16+enemy.state_animation[e]]);
					vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_image_cache_vram(enemy.sprite[e], enemy.state_animation[e]));
				}

#ifdef __BULLET                
				unsigned int r = rand();
				if(r>=65300) {
					FireBulletEnemy(e);
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

    // stage.enemy_xor = enemy_checkxor();

    // if(enemy.cs1 != 255)
    //     printf("error checksum cs1!");
    // if(enemy.cs2 != 255)
    //     printf("error checksum cs2!");
    // if(enemy.cs3 != 255)
    //     printf("error checksum cs3!");
    // if(enemy.cs4 != 255)
    //     printf("error checksum cs4!");

    bank_pull_bram();
}

char enemy_checkxor()
{
    bank_push_set_bram(BRAM_FLIGHTENGINE);
    unsigned char xor = 0;
    unsigned char* p = (char*)&enemy;
    unsigned int s = sizeof(fe_enemy_t);
    for(unsigned int i=0; i<s; i++) {
        xor ^= (unsigned char)*p;
        p++;
    }
    bank_pull_bram();
    return xor;
}

// #pragma var_model(mem)

