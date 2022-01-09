/**
 * @file cx16-heap.c
 * @author Sven Van de Velde (sven.van.de.velde@outlook.com)
 * @brief Commander x16 memory manager.
 * @version 0.1
 * @date 2021-12-26
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <cx16-heap.h>
#include <cx16-veralib.h>

struct HEAP_SEGMENT heap_segments[16];

inline void heap_bram_bank_set(heap_bank bank) {
	cx16_bram_bank_set(bank);
}

inline heap_bank heap_bram_bank_get() {
	return cx16_bram_bank_get();
}

/**
 * @brief Create a packed banked ram pointer from an 8 bit bank and 16 bit pointer, which is compressed in a 2 byte word.  
 * The returned address is aligned to 8 bytes in bram, and holds the pointer in 64 banks.  
 * So remember the loss of precision:  
 *   - The 8 bit bank is compressed to 6 bits. The 2 upper bits of the bank are discarded.
 *   - The 13 bit pointer between 0xA000 and 0xBFFF is compressed to a 10 bit pointer!
 * 
 * @param bank The 8 bit bank.
 * @param ptr The 16 bit pointer in banked ram between 0xA000 and 0xBFFF.
 * @return heap_bram_packed 
 */
inline heap_bram_packed heap_bram_pack(heap_bank bank, heap_ptr ptr) {
	return (heap_bram_packed)bank << 10 + ((heap_bram_packed)(ptr-0xA000) >> 3);
}

/**
 * @brief Return from a packed banked ram pointer the embedded bank in an 8-bit byte.
 * 
 * @param bram_packed The packed banked ram pointer.
 * @return heap_bank The 8 bit bank.
 */
inline heap_bank heap_bram_unpack_bank(heap_bram_packed bram_packed) {
    return (heap_bank)BYTE1(bram_packed) >> 2;
}

/**
 * @brief Return from a packed banked ram pointer the 16 bit address, but is now aligned to 8 bytes in memory space! (due to the loss of precision).
 * 
 * @param bram_packed The packed banked ram pointer.
 * @return heap_ptr The 16 bit pointer, pointing to a location in banked ram between 0xA000 and 0xBFFF.
 */
inline heap_ptr heap_bram_unpack_ptr(heap_bram_packed bram_packed) {
    return (heap_ptr)((bram_packed << 3 ) & 0x1FFF ) + 0xA000;
}

/**
 * @brief Create a packed vera ram pointer from an 8 bit bank and 16 bit offset, which is compressed in a 2 byte word.  
 * The returned address is aligned to 2 bytes in vram in 2 banks.  
 * So remember the loss of precision:  
 *   - The 1 bit bank is stored in bit 16 of the packed address.
 *   - The 16 bit offset from 0x0000 till 0xFFFF is 1x shifted to the right to a 15 bit offset, aligning to 2 bytes in vram.
 * 
 * @param bank The 1 bit bank in vram. 
 * @param offset The 16 bit offset in vram.
 * @return heap_vram_packed The packed vera ram address.
 */
inline heap_vram_packed heap_vram_pack(heap_bank bank, heap_vram_offset offset) {
    return (heap_vram_packed)bank << 13 + (heap_vram_packed)(offset) >> 3;
}

/**
 * @brief Return from a packed vera ram address the embedded bank in an 8-bit byte.
 * 
 * @param vram_packed The packed vera ram address.
 * @return heap_bank The 8 bit bank.
 */
inline heap_bank heap_vram_unpack_bank(heap_vram_packed vram_packed) {
    return (heap_bank)BYTE1(vram_packed) >> 5;
}

/**
 * @brief Return from a packed vera ram address the 16 bit offset, but is now aligned to 2 bytes in vera ram! (due to the loss of precision).
 * 
 * @param bram_packed The packed vera ram address.
 * @return heap_vram_offset The 16 bit offset, pointing to a location in vera ram between 0x0000 and 0xFFFF in a bank.
 */
inline heap_vram_offset  heap_vram_unpack_offset(heap_vram_packed vram_packed) {
    return (heap_vram_offset)vram_packed << 3;
}

/**
 * @brief 
 * 
 * @param size 
 * @return heap_size_packed 
 */
inline heap_size_packed heap_size_pack(heap_size_large size) {
    return (heap_size_packed)(size >> 3);
}

/**
 * @brief 
 * 
 * @param size_packed 
 * @return heap_size 
 */
inline heap_size heap_size_unpack(heap_size_packed size_packed) {
    return (heap_size)size_packed << 3;
}

/**
* Get header pointer and bank in bram.
*/
inline heap_index_ptr heap_get(heap_handle handle) {

	byte bank = heap_bram_unpack_bank(handle);
	heap_bram_bank_set(bank);
	return (heap_index_ptr)heap_bram_unpack_ptr(handle);
}

