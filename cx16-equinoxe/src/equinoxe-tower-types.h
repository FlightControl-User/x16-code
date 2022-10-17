#ifndef __EQUINOXE_TOWER_TYPES_H
#define __EQUINOXE_TOWER_TYPES_H

typedef struct {

    unsigned char used[8];
    unsigned char enabled[8];
    unsigned char offset[8];
    unsigned char x[8];
    unsigned char y[8];

    fe_sprite_index_t sprite[8]; ///< the gun turret
    vera_sprite_offset sprite_offset[8]; ///< the offset received from the sprite dispatcher 


    unsigned char type[8];
    unsigned char side[8];

    signed char health[8];


    unsigned char wait_animation[8];
    unsigned char speed_animation[8];
    unsigned char state_animation[8];
    signed char direction_animation[8];
    unsigned char start_animation[8];
    unsigned char stop_animation[8];

    unsigned char palette[8];

} tower_t;


#endif