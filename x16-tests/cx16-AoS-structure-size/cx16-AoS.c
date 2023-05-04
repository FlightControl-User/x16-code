#pragma var_model(zp)

#include <cx16.h>
#include <conio.h>
#include <cx16-conio.h>


struct sprite {
	unsigned int id;
	unsigned char type;
	unsigned int x;
	unsigned int y;  
};

struct sprite sprites[64];

__export unsigned int x;
__export unsigned int y;

void main()
{

    for(unsigned int i=0; i<64; i++) {
        x = sprites[i].x;
        y = sprites[i].y;
    }
}
