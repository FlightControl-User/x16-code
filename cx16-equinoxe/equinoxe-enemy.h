#include <cx16-heap.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"

typedef struct entity_s Enemy;

void AddEnemy(char t, signed int x, signed int y);

unsigned char SpawnEnemies(unsigned char t, signed int x, signed int y);

void LogicEnemies();
