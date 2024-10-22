#include "c128-vdc.h"

struct vdc_configuration {
    byte vdc_mode;
    byte vdc_type;
    byte xbytes;
};

struct vdc_configuration vdc_config = {0, 0, 80};

void inline vdc_wait() {
    asm {
    !:  bit VDC_REGISTER_PORT
        bpl !-
    }
}

void inline vdc_wait_vblank() {
    asm {
        lda #$20
    !:
        bit VDC_REGISTER_PORT
        beq !-
    }
}

void inline vdc_wait_novblank() {
    asm {
        lda #$20
    !:
        bit VDC_REGISTER_PORT
        bne !-
    }
}

void inline vdc_register(byte r) {
    // Write the register address to VDC_REGISTER_PORT
    *VDC_REGISTER_PORT = r;
}

byte inline vdc_read() {
    // Read the data from the VDC_DATA_PORT
    vdc_wait();
    byte d = *VDC_DATA_PORT;
    return d;
}

byte inline vdc_read_nowait() {
    // Read the data from the VDC_DATA_PORT
    byte d = *VDC_DATA_PORT;
    return d;
}

void inline vdc_write(byte d) {
    // Write the data to the VDC_DATA_PORT
    vdc_wait();
    *VDC_DATA_PORT = d;
}

void inline vdc_write_nowait(byte d) {
    // Write the data to the VDC_DATA_PORT
    *VDC_DATA_PORT = d;
}

void inline vdc_write_register(byte r, byte d) {
    vdc_register(r);
    vdc_write(d);
} 

void inline vdc_write_register_nowait(byte r, byte d) {
    vdc_register(r);
    vdc_write_nowait(d);
} 

void vdc_update_register(byte r, byte m, byte d) {
    vdc_register(r);
    byte rd = vdc_read();
    rd = (rd & ~m) | d;
    vdc_write(rd);
}


void vdc_initialize() {

    byte vdc_init[38] = {
        0x7e, 0x50, 0x66, 0x49, 0x20, 0xe0, 0x19, 0x1d,
        0xfc, 0xe7, 0xe0, 0xf0, 0x00, 0x00, 0x20, 0x00,
        0xff, 0xff, 0x00, 0x00, 0x08, 0x00, 0x78, 0xe8,
        0x20, 0xff, 0xf0, 0x00, 0x2f, 0xe7, 0xff, 0xff,
        0xff, 0xff, 0x7d, 0x64, 0xf5
    };

    byte vdc_mode = *VDC_REGISTER_PORT;
    vdc_config.vdc_mode = vdc_mode;

    byte vdc_value = 0x47;
    byte vdc_type = vdc_mode & 0x03;
    vdc_config.vdc_type = vdc_type;
    if(!vdc_type) {
        vdc_value = 0x40;
    }
    vdc_write_register(VDC_R25_MODE, vdc_value);

    for(byte r = 0; r < 37; r++) {
        if(vdc_init[r] != 0xff) {
            vdc_write_register(r, vdc_init[r]);
        }
    }

    vdc_write_register(VDC_R37_SYPL, 0xff);

    // Patch for PAL systems
    byte vdc_pal = *((byte*)0x2a6);
    if(!vdc_pal) {
        vdc_write_register(VDC_R4_VTOT, 0x27);
        vdc_write_register(VDC_R7_VSST, 0x20);
    }

 }

void vdc_memset16_vram(word vram_address, word size, byte value) {

    // Set the starting address in VRAM
    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));  // High byte
    vdc_write_register(VDC_R19_UADL, BYTE0(vram_address));  // Low byte

    for(byte i = 0; i < BYTE1(size); i++) {
        for(byte j = 255; j > 0; j--) {
            vdc_write_register(VDC_R31_DATA, value);
        }
        vdc_write_register(VDC_R31_DATA, value);
    }
    for(byte i = 0; i < BYTE0(size); i++) {
        vdc_write_register(VDC_R31_DATA, value);
    }
}

void vdc_memset16_vram2(word vram_address, word size, byte value1, byte value2) {

    // Set the starting address in VRAM
    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));  // High byte
    vdc_write_register(VDC_R19_UADL, BYTE0(vram_address));  // Low byte

    for(byte i = 0; i < BYTE1(size); i++) {
        for(byte j = 255; j > 1; j-=2) {
            vdc_write_register(VDC_R31_DATA, value1);
            vdc_write_register(VDC_R31_DATA, value2);
        }
        vdc_write_register(VDC_R31_DATA, value1);
        vdc_write_register(VDC_R31_DATA, value2);
    }
    for(byte i = 0; i < BYTE0(size); i+=2) {
        vdc_write_register(VDC_R31_DATA, value1);
        vdc_write_register(VDC_R31_DATA, value2);
    }
}

