  // File Comments
// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="cx16-veramodes.prg", type="prg", segments="Program"]
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
  .const VERA_LAYER1_ENABLE = $20
  .const VERA_LAYER0_ENABLE = $10
  .const VERA_LAYER_WIDTH_64 = $10
  .const VERA_LAYER_WIDTH_128 = $20
  .const VERA_LAYER_WIDTH_256 = $30
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_64 = $40
  .const VERA_LAYER_HEIGHT_128 = $80
  .const VERA_LAYER_HEIGHT_256 = $c0
  .const VERA_LAYER_HEIGHT_MASK = $c0
  /// Bit 0-1: Color Depth (0: 1 bpp, 1: 2 bpp, 2: 4 bpp, 3: 8 bpp)
  .const VERA_LAYER_COLOR_DEPTH_1BPP = 0
  .const VERA_LAYER_COLOR_DEPTH_2BPP = 1
  .const VERA_LAYER_COLOR_DEPTH_4BPP = 2
  .const VERA_LAYER_COLOR_DEPTH_8BPP = 3
  .const VERA_LAYER_COLOR_DEPTH_MASK = 3
  .const VERA_LAYER_CONFIG_MODE_BITMAP = 4
  /// Bit 3: T256C	        (0: tiles use a 16-color foreground and background color, 1: tiles use a 256-color foreground color) (only relevant in 1bpp modes)
  .const VERA_LAYER_CONFIG_16C = 0
  .const VERA_LAYER_CONFIG_256C = 8
  .const VERA_TILEBASE_WIDTH_16 = 1
  .const VERA_TILEBASE_HEIGHT_16 = 2
  .const VERA_LAYER_TILEBASE_MASK = $fc
  .const vera_inc_1 = $10
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH = 4
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT = 5
  .const OFFSET_STRUCT_MOS6522_VIA_PORT_A = 1
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT = 1
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT = 8
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH = 6
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK = 3
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP = $b
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT = $a
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR = $d
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_CX16_CONIO = $e
  /**
 * @brief The VIA#1: ROM/RAM Bank Control
 * Port A Bits 0-7 RAM bank
 * Port B Bits 0-2 ROM bank
 * Port B Bits 3-7 [TBD] *  *  *  *  *
 */
  .label VIA1 = $9f60
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
  .label __bitmap_address = $eb
  .label __bitmap_layer = $e8
  .label __bitmap_hscale = $ef
  .label __bitmap_vscale = $f0
  .label __bitmap_color_depth = $e1
  // The random state variable
  .label rand_state = $79
  // The random state variable
  .label rand_state_1 = $7d
  // Remainder after unsigned 16-bit division
  .label rem16u = $51
.segment Code
  // __start
__start: {
    // __start::__init1
    // __ma dword __bitmap_address = 0
    // [1] __bitmap_address = 0 -- vduz1=vduc1 
    lda #<0
    sta.z __bitmap_address
    sta.z __bitmap_address+1
    lda #<0>>$10
    sta.z __bitmap_address+2
    lda #>0>>$10
    sta.z __bitmap_address+3
    // __ma byte __bitmap_layer = 0
    // [2] __bitmap_layer = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z __bitmap_layer
    // __ma byte __bitmap_hscale = 0
    // [3] __bitmap_hscale = 0 -- vbuz1=vbuc1 
    sta.z __bitmap_hscale
    // __ma byte __bitmap_vscale = 0
    // [4] __bitmap_vscale = 0 -- vbuz1=vbuc1 
    sta.z __bitmap_vscale
    // __ma byte __bitmap_color_depth = 0
    // [5] __bitmap_color_depth = 0 -- vbuz1=vbuc1 
    sta.z __bitmap_color_depth
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [6] call conio_x16_init
    jsr conio_x16_init
    // [7] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [8] call main
    // [66] phi from __start::@1 to main [phi:__start::@1->main]
    jsr main
    // __start::@return
    // [9] return 
    rts
}
  // conio_x16_init
// Set initial cursor position
conio_x16_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label line = $45
    // char line = *BASIC_CURSOR_LINE
    // [10] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda.z BASIC_CURSOR_LINE
    sta.z line
    // vera_layer_mode_text(1,(unsigned long)0x00000,(unsigned long)0x0F800,128,64,8,8,16)
    // [11] call vera_layer_mode_text
    // [185] phi from conio_x16_init to vera_layer_mode_text [phi:conio_x16_init->vera_layer_mode_text]
    // [185] phi vera_layer_mode_text::color_mode#11 = $10 [phi:conio_x16_init->vera_layer_mode_text#0] -- vwuz1=vbuc1 
    lda #<$10
    sta.z vera_layer_mode_text.color_mode
    lda #>$10
    sta.z vera_layer_mode_text.color_mode+1
    // [185] phi vera_layer_mode_text::mapheight#11 = $40 [phi:conio_x16_init->vera_layer_mode_text#1] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_text.mapheight
    lda #>$40
    sta.z vera_layer_mode_text.mapheight+1
    // [185] phi vera_layer_mode_text::mapwidth#11 = $80 [phi:conio_x16_init->vera_layer_mode_text#2] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapwidth
    lda #>$80
    sta.z vera_layer_mode_text.mapwidth+1
    jsr vera_layer_mode_text
    // [12] phi from conio_x16_init to conio_x16_init::@3 [phi:conio_x16_init->conio_x16_init::@3]
    // conio_x16_init::@3
    // screensize(&cx16_conio.conio_screen_width, &cx16_conio.conio_screen_height)
    // [13] call screensize
    jsr screensize
    // [14] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // screenlayer(1)
    // [15] call screenlayer
    jsr screenlayer
    // [16] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // vera_layer_set_textcolor(1, WHITE)
    // [17] call vera_layer_set_textcolor
    // [229] phi from conio_x16_init::@5 to vera_layer_set_textcolor [phi:conio_x16_init::@5->vera_layer_set_textcolor]
    // [229] phi vera_layer_set_textcolor::color#2 = WHITE [phi:conio_x16_init::@5->vera_layer_set_textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z vera_layer_set_textcolor.color
    // [229] phi vera_layer_set_textcolor::layer#2 = 1 [phi:conio_x16_init::@5->vera_layer_set_textcolor#1] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_set_textcolor.layer
    jsr vera_layer_set_textcolor
    // [18] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // vera_layer_set_backcolor(1, BLUE)
    // [19] call vera_layer_set_backcolor
    // [232] phi from conio_x16_init::@6 to vera_layer_set_backcolor [phi:conio_x16_init::@6->vera_layer_set_backcolor]
    // [232] phi vera_layer_set_backcolor::color#2 = BLUE [phi:conio_x16_init::@6->vera_layer_set_backcolor#0] -- vbuz1=vbuc1 
    lda #BLUE
    sta.z vera_layer_set_backcolor.color
    // [232] phi vera_layer_set_backcolor::layer#2 = 1 [phi:conio_x16_init::@6->vera_layer_set_backcolor#1] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_set_backcolor.layer
    jsr vera_layer_set_backcolor
    // [20] phi from conio_x16_init::@6 to conio_x16_init::@7 [phi:conio_x16_init::@6->conio_x16_init::@7]
    // conio_x16_init::@7
    // vera_layer_set_mapbase(0,0x20)
    // [21] call vera_layer_set_mapbase
    // [235] phi from conio_x16_init::@7 to vera_layer_set_mapbase [phi:conio_x16_init::@7->vera_layer_set_mapbase]
    // [235] phi vera_layer_set_mapbase::mapbase#3 = $20 [phi:conio_x16_init::@7->vera_layer_set_mapbase#0] -- vbuz1=vbuc1 
    lda #$20
    sta.z vera_layer_set_mapbase.mapbase
    // [235] phi vera_layer_set_mapbase::layer#3 = 0 [phi:conio_x16_init::@7->vera_layer_set_mapbase#1] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_set_mapbase.layer
    jsr vera_layer_set_mapbase
    // [22] phi from conio_x16_init::@7 to conio_x16_init::@8 [phi:conio_x16_init::@7->conio_x16_init::@8]
    // conio_x16_init::@8
    // vera_layer_set_mapbase(1,0x00)
    // [23] call vera_layer_set_mapbase
    // [235] phi from conio_x16_init::@8 to vera_layer_set_mapbase [phi:conio_x16_init::@8->vera_layer_set_mapbase]
    // [235] phi vera_layer_set_mapbase::mapbase#3 = 0 [phi:conio_x16_init::@8->vera_layer_set_mapbase#0] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_set_mapbase.mapbase
    // [235] phi vera_layer_set_mapbase::layer#3 = 1 [phi:conio_x16_init::@8->vera_layer_set_mapbase#1] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_set_mapbase.layer
    jsr vera_layer_set_mapbase
    // [24] phi from conio_x16_init::@8 to conio_x16_init::@9 [phi:conio_x16_init::@8->conio_x16_init::@9]
    // conio_x16_init::@9
    // cursor(0)
    // [25] call cursor
    jsr cursor
    // conio_x16_init::@10
    // if(line>=cx16_conio.conio_screen_height)
    // [26] if(conio_x16_init::line#0<*((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto conio_x16_init::@1 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z line
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b1
    // conio_x16_init::@2
    // line=cx16_conio.conio_screen_height-1
    // [27] conio_x16_init::line#1 = *((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    stx.z line
    // [28] phi from conio_x16_init::@10 conio_x16_init::@2 to conio_x16_init::@1 [phi:conio_x16_init::@10/conio_x16_init::@2->conio_x16_init::@1]
    // [28] phi conio_x16_init::line#3 = conio_x16_init::line#0 [phi:conio_x16_init::@10/conio_x16_init::@2->conio_x16_init::@1#0] -- register_copy 
    // conio_x16_init::@1
  __b1:
    // gotoxy(0, line)
    // [29] gotoxy::y#1 = conio_x16_init::line#3
    // [30] call gotoxy
    // [242] phi from conio_x16_init::@1 to gotoxy [phi:conio_x16_init::@1->gotoxy]
    // [242] phi gotoxy::y#35 = gotoxy::y#1 [phi:conio_x16_init::@1->gotoxy#0] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [31] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__zp($67) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    .label __2 = $64
    .label __4 = $48
    .label __5 = $3d
    .label __6 = $10
    .label __15 = $66
    .label __16 = $4b
    .label c = $67
    .label color = $11
    .label conio_screen_text = $34
    .label conio_map_width = $53
    .label conio_addr = $34
    .label scroll_enable = $16
    // [32] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbuz1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta.z c
    // char color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [33] vera_layer_get_color::layer#0 = *((char *)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_color.layer
    // [34] call vera_layer_get_color
    // [255] phi from cputc to vera_layer_get_color [phi:cputc->vera_layer_get_color]
    // [255] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#0 [phi:cputc->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // char color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [35] vera_layer_get_color::return#3 = vera_layer_get_color::return#2
    // cputc::@7
    // [36] cputc::color#0 = vera_layer_get_color::return#3
    // unsigned int conio_screen_text = cx16_conio.conio_screen_text
    // [37] cputc::conio_screen_text#0 = *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z conio_screen_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z conio_screen_text+1
    // unsigned int conio_map_width = cx16_conio.conio_map_width
    // [38] cputc::conio_map_width#0 = *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // unsigned int conio_addr = conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [39] cputc::$15 = *((char *)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __15
    // [40] cputc::conio_addr#0 = cputc::conio_screen_text#0 + conio_line_text[cputc::$15] -- vwuz1=vwuz1_plus_pwuc1_derefidx_vbuz2 
    tay
    clc
    lda.z conio_addr
    adc conio_line_text,y
    sta.z conio_addr
    lda.z conio_addr+1
    adc conio_line_text+1,y
    sta.z conio_addr+1
    // conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [41] cputc::$2 = conio_cursor_x[*((char *)&cx16_conio)] << 1 -- vbuz1=pbuc1_derefidx_(_deref_pbuc2)_rol_1 
    ldy cx16_conio
    lda conio_cursor_x,y
    asl
    sta.z __2
    // conio_addr += conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [42] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$2 -- vwuz1=vwuz1_plus_vbuz2 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [43] if(cputc::c#0==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [44] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(conio_addr)
    // [45] cputc::$4 = byte0  cputc::conio_addr#1 -- vbuz1=_byte0_vwuz2 
    lda.z conio_addr
    sta.z __4
    // *VERA_ADDRX_L = BYTE0(conio_addr)
    // [46] *VERA_ADDRX_L = cputc::$4 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(conio_addr)
    // [47] cputc::$5 = byte1  cputc::conio_addr#1 -- vbuz1=_byte1_vwuz2 
    lda.z conio_addr+1
    sta.z __5
    // *VERA_ADDRX_M = BYTE1(conio_addr)
    // [48] *VERA_ADDRX_M = cputc::$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [49] cputc::$6 = *((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    sta.z __6
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [50] *VERA_ADDRX_H = cputc::$6 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [51] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [52] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // conio_cursor_x[cx16_conio.conio_screen_layer]++;
    // [53] conio_cursor_x[*((char *)&cx16_conio)] = ++ conio_cursor_x[*((char *)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    lda conio_cursor_x,x
    inc
    sta conio_cursor_x,x
    // unsigned char scroll_enable = conio_scroll_enable[cx16_conio.conio_screen_layer]
    // [54] cputc::scroll_enable#0 = conio_scroll_enable[*((char *)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy cx16_conio
    lda conio_scroll_enable,y
    sta.z scroll_enable
    // if(scroll_enable)
    // [55] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuz1_then_la1 
    bne __b5
    // cputc::@3
    // (unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width
    // [56] cputc::$16 = (unsigned int)conio_cursor_x[*((char *)&cx16_conio)] -- vwuz1=_word_pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_cursor_x,y
    sta.z __16
    lda #0
    sta.z __16+1
    // if((unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width)
    // [57] if(cputc::$16!=cputc::conio_map_width#0) goto cputc::@return -- vwuz1_neq_vwuz2_then_la1 
    cmp.z conio_map_width+1
    bne __breturn
    lda.z __16
    cmp.z conio_map_width
    bne __breturn
    // [58] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [59] call cputln
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [60] return 
    rts
    // cputc::@5
  __b5:
    // if(conio_cursor_x[cx16_conio.conio_screen_layer] == cx16_conio.conio_screen_width)
    // [61] if(conio_cursor_x[*((char *)&cx16_conio)]!=*((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto cputc::@return -- pbuc1_derefidx_(_deref_pbuc2)_neq__deref_pbuc3_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    ldy cx16_conio
    cmp conio_cursor_x,y
    bne __breturn
    // [62] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [63] call cputln
    jsr cputln
    rts
    // [64] phi from cputc::@7 to cputc::@1 [phi:cputc::@7->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [65] call cputln
    jsr cputln
    rts
}
  // main
main: {
    .const vera_layer_show1_layer = 1
    .const vera_layer_show2_layer = 1
    .label vera_layer_hide1___0 = $d5
    .label menu = $e9
    // [67] phi from main to main::@1 [phi:main->main::@1]
    // [67] phi rem16u#236 = 0 [phi:main->main::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z rem16u
    sta.z rem16u+1
    // [67] phi rand_state#246 = 1 [phi:main->main::@1#1] -- vwuz1=vwuc1 
    lda #<1
    sta.z rand_state_1
    lda #>1
    sta.z rand_state_1+1
    // [67] phi from main::@33 to main::@1 [phi:main::@33->main::@1]
    // [67] phi rem16u#236 = rem16u#10 [phi:main::@33->main::@1#0] -- register_copy 
    // [67] phi rand_state#246 = rand_state#10 [phi:main::@33->main::@1#1] -- register_copy 
    // main::@1
  __b1:
    // vera_layer_mode_text(1, 0x00000, 0x0f800, 64, 64, 8, 8, 4)
    // [68] call vera_layer_mode_text
    // [185] phi from main::@1 to vera_layer_mode_text [phi:main::@1->vera_layer_mode_text]
    // [185] phi vera_layer_mode_text::color_mode#11 = 4 [phi:main::@1->vera_layer_mode_text#0] -- vwuz1=vbuc1 
    lda #<4
    sta.z vera_layer_mode_text.color_mode
    lda #>4
    sta.z vera_layer_mode_text.color_mode+1
    // [185] phi vera_layer_mode_text::mapheight#11 = $40 [phi:main::@1->vera_layer_mode_text#1] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_text.mapheight
    lda #>$40
    sta.z vera_layer_mode_text.mapheight+1
    // [185] phi vera_layer_mode_text::mapwidth#11 = $40 [phi:main::@1->vera_layer_mode_text#2] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_text.mapwidth
    lda #>$40
    sta.z vera_layer_mode_text.mapwidth+1
    jsr vera_layer_mode_text
    // main::vera_display_set_scale_double1
    // *VERA_DC_HSCALE = 64
    // [69] *VERA_DC_HSCALE = $40 -- _deref_pbuc1=vbuc2 
    lda #$40
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 64
    // [70] *VERA_DC_VSCALE = $40 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // main::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [71] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [72] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *(vera_layer_enable+main::vera_layer_show1_layer#0) -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable+vera_layer_show1_layer
    sta VERA_DC_VIDEO
    // [73] phi from main::vera_layer_show1 to main::@34 [phi:main::vera_layer_show1->main::@34]
    // main::@34
    // screenlayer(1)
    // [74] call screenlayer
    jsr screenlayer
    // [75] phi from main::@34 to main::@37 [phi:main::@34->main::@37]
    // main::@37
    // textcolor(WHITE)
    // [76] call textcolor
    // [274] phi from main::@37 to textcolor [phi:main::@37->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:main::@37->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [77] phi from main::@37 to main::@38 [phi:main::@37->main::@38]
    // main::@38
    // bgcolor(BLUE)
    // [78] call bgcolor
    // [279] phi from main::@38 to bgcolor [phi:main::@38->bgcolor]
    // [279] phi bgcolor::color#26 = BLUE [phi:main::@38->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLUE
    sta.z bgcolor.color
    jsr bgcolor
    // [79] phi from main::@38 to main::@39 [phi:main::@38->main::@39]
    // main::@39
    // clrscr()
    // [80] call clrscr
    jsr clrscr
    // [81] phi from main::@39 to main::@40 [phi:main::@39->main::@40]
    // main::@40
    // printf( "\n *** vera modes demo - v1.0.1 ***\n\n" )
    // [82] call printf_str
    // [318] phi from main::@40 to printf_str [phi:main::@40->printf_str]
    // [318] phi printf_str::s#124 = main::s [phi:main::@40->printf_str#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // [83] phi from main::@40 to main::@41 [phi:main::@40->main::@41]
    // main::@41
    // printf( "1. bitmap - 320x240 - 1 bpp.\n")
    // [84] call printf_str
    // [318] phi from main::@41 to printf_str [phi:main::@41->printf_str]
    // [318] phi printf_str::s#124 = main::s1 [phi:main::@41->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [85] phi from main::@41 to main::@42 [phi:main::@41->main::@42]
    // main::@42
    // printf( "2. bitmap - 640x480 - 1 bpp.\n")
    // [86] call printf_str
    // [318] phi from main::@42 to printf_str [phi:main::@42->printf_str]
    // [318] phi printf_str::s#124 = main::s2 [phi:main::@42->printf_str#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // [87] phi from main::@42 to main::@43 [phi:main::@42->main::@43]
    // main::@43
    // printf( "3. bitmap - 320x240 - 2 bpp.\n")
    // [88] call printf_str
    // [318] phi from main::@43 to printf_str [phi:main::@43->printf_str]
    // [318] phi printf_str::s#124 = main::s3 [phi:main::@43->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // [89] phi from main::@43 to main::@44 [phi:main::@43->main::@44]
    // main::@44
    // printf( "4. bitmap - 640x480 - 2 bpp.\n")
    // [90] call printf_str
    // [318] phi from main::@44 to printf_str [phi:main::@44->printf_str]
    // [318] phi printf_str::s#124 = main::s4 [phi:main::@44->printf_str#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // [91] phi from main::@44 to main::@45 [phi:main::@44->main::@45]
    // main::@45
    // printf( "5. bitmap - 320x240 - 4 bpp.\n")
    // [92] call printf_str
    // [318] phi from main::@45 to printf_str [phi:main::@45->printf_str]
    // [318] phi printf_str::s#124 = main::s5 [phi:main::@45->printf_str#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // [93] phi from main::@45 to main::@46 [phi:main::@45->main::@46]
    // main::@46
    // printf( "6. bitmap - 320x240 - 8 bpp.\n")
    // [94] call printf_str
    // [318] phi from main::@46 to printf_str [phi:main::@46->printf_str]
    // [318] phi printf_str::s#124 = main::s6 [phi:main::@46->printf_str#0] -- pbuz1=pbuc1 
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    jsr printf_str
    // [95] phi from main::@46 to main::@47 [phi:main::@46->main::@47]
    // main::@47
    // printf( "\na. text - 8x8 - 1 bpp, 16c.\n")
    // [96] call printf_str
    // [318] phi from main::@47 to printf_str [phi:main::@47->printf_str]
    // [318] phi printf_str::s#124 = main::s7 [phi:main::@47->printf_str#0] -- pbuz1=pbuc1 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // [97] phi from main::@47 to main::@48 [phi:main::@47->main::@48]
    // main::@48
    // printf( "b. text - 8x8 - 1 bpp, 256c.\n")
    // [98] call printf_str
    // [318] phi from main::@48 to printf_str [phi:main::@48->printf_str]
    // [318] phi printf_str::s#124 = main::s8 [phi:main::@48->printf_str#0] -- pbuz1=pbuc1 
    lda #<s8
    sta.z printf_str.s
    lda #>s8
    sta.z printf_str.s+1
    jsr printf_str
    // [99] phi from main::@48 to main::@49 [phi:main::@48->main::@49]
    // main::@49
    // printf( "\nc. tile - 8x8 - 2 bpp.\n")
    // [100] call printf_str
    // [318] phi from main::@49 to printf_str [phi:main::@49->printf_str]
    // [318] phi printf_str::s#124 = main::s9 [phi:main::@49->printf_str#0] -- pbuz1=pbuc1 
    lda #<s9
    sta.z printf_str.s
    lda #>s9
    sta.z printf_str.s+1
    jsr printf_str
    // [101] phi from main::@49 to main::@50 [phi:main::@49->main::@50]
    // main::@50
    // printf( "d. tile - 16x16 - 2 bpp.\n")
    // [102] call printf_str
    // [318] phi from main::@50 to printf_str [phi:main::@50->printf_str]
    // [318] phi printf_str::s#124 = main::s10 [phi:main::@50->printf_str#0] -- pbuz1=pbuc1 
    lda #<s10
    sta.z printf_str.s
    lda #>s10
    sta.z printf_str.s+1
    jsr printf_str
    // [103] phi from main::@50 to main::@51 [phi:main::@50->main::@51]
    // main::@51
    // printf( "e. tile - 8x8 - 4 bpp.\n")
    // [104] call printf_str
    // [318] phi from main::@51 to printf_str [phi:main::@51->printf_str]
    // [318] phi printf_str::s#124 = main::s11 [phi:main::@51->printf_str#0] -- pbuz1=pbuc1 
    lda #<s11
    sta.z printf_str.s
    lda #>s11
    sta.z printf_str.s+1
    jsr printf_str
    // [105] phi from main::@51 to main::@52 [phi:main::@51->main::@52]
    // main::@52
    // printf( "f. tile - 16x16 - 4 bpp.\n")
    // [106] call printf_str
    // [318] phi from main::@52 to printf_str [phi:main::@52->printf_str]
    // [318] phi printf_str::s#124 = main::s12 [phi:main::@52->printf_str#0] -- pbuz1=pbuc1 
    lda #<s12
    sta.z printf_str.s
    lda #>s12
    sta.z printf_str.s+1
    jsr printf_str
    // [107] phi from main::@52 to main::@53 [phi:main::@52->main::@53]
    // main::@53
    // printf( "g. tile - 8x8 - 8 bpp.\n")
    // [108] call printf_str
    // [318] phi from main::@53 to printf_str [phi:main::@53->printf_str]
    // [318] phi printf_str::s#124 = main::s13 [phi:main::@53->printf_str#0] -- pbuz1=pbuc1 
    lda #<s13
    sta.z printf_str.s
    lda #>s13
    sta.z printf_str.s+1
    jsr printf_str
    // [109] phi from main::@53 to main::@54 [phi:main::@53->main::@54]
    // main::@54
    // printf( "h. tile - 16x16 - 8 bpp.\n")
    // [110] call printf_str
    // [318] phi from main::@54 to printf_str [phi:main::@54->printf_str]
    // [318] phi printf_str::s#124 = main::s14 [phi:main::@54->printf_str#0] -- pbuz1=pbuc1 
    lda #<s14
    sta.z printf_str.s
    lda #>s14
    sta.z printf_str.s+1
    jsr printf_str
    // [111] phi from main::@54 to main::@55 [phi:main::@54->main::@55]
    // main::@55
    // printf( "\n0. exit.\n")
    // [112] call printf_str
    // [318] phi from main::@55 to printf_str [phi:main::@55->printf_str]
    // [318] phi printf_str::s#124 = main::s15 [phi:main::@55->printf_str#0] -- pbuz1=pbuc1 
    lda #<s15
    sta.z printf_str.s
    lda #>s15
    sta.z printf_str.s+1
    jsr printf_str
    // [113] phi from main::@55 to main::@2 [phi:main::@55->main::@2]
    // [113] phi main::menu#10 = 0 [phi:main::@55->main::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z menu
    // main::@2
  __b2:
    // while(menu==0)
    // [114] if(main::menu#10==0) goto main::@3 -- vbuz1_eq_0_then_la1 
    lda.z menu
    bne !__b3+
    jmp __b3
  !__b3:
    // [115] phi from main::@2 to main::@4 [phi:main::@2->main::@4]
    // main::@4
    // textcolor(WHITE)
    // [116] call textcolor
    // [274] phi from main::@4 to textcolor [phi:main::@4->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:main::@4->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [117] phi from main::@4 to main::@57 [phi:main::@4->main::@57]
    // main::@57
    // bgcolor(BLACK)
    // [118] call bgcolor
    // [279] phi from main::@57 to bgcolor [phi:main::@57->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:main::@57->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [119] phi from main::@57 to main::@58 [phi:main::@57->main::@58]
    // main::@58
    // clrscr()
    // [120] call clrscr
    jsr clrscr
    // main::@59
    // case 49:
    //                 bitmap_320_x_240_1BPP();
    //                 break;
    // [121] if(main::menu#10==$31) goto main::@18 -- vbuz1_eq_vbuc1_then_la1 
    lda #$31
    cmp.z menu
    bne !__b18+
    jmp __b18
  !__b18:
    // main::@5
    // case 50:
    //                 bitmap_640_x_480_1BPP();
    //                 break;
    // [122] if(main::menu#10==$32) goto main::@19 -- vbuz1_eq_vbuc1_then_la1 
    lda #$32
    cmp.z menu
    bne !__b19+
    jmp __b19
  !__b19:
    // main::@6
    // case 51:
    //                 bitmap_320_x_240_2BPP();
    //                 break;
    // [123] if(main::menu#10==$33) goto main::@20 -- vbuz1_eq_vbuc1_then_la1 
    lda #$33
    cmp.z menu
    bne !__b20+
    jmp __b20
  !__b20:
    // main::@7
    // case 52:
    //                 bitmap_640_x_480_2BPP();
    //                 break;
    // [124] if(main::menu#10==$34) goto main::@21 -- vbuz1_eq_vbuc1_then_la1 
    lda #$34
    cmp.z menu
    bne !__b21+
    jmp __b21
  !__b21:
    // main::@8
    // case 53:
    //                 bitmap_320_x_240_4BPP();
    //                 break;
    // [125] if(main::menu#10==$35) goto main::@22 -- vbuz1_eq_vbuc1_then_la1 
    lda #$35
    cmp.z menu
    bne !__b22+
    jmp __b22
  !__b22:
    // main::@9
    // case 54:
    //                 bitmap_320_x_240_8BPP();
    //                 break;
    // [126] if(main::menu#10==$36) goto main::@23 -- vbuz1_eq_vbuc1_then_la1 
    lda #$36
    cmp.z menu
    bne !__b23+
    jmp __b23
  !__b23:
    // main::@10
    // case 65:
    //                 text_8_x_8_1BPP_16_color();
    //                 break;
    // [127] if(main::menu#10==$41) goto main::@24 -- vbuz1_eq_vbuc1_then_la1 
    lda #$41
    cmp.z menu
    bne !__b24+
    jmp __b24
  !__b24:
    // main::@11
    // case 66:
    //                 text_8_x_8_1BPP_256_color();
    //                 break;
    // [128] if(main::menu#10==$42) goto main::@25 -- vbuz1_eq_vbuc1_then_la1 
    lda #$42
    cmp.z menu
    bne !__b25+
    jmp __b25
  !__b25:
    // main::@12
    // case 67:
    //                 tile_8_x_8_2BPP_4_color();
    //                 break;
    // [129] if(main::menu#10==$43) goto main::@26 -- vbuz1_eq_vbuc1_then_la1 
    lda #$43
    cmp.z menu
    bne !__b26+
    jmp __b26
  !__b26:
    // main::@13
    // case 68:
    //                 tile_16_x_16_2BPP_4_color();
    //                 break;
    // [130] if(main::menu#10==$44) goto main::@27 -- vbuz1_eq_vbuc1_then_la1 
    lda #$44
    cmp.z menu
    bne !__b27+
    jmp __b27
  !__b27:
    // main::@14
    // case 69:
    //                 tile_8_x_8_4BPP_16_color();
    //                 break;
    // [131] if(main::menu#10==$45) goto main::@28 -- vbuz1_eq_vbuc1_then_la1 
    lda #$45
    cmp.z menu
    bne !__b28+
    jmp __b28
  !__b28:
    // main::@15
    // case 70:
    //                 tile_16_x_16_4BPP_16_color();
    //                 break;
    // [132] if(main::menu#10==$46) goto main::@29 -- vbuz1_eq_vbuc1_then_la1 
    lda #$46
    cmp.z menu
    beq __b29
    // main::@16
    // case 71:
    //                 tile_8_x_8_8BPP_256_color();
    //                 break;
    // [133] if(main::menu#10==$47) goto main::@30 -- vbuz1_eq_vbuc1_then_la1 
    lda #$47
    cmp.z menu
    beq __b30
    // main::@17
    // case 72:
    //                 tile_16_x_16_8BPP_256_color();
    //                 break;
    // [134] if(main::menu#10==$48) goto main::@31 -- vbuz1_eq_vbuc1_then_la1 
    lda #$48
    cmp.z menu
    beq __b31
    // [137] phi from main::@17 main::@18 main::@19 main::@20 main::@21 main::@22 main::@23 main::@24 main::@25 main::@26 main::@27 main::@28 main::@29 main::@30 main::@31 to main::@32 [phi:main::@17/main::@18/main::@19/main::@20/main::@21/main::@22/main::@23/main::@24/main::@25/main::@26/main::@27/main::@28/main::@29/main::@30/main::@31->main::@32]
    // [137] phi rem16u#10 = rem16u#236 [phi:main::@17/main::@18/main::@19/main::@20/main::@21/main::@22/main::@23/main::@24/main::@25/main::@26/main::@27/main::@28/main::@29/main::@30/main::@31->main::@32#0] -- register_copy 
    // [137] phi rand_state#10 = rand_state#246 [phi:main::@17/main::@18/main::@19/main::@20/main::@21/main::@22/main::@23/main::@24/main::@25/main::@26/main::@27/main::@28/main::@29/main::@30/main::@31->main::@32#1] -- register_copy 
    jmp __b32
    // [135] phi from main::@17 to main::@31 [phi:main::@17->main::@31]
    // main::@31
  __b31:
    // tile_16_x_16_8BPP_256_color()
    // [136] call tile_16_x_16_8BPP_256_color
    // [327] phi from main::@31 to tile_16_x_16_8BPP_256_color [phi:main::@31->tile_16_x_16_8BPP_256_color]
    jsr tile_16_x_16_8BPP_256_color
    // main::@32
  __b32:
    // main::vera_layer_hide1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [138] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // ~vera_layer_enable[layer]
    // [139] main::vera_layer_hide1_$0 = ~ *vera_layer_enable -- vbuz1=_bnot__deref_pbuc1 
    lda vera_layer_enable
    eor #$ff
    sta.z vera_layer_hide1___0
    // *VERA_DC_VIDEO &= ~vera_layer_enable[layer]
    // [140] *VERA_DC_VIDEO = *VERA_DC_VIDEO & main::vera_layer_hide1_$0 -- _deref_pbuc1=_deref_pbuc1_band_vbuz1 
    lda VERA_DC_VIDEO
    and.z vera_layer_hide1___0
    sta VERA_DC_VIDEO
    // [141] phi from main::vera_layer_hide1 to main::@35 [phi:main::vera_layer_hide1->main::@35]
    // main::@35
    // vera_layer_mode_text(1, 0x00000, 0x0f800, 64, 64, 8, 8, 4)
    // [142] call vera_layer_mode_text
    // [185] phi from main::@35 to vera_layer_mode_text [phi:main::@35->vera_layer_mode_text]
    // [185] phi vera_layer_mode_text::color_mode#11 = 4 [phi:main::@35->vera_layer_mode_text#0] -- vwuz1=vbuc1 
    lda #<4
    sta.z vera_layer_mode_text.color_mode
    lda #>4
    sta.z vera_layer_mode_text.color_mode+1
    // [185] phi vera_layer_mode_text::mapheight#11 = $40 [phi:main::@35->vera_layer_mode_text#1] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_text.mapheight
    lda #>$40
    sta.z vera_layer_mode_text.mapheight+1
    // [185] phi vera_layer_mode_text::mapwidth#11 = $40 [phi:main::@35->vera_layer_mode_text#2] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_text.mapwidth
    lda #>$40
    sta.z vera_layer_mode_text.mapwidth+1
    jsr vera_layer_mode_text
    // main::vera_layer_show2
    // *VERA_CTRL &= ~VERA_DCSEL
    // [143] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [144] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *(vera_layer_enable+main::vera_layer_show2_layer#0) -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable+vera_layer_show2_layer
    sta VERA_DC_VIDEO
    // [145] phi from main::vera_layer_show2 to main::@36 [phi:main::vera_layer_show2->main::@36]
    // main::@36
    // screenlayer(1)
    // [146] call screenlayer
    jsr screenlayer
    // [147] phi from main::@36 to main::@60 [phi:main::@36->main::@60]
    // main::@60
    // textcolor(WHITE)
    // [148] call textcolor
    // [274] phi from main::@60 to textcolor [phi:main::@60->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:main::@60->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [149] phi from main::@60 to main::@61 [phi:main::@60->main::@61]
    // main::@61
    // bgcolor(BLUE)
    // [150] call bgcolor
    // [279] phi from main::@61 to bgcolor [phi:main::@61->bgcolor]
    // [279] phi bgcolor::color#26 = BLUE [phi:main::@61->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLUE
    sta.z bgcolor.color
    jsr bgcolor
    // [151] phi from main::@61 to main::@62 [phi:main::@61->main::@62]
    // main::@62
    // clrscr()
    // [152] call clrscr
    jsr clrscr
    // main::@33
    // while( menu != 48 )
    // [153] if(main::menu#10!=$30) goto main::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #$30
    cmp.z menu
    beq !__b1+
    jmp __b1
  !__b1:
    // main::@return
    // }
    // [154] return 
    rts
    // [155] phi from main::@16 to main::@30 [phi:main::@16->main::@30]
    // main::@30
  __b30:
    // tile_8_x_8_8BPP_256_color()
    // [156] call tile_8_x_8_8BPP_256_color
    // [430] phi from main::@30 to tile_8_x_8_8BPP_256_color [phi:main::@30->tile_8_x_8_8BPP_256_color]
    jsr tile_8_x_8_8BPP_256_color
    jmp __b32
    // [157] phi from main::@15 to main::@29 [phi:main::@15->main::@29]
    // main::@29
  __b29:
    // tile_16_x_16_4BPP_16_color()
    // [158] call tile_16_x_16_4BPP_16_color
    // [514] phi from main::@29 to tile_16_x_16_4BPP_16_color [phi:main::@29->tile_16_x_16_4BPP_16_color]
    jsr tile_16_x_16_4BPP_16_color
    jmp __b32
    // [159] phi from main::@14 to main::@28 [phi:main::@14->main::@28]
    // main::@28
  __b28:
    // tile_8_x_8_4BPP_16_color()
    // [160] call tile_8_x_8_4BPP_16_color
    // [609] phi from main::@28 to tile_8_x_8_4BPP_16_color [phi:main::@28->tile_8_x_8_4BPP_16_color]
    jsr tile_8_x_8_4BPP_16_color
    jmp __b32
    // [161] phi from main::@13 to main::@27 [phi:main::@13->main::@27]
    // main::@27
  __b27:
    // tile_16_x_16_2BPP_4_color()
    // [162] call tile_16_x_16_2BPP_4_color
    // [704] phi from main::@27 to tile_16_x_16_2BPP_4_color [phi:main::@27->tile_16_x_16_2BPP_4_color]
    jsr tile_16_x_16_2BPP_4_color
    jmp __b32
    // [163] phi from main::@12 to main::@26 [phi:main::@12->main::@26]
    // main::@26
  __b26:
    // tile_8_x_8_2BPP_4_color()
    // [164] call tile_8_x_8_2BPP_4_color
    // [782] phi from main::@26 to tile_8_x_8_2BPP_4_color [phi:main::@26->tile_8_x_8_2BPP_4_color]
    jsr tile_8_x_8_2BPP_4_color
    jmp __b32
    // [165] phi from main::@11 to main::@25 [phi:main::@11->main::@25]
    // main::@25
  __b25:
    // text_8_x_8_1BPP_256_color()
    // [166] call text_8_x_8_1BPP_256_color
    // [852] phi from main::@25 to text_8_x_8_1BPP_256_color [phi:main::@25->text_8_x_8_1BPP_256_color]
    jsr text_8_x_8_1BPP_256_color
    jmp __b32
    // [167] phi from main::@10 to main::@24 [phi:main::@10->main::@24]
    // main::@24
  __b24:
    // text_8_x_8_1BPP_16_color()
    // [168] call text_8_x_8_1BPP_16_color
    // [891] phi from main::@24 to text_8_x_8_1BPP_16_color [phi:main::@24->text_8_x_8_1BPP_16_color]
    jsr text_8_x_8_1BPP_16_color
    jmp __b32
    // [169] phi from main::@9 to main::@23 [phi:main::@9->main::@23]
    // main::@23
  __b23:
    // bitmap_320_x_240_8BPP()
    // [170] call bitmap_320_x_240_8BPP
    // [936] phi from main::@23 to bitmap_320_x_240_8BPP [phi:main::@23->bitmap_320_x_240_8BPP]
    jsr bitmap_320_x_240_8BPP
    jmp __b32
    // [171] phi from main::@8 to main::@22 [phi:main::@8->main::@22]
    // main::@22
  __b22:
    // bitmap_320_x_240_4BPP()
    // [172] call bitmap_320_x_240_4BPP
    // [1039] phi from main::@22 to bitmap_320_x_240_4BPP [phi:main::@22->bitmap_320_x_240_4BPP]
    jsr bitmap_320_x_240_4BPP
    jmp __b32
    // [173] phi from main::@7 to main::@21 [phi:main::@7->main::@21]
    // main::@21
  __b21:
    // bitmap_640_x_480_2BPP()
    // [174] call bitmap_640_x_480_2BPP
    // [1145] phi from main::@21 to bitmap_640_x_480_2BPP [phi:main::@21->bitmap_640_x_480_2BPP]
    jsr bitmap_640_x_480_2BPP
    jmp __b32
    // [175] phi from main::@6 to main::@20 [phi:main::@6->main::@20]
    // main::@20
  __b20:
    // bitmap_320_x_240_2BPP()
    // [176] call bitmap_320_x_240_2BPP
    // [1251] phi from main::@20 to bitmap_320_x_240_2BPP [phi:main::@20->bitmap_320_x_240_2BPP]
    jsr bitmap_320_x_240_2BPP
    jmp __b32
    // [177] phi from main::@5 to main::@19 [phi:main::@5->main::@19]
    // main::@19
  __b19:
    // bitmap_640_x_480_1BPP()
    // [178] call bitmap_640_x_480_1BPP
    // [1357] phi from main::@19 to bitmap_640_x_480_1BPP [phi:main::@19->bitmap_640_x_480_1BPP]
    jsr bitmap_640_x_480_1BPP
    jmp __b32
    // [179] phi from main::@59 to main::@18 [phi:main::@59->main::@18]
    // main::@18
  __b18:
    // bitmap_320_x_240_1BPP()
    // [180] call bitmap_320_x_240_1BPP
    // [1466] phi from main::@18 to bitmap_320_x_240_1BPP [phi:main::@18->bitmap_320_x_240_1BPP]
    jsr bitmap_320_x_240_1BPP
    jmp __b32
    // [181] phi from main::@2 to main::@3 [phi:main::@2->main::@3]
    // main::@3
  __b3:
    // getin()
    // [182] call getin
    jsr getin
    // [183] getin::return#2 = getin::return#1 -- vbuz1=vbuz2 
    lda.z getin.return
    sta.z getin.return_1
    // main::@56
    // menu = getin()
    // [184] main::menu#1 = getin::return#2
    // [113] phi from main::@56 to main::@2 [phi:main::@56->main::@2]
    // [113] phi main::menu#10 = main::menu#1 [phi:main::@56->main::@2#0] -- register_copy 
    jmp __b2
  .segment Data
    s: .text @"\n *** vera modes demo - v1.0.1 ***\n\n"
    .byte 0
    s1: .text @"1. bitmap - 320x240 - 1 bpp.\n"
    .byte 0
    s2: .text @"2. bitmap - 640x480 - 1 bpp.\n"
    .byte 0
    s3: .text @"3. bitmap - 320x240 - 2 bpp.\n"
    .byte 0
    s4: .text @"4. bitmap - 640x480 - 2 bpp.\n"
    .byte 0
    s5: .text @"5. bitmap - 320x240 - 4 bpp.\n"
    .byte 0
    s6: .text @"6. bitmap - 320x240 - 8 bpp.\n"
    .byte 0
    s7: .text @"\na. text - 8x8 - 1 bpp, 16c.\n"
    .byte 0
    s8: .text @"b. text - 8x8 - 1 bpp, 256c.\n"
    .byte 0
    s9: .text @"\nc. tile - 8x8 - 2 bpp.\n"
    .byte 0
    s10: .text @"d. tile - 16x16 - 2 bpp.\n"
    .byte 0
    s11: .text @"e. tile - 8x8 - 4 bpp.\n"
    .byte 0
    s12: .text @"f. tile - 16x16 - 4 bpp.\n"
    .byte 0
    s13: .text @"g. tile - 8x8 - 8 bpp.\n"
    .byte 0
    s14: .text @"h. tile - 16x16 - 8 bpp.\n"
    .byte 0
    s15: .text @"\n0. exit.\n"
    .byte 0
}
.segment Code
  // vera_layer_mode_text
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
// void vera_layer_mode_text(char layer, unsigned long mapbase_address, unsigned long tilebase_address, __zp($dc) unsigned int mapwidth, __zp($e2) unsigned int mapheight, char tilewidth, char tileheight, __zp($e6) unsigned int color_mode)
vera_layer_mode_text: {
    .label mapwidth = $dc
    .label mapheight = $e2
    .label color_mode = $e6
    // vera_layer_mode_tile( layer, mapbase_address, tilebase_address, mapwidth, mapheight, tilewidth, tileheight, 1 )
    // [186] vera_layer_mode_tile::mapwidth#0 = vera_layer_mode_text::mapwidth#11
    // [187] vera_layer_mode_tile::mapheight#0 = vera_layer_mode_text::mapheight#11
    // [188] call vera_layer_mode_tile
    // [1580] phi from vera_layer_mode_text to vera_layer_mode_tile [phi:vera_layer_mode_text->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = 8 [phi:vera_layer_mode_text->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = 8 [phi:vera_layer_mode_text->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $f800 [phi:vera_layer_mode_text->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$f800
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$f800
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$f800>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$f800>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = 0 [phi:vera_layer_mode_text->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<0
    sta.z vera_layer_mode_tile.mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<0>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>0>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = vera_layer_mode_tile::mapheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#4] -- register_copy 
    // [1580] phi vera_layer_mode_tile::layer#14 = 1 [phi:vera_layer_mode_text->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = vera_layer_mode_tile::mapwidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#6] -- register_copy 
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 1 [phi:vera_layer_mode_text->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // vera_layer_mode_text::@4
    // case 16:
    //             vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C );
    //             break;
    // [189] if(vera_layer_mode_text::color_mode#11==$10) goto vera_layer_mode_text::@2 -- vwuz1_eq_vbuc1_then_la1 
    lda.z color_mode+1
    bne !+
    lda.z color_mode
    cmp #$10
    beq __b2
  !:
    // vera_layer_mode_text::@1
    // case 256:
    //             vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_256C );
    //             break;
    // [190] if(vera_layer_mode_text::color_mode#11==$100) goto vera_layer_mode_text::@3 -- vwuz1_eq_vwuc1_then_la1 
    lda.z color_mode
    cmp #<$100
    bne !+
    lda.z color_mode+1
    cmp #>$100
    beq __b3
  !:
    rts
    // [191] phi from vera_layer_mode_text::@1 to vera_layer_mode_text::@3 [phi:vera_layer_mode_text::@1->vera_layer_mode_text::@3]
    // vera_layer_mode_text::@3
  __b3:
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_256C )
    // [192] call vera_layer_set_text_color_mode
    // [1650] phi from vera_layer_mode_text::@3 to vera_layer_set_text_color_mode [phi:vera_layer_mode_text::@3->vera_layer_set_text_color_mode]
    // [1650] phi vera_layer_set_text_color_mode::color_mode#2 = VERA_LAYER_CONFIG_256C [phi:vera_layer_mode_text::@3->vera_layer_set_text_color_mode#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_CONFIG_256C
    sta.z vera_layer_set_text_color_mode.color_mode
    jsr vera_layer_set_text_color_mode
    // vera_layer_mode_text::@return
    // }
    // [193] return 
    rts
    // [194] phi from vera_layer_mode_text::@4 to vera_layer_mode_text::@2 [phi:vera_layer_mode_text::@4->vera_layer_mode_text::@2]
    // vera_layer_mode_text::@2
  __b2:
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C )
    // [195] call vera_layer_set_text_color_mode
    // [1650] phi from vera_layer_mode_text::@2 to vera_layer_set_text_color_mode [phi:vera_layer_mode_text::@2->vera_layer_set_text_color_mode]
    // [1650] phi vera_layer_set_text_color_mode::color_mode#2 = VERA_LAYER_CONFIG_16C [phi:vera_layer_mode_text::@2->vera_layer_set_text_color_mode#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_CONFIG_16C
    sta.z vera_layer_set_text_color_mode.color_mode
    jsr vera_layer_set_text_color_mode
    rts
}
  // screensize
// Return the current screen size.
// void screensize(char *x, char *y)
screensize: {
    .label x = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    .label y = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    .label __1 = $77
    .label __3 = $ea
    .label hscale = $77
    .label vscale = $ea
    // char hscale = (*VERA_DC_HSCALE) >> 7
    // [196] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
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
    // [197] screensize::$1 = $28 << screensize::hscale#0 -- vbuz1=vbuc1_rol_vbuz1 
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
    // [198] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbuz1 
    sta x
    // char vscale = (*VERA_DC_VSCALE) >> 7
    // [199] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    sta.z vscale
    // 30 << vscale
    // [200] screensize::$3 = $1e << screensize::vscale#0 -- vbuz1=vbuc1_rol_vbuz1 
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
    // [201] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbuz1 
    sta y
    // screensize::@return
    // }
    // [202] return 
    rts
}
  // screenlayer
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
// void screenlayer(char layer)
screenlayer: {
    .label __0 = $e0
    .label __1 = $dc
    .label vera_layer_get_width1___0 = $b0
    .label vera_layer_get_width1___1 = $b0
    .label vera_layer_get_width1___3 = $b0
    .label vera_layer_get_height1___0 = $b1
    .label vera_layer_get_height1___1 = $b1
    .label vera_layer_get_height1___3 = $b1
    .label vera_layer_get_width1_config = $e2
    .label vera_layer_get_width1_return = $e6
    .label vera_layer_get_height1_config = $a9
    .label vera_layer_get_height1_return = $3a
    .label vera_layer_get_rowshift1_return = $44
    .label vera_layer_get_rowskip1_return = $de
    // cx16_conio.conio_screen_layer = layer
    // [203] *((char *)&cx16_conio) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta cx16_conio
    // vera_layer_get_mapbase_bank(layer)
    // [204] call vera_layer_get_mapbase_bank
    jsr vera_layer_get_mapbase_bank
    // [205] vera_layer_get_mapbase_bank::return#2 = vera_layer_get_mapbase_bank::return#0
    // screenlayer::@5
    // [206] screenlayer::$0 = vera_layer_get_mapbase_bank::return#2
    // cx16_conio.conio_screen_bank = vera_layer_get_mapbase_bank(layer)
    // [207] *((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) = screenlayer::$0 -- _deref_pbuc1=vbuz1 
    lda.z __0
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // vera_layer_get_mapbase_offset(layer)
    // [208] call vera_layer_get_mapbase_offset
    jsr vera_layer_get_mapbase_offset
    // [209] vera_layer_get_mapbase_offset::return#2 = vera_layer_get_mapbase_offset::return#0
    // screenlayer::@6
    // [210] screenlayer::$1 = vera_layer_get_mapbase_offset::return#2
    // cx16_conio.conio_screen_text = vera_layer_get_mapbase_offset(layer)
    // [211] *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) = screenlayer::$1 -- _deref_pwuc1=vwuz1 
    lda.z __1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    lda.z __1+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    // screenlayer::vera_layer_get_width1
    // char* config = vera_layer_config[layer]
    // [212] screenlayer::vera_layer_get_width1_config#0 = *(vera_layer_config+1<<1) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+(1<<1)
    sta.z vera_layer_get_width1_config
    lda vera_layer_config+(1<<1)+1
    sta.z vera_layer_get_width1_config+1
    // *config & VERA_LAYER_WIDTH_MASK
    // [213] screenlayer::vera_layer_get_width1_$0 = *screenlayer::vera_layer_get_width1_config#0 & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    ldy #0
    and (vera_layer_get_width1_config),y
    sta.z vera_layer_get_width1___0
    // (*config & VERA_LAYER_WIDTH_MASK) >> 4
    // [214] screenlayer::vera_layer_get_width1_$1 = screenlayer::vera_layer_get_width1_$0 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z vera_layer_get_width1___1
    lsr
    lsr
    lsr
    lsr
    sta.z vera_layer_get_width1___1
    // return VERA_LAYER_WIDTH[ (*config & VERA_LAYER_WIDTH_MASK) >> 4];
    // [215] screenlayer::vera_layer_get_width1_$3 = screenlayer::vera_layer_get_width1_$1 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z vera_layer_get_width1___3
    // [216] screenlayer::vera_layer_get_width1_return#0 = VERA_LAYER_WIDTH[screenlayer::vera_layer_get_width1_$3] -- vwuz1=pwuc1_derefidx_vbuz2 
    ldy.z vera_layer_get_width1___3
    lda VERA_LAYER_WIDTH,y
    sta.z vera_layer_get_width1_return
    lda VERA_LAYER_WIDTH+1,y
    sta.z vera_layer_get_width1_return+1
    // screenlayer::@1
    // cx16_conio.conio_map_width = vera_layer_get_width(layer)
    // [217] *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) = screenlayer::vera_layer_get_width1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_width1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    lda.z vera_layer_get_width1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    // screenlayer::vera_layer_get_height1
    // char* config = vera_layer_config[layer]
    // [218] screenlayer::vera_layer_get_height1_config#0 = *(vera_layer_config+1<<1) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+(1<<1)
    sta.z vera_layer_get_height1_config
    lda vera_layer_config+(1<<1)+1
    sta.z vera_layer_get_height1_config+1
    // *config & VERA_LAYER_HEIGHT_MASK
    // [219] screenlayer::vera_layer_get_height1_$0 = *screenlayer::vera_layer_get_height1_config#0 & VERA_LAYER_HEIGHT_MASK -- vbuz1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    ldy #0
    and (vera_layer_get_height1_config),y
    sta.z vera_layer_get_height1___0
    // (*config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [220] screenlayer::vera_layer_get_height1_$1 = screenlayer::vera_layer_get_height1_$0 >> 6 -- vbuz1=vbuz1_ror_6 
    lda.z vera_layer_get_height1___1
    rol
    rol
    rol
    and #3
    sta.z vera_layer_get_height1___1
    // return VERA_LAYER_HEIGHT[ (*config & VERA_LAYER_HEIGHT_MASK) >> 6];
    // [221] screenlayer::vera_layer_get_height1_$3 = screenlayer::vera_layer_get_height1_$1 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z vera_layer_get_height1___3
    // [222] screenlayer::vera_layer_get_height1_return#0 = VERA_LAYER_HEIGHT[screenlayer::vera_layer_get_height1_$3] -- vwuz1=pwuc1_derefidx_vbuz2 
    ldy.z vera_layer_get_height1___3
    lda VERA_LAYER_HEIGHT,y
    sta.z vera_layer_get_height1_return
    lda VERA_LAYER_HEIGHT+1,y
    sta.z vera_layer_get_height1_return+1
    // screenlayer::@2
    // cx16_conio.conio_map_height = vera_layer_get_height(layer)
    // [223] *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) = screenlayer::vera_layer_get_height1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_height1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    lda.z vera_layer_get_height1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    // screenlayer::vera_layer_get_rowshift1
    // return vera_layer_rowshift[layer];
    // [224] screenlayer::vera_layer_get_rowshift1_return#0 = *(vera_layer_rowshift+1) -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift+1
    sta.z vera_layer_get_rowshift1_return
    // screenlayer::@3
    // cx16_conio.conio_rowshift = vera_layer_get_rowshift(layer)
    // [225] *((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) = screenlayer::vera_layer_get_rowshift1_return#0 -- _deref_pbuc1=vbuz1 
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
    // screenlayer::vera_layer_get_rowskip1
    // return vera_layer_rowskip[layer];
    // [226] screenlayer::vera_layer_get_rowskip1_return#0 = *(vera_layer_rowskip+1<<1) -- vwuz1=_deref_pwuc1 
    lda vera_layer_rowskip+(1<<1)
    sta.z vera_layer_get_rowskip1_return
    lda vera_layer_rowskip+(1<<1)+1
    sta.z vera_layer_get_rowskip1_return+1
    // screenlayer::@4
    // cx16_conio.conio_rowskip = vera_layer_get_rowskip(layer)
    // [227] *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) = screenlayer::vera_layer_get_rowskip1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_rowskip1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    lda.z vera_layer_get_rowskip1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    // screenlayer::@return
    // }
    // [228] return 
    rts
}
  // vera_layer_set_textcolor
/**
 * @brief Set the front color for text output. The old front text color setting is returned.
 *
 * @param layer The layer of the vera 0/1.
 * @param color a 4 bit value ( decimal between 0 and 15) when the VERA works in 16x16 color text mode.
 * An 8 bit value (decimal between 0 and 255) when the VERA works in 256 text mode.
 * Note that on the VERA, the transparent color has value 0.
 * @return vera_forecolor
 */
// char vera_layer_set_textcolor(__zp($6b) char layer, __zp($6c) char color)
vera_layer_set_textcolor: {
    .label layer = $6b
    .label color = $6c
    // vera_layer_textcolor[layer] = color
    // [230] vera_layer_textcolor[vera_layer_set_textcolor::layer#2] = vera_layer_set_textcolor::color#2 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z color
    ldy.z layer
    sta vera_layer_textcolor,y
    // vera_layer_set_textcolor::@return
    // }
    // [231] return 
    rts
}
  // vera_layer_set_backcolor
/**
 * @brief Set the back color for text output. The old back text color setting is returned.
 *
 * @param layer The layer of the vera 0/1.
 * @param color a 4 bit value ( decimal between 0 and 15).
 * This will only work when the VERA is in 16 color mode!
 * Note that on the VERA, the transparent color has value 0.
 * @return vera_backcolor
 */
// char vera_layer_set_backcolor(__zp($6b) char layer, __zp($6c) char color)
vera_layer_set_backcolor: {
    .label layer = $6b
    .label color = $6c
    // vera_layer_backcolor[layer] = color
    // [233] vera_layer_backcolor[vera_layer_set_backcolor::layer#2] = vera_layer_set_backcolor::color#2 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z color
    ldy.z layer
    sta vera_layer_backcolor,y
    // vera_layer_set_backcolor::@return
    // }
    // [234] return 
    rts
}
  // vera_layer_set_mapbase
/**
 * @brief Set the base of the map layer with which the conio will interact.
 *
 * @param layer The layer of the vera 0/1.
 * @param mapbase Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:9 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
 *
 */
// void vera_layer_set_mapbase(__zp($6b) char layer, __zp($6c) char mapbase)
vera_layer_set_mapbase: {
    .label __0 = $6b
    .label addr = $a9
    .label layer = $6b
    .label mapbase = $6c
    // char* addr = vera_layer_mapbase[layer]
    // [236] vera_layer_set_mapbase::$0 = vera_layer_set_mapbase::layer#3 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __0
    // [237] vera_layer_set_mapbase::addr#0 = vera_layer_mapbase[vera_layer_set_mapbase::$0] -- pbuz1=qbuc1_derefidx_vbuz2 
    ldy.z __0
    lda vera_layer_mapbase,y
    sta.z addr
    lda vera_layer_mapbase+1,y
    sta.z addr+1
    // *addr = mapbase
    // [238] *vera_layer_set_mapbase::addr#0 = vera_layer_set_mapbase::mapbase#3 -- _deref_pbuz1=vbuz2 
    lda.z mapbase
    ldy #0
    sta (addr),y
    // vera_layer_set_mapbase::@return
    // }
    // [239] return 
    rts
}
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
// char cursor(char onoff)
cursor: {
    .const onoff = 0
    // cx16_conio.conio_display_cursor = onoff
    // [240] *((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR
    // cursor::@return
    // }
    // [241] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(char x, __zp($45) char y)
gotoxy: {
    .label __5 = $44
    .label __6 = $3a
    .label line_offset = $3a
    .label y = $45
    // if(y>cx16_conio.conio_screen_height)
    // [243] if(gotoxy::y#35<=*((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto gotoxy::@4 -- vbuz1_le__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    cmp.z y
    bcs __b1
    // [245] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [245] phi gotoxy::y#36 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z y
    // [244] phi from gotoxy to gotoxy::@4 [phi:gotoxy->gotoxy::@4]
    // gotoxy::@4
    // [245] phi from gotoxy::@4 to gotoxy::@1 [phi:gotoxy::@4->gotoxy::@1]
    // [245] phi gotoxy::y#36 = gotoxy::y#35 [phi:gotoxy::@4->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=cx16_conio.conio_screen_width)
    // [246] if(0<*((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto gotoxy::@2 -- 0_lt__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    // [247] phi from gotoxy::@1 to gotoxy::@3 [phi:gotoxy::@1->gotoxy::@3]
    // gotoxy::@3
    // gotoxy::@2
    // conio_cursor_x[cx16_conio.conio_screen_layer] = x
    // [248] conio_cursor_x[*((char *)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = y
    // [249] conio_cursor_y[*((char *)&cx16_conio)] = gotoxy::y#36 -- pbuc1_derefidx_(_deref_pbuc2)=vbuz1 
    lda.z y
    sta conio_cursor_y,y
    // unsigned int line_offset = (unsigned int)y << cx16_conio.conio_rowshift
    // [250] gotoxy::$6 = (unsigned int)gotoxy::y#36 -- vwuz1=_word_vbuz2 
    sta.z __6
    lda #0
    sta.z __6+1
    // [251] gotoxy::line_offset#0 = gotoxy::$6 << *((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vwuz1_rol__deref_pbuc1 
    ldy cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
    beq !e+
  !:
    asl.z line_offset
    rol.z line_offset+1
    dey
    bne !-
  !e:
    // conio_line_text[cx16_conio.conio_screen_layer] = line_offset
    // [252] gotoxy::$5 = *((char *)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __5
    // [253] conio_line_text[gotoxy::$5] = gotoxy::line_offset#0 -- pwuc1_derefidx_vbuz1=vwuz2 
    tay
    lda.z line_offset
    sta conio_line_text,y
    lda.z line_offset+1
    sta conio_line_text+1,y
    // gotoxy::@return
    // }
    // [254] return 
    rts
}
  // vera_layer_get_color
/**
 * @brief Get the text and back color for text output in 16 color mode.
 *
 * @param layer The layer of the vera 0/1.
 * @return vera_textcolor an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
 * This will only work when the VERA is in 16 color mode!
 * Note that on the VERA, the transparent color has value 0.
 */
// __zp($11) char vera_layer_get_color(__zp($11) char layer)
vera_layer_get_color: {
    .label __0 = $16
    .label __1 = $17
    .label __3 = $15
    .label addr = $13
    .label return = $11
    .label layer = $11
    // char* addr = vera_layer_config[layer]
    // [256] vera_layer_get_color::$3 = vera_layer_get_color::layer#2 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z layer
    asl
    sta.z __3
    // [257] vera_layer_get_color::addr#0 = vera_layer_config[vera_layer_get_color::$3] -- pbuz1=qbuc1_derefidx_vbuz2 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr & VERA_LAYER_CONFIG_256C
    // [258] vera_layer_get_color::$0 = *vera_layer_get_color::addr#0 & VERA_LAYER_CONFIG_256C -- vbuz1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C
    ldy #0
    and (addr),y
    sta.z __0
    // if( *addr & VERA_LAYER_CONFIG_256C )
    // [259] if(0!=vera_layer_get_color::$0) goto vera_layer_get_color::@1 -- 0_neq_vbuz1_then_la1 
    bne __b1
    // vera_layer_get_color::@2
    // vera_layer_backcolor[layer] << 4
    // [260] vera_layer_get_color::$1 = vera_layer_backcolor[vera_layer_get_color::layer#2] << 4 -- vbuz1=pbuc1_derefidx_vbuz2_rol_4 
    ldy.z layer
    lda vera_layer_backcolor,y
    asl
    asl
    asl
    asl
    sta.z __1
    // return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
    // [261] vera_layer_get_color::return#1 = vera_layer_get_color::$1 | vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuz1=vbuz2_bor_pbuc1_derefidx_vbuz1 
    ldy.z return
    ora vera_layer_textcolor,y
    sta.z return
    // [262] phi from vera_layer_get_color::@1 vera_layer_get_color::@2 to vera_layer_get_color::@return [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return]
    // [262] phi vera_layer_get_color::return#2 = vera_layer_get_color::return#0 [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return#0] -- register_copy 
    // vera_layer_get_color::@return
    // }
    // [263] return 
    rts
    // vera_layer_get_color::@1
  __b1:
    // return (vera_layer_textcolor[layer]);
    // [264] vera_layer_get_color::return#0 = vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_textcolor,y
    sta.z return
    rts
}
  // cputln
// Print a newline
cputln: {
    .label __2 = $15
    .label __3 = $16
    .label temp = $32
    // unsigned int temp = conio_line_text[cx16_conio.conio_screen_layer]
    // [265] cputln::$2 = *((char *)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __2
    // [266] cputln::temp#0 = conio_line_text[cputln::$2] -- vwuz1=pwuc1_derefidx_vbuz2 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda conio_line_text,y
    sta.z temp
    lda conio_line_text+1,y
    sta.z temp+1
    // temp += cx16_conio.conio_rowskip
    // [267] cputln::temp#1 = cputln::temp#0 + *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z temp
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    sta.z temp
    lda.z temp+1
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    sta.z temp+1
    // conio_line_text[cx16_conio.conio_screen_layer] = temp
    // [268] cputln::$3 = *((char *)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __3
    // [269] conio_line_text[cputln::$3] = cputln::temp#1 -- pwuc1_derefidx_vbuz1=vwuz2 
    tay
    lda.z temp
    sta conio_line_text,y
    lda.z temp+1
    sta conio_line_text+1,y
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [270] conio_cursor_x[*((char *)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer]++;
    // [271] conio_cursor_y[*((char *)&cx16_conio)] = ++ conio_cursor_y[*((char *)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    lda conio_cursor_y,x
    inc
    sta conio_cursor_y,x
    // cscroll()
    // [272] call cscroll
    jsr cscroll
    // cputln::@return
    // }
    // [273] return 
    rts
}
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char textcolor(__zp($11) char color)
textcolor: {
    .label color = $11
    // vera_layer_set_textcolor(cx16_conio.conio_screen_layer, color)
    // [275] vera_layer_set_textcolor::layer#0 = *((char *)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_set_textcolor.layer
    // [276] vera_layer_set_textcolor::color#0 = textcolor::color#38 -- vbuz1=vbuz2 
    lda.z color
    sta.z vera_layer_set_textcolor.color
    // [277] call vera_layer_set_textcolor
    // [229] phi from textcolor to vera_layer_set_textcolor [phi:textcolor->vera_layer_set_textcolor]
    // [229] phi vera_layer_set_textcolor::color#2 = vera_layer_set_textcolor::color#0 [phi:textcolor->vera_layer_set_textcolor#0] -- register_copy 
    // [229] phi vera_layer_set_textcolor::layer#2 = vera_layer_set_textcolor::layer#0 [phi:textcolor->vera_layer_set_textcolor#1] -- register_copy 
    jsr vera_layer_set_textcolor
    // textcolor::@return
    // }
    // [278] return 
    rts
}
  // bgcolor
// Set the back color for text output. The old back text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor(__zp($11) char color)
bgcolor: {
    .label color = $11
    // vera_layer_set_backcolor(cx16_conio.conio_screen_layer, color)
    // [280] vera_layer_set_backcolor::layer#0 = *((char *)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_set_backcolor.layer
    // [281] vera_layer_set_backcolor::color#0 = bgcolor::color#26 -- vbuz1=vbuz2 
    lda.z color
    sta.z vera_layer_set_backcolor.color
    // [282] call vera_layer_set_backcolor
    // [232] phi from bgcolor to vera_layer_set_backcolor [phi:bgcolor->vera_layer_set_backcolor]
    // [232] phi vera_layer_set_backcolor::color#2 = vera_layer_set_backcolor::color#0 [phi:bgcolor->vera_layer_set_backcolor#0] -- register_copy 
    // [232] phi vera_layer_set_backcolor::layer#2 = vera_layer_set_backcolor::layer#0 [phi:bgcolor->vera_layer_set_backcolor#1] -- register_copy 
    jsr vera_layer_set_backcolor
    // bgcolor::@return
    // }
    // [283] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __0 = $10
    .label __1 = $10
    .label __2 = $16
    .label __5 = $67
    .label __6 = $66
    .label __7 = $64
    .label __9 = $17
    .label line_text = $4d
    .label color = $10
    .label conio_map_height = $5f
    .label conio_map_width = $4f
    .label c = $6a
    .label l = $11
    // unsigned int line_text = cx16_conio.conio_screen_text
    // [284] clrscr::line_text#0 = *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z line_text+1
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer)
    // [285] vera_layer_get_backcolor::layer#0 = *((char *)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_backcolor.layer
    // [286] call vera_layer_get_backcolor
    jsr vera_layer_get_backcolor
    // [287] vera_layer_get_backcolor::return#2 = vera_layer_get_backcolor::return#0
    // clrscr::@7
    // [288] clrscr::$0 = vera_layer_get_backcolor::return#2
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4
    // [289] clrscr::$1 = clrscr::$0 << 4 -- vbuz1=vbuz1_rol_4 
    lda.z __1
    asl
    asl
    asl
    asl
    sta.z __1
    // vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [290] vera_layer_get_textcolor::layer#0 = *((char *)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_textcolor.layer
    // [291] call vera_layer_get_textcolor
    jsr vera_layer_get_textcolor
    // [292] vera_layer_get_textcolor::return#2 = vera_layer_get_textcolor::return#0
    // clrscr::@8
    // [293] clrscr::$2 = vera_layer_get_textcolor::return#2
    // char color = ( vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4 ) | vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [294] clrscr::color#0 = clrscr::$1 | clrscr::$2 -- vbuz1=vbuz1_bor_vbuz2 
    lda.z color
    ora.z __2
    sta.z color
    // unsigned int conio_map_height = cx16_conio.conio_map_height
    // [295] clrscr::conio_map_height#0 = *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    sta.z conio_map_height
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    sta.z conio_map_height+1
    // unsigned int conio_map_width = cx16_conio.conio_map_width
    // [296] clrscr::conio_map_width#0 = *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // [297] phi from clrscr::@8 to clrscr::@1 [phi:clrscr::@8->clrscr::@1]
    // [297] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr::@8->clrscr::@1#0] -- register_copy 
    // [297] phi clrscr::l#2 = 0 [phi:clrscr::@8->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<conio_map_height; l++ )
    // [298] if(clrscr::l#2<clrscr::conio_map_height#0) goto clrscr::@2 -- vbuz1_lt_vwuz2_then_la1 
    lda.z conio_map_height+1
    bne __b2
    lda.z l
    cmp.z conio_map_height
    bcc __b2
    // clrscr::@3
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [299] conio_cursor_x[*((char *)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = 0
    // [300] conio_cursor_y[*((char *)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    sta conio_cursor_y,y
    // conio_line_text[cx16_conio.conio_screen_layer] = 0
    // [301] clrscr::$9 = *((char *)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    tya
    asl
    sta.z __9
    // [302] conio_line_text[clrscr::$9] = 0 -- pwuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z __9
    sta conio_line_text,y
    sta conio_line_text+1,y
    // clrscr::@return
    // }
    // [303] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [304] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(ch)
    // [305] clrscr::$5 = byte0  clrscr::line_text#2 -- vbuz1=_byte0_vwuz2 
    lda.z line_text
    sta.z __5
    // *VERA_ADDRX_L = BYTE0(ch)
    // [306] *VERA_ADDRX_L = clrscr::$5 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(ch)
    // [307] clrscr::$6 = byte1  clrscr::line_text#2 -- vbuz1=_byte1_vwuz2 
    lda.z line_text+1
    sta.z __6
    // *VERA_ADDRX_M = BYTE1(ch)
    // [308] *VERA_ADDRX_M = clrscr::$6 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [309] clrscr::$7 = *((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    sta.z __7
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [310] *VERA_ADDRX_H = clrscr::$7 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [311] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [311] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@4
  __b4:
    // for( char c=0;c<conio_map_width; c++ )
    // [312] if(clrscr::c#2<clrscr::conio_map_width#0) goto clrscr::@5 -- vbuz1_lt_vwuz2_then_la1 
    lda.z conio_map_width+1
    bne __b5
    lda.z c
    cmp.z conio_map_width
    bcc __b5
    // clrscr::@6
    // line_text += cx16_conio.conio_rowskip
    // [313] clrscr::line_text#1 = clrscr::line_text#2 + *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z line_text
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    sta.z line_text
    lda.z line_text+1
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    sta.z line_text+1
    // for( char l=0;l<conio_map_height; l++ )
    // [314] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [297] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [297] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [297] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [315] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [316] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<conio_map_width; c++ )
    // [317] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [311] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [311] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
}
  // printf_str
/// Print a NUL-terminated string
// void printf_str(void (*putc)(char), __zp($4d) const char *s)
printf_str: {
    .label c = $67
    .label s = $4d
    // [319] phi from printf_str printf_str::@2 to printf_str::@1 [phi:printf_str/printf_str::@2->printf_str::@1]
    // [319] phi printf_str::s#123 = printf_str::s#124 [phi:printf_str/printf_str::@2->printf_str::@1#0] -- register_copy 
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [320] printf_str::c#1 = *printf_str::s#123 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta.z c
    // [321] printf_str::s#0 = ++ printf_str::s#123 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [322] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbuz1_then_la1 
    lda.z c
    bne __b2
    // printf_str::@return
    // }
    // [323] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [324] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbuz1 
    lda.z c
    pha
    // [325] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
}
  // tile_16_x_16_8BPP_256_color
tile_16_x_16_8BPP_256_color: {
    .label __33 = $66
    .label __38 = $66
    .label p = $70
    .label tilebase = $40
    .label t = $6a
    .label column = $ba
    .label tile = $4d
    .label c = $7c
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label row = $11
    .label r = $bf
    .label column1 = $7b
    .label tile_1 = $71
    .label c1 = $76
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label row_1 = $ad
    .label r1 = $af
    // vera_layer_mode_text( 1, 0x00000, 0x0F800, 128, 128, 8, 8, 256 )
    // [328] call vera_layer_mode_text
    // [185] phi from tile_16_x_16_8BPP_256_color to vera_layer_mode_text [phi:tile_16_x_16_8BPP_256_color->vera_layer_mode_text]
    // [185] phi vera_layer_mode_text::color_mode#11 = $100 [phi:tile_16_x_16_8BPP_256_color->vera_layer_mode_text#0] -- vwuz1=vwuc1 
    lda #<$100
    sta.z vera_layer_mode_text.color_mode
    lda #>$100
    sta.z vera_layer_mode_text.color_mode+1
    // [185] phi vera_layer_mode_text::mapheight#11 = $80 [phi:tile_16_x_16_8BPP_256_color->vera_layer_mode_text#1] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapheight
    lda #>$80
    sta.z vera_layer_mode_text.mapheight+1
    // [185] phi vera_layer_mode_text::mapwidth#11 = $80 [phi:tile_16_x_16_8BPP_256_color->vera_layer_mode_text#2] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapwidth
    lda #>$80
    sta.z vera_layer_mode_text.mapwidth+1
    jsr vera_layer_mode_text
    // [329] phi from tile_16_x_16_8BPP_256_color to tile_16_x_16_8BPP_256_color::@17 [phi:tile_16_x_16_8BPP_256_color->tile_16_x_16_8BPP_256_color::@17]
    // tile_16_x_16_8BPP_256_color::@17
    // screenlayer(1)
    // [330] call screenlayer
    jsr screenlayer
    // [331] phi from tile_16_x_16_8BPP_256_color::@17 to tile_16_x_16_8BPP_256_color::@18 [phi:tile_16_x_16_8BPP_256_color::@17->tile_16_x_16_8BPP_256_color::@18]
    // tile_16_x_16_8BPP_256_color::@18
    // textcolor(WHITE)
    // [332] call textcolor
    // [274] phi from tile_16_x_16_8BPP_256_color::@18 to textcolor [phi:tile_16_x_16_8BPP_256_color::@18->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:tile_16_x_16_8BPP_256_color::@18->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [333] phi from tile_16_x_16_8BPP_256_color::@18 to tile_16_x_16_8BPP_256_color::@19 [phi:tile_16_x_16_8BPP_256_color::@18->tile_16_x_16_8BPP_256_color::@19]
    // tile_16_x_16_8BPP_256_color::@19
    // bgcolor(BLACK)
    // [334] call bgcolor
    // [279] phi from tile_16_x_16_8BPP_256_color::@19 to bgcolor [phi:tile_16_x_16_8BPP_256_color::@19->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:tile_16_x_16_8BPP_256_color::@19->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [335] phi from tile_16_x_16_8BPP_256_color::@19 to tile_16_x_16_8BPP_256_color::@20 [phi:tile_16_x_16_8BPP_256_color::@19->tile_16_x_16_8BPP_256_color::@20]
    // tile_16_x_16_8BPP_256_color::@20
    // clrscr()
    // [336] call clrscr
    jsr clrscr
    // [337] phi from tile_16_x_16_8BPP_256_color::@20 to tile_16_x_16_8BPP_256_color::@21 [phi:tile_16_x_16_8BPP_256_color::@20->tile_16_x_16_8BPP_256_color::@21]
    // tile_16_x_16_8BPP_256_color::@21
    // cx16_cpy_vram_from_vram(1, 0xF000, 0, 0xF800, 256*8)
    // [338] call cx16_cpy_vram_from_vram
  // Before we can load the tiles into memory we need to re-arrange a few things!
  // The amount of tiles is 256, the color depth is 256, so each tile is 256 bytes!
  // That is 65356 bytes of memory, which is 64K. Yup! One memory bank in VRAM.
  // VERA VRAM holds in bank 1 many registers that interfere loading all of this data.
  // So it is better to load all in bank 0, but then there is an other issue.
  // So the default CX16 character set is located in bank 0, at address 0xF800.
  // So we need to move this character set to bank 1, suggested is at address 0xF000.
  // The CX16 by default writes textual output to layer 1 in text mode, so we need to
  // realign the moved character set to 0xf000 as the new tile base for layer 1.
  // We also will need to realign for layer 1 the map base from 0x00000 to 0x10000.
  // This is now all easily done with a few statements in the new kickc vera lib ...
    // [1674] phi from tile_16_x_16_8BPP_256_color::@21 to cx16_cpy_vram_from_vram [phi:tile_16_x_16_8BPP_256_color::@21->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f000 [phi:tile_16_x_16_8BPP_256_color::@21->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 1 [phi:tile_16_x_16_8BPP_256_color::@21->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f800 [phi:tile_16_x_16_8BPP_256_color::@21->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 0 [phi:tile_16_x_16_8BPP_256_color::@21->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // [339] phi from tile_16_x_16_8BPP_256_color::@21 to tile_16_x_16_8BPP_256_color::@22 [phi:tile_16_x_16_8BPP_256_color::@21->tile_16_x_16_8BPP_256_color::@22]
    // tile_16_x_16_8BPP_256_color::@22
    // vera_layer_mode_tile(1, 0x10000, 0x1F000, 128, 64, 8, 8, 1)
    // [340] call vera_layer_mode_tile
  // We copy the 128 character set of 8 bytes each.
    // [1580] phi from tile_16_x_16_8BPP_256_color::@22 to vera_layer_mode_tile [phi:tile_16_x_16_8BPP_256_color::@22->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = 8 [phi:tile_16_x_16_8BPP_256_color::@22->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = 8 [phi:tile_16_x_16_8BPP_256_color::@22->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $1f000 [phi:tile_16_x_16_8BPP_256_color::@22->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$1f000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$1f000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $10000 [phi:tile_16_x_16_8BPP_256_color::@22->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$10000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$10000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$10000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$10000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $40 [phi:tile_16_x_16_8BPP_256_color::@22->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 1 [phi:tile_16_x_16_8BPP_256_color::@22->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $80 [phi:tile_16_x_16_8BPP_256_color::@22->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 1 [phi:tile_16_x_16_8BPP_256_color::@22->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // tile_16_x_16_8BPP_256_color::vera_display_set_scale_none1
    // *VERA_DC_HSCALE = 128
    // [341] *VERA_DC_HSCALE = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 128
    // [342] *VERA_DC_VSCALE = $80 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // [343] phi from tile_16_x_16_8BPP_256_color::vera_display_set_scale_none1 to tile_16_x_16_8BPP_256_color::@16 [phi:tile_16_x_16_8BPP_256_color::vera_display_set_scale_none1->tile_16_x_16_8BPP_256_color::@16]
    // tile_16_x_16_8BPP_256_color::@16
    // screenlayer(1)
    // [344] call screenlayer
    jsr screenlayer
    // [345] phi from tile_16_x_16_8BPP_256_color::@16 to tile_16_x_16_8BPP_256_color::@23 [phi:tile_16_x_16_8BPP_256_color::@16->tile_16_x_16_8BPP_256_color::@23]
    // tile_16_x_16_8BPP_256_color::@23
    // textcolor(WHITE)
    // [346] call textcolor
    // [274] phi from tile_16_x_16_8BPP_256_color::@23 to textcolor [phi:tile_16_x_16_8BPP_256_color::@23->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:tile_16_x_16_8BPP_256_color::@23->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [347] phi from tile_16_x_16_8BPP_256_color::@23 to tile_16_x_16_8BPP_256_color::@24 [phi:tile_16_x_16_8BPP_256_color::@23->tile_16_x_16_8BPP_256_color::@24]
    // tile_16_x_16_8BPP_256_color::@24
    // bgcolor(BLACK)
    // [348] call bgcolor
    // [279] phi from tile_16_x_16_8BPP_256_color::@24 to bgcolor [phi:tile_16_x_16_8BPP_256_color::@24->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:tile_16_x_16_8BPP_256_color::@24->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [349] phi from tile_16_x_16_8BPP_256_color::@24 to tile_16_x_16_8BPP_256_color::@25 [phi:tile_16_x_16_8BPP_256_color::@24->tile_16_x_16_8BPP_256_color::@25]
    // tile_16_x_16_8BPP_256_color::@25
    // clrscr()
    // [350] call clrscr
    jsr clrscr
    // [351] phi from tile_16_x_16_8BPP_256_color::@25 to tile_16_x_16_8BPP_256_color::@26 [phi:tile_16_x_16_8BPP_256_color::@25->tile_16_x_16_8BPP_256_color::@26]
    // tile_16_x_16_8BPP_256_color::@26
    // vera_layer_mode_tile(0, 0x14000, 0x00000, 64, 64, 16, 16, 8)
    // [352] call vera_layer_mode_tile
  // Now we can use the full bank 0!
  // We set the mapbase of the tile demo to output to 0x12000,
  // and the tilebase is set to 0x0000!
    // [1580] phi from tile_16_x_16_8BPP_256_color::@26 to vera_layer_mode_tile [phi:tile_16_x_16_8BPP_256_color::@26->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = $10 [phi:tile_16_x_16_8BPP_256_color::@26->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #$10
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = $10 [phi:tile_16_x_16_8BPP_256_color::@26->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = 0 [phi:tile_16_x_16_8BPP_256_color::@26->vera_layer_mode_tile#2] -- vduz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address+1
    sta.z vera_layer_mode_tile.tilebase_address+2
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $14000 [phi:tile_16_x_16_8BPP_256_color::@26->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $40 [phi:tile_16_x_16_8BPP_256_color::@26->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 0 [phi:tile_16_x_16_8BPP_256_color::@26->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $40 [phi:tile_16_x_16_8BPP_256_color::@26->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$40
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 8 [phi:tile_16_x_16_8BPP_256_color::@26->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // [353] phi from tile_16_x_16_8BPP_256_color::@26 to tile_16_x_16_8BPP_256_color::@27 [phi:tile_16_x_16_8BPP_256_color::@26->tile_16_x_16_8BPP_256_color::@27]
    // tile_16_x_16_8BPP_256_color::@27
    // cx16_cpy_vram_from_ram(0, tilebase, tiles, 256)
    // [354] call cx16_cpy_vram_from_ram
    // [1694] phi from tile_16_x_16_8BPP_256_color::@27 to cx16_cpy_vram_from_ram [phi:tile_16_x_16_8BPP_256_color::@27->cx16_cpy_vram_from_ram]
    // [1694] phi cx16_cpy_vram_from_ram::num#10 = $100 [phi:tile_16_x_16_8BPP_256_color::@27->cx16_cpy_vram_from_ram#0] -- vwuz1=vwuc1 
    lda #<$100
    sta.z cx16_cpy_vram_from_ram.num
    lda #>$100
    sta.z cx16_cpy_vram_from_ram.num+1
    // [1694] phi cx16_cpy_vram_from_ram::sptr_ram#10 = (void *)tile_16_x_16_8BPP_256_color::tiles [phi:tile_16_x_16_8BPP_256_color::@27->cx16_cpy_vram_from_ram#1] -- pvoz1=pvoc1 
    lda #<tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram
    lda #>tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_offset#0 = 0 [phi:tile_16_x_16_8BPP_256_color::@27->cx16_cpy_vram_from_ram#2] -- vwuz1=vwuc1 
    lda #<0
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_offset
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_offset+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_bank#0 = 0 [phi:tile_16_x_16_8BPP_256_color::@27->cx16_cpy_vram_from_ram#3] -- vbuz1=vbuc1 
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_ram
    // [355] phi from tile_16_x_16_8BPP_256_color::@27 to tile_16_x_16_8BPP_256_color::@1 [phi:tile_16_x_16_8BPP_256_color::@27->tile_16_x_16_8BPP_256_color::@1]
    // [355] phi tile_16_x_16_8BPP_256_color::t#5 = 1 [phi:tile_16_x_16_8BPP_256_color::@27->tile_16_x_16_8BPP_256_color::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z t
    // [355] phi tile_16_x_16_8BPP_256_color::tilebase#7 = $100 [phi:tile_16_x_16_8BPP_256_color::@27->tile_16_x_16_8BPP_256_color::@1#1] -- vwuz1=vwuc1 
    lda #<$100
    sta.z tilebase
    lda #>$100
    sta.z tilebase+1
    // [355] phi from tile_16_x_16_8BPP_256_color::@28 to tile_16_x_16_8BPP_256_color::@1 [phi:tile_16_x_16_8BPP_256_color::@28->tile_16_x_16_8BPP_256_color::@1]
    // [355] phi tile_16_x_16_8BPP_256_color::t#5 = tile_16_x_16_8BPP_256_color::t#1 [phi:tile_16_x_16_8BPP_256_color::@28->tile_16_x_16_8BPP_256_color::@1#0] -- register_copy 
    // [355] phi tile_16_x_16_8BPP_256_color::tilebase#7 = tile_16_x_16_8BPP_256_color::tilebase#2 [phi:tile_16_x_16_8BPP_256_color::@28->tile_16_x_16_8BPP_256_color::@1#1] -- register_copy 
    // tile_16_x_16_8BPP_256_color::@1
  __b1:
    // [356] phi from tile_16_x_16_8BPP_256_color::@1 to tile_16_x_16_8BPP_256_color::@2 [phi:tile_16_x_16_8BPP_256_color::@1->tile_16_x_16_8BPP_256_color::@2]
    // [356] phi tile_16_x_16_8BPP_256_color::p#2 = 0 [phi:tile_16_x_16_8BPP_256_color::@1->tile_16_x_16_8BPP_256_color::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z p
    // [356] phi from tile_16_x_16_8BPP_256_color::@2 to tile_16_x_16_8BPP_256_color::@2 [phi:tile_16_x_16_8BPP_256_color::@2->tile_16_x_16_8BPP_256_color::@2]
    // [356] phi tile_16_x_16_8BPP_256_color::p#2 = tile_16_x_16_8BPP_256_color::p#1 [phi:tile_16_x_16_8BPP_256_color::@2->tile_16_x_16_8BPP_256_color::@2#0] -- register_copy 
    // tile_16_x_16_8BPP_256_color::@2
  __b2:
    // tiles[p]+=1
    // [357] tile_16_x_16_8BPP_256_color::tiles[tile_16_x_16_8BPP_256_color::p#2] = tile_16_x_16_8BPP_256_color::tiles[tile_16_x_16_8BPP_256_color::p#2] + 1 -- pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_plus_1 
    ldy.z p
    lda tiles,y
    inc
    sta tiles,y
    // for(byte p:0..255)
    // [358] tile_16_x_16_8BPP_256_color::p#1 = ++ tile_16_x_16_8BPP_256_color::p#2 -- vbuz1=_inc_vbuz1 
    inc.z p
    // [359] if(tile_16_x_16_8BPP_256_color::p#1!=0) goto tile_16_x_16_8BPP_256_color::@2 -- vbuz1_neq_0_then_la1 
    lda.z p
    bne __b2
    // tile_16_x_16_8BPP_256_color::@3
    // cx16_cpy_vram_from_ram(0, tilebase, tiles, 256)
    // [360] cx16_cpy_vram_from_ram::doffset_vram#1 = tile_16_x_16_8BPP_256_color::tilebase#7 -- vwuz1=vwuz2 
    lda.z tilebase
    sta.z cx16_cpy_vram_from_ram.doffset_vram
    lda.z tilebase+1
    sta.z cx16_cpy_vram_from_ram.doffset_vram+1
    // [361] call cx16_cpy_vram_from_ram
    // [1694] phi from tile_16_x_16_8BPP_256_color::@3 to cx16_cpy_vram_from_ram [phi:tile_16_x_16_8BPP_256_color::@3->cx16_cpy_vram_from_ram]
    // [1694] phi cx16_cpy_vram_from_ram::num#10 = $100 [phi:tile_16_x_16_8BPP_256_color::@3->cx16_cpy_vram_from_ram#0] -- vwuz1=vwuc1 
    lda #<$100
    sta.z cx16_cpy_vram_from_ram.num
    lda #>$100
    sta.z cx16_cpy_vram_from_ram.num+1
    // [1694] phi cx16_cpy_vram_from_ram::sptr_ram#10 = (void *)tile_16_x_16_8BPP_256_color::tiles [phi:tile_16_x_16_8BPP_256_color::@3->cx16_cpy_vram_from_ram#1] -- pvoz1=pvoc1 
    lda #<tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram
    lda #>tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_offset#0 = cx16_cpy_vram_from_ram::doffset_vram#1 [phi:tile_16_x_16_8BPP_256_color::@3->cx16_cpy_vram_from_ram#2] -- register_copy 
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_bank#0 = 0 [phi:tile_16_x_16_8BPP_256_color::@3->cx16_cpy_vram_from_ram#3] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_ram
    // tile_16_x_16_8BPP_256_color::@28
    // tilebase+=256
    // [362] tile_16_x_16_8BPP_256_color::tilebase#2 = tile_16_x_16_8BPP_256_color::tilebase#7 + $100 -- vwuz1=vwuz1_plus_vwuc1 
    lda.z tilebase
    clc
    adc #<$100
    sta.z tilebase
    lda.z tilebase+1
    adc #>$100
    sta.z tilebase+1
    // for(byte t:1..255)
    // [363] tile_16_x_16_8BPP_256_color::t#1 = ++ tile_16_x_16_8BPP_256_color::t#5 -- vbuz1=_inc_vbuz1 
    inc.z t
    // [364] if(tile_16_x_16_8BPP_256_color::t#1!=0) goto tile_16_x_16_8BPP_256_color::@1 -- vbuz1_neq_0_then_la1 
    lda.z t
    bne __b1
    // [365] phi from tile_16_x_16_8BPP_256_color::@28 to tile_16_x_16_8BPP_256_color::@4 [phi:tile_16_x_16_8BPP_256_color::@28->tile_16_x_16_8BPP_256_color::@4]
    // tile_16_x_16_8BPP_256_color::@4
    // vera_tile_area(0, 0, 0, 0, 40, 30, 0, 0, 0)
    // [366] call vera_tile_area
  //vera_tile_area(byte layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset)
    // [1709] phi from tile_16_x_16_8BPP_256_color::@4 to vera_tile_area [phi:tile_16_x_16_8BPP_256_color::@4->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = $28 [phi:tile_16_x_16_8BPP_256_color::@4->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$28
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = $1e [phi:tile_16_x_16_8BPP_256_color::@4->vera_tile_area#1] -- vbuz1=vbuc1 
    lda #$1e
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = 0 [phi:tile_16_x_16_8BPP_256_color::@4->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 0 [phi:tile_16_x_16_8BPP_256_color::@4->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 0 [phi:tile_16_x_16_8BPP_256_color::@4->vera_tile_area#4] -- vwuz1=vbuc1 
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_8BPP_256_color::@4->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [367] phi from tile_16_x_16_8BPP_256_color::@4 to tile_16_x_16_8BPP_256_color::@5 [phi:tile_16_x_16_8BPP_256_color::@4->tile_16_x_16_8BPP_256_color::@5]
    // [367] phi tile_16_x_16_8BPP_256_color::r#5 = 0 [phi:tile_16_x_16_8BPP_256_color::@4->tile_16_x_16_8BPP_256_color::@5#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // [367] phi tile_16_x_16_8BPP_256_color::row#9 = 1 [phi:tile_16_x_16_8BPP_256_color::@4->tile_16_x_16_8BPP_256_color::@5#1] -- vbuz1=vbuc1 
    lda #1
    sta.z row
    // [367] phi tile_16_x_16_8BPP_256_color::tile#10 = 0 [phi:tile_16_x_16_8BPP_256_color::@4->tile_16_x_16_8BPP_256_color::@5#2] -- vwuz1=vwuc1 
    lda #<0
    sta.z tile
    sta.z tile+1
    // [367] phi from tile_16_x_16_8BPP_256_color::@7 to tile_16_x_16_8BPP_256_color::@5 [phi:tile_16_x_16_8BPP_256_color::@7->tile_16_x_16_8BPP_256_color::@5]
    // [367] phi tile_16_x_16_8BPP_256_color::r#5 = tile_16_x_16_8BPP_256_color::r#1 [phi:tile_16_x_16_8BPP_256_color::@7->tile_16_x_16_8BPP_256_color::@5#0] -- register_copy 
    // [367] phi tile_16_x_16_8BPP_256_color::row#9 = tile_16_x_16_8BPP_256_color::row#1 [phi:tile_16_x_16_8BPP_256_color::@7->tile_16_x_16_8BPP_256_color::@5#1] -- register_copy 
    // [367] phi tile_16_x_16_8BPP_256_color::tile#10 = tile_16_x_16_8BPP_256_color::tile#12 [phi:tile_16_x_16_8BPP_256_color::@7->tile_16_x_16_8BPP_256_color::@5#2] -- register_copy 
    // tile_16_x_16_8BPP_256_color::@5
  __b5:
    // [368] phi from tile_16_x_16_8BPP_256_color::@5 to tile_16_x_16_8BPP_256_color::@6 [phi:tile_16_x_16_8BPP_256_color::@5->tile_16_x_16_8BPP_256_color::@6]
    // [368] phi tile_16_x_16_8BPP_256_color::c#2 = 0 [phi:tile_16_x_16_8BPP_256_color::@5->tile_16_x_16_8BPP_256_color::@6#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // [368] phi tile_16_x_16_8BPP_256_color::column#2 = 0 [phi:tile_16_x_16_8BPP_256_color::@5->tile_16_x_16_8BPP_256_color::@6#1] -- vbuz1=vbuc1 
    sta.z column
    // [368] phi tile_16_x_16_8BPP_256_color::tile#6 = tile_16_x_16_8BPP_256_color::tile#10 [phi:tile_16_x_16_8BPP_256_color::@5->tile_16_x_16_8BPP_256_color::@6#2] -- register_copy 
    // [368] phi from tile_16_x_16_8BPP_256_color::@29 to tile_16_x_16_8BPP_256_color::@6 [phi:tile_16_x_16_8BPP_256_color::@29->tile_16_x_16_8BPP_256_color::@6]
    // [368] phi tile_16_x_16_8BPP_256_color::c#2 = tile_16_x_16_8BPP_256_color::c#1 [phi:tile_16_x_16_8BPP_256_color::@29->tile_16_x_16_8BPP_256_color::@6#0] -- register_copy 
    // [368] phi tile_16_x_16_8BPP_256_color::column#2 = tile_16_x_16_8BPP_256_color::column#1 [phi:tile_16_x_16_8BPP_256_color::@29->tile_16_x_16_8BPP_256_color::@6#1] -- register_copy 
    // [368] phi tile_16_x_16_8BPP_256_color::tile#6 = tile_16_x_16_8BPP_256_color::tile#12 [phi:tile_16_x_16_8BPP_256_color::@29->tile_16_x_16_8BPP_256_color::@6#2] -- register_copy 
    // tile_16_x_16_8BPP_256_color::@6
  __b6:
    // vera_tile_area(0, tile, column, row, 1, 1, 0, 0, 0)
    // [369] vera_tile_area::tileindex#1 = tile_16_x_16_8BPP_256_color::tile#6 -- vwuz1=vwuz2 
    lda.z tile
    sta.z vera_tile_area.tileindex
    lda.z tile+1
    sta.z vera_tile_area.tileindex+1
    // [370] vera_tile_area::x#1 = tile_16_x_16_8BPP_256_color::column#2 -- vbuz1=vbuz2 
    lda.z column
    sta.z vera_tile_area.x
    // [371] vera_tile_area::y#1 = tile_16_x_16_8BPP_256_color::row#9 -- vbuz1=vbuz2 
    lda.z row
    sta.z vera_tile_area.y
    // [372] call vera_tile_area
    // [1709] phi from tile_16_x_16_8BPP_256_color::@6 to vera_tile_area [phi:tile_16_x_16_8BPP_256_color::@6->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 1 [phi:tile_16_x_16_8BPP_256_color::@6->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 1 [phi:tile_16_x_16_8BPP_256_color::@6->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#1 [phi:tile_16_x_16_8BPP_256_color::@6->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = vera_tile_area::y#1 [phi:tile_16_x_16_8BPP_256_color::@6->vera_tile_area#3] -- register_copy 
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#1 [phi:tile_16_x_16_8BPP_256_color::@6->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_8BPP_256_color::@6->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // tile_16_x_16_8BPP_256_color::@29
    // column+=2
    // [373] tile_16_x_16_8BPP_256_color::column#1 = tile_16_x_16_8BPP_256_color::column#2 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z column
    clc
    adc #2
    sta.z column
    // tile++;
    // [374] tile_16_x_16_8BPP_256_color::tile#1 = ++ tile_16_x_16_8BPP_256_color::tile#6 -- vwuz1=_inc_vwuz1 
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // tile &= 0xff
    // [375] tile_16_x_16_8BPP_256_color::tile#12 = tile_16_x_16_8BPP_256_color::tile#1 & $ff -- vwuz1=vwuz1_band_vbuc1 
    lda #$ff
    and.z tile
    sta.z tile
    lda #0
    sta.z tile+1
    // for(byte c:0..19)
    // [376] tile_16_x_16_8BPP_256_color::c#1 = ++ tile_16_x_16_8BPP_256_color::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [377] if(tile_16_x_16_8BPP_256_color::c#1!=$14) goto tile_16_x_16_8BPP_256_color::@6 -- vbuz1_neq_vbuc1_then_la1 
    lda #$14
    cmp.z c
    bne __b6
    // tile_16_x_16_8BPP_256_color::@7
    // row += 2
    // [378] tile_16_x_16_8BPP_256_color::row#1 = tile_16_x_16_8BPP_256_color::row#9 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z row
    clc
    adc #2
    sta.z row
    // for(byte r:0..11)
    // [379] tile_16_x_16_8BPP_256_color::r#1 = ++ tile_16_x_16_8BPP_256_color::r#5 -- vbuz1=_inc_vbuz1 
    inc.z r
    // [380] if(tile_16_x_16_8BPP_256_color::r#1!=$c) goto tile_16_x_16_8BPP_256_color::@5 -- vbuz1_neq_vbuc1_then_la1 
    lda #$c
    cmp.z r
    bne __b5
    // [381] phi from tile_16_x_16_8BPP_256_color::@7 to tile_16_x_16_8BPP_256_color::@8 [phi:tile_16_x_16_8BPP_256_color::@7->tile_16_x_16_8BPP_256_color::@8]
    // tile_16_x_16_8BPP_256_color::@8
    // gotoxy(0,50)
    // [382] call gotoxy
    // [242] phi from tile_16_x_16_8BPP_256_color::@8 to gotoxy [phi:tile_16_x_16_8BPP_256_color::@8->gotoxy]
    // [242] phi gotoxy::y#35 = $32 [phi:tile_16_x_16_8BPP_256_color::@8->gotoxy#0] -- vbuz1=vbuc1 
    lda #$32
    sta.z gotoxy.y
    jsr gotoxy
    // [383] phi from tile_16_x_16_8BPP_256_color::@8 to tile_16_x_16_8BPP_256_color::@30 [phi:tile_16_x_16_8BPP_256_color::@8->tile_16_x_16_8BPP_256_color::@30]
    // tile_16_x_16_8BPP_256_color::@30
    // printf("vera in tile mode 8 x 8, color depth 8 bits per pixel.\n")
    // [384] call printf_str
    // [318] phi from tile_16_x_16_8BPP_256_color::@30 to printf_str [phi:tile_16_x_16_8BPP_256_color::@30->printf_str]
    // [318] phi printf_str::s#124 = s [phi:tile_16_x_16_8BPP_256_color::@30->printf_str#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // [385] phi from tile_16_x_16_8BPP_256_color::@30 to tile_16_x_16_8BPP_256_color::@31 [phi:tile_16_x_16_8BPP_256_color::@30->tile_16_x_16_8BPP_256_color::@31]
    // tile_16_x_16_8BPP_256_color::@31
    // printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n")
    // [386] call printf_str
    // [318] phi from tile_16_x_16_8BPP_256_color::@31 to printf_str [phi:tile_16_x_16_8BPP_256_color::@31->printf_str]
    // [318] phi printf_str::s#124 = s1 [phi:tile_16_x_16_8BPP_256_color::@31->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [387] phi from tile_16_x_16_8BPP_256_color::@31 to tile_16_x_16_8BPP_256_color::@32 [phi:tile_16_x_16_8BPP_256_color::@31->tile_16_x_16_8BPP_256_color::@32]
    // tile_16_x_16_8BPP_256_color::@32
    // printf("each tile can have a variation of 256 colors.\n")
    // [388] call printf_str
    // [318] phi from tile_16_x_16_8BPP_256_color::@32 to printf_str [phi:tile_16_x_16_8BPP_256_color::@32->printf_str]
    // [318] phi printf_str::s#124 = s2 [phi:tile_16_x_16_8BPP_256_color::@32->printf_str#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // [389] phi from tile_16_x_16_8BPP_256_color::@32 to tile_16_x_16_8BPP_256_color::@33 [phi:tile_16_x_16_8BPP_256_color::@32->tile_16_x_16_8BPP_256_color::@33]
    // tile_16_x_16_8BPP_256_color::@33
    // printf("the vera palette of 256 colors, can be used by setting the palette\n")
    // [390] call printf_str
    // [318] phi from tile_16_x_16_8BPP_256_color::@33 to printf_str [phi:tile_16_x_16_8BPP_256_color::@33->printf_str]
    // [318] phi printf_str::s#124 = s3 [phi:tile_16_x_16_8BPP_256_color::@33->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // [391] phi from tile_16_x_16_8BPP_256_color::@33 to tile_16_x_16_8BPP_256_color::@34 [phi:tile_16_x_16_8BPP_256_color::@33->tile_16_x_16_8BPP_256_color::@34]
    // tile_16_x_16_8BPP_256_color::@34
    // printf("offset for each tile.\n")
    // [392] call printf_str
    // [318] phi from tile_16_x_16_8BPP_256_color::@34 to printf_str [phi:tile_16_x_16_8BPP_256_color::@34->printf_str]
    // [318] phi printf_str::s#124 = s4 [phi:tile_16_x_16_8BPP_256_color::@34->printf_str#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // [393] phi from tile_16_x_16_8BPP_256_color::@34 to tile_16_x_16_8BPP_256_color::@35 [phi:tile_16_x_16_8BPP_256_color::@34->tile_16_x_16_8BPP_256_color::@35]
    // tile_16_x_16_8BPP_256_color::@35
    // printf("here each column is displaying the same tile, but with different offsets!\n")
    // [394] call printf_str
    // [318] phi from tile_16_x_16_8BPP_256_color::@35 to printf_str [phi:tile_16_x_16_8BPP_256_color::@35->printf_str]
    // [318] phi printf_str::s#124 = s5 [phi:tile_16_x_16_8BPP_256_color::@35->printf_str#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // [395] phi from tile_16_x_16_8BPP_256_color::@35 to tile_16_x_16_8BPP_256_color::@36 [phi:tile_16_x_16_8BPP_256_color::@35->tile_16_x_16_8BPP_256_color::@36]
    // tile_16_x_16_8BPP_256_color::@36
    // printf("each offset aligns to multiples of 16 colors in the palette!.\n")
    // [396] call printf_str
    // [318] phi from tile_16_x_16_8BPP_256_color::@36 to printf_str [phi:tile_16_x_16_8BPP_256_color::@36->printf_str]
    // [318] phi printf_str::s#124 = s6 [phi:tile_16_x_16_8BPP_256_color::@36->printf_str#0] -- pbuz1=pbuc1 
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    jsr printf_str
    // [397] phi from tile_16_x_16_8BPP_256_color::@36 to tile_16_x_16_8BPP_256_color::@37 [phi:tile_16_x_16_8BPP_256_color::@36->tile_16_x_16_8BPP_256_color::@37]
    // tile_16_x_16_8BPP_256_color::@37
    // printf("however, the first color will always be transparent (black).\n")
    // [398] call printf_str
    // [318] phi from tile_16_x_16_8BPP_256_color::@37 to printf_str [phi:tile_16_x_16_8BPP_256_color::@37->printf_str]
    // [318] phi printf_str::s#124 = s7 [phi:tile_16_x_16_8BPP_256_color::@37->printf_str#0] -- pbuz1=pbuc1 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // tile_16_x_16_8BPP_256_color::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [399] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [400] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [401] phi from tile_16_x_16_8BPP_256_color::@38 tile_16_x_16_8BPP_256_color::vera_layer_show1 to tile_16_x_16_8BPP_256_color::@9 [phi:tile_16_x_16_8BPP_256_color::@38/tile_16_x_16_8BPP_256_color::vera_layer_show1->tile_16_x_16_8BPP_256_color::@9]
    // tile_16_x_16_8BPP_256_color::@9
  __b9:
    // getin()
    // [402] call getin
    jsr getin
    // [403] getin::return#26 = getin::return#1
    // tile_16_x_16_8BPP_256_color::@38
    // [404] tile_16_x_16_8BPP_256_color::$33 = getin::return#26
    // while(!getin())
    // [405] if(0==tile_16_x_16_8BPP_256_color::$33) goto tile_16_x_16_8BPP_256_color::@9 -- 0_eq_vbuz1_then_la1 
    lda.z __33
    beq __b9
    // [406] phi from tile_16_x_16_8BPP_256_color::@38 to tile_16_x_16_8BPP_256_color::@10 [phi:tile_16_x_16_8BPP_256_color::@38->tile_16_x_16_8BPP_256_color::@10]
    // tile_16_x_16_8BPP_256_color::@10
    // vera_tile_area(0, 0, 0, 0, 40, 30, 0, 0, 0)
    // [407] call vera_tile_area
    // [1709] phi from tile_16_x_16_8BPP_256_color::@10 to vera_tile_area [phi:tile_16_x_16_8BPP_256_color::@10->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = $28 [phi:tile_16_x_16_8BPP_256_color::@10->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$28
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = $1e [phi:tile_16_x_16_8BPP_256_color::@10->vera_tile_area#1] -- vbuz1=vbuc1 
    lda #$1e
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = 0 [phi:tile_16_x_16_8BPP_256_color::@10->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 0 [phi:tile_16_x_16_8BPP_256_color::@10->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 0 [phi:tile_16_x_16_8BPP_256_color::@10->vera_tile_area#4] -- vwuz1=vbuc1 
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_8BPP_256_color::@10->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [408] phi from tile_16_x_16_8BPP_256_color::@10 to tile_16_x_16_8BPP_256_color::@11 [phi:tile_16_x_16_8BPP_256_color::@10->tile_16_x_16_8BPP_256_color::@11]
    // [408] phi tile_16_x_16_8BPP_256_color::r1#5 = 0 [phi:tile_16_x_16_8BPP_256_color::@10->tile_16_x_16_8BPP_256_color::@11#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r1
    // [408] phi tile_16_x_16_8BPP_256_color::row#10 = 0 [phi:tile_16_x_16_8BPP_256_color::@10->tile_16_x_16_8BPP_256_color::@11#1] -- vbuz1=vbuc1 
    sta.z row_1
    // [408] phi tile_16_x_16_8BPP_256_color::tile#11 = 0 [phi:tile_16_x_16_8BPP_256_color::@10->tile_16_x_16_8BPP_256_color::@11#2] -- vwuz1=vbuc1 
    sta.z tile_1
    sta.z tile_1+1
    // [408] phi from tile_16_x_16_8BPP_256_color::@13 to tile_16_x_16_8BPP_256_color::@11 [phi:tile_16_x_16_8BPP_256_color::@13->tile_16_x_16_8BPP_256_color::@11]
    // [408] phi tile_16_x_16_8BPP_256_color::r1#5 = tile_16_x_16_8BPP_256_color::r1#1 [phi:tile_16_x_16_8BPP_256_color::@13->tile_16_x_16_8BPP_256_color::@11#0] -- register_copy 
    // [408] phi tile_16_x_16_8BPP_256_color::row#10 = tile_16_x_16_8BPP_256_color::row#3 [phi:tile_16_x_16_8BPP_256_color::@13->tile_16_x_16_8BPP_256_color::@11#1] -- register_copy 
    // [408] phi tile_16_x_16_8BPP_256_color::tile#11 = tile_16_x_16_8BPP_256_color::tile#13 [phi:tile_16_x_16_8BPP_256_color::@13->tile_16_x_16_8BPP_256_color::@11#2] -- register_copy 
    // tile_16_x_16_8BPP_256_color::@11
  __b11:
    // [409] phi from tile_16_x_16_8BPP_256_color::@11 to tile_16_x_16_8BPP_256_color::@12 [phi:tile_16_x_16_8BPP_256_color::@11->tile_16_x_16_8BPP_256_color::@12]
    // [409] phi tile_16_x_16_8BPP_256_color::c1#2 = 0 [phi:tile_16_x_16_8BPP_256_color::@11->tile_16_x_16_8BPP_256_color::@12#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c1
    // [409] phi tile_16_x_16_8BPP_256_color::column1#2 = 0 [phi:tile_16_x_16_8BPP_256_color::@11->tile_16_x_16_8BPP_256_color::@12#1] -- vbuz1=vbuc1 
    sta.z column1
    // [409] phi tile_16_x_16_8BPP_256_color::tile#8 = tile_16_x_16_8BPP_256_color::tile#11 [phi:tile_16_x_16_8BPP_256_color::@11->tile_16_x_16_8BPP_256_color::@12#2] -- register_copy 
    // [409] phi from tile_16_x_16_8BPP_256_color::@39 to tile_16_x_16_8BPP_256_color::@12 [phi:tile_16_x_16_8BPP_256_color::@39->tile_16_x_16_8BPP_256_color::@12]
    // [409] phi tile_16_x_16_8BPP_256_color::c1#2 = tile_16_x_16_8BPP_256_color::c1#1 [phi:tile_16_x_16_8BPP_256_color::@39->tile_16_x_16_8BPP_256_color::@12#0] -- register_copy 
    // [409] phi tile_16_x_16_8BPP_256_color::column1#2 = tile_16_x_16_8BPP_256_color::column1#1 [phi:tile_16_x_16_8BPP_256_color::@39->tile_16_x_16_8BPP_256_color::@12#1] -- register_copy 
    // [409] phi tile_16_x_16_8BPP_256_color::tile#8 = tile_16_x_16_8BPP_256_color::tile#13 [phi:tile_16_x_16_8BPP_256_color::@39->tile_16_x_16_8BPP_256_color::@12#2] -- register_copy 
    // tile_16_x_16_8BPP_256_color::@12
  __b12:
    // vera_tile_area(0, tile, column, row, 2, 2, 0, 0, 0)
    // [410] vera_tile_area::tileindex#3 = tile_16_x_16_8BPP_256_color::tile#8 -- vwuz1=vwuz2 
    lda.z tile_1
    sta.z vera_tile_area.tileindex
    lda.z tile_1+1
    sta.z vera_tile_area.tileindex+1
    // [411] vera_tile_area::x#3 = tile_16_x_16_8BPP_256_color::column1#2 -- vbuz1=vbuz2 
    lda.z column1
    sta.z vera_tile_area.x
    // [412] vera_tile_area::y#3 = tile_16_x_16_8BPP_256_color::row#10 -- vbuz1=vbuz2 
    lda.z row_1
    sta.z vera_tile_area.y
    // [413] call vera_tile_area
    // [1709] phi from tile_16_x_16_8BPP_256_color::@12 to vera_tile_area [phi:tile_16_x_16_8BPP_256_color::@12->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 2 [phi:tile_16_x_16_8BPP_256_color::@12->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #2
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 2 [phi:tile_16_x_16_8BPP_256_color::@12->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#3 [phi:tile_16_x_16_8BPP_256_color::@12->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = vera_tile_area::y#3 [phi:tile_16_x_16_8BPP_256_color::@12->vera_tile_area#3] -- register_copy 
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#3 [phi:tile_16_x_16_8BPP_256_color::@12->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_8BPP_256_color::@12->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // tile_16_x_16_8BPP_256_color::@39
    // column+=2
    // [414] tile_16_x_16_8BPP_256_color::column1#1 = tile_16_x_16_8BPP_256_color::column1#2 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z column1
    clc
    adc #2
    sta.z column1
    // tile++;
    // [415] tile_16_x_16_8BPP_256_color::tile#4 = ++ tile_16_x_16_8BPP_256_color::tile#8 -- vwuz1=_inc_vwuz1 
    inc.z tile_1
    bne !+
    inc.z tile_1+1
  !:
    // tile &= 0xff
    // [416] tile_16_x_16_8BPP_256_color::tile#13 = tile_16_x_16_8BPP_256_color::tile#4 & $ff -- vwuz1=vwuz1_band_vbuc1 
    lda #$ff
    and.z tile_1
    sta.z tile_1
    lda #0
    sta.z tile_1+1
    // for(byte c:0..19)
    // [417] tile_16_x_16_8BPP_256_color::c1#1 = ++ tile_16_x_16_8BPP_256_color::c1#2 -- vbuz1=_inc_vbuz1 
    inc.z c1
    // [418] if(tile_16_x_16_8BPP_256_color::c1#1!=$14) goto tile_16_x_16_8BPP_256_color::@12 -- vbuz1_neq_vbuc1_then_la1 
    lda #$14
    cmp.z c1
    bne __b12
    // tile_16_x_16_8BPP_256_color::@13
    // row += 2
    // [419] tile_16_x_16_8BPP_256_color::row#3 = tile_16_x_16_8BPP_256_color::row#10 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z row_1
    clc
    adc #2
    sta.z row_1
    // for(byte r:0..11)
    // [420] tile_16_x_16_8BPP_256_color::r1#1 = ++ tile_16_x_16_8BPP_256_color::r1#5 -- vbuz1=_inc_vbuz1 
    inc.z r1
    // [421] if(tile_16_x_16_8BPP_256_color::r1#1!=$c) goto tile_16_x_16_8BPP_256_color::@11 -- vbuz1_neq_vbuc1_then_la1 
    lda #$c
    cmp.z r1
    bne __b11
    // [422] phi from tile_16_x_16_8BPP_256_color::@13 tile_16_x_16_8BPP_256_color::@40 to tile_16_x_16_8BPP_256_color::@14 [phi:tile_16_x_16_8BPP_256_color::@13/tile_16_x_16_8BPP_256_color::@40->tile_16_x_16_8BPP_256_color::@14]
    // tile_16_x_16_8BPP_256_color::@14
  __b14:
    // getin()
    // [423] call getin
    jsr getin
    // [424] getin::return#27 = getin::return#1
    // tile_16_x_16_8BPP_256_color::@40
    // [425] tile_16_x_16_8BPP_256_color::$38 = getin::return#27
    // while(!getin())
    // [426] if(0==tile_16_x_16_8BPP_256_color::$38) goto tile_16_x_16_8BPP_256_color::@14 -- 0_eq_vbuz1_then_la1 
    lda.z __38
    beq __b14
    // [427] phi from tile_16_x_16_8BPP_256_color::@40 to tile_16_x_16_8BPP_256_color::@15 [phi:tile_16_x_16_8BPP_256_color::@40->tile_16_x_16_8BPP_256_color::@15]
    // tile_16_x_16_8BPP_256_color::@15
    // cx16_cpy_vram_from_vram(0, 0xF800, 1, 0xF000, 256*8)
    // [428] call cx16_cpy_vram_from_vram
    // [1674] phi from tile_16_x_16_8BPP_256_color::@15 to cx16_cpy_vram_from_vram [phi:tile_16_x_16_8BPP_256_color::@15->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f800 [phi:tile_16_x_16_8BPP_256_color::@15->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 0 [phi:tile_16_x_16_8BPP_256_color::@15->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f000 [phi:tile_16_x_16_8BPP_256_color::@15->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:tile_16_x_16_8BPP_256_color::@15->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // tile_16_x_16_8BPP_256_color::@return
    // }
    // [429] return 
    rts
  .segment Data
    tiles: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}
.segment Code
  // tile_8_x_8_8BPP_256_color
tile_8_x_8_8BPP_256_color: {
    .label __29 = $66
    .label p = $11
    .label tilebase = $4d
    .label t = $70
    .label column = $bb
    .label tile = $40
    .label c = $6f
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label row = $ae
    .label r = $d7
    .label column1 = $69
    .label tile_1 = $73
    .label c1 = $68
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label row_1 = $6e
    .label r1 = $57
    // vera_layer_mode_tile(0, 0x04000, 0x14000, 128, 128, 8, 8, 8)
    // [431] call vera_layer_mode_tile
    // [1580] phi from tile_8_x_8_8BPP_256_color to vera_layer_mode_tile [phi:tile_8_x_8_8BPP_256_color->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = 8 [phi:tile_8_x_8_8BPP_256_color->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = 8 [phi:tile_8_x_8_8BPP_256_color->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $14000 [phi:tile_8_x_8_8BPP_256_color->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $4000 [phi:tile_8_x_8_8BPP_256_color->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$4000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$4000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$4000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$4000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $80 [phi:tile_8_x_8_8BPP_256_color->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapheight
    lda #>$80
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 0 [phi:tile_8_x_8_8BPP_256_color->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $80 [phi:tile_8_x_8_8BPP_256_color->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 8 [phi:tile_8_x_8_8BPP_256_color->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // tile_8_x_8_8BPP_256_color::vera_display_set_scale_none1
    // *VERA_DC_HSCALE = 128
    // [432] *VERA_DC_HSCALE = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 128
    // [433] *VERA_DC_VSCALE = $80 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // [434] phi from tile_8_x_8_8BPP_256_color::vera_display_set_scale_none1 to tile_8_x_8_8BPP_256_color::@13 [phi:tile_8_x_8_8BPP_256_color::vera_display_set_scale_none1->tile_8_x_8_8BPP_256_color::@13]
    // tile_8_x_8_8BPP_256_color::@13
    // vera_layer_mode_text( 1, 0x00000, 0x0F800, 128, 128, 8, 8, 256 )
    // [435] call vera_layer_mode_text
    // [185] phi from tile_8_x_8_8BPP_256_color::@13 to vera_layer_mode_text [phi:tile_8_x_8_8BPP_256_color::@13->vera_layer_mode_text]
    // [185] phi vera_layer_mode_text::color_mode#11 = $100 [phi:tile_8_x_8_8BPP_256_color::@13->vera_layer_mode_text#0] -- vwuz1=vwuc1 
    lda #<$100
    sta.z vera_layer_mode_text.color_mode
    lda #>$100
    sta.z vera_layer_mode_text.color_mode+1
    // [185] phi vera_layer_mode_text::mapheight#11 = $80 [phi:tile_8_x_8_8BPP_256_color::@13->vera_layer_mode_text#1] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapheight
    lda #>$80
    sta.z vera_layer_mode_text.mapheight+1
    // [185] phi vera_layer_mode_text::mapwidth#11 = $80 [phi:tile_8_x_8_8BPP_256_color::@13->vera_layer_mode_text#2] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapwidth
    lda #>$80
    sta.z vera_layer_mode_text.mapwidth+1
    jsr vera_layer_mode_text
    // [436] phi from tile_8_x_8_8BPP_256_color::@13 to tile_8_x_8_8BPP_256_color::@15 [phi:tile_8_x_8_8BPP_256_color::@13->tile_8_x_8_8BPP_256_color::@15]
    // tile_8_x_8_8BPP_256_color::@15
    // screenlayer(1)
    // [437] call screenlayer
    jsr screenlayer
    // [438] phi from tile_8_x_8_8BPP_256_color::@15 to tile_8_x_8_8BPP_256_color::@16 [phi:tile_8_x_8_8BPP_256_color::@15->tile_8_x_8_8BPP_256_color::@16]
    // tile_8_x_8_8BPP_256_color::@16
    // textcolor(WHITE)
    // [439] call textcolor
    // [274] phi from tile_8_x_8_8BPP_256_color::@16 to textcolor [phi:tile_8_x_8_8BPP_256_color::@16->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:tile_8_x_8_8BPP_256_color::@16->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [440] phi from tile_8_x_8_8BPP_256_color::@16 to tile_8_x_8_8BPP_256_color::@17 [phi:tile_8_x_8_8BPP_256_color::@16->tile_8_x_8_8BPP_256_color::@17]
    // tile_8_x_8_8BPP_256_color::@17
    // bgcolor(BLACK)
    // [441] call bgcolor
    // [279] phi from tile_8_x_8_8BPP_256_color::@17 to bgcolor [phi:tile_8_x_8_8BPP_256_color::@17->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:tile_8_x_8_8BPP_256_color::@17->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [442] phi from tile_8_x_8_8BPP_256_color::@17 to tile_8_x_8_8BPP_256_color::@18 [phi:tile_8_x_8_8BPP_256_color::@17->tile_8_x_8_8BPP_256_color::@18]
    // tile_8_x_8_8BPP_256_color::@18
    // clrscr()
    // [443] call clrscr
    jsr clrscr
    // [444] phi from tile_8_x_8_8BPP_256_color::@18 to tile_8_x_8_8BPP_256_color::@19 [phi:tile_8_x_8_8BPP_256_color::@18->tile_8_x_8_8BPP_256_color::@19]
    // tile_8_x_8_8BPP_256_color::@19
    // cx16_cpy_vram_from_ram(1, tilebase, tiles, 64)
    // [445] call cx16_cpy_vram_from_ram
    // [1694] phi from tile_8_x_8_8BPP_256_color::@19 to cx16_cpy_vram_from_ram [phi:tile_8_x_8_8BPP_256_color::@19->cx16_cpy_vram_from_ram]
    // [1694] phi cx16_cpy_vram_from_ram::num#10 = $40 [phi:tile_8_x_8_8BPP_256_color::@19->cx16_cpy_vram_from_ram#0] -- vwuz1=vbuc1 
    lda #<$40
    sta.z cx16_cpy_vram_from_ram.num
    lda #>$40
    sta.z cx16_cpy_vram_from_ram.num+1
    // [1694] phi cx16_cpy_vram_from_ram::sptr_ram#10 = (void *)tile_8_x_8_8BPP_256_color::tiles [phi:tile_8_x_8_8BPP_256_color::@19->cx16_cpy_vram_from_ram#1] -- pvoz1=pvoc1 
    lda #<tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram
    lda #>tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_offset#0 = $4000 [phi:tile_8_x_8_8BPP_256_color::@19->cx16_cpy_vram_from_ram#2] -- vwuz1=vwuc1 
    lda #<$4000
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_offset
    lda #>$4000
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_offset+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:tile_8_x_8_8BPP_256_color::@19->cx16_cpy_vram_from_ram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_ram
    // [446] phi from tile_8_x_8_8BPP_256_color::@19 to tile_8_x_8_8BPP_256_color::@1 [phi:tile_8_x_8_8BPP_256_color::@19->tile_8_x_8_8BPP_256_color::@1]
    // [446] phi tile_8_x_8_8BPP_256_color::t#5 = 1 [phi:tile_8_x_8_8BPP_256_color::@19->tile_8_x_8_8BPP_256_color::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z t
    // [446] phi tile_8_x_8_8BPP_256_color::tilebase#7 = $4000+$40 [phi:tile_8_x_8_8BPP_256_color::@19->tile_8_x_8_8BPP_256_color::@1#1] -- vwuz1=vwuc1 
    lda #<$4000+$40
    sta.z tilebase
    lda #>$4000+$40
    sta.z tilebase+1
    // [446] phi from tile_8_x_8_8BPP_256_color::@20 to tile_8_x_8_8BPP_256_color::@1 [phi:tile_8_x_8_8BPP_256_color::@20->tile_8_x_8_8BPP_256_color::@1]
    // [446] phi tile_8_x_8_8BPP_256_color::t#5 = tile_8_x_8_8BPP_256_color::t#1 [phi:tile_8_x_8_8BPP_256_color::@20->tile_8_x_8_8BPP_256_color::@1#0] -- register_copy 
    // [446] phi tile_8_x_8_8BPP_256_color::tilebase#7 = tile_8_x_8_8BPP_256_color::tilebase#2 [phi:tile_8_x_8_8BPP_256_color::@20->tile_8_x_8_8BPP_256_color::@1#1] -- register_copy 
    // tile_8_x_8_8BPP_256_color::@1
  __b1:
    // [447] phi from tile_8_x_8_8BPP_256_color::@1 to tile_8_x_8_8BPP_256_color::@2 [phi:tile_8_x_8_8BPP_256_color::@1->tile_8_x_8_8BPP_256_color::@2]
    // [447] phi tile_8_x_8_8BPP_256_color::p#2 = 0 [phi:tile_8_x_8_8BPP_256_color::@1->tile_8_x_8_8BPP_256_color::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z p
    // [447] phi from tile_8_x_8_8BPP_256_color::@2 to tile_8_x_8_8BPP_256_color::@2 [phi:tile_8_x_8_8BPP_256_color::@2->tile_8_x_8_8BPP_256_color::@2]
    // [447] phi tile_8_x_8_8BPP_256_color::p#2 = tile_8_x_8_8BPP_256_color::p#1 [phi:tile_8_x_8_8BPP_256_color::@2->tile_8_x_8_8BPP_256_color::@2#0] -- register_copy 
    // tile_8_x_8_8BPP_256_color::@2
  __b2:
    // tiles[p]+=1
    // [448] tile_8_x_8_8BPP_256_color::tiles[tile_8_x_8_8BPP_256_color::p#2] = tile_8_x_8_8BPP_256_color::tiles[tile_8_x_8_8BPP_256_color::p#2] + 1 -- pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_plus_1 
    ldy.z p
    lda tiles,y
    inc
    sta tiles,y
    // for(byte p:0..63)
    // [449] tile_8_x_8_8BPP_256_color::p#1 = ++ tile_8_x_8_8BPP_256_color::p#2 -- vbuz1=_inc_vbuz1 
    inc.z p
    // [450] if(tile_8_x_8_8BPP_256_color::p#1!=$40) goto tile_8_x_8_8BPP_256_color::@2 -- vbuz1_neq_vbuc1_then_la1 
    lda #$40
    cmp.z p
    bne __b2
    // tile_8_x_8_8BPP_256_color::@3
    // cx16_cpy_vram_from_ram(1, tilebase, tiles, 64)
    // [451] cx16_cpy_vram_from_ram::doffset_vram#3 = tile_8_x_8_8BPP_256_color::tilebase#7 -- vwuz1=vwuz2 
    lda.z tilebase
    sta.z cx16_cpy_vram_from_ram.doffset_vram
    lda.z tilebase+1
    sta.z cx16_cpy_vram_from_ram.doffset_vram+1
    // [452] call cx16_cpy_vram_from_ram
    // [1694] phi from tile_8_x_8_8BPP_256_color::@3 to cx16_cpy_vram_from_ram [phi:tile_8_x_8_8BPP_256_color::@3->cx16_cpy_vram_from_ram]
    // [1694] phi cx16_cpy_vram_from_ram::num#10 = $40 [phi:tile_8_x_8_8BPP_256_color::@3->cx16_cpy_vram_from_ram#0] -- vwuz1=vbuc1 
    lda #<$40
    sta.z cx16_cpy_vram_from_ram.num
    lda #>$40
    sta.z cx16_cpy_vram_from_ram.num+1
    // [1694] phi cx16_cpy_vram_from_ram::sptr_ram#10 = (void *)tile_8_x_8_8BPP_256_color::tiles [phi:tile_8_x_8_8BPP_256_color::@3->cx16_cpy_vram_from_ram#1] -- pvoz1=pvoc1 
    lda #<tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram
    lda #>tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_offset#0 = cx16_cpy_vram_from_ram::doffset_vram#3 [phi:tile_8_x_8_8BPP_256_color::@3->cx16_cpy_vram_from_ram#2] -- register_copy 
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:tile_8_x_8_8BPP_256_color::@3->cx16_cpy_vram_from_ram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_ram
    // tile_8_x_8_8BPP_256_color::@20
    // tilebase+=64
    // [453] tile_8_x_8_8BPP_256_color::tilebase#2 = tile_8_x_8_8BPP_256_color::tilebase#7 + $40 -- vwuz1=vwuz1_plus_vbuc1 
    lda #$40
    clc
    adc.z tilebase
    sta.z tilebase
    bcc !+
    inc.z tilebase+1
  !:
    // for(byte t:1..255)
    // [454] tile_8_x_8_8BPP_256_color::t#1 = ++ tile_8_x_8_8BPP_256_color::t#5 -- vbuz1=_inc_vbuz1 
    inc.z t
    // [455] if(tile_8_x_8_8BPP_256_color::t#1!=0) goto tile_8_x_8_8BPP_256_color::@1 -- vbuz1_neq_0_then_la1 
    lda.z t
    bne __b1
    // [456] phi from tile_8_x_8_8BPP_256_color::@20 to tile_8_x_8_8BPP_256_color::@4 [phi:tile_8_x_8_8BPP_256_color::@20->tile_8_x_8_8BPP_256_color::@4]
    // tile_8_x_8_8BPP_256_color::@4
    // vera_tile_area(0, 0, 0, 0, 80, 60, 0, 0, 0)
    // [457] call vera_tile_area
  //vera_tile_area(byte layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset)
    // [1709] phi from tile_8_x_8_8BPP_256_color::@4 to vera_tile_area [phi:tile_8_x_8_8BPP_256_color::@4->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = $50 [phi:tile_8_x_8_8BPP_256_color::@4->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$50
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = $3c [phi:tile_8_x_8_8BPP_256_color::@4->vera_tile_area#1] -- vbuz1=vbuc1 
    lda #$3c
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = 0 [phi:tile_8_x_8_8BPP_256_color::@4->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 0 [phi:tile_8_x_8_8BPP_256_color::@4->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 0 [phi:tile_8_x_8_8BPP_256_color::@4->vera_tile_area#4] -- vwuz1=vbuc1 
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_8BPP_256_color::@4->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [458] phi from tile_8_x_8_8BPP_256_color::@4 to tile_8_x_8_8BPP_256_color::@5 [phi:tile_8_x_8_8BPP_256_color::@4->tile_8_x_8_8BPP_256_color::@5]
    // [458] phi tile_8_x_8_8BPP_256_color::r#5 = 0 [phi:tile_8_x_8_8BPP_256_color::@4->tile_8_x_8_8BPP_256_color::@5#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // [458] phi tile_8_x_8_8BPP_256_color::row#9 = 1 [phi:tile_8_x_8_8BPP_256_color::@4->tile_8_x_8_8BPP_256_color::@5#1] -- vbuz1=vbuc1 
    lda #1
    sta.z row
    // [458] phi tile_8_x_8_8BPP_256_color::tile#10 = 0 [phi:tile_8_x_8_8BPP_256_color::@4->tile_8_x_8_8BPP_256_color::@5#2] -- vwuz1=vwuc1 
    lda #<0
    sta.z tile
    sta.z tile+1
    // [458] phi from tile_8_x_8_8BPP_256_color::@7 to tile_8_x_8_8BPP_256_color::@5 [phi:tile_8_x_8_8BPP_256_color::@7->tile_8_x_8_8BPP_256_color::@5]
    // [458] phi tile_8_x_8_8BPP_256_color::r#5 = tile_8_x_8_8BPP_256_color::r#1 [phi:tile_8_x_8_8BPP_256_color::@7->tile_8_x_8_8BPP_256_color::@5#0] -- register_copy 
    // [458] phi tile_8_x_8_8BPP_256_color::row#9 = tile_8_x_8_8BPP_256_color::row#1 [phi:tile_8_x_8_8BPP_256_color::@7->tile_8_x_8_8BPP_256_color::@5#1] -- register_copy 
    // [458] phi tile_8_x_8_8BPP_256_color::tile#10 = tile_8_x_8_8BPP_256_color::tile#12 [phi:tile_8_x_8_8BPP_256_color::@7->tile_8_x_8_8BPP_256_color::@5#2] -- register_copy 
    // tile_8_x_8_8BPP_256_color::@5
  __b5:
    // [459] phi from tile_8_x_8_8BPP_256_color::@5 to tile_8_x_8_8BPP_256_color::@6 [phi:tile_8_x_8_8BPP_256_color::@5->tile_8_x_8_8BPP_256_color::@6]
    // [459] phi tile_8_x_8_8BPP_256_color::c#2 = 0 [phi:tile_8_x_8_8BPP_256_color::@5->tile_8_x_8_8BPP_256_color::@6#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // [459] phi tile_8_x_8_8BPP_256_color::column#2 = 1 [phi:tile_8_x_8_8BPP_256_color::@5->tile_8_x_8_8BPP_256_color::@6#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column
    // [459] phi tile_8_x_8_8BPP_256_color::tile#6 = tile_8_x_8_8BPP_256_color::tile#10 [phi:tile_8_x_8_8BPP_256_color::@5->tile_8_x_8_8BPP_256_color::@6#2] -- register_copy 
    // [459] phi from tile_8_x_8_8BPP_256_color::@21 to tile_8_x_8_8BPP_256_color::@6 [phi:tile_8_x_8_8BPP_256_color::@21->tile_8_x_8_8BPP_256_color::@6]
    // [459] phi tile_8_x_8_8BPP_256_color::c#2 = tile_8_x_8_8BPP_256_color::c#1 [phi:tile_8_x_8_8BPP_256_color::@21->tile_8_x_8_8BPP_256_color::@6#0] -- register_copy 
    // [459] phi tile_8_x_8_8BPP_256_color::column#2 = tile_8_x_8_8BPP_256_color::column#1 [phi:tile_8_x_8_8BPP_256_color::@21->tile_8_x_8_8BPP_256_color::@6#1] -- register_copy 
    // [459] phi tile_8_x_8_8BPP_256_color::tile#6 = tile_8_x_8_8BPP_256_color::tile#12 [phi:tile_8_x_8_8BPP_256_color::@21->tile_8_x_8_8BPP_256_color::@6#2] -- register_copy 
    // tile_8_x_8_8BPP_256_color::@6
  __b6:
    // vera_tile_area(0, tile, column, row, 1, 1, 0, 0, 0)
    // [460] vera_tile_area::tileindex#5 = tile_8_x_8_8BPP_256_color::tile#6 -- vwuz1=vwuz2 
    lda.z tile
    sta.z vera_tile_area.tileindex
    lda.z tile+1
    sta.z vera_tile_area.tileindex+1
    // [461] vera_tile_area::x#5 = tile_8_x_8_8BPP_256_color::column#2 -- vbuz1=vbuz2 
    lda.z column
    sta.z vera_tile_area.x
    // [462] vera_tile_area::y#5 = tile_8_x_8_8BPP_256_color::row#9 -- vbuz1=vbuz2 
    lda.z row
    sta.z vera_tile_area.y
    // [463] call vera_tile_area
    // [1709] phi from tile_8_x_8_8BPP_256_color::@6 to vera_tile_area [phi:tile_8_x_8_8BPP_256_color::@6->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 1 [phi:tile_8_x_8_8BPP_256_color::@6->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 1 [phi:tile_8_x_8_8BPP_256_color::@6->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#5 [phi:tile_8_x_8_8BPP_256_color::@6->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = vera_tile_area::y#5 [phi:tile_8_x_8_8BPP_256_color::@6->vera_tile_area#3] -- register_copy 
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#5 [phi:tile_8_x_8_8BPP_256_color::@6->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_8BPP_256_color::@6->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // tile_8_x_8_8BPP_256_color::@21
    // column+=2
    // [464] tile_8_x_8_8BPP_256_color::column#1 = tile_8_x_8_8BPP_256_color::column#2 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z column
    clc
    adc #2
    sta.z column
    // tile++;
    // [465] tile_8_x_8_8BPP_256_color::tile#1 = ++ tile_8_x_8_8BPP_256_color::tile#6 -- vwuz1=_inc_vwuz1 
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // tile &= 0xff
    // [466] tile_8_x_8_8BPP_256_color::tile#12 = tile_8_x_8_8BPP_256_color::tile#1 & $ff -- vwuz1=vwuz1_band_vbuc1 
    lda #$ff
    and.z tile
    sta.z tile
    lda #0
    sta.z tile+1
    // for(byte c:0..31)
    // [467] tile_8_x_8_8BPP_256_color::c#1 = ++ tile_8_x_8_8BPP_256_color::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [468] if(tile_8_x_8_8BPP_256_color::c#1!=$20) goto tile_8_x_8_8BPP_256_color::@6 -- vbuz1_neq_vbuc1_then_la1 
    lda #$20
    cmp.z c
    bne __b6
    // tile_8_x_8_8BPP_256_color::@7
    // row += 2
    // [469] tile_8_x_8_8BPP_256_color::row#1 = tile_8_x_8_8BPP_256_color::row#9 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z row
    clc
    adc #2
    sta.z row
    // for(byte r:0..7)
    // [470] tile_8_x_8_8BPP_256_color::r#1 = ++ tile_8_x_8_8BPP_256_color::r#5 -- vbuz1=_inc_vbuz1 
    inc.z r
    // [471] if(tile_8_x_8_8BPP_256_color::r#1!=8) goto tile_8_x_8_8BPP_256_color::@5 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z r
    bne __b5
    // [472] phi from tile_8_x_8_8BPP_256_color::@7 to tile_8_x_8_8BPP_256_color::@8 [phi:tile_8_x_8_8BPP_256_color::@7->tile_8_x_8_8BPP_256_color::@8]
    // [472] phi tile_8_x_8_8BPP_256_color::r1#5 = 0 [phi:tile_8_x_8_8BPP_256_color::@7->tile_8_x_8_8BPP_256_color::@8#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r1
    // [472] phi tile_8_x_8_8BPP_256_color::row#11 = $14 [phi:tile_8_x_8_8BPP_256_color::@7->tile_8_x_8_8BPP_256_color::@8#1] -- vbuz1=vbuc1 
    lda #$14
    sta.z row_1
    // [472] phi tile_8_x_8_8BPP_256_color::tile#11 = 0 [phi:tile_8_x_8_8BPP_256_color::@7->tile_8_x_8_8BPP_256_color::@8#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z tile_1
    sta.z tile_1+1
    // [472] phi from tile_8_x_8_8BPP_256_color::@10 to tile_8_x_8_8BPP_256_color::@8 [phi:tile_8_x_8_8BPP_256_color::@10->tile_8_x_8_8BPP_256_color::@8]
    // [472] phi tile_8_x_8_8BPP_256_color::r1#5 = tile_8_x_8_8BPP_256_color::r1#1 [phi:tile_8_x_8_8BPP_256_color::@10->tile_8_x_8_8BPP_256_color::@8#0] -- register_copy 
    // [472] phi tile_8_x_8_8BPP_256_color::row#11 = tile_8_x_8_8BPP_256_color::row#3 [phi:tile_8_x_8_8BPP_256_color::@10->tile_8_x_8_8BPP_256_color::@8#1] -- register_copy 
    // [472] phi tile_8_x_8_8BPP_256_color::tile#11 = tile_8_x_8_8BPP_256_color::tile#13 [phi:tile_8_x_8_8BPP_256_color::@10->tile_8_x_8_8BPP_256_color::@8#2] -- register_copy 
    // tile_8_x_8_8BPP_256_color::@8
  __b8:
    // [473] phi from tile_8_x_8_8BPP_256_color::@8 to tile_8_x_8_8BPP_256_color::@9 [phi:tile_8_x_8_8BPP_256_color::@8->tile_8_x_8_8BPP_256_color::@9]
    // [473] phi tile_8_x_8_8BPP_256_color::c1#2 = 0 [phi:tile_8_x_8_8BPP_256_color::@8->tile_8_x_8_8BPP_256_color::@9#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c1
    // [473] phi tile_8_x_8_8BPP_256_color::column1#2 = 1 [phi:tile_8_x_8_8BPP_256_color::@8->tile_8_x_8_8BPP_256_color::@9#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column1
    // [473] phi tile_8_x_8_8BPP_256_color::tile#8 = tile_8_x_8_8BPP_256_color::tile#11 [phi:tile_8_x_8_8BPP_256_color::@8->tile_8_x_8_8BPP_256_color::@9#2] -- register_copy 
    // [473] phi from tile_8_x_8_8BPP_256_color::@22 to tile_8_x_8_8BPP_256_color::@9 [phi:tile_8_x_8_8BPP_256_color::@22->tile_8_x_8_8BPP_256_color::@9]
    // [473] phi tile_8_x_8_8BPP_256_color::c1#2 = tile_8_x_8_8BPP_256_color::c1#1 [phi:tile_8_x_8_8BPP_256_color::@22->tile_8_x_8_8BPP_256_color::@9#0] -- register_copy 
    // [473] phi tile_8_x_8_8BPP_256_color::column1#2 = tile_8_x_8_8BPP_256_color::column1#1 [phi:tile_8_x_8_8BPP_256_color::@22->tile_8_x_8_8BPP_256_color::@9#1] -- register_copy 
    // [473] phi tile_8_x_8_8BPP_256_color::tile#8 = tile_8_x_8_8BPP_256_color::tile#13 [phi:tile_8_x_8_8BPP_256_color::@22->tile_8_x_8_8BPP_256_color::@9#2] -- register_copy 
    // tile_8_x_8_8BPP_256_color::@9
  __b9:
    // vera_tile_area(0, tile, column, row, 2, 2, 0, 0, 0)
    // [474] vera_tile_area::tileindex#6 = tile_8_x_8_8BPP_256_color::tile#8 -- vwuz1=vwuz2 
    lda.z tile_1
    sta.z vera_tile_area.tileindex
    lda.z tile_1+1
    sta.z vera_tile_area.tileindex+1
    // [475] vera_tile_area::x#6 = tile_8_x_8_8BPP_256_color::column1#2 -- vbuz1=vbuz2 
    lda.z column1
    sta.z vera_tile_area.x
    // [476] vera_tile_area::y#6 = tile_8_x_8_8BPP_256_color::row#11 -- vbuz1=vbuz2 
    lda.z row_1
    sta.z vera_tile_area.y
    // [477] call vera_tile_area
    // [1709] phi from tile_8_x_8_8BPP_256_color::@9 to vera_tile_area [phi:tile_8_x_8_8BPP_256_color::@9->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 2 [phi:tile_8_x_8_8BPP_256_color::@9->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #2
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 2 [phi:tile_8_x_8_8BPP_256_color::@9->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#6 [phi:tile_8_x_8_8BPP_256_color::@9->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = vera_tile_area::y#6 [phi:tile_8_x_8_8BPP_256_color::@9->vera_tile_area#3] -- register_copy 
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#6 [phi:tile_8_x_8_8BPP_256_color::@9->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_8BPP_256_color::@9->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // tile_8_x_8_8BPP_256_color::@22
    // column+=2
    // [478] tile_8_x_8_8BPP_256_color::column1#1 = tile_8_x_8_8BPP_256_color::column1#2 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z column1
    clc
    adc #2
    sta.z column1
    // tile++;
    // [479] tile_8_x_8_8BPP_256_color::tile#4 = ++ tile_8_x_8_8BPP_256_color::tile#8 -- vwuz1=_inc_vwuz1 
    inc.z tile_1
    bne !+
    inc.z tile_1+1
  !:
    // tile &= 0xff
    // [480] tile_8_x_8_8BPP_256_color::tile#13 = tile_8_x_8_8BPP_256_color::tile#4 & $ff -- vwuz1=vwuz1_band_vbuc1 
    lda #$ff
    and.z tile_1
    sta.z tile_1
    lda #0
    sta.z tile_1+1
    // for(byte c:0..31)
    // [481] tile_8_x_8_8BPP_256_color::c1#1 = ++ tile_8_x_8_8BPP_256_color::c1#2 -- vbuz1=_inc_vbuz1 
    inc.z c1
    // [482] if(tile_8_x_8_8BPP_256_color::c1#1!=$20) goto tile_8_x_8_8BPP_256_color::@9 -- vbuz1_neq_vbuc1_then_la1 
    lda #$20
    cmp.z c1
    bne __b9
    // tile_8_x_8_8BPP_256_color::@10
    // row += 2
    // [483] tile_8_x_8_8BPP_256_color::row#3 = tile_8_x_8_8BPP_256_color::row#11 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z row_1
    clc
    adc #2
    sta.z row_1
    // for(byte r:0..7)
    // [484] tile_8_x_8_8BPP_256_color::r1#1 = ++ tile_8_x_8_8BPP_256_color::r1#5 -- vbuz1=_inc_vbuz1 
    inc.z r1
    // [485] if(tile_8_x_8_8BPP_256_color::r1#1!=8) goto tile_8_x_8_8BPP_256_color::@8 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z r1
    bne __b8
    // tile_8_x_8_8BPP_256_color::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [486] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [487] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [488] phi from tile_8_x_8_8BPP_256_color::vera_layer_show1 to tile_8_x_8_8BPP_256_color::@14 [phi:tile_8_x_8_8BPP_256_color::vera_layer_show1->tile_8_x_8_8BPP_256_color::@14]
    // tile_8_x_8_8BPP_256_color::@14
    // gotoxy(0,50)
    // [489] call gotoxy
    // [242] phi from tile_8_x_8_8BPP_256_color::@14 to gotoxy [phi:tile_8_x_8_8BPP_256_color::@14->gotoxy]
    // [242] phi gotoxy::y#35 = $32 [phi:tile_8_x_8_8BPP_256_color::@14->gotoxy#0] -- vbuz1=vbuc1 
    lda #$32
    sta.z gotoxy.y
    jsr gotoxy
    // [490] phi from tile_8_x_8_8BPP_256_color::@14 to tile_8_x_8_8BPP_256_color::@23 [phi:tile_8_x_8_8BPP_256_color::@14->tile_8_x_8_8BPP_256_color::@23]
    // tile_8_x_8_8BPP_256_color::@23
    // printf("vera in tile mode 8 x 8, color depth 8 bits per pixel.\n")
    // [491] call printf_str
    // [318] phi from tile_8_x_8_8BPP_256_color::@23 to printf_str [phi:tile_8_x_8_8BPP_256_color::@23->printf_str]
    // [318] phi printf_str::s#124 = s [phi:tile_8_x_8_8BPP_256_color::@23->printf_str#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // [492] phi from tile_8_x_8_8BPP_256_color::@23 to tile_8_x_8_8BPP_256_color::@24 [phi:tile_8_x_8_8BPP_256_color::@23->tile_8_x_8_8BPP_256_color::@24]
    // tile_8_x_8_8BPP_256_color::@24
    // printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n")
    // [493] call printf_str
    // [318] phi from tile_8_x_8_8BPP_256_color::@24 to printf_str [phi:tile_8_x_8_8BPP_256_color::@24->printf_str]
    // [318] phi printf_str::s#124 = s1 [phi:tile_8_x_8_8BPP_256_color::@24->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [494] phi from tile_8_x_8_8BPP_256_color::@24 to tile_8_x_8_8BPP_256_color::@25 [phi:tile_8_x_8_8BPP_256_color::@24->tile_8_x_8_8BPP_256_color::@25]
    // tile_8_x_8_8BPP_256_color::@25
    // printf("each tile can have a variation of 256 colors.\n")
    // [495] call printf_str
    // [318] phi from tile_8_x_8_8BPP_256_color::@25 to printf_str [phi:tile_8_x_8_8BPP_256_color::@25->printf_str]
    // [318] phi printf_str::s#124 = s2 [phi:tile_8_x_8_8BPP_256_color::@25->printf_str#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // [496] phi from tile_8_x_8_8BPP_256_color::@25 to tile_8_x_8_8BPP_256_color::@26 [phi:tile_8_x_8_8BPP_256_color::@25->tile_8_x_8_8BPP_256_color::@26]
    // tile_8_x_8_8BPP_256_color::@26
    // printf("the vera palette of 256 colors, can be used by setting the palette\n")
    // [497] call printf_str
    // [318] phi from tile_8_x_8_8BPP_256_color::@26 to printf_str [phi:tile_8_x_8_8BPP_256_color::@26->printf_str]
    // [318] phi printf_str::s#124 = s3 [phi:tile_8_x_8_8BPP_256_color::@26->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // [498] phi from tile_8_x_8_8BPP_256_color::@26 to tile_8_x_8_8BPP_256_color::@27 [phi:tile_8_x_8_8BPP_256_color::@26->tile_8_x_8_8BPP_256_color::@27]
    // tile_8_x_8_8BPP_256_color::@27
    // printf("offset for each tile.\n")
    // [499] call printf_str
    // [318] phi from tile_8_x_8_8BPP_256_color::@27 to printf_str [phi:tile_8_x_8_8BPP_256_color::@27->printf_str]
    // [318] phi printf_str::s#124 = s4 [phi:tile_8_x_8_8BPP_256_color::@27->printf_str#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // [500] phi from tile_8_x_8_8BPP_256_color::@27 to tile_8_x_8_8BPP_256_color::@28 [phi:tile_8_x_8_8BPP_256_color::@27->tile_8_x_8_8BPP_256_color::@28]
    // tile_8_x_8_8BPP_256_color::@28
    // printf("here each column is displaying the same tile, but with different offsets!\n")
    // [501] call printf_str
    // [318] phi from tile_8_x_8_8BPP_256_color::@28 to printf_str [phi:tile_8_x_8_8BPP_256_color::@28->printf_str]
    // [318] phi printf_str::s#124 = s5 [phi:tile_8_x_8_8BPP_256_color::@28->printf_str#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // [502] phi from tile_8_x_8_8BPP_256_color::@28 to tile_8_x_8_8BPP_256_color::@29 [phi:tile_8_x_8_8BPP_256_color::@28->tile_8_x_8_8BPP_256_color::@29]
    // tile_8_x_8_8BPP_256_color::@29
    // printf("each offset aligns to multiples of 16 colors in the palette!.\n")
    // [503] call printf_str
    // [318] phi from tile_8_x_8_8BPP_256_color::@29 to printf_str [phi:tile_8_x_8_8BPP_256_color::@29->printf_str]
    // [318] phi printf_str::s#124 = s6 [phi:tile_8_x_8_8BPP_256_color::@29->printf_str#0] -- pbuz1=pbuc1 
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    jsr printf_str
    // [504] phi from tile_8_x_8_8BPP_256_color::@29 to tile_8_x_8_8BPP_256_color::@30 [phi:tile_8_x_8_8BPP_256_color::@29->tile_8_x_8_8BPP_256_color::@30]
    // tile_8_x_8_8BPP_256_color::@30
    // printf("however, the first color will always be transparent (black).\n")
    // [505] call printf_str
    // [318] phi from tile_8_x_8_8BPP_256_color::@30 to printf_str [phi:tile_8_x_8_8BPP_256_color::@30->printf_str]
    // [318] phi printf_str::s#124 = s7 [phi:tile_8_x_8_8BPP_256_color::@30->printf_str#0] -- pbuz1=pbuc1 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // [506] phi from tile_8_x_8_8BPP_256_color::@30 tile_8_x_8_8BPP_256_color::@31 to tile_8_x_8_8BPP_256_color::@11 [phi:tile_8_x_8_8BPP_256_color::@30/tile_8_x_8_8BPP_256_color::@31->tile_8_x_8_8BPP_256_color::@11]
    // tile_8_x_8_8BPP_256_color::@11
  __b11:
    // getin()
    // [507] call getin
    jsr getin
    // [508] getin::return#28 = getin::return#1
    // tile_8_x_8_8BPP_256_color::@31
    // [509] tile_8_x_8_8BPP_256_color::$29 = getin::return#28
    // while(!getin())
    // [510] if(0==tile_8_x_8_8BPP_256_color::$29) goto tile_8_x_8_8BPP_256_color::@11 -- 0_eq_vbuz1_then_la1 
    lda.z __29
    beq __b11
    // [511] phi from tile_8_x_8_8BPP_256_color::@31 to tile_8_x_8_8BPP_256_color::@12 [phi:tile_8_x_8_8BPP_256_color::@31->tile_8_x_8_8BPP_256_color::@12]
    // tile_8_x_8_8BPP_256_color::@12
    // cx16_cpy_vram_from_vram(0, 0xF800, 1, 0xF000, 256*8)
    // [512] call cx16_cpy_vram_from_vram
    // [1674] phi from tile_8_x_8_8BPP_256_color::@12 to cx16_cpy_vram_from_vram [phi:tile_8_x_8_8BPP_256_color::@12->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f800 [phi:tile_8_x_8_8BPP_256_color::@12->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 0 [phi:tile_8_x_8_8BPP_256_color::@12->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f000 [phi:tile_8_x_8_8BPP_256_color::@12->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:tile_8_x_8_8BPP_256_color::@12->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // tile_8_x_8_8BPP_256_color::@return
    // }
    // [513] return 
    rts
  .segment Data
    tiles: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}
.segment Code
  // tile_16_x_16_4BPP_16_color
tile_16_x_16_4BPP_16_color: {
    .label __28 = $17
    .label __33 = $66
    .label column = $da
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label tile = $b6
    .label c = $cf
    .label column_1 = $5b
    .label c1 = $5a
    .label column_2 = $5c
    .label c2 = $65
    .label column_3 = $1a
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label tile_1 = $b4
    .label c3 = $d5
    .label column1 = $be
    .label c4 = $b2
    .label offset = $78
    .label row = $16
    .label r = $d6
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label tile_2 = $ab
    // vera_layer_mode_tile(0, 0x04000, 0x14000, 128, 128, 16, 16, 4)
    // [515] call vera_layer_mode_tile
    // [1580] phi from tile_16_x_16_4BPP_16_color to vera_layer_mode_tile [phi:tile_16_x_16_4BPP_16_color->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = $10 [phi:tile_16_x_16_4BPP_16_color->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #$10
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = $10 [phi:tile_16_x_16_4BPP_16_color->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $14000 [phi:tile_16_x_16_4BPP_16_color->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $4000 [phi:tile_16_x_16_4BPP_16_color->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$4000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$4000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$4000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$4000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $80 [phi:tile_16_x_16_4BPP_16_color->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapheight
    lda #>$80
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 0 [phi:tile_16_x_16_4BPP_16_color->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $80 [phi:tile_16_x_16_4BPP_16_color->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 4 [phi:tile_16_x_16_4BPP_16_color->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // tile_16_x_16_4BPP_16_color::vera_display_set_scale_none1
    // *VERA_DC_HSCALE = 128
    // [516] *VERA_DC_HSCALE = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 128
    // [517] *VERA_DC_VSCALE = $80 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // [518] phi from tile_16_x_16_4BPP_16_color::vera_display_set_scale_none1 to tile_16_x_16_4BPP_16_color::@11 [phi:tile_16_x_16_4BPP_16_color::vera_display_set_scale_none1->tile_16_x_16_4BPP_16_color::@11]
    // tile_16_x_16_4BPP_16_color::@11
    // vera_layer_mode_text( 1, 0x00000, 0x0F800, 128, 128, 8, 8, 256 )
    // [519] call vera_layer_mode_text
    // [185] phi from tile_16_x_16_4BPP_16_color::@11 to vera_layer_mode_text [phi:tile_16_x_16_4BPP_16_color::@11->vera_layer_mode_text]
    // [185] phi vera_layer_mode_text::color_mode#11 = $100 [phi:tile_16_x_16_4BPP_16_color::@11->vera_layer_mode_text#0] -- vwuz1=vwuc1 
    lda #<$100
    sta.z vera_layer_mode_text.color_mode
    lda #>$100
    sta.z vera_layer_mode_text.color_mode+1
    // [185] phi vera_layer_mode_text::mapheight#11 = $80 [phi:tile_16_x_16_4BPP_16_color::@11->vera_layer_mode_text#1] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapheight
    lda #>$80
    sta.z vera_layer_mode_text.mapheight+1
    // [185] phi vera_layer_mode_text::mapwidth#11 = $80 [phi:tile_16_x_16_4BPP_16_color::@11->vera_layer_mode_text#2] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapwidth
    lda #>$80
    sta.z vera_layer_mode_text.mapwidth+1
    jsr vera_layer_mode_text
    // [520] phi from tile_16_x_16_4BPP_16_color::@11 to tile_16_x_16_4BPP_16_color::@13 [phi:tile_16_x_16_4BPP_16_color::@11->tile_16_x_16_4BPP_16_color::@13]
    // tile_16_x_16_4BPP_16_color::@13
    // screenlayer(1)
    // [521] call screenlayer
    jsr screenlayer
    // [522] phi from tile_16_x_16_4BPP_16_color::@13 to tile_16_x_16_4BPP_16_color::@14 [phi:tile_16_x_16_4BPP_16_color::@13->tile_16_x_16_4BPP_16_color::@14]
    // tile_16_x_16_4BPP_16_color::@14
    // textcolor(WHITE)
    // [523] call textcolor
    // [274] phi from tile_16_x_16_4BPP_16_color::@14 to textcolor [phi:tile_16_x_16_4BPP_16_color::@14->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:tile_16_x_16_4BPP_16_color::@14->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [524] phi from tile_16_x_16_4BPP_16_color::@14 to tile_16_x_16_4BPP_16_color::@15 [phi:tile_16_x_16_4BPP_16_color::@14->tile_16_x_16_4BPP_16_color::@15]
    // tile_16_x_16_4BPP_16_color::@15
    // bgcolor(BLACK)
    // [525] call bgcolor
    // [279] phi from tile_16_x_16_4BPP_16_color::@15 to bgcolor [phi:tile_16_x_16_4BPP_16_color::@15->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:tile_16_x_16_4BPP_16_color::@15->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [526] phi from tile_16_x_16_4BPP_16_color::@15 to tile_16_x_16_4BPP_16_color::@16 [phi:tile_16_x_16_4BPP_16_color::@15->tile_16_x_16_4BPP_16_color::@16]
    // tile_16_x_16_4BPP_16_color::@16
    // clrscr()
    // [527] call clrscr
    jsr clrscr
    // [528] phi from tile_16_x_16_4BPP_16_color::@16 to tile_16_x_16_4BPP_16_color::@17 [phi:tile_16_x_16_4BPP_16_color::@16->tile_16_x_16_4BPP_16_color::@17]
    // tile_16_x_16_4BPP_16_color::@17
    // cx16_cpy_vram_from_ram(1, 0x4000, tiles, 2048)
    // [529] call cx16_cpy_vram_from_ram
    // [1694] phi from tile_16_x_16_4BPP_16_color::@17 to cx16_cpy_vram_from_ram [phi:tile_16_x_16_4BPP_16_color::@17->cx16_cpy_vram_from_ram]
    // [1694] phi cx16_cpy_vram_from_ram::num#10 = $800 [phi:tile_16_x_16_4BPP_16_color::@17->cx16_cpy_vram_from_ram#0] -- vwuz1=vwuc1 
    lda #<$800
    sta.z cx16_cpy_vram_from_ram.num
    lda #>$800
    sta.z cx16_cpy_vram_from_ram.num+1
    // [1694] phi cx16_cpy_vram_from_ram::sptr_ram#10 = (void *)tile_16_x_16_4BPP_16_color::tiles [phi:tile_16_x_16_4BPP_16_color::@17->cx16_cpy_vram_from_ram#1] -- pvoz1=pvoc1 
    lda #<tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram
    lda #>tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_offset#0 = $4000 [phi:tile_16_x_16_4BPP_16_color::@17->cx16_cpy_vram_from_ram#2] -- vwuz1=vwuc1 
    lda #<$4000
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_offset
    lda #>$4000
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_offset+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:tile_16_x_16_4BPP_16_color::@17->cx16_cpy_vram_from_ram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_ram
    // [530] phi from tile_16_x_16_4BPP_16_color::@17 to tile_16_x_16_4BPP_16_color::@18 [phi:tile_16_x_16_4BPP_16_color::@17->tile_16_x_16_4BPP_16_color::@18]
    // tile_16_x_16_4BPP_16_color::@18
    // vera_tile_area(0, 0, 0, 0, 40, 30, 0, 0, 0)
    // [531] call vera_tile_area
  //vera_tile_area(byte layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset)
    // [1709] phi from tile_16_x_16_4BPP_16_color::@18 to vera_tile_area [phi:tile_16_x_16_4BPP_16_color::@18->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = $28 [phi:tile_16_x_16_4BPP_16_color::@18->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$28
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = $1e [phi:tile_16_x_16_4BPP_16_color::@18->vera_tile_area#1] -- vbuz1=vbuc1 
    lda #$1e
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = 0 [phi:tile_16_x_16_4BPP_16_color::@18->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 0 [phi:tile_16_x_16_4BPP_16_color::@18->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 0 [phi:tile_16_x_16_4BPP_16_color::@18->vera_tile_area#4] -- vwuz1=vbuc1 
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_4BPP_16_color::@18->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [532] phi from tile_16_x_16_4BPP_16_color::@18 to tile_16_x_16_4BPP_16_color::@1 [phi:tile_16_x_16_4BPP_16_color::@18->tile_16_x_16_4BPP_16_color::@1]
    // [532] phi tile_16_x_16_4BPP_16_color::c#2 = 0 [phi:tile_16_x_16_4BPP_16_color::@18->tile_16_x_16_4BPP_16_color::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // [532] phi tile_16_x_16_4BPP_16_color::column#8 = 1 [phi:tile_16_x_16_4BPP_16_color::@18->tile_16_x_16_4BPP_16_color::@1#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column
    // [532] phi tile_16_x_16_4BPP_16_color::tile#10 = 0 [phi:tile_16_x_16_4BPP_16_color::@18->tile_16_x_16_4BPP_16_color::@1#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z tile
    sta.z tile+1
    // [532] phi from tile_16_x_16_4BPP_16_color::@19 to tile_16_x_16_4BPP_16_color::@1 [phi:tile_16_x_16_4BPP_16_color::@19->tile_16_x_16_4BPP_16_color::@1]
    // [532] phi tile_16_x_16_4BPP_16_color::c#2 = tile_16_x_16_4BPP_16_color::c#1 [phi:tile_16_x_16_4BPP_16_color::@19->tile_16_x_16_4BPP_16_color::@1#0] -- register_copy 
    // [532] phi tile_16_x_16_4BPP_16_color::column#8 = tile_16_x_16_4BPP_16_color::column#1 [phi:tile_16_x_16_4BPP_16_color::@19->tile_16_x_16_4BPP_16_color::@1#1] -- register_copy 
    // [532] phi tile_16_x_16_4BPP_16_color::tile#10 = tile_16_x_16_4BPP_16_color::tile#2 [phi:tile_16_x_16_4BPP_16_color::@19->tile_16_x_16_4BPP_16_color::@1#2] -- register_copy 
    // tile_16_x_16_4BPP_16_color::@1
  __b1:
    // vera_tile_area(0, tile, column, 1, 1, 1, 0, 0, 0)
    // [533] vera_tile_area::tileindex#8 = tile_16_x_16_4BPP_16_color::tile#10 -- vwuz1=vwuz2 
    lda.z tile
    sta.z vera_tile_area.tileindex
    lda.z tile+1
    sta.z vera_tile_area.tileindex+1
    // [534] vera_tile_area::x#8 = tile_16_x_16_4BPP_16_color::column#8 -- vbuz1=vbuz2 
    lda.z column
    sta.z vera_tile_area.x
    // [535] call vera_tile_area
    // [1709] phi from tile_16_x_16_4BPP_16_color::@1 to vera_tile_area [phi:tile_16_x_16_4BPP_16_color::@1->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 1 [phi:tile_16_x_16_4BPP_16_color::@1->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 1 [phi:tile_16_x_16_4BPP_16_color::@1->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#8 [phi:tile_16_x_16_4BPP_16_color::@1->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = 1 [phi:tile_16_x_16_4BPP_16_color::@1->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#8 [phi:tile_16_x_16_4BPP_16_color::@1->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_4BPP_16_color::@1->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // tile_16_x_16_4BPP_16_color::@19
    // column+=4
    // [536] tile_16_x_16_4BPP_16_color::column#1 = tile_16_x_16_4BPP_16_color::column#8 + 4 -- vbuz1=vbuz1_plus_vbuc1 
    lda #4
    clc
    adc.z column
    sta.z column
    // tile++;
    // [537] tile_16_x_16_4BPP_16_color::tile#2 = ++ tile_16_x_16_4BPP_16_color::tile#10 -- vwuz1=_inc_vwuz1 
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // for(byte c:0..7)
    // [538] tile_16_x_16_4BPP_16_color::c#1 = ++ tile_16_x_16_4BPP_16_color::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [539] if(tile_16_x_16_4BPP_16_color::c#1!=8) goto tile_16_x_16_4BPP_16_color::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z c
    bne __b1
    // [540] phi from tile_16_x_16_4BPP_16_color::@19 to tile_16_x_16_4BPP_16_color::@2 [phi:tile_16_x_16_4BPP_16_color::@19->tile_16_x_16_4BPP_16_color::@2]
    // [540] phi tile_16_x_16_4BPP_16_color::c1#2 = 0 [phi:tile_16_x_16_4BPP_16_color::@19->tile_16_x_16_4BPP_16_color::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c1
    // [540] phi tile_16_x_16_4BPP_16_color::column#10 = 1 [phi:tile_16_x_16_4BPP_16_color::@19->tile_16_x_16_4BPP_16_color::@2#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column_1
    // [540] phi tile_16_x_16_4BPP_16_color::tile#12 = tile_16_x_16_4BPP_16_color::tile#2 [phi:tile_16_x_16_4BPP_16_color::@19->tile_16_x_16_4BPP_16_color::@2#2] -- register_copy 
    // [540] phi from tile_16_x_16_4BPP_16_color::@20 to tile_16_x_16_4BPP_16_color::@2 [phi:tile_16_x_16_4BPP_16_color::@20->tile_16_x_16_4BPP_16_color::@2]
    // [540] phi tile_16_x_16_4BPP_16_color::c1#2 = tile_16_x_16_4BPP_16_color::c1#1 [phi:tile_16_x_16_4BPP_16_color::@20->tile_16_x_16_4BPP_16_color::@2#0] -- register_copy 
    // [540] phi tile_16_x_16_4BPP_16_color::column#10 = tile_16_x_16_4BPP_16_color::column#3 [phi:tile_16_x_16_4BPP_16_color::@20->tile_16_x_16_4BPP_16_color::@2#1] -- register_copy 
    // [540] phi tile_16_x_16_4BPP_16_color::tile#12 = tile_16_x_16_4BPP_16_color::tile#3 [phi:tile_16_x_16_4BPP_16_color::@20->tile_16_x_16_4BPP_16_color::@2#2] -- register_copy 
    // tile_16_x_16_4BPP_16_color::@2
  __b2:
    // vera_tile_area(0, tile, column, 3, 1, 1, 0, 0, 0)
    // [541] vera_tile_area::tileindex#9 = tile_16_x_16_4BPP_16_color::tile#12 -- vwuz1=vwuz2 
    lda.z tile
    sta.z vera_tile_area.tileindex
    lda.z tile+1
    sta.z vera_tile_area.tileindex+1
    // [542] vera_tile_area::x#9 = tile_16_x_16_4BPP_16_color::column#10 -- vbuz1=vbuz2 
    lda.z column_1
    sta.z vera_tile_area.x
    // [543] call vera_tile_area
    // [1709] phi from tile_16_x_16_4BPP_16_color::@2 to vera_tile_area [phi:tile_16_x_16_4BPP_16_color::@2->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 1 [phi:tile_16_x_16_4BPP_16_color::@2->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 1 [phi:tile_16_x_16_4BPP_16_color::@2->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#9 [phi:tile_16_x_16_4BPP_16_color::@2->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = 3 [phi:tile_16_x_16_4BPP_16_color::@2->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #3
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#9 [phi:tile_16_x_16_4BPP_16_color::@2->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_4BPP_16_color::@2->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // tile_16_x_16_4BPP_16_color::@20
    // column+=4
    // [544] tile_16_x_16_4BPP_16_color::column#3 = tile_16_x_16_4BPP_16_color::column#10 + 4 -- vbuz1=vbuz1_plus_vbuc1 
    lda #4
    clc
    adc.z column_1
    sta.z column_1
    // tile++;
    // [545] tile_16_x_16_4BPP_16_color::tile#3 = ++ tile_16_x_16_4BPP_16_color::tile#12 -- vwuz1=_inc_vwuz1 
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // for(byte c:0..7)
    // [546] tile_16_x_16_4BPP_16_color::c1#1 = ++ tile_16_x_16_4BPP_16_color::c1#2 -- vbuz1=_inc_vbuz1 
    inc.z c1
    // [547] if(tile_16_x_16_4BPP_16_color::c1#1!=8) goto tile_16_x_16_4BPP_16_color::@2 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z c1
    bne __b2
    // [548] phi from tile_16_x_16_4BPP_16_color::@20 to tile_16_x_16_4BPP_16_color::@3 [phi:tile_16_x_16_4BPP_16_color::@20->tile_16_x_16_4BPP_16_color::@3]
    // [548] phi tile_16_x_16_4BPP_16_color::c2#2 = 0 [phi:tile_16_x_16_4BPP_16_color::@20->tile_16_x_16_4BPP_16_color::@3#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c2
    // [548] phi tile_16_x_16_4BPP_16_color::column#12 = 1 [phi:tile_16_x_16_4BPP_16_color::@20->tile_16_x_16_4BPP_16_color::@3#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column_2
    // [548] phi tile_16_x_16_4BPP_16_color::tile#14 = 0 [phi:tile_16_x_16_4BPP_16_color::@20->tile_16_x_16_4BPP_16_color::@3#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z tile_1
    sta.z tile_1+1
    // [548] phi from tile_16_x_16_4BPP_16_color::@21 to tile_16_x_16_4BPP_16_color::@3 [phi:tile_16_x_16_4BPP_16_color::@21->tile_16_x_16_4BPP_16_color::@3]
    // [548] phi tile_16_x_16_4BPP_16_color::c2#2 = tile_16_x_16_4BPP_16_color::c2#1 [phi:tile_16_x_16_4BPP_16_color::@21->tile_16_x_16_4BPP_16_color::@3#0] -- register_copy 
    // [548] phi tile_16_x_16_4BPP_16_color::column#12 = tile_16_x_16_4BPP_16_color::column#5 [phi:tile_16_x_16_4BPP_16_color::@21->tile_16_x_16_4BPP_16_color::@3#1] -- register_copy 
    // [548] phi tile_16_x_16_4BPP_16_color::tile#14 = tile_16_x_16_4BPP_16_color::tile#22 [phi:tile_16_x_16_4BPP_16_color::@21->tile_16_x_16_4BPP_16_color::@3#2] -- register_copy 
    // tile_16_x_16_4BPP_16_color::@3
  __b3:
    // vera_tile_area(0, tile, column, 5, 3, 3, 0, 0, 0)
    // [549] vera_tile_area::tileindex#10 = tile_16_x_16_4BPP_16_color::tile#14 -- vwuz1=vwuz2 
    lda.z tile_1
    sta.z vera_tile_area.tileindex
    lda.z tile_1+1
    sta.z vera_tile_area.tileindex+1
    // [550] vera_tile_area::x#10 = tile_16_x_16_4BPP_16_color::column#12 -- vbuz1=vbuz2 
    lda.z column_2
    sta.z vera_tile_area.x
    // [551] call vera_tile_area
    // [1709] phi from tile_16_x_16_4BPP_16_color::@3 to vera_tile_area [phi:tile_16_x_16_4BPP_16_color::@3->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 3 [phi:tile_16_x_16_4BPP_16_color::@3->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #3
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 3 [phi:tile_16_x_16_4BPP_16_color::@3->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#10 [phi:tile_16_x_16_4BPP_16_color::@3->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = 5 [phi:tile_16_x_16_4BPP_16_color::@3->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #5
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#10 [phi:tile_16_x_16_4BPP_16_color::@3->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_4BPP_16_color::@3->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // tile_16_x_16_4BPP_16_color::@21
    // column+=4
    // [552] tile_16_x_16_4BPP_16_color::column#5 = tile_16_x_16_4BPP_16_color::column#12 + 4 -- vbuz1=vbuz1_plus_vbuc1 
    lda #4
    clc
    adc.z column_2
    sta.z column_2
    // tile++;
    // [553] tile_16_x_16_4BPP_16_color::tile#22 = ++ tile_16_x_16_4BPP_16_color::tile#14 -- vwuz1=_inc_vwuz1 
    inc.z tile_1
    bne !+
    inc.z tile_1+1
  !:
    // for(byte c:0..7)
    // [554] tile_16_x_16_4BPP_16_color::c2#1 = ++ tile_16_x_16_4BPP_16_color::c2#2 -- vbuz1=_inc_vbuz1 
    inc.z c2
    // [555] if(tile_16_x_16_4BPP_16_color::c2#1!=8) goto tile_16_x_16_4BPP_16_color::@3 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z c2
    bne __b3
    // [556] phi from tile_16_x_16_4BPP_16_color::@21 to tile_16_x_16_4BPP_16_color::@4 [phi:tile_16_x_16_4BPP_16_color::@21->tile_16_x_16_4BPP_16_color::@4]
    // [556] phi tile_16_x_16_4BPP_16_color::c3#2 = 0 [phi:tile_16_x_16_4BPP_16_color::@21->tile_16_x_16_4BPP_16_color::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c3
    // [556] phi tile_16_x_16_4BPP_16_color::column#14 = 1 [phi:tile_16_x_16_4BPP_16_color::@21->tile_16_x_16_4BPP_16_color::@4#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column_3
    // [556] phi tile_16_x_16_4BPP_16_color::tile#16 = tile_16_x_16_4BPP_16_color::tile#22 [phi:tile_16_x_16_4BPP_16_color::@21->tile_16_x_16_4BPP_16_color::@4#2] -- register_copy 
    // [556] phi from tile_16_x_16_4BPP_16_color::@22 to tile_16_x_16_4BPP_16_color::@4 [phi:tile_16_x_16_4BPP_16_color::@22->tile_16_x_16_4BPP_16_color::@4]
    // [556] phi tile_16_x_16_4BPP_16_color::c3#2 = tile_16_x_16_4BPP_16_color::c3#1 [phi:tile_16_x_16_4BPP_16_color::@22->tile_16_x_16_4BPP_16_color::@4#0] -- register_copy 
    // [556] phi tile_16_x_16_4BPP_16_color::column#14 = tile_16_x_16_4BPP_16_color::column#7 [phi:tile_16_x_16_4BPP_16_color::@22->tile_16_x_16_4BPP_16_color::@4#1] -- register_copy 
    // [556] phi tile_16_x_16_4BPP_16_color::tile#16 = tile_16_x_16_4BPP_16_color::tile#6 [phi:tile_16_x_16_4BPP_16_color::@22->tile_16_x_16_4BPP_16_color::@4#2] -- register_copy 
    // tile_16_x_16_4BPP_16_color::@4
  __b4:
    // vera_tile_area(0, tile, column, 9, 3, 3, 0, 0, 0)
    // [557] vera_tile_area::tileindex#11 = tile_16_x_16_4BPP_16_color::tile#16 -- vwuz1=vwuz2 
    lda.z tile_1
    sta.z vera_tile_area.tileindex
    lda.z tile_1+1
    sta.z vera_tile_area.tileindex+1
    // [558] vera_tile_area::x#11 = tile_16_x_16_4BPP_16_color::column#14 -- vbuz1=vbuz2 
    lda.z column_3
    sta.z vera_tile_area.x
    // [559] call vera_tile_area
    // [1709] phi from tile_16_x_16_4BPP_16_color::@4 to vera_tile_area [phi:tile_16_x_16_4BPP_16_color::@4->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 3 [phi:tile_16_x_16_4BPP_16_color::@4->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #3
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 3 [phi:tile_16_x_16_4BPP_16_color::@4->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#11 [phi:tile_16_x_16_4BPP_16_color::@4->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = 9 [phi:tile_16_x_16_4BPP_16_color::@4->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #9
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#11 [phi:tile_16_x_16_4BPP_16_color::@4->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_4BPP_16_color::@4->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // tile_16_x_16_4BPP_16_color::@22
    // column+=4
    // [560] tile_16_x_16_4BPP_16_color::column#7 = tile_16_x_16_4BPP_16_color::column#14 + 4 -- vbuz1=vbuz1_plus_vbuc1 
    lda #4
    clc
    adc.z column_3
    sta.z column_3
    // tile++;
    // [561] tile_16_x_16_4BPP_16_color::tile#6 = ++ tile_16_x_16_4BPP_16_color::tile#16 -- vwuz1=_inc_vwuz1 
    inc.z tile_1
    bne !+
    inc.z tile_1+1
  !:
    // for(byte c:0..7)
    // [562] tile_16_x_16_4BPP_16_color::c3#1 = ++ tile_16_x_16_4BPP_16_color::c3#2 -- vbuz1=_inc_vbuz1 
    inc.z c3
    // [563] if(tile_16_x_16_4BPP_16_color::c3#1!=8) goto tile_16_x_16_4BPP_16_color::@4 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z c3
    bne __b4
    // [564] phi from tile_16_x_16_4BPP_16_color::@22 to tile_16_x_16_4BPP_16_color::@5 [phi:tile_16_x_16_4BPP_16_color::@22->tile_16_x_16_4BPP_16_color::@5]
    // [564] phi tile_16_x_16_4BPP_16_color::r#7 = 0 [phi:tile_16_x_16_4BPP_16_color::@22->tile_16_x_16_4BPP_16_color::@5#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // [564] phi tile_16_x_16_4BPP_16_color::offset#5 = 0 [phi:tile_16_x_16_4BPP_16_color::@22->tile_16_x_16_4BPP_16_color::@5#1] -- vbuz1=vbuc1 
    sta.z offset
    // [564] phi tile_16_x_16_4BPP_16_color::row#5 = $d [phi:tile_16_x_16_4BPP_16_color::@22->tile_16_x_16_4BPP_16_color::@5#2] -- vbuz1=vbuc1 
    lda #$d
    sta.z row
    // [564] phi tile_16_x_16_4BPP_16_color::tile#23 = 0 [phi:tile_16_x_16_4BPP_16_color::@22->tile_16_x_16_4BPP_16_color::@5#3] -- vwuz1=vbuc1 
    lda #<0
    sta.z tile_2
    sta.z tile_2+1
    // [564] phi from tile_16_x_16_4BPP_16_color::@9 to tile_16_x_16_4BPP_16_color::@5 [phi:tile_16_x_16_4BPP_16_color::@9->tile_16_x_16_4BPP_16_color::@5]
    // [564] phi tile_16_x_16_4BPP_16_color::r#7 = tile_16_x_16_4BPP_16_color::r#1 [phi:tile_16_x_16_4BPP_16_color::@9->tile_16_x_16_4BPP_16_color::@5#0] -- register_copy 
    // [564] phi tile_16_x_16_4BPP_16_color::offset#5 = tile_16_x_16_4BPP_16_color::offset#4 [phi:tile_16_x_16_4BPP_16_color::@9->tile_16_x_16_4BPP_16_color::@5#1] -- register_copy 
    // [564] phi tile_16_x_16_4BPP_16_color::row#5 = tile_16_x_16_4BPP_16_color::row#1 [phi:tile_16_x_16_4BPP_16_color::@9->tile_16_x_16_4BPP_16_color::@5#2] -- register_copy 
    // [564] phi tile_16_x_16_4BPP_16_color::tile#23 = tile_16_x_16_4BPP_16_color::tile#25 [phi:tile_16_x_16_4BPP_16_color::@9->tile_16_x_16_4BPP_16_color::@5#3] -- register_copy 
    // tile_16_x_16_4BPP_16_color::@5
  __b5:
    // [565] phi from tile_16_x_16_4BPP_16_color::@5 to tile_16_x_16_4BPP_16_color::@6 [phi:tile_16_x_16_4BPP_16_color::@5->tile_16_x_16_4BPP_16_color::@6]
    // [565] phi tile_16_x_16_4BPP_16_color::c4#2 = 0 [phi:tile_16_x_16_4BPP_16_color::@5->tile_16_x_16_4BPP_16_color::@6#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c4
    // [565] phi tile_16_x_16_4BPP_16_color::offset#2 = tile_16_x_16_4BPP_16_color::offset#5 [phi:tile_16_x_16_4BPP_16_color::@5->tile_16_x_16_4BPP_16_color::@6#1] -- register_copy 
    // [565] phi tile_16_x_16_4BPP_16_color::column1#2 = 1 [phi:tile_16_x_16_4BPP_16_color::@5->tile_16_x_16_4BPP_16_color::@6#2] -- vbuz1=vbuc1 
    lda #1
    sta.z column1
    // [565] phi tile_16_x_16_4BPP_16_color::tile#18 = tile_16_x_16_4BPP_16_color::tile#23 [phi:tile_16_x_16_4BPP_16_color::@5->tile_16_x_16_4BPP_16_color::@6#3] -- register_copy 
    // [565] phi from tile_16_x_16_4BPP_16_color::@7 to tile_16_x_16_4BPP_16_color::@6 [phi:tile_16_x_16_4BPP_16_color::@7->tile_16_x_16_4BPP_16_color::@6]
    // [565] phi tile_16_x_16_4BPP_16_color::c4#2 = tile_16_x_16_4BPP_16_color::c4#1 [phi:tile_16_x_16_4BPP_16_color::@7->tile_16_x_16_4BPP_16_color::@6#0] -- register_copy 
    // [565] phi tile_16_x_16_4BPP_16_color::offset#2 = tile_16_x_16_4BPP_16_color::offset#4 [phi:tile_16_x_16_4BPP_16_color::@7->tile_16_x_16_4BPP_16_color::@6#1] -- register_copy 
    // [565] phi tile_16_x_16_4BPP_16_color::column1#2 = tile_16_x_16_4BPP_16_color::column1#1 [phi:tile_16_x_16_4BPP_16_color::@7->tile_16_x_16_4BPP_16_color::@6#2] -- register_copy 
    // [565] phi tile_16_x_16_4BPP_16_color::tile#18 = tile_16_x_16_4BPP_16_color::tile#25 [phi:tile_16_x_16_4BPP_16_color::@7->tile_16_x_16_4BPP_16_color::@6#3] -- register_copy 
    // tile_16_x_16_4BPP_16_color::@6
  __b6:
    // vera_tile_area(0, tile, column, row, 1, 1, 0, 0, offset)
    // [566] vera_tile_area::tileindex#12 = tile_16_x_16_4BPP_16_color::tile#18 -- vwuz1=vwuz2 
    lda.z tile_2
    sta.z vera_tile_area.tileindex
    lda.z tile_2+1
    sta.z vera_tile_area.tileindex+1
    // [567] vera_tile_area::x#12 = tile_16_x_16_4BPP_16_color::column1#2 -- vbuz1=vbuz2 
    lda.z column1
    sta.z vera_tile_area.x
    // [568] vera_tile_area::y#12 = tile_16_x_16_4BPP_16_color::row#5 -- vbuz1=vbuz2 
    lda.z row
    sta.z vera_tile_area.y
    // [569] vera_tile_area::offset#13 = tile_16_x_16_4BPP_16_color::offset#2 -- vbuz1=vbuz2 
    lda.z offset
    sta.z vera_tile_area.offset
    // [570] call vera_tile_area
    // [1709] phi from tile_16_x_16_4BPP_16_color::@6 to vera_tile_area [phi:tile_16_x_16_4BPP_16_color::@6->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 1 [phi:tile_16_x_16_4BPP_16_color::@6->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 1 [phi:tile_16_x_16_4BPP_16_color::@6->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#12 [phi:tile_16_x_16_4BPP_16_color::@6->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = vera_tile_area::y#12 [phi:tile_16_x_16_4BPP_16_color::@6->vera_tile_area#3] -- register_copy 
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#12 [phi:tile_16_x_16_4BPP_16_color::@6->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = vera_tile_area::offset#13 [phi:tile_16_x_16_4BPP_16_color::@6->vera_tile_area#5] -- register_copy 
    jsr vera_tile_area
    // tile_16_x_16_4BPP_16_color::@23
    // column+=1
    // [571] tile_16_x_16_4BPP_16_color::column1#1 = tile_16_x_16_4BPP_16_color::column1#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z column1
    // tile++;
    // [572] tile_16_x_16_4BPP_16_color::tile#20 = ++ tile_16_x_16_4BPP_16_color::tile#18 -- vwuz1=_inc_vwuz1 
    inc.z tile_2
    bne !+
    inc.z tile_2+1
  !:
    // c & 0x0f
    // [573] tile_16_x_16_4BPP_16_color::$28 = tile_16_x_16_4BPP_16_color::c4#2 & $f -- vbuz1=vbuz2_band_vbuc1 
    lda #$f
    and.z c4
    sta.z __28
    // if((c & 0x0f) == 0x0f)
    // [574] if(tile_16_x_16_4BPP_16_color::$28!=$f) goto tile_16_x_16_4BPP_16_color::@7 -- vbuz1_neq_vbuc1_then_la1 
    lda #$f
    cmp.z __28
    bne __b7
    // tile_16_x_16_4BPP_16_color::@8
    // offset++;
    // [575] tile_16_x_16_4BPP_16_color::offset#1 = ++ tile_16_x_16_4BPP_16_color::offset#2 -- vbuz1=_inc_vbuz1 
    inc.z offset
    // [576] phi from tile_16_x_16_4BPP_16_color::@23 tile_16_x_16_4BPP_16_color::@8 to tile_16_x_16_4BPP_16_color::@7 [phi:tile_16_x_16_4BPP_16_color::@23/tile_16_x_16_4BPP_16_color::@8->tile_16_x_16_4BPP_16_color::@7]
    // [576] phi tile_16_x_16_4BPP_16_color::offset#4 = tile_16_x_16_4BPP_16_color::offset#2 [phi:tile_16_x_16_4BPP_16_color::@23/tile_16_x_16_4BPP_16_color::@8->tile_16_x_16_4BPP_16_color::@7#0] -- register_copy 
    // tile_16_x_16_4BPP_16_color::@7
  __b7:
    // tile &= 0x0f
    // [577] tile_16_x_16_4BPP_16_color::tile#25 = tile_16_x_16_4BPP_16_color::tile#20 & $f -- vwuz1=vwuz1_band_vbuc1 
    lda #$f
    and.z tile_2
    sta.z tile_2
    lda #0
    sta.z tile_2+1
    // for(byte c:0..31)
    // [578] tile_16_x_16_4BPP_16_color::c4#1 = ++ tile_16_x_16_4BPP_16_color::c4#2 -- vbuz1=_inc_vbuz1 
    inc.z c4
    // [579] if(tile_16_x_16_4BPP_16_color::c4#1!=$20) goto tile_16_x_16_4BPP_16_color::@6 -- vbuz1_neq_vbuc1_then_la1 
    lda #$20
    cmp.z c4
    bne __b6
    // tile_16_x_16_4BPP_16_color::@9
    // row += 1
    // [580] tile_16_x_16_4BPP_16_color::row#1 = tile_16_x_16_4BPP_16_color::row#5 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z row
    // for(byte r:0..7)
    // [581] tile_16_x_16_4BPP_16_color::r#1 = ++ tile_16_x_16_4BPP_16_color::r#7 -- vbuz1=_inc_vbuz1 
    inc.z r
    // [582] if(tile_16_x_16_4BPP_16_color::r#1!=8) goto tile_16_x_16_4BPP_16_color::@5 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z r
    bne __b5
    // tile_16_x_16_4BPP_16_color::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [583] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [584] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [585] phi from tile_16_x_16_4BPP_16_color::vera_layer_show1 to tile_16_x_16_4BPP_16_color::@12 [phi:tile_16_x_16_4BPP_16_color::vera_layer_show1->tile_16_x_16_4BPP_16_color::@12]
    // tile_16_x_16_4BPP_16_color::@12
    // gotoxy(0,50)
    // [586] call gotoxy
    // [242] phi from tile_16_x_16_4BPP_16_color::@12 to gotoxy [phi:tile_16_x_16_4BPP_16_color::@12->gotoxy]
    // [242] phi gotoxy::y#35 = $32 [phi:tile_16_x_16_4BPP_16_color::@12->gotoxy#0] -- vbuz1=vbuc1 
    lda #$32
    sta.z gotoxy.y
    jsr gotoxy
    // [587] phi from tile_16_x_16_4BPP_16_color::@12 to tile_16_x_16_4BPP_16_color::@24 [phi:tile_16_x_16_4BPP_16_color::@12->tile_16_x_16_4BPP_16_color::@24]
    // tile_16_x_16_4BPP_16_color::@24
    // printf("vera in tile mode 16 x 16, color depth 4 bits per pixel.\n")
    // [588] call printf_str
    // [318] phi from tile_16_x_16_4BPP_16_color::@24 to printf_str [phi:tile_16_x_16_4BPP_16_color::@24->printf_str]
    // [318] phi printf_str::s#124 = tile_16_x_16_4BPP_16_color::s [phi:tile_16_x_16_4BPP_16_color::@24->printf_str#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // [589] phi from tile_16_x_16_4BPP_16_color::@24 to tile_16_x_16_4BPP_16_color::@25 [phi:tile_16_x_16_4BPP_16_color::@24->tile_16_x_16_4BPP_16_color::@25]
    // tile_16_x_16_4BPP_16_color::@25
    // printf("in this mode, tiles are 16 pixels wide and 16 pixels tall.\n")
    // [590] call printf_str
    // [318] phi from tile_16_x_16_4BPP_16_color::@25 to printf_str [phi:tile_16_x_16_4BPP_16_color::@25->printf_str]
    // [318] phi printf_str::s#124 = tile_16_x_16_4BPP_16_color::s1 [phi:tile_16_x_16_4BPP_16_color::@25->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [591] phi from tile_16_x_16_4BPP_16_color::@25 to tile_16_x_16_4BPP_16_color::@26 [phi:tile_16_x_16_4BPP_16_color::@25->tile_16_x_16_4BPP_16_color::@26]
    // tile_16_x_16_4BPP_16_color::@26
    // printf("each tile can have a variation of 16 colors.\n")
    // [592] call printf_str
    // [318] phi from tile_16_x_16_4BPP_16_color::@26 to printf_str [phi:tile_16_x_16_4BPP_16_color::@26->printf_str]
    // [318] phi printf_str::s#124 = string_0 [phi:tile_16_x_16_4BPP_16_color::@26->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_0
    sta.z printf_str.s
    lda #>string_0
    sta.z printf_str.s+1
    jsr printf_str
    // [593] phi from tile_16_x_16_4BPP_16_color::@26 to tile_16_x_16_4BPP_16_color::@27 [phi:tile_16_x_16_4BPP_16_color::@26->tile_16_x_16_4BPP_16_color::@27]
    // tile_16_x_16_4BPP_16_color::@27
    // printf("the vera palette of 256 colors, can be used by setting the palette\n")
    // [594] call printf_str
    // [318] phi from tile_16_x_16_4BPP_16_color::@27 to printf_str [phi:tile_16_x_16_4BPP_16_color::@27->printf_str]
    // [318] phi printf_str::s#124 = s3 [phi:tile_16_x_16_4BPP_16_color::@27->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // [595] phi from tile_16_x_16_4BPP_16_color::@27 to tile_16_x_16_4BPP_16_color::@28 [phi:tile_16_x_16_4BPP_16_color::@27->tile_16_x_16_4BPP_16_color::@28]
    // tile_16_x_16_4BPP_16_color::@28
    // printf("offset for each tile.\n")
    // [596] call printf_str
    // [318] phi from tile_16_x_16_4BPP_16_color::@28 to printf_str [phi:tile_16_x_16_4BPP_16_color::@28->printf_str]
    // [318] phi printf_str::s#124 = s4 [phi:tile_16_x_16_4BPP_16_color::@28->printf_str#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // [597] phi from tile_16_x_16_4BPP_16_color::@28 to tile_16_x_16_4BPP_16_color::@29 [phi:tile_16_x_16_4BPP_16_color::@28->tile_16_x_16_4BPP_16_color::@29]
    // tile_16_x_16_4BPP_16_color::@29
    // printf("here each column is displaying the same tile, but with different offsets!\n")
    // [598] call printf_str
    // [318] phi from tile_16_x_16_4BPP_16_color::@29 to printf_str [phi:tile_16_x_16_4BPP_16_color::@29->printf_str]
    // [318] phi printf_str::s#124 = s5 [phi:tile_16_x_16_4BPP_16_color::@29->printf_str#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // [599] phi from tile_16_x_16_4BPP_16_color::@29 to tile_16_x_16_4BPP_16_color::@30 [phi:tile_16_x_16_4BPP_16_color::@29->tile_16_x_16_4BPP_16_color::@30]
    // tile_16_x_16_4BPP_16_color::@30
    // printf("each offset aligns to multiples of 16 colors in the palette!.\n")
    // [600] call printf_str
    // [318] phi from tile_16_x_16_4BPP_16_color::@30 to printf_str [phi:tile_16_x_16_4BPP_16_color::@30->printf_str]
    // [318] phi printf_str::s#124 = s6 [phi:tile_16_x_16_4BPP_16_color::@30->printf_str#0] -- pbuz1=pbuc1 
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    jsr printf_str
    // [601] phi from tile_16_x_16_4BPP_16_color::@30 to tile_16_x_16_4BPP_16_color::@31 [phi:tile_16_x_16_4BPP_16_color::@30->tile_16_x_16_4BPP_16_color::@31]
    // tile_16_x_16_4BPP_16_color::@31
    // printf("however, the first color will always be transparent (black).\n")
    // [602] call printf_str
    // [318] phi from tile_16_x_16_4BPP_16_color::@31 to printf_str [phi:tile_16_x_16_4BPP_16_color::@31->printf_str]
    // [318] phi printf_str::s#124 = s7 [phi:tile_16_x_16_4BPP_16_color::@31->printf_str#0] -- pbuz1=pbuc1 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // [603] phi from tile_16_x_16_4BPP_16_color::@31 tile_16_x_16_4BPP_16_color::@32 to tile_16_x_16_4BPP_16_color::@10 [phi:tile_16_x_16_4BPP_16_color::@31/tile_16_x_16_4BPP_16_color::@32->tile_16_x_16_4BPP_16_color::@10]
    // tile_16_x_16_4BPP_16_color::@10
  __b10:
    // getin()
    // [604] call getin
    jsr getin
    // [605] getin::return#29 = getin::return#1
    // tile_16_x_16_4BPP_16_color::@32
    // [606] tile_16_x_16_4BPP_16_color::$33 = getin::return#29
    // while(!getin())
    // [607] if(0==tile_16_x_16_4BPP_16_color::$33) goto tile_16_x_16_4BPP_16_color::@10 -- 0_eq_vbuz1_then_la1 
    lda.z __33
    beq __b10
    // tile_16_x_16_4BPP_16_color::@return
    // }
    // [608] return 
    rts
  .segment Data
    tiles: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    s: .text @"vera in tile mode 16 x 16, color depth 4 bits per pixel.\n"
    .byte 0
    s1: .text @"in this mode, tiles are 16 pixels wide and 16 pixels tall.\n"
    .byte 0
}
.segment Code
  // tile_8_x_8_4BPP_16_color
tile_8_x_8_4BPP_16_color: {
    .label __28 = $16
    .label __33 = $66
    .label column = $17
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label tile = $b8
    .label c = $c5
    .label column_1 = $ce
    .label c1 = $c3
    .label column_2 = $db
    .label c2 = $c4
    .label column_3 = $c1
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label tile_1 = $5d
    .label c3 = $6d
    .label column1 = $63
    .label c4 = $3c
    .label offset = $2b
    .label row = $c2
    .label r = $c0
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label tile_2 = $3e
    // vera_layer_mode_tile(0, 0x04000, 0x14000, 128, 128, 8, 8, 4)
    // [610] call vera_layer_mode_tile
    // [1580] phi from tile_8_x_8_4BPP_16_color to vera_layer_mode_tile [phi:tile_8_x_8_4BPP_16_color->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = 8 [phi:tile_8_x_8_4BPP_16_color->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = 8 [phi:tile_8_x_8_4BPP_16_color->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $14000 [phi:tile_8_x_8_4BPP_16_color->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $4000 [phi:tile_8_x_8_4BPP_16_color->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$4000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$4000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$4000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$4000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $80 [phi:tile_8_x_8_4BPP_16_color->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapheight
    lda #>$80
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 0 [phi:tile_8_x_8_4BPP_16_color->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $80 [phi:tile_8_x_8_4BPP_16_color->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 4 [phi:tile_8_x_8_4BPP_16_color->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // tile_8_x_8_4BPP_16_color::vera_display_set_scale_none1
    // *VERA_DC_HSCALE = 128
    // [611] *VERA_DC_HSCALE = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 128
    // [612] *VERA_DC_VSCALE = $80 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // [613] phi from tile_8_x_8_4BPP_16_color::vera_display_set_scale_none1 to tile_8_x_8_4BPP_16_color::@11 [phi:tile_8_x_8_4BPP_16_color::vera_display_set_scale_none1->tile_8_x_8_4BPP_16_color::@11]
    // tile_8_x_8_4BPP_16_color::@11
    // vera_layer_mode_text( 1, 0x00000, 0x0F800, 128, 128, 8, 8, 256 )
    // [614] call vera_layer_mode_text
    // [185] phi from tile_8_x_8_4BPP_16_color::@11 to vera_layer_mode_text [phi:tile_8_x_8_4BPP_16_color::@11->vera_layer_mode_text]
    // [185] phi vera_layer_mode_text::color_mode#11 = $100 [phi:tile_8_x_8_4BPP_16_color::@11->vera_layer_mode_text#0] -- vwuz1=vwuc1 
    lda #<$100
    sta.z vera_layer_mode_text.color_mode
    lda #>$100
    sta.z vera_layer_mode_text.color_mode+1
    // [185] phi vera_layer_mode_text::mapheight#11 = $80 [phi:tile_8_x_8_4BPP_16_color::@11->vera_layer_mode_text#1] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapheight
    lda #>$80
    sta.z vera_layer_mode_text.mapheight+1
    // [185] phi vera_layer_mode_text::mapwidth#11 = $80 [phi:tile_8_x_8_4BPP_16_color::@11->vera_layer_mode_text#2] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapwidth
    lda #>$80
    sta.z vera_layer_mode_text.mapwidth+1
    jsr vera_layer_mode_text
    // [615] phi from tile_8_x_8_4BPP_16_color::@11 to tile_8_x_8_4BPP_16_color::@13 [phi:tile_8_x_8_4BPP_16_color::@11->tile_8_x_8_4BPP_16_color::@13]
    // tile_8_x_8_4BPP_16_color::@13
    // screenlayer(1)
    // [616] call screenlayer
    jsr screenlayer
    // [617] phi from tile_8_x_8_4BPP_16_color::@13 to tile_8_x_8_4BPP_16_color::@14 [phi:tile_8_x_8_4BPP_16_color::@13->tile_8_x_8_4BPP_16_color::@14]
    // tile_8_x_8_4BPP_16_color::@14
    // textcolor(WHITE)
    // [618] call textcolor
    // [274] phi from tile_8_x_8_4BPP_16_color::@14 to textcolor [phi:tile_8_x_8_4BPP_16_color::@14->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:tile_8_x_8_4BPP_16_color::@14->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [619] phi from tile_8_x_8_4BPP_16_color::@14 to tile_8_x_8_4BPP_16_color::@15 [phi:tile_8_x_8_4BPP_16_color::@14->tile_8_x_8_4BPP_16_color::@15]
    // tile_8_x_8_4BPP_16_color::@15
    // bgcolor(BLACK)
    // [620] call bgcolor
    // [279] phi from tile_8_x_8_4BPP_16_color::@15 to bgcolor [phi:tile_8_x_8_4BPP_16_color::@15->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:tile_8_x_8_4BPP_16_color::@15->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [621] phi from tile_8_x_8_4BPP_16_color::@15 to tile_8_x_8_4BPP_16_color::@16 [phi:tile_8_x_8_4BPP_16_color::@15->tile_8_x_8_4BPP_16_color::@16]
    // tile_8_x_8_4BPP_16_color::@16
    // clrscr()
    // [622] call clrscr
    jsr clrscr
    // [623] phi from tile_8_x_8_4BPP_16_color::@16 to tile_8_x_8_4BPP_16_color::@17 [phi:tile_8_x_8_4BPP_16_color::@16->tile_8_x_8_4BPP_16_color::@17]
    // tile_8_x_8_4BPP_16_color::@17
    // cx16_cpy_vram_from_ram(1, 0x4000, tiles, 512)
    // [624] call cx16_cpy_vram_from_ram
    // [1694] phi from tile_8_x_8_4BPP_16_color::@17 to cx16_cpy_vram_from_ram [phi:tile_8_x_8_4BPP_16_color::@17->cx16_cpy_vram_from_ram]
    // [1694] phi cx16_cpy_vram_from_ram::num#10 = $200 [phi:tile_8_x_8_4BPP_16_color::@17->cx16_cpy_vram_from_ram#0] -- vwuz1=vwuc1 
    lda #<$200
    sta.z cx16_cpy_vram_from_ram.num
    lda #>$200
    sta.z cx16_cpy_vram_from_ram.num+1
    // [1694] phi cx16_cpy_vram_from_ram::sptr_ram#10 = (void *)tile_8_x_8_4BPP_16_color::tiles [phi:tile_8_x_8_4BPP_16_color::@17->cx16_cpy_vram_from_ram#1] -- pvoz1=pvoc1 
    lda #<tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram
    lda #>tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_offset#0 = $4000 [phi:tile_8_x_8_4BPP_16_color::@17->cx16_cpy_vram_from_ram#2] -- vwuz1=vwuc1 
    lda #<$4000
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_offset
    lda #>$4000
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_offset+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:tile_8_x_8_4BPP_16_color::@17->cx16_cpy_vram_from_ram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_ram
    // [625] phi from tile_8_x_8_4BPP_16_color::@17 to tile_8_x_8_4BPP_16_color::@18 [phi:tile_8_x_8_4BPP_16_color::@17->tile_8_x_8_4BPP_16_color::@18]
    // tile_8_x_8_4BPP_16_color::@18
    // vera_tile_area(0, 0, 0, 0, 80, 60, 0, 0, 0)
    // [626] call vera_tile_area
    // [1709] phi from tile_8_x_8_4BPP_16_color::@18 to vera_tile_area [phi:tile_8_x_8_4BPP_16_color::@18->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = $50 [phi:tile_8_x_8_4BPP_16_color::@18->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$50
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = $3c [phi:tile_8_x_8_4BPP_16_color::@18->vera_tile_area#1] -- vbuz1=vbuc1 
    lda #$3c
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = 0 [phi:tile_8_x_8_4BPP_16_color::@18->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 0 [phi:tile_8_x_8_4BPP_16_color::@18->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 0 [phi:tile_8_x_8_4BPP_16_color::@18->vera_tile_area#4] -- vwuz1=vbuc1 
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_4BPP_16_color::@18->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [627] phi from tile_8_x_8_4BPP_16_color::@18 to tile_8_x_8_4BPP_16_color::@1 [phi:tile_8_x_8_4BPP_16_color::@18->tile_8_x_8_4BPP_16_color::@1]
    // [627] phi tile_8_x_8_4BPP_16_color::c#2 = 0 [phi:tile_8_x_8_4BPP_16_color::@18->tile_8_x_8_4BPP_16_color::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // [627] phi tile_8_x_8_4BPP_16_color::column#8 = 1 [phi:tile_8_x_8_4BPP_16_color::@18->tile_8_x_8_4BPP_16_color::@1#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column
    // [627] phi tile_8_x_8_4BPP_16_color::tile#10 = 0 [phi:tile_8_x_8_4BPP_16_color::@18->tile_8_x_8_4BPP_16_color::@1#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z tile
    sta.z tile+1
    // [627] phi from tile_8_x_8_4BPP_16_color::@19 to tile_8_x_8_4BPP_16_color::@1 [phi:tile_8_x_8_4BPP_16_color::@19->tile_8_x_8_4BPP_16_color::@1]
    // [627] phi tile_8_x_8_4BPP_16_color::c#2 = tile_8_x_8_4BPP_16_color::c#1 [phi:tile_8_x_8_4BPP_16_color::@19->tile_8_x_8_4BPP_16_color::@1#0] -- register_copy 
    // [627] phi tile_8_x_8_4BPP_16_color::column#8 = tile_8_x_8_4BPP_16_color::column#1 [phi:tile_8_x_8_4BPP_16_color::@19->tile_8_x_8_4BPP_16_color::@1#1] -- register_copy 
    // [627] phi tile_8_x_8_4BPP_16_color::tile#10 = tile_8_x_8_4BPP_16_color::tile#2 [phi:tile_8_x_8_4BPP_16_color::@19->tile_8_x_8_4BPP_16_color::@1#2] -- register_copy 
    // tile_8_x_8_4BPP_16_color::@1
  __b1:
    // vera_tile_area(0, tile, column, 1, 1, 1, 0, 0, 0)
    // [628] vera_tile_area::tileindex#14 = tile_8_x_8_4BPP_16_color::tile#10 -- vwuz1=vwuz2 
    lda.z tile
    sta.z vera_tile_area.tileindex
    lda.z tile+1
    sta.z vera_tile_area.tileindex+1
    // [629] vera_tile_area::x#14 = tile_8_x_8_4BPP_16_color::column#8 -- vbuz1=vbuz2 
    lda.z column
    sta.z vera_tile_area.x
    // [630] call vera_tile_area
    // [1709] phi from tile_8_x_8_4BPP_16_color::@1 to vera_tile_area [phi:tile_8_x_8_4BPP_16_color::@1->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 1 [phi:tile_8_x_8_4BPP_16_color::@1->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 1 [phi:tile_8_x_8_4BPP_16_color::@1->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#14 [phi:tile_8_x_8_4BPP_16_color::@1->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = 1 [phi:tile_8_x_8_4BPP_16_color::@1->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#14 [phi:tile_8_x_8_4BPP_16_color::@1->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_4BPP_16_color::@1->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // tile_8_x_8_4BPP_16_color::@19
    // column+=8
    // [631] tile_8_x_8_4BPP_16_color::column#1 = tile_8_x_8_4BPP_16_color::column#8 + 8 -- vbuz1=vbuz1_plus_vbuc1 
    lda #8
    clc
    adc.z column
    sta.z column
    // tile++;
    // [632] tile_8_x_8_4BPP_16_color::tile#2 = ++ tile_8_x_8_4BPP_16_color::tile#10 -- vwuz1=_inc_vwuz1 
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // for(byte c:0..7)
    // [633] tile_8_x_8_4BPP_16_color::c#1 = ++ tile_8_x_8_4BPP_16_color::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [634] if(tile_8_x_8_4BPP_16_color::c#1!=8) goto tile_8_x_8_4BPP_16_color::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z c
    bne __b1
    // [635] phi from tile_8_x_8_4BPP_16_color::@19 to tile_8_x_8_4BPP_16_color::@2 [phi:tile_8_x_8_4BPP_16_color::@19->tile_8_x_8_4BPP_16_color::@2]
    // [635] phi tile_8_x_8_4BPP_16_color::c1#2 = 0 [phi:tile_8_x_8_4BPP_16_color::@19->tile_8_x_8_4BPP_16_color::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c1
    // [635] phi tile_8_x_8_4BPP_16_color::column#10 = 1 [phi:tile_8_x_8_4BPP_16_color::@19->tile_8_x_8_4BPP_16_color::@2#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column_1
    // [635] phi tile_8_x_8_4BPP_16_color::tile#12 = tile_8_x_8_4BPP_16_color::tile#2 [phi:tile_8_x_8_4BPP_16_color::@19->tile_8_x_8_4BPP_16_color::@2#2] -- register_copy 
    // [635] phi from tile_8_x_8_4BPP_16_color::@20 to tile_8_x_8_4BPP_16_color::@2 [phi:tile_8_x_8_4BPP_16_color::@20->tile_8_x_8_4BPP_16_color::@2]
    // [635] phi tile_8_x_8_4BPP_16_color::c1#2 = tile_8_x_8_4BPP_16_color::c1#1 [phi:tile_8_x_8_4BPP_16_color::@20->tile_8_x_8_4BPP_16_color::@2#0] -- register_copy 
    // [635] phi tile_8_x_8_4BPP_16_color::column#10 = tile_8_x_8_4BPP_16_color::column#3 [phi:tile_8_x_8_4BPP_16_color::@20->tile_8_x_8_4BPP_16_color::@2#1] -- register_copy 
    // [635] phi tile_8_x_8_4BPP_16_color::tile#12 = tile_8_x_8_4BPP_16_color::tile#3 [phi:tile_8_x_8_4BPP_16_color::@20->tile_8_x_8_4BPP_16_color::@2#2] -- register_copy 
    // tile_8_x_8_4BPP_16_color::@2
  __b2:
    // vera_tile_area(0, tile, column, 3, 1, 1, 0, 0, 0)
    // [636] vera_tile_area::tileindex#15 = tile_8_x_8_4BPP_16_color::tile#12 -- vwuz1=vwuz2 
    lda.z tile
    sta.z vera_tile_area.tileindex
    lda.z tile+1
    sta.z vera_tile_area.tileindex+1
    // [637] vera_tile_area::x#15 = tile_8_x_8_4BPP_16_color::column#10 -- vbuz1=vbuz2 
    lda.z column_1
    sta.z vera_tile_area.x
    // [638] call vera_tile_area
    // [1709] phi from tile_8_x_8_4BPP_16_color::@2 to vera_tile_area [phi:tile_8_x_8_4BPP_16_color::@2->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 1 [phi:tile_8_x_8_4BPP_16_color::@2->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 1 [phi:tile_8_x_8_4BPP_16_color::@2->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#15 [phi:tile_8_x_8_4BPP_16_color::@2->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = 3 [phi:tile_8_x_8_4BPP_16_color::@2->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #3
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#15 [phi:tile_8_x_8_4BPP_16_color::@2->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_4BPP_16_color::@2->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // tile_8_x_8_4BPP_16_color::@20
    // column+=8
    // [639] tile_8_x_8_4BPP_16_color::column#3 = tile_8_x_8_4BPP_16_color::column#10 + 8 -- vbuz1=vbuz1_plus_vbuc1 
    lda #8
    clc
    adc.z column_1
    sta.z column_1
    // tile++;
    // [640] tile_8_x_8_4BPP_16_color::tile#3 = ++ tile_8_x_8_4BPP_16_color::tile#12 -- vwuz1=_inc_vwuz1 
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // for(byte c:0..7)
    // [641] tile_8_x_8_4BPP_16_color::c1#1 = ++ tile_8_x_8_4BPP_16_color::c1#2 -- vbuz1=_inc_vbuz1 
    inc.z c1
    // [642] if(tile_8_x_8_4BPP_16_color::c1#1!=8) goto tile_8_x_8_4BPP_16_color::@2 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z c1
    bne __b2
    // [643] phi from tile_8_x_8_4BPP_16_color::@20 to tile_8_x_8_4BPP_16_color::@3 [phi:tile_8_x_8_4BPP_16_color::@20->tile_8_x_8_4BPP_16_color::@3]
    // [643] phi tile_8_x_8_4BPP_16_color::c2#2 = 0 [phi:tile_8_x_8_4BPP_16_color::@20->tile_8_x_8_4BPP_16_color::@3#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c2
    // [643] phi tile_8_x_8_4BPP_16_color::column#12 = 1 [phi:tile_8_x_8_4BPP_16_color::@20->tile_8_x_8_4BPP_16_color::@3#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column_2
    // [643] phi tile_8_x_8_4BPP_16_color::tile#14 = 0 [phi:tile_8_x_8_4BPP_16_color::@20->tile_8_x_8_4BPP_16_color::@3#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z tile_1
    sta.z tile_1+1
    // [643] phi from tile_8_x_8_4BPP_16_color::@21 to tile_8_x_8_4BPP_16_color::@3 [phi:tile_8_x_8_4BPP_16_color::@21->tile_8_x_8_4BPP_16_color::@3]
    // [643] phi tile_8_x_8_4BPP_16_color::c2#2 = tile_8_x_8_4BPP_16_color::c2#1 [phi:tile_8_x_8_4BPP_16_color::@21->tile_8_x_8_4BPP_16_color::@3#0] -- register_copy 
    // [643] phi tile_8_x_8_4BPP_16_color::column#12 = tile_8_x_8_4BPP_16_color::column#5 [phi:tile_8_x_8_4BPP_16_color::@21->tile_8_x_8_4BPP_16_color::@3#1] -- register_copy 
    // [643] phi tile_8_x_8_4BPP_16_color::tile#14 = tile_8_x_8_4BPP_16_color::tile#22 [phi:tile_8_x_8_4BPP_16_color::@21->tile_8_x_8_4BPP_16_color::@3#2] -- register_copy 
    // tile_8_x_8_4BPP_16_color::@3
  __b3:
    // vera_tile_area(0, tile, column, 5, 6, 6, 0, 0, 0)
    // [644] vera_tile_area::tileindex#16 = tile_8_x_8_4BPP_16_color::tile#14 -- vwuz1=vwuz2 
    lda.z tile_1
    sta.z vera_tile_area.tileindex
    lda.z tile_1+1
    sta.z vera_tile_area.tileindex+1
    // [645] vera_tile_area::x#16 = tile_8_x_8_4BPP_16_color::column#12 -- vbuz1=vbuz2 
    lda.z column_2
    sta.z vera_tile_area.x
    // [646] call vera_tile_area
    // [1709] phi from tile_8_x_8_4BPP_16_color::@3 to vera_tile_area [phi:tile_8_x_8_4BPP_16_color::@3->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 6 [phi:tile_8_x_8_4BPP_16_color::@3->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #6
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 6 [phi:tile_8_x_8_4BPP_16_color::@3->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#16 [phi:tile_8_x_8_4BPP_16_color::@3->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = 5 [phi:tile_8_x_8_4BPP_16_color::@3->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #5
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#16 [phi:tile_8_x_8_4BPP_16_color::@3->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_4BPP_16_color::@3->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // tile_8_x_8_4BPP_16_color::@21
    // column+=8
    // [647] tile_8_x_8_4BPP_16_color::column#5 = tile_8_x_8_4BPP_16_color::column#12 + 8 -- vbuz1=vbuz1_plus_vbuc1 
    lda #8
    clc
    adc.z column_2
    sta.z column_2
    // tile++;
    // [648] tile_8_x_8_4BPP_16_color::tile#22 = ++ tile_8_x_8_4BPP_16_color::tile#14 -- vwuz1=_inc_vwuz1 
    inc.z tile_1
    bne !+
    inc.z tile_1+1
  !:
    // for(byte c:0..7)
    // [649] tile_8_x_8_4BPP_16_color::c2#1 = ++ tile_8_x_8_4BPP_16_color::c2#2 -- vbuz1=_inc_vbuz1 
    inc.z c2
    // [650] if(tile_8_x_8_4BPP_16_color::c2#1!=8) goto tile_8_x_8_4BPP_16_color::@3 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z c2
    bne __b3
    // [651] phi from tile_8_x_8_4BPP_16_color::@21 to tile_8_x_8_4BPP_16_color::@4 [phi:tile_8_x_8_4BPP_16_color::@21->tile_8_x_8_4BPP_16_color::@4]
    // [651] phi tile_8_x_8_4BPP_16_color::c3#2 = 0 [phi:tile_8_x_8_4BPP_16_color::@21->tile_8_x_8_4BPP_16_color::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c3
    // [651] phi tile_8_x_8_4BPP_16_color::column#14 = 1 [phi:tile_8_x_8_4BPP_16_color::@21->tile_8_x_8_4BPP_16_color::@4#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column_3
    // [651] phi tile_8_x_8_4BPP_16_color::tile#16 = tile_8_x_8_4BPP_16_color::tile#22 [phi:tile_8_x_8_4BPP_16_color::@21->tile_8_x_8_4BPP_16_color::@4#2] -- register_copy 
    // [651] phi from tile_8_x_8_4BPP_16_color::@22 to tile_8_x_8_4BPP_16_color::@4 [phi:tile_8_x_8_4BPP_16_color::@22->tile_8_x_8_4BPP_16_color::@4]
    // [651] phi tile_8_x_8_4BPP_16_color::c3#2 = tile_8_x_8_4BPP_16_color::c3#1 [phi:tile_8_x_8_4BPP_16_color::@22->tile_8_x_8_4BPP_16_color::@4#0] -- register_copy 
    // [651] phi tile_8_x_8_4BPP_16_color::column#14 = tile_8_x_8_4BPP_16_color::column#7 [phi:tile_8_x_8_4BPP_16_color::@22->tile_8_x_8_4BPP_16_color::@4#1] -- register_copy 
    // [651] phi tile_8_x_8_4BPP_16_color::tile#16 = tile_8_x_8_4BPP_16_color::tile#6 [phi:tile_8_x_8_4BPP_16_color::@22->tile_8_x_8_4BPP_16_color::@4#2] -- register_copy 
    // tile_8_x_8_4BPP_16_color::@4
  __b4:
    // vera_tile_area(0, tile, column, 12, 6, 6, 0, 0, 0)
    // [652] vera_tile_area::tileindex#17 = tile_8_x_8_4BPP_16_color::tile#16 -- vwuz1=vwuz2 
    lda.z tile_1
    sta.z vera_tile_area.tileindex
    lda.z tile_1+1
    sta.z vera_tile_area.tileindex+1
    // [653] vera_tile_area::x#17 = tile_8_x_8_4BPP_16_color::column#14 -- vbuz1=vbuz2 
    lda.z column_3
    sta.z vera_tile_area.x
    // [654] call vera_tile_area
    // [1709] phi from tile_8_x_8_4BPP_16_color::@4 to vera_tile_area [phi:tile_8_x_8_4BPP_16_color::@4->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 6 [phi:tile_8_x_8_4BPP_16_color::@4->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #6
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 6 [phi:tile_8_x_8_4BPP_16_color::@4->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#17 [phi:tile_8_x_8_4BPP_16_color::@4->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = $c [phi:tile_8_x_8_4BPP_16_color::@4->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #$c
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#17 [phi:tile_8_x_8_4BPP_16_color::@4->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_4BPP_16_color::@4->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // tile_8_x_8_4BPP_16_color::@22
    // column+=8
    // [655] tile_8_x_8_4BPP_16_color::column#7 = tile_8_x_8_4BPP_16_color::column#14 + 8 -- vbuz1=vbuz1_plus_vbuc1 
    lda #8
    clc
    adc.z column_3
    sta.z column_3
    // tile++;
    // [656] tile_8_x_8_4BPP_16_color::tile#6 = ++ tile_8_x_8_4BPP_16_color::tile#16 -- vwuz1=_inc_vwuz1 
    inc.z tile_1
    bne !+
    inc.z tile_1+1
  !:
    // for(byte c:0..7)
    // [657] tile_8_x_8_4BPP_16_color::c3#1 = ++ tile_8_x_8_4BPP_16_color::c3#2 -- vbuz1=_inc_vbuz1 
    inc.z c3
    // [658] if(tile_8_x_8_4BPP_16_color::c3#1!=8) goto tile_8_x_8_4BPP_16_color::@4 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z c3
    bne __b4
    // [659] phi from tile_8_x_8_4BPP_16_color::@22 to tile_8_x_8_4BPP_16_color::@5 [phi:tile_8_x_8_4BPP_16_color::@22->tile_8_x_8_4BPP_16_color::@5]
    // [659] phi tile_8_x_8_4BPP_16_color::r#7 = 0 [phi:tile_8_x_8_4BPP_16_color::@22->tile_8_x_8_4BPP_16_color::@5#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // [659] phi tile_8_x_8_4BPP_16_color::offset#5 = 0 [phi:tile_8_x_8_4BPP_16_color::@22->tile_8_x_8_4BPP_16_color::@5#1] -- vbuz1=vbuc1 
    sta.z offset
    // [659] phi tile_8_x_8_4BPP_16_color::row#5 = $14 [phi:tile_8_x_8_4BPP_16_color::@22->tile_8_x_8_4BPP_16_color::@5#2] -- vbuz1=vbuc1 
    lda #$14
    sta.z row
    // [659] phi tile_8_x_8_4BPP_16_color::tile#23 = 0 [phi:tile_8_x_8_4BPP_16_color::@22->tile_8_x_8_4BPP_16_color::@5#3] -- vwuz1=vbuc1 
    lda #<0
    sta.z tile_2
    sta.z tile_2+1
    // [659] phi from tile_8_x_8_4BPP_16_color::@9 to tile_8_x_8_4BPP_16_color::@5 [phi:tile_8_x_8_4BPP_16_color::@9->tile_8_x_8_4BPP_16_color::@5]
    // [659] phi tile_8_x_8_4BPP_16_color::r#7 = tile_8_x_8_4BPP_16_color::r#1 [phi:tile_8_x_8_4BPP_16_color::@9->tile_8_x_8_4BPP_16_color::@5#0] -- register_copy 
    // [659] phi tile_8_x_8_4BPP_16_color::offset#5 = tile_8_x_8_4BPP_16_color::offset#4 [phi:tile_8_x_8_4BPP_16_color::@9->tile_8_x_8_4BPP_16_color::@5#1] -- register_copy 
    // [659] phi tile_8_x_8_4BPP_16_color::row#5 = tile_8_x_8_4BPP_16_color::row#1 [phi:tile_8_x_8_4BPP_16_color::@9->tile_8_x_8_4BPP_16_color::@5#2] -- register_copy 
    // [659] phi tile_8_x_8_4BPP_16_color::tile#23 = tile_8_x_8_4BPP_16_color::tile#25 [phi:tile_8_x_8_4BPP_16_color::@9->tile_8_x_8_4BPP_16_color::@5#3] -- register_copy 
    // tile_8_x_8_4BPP_16_color::@5
  __b5:
    // [660] phi from tile_8_x_8_4BPP_16_color::@5 to tile_8_x_8_4BPP_16_color::@6 [phi:tile_8_x_8_4BPP_16_color::@5->tile_8_x_8_4BPP_16_color::@6]
    // [660] phi tile_8_x_8_4BPP_16_color::c4#2 = 0 [phi:tile_8_x_8_4BPP_16_color::@5->tile_8_x_8_4BPP_16_color::@6#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c4
    // [660] phi tile_8_x_8_4BPP_16_color::offset#2 = tile_8_x_8_4BPP_16_color::offset#5 [phi:tile_8_x_8_4BPP_16_color::@5->tile_8_x_8_4BPP_16_color::@6#1] -- register_copy 
    // [660] phi tile_8_x_8_4BPP_16_color::column1#2 = 1 [phi:tile_8_x_8_4BPP_16_color::@5->tile_8_x_8_4BPP_16_color::@6#2] -- vbuz1=vbuc1 
    lda #1
    sta.z column1
    // [660] phi tile_8_x_8_4BPP_16_color::tile#18 = tile_8_x_8_4BPP_16_color::tile#23 [phi:tile_8_x_8_4BPP_16_color::@5->tile_8_x_8_4BPP_16_color::@6#3] -- register_copy 
    // [660] phi from tile_8_x_8_4BPP_16_color::@7 to tile_8_x_8_4BPP_16_color::@6 [phi:tile_8_x_8_4BPP_16_color::@7->tile_8_x_8_4BPP_16_color::@6]
    // [660] phi tile_8_x_8_4BPP_16_color::c4#2 = tile_8_x_8_4BPP_16_color::c4#1 [phi:tile_8_x_8_4BPP_16_color::@7->tile_8_x_8_4BPP_16_color::@6#0] -- register_copy 
    // [660] phi tile_8_x_8_4BPP_16_color::offset#2 = tile_8_x_8_4BPP_16_color::offset#4 [phi:tile_8_x_8_4BPP_16_color::@7->tile_8_x_8_4BPP_16_color::@6#1] -- register_copy 
    // [660] phi tile_8_x_8_4BPP_16_color::column1#2 = tile_8_x_8_4BPP_16_color::column1#1 [phi:tile_8_x_8_4BPP_16_color::@7->tile_8_x_8_4BPP_16_color::@6#2] -- register_copy 
    // [660] phi tile_8_x_8_4BPP_16_color::tile#18 = tile_8_x_8_4BPP_16_color::tile#25 [phi:tile_8_x_8_4BPP_16_color::@7->tile_8_x_8_4BPP_16_color::@6#3] -- register_copy 
    // tile_8_x_8_4BPP_16_color::@6
  __b6:
    // vera_tile_area(0, tile, column, row, 2, 2, 0, 0, offset)
    // [661] vera_tile_area::tileindex#18 = tile_8_x_8_4BPP_16_color::tile#18 -- vwuz1=vwuz2 
    lda.z tile_2
    sta.z vera_tile_area.tileindex
    lda.z tile_2+1
    sta.z vera_tile_area.tileindex+1
    // [662] vera_tile_area::x#18 = tile_8_x_8_4BPP_16_color::column1#2 -- vbuz1=vbuz2 
    lda.z column1
    sta.z vera_tile_area.x
    // [663] vera_tile_area::y#18 = tile_8_x_8_4BPP_16_color::row#5 -- vbuz1=vbuz2 
    lda.z row
    sta.z vera_tile_area.y
    // [664] vera_tile_area::offset#19 = tile_8_x_8_4BPP_16_color::offset#2 -- vbuz1=vbuz2 
    lda.z offset
    sta.z vera_tile_area.offset
    // [665] call vera_tile_area
    // [1709] phi from tile_8_x_8_4BPP_16_color::@6 to vera_tile_area [phi:tile_8_x_8_4BPP_16_color::@6->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 2 [phi:tile_8_x_8_4BPP_16_color::@6->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #2
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 2 [phi:tile_8_x_8_4BPP_16_color::@6->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#18 [phi:tile_8_x_8_4BPP_16_color::@6->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = vera_tile_area::y#18 [phi:tile_8_x_8_4BPP_16_color::@6->vera_tile_area#3] -- register_copy 
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#18 [phi:tile_8_x_8_4BPP_16_color::@6->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = vera_tile_area::offset#19 [phi:tile_8_x_8_4BPP_16_color::@6->vera_tile_area#5] -- register_copy 
    jsr vera_tile_area
    // tile_8_x_8_4BPP_16_color::@23
    // column+=2
    // [666] tile_8_x_8_4BPP_16_color::column1#1 = tile_8_x_8_4BPP_16_color::column1#2 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z column1
    clc
    adc #2
    sta.z column1
    // tile++;
    // [667] tile_8_x_8_4BPP_16_color::tile#20 = ++ tile_8_x_8_4BPP_16_color::tile#18 -- vwuz1=_inc_vwuz1 
    inc.z tile_2
    bne !+
    inc.z tile_2+1
  !:
    // c & 0x0f
    // [668] tile_8_x_8_4BPP_16_color::$28 = tile_8_x_8_4BPP_16_color::c4#2 & $f -- vbuz1=vbuz2_band_vbuc1 
    lda #$f
    and.z c4
    sta.z __28
    // if((c & 0x0f) == 0x0f)
    // [669] if(tile_8_x_8_4BPP_16_color::$28!=$f) goto tile_8_x_8_4BPP_16_color::@7 -- vbuz1_neq_vbuc1_then_la1 
    lda #$f
    cmp.z __28
    bne __b7
    // tile_8_x_8_4BPP_16_color::@8
    // offset++;
    // [670] tile_8_x_8_4BPP_16_color::offset#1 = ++ tile_8_x_8_4BPP_16_color::offset#2 -- vbuz1=_inc_vbuz1 
    inc.z offset
    // [671] phi from tile_8_x_8_4BPP_16_color::@23 tile_8_x_8_4BPP_16_color::@8 to tile_8_x_8_4BPP_16_color::@7 [phi:tile_8_x_8_4BPP_16_color::@23/tile_8_x_8_4BPP_16_color::@8->tile_8_x_8_4BPP_16_color::@7]
    // [671] phi tile_8_x_8_4BPP_16_color::offset#4 = tile_8_x_8_4BPP_16_color::offset#2 [phi:tile_8_x_8_4BPP_16_color::@23/tile_8_x_8_4BPP_16_color::@8->tile_8_x_8_4BPP_16_color::@7#0] -- register_copy 
    // tile_8_x_8_4BPP_16_color::@7
  __b7:
    // tile &= 0x0f
    // [672] tile_8_x_8_4BPP_16_color::tile#25 = tile_8_x_8_4BPP_16_color::tile#20 & $f -- vwuz1=vwuz1_band_vbuc1 
    lda #$f
    and.z tile_2
    sta.z tile_2
    lda #0
    sta.z tile_2+1
    // for(byte c:0..31)
    // [673] tile_8_x_8_4BPP_16_color::c4#1 = ++ tile_8_x_8_4BPP_16_color::c4#2 -- vbuz1=_inc_vbuz1 
    inc.z c4
    // [674] if(tile_8_x_8_4BPP_16_color::c4#1!=$20) goto tile_8_x_8_4BPP_16_color::@6 -- vbuz1_neq_vbuc1_then_la1 
    lda #$20
    cmp.z c4
    bne __b6
    // tile_8_x_8_4BPP_16_color::@9
    // row += 2
    // [675] tile_8_x_8_4BPP_16_color::row#1 = tile_8_x_8_4BPP_16_color::row#5 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z row
    clc
    adc #2
    sta.z row
    // for(byte r:0..7)
    // [676] tile_8_x_8_4BPP_16_color::r#1 = ++ tile_8_x_8_4BPP_16_color::r#7 -- vbuz1=_inc_vbuz1 
    inc.z r
    // [677] if(tile_8_x_8_4BPP_16_color::r#1!=8) goto tile_8_x_8_4BPP_16_color::@5 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z r
    bne __b5
    // tile_8_x_8_4BPP_16_color::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [678] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [679] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [680] phi from tile_8_x_8_4BPP_16_color::vera_layer_show1 to tile_8_x_8_4BPP_16_color::@12 [phi:tile_8_x_8_4BPP_16_color::vera_layer_show1->tile_8_x_8_4BPP_16_color::@12]
    // tile_8_x_8_4BPP_16_color::@12
    // gotoxy(0,50)
    // [681] call gotoxy
    // [242] phi from tile_8_x_8_4BPP_16_color::@12 to gotoxy [phi:tile_8_x_8_4BPP_16_color::@12->gotoxy]
    // [242] phi gotoxy::y#35 = $32 [phi:tile_8_x_8_4BPP_16_color::@12->gotoxy#0] -- vbuz1=vbuc1 
    lda #$32
    sta.z gotoxy.y
    jsr gotoxy
    // [682] phi from tile_8_x_8_4BPP_16_color::@12 to tile_8_x_8_4BPP_16_color::@24 [phi:tile_8_x_8_4BPP_16_color::@12->tile_8_x_8_4BPP_16_color::@24]
    // tile_8_x_8_4BPP_16_color::@24
    // printf("vera in tile mode 8 x 8, color depth 4 bits per pixel.\n")
    // [683] call printf_str
    // [318] phi from tile_8_x_8_4BPP_16_color::@24 to printf_str [phi:tile_8_x_8_4BPP_16_color::@24->printf_str]
    // [318] phi printf_str::s#124 = tile_8_x_8_4BPP_16_color::s [phi:tile_8_x_8_4BPP_16_color::@24->printf_str#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // [684] phi from tile_8_x_8_4BPP_16_color::@24 to tile_8_x_8_4BPP_16_color::@25 [phi:tile_8_x_8_4BPP_16_color::@24->tile_8_x_8_4BPP_16_color::@25]
    // tile_8_x_8_4BPP_16_color::@25
    // printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n")
    // [685] call printf_str
    // [318] phi from tile_8_x_8_4BPP_16_color::@25 to printf_str [phi:tile_8_x_8_4BPP_16_color::@25->printf_str]
    // [318] phi printf_str::s#124 = s1 [phi:tile_8_x_8_4BPP_16_color::@25->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [686] phi from tile_8_x_8_4BPP_16_color::@25 to tile_8_x_8_4BPP_16_color::@26 [phi:tile_8_x_8_4BPP_16_color::@25->tile_8_x_8_4BPP_16_color::@26]
    // tile_8_x_8_4BPP_16_color::@26
    // printf("each tile can have a variation of 16 colors.\n")
    // [687] call printf_str
    // [318] phi from tile_8_x_8_4BPP_16_color::@26 to printf_str [phi:tile_8_x_8_4BPP_16_color::@26->printf_str]
    // [318] phi printf_str::s#124 = string_0 [phi:tile_8_x_8_4BPP_16_color::@26->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_0
    sta.z printf_str.s
    lda #>string_0
    sta.z printf_str.s+1
    jsr printf_str
    // [688] phi from tile_8_x_8_4BPP_16_color::@26 to tile_8_x_8_4BPP_16_color::@27 [phi:tile_8_x_8_4BPP_16_color::@26->tile_8_x_8_4BPP_16_color::@27]
    // tile_8_x_8_4BPP_16_color::@27
    // printf("the vera palette of 256 colors, can be used by setting the palette\n")
    // [689] call printf_str
    // [318] phi from tile_8_x_8_4BPP_16_color::@27 to printf_str [phi:tile_8_x_8_4BPP_16_color::@27->printf_str]
    // [318] phi printf_str::s#124 = s3 [phi:tile_8_x_8_4BPP_16_color::@27->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // [690] phi from tile_8_x_8_4BPP_16_color::@27 to tile_8_x_8_4BPP_16_color::@28 [phi:tile_8_x_8_4BPP_16_color::@27->tile_8_x_8_4BPP_16_color::@28]
    // tile_8_x_8_4BPP_16_color::@28
    // printf("offset for each tile.\n")
    // [691] call printf_str
    // [318] phi from tile_8_x_8_4BPP_16_color::@28 to printf_str [phi:tile_8_x_8_4BPP_16_color::@28->printf_str]
    // [318] phi printf_str::s#124 = s4 [phi:tile_8_x_8_4BPP_16_color::@28->printf_str#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // [692] phi from tile_8_x_8_4BPP_16_color::@28 to tile_8_x_8_4BPP_16_color::@29 [phi:tile_8_x_8_4BPP_16_color::@28->tile_8_x_8_4BPP_16_color::@29]
    // tile_8_x_8_4BPP_16_color::@29
    // printf("here each column is displaying the same tile, but with different offsets!\n")
    // [693] call printf_str
    // [318] phi from tile_8_x_8_4BPP_16_color::@29 to printf_str [phi:tile_8_x_8_4BPP_16_color::@29->printf_str]
    // [318] phi printf_str::s#124 = s5 [phi:tile_8_x_8_4BPP_16_color::@29->printf_str#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // [694] phi from tile_8_x_8_4BPP_16_color::@29 to tile_8_x_8_4BPP_16_color::@30 [phi:tile_8_x_8_4BPP_16_color::@29->tile_8_x_8_4BPP_16_color::@30]
    // tile_8_x_8_4BPP_16_color::@30
    // printf("each offset aligns to multiples of 16 colors in the palette!.\n")
    // [695] call printf_str
    // [318] phi from tile_8_x_8_4BPP_16_color::@30 to printf_str [phi:tile_8_x_8_4BPP_16_color::@30->printf_str]
    // [318] phi printf_str::s#124 = s6 [phi:tile_8_x_8_4BPP_16_color::@30->printf_str#0] -- pbuz1=pbuc1 
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    jsr printf_str
    // [696] phi from tile_8_x_8_4BPP_16_color::@30 to tile_8_x_8_4BPP_16_color::@31 [phi:tile_8_x_8_4BPP_16_color::@30->tile_8_x_8_4BPP_16_color::@31]
    // tile_8_x_8_4BPP_16_color::@31
    // printf("however, the first color will always be transparent (black).\n")
    // [697] call printf_str
    // [318] phi from tile_8_x_8_4BPP_16_color::@31 to printf_str [phi:tile_8_x_8_4BPP_16_color::@31->printf_str]
    // [318] phi printf_str::s#124 = s7 [phi:tile_8_x_8_4BPP_16_color::@31->printf_str#0] -- pbuz1=pbuc1 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // [698] phi from tile_8_x_8_4BPP_16_color::@31 tile_8_x_8_4BPP_16_color::@32 to tile_8_x_8_4BPP_16_color::@10 [phi:tile_8_x_8_4BPP_16_color::@31/tile_8_x_8_4BPP_16_color::@32->tile_8_x_8_4BPP_16_color::@10]
    // tile_8_x_8_4BPP_16_color::@10
  __b10:
    // getin()
    // [699] call getin
    jsr getin
    // [700] getin::return#30 = getin::return#1
    // tile_8_x_8_4BPP_16_color::@32
    // [701] tile_8_x_8_4BPP_16_color::$33 = getin::return#30
    // while(!getin())
    // [702] if(0==tile_8_x_8_4BPP_16_color::$33) goto tile_8_x_8_4BPP_16_color::@10 -- 0_eq_vbuz1_then_la1 
    lda.z __33
    beq __b10
    // tile_8_x_8_4BPP_16_color::@return
    // }
    // [703] return 
    rts
  .segment Data
    tiles: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    s: .text @"vera in tile mode 8 x 8, color depth 4 bits per pixel.\n"
    .byte 0
}
.segment Code
  // tile_16_x_16_2BPP_4_color
tile_16_x_16_2BPP_4_color: {
    .label __31 = $66
    .label column = $1d
    .label offset = $6a
    .label c = $70
    .label tile = $55
    .label row = $28
    .label r = $27
    // vera_layer_mode_tile(0, 0x04000, 0x14000, 128, 128, 16, 16, 2)
    // [705] call vera_layer_mode_tile
    // [1580] phi from tile_16_x_16_2BPP_4_color to vera_layer_mode_tile [phi:tile_16_x_16_2BPP_4_color->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = $10 [phi:tile_16_x_16_2BPP_4_color->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #$10
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = $10 [phi:tile_16_x_16_2BPP_4_color->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $14000 [phi:tile_16_x_16_2BPP_4_color->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $4000 [phi:tile_16_x_16_2BPP_4_color->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$4000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$4000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$4000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$4000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $80 [phi:tile_16_x_16_2BPP_4_color->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapheight
    lda #>$80
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 0 [phi:tile_16_x_16_2BPP_4_color->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $80 [phi:tile_16_x_16_2BPP_4_color->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 2 [phi:tile_16_x_16_2BPP_4_color->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #2
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // tile_16_x_16_2BPP_4_color::vera_display_set_scale_none1
    // *VERA_DC_HSCALE = 128
    // [706] *VERA_DC_HSCALE = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 128
    // [707] *VERA_DC_VSCALE = $80 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // [708] phi from tile_16_x_16_2BPP_4_color::vera_display_set_scale_none1 to tile_16_x_16_2BPP_4_color::@5 [phi:tile_16_x_16_2BPP_4_color::vera_display_set_scale_none1->tile_16_x_16_2BPP_4_color::@5]
    // tile_16_x_16_2BPP_4_color::@5
    // vera_layer_mode_text( 1, 0x00000, 0x0F800, 128, 128, 8, 8, 256 )
    // [709] call vera_layer_mode_text
    // [185] phi from tile_16_x_16_2BPP_4_color::@5 to vera_layer_mode_text [phi:tile_16_x_16_2BPP_4_color::@5->vera_layer_mode_text]
    // [185] phi vera_layer_mode_text::color_mode#11 = $100 [phi:tile_16_x_16_2BPP_4_color::@5->vera_layer_mode_text#0] -- vwuz1=vwuc1 
    lda #<$100
    sta.z vera_layer_mode_text.color_mode
    lda #>$100
    sta.z vera_layer_mode_text.color_mode+1
    // [185] phi vera_layer_mode_text::mapheight#11 = $80 [phi:tile_16_x_16_2BPP_4_color::@5->vera_layer_mode_text#1] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapheight
    lda #>$80
    sta.z vera_layer_mode_text.mapheight+1
    // [185] phi vera_layer_mode_text::mapwidth#11 = $80 [phi:tile_16_x_16_2BPP_4_color::@5->vera_layer_mode_text#2] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapwidth
    lda #>$80
    sta.z vera_layer_mode_text.mapwidth+1
    jsr vera_layer_mode_text
    // [710] phi from tile_16_x_16_2BPP_4_color::@5 to tile_16_x_16_2BPP_4_color::@7 [phi:tile_16_x_16_2BPP_4_color::@5->tile_16_x_16_2BPP_4_color::@7]
    // tile_16_x_16_2BPP_4_color::@7
    // screenlayer(1)
    // [711] call screenlayer
    jsr screenlayer
    // [712] phi from tile_16_x_16_2BPP_4_color::@7 to tile_16_x_16_2BPP_4_color::@8 [phi:tile_16_x_16_2BPP_4_color::@7->tile_16_x_16_2BPP_4_color::@8]
    // tile_16_x_16_2BPP_4_color::@8
    // textcolor(WHITE)
    // [713] call textcolor
    // [274] phi from tile_16_x_16_2BPP_4_color::@8 to textcolor [phi:tile_16_x_16_2BPP_4_color::@8->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:tile_16_x_16_2BPP_4_color::@8->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [714] phi from tile_16_x_16_2BPP_4_color::@8 to tile_16_x_16_2BPP_4_color::@9 [phi:tile_16_x_16_2BPP_4_color::@8->tile_16_x_16_2BPP_4_color::@9]
    // tile_16_x_16_2BPP_4_color::@9
    // bgcolor(BLACK)
    // [715] call bgcolor
    // [279] phi from tile_16_x_16_2BPP_4_color::@9 to bgcolor [phi:tile_16_x_16_2BPP_4_color::@9->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:tile_16_x_16_2BPP_4_color::@9->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [716] phi from tile_16_x_16_2BPP_4_color::@9 to tile_16_x_16_2BPP_4_color::@10 [phi:tile_16_x_16_2BPP_4_color::@9->tile_16_x_16_2BPP_4_color::@10]
    // tile_16_x_16_2BPP_4_color::@10
    // clrscr()
    // [717] call clrscr
    jsr clrscr
    // [718] phi from tile_16_x_16_2BPP_4_color::@10 to tile_16_x_16_2BPP_4_color::@11 [phi:tile_16_x_16_2BPP_4_color::@10->tile_16_x_16_2BPP_4_color::@11]
    // tile_16_x_16_2BPP_4_color::@11
    // cx16_cpy_vram_from_ram(1, 0x4000, tiles, 256)
    // [719] call cx16_cpy_vram_from_ram
    // [1694] phi from tile_16_x_16_2BPP_4_color::@11 to cx16_cpy_vram_from_ram [phi:tile_16_x_16_2BPP_4_color::@11->cx16_cpy_vram_from_ram]
    // [1694] phi cx16_cpy_vram_from_ram::num#10 = $100 [phi:tile_16_x_16_2BPP_4_color::@11->cx16_cpy_vram_from_ram#0] -- vwuz1=vwuc1 
    lda #<$100
    sta.z cx16_cpy_vram_from_ram.num
    lda #>$100
    sta.z cx16_cpy_vram_from_ram.num+1
    // [1694] phi cx16_cpy_vram_from_ram::sptr_ram#10 = (void *)tile_16_x_16_2BPP_4_color::tiles [phi:tile_16_x_16_2BPP_4_color::@11->cx16_cpy_vram_from_ram#1] -- pvoz1=pvoc1 
    lda #<tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram
    lda #>tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_offset#0 = $4000 [phi:tile_16_x_16_2BPP_4_color::@11->cx16_cpy_vram_from_ram#2] -- vwuz1=vwuc1 
    lda #<$4000
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_offset
    lda #>$4000
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_offset+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:tile_16_x_16_2BPP_4_color::@11->cx16_cpy_vram_from_ram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_ram
    // [720] phi from tile_16_x_16_2BPP_4_color::@11 to tile_16_x_16_2BPP_4_color::@12 [phi:tile_16_x_16_2BPP_4_color::@11->tile_16_x_16_2BPP_4_color::@12]
    // tile_16_x_16_2BPP_4_color::@12
    // vera_tile_area(0, 0, 0, 0, 40, 30, 0, 0, 0)
    // [721] call vera_tile_area
  //vera_tile_area(byte layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset)
    // [1709] phi from tile_16_x_16_2BPP_4_color::@12 to vera_tile_area [phi:tile_16_x_16_2BPP_4_color::@12->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = $28 [phi:tile_16_x_16_2BPP_4_color::@12->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$28
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = $1e [phi:tile_16_x_16_2BPP_4_color::@12->vera_tile_area#1] -- vbuz1=vbuc1 
    lda #$1e
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = 0 [phi:tile_16_x_16_2BPP_4_color::@12->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 0 [phi:tile_16_x_16_2BPP_4_color::@12->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 0 [phi:tile_16_x_16_2BPP_4_color::@12->vera_tile_area#4] -- vwuz1=vbuc1 
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_2BPP_4_color::@12->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [722] phi from tile_16_x_16_2BPP_4_color::@12 to tile_16_x_16_2BPP_4_color::@13 [phi:tile_16_x_16_2BPP_4_color::@12->tile_16_x_16_2BPP_4_color::@13]
    // tile_16_x_16_2BPP_4_color::@13
    // vera_tile_area(0, 0, 4, 2, 1, 1, 0, 0, 0)
    // [723] call vera_tile_area
  // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    // [1709] phi from tile_16_x_16_2BPP_4_color::@13 to vera_tile_area [phi:tile_16_x_16_2BPP_4_color::@13->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 1 [phi:tile_16_x_16_2BPP_4_color::@13->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 1 [phi:tile_16_x_16_2BPP_4_color::@13->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = 4 [phi:tile_16_x_16_2BPP_4_color::@13->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 2 [phi:tile_16_x_16_2BPP_4_color::@13->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #2
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 0 [phi:tile_16_x_16_2BPP_4_color::@13->vera_tile_area#4] -- vwuz1=vbuc1 
    lda #<0
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_2BPP_4_color::@13->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [724] phi from tile_16_x_16_2BPP_4_color::@13 to tile_16_x_16_2BPP_4_color::@14 [phi:tile_16_x_16_2BPP_4_color::@13->tile_16_x_16_2BPP_4_color::@14]
    // tile_16_x_16_2BPP_4_color::@14
    // vera_tile_area(0, 1, 10, 2, 1, 1, 0, 0, 0)
    // [725] call vera_tile_area
    // [1709] phi from tile_16_x_16_2BPP_4_color::@14 to vera_tile_area [phi:tile_16_x_16_2BPP_4_color::@14->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 1 [phi:tile_16_x_16_2BPP_4_color::@14->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 1 [phi:tile_16_x_16_2BPP_4_color::@14->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = $a [phi:tile_16_x_16_2BPP_4_color::@14->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #$a
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 2 [phi:tile_16_x_16_2BPP_4_color::@14->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #2
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 1 [phi:tile_16_x_16_2BPP_4_color::@14->vera_tile_area#4] -- vwuz1=vbuc1 
    lda #<1
    sta.z vera_tile_area.tileindex
    lda #>1
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_2BPP_4_color::@14->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [726] phi from tile_16_x_16_2BPP_4_color::@14 to tile_16_x_16_2BPP_4_color::@15 [phi:tile_16_x_16_2BPP_4_color::@14->tile_16_x_16_2BPP_4_color::@15]
    // tile_16_x_16_2BPP_4_color::@15
    // vera_tile_area(0, 2, 16, 2, 1, 1, 0, 0, 0)
    // [727] call vera_tile_area
    // [1709] phi from tile_16_x_16_2BPP_4_color::@15 to vera_tile_area [phi:tile_16_x_16_2BPP_4_color::@15->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 1 [phi:tile_16_x_16_2BPP_4_color::@15->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 1 [phi:tile_16_x_16_2BPP_4_color::@15->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = $10 [phi:tile_16_x_16_2BPP_4_color::@15->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #$10
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 2 [phi:tile_16_x_16_2BPP_4_color::@15->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #2
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 2 [phi:tile_16_x_16_2BPP_4_color::@15->vera_tile_area#4] -- vwuz1=vbuc1 
    sta.z vera_tile_area.tileindex
    lda #>2
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_2BPP_4_color::@15->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [728] phi from tile_16_x_16_2BPP_4_color::@15 to tile_16_x_16_2BPP_4_color::@16 [phi:tile_16_x_16_2BPP_4_color::@15->tile_16_x_16_2BPP_4_color::@16]
    // tile_16_x_16_2BPP_4_color::@16
    // vera_tile_area(0, 3, 22, 2, 1, 1, 0, 0, 0)
    // [729] call vera_tile_area
    // [1709] phi from tile_16_x_16_2BPP_4_color::@16 to vera_tile_area [phi:tile_16_x_16_2BPP_4_color::@16->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 1 [phi:tile_16_x_16_2BPP_4_color::@16->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 1 [phi:tile_16_x_16_2BPP_4_color::@16->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = $16 [phi:tile_16_x_16_2BPP_4_color::@16->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #$16
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 2 [phi:tile_16_x_16_2BPP_4_color::@16->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #2
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 3 [phi:tile_16_x_16_2BPP_4_color::@16->vera_tile_area#4] -- vwuz1=vbuc1 
    lda #<3
    sta.z vera_tile_area.tileindex
    lda #>3
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_2BPP_4_color::@16->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [730] phi from tile_16_x_16_2BPP_4_color::@16 to tile_16_x_16_2BPP_4_color::@17 [phi:tile_16_x_16_2BPP_4_color::@16->tile_16_x_16_2BPP_4_color::@17]
    // tile_16_x_16_2BPP_4_color::@17
    // vera_tile_area(0, 0, 4, 4, 4, 4, 0, 0, 0)
    // [731] call vera_tile_area
  // Draw 4 squares with each tile, starting from row 6, width 4, height 4, separated by 2 characters.
    // [1709] phi from tile_16_x_16_2BPP_4_color::@17 to vera_tile_area [phi:tile_16_x_16_2BPP_4_color::@17->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 4 [phi:tile_16_x_16_2BPP_4_color::@17->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 4 [phi:tile_16_x_16_2BPP_4_color::@17->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = 4 [phi:tile_16_x_16_2BPP_4_color::@17->vera_tile_area#2] -- vbuz1=vbuc1 
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 4 [phi:tile_16_x_16_2BPP_4_color::@17->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 0 [phi:tile_16_x_16_2BPP_4_color::@17->vera_tile_area#4] -- vwuz1=vbuc1 
    lda #<0
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_2BPP_4_color::@17->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [732] phi from tile_16_x_16_2BPP_4_color::@17 to tile_16_x_16_2BPP_4_color::@18 [phi:tile_16_x_16_2BPP_4_color::@17->tile_16_x_16_2BPP_4_color::@18]
    // tile_16_x_16_2BPP_4_color::@18
    // vera_tile_area(0, 1, 10, 4, 4, 4, 0, 0, 0)
    // [733] call vera_tile_area
    // [1709] phi from tile_16_x_16_2BPP_4_color::@18 to vera_tile_area [phi:tile_16_x_16_2BPP_4_color::@18->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 4 [phi:tile_16_x_16_2BPP_4_color::@18->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 4 [phi:tile_16_x_16_2BPP_4_color::@18->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = $a [phi:tile_16_x_16_2BPP_4_color::@18->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #$a
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 4 [phi:tile_16_x_16_2BPP_4_color::@18->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 1 [phi:tile_16_x_16_2BPP_4_color::@18->vera_tile_area#4] -- vwuz1=vbuc1 
    lda #<1
    sta.z vera_tile_area.tileindex
    lda #>1
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_2BPP_4_color::@18->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [734] phi from tile_16_x_16_2BPP_4_color::@18 to tile_16_x_16_2BPP_4_color::@19 [phi:tile_16_x_16_2BPP_4_color::@18->tile_16_x_16_2BPP_4_color::@19]
    // tile_16_x_16_2BPP_4_color::@19
    // vera_tile_area(0, 2, 16, 4, 4, 4, 0, 0, 0)
    // [735] call vera_tile_area
    // [1709] phi from tile_16_x_16_2BPP_4_color::@19 to vera_tile_area [phi:tile_16_x_16_2BPP_4_color::@19->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 4 [phi:tile_16_x_16_2BPP_4_color::@19->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 4 [phi:tile_16_x_16_2BPP_4_color::@19->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = $10 [phi:tile_16_x_16_2BPP_4_color::@19->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #$10
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 4 [phi:tile_16_x_16_2BPP_4_color::@19->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 2 [phi:tile_16_x_16_2BPP_4_color::@19->vera_tile_area#4] -- vwuz1=vbuc1 
    lda #<2
    sta.z vera_tile_area.tileindex
    lda #>2
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_2BPP_4_color::@19->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [736] phi from tile_16_x_16_2BPP_4_color::@19 to tile_16_x_16_2BPP_4_color::@20 [phi:tile_16_x_16_2BPP_4_color::@19->tile_16_x_16_2BPP_4_color::@20]
    // tile_16_x_16_2BPP_4_color::@20
    // vera_tile_area(0, 3, 22, 4, 4, 4, 0, 0, 0)
    // [737] call vera_tile_area
    // [1709] phi from tile_16_x_16_2BPP_4_color::@20 to vera_tile_area [phi:tile_16_x_16_2BPP_4_color::@20->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 4 [phi:tile_16_x_16_2BPP_4_color::@20->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 4 [phi:tile_16_x_16_2BPP_4_color::@20->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = $16 [phi:tile_16_x_16_2BPP_4_color::@20->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #$16
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 4 [phi:tile_16_x_16_2BPP_4_color::@20->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 3 [phi:tile_16_x_16_2BPP_4_color::@20->vera_tile_area#4] -- vwuz1=vbuc1 
    lda #<3
    sta.z vera_tile_area.tileindex
    lda #>3
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_16_x_16_2BPP_4_color::@20->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [738] phi from tile_16_x_16_2BPP_4_color::@20 to tile_16_x_16_2BPP_4_color::@1 [phi:tile_16_x_16_2BPP_4_color::@20->tile_16_x_16_2BPP_4_color::@1]
    // [738] phi tile_16_x_16_2BPP_4_color::r#5 = 0 [phi:tile_16_x_16_2BPP_4_color::@20->tile_16_x_16_2BPP_4_color::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // [738] phi tile_16_x_16_2BPP_4_color::offset#4 = 0 [phi:tile_16_x_16_2BPP_4_color::@20->tile_16_x_16_2BPP_4_color::@1#1] -- vbuz1=vbuc1 
    sta.z offset
    // [738] phi tile_16_x_16_2BPP_4_color::row#4 = $a [phi:tile_16_x_16_2BPP_4_color::@20->tile_16_x_16_2BPP_4_color::@1#2] -- vbuz1=vbuc1 
    lda #$a
    sta.z row
    // [738] phi tile_16_x_16_2BPP_4_color::tile#5 = 0 [phi:tile_16_x_16_2BPP_4_color::@20->tile_16_x_16_2BPP_4_color::@1#3] -- vwuz1=vwuc1 
    lda #<0
    sta.z tile
    sta.z tile+1
    // [738] phi from tile_16_x_16_2BPP_4_color::@3 to tile_16_x_16_2BPP_4_color::@1 [phi:tile_16_x_16_2BPP_4_color::@3->tile_16_x_16_2BPP_4_color::@1]
    // [738] phi tile_16_x_16_2BPP_4_color::r#5 = tile_16_x_16_2BPP_4_color::r#1 [phi:tile_16_x_16_2BPP_4_color::@3->tile_16_x_16_2BPP_4_color::@1#0] -- register_copy 
    // [738] phi tile_16_x_16_2BPP_4_color::offset#4 = tile_16_x_16_2BPP_4_color::offset#1 [phi:tile_16_x_16_2BPP_4_color::@3->tile_16_x_16_2BPP_4_color::@1#1] -- register_copy 
    // [738] phi tile_16_x_16_2BPP_4_color::row#4 = tile_16_x_16_2BPP_4_color::row#1 [phi:tile_16_x_16_2BPP_4_color::@3->tile_16_x_16_2BPP_4_color::@1#2] -- register_copy 
    // [738] phi tile_16_x_16_2BPP_4_color::tile#5 = tile_16_x_16_2BPP_4_color::tile#2 [phi:tile_16_x_16_2BPP_4_color::@3->tile_16_x_16_2BPP_4_color::@1#3] -- register_copy 
    // tile_16_x_16_2BPP_4_color::@1
  __b1:
    // [739] phi from tile_16_x_16_2BPP_4_color::@1 to tile_16_x_16_2BPP_4_color::@2 [phi:tile_16_x_16_2BPP_4_color::@1->tile_16_x_16_2BPP_4_color::@2]
    // [739] phi tile_16_x_16_2BPP_4_color::c#2 = 0 [phi:tile_16_x_16_2BPP_4_color::@1->tile_16_x_16_2BPP_4_color::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // [739] phi tile_16_x_16_2BPP_4_color::offset#2 = tile_16_x_16_2BPP_4_color::offset#4 [phi:tile_16_x_16_2BPP_4_color::@1->tile_16_x_16_2BPP_4_color::@2#1] -- register_copy 
    // [739] phi tile_16_x_16_2BPP_4_color::column#2 = 4 [phi:tile_16_x_16_2BPP_4_color::@1->tile_16_x_16_2BPP_4_color::@2#2] -- vbuz1=vbuc1 
    lda #4
    sta.z column
    // [739] phi from tile_16_x_16_2BPP_4_color::@21 to tile_16_x_16_2BPP_4_color::@2 [phi:tile_16_x_16_2BPP_4_color::@21->tile_16_x_16_2BPP_4_color::@2]
    // [739] phi tile_16_x_16_2BPP_4_color::c#2 = tile_16_x_16_2BPP_4_color::c#1 [phi:tile_16_x_16_2BPP_4_color::@21->tile_16_x_16_2BPP_4_color::@2#0] -- register_copy 
    // [739] phi tile_16_x_16_2BPP_4_color::offset#2 = tile_16_x_16_2BPP_4_color::offset#1 [phi:tile_16_x_16_2BPP_4_color::@21->tile_16_x_16_2BPP_4_color::@2#1] -- register_copy 
    // [739] phi tile_16_x_16_2BPP_4_color::column#2 = tile_16_x_16_2BPP_4_color::column#1 [phi:tile_16_x_16_2BPP_4_color::@21->tile_16_x_16_2BPP_4_color::@2#2] -- register_copy 
    // tile_16_x_16_2BPP_4_color::@2
  __b2:
    // vera_tile_area(0, tile, column, row, 1, 1, 0, 0, offset)
    // [740] vera_tile_area::tileindex#28 = tile_16_x_16_2BPP_4_color::tile#5 -- vwuz1=vwuz2 
    lda.z tile
    sta.z vera_tile_area.tileindex
    lda.z tile+1
    sta.z vera_tile_area.tileindex+1
    // [741] vera_tile_area::x#28 = tile_16_x_16_2BPP_4_color::column#2 -- vbuz1=vbuz2 
    lda.z column
    sta.z vera_tile_area.x
    // [742] vera_tile_area::y#28 = tile_16_x_16_2BPP_4_color::row#4 -- vbuz1=vbuz2 
    lda.z row
    sta.z vera_tile_area.y
    // [743] vera_tile_area::offset#29 = tile_16_x_16_2BPP_4_color::offset#2 -- vbuz1=vbuz2 
    lda.z offset
    sta.z vera_tile_area.offset
    // [744] call vera_tile_area
    // [1709] phi from tile_16_x_16_2BPP_4_color::@2 to vera_tile_area [phi:tile_16_x_16_2BPP_4_color::@2->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 1 [phi:tile_16_x_16_2BPP_4_color::@2->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 1 [phi:tile_16_x_16_2BPP_4_color::@2->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#28 [phi:tile_16_x_16_2BPP_4_color::@2->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = vera_tile_area::y#28 [phi:tile_16_x_16_2BPP_4_color::@2->vera_tile_area#3] -- register_copy 
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#28 [phi:tile_16_x_16_2BPP_4_color::@2->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = vera_tile_area::offset#29 [phi:tile_16_x_16_2BPP_4_color::@2->vera_tile_area#5] -- register_copy 
    jsr vera_tile_area
    // tile_16_x_16_2BPP_4_color::@21
    // column+=2
    // [745] tile_16_x_16_2BPP_4_color::column#1 = tile_16_x_16_2BPP_4_color::column#2 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z column
    clc
    adc #2
    sta.z column
    // offset++;
    // [746] tile_16_x_16_2BPP_4_color::offset#1 = ++ tile_16_x_16_2BPP_4_color::offset#2 -- vbuz1=_inc_vbuz1 
    inc.z offset
    // for(byte c:0..16)
    // [747] tile_16_x_16_2BPP_4_color::c#1 = ++ tile_16_x_16_2BPP_4_color::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [748] if(tile_16_x_16_2BPP_4_color::c#1!=$11) goto tile_16_x_16_2BPP_4_color::@2 -- vbuz1_neq_vbuc1_then_la1 
    lda #$11
    cmp.z c
    bne __b2
    // tile_16_x_16_2BPP_4_color::@3
    // tile++;
    // [749] tile_16_x_16_2BPP_4_color::tile#1 = ++ tile_16_x_16_2BPP_4_color::tile#5 -- vwuz1=_inc_vwuz1 
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // tile &= 0x3
    // [750] tile_16_x_16_2BPP_4_color::tile#2 = tile_16_x_16_2BPP_4_color::tile#1 & 3 -- vwuz1=vwuz1_band_vbuc1 
    lda #3
    and.z tile
    sta.z tile
    lda #0
    sta.z tile+1
    // row += 2
    // [751] tile_16_x_16_2BPP_4_color::row#1 = tile_16_x_16_2BPP_4_color::row#4 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z row
    clc
    adc #2
    sta.z row
    // for(byte r:0..3)
    // [752] tile_16_x_16_2BPP_4_color::r#1 = ++ tile_16_x_16_2BPP_4_color::r#5 -- vbuz1=_inc_vbuz1 
    inc.z r
    // [753] if(tile_16_x_16_2BPP_4_color::r#1!=4) goto tile_16_x_16_2BPP_4_color::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #4
    cmp.z r
    bne __b1
    // tile_16_x_16_2BPP_4_color::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [754] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [755] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [756] phi from tile_16_x_16_2BPP_4_color::vera_layer_show1 to tile_16_x_16_2BPP_4_color::@6 [phi:tile_16_x_16_2BPP_4_color::vera_layer_show1->tile_16_x_16_2BPP_4_color::@6]
    // tile_16_x_16_2BPP_4_color::@6
    // gotoxy(0,50)
    // [757] call gotoxy
    // [242] phi from tile_16_x_16_2BPP_4_color::@6 to gotoxy [phi:tile_16_x_16_2BPP_4_color::@6->gotoxy]
    // [242] phi gotoxy::y#35 = $32 [phi:tile_16_x_16_2BPP_4_color::@6->gotoxy#0] -- vbuz1=vbuc1 
    lda #$32
    sta.z gotoxy.y
    jsr gotoxy
    // [758] phi from tile_16_x_16_2BPP_4_color::@6 to tile_16_x_16_2BPP_4_color::@22 [phi:tile_16_x_16_2BPP_4_color::@6->tile_16_x_16_2BPP_4_color::@22]
    // tile_16_x_16_2BPP_4_color::@22
    // printf("vera in tile mode 8 x 8, color depth 2 bits per pixel.\n")
    // [759] call printf_str
    // [318] phi from tile_16_x_16_2BPP_4_color::@22 to printf_str [phi:tile_16_x_16_2BPP_4_color::@22->printf_str]
    // [318] phi printf_str::s#124 = string_1 [phi:tile_16_x_16_2BPP_4_color::@22->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_1
    sta.z printf_str.s
    lda #>string_1
    sta.z printf_str.s+1
    jsr printf_str
    // [760] phi from tile_16_x_16_2BPP_4_color::@22 to tile_16_x_16_2BPP_4_color::@23 [phi:tile_16_x_16_2BPP_4_color::@22->tile_16_x_16_2BPP_4_color::@23]
    // tile_16_x_16_2BPP_4_color::@23
    // printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n")
    // [761] call printf_str
    // [318] phi from tile_16_x_16_2BPP_4_color::@23 to printf_str [phi:tile_16_x_16_2BPP_4_color::@23->printf_str]
    // [318] phi printf_str::s#124 = s1 [phi:tile_16_x_16_2BPP_4_color::@23->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [762] phi from tile_16_x_16_2BPP_4_color::@23 to tile_16_x_16_2BPP_4_color::@24 [phi:tile_16_x_16_2BPP_4_color::@23->tile_16_x_16_2BPP_4_color::@24]
    // tile_16_x_16_2BPP_4_color::@24
    // printf("each tile can have a variation of 4 colors.\n")
    // [763] call printf_str
    // [318] phi from tile_16_x_16_2BPP_4_color::@24 to printf_str [phi:tile_16_x_16_2BPP_4_color::@24->printf_str]
    // [318] phi printf_str::s#124 = string_2 [phi:tile_16_x_16_2BPP_4_color::@24->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_2
    sta.z printf_str.s
    lda #>string_2
    sta.z printf_str.s+1
    jsr printf_str
    // [764] phi from tile_16_x_16_2BPP_4_color::@24 to tile_16_x_16_2BPP_4_color::@25 [phi:tile_16_x_16_2BPP_4_color::@24->tile_16_x_16_2BPP_4_color::@25]
    // tile_16_x_16_2BPP_4_color::@25
    // printf("the vera palette of 256 colors, can be used by setting the palette\n")
    // [765] call printf_str
    // [318] phi from tile_16_x_16_2BPP_4_color::@25 to printf_str [phi:tile_16_x_16_2BPP_4_color::@25->printf_str]
    // [318] phi printf_str::s#124 = s3 [phi:tile_16_x_16_2BPP_4_color::@25->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // [766] phi from tile_16_x_16_2BPP_4_color::@25 to tile_16_x_16_2BPP_4_color::@26 [phi:tile_16_x_16_2BPP_4_color::@25->tile_16_x_16_2BPP_4_color::@26]
    // tile_16_x_16_2BPP_4_color::@26
    // printf("offset for each tile.\n")
    // [767] call printf_str
    // [318] phi from tile_16_x_16_2BPP_4_color::@26 to printf_str [phi:tile_16_x_16_2BPP_4_color::@26->printf_str]
    // [318] phi printf_str::s#124 = s4 [phi:tile_16_x_16_2BPP_4_color::@26->printf_str#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // [768] phi from tile_16_x_16_2BPP_4_color::@26 to tile_16_x_16_2BPP_4_color::@27 [phi:tile_16_x_16_2BPP_4_color::@26->tile_16_x_16_2BPP_4_color::@27]
    // tile_16_x_16_2BPP_4_color::@27
    // printf("here each column is displaying the same tile, but with different offsets!\n")
    // [769] call printf_str
    // [318] phi from tile_16_x_16_2BPP_4_color::@27 to printf_str [phi:tile_16_x_16_2BPP_4_color::@27->printf_str]
    // [318] phi printf_str::s#124 = s5 [phi:tile_16_x_16_2BPP_4_color::@27->printf_str#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // [770] phi from tile_16_x_16_2BPP_4_color::@27 to tile_16_x_16_2BPP_4_color::@28 [phi:tile_16_x_16_2BPP_4_color::@27->tile_16_x_16_2BPP_4_color::@28]
    // tile_16_x_16_2BPP_4_color::@28
    // printf("each offset aligns to multiples of 16 colors, and only the first 4 colors\n")
    // [771] call printf_str
    // [318] phi from tile_16_x_16_2BPP_4_color::@28 to printf_str [phi:tile_16_x_16_2BPP_4_color::@28->printf_str]
    // [318] phi printf_str::s#124 = string_3 [phi:tile_16_x_16_2BPP_4_color::@28->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_3
    sta.z printf_str.s
    lda #>string_3
    sta.z printf_str.s+1
    jsr printf_str
    // [772] phi from tile_16_x_16_2BPP_4_color::@28 to tile_16_x_16_2BPP_4_color::@29 [phi:tile_16_x_16_2BPP_4_color::@28->tile_16_x_16_2BPP_4_color::@29]
    // tile_16_x_16_2BPP_4_color::@29
    // printf("can be used per offset!\n")
    // [773] call printf_str
    // [318] phi from tile_16_x_16_2BPP_4_color::@29 to printf_str [phi:tile_16_x_16_2BPP_4_color::@29->printf_str]
    // [318] phi printf_str::s#124 = string_4 [phi:tile_16_x_16_2BPP_4_color::@29->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_4
    sta.z printf_str.s
    lda #>string_4
    sta.z printf_str.s+1
    jsr printf_str
    // [774] phi from tile_16_x_16_2BPP_4_color::@29 to tile_16_x_16_2BPP_4_color::@30 [phi:tile_16_x_16_2BPP_4_color::@29->tile_16_x_16_2BPP_4_color::@30]
    // tile_16_x_16_2BPP_4_color::@30
    // printf("however, the first color will always be transparent (black).\n")
    // [775] call printf_str
    // [318] phi from tile_16_x_16_2BPP_4_color::@30 to printf_str [phi:tile_16_x_16_2BPP_4_color::@30->printf_str]
    // [318] phi printf_str::s#124 = s7 [phi:tile_16_x_16_2BPP_4_color::@30->printf_str#0] -- pbuz1=pbuc1 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // [776] phi from tile_16_x_16_2BPP_4_color::@30 tile_16_x_16_2BPP_4_color::@31 to tile_16_x_16_2BPP_4_color::@4 [phi:tile_16_x_16_2BPP_4_color::@30/tile_16_x_16_2BPP_4_color::@31->tile_16_x_16_2BPP_4_color::@4]
    // tile_16_x_16_2BPP_4_color::@4
  __b4:
    // getin()
    // [777] call getin
    jsr getin
    // [778] getin::return#31 = getin::return#1
    // tile_16_x_16_2BPP_4_color::@31
    // [779] tile_16_x_16_2BPP_4_color::$31 = getin::return#31
    // while(!getin())
    // [780] if(0==tile_16_x_16_2BPP_4_color::$31) goto tile_16_x_16_2BPP_4_color::@4 -- 0_eq_vbuz1_then_la1 
    lda.z __31
    beq __b4
    // tile_16_x_16_2BPP_4_color::@return
    // }
    // [781] return 
    rts
  .segment Data
    tiles: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
}
.segment Code
  // tile_8_x_8_2BPP_4_color
tile_8_x_8_2BPP_4_color: {
    .label __27 = $66
    .label column = $bc
    .label offset = $bd
    .label c = $b3
    .label tile = $49
    .label row = $d9
    .label r = $d8
    // vera_layer_mode_tile(0, 0x04000, 0x14000, 128, 128, 8, 8, 2)
    // [783] call vera_layer_mode_tile
    // [1580] phi from tile_8_x_8_2BPP_4_color to vera_layer_mode_tile [phi:tile_8_x_8_2BPP_4_color->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = 8 [phi:tile_8_x_8_2BPP_4_color->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = 8 [phi:tile_8_x_8_2BPP_4_color->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $14000 [phi:tile_8_x_8_2BPP_4_color->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $4000 [phi:tile_8_x_8_2BPP_4_color->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$4000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$4000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$4000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$4000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $80 [phi:tile_8_x_8_2BPP_4_color->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapheight
    lda #>$80
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 0 [phi:tile_8_x_8_2BPP_4_color->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $80 [phi:tile_8_x_8_2BPP_4_color->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 2 [phi:tile_8_x_8_2BPP_4_color->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #2
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // tile_8_x_8_2BPP_4_color::vera_display_set_scale_none1
    // *VERA_DC_HSCALE = 128
    // [784] *VERA_DC_HSCALE = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 128
    // [785] *VERA_DC_VSCALE = $80 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // [786] phi from tile_8_x_8_2BPP_4_color::vera_display_set_scale_none1 to tile_8_x_8_2BPP_4_color::@5 [phi:tile_8_x_8_2BPP_4_color::vera_display_set_scale_none1->tile_8_x_8_2BPP_4_color::@5]
    // tile_8_x_8_2BPP_4_color::@5
    // vera_layer_mode_text( 1, 0x00000, 0x0F800, 128, 128, 8, 8, 256 )
    // [787] call vera_layer_mode_text
    // [185] phi from tile_8_x_8_2BPP_4_color::@5 to vera_layer_mode_text [phi:tile_8_x_8_2BPP_4_color::@5->vera_layer_mode_text]
    // [185] phi vera_layer_mode_text::color_mode#11 = $100 [phi:tile_8_x_8_2BPP_4_color::@5->vera_layer_mode_text#0] -- vwuz1=vwuc1 
    lda #<$100
    sta.z vera_layer_mode_text.color_mode
    lda #>$100
    sta.z vera_layer_mode_text.color_mode+1
    // [185] phi vera_layer_mode_text::mapheight#11 = $80 [phi:tile_8_x_8_2BPP_4_color::@5->vera_layer_mode_text#1] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapheight
    lda #>$80
    sta.z vera_layer_mode_text.mapheight+1
    // [185] phi vera_layer_mode_text::mapwidth#11 = $80 [phi:tile_8_x_8_2BPP_4_color::@5->vera_layer_mode_text#2] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapwidth
    lda #>$80
    sta.z vera_layer_mode_text.mapwidth+1
    jsr vera_layer_mode_text
    // [788] phi from tile_8_x_8_2BPP_4_color::@5 to tile_8_x_8_2BPP_4_color::@7 [phi:tile_8_x_8_2BPP_4_color::@5->tile_8_x_8_2BPP_4_color::@7]
    // tile_8_x_8_2BPP_4_color::@7
    // screenlayer(1)
    // [789] call screenlayer
    jsr screenlayer
    // [790] phi from tile_8_x_8_2BPP_4_color::@7 to tile_8_x_8_2BPP_4_color::@8 [phi:tile_8_x_8_2BPP_4_color::@7->tile_8_x_8_2BPP_4_color::@8]
    // tile_8_x_8_2BPP_4_color::@8
    // textcolor(WHITE)
    // [791] call textcolor
    // [274] phi from tile_8_x_8_2BPP_4_color::@8 to textcolor [phi:tile_8_x_8_2BPP_4_color::@8->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:tile_8_x_8_2BPP_4_color::@8->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [792] phi from tile_8_x_8_2BPP_4_color::@8 to tile_8_x_8_2BPP_4_color::@9 [phi:tile_8_x_8_2BPP_4_color::@8->tile_8_x_8_2BPP_4_color::@9]
    // tile_8_x_8_2BPP_4_color::@9
    // bgcolor(BLACK)
    // [793] call bgcolor
    // [279] phi from tile_8_x_8_2BPP_4_color::@9 to bgcolor [phi:tile_8_x_8_2BPP_4_color::@9->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:tile_8_x_8_2BPP_4_color::@9->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [794] phi from tile_8_x_8_2BPP_4_color::@9 to tile_8_x_8_2BPP_4_color::@10 [phi:tile_8_x_8_2BPP_4_color::@9->tile_8_x_8_2BPP_4_color::@10]
    // tile_8_x_8_2BPP_4_color::@10
    // clrscr()
    // [795] call clrscr
    jsr clrscr
    // [796] phi from tile_8_x_8_2BPP_4_color::@10 to tile_8_x_8_2BPP_4_color::@11 [phi:tile_8_x_8_2BPP_4_color::@10->tile_8_x_8_2BPP_4_color::@11]
    // tile_8_x_8_2BPP_4_color::@11
    // cx16_cpy_vram_from_ram(1, 0x4000, tiles, 64)
    // [797] call cx16_cpy_vram_from_ram
    // [1694] phi from tile_8_x_8_2BPP_4_color::@11 to cx16_cpy_vram_from_ram [phi:tile_8_x_8_2BPP_4_color::@11->cx16_cpy_vram_from_ram]
    // [1694] phi cx16_cpy_vram_from_ram::num#10 = $40 [phi:tile_8_x_8_2BPP_4_color::@11->cx16_cpy_vram_from_ram#0] -- vwuz1=vbuc1 
    lda #<$40
    sta.z cx16_cpy_vram_from_ram.num
    lda #>$40
    sta.z cx16_cpy_vram_from_ram.num+1
    // [1694] phi cx16_cpy_vram_from_ram::sptr_ram#10 = (void *)tile_8_x_8_2BPP_4_color::tiles [phi:tile_8_x_8_2BPP_4_color::@11->cx16_cpy_vram_from_ram#1] -- pvoz1=pvoc1 
    lda #<tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram
    lda #>tiles
    sta.z cx16_cpy_vram_from_ram.sptr_ram+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_offset#0 = $4000 [phi:tile_8_x_8_2BPP_4_color::@11->cx16_cpy_vram_from_ram#2] -- vwuz1=vwuc1 
    lda #<$4000
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_offset
    lda #>$4000
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_offset+1
    // [1694] phi cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:tile_8_x_8_2BPP_4_color::@11->cx16_cpy_vram_from_ram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_ram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_ram
    // [798] phi from tile_8_x_8_2BPP_4_color::@11 to tile_8_x_8_2BPP_4_color::@12 [phi:tile_8_x_8_2BPP_4_color::@11->tile_8_x_8_2BPP_4_color::@12]
    // tile_8_x_8_2BPP_4_color::@12
    // vera_tile_area(0, 0, 0, 0, 80, 60, 0, 0, 0)
    // [799] call vera_tile_area
  //vera_tile_area(byte layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset)
    // [1709] phi from tile_8_x_8_2BPP_4_color::@12 to vera_tile_area [phi:tile_8_x_8_2BPP_4_color::@12->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = $50 [phi:tile_8_x_8_2BPP_4_color::@12->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$50
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = $3c [phi:tile_8_x_8_2BPP_4_color::@12->vera_tile_area#1] -- vbuz1=vbuc1 
    lda #$3c
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = 0 [phi:tile_8_x_8_2BPP_4_color::@12->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 0 [phi:tile_8_x_8_2BPP_4_color::@12->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 0 [phi:tile_8_x_8_2BPP_4_color::@12->vera_tile_area#4] -- vwuz1=vbuc1 
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_2BPP_4_color::@12->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [800] phi from tile_8_x_8_2BPP_4_color::@12 to tile_8_x_8_2BPP_4_color::@13 [phi:tile_8_x_8_2BPP_4_color::@12->tile_8_x_8_2BPP_4_color::@13]
    // tile_8_x_8_2BPP_4_color::@13
    // vera_tile_area(0, 0, 4, 4, 10, 10, 0, 0, 0)
    // [801] call vera_tile_area
  // Draw 4 squares with each tile, staring from row 2, width 10, height 10, separated by 2 characters.
    // [1709] phi from tile_8_x_8_2BPP_4_color::@13 to vera_tile_area [phi:tile_8_x_8_2BPP_4_color::@13->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = $a [phi:tile_8_x_8_2BPP_4_color::@13->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$a
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = $a [phi:tile_8_x_8_2BPP_4_color::@13->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = 4 [phi:tile_8_x_8_2BPP_4_color::@13->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 4 [phi:tile_8_x_8_2BPP_4_color::@13->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 0 [phi:tile_8_x_8_2BPP_4_color::@13->vera_tile_area#4] -- vwuz1=vbuc1 
    lda #<0
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_2BPP_4_color::@13->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [802] phi from tile_8_x_8_2BPP_4_color::@13 to tile_8_x_8_2BPP_4_color::@14 [phi:tile_8_x_8_2BPP_4_color::@13->tile_8_x_8_2BPP_4_color::@14]
    // tile_8_x_8_2BPP_4_color::@14
    // vera_tile_area(0, 1, 16, 4, 10, 10, 0, 0, 0)
    // [803] call vera_tile_area
    // [1709] phi from tile_8_x_8_2BPP_4_color::@14 to vera_tile_area [phi:tile_8_x_8_2BPP_4_color::@14->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = $a [phi:tile_8_x_8_2BPP_4_color::@14->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$a
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = $a [phi:tile_8_x_8_2BPP_4_color::@14->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = $10 [phi:tile_8_x_8_2BPP_4_color::@14->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #$10
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 4 [phi:tile_8_x_8_2BPP_4_color::@14->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 1 [phi:tile_8_x_8_2BPP_4_color::@14->vera_tile_area#4] -- vwuz1=vbuc1 
    lda #<1
    sta.z vera_tile_area.tileindex
    lda #>1
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_2BPP_4_color::@14->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [804] phi from tile_8_x_8_2BPP_4_color::@14 to tile_8_x_8_2BPP_4_color::@15 [phi:tile_8_x_8_2BPP_4_color::@14->tile_8_x_8_2BPP_4_color::@15]
    // tile_8_x_8_2BPP_4_color::@15
    // vera_tile_area(0, 2, 28, 4, 10, 10, 0, 0, 0)
    // [805] call vera_tile_area
    // [1709] phi from tile_8_x_8_2BPP_4_color::@15 to vera_tile_area [phi:tile_8_x_8_2BPP_4_color::@15->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = $a [phi:tile_8_x_8_2BPP_4_color::@15->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$a
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = $a [phi:tile_8_x_8_2BPP_4_color::@15->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = $1c [phi:tile_8_x_8_2BPP_4_color::@15->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #$1c
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 4 [phi:tile_8_x_8_2BPP_4_color::@15->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 2 [phi:tile_8_x_8_2BPP_4_color::@15->vera_tile_area#4] -- vwuz1=vbuc1 
    lda #<2
    sta.z vera_tile_area.tileindex
    lda #>2
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_2BPP_4_color::@15->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [806] phi from tile_8_x_8_2BPP_4_color::@15 to tile_8_x_8_2BPP_4_color::@16 [phi:tile_8_x_8_2BPP_4_color::@15->tile_8_x_8_2BPP_4_color::@16]
    // tile_8_x_8_2BPP_4_color::@16
    // vera_tile_area(0, 3, 40, 4, 10, 10, 0, 0, 0)
    // [807] call vera_tile_area
    // [1709] phi from tile_8_x_8_2BPP_4_color::@16 to vera_tile_area [phi:tile_8_x_8_2BPP_4_color::@16->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = $a [phi:tile_8_x_8_2BPP_4_color::@16->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$a
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = $a [phi:tile_8_x_8_2BPP_4_color::@16->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = $28 [phi:tile_8_x_8_2BPP_4_color::@16->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #$28
    sta.z vera_tile_area.x
    // [1709] phi vera_tile_area::y#35 = 4 [phi:tile_8_x_8_2BPP_4_color::@16->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_tile_area.y
    // [1709] phi vera_tile_area::tileindex#35 = 3 [phi:tile_8_x_8_2BPP_4_color::@16->vera_tile_area#4] -- vwuz1=vbuc1 
    lda #<3
    sta.z vera_tile_area.tileindex
    lda #>3
    sta.z vera_tile_area.tileindex+1
    // [1709] phi vera_tile_area::offset#36 = 0 [phi:tile_8_x_8_2BPP_4_color::@16->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [808] phi from tile_8_x_8_2BPP_4_color::@16 to tile_8_x_8_2BPP_4_color::@1 [phi:tile_8_x_8_2BPP_4_color::@16->tile_8_x_8_2BPP_4_color::@1]
    // [808] phi tile_8_x_8_2BPP_4_color::r#5 = 0 [phi:tile_8_x_8_2BPP_4_color::@16->tile_8_x_8_2BPP_4_color::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // [808] phi tile_8_x_8_2BPP_4_color::offset#4 = 0 [phi:tile_8_x_8_2BPP_4_color::@16->tile_8_x_8_2BPP_4_color::@1#1] -- vbuz1=vbuc1 
    sta.z offset
    // [808] phi tile_8_x_8_2BPP_4_color::row#4 = $16 [phi:tile_8_x_8_2BPP_4_color::@16->tile_8_x_8_2BPP_4_color::@1#2] -- vbuz1=vbuc1 
    lda #$16
    sta.z row
    // [808] phi tile_8_x_8_2BPP_4_color::tile#5 = 0 [phi:tile_8_x_8_2BPP_4_color::@16->tile_8_x_8_2BPP_4_color::@1#3] -- vwuz1=vwuc1 
    lda #<0
    sta.z tile
    sta.z tile+1
    // [808] phi from tile_8_x_8_2BPP_4_color::@3 to tile_8_x_8_2BPP_4_color::@1 [phi:tile_8_x_8_2BPP_4_color::@3->tile_8_x_8_2BPP_4_color::@1]
    // [808] phi tile_8_x_8_2BPP_4_color::r#5 = tile_8_x_8_2BPP_4_color::r#1 [phi:tile_8_x_8_2BPP_4_color::@3->tile_8_x_8_2BPP_4_color::@1#0] -- register_copy 
    // [808] phi tile_8_x_8_2BPP_4_color::offset#4 = tile_8_x_8_2BPP_4_color::offset#1 [phi:tile_8_x_8_2BPP_4_color::@3->tile_8_x_8_2BPP_4_color::@1#1] -- register_copy 
    // [808] phi tile_8_x_8_2BPP_4_color::row#4 = tile_8_x_8_2BPP_4_color::row#1 [phi:tile_8_x_8_2BPP_4_color::@3->tile_8_x_8_2BPP_4_color::@1#2] -- register_copy 
    // [808] phi tile_8_x_8_2BPP_4_color::tile#5 = tile_8_x_8_2BPP_4_color::tile#2 [phi:tile_8_x_8_2BPP_4_color::@3->tile_8_x_8_2BPP_4_color::@1#3] -- register_copy 
    // tile_8_x_8_2BPP_4_color::@1
  __b1:
    // [809] phi from tile_8_x_8_2BPP_4_color::@1 to tile_8_x_8_2BPP_4_color::@2 [phi:tile_8_x_8_2BPP_4_color::@1->tile_8_x_8_2BPP_4_color::@2]
    // [809] phi tile_8_x_8_2BPP_4_color::c#2 = 0 [phi:tile_8_x_8_2BPP_4_color::@1->tile_8_x_8_2BPP_4_color::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // [809] phi tile_8_x_8_2BPP_4_color::offset#2 = tile_8_x_8_2BPP_4_color::offset#4 [phi:tile_8_x_8_2BPP_4_color::@1->tile_8_x_8_2BPP_4_color::@2#1] -- register_copy 
    // [809] phi tile_8_x_8_2BPP_4_color::column#2 = 4 [phi:tile_8_x_8_2BPP_4_color::@1->tile_8_x_8_2BPP_4_color::@2#2] -- vbuz1=vbuc1 
    lda #4
    sta.z column
    // [809] phi from tile_8_x_8_2BPP_4_color::@17 to tile_8_x_8_2BPP_4_color::@2 [phi:tile_8_x_8_2BPP_4_color::@17->tile_8_x_8_2BPP_4_color::@2]
    // [809] phi tile_8_x_8_2BPP_4_color::c#2 = tile_8_x_8_2BPP_4_color::c#1 [phi:tile_8_x_8_2BPP_4_color::@17->tile_8_x_8_2BPP_4_color::@2#0] -- register_copy 
    // [809] phi tile_8_x_8_2BPP_4_color::offset#2 = tile_8_x_8_2BPP_4_color::offset#1 [phi:tile_8_x_8_2BPP_4_color::@17->tile_8_x_8_2BPP_4_color::@2#1] -- register_copy 
    // [809] phi tile_8_x_8_2BPP_4_color::column#2 = tile_8_x_8_2BPP_4_color::column#1 [phi:tile_8_x_8_2BPP_4_color::@17->tile_8_x_8_2BPP_4_color::@2#2] -- register_copy 
    // tile_8_x_8_2BPP_4_color::@2
  __b2:
    // vera_tile_area(0, tile, column, row, 3, 3, 0, 0, offset)
    // [810] vera_tile_area::tileindex#34 = tile_8_x_8_2BPP_4_color::tile#5 -- vwuz1=vwuz2 
    lda.z tile
    sta.z vera_tile_area.tileindex
    lda.z tile+1
    sta.z vera_tile_area.tileindex+1
    // [811] vera_tile_area::x#34 = tile_8_x_8_2BPP_4_color::column#2 -- vbuz1=vbuz2 
    lda.z column
    sta.z vera_tile_area.x
    // [812] vera_tile_area::y#34 = tile_8_x_8_2BPP_4_color::row#4 -- vbuz1=vbuz2 
    lda.z row
    sta.z vera_tile_area.y
    // [813] vera_tile_area::offset#35 = tile_8_x_8_2BPP_4_color::offset#2 -- vbuz1=vbuz2 
    lda.z offset
    sta.z vera_tile_area.offset
    // [814] call vera_tile_area
    // [1709] phi from tile_8_x_8_2BPP_4_color::@2 to vera_tile_area [phi:tile_8_x_8_2BPP_4_color::@2->vera_tile_area]
    // [1709] phi vera_tile_area::w#42 = 3 [phi:tile_8_x_8_2BPP_4_color::@2->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #3
    sta.z vera_tile_area.w
    // [1709] phi vera_tile_area::h#36 = 3 [phi:tile_8_x_8_2BPP_4_color::@2->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [1709] phi vera_tile_area::x#35 = vera_tile_area::x#34 [phi:tile_8_x_8_2BPP_4_color::@2->vera_tile_area#2] -- register_copy 
    // [1709] phi vera_tile_area::y#35 = vera_tile_area::y#34 [phi:tile_8_x_8_2BPP_4_color::@2->vera_tile_area#3] -- register_copy 
    // [1709] phi vera_tile_area::tileindex#35 = vera_tile_area::tileindex#34 [phi:tile_8_x_8_2BPP_4_color::@2->vera_tile_area#4] -- register_copy 
    // [1709] phi vera_tile_area::offset#36 = vera_tile_area::offset#35 [phi:tile_8_x_8_2BPP_4_color::@2->vera_tile_area#5] -- register_copy 
    jsr vera_tile_area
    // tile_8_x_8_2BPP_4_color::@17
    // column+=4
    // [815] tile_8_x_8_2BPP_4_color::column#1 = tile_8_x_8_2BPP_4_color::column#2 + 4 -- vbuz1=vbuz1_plus_vbuc1 
    lda #4
    clc
    adc.z column
    sta.z column
    // offset++;
    // [816] tile_8_x_8_2BPP_4_color::offset#1 = ++ tile_8_x_8_2BPP_4_color::offset#2 -- vbuz1=_inc_vbuz1 
    inc.z offset
    // for(byte c:0..15)
    // [817] tile_8_x_8_2BPP_4_color::c#1 = ++ tile_8_x_8_2BPP_4_color::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [818] if(tile_8_x_8_2BPP_4_color::c#1!=$10) goto tile_8_x_8_2BPP_4_color::@2 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z c
    bne __b2
    // tile_8_x_8_2BPP_4_color::@3
    // tile++;
    // [819] tile_8_x_8_2BPP_4_color::tile#1 = ++ tile_8_x_8_2BPP_4_color::tile#5 -- vwuz1=_inc_vwuz1 
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // tile &= 0x3
    // [820] tile_8_x_8_2BPP_4_color::tile#2 = tile_8_x_8_2BPP_4_color::tile#1 & 3 -- vwuz1=vwuz1_band_vbuc1 
    lda #3
    and.z tile
    sta.z tile
    lda #0
    sta.z tile+1
    // row += 4
    // [821] tile_8_x_8_2BPP_4_color::row#1 = tile_8_x_8_2BPP_4_color::row#4 + 4 -- vbuz1=vbuz1_plus_vbuc1 
    lda #4
    clc
    adc.z row
    sta.z row
    // for(byte r:0..3)
    // [822] tile_8_x_8_2BPP_4_color::r#1 = ++ tile_8_x_8_2BPP_4_color::r#5 -- vbuz1=_inc_vbuz1 
    inc.z r
    // [823] if(tile_8_x_8_2BPP_4_color::r#1!=4) goto tile_8_x_8_2BPP_4_color::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #4
    cmp.z r
    bne __b1
    // tile_8_x_8_2BPP_4_color::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [824] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [825] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [826] phi from tile_8_x_8_2BPP_4_color::vera_layer_show1 to tile_8_x_8_2BPP_4_color::@6 [phi:tile_8_x_8_2BPP_4_color::vera_layer_show1->tile_8_x_8_2BPP_4_color::@6]
    // tile_8_x_8_2BPP_4_color::@6
    // gotoxy(0,50)
    // [827] call gotoxy
    // [242] phi from tile_8_x_8_2BPP_4_color::@6 to gotoxy [phi:tile_8_x_8_2BPP_4_color::@6->gotoxy]
    // [242] phi gotoxy::y#35 = $32 [phi:tile_8_x_8_2BPP_4_color::@6->gotoxy#0] -- vbuz1=vbuc1 
    lda #$32
    sta.z gotoxy.y
    jsr gotoxy
    // [828] phi from tile_8_x_8_2BPP_4_color::@6 to tile_8_x_8_2BPP_4_color::@18 [phi:tile_8_x_8_2BPP_4_color::@6->tile_8_x_8_2BPP_4_color::@18]
    // tile_8_x_8_2BPP_4_color::@18
    // printf("vera in tile mode 8 x 8, color depth 2 bits per pixel.\n")
    // [829] call printf_str
    // [318] phi from tile_8_x_8_2BPP_4_color::@18 to printf_str [phi:tile_8_x_8_2BPP_4_color::@18->printf_str]
    // [318] phi printf_str::s#124 = string_1 [phi:tile_8_x_8_2BPP_4_color::@18->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_1
    sta.z printf_str.s
    lda #>string_1
    sta.z printf_str.s+1
    jsr printf_str
    // [830] phi from tile_8_x_8_2BPP_4_color::@18 to tile_8_x_8_2BPP_4_color::@19 [phi:tile_8_x_8_2BPP_4_color::@18->tile_8_x_8_2BPP_4_color::@19]
    // tile_8_x_8_2BPP_4_color::@19
    // printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n")
    // [831] call printf_str
    // [318] phi from tile_8_x_8_2BPP_4_color::@19 to printf_str [phi:tile_8_x_8_2BPP_4_color::@19->printf_str]
    // [318] phi printf_str::s#124 = s1 [phi:tile_8_x_8_2BPP_4_color::@19->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [832] phi from tile_8_x_8_2BPP_4_color::@19 to tile_8_x_8_2BPP_4_color::@20 [phi:tile_8_x_8_2BPP_4_color::@19->tile_8_x_8_2BPP_4_color::@20]
    // tile_8_x_8_2BPP_4_color::@20
    // printf("each tile can have a variation of 4 colors.\n")
    // [833] call printf_str
    // [318] phi from tile_8_x_8_2BPP_4_color::@20 to printf_str [phi:tile_8_x_8_2BPP_4_color::@20->printf_str]
    // [318] phi printf_str::s#124 = string_2 [phi:tile_8_x_8_2BPP_4_color::@20->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_2
    sta.z printf_str.s
    lda #>string_2
    sta.z printf_str.s+1
    jsr printf_str
    // [834] phi from tile_8_x_8_2BPP_4_color::@20 to tile_8_x_8_2BPP_4_color::@21 [phi:tile_8_x_8_2BPP_4_color::@20->tile_8_x_8_2BPP_4_color::@21]
    // tile_8_x_8_2BPP_4_color::@21
    // printf("the vera palette of 256 colors, can be used by setting the palette\n")
    // [835] call printf_str
    // [318] phi from tile_8_x_8_2BPP_4_color::@21 to printf_str [phi:tile_8_x_8_2BPP_4_color::@21->printf_str]
    // [318] phi printf_str::s#124 = s3 [phi:tile_8_x_8_2BPP_4_color::@21->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // [836] phi from tile_8_x_8_2BPP_4_color::@21 to tile_8_x_8_2BPP_4_color::@22 [phi:tile_8_x_8_2BPP_4_color::@21->tile_8_x_8_2BPP_4_color::@22]
    // tile_8_x_8_2BPP_4_color::@22
    // printf("offset for each tile.\n")
    // [837] call printf_str
    // [318] phi from tile_8_x_8_2BPP_4_color::@22 to printf_str [phi:tile_8_x_8_2BPP_4_color::@22->printf_str]
    // [318] phi printf_str::s#124 = s4 [phi:tile_8_x_8_2BPP_4_color::@22->printf_str#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // [838] phi from tile_8_x_8_2BPP_4_color::@22 to tile_8_x_8_2BPP_4_color::@23 [phi:tile_8_x_8_2BPP_4_color::@22->tile_8_x_8_2BPP_4_color::@23]
    // tile_8_x_8_2BPP_4_color::@23
    // printf("here each column is displaying the same tile, but with different offsets!\n")
    // [839] call printf_str
    // [318] phi from tile_8_x_8_2BPP_4_color::@23 to printf_str [phi:tile_8_x_8_2BPP_4_color::@23->printf_str]
    // [318] phi printf_str::s#124 = s5 [phi:tile_8_x_8_2BPP_4_color::@23->printf_str#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // [840] phi from tile_8_x_8_2BPP_4_color::@23 to tile_8_x_8_2BPP_4_color::@24 [phi:tile_8_x_8_2BPP_4_color::@23->tile_8_x_8_2BPP_4_color::@24]
    // tile_8_x_8_2BPP_4_color::@24
    // printf("each offset aligns to multiples of 16 colors, and only the first 4 colors\n")
    // [841] call printf_str
    // [318] phi from tile_8_x_8_2BPP_4_color::@24 to printf_str [phi:tile_8_x_8_2BPP_4_color::@24->printf_str]
    // [318] phi printf_str::s#124 = string_3 [phi:tile_8_x_8_2BPP_4_color::@24->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_3
    sta.z printf_str.s
    lda #>string_3
    sta.z printf_str.s+1
    jsr printf_str
    // [842] phi from tile_8_x_8_2BPP_4_color::@24 to tile_8_x_8_2BPP_4_color::@25 [phi:tile_8_x_8_2BPP_4_color::@24->tile_8_x_8_2BPP_4_color::@25]
    // tile_8_x_8_2BPP_4_color::@25
    // printf("can be used per offset!\n")
    // [843] call printf_str
    // [318] phi from tile_8_x_8_2BPP_4_color::@25 to printf_str [phi:tile_8_x_8_2BPP_4_color::@25->printf_str]
    // [318] phi printf_str::s#124 = string_4 [phi:tile_8_x_8_2BPP_4_color::@25->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_4
    sta.z printf_str.s
    lda #>string_4
    sta.z printf_str.s+1
    jsr printf_str
    // [844] phi from tile_8_x_8_2BPP_4_color::@25 to tile_8_x_8_2BPP_4_color::@26 [phi:tile_8_x_8_2BPP_4_color::@25->tile_8_x_8_2BPP_4_color::@26]
    // tile_8_x_8_2BPP_4_color::@26
    // printf("however, the first color will always be transparent (black).\n")
    // [845] call printf_str
    // [318] phi from tile_8_x_8_2BPP_4_color::@26 to printf_str [phi:tile_8_x_8_2BPP_4_color::@26->printf_str]
    // [318] phi printf_str::s#124 = s7 [phi:tile_8_x_8_2BPP_4_color::@26->printf_str#0] -- pbuz1=pbuc1 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // [846] phi from tile_8_x_8_2BPP_4_color::@26 tile_8_x_8_2BPP_4_color::@27 to tile_8_x_8_2BPP_4_color::@4 [phi:tile_8_x_8_2BPP_4_color::@26/tile_8_x_8_2BPP_4_color::@27->tile_8_x_8_2BPP_4_color::@4]
    // tile_8_x_8_2BPP_4_color::@4
  __b4:
    // getin()
    // [847] call getin
    jsr getin
    // [848] getin::return#32 = getin::return#1
    // tile_8_x_8_2BPP_4_color::@27
    // [849] tile_8_x_8_2BPP_4_color::$27 = getin::return#32
    // while(!getin())
    // [850] if(0==tile_8_x_8_2BPP_4_color::$27) goto tile_8_x_8_2BPP_4_color::@4 -- 0_eq_vbuz1_then_la1 
    lda.z __27
    beq __b4
    // tile_8_x_8_2BPP_4_color::@return
    // }
    // [851] return 
    rts
  .segment Data
    tiles: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
}
.segment Code
  // text_8_x_8_1BPP_256_color
text_8_x_8_1BPP_256_color: {
    .const vera_layer_show1_layer = 1
    .label __16 = $66
    .label c = $bf
    // vera_layer_mode_text( 1, 0x00000, 0x0F800, 128, 128, 8, 8, 256 )
    // [853] call vera_layer_mode_text
  // Configure the VERA card to work in text, 256 mode.
  // The color mode is here 256 colors, (256 foreground on a black transparent background).
    // [185] phi from text_8_x_8_1BPP_256_color to vera_layer_mode_text [phi:text_8_x_8_1BPP_256_color->vera_layer_mode_text]
    // [185] phi vera_layer_mode_text::color_mode#11 = $100 [phi:text_8_x_8_1BPP_256_color->vera_layer_mode_text#0] -- vwuz1=vwuc1 
    lda #<$100
    sta.z vera_layer_mode_text.color_mode
    lda #>$100
    sta.z vera_layer_mode_text.color_mode+1
    // [185] phi vera_layer_mode_text::mapheight#11 = $80 [phi:text_8_x_8_1BPP_256_color->vera_layer_mode_text#1] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapheight
    lda #>$80
    sta.z vera_layer_mode_text.mapheight+1
    // [185] phi vera_layer_mode_text::mapwidth#11 = $80 [phi:text_8_x_8_1BPP_256_color->vera_layer_mode_text#2] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapwidth
    lda #>$80
    sta.z vera_layer_mode_text.mapwidth+1
    jsr vera_layer_mode_text
    // text_8_x_8_1BPP_256_color::vera_display_set_scale_none1
    // *VERA_DC_HSCALE = 128
    // [854] *VERA_DC_HSCALE = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 128
    // [855] *VERA_DC_VSCALE = $80 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // [856] phi from text_8_x_8_1BPP_256_color::vera_display_set_scale_none1 to text_8_x_8_1BPP_256_color::@3 [phi:text_8_x_8_1BPP_256_color::vera_display_set_scale_none1->text_8_x_8_1BPP_256_color::@3]
    // text_8_x_8_1BPP_256_color::@3
    // screenlayer(1)
    // [857] call screenlayer
    jsr screenlayer
    // [858] phi from text_8_x_8_1BPP_256_color::@3 to text_8_x_8_1BPP_256_color::@1 [phi:text_8_x_8_1BPP_256_color::@3->text_8_x_8_1BPP_256_color::@1]
    // [858] phi text_8_x_8_1BPP_256_color::c#2 = 0 [phi:text_8_x_8_1BPP_256_color::@3->text_8_x_8_1BPP_256_color::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // [858] phi from text_8_x_8_1BPP_256_color::@6 to text_8_x_8_1BPP_256_color::@1 [phi:text_8_x_8_1BPP_256_color::@6->text_8_x_8_1BPP_256_color::@1]
    // [858] phi text_8_x_8_1BPP_256_color::c#2 = text_8_x_8_1BPP_256_color::c#1 [phi:text_8_x_8_1BPP_256_color::@6->text_8_x_8_1BPP_256_color::@1#0] -- register_copy 
    // text_8_x_8_1BPP_256_color::@1
  __b1:
    // textcolor(c)
    // [859] textcolor::color#10 = text_8_x_8_1BPP_256_color::c#2 -- vbuz1=vbuz2 
    lda.z c
    sta.z textcolor.color
    // [860] call textcolor
    // [274] phi from text_8_x_8_1BPP_256_color::@1 to textcolor [phi:text_8_x_8_1BPP_256_color::@1->textcolor]
    // [274] phi textcolor::color#38 = textcolor::color#10 [phi:text_8_x_8_1BPP_256_color::@1->textcolor#0] -- register_copy 
    jsr textcolor
    // [861] phi from text_8_x_8_1BPP_256_color::@1 to text_8_x_8_1BPP_256_color::@5 [phi:text_8_x_8_1BPP_256_color::@1->text_8_x_8_1BPP_256_color::@5]
    // text_8_x_8_1BPP_256_color::@5
    // printf(" ****** ")
    // [862] call printf_str
    // [318] phi from text_8_x_8_1BPP_256_color::@5 to printf_str [phi:text_8_x_8_1BPP_256_color::@5->printf_str]
    // [318] phi printf_str::s#124 = text_8_x_8_1BPP_256_color::s [phi:text_8_x_8_1BPP_256_color::@5->printf_str#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // text_8_x_8_1BPP_256_color::@6
    // for(byte c:0..255)
    // [863] text_8_x_8_1BPP_256_color::c#1 = ++ text_8_x_8_1BPP_256_color::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [864] if(text_8_x_8_1BPP_256_color::c#1!=0) goto text_8_x_8_1BPP_256_color::@1 -- vbuz1_neq_0_then_la1 
    lda.z c
    bne __b1
    // text_8_x_8_1BPP_256_color::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [865] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [866] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *(vera_layer_enable+text_8_x_8_1BPP_256_color::vera_layer_show1_layer#0) -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable+vera_layer_show1_layer
    sta VERA_DC_VIDEO
    // [867] phi from text_8_x_8_1BPP_256_color::vera_layer_show1 to text_8_x_8_1BPP_256_color::@4 [phi:text_8_x_8_1BPP_256_color::vera_layer_show1->text_8_x_8_1BPP_256_color::@4]
    // text_8_x_8_1BPP_256_color::@4
    // gotoxy(0,50)
    // [868] call gotoxy
    // [242] phi from text_8_x_8_1BPP_256_color::@4 to gotoxy [phi:text_8_x_8_1BPP_256_color::@4->gotoxy]
    // [242] phi gotoxy::y#35 = $32 [phi:text_8_x_8_1BPP_256_color::@4->gotoxy#0] -- vbuz1=vbuc1 
    lda #$32
    sta.z gotoxy.y
    jsr gotoxy
    // [869] phi from text_8_x_8_1BPP_256_color::@4 to text_8_x_8_1BPP_256_color::@7 [phi:text_8_x_8_1BPP_256_color::@4->text_8_x_8_1BPP_256_color::@7]
    // text_8_x_8_1BPP_256_color::@7
    // textcolor(WHITE)
    // [870] call textcolor
    // [274] phi from text_8_x_8_1BPP_256_color::@7 to textcolor [phi:text_8_x_8_1BPP_256_color::@7->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:text_8_x_8_1BPP_256_color::@7->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [871] phi from text_8_x_8_1BPP_256_color::@7 to text_8_x_8_1BPP_256_color::@8 [phi:text_8_x_8_1BPP_256_color::@7->text_8_x_8_1BPP_256_color::@8]
    // text_8_x_8_1BPP_256_color::@8
    // bgcolor(BLACK)
    // [872] call bgcolor
    // [279] phi from text_8_x_8_1BPP_256_color::@8 to bgcolor [phi:text_8_x_8_1BPP_256_color::@8->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:text_8_x_8_1BPP_256_color::@8->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [873] phi from text_8_x_8_1BPP_256_color::@8 to text_8_x_8_1BPP_256_color::@9 [phi:text_8_x_8_1BPP_256_color::@8->text_8_x_8_1BPP_256_color::@9]
    // text_8_x_8_1BPP_256_color::@9
    // printf("vera in text mode 8 x 8, color depth 1 bits per pixel.\n")
    // [874] call printf_str
    // [318] phi from text_8_x_8_1BPP_256_color::@9 to printf_str [phi:text_8_x_8_1BPP_256_color::@9->printf_str]
    // [318] phi printf_str::s#124 = string_5 [phi:text_8_x_8_1BPP_256_color::@9->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_5
    sta.z printf_str.s
    lda #>string_5
    sta.z printf_str.s+1
    jsr printf_str
    // [875] phi from text_8_x_8_1BPP_256_color::@9 to text_8_x_8_1BPP_256_color::@10 [phi:text_8_x_8_1BPP_256_color::@9->text_8_x_8_1BPP_256_color::@10]
    // text_8_x_8_1BPP_256_color::@10
    // printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n")
    // [876] call printf_str
    // [318] phi from text_8_x_8_1BPP_256_color::@10 to printf_str [phi:text_8_x_8_1BPP_256_color::@10->printf_str]
    // [318] phi printf_str::s#124 = s1 [phi:text_8_x_8_1BPP_256_color::@10->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [877] phi from text_8_x_8_1BPP_256_color::@10 to text_8_x_8_1BPP_256_color::@11 [phi:text_8_x_8_1BPP_256_color::@10->text_8_x_8_1BPP_256_color::@11]
    // text_8_x_8_1BPP_256_color::@11
    // printf("each character can have a variation of 256 foreground colors.\n")
    // [878] call printf_str
    // [318] phi from text_8_x_8_1BPP_256_color::@11 to printf_str [phi:text_8_x_8_1BPP_256_color::@11->printf_str]
    // [318] phi printf_str::s#124 = text_8_x_8_1BPP_256_color::s3 [phi:text_8_x_8_1BPP_256_color::@11->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // [879] phi from text_8_x_8_1BPP_256_color::@11 to text_8_x_8_1BPP_256_color::@12 [phi:text_8_x_8_1BPP_256_color::@11->text_8_x_8_1BPP_256_color::@12]
    // text_8_x_8_1BPP_256_color::@12
    // printf("here we display 6 stars (******) each with a different color.\n")
    // [880] call printf_str
    // [318] phi from text_8_x_8_1BPP_256_color::@12 to printf_str [phi:text_8_x_8_1BPP_256_color::@12->printf_str]
    // [318] phi printf_str::s#124 = string_6 [phi:text_8_x_8_1BPP_256_color::@12->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_6
    sta.z printf_str.s
    lda #>string_6
    sta.z printf_str.s+1
    jsr printf_str
    // [881] phi from text_8_x_8_1BPP_256_color::@12 to text_8_x_8_1BPP_256_color::@13 [phi:text_8_x_8_1BPP_256_color::@12->text_8_x_8_1BPP_256_color::@13]
    // text_8_x_8_1BPP_256_color::@13
    // printf("however, the first color will always be transparent (black).\n")
    // [882] call printf_str
    // [318] phi from text_8_x_8_1BPP_256_color::@13 to printf_str [phi:text_8_x_8_1BPP_256_color::@13->printf_str]
    // [318] phi printf_str::s#124 = s7 [phi:text_8_x_8_1BPP_256_color::@13->printf_str#0] -- pbuz1=pbuc1 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // [883] phi from text_8_x_8_1BPP_256_color::@13 to text_8_x_8_1BPP_256_color::@14 [phi:text_8_x_8_1BPP_256_color::@13->text_8_x_8_1BPP_256_color::@14]
    // text_8_x_8_1BPP_256_color::@14
    // printf("in this mode, the background color cannot be set and is always transparent.\n")
    // [884] call printf_str
    // [318] phi from text_8_x_8_1BPP_256_color::@14 to printf_str [phi:text_8_x_8_1BPP_256_color::@14->printf_str]
    // [318] phi printf_str::s#124 = string_7 [phi:text_8_x_8_1BPP_256_color::@14->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_7
    sta.z printf_str.s
    lda #>string_7
    sta.z printf_str.s+1
    jsr printf_str
    // [885] phi from text_8_x_8_1BPP_256_color::@14 text_8_x_8_1BPP_256_color::@15 to text_8_x_8_1BPP_256_color::@2 [phi:text_8_x_8_1BPP_256_color::@14/text_8_x_8_1BPP_256_color::@15->text_8_x_8_1BPP_256_color::@2]
    // text_8_x_8_1BPP_256_color::@2
  __b2:
    // getin()
    // [886] call getin
    jsr getin
    // [887] getin::return#10 = getin::return#1
    // text_8_x_8_1BPP_256_color::@15
    // [888] text_8_x_8_1BPP_256_color::$16 = getin::return#10
    // while(!getin())
    // [889] if(0==text_8_x_8_1BPP_256_color::$16) goto text_8_x_8_1BPP_256_color::@2 -- 0_eq_vbuz1_then_la1 
    lda.z __16
    beq __b2
    // text_8_x_8_1BPP_256_color::@return
    // }
    // [890] return 
    rts
  .segment Data
    s: .text " ****** "
    .byte 0
    s3: .text @"each character can have a variation of 256 foreground colors.\n"
    .byte 0
}
.segment Code
  // text_8_x_8_1BPP_16_color
text_8_x_8_1BPP_16_color: {
    .const vera_layer_show1_layer = 1
    .label __19 = $66
    .label c = $ba
    // vera_layer_mode_text(1, 0x00000, 0x0F800, 128, 128, 8, 8, 16)
    // [892] call vera_layer_mode_text
  // Configure the VERA card to work in text.
  // The color mode is here 16 colors, (16 foreground and 16 background colors).
    // [185] phi from text_8_x_8_1BPP_16_color to vera_layer_mode_text [phi:text_8_x_8_1BPP_16_color->vera_layer_mode_text]
    // [185] phi vera_layer_mode_text::color_mode#11 = $10 [phi:text_8_x_8_1BPP_16_color->vera_layer_mode_text#0] -- vwuz1=vbuc1 
    lda #<$10
    sta.z vera_layer_mode_text.color_mode
    lda #>$10
    sta.z vera_layer_mode_text.color_mode+1
    // [185] phi vera_layer_mode_text::mapheight#11 = $80 [phi:text_8_x_8_1BPP_16_color->vera_layer_mode_text#1] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapheight
    lda #>$80
    sta.z vera_layer_mode_text.mapheight+1
    // [185] phi vera_layer_mode_text::mapwidth#11 = $80 [phi:text_8_x_8_1BPP_16_color->vera_layer_mode_text#2] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_text.mapwidth
    lda #>$80
    sta.z vera_layer_mode_text.mapwidth+1
    jsr vera_layer_mode_text
    // text_8_x_8_1BPP_16_color::vera_display_set_scale_none1
    // *VERA_DC_HSCALE = 128
    // [893] *VERA_DC_HSCALE = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 128
    // [894] *VERA_DC_VSCALE = $80 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // [895] phi from text_8_x_8_1BPP_16_color::vera_display_set_scale_none1 to text_8_x_8_1BPP_16_color::@3 [phi:text_8_x_8_1BPP_16_color::vera_display_set_scale_none1->text_8_x_8_1BPP_16_color::@3]
    // text_8_x_8_1BPP_16_color::@3
    // screenlayer(1)
    // [896] call screenlayer
    jsr screenlayer
    // [897] phi from text_8_x_8_1BPP_16_color::@3 to text_8_x_8_1BPP_16_color::@5 [phi:text_8_x_8_1BPP_16_color::@3->text_8_x_8_1BPP_16_color::@5]
    // text_8_x_8_1BPP_16_color::@5
    // textcolor(WHITE)
    // [898] call textcolor
    // [274] phi from text_8_x_8_1BPP_16_color::@5 to textcolor [phi:text_8_x_8_1BPP_16_color::@5->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:text_8_x_8_1BPP_16_color::@5->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [899] phi from text_8_x_8_1BPP_16_color::@5 to text_8_x_8_1BPP_16_color::@6 [phi:text_8_x_8_1BPP_16_color::@5->text_8_x_8_1BPP_16_color::@6]
    // text_8_x_8_1BPP_16_color::@6
    // bgcolor(BLACK)
    // [900] call bgcolor
    // [279] phi from text_8_x_8_1BPP_16_color::@6 to bgcolor [phi:text_8_x_8_1BPP_16_color::@6->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:text_8_x_8_1BPP_16_color::@6->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [901] phi from text_8_x_8_1BPP_16_color::@6 to text_8_x_8_1BPP_16_color::@7 [phi:text_8_x_8_1BPP_16_color::@6->text_8_x_8_1BPP_16_color::@7]
    // text_8_x_8_1BPP_16_color::@7
    // clrscr()
    // [902] call clrscr
    jsr clrscr
    // [903] phi from text_8_x_8_1BPP_16_color::@7 to text_8_x_8_1BPP_16_color::@1 [phi:text_8_x_8_1BPP_16_color::@7->text_8_x_8_1BPP_16_color::@1]
    // [903] phi text_8_x_8_1BPP_16_color::c#2 = 0 [phi:text_8_x_8_1BPP_16_color::@7->text_8_x_8_1BPP_16_color::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // [903] phi from text_8_x_8_1BPP_16_color::@9 to text_8_x_8_1BPP_16_color::@1 [phi:text_8_x_8_1BPP_16_color::@9->text_8_x_8_1BPP_16_color::@1]
    // [903] phi text_8_x_8_1BPP_16_color::c#2 = text_8_x_8_1BPP_16_color::c#1 [phi:text_8_x_8_1BPP_16_color::@9->text_8_x_8_1BPP_16_color::@1#0] -- register_copy 
    // text_8_x_8_1BPP_16_color::@1
  __b1:
    // bgcolor(c)
    // [904] bgcolor::color#12 = text_8_x_8_1BPP_16_color::c#2 -- vbuz1=vbuz2 
    lda.z c
    sta.z bgcolor.color
    // [905] call bgcolor
    // [279] phi from text_8_x_8_1BPP_16_color::@1 to bgcolor [phi:text_8_x_8_1BPP_16_color::@1->bgcolor]
    // [279] phi bgcolor::color#26 = bgcolor::color#12 [phi:text_8_x_8_1BPP_16_color::@1->bgcolor#0] -- register_copy 
    jsr bgcolor
    // [906] phi from text_8_x_8_1BPP_16_color::@1 to text_8_x_8_1BPP_16_color::@8 [phi:text_8_x_8_1BPP_16_color::@1->text_8_x_8_1BPP_16_color::@8]
    // text_8_x_8_1BPP_16_color::@8
    // printf(" ++++++ ")
    // [907] call printf_str
    // [318] phi from text_8_x_8_1BPP_16_color::@8 to printf_str [phi:text_8_x_8_1BPP_16_color::@8->printf_str]
    // [318] phi printf_str::s#124 = text_8_x_8_1BPP_16_color::s [phi:text_8_x_8_1BPP_16_color::@8->printf_str#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // text_8_x_8_1BPP_16_color::@9
    // for(byte c:0..255)
    // [908] text_8_x_8_1BPP_16_color::c#1 = ++ text_8_x_8_1BPP_16_color::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [909] if(text_8_x_8_1BPP_16_color::c#1!=0) goto text_8_x_8_1BPP_16_color::@1 -- vbuz1_neq_0_then_la1 
    lda.z c
    bne __b1
    // text_8_x_8_1BPP_16_color::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [910] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [911] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *(vera_layer_enable+text_8_x_8_1BPP_16_color::vera_layer_show1_layer#0) -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable+vera_layer_show1_layer
    sta VERA_DC_VIDEO
    // [912] phi from text_8_x_8_1BPP_16_color::vera_layer_show1 to text_8_x_8_1BPP_16_color::@4 [phi:text_8_x_8_1BPP_16_color::vera_layer_show1->text_8_x_8_1BPP_16_color::@4]
    // text_8_x_8_1BPP_16_color::@4
    // gotoxy(0,50)
    // [913] call gotoxy
    // [242] phi from text_8_x_8_1BPP_16_color::@4 to gotoxy [phi:text_8_x_8_1BPP_16_color::@4->gotoxy]
    // [242] phi gotoxy::y#35 = $32 [phi:text_8_x_8_1BPP_16_color::@4->gotoxy#0] -- vbuz1=vbuc1 
    lda #$32
    sta.z gotoxy.y
    jsr gotoxy
    // [914] phi from text_8_x_8_1BPP_16_color::@4 to text_8_x_8_1BPP_16_color::@10 [phi:text_8_x_8_1BPP_16_color::@4->text_8_x_8_1BPP_16_color::@10]
    // text_8_x_8_1BPP_16_color::@10
    // textcolor(WHITE)
    // [915] call textcolor
    // [274] phi from text_8_x_8_1BPP_16_color::@10 to textcolor [phi:text_8_x_8_1BPP_16_color::@10->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:text_8_x_8_1BPP_16_color::@10->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [916] phi from text_8_x_8_1BPP_16_color::@10 to text_8_x_8_1BPP_16_color::@11 [phi:text_8_x_8_1BPP_16_color::@10->text_8_x_8_1BPP_16_color::@11]
    // text_8_x_8_1BPP_16_color::@11
    // bgcolor(BLACK)
    // [917] call bgcolor
    // [279] phi from text_8_x_8_1BPP_16_color::@11 to bgcolor [phi:text_8_x_8_1BPP_16_color::@11->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:text_8_x_8_1BPP_16_color::@11->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [918] phi from text_8_x_8_1BPP_16_color::@11 to text_8_x_8_1BPP_16_color::@12 [phi:text_8_x_8_1BPP_16_color::@11->text_8_x_8_1BPP_16_color::@12]
    // text_8_x_8_1BPP_16_color::@12
    // printf("vera in text mode 8 x 8, color depth 1 bits per pixel.\n")
    // [919] call printf_str
    // [318] phi from text_8_x_8_1BPP_16_color::@12 to printf_str [phi:text_8_x_8_1BPP_16_color::@12->printf_str]
    // [318] phi printf_str::s#124 = string_5 [phi:text_8_x_8_1BPP_16_color::@12->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_5
    sta.z printf_str.s
    lda #>string_5
    sta.z printf_str.s+1
    jsr printf_str
    // [920] phi from text_8_x_8_1BPP_16_color::@12 to text_8_x_8_1BPP_16_color::@13 [phi:text_8_x_8_1BPP_16_color::@12->text_8_x_8_1BPP_16_color::@13]
    // text_8_x_8_1BPP_16_color::@13
    // printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n")
    // [921] call printf_str
    // [318] phi from text_8_x_8_1BPP_16_color::@13 to printf_str [phi:text_8_x_8_1BPP_16_color::@13->printf_str]
    // [318] phi printf_str::s#124 = s1 [phi:text_8_x_8_1BPP_16_color::@13->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [922] phi from text_8_x_8_1BPP_16_color::@13 to text_8_x_8_1BPP_16_color::@14 [phi:text_8_x_8_1BPP_16_color::@13->text_8_x_8_1BPP_16_color::@14]
    // text_8_x_8_1BPP_16_color::@14
    // printf("each character can have a variation of 16 foreground colors and 16 background colors.\n")
    // [923] call printf_str
    // [318] phi from text_8_x_8_1BPP_16_color::@14 to printf_str [phi:text_8_x_8_1BPP_16_color::@14->printf_str]
    // [318] phi printf_str::s#124 = text_8_x_8_1BPP_16_color::s3 [phi:text_8_x_8_1BPP_16_color::@14->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // [924] phi from text_8_x_8_1BPP_16_color::@14 to text_8_x_8_1BPP_16_color::@15 [phi:text_8_x_8_1BPP_16_color::@14->text_8_x_8_1BPP_16_color::@15]
    // text_8_x_8_1BPP_16_color::@15
    // printf("here we display 6 stars (******) each with a different color.\n")
    // [925] call printf_str
    // [318] phi from text_8_x_8_1BPP_16_color::@15 to printf_str [phi:text_8_x_8_1BPP_16_color::@15->printf_str]
    // [318] phi printf_str::s#124 = string_6 [phi:text_8_x_8_1BPP_16_color::@15->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_6
    sta.z printf_str.s
    lda #>string_6
    sta.z printf_str.s+1
    jsr printf_str
    // [926] phi from text_8_x_8_1BPP_16_color::@15 to text_8_x_8_1BPP_16_color::@16 [phi:text_8_x_8_1BPP_16_color::@15->text_8_x_8_1BPP_16_color::@16]
    // text_8_x_8_1BPP_16_color::@16
    // printf("however, the first color will always be transparent (black).\n")
    // [927] call printf_str
    // [318] phi from text_8_x_8_1BPP_16_color::@16 to printf_str [phi:text_8_x_8_1BPP_16_color::@16->printf_str]
    // [318] phi printf_str::s#124 = s7 [phi:text_8_x_8_1BPP_16_color::@16->printf_str#0] -- pbuz1=pbuc1 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // [928] phi from text_8_x_8_1BPP_16_color::@16 to text_8_x_8_1BPP_16_color::@17 [phi:text_8_x_8_1BPP_16_color::@16->text_8_x_8_1BPP_16_color::@17]
    // text_8_x_8_1BPP_16_color::@17
    // printf("in this mode, the background color cannot be set and is always transparent.\n")
    // [929] call printf_str
    // [318] phi from text_8_x_8_1BPP_16_color::@17 to printf_str [phi:text_8_x_8_1BPP_16_color::@17->printf_str]
    // [318] phi printf_str::s#124 = string_7 [phi:text_8_x_8_1BPP_16_color::@17->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_7
    sta.z printf_str.s
    lda #>string_7
    sta.z printf_str.s+1
    jsr printf_str
    // [930] phi from text_8_x_8_1BPP_16_color::@17 text_8_x_8_1BPP_16_color::@18 to text_8_x_8_1BPP_16_color::@2 [phi:text_8_x_8_1BPP_16_color::@17/text_8_x_8_1BPP_16_color::@18->text_8_x_8_1BPP_16_color::@2]
    // text_8_x_8_1BPP_16_color::@2
  __b2:
    // getin()
    // [931] call getin
    jsr getin
    // [932] getin::return#11 = getin::return#1
    // text_8_x_8_1BPP_16_color::@18
    // [933] text_8_x_8_1BPP_16_color::$19 = getin::return#11
    // while(!getin())
    // [934] if(0==text_8_x_8_1BPP_16_color::$19) goto text_8_x_8_1BPP_16_color::@2 -- 0_eq_vbuz1_then_la1 
    lda.z __19
    beq __b2
    // text_8_x_8_1BPP_16_color::@return
    // }
    // [935] return 
    rts
  .segment Data
    s: .text " ++++++ "
    .byte 0
    s3: .text @"each character can have a variation of 16 foreground colors and 16 background colors.\n"
    .byte 0
}
.segment Code
  // bitmap_320_x_240_8BPP
bitmap_320_x_240_8BPP: {
    .label __27 = $66
    .label __37 = $53
    .label __40 = $66
    .label color = $7c
    .label x = $71
    // cx16_cpy_vram_from_vram(1, 0xF000, 0, 0xF800, 256*8)
    // [937] call cx16_cpy_vram_from_vram
  // Before we configure the bitmap pane into vera  memory we need to re-arrange a few things!
  // It is better to load all in bank 0, but then there is an issue.
  // So the default CX16 character set is located in bank 0, at address 0xF800.
  // So we need to move this character set to bank 1, suggested is at address 0xF000.
  // The CX16 by default writes textual output to layer 1 in text mode, so we need to
  // realign the moved character set to 0xf000 as the new tile base for layer 1.
  // We also will need to realign for layer 1 the map base from 0x00000 to 0x14000.
  // This is now all easily done with a few statements in the new kickc vera lib ...
    // [1674] phi from bitmap_320_x_240_8BPP to cx16_cpy_vram_from_vram [phi:bitmap_320_x_240_8BPP->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f000 [phi:bitmap_320_x_240_8BPP->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 1 [phi:bitmap_320_x_240_8BPP->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f800 [phi:bitmap_320_x_240_8BPP->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 0 [phi:bitmap_320_x_240_8BPP->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // [938] phi from bitmap_320_x_240_8BPP to bitmap_320_x_240_8BPP::@8 [phi:bitmap_320_x_240_8BPP->bitmap_320_x_240_8BPP::@8]
    // bitmap_320_x_240_8BPP::@8
    // vera_layer_mode_tile(1, 0x14000, 0x1F000, 128, 64, 8, 8, 1)
    // [939] call vera_layer_mode_tile
  // We copy the 128 character set of 8 bytes each.
    // [1580] phi from bitmap_320_x_240_8BPP::@8 to vera_layer_mode_tile [phi:bitmap_320_x_240_8BPP::@8->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = 8 [phi:bitmap_320_x_240_8BPP::@8->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = 8 [phi:bitmap_320_x_240_8BPP::@8->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $1f000 [phi:bitmap_320_x_240_8BPP::@8->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$1f000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$1f000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $14000 [phi:bitmap_320_x_240_8BPP::@8->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $40 [phi:bitmap_320_x_240_8BPP::@8->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 1 [phi:bitmap_320_x_240_8BPP::@8->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $80 [phi:bitmap_320_x_240_8BPP::@8->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 1 [phi:bitmap_320_x_240_8BPP::@8->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // [940] phi from bitmap_320_x_240_8BPP::@8 to bitmap_320_x_240_8BPP::@9 [phi:bitmap_320_x_240_8BPP::@8->bitmap_320_x_240_8BPP::@9]
    // bitmap_320_x_240_8BPP::@9
    // vera_layer_mode_bitmap(0, (dword)0x00000, 320, 8)
    // [941] call vera_layer_mode_bitmap
    // [1745] phi from bitmap_320_x_240_8BPP::@9 to vera_layer_mode_bitmap [phi:bitmap_320_x_240_8BPP::@9->vera_layer_mode_bitmap]
    // [1745] phi vera_layer_mode_bitmap::mapwidth#10 = $140 [phi:bitmap_320_x_240_8BPP::@9->vera_layer_mode_bitmap#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z vera_layer_mode_bitmap.mapwidth
    lda #>$140
    sta.z vera_layer_mode_bitmap.mapwidth+1
    // [1745] phi vera_layer_mode_bitmap::color_depth#6 = 8 [phi:bitmap_320_x_240_8BPP::@9->vera_layer_mode_bitmap#1] -- vwuz1=vbuc1 
    lda #<8
    sta.z vera_layer_mode_bitmap.color_depth
    lda #>8
    sta.z vera_layer_mode_bitmap.color_depth+1
    jsr vera_layer_mode_bitmap
    // [942] phi from bitmap_320_x_240_8BPP::@9 to bitmap_320_x_240_8BPP::@10 [phi:bitmap_320_x_240_8BPP::@9->bitmap_320_x_240_8BPP::@10]
    // bitmap_320_x_240_8BPP::@10
    // screenlayer(1)
    // [943] call screenlayer
    jsr screenlayer
    // [944] phi from bitmap_320_x_240_8BPP::@10 to bitmap_320_x_240_8BPP::@11 [phi:bitmap_320_x_240_8BPP::@10->bitmap_320_x_240_8BPP::@11]
    // bitmap_320_x_240_8BPP::@11
    // textcolor(WHITE)
    // [945] call textcolor
    // [274] phi from bitmap_320_x_240_8BPP::@11 to textcolor [phi:bitmap_320_x_240_8BPP::@11->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:bitmap_320_x_240_8BPP::@11->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [946] phi from bitmap_320_x_240_8BPP::@11 to bitmap_320_x_240_8BPP::@12 [phi:bitmap_320_x_240_8BPP::@11->bitmap_320_x_240_8BPP::@12]
    // bitmap_320_x_240_8BPP::@12
    // bgcolor(BLACK)
    // [947] call bgcolor
    // [279] phi from bitmap_320_x_240_8BPP::@12 to bgcolor [phi:bitmap_320_x_240_8BPP::@12->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:bitmap_320_x_240_8BPP::@12->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [948] phi from bitmap_320_x_240_8BPP::@12 to bitmap_320_x_240_8BPP::@13 [phi:bitmap_320_x_240_8BPP::@12->bitmap_320_x_240_8BPP::@13]
    // bitmap_320_x_240_8BPP::@13
    // clrscr()
    // [949] call clrscr
    jsr clrscr
    // [950] phi from bitmap_320_x_240_8BPP::@13 to bitmap_320_x_240_8BPP::@14 [phi:bitmap_320_x_240_8BPP::@13->bitmap_320_x_240_8BPP::@14]
    // bitmap_320_x_240_8BPP::@14
    // gotoxy(0,25)
    // [951] call gotoxy
    // [242] phi from bitmap_320_x_240_8BPP::@14 to gotoxy [phi:bitmap_320_x_240_8BPP::@14->gotoxy]
    // [242] phi gotoxy::y#35 = $19 [phi:bitmap_320_x_240_8BPP::@14->gotoxy#0] -- vbuz1=vbuc1 
    lda #$19
    sta.z gotoxy.y
    jsr gotoxy
    // [952] phi from bitmap_320_x_240_8BPP::@14 to bitmap_320_x_240_8BPP::@15 [phi:bitmap_320_x_240_8BPP::@14->bitmap_320_x_240_8BPP::@15]
    // bitmap_320_x_240_8BPP::@15
    // printf("vera in bitmap mode,\n")
    // [953] call printf_str
    // [318] phi from bitmap_320_x_240_8BPP::@15 to printf_str [phi:bitmap_320_x_240_8BPP::@15->printf_str]
    // [318] phi printf_str::s#124 = string_8 [phi:bitmap_320_x_240_8BPP::@15->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_8
    sta.z printf_str.s
    lda #>string_8
    sta.z printf_str.s+1
    jsr printf_str
    // [954] phi from bitmap_320_x_240_8BPP::@15 to bitmap_320_x_240_8BPP::@16 [phi:bitmap_320_x_240_8BPP::@15->bitmap_320_x_240_8BPP::@16]
    // bitmap_320_x_240_8BPP::@16
    // printf("color depth 8 bits per pixel.\n")
    // [955] call printf_str
    // [318] phi from bitmap_320_x_240_8BPP::@16 to printf_str [phi:bitmap_320_x_240_8BPP::@16->printf_str]
    // [318] phi printf_str::s#124 = bitmap_320_x_240_8BPP::s1 [phi:bitmap_320_x_240_8BPP::@16->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [956] phi from bitmap_320_x_240_8BPP::@16 to bitmap_320_x_240_8BPP::@17 [phi:bitmap_320_x_240_8BPP::@16->bitmap_320_x_240_8BPP::@17]
    // bitmap_320_x_240_8BPP::@17
    // printf("in this mode, it is possible to display\n")
    // [957] call printf_str
    // [318] phi from bitmap_320_x_240_8BPP::@17 to printf_str [phi:bitmap_320_x_240_8BPP::@17->printf_str]
    // [318] phi printf_str::s#124 = string_10 [phi:bitmap_320_x_240_8BPP::@17->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_10
    sta.z printf_str.s
    lda #>string_10
    sta.z printf_str.s+1
    jsr printf_str
    // [958] phi from bitmap_320_x_240_8BPP::@17 to bitmap_320_x_240_8BPP::@18 [phi:bitmap_320_x_240_8BPP::@17->bitmap_320_x_240_8BPP::@18]
    // bitmap_320_x_240_8BPP::@18
    // printf("graphics in 256 colors.\n")
    // [959] call printf_str
    // [318] phi from bitmap_320_x_240_8BPP::@18 to printf_str [phi:bitmap_320_x_240_8BPP::@18->printf_str]
    // [318] phi printf_str::s#124 = bitmap_320_x_240_8BPP::s3 [phi:bitmap_320_x_240_8BPP::@18->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // bitmap_320_x_240_8BPP::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [960] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [961] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [962] phi from bitmap_320_x_240_8BPP::vera_layer_show1 to bitmap_320_x_240_8BPP::@7 [phi:bitmap_320_x_240_8BPP::vera_layer_show1->bitmap_320_x_240_8BPP::@7]
    // bitmap_320_x_240_8BPP::@7
    // bitmap_init(0, 0x00000)
    // [963] call bitmap_init
    jsr bitmap_init
    // [964] phi from bitmap_320_x_240_8BPP::@7 to bitmap_320_x_240_8BPP::@19 [phi:bitmap_320_x_240_8BPP::@7->bitmap_320_x_240_8BPP::@19]
    // bitmap_320_x_240_8BPP::@19
    // bitmap_clear()
    // [965] call bitmap_clear
    jsr bitmap_clear
    // [966] phi from bitmap_320_x_240_8BPP::@19 to bitmap_320_x_240_8BPP::@20 [phi:bitmap_320_x_240_8BPP::@19->bitmap_320_x_240_8BPP::@20]
    // bitmap_320_x_240_8BPP::@20
    // gotoxy(0,29)
    // [967] call gotoxy
    // [242] phi from bitmap_320_x_240_8BPP::@20 to gotoxy [phi:bitmap_320_x_240_8BPP::@20->gotoxy]
    // [242] phi gotoxy::y#35 = $1d [phi:bitmap_320_x_240_8BPP::@20->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1d
    sta.z gotoxy.y
    jsr gotoxy
    // [968] phi from bitmap_320_x_240_8BPP::@20 to bitmap_320_x_240_8BPP::@21 [phi:bitmap_320_x_240_8BPP::@20->bitmap_320_x_240_8BPP::@21]
    // bitmap_320_x_240_8BPP::@21
    // textcolor(YELLOW)
    // [969] call textcolor
    // [274] phi from bitmap_320_x_240_8BPP::@21 to textcolor [phi:bitmap_320_x_240_8BPP::@21->textcolor]
    // [274] phi textcolor::color#38 = YELLOW [phi:bitmap_320_x_240_8BPP::@21->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [970] phi from bitmap_320_x_240_8BPP::@21 to bitmap_320_x_240_8BPP::@22 [phi:bitmap_320_x_240_8BPP::@21->bitmap_320_x_240_8BPP::@22]
    // bitmap_320_x_240_8BPP::@22
    // printf("press a key ...")
    // [971] call printf_str
    // [318] phi from bitmap_320_x_240_8BPP::@22 to printf_str [phi:bitmap_320_x_240_8BPP::@22->printf_str]
    // [318] phi printf_str::s#124 = string_12 [phi:bitmap_320_x_240_8BPP::@22->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_12
    sta.z printf_str.s
    lda #>string_12
    sta.z printf_str.s+1
    jsr printf_str
    // [972] phi from bitmap_320_x_240_8BPP::@22 bitmap_320_x_240_8BPP::@32 to bitmap_320_x_240_8BPP::@1 [phi:bitmap_320_x_240_8BPP::@22/bitmap_320_x_240_8BPP::@32->bitmap_320_x_240_8BPP::@1]
    // [972] phi rem16u#119 = rem16u#236 [phi:bitmap_320_x_240_8BPP::@22/bitmap_320_x_240_8BPP::@32->bitmap_320_x_240_8BPP::@1#0] -- register_copy 
    // [972] phi rand_state#112 = rand_state#246 [phi:bitmap_320_x_240_8BPP::@22/bitmap_320_x_240_8BPP::@32->bitmap_320_x_240_8BPP::@1#1] -- register_copy 
    // bitmap_320_x_240_8BPP::@1
  __b1:
    // getin()
    // [973] call getin
    jsr getin
    // [974] getin::return#22 = getin::return#1
    // bitmap_320_x_240_8BPP::@23
    // [975] bitmap_320_x_240_8BPP::$27 = getin::return#22
    // while(!getin())
    // [976] if(0==bitmap_320_x_240_8BPP::$27) goto bitmap_320_x_240_8BPP::@2 -- 0_eq_vbuz1_then_la1 
    lda.z __27
    bne !__b2+
    jmp __b2
  !__b2:
    // [977] phi from bitmap_320_x_240_8BPP::@23 to bitmap_320_x_240_8BPP::@3 [phi:bitmap_320_x_240_8BPP::@23->bitmap_320_x_240_8BPP::@3]
    // bitmap_320_x_240_8BPP::@3
    // textcolor(WHITE)
    // [978] call textcolor
    // [274] phi from bitmap_320_x_240_8BPP::@3 to textcolor [phi:bitmap_320_x_240_8BPP::@3->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:bitmap_320_x_240_8BPP::@3->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [979] phi from bitmap_320_x_240_8BPP::@3 to bitmap_320_x_240_8BPP::@33 [phi:bitmap_320_x_240_8BPP::@3->bitmap_320_x_240_8BPP::@33]
    // bitmap_320_x_240_8BPP::@33
    // bgcolor(BLACK)
    // [980] call bgcolor
    // [279] phi from bitmap_320_x_240_8BPP::@33 to bgcolor [phi:bitmap_320_x_240_8BPP::@33->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:bitmap_320_x_240_8BPP::@33->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [981] phi from bitmap_320_x_240_8BPP::@33 to bitmap_320_x_240_8BPP::@34 [phi:bitmap_320_x_240_8BPP::@33->bitmap_320_x_240_8BPP::@34]
    // bitmap_320_x_240_8BPP::@34
    // clrscr()
    // [982] call clrscr
    jsr clrscr
    // [983] phi from bitmap_320_x_240_8BPP::@34 to bitmap_320_x_240_8BPP::@35 [phi:bitmap_320_x_240_8BPP::@34->bitmap_320_x_240_8BPP::@35]
    // bitmap_320_x_240_8BPP::@35
    // gotoxy(0,26)
    // [984] call gotoxy
    // [242] phi from bitmap_320_x_240_8BPP::@35 to gotoxy [phi:bitmap_320_x_240_8BPP::@35->gotoxy]
    // [242] phi gotoxy::y#35 = $1a [phi:bitmap_320_x_240_8BPP::@35->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1a
    sta.z gotoxy.y
    jsr gotoxy
    // [985] phi from bitmap_320_x_240_8BPP::@35 to bitmap_320_x_240_8BPP::@36 [phi:bitmap_320_x_240_8BPP::@35->bitmap_320_x_240_8BPP::@36]
    // bitmap_320_x_240_8BPP::@36
    // printf("here you see all the colors possible.\n")
    // [986] call printf_str
    // [318] phi from bitmap_320_x_240_8BPP::@36 to printf_str [phi:bitmap_320_x_240_8BPP::@36->printf_str]
    // [318] phi printf_str::s#124 = string_13 [phi:bitmap_320_x_240_8BPP::@36->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_13
    sta.z printf_str.s
    lda #>string_13
    sta.z printf_str.s+1
    jsr printf_str
    // [987] phi from bitmap_320_x_240_8BPP::@36 to bitmap_320_x_240_8BPP::@37 [phi:bitmap_320_x_240_8BPP::@36->bitmap_320_x_240_8BPP::@37]
    // bitmap_320_x_240_8BPP::@37
    // gotoxy(0,29)
    // [988] call gotoxy
    // [242] phi from bitmap_320_x_240_8BPP::@37 to gotoxy [phi:bitmap_320_x_240_8BPP::@37->gotoxy]
    // [242] phi gotoxy::y#35 = $1d [phi:bitmap_320_x_240_8BPP::@37->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1d
    sta.z gotoxy.y
    jsr gotoxy
    // [989] phi from bitmap_320_x_240_8BPP::@37 to bitmap_320_x_240_8BPP::@38 [phi:bitmap_320_x_240_8BPP::@37->bitmap_320_x_240_8BPP::@38]
    // bitmap_320_x_240_8BPP::@38
    // textcolor(YELLOW)
    // [990] call textcolor
    // [274] phi from bitmap_320_x_240_8BPP::@38 to textcolor [phi:bitmap_320_x_240_8BPP::@38->textcolor]
    // [274] phi textcolor::color#38 = YELLOW [phi:bitmap_320_x_240_8BPP::@38->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [991] phi from bitmap_320_x_240_8BPP::@38 to bitmap_320_x_240_8BPP::@39 [phi:bitmap_320_x_240_8BPP::@38->bitmap_320_x_240_8BPP::@39]
    // bitmap_320_x_240_8BPP::@39
    // printf("press a key ...")
    // [992] call printf_str
    // [318] phi from bitmap_320_x_240_8BPP::@39 to printf_str [phi:bitmap_320_x_240_8BPP::@39->printf_str]
    // [318] phi printf_str::s#124 = string_12 [phi:bitmap_320_x_240_8BPP::@39->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_12
    sta.z printf_str.s
    lda #>string_12
    sta.z printf_str.s+1
    jsr printf_str
    // [993] phi from bitmap_320_x_240_8BPP::@39 to bitmap_320_x_240_8BPP::@4 [phi:bitmap_320_x_240_8BPP::@39->bitmap_320_x_240_8BPP::@4]
    // [993] phi bitmap_320_x_240_8BPP::color#2 = 0 [phi:bitmap_320_x_240_8BPP::@39->bitmap_320_x_240_8BPP::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [993] phi bitmap_320_x_240_8BPP::x#3 = 0 [phi:bitmap_320_x_240_8BPP::@39->bitmap_320_x_240_8BPP::@4#1] -- vwuz1=vwuc1 
    sta.z x
    sta.z x+1
    // bitmap_320_x_240_8BPP::@4
  __b4:
    // getin()
    // [994] call getin
    jsr getin
    // [995] getin::return#23 = getin::return#1
    // bitmap_320_x_240_8BPP::@40
    // [996] bitmap_320_x_240_8BPP::$40 = getin::return#23
    // while(!getin())
    // [997] if(0==bitmap_320_x_240_8BPP::$40) goto bitmap_320_x_240_8BPP::@5 -- 0_eq_vbuz1_then_la1 
    lda.z __40
    beq __b5
    // [998] phi from bitmap_320_x_240_8BPP::@40 to bitmap_320_x_240_8BPP::@6 [phi:bitmap_320_x_240_8BPP::@40->bitmap_320_x_240_8BPP::@6]
    // bitmap_320_x_240_8BPP::@6
    // cx16_cpy_vram_from_vram(0, 0xF800, 1, 0xF000, 256*8)
    // [999] call cx16_cpy_vram_from_vram
    // [1674] phi from bitmap_320_x_240_8BPP::@6 to cx16_cpy_vram_from_vram [phi:bitmap_320_x_240_8BPP::@6->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f800 [phi:bitmap_320_x_240_8BPP::@6->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 0 [phi:bitmap_320_x_240_8BPP::@6->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f000 [phi:bitmap_320_x_240_8BPP::@6->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:bitmap_320_x_240_8BPP::@6->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // bitmap_320_x_240_8BPP::@return
    // }
    // [1000] return 
    rts
    // bitmap_320_x_240_8BPP::@5
  __b5:
    // bitmap_line(x, x, 0, 199, color)
    // [1001] bitmap_line::x0#11 = bitmap_320_x_240_8BPP::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x0
    lda.z x+1
    sta.z bitmap_line.x0+1
    // [1002] bitmap_line::x1#11 = bitmap_320_x_240_8BPP::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x1
    lda.z x+1
    sta.z bitmap_line.x1+1
    // [1003] bitmap_line::c#11 = bitmap_320_x_240_8BPP::color#2 -- vbuz1=vbuz2 
    lda.z color
    sta.z bitmap_line.c
    // [1004] call bitmap_line
    // [1874] phi from bitmap_320_x_240_8BPP::@5 to bitmap_line [phi:bitmap_320_x_240_8BPP::@5->bitmap_line]
    // [1874] phi bitmap_line::c#12 = bitmap_line::c#11 [phi:bitmap_320_x_240_8BPP::@5->bitmap_line#0] -- register_copy 
    // [1874] phi bitmap_line::y1#12 = $c7 [phi:bitmap_320_x_240_8BPP::@5->bitmap_line#1] -- vwuz1=vbuc1 
    lda #<$c7
    sta.z bitmap_line.y1
    lda #>$c7
    sta.z bitmap_line.y1+1
    // [1874] phi bitmap_line::y0#12 = 0 [phi:bitmap_320_x_240_8BPP::@5->bitmap_line#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z bitmap_line.y0
    sta.z bitmap_line.y0+1
    // [1874] phi bitmap_line::x1#12 = bitmap_line::x1#11 [phi:bitmap_320_x_240_8BPP::@5->bitmap_line#3] -- register_copy 
    // [1874] phi bitmap_line::x0#12 = bitmap_line::x0#11 [phi:bitmap_320_x_240_8BPP::@5->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    // bitmap_320_x_240_8BPP::@41
    // color++;
    // [1005] bitmap_320_x_240_8BPP::color#1 = ++ bitmap_320_x_240_8BPP::color#2 -- vbuz1=_inc_vbuz1 
    inc.z color
    // x++;
    // [1006] bitmap_320_x_240_8BPP::x#1 = ++ bitmap_320_x_240_8BPP::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // if(x>319)
    // [1007] if(bitmap_320_x_240_8BPP::x#1<=$13f) goto bitmap_320_x_240_8BPP::@42 -- vwuz1_le_vwuc1_then_la1 
    lda.z x+1
    cmp #>$13f
    bne !+
    lda.z x
    cmp #<$13f
  !:
    bcc __b4
    beq __b4
    // [993] phi from bitmap_320_x_240_8BPP::@41 to bitmap_320_x_240_8BPP::@4 [phi:bitmap_320_x_240_8BPP::@41->bitmap_320_x_240_8BPP::@4]
    // [993] phi bitmap_320_x_240_8BPP::color#2 = bitmap_320_x_240_8BPP::color#1 [phi:bitmap_320_x_240_8BPP::@41->bitmap_320_x_240_8BPP::@4#0] -- register_copy 
    // [993] phi bitmap_320_x_240_8BPP::x#3 = 0 [phi:bitmap_320_x_240_8BPP::@41->bitmap_320_x_240_8BPP::@4#1] -- vwuz1=vbuc1 
    lda #<0
    sta.z x
    sta.z x+1
    jmp __b4
    // [1008] phi from bitmap_320_x_240_8BPP::@41 to bitmap_320_x_240_8BPP::@42 [phi:bitmap_320_x_240_8BPP::@41->bitmap_320_x_240_8BPP::@42]
    // bitmap_320_x_240_8BPP::@42
    // [993] phi from bitmap_320_x_240_8BPP::@42 to bitmap_320_x_240_8BPP::@4 [phi:bitmap_320_x_240_8BPP::@42->bitmap_320_x_240_8BPP::@4]
    // [993] phi bitmap_320_x_240_8BPP::color#2 = bitmap_320_x_240_8BPP::color#1 [phi:bitmap_320_x_240_8BPP::@42->bitmap_320_x_240_8BPP::@4#0] -- register_copy 
    // [993] phi bitmap_320_x_240_8BPP::x#3 = bitmap_320_x_240_8BPP::x#1 [phi:bitmap_320_x_240_8BPP::@42->bitmap_320_x_240_8BPP::@4#1] -- register_copy 
    // [1009] phi from bitmap_320_x_240_8BPP::@23 to bitmap_320_x_240_8BPP::@2 [phi:bitmap_320_x_240_8BPP::@23->bitmap_320_x_240_8BPP::@2]
    // bitmap_320_x_240_8BPP::@2
  __b2:
    // rand()
    // [1010] call rand
    // [1945] phi from bitmap_320_x_240_8BPP::@2 to rand [phi:bitmap_320_x_240_8BPP::@2->rand]
    // [1945] phi rand_state#50 = rand_state#112 [phi:bitmap_320_x_240_8BPP::@2->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1011] rand::return#27 = rand::return#0
    // bitmap_320_x_240_8BPP::@24
    // modr16u(rand(),320,0)
    // [1012] modr16u::dividend#20 = rand::return#27
    // [1013] call modr16u
    // [1954] phi from bitmap_320_x_240_8BPP::@24 to modr16u [phi:bitmap_320_x_240_8BPP::@24->modr16u]
    // [1954] phi modr16u::divisor#24 = $140 [phi:bitmap_320_x_240_8BPP::@24->modr16u#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z modr16u.divisor
    lda #>$140
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#20 [phi:bitmap_320_x_240_8BPP::@24->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),320,0)
    // [1014] modr16u::return#22 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_1
    lda.z modr16u.return+1
    sta.z modr16u.return_1+1
    // bitmap_320_x_240_8BPP::@25
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&255)
    // [1015] bitmap_line::x0#10 = modr16u::return#22
    // rand()
    // [1016] call rand
    // [1945] phi from bitmap_320_x_240_8BPP::@25 to rand [phi:bitmap_320_x_240_8BPP::@25->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_8BPP::@25->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1017] rand::return#28 = rand::return#0
    // bitmap_320_x_240_8BPP::@26
    // modr16u(rand(),320,0)
    // [1018] modr16u::dividend#21 = rand::return#28
    // [1019] call modr16u
    // [1954] phi from bitmap_320_x_240_8BPP::@26 to modr16u [phi:bitmap_320_x_240_8BPP::@26->modr16u]
    // [1954] phi modr16u::divisor#24 = $140 [phi:bitmap_320_x_240_8BPP::@26->modr16u#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z modr16u.divisor
    lda #>$140
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#21 [phi:bitmap_320_x_240_8BPP::@26->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),320,0)
    // [1020] modr16u::return#23 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_2
    lda.z modr16u.return+1
    sta.z modr16u.return_2+1
    // bitmap_320_x_240_8BPP::@27
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&255)
    // [1021] bitmap_line::x1#10 = modr16u::return#23
    // rand()
    // [1022] call rand
    // [1945] phi from bitmap_320_x_240_8BPP::@27 to rand [phi:bitmap_320_x_240_8BPP::@27->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_8BPP::@27->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1023] rand::return#29 = rand::return#0
    // bitmap_320_x_240_8BPP::@28
    // modr16u(rand(),200,0)
    // [1024] modr16u::dividend#22 = rand::return#29
    // [1025] call modr16u
    // [1954] phi from bitmap_320_x_240_8BPP::@28 to modr16u [phi:bitmap_320_x_240_8BPP::@28->modr16u]
    // [1954] phi modr16u::divisor#24 = $c8 [phi:bitmap_320_x_240_8BPP::@28->modr16u#0] -- vwuz1=vbuc1 
    lda #<$c8
    sta.z modr16u.divisor
    lda #>$c8
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#22 [phi:bitmap_320_x_240_8BPP::@28->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),200,0)
    // [1026] modr16u::return#24 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_3
    lda.z modr16u.return+1
    sta.z modr16u.return_3+1
    // bitmap_320_x_240_8BPP::@29
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&255)
    // [1027] bitmap_line::y0#10 = modr16u::return#24
    // rand()
    // [1028] call rand
    // [1945] phi from bitmap_320_x_240_8BPP::@29 to rand [phi:bitmap_320_x_240_8BPP::@29->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_8BPP::@29->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1029] rand::return#30 = rand::return#0
    // bitmap_320_x_240_8BPP::@30
    // modr16u(rand(),200,0)
    // [1030] modr16u::dividend#23 = rand::return#30
    // [1031] call modr16u
    // [1954] phi from bitmap_320_x_240_8BPP::@30 to modr16u [phi:bitmap_320_x_240_8BPP::@30->modr16u]
    // [1954] phi modr16u::divisor#24 = $c8 [phi:bitmap_320_x_240_8BPP::@30->modr16u#0] -- vwuz1=vbuc1 
    lda #<$c8
    sta.z modr16u.divisor
    lda #>$c8
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#23 [phi:bitmap_320_x_240_8BPP::@30->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),200,0)
    // [1032] modr16u::return#25 = modr16u::return#0
    // bitmap_320_x_240_8BPP::@31
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&255)
    // [1033] bitmap_line::y1#10 = modr16u::return#25
    // rand()
    // [1034] call rand
    // [1945] phi from bitmap_320_x_240_8BPP::@31 to rand [phi:bitmap_320_x_240_8BPP::@31->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_8BPP::@31->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1035] rand::return#31 = rand::return#0
    // bitmap_320_x_240_8BPP::@32
    // [1036] bitmap_320_x_240_8BPP::$37 = rand::return#31
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&255)
    // [1037] bitmap_line::c#10 = bitmap_320_x_240_8BPP::$37 & $ff -- vbuz1=vwuz2_band_vbuc1 
    lda #$ff
    and.z __37
    sta.z bitmap_line.c
    // [1038] call bitmap_line
    // [1874] phi from bitmap_320_x_240_8BPP::@32 to bitmap_line [phi:bitmap_320_x_240_8BPP::@32->bitmap_line]
    // [1874] phi bitmap_line::c#12 = bitmap_line::c#10 [phi:bitmap_320_x_240_8BPP::@32->bitmap_line#0] -- register_copy 
    // [1874] phi bitmap_line::y1#12 = bitmap_line::y1#10 [phi:bitmap_320_x_240_8BPP::@32->bitmap_line#1] -- register_copy 
    // [1874] phi bitmap_line::y0#12 = bitmap_line::y0#10 [phi:bitmap_320_x_240_8BPP::@32->bitmap_line#2] -- register_copy 
    // [1874] phi bitmap_line::x1#12 = bitmap_line::x1#10 [phi:bitmap_320_x_240_8BPP::@32->bitmap_line#3] -- register_copy 
    // [1874] phi bitmap_line::x0#12 = bitmap_line::x0#10 [phi:bitmap_320_x_240_8BPP::@32->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    jmp __b1
  .segment Data
    s1: .text @"color depth 8 bits per pixel.\n"
    .byte 0
    s3: .text @"graphics in 256 colors.\n"
    .byte 0
}
.segment Code
  // bitmap_320_x_240_4BPP
bitmap_320_x_240_4BPP: {
    .label __27 = $66
    .label __37 = $53
    .label __40 = $66
    .label color = $ad
    .label x = $73
    // cx16_cpy_vram_from_vram(1, 0xF000, 0, 0xF800, 256*8)
    // [1040] call cx16_cpy_vram_from_vram
  // Before we configure the bitmap pane into vera  memory we need to re-arrange a few things!
  // It is better to load all in bank 0, but then there is an issue.
  // So the default CX16 character set is located in bank 0, at address 0xF800.
  // So we need to move this character set to bank 1, suggested is at address 0xF000.
  // The CX16 by default writes textual output to layer 1 in text mode, so we need to
  // realign the moved character set to 0xf000 as the new tile base for layer 1.
  // We also will need to realign for layer 1 the map base from 0x00000 to 0x14000.
  // This is now all easily done with a few statements in the new kickc vera lib ...
    // [1674] phi from bitmap_320_x_240_4BPP to cx16_cpy_vram_from_vram [phi:bitmap_320_x_240_4BPP->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f000 [phi:bitmap_320_x_240_4BPP->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 1 [phi:bitmap_320_x_240_4BPP->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f800 [phi:bitmap_320_x_240_4BPP->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 0 [phi:bitmap_320_x_240_4BPP->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // [1041] phi from bitmap_320_x_240_4BPP to bitmap_320_x_240_4BPP::@9 [phi:bitmap_320_x_240_4BPP->bitmap_320_x_240_4BPP::@9]
    // bitmap_320_x_240_4BPP::@9
    // vera_layer_mode_tile(1, 0x14000, 0x1F000, 128, 64, 8, 8, 1)
    // [1042] call vera_layer_mode_tile
  // We copy the 128 character set of 8 bytes each.
    // [1580] phi from bitmap_320_x_240_4BPP::@9 to vera_layer_mode_tile [phi:bitmap_320_x_240_4BPP::@9->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = 8 [phi:bitmap_320_x_240_4BPP::@9->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = 8 [phi:bitmap_320_x_240_4BPP::@9->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $1f000 [phi:bitmap_320_x_240_4BPP::@9->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$1f000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$1f000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $14000 [phi:bitmap_320_x_240_4BPP::@9->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $40 [phi:bitmap_320_x_240_4BPP::@9->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 1 [phi:bitmap_320_x_240_4BPP::@9->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $80 [phi:bitmap_320_x_240_4BPP::@9->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 1 [phi:bitmap_320_x_240_4BPP::@9->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // [1043] phi from bitmap_320_x_240_4BPP::@9 to bitmap_320_x_240_4BPP::@10 [phi:bitmap_320_x_240_4BPP::@9->bitmap_320_x_240_4BPP::@10]
    // bitmap_320_x_240_4BPP::@10
    // vera_layer_mode_bitmap(0, (dword)0x00000, 320, 4)
    // [1044] call vera_layer_mode_bitmap
    // [1745] phi from bitmap_320_x_240_4BPP::@10 to vera_layer_mode_bitmap [phi:bitmap_320_x_240_4BPP::@10->vera_layer_mode_bitmap]
    // [1745] phi vera_layer_mode_bitmap::mapwidth#10 = $140 [phi:bitmap_320_x_240_4BPP::@10->vera_layer_mode_bitmap#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z vera_layer_mode_bitmap.mapwidth
    lda #>$140
    sta.z vera_layer_mode_bitmap.mapwidth+1
    // [1745] phi vera_layer_mode_bitmap::color_depth#6 = 4 [phi:bitmap_320_x_240_4BPP::@10->vera_layer_mode_bitmap#1] -- vwuz1=vbuc1 
    lda #<4
    sta.z vera_layer_mode_bitmap.color_depth
    lda #>4
    sta.z vera_layer_mode_bitmap.color_depth+1
    jsr vera_layer_mode_bitmap
    // [1045] phi from bitmap_320_x_240_4BPP::@10 to bitmap_320_x_240_4BPP::@11 [phi:bitmap_320_x_240_4BPP::@10->bitmap_320_x_240_4BPP::@11]
    // bitmap_320_x_240_4BPP::@11
    // screenlayer(1)
    // [1046] call screenlayer
    jsr screenlayer
    // [1047] phi from bitmap_320_x_240_4BPP::@11 to bitmap_320_x_240_4BPP::@12 [phi:bitmap_320_x_240_4BPP::@11->bitmap_320_x_240_4BPP::@12]
    // bitmap_320_x_240_4BPP::@12
    // textcolor(WHITE)
    // [1048] call textcolor
    // [274] phi from bitmap_320_x_240_4BPP::@12 to textcolor [phi:bitmap_320_x_240_4BPP::@12->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:bitmap_320_x_240_4BPP::@12->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [1049] phi from bitmap_320_x_240_4BPP::@12 to bitmap_320_x_240_4BPP::@13 [phi:bitmap_320_x_240_4BPP::@12->bitmap_320_x_240_4BPP::@13]
    // bitmap_320_x_240_4BPP::@13
    // bgcolor(BLACK)
    // [1050] call bgcolor
    // [279] phi from bitmap_320_x_240_4BPP::@13 to bgcolor [phi:bitmap_320_x_240_4BPP::@13->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:bitmap_320_x_240_4BPP::@13->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [1051] phi from bitmap_320_x_240_4BPP::@13 to bitmap_320_x_240_4BPP::@14 [phi:bitmap_320_x_240_4BPP::@13->bitmap_320_x_240_4BPP::@14]
    // bitmap_320_x_240_4BPP::@14
    // clrscr()
    // [1052] call clrscr
    jsr clrscr
    // [1053] phi from bitmap_320_x_240_4BPP::@14 to bitmap_320_x_240_4BPP::@15 [phi:bitmap_320_x_240_4BPP::@14->bitmap_320_x_240_4BPP::@15]
    // bitmap_320_x_240_4BPP::@15
    // gotoxy(0,25)
    // [1054] call gotoxy
    // [242] phi from bitmap_320_x_240_4BPP::@15 to gotoxy [phi:bitmap_320_x_240_4BPP::@15->gotoxy]
    // [242] phi gotoxy::y#35 = $19 [phi:bitmap_320_x_240_4BPP::@15->gotoxy#0] -- vbuz1=vbuc1 
    lda #$19
    sta.z gotoxy.y
    jsr gotoxy
    // [1055] phi from bitmap_320_x_240_4BPP::@15 to bitmap_320_x_240_4BPP::@16 [phi:bitmap_320_x_240_4BPP::@15->bitmap_320_x_240_4BPP::@16]
    // bitmap_320_x_240_4BPP::@16
    // printf("vera in bitmap mode,\n")
    // [1056] call printf_str
    // [318] phi from bitmap_320_x_240_4BPP::@16 to printf_str [phi:bitmap_320_x_240_4BPP::@16->printf_str]
    // [318] phi printf_str::s#124 = string_8 [phi:bitmap_320_x_240_4BPP::@16->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_8
    sta.z printf_str.s
    lda #>string_8
    sta.z printf_str.s+1
    jsr printf_str
    // [1057] phi from bitmap_320_x_240_4BPP::@16 to bitmap_320_x_240_4BPP::@17 [phi:bitmap_320_x_240_4BPP::@16->bitmap_320_x_240_4BPP::@17]
    // bitmap_320_x_240_4BPP::@17
    // printf("color depth 4 bits per pixel.\n")
    // [1058] call printf_str
    // [318] phi from bitmap_320_x_240_4BPP::@17 to printf_str [phi:bitmap_320_x_240_4BPP::@17->printf_str]
    // [318] phi printf_str::s#124 = bitmap_320_x_240_4BPP::s1 [phi:bitmap_320_x_240_4BPP::@17->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [1059] phi from bitmap_320_x_240_4BPP::@17 to bitmap_320_x_240_4BPP::@18 [phi:bitmap_320_x_240_4BPP::@17->bitmap_320_x_240_4BPP::@18]
    // bitmap_320_x_240_4BPP::@18
    // printf("in this mode, it is possible to display\n")
    // [1060] call printf_str
    // [318] phi from bitmap_320_x_240_4BPP::@18 to printf_str [phi:bitmap_320_x_240_4BPP::@18->printf_str]
    // [318] phi printf_str::s#124 = string_10 [phi:bitmap_320_x_240_4BPP::@18->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_10
    sta.z printf_str.s
    lda #>string_10
    sta.z printf_str.s+1
    jsr printf_str
    // [1061] phi from bitmap_320_x_240_4BPP::@18 to bitmap_320_x_240_4BPP::@19 [phi:bitmap_320_x_240_4BPP::@18->bitmap_320_x_240_4BPP::@19]
    // bitmap_320_x_240_4BPP::@19
    // printf("graphics in 16 colors.\n")
    // [1062] call printf_str
    // [318] phi from bitmap_320_x_240_4BPP::@19 to printf_str [phi:bitmap_320_x_240_4BPP::@19->printf_str]
    // [318] phi printf_str::s#124 = bitmap_320_x_240_4BPP::s3 [phi:bitmap_320_x_240_4BPP::@19->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // bitmap_320_x_240_4BPP::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [1063] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [1064] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [1065] phi from bitmap_320_x_240_4BPP::vera_layer_show1 to bitmap_320_x_240_4BPP::@8 [phi:bitmap_320_x_240_4BPP::vera_layer_show1->bitmap_320_x_240_4BPP::@8]
    // bitmap_320_x_240_4BPP::@8
    // bitmap_init(0, 0x00000)
    // [1066] call bitmap_init
    jsr bitmap_init
    // [1067] phi from bitmap_320_x_240_4BPP::@8 to bitmap_320_x_240_4BPP::@20 [phi:bitmap_320_x_240_4BPP::@8->bitmap_320_x_240_4BPP::@20]
    // bitmap_320_x_240_4BPP::@20
    // bitmap_clear()
    // [1068] call bitmap_clear
    jsr bitmap_clear
    // [1069] phi from bitmap_320_x_240_4BPP::@20 to bitmap_320_x_240_4BPP::@21 [phi:bitmap_320_x_240_4BPP::@20->bitmap_320_x_240_4BPP::@21]
    // bitmap_320_x_240_4BPP::@21
    // gotoxy(0,29)
    // [1070] call gotoxy
    // [242] phi from bitmap_320_x_240_4BPP::@21 to gotoxy [phi:bitmap_320_x_240_4BPP::@21->gotoxy]
    // [242] phi gotoxy::y#35 = $1d [phi:bitmap_320_x_240_4BPP::@21->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1d
    sta.z gotoxy.y
    jsr gotoxy
    // [1071] phi from bitmap_320_x_240_4BPP::@21 to bitmap_320_x_240_4BPP::@22 [phi:bitmap_320_x_240_4BPP::@21->bitmap_320_x_240_4BPP::@22]
    // bitmap_320_x_240_4BPP::@22
    // textcolor(YELLOW)
    // [1072] call textcolor
    // [274] phi from bitmap_320_x_240_4BPP::@22 to textcolor [phi:bitmap_320_x_240_4BPP::@22->textcolor]
    // [274] phi textcolor::color#38 = YELLOW [phi:bitmap_320_x_240_4BPP::@22->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [1073] phi from bitmap_320_x_240_4BPP::@22 to bitmap_320_x_240_4BPP::@23 [phi:bitmap_320_x_240_4BPP::@22->bitmap_320_x_240_4BPP::@23]
    // bitmap_320_x_240_4BPP::@23
    // printf("press a key ...")
    // [1074] call printf_str
    // [318] phi from bitmap_320_x_240_4BPP::@23 to printf_str [phi:bitmap_320_x_240_4BPP::@23->printf_str]
    // [318] phi printf_str::s#124 = string_12 [phi:bitmap_320_x_240_4BPP::@23->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_12
    sta.z printf_str.s
    lda #>string_12
    sta.z printf_str.s+1
    jsr printf_str
    // [1075] phi from bitmap_320_x_240_4BPP::@23 bitmap_320_x_240_4BPP::@33 to bitmap_320_x_240_4BPP::@1 [phi:bitmap_320_x_240_4BPP::@23/bitmap_320_x_240_4BPP::@33->bitmap_320_x_240_4BPP::@1]
    // [1075] phi rem16u#114 = rem16u#236 [phi:bitmap_320_x_240_4BPP::@23/bitmap_320_x_240_4BPP::@33->bitmap_320_x_240_4BPP::@1#0] -- register_copy 
    // [1075] phi rand_state#107 = rand_state#246 [phi:bitmap_320_x_240_4BPP::@23/bitmap_320_x_240_4BPP::@33->bitmap_320_x_240_4BPP::@1#1] -- register_copy 
    // bitmap_320_x_240_4BPP::@1
  __b1:
    // getin()
    // [1076] call getin
    jsr getin
    // [1077] getin::return#20 = getin::return#1
    // bitmap_320_x_240_4BPP::@24
    // [1078] bitmap_320_x_240_4BPP::$27 = getin::return#20
    // while(!getin())
    // [1079] if(0==bitmap_320_x_240_4BPP::$27) goto bitmap_320_x_240_4BPP::@2 -- 0_eq_vbuz1_then_la1 
    lda.z __27
    bne !__b2+
    jmp __b2
  !__b2:
    // [1080] phi from bitmap_320_x_240_4BPP::@24 to bitmap_320_x_240_4BPP::@3 [phi:bitmap_320_x_240_4BPP::@24->bitmap_320_x_240_4BPP::@3]
    // bitmap_320_x_240_4BPP::@3
    // textcolor(WHITE)
    // [1081] call textcolor
    // [274] phi from bitmap_320_x_240_4BPP::@3 to textcolor [phi:bitmap_320_x_240_4BPP::@3->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:bitmap_320_x_240_4BPP::@3->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [1082] phi from bitmap_320_x_240_4BPP::@3 to bitmap_320_x_240_4BPP::@34 [phi:bitmap_320_x_240_4BPP::@3->bitmap_320_x_240_4BPP::@34]
    // bitmap_320_x_240_4BPP::@34
    // bgcolor(BLACK)
    // [1083] call bgcolor
    // [279] phi from bitmap_320_x_240_4BPP::@34 to bgcolor [phi:bitmap_320_x_240_4BPP::@34->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:bitmap_320_x_240_4BPP::@34->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [1084] phi from bitmap_320_x_240_4BPP::@34 to bitmap_320_x_240_4BPP::@35 [phi:bitmap_320_x_240_4BPP::@34->bitmap_320_x_240_4BPP::@35]
    // bitmap_320_x_240_4BPP::@35
    // clrscr()
    // [1085] call clrscr
    jsr clrscr
    // [1086] phi from bitmap_320_x_240_4BPP::@35 to bitmap_320_x_240_4BPP::@36 [phi:bitmap_320_x_240_4BPP::@35->bitmap_320_x_240_4BPP::@36]
    // bitmap_320_x_240_4BPP::@36
    // gotoxy(0,26)
    // [1087] call gotoxy
    // [242] phi from bitmap_320_x_240_4BPP::@36 to gotoxy [phi:bitmap_320_x_240_4BPP::@36->gotoxy]
    // [242] phi gotoxy::y#35 = $1a [phi:bitmap_320_x_240_4BPP::@36->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1a
    sta.z gotoxy.y
    jsr gotoxy
    // [1088] phi from bitmap_320_x_240_4BPP::@36 to bitmap_320_x_240_4BPP::@37 [phi:bitmap_320_x_240_4BPP::@36->bitmap_320_x_240_4BPP::@37]
    // bitmap_320_x_240_4BPP::@37
    // printf("here you see all the colors possible.\n")
    // [1089] call printf_str
    // [318] phi from bitmap_320_x_240_4BPP::@37 to printf_str [phi:bitmap_320_x_240_4BPP::@37->printf_str]
    // [318] phi printf_str::s#124 = string_13 [phi:bitmap_320_x_240_4BPP::@37->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_13
    sta.z printf_str.s
    lda #>string_13
    sta.z printf_str.s+1
    jsr printf_str
    // [1090] phi from bitmap_320_x_240_4BPP::@37 to bitmap_320_x_240_4BPP::@38 [phi:bitmap_320_x_240_4BPP::@37->bitmap_320_x_240_4BPP::@38]
    // bitmap_320_x_240_4BPP::@38
    // gotoxy(0,29)
    // [1091] call gotoxy
    // [242] phi from bitmap_320_x_240_4BPP::@38 to gotoxy [phi:bitmap_320_x_240_4BPP::@38->gotoxy]
    // [242] phi gotoxy::y#35 = $1d [phi:bitmap_320_x_240_4BPP::@38->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1d
    sta.z gotoxy.y
    jsr gotoxy
    // [1092] phi from bitmap_320_x_240_4BPP::@38 to bitmap_320_x_240_4BPP::@39 [phi:bitmap_320_x_240_4BPP::@38->bitmap_320_x_240_4BPP::@39]
    // bitmap_320_x_240_4BPP::@39
    // textcolor(YELLOW)
    // [1093] call textcolor
    // [274] phi from bitmap_320_x_240_4BPP::@39 to textcolor [phi:bitmap_320_x_240_4BPP::@39->textcolor]
    // [274] phi textcolor::color#38 = YELLOW [phi:bitmap_320_x_240_4BPP::@39->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [1094] phi from bitmap_320_x_240_4BPP::@39 to bitmap_320_x_240_4BPP::@40 [phi:bitmap_320_x_240_4BPP::@39->bitmap_320_x_240_4BPP::@40]
    // bitmap_320_x_240_4BPP::@40
    // printf("press a key ...")
    // [1095] call printf_str
    // [318] phi from bitmap_320_x_240_4BPP::@40 to printf_str [phi:bitmap_320_x_240_4BPP::@40->printf_str]
    // [318] phi printf_str::s#124 = string_12 [phi:bitmap_320_x_240_4BPP::@40->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_12
    sta.z printf_str.s
    lda #>string_12
    sta.z printf_str.s+1
    jsr printf_str
    // [1096] phi from bitmap_320_x_240_4BPP::@40 to bitmap_320_x_240_4BPP::@4 [phi:bitmap_320_x_240_4BPP::@40->bitmap_320_x_240_4BPP::@4]
    // [1096] phi bitmap_320_x_240_4BPP::color#3 = 0 [phi:bitmap_320_x_240_4BPP::@40->bitmap_320_x_240_4BPP::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [1096] phi bitmap_320_x_240_4BPP::x#3 = 0 [phi:bitmap_320_x_240_4BPP::@40->bitmap_320_x_240_4BPP::@4#1] -- vwuz1=vwuc1 
    sta.z x
    sta.z x+1
    // bitmap_320_x_240_4BPP::@4
  __b4:
    // getin()
    // [1097] call getin
    jsr getin
    // [1098] getin::return#21 = getin::return#1
    // bitmap_320_x_240_4BPP::@41
    // [1099] bitmap_320_x_240_4BPP::$40 = getin::return#21
    // while(!getin())
    // [1100] if(0==bitmap_320_x_240_4BPP::$40) goto bitmap_320_x_240_4BPP::@5 -- 0_eq_vbuz1_then_la1 
    lda.z __40
    beq __b5
    // [1101] phi from bitmap_320_x_240_4BPP::@41 to bitmap_320_x_240_4BPP::@6 [phi:bitmap_320_x_240_4BPP::@41->bitmap_320_x_240_4BPP::@6]
    // bitmap_320_x_240_4BPP::@6
    // cx16_cpy_vram_from_vram(0, 0xF800, 1, 0xF000, 256*8)
    // [1102] call cx16_cpy_vram_from_vram
    // [1674] phi from bitmap_320_x_240_4BPP::@6 to cx16_cpy_vram_from_vram [phi:bitmap_320_x_240_4BPP::@6->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f800 [phi:bitmap_320_x_240_4BPP::@6->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 0 [phi:bitmap_320_x_240_4BPP::@6->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f000 [phi:bitmap_320_x_240_4BPP::@6->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:bitmap_320_x_240_4BPP::@6->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // bitmap_320_x_240_4BPP::@return
    // }
    // [1103] return 
    rts
    // bitmap_320_x_240_4BPP::@5
  __b5:
    // bitmap_line(x, x, 0, 199, color)
    // [1104] bitmap_line::x0#9 = bitmap_320_x_240_4BPP::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x0
    lda.z x+1
    sta.z bitmap_line.x0+1
    // [1105] bitmap_line::x1#9 = bitmap_320_x_240_4BPP::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x1
    lda.z x+1
    sta.z bitmap_line.x1+1
    // [1106] bitmap_line::c#9 = bitmap_320_x_240_4BPP::color#3 -- vbuz1=vbuz2 
    lda.z color
    sta.z bitmap_line.c
    // [1107] call bitmap_line
    // [1874] phi from bitmap_320_x_240_4BPP::@5 to bitmap_line [phi:bitmap_320_x_240_4BPP::@5->bitmap_line]
    // [1874] phi bitmap_line::c#12 = bitmap_line::c#9 [phi:bitmap_320_x_240_4BPP::@5->bitmap_line#0] -- register_copy 
    // [1874] phi bitmap_line::y1#12 = $c7 [phi:bitmap_320_x_240_4BPP::@5->bitmap_line#1] -- vwuz1=vbuc1 
    lda #<$c7
    sta.z bitmap_line.y1
    lda #>$c7
    sta.z bitmap_line.y1+1
    // [1874] phi bitmap_line::y0#12 = 0 [phi:bitmap_320_x_240_4BPP::@5->bitmap_line#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z bitmap_line.y0
    sta.z bitmap_line.y0+1
    // [1874] phi bitmap_line::x1#12 = bitmap_line::x1#9 [phi:bitmap_320_x_240_4BPP::@5->bitmap_line#3] -- register_copy 
    // [1874] phi bitmap_line::x0#12 = bitmap_line::x0#9 [phi:bitmap_320_x_240_4BPP::@5->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    // bitmap_320_x_240_4BPP::@42
    // color++;
    // [1108] bitmap_320_x_240_4BPP::color#1 = ++ bitmap_320_x_240_4BPP::color#3 -- vbuz1=_inc_vbuz1 
    inc.z color
    // if(color>15)
    // [1109] if(bitmap_320_x_240_4BPP::color#1<$f+1) goto bitmap_320_x_240_4BPP::@44 -- vbuz1_lt_vbuc1_then_la1 
    lda.z color
    cmp #$f+1
    bcc __b7
    // [1111] phi from bitmap_320_x_240_4BPP::@42 to bitmap_320_x_240_4BPP::@7 [phi:bitmap_320_x_240_4BPP::@42->bitmap_320_x_240_4BPP::@7]
    // [1111] phi bitmap_320_x_240_4BPP::color#7 = 0 [phi:bitmap_320_x_240_4BPP::@42->bitmap_320_x_240_4BPP::@7#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [1110] phi from bitmap_320_x_240_4BPP::@42 to bitmap_320_x_240_4BPP::@44 [phi:bitmap_320_x_240_4BPP::@42->bitmap_320_x_240_4BPP::@44]
    // bitmap_320_x_240_4BPP::@44
    // [1111] phi from bitmap_320_x_240_4BPP::@44 to bitmap_320_x_240_4BPP::@7 [phi:bitmap_320_x_240_4BPP::@44->bitmap_320_x_240_4BPP::@7]
    // [1111] phi bitmap_320_x_240_4BPP::color#7 = bitmap_320_x_240_4BPP::color#1 [phi:bitmap_320_x_240_4BPP::@44->bitmap_320_x_240_4BPP::@7#0] -- register_copy 
    // bitmap_320_x_240_4BPP::@7
  __b7:
    // x++;
    // [1112] bitmap_320_x_240_4BPP::x#1 = ++ bitmap_320_x_240_4BPP::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // if(x>319)
    // [1113] if(bitmap_320_x_240_4BPP::x#1<=$13f) goto bitmap_320_x_240_4BPP::@43 -- vwuz1_le_vwuc1_then_la1 
    lda.z x+1
    cmp #>$13f
    bne !+
    lda.z x
    cmp #<$13f
  !:
    bcc __b4
    beq __b4
    // [1096] phi from bitmap_320_x_240_4BPP::@7 to bitmap_320_x_240_4BPP::@4 [phi:bitmap_320_x_240_4BPP::@7->bitmap_320_x_240_4BPP::@4]
    // [1096] phi bitmap_320_x_240_4BPP::color#3 = bitmap_320_x_240_4BPP::color#7 [phi:bitmap_320_x_240_4BPP::@7->bitmap_320_x_240_4BPP::@4#0] -- register_copy 
    // [1096] phi bitmap_320_x_240_4BPP::x#3 = 0 [phi:bitmap_320_x_240_4BPP::@7->bitmap_320_x_240_4BPP::@4#1] -- vwuz1=vbuc1 
    lda #<0
    sta.z x
    sta.z x+1
    jmp __b4
    // [1114] phi from bitmap_320_x_240_4BPP::@7 to bitmap_320_x_240_4BPP::@43 [phi:bitmap_320_x_240_4BPP::@7->bitmap_320_x_240_4BPP::@43]
    // bitmap_320_x_240_4BPP::@43
    // [1096] phi from bitmap_320_x_240_4BPP::@43 to bitmap_320_x_240_4BPP::@4 [phi:bitmap_320_x_240_4BPP::@43->bitmap_320_x_240_4BPP::@4]
    // [1096] phi bitmap_320_x_240_4BPP::color#3 = bitmap_320_x_240_4BPP::color#7 [phi:bitmap_320_x_240_4BPP::@43->bitmap_320_x_240_4BPP::@4#0] -- register_copy 
    // [1096] phi bitmap_320_x_240_4BPP::x#3 = bitmap_320_x_240_4BPP::x#1 [phi:bitmap_320_x_240_4BPP::@43->bitmap_320_x_240_4BPP::@4#1] -- register_copy 
    // [1115] phi from bitmap_320_x_240_4BPP::@24 to bitmap_320_x_240_4BPP::@2 [phi:bitmap_320_x_240_4BPP::@24->bitmap_320_x_240_4BPP::@2]
    // bitmap_320_x_240_4BPP::@2
  __b2:
    // rand()
    // [1116] call rand
    // [1945] phi from bitmap_320_x_240_4BPP::@2 to rand [phi:bitmap_320_x_240_4BPP::@2->rand]
    // [1945] phi rand_state#50 = rand_state#107 [phi:bitmap_320_x_240_4BPP::@2->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1117] rand::return#22 = rand::return#0
    // bitmap_320_x_240_4BPP::@25
    // modr16u(rand(),320,0)
    // [1118] modr16u::dividend#16 = rand::return#22
    // [1119] call modr16u
    // [1954] phi from bitmap_320_x_240_4BPP::@25 to modr16u [phi:bitmap_320_x_240_4BPP::@25->modr16u]
    // [1954] phi modr16u::divisor#24 = $140 [phi:bitmap_320_x_240_4BPP::@25->modr16u#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z modr16u.divisor
    lda #>$140
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#16 [phi:bitmap_320_x_240_4BPP::@25->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),320,0)
    // [1120] modr16u::return#18 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_1
    lda.z modr16u.return+1
    sta.z modr16u.return_1+1
    // bitmap_320_x_240_4BPP::@26
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&15)
    // [1121] bitmap_line::x0#8 = modr16u::return#18
    // rand()
    // [1122] call rand
    // [1945] phi from bitmap_320_x_240_4BPP::@26 to rand [phi:bitmap_320_x_240_4BPP::@26->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_4BPP::@26->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1123] rand::return#23 = rand::return#0
    // bitmap_320_x_240_4BPP::@27
    // modr16u(rand(),320,0)
    // [1124] modr16u::dividend#17 = rand::return#23
    // [1125] call modr16u
    // [1954] phi from bitmap_320_x_240_4BPP::@27 to modr16u [phi:bitmap_320_x_240_4BPP::@27->modr16u]
    // [1954] phi modr16u::divisor#24 = $140 [phi:bitmap_320_x_240_4BPP::@27->modr16u#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z modr16u.divisor
    lda #>$140
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#17 [phi:bitmap_320_x_240_4BPP::@27->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),320,0)
    // [1126] modr16u::return#19 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_2
    lda.z modr16u.return+1
    sta.z modr16u.return_2+1
    // bitmap_320_x_240_4BPP::@28
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&15)
    // [1127] bitmap_line::x1#8 = modr16u::return#19
    // rand()
    // [1128] call rand
    // [1945] phi from bitmap_320_x_240_4BPP::@28 to rand [phi:bitmap_320_x_240_4BPP::@28->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_4BPP::@28->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1129] rand::return#24 = rand::return#0
    // bitmap_320_x_240_4BPP::@29
    // modr16u(rand(),200,0)
    // [1130] modr16u::dividend#18 = rand::return#24
    // [1131] call modr16u
    // [1954] phi from bitmap_320_x_240_4BPP::@29 to modr16u [phi:bitmap_320_x_240_4BPP::@29->modr16u]
    // [1954] phi modr16u::divisor#24 = $c8 [phi:bitmap_320_x_240_4BPP::@29->modr16u#0] -- vwuz1=vbuc1 
    lda #<$c8
    sta.z modr16u.divisor
    lda #>$c8
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#18 [phi:bitmap_320_x_240_4BPP::@29->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),200,0)
    // [1132] modr16u::return#20 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_3
    lda.z modr16u.return+1
    sta.z modr16u.return_3+1
    // bitmap_320_x_240_4BPP::@30
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&15)
    // [1133] bitmap_line::y0#8 = modr16u::return#20
    // rand()
    // [1134] call rand
    // [1945] phi from bitmap_320_x_240_4BPP::@30 to rand [phi:bitmap_320_x_240_4BPP::@30->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_4BPP::@30->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1135] rand::return#25 = rand::return#0
    // bitmap_320_x_240_4BPP::@31
    // modr16u(rand(),200,0)
    // [1136] modr16u::dividend#19 = rand::return#25
    // [1137] call modr16u
    // [1954] phi from bitmap_320_x_240_4BPP::@31 to modr16u [phi:bitmap_320_x_240_4BPP::@31->modr16u]
    // [1954] phi modr16u::divisor#24 = $c8 [phi:bitmap_320_x_240_4BPP::@31->modr16u#0] -- vwuz1=vbuc1 
    lda #<$c8
    sta.z modr16u.divisor
    lda #>$c8
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#19 [phi:bitmap_320_x_240_4BPP::@31->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),200,0)
    // [1138] modr16u::return#21 = modr16u::return#0
    // bitmap_320_x_240_4BPP::@32
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&15)
    // [1139] bitmap_line::y1#8 = modr16u::return#21
    // rand()
    // [1140] call rand
    // [1945] phi from bitmap_320_x_240_4BPP::@32 to rand [phi:bitmap_320_x_240_4BPP::@32->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_4BPP::@32->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1141] rand::return#26 = rand::return#0
    // bitmap_320_x_240_4BPP::@33
    // [1142] bitmap_320_x_240_4BPP::$37 = rand::return#26
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&15)
    // [1143] bitmap_line::c#8 = bitmap_320_x_240_4BPP::$37 & $f -- vbuz1=vwuz2_band_vbuc1 
    lda #$f
    and.z __37
    sta.z bitmap_line.c
    // [1144] call bitmap_line
    // [1874] phi from bitmap_320_x_240_4BPP::@33 to bitmap_line [phi:bitmap_320_x_240_4BPP::@33->bitmap_line]
    // [1874] phi bitmap_line::c#12 = bitmap_line::c#8 [phi:bitmap_320_x_240_4BPP::@33->bitmap_line#0] -- register_copy 
    // [1874] phi bitmap_line::y1#12 = bitmap_line::y1#8 [phi:bitmap_320_x_240_4BPP::@33->bitmap_line#1] -- register_copy 
    // [1874] phi bitmap_line::y0#12 = bitmap_line::y0#8 [phi:bitmap_320_x_240_4BPP::@33->bitmap_line#2] -- register_copy 
    // [1874] phi bitmap_line::x1#12 = bitmap_line::x1#8 [phi:bitmap_320_x_240_4BPP::@33->bitmap_line#3] -- register_copy 
    // [1874] phi bitmap_line::x0#12 = bitmap_line::x0#8 [phi:bitmap_320_x_240_4BPP::@33->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    jmp __b1
  .segment Data
    s1: .text @"color depth 4 bits per pixel.\n"
    .byte 0
    s3: .text @"graphics in 16 colors.\n"
    .byte 0
}
.segment Code
  // bitmap_640_x_480_2BPP
bitmap_640_x_480_2BPP: {
    .label __27 = $66
    .label __37 = $53
    .label __40 = $66
    .label color = $af
    .label x = $b6
    // cx16_cpy_vram_from_vram(1, 0xF000, 0, 0xF800, 256*8)
    // [1146] call cx16_cpy_vram_from_vram
  // Before we configure the bitmap pane into vera  memory we need to re-arrange a few things!
  // It is better to load all in bank 0, but then there is an issue.
  // So the default CX16 character set is located in bank 0, at address 0xF800.
  // So we need to move this character set to bank 1, suggested is at address 0xF000.
  // The CX16 by default writes textual output to layer 1 in text mode, so we need to
  // realign the moved character set to 0xf000 as the new tile base for layer 1.
  // We also will need to realign for layer 1 the map base from 0x00000 to 0x14000.
  // This is now all easily done with a few statements in the new kickc vera lib ...
    // [1674] phi from bitmap_640_x_480_2BPP to cx16_cpy_vram_from_vram [phi:bitmap_640_x_480_2BPP->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f000 [phi:bitmap_640_x_480_2BPP->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 1 [phi:bitmap_640_x_480_2BPP->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f800 [phi:bitmap_640_x_480_2BPP->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 0 [phi:bitmap_640_x_480_2BPP->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // [1147] phi from bitmap_640_x_480_2BPP to bitmap_640_x_480_2BPP::@9 [phi:bitmap_640_x_480_2BPP->bitmap_640_x_480_2BPP::@9]
    // bitmap_640_x_480_2BPP::@9
    // vera_layer_mode_tile(1, 0x14000, 0x1F000, 128, 64, 8, 8, 1)
    // [1148] call vera_layer_mode_tile
  // We copy the 128 character set of 8 bytes each.
    // [1580] phi from bitmap_640_x_480_2BPP::@9 to vera_layer_mode_tile [phi:bitmap_640_x_480_2BPP::@9->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = 8 [phi:bitmap_640_x_480_2BPP::@9->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = 8 [phi:bitmap_640_x_480_2BPP::@9->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $1f000 [phi:bitmap_640_x_480_2BPP::@9->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$1f000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$1f000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $14000 [phi:bitmap_640_x_480_2BPP::@9->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $40 [phi:bitmap_640_x_480_2BPP::@9->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 1 [phi:bitmap_640_x_480_2BPP::@9->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $80 [phi:bitmap_640_x_480_2BPP::@9->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 1 [phi:bitmap_640_x_480_2BPP::@9->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // [1149] phi from bitmap_640_x_480_2BPP::@9 to bitmap_640_x_480_2BPP::@10 [phi:bitmap_640_x_480_2BPP::@9->bitmap_640_x_480_2BPP::@10]
    // bitmap_640_x_480_2BPP::@10
    // vera_layer_mode_bitmap(0, (dword)0x00000, 640, 2)
    // [1150] call vera_layer_mode_bitmap
    // [1745] phi from bitmap_640_x_480_2BPP::@10 to vera_layer_mode_bitmap [phi:bitmap_640_x_480_2BPP::@10->vera_layer_mode_bitmap]
    // [1745] phi vera_layer_mode_bitmap::mapwidth#10 = $280 [phi:bitmap_640_x_480_2BPP::@10->vera_layer_mode_bitmap#0] -- vwuz1=vwuc1 
    lda #<$280
    sta.z vera_layer_mode_bitmap.mapwidth
    lda #>$280
    sta.z vera_layer_mode_bitmap.mapwidth+1
    // [1745] phi vera_layer_mode_bitmap::color_depth#6 = 2 [phi:bitmap_640_x_480_2BPP::@10->vera_layer_mode_bitmap#1] -- vwuz1=vbuc1 
    lda #<2
    sta.z vera_layer_mode_bitmap.color_depth
    lda #>2
    sta.z vera_layer_mode_bitmap.color_depth+1
    jsr vera_layer_mode_bitmap
    // [1151] phi from bitmap_640_x_480_2BPP::@10 to bitmap_640_x_480_2BPP::@11 [phi:bitmap_640_x_480_2BPP::@10->bitmap_640_x_480_2BPP::@11]
    // bitmap_640_x_480_2BPP::@11
    // screenlayer(1)
    // [1152] call screenlayer
    jsr screenlayer
    // [1153] phi from bitmap_640_x_480_2BPP::@11 to bitmap_640_x_480_2BPP::@12 [phi:bitmap_640_x_480_2BPP::@11->bitmap_640_x_480_2BPP::@12]
    // bitmap_640_x_480_2BPP::@12
    // textcolor(WHITE)
    // [1154] call textcolor
    // [274] phi from bitmap_640_x_480_2BPP::@12 to textcolor [phi:bitmap_640_x_480_2BPP::@12->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:bitmap_640_x_480_2BPP::@12->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [1155] phi from bitmap_640_x_480_2BPP::@12 to bitmap_640_x_480_2BPP::@13 [phi:bitmap_640_x_480_2BPP::@12->bitmap_640_x_480_2BPP::@13]
    // bitmap_640_x_480_2BPP::@13
    // bgcolor(BLACK)
    // [1156] call bgcolor
    // [279] phi from bitmap_640_x_480_2BPP::@13 to bgcolor [phi:bitmap_640_x_480_2BPP::@13->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:bitmap_640_x_480_2BPP::@13->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [1157] phi from bitmap_640_x_480_2BPP::@13 to bitmap_640_x_480_2BPP::@14 [phi:bitmap_640_x_480_2BPP::@13->bitmap_640_x_480_2BPP::@14]
    // bitmap_640_x_480_2BPP::@14
    // clrscr()
    // [1158] call clrscr
    jsr clrscr
    // [1159] phi from bitmap_640_x_480_2BPP::@14 to bitmap_640_x_480_2BPP::@15 [phi:bitmap_640_x_480_2BPP::@14->bitmap_640_x_480_2BPP::@15]
    // bitmap_640_x_480_2BPP::@15
    // gotoxy(0,54)
    // [1160] call gotoxy
    // [242] phi from bitmap_640_x_480_2BPP::@15 to gotoxy [phi:bitmap_640_x_480_2BPP::@15->gotoxy]
    // [242] phi gotoxy::y#35 = $36 [phi:bitmap_640_x_480_2BPP::@15->gotoxy#0] -- vbuz1=vbuc1 
    lda #$36
    sta.z gotoxy.y
    jsr gotoxy
    // [1161] phi from bitmap_640_x_480_2BPP::@15 to bitmap_640_x_480_2BPP::@16 [phi:bitmap_640_x_480_2BPP::@15->bitmap_640_x_480_2BPP::@16]
    // bitmap_640_x_480_2BPP::@16
    // printf("vera in bitmap mode,\n")
    // [1162] call printf_str
    // [318] phi from bitmap_640_x_480_2BPP::@16 to printf_str [phi:bitmap_640_x_480_2BPP::@16->printf_str]
    // [318] phi printf_str::s#124 = string_8 [phi:bitmap_640_x_480_2BPP::@16->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_8
    sta.z printf_str.s
    lda #>string_8
    sta.z printf_str.s+1
    jsr printf_str
    // [1163] phi from bitmap_640_x_480_2BPP::@16 to bitmap_640_x_480_2BPP::@17 [phi:bitmap_640_x_480_2BPP::@16->bitmap_640_x_480_2BPP::@17]
    // bitmap_640_x_480_2BPP::@17
    // printf("color depth 1 bits per pixel.\n")
    // [1164] call printf_str
    // [318] phi from bitmap_640_x_480_2BPP::@17 to printf_str [phi:bitmap_640_x_480_2BPP::@17->printf_str]
    // [318] phi printf_str::s#124 = string_9 [phi:bitmap_640_x_480_2BPP::@17->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_9
    sta.z printf_str.s
    lda #>string_9
    sta.z printf_str.s+1
    jsr printf_str
    // [1165] phi from bitmap_640_x_480_2BPP::@17 to bitmap_640_x_480_2BPP::@18 [phi:bitmap_640_x_480_2BPP::@17->bitmap_640_x_480_2BPP::@18]
    // bitmap_640_x_480_2BPP::@18
    // printf("in this mode, it is possible to display\n")
    // [1166] call printf_str
    // [318] phi from bitmap_640_x_480_2BPP::@18 to printf_str [phi:bitmap_640_x_480_2BPP::@18->printf_str]
    // [318] phi printf_str::s#124 = string_10 [phi:bitmap_640_x_480_2BPP::@18->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_10
    sta.z printf_str.s
    lda #>string_10
    sta.z printf_str.s+1
    jsr printf_str
    // [1167] phi from bitmap_640_x_480_2BPP::@18 to bitmap_640_x_480_2BPP::@19 [phi:bitmap_640_x_480_2BPP::@18->bitmap_640_x_480_2BPP::@19]
    // bitmap_640_x_480_2BPP::@19
    // printf("graphics in 2 colors (black or color).\n")
    // [1168] call printf_str
    // [318] phi from bitmap_640_x_480_2BPP::@19 to printf_str [phi:bitmap_640_x_480_2BPP::@19->printf_str]
    // [318] phi printf_str::s#124 = string_11 [phi:bitmap_640_x_480_2BPP::@19->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_11
    sta.z printf_str.s
    lda #>string_11
    sta.z printf_str.s+1
    jsr printf_str
    // bitmap_640_x_480_2BPP::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [1169] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [1170] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [1171] phi from bitmap_640_x_480_2BPP::vera_layer_show1 to bitmap_640_x_480_2BPP::@8 [phi:bitmap_640_x_480_2BPP::vera_layer_show1->bitmap_640_x_480_2BPP::@8]
    // bitmap_640_x_480_2BPP::@8
    // bitmap_init(0, 0x00000)
    // [1172] call bitmap_init
    jsr bitmap_init
    // [1173] phi from bitmap_640_x_480_2BPP::@8 to bitmap_640_x_480_2BPP::@20 [phi:bitmap_640_x_480_2BPP::@8->bitmap_640_x_480_2BPP::@20]
    // bitmap_640_x_480_2BPP::@20
    // bitmap_clear()
    // [1174] call bitmap_clear
    jsr bitmap_clear
    // [1175] phi from bitmap_640_x_480_2BPP::@20 to bitmap_640_x_480_2BPP::@21 [phi:bitmap_640_x_480_2BPP::@20->bitmap_640_x_480_2BPP::@21]
    // bitmap_640_x_480_2BPP::@21
    // gotoxy(0,59)
    // [1176] call gotoxy
    // [242] phi from bitmap_640_x_480_2BPP::@21 to gotoxy [phi:bitmap_640_x_480_2BPP::@21->gotoxy]
    // [242] phi gotoxy::y#35 = $3b [phi:bitmap_640_x_480_2BPP::@21->gotoxy#0] -- vbuz1=vbuc1 
    lda #$3b
    sta.z gotoxy.y
    jsr gotoxy
    // [1177] phi from bitmap_640_x_480_2BPP::@21 to bitmap_640_x_480_2BPP::@22 [phi:bitmap_640_x_480_2BPP::@21->bitmap_640_x_480_2BPP::@22]
    // bitmap_640_x_480_2BPP::@22
    // textcolor(YELLOW)
    // [1178] call textcolor
    // [274] phi from bitmap_640_x_480_2BPP::@22 to textcolor [phi:bitmap_640_x_480_2BPP::@22->textcolor]
    // [274] phi textcolor::color#38 = YELLOW [phi:bitmap_640_x_480_2BPP::@22->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [1179] phi from bitmap_640_x_480_2BPP::@22 to bitmap_640_x_480_2BPP::@23 [phi:bitmap_640_x_480_2BPP::@22->bitmap_640_x_480_2BPP::@23]
    // bitmap_640_x_480_2BPP::@23
    // printf("press a key ...")
    // [1180] call printf_str
    // [318] phi from bitmap_640_x_480_2BPP::@23 to printf_str [phi:bitmap_640_x_480_2BPP::@23->printf_str]
    // [318] phi printf_str::s#124 = string_12 [phi:bitmap_640_x_480_2BPP::@23->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_12
    sta.z printf_str.s
    lda #>string_12
    sta.z printf_str.s+1
    jsr printf_str
    // [1181] phi from bitmap_640_x_480_2BPP::@23 bitmap_640_x_480_2BPP::@33 to bitmap_640_x_480_2BPP::@1 [phi:bitmap_640_x_480_2BPP::@23/bitmap_640_x_480_2BPP::@33->bitmap_640_x_480_2BPP::@1]
    // [1181] phi rem16u#109 = rem16u#236 [phi:bitmap_640_x_480_2BPP::@23/bitmap_640_x_480_2BPP::@33->bitmap_640_x_480_2BPP::@1#0] -- register_copy 
    // [1181] phi rand_state#122 = rand_state#246 [phi:bitmap_640_x_480_2BPP::@23/bitmap_640_x_480_2BPP::@33->bitmap_640_x_480_2BPP::@1#1] -- register_copy 
    // bitmap_640_x_480_2BPP::@1
  __b1:
    // getin()
    // [1182] call getin
    jsr getin
    // [1183] getin::return#18 = getin::return#1
    // bitmap_640_x_480_2BPP::@24
    // [1184] bitmap_640_x_480_2BPP::$27 = getin::return#18
    // while(!getin())
    // [1185] if(0==bitmap_640_x_480_2BPP::$27) goto bitmap_640_x_480_2BPP::@2 -- 0_eq_vbuz1_then_la1 
    lda.z __27
    bne !__b2+
    jmp __b2
  !__b2:
    // [1186] phi from bitmap_640_x_480_2BPP::@24 to bitmap_640_x_480_2BPP::@3 [phi:bitmap_640_x_480_2BPP::@24->bitmap_640_x_480_2BPP::@3]
    // bitmap_640_x_480_2BPP::@3
    // textcolor(WHITE)
    // [1187] call textcolor
    // [274] phi from bitmap_640_x_480_2BPP::@3 to textcolor [phi:bitmap_640_x_480_2BPP::@3->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:bitmap_640_x_480_2BPP::@3->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [1188] phi from bitmap_640_x_480_2BPP::@3 to bitmap_640_x_480_2BPP::@34 [phi:bitmap_640_x_480_2BPP::@3->bitmap_640_x_480_2BPP::@34]
    // bitmap_640_x_480_2BPP::@34
    // bgcolor(BLACK)
    // [1189] call bgcolor
    // [279] phi from bitmap_640_x_480_2BPP::@34 to bgcolor [phi:bitmap_640_x_480_2BPP::@34->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:bitmap_640_x_480_2BPP::@34->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [1190] phi from bitmap_640_x_480_2BPP::@34 to bitmap_640_x_480_2BPP::@35 [phi:bitmap_640_x_480_2BPP::@34->bitmap_640_x_480_2BPP::@35]
    // bitmap_640_x_480_2BPP::@35
    // clrscr()
    // [1191] call clrscr
    jsr clrscr
    // [1192] phi from bitmap_640_x_480_2BPP::@35 to bitmap_640_x_480_2BPP::@36 [phi:bitmap_640_x_480_2BPP::@35->bitmap_640_x_480_2BPP::@36]
    // bitmap_640_x_480_2BPP::@36
    // gotoxy(0,54)
    // [1193] call gotoxy
    // [242] phi from bitmap_640_x_480_2BPP::@36 to gotoxy [phi:bitmap_640_x_480_2BPP::@36->gotoxy]
    // [242] phi gotoxy::y#35 = $36 [phi:bitmap_640_x_480_2BPP::@36->gotoxy#0] -- vbuz1=vbuc1 
    lda #$36
    sta.z gotoxy.y
    jsr gotoxy
    // [1194] phi from bitmap_640_x_480_2BPP::@36 to bitmap_640_x_480_2BPP::@37 [phi:bitmap_640_x_480_2BPP::@36->bitmap_640_x_480_2BPP::@37]
    // bitmap_640_x_480_2BPP::@37
    // printf("here you see all the colors possible.\n")
    // [1195] call printf_str
    // [318] phi from bitmap_640_x_480_2BPP::@37 to printf_str [phi:bitmap_640_x_480_2BPP::@37->printf_str]
    // [318] phi printf_str::s#124 = string_13 [phi:bitmap_640_x_480_2BPP::@37->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_13
    sta.z printf_str.s
    lda #>string_13
    sta.z printf_str.s+1
    jsr printf_str
    // [1196] phi from bitmap_640_x_480_2BPP::@37 to bitmap_640_x_480_2BPP::@38 [phi:bitmap_640_x_480_2BPP::@37->bitmap_640_x_480_2BPP::@38]
    // bitmap_640_x_480_2BPP::@38
    // gotoxy(0,59)
    // [1197] call gotoxy
    // [242] phi from bitmap_640_x_480_2BPP::@38 to gotoxy [phi:bitmap_640_x_480_2BPP::@38->gotoxy]
    // [242] phi gotoxy::y#35 = $3b [phi:bitmap_640_x_480_2BPP::@38->gotoxy#0] -- vbuz1=vbuc1 
    lda #$3b
    sta.z gotoxy.y
    jsr gotoxy
    // [1198] phi from bitmap_640_x_480_2BPP::@38 to bitmap_640_x_480_2BPP::@39 [phi:bitmap_640_x_480_2BPP::@38->bitmap_640_x_480_2BPP::@39]
    // bitmap_640_x_480_2BPP::@39
    // textcolor(YELLOW)
    // [1199] call textcolor
    // [274] phi from bitmap_640_x_480_2BPP::@39 to textcolor [phi:bitmap_640_x_480_2BPP::@39->textcolor]
    // [274] phi textcolor::color#38 = YELLOW [phi:bitmap_640_x_480_2BPP::@39->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [1200] phi from bitmap_640_x_480_2BPP::@39 to bitmap_640_x_480_2BPP::@40 [phi:bitmap_640_x_480_2BPP::@39->bitmap_640_x_480_2BPP::@40]
    // bitmap_640_x_480_2BPP::@40
    // printf("press a key ...")
    // [1201] call printf_str
    // [318] phi from bitmap_640_x_480_2BPP::@40 to printf_str [phi:bitmap_640_x_480_2BPP::@40->printf_str]
    // [318] phi printf_str::s#124 = string_12 [phi:bitmap_640_x_480_2BPP::@40->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_12
    sta.z printf_str.s
    lda #>string_12
    sta.z printf_str.s+1
    jsr printf_str
    // [1202] phi from bitmap_640_x_480_2BPP::@40 to bitmap_640_x_480_2BPP::@4 [phi:bitmap_640_x_480_2BPP::@40->bitmap_640_x_480_2BPP::@4]
    // [1202] phi bitmap_640_x_480_2BPP::color#3 = 0 [phi:bitmap_640_x_480_2BPP::@40->bitmap_640_x_480_2BPP::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [1202] phi bitmap_640_x_480_2BPP::x#3 = 0 [phi:bitmap_640_x_480_2BPP::@40->bitmap_640_x_480_2BPP::@4#1] -- vwuz1=vwuc1 
    sta.z x
    sta.z x+1
    // bitmap_640_x_480_2BPP::@4
  __b4:
    // getin()
    // [1203] call getin
    jsr getin
    // [1204] getin::return#19 = getin::return#1
    // bitmap_640_x_480_2BPP::@41
    // [1205] bitmap_640_x_480_2BPP::$40 = getin::return#19
    // while(!getin())
    // [1206] if(0==bitmap_640_x_480_2BPP::$40) goto bitmap_640_x_480_2BPP::@5 -- 0_eq_vbuz1_then_la1 
    lda.z __40
    beq __b5
    // [1207] phi from bitmap_640_x_480_2BPP::@41 to bitmap_640_x_480_2BPP::@6 [phi:bitmap_640_x_480_2BPP::@41->bitmap_640_x_480_2BPP::@6]
    // bitmap_640_x_480_2BPP::@6
    // cx16_cpy_vram_from_vram(0, 0xF800, 1, 0xF000, 256*8)
    // [1208] call cx16_cpy_vram_from_vram
    // [1674] phi from bitmap_640_x_480_2BPP::@6 to cx16_cpy_vram_from_vram [phi:bitmap_640_x_480_2BPP::@6->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f800 [phi:bitmap_640_x_480_2BPP::@6->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 0 [phi:bitmap_640_x_480_2BPP::@6->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f000 [phi:bitmap_640_x_480_2BPP::@6->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:bitmap_640_x_480_2BPP::@6->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // bitmap_640_x_480_2BPP::@return
    // }
    // [1209] return 
    rts
    // bitmap_640_x_480_2BPP::@5
  __b5:
    // bitmap_line(x, x, 0, 399, color)
    // [1210] bitmap_line::x0#7 = bitmap_640_x_480_2BPP::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x0
    lda.z x+1
    sta.z bitmap_line.x0+1
    // [1211] bitmap_line::x1#7 = bitmap_640_x_480_2BPP::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x1
    lda.z x+1
    sta.z bitmap_line.x1+1
    // [1212] bitmap_line::c#7 = bitmap_640_x_480_2BPP::color#3 -- vbuz1=vbuz2 
    lda.z color
    sta.z bitmap_line.c
    // [1213] call bitmap_line
    // [1874] phi from bitmap_640_x_480_2BPP::@5 to bitmap_line [phi:bitmap_640_x_480_2BPP::@5->bitmap_line]
    // [1874] phi bitmap_line::c#12 = bitmap_line::c#7 [phi:bitmap_640_x_480_2BPP::@5->bitmap_line#0] -- register_copy 
    // [1874] phi bitmap_line::y1#12 = $18f [phi:bitmap_640_x_480_2BPP::@5->bitmap_line#1] -- vwuz1=vwuc1 
    lda #<$18f
    sta.z bitmap_line.y1
    lda #>$18f
    sta.z bitmap_line.y1+1
    // [1874] phi bitmap_line::y0#12 = 0 [phi:bitmap_640_x_480_2BPP::@5->bitmap_line#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z bitmap_line.y0
    sta.z bitmap_line.y0+1
    // [1874] phi bitmap_line::x1#12 = bitmap_line::x1#7 [phi:bitmap_640_x_480_2BPP::@5->bitmap_line#3] -- register_copy 
    // [1874] phi bitmap_line::x0#12 = bitmap_line::x0#7 [phi:bitmap_640_x_480_2BPP::@5->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    // bitmap_640_x_480_2BPP::@42
    // color++;
    // [1214] bitmap_640_x_480_2BPP::color#1 = ++ bitmap_640_x_480_2BPP::color#3 -- vbuz1=_inc_vbuz1 
    inc.z color
    // if(color>3)
    // [1215] if(bitmap_640_x_480_2BPP::color#1<3+1) goto bitmap_640_x_480_2BPP::@44 -- vbuz1_lt_vbuc1_then_la1 
    lda.z color
    cmp #3+1
    bcc __b7
    // [1217] phi from bitmap_640_x_480_2BPP::@42 to bitmap_640_x_480_2BPP::@7 [phi:bitmap_640_x_480_2BPP::@42->bitmap_640_x_480_2BPP::@7]
    // [1217] phi bitmap_640_x_480_2BPP::color#7 = 0 [phi:bitmap_640_x_480_2BPP::@42->bitmap_640_x_480_2BPP::@7#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [1216] phi from bitmap_640_x_480_2BPP::@42 to bitmap_640_x_480_2BPP::@44 [phi:bitmap_640_x_480_2BPP::@42->bitmap_640_x_480_2BPP::@44]
    // bitmap_640_x_480_2BPP::@44
    // [1217] phi from bitmap_640_x_480_2BPP::@44 to bitmap_640_x_480_2BPP::@7 [phi:bitmap_640_x_480_2BPP::@44->bitmap_640_x_480_2BPP::@7]
    // [1217] phi bitmap_640_x_480_2BPP::color#7 = bitmap_640_x_480_2BPP::color#1 [phi:bitmap_640_x_480_2BPP::@44->bitmap_640_x_480_2BPP::@7#0] -- register_copy 
    // bitmap_640_x_480_2BPP::@7
  __b7:
    // x++;
    // [1218] bitmap_640_x_480_2BPP::x#1 = ++ bitmap_640_x_480_2BPP::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // if(x>639)
    // [1219] if(bitmap_640_x_480_2BPP::x#1<=$27f) goto bitmap_640_x_480_2BPP::@43 -- vwuz1_le_vwuc1_then_la1 
    lda.z x+1
    cmp #>$27f
    bne !+
    lda.z x
    cmp #<$27f
  !:
    bcc __b4
    beq __b4
    // [1202] phi from bitmap_640_x_480_2BPP::@7 to bitmap_640_x_480_2BPP::@4 [phi:bitmap_640_x_480_2BPP::@7->bitmap_640_x_480_2BPP::@4]
    // [1202] phi bitmap_640_x_480_2BPP::color#3 = bitmap_640_x_480_2BPP::color#7 [phi:bitmap_640_x_480_2BPP::@7->bitmap_640_x_480_2BPP::@4#0] -- register_copy 
    // [1202] phi bitmap_640_x_480_2BPP::x#3 = 0 [phi:bitmap_640_x_480_2BPP::@7->bitmap_640_x_480_2BPP::@4#1] -- vwuz1=vbuc1 
    lda #<0
    sta.z x
    sta.z x+1
    jmp __b4
    // [1220] phi from bitmap_640_x_480_2BPP::@7 to bitmap_640_x_480_2BPP::@43 [phi:bitmap_640_x_480_2BPP::@7->bitmap_640_x_480_2BPP::@43]
    // bitmap_640_x_480_2BPP::@43
    // [1202] phi from bitmap_640_x_480_2BPP::@43 to bitmap_640_x_480_2BPP::@4 [phi:bitmap_640_x_480_2BPP::@43->bitmap_640_x_480_2BPP::@4]
    // [1202] phi bitmap_640_x_480_2BPP::color#3 = bitmap_640_x_480_2BPP::color#7 [phi:bitmap_640_x_480_2BPP::@43->bitmap_640_x_480_2BPP::@4#0] -- register_copy 
    // [1202] phi bitmap_640_x_480_2BPP::x#3 = bitmap_640_x_480_2BPP::x#1 [phi:bitmap_640_x_480_2BPP::@43->bitmap_640_x_480_2BPP::@4#1] -- register_copy 
    // [1221] phi from bitmap_640_x_480_2BPP::@24 to bitmap_640_x_480_2BPP::@2 [phi:bitmap_640_x_480_2BPP::@24->bitmap_640_x_480_2BPP::@2]
    // bitmap_640_x_480_2BPP::@2
  __b2:
    // rand()
    // [1222] call rand
    // [1945] phi from bitmap_640_x_480_2BPP::@2 to rand [phi:bitmap_640_x_480_2BPP::@2->rand]
    // [1945] phi rand_state#50 = rand_state#122 [phi:bitmap_640_x_480_2BPP::@2->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1223] rand::return#17 = rand::return#0
    // bitmap_640_x_480_2BPP::@25
    // modr16u(rand(),639,0)
    // [1224] modr16u::dividend#12 = rand::return#17
    // [1225] call modr16u
    // [1954] phi from bitmap_640_x_480_2BPP::@25 to modr16u [phi:bitmap_640_x_480_2BPP::@25->modr16u]
    // [1954] phi modr16u::divisor#24 = $27f [phi:bitmap_640_x_480_2BPP::@25->modr16u#0] -- vwuz1=vwuc1 
    lda #<$27f
    sta.z modr16u.divisor
    lda #>$27f
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#12 [phi:bitmap_640_x_480_2BPP::@25->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),639,0)
    // [1226] modr16u::return#14 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_1
    lda.z modr16u.return+1
    sta.z modr16u.return_1+1
    // bitmap_640_x_480_2BPP::@26
    // bitmap_line(modr16u(rand(),639,0), modr16u(rand(),639,0), modr16u(rand(),399,0), modr16u(rand(),399,0), rand()&3)
    // [1227] bitmap_line::x0#6 = modr16u::return#14
    // rand()
    // [1228] call rand
    // [1945] phi from bitmap_640_x_480_2BPP::@26 to rand [phi:bitmap_640_x_480_2BPP::@26->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_640_x_480_2BPP::@26->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1229] rand::return#18 = rand::return#0
    // bitmap_640_x_480_2BPP::@27
    // modr16u(rand(),639,0)
    // [1230] modr16u::dividend#13 = rand::return#18
    // [1231] call modr16u
    // [1954] phi from bitmap_640_x_480_2BPP::@27 to modr16u [phi:bitmap_640_x_480_2BPP::@27->modr16u]
    // [1954] phi modr16u::divisor#24 = $27f [phi:bitmap_640_x_480_2BPP::@27->modr16u#0] -- vwuz1=vwuc1 
    lda #<$27f
    sta.z modr16u.divisor
    lda #>$27f
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#13 [phi:bitmap_640_x_480_2BPP::@27->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),639,0)
    // [1232] modr16u::return#15 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_2
    lda.z modr16u.return+1
    sta.z modr16u.return_2+1
    // bitmap_640_x_480_2BPP::@28
    // bitmap_line(modr16u(rand(),639,0), modr16u(rand(),639,0), modr16u(rand(),399,0), modr16u(rand(),399,0), rand()&3)
    // [1233] bitmap_line::x1#6 = modr16u::return#15
    // rand()
    // [1234] call rand
    // [1945] phi from bitmap_640_x_480_2BPP::@28 to rand [phi:bitmap_640_x_480_2BPP::@28->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_640_x_480_2BPP::@28->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1235] rand::return#19 = rand::return#0
    // bitmap_640_x_480_2BPP::@29
    // modr16u(rand(),399,0)
    // [1236] modr16u::dividend#14 = rand::return#19
    // [1237] call modr16u
    // [1954] phi from bitmap_640_x_480_2BPP::@29 to modr16u [phi:bitmap_640_x_480_2BPP::@29->modr16u]
    // [1954] phi modr16u::divisor#24 = $18f [phi:bitmap_640_x_480_2BPP::@29->modr16u#0] -- vwuz1=vwuc1 
    lda #<$18f
    sta.z modr16u.divisor
    lda #>$18f
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#14 [phi:bitmap_640_x_480_2BPP::@29->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),399,0)
    // [1238] modr16u::return#16 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_3
    lda.z modr16u.return+1
    sta.z modr16u.return_3+1
    // bitmap_640_x_480_2BPP::@30
    // bitmap_line(modr16u(rand(),639,0), modr16u(rand(),639,0), modr16u(rand(),399,0), modr16u(rand(),399,0), rand()&3)
    // [1239] bitmap_line::y0#6 = modr16u::return#16
    // rand()
    // [1240] call rand
    // [1945] phi from bitmap_640_x_480_2BPP::@30 to rand [phi:bitmap_640_x_480_2BPP::@30->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_640_x_480_2BPP::@30->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1241] rand::return#20 = rand::return#0
    // bitmap_640_x_480_2BPP::@31
    // modr16u(rand(),399,0)
    // [1242] modr16u::dividend#15 = rand::return#20
    // [1243] call modr16u
    // [1954] phi from bitmap_640_x_480_2BPP::@31 to modr16u [phi:bitmap_640_x_480_2BPP::@31->modr16u]
    // [1954] phi modr16u::divisor#24 = $18f [phi:bitmap_640_x_480_2BPP::@31->modr16u#0] -- vwuz1=vwuc1 
    lda #<$18f
    sta.z modr16u.divisor
    lda #>$18f
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#15 [phi:bitmap_640_x_480_2BPP::@31->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),399,0)
    // [1244] modr16u::return#17 = modr16u::return#0
    // bitmap_640_x_480_2BPP::@32
    // bitmap_line(modr16u(rand(),639,0), modr16u(rand(),639,0), modr16u(rand(),399,0), modr16u(rand(),399,0), rand()&3)
    // [1245] bitmap_line::y1#6 = modr16u::return#17
    // rand()
    // [1246] call rand
    // [1945] phi from bitmap_640_x_480_2BPP::@32 to rand [phi:bitmap_640_x_480_2BPP::@32->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_640_x_480_2BPP::@32->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1247] rand::return#21 = rand::return#0
    // bitmap_640_x_480_2BPP::@33
    // [1248] bitmap_640_x_480_2BPP::$37 = rand::return#21
    // bitmap_line(modr16u(rand(),639,0), modr16u(rand(),639,0), modr16u(rand(),399,0), modr16u(rand(),399,0), rand()&3)
    // [1249] bitmap_line::c#6 = bitmap_640_x_480_2BPP::$37 & 3 -- vbuz1=vwuz2_band_vbuc1 
    lda #3
    and.z __37
    sta.z bitmap_line.c
    // [1250] call bitmap_line
    // [1874] phi from bitmap_640_x_480_2BPP::@33 to bitmap_line [phi:bitmap_640_x_480_2BPP::@33->bitmap_line]
    // [1874] phi bitmap_line::c#12 = bitmap_line::c#6 [phi:bitmap_640_x_480_2BPP::@33->bitmap_line#0] -- register_copy 
    // [1874] phi bitmap_line::y1#12 = bitmap_line::y1#6 [phi:bitmap_640_x_480_2BPP::@33->bitmap_line#1] -- register_copy 
    // [1874] phi bitmap_line::y0#12 = bitmap_line::y0#6 [phi:bitmap_640_x_480_2BPP::@33->bitmap_line#2] -- register_copy 
    // [1874] phi bitmap_line::x1#12 = bitmap_line::x1#6 [phi:bitmap_640_x_480_2BPP::@33->bitmap_line#3] -- register_copy 
    // [1874] phi bitmap_line::x0#12 = bitmap_line::x0#6 [phi:bitmap_640_x_480_2BPP::@33->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    jmp __b1
}
  // bitmap_320_x_240_2BPP
bitmap_320_x_240_2BPP: {
    .label __27 = $66
    .label __37 = $53
    .label __40 = $66
    .label color = $7b
    .label x = $b4
    // cx16_cpy_vram_from_vram(1, 0xF000, 0, 0xF800, 256*8)
    // [1252] call cx16_cpy_vram_from_vram
  // Before we configure the bitmap pane into vera  memory we need to re-arrange a few things!
  // It is better to load all in bank 0, but then there is an issue.
  // So the default CX16 character set is located in bank 0, at address 0xF800.
  // So we need to move this character set to bank 1, suggested is at address 0xF000.
  // The CX16 by default writes textual output to layer 1 in text mode, so we need to
  // realign the moved character set to 0xf000 as the new tile base for layer 1.
  // We also will need to realign for layer 1 the map base from 0x00000 to 0x14000.
  // This is now all easily done with a few statements in the new kickc vera lib ...
    // [1674] phi from bitmap_320_x_240_2BPP to cx16_cpy_vram_from_vram [phi:bitmap_320_x_240_2BPP->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f000 [phi:bitmap_320_x_240_2BPP->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 1 [phi:bitmap_320_x_240_2BPP->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f800 [phi:bitmap_320_x_240_2BPP->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 0 [phi:bitmap_320_x_240_2BPP->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // [1253] phi from bitmap_320_x_240_2BPP to bitmap_320_x_240_2BPP::@9 [phi:bitmap_320_x_240_2BPP->bitmap_320_x_240_2BPP::@9]
    // bitmap_320_x_240_2BPP::@9
    // vera_layer_mode_tile(1, 0x14000, 0x1F000, 128, 64, 8, 8, 1)
    // [1254] call vera_layer_mode_tile
  // We copy the 128 character set of 8 bytes each.
    // [1580] phi from bitmap_320_x_240_2BPP::@9 to vera_layer_mode_tile [phi:bitmap_320_x_240_2BPP::@9->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = 8 [phi:bitmap_320_x_240_2BPP::@9->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = 8 [phi:bitmap_320_x_240_2BPP::@9->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $1f000 [phi:bitmap_320_x_240_2BPP::@9->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$1f000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$1f000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $14000 [phi:bitmap_320_x_240_2BPP::@9->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $40 [phi:bitmap_320_x_240_2BPP::@9->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 1 [phi:bitmap_320_x_240_2BPP::@9->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $80 [phi:bitmap_320_x_240_2BPP::@9->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 1 [phi:bitmap_320_x_240_2BPP::@9->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // [1255] phi from bitmap_320_x_240_2BPP::@9 to bitmap_320_x_240_2BPP::@10 [phi:bitmap_320_x_240_2BPP::@9->bitmap_320_x_240_2BPP::@10]
    // bitmap_320_x_240_2BPP::@10
    // vera_layer_mode_bitmap(0, (dword)0x00000, 320, 2)
    // [1256] call vera_layer_mode_bitmap
    // [1745] phi from bitmap_320_x_240_2BPP::@10 to vera_layer_mode_bitmap [phi:bitmap_320_x_240_2BPP::@10->vera_layer_mode_bitmap]
    // [1745] phi vera_layer_mode_bitmap::mapwidth#10 = $140 [phi:bitmap_320_x_240_2BPP::@10->vera_layer_mode_bitmap#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z vera_layer_mode_bitmap.mapwidth
    lda #>$140
    sta.z vera_layer_mode_bitmap.mapwidth+1
    // [1745] phi vera_layer_mode_bitmap::color_depth#6 = 2 [phi:bitmap_320_x_240_2BPP::@10->vera_layer_mode_bitmap#1] -- vwuz1=vbuc1 
    lda #<2
    sta.z vera_layer_mode_bitmap.color_depth
    lda #>2
    sta.z vera_layer_mode_bitmap.color_depth+1
    jsr vera_layer_mode_bitmap
    // [1257] phi from bitmap_320_x_240_2BPP::@10 to bitmap_320_x_240_2BPP::@11 [phi:bitmap_320_x_240_2BPP::@10->bitmap_320_x_240_2BPP::@11]
    // bitmap_320_x_240_2BPP::@11
    // screenlayer(1)
    // [1258] call screenlayer
    jsr screenlayer
    // [1259] phi from bitmap_320_x_240_2BPP::@11 to bitmap_320_x_240_2BPP::@12 [phi:bitmap_320_x_240_2BPP::@11->bitmap_320_x_240_2BPP::@12]
    // bitmap_320_x_240_2BPP::@12
    // textcolor(WHITE)
    // [1260] call textcolor
    // [274] phi from bitmap_320_x_240_2BPP::@12 to textcolor [phi:bitmap_320_x_240_2BPP::@12->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:bitmap_320_x_240_2BPP::@12->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [1261] phi from bitmap_320_x_240_2BPP::@12 to bitmap_320_x_240_2BPP::@13 [phi:bitmap_320_x_240_2BPP::@12->bitmap_320_x_240_2BPP::@13]
    // bitmap_320_x_240_2BPP::@13
    // bgcolor(BLACK)
    // [1262] call bgcolor
    // [279] phi from bitmap_320_x_240_2BPP::@13 to bgcolor [phi:bitmap_320_x_240_2BPP::@13->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:bitmap_320_x_240_2BPP::@13->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [1263] phi from bitmap_320_x_240_2BPP::@13 to bitmap_320_x_240_2BPP::@14 [phi:bitmap_320_x_240_2BPP::@13->bitmap_320_x_240_2BPP::@14]
    // bitmap_320_x_240_2BPP::@14
    // clrscr()
    // [1264] call clrscr
    jsr clrscr
    // [1265] phi from bitmap_320_x_240_2BPP::@14 to bitmap_320_x_240_2BPP::@15 [phi:bitmap_320_x_240_2BPP::@14->bitmap_320_x_240_2BPP::@15]
    // bitmap_320_x_240_2BPP::@15
    // gotoxy(0,25)
    // [1266] call gotoxy
    // [242] phi from bitmap_320_x_240_2BPP::@15 to gotoxy [phi:bitmap_320_x_240_2BPP::@15->gotoxy]
    // [242] phi gotoxy::y#35 = $19 [phi:bitmap_320_x_240_2BPP::@15->gotoxy#0] -- vbuz1=vbuc1 
    lda #$19
    sta.z gotoxy.y
    jsr gotoxy
    // [1267] phi from bitmap_320_x_240_2BPP::@15 to bitmap_320_x_240_2BPP::@16 [phi:bitmap_320_x_240_2BPP::@15->bitmap_320_x_240_2BPP::@16]
    // bitmap_320_x_240_2BPP::@16
    // printf("vera in bitmap mode,\n")
    // [1268] call printf_str
    // [318] phi from bitmap_320_x_240_2BPP::@16 to printf_str [phi:bitmap_320_x_240_2BPP::@16->printf_str]
    // [318] phi printf_str::s#124 = string_8 [phi:bitmap_320_x_240_2BPP::@16->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_8
    sta.z printf_str.s
    lda #>string_8
    sta.z printf_str.s+1
    jsr printf_str
    // [1269] phi from bitmap_320_x_240_2BPP::@16 to bitmap_320_x_240_2BPP::@17 [phi:bitmap_320_x_240_2BPP::@16->bitmap_320_x_240_2BPP::@17]
    // bitmap_320_x_240_2BPP::@17
    // printf("color depth 2 bits per pixel.\n")
    // [1270] call printf_str
    // [318] phi from bitmap_320_x_240_2BPP::@17 to printf_str [phi:bitmap_320_x_240_2BPP::@17->printf_str]
    // [318] phi printf_str::s#124 = bitmap_320_x_240_2BPP::s1 [phi:bitmap_320_x_240_2BPP::@17->printf_str#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [1271] phi from bitmap_320_x_240_2BPP::@17 to bitmap_320_x_240_2BPP::@18 [phi:bitmap_320_x_240_2BPP::@17->bitmap_320_x_240_2BPP::@18]
    // bitmap_320_x_240_2BPP::@18
    // printf("in this mode, it is possible to display\n")
    // [1272] call printf_str
    // [318] phi from bitmap_320_x_240_2BPP::@18 to printf_str [phi:bitmap_320_x_240_2BPP::@18->printf_str]
    // [318] phi printf_str::s#124 = string_10 [phi:bitmap_320_x_240_2BPP::@18->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_10
    sta.z printf_str.s
    lda #>string_10
    sta.z printf_str.s+1
    jsr printf_str
    // [1273] phi from bitmap_320_x_240_2BPP::@18 to bitmap_320_x_240_2BPP::@19 [phi:bitmap_320_x_240_2BPP::@18->bitmap_320_x_240_2BPP::@19]
    // bitmap_320_x_240_2BPP::@19
    // printf("graphics in 4 colors.\n")
    // [1274] call printf_str
    // [318] phi from bitmap_320_x_240_2BPP::@19 to printf_str [phi:bitmap_320_x_240_2BPP::@19->printf_str]
    // [318] phi printf_str::s#124 = bitmap_320_x_240_2BPP::s3 [phi:bitmap_320_x_240_2BPP::@19->printf_str#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // bitmap_320_x_240_2BPP::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [1275] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [1276] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [1277] phi from bitmap_320_x_240_2BPP::vera_layer_show1 to bitmap_320_x_240_2BPP::@8 [phi:bitmap_320_x_240_2BPP::vera_layer_show1->bitmap_320_x_240_2BPP::@8]
    // bitmap_320_x_240_2BPP::@8
    // bitmap_init(0, 0x00000)
    // [1278] call bitmap_init
    jsr bitmap_init
    // [1279] phi from bitmap_320_x_240_2BPP::@8 to bitmap_320_x_240_2BPP::@20 [phi:bitmap_320_x_240_2BPP::@8->bitmap_320_x_240_2BPP::@20]
    // bitmap_320_x_240_2BPP::@20
    // bitmap_clear()
    // [1280] call bitmap_clear
    jsr bitmap_clear
    // [1281] phi from bitmap_320_x_240_2BPP::@20 to bitmap_320_x_240_2BPP::@21 [phi:bitmap_320_x_240_2BPP::@20->bitmap_320_x_240_2BPP::@21]
    // bitmap_320_x_240_2BPP::@21
    // gotoxy(0,29)
    // [1282] call gotoxy
    // [242] phi from bitmap_320_x_240_2BPP::@21 to gotoxy [phi:bitmap_320_x_240_2BPP::@21->gotoxy]
    // [242] phi gotoxy::y#35 = $1d [phi:bitmap_320_x_240_2BPP::@21->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1d
    sta.z gotoxy.y
    jsr gotoxy
    // [1283] phi from bitmap_320_x_240_2BPP::@21 to bitmap_320_x_240_2BPP::@22 [phi:bitmap_320_x_240_2BPP::@21->bitmap_320_x_240_2BPP::@22]
    // bitmap_320_x_240_2BPP::@22
    // textcolor(YELLOW)
    // [1284] call textcolor
    // [274] phi from bitmap_320_x_240_2BPP::@22 to textcolor [phi:bitmap_320_x_240_2BPP::@22->textcolor]
    // [274] phi textcolor::color#38 = YELLOW [phi:bitmap_320_x_240_2BPP::@22->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [1285] phi from bitmap_320_x_240_2BPP::@22 to bitmap_320_x_240_2BPP::@23 [phi:bitmap_320_x_240_2BPP::@22->bitmap_320_x_240_2BPP::@23]
    // bitmap_320_x_240_2BPP::@23
    // printf("press a key ...")
    // [1286] call printf_str
    // [318] phi from bitmap_320_x_240_2BPP::@23 to printf_str [phi:bitmap_320_x_240_2BPP::@23->printf_str]
    // [318] phi printf_str::s#124 = string_12 [phi:bitmap_320_x_240_2BPP::@23->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_12
    sta.z printf_str.s
    lda #>string_12
    sta.z printf_str.s+1
    jsr printf_str
    // [1287] phi from bitmap_320_x_240_2BPP::@23 bitmap_320_x_240_2BPP::@33 to bitmap_320_x_240_2BPP::@1 [phi:bitmap_320_x_240_2BPP::@23/bitmap_320_x_240_2BPP::@33->bitmap_320_x_240_2BPP::@1]
    // [1287] phi rem16u#104 = rem16u#236 [phi:bitmap_320_x_240_2BPP::@23/bitmap_320_x_240_2BPP::@33->bitmap_320_x_240_2BPP::@1#0] -- register_copy 
    // [1287] phi rand_state#102 = rand_state#246 [phi:bitmap_320_x_240_2BPP::@23/bitmap_320_x_240_2BPP::@33->bitmap_320_x_240_2BPP::@1#1] -- register_copy 
    // bitmap_320_x_240_2BPP::@1
  __b1:
    // getin()
    // [1288] call getin
    jsr getin
    // [1289] getin::return#16 = getin::return#1
    // bitmap_320_x_240_2BPP::@24
    // [1290] bitmap_320_x_240_2BPP::$27 = getin::return#16
    // while(!getin())
    // [1291] if(0==bitmap_320_x_240_2BPP::$27) goto bitmap_320_x_240_2BPP::@2 -- 0_eq_vbuz1_then_la1 
    lda.z __27
    bne !__b2+
    jmp __b2
  !__b2:
    // [1292] phi from bitmap_320_x_240_2BPP::@24 to bitmap_320_x_240_2BPP::@3 [phi:bitmap_320_x_240_2BPP::@24->bitmap_320_x_240_2BPP::@3]
    // bitmap_320_x_240_2BPP::@3
    // textcolor(WHITE)
    // [1293] call textcolor
    // [274] phi from bitmap_320_x_240_2BPP::@3 to textcolor [phi:bitmap_320_x_240_2BPP::@3->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:bitmap_320_x_240_2BPP::@3->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [1294] phi from bitmap_320_x_240_2BPP::@3 to bitmap_320_x_240_2BPP::@34 [phi:bitmap_320_x_240_2BPP::@3->bitmap_320_x_240_2BPP::@34]
    // bitmap_320_x_240_2BPP::@34
    // bgcolor(BLACK)
    // [1295] call bgcolor
    // [279] phi from bitmap_320_x_240_2BPP::@34 to bgcolor [phi:bitmap_320_x_240_2BPP::@34->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:bitmap_320_x_240_2BPP::@34->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [1296] phi from bitmap_320_x_240_2BPP::@34 to bitmap_320_x_240_2BPP::@35 [phi:bitmap_320_x_240_2BPP::@34->bitmap_320_x_240_2BPP::@35]
    // bitmap_320_x_240_2BPP::@35
    // clrscr()
    // [1297] call clrscr
    jsr clrscr
    // [1298] phi from bitmap_320_x_240_2BPP::@35 to bitmap_320_x_240_2BPP::@36 [phi:bitmap_320_x_240_2BPP::@35->bitmap_320_x_240_2BPP::@36]
    // bitmap_320_x_240_2BPP::@36
    // gotoxy(0,26)
    // [1299] call gotoxy
    // [242] phi from bitmap_320_x_240_2BPP::@36 to gotoxy [phi:bitmap_320_x_240_2BPP::@36->gotoxy]
    // [242] phi gotoxy::y#35 = $1a [phi:bitmap_320_x_240_2BPP::@36->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1a
    sta.z gotoxy.y
    jsr gotoxy
    // [1300] phi from bitmap_320_x_240_2BPP::@36 to bitmap_320_x_240_2BPP::@37 [phi:bitmap_320_x_240_2BPP::@36->bitmap_320_x_240_2BPP::@37]
    // bitmap_320_x_240_2BPP::@37
    // printf("here you see all the colors possible.\n")
    // [1301] call printf_str
    // [318] phi from bitmap_320_x_240_2BPP::@37 to printf_str [phi:bitmap_320_x_240_2BPP::@37->printf_str]
    // [318] phi printf_str::s#124 = string_13 [phi:bitmap_320_x_240_2BPP::@37->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_13
    sta.z printf_str.s
    lda #>string_13
    sta.z printf_str.s+1
    jsr printf_str
    // [1302] phi from bitmap_320_x_240_2BPP::@37 to bitmap_320_x_240_2BPP::@38 [phi:bitmap_320_x_240_2BPP::@37->bitmap_320_x_240_2BPP::@38]
    // bitmap_320_x_240_2BPP::@38
    // gotoxy(0,29)
    // [1303] call gotoxy
    // [242] phi from bitmap_320_x_240_2BPP::@38 to gotoxy [phi:bitmap_320_x_240_2BPP::@38->gotoxy]
    // [242] phi gotoxy::y#35 = $1d [phi:bitmap_320_x_240_2BPP::@38->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1d
    sta.z gotoxy.y
    jsr gotoxy
    // [1304] phi from bitmap_320_x_240_2BPP::@38 to bitmap_320_x_240_2BPP::@39 [phi:bitmap_320_x_240_2BPP::@38->bitmap_320_x_240_2BPP::@39]
    // bitmap_320_x_240_2BPP::@39
    // textcolor(YELLOW)
    // [1305] call textcolor
    // [274] phi from bitmap_320_x_240_2BPP::@39 to textcolor [phi:bitmap_320_x_240_2BPP::@39->textcolor]
    // [274] phi textcolor::color#38 = YELLOW [phi:bitmap_320_x_240_2BPP::@39->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [1306] phi from bitmap_320_x_240_2BPP::@39 to bitmap_320_x_240_2BPP::@40 [phi:bitmap_320_x_240_2BPP::@39->bitmap_320_x_240_2BPP::@40]
    // bitmap_320_x_240_2BPP::@40
    // printf("press a key ...")
    // [1307] call printf_str
    // [318] phi from bitmap_320_x_240_2BPP::@40 to printf_str [phi:bitmap_320_x_240_2BPP::@40->printf_str]
    // [318] phi printf_str::s#124 = string_12 [phi:bitmap_320_x_240_2BPP::@40->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_12
    sta.z printf_str.s
    lda #>string_12
    sta.z printf_str.s+1
    jsr printf_str
    // [1308] phi from bitmap_320_x_240_2BPP::@40 to bitmap_320_x_240_2BPP::@4 [phi:bitmap_320_x_240_2BPP::@40->bitmap_320_x_240_2BPP::@4]
    // [1308] phi bitmap_320_x_240_2BPP::color#3 = 0 [phi:bitmap_320_x_240_2BPP::@40->bitmap_320_x_240_2BPP::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [1308] phi bitmap_320_x_240_2BPP::x#3 = 0 [phi:bitmap_320_x_240_2BPP::@40->bitmap_320_x_240_2BPP::@4#1] -- vwuz1=vwuc1 
    sta.z x
    sta.z x+1
    // bitmap_320_x_240_2BPP::@4
  __b4:
    // getin()
    // [1309] call getin
    jsr getin
    // [1310] getin::return#17 = getin::return#1
    // bitmap_320_x_240_2BPP::@41
    // [1311] bitmap_320_x_240_2BPP::$40 = getin::return#17
    // while(!getin())
    // [1312] if(0==bitmap_320_x_240_2BPP::$40) goto bitmap_320_x_240_2BPP::@5 -- 0_eq_vbuz1_then_la1 
    lda.z __40
    beq __b5
    // [1313] phi from bitmap_320_x_240_2BPP::@41 to bitmap_320_x_240_2BPP::@6 [phi:bitmap_320_x_240_2BPP::@41->bitmap_320_x_240_2BPP::@6]
    // bitmap_320_x_240_2BPP::@6
    // cx16_cpy_vram_from_vram(0, 0xF800, 1, 0xF000, 256*8)
    // [1314] call cx16_cpy_vram_from_vram
    // [1674] phi from bitmap_320_x_240_2BPP::@6 to cx16_cpy_vram_from_vram [phi:bitmap_320_x_240_2BPP::@6->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f800 [phi:bitmap_320_x_240_2BPP::@6->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 0 [phi:bitmap_320_x_240_2BPP::@6->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f000 [phi:bitmap_320_x_240_2BPP::@6->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:bitmap_320_x_240_2BPP::@6->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // bitmap_320_x_240_2BPP::@return
    // }
    // [1315] return 
    rts
    // bitmap_320_x_240_2BPP::@5
  __b5:
    // bitmap_line(x, x, 0, 199, color)
    // [1316] bitmap_line::x0#5 = bitmap_320_x_240_2BPP::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x0
    lda.z x+1
    sta.z bitmap_line.x0+1
    // [1317] bitmap_line::x1#5 = bitmap_320_x_240_2BPP::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x1
    lda.z x+1
    sta.z bitmap_line.x1+1
    // [1318] bitmap_line::c#5 = bitmap_320_x_240_2BPP::color#3 -- vbuz1=vbuz2 
    lda.z color
    sta.z bitmap_line.c
    // [1319] call bitmap_line
    // [1874] phi from bitmap_320_x_240_2BPP::@5 to bitmap_line [phi:bitmap_320_x_240_2BPP::@5->bitmap_line]
    // [1874] phi bitmap_line::c#12 = bitmap_line::c#5 [phi:bitmap_320_x_240_2BPP::@5->bitmap_line#0] -- register_copy 
    // [1874] phi bitmap_line::y1#12 = $c7 [phi:bitmap_320_x_240_2BPP::@5->bitmap_line#1] -- vwuz1=vbuc1 
    lda #<$c7
    sta.z bitmap_line.y1
    lda #>$c7
    sta.z bitmap_line.y1+1
    // [1874] phi bitmap_line::y0#12 = 0 [phi:bitmap_320_x_240_2BPP::@5->bitmap_line#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z bitmap_line.y0
    sta.z bitmap_line.y0+1
    // [1874] phi bitmap_line::x1#12 = bitmap_line::x1#5 [phi:bitmap_320_x_240_2BPP::@5->bitmap_line#3] -- register_copy 
    // [1874] phi bitmap_line::x0#12 = bitmap_line::x0#5 [phi:bitmap_320_x_240_2BPP::@5->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    // bitmap_320_x_240_2BPP::@42
    // color++;
    // [1320] bitmap_320_x_240_2BPP::color#1 = ++ bitmap_320_x_240_2BPP::color#3 -- vbuz1=_inc_vbuz1 
    inc.z color
    // if(color>3)
    // [1321] if(bitmap_320_x_240_2BPP::color#1<3+1) goto bitmap_320_x_240_2BPP::@44 -- vbuz1_lt_vbuc1_then_la1 
    lda.z color
    cmp #3+1
    bcc __b7
    // [1323] phi from bitmap_320_x_240_2BPP::@42 to bitmap_320_x_240_2BPP::@7 [phi:bitmap_320_x_240_2BPP::@42->bitmap_320_x_240_2BPP::@7]
    // [1323] phi bitmap_320_x_240_2BPP::color#7 = 0 [phi:bitmap_320_x_240_2BPP::@42->bitmap_320_x_240_2BPP::@7#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [1322] phi from bitmap_320_x_240_2BPP::@42 to bitmap_320_x_240_2BPP::@44 [phi:bitmap_320_x_240_2BPP::@42->bitmap_320_x_240_2BPP::@44]
    // bitmap_320_x_240_2BPP::@44
    // [1323] phi from bitmap_320_x_240_2BPP::@44 to bitmap_320_x_240_2BPP::@7 [phi:bitmap_320_x_240_2BPP::@44->bitmap_320_x_240_2BPP::@7]
    // [1323] phi bitmap_320_x_240_2BPP::color#7 = bitmap_320_x_240_2BPP::color#1 [phi:bitmap_320_x_240_2BPP::@44->bitmap_320_x_240_2BPP::@7#0] -- register_copy 
    // bitmap_320_x_240_2BPP::@7
  __b7:
    // x++;
    // [1324] bitmap_320_x_240_2BPP::x#1 = ++ bitmap_320_x_240_2BPP::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // if(x>319)
    // [1325] if(bitmap_320_x_240_2BPP::x#1<=$13f) goto bitmap_320_x_240_2BPP::@43 -- vwuz1_le_vwuc1_then_la1 
    lda.z x+1
    cmp #>$13f
    bne !+
    lda.z x
    cmp #<$13f
  !:
    bcc __b4
    beq __b4
    // [1308] phi from bitmap_320_x_240_2BPP::@7 to bitmap_320_x_240_2BPP::@4 [phi:bitmap_320_x_240_2BPP::@7->bitmap_320_x_240_2BPP::@4]
    // [1308] phi bitmap_320_x_240_2BPP::color#3 = bitmap_320_x_240_2BPP::color#7 [phi:bitmap_320_x_240_2BPP::@7->bitmap_320_x_240_2BPP::@4#0] -- register_copy 
    // [1308] phi bitmap_320_x_240_2BPP::x#3 = 0 [phi:bitmap_320_x_240_2BPP::@7->bitmap_320_x_240_2BPP::@4#1] -- vwuz1=vbuc1 
    lda #<0
    sta.z x
    sta.z x+1
    jmp __b4
    // [1326] phi from bitmap_320_x_240_2BPP::@7 to bitmap_320_x_240_2BPP::@43 [phi:bitmap_320_x_240_2BPP::@7->bitmap_320_x_240_2BPP::@43]
    // bitmap_320_x_240_2BPP::@43
    // [1308] phi from bitmap_320_x_240_2BPP::@43 to bitmap_320_x_240_2BPP::@4 [phi:bitmap_320_x_240_2BPP::@43->bitmap_320_x_240_2BPP::@4]
    // [1308] phi bitmap_320_x_240_2BPP::color#3 = bitmap_320_x_240_2BPP::color#7 [phi:bitmap_320_x_240_2BPP::@43->bitmap_320_x_240_2BPP::@4#0] -- register_copy 
    // [1308] phi bitmap_320_x_240_2BPP::x#3 = bitmap_320_x_240_2BPP::x#1 [phi:bitmap_320_x_240_2BPP::@43->bitmap_320_x_240_2BPP::@4#1] -- register_copy 
    // [1327] phi from bitmap_320_x_240_2BPP::@24 to bitmap_320_x_240_2BPP::@2 [phi:bitmap_320_x_240_2BPP::@24->bitmap_320_x_240_2BPP::@2]
    // bitmap_320_x_240_2BPP::@2
  __b2:
    // rand()
    // [1328] call rand
    // [1945] phi from bitmap_320_x_240_2BPP::@2 to rand [phi:bitmap_320_x_240_2BPP::@2->rand]
    // [1945] phi rand_state#50 = rand_state#102 [phi:bitmap_320_x_240_2BPP::@2->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1329] rand::return#12 = rand::return#0
    // bitmap_320_x_240_2BPP::@25
    // modr16u(rand(),320,0)
    // [1330] modr16u::dividend#8 = rand::return#12
    // [1331] call modr16u
    // [1954] phi from bitmap_320_x_240_2BPP::@25 to modr16u [phi:bitmap_320_x_240_2BPP::@25->modr16u]
    // [1954] phi modr16u::divisor#24 = $140 [phi:bitmap_320_x_240_2BPP::@25->modr16u#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z modr16u.divisor
    lda #>$140
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#8 [phi:bitmap_320_x_240_2BPP::@25->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),320,0)
    // [1332] modr16u::return#10 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_1
    lda.z modr16u.return+1
    sta.z modr16u.return_1+1
    // bitmap_320_x_240_2BPP::@26
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&3)
    // [1333] bitmap_line::x0#4 = modr16u::return#10
    // rand()
    // [1334] call rand
    // [1945] phi from bitmap_320_x_240_2BPP::@26 to rand [phi:bitmap_320_x_240_2BPP::@26->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_2BPP::@26->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1335] rand::return#13 = rand::return#0
    // bitmap_320_x_240_2BPP::@27
    // modr16u(rand(),320,0)
    // [1336] modr16u::dividend#9 = rand::return#13
    // [1337] call modr16u
    // [1954] phi from bitmap_320_x_240_2BPP::@27 to modr16u [phi:bitmap_320_x_240_2BPP::@27->modr16u]
    // [1954] phi modr16u::divisor#24 = $140 [phi:bitmap_320_x_240_2BPP::@27->modr16u#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z modr16u.divisor
    lda #>$140
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#9 [phi:bitmap_320_x_240_2BPP::@27->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),320,0)
    // [1338] modr16u::return#11 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_2
    lda.z modr16u.return+1
    sta.z modr16u.return_2+1
    // bitmap_320_x_240_2BPP::@28
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&3)
    // [1339] bitmap_line::x1#4 = modr16u::return#11
    // rand()
    // [1340] call rand
    // [1945] phi from bitmap_320_x_240_2BPP::@28 to rand [phi:bitmap_320_x_240_2BPP::@28->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_2BPP::@28->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1341] rand::return#14 = rand::return#0
    // bitmap_320_x_240_2BPP::@29
    // modr16u(rand(),200,0)
    // [1342] modr16u::dividend#10 = rand::return#14
    // [1343] call modr16u
    // [1954] phi from bitmap_320_x_240_2BPP::@29 to modr16u [phi:bitmap_320_x_240_2BPP::@29->modr16u]
    // [1954] phi modr16u::divisor#24 = $c8 [phi:bitmap_320_x_240_2BPP::@29->modr16u#0] -- vwuz1=vbuc1 
    lda #<$c8
    sta.z modr16u.divisor
    lda #>$c8
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#10 [phi:bitmap_320_x_240_2BPP::@29->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),200,0)
    // [1344] modr16u::return#12 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_3
    lda.z modr16u.return+1
    sta.z modr16u.return_3+1
    // bitmap_320_x_240_2BPP::@30
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&3)
    // [1345] bitmap_line::y0#4 = modr16u::return#12
    // rand()
    // [1346] call rand
    // [1945] phi from bitmap_320_x_240_2BPP::@30 to rand [phi:bitmap_320_x_240_2BPP::@30->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_2BPP::@30->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1347] rand::return#15 = rand::return#0
    // bitmap_320_x_240_2BPP::@31
    // modr16u(rand(),200,0)
    // [1348] modr16u::dividend#11 = rand::return#15
    // [1349] call modr16u
    // [1954] phi from bitmap_320_x_240_2BPP::@31 to modr16u [phi:bitmap_320_x_240_2BPP::@31->modr16u]
    // [1954] phi modr16u::divisor#24 = $c8 [phi:bitmap_320_x_240_2BPP::@31->modr16u#0] -- vwuz1=vbuc1 
    lda #<$c8
    sta.z modr16u.divisor
    lda #>$c8
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#11 [phi:bitmap_320_x_240_2BPP::@31->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),200,0)
    // [1350] modr16u::return#13 = modr16u::return#0
    // bitmap_320_x_240_2BPP::@32
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&3)
    // [1351] bitmap_line::y1#4 = modr16u::return#13
    // rand()
    // [1352] call rand
    // [1945] phi from bitmap_320_x_240_2BPP::@32 to rand [phi:bitmap_320_x_240_2BPP::@32->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_2BPP::@32->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1353] rand::return#16 = rand::return#0
    // bitmap_320_x_240_2BPP::@33
    // [1354] bitmap_320_x_240_2BPP::$37 = rand::return#16
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&3)
    // [1355] bitmap_line::c#4 = bitmap_320_x_240_2BPP::$37 & 3 -- vbuz1=vwuz2_band_vbuc1 
    lda #3
    and.z __37
    sta.z bitmap_line.c
    // [1356] call bitmap_line
    // [1874] phi from bitmap_320_x_240_2BPP::@33 to bitmap_line [phi:bitmap_320_x_240_2BPP::@33->bitmap_line]
    // [1874] phi bitmap_line::c#12 = bitmap_line::c#4 [phi:bitmap_320_x_240_2BPP::@33->bitmap_line#0] -- register_copy 
    // [1874] phi bitmap_line::y1#12 = bitmap_line::y1#4 [phi:bitmap_320_x_240_2BPP::@33->bitmap_line#1] -- register_copy 
    // [1874] phi bitmap_line::y0#12 = bitmap_line::y0#4 [phi:bitmap_320_x_240_2BPP::@33->bitmap_line#2] -- register_copy 
    // [1874] phi bitmap_line::x1#12 = bitmap_line::x1#4 [phi:bitmap_320_x_240_2BPP::@33->bitmap_line#3] -- register_copy 
    // [1874] phi bitmap_line::x0#12 = bitmap_line::x0#4 [phi:bitmap_320_x_240_2BPP::@33->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    jmp __b1
  .segment Data
    s1: .text @"color depth 2 bits per pixel.\n"
    .byte 0
    s3: .text @"graphics in 4 colors.\n"
    .byte 0
}
.segment Code
  // bitmap_640_x_480_1BPP
bitmap_640_x_480_1BPP: {
    .label __28 = $66
    .label __38 = $53
    .label __41 = $66
    .label color = $76
    .label x = $ab
    // bitmap_640_x_480_1BPP::vera_display_set_scale_none1
    // *VERA_DC_HSCALE = 128
    // [1358] *VERA_DC_HSCALE = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 128
    // [1359] *VERA_DC_VSCALE = $80 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // [1360] phi from bitmap_640_x_480_1BPP::vera_display_set_scale_none1 to bitmap_640_x_480_1BPP::@8 [phi:bitmap_640_x_480_1BPP::vera_display_set_scale_none1->bitmap_640_x_480_1BPP::@8]
    // bitmap_640_x_480_1BPP::@8
    // cx16_cpy_vram_from_vram(1, 0xF000, 0, 0xF800, 256*8)
    // [1361] call cx16_cpy_vram_from_vram
  // Before we configure the bitmap pane into vera  memory we need to re-arrange a few things!
  // It is better to load all in bank 0, but then there is an issue.
  // So the default CX16 character set is located in bank 0, at address 0xF800.
  // So we need to move this character set to bank 1, suggested is at address 0xF000.
  // The CX16 by default writes textual output to layer 1 in text mode, so we need to
  // realign the moved character set to 0xf000 as the new tile base for layer 1.
  // We also will need to realign for layer 1 the map base from 0x00000 to 0x14000.
  // This is now all easily done with a few statements in the new kickc vera lib ...
    // [1674] phi from bitmap_640_x_480_1BPP::@8 to cx16_cpy_vram_from_vram [phi:bitmap_640_x_480_1BPP::@8->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f000 [phi:bitmap_640_x_480_1BPP::@8->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 1 [phi:bitmap_640_x_480_1BPP::@8->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f800 [phi:bitmap_640_x_480_1BPP::@8->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 0 [phi:bitmap_640_x_480_1BPP::@8->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // [1362] phi from bitmap_640_x_480_1BPP::@8 to bitmap_640_x_480_1BPP::@10 [phi:bitmap_640_x_480_1BPP::@8->bitmap_640_x_480_1BPP::@10]
    // bitmap_640_x_480_1BPP::@10
    // vera_layer_mode_tile(1, 0x14000, 0x1F000, 128, 64, 8, 8, 1)
    // [1363] call vera_layer_mode_tile
  // We copy the 128 character set of 8 bytes each.
    // [1580] phi from bitmap_640_x_480_1BPP::@10 to vera_layer_mode_tile [phi:bitmap_640_x_480_1BPP::@10->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = 8 [phi:bitmap_640_x_480_1BPP::@10->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = 8 [phi:bitmap_640_x_480_1BPP::@10->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $1f000 [phi:bitmap_640_x_480_1BPP::@10->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$1f000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$1f000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $14000 [phi:bitmap_640_x_480_1BPP::@10->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $40 [phi:bitmap_640_x_480_1BPP::@10->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 1 [phi:bitmap_640_x_480_1BPP::@10->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $80 [phi:bitmap_640_x_480_1BPP::@10->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 1 [phi:bitmap_640_x_480_1BPP::@10->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // [1364] phi from bitmap_640_x_480_1BPP::@10 to bitmap_640_x_480_1BPP::@11 [phi:bitmap_640_x_480_1BPP::@10->bitmap_640_x_480_1BPP::@11]
    // bitmap_640_x_480_1BPP::@11
    // vera_layer_mode_bitmap(0, (dword)0x00000, 640, 1)
    // [1365] call vera_layer_mode_bitmap
    // [1745] phi from bitmap_640_x_480_1BPP::@11 to vera_layer_mode_bitmap [phi:bitmap_640_x_480_1BPP::@11->vera_layer_mode_bitmap]
    // [1745] phi vera_layer_mode_bitmap::mapwidth#10 = $280 [phi:bitmap_640_x_480_1BPP::@11->vera_layer_mode_bitmap#0] -- vwuz1=vwuc1 
    lda #<$280
    sta.z vera_layer_mode_bitmap.mapwidth
    lda #>$280
    sta.z vera_layer_mode_bitmap.mapwidth+1
    // [1745] phi vera_layer_mode_bitmap::color_depth#6 = 1 [phi:bitmap_640_x_480_1BPP::@11->vera_layer_mode_bitmap#1] -- vwuz1=vbuc1 
    lda #<1
    sta.z vera_layer_mode_bitmap.color_depth
    lda #>1
    sta.z vera_layer_mode_bitmap.color_depth+1
    jsr vera_layer_mode_bitmap
    // [1366] phi from bitmap_640_x_480_1BPP::@11 to bitmap_640_x_480_1BPP::@12 [phi:bitmap_640_x_480_1BPP::@11->bitmap_640_x_480_1BPP::@12]
    // bitmap_640_x_480_1BPP::@12
    // screenlayer(1)
    // [1367] call screenlayer
    jsr screenlayer
    // [1368] phi from bitmap_640_x_480_1BPP::@12 to bitmap_640_x_480_1BPP::@13 [phi:bitmap_640_x_480_1BPP::@12->bitmap_640_x_480_1BPP::@13]
    // bitmap_640_x_480_1BPP::@13
    // textcolor(WHITE)
    // [1369] call textcolor
    // [274] phi from bitmap_640_x_480_1BPP::@13 to textcolor [phi:bitmap_640_x_480_1BPP::@13->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:bitmap_640_x_480_1BPP::@13->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [1370] phi from bitmap_640_x_480_1BPP::@13 to bitmap_640_x_480_1BPP::@14 [phi:bitmap_640_x_480_1BPP::@13->bitmap_640_x_480_1BPP::@14]
    // bitmap_640_x_480_1BPP::@14
    // bgcolor(BLACK)
    // [1371] call bgcolor
    // [279] phi from bitmap_640_x_480_1BPP::@14 to bgcolor [phi:bitmap_640_x_480_1BPP::@14->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:bitmap_640_x_480_1BPP::@14->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [1372] phi from bitmap_640_x_480_1BPP::@14 to bitmap_640_x_480_1BPP::@15 [phi:bitmap_640_x_480_1BPP::@14->bitmap_640_x_480_1BPP::@15]
    // bitmap_640_x_480_1BPP::@15
    // clrscr()
    // [1373] call clrscr
    jsr clrscr
    // [1374] phi from bitmap_640_x_480_1BPP::@15 to bitmap_640_x_480_1BPP::@16 [phi:bitmap_640_x_480_1BPP::@15->bitmap_640_x_480_1BPP::@16]
    // bitmap_640_x_480_1BPP::@16
    // gotoxy(0,54)
    // [1375] call gotoxy
    // [242] phi from bitmap_640_x_480_1BPP::@16 to gotoxy [phi:bitmap_640_x_480_1BPP::@16->gotoxy]
    // [242] phi gotoxy::y#35 = $36 [phi:bitmap_640_x_480_1BPP::@16->gotoxy#0] -- vbuz1=vbuc1 
    lda #$36
    sta.z gotoxy.y
    jsr gotoxy
    // [1376] phi from bitmap_640_x_480_1BPP::@16 to bitmap_640_x_480_1BPP::@17 [phi:bitmap_640_x_480_1BPP::@16->bitmap_640_x_480_1BPP::@17]
    // bitmap_640_x_480_1BPP::@17
    // printf("vera in bitmap mode,\n")
    // [1377] call printf_str
    // [318] phi from bitmap_640_x_480_1BPP::@17 to printf_str [phi:bitmap_640_x_480_1BPP::@17->printf_str]
    // [318] phi printf_str::s#124 = string_8 [phi:bitmap_640_x_480_1BPP::@17->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_8
    sta.z printf_str.s
    lda #>string_8
    sta.z printf_str.s+1
    jsr printf_str
    // [1378] phi from bitmap_640_x_480_1BPP::@17 to bitmap_640_x_480_1BPP::@18 [phi:bitmap_640_x_480_1BPP::@17->bitmap_640_x_480_1BPP::@18]
    // bitmap_640_x_480_1BPP::@18
    // printf("color depth 1 bits per pixel.\n")
    // [1379] call printf_str
    // [318] phi from bitmap_640_x_480_1BPP::@18 to printf_str [phi:bitmap_640_x_480_1BPP::@18->printf_str]
    // [318] phi printf_str::s#124 = string_9 [phi:bitmap_640_x_480_1BPP::@18->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_9
    sta.z printf_str.s
    lda #>string_9
    sta.z printf_str.s+1
    jsr printf_str
    // [1380] phi from bitmap_640_x_480_1BPP::@18 to bitmap_640_x_480_1BPP::@19 [phi:bitmap_640_x_480_1BPP::@18->bitmap_640_x_480_1BPP::@19]
    // bitmap_640_x_480_1BPP::@19
    // printf("in this mode, it is possible to display\n")
    // [1381] call printf_str
    // [318] phi from bitmap_640_x_480_1BPP::@19 to printf_str [phi:bitmap_640_x_480_1BPP::@19->printf_str]
    // [318] phi printf_str::s#124 = string_10 [phi:bitmap_640_x_480_1BPP::@19->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_10
    sta.z printf_str.s
    lda #>string_10
    sta.z printf_str.s+1
    jsr printf_str
    // [1382] phi from bitmap_640_x_480_1BPP::@19 to bitmap_640_x_480_1BPP::@20 [phi:bitmap_640_x_480_1BPP::@19->bitmap_640_x_480_1BPP::@20]
    // bitmap_640_x_480_1BPP::@20
    // printf("graphics in 2 colors (black or color).\n")
    // [1383] call printf_str
    // [318] phi from bitmap_640_x_480_1BPP::@20 to printf_str [phi:bitmap_640_x_480_1BPP::@20->printf_str]
    // [318] phi printf_str::s#124 = string_11 [phi:bitmap_640_x_480_1BPP::@20->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_11
    sta.z printf_str.s
    lda #>string_11
    sta.z printf_str.s+1
    jsr printf_str
    // bitmap_640_x_480_1BPP::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [1384] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [1385] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [1386] phi from bitmap_640_x_480_1BPP::vera_layer_show1 to bitmap_640_x_480_1BPP::@9 [phi:bitmap_640_x_480_1BPP::vera_layer_show1->bitmap_640_x_480_1BPP::@9]
    // bitmap_640_x_480_1BPP::@9
    // bitmap_init(0, 0x00000)
    // [1387] call bitmap_init
    jsr bitmap_init
    // [1388] phi from bitmap_640_x_480_1BPP::@9 to bitmap_640_x_480_1BPP::@21 [phi:bitmap_640_x_480_1BPP::@9->bitmap_640_x_480_1BPP::@21]
    // bitmap_640_x_480_1BPP::@21
    // bitmap_clear()
    // [1389] call bitmap_clear
    jsr bitmap_clear
    // [1390] phi from bitmap_640_x_480_1BPP::@21 to bitmap_640_x_480_1BPP::@22 [phi:bitmap_640_x_480_1BPP::@21->bitmap_640_x_480_1BPP::@22]
    // bitmap_640_x_480_1BPP::@22
    // gotoxy(0,59)
    // [1391] call gotoxy
    // [242] phi from bitmap_640_x_480_1BPP::@22 to gotoxy [phi:bitmap_640_x_480_1BPP::@22->gotoxy]
    // [242] phi gotoxy::y#35 = $3b [phi:bitmap_640_x_480_1BPP::@22->gotoxy#0] -- vbuz1=vbuc1 
    lda #$3b
    sta.z gotoxy.y
    jsr gotoxy
    // [1392] phi from bitmap_640_x_480_1BPP::@22 to bitmap_640_x_480_1BPP::@23 [phi:bitmap_640_x_480_1BPP::@22->bitmap_640_x_480_1BPP::@23]
    // bitmap_640_x_480_1BPP::@23
    // textcolor(YELLOW)
    // [1393] call textcolor
    // [274] phi from bitmap_640_x_480_1BPP::@23 to textcolor [phi:bitmap_640_x_480_1BPP::@23->textcolor]
    // [274] phi textcolor::color#38 = YELLOW [phi:bitmap_640_x_480_1BPP::@23->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [1394] phi from bitmap_640_x_480_1BPP::@23 to bitmap_640_x_480_1BPP::@24 [phi:bitmap_640_x_480_1BPP::@23->bitmap_640_x_480_1BPP::@24]
    // bitmap_640_x_480_1BPP::@24
    // printf("press a key ...")
    // [1395] call printf_str
    // [318] phi from bitmap_640_x_480_1BPP::@24 to printf_str [phi:bitmap_640_x_480_1BPP::@24->printf_str]
    // [318] phi printf_str::s#124 = string_12 [phi:bitmap_640_x_480_1BPP::@24->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_12
    sta.z printf_str.s
    lda #>string_12
    sta.z printf_str.s+1
    jsr printf_str
    // [1396] phi from bitmap_640_x_480_1BPP::@24 bitmap_640_x_480_1BPP::@34 to bitmap_640_x_480_1BPP::@1 [phi:bitmap_640_x_480_1BPP::@24/bitmap_640_x_480_1BPP::@34->bitmap_640_x_480_1BPP::@1]
    // [1396] phi rem16u#134 = rem16u#236 [phi:bitmap_640_x_480_1BPP::@24/bitmap_640_x_480_1BPP::@34->bitmap_640_x_480_1BPP::@1#0] -- register_copy 
    // [1396] phi rand_state#117 = rand_state#246 [phi:bitmap_640_x_480_1BPP::@24/bitmap_640_x_480_1BPP::@34->bitmap_640_x_480_1BPP::@1#1] -- register_copy 
    // bitmap_640_x_480_1BPP::@1
  __b1:
    // getin()
    // [1397] call getin
    jsr getin
    // [1398] getin::return#14 = getin::return#1
    // bitmap_640_x_480_1BPP::@25
    // [1399] bitmap_640_x_480_1BPP::$28 = getin::return#14
    // while(!getin())
    // [1400] if(0==bitmap_640_x_480_1BPP::$28) goto bitmap_640_x_480_1BPP::@2 -- 0_eq_vbuz1_then_la1 
    lda.z __28
    bne !__b2+
    jmp __b2
  !__b2:
    // [1401] phi from bitmap_640_x_480_1BPP::@25 to bitmap_640_x_480_1BPP::@3 [phi:bitmap_640_x_480_1BPP::@25->bitmap_640_x_480_1BPP::@3]
    // bitmap_640_x_480_1BPP::@3
    // textcolor(WHITE)
    // [1402] call textcolor
    // [274] phi from bitmap_640_x_480_1BPP::@3 to textcolor [phi:bitmap_640_x_480_1BPP::@3->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:bitmap_640_x_480_1BPP::@3->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [1403] phi from bitmap_640_x_480_1BPP::@3 to bitmap_640_x_480_1BPP::@35 [phi:bitmap_640_x_480_1BPP::@3->bitmap_640_x_480_1BPP::@35]
    // bitmap_640_x_480_1BPP::@35
    // bgcolor(BLACK)
    // [1404] call bgcolor
    // [279] phi from bitmap_640_x_480_1BPP::@35 to bgcolor [phi:bitmap_640_x_480_1BPP::@35->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:bitmap_640_x_480_1BPP::@35->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [1405] phi from bitmap_640_x_480_1BPP::@35 to bitmap_640_x_480_1BPP::@36 [phi:bitmap_640_x_480_1BPP::@35->bitmap_640_x_480_1BPP::@36]
    // bitmap_640_x_480_1BPP::@36
    // clrscr()
    // [1406] call clrscr
    jsr clrscr
    // [1407] phi from bitmap_640_x_480_1BPP::@36 to bitmap_640_x_480_1BPP::@37 [phi:bitmap_640_x_480_1BPP::@36->bitmap_640_x_480_1BPP::@37]
    // bitmap_640_x_480_1BPP::@37
    // gotoxy(0,54)
    // [1408] call gotoxy
    // [242] phi from bitmap_640_x_480_1BPP::@37 to gotoxy [phi:bitmap_640_x_480_1BPP::@37->gotoxy]
    // [242] phi gotoxy::y#35 = $36 [phi:bitmap_640_x_480_1BPP::@37->gotoxy#0] -- vbuz1=vbuc1 
    lda #$36
    sta.z gotoxy.y
    jsr gotoxy
    // [1409] phi from bitmap_640_x_480_1BPP::@37 to bitmap_640_x_480_1BPP::@38 [phi:bitmap_640_x_480_1BPP::@37->bitmap_640_x_480_1BPP::@38]
    // bitmap_640_x_480_1BPP::@38
    // printf("here you see all the colors possible.\n")
    // [1410] call printf_str
    // [318] phi from bitmap_640_x_480_1BPP::@38 to printf_str [phi:bitmap_640_x_480_1BPP::@38->printf_str]
    // [318] phi printf_str::s#124 = string_13 [phi:bitmap_640_x_480_1BPP::@38->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_13
    sta.z printf_str.s
    lda #>string_13
    sta.z printf_str.s+1
    jsr printf_str
    // [1411] phi from bitmap_640_x_480_1BPP::@38 to bitmap_640_x_480_1BPP::@39 [phi:bitmap_640_x_480_1BPP::@38->bitmap_640_x_480_1BPP::@39]
    // bitmap_640_x_480_1BPP::@39
    // gotoxy(0,59)
    // [1412] call gotoxy
    // [242] phi from bitmap_640_x_480_1BPP::@39 to gotoxy [phi:bitmap_640_x_480_1BPP::@39->gotoxy]
    // [242] phi gotoxy::y#35 = $3b [phi:bitmap_640_x_480_1BPP::@39->gotoxy#0] -- vbuz1=vbuc1 
    lda #$3b
    sta.z gotoxy.y
    jsr gotoxy
    // [1413] phi from bitmap_640_x_480_1BPP::@39 to bitmap_640_x_480_1BPP::@40 [phi:bitmap_640_x_480_1BPP::@39->bitmap_640_x_480_1BPP::@40]
    // bitmap_640_x_480_1BPP::@40
    // textcolor(YELLOW)
    // [1414] call textcolor
    // [274] phi from bitmap_640_x_480_1BPP::@40 to textcolor [phi:bitmap_640_x_480_1BPP::@40->textcolor]
    // [274] phi textcolor::color#38 = YELLOW [phi:bitmap_640_x_480_1BPP::@40->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [1415] phi from bitmap_640_x_480_1BPP::@40 to bitmap_640_x_480_1BPP::@41 [phi:bitmap_640_x_480_1BPP::@40->bitmap_640_x_480_1BPP::@41]
    // bitmap_640_x_480_1BPP::@41
    // printf("press a key ...")
    // [1416] call printf_str
    // [318] phi from bitmap_640_x_480_1BPP::@41 to printf_str [phi:bitmap_640_x_480_1BPP::@41->printf_str]
    // [318] phi printf_str::s#124 = string_12 [phi:bitmap_640_x_480_1BPP::@41->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_12
    sta.z printf_str.s
    lda #>string_12
    sta.z printf_str.s+1
    jsr printf_str
    // [1417] phi from bitmap_640_x_480_1BPP::@41 to bitmap_640_x_480_1BPP::@4 [phi:bitmap_640_x_480_1BPP::@41->bitmap_640_x_480_1BPP::@4]
    // [1417] phi bitmap_640_x_480_1BPP::color#3 = 0 [phi:bitmap_640_x_480_1BPP::@41->bitmap_640_x_480_1BPP::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [1417] phi bitmap_640_x_480_1BPP::x#3 = 0 [phi:bitmap_640_x_480_1BPP::@41->bitmap_640_x_480_1BPP::@4#1] -- vwuz1=vwuc1 
    sta.z x
    sta.z x+1
    // bitmap_640_x_480_1BPP::@4
  __b4:
    // getin()
    // [1418] call getin
    jsr getin
    // [1419] getin::return#15 = getin::return#1
    // bitmap_640_x_480_1BPP::@42
    // [1420] bitmap_640_x_480_1BPP::$41 = getin::return#15
    // while(!getin())
    // [1421] if(0==bitmap_640_x_480_1BPP::$41) goto bitmap_640_x_480_1BPP::@5 -- 0_eq_vbuz1_then_la1 
    lda.z __41
    beq __b5
    // [1422] phi from bitmap_640_x_480_1BPP::@42 to bitmap_640_x_480_1BPP::@6 [phi:bitmap_640_x_480_1BPP::@42->bitmap_640_x_480_1BPP::@6]
    // bitmap_640_x_480_1BPP::@6
    // cx16_cpy_vram_from_vram(0, 0xF800, 1, 0xF000, 256*8)
    // [1423] call cx16_cpy_vram_from_vram
    // [1674] phi from bitmap_640_x_480_1BPP::@6 to cx16_cpy_vram_from_vram [phi:bitmap_640_x_480_1BPP::@6->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f800 [phi:bitmap_640_x_480_1BPP::@6->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 0 [phi:bitmap_640_x_480_1BPP::@6->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f000 [phi:bitmap_640_x_480_1BPP::@6->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:bitmap_640_x_480_1BPP::@6->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // bitmap_640_x_480_1BPP::@return
    // }
    // [1424] return 
    rts
    // bitmap_640_x_480_1BPP::@5
  __b5:
    // bitmap_line(x, x, 0, 399, color)
    // [1425] bitmap_line::x0#3 = bitmap_640_x_480_1BPP::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x0
    lda.z x+1
    sta.z bitmap_line.x0+1
    // [1426] bitmap_line::x1#3 = bitmap_640_x_480_1BPP::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x1
    lda.z x+1
    sta.z bitmap_line.x1+1
    // [1427] bitmap_line::c#3 = bitmap_640_x_480_1BPP::color#3 -- vbuz1=vbuz2 
    lda.z color
    sta.z bitmap_line.c
    // [1428] call bitmap_line
    // [1874] phi from bitmap_640_x_480_1BPP::@5 to bitmap_line [phi:bitmap_640_x_480_1BPP::@5->bitmap_line]
    // [1874] phi bitmap_line::c#12 = bitmap_line::c#3 [phi:bitmap_640_x_480_1BPP::@5->bitmap_line#0] -- register_copy 
    // [1874] phi bitmap_line::y1#12 = $18f [phi:bitmap_640_x_480_1BPP::@5->bitmap_line#1] -- vwuz1=vwuc1 
    lda #<$18f
    sta.z bitmap_line.y1
    lda #>$18f
    sta.z bitmap_line.y1+1
    // [1874] phi bitmap_line::y0#12 = 0 [phi:bitmap_640_x_480_1BPP::@5->bitmap_line#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z bitmap_line.y0
    sta.z bitmap_line.y0+1
    // [1874] phi bitmap_line::x1#12 = bitmap_line::x1#3 [phi:bitmap_640_x_480_1BPP::@5->bitmap_line#3] -- register_copy 
    // [1874] phi bitmap_line::x0#12 = bitmap_line::x0#3 [phi:bitmap_640_x_480_1BPP::@5->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    // bitmap_640_x_480_1BPP::@43
    // color++;
    // [1429] bitmap_640_x_480_1BPP::color#1 = ++ bitmap_640_x_480_1BPP::color#3 -- vbuz1=_inc_vbuz1 
    inc.z color
    // if(color>1)
    // [1430] if(bitmap_640_x_480_1BPP::color#1<1+1) goto bitmap_640_x_480_1BPP::@45 -- vbuz1_lt_vbuc1_then_la1 
    lda.z color
    cmp #1+1
    bcc __b7
    // [1432] phi from bitmap_640_x_480_1BPP::@43 to bitmap_640_x_480_1BPP::@7 [phi:bitmap_640_x_480_1BPP::@43->bitmap_640_x_480_1BPP::@7]
    // [1432] phi bitmap_640_x_480_1BPP::color#7 = 0 [phi:bitmap_640_x_480_1BPP::@43->bitmap_640_x_480_1BPP::@7#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [1431] phi from bitmap_640_x_480_1BPP::@43 to bitmap_640_x_480_1BPP::@45 [phi:bitmap_640_x_480_1BPP::@43->bitmap_640_x_480_1BPP::@45]
    // bitmap_640_x_480_1BPP::@45
    // [1432] phi from bitmap_640_x_480_1BPP::@45 to bitmap_640_x_480_1BPP::@7 [phi:bitmap_640_x_480_1BPP::@45->bitmap_640_x_480_1BPP::@7]
    // [1432] phi bitmap_640_x_480_1BPP::color#7 = bitmap_640_x_480_1BPP::color#1 [phi:bitmap_640_x_480_1BPP::@45->bitmap_640_x_480_1BPP::@7#0] -- register_copy 
    // bitmap_640_x_480_1BPP::@7
  __b7:
    // x++;
    // [1433] bitmap_640_x_480_1BPP::x#1 = ++ bitmap_640_x_480_1BPP::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // if(x>639)
    // [1434] if(bitmap_640_x_480_1BPP::x#1<=$27f) goto bitmap_640_x_480_1BPP::@44 -- vwuz1_le_vwuc1_then_la1 
    lda.z x+1
    cmp #>$27f
    bne !+
    lda.z x
    cmp #<$27f
  !:
    bcc __b4
    beq __b4
    // [1417] phi from bitmap_640_x_480_1BPP::@7 to bitmap_640_x_480_1BPP::@4 [phi:bitmap_640_x_480_1BPP::@7->bitmap_640_x_480_1BPP::@4]
    // [1417] phi bitmap_640_x_480_1BPP::color#3 = bitmap_640_x_480_1BPP::color#7 [phi:bitmap_640_x_480_1BPP::@7->bitmap_640_x_480_1BPP::@4#0] -- register_copy 
    // [1417] phi bitmap_640_x_480_1BPP::x#3 = 0 [phi:bitmap_640_x_480_1BPP::@7->bitmap_640_x_480_1BPP::@4#1] -- vwuz1=vbuc1 
    lda #<0
    sta.z x
    sta.z x+1
    jmp __b4
    // [1435] phi from bitmap_640_x_480_1BPP::@7 to bitmap_640_x_480_1BPP::@44 [phi:bitmap_640_x_480_1BPP::@7->bitmap_640_x_480_1BPP::@44]
    // bitmap_640_x_480_1BPP::@44
    // [1417] phi from bitmap_640_x_480_1BPP::@44 to bitmap_640_x_480_1BPP::@4 [phi:bitmap_640_x_480_1BPP::@44->bitmap_640_x_480_1BPP::@4]
    // [1417] phi bitmap_640_x_480_1BPP::color#3 = bitmap_640_x_480_1BPP::color#7 [phi:bitmap_640_x_480_1BPP::@44->bitmap_640_x_480_1BPP::@4#0] -- register_copy 
    // [1417] phi bitmap_640_x_480_1BPP::x#3 = bitmap_640_x_480_1BPP::x#1 [phi:bitmap_640_x_480_1BPP::@44->bitmap_640_x_480_1BPP::@4#1] -- register_copy 
    // [1436] phi from bitmap_640_x_480_1BPP::@25 to bitmap_640_x_480_1BPP::@2 [phi:bitmap_640_x_480_1BPP::@25->bitmap_640_x_480_1BPP::@2]
    // bitmap_640_x_480_1BPP::@2
  __b2:
    // rand()
    // [1437] call rand
    // [1945] phi from bitmap_640_x_480_1BPP::@2 to rand [phi:bitmap_640_x_480_1BPP::@2->rand]
    // [1945] phi rand_state#50 = rand_state#117 [phi:bitmap_640_x_480_1BPP::@2->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1438] rand::return#38 = rand::return#0
    // bitmap_640_x_480_1BPP::@26
    // modr16u(rand(),639,0)
    // [1439] modr16u::dividend#4 = rand::return#38
    // [1440] call modr16u
    // [1954] phi from bitmap_640_x_480_1BPP::@26 to modr16u [phi:bitmap_640_x_480_1BPP::@26->modr16u]
    // [1954] phi modr16u::divisor#24 = $27f [phi:bitmap_640_x_480_1BPP::@26->modr16u#0] -- vwuz1=vwuc1 
    lda #<$27f
    sta.z modr16u.divisor
    lda #>$27f
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#4 [phi:bitmap_640_x_480_1BPP::@26->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),639,0)
    // [1441] modr16u::return#31 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_1
    lda.z modr16u.return+1
    sta.z modr16u.return_1+1
    // bitmap_640_x_480_1BPP::@27
    // bitmap_line(modr16u(rand(),639,0), modr16u(rand(),639,0), modr16u(rand(),399,0), modr16u(rand(),399,0), rand()&1)
    // [1442] bitmap_line::x0#2 = modr16u::return#31
    // rand()
    // [1443] call rand
    // [1945] phi from bitmap_640_x_480_1BPP::@27 to rand [phi:bitmap_640_x_480_1BPP::@27->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_640_x_480_1BPP::@27->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1444] rand::return#39 = rand::return#0
    // bitmap_640_x_480_1BPP::@28
    // modr16u(rand(),639,0)
    // [1445] modr16u::dividend#5 = rand::return#39
    // [1446] call modr16u
    // [1954] phi from bitmap_640_x_480_1BPP::@28 to modr16u [phi:bitmap_640_x_480_1BPP::@28->modr16u]
    // [1954] phi modr16u::divisor#24 = $27f [phi:bitmap_640_x_480_1BPP::@28->modr16u#0] -- vwuz1=vwuc1 
    lda #<$27f
    sta.z modr16u.divisor
    lda #>$27f
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#5 [phi:bitmap_640_x_480_1BPP::@28->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),639,0)
    // [1447] modr16u::return#32 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_2
    lda.z modr16u.return+1
    sta.z modr16u.return_2+1
    // bitmap_640_x_480_1BPP::@29
    // bitmap_line(modr16u(rand(),639,0), modr16u(rand(),639,0), modr16u(rand(),399,0), modr16u(rand(),399,0), rand()&1)
    // [1448] bitmap_line::x1#2 = modr16u::return#32
    // rand()
    // [1449] call rand
    // [1945] phi from bitmap_640_x_480_1BPP::@29 to rand [phi:bitmap_640_x_480_1BPP::@29->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_640_x_480_1BPP::@29->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1450] rand::return#40 = rand::return#0
    // bitmap_640_x_480_1BPP::@30
    // modr16u(rand(),399,0)
    // [1451] modr16u::dividend#6 = rand::return#40
    // [1452] call modr16u
    // [1954] phi from bitmap_640_x_480_1BPP::@30 to modr16u [phi:bitmap_640_x_480_1BPP::@30->modr16u]
    // [1954] phi modr16u::divisor#24 = $18f [phi:bitmap_640_x_480_1BPP::@30->modr16u#0] -- vwuz1=vwuc1 
    lda #<$18f
    sta.z modr16u.divisor
    lda #>$18f
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#6 [phi:bitmap_640_x_480_1BPP::@30->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),399,0)
    // [1453] modr16u::return#33 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_3
    lda.z modr16u.return+1
    sta.z modr16u.return_3+1
    // bitmap_640_x_480_1BPP::@31
    // bitmap_line(modr16u(rand(),639,0), modr16u(rand(),639,0), modr16u(rand(),399,0), modr16u(rand(),399,0), rand()&1)
    // [1454] bitmap_line::y0#2 = modr16u::return#33
    // rand()
    // [1455] call rand
    // [1945] phi from bitmap_640_x_480_1BPP::@31 to rand [phi:bitmap_640_x_480_1BPP::@31->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_640_x_480_1BPP::@31->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1456] rand::return#10 = rand::return#0
    // bitmap_640_x_480_1BPP::@32
    // modr16u(rand(),399,0)
    // [1457] modr16u::dividend#7 = rand::return#10
    // [1458] call modr16u
    // [1954] phi from bitmap_640_x_480_1BPP::@32 to modr16u [phi:bitmap_640_x_480_1BPP::@32->modr16u]
    // [1954] phi modr16u::divisor#24 = $18f [phi:bitmap_640_x_480_1BPP::@32->modr16u#0] -- vwuz1=vwuc1 
    lda #<$18f
    sta.z modr16u.divisor
    lda #>$18f
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#7 [phi:bitmap_640_x_480_1BPP::@32->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),399,0)
    // [1459] modr16u::return#34 = modr16u::return#0
    // bitmap_640_x_480_1BPP::@33
    // bitmap_line(modr16u(rand(),639,0), modr16u(rand(),639,0), modr16u(rand(),399,0), modr16u(rand(),399,0), rand()&1)
    // [1460] bitmap_line::y1#2 = modr16u::return#34
    // rand()
    // [1461] call rand
    // [1945] phi from bitmap_640_x_480_1BPP::@33 to rand [phi:bitmap_640_x_480_1BPP::@33->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_640_x_480_1BPP::@33->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1462] rand::return#11 = rand::return#0
    // bitmap_640_x_480_1BPP::@34
    // [1463] bitmap_640_x_480_1BPP::$38 = rand::return#11
    // bitmap_line(modr16u(rand(),639,0), modr16u(rand(),639,0), modr16u(rand(),399,0), modr16u(rand(),399,0), rand()&1)
    // [1464] bitmap_line::c#2 = bitmap_640_x_480_1BPP::$38 & 1 -- vbuz1=vwuz2_band_vbuc1 
    lda #1
    and.z __38
    sta.z bitmap_line.c
    // [1465] call bitmap_line
    // [1874] phi from bitmap_640_x_480_1BPP::@34 to bitmap_line [phi:bitmap_640_x_480_1BPP::@34->bitmap_line]
    // [1874] phi bitmap_line::c#12 = bitmap_line::c#2 [phi:bitmap_640_x_480_1BPP::@34->bitmap_line#0] -- register_copy 
    // [1874] phi bitmap_line::y1#12 = bitmap_line::y1#2 [phi:bitmap_640_x_480_1BPP::@34->bitmap_line#1] -- register_copy 
    // [1874] phi bitmap_line::y0#12 = bitmap_line::y0#2 [phi:bitmap_640_x_480_1BPP::@34->bitmap_line#2] -- register_copy 
    // [1874] phi bitmap_line::x1#12 = bitmap_line::x1#2 [phi:bitmap_640_x_480_1BPP::@34->bitmap_line#3] -- register_copy 
    // [1874] phi bitmap_line::x0#12 = bitmap_line::x0#2 [phi:bitmap_640_x_480_1BPP::@34->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    jmp __b1
}
  // bitmap_320_x_240_1BPP
bitmap_320_x_240_1BPP: {
    .label __27 = $66
    .label __37 = $53
    .label __40 = $66
    .label color = $ae
    .label x = $b8
    // cx16_cpy_vram_from_vram(1, 0xF000, 0, 0xF800, 256*8)
    // [1467] call cx16_cpy_vram_from_vram
  // Before we configure the bitmap pane into vera  memory we need to re-arrange a few things!
  // It is better to load all in bank 0, but then there is an issue.
  // So the default CX16 character set is located in bank 0, at address 0xF800.
  // So we need to move this character set to bank 1, suggested is at address 0xF000.
  // The CX16 by default writes textual output to layer 1 in text mode, so we need to
  // realign the moved character set to 0xf000 as the new tile base for layer 1.
  // We also will need to realign for layer 1 the map base from 0x00000 to 0x14000.
  // This is now all easily done with a few statements in the new kickc vera lib ...
    // [1674] phi from bitmap_320_x_240_1BPP to cx16_cpy_vram_from_vram [phi:bitmap_320_x_240_1BPP->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f000 [phi:bitmap_320_x_240_1BPP->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 1 [phi:bitmap_320_x_240_1BPP->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f800 [phi:bitmap_320_x_240_1BPP->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 0 [phi:bitmap_320_x_240_1BPP->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // [1468] phi from bitmap_320_x_240_1BPP to bitmap_320_x_240_1BPP::@9 [phi:bitmap_320_x_240_1BPP->bitmap_320_x_240_1BPP::@9]
    // bitmap_320_x_240_1BPP::@9
    // vera_layer_mode_bitmap(0, (dword)0x00000, 320, 1)
    // [1469] call vera_layer_mode_bitmap
  // We copy the 128 character set of 8 bytes each.
    // [1745] phi from bitmap_320_x_240_1BPP::@9 to vera_layer_mode_bitmap [phi:bitmap_320_x_240_1BPP::@9->vera_layer_mode_bitmap]
    // [1745] phi vera_layer_mode_bitmap::mapwidth#10 = $140 [phi:bitmap_320_x_240_1BPP::@9->vera_layer_mode_bitmap#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z vera_layer_mode_bitmap.mapwidth
    lda #>$140
    sta.z vera_layer_mode_bitmap.mapwidth+1
    // [1745] phi vera_layer_mode_bitmap::color_depth#6 = 1 [phi:bitmap_320_x_240_1BPP::@9->vera_layer_mode_bitmap#1] -- vwuz1=vbuc1 
    lda #<1
    sta.z vera_layer_mode_bitmap.color_depth
    lda #>1
    sta.z vera_layer_mode_bitmap.color_depth+1
    jsr vera_layer_mode_bitmap
    // [1470] phi from bitmap_320_x_240_1BPP::@9 to bitmap_320_x_240_1BPP::@10 [phi:bitmap_320_x_240_1BPP::@9->bitmap_320_x_240_1BPP::@10]
    // bitmap_320_x_240_1BPP::@10
    // vera_layer_mode_tile(1, 0x14000, 0x1F000, 128, 64, 8, 8, 1)
    // [1471] call vera_layer_mode_tile
    // [1580] phi from bitmap_320_x_240_1BPP::@10 to vera_layer_mode_tile [phi:bitmap_320_x_240_1BPP::@10->vera_layer_mode_tile]
    // [1580] phi vera_layer_mode_tile::tileheight#14 = 8 [phi:bitmap_320_x_240_1BPP::@10->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [1580] phi vera_layer_mode_tile::tilewidth#14 = 8 [phi:bitmap_320_x_240_1BPP::@10->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [1580] phi vera_layer_mode_tile::tilebase_address#15 = $1f000 [phi:bitmap_320_x_240_1BPP::@10->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$1f000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$1f000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [1580] phi vera_layer_mode_tile::mapbase_address#15 = $14000 [phi:bitmap_320_x_240_1BPP::@10->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [1580] phi vera_layer_mode_tile::mapheight#14 = $40 [phi:bitmap_320_x_240_1BPP::@10->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [1580] phi vera_layer_mode_tile::layer#14 = 1 [phi:bitmap_320_x_240_1BPP::@10->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.layer
    // [1580] phi vera_layer_mode_tile::mapwidth#14 = $80 [phi:bitmap_320_x_240_1BPP::@10->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [1580] phi vera_layer_mode_tile::color_depth#14 = 1 [phi:bitmap_320_x_240_1BPP::@10->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // [1472] phi from bitmap_320_x_240_1BPP::@10 to bitmap_320_x_240_1BPP::@11 [phi:bitmap_320_x_240_1BPP::@10->bitmap_320_x_240_1BPP::@11]
    // bitmap_320_x_240_1BPP::@11
    // screenlayer(1)
    // [1473] call screenlayer
    jsr screenlayer
    // [1474] phi from bitmap_320_x_240_1BPP::@11 to bitmap_320_x_240_1BPP::@12 [phi:bitmap_320_x_240_1BPP::@11->bitmap_320_x_240_1BPP::@12]
    // bitmap_320_x_240_1BPP::@12
    // textcolor(WHITE)
    // [1475] call textcolor
    // [274] phi from bitmap_320_x_240_1BPP::@12 to textcolor [phi:bitmap_320_x_240_1BPP::@12->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:bitmap_320_x_240_1BPP::@12->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [1476] phi from bitmap_320_x_240_1BPP::@12 to bitmap_320_x_240_1BPP::@13 [phi:bitmap_320_x_240_1BPP::@12->bitmap_320_x_240_1BPP::@13]
    // bitmap_320_x_240_1BPP::@13
    // bgcolor(BLACK)
    // [1477] call bgcolor
    // [279] phi from bitmap_320_x_240_1BPP::@13 to bgcolor [phi:bitmap_320_x_240_1BPP::@13->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:bitmap_320_x_240_1BPP::@13->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [1478] phi from bitmap_320_x_240_1BPP::@13 to bitmap_320_x_240_1BPP::@14 [phi:bitmap_320_x_240_1BPP::@13->bitmap_320_x_240_1BPP::@14]
    // bitmap_320_x_240_1BPP::@14
    // clrscr()
    // [1479] call clrscr
    jsr clrscr
    // [1480] phi from bitmap_320_x_240_1BPP::@14 to bitmap_320_x_240_1BPP::@15 [phi:bitmap_320_x_240_1BPP::@14->bitmap_320_x_240_1BPP::@15]
    // bitmap_320_x_240_1BPP::@15
    // gotoxy(0,25)
    // [1481] call gotoxy
    // [242] phi from bitmap_320_x_240_1BPP::@15 to gotoxy [phi:bitmap_320_x_240_1BPP::@15->gotoxy]
    // [242] phi gotoxy::y#35 = $19 [phi:bitmap_320_x_240_1BPP::@15->gotoxy#0] -- vbuz1=vbuc1 
    lda #$19
    sta.z gotoxy.y
    jsr gotoxy
    // [1482] phi from bitmap_320_x_240_1BPP::@15 to bitmap_320_x_240_1BPP::@16 [phi:bitmap_320_x_240_1BPP::@15->bitmap_320_x_240_1BPP::@16]
    // bitmap_320_x_240_1BPP::@16
    // printf("vera in bitmap mode,\n")
    // [1483] call printf_str
    // [318] phi from bitmap_320_x_240_1BPP::@16 to printf_str [phi:bitmap_320_x_240_1BPP::@16->printf_str]
    // [318] phi printf_str::s#124 = string_8 [phi:bitmap_320_x_240_1BPP::@16->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_8
    sta.z printf_str.s
    lda #>string_8
    sta.z printf_str.s+1
    jsr printf_str
    // [1484] phi from bitmap_320_x_240_1BPP::@16 to bitmap_320_x_240_1BPP::@17 [phi:bitmap_320_x_240_1BPP::@16->bitmap_320_x_240_1BPP::@17]
    // bitmap_320_x_240_1BPP::@17
    // printf("color depth 1 bits per pixel.\n")
    // [1485] call printf_str
    // [318] phi from bitmap_320_x_240_1BPP::@17 to printf_str [phi:bitmap_320_x_240_1BPP::@17->printf_str]
    // [318] phi printf_str::s#124 = string_9 [phi:bitmap_320_x_240_1BPP::@17->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_9
    sta.z printf_str.s
    lda #>string_9
    sta.z printf_str.s+1
    jsr printf_str
    // [1486] phi from bitmap_320_x_240_1BPP::@17 to bitmap_320_x_240_1BPP::@18 [phi:bitmap_320_x_240_1BPP::@17->bitmap_320_x_240_1BPP::@18]
    // bitmap_320_x_240_1BPP::@18
    // printf("in this mode, it is possible to display\n")
    // [1487] call printf_str
    // [318] phi from bitmap_320_x_240_1BPP::@18 to printf_str [phi:bitmap_320_x_240_1BPP::@18->printf_str]
    // [318] phi printf_str::s#124 = string_10 [phi:bitmap_320_x_240_1BPP::@18->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_10
    sta.z printf_str.s
    lda #>string_10
    sta.z printf_str.s+1
    jsr printf_str
    // [1488] phi from bitmap_320_x_240_1BPP::@18 to bitmap_320_x_240_1BPP::@19 [phi:bitmap_320_x_240_1BPP::@18->bitmap_320_x_240_1BPP::@19]
    // bitmap_320_x_240_1BPP::@19
    // printf("graphics in 2 colors (black or color).\n")
    // [1489] call printf_str
    // [318] phi from bitmap_320_x_240_1BPP::@19 to printf_str [phi:bitmap_320_x_240_1BPP::@19->printf_str]
    // [318] phi printf_str::s#124 = string_11 [phi:bitmap_320_x_240_1BPP::@19->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_11
    sta.z printf_str.s
    lda #>string_11
    sta.z printf_str.s+1
    jsr printf_str
    // bitmap_320_x_240_1BPP::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [1490] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [1491] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [1492] phi from bitmap_320_x_240_1BPP::vera_layer_show1 to bitmap_320_x_240_1BPP::@8 [phi:bitmap_320_x_240_1BPP::vera_layer_show1->bitmap_320_x_240_1BPP::@8]
    // bitmap_320_x_240_1BPP::@8
    // bitmap_init(0, 0x00000)
    // [1493] call bitmap_init
    jsr bitmap_init
    // [1494] phi from bitmap_320_x_240_1BPP::@8 to bitmap_320_x_240_1BPP::@20 [phi:bitmap_320_x_240_1BPP::@8->bitmap_320_x_240_1BPP::@20]
    // bitmap_320_x_240_1BPP::@20
    // bitmap_clear()
    // [1495] call bitmap_clear
    jsr bitmap_clear
    // [1496] phi from bitmap_320_x_240_1BPP::@20 to bitmap_320_x_240_1BPP::@21 [phi:bitmap_320_x_240_1BPP::@20->bitmap_320_x_240_1BPP::@21]
    // bitmap_320_x_240_1BPP::@21
    // gotoxy(0,29)
    // [1497] call gotoxy
    // [242] phi from bitmap_320_x_240_1BPP::@21 to gotoxy [phi:bitmap_320_x_240_1BPP::@21->gotoxy]
    // [242] phi gotoxy::y#35 = $1d [phi:bitmap_320_x_240_1BPP::@21->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1d
    sta.z gotoxy.y
    jsr gotoxy
    // [1498] phi from bitmap_320_x_240_1BPP::@21 to bitmap_320_x_240_1BPP::@22 [phi:bitmap_320_x_240_1BPP::@21->bitmap_320_x_240_1BPP::@22]
    // bitmap_320_x_240_1BPP::@22
    // textcolor(YELLOW)
    // [1499] call textcolor
    // [274] phi from bitmap_320_x_240_1BPP::@22 to textcolor [phi:bitmap_320_x_240_1BPP::@22->textcolor]
    // [274] phi textcolor::color#38 = YELLOW [phi:bitmap_320_x_240_1BPP::@22->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [1500] phi from bitmap_320_x_240_1BPP::@22 to bitmap_320_x_240_1BPP::@23 [phi:bitmap_320_x_240_1BPP::@22->bitmap_320_x_240_1BPP::@23]
    // bitmap_320_x_240_1BPP::@23
    // printf("press a key ...")
    // [1501] call printf_str
    // [318] phi from bitmap_320_x_240_1BPP::@23 to printf_str [phi:bitmap_320_x_240_1BPP::@23->printf_str]
    // [318] phi printf_str::s#124 = string_12 [phi:bitmap_320_x_240_1BPP::@23->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_12
    sta.z printf_str.s
    lda #>string_12
    sta.z printf_str.s+1
    jsr printf_str
    // [1502] phi from bitmap_320_x_240_1BPP::@23 bitmap_320_x_240_1BPP::@33 to bitmap_320_x_240_1BPP::@1 [phi:bitmap_320_x_240_1BPP::@23/bitmap_320_x_240_1BPP::@33->bitmap_320_x_240_1BPP::@1]
    // [1502] phi rem16u#132 = rem16u#236 [phi:bitmap_320_x_240_1BPP::@23/bitmap_320_x_240_1BPP::@33->bitmap_320_x_240_1BPP::@1#0] -- register_copy 
    // [1502] phi rand_state#148 = rand_state#246 [phi:bitmap_320_x_240_1BPP::@23/bitmap_320_x_240_1BPP::@33->bitmap_320_x_240_1BPP::@1#1] -- register_copy 
    // bitmap_320_x_240_1BPP::@1
  __b1:
    // getin()
    // [1503] call getin
    jsr getin
    // [1504] getin::return#12 = getin::return#1
    // bitmap_320_x_240_1BPP::@24
    // [1505] bitmap_320_x_240_1BPP::$27 = getin::return#12
    // while(!getin())
    // [1506] if(0==bitmap_320_x_240_1BPP::$27) goto bitmap_320_x_240_1BPP::@2 -- 0_eq_vbuz1_then_la1 
    lda.z __27
    bne !__b2+
    jmp __b2
  !__b2:
    // [1507] phi from bitmap_320_x_240_1BPP::@24 to bitmap_320_x_240_1BPP::@3 [phi:bitmap_320_x_240_1BPP::@24->bitmap_320_x_240_1BPP::@3]
    // bitmap_320_x_240_1BPP::@3
    // textcolor(WHITE)
    // [1508] call textcolor
    // [274] phi from bitmap_320_x_240_1BPP::@3 to textcolor [phi:bitmap_320_x_240_1BPP::@3->textcolor]
    // [274] phi textcolor::color#38 = WHITE [phi:bitmap_320_x_240_1BPP::@3->textcolor#0] -- vbuz1=vbuc1 
    lda #WHITE
    sta.z textcolor.color
    jsr textcolor
    // [1509] phi from bitmap_320_x_240_1BPP::@3 to bitmap_320_x_240_1BPP::@34 [phi:bitmap_320_x_240_1BPP::@3->bitmap_320_x_240_1BPP::@34]
    // bitmap_320_x_240_1BPP::@34
    // bgcolor(BLACK)
    // [1510] call bgcolor
    // [279] phi from bitmap_320_x_240_1BPP::@34 to bgcolor [phi:bitmap_320_x_240_1BPP::@34->bgcolor]
    // [279] phi bgcolor::color#26 = BLACK [phi:bitmap_320_x_240_1BPP::@34->bgcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z bgcolor.color
    jsr bgcolor
    // [1511] phi from bitmap_320_x_240_1BPP::@34 to bitmap_320_x_240_1BPP::@35 [phi:bitmap_320_x_240_1BPP::@34->bitmap_320_x_240_1BPP::@35]
    // bitmap_320_x_240_1BPP::@35
    // clrscr()
    // [1512] call clrscr
    jsr clrscr
    // [1513] phi from bitmap_320_x_240_1BPP::@35 to bitmap_320_x_240_1BPP::@36 [phi:bitmap_320_x_240_1BPP::@35->bitmap_320_x_240_1BPP::@36]
    // bitmap_320_x_240_1BPP::@36
    // gotoxy(0,26)
    // [1514] call gotoxy
    // [242] phi from bitmap_320_x_240_1BPP::@36 to gotoxy [phi:bitmap_320_x_240_1BPP::@36->gotoxy]
    // [242] phi gotoxy::y#35 = $1a [phi:bitmap_320_x_240_1BPP::@36->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1a
    sta.z gotoxy.y
    jsr gotoxy
    // [1515] phi from bitmap_320_x_240_1BPP::@36 to bitmap_320_x_240_1BPP::@37 [phi:bitmap_320_x_240_1BPP::@36->bitmap_320_x_240_1BPP::@37]
    // bitmap_320_x_240_1BPP::@37
    // printf("here you see all the colors possible.\n")
    // [1516] call printf_str
    // [318] phi from bitmap_320_x_240_1BPP::@37 to printf_str [phi:bitmap_320_x_240_1BPP::@37->printf_str]
    // [318] phi printf_str::s#124 = string_13 [phi:bitmap_320_x_240_1BPP::@37->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_13
    sta.z printf_str.s
    lda #>string_13
    sta.z printf_str.s+1
    jsr printf_str
    // [1517] phi from bitmap_320_x_240_1BPP::@37 to bitmap_320_x_240_1BPP::@38 [phi:bitmap_320_x_240_1BPP::@37->bitmap_320_x_240_1BPP::@38]
    // bitmap_320_x_240_1BPP::@38
    // gotoxy(0,29)
    // [1518] call gotoxy
    // [242] phi from bitmap_320_x_240_1BPP::@38 to gotoxy [phi:bitmap_320_x_240_1BPP::@38->gotoxy]
    // [242] phi gotoxy::y#35 = $1d [phi:bitmap_320_x_240_1BPP::@38->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1d
    sta.z gotoxy.y
    jsr gotoxy
    // [1519] phi from bitmap_320_x_240_1BPP::@38 to bitmap_320_x_240_1BPP::@39 [phi:bitmap_320_x_240_1BPP::@38->bitmap_320_x_240_1BPP::@39]
    // bitmap_320_x_240_1BPP::@39
    // textcolor(YELLOW)
    // [1520] call textcolor
    // [274] phi from bitmap_320_x_240_1BPP::@39 to textcolor [phi:bitmap_320_x_240_1BPP::@39->textcolor]
    // [274] phi textcolor::color#38 = YELLOW [phi:bitmap_320_x_240_1BPP::@39->textcolor#0] -- vbuz1=vbuc1 
    lda #YELLOW
    sta.z textcolor.color
    jsr textcolor
    // [1521] phi from bitmap_320_x_240_1BPP::@39 to bitmap_320_x_240_1BPP::@40 [phi:bitmap_320_x_240_1BPP::@39->bitmap_320_x_240_1BPP::@40]
    // bitmap_320_x_240_1BPP::@40
    // printf("press a key ...")
    // [1522] call printf_str
    // [318] phi from bitmap_320_x_240_1BPP::@40 to printf_str [phi:bitmap_320_x_240_1BPP::@40->printf_str]
    // [318] phi printf_str::s#124 = string_12 [phi:bitmap_320_x_240_1BPP::@40->printf_str#0] -- pbuz1=pbuc1 
    lda #<string_12
    sta.z printf_str.s
    lda #>string_12
    sta.z printf_str.s+1
    jsr printf_str
    // [1523] phi from bitmap_320_x_240_1BPP::@40 to bitmap_320_x_240_1BPP::@4 [phi:bitmap_320_x_240_1BPP::@40->bitmap_320_x_240_1BPP::@4]
    // [1523] phi bitmap_320_x_240_1BPP::color#3 = 0 [phi:bitmap_320_x_240_1BPP::@40->bitmap_320_x_240_1BPP::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [1523] phi bitmap_320_x_240_1BPP::x#3 = 0 [phi:bitmap_320_x_240_1BPP::@40->bitmap_320_x_240_1BPP::@4#1] -- vwuz1=vwuc1 
    sta.z x
    sta.z x+1
    // bitmap_320_x_240_1BPP::@4
  __b4:
    // getin()
    // [1524] call getin
    jsr getin
    // [1525] getin::return#13 = getin::return#1
    // bitmap_320_x_240_1BPP::@41
    // [1526] bitmap_320_x_240_1BPP::$40 = getin::return#13
    // while(!getin())
    // [1527] if(0==bitmap_320_x_240_1BPP::$40) goto bitmap_320_x_240_1BPP::@5 -- 0_eq_vbuz1_then_la1 
    lda.z __40
    beq __b5
    // [1528] phi from bitmap_320_x_240_1BPP::@41 to bitmap_320_x_240_1BPP::@6 [phi:bitmap_320_x_240_1BPP::@41->bitmap_320_x_240_1BPP::@6]
    // bitmap_320_x_240_1BPP::@6
    // cx16_cpy_vram_from_vram(0, 0xF800, 1, 0xF000, 256*8)
    // [1529] call cx16_cpy_vram_from_vram
    // [1674] phi from bitmap_320_x_240_1BPP::@6 to cx16_cpy_vram_from_vram [phi:bitmap_320_x_240_1BPP::@6->cx16_cpy_vram_from_vram]
    // [1674] phi cx16_cpy_vram_from_vram::doffset_vram#15 = $f800 [phi:bitmap_320_x_240_1BPP::@6->cx16_cpy_vram_from_vram#0] -- vwuz1=vwuc1 
    lda #<$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram
    lda #>$f800
    sta.z cx16_cpy_vram_from_vram.doffset_vram+1
    // [1674] phi cx16_cpy_vram_from_vram::dbank_vram#15 = 0 [phi:bitmap_320_x_240_1BPP::@6->cx16_cpy_vram_from_vram#1] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_cpy_vram_from_vram.dbank_vram
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 = $f000 [phi:bitmap_320_x_240_1BPP::@6->cx16_cpy_vram_from_vram#2] -- vwuz1=vwuc1 
    lda #<$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset
    lda #>$f000
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_offset+1
    // [1674] phi cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 = 1 [phi:bitmap_320_x_240_1BPP::@6->cx16_cpy_vram_from_vram#3] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_cpy_vram_from_vram.vera_vram_data0_bank_offset1_bank
    jsr cx16_cpy_vram_from_vram
    // bitmap_320_x_240_1BPP::@return
    // }
    // [1530] return 
    rts
    // bitmap_320_x_240_1BPP::@5
  __b5:
    // bitmap_line(x, x, 0, 199, color)
    // [1531] bitmap_line::x0#1 = bitmap_320_x_240_1BPP::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x0
    lda.z x+1
    sta.z bitmap_line.x0+1
    // [1532] bitmap_line::x1#1 = bitmap_320_x_240_1BPP::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_line.x1
    lda.z x+1
    sta.z bitmap_line.x1+1
    // [1533] bitmap_line::c#1 = bitmap_320_x_240_1BPP::color#3 -- vbuz1=vbuz2 
    lda.z color
    sta.z bitmap_line.c
    // [1534] call bitmap_line
    // [1874] phi from bitmap_320_x_240_1BPP::@5 to bitmap_line [phi:bitmap_320_x_240_1BPP::@5->bitmap_line]
    // [1874] phi bitmap_line::c#12 = bitmap_line::c#1 [phi:bitmap_320_x_240_1BPP::@5->bitmap_line#0] -- register_copy 
    // [1874] phi bitmap_line::y1#12 = $c7 [phi:bitmap_320_x_240_1BPP::@5->bitmap_line#1] -- vwuz1=vbuc1 
    lda #<$c7
    sta.z bitmap_line.y1
    lda #>$c7
    sta.z bitmap_line.y1+1
    // [1874] phi bitmap_line::y0#12 = 0 [phi:bitmap_320_x_240_1BPP::@5->bitmap_line#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z bitmap_line.y0
    sta.z bitmap_line.y0+1
    // [1874] phi bitmap_line::x1#12 = bitmap_line::x1#1 [phi:bitmap_320_x_240_1BPP::@5->bitmap_line#3] -- register_copy 
    // [1874] phi bitmap_line::x0#12 = bitmap_line::x0#1 [phi:bitmap_320_x_240_1BPP::@5->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    // bitmap_320_x_240_1BPP::@42
    // color++;
    // [1535] bitmap_320_x_240_1BPP::color#1 = ++ bitmap_320_x_240_1BPP::color#3 -- vbuz1=_inc_vbuz1 
    inc.z color
    // if(color>1)
    // [1536] if(bitmap_320_x_240_1BPP::color#1<1+1) goto bitmap_320_x_240_1BPP::@44 -- vbuz1_lt_vbuc1_then_la1 
    lda.z color
    cmp #1+1
    bcc __b7
    // [1538] phi from bitmap_320_x_240_1BPP::@42 to bitmap_320_x_240_1BPP::@7 [phi:bitmap_320_x_240_1BPP::@42->bitmap_320_x_240_1BPP::@7]
    // [1538] phi bitmap_320_x_240_1BPP::color#7 = 0 [phi:bitmap_320_x_240_1BPP::@42->bitmap_320_x_240_1BPP::@7#0] -- vbuz1=vbuc1 
    lda #0
    sta.z color
    // [1537] phi from bitmap_320_x_240_1BPP::@42 to bitmap_320_x_240_1BPP::@44 [phi:bitmap_320_x_240_1BPP::@42->bitmap_320_x_240_1BPP::@44]
    // bitmap_320_x_240_1BPP::@44
    // [1538] phi from bitmap_320_x_240_1BPP::@44 to bitmap_320_x_240_1BPP::@7 [phi:bitmap_320_x_240_1BPP::@44->bitmap_320_x_240_1BPP::@7]
    // [1538] phi bitmap_320_x_240_1BPP::color#7 = bitmap_320_x_240_1BPP::color#1 [phi:bitmap_320_x_240_1BPP::@44->bitmap_320_x_240_1BPP::@7#0] -- register_copy 
    // bitmap_320_x_240_1BPP::@7
  __b7:
    // x++;
    // [1539] bitmap_320_x_240_1BPP::x#1 = ++ bitmap_320_x_240_1BPP::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // if(x>319)
    // [1540] if(bitmap_320_x_240_1BPP::x#1<=$13f) goto bitmap_320_x_240_1BPP::@43 -- vwuz1_le_vwuc1_then_la1 
    lda.z x+1
    cmp #>$13f
    bne !+
    lda.z x
    cmp #<$13f
  !:
    bcc __b4
    beq __b4
    // [1523] phi from bitmap_320_x_240_1BPP::@7 to bitmap_320_x_240_1BPP::@4 [phi:bitmap_320_x_240_1BPP::@7->bitmap_320_x_240_1BPP::@4]
    // [1523] phi bitmap_320_x_240_1BPP::color#3 = bitmap_320_x_240_1BPP::color#7 [phi:bitmap_320_x_240_1BPP::@7->bitmap_320_x_240_1BPP::@4#0] -- register_copy 
    // [1523] phi bitmap_320_x_240_1BPP::x#3 = 0 [phi:bitmap_320_x_240_1BPP::@7->bitmap_320_x_240_1BPP::@4#1] -- vwuz1=vbuc1 
    lda #<0
    sta.z x
    sta.z x+1
    jmp __b4
    // [1541] phi from bitmap_320_x_240_1BPP::@7 to bitmap_320_x_240_1BPP::@43 [phi:bitmap_320_x_240_1BPP::@7->bitmap_320_x_240_1BPP::@43]
    // bitmap_320_x_240_1BPP::@43
    // [1523] phi from bitmap_320_x_240_1BPP::@43 to bitmap_320_x_240_1BPP::@4 [phi:bitmap_320_x_240_1BPP::@43->bitmap_320_x_240_1BPP::@4]
    // [1523] phi bitmap_320_x_240_1BPP::color#3 = bitmap_320_x_240_1BPP::color#7 [phi:bitmap_320_x_240_1BPP::@43->bitmap_320_x_240_1BPP::@4#0] -- register_copy 
    // [1523] phi bitmap_320_x_240_1BPP::x#3 = bitmap_320_x_240_1BPP::x#1 [phi:bitmap_320_x_240_1BPP::@43->bitmap_320_x_240_1BPP::@4#1] -- register_copy 
    // [1542] phi from bitmap_320_x_240_1BPP::@24 to bitmap_320_x_240_1BPP::@2 [phi:bitmap_320_x_240_1BPP::@24->bitmap_320_x_240_1BPP::@2]
    // bitmap_320_x_240_1BPP::@2
  __b2:
    // rand()
    // [1543] call rand
    // [1945] phi from bitmap_320_x_240_1BPP::@2 to rand [phi:bitmap_320_x_240_1BPP::@2->rand]
    // [1945] phi rand_state#50 = rand_state#148 [phi:bitmap_320_x_240_1BPP::@2->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1544] rand::return#2 = rand::return#0
    // bitmap_320_x_240_1BPP::@25
    // modr16u(rand(),320,0)
    // [1545] modr16u::dividend#0 = rand::return#2
    // [1546] call modr16u
    // [1954] phi from bitmap_320_x_240_1BPP::@25 to modr16u [phi:bitmap_320_x_240_1BPP::@25->modr16u]
    // [1954] phi modr16u::divisor#24 = $140 [phi:bitmap_320_x_240_1BPP::@25->modr16u#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z modr16u.divisor
    lda #>$140
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#0 [phi:bitmap_320_x_240_1BPP::@25->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),320,0)
    // [1547] modr16u::return#2 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_1
    lda.z modr16u.return+1
    sta.z modr16u.return_1+1
    // bitmap_320_x_240_1BPP::@26
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&1)
    // [1548] bitmap_line::x0#0 = modr16u::return#2
    // rand()
    // [1549] call rand
    // [1945] phi from bitmap_320_x_240_1BPP::@26 to rand [phi:bitmap_320_x_240_1BPP::@26->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_1BPP::@26->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1550] rand::return#3 = rand::return#0
    // bitmap_320_x_240_1BPP::@27
    // modr16u(rand(),320,0)
    // [1551] modr16u::dividend#1 = rand::return#3
    // [1552] call modr16u
    // [1954] phi from bitmap_320_x_240_1BPP::@27 to modr16u [phi:bitmap_320_x_240_1BPP::@27->modr16u]
    // [1954] phi modr16u::divisor#24 = $140 [phi:bitmap_320_x_240_1BPP::@27->modr16u#0] -- vwuz1=vwuc1 
    lda #<$140
    sta.z modr16u.divisor
    lda #>$140
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#1 [phi:bitmap_320_x_240_1BPP::@27->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),320,0)
    // [1553] modr16u::return#28 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_2
    lda.z modr16u.return+1
    sta.z modr16u.return_2+1
    // bitmap_320_x_240_1BPP::@28
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&1)
    // [1554] bitmap_line::x1#0 = modr16u::return#28
    // rand()
    // [1555] call rand
    // [1945] phi from bitmap_320_x_240_1BPP::@28 to rand [phi:bitmap_320_x_240_1BPP::@28->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_1BPP::@28->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1556] rand::return#35 = rand::return#0
    // bitmap_320_x_240_1BPP::@29
    // modr16u(rand(),200,0)
    // [1557] modr16u::dividend#2 = rand::return#35
    // [1558] call modr16u
    // [1954] phi from bitmap_320_x_240_1BPP::@29 to modr16u [phi:bitmap_320_x_240_1BPP::@29->modr16u]
    // [1954] phi modr16u::divisor#24 = $c8 [phi:bitmap_320_x_240_1BPP::@29->modr16u#0] -- vwuz1=vbuc1 
    lda #<$c8
    sta.z modr16u.divisor
    lda #>$c8
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#2 [phi:bitmap_320_x_240_1BPP::@29->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),200,0)
    // [1559] modr16u::return#29 = modr16u::return#0 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z modr16u.return_3
    lda.z modr16u.return+1
    sta.z modr16u.return_3+1
    // bitmap_320_x_240_1BPP::@30
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&1)
    // [1560] bitmap_line::y0#0 = modr16u::return#29
    // rand()
    // [1561] call rand
    // [1945] phi from bitmap_320_x_240_1BPP::@30 to rand [phi:bitmap_320_x_240_1BPP::@30->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_1BPP::@30->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1562] rand::return#36 = rand::return#0
    // bitmap_320_x_240_1BPP::@31
    // modr16u(rand(),200,0)
    // [1563] modr16u::dividend#3 = rand::return#36
    // [1564] call modr16u
    // [1954] phi from bitmap_320_x_240_1BPP::@31 to modr16u [phi:bitmap_320_x_240_1BPP::@31->modr16u]
    // [1954] phi modr16u::divisor#24 = $c8 [phi:bitmap_320_x_240_1BPP::@31->modr16u#0] -- vwuz1=vbuc1 
    lda #<$c8
    sta.z modr16u.divisor
    lda #>$c8
    sta.z modr16u.divisor+1
    // [1954] phi modr16u::dividend#24 = modr16u::dividend#3 [phi:bitmap_320_x_240_1BPP::@31->modr16u#1] -- register_copy 
    jsr modr16u
    // modr16u(rand(),200,0)
    // [1565] modr16u::return#30 = modr16u::return#0
    // bitmap_320_x_240_1BPP::@32
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&1)
    // [1566] bitmap_line::y1#0 = modr16u::return#30
    // rand()
    // [1567] call rand
    // [1945] phi from bitmap_320_x_240_1BPP::@32 to rand [phi:bitmap_320_x_240_1BPP::@32->rand]
    // [1945] phi rand_state#50 = rand_state#2 [phi:bitmap_320_x_240_1BPP::@32->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [1568] rand::return#37 = rand::return#0
    // bitmap_320_x_240_1BPP::@33
    // [1569] bitmap_320_x_240_1BPP::$37 = rand::return#37
    // bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&1)
    // [1570] bitmap_line::c#0 = bitmap_320_x_240_1BPP::$37 & 1 -- vbuz1=vwuz2_band_vbuc1 
    lda #1
    and.z __37
    sta.z bitmap_line.c
    // [1571] call bitmap_line
    // [1874] phi from bitmap_320_x_240_1BPP::@33 to bitmap_line [phi:bitmap_320_x_240_1BPP::@33->bitmap_line]
    // [1874] phi bitmap_line::c#12 = bitmap_line::c#0 [phi:bitmap_320_x_240_1BPP::@33->bitmap_line#0] -- register_copy 
    // [1874] phi bitmap_line::y1#12 = bitmap_line::y1#0 [phi:bitmap_320_x_240_1BPP::@33->bitmap_line#1] -- register_copy 
    // [1874] phi bitmap_line::y0#12 = bitmap_line::y0#0 [phi:bitmap_320_x_240_1BPP::@33->bitmap_line#2] -- register_copy 
    // [1874] phi bitmap_line::x1#12 = bitmap_line::x1#0 [phi:bitmap_320_x_240_1BPP::@33->bitmap_line#3] -- register_copy 
    // [1874] phi bitmap_line::x0#12 = bitmap_line::x0#0 [phi:bitmap_320_x_240_1BPP::@33->bitmap_line#4] -- register_copy 
    jsr bitmap_line
    jmp __b1
}
  // getin
// GETIN. Read a byte from the input channel
// return: next byte in buffer or 0 if buffer is empty.
getin: {
    .const cx16_bram_bank_set1_bank = 0
    .label ch = $75
    .label cx16_bram_bank_set1_return = $64
    .label return = $66
    .label return_1 = $e9
    // char ch
    // [1572] getin::ch = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z ch
    // getin::cx16_bram_bank_set1
    // char current_bank = VIA1->PORT_A
    // [1573] getin::cx16_bram_bank_set1_return#0 = *((char *)VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A) -- vbuz1=_deref_pbuc1 
    lda VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    sta.z cx16_bram_bank_set1_return
    // VIA1->PORT_A = bank
    // [1574] *((char *)VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A) = getin::cx16_bram_bank_set1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #cx16_bram_bank_set1_bank
    sta VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    // getin::@1
    // asm
    // asm { jsr$ffe4 stach  }
    jsr $ffe4
    sta ch
    // getin::cx16_bram_bank_set2
    // VIA1->PORT_A = bank
    // [1576] *((char *)VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A) = getin::cx16_bram_bank_set1_return#0 -- _deref_pbuc1=vbuz1 
    lda.z cx16_bram_bank_set1_return
    sta VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    // getin::@2
    // return ch;
    // [1577] getin::return#0 = getin::ch -- vbuz1=vbuz2 
    lda.z ch
    sta.z return
    // getin::@return
    // }
    // [1578] getin::return#1 = getin::return#0
    // [1579] return 
    rts
}
  // vera_layer_mode_tile
// Set a vera layer in tile mode and configure the:
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
// - color_depth: The color depth in bits per pixel (BPP), which can be 1, 2, 4 or 8.
// void vera_layer_mode_tile(__zp($77) char layer, __zp($c6) unsigned long mapbase_address, __zp($ca) unsigned long tilebase_address, __zp($dc) unsigned int mapwidth, __zp($e2) unsigned int mapheight, __zp($ea) char tilewidth, __zp($e0) char tileheight, __zp($6b) char color_depth)
vera_layer_mode_tile: {
    .label __1 = $de
    .label __2 = $d0
    .label __6 = $a9
    .label __7 = $d1
    .label __11 = $d4
    .label __12 = $d3
    .label __13 = $d2
    .label __14 = $44
    .label __17 = $e5
    .label __18 = $e4
    // config
    .label config = $b0
    .label mapbase_address = $c6
    .label mapbase = $6c
    .label tilebase_address = $ca
    .label tilebase = $b1
    .label mapwidth = $dc
    .label mapheight = $e2
    .label color_depth = $6b
    .label layer = $77
    .label tilewidth = $ea
    .label tileheight = $e0
    // case 1:
    //             config |= VERA_LAYER_COLOR_DEPTH_1BPP;
    //             break;
    // [1581] if(vera_layer_mode_tile::color_depth#14==1) goto vera_layer_mode_tile::@5 -- vbuz1_eq_vbuc1_then_la1 
    lda #1
    cmp.z color_depth
    beq __b1
    // vera_layer_mode_tile::@1
    // case 2:
    //             config |= VERA_LAYER_COLOR_DEPTH_2BPP;
    //             break;
    // [1582] if(vera_layer_mode_tile::color_depth#14==2) goto vera_layer_mode_tile::@5 -- vbuz1_eq_vbuc1_then_la1 
    lda #2
    cmp.z color_depth
    beq __b2
    // vera_layer_mode_tile::@2
    // case 4:
    //             config |= VERA_LAYER_COLOR_DEPTH_4BPP;
    //             break;
    // [1583] if(vera_layer_mode_tile::color_depth#14==4) goto vera_layer_mode_tile::@5 -- vbuz1_eq_vbuc1_then_la1 
    lda #4
    cmp.z color_depth
    beq __b3
    // vera_layer_mode_tile::@3
    // case 8:
    //             config |= VERA_LAYER_COLOR_DEPTH_8BPP;
    //             break;
    // [1584] if(vera_layer_mode_tile::color_depth#14!=8) goto vera_layer_mode_tile::@5 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z color_depth
    bne __b4
    // [1585] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@4 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@4]
    // vera_layer_mode_tile::@4
    // [1586] phi from vera_layer_mode_tile::@4 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5]
    // [1586] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_8BPP [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_8BPP
    sta.z config
    jmp __b5
    // [1586] phi from vera_layer_mode_tile to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5]
  __b1:
    // [1586] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_1BPP [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_1BPP
    sta.z config
    jmp __b5
    // [1586] phi from vera_layer_mode_tile::@1 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5]
  __b2:
    // [1586] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_2BPP [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_2BPP
    sta.z config
    jmp __b5
    // [1586] phi from vera_layer_mode_tile::@2 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5]
  __b3:
    // [1586] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_4BPP [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_4BPP
    sta.z config
    jmp __b5
    // [1586] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5]
  __b4:
    // [1586] phi vera_layer_mode_tile::config#17 = 0 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #0
    sta.z config
    // vera_layer_mode_tile::@5
  __b5:
    // case 32:
    //             config |= VERA_LAYER_WIDTH_32;
    //             vera_layer_rowshift[layer] = 6;
    //             vera_layer_rowskip[layer] = 64;
    //             break;
    // [1587] if(vera_layer_mode_tile::mapwidth#14==$20) goto vera_layer_mode_tile::@9 -- vwuz1_eq_vbuc1_then_la1 
    lda.z mapwidth+1
    bne !+
    lda.z mapwidth
    cmp #$20
    bne !__b9+
    jmp __b9
  !__b9:
  !:
    // vera_layer_mode_tile::@6
    // case 64:
    //             config |= VERA_LAYER_WIDTH_64;
    //             vera_layer_rowshift[layer] = 7;
    //             vera_layer_rowskip[layer] = 128;
    //             break;
    // [1588] if(vera_layer_mode_tile::mapwidth#14==$40) goto vera_layer_mode_tile::@10 -- vwuz1_eq_vbuc1_then_la1 
    lda.z mapwidth+1
    bne !+
    lda.z mapwidth
    cmp #$40
    bne !__b10+
    jmp __b10
  !__b10:
  !:
    // vera_layer_mode_tile::@7
    // case 128:
    //             config |= VERA_LAYER_WIDTH_128;
    //             vera_layer_rowshift[layer] = 8;
    //             vera_layer_rowskip[layer] = 256;
    //             break;
    // [1589] if(vera_layer_mode_tile::mapwidth#14==$80) goto vera_layer_mode_tile::@11 -- vwuz1_eq_vbuc1_then_la1 
    lda.z mapwidth+1
    bne !+
    lda.z mapwidth
    cmp #$80
    bne !__b11+
    jmp __b11
  !__b11:
  !:
    // vera_layer_mode_tile::@8
    // case 256:
    //             config |= VERA_LAYER_WIDTH_256;
    //             vera_layer_rowshift[layer] = 9;
    //             vera_layer_rowskip[layer] = 512;
    //             break;
    // [1590] if(vera_layer_mode_tile::mapwidth#14!=$100) goto vera_layer_mode_tile::@13 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapwidth+1
    cmp #>$100
    bne __b13
    lda.z mapwidth
    cmp #<$100
    bne __b13
    // vera_layer_mode_tile::@12
    // config |= VERA_LAYER_WIDTH_256
    // [1591] vera_layer_mode_tile::config#8 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_256 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_WIDTH_256
    ora.z config
    sta.z config
    // vera_layer_rowshift[layer] = 9
    // [1592] vera_layer_rowshift[vera_layer_mode_tile::layer#14] = 9 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #9
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 512
    // [1593] vera_layer_mode_tile::$14 = vera_layer_mode_tile::layer#14 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z __14
    // [1594] vera_layer_rowskip[vera_layer_mode_tile::$14] = $200 -- pwuc1_derefidx_vbuz1=vwuc2 
    tay
    lda #<$200
    sta vera_layer_rowskip,y
    lda #>$200
    sta vera_layer_rowskip+1,y
    // [1595] phi from vera_layer_mode_tile::@10 vera_layer_mode_tile::@11 vera_layer_mode_tile::@12 vera_layer_mode_tile::@8 vera_layer_mode_tile::@9 to vera_layer_mode_tile::@13 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13]
    // [1595] phi vera_layer_mode_tile::config#21 = vera_layer_mode_tile::config#6 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13#0] -- register_copy 
    // vera_layer_mode_tile::@13
  __b13:
    // case 32:
    //             config |= VERA_LAYER_HEIGHT_32;
    //             break;
    // [1596] if(vera_layer_mode_tile::mapheight#14==$20) goto vera_layer_mode_tile::@20 -- vwuz1_eq_vbuc1_then_la1 
    lda.z mapheight+1
    bne !+
    lda.z mapheight
    cmp #$20
    beq __b20
  !:
    // vera_layer_mode_tile::@14
    // case 64:
    //             config |= VERA_LAYER_HEIGHT_64;
    //             break;
    // [1597] if(vera_layer_mode_tile::mapheight#14==$40) goto vera_layer_mode_tile::@17 -- vwuz1_eq_vbuc1_then_la1 
    lda.z mapheight+1
    bne !+
    lda.z mapheight
    cmp #$40
    bne !__b17+
    jmp __b17
  !__b17:
  !:
    // vera_layer_mode_tile::@15
    // case 128:
    //             config |= VERA_LAYER_HEIGHT_128;
    //             break;
    // [1598] if(vera_layer_mode_tile::mapheight#14==$80) goto vera_layer_mode_tile::@18 -- vwuz1_eq_vbuc1_then_la1 
    lda.z mapheight+1
    bne !+
    lda.z mapheight
    cmp #$80
    bne !__b18+
    jmp __b18
  !__b18:
  !:
    // vera_layer_mode_tile::@16
    // case 256:
    //             config |= VERA_LAYER_HEIGHT_256;
    //             break;
    // [1599] if(vera_layer_mode_tile::mapheight#14!=$100) goto vera_layer_mode_tile::@20 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapheight+1
    cmp #>$100
    bne __b20
    lda.z mapheight
    cmp #<$100
    bne __b20
    // vera_layer_mode_tile::@19
    // config |= VERA_LAYER_HEIGHT_256
    // [1600] vera_layer_mode_tile::config#12 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_256 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_HEIGHT_256
    ora.z config
    sta.z config
    // [1601] phi from vera_layer_mode_tile::@13 vera_layer_mode_tile::@16 vera_layer_mode_tile::@17 vera_layer_mode_tile::@18 vera_layer_mode_tile::@19 to vera_layer_mode_tile::@20 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20]
    // [1601] phi vera_layer_mode_tile::config#25 = vera_layer_mode_tile::config#21 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20#0] -- register_copy 
    // vera_layer_mode_tile::@20
  __b20:
    // vera_layer_set_config(layer, config)
    // [1602] vera_layer_set_config::layer#0 = vera_layer_mode_tile::layer#14 -- vbuz1=vbuz2 
    lda.z layer
    sta.z vera_layer_set_config.layer
    // [1603] vera_layer_set_config::config#0 = vera_layer_mode_tile::config#25
    // [1604] call vera_layer_set_config
    // [1960] phi from vera_layer_mode_tile::@20 to vera_layer_set_config [phi:vera_layer_mode_tile::@20->vera_layer_set_config]
    // [1960] phi vera_layer_set_config::config#2 = vera_layer_set_config::config#0 [phi:vera_layer_mode_tile::@20->vera_layer_set_config#0] -- register_copy 
    // [1960] phi vera_layer_set_config::layer#2 = vera_layer_set_config::layer#0 [phi:vera_layer_mode_tile::@20->vera_layer_set_config#1] -- register_copy 
    jsr vera_layer_set_config
    // vera_layer_mode_tile::@27
    // WORD0(mapbase_address)
    // [1605] vera_layer_mode_tile::$1 = word0  vera_layer_mode_tile::mapbase_address#15 -- vwuz1=_word0_vduz2 
    lda.z mapbase_address
    sta.z __1
    lda.z mapbase_address+1
    sta.z __1+1
    // vera_mapbase_offset[layer] = WORD0(mapbase_address)
    // [1606] vera_layer_mode_tile::$17 = vera_layer_mode_tile::layer#14 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z layer
    asl
    sta.z __17
    // [1607] vera_mapbase_offset[vera_layer_mode_tile::$17] = vera_layer_mode_tile::$1 -- pwuc1_derefidx_vbuz1=vwuz2 
    // mapbase
    tay
    lda.z __1
    sta vera_mapbase_offset,y
    lda.z __1+1
    sta vera_mapbase_offset+1,y
    // BYTE2(mapbase_address)
    // [1608] vera_layer_mode_tile::$2 = byte2  vera_layer_mode_tile::mapbase_address#15 -- vbuz1=_byte2_vduz2 
    lda.z mapbase_address+2
    sta.z __2
    // vera_mapbase_bank[layer] = BYTE2(mapbase_address)
    // [1609] vera_mapbase_bank[vera_layer_mode_tile::layer#14] = vera_layer_mode_tile::$2 -- pbuc1_derefidx_vbuz1=vbuz2 
    ldy.z layer
    sta vera_mapbase_bank,y
    // vera_mapbase_address[layer] = mapbase_address
    // [1610] vera_layer_mode_tile::$18 = vera_layer_mode_tile::layer#14 << 2 -- vbuz1=vbuz2_rol_2 
    tya
    asl
    asl
    sta.z __18
    // [1611] vera_mapbase_address[vera_layer_mode_tile::$18] = vera_layer_mode_tile::mapbase_address#15 -- pduc1_derefidx_vbuz1=vduz2 
    tay
    lda.z mapbase_address
    sta vera_mapbase_address,y
    lda.z mapbase_address+1
    sta vera_mapbase_address+1,y
    lda.z mapbase_address+2
    sta vera_mapbase_address+2,y
    lda.z mapbase_address+3
    sta vera_mapbase_address+3,y
    // mapbase_address = mapbase_address >> 1
    // [1612] vera_layer_mode_tile::mapbase_address#0 = vera_layer_mode_tile::mapbase_address#15 >> 1 -- vduz1=vduz1_ror_1 
    lsr.z mapbase_address+3
    ror.z mapbase_address+2
    ror.z mapbase_address+1
    ror.z mapbase_address
    // char mapbase = BYTE1(mapbase_address)
    // [1613] vera_layer_mode_tile::mapbase#0 = byte1  vera_layer_mode_tile::mapbase_address#0 -- vbuz1=_byte1_vduz2 
    lda.z mapbase_address+1
    sta.z mapbase
    // vera_layer_set_mapbase(layer,mapbase)
    // [1614] vera_layer_set_mapbase::layer#0 = vera_layer_mode_tile::layer#14 -- vbuz1=vbuz2 
    lda.z layer
    sta.z vera_layer_set_mapbase.layer
    // [1615] vera_layer_set_mapbase::mapbase#0 = vera_layer_mode_tile::mapbase#0
    // [1616] call vera_layer_set_mapbase
    // [235] phi from vera_layer_mode_tile::@27 to vera_layer_set_mapbase [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase]
    // [235] phi vera_layer_set_mapbase::mapbase#3 = vera_layer_set_mapbase::mapbase#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#0] -- register_copy 
    // [235] phi vera_layer_set_mapbase::layer#3 = vera_layer_set_mapbase::layer#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#1] -- register_copy 
    jsr vera_layer_set_mapbase
    // vera_layer_mode_tile::@28
    // WORD0(tilebase_address)
    // [1617] vera_layer_mode_tile::$6 = word0  vera_layer_mode_tile::tilebase_address#15 -- vwuz1=_word0_vduz2 
    lda.z tilebase_address
    sta.z __6
    lda.z tilebase_address+1
    sta.z __6+1
    // vera_tilebase_offset[layer] = WORD0(tilebase_address)
    // [1618] vera_tilebase_offset[vera_layer_mode_tile::$17] = vera_layer_mode_tile::$6 -- pwuc1_derefidx_vbuz1=vwuz2 
    // tilebase
    ldy.z __17
    lda.z __6
    sta vera_tilebase_offset,y
    lda.z __6+1
    sta vera_tilebase_offset+1,y
    // BYTE2(tilebase_address)
    // [1619] vera_layer_mode_tile::$7 = byte2  vera_layer_mode_tile::tilebase_address#15 -- vbuz1=_byte2_vduz2 
    lda.z tilebase_address+2
    sta.z __7
    // vera_tilebase_bank[layer] = BYTE2(tilebase_address)
    // [1620] vera_tilebase_bank[vera_layer_mode_tile::layer#14] = vera_layer_mode_tile::$7 -- pbuc1_derefidx_vbuz1=vbuz2 
    ldy.z layer
    sta vera_tilebase_bank,y
    // vera_tilebase_address[layer] = tilebase_address
    // [1621] vera_tilebase_address[vera_layer_mode_tile::$18] = vera_layer_mode_tile::tilebase_address#15 -- pduc1_derefidx_vbuz1=vduz2 
    ldy.z __18
    lda.z tilebase_address
    sta vera_tilebase_address,y
    lda.z tilebase_address+1
    sta vera_tilebase_address+1,y
    lda.z tilebase_address+2
    sta vera_tilebase_address+2,y
    lda.z tilebase_address+3
    sta vera_tilebase_address+3,y
    // tilebase_address = tilebase_address >> 1
    // [1622] vera_layer_mode_tile::tilebase_address#0 = vera_layer_mode_tile::tilebase_address#15 >> 1 -- vduz1=vduz1_ror_1 
    lsr.z tilebase_address+3
    ror.z tilebase_address+2
    ror.z tilebase_address+1
    ror.z tilebase_address
    // char tilebase = BYTE1(tilebase_address)
    // [1623] vera_layer_mode_tile::tilebase#0 = byte1  vera_layer_mode_tile::tilebase_address#0 -- vbuz1=_byte1_vduz2 
    lda.z tilebase_address+1
    sta.z tilebase
    // tilebase &= VERA_LAYER_TILEBASE_MASK
    // [1624] vera_layer_mode_tile::tilebase#1 = vera_layer_mode_tile::tilebase#0 & VERA_LAYER_TILEBASE_MASK -- vbuz1=vbuz1_band_vbuc1 
    lda #VERA_LAYER_TILEBASE_MASK
    and.z tilebase
    sta.z tilebase
    // case 8:
    //             tilebase |= VERA_TILEBASE_WIDTH_8;
    //             break;
    // [1625] if(vera_layer_mode_tile::tilewidth#14==8) goto vera_layer_mode_tile::@23 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tilewidth
    beq __b23
    // vera_layer_mode_tile::@21
    // case 16:
    //             tilebase |= VERA_TILEBASE_WIDTH_16;
    //             break;
    // [1626] if(vera_layer_mode_tile::tilewidth#14!=$10) goto vera_layer_mode_tile::@23 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tilewidth
    bne __b23
    // vera_layer_mode_tile::@22
    // tilebase |= VERA_TILEBASE_WIDTH_16
    // [1627] vera_layer_mode_tile::tilebase#3 = vera_layer_mode_tile::tilebase#1 | VERA_TILEBASE_WIDTH_16 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_TILEBASE_WIDTH_16
    ora.z tilebase
    sta.z tilebase
    // [1628] phi from vera_layer_mode_tile::@21 vera_layer_mode_tile::@22 vera_layer_mode_tile::@28 to vera_layer_mode_tile::@23 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23]
    // [1628] phi vera_layer_mode_tile::tilebase#12 = vera_layer_mode_tile::tilebase#1 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23#0] -- register_copy 
    // vera_layer_mode_tile::@23
  __b23:
    // case 8:
    //             tilebase |= VERA_TILEBASE_HEIGHT_8;
    //             break;
    // [1629] if(vera_layer_mode_tile::tileheight#14==8) goto vera_layer_mode_tile::@26 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tileheight
    beq __b26
    // vera_layer_mode_tile::@24
    // case 16:
    //             tilebase |= VERA_TILEBASE_HEIGHT_16;
    //             break;
    // [1630] if(vera_layer_mode_tile::tileheight#14!=$10) goto vera_layer_mode_tile::@26 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tileheight
    bne __b26
    // vera_layer_mode_tile::@25
    // tilebase |= VERA_TILEBASE_HEIGHT_16
    // [1631] vera_layer_mode_tile::tilebase#5 = vera_layer_mode_tile::tilebase#12 | VERA_TILEBASE_HEIGHT_16 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_TILEBASE_HEIGHT_16
    ora.z tilebase
    sta.z tilebase
    // [1632] phi from vera_layer_mode_tile::@23 vera_layer_mode_tile::@24 vera_layer_mode_tile::@25 to vera_layer_mode_tile::@26 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26]
    // [1632] phi vera_layer_mode_tile::tilebase#10 = vera_layer_mode_tile::tilebase#12 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26#0] -- register_copy 
    // vera_layer_mode_tile::@26
  __b26:
    // vera_layer_set_tilebase(layer,tilebase)
    // [1633] vera_layer_set_tilebase::layer#0 = vera_layer_mode_tile::layer#14
    // [1634] vera_layer_set_tilebase::tilebase#0 = vera_layer_mode_tile::tilebase#10
    // [1635] call vera_layer_set_tilebase
    // [1965] phi from vera_layer_mode_tile::@26 to vera_layer_set_tilebase [phi:vera_layer_mode_tile::@26->vera_layer_set_tilebase]
    // [1965] phi vera_layer_set_tilebase::tilebase#2 = vera_layer_set_tilebase::tilebase#0 [phi:vera_layer_mode_tile::@26->vera_layer_set_tilebase#0] -- register_copy 
    // [1965] phi vera_layer_set_tilebase::layer#2 = vera_layer_set_tilebase::layer#0 [phi:vera_layer_mode_tile::@26->vera_layer_set_tilebase#1] -- register_copy 
    jsr vera_layer_set_tilebase
    // vera_layer_mode_tile::@return
    // }
    // [1636] return 
    rts
    // vera_layer_mode_tile::@18
  __b18:
    // config |= VERA_LAYER_HEIGHT_128
    // [1637] vera_layer_mode_tile::config#11 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_128 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_HEIGHT_128
    ora.z config
    sta.z config
    jmp __b20
    // vera_layer_mode_tile::@17
  __b17:
    // config |= VERA_LAYER_HEIGHT_64
    // [1638] vera_layer_mode_tile::config#10 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_64 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_HEIGHT_64
    ora.z config
    sta.z config
    jmp __b20
    // vera_layer_mode_tile::@11
  __b11:
    // config |= VERA_LAYER_WIDTH_128
    // [1639] vera_layer_mode_tile::config#7 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_128 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_WIDTH_128
    ora.z config
    sta.z config
    // vera_layer_rowshift[layer] = 8
    // [1640] vera_layer_rowshift[vera_layer_mode_tile::layer#14] = 8 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #8
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 256
    // [1641] vera_layer_mode_tile::$13 = vera_layer_mode_tile::layer#14 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z __13
    // [1642] vera_layer_rowskip[vera_layer_mode_tile::$13] = $100 -- pwuc1_derefidx_vbuz1=vwuc2 
    tay
    lda #<$100
    sta vera_layer_rowskip,y
    lda #>$100
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@10
  __b10:
    // config |= VERA_LAYER_WIDTH_64
    // [1643] vera_layer_mode_tile::config#6 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_64 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_WIDTH_64
    ora.z config
    sta.z config
    // vera_layer_rowshift[layer] = 7
    // [1644] vera_layer_rowshift[vera_layer_mode_tile::layer#14] = 7 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #7
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 128
    // [1645] vera_layer_mode_tile::$12 = vera_layer_mode_tile::layer#14 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z __12
    // [1646] vera_layer_rowskip[vera_layer_mode_tile::$12] = $80 -- pwuc1_derefidx_vbuz1=vbuc2 
    lda #$80
    ldy.z __12
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@9
  __b9:
    // vera_layer_rowshift[layer] = 6
    // [1647] vera_layer_rowshift[vera_layer_mode_tile::layer#14] = 6 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #6
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 64
    // [1648] vera_layer_mode_tile::$11 = vera_layer_mode_tile::layer#14 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z __11
    // [1649] vera_layer_rowskip[vera_layer_mode_tile::$11] = $40 -- pwuc1_derefidx_vbuz1=vbuc2 
    lda #$40
    ldy.z __11
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b13
}
  // vera_layer_set_text_color_mode
/**
 * @brief Set the configuration of the layer text color mode.
 *
 * @param layer The layer of the vera 0/1.
 * @param color_mode Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
 */
// void vera_layer_set_text_color_mode(char layer, __zp($6c) char color_mode)
vera_layer_set_text_color_mode: {
    .label addr = $a9
    .label color_mode = $6c
    // char* addr = vera_layer_config[layer]
    // [1651] vera_layer_set_text_color_mode::addr#0 = *(vera_layer_config+1<<1) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+(1<<1)
    sta.z addr
    lda vera_layer_config+(1<<1)+1
    sta.z addr+1
    // *addr &= ~VERA_LAYER_CONFIG_256C
    // [1652] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 & ~VERA_LAYER_CONFIG_256C -- _deref_pbuz1=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C^$ff
    ldy #0
    and (addr),y
    sta (addr),y
    // *addr |= color_mode
    // [1653] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 | vera_layer_set_text_color_mode::color_mode#2 -- _deref_pbuz1=_deref_pbuz1_bor_vbuz2 
    lda.z color_mode
    ora (addr),y
    sta (addr),y
    // vera_layer_set_text_color_mode::@return
    // }
    // [1654] return 
    rts
}
  // vera_layer_get_mapbase_bank
/**
 * @brief Get the map base bank of the tiles for the layer.
 *
 * @param layer The layer of the vera 0/1.
 * @return vera_bank Bank in vera vram.
 */
// __zp($e0) char vera_layer_get_mapbase_bank(char layer)
vera_layer_get_mapbase_bank: {
    .const layer = 1
    .label return = $e0
    // return vera_mapbase_bank[layer];
    // [1655] vera_layer_get_mapbase_bank::return#0 = *(vera_mapbase_bank+vera_layer_get_mapbase_bank::layer#0) -- vbuz1=_deref_pbuc1 
    lda vera_mapbase_bank+layer
    sta.z return
    // vera_layer_get_mapbase_bank::@return
    // }
    // [1656] return 
    rts
}
  // vera_layer_get_mapbase_offset
/**
 * @brief Get the map base lower 16-bit address (offset) of the tiles for the layer.
 *
 * @param layer The layer of the vera 0/1.
 * @return vera_offset Offset in vera vram of the specified bank.
 */
// __zp($dc) unsigned int vera_layer_get_mapbase_offset(char layer)
vera_layer_get_mapbase_offset: {
    .const layer = 1
    .label return = $dc
    // return vera_mapbase_offset[layer];
    // [1657] vera_layer_get_mapbase_offset::return#0 = *(vera_mapbase_offset+vera_layer_get_mapbase_offset::layer#0<<1) -- vwuz1=_deref_pwuc1 
    lda vera_mapbase_offset+(layer<<1)
    sta.z return
    lda vera_mapbase_offset+(layer<<1)+1
    sta.z return+1
    // vera_layer_get_mapbase_offset::@return
    // }
    // [1658] return 
    rts
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [1659] if(conio_cursor_y[*((char *)&cx16_conio)]<*((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    ldy cx16_conio
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b3
    // cscroll::@1
    // if(conio_scroll_enable[cx16_conio.conio_screen_layer])
    // [1660] if(0!=conio_scroll_enable[*((char *)&cx16_conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    lda conio_scroll_enable,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [1661] if(conio_cursor_y[*((char *)&cx16_conio)]<*((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    // [1662] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
  __b3:
    // cscroll::@return
    // }
    // [1663] return 
    rts
    // [1664] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [1665] call insertup
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, cx16_conio.conio_screen_height-1)
    // [1666] gotoxy::y#2 = *((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    stx.z gotoxy.y
    // [1667] call gotoxy
    // [242] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [242] phi gotoxy::y#35 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    jsr gotoxy
    // [1668] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [1669] call clearline
    jsr clearline
    rts
}
  // vera_layer_get_backcolor
/**
 * @brief Get the back color for text output. The old back text color setting is returned.
 *
 * @param layer The layer of the vera 0/1.
 * @return vera_backcolor a 4 bit value ( decimal between 0 and 15).
 * This will only work when the VERA is in 16 color mode!
 * Note that on the VERA, the transparent color has value 0.
 */
// __zp($10) char vera_layer_get_backcolor(__zp($10) char layer)
vera_layer_get_backcolor: {
    .label return = $10
    .label layer = $10
    // return vera_layer_backcolor[layer];
    // [1670] vera_layer_get_backcolor::return#0 = vera_layer_backcolor[vera_layer_get_backcolor::layer#0] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_backcolor,y
    sta.z return
    // vera_layer_get_backcolor::@return
    // }
    // [1671] return 
    rts
}
  // vera_layer_get_textcolor
/**
 * @brief Get the front color for text output. The old front text color setting is returned.
 *
 * @param layer The layer of the vera 0/1.
 * @return vera_forecolor A 4 bit value ( decimal between 0 and 15).
 * This will only work when the VERA is in 16 color mode!
 * Note that on the VERA, the transparent color has value 0.
 */
// __zp($16) char vera_layer_get_textcolor(__zp($16) char layer)
vera_layer_get_textcolor: {
    .label return = $16
    .label layer = $16
    // return vera_layer_textcolor[layer];
    // [1672] vera_layer_get_textcolor::return#0 = vera_layer_textcolor[vera_layer_get_textcolor::layer#0] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_textcolor,y
    sta.z return
    // vera_layer_get_textcolor::@return
    // }
    // [1673] return 
    rts
}
  // cx16_cpy_vram_from_vram
/**
 * @brief Copy block of memory from vram to vram.
 * Copies num bytes from the source vram bank/offset to the destination vram bank/offset.
 *
 * @param dbank_vram Destination vram bank.
 * @param doffset_vram Destination vram offset.
 * @param sbank_vram Source vram bank.
 * @param soffset_vram Source vram offset.
 * @param num Amount of bytes to copy.
 */
// void cx16_cpy_vram_from_vram(__zp($cf) char dbank_vram, __zp($3e) unsigned int doffset_vram, char sbank_vram, unsigned int soffset_vram, unsigned int num)
cx16_cpy_vram_from_vram: {
    .label vera_vram_data0_bank_offset1___0 = $d6
    .label vera_vram_data0_bank_offset1___1 = $be
    .label vera_vram_data0_bank_offset1___2 = $da
    .label vera_vram_data1_bank_offset1___0 = $78
    .label vera_vram_data1_bank_offset1___1 = $b2
    .label vera_vram_data1_bank_offset1___2 = $cf
    .label vera_vram_data0_bank_offset1_bank = $da
    .label vera_vram_data0_bank_offset1_offset = $5d
    .label i = $55
    .label dbank_vram = $cf
    .label doffset_vram = $3e
    // cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1675] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1676] cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_$0 = byte0  cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 -- vbuz1=_byte0_vwuz2 
    lda.z vera_vram_data0_bank_offset1_offset
    sta.z vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1677] *VERA_ADDRX_L = cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1678] cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_$1 = byte1  cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_offset#0 -- vbuz1=_byte1_vwuz2 
    lda.z vera_vram_data0_bank_offset1_offset+1
    sta.z vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1679] *VERA_ADDRX_M = cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // bank | inc_dec
    // [1680] cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_$2 = cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_bank#0 | vera_inc_1 -- vbuz1=vbuz1_bor_vbuc1 
    lda #vera_inc_1
    ora.z vera_vram_data0_bank_offset1___2
    sta.z vera_vram_data0_bank_offset1___2
    // *VERA_ADDRX_H = bank | inc_dec
    // [1681] *VERA_ADDRX_H = cx16_cpy_vram_from_vram::vera_vram_data0_bank_offset1_$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // cx16_cpy_vram_from_vram::vera_vram_data1_bank_offset1
    // *VERA_CTRL |= VERA_ADDRSEL
    // [1682] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1683] cx16_cpy_vram_from_vram::vera_vram_data1_bank_offset1_$0 = byte0  cx16_cpy_vram_from_vram::doffset_vram#15 -- vbuz1=_byte0_vwuz2 
    lda.z doffset_vram
    sta.z vera_vram_data1_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1684] *VERA_ADDRX_L = cx16_cpy_vram_from_vram::vera_vram_data1_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1685] cx16_cpy_vram_from_vram::vera_vram_data1_bank_offset1_$1 = byte1  cx16_cpy_vram_from_vram::doffset_vram#15 -- vbuz1=_byte1_vwuz2 
    lda.z doffset_vram+1
    sta.z vera_vram_data1_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1686] *VERA_ADDRX_M = cx16_cpy_vram_from_vram::vera_vram_data1_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // bank | inc_dec
    // [1687] cx16_cpy_vram_from_vram::vera_vram_data1_bank_offset1_$2 = cx16_cpy_vram_from_vram::dbank_vram#15 | vera_inc_1 -- vbuz1=vbuz1_bor_vbuc1 
    lda #vera_inc_1
    ora.z vera_vram_data1_bank_offset1___2
    sta.z vera_vram_data1_bank_offset1___2
    // *VERA_ADDRX_H = bank | inc_dec
    // [1688] *VERA_ADDRX_H = cx16_cpy_vram_from_vram::vera_vram_data1_bank_offset1_$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [1689] phi from cx16_cpy_vram_from_vram::vera_vram_data1_bank_offset1 to cx16_cpy_vram_from_vram::@1 [phi:cx16_cpy_vram_from_vram::vera_vram_data1_bank_offset1->cx16_cpy_vram_from_vram::@1]
    // [1689] phi cx16_cpy_vram_from_vram::i#2 = 0 [phi:cx16_cpy_vram_from_vram::vera_vram_data1_bank_offset1->cx16_cpy_vram_from_vram::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // cx16_cpy_vram_from_vram::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [1690] if(cx16_cpy_vram_from_vram::i#2<$100*8) goto cx16_cpy_vram_from_vram::@2 -- vwuz1_lt_vwuc1_then_la1 
    lda.z i+1
    cmp #>$100*8
    bcc __b2
    bne !+
    lda.z i
    cmp #<$100*8
    bcc __b2
  !:
    // cx16_cpy_vram_from_vram::@return
    // }
    // [1691] return 
    rts
    // cx16_cpy_vram_from_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [1692] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [1693] cx16_cpy_vram_from_vram::i#1 = ++ cx16_cpy_vram_from_vram::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [1689] phi from cx16_cpy_vram_from_vram::@2 to cx16_cpy_vram_from_vram::@1 [phi:cx16_cpy_vram_from_vram::@2->cx16_cpy_vram_from_vram::@1]
    // [1689] phi cx16_cpy_vram_from_vram::i#2 = cx16_cpy_vram_from_vram::i#1 [phi:cx16_cpy_vram_from_vram::@2->cx16_cpy_vram_from_vram::@1#0] -- register_copy 
    jmp __b1
}
  // cx16_cpy_vram_from_ram
/**
 * @brief Copy block of memory from ram to vram.
 * Copies num bytes from the ram source pointer to the vram bank/offset.
 *
 * @param dbank_vram Destination vram bank.
 * @param doffset_vram The destination vram offset, 0x0000 till 0xFFFF)
 * @param sptr_ram Source pointer in ram.
 * @param num Amount of bytes to copy.
 */
// void cx16_cpy_vram_from_ram(char dbank_vram, __zp(6) unsigned int doffset_vram, __zp(2) void *sptr_ram, __zp($34) unsigned int num)
cx16_cpy_vram_from_ram: {
    .label vera_vram_data0_bank_offset1___0 = $b
    .label vera_vram_data0_bank_offset1___1 = $a
    .label vera_vram_data0_bank_offset1___2 = $15
    .label vera_vram_data0_bank_offset1_bank = $15
    .label vera_vram_data0_bank_offset1_offset = 6
    .label end = $34
    .label s = 2
    .label doffset_vram = 6
    .label sptr_ram = 2
    .label num = $34
    // cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1695] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1696] cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_$0 = byte0  cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_offset#0 -- vbuz1=_byte0_vwuz2 
    lda.z vera_vram_data0_bank_offset1_offset
    sta.z vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1697] *VERA_ADDRX_L = cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1698] cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_$1 = byte1  cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_offset#0 -- vbuz1=_byte1_vwuz2 
    lda.z vera_vram_data0_bank_offset1_offset+1
    sta.z vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1699] *VERA_ADDRX_M = cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // bank | inc_dec
    // [1700] cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_$2 = cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_bank#0 | vera_inc_1 -- vbuz1=vbuz1_bor_vbuc1 
    lda #vera_inc_1
    ora.z vera_vram_data0_bank_offset1___2
    sta.z vera_vram_data0_bank_offset1___2
    // *VERA_ADDRX_H = bank | inc_dec
    // [1701] *VERA_ADDRX_H = cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1_$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // cx16_cpy_vram_from_ram::@3
    // unsigned char *end = (unsigned char*)sptr_ram+num
    // [1702] cx16_cpy_vram_from_ram::end#0 = (char *)cx16_cpy_vram_from_ram::sptr_ram#10 + cx16_cpy_vram_from_ram::num#10 -- pbuz1=pbuz2_plus_vwuz1 
    // Transfer the data
    clc
    lda.z end
    adc.z sptr_ram
    sta.z end
    lda.z end+1
    adc.z sptr_ram+1
    sta.z end+1
    // [1703] cx16_cpy_vram_from_ram::s#5 = (char *)cx16_cpy_vram_from_ram::sptr_ram#10
    // [1704] phi from cx16_cpy_vram_from_ram::@2 cx16_cpy_vram_from_ram::@3 to cx16_cpy_vram_from_ram::@1 [phi:cx16_cpy_vram_from_ram::@2/cx16_cpy_vram_from_ram::@3->cx16_cpy_vram_from_ram::@1]
    // [1704] phi cx16_cpy_vram_from_ram::s#2 = cx16_cpy_vram_from_ram::s#1 [phi:cx16_cpy_vram_from_ram::@2/cx16_cpy_vram_from_ram::@3->cx16_cpy_vram_from_ram::@1#0] -- register_copy 
    // cx16_cpy_vram_from_ram::@1
  __b1:
    // for(char *s = sptr_ram; s!=end; s++)
    // [1705] if(cx16_cpy_vram_from_ram::s#2!=cx16_cpy_vram_from_ram::end#0) goto cx16_cpy_vram_from_ram::@2 -- pbuz1_neq_pbuz2_then_la1 
    lda.z s+1
    cmp.z end+1
    bne __b2
    lda.z s
    cmp.z end
    bne __b2
    // cx16_cpy_vram_from_ram::@return
    // }
    // [1706] return 
    rts
    // cx16_cpy_vram_from_ram::@2
  __b2:
    // *VERA_DATA0 = *s
    // [1707] *VERA_DATA0 = *cx16_cpy_vram_from_ram::s#2 -- _deref_pbuc1=_deref_pbuz1 
    ldy #0
    lda (s),y
    sta VERA_DATA0
    // for(char *s = sptr_ram; s!=end; s++)
    // [1708] cx16_cpy_vram_from_ram::s#1 = ++ cx16_cpy_vram_from_ram::s#2 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    jmp __b1
}
  // vera_tile_area
/// VERA TILING
// void vera_tile_area(char layer, __zp(6) unsigned int tileindex, __zp($67) char x, __zp($10) char y, __zp($64) char w, __zp($66) char h, __zp($a) char hflip, __zp($19) char vflip, __zp($15) char offset)
vera_tile_area: {
    .label __4 = $58
    .label __5 = $67
    .label __10 = $58
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1___0 = 9
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1___1 = $22
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1___2 = 8
    .label mapbase = $2c
    .label shift = $b
    .label rowskip = $53
    .label hflip = $a
    .label vflip = $19
    .label offset = $15
    .label index_l = $18
    .label index_h = $12
    .label index_h_1 = $a
    .label index_h_2 = $19
    .label index_h_3 = $15
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank = 8
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset = $c
    .label c = $3d
    .label r = $48
    .label tileindex = 6
    .label x = $67
    .label y = $10
    .label h = $66
    .label w = $64
    // unsigned long mapbase = vera_mapbase_address[layer]
    // [1710] vera_tile_area::mapbase#0 = *vera_mapbase_address -- vduz1=_deref_pduc1 
    lda vera_mapbase_address
    sta.z mapbase
    lda vera_mapbase_address+1
    sta.z mapbase+1
    lda vera_mapbase_address+2
    sta.z mapbase+2
    lda vera_mapbase_address+3
    sta.z mapbase+3
    // char shift = vera_layer_rowshift[layer]
    // [1711] vera_tile_area::shift#0 = *vera_layer_rowshift -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift
    sta.z shift
    // unsigned int rowskip = (unsigned int)1 << shift
    // [1712] vera_tile_area::rowskip#0 = 1 << vera_tile_area::shift#0 -- vwuz1=vwuc1_rol_vbuz2 
    tay
    lda #<1
    sta.z rowskip
    lda #>1+1
    sta.z rowskip+1
    cpy #0
    beq !e+
  !:
    asl.z rowskip
    rol.z rowskip+1
    dey
    bne !-
  !e:
    // hflip = vera_layer_hflip[hflip]
    // [1713] vera_tile_area::hflip#0 = *vera_layer_hflip -- vbuz1=_deref_pbuc1 
    lda vera_layer_hflip
    sta.z hflip
    // vflip = vera_layer_vflip[vflip]
    // [1714] vera_tile_area::vflip#0 = *vera_layer_vflip -- vbuz1=_deref_pbuc1 
    lda vera_layer_vflip
    sta.z vflip
    // offset = offset << 4
    // [1715] vera_tile_area::offset#0 = vera_tile_area::offset#36 << 4 -- vbuz1=vbuz1_rol_4 
    lda.z offset
    asl
    asl
    asl
    asl
    sta.z offset
    // char index_l = BYTE0(tileindex)
    // [1716] vera_tile_area::index_l#0 = byte0  vera_tile_area::tileindex#35 -- vbuz1=_byte0_vwuz2 
    lda.z tileindex
    sta.z index_l
    // char index_h = BYTE1(tileindex)
    // [1717] vera_tile_area::index_h#0 = byte1  vera_tile_area::tileindex#35 -- vbuz1=_byte1_vwuz2 
    lda.z tileindex+1
    sta.z index_h
    // index_h |= hflip
    // [1718] vera_tile_area::index_h#1 = vera_tile_area::index_h#0 | vera_tile_area::hflip#0 -- vbuz1=vbuz2_bor_vbuz1 
    lda.z index_h_1
    ora.z index_h
    sta.z index_h_1
    // index_h |= vflip
    // [1719] vera_tile_area::index_h#2 = vera_tile_area::index_h#1 | vera_tile_area::vflip#0 -- vbuz1=vbuz2_bor_vbuz1 
    lda.z index_h_2
    ora.z index_h_1
    sta.z index_h_2
    // index_h |= offset
    // [1720] vera_tile_area::index_h#3 = vera_tile_area::index_h#2 | vera_tile_area::offset#0 -- vbuz1=vbuz2_bor_vbuz1 
    lda.z index_h_3
    ora.z index_h_2
    sta.z index_h_3
    // (unsigned int)y << shift
    // [1721] vera_tile_area::$10 = (unsigned int)vera_tile_area::y#35 -- vwuz1=_word_vbuz2 
    lda.z y
    sta.z __10
    lda #0
    sta.z __10+1
    // [1722] vera_tile_area::$4 = vera_tile_area::$10 << vera_tile_area::shift#0 -- vwuz1=vwuz1_rol_vbuz2 
    ldy.z shift
    beq !e+
  !:
    asl.z __4
    rol.z __4+1
    dey
    bne !-
  !e:
    // mapbase += ((unsigned int)y << shift)
    // [1723] vera_tile_area::mapbase#1 = vera_tile_area::mapbase#0 + vera_tile_area::$4 -- vduz1=vduz1_plus_vwuz2 
    lda.z mapbase
    clc
    adc.z __4
    sta.z mapbase
    lda.z mapbase+1
    adc.z __4+1
    sta.z mapbase+1
    lda.z mapbase+2
    adc #0
    sta.z mapbase+2
    lda.z mapbase+3
    adc #0
    sta.z mapbase+3
    // x << 1
    // [1724] vera_tile_area::$5 = vera_tile_area::x#35 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __5
    // mapbase += (x << 1)
    // [1725] vera_tile_area::mapbase#2 = vera_tile_area::mapbase#1 + vera_tile_area::$5 -- vduz1=vduz1_plus_vbuz2 
    lda.z __5
    clc
    adc.z mapbase
    sta.z mapbase
    lda.z mapbase+1
    adc #0
    sta.z mapbase+1
    lda.z mapbase+2
    adc #0
    sta.z mapbase+2
    lda.z mapbase+3
    adc #0
    sta.z mapbase+3
    // [1726] phi from vera_tile_area to vera_tile_area::@1 [phi:vera_tile_area->vera_tile_area::@1]
    // [1726] phi vera_tile_area::mapbase#10 = vera_tile_area::mapbase#2 [phi:vera_tile_area->vera_tile_area::@1#0] -- register_copy 
    // [1726] phi vera_tile_area::r#2 = 0 [phi:vera_tile_area->vera_tile_area::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // vera_tile_area::@1
  __b1:
    // for(char r=0; r<h; r++)
    // [1727] if(vera_tile_area::r#2<vera_tile_area::h#36) goto vera_tile_area::vera_vram_data0_address1 -- vbuz1_lt_vbuz2_then_la1 
    lda.z r
    cmp.z h
    bcc vera_vram_data0_address1
    // vera_tile_area::@return
    // }
    // [1728] return 
    rts
    // vera_tile_area::vera_vram_data0_address1
  vera_vram_data0_address1:
    // vera_vram_data0_bank_offset( BYTE2(bankaddr), WORD0(bankaddr), inc_dec )
    // [1729] vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank#0 = byte2  vera_tile_area::mapbase#10 -- vbuz1=_byte2_vduz2 
    lda.z mapbase+2
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank
    // [1730] vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 = word0  vera_tile_area::mapbase#10 -- vwuz1=_word0_vduz2 
    lda.z mapbase
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset
    lda.z mapbase+1
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset+1
    // vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1731] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1732] vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$0 = byte0  vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 -- vbuz1=_byte0_vwuz2 
    lda.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1733] *VERA_ADDRX_L = vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1734] vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$1 = byte1  vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 -- vbuz1=_byte1_vwuz2 
    lda.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset+1
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1735] *VERA_ADDRX_M = vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // bank | inc_dec
    // [1736] vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$2 = vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank#0 | VERA_INC_1 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_INC_1
    ora.z vera_vram_data0_address1_vera_vram_data0_bank_offset1___2
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1___2
    // *VERA_ADDRX_H = bank | inc_dec
    // [1737] *VERA_ADDRX_H = vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [1738] phi from vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1 to vera_tile_area::@2 [phi:vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1->vera_tile_area::@2]
    // [1738] phi vera_tile_area::c#2 = 0 [phi:vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1->vera_tile_area::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // vera_tile_area::@2
  __b2:
    // for(char c=0; c<w; c++)
    // [1739] if(vera_tile_area::c#2<vera_tile_area::w#42) goto vera_tile_area::@3 -- vbuz1_lt_vbuz2_then_la1 
    lda.z c
    cmp.z w
    bcc __b3
    // vera_tile_area::@4
    // mapbase += rowskip
    // [1740] vera_tile_area::mapbase#3 = vera_tile_area::mapbase#10 + vera_tile_area::rowskip#0 -- vduz1=vduz1_plus_vwuz2 
    lda.z mapbase
    clc
    adc.z rowskip
    sta.z mapbase
    lda.z mapbase+1
    adc.z rowskip+1
    sta.z mapbase+1
    lda.z mapbase+2
    adc #0
    sta.z mapbase+2
    lda.z mapbase+3
    adc #0
    sta.z mapbase+3
    // for(char r=0; r<h; r++)
    // [1741] vera_tile_area::r#1 = ++ vera_tile_area::r#2 -- vbuz1=_inc_vbuz1 
    inc.z r
    // [1726] phi from vera_tile_area::@4 to vera_tile_area::@1 [phi:vera_tile_area::@4->vera_tile_area::@1]
    // [1726] phi vera_tile_area::mapbase#10 = vera_tile_area::mapbase#3 [phi:vera_tile_area::@4->vera_tile_area::@1#0] -- register_copy 
    // [1726] phi vera_tile_area::r#2 = vera_tile_area::r#1 [phi:vera_tile_area::@4->vera_tile_area::@1#1] -- register_copy 
    jmp __b1
    // vera_tile_area::@3
  __b3:
    // *VERA_DATA0 = index_l
    // [1742] *VERA_DATA0 = vera_tile_area::index_l#0 -- _deref_pbuc1=vbuz1 
    lda.z index_l
    sta VERA_DATA0
    // *VERA_DATA0 = index_h
    // [1743] *VERA_DATA0 = vera_tile_area::index_h#3 -- _deref_pbuc1=vbuz1 
    lda.z index_h_3
    sta VERA_DATA0
    // for(char c=0; c<w; c++)
    // [1744] vera_tile_area::c#1 = ++ vera_tile_area::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [1738] phi from vera_tile_area::@3 to vera_tile_area::@2 [phi:vera_tile_area::@3->vera_tile_area::@2]
    // [1738] phi vera_tile_area::c#2 = vera_tile_area::c#1 [phi:vera_tile_area::@3->vera_tile_area::@2#0] -- register_copy 
    jmp __b2
}
  // vera_layer_mode_bitmap
// Set a vera layer in bitmap mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - mapwidth: The width of the map, which can be 320 or 640.
// - color_depth: The color color depth, which can have values 1, 2, 4, 8, for 1 color, 4 colors, 16 colors or 256 colors respectively.
// void vera_layer_mode_bitmap(char layer, unsigned long bitmap_address, __zp(2) unsigned int mapwidth, __zp($49) unsigned int color_depth)
vera_layer_mode_bitmap: {
    .label color_depth = $49
    // config
    .label config = $d7
    .label tilebase = $bb
    .label mapwidth = 2
    // case 1:
    //             config |= VERA_LAYER_COLOR_DEPTH_1BPP;
    //             break;
    // [1746] if(vera_layer_mode_bitmap::color_depth#6==1) goto vera_layer_mode_bitmap::@5 -- vwuz1_eq_vbuc1_then_la1 
    lda.z color_depth+1
    bne !+
    lda.z color_depth
    cmp #1
    beq __b1
  !:
    // vera_layer_mode_bitmap::@1
    // case 2:
    //             config |= VERA_LAYER_COLOR_DEPTH_2BPP;
    //             break;
    // [1747] if(vera_layer_mode_bitmap::color_depth#6==2) goto vera_layer_mode_bitmap::@5 -- vwuz1_eq_vbuc1_then_la1 
    lda.z color_depth+1
    bne !+
    lda.z color_depth
    cmp #2
    beq __b2
  !:
    // vera_layer_mode_bitmap::@2
    // case 4:
    //             config |= VERA_LAYER_COLOR_DEPTH_4BPP;
    //             break;
    // [1748] if(vera_layer_mode_bitmap::color_depth#6==4) goto vera_layer_mode_bitmap::@5 -- vwuz1_eq_vbuc1_then_la1 
    lda.z color_depth+1
    bne !+
    lda.z color_depth
    cmp #4
    beq __b3
  !:
    // vera_layer_mode_bitmap::@3
    // case 8:
    //             config |= VERA_LAYER_COLOR_DEPTH_8BPP;
    //             break;
    // [1749] if(vera_layer_mode_bitmap::color_depth#6!=8) goto vera_layer_mode_bitmap::@5 -- vwuz1_neq_vbuc1_then_la1 
    lda.z color_depth+1
    bne __b4
    lda.z color_depth
    cmp #8
    bne __b4
    // [1750] phi from vera_layer_mode_bitmap::@3 to vera_layer_mode_bitmap::@4 [phi:vera_layer_mode_bitmap::@3->vera_layer_mode_bitmap::@4]
    // vera_layer_mode_bitmap::@4
    // [1751] phi from vera_layer_mode_bitmap::@4 to vera_layer_mode_bitmap::@5 [phi:vera_layer_mode_bitmap::@4->vera_layer_mode_bitmap::@5]
    // [1751] phi vera_layer_mode_bitmap::config#10 = VERA_LAYER_COLOR_DEPTH_8BPP [phi:vera_layer_mode_bitmap::@4->vera_layer_mode_bitmap::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_8BPP
    sta.z config
    jmp __b5
    // [1751] phi from vera_layer_mode_bitmap to vera_layer_mode_bitmap::@5 [phi:vera_layer_mode_bitmap->vera_layer_mode_bitmap::@5]
  __b1:
    // [1751] phi vera_layer_mode_bitmap::config#10 = VERA_LAYER_COLOR_DEPTH_1BPP [phi:vera_layer_mode_bitmap->vera_layer_mode_bitmap::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_1BPP
    sta.z config
    jmp __b5
    // [1751] phi from vera_layer_mode_bitmap::@1 to vera_layer_mode_bitmap::@5 [phi:vera_layer_mode_bitmap::@1->vera_layer_mode_bitmap::@5]
  __b2:
    // [1751] phi vera_layer_mode_bitmap::config#10 = VERA_LAYER_COLOR_DEPTH_2BPP [phi:vera_layer_mode_bitmap::@1->vera_layer_mode_bitmap::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_2BPP
    sta.z config
    jmp __b5
    // [1751] phi from vera_layer_mode_bitmap::@2 to vera_layer_mode_bitmap::@5 [phi:vera_layer_mode_bitmap::@2->vera_layer_mode_bitmap::@5]
  __b3:
    // [1751] phi vera_layer_mode_bitmap::config#10 = VERA_LAYER_COLOR_DEPTH_4BPP [phi:vera_layer_mode_bitmap::@2->vera_layer_mode_bitmap::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_4BPP
    sta.z config
    jmp __b5
    // [1751] phi from vera_layer_mode_bitmap::@3 to vera_layer_mode_bitmap::@5 [phi:vera_layer_mode_bitmap::@3->vera_layer_mode_bitmap::@5]
  __b4:
    // [1751] phi vera_layer_mode_bitmap::config#10 = 0 [phi:vera_layer_mode_bitmap::@3->vera_layer_mode_bitmap::@5#0] -- vbuz1=vbuc1 
    lda #0
    sta.z config
    // vera_layer_mode_bitmap::@5
  __b5:
    // config = config | VERA_LAYER_CONFIG_MODE_BITMAP
    // [1752] vera_layer_mode_bitmap::config#11 = vera_layer_mode_bitmap::config#10 | VERA_LAYER_CONFIG_MODE_BITMAP -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_CONFIG_MODE_BITMAP
    ora.z config
    sta.z config
    // vera_tilebase_offset[layer] = WORD0(bitmap_address)
    // [1753] *vera_tilebase_offset = 0 -- _deref_pwuc1=vwuc2 
    // tilebase
    lda #<0
    sta vera_tilebase_offset
    sta vera_tilebase_offset+1
    // vera_tilebase_bank[layer] = BYTE2(bitmap_address)
    // [1754] *vera_tilebase_bank = 0 -- _deref_pbuc1=vbuc2 
    sta vera_tilebase_bank
    // vera_tilebase_address[layer] = bitmap_address
    // [1755] *vera_tilebase_address = 0 -- _deref_pduc1=vduc2 
    sta vera_tilebase_address
    sta vera_tilebase_address+1
    lda #<0>>$10
    sta vera_tilebase_address+2
    lda #>0>>$10
    sta vera_tilebase_address+3
    // case 320:
    //             vera_display_set_scale_double();
    //             tilebase |= VERA_TILEBASE_WIDTH_8;
    //             break;
    // [1756] if(vera_layer_mode_bitmap::mapwidth#10==$140) goto vera_layer_mode_bitmap::vera_display_set_scale_double1 -- vwuz1_eq_vwuc1_then_la1 
    lda.z mapwidth
    cmp #<$140
    bne !+
    lda.z mapwidth+1
    cmp #>$140
    beq vera_display_set_scale_double1
  !:
    // vera_layer_mode_bitmap::@6
    // case 640:
    //             vera_display_set_scale_none();
    //             tilebase |= VERA_TILEBASE_WIDTH_16;
    //             break;
    // [1757] if(vera_layer_mode_bitmap::mapwidth#10==$280) goto vera_layer_mode_bitmap::vera_display_set_scale_none1 -- vwuz1_eq_vwuc1_then_la1 
    lda.z mapwidth
    cmp #<$280
    bne !+
    lda.z mapwidth+1
    cmp #>$280
    beq vera_display_set_scale_none1
  !:
    // [1760] phi from vera_layer_mode_bitmap::@6 vera_layer_mode_bitmap::vera_display_set_scale_double1 to vera_layer_mode_bitmap::@7 [phi:vera_layer_mode_bitmap::@6/vera_layer_mode_bitmap::vera_display_set_scale_double1->vera_layer_mode_bitmap::@7]
  __b6:
    // [1760] phi vera_layer_mode_bitmap::tilebase#6 = 0 [phi:vera_layer_mode_bitmap::@6/vera_layer_mode_bitmap::vera_display_set_scale_double1->vera_layer_mode_bitmap::@7#0] -- vbuz1=vbuc1 
    lda #0
    sta.z tilebase
    jmp __b7
    // vera_layer_mode_bitmap::vera_display_set_scale_none1
  vera_display_set_scale_none1:
    // *VERA_DC_HSCALE = 128
    // [1758] *VERA_DC_HSCALE = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 128
    // [1759] *VERA_DC_VSCALE = $80 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    // [1760] phi from vera_layer_mode_bitmap::vera_display_set_scale_none1 to vera_layer_mode_bitmap::@7 [phi:vera_layer_mode_bitmap::vera_display_set_scale_none1->vera_layer_mode_bitmap::@7]
    // [1760] phi vera_layer_mode_bitmap::tilebase#6 = VERA_TILEBASE_WIDTH_16 [phi:vera_layer_mode_bitmap::vera_display_set_scale_none1->vera_layer_mode_bitmap::@7#0] -- vbuz1=vbuc1 
    lda #VERA_TILEBASE_WIDTH_16
    sta.z tilebase
    // vera_layer_mode_bitmap::@7
  __b7:
    // vera_layer_set_config(layer, config)
    // [1761] vera_layer_set_config::config#1 = vera_layer_mode_bitmap::config#11 -- vbuz1=vbuz2 
    lda.z config
    sta.z vera_layer_set_config.config
    // [1762] call vera_layer_set_config
    // [1960] phi from vera_layer_mode_bitmap::@7 to vera_layer_set_config [phi:vera_layer_mode_bitmap::@7->vera_layer_set_config]
    // [1960] phi vera_layer_set_config::config#2 = vera_layer_set_config::config#1 [phi:vera_layer_mode_bitmap::@7->vera_layer_set_config#0] -- register_copy 
    // [1960] phi vera_layer_set_config::layer#2 = 0 [phi:vera_layer_mode_bitmap::@7->vera_layer_set_config#1] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_set_config.layer
    jsr vera_layer_set_config
    // vera_layer_mode_bitmap::@8
    // vera_layer_set_tilebase(layer,tilebase)
    // [1763] vera_layer_set_tilebase::tilebase#1 = vera_layer_mode_bitmap::tilebase#6 -- vbuz1=vbuz2 
    lda.z tilebase
    sta.z vera_layer_set_tilebase.tilebase
    // [1764] call vera_layer_set_tilebase
    // [1965] phi from vera_layer_mode_bitmap::@8 to vera_layer_set_tilebase [phi:vera_layer_mode_bitmap::@8->vera_layer_set_tilebase]
    // [1965] phi vera_layer_set_tilebase::tilebase#2 = vera_layer_set_tilebase::tilebase#1 [phi:vera_layer_mode_bitmap::@8->vera_layer_set_tilebase#0] -- register_copy 
    // [1965] phi vera_layer_set_tilebase::layer#2 = 0 [phi:vera_layer_mode_bitmap::@8->vera_layer_set_tilebase#1] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_set_tilebase.layer
    jsr vera_layer_set_tilebase
    // vera_layer_mode_bitmap::@return
    // }
    // [1765] return 
    rts
    // vera_layer_mode_bitmap::vera_display_set_scale_double1
  vera_display_set_scale_double1:
    // *VERA_DC_HSCALE = 64
    // [1766] *VERA_DC_HSCALE = $40 -- _deref_pbuc1=vbuc2 
    lda #$40
    sta VERA_DC_HSCALE
    // *VERA_DC_VSCALE = 64
    // [1767] *VERA_DC_VSCALE = $40 -- _deref_pbuc1=vbuc2 
    sta VERA_DC_VSCALE
    jmp __b6
}
  // bitmap_init
// Initialize the bitmap plotter tables for a specific bitmap
// void bitmap_init(char layer, unsigned long address)
bitmap_init: {
    .label __0 = $ce
    .label __1 = $69
    .label __2 = $68
    .label __3 = $c3
    .label __4 = $c3
    .label __7 = $1e
    .label __10 = $46
    .label __13 = $1b
    .label __23 = $38
    .label __24 = $42
    .label __25 = $4b
    .label __26 = $5f
    .label __27 = $c3
    .label __28 = $e
    .label vera_layer_get_color_depth1___0 = $ce
    .label vera_layer_get_color_depth1___1 = $c5
    .label vera_layer_get_color_depth1_layer = $c5
    .label vera_layer_get_color_depth1_config = 4
    .label vera_layer_get_color_depth1_return = $ce
    .label bitmask = $6e
    .label bitshift = $6f
    .label x = $34
    .label hdelta = $c
    .label yoffs = $2c
    .label y = $40
    .label __29 = $38
    .label __30 = $4d
    .label __31 = $61
    .label __32 = $42
    .label __33 = $36
    .label __34 = $20
    .label __35 = $4b
    .label __36 = $13
    .label __37 = $32
    .label __38 = $5f
    .label __39 = $4f
    .label __40 = $58
    .label __41 = $e
    // __bitmap_address = address
    // [1768] __bitmap_address = 0 -- vduz1=vbuc1 
    lda #0
    sta.z __bitmap_address
    sta.z __bitmap_address+1
    sta.z __bitmap_address+2
    sta.z __bitmap_address+3
    // __bitmap_layer = layer
    // [1769] __bitmap_layer = 0 -- vbuz1=vbuc1 
    sta.z __bitmap_layer
    // vera_layer_get_color_depth(__bitmap_layer)
    // [1770] bitmap_init::vera_layer_get_color_depth1_layer#0 = __bitmap_layer -- vbuz1=vbuz2 
    sta.z vera_layer_get_color_depth1_layer
    // bitmap_init::vera_layer_get_color_depth1
    // char* config = vera_layer_config[layer]
    // [1771] bitmap_init::vera_layer_get_color_depth1_$1 = bitmap_init::vera_layer_get_color_depth1_layer#0 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z vera_layer_get_color_depth1___1
    // [1772] bitmap_init::vera_layer_get_color_depth1_config#0 = vera_layer_config[bitmap_init::vera_layer_get_color_depth1_$1] -- pbuz1=qbuc1_derefidx_vbuz2 
    ldy.z vera_layer_get_color_depth1___1
    lda vera_layer_config,y
    sta.z vera_layer_get_color_depth1_config
    lda vera_layer_config+1,y
    sta.z vera_layer_get_color_depth1_config+1
    // *config & VERA_LAYER_COLOR_DEPTH_MASK
    // [1773] bitmap_init::vera_layer_get_color_depth1_$0 = *bitmap_init::vera_layer_get_color_depth1_config#0 & VERA_LAYER_COLOR_DEPTH_MASK -- vbuz1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_MASK
    ldy #0
    and (vera_layer_get_color_depth1_config),y
    sta.z vera_layer_get_color_depth1___0
    // return (*config & VERA_LAYER_COLOR_DEPTH_MASK);
    // [1774] bitmap_init::vera_layer_get_color_depth1_return#0 = bitmap_init::vera_layer_get_color_depth1_$0
    // bitmap_init::vera_layer_get_color_depth1_@return
    // }
    // [1775] bitmap_init::vera_layer_get_color_depth1_return#1 = bitmap_init::vera_layer_get_color_depth1_return#0
    // bitmap_init::@16
    // vera_layer_get_color_depth(__bitmap_layer)
    // [1776] bitmap_init::$0 = bitmap_init::vera_layer_get_color_depth1_return#1
    // __bitmap_color_depth = vera_layer_get_color_depth(__bitmap_layer)
    // [1777] __bitmap_color_depth = bitmap_init::$0 -- vbuz1=vbuz2 
    lda.z __0
    sta.z __bitmap_color_depth
    // vera_display_get_hscale()
    // [1778] call vera_display_get_hscale
    // [2006] phi from bitmap_init::@16 to vera_display_get_hscale [phi:bitmap_init::@16->vera_display_get_hscale]
    jsr vera_display_get_hscale
    // vera_display_get_hscale()
    // [1779] vera_display_get_hscale::return#2 = vera_display_get_hscale::return#0
    // bitmap_init::@17
    // [1780] bitmap_init::$1 = vera_display_get_hscale::return#2
    // __bitmap_hscale = vera_display_get_hscale()
    // [1781] __bitmap_hscale = bitmap_init::$1 -- vbuz1=vbuz2 
    lda.z __1
    sta.z __bitmap_hscale
    // vera_display_get_vscale()
    // [1782] call vera_display_get_vscale
    // [2013] phi from bitmap_init::@17 to vera_display_get_vscale [phi:bitmap_init::@17->vera_display_get_vscale]
    jsr vera_display_get_vscale
    // vera_display_get_vscale()
    // [1783] vera_display_get_vscale::return#2 = vera_display_get_vscale::return#0
    // bitmap_init::@18
    // [1784] bitmap_init::$2 = vera_display_get_vscale::return#2
    // __bitmap_vscale = vera_display_get_vscale()
    // [1785] __bitmap_vscale = bitmap_init::$2 -- vbuz1=vbuz2 
    // Returns 1 when 640 and 2 when 320.
    lda.z __2
    sta.z __bitmap_vscale
    // byte bitmask = bitmasks[__bitmap_color_depth]
    // [1786] bitmap_init::bitmask#0 = bitmasks[__bitmap_color_depth] -- vbuz1=pbuc1_derefidx_vbuz2 
    // Returns 1 when 480 and 2 when 240.
    ldy.z __bitmap_color_depth
    lda bitmasks,y
    sta.z bitmask
    // signed byte bitshift = bitshifts[__bitmap_color_depth]
    // [1787] bitmap_init::bitshift#0 = bitshifts[__bitmap_color_depth] -- vbsz1=pbsc1_derefidx_vbuz2 
    lda bitshifts,y
    sta.z bitshift
    // [1788] phi from bitmap_init::@18 to bitmap_init::@1 [phi:bitmap_init::@18->bitmap_init::@1]
    // [1788] phi bitmap_init::bitshift#10 = bitmap_init::bitshift#0 [phi:bitmap_init::@18->bitmap_init::@1#0] -- register_copy 
    // [1788] phi bitmap_init::bitmask#10 = bitmap_init::bitmask#0 [phi:bitmap_init::@18->bitmap_init::@1#1] -- register_copy 
    // [1788] phi bitmap_init::x#10 = 0 [phi:bitmap_init::@18->bitmap_init::@1#2] -- vwuz1=vwuc1 
    lda #<0
    sta.z x
    sta.z x+1
    // [1788] phi from bitmap_init::@7 to bitmap_init::@1 [phi:bitmap_init::@7->bitmap_init::@1]
    // [1788] phi bitmap_init::bitshift#10 = bitmap_init::bitshift#14 [phi:bitmap_init::@7->bitmap_init::@1#0] -- register_copy 
    // [1788] phi bitmap_init::bitmask#10 = bitmap_init::bitmask#16 [phi:bitmap_init::@7->bitmap_init::@1#1] -- register_copy 
    // [1788] phi bitmap_init::x#10 = bitmap_init::x#1 [phi:bitmap_init::@7->bitmap_init::@1#2] -- register_copy 
    // bitmap_init::@1
  __b1:
    // if(__bitmap_color_depth==0)
    // [1789] if(__bitmap_color_depth!=0) goto bitmap_init::@2 -- vbuz1_neq_0_then_la1 
    lda.z __bitmap_color_depth
    bne __b2
    // bitmap_init::@8
    // x >> 3
    // [1790] bitmap_init::$7 = bitmap_init::x#10 >> 3 -- vwuz1=vwuz2_ror_3 
    lda.z x+1
    lsr
    sta.z __7+1
    lda.z x
    ror
    sta.z __7
    lsr.z __7+1
    ror.z __7
    lsr.z __7+1
    ror.z __7
    // __bitmap_plot_x[x] = (x >> 3)
    // [1791] bitmap_init::$23 = bitmap_init::x#10 << 1 -- vwuz1=vwuz2_rol_1 
    lda.z x
    asl
    sta.z __23
    lda.z x+1
    rol
    sta.z __23+1
    // [1792] bitmap_init::$29 = __bitmap_plot_x + bitmap_init::$23 -- pwuz1=pwuc1_plus_vwuz1 
    lda.z __29
    clc
    adc #<__bitmap_plot_x
    sta.z __29
    lda.z __29+1
    adc #>__bitmap_plot_x
    sta.z __29+1
    // [1793] *bitmap_init::$29 = bitmap_init::$7 -- _deref_pwuz1=vwuz2 
    ldy #0
    lda.z __7
    sta (__29),y
    iny
    lda.z __7+1
    sta (__29),y
    // __bitmap_plot_bitmask[x] = bitmask
    // [1794] bitmap_init::$30 = __bitmap_plot_bitmask + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap_plot_bitmask
    sta.z __30
    lda.z x+1
    adc #>__bitmap_plot_bitmask
    sta.z __30+1
    // [1795] *bitmap_init::$30 = bitmap_init::bitmask#10 -- _deref_pbuz1=vbuz2 
    lda.z bitmask
    ldy #0
    sta (__30),y
    // __bitmap_plot_bitshift[x] = (byte)bitshift
    // [1796] bitmap_init::$31 = __bitmap_plot_bitshift + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap_plot_bitshift
    sta.z __31
    lda.z x+1
    adc #>__bitmap_plot_bitshift
    sta.z __31+1
    // [1797] *bitmap_init::$31 = (char)bitmap_init::bitshift#10 -- _deref_pbuz1=vbuz2 
    lda.z bitshift
    sta (__31),y
    // bitshift -= 1
    // [1798] bitmap_init::bitshift#1 = bitmap_init::bitshift#10 - 1 -- vbsz1=vbsz1_minus_1 
    dec.z bitshift
    // bitmask >>= 1
    // [1799] bitmap_init::bitmask#1 = bitmap_init::bitmask#10 >> 1 -- vbuz1=vbuz1_ror_1 
    lsr.z bitmask
    // [1800] phi from bitmap_init::@1 bitmap_init::@8 to bitmap_init::@2 [phi:bitmap_init::@1/bitmap_init::@8->bitmap_init::@2]
    // [1800] phi bitmap_init::bitshift#11 = bitmap_init::bitshift#10 [phi:bitmap_init::@1/bitmap_init::@8->bitmap_init::@2#0] -- register_copy 
    // [1800] phi bitmap_init::bitmask#11 = bitmap_init::bitmask#10 [phi:bitmap_init::@1/bitmap_init::@8->bitmap_init::@2#1] -- register_copy 
    // bitmap_init::@2
  __b2:
    // if(__bitmap_color_depth==1)
    // [1801] if(__bitmap_color_depth!=1) goto bitmap_init::@3 -- vbuz1_neq_vbuc1_then_la1 
    lda #1
    cmp.z __bitmap_color_depth
    bne __b3
    // bitmap_init::@9
    // x >> 2
    // [1802] bitmap_init::$10 = bitmap_init::x#10 >> 2 -- vwuz1=vwuz2_ror_2 
    lda.z x+1
    lsr
    sta.z __10+1
    lda.z x
    ror
    sta.z __10
    lsr.z __10+1
    ror.z __10
    // __bitmap_plot_x[x] = (x >> 2)
    // [1803] bitmap_init::$24 = bitmap_init::x#10 << 1 -- vwuz1=vwuz2_rol_1 
    lda.z x
    asl
    sta.z __24
    lda.z x+1
    rol
    sta.z __24+1
    // [1804] bitmap_init::$32 = __bitmap_plot_x + bitmap_init::$24 -- pwuz1=pwuc1_plus_vwuz1 
    lda.z __32
    clc
    adc #<__bitmap_plot_x
    sta.z __32
    lda.z __32+1
    adc #>__bitmap_plot_x
    sta.z __32+1
    // [1805] *bitmap_init::$32 = bitmap_init::$10 -- _deref_pwuz1=vwuz2 
    ldy #0
    lda.z __10
    sta (__32),y
    iny
    lda.z __10+1
    sta (__32),y
    // __bitmap_plot_bitmask[x] = bitmask
    // [1806] bitmap_init::$33 = __bitmap_plot_bitmask + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap_plot_bitmask
    sta.z __33
    lda.z x+1
    adc #>__bitmap_plot_bitmask
    sta.z __33+1
    // [1807] *bitmap_init::$33 = bitmap_init::bitmask#11 -- _deref_pbuz1=vbuz2 
    lda.z bitmask
    ldy #0
    sta (__33),y
    // __bitmap_plot_bitshift[x] = (byte)bitshift
    // [1808] bitmap_init::$34 = __bitmap_plot_bitshift + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap_plot_bitshift
    sta.z __34
    lda.z x+1
    adc #>__bitmap_plot_bitshift
    sta.z __34+1
    // [1809] *bitmap_init::$34 = (char)bitmap_init::bitshift#11 -- _deref_pbuz1=vbuz2 
    lda.z bitshift
    sta (__34),y
    // bitshift -= 2
    // [1810] bitmap_init::bitshift#2 = bitmap_init::bitshift#11 - 2 -- vbsz1=vbsz1_minus_2 
    dec.z bitshift
    dec.z bitshift
    // bitmask >>= 2
    // [1811] bitmap_init::bitmask#2 = bitmap_init::bitmask#11 >> 2 -- vbuz1=vbuz1_ror_2 
    lda.z bitmask
    lsr
    lsr
    sta.z bitmask
    // [1812] phi from bitmap_init::@2 bitmap_init::@9 to bitmap_init::@3 [phi:bitmap_init::@2/bitmap_init::@9->bitmap_init::@3]
    // [1812] phi bitmap_init::bitshift#12 = bitmap_init::bitshift#11 [phi:bitmap_init::@2/bitmap_init::@9->bitmap_init::@3#0] -- register_copy 
    // [1812] phi bitmap_init::bitmask#12 = bitmap_init::bitmask#11 [phi:bitmap_init::@2/bitmap_init::@9->bitmap_init::@3#1] -- register_copy 
    // bitmap_init::@3
  __b3:
    // if(__bitmap_color_depth==2)
    // [1813] if(__bitmap_color_depth!=2) goto bitmap_init::@4 -- vbuz1_neq_vbuc1_then_la1 
    lda #2
    cmp.z __bitmap_color_depth
    bne __b4
    // bitmap_init::@10
    // x >> 1
    // [1814] bitmap_init::$13 = bitmap_init::x#10 >> 1 -- vwuz1=vwuz2_ror_1 
    lda.z x+1
    lsr
    sta.z __13+1
    lda.z x
    ror
    sta.z __13
    // __bitmap_plot_x[x] = (x >> 1)
    // [1815] bitmap_init::$25 = bitmap_init::x#10 << 1 -- vwuz1=vwuz2_rol_1 
    lda.z x
    asl
    sta.z __25
    lda.z x+1
    rol
    sta.z __25+1
    // [1816] bitmap_init::$35 = __bitmap_plot_x + bitmap_init::$25 -- pwuz1=pwuc1_plus_vwuz1 
    lda.z __35
    clc
    adc #<__bitmap_plot_x
    sta.z __35
    lda.z __35+1
    adc #>__bitmap_plot_x
    sta.z __35+1
    // [1817] *bitmap_init::$35 = bitmap_init::$13 -- _deref_pwuz1=vwuz2 
    ldy #0
    lda.z __13
    sta (__35),y
    iny
    lda.z __13+1
    sta (__35),y
    // __bitmap_plot_bitmask[x] = bitmask
    // [1818] bitmap_init::$36 = __bitmap_plot_bitmask + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap_plot_bitmask
    sta.z __36
    lda.z x+1
    adc #>__bitmap_plot_bitmask
    sta.z __36+1
    // [1819] *bitmap_init::$36 = bitmap_init::bitmask#12 -- _deref_pbuz1=vbuz2 
    lda.z bitmask
    ldy #0
    sta (__36),y
    // __bitmap_plot_bitshift[x] = (byte)bitshift
    // [1820] bitmap_init::$37 = __bitmap_plot_bitshift + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap_plot_bitshift
    sta.z __37
    lda.z x+1
    adc #>__bitmap_plot_bitshift
    sta.z __37+1
    // [1821] *bitmap_init::$37 = (char)bitmap_init::bitshift#12 -- _deref_pbuz1=vbuz2 
    lda.z bitshift
    sta (__37),y
    // bitshift -= 4
    // [1822] bitmap_init::bitshift#3 = bitmap_init::bitshift#12 - 4 -- vbsz1=vbsz1_minus_vbsc1 
    sec
    sbc #4
    sta.z bitshift
    // bitmask >>= 4
    // [1823] bitmap_init::bitmask#3 = bitmap_init::bitmask#12 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z bitmask
    lsr
    lsr
    lsr
    lsr
    sta.z bitmask
    // [1824] phi from bitmap_init::@10 bitmap_init::@3 to bitmap_init::@4 [phi:bitmap_init::@10/bitmap_init::@3->bitmap_init::@4]
    // [1824] phi bitmap_init::bitmask#13 = bitmap_init::bitmask#3 [phi:bitmap_init::@10/bitmap_init::@3->bitmap_init::@4#0] -- register_copy 
    // [1824] phi bitmap_init::bitshift#13 = bitmap_init::bitshift#3 [phi:bitmap_init::@10/bitmap_init::@3->bitmap_init::@4#1] -- register_copy 
    // bitmap_init::@4
  __b4:
    // if(__bitmap_color_depth==3)
    // [1825] if(__bitmap_color_depth!=3) goto bitmap_init::@5 -- vbuz1_neq_vbuc1_then_la1 
    lda #3
    cmp.z __bitmap_color_depth
    bne __b5
    // bitmap_init::@11
    // __bitmap_plot_x[x] = x
    // [1826] bitmap_init::$26 = bitmap_init::x#10 << 1 -- vwuz1=vwuz2_rol_1 
    lda.z x
    asl
    sta.z __26
    lda.z x+1
    rol
    sta.z __26+1
    // [1827] bitmap_init::$38 = __bitmap_plot_x + bitmap_init::$26 -- pwuz1=pwuc1_plus_vwuz1 
    lda.z __38
    clc
    adc #<__bitmap_plot_x
    sta.z __38
    lda.z __38+1
    adc #>__bitmap_plot_x
    sta.z __38+1
    // [1828] *bitmap_init::$38 = bitmap_init::x#10 -- _deref_pwuz1=vwuz2 
    ldy #0
    lda.z x
    sta (__38),y
    iny
    lda.z x+1
    sta (__38),y
    // __bitmap_plot_bitmask[x] = bitmask
    // [1829] bitmap_init::$39 = __bitmap_plot_bitmask + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap_plot_bitmask
    sta.z __39
    lda.z x+1
    adc #>__bitmap_plot_bitmask
    sta.z __39+1
    // [1830] *bitmap_init::$39 = bitmap_init::bitmask#13 -- _deref_pbuz1=vbuz2 
    lda.z bitmask
    ldy #0
    sta (__39),y
    // __bitmap_plot_bitshift[x] = (byte)bitshift
    // [1831] bitmap_init::$40 = __bitmap_plot_bitshift + bitmap_init::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap_plot_bitshift
    sta.z __40
    lda.z x+1
    adc #>__bitmap_plot_bitshift
    sta.z __40+1
    // [1832] *bitmap_init::$40 = (char)bitmap_init::bitshift#13 -- _deref_pbuz1=vbuz2 
    lda.z bitshift
    sta (__40),y
    // bitmap_init::@5
  __b5:
    // if(bitshift<0)
    // [1833] if(bitmap_init::bitshift#13>=0) goto bitmap_init::@6 -- vbsz1_ge_0_then_la1 
    lda.z bitshift
    cmp #0
    bpl __b6
    // bitmap_init::@12
    // bitshift = bitshifts[__bitmap_color_depth]
    // [1834] bitmap_init::bitshift#4 = bitshifts[__bitmap_color_depth] -- vbsz1=pbsc1_derefidx_vbuz2 
    ldy.z __bitmap_color_depth
    lda bitshifts,y
    sta.z bitshift
    // [1835] phi from bitmap_init::@12 bitmap_init::@5 to bitmap_init::@6 [phi:bitmap_init::@12/bitmap_init::@5->bitmap_init::@6]
    // [1835] phi bitmap_init::bitshift#14 = bitmap_init::bitshift#4 [phi:bitmap_init::@12/bitmap_init::@5->bitmap_init::@6#0] -- register_copy 
    // bitmap_init::@6
  __b6:
    // if(bitmask==0)
    // [1836] if(bitmap_init::bitmask#13!=0) goto bitmap_init::@7 -- vbuz1_neq_0_then_la1 
    lda.z bitmask
    bne __b7
    // bitmap_init::@13
    // bitmask = bitmasks[__bitmap_color_depth]
    // [1837] bitmap_init::bitmask#4 = bitmasks[__bitmap_color_depth] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z __bitmap_color_depth
    lda bitmasks,y
    sta.z bitmask
    // [1838] phi from bitmap_init::@13 bitmap_init::@6 to bitmap_init::@7 [phi:bitmap_init::@13/bitmap_init::@6->bitmap_init::@7]
    // [1838] phi bitmap_init::bitmask#16 = bitmap_init::bitmask#4 [phi:bitmap_init::@13/bitmap_init::@6->bitmap_init::@7#0] -- register_copy 
    // bitmap_init::@7
  __b7:
    // for(word x : 0..639)
    // [1839] bitmap_init::x#1 = ++ bitmap_init::x#10 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // [1840] if(bitmap_init::x#1!=$280) goto bitmap_init::@1 -- vwuz1_neq_vwuc1_then_la1 
    lda.z x+1
    cmp #>$280
    beq !__b1+
    jmp __b1
  !__b1:
    lda.z x
    cmp #<$280
    beq !__b1+
    jmp __b1
  !__b1:
    // bitmap_init::@14
    // __bitmap_color_depth<<2
    // [1841] bitmap_init::$3 = __bitmap_color_depth << 2 -- vbuz1=vbuz2_rol_2 
    lda.z __bitmap_color_depth
    asl
    asl
    sta.z __3
    // (__bitmap_color_depth<<2)+__bitmap_hscale
    // [1842] bitmap_init::$4 = bitmap_init::$3 + __bitmap_hscale -- vbuz1=vbuz1_plus_vbuz2 
    lda.z __4
    clc
    adc.z __bitmap_hscale
    sta.z __4
    // word hdelta = hdeltas[(__bitmap_color_depth<<2)+__bitmap_hscale]
    // [1843] bitmap_init::$27 = bitmap_init::$4 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __27
    // [1844] bitmap_init::hdelta#0 = hdeltas[bitmap_init::$27] -- vwuz1=pwuc1_derefidx_vbuz2 
    // This sets the right delta to skip a whole line based on the scale, depending on the color depth.
    ldy.z __27
    lda hdeltas,y
    sta.z hdelta
    lda hdeltas+1,y
    sta.z hdelta+1
    // dword yoffs = __bitmap_address
    // [1845] bitmap_init::yoffs#0 = __bitmap_address -- vduz1=vduz2 
    // We start at the bitmap address; The plot_y contains the bitmap address embedded so we know where a line starts.
    lda.z __bitmap_address
    sta.z yoffs
    lda.z __bitmap_address+1
    sta.z yoffs+1
    lda.z __bitmap_address+2
    sta.z yoffs+2
    lda.z __bitmap_address+3
    sta.z yoffs+3
    // [1846] phi from bitmap_init::@14 to bitmap_init::@15 [phi:bitmap_init::@14->bitmap_init::@15]
    // [1846] phi bitmap_init::yoffs#2 = bitmap_init::yoffs#0 [phi:bitmap_init::@14->bitmap_init::@15#0] -- register_copy 
    // [1846] phi bitmap_init::y#2 = 0 [phi:bitmap_init::@14->bitmap_init::@15#1] -- vwuz1=vwuc1 
    lda #<0
    sta.z y
    sta.z y+1
    // [1846] phi from bitmap_init::@15 to bitmap_init::@15 [phi:bitmap_init::@15->bitmap_init::@15]
    // [1846] phi bitmap_init::yoffs#2 = bitmap_init::yoffs#1 [phi:bitmap_init::@15->bitmap_init::@15#0] -- register_copy 
    // [1846] phi bitmap_init::y#2 = bitmap_init::y#1 [phi:bitmap_init::@15->bitmap_init::@15#1] -- register_copy 
    // bitmap_init::@15
  __b15:
    // __bitmap_plot_y[y] = yoffs
    // [1847] bitmap_init::$28 = bitmap_init::y#2 << 2 -- vwuz1=vwuz2_rol_2 
    lda.z y
    asl
    sta.z __28
    lda.z y+1
    rol
    sta.z __28+1
    asl.z __28
    rol.z __28+1
    // [1848] bitmap_init::$41 = __bitmap_plot_y + bitmap_init::$28 -- pduz1=pduc1_plus_vwuz1 
    lda.z __41
    clc
    adc #<__bitmap_plot_y
    sta.z __41
    lda.z __41+1
    adc #>__bitmap_plot_y
    sta.z __41+1
    // [1849] *bitmap_init::$41 = bitmap_init::yoffs#2 -- _deref_pduz1=vduz2 
    ldy #0
    lda.z yoffs
    sta (__41),y
    iny
    lda.z yoffs+1
    sta (__41),y
    iny
    lda.z yoffs+2
    sta (__41),y
    iny
    lda.z yoffs+3
    sta (__41),y
    // yoffs = yoffs + hdelta
    // [1850] bitmap_init::yoffs#1 = bitmap_init::yoffs#2 + bitmap_init::hdelta#0 -- vduz1=vduz1_plus_vwuz2 
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
    // for(word y : 0..479)
    // [1851] bitmap_init::y#1 = ++ bitmap_init::y#2 -- vwuz1=_inc_vwuz1 
    inc.z y
    bne !+
    inc.z y+1
  !:
    // [1852] if(bitmap_init::y#1!=$1e0) goto bitmap_init::@15 -- vwuz1_neq_vwuc1_then_la1 
    lda.z y+1
    cmp #>$1e0
    bne __b15
    lda.z y
    cmp #<$1e0
    bne __b15
    // bitmap_init::@return
    // }
    // [1853] return 
    rts
}
  // bitmap_clear
// Clear all graphics on the bitmap
bitmap_clear: {
    .label __0 = $c4
    .label __1 = $c4
    .label __3 = $2c
    .label __7 = $db
    .label __8 = $c4
    .label vdelta = $4b
    .label hdelta = $5d
    .label count = $13
    .label vbank = $c1
    .label vdest = $32
    // word vdelta = vdeltas[__bitmap_vscale]
    // [1854] bitmap_clear::$7 = __bitmap_vscale << 1 -- vbuz1=vbuz2_rol_1 
    lda.z __bitmap_vscale
    asl
    sta.z __7
    // [1855] bitmap_clear::vdelta#0 = vdeltas[bitmap_clear::$7] -- vwuz1=pwuc1_derefidx_vbuz2 
    tay
    lda vdeltas,y
    sta.z vdelta
    lda vdeltas+1,y
    sta.z vdelta+1
    // __bitmap_color_depth<<2
    // [1856] bitmap_clear::$0 = __bitmap_color_depth << 2 -- vbuz1=vbuz2_rol_2 
    lda.z __bitmap_color_depth
    asl
    asl
    sta.z __0
    // (__bitmap_color_depth<<2)+__bitmap_hscale
    // [1857] bitmap_clear::$1 = bitmap_clear::$0 + __bitmap_hscale -- vbuz1=vbuz1_plus_vbuz2 
    lda.z __1
    clc
    adc.z __bitmap_hscale
    sta.z __1
    // word hdelta = hdeltas[(__bitmap_color_depth<<2)+__bitmap_hscale]
    // [1858] bitmap_clear::$8 = bitmap_clear::$1 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __8
    // [1859] bitmap_clear::hdelta#0 = hdeltas[bitmap_clear::$8] -- vwuz1=pwuc1_derefidx_vbuz2 
    ldy.z __8
    lda hdeltas,y
    sta.z hdelta
    lda hdeltas+1,y
    sta.z hdelta+1
    // hdelta = hdelta >> 1
    // [1860] bitmap_clear::hdelta#1 = bitmap_clear::hdelta#0 >> 1 -- vwuz1=vwuz1_ror_1 
    lsr.z hdelta+1
    ror.z hdelta
    // mul16u(hdelta,vdelta)
    // [1861] mul16u::a#0 = bitmap_clear::hdelta#1
    // [1862] mul16u::b#0 = bitmap_clear::vdelta#0
    // [1863] call mul16u
    jsr mul16u
    // [1864] mul16u::return#0 = mul16u::res#2
    // bitmap_clear::@1
    // [1865] bitmap_clear::$3 = mul16u::return#0
    // word count = (word)mul16u(hdelta,vdelta)
    // [1866] bitmap_clear::count#0 = (unsigned int)bitmap_clear::$3 -- vwuz1=_word_vduz2 
    lda.z __3
    sta.z count
    lda.z __3+1
    sta.z count+1
    // cx16_bank vbank = BYTE2(__bitmap_address)
    // [1867] bitmap_clear::vbank#0 = byte2  __bitmap_address -- vbuz1=_byte2_vduz2 
    lda.z __bitmap_address+2
    sta.z vbank
    // cx16_vram_offset vdest = WORD0(__bitmap_address)
    // [1868] bitmap_clear::vdest#0 = word0  __bitmap_address -- vwuz1=_word0_vduz2 
    lda.z __bitmap_address
    sta.z vdest
    lda.z __bitmap_address+1
    sta.z vdest+1
    // cx16_set_vram(vbank, vdest, 0, count)
    // [1869] cx16_set_vram::dbank_vram#0 = bitmap_clear::vbank#0
    // [1870] cx16_set_vram::doffset_vram#0 = bitmap_clear::vdest#0
    // [1871] cx16_set_vram::num#0 = bitmap_clear::count#0
    // [1872] call cx16_set_vram
    // [2030] phi from bitmap_clear::@1 to cx16_set_vram [phi:bitmap_clear::@1->cx16_set_vram]
    jsr cx16_set_vram
    // bitmap_clear::@return
    // }
    // [1873] return 
    rts
}
  // bitmap_line
// Draw a line on the bitmap
// void bitmap_line(__zp($40) unsigned int x0, __zp(6) unsigned int x1, __zp($5d) unsigned int y0, __zp($3e) unsigned int y1, __zp($57) char c)
bitmap_line: {
    .label xd = $55
    .label yd = $4f
    .label yd_1 = $49
    .label x0 = $40
    .label x1 = 6
    .label y0 = $5d
    .label y1 = $3e
    .label c = $57
    // if(x0<x1)
    // [1875] if(bitmap_line::x0#12<bitmap_line::x1#12) goto bitmap_line::@1 -- vwuz1_lt_vwuz2_then_la1 
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
    // [1876] bitmap_line::xd#2 = bitmap_line::x0#12 - bitmap_line::x1#12 -- vwuz1=vwuz2_minus_vwuz3 
    lda.z x0
    sec
    sbc.z x1
    sta.z xd
    lda.z x0+1
    sbc.z x1+1
    sta.z xd+1
    // if(y0<y1)
    // [1877] if(bitmap_line::y0#12<bitmap_line::y1#12) goto bitmap_line::@7 -- vwuz1_lt_vwuz2_then_la1 
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
    // [1878] bitmap_line::yd#2 = bitmap_line::y0#12 - bitmap_line::y1#12 -- vwuz1=vwuz2_minus_vwuz3 
    lda.z y0
    sec
    sbc.z y1
    sta.z yd_1
    lda.z y0+1
    sbc.z y1+1
    sta.z yd_1+1
    // if(yd<xd)
    // [1879] if(bitmap_line::yd#2<bitmap_line::xd#2) goto bitmap_line::@8 -- vwuz1_lt_vwuz2_then_la1 
    cmp.z xd+1
    bcc __b8
    bne !+
    lda.z yd_1
    cmp.z xd
    bcc __b8
  !:
    // bitmap_line::@4
    // bitmap_line_ydxi(y1, x1, y0, yd, xd, c)
    // [1880] bitmap_line_ydxi::y#0 = bitmap_line::y1#12 -- vwuz1=vwuz2 
    lda.z y1
    sta.z bitmap_line_ydxi.y
    lda.z y1+1
    sta.z bitmap_line_ydxi.y+1
    // [1881] bitmap_line_ydxi::x#0 = bitmap_line::x1#12 -- vwuz1=vwuz2 
    lda.z x1
    sta.z bitmap_line_ydxi.x
    lda.z x1+1
    sta.z bitmap_line_ydxi.x+1
    // [1882] bitmap_line_ydxi::y1#0 = bitmap_line::y0#12
    // [1883] bitmap_line_ydxi::yd#0 = bitmap_line::yd#2
    // [1884] bitmap_line_ydxi::xd#0 = bitmap_line::xd#2
    // [1885] bitmap_line_ydxi::c#0 = bitmap_line::c#12
    // [1886] call bitmap_line_ydxi
    // [2044] phi from bitmap_line::@4 to bitmap_line_ydxi [phi:bitmap_line::@4->bitmap_line_ydxi]
    // [2044] phi bitmap_line_ydxi::y1#6 = bitmap_line_ydxi::y1#0 [phi:bitmap_line::@4->bitmap_line_ydxi#0] -- register_copy 
    // [2044] phi bitmap_line_ydxi::yd#5 = bitmap_line_ydxi::yd#0 [phi:bitmap_line::@4->bitmap_line_ydxi#1] -- register_copy 
    // [2044] phi bitmap_line_ydxi::c#3 = bitmap_line_ydxi::c#0 [phi:bitmap_line::@4->bitmap_line_ydxi#2] -- register_copy 
    // [2044] phi bitmap_line_ydxi::y#6 = bitmap_line_ydxi::y#0 [phi:bitmap_line::@4->bitmap_line_ydxi#3] -- register_copy 
    // [2044] phi bitmap_line_ydxi::x#5 = bitmap_line_ydxi::x#0 [phi:bitmap_line::@4->bitmap_line_ydxi#4] -- register_copy 
    // [2044] phi bitmap_line_ydxi::xd#2 = bitmap_line_ydxi::xd#0 [phi:bitmap_line::@4->bitmap_line_ydxi#5] -- register_copy 
    jsr bitmap_line_ydxi
    // bitmap_line::@return
    // }
    // [1887] return 
    rts
    // bitmap_line::@8
  __b8:
    // bitmap_line_xdyi(x1, y1, x0, xd, yd, c)
    // [1888] bitmap_line_xdyi::x#0 = bitmap_line::x1#12 -- vwuz1=vwuz2 
    lda.z x1
    sta.z bitmap_line_xdyi.x
    lda.z x1+1
    sta.z bitmap_line_xdyi.x+1
    // [1889] bitmap_line_xdyi::y#0 = bitmap_line::y1#12
    // [1890] bitmap_line_xdyi::x1#0 = bitmap_line::x0#12 -- vwuz1=vwuz2 
    lda.z x0
    sta.z bitmap_line_xdyi.x1
    lda.z x0+1
    sta.z bitmap_line_xdyi.x1+1
    // [1891] bitmap_line_xdyi::xd#0 = bitmap_line::xd#2 -- vwuz1=vwuz2 
    lda.z xd
    sta.z bitmap_line_xdyi.xd
    lda.z xd+1
    sta.z bitmap_line_xdyi.xd+1
    // [1892] bitmap_line_xdyi::yd#0 = bitmap_line::yd#2 -- vwuz1=vwuz2 
    lda.z yd_1
    sta.z bitmap_line_xdyi.yd
    lda.z yd_1+1
    sta.z bitmap_line_xdyi.yd+1
    // [1893] bitmap_line_xdyi::c#0 = bitmap_line::c#12 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_line_xdyi.c
    // [1894] call bitmap_line_xdyi
    // [2060] phi from bitmap_line::@8 to bitmap_line_xdyi [phi:bitmap_line::@8->bitmap_line_xdyi]
    // [2060] phi bitmap_line_xdyi::x1#6 = bitmap_line_xdyi::x1#0 [phi:bitmap_line::@8->bitmap_line_xdyi#0] -- register_copy 
    // [2060] phi bitmap_line_xdyi::xd#5 = bitmap_line_xdyi::xd#0 [phi:bitmap_line::@8->bitmap_line_xdyi#1] -- register_copy 
    // [2060] phi bitmap_line_xdyi::c#3 = bitmap_line_xdyi::c#0 [phi:bitmap_line::@8->bitmap_line_xdyi#2] -- register_copy 
    // [2060] phi bitmap_line_xdyi::y#5 = bitmap_line_xdyi::y#0 [phi:bitmap_line::@8->bitmap_line_xdyi#3] -- register_copy 
    // [2060] phi bitmap_line_xdyi::x#6 = bitmap_line_xdyi::x#0 [phi:bitmap_line::@8->bitmap_line_xdyi#4] -- register_copy 
    // [2060] phi bitmap_line_xdyi::yd#2 = bitmap_line_xdyi::yd#0 [phi:bitmap_line::@8->bitmap_line_xdyi#5] -- register_copy 
    jsr bitmap_line_xdyi
    rts
    // bitmap_line::@7
  __b7:
    // yd = y1-y0
    // [1895] bitmap_line::yd#1 = bitmap_line::y1#12 - bitmap_line::y0#12 -- vwuz1=vwuz2_minus_vwuz3 
    lda.z y1
    sec
    sbc.z y0
    sta.z yd
    lda.z y1+1
    sbc.z y0+1
    sta.z yd+1
    // if(yd<xd)
    // [1896] if(bitmap_line::yd#1<bitmap_line::xd#2) goto bitmap_line::@9 -- vwuz1_lt_vwuz2_then_la1 
    cmp.z xd+1
    bcc __b9
    bne !+
    lda.z yd
    cmp.z xd
    bcc __b9
  !:
    // bitmap_line::@10
    // bitmap_line_ydxd(y0, x0, y1, yd, xd, c)
    // [1897] bitmap_line_ydxd::y#0 = bitmap_line::y0#12 -- vwuz1=vwuz2 
    lda.z y0
    sta.z bitmap_line_ydxd.y
    lda.z y0+1
    sta.z bitmap_line_ydxd.y+1
    // [1898] bitmap_line_ydxd::x#0 = bitmap_line::x0#12 -- vwuz1=vwuz2 
    lda.z x0
    sta.z bitmap_line_ydxd.x
    lda.z x0+1
    sta.z bitmap_line_ydxd.x+1
    // [1899] bitmap_line_ydxd::y1#0 = bitmap_line::y1#12 -- vwuz1=vwuz2 
    lda.z y1
    sta.z bitmap_line_ydxd.y1
    lda.z y1+1
    sta.z bitmap_line_ydxd.y1+1
    // [1900] bitmap_line_ydxd::yd#0 = bitmap_line::yd#1
    // [1901] bitmap_line_ydxd::xd#0 = bitmap_line::xd#2 -- vwuz1=vwuz2 
    lda.z xd
    sta.z bitmap_line_ydxd.xd
    lda.z xd+1
    sta.z bitmap_line_ydxd.xd+1
    // [1902] bitmap_line_ydxd::c#0 = bitmap_line::c#12 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_line_ydxd.c
    // [1903] call bitmap_line_ydxd
    // [2076] phi from bitmap_line::@10 to bitmap_line_ydxd [phi:bitmap_line::@10->bitmap_line_ydxd]
    // [2076] phi bitmap_line_ydxd::y1#6 = bitmap_line_ydxd::y1#0 [phi:bitmap_line::@10->bitmap_line_ydxd#0] -- register_copy 
    // [2076] phi bitmap_line_ydxd::yd#5 = bitmap_line_ydxd::yd#0 [phi:bitmap_line::@10->bitmap_line_ydxd#1] -- register_copy 
    // [2076] phi bitmap_line_ydxd::c#3 = bitmap_line_ydxd::c#0 [phi:bitmap_line::@10->bitmap_line_ydxd#2] -- register_copy 
    // [2076] phi bitmap_line_ydxd::y#7 = bitmap_line_ydxd::y#0 [phi:bitmap_line::@10->bitmap_line_ydxd#3] -- register_copy 
    // [2076] phi bitmap_line_ydxd::x#5 = bitmap_line_ydxd::x#0 [phi:bitmap_line::@10->bitmap_line_ydxd#4] -- register_copy 
    // [2076] phi bitmap_line_ydxd::xd#2 = bitmap_line_ydxd::xd#0 [phi:bitmap_line::@10->bitmap_line_ydxd#5] -- register_copy 
    jsr bitmap_line_ydxd
    rts
    // bitmap_line::@9
  __b9:
    // bitmap_line_xdyd(x1, y1, x0, xd, yd, c)
    // [1904] bitmap_line_xdyd::x#0 = bitmap_line::x1#12 -- vwuz1=vwuz2 
    lda.z x1
    sta.z bitmap_line_xdyd.x
    lda.z x1+1
    sta.z bitmap_line_xdyd.x+1
    // [1905] bitmap_line_xdyd::y#0 = bitmap_line::y1#12 -- vwuz1=vwuz2 
    lda.z y1
    sta.z bitmap_line_xdyd.y
    lda.z y1+1
    sta.z bitmap_line_xdyd.y+1
    // [1906] bitmap_line_xdyd::x1#0 = bitmap_line::x0#12 -- vwuz1=vwuz2 
    lda.z x0
    sta.z bitmap_line_xdyd.x1
    lda.z x0+1
    sta.z bitmap_line_xdyd.x1+1
    // [1907] bitmap_line_xdyd::xd#0 = bitmap_line::xd#2 -- vwuz1=vwuz2 
    lda.z xd
    sta.z bitmap_line_xdyd.xd
    lda.z xd+1
    sta.z bitmap_line_xdyd.xd+1
    // [1908] bitmap_line_xdyd::yd#0 = bitmap_line::yd#1 -- vwuz1=vwuz2 
    lda.z yd
    sta.z bitmap_line_xdyd.yd
    lda.z yd+1
    sta.z bitmap_line_xdyd.yd+1
    // [1909] bitmap_line_xdyd::c#0 = bitmap_line::c#12 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_line_xdyd.c
    // [1910] call bitmap_line_xdyd
    // [2092] phi from bitmap_line::@9 to bitmap_line_xdyd [phi:bitmap_line::@9->bitmap_line_xdyd]
    // [2092] phi bitmap_line_xdyd::x1#6 = bitmap_line_xdyd::x1#0 [phi:bitmap_line::@9->bitmap_line_xdyd#0] -- register_copy 
    // [2092] phi bitmap_line_xdyd::xd#5 = bitmap_line_xdyd::xd#0 [phi:bitmap_line::@9->bitmap_line_xdyd#1] -- register_copy 
    // [2092] phi bitmap_line_xdyd::c#3 = bitmap_line_xdyd::c#0 [phi:bitmap_line::@9->bitmap_line_xdyd#2] -- register_copy 
    // [2092] phi bitmap_line_xdyd::y#5 = bitmap_line_xdyd::y#0 [phi:bitmap_line::@9->bitmap_line_xdyd#3] -- register_copy 
    // [2092] phi bitmap_line_xdyd::x#6 = bitmap_line_xdyd::x#0 [phi:bitmap_line::@9->bitmap_line_xdyd#4] -- register_copy 
    // [2092] phi bitmap_line_xdyd::yd#2 = bitmap_line_xdyd::yd#0 [phi:bitmap_line::@9->bitmap_line_xdyd#5] -- register_copy 
    jsr bitmap_line_xdyd
    rts
    // bitmap_line::@1
  __b1:
    // xd = x1-x0
    // [1911] bitmap_line::xd#1 = bitmap_line::x1#12 - bitmap_line::x0#12 -- vwuz1=vwuz2_minus_vwuz3 
    lda.z x1
    sec
    sbc.z x0
    sta.z xd
    lda.z x1+1
    sbc.z x0+1
    sta.z xd+1
    // if(y0<y1)
    // [1912] if(bitmap_line::y0#12<bitmap_line::y1#12) goto bitmap_line::@11 -- vwuz1_lt_vwuz2_then_la1 
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
    // [1913] bitmap_line::yd#10 = bitmap_line::y0#12 - bitmap_line::y1#12 -- vwuz1=vwuz2_minus_vwuz3 
    lda.z y0
    sec
    sbc.z y1
    sta.z yd
    lda.z y0+1
    sbc.z y1+1
    sta.z yd+1
    // if(yd<xd)
    // [1914] if(bitmap_line::yd#10<bitmap_line::xd#1) goto bitmap_line::@12 -- vwuz1_lt_vwuz2_then_la1 
    cmp.z xd+1
    bcc __b12
    bne !+
    lda.z yd
    cmp.z xd
    bcc __b12
  !:
    // bitmap_line::@6
    // bitmap_line_ydxd(y1, x1, y0, yd, xd, c)
    // [1915] bitmap_line_ydxd::y#1 = bitmap_line::y1#12 -- vwuz1=vwuz2 
    lda.z y1
    sta.z bitmap_line_ydxd.y
    lda.z y1+1
    sta.z bitmap_line_ydxd.y+1
    // [1916] bitmap_line_ydxd::x#1 = bitmap_line::x1#12 -- vwuz1=vwuz2 
    lda.z x1
    sta.z bitmap_line_ydxd.x
    lda.z x1+1
    sta.z bitmap_line_ydxd.x+1
    // [1917] bitmap_line_ydxd::y1#1 = bitmap_line::y0#12 -- vwuz1=vwuz2 
    lda.z y0
    sta.z bitmap_line_ydxd.y1
    lda.z y0+1
    sta.z bitmap_line_ydxd.y1+1
    // [1918] bitmap_line_ydxd::yd#1 = bitmap_line::yd#10
    // [1919] bitmap_line_ydxd::xd#1 = bitmap_line::xd#1 -- vwuz1=vwuz2 
    lda.z xd
    sta.z bitmap_line_ydxd.xd
    lda.z xd+1
    sta.z bitmap_line_ydxd.xd+1
    // [1920] bitmap_line_ydxd::c#1 = bitmap_line::c#12 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_line_ydxd.c
    // [1921] call bitmap_line_ydxd
    // [2076] phi from bitmap_line::@6 to bitmap_line_ydxd [phi:bitmap_line::@6->bitmap_line_ydxd]
    // [2076] phi bitmap_line_ydxd::y1#6 = bitmap_line_ydxd::y1#1 [phi:bitmap_line::@6->bitmap_line_ydxd#0] -- register_copy 
    // [2076] phi bitmap_line_ydxd::yd#5 = bitmap_line_ydxd::yd#1 [phi:bitmap_line::@6->bitmap_line_ydxd#1] -- register_copy 
    // [2076] phi bitmap_line_ydxd::c#3 = bitmap_line_ydxd::c#1 [phi:bitmap_line::@6->bitmap_line_ydxd#2] -- register_copy 
    // [2076] phi bitmap_line_ydxd::y#7 = bitmap_line_ydxd::y#1 [phi:bitmap_line::@6->bitmap_line_ydxd#3] -- register_copy 
    // [2076] phi bitmap_line_ydxd::x#5 = bitmap_line_ydxd::x#1 [phi:bitmap_line::@6->bitmap_line_ydxd#4] -- register_copy 
    // [2076] phi bitmap_line_ydxd::xd#2 = bitmap_line_ydxd::xd#1 [phi:bitmap_line::@6->bitmap_line_ydxd#5] -- register_copy 
    jsr bitmap_line_ydxd
    rts
    // bitmap_line::@12
  __b12:
    // bitmap_line_xdyd(x0, y0, x1, xd, yd, c)
    // [1922] bitmap_line_xdyd::x#1 = bitmap_line::x0#12 -- vwuz1=vwuz2 
    lda.z x0
    sta.z bitmap_line_xdyd.x
    lda.z x0+1
    sta.z bitmap_line_xdyd.x+1
    // [1923] bitmap_line_xdyd::y#1 = bitmap_line::y0#12 -- vwuz1=vwuz2 
    lda.z y0
    sta.z bitmap_line_xdyd.y
    lda.z y0+1
    sta.z bitmap_line_xdyd.y+1
    // [1924] bitmap_line_xdyd::x1#1 = bitmap_line::x1#12 -- vwuz1=vwuz2 
    lda.z x1
    sta.z bitmap_line_xdyd.x1
    lda.z x1+1
    sta.z bitmap_line_xdyd.x1+1
    // [1925] bitmap_line_xdyd::xd#1 = bitmap_line::xd#1 -- vwuz1=vwuz2 
    lda.z xd
    sta.z bitmap_line_xdyd.xd
    lda.z xd+1
    sta.z bitmap_line_xdyd.xd+1
    // [1926] bitmap_line_xdyd::yd#1 = bitmap_line::yd#10 -- vwuz1=vwuz2 
    lda.z yd
    sta.z bitmap_line_xdyd.yd
    lda.z yd+1
    sta.z bitmap_line_xdyd.yd+1
    // [1927] bitmap_line_xdyd::c#1 = bitmap_line::c#12 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_line_xdyd.c
    // [1928] call bitmap_line_xdyd
    // [2092] phi from bitmap_line::@12 to bitmap_line_xdyd [phi:bitmap_line::@12->bitmap_line_xdyd]
    // [2092] phi bitmap_line_xdyd::x1#6 = bitmap_line_xdyd::x1#1 [phi:bitmap_line::@12->bitmap_line_xdyd#0] -- register_copy 
    // [2092] phi bitmap_line_xdyd::xd#5 = bitmap_line_xdyd::xd#1 [phi:bitmap_line::@12->bitmap_line_xdyd#1] -- register_copy 
    // [2092] phi bitmap_line_xdyd::c#3 = bitmap_line_xdyd::c#1 [phi:bitmap_line::@12->bitmap_line_xdyd#2] -- register_copy 
    // [2092] phi bitmap_line_xdyd::y#5 = bitmap_line_xdyd::y#1 [phi:bitmap_line::@12->bitmap_line_xdyd#3] -- register_copy 
    // [2092] phi bitmap_line_xdyd::x#6 = bitmap_line_xdyd::x#1 [phi:bitmap_line::@12->bitmap_line_xdyd#4] -- register_copy 
    // [2092] phi bitmap_line_xdyd::yd#2 = bitmap_line_xdyd::yd#1 [phi:bitmap_line::@12->bitmap_line_xdyd#5] -- register_copy 
    jsr bitmap_line_xdyd
    rts
    // bitmap_line::@11
  __b11:
    // yd = y1-y0
    // [1929] bitmap_line::yd#11 = bitmap_line::y1#12 - bitmap_line::y0#12 -- vwuz1=vwuz2_minus_vwuz3 
    lda.z y1
    sec
    sbc.z y0
    sta.z yd_1
    lda.z y1+1
    sbc.z y0+1
    sta.z yd_1+1
    // if(yd<xd)
    // [1930] if(bitmap_line::yd#11<bitmap_line::xd#1) goto bitmap_line::@13 -- vwuz1_lt_vwuz2_then_la1 
    cmp.z xd+1
    bcc __b13
    bne !+
    lda.z yd_1
    cmp.z xd
    bcc __b13
  !:
    // bitmap_line::@14
    // bitmap_line_ydxi(y0, x0, y1, yd, xd, c)
    // [1931] bitmap_line_ydxi::y#1 = bitmap_line::y0#12 -- vwuz1=vwuz2 
    lda.z y0
    sta.z bitmap_line_ydxi.y
    lda.z y0+1
    sta.z bitmap_line_ydxi.y+1
    // [1932] bitmap_line_ydxi::x#1 = bitmap_line::x0#12
    // [1933] bitmap_line_ydxi::y1#1 = bitmap_line::y1#12 -- vwuz1=vwuz2 
    lda.z y1
    sta.z bitmap_line_ydxi.y1
    lda.z y1+1
    sta.z bitmap_line_ydxi.y1+1
    // [1934] bitmap_line_ydxi::yd#1 = bitmap_line::yd#11
    // [1935] bitmap_line_ydxi::xd#1 = bitmap_line::xd#1
    // [1936] bitmap_line_ydxi::c#1 = bitmap_line::c#12
    // [1937] call bitmap_line_ydxi
    // [2044] phi from bitmap_line::@14 to bitmap_line_ydxi [phi:bitmap_line::@14->bitmap_line_ydxi]
    // [2044] phi bitmap_line_ydxi::y1#6 = bitmap_line_ydxi::y1#1 [phi:bitmap_line::@14->bitmap_line_ydxi#0] -- register_copy 
    // [2044] phi bitmap_line_ydxi::yd#5 = bitmap_line_ydxi::yd#1 [phi:bitmap_line::@14->bitmap_line_ydxi#1] -- register_copy 
    // [2044] phi bitmap_line_ydxi::c#3 = bitmap_line_ydxi::c#1 [phi:bitmap_line::@14->bitmap_line_ydxi#2] -- register_copy 
    // [2044] phi bitmap_line_ydxi::y#6 = bitmap_line_ydxi::y#1 [phi:bitmap_line::@14->bitmap_line_ydxi#3] -- register_copy 
    // [2044] phi bitmap_line_ydxi::x#5 = bitmap_line_ydxi::x#1 [phi:bitmap_line::@14->bitmap_line_ydxi#4] -- register_copy 
    // [2044] phi bitmap_line_ydxi::xd#2 = bitmap_line_ydxi::xd#1 [phi:bitmap_line::@14->bitmap_line_ydxi#5] -- register_copy 
    jsr bitmap_line_ydxi
    rts
    // bitmap_line::@13
  __b13:
    // bitmap_line_xdyi(x0, y0, x1, xd, yd, c)
    // [1938] bitmap_line_xdyi::x#1 = bitmap_line::x0#12 -- vwuz1=vwuz2 
    lda.z x0
    sta.z bitmap_line_xdyi.x
    lda.z x0+1
    sta.z bitmap_line_xdyi.x+1
    // [1939] bitmap_line_xdyi::y#1 = bitmap_line::y0#12 -- vwuz1=vwuz2 
    lda.z y0
    sta.z bitmap_line_xdyi.y
    lda.z y0+1
    sta.z bitmap_line_xdyi.y+1
    // [1940] bitmap_line_xdyi::x1#1 = bitmap_line::x1#12
    // [1941] bitmap_line_xdyi::xd#1 = bitmap_line::xd#1 -- vwuz1=vwuz2 
    lda.z xd
    sta.z bitmap_line_xdyi.xd
    lda.z xd+1
    sta.z bitmap_line_xdyi.xd+1
    // [1942] bitmap_line_xdyi::yd#1 = bitmap_line::yd#11 -- vwuz1=vwuz2 
    lda.z yd_1
    sta.z bitmap_line_xdyi.yd
    lda.z yd_1+1
    sta.z bitmap_line_xdyi.yd+1
    // [1943] bitmap_line_xdyi::c#1 = bitmap_line::c#12 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_line_xdyi.c
    // [1944] call bitmap_line_xdyi
    // [2060] phi from bitmap_line::@13 to bitmap_line_xdyi [phi:bitmap_line::@13->bitmap_line_xdyi]
    // [2060] phi bitmap_line_xdyi::x1#6 = bitmap_line_xdyi::x1#1 [phi:bitmap_line::@13->bitmap_line_xdyi#0] -- register_copy 
    // [2060] phi bitmap_line_xdyi::xd#5 = bitmap_line_xdyi::xd#1 [phi:bitmap_line::@13->bitmap_line_xdyi#1] -- register_copy 
    // [2060] phi bitmap_line_xdyi::c#3 = bitmap_line_xdyi::c#1 [phi:bitmap_line::@13->bitmap_line_xdyi#2] -- register_copy 
    // [2060] phi bitmap_line_xdyi::y#5 = bitmap_line_xdyi::y#1 [phi:bitmap_line::@13->bitmap_line_xdyi#3] -- register_copy 
    // [2060] phi bitmap_line_xdyi::x#6 = bitmap_line_xdyi::x#1 [phi:bitmap_line::@13->bitmap_line_xdyi#4] -- register_copy 
    // [2060] phi bitmap_line_xdyi::yd#2 = bitmap_line_xdyi::yd#1 [phi:bitmap_line::@13->bitmap_line_xdyi#5] -- register_copy 
    jsr bitmap_line_xdyi
    rts
}
  // rand
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
rand: {
    .label __0 = $5f
    .label __1 = $4f
    .label __2 = $58
    .label return = $53
    // rand_state << 7
    // [1946] rand::$0 = rand_state#50 << 7 -- vwuz1=vwuz2_rol_7 
    lda.z rand_state_1+1
    lsr
    lda.z rand_state_1
    ror
    sta.z __0+1
    lda #0
    ror
    sta.z __0
    // rand_state ^= rand_state << 7
    // [1947] rand_state#0 = rand_state#50 ^ rand::$0 -- vwuz1=vwuz2_bxor_vwuz3 
    lda.z rand_state_1
    eor.z __0
    sta.z rand_state
    lda.z rand_state_1+1
    eor.z __0+1
    sta.z rand_state+1
    // rand_state >> 9
    // [1948] rand::$1 = rand_state#0 >> 9 -- vwuz1=vwuz2_ror_9 
    lsr
    sta.z __1
    lda #0
    sta.z __1+1
    // rand_state ^= rand_state >> 9
    // [1949] rand_state#1 = rand_state#0 ^ rand::$1 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __1
    sta.z rand_state
    lda.z rand_state+1
    eor.z __1+1
    sta.z rand_state+1
    // rand_state << 8
    // [1950] rand::$2 = rand_state#1 << 8 -- vwuz1=vwuz2_rol_8 
    lda.z rand_state
    sta.z __2+1
    lda #0
    sta.z __2
    // rand_state ^= rand_state << 8
    // [1951] rand_state#2 = rand_state#1 ^ rand::$2 -- vwuz1=vwuz2_bxor_vwuz3 
    lda.z rand_state
    eor.z __2
    sta.z rand_state_1
    lda.z rand_state+1
    eor.z __2+1
    sta.z rand_state_1+1
    // return rand_state;
    // [1952] rand::return#0 = rand_state#2 -- vwuz1=vwuz2 
    lda.z rand_state_1
    sta.z return
    lda.z rand_state_1+1
    sta.z return+1
    // rand::@return
    // }
    // [1953] return 
    rts
}
  // modr16u
// Performs modulo on two 16 bit unsigned ints and an initial remainder
// Returns the remainder.
// Implemented using simple binary division
// __zp($3e) unsigned int modr16u(__zp($53) unsigned int dividend, __zp($55) unsigned int divisor, unsigned int rem)
modr16u: {
    .label return = $3e
    .label dividend = $53
    .label return_1 = $40
    .label return_2 = 6
    .label return_3 = $5d
    .label divisor = $55
    // divr16u(dividend, divisor, rem)
    // [1955] divr16u::dividend#1 = modr16u::dividend#24
    // [1956] divr16u::divisor#0 = modr16u::divisor#24
    // [1957] call divr16u
    // [2108] phi from modr16u to divr16u [phi:modr16u->divr16u]
    jsr divr16u
    // modr16u::@1
    // return rem16u;
    // [1958] modr16u::return#0 = divr16u::rem#10 -- vwuz1=vwuz2 
    lda.z divr16u.rem
    sta.z return
    lda.z divr16u.rem+1
    sta.z return+1
    // modr16u::@return
    // }
    // [1959] return 
    rts
}
  // vera_layer_set_config
/**
 * @brief Set the configuration of the layer.
 *
 * @param layer The layer of the vera 0/1.
 * @param config Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
 */
// void vera_layer_set_config(__zp($44) char layer, __zp($b0) char config)
vera_layer_set_config: {
    .label __0 = $44
    .label addr = $3a
    .label layer = $44
    .label config = $b0
    // char* addr = vera_layer_config[layer]
    // [1961] vera_layer_set_config::$0 = vera_layer_set_config::layer#2 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __0
    // [1962] vera_layer_set_config::addr#0 = vera_layer_config[vera_layer_set_config::$0] -- pbuz1=qbuc1_derefidx_vbuz2 
    ldy.z __0
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr = config
    // [1963] *vera_layer_set_config::addr#0 = vera_layer_set_config::config#2 -- _deref_pbuz1=vbuz2 
    lda.z config
    ldy #0
    sta (addr),y
    // vera_layer_set_config::@return
    // }
    // [1964] return 
    rts
}
  // vera_layer_set_tilebase
/**
 * @brief Set the base of the tiles for the layer with which the conio will interact.
 *
 * @param layer The layer of the vera 0/1.
 * @param tilebase Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:11 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
 */
// void vera_layer_set_tilebase(__zp($77) char layer, __zp($b1) char tilebase)
vera_layer_set_tilebase: {
    .label __0 = $77
    .label addr = $3a
    .label layer = $77
    .label tilebase = $b1
    // char* addr = vera_layer_tilebase[layer]
    // [1966] vera_layer_set_tilebase::$0 = vera_layer_set_tilebase::layer#2 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __0
    // [1967] vera_layer_set_tilebase::addr#0 = vera_layer_tilebase[vera_layer_set_tilebase::$0] -- pbuz1=qbuc1_derefidx_vbuz2 
    ldy.z __0
    lda vera_layer_tilebase,y
    sta.z addr
    lda vera_layer_tilebase+1,y
    sta.z addr+1
    // *addr = tilebase
    // [1968] *vera_layer_set_tilebase::addr#0 = vera_layer_set_tilebase::tilebase#2 -- _deref_pbuz1=vbuz2 
    lda.z tilebase
    ldy #0
    sta (addr),y
    // vera_layer_set_tilebase::@return
    // }
    // [1969] return 
    rts
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label __3 = $12
    .label cy = $19
    .label width = $18
    .label line = $c
    .label start = $c
    .label i = $10
    // unsigned char cy = conio_cursor_y[cx16_conio.conio_screen_layer]
    // [1970] insertup::cy#0 = conio_cursor_y[*((char *)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy cx16_conio
    lda conio_cursor_y,y
    sta.z cy
    // unsigned char width = cx16_conio.conio_screen_width * 2
    // [1971] insertup::width#0 = *((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    asl
    sta.z width
    // [1972] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [1972] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z i
    // insertup::@1
  __b1:
    // for(unsigned char i=1; i<=cy; i++)
    // [1973] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuz1_le_vbuz2_then_la1 
    lda.z cy
    cmp.z i
    bcs __b2
    // [1974] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [1975] call clearline
    jsr clearline
    // insertup::@return
    // }
    // [1976] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [1977] insertup::$3 = insertup::i#2 - 1 -- vbuz1=vbuz2_minus_1 
    ldx.z i
    dex
    stx.z __3
    // unsigned int line = (i-1) << cx16_conio.conio_rowshift
    // [1978] insertup::line#0 = insertup::$3 << *((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vbuz2_rol__deref_pbuc1 
    txa
    ldy cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
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
    // unsigned int start = cx16_conio.conio_screen_text + line
    // [1979] insertup::start#0 = *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) + insertup::line#0 -- vwuz1=_deref_pwuc1_plus_vwuz1 
    clc
    lda.z start
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z start
    lda.z start+1
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z start+1
    // cx16_cpy_vram_from_vram_inc(0, start, VERA_INC_1, 0, start+cx16_conio.conio_rowskip, VERA_INC_1, width)
    // [1980] cx16_cpy_vram_from_vram_inc::soffset_vram#0 = insertup::start#0 + *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz2_plus__deref_pwuc1 
    lda.z start
    clc
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    sta.z cx16_cpy_vram_from_vram_inc.soffset_vram
    lda.z start+1
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    sta.z cx16_cpy_vram_from_vram_inc.soffset_vram+1
    // [1981] cx16_cpy_vram_from_vram_inc::doffset_vram#0 = insertup::start#0
    // [1982] cx16_cpy_vram_from_vram_inc::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z cx16_cpy_vram_from_vram_inc.num
    lda #0
    sta.z cx16_cpy_vram_from_vram_inc.num+1
    // [1983] call cx16_cpy_vram_from_vram_inc
    // [2125] phi from insertup::@2 to cx16_cpy_vram_from_vram_inc [phi:insertup::@2->cx16_cpy_vram_from_vram_inc]
    jsr cx16_cpy_vram_from_vram_inc
    // insertup::@4
    // for(unsigned char i=1; i<=cy; i++)
    // [1984] insertup::i#1 = ++ insertup::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [1972] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [1972] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
}
  // clearline
clearline: {
    .label __1 = 9
    .label __2 = $22
    .label __5 = 8
    .label conio_screen_text = 4
    .label conio_line = $1e
    .label addr = 4
    .label color = $11
    .label c = 6
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1985] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // unsigned int conio_screen_text =  (unsigned int)cx16_conio.conio_screen_text
    // [1986] clearline::conio_screen_text#0 = *((unsigned int *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- vwuz1=_deref_pwuc1 
    // Set address
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z conio_screen_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z conio_screen_text+1
    // unsigned int conio_line = conio_line_text[cx16_conio.conio_screen_layer]
    // [1987] clearline::$5 = *((char *)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __5
    // [1988] clearline::conio_line#0 = conio_line_text[clearline::$5] -- vwuz1=pwuc1_derefidx_vbuz2 
    tay
    lda conio_line_text,y
    sta.z conio_line
    lda conio_line_text+1,y
    sta.z conio_line+1
    // conio_screen_text + conio_line
    // [1989] clearline::addr#0 = clearline::conio_screen_text#0 + clearline::conio_line#0 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z addr
    adc.z conio_line
    sta.z addr
    lda.z addr+1
    adc.z conio_line+1
    sta.z addr+1
    // BYTE0(addr)
    // [1990] clearline::$1 = byte0  (char *)clearline::addr#0 -- vbuz1=_byte0_pbuz2 
    lda.z addr
    sta.z __1
    // *VERA_ADDRX_L = BYTE0(addr)
    // [1991] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(addr)
    // [1992] clearline::$2 = byte1  (char *)clearline::addr#0 -- vbuz1=_byte1_pbuz2 
    lda.z addr+1
    sta.z __2
    // *VERA_ADDRX_M = BYTE1(addr)
    // [1993] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [1994] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // char color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1995] vera_layer_get_color::layer#1 = *((char *)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_color.layer
    // [1996] call vera_layer_get_color
  // TODO need to check this!
    // [255] phi from clearline to vera_layer_get_color [phi:clearline->vera_layer_get_color]
    // [255] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#1 [phi:clearline->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // char color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1997] vera_layer_get_color::return#4 = vera_layer_get_color::return#2
    // clearline::@4
    // [1998] clearline::color#0 = vera_layer_get_color::return#4
    // [1999] phi from clearline::@4 to clearline::@1 [phi:clearline::@4->clearline::@1]
    // [1999] phi clearline::c#2 = 0 [phi:clearline::@4->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [2000] if(clearline::c#2<*((char *)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto clearline::@2 -- vwuz1_lt__deref_pbuc1_then_la1 
    lda.z c+1
    bne !+
    lda.z c
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    bcc __b2
  !:
    // clearline::@3
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [2001] conio_cursor_x[*((char *)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // clearline::@return
    // }
    // [2002] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [2003] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [2004] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [2005] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [1999] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [1999] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
    jmp __b1
}
  // vera_display_get_hscale
/**
 * @brief Return the current horizonal scale of the vera display.
 *
 * @return vera_scale
 */
vera_display_get_hscale: {
    .const scale = 0
    .label s = $69
    .label return = $69
    // [2007] phi from vera_display_get_hscale to vera_display_get_hscale::@1 [phi:vera_display_get_hscale->vera_display_get_hscale::@1]
    // [2007] phi vera_display_get_hscale::s#2 = 1 [phi:vera_display_get_hscale->vera_display_get_hscale::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z s
    // [2007] phi from vera_display_get_hscale::@2 to vera_display_get_hscale::@1 [phi:vera_display_get_hscale::@2->vera_display_get_hscale::@1]
    // [2007] phi vera_display_get_hscale::s#2 = vera_display_get_hscale::s#1 [phi:vera_display_get_hscale::@2->vera_display_get_hscale::@1#0] -- register_copy 
    // vera_display_get_hscale::@1
  __b1:
    // if(*VERA_DC_HSCALE==hscale[s])
    // [2008] if(*VERA_DC_HSCALE!=vera_display_get_hscale::hscale[vera_display_get_hscale::s#2]) goto vera_display_get_hscale::@2 -- _deref_pbuc1_neq_pbuc2_derefidx_vbuz1_then_la1 
    lda VERA_DC_HSCALE
    ldy.z s
    cmp hscale,y
    bne __b2
    // [2011] phi from vera_display_get_hscale::@1 to vera_display_get_hscale::@3 [phi:vera_display_get_hscale::@1->vera_display_get_hscale::@3]
    // [2011] phi vera_display_get_hscale::return#0 = vera_display_get_hscale::s#2 [phi:vera_display_get_hscale::@1->vera_display_get_hscale::@3#0] -- register_copy 
    rts
    // vera_display_get_hscale::@2
  __b2:
    // for(char s:1..3)
    // [2009] vera_display_get_hscale::s#1 = ++ vera_display_get_hscale::s#2 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [2010] if(vera_display_get_hscale::s#1!=4) goto vera_display_get_hscale::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #4
    cmp.z s
    bne __b1
    // [2011] phi from vera_display_get_hscale::@2 to vera_display_get_hscale::@3 [phi:vera_display_get_hscale::@2->vera_display_get_hscale::@3]
    // [2011] phi vera_display_get_hscale::return#0 = vera_display_get_hscale::scale#0 [phi:vera_display_get_hscale::@2->vera_display_get_hscale::@3#0] -- vbuz1=vbuc1 
    lda #scale
    sta.z return
    // vera_display_get_hscale::@3
    // vera_display_get_hscale::@return
    // }
    // [2012] return 
    rts
  .segment Data
    hscale: .byte 0, $80, $40, $20
}
.segment Code
  // vera_display_get_vscale
/**
 * @brief Return the current vertical scale of the vera display.
 *
 * @return vera_scale
 */
vera_display_get_vscale: {
    .const scale = 0
    .label s = $68
    .label return = $68
    // [2014] phi from vera_display_get_vscale to vera_display_get_vscale::@1 [phi:vera_display_get_vscale->vera_display_get_vscale::@1]
    // [2014] phi vera_display_get_vscale::s#2 = 1 [phi:vera_display_get_vscale->vera_display_get_vscale::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z s
    // [2014] phi from vera_display_get_vscale::@2 to vera_display_get_vscale::@1 [phi:vera_display_get_vscale::@2->vera_display_get_vscale::@1]
    // [2014] phi vera_display_get_vscale::s#2 = vera_display_get_vscale::s#1 [phi:vera_display_get_vscale::@2->vera_display_get_vscale::@1#0] -- register_copy 
    // vera_display_get_vscale::@1
  __b1:
    // if(*VERA_DC_VSCALE==vscale[s])
    // [2015] if(*VERA_DC_VSCALE!=vera_display_get_vscale::vscale[vera_display_get_vscale::s#2]) goto vera_display_get_vscale::@2 -- _deref_pbuc1_neq_pbuc2_derefidx_vbuz1_then_la1 
    lda VERA_DC_VSCALE
    ldy.z s
    cmp vscale,y
    bne __b2
    // [2018] phi from vera_display_get_vscale::@1 to vera_display_get_vscale::@3 [phi:vera_display_get_vscale::@1->vera_display_get_vscale::@3]
    // [2018] phi vera_display_get_vscale::return#0 = vera_display_get_vscale::s#2 [phi:vera_display_get_vscale::@1->vera_display_get_vscale::@3#0] -- register_copy 
    rts
    // vera_display_get_vscale::@2
  __b2:
    // for(char s:1..3)
    // [2016] vera_display_get_vscale::s#1 = ++ vera_display_get_vscale::s#2 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [2017] if(vera_display_get_vscale::s#1!=4) goto vera_display_get_vscale::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #4
    cmp.z s
    bne __b1
    // [2018] phi from vera_display_get_vscale::@2 to vera_display_get_vscale::@3 [phi:vera_display_get_vscale::@2->vera_display_get_vscale::@3]
    // [2018] phi vera_display_get_vscale::return#0 = vera_display_get_vscale::scale#0 [phi:vera_display_get_vscale::@2->vera_display_get_vscale::@3#0] -- vbuz1=vbuc1 
    lda #scale
    sta.z return
    // vera_display_get_vscale::@3
    // vera_display_get_vscale::@return
    // }
    // [2019] return 
    rts
  .segment Data
    vscale: .byte 0, $80, $40, $20
}
.segment Code
  // mul16u
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// __zp($2c) unsigned long mul16u(__zp($5d) unsigned int a, __zp($4b) unsigned int b)
mul16u: {
    .label __1 = $6d
    .label a = $5d
    .label b = $4b
    .label return = $2c
    .label mb = $23
    .label res = $2c
    // unsigned long mb = b
    // [2020] mul16u::mb#0 = (unsigned long)mul16u::b#0 -- vduz1=_dword_vwuz2 
    lda.z b
    sta.z mb
    lda.z b+1
    sta.z mb+1
    lda #0
    sta.z mb+2
    sta.z mb+3
    // [2021] phi from mul16u to mul16u::@1 [phi:mul16u->mul16u::@1]
    // [2021] phi mul16u::mb#2 = mul16u::mb#0 [phi:mul16u->mul16u::@1#0] -- register_copy 
    // [2021] phi mul16u::res#2 = 0 [phi:mul16u->mul16u::@1#1] -- vduz1=vduc1 
    sta.z res
    sta.z res+1
    lda #<0>>$10
    sta.z res+2
    lda #>0>>$10
    sta.z res+3
    // [2021] phi mul16u::a#2 = mul16u::a#0 [phi:mul16u->mul16u::@1#2] -- register_copy 
    // mul16u::@1
  __b1:
    // while(a!=0)
    // [2022] if(mul16u::a#2!=0) goto mul16u::@2 -- vwuz1_neq_0_then_la1 
    lda.z a
    ora.z a+1
    bne __b2
    // mul16u::@return
    // }
    // [2023] return 
    rts
    // mul16u::@2
  __b2:
    // a&1
    // [2024] mul16u::$1 = mul16u::a#2 & 1 -- vbuz1=vwuz2_band_vbuc1 
    lda #1
    and.z a
    sta.z __1
    // if( (a&1) != 0)
    // [2025] if(mul16u::$1==0) goto mul16u::@3 -- vbuz1_eq_0_then_la1 
    beq __b3
    // mul16u::@4
    // res = res + mb
    // [2026] mul16u::res#1 = mul16u::res#2 + mul16u::mb#2 -- vduz1=vduz1_plus_vduz2 
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
    // [2027] phi from mul16u::@2 mul16u::@4 to mul16u::@3 [phi:mul16u::@2/mul16u::@4->mul16u::@3]
    // [2027] phi mul16u::res#6 = mul16u::res#2 [phi:mul16u::@2/mul16u::@4->mul16u::@3#0] -- register_copy 
    // mul16u::@3
  __b3:
    // a = a>>1
    // [2028] mul16u::a#1 = mul16u::a#2 >> 1 -- vwuz1=vwuz1_ror_1 
    lsr.z a+1
    ror.z a
    // mb = mb<<1
    // [2029] mul16u::mb#1 = mul16u::mb#2 << 1 -- vduz1=vduz1_rol_1 
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    // [2021] phi from mul16u::@3 to mul16u::@1 [phi:mul16u::@3->mul16u::@1]
    // [2021] phi mul16u::mb#2 = mul16u::mb#1 [phi:mul16u::@3->mul16u::@1#0] -- register_copy 
    // [2021] phi mul16u::res#2 = mul16u::res#6 [phi:mul16u::@3->mul16u::@1#1] -- register_copy 
    // [2021] phi mul16u::a#2 = mul16u::a#1 [phi:mul16u::@3->mul16u::@1#2] -- register_copy 
    jmp __b1
}
  // cx16_set_vram
/**
 * @brief Set block of memory in vram to a value.
 * Sets num bytes to the destination vram bank/offset to the specified data value.
 *
 * @param dbank_vram Destination vram bank between 0 and 1.
 * @param doffset_vram Destination vram offset between 0x0000 and 0xFFFF.
 * @param data The data to be set in word value.
 * @param num Amount of bytes to set.
 */
// void cx16_set_vram(__zp($c1) char dbank_vram, __zp($32) unsigned int doffset_vram, unsigned int data, __zp($13) unsigned int num)
cx16_set_vram: {
    .label vera_vram_data0_bank_offset1___0 = $c2
    .label vera_vram_data0_bank_offset1___1 = $c0
    .label vera_vram_data0_bank_offset1___2 = $c1
    .label i = $3e
    .label dbank_vram = $c1
    .label doffset_vram = $32
    .label num = $13
    // cx16_set_vram::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [2031] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [2032] cx16_set_vram::vera_vram_data0_bank_offset1_$0 = byte0  cx16_set_vram::doffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z doffset_vram
    sta.z vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [2033] *VERA_ADDRX_L = cx16_set_vram::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [2034] cx16_set_vram::vera_vram_data0_bank_offset1_$1 = byte1  cx16_set_vram::doffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z doffset_vram+1
    sta.z vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [2035] *VERA_ADDRX_M = cx16_set_vram::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // bank | inc_dec
    // [2036] cx16_set_vram::vera_vram_data0_bank_offset1_$2 = cx16_set_vram::dbank_vram#0 | vera_inc_1 -- vbuz1=vbuz1_bor_vbuc1 
    lda #vera_inc_1
    ora.z vera_vram_data0_bank_offset1___2
    sta.z vera_vram_data0_bank_offset1___2
    // *VERA_ADDRX_H = bank | inc_dec
    // [2037] *VERA_ADDRX_H = cx16_set_vram::vera_vram_data0_bank_offset1_$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [2038] phi from cx16_set_vram::vera_vram_data0_bank_offset1 to cx16_set_vram::@1 [phi:cx16_set_vram::vera_vram_data0_bank_offset1->cx16_set_vram::@1]
    // [2038] phi cx16_set_vram::i#2 = 0 [phi:cx16_set_vram::vera_vram_data0_bank_offset1->cx16_set_vram::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // cx16_set_vram::@1
  __b1:
    // for(word i = 0; i<num; i++)
    // [2039] if(cx16_set_vram::i#2<cx16_set_vram::num#0) goto cx16_set_vram::@2 -- vwuz1_lt_vwuz2_then_la1 
    lda.z i+1
    cmp.z num+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z num
    bcc __b2
  !:
    // cx16_set_vram::@return
    // }
    // [2040] return 
    rts
    // cx16_set_vram::@2
  __b2:
    // *VERA_DATA0 = BYTE0(data)
    // [2041] *VERA_DATA0 = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta VERA_DATA0
    // *VERA_DATA0 = BYTE1(data)
    // [2042] *VERA_DATA0 = 0 -- _deref_pbuc1=vbuc2 
    sta VERA_DATA0
    // for(word i = 0; i<num; i++)
    // [2043] cx16_set_vram::i#1 = ++ cx16_set_vram::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [2038] phi from cx16_set_vram::@2 to cx16_set_vram::@1 [phi:cx16_set_vram::@2->cx16_set_vram::@1]
    // [2038] phi cx16_set_vram::i#2 = cx16_set_vram::i#1 [phi:cx16_set_vram::@2->cx16_set_vram::@1#0] -- register_copy 
    jmp __b1
}
  // bitmap_line_ydxi
// void bitmap_line_ydxi(__zp(2) unsigned int y, __zp($40) unsigned int x, __zp($5d) unsigned int y1, __zp($49) unsigned int yd, __zp($55) unsigned int xd, __zp($57) char c)
bitmap_line_ydxi: {
    .label __6 = $1e
    .label y = 2
    .label x = $40
    .label y1 = $5d
    .label yd = $49
    .label xd = $55
    .label c = $57
    .label e = $34
    // word e = xd>>1
    // [2045] bitmap_line_ydxi::e#0 = bitmap_line_ydxi::xd#2 >> 1 -- vwuz1=vwuz2_ror_1 
    lda.z xd+1
    lsr
    sta.z e+1
    lda.z xd
    ror
    sta.z e
    // [2046] phi from bitmap_line_ydxi bitmap_line_ydxi::@2 to bitmap_line_ydxi::@1 [phi:bitmap_line_ydxi/bitmap_line_ydxi::@2->bitmap_line_ydxi::@1]
    // [2046] phi bitmap_line_ydxi::e#3 = bitmap_line_ydxi::e#0 [phi:bitmap_line_ydxi/bitmap_line_ydxi::@2->bitmap_line_ydxi::@1#0] -- register_copy 
    // [2046] phi bitmap_line_ydxi::y#3 = bitmap_line_ydxi::y#6 [phi:bitmap_line_ydxi/bitmap_line_ydxi::@2->bitmap_line_ydxi::@1#1] -- register_copy 
    // [2046] phi bitmap_line_ydxi::x#3 = bitmap_line_ydxi::x#5 [phi:bitmap_line_ydxi/bitmap_line_ydxi::@2->bitmap_line_ydxi::@1#2] -- register_copy 
    // bitmap_line_ydxi::@1
  __b1:
    // bitmap_plot(x,y,c)
    // [2047] bitmap_plot::x#2 = bitmap_line_ydxi::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_plot.x
    lda.z x+1
    sta.z bitmap_plot.x+1
    // [2048] bitmap_plot::y#2 = bitmap_line_ydxi::y#3 -- vwuz1=vwuz2 
    lda.z y
    sta.z bitmap_plot.y
    lda.z y+1
    sta.z bitmap_plot.y+1
    // [2049] bitmap_plot::c#3 = bitmap_line_ydxi::c#3 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_plot.c
    // [2050] call bitmap_plot
    // [2143] phi from bitmap_line_ydxi::@1 to bitmap_plot [phi:bitmap_line_ydxi::@1->bitmap_plot]
    // [2143] phi bitmap_plot::c#5 = bitmap_plot::c#3 [phi:bitmap_line_ydxi::@1->bitmap_plot#0] -- register_copy 
    // [2143] phi bitmap_plot::y#4 = bitmap_plot::y#2 [phi:bitmap_line_ydxi::@1->bitmap_plot#1] -- register_copy 
    // [2143] phi bitmap_plot::x#10 = bitmap_plot::x#2 [phi:bitmap_line_ydxi::@1->bitmap_plot#2] -- register_copy 
    jsr bitmap_plot
    // bitmap_line_ydxi::@4
    // y++;
    // [2051] bitmap_line_ydxi::y#2 = ++ bitmap_line_ydxi::y#3 -- vwuz1=_inc_vwuz1 
    inc.z y
    bne !+
    inc.z y+1
  !:
    // e = e+xd
    // [2052] bitmap_line_ydxi::e#1 = bitmap_line_ydxi::e#3 + bitmap_line_ydxi::xd#2 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z e
    adc.z xd
    sta.z e
    lda.z e+1
    adc.z xd+1
    sta.z e+1
    // if(yd<e)
    // [2053] if(bitmap_line_ydxi::yd#5>=bitmap_line_ydxi::e#1) goto bitmap_line_ydxi::@2 -- vwuz1_ge_vwuz2_then_la1 
    cmp.z yd+1
    bne !+
    lda.z e
    cmp.z yd
    beq __b2
  !:
    bcc __b2
    // bitmap_line_ydxi::@3
    // x++;
    // [2054] bitmap_line_ydxi::x#2 = ++ bitmap_line_ydxi::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // e = e - yd
    // [2055] bitmap_line_ydxi::e#2 = bitmap_line_ydxi::e#1 - bitmap_line_ydxi::yd#5 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z e
    sec
    sbc.z yd
    sta.z e
    lda.z e+1
    sbc.z yd+1
    sta.z e+1
    // [2056] phi from bitmap_line_ydxi::@3 bitmap_line_ydxi::@4 to bitmap_line_ydxi::@2 [phi:bitmap_line_ydxi::@3/bitmap_line_ydxi::@4->bitmap_line_ydxi::@2]
    // [2056] phi bitmap_line_ydxi::e#6 = bitmap_line_ydxi::e#2 [phi:bitmap_line_ydxi::@3/bitmap_line_ydxi::@4->bitmap_line_ydxi::@2#0] -- register_copy 
    // [2056] phi bitmap_line_ydxi::x#6 = bitmap_line_ydxi::x#2 [phi:bitmap_line_ydxi::@3/bitmap_line_ydxi::@4->bitmap_line_ydxi::@2#1] -- register_copy 
    // bitmap_line_ydxi::@2
  __b2:
    // y1+1
    // [2057] bitmap_line_ydxi::$6 = bitmap_line_ydxi::y1#6 + 1 -- vwuz1=vwuz2_plus_1 
    clc
    lda.z y1
    adc #1
    sta.z __6
    lda.z y1+1
    adc #0
    sta.z __6+1
    // while (y!=(y1+1))
    // [2058] if(bitmap_line_ydxi::y#2!=bitmap_line_ydxi::$6) goto bitmap_line_ydxi::@1 -- vwuz1_neq_vwuz2_then_la1 
    lda.z y+1
    cmp.z __6+1
    bne __b1
    lda.z y
    cmp.z __6
    bne __b1
    // bitmap_line_ydxi::@return
    // }
    // [2059] return 
    rts
}
  // bitmap_line_xdyi
// void bitmap_line_xdyi(__zp($13) unsigned int x, __zp($3e) unsigned int y, __zp(6) unsigned int x1, __zp($4b) unsigned int xd, __zp($53) unsigned int yd, __zp($5b) char c)
bitmap_line_xdyi: {
    .label __6 = $38
    .label x = $13
    .label y = $3e
    .label x1 = 6
    .label xd = $4b
    .label yd = $53
    .label c = $5b
    .label e = $32
    // word e = yd>>1
    // [2061] bitmap_line_xdyi::e#0 = bitmap_line_xdyi::yd#2 >> 1 -- vwuz1=vwuz2_ror_1 
    lda.z yd+1
    lsr
    sta.z e+1
    lda.z yd
    ror
    sta.z e
    // [2062] phi from bitmap_line_xdyi bitmap_line_xdyi::@2 to bitmap_line_xdyi::@1 [phi:bitmap_line_xdyi/bitmap_line_xdyi::@2->bitmap_line_xdyi::@1]
    // [2062] phi bitmap_line_xdyi::e#3 = bitmap_line_xdyi::e#0 [phi:bitmap_line_xdyi/bitmap_line_xdyi::@2->bitmap_line_xdyi::@1#0] -- register_copy 
    // [2062] phi bitmap_line_xdyi::y#3 = bitmap_line_xdyi::y#5 [phi:bitmap_line_xdyi/bitmap_line_xdyi::@2->bitmap_line_xdyi::@1#1] -- register_copy 
    // [2062] phi bitmap_line_xdyi::x#3 = bitmap_line_xdyi::x#6 [phi:bitmap_line_xdyi/bitmap_line_xdyi::@2->bitmap_line_xdyi::@1#2] -- register_copy 
    // bitmap_line_xdyi::@1
  __b1:
    // bitmap_plot(x,y,c)
    // [2063] bitmap_plot::x#0 = bitmap_line_xdyi::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_plot.x
    lda.z x+1
    sta.z bitmap_plot.x+1
    // [2064] bitmap_plot::y#0 = bitmap_line_xdyi::y#3 -- vwuz1=vwuz2 
    lda.z y
    sta.z bitmap_plot.y
    lda.z y+1
    sta.z bitmap_plot.y+1
    // [2065] bitmap_plot::c#1 = bitmap_line_xdyi::c#3 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_plot.c
    // [2066] call bitmap_plot
    // [2143] phi from bitmap_line_xdyi::@1 to bitmap_plot [phi:bitmap_line_xdyi::@1->bitmap_plot]
    // [2143] phi bitmap_plot::c#5 = bitmap_plot::c#1 [phi:bitmap_line_xdyi::@1->bitmap_plot#0] -- register_copy 
    // [2143] phi bitmap_plot::y#4 = bitmap_plot::y#0 [phi:bitmap_line_xdyi::@1->bitmap_plot#1] -- register_copy 
    // [2143] phi bitmap_plot::x#10 = bitmap_plot::x#0 [phi:bitmap_line_xdyi::@1->bitmap_plot#2] -- register_copy 
    jsr bitmap_plot
    // bitmap_line_xdyi::@4
    // x++;
    // [2067] bitmap_line_xdyi::x#2 = ++ bitmap_line_xdyi::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // e = e+yd
    // [2068] bitmap_line_xdyi::e#1 = bitmap_line_xdyi::e#3 + bitmap_line_xdyi::yd#2 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z e
    adc.z yd
    sta.z e
    lda.z e+1
    adc.z yd+1
    sta.z e+1
    // if(xd<e)
    // [2069] if(bitmap_line_xdyi::xd#5>=bitmap_line_xdyi::e#1) goto bitmap_line_xdyi::@2 -- vwuz1_ge_vwuz2_then_la1 
    cmp.z xd+1
    bne !+
    lda.z e
    cmp.z xd
    beq __b2
  !:
    bcc __b2
    // bitmap_line_xdyi::@3
    // y++;
    // [2070] bitmap_line_xdyi::y#2 = ++ bitmap_line_xdyi::y#3 -- vwuz1=_inc_vwuz1 
    inc.z y
    bne !+
    inc.z y+1
  !:
    // e = e - xd
    // [2071] bitmap_line_xdyi::e#2 = bitmap_line_xdyi::e#1 - bitmap_line_xdyi::xd#5 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z e
    sec
    sbc.z xd
    sta.z e
    lda.z e+1
    sbc.z xd+1
    sta.z e+1
    // [2072] phi from bitmap_line_xdyi::@3 bitmap_line_xdyi::@4 to bitmap_line_xdyi::@2 [phi:bitmap_line_xdyi::@3/bitmap_line_xdyi::@4->bitmap_line_xdyi::@2]
    // [2072] phi bitmap_line_xdyi::e#6 = bitmap_line_xdyi::e#2 [phi:bitmap_line_xdyi::@3/bitmap_line_xdyi::@4->bitmap_line_xdyi::@2#0] -- register_copy 
    // [2072] phi bitmap_line_xdyi::y#6 = bitmap_line_xdyi::y#2 [phi:bitmap_line_xdyi::@3/bitmap_line_xdyi::@4->bitmap_line_xdyi::@2#1] -- register_copy 
    // bitmap_line_xdyi::@2
  __b2:
    // x1+1
    // [2073] bitmap_line_xdyi::$6 = bitmap_line_xdyi::x1#6 + 1 -- vwuz1=vwuz2_plus_1 
    clc
    lda.z x1
    adc #1
    sta.z __6
    lda.z x1+1
    adc #0
    sta.z __6+1
    // while (x!=(x1+1))
    // [2074] if(bitmap_line_xdyi::x#2!=bitmap_line_xdyi::$6) goto bitmap_line_xdyi::@1 -- vwuz1_neq_vwuz2_then_la1 
    lda.z x+1
    cmp.z __6+1
    bne __b1
    lda.z x
    cmp.z __6
    bne __b1
    // bitmap_line_xdyi::@return
    // }
    // [2075] return 
    rts
}
  // bitmap_line_ydxd
// void bitmap_line_ydxd(__zp(4) unsigned int y, __zp($c) unsigned int x, __zp($58) unsigned int y1, __zp($4f) unsigned int yd, __zp($5f) unsigned int xd, __zp($5a) char c)
bitmap_line_ydxd: {
    .label __6 = $38
    .label y = 4
    .label x = $c
    .label y1 = $58
    .label yd = $4f
    .label xd = $5f
    .label c = $5a
    .label e = $1e
    // word e = xd>>1
    // [2077] bitmap_line_ydxd::e#0 = bitmap_line_ydxd::xd#2 >> 1 -- vwuz1=vwuz2_ror_1 
    lda.z xd+1
    lsr
    sta.z e+1
    lda.z xd
    ror
    sta.z e
    // [2078] phi from bitmap_line_ydxd bitmap_line_ydxd::@2 to bitmap_line_ydxd::@1 [phi:bitmap_line_ydxd/bitmap_line_ydxd::@2->bitmap_line_ydxd::@1]
    // [2078] phi bitmap_line_ydxd::e#3 = bitmap_line_ydxd::e#0 [phi:bitmap_line_ydxd/bitmap_line_ydxd::@2->bitmap_line_ydxd::@1#0] -- register_copy 
    // [2078] phi bitmap_line_ydxd::y#2 = bitmap_line_ydxd::y#7 [phi:bitmap_line_ydxd/bitmap_line_ydxd::@2->bitmap_line_ydxd::@1#1] -- register_copy 
    // [2078] phi bitmap_line_ydxd::x#3 = bitmap_line_ydxd::x#5 [phi:bitmap_line_ydxd/bitmap_line_ydxd::@2->bitmap_line_ydxd::@1#2] -- register_copy 
    // bitmap_line_ydxd::@1
  __b1:
    // bitmap_plot(x,y,c)
    // [2079] bitmap_plot::x#3 = bitmap_line_ydxd::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_plot.x
    lda.z x+1
    sta.z bitmap_plot.x+1
    // [2080] bitmap_plot::y#3 = bitmap_line_ydxd::y#2 -- vwuz1=vwuz2 
    lda.z y
    sta.z bitmap_plot.y
    lda.z y+1
    sta.z bitmap_plot.y+1
    // [2081] bitmap_plot::c#4 = bitmap_line_ydxd::c#3 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_plot.c
    // [2082] call bitmap_plot
    // [2143] phi from bitmap_line_ydxd::@1 to bitmap_plot [phi:bitmap_line_ydxd::@1->bitmap_plot]
    // [2143] phi bitmap_plot::c#5 = bitmap_plot::c#4 [phi:bitmap_line_ydxd::@1->bitmap_plot#0] -- register_copy 
    // [2143] phi bitmap_plot::y#4 = bitmap_plot::y#3 [phi:bitmap_line_ydxd::@1->bitmap_plot#1] -- register_copy 
    // [2143] phi bitmap_plot::x#10 = bitmap_plot::x#3 [phi:bitmap_line_ydxd::@1->bitmap_plot#2] -- register_copy 
    jsr bitmap_plot
    // bitmap_line_ydxd::@4
    // y = y++;
    // [2083] bitmap_line_ydxd::y#3 = ++ bitmap_line_ydxd::y#2 -- vwuz1=_inc_vwuz1 
    inc.z y
    bne !+
    inc.z y+1
  !:
    // e = e+xd
    // [2084] bitmap_line_ydxd::e#1 = bitmap_line_ydxd::e#3 + bitmap_line_ydxd::xd#2 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z e
    adc.z xd
    sta.z e
    lda.z e+1
    adc.z xd+1
    sta.z e+1
    // if(yd<e)
    // [2085] if(bitmap_line_ydxd::yd#5>=bitmap_line_ydxd::e#1) goto bitmap_line_ydxd::@2 -- vwuz1_ge_vwuz2_then_la1 
    cmp.z yd+1
    bne !+
    lda.z e
    cmp.z yd
    beq __b2
  !:
    bcc __b2
    // bitmap_line_ydxd::@3
    // x--;
    // [2086] bitmap_line_ydxd::x#2 = -- bitmap_line_ydxd::x#3 -- vwuz1=_dec_vwuz1 
    lda.z x
    bne !+
    dec.z x+1
  !:
    dec.z x
    // e = e - yd
    // [2087] bitmap_line_ydxd::e#2 = bitmap_line_ydxd::e#1 - bitmap_line_ydxd::yd#5 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z e
    sec
    sbc.z yd
    sta.z e
    lda.z e+1
    sbc.z yd+1
    sta.z e+1
    // [2088] phi from bitmap_line_ydxd::@3 bitmap_line_ydxd::@4 to bitmap_line_ydxd::@2 [phi:bitmap_line_ydxd::@3/bitmap_line_ydxd::@4->bitmap_line_ydxd::@2]
    // [2088] phi bitmap_line_ydxd::e#6 = bitmap_line_ydxd::e#2 [phi:bitmap_line_ydxd::@3/bitmap_line_ydxd::@4->bitmap_line_ydxd::@2#0] -- register_copy 
    // [2088] phi bitmap_line_ydxd::x#6 = bitmap_line_ydxd::x#2 [phi:bitmap_line_ydxd::@3/bitmap_line_ydxd::@4->bitmap_line_ydxd::@2#1] -- register_copy 
    // bitmap_line_ydxd::@2
  __b2:
    // y1+1
    // [2089] bitmap_line_ydxd::$6 = bitmap_line_ydxd::y1#6 + 1 -- vwuz1=vwuz2_plus_1 
    clc
    lda.z y1
    adc #1
    sta.z __6
    lda.z y1+1
    adc #0
    sta.z __6+1
    // while (y!=(y1+1))
    // [2090] if(bitmap_line_ydxd::y#3!=bitmap_line_ydxd::$6) goto bitmap_line_ydxd::@1 -- vwuz1_neq_vwuz2_then_la1 
    lda.z y+1
    cmp.z __6+1
    bne __b1
    lda.z y
    cmp.z __6
    bne __b1
    // bitmap_line_ydxd::@return
    // }
    // [2091] return 
    rts
}
  // bitmap_line_xdyd
// void bitmap_line_xdyd(__zp($46) unsigned int x, __zp($42) unsigned int y, __zp($61) unsigned int x1, __zp($4d) unsigned int xd, __zp($38) unsigned int yd, __zp($5c) char c)
bitmap_line_xdyd: {
    .label __6 = $20
    .label x = $46
    .label y = $42
    .label x1 = $61
    .label xd = $4d
    .label yd = $38
    .label c = $5c
    .label e = $36
    // word e = yd>>1
    // [2093] bitmap_line_xdyd::e#0 = bitmap_line_xdyd::yd#2 >> 1 -- vwuz1=vwuz2_ror_1 
    lda.z yd+1
    lsr
    sta.z e+1
    lda.z yd
    ror
    sta.z e
    // [2094] phi from bitmap_line_xdyd bitmap_line_xdyd::@2 to bitmap_line_xdyd::@1 [phi:bitmap_line_xdyd/bitmap_line_xdyd::@2->bitmap_line_xdyd::@1]
    // [2094] phi bitmap_line_xdyd::e#3 = bitmap_line_xdyd::e#0 [phi:bitmap_line_xdyd/bitmap_line_xdyd::@2->bitmap_line_xdyd::@1#0] -- register_copy 
    // [2094] phi bitmap_line_xdyd::y#3 = bitmap_line_xdyd::y#5 [phi:bitmap_line_xdyd/bitmap_line_xdyd::@2->bitmap_line_xdyd::@1#1] -- register_copy 
    // [2094] phi bitmap_line_xdyd::x#3 = bitmap_line_xdyd::x#6 [phi:bitmap_line_xdyd/bitmap_line_xdyd::@2->bitmap_line_xdyd::@1#2] -- register_copy 
    // bitmap_line_xdyd::@1
  __b1:
    // bitmap_plot(x,y,c)
    // [2095] bitmap_plot::x#1 = bitmap_line_xdyd::x#3 -- vwuz1=vwuz2 
    lda.z x
    sta.z bitmap_plot.x
    lda.z x+1
    sta.z bitmap_plot.x+1
    // [2096] bitmap_plot::y#1 = bitmap_line_xdyd::y#3 -- vwuz1=vwuz2 
    lda.z y
    sta.z bitmap_plot.y
    lda.z y+1
    sta.z bitmap_plot.y+1
    // [2097] bitmap_plot::c#2 = bitmap_line_xdyd::c#3 -- vbuz1=vbuz2 
    lda.z c
    sta.z bitmap_plot.c
    // [2098] call bitmap_plot
    // [2143] phi from bitmap_line_xdyd::@1 to bitmap_plot [phi:bitmap_line_xdyd::@1->bitmap_plot]
    // [2143] phi bitmap_plot::c#5 = bitmap_plot::c#2 [phi:bitmap_line_xdyd::@1->bitmap_plot#0] -- register_copy 
    // [2143] phi bitmap_plot::y#4 = bitmap_plot::y#1 [phi:bitmap_line_xdyd::@1->bitmap_plot#1] -- register_copy 
    // [2143] phi bitmap_plot::x#10 = bitmap_plot::x#1 [phi:bitmap_line_xdyd::@1->bitmap_plot#2] -- register_copy 
    jsr bitmap_plot
    // bitmap_line_xdyd::@4
    // x++;
    // [2099] bitmap_line_xdyd::x#2 = ++ bitmap_line_xdyd::x#3 -- vwuz1=_inc_vwuz1 
    inc.z x
    bne !+
    inc.z x+1
  !:
    // e = e+yd
    // [2100] bitmap_line_xdyd::e#1 = bitmap_line_xdyd::e#3 + bitmap_line_xdyd::yd#2 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z e
    adc.z yd
    sta.z e
    lda.z e+1
    adc.z yd+1
    sta.z e+1
    // if(xd<e)
    // [2101] if(bitmap_line_xdyd::xd#5>=bitmap_line_xdyd::e#1) goto bitmap_line_xdyd::@2 -- vwuz1_ge_vwuz2_then_la1 
    cmp.z xd+1
    bne !+
    lda.z e
    cmp.z xd
    beq __b2
  !:
    bcc __b2
    // bitmap_line_xdyd::@3
    // y--;
    // [2102] bitmap_line_xdyd::y#2 = -- bitmap_line_xdyd::y#3 -- vwuz1=_dec_vwuz1 
    lda.z y
    bne !+
    dec.z y+1
  !:
    dec.z y
    // e = e - xd
    // [2103] bitmap_line_xdyd::e#2 = bitmap_line_xdyd::e#1 - bitmap_line_xdyd::xd#5 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z e
    sec
    sbc.z xd
    sta.z e
    lda.z e+1
    sbc.z xd+1
    sta.z e+1
    // [2104] phi from bitmap_line_xdyd::@3 bitmap_line_xdyd::@4 to bitmap_line_xdyd::@2 [phi:bitmap_line_xdyd::@3/bitmap_line_xdyd::@4->bitmap_line_xdyd::@2]
    // [2104] phi bitmap_line_xdyd::e#6 = bitmap_line_xdyd::e#2 [phi:bitmap_line_xdyd::@3/bitmap_line_xdyd::@4->bitmap_line_xdyd::@2#0] -- register_copy 
    // [2104] phi bitmap_line_xdyd::y#6 = bitmap_line_xdyd::y#2 [phi:bitmap_line_xdyd::@3/bitmap_line_xdyd::@4->bitmap_line_xdyd::@2#1] -- register_copy 
    // bitmap_line_xdyd::@2
  __b2:
    // x1+1
    // [2105] bitmap_line_xdyd::$6 = bitmap_line_xdyd::x1#6 + 1 -- vwuz1=vwuz2_plus_1 
    clc
    lda.z x1
    adc #1
    sta.z __6
    lda.z x1+1
    adc #0
    sta.z __6+1
    // while (x!=(x1+1))
    // [2106] if(bitmap_line_xdyd::x#2!=bitmap_line_xdyd::$6) goto bitmap_line_xdyd::@1 -- vwuz1_neq_vwuz2_then_la1 
    lda.z x+1
    cmp.z __6+1
    bne __b1
    lda.z x
    cmp.z __6
    bne __b1
    // bitmap_line_xdyd::@return
    // }
    // [2107] return 
    rts
}
  // divr16u
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp($49) unsigned int divr16u(__zp($53) unsigned int dividend, __zp($55) unsigned int divisor, __zp($51) unsigned int rem)
divr16u: {
    .label __1 = $63
    .label __2 = $63
    .label rem = $51
    .label dividend = $53
    .label quotient = $49
    .label i = $65
    .label return = $49
    .label divisor = $55
    // [2109] phi from divr16u to divr16u::@1 [phi:divr16u->divr16u::@1]
    // [2109] phi divr16u::i#2 = 0 [phi:divr16u->divr16u::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // [2109] phi divr16u::quotient#3 = 0 [phi:divr16u->divr16u::@1#1] -- vwuz1=vwuc1 
    sta.z quotient
    sta.z quotient+1
    // [2109] phi divr16u::dividend#2 = divr16u::dividend#1 [phi:divr16u->divr16u::@1#2] -- register_copy 
    // [2109] phi divr16u::rem#4 = 0 [phi:divr16u->divr16u::@1#3] -- vwuz1=vbuc1 
    sta.z rem
    sta.z rem+1
    // [2109] phi from divr16u::@3 to divr16u::@1 [phi:divr16u::@3->divr16u::@1]
    // [2109] phi divr16u::i#2 = divr16u::i#1 [phi:divr16u::@3->divr16u::@1#0] -- register_copy 
    // [2109] phi divr16u::quotient#3 = divr16u::return#0 [phi:divr16u::@3->divr16u::@1#1] -- register_copy 
    // [2109] phi divr16u::dividend#2 = divr16u::dividend#0 [phi:divr16u::@3->divr16u::@1#2] -- register_copy 
    // [2109] phi divr16u::rem#4 = divr16u::rem#10 [phi:divr16u::@3->divr16u::@1#3] -- register_copy 
    // divr16u::@1
  __b1:
    // rem = rem << 1
    // [2110] divr16u::rem#0 = divr16u::rem#4 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z rem
    rol.z rem+1
    // BYTE1(dividend)
    // [2111] divr16u::$1 = byte1  divr16u::dividend#2 -- vbuz1=_byte1_vwuz2 
    lda.z dividend+1
    sta.z __1
    // BYTE1(dividend) & $80
    // [2112] divr16u::$2 = divr16u::$1 & $80 -- vbuz1=vbuz1_band_vbuc1 
    lda #$80
    and.z __2
    sta.z __2
    // if( (BYTE1(dividend) & $80) != 0 )
    // [2113] if(divr16u::$2==0) goto divr16u::@2 -- vbuz1_eq_0_then_la1 
    beq __b2
    // divr16u::@4
    // rem = rem | 1
    // [2114] divr16u::rem#1 = divr16u::rem#0 | 1 -- vwuz1=vwuz1_bor_vbuc1 
    lda #1
    ora.z rem
    sta.z rem
    // [2115] phi from divr16u::@1 divr16u::@4 to divr16u::@2 [phi:divr16u::@1/divr16u::@4->divr16u::@2]
    // [2115] phi divr16u::rem#5 = divr16u::rem#0 [phi:divr16u::@1/divr16u::@4->divr16u::@2#0] -- register_copy 
    // divr16u::@2
  __b2:
    // dividend = dividend << 1
    // [2116] divr16u::dividend#0 = divr16u::dividend#2 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z dividend
    rol.z dividend+1
    // quotient = quotient << 1
    // [2117] divr16u::quotient#1 = divr16u::quotient#3 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z quotient
    rol.z quotient+1
    // if(rem>=divisor)
    // [2118] if(divr16u::rem#5<divr16u::divisor#0) goto divr16u::@3 -- vwuz1_lt_vwuz2_then_la1 
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
    // [2119] divr16u::quotient#2 = ++ divr16u::quotient#1 -- vwuz1=_inc_vwuz1 
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    // rem = rem - divisor
    // [2120] divr16u::rem#2 = divr16u::rem#5 - divr16u::divisor#0 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z rem
    sec
    sbc.z divisor
    sta.z rem
    lda.z rem+1
    sbc.z divisor+1
    sta.z rem+1
    // [2121] phi from divr16u::@2 divr16u::@5 to divr16u::@3 [phi:divr16u::@2/divr16u::@5->divr16u::@3]
    // [2121] phi divr16u::return#0 = divr16u::quotient#1 [phi:divr16u::@2/divr16u::@5->divr16u::@3#0] -- register_copy 
    // [2121] phi divr16u::rem#10 = divr16u::rem#5 [phi:divr16u::@2/divr16u::@5->divr16u::@3#1] -- register_copy 
    // divr16u::@3
  __b3:
    // for( char i : 0..15)
    // [2122] divr16u::i#1 = ++ divr16u::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [2123] if(divr16u::i#1!=$10) goto divr16u::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z i
    bne __b1
    // divr16u::@return
    // }
    // [2124] return 
    rts
}
  // cx16_cpy_vram_from_vram_inc
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
// void cx16_cpy_vram_from_vram_inc(char dbank_vram, __zp($c) unsigned int doffset_vram, char dinc, char sbank_vram, __zp($e) unsigned int soffset_vram, char sinc, __zp(4) unsigned int num)
cx16_cpy_vram_from_vram_inc: {
    .label vera_vram_data0_bank_offset1___0 = $b
    .label vera_vram_data0_bank_offset1___1 = $a
    .label vera_vram_data1_bank_offset1___0 = 8
    .label vera_vram_data1_bank_offset1___1 = 9
    .label i = 2
    .label doffset_vram = $c
    .label soffset_vram = $e
    .label num = 4
    // cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [2126] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [2127] cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$0 = byte0  cx16_cpy_vram_from_vram_inc::soffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z soffset_vram
    sta.z vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [2128] *VERA_ADDRX_L = cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [2129] cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$1 = byte1  cx16_cpy_vram_from_vram_inc::soffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z soffset_vram+1
    sta.z vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [2130] *VERA_ADDRX_M = cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [2131] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1
    // *VERA_CTRL |= VERA_ADDRSEL
    // [2132] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [2133] cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$0 = byte0  cx16_cpy_vram_from_vram_inc::doffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z doffset_vram
    sta.z vera_vram_data1_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [2134] *VERA_ADDRX_L = cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [2135] cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$1 = byte1  cx16_cpy_vram_from_vram_inc::doffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z doffset_vram+1
    sta.z vera_vram_data1_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [2136] *VERA_ADDRX_M = cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [2137] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // [2138] phi from cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1 to cx16_cpy_vram_from_vram_inc::@1 [phi:cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1->cx16_cpy_vram_from_vram_inc::@1]
    // [2138] phi cx16_cpy_vram_from_vram_inc::i#2 = 0 [phi:cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1->cx16_cpy_vram_from_vram_inc::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // cx16_cpy_vram_from_vram_inc::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [2139] if(cx16_cpy_vram_from_vram_inc::i#2<cx16_cpy_vram_from_vram_inc::num#0) goto cx16_cpy_vram_from_vram_inc::@2 -- vwuz1_lt_vwuz2_then_la1 
    lda.z i+1
    cmp.z num+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z num
    bcc __b2
  !:
    // cx16_cpy_vram_from_vram_inc::@return
    // }
    // [2140] return 
    rts
    // cx16_cpy_vram_from_vram_inc::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [2141] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [2142] cx16_cpy_vram_from_vram_inc::i#1 = ++ cx16_cpy_vram_from_vram_inc::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [2138] phi from cx16_cpy_vram_from_vram_inc::@2 to cx16_cpy_vram_from_vram_inc::@1 [phi:cx16_cpy_vram_from_vram_inc::@2->cx16_cpy_vram_from_vram_inc::@1]
    // [2138] phi cx16_cpy_vram_from_vram_inc::i#2 = cx16_cpy_vram_from_vram_inc::i#1 [phi:cx16_cpy_vram_from_vram_inc::@2->cx16_cpy_vram_from_vram_inc::@1#0] -- register_copy 
    jmp __b1
}
  // bitmap_plot
// void bitmap_plot(__zp($20) unsigned int x, __zp($1b) unsigned int y, __zp($1a) char c)
bitmap_plot: {
    .label __3 = $1a
    .label __6 = $1d
    .label __7 = $1d
    .label __8 = $1a
    .label __9 = $e
    .label __10 = $1b
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1___0 = $28
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1___1 = $27
    .label plot_x = $2c
    .label plot_y = $23
    .label bitshift = $2b
    .label c = $1a
    .label vera_vram_data0_address1_bankaddr = $2c
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank = $3c
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset = $30
    .label x = $20
    .label y = $1b
    .label __12 = $e
    .label __13 = $1b
    .label __14 = $29
    .label __15 = $20
    // dword plot_x = __bitmap_plot_x[x]
    // [2144] bitmap_plot::$9 = bitmap_plot::x#10 << 1 -- vwuz1=vwuz2_rol_1 
    lda.z x
    asl
    sta.z __9
    lda.z x+1
    rol
    sta.z __9+1
    // [2145] bitmap_plot::$12 = __bitmap_plot_x + bitmap_plot::$9 -- pwuz1=pwuc1_plus_vwuz1 
    lda.z __12
    clc
    adc #<__bitmap_plot_x
    sta.z __12
    lda.z __12+1
    adc #>__bitmap_plot_x
    sta.z __12+1
    // [2146] bitmap_plot::plot_x#0 = (unsigned long)*bitmap_plot::$12 -- vduz1=_dword__deref_pwuz2 
    // Needs unsigned int arrays arranged as two underlying char arrays to allow char* plotter_x = plot_x[x]; - and eventually - char* plotter = plot_x[x] + plot_y[y];
    ldy #0
    sty.z plot_x+2
    sty.z plot_x+3
    lda (__12),y
    sta.z plot_x
    iny
    lda (__12),y
    sta.z plot_x+1
    // dword plot_y = __bitmap_plot_y[y]
    // [2147] bitmap_plot::$10 = bitmap_plot::y#4 << 2 -- vwuz1=vwuz1_rol_2 
    asl.z __10
    rol.z __10+1
    asl.z __10
    rol.z __10+1
    // [2148] bitmap_plot::$13 = __bitmap_plot_y + bitmap_plot::$10 -- pduz1=pduc1_plus_vwuz1 
    lda.z __13
    clc
    adc #<__bitmap_plot_y
    sta.z __13
    lda.z __13+1
    adc #>__bitmap_plot_y
    sta.z __13+1
    // [2149] bitmap_plot::plot_y#0 = *bitmap_plot::$13 -- vduz1=_deref_pduz2 
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
    // dword plotter = plot_x+plot_y
    // [2150] bitmap_plot::vera_vram_data0_address1_bankaddr#0 = bitmap_plot::plot_x#0 + bitmap_plot::plot_y#0 -- vduz1=vduz1_plus_vduz2 
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
    // byte bitshift = __bitmap_plot_bitshift[x]
    // [2151] bitmap_plot::$14 = __bitmap_plot_bitshift + bitmap_plot::x#10 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z x
    clc
    adc #<__bitmap_plot_bitshift
    sta.z __14
    lda.z x+1
    adc #>__bitmap_plot_bitshift
    sta.z __14+1
    // [2152] bitmap_plot::bitshift#0 = *bitmap_plot::$14 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (__14),y
    sta.z bitshift
    // bitshift?c<<(bitshift):c
    // [2153] if(0!=bitmap_plot::bitshift#0) goto bitmap_plot::@1 -- 0_neq_vbuz1_then_la1 
    bne __b1
    // [2155] phi from bitmap_plot bitmap_plot::@1 to bitmap_plot::@2 [phi:bitmap_plot/bitmap_plot::@1->bitmap_plot::@2]
    // [2155] phi bitmap_plot::c#0 = bitmap_plot::c#5 [phi:bitmap_plot/bitmap_plot::@1->bitmap_plot::@2#0] -- register_copy 
    jmp __b2
    // bitmap_plot::@1
  __b1:
    // [2154] bitmap_plot::$3 = bitmap_plot::c#5 << bitmap_plot::bitshift#0 -- vbuz1=vbuz1_rol_vbuz2 
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
    // [2156] bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank#0 = byte2  bitmap_plot::vera_vram_data0_address1_bankaddr#0 -- vbuz1=_byte2_vduz2 
    lda.z vera_vram_data0_address1_bankaddr+2
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank
    // [2157] bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 = word0  bitmap_plot::vera_vram_data0_address1_bankaddr#0 -- vwuz1=_word0_vduz2 
    lda.z vera_vram_data0_address1_bankaddr
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset
    lda.z vera_vram_data0_address1_bankaddr+1
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset+1
    // bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [2158] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [2159] bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$0 = byte0  bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 -- vbuz1=_byte0_vwuz2 
    lda.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [2160] *VERA_ADDRX_L = bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [2161] bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$1 = byte1  bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 -- vbuz1=_byte1_vwuz2 
    lda.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset+1
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [2162] *VERA_ADDRX_M = bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [2163] *VERA_ADDRX_H = bitmap_plot::vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuz1 
    lda.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // bitmap_plot::@3
    // ~__bitmap_plot_bitmask[x]
    // [2164] bitmap_plot::$15 = __bitmap_plot_bitmask + bitmap_plot::x#10 -- pbuz1=pbuc1_plus_vwuz1 
    lda.z __15
    clc
    adc #<__bitmap_plot_bitmask
    sta.z __15
    lda.z __15+1
    adc #>__bitmap_plot_bitmask
    sta.z __15+1
    // [2165] bitmap_plot::$6 = ~ *bitmap_plot::$15 -- vbuz1=_bnot__deref_pbuz2 
    ldy #0
    lda (__15),y
    eor #$ff
    sta.z __6
    // *VERA_DATA0 & ~__bitmap_plot_bitmask[x]
    // [2166] bitmap_plot::$7 = *VERA_DATA0 & bitmap_plot::$6 -- vbuz1=_deref_pbuc1_band_vbuz1 
    lda VERA_DATA0
    and.z __7
    sta.z __7
    // (*VERA_DATA0 & ~__bitmap_plot_bitmask[x]) | c
    // [2167] bitmap_plot::$8 = bitmap_plot::$7 | bitmap_plot::c#0 -- vbuz1=vbuz2_bor_vbuz1 
    lda.z __8
    ora.z __7
    sta.z __8
    // *VERA_DATA0 = (*VERA_DATA0 & ~__bitmap_plot_bitmask[x]) | c
    // [2168] *VERA_DATA0 = bitmap_plot::$8 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // bitmap_plot::@return
    // }
    // [2169] return 
    rts
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
  vera_mapbase_offset: .word 0, 0
  vera_mapbase_bank: .byte 0, 0
  vera_mapbase_address: .dword 0, 0
  vera_tilebase_offset: .word 0, 0
  vera_tilebase_bank: .byte 0, 0
  vera_tilebase_address: .dword 0, 0
  vera_layer_rowshift: .byte 0, 0
  vera_layer_rowskip: .word 0, 0
  vera_layer_hflip: .byte 0, 4
  vera_layer_vflip: .byte 0, 8
  vera_layer_config: .word VERA_L0_CONFIG, VERA_L1_CONFIG
  vera_layer_enable: .byte VERA_LAYER0_ENABLE, VERA_LAYER1_ENABLE
  vera_layer_mapbase: .word VERA_L0_MAPBASE, VERA_L1_MAPBASE
  vera_layer_tilebase: .word VERA_L0_TILEBASE, VERA_L1_TILEBASE
  vera_layer_textcolor: .byte WHITE, WHITE
  vera_layer_backcolor: .byte BLUE, BLUE
  // The current cursor x-position
  conio_cursor_x: .byte 0, 0
  // The current cursor y-position
  conio_cursor_y: .byte 0, 0
  // The current text cursor line start
  conio_line_text: .word 0, 0
  // Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
  // If disabled the cursor just moves back to (0,0) instead
  conio_scroll_enable: .byte 1, 1
  // Tables for the plotter - initialized by calling bitmap_draw_init();
  __bitmap_plot_x: .fill 2*$280, 0
  __bitmap_plot_y: .fill 4*$1e0, 0
  __bitmap_plot_bitmask: .fill $280, 0
  __bitmap_plot_bitshift: .fill $280, 0
  hdeltas: .word 0, $50, $28, $14, 0, $a0, $50, $28, 0, $140, $a0, $50, 0, $280, $140, $a0
  vdeltas: .word 0, $1e0, $f0, $a0
  bitmasks: .byte $80, $c0, $f0, $ff
  .fill 1, 0
  bitshifts: .byte 7, 6, 4, 0
  .fill 1, 0
  s: .text @"vera in tile mode 8 x 8, color depth 8 bits per pixel.\n"
  .byte 0
  s1: .text @"in this mode, tiles are 8 pixels wide and 8 pixels tall.\n"
  .byte 0
  s2: .text @"each tile can have a variation of 256 colors.\n"
  .byte 0
  s3: .text @"the vera palette of 256 colors, can be used by setting the palette\n"
  .byte 0
  s4: .text @"offset for each tile.\n"
  .byte 0
  s5: .text @"here each column is displaying the same tile, but with different offsets!\n"
  .byte 0
  s6: .text @"each offset aligns to multiples of 16 colors in the palette!.\n"
  .byte 0
  s7: .text @"however, the first color will always be transparent (black).\n"
  .byte 0
  string_0: .text @"each tile can have a variation of 16 colors.\n"
  .byte 0
  string_1: .text @"vera in tile mode 8 x 8, color depth 2 bits per pixel.\n"
  .byte 0
  string_2: .text @"each tile can have a variation of 4 colors.\n"
  .byte 0
  string_3: .text @"each offset aligns to multiples of 16 colors, and only the first 4 colors\n"
  .byte 0
  string_4: .text @"can be used per offset!\n"
  .byte 0
  string_5: .text @"vera in text mode 8 x 8, color depth 1 bits per pixel.\n"
  .byte 0
  string_6: .text @"here we display 6 stars (******) each with a different color.\n"
  .byte 0
  string_7: .text @"in this mode, the background color cannot be set and is always transparent.\n"
  .byte 0
  string_8: .text @"vera in bitmap mode,\n"
  .byte 0
  string_9: .text @"color depth 1 bits per pixel.\n"
  .byte 0
  string_10: .text @"in this mode, it is possible to display\n"
  .byte 0
  string_11: .text @"graphics in 2 colors (black or color).\n"
  .byte 0
  string_12: .text "press a key ..."
  .byte 0
  string_13: .text @"here you see all the colors possible.\n"
  .byte 0
  cx16_conio: .fill SIZEOF_STRUCT_CX16_CONIO, 0
