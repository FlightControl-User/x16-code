

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


#pragma var_model(zp)

#include <ht.h>
#include <lib-lru-cache_asm.h>

#include "equinoxe-types.h"
#include "equinoxe-bank.h"
#include "equinoxe-defines.h"

#define BRAM_HEAP_SEGMENTS 2
#include <lib-bramheap_asm.h>

// #pragma bank(cx16_ram, BANK_VERA_HEAP)
#include <lib-veraheap_asm.h>
// #pragma nobank

#include "lib-palette_asm.h"
#include "lib-animate_asm.h"

#define VERA_HEAP_SEGMENT_TILES     (vera_heap_segment_index_t)0
#define VERA_HEAP_SEGMENT_SPRITES   (vera_heap_segment_index_t)1

#include "equinoxe-math.h"
#include "equinoxe-levels.h"

#pragma var_model(mem)
#include "equinoxe-flightengine.h"

#ifdef __FLOOR
#include "equinoxe-floorengine.h"
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