// Function to copy data from RAM to VRAM
void vdc_memcpy8_vram_ram(word vram_address, const byte* sram_data, byte length) {
    // Set the VDC address to the target VRAM location
    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));   // Set high byte of address
    vdc_write_register(VDC_R19_UADL, BYTE0(vram_address)); // Set low byte of address

    // Write the data byte by byte to the VDC
    for (byte i = 0; i < length; i++) {
        vdc_write_register(VDC_R31_DATA, sram_data[i]);
        // *VDC_DATA_PORT = sram_data[i];  // Write a byte to the VDC data port
    }
}

// Function to copy data from RAM to VRAM
void vdc_memcpy_lines_vram(word vram_address, byte lines) {
    vdc_wait_vblank();
    vdc_write_register_nowait(VDC_R36_REFR, 0x00);  // Set the refresh rate to 0x00
    // Set the VDC address to the target VRAM location
    vdc_write_register_nowait(VDC_R18_UADH, BYTE1(vram_address));   // Set high byte of address
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address)); // Set low byte of address
    vdc_register(VDC_R31_DATA);
    // vdc_wait();

    // Write the data byte by byte to the VDC
    const byte *sram_data = (char*)$4000;
    inline for(byte l: 0..200) {
        for(byte col: 0..31 ) {
            while(!(*VDC_REGISTER_PORT & 0x80));
            byte *b = (sram_data+l*32);
            *VDC_DATA_PORT = b[col];
        }
    }
}

// Function to copy data from RAM to VRAM
void vdc_memclr_pages_vram(word vram_address, byte pages) {
    vdc_wait_vblank();
    // Set the VDC address to the target VRAM location
    vdc_write_register_nowait(VDC_R18_UADH, BYTE1(vram_address));   // Set high byte of address
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address)); // Set low byte of address
    vdc_register(VDC_R31_DATA);
    // vdc_wait();

    // Write the data byte by byte to the VDC
    for(byte p = 0; p < pages; p++) {
        inline for (byte m: 0..127 ) {
            *VDC_DATA_PORT = 0;
        }
        inline for (byte m: 0..127 ) {
            *VDC_DATA_PORT = 0;
        }
    }
    vdc_wait_novblank();
}



inline void vdc_memcpy_xywh_vram_ram(word vram_address, byte* screen, byte x, byte y, byte w, byte h) {
    word p = ((word)y * 40) + x;
    vram_address += p;
    for (byte r = 0; r < h; r++) {
        // Set the VRAM address for this row
        vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));  // Set high byte of VRAM address
        vdc_write_register(VDC_R19_UADL, BYTE0(vram_address));  // Set low byte of VRAM address

        // Write the sprite data from the RAM buffer to the VDC VRAM
        vdc_register(VDC_R31_DATA);  // Prepare VDC to write data to VRAM
        for(byte c = 0; c < w; c++) {
            vdc_write(screen[p++]);      // Write the first byte of the row
        }

        p += 40 - w;

        // Move to the next row
        vram_address += vdc_config.xbytes;
    }
}

inline void vdc_32x21_vram_ram(word vram_address, byte* buffer) {
    for (byte row = 0, p = 0; row < 21; row++) {
        // Set the VRAM address for this row
        vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));  // Set high byte of VRAM address
        vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));  // Set low byte of VRAM address

        // Write the sprite data from the RAM buffer to the VDC VRAM
        vdc_register(VDC_R31_DATA);  // Prepare VDC to write data to VRAM
        vdc_write(buffer[p++]);      // Write the first byte of the row
        vdc_write(buffer[p++]);      // Write the second byte of the row
        vdc_write(buffer[p++]);      // Write the third byte of the row
        vdc_write(buffer[p++]);      // Write the fourth byte of the row

        // Move to the next row
        vram_address += vdc_config.xbytes;
    }
}

