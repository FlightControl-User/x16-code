.namespace lru_cache {


  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  .const SIZEOF_STRUCT___1 = $8f
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .const SIZEOF_STRUCT___0 = $384

  .const CBM_PLOT = $fff0

.segment Code
  // __start
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
    // [8] phi from __start::@2 to conio_x16_init [phi:__start::@2->conio_x16_init] -- call_phi_near 
    jsr conio_x16_init
    // [5] phi from __start::@2 to __start::@1 [phi:__start::@2->__start::@1]
    // __start::@1
    // [6] call main
    // [359] phi from __start::@1 to main [phi:__start::@1->main] -- call_phi_near 
    jsr main
    // __start::@return
    // [7] return 
    rts
}
.segment segm_lru_cache_bin
  // conio_x16_init
/// Set initial screen values.
conio_x16_init: {
    // screenlayer1()
    // [9] call screenlayer1 -- call_phi_near 
    jsr screenlayer1
    // [10] phi from conio_x16_init to conio_x16_init::@1 [phi:conio_x16_init->conio_x16_init::@1]
    // conio_x16_init::@1
    // textcolor(CONIO_TEXTCOLOR_DEFAULT)
    // [11] call textcolor -- call_phi_near 
    jsr textcolor
    // [12] phi from conio_x16_init::@1 to conio_x16_init::@2 [phi:conio_x16_init::@1->conio_x16_init::@2]
    // conio_x16_init::@2
    // bgcolor(CONIO_BACKCOLOR_DEFAULT)
    // [13] call bgcolor -- call_phi_near 
    jsr bgcolor
    // [14] phi from conio_x16_init::@2 to conio_x16_init::@3 [phi:conio_x16_init::@2->conio_x16_init::@3]
    // conio_x16_init::@3
    // cursor(0)
    // [15] call cursor -- call_phi_near 
    jsr cursor
    // [16] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // cbm_k_plot_get()
    // [17] call cbm_k_plot_get -- call_phi_near 
    jsr cbm_k_plot_get
    // [18] cbm_k_plot_get::return#2 = cbm_k_plot_get::return#0 -- vwum1=vwum2 
    lda cbm_k_plot_get.return
    sta cbm_k_plot_get.return_1
    lda cbm_k_plot_get.return+1
    sta cbm_k_plot_get.return_1+1
    // conio_x16_init::@5
    // [19] conio_x16_init::$4 = cbm_k_plot_get::return#2 -- vwum1=vwum2 
    lda cbm_k_plot_get.return_1
    sta conio_x16_init__4
    lda cbm_k_plot_get.return_1+1
    sta conio_x16_init__4+1
    // BYTE1(cbm_k_plot_get())
    // [20] conio_x16_init::$5 = byte1  conio_x16_init::$4 -- vbuaa=_byte1_vwum1 
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [21] *((char *)&__conio) = conio_x16_init::$5 -- _deref_pbuc1=vbuaa 
    sta __conio
    // cbm_k_plot_get()
    // [22] call cbm_k_plot_get -- call_phi_near 
    jsr cbm_k_plot_get
    // [23] cbm_k_plot_get::return#3 = cbm_k_plot_get::return#0 -- vwum1=vwum2 
    lda cbm_k_plot_get.return
    sta cbm_k_plot_get.return_2
    lda cbm_k_plot_get.return+1
    sta cbm_k_plot_get.return_2+1
    // conio_x16_init::@6
    // [24] conio_x16_init::$6 = cbm_k_plot_get::return#3 -- vwum1=vwum2 
    lda cbm_k_plot_get.return_2
    sta conio_x16_init__6
    lda cbm_k_plot_get.return_2+1
    sta conio_x16_init__6+1
    // BYTE0(cbm_k_plot_get())
    // [25] conio_x16_init::$7 = byte0  conio_x16_init::$6 -- vbuaa=_byte0_vwum1 
    lda conio_x16_init__6
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [26] *((char *)&__conio+1) = conio_x16_init::$7 -- _deref_pbuc1=vbuaa 
    sta __conio+1
    // gotoxy(__conio.cursor_x, __conio.cursor_y)
    // [27] gotoxy::x#1 = *((char *)&__conio) -- vbuaa=_deref_pbuc1 
    lda __conio
    // [28] gotoxy::y#1 = *((char *)&__conio+1) -- vbuxx=_deref_pbuc1 
    ldx __conio+1
    // [29] call gotoxy
    // [380] phi from conio_x16_init::@6 to gotoxy [phi:conio_x16_init::@6->gotoxy]
    // [380] phi gotoxy::y#10 = gotoxy::y#1 [phi:conio_x16_init::@6->gotoxy#0] -- register_copy 
    // [380] phi gotoxy::x#4 = gotoxy::x#1 [phi:conio_x16_init::@6->gotoxy#1] -- call_phi_near 
    jsr gotoxy
    // conio_x16_init::@7
    // __conio.scroll[0] = 1
    // [30] *((char *)&__conio+$f) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta __conio+$f
    // __conio.scroll[1] = 1
    // [31] *((char *)&__conio+$f+1) = 1 -- _deref_pbuc1=vbuc2 
    sta __conio+$f+1
    // conio_x16_init::@return
    // }
    // [32] return 
    rts
    conio_x16_init__4: .word 0
    conio_x16_init__6: .word 0
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__register(X) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    // [33] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbuxx=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    tax
    // if(c=='\n')
    // [34] if(cputc::c#0==' 'pm) goto cputc::@1 -- vbuxx_eq_vbuc1_then_la1 
  .encoding "petscii_mixed"
    cpx #'\n'
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [35] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(__conio.offset)
    // [36] cputc::$1 = byte0  *((unsigned int *)&__conio+$13) -- vbuaa=_byte0__deref_pwuc1 
    lda __conio+$13
    // *VERA_ADDRX_L = BYTE0(__conio.offset)
    // [37] *VERA_ADDRX_L = cputc::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(__conio.offset)
    // [38] cputc::$2 = byte1  *((unsigned int *)&__conio+$13) -- vbuaa=_byte1__deref_pwuc1 
    lda __conio+$13+1
    // *VERA_ADDRX_M = BYTE1(__conio.offset)
    // [39] *VERA_ADDRX_M = cputc::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [40] cputc::$3 = *((char *)&__conio+5) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [41] *VERA_ADDRX_H = cputc::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [42] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [43] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // if(!__conio.hscroll[__conio.layer])
    // [44] if(0==((char *)&__conio+$11)[*((char *)&__conio+2)]) goto cputc::@5 -- 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$11,y
    cmp #0
    beq __b5
    // cputc::@3
    // if(__conio.cursor_x >= __conio.mapwidth)
    // [45] if(*((char *)&__conio)>=*((char *)&__conio+8)) goto cputc::@6 -- _deref_pbuc1_ge__deref_pbuc2_then_la1 
    lda __conio
    cmp __conio+8
    bcs __b6
    // cputc::@4
    // __conio.cursor_x++;
    // [46] *((char *)&__conio) = ++ *((char *)&__conio) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio
    // cputc::@7
  __b7:
    // __conio.offset++;
    // [47] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // [48] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // cputc::@return
    // }
    // [49] return 
    rts
    // [50] phi from cputc::@3 to cputc::@6 [phi:cputc::@3->cputc::@6]
    // cputc::@6
  __b6:
    // cputln()
    // [51] call cputln -- call_phi_near 
    jsr cputln
    jmp __b7
    // cputc::@5
  __b5:
    // if(__conio.cursor_x >= __conio.width)
    // [52] if(*((char *)&__conio)>=*((char *)&__conio+6)) goto cputc::@8 -- _deref_pbuc1_ge__deref_pbuc2_then_la1 
    lda __conio
    cmp __conio+6
    bcs __b8
    // cputc::@9
    // __conio.cursor_x++;
    // [53] *((char *)&__conio) = ++ *((char *)&__conio) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio
    // __conio.offset++;
    // [54] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // [55] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    rts
    // [56] phi from cputc::@5 to cputc::@8 [phi:cputc::@5->cputc::@8]
    // cputc::@8
  __b8:
    // cputln()
    // [57] call cputln -- call_phi_near 
    jsr cputln
    rts
    // [58] phi from cputc to cputc::@1 [phi:cputc->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [59] call cputln -- call_phi_near 
    jsr cputln
    rts
}
  // lru_cache_display
