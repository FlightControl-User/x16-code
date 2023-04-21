/**
 * @file cx16-bankheap.c
 * @author Sven Van de Velde (sven.van.de.velde@outlook.com)
 * @brief Commander x16 memory manager of the bank ram in the Commander X16.
 * @version 0.1
 * @date 2023-04-20
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#include <cx16.h>

#include <cx16-bramheap.h>

#ifdef BRAM_BRAM_HEAP
#pragma data_seg(BramBramHeap)
#endif
bram_heap_map_t  bram_heap_index; // The heap index is located in BRAM.


#ifdef DATA_BRAM_HEAP
#pragma data_seg(DataBramHeap)
#else
#pragma data_seg(Data)
#endif

bram_heap_segment_t bram_heap_segment; // The segment management is in main memory.

__mem unsigned char bramheap_dx = 0;
__mem unsigned char bramheap_dy = 0;

bram_heap_data_packed_t bram_heap_data_pack(bram_bank_t bram_bank, bram_ptr_t bram_ptr)
{
    return MAKEWORD(bram_bank, 0) | (((unsigned int)bram_ptr & 0x1FFF ) >> 5);
}


bram_heap_data_packed_t bram_heap_get_data_packed(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    return MAKEWORD(bram_heap_index.data1[index],bram_heap_index.data0[index]);
}


bram_bank_t bram_heap_data_get_bank(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    bank_push_bram(); bank_set_bram(bram_heap_segment.bram_bank);
    bram_bank_t bram_bank = bram_heap_index.data1[index];
    bank_pull_bram();
    return bram_bank;
}


bram_ptr_t bram_heap_data_get_offset(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    bank_push_bram(); bank_set_bram(bram_heap_segment.bram_bank);
    bram_ptr_t bram_ptr = (bram_ptr_t)(((unsigned int)bram_heap_index.data0[index] << 5) | 0xA000);
    bank_pull_bram();
    return bram_ptr;
}




void bram_heap_set_data(bram_heap_segment_index_t s, bram_heap_index_t index, bram_bank_t bram_bank, bram_ptr_t bram_ptr)
{
    bram_heap_index.data1[index] = bram_bank;
    bram_heap_index.data0[index] = BYTE0((unsigned int)bram_ptr>>5);
}


void bram_heap_set_data_packed(bram_heap_segment_index_t s, bram_heap_index_t index, bram_heap_data_packed_t data_packed)
{
    bram_heap_index.data1[index] = BYTE1(data_packed);
    bram_heap_index.data0[index] = BYTE0(data_packed);
}

void bram_heap_set_free(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    bram_heap_index.size1[index] |= 0x80;
}


void bram_heap_clear_free(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    bram_heap_index.size1[index] &= 0x7F;
}


bool bram_heap_is_free(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    return (bram_heap_index.size1[index] & 0x80) == 0x80;
}

bram_heap_size_packed_t bram_heap_size_pack(bram_heap_size_t size)
{
    return (bram_heap_size_packed_t)(size >> 5);
}

bram_heap_size_packed_t bram_heap_get_size_packed(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    return MAKEWORD(bram_heap_index.size1[index] & 0x7F, bram_heap_index.size0[index]); // Ignore free flag!
}

bram_heap_size_t bram_heap_size_unpack(bram_heap_size_packed_t size)
{
    return (bram_heap_size_t)size << 5; // free flag is automatically removed
}

bram_heap_size_int_t bram_heap_get_size_int(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    bank_push_bram(); bank_set_bram(bram_heap_segment.bram_bank);
    bram_heap_size_packed_t size = bram_heap_get_size_packed(s, index);
    bank_pull_bram();
    return size << 5;
}

bram_heap_size_t bram_heap_get_size(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    bank_push_bram(); bank_set_bram(bram_heap_segment.bram_bank);
    bram_heap_size_t size_packed = bram_heap_get_size_packed(s, index);
    bram_heap_size_t size = size_packed << 5;
    bank_pull_bram();
    return size;
}

void bram_heap_set_size(bram_heap_segment_index_t s, bram_heap_index_t index, bram_heap_size_t size)
{
    bram_heap_index.data1[index] = (BYTE2(size)>>5 & 0x11111000) | BYTE1(size)>>5;
    bram_heap_index.data0[index] = (BYTE1(size)>>5 & 0x11111000) | BYTE0(size)>>5;
}


void bram_heap_set_size_packed(bram_heap_segment_index_t s, bram_heap_index_t index, bram_heap_size_packed_t size_packed)
{
    bram_heap_index.size1[index] &= bram_heap_index.size1[index] & 0x80;
    bram_heap_index.size1[index] = BYTE1(size_packed) & 0x7F; // Ignore free flag.
    bram_heap_index.size0[index] = BYTE0(size_packed);
}


inline bram_heap_index_t bram_heap_get_next(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    return bram_heap_index.next[index];
}


inline void bram_heap_set_next(bram_heap_segment_index_t s, bram_heap_index_t index, bram_heap_index_t next)
{
    bram_heap_index.next[index] = next;
}


inline bram_heap_index_t bram_heap_get_prev(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    return bram_heap_index.prev[index];
}


inline void bram_heap_set_prev(bram_heap_segment_index_t s, bram_heap_index_t index, bram_heap_index_t prev)
{
    bram_heap_index.prev[index] = prev;
}


inline bram_heap_index_t bram_heap_get_left(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    return bram_heap_index.left[index];
}


inline void bram_heap_set_left(bram_heap_segment_index_t s, bram_heap_index_t index, bram_heap_index_t left)
{
    bram_heap_index.left[index] = left;
}


inline bram_heap_index_t bram_heap_get_right(bram_heap_segment_index_t s, bram_heap_index_t index)
{
    return bram_heap_index.right[index];
}


inline void bram_heap_set_right(bram_heap_segment_index_t s, bram_heap_index_t index, bram_heap_index_t right)
{
    bram_heap_index.right[index] = right;
}


/**
* Insert index in list at sorted position.
*/
bram_heap_index_t bram_heap_list_insert_at(bram_heap_segment_index_t s, bram_heap_index_t list, bram_heap_index_t index, bram_heap_index_t at) {

	if(list == BRAM_HEAP_NULL) {
		// empty list
		list = index;
        bram_heap_set_prev(s, index, index);
        bram_heap_set_next(s, index, index);
	}

    if(at == BRAM_HEAP_NULL) {
        at=list;
    }

	bram_heap_index_t last = bram_heap_get_prev(s, at);
	bram_heap_index_t first = at;

	// Add index to list at last position.
	bram_heap_set_prev(s, index, last);
	bram_heap_set_next(s, last, index);
	bram_heap_set_next(s, index, first);
	bram_heap_set_prev(s, first, index);

	return list;
}



