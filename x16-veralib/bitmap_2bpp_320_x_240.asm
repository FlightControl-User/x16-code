  // File Comments
// Example program for the Commander X16.
// Demonstrates the usage of the VERA graphic modes and layering.
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="bitmap_2bpp_320_x_240.prg", type="prg", segments="Program"]
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
  .const VERA_LAYER_COLOR_DEPTH_2BPP = 1
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
  // The random state variable
  .label rand_state = $b4
  // Remainder after unsigned 16-bit division
  .label rem16u = $7a
.segment Code
  // __start
__start: {
    // __start::__init1
    // __address(0) char BRAM
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // volatile unsigned int rand_state = 1
    // [2] rand_state = 1 -- vwuz1=vwuc1 
    lda #<1
    sta.z rand_state
    lda #>1
    sta.z rand_state+1
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [3] call conio_x16_init
    jsr conio_x16_init
    // [4] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [5] call main
    // [64] phi from __start::@1 to main [phi:__start::@1->main]
    jsr main
    // __start::@return
    // [6] return 
    rts
}
  // conio_x16_init
// Set initial cursor position
conio_x16_init: {
    // // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label __8 = $7d
    .label __9 = $61
    .label __10 = $7d
    .label __11 = $b6
    .label line = $68
    // char line = *BASIC_CURSOR_LINE
    // [7] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda.z BASIC_CURSOR_LINE
    sta.z line
    // screensize(&__conio.width, &__conio.height)
    // [8] call screensize
    // *VERA_L1_CONFIG &= ~VERA_LAYER_CONFIG_256C;
    // *VERA_L1_CONFIG |= VERA_LAYER_CONFIG_16C;
    jsr screensize
    // [9] phi from conio_x16_init to conio_x16_init::@3 [phi:conio_x16_init->conio_x16_init::@3]
    // conio_x16_init::@3
    // screenlayer1()
    // [10] call screenlayer1
    // TODO, this should become a ROM call for the CX16.
    jsr screenlayer1
    // [11] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // textcolor(WHITE)
    // [12] call textcolor
    // [212] phi from conio_x16_init::@4 to textcolor [phi:conio_x16_init::@4->textcolor]
    // [212] phi textcolor::color#6 = WHITE [phi:conio_x16_init::@4->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [13] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // bgcolor(BLUE)
    // [14] call bgcolor
    // [217] phi from conio_x16_init::@5 to bgcolor [phi:conio_x16_init::@5->bgcolor]
    // [217] phi bgcolor::color#4 = BLUE [phi:conio_x16_init::@5->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLUE
    sta.z bgcolor.color
    jsr bgcolor
    // [15] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // cursor(0)
    // [16] call cursor
    jsr cursor
    // conio_x16_init::@7
    // if(line>=__conio.height)
    // [17] if(conio_x16_init::line#0<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto conio_x16_init::@1 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z line
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    // [18] phi from conio_x16_init::@7 to conio_x16_init::@2 [phi:conio_x16_init::@7->conio_x16_init::@2]
    // conio_x16_init::@2
    // [19] phi from conio_x16_init::@2 conio_x16_init::@7 to conio_x16_init::@1 [phi:conio_x16_init::@2/conio_x16_init::@7->conio_x16_init::@1]
    // conio_x16_init::@1
    // cbm_k_plot_get()
    // [20] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [21] cbm_k_plot_get::return#2 = cbm_k_plot_get::return#0
    // conio_x16_init::@8
    // [22] conio_x16_init::$8 = cbm_k_plot_get::return#2
    // BYTE1(cbm_k_plot_get())
    // [23] conio_x16_init::$9 = byte1  conio_x16_init::$8 -- vbuz1=_byte1_vwuz2 
    lda.z __8+1
    sta.z __9
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [24] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = conio_x16_init::$9 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // cbm_k_plot_get()
    // [25] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [26] cbm_k_plot_get::return#3 = cbm_k_plot_get::return#0
    // conio_x16_init::@9
    // [27] conio_x16_init::$10 = cbm_k_plot_get::return#3
    // BYTE0(cbm_k_plot_get())
    // [28] conio_x16_init::$11 = byte0  conio_x16_init::$10 -- vbuz1=_byte0_vwuz2 
    lda.z __10
    sta.z __11
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [29] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = conio_x16_init::$11 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // gotoxy(__conio.cursor_x, __conio.cursor_y)
    // [30] gotoxy::x#1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    sta.z gotoxy.x
    // [31] gotoxy::y#1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    sta.z gotoxy.y
    // [32] call gotoxy
    // [230] phi from conio_x16_init::@9 to gotoxy [phi:conio_x16_init::@9->gotoxy]
    // [230] phi gotoxy::x#10 = gotoxy::x#1 [phi:conio_x16_init::@9->gotoxy#0] -- register_copy 
    // [230] phi gotoxy::y#8 = gotoxy::y#1 [phi:conio_x16_init::@9->gotoxy#1] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [33] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__zp($2e) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    .label __1 = $6c
    .label __3 = $79
    .label __4 = $77
    .label __5 = $76
    .label __14 = $44
    .label c = $2e
    .label color = $69
    .label mapbase_offset = $4a
    .label mapwidth = $5a
    .label conio_addr = $4a
    .label scroll_enable = $73
    // [34] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbuz1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta.z c
    // char color = __conio.color
    // [35] cputc::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z color
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [36] cputc::mapbase_offset#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z mapbase_offset
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z mapbase_offset+1
    // unsigned int mapwidth = __conio.mapwidth
    // [37] cputc::mapwidth#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    sta.z mapwidth
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    sta.z mapwidth+1
    // unsigned int conio_addr = mapbase_offset + __conio.line
    // [38] cputc::conio_addr#0 = cputc::mapbase_offset#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z conio_addr
    adc __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta.z conio_addr
    lda.z conio_addr+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    sta.z conio_addr+1
    // __conio.cursor_x << 1
    // [39] cputc::$1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    asl
    sta.z __1
    // conio_addr += __conio.cursor_x << 1
    // [40] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$1 -- vwuz1=vwuz1_plus_vbuz2 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [41] if(cputc::c#0==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [42] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(conio_addr)
    // [43] cputc::$3 = byte0  cputc::conio_addr#1 -- vbuz1=_byte0_vwuz2 
    lda.z conio_addr
    sta.z __3
    // *VERA_ADDRX_L = BYTE0(conio_addr)
    // [44] *VERA_ADDRX_L = cputc::$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(conio_addr)
    // [45] cputc::$4 = byte1  cputc::conio_addr#1 -- vbuz1=_byte1_vwuz2 
    lda.z conio_addr+1
    sta.z __4
    // *VERA_ADDRX_M = BYTE1(conio_addr)
    // [46] *VERA_ADDRX_M = cputc::$4 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [47] cputc::$5 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    sta.z __5
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [48] *VERA_ADDRX_H = cputc::$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [49] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [50] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // __conio.cursor_x++;
    // [51] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = ++ *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // unsigned char scroll_enable = __conio.scroll[__conio.layer]
    // [52] cputc::scroll_enable#0 = ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_SCROLL)[*((char *)&__conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_SCROLL,y
    sta.z scroll_enable
    // if(scroll_enable)
    // [53] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuz1_then_la1 
    bne __b5
    // cputc::@3
    // (unsigned int)__conio.cursor_x == mapwidth
    // [54] cputc::$14 = (unsigned int)*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) -- vwuz1=_word__deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    sta.z __14
    lda #0
    sta.z __14+1
    // if((unsigned int)__conio.cursor_x == mapwidth)
    // [55] if(cputc::$14!=cputc::mapwidth#0) goto cputc::@return -- vwuz1_neq_vwuz2_then_la1 
    cmp.z mapwidth+1
    bne __breturn
    lda.z __14
    cmp.z mapwidth
    bne __breturn
    // [56] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [57] call cputln
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [58] return 
    rts
    // cputc::@5
  __b5:
    // if(__conio.cursor_x == __conio.width)
    // [59] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X)!=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto cputc::@return -- _deref_pbuc1_neq__deref_pbuc2_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    bne __breturn
    // [60] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [61] call cputln
    jsr cputln
    rts
    // [62] phi from cputc to cputc::@1 [phi:cputc->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [63] call cputln
    jsr cputln
    rts
}
  // main
main: {
    .label __28 = $69
    .label __38 = $74
    .label __41 = $69
    .label color = $7c
    .label x = $a9
    // vera_layer0_mode_bitmap(
    //         0, 0x0000, 
    //         VERA_TILEBASE_WIDTH_8, 
    //         VERA_LAYER_COLOR_DEPTH_2BPP
    //     )
    // [65] call vera_layer0_mode_bitmap
    jsr vera_layer0_mode_bitmap
    // [66] phi from main to main::@9 [phi:main->main::@9]
    // main::@9
    // screenlayer1()
    // [67] call screenlayer1
    jsr screenlayer1
    // [68] phi from main::@9 to main::@10 [phi:main::@9->main::@10]
    // main::@10
    // textcolor(WHITE)
    // [69] call textcolor
    // [212] phi from main::@10 to textcolor [phi:main::@10->textcolor]
    // [212] phi textcolor::color#6 = WHITE [phi:main::@10->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [70] phi from main::@10 to main::@11 [phi:main::@10->main::@11]
    // main::@11
    // bgcolor(BLACK)
    // [71] call bgcolor
    // [217] phi from main::@11 to bgcolor [phi:main::@11->bgcolor]
    // [217] phi bgcolor::color#4 = BLACK [phi:main::@11->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [72] phi from main::@11 to main::@12 [phi:main::@11->main::@12]
    // main::@12
    // clrscr()
    // [73] call clrscr
    jsr clrscr
    // [74] phi from main::@12 to main::@13 [phi:main::@12->main::@13]
    // main::@13
    // gotoxy(0,25)
    // [75] call gotoxy
    // [230] phi from main::@13 to gotoxy [phi:main::@13->gotoxy]
    // [230] phi gotoxy::x#10 = 0 [phi:main::@13->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [230] phi gotoxy::y#8 = $19 [phi:main::@13->gotoxy#1] -- vbuz1=vbuc1 
    lda #$19
    sta.z gotoxy.y
    jsr gotoxy
    // [76] phi from main::@13 to main::@14 [phi:main::@13->main::@14]
    // main::@14
    // printf("vera in bitmap mode,\n")
    // [77] call printf_str
    // [285] phi from main::@14 to printf_str [phi:main::@14->printf_str]
    // [285] phi printf_str::s#9 = main::s [phi:main::@14->printf_str#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // [78] phi from main::@14 to main::@15 [phi:main::@14->main::@15]
    // main::@15
    // printf("color depth 2 bits per pixel.\n")
    // [79] call printf_str
    // [285] phi from main::@15 to printf_str [phi:main::@15->printf_str]
    // [285] phi printf_str::s#9 = main::s1 [phi:main::@15->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [80] phi from main::@15 to main::@16 [phi:main::@15->main::@16]
    // main::@16
    // printf("in this mode, it is possible to display\n")
    // [81] call printf_str
    // [285] phi from main::@16 to printf_str [phi:main::@16->printf_str]
    // [285] phi printf_str::s#9 = main::s2 [phi:main::@16->printf_str#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // [82] phi from main::@16 to main::@17 [phi:main::@16->main::@17]
    // main::@17
    // printf("graphics in 4 colors.\n")
    // [83] call printf_str
    // [285] phi from main::@17 to printf_str [phi:main::@17->printf_str]
    // [285] phi printf_str::s#9 = main::s3 [phi:main::@17->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // main::vera_layer0_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [84] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_LAYER0_ENABLE
    // [85] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_LAYER0_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER0_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [86] phi from main::vera_layer0_show1 to main::@8 [phi:main::vera_layer0_show1->main::@8]
    // main::@8
    // bitmap_init(0, 0, 0x0000)
    // [87] call bitmap_init
    jsr bitmap_init
    // [88] phi from main::@8 to main::@18 [phi:main::@8->main::@18]
    // main::@18
    // bitmap_clear()
    // [89] call bitmap_clear
    jsr bitmap_clear
    // [90] phi from main::@18 to main::@19 [phi:main::@18->main::@19]
    // main::@19
    // gotoxy(0,29)
    // [91] call gotoxy
    // [230] phi from main::@19 to gotoxy [phi:main::@19->gotoxy]
    // [230] phi gotoxy::x#10 = 0 [phi:main::@19->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [230] phi gotoxy::y#8 = $1d [phi:main::@19->gotoxy#1] -- vbuz1=vbuc1 
    lda #$1d
    sta.z gotoxy.y
    jsr gotoxy
    // [92] phi from main::@19 to main::@20 [phi:main::@19->main::@20]
    // main::@20
    // textcolor(YELLOW)
    // [93] call textcolor
    // [212] phi from main::@20 to textcolor [phi:main::@20->textcolor]
    // [212] phi textcolor::color#6 = YELLOW [phi:main::@20->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [94] phi from main::@20 to main::@21 [phi:main::@20->main::@21]
    // main::@21
    // printf("press a key ...")
    // [95] call printf_str
    // [285] phi from main::@21 to printf_str [phi:main::@21->printf_str]
    // [285] phi printf_str::s#9 = main::s4 [phi:main::@21->printf_str#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // [96] phi from main::@21 main::@31 to main::@1 [phi:main::@21/main::@31->main::@1]
    // main::@1
  __b1:
    // kbhit()
    // [97] call kbhit
    // [395] phi from main::@1 to kbhit [phi:main::@1->kbhit]
    jsr kbhit
    // kbhit()
    // [98] kbhit::return#2 = kbhit::return#0
    // main::@22
    // [99] main::$28 = kbhit::return#2
    // while(!kbhit())
    // [100] if(0==main::$28) goto main::@2 -- 0_eq_vbuz1_then_la1 
    lda.z __28
    bne !__b2+
    jmp __b2
  !__b2:
    // [101] phi from main::@22 to main::@3 [phi:main::@22->main::@3]
    // main::@3
    // textcolor(WHITE)
    // [102] call textcolor
    // [212] phi from main::@3 to textcolor [phi:main::@3->textcolor]
    // [212] phi textcolor::color#6 = WHITE [phi:main::@3->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [103] phi from main::@3 to main::@32 [phi:main::@3->main::@32]
    // main::@32
    // bgcolor(BLACK)
    // [104] call bgcolor
    // [217] phi from main::@32 to bgcolor [phi:main::@32->bgcolor]
    // [217] phi bgcolor::color#4 = BLACK [phi:main::@32->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [105] phi from main::@32 to main::@33 [phi:main::@32->main::@33]
    // main::@33
    // clrscr()
    // [106] call clrscr
    jsr clrscr
    // [107] phi from main::@33 to main::@34 [phi:main::@33->main::@34]
    // main::@34
    // gotoxy(0,26)
    // [108] call gotoxy
    // [230] phi from main::@34 to gotoxy [phi:main::@34->gotoxy]
    // [230] phi gotoxy::x#10 = 0 [phi:main::@34->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [230] phi gotoxy::y#8 = $1a [phi:main::@34->gotoxy#1] -- vbuz1=vbuc1 
    lda #$1a
    sta.z gotoxy.y
    jsr gotoxy
    // [109] phi from main::@34 to main::@35 [phi:main::@34->main::@35]
    // main::@35
    // printf("here you see all the colors possible.\n")
    // [110] call printf_str
    // [285] phi from main::@35 to printf_str [phi:main::@35->printf_str]
    // [285] phi printf_str::s#9 = main::s5 [phi:main::@35->printf_str#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // [111] phi from main::@35 to main::@36 [phi:main::@35->main::@36]
    // main::@36
    // gotoxy(0,29)
    // [112] call gotoxy
    // [230] phi from main::@36 to gotoxy [phi:main::@36->gotoxy]
    // [230] phi gotoxy::x#10 = 0 [phi:main::@36->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [230] phi gotoxy::y#8 = $1d [phi:main::@36->gotoxy#1] -- vbuz1=vbuc1 
    lda #$1d
    sta.z gotoxy.y
    jsr gotoxy
    // [113] phi from main::@36 to main::@37 [phi:main::@36->main::@37]
    // main::@37
    // textcolor(YELLOW)
    // [114] call textcolor
    // [212] phi from main::@37 to textcolor [phi:main::@37->textcolor]
    // [212] phi textcolor::color#6 = YELLOW [phi:main::@37->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [115] phi from main::@37 to main::@38 [phi:main::@37->main::@38]
    // main::@38
    // printf("press a key ...")
    // [116] call printf_str
    // [285] phi from main::@38 to printf_str [phi:main::@38->printf_str]
    // [285] phi printf_str::s#9 = main::s4 [phi:main::@38->printf_str#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // [117] phi from main::@38 to main::@4 [phi:main::@38->main::@4]
    // [117] phi main::color#3 = 0 [phi:main::@38->main::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [117] phi main::x#3 = 0 [phi:main::@38->main::@4#1] -- vwuz1=vwuc1 
    sta.z x
    sta.z x+1
    // main::@4
  __b4:
    // kbhit()
    // [118] call kbhit
    // [395] phi from main::@4 to kbhit [phi:main::@4->kbhit]
    jsr kbhit
    // kbhit()
    // [119] kbhit::return#3 = kbhit::return#0
    // main::@39
    // [120] main::$41 = kbhit::return#3
    // while(!kbhit())
    // [121] if(0==main::$41) goto main::@5 -- 0_eq_vbuz1_then_la1 
    lda.z __41
    beq __b5
    // [122] phi from main::@39 to main::@6 [phi:main::@39->main::@6]
    // main::@6
    // screenlayer1()
    // [123] call screenlayer1
    jsr screenlayer1
    // [124] phi from main::@6 to main::@41 [phi:main::@6->main::@41]
    // main::@41
    // textcolor(WHITE)
    // [125] call textcolor
    // [212] phi from main::@41 to textcolor [phi:main::@41->textcolor]
    // [212] phi textcolor::color#6 = WHITE [phi:main::@41->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [126] phi from main::@41 to main::@42 [phi:main::@41->main::@42]
    // main::@42
    // bgcolor(BLUE)
    // [127] call bgcolor
    // [217] phi from main::@42 to bgcolor [phi:main::@42->bgcolor]
    // [217] phi bgcolor::color#4 = BLUE [phi:main::@42->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLUE
    sta.z bgcolor.color
    jsr bgcolor
    // [128] phi from main::@42 to main::@43 [phi:main::@42->main::@43]
    // main::@43
    // clrscr()
    // [129] call clrscr
    jsr clrscr
    // main::@return
    // }
    // [130] return 
    rts
    // main::@5
  __b5:
    // bitmap_line(x, x, 0, 199, color)
    // [131] bitmap_line::x0#1 = main::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x0
    lda.z x+1
    sta.z bitmap_line.x0+1
    // [132] bitmap_line::x1#1 = main::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x1
    lda.z x+1
    sta.z bitmap_line.x1+1
    // [133] bitmap_line::c#1 = main::color#3 -- vbuz1=vbuz2 
    lda.z color
    sta.z bitmap_line.c
    // [134] call bitmap_line
    // [400] phi from main::@5 to bitmap_line [phi:main::@5->bitmap_line]
    // [400] phi bitmap_line::c#10 = bitmap_line::c#1 [phi:main::@5->bitmap_line#0] -- register_copy 
    // [400] phi bitmap_line::y1#10 = $c7 [phi:main::@5->bitmap_line#1] -- vwuz1=vbuc1 
    lda #<$c7
    sta.z bitmap_line.y1
    lda #>$c7
    sta.z bitmap_line.y1+1
    // [400] phi bitmap_line::y0#10 = 0 [phi:main::@5->bitmap_line#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z bitmap_line.y0
    sta.z bitmap_line.y0+1
    // [400] phi bitmap_line::x1#10 = bitmap_line::x1#1 [phi:main::@5->bitmap_line#3] -- register_copy 
    // [400] phi bitmap_line::x0#10 = bitmap_line::x0#1 [phi:main::@5->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    // main::@40
    // color++;
    // [135] main::color#1 = ++ main::color#3 -- vbuz1=_inc_vbuz1 
    inc.z color
    // if(color>3)
    // [136] if(main::color#1<3+1) goto main::@45 -- vbuz1_lt_vbuc1_then_la1 
    lda.z color
    cmp #3+1
    bcc __b7
    // [138] phi from main::@40 to main::@7 [phi:main::@40->main::@7]
    // [138] phi main::color#7 = 0 [phi:main::@40->main::@7#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [137] phi from main::@40 to main::@45 [phi:main::@40->main::@45]
    // main::@45
    // [138] phi from main::@45 to main::@7 [phi:main::@45->main::@7]
    // [138] phi main::color#7 = main::color#1 [phi:main::@45->main::@7#0] -- register_copy 
    // main::@7
  __b7:
    // x++;
    // [139] main::x#1 = ++ main::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // if(x>319)
    // [140] if(main::x#1<=$13f) goto main::@44 -- vwuz1_le_vwuc1_then_la1 
    lda.z x+1
    cmp #>$13f
    bne !+
    lda.z x
    cmp #<$13f
  !:
    bcc __b4
    beq __b4
    // [117] phi from main::@7 to main::@4 [phi:main::@7->main::@4]
    // [117] phi main::color#3 = main::color#7 [phi:main::@7->main::@4#0] -- register_copy 
    // [117] phi main::x#3 = 0 [phi:main::@7->main::@4#1] -- vwuz1=vbuc1 
    lda #<0
    sta.z x
    sta.z x+1
    jmp __b4
    // [141] phi from main::@7 to main::@44 [phi:main::@7->main::@44]
    // main::@44
    // [117] phi from main::@44 to main::@4 [phi:main::@44->main::@4]
    // [117] phi main::color#3 = main::color#7 [phi:main::@44->main::@4#0] -- register_copy 
    // [117] phi main::x#3 = main::x#1 [phi:main::@44->main::@4#1] -- register_copy 
    // [142] phi from main::@22 to main::@2 [phi:main::@22->main::@2]
    // main::@2
  __b2:
    // rand()
    // [143] call rand
    jsr rand
    // [144] rand::return#2 = rand::return#0
    // main::@23
    // modr16u(rand(),320,0)
    // [145] modr16u::dividend#0 = rand::return#2
    // [146] call modr16u
    // [479] phi from main::@23 to modr16u [phi:main::@23->modr16u]
    // [479] phi modr16u::divisor#4 = $140 [phi:main::@23->modr16u#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z modr16u.divisor
    lda #>$140
    sta.z modr16u.divisor+1
    // [479] phi modr16u::dividend#4 = modr16u::dividend#0 [phi:main::@23->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),320,0)
    // [147] modr16u::return#2 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_1
    lda.z modr16u.return+1
    sta.z modr16u.return_1+1
    // main::@24
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&3)
    // [148] bitmap_line::x0#0 = modr16u::return#2
    // rand()
    // [149] call rand
    jsr rand
    // [150] rand::return#3 = rand::return#0
    // main::@25
    // modr16u(rand(),320,0)
    // [151] modr16u::dividend#1 = rand::return#3
    // [152] call modr16u
    // [479] phi from main::@25 to modr16u [phi:main::@25->modr16u]
    // [479] phi modr16u::divisor#4 = $140 [phi:main::@25->modr16u#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z modr16u.divisor
    lda #>$140
    sta.z modr16u.divisor+1
    // [479] phi modr16u::dividend#4 = modr16u::dividend#1 [phi:main::@25->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),320,0)
    // [153] modr16u::return#3 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_2
    lda.z modr16u.return+1
    sta.z modr16u.return_2+1
    // main::@26
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&3)
    // [154] bitmap_line::x1#0 = modr16u::return#3
    // rand()
    // [155] call rand
    jsr rand
    // [156] rand::return#10 = rand::return#0
    // main::@27
    // modr16u(rand(),200,0)
    // [157] modr16u::dividend#2 = rand::return#10
    // [158] call modr16u
    // [479] phi from main::@27 to modr16u [phi:main::@27->modr16u]
    // [479] phi modr16u::divisor#4 = $c8 [phi:main::@27->modr16u#0] -- vwuz1=vbuc1 
    lda #<$c8
    sta.z modr16u.divisor
    lda #>$c8
    sta.z modr16u.divisor+1
    // [479] phi modr16u::dividend#4 = modr16u::dividend#2 [phi:main::@27->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),200,0)
    // [159] modr16u::return#4 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_3
    lda.z modr16u.return+1
    sta.z modr16u.return_3+1
    // main::@28
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&3)
    // [160] bitmap_line::y0#0 = modr16u::return#4
    // rand()
    // [161] call rand
    jsr rand
    // [162] rand::return#11 = rand::return#0
    // main::@29
    // modr16u(rand(),200,0)
    // [163] modr16u::dividend#3 = rand::return#11
    // [164] call modr16u
    // [479] phi from main::@29 to modr16u [phi:main::@29->modr16u]
    // [479] phi modr16u::divisor#4 = $c8 [phi:main::@29->modr16u#0] -- vwuz1=vbuc1 
    lda #<$c8
    sta.z modr16u.divisor
    lda #>$c8
    sta.z modr16u.divisor+1
    // [479] phi modr16u::dividend#4 = modr16u::dividend#3 [phi:main::@29->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),200,0)
    // [165] modr16u::return#10 = modr16u::return#0
    // main::@30
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&3)
    // [166] bitmap_line::y1#0 = modr16u::return#10
    // rand()
    // [167] call rand
    jsr rand
    // [168] rand::return#12 = rand::return#0
    // main::@31
    // [169] main::$38 = rand::return#12
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&3)
    // [170] bitmap_line::c#0 = main::$38 & 3 -- vbuz1=vwuz2_band_vbuc1 
    lda #3
    and.z __38
    sta.z bitmap_line.c
    // [171] call bitmap_line
    // [400] phi from main::@31 to bitmap_line [phi:main::@31->bitmap_line]
    // [400] phi bitmap_line::c#10 = bitmap_line::c#0 [phi:main::@31->bitmap_line#0] -- register_copy 
    // [400] phi bitmap_line::y1#10 = bitmap_line::y1#0 [phi:main::@31->bitmap_line#1] -- register_copy 
    // [400] phi bitmap_line::y0#10 = bitmap_line::y0#0 [phi:main::@31->bitmap_line#2] -- register_copy 
    // [400] phi bitmap_line::x1#10 = bitmap_line::x1#0 [phi:main::@31->bitmap_line#3] -- register_copy 
    // [400] phi bitmap_line::x0#10 = bitmap_line::x0#0 [phi:main::@31->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    jmp __b1
  .segment Data
    s: .text @"vera in bitmap mode,\n"
    .byte 0
    s1: .text @"color depth 2 bits per pixel.\n"
    .byte 0
    s2: .text @"in this mode, it is possible to display\n"
    .byte 0
    s3: .text @"graphics in 4 colors.\n"
    .byte 0
    s4: .text "press a key ..."
    .byte 0
    s5: .text @"here you see all the colors possible.\n"
    .byte 0
}
.segment Code
  // screensize
