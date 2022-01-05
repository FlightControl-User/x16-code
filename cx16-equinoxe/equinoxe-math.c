#include "equinoxe-math.h"

/**
 * @brief Calculates the x vector from an angle and speed.
 * 
 * In equinoxe world, an angle is not 360 steps but 64 steps to complete a round circle!
 * Each quadrant is subdivided in 16 steps.
 * The vectors are calculated from a common sin/cos table.
 * The 0° vector is on the x axis and the 90° vector is on the y axis.
 * Rotation is done counter clockwise.
 * This brings us to the following table:
 * >=	<	dx	dy
 * 0	16	1	1
 * 16	32	-1	1
 * 32	48	1	-1
 * 48	64	-1	-1
 * 
 * The speed dx and dy are calculated taking into account the required speed.
 * @param angle 
 * @param speed 
 * @return signed char 
 */

signed char sx[4] = {1, 1, -1, -1};
signed char sy[4] = {-1, -1, 1, 1};


signed char vecx(char angle, char speed) {
    angle = angle % 64;
    char i = angle % 32;
    char s = angle / 16;
    unsigned char dx = math_sin[i];
    dx >>= (4-speed);
    signed char sdx = (signed char)((sx[s]==1)?dx:-dx);
    return sdx;
}

signed char vecy(char angle, char speed) {
    angle = angle % 64;
    char i = angle % 32;
    char s = angle / 16;
    unsigned char dy = math_cos[i];
    dy >>= (4-speed);
    signed char sdy = (signed char)((sy[s]==1)?dy:-dy);
    return sdy;
}