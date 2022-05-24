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

#include "equinoxe-types.h"
#include "equinoxe-floorengine.h"

// #pragma data_seg(TileControl)

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

void vera_tile_cell(unsigned char row, unsigned char column) 
{

    unsigned int mapbase_offset = FLOOR_MAP_BANK_VRAM;
    unsigned char mapbase_bank = FLOOR_MAP_OFFSET_VRAM;
    byte shift = vera_layer0_get_rowshift();
    mapbase_offset += ((word)row << shift);
    mapbase_offset += column*8;

    byte sr = ( (row % 4) / 2 ) * 2;
    byte r = (row % 2) * 2;

    // for(byte x=0; x<TILES;x++) {
        word segment = (word)TileFloor[TileFloorIndex].floortile[column];
        segment = segment << 2;
        vera_vram_data0_bank_offset(mapbase_bank, mapbase_offset,VERA_INC_1);
        for(byte sc=0;sc<2;sc++) {
            byte s = sc + sr;
            unsigned char composition = TileSegmentDB.composition[segment+s];
            tile_t *tile = TilePartDB.Tile[composition]; 
            word TileOffset = TilePartDB.TileOffset[composition];
            byte TilePaletteOffset = tile->PaletteOffset << 4; 
            for(byte c=0;c<2;c++) {
                word Offset = TileOffset + r + c;
                *VERA_DATA0 = BYTE0(Offset);
                *VERA_DATA0 = TilePaletteOffset | BYTE1(Offset);
            }
        }
    // }
}

/*
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
*/


void floor_init() {

    // Initialize the first new floor was blank tiles.

    TileFloorIndex = 0;

    for(byte x=0;x<TILES;x++) {
        TileFloor[(word)TileFloorIndex].floortile[(word)x] = 0;
    }
}

/**
 * @brief Paint the segments according a progressing tiling mechanism.
 * 
 * There are 16 tiles which have each 4 segments, and are separated by a "line".
 * In order to ensure that the segments to be painted have correct separation lines, a tile logic is required.
 * This segment paint logic works as follows.
 * Each segment is indexed according the corner "fill" property.
 * Each segment corner can be filled or can be empty. In other words, each segment can have 16 combinations.
 * These 16 combinations are represented as an index in 4 bits, a bit mask ...
 * The bits are ordered from bit 3 to bit 0 clock-wise starting from the top left corner:
 * 
 *   - bit 3 = top left corner
 *   - bit 2 = top right corner
 *   - bit 1 = bottom right corner
 *   - bit 0 = bottom left corner
 * 
 *     00 = 0000  01 = 0001  02 = 0010  03 = 0011  04 = 0100  05 = 0101  06 = 0110  07 = 0111
 *     # # # # #  # # # # #  # # # # #  # # # # #  # # # # #  # # # # #  # # # # #  # # # # #   
 *     # 0 | 0 #  # 0 | 0 #  # 0 | 0 #  # 0 | 0 #  # 0 | 1 #  # 0 | 1 #  # 0 | 1 #  # 0 | 1 #        
 *     # - + - #  # - + - #  # - + - #  # - + - #  # - + - #  # - + - #  # - + - #  # - + - #        
 *     # 0 | 0 #  # 1 | 0 #  # 0 | 1 #  # 1 | 1 #  # 0 | 0 #  # 1 | 0 #  # 0 | 1 #  # 1 | 1 #        
 *     # # # # #  # # # # #  # # # # #  # # # # #  # # # # #  # # # # #  # # # # #  # # # # #        
 * 
 *     08 = 1000  09 = 1001  10 = 1010  11 = 1011  12 = 1100  13 = 1101  14 = 1110  15 = 1111
 *     # # # # #  # # # # #  # # # # #  # # # # #  # # # # #  # # # # #  # # # # #  # # # # #   
 *     # 1 | 0 #  # 1 | 0 #  # 1 | 0 #  # 1 | 0 #  # 1 | 1 #  # 1 | 1 #  # 1 | 1 #  # 1 | 1 #        
 *     # - + - #  # - + - #  # - + - #  # - + - #  # - + - #  # - + - #  # - + - #  # - + - #        
 *     # 0 | 0 #  # 1 | 0 #  # 0 | 1 #  # 1 | 1 #  # 0 | 0 #  # 1 | 0 #  # 0 | 1 #  # 1 | 1 #        
 *     # # # # #  # # # # #  # # # # #  # # # # #  # # # # #  # # # # #  # # # # #  # # # # #        
 * 
 * The segment painting is nothing more than selecting the correct segments for a row.
 * In order to achieve this, the logic works with 2 arrays of 16 bytes, that represent the "New" and the "Old" segment rows.
 * The painting works from bottom to top, so the old segment row will be at the bottom from the new segment row.
 * 
 * The new segments are painted from right to left on the new row, and are carefully selected so that:
 * 
 *   - the new left segment glues with the new right segment row.
 *   - the new left segment glues with the old bottom segment row.
 * 
 *  
 * @param row 
 * @param column 
 */