// Return the current screen size.
// void screensize(char *x, char *y)
screensize: {
    .label x = __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    .label y = __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    .label __1 = $ae
    .label __3 = $af
    .label hscale = $ae
    .label vscale = $af
    // char hscale = (*VERA_DC_HSCALE) >> 7
    // [172] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
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
    // [173] screensize::$1 = $28 << screensize::hscale#0 -- vbuz1=vbuc1_rol_vbuz1 
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
    // [174] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbuz1 
    sta x
    // char vscale = (*VERA_DC_VSCALE) >> 7
    // [175] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    sta.z vscale
    // 30 << vscale
    // [176] screensize::$3 = $1e << screensize::vscale#0 -- vbuz1=vbuc1_rol_vbuz1 
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
    // [177] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbuz1 
    sta y
    // screensize::@return
    // }
    // [178] return 
    rts
}
  // screenlayer1
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer1: {
    .label __0 = $ae
    .label __1 = $af
    .label __2 = $5f
    .label __3 = $ac
    .label __4 = $ac
    .label __5 = $ab
    .label __6 = $ab
    .label __7 = $b0
    .label __8 = $b0
    .label __9 = $b0
    .label __10 = $b1
    .label __11 = $b1
    .label __12 = $7d
    .label __13 = $b2
    .label __14 = $7d
    .label __15 = $b3
    .label __16 = $ac
    .label __17 = $ab
    .label __18 = $b1
    // __conio.layer = 1
    // [179] *((char *)&__conio) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta __conio
    // (*VERA_L1_MAPBASE)>>7
    // [180] screenlayer1::$0 = *VERA_L1_MAPBASE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_L1_MAPBASE
    rol
    rol
    and #1
    sta.z __0
    // __conio.mapbase_bank = (*VERA_L1_MAPBASE)>>7
    // [181] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) = screenlayer1::$0 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    // (*VERA_L1_MAPBASE)<<1
    // [182] screenlayer1::$1 = *VERA_L1_MAPBASE << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda VERA_L1_MAPBASE
    asl
    sta.z __1
    // MAKEWORD((*VERA_L1_MAPBASE)<<1,0)
    // [183] screenlayer1::$2 = screenlayer1::$1 w= 0 -- vwuz1=vbuz2_word_vbuc1 
    lda #0
    ldy.z __1
    sty.z __2+1
    sta.z __2
    // __conio.mapbase_offset = MAKEWORD((*VERA_L1_MAPBASE)<<1,0)
    // [184] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) = screenlayer1::$2 -- _deref_pwuc1=vwuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    tya
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    // *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK
    // [185] screenlayer1::$3 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta.z __3
    // (*VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4
    // [186] screenlayer1::$4 = screenlayer1::$3 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z __4
    lsr
    lsr
    lsr
    lsr
    sta.z __4
    // __conio.mapwidth = VERA_LAYER_WIDTH[ (*VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4]
    // [187] screenlayer1::$16 = screenlayer1::$4 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __16
    // [188] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) = VERA_LAYER_WIDTH[screenlayer1::$16] -- _deref_pwuc1=pwuc2_derefidx_vbuz1 
    ldy.z __16
    lda VERA_LAYER_WIDTH,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    lda VERA_LAYER_WIDTH+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    // *VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK
    // [189] screenlayer1::$5 = *VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK
    and VERA_L1_CONFIG
    sta.z __5
    // (*VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6
    // [190] screenlayer1::$6 = screenlayer1::$5 >> 6 -- vbuz1=vbuz1_ror_6 
    lda.z __6
    rol
    rol
    rol
    and #3
    sta.z __6
    // __conio.mapheight = VERA_LAYER_HEIGHT[ (*VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [191] screenlayer1::$17 = screenlayer1::$6 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __17
    // [192] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT) = VERA_LAYER_HEIGHT[screenlayer1::$17] -- _deref_pwuc1=pwuc2_derefidx_vbuz1 
    ldy.z __17
    lda VERA_LAYER_HEIGHT,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT
    lda VERA_LAYER_HEIGHT+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT+1
    // (*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK
    // [193] screenlayer1::$7 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta.z __7
    // ((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4
    // [194] screenlayer1::$8 = screenlayer1::$7 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z __8
    lsr
    lsr
    lsr
    lsr
    sta.z __8
    // (((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4)+6
    // [195] screenlayer1::$9 = screenlayer1::$8 + 6 -- vbuz1=vbuz1_plus_vbuc1 
    lda #6
    clc
    adc.z __9
    sta.z __9
    // __conio.rowshift = (((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4)+6
    // [196] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) = screenlayer1::$9 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    // (*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK
    // [197] screenlayer1::$10 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta.z __10
    // ((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4
    // [198] screenlayer1::$11 = screenlayer1::$10 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z __11
    lsr
    lsr
    lsr
    lsr
    sta.z __11
    // __conio.rowskip = VERA_LAYER_SKIP[((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4]
    // [199] screenlayer1::$18 = screenlayer1::$11 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __18
    // [200] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) = VERA_LAYER_SKIP[screenlayer1::$18] -- _deref_pwuc1=pwuc2_derefidx_vbuz1 
    ldy.z __18
    lda VERA_LAYER_SKIP,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    lda VERA_LAYER_SKIP+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    // cbm_k_plot_get()
    // [201] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [202] cbm_k_plot_get::return#4 = cbm_k_plot_get::return#0
    // screenlayer1::@1
    // [203] screenlayer1::$12 = cbm_k_plot_get::return#4
    // BYTE1(cbm_k_plot_get())
    // [204] screenlayer1::$13 = byte1  screenlayer1::$12 -- vbuz1=_byte1_vwuz2 
    lda.z __12+1
    sta.z __13
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [205] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = screenlayer1::$13 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // cbm_k_plot_get()
    // [206] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [207] cbm_k_plot_get::return#10 = cbm_k_plot_get::return#0
    // screenlayer1::@2
    // [208] screenlayer1::$14 = cbm_k_plot_get::return#10
    // BYTE0(cbm_k_plot_get())
    // [209] screenlayer1::$15 = byte0  screenlayer1::$14 -- vbuz1=_byte0_vwuz2 
    lda.z __14
    sta.z __15
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [210] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = screenlayer1::$15 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // screenlayer1::@return
    // }
    // [211] return 
    rts
}
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char textcolor(__zp($61) char color)
textcolor: {
    .label __0 = $ac
    .label __1 = $61
    .label color = $61
    // __conio.color & 0xF0
    // [213] textcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) & $f0 -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z __0
    // __conio.color & 0xF0 | color
    // [214] textcolor::$1 = textcolor::$0 | textcolor::color#6 -- vbuz1=vbuz2_bor_vbuz1 
    lda.z __1
    ora.z __0
    sta.z __1
    // __conio.color = __conio.color & 0xF0 | color
    // [215] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) = textcolor::$1 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    // textcolor::@return
    // }
    // [216] return 
    rts
}
  // bgcolor
// Set the back color for text output. The old back text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor(__zp($61) char color)
bgcolor: {
    .label __0 = $ab
    .label __1 = $61
    .label __2 = $ab
    .label color = $61
    // __conio.color & 0x0F
    // [218] bgcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) & $f -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #$f
    and __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z __0
    // color << 4
    // [219] bgcolor::$1 = bgcolor::color#4 << 4 -- vbuz1=vbuz1_rol_4 
    lda.z __1
    asl
    asl
    asl
    asl
    sta.z __1
    // __conio.color & 0x0F | color << 4
    // [220] bgcolor::$2 = bgcolor::$0 | bgcolor::$1 -- vbuz1=vbuz1_bor_vbuz2 
    lda.z __2
    ora.z __1
    sta.z __2
    // __conio.color = __conio.color & 0x0F | color << 4
    // [221] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) = bgcolor::$2 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    // bgcolor::@return
    // }
    // [222] return 
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
    // [223] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR
    // cursor::@return
    // }
    // [224] return 
    rts
}
  // cbm_k_plot_get
/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
cbm_k_plot_get: {
    .label x = $ad
    .label y = $7f
    .label return = $7d
    // unsigned char x
    // [225] cbm_k_plot_get::x = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z x
    // unsigned char y
    // [226] cbm_k_plot_get::y = 0 -- vbuz1=vbuc1 
    sta.z y
    // kickasm
    // kickasm( uses cbm_k_plot_get::x uses cbm_k_plot_get::y uses CBM_PLOT) {{ sec         jsr CBM_PLOT         stx y         sty x      }}
    sec
        jsr CBM_PLOT
        stx y
        sty x
    
    // MAKEWORD(x,y)
    // [228] cbm_k_plot_get::return#0 = cbm_k_plot_get::x w= cbm_k_plot_get::y -- vwuz1=vbuz2_word_vbuz3 
    lda.z x
    sta.z return+1
    lda.z y
    sta.z return
    // cbm_k_plot_get::@return
    // }
    // [229] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__zp($61) char x, __zp($68) char y)
gotoxy: {
    .label __5 = $5f
    .label line_offset = $5f
    .label x = $61
    .label y = $68
    // if(y>__conio.height)
    // [231] if(gotoxy::y#8<=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto gotoxy::@3 -- vbuz1_le__deref_pbuc1_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    cmp.z y
    bcs __b1
    // [233] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [233] phi gotoxy::y#10 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z y
    // [232] phi from gotoxy to gotoxy::@3 [phi:gotoxy->gotoxy::@3]
    // gotoxy::@3
    // [233] phi from gotoxy::@3 to gotoxy::@1 [phi:gotoxy::@3->gotoxy::@1]
    // [233] phi gotoxy::y#10 = gotoxy::y#8 [phi:gotoxy::@3->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=__conio.width)
    // [234] if(gotoxy::x#10<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto gotoxy::@4 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z x
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    bcc __b2
    // [236] phi from gotoxy::@1 to gotoxy::@2 [phi:gotoxy::@1->gotoxy::@2]
    // [236] phi gotoxy::x#9 = 0 [phi:gotoxy::@1->gotoxy::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z x
    // [235] phi from gotoxy::@1 to gotoxy::@4 [phi:gotoxy::@1->gotoxy::@4]
    // gotoxy::@4
    // [236] phi from gotoxy::@4 to gotoxy::@2 [phi:gotoxy::@4->gotoxy::@2]
    // [236] phi gotoxy::x#9 = gotoxy::x#10 [phi:gotoxy::@4->gotoxy::@2#0] -- register_copy 
    // gotoxy::@2
  __b2:
    // __conio.cursor_x = x
    // [237] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = gotoxy::x#9 -- _deref_pbuc1=vbuz1 
    lda.z x
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // __conio.cursor_y = y
    // [238] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = gotoxy::y#10 -- _deref_pbuc1=vbuz1 
    lda.z y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // unsigned int line_offset = (unsigned int)y << __conio.rowshift
    // [239] gotoxy::$5 = (unsigned int)gotoxy::y#10 -- vwuz1=_word_vbuz2 
    lda.z y
    sta.z __5
    lda #0
    sta.z __5+1
    // [240] gotoxy::line_offset#0 = gotoxy::$5 << *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) -- vwuz1=vwuz1_rol__deref_pbuc1 
    ldy __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    beq !e+
  !:
    asl.z line_offset
    rol.z line_offset+1
    dey
    bne !-
  !e:
    // __conio.line = line_offset
    // [241] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) = gotoxy::line_offset#0 -- _deref_pwuc1=vwuz1 
    lda.z line_offset
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    lda.z line_offset+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    // gotoxy::@return
    // }
    // [242] return 
    rts
}
  // cputln
// Print a newline
cputln: {
    .label temp = $4c
    // unsigned int temp = __conio.line
    // [243] cputln::temp#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) -- vwuz1=_deref_pwuc1 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta.z temp
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    sta.z temp+1
    // temp += __conio.rowskip
    // [244] cputln::temp#1 = cputln::temp#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z temp
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta.z temp
    lda.z temp+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta.z temp+1
    // __conio.line = temp
    // [245] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) = cputln::temp#1 -- _deref_pwuc1=vwuz1 
    lda.z temp
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    lda.z temp+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    // __conio.cursor_x = 0
    // [246] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // __conio.cursor_y++;
    // [247] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = ++ *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // cscroll()
    // [248] call cscroll
    jsr cscroll
    // cputln::@return
    // }
    // [249] return 
    rts
}
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
    .label __0 = $6c
    // *VERA_L0_CONFIG | VERA_LAYER_CONFIG_MODE_BITMAP
    // [250] vera_layer0_mode_bitmap::$0 = *VERA_L0_CONFIG | VERA_LAYER_CONFIG_MODE_BITMAP -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_CONFIG_MODE_BITMAP
    ora VERA_L0_CONFIG
    sta.z __0
    // *VERA_L0_CONFIG = *VERA_L0_CONFIG | VERA_LAYER_CONFIG_MODE_BITMAP
    // [251] *VERA_L0_CONFIG = vera_layer0_mode_bitmap::$0 -- _deref_pbuc1=vbuz1 
    sta VERA_L0_CONFIG
    // vera_layer0_mode_bitmap::vera_layer0_set_tile_width1
    // *VERA_L0_TILEBASE &= ~VERA_TILEBASE_WIDTH_MASK
    // [252] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE & ~VERA_TILEBASE_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_WIDTH_MASK^$ff
    and VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // *VERA_L0_TILEBASE |= tilewidth
    // [253] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L0_TILEBASE
    // vera_layer0_mode_bitmap::vera_layer0_set_tilebase1
    // *VERA_L0_TILEBASE &= ~VERA_LAYER_TILEBASE_MASK
    // [254] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE & ~VERA_LAYER_TILEBASE_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_TILEBASE_MASK^$ff
    and VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // *VERA_L0_TILEBASE |= ((tilebase_bank << 7) | BYTE1(tilebase_offset)>>1)
    // [255] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L0_TILEBASE
    // vera_layer0_mode_bitmap::vera_layer0_set_color_depth1
    // *VERA_L0_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK
    // [256] *VERA_L0_CONFIG = *VERA_L0_CONFIG & ~VERA_LAYER_COLOR_DEPTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_MASK^$ff
    and VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // *VERA_L0_CONFIG |= bpp
    // [257] *VERA_L0_CONFIG = *VERA_L0_CONFIG | VERA_LAYER_COLOR_DEPTH_2BPP -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_2BPP
    ora VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // vera_layer0_mode_bitmap::vera_display_set_scale_double1
    // *VERA_DC_HSCALE = 64
    // [258] *VERA_DC_HSCALE = $40 -- _deref_pbuc1=vbuc2 
    lda #$40
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 64
    // [259] *VERA_DC_VSCALE = $40 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // vera_layer0_mode_bitmap::@return
    // }
    // [260] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __1 = $77
    .label __2 = $76
    .label __3 = $73
    .label line_text = $50
    .label color = $79
    .label mapheight = $64
    .label mapwidth = $71
    .label c = $33
    .label l = $5e
    // unsigned int line_text = __conio.mapbase_offset
    // [261] clrscr::line_text#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z line_text
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z line_text+1
    // char color = __conio.color
    // [262] clrscr::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z color
    // unsigned int mapheight = __conio.mapheight
    // [263] clrscr::mapheight#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT
    sta.z mapheight
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT+1
    sta.z mapheight+1
    // unsigned int mapwidth = __conio.mapwidth
    // [264] clrscr::mapwidth#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    sta.z mapwidth
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    sta.z mapwidth+1
    // [265] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [265] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr->clrscr::@1#0] -- register_copy 
    // [265] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<mapheight; l++ )
    // [266] if(clrscr::l#2<clrscr::mapheight#0) goto clrscr::@2 -- vbuz1_lt_vwuz2_then_la1 
    lda.z mapheight+1
    bne __b2
    lda.z l
    cmp.z mapheight
    bcc __b2
    // clrscr::@3
    // __conio.cursor_x = 0
    // [267] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // __conio.cursor_y = 0
    // [268] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = 0 -- _deref_pbuc1=vbuc2 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // __conio.line = 0
    // [269] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) = 0 -- _deref_pwuc1=vbuc2 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    // clrscr::@return
    // }
    // [270] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [271] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(ch)
    // [272] clrscr::$1 = byte0  clrscr::line_text#2 -- vbuz1=_byte0_vwuz2 
    lda.z line_text
    sta.z __1
    // *VERA_ADDRX_L = BYTE0(ch)
    // [273] *VERA_ADDRX_L = clrscr::$1 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(ch)
    // [274] clrscr::$2 = byte1  clrscr::line_text#2 -- vbuz1=_byte1_vwuz2 
    lda.z line_text+1
    sta.z __2
    // *VERA_ADDRX_M = BYTE1(ch)
    // [275] *VERA_ADDRX_M = clrscr::$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [276] clrscr::$3 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    sta.z __3
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [277] *VERA_ADDRX_H = clrscr::$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [278] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [278] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@4
  __b4:
    // for( char c=0;c<mapwidth; c++ )
    // [279] if(clrscr::c#2<clrscr::mapwidth#0) goto clrscr::@5 -- vbuz1_lt_vwuz2_then_la1 
    lda.z mapwidth+1
    bne __b5
    lda.z c
    cmp.z mapwidth
    bcc __b5
    // clrscr::@6
    // line_text += __conio.rowskip
    // [280] clrscr::line_text#1 = clrscr::line_text#2 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z line_text
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta.z line_text
    lda.z line_text+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta.z line_text+1
    // for( char l=0;l<mapheight; l++ )
    // [281] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [265] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [265] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [265] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [282] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [283] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<mapwidth; c++ )
    // [284] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [278] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [278] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
}
  // printf_str
