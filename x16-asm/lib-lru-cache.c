#pragma link("lib-lru-cache.ld")

#pragma encoding(petscii_mixed)
#pragma var_model(zp)

#pragma asm_library
#pragma calling(__varcall)
#pragma asm_export(lru_cache_init)
#pragma asm_export(lru_cache_index)
#pragma asm_export(lru_cache_get)
#pragma asm_export(lru_cache_set)
#pragma asm_export(lru_cache_data)
#pragma asm_export(lru_cache_is_max)
#pragma asm_export(lru_cache_find_last)
#pragma asm_export(lru_cache_delete)
#pragma asm_export(lru_cache_insert)
// #pragma asm_export(lru_cache_display)

#pragma calling(__phicall)

#pragma code_seg(CodeLruCache)
#pragma data_seg(CodeLruCache)
#include <lru-cache.h>

#pragma code_seg(Code)
#pragma data_seg(Data)

