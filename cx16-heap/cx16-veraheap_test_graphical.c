#pragma var_model(mem) 

// #define VERAHEAP_DEBUG

#include <stdlib.h>
#include <cx16.h>
#include <cx16-veraheap.h>
#include <cx16-conio.h>

#pragma encoding(screencode_mixed)


void main() {

    vera_heap_bram_bank_init(1);

    vera_heap_segment_index_t s1 = vera_heap_segment_init(0, 0, 0x0000, 0, 0x8000);
    vera_heap_segment_index_t s2 = vera_heap_segment_init(1, 0, 0x0000, 1, 0xB000);

    vera_heap_index_t s2_handles[256];

    bgcolor(WHITE);
    textcolor(BLACK);
    clrscr();

    // char x = 0;
    // char y = 2;
    // for(unsigned char i=0;i<255;i++) {
    //     if(!((i % 32)+(i % 16))) {
    //         y = 2;
    //         x += 6;
    //     }
    //     gotoxy(x,y++);
    //     printf("%u %c", i, i);
    // }
    // while(!getin());
    
    // clrscr();

    unsigned long vram = 0x00000;
    unsigned char y = 4;
    while(vram < (unsigned long)0x1B000) {
        gotoxy(2, y);
        printf("%05x", vram);
        vram += 0x1000;
        gotoxy(74, y);
        printf("%05x", vram-(unsigned long)1);
        y++;
    }
    
    unsigned char weight[4] = { 31, 255, 7, 3 };
    unsigned int sizes[4] = { 256, 512, 1024, 2048 };
    unsigned char color[4] = { LIGHT_GREY, GREY, DARK_GREY, BLACK };

    while(!getin()) {

        unsigned int h = rand() % 256;
        if(h>=192)
            h=192;

        vera_heap_data_packed_t addr = 0;
        vera_heap_size_packed_t size = 0;

        // textcolor(BLACK);
        // vera_heap_dump_xy(0, 34);
        // vera_heap_dump_stats(s2);

        if(!s2_handles[h]) {
            unsigned int s = 0;
            unsigned char w = 0;
            do {
                s = rand() % 4;
                w = weight[s];
            } while((unsigned char)(rand() % 256) > w);
            unsigned int bytes = sizes[s];
            vera_heap_index_t index = vera_heap_alloc(s2, (unsigned long)bytes);
            if(index != VERAHEAP_NULL) {
                s2_handles[h] = index;
                addr = vera_heap_get_data_packed(s2, index);
                addr = addr >> 3;
                size = vera_heap_get_size_packed(s2, index);
                size = size >> 3;
                unsigned char code;
                if(size==4) code=0;
                if(size==8) code=1;
                if(size==16) code=2;
                if(size==32) code=3;
                textcolor(color[code]);
            } else {
                gotoxy(10, 33);
                printf("overflow!");
                while(!getin());
                gotoxy(10, 33);
                printf("         ");
            } 
        } else {
            // 1 chance in 2 that the block will be freed.
            // This puts more weight on allocation, instead of half/half.
            if(!(rand() % 2)) {
                vera_heap_index_t index = s2_handles[h];
                addr = vera_heap_get_data_packed(s2, index);
                addr = addr >> 3;
                size = vera_heap_get_size_packed(s2, index);
                size = size >> 3;
                vera_heap_free(s2, s2_handles[h]);
                s2_handles[h] = 0;
                textcolor(WHITE);
            }
        }

        unsigned char y = (unsigned char)(addr / 64);
        unsigned char x = (unsigned char)(addr % 64);

        for(unsigned int p=0; p<size; p++) {
            gotoxy(x+8, y+4);
            x++;
            if(p==0) {
                printf("%c", 108);
            } else {
                printf("%c", 121);
            }
            if(!(x % 64)) {
                y+=1;
                x=0;
            }
        }
    }
}