/// Print a NUL-terminated string
// void printf_str(void (*putc)(char), __zp($50) const char *s)
printf_str: {
    .label c = $2e
    .label s = $50
    // [286] phi from printf_str printf_str::@2 to printf_str::@1 [phi:printf_str/printf_str::@2->printf_str::@1]
    // [286] phi printf_str::s#8 = printf_str::s#9 [phi:printf_str/printf_str::@2->printf_str::@1#0] -- register_copy 
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [287] printf_str::c#1 = *printf_str::s#8 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta.z c
    // [288] printf_str::s#0 = ++ printf_str::s#8 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [289] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbuz1_then_la1 
    lda.z c
    bne __b2
    // printf_str::@return
    // }
    // [290] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [291] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbuz1 
    lda.z c
    pha
    // [292] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
}
  // bitmap_init
// Initialize the bitmap plotter tables for a specific bitmap
// void bitmap_init(char layer, char bank, unsigned int offset)
bitmap_init: {
    .const layer = 0
    .label __1 = $69
    .label __2 = $6c
    .label __3 = $79
    .label __4 = $79
    .label __5 = $2e
    .label __10 = $48
    .label __13 = $5c
    .label __16 = $2f
    .label __25 = $79
    .label __26 = $6d
    .label __27 = $52
    .label __28 = $4e
    .label __29 = $56
    .label __30 = $58
    .label bitmask = $33
    .label bitshift = $5e
    .label hdelta = $54
    .label yoffs = $37
    .label x = $50
    .label y = $31
    .label __32 = $6d
    .label __33 = $66
    .label __34 = $6f
    .label __35 = $52
    .label __36 = $46
    .label __37 = $34
    .label __38 = $4e
    .label __39 = $6a
    .label __40 = $62
    .label __41 = $56
    .label __42 = $26
    .label __43 = $22
    .label __44 = $58
    // __bitmap.address = MAKELONG(offset, bank)
    // [294] *((unsigned long *)&__bitmap+$1180) = 0 -- _deref_pduc1=vbuc2 
    lda #0
    sta __bitmap+$1180
    sta __bitmap+$1180+1
    sta __bitmap+$1180+2
    sta __bitmap+$1180+3
    // __bitmap.layer = layer
    // [295] *((char *)&__bitmap+$1184) = bitmap_init::layer#0 -- _deref_pbuc1=vbuc2 
    lda #layer
    sta __bitmap+$1184
    // bitmap_init::@2
    // *VERA_L0_CONFIG & VERA_LAYER_COLOR_DEPTH_MASK
    // [296] bitmap_init::$5 = *VERA_L0_CONFIG & VERA_LAYER_COLOR_DEPTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_MASK
    and VERA_L0_CONFIG
    sta.z __5
    // __bitmap.color_depth = (*VERA_L0_CONFIG & VERA_LAYER_COLOR_DEPTH_MASK)
    // [297] *((char *)&__bitmap+$1187) = bitmap_init::$5 -- _deref_pbuc1=vbuz1 
    sta __bitmap+$1187
    // [298] phi from bitmap_init::@2 to bitmap_init::@1 [phi:bitmap_init::@2->bitmap_init::@1]
    // bitmap_init::@1
    // bitmap_hscale()
    // [299] call bitmap_hscale
    // [497] phi from bitmap_init::@1 to bitmap_hscale [phi:bitmap_init::@1->bitmap_hscale]
    jsr bitmap_hscale
    // bitmap_hscale()
    // [300] bitmap_hscale::return#0 = bitmap_hscale::return#1
    // bitmap_init::@20
    // [301] bitmap_init::$1 = bitmap_hscale::return#0
    // __bitmap.hscale = bitmap_hscale()
    // [302] *((char *)&__bitmap+$1185) = bitmap_init::$1 -- _deref_pbuc1=vbuz1 
    lda.z __1
    sta __bitmap+$1185
    // bitmap_vscale()
    // [303] call bitmap_vscale
    // [504] phi from bitmap_init::@20 to bitmap_vscale [phi:bitmap_init::@20->bitmap_vscale]
    jsr bitmap_vscale
    // bitmap_vscale()
    // [304] bitmap_vscale::return#0 = bitmap_vscale::return#1
    // bitmap_init::@21
    // [305] bitmap_init::$2 = bitmap_vscale::return#0
    // __bitmap.vscale = bitmap_vscale()
    // [306] *((char *)&__bitmap+$1186) = bitmap_init::$2 -- _deref_pbuc1=vbuz1 
    // Returns 1 when 640 and 2 when 320, 3 when 160.
    lda.z __2
    sta __bitmap+$1186
    // unsigned char bitmask = bitmasks[__bitmap.color_depth]
    // [307] bitmap_init::bitmask#0 = bitmasks[*((char *)&__bitmap+$1187)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    // Returns 1 when 480 and 2 when 240, 3 when 160.
    ldy __bitmap+$1187
    lda bitmasks,y
    sta.z bitmask
    // signed char bitshift = bitshifts[__bitmap.color_depth]
    // [308] bitmap_init::bitshift#0 = bitshifts[*((char *)&__bitmap+$1187)] -- vbsz1=pbsc1_derefidx_(_deref_pbuc2) 
    lda bitshifts,y
    sta.z bitshift
    // [309] phi from bitmap_init::@21 to bitmap_init::@3 [phi:bitmap_init::@21->bitmap_init::@3]
    // [309] phi bitmap_init::bitshift#10 = bitmap_init::bitshift#0 [phi:bitmap_init::@21->bitmap_init::@3#0] -- register_copy 
    // [309] phi bitmap_init::bitmask#10 = bitmap_init::bitmask#0 [phi:bitmap_init::@21->bitmap_init::@3#1] -- register_copy 
    // [309] phi bitmap_init::x#10 = 0 [phi:bitmap_init::@21->bitmap_init::@3#2] -- vwuz1=vwuc1 
    lda #<0
    sta.z x
    sta.z x+1
    // bitmap_init::@3
  __b3:
    // for(unsigned int x=0; x<630; x++)
    // [310] if(bitmap_init::x#10<$276) goto bitmap_init::@4 -- vwuz1_lt_vwuc1_then_la1 
    lda.z x+1
    cmp #>$276
    bcs !__b4+
    jmp __b4
  !__b4:
    bne !+
    lda.z x
    cmp #<$276
    bcs !__b4+
    jmp __b4
  !__b4:
  !:
    // bitmap_init::@5
    // __bitmap.color_depth<<2
    // [311] bitmap_init::$3 = *((char *)&__bitmap+$1187) << 2 -- vbuz1=_deref_pbuc1_rol_2 
    lda __bitmap+$1187
    asl
    asl
    sta.z __3
    // (__bitmap.color_depth<<2)+__bitmap.hscale
    // [312] bitmap_init::$4 = bitmap_init::$3 + *((char *)&__bitmap+$1185) -- vbuz1=vbuz1_plus__deref_pbuc1 
    lda __bitmap+$1185
    clc
    adc.z __4
    sta.z __4
    // unsigned int hdelta = hdeltas[(__bitmap.color_depth<<2)+__bitmap.hscale]
    // [313] bitmap_init::$25 = bitmap_init::$4 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __25
    // [314] bitmap_init::hdelta#0 = hdeltas[bitmap_init::$25] -- vwuz1=pwuc1_derefidx_vbuz2 
    // This sets the right delta to skip a whole line based on the scale, depending on the color depth.
    ldy.z __25
    lda hdeltas,y
    sta.z hdelta
    lda hdeltas+1,y
    sta.z hdelta+1
    // unsigned long yoffs = __bitmap.address
    // [315] bitmap_init::yoffs#0 = *((unsigned long *)&__bitmap+$1180) -- vduz1=_deref_pduc1 
    // We start at the bitmap offset; The plot_y contains the bitmap offset embedded so we know where a line starts.
    lda __bitmap+$1180
    sta.z yoffs
    lda __bitmap+$1180+1
    sta.z yoffs+1
    lda __bitmap+$1180+2
    sta.z yoffs+2
    lda __bitmap+$1180+3
    sta.z yoffs+3
    // [316] phi from bitmap_init::@5 to bitmap_init::@18 [phi:bitmap_init::@5->bitmap_init::@18]
    // [316] phi bitmap_init::yoffs#2 = bitmap_init::yoffs#0 [phi:bitmap_init::@5->bitmap_init::@18#0] -- register_copy 
    // [316] phi bitmap_init::y#2 = 0 [phi:bitmap_init::@5->bitmap_init::@18#1] -- vwuz1=vwuc1 
    lda #<0
    sta.z y
    sta.z y+1
    // bitmap_init::@18
  __b18:
    // for(unsigned int y=0; y<479; y++)
    // [317] if(bitmap_init::y#2<$1df) goto bitmap_init::@19 -- vwuz1_lt_vwuc1_then_la1 
    lda.z y+1
    cmp #>$1df
    bcc __b19
    bne !+
    lda.z y
    cmp #<$1df
    bcc __b19
  !:
    // bitmap_init::@return
    // }
    // [318] return 
    rts
    // bitmap_init::@19
  __b19:
    // __bitmap.plot_y[y] = yoffs
    // [319] bitmap_init::$30 = bitmap_init::y#2 << 2 -- vwuz1=vwuz2_rol_2 
    lda.z y
    asl
    sta.z __30
    lda.z y+1
    rol
    sta.z __30+1
    asl.z __30
    rol.z __30+1
    // [320] bitmap_init::$44 = (unsigned long *)&__bitmap+$500 + bitmap_init::$30 -- pduz1=pduc1_plus_vwuz1 
    lda.z __44
    clc
    adc #<__bitmap+$500
    sta.z __44
    lda.z __44+1
    adc #>__bitmap+$500
    sta.z __44+1
    // [321] *bitmap_init::$44 = bitmap_init::yoffs#2 -- _deref_pduz1=vduz2 
    ldy #0
    lda.z yoffs
    sta (__44),y
    iny
    lda.z yoffs+1
    sta (__44),y
    iny
    lda.z yoffs+2
    sta (__44),y
    iny
    lda.z yoffs+3
    sta (__44),y
    // yoffs = yoffs + hdelta
    // [322] bitmap_init::yoffs#1 = bitmap_init::yoffs#2 + bitmap_init::hdelta#0 -- vduz1=vduz1_plus_vwuz2 
    lda.z yoffs
    clc
    adc.z hdelta
    sta.z yoffs
    lda.z yoffs+1
    adc.z hdelta+1
    sta.z yoffs+1
    lda.z yoffs+2
    adc #0
    sta.z yoffs+2
    lda.z yoffs+3
    adc #0
    sta.z yoffs+3
    // for(unsigned int y=0; y<479; y++)
    // [323] bitmap_init::y#1 = ++ bitmap_init::y#2 -- vwuz1=_inc_vwuz1 
    inc.z y
    bne !+
    inc.z y+1
  !:
    // [316] phi from bitmap_init::@19 to bitmap_init::@18 [phi:bitmap_init::@19->bitmap_init::@18]
    // [316] phi bitmap_init::yoffs#2 = bitmap_init::yoffs#1 [phi:bitmap_init::@19->bitmap_init::@18#0] -- register_copy 
    // [316] phi bitmap_init::y#2 = bitmap_init::y#1 [phi:bitmap_init::@19->bitmap_init::@18#1] -- register_copy 
    jmp __b18
    // bitmap_init::@4
  __b4:
    // if(__bitmap.color_depth==0)
    // [324] if(*((char *)&__bitmap+$1187)!=0) goto bitmap_init::@6 -- _deref_pbuc1_neq_0_then_la1 
    lda __bitmap+$1187
    bne __b6
    // bitmap_init::@12
    // x >> 3
    // [325] bitmap_init::$10 = bitmap_init::x#10 >> 3 -- vwuz1=vwuz2_ror_3 
    lda.z x+1
    lsr
    sta.z __10+1
    lda.z x
    ror
    sta.z __10
    lsr.z __10+1
    ror.z __10
    lsr.z __10+1
    ror.z __10
    // __bitmap.plot_x[x] = (x >> 3)
    // [326] bitmap_init::$26 = bitmap_init::x#10 << 1 -- vwuz1=vwuz2_rol_1 
    lda.z x
    asl
    sta.z __26
    lda.z x+1
    rol
    sta.z __26+1
    // [327] bitmap_init::$32 = (unsigned int *)&__bitmap + bitmap_init::$26 -- pwuz1=pwuc1_plus_vwuz1 
    lda.z __32
    clc
    adc #<__bitmap
    sta.z __32
    lda.z __32+1
    adc #>__bitmap
    sta.z __32+1
    // [328] *bitmap_init::$32 = bitmap_init::$10 -- _deref_pwuz1=vwuz2 
    ldy #0
    lda.z __10
    sta (__32),y
    iny
    lda.z __10+1
    sta (__32),y
    // __bitmap.plot_bitmask[x] = bitmask
    // [329] bitmap_init::$33 = (char *)&__bitmap+$c80 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap+$c80
    sta.z __33
    lda.z x+1
    adc #>__bitmap+$c80
    sta.z __33+1
    // [330] *bitmap_init::$33 = bitmap_init::bitmask#10 -- _deref_pbuz1=vbuz2 
    lda.z bitmask
    ldy #0
    sta (__33),y
    // __bitmap.plot_bitshift[x] = (unsigned char)bitshift
    // [331] bitmap_init::$34 = (char *)&__bitmap+$f00 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap+$f00
    sta.z __34
    lda.z x+1
    adc #>__bitmap+$f00
    sta.z __34+1
    // [332] *bitmap_init::$34 = (char)bitmap_init::bitshift#10 -- _deref_pbuz1=vbuz2 
    lda.z bitshift
    sta (__34),y
    // bitshift -= 1
    // [333] bitmap_init::bitshift#1 = bitmap_init::bitshift#10 - 1 -- vbsz1=vbsz1_minus_1 
    dec.z bitshift
    // bitmask >>= 1
    // [334] bitmap_init::bitmask#1 = bitmap_init::bitmask#10 >> 1 -- vbuz1=vbuz1_ror_1 
    lsr.z bitmask
    // [335] phi from bitmap_init::@12 bitmap_init::@4 to bitmap_init::@6 [phi:bitmap_init::@12/bitmap_init::@4->bitmap_init::@6]
    // [335] phi bitmap_init::bitshift#11 = bitmap_init::bitshift#1 [phi:bitmap_init::@12/bitmap_init::@4->bitmap_init::@6#0] -- register_copy 
    // [335] phi bitmap_init::bitmask#11 = bitmap_init::bitmask#1 [phi:bitmap_init::@12/bitmap_init::@4->bitmap_init::@6#1] -- register_copy 
    // bitmap_init::@6
  __b6:
    // if(__bitmap.color_depth==1)
    // [336] if(*((char *)&__bitmap+$1187)!=1) goto bitmap_init::@7 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #1
    cmp __bitmap+$1187
    bne __b7
    // bitmap_init::@13
    // x >> 2
    // [337] bitmap_init::$13 = bitmap_init::x#10 >> 2 -- vwuz1=vwuz2_ror_2 
    lda.z x+1
    lsr
    sta.z __13+1
    lda.z x
    ror
    sta.z __13
    lsr.z __13+1
    ror.z __13
    // __bitmap.plot_x[x] = (x >> 2)
    // [338] bitmap_init::$27 = bitmap_init::x#10 << 1 -- vwuz1=vwuz2_rol_1 
    lda.z x
    asl
    sta.z __27
    lda.z x+1
    rol
    sta.z __27+1
    // [339] bitmap_init::$35 = (unsigned int *)&__bitmap + bitmap_init::$27 -- pwuz1=pwuc1_plus_vwuz1 
    lda.z __35
    clc
    adc #<__bitmap
    sta.z __35
    lda.z __35+1
    adc #>__bitmap
    sta.z __35+1
    // [340] *bitmap_init::$35 = bitmap_init::$13 -- _deref_pwuz1=vwuz2 
    ldy #0
    lda.z __13
    sta (__35),y
    iny
    lda.z __13+1
    sta (__35),y
    // __bitmap.plot_bitmask[x] = bitmask
    // [341] bitmap_init::$36 = (char *)&__bitmap+$c80 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap+$c80
    sta.z __36
    lda.z x+1
    adc #>__bitmap+$c80
    sta.z __36+1
    // [342] *bitmap_init::$36 = bitmap_init::bitmask#11 -- _deref_pbuz1=vbuz2 
    lda.z bitmask
    ldy #0
    sta (__36),y
    // __bitmap.plot_bitshift[x] = (unsigned char)bitshift
    // [343] bitmap_init::$37 = (char *)&__bitmap+$f00 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap+$f00
    sta.z __37
    lda.z x+1
    adc #>__bitmap+$f00
    sta.z __37+1
    // [344] *bitmap_init::$37 = (char)bitmap_init::bitshift#11 -- _deref_pbuz1=vbuz2 
    lda.z bitshift
    sta (__37),y
    // bitshift -= 2
    // [345] bitmap_init::bitshift#2 = bitmap_init::bitshift#11 - 2 -- vbsz1=vbsz1_minus_2 
    dec.z bitshift
    dec.z bitshift
    // bitmask >>= 2
    // [346] bitmap_init::bitmask#2 = bitmap_init::bitmask#11 >> 2 -- vbuz1=vbuz1_ror_2 
    lda.z bitmask
    lsr
    lsr
    sta.z bitmask
    // [347] phi from bitmap_init::@13 bitmap_init::@6 to bitmap_init::@7 [phi:bitmap_init::@13/bitmap_init::@6->bitmap_init::@7]
    // [347] phi bitmap_init::bitshift#12 = bitmap_init::bitshift#2 [phi:bitmap_init::@13/bitmap_init::@6->bitmap_init::@7#0] -- register_copy 
    // [347] phi bitmap_init::bitmask#12 = bitmap_init::bitmask#2 [phi:bitmap_init::@13/bitmap_init::@6->bitmap_init::@7#1] -- register_copy 
    // bitmap_init::@7
  __b7:
    // if(__bitmap.color_depth==2)
    // [348] if(*((char *)&__bitmap+$1187)!=2) goto bitmap_init::@8 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #2
    cmp __bitmap+$1187
    bne __b8
    // bitmap_init::@14
    // x >> 1
    // [349] bitmap_init::$16 = bitmap_init::x#10 >> 1 -- vwuz1=vwuz2_ror_1 
    lda.z x+1
    lsr
    sta.z __16+1
    lda.z x
    ror
    sta.z __16
    // __bitmap.plot_x[x] = (x >> 1)
    // [350] bitmap_init::$28 = bitmap_init::x#10 << 1 -- vwuz1=vwuz2_rol_1 
    lda.z x
    asl
    sta.z __28
    lda.z x+1
    rol
    sta.z __28+1
    // [351] bitmap_init::$38 = (unsigned int *)&__bitmap + bitmap_init::$28 -- pwuz1=pwuc1_plus_vwuz1 
    lda.z __38
    clc
    adc #<__bitmap
    sta.z __38
    lda.z __38+1
    adc #>__bitmap
    sta.z __38+1
    // [352] *bitmap_init::$38 = bitmap_init::$16 -- _deref_pwuz1=vwuz2 
    ldy #0
    lda.z __16
    sta (__38),y
    iny
    lda.z __16+1
    sta (__38),y
    // __bitmap.plot_bitmask[x] = bitmask
    // [353] bitmap_init::$39 = (char *)&__bitmap+$c80 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap+$c80
    sta.z __39
    lda.z x+1
    adc #>__bitmap+$c80
    sta.z __39+1
    // [354] *bitmap_init::$39 = bitmap_init::bitmask#12 -- _deref_pbuz1=vbuz2 
    lda.z bitmask
    ldy #0
    sta (__39),y
    // __bitmap.plot_bitshift[x] = (unsigned char)bitshift
    // [355] bitmap_init::$40 = (char *)&__bitmap+$f00 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap+$f00
    sta.z __40
    lda.z x+1
    adc #>__bitmap+$f00
    sta.z __40+1
    // [356] *bitmap_init::$40 = (char)bitmap_init::bitshift#12 -- _deref_pbuz1=vbuz2 
    lda.z bitshift
    sta (__40),y
    // bitshift -= 4
    // [357] bitmap_init::bitshift#3 = bitmap_init::bitshift#12 - 4 -- vbsz1=vbsz1_minus_vbsc1 
    sec
    sbc #4
    sta.z bitshift
    // bitmask >>= 4
    // [358] bitmap_init::bitmask#3 = bitmap_init::bitmask#12 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z bitmask
    lsr
    lsr
    lsr
    lsr
    sta.z bitmask
    // [359] phi from bitmap_init::@14 bitmap_init::@7 to bitmap_init::@8 [phi:bitmap_init::@14/bitmap_init::@7->bitmap_init::@8]
    // [359] phi bitmap_init::bitmask#13 = bitmap_init::bitmask#3 [phi:bitmap_init::@14/bitmap_init::@7->bitmap_init::@8#0] -- register_copy 
    // [359] phi bitmap_init::bitshift#13 = bitmap_init::bitshift#3 [phi:bitmap_init::@14/bitmap_init::@7->bitmap_init::@8#1] -- register_copy 
    // bitmap_init::@8
  __b8:
    // if(__bitmap.color_depth==3)
    // [360] if(*((char *)&__bitmap+$1187)!=3) goto bitmap_init::@9 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #3
    cmp __bitmap+$1187
    bne __b9
    // bitmap_init::@15
    // __bitmap.plot_x[x] = x
    // [361] bitmap_init::$29 = bitmap_init::x#10 << 1 -- vwuz1=vwuz2_rol_1 
    lda.z x
    asl
    sta.z __29
    lda.z x+1
    rol
    sta.z __29+1
    // [362] bitmap_init::$41 = (unsigned int *)&__bitmap + bitmap_init::$29 -- pwuz1=pwuc1_plus_vwuz1 
    lda.z __41
    clc
    adc #<__bitmap
    sta.z __41
    lda.z __41+1
    adc #>__bitmap
    sta.z __41+1
    // [363] *bitmap_init::$41 = bitmap_init::x#10 -- _deref_pwuz1=vwuz2 
    ldy #0
    lda.z x
    sta (__41),y
    iny
    lda.z x+1
    sta (__41),y
    // __bitmap.plot_bitmask[x] = bitmask
    // [364] bitmap_init::$42 = (char *)&__bitmap+$c80 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap+$c80
    sta.z __42
    lda.z x+1
    adc #>__bitmap+$c80
    sta.z __42+1
    // [365] *bitmap_init::$42 = bitmap_init::bitmask#13 -- _deref_pbuz1=vbuz2 
    lda.z bitmask
    ldy #0
    sta (__42),y
    // __bitmap.plot_bitshift[x] = (unsigned char)bitshift
    // [366] bitmap_init::$43 = (char *)&__bitmap+$f00 + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap+$f00
    sta.z __43
    lda.z x+1
    adc #>__bitmap+$f00
    sta.z __43+1
    // [367] *bitmap_init::$43 = (char)bitmap_init::bitshift#13 -- _deref_pbuz1=vbuz2 
    lda.z bitshift
    sta (__43),y
    // bitmap_init::@9
  __b9:
    // if(bitshift<0)
    // [368] if(bitmap_init::bitshift#13>=0) goto bitmap_init::@10 -- vbsz1_ge_0_then_la1 
    lda.z bitshift
    cmp #0
    bpl __b10
    // bitmap_init::@16
    // bitshift = bitshifts[__bitmap.color_depth]
    // [369] bitmap_init::bitshift#4 = bitshifts[*((char *)&__bitmap+$1187)] -- vbsz1=pbsc1_derefidx_(_deref_pbuc2) 
    ldy __bitmap+$1187
    lda bitshifts,y
    sta.z bitshift
    // [370] phi from bitmap_init::@16 bitmap_init::@9 to bitmap_init::@10 [phi:bitmap_init::@16/bitmap_init::@9->bitmap_init::@10]
    // [370] phi bitmap_init::bitshift#15 = bitmap_init::bitshift#4 [phi:bitmap_init::@16/bitmap_init::@9->bitmap_init::@10#0] -- register_copy 
    // bitmap_init::@10
  __b10:
    // if(bitmask==0)
    // [371] if(bitmap_init::bitmask#13!=0) goto bitmap_init::@11 -- vbuz1_neq_0_then_la1 
    lda.z bitmask
    bne __b11
    // bitmap_init::@17
    // bitmask = bitmasks[__bitmap.color_depth]
    // [372] bitmap_init::bitmask#4 = bitmasks[*((char *)&__bitmap+$1187)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy __bitmap+$1187
    lda bitmasks,y
    sta.z bitmask
    // [373] phi from bitmap_init::@10 bitmap_init::@17 to bitmap_init::@11 [phi:bitmap_init::@10/bitmap_init::@17->bitmap_init::@11]
    // [373] phi bitmap_init::bitmask#17 = bitmap_init::bitmask#13 [phi:bitmap_init::@10/bitmap_init::@17->bitmap_init::@11#0] -- register_copy 
    // bitmap_init::@11
  __b11:
    // for(unsigned int x=0; x<630; x++)
    // [374] bitmap_init::x#1 = ++ bitmap_init::x#10 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // [309] phi from bitmap_init::@11 to bitmap_init::@3 [phi:bitmap_init::@11->bitmap_init::@3]
    // [309] phi bitmap_init::bitshift#10 = bitmap_init::bitshift#15 [phi:bitmap_init::@11->bitmap_init::@3#0] -- register_copy 
    // [309] phi bitmap_init::bitmask#10 = bitmap_init::bitmask#17 [phi:bitmap_init::@11->bitmap_init::@3#1] -- register_copy 
    // [309] phi bitmap_init::x#10 = bitmap_init::x#1 [phi:bitmap_init::@11->bitmap_init::@3#2] -- register_copy 
    jmp __b3
}
  // bitmap_clear