// Only for debugging
// void lru_cache_display(__register(Y) char x, __register(X) char y)
lru_cache_display: {
    .const OFFSET_STACK_X = 1
    .const OFFSET_STACK_Y = 0
    // [60] lru_cache_display::x#0 = stackidx(char,lru_cache_display::OFFSET_STACK_X) -- vbuyy=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_X,x
    tay
    // [61] lru_cache_display::y#0 = stackidx(char,lru_cache_display::OFFSET_STACK_Y) -- vbuxx=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_Y,x
    tax
    // gotoxy(x, y)
    // [62] gotoxy::x#0 = lru_cache_display::x#0 -- vbuaa=vbuyy 
    tya
    // [63] gotoxy::y#0 = lru_cache_display::y#0
    // [64] call gotoxy
    // [380] phi from lru_cache_display to gotoxy [phi:lru_cache_display->gotoxy]
    // [380] phi gotoxy::y#10 = gotoxy::y#0 [phi:lru_cache_display->gotoxy#0] -- register_copy 
    // [380] phi gotoxy::x#4 = gotoxy::x#0 [phi:lru_cache_display->gotoxy#1] -- call_phi_near 
    jsr gotoxy
    // [65] phi from lru_cache_display to lru_cache_display::@17 [phi:lru_cache_display->lru_cache_display::@17]
    // lru_cache_display::@17
    // printf("least recently used cache statistics\n")
    // [66] call printf_str
    // [403] phi from lru_cache_display::@17 to printf_str [phi:lru_cache_display::@17->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s [phi:lru_cache_display::@17->printf_str#0] -- call_phi_near 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // [67] phi from lru_cache_display::@17 to lru_cache_display::@18 [phi:lru_cache_display::@17->lru_cache_display::@18]
    // lru_cache_display::@18
    // printf("size = %3u, first = %2x, last = %2x, count = %2x\n\n", LRU_CACHE_SIZE, lru_cache.first, lru_cache.last, lru_cache.count)
    // [68] call printf_str
    // [403] phi from lru_cache_display::@18 to printf_str [phi:lru_cache_display::@18->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s1 [phi:lru_cache_display::@18->printf_str#0] -- call_phi_near 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [69] phi from lru_cache_display::@18 to lru_cache_display::@19 [phi:lru_cache_display::@18->lru_cache_display::@19]
    // lru_cache_display::@19
    // printf("size = %3u, first = %2x, last = %2x, count = %2x\n\n", LRU_CACHE_SIZE, lru_cache.first, lru_cache.last, lru_cache.count)
    // [70] call printf_uint
    // [412] phi from lru_cache_display::@19 to printf_uint [phi:lru_cache_display::@19->printf_uint]
    // [412] phi printf_uint::format_zero_padding#4 = 0 [phi:lru_cache_display::@19->printf_uint#0] -- vbum1=vbuc1 
    lda #0
    sta printf_uint.format_zero_padding
    // [412] phi printf_uint::format_min_length#4 = 3 [phi:lru_cache_display::@19->printf_uint#1] -- vbum1=vbuc1 
    lda #3
    sta printf_uint.format_min_length
    // [412] phi printf_uint::format_radix#4 = DECIMAL [phi:lru_cache_display::@19->printf_uint#2] -- vbuxx=vbuc1 
    ldx #DECIMAL
    // [412] phi printf_uint::uvalue#4 = $80 [phi:lru_cache_display::@19->printf_uint#3] -- call_phi_near 
    lda #<$80
    sta printf_uint.uvalue
    lda #>$80
    sta printf_uint.uvalue+1
    jsr printf_uint
    // [71] phi from lru_cache_display::@19 to lru_cache_display::@20 [phi:lru_cache_display::@19->lru_cache_display::@20]
    // lru_cache_display::@20
    // printf("size = %3u, first = %2x, last = %2x, count = %2x\n\n", LRU_CACHE_SIZE, lru_cache.first, lru_cache.last, lru_cache.count)
    // [72] call printf_str
    // [403] phi from lru_cache_display::@20 to printf_str [phi:lru_cache_display::@20->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s2 [phi:lru_cache_display::@20->printf_str#0] -- call_phi_near 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@21
    // printf("size = %3u, first = %2x, last = %2x, count = %2x\n\n", LRU_CACHE_SIZE, lru_cache.first, lru_cache.last, lru_cache.count)
    // [73] printf_uchar::uvalue#0 = *((char *)&lru_cache+$381) -- vbuxx=_deref_pbuc1 
    ldx lru_cache+$381
    // [74] call printf_uchar
    // [422] phi from lru_cache_display::@21 to printf_uchar [phi:lru_cache_display::@21->printf_uchar]
    // [422] phi printf_uchar::format_zero_padding#10 = 0 [phi:lru_cache_display::@21->printf_uchar#0] -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_zero_padding
    // [422] phi printf_uchar::format_min_length#10 = 2 [phi:lru_cache_display::@21->printf_uchar#1] -- vbum1=vbuc1 
    lda #2
    sta printf_uchar.format_min_length
    // [422] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#0 [phi:lru_cache_display::@21->printf_uchar#2] -- call_phi_near 
    jsr printf_uchar
    // [75] phi from lru_cache_display::@21 to lru_cache_display::@22 [phi:lru_cache_display::@21->lru_cache_display::@22]
    // lru_cache_display::@22
    // printf("size = %3u, first = %2x, last = %2x, count = %2x\n\n", LRU_CACHE_SIZE, lru_cache.first, lru_cache.last, lru_cache.count)
    // [76] call printf_str
    // [403] phi from lru_cache_display::@22 to printf_str [phi:lru_cache_display::@22->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s3 [phi:lru_cache_display::@22->printf_str#0] -- call_phi_near 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@23
    // printf("size = %3u, first = %2x, last = %2x, count = %2x\n\n", LRU_CACHE_SIZE, lru_cache.first, lru_cache.last, lru_cache.count)
    // [77] printf_uchar::uvalue#1 = *((char *)&lru_cache+$382) -- vbuxx=_deref_pbuc1 
    ldx lru_cache+$382
    // [78] call printf_uchar
    // [422] phi from lru_cache_display::@23 to printf_uchar [phi:lru_cache_display::@23->printf_uchar]
    // [422] phi printf_uchar::format_zero_padding#10 = 0 [phi:lru_cache_display::@23->printf_uchar#0] -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_zero_padding
    // [422] phi printf_uchar::format_min_length#10 = 2 [phi:lru_cache_display::@23->printf_uchar#1] -- vbum1=vbuc1 
    lda #2
    sta printf_uchar.format_min_length
    // [422] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#1 [phi:lru_cache_display::@23->printf_uchar#2] -- call_phi_near 
    jsr printf_uchar
    // [79] phi from lru_cache_display::@23 to lru_cache_display::@24 [phi:lru_cache_display::@23->lru_cache_display::@24]
    // lru_cache_display::@24
    // printf("size = %3u, first = %2x, last = %2x, count = %2x\n\n", LRU_CACHE_SIZE, lru_cache.first, lru_cache.last, lru_cache.count)
    // [80] call printf_str
    // [403] phi from lru_cache_display::@24 to printf_str [phi:lru_cache_display::@24->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s4 [phi:lru_cache_display::@24->printf_str#0] -- call_phi_near 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@25
    // printf("size = %3u, first = %2x, last = %2x, count = %2x\n\n", LRU_CACHE_SIZE, lru_cache.first, lru_cache.last, lru_cache.count)
    // [81] printf_uchar::uvalue#2 = *((char *)&lru_cache+$380) -- vbuxx=_deref_pbuc1 
    ldx lru_cache+$380
    // [82] call printf_uchar
    // [422] phi from lru_cache_display::@25 to printf_uchar [phi:lru_cache_display::@25->printf_uchar]
    // [422] phi printf_uchar::format_zero_padding#10 = 0 [phi:lru_cache_display::@25->printf_uchar#0] -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_zero_padding
    // [422] phi printf_uchar::format_min_length#10 = 2 [phi:lru_cache_display::@25->printf_uchar#1] -- vbum1=vbuc1 
    lda #2
    sta printf_uchar.format_min_length
    // [422] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#2 [phi:lru_cache_display::@25->printf_uchar#2] -- call_phi_near 
    jsr printf_uchar
    // [83] phi from lru_cache_display::@25 to lru_cache_display::@26 [phi:lru_cache_display::@25->lru_cache_display::@26]
    // lru_cache_display::@26
    // printf("size = %3u, first = %2x, last = %2x, count = %2x\n\n", LRU_CACHE_SIZE, lru_cache.first, lru_cache.last, lru_cache.count)
    // [84] call printf_str
    // [403] phi from lru_cache_display::@26 to printf_str [phi:lru_cache_display::@26->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s5 [phi:lru_cache_display::@26->printf_str#0] -- call_phi_near 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // [85] phi from lru_cache_display::@26 to lru_cache_display::@27 [phi:lru_cache_display::@26->lru_cache_display::@27]
    // lru_cache_display::@27
    // printf("least recently used hash table\n\n")
    // [86] call printf_str
    // [403] phi from lru_cache_display::@27 to printf_str [phi:lru_cache_display::@27->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s6 [phi:lru_cache_display::@27->printf_str#0] -- call_phi_near 
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    jsr printf_str
    // [87] phi from lru_cache_display::@27 to lru_cache_display::@28 [phi:lru_cache_display::@27->lru_cache_display::@28]
    // lru_cache_display::@28
    // printf("   ")
    // [88] call printf_str
    // [403] phi from lru_cache_display::@28 to printf_str [phi:lru_cache_display::@28->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s7 [phi:lru_cache_display::@28->printf_str#0] -- call_phi_near 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // [89] phi from lru_cache_display::@28 to lru_cache_display::@1 [phi:lru_cache_display::@28->lru_cache_display::@1]
    // [89] phi lru_cache_display::col#10 = 0 [phi:lru_cache_display::@28->lru_cache_display::@1#0] -- vbum1=vbuc1 
    lda #0
    sta col
    // [89] phi from lru_cache_display::@33 to lru_cache_display::@1 [phi:lru_cache_display::@33->lru_cache_display::@1]
    // [89] phi lru_cache_display::col#10 = lru_cache_display::col#1 [phi:lru_cache_display::@33->lru_cache_display::@1#0] -- register_copy 
    // lru_cache_display::@1
  __b1:
    // printf("   %1x/%1x  ", col, col + 8)
    // [90] printf_uint::uvalue#1 = lru_cache_display::col#10 + 8 -- vwum1=vbum2_plus_vbuc1 
    lda #8
    clc
    adc col
    sta printf_uint.uvalue
    lda #0
    adc #0
    sta printf_uint.uvalue+1
    // [91] call printf_str
    // [403] phi from lru_cache_display::@1 to printf_str [phi:lru_cache_display::@1->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s7 [phi:lru_cache_display::@1->printf_str#0] -- call_phi_near 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@29
    // printf("   %1x/%1x  ", col, col + 8)
    // [92] printf_uchar::uvalue#3 = lru_cache_display::col#10 -- vbuxx=vbum1 
    ldx col
    // [93] call printf_uchar
    // [422] phi from lru_cache_display::@29 to printf_uchar [phi:lru_cache_display::@29->printf_uchar]
    // [422] phi printf_uchar::format_zero_padding#10 = 0 [phi:lru_cache_display::@29->printf_uchar#0] -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_zero_padding
    // [422] phi printf_uchar::format_min_length#10 = 1 [phi:lru_cache_display::@29->printf_uchar#1] -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_min_length
    // [422] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#3 [phi:lru_cache_display::@29->printf_uchar#2] -- call_phi_near 
    jsr printf_uchar
    // [94] phi from lru_cache_display::@29 to lru_cache_display::@30 [phi:lru_cache_display::@29->lru_cache_display::@30]
    // lru_cache_display::@30
    // printf("   %1x/%1x  ", col, col + 8)
    // [95] call printf_str
    // [403] phi from lru_cache_display::@30 to printf_str [phi:lru_cache_display::@30->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s9 [phi:lru_cache_display::@30->printf_str#0] -- call_phi_near 
    lda #<s9
    sta.z printf_str.s
    lda #>s9
    sta.z printf_str.s+1
    jsr printf_str
    // [96] phi from lru_cache_display::@30 to lru_cache_display::@31 [phi:lru_cache_display::@30->lru_cache_display::@31]
    // lru_cache_display::@31
    // printf("   %1x/%1x  ", col, col + 8)
    // [97] call printf_uint
    // [412] phi from lru_cache_display::@31 to printf_uint [phi:lru_cache_display::@31->printf_uint]
    // [412] phi printf_uint::format_zero_padding#4 = 0 [phi:lru_cache_display::@31->printf_uint#0] -- vbum1=vbuc1 
    lda #0
    sta printf_uint.format_zero_padding
    // [412] phi printf_uint::format_min_length#4 = 1 [phi:lru_cache_display::@31->printf_uint#1] -- vbum1=vbuc1 
    lda #1
    sta printf_uint.format_min_length
    // [412] phi printf_uint::format_radix#4 = HEXADECIMAL [phi:lru_cache_display::@31->printf_uint#2] -- vbuxx=vbuc1 
    ldx #HEXADECIMAL
    // [412] phi printf_uint::uvalue#4 = printf_uint::uvalue#1 [phi:lru_cache_display::@31->printf_uint#3] -- call_phi_near 
    jsr printf_uint
    // [98] phi from lru_cache_display::@31 to lru_cache_display::@32 [phi:lru_cache_display::@31->lru_cache_display::@32]
    // lru_cache_display::@32
    // printf("   %1x/%1x  ", col, col + 8)
    // [99] call printf_str
    // [403] phi from lru_cache_display::@32 to printf_str [phi:lru_cache_display::@32->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s10 [phi:lru_cache_display::@32->printf_str#0] -- call_phi_near 
    lda #<s10
    sta.z printf_str.s
    lda #>s10
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@33
    // col++;
    // [100] lru_cache_display::col#1 = ++ lru_cache_display::col#10 -- vbum1=_inc_vbum1 
    inc col
    // while (col < 8)
    // [101] if(lru_cache_display::col#1<8) goto lru_cache_display::@1 -- vbum1_lt_vbuc1_then_la1 
    lda col
    cmp #8
    bcc __b1
    // [102] phi from lru_cache_display::@33 to lru_cache_display::@2 [phi:lru_cache_display::@33->lru_cache_display::@2]
    // lru_cache_display::@2
    // printf("\n")
    // [103] call printf_str
    // [403] phi from lru_cache_display::@2 to printf_str [phi:lru_cache_display::@2->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s11 [phi:lru_cache_display::@2->printf_str#0] -- call_phi_near 
    lda #<s11
    sta.z printf_str.s
    lda #>s11
    sta.z printf_str.s+1
    jsr printf_str
    // [104] phi from lru_cache_display::@2 to lru_cache_display::@3 [phi:lru_cache_display::@2->lru_cache_display::@3]
    // [104] phi lru_cache_display::index1#0 = 0 [phi:lru_cache_display::@2->lru_cache_display::@3#0] -- vbum1=vbuc1 
    lda #0
    sta index1
    // [104] phi from lru_cache_display::@46 to lru_cache_display::@3 [phi:lru_cache_display::@46->lru_cache_display::@3]
    // [104] phi lru_cache_display::index1#0 = lru_cache_display::index_row#1 [phi:lru_cache_display::@46->lru_cache_display::@3#0] -- register_copy 
    // lru_cache_display::@3
  __b3:
    // printf("%02x:", index)
    // [105] printf_uchar::uvalue#4 = lru_cache_display::index1#0 -- vbuxx=vbum1 
    ldx index1
    // [106] call printf_uchar
    // [422] phi from lru_cache_display::@3 to printf_uchar [phi:lru_cache_display::@3->printf_uchar]
    // [422] phi printf_uchar::format_zero_padding#10 = 1 [phi:lru_cache_display::@3->printf_uchar#0] -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [422] phi printf_uchar::format_min_length#10 = 2 [phi:lru_cache_display::@3->printf_uchar#1] -- vbum1=vbuc1 
    lda #2
    sta printf_uchar.format_min_length
    // [422] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#4 [phi:lru_cache_display::@3->printf_uchar#2] -- call_phi_near 
    jsr printf_uchar
    // [107] phi from lru_cache_display::@3 to lru_cache_display::@34 [phi:lru_cache_display::@3->lru_cache_display::@34]
    // lru_cache_display::@34
    // printf("%02x:", index)
    // [108] call printf_str
    // [403] phi from lru_cache_display::@34 to printf_str [phi:lru_cache_display::@34->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s12 [phi:lru_cache_display::@34->printf_str#0] -- call_phi_near 
    lda #<s12
    sta.z printf_str.s
    lda #>s12
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@35
    // [109] lru_cache_display::index1#23 = lru_cache_display::index1#0 -- vbum1=vbum2 
    lda index1
    sta index1_1
    // [110] phi from lru_cache_display::@35 lru_cache_display::@6 to lru_cache_display::@4 [phi:lru_cache_display::@35/lru_cache_display::@6->lru_cache_display::@4]
    // [110] phi lru_cache_display::index1#12 = lru_cache_display::index1#23 [phi:lru_cache_display::@35/lru_cache_display::@6->lru_cache_display::@4#0] -- register_copy 
    // lru_cache_display::@4
  __b4:
    // lru_cache.key[index] != LRU_CACHE_NOTHING
    // [111] lru_cache_display::$31 = lru_cache_display::index1#12 << 1 -- vbum1=vbum2_rol_1 
    lda index1_1
    asl
    sta lru_cache_display__31
    // if (lru_cache.key[index] != LRU_CACHE_NOTHING)
    // [112] if(((unsigned int *)&lru_cache)[lru_cache_display::$31]!=$ffff) goto lru_cache_display::@5 -- pwuc1_derefidx_vbum1_neq_vwuc2_then_la1 
    tay
    lda lru_cache+1,y
    cmp #>$ffff
    beq !__b5+
    jmp __b5
  !__b5:
    lda lru_cache,y
    cmp #<$ffff
    beq !__b5+
    jmp __b5
  !__b5:
    // [113] phi from lru_cache_display::@4 to lru_cache_display::@7 [phi:lru_cache_display::@4->lru_cache_display::@7]
    // lru_cache_display::@7
    // printf(" ----:--")
    // [114] call printf_str
    // [403] phi from lru_cache_display::@7 to printf_str [phi:lru_cache_display::@7->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s15 [phi:lru_cache_display::@7->printf_str#0] -- call_phi_near 
    lda #<s15
    sta.z printf_str.s
    lda #>s15
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@6
  __b6:
    // index++;
    // [115] lru_cache_display::index1#1 = ++ lru_cache_display::index1#12 -- vbum1=_inc_vbum1 
    inc index1_1
    // index_row + 8
    // [116] lru_cache_display::$16 = lru_cache_display::index1#0 + 8 -- vbuaa=vbum1_plus_vbuc1 
    lda #8
    clc
    adc index1
    // while (index < index_row + 8)
    // [117] if(lru_cache_display::index1#1<lru_cache_display::$16) goto lru_cache_display::@4 -- vbum1_lt_vbuaa_then_la1 
    cmp index1_1
    beq !+
    bcs __b4
  !:
    // [118] phi from lru_cache_display::@6 to lru_cache_display::@8 [phi:lru_cache_display::@6->lru_cache_display::@8]
    // lru_cache_display::@8
    // printf("\n")
    // [119] call printf_str
    // [403] phi from lru_cache_display::@8 to printf_str [phi:lru_cache_display::@8->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s11 [phi:lru_cache_display::@8->printf_str#0] -- call_phi_near 
    lda #<s11
    sta.z printf_str.s
    lda #>s11
    sta.z printf_str.s+1
    jsr printf_str
    // [120] phi from lru_cache_display::@8 to lru_cache_display::@39 [phi:lru_cache_display::@8->lru_cache_display::@39]
    // lru_cache_display::@39
    // printf("  :")
    // [121] call printf_str
    // [403] phi from lru_cache_display::@39 to printf_str [phi:lru_cache_display::@39->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s17 [phi:lru_cache_display::@39->printf_str#0] -- call_phi_near 
    lda #<s17
    sta.z printf_str.s
    lda #>s17
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@40
    // [122] lru_cache_display::index1#25 = lru_cache_display::index1#0 -- vbum1=vbum2 
    lda index1
    sta index1_2
    // [123] phi from lru_cache_display::@40 lru_cache_display::@45 to lru_cache_display::@9 [phi:lru_cache_display::@40/lru_cache_display::@45->lru_cache_display::@9]
    // [123] phi lru_cache_display::index1#10 = lru_cache_display::index1#25 [phi:lru_cache_display::@40/lru_cache_display::@45->lru_cache_display::@9#0] -- register_copy 
    // lru_cache_display::@9
  __b9:
    // printf(" %02x:", lru_cache.next[index])
    // [124] call printf_str
    // [403] phi from lru_cache_display::@9 to printf_str [phi:lru_cache_display::@9->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s13 [phi:lru_cache_display::@9->printf_str#0] -- call_phi_near 
    lda #<s13
    sta.z printf_str.s
    lda #>s13
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@41
    // printf(" %02x:", lru_cache.next[index])
    // [125] printf_uchar::uvalue#6 = ((char *)&lru_cache+$280)[lru_cache_display::index1#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy index1_2
    ldx lru_cache+$280,y
    // [126] call printf_uchar
    // [422] phi from lru_cache_display::@41 to printf_uchar [phi:lru_cache_display::@41->printf_uchar]
    // [422] phi printf_uchar::format_zero_padding#10 = 1 [phi:lru_cache_display::@41->printf_uchar#0] -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [422] phi printf_uchar::format_min_length#10 = 2 [phi:lru_cache_display::@41->printf_uchar#1] -- vbum1=vbuc1 
    lda #2
    sta printf_uchar.format_min_length
    // [422] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#6 [phi:lru_cache_display::@41->printf_uchar#2] -- call_phi_near 
    jsr printf_uchar
    // [127] phi from lru_cache_display::@41 to lru_cache_display::@42 [phi:lru_cache_display::@41->lru_cache_display::@42]
    // lru_cache_display::@42
    // printf(" %02x:", lru_cache.next[index])
    // [128] call printf_str
    // [403] phi from lru_cache_display::@42 to printf_str [phi:lru_cache_display::@42->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s12 [phi:lru_cache_display::@42->printf_str#0] -- call_phi_near 
    lda #<s12
    sta.z printf_str.s
    lda #>s12
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@43
    // printf("%02x  ", lru_cache.prev[index])
    // [129] printf_uchar::uvalue#7 = ((char *)&lru_cache+$200)[lru_cache_display::index1#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy index1_2
    ldx lru_cache+$200,y
    // [130] call printf_uchar
    // [422] phi from lru_cache_display::@43 to printf_uchar [phi:lru_cache_display::@43->printf_uchar]
    // [422] phi printf_uchar::format_zero_padding#10 = 1 [phi:lru_cache_display::@43->printf_uchar#0] -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [422] phi printf_uchar::format_min_length#10 = 2 [phi:lru_cache_display::@43->printf_uchar#1] -- vbum1=vbuc1 
    lda #2
    sta printf_uchar.format_min_length
    // [422] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#7 [phi:lru_cache_display::@43->printf_uchar#2] -- call_phi_near 
    jsr printf_uchar
    // [131] phi from lru_cache_display::@43 to lru_cache_display::@44 [phi:lru_cache_display::@43->lru_cache_display::@44]
    // lru_cache_display::@44
    // printf("%02x  ", lru_cache.prev[index])
    // [132] call printf_str
    // [403] phi from lru_cache_display::@44 to printf_str [phi:lru_cache_display::@44->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s10 [phi:lru_cache_display::@44->printf_str#0] -- call_phi_near 
    lda #<s10
    sta.z printf_str.s
    lda #>s10
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@45
    // index++;
    // [133] lru_cache_display::index1#3 = ++ lru_cache_display::index1#10 -- vbum1=_inc_vbum1 
    inc index1_2
    // index_row + 8
    // [134] lru_cache_display::$22 = lru_cache_display::index1#0 + 8 -- vbuaa=vbum1_plus_vbuc1 
    lda #8
    clc
    adc index1
    // while (index < index_row + 8)
    // [135] if(lru_cache_display::index1#3<lru_cache_display::$22) goto lru_cache_display::@9 -- vbum1_lt_vbuaa_then_la1 
    cmp index1_2
    beq !+
    bcs __b9
  !:
    // [136] phi from lru_cache_display::@45 to lru_cache_display::@10 [phi:lru_cache_display::@45->lru_cache_display::@10]
    // lru_cache_display::@10
    // printf("\n")
    // [137] call printf_str
    // [403] phi from lru_cache_display::@10 to printf_str [phi:lru_cache_display::@10->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s11 [phi:lru_cache_display::@10->printf_str#0] -- call_phi_near 
    lda #<s11
    sta.z printf_str.s
    lda #>s11
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@46
    // index_row += 8
    // [138] lru_cache_display::index_row#1 = lru_cache_display::index1#0 + 8 -- vbum1=vbum1_plus_vbuc1 
    lda #8
    clc
    adc index_row
    sta index_row
    // while (index_row < 128)
    // [139] if(lru_cache_display::index_row#1<$80) goto lru_cache_display::@3 -- vbum1_lt_vbuc1_then_la1 
    cmp #$80
    bcs !__b3+
    jmp __b3
  !__b3:
    // [140] phi from lru_cache_display::@46 to lru_cache_display::@11 [phi:lru_cache_display::@46->lru_cache_display::@11]
    // lru_cache_display::@11
    // printf("\n")
    // [141] call printf_str
    // [403] phi from lru_cache_display::@11 to printf_str [phi:lru_cache_display::@11->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s11 [phi:lru_cache_display::@11->printf_str#0] -- call_phi_near 
    lda #<s11
    sta.z printf_str.s
    lda #>s11
    sta.z printf_str.s+1
    jsr printf_str
    // [142] phi from lru_cache_display::@11 to lru_cache_display::@47 [phi:lru_cache_display::@11->lru_cache_display::@47]
    // lru_cache_display::@47
    // printf("least recently used sequence\n")
    // [143] call printf_str
    // [403] phi from lru_cache_display::@47 to printf_str [phi:lru_cache_display::@47->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s23 [phi:lru_cache_display::@47->printf_str#0] -- call_phi_near 
    lda #<s23
    sta.z printf_str.s
    lda #>s23
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@48
    // lru_cache_index_t index = lru_cache.first
    // [144] lru_cache_display::index#0 = *((char *)&lru_cache+$381) -- vbum1=_deref_pbuc1 
    lda lru_cache+$381
    sta index
    // [145] phi from lru_cache_display::@48 to lru_cache_display::@12 [phi:lru_cache_display::@48->lru_cache_display::@12]
    // [145] phi lru_cache_display::index#2 = lru_cache_display::index#0 [phi:lru_cache_display::@48->lru_cache_display::@12#0] -- register_copy 
    // [145] phi lru_cache_display::count#2 = 0 [phi:lru_cache_display::@48->lru_cache_display::@12#1] -- vbum1=vbuc1 
    lda #0
    sta count
    // lru_cache_display::@12
  __b12:
    // while (count < lru_cache.size)
    // [146] if(lru_cache_display::count#2<*((char *)&lru_cache+$383)) goto lru_cache_display::@13 -- vbum1_lt__deref_pbuc1_then_la1 
    lda count
    cmp lru_cache+$383
    bcc __b13
    // lru_cache_display::@return
    // }
    // [147] return 
    rts
    // lru_cache_display::@13
  __b13:
    // if (count < lru_cache.count)
    // [148] if(lru_cache_display::count#2<*((char *)&lru_cache+$380)) goto lru_cache_display::@14 -- vbum1_lt__deref_pbuc1_then_la1 
    lda count
    cmp lru_cache+$380
    bcc __b14
    // [149] phi from lru_cache_display::@13 to lru_cache_display::@16 [phi:lru_cache_display::@13->lru_cache_display::@16]
    // lru_cache_display::@16
    // printf("    ")
    // [150] call printf_str
    // [403] phi from lru_cache_display::@16 to printf_str [phi:lru_cache_display::@16->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s25 [phi:lru_cache_display::@16->printf_str#0] -- call_phi_near 
    lda #<s25
    sta.z printf_str.s
    lda #>s25
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@15
  __b15:
    // index = lru_cache.next[index]
    // [151] lru_cache_display::index#1 = ((char *)&lru_cache+$280)[lru_cache_display::index#2] -- vbum1=pbuc1_derefidx_vbum1 
    //printf(" %4x %3uN %3uP ", lru_cache.key[cache_index], lru_cache.next[cache_index], lru_cache.prev[cache_index]);
    ldy index
    lda lru_cache+$280,y
    sta index
    // count++;
    // [152] lru_cache_display::count#1 = ++ lru_cache_display::count#2 -- vbum1=_inc_vbum1 
    inc count
    // [145] phi from lru_cache_display::@15 to lru_cache_display::@12 [phi:lru_cache_display::@15->lru_cache_display::@12]
    // [145] phi lru_cache_display::index#2 = lru_cache_display::index#1 [phi:lru_cache_display::@15->lru_cache_display::@12#0] -- register_copy 
    // [145] phi lru_cache_display::count#2 = lru_cache_display::count#1 [phi:lru_cache_display::@15->lru_cache_display::@12#1] -- register_copy 
    jmp __b12
    // [153] phi from lru_cache_display::@13 to lru_cache_display::@14 [phi:lru_cache_display::@13->lru_cache_display::@14]
    // lru_cache_display::@14
  __b14:
    // printf(" %4x", lru_cache.key[index])
    // [154] call printf_str
    // [403] phi from lru_cache_display::@14 to printf_str [phi:lru_cache_display::@14->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s13 [phi:lru_cache_display::@14->printf_str#0] -- call_phi_near 
    lda #<s13
    sta.z printf_str.s
    lda #>s13
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@49
    // printf(" %4x", lru_cache.key[index])
    // [155] lru_cache_display::$32 = lru_cache_display::index#2 << 1 -- vbuaa=vbum1_rol_1 
    lda index
    asl
    // [156] printf_uint::uvalue#3 = ((unsigned int *)&lru_cache)[lru_cache_display::$32] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda lru_cache,y
    sta printf_uint.uvalue
    lda lru_cache+1,y
    sta printf_uint.uvalue+1
    // [157] call printf_uint
    // [412] phi from lru_cache_display::@49 to printf_uint [phi:lru_cache_display::@49->printf_uint]
    // [412] phi printf_uint::format_zero_padding#4 = 0 [phi:lru_cache_display::@49->printf_uint#0] -- vbum1=vbuc1 
    lda #0
    sta printf_uint.format_zero_padding
    // [412] phi printf_uint::format_min_length#4 = 4 [phi:lru_cache_display::@49->printf_uint#1] -- vbum1=vbuc1 
    lda #4
    sta printf_uint.format_min_length
    // [412] phi printf_uint::format_radix#4 = HEXADECIMAL [phi:lru_cache_display::@49->printf_uint#2] -- vbuxx=vbuc1 
    ldx #HEXADECIMAL
    // [412] phi printf_uint::uvalue#4 = printf_uint::uvalue#3 [phi:lru_cache_display::@49->printf_uint#3] -- call_phi_near 
    jsr printf_uint
    jmp __b15
    // [158] phi from lru_cache_display::@4 to lru_cache_display::@5 [phi:lru_cache_display::@4->lru_cache_display::@5]
    // lru_cache_display::@5
  __b5:
    // printf(" %04x:", lru_cache.key[index])
    // [159] call printf_str
    // [403] phi from lru_cache_display::@5 to printf_str [phi:lru_cache_display::@5->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s13 [phi:lru_cache_display::@5->printf_str#0] -- call_phi_near 
    lda #<s13
    sta.z printf_str.s
    lda #>s13
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@36
    // printf(" %04x:", lru_cache.key[index])
    // [160] printf_uint::uvalue#2 = ((unsigned int *)&lru_cache)[lru_cache_display::$31] -- vwum1=pwuc1_derefidx_vbum2 
    ldy lru_cache_display__31
    lda lru_cache,y
    sta printf_uint.uvalue
    lda lru_cache+1,y
    sta printf_uint.uvalue+1
    // [161] call printf_uint
    // [412] phi from lru_cache_display::@36 to printf_uint [phi:lru_cache_display::@36->printf_uint]
    // [412] phi printf_uint::format_zero_padding#4 = 1 [phi:lru_cache_display::@36->printf_uint#0] -- vbum1=vbuc1 
    lda #1
    sta printf_uint.format_zero_padding
    // [412] phi printf_uint::format_min_length#4 = 4 [phi:lru_cache_display::@36->printf_uint#1] -- vbum1=vbuc1 
    lda #4
    sta printf_uint.format_min_length
    // [412] phi printf_uint::format_radix#4 = HEXADECIMAL [phi:lru_cache_display::@36->printf_uint#2] -- vbuxx=vbuc1 
    ldx #HEXADECIMAL
    // [412] phi printf_uint::uvalue#4 = printf_uint::uvalue#2 [phi:lru_cache_display::@36->printf_uint#3] -- call_phi_near 
    jsr printf_uint
    // [162] phi from lru_cache_display::@36 to lru_cache_display::@37 [phi:lru_cache_display::@36->lru_cache_display::@37]
    // lru_cache_display::@37
    // printf(" %04x:", lru_cache.key[index])
    // [163] call printf_str
    // [403] phi from lru_cache_display::@37 to printf_str [phi:lru_cache_display::@37->printf_str]
    // [403] phi printf_str::s#29 = lru_cache_display::s12 [phi:lru_cache_display::@37->printf_str#0] -- call_phi_near 
    lda #<s12
    sta.z printf_str.s
    lda #>s12
    sta.z printf_str.s+1
    jsr printf_str
    // lru_cache_display::@38
    // printf("%02x", lru_cache.link[index])
    // [164] printf_uchar::uvalue#5 = ((char *)&lru_cache+$300)[lru_cache_display::index1#12] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy index1_1
    ldx lru_cache+$300,y
    // [165] call printf_uchar
    // [422] phi from lru_cache_display::@38 to printf_uchar [phi:lru_cache_display::@38->printf_uchar]
    // [422] phi printf_uchar::format_zero_padding#10 = 1 [phi:lru_cache_display::@38->printf_uchar#0] -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [422] phi printf_uchar::format_min_length#10 = 2 [phi:lru_cache_display::@38->printf_uchar#1] -- vbum1=vbuc1 
    lda #2
    sta printf_uchar.format_min_length
    // [422] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#5 [phi:lru_cache_display::@38->printf_uchar#2] -- call_phi_near 
    jsr printf_uchar
    jmp __b6
    s: .text @"least recently used cache statistics\n"
    .byte 0
    s1: .text "size = "
    .byte 0
    s2: .text ", first = "
    .byte 0
    s3: .text ", last = "
    .byte 0
    s4: .text ", count = "
    .byte 0
    s5: .text @"\n\n"
    .byte 0
    s6: .text @"least recently used hash table\n\n"
    .byte 0
    s7: .text "   "
    .byte 0
    s9: .text "/"
    .byte 0
    s10: .text "  "
    .byte 0
    s11: .text @"\n"
    .byte 0
    s12: .text ":"
    .byte 0
    s13: .text " "
    .byte 0
    s15: .text " ----:--"
    .byte 0
    s17: .text "  :"
    .byte 0
    s23: .text @"least recently used sequence\n"
    .byte 0
    s25: .text "    "
    .byte 0
    lru_cache_display__31: .byte 0
    col: .byte 0
    index1: .byte 0
    index1_1: .byte 0
    index1_2: .byte 0
    .label index_row = index1
    index: .byte 0
    count: .byte 0
}
  // lru_cache_delete
