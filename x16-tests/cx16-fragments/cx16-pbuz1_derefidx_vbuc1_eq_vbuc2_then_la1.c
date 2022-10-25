#include <conio.h>
#include <printf.h>

#pragma var_model(mem)

struct A {
    int dummy;
    char a;
   
};

struct B {
    int dummy;
    char b;
};

struct C {
    int dummy;
    int dummy2;
    char c;
};

struct P {
    int dummy;
    char p;
    int dummy3;
};

struct A sa;
struct B sb;
struct P sp;

struct C sc;

void fun(struct P* ps) {
    if(ps->p == 1) {
        printf("equal");
    }
}

void main() {

    clrscr();
    gotoxy(0,30);

    struct P* ps;

    sa.a = 1;
    sb.b = 30;
    sc.c = 10;
    sp.p = 40;


    fun((struct P*)&sa);

}
