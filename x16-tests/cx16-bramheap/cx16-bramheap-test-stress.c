#pragma var_model(mem) 
#pragma struct_model(classic)

#pragma link("cx16-bramheap-test.ld")

#include <cx16.h>
#include <conio.h>
#include <stdlib.h>
#include <printf.h>
#include <kernal.h>

#pragma zp_reserve(0x00..0x21, 0x80..0xA8)

#define __LIBRARY_INCLUDE

// #define __BRAM_HEAP_DEBUG
// #define __BRAM_HEAP_DUMP
// #define __BRAM_HEAP_WAIT

#define BRAM_HEAP_SEGMENTS 2
// #define BRAM_BRAM_HEAP

#include <lib-bramheap_asm.h>

#include <cx16-bramheap-segments.h>

void main() {

    cx16_k_screen_set_charset(3,0);

    bram_heap_bram_bank_init(1);

    bram_heap_segment_index_t segment = bram_heap_segment_init(1, 16, (bram_ptr_t)0xA000, 64, (bram_ptr_t)0xA000);

    bram_heap_index_t segment_handles[256];

    unsigned char weight[8] = { 255, 255, 255, 255, 255, 255, 255, 255 };
    unsigned int sizes[8] = { 0x2000, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x4000 };
    unsigned char color[4] = { LIGHT_GREY, GREY, DARK_GREY, BLACK };

    while(!kbhit()) {

        clrscr();

        gotoxy(0, 0);
        printf("Before Dump");
        bram_heap_dump(segment, 0, 2);

        printf("\n\n");


        unsigned int h = rand() % 32;
        h += rand() % 16;
        if(!segment_handles[h]) {
            unsigned int s = 0;
            unsigned char w = 0;
            do {
                s = rand() % 1;
                w = weight[s];
            } while((unsigned char)(rand() % 256) > w);
            unsigned int bytes = sizes[s];
            gotoxy(0,50);
            printf("Allocate %u bytes in segment 2\n\n", bytes);
            segment_handles[h] = bram_heap_alloc(segment, bytes);
        } else {
            gotoxy(0,50);
            printf("Free handle %03x from segment 2\n\n", segment_handles[h]);
            bram_heap_free(segment, segment_handles[h]);
            segment_handles[h] = 0;
        }

        gotoxy(40, 0);
        printf("After Dump");
        bram_heap_dump(segment, 40, 2);

        while(!kbhit());
    }

}