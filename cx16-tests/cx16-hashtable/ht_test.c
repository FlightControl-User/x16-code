#include <cx16.h>
#include <ht.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


void main() {

   ht_size_t ht_size = 128;
   ht_item_t ht[128];

   ht_init(ht);

   clrscr();
   while(!getin()) {

      unsigned int ht_key = rand() & 0b1111;
      unsigned int ht_data = rand() & 0b11;
      ht_item_t* ht_item = ht_get_duplicate(ht, ht_size, ht_key, ht_data);
      if(ht_item != NULL) {
         ht_delete(ht, ht_size, ht_item);
      } else {
         ht_insert(ht, ht_size, ht_key, ht_data);
      }
      gotoxy(0,0);
      ht_display(ht, ht_size);
   }


}