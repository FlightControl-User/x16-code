
#ifndef collision_h
#define collision_h

#include "equinoxe-flightengine.h"

void grid_remove(entity_t* entity);
unsigned char grid_insert(entity_t* entity, unsigned int x, unsigned int y, unsigned int data);

#endif
