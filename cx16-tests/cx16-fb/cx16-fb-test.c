#include <conio.h>
#include <printf.h>
#include <multiply.h>
#include <cx16-fb.h>


static heap_segment bin512; 
static heap_segment bin256; 
static heap_segment bin128;

static heap_structure bins;


void main() {

    clrscr();
    gotoxy(0,0);

    heap_segment_define(&bins, &bin128, 128U, 32U, 128U*32U);
    heap_segment_define(&bins, &bin256, 256U, 12U, 256U*12U);
    heap_segment_define(&bins, &bin512, 512U, 64U, 512U*64U);

    heap_handle h1 = heap_alloc(&bins, 256);
    heap_handle h2 = heap_alloc(&bins, 512);
    heap_handle h3 = heap_alloc(&bins, 512);
    heap_handle h4 = heap_alloc(&bins, 512);
    heap_handle h5 = heap_alloc(&bins, 512);
    heap_handle h6 = heap_alloc(&bins, 128);
    heap_handle h7 = heap_alloc(&bins, 128);
    heap_handle h8 = heap_alloc(&bins, 256);
    heap_handle h9 = heap_alloc(&bins, 128);

    heap_free(&bins, h2);
    heap_free(&bins, h3);
    heap_free(&bins, h4);
    heap_free(&bins, h1);
    heap_free(&bins, h8);

    // heap_print(&bins);

    heap_handle h10 = heap_alloc(&bins, 256);
    heap_handle h11 = heap_alloc(&bins, 512);
    heap_handle h12 = heap_alloc(&bins, 128);

    heap_free(&bins, h7);
    heap_free(&bins, h6);

    // heap_print(&bins);

}
