/**
 * @file cx16-heap.c
 * @author Sven Van de Velde (sven.van.de.velde@outlook.com)
 * @brief Commander x16 memory manager of the vera graphics card.
 * @version 0.1
 * @date 2021-12-26
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <cx16-veraheap.h>
#include <cx16-veralib.h>


vera_heap_index_t           vera_heap_index[VERAHEAP_SEGMENTS];

vera_heap_segment_t vera_heap_segment;
vera_heap_segment_index_t segment = 0xFF;

vera_heap_data_packed_t vera_heap_data_pack(vram_bank_t vram_bank, vram_offset_t vram_offset)
{
    return MAKEWORD(vram_bank<<5, 0) | (vram_offset>>3);
}


vera_heap_data_packed_t vera_heap_get_data_packed(vera_heap_segment_index_t s, vera_heap_handle_t index)
{
    return vera_heap_index[s].data[index];
}


vram_bank_t vera_heap_data_get_bank(vera_heap_segment_index_t s, vera_heap_handle_t index)
{
    return (vram_bank_t)BYTE1(vera_heap_index[s].data[index])>>5;
}


vram_offset_t vera_heap_data_get_offset(vera_heap_segment_index_t s, vera_heap_handle_t index)
{
    return (vram_offset_t)vera_heap_get_data_packed(s, index) << 3;
}




void vera_heap_set_data(vera_heap_segment_index_t s, vera_heap_handle_t index, vram_bank_t vram_bank, vram_offset_t vram_offset)
{
    vera_heap_index[s].data[index] = vera_heap_data_pack(vram_bank, vram_offset);
}


void vera_heap_set_data_packed(vera_heap_segment_index_t s, vera_heap_handle_t index, vera_heap_data_packed_t data_packed)
{
    vera_heap_index[s].data[index] = data_packed;
}

void vera_heap_set_free(vera_heap_segment_index_t s, vera_heap_handle_t index)
{
    vera_heap_index[s].size[index] |= 0x8000;
}


void vera_heap_clear_free(vera_heap_segment_index_t s, vera_heap_handle_t index)
{
    vera_heap_index[s].size[index] &= 0x7FFF;
}


unsigned int vera_heap_get_free(vera_heap_segment_index_t s, vera_heap_handle_t index)
{
    return (unsigned int)vera_heap_index[s].size[index] & 0x8000;
}

/* inline */ vera_heap_size_packed_t vera_heap_size_pack(vera_heap_size_t size)
{
    return (vera_heap_size_packed_t)MAKEWORD(BYTE2(size)<<5, 0) | (WORD0(size) >> 3);
}

vera_heap_size_packed_t vera_heap_get_size_packed(vera_heap_segment_index_t s, vera_heap_handle_t index)
{
    return vera_heap_index[s].size[index] & 0x7FFF; // ignore free flag
}

vera_heap_size_t vera_heap_size_unpack(vera_heap_size_packed_t size)
{
    return (vera_heap_size_t)size << 3; // free flag is automatically removed
}

vera_heap_size_t vera_heap_get_size(vera_heap_segment_index_t s, vera_heap_handle_t index)
{
    return vera_heap_get_size_packed(s, index) << 3; // free flag is automatically removed
}

void vera_heap_set_size(vera_heap_segment_index_t s, vera_heap_handle_t index, vera_heap_size_t size)
{
    vera_heap_index[s].size[index] = (vera_heap_size_packed_t)(size >> 3);
}


void vera_heap_set_size_packed(vera_heap_segment_index_t s, vera_heap_handle_t index, vera_heap_size_packed_t size_packed)
{
    size_packed &= 0x7FFF; // ignore free flag
    vera_heap_index[s].size[index] = (vera_heap_index[s].size[index] & 0x8000) | size_packed;
}


vera_heap_handle_t vera_heap_get_next(vera_heap_segment_index_t s, vera_heap_handle_t index)
{
    return vera_heap_index[s].next[index];
}


void vera_heap_set_next(vera_heap_segment_index_t s, vera_heap_handle_t index, vera_heap_handle_t next)
{
    vera_heap_index[s].next[index] = next;
}


vera_heap_handle_t vera_heap_get_prev(vera_heap_segment_index_t s, vera_heap_handle_t index)
{
    return vera_heap_index[s].prev[index];
}


