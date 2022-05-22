#include <conio.h>
#include <printf.h>

#pragma zp_reserve(0x01, 0x02, 0x80..0xFF)

unsigned char data1[4] = { 10, 11, 12, 13 };
unsigned char data2[4] = { 20, 21, 22, 23 };


void printnames(unsigned char *ages, char *type)
{
    printf("type = %s\n----------------------\n", type);
    for(unsigned n=0; n<4; n++) {
        printf("%u\n", ages[n]);
    }
    printf("\n");
}

void main() {

    printnames(data1, "ten");
    printnames(data2, "twenty");  

}
