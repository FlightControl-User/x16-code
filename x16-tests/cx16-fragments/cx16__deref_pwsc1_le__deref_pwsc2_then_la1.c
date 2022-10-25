#include <conio.h>
#include <printf.h>

#pragma var_model(mem)

struct A {
    int a;
};

struct B {
    int b;
};

struct A sa;
struct B sb;

void main() {

    clrscr();
    gotoxy(0,30);

    sa.a = -19000;
    sb.b = -19000;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = -19001;
    sb.b = -19000;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = -18999;
    sb.b = -19000;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = -1;
    sb.b = -2;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = -2;
    sb.b = -1;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = -1;
    sb.b = -1;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = 0;
    sb.b = -1;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = 0;
    sb.b = 0;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = -1;
    sb.b = 0;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = -1;
    sb.b = 0;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = 1;
    sb.b = 2;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = 2;
    sb.b = 2;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = 2;
    sb.b = 2;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = 10000;
    sb.b = 20000;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = 20000;
    sb.b = 10000;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = 20000;
    sb.b = 20000;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = -10000;
    sb.b = 20000;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = -20000;
    sb.b = 20000;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }

    sa.a = 20000;
    sb.b = -20000;
    if(sa.a <= sb.b) {
        printf("%i <= than %i\n", sa.a, sb.b);
    } else {
        printf("%i not <= than %i\n", sa.a, sb.b);
    }
}