// Clear all graphics on the bitmap
bitmap_clear: {
    .label __0 = $76
    .label __1 = $76
    .label __3 = $37
    .label __7 = $79
    .label __8 = $76
    .label vdelta = $4e
    .label hdelta = $24
    .label count = $6a
    .label vbank = $73
    .label vdest = $62
    // unsigned int vdelta = vdeltas[__bitmap.vscale]
    // [375] bitmap_clear::$7 = *((char *)&__bitmap+$1186) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __bitmap+$1186
    asl
    sta.z __7
    // [376] bitmap_clear::vdelta#0 = vdeltas[bitmap_clear::$7] -- vwuz1=pwuc1_derefidx_vbuz2 
    tay
    lda vdeltas,y
    sta.z vdelta
    lda vdeltas+1,y
    sta.z vdelta+1
    // __bitmap.color_depth<<2
    // [377] bitmap_clear::$0 = *((char *)&__bitmap+$1187) << 2 -- vbuz1=_deref_pbuc1_rol_2 
    lda __bitmap+$1187
    asl
    asl
    sta.z __0
    // (__bitmap.color_depth<<2)+__bitmap.hscale
    // [378] bitmap_clear::$1 = bitmap_clear::$0 + *((char *)&__bitmap+$1185) -- vbuz1=vbuz1_plus__deref_pbuc1 
    lda __bitmap+$1185
    clc
    adc.z __1
    sta.z __1
    // unsigned int hdelta = hdeltas[(__bitmap.color_depth<<2)+__bitmap.hscale]
    // [379] bitmap_clear::$8 = bitmap_clear::$1 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __8
    // [380] bitmap_clear::hdelta#0 = hdeltas[bitmap_clear::$8] -- vwuz1=pwuc1_derefidx_vbuz2 
    ldy.z __8
    lda hdeltas,y
    sta.z hdelta
    lda hdeltas+1,y
    sta.z hdelta+1
    // hdelta = hdelta >> 1
    // [381] bitmap_clear::hdelta#1 = bitmap_clear::hdelta#0 >> 1 -- vwuz1=vwuz1_ror_1 
    lsr.z hdelta+1
    ror.z hdelta
    // mul16u(hdelta,vdelta)
    // [382] mul16u::a#0 = bitmap_clear::hdelta#1
    // [383] mul16u::b#0 = bitmap_clear::vdelta#0
    // [384] call mul16u
    jsr mul16u
    // [385] mul16u::return#0 = mul16u::res#2
    // bitmap_clear::@1
    // [386] bitmap_clear::$3 = mul16u::return#0
    // unsigned int count = (unsigned int)mul16u(hdelta,vdelta)
    // [387] bitmap_clear::count#0 = (unsigned int)bitmap_clear::$3 -- vwuz1=_word_vduz2 
    lda.z __3
    sta.z count
    lda.z __3+1
    sta.z count+1
    // vram_bank_t vbank = BYTE3(__bitmap.address)
    // [388] bitmap_clear::vbank#0 = byte3  *((unsigned long *)&__bitmap+$1180) -- vbuz1=_byte3__deref_pduc1 
    lda __bitmap+$1180+3
    sta.z vbank
    // vram_offset_t vdest = WORD0(__bitmap.address)
    // [389] bitmap_clear::vdest#0 = word0  *((unsigned long *)&__bitmap+$1180) -- vwuz1=_word0__deref_pduc1 
    lda __bitmap+$1180
    sta.z vdest
    lda __bitmap+$1180+1
    sta.z vdest+1
    // memset_vram(vbank, vdest, 0, count)
    // [390] memset_vram::dbank_vram#0 = bitmap_clear::vbank#0
    // [391] memset_vram::doffset_vram#0 = bitmap_clear::vdest#0
    // [392] memset_vram::num#0 = bitmap_clear::count#0
    // [393] call memset_vram
    // [521] phi from bitmap_clear::@1 to memset_vram [phi:bitmap_clear::@1->memset_vram]
    jsr memset_vram
    // bitmap_clear::@return
    // }
    // [394] return 
    rts
}
  // kbhit
kbhit: {
    .label return = $69
    // getin()
    // [396] call getin
    jsr getin
    // [397] getin::return#2 = getin::return#1
    // kbhit::@1
    // [398] kbhit::return#0 = getin::return#2
    // kbhit::@return
    // }
    // [399] return 
    rts
}
  // bitmap_line
