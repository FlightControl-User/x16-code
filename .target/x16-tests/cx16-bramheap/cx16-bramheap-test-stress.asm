  // File Comments
  // Upstart
.cpu _65c02
  .file                               [name="cx16-bramheap-test-stress.prg", type="prg", segments="Program"]
.segmentdef Program                 [segments="Basic, Code, Data, CodeBramHeap, DataBramHeap"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=$80d]
.segmentdef CodeBramHeap            [startAfter="Code"]
.segmentdef Data                    [startAfter="CodeBramHeap"]
.segmentdef DataBramHeap            [start=$6000, min=$6000, max=$9FFF, align=$100]
.segmentdef BramBramHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]

.segment Basic
:BasicUpstart(__start)
.segment Code

  // Global Constants & labels
  .const WHITE = 1
  .const BLUE = 6
  ///< Read a character from the current channel for input.
  .const CBM_GETIN = $ffe4
  ///< Close a logical file.
  .const CBM_CLRCHN = $ffcc
  ///< Load a logical file.
  .const CBM_PLOT = $fff0
  ///< CX16 Set/Get screen mode.
  .const CX16_SCREEN_SET_CHARSET = $ff62
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_MASK = $c0
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .const isr_vsync = $314
  .const SIZEOF_STRUCT___1 = $8f
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
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __start
// void __start()
__start: {
    // __start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // [3] phi from __start::__init1 to __start::@2 [phi:__start::__init1->__start::@2]
    // __start::@2
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [4] call conio_x16_init
    // [20] phi from __start::@2 to conio_x16_init [phi:__start::@2->conio_x16_init]
    jsr conio_x16_init
    // [5] phi from __start::@2 to __start::@1 [phi:__start::@2->__start::@1]
    // __start::@1
    // [6] call __lib_bramheap_start
    // [72] phi from __start::@1 to __lib_bramheap_start [phi:__start::@1->__lib_bramheap_start]
    jsr lib_bramheap.__lib_bramheap_start
    // [7] phi from __start::@1 to __start::@3 [phi:__start::@1->__start::@3]
    // __start::@3
    // [8] call main
    jsr main
    // __start::@return
    // [9] return 
    rts
}
  // conio_x16_init
/// Set initial screen values.
// void conio_x16_init()
conio_x16_init: {
    // screenlayer1()
    // [21] call screenlayer1
    jsr screenlayer1
    // [22] phi from conio_x16_init to conio_x16_init::@1 [phi:conio_x16_init->conio_x16_init::@1]
    // conio_x16_init::@1
    // textcolor(CONIO_TEXTCOLOR_DEFAULT)
    // [23] call textcolor
    jsr textcolor
    // [24] phi from conio_x16_init::@1 to conio_x16_init::@2 [phi:conio_x16_init::@1->conio_x16_init::@2]
    // conio_x16_init::@2
    // bgcolor(CONIO_BACKCOLOR_DEFAULT)
    // [25] call bgcolor
    jsr bgcolor
    // [26] phi from conio_x16_init::@2 to conio_x16_init::@3 [phi:conio_x16_init::@2->conio_x16_init::@3]
    // conio_x16_init::@3
    // cursor(0)
    // [27] call cursor
    jsr cursor
    // [28] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // cbm_k_plot_get()
    // [29] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [30] cbm_k_plot_get::return#2 = cbm_k_plot_get::return#0
    // conio_x16_init::@5
    // [31] conio_x16_init::$4 = cbm_k_plot_get::return#2
    // BYTE1(cbm_k_plot_get())
    // [32] conio_x16_init::$5 = byte1  conio_x16_init::$4 -- vbum1=_byte1_vwum2 
    lda conio_x16_init__4+1
    sta conio_x16_init__5
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [33] *((char *)&__conio) = conio_x16_init::$5 -- _deref_pbuc1=vbum1 
    sta __conio
    // cbm_k_plot_get()
    // [34] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [35] cbm_k_plot_get::return#3 = cbm_k_plot_get::return#0
    // conio_x16_init::@6
    // [36] conio_x16_init::$6 = cbm_k_plot_get::return#3
    // BYTE0(cbm_k_plot_get())
    // [37] conio_x16_init::$7 = byte0  conio_x16_init::$6 -- vbum1=_byte0_vwum2 
    lda conio_x16_init__6
    sta conio_x16_init__7
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [38] *((char *)&__conio+1) = conio_x16_init::$7 -- _deref_pbuc1=vbum1 
    sta __conio+1
    // gotoxy(__conio.cursor_x, __conio.cursor_y)
    // [39] gotoxy::x#0 = *((char *)&__conio) -- vbum1=_deref_pbuc1 
    lda __conio
    sta gotoxy.x
    // [40] gotoxy::y#0 = *((char *)&__conio+1) -- vbum1=_deref_pbuc1 
    lda __conio+1
    sta gotoxy.y
    // [41] call gotoxy
    // [187] phi from conio_x16_init::@6 to gotoxy [phi:conio_x16_init::@6->gotoxy]
    // [187] phi gotoxy::y#10 = gotoxy::y#0 [phi:conio_x16_init::@6->gotoxy#0] -- register_copy 
    // [187] phi gotoxy::x#7 = gotoxy::x#0 [phi:conio_x16_init::@6->gotoxy#1] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@7
    // __conio.scroll[0] = 1
    // [42] *((char *)&__conio+$f) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta __conio+$f
    // __conio.scroll[1] = 1
    // [43] *((char *)&__conio+$f+1) = 1 -- _deref_pbuc1=vbuc2 
    sta __conio+$f+1
    // conio_x16_init::@return
    // }
    // [44] return 
    rts
  .segment Data
    .label conio_x16_init__4 = screenlayer.mapbase_offset
    conio_x16_init__5: .byte 0
    .label conio_x16_init__6 = screenlayer.mapbase_offset
    .label conio_x16_init__7 = conio_x16_init__5
}
.segment Code
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__mem() char c)
cputc: {
    .const OFFSET_STACK_C = 0
    // [45] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta c
    // if(c=='\n')
    // [46] if(cputc::c#0==' ') goto cputc::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [47] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(__conio.offset)
    // [48] cputc::$1 = byte0  *((unsigned int *)&__conio+$13) -- vbum1=_byte0__deref_pwuc1 
    lda __conio+$13
    sta cputc__1
    // *VERA_ADDRX_L = BYTE0(__conio.offset)
    // [49] *VERA_ADDRX_L = cputc::$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(__conio.offset)
    // [50] cputc::$2 = byte1  *((unsigned int *)&__conio+$13) -- vbum1=_byte1__deref_pwuc1 
    lda __conio+$13+1
    sta cputc__2
    // *VERA_ADDRX_M = BYTE1(__conio.offset)
    // [51] *VERA_ADDRX_M = cputc::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [52] cputc::$3 = *((char *)&__conio+5) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    sta cputc__3
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [53] *VERA_ADDRX_H = cputc::$3 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [54] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbum1 
    lda c
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [55] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // if(!__conio.hscroll[__conio.layer])
    // [56] if(0==((char *)&__conio+$11)[*((char *)&__conio+2)]) goto cputc::@5 -- 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$11,y
    cmp #0
    beq __b5
    // cputc::@3
    // if(__conio.cursor_x >= __conio.mapwidth)
    // [57] if(*((char *)&__conio)>=*((char *)&__conio+8)) goto cputc::@6 -- _deref_pbuc1_ge__deref_pbuc2_then_la1 
    lda __conio
    cmp __conio+8
    bcs __b6
    // cputc::@4
    // __conio.cursor_x++;
    // [58] *((char *)&__conio) = ++ *((char *)&__conio) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio
    // cputc::@7
  __b7:
    // __conio.offset++;
    // [59] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // [60] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // cputc::@return
    // }
    // [61] return 
    rts
    // [62] phi from cputc::@3 to cputc::@6 [phi:cputc::@3->cputc::@6]
    // cputc::@6
  __b6:
    // cputln()
    // [63] call cputln
    jsr cputln
    jmp __b7
    // cputc::@5
  __b5:
    // if(__conio.cursor_x >= __conio.width)
    // [64] if(*((char *)&__conio)>=*((char *)&__conio+6)) goto cputc::@8 -- _deref_pbuc1_ge__deref_pbuc2_then_la1 
    lda __conio
    cmp __conio+6
    bcs __b8
    // cputc::@9
    // __conio.cursor_x++;
    // [65] *((char *)&__conio) = ++ *((char *)&__conio) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio
    // __conio.offset++;
    // [66] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // [67] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    rts
    // [68] phi from cputc::@5 to cputc::@8 [phi:cputc::@5->cputc::@8]
    // cputc::@8
  __b8:
    // cputln()
    // [69] call cputln
    jsr cputln
    rts
    // [70] phi from cputc to cputc::@1 [phi:cputc->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [71] call cputln
    jsr cputln
    rts
  .segment Data
    .label cputc__1 = memcpy8_vram_vram.num8_1
    .label cputc__2 = memcpy8_vram_vram.num8_1
    .label cputc__3 = memcpy8_vram_vram.num8_1
    .label c = insertup.y
}
.segment Code
  // main
