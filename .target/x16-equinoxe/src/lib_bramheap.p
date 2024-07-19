extern __varcall __lib_import("lib_bramheap") __mem() char bram_heap_alloc(__mem() char s, __mem() unsigned long size);
extern __varcall __lib_import("lib_bramheap") void bram_heap_free(__mem() char s, __mem() char free_index);
extern __varcall __lib_import("lib_bramheap") void bram_heap_bram_bank_init(__mem() char bram_bank);
extern __varcall __lib_import("lib_bramheap") __mem() char bram_heap_segment_init(__mem() char s, __mem() char bram_bank_floor, __zp char *bram_ptr_floor, __mem() char bram_bank_ceil, __zp char *bram_ptr_ceil);
extern __varcall __lib_import("lib_bramheap") __mem() char bram_heap_data_get_bank(__mem() char s, __mem() char index);
extern __varcall __lib_import("lib_bramheap") __zp char * bram_heap_data_get_offset(__mem() char s, __mem() char index);
extern __varcall __lib_import("lib_bramheap") __mem() unsigned long bram_heap_get_size(__mem() char s, __mem() char index);
extern __phicall __lib_import("lib_bramheap") void conio_x16_init();
extern __phicall __lib_import("lib_bramheap") void __lib_bramheap_start();
