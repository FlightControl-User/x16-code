#include <conio.h>
#include <printf.h>

byte buffer1[10];
byte buffer2[10];

byte *buffers[3] = {&buffer1, &buffer2};

void swap() {
    buffers[0] = buffers[1];
    buffers[1] = buffers[2];
    buffers[2] = buffers[0];

    printf("\nt=%x, n=%x, o=%x", (word)*buffers[0], (word)*buffers[1], (word)*buffers[2]);
}

void main() {

    clrscr();
    gotoxy(0,0);
    printf("\nstart\nt=%x, n=%x, o=%x\nswapping\n", (word)*buffers[0], (word)*buffers[1], (word)*buffers[2]);

    swap();
    swap();
    swap();

}
