// Space tile scrolling engine for a space game written in kickc for the Commander X16.


#include <cx16.h>
#include <cx16-veralib.h>
#include <cx16-veraheap.h>
#include <cx16-file.h>
#include <kernal.h>
#include <6502.h>
#include <conio.h>
#include <cx16-conio.h>
#include <stdio.h>
#include <division.h>
#include <mos6522.h>
#include <multiply.h>
#include <cx16-heap-bram-fb.h>

#include "equinoxe-types.h"
#include "equinoxe.h"
#include "equinoxe-floorengine.h"
#include "equinoxe-stage.h"
#include "equinoxe-palette.h"

floor_layer_t floor_layer[2] = {
    { FLOOR_MAP0_BANK_VRAM, FLOOR_MAP0_OFFSET_VRAM },
    { FLOOR_MAP1_BANK_VRAM, FLOOR_MAP1_OFFSET_VRAM }
};

floor_cache_t floor_cache[FLOOR_CACHE_LAYERS * FLOOR_CACHE_ROWS * FLOOR_CACHE_COLUMNS];

floor_scroll_t floor_pos;

// #pragma var_model(zp)

void floor_draw_clear(unsigned char layer)
{
    bank_push_set_bram(BRAM_ENGINE_FLOOR);

    unsigned char palette = 0;
    unsigned char Offset = 0;

    vera_vram_data0_bank_offset(floor_layer[layer].bank, floor_layer[layer].offset, VERA_INC_1);

    // TODO: VERA MEMSET
    for (unsigned int i = 0; i < 32 * 64; i++) {
        *VERA_DATA0 = BYTE0(Offset);
        *VERA_DATA0 = BYTE1(Offset);
    }

    bank_pull_bram();
}

void floor_clear_row(unsigned char layer, floor_t* floor, unsigned char x, unsigned char y)
{
    bank_push_set_bram(BRAM_ENGINE_FLOOR);

    unsigned int row = (word)y << 2;
    unsigned int column = (word)x;

    floor_parts_t* floor_parts = floor->floor_parts; // todo to pass this as the parameter!


    unsigned char mapbase_bank = floor_layer[layer].bank;
    unsigned int mapbase_offset = floor_layer[layer].offset;

    unsigned char shift = vera_layer0_get_rowshift();
    mapbase_offset += ((word)row << shift);
    mapbase_offset += column * 8;

    for (unsigned char sr = 0; sr < 4; sr += 2) {
        for (unsigned char r = 0; r < 4; r += 2) {
            vera_vram_data0_bank_offset(mapbase_bank, mapbase_offset, VERA_INC_1);
            for (unsigned char sc = 0; sc < 2; sc++) {
                unsigned char s = sc + sr;
                for (unsigned char c = 0; c < 2; c++) {
                    *VERA_DATA0 = 0;
                    *VERA_DATA0 = 0;
                }
            }
            mapbase_offset += 64 * 2;
        }
    }

    bank_pull_bram();
}


void floor_draw_row(unsigned char layer, floor_t* floor, unsigned char row, unsigned char column)
{
    bank_push_set_bram(BRAM_ENGINE_FLOOR);

    floor_parts_t* floor_parts = floor->floor_parts; // todo to pass this as the parameter!

    unsigned char mapbase_bank = floor_layer[layer].bank;
    unsigned int mapbase_offset = floor_layer[layer].offset;

    unsigned char shift = vera_layer0_get_rowshift();
    mapbase_offset += ((word)row << shift);
    mapbase_offset += column * 8;

    unsigned char sr = ((row % 4) / 2) * 2;
    unsigned char r = (row % 2) * 2;

    unsigned char cache = FLOOR_CACHE(layer, row / 4, column);
    word segment = (word)floor_cache[cache];
    segment = segment << 2;
    vera_vram_data0_bank_offset(mapbase_bank, mapbase_offset, VERA_INC_1);
    for (unsigned char sc = 0;sc < 2;sc++) {
        unsigned char s = sc + sr;
        unsigned char segment2 = floor->slab[(unsigned char)segment + s]; // todo i need to create a new variable because the optimizer deletes the old!
        segment2 = segment2 << 2;
        for (unsigned char c = 0;c < 2;c++) {
            unsigned char tile = floor->composition[segment2 + c + r]; // BRAM_ENGINE_FLOOR
            unsigned int offset = floor_parts->floor_tile_offset[tile];
            unsigned char palette = floor_parts->palette[tile];
            palette = palette << 4;
            *VERA_DATA0 = BYTE0(offset);
            *VERA_DATA0 = palette | BYTE1(offset);
        }
    }
    bank_pull_bram();
}


unsigned char FLOOR_CACHE(unsigned char layer, unsigned char row, unsigned char column)
{
    return ((char)((char)(layer << 7) | (char)(row << 4) | (char)(column)));
}

