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

#define LRU_CACHE_MAX 96

#include <cx16.h>
#include <lru-cache.h>
#include <conio.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

lru_cache_table_t lru_cache;

void lru_cache_init()
{
    // The size of the elements can never exceed 256 bytes!!!
    memset_fast(lru_cache.key, 0xFF, sizeof(lru_cache_key_t)*LRU_CACHE_SIZE);
    memset_fast(lru_cache.data, 0xFF, sizeof(lru_cache_data_t)*LRU_CACHE_SIZE);
    memset_fast(lru_cache.next, 0xFF, sizeof(lru_cache_index_t)*LRU_CACHE_SIZE);
    memset_fast(lru_cache.prev, 0xFF, sizeof(lru_cache_index_t)*LRU_CACHE_SIZE);
    memset_fast(lru_cache.link, 0xFF, sizeof(lru_cache_index_t)*LRU_CACHE_SIZE);
    lru_cache.first = 0xFF;
    lru_cache.last = 0xFF;
    lru_cache.count = 0;
    lru_cache.size = LRU_CACHE_SIZE;
}

// __mem unsigned char lru_cache_seed;

lru_cache_index_t lru_cache_hash(lru_cache_key_t key)
{
    return (lru_cache_index_t)(key % LRU_CACHE_SIZE);
}

// inline lru_cache_index_t lru_cache_hash(lru_cache_key_t key) {
//     lru_cache_seed = key;
//     asm {
//                     lda lru_cache_seed
//                     beq !doEor+
//                     asl
//                     beq !noEor+
//                     bcc !noEor+
//         !doEor:     eor #$2b
//         !noEor:     sta lru_cache_seed
//     }
//     return lru_cache_seed % LRU_CACHE_SIZE;
// }

inline bool lru_cache_is_max()
{
    return lru_cache.count >= LRU_CACHE_MAX;
}

lru_cache_key_t lru_cache_find_last()
{
    return lru_cache.key[lru_cache.last];
}

lru_cache_index_t lru_cache_find_empty(lru_cache_index_t index)
{
    while (lru_cache.key[index] != LRU_CACHE_NOTHING) {
        index++;
        index %= LRU_CACHE_SIZE;
    }
    return index;
}

lru_cache_index_t lru_cache_find_duplicate(lru_cache_index_t index, lru_cache_index_t link)
{
    // First find the last duplicate node.
    while (lru_cache.link[index] != link && lru_cache.link[index] != LRU_CACHE_INDEX_NULL) {
        index = lru_cache.link[index];
    }
    return index;
}

lru_cache_index_t lru_cache_index(lru_cache_key_t key)
{
    lru_cache_index_t index = lru_cache_hash(key);

    // Search till index == 0xFF, following the links.
    while (index != LRU_CACHE_INDEX_NULL) {
        if (lru_cache.key[index] == key) {
            return index;
        }
        index = lru_cache.link[index];
    }
    return LRU_CACHE_INDEX_NULL;
}

lru_cache_data_t lru_cache_get(lru_cache_index_t index)
{
    if (index != LRU_CACHE_INDEX_NULL) {
        lru_cache_data_t data = lru_cache.data[index];

        lru_cache_index_t next = lru_cache.next[index];
        lru_cache_index_t prev = lru_cache.prev[index];

        // Delete the node from the list.
        lru_cache.next[prev] = next;
        //lru_cache.next[next] = prev;
        lru_cache.prev[next] = prev;
        //lru_cache.prev[prev] = next;

        // Reassign first and last node.
        if (index == lru_cache.first) {
            lru_cache.first = next;
        }
        if (index == lru_cache.last) {
            lru_cache.last = prev;
        }

        // Now insert the node as the first node in the list.

        lru_cache.next[index] = lru_cache.first;
        lru_cache.prev[lru_cache.first] = index;
        lru_cache.next[lru_cache.last] = index;
        lru_cache.prev[index] = lru_cache.last;

        // Now the first node in the list is the node referenced!
        // All other nodes are moved one position down!
        lru_cache.first = index;
        lru_cache.last = lru_cache.prev[index];

        return data;
    }
    return LRU_CACHE_NOTHING;
}

