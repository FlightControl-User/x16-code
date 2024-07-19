

#pragma var_model(mem)

#include "equinoxe-defines.h"


#include <cx16.h>
#include <cx16-irq.h>
#include "cx16-vera.h"
#include "cx16-veralib.h"
#include <cx16-file.h>
#include <conio.h>
#include <kernal.h>
#include <6502.h>
#include <mos6522.h>
// #include <stdio.h>
#include <stdio-types.h>
#include <stdlib.h>
// // #include <printf.h>
// #include <sprintf.h>
#include <division.h>
#include <multiply.h>
#include <cx16-veralib.h>
#include <cx16-mouse.h>


#include <ht.h>

#include "equinoxe-types.h"
#include "equinoxe-bank.h"
#include "equinoxe-defines.h"

#include <lib_lru_cache.p>
#include <lib_bramheap.p>
#include <lib_veraheap.p>

#include <equinoxe-palette.p>

#include <equinoxe-animate.p>

// #include "cx16_file.h"


#include "equinoxe-math.h"
#include "equinoxe-levels.h"

// #include "equinoxe-flightengine.h"

#ifdef __FLOOR
// #include "equinoxe-floorengine.h"
#endif


#include <equinoxe-player.p>

#ifdef __TOWER
#include "equinoxe-tower.h"
#endif

#ifdef __BULLET
#include <equinoxe-bullet.p>
#endif

// #include "equinoxe-collision.h"
#pragma var_model(mem)
#include "equinoxe-stage.h"

//extern const heap_structure_t* heap_bram_blocked;


extern equinoxe_game_t game;
// volatile extern char buffer[256];