// void main()
main: {
    .label cx16_k_screen_set_charset1_offset = $2e
    .label main__37 = $2c
    .label main__40 = $2a
    .label main__41 = $2a
    // cx16_k_screen_set_charset(3,0)
    // [74] main::cx16_k_screen_set_charset1_charset = 3 -- vbum1=vbuc1 
    lda #3
    sta cx16_k_screen_set_charset1_charset
    // [75] main::cx16_k_screen_set_charset1_offset = 0 -- pbuz1=vbuc1 
    lda #<0
    sta.z cx16_k_screen_set_charset1_offset
    sta.z cx16_k_screen_set_charset1_offset+1
    // main::cx16_k_screen_set_charset1
    // asm
    // asm { ldacharset ldx<offset ldy>offset jsrCX16_SCREEN_SET_CHARSET  }
    lda cx16_k_screen_set_charset1_charset
    ldx.z <cx16_k_screen_set_charset1_offset
    ldy.z >cx16_k_screen_set_charset1_offset
    jsr CX16_SCREEN_SET_CHARSET
    // main::@8
    // bram_heap_bram_bank_init(1)
    // [77] bram_heap_bram_bank_init::bram_bank = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_bramheap.bram_heap_bram_bank_init.bram_bank
    // [78] callexecute bram_heap_bram_bank_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_bram_bank_init
    // bram_heap_segment_index_t segment = bram_heap_segment_init(1, 16, (bram_ptr_t)0xA000, 64, (bram_ptr_t)0xA000)
    // [79] bram_heap_segment_init::s = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_bramheap.bram_heap_segment_init.s
    // [80] bram_heap_segment_init::bram_bank_floor = $10 -- vbum1=vbuc1 
    lda #$10
    sta lib_bramheap.bram_heap_segment_init.bram_bank_floor
    // [81] bram_heap_segment_init::bram_ptr_floor = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor+1
    // [82] bram_heap_segment_init::bram_bank_ceil = $40 -- vbum1=vbuc1 
    lda #$40
    sta lib_bramheap.bram_heap_segment_init.bram_bank_ceil
    // [83] bram_heap_segment_init::bram_ptr_ceil = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil+1
    // [84] callexecute bram_heap_segment_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_segment_init
    // [85] main::segment#0 = bram_heap_segment_init::return -- vbum1=vbum2 
    lda lib_bramheap.bram_heap_segment_init.return
    sta segment
    // [86] phi from main::@28 main::@8 to main::@1 [phi:main::@28/main::@8->main::@1]
    // main::@1
  __b1:
    // kbhit()
    // [87] call kbhit
    // [210] phi from main::@1 to kbhit [phi:main::@1->kbhit]
    jsr kbhit
    // kbhit()
    // [88] kbhit::return#2 = kbhit::return#0
    // main::@9
    // [89] main::$3 = kbhit::return#2 -- vbum1=vbum2 
    lda kbhit.return
    sta main__3
    // while(!kbhit())
    // [90] if(0==main::$3) goto main::@2 -- 0_eq_vbum1_then_la1 
    beq __b2
    // main::@return
    // }
    // [91] return 
    rts
    // [92] phi from main::@9 to main::@2 [phi:main::@9->main::@2]
    // main::@2
  __b2:
    // clrscr()
    // [93] call clrscr
    jsr clrscr
    // [94] phi from main::@2 to main::@10 [phi:main::@2->main::@10]
    // main::@10
    // gotoxy(0, 0)
    // [95] call gotoxy
    // [187] phi from main::@10 to gotoxy [phi:main::@10->gotoxy]
    // [187] phi gotoxy::y#10 = 0 [phi:main::@10->gotoxy#0] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.y
    // [187] phi gotoxy::x#7 = 0 [phi:main::@10->gotoxy#1] -- vbum1=vbuc1 
    sta gotoxy.x
    jsr gotoxy
    // [96] phi from main::@10 to main::@11 [phi:main::@10->main::@11]
    // main::@11
    // printf("Before Dump")
    // [97] call printf_str
    // [240] phi from main::@11 to printf_str [phi:main::@11->printf_str]
    // [240] phi printf_str::putc#10 = &cputc [phi:main::@11->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [240] phi printf_str::s#10 = main::s1 [phi:main::@11->printf_str#1] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // main::@12
    // bram_heap_dump(segment, 0, 2)
    // [98] bram_heap_dump::s = main::segment#0 -- vbum1=vbum2 
    lda segment
    sta lib_bramheap.bram_heap_dump.s
    // [99] bram_heap_dump::x = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_bramheap.bram_heap_dump.x
    // [100] bram_heap_dump::y = 2 -- vbum1=vbuc1 
    lda #2
    sta lib_bramheap.bram_heap_dump.y
    // [101] callexecute bram_heap_dump  -- call_var_near 
    jsr lib_bramheap.bram_heap_dump
    // printf("\n\n")
    // [102] call printf_str
    // [240] phi from main::@12 to printf_str [phi:main::@12->printf_str]
    // [240] phi printf_str::putc#10 = &cputc [phi:main::@12->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [240] phi printf_str::s#10 = main::s2 [phi:main::@12->printf_str#1] -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // [103] phi from main::@12 to main::@13 [phi:main::@12->main::@13]
    // main::@13
    // rand()
    // [104] call rand
    jsr rand
    // [105] rand::return#2 = rand::return#0
    // main::@14
    // [106] main::$10 = rand::return#2 -- vwum1=vwum2 
    lda rand.return
    sta main__10
    lda rand.return+1
    sta main__10+1
    // unsigned int h = rand() % 32
    // [107] main::h#0 = main::$10 & $20-1 -- vwum1=vwum1_band_vbuc1 
    lda #$20-1
    and h
    sta h
    lda #0
    sta h+1
    // rand()
    // [108] call rand
    jsr rand
    // [109] rand::return#3 = rand::return#0
    // main::@15
    // [110] main::$12 = rand::return#3 -- vwum1=vwum2 
    lda rand.return
    sta main__12
    lda rand.return+1
    sta main__12+1
    // rand() % 16
    // [111] main::$13 = main::$12 & $10-1 -- vwum1=vwum1_band_vbuc1 
    lda #$10-1
    and main__13
    sta main__13
    lda #0
    sta main__13+1
    // h += rand() % 16
    // [112] main::h#1 = main::h#0 + main::$13 -- vwum1=vwum1_plus_vwum2 
    clc
    lda h
    adc main__13
    sta h
    lda h+1
    adc main__13+1
    sta h+1
    // if(!segment_handles[h])
    // [113] main::$37 = main::segment_handles + main::h#1 -- pbuz1=pbuc1_plus_vwum2 
    lda h
    clc
    adc #<segment_handles
    sta.z main__37
    lda h+1
    adc #>segment_handles
    sta.z main__37+1
    // [114] if(0==*main::$37) goto main::@4 -- 0_eq__deref_pbuz1_then_la1 
    ldy #0
    lda (main__37),y
    cmp #0
    bne !__b4+
    jmp __b4
  !__b4:
    // [115] phi from main::@15 to main::@7 [phi:main::@15->main::@7]
    // main::@7
    // gotoxy(0,50)
    // [116] call gotoxy
    // [187] phi from main::@7 to gotoxy [phi:main::@7->gotoxy]
    // [187] phi gotoxy::y#10 = $32 [phi:main::@7->gotoxy#0] -- vbum1=vbuc1 
    lda #$32
    sta gotoxy.y
    // [187] phi gotoxy::x#7 = 0 [phi:main::@7->gotoxy#1] -- vbum1=vbuc1 
    tya
    sta gotoxy.x
    jsr gotoxy
    // [117] phi from main::@7 to main::@16 [phi:main::@7->main::@16]
    // main::@16
    // printf("Free handle %03x from segment 2\n\n", segment_handles[h])
    // [118] call printf_str
    // [240] phi from main::@16 to printf_str [phi:main::@16->printf_str]
    // [240] phi printf_str::putc#10 = &cputc [phi:main::@16->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [240] phi printf_str::s#10 = main::s3 [phi:main::@16->printf_str#1] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // main::@17
    // printf("Free handle %03x from segment 2\n\n", segment_handles[h])
    // [119] printf_uchar::uvalue#0 = *main::$37 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (main__37),y
    sta printf_uchar.uvalue
    // [120] call printf_uchar
    // [257] phi from main::@17 to printf_uchar [phi:main::@17->printf_uchar]
    jsr printf_uchar
    // [121] phi from main::@17 to main::@18 [phi:main::@17->main::@18]
    // main::@18
    // printf("Free handle %03x from segment 2\n\n", segment_handles[h])
    // [122] call printf_str
    // [240] phi from main::@18 to printf_str [phi:main::@18->printf_str]
    // [240] phi printf_str::putc#10 = &cputc [phi:main::@18->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [240] phi printf_str::s#10 = main::s4 [phi:main::@18->printf_str#1] -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // main::@19
    // bram_heap_free(segment, segment_handles[h])
    // [123] bram_heap_free::s = main::segment#0 -- vbum1=vbum2 
    lda segment
    sta lib_bramheap.bram_heap_free.s
    // [124] bram_heap_free::free_index = *main::$37 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (main__37),y
    sta lib_bramheap.bram_heap_free.free_index
    // [125] callexecute bram_heap_free  -- call_var_near 
    jsr lib_bramheap.bram_heap_free
    // segment_handles[h] = 0
    // [126] *main::$37 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (main__37),y
    // [127] phi from main::@19 main::@27 to main::@3 [phi:main::@19/main::@27->main::@3]
    // main::@3
  __b3:
    // gotoxy(40, 0)
    // [128] call gotoxy
    // [187] phi from main::@3 to gotoxy [phi:main::@3->gotoxy]
    // [187] phi gotoxy::y#10 = 0 [phi:main::@3->gotoxy#0] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.y
    // [187] phi gotoxy::x#7 = $28 [phi:main::@3->gotoxy#1] -- vbum1=vbuc1 
    lda #$28
    sta gotoxy.x
    jsr gotoxy
    // [129] phi from main::@3 to main::@20 [phi:main::@3->main::@20]
    // main::@20
    // printf("After Dump")
    // [130] call printf_str
    // [240] phi from main::@20 to printf_str [phi:main::@20->printf_str]
    // [240] phi printf_str::putc#10 = &cputc [phi:main::@20->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [240] phi printf_str::s#10 = main::s5 [phi:main::@20->printf_str#1] -- pbuz1=pbuc1 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // main::@21
    // bram_heap_dump(segment, 40, 2)
    // [131] bram_heap_dump::s = main::segment#0 -- vbum1=vbum2 
    lda segment
    sta lib_bramheap.bram_heap_dump.s
    // [132] bram_heap_dump::x = $28 -- vbum1=vbuc1 
    lda #$28
    sta lib_bramheap.bram_heap_dump.x
    // [133] bram_heap_dump::y = 2 -- vbum1=vbuc1 
    lda #2
    sta lib_bramheap.bram_heap_dump.y
    // [134] callexecute bram_heap_dump  -- call_var_near 
    jsr lib_bramheap.bram_heap_dump
    // [135] phi from main::@21 main::@28 to main::@6 [phi:main::@21/main::@28->main::@6]
    // main::@6
  __b6:
    // kbhit()
    // [136] call kbhit
    // [210] phi from main::@6 to kbhit [phi:main::@6->kbhit]
    jsr kbhit
    // kbhit()
    // [137] kbhit::return#3 = kbhit::return#0
    // main::@28
    // [138] main::$29 = kbhit::return#3 -- vbum1=vbum2 
    lda kbhit.return
    sta main__29
    // while(!kbhit())
    // [139] if(0==main::$29) goto main::@6 -- 0_eq_vbum1_then_la1 
    beq __b6
    jmp __b1
    // [140] phi from main::@15 main::@23 to main::@4 [phi:main::@15/main::@23->main::@4]
    // main::@4
  __b4:
    // rand()
    // [141] call rand
    jsr rand
    // [142] rand::return#4 = rand::return#0
    // main::@22
    // [143] main::$18 = rand::return#4 -- vwum1=vwum2 
    lda rand.return
    sta main__18
    lda rand.return+1
    sta main__18+1
    // s = rand() % 1
    // [144] main::s#1 = main::$18 & 0 -- vwum1=vwum1_band_vbuc1 
    lda #0
    and s
    sta s
    lda #0
    sta s+1
    // w = weight[s]
    // [145] main::$40 = main::weight + main::s#1 -- pbuz1=pbuc1_plus_vwum2 
    lda s
    clc
    adc #<weight
    sta.z main__40
    lda s+1
    adc #>weight
    sta.z main__40+1
    // [146] main::w#1 = *main::$40 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (main__40),y
    sta w
    // rand()
    // [147] call rand
    jsr rand
    // [148] rand::return#10 = rand::return#0
    // main::@23
    // [149] main::$20 = rand::return#10 -- vwum1=vwum2 
    lda rand.return
    sta main__20
    lda rand.return+1
    sta main__20+1
    // rand() % 256
    // [150] main::$21 = main::$20 & $100-1 -- vwum1=vwum1_band_vwuc1 
    lda main__21
    and #<$100-1
    sta main__21
    lda main__21+1
    and #>$100-1
    sta main__21+1
    // (unsigned char)(rand() % 256) > w
    // [151] main::$32 = (char)main::$21 -- vbum1=_byte_vwum2 
    lda main__21
    sta main__32
    // while((unsigned char)(rand() % 256) > w)
    // [152] if(main::$32>main::w#1) goto main::@4 -- vbum1_gt_vbum2_then_la1 
    lda w
    cmp main__32
    bcc __b4
    // main::@5
    // unsigned int bytes = sizes[s]
    // [153] main::$31 = main::s#1 << 1 -- vwum1=vwum1_rol_1 
    asl main__31
    rol main__31+1
    // [154] main::$41 = main::sizes + main::$31 -- pwuz1=pwuc1_plus_vwum2 
    lda main__31
    clc
    adc #<sizes
    sta.z main__41
    lda main__31+1
    adc #>sizes
    sta.z main__41+1
    // [155] main::bytes#0 = *main::$41 -- vwum1=_deref_pwuz2 
    ldy #0
    lda (main__41),y
    sta bytes
    iny
    lda (main__41),y
    sta bytes+1
    // gotoxy(0,50)
    // [156] call gotoxy
    // [187] phi from main::@5 to gotoxy [phi:main::@5->gotoxy]
    // [187] phi gotoxy::y#10 = $32 [phi:main::@5->gotoxy#0] -- vbum1=vbuc1 
    lda #$32
    sta gotoxy.y
    // [187] phi gotoxy::x#7 = 0 [phi:main::@5->gotoxy#1] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.x
    jsr gotoxy
    // [157] phi from main::@5 to main::@24 [phi:main::@5->main::@24]
    // main::@24
    // printf("Allocate %u bytes in segment 2\n\n", bytes)
    // [158] call printf_str
    // [240] phi from main::@24 to printf_str [phi:main::@24->printf_str]
    // [240] phi printf_str::putc#10 = &cputc [phi:main::@24->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [240] phi printf_str::s#10 = main::s6 [phi:main::@24->printf_str#1] -- pbuz1=pbuc1 
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    jsr printf_str
    // main::@25
    // printf("Allocate %u bytes in segment 2\n\n", bytes)
    // [159] printf_uint::uvalue#0 = main::bytes#0 -- vwum1=vwum2 
    lda bytes
    sta printf_uint.uvalue
    lda bytes+1
    sta printf_uint.uvalue+1
    // [160] call printf_uint
    // [264] phi from main::@25 to printf_uint [phi:main::@25->printf_uint]
    jsr printf_uint
    // [161] phi from main::@25 to main::@26 [phi:main::@25->main::@26]
    // main::@26
    // printf("Allocate %u bytes in segment 2\n\n", bytes)
    // [162] call printf_str
    // [240] phi from main::@26 to printf_str [phi:main::@26->printf_str]
    // [240] phi printf_str::putc#10 = &cputc [phi:main::@26->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [240] phi printf_str::s#10 = main::s7 [phi:main::@26->printf_str#1] -- pbuz1=pbuc1 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // main::@27
    // bram_heap_alloc(segment, bytes)
    // [163] bram_heap_alloc::s = main::segment#0 -- vbum1=vbum2 
    lda segment
    sta lib_bramheap.bram_heap_alloc.s
    // [164] bram_heap_alloc::size = main::bytes#0 -- vdum1=vwum2 
    lda bytes
    sta lib_bramheap.bram_heap_alloc.size
    lda bytes+1
    sta lib_bramheap.bram_heap_alloc.size+1
    lda #0
    sta lib_bramheap.bram_heap_alloc.size+2
    sta lib_bramheap.bram_heap_alloc.size+3
    // [165] callexecute bram_heap_alloc  -- call_var_near 
    jsr lib_bramheap.bram_heap_alloc
    // [166] main::$25 = bram_heap_alloc::return -- vbum1=vbum2 
    lda lib_bramheap.bram_heap_alloc.return
    sta main__25
    // segment_handles[h] = bram_heap_alloc(segment, bytes)
    // [167] *main::$37 = main::$25 -- _deref_pbuz1=vbum2 
    ldy #0
    sta (main__37),y
    jmp __b3
  .segment DataBramHeap
    segment_handles: .fill $100, 0
    weight: .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    sizes: .word $2000, $100, $200, $400, $800, $1000, $2000, $4000
    s1: .text "Before Dump"
    .byte 0
    s2: .text @"\n\n"
    .byte 0
    s3: .text "Free handle "
    .byte 0
    s4: .text @" from segment 2\n\n"
    .byte 0
    s5: .text "After Dump"
    .byte 0
    s6: .text "Allocate "
    .byte 0
    s7: .text @" bytes in segment 2\n\n"
    .byte 0
    main__3: .byte 0
    main__10: .word 0
    main__12: .word 0
    .label main__13 = main__12
    .label main__18 = main__12
    .label main__20 = main__10
    .label main__21 = main__10
    .label main__25 = main__3
    .label main__29 = main__3
    .label main__31 = main__12
    main__32: .byte 0
  .segment Data
    cx16_k_screen_set_charset1_charset: .byte 0
  .segment DataBramHeap
    segment: .byte 0
    .label h = main__10
    .label s = main__12
    .label w = main__3
    .label bytes = main__10
}
.segment Code
  // screenlayer1
