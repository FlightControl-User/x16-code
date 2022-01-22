// Space tile scrolling engine for a space game written in kickc for the Commander X16.


#pragma var_model(mem)

#include <cx16.h>
#include <cx16-veralib.h>
#include <cx16-heap.h>
#include <kernal.h>
#include <6502.h>
#include <conio.h>
#include <cx16-conio.h>
#include <printf.h>
#include <stdio.h>
#include <division.h>
#include <mos6522.h>
#include <multiply.h>

#include "equinoxe.h"
#include "equinoxe-floorengine.h"

void vera_tile_clear( byte layer ) {

    byte PaletteOffset = 1;
    byte Offset = 100;

    dword mapbase = vera_layer_get_mapbase_address(layer);

    vera_vram_data0_address(mapbase,VERA_INC_1);

    for(word i=0;i<64*20;i++) {
        *VERA_DATA0 = Offset;
        *VERA_DATA0 = PaletteOffset << 4;
    }
}

void vera_tile_row( byte layer, byte y,  byte *TileFloor ) {

    byte resolution = 2;

    y = y << resolution;

    dword mapbase = vera_layer_get_mapbase_address(layer);
    byte shift = vera_layer_get_rowshift(layer);
    word rowskip = (word)1 << shift;
    mapbase += ((word)y << shift);

    for(byte sr=0;sr<4;sr+=2) {
        for(byte r=0;r<4;r+=2) {
            vera_vram_data0_address(mapbase,VERA_INC_1);
            for(byte x=0; x<TILES;x++) {
                word Segment = (word)TileFloor[x];
                struct TileSegment *TileSegment = &(TileSegmentDB[Segment]);
                for(byte sc=0;sc<2;sc++) {
                    byte s = sc + sr;
                    struct TilePart *TilePart = &TilePartDB[(word)TileSegment->Composition[s]];
                    struct Tile *Tile = TilePart->Tile; 
                    word TileOffset = TilePart->TileOffset;
                    for(byte c=0;c<2;c++) {
                        word Offset = TileOffset + r + c;
                        *VERA_DATA0 = BYTE0(Offset);
                        *VERA_DATA0 = Tile->PaletteOffset << 4 | BYTE1(Offset);
                    }
                }
            }
            mapbase += rowskip;
        }
    }
}


void vera_tile_element( byte layer, byte x, byte y, word Segment ) {

    byte resolution = 2;

    struct TileSegment *TileSegment = &(TileSegmentDB[Segment]);

    x = x << resolution;
    y = y << resolution;

    dword mapbase = vera_layer_get_mapbase_address(layer);
    byte shift = vera_layer_get_rowshift(layer);
    word rowskip = vera_layer_get_rowskip(layer);
    mapbase += ((word)y << shift);
    mapbase += (x << 1); // 2 bytes per tile (one index + one palette)

    for(byte sr=0;sr<4;sr+=2) {
        for(byte r=0;r<4;r+=2) {
            vera_vram_data0_address(mapbase,VERA_INC_1);
            for(byte sc=0;sc<2;sc++) {
                for(byte c=0;c<2;c++) {
                    byte s = sc + sr;
                    struct TilePart *TilePart = &TilePartDB[(word)TileSegment->Composition[s]];
                    struct Tile *Tile = TilePart->Tile; 
                    word TileOffset = TilePart->TileOffset;
                    word Offset = TileOffset + r + c;
                    *VERA_DATA0 = BYTE0(Offset);
                    *VERA_DATA0 = Tile->PaletteOffset << 4 | BYTE1(Offset);
                }
            }
        mapbase += rowskip;
        }
    }
}



void floor_init(byte y, byte *TileFloorNew, byte *TileFloorOld) {

    // printf("\no=%x, n=%x", (word)TileFloorOld, (word)TileFloorNew);

    byte TileLeft = (byte)modr16u(rand(),16,0);
    TileFloorNew[0] = TileLeft;
    for(byte x=1;x<TILES;x++) {
        unsigned char Tile = (byte)modr16u(rand(),16,0);
        byte TileMask = ((TileLeft << 1) & 0b1000) | ((TileLeft >> 1) & 0b0001);
        Tile = Tile & 0b0110;
        Tile = Tile | TileMask;
        TileFloorNew[x] = Tile;
        TileLeft = Tile;
    }

    vera_tile_row( 0, y, TileFloorNew );

    // for(byte x=0;x<TILES;x++) {
    //     word Tile = (word)TileFloorNew[x];
    //     vera_tile_element( 0, x, y, Tile);
    // }
}

