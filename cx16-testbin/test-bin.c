#pragma link("test-bin.ld")
#pragma encoding(petscii_mixed)
#pragma var_model(mem)

#include <cx16.h>
#include <kernal.h>

#pragma code_seg(segm_test_bin)
#pragma data_seg(segm_test_bin)

char __stackcall test(char c) {
    cbm_k_chrout(c);
   
    return c;
}

__export volatile void (*call_test)(char) = (void*)&test;

#pragma code_seg(Code)
#pragma data_seg(Data)

void main() {

}

