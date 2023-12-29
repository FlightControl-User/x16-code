extern __varcall __asm_import("lib-bramheap") __zp_reserve($50, $28, $35, $20, $52, $20, $52) __zp($35) char bram_heap_alloc(__zp($50) char s, __zp($28) unsigned long size);
extern __varcall __asm_import("lib-bramheap") __zp_reserve($4f, $4e, $4d, $36, $30, $4d, $36, $30) void bram_heap_free(__zp($4f) char s, __zp($4e) char free_index);
extern __varcall __asm_import("lib-bramheap") __zp_reserve($46) void bram_heap_bram_bank_init(__zp($46) char bram_bank);
extern __varcall __asm_import("lib-bramheap") __zp_reserve($41, $4d, $26, $47, $3d, $41, $36, $36, $b, $51, $b, $b, $51, $4c) __zp($41) char bram_heap_segment_init(__zp($41) char s, __zp($4d) char bram_bank_floor, __zp($26) char *bram_ptr_floor, __zp($47) char bram_bank_ceil, __zp($3d) char *bram_ptr_ceil);
extern __varcall __asm_import("lib-bramheap") __zp_reserve($4e, $51, $38, $18, $18, $18, $18, $18) __zp($38) char bram_heap_data_get_bank(__zp($4e) char s, __zp($51) char index);
extern __varcall __asm_import("lib-bramheap") __zp_reserve($48, $49, $14, $14, $14, $14, $14, $14, $14, $14, $14) __zp($14) char * bram_heap_data_get_offset(__zp($48) char s, __zp($49) char index);
extern __varcall __asm_import("lib-bramheap") __zp_reserve($4c, $41, $28, $28, $18, $28, $28, $28) __zp($28) unsigned long bram_heap_get_size(__zp($4c) char s, __zp($41) char index);
extern __phicall __asm_import("lib-bramheap") void __lib_bramheap_start();
