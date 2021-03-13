// Example program for the Commander X16

#pragma link("tileengine.ld")

#pragma zp_reserve(0x01, 0x02, 0x80..0xA8)

#pragma data_seg(Data)

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



void vera_tile_element( byte layer, byte x, byte y, byte Segment ) {


    byte resolution = 2;

    struct TileSegment *TileSegment = &(TileSegmentDB[Segment]);
    struct Tile *Tile = TileSegment->Tile;

    byte TileTotal = Tile->DrawTotal;
    byte TileCount = Tile->DrawCount;
    byte TileRows = Tile->DrawRows;
    byte TileColumns = Tile->DrawColumns; 
    byte PaletteOffset = Tile->Palette << 4;


    x = x << resolution;
    y = y << resolution;

    dword mapbase = vera_mapbase_address[layer];
    byte shift = vera_layer_rowshift[layer];
    word rowskip = (word)1 << shift;
    mapbase += ((word)y << shift);
    mapbase += (x << 1);

    word s = 0;
    byte Test = 0;
            word Offset = Tile->Offset;
            // printf("Offset = %u\n", Offset); 
            byte segment = TileSegment->Composition[s]; 
            Offset += (segment << 2);
            for(byte r=0;r<4;r+=2) {
                for(byte c=0;c<2;c+=1) {
                    vera_vram_address0(mapbase,VERA_INC_1);
                    *VERA_DATA0 = <Offset;
            //         *VERA_DATA0 = PaletteOffset | (>TileOffset);
                }
                mapbase += rowskip;
            }
            s++;
}

volatile byte i = 0;
volatile byte j = 0;
volatile byte a = 4;
volatile word row = 5;
volatile word vscroll = 128*5;
volatile word scroll_action = 2;

/*
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
            for(byte c=0;c<5;c++) {
                byte rnd = (byte)modr16u(rand(),3,0);
                vera_tile_element( 0, c, (byte)row-1, 3, TileDB[rnd]);
            }
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
*/

void floor_init() {
    // for(int TileIndexRow=0; TileIndexRow<2; TileIndexRow++) {
    //     for(int TileIndexColumn=0;TileIndexColumn<16;TileIndexColumn++) {
    //         int TileIndex = TileIndexRow << 4 + TileIndexColumn;
    //         TileFloor[TileIndex] = 255;
    //     }
    // }
}

void floor_draw() {
    // int TileIndex = 0;
    // int TileIndexColumn = 0;
    // int TileIndexRow = 1;
    // TileIndex = TileIndexRow << 4 + TileIndexColumn;
    // byte rnd = (byte)modr16u(rand(),26,0);
    // TileFloor[TileIndex] = 0;


    // for(char TileIndexColumn:0..15) {

    //     byte rnd = (byte)modr16u(rand(),3,0);
    // }
    // for(int TileIndexRow=(4*4-2)*20; TileIndexRow>=0; TileIndexRow-=20) {
    //     for(int TileIndexColumn=0;TileIndexColumn<20;TileIndexColumn++) {
    //         TileIndex = TileIndexRow + TileIndexColumn;
    //         struct TileSegment *TileSegment = TileFloor[TileIndex];
    //         if(!TileSegment) {
    //             byte rnd = (byte)modr16u(rand(),3,0);


    //         }

    //     }
    // }
}

void tile_background() {

    int TileIndex = 0;
    int TileIndexColumn = 0;
    int TileIndexRow = 1;
    TileIndex = TileIndexRow << 4 + TileIndexColumn;

    vera_tile_element( 0, 0, 24, TileFloor[TileIndex]);
}

void show_memory_map() {
    for(byte i=0;i<3;i++) {
        struct Tile *Tile = TileDB[i];
        gotoxy(0, 4+i);
        printf("t:%u bram:%x, vram:", i, Tile->BRAM_Address);
        for(byte j=0;j<4;j++) {
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

    // Loading the graphics in main banked memory.
    bram_tiles_ceil = 0x02000;
    bram_tiles_ceil = load_tile(TileDB[TILE_BORDER], bram_tiles_ceil);
    bram_tiles_ceil = load_tile(TileDB[TILE_SQUAREMETAL], bram_tiles_ceil);
    bram_tiles_ceil = load_tile(TileDB[TILE_SQUARERASTER], bram_tiles_ceil);
    bram_tiles_ceil = load_tile(TileDB[TILE_INSIDEMETAL], bram_tiles_ceil);
    bram_tiles_ceil = load_tile(TileDB[TILE_INSIDEDARK], bram_tiles_ceil);

    // Load the palettes in main banked memory.
    bram_palette = bram_tiles_ceil;
    byte status = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, bram_palette);
    if(status!=$ff) printf("error file_palettes = %u",status);

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

    const word VRAM_FLOOR_MAP_SIZE = 64*64*2;
    const word VRAM_FLOOR_TILE_SIZE = TILE_FLOOR_COUNT*32*32/2;
    __mem dword vram_segment_floor_map = vera_heap_segment_init(HEAP_FLOOR_MAP, 0x10000, VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE);
    __mem dword vram_segment_floor_tile = vera_heap_segment_init(HEAP_FLOOR_TILE, vera_heap_segment_ceiling(HEAP_FLOOR_MAP), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE);

    vram_floor_map = vram_segment_floor_map;

    // Now we activate the tile mode.
 
    tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_BORDER]);
    tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_SQUAREMETAL]);
    tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_SQUARERASTER]);
    tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_INSIDEMETAL]);
    tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_INSIDEDARK]);

    vera_layer_mode_tile(0, vram_segment_floor_map, vram_segment_floor_tile, 64, 64, 16, 16, 4);

    // Load the palette in VERA palette registers, but keep the first 16 colors untouched.
    vera_cpy_bank_vram(bram_palette, VERA_PALETTE+32, (dword)32*6);

    vera_layer_show(0);

    floor_init();
    floor_draw();
    tile_background();

    show_memory_map();

    // Enable VSYNC IRQ (also set line bit 8 to 0)
    // SEI();
    // *KERNEL_IRQ = &irq_vsync;
    // *VERA_IEN = VERA_VSYNC; 
    // CLI();

    while(!kbhit());

    // Back to basic.
    cx16_rom_bank(CX16_ROM_BASIC);
}