// __mem() unsigned int lru_cache_delete(__mem() unsigned int key)
lru_cache_delete: {
    .const OFFSET_STACK_KEY = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [166] lru_cache_delete::key#0 = stackidx(unsigned int,lru_cache_delete::OFFSET_STACK_KEY) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_KEY,x
    sta key
    lda STACK_BASE+OFFSET_STACK_KEY+1,x
    sta key+1
    // lru_cache_index_t index = lru_cache_hash(key)
    // [167] lru_cache_hash::key#2 = lru_cache_delete::key#0 -- vwum1=vwum2 
    lda key
    sta lru_cache_hash.key
    lda key+1
    sta lru_cache_hash.key+1
    // [168] call lru_cache_hash
    // [431] phi from lru_cache_delete to lru_cache_hash [phi:lru_cache_delete->lru_cache_hash]
    // [431] phi lru_cache_hash::key#4 = lru_cache_hash::key#2 [phi:lru_cache_delete->lru_cache_hash#0] -- call_phi_near 
    jsr lru_cache_hash
    // lru_cache_index_t index = lru_cache_hash(key)
    // [169] lru_cache_hash::return#4 = lru_cache_hash::return#0
    // lru_cache_delete::@14
    // [170] lru_cache_delete::index#0 = lru_cache_hash::return#4 -- vbuxx=vbuaa 
    tax
    // [171] phi from lru_cache_delete::@14 to lru_cache_delete::@1 [phi:lru_cache_delete::@14->lru_cache_delete::@1]
    // [171] phi lru_cache_delete::index_prev#10 = $ff [phi:lru_cache_delete::@14->lru_cache_delete::@1#0] -- vbum1=vbuc1 
    lda #$ff
    sta index_prev
    // [171] phi lru_cache_delete::index#2 = lru_cache_delete::index#0 [phi:lru_cache_delete::@14->lru_cache_delete::@1#1] -- register_copy 
    // lru_cache_delete::@1
  __b1:
    // lru_cache.key[index] != LRU_CACHE_NOTHING
    // [172] lru_cache_delete::$16 = lru_cache_delete::index#2 << 1 -- vbum1=vbuxx_rol_1 
    txa
    asl
    sta lru_cache_delete__16
    // while (lru_cache.key[index] != LRU_CACHE_NOTHING)
    // [173] if(((unsigned int *)&lru_cache)[lru_cache_delete::$16]!=$ffff) goto lru_cache_delete::@2 -- pwuc1_derefidx_vbum1_neq_vwuc2_then_la1 
    tay
    lda lru_cache+1,y
    cmp #>$ffff
    bne __b2
    lda lru_cache,y
    cmp #<$ffff
    bne __b2
    // [174] phi from lru_cache_delete::@1 to lru_cache_delete::@return [phi:lru_cache_delete::@1->lru_cache_delete::@return]
    // [174] phi lru_cache_delete::return#2 = $ffff [phi:lru_cache_delete::@1->lru_cache_delete::@return#0] -- vwum1=vwuc1 
    lda #<$ffff
    sta return
    lda #>$ffff
    sta return+1
    // lru_cache_delete::@return
  __breturn:
    // }
    // [175] stackidx(unsigned int,lru_cache_delete::OFFSET_STACK_RETURN_0) = lru_cache_delete::return#2 -- _stackidxword_vbuc1=vwum1 
    tsx
    lda return
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [176] return 
    rts
    // lru_cache_delete::@2
  __b2:
    // if (lru_cache.key[index] == key)
    // [177] if(((unsigned int *)&lru_cache)[lru_cache_delete::$16]!=lru_cache_delete::key#0) goto lru_cache_delete::@3 -- pwuc1_derefidx_vbum1_neq_vwum2_then_la1 
    ldy lru_cache_delete__16
    lda key+1
    cmp lru_cache+1,y
    beq !__b3+
    jmp __b3
  !__b3:
    lda key
    cmp lru_cache,y
    beq !__b3+
    jmp __b3
  !__b3:
    // lru_cache_delete::@11
    // lru_cache_data_t data = lru_cache.data[index]
    // [178] lru_cache_delete::data#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_delete::$16] -- vwum1=pwuc1_derefidx_vbum2 
    lda lru_cache+$100,y
    sta data
    lda lru_cache+$100+1,y
    sta data+1
    // lru_cache.key[index] = LRU_CACHE_NOTHING
    // [179] ((unsigned int *)&lru_cache)[lru_cache_delete::$16] = $ffff -- pwuc1_derefidx_vbum1=vwuc2 
    // First remove the index node.
    lda #<$ffff
    sta lru_cache,y
    lda #>$ffff
    sta lru_cache+1,y
    // lru_cache.data[index] = LRU_CACHE_NOTHING
    // [180] ((unsigned int *)&lru_cache+$100)[lru_cache_delete::$16] = $ffff -- pwuc1_derefidx_vbum1=vwuc2 
    lda #<$ffff
    sta lru_cache+$100,y
    lda #>$ffff
    sta lru_cache+$100+1,y
    // lru_cache_index_t next = lru_cache.next[index]
    // [181] lru_cache_delete::next#0 = ((char *)&lru_cache+$280)[lru_cache_delete::index#2] -- vbum1=pbuc1_derefidx_vbuxx 
    lda lru_cache+$280,x
    sta next
    // lru_cache_index_t prev = lru_cache.prev[index]
    // [182] lru_cache_delete::prev#0 = ((char *)&lru_cache+$200)[lru_cache_delete::index#2] -- vbum1=pbuc1_derefidx_vbuxx 
    lda lru_cache+$200,x
    sta prev
    // lru_cache.next[index] = LRU_CACHE_INDEX_NULL
    // [183] ((char *)&lru_cache+$280)[lru_cache_delete::index#2] = $ff -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #$ff
    sta lru_cache+$280,x
    // lru_cache.prev[index] = LRU_CACHE_INDEX_NULL
    // [184] ((char *)&lru_cache+$200)[lru_cache_delete::index#2] = $ff -- pbuc1_derefidx_vbuxx=vbuc2 
    sta lru_cache+$200,x
    // if (lru_cache.next[index] == index)
    // [185] if(((char *)&lru_cache+$280)[lru_cache_delete::index#2]==lru_cache_delete::index#2) goto lru_cache_delete::@4 -- pbuc1_derefidx_vbuxx_eq_vbuxx_then_la1 
    lda lru_cache+$280,x
    tay
    sty.z $ff
    cpx.z $ff
    bne !__b4+
    jmp __b4
  !__b4:
    // lru_cache_delete::@12
    // lru_cache.next[prev] = next
    // [186] ((char *)&lru_cache+$280)[lru_cache_delete::prev#0] = lru_cache_delete::next#0 -- pbuc1_derefidx_vbum1=vbum2 
    // Delete the node from the list.
    lda next
    ldy prev
    sta lru_cache+$280,y
    // lru_cache.prev[next] = prev
    // [187] ((char *)&lru_cache+$200)[lru_cache_delete::next#0] = lru_cache_delete::prev#0 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy next
    sta lru_cache+$200,y
    // if (index == lru_cache.first)
    // [188] if(lru_cache_delete::index#2!=*((char *)&lru_cache+$381)) goto lru_cache_delete::@5 -- vbuxx_neq__deref_pbuc1_then_la1 
    cpx lru_cache+$381
    bne __b5
    // lru_cache_delete::@13
    // lru_cache.first = next
    // [189] *((char *)&lru_cache+$381) = lru_cache_delete::next#0 -- _deref_pbuc1=vbum1 
    tya
    sta lru_cache+$381
    // lru_cache_delete::@5
  __b5:
    // if (index == lru_cache.last)
    // [190] if(lru_cache_delete::index#2!=*((char *)&lru_cache+$382)) goto lru_cache_delete::@7 -- vbuxx_neq__deref_pbuc1_then_la1 
    cpx lru_cache+$382
    bne __b7
    // lru_cache_delete::@6
    // lru_cache.last = prev
    // [191] *((char *)&lru_cache+$382) = lru_cache_delete::prev#0 -- _deref_pbuc1=vbum1 
    lda prev
    sta lru_cache+$382
    // lru_cache_delete::@7
  __b7:
    // lru_cache_index_t link = lru_cache.link[index]
    // [192] lru_cache_delete::lru_cache_move_link1_index#0 = ((char *)&lru_cache+$300)[lru_cache_delete::index#2] -- vbum1=pbuc1_derefidx_vbuxx 
    lda lru_cache+$300,x
    sta lru_cache_move_link1_index
    // if (index_prev != LRU_CACHE_INDEX_NULL)
    // [193] if(lru_cache_delete::index_prev#10==$ff) goto lru_cache_delete::@8 -- vbum1_eq_vbuc1_then_la1 
    lda #$ff
    cmp index_prev
    beq __b8
    // lru_cache_delete::@10
    // lru_cache.link[index_prev] = link
    // [194] ((char *)&lru_cache+$300)[lru_cache_delete::index_prev#10] = lru_cache_delete::lru_cache_move_link1_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    // The node is not the first node but the middle of a list.
    lda lru_cache_move_link1_index
    ldy index_prev
    sta lru_cache+$300,y
    // lru_cache_delete::@8
  __b8:
    // if (link != LRU_CACHE_INDEX_NULL)
    // [195] if(lru_cache_delete::lru_cache_move_link1_index#0==$ff) goto lru_cache_delete::@9 -- vbum1_eq_vbuc1_then_la1 
    lda #$ff
    cmp lru_cache_move_link1_index
    bne !__b9+
    jmp __b9
  !__b9:
    // lru_cache_delete::lru_cache_move_link1
    // lru_cache_index_t l = lru_cache.link[index]
    // [196] lru_cache_delete::lru_cache_move_link1_l#0 = ((char *)&lru_cache+$300)[lru_cache_delete::lru_cache_move_link1_index#0] -- vbuaa=pbuc1_derefidx_vbum1 
    ldy lru_cache_move_link1_index
    lda lru_cache+$300,y
    // lru_cache.link[link] = l
    // [197] ((char *)&lru_cache+$300)[lru_cache_delete::index#2] = lru_cache_delete::lru_cache_move_link1_l#0 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta lru_cache+$300,x
    // lru_cache_key_t key = lru_cache.key[index]
    // [198] lru_cache_delete::lru_cache_move_link1_$9 = lru_cache_delete::lru_cache_move_link1_index#0 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta lru_cache_move_link1_lru_cache_delete__9
    // [199] lru_cache_delete::lru_cache_move_link1_key#0 = ((unsigned int *)&lru_cache)[lru_cache_delete::lru_cache_move_link1_$9] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda lru_cache,y
    sta lru_cache_move_link1_key
    lda lru_cache+1,y
    sta lru_cache_move_link1_key+1
    // lru_cache.key[link] = key
    // [200] ((unsigned int *)&lru_cache)[lru_cache_delete::$16] = lru_cache_delete::lru_cache_move_link1_key#0 -- pwuc1_derefidx_vbum1=vwum2 
    ldy lru_cache_delete__16
    lda lru_cache_move_link1_key
    sta lru_cache,y
    lda lru_cache_move_link1_key+1
    sta lru_cache+1,y
    // lru_cache_data_t data = lru_cache.data[index]
    // [201] lru_cache_delete::lru_cache_move_link1_data#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_delete::lru_cache_move_link1_$9] -- vwum1=pwuc1_derefidx_vbum2 
    ldy lru_cache_move_link1_lru_cache_delete__9
    lda lru_cache+$100,y
    sta lru_cache_move_link1_data
    lda lru_cache+$100+1,y
    sta lru_cache_move_link1_data+1
    // lru_cache.data[link] = data
    // [202] ((unsigned int *)&lru_cache+$100)[lru_cache_delete::$16] = lru_cache_delete::lru_cache_move_link1_data#0 -- pwuc1_derefidx_vbum1=vwum2 
    ldy lru_cache_delete__16
    lda lru_cache_move_link1_data
    sta lru_cache+$100,y
    lda lru_cache_move_link1_data+1
    sta lru_cache+$100+1,y
    // lru_cache_index_t next = lru_cache.next[index]
    // [203] lru_cache_delete::lru_cache_move_link1_next#0 = ((char *)&lru_cache+$280)[lru_cache_delete::lru_cache_move_link1_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy lru_cache_move_link1_index
    lda lru_cache+$280,y
    sta lru_cache_move_link1_next
    // lru_cache_index_t prev = lru_cache.prev[index]
    // [204] lru_cache_delete::lru_cache_move_link1_prev#0 = ((char *)&lru_cache+$200)[lru_cache_delete::lru_cache_move_link1_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda lru_cache+$200,y
    sta lru_cache_move_link1_prev
    // lru_cache.next[link] = next
    // [205] ((char *)&lru_cache+$280)[lru_cache_delete::index#2] = lru_cache_delete::lru_cache_move_link1_next#0 -- pbuc1_derefidx_vbuxx=vbum1 
    lda lru_cache_move_link1_next
    sta lru_cache+$280,x
    // lru_cache.prev[link] = prev
    // [206] ((char *)&lru_cache+$200)[lru_cache_delete::index#2] = lru_cache_delete::lru_cache_move_link1_prev#0 -- pbuc1_derefidx_vbuxx=vbum1 
    lda lru_cache_move_link1_prev
    sta lru_cache+$200,x
    // lru_cache.next[prev] = link
    // [207] ((char *)&lru_cache+$280)[lru_cache_delete::lru_cache_move_link1_prev#0] = lru_cache_delete::index#2 -- pbuc1_derefidx_vbum1=vbuxx 
    tay
    txa
    sta lru_cache+$280,y
    // lru_cache.prev[next] = link
    // [208] ((char *)&lru_cache+$200)[lru_cache_delete::lru_cache_move_link1_next#0] = lru_cache_delete::index#2 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy lru_cache_move_link1_next
    txa
    sta lru_cache+$200,y
    // if (lru_cache.last == index)
    // [209] if(*((char *)&lru_cache+$382)!=lru_cache_delete::lru_cache_move_link1_index#0) goto lru_cache_delete::lru_cache_move_link1_@1 -- _deref_pbuc1_neq_vbum1_then_la1 
    lda lru_cache+$382
    cmp lru_cache_move_link1_index
    bne lru_cache_move_link1___b1
    // lru_cache_delete::lru_cache_move_link1_@3
    // lru_cache.last = link
    // [210] *((char *)&lru_cache+$382) = lru_cache_delete::index#2 -- _deref_pbuc1=vbuxx 
    stx lru_cache+$382
    // lru_cache_delete::lru_cache_move_link1_@1
  lru_cache_move_link1___b1:
    // if (lru_cache.first == index)
    // [211] if(*((char *)&lru_cache+$381)!=lru_cache_delete::lru_cache_move_link1_index#0) goto lru_cache_delete::lru_cache_move_link1_@2 -- _deref_pbuc1_neq_vbum1_then_la1 
    lda lru_cache+$381
    cmp lru_cache_move_link1_index
    bne lru_cache_move_link1___b2
    // lru_cache_delete::lru_cache_move_link1_@4
    // lru_cache.first = link
    // [212] *((char *)&lru_cache+$381) = lru_cache_delete::index#2 -- _deref_pbuc1=vbuxx 
    stx lru_cache+$381
    // lru_cache_delete::lru_cache_move_link1_@2
  lru_cache_move_link1___b2:
    // lru_cache.key[index] = LRU_CACHE_NOTHING
    // [213] ((unsigned int *)&lru_cache)[lru_cache_delete::lru_cache_move_link1_$9] = $ffff -- pwuc1_derefidx_vbum1=vwuc2 
    ldy lru_cache_move_link1_lru_cache_delete__9
    lda #<$ffff
    sta lru_cache,y
    lda #>$ffff
    sta lru_cache+1,y
    // lru_cache.data[index] = LRU_CACHE_NOTHING
    // [214] ((unsigned int *)&lru_cache+$100)[lru_cache_delete::lru_cache_move_link1_$9] = $ffff -- pwuc1_derefidx_vbum1=vwuc2 
    lda #<$ffff
    sta lru_cache+$100,y
    lda #>$ffff
    sta lru_cache+$100+1,y
    // lru_cache.next[index] = LRU_CACHE_INDEX_NULL
    // [215] ((char *)&lru_cache+$280)[lru_cache_delete::lru_cache_move_link1_index#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    lda #$ff
    ldy lru_cache_move_link1_index
    sta lru_cache+$280,y
    // lru_cache.prev[index] = LRU_CACHE_INDEX_NULL
    // [216] ((char *)&lru_cache+$200)[lru_cache_delete::lru_cache_move_link1_index#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta lru_cache+$200,y
    // lru_cache.link[index] = LRU_CACHE_INDEX_NULL
    // [217] ((char *)&lru_cache+$300)[lru_cache_delete::lru_cache_move_link1_index#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta lru_cache+$300,y
    // lru_cache_delete::@9
  __b9:
    // lru_cache.count--;
    // [218] *((char *)&lru_cache+$380) = -- *((char *)&lru_cache+$380) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec lru_cache+$380
    // [174] phi from lru_cache_delete::@9 to lru_cache_delete::@return [phi:lru_cache_delete::@9->lru_cache_delete::@return]
    // [174] phi lru_cache_delete::return#2 = lru_cache_delete::data#0 [phi:lru_cache_delete::@9->lru_cache_delete::@return#0] -- register_copy 
    jmp __breturn
    // lru_cache_delete::@4
  __b4:
    // lru_cache.first = 0xff
    // [219] *((char *)&lru_cache+$381) = $ff -- _deref_pbuc1=vbuc2 
    // Reset first and last node.
    lda #$ff
    sta lru_cache+$381
    // lru_cache.last = 0xff
    // [220] *((char *)&lru_cache+$382) = $ff -- _deref_pbuc1=vbuc2 
    sta lru_cache+$382
    jmp __b7
    // lru_cache_delete::@3
  __b3:
    // index_prev = index
    // [221] lru_cache_delete::index_prev#1 = lru_cache_delete::index#2 -- vbum1=vbuxx 
    stx index_prev
    // index = lru_cache.link[index]
    // [222] lru_cache_delete::index#1 = ((char *)&lru_cache+$300)[lru_cache_delete::index#2] -- vbuxx=pbuc1_derefidx_vbuxx 
    lda lru_cache+$300,x
    tax
    // [171] phi from lru_cache_delete::@3 to lru_cache_delete::@1 [phi:lru_cache_delete::@3->lru_cache_delete::@1]
    // [171] phi lru_cache_delete::index_prev#10 = lru_cache_delete::index_prev#1 [phi:lru_cache_delete::@3->lru_cache_delete::@1#0] -- register_copy 
    // [171] phi lru_cache_delete::index#2 = lru_cache_delete::index#1 [phi:lru_cache_delete::@3->lru_cache_delete::@1#1] -- register_copy 
    jmp __b1
    lru_cache_delete__16: .byte 0
    lru_cache_move_link1_lru_cache_delete__9: .byte 0
  .segment Data
    key: .word 0
  .segment segm_lru_cache_bin
    // move in array until an empty
    index_prev: .byte 0
    .label data = return
    next: .byte 0
    prev: .byte 0
    lru_cache_move_link1_index: .byte 0
    lru_cache_move_link1_key: .word 0
    lru_cache_move_link1_data: .word 0
    lru_cache_move_link1_next: .byte 0
    lru_cache_move_link1_prev: .byte 0
  .segment Data
    return: .word 0
}
.segment segm_lru_cache_bin
  // lru_cache_insert
