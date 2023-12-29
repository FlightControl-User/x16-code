#include "equinoxe.h"

#ifdef __BANKING
#pragma code_seg(CODE_ENGINE_PLAYERS)
#pragma data_seg(DATA_ENGINE_PLAYERS)
#pragma bank(cx16_ram,BANK_ENGINE_PLAYERS)
#endif

void player_init() {
}

void player_add(sprite_index_t sprite_player, sprite_index_t sprite_engine) {

    unsigned char p = flight_add(FLIGHT_PLAYER, SIDE_PLAYER, sprite_player);

    flight.moved[p] = 2;
    flight.firegun[p] = 0;
    flight.reload[p] = 0;

    flight.health[p] = 100;
    flight.impact[p] = -100;


    flight.animate[p] = animate_add(6,3,3,10,1,0);

    flight.xf[p] = 0;
    flight.yf[p] = 0;
    flight.xi[p] = 320;
    flight.yi[p] = 200;
    flight.xd[p] = 0;
    flight.yd[p] = 0;

    unsigned char n = flight_add(FLIGHT_ENGINE, SIDE_PLAYER, sprite_engine);

    flight.engine[p] = n;

    flight.animate[n] = animate_add(16,0,0,2,1,0);

    stage.player = p;

}

void player_remove(unsigned char p) {

    if (flight.used[p]) {
        unsigned char n = flight.engine[p];
        animate_del(flight.animate[n]); // Remove the animation of the engine sprite.
        flight_remove(FLIGHT_ENGINE, n);
        animate_del(flight.animate[p]); // Remove the animation of the player sprite.
        flight_remove(FLIGHT_PLAYER, p);
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

    flight_index_t p = flight_root(FLIGHT_PLAYER);
    while(p) {

        flight_index_t pn = flight_next(p);

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
                stage_bullet_add(x, y, x, 0, 5, SIDE_PLAYER, b001);
            }
#endif


            flight.xi[p] = (unsigned int)cx16_mouse.x;
            flight.yi[p] = (unsigned int)cx16_mouse.y;

            flight_index_t n = flight.engine[p];
            flight.xi[n] = flight.xi[p]+8;
            flight.yi[n] = flight.yi[p]+32;

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

            unsigned char ap = flight.animate[p]; 
            animate_player(ap, (signed int)cx16_mouse.x, (signed int)cx16_mouse.px);
            unsigned char an = flight.animate[n]; 
            animate_logic(an);

#ifdef __COLLISION
            collision_insert(p);
#endif

        }
        p = pn;
    }
}

#pragma data_seg(Data)
#pragma code_seg(Code)
#pragma nobank()


inline void player_bank() {
    bank_push_set_bram(BANK_ENGINE_FLIGHT);
}

inline void player_unbank() {
    bank_pull_bram();
}


// #pragma var_model(mem)
