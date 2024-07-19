#pragma encoding(petscii_mixed)
#pragma var_model(mem)
#pragma lib_configure
#pragma calling(__varcall)
#pragma lib_export(vera_petscii_init, vera_floor_layer0, vera_floor_layer1, vera_petscii_layer1)
#pragma lib_export(vera_floor_layer0_show, vera_floor_layer1_show) 
#pragma lib_export(vera_floor_layer0_hide, vera_floor_layer1_hide) 
#pragma calling(__phicall)

#include <cx16.h>
#include <cx16-vera.h>
#include <cx16-veralib.h>
#include "equinoxe-defines.h"
#include "equinoxe-bank.h"
#include "equinoxe-vera.h"

typedef struct {
    unsigned char cursor_x;             ///< current cursor x-position
    unsigned char cursor_y;             ///< current cursor y-position
    unsigned char layer;
    unsigned int mapbase_offset; // Base pointer to the tile map base of the conio screen.
    char mapbase_bank; // Default screen of the CX16 emulator uses memory bank 0 for text.

    unsigned char width;                ///< the screen width;
    unsigned char height;               ///< the screen height;
    unsigned char mapwidth;             ///< the map width;
    unsigned char mapheight;            ///< the map height;
    unsigned int rowskip;               ///< the amount of vram bytes needed to skip a row.
    unsigned char cursor;               ///< is a cursor whown when waiting for input (0: no, other: yes)
    unsigned char color;                ///< color of the foreground and background
    unsigned char bordercolor;          ///< color of the border
    /// Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
    /// If disabled the cursor just moves back to (0,0) instead
    unsigned char scroll[2];
    unsigned char hscroll[2];
    unsigned int offset;                ///< The current offset
    unsigned int offsets[61];           ///< Calculated offsets per line according the mapbase and the row width (scale).
} cx16_conio_t;

#include <lib_conio.p>

void vera_petscii_init() {
    cx16_k_screen_set_charset(3, (char *)0);
    vera_layer1_mode_tile(
        // Maps must be aligned to 512 bytes, so allocate the map second.
        1, (vram_offset_t)0xB000, 
        // Tiles must be aligned to 2048 bytes, to allocate the tile map first. Note that the size parameter does the actual alignment to 2048 bytes.
        1, (vram_offset_t)0xF000, 
        VERA_LAYER_WIDTH_128, VERA_LAYER_HEIGHT_64, 
        VERA_TILEBASE_WIDTH_8, VERA_TILEBASE_HEIGHT_8, 
        VERA_LAYER_COLOR_DEPTH_1BPP
    );

    screenlayer1();
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();
    scroll(0);
    vera_floor_layer1_show();
    vera_floor_layer0_hide();
}

void vera_floor_layer0() {
    vera_layer0_mode_tile( 
        FLOOR_MAP0_BANK_VRAM, (vram_offset_t)FLOOR_MAP0_OFFSET_VRAM, 
        FLOOR_TILE_BANK_VRAM, (vram_offset_t)FLOOR_TILE_OFFSET_VRAM, 
        VERA_LAYER_WIDTH_64, VERA_LAYER_HEIGHT_32,
        VERA_TILEBASE_WIDTH_16, VERA_TILEBASE_HEIGHT_16, 
        VERA_LAYER_COLOR_DEPTH_4BPP
    );
    vera_floor_layer0_show();
}

void vera_floor_layer1() {
        vera_layer1_mode_tile( 
        FLOOR_MAP1_BANK_VRAM, (vram_offset_t)FLOOR_MAP1_OFFSET_VRAM, 
        FLOOR_TILE_BANK_VRAM, (vram_offset_t)FLOOR_TILE_OFFSET_VRAM, 
        VERA_LAYER_WIDTH_64, VERA_LAYER_HEIGHT_32,
        VERA_TILEBASE_WIDTH_16, VERA_TILEBASE_HEIGHT_16, 
        VERA_LAYER_COLOR_DEPTH_4BPP
    );
    vera_floor_layer1_show();

}

void vera_petscii_layer1() {
    vera_layer1_mode_tile( 
        FLOOR_MAP1_BANK_VRAM, (vram_offset_t)FLOOR_MAP1_OFFSET_VRAM, 
        1, (vram_offset_t)0xF000, 
        VERA_LAYER_WIDTH_64, VERA_LAYER_HEIGHT_32,
        VERA_TILEBASE_WIDTH_8, VERA_TILEBASE_HEIGHT_8, 
        VERA_LAYER_COLOR_DEPTH_1BPP
    );
    screenlayer1();
    clrscr();
    vera_floor_layer1_show();
}

void vera_floor_layer0_hide() {
    vera_layer0_hide();
}

void vera_floor_layer1_hide() {
    vera_layer1_hide();
}

void vera_floor_layer0_show() {
    vera_layer0_show();
}

void vera_floor_layer1_show() {
    vera_layer1_show();
}
