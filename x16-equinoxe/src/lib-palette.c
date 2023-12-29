#pragma link("lib-palette.ld")
#pragma encoding(petscii_mixed)
#pragma var_model(zp)
#pragma asm_library

#pragma code_seg(CodeEnginePalette)
#pragma data_seg(DataEnginePalette)

#pragma calling(__varcall)
#pragma asm_export(palette_init, palette_alloc_bram, palette_ptr_bram)
#pragma asm_export(palette_use_vram, palette_unuse_vram, palette_free_vram)

#pragma calling(__phicall)

#include "equinoxe-palette.h"

#pragma code_seg(Code)
#pragma data_seg(Data)
