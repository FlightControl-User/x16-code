/**
 * @file cx16-load.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief 
 * @version 0.1
 * @date 2022-10-17
 * 
 * @copyright Copyright (c) 2022
 * 
 */


#include <cx16.h>
#include <kernal.h>
#include <stdlib.h>
#include <cx16-vera.h>
#include <cx16-file.h>


/**
 * @brief Load a file to banked ram located between address 0xA000 and 0xBFFF incrementing the banks.
 *
 * @param channel Input channel.
 * @param device Input device.
 * @param secondary Secondary channel.
 * @param filename Name of the file to be loaded.
 * @param bank The bank in banked ram to where the data of the file needs to be loaded.
 * @param sptr The pointer between 0xA000 and 0xBFFF in banked ram.
 * @return bram_ptr_t
 *  - 0x0000: Something is wrong! Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
 *  - other: OK! The last pointer between 0xA000 and 0xBFFF is returned. Note that the last pointer is indicating the first free byte.
 */
unsigned int fload_bram(char channel, char device, char secondary, char* filename, bram_bank_t dbank, bram_ptr_t dptr) 
{

    bram_bank_t bank = bank_get_bram();
    bank_set_bram(dbank);

    unsigned int read = 0;
    FILE* fp = fopen(channel, device, secondary, filename);
    if(fp) {
        read = fgets(dptr, 0, fp);
        if(read) {
            fclose(fp);
        } else {
            fclose(fp);
            read = 0;
        }
    }

    bank_set_bram(bank);

    return read;
}
