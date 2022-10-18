// #define __DEBUG_FILE

#include <cx16.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <cx16-file.h>

#pragma encoding(petscii_mixed)

void main() {

    clrscr();

    char text[51] = "";

    FILE* fp = fopen(1, 8, 2, "file.bin");
    if(!fp) printf("error opening = %u", fp->status);

    unsigned int read = fgets((char*)text, 10, fp);
    if(!read) printf("no bytes read = %u", fp->status);

    printf("text %s", text);

    bank_set_bram(1);
    read = fgets((char*)0xA000, 128, fp);
    if(!read) printf("no bytes read = %u", fp->status);

    if(fclose(fp))
        printf("error closing = %u", fp->status);

    while(!getin());

}