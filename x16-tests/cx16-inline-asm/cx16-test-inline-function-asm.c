
#pragma var_model(zp)

#include <conio.h>
#include "printf.h"


inline char add(char test, char addition) {

    char result;

    asm {
        lda test
        clc
        adc addition
        sta result
    }

    return result;
}

void main() {

    clrscr();
    gotoxy(0,0);

    char test = 1;
    char result1 = add(test, 2);

    printf("%u", result1);

}
