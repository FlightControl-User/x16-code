#include <c128.h>  // Include the standard C128 header for necessary definitions
#include "c128-vdc-defines.h"  // Include the VDC register and port definitions

void vdc_initialize();

void vdc_write_register(byte r, byte d);
void vdc_update_register(byte r, byte m, byte d);


// Prototype for the function that writes data from RAM to a specific address in VDC video memory
// void vdc_memcpy_vram_ram(unsigned int dvdc_address, unsigned char* sram_data, unsigned int length);


void vdc_memset16_vram(word vram_address, word size, byte value);

void vdc_memcpy8_vram_ram(word vram_address, const byte* sram_data, byte length);
void vdc_memcpy_lines_vram(word vram_address, byte lines);

void vdc_32x21_ram_vram(byte* buffer, word vram_address);
void vdc_32x21_vram_ram(word vram_address, byte* buffer);
void vdc_memcpy_24x21_vram_ram_offset(word vram_address, byte* buffer, byte offset);


// Prototype for the function that configures the VDC for 320x200 bitmap mode with a given start address
// void vdc_bitmap_320x200(unsigned int vram_address);
void vdc_bitmap_640x200(word start_address);
void vdc_bitmap_320x200(word start_address);

void vdc_bitmap_background_pattern(word vram, byte* pattern);
void screen_bitmap_background_pattern(byte* ram, byte* pattern);
