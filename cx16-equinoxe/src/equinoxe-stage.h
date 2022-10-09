#include "equinoxe-types.h"

extern stage_t stage;

void stage_init();
void stage_reset();


inline void stage_enemy_add(unsigned char w, sprite_bram_t* sprite, stage_flightpath_t* flights);
inline void stage_enemy_hit(unsigned char w, unsigned char e, unsigned char b);
inline void stage_enemy_remove(unsigned char w, unsigned char e);
void stage_logic();
