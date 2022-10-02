#include <cx16-heap-bram-fb.h>
#include <cx16-veralib.h>

#include "levels/equinoxe-level-types.h"

#define WAVES 8
typedef struct {
    unsigned char enemy_count[WAVES]; // Temporary that holds the total amount of enemies in a scenario.
    unsigned char enemy_spawn[WAVES]; // Temporary that holds the amount of enemies that can be spawned at the same time.
    sprite_bram_t* enemy_sprite[WAVES]; // Temporary that holds the sprite of the enemy to be spawned.
    stage_flightpath_t* enemy_flightpath[WAVES]; // Temporary that holds the flight path of the enemy to be followed.
    signed int x[WAVES];
    signed int y[WAVES];
    signed char dx[WAVES];
    signed char dy[WAVES];
    unsigned char interval[WAVES];
    unsigned char wait[WAVES];
    unsigned char prev[WAVES];
    unsigned char used[WAVES];
    unsigned char finished[WAVES];
    unsigned int scenario[WAVES];
} stage_wave_t;


#define STAGES 32
typedef struct {
    heap_bram_fb_handle_t fighter_list;
    heap_bram_fb_handle_t fighter_tail;
    heap_bram_fb_handle_t bullet_tail;
    heap_bram_fb_handle_t bullet_list;
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

