#ifndef equinoxe_bullet_h
#define equinoxe_bullet_h

#include "equinoxe-types.h"
#include "equinoxe-flightengine.h"


void bullet_init();
void bullet_player_fire(unsigned int x, unsigned int y);

void bullet_enemy_fire(unsigned int x, unsigned int y);
void FireBulletTower(unsigned char t);

void bullet_remove(unsigned char b); 

void bullet_logic();

// Unbanked functions

signed char bullet_impact(unsigned char b);
void bullet_bank();
void bullet_unbank();

unsigned char bullet_has_collided(unsigned char b);

#endif