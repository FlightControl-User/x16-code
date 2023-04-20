  // File Comments
// sizeof bug demo
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="sizeof.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  // Global Constants & labels
  .const WHITE = 1
  .const BLUE = 6
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
  .const VERA_LAYER_WIDTH_128 = $20
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_64 = $40
  .const VERA_LAYER_HEIGHT_MASK = $c0
  .const VERA_LAYER_COLOR_DEPTH_MASK = 3
  .const VERA_LAYER_CONFIG_256C = 8
  .const VERA_TILEBASE_WIDTH_MASK = 1
  .const VERA_TILEBASE_HEIGHT_MASK = 2
  .const VERA_LAYER_TILEBASE_MASK = $fc
  .const OFFSET_STRUCT_CX16_CONIO_WIDTH = 4
  .const OFFSET_STRUCT_CX16_CONIO_HEIGHT = 5
  .const SIZEOF_STRUCT_ENTITY_S = $44
  .const SIZEOF_UNSIGNED_INT = 2
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET = 1
  .const OFFSET_STRUCT_CX16_CONIO_COLOR = $e
  .const OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT = 8
  .const OFFSET_STRUCT_CX16_CONIO_MAPWIDTH = 6
  .const OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK = 3
  .const OFFSET_STRUCT_CX16_CONIO_CURSOR_X = $f
  .const OFFSET_STRUCT_CX16_CONIO_CURSOR_Y = $11
  .const OFFSET_STRUCT_CX16_CONIO_LINE = $13
  .const OFFSET_STRUCT_CX16_CONIO_ROWSKIP = $b
  .const OFFSET_STRUCT_CX16_CONIO_ROWSHIFT = $a
  .const OFFSET_STRUCT_CX16_CONIO_SCROLL = $17
  .const OFFSET_STRUCT_CX16_CONIO_CURSOR = $d
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_CX16_CONIO = $19
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
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
  /// $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  /// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  /// $9F36	L1_TILEBASE	    Layer 1 Tile Base
  /// Bit 2-7: Tile Base Address (16:11)
  /// Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  /// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L1_TILEBASE = $9f36
.segment Code
  // __start
__start: {
    // [1] phi from __start to __start::__init1 [phi:__start->__start::__init1]
    // __start::__init1
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [2] call conio_x16_init
    jsr conio_x16_init
    // [3] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [4] call main
    // [55] phi from __start::@1 to main [phi:__start::@1->main]
    jsr main
    // __start::@return
    // [5] return 
    rts
}
  // conio_x16_init
// Set initial cursor position
conio_x16_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label line = $3e
    // char line = *BASIC_CURSOR_LINE
    // [6] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda.z BASIC_CURSOR_LINE
    sta.z line
    // vera_layer1_mode_text(
    //         0, (unsigned int)0x0000, 
    //         0, (unsigned int)0xF800, 
    //         VERA_LAYER_WIDTH_128, VERA_LAYER_HEIGHT_64, 
    //         VERA_TILEBASE_WIDTH_8, VERA_TILEBASE_HEIGHT_8, 
    //         VERA_LAYER_CONFIG_16C 
    //     )
    // [7] call vera_layer1_mode_text
    // [66] phi from conio_x16_init to vera_layer1_mode_text [phi:conio_x16_init->vera_layer1_mode_text]
    jsr vera_layer1_mode_text
    // [8] phi from conio_x16_init to conio_x16_init::@3 [phi:conio_x16_init->conio_x16_init::@3]
    // conio_x16_init::@3
    // screensize(&__conio.width, &__conio.height)
    // [9] call screensize
    jsr screensize
    // [10] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // screenlayer1()
    // [11] call screenlayer1
    // TODO, this should become a ROM call for the CX16.
    jsr screenlayer1
    // [12] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // textcolor(WHITE)
    // [13] call textcolor
    jsr textcolor
    // [14] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // bgcolor(BLUE)
    // [15] call bgcolor
    jsr bgcolor
    // [16] phi from conio_x16_init::@6 to conio_x16_init::@7 [phi:conio_x16_init::@6->conio_x16_init::@7]
    // conio_x16_init::@7
    // cursor(0)
    // [17] call cursor
    jsr cursor
    // conio_x16_init::@8
    // if(line>=__conio.height)
    // [18] if(conio_x16_init::line#0<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto conio_x16_init::@1 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z line
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    bcc __b1
    // conio_x16_init::@2
    // line=__conio.height-1
    // [19] conio_x16_init::line#1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    dex
    stx.z line
    // [20] phi from conio_x16_init::@2 conio_x16_init::@8 to conio_x16_init::@1 [phi:conio_x16_init::@2/conio_x16_init::@8->conio_x16_init::@1]
    // [20] phi conio_x16_init::line#3 = conio_x16_init::line#1 [phi:conio_x16_init::@2/conio_x16_init::@8->conio_x16_init::@1#0] -- register_copy 
    // conio_x16_init::@1
  __b1:
    // gotoxy(0, line)
    // [21] gotoxy::y#1 = conio_x16_init::line#3 -- vbuz1=vbuz2 
    lda.z line
    sta.z gotoxy.y
    // [22] call gotoxy
    // [108] phi from conio_x16_init::@1 to gotoxy [phi:conio_x16_init::@1->gotoxy]
    // [108] phi gotoxy::y#4 = gotoxy::y#1 [phi:conio_x16_init::@1->gotoxy#0] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [23] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__zp($e) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    .label __1 = $22
    .label __3 = $23
    .label __4 = $24
    .label __5 = $25
    .label __14 = $21
    .label __15 = $27
    .label c = $e
    .label color = $2f
    .label mapbase_offset = 2
    .label mapwidth = $30
    .label conio_addr = 2
    .label scroll_enable = $26
    // [24] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbuz1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta.z c
    // char color = __conio.color
    // [25] cputc::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z color
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [26] cputc::mapbase_offset#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z mapbase_offset
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z mapbase_offset+1
    // unsigned int mapwidth = __conio.mapwidth
    // [27] cputc::mapwidth#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    sta.z mapwidth
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    sta.z mapwidth+1
    // unsigned int conio_addr = mapbase_offset + __conio.line[__conio.layer]
    // [28] cputc::$14 = *((char *)&__conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __conio
    asl
    sta.z __14
    // [29] cputc::conio_addr#0 = cputc::mapbase_offset#0 + ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE)[cputc::$14] -- vwuz1=vwuz1_plus_pwuc1_derefidx_vbuz2 
    tay
    clc
    lda.z conio_addr
    adc __conio+OFFSET_STRUCT_CX16_CONIO_LINE,y
    sta.z conio_addr
    lda.z conio_addr+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1,y
    sta.z conio_addr+1
    // __conio.cursor_x[__conio.layer] << 1
    // [30] cputc::$1 = ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X)[*((char *)&__conio)] << 1 -- vbuz1=pbuc1_derefidx_(_deref_pbuc2)_rol_1 
    ldy __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X,y
    asl
    sta.z __1
    // conio_addr += __conio.cursor_x[__conio.layer] << 1
    // [31] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$1 -- vwuz1=vwuz1_plus_vbuz2 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [32] if(cputc::c#0==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [33] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(conio_addr)
    // [34] cputc::$3 = byte0  cputc::conio_addr#1 -- vbuz1=_byte0_vwuz2 
    lda.z conio_addr
    sta.z __3
    // *VERA_ADDRX_L = BYTE0(conio_addr)
    // [35] *VERA_ADDRX_L = cputc::$3 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(conio_addr)
    // [36] cputc::$4 = byte1  cputc::conio_addr#1 -- vbuz1=_byte1_vwuz2 
    lda.z conio_addr+1
    sta.z __4
    // *VERA_ADDRX_M = BYTE1(conio_addr)
    // [37] *VERA_ADDRX_M = cputc::$4 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [38] cputc::$5 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    sta.z __5
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [39] *VERA_ADDRX_H = cputc::$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [40] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [41] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // __conio.cursor_x[__conio.layer]++;
    // [42] ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X)[*((char *)&__conio)] = ++ ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X)[*((char *)&__conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X,x
    inc
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X,x
    // unsigned char scroll_enable = __conio.scroll[__conio.layer]
    // [43] cputc::scroll_enable#0 = ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_SCROLL)[*((char *)&__conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_SCROLL,y
    sta.z scroll_enable
    // if(scroll_enable)
    // [44] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuz1_then_la1 
    bne __b5
    // cputc::@3
    // (unsigned int)__conio.cursor_x[__conio.layer] == mapwidth
    // [45] cputc::$15 = (unsigned int)((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X)[*((char *)&__conio)] -- vwuz1=_word_pbuc1_derefidx_(_deref_pbuc2) 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X,y
    sta.z __15
    lda #0
    sta.z __15+1
    // if((unsigned int)__conio.cursor_x[__conio.layer] == mapwidth)
    // [46] if(cputc::$15!=cputc::mapwidth#0) goto cputc::@return -- vwuz1_neq_vwuz2_then_la1 
    cmp.z mapwidth+1
    bne __breturn
    lda.z __15
    cmp.z mapwidth
    bne __breturn
    // [47] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [48] call cputln
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [49] return 
    rts
    // cputc::@5
  __b5:
    // if(__conio.cursor_x[__conio.layer] == __conio.width)
    // [50] if(((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X)[*((char *)&__conio)]!=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto cputc::@return -- pbuc1_derefidx_(_deref_pbuc2)_neq__deref_pbuc3_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    ldy __conio
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X,y
    bne __breturn
    // [51] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [52] call cputln
    jsr cputln
    rts
    // [53] phi from cputc to cputc::@1 [phi:cputc->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [54] call cputln
    jsr cputln
    rts
}
  // main
