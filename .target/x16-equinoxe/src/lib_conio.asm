  //
#importonce
  // File Comments
/* Generate a library for printing. */
  // Library
.namespace lib_conio {
  // Upstart
.cpu _65c02
#if !__asm_import__lib_conio__

   .segmentdef Code
   .segmentdef Data
#endif

  // Global Constants & labels
  .label WHITE = 1
  .label BLUE = 6
  ///< Read a character from the current channel for input.
  .label CBM_GETIN = $ffe4
  ///< Close a logical file.
  .label CBM_CLRCHN = $ffcc
  ///< Load a logical file.
  .label CBM_PLOT = $fff0
  .label BINARY = 2
  .label OCTAL = 8
  .label DECIMAL = $a
  .label HEXADECIMAL = $10
  .label VERA_INC_1 = $10
  .label VERA_ADDRSEL = 1
  .label VERA_LAYER_WIDTH_MASK = $30
  .label VERA_LAYER_HEIGHT_MASK = $c0
  .label OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET = 3
  .label OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK = 5
  .label OFFSET_STRUCT_CX16_CONIO_S_MAPHEIGHT = 9
  .label OFFSET_STRUCT_CX16_CONIO_S_MAPWIDTH = 8
  .label OFFSET_STRUCT_CX16_CONIO_S_COLOR = $d
  .label OFFSET_STRUCT_CX16_CONIO_S_ROWSKIP = $a
  .label OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y = 1
  .label OFFSET_STRUCT_CX16_CONIO_S_OFFSET = $13
  .label OFFSET_STRUCT_CX16_CONIO_S_WIDTH = 6
  .label OFFSET_STRUCT_CX16_CONIO_S_HEIGHT = 7
  .label OFFSET_STRUCT_CX16_CONIO_S_OFFSETS = $15
  .label OFFSET_STRUCT_CX16_CONIO_S_HSCROLL = $11
  .label OFFSET_STRUCT_CX16_CONIO_S_LAYER = 2
  .label OFFSET_STRUCT_CX16_CONIO_S_SCROLL = $f
  .label OFFSET_STRUCT_CX16_CONIO_S_BORDERCOLOR = $e
  .label OFFSET_STRUCT_CX16_CONIO_S_CURSOR = $c
  .label OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .label STACK_BASE = $103
  .label SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .label SIZEOF_STRUCT_CX16_CONIO_S = $8f
  /// $9F20 VRAM Address (7:0)
  .label VERA_ADDRX_L = $9f20
  /// $9F21 VRAM Address (15:8)
  .label VERA_ADDRX_M = $9f21
  /// $9F22 VRAM Address (7:0)
  /// Bit 4-7: Address Increment  The following is the amount incremented per value value:increment
  ///                             0:0, 1:1, 2:2, 3:4, 4:8, 5:16, 6:32, 7:64, 8:128, 9:256, 10:512, 11:40, 12:80, 13:160, 14:320, 15:640
  /// Bit 3: DECR Setting the DECR bit, will decrement instead of increment by the value set by the 'Address Increment' field.
  /// Bit 0: VRAM Address (16)
  .label VERA_ADDRX_H = $9f22
  /// $9F23	DATA0	VRAM Data port 0
  .label VERA_DATA0 = $9f23
  /// $9F24	DATA1	VRAM Data port 1
  .label VERA_DATA1 = $9f24
  /// $9F25	CTRL Control
  /// Bit 7: Reset
  /// Bit 1: DCSEL
  /// Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  /// $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
  .label VERA_DC_HSCALE = $9f2a
  /// $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
  .label VERA_DC_VSCALE = $9f2b
  /// $9F2C	DC_BORDER (DCSEL=0)	Border Color
  .label VERA_DC_BORDER = $9f2c
  /// $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  /// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __lib_conio_start
// void __lib_conio_start()
__lib_conio_start: {
    // __lib_conio_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [3] call conio_x16_init
    // [113] phi from __lib_conio_start::__init1 to conio_x16_init [phi:__lib_conio_start::__init1->conio_x16_init]
    jsr conio_x16_init
    // __lib_conio_start::@return
    // [4] return 
    rts
}
  // printf_uchar
// Print an unsigned char using a specific format
// void printf_uchar(__zp($2c) void (*putc)(char), __mem() char uvalue, __mem() char format_min_length, __mem() char format_justify_left, __mem() char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, __mem() char format_radix)
printf_uchar: {
    .label putc = $2c
    // format_sign_always?'+':0
    // [5] if(0!=printf_uchar::format_sign_always) goto printf_uchar::@1 -- 0_neq_vbum1_then_la1 
    lda format_sign_always
    bne __b1
    // [7] phi from printf_uchar to printf_uchar::@2 [phi:printf_uchar->printf_uchar::@2]
    // [7] phi printf_uchar::$2 = 0 [phi:printf_uchar->printf_uchar::@2#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b2
    // [6] phi from printf_uchar to printf_uchar::@1 [phi:printf_uchar->printf_uchar::@1]
    // printf_uchar::@1
  __b1:
    // format_sign_always?'+':0
    // [7] phi from printf_uchar::@1 to printf_uchar::@2 [phi:printf_uchar::@1->printf_uchar::@2]
    // [7] phi printf_uchar::$2 = '+' [phi:printf_uchar::@1->printf_uchar::@2#0] -- vbuaa=vbuc1 
    lda #'+'
    // printf_uchar::@2
  __b2:
    // printf_buffer.sign = format_sign_always?'+':0
    // [8] *((char *)&printf_buffer) = printf_uchar::$2 -- _deref_pbuc1=vbuaa 
    // Handle any sign
    sta lib_conio.printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format_radix)
    // [9] uctoa::value#2 = printf_uchar::uvalue -- vbuxx=vbum1 
    ldx uvalue
    // [10] uctoa::radix#1 = printf_uchar::format_radix -- vbuaa=vbum1 
    lda format_radix
    // [11] call uctoa
  // Format number into buffer
    // [298] phi from printf_uchar::@2 to uctoa [phi:printf_uchar::@2->uctoa]
    // [298] phi uctoa::value#10 = uctoa::value#2 [phi:printf_uchar::@2->uctoa#0] -- register_copy 
    // [298] phi uctoa::radix#2 = uctoa::radix#1 [phi:printf_uchar::@2->uctoa#1] -- register_copy 
    jsr uctoa
    // printf_uchar::@3
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [12] printf_number_buffer::putc#5 = printf_uchar::putc -- pprz1=pprz2 
    lda.z putc
    sta.z printf_number_buffer.putc
    lda.z putc+1
    sta.z printf_number_buffer.putc+1
    // [13] *(&printf_number_buffer::buffer) = memcpy(*(&printf_buffer), struct printf_buffer_number, SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER
  !:
    lda lib_conio.printf_buffer-1,y
    sta printf_number_buffer.buffer-1,y
    dey
    bne !-
    // [14] printf_number_buffer::format_min_length#5 = printf_uchar::format_min_length -- vbuxx=vbum1 
    ldx format_min_length
    // [15] printf_number_buffer::format_justify_left#5 = printf_uchar::format_justify_left -- vbum1=vbum2 
    lda format_justify_left
    sta printf_number_buffer.format_justify_left
    // [16] printf_number_buffer::format_zero_padding#5 = printf_uchar::format_zero_padding -- vbum1=vbum2 
    lda format_zero_padding
    sta printf_number_buffer.format_zero_padding
    // [17] printf_number_buffer::format_upper_case#5 = printf_uchar::format_upper_case -- vbum1=vbum2 
    lda format_upper_case
    sta printf_number_buffer.format_upper_case
    // [18] call printf_number_buffer
  // Print using format
    // [327] phi from printf_uchar::@3 to printf_number_buffer [phi:printf_uchar::@3->printf_number_buffer]
    // [327] phi printf_number_buffer::format_upper_case#10 = printf_number_buffer::format_upper_case#5 [phi:printf_uchar::@3->printf_number_buffer#0] -- register_copy 
    // [327] phi printf_number_buffer::putc#10 = printf_number_buffer::putc#5 [phi:printf_uchar::@3->printf_number_buffer#1] -- register_copy 
    // [327] phi printf_number_buffer::format_zero_padding#10 = printf_number_buffer::format_zero_padding#5 [phi:printf_uchar::@3->printf_number_buffer#2] -- register_copy 
    // [327] phi printf_number_buffer::format_justify_left#10 = printf_number_buffer::format_justify_left#5 [phi:printf_uchar::@3->printf_number_buffer#3] -- register_copy 
    // [327] phi printf_number_buffer::format_min_length#10 = printf_number_buffer::format_min_length#5 [phi:printf_uchar::@3->printf_number_buffer#4] -- register_copy 
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [19] return 
    rts
  .segment Data
    .label uvalue = uctoa.max_digits
    .label format_min_length = printf_ulong.format_justify_left
    .label format_justify_left = printf_ulong.format_zero_padding
    .label format_sign_always = uctoa.digit
    .label format_zero_padding = printf_ulong.format_upper_case
    format_upper_case: .byte 0
    .label format_radix = uctoa.started
}
.segment Code
  // printf_schar
// Print a signed char using a specific format
// void printf_schar(__zp($2a) void (*putc)(char), __mem() signed char value, __mem() char format_min_length, __mem() char format_justify_left, __mem() char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, __mem() char format_radix)
printf_schar: {
    .label putc = $2a
    // printf_buffer.sign = 0
    // [20] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta lib_conio.printf_buffer
    // if(value<0)
    // [21] if(printf_schar::value<0) goto printf_schar::@1 -- vbsm1_lt_0_then_la1 
    lda value
    bmi __b1
    // printf_schar::@3
    // if(format_sign_always)
    // [22] if(0==printf_schar::format_sign_always) goto printf_schar::@2 -- 0_eq_vbum1_then_la1 
    lda format_sign_always
    beq __b2
    // printf_schar::@4
    // printf_buffer.sign = '+'
    // [23] *((char *)&printf_buffer) = '+' -- _deref_pbuc1=vbuc2 
    lda #'+'
    sta lib_conio.printf_buffer
    // printf_schar::@2
  __b2:
    // uctoa(uvalue, printf_buffer.digits, format_radix)
    // [24] uctoa::value#1 = (char)printf_schar::value -- vbuxx=vbum1 
    ldx value
    // [25] uctoa::radix#0 = printf_schar::format_radix -- vbuaa=vbum1 
    lda format_radix
    // [26] call uctoa
    // [298] phi from printf_schar::@2 to uctoa [phi:printf_schar::@2->uctoa]
    // [298] phi uctoa::value#10 = uctoa::value#1 [phi:printf_schar::@2->uctoa#0] -- register_copy 
    // [298] phi uctoa::radix#2 = uctoa::radix#0 [phi:printf_schar::@2->uctoa#1] -- register_copy 
    jsr uctoa
    // printf_schar::@5
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [27] printf_number_buffer::putc#4 = printf_schar::putc
    // [28] *(&printf_number_buffer::buffer) = memcpy(*(&printf_buffer), struct printf_buffer_number, SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER
  !:
    lda lib_conio.printf_buffer-1,y
    sta printf_number_buffer.buffer-1,y
    dey
    bne !-
    // [29] printf_number_buffer::format_min_length#4 = printf_schar::format_min_length -- vbuxx=vbum1 
    ldx format_min_length
    // [30] printf_number_buffer::format_justify_left#4 = printf_schar::format_justify_left
    // [31] printf_number_buffer::format_zero_padding#4 = printf_schar::format_zero_padding
    // [32] printf_number_buffer::format_upper_case#4 = printf_schar::format_upper_case
    // [33] call printf_number_buffer
  // Print using format
    // [327] phi from printf_schar::@5 to printf_number_buffer [phi:printf_schar::@5->printf_number_buffer]
    // [327] phi printf_number_buffer::format_upper_case#10 = printf_number_buffer::format_upper_case#4 [phi:printf_schar::@5->printf_number_buffer#0] -- register_copy 
    // [327] phi printf_number_buffer::putc#10 = printf_number_buffer::putc#4 [phi:printf_schar::@5->printf_number_buffer#1] -- register_copy 
    // [327] phi printf_number_buffer::format_zero_padding#10 = printf_number_buffer::format_zero_padding#4 [phi:printf_schar::@5->printf_number_buffer#2] -- register_copy 
    // [327] phi printf_number_buffer::format_justify_left#10 = printf_number_buffer::format_justify_left#4 [phi:printf_schar::@5->printf_number_buffer#3] -- register_copy 
    // [327] phi printf_number_buffer::format_min_length#10 = printf_number_buffer::format_min_length#4 [phi:printf_schar::@5->printf_number_buffer#4] -- register_copy 
    jsr printf_number_buffer
    // printf_schar::@return
    // }
    // [34] return 
    rts
    // printf_schar::@1
  __b1:
    // -value
    // [35] printf_schar::$4 = - printf_schar::value -- vbsaa=_neg_vbsm1 
    lda value
    eor #$ff
    clc
    adc #1
    // value = -value
    // [36] printf_schar::value = printf_schar::$4 -- vbsm1=vbsaa 
    // Negative
    sta value
    // printf_buffer.sign = '-'
    // [37] *((char *)&printf_buffer) = '-' -- _deref_pbuc1=vbuc2 
    lda #'-'
    sta lib_conio.printf_buffer
    jmp __b2
  .segment Data
    .label value = uctoa.max_digits
    .label format_min_length = printf_padding.i
    .label format_justify_left = printf_number_buffer.format_justify_left
    .label format_sign_always = uctoa.digit
    .label format_zero_padding = printf_number_buffer.format_zero_padding
    .label format_upper_case = printf_number_buffer.format_upper_case
    .label format_radix = uctoa.started
}
.segment Code
  // printf_uint
// Print an unsigned int using a specific format
// void printf_uint(__zp($2c) void (*putc)(char), __mem() unsigned int uvalue, __mem() char format_min_length, __mem() char format_justify_left, __mem() char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, __mem() char format_radix)
printf_uint: {
    .label putc = $2c
    // format_sign_always?'+':0
    // [38] if(0!=printf_uint::format_sign_always) goto printf_uint::@1 -- 0_neq_vbum1_then_la1 
    lda format_sign_always
    bne __b1
    // [40] phi from printf_uint to printf_uint::@2 [phi:printf_uint->printf_uint::@2]
    // [40] phi printf_uint::$2 = 0 [phi:printf_uint->printf_uint::@2#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b2
    // [39] phi from printf_uint to printf_uint::@1 [phi:printf_uint->printf_uint::@1]
    // printf_uint::@1
  __b1:
    // format_sign_always?'+':0
    // [40] phi from printf_uint::@1 to printf_uint::@2 [phi:printf_uint::@1->printf_uint::@2]
    // [40] phi printf_uint::$2 = '+' [phi:printf_uint::@1->printf_uint::@2#0] -- vbuaa=vbuc1 
    lda #'+'
    // printf_uint::@2
  __b2:
    // printf_buffer.sign = format_sign_always?'+':0
    // [41] *((char *)&printf_buffer) = printf_uint::$2 -- _deref_pbuc1=vbuaa 
    // void printf_uint(void (*putc)(char), unsigned int uvalue, struct printf_format_number format) {
    // Handle any sign
    sta lib_conio.printf_buffer
    // utoa(uvalue, printf_buffer.digits, format_radix)
    // [42] utoa::value#2 = printf_uint::uvalue
    // [43] utoa::radix#1 = printf_uint::format_radix -- vbuaa=vbum1 
    lda format_radix
    // [44] call utoa
  // Format number into buffer
    // [369] phi from printf_uint::@2 to utoa [phi:printf_uint::@2->utoa]
    // [369] phi utoa::value#10 = utoa::value#2 [phi:printf_uint::@2->utoa#0] -- register_copy 
    // [369] phi utoa::radix#2 = utoa::radix#1 [phi:printf_uint::@2->utoa#1] -- register_copy 
    jsr utoa
    // printf_uint::@3
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [45] printf_number_buffer::putc#3 = printf_uint::putc -- pprz1=pprz2 
    lda.z putc
    sta.z printf_number_buffer.putc
    lda.z putc+1
    sta.z printf_number_buffer.putc+1
    // [46] *(&printf_number_buffer::buffer) = memcpy(*(&printf_buffer), struct printf_buffer_number, SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER
  !:
    lda lib_conio.printf_buffer-1,y
    sta printf_number_buffer.buffer-1,y
    dey
    bne !-
    // [47] printf_number_buffer::format_min_length#3 = printf_uint::format_min_length -- vbuxx=vbum1 
    ldx format_min_length
    // [48] printf_number_buffer::format_justify_left#3 = printf_uint::format_justify_left -- vbum1=vbum2 
    lda format_justify_left
    sta printf_number_buffer.format_justify_left
    // [49] printf_number_buffer::format_zero_padding#3 = printf_uint::format_zero_padding -- vbum1=vbum2 
    lda format_zero_padding
    sta printf_number_buffer.format_zero_padding
    // [50] printf_number_buffer::format_upper_case#3 = printf_uint::format_upper_case -- vbum1=vbum2 
    lda format_upper_case
    sta printf_number_buffer.format_upper_case
    // [51] call printf_number_buffer
  // Print using format
    // [327] phi from printf_uint::@3 to printf_number_buffer [phi:printf_uint::@3->printf_number_buffer]
    // [327] phi printf_number_buffer::format_upper_case#10 = printf_number_buffer::format_upper_case#3 [phi:printf_uint::@3->printf_number_buffer#0] -- register_copy 
    // [327] phi printf_number_buffer::putc#10 = printf_number_buffer::putc#3 [phi:printf_uint::@3->printf_number_buffer#1] -- register_copy 
    // [327] phi printf_number_buffer::format_zero_padding#10 = printf_number_buffer::format_zero_padding#3 [phi:printf_uint::@3->printf_number_buffer#2] -- register_copy 
    // [327] phi printf_number_buffer::format_justify_left#10 = printf_number_buffer::format_justify_left#3 [phi:printf_uint::@3->printf_number_buffer#3] -- register_copy 
    // [327] phi printf_number_buffer::format_min_length#10 = printf_number_buffer::format_min_length#3 [phi:printf_uint::@3->printf_number_buffer#4] -- register_copy 
    jsr printf_number_buffer
    // printf_uint::@return
    // }
    // [52] return 
    rts
  .segment Data
    .label uvalue = clrscr.ch
    .label format_min_length = printf_padding.i
    .label format_justify_left = printf_ulong.format_justify_left
    .label format_sign_always = uctoa.max_digits
    .label format_zero_padding = printf_ulong.format_zero_padding
    .label format_upper_case = printf_ulong.format_upper_case
    .label format_radix = uctoa.digit
}
.segment Code
  // printf_sint