// Draw a line on the bitmap
// void bitmap_line(__zp($50) unsigned int x0, __zp($31) unsigned int x1, __zp($24) unsigned int y0, __zp($4e) unsigned int y1, __zp($69) char c)
bitmap_line: {
    .label xd = $6a
    .label yd = $64
    .label yd_1 = $62
    .label x0 = $50
    .label x1 = $31
    .label y0 = $24
    .label y1 = $4e
    .label c = $69
    // if(x0<x1)
    // [401] if(bitmap_line::x0#10<bitmap_line::x1#10) goto bitmap_line::@1 -- vwuz1_lt_vwuz2_then_la1 
    lda.z x0+1
    cmp.z x1+1
    bcs !__b1+
    jmp __b1
  !__b1:
    bne !+
    lda.z x0
    cmp.z x1
    bcs !__b1+
    jmp __b1
  !__b1:
  !:
    // bitmap_line::@2
    // xd = x0-x1
    // [402] bitmap_line::xd#2 = bitmap_line::x0#10 - bitmap_line::x1#10 -- vwuz1=vwuz2_minus_vwuz3 
    lda.z x0
    sec
    sbc.z x1
    sta.z xd
    lda.z x0+1
    sbc.z x1+1
    sta.z xd+1
    // if(y0<y1)
    // [403] if(bitmap_line::y0#10<bitmap_line::y1#10) goto bitmap_line::@7 -- vwuz1_lt_vwuz2_then_la1 
    lda.z y0+1
    cmp.z y1+1
    bcc __b7
    bne !+
    lda.z y0
    cmp.z y1
    bcc __b7
  !:
    // bitmap_line::@3
    // yd = y0-y1
    // [404] bitmap_line::yd#2 = bitmap_line::y0#10 - bitmap_line::y1#10 -- vwuz1=vwuz2_minus_vwuz3 
    lda.z y0
    sec
    sbc.z y1
    sta.z yd_1
    lda.z y0+1
    sbc.z y1+1
    sta.z yd_1+1
    // if(yd<xd)
    // [405] if(bitmap_line::yd#2<bitmap_line::xd#2) goto bitmap_line::@8 -- vwuz1_lt_vwuz2_then_la1 
    cmp.z xd+1
    bcc __b8
    bne !+
    lda.z yd_1
    cmp.z xd
    bcc __b8
  !:
    // bitmap_line::@4
    // bitmap_line_ydxi(y1, x1, y0, yd, xd, c)
    // [406] bitmap_line_ydxi::y#0 = bitmap_line::y1#10 -- vwuz1=vwuz2 
    lda.z y1
    sta.z bitmap_line_ydxi.y
    lda.z y1+1
    sta.z bitmap_line_ydxi.y+1
    // [407] bitmap_line_ydxi::x#0 = bitmap_line::x1#10 -- vwuz1=vwuz2 
    lda.z x1
    sta.z bitmap_line_ydxi.x
    lda.z x1+1
    sta.z bitmap_line_ydxi.x+1
    // [408] bitmap_line_ydxi::y1#0 = bitmap_line::y0#10
    // [409] bitmap_line_ydxi::yd#0 = bitmap_line::yd#2
    // [410] bitmap_line_ydxi::xd#0 = bitmap_line::xd#2
    // [411] bitmap_line_ydxi::c#0 = bitmap_line::c#10
    // [412] call bitmap_line_ydxi
    // [543] phi from bitmap_line::@4 to bitmap_line_ydxi [phi:bitmap_line::@4->bitmap_line_ydxi]
    // [543] phi bitmap_line_ydxi::y1#6 = bitmap_line_ydxi::y1#0 [phi:bitmap_line::@4->bitmap_line_ydxi#0] -- register_copy 
    // [543] phi bitmap_line_ydxi::yd#5 = bitmap_line_ydxi::yd#0 [phi:bitmap_line::@4->bitmap_line_ydxi#1] -- register_copy 
    // [543] phi bitmap_line_ydxi::c#3 = bitmap_line_ydxi::c#0 [phi:bitmap_line::@4->bitmap_line_ydxi#2] -- register_copy 
    // [543] phi bitmap_line_ydxi::y#6 = bitmap_line_ydxi::y#0 [phi:bitmap_line::@4->bitmap_line_ydxi#3] -- register_copy 
    // [543] phi bitmap_line_ydxi::x#5 = bitmap_line_ydxi::x#0 [phi:bitmap_line::@4->bitmap_line_ydxi#4] -- register_copy 
    // [543] phi bitmap_line_ydxi::xd#2 = bitmap_line_ydxi::xd#0 [phi:bitmap_line::@4->bitmap_line_ydxi#5] -- register_copy 
    jsr bitmap_line_ydxi
    // bitmap_line::@return
    // }
    // [413] return 
    rts
    // bitmap_line::@8
  __b8:
    // bitmap_line_xdyi(x1, y1, x0, xd, yd, c)
    // [414] bitmap_line_xdyi::x#0 = bitmap_line::x1#10 -- vwuz1=vwuz2 
    lda.z x1
    sta.z bitmap_line_xdyi.x
    lda.z x1+1
    sta.z bitmap_line_xdyi.x+1
    // [415] bitmap_line_xdyi::y#0 = bitmap_line::y1#10
    // [416] bitmap_line_xdyi::x1#0 = bitmap_line::x0#10 -- vwuz1=vwuz2 
    lda.z x0
    sta.z bitmap_line_xdyi.x1
    lda.z x0+1
    sta.z bitmap_line_xdyi.x1+1
    // [417] bitmap_line_xdyi::xd#0 = bitmap_line::xd#2 -- vwuz1=vwuz2 
    lda.z xd
    sta.z bitmap_line_xdyi.xd
    lda.z xd+1
    sta.z bitmap_line_xdyi.xd+1
    // [418] bitmap_line_xdyi::yd#0 = bitmap_line::yd#2 -- vwuz1=vwuz2 
    lda.z yd_1
    sta.z bitmap_line_xdyi.yd
    lda.z yd_1+1
    sta.z bitmap_line_xdyi.yd+1
    // [419] bitmap_line_xdyi::c#0 = bitmap_line::c#10 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_line_xdyi.c
    // [420] call bitmap_line_xdyi
    // [559] phi from bitmap_line::@8 to bitmap_line_xdyi [phi:bitmap_line::@8->bitmap_line_xdyi]
    // [559] phi bitmap_line_xdyi::x1#6 = bitmap_line_xdyi::x1#0 [phi:bitmap_line::@8->bitmap_line_xdyi#0] -- register_copy 
    // [559] phi bitmap_line_xdyi::xd#5 = bitmap_line_xdyi::xd#0 [phi:bitmap_line::@8->bitmap_line_xdyi#1] -- register_copy 
    // [559] phi bitmap_line_xdyi::c#3 = bitmap_line_xdyi::c#0 [phi:bitmap_line::@8->bitmap_line_xdyi#2] -- register_copy 
    // [559] phi bitmap_line_xdyi::y#5 = bitmap_line_xdyi::y#0 [phi:bitmap_line::@8->bitmap_line_xdyi#3] -- register_copy 
    // [559] phi bitmap_line_xdyi::x#6 = bitmap_line_xdyi::x#0 [phi:bitmap_line::@8->bitmap_line_xdyi#4] -- register_copy 
    // [559] phi bitmap_line_xdyi::yd#2 = bitmap_line_xdyi::yd#0 [phi:bitmap_line::@8->bitmap_line_xdyi#5] -- register_copy 
    jsr bitmap_line_xdyi
    rts
    // bitmap_line::@7
  __b7:
    // yd = y1-y0
    // [421] bitmap_line::yd#1 = bitmap_line::y1#10 - bitmap_line::y0#10 -- vwuz1=vwuz2_minus_vwuz3 
    lda.z y1
    sec
    sbc.z y0
    sta.z yd
    lda.z y1+1
    sbc.z y0+1
    sta.z yd+1
    // if(yd<xd)
    // [422] if(bitmap_line::yd#1<bitmap_line::xd#2) goto bitmap_line::@9 -- vwuz1_lt_vwuz2_then_la1 
    cmp.z xd+1
    bcc __b9
    bne !+
    lda.z yd
    cmp.z xd
    bcc __b9
  !:
    // bitmap_line::@10
    // bitmap_line_ydxd(y0, x0, y1, yd, xd, c)
    // [423] bitmap_line_ydxd::y#0 = bitmap_line::y0#10 -- vwuz1=vwuz2 
    lda.z y0
    sta.z bitmap_line_ydxd.y
    lda.z y0+1
    sta.z bitmap_line_ydxd.y+1
    // [424] bitmap_line_ydxd::x#0 = bitmap_line::x0#10 -- vwuz1=vwuz2 
    lda.z x0
    sta.z bitmap_line_ydxd.x
    lda.z x0+1
    sta.z bitmap_line_ydxd.x+1
    // [425] bitmap_line_ydxd::y1#0 = bitmap_line::y1#10 -- vwuz1=vwuz2 
    lda.z y1
    sta.z bitmap_line_ydxd.y1
    lda.z y1+1
    sta.z bitmap_line_ydxd.y1+1
    // [426] bitmap_line_ydxd::yd#0 = bitmap_line::yd#1
    // [427] bitmap_line_ydxd::xd#0 = bitmap_line::xd#2 -- vwuz1=vwuz2 
    lda.z xd
    sta.z bitmap_line_ydxd.xd
    lda.z xd+1
    sta.z bitmap_line_ydxd.xd+1
    // [428] bitmap_line_ydxd::c#0 = bitmap_line::c#10 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_line_ydxd.c
    // [429] call bitmap_line_ydxd
    // [575] phi from bitmap_line::@10 to bitmap_line_ydxd [phi:bitmap_line::@10->bitmap_line_ydxd]
    // [575] phi bitmap_line_ydxd::y1#6 = bitmap_line_ydxd::y1#0 [phi:bitmap_line::@10->bitmap_line_ydxd#0] -- register_copy 
    // [575] phi bitmap_line_ydxd::yd#5 = bitmap_line_ydxd::yd#0 [phi:bitmap_line::@10->bitmap_line_ydxd#1] -- register_copy 
    // [575] phi bitmap_line_ydxd::c#3 = bitmap_line_ydxd::c#0 [phi:bitmap_line::@10->bitmap_line_ydxd#2] -- register_copy 
    // [575] phi bitmap_line_ydxd::y#7 = bitmap_line_ydxd::y#0 [phi:bitmap_line::@10->bitmap_line_ydxd#3] -- register_copy 
    // [575] phi bitmap_line_ydxd::x#5 = bitmap_line_ydxd::x#0 [phi:bitmap_line::@10->bitmap_line_ydxd#4] -- register_copy 
    // [575] phi bitmap_line_ydxd::xd#2 = bitmap_line_ydxd::xd#0 [phi:bitmap_line::@10->bitmap_line_ydxd#5] -- register_copy 
    jsr bitmap_line_ydxd
    rts
    // bitmap_line::@9
  __b9:
    // bitmap_line_xdyd(x1, y1, x0, xd, yd, c)
    // [430] bitmap_line_xdyd::x#0 = bitmap_line::x1#10 -- vwuz1=vwuz2 
    lda.z x1
    sta.z bitmap_line_xdyd.x
    lda.z x1+1
    sta.z bitmap_line_xdyd.x+1
    // [431] bitmap_line_xdyd::y#0 = bitmap_line::y1#10 -- vwuz1=vwuz2 
    lda.z y1
    sta.z bitmap_line_xdyd.y
    lda.z y1+1
    sta.z bitmap_line_xdyd.y+1
    // [432] bitmap_line_xdyd::x1#0 = bitmap_line::x0#10 -- vwuz1=vwuz2 
    lda.z x0
    sta.z bitmap_line_xdyd.x1
    lda.z x0+1
    sta.z bitmap_line_xdyd.x1+1
    // [433] bitmap_line_xdyd::xd#0 = bitmap_line::xd#2 -- vwuz1=vwuz2 
    lda.z xd
    sta.z bitmap_line_xdyd.xd
    lda.z xd+1
    sta.z bitmap_line_xdyd.xd+1
    // [434] bitmap_line_xdyd::yd#0 = bitmap_line::yd#1 -- vwuz1=vwuz2 
    lda.z yd
    sta.z bitmap_line_xdyd.yd
    lda.z yd+1
    sta.z bitmap_line_xdyd.yd+1
    // [435] bitmap_line_xdyd::c#0 = bitmap_line::c#10 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_line_xdyd.c
    // [436] call bitmap_line_xdyd
    // [591] phi from bitmap_line::@9 to bitmap_line_xdyd [phi:bitmap_line::@9->bitmap_line_xdyd]
    // [591] phi bitmap_line_xdyd::x1#6 = bitmap_line_xdyd::x1#0 [phi:bitmap_line::@9->bitmap_line_xdyd#0] -- register_copy 
    // [591] phi bitmap_line_xdyd::xd#5 = bitmap_line_xdyd::xd#0 [phi:bitmap_line::@9->bitmap_line_xdyd#1] -- register_copy 
    // [591] phi bitmap_line_xdyd::c#3 = bitmap_line_xdyd::c#0 [phi:bitmap_line::@9->bitmap_line_xdyd#2] -- register_copy 
    // [591] phi bitmap_line_xdyd::y#5 = bitmap_line_xdyd::y#0 [phi:bitmap_line::@9->bitmap_line_xdyd#3] -- register_copy 
    // [591] phi bitmap_line_xdyd::x#6 = bitmap_line_xdyd::x#0 [phi:bitmap_line::@9->bitmap_line_xdyd#4] -- register_copy 
    // [591] phi bitmap_line_xdyd::yd#2 = bitmap_line_xdyd::yd#0 [phi:bitmap_line::@9->bitmap_line_xdyd#5] -- register_copy 
    jsr bitmap_line_xdyd
    rts
    // bitmap_line::@1
  __b1:
    // xd = x1-x0
    // [437] bitmap_line::xd#1 = bitmap_line::x1#10 - bitmap_line::x0#10 -- vwuz1=vwuz2_minus_vwuz3 
    lda.z x1
    sec
    sbc.z x0
    sta.z xd
    lda.z x1+1
    sbc.z x0+1
    sta.z xd+1
    // if(y0<y1)
    // [438] if(bitmap_line::y0#10<bitmap_line::y1#10) goto bitmap_line::@11 -- vwuz1_lt_vwuz2_then_la1 
    lda.z y0+1
    cmp.z y1+1
    bcc __b11
    bne !+
    lda.z y0
    cmp.z y1
    bcc __b11
  !:
    // bitmap_line::@5
    // yd = y0-y1
    // [439] bitmap_line::yd#10 = bitmap_line::y0#10 - bitmap_line::y1#10 -- vwuz1=vwuz2_minus_vwuz3 
    lda.z y0
    sec
    sbc.z y1
    sta.z yd
    lda.z y0+1
    sbc.z y1+1
    sta.z yd+1
    // if(yd<xd)
    // [440] if(bitmap_line::yd#10<bitmap_line::xd#1) goto bitmap_line::@12 -- vwuz1_lt_vwuz2_then_la1 
    cmp.z xd+1
    bcc __b12
    bne !+
    lda.z yd
    cmp.z xd
    bcc __b12
  !:
    // bitmap_line::@6
    // bitmap_line_ydxd(y1, x1, y0, yd, xd, c)
    // [441] bitmap_line_ydxd::y#1 = bitmap_line::y1#10 -- vwuz1=vwuz2 
    lda.z y1
    sta.z bitmap_line_ydxd.y
    lda.z y1+1
    sta.z bitmap_line_ydxd.y+1
    // [442] bitmap_line_ydxd::x#1 = bitmap_line::x1#10 -- vwuz1=vwuz2 
    lda.z x1
    sta.z bitmap_line_ydxd.x
    lda.z x1+1
    sta.z bitmap_line_ydxd.x+1
    // [443] bitmap_line_ydxd::y1#1 = bitmap_line::y0#10 -- vwuz1=vwuz2 
    lda.z y0
    sta.z bitmap_line_ydxd.y1
    lda.z y0+1
    sta.z bitmap_line_ydxd.y1+1
    // [444] bitmap_line_ydxd::yd#1 = bitmap_line::yd#10
    // [445] bitmap_line_ydxd::xd#1 = bitmap_line::xd#1 -- vwuz1=vwuz2 
    lda.z xd
    sta.z bitmap_line_ydxd.xd
    lda.z xd+1
    sta.z bitmap_line_ydxd.xd+1
    // [446] bitmap_line_ydxd::c#1 = bitmap_line::c#10 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_line_ydxd.c
    // [447] call bitmap_line_ydxd
    // [575] phi from bitmap_line::@6 to bitmap_line_ydxd [phi:bitmap_line::@6->bitmap_line_ydxd]
    // [575] phi bitmap_line_ydxd::y1#6 = bitmap_line_ydxd::y1#1 [phi:bitmap_line::@6->bitmap_line_ydxd#0] -- register_copy 
    // [575] phi bitmap_line_ydxd::yd#5 = bitmap_line_ydxd::yd#1 [phi:bitmap_line::@6->bitmap_line_ydxd#1] -- register_copy 
    // [575] phi bitmap_line_ydxd::c#3 = bitmap_line_ydxd::c#1 [phi:bitmap_line::@6->bitmap_line_ydxd#2] -- register_copy 
    // [575] phi bitmap_line_ydxd::y#7 = bitmap_line_ydxd::y#1 [phi:bitmap_line::@6->bitmap_line_ydxd#3] -- register_copy 
    // [575] phi bitmap_line_ydxd::x#5 = bitmap_line_ydxd::x#1 [phi:bitmap_line::@6->bitmap_line_ydxd#4] -- register_copy 
    // [575] phi bitmap_line_ydxd::xd#2 = bitmap_line_ydxd::xd#1 [phi:bitmap_line::@6->bitmap_line_ydxd#5] -- register_copy 
    jsr bitmap_line_ydxd
    rts
    // bitmap_line::@12
  __b12:
    // bitmap_line_xdyd(x0, y0, x1, xd, yd, c)
    // [448] bitmap_line_xdyd::x#1 = bitmap_line::x0#10 -- vwuz1=vwuz2 
    lda.z x0
    sta.z bitmap_line_xdyd.x
    lda.z x0+1
    sta.z bitmap_line_xdyd.x+1
    // [449] bitmap_line_xdyd::y#1 = bitmap_line::y0#10 -- vwuz1=vwuz2 
    lda.z y0
    sta.z bitmap_line_xdyd.y
    lda.z y0+1
    sta.z bitmap_line_xdyd.y+1
    // [450] bitmap_line_xdyd::x1#1 = bitmap_line::x1#10 -- vwuz1=vwuz2 
    lda.z x1
    sta.z bitmap_line_xdyd.x1
    lda.z x1+1
    sta.z bitmap_line_xdyd.x1+1
    // [451] bitmap_line_xdyd::xd#1 = bitmap_line::xd#1 -- vwuz1=vwuz2 
    lda.z xd
    sta.z bitmap_line_xdyd.xd
    lda.z xd+1
    sta.z bitmap_line_xdyd.xd+1
    // [452] bitmap_line_xdyd::yd#1 = bitmap_line::yd#10 -- vwuz1=vwuz2 
    lda.z yd
    sta.z bitmap_line_xdyd.yd
    lda.z yd+1
    sta.z bitmap_line_xdyd.yd+1
    // [453] bitmap_line_xdyd::c#1 = bitmap_line::c#10 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_line_xdyd.c
    // [454] call bitmap_line_xdyd
    // [591] phi from bitmap_line::@12 to bitmap_line_xdyd [phi:bitmap_line::@12->bitmap_line_xdyd]
    // [591] phi bitmap_line_xdyd::x1#6 = bitmap_line_xdyd::x1#1 [phi:bitmap_line::@12->bitmap_line_xdyd#0] -- register_copy 
    // [591] phi bitmap_line_xdyd::xd#5 = bitmap_line_xdyd::xd#1 [phi:bitmap_line::@12->bitmap_line_xdyd#1] -- register_copy 
    // [591] phi bitmap_line_xdyd::c#3 = bitmap_line_xdyd::c#1 [phi:bitmap_line::@12->bitmap_line_xdyd#2] -- register_copy 
    // [591] phi bitmap_line_xdyd::y#5 = bitmap_line_xdyd::y#1 [phi:bitmap_line::@12->bitmap_line_xdyd#3] -- register_copy 
    // [591] phi bitmap_line_xdyd::x#6 = bitmap_line_xdyd::x#1 [phi:bitmap_line::@12->bitmap_line_xdyd#4] -- register_copy 
    // [591] phi bitmap_line_xdyd::yd#2 = bitmap_line_xdyd::yd#1 [phi:bitmap_line::@12->bitmap_line_xdyd#5] -- register_copy 
    jsr bitmap_line_xdyd
    rts
    // bitmap_line::@11
  __b11:
    // yd = y1-y0
    // [455] bitmap_line::yd#11 = bitmap_line::y1#10 - bitmap_line::y0#10 -- vwuz1=vwuz2_minus_vwuz3 
    lda.z y1
    sec
    sbc.z y0
    sta.z yd_1
    lda.z y1+1
    sbc.z y0+1
    sta.z yd_1+1
    // if(yd<xd)
    // [456] if(bitmap_line::yd#11<bitmap_line::xd#1) goto bitmap_line::@13 -- vwuz1_lt_vwuz2_then_la1 
    cmp.z xd+1
    bcc __b13
    bne !+
    lda.z yd_1
    cmp.z xd
    bcc __b13
  !:
    // bitmap_line::@14
    // bitmap_line_ydxi(y0, x0, y1, yd, xd, c)
    // [457] bitmap_line_ydxi::y#1 = bitmap_line::y0#10 -- vwuz1=vwuz2 
    lda.z y0
    sta.z bitmap_line_ydxi.y
    lda.z y0+1
    sta.z bitmap_line_ydxi.y+1
    // [458] bitmap_line_ydxi::x#1 = bitmap_line::x0#10
    // [459] bitmap_line_ydxi::y1#1 = bitmap_line::y1#10 -- vwuz1=vwuz2 
    lda.z y1
    sta.z bitmap_line_ydxi.y1
    lda.z y1+1
    sta.z bitmap_line_ydxi.y1+1
    // [460] bitmap_line_ydxi::yd#1 = bitmap_line::yd#11
    // [461] bitmap_line_ydxi::xd#1 = bitmap_line::xd#1
    // [462] bitmap_line_ydxi::c#1 = bitmap_line::c#10
    // [463] call bitmap_line_ydxi
    // [543] phi from bitmap_line::@14 to bitmap_line_ydxi [phi:bitmap_line::@14->bitmap_line_ydxi]
    // [543] phi bitmap_line_ydxi::y1#6 = bitmap_line_ydxi::y1#1 [phi:bitmap_line::@14->bitmap_line_ydxi#0] -- register_copy 
    // [543] phi bitmap_line_ydxi::yd#5 = bitmap_line_ydxi::yd#1 [phi:bitmap_line::@14->bitmap_line_ydxi#1] -- register_copy 
    // [543] phi bitmap_line_ydxi::c#3 = bitmap_line_ydxi::c#1 [phi:bitmap_line::@14->bitmap_line_ydxi#2] -- register_copy 
    // [543] phi bitmap_line_ydxi::y#6 = bitmap_line_ydxi::y#1 [phi:bitmap_line::@14->bitmap_line_ydxi#3] -- register_copy 
    // [543] phi bitmap_line_ydxi::x#5 = bitmap_line_ydxi::x#1 [phi:bitmap_line::@14->bitmap_line_ydxi#4] -- register_copy 
    // [543] phi bitmap_line_ydxi::xd#2 = bitmap_line_ydxi::xd#1 [phi:bitmap_line::@14->bitmap_line_ydxi#5] -- register_copy 
    jsr bitmap_line_ydxi
    rts
    // bitmap_line::@13
  __b13:
    // bitmap_line_xdyi(x0, y0, x1, xd, yd, c)
    // [464] bitmap_line_xdyi::x#1 = bitmap_line::x0#10 -- vwuz1=vwuz2 
    lda.z x0
    sta.z bitmap_line_xdyi.x
    lda.z x0+1
    sta.z bitmap_line_xdyi.x+1
    // [465] bitmap_line_xdyi::y#1 = bitmap_line::y0#10 -- vwuz1=vwuz2 
    lda.z y0
    sta.z bitmap_line_xdyi.y
    lda.z y0+1
    sta.z bitmap_line_xdyi.y+1
    // [466] bitmap_line_xdyi::x1#1 = bitmap_line::x1#10
    // [467] bitmap_line_xdyi::xd#1 = bitmap_line::xd#1 -- vwuz1=vwuz2 
    lda.z xd
    sta.z bitmap_line_xdyi.xd
    lda.z xd+1
    sta.z bitmap_line_xdyi.xd+1
    // [468] bitmap_line_xdyi::yd#1 = bitmap_line::yd#11 -- vwuz1=vwuz2 
    lda.z yd_1
    sta.z bitmap_line_xdyi.yd
    lda.z yd_1+1
    sta.z bitmap_line_xdyi.yd+1
    // [469] bitmap_line_xdyi::c#1 = bitmap_line::c#10 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_line_xdyi.c
    // [470] call bitmap_line_xdyi
    // [559] phi from bitmap_line::@13 to bitmap_line_xdyi [phi:bitmap_line::@13->bitmap_line_xdyi]
    // [559] phi bitmap_line_xdyi::x1#6 = bitmap_line_xdyi::x1#1 [phi:bitmap_line::@13->bitmap_line_xdyi#0] -- register_copy 
    // [559] phi bitmap_line_xdyi::xd#5 = bitmap_line_xdyi::xd#1 [phi:bitmap_line::@13->bitmap_line_xdyi#1] -- register_copy 
    // [559] phi bitmap_line_xdyi::c#3 = bitmap_line_xdyi::c#1 [phi:bitmap_line::@13->bitmap_line_xdyi#2] -- register_copy 
    // [559] phi bitmap_line_xdyi::y#5 = bitmap_line_xdyi::y#1 [phi:bitmap_line::@13->bitmap_line_xdyi#3] -- register_copy 
    // [559] phi bitmap_line_xdyi::x#6 = bitmap_line_xdyi::x#1 [phi:bitmap_line::@13->bitmap_line_xdyi#4] -- register_copy 
    // [559] phi bitmap_line_xdyi::yd#2 = bitmap_line_xdyi::yd#1 [phi:bitmap_line::@13->bitmap_line_xdyi#5] -- register_copy 
    jsr bitmap_line_xdyi
    rts
}
  // rand
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
rand: {
    .label __0 = $56
    .label __1 = $26
    .label __2 = $22
    .label return = $74
    // rand_state << 7
    // [471] rand::$0 = rand_state << 7 -- vwuz1=vwuz2_rol_7 
    lda.z rand_state+1
    lsr
    lda.z rand_state
    ror
    sta.z __0+1
    lda #0
    ror
    sta.z __0
    // rand_state ^= rand_state << 7
    // [472] rand_state = rand_state ^ rand::$0 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __0
    sta.z rand_state
    lda.z rand_state+1
    eor.z __0+1
    sta.z rand_state+1
    // rand_state >> 9
    // [473] rand::$1 = rand_state >> 9 -- vwuz1=vwuz2_ror_9 
    lsr
    sta.z __1
    lda #0
    sta.z __1+1
    // rand_state ^= rand_state >> 9
    // [474] rand_state = rand_state ^ rand::$1 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __1
    sta.z rand_state
    lda.z rand_state+1
    eor.z __1+1
    sta.z rand_state+1
    // rand_state << 8
    // [475] rand::$2 = rand_state << 8 -- vwuz1=vwuz2_rol_8 
    lda.z rand_state
    sta.z __2+1
    lda #0
    sta.z __2
    // rand_state ^= rand_state << 8
    // [476] rand_state = rand_state ^ rand::$2 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __2
    sta.z rand_state
    lda.z rand_state+1
    eor.z __2+1
    sta.z rand_state+1
    // return rand_state;
    // [477] rand::return#0 = rand_state -- vwuz1=vwuz2 
    lda.z rand_state
    sta.z return
    lda.z rand_state+1
    sta.z return+1
    // rand::@return
    // }
    // [478] return 
    rts
}
  // modr16u
