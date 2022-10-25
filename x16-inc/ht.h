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

#ifndef HT_SIZE
    #define HT_SIZE (unsigned int)256
    #define HT_BOUNDARY ((ht_index_t)(HT_SIZE-1))
#endif

#ifndef HT_MAX
    #define HT_MAX (unsigned int)196
#endif


ht_list_t ht_list;

#pragma data_seg(Data)

__mem unsigned char ht_list_index;

inline void ht_init(ht_item_t* ht);
inline void ht_reset(ht_item_t* ht); 
inline ht_index_t ht_hash(ht_key_t key);
inline ht_index_t ht_hash_next();
inline ht_index_t ht_get(ht_item_t* ht, ht_key_t key);
inline ht_index_t ht_get_next(ht_index_t ht_index);
inline ht_data_t ht_get_data(ht_index_t ht_index); 

inline ht_index_t ht_insert(ht_item_t* ht, ht_key_t key, ht_data_t data);
void ht_display(ht_item_t* ht);

#pragma data_seg(Data)
