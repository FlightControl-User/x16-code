#include <conio.h>
#include <printf.h>

#pragma zp_reserve(0x01, 0x02, 0x80..0xFF)
void test() {
    printf("Hello\n");
}

typedef int dummy;

dummy test2;

void main() {
    clrscr();
    gotoxy(0,1);

    void() *fn;

    fn = &test;

    (*fn)();

}
