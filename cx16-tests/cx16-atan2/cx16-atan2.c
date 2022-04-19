#include <conio.h>
#include <printf.h>
#include <cx16-mouse.h>


//#pragma encoding(petscii_mixed)

__align(0x0100) unsigned char logtab[] = kickasm {{
.fill $100, (log(i)/log(2))*32
}};

__align(0x0100) unsigned char atantab[] = kickasm {{
	.for(var i=-256;i<0;i++) {
    .byte (atan(pow(2.0,(i/32.0)))*64/(PI*2))
	}
//    .fill $100, i
}};


unsigned char atan2(unsigned char x1, unsigned char x2, unsigned char y1, unsigned char y2)
{
    __address($FB) unsigned char octant = 0;

    unsigned char angle = 0;

    asm {

        lda y2
		sbc y1
		bcs !+
		eor #$ff
    !:
		tax
		rol octant

		lda x1
		sbc x2
		bcs !+
		eor #$ff
    !:
		tay
		rol octant

		lda logtab,x
		sbc logtab,y
		bcc !+
		eor #$ff
    !:
		tax

		lda octant
		rol
		and #%111
		tay

		lda atantab,x
		eor octant_adjust,y
        sta angle
		jmp !+

	octant_adjust:	
		.byte %00001111		// x+,y+,|x|>|y|
		.byte %00000000		// x+,y+,|x|<|y|
		.byte %00110000		// x+,y-,|x|>|y|
		.byte %00111111		// x+,y-,|x|<|y|
		.byte %00010000		// x-,y+,|x|>|y|
		.byte %00011111		// x-,y+,|x|<|y|
		.byte %00101111		// x-,y-,|x|>|y|
		.byte %00100000		// x-,y-,|x|<|y|

	!: 	nop
	 
    }

    return angle;


}

void angle(unsigned char x1, unsigned char x2, unsigned char y1, unsigned char y2)
{
	unsigned char a = atan2(x1,x2,y1,y2);
    printf("x1 = %03u, x2 = %03u, y1 = %03u, y2 = %03u, a = %03u\n", x1, x2, y1, y2, a);
}

void main() {

    clrscr();
    printf("atan2 test\n");

    // for(unsigned int i=0; i<=255; i++) {
    //     if(!(i % 16)) printf("\n");
    //     printf("%02x  ", atantab[i]);
    // }

    cx16_mouse_config(0x01, 80, 60);

	while(!getin()) {

		char cx16_mouse_status = cx16_mouse_get();
		gotoxy(10,10);
		angle(BYTE0(((640-1)/2) >> 2), BYTE0(cx16_mousex>>2), BYTE0(((480-1)/2)>>2), BYTE0(cx16_mousey>>2));
	}

}