void floor_draw(byte y, byte *TileFloorNew, byte *TileFloorOld) {

    // gotoxy(0,y*3+2);
    // printf("rnd: %02u", y);
    // gotoxy(0,y*3+2+1);
    // printf("val: %02u", y);

    for(byte x=0;x<TILES;x++) {

        byte Tile = (byte)modr16u(rand(),16,0);
        byte Weight = (byte)modr16u(rand(),16,0);
        while(TileSegmentDB[(word)Tile].Weight < Weight) {
            Tile = (byte)modr16u(rand(),16,0);
        }
        // byte TileDown = TileFloorOld[x];
        // Tile = (Tile & 0b1100) | ((TileDown >> 2) & 0b0011 );

    // {
    // gotoxy(6+x*6,y*3+2);
    // byte i = 4; /* however many bits are in a byte on your platform */
    // while(i--) {
    //     printf("%c", '0' + (((byte)Tile >> i) & 1)); /* loop through and print the bits */
    // }
    // }


        if(x>0) {
            byte TileLeft = TileFloorNew[x-1];
            byte TileMask = ((TileLeft << 1) & 0b1000) | ((TileLeft >> 1) & 0b0001);
            Tile = Tile & 0b0110;
            Tile = Tile | TileMask;
        }

        byte TileDown = TileFloorOld[x];
        byte TileMask = ((TileDown >> 3) & 0b0001) | ((TileDown >> 1) & 0b0010);
        Tile = Tile & 0b1100;
        Tile = Tile | TileMask;

        TileFloorNew[x] = Tile;

    }

    vera_tile_row( 0, y, TileFloorNew );

    // for(byte x=0;x<TILES;x++) {
    //     word Tile = (word)TileFloorNew[x];
    //     // gotoxy(0,12+y); printf("y%02u",y);
    //     vera_tile_element( 0, x, y, Tile);
    // }
}

void tile_background() {

    int TileIndex = 0;
    int TileIndexColumn = 0;
    int TileIndexRow = 0;
    TileIndex = TileIndexRow << 4 + TileIndexColumn;

    vera_tile_clear(0);
    byte y=15;
    floor_init(y, TileFloorNew, TileFloorOld);
    for(i=0;i<8;i++) {
        y--;
        floor_draw(y, s?TileFloorOld:TileFloorNew, s?TileFloorNew:TileFloorOld);
        s++;
        s&=1;
    }
    vera_layer_set_vertical_scroll(0,8*64);
}

void show_memory_map() {
    for(byte i=0;i<TILE_TYPES;i++) {
        struct Tile *Tile = TileDB[i];
        byte TileOffset = Tile->TileOffset;
        // gotoxy(0, 30+i);
        printf("t:%u bram:%x:%p, vram:", i, heap_data_bank(Tile->BRAM_Handle), heap_data_ptr(Tile->BRAM_Handle));
        for(byte j=0;j<Tile->TileCount;j++) {
            struct TilePart *TilePart = &TilePartDB[(word)(TileOffset+j)];
            printf("%x:%p ", heap_data_bank(TilePart->VRAM_Handle), heap_data_ptr(TilePart->VRAM_Handle));
        }
    }
}

