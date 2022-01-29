#pragma var_model(mem)

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <cx16-heap.h>
#include <division.h>

unsigned int c = 8;
heap_handle heap_handles[256] = {0};
heap_size_packed heap_sizes[256] = {32, 32, 32, 32, 32, 32, 32, 32};

void key() {
	printf("print any key ...\n");
	while(!getin());
}

void handles() {
	for(word i=0; i<c; i++) {
		printf("%u:%04x ", i, heap_handles[i]);
		
	}
	printf("\n");
}

heap_handle heapalloc(heap_segment_id s1, word i) {
	heap_size size = heap_sizes[i];
	heap_handle h = heap_alloc(s1, size);
	printf("\nAllocate %u:%04x - ", i, h);
	heap_handles[i] = h;
	handles();
	return h;

}

void heapfree(heap_segment_id s1, word i) {
	printf("\nFree %u:%04x - ", i, heap_handles[i]);
	heap_free(s1, heap_handles[i]);
	heap_handles[i] = 0;
	handles();
}



void main() {

	byte s1 = 0;

	heap_address ha1 = heap_segment_bram(
		s1,
		heap_bram_pack(1, (bram_ptr_t)0xA000),
		heap_size_pack((dword)0x8000)
	); // add a segment of 8 banks * $2000 bytes + 1 bank of $1000 bytes;

	printf("Allocate heap blockswith random sizes.\n");

	for(word i=0; i<c; i++) {
		heapalloc(s1, i);
	}
	heap_dump(s1);
	key();

	heapfree(s1, 7);
	heap_dump(s1);
	key();

	printf("\nDone.\n");

}

