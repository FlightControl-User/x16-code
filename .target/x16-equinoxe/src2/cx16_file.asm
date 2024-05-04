  //
#importonce
  // File Comments
  // Library
.namespace cx16_file {
  // Upstart
.cpu _65c02
#if !__asm_import__cx16_file__

   .segmentdef Code
   .segmentdef Data
#endif

  // Global Constants & labels
  .label WHITE = 1
  .label BLUE = 6
  /**
 * @file kernal.h
 * @author your name (you@domain.com)
 * @brief Most common CBM Kernal calls with it's dialects in the different CBM kernal family platforms.
 * Please refer to http://sta.c64.org/cbm64krnfunc.html for the list of standard CBM C64 kernal functions.
 *
 * @version 1.0
 * @date 2023-03-22
 *
 * @copyright Copyright (c) 2023
 *
 */
  .label CBM_SETNAM = $ffbd
  ///< Set the name of a file.
  .label CBM_SETLFS = $ffba
  ///< Set the logical file.
  .label CBM_OPEN = $ffc0
  ///< Open the file for the current logical file.
  .label CBM_CHKIN = $ffc6
  ///< Set the logical channel for input.
  .label CBM_READST = $ffb7
  ///< Check I/O errors.
  .label CBM_CHRIN = $ffcf
  ///< Scan a character from the keyboard.
  .label CBM_CLOSE = $ffc3
  ///< Load a logical file.
  .label CBM_PLOT = $fff0
  ///< CX16 Set character set.
  .label CX16_MACPTR = $ff44
  .label VERA_LAYER_WIDTH_MASK = $30
  .label VERA_LAYER_HEIGHT_MASK = $c0
  .label OFFSET_STRUCT_CX16_CONIO_T_MAPBASE_OFFSET = 3
  .label OFFSET_STRUCT_CX16_CONIO_T_MAPBASE_BANK = 5
  .label OFFSET_STRUCT_CX16_CONIO_T_MAPHEIGHT = 9
  .label OFFSET_STRUCT_CX16_CONIO_T_MAPWIDTH = 8
  .label OFFSET_STRUCT_CX16_CONIO_T_COLOR = $d
  .label OFFSET_STRUCT_CX16_CONIO_T_ROWSKIP = $a
  .label OFFSET_STRUCT_CX16_CONIO_T_CURSOR_Y = 1
  .label OFFSET_STRUCT_CX16_CONIO_T_OFFSET = $13
  .label OFFSET_STRUCT_CX16_CONIO_T_WIDTH = 6
  .label OFFSET_STRUCT_CX16_CONIO_T_HEIGHT = 7
  .label OFFSET_STRUCT_CX16_CONIO_T_OFFSETS = $15
  .label OFFSET_STRUCT_CX16_CONIO_T_LAYER = 2
  .label OFFSET_STRUCT_CX16_CONIO_T_SCROLL = $f
  .label OFFSET_STRUCT_CX16_CONIO_T_CURSOR = $c
  .label OFFSET_STRUCT_FILE_CHANNEL = $80
  .label OFFSET_STRUCT_FILE_DEVICE = $84
  .label OFFSET_STRUCT_FILE_SECONDARY = $88
  .label OFFSET_STRUCT_FILE_STATUS = $8c
  .label SIZEOF_STRUCT_CX16_CONIO_T = $8f
  .label SIZEOF_STRUCT_FILE = $90
  /// $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
  .label VERA_DC_HSCALE = $9f2a
  /// $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
  .label VERA_DC_VSCALE = $9f2b
  /// $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  /// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __cx16_file_start
// void __cx16_file_start()
__cx16_file_start: {
    // __cx16_file_start::__init1
    // int __errno
    // [1] __errno = 0 -- vwsm1=vwsc1 
    lda #<0
    sta __errno
    sta __errno+1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [2] BRAM = 0 -- vbuz1=vbuc1 
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [3] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __cx16_file_start::@return
    // [4] return 
    rts
}
  // fgets
/**
 * @brief Load a file to ram or (banked ram located between address 0xA000 and 0xBFFF), incrementing the banks.
 * This function uses the new CX16 macptr kernal API at address $FF44.
 *
 * @param sptr The pointer between 0xA000 and 0xBFFF in banked ram.
 * @param size The amount of bytes to be read.
 * @param filename Name of the file to be loaded.
 * @return ptr the pointer advanced to the point where the stream ends.
 */
// __mem() unsigned int fgets(__zp($b) char *ptr, __mem() unsigned int size, __zp(2) FILE *stream)
fgets: {
    .label ptr = $b
    .label stream = 2
    // unsigned char sp = (unsigned char)stream
    // [5] fgets::sp#0 = (char)fgets::stream -- vbum1=_byte_pssz2 
    lda.z stream
    sta sp
    // unsigned int remaining = size
    // [6] fgets::remaining#0 = fgets::size -- vwum1=vwum2 
    lda size
    sta remaining
    lda size+1
    sta remaining+1
    // cbm_k_chkin(__logical)
    // [7] fgets::cbm_k_chkin1_channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fgets::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta cbm_k_chkin1_channel
    // fgets::cbm_k_chkin1
    // char status
    // [8] fgets::cbm_k_chkin1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // fgets::cbm_k_readst1
    // char status
    // [10] fgets::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [12] fgets::cbm_k_readst1_return#0 = fgets::cbm_k_readst1_status -- vbuaa=vbum1 
    // fgets::cbm_k_readst1_@return
    // }
    // [13] fgets::cbm_k_readst1_return#1 = fgets::cbm_k_readst1_return#0
    // fgets::@14
    // cbm_k_readst()
    // [14] fgets::$1 = fgets::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [15] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0] = fgets::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if (__status)
    // [16] if(0==((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0]) goto fgets::@2 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    cmp #0
    beq __b1
    // fgets::@1
    // return 0;
    // [17] fgets::return = 0 -- vwum1=vbuc1 
    lda #<0
    sta return
    sta return+1
    // fgets::@return
    // }
    // [18] return 
    rts
    // [19] phi from fgets::@14 to fgets::@2 [phi:fgets::@14->fgets::@2]
  __b1:
    // [19] phi fgets::read#10 = 0 [phi:fgets::@14->fgets::@2#0] -- vwum1=vwuc1 
    lda #<0
    sta read
    sta read+1
    // [19] phi fgets::remaining#11 = fgets::remaining#0 [phi:fgets::@14->fgets::@2#1] -- register_copy 
    // [19] phi from fgets::@20 fgets::@21 to fgets::@2 [phi:fgets::@20/fgets::@21->fgets::@2]
    // [19] phi fgets::read#10 = fgets::read#1 [phi:fgets::@20/fgets::@21->fgets::@2#0] -- register_copy 
    // [19] phi fgets::remaining#11 = fgets::remaining#1 [phi:fgets::@20/fgets::@21->fgets::@2#1] -- register_copy 
    // fgets::@2
  __b2:
    // if (!size)
    // [20] if(0==fgets::size) goto fgets::@3 -- 0_eq_vwum1_then_la1 
    lda size
    ora size+1
    bne !__b3+
    jmp __b3
  !__b3:
    // fgets::@8
    // if (remaining >= 128)
    // [21] if(fgets::remaining#11>=$80) goto fgets::@4 -- vwum1_ge_vbuc1_then_la1 
    lda remaining+1
    beq !__b4+
    jmp __b4
  !__b4:
    lda remaining
    cmp #$80
    bcc !__b4+
    jmp __b4
  !__b4:
  !:
    // fgets::@9
    // cx16_k_macptr(remaining, ptr)
    // [22] cx16_k_macptr::bytes = fgets::remaining#11 -- vbum1=vwum2 
    lda remaining
    sta cx16_k_macptr.bytes
    // [23] cx16_k_macptr::buffer = (void *)fgets::ptr -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [24] call cx16_k_macptr
    jsr cx16_k_macptr
    // [25] cx16_k_macptr::return#4 = cx16_k_macptr::return#1
    // fgets::@18
  __b18:
    // bytes = cx16_k_macptr(remaining, ptr)
    // [26] fgets::bytes#3 = cx16_k_macptr::return#4
    // [27] phi from fgets::@16 fgets::@17 fgets::@18 to fgets::cbm_k_readst2 [phi:fgets::@16/fgets::@17/fgets::@18->fgets::cbm_k_readst2]
    // [27] phi fgets::bytes#10 = fgets::bytes#1 [phi:fgets::@16/fgets::@17/fgets::@18->fgets::cbm_k_readst2#0] -- register_copy 
    // fgets::cbm_k_readst2
    // char status
    // [28] fgets::cbm_k_readst2_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst2_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst2_status
    // return status;
    // [30] fgets::cbm_k_readst2_return#0 = fgets::cbm_k_readst2_status -- vbuaa=vbum1 
    // fgets::cbm_k_readst2_@return
    // }
    // [31] fgets::cbm_k_readst2_return#1 = fgets::cbm_k_readst2_return#0
    // fgets::@15
    // cbm_k_readst()
    // [32] fgets::$8 = fgets::cbm_k_readst2_return#1
    // __status = cbm_k_readst()
    // [33] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0] = fgets::$8 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // __status & 0xBF
    // [34] fgets::$9 = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0] & $bf -- vbuaa=pbuc1_derefidx_vbum1_band_vbuc2 
    lda #$bf
    and __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if (__status & 0xBF)
    // [35] if(0==fgets::$9) goto fgets::@5 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b5
    // fgets::@10
    // return 0;
    // [36] fgets::return = 0 -- vwum1=vbuc1 
    lda #<0
    sta return
    sta return+1
    rts
    // fgets::@5
  __b5:
    // if (bytes == 0xFFFF)
    // [37] if(fgets::bytes#10!=$ffff) goto fgets::@6 -- vwum1_neq_vwuc1_then_la1 
    lda bytes+1
    cmp #>$ffff
    bne __b6
    lda bytes
    cmp #<$ffff
    bne __b6
    // fgets::@11
    // return 0;
    // [38] fgets::return = 0 -- vwum1=vbuc1 
    lda #<0
    sta return
    sta return+1
    rts
    // fgets::@6
  __b6:
    // read += bytes
    // [39] fgets::read#1 = fgets::read#10 + fgets::bytes#10 -- vwum1=vwum1_plus_vwum2 
    clc
    lda read
    adc bytes
    sta read
    lda read+1
    adc bytes+1
    sta read+1
    // ptr += bytes
    // [40] fgets::ptr = fgets::ptr + fgets::bytes#10 -- pbuz1=pbuz1_plus_vwum2 
    clc
    lda.z ptr
    adc bytes
    sta.z ptr
    lda.z ptr+1
    adc bytes+1
    sta.z ptr+1
    // BYTE1(ptr)
    // [41] fgets::$13 = byte1  fgets::ptr -- vbuaa=_byte1_pbuz1 
    // if (BYTE1(ptr) == 0xC0)
    // [42] if(fgets::$13!=$c0) goto fgets::@7 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$c0
    bne __b7
    // fgets::@12
    // ptr -= 0x2000
    // [43] fgets::ptr = fgets::ptr - $2000 -- pbuz1=pbuz1_minus_vwuc1 
    lda.z ptr
    sec
    sbc #<$2000
    sta.z ptr
    lda.z ptr+1
    sbc #>$2000
    sta.z ptr+1
    // fgets::@7
  __b7:
    // remaining -= bytes
    // [44] fgets::remaining#1 = fgets::remaining#11 - fgets::bytes#10 -- vwum1=vwum1_minus_vwum2 
    lda remaining
    sec
    sbc bytes
    sta remaining
    lda remaining+1
    sbc bytes+1
    sta remaining+1
    // while ((__status == 0) && ((size && remaining) || !size))
    // [45] if(((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0]==0) goto fgets::@19 -- pbuc1_derefidx_vbum1_eq_0_then_la1 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    cmp #0
    beq __b19
    // fgets::@13
    // return read;
    // [46] fgets::return = fgets::read#1
    rts
    // fgets::@19
  __b19:
    // while ((__status == 0) && ((size && remaining) || !size))
    // [47] if(0==fgets::size) goto fgets::@20 -- 0_eq_vwum1_then_la1 
    lda size
    ora size+1
    beq __b20
    // fgets::@21
    // [48] if(0!=fgets::remaining#1) goto fgets::@2 -- 0_neq_vwum1_then_la1 
    lda remaining
    ora remaining+1
    beq !__b2+
    jmp __b2
  !__b2:
    // fgets::@20
  __b20:
    // [49] if(0==fgets::size) goto fgets::@2 -- 0_eq_vwum1_then_la1 
    lda size
    ora size+1
    bne !__b2+
    jmp __b2
  !__b2:
    rts
    // fgets::@4
  __b4:
    // cx16_k_macptr(128, ptr)
    // [50] cx16_k_macptr::bytes = $80 -- vbum1=vbuc1 
    lda #$80
    sta cx16_k_macptr.bytes
    // [51] cx16_k_macptr::buffer = (void *)fgets::ptr -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [52] call cx16_k_macptr
    jsr cx16_k_macptr
    // [53] cx16_k_macptr::return#3 = cx16_k_macptr::return#1
    // fgets::@17
    // bytes = cx16_k_macptr(128, ptr)
    // [54] fgets::bytes#2 = cx16_k_macptr::return#3
    jmp __b18
    // fgets::@3
  __b3:
    // cx16_k_macptr(0, ptr)
    // [55] cx16_k_macptr::bytes = 0 -- vbum1=vbuc1 
    lda #0
    sta cx16_k_macptr.bytes
    // [56] cx16_k_macptr::buffer = (void *)fgets::ptr -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [57] call cx16_k_macptr
    jsr cx16_k_macptr
    // [58] cx16_k_macptr::return#2 = cx16_k_macptr::return#1
    // fgets::@16
    // bytes = cx16_k_macptr(0, ptr)
    // [59] fgets::bytes#1 = cx16_k_macptr::return#2
    jmp __b18
  .segment Data
    size: .word 0
    .label return = read
    cbm_k_chkin1_channel: .byte 0
    cbm_k_chkin1_status: .byte 0
    cbm_k_readst1_status: .byte 0
    cbm_k_readst2_status: .byte 0
    .label sp = fopen.pathstep
    remaining: .word 0
    bytes: .word 0
    read: .word 0
}
.segment Code
  // fclose
/**
 * @brief Close a file.
 *
 * @param fp The FILE pointer.
 * @return
 *  - 0x0000: Something is wrong! Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
 *  - other: OK! The last pointer between 0xA000 and 0xBFFF is returned. Note that the last pointer is indicating the first free byte.
 */
// __mem() int fclose(__zp(9) FILE *stream)
fclose: {
    .label stream = 9
    // unsigned char sp = (unsigned char)stream
    // [60] fclose::sp#0 = (char)fclose::stream -- vbum1=_byte_pssz2 
    lda.z stream
    sta sp
    // cbm_k_chkin(__logical)
    // [61] fclose::cbm_k_chkin1_channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fclose::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    tay
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta cbm_k_chkin1_channel
    // fclose::cbm_k_chkin1
    // char status
    // [62] fclose::cbm_k_chkin1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // fclose::cbm_k_readst1
    // char status
    // [64] fclose::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [66] fclose::cbm_k_readst1_return#0 = fclose::cbm_k_readst1_status -- vbuaa=vbum1 
    // fclose::cbm_k_readst1_@return
    // }
    // [67] fclose::cbm_k_readst1_return#1 = fclose::cbm_k_readst1_return#0
    // fclose::@5
    // cbm_k_readst()
    // [68] fclose::$1 = fclose::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [69] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fclose::sp#0] = fclose::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if (__status)
    // [70] if(0==((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fclose::sp#0]) goto fclose::@1 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    cmp #0
    beq __b1
    // fclose::@3
    // return 0;
    // [71] fclose::return = 0 -- vwsm1=vbsc1 
    lda #<0
    sta return
    sta return+1
    // fclose::@return
    // }
    // [72] return 
    rts
    // fclose::@1
  __b1:
    // cbm_k_close(__logical)
    // [73] fclose::cbm_k_close1_channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fclose::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta cbm_k_close1_channel
    // fclose::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // fclose::cbm_k_readst2
    // char status
    // [75] fclose::cbm_k_readst2_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst2_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst2_status
    // return status;
    // [77] fclose::cbm_k_readst2_return#0 = fclose::cbm_k_readst2_status -- vbuaa=vbum1 
    // fclose::cbm_k_readst2_@return
    // }
    // [78] fclose::cbm_k_readst2_return#1 = fclose::cbm_k_readst2_return#0
    // fclose::@6
    // cbm_k_readst()
    // [79] fclose::$4 = fclose::cbm_k_readst2_return#1
    // __status = cbm_k_readst()
    // [80] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fclose::sp#0] = fclose::$4 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if (__status)
    // [81] if(0==((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fclose::sp#0]) goto fclose::@2 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    cmp #0
    beq __b2
    // fclose::@4
    // return -1;
    // [82] fclose::return = -1 -- vwsm1=vbsc1 
    lda #<-1
    sta return
    sta return+1
    rts
    // fclose::@2
  __b2:
    // __logical = 0
    // [83] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    // __device = 0
    // [84] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    // __channel = 0
    // [85] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    // __filename
    // [86] fclose::$6 = fclose::sp#0 << 2 -- vbuaa=vbum1_rol_2 
    tya
    asl
    asl
    // *__filename = '\0'
    // [87] ((char *)&__stdio_file)[fclose::$6] = '@' -- pbuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #'@'
    sta __stdio_file,y
    // __stdio_filecount--;
    // [88] __stdio_filecount = -- __stdio_filecount -- vbum1=_dec_vbum1 
    dec __stdio_filecount
    // return 0;
    // [89] fclose::return = 0 -- vwsm1=vbsc1 
    lda #<0
    sta return
    sta return+1
    rts
  .segment Data
    .label return = fgets.remaining
    cbm_k_chkin1_channel: .byte 0
    cbm_k_chkin1_status: .byte 0
    cbm_k_readst1_status: .byte 0
    cbm_k_close1_channel: .byte 0
    cbm_k_readst2_status: .byte 0
    .label sp = fopen.pathstep
}
.segment Code
  // fopen
/**
 * @brief Load a file to banked ram located between address 0xA000 and 0xBFFF incrementing the banks.
 *
 * @param channel Input channel.
 * @param device Input device.
 * @param secondary Secondary channel.
 * @param filename Name of the file to be loaded.
 * @return
 *  - 0x0000: Something is wrong! Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
 *  - other: OK! The last pointer between 0xA000 and 0xBFFF is returned. Note that the last pointer is indicating the first free byte.
 */
// __zp(9) FILE * fopen(__zp(4) const char *path, __zp(2) const char *mode)
fopen: {
    .label path = 4
    .label mode = 2
    .label return = 9
    .label fopen__11 = 4
    .label fopen__24 = 4
    .label fopen__27 = 4
    .label fopen__28 = 2
    .label cbm_k_setnam1_filename = $f
    .label stream = 9
    .label pathtoken = $b
    // unsigned char sp = __stdio_filecount
    // [90] fopen::sp#0 = __stdio_filecount -- vbum1=vbum2 
    lda __stdio_filecount
    sta sp
    // (unsigned int)sp | 0x8000
    // [91] fopen::$30 = (unsigned int)fopen::sp#0 -- vwum1=_word_vbum2 
    sta fopen__30
    lda #0
    sta fopen__30+1
    // [92] fopen::stream#0 = fopen::$30 | $8000 -- vwuz1=vwum2_bor_vwuc1 
    lda fopen__30
    ora #<$8000
    sta.z stream
    lda fopen__30+1
    ora #>$8000
    sta.z stream+1
    // char *pathtoken = path
    // [93] fopen::pathtoken#0 = fopen::path -- pbuz1=pbuz2 
    lda.z path
    sta.z pathtoken
    lda.z path+1
    sta.z pathtoken+1
    // char pathpos = sp * __STDIO_FILECOUNT
    // [94] fopen::pathpos#0 = fopen::sp#0 << 2 -- vbum1=vbum2_rol_2 
    lda sp
    asl
    asl
    sta pathpos
    // __logical = 0
    // [95] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    // __device = 0
    // [96] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    // __channel = 0
    // [97] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    // [98] fopen::pathpos#21 = fopen::pathpos#0 -- vbum1=vbum2 
    lda pathpos
    sta pathpos_1
    // [99] phi from fopen to fopen::@8 [phi:fopen->fopen::@8]
    // [99] phi fopen::num#10 = 0 [phi:fopen->fopen::@8#0] -- vbuxx=vbuc1 
    ldx #0
    // [99] phi fopen::pathpos#10 = fopen::pathpos#21 [phi:fopen->fopen::@8#1] -- register_copy 
    // [99] phi fopen::pathstep#10 = 0 [phi:fopen->fopen::@8#2] -- vbum1=vbuc1 
    txa
    sta pathstep
    // [99] phi fopen::pathtoken#10 = fopen::pathtoken#0 [phi:fopen->fopen::@8#3] -- register_copy 
  // Iterate while path is not \0.
    // [99] phi from fopen::@22 to fopen::@8 [phi:fopen::@22->fopen::@8]
    // [99] phi fopen::num#10 = fopen::num#13 [phi:fopen::@22->fopen::@8#0] -- register_copy 
    // [99] phi fopen::pathpos#10 = fopen::pathpos#7 [phi:fopen::@22->fopen::@8#1] -- register_copy 
    // [99] phi fopen::pathstep#10 = fopen::pathstep#11 [phi:fopen::@22->fopen::@8#2] -- register_copy 
    // [99] phi fopen::pathtoken#10 = fopen::pathtoken#1 [phi:fopen::@22->fopen::@8#3] -- register_copy 
    // fopen::@8
  __b8:
    // if (*pathtoken == ',' || *pathtoken == '\0')
    // [100] if(*fopen::pathtoken#10==',') goto fopen::@9 -- _deref_pbuz1_eq_vbuc1_then_la1 
    lda #','
    ldy #0
    cmp (pathtoken),y
    bne !__b9+
    jmp __b9
  !__b9:
    // fopen::@34
    // [101] if(*fopen::pathtoken#10=='@') goto fopen::@9 -- _deref_pbuz1_eq_vbuc1_then_la1 
    lda #'@'
    cmp (pathtoken),y
    bne !__b9+
    jmp __b9
  !__b9:
    // fopen::@23
    // if (pathstep == 0)
    // [102] if(fopen::pathstep#10!=0) goto fopen::@10 -- vbum1_neq_0_then_la1 
    lda pathstep
    bne __b10
    // fopen::@24
    // __stdio_file.filename[pathpos] = *pathtoken
    // [103] ((char *)&__stdio_file)[fopen::pathpos#10] = *fopen::pathtoken#10 -- pbuc1_derefidx_vbum1=_deref_pbuz2 
    lda (pathtoken),y
    ldy pathpos_1
    sta __stdio_file,y
    // pathpos++;
    // [104] fopen::pathpos#1 = ++ fopen::pathpos#10 -- vbum1=_inc_vbum1 
    inc pathpos_1
    // [105] phi from fopen::@12 fopen::@23 fopen::@24 to fopen::@10 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10]
    // [105] phi fopen::num#13 = fopen::num#15 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#0] -- register_copy 
    // [105] phi fopen::pathpos#7 = fopen::pathpos#10 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#1] -- register_copy 
    // [105] phi fopen::pathstep#11 = fopen::pathstep#1 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#2] -- register_copy 
    // fopen::@10
  __b10:
    // pathtoken++;
    // [106] fopen::pathtoken#1 = ++ fopen::pathtoken#10 -- pbuz1=_inc_pbuz1 
    inc.z pathtoken
    bne !+
    inc.z pathtoken+1
  !:
    // fopen::@22
    // pathtoken - 1
    // [107] fopen::$28 = fopen::pathtoken#1 - 1 -- pbuz1=pbuz2_minus_1 
    lda.z pathtoken
    sec
    sbc #1
    sta.z fopen__28
    lda.z pathtoken+1
    sbc #0
    sta.z fopen__28+1
    // while (*(pathtoken - 1))
    // [108] if(0!=*fopen::$28) goto fopen::@8 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (fopen__28),y
    cmp #0
    bne __b8
    // fopen::@26
    // __status = 0
    // [109] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    tya
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if(!__logical)
    // [110] if(0!=((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0]) goto fopen::@1 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    cmp #0
    bne __b1
    // fopen::@27
    // __stdio_filecount+1
    // [111] fopen::$4 = __stdio_filecount + 1 -- vbuaa=vbum1_plus_1 
    lda __stdio_filecount
    inc
    // __logical = __stdio_filecount+1
    // [112] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] = fopen::$4 -- pbuc1_derefidx_vbum1=vbuaa 
    sta __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    // fopen::@1
  __b1:
    // if(!__device)
    // [113] if(0!=((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0]) goto fopen::@2 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    cmp #0
    bne __b2
    // fopen::@5
    // __device = 8
    // [114] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0] = 8 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #8
    sta __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    // fopen::@2
  __b2:
    // if(!__channel)
    // [115] if(0!=((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0]) goto fopen::@3 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    cmp #0
    bne __b3
    // fopen::@6
    // __stdio_filecount+2
    // [116] fopen::$9 = __stdio_filecount + 2 -- vbuaa=vbum1_plus_2 
    lda __stdio_filecount
    clc
    adc #2
    // __channel = __stdio_filecount+2
    // [117] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0] = fopen::$9 -- pbuc1_derefidx_vbum1=vbuaa 
    sta __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    // fopen::@3
  __b3:
    // __filename
    // [118] fopen::$11 = (char *)&__stdio_file + fopen::pathpos#0 -- pbuz1=pbuc1_plus_vbum2 
    lda pathpos
    clc
    adc #<__stdio_file
    sta.z fopen__11
    lda #>__stdio_file
    adc #0
    sta.z fopen__11+1
    // cbm_k_setnam(__filename)
    // [119] fopen::cbm_k_setnam1_filename = fopen::$11 -- pbuz1=pbuz2 
    lda.z fopen__11
    sta.z cbm_k_setnam1_filename
    lda.z fopen__11+1
    sta.z cbm_k_setnam1_filename+1
    // fopen::cbm_k_setnam1
    // strlen(filename)
    // [120] strlen::str#1 = fopen::cbm_k_setnam1_filename -- pbuz1=pbuz2 
    lda.z cbm_k_setnam1_filename
    sta.z strlen.str
    lda.z cbm_k_setnam1_filename+1
    sta.z strlen.str+1
    // [121] call strlen
    // [204] phi from fopen::cbm_k_setnam1 to strlen [phi:fopen::cbm_k_setnam1->strlen]
    // [204] phi strlen::str#5 = strlen::str#1 [phi:fopen::cbm_k_setnam1->strlen#0] -- register_copy 
    jsr strlen
    // strlen(filename)
    // [122] strlen::return#2 = strlen::len#2
    // fopen::@32
    // [123] fopen::cbm_k_setnam1_$0 = strlen::return#2
    // char filename_len = (char)strlen(filename)
    // [124] fopen::cbm_k_setnam1_filename_len = (char)fopen::cbm_k_setnam1_$0 -- vbum1=_byte_vwum2 
    lda cbm_k_setnam1_fopen__0
    sta cbm_k_setnam1_filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx cbm_k_setnam1_filename
    ldy cbm_k_setnam1_filename+1
    jsr CBM_SETNAM
    // fopen::@28
    // cbm_k_setlfs(__logical, __device, __channel)
    // [126] cbm_k_setlfs::channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta cbm_k_setlfs.channel
    // [127] cbm_k_setlfs::device = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    sta cbm_k_setlfs.device
    // [128] cbm_k_setlfs::command = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    sta cbm_k_setlfs.command
    // [129] call cbm_k_setlfs
    jsr cbm_k_setlfs
    // fopen::cbm_k_open1
    // asm
    // asm { jsrCBM_OPEN  }
    jsr CBM_OPEN
    // fopen::cbm_k_readst1
    // char status
    // [131] fopen::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [133] fopen::cbm_k_readst1_return#0 = fopen::cbm_k_readst1_status -- vbuaa=vbum1 
    // fopen::cbm_k_readst1_@return
    // }
    // [134] fopen::cbm_k_readst1_return#1 = fopen::cbm_k_readst1_return#0
    // fopen::@29
    // cbm_k_readst()
    // [135] fopen::$15 = fopen::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [136] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fopen::sp#0] = fopen::$15 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // ferror(stream)
    // [137] ferror::stream#0 = (FILE *)fopen::stream#0
    // [138] call ferror
    jsr ferror
    // [139] ferror::return#0 = ferror::return#1
    // fopen::@33
    // [140] fopen::$16 = ferror::return#0
    // if (ferror(stream))
    // [141] if(0==fopen::$16) goto fopen::@4 -- 0_eq_vwsm1_then_la1 
    lda fopen__16
    ora fopen__16+1
    beq __b4
    // fopen::@7
    // cbm_k_close(__logical)
    // [142] fopen::cbm_k_close1_channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta cbm_k_close1_channel
    // fopen::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // fopen::@30
    // return NULL;
    // [144] fopen::return = 0 -- pssz1=vbuc1 
    lda #<0
    sta.z return
    sta.z return+1
    // fopen::@return
    // }
    // [145] return 
    rts
    // fopen::@4
  __b4:
    // __stdio_filecount++;
    // [146] __stdio_filecount = ++ __stdio_filecount -- vbum1=_inc_vbum1 
    inc __stdio_filecount
    // return (FILE *)stream;
    // [147] fopen::return = (FILE *)fopen::stream#0
    rts
    // fopen::@9
  __b9:
    // if (pathstep > 0)
    // [148] if(fopen::pathstep#10>0) goto fopen::@11 -- vbum1_gt_0_then_la1 
    lda pathstep
    bne __b11
    // fopen::@25
    // __stdio_file.filename[pathpos] = '\0'
    // [149] ((char *)&__stdio_file)[fopen::pathpos#10] = '@' -- pbuc1_derefidx_vbum1=vbuc2 
    lda #'@'
    ldy pathpos_1
    sta __stdio_file,y
    // pathtoken + 1
    // [150] fopen::$24 = fopen::pathtoken#10 + 1 -- pbuz1=pbuz2_plus_1 
    clc
    lda.z pathtoken
    adc #1
    sta.z fopen__24
    lda.z pathtoken+1
    adc #0
    sta.z fopen__24+1
    // path = pathtoken + 1
    // [151] fopen::path = fopen::$24
    // [152] phi from fopen::@16 fopen::@17 fopen::@18 fopen::@19 fopen::@25 to fopen::@12 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12]
    // [152] phi fopen::num#15 = fopen::num#2 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12#0] -- register_copy 
    // fopen::@12
  __b12:
    // pathstep++;
    // [153] fopen::pathstep#1 = ++ fopen::pathstep#10 -- vbum1=_inc_vbum1 
    inc pathstep
    jmp __b10
    // fopen::@11
  __b11:
    // char pathcmp = *path
    // [154] fopen::pathcmp#0 = *fopen::path -- vbum1=_deref_pbuz2 
    ldy #0
    lda (path),y
    sta pathcmp
    // case 'D':
    // [155] if(fopen::pathcmp#0=='D') goto fopen::@13 -- vbum1_eq_vbuc1_then_la1 
    lda #'D'
    cmp pathcmp
    beq __b13
    // fopen::@20
    // case 'L':
    // [156] if(fopen::pathcmp#0=='L') goto fopen::@13 -- vbum1_eq_vbuc1_then_la1 
    lda #'L'
    cmp pathcmp
    beq __b13
    // fopen::@21
    // case 'C':
    //                     num = (char)atoi(path + 1);
    //                     path = pathtoken + 1;
    // [157] if(fopen::pathcmp#0=='C') goto fopen::@13 -- vbum1_eq_vbuc1_then_la1 
    lda #'C'
    cmp pathcmp
    beq __b13
    // [158] phi from fopen::@21 fopen::@31 to fopen::@14 [phi:fopen::@21/fopen::@31->fopen::@14]
    // [158] phi fopen::num#2 = fopen::num#10 [phi:fopen::@21/fopen::@31->fopen::@14#0] -- register_copy 
    // fopen::@14
  __b14:
    // case 'L':
    //                     __logical = num;
    //                     break;
    // [159] if(fopen::pathcmp#0=='L') goto fopen::@17 -- vbum1_eq_vbuc1_then_la1 
    lda #'L'
    cmp pathcmp
    beq __b17
    // fopen::@15
    // case 'D':
    //                     __device = num;
    //                     break;
    // [160] if(fopen::pathcmp#0=='D') goto fopen::@18 -- vbum1_eq_vbuc1_then_la1 
    lda #'D'
    cmp pathcmp
    beq __b18
    // fopen::@16
    // case 'C':
    //                     __channel = num;
    //                     break;
    // [161] if(fopen::pathcmp#0!='C') goto fopen::@12 -- vbum1_neq_vbuc1_then_la1 
    lda #'C'
    cmp pathcmp
    bne __b12
    // fopen::@19
    // __channel = num
    // [162] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy sp
    txa
    sta __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    jmp __b12
    // fopen::@18
  __b18:
    // __device = num
    // [163] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy sp
    txa
    sta __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    jmp __b12
    // fopen::@17
  __b17:
    // __logical = num
    // [164] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy sp
    txa
    sta __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    jmp __b12
    // fopen::@13
  __b13:
    // atoi(path + 1)
    // [165] atoi::str#0 = fopen::path + 1 -- pbuz1=pbuz1_plus_1 
    inc.z atoi.str
    bne !+
    inc.z atoi.str+1
  !:
    // [166] call atoi
    // [265] phi from fopen::@13 to atoi [phi:fopen::@13->atoi]
    // [265] phi atoi::str#2 = atoi::str#0 [phi:fopen::@13->atoi#0] -- register_copy 
    jsr atoi
    // atoi(path + 1)
    // [167] atoi::return#3 = atoi::return#2
    // fopen::@31
    // [168] fopen::$26 = atoi::return#3
    // num = (char)atoi(path + 1)
    // [169] fopen::num#1 = (char)fopen::$26 -- vbuxx=_byte_vwsm1 
    lda fopen__26
    tax
    // pathtoken + 1
    // [170] fopen::$27 = fopen::pathtoken#10 + 1 -- pbuz1=pbuz2_plus_1 
    clc
    lda.z pathtoken
    adc #1
    sta.z fopen__27
    lda.z pathtoken+1
    adc #0
    sta.z fopen__27+1
    // path = pathtoken + 1
    // [171] fopen::path = fopen::$27
    jmp __b14
  .segment Data
    .label fopen__16 = fgets.remaining
    .label fopen__26 = fgets.remaining
    .label fopen__30 = fgets.remaining
    cbm_k_setnam1_filename_len: .byte 0
    .label cbm_k_setnam1_fopen__0 = fgets.remaining
    cbm_k_readst1_status: .byte 0
    cbm_k_close1_channel: .byte 0
    sp: .byte 0
    pathpos: .byte 0
    pathpos_1: .byte 0
    pathcmp: .byte 0
    // Parse path
    pathstep: .byte 0
}
.segment Code
  // conio_x16_init
/// Set initial screen values.
// void conio_x16_init()
conio_x16_init: {
    // screenlayer1()
    // [173] call screenlayer1
    jsr screenlayer1
    // [174] phi from conio_x16_init to conio_x16_init::@1 [phi:conio_x16_init->conio_x16_init::@1]
    // conio_x16_init::@1
    // textcolor(CONIO_TEXTCOLOR_DEFAULT)
    // [175] call textcolor
    jsr textcolor
    // [176] phi from conio_x16_init::@1 to conio_x16_init::@2 [phi:conio_x16_init::@1->conio_x16_init::@2]
    // conio_x16_init::@2
    // bgcolor(CONIO_BACKCOLOR_DEFAULT)
    // [177] call bgcolor
    jsr bgcolor
    // [178] phi from conio_x16_init::@2 to conio_x16_init::@3 [phi:conio_x16_init::@2->conio_x16_init::@3]
    // conio_x16_init::@3
    // cursor(0)
    // [179] call cursor
    jsr cursor
    // [180] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // cbm_k_plot_get()
    // [181] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [182] cbm_k_plot_get::return#2 = cbm_k_plot_get::return#0
    // conio_x16_init::@5
    // [183] conio_x16_init::$4 = cbm_k_plot_get::return#2
    // BYTE1(cbm_k_plot_get())
    // [184] conio_x16_init::$5 = byte1  conio_x16_init::$4 -- vbuaa=_byte1_vwum1 
    lda conio_x16_init__4+1
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [185] *((char *)&__conio) = conio_x16_init::$5 -- _deref_pbuc1=vbuaa 
    sta __conio
    // cbm_k_plot_get()
    // [186] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [187] cbm_k_plot_get::return#3 = cbm_k_plot_get::return#0
    // conio_x16_init::@6
    // [188] conio_x16_init::$6 = cbm_k_plot_get::return#3
    // BYTE0(cbm_k_plot_get())
    // [189] conio_x16_init::$7 = byte0  conio_x16_init::$6 -- vbuaa=_byte0_vwum1 
    lda conio_x16_init__6
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [190] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_CURSOR_Y) = conio_x16_init::$7 -- _deref_pbuc1=vbuaa 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_CURSOR_Y
    // gotoxy(__conio.cursor_x, __conio.cursor_y)
    // [191] gotoxy::x#0 = *((char *)&__conio) -- vbuxx=_deref_pbuc1 
    ldx __conio
    // [192] gotoxy::y#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_CURSOR_Y) -- vbuyy=_deref_pbuc1 
    tay
    // [193] call gotoxy
    jsr gotoxy
    // conio_x16_init::@7
    // __conio.scroll[0] = 1
    // [194] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_SCROLL) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_SCROLL
    // __conio.scroll[1] = 1
    // [195] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_SCROLL+1) = 1 -- _deref_pbuc1=vbuc2 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_SCROLL+1
    // conio_x16_init::@return
    // }
    // [196] return 
    rts
  .segment Data
    .label conio_x16_init__4 = fgets.remaining
    .label conio_x16_init__6 = fgets.remaining
}
.segment Code
  // cx16_init