/**
* Get data handle packed without resetting the banks.
*/
inline heap_handle heap_data_packed_get(heap_handle heapIndex) {

	// printf("handle = %x\n", handle);
	return ((heap_index_ptr)heap_get(heapIndex))->data;
}

/**
* Set data handle packed without resetting the banks.
*/
inline void heap_data_packed_set(heap_handle heapIndex, heap_handle data) {

	((heap_index_ptr)heap_get(heapIndex))->data = data;
}

/**
* Get data handle.
*/
heap_handle heap_data_get(heap_handle heapIndex) {

	heap_bank old_bank = heap_bram_bank_get();
	heap_handle data_handle = heap_data_packed_get(heapIndex);
	heap_bram_bank_set(old_bank);
	return data_handle;
}



/**
* Get data header pointer and bank or prepare vera registers.
*/
heap_bank heap_data_bank(heap_handle handle) {

	heap_bank old_bank = heap_bram_bank_get();
	// printf("handle = %x\n", handle);
	heap_handle data_handle = heap_data_packed_get(handle);
	heap_index_info header_info = ((heap_index_ptr)heap_get(handle))->size;
	header_info &= heap_type_mask;
	heap_bram_bank_set(old_bank);

	// Data blocks in bram or in vram are handled differently.
	// We only need to bank if the data is in bram, otherwise the programmer will handle it.
	//printf("heap_data_bank: header info = %x\n", header_info);
	if(header_info == heap_type_bram) {
		// return the bank of the data handle, which is expressed in bram format.
		return heap_bram_unpack_bank(data_handle);
	} else {
		// return the bank of the data handle, which is expressed in vram format.
		return heap_vram_unpack_bank(data_handle);
	}

}

/**
* Get data header pointer and bank or prepare vera registers.
*/
heap_ptr heap_data_ptr(heap_handle handle) {

	heap_handle data_handle = heap_data_packed_get(handle);
	heap_index_info header_info = ((heap_index_ptr)heap_get(handle))->size;
	header_info &= heap_type_mask;

	// Data blocks in bram or in vram are handled differently.
	// We only need to bank if the data is in bram, otherwise the programmer will handle it.
	if(header_info == heap_type_bram) {
		// heap_bram_bank_set((heap_bank)(>data_handle) >> 2);
		byte bank = heap_bram_unpack_bank(data_handle);
		heap_bram_bank_set(bank);
		return (heap_ptr)heap_bram_unpack_ptr(data_handle);
	} else {
		return (heap_ptr)heap_vram_unpack_offset(data_handle);
	}
}

/**
 * @brief Get data list pointer.
 * Bank and return pointer to data list structure.
 * The first 2 elements of the data struct are a next and prev heap_handle.
 * 
 * @param handle The handle of the memory block. 
 * @return heap_data_list_ptr 
 */
heap_data_list_ptr heap_data_list_get(heap_handle handle) {
	return (heap_data_list_ptr)heap_data_ptr(handle);
}

/**
* Set the next handle in the index block to the next header block.
*/
void heap_next_set(heap_handle handle, heap_handle next) {

		heap_index_ptr header_ptr = ((heap_index_ptr)heap_get(handle));
		header_ptr->next = next;
}

/**
* Set the prev handle in the index block to the next header block.
*/
void heap_prev_set(heap_handle handle, heap_handle prev) {

		heap_index_ptr header_ptr = ((heap_index_ptr)heap_get(handle));
		header_ptr->prev = prev;
}


/**
* Get the next handle in the index block.
*/
heap_handle heap_next_get(heap_handle handle) {

		return ((heap_index_ptr)heap_get(handle))->next;
}

/**
* Get the prev handle in the index block.
*/
heap_handle heap_prev_get(heap_handle handle) {

		return ((heap_index_ptr)heap_get(handle))->prev;
}

/**
* Set the packed size of a heap memory block.
*/
inline void heap_size_packed_set(heap_handle heapIndex, heap_size_packed size) {
	heap_index_ptr index_ptr = ((heap_index_ptr)heap_get(heapIndex));
	heap_index_info header_info = index_ptr->size;
	header_info &= ~heap_size_mask;
	size |= header_info;
	index_ptr->size = size;
}

/**
* Get the packed size of a heap memory block.
*/
inline heap_size_packed heap_size_packed_get(heap_handle heapIndex) {
	return (heap_size_packed)(((heap_index_ptr)heap_get(heapIndex))->size) & heap_size_mask;
}


/**
* Get the size of a heap memory block.
*/
heap_size_packed heap_size_get(heap_handle heapIndex) {
	char oldbank = heap_bram_bank_get();
	heap_size_packed size = heap_size_packed_get(heapIndex) << 3;
	heap_bram_bank_set(oldbank);
	return size;
}

