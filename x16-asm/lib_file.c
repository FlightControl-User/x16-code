#pragma encoding(screencode_mixed)
#pragma var_model(mem)

#pragma lib_configure

#pragma calling(__varcall)
#pragma lib_export(fopen)
#pragma lib_export(fclose)
#pragma lib_export(fgets)

#pragma calling(__phicall)

#include <stdio.h>
