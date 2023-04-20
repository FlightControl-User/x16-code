  // File Comments
// Provides provide console input/output
// Implements similar functions as conio.h from CC65 for compatibility
// See https://github.com/cc65/cc65/blob/master/include/conio.h
//
// Currently CX16/C64/PLUS4/VIC20 platforms are supported
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="cx16-vwsm1=vwsm2_plus_pbsz3_derefidx_vbuyy.prg", type="prg", segments="Program"]
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
  .const VERA_LAYER_CONFIG_256C = 8
  .const VERA_LAYER_TILEBASE_MASK = $fc
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH = 4
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT = 5
  .const SIZEOF_WORD = 2
  .const SIZEOF_POINTER = 2
  .const SIZEOF_DWORD = 4
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT = 1
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT = 8
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH = 6
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK = 3
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP = $b
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT = $a
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR = $d
  .const OFFSET_STRUCT_P_X = 2
  .const OFFSET_STRUCT_P_DX = 6
  .const OFFSET_STRUCT_P_Y = 4
  .const SIZEOF_STRUCT_CX16_CONIO = $e
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .const SIZEOF_STRUCT_A = 8
  .const SIZEOF_STRUCT_B = 5
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
  // $9F25	CTRL Control
  // Bit 7: Reset
  // Bit 1: DCSEL
  // Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  // $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
  .label VERA_DC_HSCALE = $9f2a
  // $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
  .label VERA_DC_VSCALE = $9f2b
  // $9F2D	L0_CONFIG   Layer 0 Configuration
  .label VERA_L0_CONFIG = $9f2d
  // $9F2E	L0_MAPBASE	    Layer 0 Map Base Address (16:9)
  .label VERA_L0_MAPBASE = $9f2e
  // Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L0_TILEBASE = $9f2f
  // $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  // $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  // $9F36	L1_TILEBASE	    Layer 1 Tile Base
  // Bit 2-7: Tile Base Address (16:11)
  // Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  // Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L1_TILEBASE = $9f36
  // $9F23	DATA0	VRAM Data port 0
  .label VERA_DATA0 = $9f23
  // $9F24	DATA1	VRAM Data port 1
  .label VERA_DATA1 = $9f24
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
    // [28] phi from __start::@1 to main [phi:__start::@1->main]
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
    .label line = 3
    // char line = *BASIC_CURSOR_LINE
    // [6] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda BASIC_CURSOR_LINE
    sta.z line
    // vera_layer_mode_text(1,(dword)0x00000,(dword)0x0F800,128,64,8,8,16)
    // [7] call vera_layer_mode_text 
    // [51] phi from conio_x16_init to vera_layer_mode_text [phi:conio_x16_init->vera_layer_mode_text]
    jsr vera_layer_mode_text
    // [8] phi from conio_x16_init to conio_x16_init::@3 [phi:conio_x16_init->conio_x16_init::@3]
    // conio_x16_init::@3
    // screensize(&cx16_conio.conio_screen_width, &cx16_conio.conio_screen_height)
    // [9] call screensize 
    jsr screensize
    // [10] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // screenlayer(1)
    // [11] call screenlayer 
    jsr screenlayer
    // [12] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // vera_layer_set_textcolor(1, WHITE)
    // [13] call vera_layer_set_textcolor 
    jsr vera_layer_set_textcolor
    // [14] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // vera_layer_set_backcolor(1, BLUE)
    // [15] call vera_layer_set_backcolor 
    jsr vera_layer_set_backcolor
    // [16] phi from conio_x16_init::@6 to conio_x16_init::@7 [phi:conio_x16_init::@6->conio_x16_init::@7]
    // conio_x16_init::@7
    // vera_layer_set_mapbase(0,0x20)
    // [17] call vera_layer_set_mapbase 
    // [97] phi from conio_x16_init::@7 to vera_layer_set_mapbase [phi:conio_x16_init::@7->vera_layer_set_mapbase]
    // [97] phi vera_layer_set_mapbase::mapbase#3 = $20 [phi:conio_x16_init::@7->vera_layer_set_mapbase#0] -- vbuz1=vbuc1 
    lda #$20
    sta.z vera_layer_set_mapbase.mapbase
    // [97] phi vera_layer_set_mapbase::layer#3 = 0 [phi:conio_x16_init::@7->vera_layer_set_mapbase#1] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_set_mapbase.layer
    jsr vera_layer_set_mapbase
    // [18] phi from conio_x16_init::@7 to conio_x16_init::@8 [phi:conio_x16_init::@7->conio_x16_init::@8]
    // conio_x16_init::@8
    // vera_layer_set_mapbase(1,0x00)
    // [19] call vera_layer_set_mapbase 
    // [97] phi from conio_x16_init::@8 to vera_layer_set_mapbase [phi:conio_x16_init::@8->vera_layer_set_mapbase]
    // [97] phi vera_layer_set_mapbase::mapbase#3 = 0 [phi:conio_x16_init::@8->vera_layer_set_mapbase#0] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_set_mapbase.mapbase
    // [97] phi vera_layer_set_mapbase::layer#3 = 1 [phi:conio_x16_init::@8->vera_layer_set_mapbase#1] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_set_mapbase.layer
    jsr vera_layer_set_mapbase
    // [20] phi from conio_x16_init::@8 to conio_x16_init::@9 [phi:conio_x16_init::@8->conio_x16_init::@9]
    // conio_x16_init::@9
    // cursor(0)
    // [21] call cursor 
    jsr cursor
    // conio_x16_init::@10
    // if(line>=cx16_conio.conio_screen_height)
    // [22] if(conio_x16_init::line#0<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto conio_x16_init::@1 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z line
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b1
    // conio_x16_init::@2
    // line=cx16_conio.conio_screen_height-1
    // [23] conio_x16_init::line#1 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    stx.z line
    // [24] phi from conio_x16_init::@10 conio_x16_init::@2 to conio_x16_init::@1 [phi:conio_x16_init::@10/conio_x16_init::@2->conio_x16_init::@1]
    // [24] phi conio_x16_init::line#3 = conio_x16_init::line#0 [phi:conio_x16_init::@10/conio_x16_init::@2->conio_x16_init::@1#0] -- register_copy 
    // conio_x16_init::@1
  __b1:
    // gotoxy(0, line)
    // [25] gotoxy::y#1 = conio_x16_init::line#3
    // [26] call gotoxy 
    // [104] phi from conio_x16_init::@1 to gotoxy [phi:conio_x16_init::@1->gotoxy]
    // [104] phi gotoxy::y#4 = gotoxy::y#1 [phi:conio_x16_init::@1->gotoxy#0] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [27] return 
    rts
}
  // main