void vera_heap_set_prev(vera_heap_segment_index_t s, vera_heap_handle_t index, vera_heap_handle_t prev)
{
    vera_heap_index[s].prev[index] = prev;
}


vera_heap_handle_t vera_heap_get_left(vera_heap_segment_index_t s, vera_heap_handle_t index)
{
    return vera_heap_index[s].left[index];
}


void vera_heap_set_left(vera_heap_segment_index_t s, vera_heap_handle_t index, vera_heap_handle_t left)
{
    vera_heap_index[s].left[index] = left;
}


vera_heap_handle_t vera_heap_get_right(vera_heap_segment_index_t s, vera_heap_handle_t index)
{
    return vera_heap_index[s].right[index];
}


void vera_heap_set_right(vera_heap_segment_index_t s, vera_heap_handle_t index, vera_heap_handle_t right)
{
    vera_heap_index[s].right[index] = right;
}


/**
* Insert index in list at sorted position.
*/
vera_heap_handle_t vera_heap_list_insert_at(vera_heap_segment_index_t s, vera_heap_handle_t list, vera_heap_handle_t index, vera_heap_handle_t at) {

	if(list == VERAHEAP_NULL) {
		// empty list
		list = index;
        vera_heap_set_prev(s, index, index);
        vera_heap_set_next(s, index, index);
	}

    if(at==VERAHEAP_NULL) {
        at=list;
    }

	vera_heap_handle_t last = vera_heap_get_prev(s, at);
	vera_heap_handle_t first = at;

	// Add index to list at last position.
	vera_heap_set_prev(s, index, last);
	vera_heap_set_next(s, last, index);
	vera_heap_set_next(s, index, first);
	vera_heap_set_prev(s, first, index);

	return list;
}



/**
* Remove header from List
*/
vera_heap_handle_t vera_heap_list_remove(vera_heap_segment_index_t s, vera_heap_handle_t list, vera_heap_handle_t index) 
{

	if(list == VERAHEAP_NULL) {
		// empty list
		return VERAHEAP_NULL;
	}

	// The free makes the list empty!
	if(list == vera_heap_get_next(s, list)) {
		list = 0; // We initialize the start of the list to null.
#ifdef VERAHEAP_DEBUG
        printf("list is null\n");
#endif
        vera_heap_set_next(s, index, VERAHEAP_NULL);
        vera_heap_set_prev(s, index, VERAHEAP_NULL);
		return VERAHEAP_NULL; 
	}

    vera_heap_handle_t next = vera_heap_get_next(s, index);
    vera_heap_handle_t prev = vera_heap_get_prev(s, index);

    // TODO, why can't this be coded in one statement ...
    vera_heap_set_next(s, prev, next);
    vera_heap_set_prev(s, next, prev);

	// The free changes the first header of the list!
	if(index == list) { 
		list = vera_heap_get_next(s, list);
	}

	return list;
}

vera_heap_handle_t vera_heap_heap_insert_at(vera_heap_segment_index_t s, vera_heap_handle_t heap_index, vera_heap_handle_t at, vera_heap_size_packed_t size)
{
	vera_heap_segment.heap_list[s] = vera_heap_list_insert_at(s, vera_heap_segment.heap_list[s], heap_index, at);
    vera_heap_set_size_packed(s, heap_index, size);
	vera_heap_segment.heapCount[s]++;
	return vera_heap_segment.heap_list[s];
}

void vera_heap_heap_remove(vera_heap_segment_index_t s, vera_heap_handle_t heap_index) 
{
	vera_heap_segment.heapCount[s]--;
	vera_heap_segment.heap_list[s] = vera_heap_list_remove(s, vera_heap_segment.heap_list[s], heap_index);
}

vera_heap_handle_t vera_heap_free_insert(vera_heap_segment_index_t s, vera_heap_handle_t free_index, vera_heap_data_packed_t data, vera_heap_size_packed_t size) 
{
	vera_heap_segment.free_list[s] = vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, vera_heap_segment.free_list[s]);
    vera_heap_set_data_packed(s, free_index, data);
    vera_heap_set_size_packed(s, free_index, size);
    vera_heap_set_free(s, free_index);
	vera_heap_segment.freeCount[s]++;
	return vera_heap_segment.free_list[s];
}

void vera_heap_free_remove(vera_heap_segment_index_t s, vera_heap_handle_t free_index) {
	vera_heap_segment.freeCount[s]--;
	vera_heap_segment.free_list[s] = vera_heap_list_remove(s, vera_heap_segment.free_list[s], free_index);
    vera_heap_clear_free(s, free_index);
}

