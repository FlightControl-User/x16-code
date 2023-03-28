
#pragma var_model(zp)

__export volatile char persistent;

inline char add(char test, char addition) {

    char result;

    result += addition;

    return result;
}

void main() {

    char test = 1;
    char addition = 2;
    volatile char result1 = add(test, addition);

    persistent = result1;
}



