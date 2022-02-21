#include <cx16-heap.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"

void grid_remove(entity_t* entity) {

    unsigned char c = entity->grid.cells;
    while(c) {
        c--;
        ht_item_t* item = entity->grid.cell[c];
        if(item) {
            ht_delete(ht_collision, ht_size_collision, item);
        }
    }
    entity->grid.cells = 0;
}

unsigned char grid_insert(entity_t* entity, unsigned int x, unsigned int y, unsigned int data) { 

    unsigned char cxmin = (unsigned char)(x >> 6);
    unsigned char cymin = (unsigned char)(y >> 6);

    unsigned char cxmax = (unsigned char)((x + 32) >> 6);
    unsigned char cymax = (unsigned char)((y + 32) >> 6);

    unsigned char c = 0;
    for(unsigned char cx = cxmin; cx<=cxmax; cx++) {
        unsigned char count = 0;
        for(unsigned char cy=cymin; cy<=cymax; cy++) {
            // bit 0-3 = cy
            // bit 4-7 = cx
            // bit 15-12 = collision mask
            ht_key_t ht_key = ((((unsigned int)cx << 4 + (unsigned int)cy))<<3);
            ht_insert(ht_collision, ht_size_collision, ht_key, data);
            entity->grid.cx[c] = cx;
            entity->grid.cy[c] = cy;
            c++;
        }
    }

    return c;
}