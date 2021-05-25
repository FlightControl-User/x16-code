#include <conio.h>
#include <printf.h>

#pragma zp_reserve(0x01, 0x02, 0x80..0xFF)

void fun(dword dw2, dword dw3) {

    dword dw1;

    dw1 = dw2 - dw3;
    printf("dw1 = %u\n", dw1);

}

void main() {



    clrscr();
    gotoxy(0,10);
    
    fun(0x14000,0x4000);

    fun(0x34000,0x5000);

}
