  // File Comments
// Example program for the Commander X16.
// Demonstrates the usage of the VERA graphic modes and layering.
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="bitmap_1bpp_320_x_240.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  // Global Constants & labels
  /// The colors of the CX16
  .const BLACK = 0
  .const WHITE = 1
  .const BLUE = 6
  .const YELLOW = 7
  .const VERA_INC_1 = $10
  .const VERA_DCSEL = 2
  .const VERA_ADDRSEL = 1
  .const VERA_LAYER0_ENABLE = $10
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_MASK = $c0
  .const VERA_LAYER_COLOR_DEPTH_MASK = 3
  .const VERA_LAYER_CONFIG_MODE_BITMAP = 4
  .const VERA_TILEBASE_WIDTH_MASK = 1
  .const VERA_LAYER_TILEBASE_MASK = $fc
  ///< Load a logical file.
  .const CBM_PLOT = $fff0
  .const vera_inc_1 = $10
  .const OFFSET_STRUCT_CX16_CONIO_WIDTH = 4
  .const OFFSET_STRUCT_CX16_CONIO_HEIGHT = 5
  .const OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET = 1
  .const OFFSET_STRUCT_CX16_CONIO_COLOR = $e
  .const OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT = 8
  .const OFFSET_STRUCT_CX16_CONIO_MAPWIDTH = 6
  .const OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK = 3
  .const OFFSET_STRUCT_CX16_CONIO_CURSOR_X = $f
  .const OFFSET_STRUCT_CX16_CONIO_CURSOR_Y = $10
  .const OFFSET_STRUCT_CX16_CONIO_LINE = $11
  .const OFFSET_STRUCT_CX16_CONIO_ROWSKIP = $b
  .const OFFSET_STRUCT_CX16_CONIO_ROWSHIFT = $a
  .const OFFSET_STRUCT_CX16_CONIO_SCROLL = $13
  .const OFFSET_STRUCT_CX16_CONIO_CURSOR = $d
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_CX16_CONIO = $15
  .const SIZEOF_STRUCT___0 = $1188
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
  /// $9F29	DC_VIDEO (DCSEL=0)
  /// Bit 7: Current Field     Read-only bit which reflects the active interlaced field in composite and RGB modes. (0: even, 1: odd)
  /// Bit 6: Sprites Enable	Enable output from the Sprites renderer
  /// Bit 5: Layer1 Enable	    Enable output from the Layer1 renderer
  /// Bit 4: Layer0 Enable	    Enable output from the Layer0 renderer
  /// Bit 2: Chroma Disable    Setting 'Chroma Disable' disables output of chroma in NTSC composite mode and will give a better picture on a monochrome display. (Setting this bit will also disable the chroma output on the S-video output.)
  /// Bit 0-1: Output Mode     0: Video disabled, 1: VGA output, 2: NTSC composite, 3: RGB interlaced, composite sync (via VGA connector)
  .label VERA_DC_VIDEO = $9f29
  /// $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
  .label VERA_DC_HSCALE = $9f2a
  /// $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
  .label VERA_DC_VSCALE = $9f2b
  /// $9F2D	L0_CONFIG   Layer 0 Configuration
  .label VERA_L0_CONFIG = $9f2d
  /// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L0_TILEBASE = $9f2f
  /// $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  /// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  .label BRAM = 0
.segment Code
  // __start
__start: {
    // __start::__init1
    // __address(0) char BRAM
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [2] call conio_x16_init
    jsr conio_x16_init
    // [3] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [4] call main
    // [63] phi from __start::@1 to main [phi:__start::@1->main]
    jsr main
    // __start::@return
    // [5] return 
    rts
}
  // conio_x16_init
// Set initial cursor position
conio_x16_init: {
    // // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    // char line = *BASIC_CURSOR_LINE
    // [6] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbum1=_deref_pbuc1 
    lda.z BASIC_CURSOR_LINE
    sta line
    // screensize(&__conio.width, &__conio.height)
    // [7] call screensize
    // *VERA_L1_CONFIG &= ~VERA_LAYER_CONFIG_256C;
    // *VERA_L1_CONFIG |= VERA_LAYER_CONFIG_16C;
    jsr screensize
    // [8] phi from conio_x16_init to conio_x16_init::@3 [phi:conio_x16_init->conio_x16_init::@3]
    // conio_x16_init::@3
    // screenlayer1()
    // [9] call screenlayer1
    // TODO, this should become a ROM call for the CX16.
    jsr screenlayer1
    // [10] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // textcolor(WHITE)
    // [11] call textcolor
    // [209] phi from conio_x16_init::@4 to textcolor [phi:conio_x16_init::@4->textcolor]
    // [209] phi textcolor::color#6 = WHITE [phi:conio_x16_init::@4->textcolor#0] -- vbum1=vbuc1 
    lda #WHITE
    sta textcolor.color
    jsr textcolor
    // [12] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // bgcolor(BLUE)
    // [13] call bgcolor
    // [214] phi from conio_x16_init::@5 to bgcolor [phi:conio_x16_init::@5->bgcolor]
    // [214] phi bgcolor::color#4 = BLUE [phi:conio_x16_init::@5->bgcolor#0] -- vbum1=vbuc1 
    lda #BLUE
    sta bgcolor.color
    jsr bgcolor
    // [14] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // cursor(0)
    // [15] call cursor
    jsr cursor
    // conio_x16_init::@7
    // if(line>=__conio.height)
    // [16] if(conio_x16_init::line#0<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto conio_x16_init::@1 -- vbum1_lt__deref_pbuc1_then_la1 
    lda line
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    // [17] phi from conio_x16_init::@7 to conio_x16_init::@2 [phi:conio_x16_init::@7->conio_x16_init::@2]
    // conio_x16_init::@2
    // [18] phi from conio_x16_init::@2 conio_x16_init::@7 to conio_x16_init::@1 [phi:conio_x16_init::@2/conio_x16_init::@7->conio_x16_init::@1]
    // conio_x16_init::@1
    // cbm_k_plot_get()
    // [19] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [20] cbm_k_plot_get::return#2 = cbm_k_plot_get::return#0
    // conio_x16_init::@8
    // [21] conio_x16_init::$8 = cbm_k_plot_get::return#2
    // BYTE1(cbm_k_plot_get())
    // [22] conio_x16_init::$9 = byte1  conio_x16_init::$8 -- vbum1=_byte1_vwum2 
    lda __8+1
    sta __9
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [23] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = conio_x16_init::$9 -- _deref_pbuc1=vbum1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // cbm_k_plot_get()
    // [24] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [25] cbm_k_plot_get::return#3 = cbm_k_plot_get::return#0
    // conio_x16_init::@9
    // [26] conio_x16_init::$10 = cbm_k_plot_get::return#3
    // BYTE0(cbm_k_plot_get())
    // [27] conio_x16_init::$11 = byte0  conio_x16_init::$10 -- vbum1=_byte0_vwum2 
    lda __10
    sta __11
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [28] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = conio_x16_init::$11 -- _deref_pbuc1=vbum1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // gotoxy(__conio.cursor_x, __conio.cursor_y)
    // [29] gotoxy::x#1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) -- vbum1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    sta gotoxy.x
    // [30] gotoxy::y#1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) -- vbum1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    sta gotoxy.y
    // [31] call gotoxy
    // [227] phi from conio_x16_init::@9 to gotoxy [phi:conio_x16_init::@9->gotoxy]
    // [227] phi gotoxy::x#10 = gotoxy::x#1 [phi:conio_x16_init::@9->gotoxy#0] -- register_copy 
    // [227] phi gotoxy::y#8 = gotoxy::y#1 [phi:conio_x16_init::@9->gotoxy#1] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [32] return 
    rts
  .segment Data
    .label __8 = cbm_k_plot_get.return
    __9: .byte 0
    .label __10 = cbm_k_plot_get.return
    __11: .byte 0
    line: .byte 0
}
.segment Code
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__mem() char c)
cputc: {
    .const OFFSET_STACK_C = 0
    // [33] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta c
    // char color = __conio.color
    // [34] cputc::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbum1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta color
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [35] cputc::mapbase_offset#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwum1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta mapbase_offset
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta mapbase_offset+1
    // unsigned int mapwidth = __conio.mapwidth
    // [36] cputc::mapwidth#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) -- vwum1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    sta mapwidth
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    sta mapwidth+1
    // unsigned int conio_addr = mapbase_offset + __conio.line
    // [37] cputc::conio_addr#0 = cputc::mapbase_offset#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda conio_addr
    adc __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta conio_addr
    lda conio_addr+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    sta conio_addr+1
    // __conio.cursor_x << 1
    // [38] cputc::$1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    asl
    sta __1
    // conio_addr += __conio.cursor_x << 1
    // [39] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$1 -- vwum1=vwum1_plus_vbum2 
    clc
    adc conio_addr
    sta conio_addr
    bcc !+
    inc conio_addr+1
  !:
    // if(c=='\n')
    // [40] if(cputc::c#0==' ') goto cputc::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [41] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(conio_addr)
    // [42] cputc::$3 = byte0  cputc::conio_addr#1 -- vbum1=_byte0_vwum2 
    lda conio_addr
    sta __3
    // *VERA_ADDRX_L = BYTE0(conio_addr)
    // [43] *VERA_ADDRX_L = cputc::$3 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(conio_addr)
    // [44] cputc::$4 = byte1  cputc::conio_addr#1 -- vbum1=_byte1_vwum2 
    lda conio_addr+1
    sta __4
    // *VERA_ADDRX_M = BYTE1(conio_addr)
    // [45] *VERA_ADDRX_M = cputc::$4 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [46] cputc::$5 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    sta __5
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [47] *VERA_ADDRX_H = cputc::$5 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [48] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbum1 
    lda c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [49] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbum1 
    lda color
    sta VERA_DATA0
    // __conio.cursor_x++;
    // [50] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = ++ *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // unsigned char scroll_enable = __conio.scroll[__conio.layer]
    // [51] cputc::scroll_enable#0 = ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_SCROLL)[*((char *)&__conio)] -- vbum1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_SCROLL,y
    sta scroll_enable
    // if(scroll_enable)
    // [52] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbum1_then_la1 
    bne __b5
    // cputc::@3
    // (unsigned int)__conio.cursor_x == mapwidth
    // [53] cputc::$14 = (unsigned int)*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) -- vwum1=_word__deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    sta __14
    lda #0
    sta __14+1
    // if((unsigned int)__conio.cursor_x == mapwidth)
    // [54] if(cputc::$14!=cputc::mapwidth#0) goto cputc::@return -- vwum1_neq_vwum2_then_la1 
    cmp mapwidth+1
    bne __breturn
    lda __14
    cmp mapwidth
    bne __breturn
    // [55] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [56] call cputln
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [57] return 
    rts
    // cputc::@5
  __b5:
    // if(__conio.cursor_x == __conio.width)
    // [58] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X)!=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto cputc::@return -- _deref_pbuc1_neq__deref_pbuc2_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    bne __breturn
    // [59] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [60] call cputln
    jsr cputln
    rts
    // [61] phi from cputc to cputc::@1 [phi:cputc->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [62] call cputln
    jsr cputln
    rts
  .segment Data
    __1: .byte 0
    __3: .byte 0
    __4: .byte 0
    __5: .byte 0
    __14: .word 0
    c: .byte 0
    color: .byte 0
    mapbase_offset: .word 0
    mapwidth: .word 0
    .label conio_addr = mapbase_offset
    scroll_enable: .byte 0
}
.segment Code
  // main
