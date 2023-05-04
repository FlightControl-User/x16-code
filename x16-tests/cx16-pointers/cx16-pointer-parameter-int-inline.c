#pragma var_model(zp)

#include <cx16.h>
#include <conio.h>
#include <stdio.h>

inline void properties_id(unsigned int* id) {
    *id = 12;
}

void main() {
    unsigned int id1 = 0;
    unsigned int id2 = 0;
    properties_id(&id1);
    properties_id(&id2);
    printf("id = %u\n", id1);
    printf("id = %u\n", id2);
}
