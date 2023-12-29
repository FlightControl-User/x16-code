#pragma link("lib-animate.ld")
#pragma encoding(petscii_mixed)
#pragma var_model(zp)
#pragma asm_library

#pragma code_seg(CodeEngineAnimate)
#pragma data_seg(DataEngineAnimate)

#pragma calling(__varcall)
#pragma asm_export(animate_init, animate_add, animate_logic)
#pragma asm_export(animate_is_waiting, animate_get_image, animate_get_transition)
#pragma asm_export(animate_del, animate_player, animate_tower)

#pragma calling(__phicall)

#include <cx16-veralib.h>
#include "equinoxe-animate.h"

#pragma code_seg(CodeEngineAnimate)
#pragma data_seg(DataEngineAnimate)