inline void vdc_24x16_vram_ram(word vram_address, byte* buffer) {
    // Set the VRAM address for this row
    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));  // Set high byte of VRAM address
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));  // Set low byte of VRAM address
    // Write the sprite data from the RAM buffer to the VDC VRAM
    vdc_register(VDC_R31_DATA);  // Prepare VDC to write data to VRAM
    vdc_write(buffer[00]);      
    vdc_write(buffer[01]);      
    vdc_write(buffer[02]);      
    // Move to the next row
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[03]);      
    vdc_write(buffer[04]);      
    vdc_write(buffer[05]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[06]);      
    vdc_write(buffer[07]);      
    vdc_write(buffer[08]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[09]);      
    vdc_write(buffer[10]);      
    vdc_write(buffer[11]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[12]);      
    vdc_write(buffer[13]);      
    vdc_write(buffer[14]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[15]);      
    vdc_write(buffer[16]);      
    vdc_write(buffer[17]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[18]);      
    vdc_write(buffer[19]);      
    vdc_write(buffer[20]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[21]);      
    vdc_write(buffer[22]);      
    vdc_write(buffer[23]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[24]);      
    vdc_write(buffer[25]);      
    vdc_write(buffer[26]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[27]);      
    vdc_write(buffer[28]);      
    vdc_write(buffer[29]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[30]);      
    vdc_write(buffer[31]);      
    vdc_write(buffer[32]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[33]);      
    vdc_write(buffer[34]);      
    vdc_write(buffer[35]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[36]);      
    vdc_write(buffer[37]);      
    vdc_write(buffer[38]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[39]);      
    vdc_write(buffer[40]);      
    vdc_write(buffer[41]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[42]);      
    vdc_write(buffer[43]);      
    vdc_write(buffer[44]);      
    vram_address += vdc_config.xbytes;

    vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
    vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));
    vdc_register(VDC_R31_DATA);
    vdc_write(buffer[45]);      
    vdc_write(buffer[46]);      
    vdc_write(buffer[47]);      
    vram_address += vdc_config.xbytes;
}

inline void vdc_32x21_ram_vram(byte* buffer, word vram_address) {
    for (byte row = 0, b = 0; row < 21; row++) {
        // Set the VRAM address for this row
        vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));  // Set high byte of VRAM address
        vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));  // Set low byte of VRAM address

        // Write the sprite data from the RAM buffer to the VDC VRAM
        vdc_register(VDC_R31_DATA);  // Prepare VDC to write data to VRAM
        buffer[b++] = vdc_read();
        buffer[b++] = vdc_read();
        buffer[b++] = vdc_read();
        buffer[b++] = vdc_read();

        // Move to the next row
        vram_address += vdc_config.xbytes;
    }
}

inline void vdc_24x16_ram_vram(byte* buffer, word vram_address) {
    for (byte row = 0, b = 0; row < 16; row++) {
        // Set the VRAM address for this row
        vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));  // Set high byte of VRAM address
        vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram_address));  // Set low byte of VRAM address

        // Write the sprite data from the RAM buffer to the VDC VRAM
        vdc_register(VDC_R31_DATA);  // Prepare VDC to write data to VRAM
        buffer[b++] = vdc_read();
        buffer[b++] = vdc_read();
        buffer[b++] = vdc_read();

        // Move to the next row
        vram_address += vdc_config.xbytes;
    }
}

void vdc_memcpy_24x21_vram_ram_offset(word vram_address, byte* buffer, byte offset) {
    for (byte row = 0, p = 0; row < 21; row++) {
        byte sprite_byte1 = buffer[p++];
        byte sprite_byte2 = buffer[p++];
        byte sprite_byte3 = buffer[p++];

        dword shift = MAKELONG(MAKEWORD(sprite_byte1, sprite_byte2), MAKEWORD(sprite_byte3,0));

        shift >>= offset;

        // Write the sprite data to VRAM
        vdc_write_register(VDC_R18_UADH, BYTE1(vram_address));
        vdc_write_register(VDC_R19_UADL, BYTE0(vram_address));

        vdc_register(VDC_R31_DATA);
        vdc_write(BYTE3(shift));
        vdc_write(BYTE2(shift));
        vdc_write(BYTE1(shift));
        vdc_write(BYTE0(shift));

        vram_address += vdc_config.xbytes;
    }
}



void vdc_bitmap_640x200(word start_address) {
    vdc_write_register(VDC_R12_SAH, BYTE1(start_address));  // Display Start Address High Byte
    vdc_write_register(VDC_R13_SAL, BYTE0(start_address));  // Display Start Address Low Byte
    vdc_write_register(VDC_R25_MODE, 0x80);  // Mode Bitmap / Text: Set to Bitmap Mode    
    vdc_config.xbytes = 80;
}


void vdc_bitmap_320x200(word start_address) {

    // Set the mode to 320x200 bitmap mode with double-width pixels
    vdc_write_register(VDC_R25_MODE, VDC_R25_MODE_7_MODE_SELECT   // Set to Bitmap Mode
|       VDC_R25_MODE_4_PIXEL_DOUBLE_WIDTH);  // Enable Pixel Double Width for 320x200 mode

    if(vdc_config.vdc_type)
        vdc_update_register(VDC_R25_MODE, 0x07, 0x07);

    vdc_write_register(VDC_R22_CTHO, 0x89); // Character width 9.

    vdc_write_register(VDC_R27_INCR, 0x00); // Wait byte to remove dot noise on the right edge.

    vdc_write_register(VDC_R2_HSST, 55); // Bitmap mode.


    // vdc_update_register(VDC_R25_MODE, VDC_R25_MODE_7_MODE_SELECT, VDC_R25_MODE_7_MODE_SELECT_BITMAP);
    vdc_write_register(VDC_R0_HTOT, 64); // 64 clock cycles per rasterline.
    vdc_write_register(VDC_R1_HDIS, 40); // 40 characters visible character displayed per line.

    // Set the display start address
    vdc_write_register(VDC_R12_SAH, BYTE1(start_address));  // Display Start Address High Byte
    vdc_write_register(VDC_R13_SAL, BYTE0(start_address));  // Display Start Address Low Byte

    vdc_config.xbytes = 40;
}

