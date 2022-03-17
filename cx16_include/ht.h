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

typedef unsigned int const ht_size_t;
typedef unsigned int ht_key_t;
typedef heap_handle ht_data_t;
typedef unsigned int ht_index_t;

typedef struct ht_list_s {
   ht_data_t data;
   struct ht_list_s* next;
} ht_list_t;

typedef ht_list_t* ht_list_ptr_t;

typedef struct {
   ht_key_t key;   
   ht_list_ptr_t next;
} ht_item_t;
typedef ht_item_t *ht_item_ptr_t;


volatile ht_list_ptr_t ht_list = (ht_list_ptr_t)0xA400; // A list of pointers!
volatile unsigned int ht_list_index;

void ht_init(ht_item_ptr_t ht, ht_size_t ht_size);
void ht_reset(ht_item_ptr_t ht, ht_size_t ht_size); 
void ht_clean(ht_item_ptr_t ht, ht_size_t ht_size);
unsigned int ht_code(ht_size_t ht_size, ht_key_t key);
ht_list_ptr_t ht_get(ht_item_ptr_t ht, ht_size_t ht_size, ht_key_t key);
inline ht_list_ptr_t ht_get_next(ht_list_ptr_t ht_list);
ht_list_ptr_t ht_insert(ht_item_ptr_t ht, ht_size_t ht_size, ht_key_t key, ht_data_t data);
void ht_display(ht_item_ptr_t ht, ht_size_t ht_size);