main: {
    // textcolor(WHITE)
    // [64] call textcolor
    // [209] phi from main to textcolor [phi:main->textcolor]
    // [209] phi textcolor::color#6 = WHITE [phi:main->textcolor#0] -- vbum1=vbuc1 
    lda #WHITE
    sta textcolor.color
    jsr textcolor
    // [65] phi from main to main::@9 [phi:main->main::@9]
    // main::@9
    // bgcolor(BLACK)
    // [66] call bgcolor
    // [214] phi from main::@9 to bgcolor [phi:main::@9->bgcolor]
    // [214] phi bgcolor::color#4 = BLACK [phi:main::@9->bgcolor#0] -- vbum1=vbuc1 
    lda #BLACK
    sta bgcolor.color
    jsr bgcolor
    // [67] phi from main::@9 to main::@10 [phi:main::@9->main::@10]
    // main::@10
    // clrscr()
    // [68] call clrscr
    jsr clrscr
    // [69] phi from main::@10 to main::@11 [phi:main::@10->main::@11]
    // main::@11
    // gotoxy(0,25)
    // [70] call gotoxy
    // [227] phi from main::@11 to gotoxy [phi:main::@11->gotoxy]
    // [227] phi gotoxy::x#10 = 0 [phi:main::@11->gotoxy#0] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.x
    // [227] phi gotoxy::y#8 = $19 [phi:main::@11->gotoxy#1] -- vbum1=vbuc1 
    lda #$19
    sta gotoxy.y
    jsr gotoxy
    // [71] phi from main::@11 to main::@12 [phi:main::@11->main::@12]
    // main::@12
    // printf("vera in bitmap mode,\n")
    // [72] call printf_str
    // [271] phi from main::@12 to printf_str [phi:main::@12->printf_str]
    // [271] phi printf_str::s#9 = main::s [phi:main::@12->printf_str#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // [73] phi from main::@12 to main::@13 [phi:main::@12->main::@13]
    // main::@13
    // printf("color depth 1 bits per pixel.\n")
    // [74] call printf_str
    // [271] phi from main::@13 to printf_str [phi:main::@13->printf_str]
    // [271] phi printf_str::s#9 = main::s1 [phi:main::@13->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [75] phi from main::@13 to main::@14 [phi:main::@13->main::@14]
    // main::@14
    // printf("in this mode, it is possible to display\n")
    // [76] call printf_str
    // [271] phi from main::@14 to printf_str [phi:main::@14->printf_str]
    // [271] phi printf_str::s#9 = main::s2 [phi:main::@14->printf_str#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // [77] phi from main::@14 to main::@15 [phi:main::@14->main::@15]
    // main::@15
    // printf("graphics in 2 colors (black or color).\n")
    // [78] call printf_str
    // [271] phi from main::@15 to printf_str [phi:main::@15->printf_str]
    // [271] phi printf_str::s#9 = main::s3 [phi:main::@15->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // main::vera_layer0_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [79] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_LAYER0_ENABLE
    // [80] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_LAYER0_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER0_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [81] phi from main::vera_layer0_show1 to main::@8 [phi:main::vera_layer0_show1->main::@8]
    // main::@8
    // vera_layer0_mode_bitmap(
    //         0, 0x0000, 
    //         VERA_TILEBASE_WIDTH_8, 
    //         1
    //     )
    // [82] call vera_layer0_mode_bitmap
    jsr vera_layer0_mode_bitmap
    // [83] phi from main::@8 to main::@16 [phi:main::@8->main::@16]
    // main::@16
    // bitmap_init(0, 0, 0x0000)
    // [84] call bitmap_init
    jsr bitmap_init
    // [85] phi from main::@16 to main::@17 [phi:main::@16->main::@17]
    // main::@17
    // bitmap_clear()
    // [86] call bitmap_clear
    jsr bitmap_clear
    // [87] phi from main::@17 to main::@18 [phi:main::@17->main::@18]
    // main::@18
    // gotoxy(0,29)
    // [88] call gotoxy
    // [227] phi from main::@18 to gotoxy [phi:main::@18->gotoxy]
    // [227] phi gotoxy::x#10 = 0 [phi:main::@18->gotoxy#0] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.x
    // [227] phi gotoxy::y#8 = $1d [phi:main::@18->gotoxy#1] -- vbum1=vbuc1 
    lda #$1d
    sta gotoxy.y
    jsr gotoxy
    // [89] phi from main::@18 to main::@19 [phi:main::@18->main::@19]
    // main::@19
    // textcolor(YELLOW)
    // [90] call textcolor
    // [209] phi from main::@19 to textcolor [phi:main::@19->textcolor]
    // [209] phi textcolor::color#6 = YELLOW [phi:main::@19->textcolor#0] -- vbum1=vbuc1 
    lda #YELLOW
    sta textcolor.color
    jsr textcolor
    // [91] phi from main::@19 to main::@20 [phi:main::@19->main::@20]
    // main::@20
    // printf("press a key ...")
    // [92] call printf_str
    // [271] phi from main::@20 to printf_str [phi:main::@20->printf_str]
    // [271] phi printf_str::s#9 = main::s4 [phi:main::@20->printf_str#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // [93] phi from main::@20 main::@30 to main::@1 [phi:main::@20/main::@30->main::@1]
    // main::@1
  __b1:
    // kbhit()
    // [94] call kbhit
    // [392] phi from main::@1 to kbhit [phi:main::@1->kbhit]
    jsr kbhit
    // kbhit()
    // [95] kbhit::return#2 = kbhit::return#0
    // main::@21
    // [96] main::$27 = kbhit::return#2
    // while(!kbhit())
    // [97] if(0==main::$27) goto main::@2 -- 0_eq_vbum1_then_la1 
    lda __27
    bne !__b2+
    jmp __b2
  !__b2:
    // [98] phi from main::@21 to main::@3 [phi:main::@21->main::@3]
    // main::@3
    // textcolor(WHITE)
    // [99] call textcolor
    // [209] phi from main::@3 to textcolor [phi:main::@3->textcolor]
    // [209] phi textcolor::color#6 = WHITE [phi:main::@3->textcolor#0] -- vbum1=vbuc1 
    lda #WHITE
    sta textcolor.color
    jsr textcolor
    // [100] phi from main::@3 to main::@31 [phi:main::@3->main::@31]
    // main::@31
    // bgcolor(BLACK)
    // [101] call bgcolor
    // [214] phi from main::@31 to bgcolor [phi:main::@31->bgcolor]
    // [214] phi bgcolor::color#4 = BLACK [phi:main::@31->bgcolor#0] -- vbum1=vbuc1 
    lda #BLACK
    sta bgcolor.color
    jsr bgcolor
    // [102] phi from main::@31 to main::@32 [phi:main::@31->main::@32]
    // main::@32
    // clrscr()
    // [103] call clrscr
    jsr clrscr
    // [104] phi from main::@32 to main::@33 [phi:main::@32->main::@33]
    // main::@33
    // gotoxy(0,26)
    // [105] call gotoxy
    // [227] phi from main::@33 to gotoxy [phi:main::@33->gotoxy]
    // [227] phi gotoxy::x#10 = 0 [phi:main::@33->gotoxy#0] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.x
    // [227] phi gotoxy::y#8 = $1a [phi:main::@33->gotoxy#1] -- vbum1=vbuc1 
    lda #$1a
    sta gotoxy.y
    jsr gotoxy
    // [106] phi from main::@33 to main::@34 [phi:main::@33->main::@34]
    // main::@34
    // printf("here you see all the colors possible.\n")
    // [107] call printf_str
    // [271] phi from main::@34 to printf_str [phi:main::@34->printf_str]
    // [271] phi printf_str::s#9 = main::s5 [phi:main::@34->printf_str#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // [108] phi from main::@34 to main::@35 [phi:main::@34->main::@35]
    // main::@35
    // gotoxy(0,29)
    // [109] call gotoxy
    // [227] phi from main::@35 to gotoxy [phi:main::@35->gotoxy]
    // [227] phi gotoxy::x#10 = 0 [phi:main::@35->gotoxy#0] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.x
    // [227] phi gotoxy::y#8 = $1d [phi:main::@35->gotoxy#1] -- vbum1=vbuc1 
    lda #$1d
    sta gotoxy.y
    jsr gotoxy
    // [110] phi from main::@35 to main::@36 [phi:main::@35->main::@36]
    // main::@36
    // textcolor(YELLOW)
    // [111] call textcolor
    // [209] phi from main::@36 to textcolor [phi:main::@36->textcolor]
    // [209] phi textcolor::color#6 = YELLOW [phi:main::@36->textcolor#0] -- vbum1=vbuc1 
    lda #YELLOW
    sta textcolor.color
    jsr textcolor
    // [112] phi from main::@36 to main::@37 [phi:main::@36->main::@37]
    // main::@37
    // printf("press a key ...")
    // [113] call printf_str
    // [271] phi from main::@37 to printf_str [phi:main::@37->printf_str]
    // [271] phi printf_str::s#9 = main::s4 [phi:main::@37->printf_str#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // [114] phi from main::@37 to main::@4 [phi:main::@37->main::@4]
    // [114] phi main::color#3 = 0 [phi:main::@37->main::@4#0] -- vbum1=vbuc1 
    lda #0
    sta color
    // [114] phi main::x#3 = 0 [phi:main::@37->main::@4#1] -- vwum1=vwuc1 
    sta x
    sta x+1
    // main::@4
  __b4:
    // kbhit()
    // [115] call kbhit
    // [392] phi from main::@4 to kbhit [phi:main::@4->kbhit]
    jsr kbhit
    // kbhit()
    // [116] kbhit::return#3 = kbhit::return#0
    // main::@38
    // [117] main::$40 = kbhit::return#3
    // while(!kbhit())
    // [118] if(0==main::$40) goto main::@5 -- 0_eq_vbum1_then_la1 
    lda __40
    beq __b5
    // [119] phi from main::@38 to main::@6 [phi:main::@38->main::@6]
    // main::@6
    // screenlayer1()
    // [120] call screenlayer1
    jsr screenlayer1
    // [121] phi from main::@6 to main::@40 [phi:main::@6->main::@40]
    // main::@40
    // textcolor(WHITE)
    // [122] call textcolor
    // [209] phi from main::@40 to textcolor [phi:main::@40->textcolor]
    // [209] phi textcolor::color#6 = WHITE [phi:main::@40->textcolor#0] -- vbum1=vbuc1 
    lda #WHITE
    sta textcolor.color
    jsr textcolor
    // [123] phi from main::@40 to main::@41 [phi:main::@40->main::@41]
    // main::@41
    // bgcolor(BLUE)
    // [124] call bgcolor
    // [214] phi from main::@41 to bgcolor [phi:main::@41->bgcolor]
    // [214] phi bgcolor::color#4 = BLUE [phi:main::@41->bgcolor#0] -- vbum1=vbuc1 
    lda #BLUE
    sta bgcolor.color
    jsr bgcolor
    // [125] phi from main::@41 to main::@42 [phi:main::@41->main::@42]
    // main::@42
    // clrscr()
    // [126] call clrscr
    jsr clrscr
    // main::@return
    // }
    // [127] return 
    rts
    // main::@5
  __b5:
    // bitmap_line(x, x, 0, 199, color)
    // [128] bitmap_line::x0#1 = main::x#3 -- vwum1=vwum2 
    lda x
    sta bitmap_line.x0
    lda x+1
    sta bitmap_line.x0+1
    // [129] bitmap_line::x1#1 = main::x#3 -- vwum1=vwum2 
    lda x
    sta bitmap_line.x1
    lda x+1
    sta bitmap_line.x1+1
    // [130] bitmap_line::c#1 = main::color#3 -- vbum1=vbum2 
    lda color
    sta bitmap_line.c
    // [131] call bitmap_line
    // [397] phi from main::@5 to bitmap_line [phi:main::@5->bitmap_line]
    // [397] phi bitmap_line::c#10 = bitmap_line::c#1 [phi:main::@5->bitmap_line#0] -- register_copy 
    // [397] phi bitmap_line::y1#10 = $c7 [phi:main::@5->bitmap_line#1] -- vwum1=vbuc1 
    lda #<$c7
    sta bitmap_line.y1
    lda #>$c7
    sta bitmap_line.y1+1
    // [397] phi bitmap_line::y0#10 = 0 [phi:main::@5->bitmap_line#2] -- vwum1=vbuc1 
    lda #<0
    sta bitmap_line.y0
    sta bitmap_line.y0+1
    // [397] phi bitmap_line::x1#10 = bitmap_line::x1#1 [phi:main::@5->bitmap_line#3] -- register_copy 
    // [397] phi bitmap_line::x0#10 = bitmap_line::x0#1 [phi:main::@5->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    // main::@39
    // color++;
    // [132] main::color#1 = ++ main::color#3 -- vbum1=_inc_vbum1 
    inc color
    // if(color>1)
    // [133] if(main::color#1<1+1) goto main::@44 -- vbum1_lt_vbuc1_then_la1 
    lda color
    cmp #1+1
    bcc __b7
    // [135] phi from main::@39 to main::@7 [phi:main::@39->main::@7]
    // [135] phi main::color#7 = 0 [phi:main::@39->main::@7#0] -- vbum1=vbuc1 
    lda #0
    sta color
    // [134] phi from main::@39 to main::@44 [phi:main::@39->main::@44]
    // main::@44
    // [135] phi from main::@44 to main::@7 [phi:main::@44->main::@7]
    // [135] phi main::color#7 = main::color#1 [phi:main::@44->main::@7#0] -- register_copy 
    // main::@7
  __b7:
    // x++;
    // [136] main::x#1 = ++ main::x#3 -- vwum1=_inc_vwum1 
    inc x
    bne !+
    inc x+1
  !:
    // if(x>319)
    // [137] if(main::x#1<=$13f) goto main::@43 -- vwum1_le_vwuc1_then_la1 
    lda x+1
    cmp #>$13f
    bne !+
    lda x
    cmp #<$13f
  !:
    bcc __b4
    beq __b4
    // [114] phi from main::@7 to main::@4 [phi:main::@7->main::@4]
    // [114] phi main::color#3 = main::color#7 [phi:main::@7->main::@4#0] -- register_copy 
    // [114] phi main::x#3 = 0 [phi:main::@7->main::@4#1] -- vwum1=vbuc1 
    lda #<0
    sta x
    sta x+1
    jmp __b4
    // [138] phi from main::@7 to main::@43 [phi:main::@7->main::@43]
    // main::@43
    // [114] phi from main::@43 to main::@4 [phi:main::@43->main::@4]
    // [114] phi main::color#3 = main::color#7 [phi:main::@43->main::@4#0] -- register_copy 
    // [114] phi main::x#3 = main::x#1 [phi:main::@43->main::@4#1] -- register_copy 
    // [139] phi from main::@21 to main::@2 [phi:main::@21->main::@2]
    // main::@2
  __b2:
    // rand()
    // [140] call rand
    jsr rand
    // [141] rand::return#2 = rand::return#0
    // main::@22
    // modr16u(rand(),320,0)
    // [142] modr16u::dividend#0 = rand::return#2
    // [143] call modr16u
    // [476] phi from main::@22 to modr16u [phi:main::@22->modr16u]
    // [476] phi modr16u::divisor#4 = $140 [phi:main::@22->modr16u#0] -- vwum1=vwuc1 
    lda #<$140
    sta modr16u.divisor
    lda #>$140
    sta modr16u.divisor+1
    // [476] phi modr16u::dividend#4 = modr16u::dividend#0 [phi:main::@22->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),320,0)
    // [144] modr16u::return#2 = modr16u::return#0 -- vwum1=vwum2 
    lda modr16u.return
    sta modr16u.return_1
    lda modr16u.return+1
    sta modr16u.return_1+1
    // main::@23
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&1)
    // [145] bitmap_line::x0#0 = modr16u::return#2
    // rand()
    // [146] call rand
    jsr rand
    // [147] rand::return#3 = rand::return#0
    // main::@24
    // modr16u(rand(),320,0)
    // [148] modr16u::dividend#1 = rand::return#3
    // [149] call modr16u
    // [476] phi from main::@24 to modr16u [phi:main::@24->modr16u]
    // [476] phi modr16u::divisor#4 = $140 [phi:main::@24->modr16u#0] -- vwum1=vwuc1 
    lda #<$140
    sta modr16u.divisor
    lda #>$140
    sta modr16u.divisor+1
    // [476] phi modr16u::dividend#4 = modr16u::dividend#1 [phi:main::@24->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),320,0)
    // [150] modr16u::return#3 = modr16u::return#0 -- vwum1=vwum2 
    lda modr16u.return
    sta modr16u.return_2
    lda modr16u.return+1
    sta modr16u.return_2+1
    // main::@25
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&1)
    // [151] bitmap_line::x1#0 = modr16u::return#3
    // rand()
    // [152] call rand
    jsr rand
    // [153] rand::return#10 = rand::return#0
    // main::@26
    // modr16u(rand(),200,0)
    // [154] modr16u::dividend#2 = rand::return#10
    // [155] call modr16u
    // [476] phi from main::@26 to modr16u [phi:main::@26->modr16u]
    // [476] phi modr16u::divisor#4 = $c8 [phi:main::@26->modr16u#0] -- vwum1=vbuc1 
    lda #<$c8
    sta modr16u.divisor
    lda #>$c8
    sta modr16u.divisor+1
    // [476] phi modr16u::dividend#4 = modr16u::dividend#2 [phi:main::@26->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),200,0)
    // [156] modr16u::return#4 = modr16u::return#0 -- vwum1=vwum2 
    lda modr16u.return
    sta modr16u.return_3
    lda modr16u.return+1
    sta modr16u.return_3+1
    // main::@27
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&1)
    // [157] bitmap_line::y0#0 = modr16u::return#4
    // rand()
    // [158] call rand
    jsr rand
    // [159] rand::return#11 = rand::return#0
    // main::@28
    // modr16u(rand(),200,0)
    // [160] modr16u::dividend#3 = rand::return#11
    // [161] call modr16u
    // [476] phi from main::@28 to modr16u [phi:main::@28->modr16u]
    // [476] phi modr16u::divisor#4 = $c8 [phi:main::@28->modr16u#0] -- vwum1=vbuc1 
    lda #<$c8
    sta modr16u.divisor
    lda #>$c8
    sta modr16u.divisor+1
    // [476] phi modr16u::dividend#4 = modr16u::dividend#3 [phi:main::@28->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),200,0)
    // [162] modr16u::return#10 = modr16u::return#0
    // main::@29
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&1)
    // [163] bitmap_line::y1#0 = modr16u::return#10
    // rand()
    // [164] call rand
    jsr rand
    // [165] rand::return#12 = rand::return#0
    // main::@30
    // [166] main::$37 = rand::return#12
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&1)
    // [167] bitmap_line::c#0 = main::$37 & 1 -- vbum1=vwum2_band_vbuc1 
    lda #1
    and __37
    sta bitmap_line.c
    // [168] call bitmap_line
    // [397] phi from main::@30 to bitmap_line [phi:main::@30->bitmap_line]
    // [397] phi bitmap_line::c#10 = bitmap_line::c#0 [phi:main::@30->bitmap_line#0] -- register_copy 
    // [397] phi bitmap_line::y1#10 = bitmap_line::y1#0 [phi:main::@30->bitmap_line#1] -- register_copy 
    // [397] phi bitmap_line::y0#10 = bitmap_line::y0#0 [phi:main::@30->bitmap_line#2] -- register_copy 
    // [397] phi bitmap_line::x1#10 = bitmap_line::x1#0 [phi:main::@30->bitmap_line#3] -- register_copy 
    // [397] phi bitmap_line::x0#10 = bitmap_line::x0#0 [phi:main::@30->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    jmp __b1
  .segment Data
    s: .text @"vera in bitmap mode,\n"
    .byte 0
    s1: .text @"color depth 1 bits per pixel.\n"
    .byte 0
    s2: .text @"in this mode, it is possible to display\n"
    .byte 0
    s3: .text @"graphics in 2 colors (black or color).\n"
    .byte 0
    s4: .text "press a key ..."
    .byte 0
    s5: .text @"here you see all the colors possible.\n"
    .byte 0
    .label __27 = kbhit.return
    .label __37 = modr16u.dividend
    .label __40 = kbhit.return
    color: .byte 0
    x: .word 0
}
.segment Code
  // screensize
// Return the current screen size.
// void screensize(char *x, char *y)
screensize: {
    .label x = __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    .label y = __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    // char hscale = (*VERA_DC_HSCALE) >> 7
    // [169] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbum1=_deref_pbuc1_ror_7 
    // VERA returns in VERA_DC_HSCALE the value of 128 when 80 columns is used in text mode,
    // and the value of 64 when 40 columns is used in text mode.
    // Basically, 40 columns mode in the VERA is a double scan mode.
    // Same for the VERA_DC_VSCALE mode, but then the subdivision is 60 or 30 rows.
    // I still need to test the other modes, but this will suffice for now for the pure text modes.
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    sta hscale
    // 40 << hscale
    // [170] screensize::$1 = $28 << screensize::hscale#0 -- vbum1=vbuc1_rol_vbum1 
    lda #$28
    ldy __1
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta __1
    // *x = 40 << hscale
    // [171] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbum1 
    sta x
    // char vscale = (*VERA_DC_VSCALE) >> 7
    // [172] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbum1=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    sta vscale
    // 30 << vscale
    // [173] screensize::$3 = $1e << screensize::vscale#0 -- vbum1=vbuc1_rol_vbum1 
    lda #$1e
    ldy __3
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta __3
    // *y = 30 << vscale
    // [174] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbum1 
    sta y
    // screensize::@return
    // }
    // [175] return 
    rts
  .segment Data
    .label __1 = hscale
    .label __3 = vscale
    hscale: .byte 0
    vscale: .byte 0
}
.segment Code
  // screenlayer1
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer1: {
    // __conio.layer = 1
    // [176] *((char *)&__conio) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta __conio
    // (*VERA_L1_MAPBASE)>>7
    // [177] screenlayer1::$0 = *VERA_L1_MAPBASE >> 7 -- vbum1=_deref_pbuc1_ror_7 
    lda VERA_L1_MAPBASE
    rol
    rol
    and #1
    sta __0
    // __conio.mapbase_bank = (*VERA_L1_MAPBASE)>>7
    // [178] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) = screenlayer1::$0 -- _deref_pbuc1=vbum1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    // (*VERA_L1_MAPBASE)<<1
    // [179] screenlayer1::$1 = *VERA_L1_MAPBASE << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda VERA_L1_MAPBASE
    asl
    sta __1
    // MAKEWORD((*VERA_L1_MAPBASE)<<1,0)
    // [180] screenlayer1::$2 = screenlayer1::$1 w= 0 -- vwum1=vbum2_word_vbuc1 
    lda #0
    ldy __1
    sty __2+1
    sta __2
    // __conio.mapbase_offset = MAKEWORD((*VERA_L1_MAPBASE)<<1,0)
    // [181] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) = screenlayer1::$2 -- _deref_pwuc1=vwum1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    tya
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    // *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK
    // [182] screenlayer1::$3 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta __3
    // (*VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4
    // [183] screenlayer1::$4 = screenlayer1::$3 >> 4 -- vbum1=vbum1_ror_4 
    lda __4
    lsr
    lsr
    lsr
    lsr
    sta __4
    // __conio.mapwidth = VERA_LAYER_WIDTH[ (*VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4]
    // [184] screenlayer1::$16 = screenlayer1::$4 << 1 -- vbum1=vbum1_rol_1 
    asl __16
    // [185] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) = VERA_LAYER_WIDTH[screenlayer1::$16] -- _deref_pwuc1=pwuc2_derefidx_vbum1 
    ldy __16
    lda VERA_LAYER_WIDTH,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    lda VERA_LAYER_WIDTH+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    // *VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK
    // [186] screenlayer1::$5 = *VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK
    and VERA_L1_CONFIG
    sta __5
    // (*VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6
    // [187] screenlayer1::$6 = screenlayer1::$5 >> 6 -- vbum1=vbum1_ror_6 
    lda __6
    rol
    rol
    rol
    and #3
    sta __6
    // __conio.mapheight = VERA_LAYER_HEIGHT[ (*VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [188] screenlayer1::$17 = screenlayer1::$6 << 1 -- vbum1=vbum1_rol_1 
    asl __17
    // [189] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT) = VERA_LAYER_HEIGHT[screenlayer1::$17] -- _deref_pwuc1=pwuc2_derefidx_vbum1 
    ldy __17
    lda VERA_LAYER_HEIGHT,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT
    lda VERA_LAYER_HEIGHT+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT+1
    // (*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK
    // [190] screenlayer1::$7 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta __7
    // ((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4
    // [191] screenlayer1::$8 = screenlayer1::$7 >> 4 -- vbum1=vbum1_ror_4 
    lda __8
    lsr
    lsr
    lsr
    lsr
    sta __8
    // (((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4)+6
    // [192] screenlayer1::$9 = screenlayer1::$8 + 6 -- vbum1=vbum1_plus_vbuc1 
    lda #6
    clc
    adc __9
    sta __9
    // __conio.rowshift = (((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4)+6
    // [193] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) = screenlayer1::$9 -- _deref_pbuc1=vbum1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    // (*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK
    // [194] screenlayer1::$10 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta __10
    // ((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4
    // [195] screenlayer1::$11 = screenlayer1::$10 >> 4 -- vbum1=vbum1_ror_4 
    lda __11
    lsr
    lsr
    lsr
    lsr
    sta __11
    // __conio.rowskip = VERA_LAYER_SKIP[((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4]
    // [196] screenlayer1::$18 = screenlayer1::$11 << 1 -- vbum1=vbum1_rol_1 
    asl __18
    // [197] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) = VERA_LAYER_SKIP[screenlayer1::$18] -- _deref_pwuc1=pwuc2_derefidx_vbum1 
    ldy __18
    lda VERA_LAYER_SKIP,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    lda VERA_LAYER_SKIP+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    // cbm_k_plot_get()
    // [198] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [199] cbm_k_plot_get::return#4 = cbm_k_plot_get::return#0
    // screenlayer1::@1
    // [200] screenlayer1::$12 = cbm_k_plot_get::return#4
    // BYTE1(cbm_k_plot_get())
    // [201] screenlayer1::$13 = byte1  screenlayer1::$12 -- vbum1=_byte1_vwum2 
    lda __12+1
    sta __13
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [202] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = screenlayer1::$13 -- _deref_pbuc1=vbum1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // cbm_k_plot_get()
    // [203] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [204] cbm_k_plot_get::return#10 = cbm_k_plot_get::return#0
    // screenlayer1::@2
    // [205] screenlayer1::$14 = cbm_k_plot_get::return#10
    // BYTE0(cbm_k_plot_get())
    // [206] screenlayer1::$15 = byte0  screenlayer1::$14 -- vbum1=_byte0_vwum2 
    lda __14
    sta __15
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [207] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = screenlayer1::$15 -- _deref_pbuc1=vbum1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // screenlayer1::@return
    // }
    // [208] return 
    rts
  .segment Data
    __0: .byte 0
    __1: .byte 0
    __2: .word 0
    __3: .byte 0
    .label __4 = __3
    __5: .byte 0
    .label __6 = __5
    __7: .byte 0
    .label __8 = __7
    .label __9 = __7
    __10: .byte 0
    .label __11 = __10
    .label __12 = cbm_k_plot_get.return
    __13: .byte 0
    .label __14 = cbm_k_plot_get.return
    __15: .byte 0
    .label __16 = __3
    .label __17 = __5
    .label __18 = __10
}
.segment Code
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char textcolor(__mem() char color)
textcolor: {
    // __conio.color & 0xF0
    // [210] textcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) & $f0 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta __0
    // __conio.color & 0xF0 | color
    // [211] textcolor::$1 = textcolor::$0 | textcolor::color#6 -- vbum1=vbum2_bor_vbum1 
    lda __1
    ora __0
    sta __1
    // __conio.color = __conio.color & 0xF0 | color
    // [212] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) = textcolor::$1 -- _deref_pbuc1=vbum1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    // textcolor::@return
    // }
    // [213] return 
    rts
  .segment Data
    __0: .byte 0
    .label __1 = color
    color: .byte 0
}
.segment Code
  // bgcolor
// Set the back color for text output. The old back text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor(__mem() char color)
bgcolor: {
    // __conio.color & 0x0F
    // [215] bgcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) & $f -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$f
    and __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta __0
    // color << 4
    // [216] bgcolor::$1 = bgcolor::color#4 << 4 -- vbum1=vbum1_rol_4 
    lda __1
    asl
    asl
    asl
    asl
    sta __1
    // __conio.color & 0x0F | color << 4
    // [217] bgcolor::$2 = bgcolor::$0 | bgcolor::$1 -- vbum1=vbum1_bor_vbum2 
    lda __2
    ora __1
    sta __2
    // __conio.color = __conio.color & 0x0F | color << 4
    // [218] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) = bgcolor::$2 -- _deref_pbuc1=vbum1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    // bgcolor::@return
    // }
    // [219] return 
    rts
  .segment Data
    __0: .byte 0
    .label __1 = color
    .label __2 = __0
    color: .byte 0
}
.segment Code
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
// char cursor(char onoff)
cursor: {
    .const onoff = 0
    // __conio.cursor = onoff
    // [220] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR
    // cursor::@return
    // }
    // [221] return 
    rts
}
  // cbm_k_plot_get
/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
cbm_k_plot_get: {
    // unsigned char x
    // [222] cbm_k_plot_get::x = 0 -- vbum1=vbuc1 
    lda #0
    sta x
    // unsigned char y
    // [223] cbm_k_plot_get::y = 0 -- vbum1=vbuc1 
    sta y
    // kickasm
    // kickasm( uses cbm_k_plot_get::x uses cbm_k_plot_get::y uses CBM_PLOT) {{ sec         jsr CBM_PLOT         stx y         sty x      }}
    sec
        jsr CBM_PLOT
        stx y
        sty x
    
    // MAKEWORD(x,y)
    // [225] cbm_k_plot_get::return#0 = cbm_k_plot_get::x w= cbm_k_plot_get::y -- vwum1=vbum2_word_vbum3 
    lda x
    sta return+1
    lda y
    sta return
    // cbm_k_plot_get::@return
    // }
    // [226] return 
    rts
  .segment Data
    x: .byte 0
    y: .byte 0
    return: .word 0
}
.segment Code
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__mem() char x, __mem() char y)
gotoxy: {
    // if(y>__conio.height)
    // [228] if(gotoxy::y#8<=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto gotoxy::@3 -- vbum1_le__deref_pbuc1_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    cmp y
    bcs __b1
    // [230] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [230] phi gotoxy::y#10 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbum1=vbuc1 
    lda #0
    sta y
    // [229] phi from gotoxy to gotoxy::@3 [phi:gotoxy->gotoxy::@3]
    // gotoxy::@3
    // [230] phi from gotoxy::@3 to gotoxy::@1 [phi:gotoxy::@3->gotoxy::@1]
    // [230] phi gotoxy::y#10 = gotoxy::y#8 [phi:gotoxy::@3->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=__conio.width)
    // [231] if(gotoxy::x#10<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto gotoxy::@4 -- vbum1_lt__deref_pbuc1_then_la1 
    lda x
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    bcc __b2
    // [233] phi from gotoxy::@1 to gotoxy::@2 [phi:gotoxy::@1->gotoxy::@2]
    // [233] phi gotoxy::x#9 = 0 [phi:gotoxy::@1->gotoxy::@2#0] -- vbum1=vbuc1 
    lda #0
    sta x
    // [232] phi from gotoxy::@1 to gotoxy::@4 [phi:gotoxy::@1->gotoxy::@4]
    // gotoxy::@4
    // [233] phi from gotoxy::@4 to gotoxy::@2 [phi:gotoxy::@4->gotoxy::@2]
    // [233] phi gotoxy::x#9 = gotoxy::x#10 [phi:gotoxy::@4->gotoxy::@2#0] -- register_copy 
    // gotoxy::@2
  __b2:
    // __conio.cursor_x = x
    // [234] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = gotoxy::x#9 -- _deref_pbuc1=vbum1 
    lda x
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // __conio.cursor_y = y
    // [235] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = gotoxy::y#10 -- _deref_pbuc1=vbum1 
    lda y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // unsigned int line_offset = (unsigned int)y << __conio.rowshift
    // [236] gotoxy::$5 = (unsigned int)gotoxy::y#10 -- vwum1=_word_vbum2 
    lda y
    sta __5
    lda #0
    sta __5+1
    // [237] gotoxy::line_offset#0 = gotoxy::$5 << *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) -- vwum1=vwum1_rol__deref_pbuc1 
    ldy __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    beq !e+
  !:
    asl line_offset
    rol line_offset+1
    dey
    bne !-
  !e:
    // __conio.line = line_offset
    // [238] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) = gotoxy::line_offset#0 -- _deref_pwuc1=vwum1 
    lda line_offset
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    lda line_offset+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    // gotoxy::@return
    // }
    // [239] return 
    rts
  .segment Data
    __5: .word 0
    .label line_offset = __5
    x: .byte 0
    y: .byte 0
}
.segment Code
  // cputln