/**
 * Search index for occurrance.
 */
heap_handle heap_index_find(heap_handle list, heap_handle index) {

	heap_handle anchor = list;
	heap_handle end = list;

	do {
		// O(n) search.
		heap_handle data = heap_data_packed_get(anchor); 
		if (index != data) {
			anchor = ((heap_index_ptr)heap_get(anchor))->next;
			continue;
		}

		// Found the occurrance:
		return anchor;
	} while (anchor != end);

	return 0;
}

/**
* Insert index in list at sorted position.
*/
heap_handle heap_list_insert_at(heap_handle *list, heap_handle index, heap_handle at) {

	// Missing ASM fragment Fragment not found _deref_pwuz1_neq_vwuc1_then_la1. Attempted variations _deref_pwuz1_neq_vwuc1_then_la1 _deref_pwuz1_neq_vduc1_then_la1 _deref_pwuz1_neq_vdsc1_then_la1
	// if (*list == 0xffff) {
	if (!(*list)) {
		// empty list
		*list = index;
		((heap_index_ptr)heap_get(*list))->prev = index;
		((heap_index_ptr)heap_get(*list))->next = index;
	}



	heap_handle prev = ((heap_index_ptr)heap_get(at))->prev;
	heap_handle curr = at;

	// Add index to list at last position.
	((heap_index_ptr)heap_get(index))->prev = prev;
	((heap_index_ptr)heap_get(prev))->next = index;
	((heap_index_ptr)heap_get(index))->next = curr;
	((heap_index_ptr)heap_get(curr))->prev = index;

	heap_handle dataList = heap_data_packed_get(*list);
	heap_handle dataIndex = heap_data_packed_get(index);
	if(dataIndex>dataList) {
		*list = index;
	}

	return index;
}

/**
* Insert index in list at sorted position.
*/
heap_handle heap_list_insert(heap_handle *list, heap_handle index) {

	// Missing ASM fragment Fragment not found _deref_pwuz1_neq_vwuc1_then_la1. Attempted variations _deref_pwuz1_neq_vwuc1_then_la1 _deref_pwuz1_neq_vduc1_then_la1 _deref_pwuz1_neq_vdsc1_then_la1
	// if (*list == 0xffff) {
	if (!(*list)) {
		// empty list
		*list = index;
		((heap_index_ptr)heap_get(*list))->prev = *list;
		((heap_index_ptr)heap_get(*list))->next = *list;
	}

	heap_handle last = ((heap_index_ptr)heap_get(*list))->prev;
	heap_handle first = *list;

	// Add index to list at last position.
	((heap_index_ptr)heap_get(index))->prev = last;
	((heap_index_ptr)heap_get(last))->next = index;
	((heap_index_ptr)heap_get(index))->next = first;
	((heap_index_ptr)heap_get(first))->prev = index;

	heap_handle dataList = heap_data_packed_get(*list);
	heap_handle dataIndex = heap_data_packed_get(index);
	if(dataIndex>dataList) {
		*list = index;
	}

	return index;
}




/**
* Remove header from List
*/
heap_handle heap_list_remove(heap_handle *list, heap_handle index) {

	if (!*list) {
		// empty list
		return -1;
	}

	// The free makes the list empty!
	if (*list == ((heap_index_ptr)heap_get(*list))->next) {
		*list = 0; // We initialize the start of the list to null.
		return 0; 
	}

	// The free changes the first header of the list!
	if (index == *list) { 
		*list = ((heap_index_ptr)heap_get(*list))->next;
	}

	((heap_index_ptr)heap_get(((heap_index_ptr)heap_get(index))->prev))->next = ((heap_index_ptr)heap_get(index))->next;
	((heap_index_ptr)heap_get(((heap_index_ptr)heap_get(index))->next))->prev = ((heap_index_ptr)heap_get(index))->prev;
	return 0;

}

/**
 * @brief Insert data of index in data list maintained by programmer.
 * Note that the first elements of the data must be a 2 byte next handle and a 2 byte prev handle.
 * 
 * @param list A list anchor defined and maintained by the programmer.
 * @param index The handle of the item to be inserted.
 * @return heap_handle 
 */
heap_handle heap_data_list_insert(heap_handle *list, heap_handle index) {

	heap_bank old_bank = heap_bram_bank_get();

	if (!(*list)) {
		// empty list
		*list = index;
		((heap_data_list_ptr)heap_data_list_get(*list))->prev = *list;
		((heap_data_list_ptr)heap_data_list_get(*list))->next = *list;
		heap_bram_bank_set(old_bank);
		return index;
	}

	heap_handle last = ((heap_data_list_ptr)heap_data_list_get(*list))->prev;
	heap_handle first = *list;

	// Add index to list at last position.
	((heap_data_list_ptr)heap_data_list_get(index))->prev = last;
	((heap_data_list_ptr)heap_data_list_get(index))->next = first;
	((heap_data_list_ptr)heap_data_list_get(last))->next = index;
	((heap_data_list_ptr)heap_data_list_get(first))->prev = index;

	// heap_handle dataList = heap_data_packed_get(*list);
	// heap_handle dataIndex = heap_data_packed_get(index);
	// if(dataIndex>dataList) {
	// 	*list = index;
	// }

	heap_bram_bank_set(old_bank);

	return index;
}