// void cx16_init()
cx16_init: {
    // isr_vsync = *(word *)0x0314
    // [197] isr_vsync#0 = *((unsigned int *) 788) -- vwum1=_deref_pwuc1 
    lda $314
    sta isr_vsync
    lda $314+1
    sta isr_vsync+1
    // cx16_init::@return
    // }
    // [198] return 
    rts
}
  // cx16_k_macptr
/**
 * @brief Read a number of bytes from the sdcard using kernal macptr call.
 * BRAM bank needs to be set properly before the load between adressed A000 and BFFF.
 *
 * @return x the size of bytes read
 * @return y the size of bytes read
 * @return if carry is set there is an error
 */
// __mem() unsigned int cx16_k_macptr(__mem() volatile char bytes, __zp(6) void * volatile buffer)
cx16_k_macptr: {
    .label buffer = 6
    // unsigned int bytes_read
    // [199] cx16_k_macptr::bytes_read = 0 -- vwum1=vwuc1 
    lda #<0
    sta bytes_read
    sta bytes_read+1
    // asm
    // asm { ldabytes ldxbuffer ldybuffer+1 clc jsrCX16_MACPTR stxbytes_read stybytes_read+1 bcc!+ lda#$FF stabytes_read stabytes_read+1 !:  }
    lda bytes
    ldx buffer
    ldy buffer+1
    clc
    jsr CX16_MACPTR
    stx bytes_read
    sty bytes_read+1
    bcc !+
    lda #$ff
    sta bytes_read
    sta bytes_read+1
  !:
    // return bytes_read;
    // [201] cx16_k_macptr::return#0 = cx16_k_macptr::bytes_read -- vwum1=vwum2 
    lda bytes_read
    sta return
    lda bytes_read+1
    sta return+1
    // cx16_k_macptr::@return
    // }
    // [202] cx16_k_macptr::return#1 = cx16_k_macptr::return#0
    // [203] return 
    rts
  .segment Data
    bytes: .byte 0
    bytes_read: .word 0
    .label return = fgets.bytes
}
.segment Code
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __mem() unsigned int strlen(__zp(4) char *str)
strlen: {
    .label str = 4
    // [205] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [205] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta len
    sta len+1
    // [205] phi strlen::str#3 = strlen::str#5 [phi:strlen->strlen::@1#1] -- register_copy 
    // strlen::@1
  __b1:
    // while(*str)
    // [206] if(0!=*strlen::str#3) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [207] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [208] strlen::len#1 = ++ strlen::len#2 -- vwum1=_inc_vwum1 
    inc len
    bne !+
    inc len+1
  !:
    // str++;
    // [209] strlen::str#0 = ++ strlen::str#3 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [205] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [205] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [205] phi strlen::str#3 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label len = fgets.remaining
    .label return = fgets.remaining
}
.segment Code
  // cbm_k_setlfs
