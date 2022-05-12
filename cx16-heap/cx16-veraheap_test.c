#pragma var_model(mem)

#define VERAHEAP_DEBUG

#include <stdlib.h>
#include <cx16.h>
#include <cx16-veraheap.h>


void main() {

    vera_heap_bram_bank_init(1);

    vera_heap_segment_index_t s = vera_heap_segment_init(0, 0, 0x0000, 1, 0xB000);

    clrscr();
	vera_heap_handle_t h1 = vera_heap_alloc(s, 8);

    clrscr();
	vera_heap_handle_t h2 = vera_heap_alloc(s, 16);
    
    clrscr();
	vera_heap_handle_t h3 = vera_heap_alloc(s, 8);

    clrscr();
	vera_heap_handle_t h4 = vera_heap_alloc(s, 16);

    clrscr();
	vera_heap_handle_t h5 = vera_heap_alloc(s, 24);

    clrscr();
	vera_heap_handle_t h6 = vera_heap_alloc(s, 8);

    clrscr();
	vera_heap_handle_t h7 = vera_heap_alloc(s, 8);

    // Free middle memory blocks

    clrscr();
    printf("free handle 1\n\n");
	vera_heap_free(s, h1);

    clrscr();
    printf("free handle 3\n\n");
	vera_heap_free(s, h3);

    clrscr();
    printf("free handle 5\n\n");
	vera_heap_free(s, h5);

    clrscr();
    printf("free handle 7\n\n");
	vera_heap_free(s, h7);


    // Coalescing free boundary blocks

    clrscr();
    printf("free handle 2\n\n");
	vera_heap_free(s, h2);

    clrscr();
    printf("free handle 4\n\n");
	vera_heap_free(s, h4);

    clrscr();
    printf("free handle 6\n\n");
	vera_heap_free(s, h6);


	// vera_heap_free(s, h2);

	// vera_heap_handle_t h4 = vera_heap_alloc(s, 1024);

	// vera_heap_handle_t h5 = vera_heap_alloc(s, 2048);

}