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
signed char sy[4] = {1, -1, -1, 1};


void vecx(FP3* fp3, char angle, char speed) {

    angle = angle % 64;
    char i = angle % 32;
    char s = angle / 16;
    unsigned int dx = math_sin[i];
    dx <<= speed;
    signed int sdx = (signed int)((sx[s]==1)?dx:-dx);
    asm {
        ldy #0
        lda sdx
        sta (fp3),y
        iny
        lda sdx+1
        sta (fp3),y
        iny
        lda #0
        bit sdx+1
        bpl !+
        lda #$ff
    !:
        sta (fp3),y
    }
}

void vecy(FP3* fp3, char angle, char speed) {

    angle = angle % 64;
    char i = (angle) % 32;
    char s = angle / 16;
    unsigned int dy = math_cos[i];
    dy <<= speed;
    signed int sdy = (signed int)((sy[s]==1)?dy:-dy);
    asm {
        ldy #0
        lda sdy
        sta (fp3),y
        iny
        lda sdy+1
        sta (fp3),y
        iny
        lda #0
        bit sdy+1
        bpl !+
        lda #$ff
    !:
        sta (fp3),y
    }
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
