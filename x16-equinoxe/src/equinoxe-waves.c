#pragma link("equinoxe-libraries.ld")

#pragma encoding(petscii_mixed)
#pragma var_model(mem)

#pragma lib_configure
#pragma calling(__varcall)
#pragma lib_export(wave_add)
#pragma lib_export(wave_set)
#pragma calling(__phicall)

#include "equinoxe-defines.h"
#include "equinoxe-types.h"
#include "stdio-types.h"
#include <lib_conio.p>
#include <lib_lru_cache.p>
#include <lib_veraheap.p>
#include <lib_bramheap.p>
#include <lib_file.p>
#include <equinoxe-layers.p>
#include <equinoxe-animate.p>
#include <equinoxe-palette.p>
// #include <equinoxe-flightengine.p>


__lib_export wave_t wave;

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


