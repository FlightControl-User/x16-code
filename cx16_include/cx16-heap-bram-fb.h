/**
 * @file cx16-fb.c
 * @author Sven Van de Velde (sven.van.de.velde@outlook.com)
 * @brief Commander x16 fixed block memory manager in banked ram area between A000 and BFFF.
 * @version 0.1
 * @date 2022-03-02
 * 
 * @copyright Copyright (c) 2022
 * 
 */



#include <stdlib.h>
#include <stdint.h>

typedef unsigned char   heap_bram_fb_bank_t; 			///< A bank representation for banked ram or banked vera ram.
typedef char* 	        heap_bram_fb_ptr_t;
typedef unsigned int 	heap_bram_fb_handle_t;        ///< Generic handle for heap references.
typedef unsigned int 	heap_bram_fb_size_t;          ///< The size in real buytes, max word size.

#define heap_null (fb_heap_handle_t){0,0}


typedef struct 
{
    heap_bram_fb_handle_t next;
} fb_heap_block_t;

// Use ALLOC_DEFINE to declare an fb_heap_segment_t object
typedef struct
{
    const char* name;
    heap_bram_fb_handle_t pool; 
    heap_bram_fb_handle_t base;
    heap_bram_fb_handle_t ceil;
    uint32_t total_size;
    uint16_t block_size;
    uint16_t block_max;
    heap_bram_fb_handle_t free;
    uint16_t blocks_in_use;
    uint16_t blocks_in_use_max;
} fb_heap_segment_t;

typedef struct {
    heap_bram_fb_handle_t ceil;
    heap_bram_fb_handle_t base;
    unsigned char segments;
    fb_heap_segment_t* segment[4];
} heap_structure_t;

typedef struct {
	heap_bram_fb_handle_t next;
	heap_bram_fb_handle_t prev;
} fb_heap_list_t;
typedef fb_heap_list_t* heap_list_ptr;

// Align fixed blocks on X-byte boundary based on CPU architecture.
// Set value to 1, 2, 4 or 8.
// #define ALLOC_MEM_ALIGN   (1)

// Get the maximum between a or b
#define ALLOC_MAX(a,b) (((a)>(b))?(a):(b))

// Round _numToRound_ to the next higher _multiple_
#define ALLOC_ROUND_UP(_numToRound_, _multiple_) (((_numToRound_ + _multiple_ - 1) / _multiple_) * _multiple_)

// Ensure the memory block size is: (a) is aligned on desired boundary and (b) at
// least the size of a fb_heap_segment_t*. 
#define ALLOC_BLOCK_SIZE(_size_) (ALLOC_MAX(_size_, sizeof(ALLOC_Allocator*)))


void heap_segment_base(heap_structure_t* structure, heap_bram_fb_bank_t bank, heap_bram_fb_ptr_t ptr);
void heap_segment_define(heap_structure_t* structure, fb_heap_segment_t* segment, uint16_t block_size, uint16_t block_max, uint32_t total_size);
void heap_segment_reset(heap_structure_t* structure, fb_heap_segment_t* segment, uint16_t block_size, uint16_t block_max, uint32_t total_size);

heap_bram_fb_ptr_t heap_bram_fb_ptr(heap_bram_fb_handle_t handle);
heap_bram_fb_handle_t heap_bram_fb_add(heap_bram_fb_handle_t handle, uint32_t add); 
heap_bram_fb_handle_t heap_segment_alloc(fb_heap_segment_t* self, uint16_t size);
heap_bram_fb_handle_t heap_calloc(fb_heap_segment_t* segment, uint16_t num, uint16_t size);
void heap_segment_free(fb_heap_segment_t* self, heap_bram_fb_handle_t handle_free);
void heap_print(heap_structure_t* self);
heap_bram_fb_handle_t heap_alloc(heap_structure_t* self, uint16_t requested_size); 
void heap_free(heap_structure_t* self, heap_bram_fb_handle_t handle_free); 


heap_bram_fb_handle_t heap_list_insert(heap_bram_fb_handle_t *list, heap_bram_fb_handle_t index);
heap_bram_fb_handle_t heap_list_remove(heap_bram_fb_handle_t *list, heap_bram_fb_handle_t index);

