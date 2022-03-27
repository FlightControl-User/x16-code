#include <conio.h>
#include <printf.h>
#include <cx16-veralib.h>


#pragma encoding(petscii_mixed)

void main() {

    unsigned int const VERA_PETSCII_TILE = 0xF800;
    unsigned int const VERA_PETSCII_TILE_SIZE = 0x0800;

    memcpy_vram_vram(1, (word)0xF000, 0, VERA_PETSCII_TILE, VERA_PETSCII_TILE_SIZE);

    vera_layer1_mode_tile(
        1, (word)0xB000, 
        1, (word)0xF000, 
        VERA_LAYER_WIDTH_128, VERA_LAYER_HEIGHT_64, 
        VERA_TILEBASE_WIDTH_8, VERA_TILEBASE_HEIGHT_8, 
        VERA_LAYER_COLOR_DEPTH_1BPP
    );

    screenlayer1();
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    vera_layer1_show();
    vera_layer0_hide();

    printf("printing\n %s\n", "colors");

    for(unsigned char f=0; f<16; f++) {
        for(unsigned char b=0; b<16; b++) {
            textcolor(f);
            bgcolor(b);
            gotoxy(f*4,b*2+4);
            printf("***");
        }
    }
}
