#pragma var_model(zp)

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <conio.h>
#include <cx16-conio.h>
#include <lru-cache.h>
#include <division.h>

lru_cache_table_t lru_cache;

volatile unsigned char row = 0;
volatile unsigned char col = 0;
volatile unsigned char count = 0;

void wait_key()
{
    while (!getin())
        ;
}

void display()
{
    count++;
    col = (count / 8) * 16;
    row = (count % 8);

    count = count % 32;

    gotoxy(0, 9);
    lru_cache_display(&lru_cache);

    wait_key();
}

lru_cache_data_t get(lru_cache_key_t key)
{
    gotoxy(col, row);
    printf("get %04x", key);

    lru_cache_data_t data = lru_cache_get(&lru_cache, lru_cache_index(&lru_cache, key));

    printf(":%04x", data);

    display();

    return data;
}

void set(lru_cache_key_t key, lru_cache_data_t data)
{
    gotoxy(col, row);
    printf("set %04x:%04x", key, data);

    lru_cache_set(&lru_cache, lru_cache_index(&lru_cache, key), data);

    display();
}

void insert(lru_cache_key_t key, lru_cache_data_t data)
{
    gotoxy(col, row);
    printf("Add %04x:%04x", key, data);

    lru_cache_insert(&lru_cache, key, data);

    display();
}

void delete (lru_cache_key_t key)
{
    gotoxy(col, row);
    printf("Del %04x", key);

    lru_cache_delete(&lru_cache, key);

    display();
}

void main()
{
    lru_cache_init(&lru_cache);

    bgcolor(BROWN);
    textcolor(WHITE);
    clrscr();
    scroll(0);

    int cache[128];

    char ch = getin();
    do {
        if (lru_cache_is_max(&lru_cache)) {
            lru_cache_key_t last = lru_cache_find_last(&lru_cache);
            delete(last);
        } else {
            lru_cache_key_t key = rand() % 0x100;
            lru_cache_data_t data = get(key);
            if (data != LRU_CACHE_NOTHING) {
                data += 1;
                if (data < 2) {
                    set(key, data);
                } else {
                    delete(key);
                }
            } else {
                insert(key, 0);
            }
        }
        ch = getin();
    } while (ch != 'x');
}
