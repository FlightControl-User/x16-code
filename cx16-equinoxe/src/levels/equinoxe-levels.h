#include "../equinoxe-flightengine-types.h"
#include "equinoxe-level-types.h"

#pragma data_seg(spritecontrol)

__export volatile sprite_bram_handles_t sprite_bram_handles[2048];

__export volatile sprite_bram_t sprite_p001 = { "p001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_n001 = { "n001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0101 = { "e0101", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0102 = { "e0102", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0201 = { "e0201", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0202 = { "e0202", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0301 = { "e0301", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0302 = { "e0302", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0401 = { "e0401", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0501 = { "e0501", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0502 = { "e0502", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0601 = { "e0601", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0602 = { "e0602", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0701 = { "e0701", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0702 = { "e0702", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_e0703 = { "e0703", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_b001 = { "b001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_b002 = { "b002", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_b003 = { "b003", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };
__export volatile sprite_bram_t sprite_b004 = { "b004", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0 };


#pragma data_seg(levels)

__export volatile stage_bullet_t stage_bullet_fireball = { &sprite_b002 };

__export volatile stage_enemy_t stage_enemy_e0101 = { &sprite_e0101, &sprite_e0101, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0102 = { &sprite_e0102, &sprite_e0102, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0201 = { &sprite_e0201, &sprite_e0201, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0202 = { &sprite_e0202, &sprite_e0202, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0301 = { &sprite_e0301, &sprite_e0301, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0302 = { &sprite_e0302, &sprite_e0302, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0401 = { &sprite_e0401, &sprite_e0401, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0501 = { &sprite_e0501, &sprite_e0501, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0502 = { &sprite_e0502, &sprite_e0502, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0601 = { &sprite_e0601, &sprite_e0601, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0602 = { &sprite_e0602, &sprite_e0602, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0701 = { &sprite_e0701, &sprite_e0701, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0702 = { &sprite_e0702, &sprite_e0702, &stage_bullet_fireball, 8, 1 };
__export volatile stage_enemy_t stage_enemy_e0703 = { &sprite_e0703, &sprite_e0703, &stage_bullet_fireball, 8, 1 };

__export volatile stage_engine_t stage_player_engine = { &sprite_n001 };

__export volatile stage_bullet_t stage_player_bullet = { &sprite_b001 };

__export volatile stage_player_t stage_player = { &sprite_p001, &stage_player_engine, &stage_player_bullet };

stage_action_move_t     action_move_00      = { 480+64, 16, 3 };
stage_action_move_t     action_move_left_480_01      = { 320+160, 32, 3 };
stage_action_move_t     action_move_02      = { 80, 0, 3 };
stage_action_move_t     action_move_right_480_03      = { 320+160, 0, 3 };
stage_action_move_t     action_move_04      = { 768, 32, 4 };
stage_action_move_t     action_move_05      = { 768, 32, 2 };
stage_action_move_t     action_move_06      = { 768, 0, 2 };

stage_action_turn_t     action_turn_00      = { -24, 4, 3 };
stage_action_turn_t     action_turn_01      = { 24, 4, 3 };
stage_action_turn_t     action_turn_02      = { 32, 2, 2 };

stage_action_end_t      action_end          = { 0 };

__export volatile
stage_flightpath_t action_flightpath_001[] = {
    { &action_move_00,    STAGE_ACTION_MOVE,        1 },
    { &action_end,        STAGE_ACTION_END,         0 }
};

__export volatile
stage_flightpath_t action_flightpath_left_circle_002[] = {
    { &action_move_left_480_01,    STAGE_ACTION_MOVE,        1 },
    { &action_turn_00,    STAGE_ACTION_TURN,        2 },
    { &action_move_02,    STAGE_ACTION_MOVE,        1 }
};

__export volatile
stage_flightpath_t action_flightpath_right_circle_003[] = {
    { &action_move_right_480_03,    STAGE_ACTION_MOVE,        1 },
    { &action_turn_01,    STAGE_ACTION_TURN,        2 },
    { &action_move_02,    STAGE_ACTION_MOVE,        1 }
};

__export volatile
stage_flightpath_t action_flightpath_004[] = {
    { &action_move_04,    STAGE_ACTION_MOVE,        1 },
    { &action_end,        STAGE_ACTION_END,         0 },
};


__export volatile
stage_flightpath_t action_flightpath_005[] = {
    { &action_move_05,    STAGE_ACTION_MOVE,        1 },
    { &action_end,        STAGE_ACTION_END,         0 },
};

__export volatile
stage_flightpath_t action_flightpath_006[] = {
    { &action_move_06,    STAGE_ACTION_MOVE,        1 },
    { &action_end,        STAGE_ACTION_END,         0 },
};

__export volatile
stage_scenario_t stage_level_01[32] = {
//    ct, sp, &sprite_enemy_xxx, action_flightpath_xxx,                                 xstrt, ystrt, xinc, yinc, ival, wait, prev    
    { 16, 16, &stage_enemy_e0101, action_flightpath_006,                                  -64,    32,    0,    0,    4,    0,  255 }, // 0
    { 16, 16, &stage_enemy_e0101, action_flightpath_005,                                  704,    96,    0,    0,    4,   20,    0 }, // 1
    { 16, 16, &stage_enemy_e0102, action_flightpath_006,                                  -64,   160,    0,    0,   12,   20,    0 }, // 2
    { 16, 16, &stage_enemy_e0201, action_flightpath_005,                                  704,    32,    0,    0,   14,   20,    2 }, // 3
    { 16, 16, &stage_enemy_e0202, action_flightpath_006,                                  -64,    96,    0,    0,   16,   20,    2 }, // 4
    { 16, 16, &stage_enemy_e0201, action_flightpath_005,                                  704,   160,    0,    0,   18,   20,    2 }, // 5
    {  8,  8, &stage_enemy_e0301, action_flightpath_006,                                  -64,    32,    0,    0,    8,   20,    5 }, // 6
    {  8,  8, &stage_enemy_e0302, action_flightpath_005,                                  704,    96,    0,    0,    8,   20,    5 }, // 7
    {  8,  8, &stage_enemy_e0301, action_flightpath_006,                                  -64,   160,    0,    0,    8,   20,    5 }, // 8
    {  8,  8, &stage_enemy_e0302, action_flightpath_005,                                  704,   224,    0,    0,    8,   20,    8 }, // 9
    {  8,  8, &stage_enemy_e0401, action_flightpath_006,                                  -64,    32,    0,   32,    4,   20,    8 }, // 10
    {  8,  8, &stage_enemy_e0501, action_flightpath_005,                                  704,    32,    0,   32,    2,   20,   10 }, // 11
    {  8,  8, &stage_enemy_e0601, action_flightpath_006,                                  -64,    32,    0,   32,    2,   20,   10 }, // 12
    {  8,  8, &stage_enemy_e0701, action_flightpath_005,                                  704,    32,    0,   32,    6,   20,   12 }, // 13
    {  8,  8, &stage_enemy_e0702, action_flightpath_006,                                  -64,    32,    0,   32,    8,   20,   12 }, // 14
    {  8,  8, &stage_enemy_e0703, action_flightpath_005,                                  704,    32,    0,   32,   10,   20,   12 }, // 15
    {  8,  8, &stage_enemy_e0101, action_flightpath_left_circle_002,                      704,    32,    0,   32,    6,   20,   15 }, // 16
    {  8,  8, &stage_enemy_e0202, action_flightpath_right_circle_003,                     -64,    32,    0,   32,    8,   20,   15 }, // 17
    {  8,  8, &stage_enemy_e0401, action_flightpath_right_circle_003,                     704,    32,    0,   32,   10,   20,   17 }, // 18
    {  8,  8, &stage_enemy_e0401, action_flightpath_left_circle_002,                      704,    32,    0,   32,   10,   20,   17 }  // 19
};


// This models the playbook of all the different levels in the game.
// The embedded level field in the playbook is a pointer to a level composition.
__export volatile stage_playbook_t stage_playbook[] = {
    { 19, stage_level_01, &stage_player }
};

__export volatile
stage_script_t stage_script = {
    1, stage_playbook
};

#pragma data_seg(Data)

