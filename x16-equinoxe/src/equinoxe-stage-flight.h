#include "equinoxe-types.h"

// __lib_export extern stage_t stage;

void stage_impact(flight_index_t f, flight_index_t h);

#ifdef __TOWER
void stage_tower_remove(flight_index_t t);
#endif

#ifdef __BULLET
// __lib_import("equinoxe-bullet") flight_index_t bullet_add(unsigned int sx, unsigned int sy, unsigned int tx, unsigned int ty, unsigned char speed, flight_side_t side, sprite_index_t sprite_bullet);
void stage_bullet_add(unsigned int sx, unsigned int sy, unsigned int tx, unsigned int ty, unsigned char speed, flight_side_t side, sprite_index_t sprite_bullet);
void stage_bullet_remove(flight_index_t b);
#endif


stage_action_t* stage_get_flightpath_action(stage_flightpath_t* flightpath, unsigned char action);
unsigned char stage_get_flightpath_type(stage_flightpath_t* flightpath, unsigned char action);
unsigned char stage_get_flightpath_next(stage_flightpath_t* flightpath, unsigned char action);

unsigned int stage_get_flightpath_action_move_flight(stage_action_t* action_move);
signed char stage_get_flightpath_action_move_turn(stage_action_t* action_move);
unsigned char stage_get_flightpath_action_move_speed(stage_action_t* action_move);

signed char stage_get_flightpath_action_turn_turn(volatile stage_action_t* action_turn);
unsigned char stage_get_flightpath_action_turn_radius(stage_action_t* action_turn);
unsigned char stage_get_flightpath_action_turn_speed(stage_action_t* action_turn);
