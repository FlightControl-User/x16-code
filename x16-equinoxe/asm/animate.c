#pragma link("animate.ld")
#pragma encoding(petscii_mixed)
#pragma var_model(mem)
#pragma library(animate)

#pragma code_seg(CodeEngineAnimate)
#pragma data_seg(DataEngineAnimate)

#include "equinoxe-animate.h"

#pragma code_seg(CodeEngineAnimate)
#pragma data_seg(DataEngineAnimate)

__export volatile void* funcs[] = {
    &animate_init,
    &animate_add,
    &animate_logic,
    &animate_is_waiting,
    &animate_get_state,
    &animate_del,
    // &lru_cache_display
};
