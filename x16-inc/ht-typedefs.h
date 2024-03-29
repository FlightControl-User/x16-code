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


typedef unsigned char const ht_size_t;
typedef unsigned char ht_key_t;
typedef unsigned char ht_data_t;
typedef unsigned char ht_index_t;
typedef unsigned char ht_count_t;

#ifndef HT_SIZE
    #define HT_SIZE (unsigned int)256
    #define HT_BOUNDARY ((ht_index_t)(HT_SIZE-1))
#endif

#ifndef HT_MAX
    #define HT_MAX (unsigned int)196
#endif

typedef struct {
   ht_key_t key[256];   
   ht_index_t next[256];
} ht_item_t;

typedef struct ht_list_s {
   ht_data_t data[256];
   ht_index_t next[256];
} ht_list_t;
