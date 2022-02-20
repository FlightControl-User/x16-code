
#ifndef collision_h
#define collision_h

#include "equinoxe.h"
#include "equinoxe-flightengine.h"

ht_size_t ht_size_collision = 512;
ht_item_t ht_collision[512];

typedef struct grid_s {
    unsigned char entities[10*8];
    unsigned char columns[10];
    unsigned char rows[10][8];
} grid_t;

grid_t grid;

void grid_remove(entity_t* entity);
unsigned char grid_insert(entity_t* entity, unsigned int x, unsigned int y, unsigned int data);

#endif
