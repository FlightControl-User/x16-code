.namespace animate {
  // Global Constants & labels
  .const STACK_BASE = $103
  .const isr_vsync = $314
  .const SIZEOF_STRUCT___54 = $402
  .label BRAM = 0
  .label BROM = 1
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
    // [3] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [4] call main
    // [105] phi from __start::@1 to main [phi:__start::@1->main] -- call_phi_near 
    jsr main
    // __start::@return
    // [5] return 
    rts
}
.segment CodeEngineAnimate
  // animate_logic
// void animate_logic(__mem() char a)
animate_logic: {
    .const OFFSET_STACK_A = 0
    // [6] animate_logic::a#0 = stackidx(char,animate_logic::OFFSET_STACK_A) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta a
    // if (!animate.wait[a])
    // [7] if(0!=((char *)&animate+$100)[animate_logic::a#0]) goto animate_logic::@1 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    tay
    lda animate+$100,y
    cmp #0
    bne __b1
    // animate_logic::@2
    // animate.wait[a] = animate.speed[a]
    // [8] ((char *)&animate+$100)[animate_logic::a#0] = ((char *)&animate+$180)[animate_logic::a#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    lda animate+$180,y
    sta animate+$100,y
    // animate.state[a] += animate.direction[a]
    // [9] ((char *)&animate+$80)[animate_logic::a#0] = ((char *)&animate+$80)[animate_logic::a#0] + ((signed char *)&animate+$300)[animate_logic::a#0] -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_pbsc2_derefidx_vbum1 
    ldx a
    lda animate+$80,x
    ldy animate+$300,x
    sty.z $ff
    clc
    adc.z $ff
    sta animate+$80,x
    // if (animate.direction[a])
    // [10] if(0==((signed char *)&animate+$300)[animate_logic::a#0]) goto animate_logic::@1 -- 0_eq_pbsc1_derefidx_vbum1_then_la1 
    ldy a
    lda animate+$300,y
    cmp #0
    beq __b1
    // animate_logic::@3
    // if (animate.direction[a] > 0)
    // [11] if(((signed char *)&animate+$300)[animate_logic::a#0]<=0) goto animate_logic::@8 -- pbsc1_derefidx_vbum1_le_0_then_la1 
    lda animate+$300,y
    cmp #1
    bmi __b8
    // animate_logic::@4
    // if (animate.state[a] >= animate.count[a])
    // [12] if(((char *)&animate+$80)[animate_logic::a#0]<((char *)&animate+$280)[animate_logic::a#0]) goto animate_logic::@8 -- pbuc1_derefidx_vbum1_lt_pbuc2_derefidx_vbum1_then_la1 
    lda animate+$80,y
    cmp animate+$280,y
    bcc __b8
    // animate_logic::@5
    // if (animate.reverse[a])
    // [13] if(0!=((char *)&animate+$380)[animate_logic::a#0]) goto animate_logic::@9 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda animate+$380,y
    cmp #0
    bne __b9
    // animate_logic::@6
    // animate.state[a] = animate.loop[a]
    // [14] ((char *)&animate+$80)[animate_logic::a#0] = ((char *)&animate+$200)[animate_logic::a#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    lda animate+$200,y
    sta animate+$80,y
    // animate_logic::@8
  __b8:
    // if (animate.direction[a] < 0)
    // [15] if(((signed char *)&animate+$300)[animate_logic::a#0]>=0) goto animate_logic::@1 -- pbsc1_derefidx_vbum1_ge_0_then_la1 
    ldy a
    lda animate+$300,y
    cmp #0
    bpl __b1
    // animate_logic::@10
    // if (animate.state[a] <= animate.loop[a])
    // [16] if(((char *)&animate+$80)[animate_logic::a#0]>((char *)&animate+$200)[animate_logic::a#0]) goto animate_logic::@1 -- pbuc1_derefidx_vbum1_gt_pbuc2_derefidx_vbum1_then_la1 
    lda animate+$200,y
    cmp animate+$80,y
    bcc __b1
    // animate_logic::@11
    // animate.direction[a] = 1
    // [17] ((signed char *)&animate+$300)[animate_logic::a#0] = 1 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #1
    sta animate+$300,y
    // animate_logic::@1
  __b1:
    // if (animate.speed[a])
    // [18] if(0==((char *)&animate+$180)[animate_logic::a#0]) goto animate_logic::@return -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy a
    lda animate+$180,y
    cmp #0
    beq __breturn
    // animate_logic::@7
    // animate.wait[a]--;
    // [19] ((char *)&animate+$100)[animate_logic::a#0] = -- ((char *)&animate+$100)[animate_logic::a#0] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx a
    dec animate+$100,x
    // animate_logic::@return
  __breturn:
    // }
    // [20] return 
    rts
    // animate_logic::@9
  __b9:
    // animate.direction[a] = -1
    // [21] ((signed char *)&animate+$300)[animate_logic::a#0] = -1 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #-1
    ldy a
    sta animate+$300,y
    jmp __b8
  .segment Data
    a: .byte 0
}
.segment CodeEngineAnimate
  // animate_get_state
