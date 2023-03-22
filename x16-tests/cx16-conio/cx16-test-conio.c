#include <conio.h>
#include <printf.h>
#include <cx16-veralib.h>


#pragma encoding(petscii_mixed)

void main() {

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    printf("printing\n %s\n", "colors");

    for(unsigned char f=0; f<16; f++) {
        for(unsigned char b=0; b<16; b++) {
            textcolor(f);
            bgcolor(b);
            gotoxy(f*4,b*2+4);
            printf("***");
        }
    }

    textcolor(WHITE);
    bgcolor(BLACK);
    gotoxy(0,4);
    printf("4");
    while(!kbhit());

    for(char i=0;i<10;i++) {
        insertdown(1);
        while(!kbhit());
    }

    textcolor(WHITE);
    bgcolor(BLACK);
    gotoxy(0,20);
    printf("20");
    while(!kbhit());

    for(char i=0;i<10;i++) {
        insertup(1);
        while(!kbhit());
    }

}