heap_handle heap_data_list_remove(heap_handle *list, heap_handle index) {

	heap_bank old_bank = heap_bram_bank_get();

	if (!*list) {
		// empty list
		heap_bram_bank_set(old_bank);
		return 0;
	}

	// The free makes the list empty!
	heap_handle next = ((heap_data_list_ptr)heap_data_list_get(*list))->next;
	heap_handle curr = *list;
	if (next == curr) {
		*list = 0; // We initialize the start of the list to null.
		heap_bram_bank_set(old_bank);
		return 0; 
	}

	// The free changes the first header of the list!
	if (index == curr) { 
		*list = next;
	}


	heap_handle next_index = ((heap_data_list_ptr)heap_data_list_get(index))->next;
	heap_handle prev_index = ((heap_data_list_ptr)heap_data_list_get(index))->prev;

	((heap_data_list_ptr)heap_data_list_get(prev_index))->next = next_index;
	((heap_data_list_ptr)heap_data_list_get(next_index))->prev = prev_index;

	heap_bram_bank_set(old_bank);

	return next_index;
}


heap_handle heap_heap_insert(struct HEAP_SEGMENT* s, heap_handle heapIndex, heap_size_packed size) {
	heap_list_insert(&s->heapList, heapIndex);
	heap_size_packed_set(heapIndex, size & heap_size_mask);
	s->heapCount++;
	return heapIndex;
}

heap_handle heap_heap_insert_at(struct HEAP_SEGMENT* s, heap_handle heapIndex, heap_handle at, heap_size_packed size) {
	heap_list_insert_at(&s->heapList, heapIndex, at);
	heap_size_packed_set(heapIndex, size & heap_size_mask);
	s->heapCount++;
	return heapIndex;
}

heap_handle heap_heap_remove(struct HEAP_SEGMENT* s, heap_handle heapIndex) {
	s->heapCount--;
	return heap_list_remove(&s->heapList, heapIndex);
}

heap_handle heap_free_insert(struct HEAP_SEGMENT* s, heap_handle freeIndex, heap_handle data, heap_size_packed size) {
	heap_list_insert(&s->freeList, freeIndex);
	heap_data_packed_set(freeIndex, data);
	heap_size_packed_set(freeIndex, size);
	s->freeCount++;
	return freeIndex;
}

heap_handle heap_free_remove(struct HEAP_SEGMENT* s, heap_handle freeIndex) {
	s->freeCount--;
	return heap_list_remove(&s->freeList, freeIndex);
}

heap_handle heap_idle_insert(struct HEAP_SEGMENT* s, heap_handle Index) {
	heap_list_insert(&s->idleList, Index);
	heap_data_packed_set(Index, 0);
	heap_size_packed_set(Index, 0);
	s->idleCount++;
	return Index;
}

heap_handle heap_idle_remove(struct HEAP_SEGMENT* s, heap_handle Index) {
	s->idleCount--;
	return heap_list_remove(&s->idleList, Index);
}




/**
 * Returns total allocation size, aligned to 8 bytes;
 */
inline heap_size_packed heap_alloc_size_get(heap_size size) {
	return (heap_size_packed)((size - 1) >> 3) + 1;
}


heap_handle heap_index_add(struct HEAP_SEGMENT* s) {

	// TODO: Search idle list.

	heap_handle index = s->idleList;

	if(index) {
		heap_idle_remove(s, index);
	} else {

		// The current header gets the current heap position handle.
		index = s->HeaderPosition;

		// We adjust to the next header position.
		// Missing ASM fragment Fragment not found _deref_pwuc1=_deref_pwuc1_plus_1. Attempted variations _deref_pwuc1=_deref_pwuc1_plus_1
		// s->HeaderPosition += 1; // add 8 aligned bytes
		heap_handle HeaderPosition = s->HeaderPosition;
		HeaderPosition += 1; 
		s->HeaderPosition = HeaderPosition; // add 8 aligned bytes 
	}

	// TODO: out of memory check.

	return index;
}


