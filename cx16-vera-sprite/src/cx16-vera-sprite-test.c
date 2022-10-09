/**
 * @file cx16-vera-48x48.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief A little demo program to test sprites and to tweak sprite registers for future enhancements on vera.
 * @version 0.1
 * @date 2022-10-08
 * 
 * @copyright Copyright (c) 2022
 * 
 */

// #define __DEBUG_FILE

#pragma link("cx16-vera-sprite.ld")
#pragma encoding(petscii_mixed)
// #pragma cpu(mos6502)


#pragma var_model(zp)

// #pragma var_model(mem)

#include "cx16-vera-sprite.h"

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <6502.h>
#include <kernal.h>
#include <printf.h>
#include <division.h>
#include <mos6522.h>
#include <multiply.h>

#include <cx16.h>
#include <cx16-veralib.h>
#include <cx16-mouse.h>
#include <cx16-heap-bram-fb.h>


sprite_offsets_t offsets[6];

heap_structure_t heap; const heap_structure_t* heap_bram = &heap;

fb_heap_segment_t heap_64; const fb_heap_segment_t* bin64 = &heap_64;
fb_heap_segment_t heap_128; const fb_heap_segment_t* bin128 = &heap_128;
fb_heap_segment_t heap_256; const fb_heap_segment_t* bin256 = &heap_256;
fb_heap_segment_t heap_512; const fb_heap_segment_t* bin512 = &heap_512;
fb_heap_segment_t heap_1024; const fb_heap_segment_t* bin1024 = &heap_1024;
fb_heap_segment_t heap_2048; const fb_heap_segment_t* bin2048 = &heap_2048;

#define sprite_count 16
sprite_file_t sprite_files[sprite_count] = {
    { "s408x08.bin" },  // 0000
    { "s416x08.bin" },  // 0001
    { "s432x08.bin" },  // 0010
    { "s464x08.bin" },  // 0011
    { "s408x16.bin" },  // 0100
    { "s416x16.bin" },  // 0101
    { "s432x16.bin" },  // 0110
    { "s464x16.bin" },  // 0111
    { "s408x32.bin" },  // 1000
    { "s416x32.bin" },  // 1001
    { "s432x32.bin" },  // 1010
    { "s464x32.bin" },  // 1011
    { "s408x64.bin" },  // 1100
    { "s416x64.bin" },  // 1101
    { "s432x64.bin" },  // 1110
    { "s464x64.bin" }   // 1111
};

sprite_t sprites[sprite_count];

unsigned char palette[32];

unsigned char bit_register(unsigned r, unsigned m)
{
    return r&m?'1':'0';
}

void print_register(unsigned char r)
{
    printf("%c%c%c%c%c%c%c%c", 
        bit_register(r,0x80), bit_register(r,0x40), bit_register(r,0x20), bit_register(r,0x10),
        bit_register(r,0x08), bit_register(r,0x04), bit_register(r,0x02), bit_register(r,0x01)
    );
}

void print_registers(unsigned char sprite) 
{
    struct VERA_SPRITE sprite_attr;
    unsigned char x = sprite*10+12;

    gotoxy(x,4);
    vera_sprite_offset sprite_offset = offsets[sprite].offset;
    printf("%02x", sprite_offset);

    unsigned char y = 6;
    gotoxy(x,y);
    vera_sprite_attributes_get(sprite_offset, &sprite_attr);
    print_register(BYTE0(sprite_attr.ADDR));
    gotoxy(x,++y);
    print_register(BYTE1(sprite_attr.ADDR));
    gotoxy(x,++y);
    print_register(BYTE0(sprite_attr.X));
    gotoxy(x,++y);
    print_register(BYTE1(sprite_attr.X));
    gotoxy(x,++y);
    print_register(BYTE0(sprite_attr.Y));
    gotoxy(x,++y);
    print_register(BYTE1(sprite_attr.Y));
    gotoxy(x,++y);
    print_register(sprite_attr.CTRL1);
    gotoxy(x,++y);
    print_register(sprite_attr.CTRL2);
}