// Set the layer with which the conio will interact.
// void screenlayer1()
screenlayer1: {
    // screenlayer(1, *VERA_L1_MAPBASE, *VERA_L1_CONFIG)
    // [168] screenlayer::mapbase#0 = *VERA_L1_MAPBASE -- vbum1=_deref_pbuc1 
    lda VERA_L1_MAPBASE
    sta screenlayer.mapbase
    // [169] screenlayer::config#0 = *VERA_L1_CONFIG -- vbum1=_deref_pbuc1 
    lda VERA_L1_CONFIG
    sta screenlayer.config
    // [170] call screenlayer
    jsr screenlayer
    // screenlayer1::@return
    // }
    // [171] return 
    rts
}
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char textcolor(char color)
textcolor: {
    // __conio.color & 0xF0
    // [172] textcolor::$0 = *((char *)&__conio+$d) & $f0 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and __conio+$d
    sta textcolor__0
    // __conio.color & 0xF0 | color
    // [173] textcolor::$1 = textcolor::$0 | WHITE -- vbum1=vbum1_bor_vbuc1 
    lda #WHITE
    ora textcolor__1
    sta textcolor__1
    // __conio.color = __conio.color & 0xF0 | color
    // [174] *((char *)&__conio+$d) = textcolor::$1 -- _deref_pbuc1=vbum1 
    sta __conio+$d
    // textcolor::@return
    // }
    // [175] return 
    rts
  .segment Data
    .label textcolor__0 = conio_x16_init.conio_x16_init__5
    .label textcolor__1 = conio_x16_init.conio_x16_init__5
}
.segment Code
  // bgcolor
// Set the back color for text output.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor(char color)
bgcolor: {
    // __conio.color & 0x0F
    // [176] bgcolor::$0 = *((char *)&__conio+$d) & $f -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$f
    and __conio+$d
    sta bgcolor__0
    // __conio.color & 0x0F | color << 4
    // [177] bgcolor::$2 = bgcolor::$0 | BLUE<<4 -- vbum1=vbum1_bor_vbuc1 
    lda #BLUE<<4
    ora bgcolor__2
    sta bgcolor__2
    // __conio.color = __conio.color & 0x0F | color << 4
    // [178] *((char *)&__conio+$d) = bgcolor::$2 -- _deref_pbuc1=vbum1 
    sta __conio+$d
    // bgcolor::@return
    // }
    // [179] return 
    rts
  .segment Data
    .label bgcolor__0 = conio_x16_init.conio_x16_init__5
    .label bgcolor__2 = conio_x16_init.conio_x16_init__5
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
    // [180] *((char *)&__conio+$c) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta __conio+$c
    // cursor::@return
    // }
    // [181] return 
    rts
}
  // cbm_k_plot_get
/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
// __mem() unsigned int cbm_k_plot_get()
cbm_k_plot_get: {
    // __mem unsigned char x
    // [182] cbm_k_plot_get::x = 0 -- vbum1=vbuc1 
    lda #0
    sta x
    // __mem unsigned char y
    // [183] cbm_k_plot_get::y = 0 -- vbum1=vbuc1 
    sta y
    // kickasm
    // kickasm( uses cbm_k_plot_get::x uses cbm_k_plot_get::y uses CBM_PLOT) {{ sec         jsr CBM_PLOT         stx y         sty x      }}
    sec
        jsr CBM_PLOT
        stx y
        sty x
    
    // MAKEWORD(x,y)
    // [185] cbm_k_plot_get::return#0 = cbm_k_plot_get::x w= cbm_k_plot_get::y -- vwum1=vbum2_word_vbum3 
    lda x
    sta return+1
    lda y
    sta return
    // cbm_k_plot_get::@return
    // }
    // [186] return 
    rts
  .segment Data
    x: .byte 0
    y: .byte 0
    .label return = screenlayer.mapbase_offset
}
.segment Code
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__mem() char x, __mem() char y)
gotoxy: {
    // (x>=__conio.width)?__conio.width:x
    // [188] if(gotoxy::x#7>=*((char *)&__conio+6)) goto gotoxy::@1 -- vbum1_ge__deref_pbuc1_then_la1 
    lda x
    cmp __conio+6
    bcs __b1
    // [190] phi from gotoxy gotoxy::@1 to gotoxy::@2 [phi:gotoxy/gotoxy::@1->gotoxy::@2]
    // [190] phi gotoxy::$3 = gotoxy::x#7 [phi:gotoxy/gotoxy::@1->gotoxy::@2#0] -- register_copy 
    jmp __b2
    // gotoxy::@1
  __b1:
    // [189] gotoxy::$2 = *((char *)&__conio+6) -- vbum1=_deref_pbuc1 
    lda __conio+6
    sta gotoxy__2
    // gotoxy::@2
  __b2:
    // __conio.cursor_x = (x>=__conio.width)?__conio.width:x
    // [191] *((char *)&__conio) = gotoxy::$3 -- _deref_pbuc1=vbum1 
    lda gotoxy__3
    sta __conio
    // (y>=__conio.height)?__conio.height:y
    // [192] if(gotoxy::y#10>=*((char *)&__conio+7)) goto gotoxy::@3 -- vbum1_ge__deref_pbuc1_then_la1 
    lda y
    cmp __conio+7
    bcs __b3
    // gotoxy::@4
    // [193] gotoxy::$14 = gotoxy::y#10 -- vbum1=vbum2 
    sta gotoxy__14
    // [194] phi from gotoxy::@3 gotoxy::@4 to gotoxy::@5 [phi:gotoxy::@3/gotoxy::@4->gotoxy::@5]
    // [194] phi gotoxy::$7 = gotoxy::$6 [phi:gotoxy::@3/gotoxy::@4->gotoxy::@5#0] -- register_copy 
    // gotoxy::@5
  __b5:
    // __conio.cursor_y = (y>=__conio.height)?__conio.height:y
    // [195] *((char *)&__conio+1) = gotoxy::$7 -- _deref_pbuc1=vbum1 
    lda gotoxy__7
    sta __conio+1
    // __conio.cursor_x << 1
    // [196] gotoxy::$8 = *((char *)&__conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda __conio
    asl
    sta gotoxy__8
    // __conio.offsets[y] + __conio.cursor_x << 1
    // [197] gotoxy::$10 = gotoxy::y#10 << 1 -- vbum1=vbum1_rol_1 
    asl gotoxy__10
    // [198] gotoxy::$9 = ((unsigned int *)&__conio+$15)[gotoxy::$10] + gotoxy::$8 -- vwum1=pwuc1_derefidx_vbum2_plus_vbum3 
    ldy gotoxy__10
    clc
    adc __conio+$15,y
    sta gotoxy__9
    lda __conio+$15+1,y
    adc #0
    sta gotoxy__9+1
    // __conio.offset = __conio.offsets[y] + __conio.cursor_x << 1
    // [199] *((unsigned int *)&__conio+$13) = gotoxy::$9 -- _deref_pwuc1=vwum1 
    lda gotoxy__9
    sta __conio+$13
    lda gotoxy__9+1
    sta __conio+$13+1
    // gotoxy::@return
    // }
    // [200] return 
    rts
    // gotoxy::@3
  __b3:
    // (y>=__conio.height)?__conio.height:y
    // [201] gotoxy::$6 = *((char *)&__conio+7) -- vbum1=_deref_pbuc1 
    lda __conio+7
    sta gotoxy__6
    jmp __b5
  .segment Data
    .label gotoxy__2 = gotoxy__3
    gotoxy__3: .byte 0
    .label gotoxy__6 = gotoxy__3
    .label gotoxy__7 = gotoxy__3
    .label gotoxy__8 = gotoxy__3
    gotoxy__9: .word 0
    .label gotoxy__10 = y
    .label x = gotoxy__3
    y: .byte 0
    .label gotoxy__14 = gotoxy__3
}
.segment Code
  // cputln
// Print a newline
// void cputln()
cputln: {
    // __conio.cursor_x = 0
    // [202] *((char *)&__conio) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio
    // __conio.cursor_y++;
    // [203] *((char *)&__conio+1) = ++ *((char *)&__conio+1) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+1
    // __conio.offset = __conio.offsets[__conio.cursor_y]
    // [204] cputln::$3 = *((char *)&__conio+1) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda __conio+1
    asl
    sta cputln__3
    // [205] *((unsigned int *)&__conio+$13) = ((unsigned int *)&__conio+$15)[cputln::$3] -- _deref_pwuc1=pwuc2_derefidx_vbum1 
    tay
    lda __conio+$15,y
    sta __conio+$13
    lda __conio+$15+1,y
    sta __conio+$13+1
    // if(__conio.scroll[__conio.layer])
    // [206] if(0==((char *)&__conio+$f)[*((char *)&__conio+2)]) goto cputln::@return -- 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$f,y
    cmp #0
    beq __breturn
    // [207] phi from cputln to cputln::@1 [phi:cputln->cputln::@1]
    // cputln::@1
    // cscroll()
    // [208] call cscroll
    jsr cscroll
    // cputln::@return
  __breturn:
    // }
    // [209] return 
    rts
  .segment Data
    .label cputln__3 = insertup.y
}
.segment Code
  // kbhit