// // Print a signed integer using a specific format
// void printf_sint(__zp($2a) void (*putc)(char), __mem() int value, __mem() char format_min_length, __mem() char format_justify_left, __mem() char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, __mem() char format_radix)
printf_sint: {
    .label putc = $2a
    // printf_buffer.sign = 0
    // [53] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta lib_conio.printf_buffer
    // if(value<0)
    // [54] if(printf_sint::value<0) goto printf_sint::@1 -- vwsm1_lt_0_then_la1 
    lda value+1
    bmi __b1
    // printf_sint::@3
    // if(format_sign_always)
    // [55] if(0==printf_sint::format_sign_always) goto printf_sint::@2 -- 0_eq_vbum1_then_la1 
    lda format_sign_always
    beq __b2
    // printf_sint::@4
    // printf_buffer.sign = '+'
    // [56] *((char *)&printf_buffer) = '+' -- _deref_pbuc1=vbuc2 
    lda #'+'
    sta lib_conio.printf_buffer
    // printf_sint::@2
  __b2:
    // utoa(uvalue, printf_buffer.digits, format_radix)
    // [57] utoa::value#1 = (unsigned int)printf_sint::value
    // [58] utoa::radix#0 = printf_sint::format_radix -- vbuaa=vbum1 
    lda format_radix
    // [59] call utoa
    // [369] phi from printf_sint::@2 to utoa [phi:printf_sint::@2->utoa]
    // [369] phi utoa::value#10 = utoa::value#1 [phi:printf_sint::@2->utoa#0] -- register_copy 
    // [369] phi utoa::radix#2 = utoa::radix#0 [phi:printf_sint::@2->utoa#1] -- register_copy 
    jsr utoa
    // printf_sint::@5
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [60] printf_number_buffer::putc#2 = printf_sint::putc
    // [61] *(&printf_number_buffer::buffer) = memcpy(*(&printf_buffer), struct printf_buffer_number, SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER
  !:
    lda lib_conio.printf_buffer-1,y
    sta printf_number_buffer.buffer-1,y
    dey
    bne !-
    // [62] printf_number_buffer::format_min_length#2 = printf_sint::format_min_length -- vbuxx=vbum1 
    ldx format_min_length
    // [63] printf_number_buffer::format_justify_left#2 = printf_sint::format_justify_left
    // [64] printf_number_buffer::format_zero_padding#2 = printf_sint::format_zero_padding
    // [65] printf_number_buffer::format_upper_case#2 = printf_sint::format_upper_case
    // [66] call printf_number_buffer
  // Print using format
    // [327] phi from printf_sint::@5 to printf_number_buffer [phi:printf_sint::@5->printf_number_buffer]
    // [327] phi printf_number_buffer::format_upper_case#10 = printf_number_buffer::format_upper_case#2 [phi:printf_sint::@5->printf_number_buffer#0] -- register_copy 
    // [327] phi printf_number_buffer::putc#10 = printf_number_buffer::putc#2 [phi:printf_sint::@5->printf_number_buffer#1] -- register_copy 
    // [327] phi printf_number_buffer::format_zero_padding#10 = printf_number_buffer::format_zero_padding#2 [phi:printf_sint::@5->printf_number_buffer#2] -- register_copy 
    // [327] phi printf_number_buffer::format_justify_left#10 = printf_number_buffer::format_justify_left#2 [phi:printf_sint::@5->printf_number_buffer#3] -- register_copy 
    // [327] phi printf_number_buffer::format_min_length#10 = printf_number_buffer::format_min_length#2 [phi:printf_sint::@5->printf_number_buffer#4] -- register_copy 
    jsr printf_number_buffer
    // printf_sint::@return
    // }
    // [67] return 
    rts
    // printf_sint::@1
  __b1:
    // -value
    // [68] printf_sint::$4 = - printf_sint::value -- vwsm1=_neg_vwsm1 
    lda #0
    sec
    sbc printf_sint__4
    sta printf_sint__4
    lda #0
    sbc printf_sint__4+1
    sta printf_sint__4+1
    // value = -value
    // [69] printf_sint::value = printf_sint::$4
  // Negative
    // printf_buffer.sign = '-'
    // [70] *((char *)&printf_buffer) = '-' -- _deref_pbuc1=vbuc2 
    lda #'-'
    sta lib_conio.printf_buffer
    jmp __b2
  .segment Data
    .label value = clrscr.ch
    .label format_min_length = uctoa.started
    .label format_justify_left = printf_number_buffer.format_justify_left
    .label format_sign_always = uctoa.max_digits
    .label format_zero_padding = printf_number_buffer.format_zero_padding
    .label format_upper_case = printf_number_buffer.format_upper_case
    .label format_radix = uctoa.digit
    .label printf_sint__4 = clrscr.ch
}
.segment Code
  // printf_ulong
// Print an unsigned int using a specific format
// void printf_ulong(__zp($2c) void (*putc)(char), __mem() unsigned long uvalue, __mem() char format_min_length, __mem() char format_justify_left, __mem() char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, __mem() char format_radix)
printf_ulong: {
    .label putc = $2c
    // format_sign_always?'+':0
    // [71] if(0!=printf_ulong::format_sign_always) goto printf_ulong::@1 -- 0_neq_vbum1_then_la1 
    lda format_sign_always
    bne __b1
    // [73] phi from printf_ulong to printf_ulong::@2 [phi:printf_ulong->printf_ulong::@2]
    // [73] phi printf_ulong::$2 = 0 [phi:printf_ulong->printf_ulong::@2#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b2
    // [72] phi from printf_ulong to printf_ulong::@1 [phi:printf_ulong->printf_ulong::@1]
    // printf_ulong::@1
  __b1:
    // format_sign_always?'+':0
    // [73] phi from printf_ulong::@1 to printf_ulong::@2 [phi:printf_ulong::@1->printf_ulong::@2]
    // [73] phi printf_ulong::$2 = '+' [phi:printf_ulong::@1->printf_ulong::@2#0] -- vbuaa=vbuc1 
    lda #'+'
    // printf_ulong::@2
  __b2:
    // printf_buffer.sign = format_sign_always?'+':0
    // [74] *((char *)&printf_buffer) = printf_ulong::$2 -- _deref_pbuc1=vbuaa 
    // Handle any sign
    sta lib_conio.printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format_radix)
    // [75] ultoa::value#2 = printf_ulong::uvalue
    // [76] ultoa::radix#1 = printf_ulong::format_radix -- vbuaa=vbum1 
    lda format_radix
    // [77] call ultoa
  // Format number into buffer
    // [400] phi from printf_ulong::@2 to ultoa [phi:printf_ulong::@2->ultoa]
    // [400] phi ultoa::value#10 = ultoa::value#2 [phi:printf_ulong::@2->ultoa#0] -- register_copy 
    // [400] phi ultoa::radix#2 = ultoa::radix#1 [phi:printf_ulong::@2->ultoa#1] -- register_copy 
    jsr ultoa
    // printf_ulong::@3
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [78] printf_number_buffer::putc#1 = printf_ulong::putc -- pprz1=pprz2 
    lda.z putc
    sta.z printf_number_buffer.putc
    lda.z putc+1
    sta.z printf_number_buffer.putc+1
    // [79] *(&printf_number_buffer::buffer) = memcpy(*(&printf_buffer), struct printf_buffer_number, SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER
  !:
    lda lib_conio.printf_buffer-1,y
    sta printf_number_buffer.buffer-1,y
    dey
    bne !-
    // [80] printf_number_buffer::format_min_length#1 = printf_ulong::format_min_length -- vbuxx=vbum1 
    ldx format_min_length
    // [81] printf_number_buffer::format_justify_left#1 = printf_ulong::format_justify_left -- vbum1=vbum2 
    lda format_justify_left
    sta printf_number_buffer.format_justify_left
    // [82] printf_number_buffer::format_zero_padding#1 = printf_ulong::format_zero_padding -- vbum1=vbum2 
    lda format_zero_padding
    sta printf_number_buffer.format_zero_padding
    // [83] printf_number_buffer::format_upper_case#1 = printf_ulong::format_upper_case -- vbum1=vbum2 
    lda format_upper_case
    sta printf_number_buffer.format_upper_case
    // [84] call printf_number_buffer
  // Print using format
    // [327] phi from printf_ulong::@3 to printf_number_buffer [phi:printf_ulong::@3->printf_number_buffer]
    // [327] phi printf_number_buffer::format_upper_case#10 = printf_number_buffer::format_upper_case#1 [phi:printf_ulong::@3->printf_number_buffer#0] -- register_copy 
    // [327] phi printf_number_buffer::putc#10 = printf_number_buffer::putc#1 [phi:printf_ulong::@3->printf_number_buffer#1] -- register_copy 
    // [327] phi printf_number_buffer::format_zero_padding#10 = printf_number_buffer::format_zero_padding#1 [phi:printf_ulong::@3->printf_number_buffer#2] -- register_copy 
    // [327] phi printf_number_buffer::format_justify_left#10 = printf_number_buffer::format_justify_left#1 [phi:printf_ulong::@3->printf_number_buffer#3] -- register_copy 
    // [327] phi printf_number_buffer::format_min_length#10 = printf_number_buffer::format_min_length#1 [phi:printf_ulong::@3->printf_number_buffer#4] -- register_copy 
    jsr printf_number_buffer
    // printf_ulong::@return
    // }
    // [85] return 
    rts
  .segment Data
    .label uvalue = ultoa.value
    .label format_min_length = printf_padding.i
    format_justify_left: .byte 0
    .label format_sign_always = uctoa.max_digits
    format_zero_padding: .byte 0
    format_upper_case: .byte 0
    .label format_radix = uctoa.digit
}
.segment Code
  // printf_slong
// Print a signed long using a specific format
// void printf_slong(__zp($2a) void (*putc)(char), __mem() long value, __mem() char format_min_length, __mem() char format_justify_left, __mem() char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, __mem() char format_radix)
printf_slong: {
    .label putc = $2a
    // printf_buffer.sign = 0
    // [86] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta lib_conio.printf_buffer
    // if(value<0)
    // [87] if(printf_slong::value<0) goto printf_slong::@1 -- vdsm1_lt_0_then_la1 
    lda value+3
    bmi __b1
    // printf_slong::@3
    // if(format_sign_always)
    // [88] if(0==printf_slong::format_sign_always) goto printf_slong::@2 -- 0_eq_vbum1_then_la1 
    lda format_sign_always
    beq __b2
    // printf_slong::@4
    // printf_buffer.sign = '+'
    // [89] *((char *)&printf_buffer) = '+' -- _deref_pbuc1=vbuc2 
    lda #'+'
    sta lib_conio.printf_buffer
    // printf_slong::@2
  __b2:
    // unsigned long uvalue = (unsigned long)value
    // [90] printf_slong::uvalue#0 = (unsigned long)printf_slong::value
  // Format number into buffer
    // ultoa(uvalue, printf_buffer.digits, format_radix)
    // [91] ultoa::value#1 = printf_slong::uvalue#0
    // [92] ultoa::radix#0 = printf_slong::format_radix -- vbuaa=vbum1 
    lda format_radix
    // [93] call ultoa
    // [400] phi from printf_slong::@2 to ultoa [phi:printf_slong::@2->ultoa]
    // [400] phi ultoa::value#10 = ultoa::value#1 [phi:printf_slong::@2->ultoa#0] -- register_copy 
    // [400] phi ultoa::radix#2 = ultoa::radix#0 [phi:printf_slong::@2->ultoa#1] -- register_copy 
    jsr ultoa
    // printf_slong::@5
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [94] printf_number_buffer::putc#0 = printf_slong::putc
    // [95] *(&printf_number_buffer::buffer) = memcpy(*(&printf_buffer), struct printf_buffer_number, SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER
  !:
    lda lib_conio.printf_buffer-1,y
    sta printf_number_buffer.buffer-1,y
    dey
    bne !-
    // [96] printf_number_buffer::format_min_length#0 = printf_slong::format_min_length -- vbuxx=vbum1 
    ldx format_min_length
    // [97] printf_number_buffer::format_justify_left#0 = printf_slong::format_justify_left
    // [98] printf_number_buffer::format_zero_padding#0 = printf_slong::format_zero_padding
    // [99] printf_number_buffer::format_upper_case#0 = printf_slong::format_upper_case
    // [100] call printf_number_buffer
  // Print using format
    // [327] phi from printf_slong::@5 to printf_number_buffer [phi:printf_slong::@5->printf_number_buffer]
    // [327] phi printf_number_buffer::format_upper_case#10 = printf_number_buffer::format_upper_case#0 [phi:printf_slong::@5->printf_number_buffer#0] -- register_copy 
    // [327] phi printf_number_buffer::putc#10 = printf_number_buffer::putc#0 [phi:printf_slong::@5->printf_number_buffer#1] -- register_copy 
    // [327] phi printf_number_buffer::format_zero_padding#10 = printf_number_buffer::format_zero_padding#0 [phi:printf_slong::@5->printf_number_buffer#2] -- register_copy 
    // [327] phi printf_number_buffer::format_justify_left#10 = printf_number_buffer::format_justify_left#0 [phi:printf_slong::@5->printf_number_buffer#3] -- register_copy 
    // [327] phi printf_number_buffer::format_min_length#10 = printf_number_buffer::format_min_length#0 [phi:printf_slong::@5->printf_number_buffer#4] -- register_copy 
    jsr printf_number_buffer
    // printf_slong::@return
    // }
    // [101] return 
    rts
    // printf_slong::@1
  __b1:
    // -value
    // [102] printf_slong::$4 = - printf_slong::value -- vdsm1=_neg_vdsm1 
    sec
    lda printf_slong__4
    eor #$ff
    adc #0
    sta printf_slong__4
    lda printf_slong__4+1
    eor #$ff
    adc #0
    sta printf_slong__4+1
    lda printf_slong__4+2
    eor #$ff
    adc #0
    sta printf_slong__4+2
    lda printf_slong__4+3
    eor #$ff
    adc #0
    sta printf_slong__4+3
    // value = -value
    // [103] printf_slong::value = printf_slong::$4
  // Negative
    // printf_buffer.sign = '-'
    // [104] *((char *)&printf_buffer) = '-' -- _deref_pbuc1=vbuc2 
    lda #'-'
    sta lib_conio.printf_buffer
    jmp __b2
  .segment Data
    .label value = ultoa.value
    .label format_min_length = uctoa.started
    .label format_justify_left = printf_number_buffer.format_justify_left
    .label format_sign_always = uctoa.max_digits
    .label format_zero_padding = printf_number_buffer.format_zero_padding
    .label format_upper_case = printf_number_buffer.format_upper_case
    .label format_radix = uctoa.digit
    .label printf_slong__4 = ultoa.value
    .label uvalue = ultoa.value
}
.segment Code
  // printf_str
