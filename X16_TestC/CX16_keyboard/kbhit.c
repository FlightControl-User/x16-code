#include <printf.h>

void main() {
    textcolor(BLUE);
    backcolor(WHITE);
    clrscr();

    char keys = 0;
    char* keysptr = &keys;


    while(!keys) {
        kickasm(uses keysptr) {{

         jsr ps2_init
         jmp continue1
         .var via2	=$9f70                  //VIA 6522 #2
         .var d2prb	=via2+0
         .var d2pra	=via2+1
         .var d2ddrb	=via2+2
         .var d2ddra	=via2+3

         .var port_ddr  =d2ddrb
         .var port_data =d2prb
         .var bit_data=1              // 6522 IO port data bit mask  (PA0/PB0)
         .var bit_clk =2              // 6522 IO port clock bit mask (PA1/PB1)

         // inhibit PS/2 communication on both ports
         ps2_init:
             ldx #1 // PA: keyboard
             jsr ps2dis
             dex    // PB: mouse
         ps2dis:	lda port_ddr,x
             ora #bit_clk+bit_data
             sta port_ddr,x // set CLK and DATA as output
             lda port_data,x
             and #$ff - bit_clk // CLK=0
             ora #bit_data // DATA=1
             sta port_data,x
             rts
         continue1: nop
         }}

       kickasm(uses keysptr) {{
            jsr ps2_receive_byte
            jmp continue2
            //****************************************
            // RECEIVE BYTE
            // out: A: byte (0 = none)
            //      Z: byte available
            //           0: yes
            //           1: no
            //      C:   0: parity OK
            //           1: parity error
            //****************************************
         ps2_receive_byte:
         // set input, bus idle
            lda port_ddr,x // set CLK and DATA as input
            and #$ff-bit_clk-bit_data
            sta port_ddr,x // -> bus is idle, keyboard can start sending

            lda #bit_clk+bit_data
            //ldy #10 * mhz
            ldy #10 * 8
        // :	dey
         loop:	dey
            beq lc08c
            bit port_data,x
        // 	bne :- // wait for CLK=0 and DATA=0 (start bit)
            bne loop // wait for CLK=0 and DATA=0 (start bit)

            lda #bit_clk
         lc044:	bit port_data,x // wait for CLK=1 (not ready)
            beq lc044
            ldy #9 // 9 bits including parity
         lc04a:	bit port_data,x
            bne lc04a // wait for CLK=0 (ready)
            lda port_data,x
            and #bit_data
            cmp #bit_data
            ror keysptr // save bit
            lda #bit_clk
         lc058:	bit port_data,x
            beq lc058 // wait for CLK=1 (not ready)
            dey
            bne lc04a
            rol keysptr // get parity bit into C
         lc061:	bit port_data,x
            bne lc061 // wait for CLK=0 (ready)
         lc065:	bit port_data,x
            beq lc065 // wait for CLK=1 (not ready)
         lc069:	jsr ps2dis
            lda keysptr
            php // save parity
         //lc07c:	lsr a // calculate parity
         lc07c:	lsr // calculate parity
            bcc lc080
            iny
         lc080:	cmp #0
            bne lc07c
            tya
            plp // transmitted parity
            adc #1
        // 	lsr a // C=0: parity OK
            lsr // C=0: parity OK
            lda keysptr
            ldy #1 // Z=0
            rts

         lc08c:	jsr ps2dis
            clc
            lda #0 // Z=1
            rts
            continue2: nop
          }}
        printf( "keys = %x\n", keys );
    }


}