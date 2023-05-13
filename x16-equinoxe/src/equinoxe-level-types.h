#pragma once

#include "equinoxe-flightengine-types.h"
#include "equinoxe-floorengine-types.h"
#include "cx16-veraheap-typedefs.h"

typedef struct {
    char file[16];
} stage_file_t;

typedef struct {
    sprite_index_t engine_sprite;
} stage_engine_t;

typedef struct {
    sprite_index_t bullet_sprite;
} stage_bullet_t;

typedef struct {
    sprite_index_t player_sprite;
    stage_engine_t* stage_engine;
    stage_bullet_t* stage_bullet; 
} stage_player_t;

typedef struct {
    sprite_index_t enemy_sprite_flight;
    sprite_index_t enemy_sprite_shoot;
    stage_bullet_t* stage_bullet; 
    unsigned char animation_speed;
    unsigned char animation_reverse;
} stage_enemy_t;

typedef struct {
     unsigned int flight;
     signed char turn;
     unsigned char speed;
} stage_action_move_t;

typedef struct {
     signed char turn;
     unsigned char radius;
     unsigned char speed;
} stage_action_turn_t;

typedef struct {
     unsigned char explode;
} stage_action_end_t;

typedef union {
    stage_action_move_t move;
    stage_action_turn_t turn;
    stage_action_end_t end;
} stage_action_t;

typedef struct {
    stage_action_t action;
    unsigned char type;
    unsigned char next;
} stage_flightpath_t;

typedef unsigned int stage_scenario_index_t;
typedef struct {
    unsigned char enemy_count;                      // 01
    unsigned char enemy_spawn;                      // 02
    stage_enemy_t* stage_enemy;                     // 04
    stage_flightpath_t* enemy_flightpath;           // 06 
    signed int x;                                   // 08
    signed int y;                                   // 10
    signed char dx;                                 // 11
    signed char dy;                                 // 12
    unsigned char interval;                         // 13
    unsigned char wait;                             // 14
    unsigned char prev;                             // 15
    unsigned char dummy;                            // 16
} stage_scenario_t;

typedef struct {
    floor_bram_tiles_t* floor_bram_tile;            // 02
} stage_floor_bram_tiles_t;

#define STAGE_FLOOR_FILE_COUNT 3
typedef struct {
    unsigned char floor_file_count;
    stage_floor_bram_tiles_t* floor_bram_tiles;
    floor_t* floor;
} stage_floor_t;

typedef struct {
    unsigned char tower_file_count;
    stage_floor_bram_tiles_t* tower_bram_tiles;
    floor_t* towers;
    sprite_index_t turret;
    unsigned char turret_x; ///< x pixels to be added to position the turret on the tower.
    unsigned char turret_y; ///< y pixels to be added to position the turret on the tower.
    unsigned char fire_x; ///< x pixels to be added for the fire position of the bullets on the tower.
    unsigned char fire_y; ///< x pixels to be added for the fire position of the bullets on the tower.
    stage_bullet_t* stage_bullet;
} stage_tower_t;

typedef struct {
    unsigned char scenario_total_b;                     // 1
    stage_scenario_t* scenarios_b;                      // 3
    stage_player_t* stage_player;                       // 5
    stage_floor_t* stage_floor;                         // 7
    unsigned char tower_count;                          // 8
    stage_tower_t* stage_towers;                        // 10

} stage_playbook_t;
typedef struct {
    unsigned char playbook_total_b;
    stage_playbook_t* playbooks_b;
} stage_script_t;

enum STAGE_ACTION {
    STAGE_ACTION_INIT = 0,
    STAGE_ACTION_START = 1,
    STAGE_ACTION_MOVE = 2,
    STAGE_ACTION_TURN = 3,
    STAGE_ACTION_END = 255
};
