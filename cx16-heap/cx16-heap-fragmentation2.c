// Demonstrating the heap manager in a graphical way

#pragma var_model(mem)

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <cx16-heap.h>
#include <cx16-vera.h>
#include <cx16-bitmap.h>
#include <division.h>


void main() {

    clrscr();

	byte s1 = 0; // Heap Segment 0, we have 16 of them ...

	heap_address ha1 = heap_segment_bram(
		s1,
		cx16_bram_pack(1, (bram_ptr_t)0xA000),
		cx16_size_pack((dword)0x44000)
	); // add a segment of 8 banks * $2000 bytes + 1 bank of $1000 bytes;


	unsigned int c = 1024;
	heap_handle heap_handles[2048] = {0};

	while(!getin()) {
		unsigned int i = modr16u(rand(),c,0);
		heap_handle indexHeap = heap_handles[i];
		if(indexHeap) {
			heap_handles[i] = 0;
			heap_handle indexFree = heap_free(s1, indexHeap);
			heap_size_packed sizeHeap = heap_size_get(indexHeap);
			heap_handle dataHeap = heap_data_get(indexHeap);
		} else {
			heap_size_packed size = modr16u(rand(), 0x1FF,0)+1;
			heap_handle indexHeap = heap_alloc(s1, size);
			heap_size_packed sizeHeap = heap_size_get(indexHeap);
			heap_handle dataHeap = heap_data_get(indexHeap);
			heap_handles[i] = indexHeap;
		}
		gotoxy(0,18);
		heap_dump_stats(s1);
		// while(!getin());
	}

	gotoxy(0,23);
	printf("done.\n", c);

	while(!getin());

	for(word i=0; i<c; i++) {
		heap_handle indexHeap = heap_handles[i];
		if(indexHeap) {
			heap_handle indexFree = heap_free(s1, heap_handles[i]);
			heap_handle indexHeap = heap_handles[i];
			heap_size_packed sizeHeap = heap_size_get(indexHeap);
			heap_handle dataHeap = heap_data_get(indexHeap);
		}
	}

	gotoxy(0,24);
	printf("Done.\n");

}