// #define __DEBUG_FILE

#include <conio.h>
#include <cx16.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// #pragma encoding(petscii_mixed)

#define errno __errno

void main() {

    clrscr();
    // Set the charset to lower case.
    cx16_k_screen_set_charset(3, (char *)0);

    char text[256];

    FILE *fp = fopen("FILE.BIN", "r");
    if (!fp) {
        perror("error opening file.bin");
    } else {
        unsigned int read;
        while(read = fgets((char*)text, 128, fp)) {
            if(!read) {
                if(ferror(fp)) {
                    perror("error reading file.bin");      
                    printf("error = %s\n", strerror(0));
                    break;
                }
            } else {
                printf("text=%s\n", text);
            }
        }
    }

    FILE *fp2 = fopen("FILE2.BIN,L2,D8,C3", "r");
    if (!fp2) {
        perror("error opening file2.bin");
    } else {
        unsigned int read2 = fgets((char*)text, 27, fp2);
        if(!read2) {
            if(ferror(fp2)) {
                perror("error reading file2.bin");      
                printf("error = %s\n", strerror(0));
            }
        }
        printf("text=%s\n", text);
    }

    if (fclose(fp))
        perror("error closing");

    if (fclose(fp2))
        perror("error closing");

    printf("err = %i, error = %s\n", errno, strerror(0));

    while (!kbhit())
        ;
}