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

// #pragma data_seg(VeraHeap)
// __address(0xA000) vera_heap_index_t vera_heap_index;
vera_heap_index_t vera_heap_index;
// #pragma data_seg(Data)

vera_heap_segment_t vera_heap_segment;

inline vera_heap_handle_t vera_heap_pack(vram_bank_t vram_bank, vram_offset_t vram_offset)
{
    return MAKEWORD(vram_bank<<5, 0) | (vram_offset>>3);
}


inline vram_offset_t vera_heap_get_data_packed(vera_heap_handle_t index)
{
    return vera_heap_index.data[index];
}


inline vram_bank_t vera_heap_get_bank(vera_heap_handle_t index)
{
    return BYTE1(vera_heap_index.data[index])>>5;
}


inline vram_offset_t vera_heap_get_offset(vera_heap_handle_t index)
{
    return vera_heap_get_data_packed(index) << 3;
}




inline vera_heap_data_packed_t vera_heap_set_data(vera_heap_handle_t index, vram_bank_t vram_bank, vram_offset_t vram_offset)
{
    vera_heap_data_packed_t data_packed = vera_heap_pack(vram_bank, vram_offset);
    vera_heap_index.data[index] = data_packed;
    return data_packed;
}


inline vera_heap_data_packed_t vera_heap_set_data_packed(vera_heap_handle_t index, vera_heap_data_packed_t data_packed)
{
    vera_heap_index.data[index] = data_packed;
    return data_packed;
}

inline void vera_heap_set_free(vera_heap_handle_t index)
{
    vera_heap_handle_t size = vera_heap_index.size[index];
    vera_heap_index.size[index] =  size | 0x8000;
}


inline bool vera_heap_is_free(vera_heap_handle_t index)
{
    vera_heap_handle_t size = vera_heap_index.size[index];
    return (size & 0x8000) == 0x8000;
}

inline vera_heap_size_packed_t vera_heap_get_size_packed(vera_heap_handle_t index)
{
    vera_heap_handle_t size = vera_heap_index.size[index];
    return size & 0x7FFF;
}

inline vera_heap_size_t vera_heap_get_size(vera_heap_handle_t index)
{
    return vera_heap_get_size_packed(index) << 3;
}

inline vera_heap_size_t vera_heap_set_size(vera_heap_handle_t index, vera_heap_size_t size)
{
    vera_heap_index.size[index] = (vera_heap_size_packed_t)(size >> 3);
    return size;
}


inline vera_heap_size_packed_t vera_heap_set_size_packed(vera_heap_handle_t index, vera_heap_size_packed_t size_packed)
{
    vera_heap_index.size[index] = size_packed;
    return size_packed;
}


inline vera_heap_handle_t vera_heap_get_next(vera_heap_handle_t index)
{
    return vera_heap_index.next[index];
}


inline void vera_heap_set_next(vera_heap_handle_t index, vera_heap_handle_t next)
{
    vera_heap_index.next[index] = next;
}


inline vera_heap_handle_t vera_heap_get_prev(vera_heap_handle_t index)
{
    return vera_heap_index.prev[index];
}


inline void vera_heap_set_prev(vera_heap_handle_t index, vera_heap_handle_t prev)
{
    vera_heap_index.prev[index] = prev;
}


inline vera_heap_handle_t vera_heap_get_left(vera_heap_handle_t index)
{
    return vera_heap_index.left[index];
}


inline void vera_heap_set_left(vera_heap_handle_t index, vera_heap_handle_t left)
{
    vera_heap_index.left[index] = left;
}


inline vera_heap_handle_t vera_heap_get_right(vera_heap_handle_t index)
{
    return vera_heap_index.right[index];
}


inline void vera_heap_set_right(vera_heap_handle_t index, vera_heap_handle_t right)
{
    vera_heap_index.right[index] = right;
}


/**
* Insert index in list at sorted position.
*/
vera_heap_handle_t vera_heap_list_insert_at(vera_heap_handle_t list, vera_heap_handle_t index, vera_heap_handle_t at) {

	if(list == VERAHEAP_NULL) {
		// empty list
		list = index;
        vera_heap_set_prev(index, index);
        vera_heap_set_next(index, index);
	}

    if(at==VERAHEAP_NULL) {
        at=list;
    }

	vera_heap_handle_t last = vera_heap_index.prev[at];
	vera_heap_handle_t first = at;

	// Add index to list at last position.
	vera_heap_set_prev(index, last);
	vera_heap_set_next(last, index);
	vera_heap_set_next(index, first);
	vera_heap_set_prev(first, index);

	// vera_heap_handle_t dataList = vera_heap_get_data_packed(list);
	// vera_heap_handle_t dataIndex = vera_heap_get_data_packed(index);

	// if(dataIndex>dataList) {
	// 	list = index;
	// }

	return list;
}



