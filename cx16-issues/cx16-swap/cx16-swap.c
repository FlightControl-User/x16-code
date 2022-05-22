#include <conio.h>
#include <printf.h>

byte buffer1[10];
byte buffer2[10];

byte* volatile newbuffer = buffer1;
byte* volatile oldbuffer = buffer2;
byte* volatile tempbuffer;

void swap() {
    tempbuffer = newbuffer;
    newbuffer = oldbuffer;
    oldbuffer = tempbuffer;

    printf("\nt=%x, n=%x, o=%x", (word)tempbuffer, (word)newbuffer, (word)oldbuffer);
}

void main() {

    clrscr();
    gotoxy(0,0);
    printf("\nstart\nt=%x, n=%x, o=%x\nswapping\n", (word)tempbuffer, (word)newbuffer, (word)oldbuffer);

    swap();
    swap();
    swap();

}
