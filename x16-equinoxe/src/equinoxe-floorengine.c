// Space tile scrolling engine for a space game written in kickc for the Commander X16.

#include "equinoxe.h"

#pragma data_seg(DATA_ENGINE_FLOOR)
#pragma code_seg(CODE_ENGINE_FLOOR)

floor_cache_t floor_cache[FLOOR_CACHE_ROWS * FLOOR_CACHE_COLUMNS];

floor_layer_vram_offset_t floor_layer_offsets[2];

floor_scroll_t floor_pos;

// #pragma var_model(zp)

void floor_draw_clear(floor_t *floor) {
    bank_push_set_bram(BANK_ENGINE_FLOOR);

    unsigned char palette = 0;
    unsigned char Offset = 0;

    for (unsigned char layer = 0; layer < game.layers; layer++) {

        unsigned char mapbase_bank = floor_layer_offsets[layer].bank;
        unsigned int mapbase_offset = floor_layer_offsets[layer].offset;
        vera_vram_data0_bank_offset(mapbase_bank, mapbase_offset, VERA_INC_1);

        // TODO: VERA MEMSET
        for (unsigned int i = 0; i < 64 * 32; i++) {
            *VERA_DATA0 = BYTE0(Offset);
            *VERA_DATA0 = BYTE1(Offset);
        }
    }

    bank_pull_bram();
}

void floor_clear_row(floor_t *floor, unsigned char x, unsigned char y) {
    bank_push_set_bram(BANK_ENGINE_FLOOR);

    floor_parts_t *floor_parts = floor->floor_parts;

    floor_composition_t *floor_composition = &floor->floor_compositions[0];
    floor_layer_composition_t *floor_layer_composition = floor_composition->floor_layer_compositions;

    for (unsigned char layer = 0; layer < game.layers; layer++) {

        floor_layer_t *floor_layer = floor_layer_composition[layer].floor_layer;

        unsigned int row = (word)y << 2;
        unsigned int column = (word)x;

        unsigned char mapbase_bank = floor_layer_offsets[layer].bank;
        unsigned int mapbase_offset = floor_layer_offsets[layer].offset;

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
    }

    bank_pull_bram();
}

unsigned char floor_calculate_segment_index(floor_layer_t *floor_layer, unsigned char segment) {

    // BREAKPOINT
    unsigned char segment_offset = floor_layer->segment_index.offsets[segment];
    unsigned char segment_variations = floor_layer->segment_index.variations[segment];
    unsigned char segment_index = segment_offset;

    switch (segment_variations) {
    case 1:
        break;
    case 2:
        segment_index += ((unsigned char)rand()) % 2;
        break;
    case 4:
        segment_index += ((unsigned char)rand()) % 4;
        break;
    }
    return segment_index;
}

