// #pragma data_seg(Math)

#include "equinoxe-math.h"

/**
 * @brief Calculates the x vector from an angle and speed.
 * 
 * In equinoxe world, an angle is not 360 degrees but 64 degrees to complete a round circle!
 * Each quadrant is subdivided in 16 degrees.
 * The x/y vectors are calculated from a common cos/sin table.
 * The 0° vector is on the x axis and the 16° vector is on the y axis.
 * Rotation is done clockwise.
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


inline FP vecx(unsigned char angle, char speed) {

    //TODO: check with jesper this code section, could be a bug in the optimizer.
    signed int dx = math_cos[angle%64];
    if(speed) dx <<= speed;

    // signed char dx2 = (signed char)BYTE0(dx);
    // signed char dx3 = (signed char)BYTE1(dx);
    // signed char dx4 = (signed char)0;
    // if(dx3<0) dx4=-1;
    // return (FP)MAKELONG4((char)dx4, (char)dx3, (char)dx2, 0);
    return (FP)dx<<8;
}

inline FP vecy(unsigned char angle, char speed) {

    signed int dy = math_sin[angle%64];
    if(speed) dy <<= speed;

    // signed char dy2 = (signed char)BYTE0(dy);
    // signed char dy3 = (signed char)BYTE1(dy);
    // signed char dy4 = (signed char)0;
    // if(dy3<0) dy4=-1;
    // return (FP)MAKELONG4((char)dy4, (char)dy3, (char)dy2, 0);
    return (FP)dy<<8;
}

// Get the absolute value of an 8-bit unsigned number treated as a signed number.
unsigned char abs_u8(unsigned char b) {
    if(b&0x80) {
        return -b;
    } else {
        return b;
    }
}

// Get the absolute value of a 16-bit unsigned number treated as a signed number.
unsigned int abs_u16(unsigned int w) {
    if(BYTE1(w)&0x80) {
        return -w;
    } else {
        return w;
    }
}

// Get the sign of a 8-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is <0.
unsigned char sgn_u8(unsigned char b) {
    if(b&0x80) {
        return -1;
    } else {
        return 1;
    }
}

// Get the sign of a 16-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is <0.
unsigned int sgn_u16(unsigned int w) {
    if(BYTE1(w)&0x80) {
        return -1;
    } else {
        return 1;
    }
}

#pragma data_seg(Data)
