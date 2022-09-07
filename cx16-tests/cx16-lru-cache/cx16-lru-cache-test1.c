#pragma var_model(mem)

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <cx16-conio.h>
#include <lru-cache.h>
#include <division.h>

lru_cache_table_t lru_cache;

volatile unsigned char row = 2;
volatile unsigned char col = 0;
volatile unsigned char count = 0;

void wait_key() {
	printf("print any key ...\n");
	while(!getin());
}

void display() {
    count++;
    row++;
    if(!(count % 16)) {
        row = 2;
        col += 20;
    }

    gotoxy(0,20);
        lru_cache_display(&lru_cache);

    wait_key();
}

void get(unsigned char key) {
    gotoxy(col, row);
    printf("get %02u", key);

    lru_cache_get(&lru_cache, lru_cache_index(&lru_cache, key));

    display();
}

void insert(unsigned char key, unsigned int data) {
    gotoxy(col, row);
    printf("Added %02u - %04x", key, data);

    lru_cache_insert(&lru_cache, key, data);

    display();
}

void delete(unsigned char key) {
    gotoxy(col, row);
    printf("Removed %02u", key);

    lru_cache_delete(&lru_cache, key);

    display();
}

void main() {

    lru_cache_init(&lru_cache);

    clrscr();

    insert(0, 0x0000);
    insert(1, 0x0100);
    insert(2, 0x0200);
    get(1);
    get(0);
    get(2);
    insert(8, 0x0800);
    delete(1);
    get(2);
    insert(1,0x0100);
    insert(9,0x0900);
    insert(20,0x2000);
    insert(21,0x2100);
    insert(22,0x2200);
    insert(23,0x2300);
    insert(24,0x2400);
    insert(25,0x2500);
    delete(22);
    insert(26,0x2600);
    insert(27,0x2700);

    get(0);


}

