#pragma var_model(zp)

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
        col += 8;
    }

    gotoxy(0,20);
        lru_cache_display(&lru_cache);

    wait_key();
}

void get(unsigned char key) {
    gotoxy(col, row);
    printf("get %02x", key);

    lru_cache_get(&lru_cache, lru_cache_index(&lru_cache, key));

    display();
}

void insert(unsigned char key, unsigned int data) {
    gotoxy(col, row);
    printf("Add %02x", key, data);

    lru_cache_insert(&lru_cache, key, data);

    display();
}

void delete(unsigned char key) {
    gotoxy(col, row);
    printf("Del %02x", key);

    lru_cache_delete(&lru_cache, key);

    display();
}

void main() {

    lru_cache_init(&lru_cache);

    clrscr();

    for(unsigned int i=0; i<127; i++) {
        insert(i, (unsigned int)i << 2);
    }

    get(1);
    get(0);
    get(2);
    delete(1);
    get(2);
    delete(6);
    delete(8);
    delete(20);
    delete(40);
    delete(126);
    delete(127);
    get(0);
    get(39);
    get(41);
}

