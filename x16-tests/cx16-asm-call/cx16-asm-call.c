//#include <printf.h>
//#include <conio.h>
//#include <cx16-veralib.h>


#pragma encoding(petscii_mixed)

typedef struct {
    char m1;
    char m2;
} t1;



__export char g1;
__export t1 var = {1,2};



void asm_call(char register(A) A, char register(X) X, char register(Y) Y ) {

    char m3;

    asm {
        sta var.m1
    }
}

__export char l1;
__export char l2;

void main() {

//    textcolor(WHITE);
//    bgcolor(BLACK);
    //clrscr();

    char* ch = (char*)0x3000;

    var.m2 = 2;
    *ch = var.m2;

    asm_call(1, 2, 3);

//    printf("%u", 2);

//    while(!kbhit());
}
