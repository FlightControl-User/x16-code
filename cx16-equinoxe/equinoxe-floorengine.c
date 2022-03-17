// Space tile scrolling engine for a space game written in kickc for the Commander X16.


#pragma var_model(mem)

#include <cx16.h>
#include <cx16-veralib.h>
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

void vera_tile_clear() {

    byte PaletteOffset = 1;
    byte Offset = 100;

    unsigned int mapbase_offset = vera_layer0_get_mapbase_offset();
    unsigned int mapbase_bank = vera_layer0_get_mapbase_bank();

    vera_vram_data0_bank_offset(mapbase_bank, mapbase_offset, VERA_INC_1);

    // TODO: VERA MEMSET
    for(word i=0;i<64*20;i++) {
        *VERA_DATA0 = Offset;
        *VERA_DATA0 = PaletteOffset << 4;
    }
}

void vera_tile_row(byte row) {

    unsigned int mapbase_offset = vera_layer0_get_mapbase_offset();
    unsigned char mapbase_bank = vera_layer0_get_mapbase_bank();
    byte shift = vera_layer0_get_rowshift();
    mapbase_offset += ((word)row << shift);

    byte sr = ( (row % 4) / 2 ) * 2;
    byte r = (row % 2) * 2;

    vera_vram_data0_bank_offset(mapbase_bank, mapbase_offset,VERA_INC_1);
    for(byte x=0; x<TILES;x++) {
        word Segment = (word)TileFloor[x];
        struct TileSegment *TileSegment = &(TileSegmentDB[Segment]);
        for(byte sc=0;sc<2;sc++) {
            byte s = sc + sr;
            struct TilePart *TilePart = &TilePartDB[(word)TileSegment->Composition[s]];
            struct Tile *Tile = TilePart->Tile; 
            word TileOffset = TilePart->TileOffset;
            byte TilePaletteOffset = Tile->PaletteOffset << 4; 
            for(byte c=0;c<2;c++) {
                word Offset = TileOffset + r + c;
                *VERA_DATA0 = BYTE0(Offset);
                *VERA_DATA0 = TilePaletteOffset | BYTE1(Offset);
            }
        }
    }
}


void vera_tile_element(byte x, byte y, word Segment ) {

    byte resolution = 2;

    struct TileSegment *TileSegment = &(TileSegmentDB[Segment]);

    x = x << resolution;
    y = y << resolution;

    unsigned int mapbase_offset = vera_layer0_get_mapbase_offset();
    unsigned char mapbase_bank = vera_layer0_get_mapbase_bank();
    byte shift = vera_layer0_get_rowshift();
    word rowskip = vera_layer0_get_rowskip();
    mapbase_offset += ((word)y << shift);
    mapbase_offset += (x << 1); // 2 bytes per tile (one index + one palette)

    for(byte sr=0;sr<4;sr+=2) {
        for(byte r=0;r<4;r+=2) {
            vera_vram_data0_bank_offset(mapbase_bank, mapbase_offset, VERA_INC_1);
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
        mapbase_offset += rowskip;
        }
    }
}



void floor_init() {

    // Initialize the first new floor was blank tiles.

    TileFloor = TileFloorOld;

    for(byte x=0;x<TILES;x++) {
        TileFloor[x] = 0;
    }
}

void floor_draw() {

    // gotoxy(0,y*3+2);
    // printf("rnd: %02u", y);
    // gotoxy(0,y*3+2+1);
    // printf("val: %02u", y);

    TileFloorOld = TileFloor;
    TileFloorNew = TileFloorOld;
    TileFloor = TileFloorNew;

    for(byte x=0;x<TILES;x++) {

        unsigned char Rnd = BYTE0(rand());
        byte Weight = (Rnd & 17);
        struct TileWeight *TileWeight;
        for(word i=0;i<TILE_WEIGHTS;i++) {
            TileWeight = &(TileWeightDB[i]);
            if(TileWeight->Weight >= Weight)
                break;
        }
        byte Tile = TileWeight->TileSegment[(word)(Rnd & TileWeight->Count)];

    // {
    // gotoxy(6+x*6,y*3+2);
    // byte i = 4; /* however many bits are in a byte on your platform */
    // while(i--) {
    //     printf("%c", '0' + (((byte)Tile >> i) & 1)); /* loop through and print the bits */
    // }
    // }

        // byte Tile = (BYTE0(rand()) & 0x0F);

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

        TileFloor[x] = Tile;

    }

    // for(byte x=0;x<TILES;x++) {
    //     word Tile = (word)TileFloorNew[x];
    //     // gotoxy(0,12+y); printf("y%02u",y);
    //     vera_tile_element( 0, x, y, Tile);
    // }
}

