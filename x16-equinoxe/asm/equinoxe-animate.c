#include "../src/equinoxe-animate-types.h"
#include "../src/equinoxe-stage-types.h"
// #include "equinoxe-stage.h"
#include <cx16.h>
// #include "../src/equinoxe-flightengine.h"

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

/**
 * @brief Add an animation to the animation pool.
 * There can be a maximum of 16 different animation active at the same time.
 * Animations are assigned to each object, so each object has it's own unique state.
 * 
 * @param count Total amount of animation possible states.
 * @param state Start state of the animation.
 * @param loop Start state when the animation loops.
 * @param speed Speed of the animation in frames per second.
 * @param direction Direction of the animation, which can be 1 or -1.
 * @param reverse Check if the animation needs to be reversed when loop is reached.
 * @return unsigned char
 */
unsigned char animate_add(char count, char state, char loop, char speed, signed char direction, char reverse) {

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

        animate.state[a] = state;
        animate.direction[a] = direction;
        animate.image[a] = 0;
        animate.moved[a] = 0;

        animate.used++;
    }

    return animate.pool;
}


/**
 * @brief Delete the animation from the queue.
 */
unsigned char animate_del(unsigned char a) {
    animate.locked[a] = 0;
    animate.used--;
    return animate.used;
}

unsigned char animate_is_waiting(unsigned char a) { return animate.wait[a]; }

/**
 * @brief Enquire the current state of transition of the animation.
 */
unsigned char animate_get_transition(unsigned char a) { 
    return animate.moved[a]; 
}

/**
 * @brief There is a decouplement between the state of the animation and the actual image projected.
 * This is handy when there are multiple transitions and multiple images to reflect those transitions
 * with high level of re-use of images.
 * This function is called when drawing, enquiring the animation state.
 */
unsigned char animate_get_image(unsigned char a) { 
    return animate.image[a]; 
}

/**
 * @brief Main animation logic, for looping and reversing animations:
 * - Start loop from a start position.
 * - Loop when a loop position is reached.
 * - Two possible directions of looping.
 * - Possibly change direction and reverse.
 */
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

    animate.image[a] = animate.state[a];
}

/**
 * @brief Animation of the player object.
 * It performs 3 different transitions:
 * - Stable state alternating between rotor positions.
 * - Fly left or right, turning wings.
 * - Rotate for eye candy, left or right.
 * 
 * Needs a current x and a previous x coordinate to decide on the animation action.
 * Both coordinates are signed.
 */
void animate_player(unsigned char a, signed int x, signed int px) {

    if (!animate.wait[a]) {

        animate.wait[a] = animate.speed[a];

        if (x < px) {
            if (animate.state[a] > 0) {
                animate.state[a] -= 1;
            }
            animate.moved[a] = 2;
        }
        if (x > px) {
            if(animate.state[a] < 6) {
                animate.state[a] += 1;
            }
            animate.moved[a] = 2;
        }

        if (animate.moved[a] == 1) {
            if (animate.state[a] < animate.loop[a]) {
                animate.state[a] += 1;
            }
            if (animate.state[a] > animate.loop[a]) {
                animate.state[a] -= 1;
            }
            if (animate.state[a] == animate.loop[a]) {
                animate.moved[a] = 0;
            }
        }

        if (animate.moved[a] == 2) {
            animate.moved[a]--;
        }

        if(animate.moved[a] == 0) {
            if(animate.image[a] == 16) {
                animate.image[a] = animate.state[a]-animate.loop[a];
            } else {
                animate.image[a] = 16;
            }
        } else {
            if(animate.moved[a] == 1) {
                animate.image[a] = ((char)13 + animate.state[a]) % (char)16;
            }
        }

    }

    animate.wait[a]--;
}

void animate_tower(unsigned char a) {

    switch(animate.moved[a]) {
        case 0:
            unsigned char rnd = rand();
            if(rnd <= 5) animate.moved[a] = 1;
            break;
        case 1:
            animate.wait[a] = 0;
            animate.moved[a] = 2;
            break;
        case 2:
            if(!animate.wait[a]) {
                animate.wait[a] = animate.speed[a];
                if(animate.state[a] == animate.count[a]) {
                    animate.wait[a] = 120;
                    animate.moved[a] = 3;
                } else {
                    animate.state[a] += 1;
                }
            } else {
                animate.wait[a]--;
            }
            break;
        case 3:
            // Shoot
            if(!animate.wait[a]) {
                animate.wait[a] = 0;
                animate.moved[a] = 4;
            } else {
                animate.wait[a]--;
            }
            break;   
        case 4:
            // Shot fired
            animate.moved[a] = 5;
            animate.wait[a] = 0;
            break;   
        case 5:
            if(!animate.wait[a]) {
                animate.wait[a] = animate.speed[a];
                if(animate.state[a] <= animate.loop[a]) {
                    animate.moved[a] = 0;
                } else {
                    animate.state[a] -= 1;
                }
            }
            animate.wait[a]--;
            break;
        default:
    }
    animate.image[a] = animate.state[a];
}
