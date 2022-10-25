#include "equinoxe-types.h"

#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"
#include "equinoxe-stage.h"

extern fe_enemy_t enemy;

void enemy_init();
unsigned char enemy_add(unsigned char w); 
unsigned char enemy_hit(unsigned char e, unsigned char b);
unsigned char enemy_remove(unsigned char e);

void enemy_logic();
void enemy_animate();