/// Print a NUL-terminated string
// void printf_str(__zp($28) void (*putc)(char), __zp($22) const char *s)
printf_str: {
    .label putc = $28
    .label s = $22
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [106] printf_str::c#1 = *printf_str::s -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (s),y
    // [107] printf_str::s = ++ printf_str::s -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [108] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // printf_str::@return
    // }
    // [109] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [110] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbuaa 
    pha
    // [111] callexecute *printf_str::putc  -- call__deref_pprz1 
    jsr icall1
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
    // Outside Flow
  icall1:
    jmp (putc)
}
  // conio_x16_init
/// Set initial screen values.
// void conio_x16_init()
conio_x16_init: {
    // screenlayer1()
    // [114] callexecute screenlayer1  -- call_var_near 
    jsr screenlayer1
    // textcolor(CONIO_TEXTCOLOR_DEFAULT)
    // [115] textcolor::color = WHITE -- vbum1=vbuc1 
    lda #WHITE
    sta lib_conio.textcolor.color
    // [116] callexecute textcolor  -- call_var_near 
    jsr textcolor
    // bgcolor(CONIO_BACKCOLOR_DEFAULT)
    // [117] bgcolor::color = BLUE -- vbum1=vbuc1 
    lda #BLUE
    sta lib_conio.bgcolor.color
    // [118] callexecute bgcolor  -- call_var_near 
    jsr bgcolor
    // cursor(0)
    // [119] cursor::onoff = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_conio.cursor.onoff
    // [120] callexecute cursor  -- call_var_near 
    jsr cursor
    // cbm_k_plot_get()
    // [121] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [122] cbm_k_plot_get::return#2 = cbm_k_plot_get::return#0
    // conio_x16_init::@1
    // [123] conio_x16_init::$4 = cbm_k_plot_get::return#2
    // BYTE1(cbm_k_plot_get())
    // [124] conio_x16_init::$5 = byte1  conio_x16_init::$4 -- vbuaa=_byte1_vwum1 
    lda conio_x16_init__4+1
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [125] *((char *)&__conio) = conio_x16_init::$5 -- _deref_pbuc1=vbuaa 
    sta lib_conio.__conio
    // cbm_k_plot_get()
    // [126] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [127] cbm_k_plot_get::return#3 = cbm_k_plot_get::return#0
    // conio_x16_init::@2
    // [128] conio_x16_init::$6 = cbm_k_plot_get::return#3
    // BYTE0(cbm_k_plot_get())
    // [129] conio_x16_init::$7 = byte0  conio_x16_init::$6 -- vbuaa=_byte0_vwum1 
    lda conio_x16_init__6
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [130] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y) = conio_x16_init::$7 -- _deref_pbuc1=vbuaa 
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y
    // gotoxy(__conio.cursor_x, __conio.cursor_y)
    // [131] gotoxy::x = *((char *)&__conio) -- vbum1=_deref_pbuc1 
    lda lib_conio.__conio
    sta lib_conio.gotoxy.x
    // [132] gotoxy::y = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y) -- vbum1=_deref_pbuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y
    sta lib_conio.gotoxy.y
    // [133] callexecute gotoxy  -- call_var_near 
    jsr gotoxy
    // __conio.scroll[0] = 1
    // [134] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_SCROLL) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_SCROLL
    // __conio.scroll[1] = 1
    // [135] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_SCROLL+1) = 1 -- _deref_pbuc1=vbuc2 
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_SCROLL+1
    // conio_x16_init::@return
    // }
    // [136] return 
    rts
  .segment Data
    .label conio_x16_init__4 = clrscr.ch
    .label conio_x16_init__6 = clrscr.ch
}
.segment Code
  // cpeekcxy
// __mem() char cpeekcxy(__mem() char x, __mem() char y)
cpeekcxy: {
    // gotoxy(x,y)
    // [137] gotoxy::x = cpeekcxy::x -- vbum1=vbum2 
    lda x
    sta lib_conio.gotoxy.x
    // [138] gotoxy::y = cpeekcxy::y
    // [139] callexecute gotoxy  -- call_var_near 
    jsr gotoxy
    // cpeekc()
    // [140] callexecute cpeekc  -- call_var_near 
    jsr cpeekc
    // [141] cpeekcxy::$1 = cpeekc::return -- vbuaa=vbum1 
    lda lib_conio.cpeekc.return
    // return cpeekc();
    // [142] cpeekcxy::return = cpeekcxy::$1 -- vbum1=vbuaa 
    sta return
    // cpeekcxy::@return
    // }
    // [143] return 
    rts
  .segment Data
    .label x = uctoa.started
    .label y = uctoa.digit
    .label return = uctoa.max_digits
}
.segment Code
  // cpeekc
// __mem() char cpeekc()
cpeekc: {
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [144] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(__conio.offset)
    // [145] cpeekc::$0 = byte0  *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) -- vbuaa=_byte0__deref_pwuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET
    // *VERA_ADDRX_L = BYTE0(__conio.offset)
    // [146] *VERA_ADDRX_L = cpeekc::$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(__conio.offset)
    // [147] cpeekc::$1 = byte1  *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) -- vbuaa=_byte1__deref_pwuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET+1
    // *VERA_ADDRX_M = BYTE1(__conio.offset)
    // [148] *VERA_ADDRX_M = cpeekc::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_0
    // [149] cpeekc::$2 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK) -- vbuaa=_deref_pbuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_0
    // [150] *VERA_ADDRX_H = cpeekc::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // return *VERA_DATA0;
    // [151] cpeekc::return = *VERA_DATA0 -- vbum1=_deref_pbuc1 
    lda VERA_DATA0
    sta return
    // cpeekc::@return
    // }
    // [152] return 
    rts
  .segment Data
    .label return = uctoa.max_digits
}
.segment Code
  // screenlayer1
// Set the layer with which the conio will interact.
// void screenlayer1()
screenlayer1: {
    // screenlayer(1, *VERA_L1_MAPBASE, *VERA_L1_CONFIG)
    // [153] screenlayer::mapbase#0 = *VERA_L1_MAPBASE -- vbuxx=_deref_pbuc1 
    ldx VERA_L1_MAPBASE
    // [154] screenlayer::config#0 = *VERA_L1_CONFIG -- vbum1=_deref_pbuc1 
    lda VERA_L1_CONFIG
    sta screenlayer.config
    // [155] call screenlayer
    jsr screenlayer
    // screenlayer1::@return
    // }
    // [156] return 
    rts
}
  // scroll
// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 0, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
// __mem() char scroll(__mem() char onoff)
scroll: {
    // char old = __conio.scroll[__conio.layer]
    // [157] scroll::old#0 = ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_SCROLL)[*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_LAYER)] -- vbuxx=pbuc1_derefidx_(_deref_pbuc2) 
    ldy lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_LAYER
    ldx lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_SCROLL,y
    // __conio.scroll[__conio.layer] = onoff
    // [158] ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_SCROLL)[*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_LAYER)] = scroll::onoff -- pbuc1_derefidx_(_deref_pbuc2)=vbum1 
    lda onoff
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_SCROLL,y
    // return old;
    // [159] scroll::return = scroll::old#0 -- vbum1=vbuxx 
    stx return
    // scroll::@return
    // }
    // [160] return 
    rts
  .segment Data
    .label onoff = uctoa.max_digits
    .label return = uctoa.max_digits
}
.segment Code
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
// __mem() char cursor(__mem() char onoff)
cursor: {
    // char old = __conio.cursor
    // [161] cursor::old#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR) -- vbuxx=_deref_pbuc1 
    // not supported in CX16
    ldx lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR
    // __conio.cursor = onoff
    // [162] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR) = cursor::onoff -- _deref_pbuc1=vbum1 
    lda onoff
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR
    // return old;
    // [163] cursor::return = cursor::old#0 -- vbum1=vbuxx 
    stx return
    // cursor::@return
    // }
    // [164] return 
    rts
  .segment Data
    .label onoff = uctoa.max_digits
    .label return = uctoa.max_digits
}
.segment Code
  // kbhit
// Returns a value if a key is pressed.
// __mem() char kbhit()
kbhit: {
    // kbhit::cbm_k_clrchn1
    // asm
    // asm { jsrCBM_CLRCHN  }
    jsr CBM_CLRCHN
    // [167] phi from kbhit::cbm_k_clrchn1 to kbhit::@1 [phi:kbhit::cbm_k_clrchn1->kbhit::@1]
    // kbhit::@1
    // cbm_k_getin()
    // [168] call cbm_k_getin
    jsr cbm_k_getin
    // [169] cbm_k_getin::return#0 = cbm_k_getin::return#2
    // kbhit::@2
    // [170] kbhit::$1 = cbm_k_getin::return#0
    // return cbm_k_getin();
    // [171] kbhit::return = kbhit::$1 -- vbum1=vbuaa 
    sta return
    // kbhit::@return
    // }
    // [172] return 
    rts
  .segment Data
    .label return = uctoa.max_digits
}
.segment Code
  // bordercolor
// Set the color for the border.
// __mem() char bordercolor(__mem() char color)
bordercolor: {
    // __conio.bordercolor = *VERA_DC_BORDER
    // [173] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_BORDERCOLOR) = *VERA_DC_BORDER -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DC_BORDER
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_BORDERCOLOR
    // return __conio.bordercolor = *VERA_DC_BORDER;
    // [174] bordercolor::return = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_BORDERCOLOR) -- vbum1=_deref_pbuc1 
    sta return
    // bordercolor::@return
    // }
    // [175] return 
    rts
  .segment Data
    .label color = uctoa.max_digits
    .label return = uctoa.max_digits
}
.segment Code
  // bgcolor
// Set the back color for text output.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// __mem() char bgcolor(__mem() char color)
bgcolor: {
    // __conio.color & 0x0F
    // [176] bgcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR) & $f -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$f
    and lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR
    sta bgcolor__0
    // color << 4
    // [177] bgcolor::$1 = bgcolor::color << 4 -- vbuaa=vbum1_rol_4 
    lda color
    asl
    asl
    asl
    asl
    // __conio.color & 0x0F | color << 4
    // [178] bgcolor::$2 = bgcolor::$0 | bgcolor::$1 -- vbuaa=vbum1_bor_vbuaa 
    ora bgcolor__0
    // __conio.color = __conio.color & 0x0F | color << 4
    // [179] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR) = bgcolor::$2 -- _deref_pbuc1=vbuaa 
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR
    // return __conio.color = __conio.color & 0x0F | color << 4;
    // [180] bgcolor::return = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR) -- vbum1=_deref_pbuc1 
    sta return
    // bgcolor::@return
    // }
    // [181] return 
    rts
  .segment Data
    .label color = uctoa.max_digits
    .label return = uctoa.max_digits
    .label bgcolor__0 = uctoa.digit
}
.segment Code
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// __mem() char textcolor(__mem() char color)
textcolor: {
    // __conio.color & 0xF0
    // [182] textcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR) & $f0 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR
    // __conio.color & 0xF0 | color
    // [183] textcolor::$1 = textcolor::$0 | textcolor::color -- vbuaa=vbuaa_bor_vbum1 
    ora color
    // __conio.color = __conio.color & 0xF0 | color
    // [184] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR) = textcolor::$1 -- _deref_pbuc1=vbuaa 
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR
    // return __conio.color = __conio.color & 0xF0 | color;
    // [185] textcolor::return = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR) -- vbum1=_deref_pbuc1 
    sta return
    // textcolor::@return
    // }
    // [186] return 
    rts
  .segment Data
    .label color = uctoa.max_digits
    .label return = uctoa.max_digits
}
.segment Code
  // cputsxy
// Move cursor and output a NUL-terminated string
// Same as "gotoxy (x, y); puts (s);"
// void cputsxy(__mem() char x, __mem() char y, __zp($28) const char *s)
cputsxy: {
    .label s = $28
    // gotoxy(x, y)
    // [187] gotoxy::x = cputsxy::x -- vbum1=vbum2 
    lda x
    sta lib_conio.gotoxy.x
    // [188] gotoxy::y = cputsxy::y
    // [189] callexecute gotoxy  -- call_var_near 
    jsr gotoxy
    // cputs(s)
    // [190] cputs::s = cputsxy::s -- pbuz1=pbuz2 
    lda.z s
    sta.z lib_conio.cputs.s
    lda.z s+1
    sta.z lib_conio.cputs.s+1
    // [191] callexecute cputs  -- call_var_near 
    jsr cputs
    // cputsxy::@return
    // }
    // [192] return 
    rts
  .segment Data
    .label x = uctoa.started
    .label y = uctoa.digit
}
.segment Code
  // cputs
// Output a NUL-terminated string at the current cursor position
// void cputs(__zp($2a) const char *s)
cputs: {
    .label s = $2a
    // cputs::@1
  __b1:
    // while(c=*s++)
    // [194] cputs::c#1 = *cputs::s -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (s),y
    // [195] cputs::s = ++ cputs::s -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [196] if(0!=cputs::c#1) goto cputs::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // cputs::@return
    // }
    // [197] return 
    rts
    // cputs::@2
  __b2:
    // cputc(c)
    // [198] stackpush(char) = cputs::c#1 -- _stackpushbyte_=vbuaa 
    pha
    // [199] callexecute cputc  -- call_stack_near 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
}
  // cputcxy
// Move cursor and output one character
// Same as "gotoxy (x, y); cputc (c);"
// void cputcxy(__mem() char x, __mem() char y, __mem() char c)
cputcxy: {
    // gotoxy(x, y)
    // [201] gotoxy::x = cputcxy::x -- vbum1=vbum2 
    lda x
    sta lib_conio.gotoxy.x
    // [202] gotoxy::y = cputcxy::y
    // [203] callexecute gotoxy  -- call_var_near 
    jsr gotoxy
    // cputc(c)
    // [204] stackpush(char) = cputcxy::c -- _stackpushbyte_=vbum1 
    lda c
    pha
    // [205] callexecute cputc  -- call_stack_near 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // cputcxy::@return
    // }
    // [207] return 
    rts
  .segment Data
    .label x = uctoa.started
    .label y = uctoa.digit
    .label c = printf_number_buffer.format_justify_left
}
.segment Code
  // cputln
