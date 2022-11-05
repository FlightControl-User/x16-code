#pragma var_model(zp)

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <conio.h>
#include <ht.h>

ht_item_t ht;

void main()
{

   bank_set_brom(4);

   ht_init(&ht);

   clrscr();

   volatile char i = 0;
   volatile char ch = getin();
   do {
      ht_key_t key = i;
      ht_data_t data = i;
      ht_insert(&ht, key, data);
      gotoxy(0, 0);
      ht_display(&ht);
      i++;
      while(!(ch = getin()));
   } while (ch != 'x');
}