/**
 * @brief Sets the logical file channel.
 *
 * @param channel the logical file number.
 * @param device the device number.
 * @param command the command.
 */
// void cbm_k_setlfs(__mem() volatile char channel, __mem() volatile char device, __mem() volatile char command)
cbm_k_setlfs: {
    // asm
    // asm { ldxdevice ldachannel ldycommand jsrCBM_SETLFS  }
    ldx device
    lda channel
    ldy command
    jsr CBM_SETLFS
    // cbm_k_setlfs::@return
    // }
    // [211] return 
    rts
  .segment Data
    channel: .byte 0
    device: .byte 0
    command: .byte 0
}
.segment Code
  // ferror
/**
 * @brief POSIX equivalent of ferror for the CBM C language.
 * This routine reads from secondary 15 the error message from the device!
 * The result is an error string, including the error code, message, track, sector.
 * The error string can be a maximum of 32 characters.
 *
 * @param stream FILE* stream.
 * @return int Contains a non-zero value if there is an error.
 */
// __mem() int ferror(__zp(9) FILE *stream)
ferror: {
    .label cbm_k_setnam1_filename = $d
    .label stream = 9
    .label errno_len = 8
    // unsigned char sp = (unsigned char)stream
    // [212] ferror::sp#0 = (char)ferror::stream#0 -- vbum1=_byte_pssz2 
    lda.z stream
    sta sp
    // cbm_k_setlfs(15, 8, 15)
    // [213] cbm_k_setlfs::channel = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_setlfs.channel
    // [214] cbm_k_setlfs::device = 8 -- vbum1=vbuc1 
    lda #8
    sta cbm_k_setlfs.device
    // [215] cbm_k_setlfs::command = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_setlfs.command
    // [216] call cbm_k_setlfs
    jsr cbm_k_setlfs
    // ferror::@11
    // cbm_k_setnam("")
    // [217] ferror::cbm_k_setnam1_filename = ferror::$18 -- pbuz1=pbuc1 
    lda #<ferror__18
    sta.z cbm_k_setnam1_filename
    lda #>ferror__18
    sta.z cbm_k_setnam1_filename+1
    // ferror::cbm_k_setnam1
    // strlen(filename)
    // [218] strlen::str#2 = ferror::cbm_k_setnam1_filename -- pbuz1=pbuz2 
    lda.z cbm_k_setnam1_filename
    sta.z strlen.str
    lda.z cbm_k_setnam1_filename+1
    sta.z strlen.str+1
    // [219] call strlen
    // [204] phi from ferror::cbm_k_setnam1 to strlen [phi:ferror::cbm_k_setnam1->strlen]
    // [204] phi strlen::str#5 = strlen::str#2 [phi:ferror::cbm_k_setnam1->strlen#0] -- register_copy 
    jsr strlen
    // strlen(filename)
    // [220] strlen::return#3 = strlen::len#2
    // ferror::@12
    // [221] ferror::cbm_k_setnam1_$0 = strlen::return#3
    // char filename_len = (char)strlen(filename)
    // [222] ferror::cbm_k_setnam1_filename_len = (char)ferror::cbm_k_setnam1_$0 -- vbum1=_byte_vwum2 
    lda cbm_k_setnam1_ferror__0
    sta cbm_k_setnam1_filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx cbm_k_setnam1_filename
    ldy cbm_k_setnam1_filename+1
    jsr CBM_SETNAM
    // ferror::cbm_k_open1
    // asm { jsrCBM_OPEN  }
    jsr CBM_OPEN
    // ferror::@6
    // cbm_k_chkin(15)
    // [225] ferror::cbm_k_chkin1_channel = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_chkin1_channel
    // ferror::cbm_k_chkin1
    // char status
    // [226] ferror::cbm_k_chkin1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // ferror::cbm_k_chrin1
    // char ch
    // [228] ferror::cbm_k_chrin1_ch = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chrin1_ch
    // asm
    // asm { jsrCBM_CHRIN stach  }
    jsr CBM_CHRIN
    sta cbm_k_chrin1_ch
    // return ch;
    // [230] ferror::cbm_k_chrin1_return#0 = ferror::cbm_k_chrin1_ch -- vbuaa=vbum1 
    // ferror::cbm_k_chrin1_@return
    // }
    // [231] ferror::cbm_k_chrin1_return#1 = ferror::cbm_k_chrin1_return#0
    // ferror::@7
    // char ch = cbm_k_chrin()
    // [232] ferror::ch#0 = ferror::cbm_k_chrin1_return#1 -- vbum1=vbuaa 
    sta ch
    // [233] phi from ferror::@7 to ferror::cbm_k_readst1 [phi:ferror::@7->ferror::cbm_k_readst1]
    // [233] phi ferror::errno_len#10 = 0 [phi:ferror::@7->ferror::cbm_k_readst1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z errno_len
    // [233] phi ferror::ch#10 = ferror::ch#0 [phi:ferror::@7->ferror::cbm_k_readst1#1] -- register_copy 
    // [233] phi ferror::errno_parsed#2 = 0 [phi:ferror::@7->ferror::cbm_k_readst1#2] -- vbum1=vbuc1 
    sta errno_parsed
    // ferror::cbm_k_readst1
  cbm_k_readst1:
    // char status
    // [234] ferror::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [236] ferror::cbm_k_readst1_return#0 = ferror::cbm_k_readst1_status -- vbuaa=vbum1 
    // ferror::cbm_k_readst1_@return
    // }
    // [237] ferror::cbm_k_readst1_return#1 = ferror::cbm_k_readst1_return#0
    // ferror::@8
    // cbm_k_readst()
    // [238] ferror::$6 = ferror::cbm_k_readst1_return#1
    // st = cbm_k_readst()
    // [239] ferror::st#1 = ferror::$6
    // while (!(st = cbm_k_readst()))
    // [240] if(0==ferror::st#1) goto ferror::@1 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b1
    // ferror::@2
    // __status = st
    // [241] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[ferror::sp#0] = ferror::st#1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // cbm_k_close(15)
    // [242] ferror::cbm_k_close1_channel = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_close1_channel
    // ferror::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // ferror::@9
    // return __errno;
    // [244] ferror::return#1 = __errno -- vwsm1=vwsm2 
    lda __errno
    sta return
    lda __errno+1
    sta return+1
    // ferror::@return
    // }
    // [245] return 
    rts
    // ferror::@1
  __b1:
    // if (!errno_parsed)
    // [246] if(0!=ferror::errno_parsed#2) goto ferror::@3 -- 0_neq_vbum1_then_la1 
    lda errno_parsed
    bne __b3
    // ferror::@4
    // if (ch == ',')
    // [247] if(ferror::ch#10!=',') goto ferror::@3 -- vbum1_neq_vbuc1_then_la1 
    lda #','
    cmp ch
    bne __b3
    // ferror::@5
    // errno_parsed++;
    // [248] ferror::errno_parsed#1 = ++ ferror::errno_parsed#2 -- vbum1=_inc_vbum1 
    inc errno_parsed
    // strncpy(temp, __errno_error, errno_len+1)
    // [249] strncpy::n#0 = ferror::errno_len#10 + 1 -- vwum1=vbuz2_plus_1 
    lda.z errno_len
    clc
    adc #1
    sta strncpy.n
    lda #0
    adc #0
    sta strncpy.n+1
    // [250] call strncpy
    // [314] phi from ferror::@5 to strncpy [phi:ferror::@5->strncpy]
    jsr strncpy
    // [251] phi from ferror::@5 to ferror::@13 [phi:ferror::@5->ferror::@13]
    // ferror::@13
    // atoi(temp)
    // [252] call atoi
    // [265] phi from ferror::@13 to atoi [phi:ferror::@13->atoi]
    // [265] phi atoi::str#2 = ferror::temp [phi:ferror::@13->atoi#0] -- pbuz1=pbuc1 
    lda #<temp
    sta.z atoi.str
    lda #>temp
    sta.z atoi.str+1
    jsr atoi
    // atoi(temp)
    // [253] atoi::return#4 = atoi::return#2
    // ferror::@14
    // [254] ferror::$14 = atoi::return#4
    // __errno = atoi(temp)
    // [255] __errno = ferror::$14 -- vwsm1=vwsm2 
    lda ferror__14
    sta __errno
    lda ferror__14+1
    sta __errno+1
    // [256] phi from ferror::@1 ferror::@14 ferror::@4 to ferror::@3 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3]
    // [256] phi ferror::errno_parsed#11 = ferror::errno_parsed#2 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3#0] -- register_copy 
    // ferror::@3
  __b3:
    // __errno_error[errno_len] = ch
    // [257] __errno_error[ferror::errno_len#10] = ferror::ch#10 -- pbuc1_derefidx_vbuz1=vbum2 
    lda ch
    ldy.z errno_len
    sta __errno_error,y
    // errno_len++;
    // [258] ferror::errno_len#1 = ++ ferror::errno_len#10 -- vbuz1=_inc_vbuz1 
    inc.z errno_len
    // ferror::cbm_k_chrin2
    // char ch
    // [259] ferror::cbm_k_chrin2_ch = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chrin2_ch
    // asm
    // asm { jsrCBM_CHRIN stach  }
    jsr CBM_CHRIN
    sta cbm_k_chrin2_ch
    // return ch;
    // [261] ferror::cbm_k_chrin2_return#0 = ferror::cbm_k_chrin2_ch -- vbuaa=vbum1 
    // ferror::cbm_k_chrin2_@return
    // }
    // [262] ferror::cbm_k_chrin2_return#1 = ferror::cbm_k_chrin2_return#0
    // ferror::@10
    // cbm_k_chrin()
    // [263] ferror::$15 = ferror::cbm_k_chrin2_return#1
    // ch = cbm_k_chrin()
    // [264] ferror::ch#1 = ferror::$15 -- vbum1=vbuaa 
    sta ch
    // [233] phi from ferror::@10 to ferror::cbm_k_readst1 [phi:ferror::@10->ferror::cbm_k_readst1]
    // [233] phi ferror::errno_len#10 = ferror::errno_len#1 [phi:ferror::@10->ferror::cbm_k_readst1#0] -- register_copy 
    // [233] phi ferror::ch#10 = ferror::ch#1 [phi:ferror::@10->ferror::cbm_k_readst1#1] -- register_copy 
    // [233] phi ferror::errno_parsed#2 = ferror::errno_parsed#11 [phi:ferror::@10->ferror::cbm_k_readst1#2] -- register_copy 
    jmp cbm_k_readst1
  .segment Data
    temp: .fill 4, 0
    ferror__18: .text ""
    .byte 0
    .label ferror__14 = fgets.remaining
    cbm_k_setnam1_filename_len: .byte 0
    .label cbm_k_setnam1_ferror__0 = fgets.remaining
    cbm_k_chkin1_channel: .byte 0
    cbm_k_chkin1_status: .byte 0
    cbm_k_chrin1_ch: .byte 0
    cbm_k_readst1_status: .byte 0
    cbm_k_close1_channel: .byte 0
    cbm_k_chrin2_ch: .byte 0
    .label return = fgets.remaining
    sp: .byte 0
    ch: .byte 0
    errno_parsed: .byte 0
}
.segment Code
  // atoi
