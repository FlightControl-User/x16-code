#pragma var_model(mem) 

// #define VERAHEAP_DEBUG

#include <stdlib.h>
#include <cx16.h>
#include <cx16-veraheap.h>


void main() {

    vera_heap_bram_bank_init(1);

    vera_heap_segment_index_t s1 = vera_heap_segment_init(0, 0, 0x0000, 0, 0x8000);
    vera_heap_segment_index_t s2 = vera_heap_segment_init(1, 0, 0x8000, 1, 0x4000);

    clrscr();
    printf("SE01 - Allocate handle s1h1, 512 bytes in segment 1\n\n");
	vera_heap_handle_t s1h1 = vera_heap_alloc(s1, 512);
    printf("SE01 - Allocate handle s1h2, 1024 bytes in segment 1\n\n");
	vera_heap_handle_t s1h2 = vera_heap_alloc(s1, 1024);
    printf("SE01 - Allocate handle s1h3, 256 bytes in segment 1\n\n");
	vera_heap_handle_t s1h3 = vera_heap_alloc(s1, 256);
    printf("SE01 - Allocate handle s1h4, 2048 bytes in segment 1\n\n");
	vera_heap_handle_t s1h4 = vera_heap_alloc(s1, 2048);
    printf("SE01 - Allocate handle s1h5, 512 bytes in segment 1\n\n");
	vera_heap_handle_t s1h5 = vera_heap_alloc(s1, 512);
    printf("SE01 - Free handle s1h2, 1024 bytes in segment 1\n\n");
	vera_heap_free(s1, s1h2);
    while(!getin());

    clrscr();
    printf("SE02 - Allocate handle s2h1, 1024 bytes in segment 2\n\n");
	vera_heap_handle_t s2h1 = vera_heap_alloc(s2, 1024);
    printf("SE02 - Allocate handle s2h2, 1024 bytes in segment 2\n\n");
	vera_heap_handle_t s2h2 = vera_heap_alloc(s2, 2048);
    printf("SE02 - Allocate handle s2h3, 256 bytes in segment 2\n\n");
	vera_heap_handle_t s2h3 = vera_heap_alloc(s2, 512);
    printf("SE02 - Allocate handle s2h4, 2048 bytes in segment 2\n\n");
	vera_heap_handle_t s2h4 = vera_heap_alloc(s2, 256);
    printf("SE02 - Allocate handle s2h5, 512 bytes in segment 2\n\n");
	vera_heap_handle_t s2h5 = vera_heap_alloc(s2, 4096);
    printf("SE02 - Free handle s2h4, 256 bytes in segment 2\n\n");
	vera_heap_free(s2, s2h4);
    while(!getin());

    clrscr();
    printf("SE01 - Dump\n\n");
    vera_heap_dump(s1);
    while(!getin());

    clrscr();
    printf("SE02 - Dump\n\n");
    vera_heap_dump(s2);
    while(!getin());

    vera_heap_segment_index_t s2_handles[256];

    for(unsigned int j=0; j<10; j++) {

    clrscr();
    printf("SE02 - Dump\n\n");
    vera_heap_dump(s2);

    for(unsigned int a=0; a<4; a++) {
        s2_handles[a] = vera_heap_alloc(s2, (unsigned long)rand()%64);
    }

    clrscr();
    printf("SE02 - Dump\n\n");
    vera_heap_dump(s2);

    for(unsigned int f=0; f<4; f+=2) {
        vera_heap_free(s2, s2_handles[f]);
    }

    clrscr();
    printf("SE02 - Dump\n\n");
    vera_heap_dump(s2);

    for(unsigned int f=1; f<4; f+=2) {
        vera_heap_free(s2, s2_handles[f]);
    }

    clrscr();
    printf("SE02 - Dump\n\n");
    vera_heap_dump(s2);
    }

    clrscr();
    printf("SE02 - Dump\n\n");
    vera_heap_dump(s2);
    while(!getin());

}