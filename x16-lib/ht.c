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

#include <cx16.h>
#include <ht.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#pragma data_seg(Data)
#pragma code_seg(Code)

ht_list_t ht_list;

volatile unsigned char ht_list_pool;


void ht_init(ht_item_t* ht)
{
   // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
   memset_fast(ht->key, 0, 0);
   memset_fast(ht->next, 0, 0);

   ht_list_pool = HT_SIZE-1;
}

__mem volatile unsigned char ht_seed;

inline ht_index_t ht_hash(ht_key_t key)
{
   return key; //% HT_SIZE;
}

// ht_index_t ht_hash(ht_key_t key)
// {
//    ht_seed = key;
//    asm{
//                    lda ht_seed
//                    beq !doEor+
//                    asl
//                    beq !noEor+
//                    bcc !noEor+
//        !doEor:     eor #$2b
//        !noEor:     sta ht_seed
//    }
//    return ht_seed; // & HT_SIZE;
// }

inline ht_index_t ht_hash_next(ht_index_t index)
{
   return (index+1); // % HT_SIZE;
}

// ht_index_t ht_hash_next(ht_index_t index)
// {
//    asm{
//                    lda ht_seed
//                    beq !doEor+
//                    asl
//                    beq !noEor+
//                    bcc !noEor+
//        !doEor:    eor #$2b
//        !noEor:    sta ht_seed
//    }
//    return ht_seed;
// }

ht_index_t ht_get(ht_item_t* ht, ht_key_t key)
{

   ht_index_t ht_index = ht_hash(key);

   ht_index_t ht_next;
   ht_key_t ht_key;

   while ((ht_next = ht->next[ht_index])) {
      if ((ht_key = ht->key[ht_index]) == key) {
         return ht->next[ht_index];
      }
      ht_index = ht_hash_next(ht_index);
      // ht_index %= HT_SIZE;
   }

   return 0x00;
}

inline ht_index_t ht_get_next(ht_index_t ht_index)
{
   return ht_list.next[ht_index];
}

inline ht_data_t ht_get_data(ht_index_t ht_index)
{
   return ht_list.data[ht_index];
}

inline void ht_set_data(ht_index_t ht_index, ht_data_t ht_data)
{
   ht_list.data[ht_index] = ht_data;
}


ht_index_t ht_insert(ht_item_t* ht, ht_key_t key, ht_data_t data)
{
   ht_index_t ht_index = ht_hash(key);

   ht_index_t ht_next;
   ht_key_t ht_key;

   while ((ht_next = ht->next[ht_index]) && (ht_key = ht->key[ht_index]) != key) {
      ht_index = ht_hash_next(ht_index);
      // ht_index %= HT_SIZE;
   }

   ht->key[ht_index] = key;
   ht_list.data[ht_list_pool] = data;

   // There is already an entry in the main node, so we add this item as a new node in the duplicate list.
   // ht_index_t next = ht->next[ht_index];

   // Now the new node becomes the first node in the list;
   ht_list.next[ht_list_pool] = ht_next;
   ht->next[ht_index] = ht_list_pool;

   ht_list_pool--;

   return ht_index;
}

void ht_display(ht_item_t* ht)
{
   ht_index_t ht_index = 0;

   unsigned char col = 0;

   do {

      if (!col) {
         printf("%04X: ", ht_index);
      }
      if (ht->next[ht_index]==0xff) {
         printf(" ---- ");
      } else {
         printf(" %04X ", ht->key[ht_index]);
      }

      if (++col >= 8) {
         col = 0;
         printf("\n");
      }

      ht_index++;

   } while (ht_index > 0);

   printf("\n");
}