void print_width_height(unsigned char sprite) 
{
    unsigned char x = sprite*10+12;
    unsigned char y = 40;
    vera_sprite_offset sprite_offset = offsets[sprite].offset;
    gotoxy(x,y);
    printf("%03u %03u",vera_sprite_width_get_value(vera_sprite_width_get(sprite_offset)), vera_sprite_height_get_value(vera_sprite_height_get(sprite_offset)));
}

void print_xy(unsigned char sprite) 
{
    unsigned char x = sprite*10+12;
    unsigned char y = 41;
    vera_sprite_offset sprite_offset = offsets[sprite].offset;
    gotoxy(x,y);
    printf("%03i %03i",vera_sprite_x_get(sprite_offset), vera_sprite_y_get(sprite_offset));
}

void print_size(unsigned char sprite) 
{
    unsigned char x = sprite*10+12;
    unsigned char y = 42;
    vera_sprite_offset sprite_offset = offsets[sprite].offset;
    gotoxy(x,y);
    printf("%05u", sprites[sprite].size);
}

void print_bpp(unsigned char sprite) 
{
    unsigned char x = sprite*10+12;
    unsigned char y = 43;
    vera_sprite_offset sprite_offset = offsets[sprite].offset;
    gotoxy(x,y);
    printf("%01u", vera_sprite_bpp_get_value(vera_sprite_bpp_get(sprite_offset)));
}

void sprite_header(sprite_file_header_t* sprite_file_header, sprite_t* sprite)
{
    // printf("header size=%02x, width=%02x, height=%02x, zdepth=%02x, bpp=%02x\n", sprite_file_header->size, sprite_file_header->width, sprite_file_header->height, sprite_file_header->zdepth, sprite_file_header->bpp);
    sprite->size = sprite_file_header->size;
    sprite->width = vera_sprite_width_get_bitmap(sprite_file_header->width);
    sprite->height = vera_sprite_height_get_bitmap(sprite_file_header->height);
    sprite->zdepth = vera_sprite_zdepth_get_bitmap(sprite_file_header->zdepth);
    sprite->hflip = vera_sprite_hflip_get_bitmap(sprite_file_header->hflip);
    sprite->vflip = vera_sprite_vflip_get_bitmap(sprite_file_header->vflip);
    sprite->bpp = vera_sprite_bpp_get_bitmap(sprite_file_header->bpp);
    sprite->palette = sprite_file_header->palette_offset;
    // printf("sprite size=%02x, width=%02x, height=%02x, zdepth=%02x, bpp=%02x\n", sprite->size, sprite->width, sprite->height, sprite->zdepth, sprite->bpp);
}


void sprite_load(sprite_t* sprite, char* filename)
{

    unsigned char status = file_open(1, 8, 2, filename);
    if (status) printf("error opening file %s\n", filename);

    strcpy(sprite->file, filename);

    sprite_file_header_t sprite_file_header;

    // Read the header of the file into the sprite_file_header structure.
    unsigned int read = file_load_size(1, 8, 2, 0, (char*)&sprite_file_header, 16);
    if (!read)
        printf("error loading header file %s, status = %u\n", filename, read);
    sprite_header(&sprite_file_header, sprite);

    heap_bram_fb_handle_t bram_handle = heap_alloc(heap_bram, sprite->size);
    heap_bram_fb_bank_t bram_bank = heap_bram_fb_bank_get(bram_handle);
    heap_bram_fb_ptr_t bram_ptr = heap_bram_fb_ptr_get(bram_handle);
    read = file_load_size(1, 8, 2, bram_bank, bram_ptr, sprite->size);
    if (!read) {
        printf("error loading file %s, status = %u\n", filename, read);
    }
    sprite->bram = bram_handle;

    status = file_close(1);
    if (status) printf("error closing file %s\n", filename);
}

