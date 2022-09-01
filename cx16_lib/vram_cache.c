
#include <cx16.h>
#include <vram_cache.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void vram_cache_init(vram_cache_item_t* ht) 
{
   // heap_segment_define(&vram_cache_heap, &vram_cache_heap_list, 8, vram_cache_size, 8*vram_cache_size); // Each list item is maximum 8 bytes on the heap!
   memset(ht,0x00,vram_cache_SIZE*2);
   vram_cache_list_index = 0xFF;
}

void vram_cache_reset(vram_cache_item_t* ht) 
{
   // heap_segment_reset(&vram_cache_heap, &vram_cache_heap_list, 8, vram_cache_size, 8*vram_cache_size); // Each list item is maximum 8 bytes on the heap!
   memset(ht, 0x00, vram_cache_SIZE*2);
   vram_cache_list_index = 0xFF;
}


inline vram_cache_index_t vram_cache_code(vram_cache_key_t key) 
{
   return key % 128;
}

inline vram_cache_index_t vram_cache_get(vram_cache_item_t* ht, vram_cache_key_t key) 
{
   vram_cache_index_t vram_cache_index = vram_cache_code(key);

   while(ht->next[vram_cache_index]) {
      if(ht->key[vram_cache_index] == key)  {
         return ht->next[vram_cache_index];
      }
      vram_cache_index++;
      // vram_cache_index %= vram_cache_SIZE;
   }

   return 0x00;
}

inline vram_cache_index_t vram_cache_get_next(vram_cache_index_t vram_cache_index) 
{
   return vram_cache_list.next[vram_cache_index];
}

inline vram_cache_data_t vram_cache_get_data(vram_cache_index_t vram_cache_index) 
{
   return vram_cache_list.data[vram_cache_index];
}


inline vram_cache_index_t vram_cache_insert(vram_cache_item_t* ht, vram_cache_key_t key, vram_cache_data_t data) 
{
   vram_cache_index_t vram_cache_index = vram_cache_code(key);

   while(ht->next[vram_cache_index] && ht->key[vram_cache_index]!=key) {
      vram_cache_index++;
      // vram_cache_index %= vram_cache_SIZE;
   }

   ht->key[vram_cache_index] = key;

   // There is already an entry in the main node, so we add this item as a new node in the duplicate list.
   vram_cache_index_t next = ht->next[vram_cache_index];
   vram_cache_list.data[vram_cache_list_index] = data;

   // Now the new node becomes the first node in the list;
   vram_cache_list.next[vram_cache_list_index] = next;
   ht->next[vram_cache_index] = vram_cache_list_index;

   vram_cache_list_index--;

   return vram_cache_index;
}

void vram_cache_display(vram_cache_item_t* ht) {
   vram_cache_index_t vram_cache_index = 0;
	
   unsigned char col = 0;

   do {

      if(!col) {
         printf("%04X: ", vram_cache_index);
      }
      if(!ht->next[vram_cache_index]) {
         printf(" ---- ");
      } else {
         printf(" %04X ", ht->key[vram_cache_index]);
      }
      
      if(++col >= 8) {
         col = 0;
         printf("\n");
      } 

      vram_cache_index++;

   } while(vram_cache_index > 0);
	
   printf("\n");
}

