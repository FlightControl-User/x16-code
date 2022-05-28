#include "equinoxe-level-types.h"

#pragma data_seg(level01)

stage_action_start_t    action_start_00     = { 16, -32, 48, 0 };
stage_action_start_t    action_start_01     = { 640, 20, 0, 16 };
stage_action_start_t    action_start_02     = { -32, 20, 0, 16 };
stage_action_start_t    action_start_03     = { 640, 20, 0, 8 };

stage_action_move_t     action_move_00      = { 480+64, 16, 3 };
stage_action_move_t     action_move_01      = { 320+160, 32, 3 };
stage_action_move_t     action_move_02      = { 80, 0, 3 };
stage_action_move_t     action_move_03      = { 320+160, 0, 3 };
stage_action_move_t     action_move_04      = { 640, 32, 2 };

stage_action_turn_t     action_turn_00      = { -24, 4, 3 };
stage_action_turn_t     action_turn_01      = { 24, 4, 3 };
stage_action_turn_t     action_turn_02      = { 32, 2, 2 };

stage_action_end_t      action_end          = { 0 };

__export
stage_flightpath_t action_flightpath_01[3] = {
    { &action_start_00,   STAGE_ACTION_START,       1 },
    { &action_move_00,    STAGE_ACTION_MOVE,        2 },
    { &action_end,        STAGE_ACTION_END,         0 }
};

__export
stage_flightpath_t action_flightpath_02[4] = {
    { &action_start_01,   STAGE_ACTION_START,       1 },
    { &action_move_01,    STAGE_ACTION_MOVE,        2 },
    { &action_turn_00,    STAGE_ACTION_TURN,        3 },
    { &action_move_02,    STAGE_ACTION_MOVE,        2 }
};

__export
stage_flightpath_t action_flightpath_03[4] = {
    { &action_start_02,   STAGE_ACTION_START,       1 },
    { &action_move_03,    STAGE_ACTION_MOVE,        2 },
    { &action_turn_01,    STAGE_ACTION_TURN,        3 },
    { &action_move_02,    STAGE_ACTION_MOVE,        2 }
};

__export
stage_flightpath_t action_flightpath_04[4] = {
    { &action_start_03,   STAGE_ACTION_START,       1 },
    { &action_move_04,    STAGE_ACTION_MOVE,        2 },
    { &action_turn_02,    STAGE_ACTION_TURN,        1 },
};

#pragma data_seg(Data)
