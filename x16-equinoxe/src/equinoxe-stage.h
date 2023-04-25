#pragma once

#include "equinoxe-types.h"

volatile extern stage_t stage;
volatile extern stage_wave_t wave;


stage_tower_t* stage_tower_get();

void stage_reset();
void stage_enemy_add(unsigned char w, sprite_index_t enemy_sprite);
void stage_enemy_hit(unsigned char e, signed char impact);
void stage_enemy_remove(unsigned char e);
void stage_logic();


stage_action_t* stage_get_flightpath_action(stage_flightpath_t* flightpath, unsigned char action);
unsigned char stage_get_flightpath_type(stage_flightpath_t* flightpath, unsigned char action);
unsigned char stage_get_flightpath_next(stage_flightpath_t* flightpath, unsigned char action);

unsigned int stage_get_flightpath_action_move_flight(stage_action_t* action_move);
signed char stage_get_flightpath_action_move_turn(stage_action_t* action_move);
unsigned char stage_get_flightpath_action_move_speed(stage_action_t* action_move);

signed char stage_get_flightpath_action_turn_turn(volatile stage_action_t* action_turn);
unsigned char stage_get_flightpath_action_turn_radius(stage_action_t* action_turn);
unsigned char stage_get_flightpath_action_turn_speed(stage_action_t* action_turn);