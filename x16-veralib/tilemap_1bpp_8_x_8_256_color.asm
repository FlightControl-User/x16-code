  // File Comments
// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="tilemap_1bpp_8_x_8_256_color.prg", type="prg", segments="Program"]
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
  .const VERA_INC_1 = $10
  .const VERA_DCSEL = 2
  .const VERA_ADDRSEL = 1
  .const VERA_LAYER1_ENABLE = $20
  .const VERA_LAYER0_ENABLE = $10
  .const VERA_LAYER_WIDTH_128 = $20
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_64 = $40
  .const VERA_LAYER_HEIGHT_MASK = $c0
  .const VERA_LAYER_COLOR_DEPTH_MASK = 3
  .const VERA_LAYER_CONFIG_256C = 8
  .const VERA_TILEBASE_WIDTH_MASK = 1
  .const VERA_TILEBASE_HEIGHT_MASK = 2
  .const VERA_LAYER_TILEBASE_MASK = $fc
  ///< Load a logical file.
  .const CBM_PLOT = $fff0
  .const OFFSET_STRUCT_CX16_CONIO_WIDTH = 4
  .const OFFSET_STRUCT_CX16_CONIO_HEIGHT = 5
  .const OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK = 3
  .const OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET = 1
  .const OFFSET_STRUCT_CX16_CONIO_MAPWIDTH = 6
  .const OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT = 8
  .const OFFSET_STRUCT_CX16_CONIO_ROWSHIFT = $a
  .const OFFSET_STRUCT_CX16_CONIO_ROWSKIP = $b
  .const OFFSET_STRUCT_CX16_CONIO_CURSOR_X = $f
  .const OFFSET_STRUCT_CX16_CONIO_CURSOR_Y = $10
  .const OFFSET_STRUCT_CX16_CONIO_COLOR = $e
  .const OFFSET_STRUCT_CX16_CONIO_LINE = $11
  .const OFFSET_STRUCT_CX16_CONIO_SCROLL = $13
  .const OFFSET_STRUCT_CX16_CONIO_CURSOR = $d
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_CX16_CONIO = $15
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
  /// $9F2E	L0_MAPBASE	    Layer 0 Map Base Address (16:9)
  .label VERA_L0_MAPBASE = $9f2e
  /// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L0_TILEBASE = $9f2f
  /// $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  /// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  /// $9F36	L1_TILEBASE	    Layer 1 Tile Base
  /// Bit 2-7: Tile Base Address (16:11)
  /// Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  /// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L1_TILEBASE = $9f36
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
    .label __8 = $43
    .label __9 = $34
    .label __10 = $43
    .label __11 = $50
    .label line = $35
    // char line = *BASIC_CURSOR_LINE
    // [6] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda.z BASIC_CURSOR_LINE
    sta.z line
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
    // [162] phi from conio_x16_init::@4 to textcolor [phi:conio_x16_init::@4->textcolor]
    // [162] phi textcolor::color#5 = WHITE [phi:conio_x16_init::@4->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [12] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // bgcolor(BLUE)
    // [13] call bgcolor
    // [167] phi from conio_x16_init::@5 to bgcolor [phi:conio_x16_init::@5->bgcolor]
    // [167] phi bgcolor::color#4 = BLUE [phi:conio_x16_init::@5->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLUE
    sta.z bgcolor.color
    jsr bgcolor
    // [14] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // cursor(0)
    // [15] call cursor
    jsr cursor
    // conio_x16_init::@7
    // if(line>=__conio.height)
    // [16] if(conio_x16_init::line#0<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto conio_x16_init::@1 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z line
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    // [17] phi from conio_x16_init::@7 to conio_x16_init::@2 [phi:conio_x16_init::@7->conio_x16_init::@2]
    // conio_x16_init::@2
    // [18] phi from conio_x16_init::@2 conio_x16_init::@7 to conio_x16_init::@1 [phi:conio_x16_init::@2/conio_x16_init::@7->conio_x16_init::@1]
    // conio_x16_init::@1
    // cbm_k_plot_get()
    // [19] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [20] cbm_k_plot_get::return#4 = cbm_k_plot_get::return#0
    // conio_x16_init::@8
    // [21] conio_x16_init::$8 = cbm_k_plot_get::return#4
    // BYTE1(cbm_k_plot_get())
    // [22] conio_x16_init::$9 = byte1  conio_x16_init::$8 -- vbuz1=_byte1_vwuz2 
    lda.z __8+1
    sta.z __9
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [23] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = conio_x16_init::$9 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // cbm_k_plot_get()
    // [24] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [25] cbm_k_plot_get::return#10 = cbm_k_plot_get::return#0
    // conio_x16_init::@9
    // [26] conio_x16_init::$10 = cbm_k_plot_get::return#10
    // BYTE0(cbm_k_plot_get())
    // [27] conio_x16_init::$11 = byte0  conio_x16_init::$10 -- vbuz1=_byte0_vwuz2 
    lda.z __10
    sta.z __11
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [28] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = conio_x16_init::$11 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // gotoxy(__conio.cursor_x, __conio.cursor_y)
    // [29] gotoxy::x#1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    sta.z gotoxy.x
    // [30] gotoxy::y#1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    sta.z gotoxy.y
    // [31] call gotoxy
    // [180] phi from conio_x16_init::@9 to gotoxy [phi:conio_x16_init::@9->gotoxy]
    // [180] phi gotoxy::x#5 = gotoxy::x#1 [phi:conio_x16_init::@9->gotoxy#0] -- register_copy 
    // [180] phi gotoxy::y#5 = gotoxy::y#1 [phi:conio_x16_init::@9->gotoxy#1] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [32] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__zp($3d) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    .label __1 = $36
    .label __3 = $37
    .label __4 = $38
    .label __5 = $39
    .label __14 = $3b
    .label c = $3d
    .label color = $2e
    .label mapbase_offset = $22
    .label mapwidth = $40
    .label conio_addr = $22
    .label scroll_enable = $3a
    // [33] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbuz1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta.z c
    // char color = __conio.color
    // [34] cputc::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z color
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [35] cputc::mapbase_offset#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z mapbase_offset
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z mapbase_offset+1
    // unsigned int mapwidth = __conio.mapwidth
    // [36] cputc::mapwidth#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    sta.z mapwidth
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    sta.z mapwidth+1
    // unsigned int conio_addr = mapbase_offset + __conio.line
    // [37] cputc::conio_addr#0 = cputc::mapbase_offset#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z conio_addr
    adc __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta.z conio_addr
    lda.z conio_addr+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    sta.z conio_addr+1
    // __conio.cursor_x << 1
    // [38] cputc::$1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    asl
    sta.z __1
    // conio_addr += __conio.cursor_x << 1
    // [39] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$1 -- vwuz1=vwuz1_plus_vbuz2 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [40] if(cputc::c#0==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [41] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(conio_addr)
    // [42] cputc::$3 = byte0  cputc::conio_addr#1 -- vbuz1=_byte0_vwuz2 
    lda.z conio_addr
    sta.z __3
    // *VERA_ADDRX_L = BYTE0(conio_addr)
    // [43] *VERA_ADDRX_L = cputc::$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(conio_addr)
    // [44] cputc::$4 = byte1  cputc::conio_addr#1 -- vbuz1=_byte1_vwuz2 
    lda.z conio_addr+1
    sta.z __4
    // *VERA_ADDRX_M = BYTE1(conio_addr)
    // [45] *VERA_ADDRX_M = cputc::$4 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [46] cputc::$5 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    sta.z __5
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [47] *VERA_ADDRX_H = cputc::$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [48] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [49] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // __conio.cursor_x++;
    // [50] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = ++ *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // unsigned char scroll_enable = __conio.scroll[__conio.layer]
    // [51] cputc::scroll_enable#0 = ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_SCROLL)[*((char *)&__conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_SCROLL,y
    sta.z scroll_enable
    // if(scroll_enable)
    // [52] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuz1_then_la1 
    bne __b5
    // cputc::@3
    // (unsigned int)__conio.cursor_x == mapwidth
    // [53] cputc::$14 = (unsigned int)*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) -- vwuz1=_word__deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    sta.z __14
    lda #0
    sta.z __14+1
    // if((unsigned int)__conio.cursor_x == mapwidth)
    // [54] if(cputc::$14!=cputc::mapwidth#0) goto cputc::@return -- vwuz1_neq_vwuz2_then_la1 
    cmp.z mapwidth+1
    bne __breturn
    lda.z __14
    cmp.z mapwidth
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
}
  // main
