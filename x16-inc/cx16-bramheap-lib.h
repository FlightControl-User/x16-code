#include <cx16-bramheap-typedefs.h>

extern __stackcall __library(bramheap)  void bram_heap_bram_bank_init(bram_bank_t bram_bank);

extern __stackcall __library(bramheap)  bram_heap_segment_index_t bram_heap_segment_init(bram_heap_segment_index_t s, bram_bank_t bram_bank_floor, bram_ptr_t bram_offset_floor, bram_bank_t bram_bank_ceil, bram_ptr_t bram_offset_ceil);

extern __stackcall __library(bramheap)  bram_heap_index_t bram_heap_alloc(bram_heap_segment_index_t s, bram_heap_size_t size);
extern __stackcall __library(bramheap) void bram_heap_free(bram_heap_segment_index_t s, bram_heap_index_t handle);

extern __stackcall __library(bramheap) void bram_heap_dump(bram_heap_segment_index_t s, unsigned char x, unsigned char y);
extern __stackcall __library(bramheap) void bram_heap_dump_stats(bram_heap_segment_index_t s);
// void bram_heap_dump_index(bram_heap_segment_index_t s);
extern __stackcall __library(bramheap) void bram_heap_dump_xy(unsigned char x, unsigned char y);
extern __stackcall __library(bramheap) void bram_heap_dump_graphic_print(bram_heap_segment_index_t s, unsigned char bramheap_dx, unsigned char bramheap_dy);


// bram_heap_data_packed_t bram_heap_get_data_packed(bram_heap_segment_index_t s, bram_heap_index_t index);
extern __stackcall __library(bramheap) bram_ptr_t bram_heap_data_get_offset(bram_heap_segment_index_t s, bram_heap_index_t index);
extern __stackcall __library(bramheap) bram_bank_t bram_heap_data_get_bank(bram_heap_segment_index_t s, bram_heap_index_t index);
extern __stackcall __library(bramheap) bram_heap_size_t bram_heap_get_size(bram_heap_segment_index_t s, bram_heap_index_t index);
// bram_heap_size_int_t bram_heap_get_size_int(bram_heap_segment_index_t s, bram_heap_index_t index);
// bram_heap_size_packed_t bram_heap_get_size_packed(bram_heap_segment_index_t s, bram_heap_index_t index);


// bram_heap_size_t bram_heap_alloc_size(bram_heap_segment_index_t s);
// bram_heap_size_t bram_heap_free_size(bram_heap_segment_index_t s);
// unsigned int bram_heap_alloc_count(bram_heap_segment_index_t s);
// unsigned int bram_heap_free_count(bram_heap_segment_index_t s);
// unsigned int bram_heap_idle_count(bram_heap_segment_index_t s);

//extern __stackcall __library(bramheap) bool bram_heap_has_free(bram_heap_segment_index_t s, bram_heap_size_int_t size_requested);
//extern __stackcall __library(bramheap) bool bram_heap_is_free(bram_heap_segment_index_t s, bram_heap_index_t index);

// bram_heap_index_t bram_heap_list_remove(bram_heap_segment_index_t s, bram_heap_index_t list, bram_heap_index_t index);
// bram_heap_index_t bram_heap_heap_insert_at(bram_heap_segment_index_t s, bram_heap_index_t heap_index, bram_heap_index_t at, bram_heap_size_packed_t size);