main: {
    // clrscr()
    // [56] call clrscr
    jsr clrscr
    // [57] phi from main to main::@1 [phi:main->main::@1]
    // main::@1
    // gotoxy(0,30)
    // [58] call gotoxy
    // [108] phi from main::@1 to gotoxy [phi:main::@1->gotoxy]
    // [108] phi gotoxy::y#4 = $1e [phi:main::@1->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1e
    sta.z gotoxy.y
    jsr gotoxy
    // [59] phi from main::@1 to main::@2 [phi:main::@1->main::@2]
    // main::@2
    // printf("%u\n", sizeof(entity_t))
    // [60] call printf_uchar
    // [155] phi from main::@2 to printf_uchar [phi:main::@2->printf_uchar]
    jsr printf_uchar
    // [61] phi from main::@2 to main::@3 [phi:main::@2->main::@3]
    // main::@3
    // printf("%u\n", sizeof(entity_t))
    // [62] call printf_str
    // [161] phi from main::@3 to printf_str [phi:main::@3->printf_str]
    // [161] phi printf_str::putc#5 = &cputc [phi:main::@3->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [161] phi printf_str::s#5 = main::s [phi:main::@3->printf_str#1] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // [63] phi from main::@3 to main::@4 [phi:main::@3->main::@4]
    // main::@4
    // printf("shouldn't this be 79?\n")
    // [64] call printf_str
    // [161] phi from main::@4 to printf_str [phi:main::@4->printf_str]
    // [161] phi printf_str::putc#5 = &cputc [phi:main::@4->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [161] phi printf_str::s#5 = main::s1 [phi:main::@4->printf_str#1] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // main::@return
    // }
    // [65] return 
    rts
  .segment Data
    s: .text @"\n"
    .byte 0
    s1: .text @"shouldn't this be 79?\n"
    .byte 0
}
.segment Code
  // vera_layer1_mode_text
// void vera_layer1_mode_text(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char color_mode)
vera_layer1_mode_text: {
    .label mapbase_bank = 0
    .label mapbase_offset = 0
    .label tilebase_bank = 0
    .label tilebase_offset = $f800
    // vera_layer1_mode_tile( mapbase_bank, mapbase_offset, tilebase_bank, tilebase_offset, mapwidth, mapheight, tilewidth, tileheight, VERA_LAYER_COLOR_DEPTH_1BPP)
    // [67] call vera_layer1_mode_tile
    // [170] phi from vera_layer1_mode_text to vera_layer1_mode_tile [phi:vera_layer1_mode_text->vera_layer1_mode_tile]
    jsr vera_layer1_mode_tile
    // [68] phi from vera_layer1_mode_text to vera_layer1_mode_text::@1 [phi:vera_layer1_mode_text->vera_layer1_mode_text::@1]
    // vera_layer1_mode_text::@1
    // vera_layer1_set_text_color_mode( color_mode )
    // [69] call vera_layer1_set_text_color_mode
    jsr vera_layer1_set_text_color_mode
    // vera_layer1_mode_text::@return
    // }
    // [70] return 
    rts
}
  // screensize
