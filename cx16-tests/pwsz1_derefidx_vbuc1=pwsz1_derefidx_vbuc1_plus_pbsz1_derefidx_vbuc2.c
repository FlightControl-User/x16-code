#include <conio.h>
#include <printf.h>

#pragma var_model(mem)

struct A {
    int dummy1;
    signed int x;
    signed char dx;

};

struct P {
    int dummy1;
    signed int x;
    signed char dx;
};

struct A sa;

void fun(struct P* ps) {
    ps->x -= ps->dx;
}

void main() {

    clrscr();
    gotoxy(0,30);

    sa.x = 200;
    sa.dx = -8;

    void* P;

    P = (void*)&sa;
 
    ((struct P*)P)->x += ((struct P*)P)->dx;
    printf("%i\n", sa.x);

}
