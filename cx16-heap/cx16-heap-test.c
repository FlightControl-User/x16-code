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
		cx16_size_pack(1*0x2000)
	); // add a segment of 8 banks * $2000 bytes + 1 bank of $1000 bytes;

	static heap_handle h1 = heap_alloc(s1, 6);
	char* p1_data = (char*)heap_data_ptr(h1);

	heap_free(s1, h1);
}