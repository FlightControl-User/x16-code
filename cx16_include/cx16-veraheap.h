#ifndef __CX16_VERAHEAP_H__
#define __CX16_VERAHEAP_H__

/**
 * @file cx16-heap.h
 * @author Sven VAn de Velde (sven.van.de.velde@outlook.com)
 * @brief Commander x16 memory manager.
 * @version 0.1
 * @date 2021-12-26
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#include <cx16.h>


typedef unsigned char vera_heap_bank_t;
typedef unsigned int vera_heap_offset_t;
typedef unsigned int vera_heap_handle_t;
typedef unsigned char vera_heap_index_t;

typedef unsigned int vera_heap_data_t;
typedef unsigned int vera_heap_data_packed_t;

typedef unsigned long vera_heap_size_t;
typedef unsigned int vera_heap_size_packed_t;

typedef unsigned char vera_heap_segment_index_t;

#define VERAHEAP_ERROR      (vera_heap_index_t)0xFF
#define VERAHEAP_NULL       (vera_heap_index_t)0xFF

#ifndef VERAHEAP_INDEXES
    #define VERAHEAP_INDEXES 256
#endif

/**
 * Header Block layout.
 * Contains 16 bit condensed pointer to data header.
 * Contains size of data header.
 * Contains condensed pointers to next and previous header blocks.
 */
typedef struct {
	vera_heap_data_packed_t data[VERAHEAP_INDEXES];
	vera_heap_size_packed_t size[VERAHEAP_INDEXES];
	vera_heap_index_t next[VERAHEAP_INDEXES];
	vera_heap_index_t prev[VERAHEAP_INDEXES];
	vera_heap_index_t right[VERAHEAP_INDEXES];
	vera_heap_index_t left[VERAHEAP_INDEXES];
} vera_heap_map_t;


#ifndef VERAHEAP_SEGMENTS
    #define VERAHEAP_SEGMENTS 4
#endif

typedef struct {


    vram_bank_t                 vram_bank_floor[VERAHEAP_SEGMENTS];
    vram_offset_t               vram_offset_floor[VERAHEAP_SEGMENTS];
    vera_heap_data_packed_t     floor[VERAHEAP_SEGMENTS];

    vram_bank_t                 vram_bank_ceil[VERAHEAP_SEGMENTS];
    vram_offset_t               vram_offset_ceil[VERAHEAP_SEGMENTS];
    vera_heap_data_packed_t     ceil[VERAHEAP_SEGMENTS];

    unsigned char               index_bank;

    vera_heap_index_t          heap_list[VERAHEAP_SEGMENTS];
    vera_heap_index_t          free_list[VERAHEAP_SEGMENTS];
    vera_heap_index_t          idle_list[VERAHEAP_SEGMENTS];

	vera_heap_data_packed_t     heap_offset[VERAHEAP_SEGMENTS];

	unsigned int                heapCount[VERAHEAP_SEGMENTS];
	unsigned int                freeCount[VERAHEAP_SEGMENTS];
    unsigned int                idleCount[VERAHEAP_SEGMENTS];
	unsigned int                heapSize[VERAHEAP_SEGMENTS];
	unsigned int                freeSize[VERAHEAP_SEGMENTS];

    bram_bank_t                 bram_bank;
	vera_heap_index_t           index_position;

} vera_heap_segment_t;

extern vera_heap_map_t vera_heap_index;

void vera_heap_bram_bank_init(bram_bank_t bram_bank);

vera_heap_segment_index_t vera_heap_segment_init(vera_heap_segment_index_t s, vram_bank_t vram_bank_floor, vram_offset_t vram_offset_floor, vram_bank_t vram_bank_ceil, vram_offset_t vram_offset_ceil);

vera_heap_index_t vera_heap_alloc(vera_heap_segment_index_t s, vera_heap_size_t size);
void vera_heap_free(vera_heap_segment_index_t s, vera_heap_index_t handle);


extern vera_heap_segment_t vera_heap_segment;
extern vera_heap_segment_index_t segment;


void vera_heap_dump(vera_heap_segment_index_t s, unsigned char x, unsigned char y);
void vera_heap_dump_stats(vera_heap_segment_index_t s);
void vera_heap_dump_index(vera_heap_segment_index_t s);
void vera_heap_dump_xy(unsigned char x, unsigned char y);

vera_heap_data_packed_t vera_heap_get_data_packed(vera_heap_segment_index_t s, vera_heap_index_t index);
vram_offset_t vera_heap_data_get_offset(vera_heap_segment_index_t s, vera_heap_index_t index);
vram_bank_t vera_heap_data_get_bank(vera_heap_segment_index_t s, vera_heap_index_t index);
vera_heap_size_packed_t vera_heap_get_size_packed(vera_heap_segment_index_t s, vera_heap_index_t index);


vera_heap_size_t vera_heap_alloc_size(vera_heap_segment_index_t s);
vera_heap_size_t vera_heap_free_size(vera_heap_segment_index_t s);
unsigned int vera_heap_alloc_count(vera_heap_segment_index_t s);
unsigned int vera_heap_free_count(vera_heap_segment_index_t s);
unsigned int vera_heap_idle_count(vera_heap_segment_index_t s);

vera_heap_index_t vera_heap_list_remove(vera_heap_segment_index_t s, vera_heap_index_t list, vera_heap_index_t index);
vera_heap_index_t vera_heap_heap_insert_at(vera_heap_segment_index_t s, vera_heap_index_t heap_index, vera_heap_index_t at, vera_heap_size_packed_t size);


#endif