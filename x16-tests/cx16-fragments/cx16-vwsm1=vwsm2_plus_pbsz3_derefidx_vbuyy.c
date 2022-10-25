#include <conio.h>
#include <printf.h>

#pragma var_model(mem)

struct A {
    int dummy;
    int x;
    int y;
    signed char dx;
    signed char dy;
   
};

struct B {
    int dummy2;
    int b;
    signed char x;
   
};

struct P {
    int dummy;
    int x;
    int y;
    signed char dx;
    signed char dy;
};

struct Q {
    int dummy;
    int x;
    int y;
    signed char dx;
    signed char dy;
};

struct F {
    int dummy;
    int f;
};

struct A sa;
struct B sb;
struct P sp;
struct Q sq;
struct F sf;

void* fun(void* pf) {
    return pf;
}

void calc(struct P* pp) {
    // asm { .byte $db }
    signed int x = pp->x;
    x += pp->dx;
    pp->x = x;
}


void main() {

    clrscr();
    gotoxy(0,30);

    volatile struct P* ps = (struct P*)&sa;
    volatile struct Q* qs = (struct Q*)&sb;

    ps->x = -300;
    ps->y = 8;

    ps->dx = 16;

    ps = (struct P*)fun((void*)ps);
    qs = (struct Q*)fun((void*)&sb);

    for( int n=0; n<30;n++) {
    calc(ps);


    printf("ps->x = %i\n", ps->x);
    }

}