// Return the current screen size.
// void screensize(char *x, char *y)
screensize: {
    .label x = __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    .label y = __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    .label __1 = $34
    .label __3 = $32
    .label hscale = $34
    .label vscale = $32
    // char hscale = (*VERA_DC_HSCALE) >> 7
    // [71] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    // VERA returns in VERA_DC_HSCALE the value of 128 when 80 columns is used in text mode,
    // and the value of 64 when 40 columns is used in text mode.
    // Basically, 40 columns mode in the VERA is a double scan mode.
    // Same for the VERA_DC_VSCALE mode, but then the subdivision is 60 or 30 rows.
    // I still need to test the other modes, but this will suffice for now for the pure text modes.
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    sta.z hscale
    // 40 << hscale
    // [72] screensize::$1 = $28 << screensize::hscale#0 -- vbuz1=vbuc1_rol_vbuz1 
    lda #$28
    ldy.z __1
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta.z __1
    // *x = 40 << hscale
    // [73] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbuz1 
    sta x
    // char vscale = (*VERA_DC_VSCALE) >> 7
    // [74] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    sta.z vscale
    // 30 << vscale
    // [75] screensize::$3 = $1e << screensize::vscale#0 -- vbuz1=vbuc1_rol_vbuz1 
    lda #$1e
    ldy.z __3
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta.z __3
    // *y = 30 << vscale
    // [76] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbuz1 
    sta y
    // screensize::@return
    // }
    // [77] return 
    rts
}
  // screenlayer1
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer1: {
    .label vera_layer1_get_width1___0 = $32
    .label vera_layer1_get_width1___1 = $32
    .label vera_layer1_get_width1___2 = $32
    .label vera_layer1_get_height1___0 = $33
    .label vera_layer1_get_height1___1 = $33
    .label vera_layer1_get_height1___2 = $33
    .label vera_layer1_get_mapbase_bank1_return = $34
    .label vera_layer1_get_mapbase_offset1_return = $36
    .label vera_layer1_get_width1_return = $38
    .label vera_layer1_get_height1_return = $3a
    .label vera_layer1_get_rowshift1_return = $35
    .label vera_layer1_get_rowskip1_return = $3c
    // __conio.layer = 1
    // [78] *((char *)&__conio) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta __conio
    // screenlayer1::vera_layer1_get_mapbase_bank1
    // return vera_mapbase_bank[1];
    // [79] screenlayer1::vera_layer1_get_mapbase_bank1_return#0 = *(vera_mapbase_bank+1) -- vbuz1=_deref_pbuc1 
    lda vera_mapbase_bank+1
    sta.z vera_layer1_get_mapbase_bank1_return
    // screenlayer1::@1
    // __conio.mapbase_bank = vera_layer1_get_mapbase_bank()
    // [80] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) = screenlayer1::vera_layer1_get_mapbase_bank1_return#0 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    // screenlayer1::vera_layer1_get_mapbase_offset1
    // return vera_mapbase_offset[1];
    // [81] screenlayer1::vera_layer1_get_mapbase_offset1_return#0 = *(vera_mapbase_offset+1*SIZEOF_UNSIGNED_INT) -- vwuz1=_deref_pwuc1 
    lda vera_mapbase_offset+1*SIZEOF_UNSIGNED_INT
    sta.z vera_layer1_get_mapbase_offset1_return
    lda vera_mapbase_offset+1*SIZEOF_UNSIGNED_INT+1
    sta.z vera_layer1_get_mapbase_offset1_return+1
    // screenlayer1::@2
    // __conio.mapbase_offset = vera_layer1_get_mapbase_offset()
    // [82] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) = screenlayer1::vera_layer1_get_mapbase_offset1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer1_get_mapbase_offset1_return
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    lda.z vera_layer1_get_mapbase_offset1_return+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    // screenlayer1::vera_layer1_get_width1
    // *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK
    // [83] screenlayer1::vera_layer1_get_width1_$0 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta.z vera_layer1_get_width1___0
    // (*VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4
    // [84] screenlayer1::vera_layer1_get_width1_$1 = screenlayer1::vera_layer1_get_width1_$0 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z vera_layer1_get_width1___1
    lsr
    lsr
    lsr
    lsr
    sta.z vera_layer1_get_width1___1
    // return VERA_LAYER_WIDTH[ (*VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4];
    // [85] screenlayer1::vera_layer1_get_width1_$2 = screenlayer1::vera_layer1_get_width1_$1 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z vera_layer1_get_width1___2
    // [86] screenlayer1::vera_layer1_get_width1_return#0 = VERA_LAYER_WIDTH[screenlayer1::vera_layer1_get_width1_$2] -- vwuz1=pwuc1_derefidx_vbuz2 
    ldy.z vera_layer1_get_width1___2
    lda VERA_LAYER_WIDTH,y
    sta.z vera_layer1_get_width1_return
    lda VERA_LAYER_WIDTH+1,y
    sta.z vera_layer1_get_width1_return+1
    // screenlayer1::@3
    // __conio.mapwidth = vera_layer1_get_width()
    // [87] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) = screenlayer1::vera_layer1_get_width1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer1_get_width1_return
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    lda.z vera_layer1_get_width1_return+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    // screenlayer1::vera_layer1_get_height1
    // *VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK
    // [88] screenlayer1::vera_layer1_get_height1_$0 = *VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK
    and VERA_L1_CONFIG
    sta.z vera_layer1_get_height1___0
    // (*VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6
    // [89] screenlayer1::vera_layer1_get_height1_$1 = screenlayer1::vera_layer1_get_height1_$0 >> 6 -- vbuz1=vbuz1_ror_6 
    lda.z vera_layer1_get_height1___1
    rol
    rol
    rol
    and #3
    sta.z vera_layer1_get_height1___1
    // return VERA_LAYER_HEIGHT[ (*VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6];
    // [90] screenlayer1::vera_layer1_get_height1_$2 = screenlayer1::vera_layer1_get_height1_$1 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z vera_layer1_get_height1___2
    // [91] screenlayer1::vera_layer1_get_height1_return#0 = VERA_LAYER_HEIGHT[screenlayer1::vera_layer1_get_height1_$2] -- vwuz1=pwuc1_derefidx_vbuz2 
    ldy.z vera_layer1_get_height1___2
    lda VERA_LAYER_HEIGHT,y
    sta.z vera_layer1_get_height1_return
    lda VERA_LAYER_HEIGHT+1,y
    sta.z vera_layer1_get_height1_return+1
    // screenlayer1::@4
    // __conio.mapheight = vera_layer1_get_height()
    // [92] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT) = screenlayer1::vera_layer1_get_height1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer1_get_height1_return
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT
    lda.z vera_layer1_get_height1_return+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT+1
    // screenlayer1::vera_layer1_get_rowshift1
    // return vera_layer_rowshift[1];
    // [93] screenlayer1::vera_layer1_get_rowshift1_return#0 = *(vera_layer_rowshift+1) -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift+1
    sta.z vera_layer1_get_rowshift1_return
    // screenlayer1::@5
    // __conio.rowshift = vera_layer1_get_rowshift()
    // [94] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) = screenlayer1::vera_layer1_get_rowshift1_return#0 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    // screenlayer1::vera_layer1_get_rowskip1
    // return vera_layer_rowskip[1];
    // [95] screenlayer1::vera_layer1_get_rowskip1_return#0 = *(vera_layer_rowskip+1*SIZEOF_UNSIGNED_INT) -- vwuz1=_deref_pwuc1 
    lda vera_layer_rowskip+1*SIZEOF_UNSIGNED_INT
    sta.z vera_layer1_get_rowskip1_return
    lda vera_layer_rowskip+1*SIZEOF_UNSIGNED_INT+1
    sta.z vera_layer1_get_rowskip1_return+1
    // screenlayer1::@6
    // __conio.rowskip = vera_layer1_get_rowskip()
    // [96] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) = screenlayer1::vera_layer1_get_rowskip1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer1_get_rowskip1_return
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    lda.z vera_layer1_get_rowskip1_return+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    // screenlayer1::@return
    // }
    // [97] return 
    rts
}
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char textcolor(char color)
textcolor: {
    .label __0 = $33
    .label __1 = $33
    // __conio.color & 0xF0
    // [98] textcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) & $f0 -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z __0
    // __conio.color & 0xF0 | color
    // [99] textcolor::$1 = textcolor::$0 | WHITE -- vbuz1=vbuz1_bor_vbuc1 
    lda #WHITE
    ora.z __1
    sta.z __1
    // __conio.color = __conio.color & 0xF0 | color
    // [100] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) = textcolor::$1 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    // textcolor::@return
    // }
    // [101] return 
    rts
}
  // bgcolor
