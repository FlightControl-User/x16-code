#pragma once

// #include <cx16-typedefs.h>
// #include <ht-typedefs.h>
// #include <fp3-typedefs.h>
// #include <cx16-bramheap-lib.h>
// #include <cx16-veralib.h>
// #include <cx16-veraheap-typedefs.h>

#include "cx16-bramheap-typedefs.h"
#include "cx16-veraheap-typedefs.h"
#include "equinoxe-bank.h"
#include "equinoxe-palette-types.h"
#include "equinoxe-flightengine-types.h"
#include "equinoxe-floorengine-types.h"
#include "equinoxe-tower-types.h"
#include "equinoxe-enemy-types.h"
#include "equinoxe-tower-types.h"
#include "equinoxe-bullet-types.h"
#include "equinoxe-stage-types.h"


// Side constants to determine the coalition.
const byte SIDE_PLAYER = 0;
const byte SIDE_ENEMY = 1;



// FLOOR


// SPRITES



typedef struct {
    unsigned char layers;
    unsigned char ticksync;
    unsigned char tickstage;
    unsigned int  screen_vscroll;
    unsigned char row;                          ///< Current row in the scroll of the background scenery.
    unsigned char tower_frequency;              ///< Frequency of the tower occurance in tower space.
    unsigned char scroll_wait;                  ///< Remaining wait cycles to scroll the background scenery.
    unsigned char scroll_speed;                 ///< Speed in wait cycles to scroll the background scenery.
    unsigned char floor_border;
    unsigned char floor_empty;
    unsigned char floor_ticks;
    unsigned char floor_interval;
    signed char delta_border;
    signed char delta_empty;
} equinoxe_game_t;




#pragma data_seg(Data)