// Print a newline
// void cputln()
cputln: {
    // __conio.cursor_x = 0
    // [208] *((char *)&__conio) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta lib_conio.__conio
    // __conio.cursor_y++;
    // [209] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y) = ++ *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y
    // __conio.offset = __conio.offsets[__conio.cursor_y]
    // [210] cputln::$3 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y
    asl
    // [211] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) = ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS)[cputln::$3] -- _deref_pwuc1=pwuc2_derefidx_vbuaa 
    tay
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS,y
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS+1,y
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET+1
    // if(__conio.scroll[__conio.layer])
    // [212] if(0==((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_SCROLL)[*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_LAYER)]) goto cputln::@return -- 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_LAYER
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_SCROLL,y
    cmp #0
    beq __breturn
    // [213] phi from cputln to cputln::@1 [phi:cputln->cputln::@1]
    // cputln::@1
    // cscroll()
    // [214] call cscroll
    jsr cscroll
    // cputln::@return
  __breturn:
    // }
    // [215] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__register(X) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    // [216] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbuxx=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    tax
    // if(c=='\n')
    // [217] if(cputc::c#0==' ') goto cputc::@1 -- vbuxx_eq_vbuc1_then_la1 
    cpx #'\n'
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [218] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(__conio.offset)
    // [219] cputc::$1 = byte0  *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) -- vbuaa=_byte0__deref_pwuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET
    // *VERA_ADDRX_L = BYTE0(__conio.offset)
    // [220] *VERA_ADDRX_L = cputc::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(__conio.offset)
    // [221] cputc::$2 = byte1  *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) -- vbuaa=_byte1__deref_pwuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET+1
    // *VERA_ADDRX_M = BYTE1(__conio.offset)
    // [222] *VERA_ADDRX_M = cputc::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [223] cputc::$3 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [224] *VERA_ADDRX_H = cputc::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [225] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [226] *VERA_DATA0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR) -- _deref_pbuc1=_deref_pbuc2 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR
    sta VERA_DATA0
    // if(!__conio.hscroll[__conio.layer])
    // [227] if(0==((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_HSCROLL)[*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_LAYER)]) goto cputc::@5 -- 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_LAYER
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_HSCROLL,y
    cmp #0
    beq __b5
    // cputc::@3
    // if(__conio.cursor_x >= __conio.mapwidth)
    // [228] if(*((char *)&__conio)>=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPWIDTH)) goto cputc::@6 -- _deref_pbuc1_ge__deref_pbuc2_then_la1 
    lda lib_conio.__conio
    cmp lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPWIDTH
    bcs __b6
    // cputc::@4
    // __conio.cursor_x++;
    // [229] *((char *)&__conio) = ++ *((char *)&__conio) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc lib_conio.__conio
    // __conio.offset++;
    // [230] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) = ++ *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET
    bne !+
    inc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET+1
  !:
    // [231] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) = ++ *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET
    bne !+
    inc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET+1
  !:
    // cputc::@return
    // }
    // [232] return 
    rts
    // [233] phi from cputc::@3 to cputc::@6 [phi:cputc::@3->cputc::@6]
    // cputc::@6
  __b6:
    // cputln()
    // [234] callexecute cputln  -- call_var_near 
    jsr cputln
    rts
    // cputc::@5
  __b5:
    // if(__conio.cursor_x >= __conio.width)
    // [235] if(*((char *)&__conio)>=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH)) goto cputc::@7 -- _deref_pbuc1_ge__deref_pbuc2_then_la1 
    lda lib_conio.__conio
    cmp lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH
    bcs __b7
    // cputc::@8
    // __conio.cursor_x++;
    // [236] *((char *)&__conio) = ++ *((char *)&__conio) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc lib_conio.__conio
    // __conio.offset++;
    // [237] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) = ++ *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET
    bne !+
    inc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET+1
  !:
    // [238] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) = ++ *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET
    bne !+
    inc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET+1
  !:
    rts
    // [239] phi from cputc::@5 to cputc::@7 [phi:cputc::@5->cputc::@7]
    // cputc::@7
  __b7:
    // cputln()
    // [240] callexecute cputln  -- call_var_near 
    jsr cputln
    rts
    // [241] phi from cputc to cputc::@1 [phi:cputc->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [242] callexecute cputln  -- call_var_near 
    jsr cputln
    rts
}
  // screensizey
// Return the current screen size y height.
// __mem() char screensizey()
screensizey: {
    // return __conio.height;
    // [243] screensizey::return = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT) -- vbum1=_deref_pbuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT
    sta return
    // screensizey::@return
    // }
    // [244] return 
    rts
  .segment Data
    .label return = uctoa.max_digits
}
.segment Code
  // screensizex
// Return the current screen size x width.
// __mem() char screensizex()
screensizex: {
    // return __conio.width;
    // [245] screensizex::return = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH) -- vbum1=_deref_pbuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH
    sta return
    // screensizex::@return
    // }
    // [246] return 
    rts
  .segment Data
    .label return = uctoa.max_digits
}
.segment Code
  // screensize
// Return the current screen size.
// void screensize(__zp($28) char *x, __zp($2c) char *y)
screensize: {
    .label x = $28
    .label y = $2c
    // char hscale = (*VERA_DC_HSCALE) >> 7
    // [247] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuaa=_deref_pbuc1_ror_7 
    // VERA returns in VERA_DC_HSCALE the value of 128 when 80 columns is used in text mode,
    // and the value of 64 when 40 columns is used in text mode.
    // Basically, 40 columns mode in the VERA is a double scan mode.
    // Same for the VERA_DC_VSCALE mode, but then the subdivision is 60 or 30 rows.
    // I still need to test the other modes, but this will suffice for now for the pure text modes.
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    // 40 << hscale
    // [248] screensize::$1 = $28 << screensize::hscale#0 -- vbuaa=vbuc1_rol_vbuaa 
    tay
    lda #$28
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    // (40 << hscale)-1
    // [249] screensize::$2 = screensize::$1 - 1 -- vbuaa=vbuaa_minus_1 
    sec
    sbc #1
    // *x = (40 << hscale)-1
    // [250] *screensize::x = screensize::$2 -- _deref_pbuz1=vbuaa 
    ldy #0
    sta (x),y
    // char vscale = (*VERA_DC_VSCALE) >> 7
    // [251] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuaa=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    // 30 << vscale
    // [252] screensize::$4 = $1e << screensize::vscale#0 -- vbuaa=vbuc1_rol_vbuaa 
    tay
    lda #$1e
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    // (30 << vscale)-1
    // [253] screensize::$5 = screensize::$4 - 1 -- vbuaa=vbuaa_minus_1 
    sec
    sbc #1
    // *y = (30 << vscale)-1
    // [254] *screensize::y = screensize::$5 -- _deref_pbuz1=vbuaa 
    ldy #0
    sta (y),y
    // screensize::@return
    // }
    // [255] return 
    rts
}
  // wherey
// Return the y position of the cursor
// __mem() char wherey()
wherey: {
    // return __conio.cursor_y;
    // [256] wherey::return = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y) -- vbum1=_deref_pbuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y
    sta return
    // wherey::@return
    // }
    // [257] return 
    rts
  .segment Data
    .label return = uctoa.max_digits
}
.segment Code
  // wherex