// Set the back color for text output. The old back text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor(char color)
bgcolor: {
    .label __0 = $35
    .label __2 = $35
    // __conio.color & 0x0F
    // [102] bgcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) & $f -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #$f
    and __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z __0
    // __conio.color & 0x0F | color << 4
    // [103] bgcolor::$2 = bgcolor::$0 | BLUE<<4 -- vbuz1=vbuz1_bor_vbuc1 
    lda #BLUE<<4
    ora.z __2
    sta.z __2
    // __conio.color = __conio.color & 0x0F | color << 4
    // [104] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) = bgcolor::$2 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    // bgcolor::@return
    // }
    // [105] return 
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
    // [106] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR
    // cursor::@return
    // }
    // [107] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(char x, __zp($15) char y)
gotoxy: {
    .label __5 = $14
    .label __6 = $10
    .label line_offset = $10
    .label y = $15
    // if(y>__conio.height)
    // [109] if(gotoxy::y#4<=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto gotoxy::@4 -- vbuz1_le__deref_pbuc1_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    cmp.z y
    bcs __b1
    // [111] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [111] phi gotoxy::y#5 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z y
    // [110] phi from gotoxy to gotoxy::@4 [phi:gotoxy->gotoxy::@4]
    // gotoxy::@4
    // [111] phi from gotoxy::@4 to gotoxy::@1 [phi:gotoxy::@4->gotoxy::@1]
    // [111] phi gotoxy::y#5 = gotoxy::y#4 [phi:gotoxy::@4->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=__conio.width)
    // [112] if(0<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto gotoxy::@2 -- 0_lt__deref_pbuc1_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    // [113] phi from gotoxy::@1 to gotoxy::@3 [phi:gotoxy::@1->gotoxy::@3]
    // gotoxy::@3
    // gotoxy::@2
    // __conio.cursor_x[__conio.layer] = x
    // [114] ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X)[*((char *)&__conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy __conio
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X,y
    // __conio.cursor_y[__conio.layer] = y
    // [115] ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)[*((char *)&__conio)] = gotoxy::y#5 -- pbuc1_derefidx_(_deref_pbuc2)=vbuz1 
    lda.z y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y,y
    // unsigned int line_offset = (unsigned int)y << __conio.rowshift
    // [116] gotoxy::$6 = (unsigned int)gotoxy::y#5 -- vwuz1=_word_vbuz2 
    sta.z __6
    lda #0
    sta.z __6+1
    // [117] gotoxy::line_offset#0 = gotoxy::$6 << *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) -- vwuz1=vwuz1_rol__deref_pbuc1 
    ldy __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    beq !e+
  !:
    asl.z line_offset
    rol.z line_offset+1
    dey
    bne !-
  !e:
    // __conio.line[__conio.layer] = line_offset
    // [118] gotoxy::$5 = *((char *)&__conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __conio
    asl
    sta.z __5
    // [119] ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE)[gotoxy::$5] = gotoxy::line_offset#0 -- pwuc1_derefidx_vbuz1=vwuz2 
    tay
    lda.z line_offset
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE,y
    lda.z line_offset+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1,y
    // gotoxy::@return
    // }
    // [120] return 
    rts
}
  // cputln
// Print a newline
cputln: {
    .label __2 = $1d
    .label __3 = $1e
    .label temp = $1b
    // unsigned int temp = __conio.line[__conio.layer]
    // [121] cputln::$2 = *((char *)&__conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __conio
    asl
    sta.z __2
    // [122] cputln::temp#0 = ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE)[cputln::$2] -- vwuz1=pwuc1_derefidx_vbuz2 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE,y
    sta.z temp
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1,y
    sta.z temp+1
    // temp += __conio.rowskip
    // [123] cputln::temp#1 = cputln::temp#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z temp
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta.z temp
    lda.z temp+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta.z temp+1
    // __conio.line[__conio.layer] = temp
    // [124] cputln::$3 = *((char *)&__conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __conio
    asl
    sta.z __3
    // [125] ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE)[cputln::$3] = cputln::temp#1 -- pwuc1_derefidx_vbuz1=vwuz2 
    tay
    lda.z temp
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE,y
    lda.z temp+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1,y
    // __conio.cursor_x[__conio.layer] = 0
    // [126] ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X)[*((char *)&__conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy __conio
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X,y
    // __conio.cursor_y[__conio.layer]++;
    // [127] ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)[*((char *)&__conio)] = ++ ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)[*((char *)&__conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y,x
    inc
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y,x
    // cscroll()
    // [128] call cscroll
    jsr cscroll
    // cputln::@return
    // }
    // [129] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __1 = $2c
    .label __2 = $1f
    .label __3 = $18
    .label __5 = $13
    .label line_text = $2d
    .label color = $29
    .label mapheight = $2a
    .label mapwidth = $19
    .label c = $12
    .label l = $20
    // unsigned int line_text = __conio.mapbase_offset
    // [130] clrscr::line_text#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z line_text
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z line_text+1
    // char color = __conio.color
    // [131] clrscr::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z color
    // unsigned int mapheight = __conio.mapheight
    // [132] clrscr::mapheight#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT
    sta.z mapheight
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT+1
    sta.z mapheight+1
    // unsigned int mapwidth = __conio.mapwidth
    // [133] clrscr::mapwidth#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    sta.z mapwidth
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    sta.z mapwidth+1
    // [134] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [134] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr->clrscr::@1#0] -- register_copy 
    // [134] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<mapheight; l++ )
    // [135] if(clrscr::l#2<clrscr::mapheight#0) goto clrscr::@2 -- vbuz1_lt_vwuz2_then_la1 
    lda.z mapheight+1
    bne __b2
    lda.z l
    cmp.z mapheight
    bcc __b2
    // clrscr::@3
    // __conio.cursor_x[__conio.layer] = 0
    // [136] ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X)[*((char *)&__conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy __conio
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X,y
    // __conio.cursor_y[__conio.layer] = 0
    // [137] ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)[*((char *)&__conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y,y
    // __conio.line[__conio.layer] = 0
    // [138] clrscr::$5 = *((char *)&__conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    tya
    asl
    sta.z __5
    // [139] ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE)[clrscr::$5] = 0 -- pwuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z __5
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1,y
    // clrscr::@return
    // }
    // [140] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [141] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(ch)
    // [142] clrscr::$1 = byte0  clrscr::line_text#2 -- vbuz1=_byte0_vwuz2 
    lda.z line_text
    sta.z __1
    // *VERA_ADDRX_L = BYTE0(ch)
    // [143] *VERA_ADDRX_L = clrscr::$1 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(ch)
    // [144] clrscr::$2 = byte1  clrscr::line_text#2 -- vbuz1=_byte1_vwuz2 
    lda.z line_text+1
    sta.z __2
    // *VERA_ADDRX_M = BYTE1(ch)
    // [145] *VERA_ADDRX_M = clrscr::$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [146] clrscr::$3 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    sta.z __3
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [147] *VERA_ADDRX_H = clrscr::$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [148] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [148] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@4
  __b4:
    // for( char c=0;c<mapwidth; c++ )
    // [149] if(clrscr::c#2<clrscr::mapwidth#0) goto clrscr::@5 -- vbuz1_lt_vwuz2_then_la1 
    lda.z mapwidth+1
    bne __b5
    lda.z c
    cmp.z mapwidth
    bcc __b5
    // clrscr::@6
    // line_text += __conio.rowskip
    // [150] clrscr::line_text#1 = clrscr::line_text#2 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z line_text
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta.z line_text
    lda.z line_text+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta.z line_text+1
    // for( char l=0;l<mapheight; l++ )
    // [151] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [134] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [134] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [134] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [152] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [153] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<mapwidth; c++ )
    // [154] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [148] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [148] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
}
  // printf_uchar
// Print an unsigned char using a specific format
// void printf_uchar(void (*putc)(char), char uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_uchar: {
    .label putc = cputc
    // printf_uchar::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [156] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    // [157] call uctoa
  // Format number into buffer
    // [205] phi from printf_uchar::@1 to uctoa [phi:printf_uchar::@1->uctoa]
    jsr uctoa
    // printf_uchar::@2
    // printf_number_buffer(putc, printf_buffer, format)
    // [158] printf_number_buffer::buffer_sign#0 = *((char *)&printf_buffer) -- vbuz1=_deref_pbuc1 
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
    // [159] call printf_number_buffer
  // Print using format
    // [224] phi from printf_uchar::@2 to printf_number_buffer [phi:printf_uchar::@2->printf_number_buffer]
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [160] return 
    rts
}
  // printf_str
