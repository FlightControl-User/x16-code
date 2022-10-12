typedef struct {

    vera_sprite_offset sprite_offset[32];

    FP tx[32];
    FP ty[32];
    FP tdx[32];
    FP tdy[32];

    unsigned char used[32];

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
    signed char energy[32];

    unsigned char wait_animation[32];
    unsigned char speed_animation[32];
    unsigned char state_animation[32];
    unsigned char reverse_animation[32];
    signed char direction_animation[32];
    unsigned char start_animation[32];
    unsigned char stop_animation[32];

    fe_sprite_index_t sprite[32];

} fe_bullet_t;

extern fe_bullet_t bullet;