// Converts the string argument str to an integer.
// __mem() int atoi(__zp(4) const char *str)
atoi: {
    .label str = 4
    // if (str[i] == '-')
    // [266] if(*atoi::str#2!='-') goto atoi::@3 -- _deref_pbuz1_neq_vbuc1_then_la1 
    ldy #0
    lda (str),y
    cmp #'-'
    bne __b2
    // [267] phi from atoi to atoi::@2 [phi:atoi->atoi::@2]
    // atoi::@2
    // [268] phi from atoi::@2 to atoi::@3 [phi:atoi::@2->atoi::@3]
    // [268] phi atoi::negative#2 = 1 [phi:atoi::@2->atoi::@3#0] -- vbuxx=vbuc1 
    ldx #1
    // [268] phi atoi::res#2 = 0 [phi:atoi::@2->atoi::@3#1] -- vwsm1=vwsc1 
    tya
    sta res
    sta res+1
    // [268] phi atoi::i#4 = 1 [phi:atoi::@2->atoi::@3#2] -- vbuyy=vbuc1 
    ldy #1
    jmp __b3
  // Iterate through all digits and update the result
    // [268] phi from atoi to atoi::@3 [phi:atoi->atoi::@3]
  __b2:
    // [268] phi atoi::negative#2 = 0 [phi:atoi->atoi::@3#0] -- vbuxx=vbuc1 
    ldx #0
    // [268] phi atoi::res#2 = 0 [phi:atoi->atoi::@3#1] -- vwsm1=vwsc1 
    txa
    sta res
    sta res+1
    // [268] phi atoi::i#4 = 0 [phi:atoi->atoi::@3#2] -- vbuyy=vbuc1 
    tay
    // atoi::@3
  __b3:
    // for (; str[i]>='0' && str[i]<='9'; ++i)
    // [269] if(atoi::str#2[atoi::i#4]<'0') goto atoi::@5 -- pbuz1_derefidx_vbuyy_lt_vbuc1_then_la1 
    lda (str),y
    cmp #'0'
    bcc __b5
    // atoi::@6
    // [270] if(atoi::str#2[atoi::i#4]<='9') goto atoi::@4 -- pbuz1_derefidx_vbuyy_le_vbuc1_then_la1 
    lda (str),y
    cmp #'9'
    bcc __b4
    beq __b4
    // atoi::@5
  __b5:
    // if(negative)
    // [271] if(0!=atoi::negative#2) goto atoi::@1 -- 0_neq_vbuxx_then_la1 
    // Return result with sign
    cpx #0
    bne __b1
    // [273] phi from atoi::@1 atoi::@5 to atoi::@return [phi:atoi::@1/atoi::@5->atoi::@return]
    // [273] phi atoi::return#2 = atoi::return#0 [phi:atoi::@1/atoi::@5->atoi::@return#0] -- register_copy 
    rts
    // atoi::@1
  __b1:
    // return -res;
    // [272] atoi::return#0 = - atoi::res#2 -- vwsm1=_neg_vwsm1 
    lda #0
    sec
    sbc return
    sta return
    lda #0
    sbc return+1
    sta return+1
    // atoi::@return
    // }
    // [274] return 
    rts
    // atoi::@4
  __b4:
    // res * 10
    // [275] atoi::$10 = atoi::res#2 << 2 -- vwsm1=vwsm2_rol_2 
    lda res
    asl
    sta atoi__10
    lda res+1
    rol
    sta atoi__10+1
    asl atoi__10
    rol atoi__10+1
    // [276] atoi::$11 = atoi::$10 + atoi::res#2 -- vwsm1=vwsm2_plus_vwsm1 
    clc
    lda atoi__11
    adc atoi__10
    sta atoi__11
    lda atoi__11+1
    adc atoi__10+1
    sta atoi__11+1
    // [277] atoi::$6 = atoi::$11 << 1 -- vwsm1=vwsm1_rol_1 
    asl atoi__6
    rol atoi__6+1
    // res * 10 + str[i]
    // [278] atoi::$7 = atoi::$6 + atoi::str#2[atoi::i#4] -- vwsm1=vwsm1_plus_pbuz2_derefidx_vbuyy 
    lda atoi__7
    clc
    adc (str),y
    sta atoi__7
    bcc !+
    inc atoi__7+1
  !:
    // res = res * 10 + str[i] - '0'
    // [279] atoi::res#1 = atoi::$7 - '0' -- vwsm1=vwsm1_minus_vbuc1 
    lda res
    sec
    sbc #'0'
    sta res
    bcs !+
    dec res+1
  !:
    // for (; str[i]>='0' && str[i]<='9'; ++i)
    // [280] atoi::i#2 = ++ atoi::i#4 -- vbuyy=_inc_vbuyy 
    iny
    // [268] phi from atoi::@4 to atoi::@3 [phi:atoi::@4->atoi::@3]
    // [268] phi atoi::negative#2 = atoi::negative#2 [phi:atoi::@4->atoi::@3#0] -- register_copy 
    // [268] phi atoi::res#2 = atoi::res#1 [phi:atoi::@4->atoi::@3#1] -- register_copy 
    // [268] phi atoi::i#4 = atoi::i#2 [phi:atoi::@4->atoi::@3#2] -- register_copy 
    jmp __b3
  .segment Data
    .label atoi__6 = fgets.remaining
    .label atoi__7 = fgets.remaining
    .label res = fgets.remaining
    .label return = fgets.remaining
    .label atoi__10 = fgets.read
    .label atoi__11 = fgets.remaining
}
.segment Code
  // screenlayer1