/// Print a NUL-terminated string
// void printf_str(__zp($2d) void (*putc)(char), __zp($19) const char *s)
printf_str: {
    .label c = $1f
    .label s = $19
    .label putc = $2d
    // [162] phi from printf_str printf_str::@2 to printf_str::@1 [phi:printf_str/printf_str::@2->printf_str::@1]
    // [162] phi printf_str::s#4 = printf_str::s#5 [phi:printf_str/printf_str::@2->printf_str::@1#0] -- register_copy 
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [163] printf_str::c#1 = *printf_str::s#4 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta.z c
    // [164] printf_str::s#0 = ++ printf_str::s#4 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [165] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbuz1_then_la1 
    lda.z c
    bne __b2
    // printf_str::@return
    // }
    // [166] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [167] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbuz1 
    lda.z c
    pha
    // [168] callexecute *printf_str::putc#5  -- call__deref_pprz1 
    jsr icall1
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
    // Outside Flow
  icall1:
    jmp (putc)
}
  // vera_layer1_mode_tile
// void vera_layer1_mode_tile(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char bpp)
vera_layer1_mode_tile: {
    .const vera_layer1_set_width1_index = VERA_LAYER_WIDTH_128>>4
    // vera_layer1_mode_tile::vera_layer1_set_color_depth1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK
    // [171] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_COLOR_DEPTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= bpp
    // [172] *VERA_L1_CONFIG = *VERA_L1_CONFIG -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_width1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_WIDTH_MASK
    // [173] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= mapwidth
    // [174] *VERA_L1_CONFIG = *VERA_L1_CONFIG | VERA_LAYER_WIDTH_128 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_WIDTH_128
    ora VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // vera_layer_rowshift[1] = 6+index
    // [175] *(vera_layer_rowshift+1) = 6+vera_layer1_mode_tile::vera_layer1_set_width1_index#0 -- _deref_pbuc1=vbuc2 
    lda #6+vera_layer1_set_width1_index
    sta vera_layer_rowshift+1
    // vera_layer_rowskip[1] = skip[index]
    // [176] *(vera_layer_rowskip+1*SIZEOF_UNSIGNED_INT) = *(skip+vera_layer1_mode_tile::vera_layer1_set_width1_index#0*SIZEOF_UNSIGNED_INT) -- _deref_pwuc1=_deref_pwuc2 
    lda skip+vera_layer1_set_width1_index*SIZEOF_UNSIGNED_INT
    sta vera_layer_rowskip+1*SIZEOF_UNSIGNED_INT
    lda skip+vera_layer1_set_width1_index*SIZEOF_UNSIGNED_INT+1
    sta vera_layer_rowskip+1*SIZEOF_UNSIGNED_INT+1
    // vera_layer1_mode_tile::vera_layer1_set_height1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_HEIGHT_MASK
    // [177] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= mapheight
    // [178] *VERA_L1_CONFIG = *VERA_L1_CONFIG | VERA_LAYER_HEIGHT_64 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_HEIGHT_64
    ora VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::@1
    // vera_mapbase_offset[1] = mapbase_offset
    // [179] *(vera_mapbase_offset+1*SIZEOF_UNSIGNED_INT) = vera_layer1_mode_text::mapbase_offset#0 -- _deref_pwuc1=vwuc2 
    // mapbase
    lda #<vera_layer1_mode_text.mapbase_offset
    sta vera_mapbase_offset+1*SIZEOF_UNSIGNED_INT
    lda #>vera_layer1_mode_text.mapbase_offset
    sta vera_mapbase_offset+1*SIZEOF_UNSIGNED_INT+1
    // vera_mapbase_bank[1] = mapbase_bank
    // [180] *(vera_mapbase_bank+1) = vera_layer1_mode_text::mapbase_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_layer1_mode_text.mapbase_bank
    sta vera_mapbase_bank+1
    // vera_layer1_mode_tile::vera_layer1_set_mapbase1
    // *VERA_L1_MAPBASE = (mapbase_bank<<7) | (BYTE1(mapbase_offset)>>1)
    // [181] *VERA_L1_MAPBASE = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta VERA_L1_MAPBASE
    // vera_layer1_mode_tile::@2
    // vera_tilebase_offset[1] = tilebase_offset
    // [182] *(vera_tilebase_offset+1*SIZEOF_UNSIGNED_INT) = vera_layer1_mode_text::tilebase_offset#0 -- _deref_pwuc1=vwuc2 
    // tilebase
    lda #<vera_layer1_mode_text.tilebase_offset
    sta vera_tilebase_offset+1*SIZEOF_UNSIGNED_INT
    lda #>vera_layer1_mode_text.tilebase_offset
    sta vera_tilebase_offset+1*SIZEOF_UNSIGNED_INT+1
    // vera_tilebase_bank[1] = tilebase_bank
    // [183] *(vera_tilebase_bank+1) = vera_layer1_mode_text::tilebase_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_layer1_mode_text.tilebase_bank
    sta vera_tilebase_bank+1
    // vera_layer1_mode_tile::vera_layer1_set_tilebase1
    // *VERA_L1_TILEBASE &= ~VERA_LAYER_TILEBASE_MASK
    // [184] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_LAYER_TILEBASE_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_TILEBASE_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= ((tilebase_bank << 7) | BYTE1(tilebase_offset)>>1)
    // [185] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE | byte1 vera_layer1_mode_text::tilebase_offset#0>>1 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #(>vera_layer1_mode_text.tilebase_offset)>>1
    ora VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::vera_layer1_set_tile_width1
    // *VERA_L1_TILEBASE &= ~VERA_TILEBASE_WIDTH_MASK
    // [186] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_TILEBASE_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_WIDTH_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= tilewidth
    // [187] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::vera_layer1_set_tile_height1
    // *VERA_L1_TILEBASE &= ~VERA_TILEBASE_HEIGHT_MASK
    // [188] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_TILEBASE_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_HEIGHT_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= tileheight
    // [189] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::@return
    // }
    // [190] return 
    rts
}
  // vera_layer1_set_text_color_mode
