#include <printf.h>

void main() {
    textcolor(BLUE);
    backcolor(WHITE);
    clrscr();

    gotoxy(0, 5);
    for(int i=0;i<5;i++)
        printf("line %02d ......................................................................\n",i);

    gotoxy(0, 15);
    textcolor(RED);
    unsigned int width = screensizex();
    unsigned int height = screensizey();
    printf("width = %u; height = %u\n", width, height);

    textcolor(BLUE);
    gotoxy(0,20);
    for(int i=5;i<10;i++)
        printf("line %02d ......................................................................\n",i);
    for(int i=0;i<5;i++) {
        gotoxy(0,21);
        insertdown();
    }
    for(int i=0;i<5;i++) {
        gotoxy(0,19);
        insertdown();
    }
    for(int i=0;i<3;i++) {
        gotoxy(0,10);
        insertup();
    }

    gotoxy(0,56);
    for(int i=10;i<100;i++)
        printf("line %02d ......................................................................\n",i);
}
