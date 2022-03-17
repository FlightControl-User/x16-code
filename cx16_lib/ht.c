
#include <cx16.h>
#include <ht.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void ht_init(ht_item_ptr_t ht, ht_size_t ht_size) 
{
   // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
   memset(ht,0,ht_size*4);
   ht_list_index = 0;
}

void ht_reset(ht_item_ptr_t ht, ht_size_t ht_size) 
{
   // heap_segment_reset(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
   memset(ht,0,ht_size*4);
   ht_list_index = 0;
}

void ht_clean(ht_item_ptr_t ht, ht_size_t ht_size) 
{

   for(ht_index_t ht_index = 0; ht_index<ht_size; ht_index++) {
      if(!ht[ht_index].key) {
         ht[ht_index].key = 0xFFFF;
         ht[ht_index].next = NULL;
      }
   }
}

inline ht_index_t ht_code(ht_size_t ht_size, ht_key_t key) 
{
   return (key) % ht_size;
}

inline ht_list_ptr_t ht_get(ht_item_ptr_t ht, ht_size_t ht_size, ht_key_t key) 
{
   ht_index_t ht_index = ht_code(ht_size, key);
   return ht[ht_index].next;
}

inline ht_list_ptr_t ht_get_next(ht_list_ptr_t ht_list) 
{
   return ht_list->next;
}

inline ht_list_ptr_t ht_insert(ht_item_ptr_t ht, ht_size_t ht_size, ht_key_t key, ht_data_t data) 
{
   ht_index_t ht_index = ht_code(ht_size, key);
   ht[ht_index].key = key;

   // There is already an entry in the main node, so we add this item as a new node in the duplicate list.
   ht_list_ptr_t next = ht[ht_index].next;
   ht_list_ptr_t ht_list_ptr = &ht_list[ht_list_index++];
   ht_list_ptr->data = data;

   // Now the new node becomes the first node in the list;
   ht_list_ptr->next = next;
   ht[ht_index].next = ht_list_ptr;

   return ht_list_ptr;
}

void ht_display(ht_item_ptr_t ht, ht_size_t ht_size) {
   ht_index_t ht_index = 0;
	
   unsigned char col = 0;
   for(ht_index = 0; ht_index<ht_size; ht_index++) {

      if(!col) {
         printf("%04X: ", ht_index);
      }
      if(ht[ht_index].key == 0xFFFF) {
         printf(" ---- ");
      } else {
         printf(" %04X ", ht[ht_index].key);
      }
      
      if(++col >= 8) {
         col = 0;
         printf("\n");
      } 
   }
	
   printf("\n");
}