void floor_draw_row(floor_t *floor, unsigned char row, unsigned char column) {
    bank_push_set_bram(BANK_ENGINE_FLOOR);

    floor_parts_t *floor_parts = floor->floor_parts;

    __mem unsigned char cache = FLOOR_CACHE(row / 4, column);
    __mem unsigned int cache_segment = (word)floor_cache[cache];

    floor_composition_t *floor_composition = &floor->floor_compositions[cache_segment];

    for (__mem unsigned char layer = 0; layer < game.layers; layer++) {

        floor_layer_composition_t *floor_layer_composition = &floor_composition->floor_layer_compositions[layer];
        floor_layer_t *floor_layer = floor_layer_composition->floor_layer;
        unsigned char *floor_segments = floor_layer_composition->floor_segments;
        __mem unsigned char layer_offset = floor_layer->segment_offset;

        __mem unsigned char mapbase_bank = floor_layer_offsets[layer].bank;
        __mem unsigned int mapbase_offset = floor_layer_offsets[layer].offset;

        __mem unsigned char shift = vera_layer0_get_rowshift();
        mapbase_offset += ((word)row << shift);
        mapbase_offset += column * 8;

        __mem unsigned char sr = ((row % 4) / 2) * 2;
        __mem unsigned char r = (row % 2) * 2;

        // char buffer[80] = "";
        vera_vram_data0_bank_offset(mapbase_bank, mapbase_offset, VERA_INC_1);
        for (__mem unsigned char sc = 0; sc < 2; sc++) {
            __mem unsigned char s = sc + sr;
            // sprintf(buffer, "layer=%u, layer_offset=%u, s=%u, cache_segment=%u ", layer, layer_offset, s, cache_segment);
            // BREAKPOINT
            __mem unsigned char segment = floor_segments[s];
            // sprintf(buffer, "layer=%u, segment=%u ", layer, segment);
            // BREAKPOINT
            __mem unsigned char segment_index = floor_calculate_segment_index(floor_layer, segment);
            // sprintf(buffer, "layer=%u, segment_index=%u ", layer, segment_index);
            // BREAKPOINT
            for (__mem unsigned char c = 0; c < 2; c++) {
                floor_segment_t *floor_segment = &floor_layer->segments[segment_index];
                __mem unsigned char tile = floor_segment->tiles[c + r]; // BANK_ENGINE_FLOOR
                if (tile > 0)
                    tile = tile + layer_offset;
                __mem unsigned int offset = floor_parts->floor_tile_offset[(unsigned int)tile];
                // sprintf(buffer, "layer=%u, segment=%u, cache_segment=%u, tile=%u? offset=%u? floor_parts->floor_tile_offset*=%04p ", layer, segment_index,
                // cache_segment, tile, offset, floor_parts->floor_tile_offset); BREAKPOINT
                __mem unsigned char palette = floor_parts->palette[(unsigned int)tile];
                palette = palette << 4;
                *VERA_DATA0 = BYTE0(offset);
                *VERA_DATA0 = palette | BYTE1(offset);
                // sprintf(buffer, "layer=%u, segment=%u, cache_segment=%u, tile=%u ", layer, segment_index, cache_segment, tile);
                // BREAKPOINT
            }
        }
    }
    bank_pull_bram();
}

inline unsigned char FLOOR_CACHE(__mem unsigned char row, __mem unsigned char column) { return ((char)((char)(row << 4) | (char)(column))); }

