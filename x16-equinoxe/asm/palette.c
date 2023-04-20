#pragma link("palette.ld")
#pragma encoding(petscii_mixed)
#pragma var_model(mem)

#pragma code_seg(CodeEnginePalette)
#pragma data_seg(DataEnginePalette)

#include "equinoxe-palette.h"

__export volatile void* funcs[] = {
    &palette_init,
    &palette_alloc_bram,
    &palette_ptr_bram,
    &palette_use_vram,
    &palette_unuse_vram,
    &palette_free_vram,
};

#pragma code_seg(Code)
#pragma data_seg(Data)

void main() {
}

