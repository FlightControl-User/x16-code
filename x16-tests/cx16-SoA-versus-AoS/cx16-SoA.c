#pragma var_model(zp)

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <conio.h>
#include <cx16-conio.h>
#include <lru-cache.h>
#include <division.h>

#define STRUCT_SIZE 64
typedef struct {
    char *text[STRUCT_SIZE];
    unsigned char zdepth[STRUCT_SIZE];
    unsigned int health[STRUCT_SIZE];
} struct_t;

struct_t volatile SoA = {
    { "enemy", "bullet" },
    { 1, 2 },
    { 2458, 56784 }
};

void main()
{
    bgcolor(BROWN);
    textcolor(WHITE);
    clrscr();
    scroll(0);

    for(unsigned char index=0; index<STRUCT_SIZE; index++) {
        char* text = SoA.text[index];
        unsigned char zdepth = SoA.zdepth[index];
        unsigned int health = SoA.health[index]; 
        printf("text = %s\n", text);
        printf("zdepth = %u\n", zdepth);
        printf("health = %u\n", health);
    }
}
