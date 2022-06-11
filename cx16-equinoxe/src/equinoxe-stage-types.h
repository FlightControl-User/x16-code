#include <cx16-fb.h>
#include <cx16-veralib.h>

#include "levels/equinoxe-level-types.h"


typedef struct {
    unsigned char enemy_count; // Temporary that holds the total amount of enemies in a scenario.
    unsigned char enemy_spawn; // Temporary that holds the amount of enemies that can be spawned at the same time.
    sprite_bram_t* enemy_sprite; // Temporary that holds the sprite of the enemy to be spawned.
    stage_flightpath_t* enemy_flightpath; // Temporary that holds the flight path of the enemy to be followed.
    signed int x;
    signed int y;
    signed char dx;
    signed char dy;
    unsigned char interval;
    unsigned char wait;
    unsigned char prev;
    unsigned char used;
    unsigned char finished;
    unsigned int scenario;
} stage_wave_t;


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

    stage_script_t script;

    unsigned int ew; // Wave indicator which administers the start and delta positions of each enemy new spawn.

    unsigned int playbook;
    unsigned int scenario;
    unsigned int scenarios; // Total amount of scenarios in current playbook.

    unsigned int score;
    unsigned int penalty;

    unsigned char lives;
    unsigned char respawn;

    unsigned char enemy_xor;
    unsigned char player_xor;
} stage_t;

