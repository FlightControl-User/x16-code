#pragma var_model(mem) 
#pragma link("cx16-veraheap_test_segments.ld")

#define VERAHEAP_DEBUG

#include <stdlib.h>
#include <cx16.h>
#include <cx16-veraheap.h>


void main() {

    vera_heap_bram_bank_init(1);

    vera_heap_segment_index_t s1 = vera_heap_segment_init(0, 0, 0x2000, 0, 0xA000);
    vera_heap_segment_index_t s2 = vera_heap_segment_init(1, 0, 0xA000, 1, 0xB000);

    clrscr();
    printf("SE01 - Allocate handle s1h1, 512 bytes in segment 1\n\n");
    vera_heap_dump(s1,0,4);
    gotoxy(0,20);
	vera_heap_handle_t s1h1 = vera_heap_alloc(0, 512);
    printf("\n%x", s1h1);
    vera_heap_dump(s1,40,4);
    gotoxy(0,59);
    while(!kbhit());

    clrscr();
    printf("SE02 - Allocate handle s2h1, 1024 bytes in segment 2\n\n");
    vera_heap_dump(s2,0,4);
    gotoxy(0,20);
	vera_heap_handle_t s2h1 = vera_heap_alloc(1, 1024);
    printf("\n%x", s2h1);
    vera_heap_dump(s2,40,4);
    gotoxy(0,59);
    while(!kbhit());

    clrscr();
    vera_heap_dump(s1,0,4);
    gotoxy(0,20);

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

    printf("\n%x", s1h1);
    vera_heap_dump(s1,40,4);
    gotoxy(0,59);
    while(!kbhit());

    clrscr();
    vera_heap_dump(s2,0,4);
    gotoxy(0,20);

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

    printf("\n%x", s2h1);
    vera_heap_dump(s2,40,4);
    gotoxy(0,59);
    while(!kbhit());


}