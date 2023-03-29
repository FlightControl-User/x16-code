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



#include <stdint.h>
#include <string.h>
#include <sprintf.h>
#include <cx16-heap-bram-fb.h>

// Get a pointer to the client's area within a memory block
#define GET_CLIENT_PTR(_block_ptr_)    ((void*)(_block_ptr_ ? ((void*)((char*)_block_ptr_)) : (void*)NULL))

// Get a pointer to the block using a client pointer
#define GET_BLOCK_PTR(_client_ptr_)    ((void*)(_client_ptr_ ? ((void*)((char*)_client_ptr_)) : (void*)NULL))

heap_bram_fb_handle_t heap_new(fb_heap_segment_t* self);
void heap_push(fb_heap_segment_t* self, heap_bram_fb_handle_t handle);
heap_bram_fb_handle_t heap_pop(fb_heap_segment_t* self);


void heap_debug(heap_bram_fb_handle_t handle) 
{
    printf("%2x:%4p", heap_bram_fb_bank_get(handle), heap_bram_fb_ptr_get(handle));
}

inline heap_bram_fb_bank_t heap_bram_fb_bank_get(heap_bram_fb_handle_t handle)
{
    return BYTE1(handle) >> 2;
}

inline heap_bram_fb_ptr_t heap_bram_fb_ptr_get(heap_bram_fb_handle_t handle)
{
    return (heap_bram_fb_ptr_t)(((handle & 0x3FF) << 3) | 0xA000);
}

inline heap_bram_fb_handle_t heap_bram_fb_handle_get(heap_bram_fb_bank_t bank, heap_bram_fb_ptr_t ptr)
{
    return (bank << 10) | ((uint16_t)ptr & 0x1FFF) >> 3; 
}

inline heap_bram_fb_ptr_t heap_bram_fb_ptr(heap_bram_fb_handle_t handle) 
{
    bank_set_bram(heap_bram_fb_bank_get(handle));
    return heap_bram_fb_ptr_get(handle);
}

heap_bram_fb_handle_t heap_bram_fb_add(heap_bram_fb_handle_t handle, uint32_t add) 
{
    handle += (uint16_t)(add >> 3);
    return handle;
}



/**
 * @brief 
 * 
 * @param self 
 * @return fb_heap_handle_t 
 */
heap_bram_fb_handle_t heap_new(fb_heap_segment_t* self)
{
    heap_bram_fb_handle_t handle = 0;

    #ifdef __DEBUG_HEAP_BRAM_BLOCKED
    printf("heap_new: pool="); heap_debug(self->pool); printf(", ceil="); heap_debug(self->ceil);
    #endif
        
    heap_bram_fb_handle_t pool = self->pool;
    heap_bram_fb_handle_t ceil = self->ceil;
    if(pool < ceil) {
        #ifdef __DEBUG_HEAP_BRAM_BLOCKED
            // printf(", block_size=%u", self->block_size);
        #endif
        handle = heap_bram_fb_add(self->pool, (uint32_t)self->block_size);
        self->pool = handle;
    }

    #ifdef __DEBUG_HEAP_BRAM_BLOCKED
        // printf(", pool="); heap_debug(self->pool); printf(", handle="); heap_debug(handle); printf("\n");
    #endif

    return handle;
} 

/**
 * @brief 
 * 
 * @param self 
 * @param handle 
 */
void heap_push(fb_heap_segment_t* self, heap_bram_fb_handle_t handle)
{
    if (!handle)
        return;

    #ifdef __DEBUG_HEAP_BRAM_BLOCKED
    printf("heap_push: handle="); heap_debug(handle);
    printf("\n");
    #endif

    // Point client block's next pointer to free
    heap_bram_fb_handle_t free = self->free;
    ((fb_heap_block_t*)heap_bram_fb_ptr(handle))->next = free;

    #ifdef __DEBUG_HEAP_BRAM_BLOCKED
    printf(", free="); heap_debug(self->free); printf(", next="); heap_debug(((fb_heap_block_t*)heap_bram_fb_ptr(handle))->next);
    printf("\n");
    #endif

    // The client block is now the new free
    self->free = handle;
}

/**
 * @brief 
 * 
 * @param self 
 * @return heap_bram_fb_handle_t 
 */
heap_bram_fb_handle_t heap_pop(fb_heap_segment_t* self) {
    heap_bram_fb_handle_t handle = 0;

    heap_bram_fb_handle_t free = self->free;
    if(free) {
        handle = free;
        free = ((fb_heap_block_t*)heap_bram_fb_ptr(free))->next;
    }

    self->free = free;

    return handle;
} 