/**
* Remove header from List
*/
bram_heap_index_t bram_heap_list_remove(bram_heap_segment_index_t s, bram_heap_index_t list, bram_heap_index_t index) 
{

	if(list == BRAM_HEAP_NULL) {
		// empty list
		return BRAM_HEAP_NULL;
	}

	// The free makes the list empty!
	if(list == bram_heap_get_next(s, list)) {
		list = 0; // We initialize the start of the list to null.
        bram_heap_set_next(s, index, BRAM_HEAP_NULL);
        bram_heap_set_prev(s, index, BRAM_HEAP_NULL);
		return BRAM_HEAP_NULL; 
	}

    bram_heap_index_t next = bram_heap_get_next(s, index);
    bram_heap_index_t prev = bram_heap_get_prev(s, index);

    // TODO, why can't this be coded in one statement ...
    bram_heap_set_next(s, prev, next);
    bram_heap_set_prev(s, next, prev);

	// The free changes the first header of the list!
	if(index == list) { 
		list = bram_heap_get_next(s, list);
	}

	return list;
}

bram_heap_index_t bram_heap_heap_insert_at(bram_heap_segment_index_t s, bram_heap_index_t heap_index, bram_heap_index_t at, bram_heap_size_packed_t size)
{
	bram_heap_segment.heap_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.heap_list[s], heap_index, at);
    bram_heap_set_size_packed(s, heap_index, size);
	bram_heap_segment.heapCount[s]++;
	return bram_heap_segment.heap_list[s];
}

