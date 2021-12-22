#include <stdio.h>
#include <string.h>
#include <cx16-heap.h>

void main() {

	heap_segment s1 = heap_segment_bram(0, 10, 0xB000, 1, 0xA000 ); // add a segment of 8 banks * $2000 bytes + 1 bank of $1000 bytes;

	printf("\nTC01: First allocation of header 0[8,\"A:8\"] bytes.\n");
	heap_handle h1 = heap_alloc(s1, 6);
	char* p1_data = (char*)heap_data_ptr(h1);
	heap_index_size p1_size = heap_header_size_get(h1);
	strcpy(p1_data, "A:8");
	heap_dump(s1);

	printf("\nThe data of p1_data resides in bram bank %x\n", heap_data_bank(h1));

	printf("\nTC02: Second allocation of B:16 bytes.\n");
	heap_handle h2 = heap_alloc(s1, 12);
	char* p2_data = (char*)heap_data_ptr(h2);
	heap_index_size p2_size = heap_header_size_get(h2);
	strcpy(p2_data, "B:16");
	heap_dump(s1);

	printf("\nTC03: Third allocation of C:8 bytes.\n");
	heap_handle h3 = heap_alloc(s1,6);
	char* p3_data = (char*)heap_data_ptr(h3);
	heap_index_size p3_size = heap_header_size_get(h3);
	strcpy(p3_data, "C:8");
	heap_dump(s1);

	printf("\nTC04: More allocation of D:8, E:8, F:8, G:16, H:8 bytes.\n");
	heap_handle h4 = heap_alloc(s1,6);
	char* p4_data = (char*)heap_data_ptr(h4);
	printf("p4_data: $%04p\n", p4_data);
	strcpy(p4_data, "D:8");
	heap_dump(s1);

	heap_handle h5 = heap_alloc(s1,8);
	strcpy((char*)heap_data_ptr(h5), "E:8");
	heap_handle h6 = heap_alloc(s1,8);
	char* p6_data = (char*)heap_data_ptr(h6);
	strcpy(p6_data, "F:8");
	heap_handle h7 = heap_alloc(s1,16);
	char* p7_data = (char*)heap_data_ptr(h7);
	strcpy(p7_data, "G:16");
	heap_handle h8 = heap_alloc(s1,8);
	char* p8_data = (char*)heap_data_ptr(h8);
	strcpy(p8_data, "H:8");
	heap_dump(s1);

	printf("\nEnd of alloc memory, press any key to continue to the free memory without coalescing\n");
	while(!getin());

	printf("\n\nStart Heap position before free memory:\n");
	heap_dump(s1);

	printf("\nTC05: First free of header 5[8,\"E:8\"] bytes.\n");
	heap_free(s1, h5);
	heap_dump(s1);

	printf("\nTC06: Second free of header 3[8,\"C:8\"] bytes.\n");
	heap_free(s1, h3);
	heap_dump(s1);

	printf("\nTC07: Third free of header 6[16,\"G:16\"] bytes.\n");
	heap_free(s1, h7);
	heap_dump(s1);

	printf("\nEnd of free memory without coalescing, press any key to continue to the free memory with coalescing\n");
	while(!getin());

	printf("\n\nStart Heap position before free memory with coalescing:\n");
	heap_dump(s1);

	printf("\nTC08: Free of header 1[16,\"B:16\"] bytes,\n");
	printf("coalescing to the right with header 2[8,\"C:8\"]\n");
	heap_free(s1, h2);
	heap_dump(s1);

	printf("\nTC09: Free of header 7[8,\"H:8\"] bytes,\n");
	printf("coalescing to the left with header 6[8,\"G:16\"]\n");
	heap_free(s1, h8);
	heap_dump(s1);

	printf("\nTC10: Free of header 3[8,\"D:8\"] bytes,\n");
	printf("coalescing to the left with header 1[8,\"E:8\"],\n");
	printf("coalescing to the right with header 4[24,\"B:16\"].\n");
	heap_free(s1, h4);
	heap_dump(s1);

	printf("\nTC11: Allocate new header of 32 bytes,\n");
	printf("splitting header 3[40,\"E:8\"] into free header 4[8,\"E:8\",7,7],\n");
	printf("and used header 3[32,\"I:32\",0,5].\n");
	heap_handle p10 = heap_alloc(s1, 32);
	char* p10_data = (char*)heap_data_ptr(p10);
	strcpy(p10_data, "I:32");
	heap_dump(s1);

	printf("\nTC12: Allocate blocks of 8 bytes.\n");
	heap_handle p11 = heap_alloc(s1, 8);
	strcpy((char*)heap_data_ptr(p11), "J:8");
	heap_dump(s1);

	printf("\nTC13: Allocate blocks of 8 bytes.\n");
	heap_handle p12 = heap_alloc(s1, 8);
	strcpy((char*)heap_data_ptr(p12), "K:8");
	heap_dump(s1);

}