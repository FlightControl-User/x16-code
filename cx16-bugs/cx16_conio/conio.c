#include <conio.h>
#include <printf.h>

#pragma zp_reserve(0x01, 0x02, 0x80..0xFF)

void main() {
    clrscr();
    gotoxy(10,10);
    printf("hello");
    gotoxy(50,10);
    textcolor(RED);
    printf("world");
}
