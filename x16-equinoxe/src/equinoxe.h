

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
#include <stdio.h>
#include <stdlib.h>
#include <printf.h>
#include <sprintf.h>
#include <division.h>
#include <multiply.h>
#include <cx16-veralib.h>
#include <cx16-mouse.h>


#include <ht.h>

#include "equinoxe-types.h"
#include "equinoxe-bank.h"
#include "equinoxe-defines.h"

#include <lib_lru_cache_asm.h>
#include <lib_bramheap_asm.h>
#include <lib_veraheap_asm.h>

#include "equinoxe-palette_asm.h"

#include "equinoxe-animate_asm.h"

#include <cx16_file_asm.h>


#include "equinoxe-math.h"
#include "equinoxe-levels.h"

// #include "equinoxe-flightengine.h"

#ifdef __FLOOR
// #include "equinoxe-floorengine.h"
#endif


#include "equinoxe-player.h"

#ifdef __ENEMY
#include "equinoxe-enemy.h"
#endif

#ifdef __TOWER
#include "equinoxe-tower.h"
#endif

#ifdef __BULLET
#include "equinoxe-bullet.h"
#endif

#include "equinoxe-collision.h"
#pragma var_model(mem)
#include "equinoxe-stage.h"

//extern const heap_structure_t* heap_bram_blocked;


extern equinoxe_game_t game;
// volatile extern char buffer[256];