/**
* Remove header from List
*/
vera_heap_handle_t vera_heap_list_remove(vera_heap_handle_t list, vera_heap_handle_t index) {

	if(list == VERAHEAP_NULL) {
		// empty list
		return VERAHEAP_NULL;
	}

	// The free makes the list empty!
	if(list == vera_heap_index.next[list]) {
		list = 0; // We initialize the start of the list to null.
#ifdef VERAHEAP_DEBUG
        printf("list is null\n");
#endif
        vera_heap_set_next(index, VERAHEAP_NULL);
        vera_heap_set_prev(index, VERAHEAP_NULL);
		return VERAHEAP_NULL; 
	}

    vera_heap_handle_t next = vera_heap_index.next[index];
    vera_heap_handle_t prev = vera_heap_index.prev[index];

    // TODO, why can't this be coded in one statement ...
    vera_heap_set_next(prev, next);
    vera_heap_set_prev(next, prev);

	// The free changes the first header of the list!
	if(index == list) { 
		list = vera_heap_index.next[list];
	}

	return list;
}

vera_heap_handle_t vera_heap_heap_insert_at(vera_heap_segment_index_t s, vera_heap_handle_t heapIndex, vera_heap_handle_t at, vera_heap_size_packed_t size) {
	vera_heap_segment.heap_list[s] = vera_heap_list_insert_at(vera_heap_segment.heap_list[s], heapIndex, at);
    vera_heap_set_size_packed(heapIndex, size);
	vera_heap_segment.heapCount[s]++;
	return vera_heap_segment.heap_list[s];
}

void vera_heap_heap_remove(vera_heap_segment_index_t s, vera_heap_handle_t heapIndex) {
	vera_heap_segment.heapCount[s]--;
	vera_heap_segment.heap_list[s] = vera_heap_list_remove(vera_heap_segment.heap_list[s], heapIndex);
}

vera_heap_handle_t vera_heap_free_insert(vera_heap_segment_index_t s, vera_heap_handle_t freeIndex, vera_heap_handle_t data, vera_heap_size_packed_t size) {
	vera_heap_segment.free_list[s] = vera_heap_list_insert_at(vera_heap_segment.free_list[s], freeIndex, vera_heap_segment.free_list[s]);
    vera_heap_set_data_packed(freeIndex, data);
    vera_heap_set_size_packed(freeIndex, size);
    vera_heap_set_free(freeIndex);
	vera_heap_segment.freeCount[s]++;
	return vera_heap_segment.free_list[s];
}

void vera_heap_free_remove(vera_heap_segment_index_t s, vera_heap_handle_t free_index) {
	vera_heap_segment.freeCount[s]--;
	vera_heap_segment.free_list[s] = vera_heap_list_remove(vera_heap_segment.free_list[s], free_index);
}

vera_heap_handle_t vera_heap_idle_insert(vera_heap_segment_index_t s, vera_heap_handle_t index) {
	vera_heap_segment.idle_list[s] = vera_heap_list_insert_at(vera_heap_segment.idle_list[s], index, vera_heap_segment.idle_list[s]);
    vera_heap_set_data_packed(index, 0);
    vera_heap_set_size_packed(index, 0);
	vera_heap_segment.idleCount[s]++;
	return vera_heap_segment.idle_list[s];
}

void heap_idle_remove(vera_heap_segment_index_t s, vera_heap_handle_t Index) {
	vera_heap_segment.idleCount[s]--;
	vera_heap_segment.idle_list[s] = vera_heap_list_remove(vera_heap_segment.idle_list[s], Index);
}


/**
 * Returns total allocation size, aligned to 8;
 */
inline vera_heap_size_packed_t vera_heap_alloc_size_get(vera_heap_size_packed_t size) 
{
	return (vera_heap_size_packed_t)((((size-1) >> 3) + 1));
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
    vera_heap_set_data_packed(index, vera_heap_segment.heap_position[s]);
    vera_heap_set_size_packed(index, size); // packed size!
	vera_heap_heap_insert_at(s, index, vera_heap_segment.heap_list[s], size); // TODO, not kosher

	// Decrease the current heap position handle with the size needed to be newly allocated.
	vera_heap_handle_t heap_position = vera_heap_segment.heap_position[s] += size;

	return index;
}

