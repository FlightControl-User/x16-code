#ifndef __EQUINOXE_TYPES_H
#define __EQUINOXE_TYPES_H

#include <cx16.h>
#include <string.h>
#include <ht.h>
#include <fp3.h>
#include <cx16-heap-bram-fb.h>
#include <cx16-veralib.h>
#include <cx16-veraheap-typedefs.h>

#include "equinoxe-bank.h"
#include "equinoxe-palette-types.h"
#include "equinoxe-flightengine-types.h"
#include "equinoxe-floorengine-types.h"
#include "equinoxe-enemy-types.h"
#include "equinoxe-bullet-types.h"


// sprite_bram_t constants
const unsigned char SPRITE_OFFSET_PLAYER_START = 1;
const unsigned char SPRITE_OFFSET_PLAYER_END = 4;
const unsigned char SPRITE_OFFSET_ENEMY_START = 5;
const unsigned char SPRITE_OFFSET_ENEMY_END = 63;
const unsigned char SPRITE_OFFSET_BULLET_START = 64;
const unsigned char SPRITE_OFFSET_BULLET_END = 95;

// Side constants to determine the coalition.
const byte SIDE_PLAYER = 0;
const byte SIDE_ENEMY = 1;



// FLOOR


// SPRITES



struct sprite_bullet {
    byte active;
    signed int x;
    signed int y;
    signed char dx;
    signed char dy;
    byte energy;
};

typedef struct {
    void (*Logic)(void);
    void (*Draw)(void);
} Delegate;



typedef struct {
	Delegate delegate;
    unsigned char ticksync;
    unsigned char tickstage;
} equinoxe_game_t;




#pragma data_seg(Data)

#endif