#pragma var_model(mem)

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <cx16-conio.h>
#include <lru-cache.h>
#include <division.h>

lru_cache_table_t lru_cache;

volatile unsigned char floor_tile_row = 2;
volatile unsigned char col = 0;
volatile unsigned char count = 0;

void wait_key() {
	printf("print any key ...\n");
	while(!getin());
}

void display() {
    count++;
    floor_tile_row++;
    if(!(count % 16)) {
        floor_tile_row = 2;
        col += 8;
    }

    gotoxy(0,20);
        lru_cache_display(&lru_cache);

    wait_key();
}

void get(unsigned char key) {
    gotoxy(col, floor_tile_row);
    printf("get %02x", key);

    lru_cache_get(&lru_cache, lru_cache_index(&lru_cache, key));

    display();
}

void insert(unsigned char key, unsigned int data) {
    gotoxy(col, floor_tile_row);
    printf("Add %02x", key, data);

    lru_cache_insert(&lru_cache, key, data);

    display();
}

void delete(unsigned char key) {
    gotoxy(col, floor_tile_row);
    printf("Del %02x", key);

    lru_cache_delete(&lru_cache, key);

    display();
}

void main() {

    lru_cache_init(&lru_cache);

    clrscr();

    insert(1, 1);
    insert(2, 2);
    insert(3, 3);
    insert(4, 4);
    insert(5, 5);

    get(3);
    get(2);
    get(4);
    get(2);
    get(1);

    delete(3);
    delete(3);
    insert(3, 3);
}

