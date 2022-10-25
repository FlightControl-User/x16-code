typedef struct {
    signed char f;
    signed int i;
} FP3FI;

typedef struct {
    signed int lo;
    signed char hi;
} FP3LO;

typedef struct {
    signed char lo;
    signed int hi;
} FP3HI;

typedef union {
    FP3FI fp3fi;
    FP3LO fp3lo;
    FP3HI fp3hi;
} FP3;

typedef unsigned long FP;

