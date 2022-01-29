typedef struct {
    signed char f;
    signed int i;
} FP3;


void fp3_set(FP3* fp3, signed int i, signed char f);
void fp3_add(FP3* fp3, FP3* add);
void fp3_sub(FP3* fp3, FP3* sub);
