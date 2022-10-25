#pragma var_model(mem)

#include <cx16-conio.h>
#include <cx16.h>
#include <division.h>
#include <lru-cache.h>
#include <stdio.h>
#include <string.h>
#include <cx16-veralib.h>


void wait_key() {
    printf("print any key ...\n");
    while (!getin());
}


void main() {

    clrscr();
    gotoxy(0,20);

    bank_set_bram(1);
    unsigned char* ptr = (char*)0xB805;

    

    for(unsigned int i=0; i<256*6; i+=2) {
        ptr[i] = 'A';
        ptr[i+1] = 2;
    }

    memcpy_vram_bram(1, 0xB000, 1, ptr, 0x410);
}
