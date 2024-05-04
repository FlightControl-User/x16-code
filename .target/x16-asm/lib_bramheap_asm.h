extern __varcall __asm_import("lib_bramheap") __zp_reserve( 34,35,36,37 ) __mem() char bram_heap_alloc(__mem() char s, __mem() unsigned long size);
extern __varcall __asm_import("lib_bramheap") __zp_reserve( 34,35,36,37 ) void bram_heap_free(__mem() char s, __mem() char free_index);
extern __varcall __asm_import("lib_bramheap") __zp_reserve( 38,39 ) void bram_heap_bram_bank_init(__mem() char bram_bank);
extern __varcall __asm_import("lib_bramheap") __zp_reserve( 34,35,36,37 ) __mem() char bram_heap_segment_init(__mem() char s, __mem() char bram_bank_floor, __zp($22) char *bram_ptr_floor, __mem() char bram_bank_ceil, __zp($24) char *bram_ptr_ceil);
extern __varcall __asm_import("lib_bramheap") __zp_reserve( 34,35 ) __mem() char bram_heap_data_get_bank(__mem() char s, __mem() char index);
extern __varcall __asm_import("lib_bramheap") __zp_reserve( 34,35,36,37 ) __zp($24) char * bram_heap_data_get_offset(__mem() char s, __mem() char index);
extern __varcall __asm_import("lib_bramheap") __zp_reserve( 34,35,36,37 ) __mem() unsigned long bram_heap_get_size(__mem() char s, __mem() char index);
extern __phicall __asm_import("lib_bramheap") void __lib_bramheap_start();
