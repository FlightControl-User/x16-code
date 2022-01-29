#include <conio.h>
#include <printf.h>

#pragma var_model(mem)

typedef struct A {
    int y;
    int x;
    int z;
} Enemy;

void main() {

    clrscr();
    gotoxy(0,30);

    Enemy enemy;
    enemy.x = 0;

    Enemy* pe = &enemy;

    signed int compare = 0;

    if( pe->x <= 0 ) {
        printf("%i <= than %i\n", pe->x, compare);
    } else {
        printf("%i not <= than %i\n", pe->x, compare);
    }
}