// __mem() char animate_get_state(__mem() char a)
animate_get_state: {
    .const OFFSET_STACK_A = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [22] animate_get_state::a#0 = stackidx(char,animate_get_state::OFFSET_STACK_A) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta a
    // return animate.state[a];
    // [23] animate_get_state::return#0 = ((char *)&animate+$80)[animate_get_state::a#0] -- vbum1=pbuc1_derefidx_vbum2 
    tay
    lda animate+$80,y
    sta return
    // animate_get_state::@return
    // }
    // [24] stackidx(char,animate_get_state::OFFSET_STACK_RETURN_0) = animate_get_state::return#0 -- _stackidxbyte_vbuc1=vbum1 
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    // [25] return 
    rts
  .segment Data
    a: .byte 0
    return: .byte 0
}
.segment CodeEngineAnimate
  // animate_is_waiting
// __mem() char animate_is_waiting(__mem() char a)
animate_is_waiting: {
    .const OFFSET_STACK_A = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [26] animate_is_waiting::a#0 = stackidx(char,animate_is_waiting::OFFSET_STACK_A) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta a
    // return animate.wait[a];
    // [27] animate_is_waiting::return#0 = ((char *)&animate+$100)[animate_is_waiting::a#0] -- vbum1=pbuc1_derefidx_vbum2 
    tay
    lda animate+$100,y
    sta return
    // animate_is_waiting::@return
    // }
    // [28] stackidx(char,animate_is_waiting::OFFSET_STACK_RETURN_0) = animate_is_waiting::return#0 -- _stackidxbyte_vbuc1=vbum1 
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    // [29] return 
    rts
  .segment Data
    a: .byte 0
    return: .byte 0
}
.segment CodeEngineAnimate
  // animate_del
// __mem() char animate_del(__mem() char a)
animate_del: {
    .const OFFSET_STACK_A = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [30] animate_del::a#0 = stackidx(char,animate_del::OFFSET_STACK_A) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta a
    // animate.locked[a] = 0
    // [31] ((char *)&animate)[animate_del::a#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy a
    sta animate,y
    // animate.used--;
    // [32] *((char *)&animate+$401) = -- *((char *)&animate+$401) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec animate+$401
    // return animate.used;
    // [33] animate_del::return#0 = *((char *)&animate+$401) -- vbum1=_deref_pbuc1 
    lda animate+$401
    sta return
    // animate_del::@return
    // }
    // [34] stackidx(char,animate_del::OFFSET_STACK_RETURN_0) = animate_del::return#0 -- _stackidxbyte_vbuc1=vbum1 
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    // [35] return 
    rts
  .segment Data
    a: .byte 0
    return: .byte 0
}
.segment CodeEngineAnimate
  // animate_add
