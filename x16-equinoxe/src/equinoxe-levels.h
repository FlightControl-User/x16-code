#pragma once

// #include "equinoxe-types.h"
#include "equinoxe-level-types.h"
// #include "equinoxe-defines.h"

#pragma data_seg(BRAM_ENGINE_FLIGHT)

// __export volatile sprite_bram_t sprite_t001 = { "t001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_p001 = { "p001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_n001 = { "n001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0101 = { "e0101", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0102 = { "e0102", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0201 = { "e0201", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0202 = { "e0202", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0301 = { "e0301", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0302 = { "e0302", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0401 = { "e0401", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0501 = { "e0501", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0502 = { "e0502", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0601 = { "e0601", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0602 = { "e0602", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0701 = { "e0701", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0702 = { "e0702", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_e0703 = { "e0703", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_b001 = { "b001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_b002 = { "b002", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_b003 = { "b003", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
// __export volatile sprite_bram_t sprite_b004 = { "b004", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };


#define t001 0
#define p001 1
#define n001 2
#define e0701 3
#define e0102 4
#define e0201 5
#define e0202 6
#define e0301 7
#define e0302 8
#define e0401 9
#define e0501 10
#define e0502 11
#define e0601 12
#define e0602 13
#define e0101 14
#define e0702 15
#define e0703 16
#define b001 17
#define b002 18
#define b003 19
#define b004 20

__export sprite_t sprites = {

    {   "t001",  "p001",  "n001",  "e0701", 
        "e0102", "e0201", "e0202", "e0301", 
        "e0302", "e0401", "e0501", "e0502", 
        "e0601", "e0602", "e0101", "e0702", 
        "e0703", "b001", "b002", "b003",
        "b004" 
    }, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}
};


#pragma data_seg(BRAM_ENGINE_FLOOR)

// FLOOR

__export floor_bram_tiles_t mars_bram_01 = { 0, "mars01", 54, 16*16*50, 128, 0 };

__export volatile floor_parts_t mars_parts_01 = {
        { 0 }, { 0 }, { 0 }, { 0 }, { 0 }
};

__export volatile floor_t mars_01 = {
    &mars_parts_01,
    { 0 },  
    {
        00, 00, 00, 00, // 00 - 0000
        29, 30, 09, 33, // 01 - 0001
        31, 32, 34, 35, // 02 - 0010
        00, 00, 25, 26, // 03 - 0011
        00, 40, 43, 44, // 04 - 0100
        13, 14, 17, 18, // 05 - 0101
        52, 47, 53, 54, // 06 - 0110
        21, 22, 27, 28, // 07 - 0111
        41, 42, 45, 46, // 08 - 1000
        48, 49, 50, 51, // 09 - 1001
        11, 12, 15, 16, // 10 - 1010
        19, 20, 23, 24, // 11 - 1011
        03, 04, 00, 00, // 12 - 1100
        05, 06, 09, 10, // 13 - 1101
        01, 02, 07, 08, // 14 - 1110
        36, 37, 38, 39, // 15 - 1111
    },
    {
        00, 00, 00, 00, // 00 - 0000
        00, 00, 02, 00, // 01 - 0001
        00, 00, 00, 01, // 02 - 0010
        00, 00, 03, 03, // 03 - 0011
        00, 04, 00, 00, // 04 - 0100
        00, 04, 00, 02, // 05 - 0101
        00, 05, 00, 05, // 06 - 0110
        00, 05, 03, 07, // 07 - 0111
        08, 00, 00, 00, // 08 - 1000
        10, 00, 10, 00, // 09 - 1001
        08, 00, 00, 01, // 10 - 1010
        10, 00, 11, 03, // 11 - 1011
        12, 12, 00, 00, // 12 - 1100
        14, 12, 10, 00, // 13 - 1101
        12, 13, 00, 05, // 14 - 1110
        15, 15, 15, 15  // 15 - 1111
    },
    0
};

// TOWER

__export floor_bram_tiles_t tower_bram_01 = { 0, "tower01", 16, 16*16*16, 128, 0 };

__export volatile floor_parts_t tower_parts_01 = {
        { 0 }, { 0 }, { 0 }, { 0 }, { 0 }
};

__export volatile floor_t tower_01 = {
    &tower_parts_01,
    { 0 },  
    {
        00, 00, 00, 00, // 00
        01, 02, 05, 06, // 01
        03, 04, 07, 08, // 02
        09, 10, 13, 14, // 03
        11, 12, 15, 16  // 04 
    },
    {
        00, 00, 00, 00, // 00
        01, 02, 03, 04 // 00
    },
    0
};