/**
 * @brief 
 * 
 * @param self 
 * @param size 
 * @return heap_bram_fb_handle_t 
 */
heap_bram_fb_handle_t heap_segment_alloc(fb_heap_segment_t* self, uint16_t size)
{
    heap_bram_fb_handle_t block = heap_pop(self);

    #ifdef __DEBUG_HEAP_BRAM_BLOCKED
    printf("segment_alloc: pool="); heap_debug(self->pool); printf(", ceil="); heap_debug(self->ceil);
    printf("block="); heap_debug(block);
    printf("\n");
    #endif
        

    if (!block)
    {
        block = heap_new(self);
    }

    if (block)
    {
        self->blocks_in_use++;
        unsigned int blocks_in_use = self->blocks_in_use;
        unsigned int blocks_in_use_max = self->blocks_in_use_max;
        if (blocks_in_use > blocks_in_use_max)
        {
            self->blocks_in_use_max = self->blocks_in_use;
        }

        #ifdef __DEBUG_HEAP_BRAM_BLOCKED
        printf("alloc:"); heap_debug(block); printf(", size=%u\n", size);
        #endif
    }

    return block;
}


/**
 * @brief 
 * 
 * @param segment 
 * @param num 
 * @param size 
 * @return heap_bram_fb_handle_t 
 */