void bram_heap_heap_remove(bram_heap_segment_index_t s, bram_heap_index_t heap_index) 
{
	bram_heap_segment.heapCount[s]--;
	bram_heap_segment.heap_list[s] = bram_heap_list_remove(s, bram_heap_segment.heap_list[s], heap_index);
}

bram_heap_index_t bram_heap_free_insert(bram_heap_segment_index_t s, bram_heap_index_t free_index, bram_heap_data_packed_t data, bram_heap_size_packed_t size) 
{
	bram_heap_segment.free_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, bram_heap_segment.free_list[s]);
    bram_heap_set_data_packed(s, free_index, data);
    bram_heap_set_size_packed(s, free_index, size);
    bram_heap_set_free(s, free_index);
	bram_heap_segment.freeCount[s]++;
	return bram_heap_segment.free_list[s];
}

void bram_heap_free_remove(bram_heap_segment_index_t s, bram_heap_index_t free_index) {
	bram_heap_segment.freeCount[s]--;
	bram_heap_segment.free_list[s] = bram_heap_list_remove(s, bram_heap_segment.free_list[s], free_index);
    bram_heap_clear_free(s, free_index);
}

bram_heap_index_t bram_heap_idle_insert(bram_heap_segment_index_t s, bram_heap_index_t idle_index) {
	bram_heap_segment.idle_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.idle_list[s], idle_index, bram_heap_segment.idle_list[s]);
    bram_heap_set_data_packed(s, idle_index, 0);
    bram_heap_set_size_packed(s, idle_index, 0);
	bram_heap_segment.idleCount[s]++;
	return bram_heap_segment.idle_list[s];
}

void heap_idle_remove(bram_heap_segment_index_t s, bram_heap_index_t idle_index) {
	bram_heap_segment.idleCount[s]--;
	bram_heap_segment.idle_list[s] = bram_heap_list_remove(s, bram_heap_segment.idle_list[s], idle_index);
}


/**
 * Returns total allocation size, aligned to 8;
 */
/* inline */ bram_heap_size_packed_t bram_heap_alloc_size_get(bram_heap_size_t size) 
{
	return (bram_heap_size_packed_t)((bram_heap_size_pack(size-1) + 1));
}


bram_heap_index_t bram_heap_index_add(bram_heap_segment_index_t s) {

	// TODO: Search idle list.

	bram_heap_index_t index = bram_heap_segment.idle_list[s];

	if(index != BRAM_HEAP_NULL) {
		heap_idle_remove(s, index);
	} else {
		// The current header gets the current heap position handle.
		index = bram_heap_segment.index_position;

		// We adjust to the next index position.
		bram_heap_segment.index_position += 1;
	}

	// TODO: out of memory check.

	return index;
}


bram_heap_index_t bram_heap_heap_add(bram_heap_segment_index_t s, bram_heap_size_packed_t size) {


	// Add a new index.
	bram_heap_index_t index = bram_heap_index_add(s);

	// The data handle of the header gets appointed with the current heap position handle.
    bram_heap_set_data_packed(s, index, bram_heap_segment.heap_offset[s]);
    bram_heap_set_size_packed(s, index, size); // packed size!
	bram_heap_heap_insert_at(s, index, bram_heap_segment.heap_list[s], size); // TODO, not kosher

	// Decrease the current heap position handle with the size needed to be newly allocated.
	bram_heap_data_packed_t heap_offset = bram_heap_segment.heap_offset[s] += size;

	return index;
}

/**
 * The free size matches exactly the required heap size.
 * The free index is replaced by a heap index.
 */
bram_heap_index_t bram_heap_replace_free_with_heap(bram_heap_segment_index_t s, bram_heap_index_t free_index, bram_heap_size_packed_t required_size) {

	bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index);
	bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index);
    bram_heap_index_t free_left = bram_heap_get_left(s, free_index);
    bram_heap_index_t free_right = bram_heap_get_right(s, free_index);

    bram_heap_free_remove(s, free_index);

	bram_heap_index_t heap_index = free_index;
	bram_heap_heap_insert_at(s, heap_index, BRAM_HEAP_NULL, required_size);
    bram_heap_set_data_packed(s, heap_index, free_data);
    bram_heap_set_left(s, heap_index, free_left);
    bram_heap_set_right(s, heap_index, free_right);

