#include <cx16-mouse.h>

#include "equinoxe-bullet.h"
#include "equinoxe-collision.h"
#include "equinoxe-defines.h"
#include "equinoxe-flightengine-types.h"
#include "equinoxe-flightflight.h"
#include "equinoxe-flight.h"
#include "equinoxe-stage.h"
#include "equinoxe-types.h"
#include "equinoxe.h"

#pragma data_seg(DATA_ENGINE_PLAYERS)
fe_flight_t flight;
fe_engine_t engine;

#pragma data_seg(CODE_ENGINE_PLAYERS)

#pragma code_seg(Code)

void player_init() {
}

void player_add(sprite_index_t sprite_flight, sprite_index_t sprite_engine) {

    bank_push_set_bram(BANK_ENGINE_FLIGHT);

    unsigned char p = flight_add();

    stage.player_count++;

    flight.used[p] = 1;
    flight.enabled[p] = 0;

    flight.moved[p] = 2;
    flight.firegun[p] = 0;
    flight.reload[p] = 0;

    flight.health[p] = 100;
    flight.impact[p] = -100;

    flight.speed_animation[p] = 8;
    flight.wait_animation[p] = flight.speed_animation[p];
    flight.state_animation[p] = 3;

    unsigned char s = fe_sprite_cache_copy(sprite_flight);
    flight.sprite[p] = s;

    flight.sprite_offset[p] = sprite_next_offset();
    fe_sprite_configure(flight.sprite_offset[p], s);

    flight.tx[p] = MAKELONG(320, 0);
    flight.ty[p] = MAKELONG(200, 0);
    flight.tdx[p] = 0;
    flight.tdy[p] = 0;

    // Engine
    while (flight.used[stage.engine_pool]) {
        stage.engine_pool = (stage.engine_pool++) % FE_ENGINE;
    }

    unsigned char n = flight_add();

    flight.engine[p] = n;

    flight.speed_animation[n] = 1;
    flight.wait_animation[n] = flight.speed_animation[n];

    unsigned char cn = fe_sprite_cache_copy(sprite_engine);
    flight.sprite[n] = cn;

    flight.sprite_offset[n] = sprite_next_offset();
    fe_sprite_configure(flight.sprite_offset[n], cn);

    bank_pull_bram();
}

void player_remove(unsigned char p) {

    if (flight.used[p]) {
        unsigned char n = flight.engine[p];
        flight_remove(p);
        flight_remove(n);
        stage.player_count--;
    }
}

void player_hit(unsigned char p, signed char impact) {

    if (flight.used[p]) {
        flight.collided[p] = 1; // TODO isolate this.
        flight.health[p] += impact;
        if(flight.health[p]<=0) {
            player_remove(p);
        }
    }
}

void player_logic() {

    for (flight_index_t p=0; p<128; p++) {

#ifdef debug_scanlines
        vera_display_set_border_color(6);
#endif

        if (flight.used[p]) {

            if (flight.reload[p] > 0) {
                flight.reload[p]--;
            }

            if (!flight.wait_animation[p]) {
                flight.wait_animation[p] = flight.speed_animation[p];
                if (cx16_mouse.x < cx16_mouse.px && flight.state_animation[p] > 0) {
                    // Added fragment
                    flight.state_animation[p] -= 1;
                    flight.moved[p] = 2;
                }
                if (cx16_mouse.x > cx16_mouse.px && flight.state_animation[p] < 6) {
                    flight.state_animation[p] += 1;
                    flight.moved[p] = 2;
                }

                if (flight.moved[p] == 1) {
                    if (flight.state_animation[p] < 3) {
                        flight.state_animation[p] += 1;
                    }
                    if (flight.state_animation[p] > 3) {
                        flight.state_animation[p] -= 1;
                    }
                    if (flight.state_animation[p] == 3) {
                        flight.moved[p] = 0;
                    }
                }

                if (flight.moved[p] == 2) {
                    flight.moved[p]--;
                }
            }
            flight.wait_animation[p]--;

            unsigned char n = flight.engine[p];

            if (!flight.wait_animation[n]) {
                flight.state_animation[n]++;
                flight.state_animation[n] &= 0xF;
                flight.wait_animation[n] = flight.speed_animation[n];
            }
            flight.wait_animation[n]--;

#ifdef __BULLET
            if (cx16_mouse.status == 1 && flight.reload[p] <= 0) {
                unsigned int x = WORD1(flight.tx[p]);
                unsigned int y = WORD1(flight.ty[p]);
                if (flight.firegun[p]) {
                    x += (signed char)16;
                }
                flight.firegun[p] = flight.firegun[p] ^ 1;
                flight.reload[p] = 8;
                bullet_player_fire(x, y);
            }
#endif

            flight.tx[p] = MAKELONG((word)(cx16_mouse.x), 0);
            flight.ty[p] = MAKELONG((word)(cx16_mouse.y), 0);

            flight.cx[p] = BYTE0(WORD1(flight.tx[p]) >> 2);
            flight.cy[p] = BYTE0(WORD1(flight.ty[p]) >> 2);

            volatile signed int flightx = (signed int)WORD1(flight.tx[p]);
            volatile signed int flighty = (signed int)WORD1(flight.ty[p]);

            vera_sprite_offset flight_sprite_offset = flight.sprite_offset[p];
            vera_sprite_offset engine_sprite_offset = flight.sprite_offset[n];

            if (flightx > 640 - 32)
                flightx = 640 - 32;
            if (flightx < 0)
                flightx = 0;
            if (flighty > 480 - 32)
                flighty = 480 - 32;
            if (flighty < 0)
                flighty = 0;

#ifdef __COLLISION
            flight.collided[p] = 0;
            collision_insert(flight.cx[p], flight.cy[p], p);
#endif

            unsigned char flight_sprite = flight.sprite[p];
            unsigned char engine_sprite = flight.sprite[n];

            if (!flight.enabled[p]) {
                vera_sprite_zdepth(flight_sprite_offset, sprite_cache.zdepth[flight_sprite]);
                vera_sprite_zdepth(engine_sprite_offset, sprite_cache.zdepth[engine_sprite]);
                flight.enabled[p] = 1;
            }

            if (flight.wait_animation[p]) {
                vera_sprite_set_xy(flight_sprite_offset, flightx, flighty);
            } else {
                vera_sprite_set_xy_and_image_offset(flight_sprite_offset, flightx, flighty, sprite_image_cache_vram(flight_sprite, flight.state_animation[p]));
            }
#ifdef __ENGINE
            if (flight.wait_animation[n]) {
                vera_sprite_set_xy(engine_sprite_offset, flightx + 8, flighty + 22);
            } else {
                vera_sprite_set_xy_and_image_offset(engine_sprite_offset, flightx + 8, flighty + 22,
                                                    sprite_image_cache_vram(engine_sprite, flight.state_animation[n]));
            }
#endif
        }
    }
}

#pragma data_seg(Data)
#pragma data_seg(Code)
#pragma nobank


inline void player_bank() {
    bank_push_set_bram(BANK_ENGINE_FLIGHT);
}

inline void player_unbank() {
    bank_pull_bram();
}

signed char player_impact(unsigned char p) {
	player_bank();
	signed char impact = flight.impact[p];
	player_unbank();
	return impact;
}

// This will need rework
unsigned char player_has_collided(unsigned char p) {
	player_bank();
	unsigned char collided = flight.collided[p];
	player_unbank();
	return collided;
}


// #pragma var_model(mem)
