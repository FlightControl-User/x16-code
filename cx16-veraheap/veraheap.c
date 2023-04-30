#pragma link("veraheap.ld")
#pragma encoding(petscii_mixed)
#pragma var_model(mem)
#pragma library(veraheap)

#include <cx16.h>
#include <conio.h>
#include <printf.h>

#pragma zp_reserve(0x00..0xFF, 0x80..0xA8)

#define BRAM_VERA_HEAP BramVeraHeap
#define DATA_VERA_HEAP CodeVeraHeap

// #define __VERAHEAP_DEBUG
// #define __VERAHEAP_DUMP
// #define __VERAHEAP_WAIT

#pragma code_seg(CodeVeraHeap)
#pragma data_seg(DataVeraHeap)

#include <cx16-veraheap.h>

__export volatile void* funcs[] = {
    &vera_heap_alloc,
    &vera_heap_free,
    &vera_heap_bram_bank_init,
    &vera_heap_segment_init,
    &vera_heap_data_get_offset,
    &vera_heap_data_get_bank,
    &vera_heap_get_image,
    &vera_heap_set_image,
    &vera_heap_has_free,
    // &vera_heap_dump,
};

#pragma code_seg(Code)
#pragma data_seg(Data)