main: {
    .label __26 = $2e
    .label c = $4d
    // vera_layers_reset()
    // [64] call vera_layers_reset
    // [200] phi from main to vera_layers_reset [phi:main->vera_layers_reset]
    jsr vera_layers_reset
    // [65] phi from main to main::@5 [phi:main->main::@5]
    // main::@5
    // vera_layer0_mode_text( 
    //         0, 0x0000, 
    //         1, 0xF000, 
    //         VERA_LAYER_WIDTH_128, VERA_LAYER_HEIGHT_64,
    //         VERA_TILEBASE_WIDTH_8, VERA_TILEBASE_HEIGHT_8, 
    //         VERA_LAYER_CONFIG_256C 
    //     )
    // [66] call vera_layer0_mode_text
  // Configure the VERA card to work in text, 256 mode.
  // The color mode is here 256 colors, (256 foreground on a black transparent background).
    // [209] phi from main::@5 to vera_layer0_mode_text [phi:main::@5->vera_layer0_mode_text]
    jsr vera_layer0_mode_text
    // [67] phi from main::@5 to main::@6 [phi:main::@5->main::@6]
    // main::@6
    // screenlayer0()
    // [68] call screenlayer0
    jsr screenlayer0
    // [69] phi from main::@6 to main::@7 [phi:main::@6->main::@7]
    // main::@7
    // textcolor(WHITE)
    // [70] call textcolor
    // [162] phi from main::@7 to textcolor [phi:main::@7->textcolor]
    // [162] phi textcolor::color#5 = WHITE [phi:main::@7->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [71] phi from main::@7 to main::@8 [phi:main::@7->main::@8]
    // main::@8
    // bgcolor(BLACK)
    // [72] call bgcolor
    // [167] phi from main::@8 to bgcolor [phi:main::@8->bgcolor]
    // [167] phi bgcolor::color#4 = BLACK [phi:main::@8->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [73] phi from main::@8 to main::@9 [phi:main::@8->main::@9]
    // main::@9
    // clrscr()
    // [74] call clrscr
    jsr clrscr
    // [75] phi from main::@9 to main::@1 [phi:main::@9->main::@1]
    // [75] phi main::c#2 = 0 [phi:main::@9->main::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
  // or you can use the below statement, but that includes setting a "mode", including
  // layer, map base address, tile base address, map width, map height, tile width, tile height, color mode.
  //vera_layer_mode_text(1, 0x00000, 0x0F800, 128, 128, 8, 8, 256);
    // [75] phi from main::@11 to main::@1 [phi:main::@11->main::@1]
    // [75] phi main::c#2 = main::c#1 [phi:main::@11->main::@1#0] -- register_copy 
    // main::@1
  __b1:
    // textcolor(c)
    // [76] textcolor::color#2 = main::c#2 -- vbuz1=vbuz2 
    lda.z c
    sta.z textcolor.color
    // [77] call textcolor
    // [162] phi from main::@1 to textcolor [phi:main::@1->textcolor]
    // [162] phi textcolor::color#5 = textcolor::color#2 [phi:main::@1->textcolor#0] -- register_copy 
    jsr textcolor
    // [78] phi from main::@1 to main::@10 [phi:main::@1->main::@10]
    // main::@10
    // printf(" ****** ")
    // [79] call printf_str
    // [261] phi from main::@10 to printf_str [phi:main::@10->printf_str]
    // [261] phi printf_str::s#9 = main::s [phi:main::@10->printf_str#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // main::@11
    // for(byte c:0..255)
    // [80] main::c#1 = ++ main::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [81] if(main::c#1!=0) goto main::@1 -- vbuz1_neq_0_then_la1 
    lda.z c
    bne __b1
    // main::vera_layer0_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [82] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_LAYER0_ENABLE
    // [83] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_LAYER0_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER0_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [84] phi from main::vera_layer0_show1 to main::@4 [phi:main::vera_layer0_show1->main::@4]
    // main::@4
    // screenlayer1()
    // [85] call screenlayer1
    jsr screenlayer1
    // [86] phi from main::@4 to main::@12 [phi:main::@4->main::@12]
    // main::@12
    // textcolor(WHITE)
    // [87] call textcolor
    // [162] phi from main::@12 to textcolor [phi:main::@12->textcolor]
    // [162] phi textcolor::color#5 = WHITE [phi:main::@12->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [88] phi from main::@12 to main::@13 [phi:main::@12->main::@13]
    // main::@13
    // bgcolor(BLACK)
    // [89] call bgcolor
    // [167] phi from main::@13 to bgcolor [phi:main::@13->bgcolor]
    // [167] phi bgcolor::color#4 = BLACK [phi:main::@13->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [90] phi from main::@13 to main::@14 [phi:main::@13->main::@14]
    // main::@14
    // clrscr()
    // [91] call clrscr
    jsr clrscr
    // [92] phi from main::@14 to main::@15 [phi:main::@14->main::@15]
    // main::@15
    // gotoxy(0,50)
    // [93] call gotoxy
    // [180] phi from main::@15 to gotoxy [phi:main::@15->gotoxy]
    // [180] phi gotoxy::x#5 = 0 [phi:main::@15->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [180] phi gotoxy::y#5 = $32 [phi:main::@15->gotoxy#1] -- vbuz1=vbuc1 
    lda #$32
    sta.z gotoxy.y
    jsr gotoxy
    // [94] phi from main::@15 to main::@16 [phi:main::@15->main::@16]
    // main::@16
    // printf("vera in text mode 8 x 8, color depth 1 bits per pixel.\n")
    // [95] call printf_str
    // [261] phi from main::@16 to printf_str [phi:main::@16->printf_str]
    // [261] phi printf_str::s#9 = main::s1 [phi:main::@16->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [96] phi from main::@16 to main::@17 [phi:main::@16->main::@17]
    // main::@17
    // printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n")
    // [97] call printf_str
    // [261] phi from main::@17 to printf_str [phi:main::@17->printf_str]
    // [261] phi printf_str::s#9 = main::s2 [phi:main::@17->printf_str#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // [98] phi from main::@17 to main::@18 [phi:main::@17->main::@18]
    // main::@18
    // printf("each character can have a variation of 256 foreground colors.\n")
    // [99] call printf_str
    // [261] phi from main::@18 to printf_str [phi:main::@18->printf_str]
    // [261] phi printf_str::s#9 = main::s3 [phi:main::@18->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // [100] phi from main::@18 to main::@19 [phi:main::@18->main::@19]
    // main::@19
    // printf("here we display 6 stars (******) each with a different color.\n")
    // [101] call printf_str
    // [261] phi from main::@19 to printf_str [phi:main::@19->printf_str]
    // [261] phi printf_str::s#9 = main::s4 [phi:main::@19->printf_str#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // [102] phi from main::@19 to main::@20 [phi:main::@19->main::@20]
    // main::@20
    // printf("however, the first color will always be transparent (black).\n")
    // [103] call printf_str
    // [261] phi from main::@20 to printf_str [phi:main::@20->printf_str]
    // [261] phi printf_str::s#9 = main::s5 [phi:main::@20->printf_str#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // [104] phi from main::@20 to main::@21 [phi:main::@20->main::@21]
    // main::@21
    // printf("in this mode, the background color cannot be set and is always transparent.\n")
    // [105] call printf_str
    // [261] phi from main::@21 to printf_str [phi:main::@21->printf_str]
    // [261] phi printf_str::s#9 = main::s6 [phi:main::@21->printf_str#0] -- pbuz1=pbuc1 
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    jsr printf_str
    // main::vera_layer1_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [106] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_LAYER1_ENABLE
    // [107] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_LAYER1_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER1_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [108] phi from main::@22 main::vera_layer1_show1 to main::@2 [phi:main::@22/main::vera_layer1_show1->main::@2]
    // main::@2
  __b2:
    // getin()
    // [109] call getin
    jsr getin
    // [110] getin::return#2 = getin::return#1
    // main::@22
    // [111] main::$26 = getin::return#2
    // while(!getin())
    // [112] if(0==main::$26) goto main::@2 -- 0_eq_vbuz1_then_la1 
    lda.z __26
    beq __b2
    // [113] phi from main::@22 to main::@3 [phi:main::@22->main::@3]
    // main::@3
    // vera_layers_reset()
    // [114] call vera_layers_reset
    // [200] phi from main::@3 to vera_layers_reset [phi:main::@3->vera_layers_reset]
    jsr vera_layers_reset
    // [115] phi from main::@3 to main::@23 [phi:main::@3->main::@23]
    // main::@23
    // textcolor(WHITE)
    // [116] call textcolor
    // [162] phi from main::@23 to textcolor [phi:main::@23->textcolor]
    // [162] phi textcolor::color#5 = WHITE [phi:main::@23->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [117] phi from main::@23 to main::@24 [phi:main::@23->main::@24]
    // main::@24
    // bgcolor(BLUE)
    // [118] call bgcolor
    // [167] phi from main::@24 to bgcolor [phi:main::@24->bgcolor]
    // [167] phi bgcolor::color#4 = BLUE [phi:main::@24->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLUE
    sta.z bgcolor.color
    jsr bgcolor
    // [119] phi from main::@24 to main::@25 [phi:main::@24->main::@25]
    // main::@25
    // clrscr()
    // [120] call clrscr
    jsr clrscr
    // main::@return
    // }
    // [121] return 
    rts
  .segment Data
    s: .text " ****** "
    .byte 0
    s1: .text @"vera in text mode 8 x 8, color depth 1 bits per pixel.\n"
    .byte 0
    s2: .text @"in this mode, tiles are 8 pixels wide and 8 pixels tall.\n"
    .byte 0
    s3: .text @"each character can have a variation of 256 foreground colors.\n"
    .byte 0
    s4: .text @"here we display 6 stars (******) each with a different color.\n"
    .byte 0
    s5: .text @"however, the first color will always be transparent (black).\n"
    .byte 0
    s6: .text @"in this mode, the background color cannot be set and is always transparent.\n"
    .byte 0
}
.segment Code
  // screensize
