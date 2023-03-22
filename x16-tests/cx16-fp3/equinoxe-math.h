#include <fp3.h>

const unsigned int math_sin[32] = {0,	25,	49,	74,	97,	120,	142,	162,	181,	197,	212,	225,	236,	244,	251,	254,	256,	254,	251,	244,	236,	225,	212,	197,	181,	162,	142,	120,	97,	74,	49,	25};
const unsigned int math_cos[32] = {256,	254,	251,	244,	236,	225,	212,	197,	181,	162,	142,	120,	97,	74,	49,	25,	0,	25,	49,	74,	97,	120,	142,	162,	181,	197,	212,	225,	236,	244,	251,	254};

void vecx(FP* fp3, char angle, char speed);
void vecy(FP* fp3, char angle, char speed);

// FP3 vecx(char angle, char speed);
// FP3 vecy(char angle, char speed);
// 
unsigned char abs_u8(unsigned char b);
unsigned int abs_u16(unsigned int w);
unsigned char sgn_u8(unsigned char b);
unsigned int sgn_u16(unsigned int w);