void floor_init()
{

    // Initialize the first new floor was blank tiles.

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
 * In order to achieve this, the logic works with 2 arrays of 16 unsigned chars, that represent the "New" and the "Old" segment rows.
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
void floor_paint(unsigned char row, unsigned char column)
{
    unsigned char rnd = BYTE0(rand());

    unsigned char cache;

    // Now that we know the weight, select a record from the weight table.
    // char div = div8u(rnd,16);
    // unsigned char tile = rem8u;
    // unsigned char tile = 13;

    unsigned char tile = (BYTE0(rand()) & 0x0F);

    if (column < 15) {
        // unsigned char TileRight = floor_cache.layer[0].row[row].column[column+1];
        cache = FLOOR_CACHE(0, row, column + 1);
        unsigned char TileRight = floor_cache[cache];
        unsigned char TileMask = ((TileRight >> 1) & 0b0100) | ((TileRight << 1) & 0b0010);
        tile = tile & 0b1001;
        tile = tile | TileMask;
    }

    // unsigned char TileDown = floor_cache.layer[0].row[(row+1)&0x0F].column[column];
    cache = FLOOR_CACHE(0, (row + 1) & 0x07, column);
    unsigned char TileDown = floor_cache[cache];
    unsigned char TileMask = ((TileDown >> 3) & 0b0001) | ((TileDown >> 1) & 0b0010);
    tile = tile & 0b1100;
    tile = tile | TileMask;

    cache = FLOOR_CACHE(0, row, column);
    floor_cache[cache] = tile;

#ifdef __DEBUG_FLOOR
    gotoxy(column << 2 + 10, row);
    printf("%2u", tile);
    if (!column) {
        gotoxy(0, row);
        printf("row %2u", row);
    }
#endif
}

void floor_paint_background(unsigned char layer, floor_t* floor)
{
    bank_push_set_bram(BRAM_ENGINE_FLOOR);

    unsigned char cache;

    for (unsigned char column = 0; column < 16; column++) {
        cache = FLOOR_CACHE(layer, 0, column);
        floor_cache[cache] = 0;
    }

    unsigned char row = 8;
    do {
        row--;
        // The 3 is very important, because we draw from the bottom to the top.
        // So every 4 rows, but we draw when the row is 4, not 0;
        unsigned char column = 16;
        do {
            column--;
            floor_paint(row, column);
        } while (column);
    } while (row);

    bank_pull_bram();
}

void floor_draw_background(unsigned char layer, floor_t* floor)
{
    bank_push_set_bram(BRAM_ENGINE_FLOOR);

    unsigned char row_draw = 32;
    do {
        row_draw--;
        // The 3 is very important, because we draw from the bottom to the top.
        // So every 4 rows, but we draw when the row is 4, not 0;
        unsigned char column_draw = 16;
        do {
            column_draw--;
            floor_draw_row(layer, floor, row_draw, column_draw);
        } while (column_draw);
    } while (row_draw);

    bank_pull_bram();
}

vera_heap_handle_t floor_part_alloc_vram(unsigned char part, floor_parts_t* floor_parts, vera_heap_segment_index_t segment)
{
    // Dynamic allocation of tiles in vera vram.
    vera_heap_handle_t vram_handle = vera_heap_alloc(segment, FLOOR_TILE_SIZE);
    vram_bank_t   vram_bank = vera_heap_data_get_bank(segment, vram_handle);
    vram_offset_t vram_offset = vera_heap_data_get_offset(segment, vram_handle);

    floor_parts->vram_handles[part] = vram_handle;

    // The offset starts at 0x2000.
    // Each tile is 0x0080 unsigned chars large.
    // So we need to shift each tile 7 bits to the left to get the tile index.
    unsigned int volatile offset = vram_offset - (unsigned int)0x2000; // todo refer to the start of the tile data in vram!

    offset >>= 7;

    // asm {
    //     asl offset
    //     rol offset+1
    //     lda offset+1
    //     sta offset
    //     lda #$00
    //     sta offset+1
    // }

    floor_parts->floor_tile_offset[part] = offset;

    return vram_handle;
}

void floor_part_memset_vram(unsigned char part, floor_t* floor, unsigned char pattern)
{
    bank_push_set_bram(BRAM_ENGINE_FLOOR);

    floor_parts_t* floor_parts = floor->floor_parts;

    vera_heap_handle_t vram_handle = floor_part_alloc_vram(part, floor_parts, VERA_HEAP_SEGMENT_TILES);

    vram_bank_t   vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_TILES, vram_handle);
    vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_TILES, vram_handle);
    memset_vram(vram_bank, vram_offset, pattern, FLOOR_TILE_SIZE);

    bank_pull_bram();

    floor->parts_count++;

}

void floor_part_memcpy_vram_bram(unsigned char part, floor_t* floor)
{
    bank_push_set_bram(BRAM_ENGINE_FLOOR);

    floor_parts_t* floor_parts = floor->floor_parts;

    vera_heap_handle_t vram_handle = floor_part_alloc_vram(part, floor_parts, VERA_HEAP_SEGMENT_TILES);
    vram_bank_t   vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_TILES, floor_parts->vram_handles[part]);
    vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_TILES, floor_parts->vram_handles[part]);

    heap_bram_fb_handle_t bram_handle = floor_parts->bram_handles[part];
    bram_bank_t   bram_bank = heap_bram_fb_bank_get(bram_handle);
    bram_ptr_t    bram_ptr = heap_bram_fb_ptr_get(bram_handle);

    memcpy_vram_bram(vram_bank, vram_offset, bram_bank, bram_ptr, FLOOR_TILE_SIZE);

    bank_pull_bram();
}



