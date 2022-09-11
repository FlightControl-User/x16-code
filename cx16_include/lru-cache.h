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


#ifndef LRU_CACHE_SIZE
    #define LRU_CACHE_SIZE 128
#endif

#ifndef LRU_CACHE_MAX
    #define LRU_CACHE_MAX 32
#endif


#define LRU_CACHE_NOTHING 0xFFFF
#define LRU_CACHE_USED 0xFFFE


typedef unsigned int  lru_cache_key_t;
typedef unsigned int  lru_cache_data_t;
typedef unsigned char lru_cache_index_t;

volatile unsigned char vram_cache_list_index;

typedef struct {
    lru_cache_key_t key[LRU_CACHE_SIZE];   
    lru_cache_data_t data[LRU_CACHE_SIZE];
    lru_cache_index_t prev[LRU_CACHE_SIZE];
    lru_cache_index_t next[LRU_CACHE_SIZE];
    lru_cache_index_t last;
    lru_cache_index_t first;
    lru_cache_index_t count;

} lru_cache_table_t;


void lru_cache_init(lru_cache_table_t* vram_ht);

lru_cache_index_t lru_cache_hash(lru_cache_key_t vram_key);

inline lru_cache_key_t lru_cache_last(lru_cache_table_t *lru_cache);
inline bool lru_cache_max(lru_cache_table_t *lru_cache);

lru_cache_index_t lru_cache_index(lru_cache_table_t* vram_ht, lru_cache_key_t vram_key);
inline lru_cache_data_t lru_cache_get(lru_cache_table_t *vram_ht, lru_cache_index_t vram_index);
inline lru_cache_data_t lru_cache_data(lru_cache_table_t* vram_ht, lru_cache_index_t vram_index);

lru_cache_index_t lru_cache_insert(lru_cache_table_t* vram_ht, lru_cache_key_t vram_key, lru_cache_data_t vram_data);
inline lru_cache_data_t lru_cache_delete(lru_cache_table_t* vram_ht, lru_cache_key_t vram_key);

void lru_cache_display(lru_cache_table_t* vram_ht);

