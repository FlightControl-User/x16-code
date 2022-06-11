#include "equinoxe.h"

#ifdef __PLAYER

#include "equinoxe-types.h"

extern fe_player_t player;
extern fe_engine_t engine;

void player_init();
void player_add();
void player_remove(unsigned char p, unsigned char b);
void player_logic();

#endif