// char lru_cache_insert(__mem() unsigned int key, __mem() unsigned int data)
lru_cache_insert: {
    .const OFFSET_STACK_KEY = 2
    .const OFFSET_STACK_DATA = 0
    .const OFFSET_STACK_RETURN_3 = 3
    // [223] lru_cache_insert::key#0 = stackidx(unsigned int,lru_cache_insert::OFFSET_STACK_KEY) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_KEY,x
    sta key
    lda STACK_BASE+OFFSET_STACK_KEY+1,x
    sta key+1
    // [224] lru_cache_insert::data#0 = stackidx(unsigned int,lru_cache_insert::OFFSET_STACK_DATA) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_DATA,x
    sta data
    lda STACK_BASE+OFFSET_STACK_DATA+1,x
    sta data+1
    // lru_cache_index_t index = lru_cache_hash(key)
    // [225] lru_cache_hash::key#1 = lru_cache_insert::key#0 -- vwum1=vwum2 
    lda key
    sta lru_cache_hash.key
    lda key+1
    sta lru_cache_hash.key+1
    // [226] call lru_cache_hash
    // [431] phi from lru_cache_insert to lru_cache_hash [phi:lru_cache_insert->lru_cache_hash]
    // [431] phi lru_cache_hash::key#4 = lru_cache_hash::key#1 [phi:lru_cache_insert->lru_cache_hash#0] -- call_phi_near 
    jsr lru_cache_hash
    // lru_cache_index_t index = lru_cache_hash(key)
    // [227] lru_cache_hash::return#3 = lru_cache_hash::return#0
    // lru_cache_insert::@10
    // [228] lru_cache_insert::index#0 = lru_cache_hash::return#3 -- vbum1=vbuaa 
    sta index
    // lru_cache_index_t link_head = lru_cache_find_head(index)
    // [229] lru_cache_find_head::index#0 = lru_cache_insert::index#0 -- vbuxx=vbum1 
    tax
    // [230] call lru_cache_find_head -- call_phi_near 
    // Check if there is already a link node in place in the hash table at the index.
    jsr lru_cache_find_head
    // [231] lru_cache_find_head::return#0 = lru_cache_find_head::return#3
    // lru_cache_insert::@11
    // [232] lru_cache_insert::link_head#0 = lru_cache_find_head::return#0 -- vbum1=vbuaa 
    sta link_head
    // lru_cache_index_t link_prev = lru_cache_find_duplicate(link_head, index)
    // [233] lru_cache_find_duplicate::index#0 = lru_cache_insert::link_head#0 -- vbuxx=vbum1 
    tax
    // [234] lru_cache_find_duplicate::link#0 = lru_cache_insert::index#0 -- vbum1=vbum2 
    lda index
    sta lru_cache_find_duplicate.link
    // [235] call lru_cache_find_duplicate
    // [445] phi from lru_cache_insert::@11 to lru_cache_find_duplicate [phi:lru_cache_insert::@11->lru_cache_find_duplicate]
    // [445] phi lru_cache_find_duplicate::link#3 = lru_cache_find_duplicate::link#0 [phi:lru_cache_insert::@11->lru_cache_find_duplicate#0] -- register_copy 
    // [445] phi lru_cache_find_duplicate::index#6 = lru_cache_find_duplicate::index#0 [phi:lru_cache_insert::@11->lru_cache_find_duplicate#1] -- call_phi_near 
    jsr lru_cache_find_duplicate
    // lru_cache_index_t link_prev = lru_cache_find_duplicate(link_head, index)
    // [236] lru_cache_find_duplicate::return#0 = lru_cache_find_duplicate::index#3
    // lru_cache_insert::@12
    // [237] lru_cache_insert::link_prev#0 = lru_cache_find_duplicate::return#0 -- vbum1=vbuxx 
    stx link_prev
    // lru_cache.key[index] != LRU_CACHE_NOTHING
    // [238] lru_cache_insert::lru_cache_move_link1_$6 = lru_cache_insert::index#0 << 1 -- vbum1=vbum2_rol_1 
    lda index
    asl
    sta lru_cache_move_link1_lru_cache_insert__6
    // if (lru_cache.key[index] != LRU_CACHE_NOTHING && link_head != LRU_CACHE_INDEX_NULL)
    // [239] if(((unsigned int *)&lru_cache)[lru_cache_insert::lru_cache_move_link1_$6]==$ffff) goto lru_cache_insert::@1 -- pwuc1_derefidx_vbum1_eq_vwuc2_then_la1 
    tay
    lda lru_cache,y
    cmp #<$ffff
    bne !+
    lda lru_cache+1,y
    cmp #>$ffff
    beq __b1
  !:
    // lru_cache_insert::@16
    // [240] if(lru_cache_insert::link_head#0!=$ff) goto lru_cache_insert::@5 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp link_head
    bne __b5
    // lru_cache_insert::@1
  __b1:
    // lru_cache_index_t index_prev = lru_cache_find_duplicate(index, LRU_CACHE_INDEX_NULL)
    // [241] lru_cache_find_duplicate::index#1 = lru_cache_insert::index#0 -- vbuxx=vbum1 
    ldx index
    // [242] call lru_cache_find_duplicate
  // We just follow the duplicate chain and find the last duplicate.
    // [445] phi from lru_cache_insert::@1 to lru_cache_find_duplicate [phi:lru_cache_insert::@1->lru_cache_find_duplicate]
    // [445] phi lru_cache_find_duplicate::link#3 = $ff [phi:lru_cache_insert::@1->lru_cache_find_duplicate#0] -- vbum1=vbuc1 
    lda #$ff
    sta lru_cache_find_duplicate.link
    // [445] phi lru_cache_find_duplicate::index#6 = lru_cache_find_duplicate::index#1 [phi:lru_cache_insert::@1->lru_cache_find_duplicate#1] -- call_phi_near 
    jsr lru_cache_find_duplicate
    // lru_cache_index_t index_prev = lru_cache_find_duplicate(index, LRU_CACHE_INDEX_NULL)
    // [243] lru_cache_find_duplicate::return#1 = lru_cache_find_duplicate::index#3
    // lru_cache_insert::@13
    // [244] lru_cache_insert::index_prev#0 = lru_cache_find_duplicate::return#1 -- vbum1=vbuxx 
    stx index_prev
    // lru_cache_find_empty(index_prev)
    // [245] lru_cache_find_empty::index#0 = lru_cache_insert::index_prev#0 -- vbuxx=vbum1 
    // [246] call lru_cache_find_empty
    // [451] phi from lru_cache_insert::@13 to lru_cache_find_empty [phi:lru_cache_insert::@13->lru_cache_find_empty]
    // [451] phi lru_cache_find_empty::index#7 = lru_cache_find_empty::index#0 [phi:lru_cache_insert::@13->lru_cache_find_empty#0] -- call_phi_near 
    jsr lru_cache_find_empty
    // lru_cache_find_empty(index_prev)
    // [247] lru_cache_find_empty::return#0 = lru_cache_find_empty::index#4
    // lru_cache_insert::@14
    // index = lru_cache_find_empty(index_prev)
    // [248] lru_cache_insert::index#1 = lru_cache_find_empty::return#0
    // lru_cache.link[index] = LRU_CACHE_INDEX_NULL
    // [249] ((char *)&lru_cache+$300)[lru_cache_insert::index#1] = $ff -- pbuc1_derefidx_vbuxx=vbuc2 
    // We set the link of the free node to INDEX_NULL, 
    // and point the link of the previous node to the empty node.
    // index != index_prev indicates there is a duplicate chain. 
    lda #$ff
    sta lru_cache+$300,x
    // if (index_prev != index)
    // [250] if(lru_cache_insert::index_prev#0==lru_cache_insert::index#1) goto lru_cache_insert::@2 -- vbum1_eq_vbuxx_then_la1 
    cpx index_prev
    beq __b2
    // lru_cache_insert::@6
    // lru_cache.link[index_prev] = index
    // [251] ((char *)&lru_cache+$300)[lru_cache_insert::index_prev#0] = lru_cache_insert::index#1 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy index_prev
    txa
    sta lru_cache+$300,y
    // lru_cache_insert::@2
  __b2:
    // lru_cache.key[index] = key
    // [252] lru_cache_insert::$20 = lru_cache_insert::index#1 << 1 -- vbuyy=vbuxx_rol_1 
    txa
    asl
    tay
    // [253] ((unsigned int *)&lru_cache)[lru_cache_insert::$20] = lru_cache_insert::key#0 -- pwuc1_derefidx_vbuyy=vwum1 
    // Now assign the key and the data.
    lda key
    sta lru_cache,y
    lda key+1
    sta lru_cache+1,y
    // lru_cache.data[index] = data
    // [254] ((unsigned int *)&lru_cache+$100)[lru_cache_insert::$20] = lru_cache_insert::data#0 -- pwuc1_derefidx_vbuyy=vwum1 
    lda data
    sta lru_cache+$100,y
    lda data+1
    sta lru_cache+$100+1,y
    // if (lru_cache.first == 0xff)
    // [255] if(*((char *)&lru_cache+$381)!=$ff) goto lru_cache_insert::@3 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #$ff
    cmp lru_cache+$381
    bne __b3
    // lru_cache_insert::@7
    // lru_cache.first = index
    // [256] *((char *)&lru_cache+$381) = lru_cache_insert::index#1 -- _deref_pbuc1=vbuxx 
    stx lru_cache+$381
    // lru_cache_insert::@3
  __b3:
    // if (lru_cache.last == 0xff)
    // [257] if(*((char *)&lru_cache+$382)!=$ff) goto lru_cache_insert::@4 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #$ff
    cmp lru_cache+$382
    bne __b4
    // lru_cache_insert::@8
    // lru_cache.last = index
    // [258] *((char *)&lru_cache+$382) = lru_cache_insert::index#1 -- _deref_pbuc1=vbuxx 
    stx lru_cache+$382
    // lru_cache_insert::@4
  __b4:
    // lru_cache.next[index] = lru_cache.first
    // [259] ((char *)&lru_cache+$280)[lru_cache_insert::index#1] = *((char *)&lru_cache+$381) -- pbuc1_derefidx_vbuxx=_deref_pbuc2 
    // Now insert the node as the first node in the list.
    lda lru_cache+$381
    sta lru_cache+$280,x
    // lru_cache.prev[lru_cache.first] = index
    // [260] ((char *)&lru_cache+$200)[*((char *)&lru_cache+$381)] = lru_cache_insert::index#1 -- pbuc1_derefidx_(_deref_pbuc2)=vbuxx 
    tay
    txa
    sta lru_cache+$200,y
    // lru_cache.next[lru_cache.last] = index
    // [261] ((char *)&lru_cache+$280)[*((char *)&lru_cache+$382)] = lru_cache_insert::index#1 -- pbuc1_derefidx_(_deref_pbuc2)=vbuxx 
    ldy lru_cache+$382
    txa
    sta lru_cache+$280,y
    // lru_cache.prev[index] = lru_cache.last
    // [262] ((char *)&lru_cache+$200)[lru_cache_insert::index#1] = *((char *)&lru_cache+$382) -- pbuc1_derefidx_vbuxx=_deref_pbuc2 
    tya
    sta lru_cache+$200,x
    // lru_cache.first = index
    // [263] *((char *)&lru_cache+$381) = lru_cache_insert::index#1 -- _deref_pbuc1=vbuxx 
    stx lru_cache+$381
    // lru_cache.count++;
    // [264] *((char *)&lru_cache+$380) = ++ *((char *)&lru_cache+$380) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc lru_cache+$380
    // lru_cache_insert::@return
    // }
    // [265] stackidx(char,lru_cache_insert::OFFSET_STACK_RETURN_3) = lru_cache_insert::index#1 -- _stackidxbyte_vbuc1=vbuxx 
    txa
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_3,x
    // [266] return 
    rts
    // lru_cache_insert::@5
  __b5:
    // lru_cache_index_t link = lru_cache_find_empty(index)
    // [267] lru_cache_find_empty::index#1 = lru_cache_insert::index#0 -- vbuxx=vbum1 
    ldx index
    // [268] call lru_cache_find_empty
  // There is already a link node, so this node is not a head node and needs to be moved.
  // Get the head node of this chain, we know this because we can get the head of the key.
  // The link of the head_link must be changed once the new place of the link node has been found.
    // [451] phi from lru_cache_insert::@5 to lru_cache_find_empty [phi:lru_cache_insert::@5->lru_cache_find_empty]
    // [451] phi lru_cache_find_empty::index#7 = lru_cache_find_empty::index#1 [phi:lru_cache_insert::@5->lru_cache_find_empty#0] -- call_phi_near 
    jsr lru_cache_find_empty
    // lru_cache_index_t link = lru_cache_find_empty(index)
    // [269] lru_cache_find_empty::return#1 = lru_cache_find_empty::index#4
    // lru_cache_insert::@15
    // [270] lru_cache_insert::lru_cache_move_link1_link#0 = lru_cache_find_empty::return#1
    // lru_cache_insert::lru_cache_move_link1
    // lru_cache_index_t l = lru_cache.link[index]
    // [271] lru_cache_insert::lru_cache_move_link1_l#0 = ((char *)&lru_cache+$300)[lru_cache_insert::index#0] -- vbuaa=pbuc1_derefidx_vbum1 
    ldy index
    lda lru_cache+$300,y
    // lru_cache.link[link] = l
    // [272] ((char *)&lru_cache+$300)[lru_cache_insert::lru_cache_move_link1_link#0] = lru_cache_insert::lru_cache_move_link1_l#0 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta lru_cache+$300,x
    // lru_cache_key_t key = lru_cache.key[index]
    // [273] lru_cache_insert::lru_cache_move_link1_key#0 = ((unsigned int *)&lru_cache)[lru_cache_insert::lru_cache_move_link1_$6] -- vwum1=pwuc1_derefidx_vbum2 
    ldy lru_cache_move_link1_lru_cache_insert__6
    lda lru_cache,y
    sta lru_cache_move_link1_key
    lda lru_cache+1,y
    sta lru_cache_move_link1_key+1
    // lru_cache.key[link] = key
    // [274] lru_cache_insert::lru_cache_move_link1_$7 = lru_cache_insert::lru_cache_move_link1_link#0 << 1 -- vbum1=vbuxx_rol_1 
    txa
    asl
    sta lru_cache_move_link1_lru_cache_insert__7
    // [275] ((unsigned int *)&lru_cache)[lru_cache_insert::lru_cache_move_link1_$7] = lru_cache_insert::lru_cache_move_link1_key#0 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda lru_cache_move_link1_key
    sta lru_cache,y
    lda lru_cache_move_link1_key+1
    sta lru_cache+1,y
    // lru_cache_data_t data = lru_cache.data[index]
    // [276] lru_cache_insert::lru_cache_move_link1_data#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_insert::lru_cache_move_link1_$6] -- vwum1=pwuc1_derefidx_vbum2 
    ldy lru_cache_move_link1_lru_cache_insert__6
    lda lru_cache+$100,y
    sta lru_cache_move_link1_data
    lda lru_cache+$100+1,y
    sta lru_cache_move_link1_data+1
    // lru_cache.data[link] = data
    // [277] ((unsigned int *)&lru_cache+$100)[lru_cache_insert::lru_cache_move_link1_$7] = lru_cache_insert::lru_cache_move_link1_data#0 -- pwuc1_derefidx_vbum1=vwum2 
    ldy lru_cache_move_link1_lru_cache_insert__7
    lda lru_cache_move_link1_data
    sta lru_cache+$100,y
    lda lru_cache_move_link1_data+1
    sta lru_cache+$100+1,y
    // lru_cache_index_t next = lru_cache.next[index]
    // [278] lru_cache_insert::lru_cache_move_link1_next#0 = ((char *)&lru_cache+$280)[lru_cache_insert::index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy index
    lda lru_cache+$280,y
    sta lru_cache_move_link1_next
    // lru_cache_index_t prev = lru_cache.prev[index]
    // [279] lru_cache_insert::lru_cache_move_link1_prev#0 = ((char *)&lru_cache+$200)[lru_cache_insert::index#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda lru_cache+$200,y
    sta lru_cache_move_link1_prev
    // lru_cache.next[link] = next
    // [280] ((char *)&lru_cache+$280)[lru_cache_insert::lru_cache_move_link1_link#0] = lru_cache_insert::lru_cache_move_link1_next#0 -- pbuc1_derefidx_vbuxx=vbum1 
    lda lru_cache_move_link1_next
    sta lru_cache+$280,x
    // lru_cache.prev[link] = prev
    // [281] ((char *)&lru_cache+$200)[lru_cache_insert::lru_cache_move_link1_link#0] = lru_cache_insert::lru_cache_move_link1_prev#0 -- pbuc1_derefidx_vbuxx=vbum1 
    lda lru_cache_move_link1_prev
    sta lru_cache+$200,x
    // lru_cache.next[prev] = link
    // [282] ((char *)&lru_cache+$280)[lru_cache_insert::lru_cache_move_link1_prev#0] = lru_cache_insert::lru_cache_move_link1_link#0 -- pbuc1_derefidx_vbum1=vbuxx 
    tay
    txa
    sta lru_cache+$280,y
    // lru_cache.prev[next] = link
    // [283] ((char *)&lru_cache+$200)[lru_cache_insert::lru_cache_move_link1_next#0] = lru_cache_insert::lru_cache_move_link1_link#0 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy lru_cache_move_link1_next
    txa
    sta lru_cache+$200,y
    // if (lru_cache.last == index)
    // [284] if(*((char *)&lru_cache+$382)!=lru_cache_insert::index#0) goto lru_cache_insert::lru_cache_move_link1_@1 -- _deref_pbuc1_neq_vbum1_then_la1 
    lda lru_cache+$382
    cmp index
    bne lru_cache_move_link1___b1
    // lru_cache_insert::lru_cache_move_link1_@3
    // lru_cache.last = link
    // [285] *((char *)&lru_cache+$382) = lru_cache_insert::lru_cache_move_link1_link#0 -- _deref_pbuc1=vbuxx 
    stx lru_cache+$382
    // lru_cache_insert::lru_cache_move_link1_@1
  lru_cache_move_link1___b1:
    // if (lru_cache.first == index)
    // [286] if(*((char *)&lru_cache+$381)!=lru_cache_insert::index#0) goto lru_cache_insert::lru_cache_move_link1_@2 -- _deref_pbuc1_neq_vbum1_then_la1 
    lda lru_cache+$381
    cmp index
    bne lru_cache_move_link1___b2
    // lru_cache_insert::lru_cache_move_link1_@4
    // lru_cache.first = link
    // [287] *((char *)&lru_cache+$381) = lru_cache_insert::lru_cache_move_link1_link#0 -- _deref_pbuc1=vbuxx 
    stx lru_cache+$381
    // lru_cache_insert::lru_cache_move_link1_@2
  lru_cache_move_link1___b2:
    // lru_cache.key[index] = LRU_CACHE_NOTHING
    // [288] ((unsigned int *)&lru_cache)[lru_cache_insert::lru_cache_move_link1_$6] = $ffff -- pwuc1_derefidx_vbum1=vwuc2 
    ldy lru_cache_move_link1_lru_cache_insert__6
    lda #<$ffff
    sta lru_cache,y
    lda #>$ffff
    sta lru_cache+1,y
    // lru_cache.data[index] = LRU_CACHE_NOTHING
    // [289] ((unsigned int *)&lru_cache+$100)[lru_cache_insert::lru_cache_move_link1_$6] = $ffff -- pwuc1_derefidx_vbum1=vwuc2 
    lda #<$ffff
    sta lru_cache+$100,y
    lda #>$ffff
    sta lru_cache+$100+1,y
    // lru_cache.next[index] = LRU_CACHE_INDEX_NULL
    // [290] ((char *)&lru_cache+$280)[lru_cache_insert::index#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    lda #$ff
    ldy index
    sta lru_cache+$280,y
    // lru_cache.prev[index] = LRU_CACHE_INDEX_NULL
    // [291] ((char *)&lru_cache+$200)[lru_cache_insert::index#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta lru_cache+$200,y
    // lru_cache.link[index] = LRU_CACHE_INDEX_NULL
    // [292] ((char *)&lru_cache+$300)[lru_cache_insert::index#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta lru_cache+$300,y
    // lru_cache_insert::@9
    // lru_cache.link[link_prev] = link
    // [293] ((char *)&lru_cache+$300)[lru_cache_insert::link_prev#0] = lru_cache_insert::lru_cache_move_link1_link#0 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy link_prev
    txa
    sta lru_cache+$300,y
    jmp __b1
    lru_cache_move_link1_lru_cache_insert__6: .byte 0
    lru_cache_move_link1_lru_cache_insert__7: .byte 0
  .segment Data
    key: .word 0
    data: .word 0
  .segment segm_lru_cache_bin
    index: .byte 0
    link_head: .byte 0
    link_prev: .byte 0
    index_prev: .byte 0
    lru_cache_move_link1_key: .word 0
    lru_cache_move_link1_data: .word 0
    lru_cache_move_link1_next: .byte 0
    lru_cache_move_link1_prev: .byte 0
}
  // lru_cache_data