// Return the current screen size.
// void screensize(char *x, char *y)
screensize: {
    .label x = __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    .label y = __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    .label __1 = $48
    .label __3 = $49
    .label hscale = $48
    .label vscale = $49
    // char hscale = (*VERA_DC_HSCALE) >> 7
    // [122] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
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
    // [123] screensize::$1 = $28 << screensize::hscale#0 -- vbuz1=vbuc1_rol_vbuz1 
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
    // [124] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbuz1 
    sta x
    // char vscale = (*VERA_DC_VSCALE) >> 7
    // [125] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    sta.z vscale
    // 30 << vscale
    // [126] screensize::$3 = $1e << screensize::vscale#0 -- vbuz1=vbuc1_rol_vbuz1 
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
    // [127] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbuz1 
    sta y
    // screensize::@return
    // }
    // [128] return 
    rts
}
  // screenlayer1
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer1: {
    .label __0 = $48
    .label __1 = $49
    .label __2 = $32
    .label __3 = $42
    .label __4 = $42
    .label __5 = $46
    .label __6 = $46
    .label __7 = $4a
    .label __8 = $4a
    .label __9 = $4a
    .label __10 = $4b
    .label __11 = $4b
    .label __12 = $43
    .label __13 = $4e
    .label __14 = $43
    .label __15 = $4f
    .label __16 = $42
    .label __17 = $46
    .label __18 = $4b
    // __conio.layer = 1
    // [129] *((char *)&__conio) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta __conio
    // (*VERA_L1_MAPBASE)>>7
    // [130] screenlayer1::$0 = *VERA_L1_MAPBASE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_L1_MAPBASE
    rol
    rol
    and #1
    sta.z __0
    // __conio.mapbase_bank = (*VERA_L1_MAPBASE)>>7
    // [131] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) = screenlayer1::$0 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    // (*VERA_L1_MAPBASE)<<1
    // [132] screenlayer1::$1 = *VERA_L1_MAPBASE << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda VERA_L1_MAPBASE
    asl
    sta.z __1
    // MAKEWORD((*VERA_L1_MAPBASE)<<1,0)
    // [133] screenlayer1::$2 = screenlayer1::$1 w= 0 -- vwuz1=vbuz2_word_vbuc1 
    lda #0
    ldy.z __1
    sty.z __2+1
    sta.z __2
    // __conio.mapbase_offset = MAKEWORD((*VERA_L1_MAPBASE)<<1,0)
    // [134] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) = screenlayer1::$2 -- _deref_pwuc1=vwuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    tya
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    // *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK
    // [135] screenlayer1::$3 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta.z __3
    // (*VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4
    // [136] screenlayer1::$4 = screenlayer1::$3 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z __4
    lsr
    lsr
    lsr
    lsr
    sta.z __4
    // __conio.mapwidth = VERA_LAYER_WIDTH[ (*VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4]
    // [137] screenlayer1::$16 = screenlayer1::$4 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __16
    // [138] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) = VERA_LAYER_WIDTH[screenlayer1::$16] -- _deref_pwuc1=pwuc2_derefidx_vbuz1 
    ldy.z __16
    lda VERA_LAYER_WIDTH,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    lda VERA_LAYER_WIDTH+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    // *VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK
    // [139] screenlayer1::$5 = *VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK
    and VERA_L1_CONFIG
    sta.z __5
    // (*VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6
    // [140] screenlayer1::$6 = screenlayer1::$5 >> 6 -- vbuz1=vbuz1_ror_6 
    lda.z __6
    rol
    rol
    rol
    and #3
    sta.z __6
    // __conio.mapheight = VERA_LAYER_HEIGHT[ (*VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [141] screenlayer1::$17 = screenlayer1::$6 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __17
    // [142] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT) = VERA_LAYER_HEIGHT[screenlayer1::$17] -- _deref_pwuc1=pwuc2_derefidx_vbuz1 
    ldy.z __17
    lda VERA_LAYER_HEIGHT,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT
    lda VERA_LAYER_HEIGHT+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT+1
    // (*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK
    // [143] screenlayer1::$7 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta.z __7
    // ((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4
    // [144] screenlayer1::$8 = screenlayer1::$7 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z __8
    lsr
    lsr
    lsr
    lsr
    sta.z __8
    // (((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4)+6
    // [145] screenlayer1::$9 = screenlayer1::$8 + 6 -- vbuz1=vbuz1_plus_vbuc1 
    lda #6
    clc
    adc.z __9
    sta.z __9
    // __conio.rowshift = (((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4)+6
    // [146] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) = screenlayer1::$9 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    // (*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK
    // [147] screenlayer1::$10 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta.z __10
    // ((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4
    // [148] screenlayer1::$11 = screenlayer1::$10 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z __11
    lsr
    lsr
    lsr
    lsr
    sta.z __11
    // __conio.rowskip = VERA_LAYER_SKIP[((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4]
    // [149] screenlayer1::$18 = screenlayer1::$11 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __18
    // [150] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) = VERA_LAYER_SKIP[screenlayer1::$18] -- _deref_pwuc1=pwuc2_derefidx_vbuz1 
    ldy.z __18
    lda VERA_LAYER_SKIP,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    lda VERA_LAYER_SKIP+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    // cbm_k_plot_get()
    // [151] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [152] cbm_k_plot_get::return#2 = cbm_k_plot_get::return#0
    // screenlayer1::@1
    // [153] screenlayer1::$12 = cbm_k_plot_get::return#2
    // BYTE1(cbm_k_plot_get())
    // [154] screenlayer1::$13 = byte1  screenlayer1::$12 -- vbuz1=_byte1_vwuz2 
    lda.z __12+1
    sta.z __13
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [155] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = screenlayer1::$13 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // cbm_k_plot_get()
    // [156] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [157] cbm_k_plot_get::return#3 = cbm_k_plot_get::return#0
    // screenlayer1::@2
    // [158] screenlayer1::$14 = cbm_k_plot_get::return#3
    // BYTE0(cbm_k_plot_get())
    // [159] screenlayer1::$15 = byte0  screenlayer1::$14 -- vbuz1=_byte0_vwuz2 
    lda.z __14
    sta.z __15
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [160] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = screenlayer1::$15 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // screenlayer1::@return
    // }
    // [161] return 
    rts
}
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char textcolor(__zp($34) char color)
textcolor: {
    .label __0 = $42
    .label __1 = $34
    .label color = $34
    // __conio.color & 0xF0
    // [163] textcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) & $f0 -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z __0
    // __conio.color & 0xF0 | color
    // [164] textcolor::$1 = textcolor::$0 | textcolor::color#5 -- vbuz1=vbuz2_bor_vbuz1 
    lda.z __1
    ora.z __0
    sta.z __1
    // __conio.color = __conio.color & 0xF0 | color
    // [165] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) = textcolor::$1 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    // textcolor::@return
    // }
    // [166] return 
    rts
}
  // bgcolor