vera_heap_handle_t vera_heap_idle_insert(vera_heap_segment_index_t s, vera_heap_handle_t idle_index) {
	vera_heap_segment.idle_list[s] = vera_heap_list_insert_at(s, vera_heap_segment.idle_list[s], idle_index, vera_heap_segment.idle_list[s]);
    vera_heap_set_data_packed(s, idle_index, 0);
    vera_heap_set_size_packed(s, idle_index, 0);
	vera_heap_segment.idleCount[s]++;
	return vera_heap_segment.idle_list[s];
}

void heap_idle_remove(vera_heap_segment_index_t s, vera_heap_handle_t idle_index) {
	vera_heap_segment.idleCount[s]--;
	vera_heap_segment.idle_list[s] = vera_heap_list_remove(s, vera_heap_segment.idle_list[s], idle_index);
}


/**
 * Returns total allocation size, aligned to 8;
 */
/* inline */ vera_heap_size_packed_t vera_heap_alloc_size_get(vera_heap_size_t size) 
{
	return (vera_heap_size_packed_t)((vera_heap_size_pack(size-1) + 1));
}


vera_heap_handle_t vera_heap_index_add(vera_heap_segment_index_t s) {

	// TODO: Search idle list.

	vera_heap_handle_t index = vera_heap_segment.idle_list[s];

	if(index != VERAHEAP_NULL) {
		heap_idle_remove(s, index);
	} else {
		// The current header gets the current heap position handle.
		index = vera_heap_segment.index_position[s];

		// We adjust to the next index position.
		vera_heap_segment.index_position[s]++;
	}

	// TODO: out of memory check.

	return index;
}


vera_heap_handle_t vera_heap_heap_add(vera_heap_segment_index_t s, vera_heap_size_packed_t size) {


	// Add a new index.
	vera_heap_handle_t index = vera_heap_index_add(s);

	// The data handle of the header gets appointed with the current heap position handle.
    vera_heap_set_data_packed(s, index, vera_heap_segment.heap_offset[s]);
    vera_heap_set_size_packed(s, index, size); // packed size!
	vera_heap_heap_insert_at(s, index, vera_heap_segment.heap_list[s], size); // TODO, not kosher

	// Decrease the current heap position handle with the size needed to be newly allocated.
	vera_heap_data_packed_t heap_offset = vera_heap_segment.heap_offset[s] += size;

	return index;
}

/**
 * Splits the header on two, returns the pointer to the smaller sub-header.
 */
vera_heap_handle_t vera_heap_split_free_and_allocate(vera_heap_segment_index_t s, vera_heap_handle_t free_index, vera_heap_size_packed_t required_size) {

    // The free block is reduced in size with the required size.
	vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index);
	vera_heap_data_packed_t free_data = vera_heap_get_data_packed(s, free_index);
    
    vera_heap_set_size_packed(s, free_index, free_size - required_size);
    vera_heap_set_data_packed(s, free_index, free_data + required_size);

    // We create a new heap block with the required size.
    // The data is the offset in vram.
	vera_heap_handle_t heap_index = vera_heap_index_add(s);

    vera_heap_set_data_packed(s, heap_index, free_data);
	vera_heap_heap_insert_at(s, heap_index, VERAHEAP_NULL, required_size);

    vera_heap_handle_t heap_left = vera_heap_get_left(s, free_index);
    vera_heap_handle_t heap_right = free_index;

    vera_heap_set_left(s, heap_index, heap_left);
    // printf("\nright = %04x", heap_right);
    vera_heap_set_right(s, heap_index, heap_right);

    vera_heap_set_right(s, heap_left, heap_index);
    vera_heap_set_left(s, heap_right, heap_index);

#ifdef VERAHEAP_DEBUG
    printf("\n > Split free index %04x size %05x and allocate heap index %04x size %05x", free_index, vera_heap_get_size(s, free_index), heap_index, vera_heap_get_size(s, heap_index));
#endif

	return heap_index;
}

/**
 * Whether the free memory block can be split. 
 * A spllit can occur when the free memory block is larger than the required size to be allocated.
 */
