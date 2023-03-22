// Demonstrating the heap manager in a graphical way

#pragma var_model(mem)

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <cx16-heap.h>
#include <cx16-vera.h>
#include <cx16-bitmap.h>
#include <division.h>

void plot_block(word x, word y, word size, byte color) {
	for(unsigned int s=0; s<size; s++) {
		bitmap_plot(x, y, color);
		x++;
		if(x >= 256) {
			x=0;
			y++;
		}
	}
}

void plot_handle(heap_handle handle, word size, byte color) {

	word y = (word)div16u(handle, 256);
	word x = rem16u;
	plot_block(x, y, size, color);
}

void main() {

	// We are going to use only the kernal on the X16.
    bank_set_brom(CX16_ROM_KERNAL);

    memcpy_vram_vram(1, 0xF000, 0, 0xF800, 256*8); // We copy the 128 character set of 8 bytes each.
    vera_layer_mode_tile(1, 0x14000, 0x1F000, 128, 64, 8, 8, 1);

    vera_layer_mode_bitmap(0, (dword)0x00000, 320, 2);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    bitmap_init(0, 0x00000);
    bitmap_clear();
	vera_layer_show(0);

	byte s1 = 0; // Heap Segment 0, we have 16 of them ...

	heap_address ha1 = heap_segment_bram( 
		s1,
		heap_bram_pack(1, (heap_ptr)0xA000),
		heap_size_pack((heap_size_large)0x44000)
	); // add a segment of 8 banks * $2000 bytes + 1 bank of $1000 bytes;

	unsigned int c = 1024;
	heap_handle heap_handles[2048] = {0};

	while(!kbhit()) {
		unsigned int i = modr16u(rand(),c,0);
		heap_handle indexHeap = heap_handles[i];
		if(indexHeap) {
			heap_handles[i] = 0;
			heap_handle indexFree = heap_free(s1, indexHeap);
			heap_size_packed sizeHeap = heap_size_get(indexHeap);
			heap_handle dataHeap = heap_data_get(indexHeap);
			plot_handle(dataHeap, sizeHeap / 8, 2);
			plot_handle(indexHeap, 1, 2);
			plot_handle(indexFree, 1, 2);
		} else {
			heap_size_packed size = modr16u(rand(), 0x1FF,0)+1;
			heap_handle indexHeap = heap_alloc(s1, size);
			heap_size_packed sizeHeap = heap_size_get(indexHeap);
			heap_handle dataHeap = heap_data_get(indexHeap);
			plot_handle(dataHeap, sizeHeap / 8, 1);
			plot_handle(indexHeap, 1, 1);
			heap_handles[i] = indexHeap;
		}
		gotoxy(0,18);
		heap_dump_stats(s1);
		// while(!kbhit());
	}

	gotoxy(0,23);
	printf("done.\n", c);

	while(!kbhit());

	for(word i=0; i<c; i++) {
		heap_handle indexHeap = heap_handles[i];
		if(indexHeap) {
			heap_handle indexFree = heap_free(s1, heap_handles[i]);
			heap_handle indexHeap = heap_handles[i];
			heap_size_packed sizeHeap = heap_size_get(indexHeap);
			heap_handle dataHeap = heap_data_get(indexHeap);
			plot_handle(dataHeap, sizeHeap / 8, 2);
			plot_handle(indexHeap, 1, 2);
			plot_handle(indexFree, 1, 2);
		}
	}

	gotoxy(0,24);
	printf("Done.\n");

}