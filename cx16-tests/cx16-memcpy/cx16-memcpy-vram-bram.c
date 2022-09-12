#pragma var_model(mem)

#include <cx16-conio.h>
#include <cx16.h>
#include <division.h>
#include <lru-cache.h>
#include <stdio.h>
#include <string.h>


void wait_key() {
    printf("print any key ...\n");
    while (!getin())
        ;
}

void memcpy_test(vram_bank_t dbank_vram, vram_offset_t doffset_vram, bram_bank_t sbank_bram, bram_ptr_t sptr_bram, unsigned int num ) {

    // vera_vram_data0_bank_offset(dbank_vram, doffset_vram, vera_inc_1);

    // byte bank = bank_get_bram();
    // bank_set_bram(sbank_bram);

    const bram_ptr_t pagesize = (bram_ptr_t)0x100;
    const bram_ptr_t pagemask = (bram_ptr_t)0xFF00;

    // Set the page boundary.
    bram_ptr_t ptr = sptr_bram;
    unsigned int len = (unsigned int)(((sptr_bram & pagemask) + pagesize) - sptr_bram);

    // gotoxy(0, 0);

    // If y has a value, that means that the start is not at pure page boundary.
    // We copy to the next page boundary.
    unsigned char x = len;
    if(num<=len)
        x = num;

    printf("start:  *ptr=%4p, x=%5u, num=%5u, sptr=%4p\n", ptr, x, num, sptr_bram);

    if(x) {
        unsigned char y = x;
        do {
            // *VERA_DATA0 = ptr[y];
            y++;
        } while(y);
        ptr += x;
        num -= x;
    }

    // Adjust the ptr and check if we are at page boundary.
    if(BYTE1(ptr)==0xC0) {
        ptr = (unsigned char*)0xA000;
        bank_set_bram(++sbank_bram); // select the bank
    }


    // Copy the paged part for long lasting copies.
    x = BYTE1(num);

    if(x) {
        do {
            printf("middle: *ptr=%4p, x=%5u, num=%5u, sptr=%4p\n", ptr, x, num, sptr_bram);
            unsigned char y = 0;
            do {
                // *VERA_DATA0 = ptr[y];
                y++;
            } while(y);
            ptr += 256;
            if(BYTE1(ptr)==0xC0){
                ptr = (unsigned char*)0xA000;
                bank_set_bram(++sbank_bram); // select the bank
            }
            x--;
            num -= 256;
        } while(x);
    }

    // Now copy the remainder part.
    x = num;
    printf("tail:   *ptr=%4p, x=%5u, num=%5u, sptr=%4p\n", ptr, x, num, sptr_bram);
    if(x) {
        unsigned char y = 0;
        do {
            // *VERA_DATA0 = ptr[y];
            x--;
            y++;
        } while(x);
        ptr += num;
    }

    printf("end:    *ptr=%4p, x=%5u, num=%5u, sptr=%4p\n", ptr, x, num, sptr_bram);

    printf("\n");
    // while(!getin());


    // bank_set_bram(bank);
}

void main() {
    clrscr();

    unsigned char* ptr = (char*)0xA000;
    memcpy_test(0, 0x8000, 1, ptr, 128+256);

    ptr = (char*)0xA080;
    memcpy_test(0, 0x8000, 1, ptr, 256);

    ptr = (char*)0xA200;
    memcpy_test(0, 0x8000, 1, ptr, 512);

    ptr = (char*)0xA2B0;
    memcpy_test(0, 0x8000, 1, ptr, 512);

    ptr = (char*)0xBF40;
    memcpy_test(0, 0x8000, 1, ptr, 512);

    ptr = (char*)0xBE40;
    memcpy_test(0, 0x8000, 1, ptr, 64);
}