// void vera_layer1_set_text_color_mode(char color_mode)
vera_layer1_set_text_color_mode: {
    // *VERA_L1_CONFIG &= ~VERA_LAYER_CONFIG_256C
    // [191] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_CONFIG_256C -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_CONFIG_256C^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= color_mode
    // [192] *VERA_L1_CONFIG = *VERA_L1_CONFIG -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_CONFIG
    // vera_layer1_set_text_color_mode::@return
    // }
    // [193] return 
    rts
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(__conio.cursor_y[__conio.layer]>=__conio.height)
    // [194] if(((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)[*((char *)&__conio)]<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    ldy __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y,y
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    bcc __b3
    // cscroll::@1
    // if(__conio.scroll[__conio.layer])
    // [195] if(0!=((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_SCROLL)[*((char *)&__conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_SCROLL,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(__conio.cursor_y[__conio.layer]>=__conio.height)
    // [196] if(((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)[*((char *)&__conio)]<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y,y
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    // [197] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
  __b3:
    // cscroll::@return
    // }
    // [198] return 
    rts
    // [199] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [200] call insertup
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, __conio.height-1)
    // [201] gotoxy::y#2 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    dex
    stx.z gotoxy.y
    // [202] call gotoxy
    // [108] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [108] phi gotoxy::y#4 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    jsr gotoxy
    // [203] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [204] call clearline
    jsr clearline
    rts
}
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void uctoa(__zp($12) char value, __zp($19) char *buffer, char radix)
uctoa: {
    .const max_digits = 3
    .label digit_value = $18
    .label buffer = $19
    .label digit = $20
    .label value = $12
    .label started = $29
    // [206] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
    // [206] phi uctoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:uctoa->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [206] phi uctoa::started#2 = 0 [phi:uctoa->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z started
    // [206] phi uctoa::value#2 = SIZEOF_STRUCT_ENTITY_S [phi:uctoa->uctoa::@1#2] -- vbuz1=vbuc1 
    lda #SIZEOF_STRUCT_ENTITY_S
    sta.z value
    // [206] phi uctoa::digit#2 = 0 [phi:uctoa->uctoa::@1#3] -- vbuz1=vbuc1 
    lda #0
    sta.z digit
    // uctoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [207] if(uctoa::digit#2<uctoa::max_digits#1-1) goto uctoa::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // uctoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [208] *uctoa::buffer#11 = DIGITS[uctoa::value#2] -- _deref_pbuz1=pbuc1_derefidx_vbuz2 
    ldy.z value
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [209] uctoa::buffer#3 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [210] *uctoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // uctoa::@return
    // }
    // [211] return 
    rts
    // uctoa::@2
  __b2:
    // unsigned char digit_value = digit_values[digit]
    // [212] uctoa::digit_value#0 = RADIX_DECIMAL_VALUES_CHAR[uctoa::digit#2] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z digit
    lda RADIX_DECIMAL_VALUES_CHAR,y
    sta.z digit_value
    // if (started || value >= digit_value)
    // [213] if(0!=uctoa::started#2) goto uctoa::@5 -- 0_neq_vbuz1_then_la1 
    lda.z started
    bne __b5
    // uctoa::@7
    // [214] if(uctoa::value#2>=uctoa::digit_value#0) goto uctoa::@5 -- vbuz1_ge_vbuz2_then_la1 
    lda.z value
    cmp.z digit_value
    bcs __b5
    // [215] phi from uctoa::@7 to uctoa::@4 [phi:uctoa::@7->uctoa::@4]
    // [215] phi uctoa::buffer#14 = uctoa::buffer#11 [phi:uctoa::@7->uctoa::@4#0] -- register_copy 
    // [215] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@7->uctoa::@4#1] -- register_copy 
    // [215] phi uctoa::value#6 = uctoa::value#2 [phi:uctoa::@7->uctoa::@4#2] -- register_copy 
    // uctoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [216] uctoa::digit#1 = ++ uctoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [206] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
    // [206] phi uctoa::buffer#11 = uctoa::buffer#14 [phi:uctoa::@4->uctoa::@1#0] -- register_copy 
    // [206] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@4->uctoa::@1#1] -- register_copy 
    // [206] phi uctoa::value#2 = uctoa::value#6 [phi:uctoa::@4->uctoa::@1#2] -- register_copy 
    // [206] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@4->uctoa::@1#3] -- register_copy 
    jmp __b1
    // uctoa::@5
  __b5:
    // uctoa_append(buffer++, value, digit_value)
    // [217] uctoa_append::buffer#0 = uctoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z uctoa_append.buffer
    lda.z buffer+1
    sta.z uctoa_append.buffer+1
    // [218] uctoa_append::value#0 = uctoa::value#2
    // [219] uctoa_append::sub#0 = uctoa::digit_value#0
    // [220] call uctoa_append
    // [265] phi from uctoa::@5 to uctoa_append [phi:uctoa::@5->uctoa_append]
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // [221] uctoa_append::return#0 = uctoa_append::value#2
    // uctoa::@6
    // value = uctoa_append(buffer++, value, digit_value)
    // [222] uctoa::value#0 = uctoa_append::return#0
    // value = uctoa_append(buffer++, value, digit_value);
    // [223] uctoa::buffer#4 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [215] phi from uctoa::@6 to uctoa::@4 [phi:uctoa::@6->uctoa::@4]
    // [215] phi uctoa::buffer#14 = uctoa::buffer#4 [phi:uctoa::@6->uctoa::@4#0] -- register_copy 
    // [215] phi uctoa::started#4 = 1 [phi:uctoa::@6->uctoa::@4#1] -- vbuz1=vbuc1 
    lda #1
    sta.z started
    // [215] phi uctoa::value#6 = uctoa::value#0 [phi:uctoa::@6->uctoa::@4#2] -- register_copy 
    jmp __b4
}
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(void (*putc)(char), __zp($2c) char buffer_sign, char *buffer_digits, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label buffer_sign = $2c
    // printf_number_buffer::@1
    // if(buffer.sign)
    // [225] if(0==printf_number_buffer::buffer_sign#0) goto printf_number_buffer::@2 -- 0_eq_vbuz1_then_la1 
    lda.z buffer_sign
    beq __b2
    // printf_number_buffer::@3
    // putc(buffer.sign)
    // [226] stackpush(char) = printf_number_buffer::buffer_sign#0 -- _stackpushbyte_=vbuz1 
    pha
    // [227] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // [229] phi from printf_number_buffer::@1 printf_number_buffer::@3 to printf_number_buffer::@2 [phi:printf_number_buffer::@1/printf_number_buffer::@3->printf_number_buffer::@2]
    // printf_number_buffer::@2
  __b2:
    // printf_str(putc, buffer.digits)
    // [230] call printf_str
    // [161] phi from printf_number_buffer::@2 to printf_str [phi:printf_number_buffer::@2->printf_str]
    // [161] phi printf_str::putc#5 = printf_uchar::putc#0 [phi:printf_number_buffer::@2->printf_str#0] -- pprz1=pprc1 
    lda #<printf_uchar.putc
    sta.z printf_str.putc
    lda #>printf_uchar.putc
    sta.z printf_str.putc+1
    // [161] phi printf_str::s#5 = printf_number_buffer::buffer_digits#0 [phi:printf_number_buffer::@2->printf_str#1] -- pbuz1=pbuc1 
    lda #<buffer_digits
    sta.z printf_str.s
    lda #>buffer_digits
    sta.z printf_str.s+1
    jsr printf_str
    // printf_number_buffer::@return
    // }
    // [231] return 
    rts
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label __3 = $f
    .label cy = $17
    .label width = $16
    .label line = $a
    .label start = $a
    .label i = $e
    // unsigned char cy = __conio.cursor_y[__conio.layer]
    // [232] insertup::cy#0 = ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)[*((char *)&__conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y,y
    sta.z cy
    // unsigned char width = __conio.width * 2
    // [233] insertup::width#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    asl
    sta.z width
    // [234] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [234] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z i
    // insertup::@1
  __b1:
    // for(unsigned char i=1; i<=cy; i++)
    // [235] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuz1_le_vbuz2_then_la1 
    lda.z cy
    cmp.z i
    bcs __b2
    // [236] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [237] call clearline
    jsr clearline
    // insertup::@return
    // }
    // [238] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [239] insertup::$3 = insertup::i#2 - 1 -- vbuz1=vbuz2_minus_1 
    ldx.z i
    dex
    stx.z __3
    // unsigned int line = (i-1) << __conio.rowshift
    // [240] insertup::line#0 = insertup::$3 << *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) -- vwuz1=vbuz2_rol__deref_pbuc1 
    txa
    ldy __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    sta.z line
    lda #0
    sta.z line+1
    cpy #0
    beq !e+
  !:
    asl.z line
    rol.z line+1
    dey
    bne !-
  !e:
    // unsigned int start = __conio.mapbase_offset + line
    // [241] insertup::start#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) + insertup::line#0 -- vwuz1=_deref_pwuc1_plus_vwuz1 
    clc
    lda.z start
    adc __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z start
    lda.z start+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z start+1
    // memcpy_vram_vram_inc(0, start, VERA_INC_1, 0, start+__conio.rowskip, VERA_INC_1, width)
    // [242] memcpy_vram_vram_inc::soffset_vram#0 = insertup::start#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwuz1=vwuz2_plus__deref_pwuc1 
    lda.z start
    clc
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta.z memcpy_vram_vram_inc.soffset_vram
    lda.z start+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta.z memcpy_vram_vram_inc.soffset_vram+1
    // [243] memcpy_vram_vram_inc::doffset_vram#0 = insertup::start#0
    // [244] memcpy_vram_vram_inc::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z memcpy_vram_vram_inc.num
    lda #0
    sta.z memcpy_vram_vram_inc.num+1
    // [245] call memcpy_vram_vram_inc
    // [272] phi from insertup::@2 to memcpy_vram_vram_inc [phi:insertup::@2->memcpy_vram_vram_inc]
    jsr memcpy_vram_vram_inc
    // insertup::@4
    // for(unsigned char i=1; i<=cy; i++)
    // [246] insertup::i#1 = ++ insertup::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [234] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [234] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
}
  // clearline
