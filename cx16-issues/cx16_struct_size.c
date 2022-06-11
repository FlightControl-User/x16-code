#pragma var_model(mem)

#include <conio.h>
#include <printf.h>

typedef struct {
    word integer;
    char fraction;
} fp_t;

typedef struct {
    char file[16];
    fp_t numbers[16];
} sprite_t;

__export sprite_bram_t sprite = { "sprite1.bin", {{0,0}} };
__export sprite_bram_t sprite2 = { "sprite2.bin", { {0, 0} } };


void main() {

    clrscr();
    printf("sprite file = %s\n", sprite.file);
    printf("sprite2 file = %s\n", sprite2.file);

    printf("\n\n\n");

    for(char i=0; i<16; i++) {
        sprite.numbers[i].fraction = 255;
        sprite.numbers[i].integer = 255;
    }
    for(char i=0; i<16; i++) {
        sprite.numbers[i].fraction = 127;
        sprite.numbers[i].integer = 127;
    }

    printf("sprite file = %s\n", sprite.file);
    printf("sprite2 file = %s\n", sprite2.file);

    printf("\n\n\n");
}
