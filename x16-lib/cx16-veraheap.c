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
#include <cx16-veralib.h>

#include <cx16-veraheap.h>



#ifdef __VERAHEAP_SEGMENT
#pragma data_seg(VeraHeap)
#endif
vera_heap_map_t  vera_heap_index; // The heap index is located in BRAM.

#pragma data_seg(Data)
vera_heap_segment_t vera_heap_segment; // The segment managmeent is in main memory.

__mem unsigned char veraheap_dx = 0;
__mem unsigned char veraheap_dy = 0;

#ifdef __VERAHEAP_COLOR_FREE
__mem unsigned char veraheap_color = 0;
#endif

vera_heap_data_packed_t vera_heap_data_pack(vram_bank_t vram_bank, vram_offset_t vram_offset)
{
    return MAKEWORD(vram_bank<<5, 0) | (vram_offset>>3);
}


vera_heap_data_packed_t vera_heap_get_data_packed(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    return MAKEWORD(vera_heap_index.data1[index],vera_heap_index.data0[index]);
}


inline vram_bank_t vera_heap_data_get_bank(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    bank_push_bram(); bank_set_bram(vera_heap_segment.bram_bank);
    vram_bank_t vram_bank = vera_heap_index.data1[index] >> 5;
    bank_pull_bram();
    return vram_bank;
}


inline vram_offset_t vera_heap_data_get_offset(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    bank_push_bram(); bank_set_bram(vera_heap_segment.bram_bank);
    vram_offset_t vram_offset = (vram_offset_t)vera_heap_get_data_packed(s, index) << 3;
    bank_pull_bram();
    return vram_offset;
}




void vera_heap_set_data(vera_heap_segment_index_t s, vera_heap_index_t index, vram_bank_t vram_bank, vram_offset_t vram_offset)
{
    vera_heap_index.data1[index] = vram_bank << 5 | BYTE1(vram_offset)>>3;
    vera_heap_index.data0[index] = (BYTE1(vram_offset)>>3  & 0x11100000) | BYTE0(vram_offset>>3);
}


void vera_heap_set_data_packed(vera_heap_segment_index_t s, vera_heap_index_t index, vera_heap_data_packed_t data_packed)
{
    vera_heap_index.data1[index] = BYTE1(data_packed);
    vera_heap_index.data0[index] = BYTE0(data_packed);
}

void vera_heap_set_free(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    vera_heap_index.size1[index] |= 0x80;
}


void vera_heap_clear_free(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    vera_heap_index.size1[index] &= 0x7F;
}


bool vera_heap_is_free(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    return (vera_heap_index.size1[index] & 0x80) == 0x80;
}

vera_heap_size_packed_t vera_heap_size_pack(vera_heap_size_t size)
{
    return (vera_heap_size_packed_t)MAKEWORD(BYTE2(size)<<5, 0) | (WORD0(size) >> 3);
}

vera_heap_size_packed_t vera_heap_get_size_packed(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    return MAKEWORD(vera_heap_index.size1[index] & 0x7F, vera_heap_index.size0[index]); // Ignore free flag!
}

vera_heap_size_t vera_heap_size_unpack(vera_heap_size_packed_t size)
{
    return (vera_heap_size_t)size << 3; // free flag is automatically removed
}

vera_heap_size_int_t vera_heap_get_size_int(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    bank_push_bram(); bank_set_bram(vera_heap_segment.bram_bank);
    vera_heap_size_packed_t size = vera_heap_get_size_packed(s, index);
    bank_pull_bram();
    return size << 3;
}

vera_heap_size_t vera_heap_get_size(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    bank_push_bram(); bank_set_bram(vera_heap_segment.bram_bank);
    vera_heap_size_t size = vera_heap_get_size_packed(s, index) << 3;
    bank_pull_bram();
    return size;
}

void vera_heap_set_size(vera_heap_segment_index_t s, vera_heap_index_t index, vera_heap_size_t size)
{
    vera_heap_index.data1[index] = BYTE1(size)>>3;
    vera_heap_index.data0[index] = (BYTE1(size)>>3 & 0x11100000) | BYTE0(size>>3);
}