// Load the floor tiles into bram using the bram heap manager.
unsigned char floor_parts_load_bram(unsigned char part, floor_t* floor, floor_bram_tiles_t* floor_bram_tile)
{
    bank_push_set_bram(BRAM_ENGINE_FLOOR);

    // printf("load:floor = %p\n", floor);

    floor_parts_t* floor_parts = floor->floor_parts;

    // printf("floor parts = %p", floor_parts);


    if (!floor_bram_tile->loaded) {

        // todo harmonize with sprite load
        char filename[16];
        strcpy(filename, floor_bram_tile->file);
        strcat(filename, ".bin");

#ifdef __DEBUG_LOAD
        printf("\n%10s : ", filename);
#endif

        FILE* fp = fopen(filename,"r");
        if (fp) {

            // Set palette offset of sprites
            floor_bram_tile->palette = stage.palette;

            unsigned int count = floor_bram_tile->count;
            unsigned int size = floor_bram_tile->floor_tile_size;

            for (unsigned char s = 0; s < floor_bram_tile->count; s++) {
#ifdef __DEBUG_LOAD
                printf(".");
#endif
                heap_bram_fb_handle_t handle_bram = heap_alloc(heap_bram_blocked, size);
                bram_bank_t bram_bank = heap_bram_fb_bank_get(handle_bram);
                bram_ptr_t bram_ptr = heap_bram_fb_ptr_get(handle_bram);
                bank_push_set_bram(bram_bank);
                unsigned int read = fgets(bram_ptr, size, fp);
                bank_pull_bram();
                if (!read) {
#ifdef __INCLUDE_PRINT
                    printf("error loading file %s\n", fp->filename);
                    break;
#endif
                } else {
                    floor_parts->bram_handles[part] = handle_bram;
                    floor_parts->floor_tile[part] = floor_bram_tile;

                    // Assign the palette to the floor part, this is used when painting the floor.
                    // The palettes are automatically painted.
                    floor_parts->palette[part] = palette16_use(stage.palette);

                    part++;
                }
            }

            stage.palette++;

            if (fclose(fp)) {
#ifdef __INCLUDE_PRINT
                printf("error closing file %s\n", floor_bram_tile->file);
#endif
            } else {
                floor_bram_tile->loaded = 1;
            }
        } else {
#ifdef __INCLUDE_PRINT
            if (status) printf("error opening file %s\n", fp->filename);
#endif
        }
    }

    bank_pull_bram();

    floor->parts_count = part - 1;

    return part;
}

void floor_scroll()
{


    // We only will execute the scroll logic when a scroll action needs to be done.
    if (!game.screen_vscroll_wait--) {
        game.screen_vscroll_wait = 4;

        unsigned char row = (char)((game.screen_vscroll - 16) / 16);
        row %= 32;

        // There are 16 scroll iterations as the height of the tiles is 16 pixels.
        // Each segment is 4 tiles on the x axis, so the total amount of tiles are 64 tiles of 16 pixels wide.
        // So there are 16 segments to be painted on each row.
        // That allows to paint a segment per scroll action!
        // We decrease the column for tiling, and ensure that we never go above 16.
        floor_pos.tile_column = (game.screen_vscroll - 16) % 16;
        floor_pos.tile_row = row / 4;

        // We paint from bottom to top. Each paint segment is 64 pixels on the y axis, so we must paint every 4 rows.
        // We paint when the row is the bottom row of the paint segment, so row 3. Row 0 is the top row of the segment.
        if (row % 4 == 3) {
#ifdef __TOWER
            floor_paint(floor_pos.tile_row, floor_pos.tile_column);
            tower_paint(floor_pos.tile_row, floor_pos.tile_column);
#else
            floor_paint(floor_pos.tile_row, floor_pos.tile_column);
#endif
        }

        // Now that the segment for the respective floor_tile_row and floor_tile_column has been painted,
        // we can draw a cell from the painted segment. Note that when floor_tile_row is 0, 1 or 2,
        // all paint segments will have been painted on the paint buffer, and the tiling will just pick
        // row 2, 1 or 0 from the paint segment...
        floor_draw_row(0, stage.floor, row, floor_pos.tile_column);
#ifdef __LAYER1
        floor_draw_row(1, stage.towers, row, floor_pos.tile_column);
#endif

#ifdef __TOWER
        tower_move();
#endif

        // Now we set the vertical scroll to the required scroll position.
        vera_layer0_set_vertical_scroll(game.screen_vscroll);
#ifdef __TOWER
        vera_layer1_set_vertical_scroll(game.screen_vscroll);
#endif
        game.screen_vscroll--;
    }
}


#pragma data_seg(Data)

// #pragma var_model(mem)

