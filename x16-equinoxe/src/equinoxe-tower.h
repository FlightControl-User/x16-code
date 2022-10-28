
#include "equinoxe-flightengine-types.h"

#define TOWERS_TOTAL 8

extern tower_t towers;

void tower_move();
void tower_logic();
void tower_animate();
unsigned char tower_remove(unsigned char t);
unsigned char tower_add( 
    sprite_bram_t* turret, 
    unsigned char x, 
    unsigned char y,
    signed int tx,
    signed int ty,
    signed char fx,
    signed char fy,
    unsigned char anim_speed, 
    unsigned char palette_index );
void tower_paint(unsigned char tile_row, unsigned char tile_column);