lru_cache_data_t lru_cache_set(lru_cache_index_t index, lru_cache_data_t data)
{
    if (index != LRU_CACHE_INDEX_NULL) {
        lru_cache.data[index] = data;
        return lru_cache_get(index);
    }
    return LRU_CACHE_NOTHING;
}


lru_cache_data_t lru_cache_data(lru_cache_index_t index)
{
    return lru_cache.data[index];
}


inline void lru_cache_move_link(lru_cache_index_t link, lru_cache_index_t index)
{
    // Here we move the node at the index to the new link, and set the head link to the new link.

    lru_cache_index_t l = lru_cache.link[index];
    lru_cache.link[link] = l;

    // This results in incorrect code!
    // lru_cache.key[link] = lru_cache.key[index];
    // lru_cache.data[link] = lru_cache.data[index];

    lru_cache_key_t key = lru_cache.key[index];
    lru_cache.key[link] = key;
    lru_cache_data_t data = lru_cache.data[index];
    lru_cache.data[link] = data;

    lru_cache_index_t next = lru_cache.next[index];
    lru_cache_index_t prev = lru_cache.prev[index];

    lru_cache.next[link] = next;
    lru_cache.prev[link] = prev;

    lru_cache.next[prev] = link;
    lru_cache.prev[next] = link;

    // todo first and last
    if (lru_cache.last == index) {
        lru_cache.last = link;
    }

    if (lru_cache.first == index) {
        lru_cache.first = link;
    }

    lru_cache.key[index] = LRU_CACHE_NOTHING;
    lru_cache.data[index] = LRU_CACHE_NOTHING;
    lru_cache.next[index] = LRU_CACHE_INDEX_NULL;
    lru_cache.prev[index] = LRU_CACHE_INDEX_NULL;
    lru_cache.link[index] = LRU_CACHE_INDEX_NULL;
}

lru_cache_index_t lru_cache_find_head(lru_cache_index_t index)
{
    lru_cache_key_t key_link = lru_cache.key[index];
    lru_cache_index_t head_link = lru_cache_hash(key_link);
    if (head_link != index) {
        return head_link;
    } else {
        return LRU_CACHE_INDEX_NULL;
    }
}

lru_cache_index_t lru_cache_insert(lru_cache_key_t key, lru_cache_data_t data)
{
    lru_cache_index_t index = lru_cache_hash(key);

    // Check if there is already a link node in place in the hash table at the index.

    lru_cache_index_t link_head = lru_cache_find_head(index);
    lru_cache_index_t link_prev = lru_cache_find_duplicate(link_head, index);

    if (lru_cache.key[index] != LRU_CACHE_NOTHING && link_head != LRU_CACHE_INDEX_NULL) {
        // There is already a link node, so this node is not a head node and needs to be moved.
        // Get the head node of this chain, we know this because we can get the head of the key.
        // The link of the head_link must be changed once the new place of the link node has been found.
        lru_cache_index_t link = lru_cache_find_empty(index);
        lru_cache_move_link(link, index);
        lru_cache.link[link_prev] = link;
    }

    // The index is at the head of a chain and is either duplicates or empty.

    // We just follow the duplicate chain and find the last duplicate.
    lru_cache_index_t index_prev = lru_cache_find_duplicate(index, LRU_CACHE_INDEX_NULL);

    // From the last duplicate position, we search for the first free node.
    index = lru_cache_find_empty(index_prev);

    // We set the link of the free node to INDEX_NULL, 
    // and point the link of the previous node to the empty node.
    // index != index_prev indicates there is a duplicate chain. 
    lru_cache.link[index] = LRU_CACHE_INDEX_NULL;
    if (index_prev != index) {
        lru_cache.link[index_prev] = index;
    }

    // Now assign the key and the data.
    lru_cache.key[index] = key;
    lru_cache.data[index] = data;

    // And set the lru chain.
    if (lru_cache.first == 0xff) {
        lru_cache.first = index;
    }
    if (lru_cache.last == 0xff) {
        lru_cache.last = index;
    }

    // Now insert the node as the first node in the list.
    lru_cache.next[index] = lru_cache.first;
    lru_cache.prev[lru_cache.first] = index;

    lru_cache.next[lru_cache.last] = index;
    lru_cache.prev[index] = lru_cache.last;

    lru_cache.first = index;

    lru_cache.count++;

    return index;
}


