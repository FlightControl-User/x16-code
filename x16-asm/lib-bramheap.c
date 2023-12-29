#pragma link("lib-bramheap.ld")

#pragma encoding(petscii_mixed)
#pragma var_model(zp)
#pragma struct_model(classic)


#pragma asm_library
#pragma calling(__varcall)
#pragma asm_export(bram_heap_alloc)
#pragma asm_export(bram_heap_free)
#pragma asm_export(bram_heap_bram_bank_init)
#pragma asm_export(bram_heap_segment_init)
#pragma asm_export(bram_heap_data_get_bank)
#pragma asm_export(bram_heap_data_get_offset)
#pragma asm_export(bram_heap_get_size)
// #pragma asm_export(bram_heap_dump)
// #pragma asm_export(bram_heap_dump_xy)
// #pragma asm_export(bram_heap_dump_stats)
// #pragma asm_export(bram_heap_dump_graphic_print)

#pragma calling(__phicall)

#include <cx16.h>
#include <conio.h>
#include <printf.h>

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
