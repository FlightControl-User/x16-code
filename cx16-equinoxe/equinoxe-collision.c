#include <cx16-heap.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"

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
        for(unsigned char cy=cymin; cy<=cymax; cy++) {
            ht_key_t ht_key = ((unsigned int)cx * 8 + (unsigned int)cy);
            entity->grid.cell[c] = ht_insert(ht_collision, ht_size_collision, ht_key, data);
            c++;
        }
    }

    return c;
}