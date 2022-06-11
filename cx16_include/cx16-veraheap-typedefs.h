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
typedef unsigned char vera_heap_handle_t;
typedef unsigned char vera_heap_index_t;

// #ifdef VERAHEAP_WORD
//     typedef unsigned int vera_heap_index_t;
// #else
// #endif

typedef unsigned int vera_heap_data_t;
typedef unsigned int vera_heap_data_packed_t;
typedef unsigned char vera_heap_index_data_packed_t;

typedef unsigned long vera_heap_size_t;
typedef unsigned int vera_heap_size_int_t;
typedef unsigned int vera_heap_size_packed_t;
typedef unsigned char vera_heap_index_size_packed_t;

typedef unsigned char vera_heap_segment_index_t;

#ifdef VERAHEAP_WORD
    #define VERAHEAP_ERROR      (vera_heap_index_t)0xFFFF
    #define VERAHEAP_NULL       (vera_heap_index_t)0xFFFF
#else
    #define VERAHEAP_ERROR      (vera_heap_index_t)0xFF
    #define VERAHEAP_NULL       (vera_heap_index_t)0xFF
#endif


#ifndef VERAHEAP_INDEXES 
    #ifdef VERAHEAP_WORD
        #define VERAHEAP_INDEXES 512
    #else
        #define VERAHEAP_INDEXES 256
    #endif
#endif

/**
 * Header Block layout.
 * Contains 16 bit condensed pointer to data header.
 * Contains size of data header.
 * Contains condensed pointers to next and previous header blocks.
 */
typedef struct {
	vera_heap_index_data_packed_t data0[VERAHEAP_INDEXES];
	vera_heap_index_data_packed_t data1[VERAHEAP_INDEXES];
	vera_heap_index_size_packed_t size0[VERAHEAP_INDEXES];
	vera_heap_index_size_packed_t size1[VERAHEAP_INDEXES];
	vera_heap_index_t next[VERAHEAP_INDEXES];
	vera_heap_index_t prev[VERAHEAP_INDEXES];
	vera_heap_index_t right[VERAHEAP_INDEXES];
	vera_heap_index_t left[VERAHEAP_INDEXES];
} vera_heap_map_t;


#ifndef VERAHEAP_SEGMENTS
    #define VERAHEAP_SEGMENTS 4
#endif

typedef struct {


    vera_heap_bank_t            bram_bank;
	vera_heap_index_t           index_position;

    vera_heap_bank_t            vram_bank_floor[VERAHEAP_SEGMENTS];
    vera_heap_offset_t          vram_offset_floor[VERAHEAP_SEGMENTS];
    vera_heap_data_packed_t     floor[VERAHEAP_SEGMENTS];

    vera_heap_bank_t            vram_bank_ceil[VERAHEAP_SEGMENTS];
    vera_heap_offset_t          vram_offset_ceil[VERAHEAP_SEGMENTS];
    vera_heap_data_packed_t     ceil[VERAHEAP_SEGMENTS];

    unsigned char               index_bank;

    vera_heap_index_t           heap_list[VERAHEAP_SEGMENTS];
    vera_heap_index_t           free_list[VERAHEAP_SEGMENTS];
    vera_heap_index_t           idle_list[VERAHEAP_SEGMENTS];

	vera_heap_data_packed_t     heap_offset[VERAHEAP_SEGMENTS];

	unsigned int                heapCount[VERAHEAP_SEGMENTS];
	unsigned int                freeCount[VERAHEAP_SEGMENTS];
    unsigned int                idleCount[VERAHEAP_SEGMENTS];
	unsigned int                heapSize[VERAHEAP_SEGMENTS];
	unsigned int                freeSize[VERAHEAP_SEGMENTS];

} vera_heap_segment_t;

