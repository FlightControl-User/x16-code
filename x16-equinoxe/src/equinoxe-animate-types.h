
#define SPRITE_ANIMATE 128

typedef struct {
    unsigned char used[SPRITE_ANIMATE];
    unsigned char state[SPRITE_ANIMATE];
    unsigned char wait[SPRITE_ANIMATE];
    unsigned char speed[SPRITE_ANIMATE];
    unsigned char loop[SPRITE_ANIMATE];
    unsigned char count[SPRITE_ANIMATE];
    signed char direction[SPRITE_ANIMATE];
    unsigned char reverse[SPRITE_ANIMATE];
} sprite_animate_t;

