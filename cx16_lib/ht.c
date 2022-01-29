#include <cx16.h>
#include <ht.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

ht_size_t ht_size;

void ht_init(ht_t ht, ht_size_t ht_size_init) {
   ht_size = ht_size_init;
   for(ht_index_t ht_index = 0; ht_index<ht_size; ht_index++) {
      ht[ht_index].key = 0xFFFF;
      ht[ht_index].data = NULL;
   }
}

unsigned int ht_code(ht_key_t key) {
   return key % ht_size;
}

ht_item_t* ht_get(ht_t ht, ht_key_t key) {

   ht_index_t ht_index = ht_code(key);  
	
   while(ht[ht_index].data != NULL) {
      if(ht[ht_index].key == key)
         return &ht[ht_index]; 
      ++ht_index;
      ht_index %= ht_size;
   }        
   return NULL;        
}

void ht_insert(ht_t ht, ht_key_t key, ht_data_t data) {

   ht_index_t ht_index = ht_code(key);
   while(ht[ht_index].data != NULL) {
      ++ht_index;
      ht_index %= ht_size;
   }
   ht[ht_index].key = key;
   ht[ht_index].data = data;
}

ht_item_t* ht_delete(ht_t ht, ht_item_t* item) {
   ht_key_t key = item->key;
   ht_index_t ht_index = ht_code(key);
   while(ht[ht_index].data != NULL) {
      if(ht[ht_index].key == key) {
         ht_item_t* temp = &ht[ht_index]; 
         ht[ht_index].key = 0xFFFF; 
         ht[ht_index].data = 0xFFFF;
         return temp;
      }
      ++ht_index;
      ht_index %= ht_size;
   }      
	
   return NULL;        
}

void display(ht_t ht) {
   ht_index_t ht_index = 0;
	
   for(ht_index = 0; ht_index<ht_size; ht_index++) {
	
      if(ht[ht_index].data != NULL) {
         printf("%4x - %4x     ",ht[ht_index].key,ht[ht_index].data);
      }
      else
         printf("---- - ----     ");
   }
	
   printf("\n");
}