clearline: {
    .label __1 = 7
    .label __2 = 8
    .label __4 = 6
    .label mapbase_offset = $c
    .label conio_line = 4
    .label addr = $c
    .label color = 9
    .label c = 2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [247] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // unsigned int mapbase_offset =  (unsigned int)__conio.mapbase_offset
    // [248] clearline::mapbase_offset#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwuz1=_deref_pwuc1 
    // Set address
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z mapbase_offset
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z mapbase_offset+1
    // unsigned int conio_line = __conio.line[__conio.layer]
    // [249] clearline::$4 = *((char *)&__conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __conio
    asl
    sta.z __4
    // [250] clearline::conio_line#0 = ((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE)[clearline::$4] -- vwuz1=pwuc1_derefidx_vbuz2 
    tay
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE,y
    sta.z conio_line
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1,y
    sta.z conio_line+1
    // mapbase_offset + conio_line
    // [251] clearline::addr#0 = clearline::mapbase_offset#0 + clearline::conio_line#0 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z addr
    adc.z conio_line
    sta.z addr
    lda.z addr+1
    adc.z conio_line+1
    sta.z addr+1
    // BYTE0(addr)
    // [252] clearline::$1 = byte0  (char *)clearline::addr#0 -- vbuz1=_byte0_pbuz2 
    lda.z addr
    sta.z __1
    // *VERA_ADDRX_L = BYTE0(addr)
    // [253] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(addr)
    // [254] clearline::$2 = byte1  (char *)clearline::addr#0 -- vbuz1=_byte1_pbuz2 
    lda.z addr+1
    sta.z __2
    // *VERA_ADDRX_M = BYTE1(addr)
    // [255] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [256] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // char color = __conio.color
    // [257] clearline::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbuz1=_deref_pbuc1 
    // TODO need to check this!
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z color
    // [258] phi from clearline to clearline::@1 [phi:clearline->clearline::@1]
    // [258] phi clearline::c#2 = 0 [phi:clearline->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<__conio.width; c++ )
    // [259] if(clearline::c#2<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto clearline::@2 -- vwuz1_lt__deref_pbuc1_then_la1 
    lda.z c+1
    bne !+
    lda.z c
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    bcc __b2
  !:
    // clearline::@3
    // __conio.cursor_x[__conio.layer] = 0
    // [260] ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X)[*((char *)&__conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy __conio
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X,y
    // clearline::@return
    // }
    // [261] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [262] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [263] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( unsigned int c=0;c<__conio.width; c++ )
    // [264] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [258] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [258] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
    jmp __b1
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
// __zp($12) char uctoa_append(__zp($2a) char *buffer, __zp($12) char value, __zp($18) char sub)
uctoa_append: {
    .label buffer = $2a
    .label value = $12
    .label sub = $18
    .label return = $12
    .label digit = $13
    // [266] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [266] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z digit
    // [266] phi uctoa_append::value#2 = uctoa_append::value#0 [phi:uctoa_append->uctoa_append::@1#1] -- register_copy 
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [267] if(uctoa_append::value#2>=uctoa_append::sub#0) goto uctoa_append::@2 -- vbuz1_ge_vbuz2_then_la1 
    lda.z value
    cmp.z sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [268] *uctoa_append::buffer#0 = DIGITS[uctoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuz2 
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // uctoa_append::@return
    // }
    // [269] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [270] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // value -= sub
    // [271] uctoa_append::value#1 = uctoa_append::value#2 - uctoa_append::sub#0 -- vbuz1=vbuz1_minus_vbuz2 
    lda.z value
    sec
    sbc.z sub
    sta.z value
    // [266] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [266] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    // [266] phi uctoa_append::value#2 = uctoa_append::value#1 [phi:uctoa_append::@2->uctoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // memcpy_vram_vram_inc
/**
 * @brief Copy block of memory from vram to vram with specified vera increments/decrements.
 * Copies num bytes from the source vram bank/offset to the destination vram bank/offset, with specified increment/decrement.
 *
 * @param dbank_vram Destination vram bank.
 * @param doffset_vram Destination vram offset.
 * @param dinc Destination vram increment/decrement.
 * @param sbank_vram Source vram bank.
 * @param soffset_vram Source vram offset.
 * @param sinc Source vram increment/decrement.
 * @param num Amount of bytes to copy.
 */
// void memcpy_vram_vram_inc(char dbank_vram, __zp($a) unsigned int doffset_vram, char dinc, char sbank_vram, __zp($c) unsigned int soffset_vram, char sinc, __zp(4) unsigned int num)
memcpy_vram_vram_inc: {
    .label vera_vram_data0_bank_offset1___0 = 6
    .label vera_vram_data0_bank_offset1___1 = 7
    .label vera_vram_data1_bank_offset1___0 = 8
    .label vera_vram_data1_bank_offset1___1 = 9
    .label i = 2
    .label doffset_vram = $a
    .label soffset_vram = $c
    .label num = 4
    // memcpy_vram_vram_inc::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [273] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [274] memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$0 = byte0  memcpy_vram_vram_inc::soffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z soffset_vram
    sta.z vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [275] *VERA_ADDRX_L = memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [276] memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$1 = byte1  memcpy_vram_vram_inc::soffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z soffset_vram+1
    sta.z vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [277] *VERA_ADDRX_M = memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [278] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // memcpy_vram_vram_inc::vera_vram_data1_bank_offset1
    // *VERA_CTRL |= VERA_ADDRSEL
    // [279] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [280] memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$0 = byte0  memcpy_vram_vram_inc::doffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z doffset_vram
    sta.z vera_vram_data1_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [281] *VERA_ADDRX_L = memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [282] memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$1 = byte1  memcpy_vram_vram_inc::doffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z doffset_vram+1
    sta.z vera_vram_data1_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [283] *VERA_ADDRX_M = memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [284] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // [285] phi from memcpy_vram_vram_inc::vera_vram_data1_bank_offset1 to memcpy_vram_vram_inc::@1 [phi:memcpy_vram_vram_inc::vera_vram_data1_bank_offset1->memcpy_vram_vram_inc::@1]
    // [285] phi memcpy_vram_vram_inc::i#2 = 0 [phi:memcpy_vram_vram_inc::vera_vram_data1_bank_offset1->memcpy_vram_vram_inc::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // memcpy_vram_vram_inc::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [286] if(memcpy_vram_vram_inc::i#2<memcpy_vram_vram_inc::num#0) goto memcpy_vram_vram_inc::@2 -- vwuz1_lt_vwuz2_then_la1 
    lda.z i+1
    cmp.z num+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z num
    bcc __b2
  !:
    // memcpy_vram_vram_inc::@return
    // }
    // [287] return 
    rts
    // memcpy_vram_vram_inc::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [288] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [289] memcpy_vram_vram_inc::i#1 = ++ memcpy_vram_vram_inc::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [285] phi from memcpy_vram_vram_inc::@2 to memcpy_vram_vram_inc::@1 [phi:memcpy_vram_vram_inc::@2->memcpy_vram_vram_inc::@1]
    // [285] phi memcpy_vram_vram_inc::i#2 = memcpy_vram_vram_inc::i#1 [phi:memcpy_vram_vram_inc::@2->memcpy_vram_vram_inc::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment Data
  VERA_LAYER_WIDTH: .word $20, $40, $80, $100
  VERA_LAYER_HEIGHT: .word $20, $40, $80, $100
  /**
 * @file cx16-veralib.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Commander X16 vera library for the kickc compiler.
 * Commander X16 VERA (Versatile Embedded Retro Adapter) Video and Audio Processor
 * [https://github.com/commanderx16/x16-docs/blob/master/VERA%20Programmer's%20Reference.md]()
 * @version 0.1
 * @date 2021-06-14
 *
 * @copyright Copyright (c) 2021
 *
 */
  vera_mapbase_offset: .fill 2*2, 0
  vera_mapbase_bank: .byte 0, 0
  vera_tilebase_offset: .word 0, 0
  vera_tilebase_bank: .byte 0, 0
  vera_layer_rowshift: .byte 0, 0
  vera_layer_rowskip: .word 0, 0
  skip: .word $40, $80, $100, $200
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
  __conio: .fill SIZEOF_STRUCT_CX16_CONIO, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