// __mem() unsigned int lru_cache_data(__register(A) char index)
lru_cache_data: {
    .const OFFSET_STACK_INDEX = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [294] lru_cache_data::index#0 = stackidx(char,lru_cache_data::OFFSET_STACK_INDEX) -- vbuaa=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_INDEX,x
    // return lru_cache.data[index];
    // [295] lru_cache_data::$0 = lru_cache_data::index#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [296] lru_cache_data::return#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_data::$0] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda lru_cache+$100,y
    sta return
    lda lru_cache+$100+1,y
    sta return+1
    // lru_cache_data::@return
    // }
    // [297] stackidx(unsigned int,lru_cache_data::OFFSET_STACK_RETURN_0) = lru_cache_data::return#0 -- _stackidxword_vbuc1=vwum1 
    tsx
    lda return
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [298] return 
    rts
  .segment Data
    return: .word 0
}
.segment segm_lru_cache_bin
  // lru_cache_set
// __mem() unsigned int lru_cache_set(__register(Y) char index, __mem() unsigned int data)
lru_cache_set: {
    .const OFFSET_STACK_INDEX = 2
    .const OFFSET_STACK_DATA = 0
    .const OFFSET_STACK_RETURN_1 = 1
    // [299] lru_cache_set::index#0 = stackidx(char,lru_cache_set::OFFSET_STACK_INDEX) -- vbuyy=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_INDEX,x
    tay
    // [300] lru_cache_set::data#0 = stackidx(unsigned int,lru_cache_set::OFFSET_STACK_DATA) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_DATA,x
    sta data
    lda STACK_BASE+OFFSET_STACK_DATA+1,x
    sta data+1
    // if (index != LRU_CACHE_INDEX_NULL)
    // [301] if(lru_cache_set::index#0==$ff) goto lru_cache_set::@return -- vbuyy_eq_vbuc1_then_la1 
    cpy #$ff
    beq __b1
    // lru_cache_set::@1
    // lru_cache.data[index] = data
    // [302] lru_cache_set::$3 = lru_cache_set::index#0 << 1 -- vbuxx=vbuyy_rol_1 
    tya
    asl
    tax
    // [303] ((unsigned int *)&lru_cache+$100)[lru_cache_set::$3] = lru_cache_set::data#0 -- pwuc1_derefidx_vbuxx=vwum1 
    lda data
    sta lru_cache+$100,x
    lda data+1
    sta lru_cache+$100+1,x
    // lru_cache_get(index)
    // [304] stackpush(char) = lru_cache_set::index#0 -- _stackpushbyte_=vbuyy 
    tya
    pha
    // sideeffect stackpushpadding(1) -- _stackpushpadding_1 
    pha
    // [306] callexecute lru_cache_get  -- call_vprc1 
    jsr lru_cache_get
    // return lru_cache_get(index);
    // [307] lru_cache_set::return#1 = stackpull(unsigned int) -- vwum1=_stackpullword_ 
    pla
    sta return
    pla
    sta return+1
    // [308] phi from lru_cache_set::@1 to lru_cache_set::@return [phi:lru_cache_set::@1->lru_cache_set::@return]
    // [308] phi lru_cache_set::return#2 = lru_cache_set::return#1 [phi:lru_cache_set::@1->lru_cache_set::@return#0] -- register_copy 
    jmp __breturn
    // [308] phi from lru_cache_set to lru_cache_set::@return [phi:lru_cache_set->lru_cache_set::@return]
  __b1:
    // [308] phi lru_cache_set::return#2 = $ffff [phi:lru_cache_set->lru_cache_set::@return#0] -- vwum1=vwuc1 
    lda #<$ffff
    sta return
    lda #>$ffff
    sta return+1
    // lru_cache_set::@return
  __breturn:
    // }
    // [309] stackidx(unsigned int,lru_cache_set::OFFSET_STACK_RETURN_1) = lru_cache_set::return#2 -- _stackidxword_vbuc1=vwum1 
    tsx
    lda return
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    lda return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_1+1,x
    // [310] return 
    rts
  .segment Data
    data: .word 0
    return: .word 0
}
.segment segm_lru_cache_bin
  // lru_cache_get
// __mem() unsigned int lru_cache_get(__register(X) char index)
lru_cache_get: {
    .const OFFSET_STACK_INDEX = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [311] lru_cache_get::index#0 = stackidx(char,lru_cache_get::OFFSET_STACK_INDEX) -- vbuxx=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_INDEX,x
    tax
    // if (index != LRU_CACHE_INDEX_NULL)
    // [312] if(lru_cache_get::index#0==$ff) goto lru_cache_get::@return -- vbuxx_eq_vbuc1_then_la1 
    cpx #$ff
    beq __b1
    // lru_cache_get::@1
    // lru_cache_data_t data = lru_cache.data[index]
    // [313] lru_cache_get::$6 = lru_cache_get::index#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [314] lru_cache_get::data#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_get::$6] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda lru_cache+$100,y
    sta data
    lda lru_cache+$100+1,y
    sta data+1
    // lru_cache_index_t next = lru_cache.next[index]
    // [315] lru_cache_get::next#0 = ((char *)&lru_cache+$280)[lru_cache_get::index#0] -- vbum1=pbuc1_derefidx_vbuxx 
    lda lru_cache+$280,x
    sta next
    // lru_cache_index_t prev = lru_cache.prev[index]
    // [316] lru_cache_get::prev#0 = ((char *)&lru_cache+$200)[lru_cache_get::index#0] -- vbum1=pbuc1_derefidx_vbuxx 
    lda lru_cache+$200,x
    sta prev
    // lru_cache.next[prev] = next
    // [317] ((char *)&lru_cache+$280)[lru_cache_get::prev#0] = lru_cache_get::next#0 -- pbuc1_derefidx_vbum1=vbum2 
    // Delete the node from the list.
    lda next
    ldy prev
    sta lru_cache+$280,y
    // lru_cache.prev[next] = prev
    // [318] ((char *)&lru_cache+$200)[lru_cache_get::next#0] = lru_cache_get::prev#0 -- pbuc1_derefidx_vbum1=vbum2 
    //lru_cache.next[next] = prev;
    tya
    ldy next
    sta lru_cache+$200,y
    // if (index == lru_cache.first)
    // [319] if(lru_cache_get::index#0!=*((char *)&lru_cache+$381)) goto lru_cache_get::@3 -- vbuxx_neq__deref_pbuc1_then_la1 
    cpx lru_cache+$381
    bne __b3
    // lru_cache_get::@2
    // lru_cache.first = next
    // [320] *((char *)&lru_cache+$381) = lru_cache_get::next#0 -- _deref_pbuc1=vbum1 
    tya
    sta lru_cache+$381
    // lru_cache_get::@3
  __b3:
    // if (index == lru_cache.last)
    // [321] if(lru_cache_get::index#0!=*((char *)&lru_cache+$382)) goto lru_cache_get::@4 -- vbuxx_neq__deref_pbuc1_then_la1 
    cpx lru_cache+$382
    bne __b4
    // lru_cache_get::@5
    // lru_cache.last = prev
    // [322] *((char *)&lru_cache+$382) = lru_cache_get::prev#0 -- _deref_pbuc1=vbum1 
    lda prev
    sta lru_cache+$382
    // lru_cache_get::@4
  __b4:
    // lru_cache.next[index] = lru_cache.first
    // [323] ((char *)&lru_cache+$280)[lru_cache_get::index#0] = *((char *)&lru_cache+$381) -- pbuc1_derefidx_vbuxx=_deref_pbuc2 
    // Now insert the node as the first node in the list.
    lda lru_cache+$381
    sta lru_cache+$280,x
    // lru_cache.prev[lru_cache.first] = index
    // [324] ((char *)&lru_cache+$200)[*((char *)&lru_cache+$381)] = lru_cache_get::index#0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuxx 
    tay
    txa
    sta lru_cache+$200,y
    // lru_cache.next[lru_cache.last] = index
    // [325] ((char *)&lru_cache+$280)[*((char *)&lru_cache+$382)] = lru_cache_get::index#0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuxx 
    ldy lru_cache+$382
    txa
    sta lru_cache+$280,y
    // lru_cache.prev[index] = lru_cache.last
    // [326] ((char *)&lru_cache+$200)[lru_cache_get::index#0] = *((char *)&lru_cache+$382) -- pbuc1_derefidx_vbuxx=_deref_pbuc2 
    tya
    sta lru_cache+$200,x
    // lru_cache.first = index
    // [327] *((char *)&lru_cache+$381) = lru_cache_get::index#0 -- _deref_pbuc1=vbuxx 
    // Now the first node in the list is the node referenced!
    // All other nodes are moved one position down!
    stx lru_cache+$381
    // lru_cache.last = lru_cache.prev[index]
    // [328] *((char *)&lru_cache+$382) = ((char *)&lru_cache+$200)[lru_cache_get::index#0] -- _deref_pbuc1=pbuc2_derefidx_vbuxx 
    lda lru_cache+$200,x
    sta lru_cache+$382
    // [329] phi from lru_cache_get::@4 to lru_cache_get::@return [phi:lru_cache_get::@4->lru_cache_get::@return]
    // [329] phi lru_cache_get::return#2 = lru_cache_get::data#0 [phi:lru_cache_get::@4->lru_cache_get::@return#0] -- register_copy 
    jmp __breturn
    // [329] phi from lru_cache_get to lru_cache_get::@return [phi:lru_cache_get->lru_cache_get::@return]
  __b1:
    // [329] phi lru_cache_get::return#2 = $ffff [phi:lru_cache_get->lru_cache_get::@return#0] -- vwum1=vwuc1 
    lda #<$ffff
    sta return
    lda #>$ffff
    sta return+1
    // lru_cache_get::@return
  __breturn:
    // }
    // [330] stackidx(unsigned int,lru_cache_get::OFFSET_STACK_RETURN_0) = lru_cache_get::return#2 -- _stackidxword_vbuc1=vwum1 
    tsx
    lda return
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [331] return 
    rts
    .label data = return
    next: .byte 0
    prev: .byte 0
  .segment Data
    return: .word 0
}
.segment segm_lru_cache_bin
  // lru_cache_index
// __register(X) char lru_cache_index(__mem() unsigned int key)
lru_cache_index: {
    .const OFFSET_STACK_KEY = 0
    .const OFFSET_STACK_RETURN_1 = 1
    // [332] lru_cache_index::key#0 = stackidx(unsigned int,lru_cache_index::OFFSET_STACK_KEY) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_KEY,x
    sta key
    lda STACK_BASE+OFFSET_STACK_KEY+1,x
    sta key+1
    // lru_cache_index_t index = lru_cache_hash(key)
    // [333] lru_cache_hash::key#0 = lru_cache_index::key#0 -- vwum1=vwum2 
    lda key
    sta lru_cache_hash.key
    lda key+1
    sta lru_cache_hash.key+1
    // [334] call lru_cache_hash
    // [431] phi from lru_cache_index to lru_cache_hash [phi:lru_cache_index->lru_cache_hash]
    // [431] phi lru_cache_hash::key#4 = lru_cache_hash::key#0 [phi:lru_cache_index->lru_cache_hash#0] -- call_phi_near 
    jsr lru_cache_hash
    // lru_cache_index_t index = lru_cache_hash(key)
    // [335] lru_cache_hash::return#2 = lru_cache_hash::return#0
    // lru_cache_index::@4
    // [336] lru_cache_index::index#0 = lru_cache_hash::return#2 -- vbuxx=vbuaa 
    tax
    // [337] phi from lru_cache_index::@3 lru_cache_index::@4 to lru_cache_index::@1 [phi:lru_cache_index::@3/lru_cache_index::@4->lru_cache_index::@1]
  __b1:
    // [337] phi lru_cache_index::index#2 = lru_cache_index::index#1 [phi:lru_cache_index::@3/lru_cache_index::@4->lru_cache_index::@1#0] -- register_copy 
  // Search till index == 0xFF, following the links.
    // lru_cache_index::@1
    // while (index != LRU_CACHE_INDEX_NULL)
    // [338] if(lru_cache_index::index#2!=$ff) goto lru_cache_index::@2 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$ff
    bne __b2
    // [341] phi from lru_cache_index::@1 to lru_cache_index::@return [phi:lru_cache_index::@1->lru_cache_index::@return]
    // [341] phi lru_cache_index::return#2 = $ff [phi:lru_cache_index::@1->lru_cache_index::@return#0] -- vbuxx=vbuc1 
    ldx #$ff
    jmp __breturn
    // lru_cache_index::@2
  __b2:
    // lru_cache.key[index] == key
    // [339] lru_cache_index::$4 = lru_cache_index::index#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // if (lru_cache.key[index] == key)
    // [340] if(((unsigned int *)&lru_cache)[lru_cache_index::$4]!=lru_cache_index::key#0) goto lru_cache_index::@3 -- pwuc1_derefidx_vbuaa_neq_vwum1_then_la1 
    tay
    lda key+1
    cmp lru_cache+1,y
    bne __b3
    lda key
    cmp lru_cache,y
    bne __b3
    // [341] phi from lru_cache_index::@2 to lru_cache_index::@return [phi:lru_cache_index::@2->lru_cache_index::@return]
    // [341] phi lru_cache_index::return#2 = lru_cache_index::index#2 [phi:lru_cache_index::@2->lru_cache_index::@return#0] -- register_copy 
    // lru_cache_index::@return
  __breturn:
    // }
    // [342] stackidx(char,lru_cache_index::OFFSET_STACK_RETURN_1) = lru_cache_index::return#2 -- _stackidxbyte_vbuc1=vbuxx 
    txa
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    // [343] return 
    rts
    // lru_cache_index::@3
  __b3:
    // index = lru_cache.link[index]
    // [344] lru_cache_index::index#1 = ((char *)&lru_cache+$300)[lru_cache_index::index#2] -- vbuxx=pbuc1_derefidx_vbuxx 
    lda lru_cache+$300,x
    tax
    jmp __b1
  .segment Data
    key: .word 0
}
.segment segm_lru_cache_bin
  // lru_cache_is_max
// inline lru_cache_index_t lru_cache_hash(lru_cache_key_t key) {
//     lru_cache_seed = key;
//     asm {
//                     lda lru_cache_seed
//                     beq !doEor+
//                     asl
//                     beq !noEor+
//                     bcc !noEor+
//         !doEor:     eor #$2b
//         !noEor:     sta lru_cache_seed
//     }
//     return lru_cache_seed % LRU_CACHE_SIZE;
// }
lru_cache_is_max: {
    .const OFFSET_STACK_RETURN_0 = 0
    // lru_cache.count >= LRU_CACHE_MAX
    // [345] lru_cache_is_max::return#0 = *((char *)&lru_cache+$380) >= $7c -- vboaa=_deref_pbuc1_ge_vbuc2 
    lda lru_cache+$380
    cmp #$7c
    bcs !+
    lda #0
    jmp !e+
  !:
    lda #1
  !e:
    // lru_cache_is_max::@return
    // }
    // [346] stackidx(bool,lru_cache_is_max::OFFSET_STACK_RETURN_0) = lru_cache_is_max::return#0 -- _stackidxbool_vbuc1=vboaa 
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    // [347] return 
    rts
}
  // lru_cache_find_last
lru_cache_find_last: {
    .const OFFSET_STACK_RETURN_0 = 0
    // return lru_cache.key[lru_cache.last];
    // [348] lru_cache_find_last::$0 = *((char *)&lru_cache+$382) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda lru_cache+$382
    asl
    // [349] lru_cache_find_last::return#0 = ((unsigned int *)&lru_cache)[lru_cache_find_last::$0] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda lru_cache,y
    sta return
    lda lru_cache+1,y
    sta return+1
    // lru_cache_find_last::@return
    // }
    // [350] stackidx(unsigned int,lru_cache_find_last::OFFSET_STACK_RETURN_0) = lru_cache_find_last::return#0 -- _stackidxword_vbuc1=vwum1 
    tsx
    lda return
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [351] return 
    rts
  .segment Data
    return: .word 0
}
.segment segm_lru_cache_bin
  // lru_cache_init
lru_cache_init: {
    // memset(&lru_cache, 0xFF, sizeof(lru_cache_table_t))
    // [353] call memset
    // [458] phi from lru_cache_init to memset [phi:lru_cache_init->memset] -- call_phi_near 
    jsr memset
    // lru_cache_init::@1
    // lru_cache.first = 0xFF
    // [354] *((char *)&lru_cache+$381) = $ff -- _deref_pbuc1=vbuc2 
    lda #$ff
    sta lru_cache+$381
    // lru_cache.last = 0xFF
    // [355] *((char *)&lru_cache+$382) = $ff -- _deref_pbuc1=vbuc2 
    sta lru_cache+$382
    // lru_cache.count = 0
    // [356] *((char *)&lru_cache+$380) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta lru_cache+$380
    // lru_cache.size = LRU_CACHE_SIZE
    // [357] *((char *)&lru_cache+$383) = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta lru_cache+$383
    // lru_cache_init::@return
    // }
    // [358] return 
    rts
}
.segment Code
  // main
main: {
    // main::@return
    // [360] return 
    rts
}
.segment segm_lru_cache_bin
  // screenlayer1
// Set the layer with which the conio will interact.
screenlayer1: {
    // screenlayer(1, *VERA_L1_MAPBASE, *VERA_L1_CONFIG)
    // [361] screenlayer::mapbase#0 = *VERA_L1_MAPBASE -- vbuxx=_deref_pbuc1 
    ldx VERA_L1_MAPBASE
    // [362] screenlayer::config#0 = *VERA_L1_CONFIG -- vbum1=_deref_pbuc1 
    lda VERA_L1_CONFIG
    sta screenlayer.config
    // [363] call screenlayer -- call_phi_near 
    jsr screenlayer
    // screenlayer1::@return
    // }
    // [364] return 
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
    // [365] textcolor::$0 = *((char *)&__conio+$d) & $f0 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and __conio+$d
    // __conio.color & 0xF0 | color
    // [366] textcolor::$1 = textcolor::$0 | WHITE -- vbuaa=vbuaa_bor_vbuc1 
    ora #WHITE
    // __conio.color = __conio.color & 0xF0 | color
    // [367] *((char *)&__conio+$d) = textcolor::$1 -- _deref_pbuc1=vbuaa 
    sta __conio+$d
    // textcolor::@return
    // }
    // [368] return 
    rts
}
  // bgcolor
// Set the back color for text output.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor(char color)
bgcolor: {
    // __conio.color & 0x0F
    // [369] bgcolor::$0 = *((char *)&__conio+$d) & $f -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$f
    and __conio+$d
    // __conio.color & 0x0F | color << 4
    // [370] bgcolor::$2 = bgcolor::$0 | BLUE<<4 -- vbuaa=vbuaa_bor_vbuc1 
    ora #BLUE<<4
    // __conio.color = __conio.color & 0x0F | color << 4
    // [371] *((char *)&__conio+$d) = bgcolor::$2 -- _deref_pbuc1=vbuaa 
    sta __conio+$d
    // bgcolor::@return
    // }
    // [372] return 
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
    // [373] *((char *)&__conio+$c) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta __conio+$c
    // cursor::@return
    // }
    // [374] return 
    rts
}
  // cbm_k_plot_get
