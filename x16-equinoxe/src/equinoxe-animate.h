

#include "../src/equinoxe-flightengine-types.h"

void animate_init();
unsigned char animate_add(char count, char state, char loop, char speed, signed char direction, char reverse);
unsigned char animate_del(unsigned char a);
unsigned char animate_is_waiting(unsigned char a);
unsigned char animate_get_transition(unsigned char a);
unsigned char animate_get_image(unsigned char a); 
void animate_logic(unsigned char a);
void animate_player(unsigned char a, signed int x, signed int px);
void animate_tower(unsigned char a);