vera_heap_size_packed_t vera_heap_can_split_free(vera_heap_segment_index_t s, vera_heap_handle_t free_index, vera_heap_size_packed_t required_size) {

    vera_heap_size_packed_t split_size = vera_heap_get_size_packed(s, free_index) - required_size;

#ifdef VERAHEAP_DEBUG
    printf("\n > Can split free index %04x to size %05x, heap size %05x", free_index, vera_heap_size_unpack(split_size), vera_heap_size_unpack(required_size));
#endif

	return split_size;
}

/**
 * Allocates a header from the list, splitting if needed.
 */
vera_heap_handle_t vera_heap_allocate(vera_heap_segment_index_t s, vera_heap_handle_t free_index, vera_heap_size_packed_t required_size) 
{
	// Split the larger header, reusing the free part.
	if (vera_heap_can_split_free(s, free_index, required_size)) {
		return vera_heap_split_free_and_allocate(s, free_index, required_size);
	}

	return VERAHEAP_NULL;
}




/**
 * Best-fit algorithm.
 */
vera_heap_handle_t vera_heap_alloc_using_free(vera_heap_segment_index_t s, vera_heap_size_packed_t requested_size) {

	vera_heap_handle_t free_index = vera_heap_segment.free_list[s];

    if(free_index == VERAHEAP_NULL) {
        return VERAHEAP_NULL;
    }

	vera_heap_handle_t free_end = vera_heap_segment.free_list[s];

#ifdef VERAHEAP_DEBUG
    printf(", best fit is ");
#endif

    vera_heap_size_packed_t best_size = 0xFFFF;
    vera_heap_size_packed_t best_index = VERAHEAP_NULL;

	do {

		// O(n) search.
		vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index);


		if(free_size < best_size) {
            best_size = free_size;
            best_index = free_index;
        }

        free_index = vera_heap_get_next(s, free_index);

	} while(free_index != free_end);

#ifdef VERAHEAP_DEBUG
        printf("free index %04x size %05x, ", best_index, vera_heap_size_unpack(best_size) );
#endif

    if(requested_size <= best_size) {
        return vera_heap_allocate(s, best_index, requested_size);
    }

	return VERAHEAP_ERROR;
}

/**
 * Whether we should merge this header to the left.
 */
vera_heap_handle_t vera_heap_can_coalesce_left(vera_heap_segment_index_t s, vera_heap_handle_t heap_index) {

	vera_heap_handle_t free_index = vera_heap_segment.free_list[s];
	vera_heap_handle_t end_index = vera_heap_segment.free_list[s];


    vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(s, heap_index);

    vera_heap_handle_t left_index = vera_heap_get_left(s, heap_index);
    vera_heap_data_packed_t left_offset = vera_heap_get_data_packed(s, left_index);
    unsigned int left_free = vera_heap_get_free(s, left_index);

    if(left_free && (left_offset < heap_offset)) {
#ifdef VERAHEAP_DEBUG
    printf("\n > Can coalesce to the left with free index %04x", left_index);
#endif
        return left_index;
    }

#ifdef VERAHEAP_DEBUG
    printf("\n > Cannot coalesce to the left");
#endif
    return VERAHEAP_NULL;
}


/**
 * Whether we should merge this header to the right.
 */
vera_heap_handle_t heap_can_coalesce_right(vera_heap_segment_index_t s, vera_heap_handle_t heap_index) {

	vera_heap_handle_t free_index = vera_heap_segment.free_list[s];
	vera_heap_handle_t end_index = vera_heap_segment.free_list[s];

    vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(s, heap_index);

    vera_heap_handle_t right_index = vera_heap_get_right(s, heap_index);
    vera_heap_data_packed_t right_offset = vera_heap_get_data_packed(s, right_index);
    unsigned int right_free = vera_heap_get_free(s, right_index);

    if(right_free && (heap_offset < right_offset)) {
#ifdef VERAHEAP_DEBUG
    printf("\n > Can coalesce to the right with free index %04x", right_index);
#endif
        return right_index;
    }

    // A free_index is not found, we cannot coalesce.
#ifdef VERAHEAP_DEBUG
    printf("\n > Cannot coalesce to the right");
#endif
	return VERAHEAP_NULL;
}


/**
 * Coalesces two adjacent blocks to the left.
 * The left is a free index and the right is the heap index to be freed.
 * The free index remains free, and the heap to the right stays heap.
 * The free index is returned as the new remaining (free) block.
 */
