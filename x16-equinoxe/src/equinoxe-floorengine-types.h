#ifndef __EQUINOXE_FLOORENGINE_TYPES_H
#define __EQUINOXE_FLOORENGING_TYPES_H

typedef struct {
    unsigned char loaded;
    char file[16];
    unsigned char count;
    unsigned int TotalSize;
    unsigned int floor_tile_size;
    unsigned int palette; 
} floor_bram_tiles_t;

#define FLOOR_PARTS 64
typedef struct {
    floor_bram_tiles_t *floor_tile[FLOOR_PARTS];
    unsigned int floor_tile_offset[FLOOR_PARTS];
    vera_heap_handle_t vram_handles[FLOOR_PARTS];
    heap_bram_fb_handle_t bram_handles[FLOOR_PARTS];
    palette_index_t palette[FLOOR_PARTS];
} floor_parts_t;

#define FLOOR_SEGMENTS 4
typedef struct {
    unsigned char segment[FLOOR_SEGMENTS];
} floor_segments_t;

#define FLOOR_SEGMENT_WEIGHTS 64
#define FLOOR_SEGMENT_COMPOSITIONS 256
typedef struct {
    floor_parts_t* floor_parts;
    unsigned char weight[FLOOR_SEGMENT_WEIGHTS];
    unsigned char composition[FLOOR_SEGMENT_COMPOSITIONS];
    unsigned char slab[FLOOR_SEGMENT_COMPOSITIONS];
    unsigned char parts_count;
} floor_t;

#define FLOOR_WEIGHT_SEGMENTS 15
typedef struct {
    unsigned char Weight;
    unsigned char Count;
    unsigned char TileSegment[FLOOR_WEIGHT_SEGMENTS];
} tile_weight_t;

#define FLOOR_CACHE_LAYERS 2
#define FLOOR_CACHE_ROWS 8
#define FLOOR_CACHE_COLUMNS 16
typedef unsigned char floor_cache_t; // this is exactly 256 bytes, so we have a very efficient cache!

typedef struct {
    vram_bank_t bank;
    vram_offset_t offset;
} floor_layer_t;

// #define FLOOR_CACHE(layer, row, column) ((char)((char)(layer<<7) | (char)(row<<4) | (char)(column)))
typedef heap_bram_fb_handle_t floor_bram_handles_t;

typedef struct {
    unsigned char tile_row;
    unsigned char tile_column;
} floor_scroll_t;

#endif