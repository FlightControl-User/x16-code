/**
 * @file ht.h
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Hash table, searchable. To store fast and retrieve fast elements from an array.
 * @version 0.1
 * @date 2022-01-29
 * 
 * @copyright Copyright (c) 2022
 * 
 */


#include <cx16-fb.h>

typedef unsigned char const vram_cache_size_t;
typedef unsigned int  vram_cache_key_t;
typedef unsigned int  vram_cache_data_t;
typedef unsigned char vram_cache_index_t;
typedef unsigned char vram_cache_count_t;

#pragma data_seg(Data)

#define vram_cache_SIZE 128


volatile unsigned char vram_cache_list_index;

typedef struct {
   vram_cache_key_t key[vram_cache_SIZE];   
   vram_cache_index_t next[vram_cache_SIZE];
} vram_cache_item_t;

typedef struct vram_cache_list_s {
   vram_cache_data_t data[vram_cache_SIZE];
   vram_cache_index_t next[vram_cache_SIZE];
} vram_cache_list_t;

vram_cache_list_t vram_cache_list;

#pragma data_seg(Data)

void vram_cache_init(vram_cache_item_t* ht);
void vram_cache_reset(vram_cache_item_t* ht); 
vram_cache_index_t vram_cache_code(vram_cache_key_t key);
vram_cache_index_t vram_cache_get(vram_cache_item_t* ht, vram_cache_key_t key);
vram_cache_index_t vram_cache_get_next(vram_cache_index_t vram_cache_index);
vram_cache_data_t vram_cache_get_data(vram_cache_index_t vram_cache_index); 

vram_cache_index_t vram_cache_insert(vram_cache_item_t* ht, vram_cache_key_t key, vram_cache_data_t data);
void vram_cache_display(vram_cache_item_t* ht);

#pragma data_seg(Data)