// TODO: rework to byte level addressing
#define TILE_WEIGHTS 5
tile_weight_t TileWeightDB[TILE_WEIGHTS] = {
    { 1, 4, { 10, 11, 13, 14 } },
    { 1, 2, { 03, 12 } },
    { 1, 2, { 06, 09 } },
    { 1, 6, { 01, 02, 04, 05, 07, 08 } },
    { 15, 1, { 15 } }
};


#pragma data_seg(BRAM_ENGINE_STAGES)

__export volatile stage_bullet_t stage_bullet_fireball = { b002 };
__export volatile stage_bullet_t stage_bullet_vertical_laser = { b003 };

__export volatile stage_enemy_t stage_enemy_e0101 = { e0701, e0701, &stage_bullet_fireball, 8, 0 };
__export volatile stage_enemy_t stage_enemy_e0102 = { e0102, e0102, &stage_bullet_fireball, 8, 0 };
__export volatile stage_enemy_t stage_enemy_e0201 = { e0201, e0201, &stage_bullet_fireball, 8, 0 };
__export volatile stage_enemy_t stage_enemy_e0202 = { e0202, e0202, &stage_bullet_fireball, 8, 0 };
__export volatile stage_enemy_t stage_enemy_e0301 = { e0301, e0301, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0302 = { e0302, e0302, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0401 = { e0401, e0401, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0501 = { e0501, e0501, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0502 = { e0502, e0502, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0601 = { e0601, e0601, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0602 = { e0602, e0602, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0701 = { e0701, e0701, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0702 = { e0702, e0702, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0703 = { e0703, e0703, &stage_bullet_fireball, 8, 1 };

__export volatile stage_engine_t stage_player_engine = { n001 };

__export volatile stage_bullet_t stage_player_bullet = { b001 };

__export volatile stage_player_t stage_player = { p001, &stage_player_engine, &stage_player_bullet };

// const stage_action_move_t     action_move_00                  = { 480+64, 16, 3 };
// const stage_action_move_t     action_move_left_480_01         = { 320+160, 32, 3 };
// const stage_action_move_t     action_move_02                  = { 80, 0, 3 };
// const stage_action_move_t     action_move_right_480_03        = { 320+160, 0, 3 };
// const stage_action_move_t     action_move_04                  = { 768, 32, 4 };
// const stage_action_move_t     action_move_05                  = { 768, 32, 2 };
// const stage_action_move_t     action_move_06                  = { 768, 0, 2 };

// const stage_action_turn_t     action_turn_00                  = { -24, 4, 3 };
// const stage_action_turn_t     action_turn_01                  = { 24, 4, 3 };
// const stage_action_turn_t     action_turn_02                  = { 32, 2, 2 };

// const stage_action_end_t      action_end                      = { 0 };

#define  action_move_00                 { 480+64, 16, 3 }
#define  action_move_left_480_01        { 320+160, 32, 3 }
#define  action_move_02                 { 80, 0, 3 }
#define  action_move_right_480_03       { 320+160, 0, 3 }
#define  action_move_04                 { 768, 32, 4 }
#define  action_move_05                 { 768, 32, 2 }
#define  action_move_06                 { 768, 0, 2 }

#define  action_turn_00                 { -24, 4, 3 }
#define  action_turn_01                 { 24, 4, 3 }
#define  action_turn_02                 { 32, 2, 2 }

#define  action_end                     { 0 }

const stage_flightpath_t action_flightpath_000[] = {
    { { .move = {320, 16, 0} },    STAGE_ACTION_MOVE,         0 }
};

const stage_flightpath_t action_flightpath_001[] = {
    { { .move = action_move_00 },    STAGE_ACTION_MOVE,        1 },
    { { .end = action_end },        STAGE_ACTION_END,         0 }
};

const stage_flightpath_t action_flightpath_left_circle_002[] = {
    { { .move = action_move_left_480_01 },    STAGE_ACTION_MOVE,        1 },
    { { .turn = action_turn_00 },    STAGE_ACTION_TURN,        2 },
    { { .move = action_move_02 },    STAGE_ACTION_MOVE,        1 }
};

const stage_flightpath_t action_flightpath_right_circle_003[] = {
    { { .move = action_move_right_480_03 },    STAGE_ACTION_MOVE,        1 },
    { { .turn = action_turn_01 },    STAGE_ACTION_TURN,        2 },
    { { .move = action_move_02 },    STAGE_ACTION_MOVE,        1 }
};

const stage_flightpath_t action_flightpath_004[] = {
    { { .move = action_move_04 },    STAGE_ACTION_MOVE,        1 },
    { { .end = action_end },        STAGE_ACTION_END,         0 },
};


const stage_flightpath_t action_flightpath_005[] = {
    { { .move = action_move_05 },    STAGE_ACTION_MOVE,        1 },
    { { .end = action_end },        STAGE_ACTION_END,         0 },
};

const stage_flightpath_t action_flightpath_006[] = {
    { { .move = { 768, 0, 2 } },    STAGE_ACTION_MOVE,        1 },
    { { .end = action_end },        STAGE_ACTION_END,         0 },
};

const stage_scenario_t stage_scenario_01_b[32] = {
//    ct, sp, enemy_xxx,            action_flightpath_xxx,                  xstrt,  ystrt,  xinc,   yinc,   ival,   wait,   prv,    fill    
    {  1,  1, &stage_enemy_e0401,   action_flightpath_000,                  320,    160,    0,      0,      4,      10,     255,    0 }, // 0
    {  1,  1, &stage_enemy_e0701,   action_flightpath_000,                  160,    160,    0,      0,      4,      20,     0,      0 }, // 1
    {  1,  1, &stage_enemy_e0702,   action_flightpath_000,                  480,    160,    0,      0,      4,      30,     0,      0 }, // 2
    { 16, 16, &stage_enemy_e0201,   action_flightpath_005,                  704,    32,     0,      0,      14,     20,     2,      0 }, // 3
    { 16, 16, &stage_enemy_e0201,   action_flightpath_006,                  -64,    96,     0,      0,      16,     20,     2,      0 }, // 4
    { 16, 16, &stage_enemy_e0201,   action_flightpath_005,                  704,    160,    0,      0,      18,     20,     2,      0 }, // 5
    {  8,  8, &stage_enemy_e0401,   action_flightpath_006,                  -64,    32,     0,      0,      8,      20,     5,      0 }, // 6
    {  8,  8, &stage_enemy_e0401,   action_flightpath_005,                  704,    96,     0,      0,      8,      20,     5,      0 }, // 7
    {  8,  8, &stage_enemy_e0301,   action_flightpath_006,                  -64,    160,    0,      0,      8,      20,     5,      0 }, // 8
    {  8,  8, &stage_enemy_e0302,   action_flightpath_005,                  704,    224,    0,      0,      8,      20,     8,      0 }, // 9
    {  8,  8, &stage_enemy_e0401,   action_flightpath_006,                  -64,    32,     0,      32,     4,      20,     8,      0 }, // 10
    {  8,  8, &stage_enemy_e0501,   action_flightpath_005,                  704,    32,     0,      32,     2,      20,     10,     0 }, // 11
    {  8,  8, &stage_enemy_e0601,   action_flightpath_006,                  -64,    32,     0,      32,     2,      20,     10,     0 }, // 12
    {  8,  8, &stage_enemy_e0701,   action_flightpath_005,                  704,    32,     0,      32,     6,      20,     12,     0 }, // 13
    {  8,  8, &stage_enemy_e0702,   action_flightpath_006,                  -64,    32,     0,      32,     8,      20,     12,     0 }, // 14
    {  8,  8, &stage_enemy_e0703,   action_flightpath_005,                  704,    32,     0,      32,     10,     20,     12,     0 }, // 15
    {  8,  8, &stage_enemy_e0101,   action_flightpath_left_circle_002,      704,    32,     0,      32,     6,      20,     15,     0 }, // 16
    {  8,  8, &stage_enemy_e0202,   action_flightpath_right_circle_003,     -64,    32,     0,      32,     8,      20,     15,     0 }, // 17
    {  8,  8, &stage_enemy_e0401,   action_flightpath_right_circle_003,     704,    32,     0,      32,     10,     20,     17,     0 }, // 18
    {  8,  8, &stage_enemy_e0401,   action_flightpath_left_circle_002,      704,    32,     0,      32,     10,     20,     17,     0 }  // 19
};

__export volatile stage_floor_bram_tiles_t stage_floor_bram_tiles_01[] = {
    { &mars_bram_01 }, 
};

__export volatile
stage_floor_t stage_floor_01 = {
    1, stage_floor_bram_tiles_01, &mars_01
};

__export volatile stage_floor_bram_tiles_t stage_tower_bram_tiles_01[] = {
    { &tower_bram_01 }
};


__export volatile
stage_tower_t stage_towers_01 = {
    19, stage_tower_bram_tiles_01, &tower_01, t001, 
    16, 16, 8, 8,
    &stage_bullet_vertical_laser
};

// PLAYBOOK

// This models the playbook of all the different levels in the game.
// The embedded level field in the playbook is a pointer to a level composition.
__export volatile stage_playbook_t stage_playbooks_b[] = {
    { 19, stage_scenario_01_b, &stage_player, &stage_floor_01, 1, &stage_towers_01 }
};

__export volatile
stage_script_t stage_script_b = {
    1, stage_playbooks_b
};

#pragma data_seg(Data)

