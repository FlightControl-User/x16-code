char* const SCREEN = (char*)0x0400;

typedef struct {
    unsigned char lo[10];
    unsigned char hi[10];
} split_t;

split_t numbers;

void split(unsigned int number, unsigned char index)
{
    numbers.lo[index] = BYTE0(number);
    numbers.hi[index] = BYTE1(number);
}

void main() {

    unsigned int number;

    split(0x4041, 0);
    split(0x4243, 1);

    for(unsigned char i=0; i<2; i++) {
        (SCREEN+40)[i*2+0] = numbers.lo[i];
        (SCREEN+40)[i*2+1] = numbers.hi[i];
    }
}