// Set the back color for text output. The old back text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor(__zp($34) char color)
bgcolor: {
    .label __0 = $46
    .label __1 = $34
    .label __2 = $46
    .label color = $34
    // __conio.color & 0x0F
    // [168] bgcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) & $f -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #$f
    and __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z __0
    // color << 4
    // [169] bgcolor::$1 = bgcolor::color#4 << 4 -- vbuz1=vbuz1_rol_4 
    lda.z __1
    asl
    asl
    asl
    asl
    sta.z __1
    // __conio.color & 0x0F | color << 4
    // [170] bgcolor::$2 = bgcolor::$0 | bgcolor::$1 -- vbuz1=vbuz1_bor_vbuz2 
    lda.z __2
    ora.z __1
    sta.z __2
    // __conio.color = __conio.color & 0x0F | color << 4
    // [171] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) = bgcolor::$2 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    // bgcolor::@return
    // }
    // [172] return 
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
    // [173] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR
    // cursor::@return
    // }
    // [174] return 
    rts
}
  // cbm_k_plot_get
/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
cbm_k_plot_get: {
    .label x = $47
    .label y = $45
    .label return = $43
    // unsigned char x
    // [175] cbm_k_plot_get::x = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z x
    // unsigned char y
    // [176] cbm_k_plot_get::y = 0 -- vbuz1=vbuc1 
    sta.z y
    // kickasm
    // kickasm( uses cbm_k_plot_get::x uses cbm_k_plot_get::y uses CBM_PLOT) {{ sec         jsr CBM_PLOT         stx y         sty x      }}
    sec
        jsr CBM_PLOT
        stx y
        sty x
    
    // MAKEWORD(x,y)
    // [178] cbm_k_plot_get::return#0 = cbm_k_plot_get::x w= cbm_k_plot_get::y -- vwuz1=vbuz2_word_vbuz3 
    lda.z x
    sta.z return+1
    lda.z y
    sta.z return
    // cbm_k_plot_get::@return
    // }
    // [179] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__zp($34) char x, __zp($35) char y)
gotoxy: {
    .label __5 = $32
    .label line_offset = $32
    .label x = $34
    .label y = $35
    // if(y>__conio.height)
    // [181] if(gotoxy::y#5<=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto gotoxy::@3 -- vbuz1_le__deref_pbuc1_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    cmp.z y
    bcs __b1
    // [183] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [183] phi gotoxy::y#6 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z y
    // [182] phi from gotoxy to gotoxy::@3 [phi:gotoxy->gotoxy::@3]
    // gotoxy::@3
    // [183] phi from gotoxy::@3 to gotoxy::@1 [phi:gotoxy::@3->gotoxy::@1]
    // [183] phi gotoxy::y#6 = gotoxy::y#5 [phi:gotoxy::@3->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=__conio.width)
    // [184] if(gotoxy::x#5<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto gotoxy::@4 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z x
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    bcc __b2
    // [186] phi from gotoxy::@1 to gotoxy::@2 [phi:gotoxy::@1->gotoxy::@2]
    // [186] phi gotoxy::x#6 = 0 [phi:gotoxy::@1->gotoxy::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z x
    // [185] phi from gotoxy::@1 to gotoxy::@4 [phi:gotoxy::@1->gotoxy::@4]
    // gotoxy::@4
    // [186] phi from gotoxy::@4 to gotoxy::@2 [phi:gotoxy::@4->gotoxy::@2]
    // [186] phi gotoxy::x#6 = gotoxy::x#5 [phi:gotoxy::@4->gotoxy::@2#0] -- register_copy 
    // gotoxy::@2
  __b2:
    // __conio.cursor_x = x
    // [187] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = gotoxy::x#6 -- _deref_pbuc1=vbuz1 
    lda.z x
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // __conio.cursor_y = y
    // [188] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = gotoxy::y#6 -- _deref_pbuc1=vbuz1 
    lda.z y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // unsigned int line_offset = (unsigned int)y << __conio.rowshift
    // [189] gotoxy::$5 = (unsigned int)gotoxy::y#6 -- vwuz1=_word_vbuz2 
    lda.z y
    sta.z __5
    lda #0
    sta.z __5+1
    // [190] gotoxy::line_offset#0 = gotoxy::$5 << *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) -- vwuz1=vwuz1_rol__deref_pbuc1 
    ldy __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    beq !e+
  !:
    asl.z line_offset
    rol.z line_offset+1
    dey
    bne !-
  !e:
    // __conio.line = line_offset
    // [191] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) = gotoxy::line_offset#0 -- _deref_pwuc1=vwuz1 
    lda.z line_offset
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    lda.z line_offset+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    // gotoxy::@return
    // }
    // [192] return 
    rts
}
  // cputln
// Print a newline
cputln: {
    .label temp = $22
    // unsigned int temp = __conio.line
    // [193] cputln::temp#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) -- vwuz1=_deref_pwuc1 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta.z temp
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    sta.z temp+1
    // temp += __conio.rowskip
    // [194] cputln::temp#1 = cputln::temp#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z temp
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta.z temp
    lda.z temp+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta.z temp+1
    // __conio.line = temp
    // [195] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) = cputln::temp#1 -- _deref_pwuc1=vwuz1 
    lda.z temp
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    lda.z temp+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    // __conio.cursor_x = 0
    // [196] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // __conio.cursor_y++;
    // [197] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = ++ *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // cscroll()
    // [198] call cscroll
    jsr cscroll
    // cputln::@return
    // }
    // [199] return 
    rts
}
  // vera_layers_reset
/**
 * @brief Resets the vera back to default settings.
 * Show Layer 1, hide layer 0.
 * Map from bank 1, offset 0xB000, tile from bank 1, offset 0xF000.
 * Mapbase width 128, mapbase height 64.
 * Tilebase width 8, tilebase height 8.
 * Color depth 4 bpp.
 * Color mode 16C.
 */
vera_layers_reset: {
    // vera_layer1_mode_tile( 1, 0xB000, 1, 0XF000, VERA_LAYER_WIDTH_128, VERA_LAYER_HEIGHT_64, VERA_TILEBASE_WIDTH_8, VERA_SPRITE_HEIGHT_8, VERA_LAYER_COLOR_DEPTH_1BPP)
    // [201] call vera_layer1_mode_tile
    // [290] phi from vera_layers_reset to vera_layer1_mode_tile [phi:vera_layers_reset->vera_layer1_mode_tile]
    jsr vera_layer1_mode_tile
    // [202] phi from vera_layers_reset to vera_layers_reset::@1 [phi:vera_layers_reset->vera_layers_reset::@1]
    // vera_layers_reset::@1
    // vera_layer1_set_text_color_mode( VERA_LAYER_CONFIG_16C )
    // [203] call vera_layer1_set_text_color_mode
    jsr vera_layer1_set_text_color_mode
    // vera_layers_reset::vera_layer1_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [204] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_LAYER1_ENABLE
    // [205] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_LAYER1_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER1_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_layers_reset::vera_layer0_hide1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [206] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER0_ENABLE
    // [207] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER0_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER0_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_layers_reset::@return
    // }
    // [208] return 
    rts
}
  // vera_layer0_mode_text
// Set a vera layer in text mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// - mapwidth: The width of the map in number of tiles.
// - mapheight: The height of the map in number of tiles.
// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
// - tileheight: The height of a tile, which can be 8 or 16 pixels.
// - color_mode: The color mode, which can be 16 or 256.
// void vera_layer0_mode_text(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char color_mode)
vera_layer0_mode_text: {
    .label tilebase_bank = 1
    .label tilebase_offset = $f000
    // vera_layer0_mode_tile( mapbase_bank, mapbase_offset, tilebase_bank, tilebase_offset, mapwidth, mapheight, tilewidth, tileheight, VERA_LAYER_COLOR_DEPTH_1BPP)
    // [210] call vera_layer0_mode_tile
    // [308] phi from vera_layer0_mode_text to vera_layer0_mode_tile [phi:vera_layer0_mode_text->vera_layer0_mode_tile]
    jsr vera_layer0_mode_tile
    // [211] phi from vera_layer0_mode_text to vera_layer0_mode_text::@1 [phi:vera_layer0_mode_text->vera_layer0_mode_text::@1]
    // vera_layer0_mode_text::@1
    // vera_layer0_set_text_color_mode( color_mode )
    // [212] call vera_layer0_set_text_color_mode
    jsr vera_layer0_set_text_color_mode
    // vera_layer0_mode_text::@return
    // }
    // [213] return 
    rts
}
  // screenlayer0
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer0: {
    .label __0 = $36
    .label __1 = $37
    .label __2 = $22
    .label __3 = $38
    .label __4 = $38
    .label __5 = $39
    .label __6 = $39
    .label __7 = $3a
    .label __8 = $3a
    .label __9 = $3a
    .label __10 = $30
    .label __11 = $30
    .label __12 = $38
    .label __13 = $39
    .label __14 = $30
    // __conio.layer = 0
    // [214] *((char *)&__conio) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio
    // (*VERA_L0_MAPBASE)>>7
    // [215] screenlayer0::$0 = *VERA_L0_MAPBASE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_L0_MAPBASE
    rol
    rol
    and #1
    sta.z __0
    // __conio.mapbase_bank = (*VERA_L0_MAPBASE)>>7
    // [216] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) = screenlayer0::$0 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    // (*VERA_L0_MAPBASE)<<1
    // [217] screenlayer0::$1 = *VERA_L0_MAPBASE << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda VERA_L0_MAPBASE
    asl
    sta.z __1
    // MAKEWORD((*VERA_L0_MAPBASE)<<1,0)
    // [218] screenlayer0::$2 = screenlayer0::$1 w= 0 -- vwuz1=vbuz2_word_vbuc1 
    lda #0
    ldy.z __1
    sty.z __2+1
    sta.z __2
    // __conio.mapbase_offset = MAKEWORD((*VERA_L0_MAPBASE)<<1,0)
    // [219] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) = screenlayer0::$2 -- _deref_pwuc1=vwuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    tya
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    // *VERA_L0_CONFIG & VERA_LAYER_WIDTH_MASK
    // [220] screenlayer0::$3 = *VERA_L0_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L0_CONFIG
    sta.z __3
    // (*VERA_L0_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4
    // [221] screenlayer0::$4 = screenlayer0::$3 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z __4
    lsr
    lsr
    lsr
    lsr
    sta.z __4
    // __conio.mapwidth = VERA_LAYER_WIDTH[ (*VERA_L0_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4]
    // [222] screenlayer0::$12 = screenlayer0::$4 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __12
    // [223] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) = VERA_LAYER_WIDTH[screenlayer0::$12] -- _deref_pwuc1=pwuc2_derefidx_vbuz1 
    ldy.z __12
    lda VERA_LAYER_WIDTH,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    lda VERA_LAYER_WIDTH+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    // *VERA_L0_CONFIG & VERA_LAYER_HEIGHT_MASK
    // [224] screenlayer0::$5 = *VERA_L0_CONFIG & VERA_LAYER_HEIGHT_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK
    and VERA_L0_CONFIG
    sta.z __5
    // (*VERA_L0_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6
    // [225] screenlayer0::$6 = screenlayer0::$5 >> 6 -- vbuz1=vbuz1_ror_6 
    lda.z __6
    rol
    rol
    rol
    and #3
    sta.z __6
    // __conio.mapheight = VERA_LAYER_HEIGHT[ (*VERA_L0_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [226] screenlayer0::$13 = screenlayer0::$6 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __13
    // [227] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT) = VERA_LAYER_HEIGHT[screenlayer0::$13] -- _deref_pwuc1=pwuc2_derefidx_vbuz1 
    ldy.z __13
    lda VERA_LAYER_HEIGHT,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT
    lda VERA_LAYER_HEIGHT+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT+1
    // (*VERA_L0_CONFIG)&VERA_LAYER_WIDTH_MASK
    // [228] screenlayer0::$7 = *VERA_L0_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L0_CONFIG
    sta.z __7
    // ((*VERA_L0_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4
    // [229] screenlayer0::$8 = screenlayer0::$7 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z __8
    lsr
    lsr
    lsr
    lsr
    sta.z __8
    // (((*VERA_L0_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4)+6
    // [230] screenlayer0::$9 = screenlayer0::$8 + 6 -- vbuz1=vbuz1_plus_vbuc1 
    lda #6
    clc
    adc.z __9
    sta.z __9
    // __conio.rowshift = (((*VERA_L0_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4)+6
    // [231] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) = screenlayer0::$9 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    // (*VERA_L0_CONFIG)&VERA_LAYER_WIDTH_MASK
    // [232] screenlayer0::$10 = *VERA_L0_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L0_CONFIG
    sta.z __10
    // ((*VERA_L0_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4
    // [233] screenlayer0::$11 = screenlayer0::$10 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z __11
    lsr
    lsr
    lsr
    lsr
    sta.z __11
    // __conio.rowskip = VERA_LAYER_SKIP[((*VERA_L0_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4]
    // [234] screenlayer0::$14 = screenlayer0::$11 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __14
    // [235] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) = VERA_LAYER_SKIP[screenlayer0::$14] -- _deref_pwuc1=pwuc2_derefidx_vbuz1 
    ldy.z __14
    lda VERA_LAYER_SKIP,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    lda VERA_LAYER_SKIP+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    // screenlayer0::@return
    // }
    // [236] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __1 = $36
    .label __2 = $37
    .label __3 = $31
    .label line_text = $3e
    .label color = $30
    .label mapheight = $40
    .label mapwidth = $3b
    .label c = $3d
    .label l = $2e
    // unsigned int line_text = __conio.mapbase_offset
    // [237] clrscr::line_text#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z line_text
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z line_text+1
    // char color = __conio.color
    // [238] clrscr::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z color
    // unsigned int mapheight = __conio.mapheight
    // [239] clrscr::mapheight#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT
    sta.z mapheight
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT+1
    sta.z mapheight+1
    // unsigned int mapwidth = __conio.mapwidth
    // [240] clrscr::mapwidth#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    sta.z mapwidth
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    sta.z mapwidth+1
    // [241] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [241] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr->clrscr::@1#0] -- register_copy 
    // [241] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<mapheight; l++ )
    // [242] if(clrscr::l#2<clrscr::mapheight#0) goto clrscr::@2 -- vbuz1_lt_vwuz2_then_la1 
    lda.z mapheight+1
    bne __b2
    lda.z l
    cmp.z mapheight
    bcc __b2
    // clrscr::@3
    // __conio.cursor_x = 0
    // [243] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // __conio.cursor_y = 0
    // [244] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = 0 -- _deref_pbuc1=vbuc2 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // __conio.line = 0
    // [245] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) = 0 -- _deref_pwuc1=vbuc2 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    // clrscr::@return
    // }
    // [246] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [247] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(ch)
    // [248] clrscr::$1 = byte0  clrscr::line_text#2 -- vbuz1=_byte0_vwuz2 
    lda.z line_text
    sta.z __1
    // *VERA_ADDRX_L = BYTE0(ch)
    // [249] *VERA_ADDRX_L = clrscr::$1 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(ch)
    // [250] clrscr::$2 = byte1  clrscr::line_text#2 -- vbuz1=_byte1_vwuz2 
    lda.z line_text+1
    sta.z __2
    // *VERA_ADDRX_M = BYTE1(ch)
    // [251] *VERA_ADDRX_M = clrscr::$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [252] clrscr::$3 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    sta.z __3
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [253] *VERA_ADDRX_H = clrscr::$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [254] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [254] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@4
  __b4:
    // for( char c=0;c<mapwidth; c++ )
    // [255] if(clrscr::c#2<clrscr::mapwidth#0) goto clrscr::@5 -- vbuz1_lt_vwuz2_then_la1 
    lda.z mapwidth+1
    bne __b5
    lda.z c
    cmp.z mapwidth
    bcc __b5
    // clrscr::@6
    // line_text += __conio.rowskip
    // [256] clrscr::line_text#1 = clrscr::line_text#2 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z line_text
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta.z line_text
    lda.z line_text+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta.z line_text+1
    // for( char l=0;l<mapheight; l++ )
    // [257] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [241] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [241] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [241] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [258] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [259] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<mapwidth; c++ )
    // [260] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [254] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [254] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
}
  // printf_str
/// Print a NUL-terminated string
// void printf_str(void (*putc)(char), __zp($3e) const char *s)
printf_str: {
    .label c = $36
    .label s = $3e
    // [262] phi from printf_str printf_str::@2 to printf_str::@1 [phi:printf_str/printf_str::@2->printf_str::@1]
    // [262] phi printf_str::s#8 = printf_str::s#9 [phi:printf_str/printf_str::@2->printf_str::@1#0] -- register_copy 
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [263] printf_str::c#1 = *printf_str::s#8 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta.z c
    // [264] printf_str::s#0 = ++ printf_str::s#8 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [265] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbuz1_then_la1 
    lda.z c
    bne __b2
    // printf_str::@return
    // }
    // [266] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [267] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbuz1 
    lda.z c
    pha
    // [268] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
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
    .label ch = $4c
    .label bank_get_bram1_return = $37
    .label return = $2e
    // char ch
    // [270] getin::ch = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z ch
    // getin::bank_get_bram1
    // return BRAM;
    // [271] getin::bank_get_bram1_return#0 = BRAM -- vbuz1=vbuz2 
    lda.z BRAM
    sta.z bank_get_bram1_return
    // getin::bank_set_bram1
    // BRAM = bank
    // [272] BRAM = getin::bank_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_set_bram1_bank
    sta.z BRAM
    // getin::@1
    // asm
    // asm { jsr$ffe4 stach  }
    jsr $ffe4
    sta ch
    // getin::bank_set_bram2
    // BRAM = bank
    // [274] BRAM = getin::bank_get_bram1_return#0 -- vbuz1=vbuz2 
    lda.z bank_get_bram1_return
    sta.z BRAM
    // getin::@2
    // return ch;
    // [275] getin::return#0 = getin::ch -- vbuz1=vbuz2 
    lda.z ch
    sta.z return
    // getin::@return
    // }
    // [276] getin::return#1 = getin::return#0
    // [277] return 
    rts
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(__conio.cursor_y>=__conio.height)
    // [278] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto cscroll::@return -- _deref_pbuc1_lt__deref_pbuc2_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    bcc __breturn
    // cscroll::@1
    // if(__conio.scroll[__conio.layer])
    // [279] if(0!=((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_SCROLL)[*((char *)&__conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_SCROLL,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(__conio.cursor_y>=__conio.height)
    // [280] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto cscroll::@return -- _deref_pbuc1_lt__deref_pbuc2_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    bcc __breturn
    // [281] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
    // gotoxy(0,0)
    // [282] call gotoxy
    // [180] phi from cscroll::@3 to gotoxy [phi:cscroll::@3->gotoxy]
    // [180] phi gotoxy::x#5 = 0 [phi:cscroll::@3->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [180] phi gotoxy::y#5 = 0 [phi:cscroll::@3->gotoxy#1] -- vbuz1=vbuc1 
    sta.z gotoxy.y
    jsr gotoxy
    // cscroll::@return
  __breturn:
    // }
    // [283] return 
    rts
    // [284] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [285] call insertup
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, __conio.height-1)
    // [286] gotoxy::y#2 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    dex
    stx.z gotoxy.y
    // [287] call gotoxy
    // [180] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [180] phi gotoxy::x#5 = 0 [phi:cscroll::@5->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [180] phi gotoxy::y#5 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#1] -- register_copy 
    jsr gotoxy
    // [288] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [289] call clearline
    jsr clearline
    rts
}
  // vera_layer1_mode_tile
