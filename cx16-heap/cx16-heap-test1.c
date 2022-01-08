#pragma var_model(mem)

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <cx16-heap.h>

typedef struct {

	int x;
	int y;
	int z;

} TEST;


void main() {

	heap_segment_id s1 = 0;

	heap_address ha1 = heap_segment_bram(
		s1,
		heap_bram_pack(1, (heap_ptr)0xA000),
		heap_size_pack((heap_size_large)0x8000)
	); // add a segment of 8 banks * $2000 bytes + 1 bank of $1000 bytes;


	printf("\nAllocation:\n");

	heap_handle h0 = heap_alloc(s1, sizeof(TEST));
	strcpy((char*)heap_data_ptr(h0), "feel");

	TEST* p = (TEST*)heap_data_ptr(h0);

	p->x = 5;
	p->y = 10;
	p->z = 50;

	heap_dump(s1);

	printf("\nVector: x=%i, y=%i,z= %i\n", p->x, p->y, p->z);

	printf("\nFree:\n");

	heap_free(s1, h0);

	printf("\nDone.\n");

}