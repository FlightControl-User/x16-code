//#pragma var_model(mem)

#define inline 

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <cx16-heap.h>

void main() {

	heap_segment_id s1 = 0;

	heap_address ha1 = heap_segment_bram(
		s1,
		heap_bram_pack(1, (heap_ptr)0xA000),
		heap_size_pack((heap_size_large)0x8000)
	); // add a segment of 8 banks * $2000 bytes + 1 bank of $1000 bytes;


	int i = 0;

	for(i=0; i<2; i++) {

		printf("\nAllocation:\n");

		heap_handle h0 = heap_alloc(s1, 16);
		strcpy((char*)heap_data_ptr(h0), "feel");

		heap_handle h2 = heap_alloc(s1, 64);
		strcpy((char*)heap_data_ptr(h2), "again");
		heap_dump(s1);

		printf("\nFree:\n");

		heap_free(s1, h2);
		heap_free(s1, h0);
		// heap_handle h1 = heap_alloc(s1, 32);
		// strcpy((char*)heap_data_ptr(h1), "good");
		// heap_free(s1, h1);
		heap_dump(s1);
	}

	printf("\nDone.\n");

}