/**
 * Splits the header on two, returns the pointer to the smaller sub-header.
 */
vera_heap_handle_t vera_heap_header_split(vera_heap_segment_index_t s, vera_heap_handle_t free_index, vera_heap_size_packed_t required_size) {

	// vera_heap_handle_t free_index = vera_heap_index_add(s);

#ifdef VERAHEAP_DEBUG
	printf(" > split: ");
#endif
	// Add the freeBlock to the freeList

    // The free block is reduced in size with the required size.
	vera_heap_size_packed_t free_size = vera_heap_get_size_packed(free_index);
	vera_heap_data_packed_t free_data = vera_heap_get_data_packed(free_index);
    vera_heap_set_size_packed(free_index, free_size - required_size);
    vera_heap_set_data_packed(free_index, vera_heap_get_data_packed(free_index) + required_size);

    // We create a new heap block with the required size.
    // The data is the offset in vram.
	vera_heap_handle_t heap_index = vera_heap_index_add(s);

    // TODO - need to optimize the data and the size in the vera_heap_heap_insert_at call. This is messy.
    vera_heap_set_data_packed(heap_index, free_data);
	vera_heap_heap_insert_at(s, heap_index, VERAHEAP_NULL, required_size);

    vera_heap_handle_t heap_left = vera_heap_get_left(free_index);
    vera_heap_handle_t heap_right = free_index;

    vera_heap_set_left(heap_index, heap_left);
    vera_heap_set_right(heap_index, heap_right);

    vera_heap_set_right(heap_left, heap_index);
    vera_heap_set_left(heap_right, heap_index);

#ifdef VERAHEAP_DEBUG
    printf(" fi=%04x, hi=%04x, fs=%u", free_index, heap_index, free_size);
#endif

	return heap_index;
}

/**
 * Whether the free memory block can be split. 
 * A spllit can occur when the free memory block is larger than the required size to be allocated.
 */
vera_heap_size_packed_t vera_heap_header_can_split(vera_heap_handle_t free_index, vera_heap_size_packed_t required_size) {
	vera_heap_size_packed_t free_size = vera_heap_get_size_packed(free_index);
#ifdef VERAHEAP_DEBUG
    printf("\n > can split: i=%04x, fs=%u, rs=%u", free_index, free_size, required_size);
#endif
	return free_size - required_size;
}

/**
 * Allocates a header from the list, splitting if needed.
 */
vera_heap_handle_t heap_header_list_allocate(vera_heap_segment_index_t s, vera_heap_handle_t free_index, vera_heap_size_packed_t required_size) 
{

	// Split the larger header, reusing the free part.
	if (vera_heap_header_can_split(free_index, required_size)) {
		return vera_heap_header_split(s, free_index, required_size);
	}

	return VERAHEAP_NULL;
}




/**
 * First-fit algorithm.
 */
vera_heap_handle_t vera_heap_alloc_using_free(vera_heap_segment_index_t s, vera_heap_size_packed_t requested_size) {


	vera_heap_handle_t free_index = vera_heap_segment.free_list[s];

    if(free_index == VERAHEAP_NULL) {
        return VERAHEAP_NULL;
    }

	vera_heap_handle_t free_end = vera_heap_segment.free_list[s];

#ifdef VERAHEAP_DEBUG
    printf(" > search fi=%u, rs=%u", free_index, requested_size);
#endif

	do {

		// O(n) search.
		vera_heap_size_packed_t free_size = vera_heap_get_size_packed(free_index);

#ifdef VERAHEAP_DEBUG
        printf(", fs(%u)=%u", free_index, free_size);
#endif

		if (free_size < requested_size) {
			free_index = vera_heap_index.next[free_index];
			continue;
		}

#ifdef VERAHEAP_DEBUG
        printf("\n > found free: fi=%04x, fs=%u", free_index, vera_heap_get_size_packed(free_index));
#endif

        return heap_header_list_allocate(s, free_index, requested_size);
	} while (free_index != free_end);

	return VERAHEAP_ERROR;
}

/**
 * Whether we should merge this header to the left.
 */