heap_handle heap_header_add(struct HEAP_SEGMENT* s, heap_size_packed size) {


	// Add a new index.
	heap_handle index = heap_index_add(s);

	// Decrease the current heap position handle with the size needed to be newly allocated.
	heap_handle heap_position = s->HeapPosition;
	heap_position -= size;
	s->HeapPosition = heap_position;

	// The data handle of the header gets appointed with the current heap position handle.
	heap_data_packed_set(index, s->HeapPosition);
	heap_heap_insert(s, index, size);

	// We fill out the header info with the type of heap, and the size information of the heap data.
	heap_index_info header_info = s->HeapType; // We add the heaptype to validate at each header block move the type of heap we are dealing with.
	header_info |= size;
	((heap_index_ptr)heap_get(index))->size = header_info;

	return index;
}

/**
 * Splits the header on two, returns the pointer to the smaller sub-header.
 */
heap_handle heap_header_split(struct HEAP_SEGMENT* s, heap_handle freeHeap, heap_size_packed size) {

	heap_handle heapIndex = heap_index_add(s);
	heap_handle freeIndex = heap_index_add(s);

	// printf("Split: freeHeap = %x\n", freeHeap);
	// Add the freeBlock to the freeList
	heap_handle dataIndex = heap_data_packed_get(freeHeap);
	heap_size_packed sizeHeap = heap_size_packed_get(freeHeap);
	heap_data_packed_set(heapIndex, dataIndex);
	heap_heap_insert_at(s, heapIndex, ((heap_index_ptr)heap_get(freeHeap))->next, size);

	heap_data_packed_set(freeHeap, dataIndex + size);

	heap_size_packed sizeFree = sizeHeap - size;
	heap_free_insert(s, freeIndex, freeHeap, sizeFree);
	heap_size_packed_set(freeHeap, sizeFree);

	return heapIndex;
}

/**
 * Whether the free memory block can be split. 
 * A spllit can occur when the free memory block is larger than the required size to be allocated.
 */
heap_size_packed heap_header_can_split(heap_handle freeHeap, heap_size_packed sizeRequired) {
	heap_size_packed sizeFree = heap_size_packed_get(freeHeap);
	return sizeFree - sizeRequired;
}

/**
 * Allocates a header from the list, splitting if needed.
 */
heap_handle heap_header_list_allocate(struct HEAP_SEGMENT* s, heap_handle freeHeap, heap_size_packed sizeRequired) {


	// Split the larger header, reusing the free part.
	if (heap_header_can_split(freeHeap, sizeRequired)) {
		freeHeap = heap_header_split(s, freeHeap, sizeRequired);
	}

	heap_size_packed_set(freeHeap, sizeRequired);

	return freeHeap;
}




/**
 * First-fit algorithm.
 */
heap_handle heap_header_find_free(struct HEAP_SEGMENT* s, heap_size_packed sizeRequired) {

	if (!s->freeList) {
		return 0;
	}

	heap_handle freeIndex = s->freeList;
	heap_handle end = s->freeList;

	do {

		// O(n) search.
		heap_size_packed freeSize = heap_size_packed_get(freeIndex);
		if (freeSize < sizeRequired) {
			freeIndex = ((heap_index_ptr)heap_get(freeIndex))->next;
			continue;
		}

		// Found the header:
		// printf("Found FreeIndex = %x, size = %x, block_size = %x\n", freeIndex, size, block_size);
		heap_handle freeHeap = heap_data_packed_get(freeIndex);

		// Clean Free Index
		heap_free_remove(s, freeIndex);
		heap_idle_insert(s, freeIndex);
	
		return heap_header_list_allocate(s, freeHeap, sizeRequired);
	} while (freeIndex != end);

	return 0;
}

/**
 * Coalesces two adjacent blocks to the left.
 * The free header remains free, and the header to the left becomes unused.
 */
heap_handle heap_coalesce_low(struct HEAP_SEGMENT* s, heap_handle freeIndex, heap_handle index) {

	heap_handle freeHeap = heap_data_packed_get(freeIndex);

	heap_size_packed sizeFree = heap_size_packed_get(freeHeap);
	heap_handle data = heap_data_packed_get(freeHeap);
	heap_handle lowdata = heap_data_packed_get(index);
	// Detach freeBlock from freeList and add to idleList.
	heap_free_remove(s, freeIndex);
	heap_idle_insert(s, freeIndex);
	heap_heap_remove(s, freeHeap);
	heap_idle_insert(s, freeHeap);

	heap_size_packed_set(index, heap_size_packed_get(index) + sizeFree);

	heap_data_packed_set(index, data);

	// printf("coalesce low: lowdata = %x, data = %x, freeIndex = %x, index = %x\n", lowdata, data, freeIndex, index);

	return freeHeap;
}

/**
 * Coalesces two adjacent blocks to the right.
 * The free header remains free, and the header to the right becomes unused.
 */
