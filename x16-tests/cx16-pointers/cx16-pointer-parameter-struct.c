#pragma var_model(zp)

#include <cx16.h>
#include <conio.h>
#include <cx16-conio.h>

struct sprite {
	unsigned int id;
	unsigned char* name;
};

properties_giraffe(struct sprite* animal) {
    animal->id = 12;
    animal->name = "giraffe";
}

void main() {
    clrscr();
    struct sprite animal;
    properties(&animal);
    printf("id = %u, name = %s", animal.id, animal.name);
}
