

#include "equinoxe.h"
// #include "equinoxe-types.h"

void player_init();
void player_add(sprite_index_t sprite_player, sprite_index_t sprite_engine);
void player_remove(unsigned char p);
void player_hit(unsigned char p, signed char impact);
void player_logic();

// unbanked

void player_bank();
void player_unbank();
