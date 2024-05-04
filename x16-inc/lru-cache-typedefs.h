#ifndef LRU_CACHE_SIZE
    #define LRU_CACHE_SIZE 128
#endif

#ifndef LRU_CACHE_MAX
    #define LRU_CACHE_MAX 96
#endif


#define LRU_CACHE_NOTHING 0xFFFF
#define LRU_CACHE_USED 0xFFFE

#define LRU_CACHE_INDEX_NULL 0xFF


typedef unsigned int  lru_cache_key_t;
typedef unsigned int  lru_cache_data_t;
typedef unsigned char lru_cache_index_t;



typedef struct {
    lru_cache_key_t key[LRU_CACHE_SIZE];   
    lru_cache_data_t data[LRU_CACHE_SIZE];
    lru_cache_index_t prev[LRU_CACHE_SIZE];
    lru_cache_index_t next[LRU_CACHE_SIZE];
    lru_cache_index_t link[LRU_CACHE_SIZE];
    lru_cache_index_t count;
    lru_cache_index_t first;
    lru_cache_index_t last;
    lru_cache_index_t size;
} lru_cache_table_t;
