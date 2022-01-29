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

typedef unsigned int ht_size_t;
typedef unsigned int ht_key_t;
typedef unsigned int ht_data_t;
typedef unsigned int ht_index_t;


typedef struct ht_item_s {
   ht_key_t key;   
   ht_data_t data;
} ht_item_t;

typedef struct ht_item_s *ht_t;


void ht_init(ht_t ht, ht_size_t ht_size_init);
unsigned int ht_code(ht_key_t key);
ht_item_t* ht_get(ht_t ht, ht_key_t key);
void ht_insert(ht_t ht, ht_key_t key, ht_data_t data);
ht_item_t* ht_delete(ht_t ht, ht_item_t* item);

