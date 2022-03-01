// sizeof bug demo

#include <conio.h>
#include <printf.h>

typedef struct {
    signed char f;
    signed int i;
} FP3;

typedef struct collision_s {
    unsigned char cells;                    // 1
    unsigned int gx[4];                     // 9
    unsigned int gy[4];                     // 17
    unsigned int* cell[4];                  // 25
} collision_t;


typedef struct entity_s {
    unsigned int next;                      // 2
    unsigned int prev;                      // 4

    signed int x;                           // 6
    signed int y;                           // 8
    unsigned char type;                     // 10
    unsigned char collision_mask;           // 12
    byte active;                            // 13
    byte SpriteType;                        // 14
    byte state_behaviour;                   // 15
    byte state_animation;                   // 16
    byte wait_animation;                    // 17
    byte speed_animation;                   // 18
    byte health;                            // 19
    byte gun;                               // 20
    byte strength;                          // 21
    byte reload;                            // 22
    byte moved;                             // 23
    byte side;                              // 24
    byte firegun;                           // 25
    unsigned int flight;                    // 27
    unsigned char move;                     // 28
    unsigned char step;                     // 29
    unsigned char angle;                    // 30
    unsigned char baseangle;                // 31
    unsigned char radius;                   // 32
    unsigned char delay;                    // 33
    signed char turn;                       // 34
    unsigned char speed;                    // 35
    unsigned char enabled;                  // 36
    unsigned int* sprite_type;              // 38
    unsigned int sprite_offset;             // 40

    unsigned int engine_handle;             // 42
    FP3 tx;                                 // 45
    FP3 ty;                                 // 48
    FP3 tdx;                                // 51
    FP3 tdy;                                // 54

    collision_t grid;                       // 54+25 = 79
} entity_t;

void main() {

    clrscr();
    gotoxy(0,30);

    printf("%u\n", sizeof(entity_t));

    printf("shouldn't this be 79?\n");

}
