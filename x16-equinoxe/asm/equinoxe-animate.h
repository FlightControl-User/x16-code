//#include "../src/equinoxe-stage-types.h"

void animate_init();
unsigned char animate_add(char count, char loop, char speed, signed char direction, char reverse);
unsigned char animate_del(unsigned char a);
unsigned char animate_is_waiting(unsigned char a);
unsigned char animate_get_state(unsigned char a);
void animate_logic(unsigned char a);