void vera_heap_set_size_packed(vera_heap_segment_index_t s, vera_heap_index_t index, vera_heap_size_packed_t size_packed)
{
    vera_heap_index.size1[index] &= vera_heap_index.size1[index] & 0x80;
    vera_heap_index.size1[index] = BYTE1(size_packed) & 0x7F; // Ignore free flag.
    vera_heap_index.size0[index] = BYTE0(size_packed);
}


inline vera_heap_index_t vera_heap_get_next(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    return vera_heap_index.next[index];
}


inline void vera_heap_set_next(vera_heap_segment_index_t s, vera_heap_index_t index, vera_heap_index_t next)
{
    vera_heap_index.next[index] = next;
}


inline vera_heap_index_t vera_heap_get_prev(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    return vera_heap_index.prev[index];
}


inline void vera_heap_set_prev(vera_heap_segment_index_t s, vera_heap_index_t index, vera_heap_index_t prev)
{
    vera_heap_index.prev[index] = prev;
}


inline vera_heap_index_t vera_heap_get_left(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    return vera_heap_index.left[index];
}


inline void vera_heap_set_left(vera_heap_segment_index_t s, vera_heap_index_t index, vera_heap_index_t left)
{
    vera_heap_index.left[index] = left;
}


inline vera_heap_index_t vera_heap_get_right(vera_heap_segment_index_t s, vera_heap_index_t index)
{
    return vera_heap_index.right[index];
}


inline void vera_heap_set_right(vera_heap_segment_index_t s, vera_heap_index_t index, vera_heap_index_t right)
{
    vera_heap_index.right[index] = right;
}


/**
* Insert index in list at sorted position.
*/
vera_heap_index_t vera_heap_list_insert_at(vera_heap_segment_index_t s, vera_heap_index_t list, vera_heap_index_t index, vera_heap_index_t at) {

	if(list == VERAHEAP_NULL) {
		// empty list
		list = index;
        vera_heap_set_prev(s, index, index);
        vera_heap_set_next(s, index, index);
	}

    if(at == VERAHEAP_NULL) {
        at=list;
    }

	vera_heap_index_t last = vera_heap_get_prev(s, at);
	vera_heap_index_t first = at;

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
vera_heap_index_t vera_heap_list_remove(vera_heap_segment_index_t s, vera_heap_index_t list, vera_heap_index_t index) 
{

	if(list == VERAHEAP_NULL) {
		// empty list
		return VERAHEAP_NULL;
	}

	// The free makes the list empty!
	if(list == vera_heap_get_next(s, list)) {
		list = 0; // We initialize the start of the list to null.
        vera_heap_set_next(s, index, VERAHEAP_NULL);
        vera_heap_set_prev(s, index, VERAHEAP_NULL);
		return VERAHEAP_NULL; 
	}

    vera_heap_index_t next = vera_heap_get_next(s, index);
    vera_heap_index_t prev = vera_heap_get_prev(s, index);

    // TODO, why can't this be coded in one statement ...
    vera_heap_set_next(s, prev, next);
    vera_heap_set_prev(s, next, prev);

	// The free changes the first header of the list!
	if(index == list) { 
		list = vera_heap_get_next(s, list);
	}

	return list;
}

vera_heap_index_t vera_heap_heap_insert_at(vera_heap_segment_index_t s, vera_heap_index_t heap_index, vera_heap_index_t at, vera_heap_size_packed_t size)
{
	vera_heap_segment.heap_list[s] = vera_heap_list_insert_at(s, vera_heap_segment.heap_list[s], heap_index, at);
    vera_heap_set_size_packed(s, heap_index, size);
	vera_heap_segment.heapCount[s]++;
	return vera_heap_segment.heap_list[s];
}

void vera_heap_heap_remove(vera_heap_segment_index_t s, vera_heap_index_t heap_index) 
{
	vera_heap_segment.heapCount[s]--;
	vera_heap_segment.heap_list[s] = vera_heap_list_remove(s, vera_heap_segment.heap_list[s], heap_index);
}

vera_heap_index_t vera_heap_free_insert(vera_heap_segment_index_t s, vera_heap_index_t free_index, vera_heap_data_packed_t data, vera_heap_size_packed_t size) 
{
	vera_heap_segment.free_list[s] = vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, vera_heap_segment.free_list[s]);
    vera_heap_set_data_packed(s, free_index, data);
    vera_heap_set_size_packed(s, free_index, size);
    vera_heap_set_free(s, free_index);
	vera_heap_segment.freeCount[s]++;
	return vera_heap_segment.free_list[s];
}

