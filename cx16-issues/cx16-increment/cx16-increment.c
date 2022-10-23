#include <cx16.h>
#include <conio.h>
#include <printf.h>

typedef struct {
    unsigned int py[8];
} towers_t;

towers_t towers;

void main() {

    clrscr();
    gotoxy(0,10);


    printf("before increment:\n");
    for(char i=0; i<8; i++) {
        towers.py[i] = i;
        printf("tower %u = %u\n", i, towers.py[i]);
    }

    for(char i=0; i<8; i++) {
        signed int volatile py = (signed int)towers.py[i];
        py++;
        towers.py[i] = (unsigned int)py;
    }

    printf("\nafter increment:\n");
    for(char i=0; i<8; i++) {
        printf("tower %u = %u\n", i, towers.py[i]);
    }
}
