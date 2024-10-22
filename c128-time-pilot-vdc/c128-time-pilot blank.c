#include <c128.h>
#include <c128-cpu.h>
#include "c128-vdc.h"

#pragma var_model(zp)

const byte sprite_ship[63] = {
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b00000000, 0b11111111,
    0b11111111, 0b00000000, 0b11111111,
    0b11111111, 0b00000000, 0b11111111,
    0b11111111, 0b00000000, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
    0b11111111, 0b11111111, 0b11111111,
};

struct sprite_s {
    byte* sprite_ship;
    // byte** sprite_shift;
    byte* sprite_buffer;
    byte px, py;
    byte x, y;
    byte sx, sy;  
};

struct sprite_s sprites[8];

byte sprite_shift0[4*21];
byte sprite_shift1[4*21];
byte sprite_shift2[4*21];
byte sprite_shift3[4*21];
byte sprite_shift4[4*21];
byte sprite_shift5[4*21];
byte sprite_shift6[4*21];
byte sprite_shift7[4*21];

byte* sprite_shifts[8] = {sprite_shift0, sprite_shift1, sprite_shift2, sprite_shift3, sprite_shift4, sprite_shift5, sprite_shift6, sprite_shift7};

byte sprite_buffer0[128];  // Buffer to store the sprite data
byte sprite_buffer1[128];  // Buffer to store the sprite data
byte sprite_buffer2[128];  // Buffer to store the sprite data
byte sprite_buffer3[128];  // Buffer to store the sprite data
byte sprite_buffer4[128];  // Buffer to store the sprite data
byte sprite_buffer5[128];  // Buffer to store the sprite data
byte sprite_buffer6[128];  // Buffer to store the sprite data
byte sprite_buffer7[128];  // Buffer to store the sprite data

byte* sprite_buffers[8] = {sprite_buffer0, sprite_buffer1, sprite_buffer2, sprite_buffer3, sprite_buffer4, sprite_buffer5, sprite_buffer6, sprite_buffer7};

byte* screen_address = (byte*)0x4000;

const byte* c128_mmu = (byte*)0xff00;

void sprite_init() {
    for(word s = 0, t = 0; s < 8; s++, t++) {
        sprites[s].sprite_ship = sprite_ship;
        sprites[s].sprite_buffer = sprite_buffers[t]; // TODO: need to check this compiler problem with indexing.
        // sprites[s].sprite_shift = sprite_shift; 
        sprites[s].x = 255;
        sprites[s].y = 255;
        sprites[s].px = 0;
        sprites[s].py = 0;
        sprites[s].sx = 255;
        sprites[s].sy = 255;
    }    
}


void shift(byte** sprites, byte* sprite) {
    for(byte i = 0; i < 8; i++) {
        byte* dsprite = sprites[i];
        for(byte r = 0, d = 0, s = 0; r < 21; r++) {
            // shift the sprite row (24 bits) one bit to the right and store in sprites[i][r] (32 bits)
                byte byte1 = sprite[s++];
                byte byte2 = sprite[s++];
                byte byte3 = sprite[s++];
                dword row = MAKELONG(MAKEWORD(byte1, byte2), MAKEWORD(byte3, 0));
                row >>= i;
                dsprite[d++] = BYTE3(row);
                dsprite[d++] = BYTE2(row);
                dsprite[d++] = BYTE1(row);
                dsprite[d++] = BYTE0(row);
        }   
    }
}


void buffer(byte x, byte y, byte* buffer, byte* sprite) {
    byte* p = (byte*)(screen_address + (word)y * 40 + x);
    for(byte y = 0, s = 0; y < 21; y++) {
        for(byte x = 0; x < 4; x++) {
            buffer[s] = *p | sprite[s];
            s++;
            p++;
        }
        p += 40-4;
    }
}


void draw(byte x, byte y, byte* buffer) {
    word vram_address = (word)y * 32 + x;
    vdc_memcpy_32x21_vram_ram(vram_address, buffer);
}


inline void restore(byte x, byte y, byte w, byte h) {
    vdc_memcpy_xywh_vram_ram(0, screen_address, x, y, w, h);
}



void main() {

    asm { sei }  // Disable interrupts
    // Set the bank to RAM all
    *c128_mmu = 0b00001110;

    // Set the CPU to fast mode
    c128_cpu_mode_fast();
    vdc_initialize();

    vdc_write_register(VDC_R36_REFR, 0x00);  // Set DRAM refresh to minimum.

    // Example bitmap start address in VDC memory
    unsigned int bitmap_start_address = 0x0000;

    // Set the starting address in VRAM
    vdc_write_register(VDC_R18_UADH, 0);  // High byte
    vdc_write_register(VDC_R19_UADL, 0);  // Low byte

    vdc_write_register(VDC_R31_DATA, 1);

    // Configure the VDC for 320x200 bitmap mode with the specified start address
    vdc_bitmap_256x200(bitmap_start_address);

    // Clear the screen by filling the entire VRAM with zeros
    // for(byte i=0; i < 255; i++)
    byte pattern0[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    byte pattern1[8] = {0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa};
    byte pattern2[8] = {0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55};

    // screen_bitmap_320x200_background_pattern(screen_address, pattern0);
    screen_bitmap_background_pattern(screen_address, pattern1);
    // vdc_memcpy_pages_vram_ram(bitmap_start_address, screen_address, 0x20);

    sprite_init();

    shift(sprite_shifts, sprite_ship);

    byte fx[8] = {0, 0x20, 0x40, 0x60, 0x80, 0xA0, 0xC0, 0xE0};
    byte fy[8] = {0, 0x20, 0x40, 0x60, 0x80, 0xA0, 0xC0, 0xE0};
    signed char dx[8] = { 1, 1, 1, 1, 1, 1, 1, 1 };
    signed char dy[8] = { -1, -1, -1, -1, -1, -1, -1, -1 };

    while(1) {
        vdc_memcpy_lines_vram(bitmap_start_address, 25);
        for(word s = 0; s < 1; s++) {
            if(fx[s] >= 254) dx[s] = -1;
            if(fx[s] <= 2) dx[s] = 1;
            if(fy[s] >= 198) dy[s] = -1;
            if(fy[s] <= 2) dy[s] = 1;

            fx[s] += dx[s];
            fy[s] += dy[s];

            byte px = sprites[s].px;
            byte py = sprites[s].py;
            byte sx = (byte)fx[s] / 8;
            byte sy = fy[s];
            byte* sprite_buffer = sprites[s].sprite_buffer;
            byte* sprite_shift = sprite_shifts[fx[s] % 8];

            // buffer(sx, sy, sprites[s].sprite_buffer, sprite_shift);
            draw(sx, sy, sprite_shift);
            // for(word i=0; i<5000; i++);

            sprites[s].px = sx;
            sprites[s].py = sy;
        }
        // vdc_wait_vblank();
    }
    
    while(1) { }  // Infinite loop to keep the program running
}
