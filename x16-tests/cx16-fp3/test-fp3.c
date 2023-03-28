
#pragma var_model(zp)

#include <conio.h>
#include <printf.h>
//#include <division.h>
//#include <multiply.h>

#include <fp3.h> // Fixed point 3-byte structures and functions.

#define NUMBERS 10

FP3 numbers[NUMBERS];

// void print_numbers(FP3* numbers) {

//     for(char n=0; n<NUMBERS; n++) {
//         printf(" %05u.%-3u", MAKEWORD(*(numbers[n]+1), *(numbers[n]+2)), *(numbers[n]));
//     }
//     cputc('\n');
// }

void main() {

    clrscr();
    gotoxy(0,0);
    printf("test math\n");

    for(char n=0; n<NUMBERS; n++) {
        fp3_set(&numbers[n], (signed int)n, (char)0);
    }

    // print_numbers(numbers);

}
