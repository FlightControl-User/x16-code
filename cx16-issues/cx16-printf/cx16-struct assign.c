#include <cx16.h>
#include <conio.h>
#include <printf.h>

#pragma var_model(zp)


typedef struct {
    unsigned int dummy[64];
    unsigned int offset[64];
    unsigned int d3[64];
    unsigned int d4[64];
} tile_parts_t;

typedef struct {
    tile_parts_t* parts;
} tile_t;

volatile tile_parts_t test1_parts;
volatile tile_parts_t test2_parts;

volatile tile_t test1 = { &test1_parts };
volatile tile_t test2 = { &test2_parts };

void test(tile_t* tile, unsigned int part, unsigned int vram) {

    tile_parts_t* parts = tile->parts;
    
    unsigned int offset = (vram - 0x2000);
    offset = offset >> 7;


    parts->offset[part] = offset;

}

void print(tile_t* tile, unsigned char part) {

    tile_parts_t* parts = tile->parts;
    printf("offset = %x\n", parts->offset[part]);
}

void main() {

    clrscr();

    test(&test1, 5, 0x3000);
    test(&test2, 5, 0x5000);

    print(&test1, 5);
    print(&test2, 5);
}