// Print a newline
cputln: {
    // unsigned int temp = __conio.line
    // [240] cputln::temp#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) -- vwum1=_deref_pwuc1 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta temp
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    sta temp+1
    // temp += __conio.rowskip
    // [241] cputln::temp#1 = cputln::temp#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda temp
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta temp
    lda temp+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta temp+1
    // __conio.line = temp
    // [242] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) = cputln::temp#1 -- _deref_pwuc1=vwum1 
    lda temp
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    lda temp+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    // __conio.cursor_x = 0
    // [243] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // __conio.cursor_y++;
    // [244] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = ++ *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // cscroll()
    // [245] call cscroll
    jsr cscroll
    // cputln::@return
    // }
    // [246] return 
    rts
  .segment Data
    temp: .word 0
}
.segment Code
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    // unsigned int line_text = __conio.mapbase_offset
    // [247] clrscr::line_text#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwum1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta line_text
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta line_text+1
    // char color = __conio.color
    // [248] clrscr::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbum1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta color
    // unsigned int mapheight = __conio.mapheight
    // [249] clrscr::mapheight#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT) -- vwum1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT
    sta mapheight
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT+1
    sta mapheight+1
    // unsigned int mapwidth = __conio.mapwidth
    // [250] clrscr::mapwidth#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) -- vwum1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    sta mapwidth
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    sta mapwidth+1
    // [251] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [251] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr->clrscr::@1#0] -- register_copy 
    // [251] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbum1=vbuc1 
    lda #0
    sta l
    // clrscr::@1
  __b1:
    // for( char l=0;l<mapheight; l++ )
    // [252] if(clrscr::l#2<clrscr::mapheight#0) goto clrscr::@2 -- vbum1_lt_vwum2_then_la1 
    lda mapheight+1
    bne __b2
    lda l
    cmp mapheight
    bcc __b2
    // clrscr::@3
    // __conio.cursor_x = 0
    // [253] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // __conio.cursor_y = 0
    // [254] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = 0 -- _deref_pbuc1=vbuc2 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // __conio.line = 0
    // [255] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) = 0 -- _deref_pwuc1=vbuc2 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    // clrscr::@return
    // }
    // [256] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [257] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(ch)
    // [258] clrscr::$1 = byte0  clrscr::line_text#2 -- vbum1=_byte0_vwum2 
    lda line_text
    sta __1
    // *VERA_ADDRX_L = BYTE0(ch)
    // [259] *VERA_ADDRX_L = clrscr::$1 -- _deref_pbuc1=vbum1 
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(ch)
    // [260] clrscr::$2 = byte1  clrscr::line_text#2 -- vbum1=_byte1_vwum2 
    lda line_text+1
    sta __2
    // *VERA_ADDRX_M = BYTE1(ch)
    // [261] *VERA_ADDRX_M = clrscr::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [262] clrscr::$3 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    sta __3
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [263] *VERA_ADDRX_H = clrscr::$3 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // [264] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [264] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbum1=vbuc1 
    lda #0
    sta c
    // clrscr::@4
  __b4:
    // for( char c=0;c<mapwidth; c++ )
    // [265] if(clrscr::c#2<clrscr::mapwidth#0) goto clrscr::@5 -- vbum1_lt_vwum2_then_la1 
    lda mapwidth+1
    bne __b5
    lda c
    cmp mapwidth
    bcc __b5
    // clrscr::@6
    // line_text += __conio.rowskip
    // [266] clrscr::line_text#1 = clrscr::line_text#2 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda line_text
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta line_text
    lda line_text+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta line_text+1
    // for( char l=0;l<mapheight; l++ )
    // [267] clrscr::l#1 = ++ clrscr::l#2 -- vbum1=_inc_vbum1 
    inc l
    // [251] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [251] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [251] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [268] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [269] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbum1 
    lda color
    sta VERA_DATA0
    // for( char c=0;c<mapwidth; c++ )
    // [270] clrscr::c#1 = ++ clrscr::c#2 -- vbum1=_inc_vbum1 
    inc c
    // [264] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [264] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
  .segment Data
    __1: .byte 0
    __2: .byte 0
    __3: .byte 0
    line_text: .word 0
    color: .byte 0
    mapheight: .word 0
    mapwidth: .word 0
    c: .byte 0
    l: .byte 0
}
.segment Code
  // printf_str
/// Print a NUL-terminated string
// void printf_str(void (*putc)(char), __zp($2c) const char *s)
printf_str: {
    .label s = $2c
    // [272] phi from printf_str printf_str::@2 to printf_str::@1 [phi:printf_str/printf_str::@2->printf_str::@1]
    // [272] phi printf_str::s#8 = printf_str::s#9 [phi:printf_str/printf_str::@2->printf_str::@1#0] -- register_copy 
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [273] printf_str::c#1 = *printf_str::s#8 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta c
    // [274] printf_str::s#0 = ++ printf_str::s#8 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [275] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbum1_then_la1 
    lda c
    bne __b2
    // printf_str::@return
    // }
    // [276] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [277] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbum1 
    lda c
    pha
    // [278] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
  .segment Data
    c: .byte 0
}
.segment Code
  // vera_layer0_mode_bitmap
// Set a vera layer in bitmap mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - mapwidth: The width of the map, which can be 320 or 640.
// - color_depth: The color color depth, which can have values 1, 2, 4, 8, for 1 color, 4 colors, 16 colors or 256 colors respectively.
// void vera_layer0_mode_bitmap(char tilebase_bank, unsigned int tilebase_offset, char tilewidth, char color_depth)
vera_layer0_mode_bitmap: {
    .const color_depth = 1
    // *VERA_L0_CONFIG | VERA_LAYER_CONFIG_MODE_BITMAP
    // [280] vera_layer0_mode_bitmap::$0 = *VERA_L0_CONFIG | VERA_LAYER_CONFIG_MODE_BITMAP -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_CONFIG_MODE_BITMAP
    ora VERA_L0_CONFIG
    sta __0
    // *VERA_L0_CONFIG = *VERA_L0_CONFIG | VERA_LAYER_CONFIG_MODE_BITMAP
    // [281] *VERA_L0_CONFIG = vera_layer0_mode_bitmap::$0 -- _deref_pbuc1=vbum1 
    sta VERA_L0_CONFIG
    // vera_layer0_mode_bitmap::vera_layer0_set_tile_width1
    // *VERA_L0_TILEBASE &= ~VERA_TILEBASE_WIDTH_MASK
    // [282] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE & ~VERA_TILEBASE_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_WIDTH_MASK^$ff
    and VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // *VERA_L0_TILEBASE |= tilewidth
    // [283] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L0_TILEBASE
    // vera_layer0_mode_bitmap::vera_layer0_set_tilebase1
    // *VERA_L0_TILEBASE &= ~VERA_LAYER_TILEBASE_MASK
    // [284] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE & ~VERA_LAYER_TILEBASE_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_TILEBASE_MASK^$ff
    and VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // *VERA_L0_TILEBASE |= ((tilebase_bank << 7) | BYTE1(tilebase_offset)>>1)
    // [285] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L0_TILEBASE
    // vera_layer0_mode_bitmap::vera_layer0_set_color_depth1
    // *VERA_L0_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK
    // [286] *VERA_L0_CONFIG = *VERA_L0_CONFIG & ~VERA_LAYER_COLOR_DEPTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_MASK^$ff
    and VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // *VERA_L0_CONFIG |= bpp
    // [287] *VERA_L0_CONFIG = *VERA_L0_CONFIG | vera_layer0_mode_bitmap::color_depth#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #color_depth
    ora VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // vera_layer0_mode_bitmap::vera_display_set_scale_double1
    // *VERA_DC_HSCALE = 64
    // [288] *VERA_DC_HSCALE = $40 -- _deref_pbuc1=vbuc2 
    lda #$40
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 64
    // [289] *VERA_DC_VSCALE = $40 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // vera_layer0_mode_bitmap::@return
    // }
    // [290] return 
    rts
  .segment Data
    __0: .byte 0
}
.segment Code
  // bitmap_init
