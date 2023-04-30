#include <cx16-mouse.h>

#include "equinoxe.h"
//#include "equinoxe-bullet.h"
#include "equinoxe-collision.h"
//#include "equinoxe-defines.h"
//#include "equinoxe-flightengine-types.h"
//#include "equinoxe-flightengine.h"
//#include "equinoxe-player.h"
#include "equinoxe-stage.h"
#include "equinoxe-types.h"
//#include "equinoxe.h"
#include "equinoxe-animate-lib.h"
#include "equinoxe-levels.h"


#pragma data_seg(DATA_ENGINE_PLAYERS)

#pragma data_seg(CODE_ENGINE_PLAYERS)

#pragma code_seg(Code)

void player_init() {
}

void player_add(sprite_index_t sprite_player, sprite_index_t sprite_engine) {

    unsigned char p = flight_add(FLIGHT_PLAYER, SIDE_PLAYER, sprite_player);

    stage.player_count++;

    flight.moved[p] = 2;
    flight.firegun[p] = 0;
    flight.reload[p] = 0;

    flight.health[p] = 100;
    flight.impact[p] = -100;


    flight.animate[p] = animate_add(6,3,3,8,1,0);

    flight.xf[p] = 0;
    flight.yf[p] = 0;
    flight.xi[p] = 320;
    flight.yi[p] = 200;
    flight.xd[p] = 0;
    flight.yd[p] = 0;

    unsigned char n = flight_add(FLIGHT_ENGINE, SIDE_PLAYER, sprite_engine);

    flight.engine[p] = n;

    flight.animate[n] = animate_add(4,0,0,2,1,0);

    stage.player = p;

}

void player_remove(unsigned char p) {

    if (flight.used[p]) {
        unsigned char n = flight.engine[p];
        animate_del(flight.animate[n]); // Remove the animation of the engine sprite.
        flight_remove(n);
        animate_del(flight.animate[p]); // Remove the animation of the player sprite.
        flight_remove(p);
        stage.player_count--;
        stage.player_respawn = 8;       // Wait 8 tickes until stage respawns the sprite. This needs rework. TODO.
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

#ifdef debug_scanlines
        vera_display_set_border_color(6);
#endif

    for (flight_index_t p=0; p<FLIGHT_OBJECTS; p++) {

        if (flight.type[p] == FLIGHT_PLAYER && flight.used[p]) {

            if (flight.reload[p] > 0) {
                flight.reload[p]--;
            }


#ifdef __BULLET
            if (cx16_mouse.status == 1 && flight.reload[p] <= 0) {
                unsigned int x = flight.xi[p];
                unsigned int y = flight.yi[p];
                if (flight.firegun[p]) {
                    x += (signed char)16;
                }
                flight.firegun[p] = flight.firegun[p] ^ 1;
                flight.reload[p] = 8;
                bullet_add(x, y, x, 0, 5, SIDE_PLAYER, b001);
            }
#endif


            flight.xi[p] = cx16_mouse.x;
            flight.yi[p] = cx16_mouse.y;

            flight_index_t n = flight.engine[p];
            flight.xi[n] = flight.xi[p]+8;
            flight.yi[n] = flight.yi[p]+22;

            unsigned int x = flight.xi[p];
            unsigned int y = flight.yi[p];

            vera_sprite_offset flight_sprite_offset = flight.sprite_offset[p];
            vera_sprite_offset engine_sprite_offset = flight.sprite_offset[flight.engine[p]];

            if (x > 640 - 32) {
                x = 640 - 32;
            }

            if (y > 480 - 32) {
                y = 480 - 32;
            }

            animate_player(flight.animate[p], (signed int)cx16_mouse.x, (signed int)cx16_mouse.px);
            animate_logic(flight.animate[n]);

#ifdef __COLLISION
            collision_insert(p);
#endif

//             unsigned char flight_sprite = flight.sprite[p];
//             unsigned char engine_sprite = flight.sprite[flight.engine[p]];

//             if (!flight.enabled[p]) {
//                 vera_sprite_zdepth(flight_sprite_offset, sprite_cache.zdepth[flight_sprite]);
//                 vera_sprite_zdepth(engine_sprite_offset, sprite_cache.zdepth[engine_sprite]);
//                 flight.enabled[p] = 1;
//             }

//             if (animate_is_waiting(flight.animate[p])) {
//                 vera_sprite_set_xy(flight_sprite_offset, flightx, flighty);
//             } else {
//                 vera_sprite_set_xy_and_image_offset(flight_sprite_offset, flightx, flighty, 
//                     sprite_image_cache_vram(flight_sprite, animate_get_state(flight.animate[p])));
//             }
// #ifdef __ENGINE
//             if (animate_is_waiting(flight.animate[p])) {
//                 vera_sprite_set_xy(engine_sprite_offset, flightx + 8, flighty + 22);
//             } else {
//                 vera_sprite_set_xy_and_image_offset(engine_sprite_offset, flightx + 8, flighty + 22,
//                     sprite_image_cache_vram(engine_sprite, animate_get_state(flight.animate[flight.engine[p]])));
//             }
// #endif
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
