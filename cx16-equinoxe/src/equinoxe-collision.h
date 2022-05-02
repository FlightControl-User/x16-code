
#ifndef collision_h
#define collision_h

#include "equinoxe-types.h"
#include "equinoxe-flightengine.h"
#include "ht.h"

// #pragma data_seg(Hash)
ht_item_t ht_collision;

#pragma data_seg(Data)

ht_key_t grid_key(unsigned char group, unsigned char gx, unsigned char gy);
void grid_insert(ht_item_t* ht, unsigned char group, unsigned char x, unsigned char y, ht_data_t data);

#endif