// Initialize the bitmap plotter tables for a specific bitmap
// void bitmap_init(char layer, char bank, unsigned int offset)
bitmap_init: {
    .const layer = 0
    .label __32 = $2a
    .label __33 = $28
    .label __34 = $22
    .label __35 = $24
    .label __36 = $26
    .label __37 = $2e
    .label __38 = $30
    .label __39 = $32
    .label __40 = $34
    .label __41 = $36
    .label __42 = $38
    .label __43 = $3a
    .label __44 = $2c
    // __bitmap.address = MAKELONG(offset, bank)
    // [291] *((unsigned long *)&__bitmap+$1180) = 0 -- _deref_pduc1=vbuc2 
    lda #0
    sta __bitmap+$1180
    sta __bitmap+$1180+1
    sta __bitmap+$1180+2
    sta __bitmap+$1180+3
    // __bitmap.layer = layer
    // [292] *((char *)&__bitmap+$1184) = bitmap_init::layer#0 -- _deref_pbuc1=vbuc2 
    lda #layer
    sta __bitmap+$1184
    // bitmap_init::@2
    // *VERA_L0_CONFIG & VERA_LAYER_COLOR_DEPTH_MASK
    // [293] bitmap_init::$5 = *VERA_L0_CONFIG & VERA_LAYER_COLOR_DEPTH_MASK -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_MASK
    and VERA_L0_CONFIG
    sta __5
    // __bitmap.color_depth = (*VERA_L0_CONFIG & VERA_LAYER_COLOR_DEPTH_MASK)
    // [294] *((char *)&__bitmap+$1187) = bitmap_init::$5 -- _deref_pbuc1=vbum1 
    sta __bitmap+$1187
    // [295] phi from bitmap_init::@2 to bitmap_init::@1 [phi:bitmap_init::@2->bitmap_init::@1]
    // bitmap_init::@1
    // bitmap_hscale()
    // [296] call bitmap_hscale
    // [494] phi from bitmap_init::@1 to bitmap_hscale [phi:bitmap_init::@1->bitmap_hscale]
    jsr bitmap_hscale
    // bitmap_hscale()
    // [297] bitmap_hscale::return#0 = bitmap_hscale::return#1
    // bitmap_init::@20
    // [298] bitmap_init::$1 = bitmap_hscale::return#0
    // __bitmap.hscale = bitmap_hscale()
    // [299] *((char *)&__bitmap+$1185) = bitmap_init::$1 -- _deref_pbuc1=vbum1 
    lda __1
    sta __bitmap+$1185
    // bitmap_vscale()
    // [300] call bitmap_vscale
    // [501] phi from bitmap_init::@20 to bitmap_vscale [phi:bitmap_init::@20->bitmap_vscale]
    jsr bitmap_vscale
    // bitmap_vscale()
    // [301] bitmap_vscale::return#0 = bitmap_vscale::return#1
    // bitmap_init::@21
    // [302] bitmap_init::$2 = bitmap_vscale::return#0
    // __bitmap.vscale = bitmap_vscale()
    // [303] *((char *)&__bitmap+$1186) = bitmap_init::$2 -- _deref_pbuc1=vbum1 
    // Returns 1 when 640 and 2 when 320, 3 when 160.
    lda __2
    sta __bitmap+$1186
    // unsigned char bitmask = bitmasks[__bitmap.color_depth]
    // [304] bitmap_init::bitmask#0 = bitmasks[*((char *)&__bitmap+$1187)] -- vbum1=pbuc1_derefidx_(_deref_pbuc2) 
    // Returns 1 when 480 and 2 when 240, 3 when 160.
    ldy __bitmap+$1187
    lda bitmasks,y
    sta bitmask
    // signed char bitshift = bitshifts[__bitmap.color_depth]
    // [305] bitmap_init::bitshift#0 = bitshifts[*((char *)&__bitmap+$1187)] -- vbsm1=pbsc1_derefidx_(_deref_pbuc2) 
    lda bitshifts,y
    sta bitshift
    // [306] phi from bitmap_init::@21 to bitmap_init::@3 [phi:bitmap_init::@21->bitmap_init::@3]
    // [306] phi bitmap_init::bitshift#10 = bitmap_init::bitshift#0 [phi:bitmap_init::@21->bitmap_init::@3#0] -- register_copy 
    // [306] phi bitmap_init::bitmask#10 = bitmap_init::bitmask#0 [phi:bitmap_init::@21->bitmap_init::@3#1] -- register_copy 
    // [306] phi bitmap_init::x#10 = 0 [phi:bitmap_init::@21->bitmap_init::@3#2] -- vwum1=vwuc1 
    lda #<0
    sta x
    sta x+1
    // bitmap_init::@3
  __b3:
    // for(unsigned int x=0; x<630; x++)
    // [307] if(bitmap_init::x#10<$276) goto bitmap_init::@4 -- vwum1_lt_vwuc1_then_la1 
    lda x+1
    cmp #>$276
    bcs !__b4+
    jmp __b4
  !__b4:
    bne !+
    lda x
    cmp #<$276
    bcs !__b4+
    jmp __b4
  !__b4:
  !:
    // bitmap_init::@5
    // __bitmap.color_depth<<2
    // [308] bitmap_init::$3 = *((char *)&__bitmap+$1187) << 2 -- vbum1=_deref_pbuc1_rol_2 
    lda __bitmap+$1187
    asl
    asl
    sta __3
    // (__bitmap.color_depth<<2)+__bitmap.hscale
    // [309] bitmap_init::$4 = bitmap_init::$3 + *((char *)&__bitmap+$1185) -- vbum1=vbum1_plus__deref_pbuc1 
    lda __bitmap+$1185
    clc
    adc __4
    sta __4
    // unsigned int hdelta = hdeltas[(__bitmap.color_depth<<2)+__bitmap.hscale]
    // [310] bitmap_init::$25 = bitmap_init::$4 << 1 -- vbum1=vbum1_rol_1 
    asl __25
    // [311] bitmap_init::hdelta#0 = hdeltas[bitmap_init::$25] -- vwum1=pwuc1_derefidx_vbum2 
    // This sets the right delta to skip a whole line based on the scale, depending on the color depth.
    ldy __25
    lda hdeltas,y
    sta hdelta
    lda hdeltas+1,y
    sta hdelta+1
    // unsigned long yoffs = __bitmap.address
    // [312] bitmap_init::yoffs#0 = *((unsigned long *)&__bitmap+$1180) -- vdum1=_deref_pduc1 
    // We start at the bitmap offset; The plot_y contains the bitmap offset embedded so we know where a line starts.
    lda __bitmap+$1180
    sta yoffs
    lda __bitmap+$1180+1
    sta yoffs+1
    lda __bitmap+$1180+2
    sta yoffs+2
    lda __bitmap+$1180+3
    sta yoffs+3
    // [313] phi from bitmap_init::@5 to bitmap_init::@18 [phi:bitmap_init::@5->bitmap_init::@18]
    // [313] phi bitmap_init::yoffs#2 = bitmap_init::yoffs#0 [phi:bitmap_init::@5->bitmap_init::@18#0] -- register_copy 
    // [313] phi bitmap_init::y#2 = 0 [phi:bitmap_init::@5->bitmap_init::@18#1] -- vwum1=vwuc1 
    lda #<0
    sta y
    sta y+1
    // bitmap_init::@18
  __b18:
    // for(unsigned int y=0; y<479; y++)
    // [314] if(bitmap_init::y#2<$1df) goto bitmap_init::@19 -- vwum1_lt_vwuc1_then_la1 
    lda y+1
    cmp #>$1df
    bcc __b19
    bne !+
    lda y
    cmp #<$1df
    bcc __b19
  !:
    // bitmap_init::@return
    // }
    // [315] return 
    rts
    // bitmap_init::@19
  __b19:
    // __bitmap.plot_y[y] = yoffs
    // [316] bitmap_init::$30 = bitmap_init::y#2 << 2 -- vwum1=vwum2_rol_2 
    lda y
    asl
    sta __30
    lda y+1
    rol
    sta __30+1
    asl __30
    rol __30+1
    // [317] bitmap_init::$44 = (unsigned long *)&__bitmap+$500 + bitmap_init::$30 -- pduz1=pduc1_plus_vwum2 
    lda __30
    clc
    adc #<__bitmap+$500
    sta.z __44
    lda __30+1
    adc #>__bitmap+$500
    sta.z __44+1
    // [318] *bitmap_init::$44 = bitmap_init::yoffs#2 -- _deref_pduz1=vdum2 
    ldy #0
    lda yoffs
    sta (__44),y
    iny
    lda yoffs+1
    sta (__44),y
    iny
    lda yoffs+2
    sta (__44),y
    iny
    lda yoffs+3
    sta (__44),y
    // yoffs = yoffs + hdelta
    // [319] bitmap_init::yoffs#1 = bitmap_init::yoffs#2 + bitmap_init::hdelta#0 -- vdum1=vdum1_plus_vwum2 
    lda yoffs
    clc
    adc hdelta
    sta yoffs
    lda yoffs+1
    adc hdelta+1
    sta yoffs+1
    lda yoffs+2
    adc #0
    sta yoffs+2
    lda yoffs+3
    adc #0
    sta yoffs+3
    // for(unsigned int y=0; y<479; y++)
    // [320] bitmap_init::y#1 = ++ bitmap_init::y#2 -- vwum1=_inc_vwum1 
    inc y
    bne !+
    inc y+1
  !:
    // [313] phi from bitmap_init::@19 to bitmap_init::@18 [phi:bitmap_init::@19->bitmap_init::@18]
    // [313] phi bitmap_init::yoffs#2 = bitmap_init::yoffs#1 [phi:bitmap_init::@19->bitmap_init::@18#0] -- register_copy 
    // [313] phi bitmap_init::y#2 = bitmap_init::y#1 [phi:bitmap_init::@19->bitmap_init::@18#1] -- register_copy 
    jmp __b18
    // bitmap_init::@4
  __b4:
    // if(__bitmap.color_depth==0)
    // [321] if(*((char *)&__bitmap+$1187)!=0) goto bitmap_init::@6 -- _deref_pbuc1_neq_0_then_la1 
    lda __bitmap+$1187
    bne __b6
    // bitmap_init::@12
    // x >> 3
    // [322] bitmap_init::$10 = bitmap_init::x#10 >> 3 -- vwum1=vwum2_ror_3 
    lda x+1
    lsr
    sta __10+1
    lda x
    ror
    sta __10
    lsr __10+1
    ror __10
    lsr __10+1
    ror __10
    // __bitmap.plot_x[x] = (x >> 3)
    // [323] bitmap_init::$26 = bitmap_init::x#10 << 1 -- vwum1=vwum2_rol_1 
    lda x
    asl
    sta __26
    lda x+1
    rol
    sta __26+1
    // [324] bitmap_init::$32 = (unsigned int *)&__bitmap + bitmap_init::$26 -- pwuz1=pwuc1_plus_vwum2 
    lda __26
    clc
    adc #<__bitmap
    sta.z __32
    lda __26+1
    adc #>__bitmap
    sta.z __32+1
    // [325] *bitmap_init::$32 = bitmap_init::$10 -- _deref_pwuz1=vwum2 
    ldy #0
    lda __10
    sta (__32),y
    iny
    lda __10+1
    sta (__32),y
    // __bitmap.plot_bitmask[x] = bitmask
    // [326] bitmap_init::$33 = (char *)&__bitmap+$c80 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwum2 
    lda x
    clc
    adc #<__bitmap+$c80
    sta.z __33
    lda x+1
    adc #>__bitmap+$c80
    sta.z __33+1
    // [327] *bitmap_init::$33 = bitmap_init::bitmask#10 -- _deref_pbuz1=vbum2 
    lda bitmask
    ldy #0
    sta (__33),y
    // __bitmap.plot_bitshift[x] = (unsigned char)bitshift
    // [328] bitmap_init::$34 = (char *)&__bitmap+$f00 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwum2 
    lda x
    clc
    adc #<__bitmap+$f00
    sta.z __34
    lda x+1
    adc #>__bitmap+$f00
    sta.z __34+1
    // [329] *bitmap_init::$34 = (char)bitmap_init::bitshift#10 -- _deref_pbuz1=vbum2 
    lda bitshift
    sta (__34),y
    // bitshift -= 1
    // [330] bitmap_init::bitshift#1 = bitmap_init::bitshift#10 - 1 -- vbsm1=vbsm1_minus_1 
    dec bitshift
    // bitmask >>= 1
    // [331] bitmap_init::bitmask#1 = bitmap_init::bitmask#10 >> 1 -- vbum1=vbum1_ror_1 
    lsr bitmask
    // [332] phi from bitmap_init::@12 bitmap_init::@4 to bitmap_init::@6 [phi:bitmap_init::@12/bitmap_init::@4->bitmap_init::@6]
    // [332] phi bitmap_init::bitshift#11 = bitmap_init::bitshift#1 [phi:bitmap_init::@12/bitmap_init::@4->bitmap_init::@6#0] -- register_copy 
    // [332] phi bitmap_init::bitmask#11 = bitmap_init::bitmask#1 [phi:bitmap_init::@12/bitmap_init::@4->bitmap_init::@6#1] -- register_copy 
    // bitmap_init::@6
  __b6:
    // if(__bitmap.color_depth==1)
    // [333] if(*((char *)&__bitmap+$1187)!=1) goto bitmap_init::@7 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #1
    cmp __bitmap+$1187
    bne __b7
    // bitmap_init::@13
    // x >> 2
    // [334] bitmap_init::$13 = bitmap_init::x#10 >> 2 -- vwum1=vwum2_ror_2 
    lda x+1
    lsr
    sta __13+1
    lda x
    ror
    sta __13
    lsr __13+1
    ror __13
    // __bitmap.plot_x[x] = (x >> 2)
    // [335] bitmap_init::$27 = bitmap_init::x#10 << 1 -- vwum1=vwum2_rol_1 
    lda x
    asl
    sta __27
    lda x+1
    rol
    sta __27+1
    // [336] bitmap_init::$35 = (unsigned int *)&__bitmap + bitmap_init::$27 -- pwuz1=pwuc1_plus_vwum2 
    lda __27
    clc
    adc #<__bitmap
    sta.z __35
    lda __27+1
    adc #>__bitmap
    sta.z __35+1
    // [337] *bitmap_init::$35 = bitmap_init::$13 -- _deref_pwuz1=vwum2 
    ldy #0
    lda __13
    sta (__35),y
    iny
    lda __13+1
    sta (__35),y
    // __bitmap.plot_bitmask[x] = bitmask
    // [338] bitmap_init::$36 = (char *)&__bitmap+$c80 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwum2 
    lda x
    clc
    adc #<__bitmap+$c80
    sta.z __36
    lda x+1
    adc #>__bitmap+$c80
    sta.z __36+1
    // [339] *bitmap_init::$36 = bitmap_init::bitmask#11 -- _deref_pbuz1=vbum2 
    lda bitmask
    ldy #0
    sta (__36),y
    // __bitmap.plot_bitshift[x] = (unsigned char)bitshift
    // [340] bitmap_init::$37 = (char *)&__bitmap+$f00 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwum2 
    lda x
    clc
    adc #<__bitmap+$f00
    sta.z __37
    lda x+1
    adc #>__bitmap+$f00
    sta.z __37+1
    // [341] *bitmap_init::$37 = (char)bitmap_init::bitshift#11 -- _deref_pbuz1=vbum2 
    lda bitshift
    sta (__37),y
    // bitshift -= 2
    // [342] bitmap_init::bitshift#2 = bitmap_init::bitshift#11 - 2 -- vbsm1=vbsm1_minus_2 
    dec bitshift
    dec bitshift
    // bitmask >>= 2
    // [343] bitmap_init::bitmask#2 = bitmap_init::bitmask#11 >> 2 -- vbum1=vbum1_ror_2 
    lda bitmask
    lsr
    lsr
    sta bitmask
    // [344] phi from bitmap_init::@13 bitmap_init::@6 to bitmap_init::@7 [phi:bitmap_init::@13/bitmap_init::@6->bitmap_init::@7]
    // [344] phi bitmap_init::bitshift#12 = bitmap_init::bitshift#2 [phi:bitmap_init::@13/bitmap_init::@6->bitmap_init::@7#0] -- register_copy 
    // [344] phi bitmap_init::bitmask#12 = bitmap_init::bitmask#2 [phi:bitmap_init::@13/bitmap_init::@6->bitmap_init::@7#1] -- register_copy 
    // bitmap_init::@7
  __b7:
    // if(__bitmap.color_depth==2)
    // [345] if(*((char *)&__bitmap+$1187)!=2) goto bitmap_init::@8 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #2
    cmp __bitmap+$1187
    bne __b8
    // bitmap_init::@14
    // x >> 1
    // [346] bitmap_init::$16 = bitmap_init::x#10 >> 1 -- vwum1=vwum2_ror_1 
    lda x+1
    lsr
    sta __16+1
    lda x
    ror
    sta __16
    // __bitmap.plot_x[x] = (x >> 1)
    // [347] bitmap_init::$28 = bitmap_init::x#10 << 1 -- vwum1=vwum2_rol_1 
    lda x
    asl
    sta __28
    lda x+1
    rol
    sta __28+1
    // [348] bitmap_init::$38 = (unsigned int *)&__bitmap + bitmap_init::$28 -- pwuz1=pwuc1_plus_vwum2 
    lda __28
    clc
    adc #<__bitmap
    sta.z __38
    lda __28+1
    adc #>__bitmap
    sta.z __38+1
    // [349] *bitmap_init::$38 = bitmap_init::$16 -- _deref_pwuz1=vwum2 
    ldy #0
    lda __16
    sta (__38),y
    iny
    lda __16+1
    sta (__38),y
    // __bitmap.plot_bitmask[x] = bitmask
    // [350] bitmap_init::$39 = (char *)&__bitmap+$c80 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwum2 
    lda x
    clc
    adc #<__bitmap+$c80
    sta.z __39
    lda x+1
    adc #>__bitmap+$c80
    sta.z __39+1
    // [351] *bitmap_init::$39 = bitmap_init::bitmask#12 -- _deref_pbuz1=vbum2 
    lda bitmask
    ldy #0
    sta (__39),y
    // __bitmap.plot_bitshift[x] = (unsigned char)bitshift
    // [352] bitmap_init::$40 = (char *)&__bitmap+$f00 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwum2 
    lda x
    clc
    adc #<__bitmap+$f00
    sta.z __40
    lda x+1
    adc #>__bitmap+$f00
    sta.z __40+1
    // [353] *bitmap_init::$40 = (char)bitmap_init::bitshift#12 -- _deref_pbuz1=vbum2 
    lda bitshift
    sta (__40),y
    // bitshift -= 4
    // [354] bitmap_init::bitshift#3 = bitmap_init::bitshift#12 - 4 -- vbsm1=vbsm1_minus_vbsc1 
    sec
    sbc #4
    sta bitshift
    // bitmask >>= 4
    // [355] bitmap_init::bitmask#3 = bitmap_init::bitmask#12 >> 4 -- vbum1=vbum1_ror_4 
    lda bitmask
    lsr
    lsr
    lsr
    lsr
    sta bitmask
    // [356] phi from bitmap_init::@14 bitmap_init::@7 to bitmap_init::@8 [phi:bitmap_init::@14/bitmap_init::@7->bitmap_init::@8]
    // [356] phi bitmap_init::bitmask#13 = bitmap_init::bitmask#3 [phi:bitmap_init::@14/bitmap_init::@7->bitmap_init::@8#0] -- register_copy 
    // [356] phi bitmap_init::bitshift#13 = bitmap_init::bitshift#3 [phi:bitmap_init::@14/bitmap_init::@7->bitmap_init::@8#1] -- register_copy 
    // bitmap_init::@8
  __b8:
    // if(__bitmap.color_depth==3)
    // [357] if(*((char *)&__bitmap+$1187)!=3) goto bitmap_init::@9 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #3
    cmp __bitmap+$1187
    bne __b9
    // bitmap_init::@15
    // __bitmap.plot_x[x] = x
    // [358] bitmap_init::$29 = bitmap_init::x#10 << 1 -- vwum1=vwum2_rol_1 
    lda x
    asl
    sta __29
    lda x+1
    rol
    sta __29+1
    // [359] bitmap_init::$41 = (unsigned int *)&__bitmap + bitmap_init::$29 -- pwuz1=pwuc1_plus_vwum2 
    lda __29
    clc
    adc #<__bitmap
    sta.z __41
    lda __29+1
    adc #>__bitmap
    sta.z __41+1
    // [360] *bitmap_init::$41 = bitmap_init::x#10 -- _deref_pwuz1=vwum2 
    ldy #0
    lda x
    sta (__41),y
    iny
    lda x+1
    sta (__41),y
    // __bitmap.plot_bitmask[x] = bitmask
    // [361] bitmap_init::$42 = (char *)&__bitmap+$c80 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwum2 
    lda x
    clc
    adc #<__bitmap+$c80
    sta.z __42
    lda x+1
    adc #>__bitmap+$c80
    sta.z __42+1
    // [362] *bitmap_init::$42 = bitmap_init::bitmask#13 -- _deref_pbuz1=vbum2 
    lda bitmask
    ldy #0
    sta (__42),y
    // __bitmap.plot_bitshift[x] = (unsigned char)bitshift
    // [363] bitmap_init::$43 = (char *)&__bitmap+$f00 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwum2 
    lda x
    clc
    adc #<__bitmap+$f00
    sta.z __43
    lda x+1
    adc #>__bitmap+$f00
    sta.z __43+1
    // [364] *bitmap_init::$43 = (char)bitmap_init::bitshift#13 -- _deref_pbuz1=vbum2 
    lda bitshift
    sta (__43),y
    // bitmap_init::@9
  __b9:
    // if(bitshift<0)
    // [365] if(bitmap_init::bitshift#13>=0) goto bitmap_init::@10 -- vbsm1_ge_0_then_la1 
    lda bitshift
    cmp #0
    bpl __b10
    // bitmap_init::@16
    // bitshift = bitshifts[__bitmap.color_depth]
    // [366] bitmap_init::bitshift#4 = bitshifts[*((char *)&__bitmap+$1187)] -- vbsm1=pbsc1_derefidx_(_deref_pbuc2) 
    ldy __bitmap+$1187
    lda bitshifts,y
    sta bitshift
    // [367] phi from bitmap_init::@16 bitmap_init::@9 to bitmap_init::@10 [phi:bitmap_init::@16/bitmap_init::@9->bitmap_init::@10]
    // [367] phi bitmap_init::bitshift#15 = bitmap_init::bitshift#4 [phi:bitmap_init::@16/bitmap_init::@9->bitmap_init::@10#0] -- register_copy 
    // bitmap_init::@10
  __b10:
    // if(bitmask==0)
    // [368] if(bitmap_init::bitmask#13!=0) goto bitmap_init::@11 -- vbum1_neq_0_then_la1 
    lda bitmask
    bne __b11
    // bitmap_init::@17
    // bitmask = bitmasks[__bitmap.color_depth]
    // [369] bitmap_init::bitmask#4 = bitmasks[*((char *)&__bitmap+$1187)] -- vbum1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy __bitmap+$1187
    lda bitmasks,y
    sta bitmask
    // [370] phi from bitmap_init::@10 bitmap_init::@17 to bitmap_init::@11 [phi:bitmap_init::@10/bitmap_init::@17->bitmap_init::@11]
    // [370] phi bitmap_init::bitmask#17 = bitmap_init::bitmask#13 [phi:bitmap_init::@10/bitmap_init::@17->bitmap_init::@11#0] -- register_copy 
    // bitmap_init::@11
  __b11:
    // for(unsigned int x=0; x<630; x++)
    // [371] bitmap_init::x#1 = ++ bitmap_init::x#10 -- vwum1=_inc_vwum1 
    inc x
    bne !+
    inc x+1
  !:
    // [306] phi from bitmap_init::@11 to bitmap_init::@3 [phi:bitmap_init::@11->bitmap_init::@3]
    // [306] phi bitmap_init::bitshift#10 = bitmap_init::bitshift#15 [phi:bitmap_init::@11->bitmap_init::@3#0] -- register_copy 
    // [306] phi bitmap_init::bitmask#10 = bitmap_init::bitmask#17 [phi:bitmap_init::@11->bitmap_init::@3#1] -- register_copy 
    // [306] phi bitmap_init::x#10 = bitmap_init::x#1 [phi:bitmap_init::@11->bitmap_init::@3#2] -- register_copy 
    jmp __b3
  .segment Data
    .label __1 = bitmap_hscale.return
    .label __2 = bitmap_vscale.return
    __3: .byte 0
    .label __4 = __3
    __5: .byte 0
    __10: .word 0
    __13: .word 0
    __16: .word 0
    .label __25 = __3
    __26: .word 0
    __27: .word 0
    __28: .word 0
    __29: .word 0
    __30: .word 0
    bitmask: .byte 0
    bitshift: .byte 0
    hdelta: .word 0
    yoffs: .dword 0
    x: .word 0
    y: .word 0
}
.segment Code
  // bitmap_clear
// Clear all graphics on the bitmap
bitmap_clear: {
    // unsigned int vdelta = vdeltas[__bitmap.vscale]
    // [372] bitmap_clear::$7 = *((char *)&__bitmap+$1186) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda __bitmap+$1186
    asl
    sta __7
    // [373] bitmap_clear::vdelta#0 = vdeltas[bitmap_clear::$7] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda vdeltas,y
    sta vdelta
    lda vdeltas+1,y
    sta vdelta+1
    // __bitmap.color_depth<<2
    // [374] bitmap_clear::$0 = *((char *)&__bitmap+$1187) << 2 -- vbum1=_deref_pbuc1_rol_2 
    lda __bitmap+$1187
    asl
    asl
    sta __0
    // (__bitmap.color_depth<<2)+__bitmap.hscale
    // [375] bitmap_clear::$1 = bitmap_clear::$0 + *((char *)&__bitmap+$1185) -- vbum1=vbum1_plus__deref_pbuc1 
    lda __bitmap+$1185
    clc
    adc __1
    sta __1
    // unsigned int hdelta = hdeltas[(__bitmap.color_depth<<2)+__bitmap.hscale]
    // [376] bitmap_clear::$8 = bitmap_clear::$1 << 1 -- vbum1=vbum1_rol_1 
    asl __8
    // [377] bitmap_clear::hdelta#0 = hdeltas[bitmap_clear::$8] -- vwum1=pwuc1_derefidx_vbum2 
    ldy __8
    lda hdeltas,y
    sta hdelta
    lda hdeltas+1,y
    sta hdelta+1
    // hdelta = hdelta >> 1
    // [378] bitmap_clear::hdelta#1 = bitmap_clear::hdelta#0 >> 1 -- vwum1=vwum1_ror_1 
    lsr hdelta+1
    ror hdelta
    // mul16u(hdelta,vdelta)
    // [379] mul16u::a#0 = bitmap_clear::hdelta#1
    // [380] mul16u::b#0 = bitmap_clear::vdelta#0
    // [381] call mul16u
    jsr mul16u
    // [382] mul16u::return#0 = mul16u::res#2
    // bitmap_clear::@1
    // [383] bitmap_clear::$3 = mul16u::return#0
    // unsigned int count = (unsigned int)mul16u(hdelta,vdelta)
    // [384] bitmap_clear::count#0 = (unsigned int)bitmap_clear::$3 -- vwum1=_word_vdum2 
    lda __3
    sta count
    lda __3+1
    sta count+1
    // vram_bank_t vbank = BYTE3(__bitmap.address)
    // [385] bitmap_clear::vbank#0 = byte3  *((unsigned long *)&__bitmap+$1180) -- vbum1=_byte3__deref_pduc1 
    lda __bitmap+$1180+3
    sta vbank
    // vram_offset_t vdest = WORD0(__bitmap.address)
    // [386] bitmap_clear::vdest#0 = word0  *((unsigned long *)&__bitmap+$1180) -- vwum1=_word0__deref_pduc1 
    lda __bitmap+$1180
    sta vdest
    lda __bitmap+$1180+1
    sta vdest+1
    // memset_vram(vbank, vdest, 0, count)
    // [387] memset_vram::dbank_vram#0 = bitmap_clear::vbank#0
    // [388] memset_vram::doffset_vram#0 = bitmap_clear::vdest#0
    // [389] memset_vram::num#0 = bitmap_clear::count#0
    // [390] call memset_vram
    // [518] phi from bitmap_clear::@1 to memset_vram [phi:bitmap_clear::@1->memset_vram]
    jsr memset_vram
    // bitmap_clear::@return
    // }
    // [391] return 
    rts
  .segment Data
    __0: .byte 0
    .label __1 = __0
    .label __3 = mul16u.res
    __7: .byte 0
    .label __8 = __0
    vdelta: .word 0
    .label hdelta = mul16u.a
    count: .word 0
    vbank: .byte 0
    vdest: .word 0
}
.segment Code
  // kbhit
kbhit: {
    // getin()
    // [393] call getin
    jsr getin
    // [394] getin::return#2 = getin::return#1
    // kbhit::@1
    // [395] kbhit::return#0 = getin::return#2
    // kbhit::@return
    // }
    // [396] return 
    rts
  .segment Data
    return: .byte 0
}
.segment Code
  // bitmap_line
