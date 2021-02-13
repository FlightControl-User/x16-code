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
  // $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
  .label VERA_DC_HSCALE = $9f2a
  // $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
  .label VERA_DC_VSCALE = $9f2b
  // $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  // VRAM Address of the default screen
  .label DEFAULT_SCREEN = 0
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $1c
  // The current cursor y-position
  .label conio_cursor_y = $1d
  // The current text cursor line start
  .label conio_line_text = $1e
  // The current text color
  .label conio_textcolor = $20
  .label conio_backcolor = $21
  // Variable holding the screen width;
  .label conio_screen_width = $22
  // Variable holding the screen height;
  .label conio_screen_height = $23
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
    lda #0
    sta.z conio_screen_width
    sta.z conio_screen_height
    jsr conio_x16_init
    jsr main
    rts
}
// Set initial cursor position
conio_x16_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    ldx BASIC_CURSOR_LINE
    jsr screensize
    cpx.z conio_screen_height
    bcc __b1
    ldx.z conio_screen_height
    dex
  __b1:
    jsr gotoxy
    rts
}
main: {
    .label i = 2
    .label width = $10
    .label screensizey1_return = $24
    .label i1 = 4
    .label i2 = 6
    .label i3 = 8
    .label i4 = $a
    .label i5 = $c
    lda #BLUE
    jsr textcolor
    jsr backcolor
    jsr clrscr
    ldx #5
    jsr gotoxy
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    lda.z i+1
    bpl !__b2+
    jmp __b2
  !__b2:
    cmp #>5
    bcs !__b2+
    jmp __b2
  !__b2:
    bne !+
    lda.z i
    cmp #<5
    bcs !__b2+
    jmp __b2
  !__b2:
  !:
    ldx #$f
    jsr gotoxy
    lda #RED
    jsr textcolor
    lda.z conio_screen_width
    sta.z width
    lda #0
    sta.z width+1
    lda.z conio_screen_height
    sta.z screensizey1_return
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    jsr printf_uint
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    lda.z screensizey1_return
    sta.z printf_uint.uvalue
    lda #0
    sta.z printf_uint.uvalue+1
    jsr printf_uint
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    lda #BLUE
    jsr textcolor
    ldx #$14
    jsr gotoxy
    lda #<5
    sta.z i1
    lda #>5
    sta.z i1+1
  __b4:
    lda.z i1+1
    bpl !__b5+
    jmp __b5
  !__b5:
    cmp #>$a
    bcs !__b5+
    jmp __b5
  !__b5:
    bne !+
    lda.z i1
    cmp #<$a
    bcs !__b5+
    jmp __b5
  !__b5:
  !:
    lda #<0
    sta.z i2
    sta.z i2+1
  __b6:
    lda.z i2+1
    bpl !__b7+
    jmp __b7
  !__b7:
    cmp #>5
    bcs !__b7+
    jmp __b7
  !__b7:
    bne !+
    lda.z i2
    cmp #<5
    bcs !__b7+
    jmp __b7
  !__b7:
  !:
    lda #<0
    sta.z i3
    sta.z i3+1
  __b8:
    lda.z i3+1
    bmi __b9
    cmp #>5
    bcc __b9
    bne !+
    lda.z i3
    cmp #<5
    bcc __b9
  !:
    lda #<0
    sta.z i4
    sta.z i4+1
  __b10:
    lda.z i4+1
    bmi __b11
    cmp #>3
    bcc __b11
    bne !+
    lda.z i4
    cmp #<3
    bcc __b11
  !:
    ldx #$38
    jsr gotoxy
    lda #<$a
    sta.z i5
    lda #>$a
    sta.z i5+1
  __b13:
    lda.z i5+1
    bmi __b14
    cmp #>$64
    bcc __b14
    bne !+
    lda.z i5
    cmp #<$64
    bcc __b14
  !:
    rts
  __b14:
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    lda.z i5
    sta.z printf_sint.value
    lda.z i5+1
    sta.z printf_sint.value+1
    jsr printf_sint
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    inc.z i5
    bne !+
    inc.z i5+1
  !:
    jmp __b13
  __b11:
    ldx #$a
    jsr gotoxy
    jsr insertup
    inc.z i4
    bne !+
    inc.z i4+1
  !:
    jmp __b10
  __b9:
    ldx #$13
    jsr gotoxy
    jsr insertdown
    inc.z i3
    bne !+
    inc.z i3+1
  !:
    jmp __b8
  __b7:
    ldx #$15
    jsr gotoxy
    jsr insertdown
    inc.z i2
    bne !+
    inc.z i2+1
  !:
    jmp __b6
  __b5:
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    lda.z i1
    sta.z printf_sint.value
    lda.z i1+1
    sta.z printf_sint.value+1
    jsr printf_sint
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    inc.z i1
    bne !+
    inc.z i1+1
  !:
    jmp __b4
  __b2:
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    lda.z i
    sta.z printf_sint.value
    lda.z i+1
    sta.z printf_sint.value+1
    jsr printf_sint
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
  .segment Data
    s: .text "line "
    .byte 0
    s1: .text @" ......................................................................\n"
    .byte 0
    s2: .text "width = "
    .byte 0
    s3: .text "; height = "
    .byte 0
    s4: .text @"\n"
    .byte 0
}
.segment Code
// Return the current screen size.
screensize: {
    .label x = conio_screen_width
    .label y = conio_screen_height
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    tay
    lda #$28
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta.z x
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    tay
    lda #$1e
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta.z y
    rts
}
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .label __7 = $25
    .label line_offset = $25
    lda.z conio_screen_height
    stx.z $ff
    cmp.z $ff
    bcs __b1
    ldx #0
  __b1:
    lda.z conio_screen_width
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
    .label conio_width = $2a
    .label conio_height = $2c
    .label color = $27
    .label line_text = $e
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
// cputs(byte* zp($e) s)
cputs: {
    .label s = $e
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
// Print an unsigned int using a specific format
// printf_uint(word zp($10) uvalue)
printf_uint: {
    .label uvalue = $10
    // Handle any sign
    lda #0
    sta printf_buffer
  // Format number into buffer
    jsr utoa
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
  // Print using format
    lda #0
    sta.z printf_number_buffer.format_zero_padding
    tax
    jsr printf_number_buffer
    rts
}
// Print a signed integer using a specific format
// printf_sint(signed word zp($10) value)
printf_sint: {
    .label value = $10
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
  // Print using format
    lda #1
    sta.z printf_number_buffer.format_zero_padding
    ldx #2
    jsr printf_number_buffer
    rts
}
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label width = $29
    .label line = $17
    ldx.z conio_cursor_y
    lda.z conio_screen_width
    asl
    sta.z width
    ldy #1
  __b1:
    sty.z $ff
    cpx.z $ff
    bcs __b2
    jsr clearline
    rts
  __b2:
    tya
    sec
    sbc #1
    sta.z line+1
    lda #0
    sta.z line
    clc
    adc #<$100
    sta.z vram_to_vram.vget
    lda.z line+1
    adc #>$100
    sta.z vram_to_vram.vget+1
    lda.z width
    sta.z vram_to_vram.num
    lda #0
    sta.z vram_to_vram.num+1
    jsr vram_to_vram
    iny
    jmp __b1
}
// Insert a new line, and scroll the lower part of the screen down.
insertdown: {
    .label width = $28
    .label i = $12
    .label line = $15
    lda.z conio_screen_height
    sec
    sbc.z conio_cursor_y
    sec
    sbc #1
    sta.z i
    lda.z conio_screen_width
    asl
    sta.z width
  __b1:
    lda.z i
    bne __b2
    jsr clearline
    rts
  __b2:
    lda.z conio_cursor_y
    clc
    adc.z i
    sec
    sbc #1
    sta.z line+1
    lda #0
    sta.z line
    clc
    adc #<$100
    sta.z vram_to_vram.vput
    lda.z line+1
    adc #>$100
    sta.z vram_to_vram.vput+1
    lda.z width
    sta.z vram_to_vram.num
    lda #0
    sta.z vram_to_vram.num+1
    jsr vram_to_vram
    dec.z i
    jmp __b1
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte register(Y) c)
cputc: {
    .label __4 = $2a
    .label __6 = $2c
    .label color = $29
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
    lda.z conio_cursor_x
    cmp.z conio_screen_width
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
// utoa(word zp($10) value, byte* zp($15) buffer)
utoa: {
    .label digit_value = $2a
    .label buffer = $15
    .label digit = $12
    .label value = $10
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
// printf_number_buffer(byte zp($13) buffer_sign, byte register(X) format_min_length, byte zp($27) format_zero_padding)
printf_number_buffer: {
    .label __19 = $17
    .label buffer_sign = $13
    .label padding = $14
    .label format_zero_padding = $27
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
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s+1
    jsr cputs
    rts
}
clearline: {
    .label c = $15
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    lda.z conio_line_text
    // Set address
    sta VERA_ADDRX_L
    lda.z conio_line_text+1
    sta VERA_ADDRX_M
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    lda.z conio_backcolor
    asl
    asl
    asl
    asl
    ora.z conio_textcolor
    tax
    lda #<0
    sta.z c
    sta.z c+1
  __b1:
    lda.z c+1
    bne !+
    lda.z c
    cmp.z conio_screen_width
    bcc __b2
  !:
    rts
  __b2:
    // Set data
    lda #' '
    sta VERA_DATA0
    stx VERA_DATA0
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b1
}
// Copy block of memory (from RAM to VRAM)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - src: The source address in RAM
// - num: The number of bytes to copy
// vram_to_vram(word zp($2a) num, byte* zp($15) vget, byte* zp($17) vput)
vram_to_vram: {
    .label i = $2c
    .label num = $2a
    .label vput = $17
    .label vget = $15
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
    cmp.z num+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z num
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
// utoa_append(byte* zp($2c) buffer, word zp($10) value, word zp($2a) sub)
utoa_append: {
    .label buffer = $2c
    .label value = $10
    .label sub = $2a
    .label return = $10
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
// strlen(byte* zp($15) str)
strlen: {
    .label len = $17
    .label str = $15
    .label return = $17
    lda #<0
    sta.z len
    sta.z len+1
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
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
// printf_padding(byte zp($1a) pad, byte zp($19) length)
printf_padding: {
    .label i = $1b
    .label length = $19
    .label pad = $1a
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
    lda.z conio_cursor_y
    cmp.z conio_screen_height
    bcc __breturn
    jsr insertup
    ldx.z conio_screen_height
    dex
    jsr gotoxy
  __breturn:
    rts
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