// __mem() char animate_add(__mem() char count, __mem() char loop, __mem() char speed, __mem() signed char direction, __mem() char reverse)
animate_add: {
    .const OFFSET_STACK_COUNT = 4
    .const OFFSET_STACK_LOOP = 3
    .const OFFSET_STACK_SPEED = 2
    .const OFFSET_STACK_DIRECTION = 1
    .const OFFSET_STACK_REVERSE = 0
    .const OFFSET_STACK_RETURN_4 = 4
    // [36] animate_add::count#0 = stackidx(char,animate_add::OFFSET_STACK_COUNT) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_COUNT,x
    sta count
    // [37] animate_add::loop#0 = stackidx(char,animate_add::OFFSET_STACK_LOOP) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_LOOP,x
    sta loop
    // [38] animate_add::speed#0 = stackidx(char,animate_add::OFFSET_STACK_SPEED) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_SPEED,x
    sta speed
    // [39] animate_add::direction#0 = stackidx(signed char,animate_add::OFFSET_STACK_DIRECTION) -- vbsm1=_stackidxsbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_DIRECTION,x
    sta direction
    // [40] animate_add::reverse#0 = stackidx(char,animate_add::OFFSET_STACK_REVERSE) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_REVERSE,x
    sta reverse
    // if (animate.used < SPRITE_ANIMATE)
    // [41] if(*((char *)&animate+$401)>=$80) goto animate_add::@1 -- _deref_pbuc1_ge_vbuc2_then_la1 
    lda animate+$401
    cmp #$80
    bcs __b1
    // animate_add::@2
  __b2:
    // while (animate.locked[animate.pool])
    // [42] if(0!=((char *)&animate)[*((char *)&animate+$400)]) goto animate_add::@3 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy animate+$400
    lda animate,y
    cmp #0
    bne __b3
    // animate_add::@4
    // char a = animate.pool
    // [43] animate_add::a#0 = *((char *)&animate+$400) -- vbum1=_deref_pbuc1 
    tya
    sta a
    // animate.locked[a] = 1
    // [44] ((char *)&animate)[animate_add::a#0] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    ldy a
    sta animate,y
    // animate.wait[a] = 0
    // [45] ((char *)&animate+$100)[animate_add::a#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta animate+$100,y
    // animate.speed[a] = speed
    // [46] ((char *)&animate+$180)[animate_add::a#0] = animate_add::speed#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda speed
    sta animate+$180,y
    // animate.reverse[a] = reverse
    // [47] ((char *)&animate+$380)[animate_add::a#0] = animate_add::reverse#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda reverse
    sta animate+$380,y
    // animate.loop[a] = loop
    // [48] ((char *)&animate+$200)[animate_add::a#0] = animate_add::loop#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda loop
    sta animate+$200,y
    // animate.count[a] = count
    // [49] ((char *)&animate+$280)[animate_add::a#0] = animate_add::count#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda count
    sta animate+$280,y
    // animate.direction[a] = direction
    // [50] ((signed char *)&animate+$300)[animate_add::a#0] = animate_add::direction#0 -- pbsc1_derefidx_vbum1=vbsm2 
    lda direction
    sta animate+$300,y
    // if (direction > 0)
    // [51] if(animate_add::direction#0>0) goto animate_add::@6 -- vbsm1_gt_0_then_la1 
    cmp #0
    beq !+
    bpl __b6
  !:
    // animate_add::@5
    // animate.state[a] = animate.count[a]
    // [52] ((char *)&animate+$80)[animate_add::a#0] = ((char *)&animate+$280)[animate_add::a#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    ldy a
    lda animate+$280,y
    sta animate+$80,y
    // animate_add::@7
  __b7:
    // animate.used++;
    // [53] *((char *)&animate+$401) = ++ *((char *)&animate+$401) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc animate+$401
    // animate_add::@1
  __b1:
    // return animate.pool;
    // [54] animate_add::return#0 = *((char *)&animate+$400) -- vbum1=_deref_pbuc1 
    lda animate+$400
    sta return
    // animate_add::@return
    // }
    // [55] stackidx(char,animate_add::OFFSET_STACK_RETURN_4) = animate_add::return#0 -- _stackidxbyte_vbuc1=vbum1 
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_4,x
    // [56] return 
    rts
    // animate_add::@6
  __b6:
    // animate.state[a] = 0
    // [57] ((char *)&animate+$80)[animate_add::a#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy a
    sta animate+$80,y
    jmp __b7
    // animate_add::@3
  __b3:
    // animate.pool + 1
    // [58] animate_add::$2 = *((char *)&animate+$400) + 1 -- vbum1=_deref_pbuc1_plus_1 
    lda animate+$400
    inc
    sta animate_add__2
    // (animate.pool + 1) % SPRITE_ANIMATE
    // [59] animate_add::$3 = animate_add::$2 & $80-1 -- vbum1=vbum2_band_vbuc1 
    lda #$80-1
    and animate_add__2
    sta animate_add__3
    // animate.pool = (animate.pool + 1) % SPRITE_ANIMATE
    // [60] *((char *)&animate+$400) = animate_add::$3 -- _deref_pbuc1=vbum1 
    sta animate+$400
    jmp __b2
  .segment Data
    animate_add__2: .byte 0
    animate_add__3: .byte 0
    count: .byte 0
    loop: .byte 0
    speed: .byte 0
    direction: .byte 0
    reverse: .byte 0
    return: .byte 0
    a: .byte 0
}
.segment CodeEngineAnimate
  // animate_init