vera_heap_handle_t heap_coalesce_left(vera_heap_segment_index_t s, vera_heap_handle_t left_index, vera_heap_handle_t middle_index) {

	vera_heap_size_packed_t left_size = vera_heap_get_size_packed(s, left_index);
    vera_heap_data_packed_t left_offset = vera_heap_get_data_packed(s, left_index);

	vera_heap_size_packed_t middle_size = vera_heap_get_size_packed(s, middle_index);

    vera_heap_handle_t free_left = vera_heap_get_left(s, left_index);
    vera_heap_handle_t free_right = vera_heap_get_right(s, middle_index);

	// We detach the left index from the free list and add it to the idle list.
	vera_heap_free_remove(s, left_index);
	vera_heap_idle_insert(s, left_index);

    vera_heap_set_left(s, middle_index, free_left);
    vera_heap_set_right(s, middle_index, free_right);

    vera_heap_set_left(s, free_right, middle_index);
    vera_heap_set_right(s, free_left, middle_index);

    vera_heap_set_left(s, left_index, VERAHEAP_NULL);
    vera_heap_set_right(s, left_index, VERAHEAP_NULL);

    vera_heap_set_size_packed(s, middle_index, left_size + middle_size);
    vera_heap_set_data_packed(s, middle_index, left_offset);

#ifdef VERAHEAP_DEBUG
    printf("\n > Coalesce left idling index %04x and expanding free index %04x", left_index, middle_index);
#endif

	return middle_index;
}

/**
 * Coalesces two adjacent blocks to the right.
 * The the right will remain and the middle will be idled after joining.
 * The right index is returned as the new remaining (free) block.
 */
vera_heap_handle_t heap_coalesce_right(vera_heap_segment_index_t s, vera_heap_handle_t middle_index, vera_heap_handle_t right_index) {

	vera_heap_size_packed_t right_size = vera_heap_get_size_packed(s, right_index);
	vera_heap_size_packed_t middle_size = vera_heap_get_size_packed(s, middle_index);
    vera_heap_data_packed_t middle_offset = vera_heap_get_data_packed(s, middle_index);

    vera_heap_handle_t free_left = vera_heap_get_left(s, middle_index);
    vera_heap_handle_t free_right = vera_heap_get_right(s, right_index);

	// We detach the middle index from the free list and add it to the idle list.
	vera_heap_free_remove(s, middle_index);
	vera_heap_idle_insert(s, middle_index);

    vera_heap_set_left(s, right_index, free_left);
    vera_heap_set_right(s, right_index, free_right);

    vera_heap_set_left(s, free_right, right_index);
    vera_heap_set_right(s, free_left, right_index);

    vera_heap_set_left(s, middle_index, VERAHEAP_NULL);
    vera_heap_set_right(s, middle_index, VERAHEAP_NULL);

    vera_heap_set_size_packed(s, right_index, middle_size + right_size);
    vera_heap_set_data_packed(s, right_index, middle_offset);

#ifdef VERAHEAP_DEBUG
    printf("\n > Coalesce right idling index %04x and expanding free index %04x", middle_index, right_index);
#endif

	return right_index;
}




void vera_heap_bram_bank_init(bram_bank_t bram_bank)
{
    vera_heap_segment.bram_bank = bram_bank;
}

/**
 * @brief Create a heap segment in cx16 vera ram.
 * For the given segment, a value between 0 and 15, define a heap in vera ram.
 * A heap in vera ram is useful to dynamically load tiles or sprites 
 * without having to be concerned of memmory management anymore.
 * The heap memory manager will manage the memory for you!
 * The heapCeilVram and heapSizeVram define the heap in the VERA ram.
 * An index needs to be created, and is managed by the heap memory manager, which
 * is specified by the indexFloorBram and indexSizeBram parameters.
 * Note that all these parameters are in packed format, and must be specified using
 * the respective packed functions.
 * 
 * @example 
 * // Allocate the segment for the sprites in vram.
 * heap_vram_packed vram_sprites = heap_segment_vram_ceil( 1,
 *    vram_petscii,
 *    vram_petscii,
 *    heap_bram_pack(2, (heap_ptr)0xA000),
 *    heap_size_pack(0x2000)
 * );
 * 
 * @return void 
 */