void floor_paint_segment(unsigned char row, unsigned char column) 
{
    TileFloorIndex = row>>2 & 0x01;
    unsigned char TileFloorNew = TileFloorIndex;
    unsigned char TileFloorOld = ~TileFloorIndex & 0x01;

    unsigned char rnd = BYTE0(rand());
    byte Weight = rnd % 16;
    struct TileWeight *TileWeight;
    for(word i=0;i<TILE_WEIGHTS;i++) {
        TileWeight = &(TileWeightDB[i]);
        if(TileWeight->Weight >= Weight) {
            break;
        }
    }

    // Now that we know the weight, select a record from the weight table.
    char div = div8u(rnd,TileWeight->Count);
    byte Tile = TileWeight->TileSegment[rem8u];

    // byte Tile = (BYTE0(rand()) & 0x0F);

    if(column<15) {
        byte TileRight = TileFloor[TileFloorNew].floortile[column+1];
        byte TileMask = ((TileRight >> 1) & 0b0100) | ((TileRight << 1) & 0b0010);
        Tile = Tile & 0b1001;
        Tile = Tile | TileMask;
    }

    byte TileDown = TileFloor[TileFloorOld].floortile[column];
    byte TileMask = ((TileDown >> 3) & 0b0001) | ((TileDown >> 1) & 0b0010);
    Tile = Tile & 0b1100;
    Tile = Tile | TileMask;

    TileFloor[TileFloorNew].floortile[column] = Tile;

    // gotoxy(column<<2+10, row);
    // printf("%2u", Tile);
    // if(!column) {
    //     gotoxy(0, row);
    //     printf("row %2u %1u", row, TileFloorIndex);
    // }
}

void tile_background() {

    vera_layer0_set_vertical_scroll(8*64);
    
    vera_tile_clear();
    floor_init();
    for(floor_tile_row=FLOOR_ROW_63;floor_tile_row>=FLOOR_TILE_ROW_31;floor_tile_row--) {
        // The 3 is very important, because we draw from the bottom to the top.
        // So every 4 rows, but we draw when the row is 4, not 0;
        unsigned char column=16;
        do {
            column--;
            if(floor_tile_row%4==3) {
                floor_paint_segment(floor_tile_row, column);
            }
            vera_tile_cell(floor_tile_row, column);
        } while(column>0);
    }
    floor_tile_row++;
}

// void show_memory_map() {
//     for(byte i=0;i<TILE_TYPES;i++) {
//         struct Tile *Tile = TileDB[i];
//         byte TileOffset = Tile->TileOffset;
//         // gotoxy(0, 30+i);
//         printf("t:%u bram:%x:%p, vram:", i, (Tile->bram_handle).bank, Tile->bram_handle.ptr));
//         for(byte j=0;j<Tile->count;j++) {
//             struct TilePart *TilePart = &TilePartDB[(word)(TileOffset+j)];
//             printf("%x:%p ", heap_data_bank(TilePart->VRAM_Handle), heap_data_ptr(TilePart->VRAM_Handle));
//         }
//     }
// }

void tile_vram_allocate(tile_t *tile, vera_heap_segment_index_t segment) 
{

    unsigned char tile_count = tile->count;
    unsigned int tile_size = tile->TileSize;
    word tile_offset = tile->TileOffset;

    printf("copying to vram, count=%u\n", tile->count);

    for(unsigned int t=0; t<tile_count; t++) {


        fb_heap_handle_t handle_bram = tile->bram_handle[t];
        printf("handle_bram=%02x:%04p", handle_bram.bank, handle_bram.ptr);

        tile->vera_heap_index[t] = vera_heap_alloc(segment, tile_size);
        vram_bank_t   vram_bank   = vera_heap_data_get_bank(segment, tile->vera_heap_index[t]);
        vram_offset_t vram_offset = vera_heap_data_get_offset(segment, tile->vera_heap_index[t]);

        printf(", handle_vram=%02x:%04p", vram_bank, vram_offset);

        memcpy_vram_bram(vram_bank, vram_offset, handle_bram.bank, (bram_ptr_t)handle_bram.ptr, tile_size);

        // struct TilePart *TilePart = &TilePartDB[TileOffset+t];
        // TODO: make shorter, missing fragments.
        word Offset = (vram_offset - (word)0x2000);
        // Offset = Offset >> 4;
        // Offset = Offset >> 4;
        TilePartDB.TileOffset[tile_offset+t] = BYTE1(Offset);
    }
}



// Load the tile into bram using the new cx16 heap manager.
void tile_load(tile_t *tile) {

    printf("loading tiles %s\n", tile->file);
    printf("tilecount=%u, tilesize=%u", tile->count, tile->TileSize);
    // printf(", opening\n");

    unsigned int status = open_file(1, 8, 0, tile->file);
    if (status) printf("error opening file %s\n", tile->file);

    for(unsigned char s=0; s<tile->count; s++) {
        // printf("allocating");
        fb_heap_handle_t handle_bram = heap_alloc(bins, tile->TileSize);
        // printf(", bram=%02x:%04p", handle_bram.bank, handle_bram.ptr);
        // printf(", loading");
        unsigned int bytes_loaded = load_file_bram(1, 8, 0, handle_bram.bank, handle_bram.ptr, tile->TileSize);
        if (!bytes_loaded) {
            printf("error loading file %s\n", tile->file);
            break;
        }
        printf(" %u bytes", bytes_loaded);
        tile->bram_handle[s] = handle_bram; // TODO: rework this to map into banked memory.
    }
    // printf(", closing");

    status = close_file(1, 8, 0);
    if (status) printf("error closing file %s\n", tile->file);

    printf(", done\n");
}

#pragma data_seg(Data)
