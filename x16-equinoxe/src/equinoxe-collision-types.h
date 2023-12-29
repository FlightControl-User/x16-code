

typedef struct {
    unsigned char cell[256];
} collision_quadrant_t;

typedef struct {
    unsigned char collision;
    unsigned char s;
    unsigned char x;
    unsigned char y;
    unsigned char type;
    unsigned char side;
    unsigned char min_x;
    unsigned char min_y;
    unsigned char max_x;
    unsigned char max_y;
} collision_decision_t;