vera_heap_segment_index_t vera_heap_segment_init(
    vera_heap_segment_index_t   s,
    vram_bank_t                 vram_bank_floor,
    vram_offset_t               vram_offset_floor,
    vram_bank_t                 vram_bank_ceil,
    vram_offset_t               vram_offset_ceil
	)
{

    // TODO initialize segment to all zero
    vera_heap_segment.vram_bank_floor[s] = vram_bank_floor;
    vera_heap_segment.vram_offset_floor[s] = vram_offset_floor;
    vera_heap_segment.vram_bank_ceil[s] = vram_bank_ceil;
    vera_heap_segment.vram_offset_ceil[s] = vram_offset_ceil;

    vera_heap_segment.floor[s] = vera_heap_data_pack(vram_bank_floor, vram_offset_floor);
    vera_heap_segment.ceil[s]  = vera_heap_data_pack(vram_bank_ceil, vram_offset_ceil);

    vera_heap_segment.heap_offset[s] = 0;
    vera_heap_segment.index_position[s] = 0;


	vera_heap_segment.heapCount[s] = 0;
	vera_heap_segment.heapSize[s] = 0;
	vera_heap_segment.freeCount[s] = 0;
	vera_heap_segment.freeSize[s] = vera_heap_segment.ceil[s] - vera_heap_segment.floor[s];
	vera_heap_segment.idleCount[s] = 0;

    vera_heap_segment.heap_list[s] = VERAHEAP_NULL;
    vera_heap_segment.idle_list[s] = VERAHEAP_NULL;
    vera_heap_segment.free_list[s] = VERAHEAP_NULL;

	bram_bank_t bank_old = bank_get_bram();
    bank_set_bram(vera_heap_segment.bram_bank);

    vera_heap_handle_t free_index = vera_heap_index_add(s);
    free_index = vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, 0);
    vera_heap_set_data_packed(s, free_index, vera_heap_segment.floor[s]);
    vera_heap_set_size_packed(s, free_index, vera_heap_segment.ceil[s] - vera_heap_segment.floor[s]);
    vera_heap_set_free(s, free_index);
    vera_heap_set_next(s, free_index, 0);
    vera_heap_set_prev(s, free_index, 0);
    vera_heap_segment.free_list[s] = free_index;
    
    bank_set_bram(bank_old);

    return s;
}


/**
 * @brief Allocated a specified size of memory on the heap of the segment.
 * 
 * @param size Specifies the size of memory to be allocated.
 * Note that the size is aligned to an 8 byte boundary by the memory manager.
 * When the size of the memory block is enquired, an 8 byte aligned value will be returned.
 * @return heap_handle The handle referring to the free record in the index.
 */
vera_heap_handle_t vera_heap_alloc(vera_heap_segment_index_t s, vera_heap_size_t size) 
{

	bram_bank_t bank_old = bank_get_bram();

    bank_set_bram(vera_heap_segment.bram_bank);

	// Adjust given size to 8 bytes boundary (shift right with 3 bits).
	vera_heap_size_packed_t packed_size = vera_heap_alloc_size_get(size);

#ifdef VERAHEAP_DEBUG
    printf("\n > Allocate size %05x", size);
#endif

	// Traverse the blocks list, searching for a header of
	// the appropriate size.

    vera_heap_handle_t heap_index = vera_heap_alloc_using_free(s, packed_size);
    if(heap_index != VERAHEAP_NULL) {
#ifdef VERAHEAP_DEBUG
        printf("\n");
#endif
        vera_heap_segment.freeSize[s] -= packed_size;
        vera_heap_segment.heapSize[s] += packed_size;
    } else {
        // No free index found! this means out of memory!
    }

	bank_set_bram(bank_old);

	return heap_index;
}

/**
 * @brief Free a memory block from the heap using the handle of allocated memory of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @param handle The handle referring to the heap memory block.
 * @return heap_handle 
 */
void vera_heap_free(vera_heap_segment_index_t s, vera_heap_handle_t free_index) 
{
	vram_bank_t bank_old = bank_get_bram();

    bank_set_bram(vera_heap_segment.bram_bank);

	vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index);

#ifdef VERAHEAP_DEBUG
    printf("\n > Free index %04x size %05x", free_index, vera_heap_size_unpack(free_size));
#endif

	vera_heap_data_packed_t free_offset = vera_heap_get_data_packed(s, free_index);

	vera_heap_heap_remove(s, free_index);
	vera_heap_free_insert(s, free_index, free_offset, free_size);

    vera_heap_handle_t free_left_index = vera_heap_can_coalesce_left(s, free_index);
    if(free_left_index != VERAHEAP_NULL) {
        free_index = heap_coalesce_left(s, free_left_index, free_index);
    } 

    vera_heap_handle_t free_right_index = heap_can_coalesce_right(s, free_index);
    if(free_right_index != VERAHEAP_NULL) {
        free_index = heap_coalesce_right(s, free_index, free_right_index);
    }

