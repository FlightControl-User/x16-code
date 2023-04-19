#pragma link("lru-cache-bin.ld")
#pragma var_model(zp)

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

lru_cache_table_t lru_cache;


void wait_key()
{
    while (!kbhit())
        ;
}

// Only for debugging
void lru_cache_display()
{
    unsigned char col = 0;

    printf("least recently used cache statistics\n");
    printf("size = %3u, first = %2x, last = %2x, count = %2x\n\n", LRU_CACHE_SIZE, lru_cache.first, lru_cache.last, lru_cache.count);

    printf("least recently used hash table\n\n");

    printf("   ");
    do {
        printf("   %1x/%1x  ", col, col + 8);
        col++;
    } while (col < 8);
    printf("\n");

    col = 0;
    lru_cache_index_t index_row = 0;
    do {

        lru_cache_index_t index = index_row;
        printf("%02x:", index);
        do {
            if (lru_cache.key[index] != LRU_CACHE_NOTHING) {
                printf(" %04x:", lru_cache.key[index]);
                printf("%02x", lru_cache.link[index]);
            } else {
                printf(" ----:--");
            }
            index++;
        } while (index < index_row + 8);
        printf("\n");

        index = index_row;
        printf("  :");
        do {
            printf(" %02x:", lru_cache.next[index]);
            printf("%02x  ", lru_cache.prev[index]);
            index++;
        } while (index < index_row + 8);
        printf("\n");

        index_row += 8;
    } while (index_row < 128);

    printf("\n");

    printf("least recently used sequence\n");

    lru_cache_index_t index = lru_cache.first;
    lru_cache_index_t count = 0;
    col = 0;

    while (count < lru_cache.size) {
        if (count < lru_cache.count)
            printf(" %4x", lru_cache.key[index]);
        else
            printf("    ");
        //printf(" %4x %3uN %3uP ", lru_cache.key[cache_index], lru_cache.next[cache_index], lru_cache.prev[cache_index]);

        index = lru_cache.next[index];
        count++;
    }
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

void main() {

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

__export char LRU_CACHE[] = kickasm(resource "lru-cache-bin.asm") {{
    #import "lru-cache-bin.asm"
}};