main: {
    .label ps = 7
    // clrscr()
    // [29] call clrscr 
    jsr clrscr
    // [30] phi from main to main::@3 [phi:main->main::@3]
    // main::@3
    // gotoxy(0,30)
    // [31] call gotoxy 
    // [104] phi from main::@3 to gotoxy [phi:main::@3->gotoxy]
    // [104] phi gotoxy::y#4 = $1e [phi:main::@3->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1e
    sta.z gotoxy.y
    jsr gotoxy
    // main::@4
    // ps->x = -300
    // [32] *((signed word*)(struct P*)&sa+OFFSET_STRUCT_P_X) = -$12c -- _deref_pwsc1=vwsc2 
    lda #<-$12c
    sta sa+OFFSET_STRUCT_P_X
    lda #>-$12c
    sta sa+OFFSET_STRUCT_P_X+1
    // ps->y = 8
    // [33] *((signed word*)(struct P*)&sa+OFFSET_STRUCT_P_Y) = 8 -- _deref_pwsc1=vwsc2 
    lda #<8
    sta sa+OFFSET_STRUCT_P_Y
    lda #>8
    sta sa+OFFSET_STRUCT_P_Y+1
    // ps->dx = 16
    // [34] *((signed byte*)(struct P*)&sa+OFFSET_STRUCT_P_DX) = $10 -- _deref_pbsc1=vbsc2 
    lda #$10
    sta sa+OFFSET_STRUCT_P_DX
    // fun((void*)ps)
    // [35] call fun 
    // [151] phi from main::@4 to fun [phi:main::@4->fun]
    // [151] phi fun::return#0 = (void*)(struct P*)&sa [phi:main::@4->fun#0] -- pvoz1=pvoc1 
    lda #<sa
    sta.z fun.return
    lda #>sa
    sta.z fun.return+1
    jsr fun
    // fun((void*)ps)
    // [36] fun::return#2 = fun::return#0
    // main::@5
    // [37] main::ps#1 = fun::return#2 -- pvoz1=pvoz2 
    lda.z fun.return
    sta.z ps
    lda.z fun.return+1
    sta.z ps+1
    // fun((void*)&sb)
    // [38] call fun 
    // [151] phi from main::@5 to fun [phi:main::@5->fun]
    // [151] phi fun::return#0 = (void*)&sb [phi:main::@5->fun#0] -- pvoz1=pvoc1 
    lda #<sb
    sta.z fun.return
    lda #>sb
    sta.z fun.return+1
    jsr fun
    // [39] phi from main::@5 to main::@1 [phi:main::@5->main::@1]
    // [39] phi main::n#2 = 0 [phi:main::@5->main::@1#0] -- vwsm1=vwsc1 
    lda #<0
    sta n
    sta n+1
    // main::@1
  __b1:
    // for( int n=0; n<30;n++)
    // [40] if(main::n#2<$1e) goto main::@2 -- vwsm1_lt_vwuc1_then_la1 
    lda n+1
    bmi __b2
    cmp #>$1e
    bcc __b2
    bne !+
    lda n
    cmp #<$1e
    bcc __b2
  !:
    // main::@return
    // }
    // [41] return 
    rts
    // main::@2
  __b2:
    // calc(ps)
    // [42] calc::pp#0 = (struct P*)main::ps#1 -- pssz1=pssz2 
    lda.z ps
    sta.z calc.pp
    lda.z ps+1
    sta.z calc.pp+1
    // [43] call calc 
    jsr calc
    // [44] phi from main::@2 to main::@6 [phi:main::@2->main::@6]
    // main::@6
    // printf("ps->x = %i\n", ps->x)
    // [45] call cputs 
    // [157] phi from main::@6 to cputs [phi:main::@6->cputs]
    // [157] phi cputs::s#5 = main::s [phi:main::@6->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@7
    // printf("ps->x = %i\n", ps->x)
    // [46] printf_sint::value#1 = ((signed word*)(struct P*)main::ps#1)[OFFSET_STRUCT_P_X] -- vwsz1=pwsz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_P_X
    lda (ps),y
    sta.z printf_sint.value
    iny
    lda (ps),y
    sta.z printf_sint.value+1
    // [47] call printf_sint 
    jsr printf_sint
    // [48] phi from main::@7 to main::@8 [phi:main::@7->main::@8]
    // main::@8
    // printf("ps->x = %i\n", ps->x)
    // [49] call cputs 
    // [157] phi from main::@8 to cputs [phi:main::@8->cputs]
    // [157] phi cputs::s#5 = main::s1 [phi:main::@8->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@9
    // for( int n=0; n<30;n++)
    // [50] main::n#1 = ++ main::n#2 -- vwsm1=_inc_vwsm1 
    inc n
    bne !+
    inc n+1
  !:
    // [39] phi from main::@9 to main::@1 [phi:main::@9->main::@1]
    // [39] phi main::n#2 = main::n#1 [phi:main::@9->main::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    s: .text "ps->x = "
    .byte 0
    s1: .text @"\n"
    .byte 0
    n: .word 0
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
vera_layer_mode_text: {
    .label layer = 1
    .label mapbase_address = 0
    .label tilebase_address = $f800
    // vera_layer_mode_tile( layer, mapbase_address, tilebase_address, mapwidth, mapheight, tilewidth, tileheight, 1 )
    // [52] call vera_layer_mode_tile 
    // [175] phi from vera_layer_mode_text to vera_layer_mode_tile [phi:vera_layer_mode_text->vera_layer_mode_tile]
    jsr vera_layer_mode_tile
    // [53] phi from vera_layer_mode_text to vera_layer_mode_text::@1 [phi:vera_layer_mode_text->vera_layer_mode_text::@1]
    // vera_layer_mode_text::@1
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C )
    // [54] call vera_layer_set_text_color_mode 
    jsr vera_layer_set_text_color_mode
    // vera_layer_mode_text::@return
    // }
    // [55] return 
    rts
}
  // screensize
