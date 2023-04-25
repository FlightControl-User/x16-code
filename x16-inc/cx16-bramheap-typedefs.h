#pragma once

/**
 * @file cx16-heap.h
 * @author Sven Van de Velde (sven.van.de.velde@outlook.com)
 * @brief Commander x16 memory manager.
 * @version 0.1
 * @date 2023-04-20
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#include <cx16.h>

// #define BRAM_HEAP_WORD


typedef unsigned char bram_heap_bank_t;
typedef void* bram_heap_ptr_t;

#ifdef BRAM_HEAP_WORD
    typedef unsigned int bram_heap_handle_t;
    typedef unsigned int bram_heap_index_t;
#else
    typedef unsigned char bram_heap_handle_t;
    typedef unsigned char bram_heap_index_t;
#endif


typedef unsigned int bram_heap_data_t;
typedef unsigned int bram_heap_data_packed_t;
typedef unsigned char bram_heap_index_data_packed_t;

typedef unsigned long bram_heap_size_t;
typedef unsigned int bram_heap_size_int_t;
typedef unsigned int bram_heap_size_packed_t;
typedef unsigned char bram_heap_index_size_packed_t;

typedef unsigned char bram_heap_segment_index_t;

#ifdef BRAM_HEAP_WORD
    #define BRAM_HEAP_ERROR      (bram_heap_index_t)0xFFFF
    #define BRAM_HEAP_NULL       (bram_heap_index_t)0xFFFF
#else
    #define BRAM_HEAP_ERROR      (bram_heap_index_t)0xFF
    #define BRAM_HEAP_NULL       (bram_heap_index_t)0xFF
#endif


#ifndef BRAM_HEAP_INDEXES 
    #ifdef BRAM_HEAP_WORD
        #define BRAM_HEAP_INDEXES 512
    #else
        #define BRAM_HEAP_INDEXES 256
    #endif
#endif

/**
 * Header Block layout.
 * Contains 16 bit condensed pointer to data header.
 * Contains size of data header.
 * Contains condensed pointers to next and previous header blocks.
 */
typedef struct {
	bram_heap_index_data_packed_t data0[BRAM_HEAP_INDEXES];
	bram_heap_index_data_packed_t data1[BRAM_HEAP_INDEXES];
	bram_heap_index_size_packed_t size0[BRAM_HEAP_INDEXES];
	bram_heap_index_size_packed_t size1[BRAM_HEAP_INDEXES];
	bram_heap_index_t next[BRAM_HEAP_INDEXES];
	bram_heap_index_t prev[BRAM_HEAP_INDEXES];
	bram_heap_index_t right[BRAM_HEAP_INDEXES];
	bram_heap_index_t left[BRAM_HEAP_INDEXES];
} bram_heap_map_t;


#ifndef VERAHEAP_SEGMENTS
    #define VERAHEAP_SEGMENTS 4
#endif

typedef struct {

    bram_heap_bank_t            bram_bank;
	bram_heap_index_t           index_position;

    bram_heap_bank_t            bram_bank_floor[VERAHEAP_SEGMENTS];
    bram_heap_ptr_t             bram_ptr_floor[VERAHEAP_SEGMENTS];
    bram_heap_data_packed_t     floor[VERAHEAP_SEGMENTS];

    bram_heap_bank_t            bram_bank_ceil[VERAHEAP_SEGMENTS];
    bram_heap_ptr_t             bram_ptr_ceil[VERAHEAP_SEGMENTS];
    bram_heap_data_packed_t     ceil[VERAHEAP_SEGMENTS];

    bram_heap_index_t           heap_list[VERAHEAP_SEGMENTS];
    bram_heap_index_t           free_list[VERAHEAP_SEGMENTS];
    bram_heap_index_t           idle_list[VERAHEAP_SEGMENTS];

	bram_heap_data_packed_t     heap_offset[VERAHEAP_SEGMENTS];

	unsigned int                heapCount[VERAHEAP_SEGMENTS];
	unsigned int                freeCount[VERAHEAP_SEGMENTS];
    unsigned int                idleCount[VERAHEAP_SEGMENTS];
	unsigned int                heapSize[VERAHEAP_SEGMENTS];
	unsigned int                freeSize[VERAHEAP_SEGMENTS];

    unsigned char color;

} bram_heap_segment_t;