// Draw a line on the bitmap
// void bitmap_line(__mem() unsigned int x0, __mem() unsigned int x1, __mem() unsigned int y0, __mem() unsigned int y1, __mem() char c)
bitmap_line: {
    // if(x0<x1)
    // [398] if(bitmap_line::x0#10<bitmap_line::x1#10) goto bitmap_line::@1 -- vwum1_lt_vwum2_then_la1 
    lda x0+1
    cmp x1+1
    bcs !__b1+
    jmp __b1
  !__b1:
    bne !+
    lda x0
    cmp x1
    bcs !__b1+
    jmp __b1
  !__b1:
  !:
    // bitmap_line::@2
    // xd = x0-x1
    // [399] bitmap_line::xd#2 = bitmap_line::x0#10 - bitmap_line::x1#10 -- vwum1=vwum2_minus_vwum3 
    lda x0
    sec
    sbc x1
    sta xd
    lda x0+1
    sbc x1+1
    sta xd+1
    // if(y0<y1)
    // [400] if(bitmap_line::y0#10<bitmap_line::y1#10) goto bitmap_line::@7 -- vwum1_lt_vwum2_then_la1 
    lda y0+1
    cmp y1+1
    bcs !__b7+
    jmp __b7
  !__b7:
    bne !+
    lda y0
    cmp y1
    bcc __b7
  !:
    // bitmap_line::@3
    // yd = y0-y1
    // [401] bitmap_line::yd#2 = bitmap_line::y0#10 - bitmap_line::y1#10 -- vwum1=vwum2_minus_vwum3 
    lda y0
    sec
    sbc y1
    sta yd_1
    lda y0+1
    sbc y1+1
    sta yd_1+1
    // if(yd<xd)
    // [402] if(bitmap_line::yd#2<bitmap_line::xd#2) goto bitmap_line::@8 -- vwum1_lt_vwum2_then_la1 
    cmp xd+1
    bcc __b8
    bne !+
    lda yd_1
    cmp xd
    bcc __b8
  !:
    // bitmap_line::@4
    // bitmap_line_ydxi(y1, x1, y0, yd, xd, c)
    // [403] bitmap_line_ydxi::y#0 = bitmap_line::y1#10 -- vwum1=vwum2 
    lda y1
    sta bitmap_line_ydxi.y
    lda y1+1
    sta bitmap_line_ydxi.y+1
    // [404] bitmap_line_ydxi::x#0 = bitmap_line::x1#10 -- vwum1=vwum2 
    lda x1
    sta bitmap_line_ydxi.x
    lda x1+1
    sta bitmap_line_ydxi.x+1
    // [405] bitmap_line_ydxi::y1#0 = bitmap_line::y0#10
    // [406] bitmap_line_ydxi::yd#0 = bitmap_line::yd#2
    // [407] bitmap_line_ydxi::xd#0 = bitmap_line::xd#2
    // [408] bitmap_line_ydxi::c#0 = bitmap_line::c#10
    // [409] call bitmap_line_ydxi
    // [540] phi from bitmap_line::@4 to bitmap_line_ydxi [phi:bitmap_line::@4->bitmap_line_ydxi]
    // [540] phi bitmap_line_ydxi::y1#6 = bitmap_line_ydxi::y1#0 [phi:bitmap_line::@4->bitmap_line_ydxi#0] -- register_copy 
    // [540] phi bitmap_line_ydxi::yd#5 = bitmap_line_ydxi::yd#0 [phi:bitmap_line::@4->bitmap_line_ydxi#1] -- register_copy 
    // [540] phi bitmap_line_ydxi::c#3 = bitmap_line_ydxi::c#0 [phi:bitmap_line::@4->bitmap_line_ydxi#2] -- register_copy 
    // [540] phi bitmap_line_ydxi::y#6 = bitmap_line_ydxi::y#0 [phi:bitmap_line::@4->bitmap_line_ydxi#3] -- register_copy 
    // [540] phi bitmap_line_ydxi::x#5 = bitmap_line_ydxi::x#0 [phi:bitmap_line::@4->bitmap_line_ydxi#4] -- register_copy 
    // [540] phi bitmap_line_ydxi::xd#2 = bitmap_line_ydxi::xd#0 [phi:bitmap_line::@4->bitmap_line_ydxi#5] -- register_copy 
    jsr bitmap_line_ydxi
    // bitmap_line::@return
    // }
    // [410] return 
    rts
    // bitmap_line::@8
  __b8:
    // bitmap_line_xdyi(x1, y1, x0, xd, yd, c)
    // [411] bitmap_line_xdyi::x#0 = bitmap_line::x1#10 -- vwum1=vwum2 
    lda x1
    sta bitmap_line_xdyi.x
    lda x1+1
    sta bitmap_line_xdyi.x+1
    // [412] bitmap_line_xdyi::y#0 = bitmap_line::y1#10
    // [413] bitmap_line_xdyi::x1#0 = bitmap_line::x0#10 -- vwum1=vwum2 
    lda x0
    sta bitmap_line_xdyi.x1
    lda x0+1
    sta bitmap_line_xdyi.x1+1
    // [414] bitmap_line_xdyi::xd#0 = bitmap_line::xd#2 -- vwum1=vwum2 
    lda xd
    sta bitmap_line_xdyi.xd
    lda xd+1
    sta bitmap_line_xdyi.xd+1
    // [415] bitmap_line_xdyi::yd#0 = bitmap_line::yd#2 -- vwum1=vwum2 
    lda yd_1
    sta bitmap_line_xdyi.yd
    lda yd_1+1
    sta bitmap_line_xdyi.yd+1
    // [416] bitmap_line_xdyi::c#0 = bitmap_line::c#10 -- vbum1=vbum2 
    lda c
    sta bitmap_line_xdyi.c
    // [417] call bitmap_line_xdyi
    // [556] phi from bitmap_line::@8 to bitmap_line_xdyi [phi:bitmap_line::@8->bitmap_line_xdyi]
    // [556] phi bitmap_line_xdyi::x1#6 = bitmap_line_xdyi::x1#0 [phi:bitmap_line::@8->bitmap_line_xdyi#0] -- register_copy 
    // [556] phi bitmap_line_xdyi::xd#5 = bitmap_line_xdyi::xd#0 [phi:bitmap_line::@8->bitmap_line_xdyi#1] -- register_copy 
    // [556] phi bitmap_line_xdyi::c#3 = bitmap_line_xdyi::c#0 [phi:bitmap_line::@8->bitmap_line_xdyi#2] -- register_copy 
    // [556] phi bitmap_line_xdyi::y#5 = bitmap_line_xdyi::y#0 [phi:bitmap_line::@8->bitmap_line_xdyi#3] -- register_copy 
    // [556] phi bitmap_line_xdyi::x#6 = bitmap_line_xdyi::x#0 [phi:bitmap_line::@8->bitmap_line_xdyi#4] -- register_copy 
    // [556] phi bitmap_line_xdyi::yd#2 = bitmap_line_xdyi::yd#0 [phi:bitmap_line::@8->bitmap_line_xdyi#5] -- register_copy 
    jsr bitmap_line_xdyi
    rts
    // bitmap_line::@7
  __b7:
    // yd = y1-y0
    // [418] bitmap_line::yd#1 = bitmap_line::y1#10 - bitmap_line::y0#10 -- vwum1=vwum2_minus_vwum3 
    lda y1
    sec
    sbc y0
    sta yd
    lda y1+1
    sbc y0+1
    sta yd+1
    // if(yd<xd)
    // [419] if(bitmap_line::yd#1<bitmap_line::xd#2) goto bitmap_line::@9 -- vwum1_lt_vwum2_then_la1 
    cmp xd+1
    bcc __b9
    bne !+
    lda yd
    cmp xd
    bcc __b9
  !:
    // bitmap_line::@10
    // bitmap_line_ydxd(y0, x0, y1, yd, xd, c)
    // [420] bitmap_line_ydxd::y#0 = bitmap_line::y0#10 -- vwum1=vwum2 
    lda y0
    sta bitmap_line_ydxd.y
    lda y0+1
    sta bitmap_line_ydxd.y+1
    // [421] bitmap_line_ydxd::x#0 = bitmap_line::x0#10 -- vwum1=vwum2 
    lda x0
    sta bitmap_line_ydxd.x
    lda x0+1
    sta bitmap_line_ydxd.x+1
    // [422] bitmap_line_ydxd::y1#0 = bitmap_line::y1#10 -- vwum1=vwum2 
    lda y1
    sta bitmap_line_ydxd.y1
    lda y1+1
    sta bitmap_line_ydxd.y1+1
    // [423] bitmap_line_ydxd::yd#0 = bitmap_line::yd#1
    // [424] bitmap_line_ydxd::xd#0 = bitmap_line::xd#2 -- vwum1=vwum2 
    lda xd
    sta bitmap_line_ydxd.xd
    lda xd+1
    sta bitmap_line_ydxd.xd+1
    // [425] bitmap_line_ydxd::c#0 = bitmap_line::c#10 -- vbum1=vbum2 
    lda c
    sta bitmap_line_ydxd.c
    // [426] call bitmap_line_ydxd
    // [572] phi from bitmap_line::@10 to bitmap_line_ydxd [phi:bitmap_line::@10->bitmap_line_ydxd]
    // [572] phi bitmap_line_ydxd::y1#6 = bitmap_line_ydxd::y1#0 [phi:bitmap_line::@10->bitmap_line_ydxd#0] -- register_copy 
    // [572] phi bitmap_line_ydxd::yd#5 = bitmap_line_ydxd::yd#0 [phi:bitmap_line::@10->bitmap_line_ydxd#1] -- register_copy 
    // [572] phi bitmap_line_ydxd::c#3 = bitmap_line_ydxd::c#0 [phi:bitmap_line::@10->bitmap_line_ydxd#2] -- register_copy 
    // [572] phi bitmap_line_ydxd::y#7 = bitmap_line_ydxd::y#0 [phi:bitmap_line::@10->bitmap_line_ydxd#3] -- register_copy 
    // [572] phi bitmap_line_ydxd::x#5 = bitmap_line_ydxd::x#0 [phi:bitmap_line::@10->bitmap_line_ydxd#4] -- register_copy 
    // [572] phi bitmap_line_ydxd::xd#2 = bitmap_line_ydxd::xd#0 [phi:bitmap_line::@10->bitmap_line_ydxd#5] -- register_copy 
    jsr bitmap_line_ydxd
    rts
    // bitmap_line::@9
  __b9:
    // bitmap_line_xdyd(x1, y1, x0, xd, yd, c)
    // [427] bitmap_line_xdyd::x#0 = bitmap_line::x1#10 -- vwum1=vwum2 
    lda x1
    sta bitmap_line_xdyd.x
    lda x1+1
    sta bitmap_line_xdyd.x+1
    // [428] bitmap_line_xdyd::y#0 = bitmap_line::y1#10 -- vwum1=vwum2 
    lda y1
    sta bitmap_line_xdyd.y
    lda y1+1
    sta bitmap_line_xdyd.y+1
    // [429] bitmap_line_xdyd::x1#0 = bitmap_line::x0#10 -- vwum1=vwum2 
    lda x0
    sta bitmap_line_xdyd.x1
    lda x0+1
    sta bitmap_line_xdyd.x1+1
    // [430] bitmap_line_xdyd::xd#0 = bitmap_line::xd#2 -- vwum1=vwum2 
    lda xd
    sta bitmap_line_xdyd.xd
    lda xd+1
    sta bitmap_line_xdyd.xd+1
    // [431] bitmap_line_xdyd::yd#0 = bitmap_line::yd#1 -- vwum1=vwum2 
    lda yd
    sta bitmap_line_xdyd.yd
    lda yd+1
    sta bitmap_line_xdyd.yd+1
    // [432] bitmap_line_xdyd::c#0 = bitmap_line::c#10 -- vbum1=vbum2 
    lda c
    sta bitmap_line_xdyd.c
    // [433] call bitmap_line_xdyd
    // [588] phi from bitmap_line::@9 to bitmap_line_xdyd [phi:bitmap_line::@9->bitmap_line_xdyd]
    // [588] phi bitmap_line_xdyd::x1#6 = bitmap_line_xdyd::x1#0 [phi:bitmap_line::@9->bitmap_line_xdyd#0] -- register_copy 
    // [588] phi bitmap_line_xdyd::xd#5 = bitmap_line_xdyd::xd#0 [phi:bitmap_line::@9->bitmap_line_xdyd#1] -- register_copy 
    // [588] phi bitmap_line_xdyd::c#3 = bitmap_line_xdyd::c#0 [phi:bitmap_line::@9->bitmap_line_xdyd#2] -- register_copy 
    // [588] phi bitmap_line_xdyd::y#5 = bitmap_line_xdyd::y#0 [phi:bitmap_line::@9->bitmap_line_xdyd#3] -- register_copy 
    // [588] phi bitmap_line_xdyd::x#6 = bitmap_line_xdyd::x#0 [phi:bitmap_line::@9->bitmap_line_xdyd#4] -- register_copy 
    // [588] phi bitmap_line_xdyd::yd#2 = bitmap_line_xdyd::yd#0 [phi:bitmap_line::@9->bitmap_line_xdyd#5] -- register_copy 
    jsr bitmap_line_xdyd
    rts
    // bitmap_line::@1
  __b1:
    // xd = x1-x0
    // [434] bitmap_line::xd#1 = bitmap_line::x1#10 - bitmap_line::x0#10 -- vwum1=vwum2_minus_vwum3 
    lda x1
    sec
    sbc x0
    sta xd
    lda x1+1
    sbc x0+1
    sta xd+1
    // if(y0<y1)
    // [435] if(bitmap_line::y0#10<bitmap_line::y1#10) goto bitmap_line::@11 -- vwum1_lt_vwum2_then_la1 
    lda y0+1
    cmp y1+1
    bcs !__b11+
    jmp __b11
  !__b11:
    bne !+
    lda y0
    cmp y1
    bcs !__b11+
    jmp __b11
  !__b11:
  !:
    // bitmap_line::@5
    // yd = y0-y1
    // [436] bitmap_line::yd#10 = bitmap_line::y0#10 - bitmap_line::y1#10 -- vwum1=vwum2_minus_vwum3 
    lda y0
    sec
    sbc y1
    sta yd
    lda y0+1
    sbc y1+1
    sta yd+1
    // if(yd<xd)
    // [437] if(bitmap_line::yd#10<bitmap_line::xd#1) goto bitmap_line::@12 -- vwum1_lt_vwum2_then_la1 
    cmp xd+1
    bcc __b12
    bne !+
    lda yd
    cmp xd
    bcc __b12
  !:
    // bitmap_line::@6
    // bitmap_line_ydxd(y1, x1, y0, yd, xd, c)
    // [438] bitmap_line_ydxd::y#1 = bitmap_line::y1#10 -- vwum1=vwum2 
    lda y1
    sta bitmap_line_ydxd.y
    lda y1+1
    sta bitmap_line_ydxd.y+1
    // [439] bitmap_line_ydxd::x#1 = bitmap_line::x1#10 -- vwum1=vwum2 
    lda x1
    sta bitmap_line_ydxd.x
    lda x1+1
    sta bitmap_line_ydxd.x+1
    // [440] bitmap_line_ydxd::y1#1 = bitmap_line::y0#10 -- vwum1=vwum2 
    lda y0
    sta bitmap_line_ydxd.y1
    lda y0+1
    sta bitmap_line_ydxd.y1+1
    // [441] bitmap_line_ydxd::yd#1 = bitmap_line::yd#10
    // [442] bitmap_line_ydxd::xd#1 = bitmap_line::xd#1 -- vwum1=vwum2 
    lda xd
    sta bitmap_line_ydxd.xd
    lda xd+1
    sta bitmap_line_ydxd.xd+1
    // [443] bitmap_line_ydxd::c#1 = bitmap_line::c#10 -- vbum1=vbum2 
    lda c
    sta bitmap_line_ydxd.c
    // [444] call bitmap_line_ydxd
    // [572] phi from bitmap_line::@6 to bitmap_line_ydxd [phi:bitmap_line::@6->bitmap_line_ydxd]
    // [572] phi bitmap_line_ydxd::y1#6 = bitmap_line_ydxd::y1#1 [phi:bitmap_line::@6->bitmap_line_ydxd#0] -- register_copy 
    // [572] phi bitmap_line_ydxd::yd#5 = bitmap_line_ydxd::yd#1 [phi:bitmap_line::@6->bitmap_line_ydxd#1] -- register_copy 
    // [572] phi bitmap_line_ydxd::c#3 = bitmap_line_ydxd::c#1 [phi:bitmap_line::@6->bitmap_line_ydxd#2] -- register_copy 
    // [572] phi bitmap_line_ydxd::y#7 = bitmap_line_ydxd::y#1 [phi:bitmap_line::@6->bitmap_line_ydxd#3] -- register_copy 
    // [572] phi bitmap_line_ydxd::x#5 = bitmap_line_ydxd::x#1 [phi:bitmap_line::@6->bitmap_line_ydxd#4] -- register_copy 
    // [572] phi bitmap_line_ydxd::xd#2 = bitmap_line_ydxd::xd#1 [phi:bitmap_line::@6->bitmap_line_ydxd#5] -- register_copy 
    jsr bitmap_line_ydxd
    rts
    // bitmap_line::@12
  __b12:
    // bitmap_line_xdyd(x0, y0, x1, xd, yd, c)
    // [445] bitmap_line_xdyd::x#1 = bitmap_line::x0#10 -- vwum1=vwum2 
    lda x0
    sta bitmap_line_xdyd.x
    lda x0+1
    sta bitmap_line_xdyd.x+1
    // [446] bitmap_line_xdyd::y#1 = bitmap_line::y0#10 -- vwum1=vwum2 
    lda y0
    sta bitmap_line_xdyd.y
    lda y0+1
    sta bitmap_line_xdyd.y+1
    // [447] bitmap_line_xdyd::x1#1 = bitmap_line::x1#10 -- vwum1=vwum2 
    lda x1
    sta bitmap_line_xdyd.x1
    lda x1+1
    sta bitmap_line_xdyd.x1+1
    // [448] bitmap_line_xdyd::xd#1 = bitmap_line::xd#1 -- vwum1=vwum2 
    lda xd
    sta bitmap_line_xdyd.xd
    lda xd+1
    sta bitmap_line_xdyd.xd+1
    // [449] bitmap_line_xdyd::yd#1 = bitmap_line::yd#10 -- vwum1=vwum2 
    lda yd
    sta bitmap_line_xdyd.yd
    lda yd+1
    sta bitmap_line_xdyd.yd+1
    // [450] bitmap_line_xdyd::c#1 = bitmap_line::c#10 -- vbum1=vbum2 
    lda c
    sta bitmap_line_xdyd.c
    // [451] call bitmap_line_xdyd
    // [588] phi from bitmap_line::@12 to bitmap_line_xdyd [phi:bitmap_line::@12->bitmap_line_xdyd]
    // [588] phi bitmap_line_xdyd::x1#6 = bitmap_line_xdyd::x1#1 [phi:bitmap_line::@12->bitmap_line_xdyd#0] -- register_copy 
    // [588] phi bitmap_line_xdyd::xd#5 = bitmap_line_xdyd::xd#1 [phi:bitmap_line::@12->bitmap_line_xdyd#1] -- register_copy 
    // [588] phi bitmap_line_xdyd::c#3 = bitmap_line_xdyd::c#1 [phi:bitmap_line::@12->bitmap_line_xdyd#2] -- register_copy 
    // [588] phi bitmap_line_xdyd::y#5 = bitmap_line_xdyd::y#1 [phi:bitmap_line::@12->bitmap_line_xdyd#3] -- register_copy 
    // [588] phi bitmap_line_xdyd::x#6 = bitmap_line_xdyd::x#1 [phi:bitmap_line::@12->bitmap_line_xdyd#4] -- register_copy 
    // [588] phi bitmap_line_xdyd::yd#2 = bitmap_line_xdyd::yd#1 [phi:bitmap_line::@12->bitmap_line_xdyd#5] -- register_copy 
    jsr bitmap_line_xdyd
    rts
    // bitmap_line::@11
  __b11:
    // yd = y1-y0
    // [452] bitmap_line::yd#11 = bitmap_line::y1#10 - bitmap_line::y0#10 -- vwum1=vwum2_minus_vwum3 
    lda y1
    sec
    sbc y0
    sta yd_1
    lda y1+1
    sbc y0+1
    sta yd_1+1
    // if(yd<xd)
    // [453] if(bitmap_line::yd#11<bitmap_line::xd#1) goto bitmap_line::@13 -- vwum1_lt_vwum2_then_la1 
    cmp xd+1
    bcc __b13
    bne !+
    lda yd_1
    cmp xd
    bcc __b13
  !:
    // bitmap_line::@14
    // bitmap_line_ydxi(y0, x0, y1, yd, xd, c)
    // [454] bitmap_line_ydxi::y#1 = bitmap_line::y0#10 -- vwum1=vwum2 
    lda y0
    sta bitmap_line_ydxi.y
    lda y0+1
    sta bitmap_line_ydxi.y+1
    // [455] bitmap_line_ydxi::x#1 = bitmap_line::x0#10
    // [456] bitmap_line_ydxi::y1#1 = bitmap_line::y1#10 -- vwum1=vwum2 
    lda y1
    sta bitmap_line_ydxi.y1
    lda y1+1
    sta bitmap_line_ydxi.y1+1
    // [457] bitmap_line_ydxi::yd#1 = bitmap_line::yd#11
    // [458] bitmap_line_ydxi::xd#1 = bitmap_line::xd#1
    // [459] bitmap_line_ydxi::c#1 = bitmap_line::c#10
    // [460] call bitmap_line_ydxi
    // [540] phi from bitmap_line::@14 to bitmap_line_ydxi [phi:bitmap_line::@14->bitmap_line_ydxi]
    // [540] phi bitmap_line_ydxi::y1#6 = bitmap_line_ydxi::y1#1 [phi:bitmap_line::@14->bitmap_line_ydxi#0] -- register_copy 
    // [540] phi bitmap_line_ydxi::yd#5 = bitmap_line_ydxi::yd#1 [phi:bitmap_line::@14->bitmap_line_ydxi#1] -- register_copy 
    // [540] phi bitmap_line_ydxi::c#3 = bitmap_line_ydxi::c#1 [phi:bitmap_line::@14->bitmap_line_ydxi#2] -- register_copy 
    // [540] phi bitmap_line_ydxi::y#6 = bitmap_line_ydxi::y#1 [phi:bitmap_line::@14->bitmap_line_ydxi#3] -- register_copy 
    // [540] phi bitmap_line_ydxi::x#5 = bitmap_line_ydxi::x#1 [phi:bitmap_line::@14->bitmap_line_ydxi#4] -- register_copy 
    // [540] phi bitmap_line_ydxi::xd#2 = bitmap_line_ydxi::xd#1 [phi:bitmap_line::@14->bitmap_line_ydxi#5] -- register_copy 
    jsr bitmap_line_ydxi
    rts
    // bitmap_line::@13
  __b13:
    // bitmap_line_xdyi(x0, y0, x1, xd, yd, c)
    // [461] bitmap_line_xdyi::x#1 = bitmap_line::x0#10 -- vwum1=vwum2 
    lda x0
    sta bitmap_line_xdyi.x
    lda x0+1
    sta bitmap_line_xdyi.x+1
    // [462] bitmap_line_xdyi::y#1 = bitmap_line::y0#10 -- vwum1=vwum2 
    lda y0
    sta bitmap_line_xdyi.y
    lda y0+1
    sta bitmap_line_xdyi.y+1
    // [463] bitmap_line_xdyi::x1#1 = bitmap_line::x1#10
    // [464] bitmap_line_xdyi::xd#1 = bitmap_line::xd#1 -- vwum1=vwum2 
    lda xd
    sta bitmap_line_xdyi.xd
    lda xd+1
    sta bitmap_line_xdyi.xd+1
    // [465] bitmap_line_xdyi::yd#1 = bitmap_line::yd#11 -- vwum1=vwum2 
    lda yd_1
    sta bitmap_line_xdyi.yd
    lda yd_1+1
    sta bitmap_line_xdyi.yd+1
    // [466] bitmap_line_xdyi::c#1 = bitmap_line::c#10 -- vbum1=vbum2 
    lda c
    sta bitmap_line_xdyi.c
    // [467] call bitmap_line_xdyi
    // [556] phi from bitmap_line::@13 to bitmap_line_xdyi [phi:bitmap_line::@13->bitmap_line_xdyi]
    // [556] phi bitmap_line_xdyi::x1#6 = bitmap_line_xdyi::x1#1 [phi:bitmap_line::@13->bitmap_line_xdyi#0] -- register_copy 
    // [556] phi bitmap_line_xdyi::xd#5 = bitmap_line_xdyi::xd#1 [phi:bitmap_line::@13->bitmap_line_xdyi#1] -- register_copy 
    // [556] phi bitmap_line_xdyi::c#3 = bitmap_line_xdyi::c#1 [phi:bitmap_line::@13->bitmap_line_xdyi#2] -- register_copy 
    // [556] phi bitmap_line_xdyi::y#5 = bitmap_line_xdyi::y#1 [phi:bitmap_line::@13->bitmap_line_xdyi#3] -- register_copy 
    // [556] phi bitmap_line_xdyi::x#6 = bitmap_line_xdyi::x#1 [phi:bitmap_line::@13->bitmap_line_xdyi#4] -- register_copy 
    // [556] phi bitmap_line_xdyi::yd#2 = bitmap_line_xdyi::yd#1 [phi:bitmap_line::@13->bitmap_line_xdyi#5] -- register_copy 
    jsr bitmap_line_xdyi
    rts
  .segment Data
    .label xd = bitmap_line_ydxi.xd
    .label yd = bitmap_line_ydxd.yd
    .label yd_1 = bitmap_line_ydxi.yd
    x0: .word 0
    x1: .word 0
    y0: .word 0
    y1: .word 0
    c: .byte 0
}
.segment Code
  // rand
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
rand: {
    // rand_state << 7
    // [468] rand::$0 = rand_state << 7 -- vwum1=vwum2_rol_7 
    lda rand_state+1
    lsr
    lda rand_state
    ror
    sta __0+1
    lda #0
    ror
    sta __0
    // rand_state ^= rand_state << 7
    // [469] rand_state = rand_state ^ rand::$0 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor __0
    sta rand_state
    lda rand_state+1
    eor __0+1
    sta rand_state+1
    // rand_state >> 9
    // [470] rand::$1 = rand_state >> 9 -- vwum1=vwum2_ror_9 
    lsr
    sta __1
    lda #0
    sta __1+1
    // rand_state ^= rand_state >> 9
    // [471] rand_state = rand_state ^ rand::$1 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor __1
    sta rand_state
    lda rand_state+1
    eor __1+1
    sta rand_state+1
    // rand_state << 8
    // [472] rand::$2 = rand_state << 8 -- vwum1=vwum2_rol_8 
    lda rand_state
    sta __2+1
    lda #0
    sta __2
    // rand_state ^= rand_state << 8
    // [473] rand_state = rand_state ^ rand::$2 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor __2
    sta rand_state
    lda rand_state+1
    eor __2+1
    sta rand_state+1
    // return rand_state;
    // [474] rand::return#0 = rand_state -- vwum1=vwum2 
    lda rand_state
    sta return
    lda rand_state+1
    sta return+1
    // rand::@return
    // }
    // [475] return 
    rts
  .segment Data
    __0: .word 0
    __1: .word 0
    __2: .word 0
    .label return = modr16u.dividend
}
.segment Code
  // modr16u
