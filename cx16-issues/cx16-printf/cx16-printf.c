#include <conio.h>
#include <printf.h>

#pragma zp_reserve(0x01, 0x02, 0x80..0xFF)


void main() {

    unsigned int s = 23;

    clrscr();
    gotoxy(0,10);

    printf("%x", s);
    
}
