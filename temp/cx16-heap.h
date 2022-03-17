/**
 * @file cx16-heap.h
 * @author Sven Van de Velde (sven.van.de.velde@outlook.com)
 * @brief Commander x16 memory manager.
 * @version 0.1
 * @date 2021-12-26
 * 
 * @copyright Copyright (c) 2021
 * 
 */

typedef unsigned int    heap_packed; 		///< Packed pointer to a banked location in various rams.
typedef unsigned int    heap_bram_packed; 	///< Packed pointer to a location in banked ram between A000 and C000.
typedef unsigned int    heap_vram_packed; 	///< Packed pointer to a location in banked vera ram.
typedef unsigned char   heap_bank; 			///< A bank representation for banked ram or banked vera ram.

typedef unsigned int 	heap_address;       ///< Represents an address.
typedef unsigned int 	heap_handle;        ///< Generic handle for heap references.
typedef unsigned int 	heap_size_packed;   ///< The size packed in a word, shifted 3 bits to the right.
typedef unsigned int 	heap_size;          ///< The size in real buytes, max word size.
typedef unsigned long 	heap_size_large;    ///< The size in real buytes, max dword size.
typedef unsigned int 	heap_count;         ///< Counters.
typedef unsigned int 	heap_index_info;
typedef unsigned char* 	heap_ptr;
typedef unsigned int 	heap_vram_offset;
typedef unsigned int 	heap_word;

const unsigned int 		heap_type_bram = 0x0000;
const unsigned int 		heap_type_vram = 0x8000;
const unsigned int 		heap_type_mask = 0x8000;

const unsigned int 		heap_bram_bank_min = 0;
const unsigned int 		heap_bram_ptr_min = 0xA000;
const unsigned int 		heap_bram_bank_max = 64;
const unsigned int 		heap_bram_ptr_max = 0xC000;
const unsigned int 		heap_bram_ptr_mask = 0x1FFF;
const unsigned int 		heap_bram_ptr_base = 0xA000;

const unsigned int 		heap_vram_bank_min = 0;
const unsigned int 		heap_vram_ptr_min = 0x0000;
const unsigned int 		heap_vram_bank_max = 1;
const unsigned int 		heap_vram_ptr_max = 0xF800;
const unsigned int 		heap_vram_ptr_mask = 0xFFFF;
const unsigned int 		heap_vram_ptr_base = 0x0000;


const unsigned int 		heap_size_mask = 0x7FFF;

struct HEAP_SEGMENT {

	unsigned int HeapType;

	heap_handle HeapFloor;
	heap_handle HeapCeil;
	heap_handle HeapSize;
	heap_handle HeaderFloor;
	heap_handle HeaderCeil;
	heap_handle HeaderSize;

	heap_handle freeList;
	heap_handle idleList;
	heap_handle heapList;
	
	heap_handle HeaderPosition;
	heap_handle HeapPosition;

	unsigned int heapCount;
	unsigned int freeCount;
	unsigned int idleCount;
	unsigned int heapSize;
	unsigned int freeSize;
};

typedef struct HEAP_SEGMENT heap_segment_struct;
typedef struct HEAP_SEGMENT* heap_segment_ptr;

typedef unsigned char heap_segment_id;


/**
 * Header Block layout.
 * Contains 16 bit condensed pointer to data header.
 * Contains size of data header.
 * Contains condensed pointers to next and previous header blocks.
 */
struct HEAP_INDEX {
	heap_handle data;
	heap_size_packed size;
	heap_handle next;
	heap_handle prev;
};

typedef struct HEAP_INDEX heap_index;
typedef struct HEAP_INDEX* heap_index_ptr;

struct HEAP_DATA_LIST {
	heap_handle next;
	heap_handle prev;
};

typedef struct HEAP_DATA_LIST heap_data_list;
typedef struct HEAP_DATA_LIST* heap_data_list_ptr;

inline heap_bram_packed  heap_bram_pack(heap_bank bank, heap_ptr ptr);
inline heap_vram_packed  heap_vram_pack(heap_bank bank, heap_vram_offset offset);
inline heap_bank         heap_bram_unpack_bank(heap_bram_packed bram_packed);
inline heap_ptr          heap_bram_unpack_ptr(heap_bram_packed bram_packed);
inline heap_bank         heap_vram_unpack_bank(heap_vram_packed vram_packed);
inline heap_vram_offset       heap_vram_unpack_offset(heap_vram_packed vram_packed);

inline heap_size_packed  heap_size_pack(heap_size_large size);
inline heap_size         heap_size_unpack(heap_size_packed size_packed);


heap_address heap_segment_bram(
	heap_segment_id segment, 
	heap_vram_packed heapFloorBram,
	heap_size_packed heapSizeBram
	);

heap_address heap_segment_vram_floor(
	heap_segment_id segment, 
	heap_vram_packed heapFloorVram,
	heap_size_packed heapSizeVram,
	heap_bram_packed indexFloorBram,
	heap_size_packed indexSizeBram
	);

heap_address heap_segment_vram_ceil(
	heap_segment_id segment, 
	heap_vram_packed heapCeilVram,
	heap_size_packed heapSizeVram,
	heap_bram_packed indexFloorBram,
	heap_size_packed indexSizeBram
	);

heap_handle heap_alloc(heap_segment_id segment, heap_size size);
heap_handle heap_free(heap_segment_id segment, heap_handle handle);

heap_ptr heap_data_ptr(
	heap_handle handle
	);

heap_handle heap_data_get(heap_handle indexHeap);
heap_size_packed heap_size_get(heap_handle indexHeap);

heap_bank heap_data_bank(heap_handle handle);
heap_handle heap_data_get(heap_handle handle);

void heap_dump(heap_segment_id segment);
void heap_dump_stats(heap_segment_id segment);
void heap_dump_index(heap_segment_id segment);

heap_size_large heap_alloc_size(heap_segment_id segment);
heap_size_large heap_free_size(heap_segment_id segment);
unsigned int heap_alloc_count(heap_segment_id segment);
unsigned int heap_free_count(heap_segment_id segment);
unsigned int heap_idle_count(heap_segment_id segment);

// heap_handle heap_data_list_insert_at(heap_handle *list, heap_handle index, heap_handle at);
heap_handle heap_data_list_insert(heap_handle *list, heap_handle index);
heap_handle heap_data_list_remove(heap_handle *list, heap_handle index);