// Performs modulo on two 16 bit unsigned ints and an initial remainder
// Returns the remainder.
// Implemented using simple binary division
// __mem() unsigned int modr16u(__mem() unsigned int dividend, __mem() unsigned int divisor, unsigned int rem)
modr16u: {
    // divr16u(dividend, divisor, rem)
    // [477] divr16u::dividend#1 = modr16u::dividend#4
    // [478] divr16u::divisor#0 = modr16u::divisor#4
    // [479] call divr16u
    // [604] phi from modr16u to divr16u [phi:modr16u->divr16u]
    jsr divr16u
    // modr16u::@1
    // return rem16u;
    // [480] modr16u::return#0 = rem16u#0 -- vwum1=vwum2 
    lda rem16u
    sta return
    lda rem16u+1
    sta return+1
    // modr16u::@return
    // }
    // [481] return 
    rts
  .segment Data
    .label return = bitmap_line.y1
    dividend: .word 0
    .label return_1 = bitmap_line.x0
    .label return_2 = bitmap_line.x1
    .label return_3 = bitmap_line.y0
    divisor: .word 0
}
.segment Code
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(__conio.cursor_y>=__conio.height)
    // [482] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto cscroll::@return -- _deref_pbuc1_lt__deref_pbuc2_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    bcc __breturn
    // cscroll::@1
    // if(__conio.scroll[__conio.layer])
    // [483] if(0!=((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_SCROLL)[*((char *)&__conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_SCROLL,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(__conio.cursor_y>=__conio.height)
    // [484] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto cscroll::@return -- _deref_pbuc1_lt__deref_pbuc2_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    bcc __breturn
    // [485] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
    // gotoxy(0,0)
    // [486] call gotoxy
    // [227] phi from cscroll::@3 to gotoxy [phi:cscroll::@3->gotoxy]
    // [227] phi gotoxy::x#10 = 0 [phi:cscroll::@3->gotoxy#0] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.x
    // [227] phi gotoxy::y#8 = 0 [phi:cscroll::@3->gotoxy#1] -- vbum1=vbuc1 
    sta gotoxy.y
    jsr gotoxy
    // cscroll::@return
  __breturn:
    // }
    // [487] return 
    rts
    // [488] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [489] call insertup
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, __conio.height-1)
    // [490] gotoxy::y#2 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT) - 1 -- vbum1=_deref_pbuc1_minus_1 
    ldx __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    dex
    stx gotoxy.y
    // [491] call gotoxy
    // [227] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [227] phi gotoxy::x#10 = 0 [phi:cscroll::@5->gotoxy#0] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.x
    // [227] phi gotoxy::y#8 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#1] -- register_copy 
    jsr gotoxy
    // [492] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [493] call clearline
    jsr clearline
    rts
}
  // bitmap_hscale
bitmap_hscale: {
    .const scale = 0
    // [495] phi from bitmap_hscale to bitmap_hscale::@1 [phi:bitmap_hscale->bitmap_hscale::@1]
    // [495] phi bitmap_hscale::s#2 = 1 [phi:bitmap_hscale->bitmap_hscale::@1#0] -- vbum1=vbuc1 
    lda #1
    sta s
    // bitmap_hscale::@1
  __b1:
    // for(char s=1;s<=3;s++)
    // [496] if(bitmap_hscale::s#2<3+1) goto bitmap_hscale::@2 -- vbum1_lt_vbuc1_then_la1 
    lda s
    cmp #3+1
    bcc __b2
    // [498] phi from bitmap_hscale::@1 to bitmap_hscale::@4 [phi:bitmap_hscale::@1->bitmap_hscale::@4]
    // [498] phi bitmap_hscale::return#1 = bitmap_hscale::scale#0 [phi:bitmap_hscale::@1->bitmap_hscale::@4#0] -- vbum1=vbuc1 
    lda #scale
    sta return
    rts
    // bitmap_hscale::@2
  __b2:
    // if(*VERA_DC_HSCALE==hscale[s])
    // [497] if(*VERA_DC_HSCALE!=bitmap_hscale::hscale[bitmap_hscale::s#2]) goto bitmap_hscale::@3 -- _deref_pbuc1_neq_pbuc2_derefidx_vbum1_then_la1 
    lda VERA_DC_HSCALE
    ldy s
    cmp hscale,y
    bne __b3
    // [498] phi from bitmap_hscale::@2 to bitmap_hscale::@4 [phi:bitmap_hscale::@2->bitmap_hscale::@4]
    // [498] phi bitmap_hscale::return#1 = bitmap_hscale::s#2 [phi:bitmap_hscale::@2->bitmap_hscale::@4#0] -- register_copy 
    // bitmap_hscale::@4
    // bitmap_hscale::@return
    // }
    // [499] return 
    rts
    // bitmap_hscale::@3
  __b3:
    // for(char s=1;s<=3;s++)
    // [500] bitmap_hscale::s#1 = ++ bitmap_hscale::s#2 -- vbum1=_inc_vbum1 
    inc s
    // [495] phi from bitmap_hscale::@3 to bitmap_hscale::@1 [phi:bitmap_hscale::@3->bitmap_hscale::@1]
    // [495] phi bitmap_hscale::s#2 = bitmap_hscale::s#1 [phi:bitmap_hscale::@3->bitmap_hscale::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    hscale: .byte 0, $80, $40, $20
    return: .byte 0
    .label s = return
}
.segment Code
  // bitmap_vscale
bitmap_vscale: {
    .const scale = 0
    // [502] phi from bitmap_vscale to bitmap_vscale::@1 [phi:bitmap_vscale->bitmap_vscale::@1]
    // [502] phi bitmap_vscale::s#2 = 1 [phi:bitmap_vscale->bitmap_vscale::@1#0] -- vbum1=vbuc1 
    lda #1
    sta s
    // bitmap_vscale::@1
  __b1:
    // for(char s=1;s<=3;s++)
    // [503] if(bitmap_vscale::s#2<3+1) goto bitmap_vscale::@2 -- vbum1_lt_vbuc1_then_la1 
    lda s
    cmp #3+1
    bcc __b2
    // [505] phi from bitmap_vscale::@1 to bitmap_vscale::@4 [phi:bitmap_vscale::@1->bitmap_vscale::@4]
    // [505] phi bitmap_vscale::return#1 = bitmap_vscale::scale#0 [phi:bitmap_vscale::@1->bitmap_vscale::@4#0] -- vbum1=vbuc1 
    lda #scale
    sta return
    rts
    // bitmap_vscale::@2
  __b2:
    // if(*VERA_DC_VSCALE==vscale[s])
    // [504] if(*VERA_DC_VSCALE!=bitmap_vscale::vscale[bitmap_vscale::s#2]) goto bitmap_vscale::@3 -- _deref_pbuc1_neq_pbuc2_derefidx_vbum1_then_la1 
    lda VERA_DC_VSCALE
    ldy s
    cmp vscale,y
    bne __b3
    // [505] phi from bitmap_vscale::@2 to bitmap_vscale::@4 [phi:bitmap_vscale::@2->bitmap_vscale::@4]
    // [505] phi bitmap_vscale::return#1 = bitmap_vscale::s#2 [phi:bitmap_vscale::@2->bitmap_vscale::@4#0] -- register_copy 
    // bitmap_vscale::@4
    // bitmap_vscale::@return
    // }
    // [506] return 
    rts
    // bitmap_vscale::@3
  __b3:
    // for(char s=1;s<=3;s++)
    // [507] bitmap_vscale::s#1 = ++ bitmap_vscale::s#2 -- vbum1=_inc_vbum1 
    inc s
    // [502] phi from bitmap_vscale::@3 to bitmap_vscale::@1 [phi:bitmap_vscale::@3->bitmap_vscale::@1]
    // [502] phi bitmap_vscale::s#2 = bitmap_vscale::s#1 [phi:bitmap_vscale::@3->bitmap_vscale::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    vscale: .byte 0, $80, $40, $20
    return: .byte 0
    .label s = return
}
.segment Code
  // mul16u
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// __mem() unsigned long mul16u(__mem() unsigned int a, __mem() unsigned int b)
mul16u: {
    // unsigned long mb = b
    // [508] mul16u::mb#0 = (unsigned long)mul16u::b#0 -- vdum1=_dword_vwum2 
    lda b
    sta mb
    lda b+1
    sta mb+1
    lda #0
    sta mb+2
    sta mb+3
    // [509] phi from mul16u to mul16u::@1 [phi:mul16u->mul16u::@1]
    // [509] phi mul16u::mb#2 = mul16u::mb#0 [phi:mul16u->mul16u::@1#0] -- register_copy 
    // [509] phi mul16u::res#2 = 0 [phi:mul16u->mul16u::@1#1] -- vdum1=vduc1 
    sta res
    sta res+1
    lda #<0>>$10
    sta res+2
    lda #>0>>$10
    sta res+3
    // [509] phi mul16u::a#2 = mul16u::a#0 [phi:mul16u->mul16u::@1#2] -- register_copy 
    // mul16u::@1
  __b1:
    // while(a!=0)
    // [510] if(mul16u::a#2!=0) goto mul16u::@2 -- vwum1_neq_0_then_la1 
    lda a
    ora a+1
    bne __b2
    // mul16u::@return
    // }
    // [511] return 
    rts
    // mul16u::@2
  __b2:
    // a&1
    // [512] mul16u::$1 = mul16u::a#2 & 1 -- vbum1=vwum2_band_vbuc1 
    lda #1
    and a
    sta __1
    // if( (a&1) != 0)
    // [513] if(mul16u::$1==0) goto mul16u::@3 -- vbum1_eq_0_then_la1 
    beq __b3
    // mul16u::@4
    // res = res + mb
    // [514] mul16u::res#1 = mul16u::res#2 + mul16u::mb#2 -- vdum1=vdum1_plus_vdum2 
    clc
    lda res
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
    lda res+2
    adc mb+2
    sta res+2
    lda res+3
    adc mb+3
    sta res+3
    // [515] phi from mul16u::@2 mul16u::@4 to mul16u::@3 [phi:mul16u::@2/mul16u::@4->mul16u::@3]
    // [515] phi mul16u::res#6 = mul16u::res#2 [phi:mul16u::@2/mul16u::@4->mul16u::@3#0] -- register_copy 
    // mul16u::@3
  __b3:
    // a = a>>1
    // [516] mul16u::a#1 = mul16u::a#2 >> 1 -- vwum1=vwum1_ror_1 
    lsr a+1
    ror a
    // mb = mb<<1
    // [517] mul16u::mb#1 = mul16u::mb#2 << 1 -- vdum1=vdum1_rol_1 
    asl mb
    rol mb+1
    rol mb+2
    rol mb+3
    // [509] phi from mul16u::@3 to mul16u::@1 [phi:mul16u::@3->mul16u::@1]
    // [509] phi mul16u::mb#2 = mul16u::mb#1 [phi:mul16u::@3->mul16u::@1#0] -- register_copy 
    // [509] phi mul16u::res#2 = mul16u::res#6 [phi:mul16u::@3->mul16u::@1#1] -- register_copy 
    // [509] phi mul16u::a#2 = mul16u::a#1 [phi:mul16u::@3->mul16u::@1#2] -- register_copy 
    jmp __b1
  .segment Data
    __1: .byte 0
    a: .word 0
    .label b = bitmap_clear.vdelta
    .label return = res
    mb: .dword 0
    res: .dword 0
}
.segment Code
  // memset_vram
/**
 * @brief Set block of memory in vram to a value.
 * Sets num bytes to the destination vram bank/offset to the specified data value.
 *
 * @param dbank_vram Destination vram bank between 0 and 1.
 * @param doffset_vram Destination vram offset between 0x0000 and 0xFFFF.
 * @param data The data to be set in word value.
 * @param num Amount of bytes to set.
 */
// void memset_vram(__mem() char dbank_vram, __mem() unsigned int doffset_vram, unsigned int data, __mem() unsigned int num)
memset_vram: {
    // memset_vram::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [519] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [520] memset_vram::vera_vram_data0_bank_offset1_$0 = byte0  memset_vram::doffset_vram#0 -- vbum1=_byte0_vwum2 
    lda doffset_vram
    sta vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [521] *VERA_ADDRX_L = memset_vram::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [522] memset_vram::vera_vram_data0_bank_offset1_$1 = byte1  memset_vram::doffset_vram#0 -- vbum1=_byte1_vwum2 
    lda doffset_vram+1
    sta vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [523] *VERA_ADDRX_M = memset_vram::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // bank | inc_dec
    // [524] memset_vram::vera_vram_data0_bank_offset1_$2 = memset_vram::dbank_vram#0 | vera_inc_1 -- vbum1=vbum1_bor_vbuc1 
    lda #vera_inc_1
    ora vera_vram_data0_bank_offset1___2
    sta vera_vram_data0_bank_offset1___2
    // *VERA_ADDRX_H = bank | inc_dec
    // [525] *VERA_ADDRX_H = memset_vram::vera_vram_data0_bank_offset1_$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // [526] phi from memset_vram::vera_vram_data0_bank_offset1 to memset_vram::@1 [phi:memset_vram::vera_vram_data0_bank_offset1->memset_vram::@1]
    // [526] phi memset_vram::i#2 = 0 [phi:memset_vram::vera_vram_data0_bank_offset1->memset_vram::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta i
    sta i+1
  // Transfer the data
    // memset_vram::@1
  __b1:
    // for(word i = 0; i<num; i++)
    // [527] if(memset_vram::i#2<memset_vram::num#0) goto memset_vram::@2 -- vwum1_lt_vwum2_then_la1 
    lda i+1
    cmp num+1
    bcc __b2
    bne !+
    lda i
    cmp num
    bcc __b2
  !:
    // memset_vram::@return
    // }
    // [528] return 
    rts
    // memset_vram::@2
  __b2:
    // *VERA_DATA0 = BYTE0(data)
    // [529] *VERA_DATA0 = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta VERA_DATA0
    // *VERA_DATA0 = BYTE1(data)
    // [530] *VERA_DATA0 = 0 -- _deref_pbuc1=vbuc2 
    sta VERA_DATA0
    // for(word i = 0; i<num; i++)
    // [531] memset_vram::i#1 = ++ memset_vram::i#2 -- vwum1=_inc_vwum1 
    inc i
    bne !+
    inc i+1
  !:
    // [526] phi from memset_vram::@2 to memset_vram::@1 [phi:memset_vram::@2->memset_vram::@1]
    // [526] phi memset_vram::i#2 = memset_vram::i#1 [phi:memset_vram::@2->memset_vram::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    vera_vram_data0_bank_offset1___0: .byte 0
    vera_vram_data0_bank_offset1___1: .byte 0
    .label vera_vram_data0_bank_offset1___2 = bitmap_clear.vbank
    i: .word 0
    .label dbank_vram = bitmap_clear.vbank
    .label doffset_vram = bitmap_clear.vdest
    .label num = bitmap_clear.count
}
.segment Code
  // getin
/**
 * @brief Get a character from keyboard.
 * 
 * @return char The character read.
 */
getin: {
    .const bank_set_bram1_bank = 0
    // char ch
    // [532] getin::ch = 0 -- vbum1=vbuc1 
    lda #0
    sta ch
    // getin::bank_get_bram1
    // return BRAM;
    // [533] getin::bank_get_bram1_return#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_get_bram1_return
    // getin::bank_set_bram1
    // BRAM = bank
    // [534] BRAM = getin::bank_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_set_bram1_bank
    sta.z BRAM
    // getin::@1
    // asm
    // asm { jsr$ffe4 stach  }
    jsr $ffe4
    sta ch
    // getin::bank_set_bram2
    // BRAM = bank
    // [536] BRAM = getin::bank_get_bram1_return#0 -- vbuz1=vbum2 
    lda bank_get_bram1_return
    sta.z BRAM
    // getin::@2
    // return ch;
    // [537] getin::return#0 = getin::ch -- vbum1=vbum2 
    lda ch
    sta return
    // getin::@return
    // }
    // [538] getin::return#1 = getin::return#0
    // [539] return 
    rts
  .segment Data
    ch: .byte 0
    bank_get_bram1_return: .byte 0
    .label return = kbhit.return
}
.segment Code
  // bitmap_line_ydxi
// void bitmap_line_ydxi(__mem() unsigned int y, __mem() unsigned int x, __mem() unsigned int y1, __mem() unsigned int yd, __mem() unsigned int xd, __mem() char c)
bitmap_line_ydxi: {
    // unsigned int e = xd>>1
    // [541] bitmap_line_ydxi::e#0 = bitmap_line_ydxi::xd#2 >> 1 -- vwum1=vwum2_ror_1 
    lda xd+1
    lsr
    sta e+1
    lda xd
    ror
    sta e
    // [542] phi from bitmap_line_ydxi bitmap_line_ydxi::@2 to bitmap_line_ydxi::@1 [phi:bitmap_line_ydxi/bitmap_line_ydxi::@2->bitmap_line_ydxi::@1]
    // [542] phi bitmap_line_ydxi::e#3 = bitmap_line_ydxi::e#0 [phi:bitmap_line_ydxi/bitmap_line_ydxi::@2->bitmap_line_ydxi::@1#0] -- register_copy 
    // [542] phi bitmap_line_ydxi::y#3 = bitmap_line_ydxi::y#6 [phi:bitmap_line_ydxi/bitmap_line_ydxi::@2->bitmap_line_ydxi::@1#1] -- register_copy 
    // [542] phi bitmap_line_ydxi::x#3 = bitmap_line_ydxi::x#5 [phi:bitmap_line_ydxi/bitmap_line_ydxi::@2->bitmap_line_ydxi::@1#2] -- register_copy 
    // bitmap_line_ydxi::@1
  __b1:
    // bitmap_plot(x,y,c)
    // [543] bitmap_plot::x#2 = bitmap_line_ydxi::x#3 -- vwum1=vwum2 
    lda x
    sta bitmap_plot.x
    lda x+1
    sta bitmap_plot.x+1
    // [544] bitmap_plot::y#2 = bitmap_line_ydxi::y#3 -- vwum1=vwum2 
    lda y
    sta bitmap_plot.y
    lda y+1
    sta bitmap_plot.y+1
    // [545] bitmap_plot::c#3 = bitmap_line_ydxi::c#3 -- vbum1=vbum2 
    lda c
    sta bitmap_plot.c
    // [546] call bitmap_plot
    // [654] phi from bitmap_line_ydxi::@1 to bitmap_plot [phi:bitmap_line_ydxi::@1->bitmap_plot]
    // [654] phi bitmap_plot::c#5 = bitmap_plot::c#3 [phi:bitmap_line_ydxi::@1->bitmap_plot#0] -- register_copy 
    // [654] phi bitmap_plot::y#4 = bitmap_plot::y#2 [phi:bitmap_line_ydxi::@1->bitmap_plot#1] -- register_copy 
    // [654] phi bitmap_plot::x#10 = bitmap_plot::x#2 [phi:bitmap_line_ydxi::@1->bitmap_plot#2] -- register_copy 
    jsr bitmap_plot
    // bitmap_line_ydxi::@4
    // y++;
    // [547] bitmap_line_ydxi::y#2 = ++ bitmap_line_ydxi::y#3 -- vwum1=_inc_vwum1 
    inc y
    bne !+
    inc y+1
  !:
    // e = e+xd
    // [548] bitmap_line_ydxi::e#1 = bitmap_line_ydxi::e#3 + bitmap_line_ydxi::xd#2 -- vwum1=vwum1_plus_vwum2 
    clc
    lda e
    adc xd
    sta e
    lda e+1
    adc xd+1
    sta e+1
    // if(yd<e)
    // [549] if(bitmap_line_ydxi::yd#5>=bitmap_line_ydxi::e#1) goto bitmap_line_ydxi::@2 -- vwum1_ge_vwum2_then_la1 
    cmp yd+1
    bne !+
    lda e
    cmp yd
    beq __b2
  !:
    bcc __b2
    // bitmap_line_ydxi::@3
    // x++;
    // [550] bitmap_line_ydxi::x#2 = ++ bitmap_line_ydxi::x#3 -- vwum1=_inc_vwum1 
    inc x
    bne !+
    inc x+1
  !:
    // e = e - yd
    // [551] bitmap_line_ydxi::e#2 = bitmap_line_ydxi::e#1 - bitmap_line_ydxi::yd#5 -- vwum1=vwum1_minus_vwum2 
    lda e
    sec
    sbc yd
    sta e
    lda e+1
    sbc yd+1
    sta e+1
    // [552] phi from bitmap_line_ydxi::@3 bitmap_line_ydxi::@4 to bitmap_line_ydxi::@2 [phi:bitmap_line_ydxi::@3/bitmap_line_ydxi::@4->bitmap_line_ydxi::@2]
    // [552] phi bitmap_line_ydxi::e#6 = bitmap_line_ydxi::e#2 [phi:bitmap_line_ydxi::@3/bitmap_line_ydxi::@4->bitmap_line_ydxi::@2#0] -- register_copy 
    // [552] phi bitmap_line_ydxi::x#6 = bitmap_line_ydxi::x#2 [phi:bitmap_line_ydxi::@3/bitmap_line_ydxi::@4->bitmap_line_ydxi::@2#1] -- register_copy 
    // bitmap_line_ydxi::@2
  __b2:
    // y1+1
    // [553] bitmap_line_ydxi::$6 = bitmap_line_ydxi::y1#6 + 1 -- vwum1=vwum2_plus_1 
    clc
    lda y1
    adc #1
    sta __6
    lda y1+1
    adc #0
    sta __6+1
    // while (y!=(y1+1))
    // [554] if(bitmap_line_ydxi::y#2!=bitmap_line_ydxi::$6) goto bitmap_line_ydxi::@1 -- vwum1_neq_vwum2_then_la1 
    lda y+1
    cmp __6+1
    bne __b1
    lda y
    cmp __6
    beq !__b1+
    jmp __b1
  !__b1:
    // bitmap_line_ydxi::@return
    // }
    // [555] return 
    rts
  .segment Data
    __6: .word 0
    y: .word 0
    .label x = bitmap_line.x0
    .label y1 = bitmap_line.y0
    yd: .word 0
    xd: .word 0
    .label c = bitmap_line.c
    e: .word 0
}
.segment Code
  // bitmap_line_xdyi
