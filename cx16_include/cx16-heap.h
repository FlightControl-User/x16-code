/**
 * @file cx16-heap.h
 * @author Sven VAn de Velde (sven.van.de.velde@outlook.com)
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
typedef unsigned int 	heap_offset;
typedef unsigned int 	heap_word;

const unsigned int heap_type_bram = 0x0000;
const unsigned int heap_type_vram = 0x8000;
const unsigned int heap_type_mask = 0x8000;

const unsigned int heap_bram_bank_min = 0;
const unsigned int heap_bram_ptr_min = 0xA000;
const unsigned int heap_bram_bank_max = 64;
const unsigned int heap_bram_ptr_max = 0xC000;
const unsigned int heap_bram_ptr_mask = 0x1FFF;
const unsigned int heap_bram_ptr_base = 0xA000;

const unsigned int heap_vram_bank_min = 0;
const unsigned int heap_vram_ptr_min = 0x0000;
const unsigned int heap_vram_bank_max = 1;
const unsigned int heap_vram_ptr_max = 0xF800;
const unsigned int heap_vram_ptr_mask = 0xFFFF;
const unsigned int heap_vram_ptr_base = 0x0000;


const unsigned int heap_size_mask = 0x7FFF;

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

typedef unsigned char heap_segment;

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

inline heap_bram_packed  heap_bram_pack(cx16_bank bank, cx16_ptr ptr);
inline heap_vram_packed  heap_vram_pack(cx16_bank bank, cx16_offset offset);
inline heap_bank         heap_bram_unpack_bank(cx16_bram_packed bram_packed);
inline heap_ptr          heap_bram_unpack_ptr(cx16_bram_packed bram_packed);
inline heap_bank         heap_vram_unpack_bank(cx16_vram_packed vram_packed);
inline heap_offset       heap_vram_unpack_offset(cx16_vram_packed vram_packed);


heap_address heap_segment_bram(
	heap_segment Segment, 
	cx16_vram_packed HeapFloorBram,
	heap_size_packed HeapSizeBram
	);

heap_address heap_segment_vram_floor(
	heap_segment Segment, 
	cx16_vram_packed HeapFloorVram,
	heap_size_packed HeapSizeVram,
	cx16_bram_packed HeaderFloorBram,
	heap_size_packed HeaderSizeBram
	);

heap_address heap_segment_vram_ceil(
	heap_segment Segment, 
	cx16_vram_packed HeapCeilVram,
	heap_size_packed HeapSizeVram,
	cx16_bram_packed HeaderFloorBram,
	heap_size_packed HeaderSizeBram
	);

heap_handle heap_alloc(heap_segment segment, heap_size size);
heap_handle heap_free(heap_segment segment, heap_handle handle);

heap_ptr heap_data_ptr(
	heap_handle handle
	);

heap_handle heap_data_get(heap_handle indexHeap);
heap_size_packed heap_size_get(heap_handle indexHeap);

heap_bank heap_data_bank(
	heap_handle handle
	);

heap_handle heap_data_get(
	heap_handle handle
	);

dword heap_segment_vram_floor_ulong(struct HEAP_SEGMENT* Segment);

void heap_dump(heap_segment Segment);
void heap_dump_stats(heap_segment Segment);
void heap_dump_index(heap_segment Segment);

heap_size_large heap_alloc_size(heap_segment Segment);
heap_size_large heap_free_size(heap_segment Segment);
unsigned int heap_alloc_count(heap_segment Segment);
unsigned int heap_free_count(heap_segment Segment);
unsigned int heap_idle_count(heap_segment Segment);
