// Space tile scrolling engine for a space game written in kickc for the Commander X16.


#include <cx16.h>
#include <cx16-veralib.h>
#include <kernal.h>
#include <6502.h>
#include <conio.h>
#include <cx16-conio.h>
#include <stdio.h>
#include <division.h>
#include <mos6522.h>
#include <multiply.h>

#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-floorengine.h"
#include "equinoxe-stage.h"
#include "equinoxe-palette.h"


void floor_paint_clear() {

    byte palette = 1;
    byte Offset = 0;

    vera_vram_data0_bank_offset(FLOOR_MAP_BANK_VRAM, FLOOR_MAP_OFFSET_VRAM, VERA_INC_1);

    // TODO: VERA MEMSET
    for(word i=0;i<64*64;i++) {
        *VERA_DATA0 = Offset;
        *VERA_DATA0 = palette << 4;
    }
}

void floor_paint_tiles(tile_segment_t* floor_segment, unsigned char row, unsigned char column) 
{
    bank_push_set_bram(BRAM_FLOOR_CONTROL);

    tile_part_t* floor_part = floor_segment->floor_parts; // todo to pass this as the parameter!
 
    unsigned int mapbase_offset = FLOOR_MAP_OFFSET_VRAM;
    unsigned char mapbase_bank = FLOOR_MAP_BANK_VRAM;

    byte shift = vera_layer0_get_rowshift();
    mapbase_offset += ((word)row << shift);
    mapbase_offset += column*8;

    byte sr = ( (row % 4) / 2 ) * 2;
    byte r = (row % 2) * 2;

    word segment = (word)TileFloor[TileFloorIndex].floortile[column];
    segment = segment << 2;
    vera_vram_data0_bank_offset(mapbase_bank, mapbase_offset,VERA_INC_1);
    gotoxy(column<<2, row);
    for(byte sc=0;sc<2;sc++) {
        byte s = sc + sr;
        unsigned char segment2 = floor_segment->slab[(unsigned char)segment+s]; // todo i need to create a new variable because the optimizer deletes the old!
        segment2 = segment2 << 2;
        for(byte c=0;c<2;c++) {
            unsigned char tile = floor_segment->composition[segment2+c+r]; // BRAM_FLOOR_CONTROL
            unsigned char palette = floor_part->palette[tile];
            palette = palette << 4; 
            *VERA_DATA0 = BYTE0(tile);
            *VERA_DATA0 = palette | BYTE1(tile);
        }
    }
    bank_pull_bram();
}


void floor_init() {

    // Initialize the first new floor was blank tiles.

    unsigned int bytes = file_load_bram(1, 8, 2, "floors.bin", BRAM_FLOOR_CONTROL, (bram_ptr_t)0xA000);
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

    // Now that we know the weight, select a record from the weight table.
    // char div = div8u(rnd,16);
    // byte Tile = rem8u;
    // byte Tile = 13;

    byte Tile = (BYTE0(rand()) & 0x0F);

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

#ifdef __DEBUG_FLOOR
    gotoxy(column<<2+10, row);
    printf("%2u", Tile);
    if(!column) {
        gotoxy(0, row);
        printf("row %2u %1u", row, TileFloorIndex);
    }
#endif
}

void floor_paint_background(tile_segment_t* floor_segments) 
{

    bank_push_set_bram(BRAM_FLOOR_CONTROL);

    vera_layer0_set_vertical_scroll(8*64);
    
    floor_paint_clear();

    TileFloorIndex = 0;
    for(byte x=0; x<TILES; x++) {
        TileFloor[(word)TileFloorIndex].floortile[(word)x] = 0;
    }

    for(floor_tile_row=FLOOR_ROW_63;floor_tile_row>=FLOOR_TILE_ROW_31;floor_tile_row--) {
        // The 3 is very important, because we draw from the bottom to the top.
        // So every 4 rows, but we draw when the row is 4, not 0;
        unsigned char column=16;
        do {
            column--;
            if(floor_tile_row%4==3) {
                floor_paint_segment(floor_tile_row, column);
            }
            floor_paint_tiles(floor_segments, floor_tile_row, column);
        } while(column>0);
    }
    floor_tile_row++;

    bank_pull_bram();
}

void floor_vram_copy(unsigned char part, tile_segment_t* floor_segments, vera_heap_segment_index_t segment) 
{
    bank_push_set_bram(BRAM_FLOOR_CONTROL);

    tile_part_t* floor_parts = floor_segments->floor_parts;

    heap_bram_fb_handle_t handle_bram = floor_parts->bram_handles[part];

    // Dynamic allocation of tiles in vera vram.
    floor_parts->vram_handles[part] = vera_heap_alloc(segment, FLOOR_TILE_SIZE);
    vram_bank_t   vram_bank   = vera_heap_data_get_bank(segment, floor_parts->vram_handles[part]);
    vram_offset_t vram_offset = vera_heap_data_get_offset(segment, floor_parts->vram_handles[part]);

    memcpy_vram_bram(vram_bank, vram_offset, heap_bram_fb_bank_get(handle_bram), heap_bram_fb_ptr_get(handle_bram), FLOOR_TILE_SIZE);

    // The offset starts at 0x2000.
    // Each tile is 0x0080 bytes large.
    // So we need to shift each tile 7 bits to the left to get the tile index.
    // However, for performance, we only need to shift with 1 bit to the right and then take the high byte.
    unsigned int offset = (vram_offset - (word)0x2000); // todo refer to the start of the tile data in vram!
    offset <<= 1; 
    floor_parts->floor_tile_offset[part] = BYTE1(offset);

    bank_pull_bram();
}



// Load the floor tiles into bram using the bram heap manager.
unsigned int floor_bram_load(unsigned int part, tile_segment_t* floor_segments, floor_bram_t * floor_bram_tile) 
{
    bank_push_set_bram(BRAM_FLOOR_CONTROL);

    tile_part_t* floor_parts = floor_segments->floor_parts;

    if(!floor_bram_tile->loaded) {

        // todo harmonize with sprite load
        char filename[16];
        strcpy(filename, floor_bram_tile->file);
        strcat(filename, ".bin");

        #ifdef __DEBUG_LOAD
        printf("\n%10s : ", filename);
        #endif

        unsigned int status = file_open(1, 8, 2, filename);
        if (status) printf("error opening file %s\n", filename);

        // Set palette offset of sprites
        floor_bram_tile->palette = stage.palette;

        for(unsigned char s=0; s<floor_bram_tile->count; s++) {
            #ifdef __DEBUG_LOAD
            printf(".");
            #endif
            heap_bram_fb_handle_t handle_bram = heap_alloc(heap_bram_blocked, floor_bram_tile->floor_tile_size);
            unsigned int read  = file_load_size(1, 8, 2, heap_bram_fb_bank_get(handle_bram), heap_bram_fb_ptr_get(handle_bram), floor_bram_tile->floor_tile_size);
            if (!read) {
                printf("error loading file %s\n", floor_bram_tile->file);
                break;
            }
            floor_parts->bram_handles[part] = handle_bram;
            floor_parts->floor_tile[part] = floor_bram_tile;

            // Assign the palette to the floor part, this is used when painting the floor.
            // The palettes are automatically painted.
            floor_parts->palette[part] = palette16_use(stage.palette);
            
            part++;
        }

        stage.palette++;

        status = file_close(1);
        if (status) printf("error closing file %s\n", floor_bram_tile->file);
        floor_bram_tile->loaded = 1;
    }

    bank_pull_bram();

    return part;
}


#pragma data_seg(Data)