lru_cache_data_t lru_cache_delete(lru_cache_key_t key)
{
    lru_cache_index_t index = lru_cache_hash(key);

    // move in array until an empty
    lru_cache_index_t index_prev = LRU_CACHE_INDEX_NULL;
    while (lru_cache.key[index] != LRU_CACHE_NOTHING) {

        if (lru_cache.key[index] == key) {

            lru_cache_data_t data = lru_cache.data[index];

            // First remove the index node.
            lru_cache.key[index] = LRU_CACHE_NOTHING;
            lru_cache.data[index] = LRU_CACHE_NOTHING;

            lru_cache_index_t next = lru_cache.next[index];
            lru_cache_index_t prev = lru_cache.prev[index];

            lru_cache.next[index] = LRU_CACHE_INDEX_NULL;
            lru_cache.prev[index] = LRU_CACHE_INDEX_NULL;
            if (lru_cache.next[index] == index) {
                // Reset first and last node.
                lru_cache.first = 0xff;
                lru_cache.last = 0xff;
            } else {
                // Delete the node from the list.
                lru_cache.next[prev] = next;
                lru_cache.prev[next] = prev;
                // Reassign first and last node.
                if (index == lru_cache.first) {
                    lru_cache.first = next;
                }
                if (index == lru_cache.last) {
                    lru_cache.last = prev;
                }
            }

            lru_cache_index_t link = lru_cache.link[index];

            if (index_prev != LRU_CACHE_INDEX_NULL) {
                // The node is not the first node but the middle of a list.
                lru_cache.link[index_prev] = link;
            }

            if (link != LRU_CACHE_INDEX_NULL) {
                // The head is the start of a duplicate chain.
                // Simply move the next node in the duplicate chain as the new head.
                lru_cache_move_link(index, link);
            }


            lru_cache.count--;

            return data;
        }

        index_prev = index;
        index = lru_cache.link[index];
    }

    return LRU_CACHE_NOTHING;
}

// Only for debugging
void lru_cache_display(char x, char y) {
    unsigned char col = 0;

    gotoxy(x, y);

    printf("least recently used cache statistics\n");
    printf("size = %3u, first = %2x, last = %2x, count = %2x\n\n", LRU_CACHE_SIZE, lru_cache.first, lru_cache.last, lru_cache.count);

    printf("least recently used hash table\n\n");

    printf("   ");
    do {
        printf("   %1x/%1x  ", col, col + 8);
        col++;
    } while (col < 8);
    printf("\n");

    col = 0;
    lru_cache_index_t index_row = 0;
    do {

        lru_cache_index_t index = index_row;
        printf("%02x:", index);
        do {
            if (lru_cache.key[index] != LRU_CACHE_NOTHING) {
                printf(" %04x:", lru_cache.key[index]);
                printf("%02x", lru_cache.link[index]);
            } else {
                printf(" ----:--");
            }
            index++;
        } while (index < index_row + 8);
        printf("\n");

        index = index_row;
        printf("  :");
        do {
            printf(" %02x:", lru_cache.next[index]);
            printf("%02x  ", lru_cache.prev[index]);
            index++;
        } while (index < index_row + 8);
        printf("\n");

        index_row += 8;
    } while (index_row < 128);

    printf("\n");

    printf("least recently used sequence\n");

    lru_cache_index_t index = lru_cache.first;
    lru_cache_index_t count = 0;
    col = 0;

    while (count < lru_cache.size) {
        if (count < lru_cache.count)
            printf(" %4x", lru_cache.key[index]);
        else
            printf("    ");
        //printf(" %4x %3uN %3uP ", lru_cache.key[cache_index], lru_cache.next[cache_index], lru_cache.prev[cache_index]);

        index = lru_cache.next[index];
        count++;
    }
}
