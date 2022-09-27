#include "equinoxe-types.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"
#include "stdio.h"
#include <cx16-bitmap.h>

inline ht_key_t grid_key(unsigned char group, unsigned char gx, unsigned char gy) {
     return ((gy | gx) + group);
    //  return (((unsigned int)(kx + ky))|(unsigned int)group<<4);
}


void grid_insert(ht_item_t* ht, unsigned char group, unsigned char xmin, unsigned char ymin, ht_data_t data) { 

    // bram_bank_t bram_old = bank_get_bram();
    // bank_set_bram(60);

    unsigned char xmax = (xmin + 8) & 0b11110000;
    unsigned char ymax = (ymin + 8) & 0b11110000; 

    xmin = xmin & 0b11110000;
    ymin = ymin & 0b11110000;

    for(unsigned char gx=xmin>>4; gx<=xmax>>4; gx+=16>>4) {
        for(unsigned char gy=ymin; gy<=ymax; gy+=16) {

            // bit 0-3 = cy
            // bit 4-7 = cx

            ht_key_t ht_key = grid_key(group, gx, gy);
            ht_insert(ht, ht_key, data);
        }
    }

    // bank_set_bram(bram_old);
}

inline void grid_print(ht_item_t* ht)
{
    bram_bank_t bram_old = bank_get_bram();
    bank_set_bram(60);
    ht_display(ht);
    bank_set_bram(bram_old);
}