/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
cbm_k_plot_get: {
    // __mem unsigned char x
    // [375] cbm_k_plot_get::x = 0 -- vbum1=vbuc1 
    lda #0
    sta x
    // __mem unsigned char y
    // [376] cbm_k_plot_get::y = 0 -- vbum1=vbuc1 
    sta y
    // kickasm
    // kickasm( uses cbm_k_plot_get::x uses cbm_k_plot_get::y uses CBM_PLOT) {{ sec         jsr CBM_PLOT         stx y         sty x      }}
    sec
        jsr CBM_PLOT
        stx y
        sty x
    
    // MAKEWORD(x,y)
    // [378] cbm_k_plot_get::return#0 = cbm_k_plot_get::x w= cbm_k_plot_get::y -- vwum1=vbum2_word_vbum3 
    lda x
    sta return+1
    lda y
    sta return
    // cbm_k_plot_get::@return
    // }
    // [379] return 
    rts
    x: .byte 0
    y: .byte 0
  .segment Data
    return: .word 0
    return_1: .word 0
    return_2: .word 0
}
.segment segm_lru_cache_bin
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__register(A) char x, __register(X) char y)
gotoxy: {
    // (x>=__conio.width)?__conio.width:x
    // [381] if(gotoxy::x#4>=*((char *)&__conio+6)) goto gotoxy::@1 -- vbuaa_ge__deref_pbuc1_then_la1 
    cmp __conio+6
    bcs __b1
    // [383] phi from gotoxy gotoxy::@1 to gotoxy::@2 [phi:gotoxy/gotoxy::@1->gotoxy::@2]
    // [383] phi gotoxy::$3 = gotoxy::x#4 [phi:gotoxy/gotoxy::@1->gotoxy::@2#0] -- register_copy 
    jmp __b2
    // gotoxy::@1
  __b1:
    // [382] gotoxy::$2 = *((char *)&__conio+6) -- vbuaa=_deref_pbuc1 
    lda __conio+6
    // gotoxy::@2
  __b2:
    // __conio.cursor_x = (x>=__conio.width)?__conio.width:x
    // [384] *((char *)&__conio) = gotoxy::$3 -- _deref_pbuc1=vbuaa 
    sta __conio
    // (y>=__conio.height)?__conio.height:y
    // [385] if(gotoxy::y#10>=*((char *)&__conio+7)) goto gotoxy::@3 -- vbuxx_ge__deref_pbuc1_then_la1 
    cpx __conio+7
    bcs __b3
    // gotoxy::@4
    // [386] gotoxy::$14 = gotoxy::y#10 -- vbuaa=vbuxx 
    txa
    // [387] phi from gotoxy::@3 gotoxy::@4 to gotoxy::@5 [phi:gotoxy::@3/gotoxy::@4->gotoxy::@5]
    // [387] phi gotoxy::$7 = gotoxy::$6 [phi:gotoxy::@3/gotoxy::@4->gotoxy::@5#0] -- register_copy 
    // gotoxy::@5
  __b5:
    // __conio.cursor_y = (y>=__conio.height)?__conio.height:y
    // [388] *((char *)&__conio+1) = gotoxy::$7 -- _deref_pbuc1=vbuaa 
    sta __conio+1
    // __conio.cursor_x << 1
    // [389] gotoxy::$8 = *((char *)&__conio) << 1 -- vbuyy=_deref_pbuc1_rol_1 
    lda __conio
    asl
    tay
    // __conio.offsets[y] + __conio.cursor_x << 1
    // [390] gotoxy::$10 = gotoxy::y#10 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [391] gotoxy::$9 = ((unsigned int *)&__conio+$15)[gotoxy::$10] + gotoxy::$8 -- vwum1=pwuc1_derefidx_vbuaa_plus_vbuyy 
    tax
    tya
    clc
    adc __conio+$15,x
    sta gotoxy__9
    lda __conio+$15+1,x
    adc #0
    sta gotoxy__9+1
    // __conio.offset = __conio.offsets[y] + __conio.cursor_x << 1
    // [392] *((unsigned int *)&__conio+$13) = gotoxy::$9 -- _deref_pwuc1=vwum1 
    lda gotoxy__9
    sta __conio+$13
    lda gotoxy__9+1
    sta __conio+$13+1
    // gotoxy::@return
    // }
    // [393] return 
    rts
    // gotoxy::@3
  __b3:
    // (y>=__conio.height)?__conio.height:y
    // [394] gotoxy::$6 = *((char *)&__conio+7) -- vbuaa=_deref_pbuc1 
    lda __conio+7
    jmp __b5
    gotoxy__9: .word 0
}
  // cputln
// Print a newline
cputln: {
    // __conio.cursor_x = 0
    // [395] *((char *)&__conio) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio
    // __conio.cursor_y++;
    // [396] *((char *)&__conio+1) = ++ *((char *)&__conio+1) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+1
    // __conio.offset = __conio.offsets[__conio.cursor_y]
    // [397] cputln::$3 = *((char *)&__conio+1) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda __conio+1
    asl
    // [398] *((unsigned int *)&__conio+$13) = ((unsigned int *)&__conio+$15)[cputln::$3] -- _deref_pwuc1=pwuc2_derefidx_vbuaa 
    tay
    lda __conio+$15,y
    sta __conio+$13
    lda __conio+$15+1,y
    sta __conio+$13+1
    // if(__conio.scroll[__conio.layer])
    // [399] if(0==((char *)&__conio+$f)[*((char *)&__conio+2)]) goto cputln::@return -- 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$f,y
    cmp #0
    beq __breturn
    // [400] phi from cputln to cputln::@1 [phi:cputln->cputln::@1]
    // cputln::@1
    // cscroll()
    // [401] call cscroll -- call_phi_near 
    jsr cscroll
    // cputln::@return
  __breturn:
    // }
    // [402] return 
    rts
}
  // printf_str
/// Print a NUL-terminated string
// void printf_str(void (*putc)(char), __zp($24) const char *s)
printf_str: {
    .label s = $24
    // [404] phi from printf_str printf_str::@2 to printf_str::@1 [phi:printf_str/printf_str::@2->printf_str::@1]
    // [404] phi printf_str::s#28 = printf_str::s#29 [phi:printf_str/printf_str::@2->printf_str::@1#0] -- register_copy 
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [405] printf_str::c#1 = *printf_str::s#28 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (s),y
    // [406] printf_str::s#26 = ++ printf_str::s#28 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [407] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // printf_str::@return
    // }
    // [408] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [409] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbuaa 
    pha
    // [410] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
}
  // printf_uint
// Print an unsigned int using a specific format
// void printf_uint(void (*putc)(char), __mem() unsigned int uvalue, __mem() char format_min_length, char format_justify_left, char format_sign_always, __mem() char format_zero_padding, char format_upper_case, __register(X) char format_radix)
printf_uint: {
    // printf_uint::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [413] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
    // [414] utoa::value#1 = printf_uint::uvalue#4 -- vwum1=vwum2 
    lda uvalue
    sta utoa.value
    lda uvalue+1
    sta utoa.value+1
    // [415] utoa::radix#0 = printf_uint::format_radix#4 -- vbuaa=vbuxx 
    txa
    // [416] call utoa -- call_phi_near 
    // Format number into buffer
    jsr utoa
    // printf_uint::@2
    // printf_number_buffer(putc, printf_buffer, format)
    // [417] printf_number_buffer::buffer_sign#0 = *((char *)&printf_buffer) -- vbum1=_deref_pbuc1 
    lda printf_buffer
    sta printf_number_buffer.buffer_sign
    // [418] printf_number_buffer::format_min_length#0 = printf_uint::format_min_length#4 -- vbuxx=vbum1 
    ldx format_min_length
    // [419] printf_number_buffer::format_zero_padding#0 = printf_uint::format_zero_padding#4 -- vbum1=vbum2 
    lda format_zero_padding
    sta printf_number_buffer.format_zero_padding
    // [420] call printf_number_buffer
  // Print using format
    // [540] phi from printf_uint::@2 to printf_number_buffer [phi:printf_uint::@2->printf_number_buffer]
    // [540] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#0 [phi:printf_uint::@2->printf_number_buffer#0] -- register_copy 
    // [540] phi printf_number_buffer::format_zero_padding#10 = printf_number_buffer::format_zero_padding#0 [phi:printf_uint::@2->printf_number_buffer#1] -- register_copy 
    // [540] phi printf_number_buffer::format_min_length#2 = printf_number_buffer::format_min_length#0 [phi:printf_uint::@2->printf_number_buffer#2] -- call_phi_near 
    jsr printf_number_buffer
    // printf_uint::@return
    // }
    // [421] return 
    rts
  .segment Data
    uvalue: .word 0
    format_min_length: .byte 0
    format_zero_padding: .byte 0
}
.segment segm_lru_cache_bin
  // printf_uchar
// Print an unsigned char using a specific format
// void printf_uchar(void (*putc)(char), __register(X) char uvalue, __mem() char format_min_length, char format_justify_left, char format_sign_always, __mem() char format_zero_padding, char format_upper_case, char format_radix)
printf_uchar: {
    // printf_uchar::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [423] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    // [424] uctoa::value#1 = printf_uchar::uvalue#10
    // [425] call uctoa
  // Format number into buffer
    // [569] phi from printf_uchar::@1 to uctoa [phi:printf_uchar::@1->uctoa] -- call_phi_near 
    jsr uctoa
    // printf_uchar::@2
    // printf_number_buffer(putc, printf_buffer, format)
    // [426] printf_number_buffer::buffer_sign#1 = *((char *)&printf_buffer) -- vbum1=_deref_pbuc1 
    lda printf_buffer
    sta printf_number_buffer.buffer_sign
    // [427] printf_number_buffer::format_min_length#1 = printf_uchar::format_min_length#10 -- vbuxx=vbum1 
    ldx format_min_length
    // [428] printf_number_buffer::format_zero_padding#1 = printf_uchar::format_zero_padding#10 -- vbum1=vbum2 
    lda format_zero_padding
    sta printf_number_buffer.format_zero_padding
    // [429] call printf_number_buffer
  // Print using format
    // [540] phi from printf_uchar::@2 to printf_number_buffer [phi:printf_uchar::@2->printf_number_buffer]
    // [540] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#1 [phi:printf_uchar::@2->printf_number_buffer#0] -- register_copy 
    // [540] phi printf_number_buffer::format_zero_padding#10 = printf_number_buffer::format_zero_padding#1 [phi:printf_uchar::@2->printf_number_buffer#1] -- register_copy 
    // [540] phi printf_number_buffer::format_min_length#2 = printf_number_buffer::format_min_length#1 [phi:printf_uchar::@2->printf_number_buffer#2] -- call_phi_near 
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [430] return 
    rts
  .segment Data
    format_min_length: .byte 0
    format_zero_padding: .byte 0
}
.segment segm_lru_cache_bin
  // lru_cache_hash
// __mem unsigned char lru_cache_seed;
// __register(A) char lru_cache_hash(__mem() unsigned int key)
lru_cache_hash: {
    // key % LRU_CACHE_SIZE
    // [432] lru_cache_hash::$0 = lru_cache_hash::key#4 & $80-1 -- vwum1=vwum2_band_vbuc1 
    lda #$80-1
    and key
    sta lru_cache_hash__0
    lda #0
    sta lru_cache_hash__0+1
    // return (lru_cache_index_t)(key % LRU_CACHE_SIZE);
    // [433] lru_cache_hash::return#0 = (char)lru_cache_hash::$0 -- vbuaa=_byte_vwum1 
    lda lru_cache_hash__0
    // lru_cache_hash::@return
    // }
    // [434] return 
    rts
    lru_cache_hash__0: .word 0
  .segment Data
    key: .word 0
}
.segment segm_lru_cache_bin
  // lru_cache_find_head
// __register(A) char lru_cache_find_head(__register(X) char index)
lru_cache_find_head: {
    // lru_cache_key_t key_link = lru_cache.key[index]
    // [435] lru_cache_find_head::$2 = lru_cache_find_head::index#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [436] lru_cache_find_head::key_link#0 = ((unsigned int *)&lru_cache)[lru_cache_find_head::$2] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda lru_cache,y
    sta key_link
    lda lru_cache+1,y
    sta key_link+1
    // lru_cache_index_t head_link = lru_cache_hash(key_link)
    // [437] lru_cache_hash::key#3 = lru_cache_find_head::key_link#0 -- vwum1=vwum2 
    lda key_link
    sta lru_cache_hash.key
    lda key_link+1
    sta lru_cache_hash.key+1
    // [438] call lru_cache_hash
    // [431] phi from lru_cache_find_head to lru_cache_hash [phi:lru_cache_find_head->lru_cache_hash]
    // [431] phi lru_cache_hash::key#4 = lru_cache_hash::key#3 [phi:lru_cache_find_head->lru_cache_hash#0] -- call_phi_near 
    jsr lru_cache_hash
    // lru_cache_index_t head_link = lru_cache_hash(key_link)
    // [439] lru_cache_hash::return#10 = lru_cache_hash::return#0
    // lru_cache_find_head::@2
    // [440] lru_cache_find_head::head_link#0 = lru_cache_hash::return#10
    // if (head_link != index)
    // [441] if(lru_cache_find_head::head_link#0!=lru_cache_find_head::index#0) goto lru_cache_find_head::@1 -- vbuaa_neq_vbuxx_then_la1 
    tay
    stx.z $ff
    cpy.z $ff
    bne __b1
    // [443] phi from lru_cache_find_head::@2 to lru_cache_find_head::@return [phi:lru_cache_find_head::@2->lru_cache_find_head::@return]
    // [443] phi lru_cache_find_head::return#3 = $ff [phi:lru_cache_find_head::@2->lru_cache_find_head::@return#0] -- vbuaa=vbuc1 
    lda #$ff
    rts
    // [442] phi from lru_cache_find_head::@2 to lru_cache_find_head::@1 [phi:lru_cache_find_head::@2->lru_cache_find_head::@1]
    // lru_cache_find_head::@1
  __b1:
    // [443] phi from lru_cache_find_head::@1 to lru_cache_find_head::@return [phi:lru_cache_find_head::@1->lru_cache_find_head::@return]
    // [443] phi lru_cache_find_head::return#3 = lru_cache_find_head::head_link#0 [phi:lru_cache_find_head::@1->lru_cache_find_head::@return#0] -- register_copy 
    // lru_cache_find_head::@return
    // }
    // [444] return 
    rts
    key_link: .word 0
}
  // lru_cache_find_duplicate
// __register(X) char lru_cache_find_duplicate(__register(X) char index, __mem() char link)
lru_cache_find_duplicate: {
    // [446] phi from lru_cache_find_duplicate lru_cache_find_duplicate::@2 to lru_cache_find_duplicate::@1 [phi:lru_cache_find_duplicate/lru_cache_find_duplicate::@2->lru_cache_find_duplicate::@1]
  __b1:
    // [446] phi lru_cache_find_duplicate::index#3 = lru_cache_find_duplicate::index#6 [phi:lru_cache_find_duplicate/lru_cache_find_duplicate::@2->lru_cache_find_duplicate::@1#0] -- register_copy 
  // First find the last duplicate node.
    // lru_cache_find_duplicate::@1
    // while (lru_cache.link[index] != link && lru_cache.link[index] != LRU_CACHE_INDEX_NULL)
    // [447] if(((char *)&lru_cache+$300)[lru_cache_find_duplicate::index#3]==lru_cache_find_duplicate::link#3) goto lru_cache_find_duplicate::@return -- pbuc1_derefidx_vbuxx_eq_vbum1_then_la1 
    lda lru_cache+$300,x
    cmp link
    beq __breturn
    // lru_cache_find_duplicate::@3
    // [448] if(((char *)&lru_cache+$300)[lru_cache_find_duplicate::index#3]!=$ff) goto lru_cache_find_duplicate::@2 -- pbuc1_derefidx_vbuxx_neq_vbuc2_then_la1 
    lda lru_cache+$300,x
    cmp #$ff
    bne __b2
    // lru_cache_find_duplicate::@return
  __breturn:
    // }
    // [449] return 
    rts
    // lru_cache_find_duplicate::@2
  __b2:
    // index = lru_cache.link[index]
    // [450] lru_cache_find_duplicate::index#2 = ((char *)&lru_cache+$300)[lru_cache_find_duplicate::index#3] -- vbuxx=pbuc1_derefidx_vbuxx 
    lda lru_cache+$300,x
    tax
    jmp __b1
  .segment Data
    link: .byte 0
}
.segment segm_lru_cache_bin
  // lru_cache_find_empty
// __register(X) char lru_cache_find_empty(__register(X) char index)
lru_cache_find_empty: {
    // [452] phi from lru_cache_find_empty lru_cache_find_empty::@2 to lru_cache_find_empty::@1 [phi:lru_cache_find_empty/lru_cache_find_empty::@2->lru_cache_find_empty::@1]
    // [452] phi lru_cache_find_empty::index#4 = lru_cache_find_empty::index#7 [phi:lru_cache_find_empty/lru_cache_find_empty::@2->lru_cache_find_empty::@1#0] -- register_copy 
    // lru_cache_find_empty::@1
  __b1:
    // lru_cache.key[index] != LRU_CACHE_NOTHING
    // [453] lru_cache_find_empty::$1 = lru_cache_find_empty::index#4 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // while (lru_cache.key[index] != LRU_CACHE_NOTHING)
    // [454] if(((unsigned int *)&lru_cache)[lru_cache_find_empty::$1]!=$ffff) goto lru_cache_find_empty::@2 -- pwuc1_derefidx_vbuaa_neq_vwuc2_then_la1 
    tay
    lda lru_cache+1,y
    cmp #>$ffff
    bne __b2
    lda lru_cache,y
    cmp #<$ffff
    bne __b2
    // lru_cache_find_empty::@return
    // }
    // [455] return 
    rts
    // lru_cache_find_empty::@2
  __b2:
    // index++;
    // [456] lru_cache_find_empty::index#2 = ++ lru_cache_find_empty::index#4 -- vbuaa=_inc_vbuxx 
    txa
    inc
    // index %= LRU_CACHE_SIZE
    // [457] lru_cache_find_empty::index#3 = lru_cache_find_empty::index#2 & $80-1 -- vbuxx=vbuaa_band_vbuc1 
    and #$80-1
    tax
    jmp __b1
}
  // memset
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const c = $ff
    .const num = $384
    .label str = lru_cache
    .label end = str+num
    .label dst = $28
    // [459] phi from memset to memset::@1 [phi:memset->memset::@1]
    // [459] phi memset::dst#2 = (char *)memset::str#0 [phi:memset->memset::@1#0] -- pbuz1=pbuc1 
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
    // memset::@1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    // [460] if(memset::dst#2!=memset::end#0) goto memset::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // memset::@return
    // }
    // [461] return 
    rts
    // memset::@2
  __b2:
    // *dst = c
    // [462] *memset::dst#2 = memset::c#0 -- _deref_pbuz1=vbuc1 
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    // [463] memset::dst#1 = ++ memset::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [459] phi from memset::@2 to memset::@1 [phi:memset::@2->memset::@1]
    // [459] phi memset::dst#2 = memset::dst#1 [phi:memset::@2->memset::@1#0] -- register_copy 
    jmp __b1
}
  // screenlayer
