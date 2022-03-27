// CX16 conio.h implementation

#define __CX16__

#include <conio.h>
#include <cx16.h>
#include <cx16-veralib.h>
#include <kernal.h>

// The text screen base address, which is a 16:0 bit value in VERA VRAM.
// That is 128KB addressable space, thus 17 bits in total.
// CONIO_SCREEN_TEXT contains bits 15:0 of the address.
// CONIO_SCREEN_BANK contains bit 16, the the 64K memory bank in VERA VRAM (the upper 17th bit).
// !!! note that these values are not const for the cx16!
// This conio implements the two layers of VERA, which can be layer 0 or layer 1.
// Configuring conio to output to a different layer, will change these fields to the address base
// configured using VERA_L0_MAPBASE = 0x9f2e or VERA_L1_MAPBASE = 0x9f35.
// Using the function setscreenlayer(layer) will re-calculate using CONIO_SCREEN_TEXT and CONIO_SCREEN_BASE
// based on the values of VERA_L0_MAPBASE or VERA_L1_MAPBASE, mapping the base address of the selected layer.
// The function setscreenlayermapbase(layer,mapbase) allows to configure bit 16:9 of the
// mapbase address of the time map in VRAM of the selected layer VERA_L0_MAPBASE or VERA_L1_MAPBASE.


// This requires the following constants to be defined
// - CONIO_WIDTH - The screen width
// - CONIO_HEIGHT - The screen height
// - CONIO_SCREEN_TEXT - The text screen address
// - CONIO_SCREEN_COLORS - The color screen address
// - CONIO_TEXTCOLOR_DEFAULT - The default text color

#include <string.h>

#define CONIO_TEXTCOLOR_DEFAULT WHITE; // The default text color
#define CONIO_BACKCOLOR_DEFAULT BLUE; // The default back color

struct CX16_CONIO {
    unsigned char layer;
    unsigned int mapbase_offset; // Base pointer to the tile map base of the conio screen.
    char mapbase_bank; // Default screen of the CX16 emulator uses memory bank 0 for text.

    unsigned char width; // Variable holding the screen width;
    unsigned char height; // Variable holding the screen height;
    unsigned int mapwidth; // Variable holding the map width;
    unsigned int mapheight; // Variable holding the map height;
    unsigned char rowshift;
    unsigned int rowskip;
    unsigned char cursor; // Is a cursor whown when waiting for input (0: no, other: yes)
    unsigned char color;
    // The current cursor x-position
    unsigned char cursor_x[2];
    // The current cursor y-position
    unsigned char cursor_y[2];
    // The current text cursor line start
    unsigned int line[2];
    // Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
    // If disabled the cursor just moves back to (0,0) instead
    unsigned char scroll[2];
};


struct CX16_CONIO __conio;


// Initializer for conio.h on X16 Commander.
// #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)

// Set initial cursor position
// void conio_x16_init() {
    // Position cursor at current line
    // char * const BASIC_CURSOR_LINE = (char*)0xD6;
    // char line = *BASIC_CURSOR_LINE;
    // vera_layer1_mode_text(
    //     0, (unsigned int)0x0000, 
    //     0, (unsigned int)0xF800, 
    //     VERA_LAYER_WIDTH_128, VERA_LAYER_HEIGHT_64, 
    //     VERA_TILEBASE_WIDTH_8, VERA_TILEBASE_HEIGHT_8, 
    //     VERA_LAYER_CONFIG_16C 
    // );
    // screensize(&__conio.width, &__conio.height); // TODO, this should become a ROM call for the CX16.
    // screenlayer1();
    // textcolor(WHITE);
    // bgcolor(BLUE);
    // cursor(0);
    // if(line>=__conio.height) line=__conio.height-1;
//     gotoxy(0, 0);
// }

unsigned char kbhit (void) {
    return getin();
}

// clears the screen and moves the cursor to the upper left-hand corner of the screen.
void clrscr(void) {
    cputc(147);
}