#ifdef __BRAM_HEAP_DEBUG
    printf("\n > Replaced free index with heap index %03x size %05x.", heap_index, bram_heap_get_size(s, heap_index));
#endif

	return heap_index;
}

/**
 * Splits the header on two, returns the pointer to the smaller sub-header.
 */
bram_heap_index_t bram_heap_split_free_and_allocate(bram_heap_segment_index_t s, bram_heap_index_t free_index, bram_heap_size_packed_t required_size) {

    // The free block is reduced in size with the required size.
	bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index);
	bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index);
    
    bram_heap_set_size_packed(s, free_index, free_size - required_size);
    bram_heap_set_data_packed(s, free_index, free_data + required_size);

    // We create a new heap block with the required size.
    // The data is the offset in vram.
	bram_heap_index_t heap_index = bram_heap_index_add(s);

    bram_heap_set_data_packed(s, heap_index, free_data);
	bram_heap_heap_insert_at(s, heap_index, BRAM_HEAP_NULL, required_size);

    bram_heap_index_t heap_left = bram_heap_get_left(s, free_index);
    bram_heap_index_t heap_right = free_index;

    bram_heap_set_left(s, heap_index, heap_left);
    // printf("\nright = %03x", heap_right);
    bram_heap_set_right(s, heap_index, heap_right);

    bram_heap_set_right(s, heap_left, heap_index);
    bram_heap_set_left(s, heap_right, heap_index);

    bram_heap_set_free(s, heap_right);
    bram_heap_clear_free(s, heap_left);

#ifdef __BRAM_HEAP_DEBUG
    printf("\n > Split free index %03x size %05x and allocate heap index %03x size %05x.", free_index, bram_heap_get_size(s, free_index), heap_index, bram_heap_get_size(s, heap_index));
#endif

	return heap_index;
}

/**
 * Whether the free memory block can be split. 
 * A spllit can occur when the free memory block is larger than the required size to be allocated.
 */
signed char bram_heap_can_split_free(bram_heap_segment_index_t s, bram_heap_index_t free_index, bram_heap_size_packed_t required_size) {

    bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index);
    if(free_size > required_size) {
#ifdef __BRAM_HEAP_DEBUG
        printf("\n > Can split free index %03x to size %05x, heap size %05x.", free_index, bram_heap_size_unpack(free_size - required_size), bram_heap_size_unpack(required_size));
#endif
        return 1;

    } else {
        if(free_size == required_size) {
#ifdef __BRAM_HEAP_DEBUG
            printf("\n > Can replace free index %03x with heap size %05x.", free_index, bram_heap_size_unpack(required_size));
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
bram_heap_index_t bram_heap_allocate(bram_heap_segment_index_t s, bram_heap_index_t free_index, bram_heap_size_packed_t required_size) 
{
    bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index);

    if(free_size > required_size) {
#ifdef __BRAM_HEAP_DEBUG
        printf("\n > Can split free index %03x to size %05x, heap size %05x.", free_index, bram_heap_size_unpack(free_size - required_size), bram_heap_size_unpack(required_size));
#endif
		return bram_heap_split_free_and_allocate(s, free_index, required_size);
    } else {
        if(free_size == required_size) {
#ifdef __BRAM_HEAP_DEBUG
            printf("\n > Can replace free index %03x with heap size %05x.", free_index, bram_heap_size_unpack(required_size));
#endif
            return bram_heap_replace_free_with_heap(s, free_index, required_size);
        } else {
    	    return BRAM_HEAP_NULL;
        }
    }
}




/**
 * Best-fit algorithm.
 */
bram_heap_index_t bram_heap_find_best_fit(bram_heap_segment_index_t s, bram_heap_size_packed_t requested_size) {

	bram_heap_index_t free_index = bram_heap_segment.free_list[s];

    if(free_index == BRAM_HEAP_NULL) {
        return BRAM_HEAP_NULL;
    }

	bram_heap_index_t free_end = bram_heap_segment.free_list[s];

#ifdef __BRAM_HEAP_DEBUG
    printf(", best fit is ");
#endif

    bram_heap_size_packed_t best_size = 0xFFFF;
    bram_heap_index_t best_index = BRAM_HEAP_NULL;

	do {

		// O(n) search.
		bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index);


		if(free_size >= requested_size && free_size < best_size) {
            best_size = free_size;
            best_index = free_index;
        }

        free_index = bram_heap_get_next(s, free_index);

	} while(free_index != free_end);

#ifdef __BRAM_HEAP_DEBUG
        printf("free index %03x size %05x.", best_index, bram_heap_size_unpack(best_size) );
#endif

    if(requested_size <= best_size) {
        return best_index;
    }

	return BRAM_HEAP_NULL;
}

