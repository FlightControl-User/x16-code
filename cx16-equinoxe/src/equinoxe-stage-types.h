#ifndef equinoxe_stage_types_h
#define equinoxe_stage_types_h

#include "equinoxe-types.h"
#include "equinoxe-flightengine-types.h"
#include "equinoxe-enemy-types.h"

#define STAGES 2
typedef struct {
    heap_handle fighter_list;
    heap_handle fighter_tail;
    heap_handle bullet_tail;
    heap_handle bullet_list;
    vera_sprite_id sprite_player; // Keep track of the last player sprite allocated.
    unsigned char sprite_player_count;
    vera_sprite_id sprite_bullet; // Keep track of the last bullet sprite allocated.
    unsigned char sprite_bullet_count;
    vera_sprite_id sprite_enemy;  // Keep track of the last enemy sprite allocated.
    unsigned char sprite_enemy_count;
    unsigned char level;
    unsigned char step;
    unsigned char steps;
    unsigned char phase;
    unsigned char enemy_count[STAGES];
    unsigned char enemy_spawn[STAGES];
    sprite_t* enemy_sprite[STAGES];
    enemy_flightpath_t* enemy_flightpath[STAGES];
    unsigned char spawnenemytype;
    
    unsigned int score;
    unsigned int penalty;

    unsigned char lives;
    unsigned char respawn;
} stage_t;

#endif