// void bitmap_line_xdyi(__mem() unsigned int x, __mem() unsigned int y, __mem() unsigned int x1, __mem() unsigned int xd, __mem() unsigned int yd, __mem() char c)
bitmap_line_xdyi: {
    // unsigned int e = yd>>1
    // [557] bitmap_line_xdyi::e#0 = bitmap_line_xdyi::yd#2 >> 1 -- vwum1=vwum2_ror_1 
    lda yd+1
    lsr
    sta e+1
    lda yd
    ror
    sta e
    // [558] phi from bitmap_line_xdyi bitmap_line_xdyi::@2 to bitmap_line_xdyi::@1 [phi:bitmap_line_xdyi/bitmap_line_xdyi::@2->bitmap_line_xdyi::@1]
    // [558] phi bitmap_line_xdyi::e#3 = bitmap_line_xdyi::e#0 [phi:bitmap_line_xdyi/bitmap_line_xdyi::@2->bitmap_line_xdyi::@1#0] -- register_copy 
    // [558] phi bitmap_line_xdyi::y#3 = bitmap_line_xdyi::y#5 [phi:bitmap_line_xdyi/bitmap_line_xdyi::@2->bitmap_line_xdyi::@1#1] -- register_copy 
    // [558] phi bitmap_line_xdyi::x#3 = bitmap_line_xdyi::x#6 [phi:bitmap_line_xdyi/bitmap_line_xdyi::@2->bitmap_line_xdyi::@1#2] -- register_copy 
    // bitmap_line_xdyi::@1
  __b1:
    // bitmap_plot(x,y,c)
    // [559] bitmap_plot::x#0 = bitmap_line_xdyi::x#3 -- vwum1=vwum2 
    lda x
    sta bitmap_plot.x
    lda x+1
    sta bitmap_plot.x+1
    // [560] bitmap_plot::y#0 = bitmap_line_xdyi::y#3 -- vwum1=vwum2 
    lda y
    sta bitmap_plot.y
    lda y+1
    sta bitmap_plot.y+1
    // [561] bitmap_plot::c#1 = bitmap_line_xdyi::c#3 -- vbum1=vbum2 
    lda c
    sta bitmap_plot.c
    // [562] call bitmap_plot
    // [654] phi from bitmap_line_xdyi::@1 to bitmap_plot [phi:bitmap_line_xdyi::@1->bitmap_plot]
    // [654] phi bitmap_plot::c#5 = bitmap_plot::c#1 [phi:bitmap_line_xdyi::@1->bitmap_plot#0] -- register_copy 
    // [654] phi bitmap_plot::y#4 = bitmap_plot::y#0 [phi:bitmap_line_xdyi::@1->bitmap_plot#1] -- register_copy 
    // [654] phi bitmap_plot::x#10 = bitmap_plot::x#0 [phi:bitmap_line_xdyi::@1->bitmap_plot#2] -- register_copy 
    jsr bitmap_plot
    // bitmap_line_xdyi::@4
    // x++;
    // [563] bitmap_line_xdyi::x#2 = ++ bitmap_line_xdyi::x#3 -- vwum1=_inc_vwum1 
    inc x
    bne !+
    inc x+1
  !:
    // e = e+yd
    // [564] bitmap_line_xdyi::e#1 = bitmap_line_xdyi::e#3 + bitmap_line_xdyi::yd#2 -- vwum1=vwum1_plus_vwum2 
    clc
    lda e
    adc yd
    sta e
    lda e+1
    adc yd+1
    sta e+1
    // if(xd<e)
    // [565] if(bitmap_line_xdyi::xd#5>=bitmap_line_xdyi::e#1) goto bitmap_line_xdyi::@2 -- vwum1_ge_vwum2_then_la1 
    cmp xd+1
    bne !+
    lda e
    cmp xd
    beq __b2
  !:
    bcc __b2
    // bitmap_line_xdyi::@3
    // y++;
    // [566] bitmap_line_xdyi::y#2 = ++ bitmap_line_xdyi::y#3 -- vwum1=_inc_vwum1 
    inc y
    bne !+
    inc y+1
  !:
    // e = e - xd
    // [567] bitmap_line_xdyi::e#2 = bitmap_line_xdyi::e#1 - bitmap_line_xdyi::xd#5 -- vwum1=vwum1_minus_vwum2 
    lda e
    sec
    sbc xd
    sta e
    lda e+1
    sbc xd+1
    sta e+1
    // [568] phi from bitmap_line_xdyi::@3 bitmap_line_xdyi::@4 to bitmap_line_xdyi::@2 [phi:bitmap_line_xdyi::@3/bitmap_line_xdyi::@4->bitmap_line_xdyi::@2]
    // [568] phi bitmap_line_xdyi::e#6 = bitmap_line_xdyi::e#2 [phi:bitmap_line_xdyi::@3/bitmap_line_xdyi::@4->bitmap_line_xdyi::@2#0] -- register_copy 
    // [568] phi bitmap_line_xdyi::y#6 = bitmap_line_xdyi::y#2 [phi:bitmap_line_xdyi::@3/bitmap_line_xdyi::@4->bitmap_line_xdyi::@2#1] -- register_copy 
    // bitmap_line_xdyi::@2
  __b2:
    // x1+1
    // [569] bitmap_line_xdyi::$6 = bitmap_line_xdyi::x1#6 + 1 -- vwum1=vwum2_plus_1 
    clc
    lda x1
    adc #1
    sta __6
    lda x1+1
    adc #0
    sta __6+1
    // while (x!=(x1+1))
    // [570] if(bitmap_line_xdyi::x#2!=bitmap_line_xdyi::$6) goto bitmap_line_xdyi::@1 -- vwum1_neq_vwum2_then_la1 
    lda x+1
    cmp __6+1
    bne __b1
    lda x
    cmp __6
    beq !__b1+
    jmp __b1
  !__b1:
    // bitmap_line_xdyi::@return
    // }
    // [571] return 
    rts
  .segment Data
    __6: .word 0
    x: .word 0
    .label y = bitmap_line.y1
    .label x1 = bitmap_line.x1
    xd: .word 0
    yd: .word 0
    c: .byte 0
    e: .word 0
}
.segment Code
  // bitmap_line_ydxd
// void bitmap_line_ydxd(__mem() unsigned int y, __mem() unsigned int x, __mem() unsigned int y1, __mem() unsigned int yd, __mem() unsigned int xd, __mem() char c)
bitmap_line_ydxd: {
    // unsigned int e = xd>>1
    // [573] bitmap_line_ydxd::e#0 = bitmap_line_ydxd::xd#2 >> 1 -- vwum1=vwum2_ror_1 
    lda xd+1
    lsr
    sta e+1
    lda xd
    ror
    sta e
    // [574] phi from bitmap_line_ydxd bitmap_line_ydxd::@2 to bitmap_line_ydxd::@1 [phi:bitmap_line_ydxd/bitmap_line_ydxd::@2->bitmap_line_ydxd::@1]
    // [574] phi bitmap_line_ydxd::e#3 = bitmap_line_ydxd::e#0 [phi:bitmap_line_ydxd/bitmap_line_ydxd::@2->bitmap_line_ydxd::@1#0] -- register_copy 
    // [574] phi bitmap_line_ydxd::y#2 = bitmap_line_ydxd::y#7 [phi:bitmap_line_ydxd/bitmap_line_ydxd::@2->bitmap_line_ydxd::@1#1] -- register_copy 
    // [574] phi bitmap_line_ydxd::x#3 = bitmap_line_ydxd::x#5 [phi:bitmap_line_ydxd/bitmap_line_ydxd::@2->bitmap_line_ydxd::@1#2] -- register_copy 
    // bitmap_line_ydxd::@1
  __b1:
    // bitmap_plot(x,y,c)
    // [575] bitmap_plot::x#3 = bitmap_line_ydxd::x#3 -- vwum1=vwum2 
    lda x
    sta bitmap_plot.x
    lda x+1
    sta bitmap_plot.x+1
    // [576] bitmap_plot::y#3 = bitmap_line_ydxd::y#2 -- vwum1=vwum2 
    lda y
    sta bitmap_plot.y
    lda y+1
    sta bitmap_plot.y+1
    // [577] bitmap_plot::c#4 = bitmap_line_ydxd::c#3 -- vbum1=vbum2 
    lda c
    sta bitmap_plot.c
    // [578] call bitmap_plot
    // [654] phi from bitmap_line_ydxd::@1 to bitmap_plot [phi:bitmap_line_ydxd::@1->bitmap_plot]
    // [654] phi bitmap_plot::c#5 = bitmap_plot::c#4 [phi:bitmap_line_ydxd::@1->bitmap_plot#0] -- register_copy 
    // [654] phi bitmap_plot::y#4 = bitmap_plot::y#3 [phi:bitmap_line_ydxd::@1->bitmap_plot#1] -- register_copy 
    // [654] phi bitmap_plot::x#10 = bitmap_plot::x#3 [phi:bitmap_line_ydxd::@1->bitmap_plot#2] -- register_copy 
    jsr bitmap_plot
    // bitmap_line_ydxd::@4
    // y = y++;
    // [579] bitmap_line_ydxd::y#3 = ++ bitmap_line_ydxd::y#2 -- vwum1=_inc_vwum1 
    inc y
    bne !+
    inc y+1
  !:
    // e = e+xd
    // [580] bitmap_line_ydxd::e#1 = bitmap_line_ydxd::e#3 + bitmap_line_ydxd::xd#2 -- vwum1=vwum1_plus_vwum2 
    clc
    lda e
    adc xd
    sta e
    lda e+1
    adc xd+1
    sta e+1
    // if(yd<e)
    // [581] if(bitmap_line_ydxd::yd#5>=bitmap_line_ydxd::e#1) goto bitmap_line_ydxd::@2 -- vwum1_ge_vwum2_then_la1 
    cmp yd+1
    bne !+
    lda e
    cmp yd
    beq __b2
  !:
    bcc __b2
    // bitmap_line_ydxd::@3
    // x--;
    // [582] bitmap_line_ydxd::x#2 = -- bitmap_line_ydxd::x#3 -- vwum1=_dec_vwum1 
    lda x
    bne !+
    dec x+1
  !:
    dec x
    // e = e - yd
    // [583] bitmap_line_ydxd::e#2 = bitmap_line_ydxd::e#1 - bitmap_line_ydxd::yd#5 -- vwum1=vwum1_minus_vwum2 
    lda e
    sec
    sbc yd
    sta e
    lda e+1
    sbc yd+1
    sta e+1
    // [584] phi from bitmap_line_ydxd::@3 bitmap_line_ydxd::@4 to bitmap_line_ydxd::@2 [phi:bitmap_line_ydxd::@3/bitmap_line_ydxd::@4->bitmap_line_ydxd::@2]
    // [584] phi bitmap_line_ydxd::e#6 = bitmap_line_ydxd::e#2 [phi:bitmap_line_ydxd::@3/bitmap_line_ydxd::@4->bitmap_line_ydxd::@2#0] -- register_copy 
    // [584] phi bitmap_line_ydxd::x#6 = bitmap_line_ydxd::x#2 [phi:bitmap_line_ydxd::@3/bitmap_line_ydxd::@4->bitmap_line_ydxd::@2#1] -- register_copy 
    // bitmap_line_ydxd::@2
  __b2:
    // y1+1
    // [585] bitmap_line_ydxd::$6 = bitmap_line_ydxd::y1#6 + 1 -- vwum1=vwum2_plus_1 
    clc
    lda y1
    adc #1
    sta __6
    lda y1+1
    adc #0
    sta __6+1
    // while (y!=(y1+1))
    // [586] if(bitmap_line_ydxd::y#3!=bitmap_line_ydxd::$6) goto bitmap_line_ydxd::@1 -- vwum1_neq_vwum2_then_la1 
    lda y+1
    cmp __6+1
    beq !__b1+
    jmp __b1
  !__b1:
    lda y
    cmp __6
    beq !__b1+
    jmp __b1
  !__b1:
    // bitmap_line_ydxd::@return
    // }
    // [587] return 
    rts
  .segment Data
    __6: .word 0
    y: .word 0
    x: .word 0
    y1: .word 0
    yd: .word 0
    xd: .word 0
    c: .byte 0
    e: .word 0
}
.segment Code
  // bitmap_line_xdyd
