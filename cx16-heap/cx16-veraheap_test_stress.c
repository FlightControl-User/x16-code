// #pragma var_model(mem) 

#define VERAHEAP_DEBUG

#include <stdlib.h>
#include <cx16.h>
#include <cx16-veraheap.h>


void main() {

    vera_heap_bram_bank_init(1);

    // vera_heap_segment_index_t s1 = vera_heap_segment_init(0, 0, 0x0000, 0, 0x8000);
    vera_heap_segment_index_t s2 = vera_heap_segment_init(1, 0, 0x0000, 1, 0xB000);

    vera_heap_handle_t s2_handles[256];

    while(!getin()) {

        clrscr();

        gotoxy(0, 0);
        printf("Before Dump");
        vera_heap_dump(s2, 0, 2);

        printf("\n\n");

        unsigned int h = rand() % 32;
        h += rand() % 16;
        if(!s2_handles[h]) {
            vera_heap_size_t bytes = (unsigned long)((rand()%512)+1);
            printf("Allocate %u bytes in segment 2\n\n", bytes);
            s2_handles[h] = vera_heap_alloc(s2, bytes);
        } else {
            printf("Free handle %03x from segment 2\n\n", s2_handles[h]);
            vera_heap_free(s2, s2_handles[h]);
            s2_handles[h] = 0;
        }

        gotoxy(40, 0);
        printf("After Dump");
        vera_heap_dump(s2, 40, 2);
        // while(!getin());
    }

}