// Returns a value if a key is pressed.
// __mem() char kbhit()
kbhit: {
    // kbhit::cbm_k_clrchn1
    // asm
    // asm { jsrCBM_CLRCHN  }
    jsr CBM_CLRCHN
    // [212] phi from kbhit::cbm_k_clrchn1 to kbhit::@1 [phi:kbhit::cbm_k_clrchn1->kbhit::@1]
    // kbhit::@1
    // cbm_k_getin()
    // [213] call cbm_k_getin
    jsr cbm_k_getin
    // [214] cbm_k_getin::return#2 = cbm_k_getin::return#1
    // kbhit::@2
    // [215] kbhit::return#0 = cbm_k_getin::return#2
    // kbhit::@return
    // }
    // [216] return 
    rts
  .segment Data
    .label return = clrscr.l
}
.segment Code
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
// void clrscr()
clrscr: {
    // unsigned int line_text = __conio.mapbase_offset
    // [217] clrscr::line_text#0 = *((unsigned int *)&__conio+3) -- vwum1=_deref_pwuc1 
    lda __conio+3
    sta line_text
    lda __conio+3+1
    sta line_text+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [218] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // __conio.mapbase_bank | VERA_INC_1
    // [219] clrscr::$0 = *((char *)&__conio+5) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    sta clrscr__0
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [220] *VERA_ADDRX_H = clrscr::$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // unsigned char l = __conio.mapheight
    // [221] clrscr::l#0 = *((char *)&__conio+9) -- vbum1=_deref_pbuc1 
    lda __conio+9
    sta l
    // [222] phi from clrscr clrscr::@3 to clrscr::@1 [phi:clrscr/clrscr::@3->clrscr::@1]
    // [222] phi clrscr::l#4 = clrscr::l#0 [phi:clrscr/clrscr::@3->clrscr::@1#0] -- register_copy 
    // [222] phi clrscr::ch#0 = clrscr::line_text#0 [phi:clrscr/clrscr::@3->clrscr::@1#1] -- register_copy 
    // clrscr::@1
  __b1:
    // BYTE0(ch)
    // [223] clrscr::$1 = byte0  clrscr::ch#0 -- vbum1=_byte0_vwum2 
    lda ch
    sta clrscr__1
    // *VERA_ADDRX_L = BYTE0(ch)
    // [224] *VERA_ADDRX_L = clrscr::$1 -- _deref_pbuc1=vbum1 
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(ch)
    // [225] clrscr::$2 = byte1  clrscr::ch#0 -- vbum1=_byte1_vwum2 
    lda ch+1
    sta clrscr__2
    // *VERA_ADDRX_M = BYTE1(ch)
    // [226] *VERA_ADDRX_M = clrscr::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // unsigned char c = __conio.mapwidth
    // [227] clrscr::c#0 = *((char *)&__conio+8) -- vbum1=_deref_pbuc1 
    lda __conio+8
    sta c
    // [228] phi from clrscr::@1 clrscr::@2 to clrscr::@2 [phi:clrscr::@1/clrscr::@2->clrscr::@2]
    // [228] phi clrscr::c#2 = clrscr::c#0 [phi:clrscr::@1/clrscr::@2->clrscr::@2#0] -- register_copy 
    // clrscr::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [229] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [230] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // c--;
    // [231] clrscr::c#1 = -- clrscr::c#2 -- vbum1=_dec_vbum1 
    dec c
    // while(c)
    // [232] if(0!=clrscr::c#1) goto clrscr::@2 -- 0_neq_vbum1_then_la1 
    lda c
    bne __b2
    // clrscr::@3
    // line_text += __conio.rowskip
    // [233] clrscr::line_text#1 = clrscr::ch#0 + *((unsigned int *)&__conio+$a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda line_text
    adc __conio+$a
    sta line_text
    lda line_text+1
    adc __conio+$a+1
    sta line_text+1
    // l--;
    // [234] clrscr::l#1 = -- clrscr::l#4 -- vbum1=_dec_vbum1 
    dec l
    // while(l)
    // [235] if(0!=clrscr::l#1) goto clrscr::@1 -- 0_neq_vbum1_then_la1 
    lda l
    bne __b1
    // clrscr::@4
    // __conio.cursor_x = 0
    // [236] *((char *)&__conio) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio
    // __conio.cursor_y = 0
    // [237] *((char *)&__conio+1) = 0 -- _deref_pbuc1=vbuc2 
    sta __conio+1
    // __conio.offset = __conio.mapbase_offset
    // [238] *((unsigned int *)&__conio+$13) = *((unsigned int *)&__conio+3) -- _deref_pwuc1=_deref_pwuc2 
    lda __conio+3
    sta __conio+$13
    lda __conio+3+1
    sta __conio+$13+1
    // clrscr::@return
    // }
    // [239] return 
    rts
  .segment Data
    .label clrscr__0 = l
    .label clrscr__1 = c
    .label clrscr__2 = c
    .label line_text = ch
    l: .byte 0
    ch: .word 0
    c: .byte 0
}
.segment Code
  // printf_str
/// Print a NUL-terminated string
// void printf_str(__zp($22) void (*putc)(char), __zp($24) const char *s)
printf_str: {
    .label s = $24
    .label putc = $22
    // [241] phi from printf_str printf_str::@2 to printf_str::@1 [phi:printf_str/printf_str::@2->printf_str::@1]
    // [241] phi printf_str::s#9 = printf_str::s#10 [phi:printf_str/printf_str::@2->printf_str::@1#0] -- register_copy 
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [242] printf_str::c#1 = *printf_str::s#9 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta c
    // [243] printf_str::s#0 = ++ printf_str::s#9 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [244] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbum1_then_la1 
    lda c
    bne __b2
    // printf_str::@return
    // }
    // [245] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [246] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbum1 
    lda c
    pha
    // [247] callexecute *printf_str::putc#10  -- call__deref_pprz1 
    jsr icall1
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
    // Outside Flow
  icall1:
    jmp (putc)
  .segment Data
    .label c = printf_number_buffer.format_upper_case
}
.segment Code
  // rand
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
// __mem() unsigned int rand()
rand: {
    // rand_state << 7
    // [249] rand::$0 = rand_state << 7 -- vwum1=vwum2_rol_7 
    lda rand_state+1
    lsr
    lda rand_state
    ror
    sta rand__0+1
    lda #0
    ror
    sta rand__0
    // rand_state ^= rand_state << 7
    // [250] rand_state = rand_state ^ rand::$0 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__0
    sta rand_state
    lda rand_state+1
    eor rand__0+1
    sta rand_state+1
    // rand_state >> 9
    // [251] rand::$1 = rand_state >> 9 -- vwum1=vwum2_ror_9 
    lsr
    sta rand__1
    lda #0
    sta rand__1+1
    // rand_state ^= rand_state >> 9
    // [252] rand_state = rand_state ^ rand::$1 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__1
    sta rand_state
    lda rand_state+1
    eor rand__1+1
    sta rand_state+1
    // rand_state << 8
    // [253] rand::$2 = rand_state << 8 -- vwum1=vwum2_rol_8 
    lda rand_state
    sta rand__2+1
    lda #0
    sta rand__2
    // rand_state ^= rand_state << 8
    // [254] rand_state = rand_state ^ rand::$2 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__2
    sta rand_state
    lda rand_state+1
    eor rand__2+1
    sta rand_state+1
    // return rand_state;
    // [255] rand::return#0 = rand_state -- vwum1=vwum2 
    lda rand_state
    sta return
    lda rand_state+1
    sta return+1
    // rand::@return
    // }
    // [256] return 
    rts
  .segment Data
    .label rand__0 = clrscr.ch
    .label rand__1 = clrscr.ch
    .label rand__2 = clrscr.ch
    .label return = clrscr.ch
}
.segment Code
  // printf_uchar
// Print an unsigned char using a specific format
// void printf_uchar(void (*putc)(char), __mem() char uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_uchar: {
    .const format_min_length = 3
    .const format_justify_left = 0
    .const format_zero_padding = 1
    .const format_upper_case = 0
    .label putc = cputc
    // printf_uchar::@1
    // printf_buffer.sign = format_sign_always?'+':0
    // [258] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format_radix)
    // [259] uctoa::value#1 = printf_uchar::uvalue#0
    // [260] call uctoa
  // Format number into buffer
    // [322] phi from printf_uchar::@1 to uctoa [phi:printf_uchar::@1->uctoa]
    jsr uctoa
    // printf_uchar::@2
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [261] *(&printf_number_buffer::buffer) = memcpy(*(&printf_buffer), struct printf_buffer_number, SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER
  !:
    lda printf_buffer-1,y
    sta printf_number_buffer.buffer-1,y
    dey
    bne !-
    // [262] call printf_number_buffer
  // Print using format
    // [341] phi from printf_uchar::@2 to printf_number_buffer [phi:printf_uchar::@2->printf_number_buffer]
    // [341] phi printf_number_buffer::format_upper_case#10 = printf_uchar::format_upper_case#0 [phi:printf_uchar::@2->printf_number_buffer#0] -- vbum1=vbuc1 
    lda #format_upper_case
    sta printf_number_buffer.format_upper_case
    // [341] phi printf_number_buffer::putc#10 = printf_uchar::putc#0 [phi:printf_uchar::@2->printf_number_buffer#1] -- pprz1=pprc1 
    lda #<putc
    sta.z printf_number_buffer.putc
    lda #>putc
    sta.z printf_number_buffer.putc+1
    // [341] phi printf_number_buffer::format_zero_padding#10 = printf_uchar::format_zero_padding#0 [phi:printf_uchar::@2->printf_number_buffer#2] -- vbum1=vbuc1 
    lda #format_zero_padding
    sta printf_number_buffer.format_zero_padding
    // [341] phi printf_number_buffer::format_justify_left#10 = printf_uchar::format_justify_left#0 [phi:printf_uchar::@2->printf_number_buffer#3] -- vbum1=vbuc1 
    lda #format_justify_left
    sta printf_number_buffer.format_justify_left
    // [341] phi printf_number_buffer::format_min_length#2 = printf_uchar::format_min_length#0 [phi:printf_uchar::@2->printf_number_buffer#4] -- vbum1=vbuc1 
    lda #format_min_length
    sta printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [263] return 
    rts
  .segment Data
    .label uvalue = clrscr.c
}
.segment Code
  // printf_uint
// Print an unsigned int using a specific format
// void printf_uint(void (*putc)(char), __mem() unsigned int uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_uint: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
    .label putc = cputc
    // printf_uint::@1
    // printf_buffer.sign = format_sign_always?'+':0
    // [265] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // void printf_uint(void (*putc)(char), unsigned int uvalue, struct printf_format_number format) {
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format_radix)
    // [266] utoa::value#1 = printf_uint::uvalue#0
    // [267] call utoa
  // Format number into buffer
    // [382] phi from printf_uint::@1 to utoa [phi:printf_uint::@1->utoa]
    jsr utoa
    // printf_uint::@2
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [268] *(&printf_number_buffer::buffer) = memcpy(*(&printf_buffer), struct printf_buffer_number, SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER
  !:
    lda printf_buffer-1,y
    sta printf_number_buffer.buffer-1,y
    dey
    bne !-
    // [269] call printf_number_buffer
  // Print using format
    // [341] phi from printf_uint::@2 to printf_number_buffer [phi:printf_uint::@2->printf_number_buffer]
    // [341] phi printf_number_buffer::format_upper_case#10 = printf_uint::format_upper_case#0 [phi:printf_uint::@2->printf_number_buffer#0] -- vbum1=vbuc1 
    lda #format_upper_case
    sta printf_number_buffer.format_upper_case
    // [341] phi printf_number_buffer::putc#10 = printf_uint::putc#0 [phi:printf_uint::@2->printf_number_buffer#1] -- pprz1=pprc1 
    lda #<putc
    sta.z printf_number_buffer.putc
    lda #>putc
    sta.z printf_number_buffer.putc+1
    // [341] phi printf_number_buffer::format_zero_padding#10 = printf_uint::format_zero_padding#0 [phi:printf_uint::@2->printf_number_buffer#2] -- vbum1=vbuc1 
    lda #format_zero_padding
    sta printf_number_buffer.format_zero_padding
    // [341] phi printf_number_buffer::format_justify_left#10 = printf_uint::format_justify_left#0 [phi:printf_uint::@2->printf_number_buffer#3] -- vbum1=vbuc1 
    lda #format_justify_left
    sta printf_number_buffer.format_justify_left
    // [341] phi printf_number_buffer::format_min_length#2 = printf_uint::format_min_length#0 [phi:printf_uint::@2->printf_number_buffer#4] -- vbum1=vbuc1 
    lda #format_min_length
    sta printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // printf_uint::@return
    // }
    // [270] return 
    rts
  .segment Data
    .label uvalue = clrscr.ch
}
.segment Code
  // screenlayer
