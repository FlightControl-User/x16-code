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

heap_handle heap_new(heap_segment* self);
void heap_push(heap_segment* self, heap_handle handle);
heap_handle heap_pop(heap_segment* self);


#ifdef debug_heap
void heap_debug(heap_handle handle) 
{
    printf("%2x:%4p", handle.bank, handle.ptr);
}
#endif

inline heap_handle_ptr heap_ptr(heap_handle handle) 
{
    BRAM = handle.bank;
    return handle.ptr;
}

heap_handle heap_handle_add_bram(heap_handle handle, unsigned int add) 
{
    handle.ptr = (void*)((char*)handle.ptr + add % 0x2000);
    handle.bank += (heap_bank)(add / 0x2000);
    if(handle.ptr >= 0xC000) {
        handle.ptr = (void*)((char*)handle.ptr - 0x2000);
        handle.bank++;
    }
    return handle;
}

heap_handle heap_handle_add_vram(heap_handle handle, unsigned int add) 
{
    handle.ptr = (void*)((char*)handle.ptr + add);
    if(handle.ptr < add) {
        handle.bank++;
    }
    return handle;
}

// inline bool heap_handle_is_not_null(heap_handle handle) 
// {
//     return handle.bank || handle.ptr;
// }

// inline bool heap_handle_is_null(heap_handle handle) 
// {
//     return !handle.bank && !handle.ptr;
// }

// inline bool heap_handle_lt_handle(heap_handle handle1, heap_handle handle2) 
// {
//     return (handle1.bank < handle2.bank) || (handle1.bank == handle2.bank && handle1.ptr < handle2.ptr);
// }

// inline bool heap_handle_eq_handle(heap_handle handle1, heap_handle handle2) 
// {
//     return (handle1.bank == handle2.bank && handle1.ptr == handle2.ptr);
// }

// inline bool heap_handle_ne_handle(heap_handle handle1, heap_handle handle2) 
// {
//     return (handle1.bank != handle2.bank || handle1.ptr != handle2.ptr);
// }


/**
 * @brief 
 * 
 * @param self 
 * @return heap_handle 
 */