// --- layer management in VERA ---
// void screenlayer(char layer, __register(X) char mapbase, __mem() char config)
screenlayer: {
    // __mem char vera_dc_hscale_temp = *VERA_DC_HSCALE
    // [464] screenlayer::vera_dc_hscale_temp#0 = *VERA_DC_HSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_HSCALE
    sta vera_dc_hscale_temp
    // __mem char vera_dc_vscale_temp = *VERA_DC_VSCALE
    // [465] screenlayer::vera_dc_vscale_temp#0 = *VERA_DC_VSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_VSCALE
    sta vera_dc_vscale_temp
    // __conio.layer = 0
    // [466] *((char *)&__conio+2) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+2
    // mapbase >> 7
    // [467] screenlayer::$0 = screenlayer::mapbase#0 >> 7 -- vbuaa=vbuxx_ror_7 
    txa
    rol
    rol
    and #1
    // __conio.mapbase_bank = mapbase >> 7
    // [468] *((char *)&__conio+5) = screenlayer::$0 -- _deref_pbuc1=vbuaa 
    sta __conio+5
    // (mapbase)<<1
    // [469] screenlayer::$1 = screenlayer::mapbase#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // MAKEWORD((mapbase)<<1,0)
    // [470] screenlayer::$2 = screenlayer::$1 w= 0 -- vwum1=vbuaa_word_vbuc1 
    ldy #0
    sta screenlayer__2+1
    sty screenlayer__2
    // __conio.mapbase_offset = MAKEWORD((mapbase)<<1,0)
    // [471] *((unsigned int *)&__conio+3) = screenlayer::$2 -- _deref_pwuc1=vwum1 
    tya
    sta __conio+3
    lda screenlayer__2+1
    sta __conio+3+1
    // config & VERA_LAYER_WIDTH_MASK
    // [472] screenlayer::$7 = screenlayer::config#0 & VERA_LAYER_WIDTH_MASK -- vbuaa=vbum1_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    and config
    // (config & VERA_LAYER_WIDTH_MASK) >> 4
    // [473] screenlayer::$8 = screenlayer::$7 >> 4 -- vbuxx=vbuaa_ror_4 
    lsr
    lsr
    lsr
    lsr
    tax
    // __conio.mapwidth = VERA_LAYER_DIM[ (config & VERA_LAYER_WIDTH_MASK) >> 4]
    // [474] *((char *)&__conio+8) = screenlayer::VERA_LAYER_DIM[screenlayer::$8] -- _deref_pbuc1=pbuc2_derefidx_vbuxx 
    lda VERA_LAYER_DIM,x
    sta __conio+8
    // config & VERA_LAYER_HEIGHT_MASK
    // [475] screenlayer::$5 = screenlayer::config#0 & VERA_LAYER_HEIGHT_MASK -- vbuaa=vbum1_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    and config
    // (config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [476] screenlayer::$6 = screenlayer::$5 >> 6 -- vbuaa=vbuaa_ror_6 
    rol
    rol
    rol
    and #3
    // __conio.mapheight = VERA_LAYER_DIM[ (config & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [477] *((char *)&__conio+9) = screenlayer::VERA_LAYER_DIM[screenlayer::$6] -- _deref_pbuc1=pbuc2_derefidx_vbuaa 
    tay
    lda VERA_LAYER_DIM,y
    sta __conio+9
    // __conio.rowskip = VERA_LAYER_SKIP[(config & VERA_LAYER_WIDTH_MASK)>>4]
    // [478] screenlayer::$16 = screenlayer::$8 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [479] *((unsigned int *)&__conio+$a) = screenlayer::VERA_LAYER_SKIP[screenlayer::$16] -- _deref_pwuc1=pwuc2_derefidx_vbuaa 
    // __conio.rowshift = ((config & VERA_LAYER_WIDTH_MASK)>>4)+6;
    tay
    lda VERA_LAYER_SKIP,y
    sta __conio+$a
    lda VERA_LAYER_SKIP+1,y
    sta __conio+$a+1
    // vera_dc_hscale_temp == 0x80
    // [480] screenlayer::$9 = screenlayer::vera_dc_hscale_temp#0 == $80 -- vboaa=vbum1_eq_vbuc1 
    lda vera_dc_hscale_temp
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // 40 << (char)(vera_dc_hscale_temp == 0x80)
    // [481] screenlayer::$18 = (char)screenlayer::$9 -- vbuxx=vbuaa 
    tax
    // [482] screenlayer::$10 = $28 << screenlayer::$18 -- vbuaa=vbuc1_rol_vbuxx 
    lda #$28
    cpx #0
    beq !e+
  !:
    asl
    dex
    bne !-
  !e:
    // (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [483] screenlayer::$11 = screenlayer::$10 - 1 -- vbuaa=vbuaa_minus_1 
    sec
    sbc #1
    // __conio.width = (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [484] *((char *)&__conio+6) = screenlayer::$11 -- _deref_pbuc1=vbuaa 
    sta __conio+6
    // vera_dc_vscale_temp == 0x80
    // [485] screenlayer::$12 = screenlayer::vera_dc_vscale_temp#0 == $80 -- vboaa=vbum1_eq_vbuc1 
    lda vera_dc_vscale_temp
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // 30 << (char)(vera_dc_vscale_temp == 0x80)
    // [486] screenlayer::$19 = (char)screenlayer::$12 -- vbuxx=vbuaa 
    tax
    // [487] screenlayer::$13 = $1e << screenlayer::$19 -- vbuaa=vbuc1_rol_vbuxx 
    lda #$1e
    cpx #0
    beq !e+
  !:
    asl
    dex
    bne !-
  !e:
    // (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [488] screenlayer::$14 = screenlayer::$13 - 1 -- vbuaa=vbuaa_minus_1 
    sec
    sbc #1
    // __conio.height = (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [489] *((char *)&__conio+7) = screenlayer::$14 -- _deref_pbuc1=vbuaa 
    sta __conio+7
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [490] screenlayer::mapbase_offset#0 = *((unsigned int *)&__conio+3) -- vwum1=_deref_pwuc1 
    lda __conio+3
    sta mapbase_offset
    lda __conio+3+1
    sta mapbase_offset+1
    // [491] phi from screenlayer to screenlayer::@1 [phi:screenlayer->screenlayer::@1]
    // [491] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#0 [phi:screenlayer->screenlayer::@1#0] -- register_copy 
    // [491] phi screenlayer::y#2 = 0 [phi:screenlayer->screenlayer::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // screenlayer::@1
  __b1:
    // for(register char y=0; y<=__conio.height; y++)
    // [492] if(screenlayer::y#2<=*((char *)&__conio+7)) goto screenlayer::@2 -- vbuxx_le__deref_pbuc1_then_la1 
    lda __conio+7
    stx.z $ff
    cmp.z $ff
    bcs __b2
    // screenlayer::@return
    // }
    // [493] return 
    rts
    // screenlayer::@2
  __b2:
    // __conio.offsets[y] = mapbase_offset
    // [494] screenlayer::$17 = screenlayer::y#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [495] ((unsigned int *)&__conio+$15)[screenlayer::$17] = screenlayer::mapbase_offset#2 -- pwuc1_derefidx_vbuaa=vwum1 
    tay
    lda mapbase_offset
    sta __conio+$15,y
    lda mapbase_offset+1
    sta __conio+$15+1,y
    // mapbase_offset += __conio.rowskip
    // [496] screenlayer::mapbase_offset#1 = screenlayer::mapbase_offset#2 + *((unsigned int *)&__conio+$a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda mapbase_offset
    adc __conio+$a
    sta mapbase_offset
    lda mapbase_offset+1
    adc __conio+$a+1
    sta mapbase_offset+1
    // for(register char y=0; y<=__conio.height; y++)
    // [497] screenlayer::y#1 = ++ screenlayer::y#2 -- vbuxx=_inc_vbuxx 
    inx
    // [491] phi from screenlayer::@2 to screenlayer::@1 [phi:screenlayer::@2->screenlayer::@1]
    // [491] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#1 [phi:screenlayer::@2->screenlayer::@1#0] -- register_copy 
    // [491] phi screenlayer::y#2 = screenlayer::y#1 [phi:screenlayer::@2->screenlayer::@1#1] -- register_copy 
    jmp __b1
    VERA_LAYER_DIM: .byte $1f, $3f, $7f, $ff
    VERA_LAYER_SKIP: .word $40, $80, $100, $200
    screenlayer__2: .word 0
    vera_dc_hscale_temp: .byte 0
    vera_dc_vscale_temp: .byte 0
    mapbase_offset: .word 0
  .segment Data
    config: .byte 0
}
.segment segm_lru_cache_bin
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(__conio.cursor_y>__conio.height)
    // [498] if(*((char *)&__conio+1)<=*((char *)&__conio+7)) goto cscroll::@return -- _deref_pbuc1_le__deref_pbuc2_then_la1 
    lda __conio+7
    cmp __conio+1
    bcs __breturn
    // cscroll::@1
    // if(__conio.scroll[__conio.layer])
    // [499] if(0!=((char *)&__conio+$f)[*((char *)&__conio+2)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$f,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(__conio.cursor_y>__conio.height)
    // [500] if(*((char *)&__conio+1)<=*((char *)&__conio+7)) goto cscroll::@return -- _deref_pbuc1_le__deref_pbuc2_then_la1 
    lda __conio+7
    cmp __conio+1
    bcs __breturn
    // [501] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
    // gotoxy(0,0)
    // [502] call gotoxy
    // [380] phi from cscroll::@3 to gotoxy [phi:cscroll::@3->gotoxy]
    // [380] phi gotoxy::y#10 = 0 [phi:cscroll::@3->gotoxy#0] -- vbuxx=vbuc1 
    ldx #0
    // [380] phi gotoxy::x#4 = 0 [phi:cscroll::@3->gotoxy#1] -- call_phi_near 
    txa
    jsr gotoxy
    // cscroll::@return
  __breturn:
    // }
    // [503] return 
    rts
    // [504] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup(1)
    // [505] call insertup -- call_phi_near 
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, __conio.height)
    // [506] gotoxy::y#2 = *((char *)&__conio+7) -- vbuxx=_deref_pbuc1 
    ldx __conio+7
    // [507] call gotoxy
    // [380] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [380] phi gotoxy::y#10 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    // [380] phi gotoxy::x#4 = 0 [phi:cscroll::@5->gotoxy#1] -- call_phi_near 
    lda #0
    jsr gotoxy
    // [508] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [509] call clearline -- call_phi_near 
    jsr clearline
    rts
}
  // utoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__mem() unsigned int value, __zp($26) char *buffer, __register(A) char radix)
