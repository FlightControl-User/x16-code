
#ifndef collision_h
#define collision_h

#include "equinoxe-types.h"
#include "equinoxe-flightengine.h"
#include "ht.h"

#define COLLISION_PLAYER   (0x00)
#define COLLISION_ENEMY    (0x40)
#define COLLISION_TOWER    (0x80)
#define COLLISION_BULLET   (0xC0)
#define COLLISION_MASK     (0xC0)

// #pragma data_seg(Hash)
ht_item_t ht_collision;

#pragma data_seg(Data)

ht_key_t collision_key(unsigned char gx, unsigned char gy);
void collision_insert(ht_item_t* ht, unsigned char x, unsigned char y, ht_data_t data);

#endif