void floor_init() {

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
void floor_paint(unsigned char column, unsigned char row) {
    __mem unsigned char rnd = BYTE0(rand());

    __mem unsigned char cache;

    // Define the down tile to be glued.
    // cache = ;
    __mem unsigned char tile_down = floor_cache[FLOOR_CACHE((row + 1) & 0x07, column)];
    __mem unsigned char tile_left_down = floor_cache[FLOOR_CACHE((row + 1) & 0x07, column-1)];

    // Define the right tile to be glued.
    // If the column is 15, then the right tile is the tile randomized (there is no start point).
    __mem unsigned char tile_right = tile_down;
    // If the column is less than 15, then the right tile is the tile from the right in the cache.
    if (column < 15) {
        cache = FLOOR_CACHE(row, column + 1);
        tile_right = floor_cache[cache];
    }

    __mem unsigned char weight = (BYTE0(rand()) & 0x0F);
    __mem unsigned char tile = 0x0F;
    if (weight < game.floor_border) {
        // do {
            tile = (BYTE0(rand()) & 0x0F);
        // } while(tile != 0b0110 && tile != 0b1001);
    } else {
        if (weight < game.floor_empty) {
            tile = 0x00;
        }
    }

    // Now we mask the down tile to get the correct glue for the tile.
    // When the down tile type is not equal to the tile type, then we don't glue!
    __mem unsigned char tile_mask_down_right = (((tile_down & 0b1111) >> 2) & 0b0001);
    __mem unsigned char tile_mask_down_left = (((tile_down & 0b1111) >> 2) & 0b0010);
    __mem unsigned char tile_down_mask = tile_mask_down_left | tile_mask_down_right;
    tile = tile & 0b1100;
    tile = tile | tile_down_mask;

    // Now we glue the tile to the right, there are no restrictions here.
    if (column < 15) {
        cache = FLOOR_CACHE(row, column + 1);
        tile_right = floor_cache[cache];
        __mem unsigned char tile_mask_right_up = (((tile_right & 0b1111) >> 1) & 0b0100);
        __mem unsigned char tile_mask_right_down = (((tile_right & 0b1111) >> 1) & 0b0001);
        __mem unsigned char tile_right_mask = tile_mask_right_up | tile_mask_right_down;
        tile = tile & 0b1010;
        tile = tile | tile_right_mask;
    }

    // The right tile type is the same as the down tile type as a a start point.
    __mem unsigned char tile_right_type = tile_right & 0b11110000;
    __mem unsigned char tile_down_type = tile_down & 0b11110000;
    __mem unsigned char tile_left_down_type = tile_left_down & 0b11110000;

    // By default, the tile type of the new tile is equal to the tile on the right.
    __mem unsigned char tile_type = tile_right_type;

    if (tile == 0b0111) {
        __mem unsigned char weight = rand();
        if(weight<224) {
            tile_type = ((char)rand() & 0x10) + ((char)rand() & 0x10);
        }
    } else {
        // if (tile == 0b1000) {
        //     tile_type = 0x20;
        // } else {
            if ((tile | 0b1011) == 0b1011) {
                // if(tile == 0b0011 || tile == 0b1011 || tile == 0b0001 || tile == 0b1001) {
                tile_type = tile_right_type;
            } else {
                tile_type = tile_down_type;
            }
        // }
    }

    // We need to adjust when the down tile type is not equal to the right tile type!
    if (tile_type != tile_down_type) {
        if (tile != 0b1001) {
            tile |= 0b0011; // We ensure that the right down and left down glue is set in the tile.
            tile_down |= 0b1100;
        } else {
            tile |= 0b0001;
            tile_down |= 0b0100;
        }
    }

    if(tile == 0b1001) {
        if(tile_type != tile_down_type) {
            tile_type = tile_down_type;
            tile = tile | 0b1100;
            tile_right = tile_right | 0b1010;
        }
    }
    

    tile |= tile_type;

    cache = FLOOR_CACHE(row, column); // paint tile
    floor_cache[cache] = tile;

    cache = FLOOR_CACHE((row + 1) & 0x07, column); // down tile
    floor_cache[cache] = tile_down;

    if(column<15)
        floor_cache[FLOOR_CACHE(row, column+1)] = tile_right;

#ifdef __DEBUG_FLOOR
    gotoxy(column << 2 + 10, row);
    printf("%2u", tile);
    if (!column) {
        gotoxy(0, row);
        printf("row %2u", row);
    }
#endif
}

void floor_paint_background() {
    bank_push_set_bram(BANK_ENGINE_FLOOR);

    unsigned char cache;
    for (unsigned char column = 0; column < FLOOR_CACHE_COLUMNS; column++) {
        cache = FLOOR_CACHE(0, column);
        floor_cache[cache] = 0;
    }

    unsigned char row = FLOOR_CACHE_ROWS;
    do {
        row--;
        // The 3 is very important, because we draw from the bottom to the top.
        // So every 4 rows, but we draw when the row is 4, not 0;
        unsigned char column = FLOOR_CACHE_COLUMNS;
        do {
            column--;
            floor_paint(row, column);
        } while (column);
    } while (row);

    bank_pull_bram();
}

void floor_draw_background(floor_t *floor) {
    bank_push_set_bram(BANK_ENGINE_FLOOR);

    unsigned char row_draw = 32;
    do {
        row_draw--;
        // The 3 is very important, because we draw from the bottom to the top.
        // So every 4 rows, but we draw when the row is 4, not 0;
        unsigned char column_draw = FLOOR_CACHE_COLUMNS;
        do {
            column_draw--;
            floor_draw_row(floor, row_draw, column_draw);
        } while (column_draw);
    } while (row_draw);

    bank_pull_bram();
}

vera_heap_handle_t floor_part_alloc_vram(unsigned char part, floor_parts_t *floor_parts, vera_heap_segment_index_t segment) {
    bank_push_set_bram(BANK_ENGINE_FLOOR);

    // Dynamic allocation of tiles in vera vram.
    vera_heap_handle_t vram_handle = vera_heap_alloc(segment, FLOOR_TILE_SIZE);
    vram_bank_t vram_bank = vera_heap_data_get_bank(segment, vram_handle);
    vram_offset_t vram_offset = vera_heap_data_get_offset(segment, vram_handle);

    floor_parts->vram_handles[(unsigned int)part] = vram_handle;

    // The offset starts at 0x2000.
    // Each tile is 0x0080 unsigned chars large.
    // So we need to shift each tile 7 bits to the left to get the tile index.
    unsigned int volatile offset = vram_offset - (unsigned int)FLOOR_TILE_OFFSET_VRAM; // todo refer to the start of the tile data in vram!

    offset >>= 7;

    // asm {
    //     asl offset
    //     rol offset+1
    //     lda offset+1
    //     sta offset
    //     lda #$00
    //     sta offset+1
    // }

    floor_parts->floor_tile_offset[(unsigned int)part] = offset;

    bank_pull_bram();

    return vram_handle;
}

void floor_part_memset_vram(unsigned char part, floor_t *floor, unsigned char pattern) {
    bank_push_set_bram(BANK_ENGINE_FLOOR);

    floor_parts_t *floor_parts = floor->floor_parts;

    vera_heap_handle_t vram_handle = floor_part_alloc_vram(part, floor_parts, VERA_HEAP_SEGMENT_TILES);

    vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_TILES, vram_handle);
    vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_TILES, vram_handle);
    memset_vram(vram_bank, vram_offset, pattern, FLOOR_TILE_SIZE);

    floor_parts->floor_tile_offset[0] = 0;
    floor_parts->palette[0] = 0;

    floor->parts_count++;

    bank_pull_bram();
}

