
#include <cx16.h>
#include <ht.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void ht_init(ht_item_t* ht) 
{
   // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
   memset(ht,0x00,HT_SIZE*2);
   ht_list_index = 0xFF;
}

void ht_reset(ht_item_t* ht) 
{
   // heap_segment_reset(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
   memset(ht, 0x00, HT_SIZE*2);
   ht_list_index = 0xFF;
}


inline ht_index_t ht_code(ht_key_t key) 
{
   return HT_RANDOM[key];
}

inline ht_index_t ht_get(ht_item_t* ht, ht_key_t key) 
{
   ht_index_t ht_index = ht_code(key);

   while(ht->next[ht_index]) {
      if(ht->key[ht_index] == key)  {
         return ht->next[ht_index];
      }
      ht_index++;
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


inline ht_index_t ht_insert(ht_item_t* ht, ht_key_t key, ht_data_t data) 
{
   ht_index_t ht_index = ht_code(key);

   while(ht->next[ht_index] && ht->key[ht_index]!=key) {
      ht_index++;
      // ht_index %= HT_SIZE;
   }

   ht->key[ht_index] = key;

   // There is already an entry in the main node, so we add this item as a new node in the duplicate list.
   ht_index_t next = ht->next[ht_index];
   ht_list.data[ht_list_index] = data;

   // Now the new node becomes the first node in the list;
   ht_list.next[ht_list_index] = next;
   ht->next[ht_index] = ht_list_index;

   ht_list_index--;

   return ht_index;
}

void ht_display(ht_item_t* ht) {
   ht_index_t ht_index = 0;
	
   unsigned char col = 0;

   do {

      if(!col) {
         printf("%04X: ", ht_index);
      }
      if(!ht->next[ht_index]) {
         printf(" ---- ");
      } else {
         printf(" %04X ", ht->key[ht_index]);
      }
      
      if(++col >= 8) {
         col = 0;
         printf("\n");
      } 

      ht_index++;

   } while(ht_index > 0);
	
   printf("\n");
}

