  // File Comments
  // Library
.namespace lib_animate {
  // Upstart
.cpu _65c02
  
#if __asm_import__
#else

.segmentdef Code                    
.segmentdef CodeEngineAnimate       
.segmentdef Data                    
.segmentdef DataEngineAnimate       

#endif
  // Global Constants & labels
  .const SIZEOF_STRUCT___5 = $502
  // The random state variable
  .label rand_state = 6
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __lib_animate_start
// void __lib_animate_start()
__lib_animate_start: {
    // __lib_animate_start::__init1
    // volatile unsigned int rand_state = 1
    // [1] rand_state = 1 -- vwuz1=vwuc1 
    lda #<1
    sta.z rand_state
    lda #>1
    sta.z rand_state+1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [2] BRAM = 0 -- vbuz1=vbuc1 
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [3] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __lib_animate_start::@return
    // [4] return 
    rts
}
.segment CodeEngineAnimate
  // animate_tower
// void animate_tower(__zp($b) char a)
animate_tower: {
    .label a = $b
    .label animate_tower__0 = 9
    // case 0:
    //             unsigned char rnd = (char)rand();
    //             if(rnd <= 5) animate.moved[a] = 1;
    //             break;
    // [5] if(((char *)&animate+$100)[animate_tower::a]==0) goto animate_tower::@6 -- pbuc1_derefidx_vbuz1_eq_0_then_la1 
    ldy.z a
    lda animate+$100,y
    cmp #0
    bne !__b6+
    jmp __b6
  !__b6:
    // animate_tower::@1
    // case 1:
    //             animate.wait[a] = 0;
    //             animate.moved[a] = 2;
    //             break;
    // [6] if(((char *)&animate+$100)[animate_tower::a]==1) goto animate_tower::@7 -- pbuc1_derefidx_vbuz1_eq_vbuc2_then_la1 
    lda animate+$100,y
    cmp #1
    bne !__b7+
    jmp __b7
  !__b7:
    // animate_tower::@2
    // case 2:
    //             if(!animate.wait[a]) {
    //                 animate.wait[a] = animate.speed[a];
    //                 if(animate.state[a] == animate.count[a]) {
    //                     animate.wait[a] = 120;
    //                     animate.moved[a] = 3;
    //                 } else {
    //                     animate.state[a] += 1;
    //                 }
    //             } else {
    //                 animate.wait[a]--;
    //             }
    //             break;
    // [7] if(((char *)&animate+$100)[animate_tower::a]==2) goto animate_tower::@8 -- pbuc1_derefidx_vbuz1_eq_vbuc2_then_la1 
    lda animate+$100,y
    cmp #2
    beq __b8
    // animate_tower::@3
    // case 3:
    //             // Shoot
    //             if(!animate.wait[a]) {
    //                 animate.wait[a] = 0;
    //                 animate.moved[a] = 4;
    //             } else {
    //                 animate.wait[a]--;
    //             }
    //             break;
    // [8] if(((char *)&animate+$100)[animate_tower::a]==3) goto animate_tower::@9 -- pbuc1_derefidx_vbuz1_eq_vbuc2_then_la1 
    lda animate+$100,y
    cmp #3
    beq __b9
    // animate_tower::@4
    // case 4:
    //             // Shot fired
    //             animate.moved[a] = 5;
    //             animate.wait[a] = 0;
    //             break;
    // [9] if(((char *)&animate+$100)[animate_tower::a]==4) goto animate_tower::@10 -- pbuc1_derefidx_vbuz1_eq_vbuc2_then_la1 
    lda animate+$100,y
    cmp #4
    beq __b10
    // animate_tower::@5
    // case 5:
    //             if(!animate.wait[a]) {
    //                 animate.wait[a] = animate.speed[a];
    //                 if(animate.state[a] <= animate.loop[a]) {
    //                     animate.moved[a] = 0;
    //                 } else {
    //                     animate.state[a] -= 1;
    //                 }
    //             }
    //             animate.wait[a]--;
    //             break;
    // [10] if(((char *)&animate+$100)[animate_tower::a]==5) goto animate_tower::@11 -- pbuc1_derefidx_vbuz1_eq_vbuc2_then_la1 
    lda animate+$100,y
    cmp #5
    beq __b11
    // animate_tower::@12
  __b12:
    // animate.image[a] = animate.state[a]
    // [11] ((char *)&animate+$480)[animate_tower::a] = ((char *)&animate+$80)[animate_tower::a] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz1 
    ldy.z a
    lda animate+$80,y
    sta animate+$480,y
    // animate_tower::@return
    // }
    // [12] return 
    rts
    // animate_tower::@11
  __b11:
    // if(!animate.wait[a])
    // [13] if(0!=((char *)&animate+$180)[animate_tower::a]) goto animate_tower::@16 -- 0_neq_pbuc1_derefidx_vbuz1_then_la1 
    ldy.z a
    lda animate+$180,y
    cmp #0
    bne __b16
    // animate_tower::@22
    // animate.wait[a] = animate.speed[a]
    // [14] ((char *)&animate+$180)[animate_tower::a] = ((char *)&animate+$200)[animate_tower::a] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz1 
    lda animate+$200,y
    sta animate+$180,y
    // if(animate.state[a] <= animate.loop[a])
    // [15] if(((char *)&animate+$80)[animate_tower::a]<=((char *)&animate+$280)[animate_tower::a]) goto animate_tower::@17 -- pbuc1_derefidx_vbuz1_le_pbuc2_derefidx_vbuz1_then_la1 
    lda animate+$280,y
    cmp animate+$80,y
    bcs __b17
    // animate_tower::@23
    // animate.state[a] -= 1
    // [16] ((char *)&animate+$80)[animate_tower::a] = ((char *)&animate+$80)[animate_tower::a] - 1 -- pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_minus_1 
    lda animate+$80,y
    sec
    sbc #1
    sta animate+$80,y
    // animate_tower::@16
  __b16:
    // animate.wait[a]--;
    // [17] ((char *)&animate+$180)[animate_tower::a] = -- ((char *)&animate+$180)[animate_tower::a] -- pbuc1_derefidx_vbuz1=_dec_pbuc1_derefidx_vbuz1 
    ldx.z a
    dec animate+$180,x
    jmp __b12
    // animate_tower::@17
  __b17:
    // animate.moved[a] = 0
    // [18] ((char *)&animate+$100)[animate_tower::a] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z a
    sta animate+$100,y
    jmp __b16
    // animate_tower::@10
  __b10:
    // animate.moved[a] = 5
    // [19] ((char *)&animate+$100)[animate_tower::a] = 5 -- pbuc1_derefidx_vbuz1=vbuc2 
    // Shot fired
    lda #5
    ldy.z a
    sta animate+$100,y
    // animate.wait[a] = 0
    // [20] ((char *)&animate+$180)[animate_tower::a] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    sta animate+$180,y
    jmp __b12
    // animate_tower::@9
  __b9:
    // if(!animate.wait[a])
    // [21] if(0==((char *)&animate+$180)[animate_tower::a]) goto animate_tower::@15 -- 0_eq_pbuc1_derefidx_vbuz1_then_la1 
    // Shoot
    ldy.z a
    lda animate+$180,y
    cmp #0
    beq __b15
    // animate_tower::@21
    // animate.wait[a]--;
    // [22] ((char *)&animate+$180)[animate_tower::a] = -- ((char *)&animate+$180)[animate_tower::a] -- pbuc1_derefidx_vbuz1=_dec_pbuc1_derefidx_vbuz1 
    ldx.z a
    dec animate+$180,x
    jmp __b12
    // animate_tower::@15
  __b15:
    // animate.wait[a] = 0
    // [23] ((char *)&animate+$180)[animate_tower::a] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z a
    sta animate+$180,y
    // animate.moved[a] = 4
    // [24] ((char *)&animate+$100)[animate_tower::a] = 4 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #4
    sta animate+$100,y
    jmp __b12
    // animate_tower::@8
  __b8:
    // if(!animate.wait[a])
    // [25] if(0==((char *)&animate+$180)[animate_tower::a]) goto animate_tower::@13 -- 0_eq_pbuc1_derefidx_vbuz1_then_la1 
    ldy.z a
    lda animate+$180,y
    cmp #0
    beq __b13
    // animate_tower::@19
    // animate.wait[a]--;
    // [26] ((char *)&animate+$180)[animate_tower::a] = -- ((char *)&animate+$180)[animate_tower::a] -- pbuc1_derefidx_vbuz1=_dec_pbuc1_derefidx_vbuz1 
    ldx.z a
    dec animate+$180,x
    jmp __b12
    // animate_tower::@13
  __b13:
    // animate.wait[a] = animate.speed[a]
    // [27] ((char *)&animate+$180)[animate_tower::a] = ((char *)&animate+$200)[animate_tower::a] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz1 
    ldy.z a
    lda animate+$200,y
    sta animate+$180,y
    // if(animate.state[a] == animate.count[a])
    // [28] if(((char *)&animate+$80)[animate_tower::a]==((char *)&animate+$300)[animate_tower::a]) goto animate_tower::@14 -- pbuc1_derefidx_vbuz1_eq_pbuc2_derefidx_vbuz1_then_la1 
    ldx.z a
    lda animate+$80,x
    tay
    lda animate+$300,x
    tax
    sty.z $ff
    cpx.z $ff
    beq __b14
    // animate_tower::@20
    // animate.state[a] += 1
    // [29] ((char *)&animate+$80)[animate_tower::a] = ((char *)&animate+$80)[animate_tower::a] + 1 -- pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_plus_1 
    ldy.z a
    lda animate+$80,y
    inc
    sta animate+$80,y
    jmp __b12
    // animate_tower::@14
  __b14:
    // animate.wait[a] = 120
    // [30] ((char *)&animate+$180)[animate_tower::a] = $78 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #$78
    ldy.z a
    sta animate+$180,y
    // animate.moved[a] = 3
    // [31] ((char *)&animate+$100)[animate_tower::a] = 3 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #3
    sta animate+$100,y
    jmp __b12
    // animate_tower::@7
  __b7:
    // animate.wait[a] = 0
    // [32] ((char *)&animate+$180)[animate_tower::a] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z a
    sta animate+$180,y
    // animate.moved[a] = 2
    // [33] ((char *)&animate+$100)[animate_tower::a] = 2 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #2
    sta animate+$100,y
    jmp __b12
    // [34] phi from animate_tower to animate_tower::@6 [phi:animate_tower->animate_tower::@6]
    // animate_tower::@6
  __b6:
    // rand()
    // [35] call rand
    jsr rand
    // [36] rand::return#2 = rand::return#0
    // animate_tower::@24
    // [37] animate_tower::$0 = rand::return#2 -- vwuz1=vwuz2 
    lda.z rand.return
    sta.z animate_tower__0
    lda.z rand.return+1
    sta.z animate_tower__0+1
    // unsigned char rnd = (char)rand()
    // [38] animate_tower::rnd#0 = (char)animate_tower::$0 -- vbuaa=_byte_vwuz1 
    lda.z animate_tower__0
    // if(rnd <= 5)
    // [39] if(animate_tower::rnd#0>=5+1) goto animate_tower::@12 -- vbuaa_ge_vbuc1_then_la1 
    cmp #5+1
    bcc !__b12+
    jmp __b12
  !__b12:
    // animate_tower::@18
    // animate.moved[a] = 1
    // [40] ((char *)&animate+$100)[animate_tower::a] = 1 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #1
    ldy.z a
    sta animate+$100,y
    jmp __b12
}
  // animate_player
/**
 * @brief Animation of the player object.
 * It performs 3 different transitions:
 * - Stable state alternating between rotor positions.
 * - Fly left or right, turning wings.
 * - Rotate for eye candy, left or right.
 * 
 * Needs a current x and a previous x coordinate to decide on the animation action.
 * Both coordinates are signed.
 */
// void animate_player(__zp(8) char a, __zp(9) int x, __zp($e) int px)
animate_player: {
    .label a = 8
    .label x = 9
    .label px = $e
    // if (!animate.wait[a])
    // [41] if(0!=((char *)&animate+$180)[animate_player::a]) goto animate_player::@1 -- 0_neq_pbuc1_derefidx_vbuz1_then_la1 
    ldy.z a
    lda animate+$180,y
    cmp #0
    beq !__b1+
    jmp __b1
  !__b1:
    // animate_player::@2
    // animate.wait[a] = animate.speed[a]
    // [42] ((char *)&animate+$180)[animate_player::a] = ((char *)&animate+$200)[animate_player::a] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz1 
    lda animate+$200,y
    sta animate+$180,y
    // if (x < px)
    // [43] if(animate_player::x>=animate_player::px) goto animate_player::@5 -- vwsz1_ge_vwsz2_then_la1 
    lda.z x
    cmp.z px
    lda.z x+1
    sbc.z px+1
    bvc !+
    eor #$80
  !:
    bpl __b5
    // animate_player::@3
    // if (animate.state[a] > 0)
    // [44] if(((char *)&animate+$80)[animate_player::a]<=0) goto animate_player::@6 -- pbuc1_derefidx_vbuz1_le_0_then_la1 
    ldy.z a
    lda animate+$80,y
    cmp #0
    beq __b6
    // animate_player::@4
    // animate.state[a] -= 1
    // [45] ((char *)&animate+$80)[animate_player::a] = ((char *)&animate+$80)[animate_player::a] - 1 -- pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_minus_1 
    lda animate+$80,y
    sec
    sbc #1
    sta animate+$80,y
    // animate_player::@6
  __b6:
    // animate.moved[a] = 2
    // [46] ((char *)&animate+$100)[animate_player::a] = 2 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #2
    ldy.z a
    sta animate+$100,y
    // animate_player::@5
  __b5:
    // if (x > px)
    // [47] if(animate_player::x<=animate_player::px) goto animate_player::@7 -- vwsz1_le_vwsz2_then_la1 
    lda.z px
    cmp.z x
    lda.z px+1
    sbc.z x+1
    bvc !+
    eor #$80
  !:
    bpl __b7
    // animate_player::@17
    // if(animate.state[a] < 6)
    // [48] if(((char *)&animate+$80)[animate_player::a]>=6) goto animate_player::@8 -- pbuc1_derefidx_vbuz1_ge_vbuc2_then_la1 
    ldy.z a
    lda animate+$80,y
    cmp #6
    bcs __b8
    // animate_player::@18
    // animate.state[a] += 1
    // [49] ((char *)&animate+$80)[animate_player::a] = ((char *)&animate+$80)[animate_player::a] + 1 -- pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_plus_1 
    lda animate+$80,y
    inc
    sta animate+$80,y
    // animate_player::@8
  __b8:
    // animate.moved[a] = 2
    // [50] ((char *)&animate+$100)[animate_player::a] = 2 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #2
    ldy.z a
    sta animate+$100,y
    // animate_player::@7
  __b7:
    // if (animate.moved[a] == 1)
    // [51] if(((char *)&animate+$100)[animate_player::a]!=1) goto animate_player::@9 -- pbuc1_derefidx_vbuz1_neq_vbuc2_then_la1 
    lda #1
    ldy.z a
    cmp animate+$100,y
    bne __b9
    // animate_player::@19
    // if (animate.state[a] < animate.loop[a])
    // [52] if(((char *)&animate+$80)[animate_player::a]>=((char *)&animate+$280)[animate_player::a]) goto animate_player::@10 -- pbuc1_derefidx_vbuz1_ge_pbuc2_derefidx_vbuz1_then_la1 
    lda animate+$80,y
    cmp animate+$280,y
    bcs __b10
    // animate_player::@20
    // animate.state[a] += 1
    // [53] ((char *)&animate+$80)[animate_player::a] = ((char *)&animate+$80)[animate_player::a] + 1 -- pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_plus_1 
    lda animate+$80,y
    inc
    sta animate+$80,y
    // animate_player::@10
  __b10:
    // if (animate.state[a] > animate.loop[a])
    // [54] if(((char *)&animate+$80)[animate_player::a]<=((char *)&animate+$280)[animate_player::a]) goto animate_player::@11 -- pbuc1_derefidx_vbuz1_le_pbuc2_derefidx_vbuz1_then_la1 
    ldy.z a
    lda animate+$280,y
    cmp animate+$80,y
    bcs __b11
    // animate_player::@12
    // animate.state[a] -= 1
    // [55] ((char *)&animate+$80)[animate_player::a] = ((char *)&animate+$80)[animate_player::a] - 1 -- pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_minus_1 
    lda animate+$80,y
    sec
    sbc #1
    sta animate+$80,y
    // animate_player::@11
  __b11:
    // if (animate.state[a] == animate.loop[a])
    // [56] if(((char *)&animate+$80)[animate_player::a]!=((char *)&animate+$280)[animate_player::a]) goto animate_player::@9 -- pbuc1_derefidx_vbuz1_neq_pbuc2_derefidx_vbuz1_then_la1 
    ldy.z a
    lda animate+$80,y
    cmp animate+$280,y
    bne __b9
    // animate_player::@13
    // animate.moved[a] = 0
    // [57] ((char *)&animate+$100)[animate_player::a] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    sta animate+$100,y
    // animate_player::@9
  __b9:
    // if (animate.moved[a] == 2)
    // [58] if(((char *)&animate+$100)[animate_player::a]!=2) goto animate_player::@14 -- pbuc1_derefidx_vbuz1_neq_vbuc2_then_la1 
    lda #2
    ldy.z a
    cmp animate+$100,y
    bne __b14
    // animate_player::@21
    // animate.moved[a]--;
    // [59] ((char *)&animate+$100)[animate_player::a] = -- ((char *)&animate+$100)[animate_player::a] -- pbuc1_derefidx_vbuz1=_dec_pbuc1_derefidx_vbuz1 
    ldx.z a
    dec animate+$100,x
    // animate_player::@14
  __b14:
    // if(animate.moved[a] == 0)
    // [60] if(((char *)&animate+$100)[animate_player::a]==0) goto animate_player::@15 -- pbuc1_derefidx_vbuz1_eq_0_then_la1 
    ldy.z a
    lda animate+$100,y
    cmp #0
    beq __b15
    // animate_player::@22
    // if(animate.moved[a] == 1)
    // [61] if(((char *)&animate+$100)[animate_player::a]!=1) goto animate_player::@1 -- pbuc1_derefidx_vbuz1_neq_vbuc2_then_la1 
    lda #1
    cmp animate+$100,y
    bne __b1
    // animate_player::@23
    // (char)13 + animate.state[a]
    // [62] animate_player::$25 = $d + ((char *)&animate+$80)[animate_player::a] -- vbuaa=vbuc1_plus_pbuc2_derefidx_vbuz1 
    lda #$d
    clc
    adc animate+$80,y
    // ((char)13 + animate.state[a]) % (char)16
    // [63] animate_player::$26 = animate_player::$25 & $10-1 -- vbuaa=vbuaa_band_vbuc1 
    and #$10-1
    // animate.image[a] = ((char)13 + animate.state[a]) % (char)16
    // [64] ((char *)&animate+$480)[animate_player::a] = animate_player::$26 -- pbuc1_derefidx_vbuz1=vbuaa 
    sta animate+$480,y
    // animate_player::@1
  __b1:
    // animate.wait[a]--;
    // [65] ((char *)&animate+$180)[animate_player::a] = -- ((char *)&animate+$180)[animate_player::a] -- pbuc1_derefidx_vbuz1=_dec_pbuc1_derefidx_vbuz1 
    ldx.z a
    dec animate+$180,x
    // animate_player::@return
    // }
    // [66] return 
    rts
    // animate_player::@15
  __b15:
    // if(animate.image[a] == 16)
    // [67] if(((char *)&animate+$480)[animate_player::a]==$10) goto animate_player::@16 -- pbuc1_derefidx_vbuz1_eq_vbuc2_then_la1 
    ldy.z a
    lda animate+$480,y
    cmp #$10
    beq __b16
    // animate_player::@24
    // animate.image[a] = 16
    // [68] ((char *)&animate+$480)[animate_player::a] = $10 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #$10
    sta animate+$480,y
    jmp __b1
    // animate_player::@16
  __b16:
    // animate.state[a]-animate.loop[a]
    // [69] animate_player::$28 = ((char *)&animate+$80)[animate_player::a] - ((char *)&animate+$280)[animate_player::a] -- vbuaa=pbuc1_derefidx_vbuz1_minus_pbuc2_derefidx_vbuz1 
    ldy.z a
    lda animate+$80,y
    sec
    sbc animate+$280,y
    // animate.image[a] = animate.state[a]-animate.loop[a]
    // [70] ((char *)&animate+$480)[animate_player::a] = animate_player::$28 -- pbuc1_derefidx_vbuz1=vbuaa 
    sta animate+$480,y
    jmp __b1
}
  // animate_logic
/**
 * @brief Main animation logic, for looping and reversing animations:
 * - Start loop from a start position.
 * - Loop when a loop position is reached.
 * - Two possible directions of looping.
 * - Possibly change direction and reverse.
 */
// void animate_logic(__zp(2) char a)
animate_logic: {
    .label a = 2
    // if (!animate.wait[a])
    // [71] if(0!=((char *)&animate+$180)[animate_logic::a]) goto animate_logic::@1 -- 0_neq_pbuc1_derefidx_vbuz1_then_la1 
    ldy.z a
    lda animate+$180,y
    cmp #0
    bne __b1
    // animate_logic::@3
    // animate.wait[a] = animate.speed[a]
    // [72] ((char *)&animate+$180)[animate_logic::a] = ((char *)&animate+$200)[animate_logic::a] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz1 
    lda animate+$200,y
    sta animate+$180,y
    // animate.state[a] += animate.direction[a]
    // [73] ((char *)&animate+$80)[animate_logic::a] = ((char *)&animate+$80)[animate_logic::a] + ((signed char *)&animate+$380)[animate_logic::a] -- pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_plus_pbsc2_derefidx_vbuz1 
    ldx.z a
    lda animate+$80,x
    ldy animate+$380,x
    sty.z $ff
    clc
    adc.z $ff
    sta animate+$80,x
    // if (animate.direction[a])
    // [74] if(0==((signed char *)&animate+$380)[animate_logic::a]) goto animate_logic::@1 -- 0_eq_pbsc1_derefidx_vbuz1_then_la1 
    ldy.z a
    lda animate+$380,y
    cmp #0
    beq __b1
    // animate_logic::@4
    // if (animate.direction[a] > 0)
    // [75] if(((signed char *)&animate+$380)[animate_logic::a]<=0) goto animate_logic::@9 -- pbsc1_derefidx_vbuz1_le_0_then_la1 
    lda animate+$380,y
    cmp #1
    bmi __b9
    // animate_logic::@5
    // if (animate.state[a] >= animate.count[a])
    // [76] if(((char *)&animate+$80)[animate_logic::a]<((char *)&animate+$300)[animate_logic::a]) goto animate_logic::@9 -- pbuc1_derefidx_vbuz1_lt_pbuc2_derefidx_vbuz1_then_la1 
    lda animate+$80,y
    cmp animate+$300,y
    bcc __b9
    // animate_logic::@6
    // if (animate.reverse[a])
    // [77] if(0!=((char *)&animate+$400)[animate_logic::a]) goto animate_logic::@10 -- 0_neq_pbuc1_derefidx_vbuz1_then_la1 
    lda animate+$400,y
    cmp #0
    bne __b10
    // animate_logic::@7
    // animate.state[a] = animate.loop[a]
    // [78] ((char *)&animate+$80)[animate_logic::a] = ((char *)&animate+$280)[animate_logic::a] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz1 
    lda animate+$280,y
    sta animate+$80,y
    // animate_logic::@9
  __b9:
    // if (animate.direction[a] < 0)
    // [79] if(((signed char *)&animate+$380)[animate_logic::a]>=0) goto animate_logic::@1 -- pbsc1_derefidx_vbuz1_ge_0_then_la1 
    ldy.z a
    lda animate+$380,y
    cmp #0
    bpl __b1
    // animate_logic::@11
    // if (animate.state[a] <= animate.loop[a])
    // [80] if(((char *)&animate+$80)[animate_logic::a]>((char *)&animate+$280)[animate_logic::a]) goto animate_logic::@1 -- pbuc1_derefidx_vbuz1_gt_pbuc2_derefidx_vbuz1_then_la1 
    lda animate+$280,y
    cmp animate+$80,y
    bcc __b1
    // animate_logic::@12
    // animate.direction[a] = 1
    // [81] ((signed char *)&animate+$380)[animate_logic::a] = 1 -- pbsc1_derefidx_vbuz1=vbsc2 
    lda #1
    sta animate+$380,y
    // animate_logic::@1
  __b1:
    // if (animate.speed[a])
    // [82] if(0==((char *)&animate+$200)[animate_logic::a]) goto animate_logic::@2 -- 0_eq_pbuc1_derefidx_vbuz1_then_la1 
    ldy.z a
    lda animate+$200,y
    cmp #0
    beq __b2
    // animate_logic::@8
    // animate.wait[a]--;
    // [83] ((char *)&animate+$180)[animate_logic::a] = -- ((char *)&animate+$180)[animate_logic::a] -- pbuc1_derefidx_vbuz1=_dec_pbuc1_derefidx_vbuz1 
    ldx.z a
    dec animate+$180,x
    // animate_logic::@2
  __b2:
    // animate.image[a] = animate.state[a]
    // [84] ((char *)&animate+$480)[animate_logic::a] = ((char *)&animate+$80)[animate_logic::a] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz1 
    ldy.z a
    lda animate+$80,y
    sta animate+$480,y
    // animate_logic::@return
    // }
    // [85] return 
    rts
    // animate_logic::@10
  __b10:
    // animate.direction[a] = -1
    // [86] ((signed char *)&animate+$380)[animate_logic::a] = -1 -- pbsc1_derefidx_vbuz1=vbsc2 
    lda #-1
    ldy.z a
    sta animate+$380,y
    jmp __b9
}
  // animate_get_image
/**
 * @brief There is a decouplement between the state of the animation and the actual image projected.
 * This is handy when there are multiple transitions and multiple images to reflect those transitions
 * with high level of re-use of images.
 * This function is called when drawing, enquiring the animation state.
 */
// __zp(2) char animate_get_image(__zp($c) char a)
animate_get_image: {
    .label a = $c
    .label return = 2
    // return animate.image[a];
    // [87] animate_get_image::return = ((char *)&animate+$480)[animate_get_image::a] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z a
    lda animate+$480,y
    sta.z return
    // animate_get_image::@return
    // }
    // [88] return 
    rts
}
  // animate_get_transition
/**
 * @brief Enquire the current state of transition of the animation.
 */
// __zp(2) char animate_get_transition(__zp($d) char a)
animate_get_transition: {
    .label a = $d
    .label return = 2
    // return animate.moved[a];
    // [89] animate_get_transition::return = ((char *)&animate+$100)[animate_get_transition::a] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z a
    lda animate+$100,y
    sta.z return
    // animate_get_transition::@return
    // }
    // [90] return 
    rts
}
  // animate_is_waiting
// __zp(2) char animate_is_waiting(__zp(5) char a)
animate_is_waiting: {
    .label a = 5
    .label return = 2
    // return animate.wait[a];
    // [91] animate_is_waiting::return = ((char *)&animate+$180)[animate_is_waiting::a] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z a
    lda animate+$180,y
    sta.z return
    // animate_is_waiting::@return
    // }
    // [92] return 
    rts
}
  // animate_del
/**
 * @brief Delete the animation from the queue.
 */
// __zp(2) char animate_del(__zp(5) char a)
animate_del: {
    .label a = 5
    .label return = 2
    // animate.locked[a] = 0
    // [93] ((char *)&animate)[animate_del::a] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z a
    sta animate,y
    // animate.used--;
    // [94] *((char *)&animate+$501) = -- *((char *)&animate+$501) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec animate+$501
    // return animate.used;
    // [95] animate_del::return = *((char *)&animate+$501) -- vbuz1=_deref_pbuc1 
    lda animate+$501
    sta.z return
    // animate_del::@return
    // }
    // [96] return 
    rts
}
  // animate_add
/**
 * @brief Add an animation to the animation pool.
 * There can be a maximum of 16 different animation active at the same time.
 * Animations are assigned to each object, so each object has it's own unique state.
 * 
 * @param count Total amount of animation possible states.
 * @param state Start state of the animation.
 * @param loop Start state when the animation loops.
 * @param speed Speed of the animation in frames per second.
 * @param direction Direction of the animation, which can be 1 or -1.
 * @param reverse Check if the animation needs to be reversed when loop is reached.
 * @return unsigned char
 */
// __zp(5) char animate_add(__zp(5) char count, __zp($d) char state, __zp($c) char loop, __zp(2) char speed, __zp(8) signed char direction, __zp($b) char reverse)
animate_add: {
    .label count = 5
    .label state = $d
    .label loop = $c
    .label speed = 2
    .label direction = 8
    .label reverse = $b
    .label return = 5
    // if (animate.used < SPRITE_ANIMATE)
    // [97] if(*((char *)&animate+$501)>=$80) goto animate_add::@1 -- _deref_pbuc1_ge_vbuc2_then_la1 
    lda animate+$501
    cmp #$80
    bcs __b1
    // animate_add::@2
  __b2:
    // while (animate.locked[animate.pool])
    // [98] if(0!=((char *)&animate)[*((char *)&animate+$500)]) goto animate_add::@3 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy animate+$500
    lda animate,y
    cmp #0
    bne __b3
    // animate_add::@4
    // char a = animate.pool
    // [99] animate_add::a#0 = *((char *)&animate+$500) -- vbuxx=_deref_pbuc1 
    ldx animate+$500
    // animate.locked[a] = 1
    // [100] ((char *)&animate)[animate_add::a#0] = 1 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #1
    sta animate,x
    // animate.wait[a] = 0
    // [101] ((char *)&animate+$180)[animate_add::a#0] = 0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #0
    sta animate+$180,x
    // animate.speed[a] = speed
    // [102] ((char *)&animate+$200)[animate_add::a#0] = animate_add::speed -- pbuc1_derefidx_vbuxx=vbuz1 
    lda.z speed
    sta animate+$200,x
    // animate.reverse[a] = reverse
    // [103] ((char *)&animate+$400)[animate_add::a#0] = animate_add::reverse -- pbuc1_derefidx_vbuxx=vbuz1 
    lda.z reverse
    sta animate+$400,x
    // animate.loop[a] = loop
    // [104] ((char *)&animate+$280)[animate_add::a#0] = animate_add::loop -- pbuc1_derefidx_vbuxx=vbuz1 
    lda.z loop
    sta animate+$280,x
    // animate.count[a] = count
    // [105] ((char *)&animate+$300)[animate_add::a#0] = animate_add::count -- pbuc1_derefidx_vbuxx=vbuz1 
    lda.z count
    sta animate+$300,x
    // animate.state[a] = state
    // [106] ((char *)&animate+$80)[animate_add::a#0] = animate_add::state -- pbuc1_derefidx_vbuxx=vbuz1 
    lda.z state
    sta animate+$80,x
    // animate.direction[a] = direction
    // [107] ((signed char *)&animate+$380)[animate_add::a#0] = animate_add::direction -- pbsc1_derefidx_vbuxx=vbsz1 
    lda.z direction
    sta animate+$380,x
    // animate.image[a] = 0
    // [108] ((char *)&animate+$480)[animate_add::a#0] = 0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #0
    sta animate+$480,x
    // animate.moved[a] = 0
    // [109] ((char *)&animate+$100)[animate_add::a#0] = 0 -- pbuc1_derefidx_vbuxx=vbuc2 
    sta animate+$100,x
    // animate.used++;
    // [110] *((char *)&animate+$501) = ++ *((char *)&animate+$501) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc animate+$501
    // animate_add::@1
  __b1:
    // return animate.pool;
    // [111] animate_add::return = *((char *)&animate+$500) -- vbuz1=_deref_pbuc1 
    lda animate+$500
    sta.z return
    // animate_add::@return
    // }
    // [112] return 
    rts
    // animate_add::@3
  __b3:
    // animate.pool + 1
    // [113] animate_add::$2 = *((char *)&animate+$500) + 1 -- vbuaa=_deref_pbuc1_plus_1 
    lda animate+$500
    inc
    // (animate.pool + 1) % SPRITE_ANIMATE
    // [114] animate_add::$3 = animate_add::$2 & $80-1 -- vbuaa=vbuaa_band_vbuc1 
    and #$80-1
    // animate.pool = (animate.pool + 1) % SPRITE_ANIMATE
    // [115] *((char *)&animate+$500) = animate_add::$3 -- _deref_pbuc1=vbuaa 
    sta animate+$500
    jmp __b2
}
  // animate_init
// void animate_init()
animate_init: {
    .const memset_fast1_c = 0
    .const memset_fast2_c = 0
    .const memset_fast3_c = 0
    .const memset_fast4_c = 0
    .const memset_fast5_c = 0
    .const memset_fast6_c = 0
    .const memset_fast7_c = 0
    .const memset_fast8_c = 0
    .label memset_fast1_destination = animate+$300
    .label memset_fast2_destination = animate+$380
    .label memset_fast3_destination = animate+$280
    .label memset_fast4_destination = animate+$400
    .label memset_fast5_destination = animate+$200
    .label memset_fast6_destination = animate+$80
    .label memset_fast7_destination = animate
    .label memset_fast8_destination = animate+$180
    // [117] phi from animate_init to animate_init::memset_fast1 [phi:animate_init->animate_init::memset_fast1]
    // animate_init::memset_fast1
    // [118] phi from animate_init::memset_fast1 to animate_init::memset_fast1_@1 [phi:animate_init::memset_fast1->animate_init::memset_fast1_@1]
    // [118] phi animate_init::memset_fast1_num#2 = $80 [phi:animate_init::memset_fast1->animate_init::memset_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #$80
    // [118] phi from animate_init::memset_fast1_@1 to animate_init::memset_fast1_@1 [phi:animate_init::memset_fast1_@1->animate_init::memset_fast1_@1]
    // [118] phi animate_init::memset_fast1_num#2 = animate_init::memset_fast1_num#1 [phi:animate_init::memset_fast1_@1->animate_init::memset_fast1_@1#0] -- register_copy 
    // animate_init::memset_fast1_@1
  memset_fast1___b1:
    // *(destination+num) = c
    // [119] animate_init::memset_fast1_destination#0[animate_init::memset_fast1_num#2] = animate_init::memset_fast1_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast1_c
    sta memset_fast1_destination,x
    // num--;
    // [120] animate_init::memset_fast1_num#1 = -- animate_init::memset_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [121] if(0!=animate_init::memset_fast1_num#1) goto animate_init::memset_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast1___b1
    // [122] phi from animate_init::memset_fast1_@1 to animate_init::memset_fast2 [phi:animate_init::memset_fast1_@1->animate_init::memset_fast2]
    // animate_init::memset_fast2
    // [123] phi from animate_init::memset_fast2 to animate_init::memset_fast2_@1 [phi:animate_init::memset_fast2->animate_init::memset_fast2_@1]
    // [123] phi animate_init::memset_fast2_num#2 = $80 [phi:animate_init::memset_fast2->animate_init::memset_fast2_@1#0] -- vbuxx=vbuc1 
    ldx #$80
    // [123] phi from animate_init::memset_fast2_@1 to animate_init::memset_fast2_@1 [phi:animate_init::memset_fast2_@1->animate_init::memset_fast2_@1]
    // [123] phi animate_init::memset_fast2_num#2 = animate_init::memset_fast2_num#1 [phi:animate_init::memset_fast2_@1->animate_init::memset_fast2_@1#0] -- register_copy 
    // animate_init::memset_fast2_@1
  memset_fast2___b1:
    // *(destination+num) = c
    // [124] animate_init::memset_fast2_destination#0[animate_init::memset_fast2_num#2] = animate_init::memset_fast2_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast2_c
    sta memset_fast2_destination,x
    // num--;
    // [125] animate_init::memset_fast2_num#1 = -- animate_init::memset_fast2_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [126] if(0!=animate_init::memset_fast2_num#1) goto animate_init::memset_fast2_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast2___b1
    // [127] phi from animate_init::memset_fast2_@1 to animate_init::memset_fast3 [phi:animate_init::memset_fast2_@1->animate_init::memset_fast3]
    // animate_init::memset_fast3
    // [128] phi from animate_init::memset_fast3 to animate_init::memset_fast3_@1 [phi:animate_init::memset_fast3->animate_init::memset_fast3_@1]
    // [128] phi animate_init::memset_fast3_num#2 = $80 [phi:animate_init::memset_fast3->animate_init::memset_fast3_@1#0] -- vbuxx=vbuc1 
    ldx #$80
    // [128] phi from animate_init::memset_fast3_@1 to animate_init::memset_fast3_@1 [phi:animate_init::memset_fast3_@1->animate_init::memset_fast3_@1]
    // [128] phi animate_init::memset_fast3_num#2 = animate_init::memset_fast3_num#1 [phi:animate_init::memset_fast3_@1->animate_init::memset_fast3_@1#0] -- register_copy 
    // animate_init::memset_fast3_@1
  memset_fast3___b1:
    // *(destination+num) = c
    // [129] animate_init::memset_fast3_destination#0[animate_init::memset_fast3_num#2] = animate_init::memset_fast3_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast3_c
    sta memset_fast3_destination,x
    // num--;
    // [130] animate_init::memset_fast3_num#1 = -- animate_init::memset_fast3_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [131] if(0!=animate_init::memset_fast3_num#1) goto animate_init::memset_fast3_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast3___b1
    // [132] phi from animate_init::memset_fast3_@1 to animate_init::memset_fast4 [phi:animate_init::memset_fast3_@1->animate_init::memset_fast4]
    // animate_init::memset_fast4
    // [133] phi from animate_init::memset_fast4 to animate_init::memset_fast4_@1 [phi:animate_init::memset_fast4->animate_init::memset_fast4_@1]
    // [133] phi animate_init::memset_fast4_num#2 = $80 [phi:animate_init::memset_fast4->animate_init::memset_fast4_@1#0] -- vbuxx=vbuc1 
    ldx #$80
    // [133] phi from animate_init::memset_fast4_@1 to animate_init::memset_fast4_@1 [phi:animate_init::memset_fast4_@1->animate_init::memset_fast4_@1]
    // [133] phi animate_init::memset_fast4_num#2 = animate_init::memset_fast4_num#1 [phi:animate_init::memset_fast4_@1->animate_init::memset_fast4_@1#0] -- register_copy 
    // animate_init::memset_fast4_@1
  memset_fast4___b1:
    // *(destination+num) = c
    // [134] animate_init::memset_fast4_destination#0[animate_init::memset_fast4_num#2] = animate_init::memset_fast4_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast4_c
    sta memset_fast4_destination,x
    // num--;
    // [135] animate_init::memset_fast4_num#1 = -- animate_init::memset_fast4_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [136] if(0!=animate_init::memset_fast4_num#1) goto animate_init::memset_fast4_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast4___b1
    // [137] phi from animate_init::memset_fast4_@1 to animate_init::memset_fast5 [phi:animate_init::memset_fast4_@1->animate_init::memset_fast5]
    // animate_init::memset_fast5
    // [138] phi from animate_init::memset_fast5 to animate_init::memset_fast5_@1 [phi:animate_init::memset_fast5->animate_init::memset_fast5_@1]
    // [138] phi animate_init::memset_fast5_num#2 = $80 [phi:animate_init::memset_fast5->animate_init::memset_fast5_@1#0] -- vbuxx=vbuc1 
    ldx #$80
    // [138] phi from animate_init::memset_fast5_@1 to animate_init::memset_fast5_@1 [phi:animate_init::memset_fast5_@1->animate_init::memset_fast5_@1]
    // [138] phi animate_init::memset_fast5_num#2 = animate_init::memset_fast5_num#1 [phi:animate_init::memset_fast5_@1->animate_init::memset_fast5_@1#0] -- register_copy 
    // animate_init::memset_fast5_@1
  memset_fast5___b1:
    // *(destination+num) = c
    // [139] animate_init::memset_fast5_destination#0[animate_init::memset_fast5_num#2] = animate_init::memset_fast5_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast5_c
    sta memset_fast5_destination,x
    // num--;
    // [140] animate_init::memset_fast5_num#1 = -- animate_init::memset_fast5_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [141] if(0!=animate_init::memset_fast5_num#1) goto animate_init::memset_fast5_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast5___b1
    // [142] phi from animate_init::memset_fast5_@1 to animate_init::memset_fast6 [phi:animate_init::memset_fast5_@1->animate_init::memset_fast6]
    // animate_init::memset_fast6
    // [143] phi from animate_init::memset_fast6 to animate_init::memset_fast6_@1 [phi:animate_init::memset_fast6->animate_init::memset_fast6_@1]
    // [143] phi animate_init::memset_fast6_num#2 = $80 [phi:animate_init::memset_fast6->animate_init::memset_fast6_@1#0] -- vbuxx=vbuc1 
    ldx #$80
    // [143] phi from animate_init::memset_fast6_@1 to animate_init::memset_fast6_@1 [phi:animate_init::memset_fast6_@1->animate_init::memset_fast6_@1]
    // [143] phi animate_init::memset_fast6_num#2 = animate_init::memset_fast6_num#1 [phi:animate_init::memset_fast6_@1->animate_init::memset_fast6_@1#0] -- register_copy 
    // animate_init::memset_fast6_@1
  memset_fast6___b1:
    // *(destination+num) = c
    // [144] animate_init::memset_fast6_destination#0[animate_init::memset_fast6_num#2] = animate_init::memset_fast6_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast6_c
    sta memset_fast6_destination,x
    // num--;
    // [145] animate_init::memset_fast6_num#1 = -- animate_init::memset_fast6_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [146] if(0!=animate_init::memset_fast6_num#1) goto animate_init::memset_fast6_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast6___b1
    // [147] phi from animate_init::memset_fast6_@1 to animate_init::memset_fast7 [phi:animate_init::memset_fast6_@1->animate_init::memset_fast7]
    // animate_init::memset_fast7
    // [148] phi from animate_init::memset_fast7 to animate_init::memset_fast7_@1 [phi:animate_init::memset_fast7->animate_init::memset_fast7_@1]
    // [148] phi animate_init::memset_fast7_num#2 = $80 [phi:animate_init::memset_fast7->animate_init::memset_fast7_@1#0] -- vbuxx=vbuc1 
    ldx #$80
    // [148] phi from animate_init::memset_fast7_@1 to animate_init::memset_fast7_@1 [phi:animate_init::memset_fast7_@1->animate_init::memset_fast7_@1]
    // [148] phi animate_init::memset_fast7_num#2 = animate_init::memset_fast7_num#1 [phi:animate_init::memset_fast7_@1->animate_init::memset_fast7_@1#0] -- register_copy 
    // animate_init::memset_fast7_@1
  memset_fast7___b1:
    // *(destination+num) = c
    // [149] animate_init::memset_fast7_destination#0[animate_init::memset_fast7_num#2] = animate_init::memset_fast7_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast7_c
    sta memset_fast7_destination,x
    // num--;
    // [150] animate_init::memset_fast7_num#1 = -- animate_init::memset_fast7_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [151] if(0!=animate_init::memset_fast7_num#1) goto animate_init::memset_fast7_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast7___b1
    // [152] phi from animate_init::memset_fast7_@1 to animate_init::memset_fast8 [phi:animate_init::memset_fast7_@1->animate_init::memset_fast8]
    // animate_init::memset_fast8
    // [153] phi from animate_init::memset_fast8 to animate_init::memset_fast8_@1 [phi:animate_init::memset_fast8->animate_init::memset_fast8_@1]
    // [153] phi animate_init::memset_fast8_num#2 = $80 [phi:animate_init::memset_fast8->animate_init::memset_fast8_@1#0] -- vbuxx=vbuc1 
    ldx #$80
    // [153] phi from animate_init::memset_fast8_@1 to animate_init::memset_fast8_@1 [phi:animate_init::memset_fast8_@1->animate_init::memset_fast8_@1]
    // [153] phi animate_init::memset_fast8_num#2 = animate_init::memset_fast8_num#1 [phi:animate_init::memset_fast8_@1->animate_init::memset_fast8_@1#0] -- register_copy 
    // animate_init::memset_fast8_@1
  memset_fast8___b1:
    // *(destination+num) = c
    // [154] animate_init::memset_fast8_destination#0[animate_init::memset_fast8_num#2] = animate_init::memset_fast8_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast8_c
    sta memset_fast8_destination,x
    // num--;
    // [155] animate_init::memset_fast8_num#1 = -- animate_init::memset_fast8_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [156] if(0!=animate_init::memset_fast8_num#1) goto animate_init::memset_fast8_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast8___b1
    // animate_init::@1
    // animate.pool = 0
    // [157] *((char *)&animate+$500) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta animate+$500
    // animate.used = 0
    // [158] *((char *)&animate+$501) = 0 -- _deref_pbuc1=vbuc2 
    sta animate+$501
    // animate_init::@return
    // }
    // [159] return 
    rts
}
  // rand
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
// __zp(3) unsigned int rand()
rand: {
    .label rand__0 = 3
    .label rand__1 = 3
    .label rand__2 = 3
    .label return = 3
    // rand_state << 7
    // [160] rand::$0 = rand_state << 7 -- vwuz1=vwuz2_rol_7 
    lda.z rand_state+1
    lsr
    lda.z rand_state
    ror
    sta.z rand__0+1
    lda #0
    ror
    sta.z rand__0
    // rand_state ^= rand_state << 7
    // [161] rand_state = rand_state ^ rand::$0 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z rand__0
    sta.z rand_state
    lda.z rand_state+1
    eor.z rand__0+1
    sta.z rand_state+1
    // rand_state >> 9
    // [162] rand::$1 = rand_state >> 9 -- vwuz1=vwuz2_ror_9 
    lsr
    sta.z rand__1
    lda #0
    sta.z rand__1+1
    // rand_state ^= rand_state >> 9
    // [163] rand_state = rand_state ^ rand::$1 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z rand__1
    sta.z rand_state
    lda.z rand_state+1
    eor.z rand__1+1
    sta.z rand_state+1
    // rand_state << 8
    // [164] rand::$2 = rand_state << 8 -- vwuz1=vwuz2_rol_8 
    lda.z rand_state
    sta.z rand__2+1
    lda #0
    sta.z rand__2
    // rand_state ^= rand_state << 8
    // [165] rand_state = rand_state ^ rand::$2 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z rand__2
    sta.z rand_state
    lda.z rand_state+1
    eor.z rand__2+1
    sta.z rand_state+1
    // return rand_state;
    // [166] rand::return#0 = rand_state -- vwuz1=vwuz2 
    lda.z rand_state
    sta.z return
    lda.z rand_state+1
    sta.z return+1
    // rand::@return
    // }
    // [167] return 
    rts
}
  // File Data
.segment Data
  // #include "equinoxe-stage.h"
  // #include "../src/equinoxe-flightengine.h"
  animate: .fill SIZEOF_STRUCT___5, 0
}
