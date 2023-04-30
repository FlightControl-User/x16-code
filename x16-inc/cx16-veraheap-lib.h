#include <cx16-veraheap-typedefs.h>

extern __stackcall __library(veraheap)  void vera_heap_bram_bank_init(bram_bank_t bram_bank);

extern __stackcall __library(veraheap)  vera_heap_segment_index_t vera_heap_segment_init(vera_heap_segment_index_t s, vram_bank_t vram_bank_floor, vram_offset_t vram_offset_floor, vram_bank_t vram_bank_ceil, vram_offset_t vram_offset_ceil);

extern __stackcall __library(veraheap)  vera_heap_index_t vera_heap_alloc(vera_heap_segment_index_t s, vera_heap_size_t size);
extern __stackcall __library(veraheap) void vera_heap_free(vera_heap_segment_index_t s, vera_heap_index_t handle);

extern __stackcall __library(veraheap) void vera_heap_dump(vera_heap_segment_index_t s, unsigned char x, unsigned char y);
// void vera_heap_dump_stats(vera_heap_segment_index_t s);
// void vera_heap_dump_index(vera_heap_segment_index_t s);
// void vera_heap_dump_xy(unsigned char x, unsigned char y);
// void vera_heap_dump_graphic_print(vera_heap_segment_index_t s, unsigned char veraheap_dx, unsigned char veraheap_dy);


// vera_heap_data_packed_t vera_heap_get_data_packed(vera_heap_segment_index_t s, vera_heap_index_t index);
extern __stackcall __library(veraheap) vram_offset_t vera_heap_data_get_offset(vera_heap_segment_index_t s, vera_heap_index_t index);
extern __stackcall __library(veraheap) vram_bank_t vera_heap_data_get_bank(vera_heap_segment_index_t s, vera_heap_index_t index);
extern __stackcall __library(veraheap) vera_heap_size_t vera_heap_get_size(vera_heap_segment_index_t s, vera_heap_index_t index);
// vera_heap_size_int_t vera_heap_get_size_int(vera_heap_segment_index_t s, vera_heap_index_t index);
// vera_heap_size_packed_t vera_heap_get_size_packed(vera_heap_segment_index_t s, vera_heap_index_t index);

extern __stackcall __library(veraheap) vera_heap_image_t vera_heap_get_image(vera_heap_segment_index_t s, vera_heap_index_t index);
extern __stackcall __library(veraheap) void vera_heap_set_image(vera_heap_segment_index_t s, vera_heap_index_t index, vera_heap_image_t image);


// vera_heap_size_t vera_heap_alloc_size(vera_heap_segment_index_t s);
// vera_heap_size_t vera_heap_free_size(vera_heap_segment_index_t s);
// unsigned int vera_heap_alloc_count(vera_heap_segment_index_t s);
// unsigned int vera_heap_free_count(vera_heap_segment_index_t s);
// unsigned int vera_heap_idle_count(vera_heap_segment_index_t s);

extern __stackcall __library(veraheap) bool vera_heap_has_free(vera_heap_segment_index_t s, vera_heap_size_int_t size_requested);
extern __stackcall __library(veraheap) bool vera_heap_is_free(vera_heap_segment_index_t s, vera_heap_index_t index);

// vera_heap_index_t vera_heap_list_remove(vera_heap_segment_index_t s, vera_heap_index_t list, vera_heap_index_t index);
// vera_heap_index_t vera_heap_heap_insert_at(vera_heap_segment_index_t s, vera_heap_index_t heap_index, vera_heap_index_t at, vera_heap_size_packed_t size);
