#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"
#include "stdio.h"
#include <cx16-bitmap.h>

inline ht_key_t grid_key(unsigned char group, unsigned char gx, unsigned char gy) {
     return MAKEWORD(group, gx | gy>>4);
    //  return (((unsigned int)(kx + ky))|(unsigned int)group<<4);
}

void grid_reset(ht_item_ptr_t ht, ht_size_t ht_size)
{
    bram_bank_t bram_old = bank_get_bram();
    bank_set_bram(60);
    ht_reset(ht, ht_size);
    bank_set_bram(bram_old);
}

void grid_init(ht_item_ptr_t ht, ht_size_t ht_size)
{
    bram_bank_t bram_old = bank_get_bram();
    bank_set_bram(60);
    ht_init(ht, ht_size);
    bank_set_bram(bram_old);
}

 inline void grid_insert(unsigned char group, unsigned char xmin, unsigned char ymin, unsigned int data) { 

    bram_bank_t bram_old = bank_get_bram();
    bank_set_bram(60);

    unsigned char xmax = (xmin + 8) & 0b11110000;
    unsigned char ymax = (ymin + 8) & 0b11110000; 

    xmin = xmin & 0b11110000;
    ymin = ymin & 0b11110000;

    for(unsigned char gx=xmin; gx<=xmax; gx+=16) {
        for(unsigned char gy=ymax; gy<=ymax; gy+=16) {

            // bit 0-3 = cy
            // bit 4-7 = cx
            // bit 15-12 = collision mask

            ht_key_t ht_key = grid_key(group,gx,gy);
            ht_insert(ht_collision, ht_size_collision, ht_key, data);
            // entity->grid.gx[grid] = gx;
            // entity->grid.gy[grid] = gy;
        }
    }

    bank_set_bram(bram_old);
}