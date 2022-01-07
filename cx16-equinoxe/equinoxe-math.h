const char math_sin[32] = {0,	12,	24,	37,	48,	60,	71,	81,	90,	98,	106,	112,	118,	122,	125,	127,	128,	127,	125,	122,	118,	112,	106,	98,	90,	81,	71,	60,	48,	37,	24,	12};
const char math_cos[32] = {128,	127,	125,	122,	118,	112,	106,	98,	90,	81,	71,	60,	48,	37,	24,	12,	0,	12,	24,	37,	48,	60,	71,	81,	90,	98,	106,	112,	118,	122,	125,	127};

signed char vecx(char angle, char speed);
signed char vecy(char angle, char speed);

unsigned char abs_u8(unsigned char b);
unsigned int abs_u16(unsigned int w);
unsigned char sgn_u8(unsigned char b);
unsigned int sgn_u16(unsigned int w);