vera_heap_handle_t vera_heap_can_coalesce_left(vera_heap_segment_index_t s, vera_heap_handle_t heap_index) {

	vera_heap_handle_t free_index = vera_heap_segment.free_list[s];
	vera_heap_handle_t end_index = vera_heap_segment.free_list[s];

#ifdef VERAHEAP_DEBUG
    printf(" > coa left: hi=%04x, fi=%04x\n", heap_index, free_index);
#endif

    vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(heap_index);

#ifdef VERAHEAP_DEBUG
    printf(" > coa left search: ");
#endif

// We don't need the loop anymore with the left pointer!
// 	do {
// 		// O(n) search.
// 		vera_heap_data_packed_t free_offset = vera_heap_get_data_packed(free_index);
//         vera_heap_size_packed_t free_size = vera_heap_get_size_packed(free_index);
//         free_offset += free_size;
// #ifdef VERAHEAP_DEBUG
//         printf(" > fo=%04x, ho=%04x", free_offset, heap_offset);
// #endif
// 		if (free_offset == heap_offset) {
// #ifdef VERAHEAP_DEBUG
//             printf(" fi=%04x\n", free_index);
// #endif
// 			return free_index;
// 		}
// 		// Found no occurrance:
//         free_index = vera_heap_index.next[free_index];
// 	} while (free_index != end_index);

    vera_heap_handle_t left_index = vera_heap_get_left(heap_index);
    printf(" li=%04x\n", left_index);
    if(vera_heap_is_free(left_index)) 
        return left_index;

    return VERAHEAP_NULL;
}


/**
 * Whether we should merge this header to the right.
 */
vera_heap_handle_t heap_can_coalesce_right(vera_heap_segment_index_t s, vera_heap_handle_t heap_index) {

	vera_heap_handle_t free_index = vera_heap_segment.free_list[s];
	vera_heap_handle_t end_index = vera_heap_segment.free_list[s];

#ifdef VERAHEAP_DEBUG
    printf(" > coa right: hi=%04x, fi=%04x\n", heap_index, free_index);
#endif

    vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(heap_index);
    heap_offset += vera_heap_get_size_packed(heap_index);

// We don't need the loop anymore with the right pointer!
#ifdef VERAHEAP_DEBUG
    printf(" > coa right search: ");
#endif
// 	do {
// 		// O(n) search.
// 		vera_heap_data_packed_t free_offset = vera_heap_get_data_packed(free_index);
// #ifdef VERAHEAP_DEBUG
//         printf(" > fo=%04x, ho=%04x", free_offset, heap_offset);
// #endif
// 		if (free_offset == heap_offset) {
// #ifdef VERAHEAP_DEBUG
//             printf(" fi=%04x\n", free_index);
// #endif
// 			return free_index;
// 		}

// 		// Found no occurrance:
//         free_index = vera_heap_index.next[free_index];
// 	} while (free_index != end_index);


    vera_heap_handle_t right_index = vera_heap_get_right(heap_index);
    printf(" ri=%04x\n", right_index);
    if(vera_heap_is_free(right_index)) 
        return right_index;

    // A free_index is not found, we cannot coalesce.
	return VERAHEAP_NULL;
}


/**
 * Coalesces two adjacent blocks to the left.
 * The left is a free index and the right is the heap index to be freed.
 * The free index remains free, and the heap to the right stays heap.
 * The free index is returned as the new remaining (free) block.
 */
vera_heap_handle_t heap_coalesce_left(vera_heap_segment_index_t s, vera_heap_handle_t left_index, vera_heap_handle_t middle_index) {


#ifdef VERAHEAP_DEBUG
    printf("> coa left: ");
#endif
	vera_heap_handle_t left_offset = vera_heap_get_data_packed(left_index);
	vera_heap_size_packed_t left_size = vera_heap_get_size_packed(left_index);

	vera_heap_size_packed_t middle_size = vera_heap_get_size_packed(middle_index);

    vera_heap_handle_t free_left = vera_heap_get_left(left_index);
    vera_heap_handle_t free_right = vera_heap_get_right(middle_index);

	// Detach freeBlock from freeList and add to idleList.
	vera_heap_free_remove(s, middle_index);
	vera_heap_idle_insert(s, middle_index);

    vera_heap_set_left(left_index, free_left); // Not really needed ...
    vera_heap_set_right(left_index, free_right);

    vera_heap_set_left(free_right, left_index);
    vera_heap_set_right(free_left, left_index);

    vera_heap_set_left(middle_index, VERAHEAP_NULL);
    vera_heap_set_right(middle_index, VERAHEAP_NULL);

#ifdef VERAHEAP_DEBUG
    printf("> removed free, inserted idle \n");
#endif

    vera_heap_set_size_packed(left_index, middle_size + left_size);

	return left_index;
}