// Return the current screen size.
screensize: {
    .label x = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    .label y = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    .label hscale = $a
    .label vscale = 9
    // char hscale = (*VERA_DC_HSCALE) >> 7
    // [56] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    sta.z hscale
    // 40 << hscale
    // [57] screensize::$1 = $28 << screensize::hscale#0 -- vbum1=vbuc1_rol_vbuz2 
    lda #$28
    ldy.z hscale
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta __1
    // *x = 40 << hscale
    // [58] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbum1 
    sta x
    // char vscale = (*VERA_DC_VSCALE) >> 7
    // [59] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    sta.z vscale
    // 30 << vscale
    // [60] screensize::$3 = $1e << screensize::vscale#0 -- vbum1=vbuc1_rol_vbuz2 
    lda #$1e
    ldy.z vscale
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta __3
    // *y = 30 << vscale
    // [61] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbum1 
    sta y
    // screensize::@return
    // }
    // [62] return 
    rts
  .segment Data
    __1: .byte 0
    __3: .byte 0
}
.segment Code
  // screenlayer
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer: {
    .label layer = 1
    .label vera_layer_get_width1_config = $17
    .label vera_layer_get_width1_return = $b
    .label vera_layer_get_height1_config = $d
    .label vera_layer_get_height1_return = $10
    // cx16_conio.conio_screen_layer = layer
    // [63] *((byte*)&cx16_conio) = screenlayer::layer#0 -- _deref_pbuc1=vbuc2 
    lda #layer
    sta cx16_conio
    // vera_layer_get_mapbase_bank(layer)
    // [64] call vera_layer_get_mapbase_bank 
    jsr vera_layer_get_mapbase_bank
    // [65] vera_layer_get_mapbase_bank::return#2 = vera_layer_get_mapbase_bank::return#0
    // screenlayer::@3
    // [66] screenlayer::$0 = vera_layer_get_mapbase_bank::return#2 -- vbum1=vbuz2 
    lda.z vera_layer_get_mapbase_bank.return
    sta __0
    // cx16_conio.conio_screen_bank = vera_layer_get_mapbase_bank(layer)
    // [67] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) = screenlayer::$0 -- _deref_pbuc1=vbum1 
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // vera_layer_get_mapbase_offset(layer)
    // [68] call vera_layer_get_mapbase_offset 
    jsr vera_layer_get_mapbase_offset
    // [69] vera_layer_get_mapbase_offset::return#2 = vera_layer_get_mapbase_offset::return#0
    // screenlayer::@4
    // [70] screenlayer::$1 = vera_layer_get_mapbase_offset::return#2 -- vwum1=vwuz2 
    lda.z vera_layer_get_mapbase_offset.return
    sta __1
    lda.z vera_layer_get_mapbase_offset.return+1
    sta __1+1
    // cx16_conio.conio_screen_text = vera_layer_get_mapbase_offset(layer)
    // [71] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) = screenlayer::$1 -- _deref_pwuc1=vwum1 
    lda __1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    lda __1+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    // screenlayer::vera_layer_get_width1
    // byte* config = vera_layer_config[layer]
    // [72] screenlayer::vera_layer_get_width1_config#0 = *(vera_layer_config+screenlayer::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+layer*SIZEOF_POINTER
    sta.z vera_layer_get_width1_config
    lda vera_layer_config+layer*SIZEOF_POINTER+1
    sta.z vera_layer_get_width1_config+1
    // *config & VERA_LAYER_WIDTH_MASK
    // [73] screenlayer::vera_layer_get_width1_$0 = *screenlayer::vera_layer_get_width1_config#0 & VERA_LAYER_WIDTH_MASK -- vbum1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    ldy #0
    and (vera_layer_get_width1_config),y
    sta vera_layer_get_width1___0
    // (*config & VERA_LAYER_WIDTH_MASK) >> 4
    // [74] screenlayer::vera_layer_get_width1_$1 = screenlayer::vera_layer_get_width1_$0 >> 4 -- vbum1=vbum1_ror_4 
    lda vera_layer_get_width1___1
    lsr
    lsr
    lsr
    lsr
    sta vera_layer_get_width1___1
    // return VERA_LAYER_WIDTH[ (*config & VERA_LAYER_WIDTH_MASK) >> 4];
    // [75] screenlayer::vera_layer_get_width1_$3 = screenlayer::vera_layer_get_width1_$1 << 1 -- vbum1=vbum1_rol_1 
    asl vera_layer_get_width1___3
    // [76] screenlayer::vera_layer_get_width1_return#0 = VERA_LAYER_WIDTH[screenlayer::vera_layer_get_width1_$3] -- vwuz1=pwuc1_derefidx_vbum2 
    ldy vera_layer_get_width1___3
    lda VERA_LAYER_WIDTH,y
    sta.z vera_layer_get_width1_return
    lda VERA_LAYER_WIDTH+1,y
    sta.z vera_layer_get_width1_return+1
    // screenlayer::@1
    // cx16_conio.conio_map_width = vera_layer_get_width(layer)
    // [77] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) = screenlayer::vera_layer_get_width1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_width1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    lda.z vera_layer_get_width1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    // screenlayer::vera_layer_get_height1
    // byte* config = vera_layer_config[layer]
    // [78] screenlayer::vera_layer_get_height1_config#0 = *(vera_layer_config+screenlayer::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+layer*SIZEOF_POINTER
    sta.z vera_layer_get_height1_config
    lda vera_layer_config+layer*SIZEOF_POINTER+1
    sta.z vera_layer_get_height1_config+1
    // *config & VERA_LAYER_HEIGHT_MASK
    // [79] screenlayer::vera_layer_get_height1_$0 = *screenlayer::vera_layer_get_height1_config#0 & VERA_LAYER_HEIGHT_MASK -- vbum1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    ldy #0
    and (vera_layer_get_height1_config),y
    sta vera_layer_get_height1___0
    // (*config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [80] screenlayer::vera_layer_get_height1_$1 = screenlayer::vera_layer_get_height1_$0 >> 6 -- vbum1=vbum1_ror_6 
    lda vera_layer_get_height1___1
    rol
    rol
    rol
    and #3
    sta vera_layer_get_height1___1
    // return VERA_LAYER_HEIGHT[ (*config & VERA_LAYER_HEIGHT_MASK) >> 6];
    // [81] screenlayer::vera_layer_get_height1_$3 = screenlayer::vera_layer_get_height1_$1 << 1 -- vbum1=vbum1_rol_1 
    asl vera_layer_get_height1___3
    // [82] screenlayer::vera_layer_get_height1_return#0 = VERA_LAYER_HEIGHT[screenlayer::vera_layer_get_height1_$3] -- vwuz1=pwuc1_derefidx_vbum2 
    ldy vera_layer_get_height1___3
    lda VERA_LAYER_HEIGHT,y
    sta.z vera_layer_get_height1_return
    lda VERA_LAYER_HEIGHT+1,y
    sta.z vera_layer_get_height1_return+1
    // screenlayer::@2
    // cx16_conio.conio_map_height = vera_layer_get_height(layer)
    // [83] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) = screenlayer::vera_layer_get_height1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_height1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    lda.z vera_layer_get_height1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    // vera_layer_get_rowshift(layer)
    // [84] call vera_layer_get_rowshift 
    jsr vera_layer_get_rowshift
    // [85] vera_layer_get_rowshift::return#2 = vera_layer_get_rowshift::return#0
    // screenlayer::@5
    // [86] screenlayer::$4 = vera_layer_get_rowshift::return#2 -- vbum1=vbuz2 
    lda.z vera_layer_get_rowshift.return
    sta __4
    // cx16_conio.conio_rowshift = vera_layer_get_rowshift(layer)
    // [87] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) = screenlayer::$4 -- _deref_pbuc1=vbum1 
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
    // vera_layer_get_rowskip(layer)
    // [88] call vera_layer_get_rowskip 
    jsr vera_layer_get_rowskip
    // [89] vera_layer_get_rowskip::return#2 = vera_layer_get_rowskip::return#0
    // screenlayer::@6
    // [90] screenlayer::$5 = vera_layer_get_rowskip::return#2 -- vwum1=vwuz2 
    lda.z vera_layer_get_rowskip.return
    sta __5
    lda.z vera_layer_get_rowskip.return+1
    sta __5+1
    // cx16_conio.conio_rowskip = vera_layer_get_rowskip(layer)
    // [91] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) = screenlayer::$5 -- _deref_pwuc1=vwum1 
    lda __5
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    lda __5+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    // screenlayer::@return
    // }
    // [92] return 
    rts
  .segment Data
    __0: .byte 0
    __1: .word 0
    __4: .byte 0
    __5: .word 0
    vera_layer_get_width1___0: .byte 0
    .label vera_layer_get_width1___1 = vera_layer_get_width1___0
    .label vera_layer_get_width1___3 = vera_layer_get_width1___0
    vera_layer_get_height1___0: .byte 0
    .label vera_layer_get_height1___1 = vera_layer_get_height1___0
    .label vera_layer_get_height1___3 = vera_layer_get_height1___0
}
.segment Code
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
vera_layer_set_textcolor: {
    .const layer = 1
    // vera_layer_textcolor[layer] = color
    // [93] *(vera_layer_textcolor+vera_layer_set_textcolor::layer#0) = WHITE -- _deref_pbuc1=vbuc2 
    lda #WHITE
    sta vera_layer_textcolor+layer
    // vera_layer_set_textcolor::@return
    // }
    // [94] return 
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
vera_layer_set_backcolor: {
    .const layer = 1
    // vera_layer_backcolor[layer] = color
    // [95] *(vera_layer_backcolor+vera_layer_set_backcolor::layer#0) = BLUE -- _deref_pbuc1=vbuc2 
    lda #BLUE
    sta vera_layer_backcolor+layer
    // vera_layer_set_backcolor::@return
    // }
    // [96] return 
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
// vera_layer_set_mapbase(byte zp($a) layer, byte zp(9) mapbase)
vera_layer_set_mapbase: {
    .label addr = $b
    .label layer = $a
    .label mapbase = 9
    // byte* addr = vera_layer_mapbase[layer]
    // [98] vera_layer_set_mapbase::$0 = vera_layer_set_mapbase::layer#3 << 1 -- vbum1=vbuz2_rol_1 
    lda.z layer
    asl
    sta __0
    // [99] vera_layer_set_mapbase::addr#0 = vera_layer_mapbase[vera_layer_set_mapbase::$0] -- pbuz1=qbuc1_derefidx_vbum2 
    tay
    lda vera_layer_mapbase,y
    sta.z addr
    lda vera_layer_mapbase+1,y
    sta.z addr+1
    // *addr = mapbase
    // [100] *vera_layer_set_mapbase::addr#0 = vera_layer_set_mapbase::mapbase#3 -- _deref_pbuz1=vbuz2 
    lda.z mapbase
    ldy #0
    sta (addr),y
    // vera_layer_set_mapbase::@return
    // }
    // [101] return 
    rts
  .segment Data
    __0: .byte 0
}
.segment Code
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
cursor: {
    .const onoff = 0
    // cx16_conio.conio_display_cursor = onoff
    // [102] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR
    // cursor::@return
    // }
    // [103] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// gotoxy(byte zp(3) y)
gotoxy: {
    .label line_offset = $d
    .label y = 3
    // if(y>cx16_conio.conio_screen_height)
    // [105] if(gotoxy::y#4<=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto gotoxy::@4 -- vbuz1_le__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    cmp.z y
    bcs __b1
    // [107] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [107] phi gotoxy::y#5 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z y
    // [106] phi from gotoxy to gotoxy::@4 [phi:gotoxy->gotoxy::@4]
    // gotoxy::@4
    // [107] phi from gotoxy::@4 to gotoxy::@1 [phi:gotoxy::@4->gotoxy::@1]
    // [107] phi gotoxy::y#5 = gotoxy::y#4 [phi:gotoxy::@4->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=cx16_conio.conio_screen_width)
    // [108] if(0<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto gotoxy::@2 -- 0_lt__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    cmp #0
    // [109] phi from gotoxy::@1 to gotoxy::@3 [phi:gotoxy::@1->gotoxy::@3]
    // gotoxy::@3
    // gotoxy::@2
    // conio_cursor_x[cx16_conio.conio_screen_layer] = x
    // [110] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = y
    // [111] conio_cursor_y[*((byte*)&cx16_conio)] = gotoxy::y#5 -- pbuc1_derefidx_(_deref_pbuc2)=vbuz1 
    lda.z y
    sta conio_cursor_y,y
    // (unsigned int)y << cx16_conio.conio_rowshift
    // [112] gotoxy::$6 = (word)gotoxy::y#5 -- vwum1=_word_vbuz2 
    sta __6
    lda #0
    sta __6+1
    // unsigned int line_offset = (unsigned int)y << cx16_conio.conio_rowshift
    // [113] gotoxy::line_offset#0 = gotoxy::$6 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vwum2_rol__deref_pbuc1 
    ldy cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
    lda __6
    sta.z line_offset
    lda __6+1
    sta.z line_offset+1
    cpy #0
    beq !e+
  !:
    asl.z line_offset
    rol.z line_offset+1
    dey
    bne !-
  !e:
    // conio_line_text[cx16_conio.conio_screen_layer] = line_offset
    // [114] gotoxy::$5 = *((byte*)&cx16_conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta __5
    // [115] conio_line_text[gotoxy::$5] = gotoxy::line_offset#0 -- pwuc1_derefidx_vbum1=vwuz2 
    tay
    lda.z line_offset
    sta conio_line_text,y
    lda.z line_offset+1
    sta conio_line_text+1,y
    // gotoxy::@return
    // }
    // [116] return 
    rts
  .segment Data
    __5: .byte 0
    __6: .word 0
}
.segment Code
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label line_text = 4
    .label color = $16
    .label conio_map_height = $12
    .label conio_map_width = $14
    .label c = $1b
    .label l = 6
    // unsigned int line_text = cx16_conio.conio_screen_text
    // [117] clrscr::line_text#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z line_text+1
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer)
    // [118] vera_layer_get_backcolor::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_backcolor.layer
    // [119] call vera_layer_get_backcolor 
    jsr vera_layer_get_backcolor
    // [120] vera_layer_get_backcolor::return#0 = vera_layer_get_backcolor::return#1
    // clrscr::@7
    // [121] clrscr::$0 = vera_layer_get_backcolor::return#0 -- vbum1=vbuz2 
    lda.z vera_layer_get_backcolor.return
    sta __0
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4
    // [122] clrscr::$1 = clrscr::$0 << 4 -- vbum1=vbum1_rol_4 
    lda __1
    asl
    asl
    asl
    asl
    sta __1
    // vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [123] vera_layer_get_textcolor::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_textcolor.layer
    // [124] call vera_layer_get_textcolor 
    jsr vera_layer_get_textcolor
    // [125] vera_layer_get_textcolor::return#0 = vera_layer_get_textcolor::return#1
    // clrscr::@8
    // [126] clrscr::$2 = vera_layer_get_textcolor::return#0 -- vbum1=vbuz2 
    lda.z vera_layer_get_textcolor.return
    sta __2
    // char color = ( vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4 ) | vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [127] clrscr::color#0 = clrscr::$1 | clrscr::$2 -- vbuz1=vbum2_bor_vbum3 
    lda __1
    ora __2
    sta.z color
    // word conio_map_height = cx16_conio.conio_map_height
    // [128] clrscr::conio_map_height#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    sta.z conio_map_height
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    sta.z conio_map_height+1
    // word conio_map_width = cx16_conio.conio_map_width
    // [129] clrscr::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // [130] phi from clrscr::@8 to clrscr::@1 [phi:clrscr::@8->clrscr::@1]
    // [130] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr::@8->clrscr::@1#0] -- register_copy 
    // [130] phi clrscr::l#2 = 0 [phi:clrscr::@8->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<conio_map_height; l++ )
    // [131] if(clrscr::l#2<clrscr::conio_map_height#0) goto clrscr::@2 -- vbuz1_lt_vwuz2_then_la1 
    lda.z conio_map_height+1
    bne __b2
    lda.z l
    cmp.z conio_map_height
    bcc __b2
    // clrscr::@3
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [132] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = 0
    // [133] conio_cursor_y[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    sta conio_cursor_y,y
    // conio_line_text[cx16_conio.conio_screen_layer] = 0
    // [134] clrscr::$9 = *((byte*)&cx16_conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    tya
    asl
    sta __9
    // [135] conio_line_text[clrscr::$9] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy __9
    sta conio_line_text,y
    sta conio_line_text+1,y
    // clrscr::@return
    // }
    // [136] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [137] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <ch
    // [138] clrscr::$5 = < clrscr::line_text#2 -- vbum1=_lo_vwuz2 
    lda.z line_text
    sta __5
    // *VERA_ADDRX_L = <ch
    // [139] *VERA_ADDRX_L = clrscr::$5 -- _deref_pbuc1=vbum1 
    // Set address
    sta VERA_ADDRX_L
    // >ch
    // [140] clrscr::$6 = > clrscr::line_text#2 -- vbum1=_hi_vwuz2 
    lda.z line_text+1
    sta __6
    // *VERA_ADDRX_M = >ch
    // [141] *VERA_ADDRX_M = clrscr::$6 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [142] clrscr::$7 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    sta __7
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [143] *VERA_ADDRX_H = clrscr::$7 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // [144] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [144] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@4
  __b4:
    // for( char c=0;c<conio_map_width; c++ )
    // [145] if(clrscr::c#2<clrscr::conio_map_width#0) goto clrscr::@5 -- vbuz1_lt_vwuz2_then_la1 
    lda.z conio_map_width+1
    bne __b5
    lda.z c
    cmp.z conio_map_width
    bcc __b5
    // clrscr::@6
    // line_text += cx16_conio.conio_rowskip
    // [146] clrscr::line_text#1 = clrscr::line_text#2 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z line_text
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z line_text+1
    sta.z line_text+1
    // for( char l=0;l<conio_map_height; l++ )
    // [147] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [130] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [130] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [130] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [148] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [149] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<conio_map_width; c++ )
    // [150] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [144] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [144] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
  .segment Data
    __0: .byte 0
    .label __1 = __0
    __2: .byte 0
    __5: .byte 0
    __6: .byte 0
    __7: .byte 0
    __9: .byte 0
}
.segment Code
  // fun
fun: {
    .label return = 4
    // fun::@return
    // }
    // [152] return 
    rts
}
  // calc
// calc(struct P* zp($12) pp)
calc: {
    .label pp = $12
    // signed int x = pp->x
    // [153] calc::x#0 = ((signed word*)calc::pp#0)[OFFSET_STRUCT_P_X] -- vwsm1=pwsz2_derefidx_vbuc1 
    // asm { .byte $db }
    ldy #OFFSET_STRUCT_P_X
    lda (pp),y
    sta x
    iny
    lda (pp),y
    sta x+1
    // x += pp->dx
    // [154] calc::x#1 = calc::x#0 + ((signed byte*)calc::pp#0)[OFFSET_STRUCT_P_DX] -- vwsm1=vwsm1_plus_pbsz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_P_DX
    lda (pp),y
    sta.z $fe
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z $ff
    clc
    lda x
    adc.z $fe
    sta x
    lda x+1
    adc.z $ff
    sta x+1
    // pp->x = x
    // [155] ((signed word*)calc::pp#0)[OFFSET_STRUCT_P_X] = calc::x#1 -- pwsz1_derefidx_vbuc1=vwsm2 
    ldy #OFFSET_STRUCT_P_X
    lda x
    sta (pp),y
    iny
    lda x+1
    sta (pp),y
    // calc::@return
    // }
    // [156] return 
    rts
  .segment Data
    x: .word 0
}
.segment Code
  // cputs
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp(4) s)
cputs: {
    .label c = 6
    .label s = 4
    // [158] phi from cputs cputs::@2 to cputs::@1 [phi:cputs/cputs::@2->cputs::@1]
    // [158] phi cputs::s#4 = cputs::s#5 [phi:cputs/cputs::@2->cputs::@1#0] -- register_copy 
    // cputs::@1
  __b1:
    // while(c=*s++)
    // [159] cputs::c#1 = *cputs::s#4 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta.z c
    // [160] cputs::s#0 = ++ cputs::s#4 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [161] if(0!=cputs::c#1) goto cputs::@2 -- 0_neq_vbuz1_then_la1 
    lda.z c
    bne __b2
    // cputs::@return
    // }
    // [162] return 
    rts
    // cputs::@2
  __b2:
    // cputc(c)
    // [163] cputc::c#0 = cputs::c#1
    // [164] call cputc 
    // [206] phi from cputs::@2 to cputc [phi:cputs::@2->cputc]
    // [206] phi cputc::c#3 = cputc::c#0 [phi:cputs::@2->cputc#0] -- register_copy 
    jsr cputc
    jmp __b1
}
  // printf_sint
