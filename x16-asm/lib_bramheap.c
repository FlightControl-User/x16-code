#pragma link("lib_bramheap.ld")

#pragma encoding(petscii_mixed)
#pragma var_model(mem)
#pragma struct_model(classic)
#pragma zp_reserve(0x00..0x01)

#pragma lib_configure
#pragma calling(__varcall)
#pragma lib_export(bram_heap_alloc)
#pragma lib_export(bram_heap_free)
#pragma lib_export(bram_heap_bram_bank_init)
#pragma lib_export(bram_heap_segment_init)
#pragma lib_export(bram_heap_data_get_bank)
#pragma lib_export(bram_heap_data_get_offset)
#pragma lib_export(bram_heap_get_size)
// #pragma lib_export(bram_heap_dump)
// #pragma lib_export(bram_heap_dump_xy)
// #pragma lib_export(bram_heap_dump_stats)
// #pragma lib_export(bram_heap_dump_graphic_print)

#pragma calling(__phicall)

#include <cx16.h>
// #include <conio.h>
// #include <printf.h>

#define BRAM_BRAM_HEAP BramBramHeap
//#define DATA_BRAM_HEAP DataBramHeap

// #define __BRAM_HEAP_DEBUG
// #define __BRAM_HEAP_DUMP
// #define __BRAM_HEAP_WAIT

#pragma code_seg(CodeBramHeap)
#pragma data_seg(DataBramHeap)

#define BRAM_HEAP_SEGMENTS 2
#include <cx16-bramheap-segments.h>

#pragma code_seg(Code)
#pragma data_seg(Data)
