#include "../src/equinoxe-animate-types.h"
#include "../src/equinoxe-stage-types.h"
// #include "equinoxe-stage.h"
#include <cx16.h>
// #include "equinoxe-flightengine.h"

#pragma zp_reserve(0x00..0x21, 0x80..0xA8)

sprite_animate_t animate;

void animate_init() {
    memset_fast(animate.count, 0, SPRITE_ANIMATE);
    memset_fast((char *)animate.direction, 0, SPRITE_ANIMATE);
    memset_fast(animate.loop, 0, SPRITE_ANIMATE);
    memset_fast(animate.reverse, 0, SPRITE_ANIMATE);
    memset_fast(animate.speed, 0, SPRITE_ANIMATE);
    memset_fast(animate.state, 0, SPRITE_ANIMATE);
    memset_fast(animate.locked, 0, SPRITE_ANIMATE);
    memset_fast(animate.wait, 0, SPRITE_ANIMATE);
    animate.pool = 0;
    animate.used = 0;
}

unsigned char animate_add(char count, char loop, char speed, signed char direction, char reverse) {

    if (animate.used < SPRITE_ANIMATE) {
        while (animate.locked[animate.pool]) {
            animate.pool = (animate.pool + 1) % SPRITE_ANIMATE;
        }
        char a = animate.pool;
        animate.locked[a] = 1;
        animate.wait[a] = 0;
        animate.speed[a] = speed;
        animate.reverse[a] = reverse;
        animate.loop[a] = loop;
        animate.count[a] = count;
        animate.direction[a] = direction;

        if (direction > 0)
            animate.state[a] = 0;
        else
            animate.state[a] = animate.count[a];

        animate.used++;
    }

    return animate.pool;
}

unsigned char animate_del(unsigned char a) {
    animate.locked[a] = 0;
    animate.used--;
    return animate.used;
}

unsigned char animate_is_waiting(unsigned char a) { return animate.wait[a]; }

unsigned char animate_get_state(unsigned char a) { 
    return animate.state[a]; 
}

void animate_logic(unsigned char a) {
    if (!animate.wait[a]) {
        animate.wait[a] = animate.speed[a];
        animate.state[a] += animate.direction[a];
        if (animate.direction[a]) {
            if (animate.direction[a] > 0) {
                if (animate.state[a] >= animate.count[a]) {
                    if (animate.reverse[a]) {
                        animate.direction[a] = -1;
                    } else {
                        animate.state[a] = animate.loop[a];
                    }
                }
            }

            if (animate.direction[a] < 0) {
                if (animate.state[a] <= animate.loop[a]) {
                    animate.direction[a] = 1;
                }
            }
        }
    }

    if (animate.speed[a])
        animate.wait[a]--;
}
