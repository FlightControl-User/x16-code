#include <cx16.h>
#include "equinoxe.h"
#include "equinoxe-animate-lib.h"


#pragma data_seg(DATA_ENGINE_ENEMIES)

#ifdef __BANKING
#pragma code_seg(CODE_ENGINE_ENEMIES)
#pragma data_seg(DATA_ENGINE_ENEMIES)
#pragma bank(cx16_ram,BANK_ENGINE_ENEMIES)
#endif

void enemy_init()
{
}

unsigned char enemy_add(unsigned char w, sprite_index_t sprite_enemy) 
{

    stage.enemy_count++;

	unsigned char e = flight_add(FLIGHT_ENEMY, SIDE_ENEMY, sprite_enemy);

    flight.wave[e] = w;

	flight.animate[e] = animate_add(
		sprite_cache.count[flight.cache[e]]-1, 
		0,
		0,
		wave.animation_speed[w],
		1, 
		wave.animation_reverse[w]
		);

	flight.health[e] = 100;
	flight.impact[e] = -30;

    stage_flightpath_t* flightpath = wave.enemy_flightpath[w];
    flight.flightpath[e] = flightpath;

	flight.xf[e] = 0;
	flight.yf[e] = 0;
	flight.xi[e] = (unsigned int)wave.x[w];
	flight.yi[e] = (unsigned int)wave.y[w];
	flight.xd[e] = 0;
	flight.yd[e] = 0;
	
    unsigned char ret = 1;
    return ret;
}

void enemy_remove(unsigned char e) 
{
    if(flight.used[e]) {
		animate_del(flight.animate[e]);
		flight_remove(FLIGHT_ENEMY, e);
    }
}


unsigned char enemy_hit(unsigned char e, signed char impact) 
{
	
    flight.health[e] += impact;
    if(flight.health[e] <= 0) {
		flight.collided[e] = 1;
		return 1;
    }

    return 0;
}

void enemy_move( unsigned char e, unsigned int moving, unsigned char turn, unsigned char speed)
{
	flight.move[e] = 1;
	if(speed>1) moving >>= (speed-1);
	flight.moving[e] = moving;
	flight.angle[e] = flight.angle[e] + turn;
	flight.speed[e] = speed;
}

void enemy_arc( unsigned char e, unsigned char turn, unsigned char radius, unsigned char speed)
{
	flight.move[e] = 2;
	flight.turn[e] = sgn_u8(turn);
	flight.radius[e] = radius;
	flight.delay[e] = 0;
	flight.moving[e] = mul8u(abs_u8((unsigned char)turn), radius);
	flight.speed[e] = speed;
}