void tile_cpy_vram_from_bram(struct Tile *Tile) {

    heap_ptr ptr_bram_tile = heap_data_ptr(Tile->BRAM_Handle);
    heap_bank bank_bram_tile = heap_data_bank(Tile->BRAM_Handle);

    byte TileCount = Tile->TileCount;
    word TileSize = Tile->TileSize;
    byte TileOffset = Tile->TileOffset;

    for(byte t=0;t<TileCount;t++) {

        heap_handle handle_vram_tile = heap_alloc(HEAP_SEGMENT_VRAM_FLOOR_TILE, TileSize);
        heap_bank bank_vram_tile = heap_data_bank(handle_vram_tile);
        heap_ptr ptr_vram_tile = heap_data_ptr(handle_vram_tile);

        cx16_cpy_vram_from_bram(bank_vram_tile, (word)ptr_vram_tile, bank_bram_tile, (byte*)ptr_bram_tile, TileSize);

        struct TilePart *TilePart = &TilePartDB[(word)(TileOffset+t)];
        // TODO: make shorter, missing fragments.
        word Offset = ((word)ptr_vram_tile - (word)0x2000);
        // Offset = Offset >> 4;
        // Offset = Offset >> 4;
        TilePart->TileOffset = BYTE1(Offset);
        TilePart->VRAM_Handle = handle_vram_tile;
        ptr_bram_tile = cx16_bram_ptr_inc(bank_bram_tile, ptr_bram_tile, TileSize);
        bank_bram_tile = cx16_bram_bank_get();
    }
}


// Load the tile into bram using the new cx16 heap manager.
heap_handle tile_load( struct Tile *Tile) {

    heap_handle handle_bram_tile = heap_alloc(HEAP_SEGMENT_BRAM_TILES, Tile->TotalSize);  // Reserve enough memory on the heap for the tile loading.
    heap_ptr ptr_bram_tile = heap_data_ptr(handle_bram_tile);
    heap_bank bank_bram_tile = heap_data_bank(handle_bram_tile);
    heap_handle data_handle_bram_tile = heap_data_get(handle_bram_tile);

    // printf("bram: %x:%p\n", heap_data_bank(handle_bram_tile), heap_data_ptr(handle_bram_tile));

    unsigned int tiles_loaded = cx16_bram_load(1, 8, 0, Tile->File, bank_bram_tile, ptr_bram_tile);
    if(!tiles_loaded) printf("error file %s\n", Tile->File);

    Tile->BRAM_Handle = handle_bram_tile;
    return handle_bram_tile;
}


// #include "equinoxe-petscii-move.c"

// void main() {


//     // We are going to use only the kernal on the X16.
//     cx16_brom_bank_set(CX16_ROM_KERNAL);

//     // Memory is managed as follows:
//     // ------------------------------------------------------------------------
//     //
//     // HEAP SEGMENT                     VRAM                  BRAM
//     // -------------------------        -----------------     -----------------
//     // HEAP_SEGMENT_VRAM_PETSCII        01/B000 - 01/F800     01/A000 - 01/A400
//     // HEAP_SEGMENT_VRAM_SPRITES        00/0000 - 01/B000     01/A400 - 01/C000
//     // HEAP_SEGMENT_BRAM_SPRITES                              02/A000 - 20/C000
//     // HEAP_SEGMENT_BRAM_PALETTE                              3F/A000 - 3F/C000

//     heap_address vram_petscii = petscii();

//     // Allocate the segment for the tiles in vram.
//     const word VRAM_FLOOR_MAP_SIZE = 64*64*2;
//     const word VRAM_FLOOR_TILE_SIZE = TILE_FLOOR_COUNT*32*32/2;
    
//     // Allocate the segment for the floor map in vram.
//     heap_vram_packed vram_floor_map = heap_segment_vram_floor(
//         HEAP_SEGMENT_VRAM_FLOOR_MAP, 
//         heap_vram_pack(1, 0x0000), 
//         heap_size_pack(0x2000), 
//         heap_bram_pack(1, (heap_ptr)0xA400), 
//         0
//         );

//     //heap_segment_id segment_vram_floor_map = heap_segment_vram(HEAP_SEGMENT_VRAM_FLOOR_MAP, 1, 0x2000, 1, 0x0000, 1, 0xA400, 0);

//     heap_vram_packed vram_floor_tile = heap_segment_vram_floor(
//         HEAP_SEGMENT_VRAM_FLOOR_TILE, 
//         heap_vram_pack(1, (cx16_vram_offset)0x2000), 
//         heap_size_pack(0x8000), 
//         heap_bram_pack(1, (cx16_bram_ptr)0xA400), 
//         0x100
//         );

//     //heap_segment_id segment_vram_floor_tile = heap_segment_vram(HEAP_SEGMENT_VRAM_FLOOR_TILE, 1, 0xA000, 1, 0x2000, 1, 0xA400, 0x100);

