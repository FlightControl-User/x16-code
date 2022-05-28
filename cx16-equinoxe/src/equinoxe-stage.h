#ifndef equinoxe_stage_h
#define equinoxe_stage_h

#include "equinoxe-types.h"

extern stage_t stage;

void stage_init(bram_bank_t bram_bank);
void stage_reset();

vera_sprite_offset NextOffset(vera_sprite_id sprite_start, vera_sprite_id sprite_end, vera_sprite_id* sprite_id, unsigned char* count);
void FreeOffset(vera_sprite_offset sprite_offset, unsigned char* count);

inline void stage_enemy_add(sprite_t* sprite, stage_flightpath_t* flights);
inline void stage_enemy_hit(unsigned char e, unsigned char b);
inline void stage_enemy_remove(unsigned char e);
void stage_logic();

#endif