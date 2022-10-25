
#pragma var_model(zp)

#define __DEBUG_HEAP_BRAM_BLOCKED

#include <cx16.h>
#include <conio.h>
#include <printf.h>
#include <cx16-heap-bram-fb.h>

heap_structure_t heap; const heap_structure_t* heap_bram = &heap;

fb_heap_segment_t heap_512; const fb_heap_segment_t* bin512 = &heap_512;
fb_heap_segment_t heap_2048; const fb_heap_segment_t* bin2048 = &heap_2048;


void main() {

    clrscr();

    // We create the heap blocks in BRAM using the Fixed Block Heap Memory Manager.
    heap_segment_base(heap_bram, 8, (heap_bram_fb_ptr_t)0xA000); // We set the heap to start in BRAM, bank 32. 
    heap_segment_define(heap_bram, bin512, 512, 320, 320*512);
    heap_segment_define(heap_bram, bin2048, 2048, 20, 2048*96);

    unsigned int h[320];

    for(int i=0;i<320;i++) {
        h[i] = heap_alloc(heap_bram, 512);
    }
    heap_bram_fb_handle_t h1 = heap_alloc(heap_bram, 513);
    heap_bram_fb_handle_t h2 = heap_alloc(heap_bram, 513);

    heap_free(heap_bram, h1);

    heap_print(heap_bram);
}
