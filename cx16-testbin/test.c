#pragma encoding(petscii_mixed)
#pragma var_model(zp)
#pragma link("test.ld")

#include <cx16.h>
#include <printf.h>
// #include <kernal.h>

// char* screen = (char*)0x400;

extern __stackcall char test(char c);

//__stackcall char test(char c);

//char test(char c) {
//    *screen = c;
//    return c++;
//}

__export char EXOMIZER[] = kickasm(resource "C:/Users/svenv/OneDrive/Documents/GitHub/x16-code/target/cx16-testbin/test-bin.asm") {{
    #import "C:/Users/svenv/OneDrive/Documents/GitHub/x16-code/target/cx16-testbin/test-bin.asm" 
}};

void main() {
    unsigned int count = 0;

    count = test('O');
    count = count + test('K');
    count = count + test('!');
    count = count + test('!');

    printf("\ncount = %u", count);

}




