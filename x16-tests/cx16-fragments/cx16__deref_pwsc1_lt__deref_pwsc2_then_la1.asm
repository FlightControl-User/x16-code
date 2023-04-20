  // File Comments
// Provides provide console input/output
// Implements similar functions as conio.h from CC65 for compatibility
// See https://github.com/cc65/cc65/blob/master/include/conio.h
//
// Currently CX16/C64/PLUS4/VIC20 platforms are supported
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="cx16__deref_pwsc1_lt__deref_pwsc2_then_la1.prg", type="prg", segments="Program"]
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
  .const SIZEOF_STRUCT_CX16_CONIO = $e
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .const SIZEOF_STRUCT_A = 2
  .const SIZEOF_STRUCT_B = 2
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
    // [394] phi from conio_x16_init to vera_layer_mode_text [phi:conio_x16_init->vera_layer_mode_text]
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
    // [440] phi from conio_x16_init::@7 to vera_layer_set_mapbase [phi:conio_x16_init::@7->vera_layer_set_mapbase]
    // [440] phi vera_layer_set_mapbase::mapbase#3 = $20 [phi:conio_x16_init::@7->vera_layer_set_mapbase#0] -- vbuz1=vbuc1 
    lda #$20
    sta.z vera_layer_set_mapbase.mapbase
    // [440] phi vera_layer_set_mapbase::layer#3 = 0 [phi:conio_x16_init::@7->vera_layer_set_mapbase#1] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_set_mapbase.layer
    jsr vera_layer_set_mapbase
    // [18] phi from conio_x16_init::@7 to conio_x16_init::@8 [phi:conio_x16_init::@7->conio_x16_init::@8]
    // conio_x16_init::@8
    // vera_layer_set_mapbase(1,0x00)
    // [19] call vera_layer_set_mapbase 
    // [440] phi from conio_x16_init::@8 to vera_layer_set_mapbase [phi:conio_x16_init::@8->vera_layer_set_mapbase]
    // [440] phi vera_layer_set_mapbase::mapbase#3 = 0 [phi:conio_x16_init::@8->vera_layer_set_mapbase#0] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_set_mapbase.mapbase
    // [440] phi vera_layer_set_mapbase::layer#3 = 1 [phi:conio_x16_init::@8->vera_layer_set_mapbase#1] -- vbuz1=vbuc1 
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
    // [447] phi from conio_x16_init::@1 to gotoxy [phi:conio_x16_init::@1->gotoxy]
    // [447] phi gotoxy::y#4 = gotoxy::y#1 [phi:conio_x16_init::@1->gotoxy#0] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [27] return 
    rts
}
  // main
