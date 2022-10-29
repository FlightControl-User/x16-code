#pragma var_model(mem)

#include <cx16-conio.h>
#include <cx16.h>
#include <division.h>
#include <lru-cache.h>
#include <stdio.h>
#include <string.h>

lru_cache_table_t lru_cache;

volatile unsigned char row = 2;
volatile unsigned char col = 0;
volatile unsigned char count = 0;

void wait_key() {
    printf("print any key ...\n");
    while (!getin())
        ;
}

void display() {
    count++;
    row++;
    if (!(count % 16)) {
        row = 2;
        col += 8;
    }

    gotoxy(0, 20);
    lru_cache_display(&lru_cache);

    wait_key();
}

void main() {
    lru_cache_init(&lru_cache);

    clrscr();

    for (unsigned int i = 0; i < 128; i++) {
        lru_cache_insert(&lru_cache, i, (unsigned int)i << 2);
    }

    // for (unsigned int j = 0; j < 1; j++) {
    //     for (unsigned int i = 0; i < 127; i++) {
    //         lru_cache_get(&lru_cache, lru_cache_index(&lru_cache, i));
    //     }
    // }

    for (unsigned int i = 0; i < 128; i++) {
        lru_cache_delete(&lru_cache, i);
    }

    for (unsigned int i = 0; i < 129; i++) {
        lru_cache_insert(&lru_cache, i, (unsigned int)i << 2);
    }


    display();
}
