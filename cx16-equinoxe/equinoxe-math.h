#include <fp3.h>

signed int math_sin[64] = kickasm {{
.fillword 64, 128*sin(toRadians(i*360/64))
}};

signed int math_cos[64] = kickasm {{
.fillword 64, 128*cos(toRadians(i*360/64))
}};


FP vecx(unsigned char angle, char speed);
FP vecy(unsigned char angle, char speed);

// FP3 vecx(char angle, char speed);
// FP3 vecy(char angle, char speed);
// 
unsigned char abs_u8(unsigned char b);
unsigned int abs_u16(unsigned int w);
unsigned char sgn_u8(unsigned char b);
unsigned int sgn_u16(unsigned int w);
