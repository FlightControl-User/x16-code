#pragma encoding(screencode_mixed)
#pragma var_model(mem)

#pragma asm_library

#pragma calling(__varcall)
#pragma asm_export(fopen)
#pragma asm_export(fclose)
#pragma asm_export(fgets)

#pragma calling(__phicall)

#include <stdio.h>