heap_handle heap_new(heap_segment* self)
{
    heap_handle handle = heap_null;

    #ifdef debug_heap
        printf("heap_new: pool="); heap_debug(self->pool); printf(", ceil="); heap_debug(self->ceil);
    #endif
        
    heap_handle pool = self->pool;
    heap_handle ceil = self->ceil;
    if(heap_handle_lt_handle(pool, ceil)) {
        #ifdef debug_heap
            printf(", block_size=%u", self->block_size);
        #endif
        handle = heap_handle_add_bram(self->pool, self->block_size);
        self->pool = handle;
    }

    #ifdef debug_heap
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
void heap_push(heap_segment* self, heap_handle handle)
{
    if (heap_handle_is_null(handle))
        return;

    // Point client block's next pointer to head
    heap_handle head = self->head;
    ((heap_block*)heap_ptr(handle))->next = head;

    // The client block is now the new head
    self->head = handle;
}

/**
 * @brief 
 * 
 * @param self 
 * @return heap_handle 
 */
heap_handle heap_pop(heap_segment* self) {
    heap_handle handle = heap_null;

    heap_handle head = self->head;
    if(heap_handle_is_not_null(head)) {
        handle = head;
        head = ((heap_block*)heap_ptr(head))->next;
    }

    self->head = head;

    return handle;
} 

/**
 * @brief 
 * 
 * @param self 
 * @param size 
 * @return heap_handle 
 */
heap_handle heap_segment_alloc(heap_segment* self, size_t size)
{
    heap_handle pBlock = heap_pop(self);

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
 * @return heap_handle 
 */
heap_handle heap_calloc(heap_segment* segment, size_t num, size_t size)
{
    // Compute the total size of the block
    size_t n = num * size;

    // Allocate the memory
    heap_handle handle = heap_segment_alloc(segment, n);

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
void heap_segment_free(heap_segment* self, heap_handle handle_free) 
{
    if(heap_handle_is_null(handle_free))
        return;

    // Push the block onto a stack (i.e. the free-list)
    heap_push(self, handle_free);

    // Keep track of usage statistics
    self->blocks_in_use--;
} 

void heap_segment_reset(heap_structure* structure, heap_segment* segment, heap_size size, unsigned int blocks, size_t total)
{
    memset(segment, 0, sizeof(heap_segment));

    heap_handle ceil = structure->ceil; 
    heap_handle base = structure->base; 

    segment->pool = base;
    segment->floor = base;
    segment->ceil = heap_handle_add_bram(base, total);
    segment->total_size = total;
    segment->block_size = size;
    segment->block_max = blocks;
    segment->head = heap_null;
}

void heap_segment_base(heap_structure* structure, heap_bank bank, heap_handle_ptr ptr)
{
    structure->base.bank = bank;
    structure->base.ptr = ptr;
    structure->ceil.bank = bank;
    structure->ceil.ptr = ptr;
}

void heap_segment_define(heap_structure* structure, heap_segment* segment, heap_size size, unsigned int blocks, size_t total)
{
    memset(segment, 0, sizeof(heap_segment));

    heap_handle ceil = structure->ceil; 
    if(heap_handle_is_null(structure->base)) {
        structure->base = (heap_handle){1,0xA000}; // The default start of the heap is at BRAM bank 1.
    } else {
        structure->base = ceil;
    }

    heap_handle base = structure->base; 

    segment->pool = base;
    segment->floor = base;
    segment->ceil = heap_handle_add_bram(base, total);
    segment->total_size = total;
    segment->block_size = size;
    segment->block_max = blocks;
    segment->head = heap_null;
    
    heap_handle seg_ceil = segment->ceil; 
    structure->ceil = seg_ceil;
    structure->segment[structure->segments] = segment;
    structure->segments++;
}

heap_handle heap_alloc(heap_structure* self, heap_size size) 
{
    for(char s=0; s<self->segments;s++) {
        heap_segment* segment=self->segment[s];
        if(segment->block_size>=size) {
            return heap_segment_alloc(segment, size);
        }
    }
    
    return heap_null;
}

void heap_free(heap_structure* self, heap_handle handle) {

    for(char s=0; s<self->segments;s++) {
        heap_segment* segment=self->segment[s];
        heap_bank bank = handle.bank;
        heap_handle_ptr ptr = handle.ptr;
        heap_bank floor_bank = segment->floor.bank;
        heap_handle_ptr floor_ptr = segment->floor.ptr;
        heap_bank ceil_bank = segment->ceil.bank;
        heap_handle_ptr ceil_ptr = segment->ceil.ptr;
        if( bank >= floor_bank && ptr >= floor_ptr &&
            bank <= ceil_bank && ptr < ceil_ptr ) {
            heap_segment_free(segment, handle);
            break;
        }
    }

    // heap_segment* segment=self->segment[handle.s];
    // heap_segment_free(segment, handle);
}


void heap_print(heap_structure* self) 
{
    printf("\n");
    for(char s=0; s<self->segments;s++) {
        heap_segment* segment = self->segment[s];
        printf("heap statistics: size=%x, allocated=%u, max=%u, free=%u", segment->block_size, segment->blocks_in_use, segment->blocks_in_use_max, segment->blocks_in_use_max-segment->blocks_in_use);
        printf(", free blocks:\n");

        heap_handle handle = segment->head;
        while(heap_handle_is_not_null(handle)) {
            printf("%2x:%4p ", handle.bank, handle.ptr);
            handle = ((heap_block*)heap_ptr(handle))->next;
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
 * @return heap_handle 
 */
heap_handle heap_list_insert(heap_handle *list, heap_handle index) 
{

	heap_bank old_bank =  bank_get_bram();

	if (heap_handle_is_null(*list)) {
		// empty list
		*list = index;
		((heap_list_ptr)heap_ptr(*list))->prev = index;
		((heap_list_ptr)heap_ptr(*list))->next = index;
		bank_set_bram(old_bank);
		return index;
	}

	heap_handle last = ((heap_list_ptr)heap_ptr(*list))->prev;
	heap_handle first = *list;

	// Add index to list at last position.
	((heap_list_ptr)heap_ptr(index))->prev = last;
	((heap_list_ptr)heap_ptr(index))->next = first;
	((heap_list_ptr)heap_ptr(last))->next = index;
	((heap_list_ptr)heap_ptr(first))->prev = index;

	// heap_handle dataList = heap_data_packed_get(*list);
	// heap_handle dataIndex = heap_data_packed_get(index);
	// if(dataIndex>dataList) {
	// 	*list = index;
	// }

	bank_set_bram(old_bank);

	return index;
}

heap_handle heap_list_remove(heap_handle *list, heap_handle index) {

	heap_bank old_bank = bank_get_bram();

	if (heap_handle_is_null(*list)) {
		// empty list
		bank_set_bram(old_bank);
		return heap_null;
	}

	// The free makes the list empty!
	heap_handle next = ((heap_list_ptr)heap_ptr(*list))->next;
	heap_handle curr = *list;
	if (heap_handle_eq_handle(next, curr)) {
		*list = heap_null; // We initialize the start of the list to null.
		bank_set_bram(old_bank);
		return heap_null; 
	}

	// The free changes the first header of the list!
	if (heap_handle_eq_handle(index, curr)) { 
		*list = next;
	}


	heap_handle next_index = ((heap_list_ptr)heap_ptr(index))->next;
	heap_handle prev_index = ((heap_list_ptr)heap_ptr(index))->prev;

	((heap_list_ptr)heap_ptr(prev_index))->next = next_index;
	((heap_list_ptr)heap_ptr(next_index))->prev = prev_index;

	bank_set_bram(old_bank);

	return next_index;
}
