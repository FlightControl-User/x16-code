
#include <conio.h>
#include <printf.h>
#include <cx16-mouse.h>
#include <kernal.h>

#pragma zp_reserve(0x00..0x21, 0x80..0xFF)

void main() {
    clrscr();
    cx16_mouse_config(0xFF, 80, 60);

    printf("move the mouse, and check the registers updating correctly. press any key ...\n");

    while(!getin()) { // loop until a key is pressed
        char cx16_mouse_status = cx16_mouse_get(); // get the mouse status, which puts the x and y coordinates in zero page $22
        char const *addr_22 = (char*)0x0022;
        char const *addr_23 = (char*)0x0023;
        char const *addr_24 = (char*)0x0024;
        char const *addr_25 = (char*)0x0025;
        gotoxy(0,19);
        printf("before open : $22=%3u, $23=%3u, $24=%3u, $25=%3u", *addr_22, *addr_23, *addr_24, *addr_25); // print the mouse vectors
    }

    gotoxy(0,2);
    printf("opening the file and closing the file, no reading occurring ...\n");

    cbm_k_setnam("FILE"); // File name on the disk
    cbm_k_setlfs(1, 8, 0); // set the channel to be a file loaded from disk

    char status = cbm_k_open(); // open the file on the selected channel
    printf("open status=%u\n", status);
    if(status!=0x0) return; // stop program if file cannot be read

    status = cbm_k_close(1); // close active channel
    printf("close status=%u\n", status);

    printf("\nnow move the mouse again, and please check the coordinates updating after the\n file open and close, press any key ...\n");


    while(!getin()) { // loop until a key is pressed
        char cx16_mouse_status = cx16_mouse_get(); // get the mouse status, which puts the x and y coordinates in zero page $22
        char const *addr_22 = (char*)0x0022;
        char const *addr_23 = (char*)0x0023;
        char const *addr_24 = (char*)0x0024;
        char const *addr_25 = (char*)0x0025;
        gotoxy(0,20);
        printf("after open : $22=%3u, $23=%3u, $24=%3u, $25=%3u", *addr_22, *addr_23, *addr_24, *addr_25); // print the mouse vectors
    }
}