// Performs modulo on two 16 bit unsigned ints and an initial remainder
// Returns the remainder.
// Implemented using simple binary division
// __zp($4e) unsigned int modr16u(__zp($74) unsigned int dividend, __zp($6a) unsigned int divisor, unsigned int rem)
modr16u: {
    .label return = $4e
    .label dividend = $74
    .label return_1 = $50
    .label return_2 = $31
    .label return_3 = $24
    .label divisor = $6a
    // divr16u(dividend, divisor, rem)
    // [480] divr16u::dividend#1 = modr16u::dividend#4
    // [481] divr16u::divisor#0 = modr16u::divisor#4
    // [482] call divr16u
    // [607] phi from modr16u to divr16u [phi:modr16u->divr16u]
    jsr divr16u
    // modr16u::@1
    // return rem16u;
    // [483] modr16u::return#0 = rem16u#0 -- vwuz1=vwuz2 
    lda.z rem16u
    sta.z return
    lda.z rem16u+1
    sta.z return+1
    // modr16u::@return
    // }
    // [484] return 
    rts
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(__conio.cursor_y>=__conio.height)
    // [485] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto cscroll::@return -- _deref_pbuc1_lt__deref_pbuc2_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    bcc __breturn
    // cscroll::@1
    // if(__conio.scroll[__conio.layer])
    // [486] if(0!=((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_SCROLL)[*((char *)&__conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_SCROLL,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(__conio.cursor_y>=__conio.height)
    // [487] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto cscroll::@return -- _deref_pbuc1_lt__deref_pbuc2_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    bcc __breturn
    // [488] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
    // gotoxy(0,0)
    // [489] call gotoxy
    // [230] phi from cscroll::@3 to gotoxy [phi:cscroll::@3->gotoxy]
    // [230] phi gotoxy::x#10 = 0 [phi:cscroll::@3->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [230] phi gotoxy::y#8 = 0 [phi:cscroll::@3->gotoxy#1] -- vbuz1=vbuc1 
    sta.z gotoxy.y
    jsr gotoxy
    // cscroll::@return
  __breturn:
    // }
    // [490] return 
    rts
    // [491] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [492] call insertup
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, __conio.height-1)
    // [493] gotoxy::y#2 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    dex
    stx.z gotoxy.y
    // [494] call gotoxy
    // [230] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [230] phi gotoxy::x#10 = 0 [phi:cscroll::@5->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [230] phi gotoxy::y#8 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#1] -- register_copy 
    jsr gotoxy
    // [495] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [496] call clearline
    jsr clearline
    rts
}
  // bitmap_hscale
bitmap_hscale: {
    .const scale = 0
    .label return = $69
    .label s = $69
    // [498] phi from bitmap_hscale to bitmap_hscale::@1 [phi:bitmap_hscale->bitmap_hscale::@1]
    // [498] phi bitmap_hscale::s#2 = 1 [phi:bitmap_hscale->bitmap_hscale::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z s
    // bitmap_hscale::@1
  __b1:
    // for(char s=1;s<=3;s++)
    // [499] if(bitmap_hscale::s#2<3+1) goto bitmap_hscale::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z s
    cmp #3+1
    bcc __b2
    // [501] phi from bitmap_hscale::@1 to bitmap_hscale::@4 [phi:bitmap_hscale::@1->bitmap_hscale::@4]
    // [501] phi bitmap_hscale::return#1 = bitmap_hscale::scale#0 [phi:bitmap_hscale::@1->bitmap_hscale::@4#0] -- vbuz1=vbuc1 
    lda #scale
    sta.z return
    rts
    // bitmap_hscale::@2
  __b2:
    // if(*VERA_DC_HSCALE==hscale[s])
    // [500] if(*VERA_DC_HSCALE!=bitmap_hscale::hscale[bitmap_hscale::s#2]) goto bitmap_hscale::@3 -- _deref_pbuc1_neq_pbuc2_derefidx_vbuz1_then_la1 
    lda VERA_DC_HSCALE
    ldy.z s
    cmp hscale,y
    bne __b3
    // [501] phi from bitmap_hscale::@2 to bitmap_hscale::@4 [phi:bitmap_hscale::@2->bitmap_hscale::@4]
    // [501] phi bitmap_hscale::return#1 = bitmap_hscale::s#2 [phi:bitmap_hscale::@2->bitmap_hscale::@4#0] -- register_copy 
    // bitmap_hscale::@4
    // bitmap_hscale::@return
    // }
    // [502] return 
    rts
    // bitmap_hscale::@3
  __b3:
    // for(char s=1;s<=3;s++)
    // [503] bitmap_hscale::s#1 = ++ bitmap_hscale::s#2 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [498] phi from bitmap_hscale::@3 to bitmap_hscale::@1 [phi:bitmap_hscale::@3->bitmap_hscale::@1]
    // [498] phi bitmap_hscale::s#2 = bitmap_hscale::s#1 [phi:bitmap_hscale::@3->bitmap_hscale::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    hscale: .byte 0, $80, $40, $20
}
.segment Code
  // bitmap_vscale
bitmap_vscale: {
    .const scale = 0
    .label return = $6c
    .label s = $6c
    // [505] phi from bitmap_vscale to bitmap_vscale::@1 [phi:bitmap_vscale->bitmap_vscale::@1]
    // [505] phi bitmap_vscale::s#2 = 1 [phi:bitmap_vscale->bitmap_vscale::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z s
    // bitmap_vscale::@1
  __b1:
    // for(char s=1;s<=3;s++)
    // [506] if(bitmap_vscale::s#2<3+1) goto bitmap_vscale::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z s
    cmp #3+1
    bcc __b2
    // [508] phi from bitmap_vscale::@1 to bitmap_vscale::@4 [phi:bitmap_vscale::@1->bitmap_vscale::@4]
    // [508] phi bitmap_vscale::return#1 = bitmap_vscale::scale#0 [phi:bitmap_vscale::@1->bitmap_vscale::@4#0] -- vbuz1=vbuc1 
    lda #scale
    sta.z return
    rts
    // bitmap_vscale::@2
  __b2:
    // if(*VERA_DC_VSCALE==vscale[s])
    // [507] if(*VERA_DC_VSCALE!=bitmap_vscale::vscale[bitmap_vscale::s#2]) goto bitmap_vscale::@3 -- _deref_pbuc1_neq_pbuc2_derefidx_vbuz1_then_la1 
    lda VERA_DC_VSCALE
    ldy.z s
    cmp vscale,y
    bne __b3
    // [508] phi from bitmap_vscale::@2 to bitmap_vscale::@4 [phi:bitmap_vscale::@2->bitmap_vscale::@4]
    // [508] phi bitmap_vscale::return#1 = bitmap_vscale::s#2 [phi:bitmap_vscale::@2->bitmap_vscale::@4#0] -- register_copy 
    // bitmap_vscale::@4
    // bitmap_vscale::@return
    // }
    // [509] return 
    rts
    // bitmap_vscale::@3
  __b3:
    // for(char s=1;s<=3;s++)
    // [510] bitmap_vscale::s#1 = ++ bitmap_vscale::s#2 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [505] phi from bitmap_vscale::@3 to bitmap_vscale::@1 [phi:bitmap_vscale::@3->bitmap_vscale::@1]
    // [505] phi bitmap_vscale::s#2 = bitmap_vscale::s#1 [phi:bitmap_vscale::@3->bitmap_vscale::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    vscale: .byte 0, $80, $40, $20
}
.segment Code
  // mul16u
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// __zp($37) unsigned long mul16u(__zp($24) unsigned int a, __zp($4e) unsigned int b)
mul16u: {
    .label __1 = $77
    .label a = $24
    .label b = $4e
    .label return = $37
    .label mb = $3e
    .label res = $37
    // unsigned long mb = b
    // [511] mul16u::mb#0 = (unsigned long)mul16u::b#0 -- vduz1=_dword_vwuz2 
    lda.z b
    sta.z mb
    lda.z b+1
    sta.z mb+1
    lda #0
    sta.z mb+2
    sta.z mb+3
    // [512] phi from mul16u to mul16u::@1 [phi:mul16u->mul16u::@1]
    // [512] phi mul16u::mb#2 = mul16u::mb#0 [phi:mul16u->mul16u::@1#0] -- register_copy 
    // [512] phi mul16u::res#2 = 0 [phi:mul16u->mul16u::@1#1] -- vduz1=vduc1 
    sta.z res
    sta.z res+1
    lda #<0>>$10
    sta.z res+2
    lda #>0>>$10
    sta.z res+3
    // [512] phi mul16u::a#2 = mul16u::a#0 [phi:mul16u->mul16u::@1#2] -- register_copy 
    // mul16u::@1
  __b1:
    // while(a!=0)
    // [513] if(mul16u::a#2!=0) goto mul16u::@2 -- vwuz1_neq_0_then_la1 
    lda.z a
    ora.z a+1
    bne __b2
    // mul16u::@return
    // }
    // [514] return 
    rts
    // mul16u::@2
  __b2:
    // a&1
    // [515] mul16u::$1 = mul16u::a#2 & 1 -- vbuz1=vwuz2_band_vbuc1 
    lda #1
    and.z a
    sta.z __1
    // if( (a&1) != 0)
    // [516] if(mul16u::$1==0) goto mul16u::@3 -- vbuz1_eq_0_then_la1 
    beq __b3
    // mul16u::@4
    // res = res + mb
    // [517] mul16u::res#1 = mul16u::res#2 + mul16u::mb#2 -- vduz1=vduz1_plus_vduz2 
    clc
    lda.z res
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
    lda.z res+2
    adc.z mb+2
    sta.z res+2
    lda.z res+3
    adc.z mb+3
    sta.z res+3
    // [518] phi from mul16u::@2 mul16u::@4 to mul16u::@3 [phi:mul16u::@2/mul16u::@4->mul16u::@3]
    // [518] phi mul16u::res#6 = mul16u::res#2 [phi:mul16u::@2/mul16u::@4->mul16u::@3#0] -- register_copy 
    // mul16u::@3
  __b3:
    // a = a>>1
    // [519] mul16u::a#1 = mul16u::a#2 >> 1 -- vwuz1=vwuz1_ror_1 
    lsr.z a+1
    ror.z a
    // mb = mb<<1
    // [520] mul16u::mb#1 = mul16u::mb#2 << 1 -- vduz1=vduz1_rol_1 
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    // [512] phi from mul16u::@3 to mul16u::@1 [phi:mul16u::@3->mul16u::@1]
    // [512] phi mul16u::mb#2 = mul16u::mb#1 [phi:mul16u::@3->mul16u::@1#0] -- register_copy 
    // [512] phi mul16u::res#2 = mul16u::res#6 [phi:mul16u::@3->mul16u::@1#1] -- register_copy 
    // [512] phi mul16u::a#2 = mul16u::a#1 [phi:mul16u::@3->mul16u::@1#2] -- register_copy 
    jmp __b1
}
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
// void memset_vram(__zp($73) char dbank_vram, __zp($62) unsigned int doffset_vram, unsigned int data, __zp($6a) unsigned int num)
memset_vram: {
    .label vera_vram_data0_bank_offset1___0 = $77
    .label vera_vram_data0_bank_offset1___1 = $5e
    .label vera_vram_data0_bank_offset1___2 = $73
    .label i = $4e
    .label dbank_vram = $73
    .label doffset_vram = $62
    .label num = $6a
    // memset_vram::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [522] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [523] memset_vram::vera_vram_data0_bank_offset1_$0 = byte0  memset_vram::doffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z doffset_vram
    sta.z vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [524] *VERA_ADDRX_L = memset_vram::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [525] memset_vram::vera_vram_data0_bank_offset1_$1 = byte1  memset_vram::doffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z doffset_vram+1
    sta.z vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [526] *VERA_ADDRX_M = memset_vram::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // bank | inc_dec
    // [527] memset_vram::vera_vram_data0_bank_offset1_$2 = memset_vram::dbank_vram#0 | vera_inc_1 -- vbuz1=vbuz1_bor_vbuc1 
    lda #vera_inc_1
    ora.z vera_vram_data0_bank_offset1___2
    sta.z vera_vram_data0_bank_offset1___2
    // *VERA_ADDRX_H = bank | inc_dec
    // [528] *VERA_ADDRX_H = memset_vram::vera_vram_data0_bank_offset1_$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [529] phi from memset_vram::vera_vram_data0_bank_offset1 to memset_vram::@1 [phi:memset_vram::vera_vram_data0_bank_offset1->memset_vram::@1]
    // [529] phi memset_vram::i#2 = 0 [phi:memset_vram::vera_vram_data0_bank_offset1->memset_vram::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // memset_vram::@1
  __b1:
    // for(word i = 0; i<num; i++)
    // [530] if(memset_vram::i#2<memset_vram::num#0) goto memset_vram::@2 -- vwuz1_lt_vwuz2_then_la1 
    lda.z i+1
    cmp.z num+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z num
    bcc __b2
  !:
    // memset_vram::@return
    // }
    // [531] return 
    rts
    // memset_vram::@2
  __b2:
    // *VERA_DATA0 = BYTE0(data)
    // [532] *VERA_DATA0 = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta VERA_DATA0
    // *VERA_DATA0 = BYTE1(data)
    // [533] *VERA_DATA0 = 0 -- _deref_pbuc1=vbuc2 
    sta VERA_DATA0
    // for(word i = 0; i<num; i++)
    // [534] memset_vram::i#1 = ++ memset_vram::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [529] phi from memset_vram::@2 to memset_vram::@1 [phi:memset_vram::@2->memset_vram::@1]
    // [529] phi memset_vram::i#2 = memset_vram::i#1 [phi:memset_vram::@2->memset_vram::@1#0] -- register_copy 
    jmp __b1
}
  // getin
/**
 * @brief Get a character from keyboard.
 * 
 * @return char The character read.
 */
getin: {
    .const bank_set_bram1_bank = 0
    .label ch = $78
    .label bank_get_bram1_return = $76
    .label return = $69
    // char ch
    // [535] getin::ch = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z ch
    // getin::bank_get_bram1
    // return BRAM;
    // [536] getin::bank_get_bram1_return#0 = BRAM -- vbuz1=vbuz2 
    lda.z BRAM
    sta.z bank_get_bram1_return
    // getin::bank_set_bram1
    // BRAM = bank
    // [537] BRAM = getin::bank_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_set_bram1_bank
    sta.z BRAM
    // getin::@1
    // asm
    // asm { jsr$ffe4 stach  }
    jsr $ffe4
    sta ch
    // getin::bank_set_bram2
    // BRAM = bank
    // [539] BRAM = getin::bank_get_bram1_return#0 -- vbuz1=vbuz2 
    lda.z bank_get_bram1_return
    sta.z BRAM
    // getin::@2
    // return ch;
    // [540] getin::return#0 = getin::ch -- vbuz1=vbuz2 
    lda.z ch
    sta.z return
    // getin::@return
    // }
    // [541] getin::return#1 = getin::return#0
    // [542] return 
    rts
}
  // bitmap_line_ydxi
// void bitmap_line_ydxi(__zp($56) unsigned int y, __zp($50) unsigned int x, __zp($24) unsigned int y1, __zp($62) unsigned int yd, __zp($6a) unsigned int xd, __zp($69) char c)
bitmap_line_ydxi: {
    .label __6 = $4c
    .label y = $56
    .label x = $50
    .label y1 = $24
    .label yd = $62
    .label xd = $6a
    .label c = $69
    .label e = $26
    // unsigned int e = xd>>1
    // [544] bitmap_line_ydxi::e#0 = bitmap_line_ydxi::xd#2 >> 1 -- vwuz1=vwuz2_ror_1 
    lda.z xd+1
    lsr
    sta.z e+1
    lda.z xd
    ror
    sta.z e
    // [545] phi from bitmap_line_ydxi bitmap_line_ydxi::@2 to bitmap_line_ydxi::@1 [phi:bitmap_line_ydxi/bitmap_line_ydxi::@2->bitmap_line_ydxi::@1]
    // [545] phi bitmap_line_ydxi::e#3 = bitmap_line_ydxi::e#0 [phi:bitmap_line_ydxi/bitmap_line_ydxi::@2->bitmap_line_ydxi::@1#0] -- register_copy 
    // [545] phi bitmap_line_ydxi::y#3 = bitmap_line_ydxi::y#6 [phi:bitmap_line_ydxi/bitmap_line_ydxi::@2->bitmap_line_ydxi::@1#1] -- register_copy 
    // [545] phi bitmap_line_ydxi::x#3 = bitmap_line_ydxi::x#5 [phi:bitmap_line_ydxi/bitmap_line_ydxi::@2->bitmap_line_ydxi::@1#2] -- register_copy 
    // bitmap_line_ydxi::@1
  __b1:
    // bitmap_plot(x,y,c)
    // [546] bitmap_plot::x#2 = bitmap_line_ydxi::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_plot.x
    lda.z x+1
    sta.z bitmap_plot.x+1
    // [547] bitmap_plot::y#2 = bitmap_line_ydxi::y#3 -- vwuz1=vwuz2 
    lda.z y
    sta.z bitmap_plot.y
    lda.z y+1
    sta.z bitmap_plot.y+1
    // [548] bitmap_plot::c#3 = bitmap_line_ydxi::c#3 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_plot.c
    // [549] call bitmap_plot
    // [657] phi from bitmap_line_ydxi::@1 to bitmap_plot [phi:bitmap_line_ydxi::@1->bitmap_plot]
    // [657] phi bitmap_plot::c#5 = bitmap_plot::c#3 [phi:bitmap_line_ydxi::@1->bitmap_plot#0] -- register_copy 
    // [657] phi bitmap_plot::y#4 = bitmap_plot::y#2 [phi:bitmap_line_ydxi::@1->bitmap_plot#1] -- register_copy 
    // [657] phi bitmap_plot::x#10 = bitmap_plot::x#2 [phi:bitmap_line_ydxi::@1->bitmap_plot#2] -- register_copy 
    jsr bitmap_plot
    // bitmap_line_ydxi::@4
    // y++;
    // [550] bitmap_line_ydxi::y#2 = ++ bitmap_line_ydxi::y#3 -- vwuz1=_inc_vwuz1 
    inc.z y
    bne !+
    inc.z y+1
  !:
    // e = e+xd
    // [551] bitmap_line_ydxi::e#1 = bitmap_line_ydxi::e#3 + bitmap_line_ydxi::xd#2 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z e
    adc.z xd
    sta.z e
    lda.z e+1
    adc.z xd+1
    sta.z e+1
    // if(yd<e)
    // [552] if(bitmap_line_ydxi::yd#5>=bitmap_line_ydxi::e#1) goto bitmap_line_ydxi::@2 -- vwuz1_ge_vwuz2_then_la1 
    cmp.z yd+1
    bne !+
    lda.z e
    cmp.z yd
    beq __b2
  !:
    bcc __b2
    // bitmap_line_ydxi::@3
    // x++;
    // [553] bitmap_line_ydxi::x#2 = ++ bitmap_line_ydxi::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // e = e - yd
    // [554] bitmap_line_ydxi::e#2 = bitmap_line_ydxi::e#1 - bitmap_line_ydxi::yd#5 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z e
    sec
    sbc.z yd
    sta.z e
    lda.z e+1
    sbc.z yd+1
    sta.z e+1
    // [555] phi from bitmap_line_ydxi::@3 bitmap_line_ydxi::@4 to bitmap_line_ydxi::@2 [phi:bitmap_line_ydxi::@3/bitmap_line_ydxi::@4->bitmap_line_ydxi::@2]
    // [555] phi bitmap_line_ydxi::e#6 = bitmap_line_ydxi::e#2 [phi:bitmap_line_ydxi::@3/bitmap_line_ydxi::@4->bitmap_line_ydxi::@2#0] -- register_copy 
    // [555] phi bitmap_line_ydxi::x#6 = bitmap_line_ydxi::x#2 [phi:bitmap_line_ydxi::@3/bitmap_line_ydxi::@4->bitmap_line_ydxi::@2#1] -- register_copy 
    // bitmap_line_ydxi::@2
  __b2:
    // y1+1
    // [556] bitmap_line_ydxi::$6 = bitmap_line_ydxi::y1#6 + 1 -- vwuz1=vwuz2_plus_1 
    clc
    lda.z y1
    adc #1
    sta.z __6
    lda.z y1+1
    adc #0
    sta.z __6+1
    // while (y!=(y1+1))
    // [557] if(bitmap_line_ydxi::y#2!=bitmap_line_ydxi::$6) goto bitmap_line_ydxi::@1 -- vwuz1_neq_vwuz2_then_la1 
    lda.z y+1
    cmp.z __6+1
    bne __b1
    lda.z y
    cmp.z __6
    bne __b1
    // bitmap_line_ydxi::@return
    // }
    // [558] return 
    rts
}
  // bitmap_line_xdyi
