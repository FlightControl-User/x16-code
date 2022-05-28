typedef struct {
     signed int x;
     signed int y;
     signed char dx;
     signed char dy;
} stage_action_start_t;

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
    stage_action_start_t start;
    stage_action_move_t move;
    stage_action_turn_t turn;
} stage_action_t;

typedef struct {
    void* action;
    unsigned char type;
    unsigned char next;
} stage_flightpath_t;


const unsigned char STAGE_ACTION_START = 0;
const unsigned char STAGE_ACTION_MOVE = 1;
const unsigned char STAGE_ACTION_TURN = 2;
const unsigned char STAGE_ACTION_END = 255; 
