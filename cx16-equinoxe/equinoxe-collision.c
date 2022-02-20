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
            unsigned char cx = entity->grid.cx[c]<<3;
            unsigned char cy = entity->grid.cy[c];
            unsigned char entities = grid.entities[cx+cy]--;
            if(!entities) {
                grid.rows[cx][] //.column[cx].rows--;
            }
            if(!grid.column[cx].rows) {
                grid.columns--;
            }
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
        grid.columns++;
        for(unsigned char cy=cymin; cy<=cymax; cy++) {
            // bit 0-3 = cy
            // bit 4-7 = cx
            // bit 8-11 = count
            grid.column[cx].rows++;
            unsigned char entities = grid.column[cx].row[cy].entities++;
            ht_key_t ht_key = ((((unsigned int)cx << 4 + (unsigned int)cy)) << 8)+entities;
            ht_insert(ht_collision, ht_size_collision, ht_key, data);
            entity->grid.cx[c] = cx;
            entity->grid.cy[c] = cy;
            c++;
        }
    }

    return c;
}