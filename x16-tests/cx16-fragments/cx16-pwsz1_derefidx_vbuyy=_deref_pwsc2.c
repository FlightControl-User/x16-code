#include <conio.h>
#include <printf.h>

#pragma var_model(mem)

struct A {
    int dummy;
    int a;
   
};

struct B {
    int dummy;
    int b;
};

struct C {
    int dummy;
    int dummy2;
    int c;
};

struct P {
    int dummy;
    int p;
};

struct A sa;
struct B sb;
struct P sp;

struct C sc;

void fun(struct P* ps) {
    ps->p = sc.c;
}

void main() {

    clrscr();
    gotoxy(0,30);

    struct P* ps;

    sa.a = -20;
    sb.b = 30;
    sc.c = 10;
    sp.p = 40;


    fun((struct P*)&sa);
    printf("sa.a = %i\n", sa.a);

    sc.c = 50;
    fun((struct P*)&sb);
    printf("sb.b = %i\n", sb.b);

}
