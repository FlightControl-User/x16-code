#include <cx16.h>
#include <string.h>
#include <ht.h>
#include <fp3.h>
#include <cx16-heap-bram-fb.h>
#include <cx16-veralib.h>
#include <cx16-veraheap-typedefs.h>

#include "equinoxe-stage-types.h"

typedef struct {

    char cs1;
    FP tx[64]; // 256
    FP ty[64]; // 512
    FP tdx[64]; // 768
    FP tdy[64]; // 1024


    char cs2;
    unsigned char used[64]; // 1088

    char cs3;
    unsigned char type[64]; // 1152
    unsigned char side[64]; // 1216

    unsigned char wave[64]; 
    
    unsigned char move[64]; // 1280
    unsigned char moved[64]; // 1344
    unsigned char enabled[64]; // 1408

    unsigned int flight[64]; // 1536
    unsigned char delay[64]; // 1600

    unsigned char angle[64]; // 1664
    unsigned char speed[64]; // 1728
    unsigned char turn[64]; // 1792
    unsigned char radius[64]; // 1856
    unsigned char baseangle[64]; // 1920

    unsigned char reload[64]; // 1984
    signed char health[64]; // 2048

    char cs4;
    vera_sprite_offset sprite_offset[64]; // 2176

    unsigned char wait_animation[64]; // 2240
    unsigned char speed_animation[64]; // 2304
    unsigned char state_animation[64]; // 2368
    unsigned char reverse_animation[64]; // 2432
    signed char direction_animation[64]; // 2496
    unsigned char start_animation[64]; // 2560
    unsigned char stop_animation[64]; // 2624

    unsigned char action[64]; // 2688
    stage_flightpath_t* flightpath[64]; // 2816
    unsigned char initpath; // 2217

    fe_sprite_index_t sprite[64]; // 2881

} fe_enemy_t;
