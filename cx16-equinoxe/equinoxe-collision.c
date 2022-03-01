#include <cx16-heap.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"
#include "stdio.h"
#include <cx16-bitmap.h>

ht_key_t grid_key(unsigned char group, unsigned int gx, unsigned int gy) {
     unsigned char kx = (BYTE1(gx)<<2 | BYTE0(gx)>>6);
     unsigned char ky = (BYTE1(gy)<<2 | BYTE0(gy)>>6);
     return (((unsigned int)(kx<<4 + ky))|(unsigned int)group<<4);
}

void grid_remove(entity_t* entity) {

    unsigned char grid = entity->grid.cells;
    while(grid) {
        grid--;
        ht_item_t* item = entity->grid.cell[grid];

        // unsigned int gx00 = entity->grid.gx[grid];
        // unsigned int gy00 = entity->grid.gy[grid];
        // unsigned int gx64 = gx00+64;
        // unsigned int gy64 = gy00+64;

        // bitmap_plot(gx00,gy00,0);
        // bitmap_plot(gx00,gy64,0);
        // bitmap_plot(gx64,gy00,0);
        // bitmap_plot(gx64,gy64,0);

        if(item) {
            ht_delete(ht_collision, ht_size_collision, item);
        }
    }
    entity->grid.cells = 0;
}

unsigned char grid_insert(entity_t* entity, unsigned char group, unsigned int xmin, unsigned int ymin, unsigned int data) { 

    unsigned int xmax = (xmin + 32) & 0b1111111111000000; 
    unsigned int ymax = (ymin + 32) & 0b1111111111000000; 

    xmin = xmin & 0b1111111111000000;
    ymin = ymin & 0b1111111111000000;

    unsigned char grid = 0;

    for(unsigned int gx=xmin; gx<=xmax; gx+=64) {
        for(unsigned int gy=ymin; gy<=ymax; gy+=64) {

            // unsigned int gx00 = gx;
            // unsigned int gy00 = gy;
            // unsigned int gx64 = gx00+64;
            // unsigned int gy64 = gy00+64;

            // bitmap_plot(gx00,gy00,1);
            // bitmap_plot(gx00,gy64,1);
            // bitmap_plot(gx64,gy00,1);
            // bitmap_plot(gx64,gy64,1);

            // bit 0-3 = cy
            // bit 4-7 = cx
            // bit 15-12 = collision mask

            ht_key_t ht_key = grid_key(group,gx,gy);
            entity->grid.cell[grid] = ht_insert(ht_collision, ht_size_collision, ht_key, data);
            entity->grid.gx[grid] = gx;
            entity->grid.gy[grid] = gy;
            grid++;
        }
    }

    return grid;
}