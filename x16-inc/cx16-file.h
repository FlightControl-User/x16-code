/**
 * @file cx16-file.h
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief 
 * @version 0.1
 * @date 2022-10-17
 * 
 * @copyright Copyright (c) 2022
 * 
 */


#ifndef __CX16__
#error "Target platform must be cx16"
#endif

#include <cx16.h>
#include <mos6522.h>

unsigned int fload_bram(char channel, char device, char secondary, char* filename, bram_bank_t dbank, bram_ptr_t dptr);