// Set the cursor to the specified position
void gotoxy(unsigned char x, unsigned char y) {
    cbm_k_plot_set(x,y);
    // if(y>__conio.height) y = 0;
    // if(x>=__conio.width) x = 0;
    // __conio.cursor_x[__conio.layer] = x;
    // __conio.cursor_y[__conio.layer] = y;
    // unsigned int line_offset = (unsigned int)y << __conio.rowshift;
    // __conio.line[__conio.layer] = line_offset;
}

// Return the current screen size.
void screensize(unsigned char* x, unsigned char* y) {
    // VERA returns in VERA_DC_HSCALE the value of 128 when 80 columns is used in text mode,
    // and the value of 64 when 40 columns is used in text mode.
    // Basically, 40 columns mode in the VERA is a double scan mode.
    // Same for the VERA_DC_VSCALE mode, but then the subdivision is 60 or 30 rows.
    // I still need to test the other modes, but this will suffice for now for the pure text modes.
    // char hscale = (*VERA_DC_HSCALE) >> 7;
    // *x = 40 << hscale;
    // char vscale = (*VERA_DC_VSCALE) >> 7;
    // *y = 30 << vscale;
    //printf("%u, %u\n", *x, *y);
}

// Return the current screen size X width.
unsigned char screensizex() {
    return 0;
}

// Return the current screen size Y height.
unsigned char screensizey() {
    return 0;
}

// Return the X position of the cursor
unsigned char wherex(void) {
    return BYTE1(cbm_k_plot_get());
    // return __conio.cursor_x[__conio.layer];
}

// Return the Y position of the cursor
unsigned char wherey(void) {
    return BYTE0(cbm_k_plot_get());
    // return __conio.cursor_y[__conio.layer];
}

// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
void cputc(char c) {
    // char color = __conio.color;
    // unsigned int mapbase_offset = __conio.mapbase_offset;
    // unsigned int mapwidth = __conio.mapwidth;
    // unsigned int conio_addr = mapbase_offset + __conio.line[__conio.layer];

    // conio_addr += __conio.cursor_x[__conio.layer] << 1;
    if(c=='\n') {
        cputln();
    } else {
        // // Select DATA0
        // *VERA_CTRL &= ~VERA_ADDRSEL;
        // // Set address
        // *VERA_ADDRX_L = BYTE0(conio_addr);
        // *VERA_ADDRX_M = BYTE1(conio_addr);
        // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1;
        // *VERA_DATA0 = c;
        // *VERA_DATA0 = color;

        cbm_k_chrout(c);

        // __conio.cursor_x[__conio.layer]++;
        // unsigned char scroll_enable = __conio.scroll[__conio.layer];
        // if(scroll_enable) {
        //     if(__conio.cursor_x[__conio.layer] == __conio.width)
        //         cputln();
        // } else {
        //     if((unsigned int)__conio.cursor_x[__conio.layer] == mapwidth)
        //         cputln();
        // }
    }
}

// Print a newline
void cputln() {
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    // unsigned int temp = __conio.line[__conio.layer];
    // temp += __conio.rowskip;
    // __conio.line[__conio.layer] = temp;
    // __conio.cursor_x[__conio.layer] = 0;
    // __conio.cursor_y[__conio.layer]++;
    // cscroll();
    cbm_k_chrout(13);
}

void clearline() {
    // Select DATA0
    // *VERA_CTRL &= ~VERA_ADDRSEL;
    // // Set address
    // unsigned int mapbase_offset =  (unsigned int)__conio.mapbase_offset;
    // unsigned int conio_line = __conio.line[__conio.layer];
    // unsigned char* addr = (unsigned char*)( mapbase_offset + conio_line );
    // *VERA_ADDRX_L = BYTE0(addr);
    // *VERA_ADDRX_M = BYTE1(addr);
    // *VERA_ADDRX_H = VERA_INC_1; // TODO need to check this!
    // char color = __conio.color;
    // for( unsigned int c=0;c<__conio.width; c++ ) {
    //     // Set data
    //     *VERA_DATA0 = ' ';
    //     *VERA_DATA0 = color;
    // }
    // __conio.cursor_x[__conio.layer] = 0;
}

