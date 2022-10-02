#include "../equinoxe-flightengine-types.h"
#include "equinoxe-level-types.h"

#pragma data_seg(spritecontrol)



__export volatile
sprite_bram_t sprite_engine_01 =       { 
    "engine01.bin", 16, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 1, 
    0, {0,0,0,0}, 0, 0
    // &engine01_vera_heap_index, &engine01_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_player_01 =       { 
    "player01.bin", 7, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 0, 
    0, {2,2,32-2,32-2}, 0, 0
    // &player01_vera_heap_index, &player01_vram_image_offset 
};


__export volatile
sprite_bram_t sprite_enemy_001 =       { 
    "enemy01.bin", 12, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 2, 
    0, {2,2,32-2,32-2}, 0, 0
    // &enemy01_vera_heap_index, &enemy01_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_002 =       { 
    "enemy02.bin", 12, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 3, 
    1, {2,2,32-2,32-2}, 0, 0 
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_003 =       { 
    "enemy03.bin", 6, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 4, 
    1, {4,4,32-4,32-4}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_004 =       { 
    "enemy04.bin", 12, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 5, 
    1, {4,4,32-4,32-4}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_005 =       { 
    "enemy05.bin", 12, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 6, 
    0, {4,4,32-4,32-4}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_006 =       { 
    "enemy06.bin", 21, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 7, 
    0, {4,4,32-4,32-4}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_007 =       { 
    "enemy07.bin", 12, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 8, 
    0, {4,4,32-4,32-4}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};


__export volatile
sprite_bram_t sprite_enemy_008 =       { 
    "enemy08.bin", 15, 2048, 
    VERA_SPRITE_HEIGHT_64, VERA_SPRITE_WIDTH_64, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 9, 
    0, {4,4,64-4,64-4}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_009 =       { 
    "enemy09.bin", 25, 2048, 
    VERA_SPRITE_HEIGHT_64, VERA_SPRITE_WIDTH_64, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 10, 
    0, {4,4,64-4-16,64-4-16}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_010 =       { 
    "enemy10.bin", 25, 2048, 
    VERA_SPRITE_HEIGHT_64, VERA_SPRITE_WIDTH_64, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 11, 
    0, {4,4,64-4-16,64-4-16}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_bullet_01 =       { 
    "bullet01.bin", 1, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 12, 
    0, {0,0,1,4}, 0, 0
    // &bullet01_vera_heap_index, &bullet01_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_bullet_02 =       { 
    "bullet02.bin", 5, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 13, 
    0, {0,0,1,4}, 0, 0
    // &bullet02_vera_heap_index, &bullet02_vram_image_offset 
};


__export volatile
sprite_bram_t sprite_bullet_03 =       { 
    "bullet03.bin", 4, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 14, 
    0, {0,0,1,4}, 0, 0
    // &bullet02_vera_heap_index, &bullet02_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_bullet_04 =       { 
    "bullet04.bin", 4, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 15, 
    0, {0,0,1,4}, 0, 0
    // &bullet02_vera_heap_index, &bullet02_vram_image_offset 
};

__export volatile
sprite_bram_t *sprite_DB[] = { 
    &sprite_engine_01, 
    &sprite_player_01, 
    &sprite_enemy_001, 
    &sprite_enemy_002, 
    &sprite_enemy_003, 
    &sprite_enemy_004, 
    &sprite_enemy_005, 
    &sprite_enemy_006, 
    &sprite_enemy_007, 
    &sprite_enemy_008, 
    &sprite_enemy_009, 
    &sprite_enemy_010, 
    &sprite_bullet_01, 
    &sprite_bullet_02,
    &sprite_bullet_03, 
    &sprite_bullet_04,
    0 
    };


__export volatile
sprite_bram_handles_t sprite_bram_handles[256];


#pragma data_seg(levels)

stage_action_move_t     action_move_00      = { 480+64, 16, 3 };
stage_action_move_t     action_move_01      = { 320+160, 32, 3 };
stage_action_move_t     action_move_02      = { 80, 0, 3 };
stage_action_move_t     action_move_03      = { 320+160, 0, 3 };
stage_action_move_t     action_move_04      = { 640, 32, 4 };
stage_action_move_t     action_move_05      = { 640, 32, 2 };
stage_action_move_t     action_move_06      = { 640, 0, 2 };

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
stage_flightpath_t action_flightpath_002[] = {
    { &action_move_01,    STAGE_ACTION_MOVE,        1 },
    { &action_turn_00,    STAGE_ACTION_TURN,        2 },
    { &action_move_02,    STAGE_ACTION_MOVE,        1 }
};

__export volatile
stage_flightpath_t action_flightpath_003[] = {
    { &action_move_03,    STAGE_ACTION_MOVE,        1 },
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
//    ct, sp, &sprite_enemy_xxx, action_flightpath_xxx, xstrt, ystrt, xinc, yinc, ival, wait, prev    
    {  8,  8, &sprite_enemy_010, action_flightpath_006,   -32,    32,    0,   48,    0,    0,  255 }, // 0
    {  8,  8, &sprite_enemy_010, action_flightpath_005,   640,    32,    0,   48,    0,   80,    0 }, // 1
    {  8,  8, &sprite_enemy_006, action_flightpath_006,   -32,    32,    0,   32,    0,   80,    1 }, // 2
    {  8,  8, &sprite_enemy_006, action_flightpath_005,   640,    32,    0,   32,    0,   80,    2 }, // 3
    {  8,  8, &sprite_enemy_004, action_flightpath_006,   -32,    32,    0,   48,    0,   80,    3 }, // 4
    {  8,  8, &sprite_enemy_005, action_flightpath_005,   640,    32,    0,   48,    0,   80,    4 }, // 5
    {  8,  8, &sprite_enemy_006, action_flightpath_006,   -32,    32,    0,   32,    8,   80,    5 }, // 6
    {  8,  8, &sprite_enemy_009, action_flightpath_005,   640,    32,    0,   32,    8,   80,    6 }, // 7
    {  8,  8, &sprite_enemy_010, action_flightpath_006,   -32,    32,    0,   32,    8,   80,    7 }, // 8
    {  8,  8, &sprite_enemy_009, action_flightpath_005,   640,    32,    0,   32,    8,   80,    8 }, // 9
    {  8,  8, &sprite_enemy_009, action_flightpath_006,   -32,    32,    0,   32,    8,   80,    9 }, // 10
    {  8,  8, &sprite_enemy_003, action_flightpath_005,   640,    32,    0,   32,    4,   80,   10 }, // 11
    {  8,  8, &sprite_enemy_004, action_flightpath_006,   -32,    32,    0,   32,    4,   80,   11 }, // 12
    {  8,  8, &sprite_enemy_005, action_flightpath_005,   640,    32,    0,   32,    4,   80,   12 }, // 13
    {  8,  8, &sprite_enemy_006, action_flightpath_006,   -32,    32,    0,   32,    4,   80,   13 }, // 14
    {  8,  8, &sprite_enemy_007, action_flightpath_005,   640,    32,    0,   32,    4,   80,   14 }  // 15
};

// This models the playbook of all the different levels in the game.
// The embedded level field in the playbook is a pointer to a level composition.
__export volatile
stage_playbook_t stage_playbook[1] = {
    { 15, stage_level_01 }
};

__export volatile
stage_script_t stage_script = {
    1, stage_playbook
};

#pragma data_seg(Data)
