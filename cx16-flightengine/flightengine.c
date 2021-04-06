// Example program for the Commander X16


#pragma zp_reserve(0x01, 0x02, 0x80..0xA8)

#include <cx16.h>
#include <cx16-veralib.h>
#include <cx16-veramem.h>
#include <kernal.h>
#include <6502.h>
#include <conio.h>
#include <printf.h>
#include <stdio.h>
#include <division.h>
#include <mos6522.h>
#include <multiply.h>

#include "flightengine.h"

volatile byte i = 0;
volatile byte j = 0;
volatile byte a = 4;
volatile word row = 8;
volatile word vscroll = 8*64;
volatile word scroll_action = 2;
volatile byte s = 1;


byte const HEAP_FLOOR_MAP = 1;
byte const HEAP_FLOOR_TILE = 2;
byte const HEAP_PETSCII = 3;

const dword VRAM_PETSCII_MAP = 0x1B000;
const dword VRAM_PETSCII_TILE = 0x1F000;

__mem dword bram_sprites_base;
__mem dword bram_sprites_ceil;
__mem dword bram_tiles_base;
__mem dword bram_ceil;
__mem dword bram_palette;

volatile dword vram_floor_map;

const char FILE_PALETTES[] = "PALETTES";


void sprite_cpy_vram(byte segmentid, struct Sprite *Sprite) {
    dword bsrc = Sprite->BRAM_Address;
    byte SpriteCount = Sprite->SpriteCount;
    word SpriteSize = Sprite->SpriteSize;
    byte SpriteOffset = Sprite->SpriteOffset;
    for(byte s=0;s<SpriteCount;s++) {
        dword vaddr = vera_heap_malloc(segmentid, SpriteSize);
        dword baddr = bsrc+mul16u((word)s,SpriteSize);
        vera_cpy_bank_vram(baddr, vaddr, SpriteSize);
        Sprite->VRAM_Address[s] = vaddr;
    }
}

dword sprite_load( struct Sprite *Sprite, dword bram_address) {
    char status = cx16_load_ram_banked(1, 8, 0, Sprite->File, bram_address);
    if(status!=$ff) printf("error file %s: %x\n", Sprite->File, status);
    Sprite->BRAM_Address = bram_address;
    word SpriteSize = Sprite->TotalSize;
    // printf("SpriteSize = %u", SpriteSize);
    return bram_address + SpriteSize;
    // return bram_address + Sprite->Size; // TODO: fragment
}

void sprite_create(byte sprite) {

    // Copy sprite palette to VRAM
    // Copy 8* sprite attributes to VRAM
    struct Sprite *Sprite = SpriteDB[sprite];
    for(byte s=0;s<Sprite->SpriteCount;s++) {
        byte Offset = Sprite->SpriteOffset+s;
        vera_sprite_bpp(Offset, Sprite->BPP);
        vera_sprite_address(Offset, Sprite->VRAM_Address[s]);
        vera_sprite_xy(Offset, 40+((word)(s&03)<<6), 100+((word)(s>>2)<<6));
        vera_sprite_height(Offset, Sprite->Height);
        vera_sprite_width(Offset, Sprite->Width);
        vera_sprite_zdepth(Offset, Sprite->Zdepth);
        vera_sprite_hflip(Offset, Sprite->Hflip);
        vera_sprite_vflip(Offset, Sprite->Vflip);
        vera_sprite_palette_offset(Offset, Sprite->PaletteOffset);
    }
}

void show_memory_map() {
    for(byte i=0;i<SPRITE_TYPES;i++) {
        struct Sprite *Sprite = SpriteDB[i];
        byte offset = Sprite->SpriteOffset;
        gotoxy(0, 30+i);
        printf("t:%u bram:%x, vram:", i, Sprite->BRAM_Address);
        for(byte j=0;j<Sprite->SpriteCount;j++) {
            printf("%x ", Sprite->VRAM_Address[j]);
        }
    }
}

void main() {


    // We are going to use only the kernal on the X16.
    cx16_rom_bank(CX16_ROM_KERNAL);

    // Handle the relocation of the CX16 petscii character set and map to the most upper corner in VERA VRAM.
    // This frees up the maximum space in VERA VRAM available for graphics.
    const word VRAM_PETSCII_MAP_SIZE = 128*64*2;
    vera_heap_segment_init(HEAP_PETSCII, 0x1B000, VRAM_PETSCII_MAP_SIZE + VERA_PETSCII_TILE_SIZE);
    dword vram_petscii_map = vera_heap_malloc(HEAP_PETSCII, VRAM_PETSCII_MAP_SIZE);
    dword vram_petscii_tile = vera_heap_malloc(HEAP_PETSCII, VERA_PETSCII_TILE_SIZE);
    vera_cpy_vram_vram(VERA_PETSCII_TILE, VRAM_PETSCII_TILE, VERA_PETSCII_TILE_SIZE);
    vera_layer_mode_tile(1, vram_petscii_map, vram_petscii_tile, 128, 64, 8, 8, 1);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0, 30);
    // Loading the graphics in main banked memory.
    bram_ceil = 0x02000;
    for(i=0; i<SPRITE_TYPES;i++) {
        bram_ceil = sprite_load(SpriteDB[i], bram_ceil);
    }

    // Load the palettes in main banked memory.
    bram_palette = 0x24000;
    byte status = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, bram_palette);
    if(status!=$ff) printf("error file_palettes = %u",status);

    // Set the vera heap parameters.
    word const VRAM_SPRITES_SIZE = 64*32*32/2; // Issue to solve: 128 sprites in heap manager seems not to work correctly, but will 127?
    __mem dword vram_segment_sprites = vera_heap_segment_init(HEAP_SPRITES, 0x00000, VRAM_SPRITES_SIZE);

    // Now we activate the tile mode.
    for(i=0;i<SPRITE_TYPES;i++) {
        sprite_cpy_vram(HEAP_SPRITES, SpriteDB[i]);
    }

    // Load the palette in VERA palette registers, but keep the first 16 colors untouched.
    vera_cpy_bank_vram(bram_palette, VERA_PALETTE+32, (dword)32*1);

    sprite_create(0);
    show_memory_map();

    vera_sprite_on();

    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC; 
    CLI();

    while(!kbhit());

    // Back to basic.
    cx16_rom_bank(CX16_ROM_BASIC);
}

void rotate_sprites(word rotate, struct Sprite *Sprite, word basex, word basey) {
    byte SpriteOffset = Sprite->SpriteOffset;
    word SpriteCount = Sprite->SpriteCount;
    for(byte s=0;s<SpriteCount;s++) {
        word i = s+rotate;
        if(i>=SpriteCount) i-=SpriteCount;
        vera_sprite_address(s+SpriteOffset, Sprite->VRAM_Address[i]);
        vera_sprite_xy(s+SpriteOffset, basex+((word)(s&03)<<6), basey+((word)(s>>2)<<6));
    }

}

//VSYNC Interrupt Routine

__interrupt(rom_sys_cx16) void irq_vsync() {

    // background scrolling
    if(!scroll_action--) {
        scroll_action = 4;
        gotoxy(0,2);
        printf("i:%02u",i);
        rotate_sprites(i, SpriteDB[0], 40, 100);
        i=(i<7)?i+1:0;
    }

    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
}