#pragma data_seg(Palettes)
export char PALETTES[] = 

kickasm {{
    .function GetPalette(tile,count,width,height,hinc,vinc) {
        .var palette = Hashtable()
        .var palList = List()
        .var nxt_idx = 0;
        .for(var p=1;p<=count;p++) {
            .var nr = "00"+toIntString(p)
            .var pic = LoadPicture("Floor/" + tile + "_" + nr.substring(nr.size()-3,nr.size()-1) + ".png")
            .for (var y=0; y<height; y++) {
                .for (var x=0;x<width; x++) {
                    // Find palette index (add if not known)
                    .var rgb = pic.getPixel(x,y);
                    .var idx = palette.get(rgb)
                    .if(idx==null) {
                        .eval idx = nxt_idx++;
                        .eval palette.put(rgb,idx);
                        .eval palList.add(rgb)
                    }
                }
            }
        }
        .return palette
    }

    .function MakeTile(tile,palette,count,width,height,hinc,vinc) {
        .var tiledata = List()
        .for(var p=1;p<=count;p++) {
            .var nr = "00"+toIntString(p)
            .var pic = LoadPicture("Floor/" + tile + "_" + nr.substring(nr.size()-3,nr.size()-1) + ".png")
            .for(var j=0; j<height; j+=vinc) {
                .for(var i=0; i<width; i+=hinc) {
                    .for (var y=j; y<j+vinc; y++) {
                        .for (var x=i; x<i+hinc; x+=2) {
                            // Find palette index (add if not known)
                            .var rgb = pic.getPixel(x,y);
                            .var idx1 = palette.get(rgb)
                            .if(idx1==null) {   
                                .error "unknown rgb value!"
                            }
                            // Find palette index (add if not known)
                            .eval rgb = pic.getPixel(x+1,y);
                            .var idx2 = palette.get(rgb)
                            .if(idx2==null) {
                                .error "unknown rgb value!"
                            }
                            .eval tiledata.add( idx1*16+idx2 );
                        }
                    }
                }
            }
        }
        .print tiledata
        .return tiledata
    }


    .function MakePalette(palette,palettecount) {

        .var palettedata = List()
        .var palettekeys = palette.keys()
        .if(palettekeys.size()>palettecount) .error "Image has too many colours "+palettekeys.size()

        .for(var i=0;i<palettecount;i++) {
            .var rgb = 0
            .if(i<palettekeys.size())
                .eval rgb = palettekeys.get(i).asNumber()
            .print "rgb = " + rgb
            .var red = rgb / [256*256]
            .var green = (rgb/256) & 255
            .var blue = rgb & 255
            // bits 4-8: green, bits 0-3 blue
            .eval palettedata.add(green&$f0 | blue/16)
            // bits bits 0-3 red
            .eval palettedata.add(red/16)
            // .printnow "tile large: rgb = " + rgb + ", i = " + i
        }
        .print palettedata
        .return palettedata
    }
}};


#pragma data_seg(Border)
export char BITMAP_BORDER[] = kickasm {{
    .var palette = GetPalette("Border",24,32,32,16,64)
    .var tiledata = MakeTile("Border",palette,24,32,32,16,16)
    .var palettedata = MakePalette(palette,64)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .for(var i=0;i<palettedata.size();i++) {
        .byte palettedata.get(i)
    }
}};

// #pragma data_seg(SquareMetal)
// export char BITMAP_SQUAREMETAL[] = kickasm {{{
//     .eval Tile("SquareMetal",16,32,32,16,16,16)
// };}};

// #pragma data_seg(SquareRaster)
// export char BITMAP_SQUARERASTER[] = kickasm {{{
//     .eval Tile("SquareRaster",16,32,32,16,16,16)
// };}};

// #pragma data_seg(InsideMetal)
// export char BITMAP_INSIDEMETAL[] = kickasm {{{
//     .eval Tile("InsideMetal",4,32,32,16,16,16)
// };}};

// #pragma data_seg(InsideDark)
// export char BITMAP_INSIDEDARK[] = kickasm {{{
//     .eval Tile("InsideDark",4,32,32,16,16,16)
// };}};

#pragma data_seg(Data)