void vera_heap_free_remove(vera_heap_segment_index_t s, vera_heap_index_t free_index) {
	vera_heap_segment.freeCount[s]--;
	vera_heap_segment.free_list[s] = vera_heap_list_remove(s, vera_heap_segment.free_list[s], free_index);
    vera_heap_clear_free(s, free_index);
}

vera_heap_index_t vera_heap_idle_insert(vera_heap_segment_index_t s, vera_heap_index_t idle_index) {
	vera_heap_segment.idle_list[s] = vera_heap_list_insert_at(s, vera_heap_segment.idle_list[s], idle_index, vera_heap_segment.idle_list[s]);
    vera_heap_set_data_packed(s, idle_index, 0);
    vera_heap_set_size_packed(s, idle_index, 0);
	vera_heap_segment.idleCount[s]++;
	return vera_heap_segment.idle_list[s];
}

void heap_idle_remove(vera_heap_segment_index_t s, vera_heap_index_t idle_index) {
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


vera_heap_index_t vera_heap_index_add(vera_heap_segment_index_t s) {

	// TODO: Search idle list.

	vera_heap_index_t index = vera_heap_segment.idle_list[s];

	if(index != VERAHEAP_NULL) {
		heap_idle_remove(s, index);
	} else {
		// The current header gets the current heap position handle.
		index = vera_heap_segment.index_position;

		// We adjust to the next index position.
		vera_heap_segment.index_position += 1;
	}

	// TODO: out of memory check.

	return index;
}


vera_heap_index_t vera_heap_heap_add(vera_heap_segment_index_t s, vera_heap_size_packed_t size) {


	// Add a new index.
	vera_heap_index_t index = vera_heap_index_add(s);

	// The data handle of the header gets appointed with the current heap position handle.
    vera_heap_set_data_packed(s, index, vera_heap_segment.heap_offset[s]);
    vera_heap_set_size_packed(s, index, size); // packed size!
	vera_heap_heap_insert_at(s, index, vera_heap_segment.heap_list[s], size); // TODO, not kosher

	// Decrease the current heap position handle with the size needed to be newly allocated.
	vera_heap_data_packed_t heap_offset = vera_heap_segment.heap_offset[s] += size;

	return index;
}

/**
 * The free size matches exactly the required heap size.
 * The free index is replaced by a heap index.
 */
vera_heap_index_t vera_heap_replace_free_with_heap(vera_heap_segment_index_t s, vera_heap_index_t free_index, vera_heap_size_packed_t required_size) {

	vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index);
	vera_heap_data_packed_t free_data = vera_heap_get_data_packed(s, free_index);
    vera_heap_index_t free_left = vera_heap_get_left(s, free_index);
    vera_heap_index_t free_right = vera_heap_get_right(s, free_index);

    vera_heap_free_remove(s, free_index);

	vera_heap_index_t heap_index = free_index;
	vera_heap_heap_insert_at(s, heap_index, VERAHEAP_NULL, required_size);
    vera_heap_set_data_packed(s, heap_index, free_data);
    vera_heap_set_left(s, heap_index, free_left);
    vera_heap_set_right(s, heap_index, free_right);

#ifdef __VERAHEAP_DEBUG
    printf("\n > Replaced free index with heap index %03x size %05x.", heap_index, vera_heap_get_size(s, heap_index));
#endif

	return heap_index;
}

/**
 * Splits the header on two, returns the pointer to the smaller sub-header.
 */
