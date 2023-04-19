// #pragma var_model(mem) 

#include <cx16-veraheap.h>

vera_heap_segment_index_t s;
vera_heap_handle_t h1;


void main() {

    vera_heap_bram_bank_init(1);

    s = vera_heap_segment_init(0, 0, 0x0000, 1, 0xB000);
    h1 = vera_heap_alloc(s, 8);
    vera_heap_free(s,h1);
}