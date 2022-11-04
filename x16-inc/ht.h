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

#include "ht-typedefs.h"



ht_list_t ht_list;

#pragma data_seg(Data)

__mem unsigned char ht_list_index;

void ht_init(ht_item_t* ht);
void ht_reset(ht_item_t* ht); 
ht_index_t ht_hash(ht_key_t key);
ht_index_t ht_hash_next();
ht_index_t ht_get(ht_item_t* ht, ht_key_t key);
ht_index_t ht_get_next(ht_index_t ht_index);
ht_data_t ht_get_data(ht_index_t ht_index); 

ht_index_t ht_insert(ht_item_t* ht, ht_key_t key, ht_data_t data);
void ht_display(ht_item_t* ht);

#pragma data_seg(Data)
