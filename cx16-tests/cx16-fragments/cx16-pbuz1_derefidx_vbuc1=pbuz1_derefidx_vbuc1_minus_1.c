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

struct P {
    int dummy;
    char p;
};

struct A sa;
struct B sb;

void fun(struct P* ps) {
    ps->p -= 1;
}

void main() {

    clrscr();
    gotoxy(0,30);

    struct P* ps;

    sa.a = 20;
    sb.b = 33;

    fun((struct P*)&sa);
    printf("sa.a = %u\n", sa.a);
    fun((struct P*)&sa);
    printf("sa.a = %u\n", sa.a);
    fun((struct P*)&sa);
    printf("sa.a = %u\n", sa.a);

    fun((struct P*)&sb);
    printf("sb.b = %u\n", sb.b);
    fun((struct P*)&sb);
    printf("sb.b = %u\n", sb.b);
    fun((struct P*)&sb);
    printf("sb.b = %u\n", sb.b);

}
