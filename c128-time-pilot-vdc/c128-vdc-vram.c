#include <c128.h>
#include <c128-cpu.h>
#include "c128-vdc.h"
#include "c128-resources.h"

#pragma var_model(zp)

__export char fly[32] = kickasm {{{
    .var sprite = Sprite("graphics/flies/fly_01","png",0,1,1,32,16,16,2,0,0,1,2,0,2,1)
    .var pallist = GetPalette(sprite)
    .var tiledata = MakeTile(sprite,pallist)
    .var pallistdata = MakePalette(sprite,pallist)
    Data(sprite,tiledata,pallistdata)
};}};



const byte sprite_buffer[84];

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

void sprite_init() {
    for(word s = 0, t = 0; s < 8; s++, t++) {
        sprites[s].sprite_ship = fly;
        sprites[s].x = 255;
        sprites[s].y = 255;
        sprites[s].px = 0;
        sprites[s].py = 0;
        sprites[s].sx = 255;
        sprites[s].sy = 255;
    }    
}

void shift24(byte** sprites, byte* sprite) {
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

void shift16(byte** sprites, byte* sprite) {
    for(byte i = 0; i < 8; i++) {
        byte* dsprite = sprites[i];
        for(byte r = 0, d = 0, s = 0; r < 21; r++) {
            // shift the sprite row (16 bits) one bit to the right and store in sprites[i][r] (24 bits)
                byte byte1 = sprite[s++];
                byte byte2 = sprite[s++];
                dword row = MAKELONG(MAKEWORD(byte1, byte2), MAKEWORD(0, 0));
                row >>= i;
                dsprite[d++] = BYTE3(row);
                dsprite[d++] = BYTE2(row);
                dsprite[d++] = BYTE1(row);
        }   
    }
}

byte* screen_address = (byte*)0x4000;

word vram_addresses[2] = { 0x0000, 0x2000 };
byte vram = 0;

const byte* c128_mmu = (byte*)0xff00;

inline void draw24(byte x, byte y, byte* buffer) {
    word vram_address = vram_addresses[vram] + (word)y * 32 + x;
    vdc_24x16_vram_ram(vram_address, buffer);
}

inline void draw32(byte x, byte y, byte* buffer) {
    word vram_address = vram_addresses[vram] + (word)y * 32 + x;
    vdc_32x21_vram_ram(vram_address, buffer);
}

inline void read24(byte x, byte y, byte* buffer) {
    word vram_address = vram_addresses[vram] + (word)y * 32 + x;
    vdc_24x16_ram_vram(buffer, vram_address);
}

inline void read32(byte x, byte y, byte* buffer) {
    word vram_address = vram_addresses[vram] + (word)y * 32 + x;
    vdc_32x21_ram_vram(buffer, vram_address);
}

inline void merge32(byte* buffer, byte* sprite) {
    inline for(byte b = 0; b < 84; b++) {
        buffer[b] |= sprite[b];
    }
}

inline void merge24(byte* buffer, byte* sprite) {
    inline for(byte b = 0; b < 63; b++) {
        buffer[b] |= sprite[b];
    }
}


void main() {

    asm { sei }  // Disable interrupts
    // Set the bank to RAM all
    *c128_mmu = 0b00001110;

    // Set the CPU to fast mode
    c128_cpu_mode_fast();
    vdc_initialize();

    vdc_write_register(VDC_R36_REFR, 0x00);  // Set DRAM refresh to minimum.


    // Set the starting address in VRAM
    vdc_write_register(VDC_R18_UADH, 0);  // High byte
    vdc_write_register(VDC_R19_UADL, 0);  // Low byte

    vdc_write_register(VDC_R31_DATA, 1);

    // Configure the VDC for 320x200 bitmap mode with the specified start address
    vdc_bitmap_256x200_wide(vram_addresses[vram]);
    vram ^= 1;


    sprite_init();
    shift16(sprite_shifts, fly);

    byte fx[8] = {0, 0x20, 0x40, 0x60, 0x80, 0xA0, 0xC0, 0xE0};
    byte fy[8] = {0, 0x20, 0x40, 0x60, 0x80, 0xA0, 0xC0, 0xE0};
    signed char dx[8] = { 1, 1, 1, 1, 1, 1, 1, 1 };
    signed char dy[8] = { -1, -1, -1, -1, -1, -1, -1, -1 };

    byte sp = 0x10; // Stationary position on the x axis.
    byte sd = 1; // Stationary direction.
    byte sm[8*4]; // Stationary matrix, the byte indicates the type of enemy, 0 is none.

    sm[0] = 1;
    sm[1] = 1;
    sm[2] = 1; 
    sm[3] = 1; 
    sm[4] = 1; 
    sm[5] = 1; 
    sm[6] = 1; 
    sm[7] = 1; 

    while(1) {
        vdc_wait_vblank();
        vdc_bitmap_background(vram_addresses[vram], 0);
        for(byte s = 0; s < 8; s++) {
            if(fx[s] >= 254-24) dx[s] = -1;
            if(fx[s] <= 2) dx[s] = 1;
            if(fy[s] >= 198-21) dy[s] = -1;
            if(fy[s] <= 2) dy[s] = 1;

            fx[s] += dx[s];
            fy[s] += dy[s];

            byte px = sprites[s].px;
            byte py = sprites[s].py;
            byte sx = (byte)fx[s] / 8;
            byte sy = fy[s];
            byte* sprite_shift = sprite_shifts[fx[s] % 8];
            // Read sprite into buffer;
            read24(sx, sy, sprite_buffer);
            merge24(sprite_buffer, sprite_shift);
            draw24(sx, sy, sprite_buffer);

            // draw24(sx, sy, sprite_shift);
        }

        // // Draw stationary.
        // for(byte e = 0; e < 8*4; e++) {
        //     byte x = e % 8;
        //     byte y = e / 8;
        //     byte m = sm[e];
        //     if(m) {
        //         byte* sprite_shift = sprite_shifts[fx[s] % 8];
        //         draw24(sp + x, y, sprite_shift);
        //     }
        // }
        // if(sp >= 0x28) sd = -1;
        // if(sp <= 0x10) sd = 1;
        // sp += sd;

        vdc_bitmap_start(vram_addresses[vram]);
        vram ^= 1;
    }
    
    while(1) { }  // Infinite loop to keep the program running
}
