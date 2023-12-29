

#include "equinoxe.h"

#ifdef __TOWER

#define TOWERS_TOTAL 8

void tower_move();
void tower_logic();
flight_index_t tower_add( 
    sprite_index_t turret, 
    unsigned int tx,
    unsigned int ty,
    unsigned char fx,
    unsigned char fy);
void tower_remove(flight_index_t t);
void tower_paint(unsigned char column, unsigned char row);

#endif