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

volatile unsigned char shoot = 12;

void enemy_init()
{
    bank_push_bram(); bank_set_bram(fe.bram_bank);
    
    memset(&enemy, 0, sizeof(fe_enemy_t));

    bank_pull_bram();
}


unsigned char AddEnemy(sprite_t* sprite, enemy_flightpath_t* flightpath) 
{

    bank_push_bram(); bank_set_bram(fe.bram_bank);

	unsigned char e = fe.enemy_pool;

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
	enemy.action[e] = 0;
	enemy.turn[e] = 0;
	enemy.radius[e] = 0;
	enemy.baseangle[e] = 0;
	enemy.reload[e] = 0;

	enemy.wait_animation[e] = 4;
	enemy.speed_animation[e] = 4;
	enemy.state_animation[e] = 0;
    enemy.reverse_animation[e] = sprite->reverse;
    enemy.start_animation[e] = 0;
    enemy.stop_animation[e] = sprite->count-1;
    enemy.direction_animation[e] = 1;

	enemy.health[e] = 100;
	enemy.delay[e] = 0;

    enemy.flightpath[e] = flightpath;

	enemy.sprite_type[e] = sprite;
    sprite_vram_allocate(sprite, VERA_HEAP_SEGMENT_SPRITES);

	enemy.sprite_offset[e] = NextOffset(SPRITE_OFFSET_ENEMY_START, SPRITE_OFFSET_ENEMY_END, &stage.sprite_enemy, &stage.sprite_enemy_count);
	sprite_configure(enemy.sprite_offset[e], enemy.sprite_type[e]);

    enemy.sprite_palette[e] = sprite->PaletteOffset;
    sprite_palette(enemy.sprite_offset[e], enemy.sprite_palette[e]);

	enemy.tx[e] = 0;
	enemy.ty[e] = 0;
	enemy.tdx[e] = 0;
	enemy.tdy[e] = 0;
	
	enemy.aabb_min_x[e] = sprite->aabb[0];
	enemy.aabb_min_y[e] = sprite->aabb[1];
	enemy.aabb_max_x[e] = sprite->aabb[2];
	enemy.aabb_max_y[e] = sprite->aabb[3];

	fe.enemy_pool = (e+1)%FE_ENEMY;

    bank_pull_bram();
    return 1;
}

unsigned char RemoveEnemy(unsigned char e) 
{

    bank_push_bram(); bank_set_bram(fe.bram_bank);

    vera_sprite_offset sprite_offset = enemy.sprite_offset[e];
    FreeOffset(sprite_offset, &stage.sprite_enemy_count);
    vera_sprite_disable(sprite_offset);
    palette16_unuse(enemy.sprite_palette[e]);
    sprite_vram_free(enemy.sprite_type[e], VERA_HEAP_SEGMENT_SPRITES);
    enemy.used[e] = 0;
    enemy.enabled[e] = 0;

    bank_pull_bram();
    return 1;
}

unsigned char HitEnemy(unsigned char e, unsigned char b) 
{
    bank_push_bram(); bank_set_bram(fe.bram_bank);

    enemy.health[e] += bullet.energy[b];
    if(enemy.health[e] <= 0) {
        bank_pull_bram();
        return RemoveEnemy(e);
    }

    bank_pull_bram();
    return 0;
}


void MoveEnemy( unsigned char e, unsigned int flight, unsigned char turn, unsigned char speed)
{
	enemy.move[e] = 1;
	if(speed>1) flight >>= (speed-1);
	enemy.flight[e] = flight;
	enemy.angle[e] = enemy.angle[e] + turn;
	enemy.speed[e] = speed;
}

void ArcEnemy( unsigned char e, unsigned char turn, unsigned char radius, unsigned char speed)
{
	enemy.move[e] = 2;
	enemy.turn[e] = sgn_u8(turn);
	enemy.radius[e] = radius;
	enemy.delay[e] = 0;
	enemy.flight[e] = mul8u(abs_u8((unsigned char)turn), radius);
	enemy.baseangle[e] = enemy.angle[e];
	enemy.speed[e] = speed;
}


