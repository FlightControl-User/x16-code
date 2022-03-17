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

typedef unsigned char   heap_bank; 			///< A bank representation for banked ram or banked vera ram.
typedef char* 	heap_handle_ptr;
typedef struct { heap_bank bank; heap_handle_ptr ptr; } 	heap_handle;        ///< Generic handle for heap references.
typedef unsigned int 	heap_size;          ///< The size in real buytes, max word size.

#define heap_null (heap_handle){0,0}


typedef struct 
{
    heap_handle next;
} heap_block;

// Use ALLOC_DEFINE to declare an heap_segment object
typedef struct
{
    const char* name;
    heap_handle pool; 
    heap_handle floor;
    heap_handle ceil;
    heap_size total_size;
    size_t block_size;
    unsigned int block_max;
    heap_handle head;
    unsigned int blocks_in_use;
    unsigned int blocks_in_use_max;
} heap_segment;

typedef struct {
    heap_handle ceil;
    heap_handle base;
    unsigned char segments;
    heap_segment* segment[4];
} heap_structure;

typedef struct {
	heap_handle next;
	heap_handle prev;
} heap_list;
typedef heap_list* heap_list_ptr;

// Align fixed blocks on X-byte boundary based on CPU architecture.
// Set value to 1, 2, 4 or 8.
// #define ALLOC_MEM_ALIGN   (1)

// Get the maximum between a or b
#define ALLOC_MAX(a,b) (((a)>(b))?(a):(b))

// Round _numToRound_ to the next higher _multiple_
#define ALLOC_ROUND_UP(_numToRound_, _multiple_) (((_numToRound_ + _multiple_ - 1) / _multiple_) * _multiple_)

// Ensure the memory block size is: (a) is aligned on desired boundary and (b) at
// least the size of a heap_segment*. 
#define ALLOC_BLOCK_SIZE(_size_) (ALLOC_MAX(_size_, sizeof(ALLOC_Allocator*)))

// Defines block memory, allocator instance and a handle. On the example below, 
// the heap_segment instance is myAllocatorObj and the handle is myAllocator.
// _name_ - the allocator name
// _size_ - fixed memory block size in bytes
// _objects_ - number of fixed memory blocks 
// _memory_ must be the concatenation of _name_ tag + "Memory"
// _obj_ must be the concatenation of _name_ tag + "Obj"
// _qname_ is _name_ between string quotes
// e.g. ALLOC_DEFINE(myAllocator, 32, 10)
// #define ALLOC_DEFINE(_name_, _size_, _objects_, _memory_, _obj_, _qname_ ) \
//     static char _memory_[ALLOC_BLOCK_SIZE(_size_) * (_objects_)] = { 0 }; \
//     static heap_segment _obj_ = { _qname_, _memory_, _size_, ALLOC_BLOCK_SIZE(_size_), _objects_, NULL, 0, 0, 0, 0, 0 }; \
//     static ALLOC_HANDLE _name_ = &_obj_;


// inline bool heap_handle_is_not_null(heap_handle handle);
// inline bool heap_handle_is_null(heap_handle handle);
// inline bool heap_handle_lt_handle(heap_handle handle1, heap_handle handle2);
// inline bool heap_handle_eq_handle(heap_handle handle1, heap_handle handle2);
// inline bool heap_handle_ne_handle(heap_handle handle1, heap_handle handle2);

#define heap_handle_is_not_null(handle) ((handle).bank || (handle).ptr)
#define heap_handle_is_null(handle) (!(handle).bank && !(handle).ptr)
#define heap_handle_eq_handle(handle1, handle2) (((handle1).bank == (handle2).bank && (handle1).ptr == (handle2).ptr))
#define heap_handle_ne_handle(handle1, handle2) (((handle1).bank != (handle2).bank || (handle1).ptr != (handle2).ptr))
#define heap_handle_lt_handle(handle1, handle2) ((((handle1).bank < (handle2).bank) || ((handle1).bank == (handle2).bank && (handle1).ptr < (handle2).ptr)))






void heap_segment_define(heap_structure* structure, heap_segment* segment, heap_size size, unsigned int blocks, size_t total);
void heap_segment_reset(heap_structure* structure, heap_segment* segment, heap_size size, unsigned int blocks, size_t total);

heap_handle_ptr heap_ptr(heap_handle handle);
heap_handle heap_handle_add(heap_handle handle, unsigned int add); 
heap_handle heap_segment_alloc(heap_segment* self, size_t size);
heap_handle heap_calloc(heap_segment* segment, size_t num, size_t size);
void heap_segment_free(heap_segment* self, heap_handle handle_free);
void heap_print(heap_structure* self);
heap_handle heap_alloc(heap_structure* self, heap_size size); 
void heap_free(heap_structure* self, heap_handle handle_free); 


heap_handle heap_list_insert(heap_handle *list, heap_handle index);
heap_handle heap_list_remove(heap_handle *list, heap_handle index);


#endif