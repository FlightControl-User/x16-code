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

    bitmap_init(0, 0, 0x0000);
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