void vdc_bitmap_256x200(word start_address) {

    // Set the mode to 256x200 bitmap mode with double-width pixels
    vdc_write_register(VDC_R25_MODE, VDC_R25_MODE_7_MODE_SELECT | 0x07);

    // if(vdc_config.vdc_type)
    //     vdc_update_register(VDC_R25_MODE, 0x07, 0x07);

    vdc_write_register(VDC_R1_HDIS, 32); // 32 characters visible character displayed per line.
    vdc_write_register(VDC_R0_HTOT, 127); // All of horizontal columns.

    vdc_write_register(VDC_R2_HSST, 78); // Bitmap mode.

    vdc_write_register(VDC_R22_CTHO, 0x78); // Character width 9.

    // Set the display start address
    vdc_write_register(VDC_R12_SAH, BYTE1(start_address));  // Display Start Address High Byte
    vdc_write_register(VDC_R13_SAL, BYTE0(start_address));  // Display Start Address Low Byte

    vdc_config.xbytes = 32;
}

void vdc_bitmap_256x200_wide(word start_address) {

    // Set the mode to 256x200 bitmap mode with double-width pixels
    vdc_write_register(VDC_R25_MODE, VDC_R25_MODE_7_MODE_SELECT | VDC_R25_MODE_4_PIXEL_DOUBLE_WIDTH | 0x07);

    // if(vdc_config.vdc_type)
    //     vdc_update_register(VDC_R25_MODE, 0x07, 0x07);

    vdc_write_register(VDC_R1_HDIS, 32); // 32 characters visible character displayed per line.
    vdc_write_register(VDC_R0_HTOT, 63); // All of horizontal columns.


    vdc_write_register(VDC_R22_CTHO, 0x89); // Character width 9.

    vdc_write_register(VDC_R2_HSST, 51); // Bitmap mode.
    // Set the display start address
    vdc_write_register(VDC_R12_SAH, BYTE1(start_address));  // Display Start Address High Byte
    vdc_write_register(VDC_R13_SAL, BYTE0(start_address));  // Display Start Address Low Byte

    vdc_write_register(VDC_R36_REFR, 0);  // Set DRAM refresh to minimum.

    vdc_config.xbytes = 32;
}

void vdc_bitmap_start(word vram) {
    // Set the display start address
    vdc_write_register(VDC_R12_SAH, BYTE1(vram));  // Display Start Address High Byte
    vdc_write_register(VDC_R13_SAL, BYTE0(vram));  // Display Start Address Low Byte
}

void vdc_bitmap_background_pattern(word vram, byte* pattern) {

    // Set the starting address in VRAM
    vdc_write_register(VDC_R18_UADH, BYTE1(vram));  // High byte
    vdc_write_register(VDC_R19_UADL, BYTE0(vram));  // Low byte

    vdc_register(VDC_R31_DATA);

    for(byte y = 0; y < 200; y++) {
        byte pixels = pattern[y % 8]; 
        for(byte x = 0; x < vdc_config.xbytes; x++) {
            vdc_write(pixels);
        }
    }
}

void vdc_bitmap_background(word vram, byte b) {

    for(byte y = 0; y < 200; y++) {
        // Set the starting address in VRAM
        vdc_write_register(VDC_R18_UADH, BYTE1(vram));  // High byte
        vdc_write_register_nowait(VDC_R19_UADL, BYTE0(vram));  // Low byte

        vdc_register(VDC_R31_DATA);
        vdc_write(b);
        vdc_write_register(VDC_R24_VSST, 0);
        vdc_write_register(VDC_R30_WORD, 31);
        vram+=32;
        // Block set of the next 31 bytes of the row.
    }
    vdc_write_register(VDC_R30_WORD, 0);

}

void screen_bitmap_background_pattern(byte* ram, byte* pattern) {

    for(byte y = 0; y < 200; y++) {
        byte pixels = pattern[y % 8]; 
        for(byte x = 0; x < vdc_config.xbytes; x++) {
            *ram = pixels;
            ram++;
        }
    }
}

