#pragma var_model(mem) 

#pragma link("bramheap-test.ld")

#include <cx16.h>
#include <conio.h>
#include <stdlib.h>
#include <printf.h>
#include <kernal.h>

#pragma zp_reserve(0x00..0x40, 0x80..0xA8)

// #define __LIBRARY_INCLUDE
#define __BRAM_HEAP_DEBUG


#ifdef __LIBRARY_INCLUDE
#include <cx16-bramheap-lib.h>
#else
#include <cx16-bramheap.h>
#endif

void main() {

#ifdef __LIBRARY_INCLUDE
    {kickasm {{
        jsr bramheap.__start
    }}}
#endif

    cx16_k_screen_set_charset(3,0);

    bram_heap_bram_bank_init(1);

    bram_heap_segment_index_t s2 = bram_heap_segment_init(2, 0x10, (bram_ptr_t)0xA000, 0x39, (bram_ptr_t)0xA000);

    bram_heap_index_t s2_handles[256];

    unsigned char weight[8] = { 255, 255, 255, 255, 255, 255, 255, 255 };
    unsigned int sizes[8] = { 0x200, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x4000 };
    unsigned char color[4] = { LIGHT_GREY, GREY, DARK_GREY, BLACK };

    while(!kbhit()) {

        clrscr();

        gotoxy(0, 0);
        printf("Before Dump");
        bram_heap_dump(s2, 0, 2);

        printf("\n\n");

        unsigned int h = rand() % 128;
        h += rand() % 64;
        if(!s2_handles[h]) {
            unsigned int s = 0;
            unsigned char w = 0;
            do {
                s = rand() % 1;
                w = weight[s];
            } while((unsigned char)(rand() % 256) > w);
            unsigned int bytes = sizes[s];
            gotoxy(0,50);
            printf("Allocate %u bytes in segment 2\n\n", bytes);
            s2_handles[h] = bram_heap_alloc(s2, bytes);
        // } else {
        //     gotoxy(0,50);
        //     printf("Free handle %03x from segment 2\n\n", s2_handles[h]);
        //     bram_heap_free(s2, s2_handles[h]);
        //     s2_handles[h] = 0;
        }



        gotoxy(40, 0);
        printf("After Dump: %03x", s2_handles[h]);
        gotoxy(40, 2);
        bram_heap_dump(s2, 40, 2);

        while(!kbhit());
    }

#ifdef __LIBRARY_INCLUDE
{__export char BRAM_HEAP[] = kickasm(resource "bramheap-debug.asm") {{
    #import "bramheap-debug.asm" 
}};}
#endif

}