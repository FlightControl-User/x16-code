// #pragma var_model(mem)

#include <stdlib.h>
#include <cx16.h>
#include <cx16-veraheap.h>


void main() {

    vera_heap_bram_bank_init(1);

    vera_heap_segment_index_t s = vera_heap_segment_init(0, 1, 0x0000, 1, 0xB000);

	vera_heap_handle_t h0 = vera_heap_alloc(s, 32);

	vera_heap_handle_t h1 = vera_heap_alloc(s, 64);
    
	vera_heap_handle_t h2 = vera_heap_alloc(s, 512);

	vera_heap_free(s, h0);

	vera_heap_free(s, h1);

	vera_heap_free(s, h2);

	vera_heap_handle_t h4 = vera_heap_alloc(s, 1024);

	vera_heap_handle_t h5 = vera_heap_alloc(s, 2048);

}