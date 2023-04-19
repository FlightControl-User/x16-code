
#pragma link("veraheap-bin.ld")
#pragma encoding(petscii_mixed)
#pragma var_model(mem)


#include <cx16.h>
#include <conio.h>
#include <printf.h>

#include "veraheap-bin.h"

#define BRAM_VERA_HEAP BramVeraHeap
#define DATA_VERA_HEAP CodeVeraHeap

// #define __VERAHEAP_DEBUG
// #define __VERAHEAP_DUMP
// #define __VERAHEAP_WAIT

#pragma code_seg(CodeVeraHeap)
#pragma data_seg(CodeVeraHeap)

#include <cx16-veraheap.h>

__export volatile void* funcs[] = {
    &vera_heap_alloc,
    &vera_heap_free,
    &vera_heap_bram_bank_init,
    &vera_heap_segment_init,
    &vera_heap_data_get_offset,
    &vera_heap_data_get_bank,
    &vera_heap_has_free,
    // &vera_heap_dump,
};

#pragma code_seg(Code)
#pragma data_seg(Data)


void main() {

}

