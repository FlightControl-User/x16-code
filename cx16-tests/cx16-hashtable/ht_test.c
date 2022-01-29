#include <cx16.h>
#include <ht.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void main() {

   ht_size_t ht_size = 128;
   ht_item_t ht[128];

   ht_init(ht, ht_size);

   ht_insert(ht, 1, 20);
   ht_insert(ht, 2, 70);
   ht_insert(ht, 42, 80);
   ht_insert(ht, 4, 25);
   ht_insert(ht, 12, 44);
   ht_insert(ht, 14, 32);
   ht_insert(ht, 17, 11);
   ht_insert(ht, 13, 78);
   ht_insert(ht, 37, 97);
   ht_insert(ht, 45, 145);

   display(ht);
   
   ht_item_t* ht_item = ht_get(ht, 37);
   if(ht_item != NULL) {
      printf("Element found: %u\n", ht_item->data);
   } else {
      printf("Element not found\n");
   }

   ht_delete(ht, ht_item);
   ht_item = ht_get(ht, 37);

   if(ht_item != NULL) {
      printf("Element found: %u\n", ht_item->data);
   } else {
      printf("Element not found\n");
   }

   ht_item = ht_get(ht, 13);
   ht_delete(ht, ht_item);

   display(ht);

   ht_item = ht_get(ht, 45);

   if(ht_item != NULL) {
      printf("Element found: %u\n", ht_item->data);
   } else {
      printf("Element not found\n");
   }

}