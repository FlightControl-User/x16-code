
#pragma link("cx16-far-call-ram-banked.ld")
#pragma var_model(zp)

#define __DEBUG_FILE

#include <cx16.h>

#pragma encoding(petscii_mixed)


void main() {
    const bram_ptr_t addr = (bram_ptr_t)0xA000;
    const bram_bank_t bank = 3;

    bank_set_bram(3);
    *addr = 0x60;

    bank_set_brom(0);
    bank_set_bram(0);

    // {asm {.byte $db}}

    kickasm {{
        jsr $FF6E
        .word $A000
        .byte 03
    }};

    bank_set_brom(4);

}



