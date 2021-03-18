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

#include "tileengine.h"



byte const HEAP_FLOOR_MAP = 1;
byte const HEAP_FLOOR_TILE = 2;
byte const HEAP_PETSCII = 3;

const dword VRAM_PETSCII_MAP = 0x1B000;
const dword VRAM_PETSCII_TILE = 0x1F000;

__mem dword bram_sprites_base;
__mem dword bram_sprites_ceil;
__mem dword bram_tiles_base;
__mem dword bram_tiles_ceil;
__mem dword bram_palette;

volatile dword vram_floor_map;

const char FILE_PALETTES[] = "PALETTES";


void vera_tile_clear( byte layer ) {

    byte PaletteOffset = 1;
    byte Offset = 100;

    dword mapbase = vera_mapbase_address[layer];

    vera_vram_address0(mapbase,VERA_INC_1);

    for(word i=0;i<64*20;i++) {
        *VERA_DATA0 = Offset;
        *VERA_DATA0 = PaletteOffset << 4;
    }
}


void vera_tile_element( byte layer, byte x, byte y, word Segment ) {


    byte resolution = 2;

    struct TileSegment *TileSegment = &(TileSegmentDB[Segment]);
    struct Tile *Tile = TileSegment->Tile;

    byte PaletteOffset = Tile->PaletteOffset;


    x = x << resolution;
    y = y << resolution;

    dword mapbase = vera_mapbase_address[layer];
    byte shift = vera_layer_rowshift[layer];
    word rowskip = (word)1 << shift;
    mapbase += ((word)y << shift);
    mapbase += (x << 1); // 2 bytes per tile (one index + one palette)

    word TileBase = Tile->Offset;
    for(byte sr=0;sr<4;sr+=2) {
        for(byte r=0;r<4;r+=2) {
            vera_vram_address0(mapbase,VERA_INC_1);
            for(byte sc=0;sc<2;sc++) {
                for(byte c=0;c<2;c++) {
                    byte s = sc + sr;
                    word TileOffset = (TileSegment->Composition[s]);
                    TileOffset *= 4;
                    word Offset =  TileBase + TileOffset + c + r;
                    *VERA_DATA0 = <Offset;
                    *VERA_DATA0 = PaletteOffset << 4 | >Offset;
                }
            }
        mapbase += rowskip;
        }
    }
}

volatile byte i = 0;
volatile byte j = 0;
volatile byte a = 4;
volatile word row = 5;
volatile word vscroll = 128*5;
volatile word scroll_action = 2;
volatile byte s = 1;

//VSYNC Interrupt Routine
__interrupt(rom_sys_cx16) void irq_vsync() {
    // Move the sprite around

    if(scroll_action--) {
        scroll_action = 10;
        if((<vscroll & 0x80)==<vscroll) {
            if(row<=4) {
                dword dest_row = vram_floor_map+((row+4)*8*64*2);
                dword src_row = vram_floor_map+(row*8*64*2);
                vera_cpy_vram_vram(src_row, dest_row, (dword)64*8*2);
                // gotoxy(0, 21);
                // printf("src_row:%x dest_row:%x vram_floor_map:%x   ",src_row, dest_row, vram_floor_map);
            }
            if(vscroll==0) {
                vscroll=128*4;
                row = 4;
            }
            floor_draw((byte)row-1, s?TileFloorOld:TileFloorNew, s?TileFloorNew:TileFloorOld);
            s++;
            s&=1;
            // for(byte c=0;c<5;c++) {
            //     byte rnd = (byte)modr16u(rand(),3,0);
            //     vera_tile_element( 0, c, (byte)row-1, 3, TileDB[rnd]);
            // }
            row--;
        } 
        vscroll--;
        vera_layer_set_vertical_scroll(0,vscroll);
    }

    // gotoxy(0, 20);
    // printf("vscroll:%u row:%u     ",vscroll, row);

    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
}