main: {
    // clrscr()
    // [29] call clrscr 
    jsr clrscr
    // [30] phi from main to main::@57 [phi:main->main::@57]
    // main::@57
    // gotoxy(0,30)
    // [31] call gotoxy 
    // [447] phi from main::@57 to gotoxy [phi:main::@57->gotoxy]
    // [447] phi gotoxy::y#4 = $1e [phi:main::@57->gotoxy#0] -- vbuz1=vbuc1 
    lda #$1e
    sta.z gotoxy.y
    jsr gotoxy
    // main::@58
    // sa.a = -19000
    // [32] *((signed word*)&sa) = -$4a38 -- _deref_pwsc1=vwsc2 
    lda #<-$4a38
    sta sa
    lda #>-$4a38
    sta sa+1
    // sb.b = -19000
    // [33] *((signed word*)&sb) = -$4a38 -- _deref_pwsc1=vwsc2 
    lda #<-$4a38
    sta sb
    lda #>-$4a38
    sta sb+1
    // if(sa.a < sb.b)
    // [34] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@1 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b1+
    jmp __b1
  !__b1:
    // main::@38
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [35] printf_sint::value#3 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [36] call printf_sint 
    // [494] phi from main::@38 to printf_sint [phi:main::@38->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#3 [phi:main::@38->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [37] phi from main::@38 to main::@62 [phi:main::@38->main::@62]
    // main::@62
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [38] call cputs 
    // [505] phi from main::@62 to cputs [phi:main::@62->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@62->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@63
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [39] printf_sint::value#4 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [40] call printf_sint 
    // [494] phi from main::@63 to printf_sint [phi:main::@63->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#4 [phi:main::@63->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [41] phi from main::@63 to main::@64 [phi:main::@63->main::@64]
    // main::@64
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [42] call cputs 
    // [505] phi from main::@64 to cputs [phi:main::@64->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@64->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@2
  __b2:
    // sa.a = -19001
    // [43] *((signed word*)&sa) = -$4a39 -- _deref_pwsc1=vwsc2 
    lda #<-$4a39
    sta sa
    lda #>-$4a39
    sta sa+1
    // sb.b = -19000
    // [44] *((signed word*)&sb) = -$4a38 -- _deref_pwsc1=vwsc2 
    lda #<-$4a38
    sta sb
    lda #>-$4a38
    sta sb+1
    // if(sa.a < sb.b)
    // [45] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@3 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b3+
    jmp __b3
  !__b3:
    // main::@39
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [46] printf_sint::value#7 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [47] call printf_sint 
    // [494] phi from main::@39 to printf_sint [phi:main::@39->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#7 [phi:main::@39->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [48] phi from main::@39 to main::@68 [phi:main::@39->main::@68]
    // main::@68
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [49] call cputs 
    // [505] phi from main::@68 to cputs [phi:main::@68->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@68->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@69
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [50] printf_sint::value#8 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [51] call printf_sint 
    // [494] phi from main::@69 to printf_sint [phi:main::@69->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#8 [phi:main::@69->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [52] phi from main::@69 to main::@70 [phi:main::@69->main::@70]
    // main::@70
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [53] call cputs 
    // [505] phi from main::@70 to cputs [phi:main::@70->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@70->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@4
  __b4:
    // sa.a = -18999
    // [54] *((signed word*)&sa) = -$4a37 -- _deref_pwsc1=vwsc2 
    lda #<-$4a37
    sta sa
    lda #>-$4a37
    sta sa+1
    // sb.b = -19000
    // [55] *((signed word*)&sb) = -$4a38 -- _deref_pwsc1=vwsc2 
    lda #<-$4a38
    sta sb
    lda #>-$4a38
    sta sb+1
    // if(sa.a < sb.b)
    // [56] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@5 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b5+
    jmp __b5
  !__b5:
    // main::@40
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [57] printf_sint::value#11 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [58] call printf_sint 
    // [494] phi from main::@40 to printf_sint [phi:main::@40->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#11 [phi:main::@40->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [59] phi from main::@40 to main::@74 [phi:main::@40->main::@74]
    // main::@74
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [60] call cputs 
    // [505] phi from main::@74 to cputs [phi:main::@74->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@74->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@75
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [61] printf_sint::value#12 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [62] call printf_sint 
    // [494] phi from main::@75 to printf_sint [phi:main::@75->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#12 [phi:main::@75->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [63] phi from main::@75 to main::@76 [phi:main::@75->main::@76]
    // main::@76
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [64] call cputs 
    // [505] phi from main::@76 to cputs [phi:main::@76->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@76->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@6
  __b6:
    // sa.a = -1
    // [65] *((signed word*)&sa) = -1 -- _deref_pwsc1=vwsc2 
    lda #<-1
    sta sa
    sta sa+1
    // sb.b = -2
    // [66] *((signed word*)&sb) = -2 -- _deref_pwsc1=vwsc2 
    lda #<-2
    sta sb
    lda #>-2
    sta sb+1
    // if(sa.a < sb.b)
    // [67] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@7 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b7+
    jmp __b7
  !__b7:
    // main::@41
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [68] printf_sint::value#15 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [69] call printf_sint 
    // [494] phi from main::@41 to printf_sint [phi:main::@41->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#15 [phi:main::@41->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [70] phi from main::@41 to main::@80 [phi:main::@41->main::@80]
    // main::@80
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [71] call cputs 
    // [505] phi from main::@80 to cputs [phi:main::@80->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@80->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@81
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [72] printf_sint::value#16 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [73] call printf_sint 
    // [494] phi from main::@81 to printf_sint [phi:main::@81->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#16 [phi:main::@81->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [74] phi from main::@81 to main::@82 [phi:main::@81->main::@82]
    // main::@82
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [75] call cputs 
    // [505] phi from main::@82 to cputs [phi:main::@82->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@82->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@8
  __b8:
    // sa.a = -2
    // [76] *((signed word*)&sa) = -2 -- _deref_pwsc1=vwsc2 
    lda #<-2
    sta sa
    lda #>-2
    sta sa+1
    // sb.b = -1
    // [77] *((signed word*)&sb) = -1 -- _deref_pwsc1=vwsc2 
    sta sb
    sta sb+1
    // if(sa.a < sb.b)
    // [78] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@9 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b9+
    jmp __b9
  !__b9:
    // main::@42
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [79] printf_sint::value#19 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [80] call printf_sint 
    // [494] phi from main::@42 to printf_sint [phi:main::@42->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#19 [phi:main::@42->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [81] phi from main::@42 to main::@86 [phi:main::@42->main::@86]
    // main::@86
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [82] call cputs 
    // [505] phi from main::@86 to cputs [phi:main::@86->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@86->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@87
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [83] printf_sint::value#20 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [84] call printf_sint 
    // [494] phi from main::@87 to printf_sint [phi:main::@87->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#20 [phi:main::@87->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [85] phi from main::@87 to main::@88 [phi:main::@87->main::@88]
    // main::@88
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [86] call cputs 
    // [505] phi from main::@88 to cputs [phi:main::@88->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@88->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@10
  __b10:
    // sa.a = -1
    // [87] *((signed word*)&sa) = -1 -- _deref_pwsc1=vwsc2 
    lda #<-1
    sta sa
    sta sa+1
    // sb.b = -1
    // [88] *((signed word*)&sb) = -1 -- _deref_pwsc1=vwsc2 
    sta sb
    sta sb+1
    // if(sa.a < sb.b)
    // [89] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@11 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b11+
    jmp __b11
  !__b11:
    // main::@43
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [90] printf_sint::value#23 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [91] call printf_sint 
    // [494] phi from main::@43 to printf_sint [phi:main::@43->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#23 [phi:main::@43->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [92] phi from main::@43 to main::@92 [phi:main::@43->main::@92]
    // main::@92
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [93] call cputs 
    // [505] phi from main::@92 to cputs [phi:main::@92->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@92->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@93
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [94] printf_sint::value#24 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [95] call printf_sint 
    // [494] phi from main::@93 to printf_sint [phi:main::@93->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#24 [phi:main::@93->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [96] phi from main::@93 to main::@94 [phi:main::@93->main::@94]
    // main::@94
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [97] call cputs 
    // [505] phi from main::@94 to cputs [phi:main::@94->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@94->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@12
  __b12:
    // sa.a = 0
    // [98] *((signed word*)&sa) = 0 -- _deref_pwsc1=vwsc2 
    lda #<0
    sta sa
    sta sa+1
    // sb.b = -1
    // [99] *((signed word*)&sb) = -1 -- _deref_pwsc1=vwsc2 
    lda #<-1
    sta sb
    sta sb+1
    // if(sa.a < sb.b)
    // [100] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@13 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b13+
    jmp __b13
  !__b13:
    // main::@44
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [101] printf_sint::value#27 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [102] call printf_sint 
    // [494] phi from main::@44 to printf_sint [phi:main::@44->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#27 [phi:main::@44->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [103] phi from main::@44 to main::@98 [phi:main::@44->main::@98]
    // main::@98
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [104] call cputs 
    // [505] phi from main::@98 to cputs [phi:main::@98->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@98->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@99
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [105] printf_sint::value#28 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [106] call printf_sint 
    // [494] phi from main::@99 to printf_sint [phi:main::@99->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#28 [phi:main::@99->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [107] phi from main::@99 to main::@100 [phi:main::@99->main::@100]
    // main::@100
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [108] call cputs 
    // [505] phi from main::@100 to cputs [phi:main::@100->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@100->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@14
  __b14:
    // sa.a = 0
    // [109] *((signed word*)&sa) = 0 -- _deref_pwsc1=vwsc2 
    lda #<0
    sta sa
    sta sa+1
    // sb.b = 0
    // [110] *((signed word*)&sb) = 0 -- _deref_pwsc1=vwsc2 
    sta sb
    sta sb+1
    // if(sa.a < sb.b)
    // [111] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@15 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b15+
    jmp __b15
  !__b15:
    // main::@45
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [112] printf_sint::value#31 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [113] call printf_sint 
    // [494] phi from main::@45 to printf_sint [phi:main::@45->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#31 [phi:main::@45->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [114] phi from main::@45 to main::@104 [phi:main::@45->main::@104]
    // main::@104
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [115] call cputs 
    // [505] phi from main::@104 to cputs [phi:main::@104->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@104->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@105
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [116] printf_sint::value#32 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [117] call printf_sint 
    // [494] phi from main::@105 to printf_sint [phi:main::@105->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#32 [phi:main::@105->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [118] phi from main::@105 to main::@106 [phi:main::@105->main::@106]
    // main::@106
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [119] call cputs 
    // [505] phi from main::@106 to cputs [phi:main::@106->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@106->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@16
  __b16:
    // sa.a = -1
    // [120] *((signed word*)&sa) = -1 -- _deref_pwsc1=vwsc2 
    lda #<-1
    sta sa
    sta sa+1
    // sb.b = 0
    // [121] *((signed word*)&sb) = 0 -- _deref_pwsc1=vwsc2 
    lda #<0
    sta sb
    sta sb+1
    // if(sa.a < sb.b)
    // [122] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@17 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b17+
    jmp __b17
  !__b17:
    // main::@46
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [123] printf_sint::value#35 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [124] call printf_sint 
    // [494] phi from main::@46 to printf_sint [phi:main::@46->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#35 [phi:main::@46->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [125] phi from main::@46 to main::@110 [phi:main::@46->main::@110]
    // main::@110
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [126] call cputs 
    // [505] phi from main::@110 to cputs [phi:main::@110->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@110->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@111
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [127] printf_sint::value#36 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [128] call printf_sint 
    // [494] phi from main::@111 to printf_sint [phi:main::@111->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#36 [phi:main::@111->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [129] phi from main::@111 to main::@112 [phi:main::@111->main::@112]
    // main::@112
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [130] call cputs 
    // [505] phi from main::@112 to cputs [phi:main::@112->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@112->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@18
  __b18:
    // sa.a = -1
    // [131] *((signed word*)&sa) = -1 -- _deref_pwsc1=vwsc2 
    lda #<-1
    sta sa
    sta sa+1
    // sb.b = 0
    // [132] *((signed word*)&sb) = 0 -- _deref_pwsc1=vwsc2 
    lda #<0
    sta sb
    sta sb+1
    // if(sa.a < sb.b)
    // [133] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@19 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b19+
    jmp __b19
  !__b19:
    // main::@47
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [134] printf_sint::value#39 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [135] call printf_sint 
    // [494] phi from main::@47 to printf_sint [phi:main::@47->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#39 [phi:main::@47->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [136] phi from main::@47 to main::@116 [phi:main::@47->main::@116]
    // main::@116
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [137] call cputs 
    // [505] phi from main::@116 to cputs [phi:main::@116->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@116->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@117
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [138] printf_sint::value#40 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [139] call printf_sint 
    // [494] phi from main::@117 to printf_sint [phi:main::@117->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#40 [phi:main::@117->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [140] phi from main::@117 to main::@118 [phi:main::@117->main::@118]
    // main::@118
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [141] call cputs 
    // [505] phi from main::@118 to cputs [phi:main::@118->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@118->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@20
  __b20:
    // sa.a = 1
    // [142] *((signed word*)&sa) = 1 -- _deref_pwsc1=vwsc2 
    lda #<1
    sta sa
    lda #>1
    sta sa+1
    // sb.b = 2
    // [143] *((signed word*)&sb) = 2 -- _deref_pwsc1=vwsc2 
    lda #<2
    sta sb
    lda #>2
    sta sb+1
    // if(sa.a < sb.b)
    // [144] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@21 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b21+
    jmp __b21
  !__b21:
    // main::@48
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [145] printf_sint::value#43 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [146] call printf_sint 
    // [494] phi from main::@48 to printf_sint [phi:main::@48->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#43 [phi:main::@48->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [147] phi from main::@48 to main::@122 [phi:main::@48->main::@122]
    // main::@122
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [148] call cputs 
    // [505] phi from main::@122 to cputs [phi:main::@122->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@122->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@123
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [149] printf_sint::value#44 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [150] call printf_sint 
    // [494] phi from main::@123 to printf_sint [phi:main::@123->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#44 [phi:main::@123->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [151] phi from main::@123 to main::@124 [phi:main::@123->main::@124]
    // main::@124
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [152] call cputs 
    // [505] phi from main::@124 to cputs [phi:main::@124->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@124->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@22
  __b22:
    // sa.a = 2
    // [153] *((signed word*)&sa) = 2 -- _deref_pwsc1=vwsc2 
    lda #<2
    sta sa
    lda #>2
    sta sa+1
    // sb.b = 2
    // [154] *((signed word*)&sb) = 2 -- _deref_pwsc1=vwsc2 
    lda #<2
    sta sb
    lda #>2
    sta sb+1
    // if(sa.a < sb.b)
    // [155] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@23 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b23+
    jmp __b23
  !__b23:
    // main::@49
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [156] printf_sint::value#47 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [157] call printf_sint 
    // [494] phi from main::@49 to printf_sint [phi:main::@49->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#47 [phi:main::@49->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [158] phi from main::@49 to main::@128 [phi:main::@49->main::@128]
    // main::@128
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [159] call cputs 
    // [505] phi from main::@128 to cputs [phi:main::@128->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@128->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@129
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [160] printf_sint::value#48 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [161] call printf_sint 
    // [494] phi from main::@129 to printf_sint [phi:main::@129->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#48 [phi:main::@129->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [162] phi from main::@129 to main::@130 [phi:main::@129->main::@130]
    // main::@130
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [163] call cputs 
    // [505] phi from main::@130 to cputs [phi:main::@130->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@130->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@24
  __b24:
    // sa.a = 2
    // [164] *((signed word*)&sa) = 2 -- _deref_pwsc1=vwsc2 
    lda #<2
    sta sa
    lda #>2
    sta sa+1
    // sb.b = 2
    // [165] *((signed word*)&sb) = 2 -- _deref_pwsc1=vwsc2 
    lda #<2
    sta sb
    lda #>2
    sta sb+1
    // if(sa.a < sb.b)
    // [166] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@25 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b25+
    jmp __b25
  !__b25:
    // main::@50
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [167] printf_sint::value#51 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [168] call printf_sint 
    // [494] phi from main::@50 to printf_sint [phi:main::@50->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#51 [phi:main::@50->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [169] phi from main::@50 to main::@134 [phi:main::@50->main::@134]
    // main::@134
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [170] call cputs 
    // [505] phi from main::@134 to cputs [phi:main::@134->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@134->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@135
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [171] printf_sint::value#52 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [172] call printf_sint 
    // [494] phi from main::@135 to printf_sint [phi:main::@135->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#52 [phi:main::@135->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [173] phi from main::@135 to main::@136 [phi:main::@135->main::@136]
    // main::@136
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [174] call cputs 
    // [505] phi from main::@136 to cputs [phi:main::@136->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@136->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@26
  __b26:
    // sa.a = 10000
    // [175] *((signed word*)&sa) = $2710 -- _deref_pwsc1=vwsc2 
    lda #<$2710
    sta sa
    lda #>$2710
    sta sa+1
    // sb.b = 20000
    // [176] *((signed word*)&sb) = $4e20 -- _deref_pwsc1=vwsc2 
    lda #<$4e20
    sta sb
    lda #>$4e20
    sta sb+1
    // if(sa.a < sb.b)
    // [177] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@27 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b27+
    jmp __b27
  !__b27:
    // main::@51
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [178] printf_sint::value#55 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [179] call printf_sint 
    // [494] phi from main::@51 to printf_sint [phi:main::@51->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#55 [phi:main::@51->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [180] phi from main::@51 to main::@140 [phi:main::@51->main::@140]
    // main::@140
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [181] call cputs 
    // [505] phi from main::@140 to cputs [phi:main::@140->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@140->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@141
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [182] printf_sint::value#56 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [183] call printf_sint 
    // [494] phi from main::@141 to printf_sint [phi:main::@141->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#56 [phi:main::@141->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [184] phi from main::@141 to main::@142 [phi:main::@141->main::@142]
    // main::@142
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [185] call cputs 
    // [505] phi from main::@142 to cputs [phi:main::@142->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@142->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@28
  __b28:
    // sa.a = 20000
    // [186] *((signed word*)&sa) = $4e20 -- _deref_pwsc1=vwsc2 
    lda #<$4e20
    sta sa
    lda #>$4e20
    sta sa+1
    // sb.b = 10000
    // [187] *((signed word*)&sb) = $2710 -- _deref_pwsc1=vwsc2 
    lda #<$2710
    sta sb
    lda #>$2710
    sta sb+1
    // if(sa.a < sb.b)
    // [188] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@29 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b29+
    jmp __b29
  !__b29:
    // main::@52
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [189] printf_sint::value#59 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [190] call printf_sint 
    // [494] phi from main::@52 to printf_sint [phi:main::@52->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#59 [phi:main::@52->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [191] phi from main::@52 to main::@146 [phi:main::@52->main::@146]
    // main::@146
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [192] call cputs 
    // [505] phi from main::@146 to cputs [phi:main::@146->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@146->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@147
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [193] printf_sint::value#60 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [194] call printf_sint 
    // [494] phi from main::@147 to printf_sint [phi:main::@147->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#60 [phi:main::@147->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [195] phi from main::@147 to main::@148 [phi:main::@147->main::@148]
    // main::@148
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [196] call cputs 
    // [505] phi from main::@148 to cputs [phi:main::@148->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@148->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@30
  __b30:
    // sa.a = 20000
    // [197] *((signed word*)&sa) = $4e20 -- _deref_pwsc1=vwsc2 
    lda #<$4e20
    sta sa
    lda #>$4e20
    sta sa+1
    // sb.b = 20000
    // [198] *((signed word*)&sb) = $4e20 -- _deref_pwsc1=vwsc2 
    lda #<$4e20
    sta sb
    lda #>$4e20
    sta sb+1
    // if(sa.a < sb.b)
    // [199] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@31 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b31+
    jmp __b31
  !__b31:
    // main::@53
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [200] printf_sint::value#63 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [201] call printf_sint 
    // [494] phi from main::@53 to printf_sint [phi:main::@53->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#63 [phi:main::@53->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [202] phi from main::@53 to main::@152 [phi:main::@53->main::@152]
    // main::@152
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [203] call cputs 
    // [505] phi from main::@152 to cputs [phi:main::@152->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@152->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@153
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [204] printf_sint::value#64 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [205] call printf_sint 
    // [494] phi from main::@153 to printf_sint [phi:main::@153->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#64 [phi:main::@153->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [206] phi from main::@153 to main::@154 [phi:main::@153->main::@154]
    // main::@154
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [207] call cputs 
    // [505] phi from main::@154 to cputs [phi:main::@154->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@154->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@32
  __b32:
    // sa.a = -10000
    // [208] *((signed word*)&sa) = -$2710 -- _deref_pwsc1=vwsc2 
    lda #<-$2710
    sta sa
    lda #>-$2710
    sta sa+1
    // sb.b = 20000
    // [209] *((signed word*)&sb) = $4e20 -- _deref_pwsc1=vwsc2 
    lda #<$4e20
    sta sb
    lda #>$4e20
    sta sb+1
    // if(sa.a < sb.b)
    // [210] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@33 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b33+
    jmp __b33
  !__b33:
    // main::@54
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [211] printf_sint::value#67 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [212] call printf_sint 
    // [494] phi from main::@54 to printf_sint [phi:main::@54->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#67 [phi:main::@54->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [213] phi from main::@54 to main::@158 [phi:main::@54->main::@158]
    // main::@158
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [214] call cputs 
    // [505] phi from main::@158 to cputs [phi:main::@158->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@158->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@159
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [215] printf_sint::value#68 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [216] call printf_sint 
    // [494] phi from main::@159 to printf_sint [phi:main::@159->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#68 [phi:main::@159->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [217] phi from main::@159 to main::@160 [phi:main::@159->main::@160]
    // main::@160
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [218] call cputs 
    // [505] phi from main::@160 to cputs [phi:main::@160->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@160->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@34
  __b34:
    // sa.a = -20000
    // [219] *((signed word*)&sa) = -$4e20 -- _deref_pwsc1=vwsc2 
    lda #<-$4e20
    sta sa
    lda #>-$4e20
    sta sa+1
    // sb.b = 20000
    // [220] *((signed word*)&sb) = $4e20 -- _deref_pwsc1=vwsc2 
    lda #<$4e20
    sta sb
    lda #>$4e20
    sta sb+1
    // if(sa.a < sb.b)
    // [221] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@35 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bpl !__b35+
    jmp __b35
  !__b35:
    // main::@55
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [222] printf_sint::value#71 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [223] call printf_sint 
    // [494] phi from main::@55 to printf_sint [phi:main::@55->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#71 [phi:main::@55->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [224] phi from main::@55 to main::@164 [phi:main::@55->main::@164]
    // main::@164
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [225] call cputs 
    // [505] phi from main::@164 to cputs [phi:main::@164->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@164->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@165
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [226] printf_sint::value#72 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [227] call printf_sint 
    // [494] phi from main::@165 to printf_sint [phi:main::@165->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#72 [phi:main::@165->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [228] phi from main::@165 to main::@166 [phi:main::@165->main::@166]
    // main::@166
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [229] call cputs 
    // [505] phi from main::@166 to cputs [phi:main::@166->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@166->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@36
  __b36:
    // sa.a = 20000
    // [230] *((signed word*)&sa) = $4e20 -- _deref_pwsc1=vwsc2 
    lda #<$4e20
    sta sa
    lda #>$4e20
    sta sa+1
    // sb.b = -20000
    // [231] *((signed word*)&sb) = -$4e20 -- _deref_pwsc1=vwsc2 
    lda #<-$4e20
    sta sb
    lda #>-$4e20
    sta sb+1
    // if(sa.a < sb.b)
    // [232] if(*((signed word*)&sa)<*((signed word*)&sb)) goto main::@37 -- _deref_pwsc1_lt__deref_pwsc2_then_la1 
    lda sa
    cmp sb
    lda sa+1
    sbc sb+1
    bvc !+
    eor #$80
  !:
    bmi __b37
    // main::@56
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [233] printf_sint::value#75 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [234] call printf_sint 
    // [494] phi from main::@56 to printf_sint [phi:main::@56->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#75 [phi:main::@56->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [235] phi from main::@56 to main::@170 [phi:main::@56->main::@170]
    // main::@170
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [236] call cputs 
    // [505] phi from main::@170 to cputs [phi:main::@170->cputs]
    // [505] phi cputs::s#79 = main::s2 [phi:main::@170->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@171
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [237] printf_sint::value#76 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [238] call printf_sint 
    // [494] phi from main::@171 to printf_sint [phi:main::@171->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#76 [phi:main::@171->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [239] phi from main::@171 to main::@172 [phi:main::@171->main::@172]
    // main::@172
    // printf("%i not < than %i\n", sa.a, sb.b)
    // [240] call cputs 
    // [505] phi from main::@172 to cputs [phi:main::@172->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@172->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@return
    // }
    // [241] return 
    rts
    // main::@37
  __b37:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [242] printf_sint::value#73 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [243] call printf_sint 
    // [494] phi from main::@37 to printf_sint [phi:main::@37->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#73 [phi:main::@37->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [244] phi from main::@37 to main::@167 [phi:main::@37->main::@167]
    // main::@167
    // printf("%i < than %i\n", sa.a, sb.b)
    // [245] call cputs 
    // [505] phi from main::@167 to cputs [phi:main::@167->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@167->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@168
    // printf("%i < than %i\n", sa.a, sb.b)
    // [246] printf_sint::value#74 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [247] call printf_sint 
    // [494] phi from main::@168 to printf_sint [phi:main::@168->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#74 [phi:main::@168->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [248] phi from main::@168 to main::@169 [phi:main::@168->main::@169]
    // main::@169
    // printf("%i < than %i\n", sa.a, sb.b)
    // [249] call cputs 
    // [505] phi from main::@169 to cputs [phi:main::@169->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@169->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    rts
    // main::@35
  __b35:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [250] printf_sint::value#69 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [251] call printf_sint 
    // [494] phi from main::@35 to printf_sint [phi:main::@35->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#69 [phi:main::@35->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [252] phi from main::@35 to main::@161 [phi:main::@35->main::@161]
    // main::@161
    // printf("%i < than %i\n", sa.a, sb.b)
    // [253] call cputs 
    // [505] phi from main::@161 to cputs [phi:main::@161->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@161->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@162
    // printf("%i < than %i\n", sa.a, sb.b)
    // [254] printf_sint::value#70 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [255] call printf_sint 
    // [494] phi from main::@162 to printf_sint [phi:main::@162->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#70 [phi:main::@162->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [256] phi from main::@162 to main::@163 [phi:main::@162->main::@163]
    // main::@163
    // printf("%i < than %i\n", sa.a, sb.b)
    // [257] call cputs 
    // [505] phi from main::@163 to cputs [phi:main::@163->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@163->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b36
    // main::@33
  __b33:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [258] printf_sint::value#65 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [259] call printf_sint 
    // [494] phi from main::@33 to printf_sint [phi:main::@33->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#65 [phi:main::@33->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [260] phi from main::@33 to main::@155 [phi:main::@33->main::@155]
    // main::@155
    // printf("%i < than %i\n", sa.a, sb.b)
    // [261] call cputs 
    // [505] phi from main::@155 to cputs [phi:main::@155->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@155->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@156
    // printf("%i < than %i\n", sa.a, sb.b)
    // [262] printf_sint::value#66 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [263] call printf_sint 
    // [494] phi from main::@156 to printf_sint [phi:main::@156->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#66 [phi:main::@156->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [264] phi from main::@156 to main::@157 [phi:main::@156->main::@157]
    // main::@157
    // printf("%i < than %i\n", sa.a, sb.b)
    // [265] call cputs 
    // [505] phi from main::@157 to cputs [phi:main::@157->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@157->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b34
    // main::@31
  __b31:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [266] printf_sint::value#61 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [267] call printf_sint 
    // [494] phi from main::@31 to printf_sint [phi:main::@31->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#61 [phi:main::@31->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [268] phi from main::@31 to main::@149 [phi:main::@31->main::@149]
    // main::@149
    // printf("%i < than %i\n", sa.a, sb.b)
    // [269] call cputs 
    // [505] phi from main::@149 to cputs [phi:main::@149->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@149->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@150
    // printf("%i < than %i\n", sa.a, sb.b)
    // [270] printf_sint::value#62 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [271] call printf_sint 
    // [494] phi from main::@150 to printf_sint [phi:main::@150->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#62 [phi:main::@150->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [272] phi from main::@150 to main::@151 [phi:main::@150->main::@151]
    // main::@151
    // printf("%i < than %i\n", sa.a, sb.b)
    // [273] call cputs 
    // [505] phi from main::@151 to cputs [phi:main::@151->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@151->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b32
    // main::@29
  __b29:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [274] printf_sint::value#57 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [275] call printf_sint 
    // [494] phi from main::@29 to printf_sint [phi:main::@29->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#57 [phi:main::@29->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [276] phi from main::@29 to main::@143 [phi:main::@29->main::@143]
    // main::@143
    // printf("%i < than %i\n", sa.a, sb.b)
    // [277] call cputs 
    // [505] phi from main::@143 to cputs [phi:main::@143->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@143->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@144
    // printf("%i < than %i\n", sa.a, sb.b)
    // [278] printf_sint::value#58 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [279] call printf_sint 
    // [494] phi from main::@144 to printf_sint [phi:main::@144->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#58 [phi:main::@144->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [280] phi from main::@144 to main::@145 [phi:main::@144->main::@145]
    // main::@145
    // printf("%i < than %i\n", sa.a, sb.b)
    // [281] call cputs 
    // [505] phi from main::@145 to cputs [phi:main::@145->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@145->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b30
    // main::@27
  __b27:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [282] printf_sint::value#53 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [283] call printf_sint 
    // [494] phi from main::@27 to printf_sint [phi:main::@27->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#53 [phi:main::@27->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [284] phi from main::@27 to main::@137 [phi:main::@27->main::@137]
    // main::@137
    // printf("%i < than %i\n", sa.a, sb.b)
    // [285] call cputs 
    // [505] phi from main::@137 to cputs [phi:main::@137->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@137->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@138
    // printf("%i < than %i\n", sa.a, sb.b)
    // [286] printf_sint::value#54 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [287] call printf_sint 
    // [494] phi from main::@138 to printf_sint [phi:main::@138->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#54 [phi:main::@138->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [288] phi from main::@138 to main::@139 [phi:main::@138->main::@139]
    // main::@139
    // printf("%i < than %i\n", sa.a, sb.b)
    // [289] call cputs 
    // [505] phi from main::@139 to cputs [phi:main::@139->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@139->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b28
    // main::@25
  __b25:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [290] printf_sint::value#49 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [291] call printf_sint 
    // [494] phi from main::@25 to printf_sint [phi:main::@25->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#49 [phi:main::@25->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [292] phi from main::@25 to main::@131 [phi:main::@25->main::@131]
    // main::@131
    // printf("%i < than %i\n", sa.a, sb.b)
    // [293] call cputs 
    // [505] phi from main::@131 to cputs [phi:main::@131->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@131->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@132
    // printf("%i < than %i\n", sa.a, sb.b)
    // [294] printf_sint::value#50 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [295] call printf_sint 
    // [494] phi from main::@132 to printf_sint [phi:main::@132->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#50 [phi:main::@132->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [296] phi from main::@132 to main::@133 [phi:main::@132->main::@133]
    // main::@133
    // printf("%i < than %i\n", sa.a, sb.b)
    // [297] call cputs 
    // [505] phi from main::@133 to cputs [phi:main::@133->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@133->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b26
    // main::@23
  __b23:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [298] printf_sint::value#45 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [299] call printf_sint 
    // [494] phi from main::@23 to printf_sint [phi:main::@23->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#45 [phi:main::@23->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [300] phi from main::@23 to main::@125 [phi:main::@23->main::@125]
    // main::@125
    // printf("%i < than %i\n", sa.a, sb.b)
    // [301] call cputs 
    // [505] phi from main::@125 to cputs [phi:main::@125->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@125->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@126
    // printf("%i < than %i\n", sa.a, sb.b)
    // [302] printf_sint::value#46 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [303] call printf_sint 
    // [494] phi from main::@126 to printf_sint [phi:main::@126->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#46 [phi:main::@126->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [304] phi from main::@126 to main::@127 [phi:main::@126->main::@127]
    // main::@127
    // printf("%i < than %i\n", sa.a, sb.b)
    // [305] call cputs 
    // [505] phi from main::@127 to cputs [phi:main::@127->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@127->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b24
    // main::@21
  __b21:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [306] printf_sint::value#41 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [307] call printf_sint 
    // [494] phi from main::@21 to printf_sint [phi:main::@21->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#41 [phi:main::@21->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [308] phi from main::@21 to main::@119 [phi:main::@21->main::@119]
    // main::@119
    // printf("%i < than %i\n", sa.a, sb.b)
    // [309] call cputs 
    // [505] phi from main::@119 to cputs [phi:main::@119->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@119->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@120
    // printf("%i < than %i\n", sa.a, sb.b)
    // [310] printf_sint::value#42 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [311] call printf_sint 
    // [494] phi from main::@120 to printf_sint [phi:main::@120->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#42 [phi:main::@120->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [312] phi from main::@120 to main::@121 [phi:main::@120->main::@121]
    // main::@121
    // printf("%i < than %i\n", sa.a, sb.b)
    // [313] call cputs 
    // [505] phi from main::@121 to cputs [phi:main::@121->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@121->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b22
    // main::@19
  __b19:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [314] printf_sint::value#37 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [315] call printf_sint 
    // [494] phi from main::@19 to printf_sint [phi:main::@19->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#37 [phi:main::@19->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [316] phi from main::@19 to main::@113 [phi:main::@19->main::@113]
    // main::@113
    // printf("%i < than %i\n", sa.a, sb.b)
    // [317] call cputs 
    // [505] phi from main::@113 to cputs [phi:main::@113->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@113->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@114
    // printf("%i < than %i\n", sa.a, sb.b)
    // [318] printf_sint::value#38 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [319] call printf_sint 
    // [494] phi from main::@114 to printf_sint [phi:main::@114->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#38 [phi:main::@114->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [320] phi from main::@114 to main::@115 [phi:main::@114->main::@115]
    // main::@115
    // printf("%i < than %i\n", sa.a, sb.b)
    // [321] call cputs 
    // [505] phi from main::@115 to cputs [phi:main::@115->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@115->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b20
    // main::@17
  __b17:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [322] printf_sint::value#33 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [323] call printf_sint 
    // [494] phi from main::@17 to printf_sint [phi:main::@17->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#33 [phi:main::@17->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [324] phi from main::@17 to main::@107 [phi:main::@17->main::@107]
    // main::@107
    // printf("%i < than %i\n", sa.a, sb.b)
    // [325] call cputs 
    // [505] phi from main::@107 to cputs [phi:main::@107->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@107->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@108
    // printf("%i < than %i\n", sa.a, sb.b)
    // [326] printf_sint::value#34 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [327] call printf_sint 
    // [494] phi from main::@108 to printf_sint [phi:main::@108->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#34 [phi:main::@108->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [328] phi from main::@108 to main::@109 [phi:main::@108->main::@109]
    // main::@109
    // printf("%i < than %i\n", sa.a, sb.b)
    // [329] call cputs 
    // [505] phi from main::@109 to cputs [phi:main::@109->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@109->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b18
    // main::@15
  __b15:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [330] printf_sint::value#29 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [331] call printf_sint 
    // [494] phi from main::@15 to printf_sint [phi:main::@15->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#29 [phi:main::@15->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [332] phi from main::@15 to main::@101 [phi:main::@15->main::@101]
    // main::@101
    // printf("%i < than %i\n", sa.a, sb.b)
    // [333] call cputs 
    // [505] phi from main::@101 to cputs [phi:main::@101->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@101->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@102
    // printf("%i < than %i\n", sa.a, sb.b)
    // [334] printf_sint::value#30 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [335] call printf_sint 
    // [494] phi from main::@102 to printf_sint [phi:main::@102->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#30 [phi:main::@102->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [336] phi from main::@102 to main::@103 [phi:main::@102->main::@103]
    // main::@103
    // printf("%i < than %i\n", sa.a, sb.b)
    // [337] call cputs 
    // [505] phi from main::@103 to cputs [phi:main::@103->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@103->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b16
    // main::@13
  __b13:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [338] printf_sint::value#25 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [339] call printf_sint 
    // [494] phi from main::@13 to printf_sint [phi:main::@13->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#25 [phi:main::@13->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [340] phi from main::@13 to main::@95 [phi:main::@13->main::@95]
    // main::@95
    // printf("%i < than %i\n", sa.a, sb.b)
    // [341] call cputs 
    // [505] phi from main::@95 to cputs [phi:main::@95->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@95->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@96
    // printf("%i < than %i\n", sa.a, sb.b)
    // [342] printf_sint::value#26 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [343] call printf_sint 
    // [494] phi from main::@96 to printf_sint [phi:main::@96->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#26 [phi:main::@96->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [344] phi from main::@96 to main::@97 [phi:main::@96->main::@97]
    // main::@97
    // printf("%i < than %i\n", sa.a, sb.b)
    // [345] call cputs 
    // [505] phi from main::@97 to cputs [phi:main::@97->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@97->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b14
    // main::@11
  __b11:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [346] printf_sint::value#21 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [347] call printf_sint 
    // [494] phi from main::@11 to printf_sint [phi:main::@11->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#21 [phi:main::@11->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [348] phi from main::@11 to main::@89 [phi:main::@11->main::@89]
    // main::@89
    // printf("%i < than %i\n", sa.a, sb.b)
    // [349] call cputs 
    // [505] phi from main::@89 to cputs [phi:main::@89->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@89->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@90
    // printf("%i < than %i\n", sa.a, sb.b)
    // [350] printf_sint::value#22 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [351] call printf_sint 
    // [494] phi from main::@90 to printf_sint [phi:main::@90->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#22 [phi:main::@90->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [352] phi from main::@90 to main::@91 [phi:main::@90->main::@91]
    // main::@91
    // printf("%i < than %i\n", sa.a, sb.b)
    // [353] call cputs 
    // [505] phi from main::@91 to cputs [phi:main::@91->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@91->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b12
    // main::@9
  __b9:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [354] printf_sint::value#17 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [355] call printf_sint 
    // [494] phi from main::@9 to printf_sint [phi:main::@9->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#17 [phi:main::@9->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [356] phi from main::@9 to main::@83 [phi:main::@9->main::@83]
    // main::@83
    // printf("%i < than %i\n", sa.a, sb.b)
    // [357] call cputs 
    // [505] phi from main::@83 to cputs [phi:main::@83->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@83->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@84
    // printf("%i < than %i\n", sa.a, sb.b)
    // [358] printf_sint::value#18 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [359] call printf_sint 
    // [494] phi from main::@84 to printf_sint [phi:main::@84->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#18 [phi:main::@84->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [360] phi from main::@84 to main::@85 [phi:main::@84->main::@85]
    // main::@85
    // printf("%i < than %i\n", sa.a, sb.b)
    // [361] call cputs 
    // [505] phi from main::@85 to cputs [phi:main::@85->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@85->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b10
    // main::@7
  __b7:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [362] printf_sint::value#13 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [363] call printf_sint 
    // [494] phi from main::@7 to printf_sint [phi:main::@7->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#13 [phi:main::@7->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [364] phi from main::@7 to main::@77 [phi:main::@7->main::@77]
    // main::@77
    // printf("%i < than %i\n", sa.a, sb.b)
    // [365] call cputs 
    // [505] phi from main::@77 to cputs [phi:main::@77->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@77->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@78
    // printf("%i < than %i\n", sa.a, sb.b)
    // [366] printf_sint::value#14 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [367] call printf_sint 
    // [494] phi from main::@78 to printf_sint [phi:main::@78->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#14 [phi:main::@78->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [368] phi from main::@78 to main::@79 [phi:main::@78->main::@79]
    // main::@79
    // printf("%i < than %i\n", sa.a, sb.b)
    // [369] call cputs 
    // [505] phi from main::@79 to cputs [phi:main::@79->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@79->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b8
    // main::@5
  __b5:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [370] printf_sint::value#9 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [371] call printf_sint 
    // [494] phi from main::@5 to printf_sint [phi:main::@5->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#9 [phi:main::@5->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [372] phi from main::@5 to main::@71 [phi:main::@5->main::@71]
    // main::@71
    // printf("%i < than %i\n", sa.a, sb.b)
    // [373] call cputs 
    // [505] phi from main::@71 to cputs [phi:main::@71->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@71->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@72
    // printf("%i < than %i\n", sa.a, sb.b)
    // [374] printf_sint::value#10 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [375] call printf_sint 
    // [494] phi from main::@72 to printf_sint [phi:main::@72->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#10 [phi:main::@72->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [376] phi from main::@72 to main::@73 [phi:main::@72->main::@73]
    // main::@73
    // printf("%i < than %i\n", sa.a, sb.b)
    // [377] call cputs 
    // [505] phi from main::@73 to cputs [phi:main::@73->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@73->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b6
    // main::@3
  __b3:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [378] printf_sint::value#5 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [379] call printf_sint 
    // [494] phi from main::@3 to printf_sint [phi:main::@3->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#5 [phi:main::@3->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [380] phi from main::@3 to main::@65 [phi:main::@3->main::@65]
    // main::@65
    // printf("%i < than %i\n", sa.a, sb.b)
    // [381] call cputs 
    // [505] phi from main::@65 to cputs [phi:main::@65->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@65->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@66
    // printf("%i < than %i\n", sa.a, sb.b)
    // [382] printf_sint::value#6 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [383] call printf_sint 
    // [494] phi from main::@66 to printf_sint [phi:main::@66->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#6 [phi:main::@66->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [384] phi from main::@66 to main::@67 [phi:main::@66->main::@67]
    // main::@67
    // printf("%i < than %i\n", sa.a, sb.b)
    // [385] call cputs 
    // [505] phi from main::@67 to cputs [phi:main::@67->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@67->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b4
    // main::@1
  __b1:
    // printf("%i < than %i\n", sa.a, sb.b)
    // [386] printf_sint::value#1 = *((signed word*)&sa) -- vwsz1=_deref_pwsc1 
    lda sa
    sta.z printf_sint.value
    lda sa+1
    sta.z printf_sint.value+1
    // [387] call printf_sint 
    // [494] phi from main::@1 to printf_sint [phi:main::@1->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#1 [phi:main::@1->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [388] phi from main::@1 to main::@59 [phi:main::@1->main::@59]
    // main::@59
    // printf("%i < than %i\n", sa.a, sb.b)
    // [389] call cputs 
    // [505] phi from main::@59 to cputs [phi:main::@59->cputs]
    // [505] phi cputs::s#79 = main::s [phi:main::@59->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@60
    // printf("%i < than %i\n", sa.a, sb.b)
    // [390] printf_sint::value#2 = *((signed word*)&sb) -- vwsz1=_deref_pwsc1 
    lda sb
    sta.z printf_sint.value
    lda sb+1
    sta.z printf_sint.value+1
    // [391] call printf_sint 
    // [494] phi from main::@60 to printf_sint [phi:main::@60->printf_sint]
    // [494] phi printf_sint::value#77 = printf_sint::value#2 [phi:main::@60->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [392] phi from main::@60 to main::@61 [phi:main::@60->main::@61]
    // main::@61
    // printf("%i < than %i\n", sa.a, sb.b)
    // [393] call cputs 
    // [505] phi from main::@61 to cputs [phi:main::@61->cputs]
    // [505] phi cputs::s#79 = main::s1 [phi:main::@61->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    jmp __b2
  .segment Data
    s: .text " < than "
    .byte 0
    s1: .text @"\n"
    .byte 0
    s2: .text " not < than "
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
vera_layer_mode_text: {
    .label layer = 1
    .label mapbase_address = 0
    .label tilebase_address = $f800
    // vera_layer_mode_tile( layer, mapbase_address, tilebase_address, mapwidth, mapheight, tilewidth, tileheight, 1 )
    // [395] call vera_layer_mode_tile 
    // [513] phi from vera_layer_mode_text to vera_layer_mode_tile [phi:vera_layer_mode_text->vera_layer_mode_tile]
    jsr vera_layer_mode_tile
    // [396] phi from vera_layer_mode_text to vera_layer_mode_text::@1 [phi:vera_layer_mode_text->vera_layer_mode_text::@1]
    // vera_layer_mode_text::@1
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C )
    // [397] call vera_layer_set_text_color_mode 
    jsr vera_layer_set_text_color_mode
    // vera_layer_mode_text::@return
    // }
    // [398] return 
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
    // [399] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    sta.z hscale
    // 40 << hscale
    // [400] screensize::$1 = $28 << screensize::hscale#0 -- vbum1=vbuc1_rol_vbuz2 
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
    // [401] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbum1 
    sta x
    // char vscale = (*VERA_DC_VSCALE) >> 7
    // [402] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    sta.z vscale
    // 30 << vscale
    // [403] screensize::$3 = $1e << screensize::vscale#0 -- vbum1=vbuc1_rol_vbuz2 
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
    // [404] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbum1 
    sta y
    // screensize::@return
    // }
    // [405] return 
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
    // [406] *((byte*)&cx16_conio) = screenlayer::layer#0 -- _deref_pbuc1=vbuc2 
    lda #layer
    sta cx16_conio
    // vera_layer_get_mapbase_bank(layer)
    // [407] call vera_layer_get_mapbase_bank 
    jsr vera_layer_get_mapbase_bank
    // [408] vera_layer_get_mapbase_bank::return#2 = vera_layer_get_mapbase_bank::return#0
    // screenlayer::@3
    // [409] screenlayer::$0 = vera_layer_get_mapbase_bank::return#2 -- vbum1=vbuz2 
    lda.z vera_layer_get_mapbase_bank.return
    sta __0
    // cx16_conio.conio_screen_bank = vera_layer_get_mapbase_bank(layer)
    // [410] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) = screenlayer::$0 -- _deref_pbuc1=vbum1 
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // vera_layer_get_mapbase_offset(layer)
    // [411] call vera_layer_get_mapbase_offset 
    jsr vera_layer_get_mapbase_offset
    // [412] vera_layer_get_mapbase_offset::return#2 = vera_layer_get_mapbase_offset::return#0
    // screenlayer::@4
    // [413] screenlayer::$1 = vera_layer_get_mapbase_offset::return#2 -- vwum1=vwuz2 
    lda.z vera_layer_get_mapbase_offset.return
    sta __1
    lda.z vera_layer_get_mapbase_offset.return+1
    sta __1+1
    // cx16_conio.conio_screen_text = vera_layer_get_mapbase_offset(layer)
    // [414] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) = screenlayer::$1 -- _deref_pwuc1=vwum1 
    lda __1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    lda __1+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    // screenlayer::vera_layer_get_width1
    // byte* config = vera_layer_config[layer]
    // [415] screenlayer::vera_layer_get_width1_config#0 = *(vera_layer_config+screenlayer::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+layer*SIZEOF_POINTER
    sta.z vera_layer_get_width1_config
    lda vera_layer_config+layer*SIZEOF_POINTER+1
    sta.z vera_layer_get_width1_config+1
    // *config & VERA_LAYER_WIDTH_MASK
    // [416] screenlayer::vera_layer_get_width1_$0 = *screenlayer::vera_layer_get_width1_config#0 & VERA_LAYER_WIDTH_MASK -- vbum1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    ldy #0
    and (vera_layer_get_width1_config),y
    sta vera_layer_get_width1___0
    // (*config & VERA_LAYER_WIDTH_MASK) >> 4
    // [417] screenlayer::vera_layer_get_width1_$1 = screenlayer::vera_layer_get_width1_$0 >> 4 -- vbum1=vbum1_ror_4 
    lda vera_layer_get_width1___1
    lsr
    lsr
    lsr
    lsr
    sta vera_layer_get_width1___1
    // return VERA_LAYER_WIDTH[ (*config & VERA_LAYER_WIDTH_MASK) >> 4];
    // [418] screenlayer::vera_layer_get_width1_$3 = screenlayer::vera_layer_get_width1_$1 << 1 -- vbum1=vbum1_rol_1 
    asl vera_layer_get_width1___3
    // [419] screenlayer::vera_layer_get_width1_return#0 = VERA_LAYER_WIDTH[screenlayer::vera_layer_get_width1_$3] -- vwuz1=pwuc1_derefidx_vbum2 
    ldy vera_layer_get_width1___3
    lda VERA_LAYER_WIDTH,y
    sta.z vera_layer_get_width1_return
    lda VERA_LAYER_WIDTH+1,y
    sta.z vera_layer_get_width1_return+1
    // screenlayer::@1
    // cx16_conio.conio_map_width = vera_layer_get_width(layer)
    // [420] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) = screenlayer::vera_layer_get_width1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_width1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    lda.z vera_layer_get_width1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    // screenlayer::vera_layer_get_height1
    // byte* config = vera_layer_config[layer]
    // [421] screenlayer::vera_layer_get_height1_config#0 = *(vera_layer_config+screenlayer::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+layer*SIZEOF_POINTER
    sta.z vera_layer_get_height1_config
    lda vera_layer_config+layer*SIZEOF_POINTER+1
    sta.z vera_layer_get_height1_config+1
    // *config & VERA_LAYER_HEIGHT_MASK
    // [422] screenlayer::vera_layer_get_height1_$0 = *screenlayer::vera_layer_get_height1_config#0 & VERA_LAYER_HEIGHT_MASK -- vbum1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    ldy #0
    and (vera_layer_get_height1_config),y
    sta vera_layer_get_height1___0
    // (*config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [423] screenlayer::vera_layer_get_height1_$1 = screenlayer::vera_layer_get_height1_$0 >> 6 -- vbum1=vbum1_ror_6 
    lda vera_layer_get_height1___1
    rol
    rol
    rol
    and #3
    sta vera_layer_get_height1___1
    // return VERA_LAYER_HEIGHT[ (*config & VERA_LAYER_HEIGHT_MASK) >> 6];
    // [424] screenlayer::vera_layer_get_height1_$3 = screenlayer::vera_layer_get_height1_$1 << 1 -- vbum1=vbum1_rol_1 
    asl vera_layer_get_height1___3
    // [425] screenlayer::vera_layer_get_height1_return#0 = VERA_LAYER_HEIGHT[screenlayer::vera_layer_get_height1_$3] -- vwuz1=pwuc1_derefidx_vbum2 
    ldy vera_layer_get_height1___3
    lda VERA_LAYER_HEIGHT,y
    sta.z vera_layer_get_height1_return
    lda VERA_LAYER_HEIGHT+1,y
    sta.z vera_layer_get_height1_return+1
    // screenlayer::@2
    // cx16_conio.conio_map_height = vera_layer_get_height(layer)
    // [426] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) = screenlayer::vera_layer_get_height1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_height1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    lda.z vera_layer_get_height1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    // vera_layer_get_rowshift(layer)
    // [427] call vera_layer_get_rowshift 
    jsr vera_layer_get_rowshift
    // [428] vera_layer_get_rowshift::return#2 = vera_layer_get_rowshift::return#0
    // screenlayer::@5
    // [429] screenlayer::$4 = vera_layer_get_rowshift::return#2 -- vbum1=vbuz2 
    lda.z vera_layer_get_rowshift.return
    sta __4
    // cx16_conio.conio_rowshift = vera_layer_get_rowshift(layer)
    // [430] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) = screenlayer::$4 -- _deref_pbuc1=vbum1 
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
    // vera_layer_get_rowskip(layer)
    // [431] call vera_layer_get_rowskip 
    jsr vera_layer_get_rowskip
    // [432] vera_layer_get_rowskip::return#2 = vera_layer_get_rowskip::return#0
    // screenlayer::@6
    // [433] screenlayer::$5 = vera_layer_get_rowskip::return#2 -- vwum1=vwuz2 
    lda.z vera_layer_get_rowskip.return
    sta __5
    lda.z vera_layer_get_rowskip.return+1
    sta __5+1
    // cx16_conio.conio_rowskip = vera_layer_get_rowskip(layer)
    // [434] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) = screenlayer::$5 -- _deref_pwuc1=vwum1 
    lda __5
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    lda __5+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    // screenlayer::@return
    // }
    // [435] return 
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
    // [436] *(vera_layer_textcolor+vera_layer_set_textcolor::layer#0) = WHITE -- _deref_pbuc1=vbuc2 
    lda #WHITE
    sta vera_layer_textcolor+layer
    // vera_layer_set_textcolor::@return
    // }
    // [437] return 
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
    // [438] *(vera_layer_backcolor+vera_layer_set_backcolor::layer#0) = BLUE -- _deref_pbuc1=vbuc2 
    lda #BLUE
    sta vera_layer_backcolor+layer
    // vera_layer_set_backcolor::@return
    // }
    // [439] return 
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
    // [441] vera_layer_set_mapbase::$0 = vera_layer_set_mapbase::layer#3 << 1 -- vbum1=vbuz2_rol_1 
    lda.z layer
    asl
    sta __0
    // [442] vera_layer_set_mapbase::addr#0 = vera_layer_mapbase[vera_layer_set_mapbase::$0] -- pbuz1=qbuc1_derefidx_vbum2 
    tay
    lda vera_layer_mapbase,y
    sta.z addr
    lda vera_layer_mapbase+1,y
    sta.z addr+1
    // *addr = mapbase
    // [443] *vera_layer_set_mapbase::addr#0 = vera_layer_set_mapbase::mapbase#3 -- _deref_pbuz1=vbuz2 
    lda.z mapbase
    ldy #0
    sta (addr),y
    // vera_layer_set_mapbase::@return
    // }
    // [444] return 
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
    // [445] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR
    // cursor::@return
    // }
    // [446] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// gotoxy(byte zp(3) y)
gotoxy: {
    .label line_offset = $d
    .label y = 3
    // if(y>cx16_conio.conio_screen_height)
    // [448] if(gotoxy::y#4<=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto gotoxy::@4 -- vbuz1_le__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    cmp.z y
    bcs __b1
    // [450] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [450] phi gotoxy::y#5 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z y
    // [449] phi from gotoxy to gotoxy::@4 [phi:gotoxy->gotoxy::@4]
    // gotoxy::@4
    // [450] phi from gotoxy::@4 to gotoxy::@1 [phi:gotoxy::@4->gotoxy::@1]
    // [450] phi gotoxy::y#5 = gotoxy::y#4 [phi:gotoxy::@4->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=cx16_conio.conio_screen_width)
    // [451] if(0<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto gotoxy::@2 -- 0_lt__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    cmp #0
    // [452] phi from gotoxy::@1 to gotoxy::@3 [phi:gotoxy::@1->gotoxy::@3]
    // gotoxy::@3
    // gotoxy::@2
    // conio_cursor_x[cx16_conio.conio_screen_layer] = x
    // [453] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = y
    // [454] conio_cursor_y[*((byte*)&cx16_conio)] = gotoxy::y#5 -- pbuc1_derefidx_(_deref_pbuc2)=vbuz1 
    lda.z y
    sta conio_cursor_y,y
    // (unsigned int)y << cx16_conio.conio_rowshift
    // [455] gotoxy::$6 = (word)gotoxy::y#5 -- vwum1=_word_vbuz2 
    sta __6
    lda #0
    sta __6+1
    // unsigned int line_offset = (unsigned int)y << cx16_conio.conio_rowshift
    // [456] gotoxy::line_offset#0 = gotoxy::$6 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vwum2_rol__deref_pbuc1 
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
    // [457] gotoxy::$5 = *((byte*)&cx16_conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta __5
    // [458] conio_line_text[gotoxy::$5] = gotoxy::line_offset#0 -- pwuc1_derefidx_vbum1=vwuz2 
    tay
    lda.z line_offset
    sta conio_line_text,y
    lda.z line_offset+1
    sta conio_line_text+1,y
    // gotoxy::@return
    // }
    // [459] return 
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
    .label conio_map_height = $14
    .label conio_map_width = $12
    .label c = $1c
    .label l = $1b
    // unsigned int line_text = cx16_conio.conio_screen_text
    // [460] clrscr::line_text#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z line_text+1
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer)
    // [461] vera_layer_get_backcolor::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_backcolor.layer
    // [462] call vera_layer_get_backcolor 
    jsr vera_layer_get_backcolor
    // [463] vera_layer_get_backcolor::return#0 = vera_layer_get_backcolor::return#1
    // clrscr::@7
    // [464] clrscr::$0 = vera_layer_get_backcolor::return#0 -- vbum1=vbuz2 
    lda.z vera_layer_get_backcolor.return
    sta __0
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4
    // [465] clrscr::$1 = clrscr::$0 << 4 -- vbum1=vbum1_rol_4 
    lda __1
    asl
    asl
    asl
    asl
    sta __1
    // vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [466] vera_layer_get_textcolor::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_textcolor.layer
    // [467] call vera_layer_get_textcolor 
    jsr vera_layer_get_textcolor
    // [468] vera_layer_get_textcolor::return#0 = vera_layer_get_textcolor::return#1
    // clrscr::@8
    // [469] clrscr::$2 = vera_layer_get_textcolor::return#0 -- vbum1=vbuz2 
    lda.z vera_layer_get_textcolor.return
    sta __2
    // char color = ( vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4 ) | vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [470] clrscr::color#0 = clrscr::$1 | clrscr::$2 -- vbuz1=vbum2_bor_vbum3 
    lda __1
    ora __2
    sta.z color
    // word conio_map_height = cx16_conio.conio_map_height
    // [471] clrscr::conio_map_height#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    sta.z conio_map_height
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    sta.z conio_map_height+1
    // word conio_map_width = cx16_conio.conio_map_width
    // [472] clrscr::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // [473] phi from clrscr::@8 to clrscr::@1 [phi:clrscr::@8->clrscr::@1]
    // [473] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr::@8->clrscr::@1#0] -- register_copy 
    // [473] phi clrscr::l#2 = 0 [phi:clrscr::@8->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<conio_map_height; l++ )
    // [474] if(clrscr::l#2<clrscr::conio_map_height#0) goto clrscr::@2 -- vbuz1_lt_vwuz2_then_la1 
    lda.z conio_map_height+1
    bne __b2
    lda.z l
    cmp.z conio_map_height
    bcc __b2
    // clrscr::@3
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [475] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = 0
    // [476] conio_cursor_y[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    sta conio_cursor_y,y
    // conio_line_text[cx16_conio.conio_screen_layer] = 0
    // [477] clrscr::$9 = *((byte*)&cx16_conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    tya
    asl
    sta __9
    // [478] conio_line_text[clrscr::$9] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy __9
    sta conio_line_text,y
    sta conio_line_text+1,y
    // clrscr::@return
    // }
    // [479] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [480] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <ch
    // [481] clrscr::$5 = < clrscr::line_text#2 -- vbum1=_lo_vwuz2 
    lda.z line_text
    sta __5
    // *VERA_ADDRX_L = <ch
    // [482] *VERA_ADDRX_L = clrscr::$5 -- _deref_pbuc1=vbum1 
    // Set address
    sta VERA_ADDRX_L
    // >ch
    // [483] clrscr::$6 = > clrscr::line_text#2 -- vbum1=_hi_vwuz2 
    lda.z line_text+1
    sta __6
    // *VERA_ADDRX_M = >ch
    // [484] *VERA_ADDRX_M = clrscr::$6 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [485] clrscr::$7 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    sta __7
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [486] *VERA_ADDRX_H = clrscr::$7 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // [487] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [487] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@4
  __b4:
    // for( char c=0;c<conio_map_width; c++ )
    // [488] if(clrscr::c#2<clrscr::conio_map_width#0) goto clrscr::@5 -- vbuz1_lt_vwuz2_then_la1 
    lda.z conio_map_width+1
    bne __b5
    lda.z c
    cmp.z conio_map_width
    bcc __b5
    // clrscr::@6
    // line_text += cx16_conio.conio_rowskip
    // [489] clrscr::line_text#1 = clrscr::line_text#2 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z line_text
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z line_text+1
    sta.z line_text+1
    // for( char l=0;l<conio_map_height; l++ )
    // [490] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [473] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [473] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [473] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [491] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [492] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<conio_map_width; c++ )
    // [493] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [487] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [487] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
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
  // printf_sint
// Print a signed integer using a specific format
// printf_sint(signed word zp(4) value)
printf_sint: {
    .label value = 4
    // printf_buffer.sign = 0
    // [495] *((byte*)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // if(value<0)
    // [496] if(printf_sint::value#77<0) goto printf_sint::@1 -- vwsz1_lt_0_then_la1 
    lda.z value+1
    bmi __b1
    // [499] phi from printf_sint printf_sint::@1 to printf_sint::@2 [phi:printf_sint/printf_sint::@1->printf_sint::@2]
    // [499] phi printf_sint::value#79 = printf_sint::value#77 [phi:printf_sint/printf_sint::@1->printf_sint::@2#0] -- register_copy 
    jmp __b2
    // printf_sint::@1
  __b1:
    // value = -value
    // [497] printf_sint::value#0 = - printf_sint::value#77 -- vwsz1=_neg_vwsz1 
    sec
    lda #0
    sbc.z value
    sta.z value
    lda #0
    sbc.z value+1
    sta.z value+1
    // printf_buffer.sign = '-'
    // [498] *((byte*)&printf_buffer) = '-' -- _deref_pbuc1=vbuc2 
    lda #'-'
    sta printf_buffer
    // printf_sint::@2
  __b2:
    // utoa(uvalue, printf_buffer.digits, format.radix)
    // [500] utoa::value#1 = (word)printf_sint::value#79
    // [501] call utoa 
    // [544] phi from printf_sint::@2 to utoa [phi:printf_sint::@2->utoa]
    jsr utoa
    // printf_sint::@3
    // printf_number_buffer(printf_buffer, format)
    // [502] printf_number_buffer::buffer_sign#0 = *((byte*)&printf_buffer) -- vbuz1=_deref_pbuc1 
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
    // [503] call printf_number_buffer 
  // Print using format
    // [565] phi from printf_sint::@3 to printf_number_buffer [phi:printf_sint::@3->printf_number_buffer]
    jsr printf_number_buffer
    // printf_sint::@return
    // }
    // [504] return 
    rts
}
  // cputs
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp(6) s)
cputs: {
    .label c = 8
    .label s = 6
    // [506] phi from cputs cputs::@2 to cputs::@1 [phi:cputs/cputs::@2->cputs::@1]
    // [506] phi cputs::s#78 = cputs::s#79 [phi:cputs/cputs::@2->cputs::@1#0] -- register_copy 
    // cputs::@1
  __b1:
    // while(c=*s++)
    // [507] cputs::c#1 = *cputs::s#78 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta.z c
    // [508] cputs::s#0 = ++ cputs::s#78 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [509] if(0!=cputs::c#1) goto cputs::@2 -- 0_neq_vbuz1_then_la1 
    lda.z c
    bne __b2
    // cputs::@return
    // }
    // [510] return 
    rts
    // cputs::@2
  __b2:
    // cputc(c)
    // [511] cputc::c#0 = cputs::c#1
    // [512] call cputc 
    // [572] phi from cputs::@2 to cputc [phi:cputs::@2->cputc]
    // [572] phi cputc::c#3 = cputc::c#0 [phi:cputs::@2->cputc#0] -- register_copy 
    jsr cputc
    jmp __b1
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
    // [514] *(vera_layer_rowshift+vera_layer_mode_text::layer#0) = 8 -- _deref_pbuc1=vbuc2 
    lda #8
    sta vera_layer_rowshift+vera_layer_mode_text.layer
    // vera_layer_rowskip[layer] = 256
    // [515] *(vera_layer_rowskip+vera_layer_mode_text::layer#0*SIZEOF_WORD) = $100 -- _deref_pwuc1=vwuc2 
    lda #<$100
    sta vera_layer_rowskip+vera_layer_mode_text.layer*SIZEOF_WORD
    lda #>$100
    sta vera_layer_rowskip+vera_layer_mode_text.layer*SIZEOF_WORD+1
    // [516] phi from vera_layer_mode_tile::@1 to vera_layer_mode_tile::@2 [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@2]
    // vera_layer_mode_tile::@2
    // vera_layer_set_config(layer, config)
    // [517] call vera_layer_set_config 
    jsr vera_layer_set_config
    // vera_layer_mode_tile::@4
    // vera_mapbase_offset[layer] = <mapbase_address
    // [518] *(vera_mapbase_offset+vera_layer_mode_text::layer#0*SIZEOF_WORD) = 0 -- _deref_pwuc1=vwuc2 
    // mapbase
    lda #<0
    sta vera_mapbase_offset+vera_layer_mode_text.layer*SIZEOF_WORD
    sta vera_mapbase_offset+vera_layer_mode_text.layer*SIZEOF_WORD+1
    // vera_mapbase_bank[layer] = (byte)(>mapbase_address)
    // [519] *(vera_mapbase_bank+vera_layer_mode_text::layer#0) = 0 -- _deref_pbuc1=vbuc2 
    sta vera_mapbase_bank+vera_layer_mode_text.layer
    // vera_mapbase_address[layer] = mapbase_address
    // [520] *(vera_mapbase_address+vera_layer_mode_text::layer#0*SIZEOF_DWORD) = vera_layer_mode_text::mapbase_address#0 -- _deref_pduc1=vduc2 
    lda #<vera_layer_mode_text.mapbase_address
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_DWORD
    lda #>vera_layer_mode_text.mapbase_address
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+1
    lda #<vera_layer_mode_text.mapbase_address>>$10
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+2
    lda #>vera_layer_mode_text.mapbase_address>>$10
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+3
    // vera_layer_set_mapbase(layer,mapbase)
    // [521] call vera_layer_set_mapbase 
    // [440] phi from vera_layer_mode_tile::@4 to vera_layer_set_mapbase [phi:vera_layer_mode_tile::@4->vera_layer_set_mapbase]
    // [440] phi vera_layer_set_mapbase::mapbase#3 = vera_layer_mode_tile::mapbase#0 [phi:vera_layer_mode_tile::@4->vera_layer_set_mapbase#0] -- vbuz1=vbuc1 
    lda #mapbase
    sta.z vera_layer_set_mapbase.mapbase
    // [440] phi vera_layer_set_mapbase::layer#3 = vera_layer_mode_text::layer#0 [phi:vera_layer_mode_tile::@4->vera_layer_set_mapbase#1] -- vbuz1=vbuc1 
    lda #vera_layer_mode_text.layer
    sta.z vera_layer_set_mapbase.layer
    jsr vera_layer_set_mapbase
    // vera_layer_mode_tile::@5
    // vera_tilebase_offset[layer] = <tilebase_address
    // [522] *(vera_tilebase_offset+vera_layer_mode_text::layer#0*SIZEOF_WORD) = <vera_layer_mode_text::tilebase_address#0 -- _deref_pwuc1=vwuc2 
    // tilebase
    lda #<vera_layer_mode_text.tilebase_address&$ffff
    sta vera_tilebase_offset+vera_layer_mode_text.layer*SIZEOF_WORD
    lda #>vera_layer_mode_text.tilebase_address&$ffff
    sta vera_tilebase_offset+vera_layer_mode_text.layer*SIZEOF_WORD+1
    // vera_tilebase_bank[layer] = (byte)>tilebase_address
    // [523] *(vera_tilebase_bank+vera_layer_mode_text::layer#0) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta vera_tilebase_bank+vera_layer_mode_text.layer
    // vera_tilebase_address[layer] = tilebase_address
    // [524] *(vera_tilebase_address+vera_layer_mode_text::layer#0*SIZEOF_DWORD) = vera_layer_mode_text::tilebase_address#0 -- _deref_pduc1=vduc2 
    lda #<vera_layer_mode_text.tilebase_address
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_DWORD
    lda #>vera_layer_mode_text.tilebase_address
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+1
    lda #<vera_layer_mode_text.tilebase_address>>$10
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+2
    lda #>vera_layer_mode_text.tilebase_address>>$10
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+3
    // [525] phi from vera_layer_mode_tile::@5 to vera_layer_mode_tile::@3 [phi:vera_layer_mode_tile::@5->vera_layer_mode_tile::@3]
    // vera_layer_mode_tile::@3
    // vera_layer_set_tilebase(layer,tilebase)
    // [526] call vera_layer_set_tilebase 
    jsr vera_layer_set_tilebase
    // vera_layer_mode_tile::@return
    // }
    // [527] return 
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
    // [528] vera_layer_set_text_color_mode::addr#0 = *(vera_layer_config+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr &= ~VERA_LAYER_CONFIG_256C
    // [529] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 & ~VERA_LAYER_CONFIG_256C -- _deref_pbuz1=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C^$ff
    ldy #0
    and (addr),y
    sta (addr),y
    // *addr |= color_mode
    // [530] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 -- _deref_pbuz1=_deref_pbuz1 
    lda (addr),y
    sta (addr),y
    // vera_layer_set_text_color_mode::@return
    // }
    // [531] return 
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
    // [532] vera_layer_get_mapbase_bank::return#0 = *(vera_mapbase_bank+screenlayer::layer#0) -- vbuz1=_deref_pbuc1 
    lda vera_mapbase_bank+screenlayer.layer
    sta.z return
    // vera_layer_get_mapbase_bank::@return
    // }
    // [533] return 
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
    // [534] vera_layer_get_mapbase_offset::return#0 = *(vera_mapbase_offset+screenlayer::layer#0*SIZEOF_WORD) -- vwuz1=_deref_pwuc1 
    lda vera_mapbase_offset+screenlayer.layer*SIZEOF_WORD
    sta.z return
    lda vera_mapbase_offset+screenlayer.layer*SIZEOF_WORD+1
    sta.z return+1
    // vera_layer_get_mapbase_offset::@return
    // }
    // [535] return 
    rts
}
  // vera_layer_get_rowshift
