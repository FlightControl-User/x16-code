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
    unsigned char palette[FLOOR_PARTS];
} floor_parts_t;

#define FLOOR_SEGMENTS 4
typedef struct {
    unsigned char segment[FLOOR_SEGMENTS];
} floor_segments_t;

#define FLOOR_SEGMENT_WEIGHTS 64
#define FLOOR_SEGMENT_COMPOSITIONS 256
typedef struct {
    vera_bank bank;
    vera_map_offset offset;
    floor_parts_t* floor_parts;
    unsigned char weight[FLOOR_SEGMENT_WEIGHTS];
    unsigned char composition[FLOOR_SEGMENT_COMPOSITIONS];
    unsigned char slab[FLOOR_SEGMENT_COMPOSITIONS];
} floor_t;

#define FLOOR_WEIGHT_SEGMENTS 15
typedef struct {
    unsigned char Weight;
    unsigned char Count;
    unsigned char TileSegment[FLOOR_WEIGHT_SEGMENTS];
} tile_weight_t;

// todo: rework naming to floor_cache
#define FLOOR_CACHE_TILES 16
typedef struct {
    char floor_segment[FLOOR_CACHE_TILES];
} floor_cache_t;

typedef heap_bram_fb_handle_t floor_bram_handles_t;

#endif