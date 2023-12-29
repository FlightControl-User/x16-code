/**
 * @file cx16-bankheap.h
 * @author Sven Van de Velde (sven.van.de.velde@outlook.com)
 * @brief Commander x16 memory manager of the bank ram in the Commander X16.
 * @version 0.1
 * @date 2023-04-20
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#include <cx16-bramheap-segments-typedefs.h>

extern bram_heap_map_t bram_heap_index[BRAM_HEAP_SEGMENTS];
extern bram_heap_segment_t bram_heap_segment;

void bram_heap_bram_bank_init(bram_bank_t bram_bank);

bram_heap_segment_index_t bram_heap_segment_init(bram_heap_segment_index_t s, bram_bank_t bram_bank_floor, bram_ptr_t bram_ptr_floor, bram_bank_t bram_bank_ceil, bram_ptr_t bram_ptr_ceil);

bram_heap_index_t bram_heap_alloc(bram_heap_segment_index_t s, bram_heap_size_t size);
void bram_heap_free(bram_heap_segment_index_t s, bram_heap_index_t handle);




void bram_heap_dump(bram_heap_segment_index_t s, unsigned char x, unsigned char y);
void bram_heap_dump_stats(bram_heap_segment_index_t s);
void bram_heap_dump_index(bram_heap_segment_index_t s);
void bram_heap_dump_xy(unsigned char x, unsigned char y);
void bram_heap_dump_graphic_print(bram_heap_segment_index_t s, unsigned char bramheap_dx, unsigned char bramheap_dy);


bram_heap_data_packed_t bram_heap_get_data_packed(bram_heap_segment_index_t s, bram_heap_index_t index);
bram_ptr_t bram_heap_data_get_offset(bram_heap_segment_index_t s, bram_heap_index_t index);
bram_bank_t bram_heap_data_get_bank(bram_heap_segment_index_t s, bram_heap_index_t index);
bram_heap_size_t bram_heap_get_size(bram_heap_segment_index_t s, bram_heap_index_t index);
bram_heap_size_int_t bram_heap_get_size_int(bram_heap_segment_index_t s, bram_heap_index_t index);
bram_heap_size_packed_t bram_heap_get_size_packed(bram_heap_segment_index_t s, bram_heap_index_t index);


bram_heap_size_t bram_heap_alloc_size(bram_heap_segment_index_t s);
bram_heap_size_t bram_heap_free_size(bram_heap_segment_index_t s);
unsigned int bram_heap_alloc_count(bram_heap_segment_index_t s);
unsigned int bram_heap_free_count(bram_heap_segment_index_t s);
unsigned int bram_heap_idle_count(bram_heap_segment_index_t s);

bool bram_heap_has_free(bram_heap_segment_index_t s, bram_heap_size_int_t size_requested);
bool bram_heap_is_free(bram_heap_segment_index_t s, bram_heap_index_t index);

bram_heap_index_t bram_heap_list_remove(bram_heap_segment_index_t s, bram_heap_index_t list, bram_heap_index_t index);
bram_heap_index_t bram_heap_heap_insert_at(bram_heap_segment_index_t s, bram_heap_index_t heap_index, bram_heap_index_t at, bram_heap_size_packed_t size);