// --- layer management in VERA ---
// void screenlayer(char layer, __mem() char mapbase, __mem() char config)
screenlayer: {
    .label y = $29
    // __mem char vera_dc_hscale_temp = *VERA_DC_HSCALE
    // [271] screenlayer::vera_dc_hscale_temp#0 = *VERA_DC_HSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_HSCALE
    sta vera_dc_hscale_temp
    // __mem char vera_dc_vscale_temp = *VERA_DC_VSCALE
    // [272] screenlayer::vera_dc_vscale_temp#0 = *VERA_DC_VSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_VSCALE
    sta vera_dc_vscale_temp
    // __conio.layer = 0
    // [273] *((char *)&__conio+2) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+2
    // mapbase >> 7
    // [274] screenlayer::$0 = screenlayer::mapbase#0 >> 7 -- vbum1=vbum2_ror_7 
    lda mapbase
    rol
    rol
    and #1
    sta screenlayer__0
    // __conio.mapbase_bank = mapbase >> 7
    // [275] *((char *)&__conio+5) = screenlayer::$0 -- _deref_pbuc1=vbum1 
    sta __conio+5
    // (mapbase)<<1
    // [276] screenlayer::$1 = screenlayer::mapbase#0 << 1 -- vbum1=vbum1_rol_1 
    asl screenlayer__1
    // MAKEWORD((mapbase)<<1,0)
    // [277] screenlayer::$2 = screenlayer::$1 w= 0 -- vwum1=vbum2_word_vbuc1 
    lda #0
    ldy screenlayer__1
    sty screenlayer__2+1
    sta screenlayer__2
    // __conio.mapbase_offset = MAKEWORD((mapbase)<<1,0)
    // [278] *((unsigned int *)&__conio+3) = screenlayer::$2 -- _deref_pwuc1=vwum1 
    sta __conio+3
    tya
    sta __conio+3+1
    // config & VERA_LAYER_WIDTH_MASK
    // [279] screenlayer::$7 = screenlayer::config#0 & VERA_LAYER_WIDTH_MASK -- vbum1=vbum2_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    and config
    sta screenlayer__7
    // (config & VERA_LAYER_WIDTH_MASK) >> 4
    // [280] screenlayer::$8 = screenlayer::$7 >> 4 -- vbum1=vbum1_ror_4 
    lda screenlayer__8
    lsr
    lsr
    lsr
    lsr
    sta screenlayer__8
    // __conio.mapwidth = VERA_LAYER_DIM[ (config & VERA_LAYER_WIDTH_MASK) >> 4]
    // [281] *((char *)&__conio+8) = screenlayer::VERA_LAYER_DIM[screenlayer::$8] -- _deref_pbuc1=pbuc2_derefidx_vbum1 
    tay
    lda VERA_LAYER_DIM,y
    sta __conio+8
    // config & VERA_LAYER_HEIGHT_MASK
    // [282] screenlayer::$5 = screenlayer::config#0 & VERA_LAYER_HEIGHT_MASK -- vbum1=vbum1_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    and screenlayer__5
    sta screenlayer__5
    // (config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [283] screenlayer::$6 = screenlayer::$5 >> 6 -- vbum1=vbum1_ror_6 
    lda screenlayer__6
    rol
    rol
    rol
    and #3
    sta screenlayer__6
    // __conio.mapheight = VERA_LAYER_DIM[ (config & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [284] *((char *)&__conio+9) = screenlayer::VERA_LAYER_DIM[screenlayer::$6] -- _deref_pbuc1=pbuc2_derefidx_vbum1 
    tay
    lda VERA_LAYER_DIM,y
    sta __conio+9
    // __conio.rowskip = VERA_LAYER_SKIP[(config & VERA_LAYER_WIDTH_MASK)>>4]
    // [285] screenlayer::$16 = screenlayer::$8 << 1 -- vbum1=vbum1_rol_1 
    asl screenlayer__16
    // [286] *((unsigned int *)&__conio+$a) = screenlayer::VERA_LAYER_SKIP[screenlayer::$16] -- _deref_pwuc1=pwuc2_derefidx_vbum1 
    // __conio.rowshift = ((config & VERA_LAYER_WIDTH_MASK)>>4)+6;
    ldy screenlayer__16
    lda VERA_LAYER_SKIP,y
    sta __conio+$a
    lda VERA_LAYER_SKIP+1,y
    sta __conio+$a+1
    // vera_dc_hscale_temp == 0x80
    // [287] screenlayer::$9 = screenlayer::vera_dc_hscale_temp#0 == $80 -- vbom1=vbum1_eq_vbuc1 
    lda screenlayer__9
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    sta screenlayer__9
    // 40 << (char)(vera_dc_hscale_temp == 0x80)
    // [288] screenlayer::$18 = (char)screenlayer::$9
    // [289] screenlayer::$10 = $28 << screenlayer::$18 -- vbum1=vbuc1_rol_vbum1 
    lda #$28
    ldy screenlayer__10
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta screenlayer__10
    // (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [290] screenlayer::$11 = screenlayer::$10 - 1 -- vbum1=vbum1_minus_1 
    dec screenlayer__11
    // __conio.width = (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [291] *((char *)&__conio+6) = screenlayer::$11 -- _deref_pbuc1=vbum1 
    lda screenlayer__11
    sta __conio+6
    // vera_dc_vscale_temp == 0x80
    // [292] screenlayer::$12 = screenlayer::vera_dc_vscale_temp#0 == $80 -- vbom1=vbum1_eq_vbuc1 
    lda screenlayer__12
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    sta screenlayer__12
    // 30 << (char)(vera_dc_vscale_temp == 0x80)
    // [293] screenlayer::$19 = (char)screenlayer::$12
    // [294] screenlayer::$13 = $1e << screenlayer::$19 -- vbum1=vbuc1_rol_vbum1 
    lda #$1e
    ldy screenlayer__13
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta screenlayer__13
    // (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [295] screenlayer::$14 = screenlayer::$13 - 1 -- vbum1=vbum1_minus_1 
    dec screenlayer__14
    // __conio.height = (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [296] *((char *)&__conio+7) = screenlayer::$14 -- _deref_pbuc1=vbum1 
    lda screenlayer__14
    sta __conio+7
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [297] screenlayer::mapbase_offset#0 = *((unsigned int *)&__conio+3) -- vwum1=_deref_pwuc1 
    lda __conio+3
    sta mapbase_offset
    lda __conio+3+1
    sta mapbase_offset+1
    // [298] phi from screenlayer to screenlayer::@1 [phi:screenlayer->screenlayer::@1]
    // [298] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#0 [phi:screenlayer->screenlayer::@1#0] -- register_copy 
    // [298] phi screenlayer::y#2 = 0 [phi:screenlayer->screenlayer::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z y
    // screenlayer::@1
  __b1:
    // for(register char y=0; y<=__conio.height; y++)
    // [299] if(screenlayer::y#2<=*((char *)&__conio+7)) goto screenlayer::@2 -- vbuz1_le__deref_pbuc1_then_la1 
    lda __conio+7
    cmp.z y
    bcs __b2
    // screenlayer::@return
    // }
    // [300] return 
    rts
    // screenlayer::@2
  __b2:
    // __conio.offsets[y] = mapbase_offset
    // [301] screenlayer::$17 = screenlayer::y#2 << 1 -- vbum1=vbuz2_rol_1 
    lda.z y
    asl
    sta screenlayer__17
    // [302] ((unsigned int *)&__conio+$15)[screenlayer::$17] = screenlayer::mapbase_offset#2 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda mapbase_offset
    sta __conio+$15,y
    lda mapbase_offset+1
    sta __conio+$15+1,y
    // mapbase_offset += __conio.rowskip
    // [303] screenlayer::mapbase_offset#1 = screenlayer::mapbase_offset#2 + *((unsigned int *)&__conio+$a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda mapbase_offset
    adc __conio+$a
    sta mapbase_offset
    lda mapbase_offset+1
    adc __conio+$a+1
    sta mapbase_offset+1
    // for(register char y=0; y<=__conio.height; y++)
    // [304] screenlayer::y#1 = ++ screenlayer::y#2 -- vbuz1=_inc_vbuz1 
    inc.z y
    // [298] phi from screenlayer::@2 to screenlayer::@1 [phi:screenlayer::@2->screenlayer::@1]
    // [298] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#1 [phi:screenlayer::@2->screenlayer::@1#0] -- register_copy 
    // [298] phi screenlayer::y#2 = screenlayer::y#1 [phi:screenlayer::@2->screenlayer::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    VERA_LAYER_DIM: .byte $1f, $3f, $7f, $ff
    VERA_LAYER_SKIP: .word $40, $80, $100, $200
    screenlayer__0: .byte 0
    .label screenlayer__1 = conio_x16_init.conio_x16_init__5
    .label screenlayer__2 = mapbase_offset
    .label screenlayer__5 = config
    .label screenlayer__6 = config
    .label screenlayer__7 = conio_x16_init.conio_x16_init__5
    .label screenlayer__8 = conio_x16_init.conio_x16_init__5
    .label screenlayer__9 = vera_dc_hscale_temp
    .label screenlayer__10 = vera_dc_hscale_temp
    .label screenlayer__11 = vera_dc_hscale_temp
    .label screenlayer__12 = vera_dc_vscale_temp
    .label screenlayer__13 = vera_dc_vscale_temp
    .label screenlayer__14 = vera_dc_vscale_temp
    .label screenlayer__16 = conio_x16_init.conio_x16_init__5
    .label screenlayer__17 = conio_x16_init.conio_x16_init__5
    .label screenlayer__18 = vera_dc_hscale_temp
    .label screenlayer__19 = vera_dc_vscale_temp
    .label mapbase = conio_x16_init.conio_x16_init__5
    config: .byte 0
    vera_dc_hscale_temp: .byte 0
    vera_dc_vscale_temp: .byte 0
    mapbase_offset: .word 0
}
.segment Code
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
// void cscroll()
cscroll: {
    // if(__conio.cursor_y>__conio.height)
    // [305] if(*((char *)&__conio+1)<=*((char *)&__conio+7)) goto cscroll::@return -- _deref_pbuc1_le__deref_pbuc2_then_la1 
    lda __conio+7
    cmp __conio+1
    bcs __breturn
    // cscroll::@1
    // if(__conio.scroll[__conio.layer])
    // [306] if(0!=((char *)&__conio+$f)[*((char *)&__conio+2)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$f,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(__conio.cursor_y>__conio.height)
    // [307] if(*((char *)&__conio+1)<=*((char *)&__conio+7)) goto cscroll::@return -- _deref_pbuc1_le__deref_pbuc2_then_la1 
    lda __conio+7
    cmp __conio+1
    bcs __breturn
    // [308] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
    // gotoxy(0,0)
    // [309] call gotoxy
    // [187] phi from cscroll::@3 to gotoxy [phi:cscroll::@3->gotoxy]
    // [187] phi gotoxy::y#10 = 0 [phi:cscroll::@3->gotoxy#0] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.y
    // [187] phi gotoxy::x#7 = 0 [phi:cscroll::@3->gotoxy#1] -- vbum1=vbuc1 
    sta gotoxy.x
    jsr gotoxy
    // cscroll::@return
  __breturn:
    // }
    // [310] return 
    rts
    // [311] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup(1)
    // [312] call insertup
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, __conio.height)
    // [313] gotoxy::y#1 = *((char *)&__conio+7) -- vbum1=_deref_pbuc1 
    lda __conio+7
    sta gotoxy.y
    // [314] call gotoxy
    // [187] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [187] phi gotoxy::y#10 = gotoxy::y#1 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    // [187] phi gotoxy::x#7 = 0 [phi:cscroll::@5->gotoxy#1] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.x
    jsr gotoxy
    // [315] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [316] call clearline
    jsr clearline
    rts
}
  // cbm_k_getin
/**
 * @brief Scan a character from keyboard without pressing enter.
 * 
 * @return char The character read.
 */
