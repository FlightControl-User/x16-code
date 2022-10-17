/**
 * @file cx16-rom-flash.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief CCOMMANDER X16 ROM FLASH UTILITY
 * 
 * This flash utility follows the ROM memory addressing outline of the commander X16.
 * 
 * An address of 0x5555 results in rom bank 0x01 and rom ptr 0x1555.
 *
 *                              +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+  
 *                              | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
 *                              | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
 *                              +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+  
 *                              | 0 | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 |
 *                              +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+  
 * ROM_BANK_MASK  0x7C000       | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
 *                              +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+  
 * ROM_PTR_MASK   0x03FFF       | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
 *                              +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+  
 * RESULT BANK                  | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 |
 *                              +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+  
 * RESULT PTR                   | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 1 |
 *                              +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+  
 *
 * A sector erase address determination uses bit 12 as the base bit.
 *
 *                              +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+  
 *                              | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
 *                              | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
 *                              +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+  
 * ROM_SECTOR_MASK     0x7F000  | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
 *                              +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+  
 * ROM_SECTADDR_MASK   0x00FFF  | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
 *                              +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+  
 
 * @version 0.1
 * @date 2022-10-16
 * 
 * @copyright Copyright (c) 2022
 * 
 */


/**
 * @brief 

 * An address of 0x5555 results in rom bank 0x01 and rom ptr 0x1555.
 *
 * 
 * @param address 
 * @return unsigned char 
 */

// #define __DEBUG_FILE


// #define __FLASH

#pragma encoding(petscii_mixed)

#include <cx16.h>
#include <conio.h>
#include <printf.h>
#include <6502.h>
#include <kernal.h>

#pragma var_model(zp)

#define ROM_BASE            ((unsigned int)0xC000)
#define ROM_SIZE            ((unsigned int)0x4000)
#define ROM_PTR_MASK        ((unsigned long)0x03FFF)
#define ROM_BANK_MASK       ((unsigned long)0x7C000)

#define ROM_SECTOR_MASK     ((unsigned long)0x7F000)
#define ROM_SECTADDR_MASK   ((unsigned long)0x00FFF)

#define SST39SF010A         ((unsigned char)0xB5)
#define SST39SF020A         ((unsigned char)0xB6)
#define SST39SF040          ((unsigned char)0xB7)

unsigned char rom_bank(unsigned long address) {
    return (char)((unsigned long)(address & ROM_BANK_MASK) >> 14);
}

brom_ptr_t rom_ptr(unsigned long address) {
    return (brom_ptr_t)((unsigned int)(address & ROM_PTR_MASK) + ROM_BASE);
}

unsigned long rom_address(unsigned char bank, brom_ptr_t ptr) {
    ptr -= 0xC000;
    return (unsigned long)ptr | (unsigned long)bank << 14;
}



brom_ptr_t rom_erase_address(unsigned long address) {
    return (brom_ptr_t)((unsigned int)(address & ROM_SECTADDR_MASK) + ROM_BASE);
}


unsigned char rom_read_byte(unsigned long address)
{
    brom_bank_t bank_rom = rom_bank((unsigned long)address);
    brom_ptr_t  ptr_rom  = rom_ptr((unsigned long)address);

    bank_set_brom(bank_rom);
    return *ptr_rom;
}

void rom_write_byte(unsigned long address, unsigned char value)
{
    brom_bank_t bank_rom = rom_bank((unsigned long)address);
    brom_ptr_t  ptr_rom  = rom_ptr((unsigned long)address);

    bank_set_brom(bank_rom);
    *ptr_rom = value;

}

void rom_wait(brom_ptr_t  ptr_rom)
{
    unsigned char test1;
    unsigned char test2;

    do {
        test1 = *((brom_ptr_t)ptr_rom);
        test2 = *((brom_ptr_t)ptr_rom);
    } while((test1 & 0x40) != (test2 & 0x40));
}


void rom_byte_program(unsigned long address, unsigned char value)
{
    brom_ptr_t  ptr_rom  = rom_ptr((unsigned long)address);

    rom_write_byte(address, value);
    rom_wait(ptr_rom);    

}




unsigned int rom_sector(unsigned long address) {
    return ((unsigned int)(address & ROM_SECTOR_MASK) >> 12);
}



void rom_sector_erase(unsigned long address) {

    brom_ptr_t  ptr_rom  = rom_ptr((unsigned long)address);

    rom_write_byte(0x05555, 0xAA);
    rom_write_byte(0x02AAA, 0x55);
    rom_write_byte(0x05555, 0x80);
    rom_write_byte(0x05555, 0xAA);
    rom_write_byte(0x02AAA, 0x55);

    // printf("sector_bank = %x, sector_ptr = %p\n", sector_bank, sector_ptr);
    rom_write_byte(address, 0x30);

    rom_wait(ptr_rom);
}

void rom_unlock(unsigned char unlock_code)
{
    unsigned char byte1 = 0xAA;
    unsigned char byte2 = 0x55;

    rom_write_byte(0x05555, byte1);
    rom_write_byte(0x02AAA, byte2);
    rom_write_byte(0x05555, unlock_code);
}