void floor_part_memcpy_vram_bram(unsigned char part, floor_t *floor) {
    bank_push_set_bram(BANK_ENGINE_FLOOR);

    floor_parts_t *floor_parts = floor->floor_parts;

    vera_heap_handle_t vram_handle = floor_part_alloc_vram(part, floor_parts, VERA_HEAP_SEGMENT_TILES);
    vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_TILES, floor_parts->vram_handles[part]);
    vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_TILES, floor_parts->vram_handles[part]);

    bram_heap_handle_t bram_handle = floor_parts->bram_handles[(unsigned int)part];
    bram_bank_t bram_bank = bram_heap_data_get_bank(1, bram_handle);
    bram_ptr_t bram_ptr = bram_heap_data_get_offset(1, bram_handle);

    memcpy_vram_bram(vram_bank, vram_offset, bram_bank, bram_ptr, FLOOR_TILE_SIZE);

    bank_pull_bram();
}

inline void floor_layer_map(unsigned char layer, unsigned char bank, unsigned int offset) {

    floor_layer_offsets[layer].bank = bank;
    floor_layer_offsets[layer].offset = offset;
}

/**
 * @brief Iterate through the floor and build the floor index.
 * This to quickly be able to select a randomized segment for the specific range of segments with the same floor mask.
 * Each layer has its floor index with specific segments and composition of slabs.
 *
 * @param floor
 */
void floor_layer_index_segments(floor_t *floor) {

    bank_push_set_bram(BANK_ENGINE_FLOOR);

    unsigned char layer = 0;
    floor_layer_t *floor_layer = floor->floor_layers[layer];
    while (floor_layer) {

        // Index of the floor for drawing while randomizing the selection of segments.
        unsigned char offset = 0;
        unsigned char segment = 0;
        unsigned char mask = 0;
        unsigned char variation = 0;
        do {
            if (mask != floor_layer->segments[segment].mask) {
                floor_layer->segment_index.offsets[mask] = offset;
                floor_layer->segment_index.variations[mask] = variation;
                mask = floor_layer->segments[segment].mask;
                offset += variation;
                variation = 0;
            }
            variation++;
            segment++;
        } while (segment < floor_layer->segment_index.segments);
        floor_layer->segment_index.offsets[mask] = offset;
        floor_layer->segment_index.variations[mask] = variation;

        floor_layer = floor->floor_layers[++layer];
    }

    bank_pull_bram();
}

void floor_layer_debug(floor_t *floor, unsigned char layer) {

    bank_push_set_bram(BANK_ENGINE_FLOOR);

    floor_layer_t *floor_layer = floor->floor_layers[layer];

    printf("L # mask t0  t1  t2  t3 \n");
    for (unsigned char s = 0; s < floor_layer->segment_index.segments; s++) {
        floor_segment_t *segment = &floor_layer->segments[s];
        printf("%1u %1u %02x   ", layer, s, segment->mask);
        for (unsigned char t = 0; t < 4; t++) {
            printf("%3u ", segment->tiles[t]);
        }
        printf("\n");
    }

    bank_pull_bram();
}

