#include <stdlib.h>

byte zeropage = 2;

byte calc(byte value, byte zeropage) {
    byte status = 0;
    status = value << zeropage;
    return status;
}

void main() {
    byte value = (byte)rand();
    zeropage = value | zeropage;
    value = zeropage | value;
    byte result = calc(value,zeropage);
    result = calc(result, zeropage);

}