heap_handle heap_coalesce_high(struct HEAP_SEGMENT* s, heap_handle index, heap_handle freeIndex) {

	heap_handle freeData = heap_data_packed_get(freeIndex);

	heap_handle sizeFree = heap_size_packed_get(freeData);

	heap_handle data = heap_data_packed_get(freeData);
	heap_handle lowdata = heap_data_packed_get(index);

	// Detach freeBlock from freeList and add to unusedList.
	heap_heap_remove(s, freeData);
	heap_idle_insert(s, freeData);
	heap_free_remove(s, freeIndex);
	heap_idle_insert(s, freeIndex);

	heap_size_packed_set(index, heap_size_packed_get(index) + sizeFree);

	// printf("coalesce high: lowdata = %x, data = %x, freeIndex = %x, index = %x\n", lowdata, data, freeIndex, index);

	return index;
}

/**
 * Whether we should merge this header to the left.
 */
heap_handle heap_can_coalesce_low(struct HEAP_SEGMENT* s, heap_handle index) {

	heap_handle next = ((heap_index_ptr)heap_get(index))->next;
	heap_handle free = heap_index_find(s->freeList, next);


	if(free) {
		heap_handle data = heap_data_packed_get(next);
		heap_handle size = heap_size_packed_get(next);
		if(heap_data_packed_get(index) == data+size) {
			return free;
		}
	}

	return 0;
}

/**
 * Whether we should merge this header to the right.
 */
heap_handle heap_can_coalesce_high(struct HEAP_SEGMENT* s, heap_handle index) {

	heap_handle prev = ((heap_index_ptr)heap_get(index))->prev;
	heap_handle free = heap_index_find(s->freeList, prev);

	if(free) {
		heap_handle data = heap_data_packed_get(index);
		heap_handle size = heap_size_packed_get(index);
		if(heap_data_packed_get(prev) == data+size) {
			return free;
		}
	}

	return 0;
}


/**
 * Tries to find a header that fits.
 */
heap_handle heap_header_find(struct HEAP_SEGMENT* s, heap_size_packed size) {
	return heap_header_find_free(s, size);
}

// Initialize the segment.
void heap_segment_init(struct HEAP_SEGMENT* s) {
    s->freeList = 0;
	s->idleList = 0;
	s->heapList = 0;

	s->heapCount = 0;
	s->heapSize = 0;
	s->freeCount = 0;
	s->freeSize = 0;
	s->idleCount = 0;
}


/**
 * @brief Create a heap segment in cx16 banked ram.
 * For the given segment, a value between 0 and 15, define a heap in banked ram.
 * The heapFloorBram defines a packed bram memory address, 
 * which must be declared using the function heap_bram_pack.
 * The size of the heap must be given through heapSizeBram, 
 * but is in heap_size_packed format.
 * Use the function heap_size_pack to declare the size, which can be larger than
 * 0xFFFF.
 * 
 * @example
 *   // Initialize the bram heap for dynamic allocation of the entities.
 *   heap_bram_packed bram_entities = heap_segment_bram( 0,
 *   	heap_bram_pack(1, (heap_ptr)0xA000),
 *   	heap_size_pack( 0x2000 * 20)
 *   );
 * 
 * @param segment 
 * @param heapFloorBram 
 * @param heapSizeBram 
 * @return heap_address 
 */
