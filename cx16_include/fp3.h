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

void fp3_set(FP3* fp3, signed int i, signed char f);
void fp3_add(FP3* fp3, FP3* add);
void fp3_sub(FP3* fp3, FP3* sub);

// #define fp3_add(fp3, add) asm { clc ldy #0 lda (fp3),y adc (add),y sta (fp3),y iny lda (fp3),y adc (add),y sta (fp3),y iny lda (fp3),y adc (add),y sta (fp3),y }