vera_heap_index_t vera_heap_split_free_and_allocate(vera_heap_segment_index_t s, vera_heap_index_t free_index, vera_heap_size_packed_t required_size) {

    // The free block is reduced in size with the required size.
	vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index);
	vera_heap_data_packed_t free_data = vera_heap_get_data_packed(s, free_index);
    
    vera_heap_set_size_packed(s, free_index, free_size - required_size);
    vera_heap_set_data_packed(s, free_index, free_data + required_size);

    // We create a new heap block with the required size.
    // The data is the offset in vram.
	vera_heap_index_t heap_index = vera_heap_index_add(s);

    vera_heap_set_data_packed(s, heap_index, free_data);
	vera_heap_heap_insert_at(s, heap_index, VERAHEAP_NULL, required_size);

    vera_heap_index_t heap_left = vera_heap_get_left(s, free_index);
    vera_heap_index_t heap_right = free_index;

    vera_heap_set_left(s, heap_index, heap_left);
    // printf("\nright = %03x", heap_right);
    vera_heap_set_right(s, heap_index, heap_right);

    vera_heap_set_right(s, heap_left, heap_index);
    vera_heap_set_left(s, heap_right, heap_index);

    vera_heap_set_free(s, heap_right);
    vera_heap_clear_free(s, heap_left);

#ifdef __VERAHEAP_DEBUG
    printf("\n > Split free index %03x size %05x and allocate heap index %03x size %05x.", free_index, vera_heap_get_size(s, free_index), heap_index, vera_heap_get_size(s, heap_index));
#endif

	return heap_index;
}

/**
 * Whether the free memory block can be split. 
 * A spllit can occur when the free memory block is larger than the required size to be allocated.
 */
signed char vera_heap_can_split_free(vera_heap_segment_index_t s, vera_heap_index_t free_index, vera_heap_size_packed_t required_size) {

    vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index);
    if(free_size > required_size) {
#ifdef __VERAHEAP_DEBUG
        printf("\n > Can split free index %03x to size %05x, heap size %05x.", free_index, vera_heap_size_unpack(free_size - required_size), vera_heap_size_unpack(required_size));
#endif
        return 1;

    } else {
        if(free_size == required_size) {
#ifdef __VERAHEAP_DEBUG
            printf("\n > Can replace free index %03x with heap size %05x.", free_index, vera_heap_size_unpack(required_size));
#endif
            return 0;
        } else {
            return -1;
        }
    }
}

/**
 * Allocates a header from the list, splitting if needed.
 */
vera_heap_index_t vera_heap_allocate(vera_heap_segment_index_t s, vera_heap_index_t free_index, vera_heap_size_packed_t required_size) 
{
    vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index);

    if(free_size > required_size) {
#ifdef __VERAHEAP_DEBUG
        printf("\n > Can split free index %03x to size %05x, heap size %05x.", free_index, vera_heap_size_unpack(free_size - required_size), vera_heap_size_unpack(required_size));
#endif
		return vera_heap_split_free_and_allocate(s, free_index, required_size);
    } else {
        if(free_size == required_size) {
#ifdef __VERAHEAP_DEBUG
            printf("\n > Can replace free index %03x with heap size %05x.", free_index, vera_heap_size_unpack(required_size));
#endif
            return vera_heap_replace_free_with_heap(s, free_index, required_size);
        } else {
    	    return VERAHEAP_NULL;
        }
    }
}




/**
 * Best-fit algorithm.
 */
vera_heap_index_t vera_heap_find_best_fit(vera_heap_segment_index_t s, vera_heap_size_packed_t requested_size) {

	vera_heap_index_t free_index = vera_heap_segment.free_list[s];

    if(free_index == VERAHEAP_NULL) {
        return VERAHEAP_NULL;
    }

	vera_heap_index_t free_end = vera_heap_segment.free_list[s];

#ifdef __VERAHEAP_DEBUG
    printf(", best fit is ");
#endif

    vera_heap_size_packed_t best_size = 0xFFFF;
    vera_heap_index_t best_index = VERAHEAP_NULL;

	do {

		// O(n) search.
		vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index);


		if(free_size >= requested_size && free_size < best_size) {
            best_size = free_size;
            best_index = free_index;
        }

        free_index = vera_heap_get_next(s, free_index);

	} while(free_index != free_end);

