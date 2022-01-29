#include <fp3.h>

void fp3_set(FP3* fp3, signed int i, signed char f) {

    fp3->i = i;
    fp3->f = f;
    if(i==0 && f<0) {
        fp3->i=-1;
    }
}

void fp3_add(FP3* fp3, FP3* add) {

    asm {
        clc
        ldy #0
        lda (fp3),y
        adc (add),y
        sta (fp3),y
        iny
        lda (fp3),y
        adc (add),y
        sta (fp3),y
        iny
        lda (fp3),y
        adc (add),y
        sta (fp3),y
    }
}

void fp3_sub(FP3* fp3, FP3* sub) {

    asm {
        sec
        ldy #0
        lda (fp3),y
        sbc (sub),y
        sta (fp3),y
        iny
        lda (fp3),y
        sbc (sub),y
        sta (fp3),y
        iny
        lda (fp3),y
        sbc (sub),y
        sta (fp3),y
    }
}