utoa: {
    .label buffer = $26
    .label digit_values = $24
    // if(radix==DECIMAL)
    // [510] if(utoa::radix#0==DECIMAL) goto utoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #DECIMAL
    beq __b2
    // utoa::@2
    // if(radix==HEXADECIMAL)
    // [511] if(utoa::radix#0==HEXADECIMAL) goto utoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #HEXADECIMAL
    beq __b3
    // utoa::@3
    // if(radix==OCTAL)
    // [512] if(utoa::radix#0==OCTAL) goto utoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #OCTAL
    beq __b4
    // utoa::@4
    // if(radix==BINARY)
    // [513] if(utoa::radix#0==BINARY) goto utoa::@1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #BINARY
    beq __b5
    // utoa::@5
    // *buffer++ = 'e'
    // [514] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS) = 'e'pm -- _deref_pbuc1=vbuc2 
    // Unknown radix
    lda #'e'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    // [515] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1) = 'r'pm -- _deref_pbuc1=vbuc2 
    lda #'r'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    // [516] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2) = 'r'pm -- _deref_pbuc1=vbuc2 
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    // [517] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // utoa::@return
    // }
    // [518] return 
    rts
    // [519] phi from utoa to utoa::@1 [phi:utoa->utoa::@1]
  __b2:
    // [519] phi utoa::digit_values#8 = RADIX_DECIMAL_VALUES [phi:utoa->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_DECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES
    sta.z digit_values+1
    // [519] phi utoa::max_digits#7 = 5 [phi:utoa->utoa::@1#1] -- vbum1=vbuc1 
    lda #5
    sta max_digits
    jmp __b1
    // [519] phi from utoa::@2 to utoa::@1 [phi:utoa::@2->utoa::@1]
  __b3:
    // [519] phi utoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES [phi:utoa::@2->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_HEXADECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES
    sta.z digit_values+1
    // [519] phi utoa::max_digits#7 = 4 [phi:utoa::@2->utoa::@1#1] -- vbum1=vbuc1 
    lda #4
    sta max_digits
    jmp __b1
    // [519] phi from utoa::@3 to utoa::@1 [phi:utoa::@3->utoa::@1]
  __b4:
    // [519] phi utoa::digit_values#8 = RADIX_OCTAL_VALUES [phi:utoa::@3->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_OCTAL_VALUES
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES
    sta.z digit_values+1
    // [519] phi utoa::max_digits#7 = 6 [phi:utoa::@3->utoa::@1#1] -- vbum1=vbuc1 
    lda #6
    sta max_digits
    jmp __b1
    // [519] phi from utoa::@4 to utoa::@1 [phi:utoa::@4->utoa::@1]
  __b5:
    // [519] phi utoa::digit_values#8 = RADIX_BINARY_VALUES [phi:utoa::@4->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_BINARY_VALUES
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES
    sta.z digit_values+1
    // [519] phi utoa::max_digits#7 = $10 [phi:utoa::@4->utoa::@1#1] -- vbum1=vbuc1 
    lda #$10
    sta max_digits
    // utoa::@1
  __b1:
    // [520] phi from utoa::@1 to utoa::@6 [phi:utoa::@1->utoa::@6]
    // [520] phi utoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:utoa::@1->utoa::@6#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [520] phi utoa::started#2 = 0 [phi:utoa::@1->utoa::@6#1] -- vbuxx=vbuc1 
    ldx #0
    // [520] phi utoa::value#2 = utoa::value#1 [phi:utoa::@1->utoa::@6#2] -- register_copy 
    // [520] phi utoa::digit#2 = 0 [phi:utoa::@1->utoa::@6#3] -- vbum1=vbuc1 
    txa
    sta digit
    // utoa::@6
  __b6:
    // max_digits-1
    // [521] utoa::$4 = utoa::max_digits#7 - 1 -- vbuaa=vbum1_minus_1 
    lda max_digits
    sec
    sbc #1
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [522] if(utoa::digit#2<utoa::$4) goto utoa::@7 -- vbum1_lt_vbuaa_then_la1 
    cmp digit
    beq !+
    bcs __b7
  !:
    // utoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [523] utoa::$11 = (char)utoa::value#2 -- vbuxx=_byte_vwum1 
    ldx value
    // [524] *utoa::buffer#11 = DIGITS[utoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [525] utoa::buffer#3 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [526] *utoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    rts
    // utoa::@7
  __b7:
    // unsigned int digit_value = digit_values[digit]
    // [527] utoa::$10 = utoa::digit#2 << 1 -- vbuaa=vbum1_rol_1 
    lda digit
    asl
    // [528] utoa::digit_value#0 = utoa::digit_values#8[utoa::$10] -- vwum1=pwuz2_derefidx_vbuaa 
    tay
    lda (digit_values),y
    sta digit_value
    iny
    lda (digit_values),y
    sta digit_value+1
    // if (started || value >= digit_value)
    // [529] if(0!=utoa::started#2) goto utoa::@10 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b10
    // utoa::@12
    // [530] if(utoa::value#2>=utoa::digit_value#0) goto utoa::@10 -- vwum1_ge_vwum2_then_la1 
    cmp value+1
    bne !+
    lda digit_value
    cmp value
    beq __b10
  !:
    bcc __b10
    // [531] phi from utoa::@12 to utoa::@9 [phi:utoa::@12->utoa::@9]
    // [531] phi utoa::buffer#14 = utoa::buffer#11 [phi:utoa::@12->utoa::@9#0] -- register_copy 
    // [531] phi utoa::started#4 = utoa::started#2 [phi:utoa::@12->utoa::@9#1] -- register_copy 
    // [531] phi utoa::value#6 = utoa::value#2 [phi:utoa::@12->utoa::@9#2] -- register_copy 
    // utoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [532] utoa::digit#1 = ++ utoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [520] phi from utoa::@9 to utoa::@6 [phi:utoa::@9->utoa::@6]
    // [520] phi utoa::buffer#11 = utoa::buffer#14 [phi:utoa::@9->utoa::@6#0] -- register_copy 
    // [520] phi utoa::started#2 = utoa::started#4 [phi:utoa::@9->utoa::@6#1] -- register_copy 
    // [520] phi utoa::value#2 = utoa::value#6 [phi:utoa::@9->utoa::@6#2] -- register_copy 
    // [520] phi utoa::digit#2 = utoa::digit#1 [phi:utoa::@9->utoa::@6#3] -- register_copy 
    jmp __b6
    // utoa::@10
  __b10:
    // utoa_append(buffer++, value, digit_value)
    // [533] utoa_append::buffer#0 = utoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z utoa_append.buffer
    lda.z buffer+1
    sta.z utoa_append.buffer+1
    // [534] utoa_append::value#0 = utoa::value#2 -- vwum1=vwum2 
    lda value
    sta utoa_append.value
    lda value+1
    sta utoa_append.value+1
    // [535] utoa_append::sub#0 = utoa::digit_value#0 -- vwum1=vwum2 
    lda digit_value
    sta utoa_append.sub
    lda digit_value+1
    sta utoa_append.sub+1
    // [536] call utoa_append
    // [621] phi from utoa::@10 to utoa_append [phi:utoa::@10->utoa_append] -- call_phi_near 
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // [537] utoa_append::return#0 = utoa_append::value#2 -- vwum1=vwum2 
    lda utoa_append.value
    sta utoa_append.return
    lda utoa_append.value+1
    sta utoa_append.return+1
    // utoa::@11
    // value = utoa_append(buffer++, value, digit_value)
    // [538] utoa::value#0 = utoa_append::return#0 -- vwum1=vwum2 
    lda utoa_append.return
    sta value
    lda utoa_append.return+1
    sta value+1
    // value = utoa_append(buffer++, value, digit_value);
    // [539] utoa::buffer#4 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [531] phi from utoa::@11 to utoa::@9 [phi:utoa::@11->utoa::@9]
    // [531] phi utoa::buffer#14 = utoa::buffer#4 [phi:utoa::@11->utoa::@9#0] -- register_copy 
    // [531] phi utoa::started#4 = 1 [phi:utoa::@11->utoa::@9#1] -- vbuxx=vbuc1 
    ldx #1
    // [531] phi utoa::value#6 = utoa::value#0 [phi:utoa::@11->utoa::@9#2] -- register_copy 
    jmp __b9
    digit_value: .word 0
    digit: .byte 0
  .segment Data
    value: .word 0
  .segment segm_lru_cache_bin
    max_digits: .byte 0
}
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(void (*putc)(char), __mem() char buffer_sign, char *buffer_digits, __register(X) char format_min_length, char format_justify_left, char format_sign_always, __mem() char format_zero_padding, char format_upper_case, char format_radix)
printf_number_buffer: {
    // if(format.min_length)
    // [541] if(0==printf_number_buffer::format_min_length#2) goto printf_number_buffer::@1 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq __b5
    // [542] phi from printf_number_buffer to printf_number_buffer::@5 [phi:printf_number_buffer->printf_number_buffer::@5]
    // printf_number_buffer::@5
    // strlen(buffer.digits)
    // [543] call strlen
    // [628] phi from printf_number_buffer::@5 to strlen [phi:printf_number_buffer::@5->strlen] -- call_phi_near 
    jsr strlen
    // strlen(buffer.digits)
    // [544] strlen::return#2 = strlen::len#2 -- vwum1=vwum2 
    lda strlen.len
    sta strlen.return
    lda strlen.len+1
    sta strlen.return+1
    // printf_number_buffer::@11
    // [545] printf_number_buffer::$19 = strlen::return#2 -- vwum1=vwum2 
    lda strlen.return
    sta printf_number_buffer__19
    lda strlen.return+1
    sta printf_number_buffer__19+1
    // signed char len = (signed char)strlen(buffer.digits)
    // [546] printf_number_buffer::len#0 = (signed char)printf_number_buffer::$19 -- vbsyy=_sbyte_vwum1 
    // There is a minimum length - work out the padding
    ldy printf_number_buffer__19
    // if(buffer.sign)
    // [547] if(0==printf_number_buffer::buffer_sign#10) goto printf_number_buffer::@10 -- 0_eq_vbum1_then_la1 
    lda buffer_sign
    beq __b10
    // printf_number_buffer::@6
    // len++;
    // [548] printf_number_buffer::len#1 = ++ printf_number_buffer::len#0 -- vbsyy=_inc_vbsyy 
    iny
    // [549] phi from printf_number_buffer::@11 printf_number_buffer::@6 to printf_number_buffer::@10 [phi:printf_number_buffer::@11/printf_number_buffer::@6->printf_number_buffer::@10]
    // [549] phi printf_number_buffer::len#2 = printf_number_buffer::len#0 [phi:printf_number_buffer::@11/printf_number_buffer::@6->printf_number_buffer::@10#0] -- register_copy 
    // printf_number_buffer::@10
  __b10:
    // padding = (signed char)format.min_length - len
    // [550] printf_number_buffer::padding#1 = (signed char)printf_number_buffer::format_min_length#2 - printf_number_buffer::len#2 -- vbsm1=vbsxx_minus_vbsyy 
    txa
    sty.z $ff
    sec
    sbc.z $ff
    sta padding
    // if(padding<0)
    // [551] if(printf_number_buffer::padding#1>=0) goto printf_number_buffer::@15 -- vbsm1_ge_0_then_la1 
    cmp #0
    bpl __b1
    // [553] phi from printf_number_buffer printf_number_buffer::@10 to printf_number_buffer::@1 [phi:printf_number_buffer/printf_number_buffer::@10->printf_number_buffer::@1]
  __b5:
    // [553] phi printf_number_buffer::padding#10 = 0 [phi:printf_number_buffer/printf_number_buffer::@10->printf_number_buffer::@1#0] -- vbsm1=vbsc1 
    lda #0
    sta padding
    // [552] phi from printf_number_buffer::@10 to printf_number_buffer::@15 [phi:printf_number_buffer::@10->printf_number_buffer::@15]
    // printf_number_buffer::@15
    // [553] phi from printf_number_buffer::@15 to printf_number_buffer::@1 [phi:printf_number_buffer::@15->printf_number_buffer::@1]
    // [553] phi printf_number_buffer::padding#10 = printf_number_buffer::padding#1 [phi:printf_number_buffer::@15->printf_number_buffer::@1#0] -- register_copy 
    // printf_number_buffer::@1
  __b1:
    // printf_number_buffer::@13
    // if(!format.justify_left && !format.zero_padding && padding)
    // [554] if(0!=printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@2 -- 0_neq_vbum1_then_la1 
    lda format_zero_padding
    bne __b2
    // printf_number_buffer::@12
    // [555] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@7 -- 0_neq_vbsm1_then_la1 
    lda padding
    cmp #0
    bne __b7
    jmp __b2
    // printf_number_buffer::@7
  __b7:
    // printf_padding(putc, ' ',(char)padding)
    // [556] printf_padding::length#0 = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [557] call printf_padding
    // [634] phi from printf_number_buffer::@7 to printf_padding [phi:printf_number_buffer::@7->printf_padding]
    // [634] phi printf_padding::pad#5 = ' 'pm [phi:printf_number_buffer::@7->printf_padding#0] -- vbum1=vbuc1 
    lda #' '
    sta printf_padding.pad
    // [634] phi printf_padding::length#4 = printf_padding::length#0 [phi:printf_number_buffer::@7->printf_padding#1] -- call_phi_near 
    jsr printf_padding
    // printf_number_buffer::@2
  __b2:
    // if(buffer.sign)
    // [558] if(0==printf_number_buffer::buffer_sign#10) goto printf_number_buffer::@3 -- 0_eq_vbum1_then_la1 
    lda buffer_sign
    beq __b3
    // printf_number_buffer::@8
    // putc(buffer.sign)
    // [559] stackpush(char) = printf_number_buffer::buffer_sign#10 -- _stackpushbyte_=vbum1 
    pha
    // [560] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_number_buffer::@3
  __b3:
    // if(format.zero_padding && padding)
    // [562] if(0==printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@4 -- 0_eq_vbum1_then_la1 
    lda format_zero_padding
    beq __b4
    // printf_number_buffer::@14
    // [563] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@9 -- 0_neq_vbsm1_then_la1 
    lda padding
    cmp #0
    bne __b9
    // [566] phi from printf_number_buffer::@14 printf_number_buffer::@3 printf_number_buffer::@9 to printf_number_buffer::@4 [phi:printf_number_buffer::@14/printf_number_buffer::@3/printf_number_buffer::@9->printf_number_buffer::@4]
    jmp __b4
    // printf_number_buffer::@9
  __b9:
    // printf_padding(putc, '0',(char)padding)
    // [564] printf_padding::length#1 = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [565] call printf_padding
    // [634] phi from printf_number_buffer::@9 to printf_padding [phi:printf_number_buffer::@9->printf_padding]
    // [634] phi printf_padding::pad#5 = '0'pm [phi:printf_number_buffer::@9->printf_padding#0] -- vbum1=vbuc1 
    lda #'0'
    sta printf_padding.pad
    // [634] phi printf_padding::length#4 = printf_padding::length#1 [phi:printf_number_buffer::@9->printf_padding#1] -- call_phi_near 
    jsr printf_padding
    // printf_number_buffer::@4
  __b4:
    // printf_str(putc, buffer.digits)
    // [567] call printf_str
    // [403] phi from printf_number_buffer::@4 to printf_str [phi:printf_number_buffer::@4->printf_str]
    // [403] phi printf_str::s#29 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:printf_number_buffer::@4->printf_str#0] -- call_phi_near 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.s+1
    jsr printf_str
    // printf_number_buffer::@return
    // }
    // [568] return 
    rts
    printf_number_buffer__19: .word 0
  .segment Data
    buffer_sign: .byte 0
    format_zero_padding: .byte 0
  .segment segm_lru_cache_bin
    padding: .byte 0
}
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void uctoa(__register(X) char value, __zp($26) char *buffer, char radix)
uctoa: {
    .label buffer = $26
    // [570] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
    // [570] phi uctoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:uctoa->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [570] phi uctoa::started#2 = 0 [phi:uctoa->uctoa::@1#1] -- vbum1=vbuc1 
    lda #0
    sta started
    // [570] phi uctoa::value#2 = uctoa::value#1 [phi:uctoa->uctoa::@1#2] -- register_copy 
    // [570] phi uctoa::digit#2 = 0 [phi:uctoa->uctoa::@1#3] -- vbum1=vbuc1 
    sta digit
    // uctoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [571] if(uctoa::digit#2<2-1) goto uctoa::@2 -- vbum1_lt_vbuc1_then_la1 
    lda digit
    cmp #2-1
    bcc __b2
    // uctoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [572] *uctoa::buffer#11 = DIGITS[uctoa::value#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [573] uctoa::buffer#3 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [574] *uctoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // uctoa::@return
    // }
    // [575] return 
    rts
    // uctoa::@2
  __b2:
    // unsigned char digit_value = digit_values[digit]
    // [576] uctoa::digit_value#0 = RADIX_HEXADECIMAL_VALUES_CHAR[uctoa::digit#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy digit
    lda RADIX_HEXADECIMAL_VALUES_CHAR,y
    sta digit_value
    // if (started || value >= digit_value)
    // [577] if(0!=uctoa::started#2) goto uctoa::@5 -- 0_neq_vbum1_then_la1 
    lda started
    bne __b5
    // uctoa::@7
    // [578] if(uctoa::value#2>=uctoa::digit_value#0) goto uctoa::@5 -- vbuxx_ge_vbum1_then_la1 
    cpx digit_value
    bcs __b5
    // [579] phi from uctoa::@7 to uctoa::@4 [phi:uctoa::@7->uctoa::@4]
    // [579] phi uctoa::buffer#14 = uctoa::buffer#11 [phi:uctoa::@7->uctoa::@4#0] -- register_copy 
    // [579] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@7->uctoa::@4#1] -- register_copy 
    // [579] phi uctoa::value#6 = uctoa::value#2 [phi:uctoa::@7->uctoa::@4#2] -- register_copy 
    // uctoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [580] uctoa::digit#1 = ++ uctoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [570] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
    // [570] phi uctoa::buffer#11 = uctoa::buffer#14 [phi:uctoa::@4->uctoa::@1#0] -- register_copy 
    // [570] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@4->uctoa::@1#1] -- register_copy 
    // [570] phi uctoa::value#2 = uctoa::value#6 [phi:uctoa::@4->uctoa::@1#2] -- register_copy 
    // [570] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@4->uctoa::@1#3] -- register_copy 
    jmp __b1
    // uctoa::@5
  __b5:
    // uctoa_append(buffer++, value, digit_value)
    // [581] uctoa_append::buffer#0 = uctoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z uctoa_append.buffer
    lda.z buffer+1
    sta.z uctoa_append.buffer+1
    // [582] uctoa_append::value#0 = uctoa::value#2
    // [583] uctoa_append::sub#0 = uctoa::digit_value#0 -- vbum1=vbum2 
    lda digit_value
    sta uctoa_append.sub
    // [584] call uctoa_append
    // [642] phi from uctoa::@5 to uctoa_append [phi:uctoa::@5->uctoa_append] -- call_phi_near 
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // [585] uctoa_append::return#0 = uctoa_append::value#2
    // uctoa::@6
    // value = uctoa_append(buffer++, value, digit_value)
    // [586] uctoa::value#0 = uctoa_append::return#0
    // value = uctoa_append(buffer++, value, digit_value);
    // [587] uctoa::buffer#4 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [579] phi from uctoa::@6 to uctoa::@4 [phi:uctoa::@6->uctoa::@4]
    // [579] phi uctoa::buffer#14 = uctoa::buffer#4 [phi:uctoa::@6->uctoa::@4#0] -- register_copy 
    // [579] phi uctoa::started#4 = 1 [phi:uctoa::@6->uctoa::@4#1] -- vbum1=vbuc1 
    lda #1
    sta started
    // [579] phi uctoa::value#6 = uctoa::value#0 [phi:uctoa::@6->uctoa::@4#2] -- register_copy 
    jmp __b4
    digit_value: .byte 0
    digit: .byte 0
    started: .byte 0
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
// void insertup(char rows)
insertup: {
    // __conio.width+1
    // [588] insertup::$0 = *((char *)&__conio+6) + 1 -- vbuaa=_deref_pbuc1_plus_1 
    lda __conio+6
    inc
    // unsigned char width = (__conio.width+1) * 2
    // [589] insertup::width#0 = insertup::$0 << 1 -- vbum1=vbuaa_rol_1 
    // {asm{.byte $db}}
    asl
    sta width
    // [590] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [590] phi insertup::y#2 = 0 [phi:insertup->insertup::@1#0] -- vbum1=vbuc1 
    lda #0
    sta y
    // insertup::@1
  __b1:
    // for(unsigned char y=0; y<__conio.cursor_y; y++)
    // [591] if(insertup::y#2<*((char *)&__conio+1)) goto insertup::@2 -- vbum1_lt__deref_pbuc1_then_la1 
    lda y
    cmp __conio+1
    bcc __b2
    // [592] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [593] call clearline -- call_phi_near 
    jsr clearline
    // insertup::@return
    // }
    // [594] return 
    rts
    // insertup::@2
  __b2:
    // y+1
    // [595] insertup::$4 = insertup::y#2 + 1 -- vbuxx=vbum1_plus_1 
    ldx y
    inx
    // memcpy8_vram_vram(__conio.mapbase_bank, __conio.offsets[y], __conio.mapbase_bank, __conio.offsets[y+1], width)
    // [596] insertup::$6 = insertup::y#2 << 1 -- vbuyy=vbum1_rol_1 
    lda y
    asl
    tay
    // [597] insertup::$7 = insertup::$4 << 1 -- vbuxx=vbuxx_rol_1 
    txa
    asl
    tax
    // [598] memcpy8_vram_vram::dbank_vram#0 = *((char *)&__conio+5) -- vbum1=_deref_pbuc1 
    lda __conio+5
    sta memcpy8_vram_vram.dbank_vram
    // [599] memcpy8_vram_vram::doffset_vram#0 = ((unsigned int *)&__conio+$15)[insertup::$6] -- vwum1=pwuc1_derefidx_vbuyy 
    lda __conio+$15,y
    sta memcpy8_vram_vram.doffset_vram
    lda __conio+$15+1,y
    sta memcpy8_vram_vram.doffset_vram+1
    // [600] memcpy8_vram_vram::sbank_vram#0 = *((char *)&__conio+5) -- vbum1=_deref_pbuc1 
    lda __conio+5
    sta memcpy8_vram_vram.sbank_vram
    // [601] memcpy8_vram_vram::soffset_vram#0 = ((unsigned int *)&__conio+$15)[insertup::$7] -- vwum1=pwuc1_derefidx_vbuxx 
    lda __conio+$15,x
    sta memcpy8_vram_vram.soffset_vram
    lda __conio+$15+1,x
    sta memcpy8_vram_vram.soffset_vram+1
    // [602] memcpy8_vram_vram::num8#1 = insertup::width#0 -- vbuyy=vbum1 
    ldy width
    // [603] call memcpy8_vram_vram -- call_phi_near 
    jsr memcpy8_vram_vram
    // insertup::@4
    // for(unsigned char y=0; y<__conio.cursor_y; y++)
    // [604] insertup::y#1 = ++ insertup::y#2 -- vbum1=_inc_vbum1 
    inc y
    // [590] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [590] phi insertup::y#2 = insertup::y#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
    width: .byte 0
    y: .byte 0
}
  // clearline
clearline: {
    // unsigned int addr = __conio.offsets[__conio.cursor_y]
    // [605] clearline::$3 = *((char *)&__conio+1) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda __conio+1
    asl
    // [606] clearline::addr#0 = ((unsigned int *)&__conio+$15)[clearline::$3] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda __conio+$15,y
    sta addr
    lda __conio+$15+1,y
    sta addr+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [607] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(addr)
    // [608] clearline::$0 = byte0  clearline::addr#0 -- vbuaa=_byte0_vwum1 
    lda addr
    // *VERA_ADDRX_L = BYTE0(addr)
    // [609] *VERA_ADDRX_L = clearline::$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(addr)
    // [610] clearline::$1 = byte1  clearline::addr#0 -- vbuaa=_byte1_vwum1 
    lda addr+1
    // *VERA_ADDRX_M = BYTE1(addr)
    // [611] *VERA_ADDRX_M = clearline::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [612] clearline::$2 = *((char *)&__conio+5) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [613] *VERA_ADDRX_H = clearline::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // register unsigned char c=__conio.width
    // [614] clearline::c#0 = *((char *)&__conio+6) -- vbuxx=_deref_pbuc1 
    ldx __conio+6
    // [615] phi from clearline clearline::@1 to clearline::@1 [phi:clearline/clearline::@1->clearline::@1]
    // [615] phi clearline::c#2 = clearline::c#0 [phi:clearline/clearline::@1->clearline::@1#0] -- register_copy 
    // clearline::@1
  __b1:
    // *VERA_DATA0 = ' '
    // [616] *VERA_DATA0 = ' 'pm -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [617] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // c--;
    // [618] clearline::c#1 = -- clearline::c#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(c)
    // [619] if(0!=clearline::c#1) goto clearline::@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b1
    // clearline::@return
    // }
    // [620] return 
    rts
    addr: .word 0
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
// __mem() unsigned int utoa_append(__zp($22) char *buffer, __mem() unsigned int value, __mem() unsigned int sub)
utoa_append: {
    .label buffer = $22
    // [622] phi from utoa_append to utoa_append::@1 [phi:utoa_append->utoa_append::@1]
    // [622] phi utoa_append::digit#2 = 0 [phi:utoa_append->utoa_append::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [622] phi utoa_append::value#2 = utoa_append::value#0 [phi:utoa_append->utoa_append::@1#1] -- register_copy 
    // utoa_append::@1
  __b1:
    // while (value >= sub)
    // [623] if(utoa_append::value#2>=utoa_append::sub#0) goto utoa_append::@2 -- vwum1_ge_vwum2_then_la1 
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
    // [624] *utoa_append::buffer#0 = DIGITS[utoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // utoa_append::@return
    // }
    // [625] return 
    rts
    // utoa_append::@2
  __b2:
    // digit++;
    // [626] utoa_append::digit#1 = ++ utoa_append::digit#2 -- vbuxx=_inc_vbuxx 
    inx
    // value -= sub
    // [627] utoa_append::value#1 = utoa_append::value#2 - utoa_append::sub#0 -- vwum1=vwum1_minus_vwum2 
    lda value
    sec
    sbc sub
    sta value
    lda value+1
    sbc sub+1
    sta value+1
    // [622] phi from utoa_append::@2 to utoa_append::@1 [phi:utoa_append::@2->utoa_append::@1]
    // [622] phi utoa_append::digit#2 = utoa_append::digit#1 [phi:utoa_append::@2->utoa_append::@1#0] -- register_copy 
    // [622] phi utoa_append::value#2 = utoa_append::value#1 [phi:utoa_append::@2->utoa_append::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    value: .word 0
    sub: .word 0
    return: .word 0
}
.segment segm_lru_cache_bin
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __mem() unsigned int strlen(__zp($22) char *str)
strlen: {
    .label str = $22
    // [629] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [629] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta len
    sta len+1
    // [629] phi strlen::str#2 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:strlen->strlen::@1#1] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z str+1
    // strlen::@1
  __b1:
    // while(*str)
    // [630] if(0!=*strlen::str#2) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [631] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [632] strlen::len#1 = ++ strlen::len#2 -- vwum1=_inc_vwum1 
    inc len
    bne !+
    inc len+1
  !:
    // str++;
    // [633] strlen::str#0 = ++ strlen::str#2 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [629] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [629] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [629] phi strlen::str#2 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
    len: .word 0
  .segment Data
    return: .word 0
}
.segment segm_lru_cache_bin
  // printf_padding
// Print a padding char a number of times
// void printf_padding(void (*putc)(char), __mem() char pad, __mem() char length)
printf_padding: {
    // [635] phi from printf_padding to printf_padding::@1 [phi:printf_padding->printf_padding::@1]
    // [635] phi printf_padding::i#2 = 0 [phi:printf_padding->printf_padding::@1#0] -- vbum1=vbuc1 
    lda #0
    sta i
    // printf_padding::@1
  __b1:
    // for(char i=0;i<length; i++)
    // [636] if(printf_padding::i#2<printf_padding::length#4) goto printf_padding::@2 -- vbum1_lt_vbum2_then_la1 
    lda i
    cmp length
    bcc __b2
    // printf_padding::@return
    // }
    // [637] return 
    rts
    // printf_padding::@2
  __b2:
    // putc(pad)
    // [638] stackpush(char) = printf_padding::pad#5 -- _stackpushbyte_=vbum1 
    lda pad
    pha
    // [639] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_padding::@3
    // for(char i=0;i<length; i++)
    // [641] printf_padding::i#1 = ++ printf_padding::i#2 -- vbum1=_inc_vbum1 
    inc i
    // [635] phi from printf_padding::@3 to printf_padding::@1 [phi:printf_padding::@3->printf_padding::@1]
    // [635] phi printf_padding::i#2 = printf_padding::i#1 [phi:printf_padding::@3->printf_padding::@1#0] -- register_copy 
    jmp __b1
    i: .byte 0
  .segment Data
    length: .byte 0
    pad: .byte 0
}
.segment segm_lru_cache_bin
  // uctoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __register(X) char uctoa_append(__zp($24) char *buffer, __register(X) char value, __mem() char sub)
uctoa_append: {
    .label buffer = $24
    // [643] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [643] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbuyy=vbuc1 
    ldy #0
    // [643] phi uctoa_append::value#2 = uctoa_append::value#0 [phi:uctoa_append->uctoa_append::@1#1] -- register_copy 
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [644] if(uctoa_append::value#2>=uctoa_append::sub#0) goto uctoa_append::@2 -- vbuxx_ge_vbum1_then_la1 
    cpx sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [645] *uctoa_append::buffer#0 = DIGITS[uctoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuyy 
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // uctoa_append::@return
    // }
    // [646] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [647] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbuyy=_inc_vbuyy 
    iny
    // value -= sub
    // [648] uctoa_append::value#1 = uctoa_append::value#2 - uctoa_append::sub#0 -- vbuxx=vbuxx_minus_vbum1 
    txa
    sec
    sbc sub
    tax
    // [643] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [643] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    // [643] phi uctoa_append::value#2 = uctoa_append::value#1 [phi:uctoa_append::@2->uctoa_append::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    sub: .byte 0
}
.segment segm_lru_cache_bin
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
// void memcpy8_vram_vram(__mem() char dbank_vram, __mem() unsigned int doffset_vram, __mem() char sbank_vram, __mem() unsigned int soffset_vram, __register(X) char num8)
memcpy8_vram_vram: {
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [649] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(soffset_vram)
    // [650] memcpy8_vram_vram::$0 = byte0  memcpy8_vram_vram::soffset_vram#0 -- vbuaa=_byte0_vwum1 
    lda soffset_vram
    // *VERA_ADDRX_L = BYTE0(soffset_vram)
    // [651] *VERA_ADDRX_L = memcpy8_vram_vram::$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(soffset_vram)
    // [652] memcpy8_vram_vram::$1 = byte1  memcpy8_vram_vram::soffset_vram#0 -- vbuaa=_byte1_vwum1 
    lda soffset_vram+1
    // *VERA_ADDRX_M = BYTE1(soffset_vram)
    // [653] *VERA_ADDRX_M = memcpy8_vram_vram::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // sbank_vram | VERA_INC_1
    // [654] memcpy8_vram_vram::$2 = memcpy8_vram_vram::sbank_vram#0 | VERA_INC_1 -- vbuaa=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora sbank_vram
    // *VERA_ADDRX_H = sbank_vram | VERA_INC_1
    // [655] *VERA_ADDRX_H = memcpy8_vram_vram::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [656] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [657] memcpy8_vram_vram::$3 = byte0  memcpy8_vram_vram::doffset_vram#0 -- vbuaa=_byte0_vwum1 
    lda doffset_vram
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [658] *VERA_ADDRX_L = memcpy8_vram_vram::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [659] memcpy8_vram_vram::$4 = byte1  memcpy8_vram_vram::doffset_vram#0 -- vbuaa=_byte1_vwum1 
    lda doffset_vram+1
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [660] *VERA_ADDRX_M = memcpy8_vram_vram::$4 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // dbank_vram | VERA_INC_1
    // [661] memcpy8_vram_vram::$5 = memcpy8_vram_vram::dbank_vram#0 | VERA_INC_1 -- vbuaa=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora dbank_vram
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [662] *VERA_ADDRX_H = memcpy8_vram_vram::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [663] phi from memcpy8_vram_vram memcpy8_vram_vram::@2 to memcpy8_vram_vram::@1 [phi:memcpy8_vram_vram/memcpy8_vram_vram::@2->memcpy8_vram_vram::@1]
  __b1:
    // [663] phi memcpy8_vram_vram::num8#2 = memcpy8_vram_vram::num8#1 [phi:memcpy8_vram_vram/memcpy8_vram_vram::@2->memcpy8_vram_vram::@1#0] -- register_copy 
  // the size is only a byte, this is the fastest loop!
    // memcpy8_vram_vram::@1
    // while (num8--)
    // [664] memcpy8_vram_vram::num8#0 = -- memcpy8_vram_vram::num8#2 -- vbuxx=_dec_vbuyy 
    tya
    tax
    dex
    // [665] if(0!=memcpy8_vram_vram::num8#2) goto memcpy8_vram_vram::@2 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne __b2
    // memcpy8_vram_vram::@return
    // }
    // [666] return 
    rts
    // memcpy8_vram_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [667] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // [668] memcpy8_vram_vram::num8#6 = memcpy8_vram_vram::num8#0 -- vbuyy=vbuxx 
    txa
    tay
    jmp __b1
  .segment Data
    dbank_vram: .byte 0
    doffset_vram: .word 0
    sbank_vram: .byte 0
    soffset_vram: .word 0
}
  // File Data
.segment segm_lru_cache_bin
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // Values of binary digits
  RADIX_BINARY_VALUES: .word $8000, $4000, $2000, $1000, $800, $400, $200, $100, $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES: .word $8000, $1000, $200, $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES: .word $1000, $100, $10
  funcs: .word lru_cache_init, lru_cache_index, lru_cache_get, lru_cache_set, lru_cache_data, lru_cache_is_max, lru_cache_find_last, lru_cache_delete, lru_cache_insert, lru_cache_display
  __conio: .fill SIZEOF_STRUCT___1, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
  lru_cache: .fill SIZEOF_STRUCT___0, 0
}