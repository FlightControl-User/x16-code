// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.

// Author: Sven Van de Velde

#pragma target(cx16)
#include <cx16.h>
#include <cx16-veralib.h>
#include <printf.h>

void main() {

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    for(byte c:0..255) {
        bgcolor(c);
        printf(" ****** ");
    }

    gotoxy(0,50);
    textcolor(WHITE);
    bgcolor(BLACK);
    printf("vera in text mode 8 x 8, color depth 1 bits per pixel.\n");
    printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n");
    printf("each character can have a variation of 16 foreground colors and 16 background colors.\n");
    printf("here we display 6 stars (******) each with a different color.\n");
    printf("however, the first color will always be transparent (black).\n");
    printf("in this mode, the background color cannot be set and is always transparent.\n");

    while(!kbhit());
}
