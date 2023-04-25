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
#include "equinoxe-bullet-types.h"
#include "equinoxe-stage-types.h"


// Side constants to determine the coalition.
const byte SIDE_PLAYER = 0;
const byte SIDE_ENEMY = 1;



// FLOOR


// SPRITES



typedef struct {
    unsigned char ticksync;
    unsigned char tickstage;
    unsigned int  screen_vscroll;
    unsigned char screen_vscroll_wait;
    unsigned char row;

} equinoxe_game_t;




#pragma data_seg(Data)
