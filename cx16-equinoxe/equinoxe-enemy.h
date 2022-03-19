#ifndef equinoxe_enemy_h
#define equinoxe_enemy_h

#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"

typedef struct entity_s Enemy;



void AddEnemy(char t, unsigned int x, unsigned int y);

unsigned char SpawnEnemies(unsigned char t, unsigned int x, unsigned int y);

void LogicEnemies();

#endif
