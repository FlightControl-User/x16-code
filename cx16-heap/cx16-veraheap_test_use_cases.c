// #pragma var_model(mem) 

#define VERAHEAP_DEBUG
#define VERAHEAP_DUMP

#include <stdlib.h>
#include <cx16.h>
#include <cx16-veraheap.h>


void main() {

    vera_heap_bram_bank_init(1);

    vera_heap_segment_index_t s = vera_heap_segment_init(0, 0, 0x0000, 1, 0xB000);

    clrscr();
    printf("UC01 - Allocate handle 1, 8 bytes\n\n");
	vera_heap_handle_t h1 = vera_heap_alloc(s, 8);

    clrscr();
    printf("UC02 - Allocate handle 2, 16 bytes\n\n");
	vera_heap_handle_t h2 = vera_heap_alloc(s, 16);
    
    clrscr();
    printf("UC03 - Allocate handle 3, 8 bytes\n\n");
	__mem vera_heap_handle_t h3 = vera_heap_alloc(s, 8);

    clrscr();
    printf("UC04 - Allocate handle 4, 16 bytes\n\n");
	__mem vera_heap_handle_t h4 = vera_heap_alloc(s, 16);

    clrscr();
    printf("UC04 - Allocate handle 5, 16 bytes\n\n");
	__mem vera_heap_handle_t h5 = vera_heap_alloc(s, 16);

    clrscr();
    printf("UC04 - Allocate handle 6, 8 bytes\n\n");
	__mem vera_heap_handle_t h6 = vera_heap_alloc(s, 8);

    clrscr();
    printf("UC04 - Allocate handle 7, 8 bytes\n\n");
	__mem vera_heap_handle_t h7 = vera_heap_alloc(s, 8);

    // Free middle memory blocks

    clrscr();
    printf("UC05 - Free handle 1, 8 bytes\n\n");
	vera_heap_free(s, h1);

    clrscr();
    printf("UC06 - Free handle 3, 8 bytes\n\n");
	vera_heap_free(s, h3);

    clrscr();
    printf("UC07 - Free handle 5, 16 bytes\n\n");
	vera_heap_free(s, h5);


    // Coalescing free boundary blocks

    clrscr();
    printf("UC09 - Free handle 7, 8 bytes\n\n");
	vera_heap_free(s, h7);

    clrscr();
    printf("UC10 - Free handle 2, 16 bytes\n\n");
	vera_heap_free(s, h2);

    clrscr();
    printf("UC11 - Free handle 4, 16 bytes\n\n");
	vera_heap_free(s, h4);

    clrscr();
    printf("UC12 - Free handle 6, 8 bytes\n\n");
	vera_heap_free(s, h6);

    // Reallocate memory

    clrscr();
    printf("UC13 - Allocate handle 8, 8 bytes\n\n");
	vera_heap_handle_t h8 = vera_heap_alloc(s, 8);

    clrscr();
    printf("UC14 - Allocate handle 9, 32 bytes\n\n");
	vera_heap_handle_t h9 = vera_heap_alloc(s, 32);

    clrscr();
    printf("UC15 - Allocate handle 10, 8 bytes\n\n");
	vera_heap_handle_t h10 = vera_heap_alloc(s, 8);

    clrscr();
    printf("UC16 - Free handle 9, 32 bytes\n\n");
	vera_heap_free(s, h9);

    clrscr();
    printf("UC17 - Allocate handle 11, 24 bytes\n\n");
	vera_heap_handle_t h11 = vera_heap_alloc(s, 24);

}