// void vera_layer1_mode_tile(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char bpp)
vera_layer1_mode_tile: {
    .const mapbase_bank = 1
    .const mapbase_offset = $b000
    .const tilebase_bank = 1
    .const tilebase_offset = $f000
    // vera_layer1_mode_tile::vera_layer1_set_color_depth1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK
    // [291] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_COLOR_DEPTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= bpp
    // [292] *VERA_L1_CONFIG = *VERA_L1_CONFIG -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_width1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_WIDTH_MASK
    // [293] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= mapwidth
    // [294] *VERA_L1_CONFIG = *VERA_L1_CONFIG | VERA_LAYER_WIDTH_128 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_WIDTH_128
    ora VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_height1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_HEIGHT_MASK
    // [295] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= mapheight
    // [296] *VERA_L1_CONFIG = *VERA_L1_CONFIG | VERA_LAYER_HEIGHT_64 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_HEIGHT_64
    ora VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_mapbase1
    // *VERA_L1_MAPBASE = (mapbase_bank<<7) | (BYTE1(mapbase_offset)>>1)
    // [297] *VERA_L1_MAPBASE = vera_layer1_mode_tile::mapbase_bank#0<<7|byte1 vera_layer1_mode_tile::mapbase_offset#0>>1 -- _deref_pbuc1=vbuc2 
    lda #mapbase_bank<<7|(>mapbase_offset)>>1
    sta VERA_L1_MAPBASE
    // vera_layer1_mode_tile::vera_layer1_set_tilebase1
    // *VERA_L1_TILEBASE &= ~VERA_LAYER_TILEBASE_MASK
    // [298] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_LAYER_TILEBASE_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_TILEBASE_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= ((tilebase_bank << 7) | BYTE1(tilebase_offset)>>1)
    // [299] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE | vera_layer1_mode_tile::tilebase_bank#0<<7|byte1 vera_layer1_mode_tile::tilebase_offset#0>>1 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #tilebase_bank<<7|(>tilebase_offset)>>1
    ora VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::vera_layer1_set_tile_width1
    // *VERA_L1_TILEBASE &= ~VERA_TILEBASE_WIDTH_MASK
    // [300] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_TILEBASE_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_WIDTH_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= tilewidth
    // [301] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::vera_layer1_set_tile_height1
    // *VERA_L1_TILEBASE &= ~VERA_TILEBASE_HEIGHT_MASK
    // [302] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_TILEBASE_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_HEIGHT_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= tileheight
    // [303] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::@return
    // }
    // [304] return 
    rts
}
  // vera_layer1_set_text_color_mode