// void bitmap_line_xdyi(__zp($5a) unsigned int x, __zp($4e) unsigned int y, __zp($31) unsigned int x1, __zp($4a) unsigned int xd, __zp($22) unsigned int yd, __zp($6c) char c)
bitmap_line_xdyi: {
    .label __6 = $4c
    .label x = $5a
    .label y = $4e
    .label x1 = $31
    .label xd = $4a
    .label yd = $22
    .label c = $6c
    .label e = $44
    // unsigned int e = yd>>1
    // [560] bitmap_line_xdyi::e#0 = bitmap_line_xdyi::yd#2 >> 1 -- vwuz1=vwuz2_ror_1 
    lda.z yd+1
    lsr
    sta.z e+1
    lda.z yd
    ror
    sta.z e
    // [561] phi from bitmap_line_xdyi bitmap_line_xdyi::@2 to bitmap_line_xdyi::@1 [phi:bitmap_line_xdyi/bitmap_line_xdyi::@2->bitmap_line_xdyi::@1]
    // [561] phi bitmap_line_xdyi::e#3 = bitmap_line_xdyi::e#0 [phi:bitmap_line_xdyi/bitmap_line_xdyi::@2->bitmap_line_xdyi::@1#0] -- register_copy 
    // [561] phi bitmap_line_xdyi::y#3 = bitmap_line_xdyi::y#5 [phi:bitmap_line_xdyi/bitmap_line_xdyi::@2->bitmap_line_xdyi::@1#1] -- register_copy 
    // [561] phi bitmap_line_xdyi::x#3 = bitmap_line_xdyi::x#6 [phi:bitmap_line_xdyi/bitmap_line_xdyi::@2->bitmap_line_xdyi::@1#2] -- register_copy 
    // bitmap_line_xdyi::@1
  __b1:
    // bitmap_plot(x,y,c)
    // [562] bitmap_plot::x#0 = bitmap_line_xdyi::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_plot.x
    lda.z x+1
    sta.z bitmap_plot.x+1
    // [563] bitmap_plot::y#0 = bitmap_line_xdyi::y#3 -- vwuz1=vwuz2 
    lda.z y
    sta.z bitmap_plot.y
    lda.z y+1
    sta.z bitmap_plot.y+1
    // [564] bitmap_plot::c#1 = bitmap_line_xdyi::c#3 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_plot.c
    // [565] call bitmap_plot
    // [657] phi from bitmap_line_xdyi::@1 to bitmap_plot [phi:bitmap_line_xdyi::@1->bitmap_plot]
    // [657] phi bitmap_plot::c#5 = bitmap_plot::c#1 [phi:bitmap_line_xdyi::@1->bitmap_plot#0] -- register_copy 
    // [657] phi bitmap_plot::y#4 = bitmap_plot::y#0 [phi:bitmap_line_xdyi::@1->bitmap_plot#1] -- register_copy 
    // [657] phi bitmap_plot::x#10 = bitmap_plot::x#0 [phi:bitmap_line_xdyi::@1->bitmap_plot#2] -- register_copy 
    jsr bitmap_plot
    // bitmap_line_xdyi::@4
    // x++;
    // [566] bitmap_line_xdyi::x#2 = ++ bitmap_line_xdyi::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // e = e+yd
    // [567] bitmap_line_xdyi::e#1 = bitmap_line_xdyi::e#3 + bitmap_line_xdyi::yd#2 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z e
    adc.z yd
    sta.z e
    lda.z e+1
    adc.z yd+1
    sta.z e+1
    // if(xd<e)
    // [568] if(bitmap_line_xdyi::xd#5>=bitmap_line_xdyi::e#1) goto bitmap_line_xdyi::@2 -- vwuz1_ge_vwuz2_then_la1 
    cmp.z xd+1
    bne !+
    lda.z e
    cmp.z xd
    beq __b2
  !:
    bcc __b2
    // bitmap_line_xdyi::@3
    // y++;
    // [569] bitmap_line_xdyi::y#2 = ++ bitmap_line_xdyi::y#3 -- vwuz1=_inc_vwuz1 
    inc.z y
    bne !+
    inc.z y+1
  !:
    // e = e - xd
    // [570] bitmap_line_xdyi::e#2 = bitmap_line_xdyi::e#1 - bitmap_line_xdyi::xd#5 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z e
    sec
    sbc.z xd
    sta.z e
    lda.z e+1
    sbc.z xd+1
    sta.z e+1
    // [571] phi from bitmap_line_xdyi::@3 bitmap_line_xdyi::@4 to bitmap_line_xdyi::@2 [phi:bitmap_line_xdyi::@3/bitmap_line_xdyi::@4->bitmap_line_xdyi::@2]
    // [571] phi bitmap_line_xdyi::e#6 = bitmap_line_xdyi::e#2 [phi:bitmap_line_xdyi::@3/bitmap_line_xdyi::@4->bitmap_line_xdyi::@2#0] -- register_copy 
    // [571] phi bitmap_line_xdyi::y#6 = bitmap_line_xdyi::y#2 [phi:bitmap_line_xdyi::@3/bitmap_line_xdyi::@4->bitmap_line_xdyi::@2#1] -- register_copy 
    // bitmap_line_xdyi::@2
  __b2:
    // x1+1
    // [572] bitmap_line_xdyi::$6 = bitmap_line_xdyi::x1#6 + 1 -- vwuz1=vwuz2_plus_1 
    clc
    lda.z x1
    adc #1
    sta.z __6
    lda.z x1+1
    adc #0
    sta.z __6+1
    // while (x!=(x1+1))
    // [573] if(bitmap_line_xdyi::x#2!=bitmap_line_xdyi::$6) goto bitmap_line_xdyi::@1 -- vwuz1_neq_vwuz2_then_la1 
    lda.z x+1
    cmp.z __6+1
    bne __b1
    lda.z x
    cmp.z __6
    bne __b1
    // bitmap_line_xdyi::@return
    // }
    // [574] return 
    rts
}
  // bitmap_line_ydxd
// void bitmap_line_ydxd(__zp($58) unsigned int y, __zp($54) unsigned int x, __zp($71) unsigned int y1, __zp($64) unsigned int yd, __zp($4c) unsigned int xd, __zp($5e) char c)
bitmap_line_ydxd: {
    .label __6 = $4a
    .label y = $58
    .label x = $54
    .label y1 = $71
    .label yd = $64
    .label xd = $4c
    .label c = $5e
    .label e = $48
    // unsigned int e = xd>>1
    // [576] bitmap_line_ydxd::e#0 = bitmap_line_ydxd::xd#2 >> 1 -- vwuz1=vwuz2_ror_1 
    lda.z xd+1
    lsr
    sta.z e+1
    lda.z xd
    ror
    sta.z e
    // [577] phi from bitmap_line_ydxd bitmap_line_ydxd::@2 to bitmap_line_ydxd::@1 [phi:bitmap_line_ydxd/bitmap_line_ydxd::@2->bitmap_line_ydxd::@1]
    // [577] phi bitmap_line_ydxd::e#3 = bitmap_line_ydxd::e#0 [phi:bitmap_line_ydxd/bitmap_line_ydxd::@2->bitmap_line_ydxd::@1#0] -- register_copy 
    // [577] phi bitmap_line_ydxd::y#2 = bitmap_line_ydxd::y#7 [phi:bitmap_line_ydxd/bitmap_line_ydxd::@2->bitmap_line_ydxd::@1#1] -- register_copy 
    // [577] phi bitmap_line_ydxd::x#3 = bitmap_line_ydxd::x#5 [phi:bitmap_line_ydxd/bitmap_line_ydxd::@2->bitmap_line_ydxd::@1#2] -- register_copy 
    // bitmap_line_ydxd::@1
  __b1:
    // bitmap_plot(x,y,c)
    // [578] bitmap_plot::x#3 = bitmap_line_ydxd::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_plot.x
    lda.z x+1
    sta.z bitmap_plot.x+1
    // [579] bitmap_plot::y#3 = bitmap_line_ydxd::y#2 -- vwuz1=vwuz2 
    lda.z y
    sta.z bitmap_plot.y
    lda.z y+1
    sta.z bitmap_plot.y+1
    // [580] bitmap_plot::c#4 = bitmap_line_ydxd::c#3 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_plot.c
    // [581] call bitmap_plot
    // [657] phi from bitmap_line_ydxd::@1 to bitmap_plot [phi:bitmap_line_ydxd::@1->bitmap_plot]
    // [657] phi bitmap_plot::c#5 = bitmap_plot::c#4 [phi:bitmap_line_ydxd::@1->bitmap_plot#0] -- register_copy 
    // [657] phi bitmap_plot::y#4 = bitmap_plot::y#3 [phi:bitmap_line_ydxd::@1->bitmap_plot#1] -- register_copy 
    // [657] phi bitmap_plot::x#10 = bitmap_plot::x#3 [phi:bitmap_line_ydxd::@1->bitmap_plot#2] -- register_copy 
    jsr bitmap_plot
    // bitmap_line_ydxd::@4
    // y = y++;
    // [582] bitmap_line_ydxd::y#3 = ++ bitmap_line_ydxd::y#2 -- vwuz1=_inc_vwuz1 
    inc.z y
    bne !+
    inc.z y+1
  !:
    // e = e+xd
    // [583] bitmap_line_ydxd::e#1 = bitmap_line_ydxd::e#3 + bitmap_line_ydxd::xd#2 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z e
    adc.z xd
    sta.z e
    lda.z e+1
    adc.z xd+1
    sta.z e+1
    // if(yd<e)
    // [584] if(bitmap_line_ydxd::yd#5>=bitmap_line_ydxd::e#1) goto bitmap_line_ydxd::@2 -- vwuz1_ge_vwuz2_then_la1 
    cmp.z yd+1
    bne !+
    lda.z e
    cmp.z yd
    beq __b2
  !:
    bcc __b2
    // bitmap_line_ydxd::@3
    // x--;
    // [585] bitmap_line_ydxd::x#2 = -- bitmap_line_ydxd::x#3 -- vwuz1=_dec_vwuz1 
    lda.z x
    bne !+
    dec.z x+1
  !:
    dec.z x
    // e = e - yd
    // [586] bitmap_line_ydxd::e#2 = bitmap_line_ydxd::e#1 - bitmap_line_ydxd::yd#5 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z e
    sec
    sbc.z yd
    sta.z e
    lda.z e+1
    sbc.z yd+1
    sta.z e+1
    // [587] phi from bitmap_line_ydxd::@3 bitmap_line_ydxd::@4 to bitmap_line_ydxd::@2 [phi:bitmap_line_ydxd::@3/bitmap_line_ydxd::@4->bitmap_line_ydxd::@2]
    // [587] phi bitmap_line_ydxd::e#6 = bitmap_line_ydxd::e#2 [phi:bitmap_line_ydxd::@3/bitmap_line_ydxd::@4->bitmap_line_ydxd::@2#0] -- register_copy 
    // [587] phi bitmap_line_ydxd::x#6 = bitmap_line_ydxd::x#2 [phi:bitmap_line_ydxd::@3/bitmap_line_ydxd::@4->bitmap_line_ydxd::@2#1] -- register_copy 
    // bitmap_line_ydxd::@2
  __b2:
    // y1+1
    // [588] bitmap_line_ydxd::$6 = bitmap_line_ydxd::y1#6 + 1 -- vwuz1=vwuz2_plus_1 
    clc
    lda.z y1
    adc #1
    sta.z __6
    lda.z y1+1
    adc #0
    sta.z __6+1
    // while (y!=(y1+1))
    // [589] if(bitmap_line_ydxd::y#3!=bitmap_line_ydxd::$6) goto bitmap_line_ydxd::@1 -- vwuz1_neq_vwuz2_then_la1 
    lda.z y+1
    cmp.z __6+1
    bne __b1
    lda.z y
    cmp.z __6
    bne __b1
    // bitmap_line_ydxd::@return
    // }
    // [590] return 
    rts
}
  // bitmap_line_xdyd