// void bitmap_line_xdyd(__mem() unsigned int x, __mem() unsigned int y, __mem() unsigned int x1, __mem() unsigned int xd, __mem() unsigned int yd, __mem() char c)
bitmap_line_xdyd: {
    // unsigned int e = yd>>1
    // [589] bitmap_line_xdyd::e#0 = bitmap_line_xdyd::yd#2 >> 1 -- vwum1=vwum2_ror_1 
    lda yd+1
    lsr
    sta e+1
    lda yd
    ror
    sta e
    // [590] phi from bitmap_line_xdyd bitmap_line_xdyd::@2 to bitmap_line_xdyd::@1 [phi:bitmap_line_xdyd/bitmap_line_xdyd::@2->bitmap_line_xdyd::@1]
    // [590] phi bitmap_line_xdyd::e#3 = bitmap_line_xdyd::e#0 [phi:bitmap_line_xdyd/bitmap_line_xdyd::@2->bitmap_line_xdyd::@1#0] -- register_copy 
    // [590] phi bitmap_line_xdyd::y#3 = bitmap_line_xdyd::y#5 [phi:bitmap_line_xdyd/bitmap_line_xdyd::@2->bitmap_line_xdyd::@1#1] -- register_copy 
    // [590] phi bitmap_line_xdyd::x#3 = bitmap_line_xdyd::x#6 [phi:bitmap_line_xdyd/bitmap_line_xdyd::@2->bitmap_line_xdyd::@1#2] -- register_copy 
    // bitmap_line_xdyd::@1
  __b1:
    // bitmap_plot(x,y,c)
    // [591] bitmap_plot::x#1 = bitmap_line_xdyd::x#3 -- vwum1=vwum2 
    lda x
    sta bitmap_plot.x
    lda x+1
    sta bitmap_plot.x+1
    // [592] bitmap_plot::y#1 = bitmap_line_xdyd::y#3 -- vwum1=vwum2 
    lda y
    sta bitmap_plot.y
    lda y+1
    sta bitmap_plot.y+1
    // [593] bitmap_plot::c#2 = bitmap_line_xdyd::c#3 -- vbum1=vbum2 
    lda c
    sta bitmap_plot.c
    // [594] call bitmap_plot
    // [654] phi from bitmap_line_xdyd::@1 to bitmap_plot [phi:bitmap_line_xdyd::@1->bitmap_plot]
    // [654] phi bitmap_plot::c#5 = bitmap_plot::c#2 [phi:bitmap_line_xdyd::@1->bitmap_plot#0] -- register_copy 
    // [654] phi bitmap_plot::y#4 = bitmap_plot::y#1 [phi:bitmap_line_xdyd::@1->bitmap_plot#1] -- register_copy 
    // [654] phi bitmap_plot::x#10 = bitmap_plot::x#1 [phi:bitmap_line_xdyd::@1->bitmap_plot#2] -- register_copy 
    jsr bitmap_plot
    // bitmap_line_xdyd::@4
    // x++;
    // [595] bitmap_line_xdyd::x#2 = ++ bitmap_line_xdyd::x#3 -- vwum1=_inc_vwum1 
    inc x
    bne !+
    inc x+1
  !:
    // e = e+yd
    // [596] bitmap_line_xdyd::e#1 = bitmap_line_xdyd::e#3 + bitmap_line_xdyd::yd#2 -- vwum1=vwum1_plus_vwum2 
    clc
    lda e
    adc yd
    sta e
    lda e+1
    adc yd+1
    sta e+1
    // if(xd<e)
    // [597] if(bitmap_line_xdyd::xd#5>=bitmap_line_xdyd::e#1) goto bitmap_line_xdyd::@2 -- vwum1_ge_vwum2_then_la1 
    cmp xd+1
    bne !+
    lda e
    cmp xd
    beq __b2
  !:
    bcc __b2
    // bitmap_line_xdyd::@3
    // y--;
    // [598] bitmap_line_xdyd::y#2 = -- bitmap_line_xdyd::y#3 -- vwum1=_dec_vwum1 
    lda y
    bne !+
    dec y+1
  !:
    dec y
    // e = e - xd
    // [599] bitmap_line_xdyd::e#2 = bitmap_line_xdyd::e#1 - bitmap_line_xdyd::xd#5 -- vwum1=vwum1_minus_vwum2 
    lda e
    sec
    sbc xd
    sta e
    lda e+1
    sbc xd+1
    sta e+1
    // [600] phi from bitmap_line_xdyd::@3 bitmap_line_xdyd::@4 to bitmap_line_xdyd::@2 [phi:bitmap_line_xdyd::@3/bitmap_line_xdyd::@4->bitmap_line_xdyd::@2]
    // [600] phi bitmap_line_xdyd::e#6 = bitmap_line_xdyd::e#2 [phi:bitmap_line_xdyd::@3/bitmap_line_xdyd::@4->bitmap_line_xdyd::@2#0] -- register_copy 
    // [600] phi bitmap_line_xdyd::y#6 = bitmap_line_xdyd::y#2 [phi:bitmap_line_xdyd::@3/bitmap_line_xdyd::@4->bitmap_line_xdyd::@2#1] -- register_copy 
    // bitmap_line_xdyd::@2
  __b2:
    // x1+1
    // [601] bitmap_line_xdyd::$6 = bitmap_line_xdyd::x1#6 + 1 -- vwum1=vwum2_plus_1 
    clc
    lda x1
    adc #1
    sta __6
    lda x1+1
    adc #0
    sta __6+1
    // while (x!=(x1+1))
    // [602] if(bitmap_line_xdyd::x#2!=bitmap_line_xdyd::$6) goto bitmap_line_xdyd::@1 -- vwum1_neq_vwum2_then_la1 
    lda x+1
    cmp __6+1
    beq !__b1+
    jmp __b1
  !__b1:
    lda x
    cmp __6
    beq !__b1+
    jmp __b1
  !__b1:
    // bitmap_line_xdyd::@return
    // }
    // [603] return 
    rts
  .segment Data
    __6: .word 0
    x: .word 0
    y: .word 0
    x1: .word 0
    xd: .word 0
    yd: .word 0
    c: .byte 0
    e: .word 0
}
.segment Code
  // divr16u
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __mem() unsigned int divr16u(__mem() unsigned int dividend, __mem() unsigned int divisor, __mem() unsigned int rem)
divr16u: {
    // [605] phi from divr16u to divr16u::@1 [phi:divr16u->divr16u::@1]
    // [605] phi divr16u::i#2 = 0 [phi:divr16u->divr16u::@1#0] -- vbum1=vbuc1 
    lda #0
    sta i
    // [605] phi divr16u::quotient#3 = 0 [phi:divr16u->divr16u::@1#1] -- vwum1=vwuc1 
    sta quotient
    sta quotient+1
    // [605] phi divr16u::dividend#2 = divr16u::dividend#1 [phi:divr16u->divr16u::@1#2] -- register_copy 
    // [605] phi divr16u::rem#4 = 0 [phi:divr16u->divr16u::@1#3] -- vwum1=vbuc1 
    sta rem
    sta rem+1
    // [605] phi from divr16u::@3 to divr16u::@1 [phi:divr16u::@3->divr16u::@1]
    // [605] phi divr16u::i#2 = divr16u::i#1 [phi:divr16u::@3->divr16u::@1#0] -- register_copy 
    // [605] phi divr16u::quotient#3 = divr16u::return#0 [phi:divr16u::@3->divr16u::@1#1] -- register_copy 
    // [605] phi divr16u::dividend#2 = divr16u::dividend#0 [phi:divr16u::@3->divr16u::@1#2] -- register_copy 
    // [605] phi divr16u::rem#4 = divr16u::rem#10 [phi:divr16u::@3->divr16u::@1#3] -- register_copy 
    // divr16u::@1
  __b1:
    // rem = rem << 1
    // [606] divr16u::rem#0 = divr16u::rem#4 << 1 -- vwum1=vwum1_rol_1 
    asl rem
    rol rem+1
    // BYTE1(dividend)
    // [607] divr16u::$1 = byte1  divr16u::dividend#2 -- vbum1=_byte1_vwum2 
    lda dividend+1
    sta __1
    // BYTE1(dividend) & $80
    // [608] divr16u::$2 = divr16u::$1 & $80 -- vbum1=vbum1_band_vbuc1 
    lda #$80
    and __2
    sta __2
    // if( (BYTE1(dividend) & $80) != 0 )
    // [609] if(divr16u::$2==0) goto divr16u::@2 -- vbum1_eq_0_then_la1 
    beq __b2
    // divr16u::@4
    // rem = rem | 1
    // [610] divr16u::rem#1 = divr16u::rem#0 | 1 -- vwum1=vwum1_bor_vbuc1 
    lda #1
    ora rem
    sta rem
    // [611] phi from divr16u::@1 divr16u::@4 to divr16u::@2 [phi:divr16u::@1/divr16u::@4->divr16u::@2]
    // [611] phi divr16u::rem#5 = divr16u::rem#0 [phi:divr16u::@1/divr16u::@4->divr16u::@2#0] -- register_copy 
    // divr16u::@2
  __b2:
    // dividend = dividend << 1
    // [612] divr16u::dividend#0 = divr16u::dividend#2 << 1 -- vwum1=vwum1_rol_1 
    asl dividend
    rol dividend+1
    // quotient = quotient << 1
    // [613] divr16u::quotient#1 = divr16u::quotient#3 << 1 -- vwum1=vwum1_rol_1 
    asl quotient
    rol quotient+1
    // if(rem>=divisor)
    // [614] if(divr16u::rem#5<divr16u::divisor#0) goto divr16u::@3 -- vwum1_lt_vwum2_then_la1 
    lda rem+1
    cmp divisor+1
    bcc __b3
    bne !+
    lda rem
    cmp divisor
    bcc __b3
  !:
    // divr16u::@5
    // quotient++;
    // [615] divr16u::quotient#2 = ++ divr16u::quotient#1 -- vwum1=_inc_vwum1 
    inc quotient
    bne !+
    inc quotient+1
  !:
    // rem = rem - divisor
    // [616] divr16u::rem#2 = divr16u::rem#5 - divr16u::divisor#0 -- vwum1=vwum1_minus_vwum2 
    lda rem
    sec
    sbc divisor
    sta rem
    lda rem+1
    sbc divisor+1
    sta rem+1
    // [617] phi from divr16u::@2 divr16u::@5 to divr16u::@3 [phi:divr16u::@2/divr16u::@5->divr16u::@3]
    // [617] phi divr16u::return#0 = divr16u::quotient#1 [phi:divr16u::@2/divr16u::@5->divr16u::@3#0] -- register_copy 
    // [617] phi divr16u::rem#10 = divr16u::rem#5 [phi:divr16u::@2/divr16u::@5->divr16u::@3#1] -- register_copy 
    // divr16u::@3
  __b3:
    // for( char i : 0..15)
    // [618] divr16u::i#1 = ++ divr16u::i#2 -- vbum1=_inc_vbum1 
    inc i
    // [619] if(divr16u::i#1!=$10) goto divr16u::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$10
    cmp i
    bne __b1
    // divr16u::@6
    // rem16u = rem
    // [620] rem16u#0 = divr16u::rem#10 -- vwum1=vwum2 
    lda rem
    sta rem16u
    lda rem+1
    sta rem16u+1
    // divr16u::@return
    // }
    // [621] return 
    rts
  .segment Data
    __1: .byte 0
    .label __2 = __1
    rem: .word 0
    .label dividend = modr16u.dividend
    quotient: .word 0
    i: .byte 0
    .label return = quotient
    .label divisor = modr16u.divisor
}
.segment Code
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    // unsigned char cy = __conio.cursor_y
    // [622] insertup::cy#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) -- vbum1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    sta cy
    // unsigned char width = __conio.width * 2
    // [623] insertup::width#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    asl
    sta width
    // [624] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [624] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbum1=vbuc1 
    lda #1
    sta i
    // insertup::@1
  __b1:
    // for(unsigned char i=1; i<=cy; i++)
    // [625] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbum1_le_vbum2_then_la1 
    lda cy
    cmp i
    bcs __b2
    // [626] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [627] call clearline
    jsr clearline
    // insertup::@return
    // }
    // [628] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [629] insertup::$3 = insertup::i#2 - 1 -- vbum1=vbum2_minus_1 
    ldx i
    dex
    stx __3
    // unsigned int line = (i-1) << __conio.rowshift
    // [630] insertup::line#0 = insertup::$3 << *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) -- vwum1=vbum2_rol__deref_pbuc1 
    txa
    ldy __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    sta line
    lda #0
    sta line+1
    cpy #0
    beq !e+
  !:
    asl line
    rol line+1
    dey
    bne !-
  !e:
    // unsigned int start = __conio.mapbase_offset + line
    // [631] insertup::start#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) + insertup::line#0 -- vwum1=_deref_pwuc1_plus_vwum1 
    clc
    lda start
    adc __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta start
    lda start+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta start+1
    // memcpy_vram_vram_inc(0, start, VERA_INC_1, 0, start+__conio.rowskip, VERA_INC_1, width)
    // [632] memcpy_vram_vram_inc::soffset_vram#0 = insertup::start#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwum1=vwum2_plus__deref_pwuc1 
    lda start
    clc
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta memcpy_vram_vram_inc.soffset_vram
    lda start+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta memcpy_vram_vram_inc.soffset_vram+1
    // [633] memcpy_vram_vram_inc::doffset_vram#0 = insertup::start#0
    // [634] memcpy_vram_vram_inc::num#0 = insertup::width#0 -- vwum1=vbum2 
    lda width
    sta memcpy_vram_vram_inc.num
    lda #0
    sta memcpy_vram_vram_inc.num+1
    // [635] call memcpy_vram_vram_inc
    // [681] phi from insertup::@2 to memcpy_vram_vram_inc [phi:insertup::@2->memcpy_vram_vram_inc]
    jsr memcpy_vram_vram_inc
    // insertup::@4
    // for(unsigned char i=1; i<=cy; i++)
    // [636] insertup::i#1 = ++ insertup::i#2 -- vbum1=_inc_vbum1 
    inc i
    // [624] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [624] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    __3: .byte 0
    cy: .byte 0
    width: .byte 0
    line: .word 0
    .label start = line
    i: .byte 0
}
.segment Code
  // clearline
clearline: {
    .label addr = $2a
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [637] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // unsigned int mapbase_offset =  (unsigned int)__conio.mapbase_offset
    // [638] clearline::mapbase_offset#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwum1=_deref_pwuc1 
    // Set address
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta mapbase_offset
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta mapbase_offset+1
    // unsigned int conio_line = __conio.line
    // [639] clearline::conio_line#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) -- vwum1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta conio_line
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    sta conio_line+1
    // mapbase_offset + conio_line
    // [640] clearline::addr#0 = clearline::mapbase_offset#0 + clearline::conio_line#0 -- vwuz1=vwum2_plus_vwum3 
    lda mapbase_offset
    clc
    adc conio_line
    sta.z addr
    lda mapbase_offset+1
    adc conio_line+1
    sta.z addr+1
    // BYTE0(addr)
    // [641] clearline::$1 = byte0  (char *)clearline::addr#0 -- vbum1=_byte0_pbuz2 
    lda.z addr
    sta __1
    // *VERA_ADDRX_L = BYTE0(addr)
    // [642] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(addr)
    // [643] clearline::$2 = byte1  (char *)clearline::addr#0 -- vbum1=_byte1_pbuz2 
    lda.z addr+1
    sta __2
    // *VERA_ADDRX_M = BYTE1(addr)
    // [644] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [645] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // char color = __conio.color
    // [646] clearline::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbum1=_deref_pbuc1 
    // TODO need to check this!
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta color
    // [647] phi from clearline to clearline::@1 [phi:clearline->clearline::@1]
    // [647] phi clearline::c#2 = 0 [phi:clearline->clearline::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta c
    sta c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<__conio.width; c++ )
    // [648] if(clearline::c#2<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto clearline::@2 -- vwum1_lt__deref_pbuc1_then_la1 
    lda c+1
    bne !+
    lda c
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    bcc __b2
  !:
    // clearline::@3
    // __conio.cursor_x = 0
    // [649] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // clearline::@return
    // }
    // [650] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [651] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [652] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbum1 
    lda color
    sta VERA_DATA0
    // for( unsigned int c=0;c<__conio.width; c++ )
    // [653] clearline::c#1 = ++ clearline::c#2 -- vwum1=_inc_vwum1 
    inc c
    bne !+
    inc c+1
  !:
    // [647] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [647] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    __1: .byte 0
    __2: .byte 0
    mapbase_offset: .word 0
    conio_line: .word 0
    color: .byte 0
    c: .word 0
}
.segment Code
  // bitmap_plot
// void bitmap_plot(__mem() unsigned int x, __mem() unsigned int y, __mem() char c)
bitmap_plot: {
    .label __12 = $28
    .label __13 = $22
    .label __14 = $24
    .label __15 = $26
    // unsigned long plot_x = __bitmap.plot_x[x]
    // [655] bitmap_plot::$9 = bitmap_plot::x#10 << 1 -- vwum1=vwum2_rol_1 
    lda x
    asl
    sta __9
    lda x+1
    rol
    sta __9+1
    // [656] bitmap_plot::$12 = (unsigned int *)&__bitmap + bitmap_plot::$9 -- pwuz1=pwuc1_plus_vwum2 
    lda __9
    clc
    adc #<__bitmap
    sta.z __12
    lda __9+1
    adc #>__bitmap
    sta.z __12+1
    // [657] bitmap_plot::plot_x#0 = (unsigned long)*bitmap_plot::$12 -- vdum1=_dword__deref_pwuz2 
    // Needs unsigned int arrays arranged as two underlying char arrays to allow char* plotter_x = plot_x[x]; - and eventually - char* plotter = plot_x[x] + plot_y[y];
    ldy #0
    sty plot_x+2
    sty plot_x+3
    lda (__12),y
    sta plot_x
    iny
    lda (__12),y
    sta plot_x+1
    // unsigned long plot_y = __bitmap.plot_y[y]
    // [658] bitmap_plot::$10 = bitmap_plot::y#4 << 2 -- vwum1=vwum1_rol_2 
    asl __10
    rol __10+1
    asl __10
    rol __10+1
    // [659] bitmap_plot::$13 = (unsigned long *)&__bitmap+$500 + bitmap_plot::$10 -- pduz1=pduc1_plus_vwum2 
    lda __10
    clc
    adc #<__bitmap+$500
    sta.z __13
    lda __10+1
    adc #>__bitmap+$500
    sta.z __13+1
    // [660] bitmap_plot::plot_y#0 = *bitmap_plot::$13 -- vdum1=_deref_pduz2 
    ldy #0
    lda (__13),y
    sta plot_y
    iny
    lda (__13),y
    sta plot_y+1
    iny
    lda (__13),y
    sta plot_y+2
    iny
    lda (__13),y
    sta plot_y+3
    // unsigned long plotter = plot_x+plot_y
    // [661] bitmap_plot::vera_vram_data0_address1_bankaddr#0 = bitmap_plot::plot_x#0 + bitmap_plot::plot_y#0 -- vdum1=vdum1_plus_vdum2 
    clc
    lda vera_vram_data0_address1_bankaddr
    adc plot_y
    sta vera_vram_data0_address1_bankaddr
    lda vera_vram_data0_address1_bankaddr+1
    adc plot_y+1
    sta vera_vram_data0_address1_bankaddr+1
    lda vera_vram_data0_address1_bankaddr+2
    adc plot_y+2
    sta vera_vram_data0_address1_bankaddr+2
    lda vera_vram_data0_address1_bankaddr+3
    adc plot_y+3
    sta vera_vram_data0_address1_bankaddr+3
    // unsigned char bitshift = __bitmap.plot_bitshift[x]
    // [662] bitmap_plot::$14 = (char *)&__bitmap+$f00 + bitmap_plot::x#10 -- pbuz1=pbuc1_plus_vwum2 
    lda x
    clc
    adc #<__bitmap+$f00
    sta.z __14
    lda x+1
    adc #>__bitmap+$f00
    sta.z __14+1
    // [663] bitmap_plot::bitshift#0 = *bitmap_plot::$14 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (__14),y
    sta bitshift
    // bitshift?c<<(bitshift):c
    // [664] if(0!=bitmap_plot::bitshift#0) goto bitmap_plot::@1 -- 0_neq_vbum1_then_la1 
    bne __b1
    // [666] phi from bitmap_plot bitmap_plot::@1 to bitmap_plot::@2 [phi:bitmap_plot/bitmap_plot::@1->bitmap_plot::@2]
    // [666] phi bitmap_plot::c#0 = bitmap_plot::c#5 [phi:bitmap_plot/bitmap_plot::@1->bitmap_plot::@2#0] -- register_copy 
    jmp __b2
    // bitmap_plot::@1
  __b1:
    // [665] bitmap_plot::$3 = bitmap_plot::c#5 << bitmap_plot::bitshift#0 -- vbum1=vbum1_rol_vbum2 
    lda __3
    ldy bitshift
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta __3
    // bitmap_plot::@2
  __b2:
    // bitmap_plot::vera_vram_data0_address1
    // vera_vram_data0_bank_offset( BYTE2(bankaddr), WORD0(bankaddr), inc_dec )
    // [667] bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank#0 = byte2  bitmap_plot::vera_vram_data0_address1_bankaddr#0 -- vbum1=_byte2_vdum2 
    lda vera_vram_data0_address1_bankaddr+2
    sta vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank
    // [668] bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 = word0  bitmap_plot::vera_vram_data0_address1_bankaddr#0 -- vwum1=_word0_vdum2 
    lda vera_vram_data0_address1_bankaddr
    sta vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset
    lda vera_vram_data0_address1_bankaddr+1
    sta vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset+1
    // bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [669] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [670] bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$0 = byte0  bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte0_vwum2 
    lda vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_address1_vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [671] *VERA_ADDRX_L = bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [672] bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$1 = byte1  bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte1_vwum2 
    lda vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset+1
    sta vera_vram_data0_address1_vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [673] *VERA_ADDRX_M = bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [674] *VERA_ADDRX_H = bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbum1 
    lda vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // bitmap_plot::@3
    // ~__bitmap.plot_bitmask[x]
    // [675] bitmap_plot::$15 = (char *)&__bitmap+$c80 + bitmap_plot::x#10 -- pbuz1=pbuc1_plus_vwum2 
    lda x
    clc
    adc #<__bitmap+$c80
    sta.z __15
    lda x+1
    adc #>__bitmap+$c80
    sta.z __15+1
    // [676] bitmap_plot::$6 = ~ *bitmap_plot::$15 -- vbum1=_bnot__deref_pbuz2 
    ldy #0
    lda (__15),y
    eor #$ff
    sta __6
    // *VERA_DATA0 & ~__bitmap.plot_bitmask[x]
    // [677] bitmap_plot::$7 = *VERA_DATA0 & bitmap_plot::$6 -- vbum1=_deref_pbuc1_band_vbum1 
    lda VERA_DATA0
    and __7
    sta __7
    // (*VERA_DATA0 & ~__bitmap.plot_bitmask[x]) | c
    // [678] bitmap_plot::$8 = bitmap_plot::$7 | bitmap_plot::c#0 -- vbum1=vbum2_bor_vbum1 
    lda __8
    ora __7
    sta __8
    // *VERA_DATA0 = (*VERA_DATA0 & ~__bitmap.plot_bitmask[x]) | c
    // [679] *VERA_DATA0 = bitmap_plot::$8 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // bitmap_plot::@return
    // }
    // [680] return 
    rts
  .segment Data
    .label __3 = c
    __6: .byte 0
    .label __7 = __6
    .label __8 = c
    __9: .word 0
    .label __10 = y
    vera_vram_data0_address1_vera_vram_data0_bank_offset1___0: .byte 0
    vera_vram_data0_address1_vera_vram_data0_bank_offset1___1: .byte 0
    plot_x: .dword 0
    plot_y: .dword 0
    bitshift: .byte 0
    c: .byte 0
    .label vera_vram_data0_address1_bankaddr = plot_x
    vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank: .byte 0
    vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset: .word 0
    x: .word 0
    y: .word 0
}
.segment Code
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
// void memcpy_vram_vram_inc(char dbank_vram, __mem() unsigned int doffset_vram, char dinc, char sbank_vram, __mem() unsigned int soffset_vram, char sinc, __mem() unsigned int num)
memcpy_vram_vram_inc: {
    // memcpy_vram_vram_inc::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [682] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [683] memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$0 = byte0  memcpy_vram_vram_inc::soffset_vram#0 -- vbum1=_byte0_vwum2 
    lda soffset_vram
    sta vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [684] *VERA_ADDRX_L = memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [685] memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$1 = byte1  memcpy_vram_vram_inc::soffset_vram#0 -- vbum1=_byte1_vwum2 
    lda soffset_vram+1
    sta vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [686] *VERA_ADDRX_M = memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [687] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // memcpy_vram_vram_inc::vera_vram_data1_bank_offset1
    // *VERA_CTRL |= VERA_ADDRSEL
    // [688] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [689] memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$0 = byte0  memcpy_vram_vram_inc::doffset_vram#0 -- vbum1=_byte0_vwum2 
    lda doffset_vram
    sta vera_vram_data1_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [690] *VERA_ADDRX_L = memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [691] memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$1 = byte1  memcpy_vram_vram_inc::doffset_vram#0 -- vbum1=_byte1_vwum2 
    lda doffset_vram+1
    sta vera_vram_data1_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [692] *VERA_ADDRX_M = memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [693] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // [694] phi from memcpy_vram_vram_inc::vera_vram_data1_bank_offset1 to memcpy_vram_vram_inc::@1 [phi:memcpy_vram_vram_inc::vera_vram_data1_bank_offset1->memcpy_vram_vram_inc::@1]
    // [694] phi memcpy_vram_vram_inc::i#2 = 0 [phi:memcpy_vram_vram_inc::vera_vram_data1_bank_offset1->memcpy_vram_vram_inc::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta i
    sta i+1
  // Transfer the data
    // memcpy_vram_vram_inc::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [695] if(memcpy_vram_vram_inc::i#2<memcpy_vram_vram_inc::num#0) goto memcpy_vram_vram_inc::@2 -- vwum1_lt_vwum2_then_la1 
    lda i+1
    cmp num+1
    bcc __b2
    bne !+
    lda i
    cmp num
    bcc __b2
  !:
    // memcpy_vram_vram_inc::@return
    // }
    // [696] return 
    rts
    // memcpy_vram_vram_inc::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [697] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [698] memcpy_vram_vram_inc::i#1 = ++ memcpy_vram_vram_inc::i#2 -- vwum1=_inc_vwum1 
    inc i
    bne !+
    inc i+1
  !:
    // [694] phi from memcpy_vram_vram_inc::@2 to memcpy_vram_vram_inc::@1 [phi:memcpy_vram_vram_inc::@2->memcpy_vram_vram_inc::@1]
    // [694] phi memcpy_vram_vram_inc::i#2 = memcpy_vram_vram_inc::i#1 [phi:memcpy_vram_vram_inc::@2->memcpy_vram_vram_inc::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    vera_vram_data0_bank_offset1___0: .byte 0
    vera_vram_data0_bank_offset1___1: .byte 0
    vera_vram_data1_bank_offset1___0: .byte 0
    vera_vram_data1_bank_offset1___1: .byte 0
    i: .word 0
    .label doffset_vram = insertup.line
    soffset_vram: .word 0
    num: .word 0
}
  // File Data
  VERA_LAYER_WIDTH: .word $20, $40, $80, $100
  VERA_LAYER_HEIGHT: .word $20, $40, $80, $100
  VERA_LAYER_SKIP: .word $40, $80, $100, $200
  hdeltas: .word 0, $50, $28, $14, 0, $a0, $50, $28, 0, $140, $a0, $50, 0, $280, $140, $a0
  vdeltas: .word 0, $1e0, $f0, $a0
  bitmasks: .byte $80, $c0, $f0, $ff
  .fill 1, 0
  bitshifts: .byte 7, 6, 4, 0
  .fill 1, 0
  // The random state variable
  rand_state: .word 1
  __conio: .fill SIZEOF_STRUCT_CX16_CONIO, 0
  __bitmap: .fill SIZEOF_STRUCT___0, 0
  // Remainder after unsigned 16-bit division
  rem16u: .word 0
