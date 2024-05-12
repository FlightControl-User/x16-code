#pragma once

#include "equinoxe-level-types.h"
#include "equinoxe-types.h"

#define STAGES 32
typedef struct {
    stage_playbook_t current_playbook;

    bram_heap_handle_t fighter_list;
    bram_heap_handle_t fighter_tail;
    bram_heap_handle_t bullet_tail;
    bram_heap_handle_t bullet_list;

    vera_sprite_id sprite_pool; // Keep track of the last sprite allocated.
    unsigned char  sprite_count;

    unsigned char player;
    unsigned char bullet_count;
    unsigned char player_count;
    unsigned char enemy_count;
    unsigned char tower_count;

    stage_script_t script_b;

    unsigned int ew; // Wave indicator which administers the start and delta positions of each enemy new spawn.

    unsigned int playbook_current;
    unsigned int scenario_current;
    unsigned int scenario_total; // Total amount of scenarios in current playbook.

    stage_floor_t stage_floor;

    unsigned int sprite_offset;
    unsigned char palette;
    unsigned char palette_count;

    unsigned char tower_pool;

    unsigned char animate_pool;
    unsigned char animate_count;

    floor_t* floor;
    floor_t* towers;


    unsigned int score;
    unsigned int penalty;

    unsigned char lives;
    unsigned char player_respawn;

    unsigned char enemy_xor;
    unsigned char player_xor;
} stage_t;