void floor_init(byte y, byte *TileFloorNew, byte *TileFloorOld) {

    printf("\no=%x, n=%x", (word)TileFloorOld, (word)TileFloorNew);

    byte rnd = (byte)modr16u(rand(),26,0);
    struct TileSegment *TileSegment = &(TileSegmentDB[(word)rnd]);
    TileFloorNew[0] = rnd;
    for(byte x=1;x<10;x++) {
        struct TileGlue *TileGlue = TileSegment->Glue[1];
        byte RndGlue = (byte)modr16u(rand(),TileGlue->CountGlue,0);
        byte GlueSegment = TileGlue->GlueSegment[RndGlue];
        TileSegment = &(TileSegmentDB[(word)GlueSegment]);
        TileFloorNew[x] = GlueSegment;
    }
    for(byte x=0;x<10;x++) {
        word Tile = (word)TileFloorNew[x];
        vera_tile_element( 0, x, y, Tile);
    }
}

struct TileGlue* floor_get_glue(byte GlueSegment, byte GlueDirection ) {
    struct TileSegment *TileSegment = &(TileSegmentDB[(word)GlueSegment]);
    struct TileGlue *TileGlue = TileSegment->Glue[GlueDirection];
    return TileGlue;
}

struct TileSegment* floor_get_random_gluesegment(struct TileGlue* TileGlue) {
    byte GlueSegment = TileGlue->GlueSegment[(byte)modr16u(rand(),TileGlue->CountGlue,0)];
    return GlueSegment;
}

void floor_draw(byte y, byte *TileFloorNew, byte *TileFloorOld) {

    byte TileResults[20];

    for(byte x=0;x<10;x++) {

        struct TileGlue *TileGlueNew;
        if(x>0) {
            // Start from the west side ...
            TileGlueNew = floor_get_glue(TileFloorNew[x-1], 1);
        } else {
            // Start from the south side ...
            TileGlueNew = floor_get_glue(TileFloorOld[0], 0);
        }


        // Find the common tile segment(s) ...
        byte TileResultCount = 0;
        for(byte i=0; i<TileGlueNew->CountGlue; i++) {
            byte GlueSegmentNew = TileGlueNew->GlueSegment[i];

            byte TileSouth = 0;
            byte TileEast = 0;
            if(x>0) {
                // Get the south side ...
                struct TileGlue *TileGlueSouth = floor_get_glue(TileFloorOld[x], 0);
                for(byte j=0;j<TileGlueSouth->CountGlue;j++) {
                    byte GlueSegmentSouth = TileGlueSouth->GlueSegment[j];
                    if( GlueSegmentNew == GlueSegmentSouth ) {
                        TileSouth = 1;
                    }
                }
            } else {
                TileSouth = 1;
            }
            if(x<9) {
                // Get the southeast side ...
                struct TileGlue *TileGlueSouthEast = floor_get_glue(TileFloorOld[x+1], 0);
                for(byte j=0;j<TileGlueSouthEast->CountGlue;j++) {
                    byte GlueSegmentSouthEast = TileGlueSouthEast->GlueSegment[j];
                    struct TileGlue *TileGlueEast = floor_get_glue(GlueSegmentSouthEast,3);
                    for(byte f=0;f<TileGlueEast->CountGlue;f++) {
                        byte GlueSegmentEast = TileGlueEast->GlueSegment[f];
                        if( GlueSegmentNew == GlueSegmentEast ) {
                            TileEast = 1;
                        }
                    }
                }
            } else {
                TileEast = 1;
            }
            if(TileSouth == 1 && TileEast == 1) {
                TileResults[TileResultCount] = GlueSegmentNew;
                TileResultCount++;
            }
        }

        if( TileResultCount>0) {
            byte GlueSegment = TileResults[(byte)modr16u(rand(),TileResultCount,0)];
            TileFloorNew[x] = GlueSegment;
        } else {
            byte GlueSegment = 24;
            TileFloorNew[x] = GlueSegment;
        }
    }

    for(byte x=0;x<10;x++) {
        word Tile = (word)TileFloorNew[x];
        vera_tile_element( 0, x, y, Tile);
    }
}

void tile_background() {

    int TileIndex = 0;
    int TileIndexColumn = 0;
    int TileIndexRow = 0;
    TileIndex = TileIndexRow << 4 + TileIndexColumn;

    vera_tile_clear(0);
    byte y=15;
    floor_init(y, TileFloorNew, TileFloorOld);
    for( i=0;i<15;i++) {
        y--;
        floor_draw(y, s?TileFloorOld:TileFloorNew, s?TileFloorNew:TileFloorOld);
        s++;
        s&=1;
    }
}

