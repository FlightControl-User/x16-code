#include <c128.h>
#include <c128-cpu.h>
#include "c128-vdc.h"

#pragma var_model(zp)


byte* screen_address = (byte*)0x4000;

word vram_addresses[2] = { 0x0000, 0x2000 };
byte vram = 0;

const byte* c128_mmu = (byte*)0xff00;


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


    // Set the starting address in VRAM
    vdc_write_register(VDC_R18_UADH, 0);  // High byte
    vdc_write_register(VDC_R19_UADL, 0);  // Low byte

    vdc_write_register(VDC_R31_DATA, 1);

    // Configure the VDC for 320x200 bitmap mode with the specified start address
    vdc_bitmap_256x200_wide(vram_addresses[vram]);
    vram ^= 1;


    // Clear the screen by filling the entire VRAM with zeros
    // for(byte i=0; i < 255; i++)
    byte pattern0[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    byte pattern1[8] = {0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa};
    byte pattern2[8] = {0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55};

    byte background = 0;

    while(1) {
        vdc_wait_vblank();
        vdc_bitmap_background(vram_addresses[vram], background++);
        vdc_bitmap_start(vram_addresses[vram]);
        vram ^= 1;
    }
    
    while(1) { }  // Infinite loop to keep the program running
}
