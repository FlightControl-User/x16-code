#include "equinoxe-types.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"
#include "stdio.h"
#include <cx16-bitmap.h>

ht_key_t grid_key(unsigned char gx, unsigned char gy)
{
    unsigned char key = gy + gx;
    return key;
    //  return (((unsigned int)(kx + ky))|(unsigned int)group<<4);
}


/**
 * @brief Add a new coordinate to the spacial grid.
 * This routine is very tricky. It requires to carefully determine which sectors 
 * in the spacial grid are to be inserted in the has table.
 * And this is not obvious, sometimes also negative coordinates are given, like -64.
 * This has a risk of ending in an endless loop!
 * So the xmin and ymin are taken as char values, while the xmax and ymax values are taken as int values.
 * This to carefully compare the increment of ymin from 0x00F0 to 0x0100 and not to 0x0000!
 * Same for the xmin value. So the gx and gy values are also int to ensure that the addition is taken in two bytes.
 * But note that only the lower bytes of the int values are actually stored in the spacial grid coordinate system!
 * 
 * @param ht 
 * @param group 
 * @param xmin 
 * @param ymin 
 * @param data 
 */
void grid_insert(ht_item_t* ht, unsigned char xmin, unsigned char ymin, ht_data_t data) { 

    // bram_bank_t bram_old = bank_get_bram();
    // bank_set_bram(60);

    unsigned int xmax = ((unsigned int)xmin + 8) & 0b111111110000;
    unsigned int ymax = ((unsigned int)ymin + 8) & 0b111111110000; 

    xmin = xmin & 0b11110000;
    ymin = ymin & 0b11110000;

    xmin >>= 4;
    xmax >>= 4;

    for(unsigned int gx=xmin; gx<=xmax; gx+=1) {
        for(unsigned int gy=ymin; gy<=ymax; gy+=16) {
            ht_key_t ht_key = grid_key((unsigned char)gx, (unsigned char)gy);
            // printf("cell %02x,%02x:%02x(%02x)", gx, gy, ht_key, data);
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