heap_address heap_segment_bram(
	heap_segment_id segment, 
	heap_bram_packed heapFloorBram,
	heap_size_packed heapSizeBram
	) {

	struct HEAP_SEGMENT* s = &heap_segments[segment];

	s->HeapType = heap_type_bram;

	s->HeapFloor = heapFloorBram;
	s->HeapCeil = heapFloorBram+heapSizeBram;
	s->HeaderFloor = heapFloorBram;
	s->HeaderCeil = heapFloorBram+heapSizeBram; 

	s->HeapSize = heapSizeBram;
	s->HeaderSize = heapSizeBram;

	s->HeaderPosition = s->HeapFloor;
	s->HeapPosition = s->HeapCeil;

	heap_segment_init(s);

	return s->HeapCeil;
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
 * @param segment The segment identifier, a value between 0 and 15.
 * @param heapCeilVram This specifies the top address in vera ram from where the heap
 * will populate downwards. Use the function heap_vram_packed to
 * specify the bank and offset in vera ram. The offset is aligned in
 * vera ram at 8 bytes boundaries.
 * @param heapSizeVram This specifies the size of the heap in vera ram.
 * Note that the size is in packed format, so use the function heap_size_packed to
 * specify the size of the heap.
 * @param indexFloorBram This specifies the floor address in banked ram, from where the index
 * of the heap will populate upwards. Each block in the index is 8 bytes.
 * Typically, one bank in banked ram is used to define the index of the vera heap.
 * @param indexSizeBram This specifies the size in banked ram to be reserved for the index
 * of the heap. Each block in the index is 8 bytes, so in one banked ram bank, there can be
 * 1024 heap index blocks administered by the memory manager, which is more than sufficient.
 * @return heap_address 
 */
heap_address heap_segment_vram_ceil(
	heap_segment_id segment, 
	heap_vram_packed heapCeilVram,
	heap_size_packed heapSizeVram,
	heap_bram_packed indexFloorBram,
	heap_size_packed indexSizeBram
	) {

	struct HEAP_SEGMENT* s = &heap_segments[segment];

	s->HeapType = heap_type_vram;

	s->HeapFloor = heapCeilVram-heapSizeVram;
	s->HeapCeil = heapCeilVram;
	s->HeaderFloor = indexFloorBram;
	s->HeaderCeil = indexFloorBram+indexSizeBram; 

	s->HeaderPosition = s->HeaderFloor; // CX16 BANKED RAM HANDLE
	s->HeapPosition = s->HeapCeil; // VERA VRAM HANDLE

	heap_segment_init(s);

	return s->HeapFloor;
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
 * @param segment The segment identifier, a value between 0 and 15.
 * @param heapFloorVram This specifies the bottom address in vera ram from where the heap
 * is defined. Note that the heap will populate downwards, so the heapSizeVram 
 * will define the top address in vera ram. Use the function heap_vram_packed to
 * specify the bank and offset in vera ram. The offset is aligned in
 * vera ram at 8 bytes boundaries.
 * @param heapSizeVram This specifies the size of the heap in vera ram.
 * Note that the size is in packed format, so use the function heap_size_packed to
 * specify the size of the heap.
 * @param indexFloorBram This specifies the floor address in banked ram, from where the index
 * of the heap will populate upwards. Each block in the index is 8 bytes.
 * Typically, one bank in banked ram is used to define the index of the vera heap.
 * @param indexSizeBram This specifies the size in banked ram to be reserved for the index
 * of the heap. Each block in the index is 8 bytes, so in one banked ram bank, there can be
 * 1024 heap index blocks administered by the memory manager, which is more than sufficient.
 * @return heap_address 
 */
heap_address heap_segment_vram_floor(
	heap_segment_id segment, 
	heap_vram_packed heapFloorVram,
	heap_size_packed heapSizeVram,
	heap_bram_packed indexFloorBram,
	heap_size_packed indexSizeBram
	) {

	struct HEAP_SEGMENT* s = &heap_segments[segment];

	s->HeapType = heap_type_vram;

	s->HeapFloor = heapFloorVram;
	s->HeapCeil = heapFloorVram+heapSizeVram;
	s->HeaderFloor = indexFloorBram;
	s->HeaderCeil = indexFloorBram+indexSizeBram; 

	s->HeaderPosition = s->HeaderFloor; // CX16 BANKED RAM HANDLE
	s->HeapPosition = s->HeapCeil; // VERA VRAM HANDLE

	heap_segment_init(s);

	return s->HeapCeil;
}


/**
 * @brief Allocated a specified size of memory on the heap of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @param size Specifies the size of memory to be allocated.
 * Note that the size is aligned to an 8 byte boundary by the memory manager.
 * When the size of the memory block is enquired, an 8 byte aligned value will be returned.
 * @return heap_handle The handle referring to the free record in the index.
 */
heap_handle heap_alloc(heap_segment_id segment, heap_size size) {
	struct HEAP_SEGMENT* s = &heap_segments[segment];

	heap_bank bank_old = heap_bram_bank_get();

	// Adjust given size to 8 bytes boundary (shift right with 3 bits).
	heap_size_packed sizePacked = heap_alloc_size_get(size);

	// Traverse the blocks list, searching for a header of
	// the appropriate size.

	{
		heap_handle index = heap_header_find(s, sizePacked);
		if (index) {
			s->freeSize -= sizePacked;
			return (heap_handle)index;
		}
	}

	// No free heap found, request to map more memory.
	heap_handle heapIndex = heap_header_add(s, sizePacked);
	s->heapSize += sizePacked;

	heap_bram_bank_set(bank_old);

	return (heap_handle)heapIndex;
}

/**
 * @brief Free a memory block from the heap using the handle of allocated memory of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @param handle The handle referring to the heap memory block.
 * @return heap_handle 
 */
heap_handle heap_free(heap_segment_id segment, heap_handle handle) {
	struct HEAP_SEGMENT* s = &heap_segments[segment];

	heap_bank bank_old = heap_bram_bank_get();
	heap_size_packed freeSize = heap_size_packed_get(handle);
	s->freeSize += freeSize;

	{
		heap_handle freeIndex = heap_can_coalesce_low(s, handle);
		// printf("Can coalesce %x low %x\n", freeIndex, index);
		if (freeIndex) {
			heap_coalesce_low(s, freeIndex, handle);
		}
	}


	{
		heap_handle freeIndex = heap_can_coalesce_high(s, handle);
		if (freeIndex) {
			heap_coalesce_high(s, handle, freeIndex);
		}
	}

	heap_handle freeIndex = heap_index_add(s);
	heap_free_insert(s, freeIndex, handle, heap_size_packed_get(handle));

	// *(char*)heap_data_ptr(heap_data_packed_get(handle)) = 0;

	heap_bram_bank_set(bank_old);

	return freeIndex;
}

void heap_print_bram(char prefix, heap_handle list) {

	if (!list) return;
	heap_handle header = list;
	heap_handle end = list;

	do {
		heap_ptr ptr = heap_data_ptr(header);
		heap_size_packed size = heap_size_get(header);
		size = size / 8;
		word wptr = (word)ptr;
		wptr = wptr - 0xA000;
		wptr = wptr / 8;
		for(heap_size_packed p = 0; p<size; p++) {
			byte y = (byte)((wptr+p) / 64);
			byte x = (byte)((wptr+p) % 64);
			gotoxy(63-x,15-y);
			printf("%c", prefix);
		}
		header = ((heap_index_ptr)heap_get(header))->next;
	} while (header != end);
}


/**
 * @brief Print an index list.
 * 
 * @param prefix The chain code.
 * @param list The index list with packed next and prev pointers.
 */
void heap_dump_index_print(char prefix, heap_handle list) {

	if (!list) return;
	heap_handle anchor_index = list;
	heap_handle end_index = list;
	do {
		printf("%c:", prefix);
		printf("%05x[%05x,%06u", anchor_index, heap_data_packed_get(anchor_index), heap_size_get(anchor_index) );
		printf(",%05x,%05x", ((heap_index_ptr)heap_get(anchor_index))->next, ((heap_index_ptr)heap_get(anchor_index))->prev );
		printf("]");
		heap_ptr data = heap_data_ptr(anchor_index);
		for(unsigned int p=0; p<4;p++) {
			printf(" %02x", *((char*)data+p));
		}
		printf("]\n");
		anchor_index = ((heap_index_ptr)heap_get(anchor_index))->next;
	} while (anchor_index != end_index);
}

/**
 * @brief Print the heap memory manager statistics of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
void heap_dump_stats(heap_segment_id segment) {
	struct HEAP_SEGMENT* s = &heap_segments[segment];

	printf("size  alloc:%7u free:%7u\n", heap_alloc_size(segment), heap_free_size(segment));
	printf("count alloc:%4u free:%4u idle:%4u\n", heap_alloc_count(segment), heap_free_count(segment), heap_idle_count(segment));
}

/**
 * @brief Ddump the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
void heap_dump_index(heap_segment_id segment) {
	struct HEAP_SEGMENT* s = &heap_segments[segment];

	printf("list  heap:%05x free:%05x idle:%05x\n", s->heapList, s->freeList, s->idleList);
	heap_dump_index_print('i', s->idleList);
	heap_dump_index_print('f', s->freeList);
	heap_dump_index_print('h', s->heapList);
}

/**
 * @brief Print the heap memory manager statistics and dump the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
void heap_dump(heap_segment_id segment) {
	struct HEAP_SEGMENT* s = &heap_segments[segment];

	heap_dump_stats(segment);
	heap_dump_index(segment);
}

/**
 * @brief Return the size of allocated heap records of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_size_large
 */
heap_size_large heap_free_size(heap_segment_id segment) {
	struct HEAP_SEGMENT* s = &heap_segments[segment];
	heap_size_packed freeSize = s->freeSize;
	return (heap_size_large)freeSize<<3;
}

/**
 * @brief Return the size of allocated heap records of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_size_large 
 */
heap_size_large heap_alloc_size(heap_segment_id segment) {
	struct HEAP_SEGMENT* s = &heap_segments[segment];
	heap_size_packed freeSize = s->freeSize;
	heap_size_packed heapSize = s->heapSize;
	return (heap_size_large)(heapSize-freeSize)<<3;
}

/**
 * @brief Return the amount of heap records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
heap_count heap_alloc_count(heap_segment_id segment) {
	struct HEAP_SEGMENT* s = &heap_segments[segment];
	return s->heapCount - s->freeCount;
}

/**
 * @brief Return the amount of free records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
heap_count heap_free_count(heap_segment_id segment) {
	struct HEAP_SEGMENT* s = &heap_segments[segment];
	return s->freeCount;
}

/**
 * @brief Return the amount of idle records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
heap_count heap_idle_count(heap_segment_id segment) {
	struct HEAP_SEGMENT* s = &heap_segments[segment];
	return s->idleCount;
}
