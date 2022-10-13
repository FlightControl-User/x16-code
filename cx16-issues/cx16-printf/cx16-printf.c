#include <cx16.h>
#include <conio.h>
#include <printf.h>


void main() {

    unsigned int s = 23;

    clrscr();
    gotoxy(0,10);

    printf("%x", s);
    
}
