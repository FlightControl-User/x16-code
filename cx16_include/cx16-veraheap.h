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

#define VERAHEAP_DEBUG


typedef unsigned char vera_heap_bank_t;
typedef unsigned int vera_heap_offset_t;
typedef unsigned int vera_heap_handle_t;

typedef unsigned int vera_heap_data_t;
typedef unsigned int vera_heap_data_packed_t;

typedef unsigned long vera_heap_size_t;
typedef unsigned int vera_heap_size_packed_t;

typedef unsigned char vera_heap_segment_index_t;

#define VERAHEAP_ERROR      0xFFFF
#define VERAHEAP_NULL       0xFFFF

#ifndef VERAHEAP_INDEXES
    #define VERAHEAP_INDEXES 512
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
	vera_heap_handle_t next[VERAHEAP_INDEXES];
	vera_heap_handle_t prev[VERAHEAP_INDEXES];
	vera_heap_handle_t right[VERAHEAP_INDEXES];
	vera_heap_handle_t left[VERAHEAP_INDEXES];
} vera_heap_index_t;

extern vera_heap_index_t vera_heap_index;


#ifndef VERAHEAP_SEGMENTS
    #define VERAHEAP_SEGMENTS 4
#endif

typedef struct {
    bram_bank_t         bram_bank;
    
    vram_bank_t         vram_bank_floor[VERAHEAP_SEGMENTS];
    vram_offset_t       vram_offset_floor[VERAHEAP_SEGMENTS];
    vera_heap_handle_t  floor[VERAHEAP_SEGMENTS];

    vram_bank_t         vram_bank_ceil[VERAHEAP_SEGMENTS];
    vram_offset_t       vram_offset_ceil[VERAHEAP_SEGMENTS];
    vera_heap_handle_t  ceil[VERAHEAP_SEGMENTS];

    unsigned char index_bank;

    vera_heap_handle_t  heap_list[VERAHEAP_SEGMENTS];
    vera_heap_handle_t  free_list[VERAHEAP_SEGMENTS];
    vera_heap_handle_t  idle_list[VERAHEAP_SEGMENTS];

	vera_heap_handle_t  heap_position[VERAHEAP_SEGMENTS];
	vera_heap_handle_t  index_position[VERAHEAP_SEGMENTS];

	unsigned int heapCount[VERAHEAP_SEGMENTS];
	unsigned int freeCount[VERAHEAP_SEGMENTS];
	unsigned int idleCount[VERAHEAP_SEGMENTS];
	unsigned int heapSize[VERAHEAP_SEGMENTS];
	unsigned int freeSize[VERAHEAP_SEGMENTS];
} vera_heap_segment_t;


void vera_heap_bram_bank_init(bram_bank_t bram_bank);

vera_heap_segment_index_t vera_heap_segment_init(vera_heap_segment_index_t s, vram_bank_t vram_bank_floor, vram_offset_t vram_offset_floor, vram_bank_t vram_bank_ceil, vram_offset_t vram_offset_ceil);

vera_heap_handle_t vera_heap_alloc(vera_heap_segment_index_t s, vera_heap_size_packed_t size);
vera_heap_handle_t vera_heap_free(vera_heap_segment_index_t s, vera_heap_handle_t handle);




#ifdef VERAHEAP_DEBUG
void vera_heap_dump(vera_heap_segment_index_t s);
void vera_heap_dump_stats(vera_heap_segment_index_t s);
void vera_heap_dump_index(vera_heap_segment_index_t s);

unsigned int vera_heap_alloc_size(vera_heap_segment_index_t s);
unsigned int vera_heap_free_size(vera_heap_segment_index_t s);
unsigned int vera_heap_alloc_count(vera_heap_segment_index_t s);
unsigned int vera_heap_free_count(vera_heap_segment_index_t s);
unsigned int vera_heap_idle_count(vera_heap_segment_index_t s);
#endif
