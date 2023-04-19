// #pragma var_model(mem)

#include <cx16-conio.h>
#include <cx16.h>
#include <division.h>
#include <lru-cache.h>
#include <stdio.h>
#include <string.h>

unsigned char __address(0xB000) number;
unsigned char bank = 2;

void wait_key() {
    printf("print any key ...\n");
    while (!kbhit());
}

void init(unsigned char value) {
    asm {
        pha
        lda bank
        sta $00
    }
    number = value;
    asm {
        pla
        sta $00
    }
}

inline unsigned char increment(unsigned char count) {
    asm {
        pha
        lda bank
        sta $00
    }
    unsigned char result = number + count;
    asm {
        pla
        sta $00
    }
    return result;
}

void main() {
    clrscr();

    init(100);
    printf("number = %u\n", increment(1));
    printf("number = %u\n", increment(5));


}