#ifdef __VERAHEAP_DEBUG
        printf("free index %03x size %05x.", best_index, vera_heap_size_unpack(best_size) );
#endif

    if(requested_size <= best_size) {
        return best_index;
    }

	return VERAHEAP_NULL;
}

/**
 * Whether we should merge this header to the left.
 */
vera_heap_index_t vera_heap_can_coalesce_left(vera_heap_segment_index_t s, vera_heap_index_t heap_index) {

    vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(s, heap_index);

    vera_heap_index_t left_index = vera_heap_get_left(s, heap_index);
    vera_heap_data_packed_t left_offset = vera_heap_get_data_packed(s, left_index);
    bool left_free = vera_heap_is_free(s, left_index);


    if(left_free && (left_offset < heap_offset)) {
#ifdef __VERAHEAP_DEBUG
    printf("\n > Left index %02x is free %s with offset %04x\n", left_index, left_free?"true":"false", left_offset);
    printf("\n > Can coalesce to the left with free index %03x.", left_index);
#endif
        return left_index;
    }

#ifdef __VERAHEAP_DEBUG
    printf("\n > Cannot coalesce to the left.");
#endif
    return VERAHEAP_NULL;
}


/**
 * Whether we should merge this header to the right.
 */
vera_heap_index_t heap_can_coalesce_right(vera_heap_segment_index_t s, vera_heap_index_t heap_index) {

    vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(s, heap_index);

    vera_heap_index_t right_index = vera_heap_get_right(s, heap_index);
    vera_heap_data_packed_t right_offset = vera_heap_get_data_packed(s, right_index);
    bool right_free = vera_heap_is_free(s, right_index);

    if(right_free && (heap_offset < right_offset)) {
#ifdef __VERAHEAP_DEBUG
    printf("\n > Right index %02x is free %s with offset %04x\n", right_index, right_free?"true":"false", right_offset);
    printf("\n > Can coalesce to the right with free index %03x.", right_index);
#endif
        return right_index;
    }

    // A free_index is not found, we cannot coalesce.
#ifdef __VERAHEAP_DEBUG
    printf("\n > Cannot coalesce to the right.");
#endif
	return VERAHEAP_NULL;
}


/**
 * Coalesces two adjacent blocks to the left.
 * The left is a free index and the right is the heap index to be freed.
 * The free index remains free, and the heap to the right stays heap.
 * The free index is returned as the new remaining (free) block.
 */
vera_heap_index_t vera_heap_coalesce(vera_heap_segment_index_t s, vera_heap_index_t left_index, vera_heap_index_t right_index) {

	vera_heap_size_packed_t right_size = vera_heap_get_size_packed(s, right_index);
	vera_heap_size_packed_t left_size = vera_heap_get_size_packed(s, left_index);
    vera_heap_data_packed_t left_offset = vera_heap_get_data_packed(s, left_index);

    vera_heap_index_t free_left = vera_heap_get_left(s, left_index);
    vera_heap_index_t free_right = vera_heap_get_right(s, right_index);

	// We detach the left index from the free list and add it to the idle list.
	vera_heap_free_remove(s, left_index);
	vera_heap_idle_insert(s, left_index);

    vera_heap_set_left(s, right_index, free_left);
    vera_heap_set_right(s, right_index, free_right);

    vera_heap_set_left(s, free_right, right_index);
    vera_heap_set_right(s, free_left, right_index);

    vera_heap_set_left(s, left_index, VERAHEAP_NULL);
    vera_heap_set_right(s, left_index, VERAHEAP_NULL);

    vera_heap_set_size_packed(s, right_index, left_size + right_size);
    vera_heap_set_data_packed(s, right_index, left_offset);

    vera_heap_set_free(s, left_index);
    vera_heap_set_free(s, right_index);

#ifdef __VERAHEAP_DEBUG
    printf("\n > Coalesce idling index %03x and expanding free index %03x.", left_index, right_index);
#endif

	return right_index;
}



