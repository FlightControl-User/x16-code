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


#ifndef _FB_ALLOCATOR_H
#define _FB_ALLOCATOR_H

#include <stdlib.h>

typedef unsigned char   fb_heap_bank_t; 			///< A bank representation for banked ram or banked vera ram.
typedef char* 	fb_heap_handle_ptr_t;
typedef struct { fb_heap_bank_t bank; fb_heap_handle_ptr_t ptr; } 	fb_heap_handle_t;        ///< Generic handle for heap references.
typedef unsigned int 	fb_heap_size_t;          ///< The size in real buytes, max word size.

#define heap_null (fb_heap_handle_t){0,0}


typedef struct 
{
    fb_heap_handle_t next;
} fb_heap_block_t;

// Use ALLOC_DEFINE to declare an fb_heap_segment_t object
typedef struct
{
    const char* name;
    fb_heap_handle_t pool; 
    fb_heap_handle_t floor;
    fb_heap_handle_t ceil;
    fb_heap_size_t total_size;
    size_t block_size;
    unsigned int block_max;
    fb_heap_handle_t head;
    unsigned int blocks_in_use;
    unsigned int blocks_in_use_max;
} fb_heap_segment_t;

typedef struct {
    fb_heap_handle_t ceil;
    fb_heap_handle_t base;
    unsigned char segments;
    fb_heap_segment_t* segment[4];
} heap_structure;

typedef struct {
	fb_heap_handle_t next;
	fb_heap_handle_t prev;
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

// Defines block memory, allocator instance and a handle. On the example below, 
// the fb_heap_segment_t instance is myAllocatorObj and the handle is myAllocator.
// _name_ - the allocator name
// _size_ - fixed memory block size in bytes
// _objects_ - number of fixed memory blocks 
// _memory_ must be the concatenation of _name_ tag + "Memory"
// _obj_ must be the concatenation of _name_ tag + "Obj"
// _qname_ is _name_ between string quotes
// e.g. ALLOC_DEFINE(myAllocator, 32, 10)
// #define ALLOC_DEFINE(_name_, _size_, _objects_, _memory_, _obj_, _qname_ ) \
//     static char _memory_[ALLOC_BLOCK_SIZE(_size_) * (_objects_)] = { 0 }; \
//     static fb_heap_segment_t _obj_ = { _qname_, _memory_, _size_, ALLOC_BLOCK_SIZE(_size_), _objects_, NULL, 0, 0, 0, 0, 0 }; \
//     static ALLOC_HANDLE _name_ = &_obj_;


// inline bool heap_handle_is_not_null(fb_heap_handle_t handle);
// inline bool heap_handle_is_null(fb_heap_handle_t handle);
// inline bool heap_handle_lt_handle(fb_heap_handle_t handle1, fb_heap_handle_t handle2);
// inline bool heap_handle_eq_handle(fb_heap_handle_t handle1, fb_heap_handle_t handle2);
// inline bool heap_handle_ne_handle(fb_heap_handle_t handle1, fb_heap_handle_t handle2);

#define heap_handle_is_not_null(handle) ((handle).bank || (handle).ptr)
#define heap_handle_is_null(handle) (!(handle).bank && !(handle).ptr)
#define heap_handle_eq_handle(handle1, handle2) (((handle1).bank == (handle2).bank && (handle1).ptr == (handle2).ptr))
#define heap_handle_ne_handle(handle1, handle2) (((handle1).bank != (handle2).bank || (handle1).ptr != (handle2).ptr))
#define heap_handle_lt_handle(handle1, handle2) ((((handle1).bank < (handle2).bank) || ((handle1).bank == (handle2).bank && (handle1).ptr < (handle2).ptr)))






void heap_segment_base(heap_structure* structure, fb_heap_bank_t bank, fb_heap_handle_ptr_t ptr);
void heap_segment_define(heap_structure* structure, fb_heap_segment_t* segment, fb_heap_size_t size, unsigned int blocks, size_t total);
void heap_segment_reset(heap_structure* structure, fb_heap_segment_t* segment, fb_heap_size_t size, unsigned int blocks, size_t total);

fb_heap_handle_ptr_t heap_ptr(fb_heap_handle_t handle);
fb_heap_handle_t heap_handle_add_bram(fb_heap_handle_t handle, unsigned int add); 
fb_heap_handle_t heap_handle_add_vram(fb_heap_handle_t handle, unsigned int add); 
fb_heap_handle_t heap_segment_alloc(fb_heap_segment_t* self, size_t size);
fb_heap_handle_t heap_calloc(fb_heap_segment_t* segment, size_t num, size_t size);
void heap_segment_free(fb_heap_segment_t* self, fb_heap_handle_t handle_free);
void heap_print(heap_structure* self);
fb_heap_handle_t heap_alloc(heap_structure* self, fb_heap_size_t size); 
void heap_free(heap_structure* self, fb_heap_handle_t handle_free); 


fb_heap_handle_t heap_list_insert(fb_heap_handle_t *list, fb_heap_handle_t index);
fb_heap_handle_t heap_list_remove(fb_heap_handle_t *list, fb_heap_handle_t index);


#endif