// Set the layer with which the conio will interact.
// void screenlayer1()
screenlayer1: {
    // screenlayer(1, *VERA_L1_MAPBASE, *VERA_L1_CONFIG)
    // [281] screenlayer::mapbase#0 = *VERA_L1_MAPBASE -- vbuxx=_deref_pbuc1 
    ldx VERA_L1_MAPBASE
    // [282] screenlayer::config#0 = *VERA_L1_CONFIG -- vbum1=_deref_pbuc1 
    lda VERA_L1_CONFIG
    sta screenlayer.config
    // [283] call screenlayer
    jsr screenlayer
    // screenlayer1::@return
    // }
    // [284] return 
    rts
}
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char textcolor(char color)
textcolor: {
    // __conio.color & 0xF0
    // [285] textcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_COLOR) & $f0 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and __conio+OFFSET_STRUCT_CX16_CONIO_T_COLOR
    // __conio.color & 0xF0 | color
    // [286] textcolor::$1 = textcolor::$0 | WHITE -- vbuaa=vbuaa_bor_vbuc1 
    ora #WHITE
    // __conio.color = __conio.color & 0xF0 | color
    // [287] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_COLOR) = textcolor::$1 -- _deref_pbuc1=vbuaa 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_COLOR
    // textcolor::@return
    // }
    // [288] return 
    rts
}
  // bgcolor