void vera_heap_bram_bank_init(bram_bank_t bram_bank)
{
    vera_heap_segment.bram_bank = bram_bank;
    vera_heap_segment.index_position = 0;
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

    vera_heap_size_packed_t free_size = vera_heap_segment.ceil[s];
    free_size -= vera_heap_segment.floor[s];

	vera_heap_segment.heapCount[s] = 0;
	vera_heap_segment.freeCount[s] = 0;
	vera_heap_segment.idleCount[s] = 0;

    vera_heap_segment.heap_list[s] = VERAHEAP_NULL;
    vera_heap_segment.idle_list[s] = VERAHEAP_NULL;
    vera_heap_segment.free_list[s] = VERAHEAP_NULL;

	bram_bank_t bank_old = bank_get_bram();
    bank_set_bram(vera_heap_segment.bram_bank);

    vera_heap_index_t free_index = vera_heap_index_add(s);
    free_index = vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, free_index);
    vera_heap_set_data_packed(s, free_index, vera_heap_segment.floor[s]);
    vera_heap_set_size_packed(s, free_index, vera_heap_segment.ceil[s] - vera_heap_segment.floor[s]);
    vera_heap_set_free(s, free_index);
    vera_heap_set_next(s, free_index, free_index);
    vera_heap_set_prev(s, free_index, free_index);

    vera_heap_segment.freeCount[s]++;
    vera_heap_segment.free_list[s] = free_index;
    vera_heap_segment.freeSize[s] = free_size;
    vera_heap_segment.heapSize[s] = 0;
    
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
vera_heap_index_t vera_heap_alloc(vera_heap_segment_index_t s, vera_heap_size_t size) 
{

    bank_push_bram(); bank_set_bram(vera_heap_segment.bram_bank);

	// Adjust given size to 8 bytes boundary (shift right with 3 bits).
	vera_heap_size_packed_t packed_size = vera_heap_alloc_size_get(size);

#ifdef __VERAHEAP_DUMP
    vera_heap_dump(s, 0, 4);
    gotoxy(0, 46);
#endif

#ifdef __VERAHEAP_DEBUG
    printf("\n > Allocate segment %02x, size %05x", s, size);
#endif

    vera_heap_index_t heap_index = VERAHEAP_NULL;
    vera_heap_index_t free_index = vera_heap_find_best_fit(s, packed_size);

    if(free_index != VERAHEAP_NULL) {
        heap_index = vera_heap_allocate(s, free_index, packed_size);

        vera_heap_segment.freeSize[s] -= packed_size;
        vera_heap_segment.heapSize[s] += packed_size;
    } else {
        // No free index found! this means out of memory!
    }


#ifdef __VERAHEAP_DEBUG
        printf("\n > returning heap index %03x.\n", heap_index);
#endif

#ifdef __VERAHEAP_DUMP
    vera_heap_dump(s, 40, 4);
#endif

#ifdef __VERAHEAP_WAIT
    while(!kbhit());
#endif

	bank_pull_bram();

	return heap_index;
}

/**
 * @brief Free a memory block from the heap using the handle of allocated memory of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @param handle The handle referring to the heap memory block.
 * @return heap_handle 
 */
void vera_heap_free(vera_heap_segment_index_t s, vera_heap_index_t free_index) 
{
    bank_push_bram(); bank_set_bram(vera_heap_segment.bram_bank);

	vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index);

#ifdef __VERAHEAP_DUMP
    vera_heap_dump(s, 0, 4);
    gotoxy(0, 46);
#endif

#ifdef __VERAHEAP_DEBUG
    printf("\n > Free index %03x size %05x.", free_index, vera_heap_size_unpack(free_size));