heap_bram_fb_handle_t heap_calloc(fb_heap_segment_t* segment, uint16_t num, uint16_t size)
{
    // Compute the total_size size of the block
    uint16_t n = num * size;

    // Allocate the memory
    heap_bram_fb_handle_t handle = heap_segment_alloc(segment, n);

    if (handle)
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
void heap_segment_free(fb_heap_segment_t* self, heap_bram_fb_handle_t handle_free) 
{
    if(!handle_free)
        return;

    // Push the block onto a stack (i.e. the free-list)
    heap_push(self, handle_free);

    // Keep track of usage statistics
    self->blocks_in_use--;
} 

void heap_segment_reset(heap_structure_t* structure, fb_heap_segment_t* segment, uint16_t block_size, uint16_t block_max, uint32_t total_size)
{
    memset(segment, 0, sizeof(fb_heap_segment_t));

    heap_bram_fb_handle_t ceil = structure->ceil; 
    heap_bram_fb_handle_t base = structure->base; 

    segment->pool = base;
    segment->base = base;
    segment->ceil = heap_bram_fb_add(base, total_size);
    segment->total_size = total_size;
    segment->block_size = block_size;
    segment->block_max = block_max;
    segment->free = 0;
}

void heap_segment_base(heap_structure_t* structure, heap_bram_fb_bank_t bank, heap_bram_fb_ptr_t ptr)
{
    heap_bram_fb_handle_t handle = heap_bram_fb_handle_get(bank, ptr); 
    structure->base = handle;
    structure->ceil = handle;
}

void heap_segment_define(heap_structure_t* structure, fb_heap_segment_t* segment, uint16_t block_size, uint16_t block_max, uint32_t total_size)
{

    #ifdef __DEBUG_HEAP_BRAM_BLOCKED
        // printf("segment_define: structure ceil="); heap_debug(structure->ceil);
        // printf("\nsize  allo  maxi  free\n"); 
    #endif

    memset(segment, 0, sizeof(fb_heap_segment_t));

    heap_bram_fb_handle_t ceil = structure->ceil; 
    if(!structure->base) {
        structure->base = (heap_bram_fb_handle_t)heap_bram_fb_handle_get(1, (heap_bram_fb_ptr_t) 0xA000); // The default start of the heap is at BRAM bank 1.
    } else {
        structure->base = ceil;
    }

    heap_bram_fb_handle_t base = structure->base; 

    segment->pool = base;
    segment->base = base;
    segment->ceil = heap_bram_fb_add(base, total_size);
    segment->total_size = total_size;
    segment->block_size = block_size;
    segment->block_max = block_max;
    segment->free = 0;
    
    heap_bram_fb_handle_t seg_ceil = segment->ceil; 
    structure->ceil = seg_ceil;
    structure->segment[structure->segments] = segment;
    structure->segments++;
}

heap_bram_fb_handle_t heap_alloc(heap_structure_t* self, uint16_t request_size) 
{
    for(char s=0; s<self->segments;s++) {
        fb_heap_segment_t* segment=self->segment[s];
        if(segment->block_size >= request_size) {
            return heap_segment_alloc(segment, request_size);
        }
    }
    
    return 0;
}

void heap_free(heap_structure_t* self, heap_bram_fb_handle_t handle) {

    for(char s=0; s<self->segments;s++) {
        fb_heap_segment_t* segment=self->segment[s];
        printf("free handle=");
        heap_bram_fb_handle_t base = segment->base;
        heap_bram_fb_handle_t ceil = segment->ceil;
        if( handle >= base &&
            handle < ceil ) {
            heap_segment_free(segment, handle);
            break;
        }
    }

    // fb_heap_segment_t* segment=self->segment[handle.s];
    // heap_segment_free(segment, handle);
}


void heap_print(heap_structure_t* self) 
{
    printf("\n$size  used maxi free $base     $ceil     $pool     $free\n");
    for(char s=0; s<self->segments;s++) {
        fb_heap_segment_t* segment = self->segment[s];
        uint16_t blocks_free = segment->blocks_in_use_max;
        uint16_t blocks_used = segment->blocks_in_use;
        blocks_free -= blocks_used;
        printf("$%05x %04u %04u %04u ", segment->block_size, segment->blocks_in_use, segment->blocks_in_use_max, blocks_free);

        heap_debug(segment->base); cputc(' ');
        heap_debug(segment->ceil); cputc(' ');
        heap_debug(segment->pool); cputc(' ');
        heap_debug(segment->free); cputc(' ');

        printf("\n");

    }

}

/**
 * @brief Insert data of index in data list maintained by programmer.
 * Note that the first elements of the data must be a 2 byte next handle and a 2 byte prev handle.
 * 
 * @param list A list anchor defined and maintained by the programmer.
 * @param index The handle of the item to be inserted.
 * @return heap_bram_fb_handle_t 
 */
heap_bram_fb_handle_t heap_list_insert(heap_bram_fb_handle_t *list, heap_bram_fb_handle_t index) 
{

	heap_bram_fb_bank_t old_bank =  bank_get_bram();

	if (!(*list)) {
		// empty list
		*list = index;
		((heap_list_ptr)heap_bram_fb_ptr(*list))->prev = index;
		((heap_list_ptr)heap_bram_fb_ptr(*list))->next = index;
		bank_set_bram(old_bank);
		return index;
	}

	heap_bram_fb_handle_t last = ((heap_list_ptr)heap_bram_fb_ptr(*list))->prev;
	heap_bram_fb_handle_t first = *list;

	// Add index to list at last position.
	((heap_list_ptr)heap_bram_fb_ptr(index))->prev = last;
	((heap_list_ptr)heap_bram_fb_ptr(index))->next = first;
	((heap_list_ptr)heap_bram_fb_ptr(last))->next = index;
	((heap_list_ptr)heap_bram_fb_ptr(first))->prev = index;

	// heap_bram_fb_handle_t dataList = heap_data_packed_get(*list);
	// heap_bram_fb_handle_t dataIndex = heap_data_packed_get(index);
	// if(dataIndex>dataList) {
	// 	*list = index;
	// }

	bank_set_bram(old_bank);

	return index;
}

heap_bram_fb_handle_t heap_list_remove(heap_bram_fb_handle_t *list, heap_bram_fb_handle_t index) {

	heap_bram_fb_bank_t old_bank = bank_get_bram();

	if (!(*list)) {
		// empty list
		bank_set_bram(old_bank);
		return 0;
	}

	// The free makes the list empty!
	heap_bram_fb_handle_t next = ((heap_list_ptr)heap_bram_fb_ptr(*list))->next;
	heap_bram_fb_handle_t curr = *list;
	if (next == curr) {
		*list = 0; // We initialize the start of the list to null.
		bank_set_bram(old_bank);
		return 0; 
	}

	// The free changes the first header of the list!
	if (index == curr) { 
		*list = next;
	}


	heap_bram_fb_handle_t next_index = ((heap_list_ptr)heap_bram_fb_ptr(index))->next;
	heap_bram_fb_handle_t prev_index = ((heap_list_ptr)heap_bram_fb_ptr(index))->prev;

	((heap_list_ptr)heap_bram_fb_ptr(prev_index))->next = next_index;
	((heap_list_ptr)heap_bram_fb_ptr(next_index))->prev = prev_index;

	bank_set_bram(old_bank);

	return next_index;
}