void enemy_logic() {

    flight_index_t e = flight_root(FLIGHT_ENEMY);
	while(e) {

		flight_index_t en = flight_next(e);

		if(flight.type[e] == FLIGHT_ENEMY && flight.used[e]) {	

			if(!flight.moving[e]) {

				// gotoxy(0, e);
				// printf("%02u - used", e);

				stage_flightpath_t* enemy_flightpath = flight.flightpath[e];
				unsigned char enemy_action = flight.action[e];
                stage_action_t* action = stage_get_flightpath_action(enemy_flightpath, enemy_action);
                unsigned char type = stage_get_flightpath_type(enemy_flightpath, enemy_action);
                unsigned char next = stage_get_flightpath_next(enemy_flightpath, enemy_action);

				// printf("efp=%p, ac=%03u, ty=%03u, ne=%03u - ", enemy_flightpath, enemy_action, type, next );

				unsigned int path = 0;
				signed char turn = 0;
				unsigned char speed = 0;
				unsigned char radius = 0;

				switch(type) {

				case STAGE_ACTION_MOVE:
                    path = stage_get_flightpath_action_move_flight(action);
                    turn = stage_get_flightpath_action_move_turn(action);
                    speed = stage_get_flightpath_action_move_speed(action);
                    // printf("move f=%03u, t=%03d, s=%03u, a=%03u - ", flight, turn, speed, next );

					enemy_move(e, path, (unsigned char)turn, speed);
                    flight.action[e] = next;
					break;

				case STAGE_ACTION_TURN:
                    turn = stage_get_flightpath_action_turn_turn(action);
                    radius = stage_get_flightpath_action_turn_radius(action);
                    speed = stage_get_flightpath_action_turn_speed(action);
                    // printf("turn t=%03d, r=%03u, s=%03u, a=%03u - ", turn, radius, speed, next );

					enemy_arc( e, (unsigned char)turn, radius, speed);
                    flight.action[e] = next;
					break;
        

				case STAGE_ACTION_END:
                    stage_enemy_remove(e);
					continue; // After removal, continue with the next enemy.
                    
				}
			} else {
				flight.moving[e]--;

				if( flight.move[e]) {
					if(flight.move[e] == 1) {
						flight.xd[e] = (unsigned int)math_vecx(flight.angle[e], flight.speed[e]);
						flight.yd[e] = (unsigned int)math_vecy(flight.angle[e], flight.speed[e]);
						flight.move[e] = 0;
					}
					if(flight.move[e] == 2) {
						// Calculate current angle based on flight from x,y and angle startpoint.
						if(!flight.delay[e]) {
							flight.angle[e] += flight.turn[e];
							flight.angle[e] %= 64;
							flight.delay[e] = flight.radius[e];
							flight.xd[e] = (unsigned int)math_vecx(flight.angle[e], flight.speed[e]);
							flight.yd[e] = (unsigned int)math_vecy(flight.angle[e], flight.speed[e]);
						}
						flight.delay[e]--;
					}
				}
			}

            char* const xf = (char*)&flight.xf;
            char* const yf = (char*)&flight.yf;
            char* const xi = (char*)&flight.xi;
            char* const yi = (char*)&flight.yi;
            char* const xd = (char*)&flight.xd;
            char* const yd = (char*)&flight.yd;

            {kickasm(uses xf, uses yf, uses xi, uses yi, uses xd, uses yd) {{
                lda e
                asl
                tay
                ldx e
                lda xf,x        // Load the fractional part of the coordinate.
                clc             // For addition, clear the carry.
                adc xd,y        // Add the low byte (=fractional part) of the delta.
                sta xf,x        // Store the low byte of the delta in the fractional part of the coordinate.
                lda xi,y        // Load the low byte of the integer part of the coordinate.
                adc xd+1,y      // Add the high byte (=integer part) of the delta.
                sta xi,y        // Store the result in the low byte of the integer part of the coordinate.
                lda xd+1,y      // Load back the high byte of the axis delta, it may be negative.
                ora #$7f        // We check the sign bit.
                bmi !+          // If it was minus, the result in A will be $FF.
                lda #0          // The result was not minus, so just add carry.
                !:
                adc xi+1,y      // Now do the signed final addition.
                sta xi+1,y      // And store the result, we're done.

                lda yf,x        // Load the fractional part of the coordinate.
                clc             // For addition, clear the carry.
                adc yd,y        // Add the low byte (=fractional part) of the delta.
                sta yf,x        // Store the low byte of the delta in the fractional part of the coordinate.
                lda yi,y        // Load the low byte of the integer part of the coordinate.
                adc yd+1,y      // Add the high byte (=integer part) of the delta.
                sta yi,y        // Store the result in the low byte of the integer part of the coordinate.
                lda yd+1,y      // Load back the high byte of the delta, it may be negative.
                ora #$7f        // We check the sign bit.
                bmi !+          // If it was minus, the result in A will be $FF.
                lda #0          // The result was not minus, so just add carry.
                !:
                adc yi+1,y      // Now do the signed final addition.
                sta yi+1,y      // And store the result, we're done.
            }};}

			unsigned int x = flight.xi[e];
			unsigned int y = flight.yi[e];

			if (flight.reload[e] > 0) {
				flight.reload[e]--;
			}

			// vera_sprite_offset sprite_offset = flight.sprite_offset[e];

            // printf("x=%05i, y=%05i, offset=%04x", x, y, sprite_offset);

			// if(x>=-68 && x<640+68 && y>=-68 && y<480+68) {

			// 	if(!flight.enabled[e]) {
			//     	vera_sprite_zdepth(sprite_offset, sprite_cache.zdepth[flight.sprite[e]]);
			// 		flight.enabled[e] = 1;
			// 	}

			// // gotoxy(0, e);
			// // printf("%02u - wait=%u", e, flight.wait_animation[e]);


			// 	if(animate_is_waiting(flight.animate[e])) {
			// 		vera_sprite_set_xy(sprite_offset, x, y);
			// 	} else {
			// 		// vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_cache.vram_image_offset[(unsigned int)flight.sprite[e]*16+flight.state_animation[e]]);
			// 		vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, 
			// 			sprite_image_cache_vram(flight.sprite[e], animate_get_state(flight.animate[e])));
			// 	}

#ifdef __BULLET         
				unsigned int r = rand();
				if(r>=65300) {
					stage_bullet_add(flight.xi[e], flight.yi[e], flight.xi[stage.player], flight.yi[stage.player], 4, SIDE_ENEMY, b002);
				}
#endif
				animate_logic(flight.animate[e]);
#ifdef __COLLISION
				collision_insert(e);
#endif
			// } else {
			// 	if(flight.enabled[e]) {
			//     	vera_sprite_disable(sprite_offset);
			// 		flight.enabled[e] = 0;
			// 	}
			// }
		}
		e = en;
	}
}

unsigned char enemy_get_wave(unsigned char e) {
	return flight.wave[e];
}

#pragma code_seg(Code)
#pragma data_seg(Data)
#pragma nobank

inline void enemy_bank() {
}

inline void enemy_unbank() {
}

signed char enemy_impact(unsigned char e) {
	signed char impact = flight.impact[e];
	return impact;
}

// This will need rework
unsigned char enemy_has_collided(unsigned char e) {
	unsigned char collided = flight.collided[e];
	return collided;
}

