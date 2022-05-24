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



#include <cx16.h>
#include <cx16-fb.h>
#include <string.h>

// Get a pointer to the client's area within a memory block
#define GET_CLIENT_PTR(_block_ptr_)    ((void*)(_block_ptr_ ? ((void*)((char*)_block_ptr_)) : (void*)NULL))

// Get a pointer to the block using a client pointer
#define GET_BLOCK_PTR(_client_ptr_)    ((void*)(_client_ptr_ ? ((void*)((char*)_client_ptr_)) : (void*)NULL))

fb_heap_handle_t heap_new(fb_heap_segment_t* self);
void heap_push(fb_heap_segment_t* self, fb_heap_handle_t handle);
fb_heap_handle_t heap_pop(fb_heap_segment_t* self);


#ifdef __HEAP_DEBUG
void heap_debug(fb_heap_handle_t handle) 
{
    printf("%2x:%4p", handle.bank, handle.ptr);
}
#endif

inline fb_heap_handle_ptr_t heap_ptr(fb_heap_handle_t handle) 
{
    BRAM = handle.bank;
    return handle.ptr;
}

fb_heap_handle_t heap_handle_add_bram(fb_heap_handle_t handle, unsigned int add) 
{
    handle.ptr = (void*)((char*)handle.ptr + add % 0x2000);
    handle.bank += (fb_heap_bank_t)(add / 0x2000);
    if(handle.ptr >= 0xC000) {
        handle.ptr = (void*)((char*)handle.ptr - 0x2000);
        handle.bank++;
    }
    return handle;
}

fb_heap_handle_t heap_handle_add_vram(fb_heap_handle_t handle, unsigned int add) 
{
    handle.ptr = (void*)((char*)handle.ptr + add);
    if(handle.ptr < add) {
        handle.bank++;
    }
    return handle;
}

// inline bool heap_handle_is_not_null(fb_heap_handle_t handle) 
// {
//     return handle.bank || handle.ptr;
// }

// inline bool heap_handle_is_null(fb_heap_handle_t handle) 
// {
//     return !handle.bank && !handle.ptr;
// }

// inline bool heap_handle_lt_handle(fb_heap_handle_t handle1, fb_heap_handle_t handle2) 
// {
//     return (handle1.bank < handle2.bank) || (handle1.bank == handle2.bank && handle1.ptr < handle2.ptr);
// }

// inline bool heap_handle_eq_handle(fb_heap_handle_t handle1, fb_heap_handle_t handle2) 
// {
//     return (handle1.bank == handle2.bank && handle1.ptr == handle2.ptr);
// }

// inline bool heap_handle_ne_handle(fb_heap_handle_t handle1, fb_heap_handle_t handle2) 
// {
//     return (handle1.bank != handle2.bank || handle1.ptr != handle2.ptr);
// }


/**
 * @brief 
 * 
 * @param self 
 * @return fb_heap_handle_t 
 */
fb_heap_handle_t heap_new(fb_heap_segment_t* self)
{
    fb_heap_handle_t handle = heap_null;

    #ifdef __HEAP_DEBUG
        printf("heap_new: pool="); heap_debug(self->pool); printf(", ceil="); heap_debug(self->ceil);
    #endif
        
    fb_heap_handle_t pool = self->pool;
    fb_heap_handle_t ceil = self->ceil;
    if(heap_handle_lt_handle(pool, ceil)) {
        #ifdef __HEAP_DEBUG
            printf(", block_size=%u", self->block_size);
        #endif
        handle = heap_handle_add_bram(self->pool, self->block_size);
        self->pool = handle;
    }

    #ifdef __HEAP_DEBUG
        printf(", pool="); heap_debug(self->pool); printf(", handle="); heap_debug(handle); printf("\n");
    #endif

    return handle;
} 

/**
 * @brief 
 * 
 * @param self 
 * @param handle 
 */
void heap_push(fb_heap_segment_t* self, fb_heap_handle_t handle)
{
    if (heap_handle_is_null(handle))
        return;

    // Point client block's next pointer to head
    fb_heap_handle_t head = self->head;
    ((fb_heap_block_t*)heap_ptr(handle))->next = head;

    // The client block is now the new head
    self->head = handle;
}

/**
 * @brief 
 * 
 * @param self 
 * @return fb_heap_handle_t 
 */
fb_heap_handle_t heap_pop(fb_heap_segment_t* self) {
    fb_heap_handle_t handle = heap_null;

    fb_heap_handle_t head = self->head;
    if(heap_handle_is_not_null(head)) {
        handle = head;
        head = ((fb_heap_block_t*)heap_ptr(head))->next;
    }

    self->head = head;

    return handle;
} 

