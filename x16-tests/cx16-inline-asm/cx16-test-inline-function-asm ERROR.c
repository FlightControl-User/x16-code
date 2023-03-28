
#pragma var_model(zp)

volatile char addition_error;

inline char add(char test, char addition) {

    char result;

    asm {
        lda test
        clc
        adc addition
        sta result
        sta addition_error
    }

    return result;
}

void main() {

    char test = 1;
    char addition = 2;
    char result1 = add(test, addition);

}