void LogicEnemies() {

    bank_push_bram(); bank_set_bram(fe.bram_bank);

	for(unsigned char e=0; e<FE_ENEMY; e++) {

		if(enemy.used[e] && enemy.side[e] == SIDE_ENEMY) {	

    #ifdef __CPULINES
	    vera_display_set_border_color(WHITE);
    #endif

			// FP tdx = enemy.tdx[e];
			// FP tdy = enemy.tdy[e];
            

            // gotoxy(0,11+e);
            // printf("e=%02u, f=%03u", e, enemy.flight[e]);            

			if(!enemy.flight[e]) {
                enemy_flightpath_t* flightpath = enemy.flightpath[e];
                unsigned char action = enemy.action[e];
                enemy_flightpath_t flight = flightpath[action];
                unsigned char type = flight.type;

                // printf(", a=%03u, at=%03u", action, type);

				switch(type) {
				case ENEMY_ACTION_START:
                    enemy_action_start_t* action_start = (enemy_action_start_t*)(flight.action);
                    signed int x = action_start->x;
                    signed int y = action_start->y;
                    // printf(", start x/y=%03i/%03i, p=%x    ", x, y, (word)flight.action);
                    enemy.tx[e] = MAKELONG((word)x,0);
                    enemy.ty[e] = MAKELONG((word)y,0);
                    enemy.action[e] = flight.next;
                    signed char dx = action_start->dx;
                    signed char dy = action_start->dy;
                    x += dx;
                    y += dy;
                    action_start->x = x;
                    action_start->y = y;
					break;
				case ENEMY_ACTION_MOVE:
                    enemy_action_move_t* action_move = (enemy_action_move_t*)flight.action;
                    // printf(", move f=%03u, t=%03u, s=%03u", action_move->flight, (unsigned char)action_move->turn, action_move->speed );
					MoveEnemy( e, 
                        action_move->flight, 
                        (unsigned char)action_move->turn, 
                        action_move->speed
                    );
                    enemy.action[e] = flight.next;
					break;
				case ENEMY_ACTION_TURN:
                    enemy_action_turn_t* action_turn = (enemy_action_turn_t*)flight.action;
                    // printf(", move t=%03u, r=%03u, s=%03u    ", (unsigned char)action_turn->turn, action_turn->radius, action_turn->speed );
					ArcEnemy( e, 
                        (unsigned char)action_turn->turn, 
                        action_turn->radius, 
                        action_turn->speed
                    );
                    enemy.action[e] = flight.next;
					break;
				case ENEMY_ACTION_END:
                    enemy_action_end_t* action_end = (enemy_action_end_t*)flight.action;
                    // printf(", end e=%03u    ", action_end->explode );
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


			signed int x = (signed int)WORD1(enemy.tx[e]);
			signed int y = (signed int)WORD1(enemy.ty[e]);

			vera_sprite_offset sprite_offset = enemy.sprite_offset[e];
			sprite_t* sprite = enemy.sprite_type[e];

			if(x>=-31 && x<640 && y>=-31 && y<480) {
#ifdef __CPULINES
			vera_display_set_border_color(RED);
#endif
				grid_insert(&ht_collision, 2, BYTE0(x>>2), BYTE0(y>>2), e);
#ifdef __CPULINES
			vera_display_set_border_color(PURPLE);
#endif
				if(!enemy.enabled[e]) {
			    	vera_sprite_zdepth(sprite_offset, sprite->Zdepth);
					enemy.enabled[e] = 1;
				}

				if(enemy.wait_animation[e]) {
					vera_sprite_set_xy(sprite_offset, x, y);
				} else {
					vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite->vram_image_offset[enemy.state_animation[e]]);
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

    bank_pull_bram();
}

