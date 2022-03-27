// Space tile scrolling engine for a space game written in kickc for the Commander X16.


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

#pragma data_seg(TileControl)

void vera_tile_clear() {

    byte PaletteOffset = 1;
    byte Offset = 100;

    vera_vram_data0_bank_offset(FLOOR_MAP_BANK_VRAM, FLOOR_MAP_OFFSET_VRAM, VERA_INC_1);

    // TODO: VERA MEMSET
    for(word i=0;i<64*20;i++) {
        *VERA_DATA0 = Offset;
        *VERA_DATA0 = PaletteOffset << 4;
    }
}

void vera_tile_row(byte row) 
{

    unsigned int mapbase_offset = FLOOR_MAP_BANK_VRAM;
    unsigned char mapbase_bank = FLOOR_MAP_OFFSET_VRAM;
    byte shift = vera_layer0_get_rowshift();
    mapbase_offset += ((word)row << shift);

    byte sr = ( (row % 4) / 2 ) * 2;
    byte r = (row % 2) * 2;

    // vera_vram_data0_bank_offset(mapbase_bank, mapbase_offset,VERA_INC_1);
    vera_vram_data0_bank_offset(mapbase_bank, mapbase_offset,VERA_INC_1);
    for(byte x=0; x<TILES;x++) {
        word Segment = (word)TileFloor[(word)TileFloorIndex].floortile[(word)x];
        struct TileSegment *TileSegment = &(TileSegmentDB[Segment]);
        for(byte sc=0;sc<2;sc++) {
            byte s = sc + sr;
            struct TilePart *TilePart = &TilePartDB[(word)TileSegment->Composition[s]];
            tile_t *tile = TilePart->Tile; 
            word TileOffset = TilePart->TileOffset;
            byte TilePaletteOffset = tile->PaletteOffset << 4; 
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

    unsigned int mapbase_offset = FLOOR_MAP_BANK_VRAM;
    unsigned char mapbase_bank = FLOOR_MAP_OFFSET_VRAM;
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
                    tile_t *tile = TilePart->Tile; 
                    word TileOffset = TilePart->TileOffset;
                    word Offset = TileOffset + r + c;
                    *VERA_DATA0 = BYTE0(Offset);
                    *VERA_DATA0 = tile->PaletteOffset << 4 | BYTE1(Offset);
                }
            }
        mapbase_offset += rowskip;
        }
    }
}



void floor_init() {

    // Initialize the first new floor was blank tiles.

    TileFloorIndex = 0;

    for(byte x=0;x<TILES;x++) {
        TileFloor[(word)TileFloorIndex].floortile[(word)x] = 0;
    }
}

void floor_draw() {

    // gotoxy(0,y*3+2);
    // printf("rnd: %02u", y);
    // gotoxy(0,y*3+2+1);
    // printf("val: %02u", y);

    unsigned char TileFloorNew = TileFloorIndex;
    TileFloorIndex = (TileFloorIndex + 1) & 0x01;
    unsigned char TileFloorOld = TileFloorIndex;

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
            byte TileLeft = TileFloor[(word)TileFloorNew].floortile[(word)x-1];
            byte TileMask = ((TileLeft << 1) & 0b1000) | ((TileLeft >> 1) & 0b0001);
            Tile = Tile & 0b0110;
            Tile = Tile | TileMask;
        }

        byte TileDown = TileFloor[(word)TileFloorOld].floortile[(word)x];
        byte TileMask = ((TileDown >> 3) & 0b0001) | ((TileDown >> 1) & 0b0010);
        Tile = Tile & 0b1100;
        Tile = Tile | TileMask;

        TileFloor[(word)TileFloorNew].floortile[(word)x] = Tile;

    }

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

void tile_cpy_vram_from_bram(tile_t *tile, heap_handle handle_vram) 
{

    unsigned char TileCount = tile->TileCount;
    unsigned int TileSize = tile->TileSize;
    word TileOffset = tile->TileOffset;

    printf("copying to vram, count=%u\n", tile->TileCount);

    for(unsigned int t=0; t<TileCount; t++) {

        printf("handle_vram=%02x:%04p", handle_vram.bank, handle_vram.ptr);

        heap_handle handle_bram = tile->handle_bram[t];
        printf(", handle_bram=%02x:%04p", handle_bram.bank, handle_bram.ptr);

        memcpy_vram_bram(handle_vram.bank, (vram_offset_t)handle_vram.ptr, handle_bram.bank, (bram_ptr_t)handle_bram.ptr, TileSize);

        struct TilePart *TilePart = &TilePartDB[TileOffset+t];
        // TODO: make shorter, missing fragments.
        word Offset = ((vram_offset_t)handle_vram.ptr - (word)0x2000);
        // Offset = Offset >> 4;
        // Offset = Offset >> 4;
        TilePart->TileOffset = BYTE1(Offset);
        handle_vram = heap_handle_add_vram(handle_vram, TileSize);
        printf("\n");
    }
    printf("\n");
}



// Load the tile into bram using the new cx16 heap manager.
void tile_load(tile_t *tile) {

    printf("loading tiles %s\n", tile->File);
    printf("tilecount=%u, tilesize=%u", tile->TileCount, tile->TileSize);
    printf(", opening\n");

    unsigned int status = open_file(1, 8, 0, tile->File);
    if (!status) printf("error opening file %s\n", tile->File);

    for(unsigned char s=0; s<tile->TileCount; s++) {
        printf("allocating");
        heap_handle handle_bram = heap_alloc(bins, tile->TileSize);
        printf(", bram=%02x:%04p", handle_bram.bank, handle_bram.ptr);
        printf(", loading");
        unsigned int bytes_loaded = load_file_bram(1, 8, 0, handle_bram.bank, handle_bram.ptr, tile->TileSize);
        if (!bytes_loaded) {
            printf("error loading file %s\n", tile->File);
            break;
        }
        printf(" %u bytes\n", bytes_loaded);
        tile->handle_bram[s] = handle_bram; // TODO: rework this to map into banked memory.
    }
    printf(", closing");

    status = close_file(1, 8, 0);
    if (!status) printf("error closing file %s\n", tile->File);

    printf(", done\n");
}

#pragma data_seg(Data)