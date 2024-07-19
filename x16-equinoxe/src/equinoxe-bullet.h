

#include "equinoxe-types.h"
// #include "equinoxe-flightengine.h"

#ifdef __BULLET

void bullet_init();
flight_index_t bullet_add(unsigned int sx, unsigned int sy, unsigned int tx, unsigned int ty, unsigned char speed, flight_side_t side, sprite_index_t sprite_bullet);

/*void FireBulletTower(unsigned char t);*/

void bullet_logic();

// Unbanked functions

void bullet_bank();
void bullet_unbank();

#endif