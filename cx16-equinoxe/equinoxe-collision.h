
#ifndef collision_h
#define collision_h

#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "ht.h"

ht_size_t ht_size_collision = 128;
volatile ht_item_t *ht_collision = (ht_item_t *)0xA000;

void grid_reset(ht_item_ptr_t ht, ht_size_t ht_size);
void grid_init(ht_item_ptr_t ht, ht_size_t ht_size);

ht_key_t grid_key(unsigned char group, unsigned char gx, unsigned char gy);
void grid_insert(entity_t* entity, unsigned char group, unsigned char x, unsigned char y, heap_handle data);

#endif