// void vera_layer1_set_text_color_mode(char color_mode)
vera_layer1_set_text_color_mode: {
    // *VERA_L1_CONFIG &= ~VERA_LAYER_CONFIG_256C
    // [305] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_CONFIG_256C -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_CONFIG_256C^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= color_mode
    // [306] *VERA_L1_CONFIG = *VERA_L1_CONFIG -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_CONFIG
    // vera_layer1_set_text_color_mode::@return
    // }
    // [307] return 
    rts
}
  // vera_layer0_mode_tile
// void vera_layer0_mode_tile(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char bpp)
vera_layer0_mode_tile: {
    // vera_layer0_mode_tile::vera_layer0_set_color_depth1
    // *VERA_L0_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK
    // [309] *VERA_L0_CONFIG = *VERA_L0_CONFIG & ~VERA_LAYER_COLOR_DEPTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_MASK^$ff
    and VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // *VERA_L0_CONFIG |= bpp
    // [310] *VERA_L0_CONFIG = *VERA_L0_CONFIG -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L0_CONFIG
    // vera_layer0_mode_tile::vera_layer0_set_width1
    // *VERA_L0_CONFIG &= ~VERA_LAYER_WIDTH_MASK
    // [311] *VERA_L0_CONFIG = *VERA_L0_CONFIG & ~VERA_LAYER_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK^$ff
    and VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // *VERA_L0_CONFIG |= mapwidth
    // [312] *VERA_L0_CONFIG = *VERA_L0_CONFIG | VERA_LAYER_WIDTH_128 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_WIDTH_128
    ora VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // vera_layer0_mode_tile::vera_layer0_set_height1
    // *VERA_L0_CONFIG &= ~VERA_LAYER_HEIGHT_MASK
    // [313] *VERA_L0_CONFIG = *VERA_L0_CONFIG & ~VERA_LAYER_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK^$ff
    and VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // *VERA_L0_CONFIG |= mapheight
    // [314] *VERA_L0_CONFIG = *VERA_L0_CONFIG | VERA_LAYER_HEIGHT_64 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_HEIGHT_64
    ora VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // vera_layer0_mode_tile::vera_layer0_set_mapbase1
    // *VERA_L0_MAPBASE = (mapbase_bank<<7) | (BYTE1(mapbase_offset)>>1)
    // [315] *VERA_L0_MAPBASE = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta VERA_L0_MAPBASE
    // vera_layer0_mode_tile::vera_layer0_set_tilebase1
    // *VERA_L0_TILEBASE &= ~VERA_LAYER_TILEBASE_MASK
    // [316] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE & ~VERA_LAYER_TILEBASE_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_TILEBASE_MASK^$ff
    and VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // *VERA_L0_TILEBASE |= ((tilebase_bank << 7) | BYTE1(tilebase_offset)>>1)
    // [317] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE | vera_layer0_mode_text::tilebase_bank#0<<7|byte1 vera_layer0_mode_text::tilebase_offset#0>>1 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #vera_layer0_mode_text.tilebase_bank<<7|(>vera_layer0_mode_text.tilebase_offset)>>1
    ora VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // vera_layer0_mode_tile::vera_layer0_set_tile_width1
    // *VERA_L0_TILEBASE &= ~VERA_TILEBASE_WIDTH_MASK
    // [318] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE & ~VERA_TILEBASE_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_WIDTH_MASK^$ff
    and VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // *VERA_L0_TILEBASE |= tilewidth
    // [319] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L0_TILEBASE
    // vera_layer0_mode_tile::vera_layer0_set_tile_height1
    // *VERA_L0_TILEBASE &= ~VERA_TILEBASE_HEIGHT_MASK
    // [320] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE & ~VERA_TILEBASE_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_HEIGHT_MASK^$ff
    and VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // *VERA_L0_TILEBASE |= tileheight
    // [321] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L0_TILEBASE
    // vera_layer0_mode_tile::@return
    // }
    // [322] return 
    rts
}
  // vera_layer0_set_text_color_mode
