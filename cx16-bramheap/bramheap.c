#pragma link("bramheap.ld")
#pragma encoding(petscii_mixed)
#pragma var_model(mem)

#pragma zp_reserve(0x00..0xFF, 0x80..0xA8)

#pragma library(bramheap)

#include <cx16.h>
#include <conio.h>
#include <printf.h>

//#include "cx16-bramheap-lib.h"

#define BRAM_BRAM_HEAP BramBramHeap
#define DATA_BRAM_HEAP CodeBramHeap

// #define __BRAM_HEAP_DEBUG
// #define __BRAM_HEAP_DUMP
// #define __BRAM_HEAP_WAIT

#pragma code_seg(CodeBramHeap)
#pragma data_seg(DataBramHeap)


#include <cx16-bramheap.h>

__export volatile void* funcs[] = {
    &bram_heap_alloc,
    &bram_heap_free,
    &bram_heap_bram_bank_init,
    &bram_heap_segment_init,
    &bram_heap_data_get_bank,
    &bram_heap_data_get_offset,
    &bram_heap_get_size,
    // &bram_heap_dump,
    // &bram_heap_dump_xy,
    // &bram_heap_dump_stats,
    // &bram_heap_dump_graphic_print,
};

#pragma code_seg(Code)
#pragma data_seg(Data)
