#ifndef equinoxe_bullet_h
#define equinoxe_bullet_h

#include "equinoxe-types.h"
#include "equinoxe-flightengine.h"


void bullet_init();
void FireBullet(unsigned char p, char reload);

void FireBulletEnemy(unsigned char e);
void FireBulletTower(unsigned char t);

void bullet_remove(unsigned char b); 

void LogicBullets();

#endif