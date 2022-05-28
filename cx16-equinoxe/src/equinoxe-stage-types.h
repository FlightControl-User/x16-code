#include <cx16-fb.h>
#include <cx16-veralib.h>

#include "levels/equinoxe-level-types.h"


#define STAGES 32
typedef struct {
    fb_heap_handle_t fighter_list;
    fb_heap_handle_t fighter_tail;
    fb_heap_handle_t bullet_tail;
    fb_heap_handle_t bullet_list;
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
    stage_flightpath_t* enemy_flightpath[STAGES];
    unsigned char spawnenemytype;
    
    unsigned int score;
    unsigned int penalty;

    unsigned char lives;
    unsigned char respawn;
} stage_t;
