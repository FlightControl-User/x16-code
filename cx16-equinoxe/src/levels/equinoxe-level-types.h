#include "../equinoxe-flightengine-types.h"
#include "cx16-veraheap-typedefs.h"

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
    sprite_bram_t* enemy_sprite;
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
    unsigned char scenarios;
    stage_scenario_t* scenario;
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