/**
 * @brief Set the configuration of the layer text color mode.
 *
 * @param color_mode Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
 */
// void vera_layer0_set_text_color_mode(char color_mode)
vera_layer0_set_text_color_mode: {
    // *VERA_L0_CONFIG &= ~VERA_LAYER_CONFIG_256C
    // [323] *VERA_L0_CONFIG = *VERA_L0_CONFIG & ~VERA_LAYER_CONFIG_256C -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_CONFIG_256C^$ff
    and VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // *VERA_L0_CONFIG |= color_mode
    // [324] *VERA_L0_CONFIG = *VERA_L0_CONFIG | VERA_LAYER_CONFIG_256C -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_CONFIG_256C
    ora VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // vera_layer0_set_text_color_mode::@return
    // }
    // [325] return 
    rts
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label __3 = $2f
    .label cy = $31
    .label width = $30
    .label line = $2a
    .label start = $2a
    .label i = $2e
    // unsigned char cy = __conio.cursor_y
    // [326] insertup::cy#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    sta.z cy
    // unsigned char width = __conio.width * 2
    // [327] insertup::width#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    asl
    sta.z width
    // [328] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [328] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z i
    // insertup::@1
  __b1:
    // for(unsigned char i=1; i<=cy; i++)
    // [329] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuz1_le_vbuz2_then_la1 
    lda.z cy
    cmp.z i
    bcs __b2
    // [330] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [331] call clearline
    jsr clearline
    // insertup::@return
    // }
    // [332] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [333] insertup::$3 = insertup::i#2 - 1 -- vbuz1=vbuz2_minus_1 
    ldx.z i
    dex
    stx.z __3
    // unsigned int line = (i-1) << __conio.rowshift
    // [334] insertup::line#0 = insertup::$3 << *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) -- vwuz1=vbuz2_rol__deref_pbuc1 
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
    // [335] insertup::start#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) + insertup::line#0 -- vwuz1=_deref_pwuc1_plus_vwuz1 
    clc
    lda.z start
    adc __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z start
    lda.z start+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z start+1
    // memcpy_vram_vram_inc(0, start, VERA_INC_1, 0, start+__conio.rowskip, VERA_INC_1, width)
    // [336] memcpy_vram_vram_inc::soffset_vram#0 = insertup::start#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwuz1=vwuz2_plus__deref_pwuc1 
    lda.z start
    clc
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta.z memcpy_vram_vram_inc.soffset_vram
    lda.z start+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta.z memcpy_vram_vram_inc.soffset_vram+1
    // [337] memcpy_vram_vram_inc::doffset_vram#0 = insertup::start#0
    // [338] memcpy_vram_vram_inc::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z memcpy_vram_vram_inc.num
    lda #0
    sta.z memcpy_vram_vram_inc.num+1
    // [339] call memcpy_vram_vram_inc
    // [358] phi from insertup::@2 to memcpy_vram_vram_inc [phi:insertup::@2->memcpy_vram_vram_inc]
    jsr memcpy_vram_vram_inc
    // insertup::@4
    // for(unsigned char i=1; i<=cy; i++)
    // [340] insertup::i#1 = ++ insertup::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [328] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [328] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
}
  // clearline
