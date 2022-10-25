/**
 * @file lru-cache.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Least Recently Used Cache using a hash table and a double linked list, searchable. 
 * To store fast and retrieve fast elements from an array. To search fast the last used element and delete it.
 * @version 0.1
 * @date 2022-09-02
 * 
 * @copyright Copyright (c) 2022
 * 
 */
#include <conio.h>
#include <cx16.h>
#include <lru-cache.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void lru_cache_init(lru_cache_table_t *lru_cache) {
    memset(lru_cache->key, 0xFF, LRU_CACHE_SIZE * 2);
    memset(lru_cache->data, 0xFF, LRU_CACHE_SIZE * 2);
    memset(lru_cache->prev, 0xFF, LRU_CACHE_SIZE);
    memset(lru_cache->next, 0xFF, LRU_CACHE_SIZE);
    lru_cache->first = 0xFF;
    lru_cache->last = 0xFF;
    lru_cache->count = 0;
    lru_cache->size = LRU_CACHE_SIZE;
}

__mem unsigned char lru_cache_seed;

// /* inline */ lru_cache_index_t lru_cache_hash(lru_cache_key_t key) {
//     return key % LRU_CACHE_SIZE;
// }

inline lru_cache_index_t lru_cache_hash(lru_cache_key_t key) {
    lru_cache_seed = key;
    asm {
                    lda lru_cache_seed
                    beq !doEor+
                    asl
                    beq !noEor+
                    bcc !noEor+
        !doEor:     eor #$2b
        !noEor:     sta lru_cache_seed
    }
    return lru_cache_seed % LRU_CACHE_SIZE;
}

inline lru_cache_index_t lru_cache_hash2() {
    asm {
                    lda lru_cache_seed
                    beq !doEor+
                    asl
                    beq !noEor+
                    bcc !noEor+
        !doEor:    eor #$2b
        !noEor:    sta lru_cache_seed
    }
    return lru_cache_seed % LRU_CACHE_SIZE;
}

inline bool lru_cache_max(lru_cache_table_t *lru_cache) {
    return lru_cache->count >= LRU_CACHE_MAX;
}

inline lru_cache_key_t lru_cache_last(lru_cache_table_t *lru_cache) {
    return lru_cache->key[lru_cache->last];
}

inline lru_cache_index_t lru_cache_index(lru_cache_table_t *lru_cache, lru_cache_key_t cache_key) {
    lru_cache_index_t vram_cache_index = lru_cache_hash(cache_key);

    while (lru_cache->data[vram_cache_index] != LRU_CACHE_NOTHING) {
        if (lru_cache->key[vram_cache_index] == cache_key)
            return vram_cache_index;

        // ++vram_cache_index;
        vram_cache_index = lru_cache_hash2();
        vram_cache_index %= LRU_CACHE_SIZE;
    }

    return LRU_CACHE_NOTHING;
}

inline lru_cache_data_t lru_cache_get(lru_cache_table_t *lru_cache, lru_cache_index_t cache_index) {

    lru_cache_data_t data = lru_cache->data[cache_index];

    lru_cache_index_t next = lru_cache->next[cache_index];
    lru_cache_index_t prev = lru_cache->prev[cache_index];

    // Delete the node from the list.
    lru_cache->next[prev] = next;
    //lru_cache->next[next] = prev;
    lru_cache->prev[next] = prev;
    //lru_cache->prev[prev] = next;

    // Reassign first and last node.
    if (cache_index == lru_cache->first) {
        lru_cache->first = next;
    }
    if (cache_index == lru_cache->last) {
        lru_cache->last = prev;
    }

    // Now insert the node as the first node in the list.

    lru_cache->next[cache_index] = lru_cache->first;
    lru_cache->prev[lru_cache->first] = cache_index;
    lru_cache->next[lru_cache->last] = cache_index;
    lru_cache->prev[cache_index] = lru_cache->last;

    // Now the first node in the list is the node referenced!
    // All other nodes are moved one position down!
    lru_cache->first = cache_index;
    lru_cache->last = lru_cache->prev[cache_index];

    return data;
}

inline lru_cache_data_t lru_cache_data(lru_cache_table_t *lru_cache, lru_cache_index_t cache_index) {
    return lru_cache->data[cache_index];
}

