#pragma link("lru-cache-bin.ld")
#pragma encoding(petscii_mixed)
#pragma var_model(mem)

//#include <cx16.h>
#include "lru-cache-bin.h"

#pragma code_seg(CodeLruCache)
#pragma data_seg(CodeLruCache)
#include <lru-cache.h>


__export volatile void* funcs[] = {
    &lru_cache_init,
    &lru_cache_index,
    &lru_cache_get,
    &lru_cache_set,
    &lru_cache_data,
    &lru_cache_is_max,
    &lru_cache_find_last,
    &lru_cache_delete,
    &lru_cache_insert,
    // &lru_cache_display
};

#pragma code_seg(Code)
#pragma data_seg(Data)


void main() {
}