// Print a signed integer using a specific format
// printf_sint(signed word zp(4) value)
printf_sint: {
    .label value = 4
    // printf_buffer.sign = 0
    // [165] *((byte*)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // if(value<0)
    // [166] if(printf_sint::value#1<0) goto printf_sint::@1 -- vwsz1_lt_0_then_la1 
    lda.z value+1
    bmi __b1
    // [169] phi from printf_sint printf_sint::@1 to printf_sint::@2 [phi:printf_sint/printf_sint::@1->printf_sint::@2]
    // [169] phi printf_sint::value#4 = printf_sint::value#1 [phi:printf_sint/printf_sint::@1->printf_sint::@2#0] -- register_copy 
    jmp __b2
    // printf_sint::@1
  __b1:
    // value = -value
    // [167] printf_sint::value#0 = - printf_sint::value#1 -- vwsz1=_neg_vwsz1 
    sec
    lda #0
    sbc.z value
    sta.z value
    lda #0
    sbc.z value+1
    sta.z value+1
    // printf_buffer.sign = '-'
    // [168] *((byte*)&printf_buffer) = '-' -- _deref_pbuc1=vbuc2 
    lda #'-'
    sta printf_buffer
    // printf_sint::@2
  __b2:
    // utoa(uvalue, printf_buffer.digits, format.radix)
    // [170] utoa::value#1 = (word)printf_sint::value#4
    // [171] call utoa 
    // [240] phi from printf_sint::@2 to utoa [phi:printf_sint::@2->utoa]
    jsr utoa
    // printf_sint::@3
    // printf_number_buffer(printf_buffer, format)
    // [172] printf_number_buffer::buffer_sign#0 = *((byte*)&printf_buffer) -- vbuz1=_deref_pbuc1 
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
    // [173] call printf_number_buffer 
  // Print using format
    // [261] phi from printf_sint::@3 to printf_number_buffer [phi:printf_sint::@3->printf_number_buffer]
    jsr printf_number_buffer
    // printf_sint::@return
    // }
    // [174] return 
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
vera_layer_mode_tile: {
    .const mapbase = 0
    .label tilebase_address = vera_layer_mode_text.tilebase_address>>1
    // config
    .label config = VERA_LAYER_WIDTH_128|VERA_LAYER_HEIGHT_64
    // vera_layer_mode_tile::@1
    // vera_layer_rowshift[layer] = 8
    // [176] *(vera_layer_rowshift+vera_layer_mode_text::layer#0) = 8 -- _deref_pbuc1=vbuc2 
    lda #8
    sta vera_layer_rowshift+vera_layer_mode_text.layer
    // vera_layer_rowskip[layer] = 256
    // [177] *(vera_layer_rowskip+vera_layer_mode_text::layer#0*SIZEOF_WORD) = $100 -- _deref_pwuc1=vwuc2 
    lda #<$100
    sta vera_layer_rowskip+vera_layer_mode_text.layer*SIZEOF_WORD
    lda #>$100
    sta vera_layer_rowskip+vera_layer_mode_text.layer*SIZEOF_WORD+1
    // [178] phi from vera_layer_mode_tile::@1 to vera_layer_mode_tile::@2 [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@2]
    // vera_layer_mode_tile::@2
    // vera_layer_set_config(layer, config)
    // [179] call vera_layer_set_config 
    jsr vera_layer_set_config
    // vera_layer_mode_tile::@4
    // vera_mapbase_offset[layer] = <mapbase_address
    // [180] *(vera_mapbase_offset+vera_layer_mode_text::layer#0*SIZEOF_WORD) = 0 -- _deref_pwuc1=vwuc2 
    // mapbase
    lda #<0
    sta vera_mapbase_offset+vera_layer_mode_text.layer*SIZEOF_WORD
    sta vera_mapbase_offset+vera_layer_mode_text.layer*SIZEOF_WORD+1
    // vera_mapbase_bank[layer] = (byte)(>mapbase_address)
    // [181] *(vera_mapbase_bank+vera_layer_mode_text::layer#0) = 0 -- _deref_pbuc1=vbuc2 
    sta vera_mapbase_bank+vera_layer_mode_text.layer
    // vera_mapbase_address[layer] = mapbase_address
    // [182] *(vera_mapbase_address+vera_layer_mode_text::layer#0*SIZEOF_DWORD) = vera_layer_mode_text::mapbase_address#0 -- _deref_pduc1=vduc2 
    lda #<vera_layer_mode_text.mapbase_address
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_DWORD
    lda #>vera_layer_mode_text.mapbase_address
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+1
    lda #<vera_layer_mode_text.mapbase_address>>$10
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+2
    lda #>vera_layer_mode_text.mapbase_address>>$10
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+3
    // vera_layer_set_mapbase(layer,mapbase)
    // [183] call vera_layer_set_mapbase 
    // [97] phi from vera_layer_mode_tile::@4 to vera_layer_set_mapbase [phi:vera_layer_mode_tile::@4->vera_layer_set_mapbase]
    // [97] phi vera_layer_set_mapbase::mapbase#3 = vera_layer_mode_tile::mapbase#0 [phi:vera_layer_mode_tile::@4->vera_layer_set_mapbase#0] -- vbuz1=vbuc1 
    lda #mapbase
    sta.z vera_layer_set_mapbase.mapbase
    // [97] phi vera_layer_set_mapbase::layer#3 = vera_layer_mode_text::layer#0 [phi:vera_layer_mode_tile::@4->vera_layer_set_mapbase#1] -- vbuz1=vbuc1 
    lda #vera_layer_mode_text.layer
    sta.z vera_layer_set_mapbase.layer
    jsr vera_layer_set_mapbase
    // vera_layer_mode_tile::@5
    // vera_tilebase_offset[layer] = <tilebase_address
    // [184] *(vera_tilebase_offset+vera_layer_mode_text::layer#0*SIZEOF_WORD) = <vera_layer_mode_text::tilebase_address#0 -- _deref_pwuc1=vwuc2 
    // tilebase
    lda #<vera_layer_mode_text.tilebase_address&$ffff
    sta vera_tilebase_offset+vera_layer_mode_text.layer*SIZEOF_WORD
    lda #>vera_layer_mode_text.tilebase_address&$ffff
    sta vera_tilebase_offset+vera_layer_mode_text.layer*SIZEOF_WORD+1
    // vera_tilebase_bank[layer] = (byte)>tilebase_address
    // [185] *(vera_tilebase_bank+vera_layer_mode_text::layer#0) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta vera_tilebase_bank+vera_layer_mode_text.layer
    // vera_tilebase_address[layer] = tilebase_address
    // [186] *(vera_tilebase_address+vera_layer_mode_text::layer#0*SIZEOF_DWORD) = vera_layer_mode_text::tilebase_address#0 -- _deref_pduc1=vduc2 
    lda #<vera_layer_mode_text.tilebase_address
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_DWORD
    lda #>vera_layer_mode_text.tilebase_address
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+1
    lda #<vera_layer_mode_text.tilebase_address>>$10
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+2
    lda #>vera_layer_mode_text.tilebase_address>>$10
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+3
    // [187] phi from vera_layer_mode_tile::@5 to vera_layer_mode_tile::@3 [phi:vera_layer_mode_tile::@5->vera_layer_mode_tile::@3]
    // vera_layer_mode_tile::@3
    // vera_layer_set_tilebase(layer,tilebase)
    // [188] call vera_layer_set_tilebase 
    jsr vera_layer_set_tilebase
    // vera_layer_mode_tile::@return
    // }
    // [189] return 
    rts
}
  // vera_layer_set_text_color_mode
/**
 * @brief Set the configuration of the layer text color mode.
 * 
 * @param layer The layer of the vera 0/1.
 * @param color_mode Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
 */
vera_layer_set_text_color_mode: {
    .label addr = $10
    // byte* addr = vera_layer_config[layer]
    // [190] vera_layer_set_text_color_mode::addr#0 = *(vera_layer_config+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr &= ~VERA_LAYER_CONFIG_256C
    // [191] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 & ~VERA_LAYER_CONFIG_256C -- _deref_pbuz1=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C^$ff
    ldy #0
    and (addr),y
    sta (addr),y
    // *addr |= color_mode
    // [192] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 -- _deref_pbuz1=_deref_pbuz1 
    lda (addr),y
    sta (addr),y
    // vera_layer_set_text_color_mode::@return
    // }
    // [193] return 
    rts
}
  // vera_layer_get_mapbase_bank
/**
 * @brief Get the map base bank of the tiles for the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_bank Bank in vera vram.
 */
vera_layer_get_mapbase_bank: {
    .label return = $a
    // return vera_mapbase_bank[layer];
    // [194] vera_layer_get_mapbase_bank::return#0 = *(vera_mapbase_bank+screenlayer::layer#0) -- vbuz1=_deref_pbuc1 
    lda vera_mapbase_bank+screenlayer.layer
    sta.z return
    // vera_layer_get_mapbase_bank::@return
    // }
    // [195] return 
    rts
}
  // vera_layer_get_mapbase_offset
/**
 * @brief Get the map base lower 16-bit address (offset) of the tiles for the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_offset Offset in vera vram of the specified bank.
 */
vera_layer_get_mapbase_offset: {
    .label return = $17
    // return vera_mapbase_offset[layer];
    // [196] vera_layer_get_mapbase_offset::return#0 = *(vera_mapbase_offset+screenlayer::layer#0*SIZEOF_WORD) -- vwuz1=_deref_pwuc1 
    lda vera_mapbase_offset+screenlayer.layer*SIZEOF_WORD
    sta.z return
    lda vera_mapbase_offset+screenlayer.layer*SIZEOF_WORD+1
    sta.z return+1
    // vera_layer_get_mapbase_offset::@return
    // }
    // [197] return 
    rts
}
  // vera_layer_get_rowshift
// Get the bit shift value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
vera_layer_get_rowshift: {
    .label return = $a
    // return vera_layer_rowshift[layer];
    // [198] vera_layer_get_rowshift::return#0 = *(vera_layer_rowshift+screenlayer::layer#0) -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift+screenlayer.layer
    sta.z return
    // vera_layer_get_rowshift::@return
    // }
    // [199] return 
    rts
}
  // vera_layer_get_rowskip
// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
vera_layer_get_rowskip: {
    .label return = $17
    // return vera_layer_rowskip[layer];
    // [200] vera_layer_get_rowskip::return#0 = *(vera_layer_rowskip+screenlayer::layer#0*SIZEOF_WORD) -- vwuz1=_deref_pwuc1 
    lda vera_layer_rowskip+screenlayer.layer*SIZEOF_WORD
    sta.z return
    lda vera_layer_rowskip+screenlayer.layer*SIZEOF_WORD+1
    sta.z return+1
    // vera_layer_get_rowskip::@return
    // }
    // [201] return 
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
// vera_layer_get_backcolor(byte zp($f) layer)
vera_layer_get_backcolor: {
    .label layer = $f
    .label return = $f
    // return vera_layer_backcolor[layer];
    // [202] vera_layer_get_backcolor::return#1 = vera_layer_backcolor[vera_layer_get_backcolor::layer#0] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_backcolor,y
    sta.z return
    // vera_layer_get_backcolor::@return
    // }
    // [203] return 
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
// vera_layer_get_textcolor(byte zp($f) layer)
vera_layer_get_textcolor: {
    .label layer = $f
    .label return = $f
    // return vera_layer_textcolor[layer];
    // [204] vera_layer_get_textcolor::return#1 = vera_layer_textcolor[vera_layer_get_textcolor::layer#0] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_textcolor,y
    sta.z return
    // vera_layer_get_textcolor::@return
    // }
    // [205] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp(6) c)
cputc: {
    .label color = $f
    .label conio_screen_text = $12
    .label conio_map_width = $14
    .label conio_addr = $12
    .label scroll_enable = $16
    .label c = 6
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [207] vera_layer_get_color::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_color.layer
    // [208] call vera_layer_get_color 
    // [274] phi from cputc to vera_layer_get_color [phi:cputc->vera_layer_get_color]
    // [274] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#0 [phi:cputc->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [209] vera_layer_get_color::return#0 = vera_layer_get_color::return#3
    // cputc::@7
    // char color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [210] cputc::color#0 = vera_layer_get_color::return#0
    // unsigned int conio_screen_text = cx16_conio.conio_screen_text
    // [211] cputc::conio_screen_text#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z conio_screen_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z conio_screen_text+1
    // word conio_map_width = cx16_conio.conio_map_width
    // [212] cputc::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [213] cputc::$15 = *((byte*)&cx16_conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta __15
    // unsigned int conio_addr = conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [214] cputc::conio_addr#0 = cputc::conio_screen_text#0 + conio_line_text[cputc::$15] -- vwuz1=vwuz1_plus_pwuc1_derefidx_vbum2 
    tay
    clc
    lda.z conio_addr
    adc conio_line_text,y
    sta.z conio_addr
    lda.z conio_addr+1
    adc conio_line_text+1,y
    sta.z conio_addr+1
    // conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [215] cputc::$2 = conio_cursor_x[*((byte*)&cx16_conio)] << 1 -- vbum1=pbuc1_derefidx_(_deref_pbuc2)_rol_1 
    ldy cx16_conio
    lda conio_cursor_x,y
    asl
    sta __2
    // conio_addr += conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [216] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$2 -- vwuz1=vwuz1_plus_vbum2 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [217] if(cputc::c#3==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [218] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <conio_addr
    // [219] cputc::$4 = < cputc::conio_addr#1 -- vbum1=_lo_vwuz2 
    lda.z conio_addr
    sta __4
    // *VERA_ADDRX_L = <conio_addr
    // [220] *VERA_ADDRX_L = cputc::$4 -- _deref_pbuc1=vbum1 
    // Set address
    sta VERA_ADDRX_L
    // >conio_addr
    // [221] cputc::$5 = > cputc::conio_addr#1 -- vbum1=_hi_vwuz2 
    lda.z conio_addr+1
    sta __5
    // *VERA_ADDRX_M = >conio_addr
    // [222] *VERA_ADDRX_M = cputc::$5 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [223] cputc::$6 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    sta __6
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [224] *VERA_ADDRX_H = cputc::$6 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [225] *VERA_DATA0 = cputc::c#3 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [226] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // conio_cursor_x[cx16_conio.conio_screen_layer]++;
    // [227] conio_cursor_x[*((byte*)&cx16_conio)] = ++ conio_cursor_x[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    ldy cx16_conio
    lda conio_cursor_x,x
    inc
    sta conio_cursor_x,y
    // byte scroll_enable = conio_scroll_enable[cx16_conio.conio_screen_layer]
    // [228] cputc::scroll_enable#0 = conio_scroll_enable[*((byte*)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_scroll_enable,y
    sta.z scroll_enable
    // if(scroll_enable)
    // [229] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuz1_then_la1 
    bne __b5
    // cputc::@3
    // (unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width
    // [230] cputc::$16 = (word)conio_cursor_x[*((byte*)&cx16_conio)] -- vwum1=_word_pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_cursor_x,y
    sta __16
    lda #0
    sta __16+1
    // if((unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width)
    // [231] if(cputc::$16!=cputc::conio_map_width#0) goto cputc::@return -- vwum1_neq_vwuz2_then_la1 
    cmp.z conio_map_width+1
    bne __breturn
    lda __16
    cmp.z conio_map_width
    bne __breturn
    // [232] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [233] call cputln 
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [234] return 
    rts
    // cputc::@5
  __b5:
    // if(conio_cursor_x[cx16_conio.conio_screen_layer] == cx16_conio.conio_screen_width)
    // [235] if(conio_cursor_x[*((byte*)&cx16_conio)]!=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto cputc::@return -- pbuc1_derefidx_(_deref_pbuc2)_neq__deref_pbuc3_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    ldy cx16_conio
    cmp conio_cursor_x,y
    bne __breturn
    // [236] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [237] call cputln 
    jsr cputln
    rts
    // [238] phi from cputc::@7 to cputc::@1 [phi:cputc::@7->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [239] call cputln 
    jsr cputln
    rts
  .segment Data
    __2: .byte 0
    __4: .byte 0
    __5: .byte 0
    __6: .byte 0
    __15: .byte 0
    __16: .word 0
}
.segment Code
  // utoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp(4) value, byte* zp($12) buffer)
utoa: {
    .const max_digits = 5
    .label digit_value = $1d
    .label buffer = $12
    .label digit = $1b
    .label value = 4
    .label started = $f
    // [241] phi from utoa to utoa::@1 [phi:utoa->utoa::@1]
    // [241] phi utoa::buffer#11 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:utoa->utoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [241] phi utoa::started#2 = 0 [phi:utoa->utoa::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z started
    // [241] phi utoa::value#2 = utoa::value#1 [phi:utoa->utoa::@1#2] -- register_copy 
    // [241] phi utoa::digit#2 = 0 [phi:utoa->utoa::@1#3] -- vbuz1=vbuc1 
    sta.z digit
    // utoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [242] if(utoa::digit#2<utoa::max_digits#1-1) goto utoa::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // utoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [243] utoa::$11 = (byte)utoa::value#2 -- vbum1=_byte_vwuz2 
    lda.z value
    sta __11
    // [244] *utoa::buffer#11 = DIGITS[utoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [245] utoa::buffer#3 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [246] *utoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // utoa::@return
    // }
    // [247] return 
    rts
    // utoa::@2
  __b2:
    // unsigned int digit_value = digit_values[digit]
    // [248] utoa::$10 = utoa::digit#2 << 1 -- vbum1=vbuz2_rol_1 
    lda.z digit
    asl
    sta __10
    // [249] utoa::digit_value#0 = RADIX_DECIMAL_VALUES[utoa::$10] -- vwuz1=pwuc1_derefidx_vbum2 
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    // [250] if(0!=utoa::started#2) goto utoa::@5 -- 0_neq_vbuz1_then_la1 
    lda.z started
    bne __b5
    // utoa::@7
    // [251] if(utoa::value#2>=utoa::digit_value#0) goto utoa::@5 -- vwuz1_ge_vwuz2_then_la1 
    lda.z digit_value+1
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b5
  !:
    bcc __b5
    // [252] phi from utoa::@7 to utoa::@4 [phi:utoa::@7->utoa::@4]
    // [252] phi utoa::buffer#14 = utoa::buffer#11 [phi:utoa::@7->utoa::@4#0] -- register_copy 
    // [252] phi utoa::started#4 = utoa::started#2 [phi:utoa::@7->utoa::@4#1] -- register_copy 
    // [252] phi utoa::value#6 = utoa::value#2 [phi:utoa::@7->utoa::@4#2] -- register_copy 
    // utoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [253] utoa::digit#1 = ++ utoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [241] phi from utoa::@4 to utoa::@1 [phi:utoa::@4->utoa::@1]
    // [241] phi utoa::buffer#11 = utoa::buffer#14 [phi:utoa::@4->utoa::@1#0] -- register_copy 
    // [241] phi utoa::started#2 = utoa::started#4 [phi:utoa::@4->utoa::@1#1] -- register_copy 
    // [241] phi utoa::value#2 = utoa::value#6 [phi:utoa::@4->utoa::@1#2] -- register_copy 
    // [241] phi utoa::digit#2 = utoa::digit#1 [phi:utoa::@4->utoa::@1#3] -- register_copy 
    jmp __b1
    // utoa::@5
  __b5:
    // utoa_append(buffer++, value, digit_value)
    // [254] utoa_append::buffer#0 = utoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z utoa_append.buffer
    lda.z buffer+1
    sta.z utoa_append.buffer+1
    // [255] utoa_append::value#0 = utoa::value#2
    // [256] utoa_append::sub#0 = utoa::digit_value#0
    // [257] call utoa_append 
    // [293] phi from utoa::@5 to utoa_append [phi:utoa::@5->utoa_append]
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // [258] utoa_append::return#0 = utoa_append::value#2
    // utoa::@6
    // value = utoa_append(buffer++, value, digit_value)
    // [259] utoa::value#0 = utoa_append::return#0
    // value = utoa_append(buffer++, value, digit_value);
    // [260] utoa::buffer#4 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [252] phi from utoa::@6 to utoa::@4 [phi:utoa::@6->utoa::@4]
    // [252] phi utoa::buffer#14 = utoa::buffer#4 [phi:utoa::@6->utoa::@4#0] -- register_copy 
    // [252] phi utoa::started#4 = 1 [phi:utoa::@6->utoa::@4#1] -- vbuz1=vbuc1 
    lda #1
    sta.z started
    // [252] phi utoa::value#6 = utoa::value#0 [phi:utoa::@6->utoa::@4#2] -- register_copy 
    jmp __b4
  .segment Data
    __10: .byte 0
    __11: .byte 0
}
.segment Code
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp(6) buffer_sign)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label buffer_sign = 6
    // printf_number_buffer::@1
    // if(buffer.sign)
    // [262] if(0==printf_number_buffer::buffer_sign#0) goto printf_number_buffer::@2 -- 0_eq_vbuz1_then_la1 
    lda.z buffer_sign
    beq __b2
    // printf_number_buffer::@3
    // cputc(buffer.sign)
    // [263] cputc::c#2 = printf_number_buffer::buffer_sign#0
    // [264] call cputc 
    // [206] phi from printf_number_buffer::@3 to cputc [phi:printf_number_buffer::@3->cputc]
    // [206] phi cputc::c#3 = cputc::c#2 [phi:printf_number_buffer::@3->cputc#0] -- register_copy 
    jsr cputc
    // [265] phi from printf_number_buffer::@1 printf_number_buffer::@3 to printf_number_buffer::@2 [phi:printf_number_buffer::@1/printf_number_buffer::@3->printf_number_buffer::@2]
    // printf_number_buffer::@2
  __b2:
    // cputs(buffer.digits)
    // [266] call cputs 
    // [157] phi from printf_number_buffer::@2 to cputs [phi:printf_number_buffer::@2->cputs]
    // [157] phi cputs::s#5 = printf_number_buffer::buffer_digits#0 [phi:printf_number_buffer::@2->cputs#0] -- pbuz1=pbuc1 
    lda #<buffer_digits
    sta.z cputs.s
    lda #>buffer_digits
    sta.z cputs.s+1
    jsr cputs
    // printf_number_buffer::@return
    // }
    // [267] return 
    rts
}
  // vera_layer_set_config
/**
 * @brief Set the configuration of the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @param config Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
 */
vera_layer_set_config: {
    .label addr = $17
    // byte* addr = vera_layer_config[layer]
    // [268] vera_layer_set_config::addr#0 = *(vera_layer_config+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr = config
    // [269] *vera_layer_set_config::addr#0 = vera_layer_mode_tile::config#10 -- _deref_pbuz1=vbuc1 
    lda #vera_layer_mode_tile.config
    ldy #0
    sta (addr),y
    // vera_layer_set_config::@return
    // }
    // [270] return 
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
vera_layer_set_tilebase: {
    .label addr = $17
    // byte* addr = vera_layer_tilebase[layer]
    // [271] vera_layer_set_tilebase::addr#0 = *(vera_layer_tilebase+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_tilebase+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_tilebase+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr = tilebase
    // [272] *vera_layer_set_tilebase::addr#0 = ><vera_layer_mode_tile::tilebase_address#0&VERA_LAYER_TILEBASE_MASK -- _deref_pbuz1=vbuc1 
    lda #(>(vera_layer_mode_tile.tilebase_address&$ffff))&VERA_LAYER_TILEBASE_MASK
    ldy #0
    sta (addr),y
    // vera_layer_set_tilebase::@return
    // }
    // [273] return 
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
// vera_layer_get_color(byte zp($f) layer)
vera_layer_get_color: {
    .label layer = $f
    .label return = $f
    .label addr = $1d
    // byte* addr = vera_layer_config[layer]
    // [275] vera_layer_get_color::$3 = vera_layer_get_color::layer#2 << 1 -- vbum1=vbuz2_rol_1 
    lda.z layer
    asl
    sta __3
    // [276] vera_layer_get_color::addr#0 = vera_layer_config[vera_layer_get_color::$3] -- pbuz1=qbuc1_derefidx_vbum2 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr & VERA_LAYER_CONFIG_256C
    // [277] vera_layer_get_color::$0 = *vera_layer_get_color::addr#0 & VERA_LAYER_CONFIG_256C -- vbum1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C
    ldy #0
    and (addr),y
    sta __0
    // if( *addr & VERA_LAYER_CONFIG_256C )
    // [278] if(0!=vera_layer_get_color::$0) goto vera_layer_get_color::@1 -- 0_neq_vbum1_then_la1 
    bne __b1
    // vera_layer_get_color::@2
    // vera_layer_backcolor[layer] << 4
    // [279] vera_layer_get_color::$1 = vera_layer_backcolor[vera_layer_get_color::layer#2] << 4 -- vbum1=pbuc1_derefidx_vbuz2_rol_4 
    ldy.z layer
    lda vera_layer_backcolor,y
    asl
    asl
    asl
    asl
    sta __1
    // return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
    // [280] vera_layer_get_color::return#2 = vera_layer_get_color::$1 | vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuz1=vbum2_bor_pbuc1_derefidx_vbuz1 
    ldy.z return
    ora vera_layer_textcolor,y
    sta.z return
    // [281] phi from vera_layer_get_color::@1 vera_layer_get_color::@2 to vera_layer_get_color::@return [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return]
    // [281] phi vera_layer_get_color::return#3 = vera_layer_get_color::return#1 [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return#0] -- register_copy 
    // vera_layer_get_color::@return
    // }
    // [282] return 
    rts
    // vera_layer_get_color::@1
  __b1:
    // return (vera_layer_textcolor[layer]);
    // [283] vera_layer_get_color::return#1 = vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_textcolor,y
    sta.z return
    rts
  .segment Data
    __0: .byte 0
    __1: .byte 0
    __3: .byte 0
}
.segment Code
  // cputln
// Print a newline
cputln: {
    .label temp = $19
    // word temp = conio_line_text[cx16_conio.conio_screen_layer]
    // [284] cputln::$2 = *((byte*)&cx16_conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta __2
    // [285] cputln::temp#0 = conio_line_text[cputln::$2] -- vwuz1=pwuc1_derefidx_vbum2 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda conio_line_text,y
    sta.z temp
    lda conio_line_text+1,y
    sta.z temp+1
    // temp += cx16_conio.conio_rowskip
    // [286] cputln::temp#1 = cputln::temp#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z temp
    sta.z temp
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z temp+1
    sta.z temp+1
    // conio_line_text[cx16_conio.conio_screen_layer] = temp
    // [287] cputln::$3 = *((byte*)&cx16_conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta __3
    // [288] conio_line_text[cputln::$3] = cputln::temp#1 -- pwuc1_derefidx_vbum1=vwuz2 
    tay
    lda.z temp
    sta conio_line_text,y
    lda.z temp+1
    sta conio_line_text+1,y
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [289] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer]++;
    // [290] conio_cursor_y[*((byte*)&cx16_conio)] = ++ conio_cursor_y[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    lda conio_cursor_y,x
    inc
    sta conio_cursor_y,y
    // cscroll()
    // [291] call cscroll 
    jsr cscroll
    // cputln::@return
    // }
    // [292] return 
    rts
  .segment Data
    __2: .byte 0
    __3: .byte 0
}
.segment Code
  // utoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zp($19) buffer, word zp(4) value, word zp($1d) sub)
utoa_append: {
    .label buffer = $19
    .label value = 4
    .label sub = $1d
    .label return = 4
    .label digit = $16
    // [294] phi from utoa_append to utoa_append::@1 [phi:utoa_append->utoa_append::@1]
    // [294] phi utoa_append::digit#2 = 0 [phi:utoa_append->utoa_append::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z digit
    // [294] phi utoa_append::value#2 = utoa_append::value#0 [phi:utoa_append->utoa_append::@1#1] -- register_copy 
    // utoa_append::@1
  __b1:
    // while (value >= sub)
    // [295] if(utoa_append::value#2>=utoa_append::sub#0) goto utoa_append::@2 -- vwuz1_ge_vwuz2_then_la1 
    lda.z sub+1
    cmp.z value+1
    bne !+
    lda.z sub
    cmp.z value
    beq __b2
  !:
    bcc __b2
    // utoa_append::@3
    // *buffer = DIGITS[digit]
    // [296] *utoa_append::buffer#0 = DIGITS[utoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuz2 
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // utoa_append::@return
    // }
    // [297] return 
    rts
    // utoa_append::@2
  __b2:
    // digit++;
    // [298] utoa_append::digit#1 = ++ utoa_append::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // value -= sub
    // [299] utoa_append::value#1 = utoa_append::value#2 - utoa_append::sub#0 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    // [294] phi from utoa_append::@2 to utoa_append::@1 [phi:utoa_append::@2->utoa_append::@1]
    // [294] phi utoa_append::digit#2 = utoa_append::digit#1 [phi:utoa_append::@2->utoa_append::@1#0] -- register_copy 
    // [294] phi utoa_append::value#2 = utoa_append::value#1 [phi:utoa_append::@2->utoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [300] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    ldy cx16_conio
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b3
    // cscroll::@1
    // if(conio_scroll_enable[cx16_conio.conio_screen_layer])
    // [301] if(0!=conio_scroll_enable[*((byte*)&cx16_conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    lda conio_scroll_enable,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [302] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    // [303] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
  __b3:
    // cscroll::@return
    // }
    // [304] return 
    rts
    // [305] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [306] call insertup 
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, cx16_conio.conio_screen_height-1)
    // [307] gotoxy::y#2 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    stx.z gotoxy.y
    // [308] call gotoxy 
    // [104] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [104] phi gotoxy::y#4 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    jsr gotoxy
    // [309] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [310] call clearline 
    jsr clearline
    rts
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label cy = $1b
    .label width = $1c
    .label line = $1d
    .label start = $1d
    .label i = $16
    // unsigned byte cy = conio_cursor_y[cx16_conio.conio_screen_layer]
    // [311] insertup::cy#0 = conio_cursor_y[*((byte*)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy cx16_conio
    lda conio_cursor_y,y
    sta.z cy
    // unsigned byte width = cx16_conio.conio_screen_width * 2
    // [312] insertup::width#0 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    asl
    sta.z width
    // [313] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [313] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z i
    // insertup::@1
  __b1:
    // for(unsigned byte i=1; i<=cy; i++)
    // [314] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuz1_le_vbuz2_then_la1 
    lda.z cy
    cmp.z i
    bcs __b2
    // [315] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [316] call clearline 
    jsr clearline
    // insertup::@return
    // }
    // [317] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [318] insertup::$3 = insertup::i#2 - 1 -- vbum1=vbuz2_minus_1 
    ldx.z i
    dex
    stx __3
    // unsigned int line = (i-1) << cx16_conio.conio_rowshift
    // [319] insertup::line#0 = insertup::$3 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vbum2_rol__deref_pbuc1 
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
    // [320] insertup::start#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) + insertup::line#0 -- vwuz1=_deref_pwuc1_plus_vwuz1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    adc.z start
    sta.z start
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    adc.z start+1
    sta.z start+1
    // cx16_cpy_vram_from_vram_inc(0, start, VERA_INC_1, 0, start+cx16_conio.conio_rowskip, VERA_INC_1, width)
    // [321] cx16_cpy_vram_from_vram_inc::soffset_vram#0 = insertup::start#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz2_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z start
    sta.z cx16_cpy_vram_from_vram_inc.soffset_vram
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z start+1
    sta.z cx16_cpy_vram_from_vram_inc.soffset_vram+1
    // [322] cx16_cpy_vram_from_vram_inc::doffset_vram#0 = insertup::start#0
    // [323] cx16_cpy_vram_from_vram_inc::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z cx16_cpy_vram_from_vram_inc.num
    lda #0
    sta.z cx16_cpy_vram_from_vram_inc.num+1
    // [324] call cx16_cpy_vram_from_vram_inc 
    // [347] phi from insertup::@2 to cx16_cpy_vram_from_vram_inc [phi:insertup::@2->cx16_cpy_vram_from_vram_inc]
    jsr cx16_cpy_vram_from_vram_inc
    // insertup::@4
    // for(unsigned byte i=1; i<=cy; i++)
    // [325] insertup::i#1 = ++ insertup::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [313] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [313] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    __3: .byte 0
}
.segment Code
  // clearline
clearline: {
    .label conio_screen_text = $1f
    .label conio_line = $21
    .label addr = $1f
    .label color = $f
    .label c = $12
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [326] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // word conio_screen_text =  (word)cx16_conio.conio_screen_text
    // [327] clearline::conio_screen_text#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- vwuz1=_deref_pwuc1 
    // Set address
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z conio_screen_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z conio_screen_text+1
    // word conio_line = conio_line_text[cx16_conio.conio_screen_layer]
    // [328] clearline::$5 = *((byte*)&cx16_conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta __5
    // [329] clearline::conio_line#0 = conio_line_text[clearline::$5] -- vwuz1=pwuc1_derefidx_vbum2 
    tay
    lda conio_line_text,y
    sta.z conio_line
    lda conio_line_text+1,y
    sta.z conio_line+1
    // conio_screen_text + conio_line
    // [330] clearline::addr#0 = clearline::conio_screen_text#0 + clearline::conio_line#0 -- vwuz1=vwuz1_plus_vwuz2 
    lda.z addr
    clc
    adc.z conio_line
    sta.z addr
    lda.z addr+1
    adc.z conio_line+1
    sta.z addr+1
    // <addr
    // [331] clearline::$1 = < (byte*)clearline::addr#0 -- vbum1=_lo_pbuz2 
    lda.z addr
    sta __1
    // *VERA_ADDRX_L = <addr
    // [332] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // >addr
    // [333] clearline::$2 = > (byte*)clearline::addr#0 -- vbum1=_hi_pbuz2 
    lda.z addr+1
    sta __2
    // *VERA_ADDRX_M = >addr
    // [334] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [335] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [336] vera_layer_get_color::layer#1 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_color.layer
    // [337] call vera_layer_get_color 
    // [274] phi from clearline to vera_layer_get_color [phi:clearline->vera_layer_get_color]
    // [274] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#1 [phi:clearline->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [338] vera_layer_get_color::return#4 = vera_layer_get_color::return#3
    // clearline::@4
    // char color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [339] clearline::color#0 = vera_layer_get_color::return#4
    // [340] phi from clearline::@4 to clearline::@1 [phi:clearline::@4->clearline::@1]
    // [340] phi clearline::c#2 = 0 [phi:clearline::@4->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [341] if(clearline::c#2<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto clearline::@2 -- vwuz1_lt__deref_pbuc1_then_la1 
    ldy cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    lda.z c+1
    bne !+
    sty.z $ff
    lda.z c
    cmp.z $ff
    bcc __b2
  !:
    // clearline::@3
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [342] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // clearline::@return
    // }
    // [343] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [344] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [345] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [346] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [340] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [340] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    __1: .byte 0
    __2: .byte 0
    __5: .byte 0
}
.segment Code
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
// cx16_cpy_vram_from_vram_inc(word zp($1d) doffset_vram, word zp($1f) soffset_vram, word zp($21) num)
cx16_cpy_vram_from_vram_inc: {
    .label i = $12
    .label doffset_vram = $1d
    .label soffset_vram = $1f
    .label num = $21
    // cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [348] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [349] cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$0 = < cx16_cpy_vram_from_vram_inc::soffset_vram#0 -- vbum1=_byte0_vwuz2 
    lda.z soffset_vram
    sta vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [350] *VERA_ADDRX_L = cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [351] cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$1 = > cx16_cpy_vram_from_vram_inc::soffset_vram#0 -- vbum1=_byte1_vwuz2 
    lda.z soffset_vram+1
    sta vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [352] *VERA_ADDRX_M = cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [353] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1
    // *VERA_CTRL |= VERA_ADDRSEL
    // [354] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [355] cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$0 = < cx16_cpy_vram_from_vram_inc::doffset_vram#0 -- vbum1=_byte0_vwuz2 
    lda.z doffset_vram
    sta vera_vram_data1_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [356] *VERA_ADDRX_L = cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [357] cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$1 = > cx16_cpy_vram_from_vram_inc::doffset_vram#0 -- vbum1=_byte1_vwuz2 
    lda.z doffset_vram+1
    sta vera_vram_data1_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [358] *VERA_ADDRX_M = cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [359] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // [360] phi from cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1 to cx16_cpy_vram_from_vram_inc::@1 [phi:cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1->cx16_cpy_vram_from_vram_inc::@1]
    // [360] phi cx16_cpy_vram_from_vram_inc::i#2 = 0 [phi:cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1->cx16_cpy_vram_from_vram_inc::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // cx16_cpy_vram_from_vram_inc::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [361] if(cx16_cpy_vram_from_vram_inc::i#2<cx16_cpy_vram_from_vram_inc::num#0) goto cx16_cpy_vram_from_vram_inc::@2 -- vwuz1_lt_vwuz2_then_la1 
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
    // [362] return 
    rts
    // cx16_cpy_vram_from_vram_inc::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [363] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [364] cx16_cpy_vram_from_vram_inc::i#1 = ++ cx16_cpy_vram_from_vram_inc::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [360] phi from cx16_cpy_vram_from_vram_inc::@2 to cx16_cpy_vram_from_vram_inc::@1 [phi:cx16_cpy_vram_from_vram_inc::@2->cx16_cpy_vram_from_vram_inc::@1]
    // [360] phi cx16_cpy_vram_from_vram_inc::i#2 = cx16_cpy_vram_from_vram_inc::i#1 [phi:cx16_cpy_vram_from_vram_inc::@2->cx16_cpy_vram_from_vram_inc::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    vera_vram_data0_bank_offset1___0: .byte 0
    vera_vram_data0_bank_offset1___1: .byte 0
    vera_vram_data1_bank_offset1___0: .byte 0
    vera_vram_data1_bank_offset1___1: .byte 0
}
  // File Data
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
  vera_layer_config: .word VERA_L0_CONFIG, VERA_L1_CONFIG
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
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  cx16_conio: .fill SIZEOF_STRUCT_CX16_CONIO, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
  sa: .fill SIZEOF_STRUCT_A, 0
  sb: .fill SIZEOF_STRUCT_B, 0