// __mem() char cbm_k_getin()
cbm_k_getin: {
    // __mem unsigned char ch
    // [317] cbm_k_getin::ch = 0 -- vbum1=vbuc1 
    lda #0
    sta ch
    // asm
    // asm { jsrCBM_GETIN stach  }
    jsr CBM_GETIN
    sta ch
    // return ch;
    // [319] cbm_k_getin::return#0 = cbm_k_getin::ch -- vbum1=vbum2 
    sta return
    // cbm_k_getin::@return
    // }
    // [320] cbm_k_getin::return#1 = cbm_k_getin::return#0
    // [321] return 
    rts
  .segment Data
    ch: .byte 0
    .label return = clrscr.l
}
.segment Code
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void uctoa(__mem() char value, __zp($22) char *buffer, char radix)
uctoa: {
    .const max_digits = 2
    .label buffer = $22
    // [323] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
    // [323] phi uctoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:uctoa->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [323] phi uctoa::started#2 = 0 [phi:uctoa->uctoa::@1#1] -- vbum1=vbuc1 
    lda #0
    sta started
    // [323] phi uctoa::value#2 = uctoa::value#1 [phi:uctoa->uctoa::@1#2] -- register_copy 
    // [323] phi uctoa::digit#2 = 0 [phi:uctoa->uctoa::@1#3] -- vbum1=vbuc1 
    sta digit
    // uctoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [324] if(uctoa::digit#2<uctoa::max_digits#2-1) goto uctoa::@2 -- vbum1_lt_vbuc1_then_la1 
    lda digit
    cmp #max_digits-1
    bcc __b2
    // uctoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [325] *uctoa::buffer#11 = DIGITS[uctoa::value#2] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    ldy value
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [326] uctoa::buffer#3 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [327] *uctoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // uctoa::@return
    // }
    // [328] return 
    rts
    // uctoa::@2
  __b2:
    // unsigned char digit_value = digit_values[digit]
    // [329] uctoa::digit_value#0 = RADIX_HEXADECIMAL_VALUES_CHAR[uctoa::digit#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy digit
    lda RADIX_HEXADECIMAL_VALUES_CHAR,y
    sta digit_value
    // if (started || value >= digit_value)
    // [330] if(0!=uctoa::started#2) goto uctoa::@5 -- 0_neq_vbum1_then_la1 
    lda started
    bne __b5
    // uctoa::@7
    // [331] if(uctoa::value#2>=uctoa::digit_value#0) goto uctoa::@5 -- vbum1_ge_vbum2_then_la1 
    lda value
    cmp digit_value
    bcs __b5
    // [332] phi from uctoa::@7 to uctoa::@4 [phi:uctoa::@7->uctoa::@4]
    // [332] phi uctoa::buffer#14 = uctoa::buffer#11 [phi:uctoa::@7->uctoa::@4#0] -- register_copy 
    // [332] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@7->uctoa::@4#1] -- register_copy 
    // [332] phi uctoa::value#6 = uctoa::value#2 [phi:uctoa::@7->uctoa::@4#2] -- register_copy 
    // uctoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [333] uctoa::digit#1 = ++ uctoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [323] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
    // [323] phi uctoa::buffer#11 = uctoa::buffer#14 [phi:uctoa::@4->uctoa::@1#0] -- register_copy 
    // [323] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@4->uctoa::@1#1] -- register_copy 
    // [323] phi uctoa::value#2 = uctoa::value#6 [phi:uctoa::@4->uctoa::@1#2] -- register_copy 
    // [323] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@4->uctoa::@1#3] -- register_copy 
    jmp __b1
    // uctoa::@5
  __b5:
    // uctoa_append(buffer++, value, digit_value)
    // [334] uctoa_append::buffer#0 = uctoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z uctoa_append.buffer
    lda.z buffer+1
    sta.z uctoa_append.buffer+1
    // [335] uctoa_append::value#0 = uctoa::value#2
    // [336] uctoa_append::sub#0 = uctoa::digit_value#0
    // [337] call uctoa_append
    // [436] phi from uctoa::@5 to uctoa_append [phi:uctoa::@5->uctoa_append]
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // [338] uctoa_append::return#0 = uctoa_append::value#2
    // uctoa::@6
    // value = uctoa_append(buffer++, value, digit_value)
    // [339] uctoa::value#0 = uctoa_append::return#0
    // value = uctoa_append(buffer++, value, digit_value);
    // [340] uctoa::buffer#4 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [332] phi from uctoa::@6 to uctoa::@4 [phi:uctoa::@6->uctoa::@4]
    // [332] phi uctoa::buffer#14 = uctoa::buffer#4 [phi:uctoa::@6->uctoa::@4#0] -- register_copy 
    // [332] phi uctoa::started#4 = 1 [phi:uctoa::@6->uctoa::@4#1] -- vbum1=vbuc1 
    lda #1
    sta started
    // [332] phi uctoa::value#6 = uctoa::value#0 [phi:uctoa::@6->uctoa::@4#2] -- register_copy 
    jmp __b4
  .segment Data
    .label digit_value = printf_number_buffer.format_upper_case
    .label digit = clrscr.l
    .label value = clrscr.c
    started: .byte 0
}
.segment Code
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(__zp($26) void (*putc)(char), __mem() struct printf_buffer_number buffer, __mem() char format_min_length, __mem() char format_justify_left, char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, char format_radix)
printf_number_buffer: {
    .label putc = $26
    // if(format_min_length)
    // [342] if(0==printf_number_buffer::format_min_length#2) goto printf_number_buffer::@1 -- 0_eq_vbum1_then_la1 
    lda format_min_length
    beq __b6
    // [343] phi from printf_number_buffer to printf_number_buffer::@6 [phi:printf_number_buffer->printf_number_buffer::@6]
    // printf_number_buffer::@6
    // strlen(buffer.digits)
    // [344] call strlen
    // [443] phi from printf_number_buffer::@6 to strlen [phi:printf_number_buffer::@6->strlen]
    jsr strlen
    // strlen(buffer.digits)
    // [345] strlen::return#2 = strlen::len#2
    // printf_number_buffer::@14
    // [346] printf_number_buffer::$19 = strlen::return#2
    // signed char len = (signed char)strlen(buffer.digits)
    // [347] printf_number_buffer::len#0 = (signed char)printf_number_buffer::$19 -- vbsm1=_sbyte_vwum2 
    // There is a minimum length - work out the padding
    lda printf_number_buffer__19
    sta len
    // if(buffer.sign)
    // [348] if(0==*((char *)&printf_number_buffer::buffer)) goto printf_number_buffer::@13 -- 0_eq__deref_pbuc1_then_la1 
    lda buffer
    beq __b13
    // printf_number_buffer::@7
    // len++;
    // [349] printf_number_buffer::len#1 = ++ printf_number_buffer::len#0 -- vbsm1=_inc_vbsm1 
    inc len
    // [350] phi from printf_number_buffer::@14 printf_number_buffer::@7 to printf_number_buffer::@13 [phi:printf_number_buffer::@14/printf_number_buffer::@7->printf_number_buffer::@13]
    // [350] phi printf_number_buffer::len#2 = printf_number_buffer::len#0 [phi:printf_number_buffer::@14/printf_number_buffer::@7->printf_number_buffer::@13#0] -- register_copy 
    // printf_number_buffer::@13
  __b13:
    // padding = (signed char)format_min_length - len
    // [351] printf_number_buffer::padding#1 = (signed char)printf_number_buffer::format_min_length#2 - printf_number_buffer::len#2 -- vbsm1=vbsm1_minus_vbsm2 
    lda padding
    sec
    sbc len
    sta padding
    // if(padding<0)
    // [352] if(printf_number_buffer::padding#1>=0) goto printf_number_buffer::@21 -- vbsm1_ge_0_then_la1 
    cmp #0
    bpl __b1
    // [354] phi from printf_number_buffer printf_number_buffer::@13 to printf_number_buffer::@1 [phi:printf_number_buffer/printf_number_buffer::@13->printf_number_buffer::@1]
  __b6:
    // [354] phi printf_number_buffer::padding#10 = 0 [phi:printf_number_buffer/printf_number_buffer::@13->printf_number_buffer::@1#0] -- vbsm1=vbsc1 
    lda #0
    sta padding
    // [353] phi from printf_number_buffer::@13 to printf_number_buffer::@21 [phi:printf_number_buffer::@13->printf_number_buffer::@21]
    // printf_number_buffer::@21
    // [354] phi from printf_number_buffer::@21 to printf_number_buffer::@1 [phi:printf_number_buffer::@21->printf_number_buffer::@1]
    // [354] phi printf_number_buffer::padding#10 = printf_number_buffer::padding#1 [phi:printf_number_buffer::@21->printf_number_buffer::@1#0] -- register_copy 
    // printf_number_buffer::@1
  __b1:
    // if(!format_justify_left && !format_zero_padding && padding)
    // [355] if(0!=printf_number_buffer::format_justify_left#10) goto printf_number_buffer::@2 -- 0_neq_vbum1_then_la1 
    lda format_justify_left
    bne __b2
    // printf_number_buffer::@17
    // [356] if(0!=printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@2 -- 0_neq_vbum1_then_la1 
    lda format_zero_padding
    bne __b2
    // printf_number_buffer::@16
    // [357] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@8 -- 0_neq_vbsm1_then_la1 
    lda padding
    cmp #0
    bne __b8
    jmp __b2
    // printf_number_buffer::@8
  __b8:
    // printf_padding(putc, ' ',(char)padding)
    // [358] printf_padding::putc#0 = printf_number_buffer::putc#10 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [359] printf_padding::length#0 = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [360] call printf_padding
    // [449] phi from printf_number_buffer::@8 to printf_padding [phi:printf_number_buffer::@8->printf_padding]
    // [449] phi printf_padding::putc#5 = printf_padding::putc#0 [phi:printf_number_buffer::@8->printf_padding#0] -- register_copy 
    // [449] phi printf_padding::pad#5 = ' ' [phi:printf_number_buffer::@8->printf_padding#1] -- vbum1=vbuc1 
    lda #' '
    sta printf_padding.pad
    // [449] phi printf_padding::length#4 = printf_padding::length#0 [phi:printf_number_buffer::@8->printf_padding#2] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@2
  __b2:
    // if(buffer.sign)
    // [361] if(0==*((char *)&printf_number_buffer::buffer)) goto printf_number_buffer::@3 -- 0_eq__deref_pbuc1_then_la1 
    lda buffer
    beq __b3
    // printf_number_buffer::@9
    // putc(buffer.sign)
    // [362] stackpush(char) = *((char *)&printf_number_buffer::buffer) -- _stackpushbyte_=_deref_pbuc1 
    pha
    // [363] callexecute *printf_number_buffer::putc#10  -- call__deref_pprz1 
    jsr icall2
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_number_buffer::@3
  __b3:
    // if(format_zero_padding && padding)
    // [365] if(0==printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@4 -- 0_eq_vbum1_then_la1 
    lda format_zero_padding
    beq __b4
    // printf_number_buffer::@18
    // [366] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@10 -- 0_neq_vbsm1_then_la1 
    lda padding
    cmp #0
    bne __b10
    jmp __b4
    // printf_number_buffer::@10
  __b10:
    // printf_padding(putc, '0',(char)padding)
    // [367] printf_padding::putc#1 = printf_number_buffer::putc#10 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [368] printf_padding::length#1 = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [369] call printf_padding
    // [449] phi from printf_number_buffer::@10 to printf_padding [phi:printf_number_buffer::@10->printf_padding]
    // [449] phi printf_padding::putc#5 = printf_padding::putc#1 [phi:printf_number_buffer::@10->printf_padding#0] -- register_copy 
    // [449] phi printf_padding::pad#5 = '0' [phi:printf_number_buffer::@10->printf_padding#1] -- vbum1=vbuc1 
    lda #'0'
    sta printf_padding.pad
    // [449] phi printf_padding::length#4 = printf_padding::length#1 [phi:printf_number_buffer::@10->printf_padding#2] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@4
  __b4:
    // if(format_upper_case)
    // [370] if(0==printf_number_buffer::format_upper_case#10) goto printf_number_buffer::@5 -- 0_eq_vbum1_then_la1 
    lda format_upper_case
    beq __b5
    // [371] phi from printf_number_buffer::@4 to printf_number_buffer::@11 [phi:printf_number_buffer::@4->printf_number_buffer::@11]
    // printf_number_buffer::@11
    // strupr(buffer.digits)
    // [372] call strupr
    // [457] phi from printf_number_buffer::@11 to strupr [phi:printf_number_buffer::@11->strupr]
    jsr strupr
    // printf_number_buffer::@5
  __b5:
    // printf_str(putc, buffer.digits)
    // [373] printf_str::putc#0 = printf_number_buffer::putc#10 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_str.putc
    lda.z putc+1
    sta.z printf_str.putc+1
    // [374] call printf_str
    // [240] phi from printf_number_buffer::@5 to printf_str [phi:printf_number_buffer::@5->printf_str]
    // [240] phi printf_str::putc#10 = printf_str::putc#0 [phi:printf_number_buffer::@5->printf_str#0] -- register_copy 
    // [240] phi printf_str::s#10 = (char *)&printf_number_buffer::buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:printf_number_buffer::@5->printf_str#1] -- pbuz1=pbuc1 
    lda #<buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.s
    lda #>buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.s+1
    jsr printf_str
    // printf_number_buffer::@15
    // if(format_justify_left && !format_zero_padding && padding)
    // [375] if(0==printf_number_buffer::format_justify_left#10) goto printf_number_buffer::@return -- 0_eq_vbum1_then_la1 
    lda format_justify_left
    beq __breturn
    // printf_number_buffer::@20
    // [376] if(0!=printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@return -- 0_neq_vbum1_then_la1 
    lda format_zero_padding
    bne __breturn
    // printf_number_buffer::@19
    // [377] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@12 -- 0_neq_vbsm1_then_la1 
    lda padding
    cmp #0
    bne __b12
    rts
    // printf_number_buffer::@12
  __b12:
    // printf_padding(putc, ' ',(char)padding)
    // [378] printf_padding::putc#2 = printf_number_buffer::putc#10 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [379] printf_padding::length#2 = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [380] call printf_padding
    // [449] phi from printf_number_buffer::@12 to printf_padding [phi:printf_number_buffer::@12->printf_padding]
    // [449] phi printf_padding::putc#5 = printf_padding::putc#2 [phi:printf_number_buffer::@12->printf_padding#0] -- register_copy 
    // [449] phi printf_padding::pad#5 = ' ' [phi:printf_number_buffer::@12->printf_padding#1] -- vbum1=vbuc1 
    lda #' '
    sta printf_padding.pad
    // [449] phi printf_padding::length#4 = printf_padding::length#2 [phi:printf_number_buffer::@12->printf_padding#2] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@return
  __breturn:
    // }
    // [381] return 
    rts
    // Outside Flow
  icall2:
    jmp (putc)
  .segment Data
    buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
    .label printf_number_buffer__19 = clrscr.ch
    len: .byte 0
    .label padding = clrscr.l
    .label format_min_length = clrscr.l
    .label format_zero_padding = uctoa.started
    .label format_justify_left = clrscr.c
    format_upper_case: .byte 0
}
.segment Code
  // utoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__mem() unsigned int value, __zp($24) char *buffer, char radix)