/**
 * Coalesces two adjacent blocks to the right.
 * The the middle will remain and the right will be idled after joining.
 * The middle index is returned as the new remaining (free) block.
 */
vera_heap_handle_t heap_coalesce_right(vera_heap_segment_index_t s, vera_heap_handle_t middle_index, vera_heap_handle_t right_index) {

	vera_heap_handle_t right_offset = vera_heap_get_data_packed(right_index);
	vera_heap_handle_t right_size = vera_heap_get_size_packed(right_index);

    vera_heap_handle_t middle_offset = vera_heap_get_data_packed(middle_index);
	vera_heap_handle_t middle_size = vera_heap_get_size_packed(middle_index);

    vera_heap_handle_t free_left = vera_heap_get_left(middle_index);
    vera_heap_handle_t free_right = vera_heap_get_right(right_index);

	// Detach freeBlock from freeList and add to unusedList.
	vera_heap_free_remove(s, right_index);
	vera_heap_idle_insert(s, right_index);

    vera_heap_set_left(middle_index, free_left); // Not really needed ...
    vera_heap_set_right(middle_index, free_right);

    vera_heap_set_left(free_right, middle_index);
    vera_heap_set_right(free_left, middle_index);

    vera_heap_set_left(right_index, VERAHEAP_NULL);
    vera_heap_set_right(right_index, VERAHEAP_NULL);

    vera_heap_set_size_packed(middle_index, middle_size + right_size);

	// printf("coalesce high: lowdata = %x, data = %x, freeIndex = %x, index = %x\n", lowdata, data, freeIndex, index);

	return middle_index;
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
    vera_heap_segment.vram_bank_floor[s] = vram_bank_floor;
    vera_heap_segment.vram_offset_floor[s] = vram_offset_floor;
    vera_heap_segment.vram_bank_ceil[s] = vram_bank_ceil;
    vera_heap_segment.vram_offset_ceil[s] = vram_offset_ceil;

    vera_heap_segment.floor[s] = vera_heap_pack(vram_bank_floor, vram_offset_floor);
    vera_heap_segment.ceil[s]  = vera_heap_pack(vram_bank_ceil, vram_offset_ceil);

    vera_heap_segment.heap_position[s] = 0;
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
    free_index = vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], 0);
    vera_heap_set_data_packed(free_index, vera_heap_segment.floor[s]);
    vera_heap_set_size_packed(free_index, vera_heap_segment.ceil[s] - vera_heap_segment.floor[s]);
    vera_heap_set_next(free_index, 0);
    vera_heap_set_prev(free_index, 0);
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
vera_heap_handle_t vera_heap_alloc(vera_heap_segment_index_t s, vera_heap_size_packed_t size) 
{

	bram_bank_t bank_old = bank_get_bram();

    bank_set_bram(vera_heap_segment.bram_bank);


	// Adjust given size to 8 bytes boundary (shift right with 3 bits).
	vera_heap_size_packed_t requested_size = vera_heap_alloc_size_get(size);

#ifdef VERAHEAP_DEBUG
    printf(" > alloc: rs=%u", requested_size);
#endif

	// Traverse the blocks list, searching for a header of
	// the appropriate size.

    vera_heap_handle_t heap_index = vera_heap_alloc_using_free(s, requested_size);
    if(heap_index != VERAHEAP_NULL) {
#ifdef VERAHEAP_DEBUG
        printf("\n");
#endif
        vera_heap_segment.freeSize[s] -= requested_size;
    } else {
        // No free index found! this means out of memory!
    }

#ifdef VERAHEAP_DEBUG
    vera_heap_dump(s);
#endif
	bank_set_bram(bank_old);

#ifdef VERAHEAP_DEBUG
    while(!getin());
#endif

	return heap_index;
}

/**
 * @brief Free a memory block from the heap using the handle of allocated memory of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @param handle The handle referring to the heap memory block.
 * @return heap_handle 
 */
