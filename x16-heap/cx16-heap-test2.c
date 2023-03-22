#pragma var_model(mem)

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <cx16-heap.h>
#include <division.h>


void main() {

	byte s1 = 0;

	heap_address ha1 = heap_segment_bram(
		s1,
		cx16_bram_pack(1, (bram_ptr_t)0xA000),
		cx16_size_pack((dword)0x8000)
	); // add a segment of 8 banks * $2000 bytes + 1 bank of $1000 bytes;

	unsigned int c = 2;
	heap_handle heap_handles[2048] = {0};

	printf("Allocate and Free heap blocks in random order.\n");
	while(!kbhit()) {
		unsigned int i = modr16u(rand(),c,0);
		heap_handle indexHeap = heap_handles[i];
		if(indexHeap) {
			printf("\nFree %x - ", indexHeap);
			heap_free(s1, indexHeap);
			heap_handles[i] = 0;
		} else {
			heap_size_packed size = modr16u(rand(),126,0)+1;
			heap_handle h = heap_alloc(s1, size);
			printf("\nAllocate %x - ", h);
			*(word*)heap_data_ptr(h) = i;
			heap_handles[i] = h;
		}

		for(unsigned int j=0;j<c;j++)
			printf("%u=%x ", j, heap_handles[j]);
		printf("\n");

		// printf("list = %x", s->heapList);
		heap_dump(s1);

		while(!kbhit());
	}

	printf("\nDone.\n");

}