#pragma var_model(zp)

#include <cx16.h>
#include <conio.h>
#include <stdio.h>
#include <kernal.h>

#define ELEMENTS 64

#define ALPHA 0
#define GAMMA 1

typedef unsigned char data_index_t;
typedef unsigned char data_type_t;

typedef struct {
    char used[ELEMENTS];
    char symbol[ELEMENTS];
    char next[ELEMENTS];
    char prev[ELEMENTS];
    char root[4];
    char index;
} data_t;

data_t data;

void data_debug(char c) {
    gotoxy(0+c,1);
    printf("ALPHA = %02x  GAMMA = %02x", data.root[ALPHA], data.root[GAMMA]);

    gotoxy(0+c,3);
    printf("ID C NE PR          ID C NR PR");
    gotoxy(0+c,4);
    printf("-- - -- --          -- - -- --");

    for(unsigned char index=0; index<ELEMENTS; index++) {
        char x = ((index / 32) * 20) + c;
        char y = (index % 32) + 5;

        gotoxy(x,y);
        printf("%02x %c %02x %02x", index, data.symbol[index], data.next[index], data.prev[index]); 
    }
}

data_index_t data_add(data_type_t type, char symbol) {

    data_debug(0);

    data.index %= ELEMENTS;
    while (!data.index || data.used[data.index]) {
        data.index = (data.index + 1) % ELEMENTS;
    }

    unsigned char index = data.index;
    // p.r = 3 => f[3].n = 2, f[2].n = 1, f[1].n = -
    //         => f[3].p = -, f[2].p = 3, f[1].p = 2
    // Add 4
    // p.r = 4 => f[4].n = 3, f[3].n = 2, f[2].n = 1, f[1].n = -
    // p.r = 4 => f[4].p = -, f[3].p = 4, f[2].p = 3, f[1].p = 2

    data_index_t root = data.root[type];
    data.next[index] = root;
    data.prev[index] = NULL;
    if (root)
        data.prev[root] = index;
    data.root[type] = index;

    data.used[index] = 1;
    data.symbol[index] = symbol;

    data_debug(40);

    while(!kbhit());

    return index;
}

void data_remove(data_type_t type, data_index_t index) {

    data_debug(0);

    if (data.used[index]) {
        data.used[index] = 0;

        // p.r = 4 => f[4].n = 3, f[3].n = 2, f[2].n = 1, f[1].n = -
        // p.r = 4 => f[4].p = -, f[3].p = 4, f[2].p = 3, f[1].p = 2
        // Remove 4
        // p.r = 3 => f[3].n = 2, f[2].n = 1, f[1].n = -
        //         => f[3].p = -, f[2].p = 3, f[1].p = 2

        data_index_t root = data.root[type];
        if(!data.next[root]) {
            data.root[type] = NULL;
        } else {
            data_index_t next = data.next[index];
            data_index_t prev = data.prev[index];
            if (next) {
                data.prev[next] = prev;
            }
            if (prev) {
                data.next[prev] = next;
            }
            if (root == index) {
                data.root[type] = next;
            }
        }
        data.next[index] = NULL;
        data.prev[index] = NULL;
        data.symbol[index] = '-';

    }
    data_debug(40);
    while(!kbhit());
}

data_index_t flight_root(data_type_t type) { return data.root[type]; }

data_index_t flight_next(data_index_t i) { return data.next[i]; }

data_index_t indexes[64];

void main() {
    clrscr();
    cx16_k_screen_set_charset(3, (char*)0);
    memset_fast(data.symbol, ' ', ELEMENTS);

    char a = data_add(ALPHA, 'A');
    char b = data_add(ALPHA, 'B');
    char x = data_add(GAMMA, 'X');
    char y = data_add(GAMMA, 'Y');
    char c = data_add(ALPHA, 'C');
    char z = data_add(GAMMA, 'Z');

    data_remove(ALPHA, b);
    data_remove(ALPHA, c);
    data_remove(ALPHA, a);

    a = data_add(ALPHA, 'A');
    b = data_add(ALPHA, 'B');
    c = data_add(ALPHA, 'C');

    for(unsigned char i=0; i<=56; i++) {
        indexes[i] = data_add(ALPHA, 'a' + i);
    }

    data_remove(GAMMA, z);
    data_remove(GAMMA, y);
    data_remove(GAMMA, x);

    for(unsigned char i=0; i<=56; i++) {
        data_remove(ALPHA, indexes[i]);
    }

}
