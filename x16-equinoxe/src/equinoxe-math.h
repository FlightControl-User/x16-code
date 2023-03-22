#include <fp3.h>

// #pragma data_seg(Math)

signed int math_sin[64] = kickasm {{
	.fillword 64, 128*sin(toRadians(i*360/64))
}};

signed int math_cos[64] = kickasm {{
	.fillword 64, 128*cos(toRadians(i*360/64))
}};

__align(0x0100) unsigned char logtab[] = kickasm {{
	.fill $100, (log(i)/log(2))*32
}};

__align(0x0100) unsigned char atantab[] = kickasm {{
	.for(var i=-256;i<0;i++) {
    .byte (atan(pow(2.0,(i/32.0)))*64/(PI*2))
	}
//    .fill $100, i
}};

__align(0x100)  unsigned char adjust_octant[] = kickasm {{	
	.byte %00001111		// x+,y+,|x|>|y|
	.byte %00000000		// x+,y+,|x|<|y|
	.byte %00110000		// x+,y-,|x|>|y|
	.byte %00111111		// x+,y-,|x|<|y|
	.byte %00010000		// x-,y+,|x|>|y|
	.byte %00011111		// x-,y+,|x|<|y|
	.byte %00101111		// x-,y-,|x|>|y|
	.byte %00100000		// x-,y-,|x|<|y|
}};



FP math_vecx(unsigned char angle, char speed);
FP math_vecy(unsigned char angle, char speed);
unsigned char math_atan2(unsigned char x1, unsigned char x2, unsigned char y1, unsigned char y2);

// FP3 vecx(char angle, char speed);
// FP3 vecy(char angle, char speed);
// 
unsigned char abs_u8(unsigned char b);
unsigned int abs_u16(unsigned int w);
unsigned char sgn_u8(unsigned char b);
unsigned int sgn_u16(unsigned int w);

#pragma data_seg(Data)
