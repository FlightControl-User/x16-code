
#ifndef collision_h
#define collision_h

#include "equinoxe.h"
#include "equinoxe-flightengine.h"

ht_size_t ht_size_collision = 512;
ht_item_t ht_collision[512];


void grid_remove(entity_t* entity);
unsigned char grid_insert(entity_t* entity, unsigned int x, unsigned int y, unsigned int data);

#endif
