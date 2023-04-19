#pragma link("lru-cache-test.ld")
#pragma var_model(mem)

#pragma zp_reserve(0x00..0x32, 0x80..0xA8)


#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <conio.h>
#include <cx16-conio.h>
#include <lru-cache-lib.h>
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

    lru_cache_display(0, 9);

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

void main() {
    
    kickasm {{
        jsr lru_cache.__start 
    }}
    lru_cache_init();

    bgcolor(BROWN);
    textcolor(WHITE);
    clrscr();

    insert(0x0, 0x0);
    insert(0x80, 0x80);
    insert(0x100, 0x100);
    insert(0x1, 0x1);
    insert(0x200, 0x200);
    insert(0x2, 0x2);
    insert(0x82, 0x82);
    delete(0x0);
    delete(0x100);
    delete(0x80);
    delete(0x1);
    insert(0x201, 0x201);
    insert(0x81, 0x81);
    delete(0x2);
    delete(0x81);
    delete(0x201);
    delete(0x82);
    delete(0x200);
}

__export char LRU_CACHE[] = kickasm(resource "lru-cache.asm") {{
    #import "lru-cache.asm"
}};
