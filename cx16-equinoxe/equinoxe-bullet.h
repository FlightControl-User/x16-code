#include "equinoxe.h"

typedef struct entity_s Bullet;

void FireBullet(struct entity_s* entity, char reload);
void DrawBullet(heap_handle bullet_handle);
void LogicBullets();