utoa: {
    .const max_digits = 5
    .label buffer = $24
    // [383] phi from utoa to utoa::@1 [phi:utoa->utoa::@1]
    // [383] phi utoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:utoa->utoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [383] phi utoa::started#2 = 0 [phi:utoa->utoa::@1#1] -- vbum1=vbuc1 
    lda #0
    sta started
    // [383] phi utoa::value#2 = utoa::value#1 [phi:utoa->utoa::@1#2] -- register_copy 
    // [383] phi utoa::digit#2 = 0 [phi:utoa->utoa::@1#3] -- vbum1=vbuc1 
    sta digit
    // utoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [384] if(utoa::digit#2<utoa::max_digits#1-1) goto utoa::@2 -- vbum1_lt_vbuc1_then_la1 
    lda digit
    cmp #max_digits-1
    bcc __b2
    // utoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [385] utoa::$11 = (char)utoa::value#2 -- vbum1=_byte_vwum2 
    lda value
    sta utoa__11
    // [386] *utoa::buffer#11 = DIGITS[utoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [387] utoa::buffer#3 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [388] *utoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // utoa::@return
    // }
    // [389] return 
    rts
    // utoa::@2
  __b2:
    // unsigned int digit_value = digit_values[digit]
    // [390] utoa::$10 = utoa::digit#2 << 1 -- vbum1=vbum2_rol_1 
    lda digit
    asl
    sta utoa__10
    // [391] utoa::digit_value#0 = RADIX_DECIMAL_VALUES[utoa::$10] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta digit_value+1
    // if (started || value >= digit_value)
    // [392] if(0!=utoa::started#2) goto utoa::@5 -- 0_neq_vbum1_then_la1 
    lda started
    bne __b5
    // utoa::@7
    // [393] if(utoa::value#2>=utoa::digit_value#0) goto utoa::@5 -- vwum1_ge_vwum2_then_la1 
    lda digit_value+1
    cmp value+1
    bne !+
    lda digit_value
    cmp value
    beq __b5
  !:
    bcc __b5
    // [394] phi from utoa::@7 to utoa::@4 [phi:utoa::@7->utoa::@4]
    // [394] phi utoa::buffer#14 = utoa::buffer#11 [phi:utoa::@7->utoa::@4#0] -- register_copy 
    // [394] phi utoa::started#4 = utoa::started#2 [phi:utoa::@7->utoa::@4#1] -- register_copy 
    // [394] phi utoa::value#6 = utoa::value#2 [phi:utoa::@7->utoa::@4#2] -- register_copy 
    // utoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [395] utoa::digit#1 = ++ utoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [383] phi from utoa::@4 to utoa::@1 [phi:utoa::@4->utoa::@1]
    // [383] phi utoa::buffer#11 = utoa::buffer#14 [phi:utoa::@4->utoa::@1#0] -- register_copy 
    // [383] phi utoa::started#2 = utoa::started#4 [phi:utoa::@4->utoa::@1#1] -- register_copy 
    // [383] phi utoa::value#2 = utoa::value#6 [phi:utoa::@4->utoa::@1#2] -- register_copy 
    // [383] phi utoa::digit#2 = utoa::digit#1 [phi:utoa::@4->utoa::@1#3] -- register_copy 
    jmp __b1
    // utoa::@5
  __b5:
    // utoa_append(buffer++, value, digit_value)
    // [396] utoa_append::buffer#0 = utoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z utoa_append.buffer
    lda.z buffer+1
    sta.z utoa_append.buffer+1
    // [397] utoa_append::value#0 = utoa::value#2
    // [398] utoa_append::sub#0 = utoa::digit_value#0
    // [399] call utoa_append
    // [467] phi from utoa::@5 to utoa_append [phi:utoa::@5->utoa_append]
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // [400] utoa_append::return#0 = utoa_append::value#2
    // utoa::@6
    // value = utoa_append(buffer++, value, digit_value)
    // [401] utoa::value#0 = utoa_append::return#0
    // value = utoa_append(buffer++, value, digit_value);
    // [402] utoa::buffer#4 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [394] phi from utoa::@6 to utoa::@4 [phi:utoa::@6->utoa::@4]
    // [394] phi utoa::buffer#14 = utoa::buffer#4 [phi:utoa::@6->utoa::@4#0] -- register_copy 
    // [394] phi utoa::started#4 = 1 [phi:utoa::@6->utoa::@4#1] -- vbum1=vbuc1 
    lda #1
    sta started
    // [394] phi utoa::value#6 = utoa::value#0 [phi:utoa::@6->utoa::@4#2] -- register_copy 
    jmp __b4
  .segment Data
    .label utoa__10 = uctoa.started
    .label utoa__11 = clrscr.l
    digit_value: .word 0
    .label digit = clrscr.l
    .label value = clrscr.ch
    .label started = clrscr.c
}
.segment Code
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
// void insertup(char rows)
insertup: {
    // __conio.width+1
    // [403] insertup::$0 = *((char *)&__conio+6) + 1 -- vbum1=_deref_pbuc1_plus_1 
    lda __conio+6
    inc
    sta insertup__0
    // unsigned char width = (__conio.width+1) * 2
    // [404] insertup::width#0 = insertup::$0 << 1 -- vbum1=vbum1_rol_1 
    // {asm{.byte $db}}
    asl width
    // [405] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [405] phi insertup::y#2 = 0 [phi:insertup->insertup::@1#0] -- vbum1=vbuc1 
    lda #0
    sta y
    // insertup::@1
  __b1:
    // for(unsigned char y=0; y<__conio.cursor_y; y++)
    // [406] if(insertup::y#2<*((char *)&__conio+1)) goto insertup::@2 -- vbum1_lt__deref_pbuc1_then_la1 
    lda y
    cmp __conio+1
    bcc __b2
    // [407] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [408] call clearline
    jsr clearline
    // insertup::@return
    // }
    // [409] return 
    rts
    // insertup::@2
  __b2:
    // y+1
    // [410] insertup::$4 = insertup::y#2 + 1 -- vbum1=vbum2_plus_1 
    lda y
    inc
    sta insertup__4
    // memcpy8_vram_vram(__conio.mapbase_bank, __conio.offsets[y], __conio.mapbase_bank, __conio.offsets[y+1], width)
    // [411] insertup::$6 = insertup::y#2 << 1 -- vbum1=vbum2_rol_1 
    lda y
    asl
    sta insertup__6
    // [412] insertup::$7 = insertup::$4 << 1 -- vbum1=vbum1_rol_1 
    asl insertup__7
    // [413] memcpy8_vram_vram::dbank_vram#0 = *((char *)&__conio+5) -- vbum1=_deref_pbuc1 
    lda __conio+5
    sta memcpy8_vram_vram.dbank_vram
    // [414] memcpy8_vram_vram::doffset_vram#0 = ((unsigned int *)&__conio+$15)[insertup::$6] -- vwum1=pwuc1_derefidx_vbum2 
    ldy insertup__6
    lda __conio+$15,y
    sta memcpy8_vram_vram.doffset_vram
    lda __conio+$15+1,y
    sta memcpy8_vram_vram.doffset_vram+1
    // [415] memcpy8_vram_vram::sbank_vram#0 = *((char *)&__conio+5) -- vbum1=_deref_pbuc1 
    lda __conio+5
    sta memcpy8_vram_vram.sbank_vram
    // [416] memcpy8_vram_vram::soffset_vram#0 = ((unsigned int *)&__conio+$15)[insertup::$7] -- vwum1=pwuc1_derefidx_vbum2 
    ldy insertup__7
    lda __conio+$15,y
    sta memcpy8_vram_vram.soffset_vram
    lda __conio+$15+1,y
    sta memcpy8_vram_vram.soffset_vram+1
    // [417] memcpy8_vram_vram::num8#1 = insertup::width#0 -- vbum1=vbum2 
    lda width
    sta memcpy8_vram_vram.num8_1
    // [418] call memcpy8_vram_vram
    jsr memcpy8_vram_vram
    // insertup::@4
    // for(unsigned char y=0; y<__conio.cursor_y; y++)
    // [419] insertup::y#1 = ++ insertup::y#2 -- vbum1=_inc_vbum1 
    inc y
    // [405] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [405] phi insertup::y#2 = insertup::y#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    insertup__0: .byte 0
    .label insertup__4 = memcpy8_vram_vram.num8_1
    insertup__6: .byte 0
    .label insertup__7 = memcpy8_vram_vram.num8_1
    .label width = insertup__0
    y: .byte 0
}
.segment Code
  // clearline
// void clearline()
clearline: {
    .label c = $28
    // unsigned int addr = __conio.offsets[__conio.cursor_y]
    // [420] clearline::$3 = *((char *)&__conio+1) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda __conio+1
    asl
    sta clearline__3
    // [421] clearline::addr#0 = ((unsigned int *)&__conio+$15)[clearline::$3] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda __conio+$15,y
    sta addr
    lda __conio+$15+1,y
    sta addr+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [422] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(addr)
    // [423] clearline::$0 = byte0  clearline::addr#0 -- vbum1=_byte0_vwum2 
    lda addr
    sta clearline__0
    // *VERA_ADDRX_L = BYTE0(addr)
    // [424] *VERA_ADDRX_L = clearline::$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(addr)
    // [425] clearline::$1 = byte1  clearline::addr#0 -- vbum1=_byte1_vwum2 
    lda addr+1
    sta clearline__1
    // *VERA_ADDRX_M = BYTE1(addr)
    // [426] *VERA_ADDRX_M = clearline::$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [427] clearline::$2 = *((char *)&__conio+5) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    sta clearline__2
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [428] *VERA_ADDRX_H = clearline::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // register unsigned char c=__conio.width
    // [429] clearline::c#0 = *((char *)&__conio+6) -- vbuz1=_deref_pbuc1 
    lda __conio+6
    sta.z c
    // [430] phi from clearline clearline::@1 to clearline::@1 [phi:clearline/clearline::@1->clearline::@1]
    // [430] phi clearline::c#2 = clearline::c#0 [phi:clearline/clearline::@1->clearline::@1#0] -- register_copy 
    // clearline::@1
  __b1:
    // *VERA_DATA0 = ' '
    // [431] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [432] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // c--;
    // [433] clearline::c#1 = -- clearline::c#2 -- vbuz1=_dec_vbuz1 
    dec.z c
    // while(c)
    // [434] if(0!=clearline::c#1) goto clearline::@1 -- 0_neq_vbuz1_then_la1 
    lda.z c
    bne __b1
    // clearline::@return
    // }
    // [435] return 
    rts
  .segment Data
    .label clearline__0 = insertup.y
    .label clearline__1 = insertup.y
    .label clearline__2 = insertup.y
    .label clearline__3 = insertup.y
    .label addr = memcpy8_vram_vram.doffset_vram
}
.segment Code
  // uctoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __mem() char uctoa_append(__zp($26) char *buffer, __mem() char value, __mem() char sub)