//     // Load the palettes in main banked memory.
//     heap_address bram_palettes = heap_segment_bram(
//         HEAP_SEGMENT_BRAM_PALETTES, 
//         heap_bram_pack(63, (heap_ptr)0xA000), 
//         heap_size_pack(0x2000)
//         );

//     // Palettes
//     heap_handle handle_bram_palettes = heap_alloc(HEAP_SEGMENT_BRAM_PALETTES, 8192);
//     heap_ptr ptr_bram_palettes = heap_data_ptr(handle_bram_palettes);
//     heap_bank bank_bram_palettes = heap_data_bank(handle_bram_palettes);

//     unsigned int palette_loaded = 0;

//     unsigned int sprite_palette_loaded = cx16_bram_load(1, 8, 0, FILE_PALETTES_SPRITE01, bank_bram_palettes, ptr_bram_palettes+palette_loaded);
//     if(!sprite_palette_loaded) printf("error file_palettes");
//     palette_loaded += sprite_palette_loaded;
//     heap_ptr ptr_bram_palettes_sprite = heap_data_ptr(handle_bram_palettes)+palette_loaded;

//     unsigned int floor_palette_loaded = cx16_bram_load(1, 8, 0, FILE_PALETTES_FLOOR01, bank_bram_palettes, ptr_bram_palettes+palette_loaded);
//     if(!floor_palette_loaded) printf("error file_palettes");
//     palette_loaded += floor_palette_loaded;
//     heap_ptr ptr_bram_palettes_floor = heap_data_ptr(handle_bram_palettes)+palette_loaded;

//     cx16_cpy_vram_from_bram(VERA_PALETTE_BANK, (word)VERA_PALETTE_PTR+32, bank_bram_palettes, ptr_bram_palettes, palette_loaded);

//     // Initialize the bram heap for tile loading.
//     heap_address bram_floor_tile = heap_segment_bram(
//         HEAP_SEGMENT_BRAM_TILES,
//         heap_bram_pack(33,(heap_ptr)0xA000),
//         heap_size_pack(0x2000*8)
//         );

//     gotoxy(0, 10);

//     // Loading the graphics in main banked memory.
//     for(i=0; i<TILE_TYPES;i++) {
//         tile_load(TileDB[i]);
//     }

//     // Now we activate the tile mode.
//     for(i=0;i<TILE_TYPES;i++) {
//         tile_cpy_vram_from_bram(TileDB[i]);
//     }

//     show_memory_map();

//     vram_floor_map_ulong = 0x10000;
//     vera_layer_mode_tile(0, vram_floor_map_ulong, 0x12000, 64, 64, 16, 16, 4);

//     vera_layer_show(0);

//     //floor_init();
//     tile_background();

//     // Enable VSYNC IRQ (also set line bit 8 to 0)
//     SEI();
//     *KERNEL_IRQ = &irq_vsync;
//     *VERA_IEN = VERA_VSYNC; 
//     CLI();

//     while(!kbhit());

//     // Back to basic.
//     cx16_brom_bank_set(CX16_ROM_BASIC);
// }

// //VSYNC Interrupt Routine

// __interrupt(rom_sys_cx16) void irq_vsync() {

//     // background scrolling
//     if(!scroll_action--) {
//         scroll_action = 4;
//         gotoxy(0, 10);
//         printf("vscroll:%u row:%u   ",vscroll, row);
//         if((BYTE0(vscroll) & 0xC0)==BYTE0(vscroll) ) {
//             if(row<=7) {
//                 dword dest_row = vram_floor_map_ulong+((row+8)*4*64*2);
//                 dword src_row = vram_floor_map_ulong+(row*4*64*2);
//                 vera_cpy_vram_vram(src_row, dest_row, (dword)64*4*2);
//             }
//             if(vscroll==0) {
//                 vscroll=8*64;
//                 row = 8;
//             }
//             floor_draw((byte)row-1, s?TileFloorNew:TileFloorOld, s?TileFloorOld:TileFloorNew);
//             s++;
//             s&=1;
//             row--;
//         } 
//         vera_layer_set_vertical_scroll(0,vscroll);
//         vscroll--;
//     }

//     // Reset the VSYNC interrupt
//     *VERA_ISR = VERA_VSYNC;
// }
