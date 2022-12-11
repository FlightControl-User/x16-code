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
    char *text;
    unsigned char zdepth;
    unsigned int health;
} struct_t;

struct_t volatile AoS[STRUCT_SIZE] = {
    { "enemy", 1, 2458},
    { "bullet", 2, 56784}
};

void main()
{
    bgcolor(BROWN);
    textcolor(WHITE);
    clrscr();
    scroll(0);

    for(unsigned char index=0; index<STRUCT_SIZE; index++) {
        char* text = AoS[index].text;
        unsigned char zdepth = AoS[index].zdepth;
        unsigned int health = AoS[index].health; 
        printf("text = %s\n", text);
        printf("zdepth = %u\n", zdepth);
        printf("health = %u\n", health);
    }
}