animate_init: {
    .const memset_fast1_c = 0
    .const memset_fast2_c = 0
    .const memset_fast3_c = 0
    .const memset_fast4_c = 0
    .const memset_fast5_c = 0
    .const memset_fast6_c = 0
    .const memset_fast7_c = 0
    .const memset_fast8_c = 0
    .label memset_fast1_destination = animate+$280
    .label memset_fast2_destination = animate+$300
    .label memset_fast3_destination = animate+$200
    .label memset_fast4_destination = animate+$380
    .label memset_fast5_destination = animate+$180
    .label memset_fast6_destination = animate+$80
    .label memset_fast7_destination = animate
    .label memset_fast8_destination = animate+$100
    // [62] phi from animate_init to animate_init::memset_fast1 [phi:animate_init->animate_init::memset_fast1]
    // animate_init::memset_fast1
    // [63] phi from animate_init::memset_fast1 to animate_init::memset_fast1_@1 [phi:animate_init::memset_fast1->animate_init::memset_fast1_@1]
    // [63] phi animate_init::memset_fast1_num#2 = $80 [phi:animate_init::memset_fast1->animate_init::memset_fast1_@1#0] -- vbum1=vbuc1 
    lda #$80
    sta memset_fast1_num
    // [63] phi from animate_init::memset_fast1_@1 to animate_init::memset_fast1_@1 [phi:animate_init::memset_fast1_@1->animate_init::memset_fast1_@1]
    // [63] phi animate_init::memset_fast1_num#2 = animate_init::memset_fast1_num#1 [phi:animate_init::memset_fast1_@1->animate_init::memset_fast1_@1#0] -- register_copy 
    // animate_init::memset_fast1_@1
  memset_fast1___b1:
    // *(destination+num) = c
    // [64] animate_init::memset_fast1_destination#0[animate_init::memset_fast1_num#2] = animate_init::memset_fast1_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast1_c
    ldy memset_fast1_num
    sta memset_fast1_destination,y
    // num--;
    // [65] animate_init::memset_fast1_num#1 = -- animate_init::memset_fast1_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast1_num
    // while(num)
    // [66] if(0!=animate_init::memset_fast1_num#1) goto animate_init::memset_fast1_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast1_num
    bne memset_fast1___b1
    // [67] phi from animate_init::memset_fast1_@1 to animate_init::memset_fast2 [phi:animate_init::memset_fast1_@1->animate_init::memset_fast2]
    // animate_init::memset_fast2
    // [68] phi from animate_init::memset_fast2 to animate_init::memset_fast2_@1 [phi:animate_init::memset_fast2->animate_init::memset_fast2_@1]
    // [68] phi animate_init::memset_fast2_num#2 = $80 [phi:animate_init::memset_fast2->animate_init::memset_fast2_@1#0] -- vbum1=vbuc1 
    lda #$80
    sta memset_fast2_num
    // [68] phi from animate_init::memset_fast2_@1 to animate_init::memset_fast2_@1 [phi:animate_init::memset_fast2_@1->animate_init::memset_fast2_@1]
    // [68] phi animate_init::memset_fast2_num#2 = animate_init::memset_fast2_num#1 [phi:animate_init::memset_fast2_@1->animate_init::memset_fast2_@1#0] -- register_copy 
    // animate_init::memset_fast2_@1
  memset_fast2___b1:
    // *(destination+num) = c
    // [69] animate_init::memset_fast2_destination#0[animate_init::memset_fast2_num#2] = animate_init::memset_fast2_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast2_c
    ldy memset_fast2_num
    sta memset_fast2_destination,y
    // num--;
    // [70] animate_init::memset_fast2_num#1 = -- animate_init::memset_fast2_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast2_num
    // while(num)
    // [71] if(0!=animate_init::memset_fast2_num#1) goto animate_init::memset_fast2_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast2_num
    bne memset_fast2___b1
    // [72] phi from animate_init::memset_fast2_@1 to animate_init::memset_fast3 [phi:animate_init::memset_fast2_@1->animate_init::memset_fast3]
    // animate_init::memset_fast3
    // [73] phi from animate_init::memset_fast3 to animate_init::memset_fast3_@1 [phi:animate_init::memset_fast3->animate_init::memset_fast3_@1]
    // [73] phi animate_init::memset_fast3_num#2 = $80 [phi:animate_init::memset_fast3->animate_init::memset_fast3_@1#0] -- vbum1=vbuc1 
    lda #$80
    sta memset_fast3_num
    // [73] phi from animate_init::memset_fast3_@1 to animate_init::memset_fast3_@1 [phi:animate_init::memset_fast3_@1->animate_init::memset_fast3_@1]
    // [73] phi animate_init::memset_fast3_num#2 = animate_init::memset_fast3_num#1 [phi:animate_init::memset_fast3_@1->animate_init::memset_fast3_@1#0] -- register_copy 
    // animate_init::memset_fast3_@1
  memset_fast3___b1:
    // *(destination+num) = c
    // [74] animate_init::memset_fast3_destination#0[animate_init::memset_fast3_num#2] = animate_init::memset_fast3_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast3_c
    ldy memset_fast3_num
    sta memset_fast3_destination,y
    // num--;
    // [75] animate_init::memset_fast3_num#1 = -- animate_init::memset_fast3_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast3_num
    // while(num)
    // [76] if(0!=animate_init::memset_fast3_num#1) goto animate_init::memset_fast3_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast3_num
    bne memset_fast3___b1
    // [77] phi from animate_init::memset_fast3_@1 to animate_init::memset_fast4 [phi:animate_init::memset_fast3_@1->animate_init::memset_fast4]
    // animate_init::memset_fast4
    // [78] phi from animate_init::memset_fast4 to animate_init::memset_fast4_@1 [phi:animate_init::memset_fast4->animate_init::memset_fast4_@1]
    // [78] phi animate_init::memset_fast4_num#2 = $80 [phi:animate_init::memset_fast4->animate_init::memset_fast4_@1#0] -- vbum1=vbuc1 
    lda #$80
    sta memset_fast4_num
    // [78] phi from animate_init::memset_fast4_@1 to animate_init::memset_fast4_@1 [phi:animate_init::memset_fast4_@1->animate_init::memset_fast4_@1]
    // [78] phi animate_init::memset_fast4_num#2 = animate_init::memset_fast4_num#1 [phi:animate_init::memset_fast4_@1->animate_init::memset_fast4_@1#0] -- register_copy 
    // animate_init::memset_fast4_@1
  memset_fast4___b1:
    // *(destination+num) = c
    // [79] animate_init::memset_fast4_destination#0[animate_init::memset_fast4_num#2] = animate_init::memset_fast4_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast4_c
    ldy memset_fast4_num
    sta memset_fast4_destination,y
    // num--;
    // [80] animate_init::memset_fast4_num#1 = -- animate_init::memset_fast4_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast4_num
    // while(num)
    // [81] if(0!=animate_init::memset_fast4_num#1) goto animate_init::memset_fast4_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast4_num
    bne memset_fast4___b1
    // [82] phi from animate_init::memset_fast4_@1 to animate_init::memset_fast5 [phi:animate_init::memset_fast4_@1->animate_init::memset_fast5]
    // animate_init::memset_fast5
    // [83] phi from animate_init::memset_fast5 to animate_init::memset_fast5_@1 [phi:animate_init::memset_fast5->animate_init::memset_fast5_@1]
    // [83] phi animate_init::memset_fast5_num#2 = $80 [phi:animate_init::memset_fast5->animate_init::memset_fast5_@1#0] -- vbum1=vbuc1 
    lda #$80
    sta memset_fast5_num
    // [83] phi from animate_init::memset_fast5_@1 to animate_init::memset_fast5_@1 [phi:animate_init::memset_fast5_@1->animate_init::memset_fast5_@1]
    // [83] phi animate_init::memset_fast5_num#2 = animate_init::memset_fast5_num#1 [phi:animate_init::memset_fast5_@1->animate_init::memset_fast5_@1#0] -- register_copy 
    // animate_init::memset_fast5_@1
  memset_fast5___b1:
    // *(destination+num) = c
    // [84] animate_init::memset_fast5_destination#0[animate_init::memset_fast5_num#2] = animate_init::memset_fast5_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast5_c
    ldy memset_fast5_num
    sta memset_fast5_destination,y
    // num--;
    // [85] animate_init::memset_fast5_num#1 = -- animate_init::memset_fast5_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast5_num
    // while(num)
    // [86] if(0!=animate_init::memset_fast5_num#1) goto animate_init::memset_fast5_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast5_num
    bne memset_fast5___b1
    // [87] phi from animate_init::memset_fast5_@1 to animate_init::memset_fast6 [phi:animate_init::memset_fast5_@1->animate_init::memset_fast6]
    // animate_init::memset_fast6
    // [88] phi from animate_init::memset_fast6 to animate_init::memset_fast6_@1 [phi:animate_init::memset_fast6->animate_init::memset_fast6_@1]
    // [88] phi animate_init::memset_fast6_num#2 = $80 [phi:animate_init::memset_fast6->animate_init::memset_fast6_@1#0] -- vbum1=vbuc1 
    lda #$80
    sta memset_fast6_num
    // [88] phi from animate_init::memset_fast6_@1 to animate_init::memset_fast6_@1 [phi:animate_init::memset_fast6_@1->animate_init::memset_fast6_@1]
    // [88] phi animate_init::memset_fast6_num#2 = animate_init::memset_fast6_num#1 [phi:animate_init::memset_fast6_@1->animate_init::memset_fast6_@1#0] -- register_copy 
    // animate_init::memset_fast6_@1
  memset_fast6___b1:
    // *(destination+num) = c
    // [89] animate_init::memset_fast6_destination#0[animate_init::memset_fast6_num#2] = animate_init::memset_fast6_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast6_c
    ldy memset_fast6_num
    sta memset_fast6_destination,y
    // num--;
    // [90] animate_init::memset_fast6_num#1 = -- animate_init::memset_fast6_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast6_num
    // while(num)
    // [91] if(0!=animate_init::memset_fast6_num#1) goto animate_init::memset_fast6_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast6_num
    bne memset_fast6___b1
    // [92] phi from animate_init::memset_fast6_@1 to animate_init::memset_fast7 [phi:animate_init::memset_fast6_@1->animate_init::memset_fast7]
    // animate_init::memset_fast7
    // [93] phi from animate_init::memset_fast7 to animate_init::memset_fast7_@1 [phi:animate_init::memset_fast7->animate_init::memset_fast7_@1]
    // [93] phi animate_init::memset_fast7_num#2 = $80 [phi:animate_init::memset_fast7->animate_init::memset_fast7_@1#0] -- vbum1=vbuc1 
    lda #$80
    sta memset_fast7_num
    // [93] phi from animate_init::memset_fast7_@1 to animate_init::memset_fast7_@1 [phi:animate_init::memset_fast7_@1->animate_init::memset_fast7_@1]
    // [93] phi animate_init::memset_fast7_num#2 = animate_init::memset_fast7_num#1 [phi:animate_init::memset_fast7_@1->animate_init::memset_fast7_@1#0] -- register_copy 
    // animate_init::memset_fast7_@1
  memset_fast7___b1:
    // *(destination+num) = c
    // [94] animate_init::memset_fast7_destination#0[animate_init::memset_fast7_num#2] = animate_init::memset_fast7_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast7_c
    ldy memset_fast7_num
    sta memset_fast7_destination,y
    // num--;
    // [95] animate_init::memset_fast7_num#1 = -- animate_init::memset_fast7_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast7_num
    // while(num)
    // [96] if(0!=animate_init::memset_fast7_num#1) goto animate_init::memset_fast7_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast7_num
    bne memset_fast7___b1
    // [97] phi from animate_init::memset_fast7_@1 to animate_init::memset_fast8 [phi:animate_init::memset_fast7_@1->animate_init::memset_fast8]
    // animate_init::memset_fast8
    // [98] phi from animate_init::memset_fast8 to animate_init::memset_fast8_@1 [phi:animate_init::memset_fast8->animate_init::memset_fast8_@1]
    // [98] phi animate_init::memset_fast8_num#2 = $80 [phi:animate_init::memset_fast8->animate_init::memset_fast8_@1#0] -- vbum1=vbuc1 
    lda #$80
    sta memset_fast8_num
    // [98] phi from animate_init::memset_fast8_@1 to animate_init::memset_fast8_@1 [phi:animate_init::memset_fast8_@1->animate_init::memset_fast8_@1]
    // [98] phi animate_init::memset_fast8_num#2 = animate_init::memset_fast8_num#1 [phi:animate_init::memset_fast8_@1->animate_init::memset_fast8_@1#0] -- register_copy 
    // animate_init::memset_fast8_@1
  memset_fast8___b1:
    // *(destination+num) = c
    // [99] animate_init::memset_fast8_destination#0[animate_init::memset_fast8_num#2] = animate_init::memset_fast8_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast8_c
    ldy memset_fast8_num
    sta memset_fast8_destination,y
    // num--;
    // [100] animate_init::memset_fast8_num#1 = -- animate_init::memset_fast8_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast8_num
    // while(num)
    // [101] if(0!=animate_init::memset_fast8_num#1) goto animate_init::memset_fast8_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast8_num
    bne memset_fast8___b1
    // animate_init::@1
    // animate.pool = 0
    // [102] *((char *)&animate+$400) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta animate+$400
    // animate.used = 0
    // [103] *((char *)&animate+$401) = 0 -- _deref_pbuc1=vbuc2 
    sta animate+$401
    // animate_init::@return
    // }
    // [104] return 
    rts
    memset_fast1_num: .byte 0
    memset_fast2_num: .byte 0
    memset_fast3_num: .byte 0
    memset_fast4_num: .byte 0
    memset_fast5_num: .byte 0
    memset_fast6_num: .byte 0
    memset_fast7_num: .byte 0
    memset_fast8_num: .byte 0
}
.segment Code
  // main
main: {
    // main::@return
    // [106] return 
    rts
}
  // File Data
.segment Data
  funcs: .word animate_init, animate_add, animate_logic, animate_is_waiting, animate_get_state, animate_del
  animate: .fill SIZEOF_STRUCT___54, 0
}