// void bitmap_line_xdyd(__zp($5c) unsigned int x, __zp($52) unsigned int y, __zp($6f) unsigned int x1, __zp($66) unsigned int xd, __zp($6d) unsigned int yd, __zp($33) char c)
bitmap_line_xdyd: {
    .label __6 = $4a
    .label x = $5c
    .label y = $52
    .label x1 = $6f
    .label xd = $66
    .label yd = $6d
    .label c = $33
    .label e = $46
    // unsigned int e = yd>>1
    // [592] bitmap_line_xdyd::e#0 = bitmap_line_xdyd::yd#2 >> 1 -- vwuz1=vwuz2_ror_1 
    lda.z yd+1
    lsr
    sta.z e+1
    lda.z yd
    ror
    sta.z e
    // [593] phi from bitmap_line_xdyd bitmap_line_xdyd::@2 to bitmap_line_xdyd::@1 [phi:bitmap_line_xdyd/bitmap_line_xdyd::@2->bitmap_line_xdyd::@1]
    // [593] phi bitmap_line_xdyd::e#3 = bitmap_line_xdyd::e#0 [phi:bitmap_line_xdyd/bitmap_line_xdyd::@2->bitmap_line_xdyd::@1#0] -- register_copy 
    // [593] phi bitmap_line_xdyd::y#3 = bitmap_line_xdyd::y#5 [phi:bitmap_line_xdyd/bitmap_line_xdyd::@2->bitmap_line_xdyd::@1#1] -- register_copy 
    // [593] phi bitmap_line_xdyd::x#3 = bitmap_line_xdyd::x#6 [phi:bitmap_line_xdyd/bitmap_line_xdyd::@2->bitmap_line_xdyd::@1#2] -- register_copy 
    // bitmap_line_xdyd::@1
  __b1:
    // bitmap_plot(x,y,c)
    // [594] bitmap_plot::x#1 = bitmap_line_xdyd::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_plot.x
    lda.z x+1
    sta.z bitmap_plot.x+1
    // [595] bitmap_plot::y#1 = bitmap_line_xdyd::y#3 -- vwuz1=vwuz2 
    lda.z y
    sta.z bitmap_plot.y
    lda.z y+1
    sta.z bitmap_plot.y+1
    // [596] bitmap_plot::c#2 = bitmap_line_xdyd::c#3 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_plot.c
    // [597] call bitmap_plot
    // [657] phi from bitmap_line_xdyd::@1 to bitmap_plot [phi:bitmap_line_xdyd::@1->bitmap_plot]
    // [657] phi bitmap_plot::c#5 = bitmap_plot::c#2 [phi:bitmap_line_xdyd::@1->bitmap_plot#0] -- register_copy 
    // [657] phi bitmap_plot::y#4 = bitmap_plot::y#1 [phi:bitmap_line_xdyd::@1->bitmap_plot#1] -- register_copy 
    // [657] phi bitmap_plot::x#10 = bitmap_plot::x#1 [phi:bitmap_line_xdyd::@1->bitmap_plot#2] -- register_copy 
    jsr bitmap_plot
    // bitmap_line_xdyd::@4
    // x++;
    // [598] bitmap_line_xdyd::x#2 = ++ bitmap_line_xdyd::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // e = e+yd
    // [599] bitmap_line_xdyd::e#1 = bitmap_line_xdyd::e#3 + bitmap_line_xdyd::yd#2 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z e
    adc.z yd
    sta.z e
    lda.z e+1
    adc.z yd+1
    sta.z e+1
    // if(xd<e)
    // [600] if(bitmap_line_xdyd::xd#5>=bitmap_line_xdyd::e#1) goto bitmap_line_xdyd::@2 -- vwuz1_ge_vwuz2_then_la1 
    cmp.z xd+1
    bne !+
    lda.z e
    cmp.z xd
    beq __b2
  !:
    bcc __b2
    // bitmap_line_xdyd::@3
    // y--;
    // [601] bitmap_line_xdyd::y#2 = -- bitmap_line_xdyd::y#3 -- vwuz1=_dec_vwuz1 
    lda.z y
    bne !+
    dec.z y+1
  !:
    dec.z y
    // e = e - xd
    // [602] bitmap_line_xdyd::e#2 = bitmap_line_xdyd::e#1 - bitmap_line_xdyd::xd#5 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z e
    sec
    sbc.z xd
    sta.z e
    lda.z e+1
    sbc.z xd+1
    sta.z e+1
    // [603] phi from bitmap_line_xdyd::@3 bitmap_line_xdyd::@4 to bitmap_line_xdyd::@2 [phi:bitmap_line_xdyd::@3/bitmap_line_xdyd::@4->bitmap_line_xdyd::@2]
    // [603] phi bitmap_line_xdyd::e#6 = bitmap_line_xdyd::e#2 [phi:bitmap_line_xdyd::@3/bitmap_line_xdyd::@4->bitmap_line_xdyd::@2#0] -- register_copy 
    // [603] phi bitmap_line_xdyd::y#6 = bitmap_line_xdyd::y#2 [phi:bitmap_line_xdyd::@3/bitmap_line_xdyd::@4->bitmap_line_xdyd::@2#1] -- register_copy 
    // bitmap_line_xdyd::@2
  __b2:
    // x1+1
    // [604] bitmap_line_xdyd::$6 = bitmap_line_xdyd::x1#6 + 1 -- vwuz1=vwuz2_plus_1 
    clc
    lda.z x1
    adc #1
    sta.z __6
    lda.z x1+1
    adc #0
    sta.z __6+1
    // while (x!=(x1+1))
    // [605] if(bitmap_line_xdyd::x#2!=bitmap_line_xdyd::$6) goto bitmap_line_xdyd::@1 -- vwuz1_neq_vwuz2_then_la1 
    lda.z x+1
    cmp.z __6+1
    bne __b1
    lda.z x
    cmp.z __6
    bne __b1
    // bitmap_line_xdyd::@return
    // }
    // [606] return 
    rts
}
  // divr16u
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp($56) unsigned int divr16u(__zp($74) unsigned int dividend, __zp($6a) unsigned int divisor, __zp($62) unsigned int rem)
divr16u: {
    .label __1 = $73
    .label __2 = $73
    .label rem = $62
    .label dividend = $74
    .label quotient = $56
    .label i = $5e
    .label return = $56
    .label divisor = $6a
    // [608] phi from divr16u to divr16u::@1 [phi:divr16u->divr16u::@1]
    // [608] phi divr16u::i#2 = 0 [phi:divr16u->divr16u::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // [608] phi divr16u::quotient#3 = 0 [phi:divr16u->divr16u::@1#1] -- vwuz1=vwuc1 
    sta.z quotient
    sta.z quotient+1
    // [608] phi divr16u::dividend#2 = divr16u::dividend#1 [phi:divr16u->divr16u::@1#2] -- register_copy 
    // [608] phi divr16u::rem#4 = 0 [phi:divr16u->divr16u::@1#3] -- vwuz1=vbuc1 
    sta.z rem
    sta.z rem+1
    // [608] phi from divr16u::@3 to divr16u::@1 [phi:divr16u::@3->divr16u::@1]
    // [608] phi divr16u::i#2 = divr16u::i#1 [phi:divr16u::@3->divr16u::@1#0] -- register_copy 
    // [608] phi divr16u::quotient#3 = divr16u::return#0 [phi:divr16u::@3->divr16u::@1#1] -- register_copy 
    // [608] phi divr16u::dividend#2 = divr16u::dividend#0 [phi:divr16u::@3->divr16u::@1#2] -- register_copy 
    // [608] phi divr16u::rem#4 = divr16u::rem#10 [phi:divr16u::@3->divr16u::@1#3] -- register_copy 
    // divr16u::@1
  __b1:
    // rem = rem << 1
    // [609] divr16u::rem#0 = divr16u::rem#4 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z rem
    rol.z rem+1
    // BYTE1(dividend)
    // [610] divr16u::$1 = byte1  divr16u::dividend#2 -- vbuz1=_byte1_vwuz2 
    lda.z dividend+1
    sta.z __1
    // BYTE1(dividend) & $80
    // [611] divr16u::$2 = divr16u::$1 & $80 -- vbuz1=vbuz1_band_vbuc1 
    lda #$80
    and.z __2
    sta.z __2
    // if( (BYTE1(dividend) & $80) != 0 )
    // [612] if(divr16u::$2==0) goto divr16u::@2 -- vbuz1_eq_0_then_la1 
    beq __b2
    // divr16u::@4
    // rem = rem | 1
    // [613] divr16u::rem#1 = divr16u::rem#0 | 1 -- vwuz1=vwuz1_bor_vbuc1 
    lda #1
    ora.z rem
    sta.z rem
    // [614] phi from divr16u::@1 divr16u::@4 to divr16u::@2 [phi:divr16u::@1/divr16u::@4->divr16u::@2]
    // [614] phi divr16u::rem#5 = divr16u::rem#0 [phi:divr16u::@1/divr16u::@4->divr16u::@2#0] -- register_copy 
    // divr16u::@2
  __b2:
    // dividend = dividend << 1
    // [615] divr16u::dividend#0 = divr16u::dividend#2 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z dividend
    rol.z dividend+1
    // quotient = quotient << 1
    // [616] divr16u::quotient#1 = divr16u::quotient#3 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z quotient
    rol.z quotient+1
    // if(rem>=divisor)
    // [617] if(divr16u::rem#5<divr16u::divisor#0) goto divr16u::@3 -- vwuz1_lt_vwuz2_then_la1 
    lda.z rem+1
    cmp.z divisor+1
    bcc __b3
    bne !+
    lda.z rem
    cmp.z divisor
    bcc __b3
  !:
    // divr16u::@5
    // quotient++;
    // [618] divr16u::quotient#2 = ++ divr16u::quotient#1 -- vwuz1=_inc_vwuz1 
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    // rem = rem - divisor
    // [619] divr16u::rem#2 = divr16u::rem#5 - divr16u::divisor#0 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z rem
    sec
    sbc.z divisor
    sta.z rem
    lda.z rem+1
    sbc.z divisor+1
    sta.z rem+1
    // [620] phi from divr16u::@2 divr16u::@5 to divr16u::@3 [phi:divr16u::@2/divr16u::@5->divr16u::@3]
    // [620] phi divr16u::return#0 = divr16u::quotient#1 [phi:divr16u::@2/divr16u::@5->divr16u::@3#0] -- register_copy 
    // [620] phi divr16u::rem#10 = divr16u::rem#5 [phi:divr16u::@2/divr16u::@5->divr16u::@3#1] -- register_copy 
    // divr16u::@3
  __b3:
    // for( char i : 0..15)
    // [621] divr16u::i#1 = ++ divr16u::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [622] if(divr16u::i#1!=$10) goto divr16u::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z i
    bne __b1
    // divr16u::@6
    // rem16u = rem
    // [623] rem16u#0 = divr16u::rem#10 -- vwuz1=vwuz2 
    lda.z rem
    sta.z rem16u
    lda.z rem+1
    sta.z rem16u+1
    // divr16u::@return
    // }
    // [624] return 
    rts
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label __3 = $36
    .label cy = $5e
    .label width = $3d
    .label line = $2c
    .label start = $2c
    .label i = $33
    // unsigned char cy = __conio.cursor_y
    // [625] insertup::cy#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    sta.z cy
    // unsigned char width = __conio.width * 2
    // [626] insertup::width#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    asl
    sta.z width
    // [627] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [627] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z i
    // insertup::@1
  __b1:
    // for(unsigned char i=1; i<=cy; i++)
    // [628] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuz1_le_vbuz2_then_la1 
    lda.z cy
    cmp.z i
    bcs __b2
    // [629] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [630] call clearline
    jsr clearline
    // insertup::@return
    // }
    // [631] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [632] insertup::$3 = insertup::i#2 - 1 -- vbuz1=vbuz2_minus_1 
    ldx.z i
    dex
    stx.z __3
    // unsigned int line = (i-1) << __conio.rowshift
    // [633] insertup::line#0 = insertup::$3 << *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) -- vwuz1=vbuz2_rol__deref_pbuc1 
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
    // [634] insertup::start#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) + insertup::line#0 -- vwuz1=_deref_pwuc1_plus_vwuz1 
    clc
    lda.z start
    adc __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z start
    lda.z start+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z start+1
    // memcpy_vram_vram_inc(0, start, VERA_INC_1, 0, start+__conio.rowskip, VERA_INC_1, width)
    // [635] memcpy_vram_vram_inc::soffset_vram#0 = insertup::start#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwuz1=vwuz2_plus__deref_pwuc1 
    lda.z start
    clc
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta.z memcpy_vram_vram_inc.soffset_vram
    lda.z start+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta.z memcpy_vram_vram_inc.soffset_vram+1
    // [636] memcpy_vram_vram_inc::doffset_vram#0 = insertup::start#0
    // [637] memcpy_vram_vram_inc::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z memcpy_vram_vram_inc.num
    lda #0
    sta.z memcpy_vram_vram_inc.num+1
    // [638] call memcpy_vram_vram_inc
    // [684] phi from insertup::@2 to memcpy_vram_vram_inc [phi:insertup::@2->memcpy_vram_vram_inc]
    jsr memcpy_vram_vram_inc
    // insertup::@4
    // for(unsigned char i=1; i<=cy; i++)
    // [639] insertup::i#1 = ++ insertup::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [627] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [627] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
}
  // clearline
clearline: {
    .label __1 = $29
    .label __2 = $2a
    .label mapbase_offset = $31
    .label conio_line = $24
    .label addr = $31
    .label color = $28
    .label c = $26
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [640] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // unsigned int mapbase_offset =  (unsigned int)__conio.mapbase_offset
    // [641] clearline::mapbase_offset#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwuz1=_deref_pwuc1 
    // Set address
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z mapbase_offset
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z mapbase_offset+1
    // unsigned int conio_line = __conio.line
    // [642] clearline::conio_line#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta.z conio_line
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    sta.z conio_line+1
    // mapbase_offset + conio_line
    // [643] clearline::addr#0 = clearline::mapbase_offset#0 + clearline::conio_line#0 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z addr
    adc.z conio_line
    sta.z addr
    lda.z addr+1
    adc.z conio_line+1
    sta.z addr+1
    // BYTE0(addr)
    // [644] clearline::$1 = byte0  (char *)clearline::addr#0 -- vbuz1=_byte0_pbuz2 
    lda.z addr
    sta.z __1
    // *VERA_ADDRX_L = BYTE0(addr)
    // [645] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(addr)
    // [646] clearline::$2 = byte1  (char *)clearline::addr#0 -- vbuz1=_byte1_pbuz2 
    lda.z addr+1
    sta.z __2
    // *VERA_ADDRX_M = BYTE1(addr)
    // [647] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [648] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // char color = __conio.color
    // [649] clearline::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbuz1=_deref_pbuc1 
    // TODO need to check this!
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z color
    // [650] phi from clearline to clearline::@1 [phi:clearline->clearline::@1]
    // [650] phi clearline::c#2 = 0 [phi:clearline->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<__conio.width; c++ )
    // [651] if(clearline::c#2<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto clearline::@2 -- vwuz1_lt__deref_pbuc1_then_la1 
    lda.z c+1
    bne !+
    lda.z c
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    bcc __b2
  !:
    // clearline::@3
    // __conio.cursor_x = 0
    // [652] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // clearline::@return
    // }
    // [653] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [654] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [655] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( unsigned int c=0;c<__conio.width; c++ )
    // [656] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [650] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [650] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
    jmp __b1
}
  // bitmap_plot
// void bitmap_plot(__zp($34) unsigned int x, __zp($2f) unsigned int y, __zp($2e) char c)
bitmap_plot: {
    .label __3 = $2e
    .label __6 = $28
    .label __7 = $28
    .label __8 = $2e
    .label __9 = $2c
    .label __10 = $2f
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1___0 = $29
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1___1 = $2a
    .label plot_x = $3e
    .label plot_y = $37
    .label bitshift = $3d
    .label c = $2e
    .label vera_vram_data0_address1_bankaddr = $3e
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank = $36
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset = $42
    .label x = $34
    .label y = $2f
    .label __12 = $2c
    .label __13 = $2f
    .label __14 = $3b
    .label __15 = $34
    // unsigned long plot_x = __bitmap.plot_x[x]
    // [658] bitmap_plot::$9 = bitmap_plot::x#10 << 1 -- vwuz1=vwuz2_rol_1 
    lda.z x
    asl
    sta.z __9
    lda.z x+1
    rol
    sta.z __9+1
    // [659] bitmap_plot::$12 = (unsigned int *)&__bitmap + bitmap_plot::$9 -- pwuz1=pwuc1_plus_vwuz1 
    lda.z __12
    clc
    adc #<__bitmap
    sta.z __12
    lda.z __12+1
    adc #>__bitmap
    sta.z __12+1
    // [660] bitmap_plot::plot_x#0 = (unsigned long)*bitmap_plot::$12 -- vduz1=_dword__deref_pwuz2 
    // Needs unsigned int arrays arranged as two underlying char arrays to allow char* plotter_x = plot_x[x]; - and eventually - char* plotter = plot_x[x] + plot_y[y];
    ldy #0
    sty.z plot_x+2
    sty.z plot_x+3
    lda (__12),y
    sta.z plot_x
    iny
    lda (__12),y
    sta.z plot_x+1
    // unsigned long plot_y = __bitmap.plot_y[y]
    // [661] bitmap_plot::$10 = bitmap_plot::y#4 << 2 -- vwuz1=vwuz1_rol_2 
    asl.z __10
    rol.z __10+1
    asl.z __10
    rol.z __10+1
    // [662] bitmap_plot::$13 = (unsigned long *)&__bitmap+$500 + bitmap_plot::$10 -- pduz1=pduc1_plus_vwuz1 
    lda.z __13
    clc
    adc #<__bitmap+$500
    sta.z __13
    lda.z __13+1
    adc #>__bitmap+$500
    sta.z __13+1
    // [663] bitmap_plot::plot_y#0 = *bitmap_plot::$13 -- vduz1=_deref_pduz2 
    ldy #0
    lda (__13),y
    sta.z plot_y
    iny
    lda (__13),y
    sta.z plot_y+1
    iny
    lda (__13),y
    sta.z plot_y+2
    iny
    lda (__13),y
    sta.z plot_y+3
    // unsigned long plotter = plot_x+plot_y
    // [664] bitmap_plot::vera_vram_data0_address1_bankaddr#0 = bitmap_plot::plot_x#0 + bitmap_plot::plot_y#0 -- vduz1=vduz1_plus_vduz2 
    clc
    lda.z vera_vram_data0_address1_bankaddr
    adc.z plot_y
    sta.z vera_vram_data0_address1_bankaddr
    lda.z vera_vram_data0_address1_bankaddr+1
    adc.z plot_y+1
    sta.z vera_vram_data0_address1_bankaddr+1
    lda.z vera_vram_data0_address1_bankaddr+2
    adc.z plot_y+2
    sta.z vera_vram_data0_address1_bankaddr+2
    lda.z vera_vram_data0_address1_bankaddr+3
    adc.z plot_y+3
    sta.z vera_vram_data0_address1_bankaddr+3
    // unsigned char bitshift = __bitmap.plot_bitshift[x]
    // [665] bitmap_plot::$14 = (char *)&__bitmap+$f00 + bitmap_plot::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap+$f00
    sta.z __14
    lda.z x+1
    adc #>__bitmap+$f00
    sta.z __14+1
    // [666] bitmap_plot::bitshift#0 = *bitmap_plot::$14 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (__14),y
    sta.z bitshift
    // bitshift?c<<(bitshift):c
    // [667] if(0!=bitmap_plot::bitshift#0) goto bitmap_plot::@1 -- 0_neq_vbuz1_then_la1 
    bne __b1
    // [669] phi from bitmap_plot bitmap_plot::@1 to bitmap_plot::@2 [phi:bitmap_plot/bitmap_plot::@1->bitmap_plot::@2]
    // [669] phi bitmap_plot::c#0 = bitmap_plot::c#5 [phi:bitmap_plot/bitmap_plot::@1->bitmap_plot::@2#0] -- register_copy 
    jmp __b2
    // bitmap_plot::@1
  __b1:
    // [668] bitmap_plot::$3 = bitmap_plot::c#5 << bitmap_plot::bitshift#0 -- vbuz1=vbuz1_rol_vbuz2 
    lda.z __3
    ldy.z bitshift
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta.z __3
    // bitmap_plot::@2
  __b2:
    // bitmap_plot::vera_vram_data0_address1
    // vera_vram_data0_bank_offset( BYTE2(bankaddr), WORD0(bankaddr), inc_dec )
    // [670] bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank#0 = byte2  bitmap_plot::vera_vram_data0_address1_bankaddr#0 -- vbuz1=_byte2_vduz2 
    lda.z vera_vram_data0_address1_bankaddr+2
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank
    // [671] bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 = word0  bitmap_plot::vera_vram_data0_address1_bankaddr#0 -- vwuz1=_word0_vduz2 
    lda.z vera_vram_data0_address1_bankaddr
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset
    lda.z vera_vram_data0_address1_bankaddr+1
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset+1
    // bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [672] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [673] bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$0 = byte0  bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 -- vbuz1=_byte0_vwuz2 
    lda.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [674] *VERA_ADDRX_L = bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [675] bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$1 = byte1  bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 -- vbuz1=_byte1_vwuz2 
    lda.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset+1
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [676] *VERA_ADDRX_M = bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [677] *VERA_ADDRX_H = bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuz1 
    lda.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // bitmap_plot::@3
    // ~__bitmap.plot_bitmask[x]
    // [678] bitmap_plot::$15 = (char *)&__bitmap+$c80 + bitmap_plot::x#10 -- pbuz1=pbuc1_plus_vwuz1 
    lda.z __15
    clc
    adc #<__bitmap+$c80
    sta.z __15
    lda.z __15+1
    adc #>__bitmap+$c80
    sta.z __15+1
    // [679] bitmap_plot::$6 = ~ *bitmap_plot::$15 -- vbuz1=_bnot__deref_pbuz2 
    ldy #0
    lda (__15),y
    eor #$ff
    sta.z __6
    // *VERA_DATA0 & ~__bitmap.plot_bitmask[x]
    // [680] bitmap_plot::$7 = *VERA_DATA0 & bitmap_plot::$6 -- vbuz1=_deref_pbuc1_band_vbuz1 
    lda VERA_DATA0
    and.z __7
    sta.z __7
    // (*VERA_DATA0 & ~__bitmap.plot_bitmask[x]) | c
    // [681] bitmap_plot::$8 = bitmap_plot::$7 | bitmap_plot::c#0 -- vbuz1=vbuz2_bor_vbuz1 
    lda.z __8
    ora.z __7
    sta.z __8
    // *VERA_DATA0 = (*VERA_DATA0 & ~__bitmap.plot_bitmask[x]) | c
    // [682] *VERA_DATA0 = bitmap_plot::$8 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // bitmap_plot::@return
    // }
    // [683] return 
    rts
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
// void memcpy_vram_vram_inc(char dbank_vram, __zp($2c) unsigned int doffset_vram, char dinc, char sbank_vram, __zp($31) unsigned int soffset_vram, char sinc, __zp($24) unsigned int num)
memcpy_vram_vram_inc: {
    .label vera_vram_data0_bank_offset1___0 = $29
    .label vera_vram_data0_bank_offset1___1 = $2a
    .label vera_vram_data1_bank_offset1___0 = $28
    .label vera_vram_data1_bank_offset1___1 = $2b
    .label i = $22
    .label doffset_vram = $2c
    .label soffset_vram = $31
    .label num = $24
    // memcpy_vram_vram_inc::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [685] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [686] memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$0 = byte0  memcpy_vram_vram_inc::soffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z soffset_vram
    sta.z vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [687] *VERA_ADDRX_L = memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [688] memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$1 = byte1  memcpy_vram_vram_inc::soffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z soffset_vram+1
    sta.z vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [689] *VERA_ADDRX_M = memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [690] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // memcpy_vram_vram_inc::vera_vram_data1_bank_offset1
    // *VERA_CTRL |= VERA_ADDRSEL
    // [691] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [692] memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$0 = byte0  memcpy_vram_vram_inc::doffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z doffset_vram
    sta.z vera_vram_data1_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [693] *VERA_ADDRX_L = memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [694] memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$1 = byte1  memcpy_vram_vram_inc::doffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z doffset_vram+1
    sta.z vera_vram_data1_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [695] *VERA_ADDRX_M = memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [696] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // [697] phi from memcpy_vram_vram_inc::vera_vram_data1_bank_offset1 to memcpy_vram_vram_inc::@1 [phi:memcpy_vram_vram_inc::vera_vram_data1_bank_offset1->memcpy_vram_vram_inc::@1]
    // [697] phi memcpy_vram_vram_inc::i#2 = 0 [phi:memcpy_vram_vram_inc::vera_vram_data1_bank_offset1->memcpy_vram_vram_inc::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // memcpy_vram_vram_inc::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [698] if(memcpy_vram_vram_inc::i#2<memcpy_vram_vram_inc::num#0) goto memcpy_vram_vram_inc::@2 -- vwuz1_lt_vwuz2_then_la1 
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
    // [699] return 
    rts
    // memcpy_vram_vram_inc::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [700] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [701] memcpy_vram_vram_inc::i#1 = ++ memcpy_vram_vram_inc::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [697] phi from memcpy_vram_vram_inc::@2 to memcpy_vram_vram_inc::@1 [phi:memcpy_vram_vram_inc::@2->memcpy_vram_vram_inc::@1]
    // [697] phi memcpy_vram_vram_inc::i#2 = memcpy_vram_vram_inc::i#1 [phi:memcpy_vram_vram_inc::@2->memcpy_vram_vram_inc::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment Data
  VERA_LAYER_WIDTH: .word $20, $40, $80, $100
  VERA_LAYER_HEIGHT: .word $20, $40, $80, $100
  VERA_LAYER_SKIP: .word $40, $80, $100, $200
  hdeltas: .word 0, $50, $28, $14, 0, $a0, $50, $28, 0, $140, $a0, $50, 0, $280, $140, $a0
  vdeltas: .word 0, $1e0, $f0, $a0
  bitmasks: .byte $80, $c0, $f0, $ff
  .fill 1, 0
  bitshifts: .byte 7, 6, 4, 0
  .fill 1, 0
  __conio: .fill SIZEOF_STRUCT_CX16_CONIO, 0
  __bitmap: .fill SIZEOF_STRUCT___0, 0
