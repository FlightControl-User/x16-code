#include "equinoxe-types.h"
#include "equinoxe-collision-types.h"
#include "ht.h"

#define COLLISION_PLAYER   (0x00)
#define COLLISION_ENEMY    (0x40)
#define COLLISION_TOWER    (0x80)
#define COLLISION_BULLET   (0xC0)
#define COLLISION_MASK     (0xC0)

#pragma data_seg(hash)
extern ht_item_t collision_hash;
extern collision_quadrant_t collision_quadrant; 

#pragma data_seg(Data)
ht_key_t collision_key(unsigned char gx, unsigned char gy);
void collision_init();
void collision_insert(unsigned char x, unsigned char y, ht_data_t data);
unsigned char collision_count(unsigned char x, unsigned char y);
unsigned char collision_data(unsigned char collision, collision_decision_t *collision_decision);
inline void collision_debug();
