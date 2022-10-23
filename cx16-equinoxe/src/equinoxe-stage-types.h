#include <cx16-heap-bram-fb.h>
#include <cx16-veralib.h>

#include "equinoxe-level-types.h"
#include "equinoxe-types.h"

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
    unsigned char animation_speed[WAVES];
    unsigned char animation_reverse[WAVES];
} stage_wave_t;


#define STAGES 32
typedef struct {
    heap_bram_fb_handle_t fighter_list;
    heap_bram_fb_handle_t fighter_tail;
    heap_bram_fb_handle_t bullet_tail;
    heap_bram_fb_handle_t bullet_list;

    vera_sprite_id sprite_pool; // Keep track of the last sprite allocated.
    unsigned char  sprite_count;

    unsigned char bullet_count;
    unsigned char player_count;
    unsigned char enemy_count;
    unsigned char tower_count;

    stage_script_t script;

    unsigned int ew; // Wave indicator which administers the start and delta positions of each enemy new spawn.

    unsigned int playbook;
    stage_playbook_t current_playbook;
    unsigned int scenario;
    unsigned int scenarios; // Total amount of scenarios in current playbook.

    stage_floor_t stage_floor;

    unsigned int sprite_offset;
    unsigned char palette;
    unsigned char palette_count;

    unsigned char enemy_pool;
    unsigned char player_pool;
    unsigned char engine_pool;
    unsigned char bullet_pool;
    unsigned char tower_pool;
    unsigned char sprite_cache_pool;
    
    floor_t* floor;
    floor_t* towers;


    unsigned int score;
    unsigned int penalty;

    unsigned char lives;
    unsigned char respawn;

    unsigned char enemy_xor;
    unsigned char player_xor;
} stage_t;

