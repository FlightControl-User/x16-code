#include "../equinoxe-flightengine-types.h"
#include "../equinoxe-floorengine-types.h"
#include "cx16-veraheap-typedefs.h"

typedef struct {
    char file[16];
} stage_file_t;

typedef struct {
    sprite_bram_t* engine_sprite;
} stage_engine_t;

typedef struct {
    sprite_bram_t* bullet_sprite;
} stage_bullet_t;

typedef struct {
    sprite_bram_t* player_sprite;
    stage_engine_t* stage_engine;
    stage_bullet_t* stage_bullet; 
} stage_player_t;

typedef struct {
    sprite_bram_t* enemy_sprite_flight;
    sprite_bram_t* enemy_sprite_shoot;
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
} stage_action_t;

typedef struct {
    void* action;
    unsigned char type;
    unsigned char next;
} stage_flightpath_t;


typedef struct {
    unsigned char enemy_count;
    unsigned char enemy_spawn;
    stage_enemy_t* stage_enemy;
    stage_flightpath_t* enemy_flightpath;
    signed int x;
    signed int y;
    signed char dx;
    signed char dy;
    unsigned char interval;
    unsigned char wait;
    unsigned char prev;
} stage_scenario_t;

typedef struct {
    floor_bram_tiles_t* floor_bram_tile;
} stage_floor_bram_tiles_t;

#define STAGE_FLOOR_FILE_COUNT 3
typedef struct {
    unsigned char floor_file_count;
    stage_floor_bram_tiles_t* floor_bram_tiles;
    floor_t* floor;
} stage_floor_t;

typedef struct {
    unsigned char scenario_count;
    stage_scenario_t* scenarios;
    stage_player_t* stage_player;
    stage_floor_t* stage_floor;
} stage_playbook_t;

typedef struct {
    unsigned char playbooks;
    stage_playbook_t* playbook;
} stage_script_t;

enum STAGE_ACTION {
    STAGE_ACTION_INIT = 0,
    STAGE_ACTION_START = 1,
    STAGE_ACTION_MOVE = 2,
    STAGE_ACTION_TURN = 3,
    STAGE_ACTION_END = 255
};