#endif


	vera_heap_data_packed_t free_offset = vera_heap_get_data_packed(s, free_index);

    // TODO: only remove allocated indexes!
	vera_heap_heap_remove(s, free_index);
	vera_heap_free_insert(s, free_index, free_offset, free_size);

    vera_heap_index_t free_left_index = vera_heap_can_coalesce_left(s, free_index);
    if(free_left_index != VERAHEAP_NULL) {
        free_index = vera_heap_coalesce(s, free_left_index, free_index);
    } 

    vera_heap_index_t free_right_index = heap_can_coalesce_right(s, free_index);
    if(free_right_index != VERAHEAP_NULL) {
        free_index = vera_heap_coalesce(s, free_index, free_right_index);
    }

    #ifdef __VERAHEAP_COLOR_FREE
    vera_heap_size_int_t free_size_coalesced = vera_heap_get_size_int(s, free_index);
    vera_heap_bank_t free_bank_coalesced = vera_heap_data_get_bank(s, free_index);
    vera_heap_bank_t free_offset_coalesced = vera_heap_data_get_offset(s, free_index);
    memset_vram(free_bank_coalesced, free_offset_coalesced, veraheap_color++, free_size_coalesced);
    #endif

#ifdef __VERAHEAP_DEBUG
    printf("\n");
#endif

    vera_heap_segment.freeSize[s] += free_size;
    vera_heap_segment.heapSize[s] -= free_size;

#ifdef __VERAHEAP_DUMP
    vera_heap_dump(s, 40, 4);
#endif

#ifdef __VERAHEAP_WAIT
    while(!kbhit());
#endif

    bank_pull_bram();
}


/**
 * @brief Print the heap graphically in a block of 64 characters wide and 32 characters high.
 * One block represents 64 bytes in vram.
 */
void vera_heap_dump_graphic_print(vera_heap_segment_index_t s, unsigned char veraheap_dx, unsigned char veraheap_dy)
{


    vera_heap_index_t list = vera_heap_segment.heap_list[s];

	if (list == VERAHEAP_NULL) {
        return;
    }

    bank_push_bram(); bank_set_bram(vera_heap_segment.bram_bank);

	vera_heap_index_t index = vera_heap_segment.heap_list[s];	
	vera_heap_index_t end_index = vera_heap_segment.heap_list[s];

    unsigned char heap_count = vera_heap_segment.heapCount[s];

    char count = 0;

    gotoxy(veraheap_dx, veraheap_dy++);

	do {

        vera_heap_data_packed_t offset = vera_heap_get_data_packed(s, index);
        offset = offset >> 3;
        vera_heap_size_packed_t size = vera_heap_get_size_packed(s, index);
        size = size >> 3;


        unsigned char x = veraheap_dx + ((unsigned char)(offset % 64));
        unsigned char y = veraheap_dy + ((unsigned char)(offset / 64));

        for(unsigned char p = 0; p < size; p++) {

            gotoxy(x, y);
            x++;
            if(p==0) {
                printf("%c", 108);
            } else {
                printf("%c", 121);
            }
            if(!(x % 64)) {
                y+=1;
                x=0;
            }
            
        }

		index = vera_heap_get_next(s, index);
        if(++count > heap_count && index!=end_index) {
            gotoxy(veraheap_dx, veraheap_dy++);
            printf("ABORT i: %03x e:%03x, l:%03x, c=%x, hc=%x, b=%x\n", index, end_index, list, count, heap_count, bank_get_bram());
            break;
        }

	} while (index != end_index);

    
    bank_pull_bram();

}


/**
 * @brief Print an index list.
 * 
 * @param prefix The chain code.
 * @param list The index list with packed next and prev pointers.
 */
void vera_heap_dump_index_print(vera_heap_segment_index_t s, char prefix, vera_heap_index_t list, unsigned int heap_count)
{

	if (list == VERAHEAP_NULL) return;
	vera_heap_index_t index = list;	
    vera_heap_index_t prev_index = list;
	vera_heap_index_t end_index = list;

    unsigned count = 0;

	do {
        gotoxy(veraheap_dx, veraheap_dy++);
		printf("%03x %c%c ", index, prefix, (vera_heap_is_free(s, index)?'*':' '));
		printf("%x%04x %05x  ", vera_heap_data_get_bank(s, index), vera_heap_data_get_offset(s, index), vera_heap_get_size(s, index));
		printf("%03x  %03x  ", vera_heap_get_next(s, index), vera_heap_get_prev(s, index));
		printf("%03x  %03x  ", vera_heap_get_left(s, index), vera_heap_get_right(s, index));
		index = vera_heap_get_next(s, index);
        if(++count > heap_count && index!=end_index) {
            gotoxy(veraheap_dx, veraheap_dy++);
            printf("ABORT i: %03x e:%03x, l:%03x\n", index, end_index, list);
            break;
        }
        prev_index = index;
	} while (index != end_index);
}


