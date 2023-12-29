#pragma var_model(mem) 

#pragma link("cx16-veraheap-test.ld")

#include <cx16.h>
#include <conio.h>
#include <stdlib.h>
#include <printf.h>
#include <kernal.h>

#pragma zp_reserve(0x00..0x2f, 0x80..0xA8)



#include <cx16-veraheap-lib.h>


void main() {

    {kickasm {{
        jsr veraheap.__start
    }}}

    vera_heap_bram_bank_init(1);

    // vera_heap_segment_index_t s1 = vera_heap_segment_init(0, 0, 0x0000, 0, 0x8000);
    vera_heap_segment_index_t s2 = vera_heap_segment_init(1, 0, 0x0000, 1, 0xB000);

    vera_heap_index_t s2_handles[256];

    unsigned char weight[4] = { 31, 255, 7, 3 };
    unsigned int sizes[4] = { 256, 512, 1024, 2048 };
    unsigned char color[4] = { LIGHT_GREY, GREY, DARK_GREY, BLACK };

    while(!kbhit()) {

        clrscr();
        cx16_k_screen_set_charset(3,0);


        gotoxy(0, 0);
        printf("Before Dump");
        vera_heap_dump(s2, 0, 2);

        printf("\n\n");

        unsigned int h = rand() % 32;
        h += rand() % 16;
        if(!s2_handles[h]) {
            unsigned int s = 0;
            unsigned char w = 0;
            do {
                s = rand() % 4;
                w = weight[s];
            } while((unsigned char)(rand() % 256) > w);
            unsigned int bytes = sizes[s];
            printf("Allocate %u bytes in segment 2\n\n", bytes);
            s2_handles[h] = vera_heap_alloc(s2, bytes);
        } else {
            printf("Free handle %03x from segment 2\n\n", s2_handles[h]);
            vera_heap_free(s2, s2_handles[h]);
            s2_handles[h] = 0;
        }

        gotoxy(40, 0);
        printf("After Dump");
        vera_heap_dump(s2, 40, 2);

        while(!kbhit());
    }

#ifndef __INTELLISENSE__
__export char VERAHEAP[] = kickasm(resource "../../target/cx16-veraheap/veraheap.asm") {{
    #define __veraheap__
    #import "veraheap.asm"
}};
#endif

}