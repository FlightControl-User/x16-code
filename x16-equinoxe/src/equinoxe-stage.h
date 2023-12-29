

#include "equinoxe-types.h"

volatile extern stage_t stage;
volatile extern stage_wave_t wave;



void stage_reset();
void stage_enemy_add(unsigned char w, sprite_index_t enemy_sprite);
void stage_enemy_remove(unsigned char e);
void stage_logic();

void stage_impact(unsigned char f, flight_index_t h);

#ifdef __TOWER
stage_tower_t* stage_tower_get();
void stage_tower_add(unsigned char row, unsigned char column);
void stage_tower_remove(unsigned char t);
#endif

void stage_bullet_add(unsigned int sx, unsigned int sy, unsigned int tx, unsigned int ty, unsigned char speed, flight_side_t side, sprite_index_t sprite_bullet);
void stage_bullet_remove(flight_index_t b);



stage_action_t* stage_get_flightpath_action(stage_flightpath_t* flightpath, unsigned char action);
unsigned char stage_get_flightpath_type(stage_flightpath_t* flightpath, unsigned char action);
unsigned char stage_get_flightpath_next(stage_flightpath_t* flightpath, unsigned char action);

unsigned int stage_get_flightpath_action_move_flight(stage_action_t* action_move);
signed char stage_get_flightpath_action_move_turn(stage_action_t* action_move);
unsigned char stage_get_flightpath_action_move_speed(stage_action_t* action_move);

signed char stage_get_flightpath_action_turn_turn(volatile stage_action_t* action_turn);
unsigned char stage_get_flightpath_action_turn_radius(stage_action_t* action_turn);
unsigned char stage_get_flightpath_action_turn_speed(stage_action_t* action_turn);