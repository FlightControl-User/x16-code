#pragma link("equinoxe-lib.ld")

#pragma encoding(petscii_mixed)
#pragma var_model(mem)

#pragma asm_library
#pragma calling(__varcall)
#pragma asm_export(wave_add)
#pragma asm_export(wave_set)
#pragma calling(__phicall)

#include "equinoxe-defines.h"
#include "equinoxe-types.h"
#include "stdio-types.h"
#include "lib_conio_asm.h"
#include "lib_lru_cache_asm.h"
#include "lib_veraheap_asm.h"
#include "lib_bramheap_asm.h"
#include "lib_file_asm.h"
#include "equinoxe-layers_asm.h"
#include "equinoxe-animate_asm.h"
#include "equinoxe-palette_asm.h"
#include "equinoxe-flightengine_asm.h"


__asm_export wave_t wave;

wave_index_t wave_add(wave_index_t w) {
    return (w+1) & (WAVE_COUNT-1);
}

void wave_set(wave_index_t w) {
    wave.x[w] += wave.dx[w];
    wave.y[w] += wave.dy[w];
    wave.wait[w] = wave.interval[w];
    wave.enemy_spawn[w] -= 1;
    wave.enemy_count[w] -= 1;
    wave.enemy_alive[w] += 1;
}


