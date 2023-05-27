#pragma once

#include <cx16-bramheap-typedefs.h>
#include "equinoxe-palette-types.h"



typedef struct {
    unsigned char loaded;
    char file[16];
    unsigned char count;
    unsigned int TotalSize;
    unsigned int floor_tile_size;
    unsigned int palette; 
} floor_bram_tiles_t;

#define FLOOR_PARTS 128
typedef struct {
    floor_bram_tiles_t *floor_tile[FLOOR_PARTS];
    unsigned int floor_tile_offset[FLOOR_PARTS];
    vera_heap_handle_t vram_handles[FLOOR_PARTS];
    bram_heap_handle_t bram_handles[FLOOR_PARTS];
    palette_index_t palette[FLOOR_PARTS];
} floor_parts_t;

typedef struct {
    unsigned char segments;
    unsigned char variations[16];
    unsigned char offsets[16];
} floor_segment_index_t;

#define FLOOR_TILES 4
typedef unsigned char floor_tile_t;

typedef struct {
    unsigned char mask;
    floor_tile_t tiles[FLOOR_TILES];
} floor_segment_t;
#define FLOOR_SEGMENTS 48

typedef struct {
    vram_bank_t bank;
    vram_offset_t offset;
} floor_layer_vram_offset_t;

typedef struct {
    unsigned char segment_offset;
    floor_segment_index_t segment_index;
    floor_segment_t segments[FLOOR_SEGMENTS];
} floor_layer_t;

typedef struct {
    floor_layer_t* floor_layer;
    unsigned char floor_segments[4];   
} floor_layer_composition_t;

typedef struct {
    floor_layer_composition_t floor_layer_compositions[2];
} floor_composition_t;

#define FLOOR_SEGMENT_COMPOSITIONS 16*4
typedef struct {
    floor_parts_t* floor_parts;
    floor_layer_t* floor_layers[10];
    floor_composition_t floor_compositions[64];
    unsigned char parts_count;
} floor_t;

#define FLOOR_WEIGHT_SEGMENTS 15
typedef struct {
    unsigned char Weight;
    unsigned char Count;
    unsigned char TileSegment[FLOOR_WEIGHT_SEGMENTS];
} tile_weight_t;

#define FLOOR_CACHE_ROWS 16
#define FLOOR_CACHE_COLUMNS 16
typedef unsigned char floor_cache_t; // this is exactly 256 bytes, so we have a very efficient cache!

// #define FLOOR_CACHE(layer, row, column) ((char)((char)(layer<<7) | (char)(row<<4) | (char)(column)))
typedef bram_heap_handle_t floor_bram_handles_t;

typedef struct {
    unsigned char tile_row;
    unsigned char tile_column;
} floor_scroll_t;
