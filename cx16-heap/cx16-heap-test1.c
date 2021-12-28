#pragma var_model(mem)

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <cx16-heap.h>

void main() {

	byte s1 = 0;

	heap_address ha1 = heap_segment_bram(
		s1,
		cx16_bram_pack(1, (cx16_ptr)0xA000),
		cx16_size_pack((dword)0x8000)
	); // add a segment of 8 banks * $2000 bytes + 1 bank of $1000 bytes;


	for(int i=0;i<2;i++) {
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