// Set the back color for text output.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor(char color)
bgcolor: {
    // __conio.color & 0x0F
    // [289] bgcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_COLOR) & $f -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$f
    and __conio+OFFSET_STRUCT_CX16_CONIO_T_COLOR
    // __conio.color & 0x0F | color << 4
    // [290] bgcolor::$2 = bgcolor::$0 | BLUE<<4 -- vbuaa=vbuaa_bor_vbuc1 
    ora #BLUE<<4
    // __conio.color = __conio.color & 0x0F | color << 4
    // [291] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_COLOR) = bgcolor::$2 -- _deref_pbuc1=vbuaa 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_COLOR
    // bgcolor::@return
    // }
    // [292] return 
    rts
}
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
// char cursor(char onoff)
cursor: {
    .const onoff = 0
    // __conio.cursor = onoff
    // [293] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_CURSOR
    // cursor::@return
    // }
    // [294] return 
    rts
}
  // cbm_k_plot_get
/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
// __mem() unsigned int cbm_k_plot_get()
cbm_k_plot_get: {
    // __mem unsigned char x
    // [295] cbm_k_plot_get::x = 0 -- vbum1=vbuc1 
    lda #0
    sta x
    // __mem unsigned char y
    // [296] cbm_k_plot_get::y = 0 -- vbum1=vbuc1 
    sta y
    // kickasm
    // kickasm( uses cbm_k_plot_get::x uses cbm_k_plot_get::y uses CBM_PLOT) {{ sec         jsr CBM_PLOT         stx y         sty x      }}
    sec
        jsr CBM_PLOT
        stx y
        sty x
    
    // MAKEWORD(x,y)
    // [298] cbm_k_plot_get::return#0 = cbm_k_plot_get::x w= cbm_k_plot_get::y -- vwum1=vbum2_word_vbum3 
    lda x
    sta return+1
    lda y
    sta return
    // cbm_k_plot_get::@return
    // }
    // [299] return 
    rts
  .segment Data
    x: .byte 0
    y: .byte 0
    .label return = fgets.remaining
}
.segment Code
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__register(X) char x, __register(Y) char y)
gotoxy: {
    // (x>=__conio.width)?__conio.width:x
    // [300] if(gotoxy::x#0>=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_WIDTH)) goto gotoxy::@1 -- vbuxx_ge__deref_pbuc1_then_la1 
    cpx __conio+OFFSET_STRUCT_CX16_CONIO_T_WIDTH
    bcs __b1
    // [302] phi from gotoxy gotoxy::@1 to gotoxy::@2 [phi:gotoxy/gotoxy::@1->gotoxy::@2]
    // [302] phi gotoxy::$3 = gotoxy::x#0 [phi:gotoxy/gotoxy::@1->gotoxy::@2#0] -- register_copy 
    jmp __b2
    // gotoxy::@1
  __b1:
    // [301] gotoxy::$2 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_WIDTH) -- vbuxx=_deref_pbuc1 
    ldx __conio+OFFSET_STRUCT_CX16_CONIO_T_WIDTH
    // gotoxy::@2
  __b2:
    // __conio.cursor_x = (x>=__conio.width)?__conio.width:x
    // [303] *((char *)&__conio) = gotoxy::$3 -- _deref_pbuc1=vbuxx 
    stx __conio
    // (y>=__conio.height)?__conio.height:y
    // [304] if(gotoxy::y#0>=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_HEIGHT)) goto gotoxy::@3 -- vbuyy_ge__deref_pbuc1_then_la1 
    cpy __conio+OFFSET_STRUCT_CX16_CONIO_T_HEIGHT
    bcs __b3
    // gotoxy::@4
    // [305] gotoxy::$14 = gotoxy::y#0 -- vbuaa=vbuyy 
    tya
    // [306] phi from gotoxy::@3 gotoxy::@4 to gotoxy::@5 [phi:gotoxy::@3/gotoxy::@4->gotoxy::@5]
    // [306] phi gotoxy::$7 = gotoxy::$6 [phi:gotoxy::@3/gotoxy::@4->gotoxy::@5#0] -- register_copy 
    // gotoxy::@5
  __b5:
    // __conio.cursor_y = (y>=__conio.height)?__conio.height:y
    // [307] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_CURSOR_Y) = gotoxy::$7 -- _deref_pbuc1=vbuaa 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_CURSOR_Y
    // __conio.cursor_x << 1
    // [308] gotoxy::$8 = *((char *)&__conio) << 1 -- vbuxx=_deref_pbuc1_rol_1 
    lda __conio
    asl
    tax
    // __conio.offsets[y] + __conio.cursor_x << 1
    // [309] gotoxy::$10 = gotoxy::y#0 << 1 -- vbuaa=vbuyy_rol_1 
    tya
    asl
    // [310] gotoxy::$9 = ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_OFFSETS)[gotoxy::$10] + gotoxy::$8 -- vwum1=pwuc1_derefidx_vbuaa_plus_vbuxx 
    tay
    txa
    clc
    adc __conio+OFFSET_STRUCT_CX16_CONIO_T_OFFSETS,y
    sta gotoxy__9
    lda __conio+OFFSET_STRUCT_CX16_CONIO_T_OFFSETS+1,y
    adc #0
    sta gotoxy__9+1
    // __conio.offset = __conio.offsets[y] + __conio.cursor_x << 1
    // [311] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_OFFSET) = gotoxy::$9 -- _deref_pwuc1=vwum1 
    lda gotoxy__9
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_OFFSET
    lda gotoxy__9+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_OFFSET+1
    // gotoxy::@return
    // }
    // [312] return 
    rts
    // gotoxy::@3
  __b3:
    // (y>=__conio.height)?__conio.height:y
    // [313] gotoxy::$6 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_HEIGHT) -- vbuaa=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_T_HEIGHT
    jmp __b5
  .segment Data
    .label gotoxy__9 = fgets.remaining
}
.segment Code
  // strncpy
