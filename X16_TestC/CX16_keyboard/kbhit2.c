#include <printf.h>

void main() {
    textcolor(BLUE);
    backcolor(WHITE);
    clrscr();

    char ps2byte = 0;
    char* keylog = &ps2byte;



    while(!ps2byte) {
        kickasm(uses keylog) {{

            jsr _kbhit
            jmp continue1
            .var via1 = $9f60                  //VIA 6522 #1
            .var d1pra = via1+1

        _kbhit:
            ldy     d1pra       // (KEY_COUNT is in RAM bank 0)
            stz     d1pra
            lda     $A00A       // Get number of characters
            sta     keylog
            sty     d1pra
            tax                     // High byte of return (only its zero/nonzero ...
            rts                     // ... state matters)
        continue1: nop
         }}

        printf( "ps2byte = %x\n", ps2byte );
    }


}