vera_heap_handle_t vera_heap_free(vera_heap_segment_index_t s, vera_heap_handle_t heap_index) 
{

	vram_bank_t bank_old = bank_get_bram();

    bank_set_bram(vera_heap_segment.bram_bank);

#ifdef VERAHEAP_DEBUG
    vera_heap_dump(s);
#endif

	vera_heap_size_packed_t heap_size = vera_heap_get_size_packed(heap_index);
	vera_heap_handle_t heap_offset = vera_heap_get_data_packed(heap_index);


#ifdef VERAHEAP_DEBUG
    printf("removing heap hi=%04x\n", heap_index);
#endif

	vera_heap_heap_remove(s, heap_index);

#ifdef VERAHEAP_DEBUG
    printf(" > insert free");
#endif
	vera_heap_free_insert(s, heap_index, heap_offset, heap_size);

// #ifdef VERAHEAP_DEBUG
//     vera_heap_dump(s);
//     while(!getin());
// #endif


    vera_heap_handle_t free_left_index = vera_heap_can_coalesce_left(s, heap_index);
    if(free_left_index != VERAHEAP_NULL) {
        heap_index = heap_coalesce_left(s, free_left_index, heap_index);
    } 

// #ifdef VERAHEAP_DEBUG
//     vera_heap_dump(s);
// #endif

    vera_heap_handle_t free_right_index = heap_can_coalesce_right(s, heap_index);
    if(free_right_index != VERAHEAP_NULL) {
        heap_index = heap_coalesce_right(s, heap_index, free_right_index);
    }

    vera_heap_segment.freeSize[s] += heap_size;

#ifdef VERAHEAP_DEBUG
    vera_heap_dump(s);
#endif

	bank_set_bram(bank_old);

#ifdef VERAHEAP_DEBUG
    while(!getin());
#endif

	return heap_index;
}

/*
void heap_print_bram(char prefix, vera_heap_handle_t list) {

	if (list==VERAHEAP_NULL) return;

	vera_heap_handle_t index = list;
	vera_heap_handle_t end = list;

	do {
		heap_ptr ptr = heap_data_ptr(index);
		vera_heap_size_packed_t size = heap_size_get(index);
		size = size / 8;
		word wptr = (word)ptr;
		wptr = wptr - 0xA000;
		wptr = wptr / 8;
		for(vera_heap_size_packed_t p = 0; p<size; p++) {
			byte y = (byte)((wptr+p) / 64);
			byte x = (byte)((wptr+p) % 64);
			gotoxy(63-x,15-y);
			printf("%c", prefix);
		}
		index = vera_heap_index.next[index];
	} while (index != end);
}
*/


#ifdef VERAHEAP_DEBUG


/**
 * @brief Print an index list.
 * 
 * @param prefix The chain code.
 * @param list The index list with packed next and prev pointers.
 */
void vera_heap_dump_index_print(char prefix, vera_heap_handle_t list)
{

	if (list == VERAHEAP_NULL) return;
	vera_heap_handle_t index = list;
	vera_heap_handle_t end_index = list;
	do {
		printf("%03u  %c  ", index, prefix);
		printf("%x%04x  %05x  ", vera_heap_get_bank(index), vera_heap_get_offset(index), vera_heap_get_size(index));
		printf("%02x  %02x  ", vera_heap_get_next(index), vera_heap_get_prev(index));
		printf("%02x  %02x  ", vera_heap_get_left(index), vera_heap_get_right(index));
		printf("\n");
		index = vera_heap_get_next(index);
	} while (index != end_index);
}

/**
 * @brief Print the heap memory manager statistics of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
void vera_heap_dump_stats(vera_heap_segment_index_t s)
{

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

    bank_set_bram(vera_heap_segment.bram_bank);

	printf("list  heap:%04x free:%04x idle:%04x\n", vera_heap_segment.heap_list[s], vera_heap_segment.free_list[s], vera_heap_segment.idle_list[s]);

    printf("#    T  OFFS   SIZE   N   P   L   R   \n");
    printf("---  -  -----  -----  --  --  --  --  \n");
	vera_heap_dump_index_print('I', vera_heap_segment.idle_list[s]);
	vera_heap_dump_index_print('F', vera_heap_segment.free_list[s]);
	vera_heap_dump_index_print('H', vera_heap_segment.heap_list[s]);

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
unsigned int vera_heap_free_size(vera_heap_segment_index_t s)
{
	vera_heap_size_packed_t freeSize = vera_heap_segment.freeSize[s];
	return (unsigned int)freeSize;
}

/**
 * @brief Return the size of allocated heap records of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_size_large 
 */

// TODO - make long
unsigned int vera_heap_alloc_size(vera_heap_segment_index_t s)
{
	vera_heap_size_packed_t freeSize = vera_heap_segment.freeSize[s];
	vera_heap_size_packed_t heapSize = vera_heap_segment.heapSize[s];
	return (unsigned int)(freeSize - heapSize);
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

#endif