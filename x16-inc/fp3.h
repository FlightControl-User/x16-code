
#pragma once

#include <fp3-typedefs.h>

void fp3_set(FP3* fp3, signed int i, signed char f);
void fp3_add(FP3* fp3, FP3* add);
void fp3_sub(FP3* fp3, FP3* sub);

// #define fp3_add(fp3, add) asm { clc ldy #0 lda (fp3),y adc (add),y sta (fp3),y iny lda (fp3),y adc (add),y sta (fp3),y iny lda (fp3),y adc (add),y sta (fp3),y }