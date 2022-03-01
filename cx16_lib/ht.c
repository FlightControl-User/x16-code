
#include <cx16.h>
#include <ht.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void ht_init(ht_t ht, ht_size_t ht_size) {
   for(ht_index_t ht_index = 0; ht_index<ht_size; ht_index++) {
      ht[ht_index].key = 0xFFFF;
      ht[ht_index].data = NULL;
   }
}

unsigned int ht_code(ht_size_t ht_size, ht_key_t key) {
   return (key << 3) % ht_size;
}

ht_item_t* ht_get(ht_t ht, ht_size_t ht_size, ht_key_t key) {

   ht_index_t ht_index = ht_code(ht_size, key);  
	
   while(ht[ht_index].data != NULL) {
      if(ht[ht_index].key == key)
         return &ht[ht_index]; 
      ++ht_index;
      ht_index %= ht_size;
   }        
   return NULL;        
}

inline ht_item_t* ht_get_next(ht_t ht, ht_size_t ht_size, ht_key_t key, ht_item_t* ht_item) {

   ht_index_t ht_index = ((unsigned int)(ht_item - ht))/sizeof(ht_item_t);
   ++ht_index;
   ht_index %= ht_size;
	
   while(ht[ht_index].data != NULL) {
      if(ht[ht_index].key == key)
         if(ht_item != &ht[ht_index])
            return &ht[ht_index];
         else
            return NULL; 
      ++ht_index;
      ht_index %= ht_size;
   }        
   return NULL;        
}

ht_item_t* ht_insert(ht_t ht, ht_size_t ht_size, ht_key_t key, ht_data_t data) {

   ht_index_t ht_index = ht_code(ht_size, key);
   while(ht[ht_index].data != NULL && ht[ht_index].key != 0xFFFF) {
      ++ht_index;
      ht_index %= ht_size;
   }
   ht[ht_index].key = key;
   ht[ht_index].data = data;
   return &ht[ht_index];
}

ht_item_t* ht_delete(ht_t ht, ht_size_t ht_size, ht_item_t* item) {
   item->key = 0xFFFF; 
   item->data = 0xFFFF;
   return item;
}

void ht_display(ht_t ht, ht_size_t ht_size) {
   ht_index_t ht_index = 0;
	
   unsigned char col = 0;
   for(ht_index = 0; ht_index<ht_size; ht_index++) {

      if(!col) {
         printf("%04X: ", ht_index);
      }
      if(ht[ht_index].data != NULL) {
         if(ht[ht_index].key == 0xFFFF) {
            printf(" **** ");
         } else {
            printf(" %04X ", ht[ht_index].key);

         }
      }
      else
         printf(" ---- ");
      
      if(++col >= 8) {
         col = 0;
         printf("\n");
      } 
   }
	
   printf("\n");
}

