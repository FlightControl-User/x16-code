#include <conio.h>
#include <printf.h>
#include <cx16-veralib.h>

#pragma target(cx16)

#pragma encoding(petscii_mixed)

void main() {

    cx16_k_screen_set_mode(0);  // Default 80 columns mode.
    screenlayer1(); // Reset the screen layer values for conio.
    cx16_k_screen_set_charset(3, (char *)0);  // Lower case characters.
    vera_display_set_hstart(11);  // Set border.
    vera_display_set_hstop(147);  // Set border.
    vera_display_set_vstart(19);  // Set border.
    vera_display_set_vstop(219);  // Set border.
    vera_sprites_hide();  // Hide sprites.
    vera_layer0_hide();  // Layer 0 deactivated.
    vera_layer1_show();  // Layer 1 is the current text canvas.
    textcolor(WHITE);  // Default text color is white.
    bgcolor(BLUE);  // With a blue background.
    clrscr(); 
    vera_display_set_border_color(5);
   
}
