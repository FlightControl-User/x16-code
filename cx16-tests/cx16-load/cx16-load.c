// #define __DEBUG_FILE

#include <cx16.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#pragma encoding(petscii_mixed)




void main() {

    clrscr();

    char text[51] = "";

    char status = file_open(1 , 8, 0, "file.bin");
    if(status) printf("error opening = %u", status);

    status = file_load_size(1, 8, 2, 1, (char*)text, 45);
    if(status) printf("no bytes read = %u", status);

    printf("text %s", text);

    status = file_load_size(1, 8, 2, 1, (char*)0xA000, 512);
    if(status) printf("no bytes read = %u", status);

    status = file_close(1);
    if(status) printf("error closing = %u", status);

}