void show_memory_map() {
    for(byte i=0;i<5;i++) {
        struct Tile *Tile = TileDB[i];
        gotoxy(0, 10+i);
        printf("t:%u bram:%x, vram:", i, Tile->BRAM_Address);
        for(byte j=0;j<Tile->TileCount;j++) {
            printf("%x ", Tile->VRAM_Addresses[j]);
        }
    }
}

void tile_cpy_vram(byte segmentid, struct Tile *Tile) {
    dword bsrc = Tile->BRAM_Address;
    byte num = Tile->TileCount;
    word size = Tile->TileSize;
    for(byte s=0;s<num;s++) {
        dword vaddr = vera_heap_malloc(segmentid, size);
        dword baddr = bsrc+mul16u((word)s,size);
        vera_cpy_bank_vram(baddr, vaddr, size);
        Tile->VRAM_Addresses[s] = vaddr;
    }
}

dword load_tile( struct Tile *Tile, dword bram_address) {
    char status = cx16_load_ram_banked(1, 8, 0, Tile->File, bram_address);
    if(status!=$ff) printf("error file %s: %x\n", Tile->File, status);
    Tile->BRAM_Address = bram_address;
    word size = Tile->TotalSize;
    return bram_address + size;
    // return bram_address + Tile->Size; // TODO: fragment
}

void main() {

    TileDB[TILE_BORDER] = &TileBorder;
    TileDB[TILE_SQUAREMETAL] = &TileSquareMetal;
    TileDB[TILE_SQUARERASTER] = &TileSquareRaster;
    TileDB[TILE_INSIDEMETAL] = &TileInsideMetal;
    TileDB[TILE_INSIDEDARK] = &TileInsideDark;


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
    bram_tiles_ceil = 0x02000;
    bram_tiles_ceil = load_tile(TileDB[TILE_BORDER], bram_tiles_ceil);
    bram_tiles_ceil = load_tile(TileDB[TILE_SQUAREMETAL], bram_tiles_ceil);
    bram_tiles_ceil = load_tile(TileDB[TILE_SQUARERASTER], bram_tiles_ceil);
    bram_tiles_ceil = load_tile(TileDB[TILE_INSIDEMETAL], bram_tiles_ceil);
    bram_tiles_ceil = load_tile(TileDB[TILE_INSIDEDARK], bram_tiles_ceil);

    // Load the palettes in main banked memory.
    bram_palette = 0x16000;
    byte status = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, bram_palette);
    if(status!=$ff) printf("error file_palettes = %u",status);

    const word VRAM_FLOOR_MAP_SIZE = 64*64*2;
    const word VRAM_FLOOR_TILE_SIZE = TILE_FLOOR_COUNT*32*32/2;
    __mem dword vram_segment_floor_map = vera_heap_segment_init(HEAP_FLOOR_MAP, 0x10000, VRAM_FLOOR_MAP_SIZE);
    __mem dword vram_segment_floor_tile = vera_heap_segment_init(HEAP_FLOOR_TILE, vera_heap_segment_ceiling(HEAP_FLOOR_MAP), VRAM_FLOOR_TILE_SIZE);

    gotoxy(0,34);
    printf("floor map = %x, tile map = %x\n", vram_segment_floor_map, vram_segment_floor_tile);
    printf("tiledb\n");
    for(word i=0;i<5;i++) {
        printf("%x ",(word)TileDB[(byte)i]);
    }
    printf("\n");
    printf("segmentdb\n");
    for(word i=0;i<26;i++) {
        struct TileSegment *TileSegment = &(TileSegmentDB[i]);
        printf("%x ",(word)TileSegment->Tile);
    }
    vram_floor_map = vram_segment_floor_map;

    // Now we activate the tile mode.
 
    tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_BORDER]);
    tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_SQUAREMETAL]);
    tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_SQUARERASTER]);
    tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_INSIDEMETAL]);
    tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_INSIDEDARK]);

    vera_layer_mode_tile(0, vram_segment_floor_map, vram_segment_floor_tile, 64, 64, 16, 16, 4);

    // Load the palette in VERA palette registers, but keep the first 16 colors untouched.
    vera_cpy_bank_vram(bram_palette, VERA_PALETTE+32, (dword)32*5);

    show_memory_map();

    // floor_init();
    tile_background();

    vera_layer_show(0);

    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC; 
    CLI();

    while(!kbhit());

    // Back to basic.
    cx16_rom_bank(CX16_ROM_BASIC);
}

