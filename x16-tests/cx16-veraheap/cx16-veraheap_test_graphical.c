// #pragma var_model(mem) 

#pragma link("cx16-veraheap-test.ld")

#define VERAHEAP_DEBUG

#include <stdlib.h>
#include <cx16.h>
#include <conio.h>
#include <cx16-conio.h>
#include <printf.h>

#pragma encoding(screencode_mixed)

#include <cx16-veraheap-lib.h>

vera_heap_index_t segment1_handles[256];
vera_heap_index_t segment2_handles[256];

void vera_alloc(vera_heap_segment_index_t segment, vera_heap_index_t* handles, char count, unsigned int size) {
    for(unsigned char i = 0; i < count; i++) {
        *handles = vera_heap_alloc(segment, size);
        if(*handles == 0xFF) {
            printf("Failed to allocate %u bytes\n", size);
            return;
        }
        handles++;
    }
}

void vera_free(vera_heap_segment_index_t segment, vera_heap_index_t* handles, char count) {
    for(unsigned char i = 0; i < count; i++) {
        vera_heap_free(segment, *handles);
        *handles = 0xFF;
        handles++;
    }
}

void main() {

    bgcolor(WHITE);
    textcolor(BLACK);
    clrscr();

    vera_heap_bram_bank_init(1);
    vera_heap_segment_index_t s0 = vera_heap_segment_init(0, 0, 0x0000, 1, 0x8000);
    vera_heap_segment_index_t s1 = vera_heap_segment_init(1, 1, 0x8000, 1, 0xA000);

    char h1[12];
    vera_alloc(s0, h1, 12, 32*32/2);

    vera_heap_dump_graphic_print(s0,0,10);
   
    

#ifndef __INTELLISENSE__
__export char VERAHEAP[] = kickasm(resource "../../target/cx16-veraheap/veraheap.asm") {{
    #define __veraheap__
    #import "veraheap.asm"
}};
#endif

}