uctoa_append: {
    .label buffer = $26
    // [437] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [437] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbum1=vbuc1 
    lda #0
    sta digit
    // [437] phi uctoa_append::value#2 = uctoa_append::value#0 [phi:uctoa_append->uctoa_append::@1#1] -- register_copy 
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [438] if(uctoa_append::value#2>=uctoa_append::sub#0) goto uctoa_append::@2 -- vbum1_ge_vbum2_then_la1 
    lda value
    cmp sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [439] *uctoa_append::buffer#0 = DIGITS[uctoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    ldy digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // uctoa_append::@return
    // }
    // [440] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [441] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // value -= sub
    // [442] uctoa_append::value#1 = uctoa_append::value#2 - uctoa_append::sub#0 -- vbum1=vbum1_minus_vbum2 
    lda value
    sec
    sbc sub
    sta value
    // [437] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [437] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    // [437] phi uctoa_append::value#2 = uctoa_append::value#1 [phi:uctoa_append::@2->uctoa_append::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label value = clrscr.c
    .label sub = printf_number_buffer.format_upper_case
    .label return = clrscr.c
    .label digit = uctoa.started
}
.segment Code
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __mem() unsigned int strlen(__zp($22) char *str)
strlen: {
    .label str = $22
    // [444] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [444] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta len
    sta len+1
    // [444] phi strlen::str#2 = (char *)&printf_number_buffer::buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:strlen->strlen::@1#1] -- pbuz1=pbuc1 
    lda #<printf_number_buffer.buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z str
    lda #>printf_number_buffer.buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z str+1
    // strlen::@1
  __b1:
    // while(*str)
    // [445] if(0!=*strlen::str#2) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [446] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [447] strlen::len#1 = ++ strlen::len#2 -- vwum1=_inc_vwum1 
    inc len
    bne !+
    inc len+1
  !:
    // str++;
    // [448] strlen::str#0 = ++ strlen::str#2 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [444] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [444] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [444] phi strlen::str#2 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label len = clrscr.ch
    .label return = clrscr.ch
}
.segment Code
  // printf_padding
// Print a padding char a number of times
// void printf_padding(__zp($22) void (*putc)(char), __mem() char pad, __mem() char length)
printf_padding: {
    .label putc = $22
    // [450] phi from printf_padding to printf_padding::@1 [phi:printf_padding->printf_padding::@1]
    // [450] phi printf_padding::i#2 = 0 [phi:printf_padding->printf_padding::@1#0] -- vbum1=vbuc1 
    lda #0
    sta i
    // printf_padding::@1
  __b1:
    // for(char i=0;i<length; i++)
    // [451] if(printf_padding::i#2<printf_padding::length#4) goto printf_padding::@2 -- vbum1_lt_vbum2_then_la1 
    lda i
    cmp length
    bcc __b2
    // printf_padding::@return
    // }
    // [452] return 
    rts
    // printf_padding::@2
  __b2:
    // putc(pad)
    // [453] stackpush(char) = printf_padding::pad#5 -- _stackpushbyte_=vbum1 
    lda pad
    pha
    // [454] callexecute *printf_padding::putc#5  -- call__deref_pprz1 
    jsr icall3
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_padding::@3
    // for(char i=0;i<length; i++)
    // [456] printf_padding::i#1 = ++ printf_padding::i#2 -- vbum1=_inc_vbum1 
    inc i
    // [450] phi from printf_padding::@3 to printf_padding::@1 [phi:printf_padding::@3->printf_padding::@1]
    // [450] phi printf_padding::i#2 = printf_padding::i#1 [phi:printf_padding::@3->printf_padding::@1#0] -- register_copy 
    jmp __b1
    // Outside Flow
  icall3:
    jmp (putc)
  .segment Data
    i: .byte 0
    .label length = printf_number_buffer.len
    pad: .byte 0
}
.segment Code
  // strupr
// Converts a string to uppercase.
// char * strupr(char *str)
strupr: {
    .label str = printf_number_buffer.buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label src = $22
    // [458] phi from strupr to strupr::@1 [phi:strupr->strupr::@1]
    // [458] phi strupr::src#2 = strupr::str#0 [phi:strupr->strupr::@1#0] -- pbuz1=pbuc1 
    lda #<str
    sta.z src
    lda #>str
    sta.z src+1
    // strupr::@1
  __b1:
    // while(*src)
    // [459] if(0!=*strupr::src#2) goto strupr::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strupr::@return
    // }
    // [460] return 
    rts
    // strupr::@2
  __b2:
    // toupper(*src)
    // [461] toupper::ch#0 = *strupr::src#2 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta toupper.ch
    // [462] call toupper
    jsr toupper
    // [463] toupper::return#3 = toupper::return#2
    // strupr::@3
    // [464] strupr::$0 = toupper::return#3
    // *src = toupper(*src)
    // [465] *strupr::src#2 = strupr::$0 -- _deref_pbuz1=vbum2 
    lda strupr__0
    ldy #0
    sta (src),y
    // src++;
    // [466] strupr::src#1 = ++ strupr::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [458] phi from strupr::@3 to strupr::@1 [phi:strupr::@3->strupr::@1]
    // [458] phi strupr::src#2 = strupr::src#1 [phi:strupr::@3->strupr::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    .label strupr__0 = printf_number_buffer.format_upper_case
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
// __mem() unsigned int utoa_append(__zp($22) char *buffer, __mem() unsigned int value, __mem() unsigned int sub)
utoa_append: {
    .label buffer = $22
    // [468] phi from utoa_append to utoa_append::@1 [phi:utoa_append->utoa_append::@1]
    // [468] phi utoa_append::digit#2 = 0 [phi:utoa_append->utoa_append::@1#0] -- vbum1=vbuc1 
    lda #0
    sta digit
    // [468] phi utoa_append::value#2 = utoa_append::value#0 [phi:utoa_append->utoa_append::@1#1] -- register_copy 
    // utoa_append::@1
  __b1:
    // while (value >= sub)
    // [469] if(utoa_append::value#2>=utoa_append::sub#0) goto utoa_append::@2 -- vwum1_ge_vwum2_then_la1 
    lda sub+1
    cmp value+1
    bne !+
    lda sub
    cmp value
    beq __b2
  !:
    bcc __b2
    // utoa_append::@3
    // *buffer = DIGITS[digit]
    // [470] *utoa_append::buffer#0 = DIGITS[utoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    ldy digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // utoa_append::@return
    // }
    // [471] return 
    rts
    // utoa_append::@2
  __b2:
    // digit++;
    // [472] utoa_append::digit#1 = ++ utoa_append::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // value -= sub
    // [473] utoa_append::value#1 = utoa_append::value#2 - utoa_append::sub#0 -- vwum1=vwum1_minus_vwum2 
    lda value
    sec
    sbc sub
    sta value
    lda value+1
    sbc sub+1
    sta value+1
    // [468] phi from utoa_append::@2 to utoa_append::@1 [phi:utoa_append::@2->utoa_append::@1]
    // [468] phi utoa_append::digit#2 = utoa_append::digit#1 [phi:utoa_append::@2->utoa_append::@1#0] -- register_copy 
    // [468] phi utoa_append::value#2 = utoa_append::value#1 [phi:utoa_append::@2->utoa_append::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label value = clrscr.ch
    .label sub = utoa.digit_value
    .label return = clrscr.ch
    .label digit = clrscr.c
}
.segment Code
  // memcpy8_vram_vram
/**
 * @brief Copy a block of memory in VRAM from a source to a target destination.
 * This function is designed to copy maximum 255 bytes of memory in one step.
 * If more than 255 bytes need to be copied, use the memcpy_vram_vram function.
 *
 * @see memcpy_vram_vram
 *
 * @param dbank_vram Bank of the destination location in vram.
 * @param doffset_vram Offset of the destination location in vram.
 * @param sbank_vram Bank of the source location in vram.
 * @param soffset_vram Offset of the source location in vram.
 * @param num16 Specified the amount of bytes to be copied.
 */
// void memcpy8_vram_vram(__mem() char dbank_vram, __mem() unsigned int doffset_vram, __mem() char sbank_vram, __mem() unsigned int soffset_vram, __mem() char num8)
memcpy8_vram_vram: {
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [474] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(soffset_vram)
    // [475] memcpy8_vram_vram::$0 = byte0  memcpy8_vram_vram::soffset_vram#0 -- vbum1=_byte0_vwum2 
    lda soffset_vram
    sta memcpy8_vram_vram__0
    // *VERA_ADDRX_L = BYTE0(soffset_vram)
    // [476] *VERA_ADDRX_L = memcpy8_vram_vram::$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(soffset_vram)
    // [477] memcpy8_vram_vram::$1 = byte1  memcpy8_vram_vram::soffset_vram#0 -- vbum1=_byte1_vwum2 
    lda soffset_vram+1
    sta memcpy8_vram_vram__1
    // *VERA_ADDRX_M = BYTE1(soffset_vram)
    // [478] *VERA_ADDRX_M = memcpy8_vram_vram::$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // sbank_vram | VERA_INC_1
    // [479] memcpy8_vram_vram::$2 = memcpy8_vram_vram::sbank_vram#0 | VERA_INC_1 -- vbum1=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora memcpy8_vram_vram__2
    sta memcpy8_vram_vram__2
    // *VERA_ADDRX_H = sbank_vram | VERA_INC_1
    // [480] *VERA_ADDRX_H = memcpy8_vram_vram::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [481] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [482] memcpy8_vram_vram::$3 = byte0  memcpy8_vram_vram::doffset_vram#0 -- vbum1=_byte0_vwum2 
    lda doffset_vram
    sta memcpy8_vram_vram__3
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [483] *VERA_ADDRX_L = memcpy8_vram_vram::$3 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [484] memcpy8_vram_vram::$4 = byte1  memcpy8_vram_vram::doffset_vram#0 -- vbum1=_byte1_vwum2 
    lda doffset_vram+1
    sta memcpy8_vram_vram__4
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [485] *VERA_ADDRX_M = memcpy8_vram_vram::$4 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // dbank_vram | VERA_INC_1
    // [486] memcpy8_vram_vram::$5 = memcpy8_vram_vram::dbank_vram#0 | VERA_INC_1 -- vbum1=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora memcpy8_vram_vram__5
    sta memcpy8_vram_vram__5
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [487] *VERA_ADDRX_H = memcpy8_vram_vram::$5 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // [488] phi from memcpy8_vram_vram memcpy8_vram_vram::@2 to memcpy8_vram_vram::@1 [phi:memcpy8_vram_vram/memcpy8_vram_vram::@2->memcpy8_vram_vram::@1]
  __b1:
    // [488] phi memcpy8_vram_vram::num8#2 = memcpy8_vram_vram::num8#1 [phi:memcpy8_vram_vram/memcpy8_vram_vram::@2->memcpy8_vram_vram::@1#0] -- register_copy 
  // the size is only a byte, this is the fastest loop!
    // memcpy8_vram_vram::@1
    // while (num8--)
    // [489] memcpy8_vram_vram::num8#0 = -- memcpy8_vram_vram::num8#2 -- vbum1=_dec_vbum2 
    ldy num8_1
    dey
    sty num8
    // [490] if(0!=memcpy8_vram_vram::num8#2) goto memcpy8_vram_vram::@2 -- 0_neq_vbum1_then_la1 
    lda num8_1
    bne __b2
    // memcpy8_vram_vram::@return
    // }
    // [491] return 
    rts
    // memcpy8_vram_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [492] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // [493] memcpy8_vram_vram::num8#6 = memcpy8_vram_vram::num8#0 -- vbum1=vbum2 
    lda num8
    sta num8_1
    jmp __b1
  .segment Data
    memcpy8_vram_vram__0: .byte 0
    .label memcpy8_vram_vram__1 = memcpy8_vram_vram__0
    .label memcpy8_vram_vram__2 = insertup.insertup__6
    .label memcpy8_vram_vram__3 = insertup.insertup__6
    .label memcpy8_vram_vram__4 = insertup.insertup__6
    .label memcpy8_vram_vram__5 = dbank_vram
    .label num8 = insertup.insertup__6
    dbank_vram: .byte 0
    doffset_vram: .word 0
    .label sbank_vram = insertup.insertup__6
    soffset_vram: .word 0
    num8_1: .byte 0
}
.segment Code
  // toupper
// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
// __mem() char toupper(__mem() char ch)
toupper: {
    // if(ch>='a' && ch<='z')
    // [494] if(toupper::ch#0<'a') goto toupper::@return -- vbum1_lt_vbuc1_then_la1 
    lda ch
    cmp #'a'
    bcc __breturn
    // toupper::@2
    // [495] if(toupper::ch#0<='z') goto toupper::@1 -- vbum1_le_vbuc1_then_la1 
    lda #'z'
    cmp ch
    bcs __b1
    // [497] phi from toupper toupper::@1 toupper::@2 to toupper::@return [phi:toupper/toupper::@1/toupper::@2->toupper::@return]
    // [497] phi toupper::return#2 = toupper::ch#0 [phi:toupper/toupper::@1/toupper::@2->toupper::@return#0] -- register_copy 
    rts
    // toupper::@1
  __b1:
    // return ch + ('A'-'a');
    // [496] toupper::return#0 = toupper::ch#0 + 'A'-'a' -- vbum1=vbum1_plus_vbuc1 
    lda #'A'-'a'
    clc
    adc return
    sta return
    // toupper::@return
  __breturn:
    // }
    // [498] return 
    rts
  .segment Data
    .label return = printf_number_buffer.format_upper_case
    .label ch = printf_number_buffer.format_upper_case
}
  // File Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // The random state variable
  rand_state: .word 1
  __conio: .fill SIZEOF_STRUCT___1, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
  //Asm library lib-bramheap:
  #define __asm_import__
  #import "lib-bramheap.asm"
