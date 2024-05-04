/**
 * @file lru_cache.h
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Least Recently Used Cache using a hash table and a double linked list, searchable. 
 * To store fast and retrieve fast elements from an array. To search fast the last used element and delete it.
 * @version 0.1
 * @date 2022-09-02
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "lru-cache-typedefs.h"


void lru_cache_init();

lru_cache_index_t lru_cache_hash(lru_cache_key_t key);

lru_cache_key_t lru_cache_find_last();
inline bool lru_cache_is_max();

lru_cache_index_t lru_cache_index(lru_cache_key_t key);
lru_cache_data_t lru_cache_get(lru_cache_index_t index);
lru_cache_data_t lru_cache_set(lru_cache_index_t index, lru_cache_data_t data);
lru_cache_data_t lru_cache_data(lru_cache_index_t index);

lru_cache_index_t lru_cache_insert(lru_cache_key_t key, lru_cache_data_t data);
lru_cache_data_t lru_cache_delete(lru_cache_key_t key);

void lru_cache_display(char x, char y);