// Get the bit shift value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
vera_layer_get_rowshift: {
    .label return = $a
    // return vera_layer_rowshift[layer];
    // [536] vera_layer_get_rowshift::return#0 = *(vera_layer_rowshift+screenlayer::layer#0) -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift+screenlayer.layer
    sta.z return
    // vera_layer_get_rowshift::@return
    // }
    // [537] return 
    rts
}
  // vera_layer_get_rowskip
// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
vera_layer_get_rowskip: {
    .label return = $17
    // return vera_layer_rowskip[layer];
    // [538] vera_layer_get_rowskip::return#0 = *(vera_layer_rowskip+screenlayer::layer#0*SIZEOF_WORD) -- vwuz1=_deref_pwuc1 
    lda vera_layer_rowskip+screenlayer.layer*SIZEOF_WORD
    sta.z return
    lda vera_layer_rowskip+screenlayer.layer*SIZEOF_WORD+1
    sta.z return+1
    // vera_layer_get_rowskip::@return
    // }
    // [539] return 
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
    // [540] vera_layer_get_backcolor::return#1 = vera_layer_backcolor[vera_layer_get_backcolor::layer#0] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_backcolor,y
    sta.z return
    // vera_layer_get_backcolor::@return
    // }
    // [541] return 
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
// vera_layer_get_textcolor(byte zp($16) layer)
vera_layer_get_textcolor: {
    .label layer = $16
    .label return = $16
    // return vera_layer_textcolor[layer];
    // [542] vera_layer_get_textcolor::return#1 = vera_layer_textcolor[vera_layer_get_textcolor::layer#0] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_textcolor,y
    sta.z return
    // vera_layer_get_textcolor::@return
    // }
    // [543] return 
    rts
}
  // utoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp(4) value, byte* zp(6) buffer)
utoa: {
    .label digit_value = $14
    .label buffer = 6
    .label digit = $1b
    .label value = 4
    .label started = $1c
    // [545] phi from utoa to utoa::@1 [phi:utoa->utoa::@1]
    // [545] phi utoa::buffer#11 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:utoa->utoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [545] phi utoa::started#2 = 0 [phi:utoa->utoa::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z started
    // [545] phi utoa::value#2 = utoa::value#1 [phi:utoa->utoa::@1#2] -- register_copy 
    // [545] phi utoa::digit#2 = 0 [phi:utoa->utoa::@1#3] -- vbuz1=vbuc1 
    sta.z digit
    // utoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [546] if(utoa::digit#2<5-1) goto utoa::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z digit
    cmp #5-1
    bcc __b2
    // utoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [547] utoa::$11 = (byte)utoa::value#2 -- vbum1=_byte_vwuz2 
    lda.z value
    sta __11
    // [548] *utoa::buffer#11 = DIGITS[utoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [549] utoa::buffer#3 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [550] *utoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // utoa::@return
    // }
    // [551] return 
    rts
    // utoa::@2
  __b2:
    // unsigned int digit_value = digit_values[digit]
    // [552] utoa::$10 = utoa::digit#2 << 1 -- vbum1=vbuz2_rol_1 
    lda.z digit
    asl
    sta __10
    // [553] utoa::digit_value#0 = RADIX_DECIMAL_VALUES[utoa::$10] -- vwuz1=pwuc1_derefidx_vbum2 
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    // [554] if(0!=utoa::started#2) goto utoa::@5 -- 0_neq_vbuz1_then_la1 
    lda.z started
    bne __b5
    // utoa::@7
    // [555] if(utoa::value#2>=utoa::digit_value#0) goto utoa::@5 -- vwuz1_ge_vwuz2_then_la1 
    lda.z digit_value+1
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b5
  !:
    bcc __b5
    // [556] phi from utoa::@7 to utoa::@4 [phi:utoa::@7->utoa::@4]
    // [556] phi utoa::buffer#14 = utoa::buffer#11 [phi:utoa::@7->utoa::@4#0] -- register_copy 
    // [556] phi utoa::started#4 = utoa::started#2 [phi:utoa::@7->utoa::@4#1] -- register_copy 
    // [556] phi utoa::value#6 = utoa::value#2 [phi:utoa::@7->utoa::@4#2] -- register_copy 
    // utoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [557] utoa::digit#1 = ++ utoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [545] phi from utoa::@4 to utoa::@1 [phi:utoa::@4->utoa::@1]
    // [545] phi utoa::buffer#11 = utoa::buffer#14 [phi:utoa::@4->utoa::@1#0] -- register_copy 
    // [545] phi utoa::started#2 = utoa::started#4 [phi:utoa::@4->utoa::@1#1] -- register_copy 
    // [545] phi utoa::value#2 = utoa::value#6 [phi:utoa::@4->utoa::@1#2] -- register_copy 
    // [545] phi utoa::digit#2 = utoa::digit#1 [phi:utoa::@4->utoa::@1#3] -- register_copy 
    jmp __b1
    // utoa::@5
  __b5:
    // utoa_append(buffer++, value, digit_value)
    // [558] utoa_append::buffer#0 = utoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z utoa_append.buffer
    lda.z buffer+1
    sta.z utoa_append.buffer+1
    // [559] utoa_append::value#0 = utoa::value#2
    // [560] utoa_append::sub#0 = utoa::digit_value#0
    // [561] call utoa_append 
    // [612] phi from utoa::@5 to utoa_append [phi:utoa::@5->utoa_append]
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // [562] utoa_append::return#0 = utoa_append::value#2
    // utoa::@6
    // value = utoa_append(buffer++, value, digit_value)
    // [563] utoa::value#0 = utoa_append::return#0
    // value = utoa_append(buffer++, value, digit_value);
    // [564] utoa::buffer#4 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [556] phi from utoa::@6 to utoa::@4 [phi:utoa::@6->utoa::@4]
    // [556] phi utoa::buffer#14 = utoa::buffer#4 [phi:utoa::@6->utoa::@4#0] -- register_copy 
    // [556] phi utoa::started#4 = 1 [phi:utoa::@6->utoa::@4#1] -- vbuz1=vbuc1 
    lda #1
    sta.z started
    // [556] phi utoa::value#6 = utoa::value#0 [phi:utoa::@6->utoa::@4#2] -- register_copy 
    jmp __b4
  .segment Data
    __10: .byte 0
    __11: .byte 0
}
.segment Code
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp(8) buffer_sign)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label buffer_sign = 8
    // printf_number_buffer::@1
    // if(buffer.sign)
    // [566] if(0==printf_number_buffer::buffer_sign#0) goto printf_number_buffer::@2 -- 0_eq_vbuz1_then_la1 
    lda.z buffer_sign
    beq __b2
    // printf_number_buffer::@3
    // cputc(buffer.sign)
    // [567] cputc::c#2 = printf_number_buffer::buffer_sign#0
    // [568] call cputc 
    // [572] phi from printf_number_buffer::@3 to cputc [phi:printf_number_buffer::@3->cputc]
    // [572] phi cputc::c#3 = cputc::c#2 [phi:printf_number_buffer::@3->cputc#0] -- register_copy 
    jsr cputc
    // [569] phi from printf_number_buffer::@1 printf_number_buffer::@3 to printf_number_buffer::@2 [phi:printf_number_buffer::@1/printf_number_buffer::@3->printf_number_buffer::@2]
    // printf_number_buffer::@2
  __b2:
    // cputs(buffer.digits)
    // [570] call cputs 
    // [505] phi from printf_number_buffer::@2 to cputs [phi:printf_number_buffer::@2->cputs]
    // [505] phi cputs::s#79 = printf_number_buffer::buffer_digits#0 [phi:printf_number_buffer::@2->cputs#0] -- pbuz1=pbuc1 
    lda #<buffer_digits
    sta.z cputs.s
    lda #>buffer_digits
    sta.z cputs.s+1
    jsr cputs
    // printf_number_buffer::@return
    // }
    // [571] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp(8) c)