/**
 * Whether we should merge this header to the left.
 */
bram_heap_index_t bram_heap_can_coalesce_left(bram_heap_segment_index_t s, bram_heap_index_t heap_index) {

    bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index);

    bram_heap_index_t left_index = bram_heap_get_left(s, heap_index);
    bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index);
    bool left_free = bram_heap_is_free(s, left_index);


    if(left_free && (left_offset < heap_offset)) {
#ifdef __BRAM_HEAP_DEBUG
    printf("\n > Left index %02x is free %s with offset %04x\n", left_index, left_free?"true":"false", left_offset);
    printf("\n > Can coalesce to the left with free index %03x.", left_index);
#endif
        return left_index;
    }

#ifdef __BRAM_HEAP_DEBUG
    printf("\n > Cannot coalesce to the left.");
#endif
    return BRAM_HEAP_NULL;
}


/**
 * Whether we should merge this header to the right.
 */
bram_heap_index_t heap_can_coalesce_right(bram_heap_segment_index_t s, bram_heap_index_t heap_index) {

    bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index);

    bram_heap_index_t right_index = bram_heap_get_right(s, heap_index);
    bram_heap_data_packed_t right_offset = bram_heap_get_data_packed(s, right_index);
    bool right_free = bram_heap_is_free(s, right_index);

    if(right_free && (heap_offset < right_offset)) {
#ifdef __BRAM_HEAP_DEBUG
    printf("\n > Right index %02x is free %s with offset %04x\n", right_index, right_free?"true":"false", right_offset);
    printf("\n > Can coalesce to the right with free index %03x.", right_index);
#endif
        return right_index;
    }

    // A free_index is not found, we cannot coalesce.
#ifdef __BRAM_HEAP_DEBUG
    printf("\n > Cannot coalesce to the right.");
#endif
	return BRAM_HEAP_NULL;
}


/**
 * Coalesces two adjacent blocks to the left.
 * The left is a free index and the right is the heap index to be freed.
 * The free index remains free, and the heap to the right stays heap.
 * The free index is returned as the new remaining (free) block.
 */
bram_heap_index_t bram_heap_coalesce(bram_heap_segment_index_t s, bram_heap_index_t left_index, bram_heap_index_t right_index) {

	bram_heap_size_packed_t right_size = bram_heap_get_size_packed(s, right_index);
	bram_heap_size_packed_t left_size = bram_heap_get_size_packed(s, left_index);
    bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index);

    bram_heap_index_t free_left = bram_heap_get_left(s, left_index);
    bram_heap_index_t free_right = bram_heap_get_right(s, right_index);

	// We detach the left index from the free list and add it to the idle list.
	bram_heap_free_remove(s, left_index);
	bram_heap_idle_insert(s, left_index);

    bram_heap_set_left(s, right_index, free_left);
    bram_heap_set_right(s, right_index, free_right);

    bram_heap_set_left(s, free_right, right_index);
    bram_heap_set_right(s, free_left, right_index);

    bram_heap_set_left(s, left_index, BRAM_HEAP_NULL);
    bram_heap_set_right(s, left_index, BRAM_HEAP_NULL);

    bram_heap_set_size_packed(s, right_index, left_size + right_size);
    bram_heap_set_data_packed(s, right_index, left_offset);

    bram_heap_set_free(s, left_index);
    bram_heap_set_free(s, right_index);