/* inline */ lru_cache_index_t lru_cache_insert(lru_cache_table_t *lru_cache, lru_cache_key_t vram_key, lru_cache_data_t vram_data) {
    lru_cache_index_t cache_index = lru_cache_hash(vram_key);

    while (lru_cache->data[cache_index] != LRU_CACHE_NOTHING && lru_cache->key[cache_index] != LRU_CACHE_NOTHING) {
        // cache_index++;
        cache_index = lru_cache_hash2();
        cache_index %= LRU_CACHE_SIZE;
    }

    lru_cache->key[cache_index] = vram_key;
    lru_cache->data[cache_index] = vram_data;

    if(lru_cache->first == 0xff) {
        lru_cache->first = cache_index;
    }
    if(lru_cache->last == 0xff) {
        lru_cache->last = cache_index;
    }

    // Now insert the node as the first node in the list.
    lru_cache->next[cache_index] = lru_cache->first;
    lru_cache->prev[lru_cache->first] = cache_index;

    lru_cache->next[lru_cache->last] = cache_index;
    lru_cache->prev[cache_index] = lru_cache->last;

    lru_cache->first = cache_index;

    lru_cache->count++;

    return cache_index;
}


/* inline */ lru_cache_data_t lru_cache_delete(lru_cache_table_t *lru_cache, lru_cache_key_t vram_key) {
    lru_cache_index_t cache_index = lru_cache_hash(vram_key);

    // move in array until an empty
    while (lru_cache->data[cache_index] != LRU_CACHE_NOTHING) {
        if (lru_cache->key[cache_index] == vram_key) {

            lru_cache_data_t data = lru_cache->data[cache_index];

            lru_cache->key[cache_index] = LRU_CACHE_NOTHING;
            lru_cache->data[cache_index] = LRU_CACHE_USED;

            lru_cache_index_t next = lru_cache->next[cache_index];
            lru_cache_index_t prev = lru_cache->prev[cache_index];

            if (lru_cache->next[cache_index] == cache_index) {
                // Reset first and last node.
                lru_cache->first = 0xff;
                lru_cache->last = 0xff;
            } else {
                // Delete the node from the list.
                lru_cache->next[prev] = next;
                lru_cache->prev[next] = prev;
                // Reassign first and last node.
                if (cache_index == lru_cache->first) {
                    lru_cache->first = next;
                }
                if (cache_index == lru_cache->last) {
                    lru_cache->last = prev;
                }
            }

            lru_cache->count--;

            return data;
        }

        // ++cache_index;
        cache_index = lru_cache_hash2();
        cache_index %= LRU_CACHE_SIZE;
    }

    return LRU_CACHE_NOTHING;
}

// Only for debugging
void lru_cache_display(lru_cache_table_t *lru_cache) {
    lru_cache_index_t cache_index = 0;
    unsigned char col = 0;

    printf("least recently used cache statistics\n");
    printf("size = %3u, first = %2x, last = %2x, count = %2x\n\n", LRU_CACHE_SIZE, lru_cache->first, lru_cache->last, lru_cache->count);

    printf("least recently used hash table\n");
    do {
        if (!col) {
            printf("%04x: ", cache_index);
        }
        if (lru_cache->data[cache_index] == LRU_CACHE_USED) {
            printf(" ++:++++");
        } else {
            if (lru_cache->data[cache_index] != LRU_CACHE_NOTHING) {
                printf(" %2x:", lru_cache->key[cache_index]);
                printf("%04x", lru_cache->data[cache_index]);
            } else {
                printf(" --:----");
            }
        }

        if (++col >= 8) {
            col = 0;
            printf("\n");
        }

        cache_index++;

    } while (cache_index < 128);

    printf("\n");

    printf("least recently used sequence\n");

    cache_index = lru_cache->first;

    unsigned char cache_count = 0;
    col = 0;

    while (cache_count < lru_cache->size) {
        if (!col) {
            printf("%4x: ", cache_count);
        }
        if(cache_count < lru_cache->count)
            printf(" %2x", lru_cache->key[cache_index]);
        else
            printf("   ");
        //printf(" %4x %3uN %3uP ", lru_cache->key[cache_index], lru_cache->next[cache_index], lru_cache->prev[cache_index]);

        if (++col >= 16) {
            col = 0;
            printf("\n");
        }

        cache_index = lru_cache->next[cache_index];
        cache_count++;
    } 
}
