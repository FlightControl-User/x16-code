
#include <conio.h>
#include <printf.h>
#include <cx16-mouse.h>
#include <kernal.h>

#pragma zp_reserve(0x00..0x21, 0x80..0xFF)

void main() {
    cx16_mouse_config(0x01, 80, 60);

    cbm_k_setnam("FILE"); // File name on the disk
    cbm_k_setlfs(1, 8, 2); // set the channel to be a file loaded from disk
    cbm_k_open(); // open the file on the selected channel
    cbm_k_close(1); // close active channel
}