void main() {

    unsigned int bytes = 0;

    SEI();

    clrscr();


    printf("rom flash utility\n");

    printf("\nROM chipset device determination:\n\n");

    unsigned char rom_manufacturer_id = 0;
    unsigned char rom_device_id = 0;

    #ifdef __FLASH
    rom_unlock(0x90);
    rom_manufacturer_id = rom_read_byte(0x00000);
    rom_device_id = rom_read_byte(0x00001);
    rom_unlock(0xF0);

    rom_unlock(0x90);
    rom_manufacturer_id = rom_read_byte(0x00000);
    rom_device_id = rom_read_byte(0x00001);
    rom_unlock(0xF0);
    #endif


    bank_set_brom(4);

    printf("manufacturer id = %x\n", rom_manufacturer_id);
    
    char* rom_device = NULL;
    switch(rom_device_id) {
        case SST39SF010A:
            rom_device = "sst39sf010a";
            break;
        case SST39SF020A:
            rom_device = "sst39sf020a";
            break;
        case SST39SF040:
            rom_device = "sst39sf040";
            break;
        default:
            rom_device = "unknown";
            break;
    }
    printf("device id = %s (%x)\n", rom_device, rom_device_id );

    CLI();

    bank_set_bram(1);
    bank_set_brom(4);

    printf("\nopening file rom.bin from the sd card ...\n");
    unsigned int status = file_open(1, 8, 2, "rom.bin");
    if (status) {
        printf("cannot open file rom.bin from sd card!\n");
        return;
    }

    printf("opening of file rom.bin from sd card succesful ...\n");

    printf("\nloading kernal rom in main memory ...\n");

    ram_ptr_t ram_addr = (ram_ptr_t)0x4000;
    unsigned long rom_addr = 0x00000;

    printf("\n%06x : ", rom_addr);

    while(rom_addr < 0x4000) {
        bytes = file_load_size(1, 8, 2, ram_addr, 128); // this will load 128 bytes from the rom.bin file or less if EOF is reached.
        if(bytes) {

            if (!(rom_addr % 0x02000)) {
                printf("\n%06x : ", rom_addr);
            }

            cputc('.');

            ram_addr += bytes;
            rom_addr += bytes;

        } else {
            printf("error: rom.bin is incomplete!");
            return;
        }
    }

    printf("\n\nloading remaining rom in banked memory ...\n");

    bank_set_bram(1); // read from bank 1 in bram.
    ram_addr = (ram_ptr_t)0xA000;

    bytes = file_load_size(1, 8, 2, ram_addr, 128); // this will load 128 bytes from the rom.bin file or less if EOF is reached.

    while(bytes && rom_addr < 0x28000) {

        if (!(rom_addr % 0x2000)) {
            printf("\n%06x : ", rom_addr);
        }

        cputc('.'); // show the user something has been read.
        ram_addr += bytes;
        rom_addr += bytes;
        if(ram_addr >= 0xC000) {
            ram_addr = ram_addr - 0x2000;
        }
        bytes = file_load_size(1, 8, 2, ram_addr, 128); // this will load 128 bytes from the rom.bin file or less if EOF is reached.
    }

    unsigned long rom_total = rom_addr; 
    printf("\n\na total of %06x rom bytes to be upgraded from rom.bin ...", rom_total);

    printf("\npress any key to upgrade to the new rom ...\n");

    while(!getin());
    clrscr();

    SEI();

    printf("\nupgrading kernal rom from main memory ...\n");

    ram_addr = (ram_ptr_t)0x4000;
    rom_addr = 0x00000;

    while(rom_addr < 0x4000) {
        
        if (!(rom_addr % 0x2000)) {
            printf("\n%06x : ", rom_addr);
        }

        if (!(rom_addr % 0x80))
            cputc('.');

        if (!(rom_addr % 0x1000)) {
            #ifdef __FLASH
            rom_sector_erase(rom_addr); // clearing rom sector
            #endif
        }

        for(unsigned char b=0; b<128; b++) {
            #ifdef __FLASH
            rom_unlock(0xA0);
            rom_byte_program(rom_addr, *ram_addr);
            #endif
            rom_addr++;
            ram_addr++;
        }
    }

    printf("\n\nflashing remaining rom from banked memory ...\n");

    unsigned char bank = 1;
    bank_set_bram(bank); // read from bank 1 in bram.
    ram_addr = (ram_ptr_t)0xA000;

    while(rom_addr < rom_total) {
        
        if (!(rom_addr % 0x2000)) {
            printf("\n%06x : ", rom_addr);
        }

        if (!(rom_addr % 0x80))
            cputc('.');

        if (!(rom_addr % 0x1000)) {
            #ifdef __FLASH
            rom_sector_erase(rom_addr); // clearing rom sector
            #endif
        }

        for(unsigned char b=0; b<128; b++) {
            #ifdef __FLASH
            rom_unlock(0xA0);
            rom_byte_program(rom_addr, *ram_addr);
            #endif
            rom_addr++;
            ram_addr++;

            if(ram_addr >= 0xC000) {
                ram_addr = ram_addr - 0x2000;
                bank++;
            }
            bank_set_bram(bank); // read from bank 1 in bram.
        }
    }

    CLI();

    printf("\n\nflashing of new rom successful ... resetting commander x16 to new rom...\n");

    for(unsigned int w=0; w<64; w++) {
        for(unsigned int v=0; v<256*64; v++) {
        } 
        cputc('.');
    }

    bank_set_bram(0);
    bank_set_brom(0);

    asm {
        jmp ($FFFC)
    }


}
