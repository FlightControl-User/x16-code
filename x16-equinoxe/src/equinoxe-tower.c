#include "equinoxe.h"

#pragma data_seg(DATA_ENGINE_TOWERS)

#ifdef __BANKING
#pragma code_seg(CODE_ENGINE_TOWERS)
#pragma data_seg(DATA_ENGINE_TOWERS)
#pragma bank(cx16_ram, BANK_ENGINE_TOWERS)
#endif

flight_index_t tower_add(sprite_index_t sprite_tower, unsigned int xi, unsigned int yi, unsigned char xs, unsigned char ys) {

    flight_index_t t = flight_add(FLIGHT_TOWER, SIDE_ENEMY, sprite_tower);

    flight.health[t] = 100;
    flight.impact[t] = 100;

    flight.xi[t] = xi;
    flight.yi[t] = yi;
    flight.xs[t] = xs;
    flight.xs[t] = ys;
    // flight.x[t] = x;
    // flight.y[t] = y;

    flight.animate[t] = animate_add(11, 0, 0, 4, 1, 0);
    animate_tower(flight.animate[t]);

    return t;
}

void tower_remove(flight_index_t t) {
    if (flight.used[t]) {
        animate_del(flight.animate[t]);
        flight_remove(FLIGHT_TOWER, t);
    }
}

void tower_paint(unsigned char column, unsigned char row) {

#ifdef __FLOOR
    if (column < 8) {
        unsigned char cache_floor = FLOOR_CACHE(row, column);
        unsigned char floor_slab = floor_cache[cache_floor];
        floor_cache[cache_tower] = 0;
        if (floor_slab == 15) {
            unsigned char rnd = BYTE0(rand());
            if( rnd <= game.tower_frequency ) {
                floor_cache[cache_tower] = 1;
                stage_tower_add(column, row);
            }
        }
    }
#endif
}


void tower_move() {
    flight_index_t t = flight_root(FLIGHT_TOWER);
    while (t) {
        flight_index_t tn = flight_next(t);
        // todo i need to review this statement as it compiles wrongly like this:
        // signed int py = (signed int)((unsigned int)flight.y[t] * 64) - (signed int)game.screen_vscroll; // the screen_vscroll contains the current scroll
        // position.
        flight.yi[t]++;
        t = tn;
    }
}

void tower_logic() {
    flight_index_t t = flight_root(FLIGHT_TOWER);

    while (t) {
        flight_index_t tn = flight_next(t);

        unsigned int y = flight.yi[t];
        unsigned int x = flight.xi[t];
        if (y < 480 || y >= 1024-64) {
            // printf("tower logic: t=%u, towers gx=%04u, gy=%04u\n", t, gx, gy);
            collision_insert(t);
            unsigned char a = flight.animate[t];
            unsigned char transition = animate_get_transition(a);
            if (transition == 3) {
#ifdef __BULLET
                if (y < 480 - 64) {
                    unsigned int rnd = rand();
                    if (rnd < 32) {
                        unsigned int xs = flight.xi[t]+flight.xs[t];
                        unsigned int ys = flight.yi[t]+flight.ys[t];
                        unsigned int xt = flight.xi[t]+flight.xs[t]-1;
                        unsigned int yt = 480;
                        stage_bullet_add(xs, ys, xt, yt, 4, SIDE_ENEMY, b003);
                    }
                }
#endif
            }
            animate_tower(a);
        } else {
            stage_tower_remove(t);
        }
        t = tn;
    }
}

#pragma data_seg(Data)
#pragma code_seg(Code)
#pragma nobank

