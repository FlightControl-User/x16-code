#include "equinoxe-types.h"

#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"
#include "equinoxe-stage.h"

extern fe_enemy_t enemy;

void enemy_init();
unsigned char enemy_add(unsigned char w, sprite_index_t enemy_sprite); 
unsigned char enemy_hit(unsigned char e, unsigned char b);
void enemy_remove(unsigned char e);

void enemy_logic();
void enemy_animate();

unsigned char enemy_get_wave(unsigned char e);

inline void enemy_bank();
inline void enemy_unbank();