cputc: {
    .label color = $f
    .label conio_screen_text = $12
    .label conio_map_width = $14
    .label conio_addr = $12
    .label scroll_enable = $16
    .label c = 8
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [573] vera_layer_get_color::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_color.layer
    // [574] call vera_layer_get_color 
    // [619] phi from cputc to vera_layer_get_color [phi:cputc->vera_layer_get_color]
    // [619] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#0 [phi:cputc->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [575] vera_layer_get_color::return#0 = vera_layer_get_color::return#3
    // cputc::@7
    // char color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [576] cputc::color#0 = vera_layer_get_color::return#0
    // unsigned int conio_screen_text = cx16_conio.conio_screen_text
    // [577] cputc::conio_screen_text#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z conio_screen_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z conio_screen_text+1
    // word conio_map_width = cx16_conio.conio_map_width
    // [578] cputc::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [579] cputc::$15 = *((byte*)&cx16_conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta __15
    // unsigned int conio_addr = conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [580] cputc::conio_addr#0 = cputc::conio_screen_text#0 + conio_line_text[cputc::$15] -- vwuz1=vwuz1_plus_pwuc1_derefidx_vbum2 
    tay
    clc
    lda.z conio_addr
    adc conio_line_text,y
    sta.z conio_addr
    lda.z conio_addr+1
    adc conio_line_text+1,y
    sta.z conio_addr+1
    // conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [581] cputc::$2 = conio_cursor_x[*((byte*)&cx16_conio)] << 1 -- vbum1=pbuc1_derefidx_(_deref_pbuc2)_rol_1 
    ldy cx16_conio
    lda conio_cursor_x,y
    asl
    sta __2
    // conio_addr += conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [582] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$2 -- vwuz1=vwuz1_plus_vbum2 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [583] if(cputc::c#3==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [584] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <conio_addr
    // [585] cputc::$4 = < cputc::conio_addr#1 -- vbum1=_lo_vwuz2 
    lda.z conio_addr
    sta __4
    // *VERA_ADDRX_L = <conio_addr
    // [586] *VERA_ADDRX_L = cputc::$4 -- _deref_pbuc1=vbum1 
    // Set address
    sta VERA_ADDRX_L
    // >conio_addr
    // [587] cputc::$5 = > cputc::conio_addr#1 -- vbum1=_hi_vwuz2 
    lda.z conio_addr+1
    sta __5
    // *VERA_ADDRX_M = >conio_addr
    // [588] *VERA_ADDRX_M = cputc::$5 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [589] cputc::$6 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    sta __6
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [590] *VERA_ADDRX_H = cputc::$6 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [591] *VERA_DATA0 = cputc::c#3 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [592] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // conio_cursor_x[cx16_conio.conio_screen_layer]++;
    // [593] conio_cursor_x[*((byte*)&cx16_conio)] = ++ conio_cursor_x[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    ldy cx16_conio
    lda conio_cursor_x,x
    inc
    sta conio_cursor_x,y
    // byte scroll_enable = conio_scroll_enable[cx16_conio.conio_screen_layer]
    // [594] cputc::scroll_enable#0 = conio_scroll_enable[*((byte*)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_scroll_enable,y
    sta.z scroll_enable
    // if(scroll_enable)
    // [595] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuz1_then_la1 
    bne __b5
    // cputc::@3
    // (unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width
    // [596] cputc::$16 = (word)conio_cursor_x[*((byte*)&cx16_conio)] -- vwum1=_word_pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_cursor_x,y
    sta __16
    lda #0
    sta __16+1
    // if((unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width)
    // [597] if(cputc::$16!=cputc::conio_map_width#0) goto cputc::@return -- vwum1_neq_vwuz2_then_la1 
    cmp.z conio_map_width+1
    bne __breturn
    lda __16
    cmp.z conio_map_width
    bne __breturn
    // [598] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [599] call cputln 
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [600] return 
    rts
    // cputc::@5
  __b5:
    // if(conio_cursor_x[cx16_conio.conio_screen_layer] == cx16_conio.conio_screen_width)
    // [601] if(conio_cursor_x[*((byte*)&cx16_conio)]!=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto cputc::@return -- pbuc1_derefidx_(_deref_pbuc2)_neq__deref_pbuc3_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    ldy cx16_conio
    cmp conio_cursor_x,y
    bne __breturn
    // [602] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [603] call cputln 
    jsr cputln
    rts
    // [604] phi from cputc::@7 to cputc::@1 [phi:cputc::@7->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [605] call cputln 
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
    // [606] vera_layer_set_config::addr#0 = *(vera_layer_config+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr = config
    // [607] *vera_layer_set_config::addr#0 = vera_layer_mode_tile::config#10 -- _deref_pbuz1=vbuc1 
    lda #vera_layer_mode_tile.config
    ldy #0
    sta (addr),y
    // vera_layer_set_config::@return
    // }
    // [608] return 
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
    // [609] vera_layer_set_tilebase::addr#0 = *(vera_layer_tilebase+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_tilebase+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_tilebase+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr = tilebase
    // [610] *vera_layer_set_tilebase::addr#0 = ><vera_layer_mode_tile::tilebase_address#0&VERA_LAYER_TILEBASE_MASK -- _deref_pbuz1=vbuc1 
    lda #(>(vera_layer_mode_tile.tilebase_address&$ffff))&VERA_LAYER_TILEBASE_MASK
    ldy #0
    sta (addr),y
    // vera_layer_set_tilebase::@return
    // }
    // [611] return 
    rts
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
// utoa_append(byte* zp($12) buffer, word zp(4) value, word zp($14) sub)
utoa_append: {
    .label buffer = $12
    .label value = 4
    .label sub = $14
    .label return = 4
    .label digit = 8
    // [613] phi from utoa_append to utoa_append::@1 [phi:utoa_append->utoa_append::@1]
    // [613] phi utoa_append::digit#2 = 0 [phi:utoa_append->utoa_append::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z digit
    // [613] phi utoa_append::value#2 = utoa_append::value#0 [phi:utoa_append->utoa_append::@1#1] -- register_copy 
    // utoa_append::@1
  __b1:
    // while (value >= sub)
    // [614] if(utoa_append::value#2>=utoa_append::sub#0) goto utoa_append::@2 -- vwuz1_ge_vwuz2_then_la1 
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
    // [615] *utoa_append::buffer#0 = DIGITS[utoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuz2 
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // utoa_append::@return
    // }
    // [616] return 
    rts
    // utoa_append::@2
  __b2:
    // digit++;
    // [617] utoa_append::digit#1 = ++ utoa_append::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // value -= sub
    // [618] utoa_append::value#1 = utoa_append::value#2 - utoa_append::sub#0 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    // [613] phi from utoa_append::@2 to utoa_append::@1 [phi:utoa_append::@2->utoa_append::@1]
    // [613] phi utoa_append::digit#2 = utoa_append::digit#1 [phi:utoa_append::@2->utoa_append::@1#0] -- register_copy 
    // [613] phi utoa_append::value#2 = utoa_append::value#1 [phi:utoa_append::@2->utoa_append::@1#1] -- register_copy 
    jmp __b1
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
    .label addr = $19
    // byte* addr = vera_layer_config[layer]
    // [620] vera_layer_get_color::$3 = vera_layer_get_color::layer#2 << 1 -- vbum1=vbuz2_rol_1 
    lda.z layer
    asl
    sta __3
    // [621] vera_layer_get_color::addr#0 = vera_layer_config[vera_layer_get_color::$3] -- pbuz1=qbuc1_derefidx_vbum2 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr & VERA_LAYER_CONFIG_256C
    // [622] vera_layer_get_color::$0 = *vera_layer_get_color::addr#0 & VERA_LAYER_CONFIG_256C -- vbum1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C
    ldy #0
    and (addr),y
    sta __0
    // if( *addr & VERA_LAYER_CONFIG_256C )
    // [623] if(0!=vera_layer_get_color::$0) goto vera_layer_get_color::@1 -- 0_neq_vbum1_then_la1 
    bne __b1
    // vera_layer_get_color::@2
    // vera_layer_backcolor[layer] << 4
    // [624] vera_layer_get_color::$1 = vera_layer_backcolor[vera_layer_get_color::layer#2] << 4 -- vbum1=pbuc1_derefidx_vbuz2_rol_4 
    ldy.z layer
    lda vera_layer_backcolor,y
    asl
    asl
    asl
    asl
    sta __1
    // return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
    // [625] vera_layer_get_color::return#2 = vera_layer_get_color::$1 | vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuz1=vbum2_bor_pbuc1_derefidx_vbuz1 
    ldy.z return
    ora vera_layer_textcolor,y
    sta.z return
    // [626] phi from vera_layer_get_color::@1 vera_layer_get_color::@2 to vera_layer_get_color::@return [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return]
    // [626] phi vera_layer_get_color::return#3 = vera_layer_get_color::return#1 [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return#0] -- register_copy 
    // vera_layer_get_color::@return
    // }
    // [627] return 
    rts
    // vera_layer_get_color::@1
  __b1:
    // return (vera_layer_textcolor[layer]);
    // [628] vera_layer_get_color::return#1 = vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuz1=pbuc1_derefidx_vbuz1 
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
    // [629] cputln::$2 = *((byte*)&cx16_conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta __2
    // [630] cputln::temp#0 = conio_line_text[cputln::$2] -- vwuz1=pwuc1_derefidx_vbum2 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda conio_line_text,y
    sta.z temp
    lda conio_line_text+1,y
    sta.z temp+1
    // temp += cx16_conio.conio_rowskip
    // [631] cputln::temp#1 = cputln::temp#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z temp
    sta.z temp
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z temp+1
    sta.z temp+1
    // conio_line_text[cx16_conio.conio_screen_layer] = temp
    // [632] cputln::$3 = *((byte*)&cx16_conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta __3
    // [633] conio_line_text[cputln::$3] = cputln::temp#1 -- pwuc1_derefidx_vbum1=vwuz2 
    tay
    lda.z temp
    sta conio_line_text,y
    lda.z temp+1
    sta conio_line_text+1,y
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [634] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer]++;
    // [635] conio_cursor_y[*((byte*)&cx16_conio)] = ++ conio_cursor_y[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    lda conio_cursor_y,x
    inc
    sta conio_cursor_y,y
    // cscroll()
    // [636] call cscroll 
    jsr cscroll
    // cputln::@return
    // }
    // [637] return 
    rts
  .segment Data
    __2: .byte 0
    __3: .byte 0
}
.segment Code
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [638] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    ldy cx16_conio
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b3
    // cscroll::@1
    // if(conio_scroll_enable[cx16_conio.conio_screen_layer])
    // [639] if(0!=conio_scroll_enable[*((byte*)&cx16_conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    lda conio_scroll_enable,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [640] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    // [641] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
  __b3:
    // cscroll::@return
    // }
    // [642] return 
    rts
    // [643] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [644] call insertup 
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, cx16_conio.conio_screen_height-1)
    // [645] gotoxy::y#2 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    stx.z gotoxy.y
    // [646] call gotoxy 
    // [447] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [447] phi gotoxy::y#4 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    jsr gotoxy
    // [647] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [648] call clearline 
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
    // [649] insertup::cy#0 = conio_cursor_y[*((byte*)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy cx16_conio
    lda conio_cursor_y,y
    sta.z cy
    // unsigned byte width = cx16_conio.conio_screen_width * 2
    // [650] insertup::width#0 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    asl
    sta.z width
    // [651] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [651] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z i
    // insertup::@1
  __b1:
    // for(unsigned byte i=1; i<=cy; i++)
    // [652] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuz1_le_vbuz2_then_la1 
    lda.z cy
    cmp.z i
    bcs __b2
    // [653] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [654] call clearline 
    jsr clearline
    // insertup::@return
    // }
    // [655] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [656] insertup::$3 = insertup::i#2 - 1 -- vbum1=vbuz2_minus_1 
    ldx.z i
    dex
    stx __3
    // unsigned int line = (i-1) << cx16_conio.conio_rowshift
    // [657] insertup::line#0 = insertup::$3 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vbum2_rol__deref_pbuc1 
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
    // [658] insertup::start#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) + insertup::line#0 -- vwuz1=_deref_pwuc1_plus_vwuz1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    adc.z start
    sta.z start
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    adc.z start+1
    sta.z start+1
    // cx16_cpy_vram_from_vram_inc(0, start, VERA_INC_1, 0, start+cx16_conio.conio_rowskip, VERA_INC_1, width)
    // [659] cx16_cpy_vram_from_vram_inc::soffset_vram#0 = insertup::start#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz2_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z start
    sta.z cx16_cpy_vram_from_vram_inc.soffset_vram
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z start+1
    sta.z cx16_cpy_vram_from_vram_inc.soffset_vram+1
    // [660] cx16_cpy_vram_from_vram_inc::doffset_vram#0 = insertup::start#0
    // [661] cx16_cpy_vram_from_vram_inc::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z cx16_cpy_vram_from_vram_inc.num
    lda #0
    sta.z cx16_cpy_vram_from_vram_inc.num+1
    // [662] call cx16_cpy_vram_from_vram_inc 
    // [685] phi from insertup::@2 to cx16_cpy_vram_from_vram_inc [phi:insertup::@2->cx16_cpy_vram_from_vram_inc]
    jsr cx16_cpy_vram_from_vram_inc
    // insertup::@4
    // for(unsigned byte i=1; i<=cy; i++)
    // [663] insertup::i#1 = ++ insertup::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [651] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [651] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
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
    .label c = $14
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [664] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // word conio_screen_text =  (word)cx16_conio.conio_screen_text
    // [665] clearline::conio_screen_text#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- vwuz1=_deref_pwuc1 
    // Set address
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z conio_screen_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z conio_screen_text+1
    // word conio_line = conio_line_text[cx16_conio.conio_screen_layer]
    // [666] clearline::$5 = *((byte*)&cx16_conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta __5
    // [667] clearline::conio_line#0 = conio_line_text[clearline::$5] -- vwuz1=pwuc1_derefidx_vbum2 
    tay
    lda conio_line_text,y
    sta.z conio_line
    lda conio_line_text+1,y
    sta.z conio_line+1
    // conio_screen_text + conio_line
    // [668] clearline::addr#0 = clearline::conio_screen_text#0 + clearline::conio_line#0 -- vwuz1=vwuz1_plus_vwuz2 
    lda.z addr
    clc
    adc.z conio_line
    sta.z addr
    lda.z addr+1
    adc.z conio_line+1
    sta.z addr+1
    // <addr
    // [669] clearline::$1 = < (byte*)clearline::addr#0 -- vbum1=_lo_pbuz2 
    lda.z addr
    sta __1
    // *VERA_ADDRX_L = <addr
    // [670] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // >addr
    // [671] clearline::$2 = > (byte*)clearline::addr#0 -- vbum1=_hi_pbuz2 
    lda.z addr+1
    sta __2
    // *VERA_ADDRX_M = >addr
    // [672] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [673] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [674] vera_layer_get_color::layer#1 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_color.layer
    // [675] call vera_layer_get_color 
    // [619] phi from clearline to vera_layer_get_color [phi:clearline->vera_layer_get_color]
    // [619] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#1 [phi:clearline->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [676] vera_layer_get_color::return#4 = vera_layer_get_color::return#3
    // clearline::@4
    // char color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [677] clearline::color#0 = vera_layer_get_color::return#4
    // [678] phi from clearline::@4 to clearline::@1 [phi:clearline::@4->clearline::@1]
    // [678] phi clearline::c#2 = 0 [phi:clearline::@4->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [679] if(clearline::c#2<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto clearline::@2 -- vwuz1_lt__deref_pbuc1_then_la1 
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
    // [680] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // clearline::@return
    // }
    // [681] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [682] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [683] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [684] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [678] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [678] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
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
    .label i = $14
    .label doffset_vram = $1d
    .label soffset_vram = $1f
    .label num = $21
    // cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [686] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [687] cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$0 = < cx16_cpy_vram_from_vram_inc::soffset_vram#0 -- vbum1=_byte0_vwuz2 
    lda.z soffset_vram
    sta vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [688] *VERA_ADDRX_L = cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [689] cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$1 = > cx16_cpy_vram_from_vram_inc::soffset_vram#0 -- vbum1=_byte1_vwuz2 
    lda.z soffset_vram+1
    sta vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [690] *VERA_ADDRX_M = cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [691] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1
    // *VERA_CTRL |= VERA_ADDRSEL
    // [692] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [693] cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$0 = < cx16_cpy_vram_from_vram_inc::doffset_vram#0 -- vbum1=_byte0_vwuz2 
    lda.z doffset_vram
    sta vera_vram_data1_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [694] *VERA_ADDRX_L = cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [695] cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$1 = > cx16_cpy_vram_from_vram_inc::doffset_vram#0 -- vbum1=_byte1_vwuz2 
    lda.z doffset_vram+1
    sta vera_vram_data1_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [696] *VERA_ADDRX_M = cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [697] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // [698] phi from cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1 to cx16_cpy_vram_from_vram_inc::@1 [phi:cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1->cx16_cpy_vram_from_vram_inc::@1]
    // [698] phi cx16_cpy_vram_from_vram_inc::i#2 = 0 [phi:cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1->cx16_cpy_vram_from_vram_inc::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // cx16_cpy_vram_from_vram_inc::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [699] if(cx16_cpy_vram_from_vram_inc::i#2<cx16_cpy_vram_from_vram_inc::num#0) goto cx16_cpy_vram_from_vram_inc::@2 -- vwuz1_lt_vwuz2_then_la1 
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
    // [700] return 
    rts
    // cx16_cpy_vram_from_vram_inc::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [701] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [702] cx16_cpy_vram_from_vram_inc::i#1 = ++ cx16_cpy_vram_from_vram_inc::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [698] phi from cx16_cpy_vram_from_vram_inc::@2 to cx16_cpy_vram_from_vram_inc::@1 [phi:cx16_cpy_vram_from_vram_inc::@2->cx16_cpy_vram_from_vram_inc::@1]
    // [698] phi cx16_cpy_vram_from_vram_inc::i#2 = cx16_cpy_vram_from_vram_inc::i#1 [phi:cx16_cpy_vram_from_vram_inc::@2->cx16_cpy_vram_from_vram_inc::@1#0] -- register_copy 
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