// Return the x position of the cursor
// __mem() char wherex()
wherex: {
    // return __conio.cursor_x;
    // [258] wherex::return = *((char *)&__conio) -- vbum1=_deref_pbuc1 
    lda lib_conio.__conio
    sta return
    // wherex::@return
    // }
    // [259] return 
    rts
  .segment Data
    .label return = uctoa.max_digits
}
.segment Code
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__mem() char x, __mem() char y)
gotoxy: {
    // (x>=__conio.width)?__conio.width:x
    // [260] if(gotoxy::x>=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH)) goto gotoxy::@1 -- vbum1_ge__deref_pbuc1_then_la1 
    lda x
    cmp lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH
    bcs __b1
    // gotoxy::@2
    // [261] gotoxy::$1 = gotoxy::x -- vbuaa=vbum1 
    // [262] phi from gotoxy::@1 gotoxy::@2 to gotoxy::@3 [phi:gotoxy::@1/gotoxy::@2->gotoxy::@3]
    // [262] phi gotoxy::$3 = gotoxy::$2 [phi:gotoxy::@1/gotoxy::@2->gotoxy::@3#0] -- register_copy 
    // gotoxy::@3
  __b3:
    // __conio.cursor_x = (x>=__conio.width)?__conio.width:x
    // [263] *((char *)&__conio) = gotoxy::$3 -- _deref_pbuc1=vbuaa 
    sta lib_conio.__conio
    // (y>=__conio.height)?__conio.height:y
    // [264] if(gotoxy::y>=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT)) goto gotoxy::@4 -- vbum1_ge__deref_pbuc1_then_la1 
    lda y
    cmp lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT
    bcs __b4
    // gotoxy::@5
    // [265] gotoxy::$5 = gotoxy::y -- vbuaa=vbum1 
    // [266] phi from gotoxy::@4 gotoxy::@5 to gotoxy::@6 [phi:gotoxy::@4/gotoxy::@5->gotoxy::@6]
    // [266] phi gotoxy::$7 = gotoxy::$6 [phi:gotoxy::@4/gotoxy::@5->gotoxy::@6#0] -- register_copy 
    // gotoxy::@6
  __b6:
    // __conio.cursor_y = (y>=__conio.height)?__conio.height:y
    // [267] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y) = gotoxy::$7 -- _deref_pbuc1=vbuaa 
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y
    // __conio.cursor_x << 1
    // [268] gotoxy::$8 = *((char *)&__conio) << 1 -- vbuxx=_deref_pbuc1_rol_1 
    lda lib_conio.__conio
    asl
    tax
    // __conio.offsets[y] + __conio.cursor_x << 1
    // [269] gotoxy::$10 = gotoxy::y << 1 -- vbuaa=vbum1_rol_1 
    lda y
    asl
    // [270] gotoxy::$9 = ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS)[gotoxy::$10] + gotoxy::$8 -- vwum1=pwuc1_derefidx_vbuaa_plus_vbuxx 
    tay
    txa
    clc
    adc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS,y
    sta gotoxy__9
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS+1,y
    adc #0
    sta gotoxy__9+1
    // __conio.offset = __conio.offsets[y] + __conio.cursor_x << 1
    // [271] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) = gotoxy::$9 -- _deref_pwuc1=vwum1 
    lda gotoxy__9
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET
    lda gotoxy__9+1
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET+1
    // gotoxy::@return
    // }
    // [272] return 
    rts
    // gotoxy::@4
  __b4:
    // (y>=__conio.height)?__conio.height:y
    // [273] gotoxy::$6 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT) -- vbuaa=_deref_pbuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT
    jmp __b6
    // gotoxy::@1
  __b1:
    // (x>=__conio.width)?__conio.width:x
    // [274] gotoxy::$2 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH) -- vbuaa=_deref_pbuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH
    jmp __b3
  .segment Data
    .label x = uctoa.max_digits
    .label y = uctoa.digit
    .label gotoxy__9 = clrscr.ch
}
.segment Code
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
// void clrscr()
clrscr: {
    // unsigned int line_text = __conio.mapbase_offset
    // [275] clrscr::line_text#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET) -- vwum1=_deref_pwuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET
    sta line_text
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET+1
    sta line_text+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [276] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // __conio.mapbase_bank | VERA_INC_1
    // [277] clrscr::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [278] *VERA_ADDRX_H = clrscr::$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // unsigned char l = __conio.mapheight
    // [279] clrscr::l#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPHEIGHT) -- vbuxx=_deref_pbuc1 
    ldx lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPHEIGHT
    // [280] phi from clrscr clrscr::@3 to clrscr::@1 [phi:clrscr/clrscr::@3->clrscr::@1]
    // [280] phi clrscr::l#4 = clrscr::l#0 [phi:clrscr/clrscr::@3->clrscr::@1#0] -- register_copy 
    // [280] phi clrscr::ch#0 = clrscr::line_text#0 [phi:clrscr/clrscr::@3->clrscr::@1#1] -- register_copy 
    // clrscr::@1
  __b1:
    // BYTE0(ch)
    // [281] clrscr::$1 = byte0  clrscr::ch#0 -- vbuaa=_byte0_vwum1 
    lda ch
    // *VERA_ADDRX_L = BYTE0(ch)
    // [282] *VERA_ADDRX_L = clrscr::$1 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(ch)
    // [283] clrscr::$2 = byte1  clrscr::ch#0 -- vbuaa=_byte1_vwum1 
    lda ch+1
    // *VERA_ADDRX_M = BYTE1(ch)
    // [284] *VERA_ADDRX_M = clrscr::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // unsigned char c = __conio.mapwidth+1
    // [285] clrscr::c#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPWIDTH) + 1 -- vbuyy=_deref_pbuc1_plus_1 
    ldy lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPWIDTH
    iny
    // [286] phi from clrscr::@1 clrscr::@2 to clrscr::@2 [phi:clrscr::@1/clrscr::@2->clrscr::@2]
    // [286] phi clrscr::c#2 = clrscr::c#0 [phi:clrscr::@1/clrscr::@2->clrscr::@2#0] -- register_copy 
    // clrscr::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [287] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [288] *VERA_DATA0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR) -- _deref_pbuc1=_deref_pbuc2 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR
    sta VERA_DATA0
    // c--;
    // [289] clrscr::c#1 = -- clrscr::c#2 -- vbuyy=_dec_vbuyy 
    dey
    // while(c)
    // [290] if(0!=clrscr::c#1) goto clrscr::@2 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne __b2
    // clrscr::@3
    // line_text += __conio.rowskip
    // [291] clrscr::line_text#1 = clrscr::ch#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_ROWSKIP) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda line_text
    adc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_ROWSKIP
    sta line_text
    lda line_text+1
    adc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_ROWSKIP+1
    sta line_text+1
    // l--;
    // [292] clrscr::l#1 = -- clrscr::l#4 -- vbuxx=_dec_vbuxx 
    dex
    // while(l)
    // [293] if(0!=clrscr::l#1) goto clrscr::@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b1
    // clrscr::@4
    // __conio.cursor_x = 0
    // [294] *((char *)&__conio) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta lib_conio.__conio
    // __conio.cursor_y = 0
    // [295] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y) = 0 -- _deref_pbuc1=vbuc2 
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y
    // __conio.offset = __conio.mapbase_offset
    // [296] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET) = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET) -- _deref_pwuc1=_deref_pwuc2 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET+1
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSET+1
    // clrscr::@return
    // }
    // [297] return 
    rts
  .segment Data
    .label line_text = ch
    ch: .word 0
}
.segment Code
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void uctoa(__register(X) char value, __zp($26) char *buffer, __register(A) char radix)
uctoa: {
    .label buffer = $26
    .label digit_values = $24
    // if(radix==DECIMAL)
    // [299] if(uctoa::radix#2==DECIMAL) goto uctoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #DECIMAL
    beq __b2
    // uctoa::@2
    // if(radix==HEXADECIMAL)
    // [300] if(uctoa::radix#2==HEXADECIMAL) goto uctoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #HEXADECIMAL
    beq __b3
    // uctoa::@3
    // if(radix==OCTAL)
    // [301] if(uctoa::radix#2==OCTAL) goto uctoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #OCTAL
    beq __b4
    // uctoa::@4
    // if(radix==BINARY)
    // [302] if(uctoa::radix#2==BINARY) goto uctoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #BINARY
    beq __b5
    // uctoa::@5
    // *buffer++ = 'e'
    // [303] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS) = 'e' -- _deref_pbuc1=vbuc2 
    // Unknown radix
    lda #'e'
    sta lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    // [304] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1) = 'r' -- _deref_pbuc1=vbuc2 
    lda #'r'
    sta lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    // [305] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2) = 'r' -- _deref_pbuc1=vbuc2 
    sta lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    // [306] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // uctoa::@return
    // }
    // [307] return 
    rts
    // [308] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
  __b2:
    // [308] phi uctoa::digit_values#8 = RADIX_DECIMAL_VALUES_CHAR [phi:uctoa->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values+1
    // [308] phi uctoa::max_digits#7 = 3 [phi:uctoa->uctoa::@1#1] -- vbum1=vbuc1 
    lda #3
    sta max_digits
    jmp __b1
    // [308] phi from uctoa::@2 to uctoa::@1 [phi:uctoa::@2->uctoa::@1]
  __b3:
    // [308] phi uctoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES_CHAR [phi:uctoa::@2->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values+1
    // [308] phi uctoa::max_digits#7 = 2 [phi:uctoa::@2->uctoa::@1#1] -- vbum1=vbuc1 
    lda #2
    sta max_digits
    jmp __b1
    // [308] phi from uctoa::@3 to uctoa::@1 [phi:uctoa::@3->uctoa::@1]
  __b4:
    // [308] phi uctoa::digit_values#8 = RADIX_OCTAL_VALUES_CHAR [phi:uctoa::@3->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values+1
    // [308] phi uctoa::max_digits#7 = 3 [phi:uctoa::@3->uctoa::@1#1] -- vbum1=vbuc1 
    lda #3
    sta max_digits
    jmp __b1
    // [308] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
  __b5:
    // [308] phi uctoa::digit_values#8 = RADIX_BINARY_VALUES_CHAR [phi:uctoa::@4->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_BINARY_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES_CHAR
    sta.z digit_values+1
    // [308] phi uctoa::max_digits#7 = 8 [phi:uctoa::@4->uctoa::@1#1] -- vbum1=vbuc1 
    lda #8
    sta max_digits
    // uctoa::@1
  __b1:
    // [309] phi from uctoa::@1 to uctoa::@6 [phi:uctoa::@1->uctoa::@6]
    // [309] phi uctoa::buffer#10 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:uctoa::@1->uctoa::@6#0] -- pbuz1=pbuc1 
    lda #<lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [309] phi uctoa::started#2 = 0 [phi:uctoa::@1->uctoa::@6#1] -- vbum1=vbuc1 
    lda #0
    sta started
    // [309] phi uctoa::value#3 = uctoa::value#10 [phi:uctoa::@1->uctoa::@6#2] -- register_copy 
    // [309] phi uctoa::digit#2 = 0 [phi:uctoa::@1->uctoa::@6#3] -- vbum1=vbuc1 
    sta digit
    // uctoa::@6
  __b6:
    // max_digits-1
    // [310] uctoa::$4 = uctoa::max_digits#7 - 1 -- vbuaa=vbum1_minus_1 
    lda max_digits
    sec
    sbc #1
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [311] if(uctoa::digit#2<uctoa::$4) goto uctoa::@7 -- vbum1_lt_vbuaa_then_la1 
    cmp digit
    beq !+
    bcs __b7
  !:
    // uctoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [312] *uctoa::buffer#10 = DIGITS[uctoa::value#3] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [313] uctoa::buffer#3 = ++ uctoa::buffer#10 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [314] *uctoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    rts
    // uctoa::@7
  __b7:
    // unsigned char digit_value = digit_values[digit]
    // [315] uctoa::digit_value#0 = uctoa::digit_values#8[uctoa::digit#2] -- vbuyy=pbuz1_derefidx_vbum2 
    ldy digit
    lda (digit_values),y
    tay
    // if (started || value >= digit_value)
    // [316] if(0!=uctoa::started#2) goto uctoa::@10 -- 0_neq_vbum1_then_la1 
    lda started
    bne __b10
    // uctoa::@12
    // [317] if(uctoa::value#3>=uctoa::digit_value#0) goto uctoa::@10 -- vbuxx_ge_vbuyy_then_la1 
    sty.z $ff
    cpx.z $ff
    bcs __b10
    // [318] phi from uctoa::@12 to uctoa::@9 [phi:uctoa::@12->uctoa::@9]
    // [318] phi uctoa::buffer#15 = uctoa::buffer#10 [phi:uctoa::@12->uctoa::@9#0] -- register_copy 
    // [318] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@12->uctoa::@9#1] -- register_copy 
    // [318] phi uctoa::value#7 = uctoa::value#3 [phi:uctoa::@12->uctoa::@9#2] -- register_copy 
    // uctoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [319] uctoa::digit#1 = ++ uctoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [309] phi from uctoa::@9 to uctoa::@6 [phi:uctoa::@9->uctoa::@6]
    // [309] phi uctoa::buffer#10 = uctoa::buffer#15 [phi:uctoa::@9->uctoa::@6#0] -- register_copy 
    // [309] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@9->uctoa::@6#1] -- register_copy 
    // [309] phi uctoa::value#3 = uctoa::value#7 [phi:uctoa::@9->uctoa::@6#2] -- register_copy 
    // [309] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@9->uctoa::@6#3] -- register_copy 
    jmp __b6
    // uctoa::@10
  __b10:
    // uctoa_append(buffer++, value, digit_value)
    // [320] uctoa_append::buffer#0 = uctoa::buffer#10 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z uctoa_append.buffer
    lda.z buffer+1
    sta.z uctoa_append.buffer+1
    // [321] uctoa_append::value#0 = uctoa::value#3
    // [322] uctoa_append::sub#0 = uctoa::digit_value#0 -- vbum1=vbuyy 
    sty uctoa_append.sub
    // [323] call uctoa_append
    // [488] phi from uctoa::@10 to uctoa_append [phi:uctoa::@10->uctoa_append]
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // [324] uctoa_append::return#0 = uctoa_append::value#2
    // uctoa::@11
    // value = uctoa_append(buffer++, value, digit_value)
    // [325] uctoa::value#0 = uctoa_append::return#0
    // value = uctoa_append(buffer++, value, digit_value);
    // [326] uctoa::buffer#4 = ++ uctoa::buffer#10 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [318] phi from uctoa::@11 to uctoa::@9 [phi:uctoa::@11->uctoa::@9]
    // [318] phi uctoa::buffer#15 = uctoa::buffer#4 [phi:uctoa::@11->uctoa::@9#0] -- register_copy 
    // [318] phi uctoa::started#4 = 1 [phi:uctoa::@11->uctoa::@9#1] -- vbum1=vbuc1 
    lda #1
    sta started
    // [318] phi uctoa::value#7 = uctoa::value#0 [phi:uctoa::@11->uctoa::@9#2] -- register_copy 
    jmp __b9
  .segment Data
    digit: .byte 0
    started: .byte 0
    max_digits: .byte 0
}
.segment Code
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(__zp($2a) void (*putc)(char), __mem() struct printf_buffer_number buffer, __register(X) char format_min_length, __mem() char format_justify_left, char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, char format_radix)
printf_number_buffer: {
    .label putc = $2a
    // if(format_min_length)
    // [328] if(0==printf_number_buffer::format_min_length#10) goto printf_number_buffer::@1 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq __b6
    // [329] phi from printf_number_buffer to printf_number_buffer::@6 [phi:printf_number_buffer->printf_number_buffer::@6]
    // printf_number_buffer::@6
    // strlen(buffer.digits)
    // [330] call strlen
    // [495] phi from printf_number_buffer::@6 to strlen [phi:printf_number_buffer::@6->strlen]
    jsr strlen
    // strlen(buffer.digits)
    // [331] strlen::return#2 = strlen::len#2
    // printf_number_buffer::@14
    // [332] printf_number_buffer::$19 = strlen::return#2
    // signed char len = (signed char)strlen(buffer.digits)
    // [333] printf_number_buffer::len#0 = (signed char)printf_number_buffer::$19 -- vbsyy=_sbyte_vwum1 
    // There is a minimum length - work out the padding
    ldy printf_number_buffer__19
    // if(buffer.sign)
    // [334] if(0==*((char *)&printf_number_buffer::buffer)) goto printf_number_buffer::@13 -- 0_eq__deref_pbuc1_then_la1 
    lda buffer
    beq __b13
    // printf_number_buffer::@7
    // len++;
    // [335] printf_number_buffer::len#1 = ++ printf_number_buffer::len#0 -- vbsyy=_inc_vbsyy 
    iny
    // [336] phi from printf_number_buffer::@14 printf_number_buffer::@7 to printf_number_buffer::@13 [phi:printf_number_buffer::@14/printf_number_buffer::@7->printf_number_buffer::@13]
    // [336] phi printf_number_buffer::len#2 = printf_number_buffer::len#0 [phi:printf_number_buffer::@14/printf_number_buffer::@7->printf_number_buffer::@13#0] -- register_copy 
    // printf_number_buffer::@13
  __b13:
    // padding = (signed char)format_min_length - len
    // [337] printf_number_buffer::padding#1 = (signed char)printf_number_buffer::format_min_length#10 - printf_number_buffer::len#2 -- vbsm1=vbsxx_minus_vbsyy 
    txa
    sty.z $ff
    sec
    sbc.z $ff
    sta padding
    // if(padding<0)
    // [338] if(printf_number_buffer::padding#1>=0) goto printf_number_buffer::@20 -- vbsm1_ge_0_then_la1 
    cmp #0
    bpl __b1
    // [340] phi from printf_number_buffer printf_number_buffer::@13 to printf_number_buffer::@1 [phi:printf_number_buffer/printf_number_buffer::@13->printf_number_buffer::@1]
  __b6:
    // [340] phi printf_number_buffer::padding#10 = 0 [phi:printf_number_buffer/printf_number_buffer::@13->printf_number_buffer::@1#0] -- vbsm1=vbsc1 
    lda #0
    sta padding
    // [339] phi from printf_number_buffer::@13 to printf_number_buffer::@20 [phi:printf_number_buffer::@13->printf_number_buffer::@20]
    // printf_number_buffer::@20
    // [340] phi from printf_number_buffer::@20 to printf_number_buffer::@1 [phi:printf_number_buffer::@20->printf_number_buffer::@1]
    // [340] phi printf_number_buffer::padding#10 = printf_number_buffer::padding#1 [phi:printf_number_buffer::@20->printf_number_buffer::@1#0] -- register_copy 
    // printf_number_buffer::@1
  __b1:
    // if(!format_justify_left && !format_zero_padding && padding)
    // [341] if(0!=printf_number_buffer::format_justify_left#10) goto printf_number_buffer::@2 -- 0_neq_vbum1_then_la1 
    lda format_justify_left
    bne __b2
    // printf_number_buffer::@16
    // [342] if(0!=printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@2 -- 0_neq_vbum1_then_la1 
    lda format_zero_padding
    bne __b2
    // printf_number_buffer::@15
    // [343] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@8 -- 0_neq_vbsm1_then_la1 
    lda padding
    cmp #0
    bne __b8
    jmp __b2
    // printf_number_buffer::@8
  __b8:
    // printf_padding(putc, ' ',(char)padding)
    // [344] printf_padding::putc#0 = printf_number_buffer::putc#10 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [345] printf_padding::length#0 = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [346] call printf_padding
    // [501] phi from printf_number_buffer::@8 to printf_padding [phi:printf_number_buffer::@8->printf_padding]
    // [501] phi printf_padding::putc#5 = printf_padding::putc#0 [phi:printf_number_buffer::@8->printf_padding#0] -- register_copy 
    // [501] phi printf_padding::pad#5 = ' ' [phi:printf_number_buffer::@8->printf_padding#1] -- vbum1=vbuc1 
    lda #' '
    sta printf_padding.pad
    // [501] phi printf_padding::length#4 = printf_padding::length#0 [phi:printf_number_buffer::@8->printf_padding#2] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@2
  __b2:
    // if(buffer.sign)
    // [347] if(0==*((char *)&printf_number_buffer::buffer)) goto printf_number_buffer::@3 -- 0_eq__deref_pbuc1_then_la1 
    lda buffer
    beq __b3
    // printf_number_buffer::@9
    // putc(buffer.sign)
    // [348] stackpush(char) = *((char *)&printf_number_buffer::buffer) -- _stackpushbyte_=_deref_pbuc1 
    pha
    // [349] callexecute *printf_number_buffer::putc#10  -- call__deref_pprz1 
    jsr icall2
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_number_buffer::@3
  __b3:
    // if(format_zero_padding && padding)
    // [351] if(0==printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@4 -- 0_eq_vbum1_then_la1 
    lda format_zero_padding
    beq __b4
    // printf_number_buffer::@17
    // [352] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@10 -- 0_neq_vbsm1_then_la1 
    lda padding
    cmp #0
    bne __b10
    jmp __b4
    // printf_number_buffer::@10
  __b10:
    // printf_padding(putc, '0',(char)padding)
    // [353] printf_padding::putc#1 = printf_number_buffer::putc#10 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [354] printf_padding::length#1 = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [355] call printf_padding
    // [501] phi from printf_number_buffer::@10 to printf_padding [phi:printf_number_buffer::@10->printf_padding]
    // [501] phi printf_padding::putc#5 = printf_padding::putc#1 [phi:printf_number_buffer::@10->printf_padding#0] -- register_copy 
    // [501] phi printf_padding::pad#5 = '0' [phi:printf_number_buffer::@10->printf_padding#1] -- vbum1=vbuc1 
    lda #'0'
    sta printf_padding.pad
    // [501] phi printf_padding::length#4 = printf_padding::length#1 [phi:printf_number_buffer::@10->printf_padding#2] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@4
  __b4:
    // if(format_upper_case)
    // [356] if(0==printf_number_buffer::format_upper_case#10) goto printf_number_buffer::@5 -- 0_eq_vbum1_then_la1 
    lda format_upper_case
    beq __b5
    // [357] phi from printf_number_buffer::@4 to printf_number_buffer::@11 [phi:printf_number_buffer::@4->printf_number_buffer::@11]
    // printf_number_buffer::@11
    // strupr(buffer.digits)
    // [358] call strupr
    // [509] phi from printf_number_buffer::@11 to strupr [phi:printf_number_buffer::@11->strupr]
    jsr strupr
    // printf_number_buffer::@5
  __b5:
    // printf_str(putc, buffer.digits)
    // [359] printf_str::putc = printf_number_buffer::putc#10 -- pprz1=pprz2 
    lda.z putc
    sta.z lib_conio.printf_str.putc
    lda.z putc+1
    sta.z lib_conio.printf_str.putc+1
    // [360] printf_str::s = (char *)&printf_number_buffer::buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS -- pbuz1=pbuc1 
    lda #<buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z lib_conio.printf_str.s
    lda #>buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z lib_conio.printf_str.s+1
    // [361] callexecute printf_str  -- call_var_near 
    jsr printf_str
    // if(format_justify_left && !format_zero_padding && padding)
    // [362] if(0==printf_number_buffer::format_justify_left#10) goto printf_number_buffer::@return -- 0_eq_vbum1_then_la1 
    lda format_justify_left
    beq __breturn
    // printf_number_buffer::@19
    // [363] if(0!=printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@return -- 0_neq_vbum1_then_la1 
    lda format_zero_padding
    bne __breturn
    // printf_number_buffer::@18
    // [364] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@12 -- 0_neq_vbsm1_then_la1 
    lda padding
    cmp #0
    bne __b12
    rts
    // printf_number_buffer::@12
  __b12:
    // printf_padding(putc, ' ',(char)padding)
    // [365] printf_padding::putc#2 = printf_number_buffer::putc#10 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [366] printf_padding::length#2 = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [367] call printf_padding
    // [501] phi from printf_number_buffer::@12 to printf_padding [phi:printf_number_buffer::@12->printf_padding]
    // [501] phi printf_padding::putc#5 = printf_padding::putc#2 [phi:printf_number_buffer::@12->printf_padding#0] -- register_copy 
    // [501] phi printf_padding::pad#5 = ' ' [phi:printf_number_buffer::@12->printf_padding#1] -- vbum1=vbuc1 
    lda #' '
    sta printf_padding.pad
    // [501] phi printf_padding::length#4 = printf_padding::length#2 [phi:printf_number_buffer::@12->printf_padding#2] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@return
  __breturn:
    // }
    // [368] return 
    rts
    // Outside Flow
  icall2:
    jmp (putc)
  .segment Data
    buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
    .label printf_number_buffer__19 = clrscr.ch
    format_justify_left: .byte 0
    format_zero_padding: .byte 0
    format_upper_case: .byte 0
    .label padding = uctoa.max_digits
}
.segment Code
  // utoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__mem() unsigned int value, __zp($26) char *buffer, __register(A) char radix)
utoa: {
    .label buffer = $26
    .label digit_values = $24
    // if(radix==DECIMAL)
    // [370] if(utoa::radix#2==DECIMAL) goto utoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #DECIMAL
    beq __b2
    // utoa::@2
    // if(radix==HEXADECIMAL)
    // [371] if(utoa::radix#2==HEXADECIMAL) goto utoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #HEXADECIMAL
    beq __b3
    // utoa::@3
    // if(radix==OCTAL)
    // [372] if(utoa::radix#2==OCTAL) goto utoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #OCTAL
    beq __b4
    // utoa::@4
    // if(radix==BINARY)
    // [373] if(utoa::radix#2==BINARY) goto utoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #BINARY
    beq __b5
    // utoa::@5
    // *buffer++ = 'e'
    // [374] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS) = 'e' -- _deref_pbuc1=vbuc2 
    // Unknown radix
    lda #'e'
    sta lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    // [375] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1) = 'r' -- _deref_pbuc1=vbuc2 
    lda #'r'
    sta lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    // [376] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2) = 'r' -- _deref_pbuc1=vbuc2 
    sta lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    // [377] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // utoa::@return
    // }
    // [378] return 
    rts
    // [379] phi from utoa to utoa::@1 [phi:utoa->utoa::@1]
  __b2:
    // [379] phi utoa::digit_values#8 = RADIX_DECIMAL_VALUES [phi:utoa->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_DECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES
    sta.z digit_values+1
    // [379] phi utoa::max_digits#7 = 5 [phi:utoa->utoa::@1#1] -- vbum1=vbuc1 
    lda #5
    sta max_digits
    jmp __b1
    // [379] phi from utoa::@2 to utoa::@1 [phi:utoa::@2->utoa::@1]
  __b3:
    // [379] phi utoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES [phi:utoa::@2->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_HEXADECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES
    sta.z digit_values+1
    // [379] phi utoa::max_digits#7 = 4 [phi:utoa::@2->utoa::@1#1] -- vbum1=vbuc1 
    lda #4
    sta max_digits
    jmp __b1
    // [379] phi from utoa::@3 to utoa::@1 [phi:utoa::@3->utoa::@1]
  __b4:
    // [379] phi utoa::digit_values#8 = RADIX_OCTAL_VALUES [phi:utoa::@3->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_OCTAL_VALUES
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES
    sta.z digit_values+1
    // [379] phi utoa::max_digits#7 = 6 [phi:utoa::@3->utoa::@1#1] -- vbum1=vbuc1 
    lda #6
    sta max_digits
    jmp __b1
    // [379] phi from utoa::@4 to utoa::@1 [phi:utoa::@4->utoa::@1]
  __b5:
    // [379] phi utoa::digit_values#8 = RADIX_BINARY_VALUES [phi:utoa::@4->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_BINARY_VALUES
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES
    sta.z digit_values+1
    // [379] phi utoa::max_digits#7 = $10 [phi:utoa::@4->utoa::@1#1] -- vbum1=vbuc1 
    lda #$10
    sta max_digits
    // utoa::@1
  __b1:
    // [380] phi from utoa::@1 to utoa::@6 [phi:utoa::@1->utoa::@6]
    // [380] phi utoa::buffer#10 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:utoa::@1->utoa::@6#0] -- pbuz1=pbuc1 
    lda #<lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [380] phi utoa::started#2 = 0 [phi:utoa::@1->utoa::@6#1] -- vbuxx=vbuc1 
    ldx #0
    // [380] phi utoa::value#3 = utoa::value#10 [phi:utoa::@1->utoa::@6#2] -- register_copy 
    // [380] phi utoa::digit#2 = 0 [phi:utoa::@1->utoa::@6#3] -- vbum1=vbuc1 
    txa
    sta digit
    // utoa::@6
  __b6:
    // max_digits-1
    // [381] utoa::$4 = utoa::max_digits#7 - 1 -- vbuaa=vbum1_minus_1 
    lda max_digits
    sec
    sbc #1
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [382] if(utoa::digit#2<utoa::$4) goto utoa::@7 -- vbum1_lt_vbuaa_then_la1 
    cmp digit
    beq !+
    bcs __b7
  !:
    // utoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [383] utoa::$11 = (char)utoa::value#3 -- vbuxx=_byte_vwum1 
    ldx value
    // [384] *utoa::buffer#10 = DIGITS[utoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [385] utoa::buffer#3 = ++ utoa::buffer#10 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [386] *utoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    rts
    // utoa::@7
  __b7:
    // unsigned int digit_value = digit_values[digit]
    // [387] utoa::$10 = utoa::digit#2 << 1 -- vbuaa=vbum1_rol_1 
    lda digit
    asl
    // [388] utoa::digit_value#0 = utoa::digit_values#8[utoa::$10] -- vwum1=pwuz2_derefidx_vbuaa 
    tay
    lda (digit_values),y
    sta digit_value
    iny
    lda (digit_values),y
    sta digit_value+1
    // if (started || value >= digit_value)
    // [389] if(0!=utoa::started#2) goto utoa::@10 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b10
    // utoa::@12
    // [390] if(utoa::value#3>=utoa::digit_value#0) goto utoa::@10 -- vwum1_ge_vwum2_then_la1 
    cmp value+1
    bne !+
    lda digit_value
    cmp value
    beq __b10
  !:
    bcc __b10
    // [391] phi from utoa::@12 to utoa::@9 [phi:utoa::@12->utoa::@9]
    // [391] phi utoa::buffer#15 = utoa::buffer#10 [phi:utoa::@12->utoa::@9#0] -- register_copy 
    // [391] phi utoa::started#4 = utoa::started#2 [phi:utoa::@12->utoa::@9#1] -- register_copy 
    // [391] phi utoa::value#7 = utoa::value#3 [phi:utoa::@12->utoa::@9#2] -- register_copy 
    // utoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [392] utoa::digit#1 = ++ utoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [380] phi from utoa::@9 to utoa::@6 [phi:utoa::@9->utoa::@6]
    // [380] phi utoa::buffer#10 = utoa::buffer#15 [phi:utoa::@9->utoa::@6#0] -- register_copy 
    // [380] phi utoa::started#2 = utoa::started#4 [phi:utoa::@9->utoa::@6#1] -- register_copy 
    // [380] phi utoa::value#3 = utoa::value#7 [phi:utoa::@9->utoa::@6#2] -- register_copy 
    // [380] phi utoa::digit#2 = utoa::digit#1 [phi:utoa::@9->utoa::@6#3] -- register_copy 
    jmp __b6
    // utoa::@10
  __b10:
    // utoa_append(buffer++, value, digit_value)
    // [393] utoa_append::buffer#0 = utoa::buffer#10 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z utoa_append.buffer
    lda.z buffer+1
    sta.z utoa_append.buffer+1
    // [394] utoa_append::value#0 = utoa::value#3
    // [395] utoa_append::sub#0 = utoa::digit_value#0
    // [396] call utoa_append
    // [519] phi from utoa::@10 to utoa_append [phi:utoa::@10->utoa_append]
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // [397] utoa_append::return#0 = utoa_append::value#2
    // utoa::@11
    // value = utoa_append(buffer++, value, digit_value)
    // [398] utoa::value#0 = utoa_append::return#0
    // value = utoa_append(buffer++, value, digit_value);
    // [399] utoa::buffer#4 = ++ utoa::buffer#10 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [391] phi from utoa::@11 to utoa::@9 [phi:utoa::@11->utoa::@9]
    // [391] phi utoa::buffer#15 = utoa::buffer#4 [phi:utoa::@11->utoa::@9#0] -- register_copy 
    // [391] phi utoa::started#4 = 1 [phi:utoa::@11->utoa::@9#1] -- vbuxx=vbuc1 
    ldx #1
    // [391] phi utoa::value#7 = utoa::value#0 [phi:utoa::@11->utoa::@9#2] -- register_copy 
    jmp __b9
  .segment Data
    digit_value: .word 0
    .label digit = uctoa.digit
    .label value = clrscr.ch
    .label max_digits = uctoa.max_digits
}
.segment Code
  // ultoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void ultoa(__mem() unsigned long value, __zp($26) char *buffer, __register(A) char radix)
ultoa: {
    .label buffer = $26
    .label digit_values = $24
    // if(radix==DECIMAL)
    // [401] if(ultoa::radix#2==DECIMAL) goto ultoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #DECIMAL
    beq __b2
    // ultoa::@2
    // if(radix==HEXADECIMAL)
    // [402] if(ultoa::radix#2==HEXADECIMAL) goto ultoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #HEXADECIMAL
    beq __b3
    // ultoa::@3
    // if(radix==OCTAL)
    // [403] if(ultoa::radix#2==OCTAL) goto ultoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #OCTAL
    beq __b4
    // ultoa::@4
    // if(radix==BINARY)
    // [404] if(ultoa::radix#2==BINARY) goto ultoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #BINARY
    beq __b5
    // ultoa::@5
    // *buffer++ = 'e'
    // [405] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS) = 'e' -- _deref_pbuc1=vbuc2 
    // Unknown radix
    lda #'e'
    sta lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    // [406] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1) = 'r' -- _deref_pbuc1=vbuc2 
    lda #'r'
    sta lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    // [407] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2) = 'r' -- _deref_pbuc1=vbuc2 
    sta lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    // [408] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // ultoa::@return
    // }
    // [409] return 
    rts
    // [410] phi from ultoa to ultoa::@1 [phi:ultoa->ultoa::@1]
  __b2:
    // [410] phi ultoa::digit_values#8 = RADIX_DECIMAL_VALUES_LONG [phi:ultoa->ultoa::@1#0] -- pduz1=pduc1 
    lda #<RADIX_DECIMAL_VALUES_LONG
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES_LONG
    sta.z digit_values+1
    // [410] phi ultoa::max_digits#7 = $a [phi:ultoa->ultoa::@1#1] -- vbum1=vbuc1 
    lda #$a
    sta max_digits
    jmp __b1
    // [410] phi from ultoa::@2 to ultoa::@1 [phi:ultoa::@2->ultoa::@1]
  __b3:
    // [410] phi ultoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES_LONG [phi:ultoa::@2->ultoa::@1#0] -- pduz1=pduc1 
    lda #<RADIX_HEXADECIMAL_VALUES_LONG
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES_LONG
    sta.z digit_values+1
    // [410] phi ultoa::max_digits#7 = 8 [phi:ultoa::@2->ultoa::@1#1] -- vbum1=vbuc1 
    lda #8
    sta max_digits
    jmp __b1
    // [410] phi from ultoa::@3 to ultoa::@1 [phi:ultoa::@3->ultoa::@1]
  __b4:
    // [410] phi ultoa::digit_values#8 = RADIX_OCTAL_VALUES_LONG [phi:ultoa::@3->ultoa::@1#0] -- pduz1=pduc1 
    lda #<RADIX_OCTAL_VALUES_LONG
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES_LONG
    sta.z digit_values+1
    // [410] phi ultoa::max_digits#7 = $b [phi:ultoa::@3->ultoa::@1#1] -- vbum1=vbuc1 
    lda #$b
    sta max_digits
    jmp __b1
    // [410] phi from ultoa::@4 to ultoa::@1 [phi:ultoa::@4->ultoa::@1]
  __b5:
    // [410] phi ultoa::digit_values#8 = RADIX_BINARY_VALUES_LONG [phi:ultoa::@4->ultoa::@1#0] -- pduz1=pduc1 
    lda #<RADIX_BINARY_VALUES_LONG
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES_LONG
    sta.z digit_values+1
    // [410] phi ultoa::max_digits#7 = $20 [phi:ultoa::@4->ultoa::@1#1] -- vbum1=vbuc1 
    lda #$20
    sta max_digits
    // ultoa::@1
  __b1:
    // [411] phi from ultoa::@1 to ultoa::@6 [phi:ultoa::@1->ultoa::@6]
    // [411] phi ultoa::buffer#10 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:ultoa::@1->ultoa::@6#0] -- pbuz1=pbuc1 
    lda #<lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>lib_conio.printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [411] phi ultoa::started#2 = 0 [phi:ultoa::@1->ultoa::@6#1] -- vbuxx=vbuc1 
    ldx #0
    // [411] phi ultoa::value#3 = ultoa::value#10 [phi:ultoa::@1->ultoa::@6#2] -- register_copy 
    // [411] phi ultoa::digit#2 = 0 [phi:ultoa::@1->ultoa::@6#3] -- vbum1=vbuc1 
    txa
    sta digit
    // ultoa::@6
  __b6:
    // max_digits-1
    // [412] ultoa::$4 = ultoa::max_digits#7 - 1 -- vbuaa=vbum1_minus_1 
    lda max_digits
    sec
    sbc #1
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [413] if(ultoa::digit#2<ultoa::$4) goto ultoa::@7 -- vbum1_lt_vbuaa_then_la1 
    cmp digit
    beq !+
    bcs __b7
  !:
    // ultoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [414] ultoa::$11 = (char)ultoa::value#3 -- vbuaa=_byte_vdum1 
    lda value
    // [415] *ultoa::buffer#10 = DIGITS[ultoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbuaa 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [416] ultoa::buffer#3 = ++ ultoa::buffer#10 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [417] *ultoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    rts
    // ultoa::@7
  __b7:
    // unsigned long digit_value = digit_values[digit]
    // [418] ultoa::$10 = ultoa::digit#2 << 2 -- vbuaa=vbum1_rol_2 
    lda digit
    asl
    asl
    // [419] ultoa::digit_value#0 = ultoa::digit_values#8[ultoa::$10] -- vdum1=pduz2_derefidx_vbuaa 
    tay
    lda (digit_values),y
    sta digit_value
    iny
    lda (digit_values),y
    sta digit_value+1
    iny
    lda (digit_values),y
    sta digit_value+2
    iny
    lda (digit_values),y
    sta digit_value+3
    // if (started || value >= digit_value)
    // [420] if(0!=ultoa::started#2) goto ultoa::@10 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b10
    // ultoa::@12
    // [421] if(ultoa::value#3>=ultoa::digit_value#0) goto ultoa::@10 -- vdum1_ge_vdum2_then_la1 
    lda value+3
    cmp digit_value+3
    bcc !+
    bne __b10
    lda value+2
    cmp digit_value+2
    bcc !+
    bne __b10
    lda value+1
    cmp digit_value+1
    bcc !+
    bne __b10
    lda value
    cmp digit_value
    bcs __b10
  !:
    // [422] phi from ultoa::@12 to ultoa::@9 [phi:ultoa::@12->ultoa::@9]
    // [422] phi ultoa::buffer#15 = ultoa::buffer#10 [phi:ultoa::@12->ultoa::@9#0] -- register_copy 
    // [422] phi ultoa::started#4 = ultoa::started#2 [phi:ultoa::@12->ultoa::@9#1] -- register_copy 
    // [422] phi ultoa::value#7 = ultoa::value#3 [phi:ultoa::@12->ultoa::@9#2] -- register_copy 
    // ultoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [423] ultoa::digit#1 = ++ ultoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [411] phi from ultoa::@9 to ultoa::@6 [phi:ultoa::@9->ultoa::@6]
    // [411] phi ultoa::buffer#10 = ultoa::buffer#15 [phi:ultoa::@9->ultoa::@6#0] -- register_copy 
    // [411] phi ultoa::started#2 = ultoa::started#4 [phi:ultoa::@9->ultoa::@6#1] -- register_copy 
    // [411] phi ultoa::value#3 = ultoa::value#7 [phi:ultoa::@9->ultoa::@6#2] -- register_copy 
    // [411] phi ultoa::digit#2 = ultoa::digit#1 [phi:ultoa::@9->ultoa::@6#3] -- register_copy 
    jmp __b6
    // ultoa::@10
  __b10:
    // ultoa_append(buffer++, value, digit_value)
    // [424] ultoa_append::buffer#0 = ultoa::buffer#10 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z ultoa_append.buffer
    lda.z buffer+1
    sta.z ultoa_append.buffer+1
    // [425] ultoa_append::value#0 = ultoa::value#3
    // [426] ultoa_append::sub#0 = ultoa::digit_value#0
    // [427] call ultoa_append
    // [526] phi from ultoa::@10 to ultoa_append [phi:ultoa::@10->ultoa_append]
    jsr ultoa_append
    // ultoa_append(buffer++, value, digit_value)
    // [428] ultoa_append::return#0 = ultoa_append::value#2
    // ultoa::@11
    // value = ultoa_append(buffer++, value, digit_value)
    // [429] ultoa::value#0 = ultoa_append::return#0
    // value = ultoa_append(buffer++, value, digit_value);
    // [430] ultoa::buffer#4 = ++ ultoa::buffer#10 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [422] phi from ultoa::@11 to ultoa::@9 [phi:ultoa::@11->ultoa::@9]
    // [422] phi ultoa::buffer#15 = ultoa::buffer#4 [phi:ultoa::@11->ultoa::@9#0] -- register_copy 
    // [422] phi ultoa::started#4 = 1 [phi:ultoa::@11->ultoa::@9#1] -- vbuxx=vbuc1 
    ldx #1
    // [422] phi ultoa::value#7 = ultoa::value#0 [phi:ultoa::@11->ultoa::@9#2] -- register_copy 
    jmp __b9
  .segment Data
    digit_value: .dword 0
    .label digit = uctoa.digit
    value: .dword 0
    .label max_digits = uctoa.max_digits
}
.segment Code
  // cbm_k_plot_get
/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
// __mem() unsigned int cbm_k_plot_get()
cbm_k_plot_get: {
    // __mem unsigned char x
    // [431] cbm_k_plot_get::x = 0 -- vbum1=vbuc1 
    lda #0
    sta x
    // __mem unsigned char y
    // [432] cbm_k_plot_get::y = 0 -- vbum1=vbuc1 
    sta y
    // kickasm
    // kickasm( uses cbm_k_plot_get::x uses cbm_k_plot_get::y uses CBM_PLOT) {{ sec         jsr CBM_PLOT         stx y         sty x      }}
    sec
        jsr CBM_PLOT
        stx y
        sty x
    
    // MAKEWORD(x,y)
    // [434] cbm_k_plot_get::return#0 = cbm_k_plot_get::x w= cbm_k_plot_get::y -- vwum1=vbum2_word_vbum3 
    lda x
    sta return+1
    lda y
    sta return
    // cbm_k_plot_get::@return
    // }
    // [435] return 
    rts
  .segment Data
    x: .byte 0
    y: .byte 0
    .label return = clrscr.ch
}
.segment Code
  // screenlayer
// --- layer management in VERA ---
// void screenlayer(char layer, __register(X) char mapbase, __mem() char config)
screenlayer: {
    // __mem char vera_dc_hscale_temp = *VERA_DC_HSCALE
    // [436] screenlayer::vera_dc_hscale_temp#0 = *VERA_DC_HSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_HSCALE
    sta vera_dc_hscale_temp
    // __mem char vera_dc_vscale_temp = *VERA_DC_VSCALE
    // [437] screenlayer::vera_dc_vscale_temp#0 = *VERA_DC_VSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_VSCALE
    sta vera_dc_vscale_temp
    // __conio.layer = 0
    // [438] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_LAYER) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_LAYER
    // mapbase >> 7
    // [439] screenlayer::$0 = screenlayer::mapbase#0 >> 7 -- vbuaa=vbuxx_ror_7 
    txa
    rol
    rol
    and #1
    // __conio.mapbase_bank = mapbase >> 7
    // [440] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK) = screenlayer::$0 -- _deref_pbuc1=vbuaa 
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK
    // (mapbase)<<1
    // [441] screenlayer::$1 = screenlayer::mapbase#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // MAKEWORD((mapbase)<<1,0)
    // [442] screenlayer::$2 = screenlayer::$1 w= 0 -- vwum1=vbuaa_word_vbuc1 
    ldy #0
    sta screenlayer__2+1
    sty screenlayer__2
    // __conio.mapbase_offset = MAKEWORD((mapbase)<<1,0)
    // [443] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET) = screenlayer::$2 -- _deref_pwuc1=vwum1 
    tya
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET
    lda screenlayer__2+1
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET+1
    // config & VERA_LAYER_WIDTH_MASK
    // [444] screenlayer::$7 = screenlayer::config#0 & VERA_LAYER_WIDTH_MASK -- vbuaa=vbum1_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    and config
    // (config & VERA_LAYER_WIDTH_MASK) >> 4
    // [445] screenlayer::$8 = screenlayer::$7 >> 4 -- vbuxx=vbuaa_ror_4 
    lsr
    lsr
    lsr
    lsr
    tax
    // __conio.mapwidth = VERA_LAYER_DIM[ (config & VERA_LAYER_WIDTH_MASK) >> 4]
    // [446] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPWIDTH) = screenlayer::VERA_LAYER_DIM[screenlayer::$8] -- _deref_pbuc1=pbuc2_derefidx_vbuxx 
    lda VERA_LAYER_DIM,x
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPWIDTH
    // config & VERA_LAYER_HEIGHT_MASK
    // [447] screenlayer::$5 = screenlayer::config#0 & VERA_LAYER_HEIGHT_MASK -- vbuaa=vbum1_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    and config
    // (config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [448] screenlayer::$6 = screenlayer::$5 >> 6 -- vbuaa=vbuaa_ror_6 
    rol
    rol
    rol
    and #3
    // __conio.mapheight = VERA_LAYER_DIM[ (config & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [449] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPHEIGHT) = screenlayer::VERA_LAYER_DIM[screenlayer::$6] -- _deref_pbuc1=pbuc2_derefidx_vbuaa 
    tay
    lda VERA_LAYER_DIM,y
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPHEIGHT
    // __conio.rowskip = VERA_LAYER_SKIP[(config & VERA_LAYER_WIDTH_MASK)>>4]
    // [450] screenlayer::$16 = screenlayer::$8 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [451] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_ROWSKIP) = screenlayer::VERA_LAYER_SKIP[screenlayer::$16] -- _deref_pwuc1=pwuc2_derefidx_vbuaa 
    // __conio.rowshift = ((config & VERA_LAYER_WIDTH_MASK)>>4)+6;
    tay
    lda VERA_LAYER_SKIP,y
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_ROWSKIP
    lda VERA_LAYER_SKIP+1,y
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_ROWSKIP+1
    // vera_dc_hscale_temp == 0x80
    // [452] screenlayer::$9 = screenlayer::vera_dc_hscale_temp#0 == $80 -- vboaa=vbum1_eq_vbuc1 
    lda vera_dc_hscale_temp
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // 40 << (char)(vera_dc_hscale_temp == 0x80)
    // [453] screenlayer::$18 = (char)screenlayer::$9 -- vbuxx=vbuaa 
    tax
    // [454] screenlayer::$10 = $28 << screenlayer::$18 -- vbuaa=vbuc1_rol_vbuxx 
    lda #$28
    cpx #0
    beq !e+
  !:
    asl
    dex
    bne !-
  !e:
    // (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [455] screenlayer::$11 = screenlayer::$10 - 1 -- vbuaa=vbuaa_minus_1 
    sec
    sbc #1
    // __conio.width = (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [456] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH) = screenlayer::$11 -- _deref_pbuc1=vbuaa 
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH
    // vera_dc_vscale_temp == 0x80
    // [457] screenlayer::$12 = screenlayer::vera_dc_vscale_temp#0 == $80 -- vboaa=vbum1_eq_vbuc1 
    lda vera_dc_vscale_temp
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // 30 << (char)(vera_dc_vscale_temp == 0x80)
    // [458] screenlayer::$19 = (char)screenlayer::$12 -- vbuxx=vbuaa 
    tax
    // [459] screenlayer::$13 = $1e << screenlayer::$19 -- vbuaa=vbuc1_rol_vbuxx 
    lda #$1e
    cpx #0
    beq !e+
  !:
    asl
    dex
    bne !-
  !e:
    // (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [460] screenlayer::$14 = screenlayer::$13 - 1 -- vbuaa=vbuaa_minus_1 
    sec
    sbc #1
    // __conio.height = (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [461] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT) = screenlayer::$14 -- _deref_pbuc1=vbuaa 
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [462] screenlayer::mapbase_offset#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET) -- vwum1=_deref_pwuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET
    sta mapbase_offset
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_OFFSET+1
    sta mapbase_offset+1
    // [463] phi from screenlayer to screenlayer::@1 [phi:screenlayer->screenlayer::@1]
    // [463] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#0 [phi:screenlayer->screenlayer::@1#0] -- register_copy 
    // [463] phi screenlayer::y#2 = 0 [phi:screenlayer->screenlayer::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // screenlayer::@1
  __b1:
    // for(register char y=0; y<=__conio.height; y++)
    // [464] if(screenlayer::y#2<=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT)) goto screenlayer::@2 -- vbuxx_le__deref_pbuc1_then_la1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT
    stx.z $ff
    cmp.z $ff
    bcs __b2
    // screenlayer::@return
    // }
    // [465] return 
    rts
    // screenlayer::@2
  __b2:
    // __conio.offsets[y] = mapbase_offset
    // [466] screenlayer::$17 = screenlayer::y#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [467] ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS)[screenlayer::$17] = screenlayer::mapbase_offset#2 -- pwuc1_derefidx_vbuaa=vwum1 
    tay
    lda mapbase_offset
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS,y
    lda mapbase_offset+1
    sta lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS+1,y
    // mapbase_offset += __conio.rowskip
    // [468] screenlayer::mapbase_offset#1 = screenlayer::mapbase_offset#2 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_ROWSKIP) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda mapbase_offset
    adc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_ROWSKIP
    sta mapbase_offset
    lda mapbase_offset+1
    adc lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_ROWSKIP+1
    sta mapbase_offset+1
    // for(register char y=0; y<=__conio.height; y++)
    // [469] screenlayer::y#1 = ++ screenlayer::y#2 -- vbuxx=_inc_vbuxx 
    inx
    // [463] phi from screenlayer::@2 to screenlayer::@1 [phi:screenlayer::@2->screenlayer::@1]
    // [463] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#1 [phi:screenlayer::@2->screenlayer::@1#0] -- register_copy 
    // [463] phi screenlayer::y#2 = screenlayer::y#1 [phi:screenlayer::@2->screenlayer::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    VERA_LAYER_DIM: .byte $1f, $3f, $7f, $ff
    VERA_LAYER_SKIP: .word $40, $80, $100, $200
    .label screenlayer__2 = clrscr.ch
    .label config = uctoa.max_digits
    .label vera_dc_hscale_temp = uctoa.digit
    .label vera_dc_vscale_temp = uctoa.started
    .label mapbase_offset = clrscr.ch
}
.segment Code
  // cbm_k_getin
/**
 * @brief Scan a character from keyboard without pressing enter.
 * 
 * @return char The character read.
 */
// __register(A) char cbm_k_getin()
cbm_k_getin: {
    // __mem unsigned char ch
    // [470] cbm_k_getin::ch = 0 -- vbum1=vbuc1 
    lda #0
    sta ch
    // asm
    // asm { jsrCBM_GETIN stach  }
    jsr CBM_GETIN
    sta ch
    // return ch;
    // [472] cbm_k_getin::return#1 = cbm_k_getin::ch -- vbuaa=vbum1 
    // cbm_k_getin::@return
    // }
    // [473] cbm_k_getin::return#2 = cbm_k_getin::return#1
    // [474] return 
    rts
  .segment Data
    ch: .byte 0
}
.segment Code
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
// void cscroll()
cscroll: {
    // if(__conio.cursor_y>__conio.height)
    // [475] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y)<=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT)) goto cscroll::@return -- _deref_pbuc1_le__deref_pbuc2_then_la1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT
    cmp lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y
    bcs __breturn
    // cscroll::@1
    // if(__conio.scroll[__conio.layer])
    // [476] if(0!=((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_SCROLL)[*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_LAYER)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_LAYER
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_SCROLL,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(__conio.cursor_y>__conio.height)
    // [477] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y)<=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT)) goto cscroll::@return -- _deref_pbuc1_le__deref_pbuc2_then_la1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT
    cmp lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y
    bcs __breturn
    // cscroll::@3
    // gotoxy(0,0)
    // [478] gotoxy::x = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_conio.gotoxy.x
    // [479] gotoxy::y = 0 -- vbum1=vbuc1 
    sta lib_conio.gotoxy.y
    // [480] callexecute gotoxy  -- call_var_near 
    jsr gotoxy
    // cscroll::@return
  __breturn:
    // }
    // [481] return 
    rts
    // [482] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup(1)
    // [483] call insertup
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, __conio.height)
    // [484] gotoxy::x = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_conio.gotoxy.x
    // [485] gotoxy::y = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT) -- vbum1=_deref_pbuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_HEIGHT
    sta lib_conio.gotoxy.y
    // [486] callexecute gotoxy  -- call_var_near 
    jsr gotoxy
    // clearline()
    // [487] call clearline
    jsr clearline
    rts
}
  // uctoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __register(X) char uctoa_append(__zp($28) char *buffer, __register(X) char value, __mem() char sub)
uctoa_append: {
    .label buffer = $28
    // [489] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [489] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbuyy=vbuc1 
    ldy #0
    // [489] phi uctoa_append::value#2 = uctoa_append::value#0 [phi:uctoa_append->uctoa_append::@1#1] -- register_copy 
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [490] if(uctoa_append::value#2>=uctoa_append::sub#0) goto uctoa_append::@2 -- vbuxx_ge_vbum1_then_la1 
    cpx sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [491] *uctoa_append::buffer#0 = DIGITS[uctoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuyy 
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // uctoa_append::@return
    // }
    // [492] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [493] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbuyy=_inc_vbuyy 
    iny
    // value -= sub
    // [494] uctoa_append::value#1 = uctoa_append::value#2 - uctoa_append::sub#0 -- vbuxx=vbuxx_minus_vbum1 
    txa
    sec
    sbc sub
    tax
    // [489] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [489] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    // [489] phi uctoa_append::value#2 = uctoa_append::value#1 [phi:uctoa_append::@2->uctoa_append::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label sub = uctoa.started
}
.segment Code
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __mem() unsigned int strlen(__zp($24) char *str)
strlen: {
    .label str = $24
    // [496] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [496] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta len
    sta len+1
    // [496] phi strlen::str#2 = (char *)&printf_number_buffer::buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:strlen->strlen::@1#1] -- pbuz1=pbuc1 
    lda #<printf_number_buffer.buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z str
    lda #>printf_number_buffer.buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z str+1
    // strlen::@1
  __b1:
    // while(*str)
    // [497] if(0!=*strlen::str#2) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [498] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [499] strlen::len#1 = ++ strlen::len#2 -- vwum1=_inc_vwum1 
    inc len
    bne !+
    inc len+1
  !:
    // str++;
    // [500] strlen::str#0 = ++ strlen::str#2 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [496] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [496] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [496] phi strlen::str#2 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label len = clrscr.ch
    .label return = clrscr.ch
}
.segment Code
  // printf_padding
// Print a padding char a number of times
// void printf_padding(__zp($26) void (*putc)(char), __mem() char pad, __mem() char length)
printf_padding: {
    .label putc = $26
    // [502] phi from printf_padding to printf_padding::@1 [phi:printf_padding->printf_padding::@1]
    // [502] phi printf_padding::i#2 = 0 [phi:printf_padding->printf_padding::@1#0] -- vbum1=vbuc1 
    lda #0
    sta i
    // printf_padding::@1
  __b1:
    // for(char i=0;i<length; i++)
    // [503] if(printf_padding::i#2<printf_padding::length#4) goto printf_padding::@2 -- vbum1_lt_vbum2_then_la1 
    lda i
    cmp length
    bcc __b2
    // printf_padding::@return
    // }
    // [504] return 
    rts
    // printf_padding::@2
  __b2:
    // putc(pad)
    // [505] stackpush(char) = printf_padding::pad#5 -- _stackpushbyte_=vbum1 
    lda pad
    pha
    // [506] callexecute *printf_padding::putc#5  -- call__deref_pprz1 
    jsr icall3
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_padding::@3
    // for(char i=0;i<length; i++)
    // [508] printf_padding::i#1 = ++ printf_padding::i#2 -- vbum1=_inc_vbum1 
    inc i
    // [502] phi from printf_padding::@3 to printf_padding::@1 [phi:printf_padding::@3->printf_padding::@1]
    // [502] phi printf_padding::i#2 = printf_padding::i#1 [phi:printf_padding::@3->printf_padding::@1#0] -- register_copy 
    jmp __b1
    // Outside Flow
  icall3:
    jmp (putc)
  .segment Data
    i: .byte 0
    .label length = uctoa.digit
    .label pad = uctoa.started
}
.segment Code
  // strupr
// Converts a string to uppercase.
// char * strupr(char *str)
strupr: {
    .label str = printf_number_buffer.buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label src = $22
    // [510] phi from strupr to strupr::@1 [phi:strupr->strupr::@1]
    // [510] phi strupr::src#2 = strupr::str#0 [phi:strupr->strupr::@1#0] -- pbuz1=pbuc1 
    lda #<str
    sta.z src
    lda #>str
    sta.z src+1
    // strupr::@1
  __b1:
    // while(*src)
    // [511] if(0!=*strupr::src#2) goto strupr::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strupr::@return
    // }
    // [512] return 
    rts
    // strupr::@2
  __b2:
    // toupper(*src)
    // [513] toupper::ch#0 = *strupr::src#2 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (src),y
    // [514] call toupper
    jsr toupper
    // [515] toupper::return#3 = toupper::return#2
    // strupr::@3
    // [516] strupr::$0 = toupper::return#3
    // *src = toupper(*src)
    // [517] *strupr::src#2 = strupr::$0 -- _deref_pbuz1=vbuaa 
    ldy #0
    sta (src),y
    // src++;
    // [518] strupr::src#1 = ++ strupr::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [510] phi from strupr::@3 to strupr::@1 [phi:strupr::@3->strupr::@1]
    // [510] phi strupr::src#2 = strupr::src#1 [phi:strupr::@3->strupr::@1#0] -- register_copy 
    jmp __b1
}
  // utoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __mem() unsigned int utoa_append(__zp($22) char *buffer, __mem() unsigned int value, __mem() unsigned int sub)
utoa_append: {
    .label buffer = $22
    // [520] phi from utoa_append to utoa_append::@1 [phi:utoa_append->utoa_append::@1]
    // [520] phi utoa_append::digit#2 = 0 [phi:utoa_append->utoa_append::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [520] phi utoa_append::value#2 = utoa_append::value#0 [phi:utoa_append->utoa_append::@1#1] -- register_copy 
    // utoa_append::@1
  __b1:
    // while (value >= sub)
    // [521] if(utoa_append::value#2>=utoa_append::sub#0) goto utoa_append::@2 -- vwum1_ge_vwum2_then_la1 
    lda sub+1
    cmp value+1
    bne !+
    lda sub
    cmp value
    beq __b2
  !:
    bcc __b2
    // utoa_append::@3
    // *buffer = DIGITS[digit]
    // [522] *utoa_append::buffer#0 = DIGITS[utoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // utoa_append::@return
    // }
    // [523] return 
    rts
    // utoa_append::@2
  __b2:
    // digit++;
    // [524] utoa_append::digit#1 = ++ utoa_append::digit#2 -- vbuxx=_inc_vbuxx 
    inx
    // value -= sub
    // [525] utoa_append::value#1 = utoa_append::value#2 - utoa_append::sub#0 -- vwum1=vwum1_minus_vwum2 
    lda value
    sec
    sbc sub
    sta value
    lda value+1
    sbc sub+1
    sta value+1
    // [520] phi from utoa_append::@2 to utoa_append::@1 [phi:utoa_append::@2->utoa_append::@1]
    // [520] phi utoa_append::digit#2 = utoa_append::digit#1 [phi:utoa_append::@2->utoa_append::@1#0] -- register_copy 
    // [520] phi utoa_append::value#2 = utoa_append::value#1 [phi:utoa_append::@2->utoa_append::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label value = clrscr.ch
    .label sub = utoa.digit_value
    .label return = clrscr.ch
}
.segment Code
  // ultoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __mem() unsigned long ultoa_append(__zp($22) char *buffer, __mem() unsigned long value, __mem() unsigned long sub)
ultoa_append: {
    .label buffer = $22
    // [527] phi from ultoa_append to ultoa_append::@1 [phi:ultoa_append->ultoa_append::@1]
    // [527] phi ultoa_append::digit#2 = 0 [phi:ultoa_append->ultoa_append::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [527] phi ultoa_append::value#2 = ultoa_append::value#0 [phi:ultoa_append->ultoa_append::@1#1] -- register_copy 
    // ultoa_append::@1
  __b1:
    // while (value >= sub)
    // [528] if(ultoa_append::value#2>=ultoa_append::sub#0) goto ultoa_append::@2 -- vdum1_ge_vdum2_then_la1 
    lda value+3
    cmp sub+3
    bcc !+
    bne __b2
    lda value+2
    cmp sub+2
    bcc !+
    bne __b2
    lda value+1
    cmp sub+1
    bcc !+
    bne __b2
    lda value
    cmp sub
    bcs __b2
  !:
    // ultoa_append::@3
    // *buffer = DIGITS[digit]
    // [529] *ultoa_append::buffer#0 = DIGITS[ultoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // ultoa_append::@return
    // }
    // [530] return 
    rts
    // ultoa_append::@2
  __b2:
    // digit++;
    // [531] ultoa_append::digit#1 = ++ ultoa_append::digit#2 -- vbuxx=_inc_vbuxx 
    inx
    // value -= sub
    // [532] ultoa_append::value#1 = ultoa_append::value#2 - ultoa_append::sub#0 -- vdum1=vdum1_minus_vdum2 
    lda value
    sec
    sbc sub
    sta value
    lda value+1
    sbc sub+1
    sta value+1
    lda value+2
    sbc sub+2
    sta value+2
    lda value+3
    sbc sub+3
    sta value+3
    // [527] phi from ultoa_append::@2 to ultoa_append::@1 [phi:ultoa_append::@2->ultoa_append::@1]
    // [527] phi ultoa_append::digit#2 = ultoa_append::digit#1 [phi:ultoa_append::@2->ultoa_append::@1#0] -- register_copy 
    // [527] phi ultoa_append::value#2 = ultoa_append::value#1 [phi:ultoa_append::@2->ultoa_append::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label value = ultoa.value
    .label sub = ultoa.digit_value
    .label return = ultoa.value
}
.segment Code
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
// void insertup(char rows)
insertup: {
    // __conio.width+1
    // [533] insertup::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH) + 1 -- vbuaa=_deref_pbuc1_plus_1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH
    inc
    // unsigned char width = (__conio.width+1) * 2
    // [534] insertup::width#0 = insertup::$0 << 1 -- vbum1=vbuaa_rol_1 
    // {asm{.byte $db}}
    asl
    sta width
    // [535] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [535] phi insertup::y#2 = 0 [phi:insertup->insertup::@1#0] -- vbum1=vbuc1 
    lda #0
    sta y
    // insertup::@1
  __b1:
    // for(unsigned char y=0; y<__conio.cursor_y; y++)
    // [536] if(insertup::y#2<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y)) goto insertup::@2 -- vbum1_lt__deref_pbuc1_then_la1 
    lda y
    cmp lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y
    bcc __b2
    // [537] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [538] call clearline
    jsr clearline
    // insertup::@return
    // }
    // [539] return 
    rts
    // insertup::@2
  __b2:
    // y+1
    // [540] insertup::$4 = insertup::y#2 + 1 -- vbuxx=vbum1_plus_1 
    ldx y
    inx
    // memcpy8_vram_vram(__conio.mapbase_bank, __conio.offsets[y], __conio.mapbase_bank, __conio.offsets[y+1], width)
    // [541] insertup::$6 = insertup::y#2 << 1 -- vbuyy=vbum1_rol_1 
    lda y
    asl
    tay
    // [542] insertup::$7 = insertup::$4 << 1 -- vbuxx=vbuxx_rol_1 
    txa
    asl
    tax
    // [543] memcpy8_vram_vram::dbank_vram#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK) -- vbum1=_deref_pbuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK
    sta memcpy8_vram_vram.dbank_vram
    // [544] memcpy8_vram_vram::doffset_vram#0 = ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS)[insertup::$6] -- vwum1=pwuc1_derefidx_vbuyy 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS,y
    sta memcpy8_vram_vram.doffset_vram
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS+1,y
    sta memcpy8_vram_vram.doffset_vram+1
    // [545] memcpy8_vram_vram::sbank_vram#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK) -- vbum1=_deref_pbuc1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK
    sta memcpy8_vram_vram.sbank_vram
    // [546] memcpy8_vram_vram::soffset_vram#0 = ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS)[insertup::$7] -- vwum1=pwuc1_derefidx_vbuxx 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS,x
    sta memcpy8_vram_vram.soffset_vram
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS+1,x
    sta memcpy8_vram_vram.soffset_vram+1
    // [547] memcpy8_vram_vram::num8#1 = insertup::width#0 -- vbuyy=vbum1 
    ldy width
    // [548] call memcpy8_vram_vram
    jsr memcpy8_vram_vram
    // insertup::@4
    // for(unsigned char y=0; y<__conio.cursor_y; y++)
    // [549] insertup::y#1 = ++ insertup::y#2 -- vbum1=_inc_vbum1 
    inc y
    // [535] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [535] phi insertup::y#2 = insertup::y#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    .label width = uctoa.digit
    .label y = uctoa.max_digits
}
.segment Code
  // clearline
// void clearline()
clearline: {
    // unsigned int addr = __conio.offsets[__conio.cursor_y]
    // [550] clearline::$3 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_CURSOR_Y
    asl
    // [551] clearline::addr#0 = ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS)[clearline::$3] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS,y
    sta addr
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_OFFSETS+1,y
    sta addr+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [552] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(addr)
    // [553] clearline::$0 = byte0  clearline::addr#0 -- vbuaa=_byte0_vwum1 
    lda addr
    // *VERA_ADDRX_L = BYTE0(addr)
    // [554] *VERA_ADDRX_L = clearline::$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(addr)
    // [555] clearline::$1 = byte1  clearline::addr#0 -- vbuaa=_byte1_vwum1 
    lda addr+1
    // *VERA_ADDRX_M = BYTE1(addr)
    // [556] *VERA_ADDRX_M = clearline::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [557] clearline::$2 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_MAPBASE_BANK
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [558] *VERA_ADDRX_H = clearline::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // register unsigned char c=__conio.width
    // [559] clearline::c#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH) -- vbuxx=_deref_pbuc1 
    ldx lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_WIDTH
    // [560] phi from clearline clearline::@1 to clearline::@1 [phi:clearline/clearline::@1->clearline::@1]
    // [560] phi clearline::c#2 = clearline::c#0 [phi:clearline/clearline::@1->clearline::@1#0] -- register_copy 
    // clearline::@1
  __b1:
    // *VERA_DATA0 = ' '
    // [561] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [562] *VERA_DATA0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR) -- _deref_pbuc1=_deref_pbuc2 
    lda lib_conio.__conio+OFFSET_STRUCT_CX16_CONIO_S_COLOR
    sta VERA_DATA0
    // c--;
    // [563] clearline::c#1 = -- clearline::c#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(c)
    // [564] if(0!=clearline::c#1) goto clearline::@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b1
    // clearline::@return
    // }
    // [565] return 
    rts
  .segment Data
    .label addr = clrscr.ch
}
.segment Code
  // toupper
// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
// __register(A) char toupper(__register(A) char ch)
toupper: {
    // if(ch>='a' && ch<='z')
    // [566] if(toupper::ch#0<'a') goto toupper::@return -- vbuaa_lt_vbuc1_then_la1 
    cmp #'a'
    bcc __breturn
    // toupper::@2
    // [567] if(toupper::ch#0<='z') goto toupper::@1 -- vbuaa_le_vbuc1_then_la1 
    cmp #'z'
    bcc __b1
    beq __b1
    // [569] phi from toupper toupper::@1 toupper::@2 to toupper::@return [phi:toupper/toupper::@1/toupper::@2->toupper::@return]
    // [569] phi toupper::return#2 = toupper::ch#0 [phi:toupper/toupper::@1/toupper::@2->toupper::@return#0] -- register_copy 
    rts
    // toupper::@1
  __b1:
    // return ch + ('A'-'a');
    // [568] toupper::return#0 = toupper::ch#0 + 'A'-'a' -- vbuaa=vbuaa_plus_vbuc1 
    clc
    adc #'A'-'a'
    // toupper::@return
  __breturn:
    // }
    // [570] return 
    rts
}
  // memcpy8_vram_vram
/**
 * @brief Copy a block of memory in VRAM from a source to a target destination.
 * This function is designed to copy maximum 255 bytes of memory in one step.
 * If more than 255 bytes need to be copied, use the memcpy_vram_vram function.
 *
 * @see memcpy_vram_vram
 *
 * @param dbank_vram Bank of the destination location in vram.
 * @param doffset_vram Offset of the destination location in vram.
 * @param sbank_vram Bank of the source location in vram.
 * @param soffset_vram Offset of the source location in vram.
 * @param num16 Specified the amount of bytes to be copied.
 */
// void memcpy8_vram_vram(__mem() char dbank_vram, __mem() unsigned int doffset_vram, __mem() char sbank_vram, __mem() unsigned int soffset_vram, __register(X) char num8)
memcpy8_vram_vram: {
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [571] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(soffset_vram)
    // [572] memcpy8_vram_vram::$0 = byte0  memcpy8_vram_vram::soffset_vram#0 -- vbuaa=_byte0_vwum1 
    lda soffset_vram
    // *VERA_ADDRX_L = BYTE0(soffset_vram)
    // [573] *VERA_ADDRX_L = memcpy8_vram_vram::$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(soffset_vram)
    // [574] memcpy8_vram_vram::$1 = byte1  memcpy8_vram_vram::soffset_vram#0 -- vbuaa=_byte1_vwum1 
    lda soffset_vram+1
    // *VERA_ADDRX_M = BYTE1(soffset_vram)
    // [575] *VERA_ADDRX_M = memcpy8_vram_vram::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // sbank_vram | VERA_INC_1
    // [576] memcpy8_vram_vram::$2 = memcpy8_vram_vram::sbank_vram#0 | VERA_INC_1 -- vbuaa=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora sbank_vram
    // *VERA_ADDRX_H = sbank_vram | VERA_INC_1
    // [577] *VERA_ADDRX_H = memcpy8_vram_vram::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [578] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [579] memcpy8_vram_vram::$3 = byte0  memcpy8_vram_vram::doffset_vram#0 -- vbuaa=_byte0_vwum1 
    lda doffset_vram
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [580] *VERA_ADDRX_L = memcpy8_vram_vram::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [581] memcpy8_vram_vram::$4 = byte1  memcpy8_vram_vram::doffset_vram#0 -- vbuaa=_byte1_vwum1 
    lda doffset_vram+1
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [582] *VERA_ADDRX_M = memcpy8_vram_vram::$4 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // dbank_vram | VERA_INC_1
    // [583] memcpy8_vram_vram::$5 = memcpy8_vram_vram::dbank_vram#0 | VERA_INC_1 -- vbuaa=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora dbank_vram
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [584] *VERA_ADDRX_H = memcpy8_vram_vram::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [585] phi from memcpy8_vram_vram memcpy8_vram_vram::@2 to memcpy8_vram_vram::@1 [phi:memcpy8_vram_vram/memcpy8_vram_vram::@2->memcpy8_vram_vram::@1]
  __b1:
    // [585] phi memcpy8_vram_vram::num8#2 = memcpy8_vram_vram::num8#1 [phi:memcpy8_vram_vram/memcpy8_vram_vram::@2->memcpy8_vram_vram::@1#0] -- register_copy 
  // the size is only a byte, this is the fastest loop!
    // memcpy8_vram_vram::@1
    // while (num8--)
    // [586] memcpy8_vram_vram::num8#0 = -- memcpy8_vram_vram::num8#2 -- vbuxx=_dec_vbuyy 
    tya
    tax
    dex
    // [587] if(0!=memcpy8_vram_vram::num8#2) goto memcpy8_vram_vram::@2 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne __b2
    // memcpy8_vram_vram::@return
    // }
    // [588] return 
    rts
    // memcpy8_vram_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [589] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // [590] memcpy8_vram_vram::num8#6 = memcpy8_vram_vram::num8#0 -- vbuyy=vbuxx 
    txa
    tay
    jmp __b1
  .segment Data
    .label dbank_vram = uctoa.started
    .label doffset_vram = clrscr.ch
    .label sbank_vram = printf_number_buffer.format_justify_left
    .label soffset_vram = utoa.digit_value
}
  // Exported Global Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of binary digits
  RADIX_BINARY_VALUES_CHAR: .byte $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES_CHAR: .byte $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // Values of binary digits
  RADIX_BINARY_VALUES: .word $8000, $4000, $2000, $1000, $800, $400, $200, $100, $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES: .word $8000, $1000, $200, $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES: .word $1000, $100, $10
  // Values of binary digits
  RADIX_BINARY_VALUES_LONG: .dword $80000000, $40000000, $20000000, $10000000, $8000000, $4000000, $2000000, $1000000, $800000, $400000, $200000, $100000, $80000, $40000, $20000, $10000, $8000, $4000, $2000, $1000, $800, $400, $200, $100, $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES_LONG: .dword $40000000, $8000000, $1000000, $200000, $40000, $8000, $1000, $200, $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_LONG: .dword $3b9aca00, $5f5e100, $989680, $f4240, $186a0, $2710, $3e8, $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_LONG: .dword $10000000, $1000000, $100000, $10000, $1000, $100, $10
  __conio: .fill lib_conio.SIZEOF_STRUCT_CX16_CONIO_S, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill lib_conio.SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
} // namespace
