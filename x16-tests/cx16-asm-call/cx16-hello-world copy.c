#include <conio.h>
#include <printf.h>

#pragma encoding(screencode_mixed)

volatile char rom_detected[16];
volatile char rom_name[16];

void main() {

    printf("%p, %p\n", rom_detected, rom_name);
}
