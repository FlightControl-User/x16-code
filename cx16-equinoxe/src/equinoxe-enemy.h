#include "equinoxe-types.h"

#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"
#include "equinoxe-stage.h"

extern fe_enemy_t enemy;

void enemy_init();
unsigned char AddEnemy(sprite_t* sprite, stage_flightpath_t* flights); 
unsigned char HitEnemy(unsigned char e, unsigned char b);
unsigned char RemoveEnemy(unsigned char e);

void LogicEnemies();
