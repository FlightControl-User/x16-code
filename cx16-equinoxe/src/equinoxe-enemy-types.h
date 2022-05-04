#ifndef equinoxe_enemy_types_h
#define equinoxe_enemy_types_h

#include "equinoxe-types.h"

typedef struct {
     signed int x;
     signed int y;
     signed char dx;
     signed char dy;
} enemy_action_start_t;

typedef struct {
     unsigned int flight;
     signed char turn;
     unsigned char speed;
} enemy_action_move_t;

typedef struct {
     signed char turn;
     unsigned char radius;
     unsigned char speed;
} enemy_action_turn_t;

typedef struct {
     unsigned char explode;
} enemy_action_end_t;

typedef union {
    enemy_action_start_t start;
    enemy_action_move_t move;
    enemy_action_turn_t turn;
} enemy_action_t;

typedef struct {
    void* action;
    unsigned char type;
    unsigned char next;
} enemy_flightpath_t;

typedef struct {

    FP tx[64];
    FP ty[64];
    FP tdx[64];
    FP tdy[64];

    unsigned char aabb_min_x[64];
    unsigned char aabb_min_y[64];
    unsigned char aabb_max_x[64];
    unsigned char aabb_max_y[64];

    unsigned char used[64];

    unsigned char type[64];
    unsigned char side[64];

    unsigned char move[64];
    unsigned char moved[64];
    unsigned char enabled[64];

    unsigned int flight[64];
    unsigned char delay[64];

    unsigned char angle[64];
    unsigned char speed[64];
    unsigned char turn[64];
    unsigned char radius[64];
    unsigned char baseangle[64];

    unsigned char reload[64];
    signed char health[64];

    unsigned char wait_animation[64];
    unsigned char speed_animation[64];
    unsigned char state_animation[64];
    unsigned char reverse_animation[64];
    signed char direction_animation[64];
    unsigned char start_animation[64];
    unsigned char stop_animation[64];

    unsigned char action[64];
    enemy_flightpath_t* flightpath[64];

    sprite_t* sprite_type[64];
    vera_sprite_offset sprite_offset[64];
    unsigned char sprite_palette[64];

} fe_enemy_t;

#endif