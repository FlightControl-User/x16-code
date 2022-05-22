#ifndef equinoxe_player_h
#define equinoxe_player_h

#include "equinoxe-types.h"

extern fe_player_t player;
extern fe_engine_t engine;

void player_init();
void InitPlayer();
void RemovePlayer(unsigned char p, unsigned char b);
void LogicPlayer();

#endif