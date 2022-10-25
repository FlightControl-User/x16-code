#include <conio.h>
#include <printf.h>

#pragma var_model(mem)


void test( signed char* test) {
    signed char result = *test;
    result = result >> 4;
    printf("result = %i\n", result);
}

void main() {

    clrscr();
    gotoxy(0,30);

    signed char compare = -80;

    signed char result = 0;
    test(&compare);

}
