

#include "equinoxe.h"

// #include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"
#include "equinoxe-stage.h"

void enemy_init();
unsigned char enemy_add(unsigned char w, sprite_index_t enemy_sprite); 
void enemy_remove(unsigned char e);

void enemy_logic();

unsigned char enemy_get_wave(unsigned char e);

// unbanked

void enemy_bank();
void enemy_unbank();

