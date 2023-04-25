#pragma once

#include "equinoxe-animate-types.h"

typedef struct {

    vera_sprite_offset sprite_offset[32];

    FP tx[32];
    FP ty[32];
    FP tdx[32];
    FP tdy[32];

    unsigned char cx[32];
    unsigned char cy[32];

    unsigned char used[32];
    unsigned char collided[32];

    unsigned char type[32];
    unsigned char side[32];

    unsigned char move[32];
    unsigned char moved[32];
    unsigned char enabled[32];

    unsigned char step[32];
    unsigned int flight[32];
    unsigned char delay[32];

    unsigned char angle[32];
    unsigned char speed[32];
    unsigned char turn[32];
    unsigned char radius[32];
    unsigned char baseangle[32];

    unsigned char reload[32];
    signed char impact[32];

    unsigned char animate[32];

    fe_sprite_index_t sprite[32];

} fe_bullet_t;
