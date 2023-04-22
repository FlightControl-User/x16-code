#pragma var_model(zp)
#pragma target(C128)

#include <c128.h>
#include <stdio.h>
#include <string.h>
#include <conio.h>
#include <lru-cache.h>
#include <division.h>

volatile unsigned char row = 0;
volatile unsigned char col = 0;
volatile unsigned char count = 0;

void wait_key()
{
    while (!kbhit())
        ;
}

void display()
{
    count++;
    col = (count / 8) * 16;
    row = (count % 8);

    count = count % 32;

    gotoxy(0, 9);
    lru_cache_display();

    wait_key();
}

lru_cache_data_t get(lru_cache_key_t key)
{
    gotoxy(col, row);
    printf("get %04x", key);

    lru_cache_data_t data = lru_cache_get(lru_cache_index(key));

    printf(":%04x", data);

    display();

    return data;
}

void set(lru_cache_key_t key, lru_cache_data_t data)
{
    gotoxy(col, row);
    printf("set %04x:%04x", key, data);

    lru_cache_set(lru_cache_index(key), data);

    display();
}

void insert(lru_cache_key_t key, lru_cache_data_t data)
{
    gotoxy(col, row);
    printf("Add %04x:%04x", key, data);

    lru_cache_insert(key, data);

    display();
}

void delete (lru_cache_key_t key)
{
    gotoxy(col, row);
    printf("Del %04x", key);

    lru_cache_delete(key);

    display();
}

void main()
{
    lru_cache_init();

    bgcolor(BROWN);
    textcolor(WHITE);
    clrscr();
    scroll(0);

    int cache[128];

    char ch = kbhit();
    do {
        if (lru_cache_is_max()) {
            lru_cache_key_t last = lru_cache_find_last();
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
        ch = kbhit();
    } while (ch != 'x');
}
