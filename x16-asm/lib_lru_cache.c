#pragma link("lib_lru_cache.ld")

#pragma encoding(petscii_mixed)
#pragma var_model(mem)

#pragma lib_configure
#pragma calling(__varcall)
#pragma lib_export(lru_cache_init)
#pragma lib_export(lru_cache_index)
#pragma lib_export(lru_cache_get)
#pragma lib_export(lru_cache_set)
#pragma lib_export(lru_cache_data)
#pragma lib_export(lru_cache_is_max)
#pragma lib_export(lru_cache_find_last)
#pragma lib_export(lru_cache_delete)
#pragma lib_export(lru_cache_insert)
// #pragma lib_export(lru_cache_display)

#pragma calling(__phicall)

#pragma code_seg(CodeLruCache)
#pragma data_seg(CodeLruCache)
#include <lru-cache.h>

#pragma code_seg(Code)
#pragma data_seg(Data)

