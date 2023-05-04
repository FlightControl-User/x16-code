#pragma var_model(zp)

#include <cx16.h>
#include <conio.h>
#include <stdio.h>

void properties_id(unsigned int* id) {
    *id = 12;
}

void main() {
    unsigned int id = 0;
    properties_id(&id);
    printf("id = %u\n", id);
}