/**
 * @brief Print the heap memory manager statistics of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
void vera_heap_dump_stats(vera_heap_segment_index_t s)
{
    gotoxy(veraheap_dx, veraheap_dy++);
	printf("size  heap:%05x  free:%05x", vera_heap_alloc_size(s), vera_heap_free_size(s));
    gotoxy(veraheap_dx, veraheap_dy++);
	printf("count  heap:%04u  free:%04u  idle:%04u", vera_heap_alloc_count(s), vera_heap_free_count(s), vera_heap_idle_count(s));
    gotoxy(veraheap_dx, veraheap_dy++);
	printf("list   heap:%03x   free:%03x   idle:%03x", vera_heap_segment.heap_list[s], vera_heap_segment.free_list[s], vera_heap_segment.idle_list[s]);
}

/**
 * @brief Ddump the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
void vera_heap_dump_index(vera_heap_segment_index_t s)
{
	bram_bank_t bank_old = bank_get_bram();

    bank_set_bram(vera_heap_segment.bram_bank);


    gotoxy(veraheap_dx, veraheap_dy++);
    printf("#   T  OFFS  SIZE   N    P    L    R");
    gotoxy(veraheap_dx, veraheap_dy++);
    printf("--- -  ----- -----  ---  ---  ---  ---");
	vera_heap_dump_index_print(s, 'I', vera_heap_segment.idle_list[s], vera_heap_segment.idleCount[s]);
	vera_heap_dump_index_print(s, 'F', vera_heap_segment.free_list[s], vera_heap_segment.freeCount[s]);
	vera_heap_dump_index_print(s, 'H', vera_heap_segment.heap_list[s], vera_heap_segment.heapCount[s]);

    bank_set_bram(bank_old);
}

void vera_heap_dump_xy(unsigned char x, unsigned char y) 
{
    veraheap_dx = x;
    veraheap_dy = y;
}

/**
 * @brief Print the heap memory manager statistics and dump the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
void vera_heap_dump(vera_heap_segment_index_t s, unsigned char x, unsigned char y)
{
    vera_heap_dump_xy(x, y);

	vera_heap_dump_stats(s);
	vera_heap_dump_index(s);
}

/**
 * @brief Return if there is free memory according to the requested size.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @param size_requested The requested size in uint16 format.
 * @return bool indicating if there is free memory or not.
 */
inline bool vera_heap_has_free(vera_heap_segment_index_t s, vera_heap_size_int_t size_requested)
{
    bank_push_set_bram(vera_heap_segment.bram_bank);

	// Adjust given size to 8 bytes boundary (shift right with 3 bits).
	vera_heap_size_packed_t packed_size = vera_heap_alloc_size_get(size_requested);

    vera_heap_index_t free_index = vera_heap_find_best_fit(s, packed_size);
    bool has_free = free_index != VERAHEAP_NULL;

    bank_pull_bram();
    
    return has_free;
}


/**
 * @brief Return the size of free heap of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_size_large
 */
vera_heap_size_t vera_heap_free_size(vera_heap_segment_index_t s)
{
	vera_heap_size_packed_t freeSize = vera_heap_segment.freeSize[s];
	return (vera_heap_size_t)vera_heap_size_unpack(freeSize);
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
	vera_heap_size_packed_t heapSize = vera_heap_segment.heapSize[s];
	return (vera_heap_size_t)vera_heap_size_unpack(heapSize);
}

/**
 * @brief Return the amount of heap records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
unsigned int vera_heap_alloc_count(vera_heap_segment_index_t s)
{
	return vera_heap_segment.heapCount[s];
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