/// Copies up to n characters from the string pointed to, by src to dst.
/// In a case where the length of src is less than that of n, the remainder of dst will be padded with null bytes.
/// @param dst ? This is the pointer to the destination array where the content is to be copied.
/// @param src ? This is the string to be copied.
/// @param n ? The number of characters to be copied from source.
/// @return The destination
// char * strncpy(__zp(4) char *dst, __zp(2) const char *src, __mem() unsigned int n)
strncpy: {
    .label dst = 4
    .label src = 2
    // [315] phi from strncpy to strncpy::@1 [phi:strncpy->strncpy::@1]
    // [315] phi strncpy::dst#2 = ferror::temp [phi:strncpy->strncpy::@1#0] -- pbuz1=pbuc1 
    lda #<ferror.temp
    sta.z dst
    lda #>ferror.temp
    sta.z dst+1
    // [315] phi strncpy::src#2 = __errno_error [phi:strncpy->strncpy::@1#1] -- pbuz1=pbuc1 
    lda #<__errno_error
    sta.z src
    lda #>__errno_error
    sta.z src+1
    // [315] phi strncpy::i#2 = 0 [phi:strncpy->strncpy::@1#2] -- vwum1=vwuc1 
    lda #<0
    sta i
    sta i+1
    // strncpy::@1
  __b1:
    // for(size_t i = 0;i<n;i++)
    // [316] if(strncpy::i#2<strncpy::n#0) goto strncpy::@2 -- vwum1_lt_vwum2_then_la1 
    lda i+1
    cmp n+1
    bcc __b2
    bne !+
    lda i
    cmp n
    bcc __b2
  !:
    // strncpy::@return
    // }
    // [317] return 
    rts
    // strncpy::@2
  __b2:
    // char c = *src
    // [318] strncpy::c#0 = *strncpy::src#2 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (src),y
    // if(c)
    // [319] if(0==strncpy::c#0) goto strncpy::@3 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b3
    // strncpy::@4
    // src++;
    // [320] strncpy::src#0 = ++ strncpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [321] phi from strncpy::@2 strncpy::@4 to strncpy::@3 [phi:strncpy::@2/strncpy::@4->strncpy::@3]
    // [321] phi strncpy::src#6 = strncpy::src#2 [phi:strncpy::@2/strncpy::@4->strncpy::@3#0] -- register_copy 
    // strncpy::@3
  __b3:
    // *dst++ = c
    // [322] *strncpy::dst#2 = strncpy::c#0 -- _deref_pbuz1=vbuaa 
    ldy #0
    sta (dst),y
    // *dst++ = c;
    // [323] strncpy::dst#0 = ++ strncpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // for(size_t i = 0;i<n;i++)
    // [324] strncpy::i#1 = ++ strncpy::i#2 -- vwum1=_inc_vwum1 
    inc i
    bne !+
    inc i+1
  !:
    // [315] phi from strncpy::@3 to strncpy::@1 [phi:strncpy::@3->strncpy::@1]
    // [315] phi strncpy::dst#2 = strncpy::dst#0 [phi:strncpy::@3->strncpy::@1#0] -- register_copy 
    // [315] phi strncpy::src#2 = strncpy::src#6 [phi:strncpy::@3->strncpy::@1#1] -- register_copy 
    // [315] phi strncpy::i#2 = strncpy::i#1 [phi:strncpy::@3->strncpy::@1#2] -- register_copy 
    jmp __b1
  .segment Data
    .label i = fgets.remaining
    .label n = fgets.read
}
.segment Code
  // screenlayer