clearline: {
    .label __1 = $27
    .label __2 = $28
    .label mapbase_offset = $2c
    .label conio_line = $24
    .label addr = $2c
    .label color = $26
    .label c = $22
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [341] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // unsigned int mapbase_offset =  (unsigned int)__conio.mapbase_offset
    // [342] clearline::mapbase_offset#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwuz1=_deref_pwuc1 
    // Set address
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z mapbase_offset
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z mapbase_offset+1
    // unsigned int conio_line = __conio.line
    // [343] clearline::conio_line#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta.z conio_line
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    sta.z conio_line+1
    // mapbase_offset + conio_line
    // [344] clearline::addr#0 = clearline::mapbase_offset#0 + clearline::conio_line#0 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z addr
    adc.z conio_line
    sta.z addr
    lda.z addr+1
    adc.z conio_line+1
    sta.z addr+1
    // BYTE0(addr)
    // [345] clearline::$1 = byte0  (char *)clearline::addr#0 -- vbuz1=_byte0_pbuz2 
    lda.z addr
    sta.z __1
    // *VERA_ADDRX_L = BYTE0(addr)
    // [346] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(addr)
    // [347] clearline::$2 = byte1  (char *)clearline::addr#0 -- vbuz1=_byte1_pbuz2 
    lda.z addr+1
    sta.z __2
    // *VERA_ADDRX_M = BYTE1(addr)
    // [348] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [349] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // char color = __conio.color
    // [350] clearline::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbuz1=_deref_pbuc1 
    // TODO need to check this!
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z color
    // [351] phi from clearline to clearline::@1 [phi:clearline->clearline::@1]
    // [351] phi clearline::c#2 = 0 [phi:clearline->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<__conio.width; c++ )
    // [352] if(clearline::c#2<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto clearline::@2 -- vwuz1_lt__deref_pbuc1_then_la1 
    lda.z c+1
    bne !+
    lda.z c
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    bcc __b2
  !:
    // clearline::@3
    // __conio.cursor_x = 0
    // [353] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // clearline::@return
    // }
    // [354] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [355] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [356] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( unsigned int c=0;c<__conio.width; c++ )
    // [357] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [351] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [351] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
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
// void memcpy_vram_vram_inc(char dbank_vram, __zp($2a) unsigned int doffset_vram, char dinc, char sbank_vram, __zp($2c) unsigned int soffset_vram, char sinc, __zp($24) unsigned int num)
memcpy_vram_vram_inc: {
    .label vera_vram_data0_bank_offset1___0 = $27
    .label vera_vram_data0_bank_offset1___1 = $28
    .label vera_vram_data1_bank_offset1___0 = $26
    .label vera_vram_data1_bank_offset1___1 = $29
    .label i = $22
    .label doffset_vram = $2a
    .label soffset_vram = $2c
    .label num = $24
    // memcpy_vram_vram_inc::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [359] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [360] memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$0 = byte0  memcpy_vram_vram_inc::soffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z soffset_vram
    sta.z vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [361] *VERA_ADDRX_L = memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [362] memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$1 = byte1  memcpy_vram_vram_inc::soffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z soffset_vram+1
    sta.z vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [363] *VERA_ADDRX_M = memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [364] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // memcpy_vram_vram_inc::vera_vram_data1_bank_offset1
    // *VERA_CTRL |= VERA_ADDRSEL
    // [365] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [366] memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$0 = byte0  memcpy_vram_vram_inc::doffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z doffset_vram
    sta.z vera_vram_data1_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [367] *VERA_ADDRX_L = memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [368] memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$1 = byte1  memcpy_vram_vram_inc::doffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z doffset_vram+1
    sta.z vera_vram_data1_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [369] *VERA_ADDRX_M = memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [370] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // [371] phi from memcpy_vram_vram_inc::vera_vram_data1_bank_offset1 to memcpy_vram_vram_inc::@1 [phi:memcpy_vram_vram_inc::vera_vram_data1_bank_offset1->memcpy_vram_vram_inc::@1]
    // [371] phi memcpy_vram_vram_inc::i#2 = 0 [phi:memcpy_vram_vram_inc::vera_vram_data1_bank_offset1->memcpy_vram_vram_inc::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // memcpy_vram_vram_inc::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [372] if(memcpy_vram_vram_inc::i#2<memcpy_vram_vram_inc::num#0) goto memcpy_vram_vram_inc::@2 -- vwuz1_lt_vwuz2_then_la1 
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
    // [373] return 
    rts
    // memcpy_vram_vram_inc::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [374] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [375] memcpy_vram_vram_inc::i#1 = ++ memcpy_vram_vram_inc::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [371] phi from memcpy_vram_vram_inc::@2 to memcpy_vram_vram_inc::@1 [phi:memcpy_vram_vram_inc::@2->memcpy_vram_vram_inc::@1]
    // [371] phi memcpy_vram_vram_inc::i#2 = memcpy_vram_vram_inc::i#1 [phi:memcpy_vram_vram_inc::@2->memcpy_vram_vram_inc::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment Data
  VERA_LAYER_WIDTH: .word $20, $40, $80, $100
  VERA_LAYER_HEIGHT: .word $20, $40, $80, $100
  VERA_LAYER_SKIP: .word $40, $80, $100, $200
  __conio: .fill SIZEOF_STRUCT_CX16_CONIO, 0
