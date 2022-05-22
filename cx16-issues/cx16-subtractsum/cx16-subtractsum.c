#include <conio.h>
#include <printf.h>
#include <cx16.h>

const word SIZE1 = 0x1000;
const word SIZE2 = 0x0800;


void main() {
    printf("calculation result = %x", 0xF800-(SIZE1+SIZE2));
}