#ifdef VERAHEAP_DEBUG
    printf("\n");
#endif

    vera_heap_segment.freeSize[s] += free_size;
    vera_heap_segment.heapSize[s] -= free_size;

	bank_set_bram(bank_old);

	// return free_index;
}


/**
 * @brief Print an index list.
 * 
 * @param prefix The chain code.
 * @param list The index list with packed next and prev pointers.
 */
void vera_heap_dump_index_print(vera_heap_segment_index_t s, char prefix, vera_heap_handle_t list)
{

	if (list == VERAHEAP_NULL) return;
	vera_heap_handle_t index = list;
	vera_heap_handle_t end_index = list;
	do {
		printf("%03u  %c  ", index, prefix);
		printf("%x%04x  %05x  ", vera_heap_data_get_bank(s, index), vera_heap_data_get_offset(s, index), vera_heap_get_size(s, index));
		printf("%02x  %02x  ", vera_heap_get_next(s, index), vera_heap_get_prev(s, index));
		printf("%02x  %02x  ", vera_heap_get_left(s, index), vera_heap_get_right(s, index));
		printf("\n");
		index = vera_heap_get_next(s, index);
	} while (index != end_index);
}


/**
 * @brief Print the heap memory manager statistics of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
void vera_heap_dump_stats(vera_heap_segment_index_t s)
{
    segment = s;

	printf("size  alloc:%07u free:%07u\n", vera_heap_alloc_size(s), vera_heap_free_size(s));
	printf("count alloc:%04u free:%04u idle:%04u\n", vera_heap_alloc_count(s), vera_heap_free_count(s), vera_heap_idle_count(s));
}

/**
 * @brief Ddump the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
void vera_heap_dump_index(vera_heap_segment_index_t s)
{
	bram_bank_t bank_old = bank_get_bram();

    segment = s;

    bank_set_bram(vera_heap_segment.bram_bank);

	printf("list  heap:%04x free:%04x idle:%04x\n", vera_heap_segment.heap_list[s], vera_heap_segment.free_list[s], vera_heap_segment.idle_list[s]);

    printf("#    T  OFFS   SIZE   N   P   L   R   \n");
    printf("---  -  -----  -----  --  --  --  --  \n");
	vera_heap_dump_index_print(s, 'I', vera_heap_segment.idle_list[s]);
	vera_heap_dump_index_print(s, 'F', vera_heap_segment.free_list[s]);
	vera_heap_dump_index_print(s, 'H', vera_heap_segment.heap_list[s]);

    bank_set_bram(bank_old);
}

/**
 * @brief Print the heap memory manager statistics and dump the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
void vera_heap_dump(vera_heap_segment_index_t s)
{
	vera_heap_dump_stats(s);
	vera_heap_dump_index(s);
}

/**
 * @brief Return the size of allocated heap records of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_size_large
 */
vera_heap_size_t vera_heap_free_size(vera_heap_segment_index_t s)
{
	vera_heap_size_packed_t freeSize = vera_heap_segment.freeSize[s];
	return (vera_heap_size_t)freeSize;
}

/**
 * @brief Return the size of allocated heap records of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_size_large 
 */

// TODO - make long
vera_heap_size_t vera_heap_alloc_size(vera_heap_segment_index_t s)
{
	vera_heap_size_packed_t freeSize = vera_heap_segment.freeSize[s];
	vera_heap_size_packed_t heapSize = vera_heap_segment.heapSize[s];
	return (vera_heap_size_t)(heapSize);
}

/**
 * @brief Return the amount of heap records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
unsigned int vera_heap_alloc_count(vera_heap_segment_index_t s)
{
	return vera_heap_segment.heapCount[s] - vera_heap_segment.freeCount[s];
}

/**
 * @brief Return the amount of free records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
unsigned int vera_heap_free_count(vera_heap_segment_index_t s)
{
	return vera_heap_segment.freeCount[s];
}

/**
 * @brief Return the amount of idle records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
unsigned int vera_heap_idle_count(vera_heap_segment_index_t s)
{
	return vera_heap_segment.idleCount[s];
}
