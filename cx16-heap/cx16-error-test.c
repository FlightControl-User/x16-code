#pragma var_model(mem)

#include <stdlib.h>

typedef struct {

	int x;
	int y;
	int z;

} TEST;

TEST* ret(unsigned int a, unsigned int b) {
	return (TEST*)((unsigned int)rand());
}


void main() {

	unsigned int a = 30;
	unsigned int b = 60;

	TEST* p = (TEST*)ret(a,b);

	p->x = 5;
	p->y = 10;
	p->z = 50;

	a=31;
	b=32;

p = (TEST*)ret(a+3,b+5);

	p->x = 5;
	p->y = 10;
	p->z = 50;

}