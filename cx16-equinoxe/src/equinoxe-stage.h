#ifndef equinoxe_stage_h
#define equinoxe_stage_h

#include "equinoxe-types.h"

extern stage_t stage;

void StageInit();
void StageReset();

vera_sprite_offset NextOffset(vera_sprite_id sprite_start, vera_sprite_id sprite_end, vera_sprite_id* sprite_id, unsigned char* count);
void FreeOffset(vera_sprite_offset sprite_offset, unsigned char* count);

inline void StageAddEnemy(sprite_t* sprite, enemy_flightpath_t* flights);
inline void StageHitEnemy(unsigned char e, unsigned char b);
inline void StageRemoveEnemy(unsigned char e);
void LogicStage();

#endif