/**
 * @brief 
 * 
 * @param self 
 * @param size 
 * @return fb_heap_handle_t 
 */
fb_heap_handle_t heap_segment_alloc(fb_heap_segment_t* self, size_t size)
{
    fb_heap_handle_t pBlock = heap_pop(self);

    #ifdef __HEAP_DEBUG
        printf("segment_alloc: pool="); heap_debug(self->pool); printf(", ceil="); heap_debug(self->ceil);
        printf("pblock ="); heap_debug(pBlock);
        printf("\n");
    #endif
        

    if (heap_handle_is_null(pBlock))
    {
        pBlock = heap_new(self);
    }

    if (heap_handle_is_not_null(pBlock))
    {
        self->blocks_in_use++;
        unsigned int blocks_in_use = self->blocks_in_use;
        unsigned int blocks_in_use_max = self->blocks_in_use_max;
        if (blocks_in_use > blocks_in_use_max)
        {
            self->blocks_in_use_max = self->blocks_in_use;
        }

        // printf("alloc: %2x:%4p, size=%u\n", pBlock.bank, pBlock.ptr, size);
    }

    return pBlock;
}


/**
 * @brief 
 * 
 * @param segment 
 * @param num 
 * @param size 
 * @return fb_heap_handle_t 
 */
fb_heap_handle_t heap_calloc(fb_heap_segment_t* segment, size_t num, size_t size)
{
    // Compute the total size of the block
    size_t n = num * size;

    // Allocate the memory
    fb_heap_handle_t handle = heap_segment_alloc(segment, n);

    if (heap_handle_is_not_null(handle))
    {
        // Initialize memory to 0 per calloc behavior 
        // TODO: BRAM memset memset(handle.ptr, 0, n);
    }

    return handle;
}

/**
 * @brief 
 * 
 * @param self 
 * @param handle_free 
 */
void heap_segment_free(fb_heap_segment_t* self, fb_heap_handle_t handle_free) 
{
    if(heap_handle_is_null(handle_free))
        return;

    // Push the block onto a stack (i.e. the free-list)
    heap_push(self, handle_free);

    // Keep track of usage statistics
    self->blocks_in_use--;
} 

void heap_segment_reset(heap_structure_t* structure, fb_heap_segment_t* segment, fb_heap_size_t size, unsigned int blocks, size_t total)
{
    memset(segment, 0, sizeof(fb_heap_segment_t));

    fb_heap_handle_t ceil = structure->ceil; 
    fb_heap_handle_t base = structure->base; 

    segment->pool = base;
    segment->floor = base;
    segment->ceil = heap_handle_add_bram(base, total);
    segment->total_size = total;
    segment->block_size = size;
    segment->block_max = blocks;
    segment->head = heap_null;
}

void heap_segment_base(heap_structure_t* structure, fb_heap_bank_t bank, fb_heap_handle_ptr_t ptr)
{
    structure->base.bank = bank;
    structure->base.ptr = ptr;
    structure->ceil.bank = bank;
    structure->ceil.ptr = ptr;
}

void heap_segment_define(heap_structure_t* structure, fb_heap_segment_t* segment, fb_heap_size_t size, unsigned int blocks, size_t total)
{

    #ifdef __HEAP_DEBUG
        printf("segment_define: structure ceil="); heap_debug(structure->ceil);
    #endif

    memset(segment, 0, sizeof(fb_heap_segment_t));

    fb_heap_handle_t ceil = structure->ceil; 
    if(heap_handle_is_null(structure->base)) {
        structure->base = (fb_heap_handle_t){1,0xA000}; // The default start of the heap is at BRAM bank 1.
    } else {
        structure->base = ceil;
    }

    fb_heap_handle_t base = structure->base; 

    segment->pool = base;
    segment->floor = base;
    segment->ceil = heap_handle_add_bram(base, total);
    segment->total_size = total;
    segment->block_size = size;
    segment->block_max = blocks;
    segment->head = heap_null;
    
    fb_heap_handle_t seg_ceil = segment->ceil; 
    structure->ceil = seg_ceil;
    structure->segment[structure->segments] = segment;
    structure->segments++;
}

fb_heap_handle_t heap_alloc(heap_structure_t* self, fb_heap_size_t size) 
{
    for(char s=0; s<self->segments;s++) {
        fb_heap_segment_t* segment=self->segment[s];
        if(segment->block_size>=size) {
            return heap_segment_alloc(segment, size);
        }
    }
    
    return heap_null;
}

