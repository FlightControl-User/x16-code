#include "ht.h"
#include "equinoxe-collision-types.h"

#pragma data_seg(hash)
extern ht_item_t collision_hash;
extern collision_quadrant_t collision_quadrant; 

#pragma data_seg(Data)
ht_key_t collision_key(unsigned char gx, unsigned char gy);
void collision_init();
void collision_insert(flight_index_t f);
unsigned char collision_count(unsigned char x, unsigned char y);
unsigned char collision_data(unsigned char collision, collision_decision_t *collision_decision);
// inline void collision_debug();
