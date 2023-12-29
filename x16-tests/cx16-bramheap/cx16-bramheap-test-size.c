#pragma var_model(mem)

#pragma link("cx16-bramheap-test.ld")

#include <conio.h>
#include <cx16.h>
#include <kernal.h>
#include <printf.h>
#include <stdlib.h>

#pragma zp_reserve(0x00..0x21, 0x80..0xA8)

// #define __LIBRARY_INCLUDE

// #define __BRAM_HEAP_DEBUG
// #define __BRAM_HEAP_DUMP
// #define __BRAM_HEAP_WAIT

#define BRAM_HEAP_SEGMENTS 2
// #define BRAM_BRAM_HEAP

#ifdef __LIBRARY_INCLUDE
#include <cx16-bramheap-lib.h>
#else
#include <cx16-bramheap-segments.h>
#endif

void main() {

#ifdef __LIBRARY_INCLUDE
    {kickasm {{ 
        jsr bramheap.__start 
        }};
    }
#endif

    cx16_k_screen_set_charset(3, 0);

    bram_heap_bram_bank_init(1);

    bram_heap_segment_index_t s0 = bram_heap_segment_init(0, 0x10, (bram_ptr_t)0xA000, 0x18, (bram_ptr_t)0xA000);
    bram_heap_segment_index_t s1 = bram_heap_segment_init(1, 0x18, (bram_ptr_t)0xA000, 0x40, (bram_ptr_t)0xA000);

    bram_heap_index_t s0_handles[256];
    bram_heap_index_t s1_handles[256];

    clrscr();

    // asm{.byte $db}
    printf("\n\n\n\nsize = %05x\n", bram_heap_get_size(1,0));

    // while (!kbhit());

    // clrscr();

    // for (unsigned int i = 0; i < 128; i++) {
    //     s1_handles[i] = bram_heap_alloc(s1, 0x40);
    // }

    // for (unsigned int i = 0; i < 128; i++) {
    //     s0_handles[i] = bram_heap_alloc(s0, 0x80);
    // }

    // gotoxy(0, 0);
    // printf("Segment %u\n", s0);
    // bram_heap_dump_xy(0, 2);
    // bram_heap_dump_stats(s0);

    // gotoxy(0,10);
    // for(unsigned int i = 0; i < 255; i++) {
    //     bram_heap_index_t h = s0_handles[i];
    //     if(h) {
    //     bram_bank_t b = bram_heap_data_get_bank(s0, h);
    //     bram_ptr_t o = bram_heap_data_get_offset(s0, h);
    //     printf("%02x/%04p ", b, o);
    //     }
    // }

    while (!kbhit());

#ifdef __LIBRARY_INCLUDE
{
    __export char BRAMHEAP[] = kickasm(resource "../../target/cx16-bramheap/bramheap.asm"){{
#define __bramheap__
#import "bramheap.asm"
    }};
}
#endif

}
