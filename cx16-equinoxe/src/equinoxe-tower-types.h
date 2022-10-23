#ifndef __EQUINOXE_TOWER_TYPES_H
#define __EQUINOXE_TOWER_TYPES_H

typedef struct {

    unsigned char used[8];
    unsigned char enabled[8];
    unsigned char offset[8];
    unsigned char x[8];
    unsigned char y[8];
    signed int tx[8];
    signed int ty[8];

    unsigned char state[8];

    fe_sprite_index_t sprite[8]; ///< the gun turret
    vera_sprite_offset sprite_offset[8]; ///< the offset received from the sprite dispatcher 


    unsigned char type[8];
    unsigned char side[8];

    signed char health[8];

    unsigned char anim_state[8];
    unsigned char anim_wait[8];
    unsigned char anim_speed[8];
    unsigned char anim_start[8];
    unsigned char anim_stop[8];

    unsigned char palette[8];

} tower_t;


#endif