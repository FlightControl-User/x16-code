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
sprite_bram_t sprite_enemy_01 =       { 
    "enemy01.bin", 12, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 2, 
    0, {2,2,32-2,32-2}, 0, 0
    // &enemy01_vera_heap_index, &enemy01_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_02 =       { 
    "enemy02.bin", 12, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 3, 
    1, {2,2,32-2,32-2}, 0, 0 
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_03 =       { 
    "enemy03.bin", 6, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 4, 
    1, {4,4,32-4,32-4}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_04 =       { 
    "enemy04.bin", 12, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 5, 
    1, {4,4,32-4,32-4}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_05 =       { 
    "enemy05.bin", 12, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 6, 
    1, {4,4,32-4,32-4}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_06 =       { 
    "enemy06.bin", 12, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 7, 
    1, {4,4,32-4,32-4}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_enemy_07 =       { 
    "enemy07.bin", 12, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 8, 
    1, {4,4,32-4,32-4}, 0, 0
    // &enemy03_vera_heap_index, &enemy03_vram_image_offset 
};


__export volatile
sprite_bram_t sprite_bullet_01 =       { 
    "bullet01.bin", 1, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 9, 
    0, {0,0,1,4}, 0, 0
    // &bullet01_vera_heap_index, &bullet01_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_bullet_02 =       { 
    "bullet02.bin", 5, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 10, 
    0, {0,0,1,4}, 0, 0
    // &bullet02_vera_heap_index, &bullet02_vram_image_offset 
};


__export volatile
sprite_bram_t sprite_bullet_03 =       { 
    "bullet03.bin", 4, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 11, 
    0, {0,0,1,4}, 0, 0
    // &bullet02_vera_heap_index, &bullet02_vram_image_offset 
};

__export volatile
sprite_bram_t sprite_bullet_04 =       { 
    "bullet04.bin", 4, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 12, 
    0, {0,0,1,4}, 0, 0
    // &bullet02_vera_heap_index, &bullet02_vram_image_offset 
};

__export volatile
sprite_bram_t *sprite_DB[] = { 
    &sprite_engine_01, 
    &sprite_player_01, 
    &sprite_enemy_01, 
    &sprite_enemy_02, 
    &sprite_enemy_03, 
    &sprite_enemy_04, 
    &sprite_enemy_05, 
    &sprite_enemy_06, 
    &sprite_enemy_07, 
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

stage_action_turn_t     action_turn_00      = { -24, 4, 3 };
stage_action_turn_t     action_turn_01      = { 24, 4, 3 };
stage_action_turn_t     action_turn_02      = { 32, 2, 2 };

stage_action_end_t      action_end          = { 0 };

__export volatile
stage_flightpath_t action_flightpath_01[3] = {
    { &action_move_00,    STAGE_ACTION_MOVE,        1 },
    { &action_end,        STAGE_ACTION_END,         0 }
};

__export volatile
stage_flightpath_t action_flightpath_02[4] = {
    { &action_move_01,    STAGE_ACTION_MOVE,        1 },
    { &action_turn_00,    STAGE_ACTION_TURN,        2 },
    { &action_move_02,    STAGE_ACTION_MOVE,        1 }
};

__export volatile
stage_flightpath_t action_flightpath_03[4] = {
    { &action_move_03,    STAGE_ACTION_MOVE,        1 },
    { &action_turn_01,    STAGE_ACTION_TURN,        2 },
    { &action_move_02,    STAGE_ACTION_MOVE,        1 }
};

__export volatile
stage_flightpath_t action_flightpath_04[4] = {
    { &action_move_04,    STAGE_ACTION_MOVE,        1 },
    { &action_end,        STAGE_ACTION_END,         0 },
};

__export volatile
stage_scenario_t stage_level_01[32] = {
    { 16, 2, &sprite_enemy_01, action_flightpath_01, 16, -32, 48, 0, 4, 0, 255 }, // 0
    { 16, 2, &sprite_enemy_02, action_flightpath_02, 640, 20, 0, 16, 4, 0, 0 }, // 1
    { 16, 4, &sprite_enemy_03, action_flightpath_01, 16, -32, 48, 0, 4, 0, 1 }, // 2
    { 16, 4, &sprite_enemy_04, action_flightpath_01, 16, -32, 16, 0, 4, 10, 1 }, // 3
    { 16, 4, &sprite_enemy_05, action_flightpath_01, 16, -32, 48, 0, 4, 40, 3 }, // 4
    { 16, 4, &sprite_enemy_06, action_flightpath_02, 640, 20, 0, 16, 4, 20, 4 }, // 5
    { 16, 8, &sprite_enemy_07, action_flightpath_03, -32, 20, 0, 16, 4, 20, 5 }  // 6
};

// This models the playbook of all the different levels in the game.
// The embedded level field in the playbook is a pointer to a level composition.
__export volatile
stage_playbook_t stage_playbook[1] = {
    { 6, stage_level_01 }
};

__export volatile
stage_script_t stage_script = {
    1, stage_playbook
};

#pragma data_seg(Data)