// --- layer management in VERA ---
// void screenlayer(char layer, __register(X) char mapbase, __mem() char config)
screenlayer: {
    // __mem char vera_dc_hscale_temp = *VERA_DC_HSCALE
    // [325] screenlayer::vera_dc_hscale_temp#0 = *VERA_DC_HSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_HSCALE
    sta vera_dc_hscale_temp
    // __mem char vera_dc_vscale_temp = *VERA_DC_VSCALE
    // [326] screenlayer::vera_dc_vscale_temp#0 = *VERA_DC_VSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_VSCALE
    sta vera_dc_vscale_temp
    // __conio.layer = 0
    // [327] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_LAYER) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_LAYER
    // mapbase >> 7
    // [328] screenlayer::$0 = screenlayer::mapbase#0 >> 7 -- vbuaa=vbuxx_ror_7 
    txa
    rol
    rol
    and #1
    // __conio.mapbase_bank = mapbase >> 7
    // [329] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_MAPBASE_BANK) = screenlayer::$0 -- _deref_pbuc1=vbuaa 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_MAPBASE_BANK
    // (mapbase)<<1
    // [330] screenlayer::$1 = screenlayer::mapbase#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // MAKEWORD((mapbase)<<1,0)
    // [331] screenlayer::$2 = screenlayer::$1 w= 0 -- vwum1=vbuaa_word_vbuc1 
    ldy #0
    sta screenlayer__2+1
    sty screenlayer__2
    // __conio.mapbase_offset = MAKEWORD((mapbase)<<1,0)
    // [332] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_MAPBASE_OFFSET) = screenlayer::$2 -- _deref_pwuc1=vwum1 
    tya
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_MAPBASE_OFFSET
    lda screenlayer__2+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_MAPBASE_OFFSET+1
    // config & VERA_LAYER_WIDTH_MASK
    // [333] screenlayer::$7 = screenlayer::config#0 & VERA_LAYER_WIDTH_MASK -- vbuaa=vbum1_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    and config
    // (config & VERA_LAYER_WIDTH_MASK) >> 4
    // [334] screenlayer::$8 = screenlayer::$7 >> 4 -- vbuxx=vbuaa_ror_4 
    lsr
    lsr
    lsr
    lsr
    tax
    // __conio.mapwidth = VERA_LAYER_DIM[ (config & VERA_LAYER_WIDTH_MASK) >> 4]
    // [335] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_MAPWIDTH) = screenlayer::VERA_LAYER_DIM[screenlayer::$8] -- _deref_pbuc1=pbuc2_derefidx_vbuxx 
    lda VERA_LAYER_DIM,x
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_MAPWIDTH
    // config & VERA_LAYER_HEIGHT_MASK
    // [336] screenlayer::$5 = screenlayer::config#0 & VERA_LAYER_HEIGHT_MASK -- vbuaa=vbum1_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    and config
    // (config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [337] screenlayer::$6 = screenlayer::$5 >> 6 -- vbuaa=vbuaa_ror_6 
    rol
    rol
    rol
    and #3
    // __conio.mapheight = VERA_LAYER_DIM[ (config & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [338] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_MAPHEIGHT) = screenlayer::VERA_LAYER_DIM[screenlayer::$6] -- _deref_pbuc1=pbuc2_derefidx_vbuaa 
    tay
    lda VERA_LAYER_DIM,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_MAPHEIGHT
    // __conio.rowskip = VERA_LAYER_SKIP[(config & VERA_LAYER_WIDTH_MASK)>>4]
    // [339] screenlayer::$16 = screenlayer::$8 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [340] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_ROWSKIP) = screenlayer::VERA_LAYER_SKIP[screenlayer::$16] -- _deref_pwuc1=pwuc2_derefidx_vbuaa 
    // __conio.rowshift = ((config & VERA_LAYER_WIDTH_MASK)>>4)+6;
    tay
    lda VERA_LAYER_SKIP,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_ROWSKIP
    lda VERA_LAYER_SKIP+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_ROWSKIP+1
    // vera_dc_hscale_temp == 0x80
    // [341] screenlayer::$9 = screenlayer::vera_dc_hscale_temp#0 == $80 -- vboaa=vbum1_eq_vbuc1 
    lda vera_dc_hscale_temp
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // 40 << (char)(vera_dc_hscale_temp == 0x80)
    // [342] screenlayer::$18 = (char)screenlayer::$9 -- vbuxx=vbuaa 
    tax
    // [343] screenlayer::$10 = $28 << screenlayer::$18 -- vbuaa=vbuc1_rol_vbuxx 
    lda #$28
    cpx #0
    beq !e+
  !:
    asl
    dex
    bne !-
  !e:
    // (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [344] screenlayer::$11 = screenlayer::$10 - 1 -- vbuaa=vbuaa_minus_1 
    sec
    sbc #1
    // __conio.width = (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [345] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_WIDTH) = screenlayer::$11 -- _deref_pbuc1=vbuaa 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_WIDTH
    // vera_dc_vscale_temp == 0x80
    // [346] screenlayer::$12 = screenlayer::vera_dc_vscale_temp#0 == $80 -- vboaa=vbum1_eq_vbuc1 
    lda vera_dc_vscale_temp
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // 30 << (char)(vera_dc_vscale_temp == 0x80)
    // [347] screenlayer::$19 = (char)screenlayer::$12 -- vbuxx=vbuaa 
    tax
    // [348] screenlayer::$13 = $1e << screenlayer::$19 -- vbuaa=vbuc1_rol_vbuxx 
    lda #$1e
    cpx #0
    beq !e+
  !:
    asl
    dex
    bne !-
  !e:
    // (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [349] screenlayer::$14 = screenlayer::$13 - 1 -- vbuaa=vbuaa_minus_1 
    sec
    sbc #1
    // __conio.height = (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [350] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_HEIGHT) = screenlayer::$14 -- _deref_pbuc1=vbuaa 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_HEIGHT
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [351] screenlayer::mapbase_offset#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_MAPBASE_OFFSET) -- vwum1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_T_MAPBASE_OFFSET
    sta mapbase_offset
    lda __conio+OFFSET_STRUCT_CX16_CONIO_T_MAPBASE_OFFSET+1
    sta mapbase_offset+1
    // [352] phi from screenlayer to screenlayer::@1 [phi:screenlayer->screenlayer::@1]
    // [352] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#0 [phi:screenlayer->screenlayer::@1#0] -- register_copy 
    // [352] phi screenlayer::y#2 = 0 [phi:screenlayer->screenlayer::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // screenlayer::@1
  __b1:
    // for(register char y=0; y<=__conio.height; y++)
    // [353] if(screenlayer::y#2<=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_HEIGHT)) goto screenlayer::@2 -- vbuxx_le__deref_pbuc1_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_T_HEIGHT
    stx.z $ff
    cmp.z $ff
    bcs __b2
    // screenlayer::@return
    // }
    // [354] return 
    rts
    // screenlayer::@2
  __b2:
    // __conio.offsets[y] = mapbase_offset
    // [355] screenlayer::$17 = screenlayer::y#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [356] ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_OFFSETS)[screenlayer::$17] = screenlayer::mapbase_offset#2 -- pwuc1_derefidx_vbuaa=vwum1 
    tay
    lda mapbase_offset
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_OFFSETS,y
    lda mapbase_offset+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_T_OFFSETS+1,y
    // mapbase_offset += __conio.rowskip
    // [357] screenlayer::mapbase_offset#1 = screenlayer::mapbase_offset#2 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_T_ROWSKIP) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda mapbase_offset
    adc __conio+OFFSET_STRUCT_CX16_CONIO_T_ROWSKIP
    sta mapbase_offset
    lda mapbase_offset+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_T_ROWSKIP+1
    sta mapbase_offset+1
    // for(register char y=0; y<=__conio.height; y++)
    // [358] screenlayer::y#1 = ++ screenlayer::y#2 -- vbuxx=_inc_vbuxx 
    inx
    // [352] phi from screenlayer::@2 to screenlayer::@1 [phi:screenlayer::@2->screenlayer::@1]
    // [352] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#1 [phi:screenlayer::@2->screenlayer::@1#0] -- register_copy 
    // [352] phi screenlayer::y#2 = screenlayer::y#1 [phi:screenlayer::@2->screenlayer::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    VERA_LAYER_DIM: .byte $1f, $3f, $7f, $ff
    VERA_LAYER_SKIP: .word $40, $80, $100, $200
    .label screenlayer__2 = fgets.remaining
    .label config = fopen.pathstep
    .label vera_dc_hscale_temp = fopen.pathpos_1
    .label vera_dc_vscale_temp = ferror.errno_parsed
    .label mapbase_offset = fgets.remaining
}
  // Exported Global Data
  /**
 * @file errno.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Contains the POSIX implementation of errno, which contains the last error detected.
 * @version 0.1
 * @date 2023-03-18
 * 
 * @copyright Copyright (c) 2023
 * 
 */
  __errno_error: .fill $20, 0
  __errno: .word 0
  __conio: .fill cx16_file.SIZEOF_STRUCT_CX16_CONIO_T, 0
  __stdio_file: .fill cx16_file.SIZEOF_STRUCT_FILE, 0
  __stdio_filecount: .byte 0
  isr_vsync: .word 0
} // namespace