void heap_free(heap_structure_t* self, fb_heap_handle_t handle) {

    for(char s=0; s<self->segments;s++) {
        fb_heap_segment_t* segment=self->segment[s];
        fb_heap_bank_t bank = handle.bank;
        fb_heap_handle_ptr_t ptr = handle.ptr;
        fb_heap_bank_t floor_bank = segment->floor.bank;
        fb_heap_handle_ptr_t floor_ptr = segment->floor.ptr;
        fb_heap_bank_t ceil_bank = segment->ceil.bank;
        fb_heap_handle_ptr_t ceil_ptr = segment->ceil.ptr;
        if( bank >= floor_bank && ptr >= floor_ptr &&
            bank <= ceil_bank && ptr < ceil_ptr ) {
            heap_segment_free(segment, handle);
            break;
        }
    }

    // fb_heap_segment_t* segment=self->segment[handle.s];
    // heap_segment_free(segment, handle);
}


void heap_print(heap_structure_t* self) 
{
    printf("\n");
    for(char s=0; s<self->segments;s++) {
        fb_heap_segment_t* segment = self->segment[s];
        printf("heap statistics: size=%x, allocated=%u, max=%u, free=%u", segment->block_size, segment->blocks_in_use, segment->blocks_in_use_max, segment->blocks_in_use_max-segment->blocks_in_use);
        printf(", free blocks:\n");

        fb_heap_handle_t handle = segment->head;
        while(heap_handle_is_not_null(handle)) {
            printf("%2x:%4p ", handle.bank, handle.ptr);
            handle = ((fb_heap_block_t*)heap_ptr(handle))->next;
        }
        printf("\n");

    }

}

/**
 * @brief Insert data of index in data list maintained by programmer.
 * Note that the first elements of the data must be a 2 byte next handle and a 2 byte prev handle.
 * 
 * @param list A list anchor defined and maintained by the programmer.
 * @param index The handle of the item to be inserted.
 * @return fb_heap_handle_t 
 */
fb_heap_handle_t heap_list_insert(fb_heap_handle_t *list, fb_heap_handle_t index) 
{

	fb_heap_bank_t old_bank =  bank_get_bram();

	if (heap_handle_is_null(*list)) {
		// empty list
		*list = index;
		((heap_list_ptr)heap_ptr(*list))->prev = index;
		((heap_list_ptr)heap_ptr(*list))->next = index;
		bank_set_bram(old_bank);
		return index;
	}

	fb_heap_handle_t last = ((heap_list_ptr)heap_ptr(*list))->prev;
	fb_heap_handle_t first = *list;

	// Add index to list at last position.
	((heap_list_ptr)heap_ptr(index))->prev = last;
	((heap_list_ptr)heap_ptr(index))->next = first;
	((heap_list_ptr)heap_ptr(last))->next = index;
	((heap_list_ptr)heap_ptr(first))->prev = index;

	// fb_heap_handle_t dataList = heap_data_packed_get(*list);
	// fb_heap_handle_t dataIndex = heap_data_packed_get(index);
	// if(dataIndex>dataList) {
	// 	*list = index;
	// }

	bank_set_bram(old_bank);

	return index;
}

fb_heap_handle_t heap_list_remove(fb_heap_handle_t *list, fb_heap_handle_t index) {

	fb_heap_bank_t old_bank = bank_get_bram();

	if (heap_handle_is_null(*list)) {
		// empty list
		bank_set_bram(old_bank);
		return heap_null;
	}

	// The free makes the list empty!
	fb_heap_handle_t next = ((heap_list_ptr)heap_ptr(*list))->next;
	fb_heap_handle_t curr = *list;
	if (heap_handle_eq_handle(next, curr)) {
		*list = heap_null; // We initialize the start of the list to null.
		bank_set_bram(old_bank);
		return heap_null; 
	}

	// The free changes the first header of the list!
	if (heap_handle_eq_handle(index, curr)) { 
		*list = next;
	}


	fb_heap_handle_t next_index = ((heap_list_ptr)heap_ptr(index))->next;
	fb_heap_handle_t prev_index = ((heap_list_ptr)heap_ptr(index))->prev;

	((heap_list_ptr)heap_ptr(prev_index))->next = next_index;
	((heap_list_ptr)heap_ptr(next_index))->prev = prev_index;

	bank_set_bram(old_bank);

	return next_index;
}
