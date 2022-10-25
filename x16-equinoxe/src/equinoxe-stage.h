#include "equinoxe-types.h"

extern stage_t stage;
extern stage_wave_t wave;

void stage_reset();

stage_tower_t* stage_tower_get();

inline void stage_enemy_add(unsigned char w);
inline void stage_enemy_hit(unsigned char w, unsigned char e, unsigned char b);
inline void stage_enemy_remove(unsigned char w, unsigned char e);
void stage_logic();
