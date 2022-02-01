// Example program for the Commander X16.
// Demonstrates the usage of the VERA graphic modes and layering.

// Author: Sven Van de Velde

#pragma target(cx16)
#include <cx16.h>
#include <cx16-veralib.h>
#include <conio.h>
#include <printf.h>
#include <cx16-bitmap.h>
#include <stdlib.h>
#include <division.h>

void main() {

    // Before we configure the bitmap pane into vera  memory we need to re-arrange a few things!
    // It is better to load all in bank 0, but then there is an issue.
    // So the default CX16 character set is located in bank 0, at address 0xF800.
    // So we need to move this character set to bank 1, suggested is at address 0xF000.
    // The CX16 by default writes textual output to layer 1 in text mode, so we need to
    // realign the moved character set to 0xf000 as the new tile base for layer 1.
    // We also will need to realign for layer 1 the map base from 0x00000 to 0x14000.
    // This is now all easily done with a few statements in the new kickc vera lib ...

    memcpy_vram_vram(1, 0xF000, 0, 0xF800, 256*8); // We copy the 128 character set of 8 bytes each.
    vera_layer1_mode_tile(
        1, 0x4000, 
        1, 0xF000,
        VERA_LAYER_WIDTH_128, VERA_LAYER_HEIGHT_64, 
        VERA_TILEBASE_WIDTH_8, VERA_TILEBASE_HEIGHT_8, 
        VERA_LAYER_COLOR_DEPTH_1BPP
    );

    vera_layer0_mode_bitmap(
        0, 0x0000, 
        VERA_TILEBASE_WIDTH_8, 
        VERA_LAYER_COLOR_DEPTH_4BPP
    );

    screenlayer1();
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,25);
    printf("vera in bitmap mode,\n");
    printf("color depth 4 bits per pixel.\n");
    printf("in this mode, it is possible to display\n");
    printf("graphics in 16 colors.\n");

    vera_layer0_show();

    bitmap_init(0, 0x00000);
    bitmap_clear();

    gotoxy(0,29);
    textcolor(YELLOW);
    printf("press a key ...");

    while(!kbhit()) {
        bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&15);
    };

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,26);
    printf("here you see all the colors possible.\n");

    gotoxy(0,29);
    textcolor(YELLOW);
    printf("press a key ...");

    word x = 0;
    byte color = 0;
    while(!kbhit()) {
        bitmap_line(x, x, 0, 199, color);
        color++;
        if(color>15) color=0;
        x++;
        if(x>319) x=0;
    };

    screenlayer1();
    textcolor(WHITE);
    bgcolor(BLUE);
    clrscr();

}
