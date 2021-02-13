// Functions for printing formatted strings
// C standard library stdlib.h
// Implementation of functions found int C stdlib.h / stdlib.c
// C standard library string.h
// Functions to manipulate C strings and arrays.
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="helloworld.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
  .const VERA_L1_CONFIG_WIDTH_MASK = $30
  .const VERA_L1_CONFIG_HEIGHT_MASK = $c0
  .const WHITE = 1
  .const RED = 2
  .const PURPLE = 4
  .const BLUE = 6
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  // $9F20 VRAM Address (7:0)
  .label VERA_ADDRX_L = $9f20
  // $9F21 VRAM Address (15:8)
  .label VERA_ADDRX_M = $9f21
  // $9F22 VRAM Address (7:0)
  // Bit 4-7: Address Increment  The following is the amount incremented per value value:increment
  //                             0:0, 1:1, 2:2, 3:4, 4:8, 5:16, 6:32, 7:64, 8:128, 9:256, 10:512, 11:40, 12:80, 13:160, 14:320, 15:640
  // Bit 3: DECR Setting the DECR bit, will decrement instead of increment by the value set by the 'Address Increment' field.
  // Bit 0: VRAM Address (16)
  .label VERA_ADDRX_H = $9f22
  // $9F23	DATA0	VRAM Data port 0
  .label VERA_DATA0 = $9f23
  // $9F24	DATA1	VRAM Data port 1
  .label VERA_DATA1 = $9f24
  // $9F25	CTRL Control
  // Bit 7: Reset
  // Bit 1: DCSEL
  // Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  // $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  // VRAM Address of the default screen
  .label DEFAULT_SCREEN = 0
  // Color Ram
  .label COLORRAM = $d800
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $e
  // The current cursor y-position
  .label conio_cursor_y = $f
  // The current text cursor line start
  .label conio_line_text = $10
  // The current text color
  .label conio_textcolor = $12
  .label conio_backcolor = $13