// Load the floor tiles into bram using the bram heap manager.
unsigned char floor_parts_load_bram(unsigned char part, floor_t *floor, floor_bram_tiles_t *floor_bram_tile) {
    bank_push_set_bram(BANK_ENGINE_FLOOR);

    // printf("load:floor = %p\n", floor);

    floor_parts_t *floor_parts = floor->floor_parts;

    // printf("floor parts = %p", floor_parts);

    if (!floor_bram_tile->loaded) {

        // todo harmonize with sprite load
        char filename[16];
        strcpy(filename, floor_bram_tile->file);
        strcat(filename, ".bin");

#ifdef __DEBUG_LOAD
        printf("\n%10s : ", filename);
#endif

        FILE *fp = fopen(filename, "r");
        if (fp) {

            // The palette data, which we load and index using the palette library.
            palette_index_t palette_index = palette_alloc_bram();
            palette_ptr_t palette_ptr = palette_ptr_bram(palette_index);
            unsigned char palette_size = 0;
            floor_bram_tile->palette = palette_index;
            bank_push_set_bram(BANK_ENGINE_PALETTE);
            unsigned int read = fgets((char *)palette_ptr, 32, fp);
            bank_pull_bram();

            unsigned int count = floor_bram_tile->count;
            unsigned int size = floor_bram_tile->floor_tile_size;

            for (unsigned char s = 0; s < floor_bram_tile->count; s++) {
#ifdef __DEBUG_LOAD
                printf(".");
#endif
                bram_heap_handle_t handle_bram = bram_heap_alloc(1, size);
                bram_bank_t bram_bank = bram_heap_data_get_bank(1, handle_bram);
                // printf("bram_bank = %u\n", bram_bank);
                bram_ptr_t bram_ptr = bram_heap_data_get_offset(1, handle_bram);
                // printf("bram_ptr = %p\n", bram_ptr);

                bank_push_set_bram(bram_bank);
                unsigned int read = fgets(bram_ptr, size, fp);
                bank_pull_bram();
                if (!read) {
#ifdef __INCLUDE_PRINT
                    printf("error loading file %s\n", fp->filename);
                    break;
#endif
                } else {
                    floor_parts->bram_handles[(unsigned int)part] = handle_bram;
                    floor_parts->floor_tile[(unsigned int)part] = floor_bram_tile;

                    // Assign the palette to the floor part, this is used when painting the floor.
                    // The palettes are automatically painted.
                    floor_parts->palette[(unsigned int)part] = palette_use_vram(palette_index);

                    part++;
                }
            }

            if (fclose(fp)) {
#ifdef __INCLUDE_PRINT
                printf("error closing file %s\n", floor_bram_tile->file);
#endif
            } else {
                floor_bram_tile->loaded = 1;
            }
        } else {
#ifdef __INCLUDE_PRINT
            if (status)
                printf("error opening file %s\n", fp->filename);
#endif
        }
    }

    bank_pull_bram();

    return part;
}

void floor_scroll() {
    // We only will execute the scroll logic when a scroll action needs to be done.
    if (!game.scroll_wait--) {
        game.scroll_wait = game.scroll_speed;

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
            floor_paint(floor_pos.tile_column, (floor_pos.tile_row - 1) % 8);
#ifdef __TOWER
            tower_paint(floor_pos.tile_column, floor_pos.tile_row);
#endif
        }

        // Now that the segment for the respective floor_tile_row and floor_tile_column has been painted,
        // we can draw a cell from the painted segment. Note that when floor_tile_row is 0, 1 or 2,
        // all paint segments will have been painted on the paint buffer, and the tiling will just pick
        // row 2, 1 or 0 from the paint segment...
        floor_draw_row(stage.floor, row, floor_pos.tile_column);
#ifdef __TOWERS
        floor_draw_row(stage.towers, row, floor_pos.tile_column);
#endif

#ifdef __TOWER
        tower_move();
#endif

        game.screen_vscroll--;
    }
}

void floor_position() {
    // Now we set the vertical scroll to the required scroll position.
    vera_layer0_set_vertical_scroll(game.screen_vscroll);
#ifdef __LAYER1
    vera_layer1_set_vertical_scroll(game.screen_vscroll);
#endif
}

void floor_evolve() {
    if (!game.floor_ticks) {
        if (!game.floor_border) {
            game.delta_border = 1;
        }
        if (game.floor_border == game.floor_empty) {
            game.delta_border = -1;
            game.delta_empty = 1;
        }
        if (game.floor_empty == 0x0f) {
            game.delta_empty = -1;
        }
        game.floor_border += game.delta_border;
        game.floor_empty += game.delta_empty;
        game.floor_ticks = game.floor_interval;
    }
    game.floor_ticks--;
}

#pragma data_seg(Data)
#pragma data_seg(Code)