// Insert a new line, and scroll the lower part of the screen down.
void insertdown(unsigned char rows) {
    // unsigned char cy = __conio.height - __conio.cursor_y[__conio.layer];
    // cy -= 1;
    // unsigned char width = __conio.width * 2;
    // for(unsigned char i=cy; i>0; i--) {
    //     unsigned int line = (__conio.cursor_y[__conio.layer] + i - 1) << __conio.rowshift;
    //     unsigned int start = __conio.mapbase_offset + line;
    //     memcpy_vram_vram_inc(0, start+__conio.rowskip, VERA_INC_1, 0, start, VERA_INC_1, width);
    // }
    // clearline();
}

// Insert a new line, and scroll the upper part of the screen up.
void insertup() {
    // unsigned char cy = __conio.cursor_y[__conio.layer];
    // unsigned char width = __conio.width * 2;
    // for(unsigned char i=1; i<=cy; i++) {
    //     unsigned int line = (i-1) << __conio.rowshift;
    //     unsigned int start = __conio.mapbase_offset + line;
    //     memcpy_vram_vram_inc(0, start, VERA_INC_1, 0, start+__conio.rowskip, VERA_INC_1, width);
    // }
    // clearline();
}

// Scroll the entire screen if the cursor is beyond the last line
void cscroll() {
    // not needed.
}


// Output a NUL-terminated string at the current cursor position
void cputs(const char* s) {
    char c;
    while(c=*s++)
        cputc(c);
}

// Move cursor and output one character
// Same as "gotoxy (x, y); cputc (c);"
void cputcxy(unsigned char x, unsigned char y, char c) {
    gotoxy(x, y);
    cputc(c);
}

// Move cursor and output a NUL-terminated string
// Same as "gotoxy (x, y); puts (s);"
void cputsxy(unsigned char x, unsigned char y, const char* s) {
    gotoxy(x, y);
    cputs(s);
}

// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
unsigned char cursor(unsigned char onoff) {
    // not functional on the CX16 (yet).
    return 0;
}

// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 0, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
unsigned char scroll(unsigned char onoff) {
    // char old = __conio.scroll[__conio.layer];
    // __conio.scroll[__conio.layer] = onoff;
    return 0;
}

// --- Defined in cx16.c and cx16-vera.h ---

// --- layer management in VERA ---



// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
void screenlayer0() {
    // __conio.layer = 0;
    // __conio.mapbase_bank = vera_layer0_get_mapbase_bank();
    // __conio.mapbase_offset = vera_layer0_get_mapbase_offset();
    // __conio.mapwidth = vera_layer0_get_width();
    // __conio.mapheight = vera_layer0_get_height();
    // __conio.rowshift = vera_layer0_get_rowshift();
    // __conio.rowskip = vera_layer0_get_rowskip();
}


// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
void screenlayer1() {
    // __conio.layer = 1;
    // __conio.mapbase_bank = vera_layer1_get_mapbase_bank();
    // __conio.mapbase_offset = vera_layer1_get_mapbase_offset();
    // __conio.mapwidth = vera_layer1_get_width();
    // __conio.mapheight = vera_layer1_get_height();
    // __conio.rowshift = vera_layer1_get_rowshift();
    // __conio.rowskip = vera_layer1_get_rowskip();
}


// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
char textcolor(char color) {
    char chrs[16] = {144, 5, 28, 159, 156, 30, 31, 158, 129, 149, 150, 151, 152, 153, 154, 155};
    char chr = chrs[color];
    cputc(chr);
    return 0;
}

// Set the back color for text output. The old back text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
char bgcolor(char color) {
    char chrs[16] = {144, 5, 28, 159, 156, 30, 31, 158, 129, 149, 150, 151, 152, 153, 154, 155};
    char chr = chrs[color];
    cputc(1);
    cputc(chr);
    cputc(1);
    return 0;
}

// Set the color for the border. The old color setting is returned.
char bordercolor(unsigned char color) {
    // The border color register address
    char old = *VERA_DC_BORDER;
    *VERA_DC_BORDER = color;
    return 0;
}