#ifdef __BRAM_HEAP_DEBUG
    printf("\n > Coalesce idling index %03x and expanding free index %03x.", left_index, right_index);
#endif

	return right_index;
}



void bram_heap_bram_bank_init(bram_bank_t bram_bank)
{
    bram_heap_segment.bram_bank = bram_bank;
    bram_heap_segment.index_position = 0;
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
bram_heap_segment_index_t bram_heap_segment_init(
    bram_heap_segment_index_t   s,
    bram_bank_t                 bram_bank_floor,
    bram_ptr_t                  bram_ptr_floor,
    bram_bank_t                 bram_bank_ceil,
    bram_ptr_t                  bram_ptr_ceil
	)
{

    // TODO initialize segment to all zero
    bram_heap_segment.bram_bank_floor[s] = bram_bank_floor;
    bram_heap_segment.bram_ptr_floor[s] = bram_ptr_floor;
    bram_heap_segment.bram_bank_ceil[s] = bram_bank_ceil;
    bram_heap_segment.bram_ptr_ceil[s] = bram_ptr_ceil;

    bram_heap_segment.floor[s] = bram_heap_data_pack(bram_bank_floor, bram_ptr_floor);
    bram_heap_segment.ceil[s]  = bram_heap_data_pack(bram_bank_ceil, bram_ptr_ceil);

    bram_heap_segment.heap_offset[s] = 0;

    bram_heap_size_packed_t free_size = bram_heap_segment.ceil[s];
    free_size -= bram_heap_segment.floor[s];

	bram_heap_segment.heapCount[s] = 0;
	bram_heap_segment.freeCount[s] = 0;
	bram_heap_segment.idleCount[s] = 0;

    bram_heap_segment.heap_list[s] = BRAM_HEAP_NULL;
    bram_heap_segment.idle_list[s] = BRAM_HEAP_NULL;
    bram_heap_segment.free_list[s] = BRAM_HEAP_NULL;

	bram_bank_t bank_old = bank_get_bram();
    bank_set_bram(bram_heap_segment.bram_bank);

    bram_heap_index_t free_index = bram_heap_index_add(s);
    free_index = bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, free_index);
    bram_heap_set_data_packed(s, free_index, bram_heap_segment.floor[s]);
    bram_heap_set_size_packed(s, free_index, bram_heap_segment.ceil[s] - bram_heap_segment.floor[s]);
    bram_heap_set_free(s, free_index);
    bram_heap_set_next(s, free_index, free_index);
    bram_heap_set_prev(s, free_index, free_index);

    bram_heap_segment.freeCount[s]++;
    bram_heap_segment.free_list[s] = free_index;
    bram_heap_segment.freeSize[s] = free_size;
    bram_heap_segment.heapSize[s] = 0;
    
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
bram_heap_index_t bram_heap_alloc(bram_heap_segment_index_t s, bram_heap_size_t size) 
{

    bank_push_bram(); bank_set_bram(bram_heap_segment.bram_bank);

	// Adjust given size to 8 bytes boundary (shift right with 3 bits).
	bram_heap_size_packed_t packed_size = bram_heap_alloc_size_get(size);

#ifdef __VERAHEAP_DUMP
    bram_heap_dump(s, 0, 4);
    gotoxy(0, 46);
#endif

#ifdef __BRAM_HEAP_DEBUG
    printf("\n > Allocate segment %02x, size %05x", s, size);
#endif

    bram_heap_index_t heap_index = BRAM_HEAP_NULL;
    bram_heap_index_t free_index = bram_heap_find_best_fit(s, packed_size);

    if(free_index != BRAM_HEAP_NULL) {
        heap_index = bram_heap_allocate(s, free_index, packed_size);

        bram_heap_segment.freeSize[s] -= packed_size;
        bram_heap_segment.heapSize[s] += packed_size;
    } else {
        // No free index found! this means out of memory!
    }


#ifdef __BRAM_HEAP_DEBUG
        printf("\n > returning heap index %03x.\n", heap_index);
#endif

#ifdef __VERAHEAP_DUMP
    bram_heap_dump(s, 40, 4);
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
void bram_heap_free(bram_heap_segment_index_t s, bram_heap_index_t free_index) 
{
    bank_push_bram(); bank_set_bram(bram_heap_segment.bram_bank);

	bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index);

#ifdef __VERAHEAP_DUMP
    bram_heap_dump(s, 0, 4);
    gotoxy(0, 46);
#endif

#ifdef __BRAM_HEAP_DEBUG
    printf("\n > Free index %03x size %05x.", free_index, bram_heap_size_unpack(free_size));
#endif


	bram_heap_data_packed_t free_offset = bram_heap_get_data_packed(s, free_index);

    // TODO: only remove allocated indexes!
	bram_heap_heap_remove(s, free_index);
	bram_heap_free_insert(s, free_index, free_offset, free_size);

    bram_heap_index_t free_left_index = bram_heap_can_coalesce_left(s, free_index);
    if(free_left_index != BRAM_HEAP_NULL) {
        free_index = bram_heap_coalesce(s, free_left_index, free_index);
    } 

    bram_heap_index_t free_right_index = heap_can_coalesce_right(s, free_index);
    if(free_right_index != BRAM_HEAP_NULL) {
        free_index = bram_heap_coalesce(s, free_index, free_right_index);
    }

    #ifdef __VERAHEAP_COLOR_FREE
    bram_heap_size_int_t free_size_coalesced = bram_heap_get_size_int(s, free_index);
    bram_heap_bank_t free_bank_coalesced = bram_heap_data_get_bank(s, free_index);
    bram_heap_bank_t free_offset_coalesced = bram_heap_data_get_offset(s, free_index);
    memset_vram(free_bank_coalesced, free_offset_coalesced, veraheap_color++, free_size_coalesced);
    #endif

#ifdef __BRAM_HEAP_DEBUG
    printf("\n");
#endif

    bram_heap_segment.freeSize[s] += free_size;
    bram_heap_segment.heapSize[s] -= free_size;

#ifdef __VERAHEAP_DUMP
    bram_heap_dump(s, 40, 4);
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
void bram_heap_dump_graphic_print(bram_heap_segment_index_t s, unsigned char veraheap_dx, unsigned char veraheap_dy)
{


    bram_heap_index_t list = bram_heap_segment.heap_list[s];

	if (list == BRAM_HEAP_NULL) {
        return;
    }

    bank_push_bram(); bank_set_bram(bram_heap_segment.bram_bank);

	bram_heap_index_t index = bram_heap_segment.heap_list[s];	
	bram_heap_index_t end_index = bram_heap_segment.heap_list[s];

    unsigned char heap_count = bram_heap_segment.heapCount[s];

    char count = 0;

    gotoxy(veraheap_dx, veraheap_dy++);

	do {

        bram_heap_data_packed_t offset = bram_heap_get_data_packed(s, index);
        offset = offset >> 3;
        bram_heap_size_packed_t size = bram_heap_get_size_packed(s, index);
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

		index = bram_heap_get_next(s, index);
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
void bram_heap_dump_index_print(bram_heap_segment_index_t s, char prefix, bram_heap_index_t list, unsigned int heap_count)
{

	if (list == BRAM_HEAP_NULL) return;
	bram_heap_index_t index = list;	
    bram_heap_index_t prev_index = list;
	bram_heap_index_t end_index = list;

    unsigned count = 0;

	do {
        gotoxy(bramheap_dx, bramheap_dy++);
		printf("%03x %c%c ", index, prefix, (bram_heap_is_free(s, index)?'*':' '));
		printf("%02x%04p %05x  ", bram_heap_data_get_bank(s, index), bram_heap_data_get_offset(s, index), bram_heap_get_size(s, index));
		printf("%03x  %03x  ", bram_heap_get_next(s, index), bram_heap_get_prev(s, index));
		printf("%03x  %03x", bram_heap_get_left(s, index), bram_heap_get_right(s, index));
		index = bram_heap_get_next(s, index);
        if(++count > heap_count && index!=end_index) {
            gotoxy(bramheap_dx, bramheap_dy++);
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
void bram_heap_dump_stats(bram_heap_segment_index_t s)
{
    gotoxy(bramheap_dx, bramheap_dy++);
	printf("size  heap:%05x  free:%05x", bram_heap_alloc_size(s), bram_heap_free_size(s));
    gotoxy(bramheap_dx, bramheap_dy++);
	printf("count  heap:%04u  free:%04u  idle:%04u", bram_heap_alloc_count(s), bram_heap_free_count(s), bram_heap_idle_count(s));
    gotoxy(bramheap_dx, bramheap_dy++);
	printf("list   heap:%03x   free:%03x   idle:%03x", bram_heap_segment.heap_list[s], bram_heap_segment.free_list[s], bram_heap_segment.idle_list[s]);
}

/**
 * @brief Ddump the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
void bram_heap_dump_index(bram_heap_segment_index_t s)
{
	bram_bank_t bank_old = bank_get_bram();

    bank_set_bram(bram_heap_segment.bram_bank);


    gotoxy(bramheap_dx, bramheap_dy++);
    printf("#   T  OFFS  SIZE   N    P    L    R");
    gotoxy(bramheap_dx, bramheap_dy++);
    printf("--- -  ------ -----  ---  ---  ---  ---");
	bram_heap_dump_index_print(s, 'I', bram_heap_segment.idle_list[s], bram_heap_segment.idleCount[s]);
	bram_heap_dump_index_print(s, 'F', bram_heap_segment.free_list[s], bram_heap_segment.freeCount[s]);
	bram_heap_dump_index_print(s, 'H', bram_heap_segment.heap_list[s], bram_heap_segment.heapCount[s]);

    bank_set_bram(bank_old);
}

void bram_heap_dump_xy(unsigned char x, unsigned char y) 
{
    bramheap_dx = x;
    bramheap_dy = y;
}

/**
 * @brief Print the heap memory manager statistics and dump the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
void bram_heap_dump(bram_heap_segment_index_t s, unsigned char x, unsigned char y)
{
    bram_heap_dump_xy(x, y);

	bram_heap_dump_stats(s);
	bram_heap_dump_index(s);
}

/**
 * @brief Return if there is free memory according to the requested size.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @param size_requested The requested size in uint16 format.
 * @return bool indicating if there is free memory or not.
 */
inline bool bram_heap_has_free(bram_heap_segment_index_t s, bram_heap_size_int_t size_requested)
{
    bank_push_set_bram(bram_heap_segment.bram_bank);

	// Adjust given size to 8 bytes boundary (shift right with 3 bits).
	bram_heap_size_packed_t packed_size = bram_heap_alloc_size_get(size_requested);

    bram_heap_index_t free_index = bram_heap_find_best_fit(s, packed_size);
    bool has_free = free_index != BRAM_HEAP_NULL;

    bank_pull_bram();
    
    return has_free;
}


/**
 * @brief Return the size of free heap of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_size_large
 */
bram_heap_size_t bram_heap_free_size(bram_heap_segment_index_t s)
{
	bram_heap_size_packed_t freeSize = bram_heap_segment.freeSize[s];
	return (bram_heap_size_t)bram_heap_size_unpack(freeSize);
}

/**
 * @brief Return the size of allocated heap records of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_size_large 
 */

// TODO - make long
bram_heap_size_t bram_heap_alloc_size(bram_heap_segment_index_t s)
{
	bram_heap_size_packed_t heapSize = bram_heap_segment.heapSize[s];
	return (bram_heap_size_t)bram_heap_size_unpack(heapSize);
}

/**
 * @brief Return the amount of heap records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
unsigned int bram_heap_alloc_count(bram_heap_segment_index_t s)
{
	return bram_heap_segment.heapCount[s];
}

/**
 * @brief Return the amount of free records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
unsigned int bram_heap_free_count(bram_heap_segment_index_t s)
{
	return bram_heap_segment.freeCount[s];
}

/**
 * @brief Return the amount of idle records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
unsigned int bram_heap_idle_count(bram_heap_segment_index_t s)
{
	return bram_heap_segment.idleCount[s];
}

