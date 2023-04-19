#pragma link("equinoxe-animate.ld")
#pragma encoding(petscii_mixed)
#pragma var_model(mem)

//#include <cx16.h>

#pragma code_seg(CodeEngineAnimate)
#pragma data_seg(CodeEngineAnimate)
#include "equinoxe-animate.h"


__export volatile void* funcs[] = {
    &animate_init,
    &animate_add,
    &animate_logic,
    &animate_is_waiting,
    &animate_get_state,
    &animate_del,
    // &lru_cache_display
};

#pragma code_seg(Code)
#pragma data_seg(Data)


void main() {
}