.segment Code
__start: {
    lda #0
    sta.z conio_cursor_x
    sta.z conio_cursor_y
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    lda #WHITE
    sta.z conio_textcolor
    lda #BLUE
    sta.z conio_backcolor
    jsr conio_c64_init
    jsr main
    rts
}
// Set initial cursor position
conio_c64_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    ldx BASIC_CURSOR_LINE
    cpx #$3c
    bcc __b1
    ldx #$3c-1
  __b1:
    jsr gotoxy
    rts
}
main: {
    .label i = 2
    .label i1 = 4
    lda #BLUE
    jsr textcolor
    jsr backcolor
    jsr clrscr
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    lda #0
    sta.z printf_sint.format_zero_padding
    sta.z printf_sint.format_min_length
    lda #<$10
    sta.z printf_sint.value
    lda #>$10
    sta.z printf_sint.value+1
    jsr printf_sint
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    lda #RED
    jsr textcolor
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    ldx #2
    jsr gotoxy
    lda #PURPLE
    jsr textcolor
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    ldx #4
    jsr gotoxy
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    lda.z i+1
    bmi __b2
    cmp #>$36
    bcc __b2
    bne !+
    lda.z i
    cmp #<$36
    bcc __b2
  !:
    lda #<0
    sta.z i1
    sta.z i1+1
  __b3:
    lda.z i1+1
    bmi __b4
    cmp #>2
    bcc __b4
    bne !+
    lda.z i1
    cmp #<2
    bcc __b4
  !:
    rts
  __b4:
    ldx #4
    jsr gotoxy
    jsr insertdown
    inc.z i1
    bne !+
    inc.z i1+1
  !:
    jmp __b3
  __b2:
    lda #<s7
    sta.z cputs.s
    lda #>s7
    sta.z cputs.s+1
    jsr cputs
    lda.z i
    sta.z printf_sint.value
    lda.z i+1
    sta.z printf_sint.value+1
    lda #1
    sta.z printf_sint.format_zero_padding
    lda #2
    sta.z printf_sint.format_min_length
    jsr printf_sint
    lda #<s8
    sta.z cputs.s
    lda #>s8
    sta.z cputs.s+1
    jsr cputs
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
  .segment Data
    s: .text @"hello world!\n"
    .byte 0
    s1: .text "this is a test. "
    .byte 0
    s2: .text "it implements the cx"
    .byte 0
    s3: .text @" vera logic.\n"
    .byte 0
    s4: .text @"\namazing!\n"
    .byte 0
    s5: .text "here i insert a text."
    .byte 0
    s6: .text @"this texts are moved on the next line\n"
    .byte 0
    s7: .text "line "
    .byte 0
    s8: .text " ........................................................................"
    .byte 0
}
.segment Code
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .label __7 = $14
    .label line_offset = $14
    cpx #$3c+1
    bcc __b2
    ldx #0
  __b2:
    lda #0
    sta.z conio_cursor_x
    stx.z conio_cursor_y
    txa
    sta.z __7
    lda #0
    sta.z __7+1
    lda.z line_offset
    sta.z line_offset+1
    lda #0
    sta.z line_offset
    sta.z conio_line_text
    lda.z line_offset+1
    sta.z conio_line_text+1
    rts
}
// Set the color for text output. The old color setting is returned.
// textcolor(byte register(A) color)
textcolor: {
    sta.z conio_textcolor
    rts
}
// Set the color for back output. The old color setting is returned.
backcolor: {
    lda #WHITE
    sta.z conio_backcolor
    rts
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label conio_width = $16
    .label conio_height = $1d
    .label color = $18
    .label line_text = 7
    lda #VERA_L1_CONFIG_WIDTH_MASK
    and VERA_L1_CONFIG
    lsr
    lsr
    lsr
    lsr
    asl
    tay
    lda VERA_L1_CONFIG_WIDTH,y
    sta.z conio_width
    lda VERA_L1_CONFIG_WIDTH+1,y
    sta.z conio_width+1
    lda #VERA_L1_CONFIG_HEIGHT_MASK
    and VERA_L1_CONFIG
    rol
    rol
    rol
    and #3
    asl
    tay
    lda VERA_L1_CONFIG_HEIGHT,y
    sta.z conio_height
    lda VERA_L1_CONFIG_HEIGHT+1,y
    sta.z conio_height+1
    lda.z conio_backcolor
    asl
    asl
    asl
    asl
    ora.z conio_textcolor
    sta.z color
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    ldx #0
  __b1:
    lda.z conio_height+1
    bne __b2
    cpx.z conio_height
    bcc __b2
    lda #0
    sta.z conio_cursor_x
    sta.z conio_cursor_y
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    rts
  __b2:
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    lda.z line_text
    // Set address
    sta VERA_ADDRX_L
    lda.z line_text+1
    sta VERA_ADDRX_M
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    ldy #0
  __b4:
    lda.z conio_width+1
    bne __b5
    cpy.z conio_width
    bcc __b5
    clc
    lda.z line_text
    adc #<$100
    sta.z line_text
    lda.z line_text+1
    adc #>$100
    sta.z line_text+1
    inx
    jmp __b1
  __b5:
    // Set data
    lda #' '
    sta VERA_DATA0
    lda.z color
    sta VERA_DATA0
    iny
    jmp __b4
}
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp(7) s)
cputs: {
    .label s = 7
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
    tay
    jsr cputc
    jmp __b1
}
// Print a signed integer using a specific format
// printf_sint(signed word zp(7) value, byte zp($18) format_min_length, byte zp(6) format_zero_padding)
printf_sint: {
    .label value = 7
    .label format_min_length = $18
    .label format_zero_padding = 6
    // Handle any sign
    lda #0
    sta printf_buffer
    lda.z value+1
    bmi __b1
    jmp __b2
  __b1:
    sec
    lda #0
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
    sta.z printf_number_buffer.buffer_sign
    ldx.z format_min_length
    // Print using format
    jsr printf_number_buffer
    rts
}
// Insert a new line, and scroll the rest of the screen down.
insertdown: {
    .label n = $50*2
    .label cy = 7
    .label i = 7
    .label line = $1d
    .label start = $1d
    sec
    lda #$3c
    sbc.z conio_cursor_y
    sta.z cy
    lda #0
    sbc #0
    sta.z cy+1
    lda.z cy
    sec
    sbc #1
    sta.z cy
    lda.z cy+1
    sbc #0
    sta.z cy+1
    lda.z i
    sec
    sbc #1
    sta.z i
    lda.z i+1
    sbc #0
    sta.z i+1
  __b1:
    lda.z i+1
    bne __b2
    lda.z i
    bne __b2
  !:
    rts
  __b2:
    lda.z i
    sta.z line+1
    lda #0
    sta.z line
    lda.z start
    clc
    adc.z conio_line_text
    sta.z start
    lda.z start+1
    adc.z conio_line_text+1
    sta.z start+1
    clc
    lda.z start
    adc #<$100
    sta.z vram_to_vram.vput
    lda.z start+1
    adc #>$100
    sta.z vram_to_vram.vput+1
    jsr vram_to_vram
    lda.z i
    bne !+
    dec.z i+1
  !:
    dec.z i
    jmp __b1
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte register(Y) c)
cputc: {
    .label __4 = $1b
    .label __6 = $1d
    .label color = $1a
    lda.z conio_backcolor
    asl
    asl
    asl
    asl
    ora.z conio_textcolor
    sta.z color
    cpy #'\n'
    beq __b1
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    lda.z conio_cursor_x
    asl
    tax
    txa
    clc
    adc.z conio_line_text
    sta.z __4
    lda #0
    adc.z conio_line_text+1
    sta.z __4+1
    lda.z __4
    sta VERA_ADDRX_L
    txa
    clc
    adc.z conio_line_text
    sta.z __6
    lda #0
    adc.z conio_line_text+1
    sta.z __6+1
    sta VERA_ADDRX_M
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    sty VERA_DATA0
    lda.z color
    sta VERA_DATA0
    inc.z conio_cursor_x
    lda #$50
    cmp.z conio_cursor_x
    bne __breturn
    jsr cputln
  __breturn:
    rts
  __b1:
    jsr cputln
    rts
}
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp(7) value, byte* zp($c) buffer)
utoa: {
    .label digit_value = $1d
    .label buffer = $c
    .label digit = 9
    .label value = 7
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    ldx #0
    txa
    sta.z digit
  __b1:
    lda.z digit
    cmp #5-1
    bcc __b2
    lda.z value
    tay
    lda DIGITS,y
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
// printf_number_buffer(byte zp($19) buffer_sign, byte register(X) format_min_length, byte zp(6) format_zero_padding)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label __19 = $16
    .label buffer_sign = $19
    .label format_zero_padding = 6
    .label padding = 9
    cpx #0
    beq __b5
    jsr strlen
    // There is a minimum length - work out the padding
    ldy.z __19
    lda.z buffer_sign
    cmp #0
    beq __b10
    iny
  __b10:
    txa
    sty.z $ff
    sec
    sbc.z $ff
    sta.z padding
    cmp #0
    bpl __b1
  __b5:
    lda #0
    sta.z padding
  __b1:
    lda.z format_zero_padding
    cmp #0
    bne __b2
    lda.z padding
    cmp #0
    bne __b7
    jmp __b2
  __b7:
    lda.z padding
    sta.z printf_padding.length
    lda #' '
    sta.z printf_padding.pad
    jsr printf_padding
  __b2:
    lda.z buffer_sign
    cmp #0
    beq __b3
    tay
    jsr cputc
  __b3:
    lda.z format_zero_padding
    cmp #0
    beq __b4
    lda.z padding
    cmp #0
    bne __b9
    jmp __b4
  __b9:
    lda.z padding
    sta.z printf_padding.length
    lda #'0'
    sta.z printf_padding.pad
    jsr printf_padding
  __b4:
    lda #<buffer_digits
    sta.z cputs.s
    lda #>buffer_digits
    sta.z cputs.s+1
    jsr cputs
    rts
}
// Copy block of memory (from RAM to VRAM)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - src: The source address in RAM
// - num: The number of bytes to copy
// vram_to_vram(void* zp($1d) vget, byte* zp($1b) vput)
vram_to_vram: {
    .label i = $c
    .label vget = $1d
    .label vput = $1b
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    lda.z vget
    // Set address
    sta VERA_ADDRX_L
    lda.z vget+1
    sta VERA_ADDRX_M
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // Select DATA1
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    lda.z vput
    // Set address
    sta VERA_ADDRX_L
    lda.z vput+1
    sta VERA_ADDRX_M
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
  __b1:
    lda.z i+1
    cmp #>insertdown.n
    bcc __b2
    bne !+
    lda.z i
    cmp #<insertdown.n
    bcc __b2
  !:
    rts
  __b2:
    lda VERA_DATA0
    sta VERA_DATA1
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// Print a newline
cputln: {
    //conio_line_text +=  CONIO_WIDTH;
    clc
    lda.z conio_line_text
    adc #<$100
    sta.z conio_line_text
    lda.z conio_line_text+1
    adc #>$100
    sta.z conio_line_text+1
    lda #0
    sta.z conio_cursor_x
    inc.z conio_cursor_y
    jsr cscroll
    rts
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zp($1f) buffer, word zp(7) value, word zp($1d) sub)
utoa_append: {
    .label buffer = $1f
    .label value = 7
    .label sub = $1d
    .label return = 7
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
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($c) str)
strlen: {
    .label len = $16
    .label str = $c
    .label return = $16
    lda #<0
    sta.z len
    sta.z len+1
    lda #<printf_number_buffer.buffer_digits
    sta.z str
    lda #>printf_number_buffer.buffer_digits
    sta.z str+1
  __b1:
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    rts
  __b2:
    inc.z len
    bne !+
    inc.z len+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Print a padding char a number of times
// printf_padding(byte zp($a) pad, byte zp($18) length)
printf_padding: {
    .label i = $b
    .label length = $18
    .label pad = $a
    lda #0
    sta.z i
  __b1:
    lda.z i
    cmp.z length
    bcc __b2
    rts
  __b2:
    ldy.z pad
    jsr cputc
    inc.z i
    jmp __b1
}
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    lda #$3c
    cmp.z conio_cursor_y
    bne __breturn
    lda #<DEFAULT_SCREEN
    sta.z memcpy.destination
    lda #>DEFAULT_SCREEN
    sta.z memcpy.destination+1
    lda #<DEFAULT_SCREEN+$50
    sta.z memcpy.source
    lda #>DEFAULT_SCREEN+$50
    sta.z memcpy.source+1
    jsr memcpy
    lda #<COLORRAM
    sta.z memcpy.destination
    lda #>COLORRAM
    sta.z memcpy.destination+1
    lda #<COLORRAM+$50
    sta.z memcpy.source
    lda #>COLORRAM+$50
    sta.z memcpy.source+1
    jsr memcpy
    ldx #' '
    lda #<DEFAULT_SCREEN+$3c*$50-$50
    sta.z memset.str
    lda #>DEFAULT_SCREEN+$3c*$50-$50
    sta.z memset.str+1
    jsr memset
    ldx.z conio_textcolor
    lda #<COLORRAM+$3c*$50-$50
    sta.z memset.str
    lda #>COLORRAM+$3c*$50-$50
    sta.z memset.str+1
    jsr memset
    sec
    lda.z conio_line_text
    sbc #$50
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #0
    sta.z conio_line_text+1
    dec.z conio_cursor_y
  __breturn:
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp($16) destination, void* zp($c) source)
memcpy: {
    .label src_end = $1f
    .label dst = $16
    .label src = $c
    .label source = $c
    .label destination = $16
    clc
    lda.z source
    adc #<$3c*$50-$50
    sta.z src_end
    lda.z source+1
    adc #>$3c*$50-$50
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
// memset(void* zp($16) str, byte register(X) c)
memset: {
    .label end = $1f
    .label dst = $16
    .label str = $16
    lda #$50
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
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  VERA_L1_CONFIG_WIDTH: .word $20, $40, $80, $100
  VERA_L1_CONFIG_HEIGHT: .word $20, $40, $80, $100
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
