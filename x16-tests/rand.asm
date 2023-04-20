/// @file
/// Provides provide console input/output
///
/// Implements similar functions as conio.h from CC65 for compatibility
/// See https://github.com/cc65/cc65/blob/master/include/conio.h
//
/// Currently CX16/C64/PLUS4/VIC20 platforms are supported
  // Commodore 64 PRG executable file
.file [name="rand.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const LIGHT_BLUE = $e
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const OFFSET_STRUCT_P_X = 2
  .const OFFSET_STRUCT_P_DX = 4
  .const OFFSET_STRUCT_A_X = 2
  .const OFFSET_STRUCT_A_DX = 4
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .const SIZEOF_STRUCT_A = 5
  /// Color Ram
  .label COLORRAM = $d800
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $16
  // The current cursor y-position
  .label conio_cursor_y = $e
  // The current text cursor line start
  .label conio_line_text = $11
  // The current color cursor line start
  .label conio_line_color = $f
.segment Code
__start: {
    lda #0
    sta.z conio_cursor_x
    sta.z conio_cursor_y
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    lda #<COLORRAM
    sta.z conio_line_color
    lda #>COLORRAM
    sta.z conio_line_color+1
    jsr conio_c64_init
    jsr main
    rts
}
// Set initial cursor position
conio_c64_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    ldx.z BASIC_CURSOR_LINE
    cpx #$19
    bcc __b1
    ldx #$19-1
  __b1:
    jsr gotoxy
    rts
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__register(A) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    cmp #'\n'
    beq __b1
    ldy.z conio_cursor_x
    sta (conio_line_text),y
    lda #LIGHT_BLUE
    sta (conio_line_color),y
    inc.z conio_cursor_x
    lda #$28
    cmp.z conio_cursor_x
    bne __breturn
    jsr cputln
  __breturn:
    rts
  __b1:
    jsr cputln
    rts
}
main: {
    .label P = sa
    jsr clrscr
    ldx #$1e
    jsr gotoxy
    lda #<$c8
    sta sa+OFFSET_STRUCT_A_X
    lda #>$c8
    sta sa+OFFSET_STRUCT_A_X+1
    lda #-8
    sta sa+OFFSET_STRUCT_A_DX
    lda P+OFFSET_STRUCT_P_DX
    sta.z $ff
    clc
    adc P+OFFSET_STRUCT_P_X
    sta P+OFFSET_STRUCT_P_X
    lda.z $ff
    ora #$7f
    bmi !+
    lda #0
  !:
    adc P+OFFSET_STRUCT_P_X+1
    sta P+OFFSET_STRUCT_P_X+1
    lda sa+OFFSET_STRUCT_A_X
    sta.z printf_sint.value
    lda sa+OFFSET_STRUCT_A_X+1
    sta.z printf_sint.value+1
    jsr printf_sint
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    rts
  .segment Data
    s: .text @"\n"
    .byte 0
}
.segment Code
// Set the cursor to the specified position
// void gotoxy(char x, __register(X) char y)
gotoxy: {
    .label __5 = $19
    .label __6 = $17
    .label line_offset = $17
    cpx #$19+1
    bcc __b2
    ldx #0
  __b2:
    lda #0
    sta.z conio_cursor_x
    stx.z conio_cursor_y
    txa
    sta __7
    lda #0
    sta __7+1
    lda __7
    asl
    sta __8
    lda __7+1
    rol
    sta __8+1
    asl __8
    rol __8+1
    clc
    lda __9
    adc __8
    sta __9
    lda __9+1
    adc __8+1
    sta __9+1
    lda __9
    asl
    sta.z line_offset
    lda __9+1
    rol
    sta.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    lda.z line_offset
    clc
    adc #<DEFAULT_SCREEN
    sta.z __5
    lda.z line_offset+1
    adc #>DEFAULT_SCREEN
    sta.z __5+1
    lda.z __5
    sta.z conio_line_text
    lda.z __5+1
    sta.z conio_line_text+1
    lda.z __6
    clc
    adc #<COLORRAM
    sta.z __6
    lda.z __6+1
    adc #>COLORRAM
    sta.z __6+1
    lda.z __6
    sta.z conio_line_color
    lda.z __6+1
    sta.z conio_line_color+1
    rts
  .segment Data
    __7: .word 0
    __8: .word 0
    .label __9 = __7
}
.segment Code
// Print a newline
cputln: {
    lda #$28
    clc
    adc.z conio_line_text
    sta.z conio_line_text
    bcc !+
    inc.z conio_line_text+1
  !:
    lda #$28
    clc
    adc.z conio_line_color
    sta.z conio_line_color
    bcc !+
    inc.z conio_line_color+1
  !:
    lda #0
    sta.z conio_cursor_x
    inc.z conio_cursor_y
    jsr cscroll
    rts
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = 6
    .label line_cols = $a
    lda #<COLORRAM
    sta.z line_cols
    lda #>COLORRAM
    sta.z line_cols+1
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    ldx #0
  __b1:
    cpx #$19
    bcc __b2
    lda #0
    sta.z conio_cursor_x
    sta.z conio_cursor_y
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    lda #<COLORRAM
    sta.z conio_line_color
    lda #>COLORRAM
    sta.z conio_line_color+1
    rts
  __b2:
    ldy #0
  __b3:
    cpy #$28
    bcc __b4
    lda #$28
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    lda #$28
    clc
    adc.z line_cols
    sta.z line_cols
    bcc !+
    inc.z line_cols+1
  !:
    inx
    jmp __b1
  __b4:
    lda #' '
    sta (line_text),y
    lda #LIGHT_BLUE
    sta (line_cols),y
    iny
    jmp __b3
}
// Print a signed integer using a specific format
// void printf_sint(void (*putc)(char), __zp(6) int value, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_sint: {
    .label putc = cputc
    .label value = 6
    // Handle any sign
    lda #0
    sta printf_buffer
    lda.z value+1
    bmi __b1
    jmp __b2
  __b1:
    lda #0
    sec
    sbc.z value
    sta.z value
    lda #0
    sbc.z value+1
    sta.z value+1
    lda #'-'
    sta printf_buffer
  __b2:
    jsr utoa
    lda printf_buffer
  // Print using format
    jsr printf_number_buffer
    rts
}
/// Print a NUL-terminated string
// void printf_str(__zp($a) void (*putc)(char), __zp($c) const char *s)
printf_str: {
    .label s = $c
    .label putc = $a
  __b1:
    ldy #0
    lda (s),y
    inc.z s
    bne !+
    inc.z s+1
  !:
    cmp #0
    bne __b2
    rts
  __b2:
    pha
    jsr icall1
    pla
    jmp __b1
  icall1:
    jmp (putc)
}
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    lda #$19
    cmp.z conio_cursor_y
    bne __breturn
    lda #<DEFAULT_SCREEN
    sta.z memcpy.destination
    lda #>DEFAULT_SCREEN
    sta.z memcpy.destination+1
    lda #<DEFAULT_SCREEN+$28
    sta.z memcpy.source
    lda #>DEFAULT_SCREEN+$28
    sta.z memcpy.source+1
    jsr memcpy
    lda #<COLORRAM
    sta.z memcpy.destination
    lda #>COLORRAM
    sta.z memcpy.destination+1
    lda #<COLORRAM+$28
    sta.z memcpy.source
    lda #>COLORRAM+$28
    sta.z memcpy.source+1
    jsr memcpy
    ldx #' '
    lda #<DEFAULT_SCREEN+$19*$28-$28
    sta.z memset.str
    lda #>DEFAULT_SCREEN+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    ldx #LIGHT_BLUE
    lda #<COLORRAM+$19*$28-$28
    sta.z memset.str
    lda #>COLORRAM+$19*$28-$28
    sta.z memset.str+1
    jsr memset
    sec
    lda.z conio_line_text
    sbc #$28
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #0
    sta.z conio_line_text+1
    sec
    lda.z conio_line_color
    sbc #$28
    sta.z conio_line_color
    lda.z conio_line_color+1
    sbc #0
    sta.z conio_line_color+1
    dec.z conio_cursor_y
  __breturn:
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__zp(6) unsigned int value, __zp($c) char *buffer, char radix)
utoa: {
    .const max_digits = 5
    .label digit_value = $a
    .label buffer = $c
    .label digit = $13
    .label value = 6
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  __b1:
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    ldx.z value
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    lda #0
    tay
    sta (buffer),y
    rts
  __b2:
    lda.z digit
    asl
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    cpx #0
    bne __b5
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b5
  !:
    bcc __b5
  __b4:
    inc.z digit
    jmp __b1
  __b5:
    lda.z buffer
    sta.z utoa_append.buffer
    lda.z buffer+1
    sta.z utoa_append.buffer+1
    jsr utoa_append
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    ldx #1
    jmp __b4
}
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(void (*putc)(char), __register(A) char buffer_sign, char *buffer_digits, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    cmp #0
    beq __b2
    pha
    jsr cputc
    pla
  __b2:
    lda #<printf_sint.putc
    sta.z printf_str.putc
    lda #>printf_sint.putc
    sta.z printf_str.putc+1
    lda #<buffer_digits
    sta.z printf_str.s
    lda #>buffer_digits
    sta.z printf_str.s+1
    jsr printf_str
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(__zp(4) void *destination, __zp(2) void *source, unsigned int num)
memcpy: {
    .label src_end = 8
    .label dst = 4
    .label src = 2
    .label source = 2
    .label destination = 4
    lda.z source
    clc
    adc #<$19*$28-$28
    sta.z src_end
    lda.z source+1
    adc #>$19*$28-$28
    sta.z src_end+1
  __b1:
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
    bne __b2
    rts
  __b2:
    ldy #0
    lda (src),y
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(__zp(2) void *str, __register(X) char c, unsigned int num)
memset: {
    .label end = 4
    .label dst = 2
    .label str = 2
    lda #$28
    clc
    adc.z str
    sta.z end
    lda #0
    adc.z str+1
    sta.z end+1
  __b2:
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
    rts
  __b3:
    txa
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __zp(6) unsigned int utoa_append(__zp($14) char *buffer, __zp(6) unsigned int value, __zp($a) unsigned int sub)
utoa_append: {
    .label buffer = $14
    .label value = 6
    .label sub = $a
    .label return = 6
    ldx #0
  __b1:
    lda.z sub+1
    cmp.z value+1
    bne !+
    lda.z sub
    cmp.z value
    beq __b2
  !:
    bcc __b2
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    rts
  __b2:
    inx
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    jmp __b1
}
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
  sa: .fill SIZEOF_STRUCT_A, 0
