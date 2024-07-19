#pragma link("lib_veraheap.ld")

#pragma encoding(petscii_mixed)
#pragma var_model(mem)

#pragma library(veraheap)

#pragma lib_configure
#pragma calling(__varcall)
#pragma lib_export(vera_heap_alloc)
#pragma lib_export(vera_heap_free)
#pragma lib_export(vera_heap_bram_bank_init)
#pragma lib_export(vera_heap_segment_init)
#pragma lib_export(vera_heap_data_get_offset)
#pragma lib_export(vera_heap_data_get_bank)
#pragma lib_export(vera_heap_get_image)
#pragma lib_export(vera_heap_set_image)
#pragma lib_export(vera_heap_has_free)

#pragma calling(__phicall)

#include <cx16.h>
// #include <conio.h>
// #include <printf.h>

#define BRAM_VERA_HEAP BramVeraHeap
#define DATA_VERA_HEAP DataVeraHeap

// #define __VERAHEAP_COLOR_FREE

// #define __VERAHEAP_DEBUG
// #define __VERAHEAP_DUMP
// #define __VERAHEAP_WAIT



#pragma code_seg(CodeVeraHeap)
#pragma data_seg(DataVeraHeap)

#include <cx16-veraheap.h>

#pragma code_seg(Code)
#pragma data_seg(Data)

