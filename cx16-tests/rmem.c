#include <conio.h>
#include <printf.h>
#include <multiply.h>


#pragma var_model(mem)

typedef struct {
    char bank;
    char* ptr;
} TEST;



void main() {

    clrscr();
    gotoxy(0,30);

    TEST mem1;
    TEST mem2;

    mem1.bank = 1;
    mem1.ptr = (char*)0xA000;

    mem2.bank = 2;
    mem2.ptr = (char*)0xB000;

    printf("mem1 = %u, %p\n", mem1.bank, mem1.ptr);
    printf("mem2 = %u, %p\n", mem2.bank, mem2.ptr);

    mem2 = mem1;

    printf("mem1 = %u, %p\n", mem1.bank, mem1.ptr);
    printf("mem2 = %u, %p\n", mem2.bank, mem2.ptr);
    

}
