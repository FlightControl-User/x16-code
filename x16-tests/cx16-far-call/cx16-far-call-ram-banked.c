
#pragma link("cx16-far-call-ram-banked.ld")
#pragma var_model(zp)

// #define __DEBUG_FILE

#include <cx16.h>
#include <conio.h>
#include <printf.h>
#include <cx16-file.h>
#include <6502.h>
#include <kernal.h>

#pragma var_model(mem)


#pragma code_seg(Bank3)
#pragma data_seg(Bank3)
#pragma bank(ram, 3)

char add(char test, char addition) {

    unsigned int result = 0;
    unsigned int result2 = 0;

    result2 = test + addition;
    result = result2 << 6; 

    return BYTE1(result);
}

#pragma code_seg(Code)
#pragma data_seg(Data)
#pragma nobank(dummy)


void main() {
    clrscr();

    bank_set_brom(0);

    unsigned int bytes = fload_bram("BANK3.BIN", 3, (bram_ptr_t)0xA000);
    printf("bytes read = %u\n", bytes);

    while(!kbhit());

    bank_set_bram(0);

    char base = 1;
    char addition = 2;
    bank_set_bram(0);
    char result = add(base, addition);
    bank_set_bram(0);

    printf("result = %u add %u = %u\n", base, addition, result);

    base = 10;
    addition = 20;
    bank_set_bram(0);
    result = add(base, addition);
    bank_set_bram(0);
    printf("result = %u add %u = %u\n", base, addition, result);

    bank_set_brom(4);
}