void palette_load(char* palette, char* filename)
{

    unsigned char status = file_open(1, 8, 2, filename);
    if (status) printf("error opening file %s\n", filename);

    unsigned int read = file_load_size(1, 8, 2, 0, palette, 32);
    if (!read) {
        printf("error loading file %s, status = %u\n", filename, read);
    }

    status = file_close(1);
    if (status) printf("error closing file %s\n", filename);
}

void main() {

    // We are going to use only the kernal on the X16.
    // bank_set_brom(CX16_ROM_KERNAL);

    // We create the heap blocks in BRAM using the Fixed Block Heap Memory Manager.
    heap_segment_base(heap_bram, 16, (heap_bram_fb_ptr_t)0xA000); // We set the heap to start in BRAM, bank 8. 
    heap_segment_define(heap_bram, bin64, 64, 12, 64*12);
    heap_segment_define(heap_bram, bin128, 128, 12, 128*12);
    heap_segment_define(heap_bram, bin256, 256, 12, 256*12);
    heap_segment_define(heap_bram, bin512, 512, 12, 512*12);
    heap_segment_define(heap_bram, bin1024, 1024, 12, 1024*12);
    heap_segment_define(heap_bram, bin2048, 2048, 12, 2048*12);

    unsigned char sprite = 0;


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
    vera_layer1_show();
    vera_layer0_hide();
    scroll(0);

    cx16_mouse_config(0xFF, 80, 60);
    // memset_vram(1, 0x0000, 0, 16);

    cx16_mouse_get();

    for(unsigned int f=0; f<sprite_count; f++) {
        sprite_load(&sprites[f], sprite_files[f].file);
    }

    palette_load(palette, "palette.bin");
    memcpy_vram_bram(VERA_PALETTE_BANK, (vram_offset_t)VERA_PALETTE_PTR+32, 0, palette, 32);

    printf("sprite configuration tester");

    gotoxy(0, 4);
    printf("sprite\n");
    printf("----------  --------  --------  --------  --------  --------  --------\n");
    printf("register 0\n");
    printf("register 1\n");
    printf("register 2\n");
    printf("register 3\n");
    printf("register 4\n");
    printf("register 5\n");
    printf("register 6\n");
    printf("register 7\n");


    gotoxy(0,40);
    printf("wid/hei\n");
    printf("x/y pos\n");
    printf("size\n");
    printf("bpp\n");

    gotoxy(0,50);
    printf("config:     (q)       (b)       (c)       (d)       (e)       (f)\n");
    printf("offset next:(+) / prev:(-)   sprite position x:(a)/(s) / y:(z)/(w)\n");
    printf("zdepth show:(s) / hide:(h) / layer:(j) / background:(v)\n");
    printf("width prev:(i) / next:(o)   height prev:(k) / next:(l)\n");
    printf("register select next:(n) prev:(p)\n");
    printf("register switch bit 0:(0) 1:(1) 2:(2) 3:(3) 4:(4) 5:(5) 6:(6) 7:(7)\n");

    unsigned char ch = getin();

    for(unsigned int s=0; s<6; s++) {
        vram_bank_t vram_image_bank = 0;
        vram_offset_t vram_image_offset = (unsigned int)s*64*64;
        bram_bank_t bram_bank = heap_bram_fb_bank_get(sprites[s].bram);
        bram_ptr_t bram_ptr = heap_bram_fb_ptr_get(sprites[s].bram);
        unsigned int sprite_size = sprites[s].size;
        offsets[s].offset = vera_sprite_get_offset((unsigned char)s+1);
        vera_sprite_offset sprite_offset = offsets[s].offset;

        memcpy_vram_bram(vram_image_bank, vram_image_offset, bram_bank, bram_ptr, sprite_size);
        vera_sprite_bpp(sprite_offset, sprites[s].bpp);
        vera_sprite_width(sprite_offset, sprites[s].width);
        vera_sprite_height(sprite_offset, sprites[s].height);
        vera_sprite_set_xy(sprite_offset, (signed int)(12*8+s*(8*10)), (signed int)(8*16));
        vera_sprite_set_image_offset(sprite_offset, vera_sprite_get_image_offset(vram_image_bank, vram_image_offset));
        vera_sprite_zdepth_in_front(sprite_offset);
        vera_sprite_palette_offset(sprite_offset, 1);
    }

    vera_sprites_show();

    while(ch != 'x') {

        switch(ch) {
            case 'q':
                sprite = 0;
                break;
            case 'b':
                sprite = 1;
                break;
            case 'c':
                sprite = 2;
                break;
            case 'd':
                sprite = 3;
                break;
            case 'e':
                sprite = 4;
                break;
            case 'f':
                sprite = 5;
                break;
            case '+':
                offsets[sprite].offset+=8;
                break;
            case '-':
                offsets[sprite].offset-=8;
                break; 
        }

        vera_sprite_offset sprite_offset = offsets[sprite].offset;
        
        switch(ch) {
            case 'a':
                vera_sprite_set_xy(sprite_offset, vera_sprite_x_get(sprite_offset)-1, vera_sprite_y_get(sprite_offset));
                break;
            case 's':
                vera_sprite_set_xy(sprite_offset, vera_sprite_x_get(sprite_offset)+1, vera_sprite_y_get(sprite_offset));
                break;
            case 'w':
                vera_sprite_set_xy(sprite_offset, vera_sprite_x_get(sprite_offset), vera_sprite_y_get(sprite_offset)-1);
                break;
            case 'z':
                vera_sprite_set_xy(sprite_offset, vera_sprite_x_get(sprite_offset), vera_sprite_y_get(sprite_offset)+1);
                break;
            case 'o':
                if(vera_sprite_width_get(sprite_offset) < VERA_SPRITE_WIDTH_64)
                    vera_sprite_width(sprite_offset, vera_sprite_width_get(sprite_offset) + VERA_SPRITE_WIDTH_16);
                break;
            case 'i':
                if(vera_sprite_width_get(sprite_offset) > VERA_SPRITE_WIDTH_8)
                    vera_sprite_width(sprite_offset, vera_sprite_width_get(sprite_offset) - VERA_SPRITE_WIDTH_16);
                break;
            case 'l':
                if(vera_sprite_height_get(sprite_offset) < VERA_SPRITE_HEIGHT_64)
                    vera_sprite_height(sprite_offset, vera_sprite_height_get(sprite_offset) + VERA_SPRITE_HEIGHT_16);
                break;
            case 'k':
                if(vera_sprite_height_get(sprite_offset) > VERA_SPRITE_HEIGHT_8)
                    vera_sprite_height(sprite_offset, vera_sprite_height_get(sprite_offset) - VERA_SPRITE_HEIGHT_16);
                break;
        }

        vram_bank_t vram_image_bank = 0;
        vram_offset_t vram_image_offset = (unsigned int)sprite*64*64;
        unsigned int sprite_copy =  (unsigned int)( vera_sprite_width_get(sprite_offset) | vera_sprite_height_get(sprite_offset) );
        sprite_copy = sprite_copy >> 4;


        unsigned int sprite_size = sprites[sprite_copy].size;
        bram_bank_t bram_bank = heap_bram_fb_bank_get(sprites[sprite_copy].bram);
        bram_ptr_t bram_ptr = heap_bram_fb_ptr_get(sprites[sprite_copy].bram);
        memcpy_vram_bram(vram_image_bank, vram_image_offset, bram_bank, bram_ptr, sprite_size);

        vera_sprite_zdepth_in_front(sprite_offset);


        for (unsigned char s=0;s<6;s++) {
            print_registers(s);
            print_width_height(s);
            print_xy(s);
            print_size(s);
            print_bpp(s);
        }

        while(!(ch=getin()));
        gotoxy(0,50);
    } 

    // Back to basic.
    bank_set_brom(CX16_ROM_BASIC);

}

