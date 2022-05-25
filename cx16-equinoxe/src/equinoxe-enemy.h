#ifndef equinoxe_enemy_h
#define equinoxe_enemy_h

#include "equinoxe-types.h"
#include "equinoxe-enemy-types.h"

#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"
#include "equinoxe-stage.h"


#define ENEMY_ACTION_START 0
#define ENEMY_ACTION_MOVE 1
#define ENEMY_ACTION_TURN 2
#define ENEMY_ACTION_END 255 

#pragma data_seg(EnemyControl)

/* 
How to read these tables ...
----------------------------
enemy_action_start_t            { }

*/

enemy_action_start_t    enemy01_start00     = { 16, -32, 48, 0 };
enemy_action_move_t     enemy01_move01      = { 480+64, 16, 3 };
enemy_action_end_t      enemy01_end01       = { 0 };

enemy_flightpath_t enemy01_flightpath[3] = {
    { &enemy01_start00,   ENEMY_ACTION_START,       1 },
    { &enemy01_move01,    ENEMY_ACTION_MOVE,        2 },
    { &enemy01_end01,     ENEMY_ACTION_END,         0 }
};

enemy_action_start_t    enemy02_start00     = { 640, 20, 0, 16 };
enemy_action_turn_t     enemy02_turn01      = { -24, 4, 3 };
enemy_action_move_t     enemy02_move01      = { 320+160, 32, 3 };
enemy_action_move_t     enemy02_move02      = { 80, 0, 3 };


enemy_flightpath_t enemy02_flightpath[4] = {
    { &enemy02_start00,   ENEMY_ACTION_START,       1 },
    { &enemy02_move01,    ENEMY_ACTION_MOVE,        2 },
    { &enemy02_turn01,    ENEMY_ACTION_TURN,        3 },
    { &enemy02_move02,    ENEMY_ACTION_MOVE,        2 }
};

enemy_action_start_t    enemy03_start00     = { -32, 20, 0, 16 };
enemy_action_turn_t     enemy03_turn01      = { 24, 4, 3 };
enemy_action_move_t     enemy03_move01      = { 320+160, 0, 3 };
enemy_action_move_t     enemy03_move02      = { 80, 0, 3 };


enemy_flightpath_t enemy03_flightpath[4] = {
    { &enemy03_start00,   ENEMY_ACTION_START,       1 },
    { &enemy03_move01,    ENEMY_ACTION_MOVE,        2 },
    { &enemy03_turn01,    ENEMY_ACTION_TURN,        3 },
    { &enemy03_move02,    ENEMY_ACTION_MOVE,        2 }
};

enemy_action_start_t    enemy04_start00     = { 640, 20, 0, 8 };
enemy_action_turn_t     enemy04_turn01      = { 32, 2, 5 };
enemy_action_move_t     enemy04_move01      = { 640, 32, 5 };


enemy_flightpath_t enemy04_flightpath[4] = {
    { &enemy04_start00,   ENEMY_ACTION_START,       1 },
    { &enemy04_move01,    ENEMY_ACTION_MOVE,        2 },
    { &enemy04_turn01,    ENEMY_ACTION_TURN,        1 },
};

extern fe_enemy_t enemy;

#pragma data_seg(Data)

void enemy_init();
unsigned char AddEnemy(sprite_t* sprite, enemy_flightpath_t* flights); 
unsigned char HitEnemy(unsigned char e, unsigned char b);
unsigned char RemoveEnemy(unsigned char e);

void LogicEnemies();

#endif