void tile_background() {

    vera_layer0_set_vertical_scroll(8*64);
    
    vera_tile_clear();
    floor_init();
    for(row=63;row>=32;row--) {
        // The 3 is very important, because we draw from the bottom to the top.
        // So every 4 rows, but we draw when the row is 4, not 0;
        if(row%4==3) {
            floor_draw();
        }
        vera_tile_row(row);
    }
}

// void show_memory_map() {
//     for(byte i=0;i<TILE_TYPES;i++) {
//         struct Tile *Tile = TileDB[i];
//         byte TileOffset = Tile->TileOffset;
//         // gotoxy(0, 30+i);
//         printf("t:%u bram:%x:%p, vram:", i, (Tile->bram_handle).bank, Tile->bram_handle.ptr));
//         for(byte j=0;j<Tile->TileCount;j++) {
//             struct TilePart *TilePart = &TilePartDB[(word)(TileOffset+j)];
//             printf("%x:%p ", heap_data_bank(TilePart->VRAM_Handle), heap_data_ptr(TilePart->VRAM_Handle));
//         }
//     }
// }

void tile_cpy_vram_from_bram(struct Tile *Tile, heap_handle* vram_handle) {

    byte TileCount = Tile->TileCount;
    word TileSize = Tile->TileSize;
    byte TileOffset = Tile->TileOffset;

    for(byte t=0;t<TileCount;t++) {

        heap_handle bram_handle = Tile->bram_handle[t];

        memcpy_vram_bram(vram_handle->bank, (vram_offset_t)vram_handle->ptr, bram_handle.bank, (bram_ptr_t)bram_handle.ptr, TileSize);

        struct TilePart *TilePart = &TilePartDB[(word)(TileOffset+t)];
        // TODO: make shorter, missing fragments.
        word Offset = ((vram_offset_t)vram_handle->ptr - (word)0x2000);
        // Offset = Offset >> 4;
        // Offset = Offset >> 4;
        TilePart->TileOffset = BYTE1(Offset);
        TilePart->VRAM_Handle = *vram_handle;
        vram_handle+=TileSize;
    }
}


// Load the tile into bram using the new cx16 heap manager.
void tile_load( struct Tile *tile) {

    unsigned int status = open_file(1, 8, 0, tile->File);
    if (!status) printf("error opening file %s\n", tile->File);

    for(char s=0; s<tile->TileCount; s++) {
        heap_handle handle = heap_alloc(bins, tile->TileSize);
        unsigned int bytes_loaded = load_file_bram(1, 8, 0, handle.bank, handle.ptr, tile->TileSize);
        if (!bytes_loaded) {
            printf("error loading file %s\n", tile->File);
            break;
        }
        tile->bram_handle[s] = handle; // TODO: rework this to map into banked memory.
    }

    status = close_file(1, 8, 0);
    if (!status) printf("error closing file %s\n", tile->File);
}


// #include "equinoxe-petscii-move.c"

// void main() {


//     // We are going to use only the kernal on the X16.
//     bank_set_brom(CX16_ROM_KERNAL);

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
//         heap_vram_pack(1, (vram_offset_t)0x2000), 
//         heap_size_pack(0x8000), 
//         heap_bram_pack(1, (bram_ptr_t)0xA400), 
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

//     unsigned int sprite_palette_loaded = load_bram(1, 8, 0, FILE_PALETTES_SPRITE01, bank_bram_palettes, ptr_bram_palettes+palette_loaded);
//     if(!sprite_palette_loaded) printf("error file_palettes");
//     palette_loaded += sprite_palette_loaded;
//     heap_ptr ptr_bram_palettes_sprite = heap_data_ptr(handle_bram_palettes)+palette_loaded;

//     unsigned int floor_palette_loaded = load_bram(1, 8, 0, FILE_PALETTES_FLOOR01, bank_bram_palettes, ptr_bram_palettes+palette_loaded);
//     if(!floor_palette_loaded) printf("error file_palettes");
//     palette_loaded += floor_palette_loaded;
//     heap_ptr ptr_bram_palettes_floor = heap_data_ptr(handle_bram_palettes)+palette_loaded;

//     memcpy_vram_bram(VERA_PALETTE_BANK, (word)VERA_PALETTE_PTR+32, bank_bram_palettes, ptr_bram_palettes, palette_loaded);

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
//     bank_set_brom(CX16_ROM_BASIC);
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
