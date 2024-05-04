  //
#importonce
  // File Comments
  // Library
.namespace equinoxe_animate {
  // Upstart
.cpu _65c02
#if !__asm_import__equinoxe_animate__
.file                               [name="equinoxe-animate.prg", type="prg", segments="Program"]
.file                               [name="STAGES.BIN",         type="bin", segments="CodeEngineStages, BramEngineStages"]
.file                               [name="PLAYERS.BIN",        type="bin", segments="CodeEnginePlayers"]
.file                               [name="BULLETS.BIN",        type="bin", segments="CodeEngineBullets"]
.file                               [name="ENEMIES.BIN",        type="bin", segments="CodeEngineEnemies"]
.file                               [name="TOWERS.BIN",         type="bin", segments="CodeEngineTowers"]
.file                               [name="BRAMFLIGHT1.BIN",    type="bin", segments="BramEngineFlight"]
.file                               [name="BRAMFLOOR1.BIN",     type="bin", segments="BramEngineFloor"]
.segmentdef Program                 [segments="Basic, Code, Data" + 
                                     ", CodeBramHeap" +
                                     ", CodeVeraHeap" +
                                     ", CodeLruCache" + 
                                     ", CodeEngineFloor" +
                                     ", CodeEngineAnimate" +
                                     ", CodeEngineFlight" +
                                     ", CodeEnginePalette" +
                                     ", DataBramHeap" +
                                     ", DataVeraHeap" +
                                     ", DataEngineFloor" +
                                     ", DataEngineAnimate" +
                                     ", DataEngineStages" +
                                     ", DataEngineBullets" +
                                     ", DataEnginePlayers" +
                                     ", DataEngineEnemies" +
                                     ", DataEngineFlight" +
                                     ", DataEnginePalette" +
//                                     ", BramEngineFloor" +
                                     ", DataSpriteCache"
                                     ]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=$80d]
.segmentdef CodeBramHeap            [startAfter="Code"] 
.segmentdef CodeVeraHeap            [startAfter="CodeBramHeap"] 
.segmentdef CodeLruCache            [startAfter="CodeVeraHeap"] 
.segmentdef CodeEngineFlight        [startAfter="CodeLruCache"] 
.segmentdef CodeEngineFloor         [startAfter="CodeEngineFlight"] 
.segmentdef CodeEngineAnimate       [startAfter="CodeEngineFloor"] 
.segmentdef CodeEnginePalette       [startAfter="CodeEngineAnimate"] 

.segmentdef Data                    [startAfter="CodeEnginePalette", align=$100]
.segmentdef DataBramHeap            [startAfter="Data"] 
.segmentdef DataVeraHeap            [startAfter="DataBramHeap"] 
.segmentdef DataEngineAnimate       [startAfter="DataVeraHeap"] 
.segmentdef DataEnginePalette       [startAfter="DataEngineAnimate"] 
.segmentdef DataEngineFloor         [startAfter="DataEnginePalette"] 
.segmentdef DataEngineStages        [startAfter="DataEngineFloor"]
.segmentdef DataEngineBullets       [startAfter="DataEngineStages"]
.segmentdef DataEnginePlayers       [startAfter="DataEngineBullets"]
.segmentdef DataEngineEnemies       [startAfter="DataEnginePlayers"]
.segmentdef DataEngineTowers        [startAfter="DataEngineEnemies"]
.segmentdef DataEngineFlight        [startAfter="DataEngineTowers", align=$100] 
.segmentdef DataSpriteCache         [startAfter="DataEngineFlight", align=$100]


//.segmentdef BramEngineFloor       [startAfter=""] 


.segmentdef Hash                    [start=$0400, min=$0400, max=$06FF, align=$100]

.segmentdef Debug                   [startAfter="Hash", align=$100]

.segmentdef BramBramHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef BramVeraHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]

//.segmentdef CodeVeraHeap            [startAfter="BramVeraHeap", min=$A000, max=$BFFF, align=$100] 
//.segmentdef DataVeraHeap            [startAfter="CodeVeraHeap", min=$A000, max=$BFFF, align=$100] 

.segmentdef CodeEngineStages        [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef BramEngineStages        [startAfter="CodeEngineStages", min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEnginePlayers       [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineBullets       [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineEnemies       [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineTowers        [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef BramEngineFloor         [start=$A000, min=$A000, align=$100]
.segmentdef BramEngineFlight        [start=$A000, min=$A000, max=$BF00, align=$100]
.segmentdef BramEnginePalette       [start=$A000, min=$A000, max=$BFFF, align=$100]

//.segmentdef CodeEngineFloor         [start=$A000, min=$A000, max=$BF00, align=$100]
//.segmentdef CodeEngineFlight        [start=$A000, min=$A000, max=$BFFF, align=$100]


.segment Basic
:BasicUpstart(__equinoxe_animate_start)
.segment Code
.segment CodeEngineFloor
.segment CodeEngineFlight
.segment CodeEngineStages
.segment CodeEngineBullets
.segment CodeEngineEnemies
.segment CodeEnginePlayers
.segment Data
.segment Code

#endif

  // Global Constants & labels
  .label OFFSET_STRUCT_ANIMATE_S_COUNT = $300
  .label OFFSET_STRUCT_ANIMATE_S_DIRECTION = $380
  .label OFFSET_STRUCT_ANIMATE_S_LOOP = $280
  .label OFFSET_STRUCT_ANIMATE_S_REVERSE = $400
  .label OFFSET_STRUCT_ANIMATE_S_SPEED = $200
  .label OFFSET_STRUCT_ANIMATE_S_STATE = $80
  .label OFFSET_STRUCT_ANIMATE_S_WAIT = $180
  .label OFFSET_STRUCT_ANIMATE_S_POOL = $500
  .label OFFSET_STRUCT_ANIMATE_S_USED = $501
  .label OFFSET_STRUCT_ANIMATE_S_IMAGE = $480
  .label OFFSET_STRUCT_ANIMATE_S_MOVED = $100
  .label SIZEOF_STRUCT_ANIMATE_S = $502
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __equinoxe_animate_start
// void __equinoxe_animate_start()
__equinoxe_animate_start: {
    // __equinoxe_animate_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __equinoxe_animate_start::@return
    // [3] return 
    rts
}
.segment CodeEngineAnimate
  // animate_tower
// void animate_tower(__mem() char a)
animate_tower: {
    // case 0:
    //             unsigned char rnd = (char)rand();
    //             if(rnd <= 5) animate.moved[a] = 1;
    //             break;
    // [4] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_tower::a]==0) goto animate_tower::@6 -- pbuc1_derefidx_vbum1_eq_0_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    cmp #0
    bne !__b6+
    jmp __b6
  !__b6:
    // animate_tower::@1
    // case 1:
    //             animate.wait[a] = 0;
    //             animate.moved[a] = 2;
    //             break;
    // [5] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_tower::a]==1) goto animate_tower::@7 -- pbuc1_derefidx_vbum1_eq_vbuc2_then_la1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
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
    // [6] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_tower::a]==2) goto animate_tower::@8 -- pbuc1_derefidx_vbum1_eq_vbuc2_then_la1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    cmp #2
    bne !__b8+
    jmp __b8
  !__b8:
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
    // [7] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_tower::a]==3) goto animate_tower::@9 -- pbuc1_derefidx_vbum1_eq_vbuc2_then_la1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    cmp #3
    beq __b9
    // animate_tower::@4
    // case 4:
    //             // Shot fired
    //             animate.moved[a] = 5;
    //             animate.wait[a] = 0;
    //             break;
    // [8] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_tower::a]==4) goto animate_tower::@10 -- pbuc1_derefidx_vbum1_eq_vbuc2_then_la1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
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
    // [9] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_tower::a]==5) goto animate_tower::@11 -- pbuc1_derefidx_vbum1_eq_vbuc2_then_la1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    cmp #5
    beq __b11
    // animate_tower::@12
  __b12:
    // animate.image[a] = animate.state[a]
    // [10] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_IMAGE)[animate_tower::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_tower::a] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    sta animate+OFFSET_STRUCT_ANIMATE_S_IMAGE,y
    // animate_tower::@return
    // }
    // [11] return 
    rts
    // animate_tower::@11
  __b11:
    // if(!animate.wait[a])
    // [12] if(0!=((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a]) goto animate_tower::@16 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    cmp #0
    bne __b16
    // animate_tower::@22
    // animate.wait[a] = animate.speed[a]
    // [13] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_SPEED)[animate_tower::a] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_SPEED,y
    sta animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    // if(animate.state[a] <= animate.loop[a])
    // [14] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_tower::a]<=((char *)&animate+OFFSET_STRUCT_ANIMATE_S_LOOP)[animate_tower::a]) goto animate_tower::@17 -- pbuc1_derefidx_vbum1_le_pbuc2_derefidx_vbum1_then_la1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_LOOP,y
    cmp animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    bcs __b17
    // animate_tower::@23
    // animate.state[a] -= 1
    // [15] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_tower::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_tower::a] - 1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_minus_1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    sec
    sbc #1
    sta animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    // animate_tower::@16
  __b16:
    // animate.wait[a]--;
    // [16] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a] = -- ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx a
    dec animate+OFFSET_STRUCT_ANIMATE_S_WAIT,x
    jmp __b12
    // animate_tower::@17
  __b17:
    // animate.moved[a] = 0
    // [17] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_tower::a] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy a
    sta animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    jmp __b16
    // animate_tower::@10
  __b10:
    // animate.moved[a] = 5
    // [18] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_tower::a] = 5 -- pbuc1_derefidx_vbum1=vbuc2 
    // Shot fired
    lda #5
    ldy a
    sta animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    // animate.wait[a] = 0
    // [19] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    jmp __b12
    // animate_tower::@9
  __b9:
    // if(!animate.wait[a])
    // [20] if(0==((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a]) goto animate_tower::@15 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    // Shoot
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    cmp #0
    beq __b15
    // animate_tower::@21
    // animate.wait[a]--;
    // [21] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a] = -- ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx a
    dec animate+OFFSET_STRUCT_ANIMATE_S_WAIT,x
    jmp __b12
    // animate_tower::@15
  __b15:
    // animate.wait[a] = 0
    // [22] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy a
    sta animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    // animate.moved[a] = 4
    // [23] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_tower::a] = 4 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #4
    sta animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    jmp __b12
    // animate_tower::@8
  __b8:
    // if(!animate.wait[a])
    // [24] if(0==((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a]) goto animate_tower::@13 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    cmp #0
    beq __b13
    // animate_tower::@19
    // animate.wait[a]--;
    // [25] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a] = -- ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx a
    dec animate+OFFSET_STRUCT_ANIMATE_S_WAIT,x
    jmp __b12
    // animate_tower::@13
  __b13:
    // animate.wait[a] = animate.speed[a]
    // [26] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_SPEED)[animate_tower::a] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_SPEED,y
    sta animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    // if(animate.state[a] == animate.count[a])
    // [27] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_tower::a]==((char *)&animate+OFFSET_STRUCT_ANIMATE_S_COUNT)[animate_tower::a]) goto animate_tower::@14 -- pbuc1_derefidx_vbum1_eq_pbuc2_derefidx_vbum1_then_la1 
    ldx a
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,x
    tay
    lda animate+OFFSET_STRUCT_ANIMATE_S_COUNT,x
    tax
    sty.z $ff
    cpx.z $ff
    beq __b14
    // animate_tower::@20
    // animate.state[a] += 1
    // [28] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_tower::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_tower::a] + 1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    inc
    sta animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    jmp __b12
    // animate_tower::@14
  __b14:
    // animate.wait[a] = 120
    // [29] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a] = $78 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #$78
    ldy a
    sta animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    // animate.moved[a] = 3
    // [30] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_tower::a] = 3 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #3
    sta animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    jmp __b12
    // animate_tower::@7
  __b7:
    // animate.wait[a] = 0
    // [31] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_tower::a] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy a
    sta animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    // animate.moved[a] = 2
    // [32] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_tower::a] = 2 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #2
    sta animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    jmp __b12
    // [33] phi from animate_tower to animate_tower::@6 [phi:animate_tower->animate_tower::@6]
    // animate_tower::@6
  __b6:
    // rand()
    // [34] call rand
    jsr rand
    // [35] rand::return#2 = rand::return#0
    // animate_tower::@24
    // [36] animate_tower::$0 = rand::return#2 -- vwum1=vwum2 
    lda rand.return
    sta animate_tower__0
    lda rand.return+1
    sta animate_tower__0+1
    // unsigned char rnd = (char)rand()
    // [37] animate_tower::rnd#0 = (char)animate_tower::$0 -- vbuaa=_byte_vwum1 
    lda animate_tower__0
    // if(rnd <= 5)
    // [38] if(animate_tower::rnd#0>=5+1) goto animate_tower::@12 -- vbuaa_ge_vbuc1_then_la1 
    cmp #5+1
    bcc !__b12+
    jmp __b12
  !__b12:
    // animate_tower::@18
    // animate.moved[a] = 1
    // [39] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_tower::a] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    ldy a
    sta animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    jmp __b12
  .segment DataEngineAnimate
    .label a = animate_get_image.return
    animate_tower__0: .word 0
}
.segment CodeEngineAnimate
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
// void animate_player(__mem() char a, __mem() int x, __mem() int px)
animate_player: {
    // if (!animate.wait[a])
    // [40] if(0!=((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_player::a]) goto animate_player::@1 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    cmp #0
    beq !__b1+
    jmp __b1
  !__b1:
    // animate_player::@2
    // animate.wait[a] = animate.speed[a]
    // [41] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_player::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_SPEED)[animate_player::a] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_SPEED,y
    sta animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    // if (x < px)
    // [42] if(animate_player::x>=animate_player::px) goto animate_player::@5 -- vwsm1_ge_vwsm2_then_la1 
    lda x
    cmp px
    lda x+1
    sbc px+1
    bvc !+
    eor #$80
  !:
    bpl __b5
    // animate_player::@3
    // if (animate.state[a] > 0)
    // [43] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a]<=0) goto animate_player::@6 -- pbuc1_derefidx_vbum1_le_0_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    cmp #0
    beq __b6
    // animate_player::@4
    // animate.state[a] -= 1
    // [44] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a] - 1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_minus_1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    sec
    sbc #1
    sta animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    // animate_player::@6
  __b6:
    // animate.moved[a] = 2
    // [45] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_player::a] = 2 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #2
    ldy a
    sta animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    // animate_player::@5
  __b5:
    // if (x > px)
    // [46] if(animate_player::x<=animate_player::px) goto animate_player::@7 -- vwsm1_le_vwsm2_then_la1 
    lda px
    cmp x
    lda px+1
    sbc x+1
    bvc !+
    eor #$80
  !:
    bpl __b7
    // animate_player::@17
    // if(animate.state[a] < 6)
    // [47] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a]>=6) goto animate_player::@8 -- pbuc1_derefidx_vbum1_ge_vbuc2_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    cmp #6
    bcs __b8
    // animate_player::@18
    // animate.state[a] += 1
    // [48] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a] + 1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    inc
    sta animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    // animate_player::@8
  __b8:
    // animate.moved[a] = 2
    // [49] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_player::a] = 2 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #2
    ldy a
    sta animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    // animate_player::@7
  __b7:
    // if (animate.moved[a] == 1)
    // [50] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_player::a]!=1) goto animate_player::@9 -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #1
    ldy a
    cmp animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    bne __b9
    // animate_player::@19
    // if (animate.state[a] < animate.loop[a])
    // [51] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a]>=((char *)&animate+OFFSET_STRUCT_ANIMATE_S_LOOP)[animate_player::a]) goto animate_player::@10 -- pbuc1_derefidx_vbum1_ge_pbuc2_derefidx_vbum1_then_la1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    cmp animate+OFFSET_STRUCT_ANIMATE_S_LOOP,y
    bcs __b10
    // animate_player::@20
    // animate.state[a] += 1
    // [52] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a] + 1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    inc
    sta animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    // animate_player::@10
  __b10:
    // if (animate.state[a] > animate.loop[a])
    // [53] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a]<=((char *)&animate+OFFSET_STRUCT_ANIMATE_S_LOOP)[animate_player::a]) goto animate_player::@11 -- pbuc1_derefidx_vbum1_le_pbuc2_derefidx_vbum1_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_LOOP,y
    cmp animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    bcs __b11
    // animate_player::@12
    // animate.state[a] -= 1
    // [54] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a] - 1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_minus_1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    sec
    sbc #1
    sta animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    // animate_player::@11
  __b11:
    // if (animate.state[a] == animate.loop[a])
    // [55] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a]!=((char *)&animate+OFFSET_STRUCT_ANIMATE_S_LOOP)[animate_player::a]) goto animate_player::@9 -- pbuc1_derefidx_vbum1_neq_pbuc2_derefidx_vbum1_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    cmp animate+OFFSET_STRUCT_ANIMATE_S_LOOP,y
    bne __b9
    // animate_player::@13
    // animate.moved[a] = 0
    // [56] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_player::a] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    // animate_player::@9
  __b9:
    // if (animate.moved[a] == 2)
    // [57] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_player::a]!=2) goto animate_player::@14 -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #2
    ldy a
    cmp animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    bne __b14
    // animate_player::@21
    // animate.moved[a]--;
    // [58] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_player::a] = -- ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_player::a] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx a
    dec animate+OFFSET_STRUCT_ANIMATE_S_MOVED,x
    // animate_player::@14
  __b14:
    // if(animate.moved[a] == 0)
    // [59] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_player::a]==0) goto animate_player::@15 -- pbuc1_derefidx_vbum1_eq_0_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    cmp #0
    beq __b15
    // animate_player::@22
    // if(animate.moved[a] == 1)
    // [60] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_player::a]!=1) goto animate_player::@1 -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #1
    cmp animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    bne __b1
    // animate_player::@23
    // (char)13 + animate.state[a]
    // [61] animate_player::$25 = $d + ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a] -- vbuaa=vbuc1_plus_pbuc2_derefidx_vbum1 
    lda #$d
    clc
    adc animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    // ((char)13 + animate.state[a]) % (char)16
    // [62] animate_player::$26 = animate_player::$25 & $10-1 -- vbuaa=vbuaa_band_vbuc1 
    and #$10-1
    // animate.image[a] = ((char)13 + animate.state[a]) % (char)16
    // [63] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_IMAGE)[animate_player::a] = animate_player::$26 -- pbuc1_derefidx_vbum1=vbuaa 
    sta animate+OFFSET_STRUCT_ANIMATE_S_IMAGE,y
    // animate_player::@1
  __b1:
    // animate.wait[a]--;
    // [64] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_player::a] = -- ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_player::a] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx a
    dec animate+OFFSET_STRUCT_ANIMATE_S_WAIT,x
    // animate_player::@return
    // }
    // [65] return 
    rts
    // animate_player::@15
  __b15:
    // if(animate.image[a] == 16)
    // [66] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_IMAGE)[animate_player::a]==$10) goto animate_player::@16 -- pbuc1_derefidx_vbum1_eq_vbuc2_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_IMAGE,y
    cmp #$10
    beq __b16
    // animate_player::@24
    // animate.image[a] = 16
    // [67] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_IMAGE)[animate_player::a] = $10 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #$10
    sta animate+OFFSET_STRUCT_ANIMATE_S_IMAGE,y
    jmp __b1
    // animate_player::@16
  __b16:
    // animate.state[a]-animate.loop[a]
    // [68] animate_player::$28 = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_player::a] - ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_LOOP)[animate_player::a] -- vbuaa=pbuc1_derefidx_vbum1_minus_pbuc2_derefidx_vbum1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    sec
    sbc animate+OFFSET_STRUCT_ANIMATE_S_LOOP,y
    // animate.image[a] = animate.state[a]-animate.loop[a]
    // [69] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_IMAGE)[animate_player::a] = animate_player::$28 -- pbuc1_derefidx_vbum1=vbuaa 
    sta animate+OFFSET_STRUCT_ANIMATE_S_IMAGE,y
    jmp __b1
  .segment DataEngineAnimate
    .label a = animate_get_image.return
    .label x = animate_tower.animate_tower__0
    px: .word 0
}
.segment CodeEngineAnimate
  // animate_logic
/**
 * @brief Main animation logic, for looping and reversing animations:
 * - Start loop from a start position.
 * - Loop when a loop position is reached.
 * - Two possible directions of looping.
 * - Possibly change direction and reverse.
 */
// void animate_logic(__mem() char a)
animate_logic: {
    // if (!animate.wait[a])
    // [70] if(0!=((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_logic::a]) goto animate_logic::@1 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    cmp #0
    bne __b1
    // animate_logic::@3
    // animate.wait[a] = animate.speed[a]
    // [71] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_logic::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_SPEED)[animate_logic::a] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_SPEED,y
    sta animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    // animate.state[a] += animate.direction[a]
    // [72] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_logic::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_logic::a] + ((signed char *)&animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION)[animate_logic::a] -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_pbsc2_derefidx_vbum1 
    ldx a
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,x
    ldy animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION,x
    sty.z $ff
    clc
    adc.z $ff
    sta animate+OFFSET_STRUCT_ANIMATE_S_STATE,x
    // if (animate.direction[a])
    // [73] if(0==((signed char *)&animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION)[animate_logic::a]) goto animate_logic::@1 -- 0_eq_pbsc1_derefidx_vbum1_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION,y
    cmp #0
    beq __b1
    // animate_logic::@4
    // if (animate.direction[a] > 0)
    // [74] if(((signed char *)&animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION)[animate_logic::a]<=0) goto animate_logic::@9 -- pbsc1_derefidx_vbum1_le_0_then_la1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION,y
    cmp #1
    bmi __b9
    // animate_logic::@5
    // if (animate.state[a] >= animate.count[a])
    // [75] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_logic::a]<((char *)&animate+OFFSET_STRUCT_ANIMATE_S_COUNT)[animate_logic::a]) goto animate_logic::@9 -- pbuc1_derefidx_vbum1_lt_pbuc2_derefidx_vbum1_then_la1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    cmp animate+OFFSET_STRUCT_ANIMATE_S_COUNT,y
    bcc __b9
    // animate_logic::@6
    // if (animate.reverse[a])
    // [76] if(0!=((char *)&animate+OFFSET_STRUCT_ANIMATE_S_REVERSE)[animate_logic::a]) goto animate_logic::@10 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_REVERSE,y
    cmp #0
    bne __b10
    // animate_logic::@7
    // animate.state[a] = animate.loop[a]
    // [77] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_logic::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_LOOP)[animate_logic::a] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_LOOP,y
    sta animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    // animate_logic::@9
  __b9:
    // if (animate.direction[a] < 0)
    // [78] if(((signed char *)&animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION)[animate_logic::a]>=0) goto animate_logic::@1 -- pbsc1_derefidx_vbum1_ge_0_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION,y
    cmp #0
    bpl __b1
    // animate_logic::@11
    // if (animate.state[a] <= animate.loop[a])
    // [79] if(((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_logic::a]>((char *)&animate+OFFSET_STRUCT_ANIMATE_S_LOOP)[animate_logic::a]) goto animate_logic::@1 -- pbuc1_derefidx_vbum1_gt_pbuc2_derefidx_vbum1_then_la1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_LOOP,y
    cmp animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    bcc __b1
    // animate_logic::@12
    // animate.direction[a] = 1
    // [80] ((signed char *)&animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION)[animate_logic::a] = 1 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #1
    sta animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION,y
    // animate_logic::@1
  __b1:
    // if (animate.speed[a])
    // [81] if(0==((char *)&animate+OFFSET_STRUCT_ANIMATE_S_SPEED)[animate_logic::a]) goto animate_logic::@2 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_SPEED,y
    cmp #0
    beq __b2
    // animate_logic::@8
    // animate.wait[a]--;
    // [82] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_logic::a] = -- ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_logic::a] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx a
    dec animate+OFFSET_STRUCT_ANIMATE_S_WAIT,x
    // animate_logic::@2
  __b2:
    // animate.image[a] = animate.state[a]
    // [83] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_IMAGE)[animate_logic::a] = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_logic::a] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_STATE,y
    sta animate+OFFSET_STRUCT_ANIMATE_S_IMAGE,y
    // animate_logic::@return
    // }
    // [84] return 
    rts
    // animate_logic::@10
  __b10:
    // animate.direction[a] = -1
    // [85] ((signed char *)&animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION)[animate_logic::a] = -1 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #-1
    ldy a
    sta animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION,y
    jmp __b9
  .segment DataEngineAnimate
    .label a = animate_get_image.return
}
.segment CodeEngineAnimate
  // animate_get_image
/**
 * @brief There is a decouplement between the state of the animation and the actual image projected.
 * This is handy when there are multiple transitions and multiple images to reflect those transitions
 * with high level of re-use of images.
 * This function is called when drawing, enquiring the animation state.
 */
// __mem() char animate_get_image(__mem() char a)
animate_get_image: {
    // return animate.image[a];
    // [86] animate_get_image::return = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_IMAGE)[animate_get_image::a] -- vbum1=pbuc1_derefidx_vbum2 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_IMAGE,y
    sta return
    // animate_get_image::@return
    // }
    // [87] return 
    rts
  .segment DataEngineAnimate
    .label a = animate_add.state
    return: .byte 0
}
.segment CodeEngineAnimate
  // animate_get_transition
/**
 * @brief Enquire the current state of transition of the animation.
 */
// __mem() char animate_get_transition(__mem() char a)
animate_get_transition: {
    // return animate.moved[a];
    // [88] animate_get_transition::return = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_get_transition::a] -- vbum1=pbuc1_derefidx_vbum2 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_MOVED,y
    sta return
    // animate_get_transition::@return
    // }
    // [89] return 
    rts
  .segment DataEngineAnimate
    .label a = animate_add.state
    .label return = animate_get_image.return
}
.segment CodeEngineAnimate
  // animate_is_waiting
// __mem() char animate_is_waiting(__mem() char a)
animate_is_waiting: {
    // return animate.wait[a];
    // [90] animate_is_waiting::return = ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_is_waiting::a] -- vbum1=pbuc1_derefidx_vbum2 
    ldy a
    lda animate+OFFSET_STRUCT_ANIMATE_S_WAIT,y
    sta return
    // animate_is_waiting::@return
    // }
    // [91] return 
    rts
  .segment DataEngineAnimate
    .label a = animate_add.state
    .label return = animate_get_image.return
}
.segment CodeEngineAnimate
  // animate_del
/**
 * @brief Delete the animation from the queue.
 */
// __mem() char animate_del(__mem() char a)
animate_del: {
    // animate.locked[a] = 0
    // [92] ((char *)&animate)[animate_del::a] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy a
    sta animate,y
    // animate.used--;
    // [93] *((char *)&animate+OFFSET_STRUCT_ANIMATE_S_USED) = -- *((char *)&animate+OFFSET_STRUCT_ANIMATE_S_USED) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec animate+OFFSET_STRUCT_ANIMATE_S_USED
    // return animate.used;
    // [94] animate_del::return = *((char *)&animate+OFFSET_STRUCT_ANIMATE_S_USED) -- vbum1=_deref_pbuc1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_USED
    sta return
    // animate_del::@return
    // }
    // [95] return 
    rts
  .segment DataEngineAnimate
    .label a = animate_get_image.return
    .label return = animate_get_image.return
}
.segment CodeEngineAnimate
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
// __mem() char animate_add(__mem() char count, __mem() char state, __mem() char loop, __mem() char speed, __mem() signed char direction, __mem() char reverse)
animate_add: {
    // if (animate.used < SPRITE_ANIMATE)
    // [96] if(*((char *)&animate+OFFSET_STRUCT_ANIMATE_S_USED)>=$80) goto animate_add::@1 -- _deref_pbuc1_ge_vbuc2_then_la1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_USED
    cmp #$80
    bcs __b1
    // animate_add::@2
  __b2:
    // while (animate.locked[animate.pool])
    // [97] if(0!=((char *)&animate)[*((char *)&animate+OFFSET_STRUCT_ANIMATE_S_POOL)]) goto animate_add::@3 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy animate+OFFSET_STRUCT_ANIMATE_S_POOL
    lda animate,y
    cmp #0
    bne __b3
    // animate_add::@4
    // char a = animate.pool
    // [98] animate_add::a#0 = *((char *)&animate+OFFSET_STRUCT_ANIMATE_S_POOL) -- vbuxx=_deref_pbuc1 
    ldx animate+OFFSET_STRUCT_ANIMATE_S_POOL
    // animate.locked[a] = 1
    // [99] ((char *)&animate)[animate_add::a#0] = 1 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #1
    sta animate,x
    // animate.wait[a] = 0
    // [100] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_WAIT)[animate_add::a#0] = 0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #0
    sta animate+OFFSET_STRUCT_ANIMATE_S_WAIT,x
    // animate.speed[a] = speed
    // [101] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_SPEED)[animate_add::a#0] = animate_add::speed -- pbuc1_derefidx_vbuxx=vbum1 
    lda speed
    sta animate+OFFSET_STRUCT_ANIMATE_S_SPEED,x
    // animate.reverse[a] = reverse
    // [102] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_REVERSE)[animate_add::a#0] = animate_add::reverse -- pbuc1_derefidx_vbuxx=vbum1 
    lda reverse
    sta animate+OFFSET_STRUCT_ANIMATE_S_REVERSE,x
    // animate.loop[a] = loop
    // [103] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_LOOP)[animate_add::a#0] = animate_add::loop -- pbuc1_derefidx_vbuxx=vbum1 
    lda loop
    sta animate+OFFSET_STRUCT_ANIMATE_S_LOOP,x
    // animate.count[a] = count
    // [104] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_COUNT)[animate_add::a#0] = animate_add::count -- pbuc1_derefidx_vbuxx=vbum1 
    lda count
    sta animate+OFFSET_STRUCT_ANIMATE_S_COUNT,x
    // animate.state[a] = state
    // [105] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_STATE)[animate_add::a#0] = animate_add::state -- pbuc1_derefidx_vbuxx=vbum1 
    lda state
    sta animate+OFFSET_STRUCT_ANIMATE_S_STATE,x
    // animate.direction[a] = direction
    // [106] ((signed char *)&animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION)[animate_add::a#0] = animate_add::direction -- pbsc1_derefidx_vbuxx=vbsm1 
    lda direction
    sta animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION,x
    // animate.image[a] = 0
    // [107] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_IMAGE)[animate_add::a#0] = 0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #0
    sta animate+OFFSET_STRUCT_ANIMATE_S_IMAGE,x
    // animate.moved[a] = 0
    // [108] ((char *)&animate+OFFSET_STRUCT_ANIMATE_S_MOVED)[animate_add::a#0] = 0 -- pbuc1_derefidx_vbuxx=vbuc2 
    sta animate+OFFSET_STRUCT_ANIMATE_S_MOVED,x
    // animate.used++;
    // [109] *((char *)&animate+OFFSET_STRUCT_ANIMATE_S_USED) = ++ *((char *)&animate+OFFSET_STRUCT_ANIMATE_S_USED) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc animate+OFFSET_STRUCT_ANIMATE_S_USED
    // animate_add::@1
  __b1:
    // return animate.pool;
    // [110] animate_add::return = *((char *)&animate+OFFSET_STRUCT_ANIMATE_S_POOL) -- vbum1=_deref_pbuc1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_POOL
    sta return
    // animate_add::@return
    // }
    // [111] return 
    rts
    // animate_add::@3
  __b3:
    // animate.pool + 1
    // [112] animate_add::$2 = *((char *)&animate+OFFSET_STRUCT_ANIMATE_S_POOL) + 1 -- vbuaa=_deref_pbuc1_plus_1 
    lda animate+OFFSET_STRUCT_ANIMATE_S_POOL
    inc
    // (animate.pool + 1) % SPRITE_ANIMATE
    // [113] animate_add::$3 = animate_add::$2 & $80-1 -- vbuaa=vbuaa_band_vbuc1 
    and #$80-1
    // animate.pool = (animate.pool + 1) % SPRITE_ANIMATE
    // [114] *((char *)&animate+OFFSET_STRUCT_ANIMATE_S_POOL) = animate_add::$3 -- _deref_pbuc1=vbuaa 
    sta animate+OFFSET_STRUCT_ANIMATE_S_POOL
    jmp __b2
  .segment DataEngineAnimate
    .label count = animate_get_image.return
    state: .byte 0
    loop: .byte 0
    speed: .byte 0
    direction: .byte 0
    reverse: .byte 0
    .label return = animate_get_image.return
}
.segment CodeEngineAnimate
  // animate_init
// void animate_init()
animate_init: {
    .const memset_fast1_ch = 0
    .const memset_fast2_ch = 0
    .const memset_fast3_ch = 0
    .const memset_fast4_ch = 0
    .const memset_fast5_ch = 0
    .const memset_fast6_ch = 0
    .const memset_fast7_ch = 0
    .const memset_fast8_ch = 0
    .label memset_fast1_destination = animate+OFFSET_STRUCT_ANIMATE_S_COUNT
    .label memset_fast2_destination = animate+OFFSET_STRUCT_ANIMATE_S_DIRECTION
    .label memset_fast3_destination = animate+OFFSET_STRUCT_ANIMATE_S_LOOP
    .label memset_fast4_destination = animate+OFFSET_STRUCT_ANIMATE_S_REVERSE
    .label memset_fast5_destination = animate+OFFSET_STRUCT_ANIMATE_S_SPEED
    .label memset_fast6_destination = animate+OFFSET_STRUCT_ANIMATE_S_STATE
    .label memset_fast7_destination = animate
    .label memset_fast8_destination = animate+OFFSET_STRUCT_ANIMATE_S_WAIT
    // [116] phi from animate_init to animate_init::memset_fast1 [phi:animate_init->animate_init::memset_fast1]
    // animate_init::memset_fast1
    // [117] phi from animate_init::memset_fast1 to animate_init::memset_fast1_@1 [phi:animate_init::memset_fast1->animate_init::memset_fast1_@1]
    // [117] phi animate_init::memset_fast1_num#2 = $80 [phi:animate_init::memset_fast1->animate_init::memset_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #$80
    // [117] phi animate_init::memset_fast1_x#2 = 0 [phi:animate_init::memset_fast1->animate_init::memset_fast1_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [117] phi from animate_init::memset_fast1_@1 to animate_init::memset_fast1_@1 [phi:animate_init::memset_fast1_@1->animate_init::memset_fast1_@1]
    // [117] phi animate_init::memset_fast1_num#2 = animate_init::memset_fast1_num#1 [phi:animate_init::memset_fast1_@1->animate_init::memset_fast1_@1#0] -- register_copy 
    // [117] phi animate_init::memset_fast1_x#2 = animate_init::memset_fast1_x#1 [phi:animate_init::memset_fast1_@1->animate_init::memset_fast1_@1#1] -- register_copy 
    // animate_init::memset_fast1_@1
  memset_fast1___b1:
    // destination[x] = ch
    // [118] animate_init::memset_fast1_destination#0[animate_init::memset_fast1_x#2] = animate_init::memset_fast1_ch#0 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #memset_fast1_ch
    sta memset_fast1_destination,y
    // x++;
    // [119] animate_init::memset_fast1_x#1 = ++ animate_init::memset_fast1_x#2 -- vbuyy=_inc_vbuyy 
    iny
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
    // [123] phi animate_init::memset_fast2_x#2 = 0 [phi:animate_init::memset_fast2->animate_init::memset_fast2_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [123] phi from animate_init::memset_fast2_@1 to animate_init::memset_fast2_@1 [phi:animate_init::memset_fast2_@1->animate_init::memset_fast2_@1]
    // [123] phi animate_init::memset_fast2_num#2 = animate_init::memset_fast2_num#1 [phi:animate_init::memset_fast2_@1->animate_init::memset_fast2_@1#0] -- register_copy 
    // [123] phi animate_init::memset_fast2_x#2 = animate_init::memset_fast2_x#1 [phi:animate_init::memset_fast2_@1->animate_init::memset_fast2_@1#1] -- register_copy 
    // animate_init::memset_fast2_@1
  memset_fast2___b1:
    // destination[x] = ch
    // [124] animate_init::memset_fast2_destination#0[animate_init::memset_fast2_x#2] = animate_init::memset_fast2_ch#0 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #memset_fast2_ch
    sta memset_fast2_destination,y
    // x++;
    // [125] animate_init::memset_fast2_x#1 = ++ animate_init::memset_fast2_x#2 -- vbuyy=_inc_vbuyy 
    iny
    // num--;
    // [126] animate_init::memset_fast2_num#1 = -- animate_init::memset_fast2_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [127] if(0!=animate_init::memset_fast2_num#1) goto animate_init::memset_fast2_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast2___b1
    // [128] phi from animate_init::memset_fast2_@1 to animate_init::memset_fast3 [phi:animate_init::memset_fast2_@1->animate_init::memset_fast3]
    // animate_init::memset_fast3
    // [129] phi from animate_init::memset_fast3 to animate_init::memset_fast3_@1 [phi:animate_init::memset_fast3->animate_init::memset_fast3_@1]
    // [129] phi animate_init::memset_fast3_num#2 = $80 [phi:animate_init::memset_fast3->animate_init::memset_fast3_@1#0] -- vbuyy=vbuc1 
    ldy #$80
    // [129] phi animate_init::memset_fast3_x#2 = 0 [phi:animate_init::memset_fast3->animate_init::memset_fast3_@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [129] phi from animate_init::memset_fast3_@1 to animate_init::memset_fast3_@1 [phi:animate_init::memset_fast3_@1->animate_init::memset_fast3_@1]
    // [129] phi animate_init::memset_fast3_num#2 = animate_init::memset_fast3_num#1 [phi:animate_init::memset_fast3_@1->animate_init::memset_fast3_@1#0] -- register_copy 
    // [129] phi animate_init::memset_fast3_x#2 = animate_init::memset_fast3_x#1 [phi:animate_init::memset_fast3_@1->animate_init::memset_fast3_@1#1] -- register_copy 
    // animate_init::memset_fast3_@1
  memset_fast3___b1:
    // destination[x] = ch
    // [130] animate_init::memset_fast3_destination#0[animate_init::memset_fast3_x#2] = animate_init::memset_fast3_ch#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast3_ch
    sta memset_fast3_destination,x
    // x++;
    // [131] animate_init::memset_fast3_x#1 = ++ animate_init::memset_fast3_x#2 -- vbuxx=_inc_vbuxx 
    inx
    // num--;
    // [132] animate_init::memset_fast3_num#1 = -- animate_init::memset_fast3_num#2 -- vbuyy=_dec_vbuyy 
    dey
    // while(num)
    // [133] if(0!=animate_init::memset_fast3_num#1) goto animate_init::memset_fast3_@1 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne memset_fast3___b1
    // [134] phi from animate_init::memset_fast3_@1 to animate_init::memset_fast4 [phi:animate_init::memset_fast3_@1->animate_init::memset_fast4]
    // animate_init::memset_fast4
    // [135] phi from animate_init::memset_fast4 to animate_init::memset_fast4_@1 [phi:animate_init::memset_fast4->animate_init::memset_fast4_@1]
    // [135] phi animate_init::memset_fast4_num#2 = $80 [phi:animate_init::memset_fast4->animate_init::memset_fast4_@1#0] -- vbuyy=vbuc1 
    ldy #$80
    // [135] phi animate_init::memset_fast4_x#2 = 0 [phi:animate_init::memset_fast4->animate_init::memset_fast4_@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [135] phi from animate_init::memset_fast4_@1 to animate_init::memset_fast4_@1 [phi:animate_init::memset_fast4_@1->animate_init::memset_fast4_@1]
    // [135] phi animate_init::memset_fast4_num#2 = animate_init::memset_fast4_num#1 [phi:animate_init::memset_fast4_@1->animate_init::memset_fast4_@1#0] -- register_copy 
    // [135] phi animate_init::memset_fast4_x#2 = animate_init::memset_fast4_x#1 [phi:animate_init::memset_fast4_@1->animate_init::memset_fast4_@1#1] -- register_copy 
    // animate_init::memset_fast4_@1
  memset_fast4___b1:
    // destination[x] = ch
    // [136] animate_init::memset_fast4_destination#0[animate_init::memset_fast4_x#2] = animate_init::memset_fast4_ch#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast4_ch
    sta memset_fast4_destination,x
    // x++;
    // [137] animate_init::memset_fast4_x#1 = ++ animate_init::memset_fast4_x#2 -- vbuxx=_inc_vbuxx 
    inx
    // num--;
    // [138] animate_init::memset_fast4_num#1 = -- animate_init::memset_fast4_num#2 -- vbuyy=_dec_vbuyy 
    dey
    // while(num)
    // [139] if(0!=animate_init::memset_fast4_num#1) goto animate_init::memset_fast4_@1 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne memset_fast4___b1
    // [140] phi from animate_init::memset_fast4_@1 to animate_init::memset_fast5 [phi:animate_init::memset_fast4_@1->animate_init::memset_fast5]
    // animate_init::memset_fast5
    // [141] phi from animate_init::memset_fast5 to animate_init::memset_fast5_@1 [phi:animate_init::memset_fast5->animate_init::memset_fast5_@1]
    // [141] phi animate_init::memset_fast5_num#2 = $80 [phi:animate_init::memset_fast5->animate_init::memset_fast5_@1#0] -- vbuyy=vbuc1 
    ldy #$80
    // [141] phi animate_init::memset_fast5_x#2 = 0 [phi:animate_init::memset_fast5->animate_init::memset_fast5_@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [141] phi from animate_init::memset_fast5_@1 to animate_init::memset_fast5_@1 [phi:animate_init::memset_fast5_@1->animate_init::memset_fast5_@1]
    // [141] phi animate_init::memset_fast5_num#2 = animate_init::memset_fast5_num#1 [phi:animate_init::memset_fast5_@1->animate_init::memset_fast5_@1#0] -- register_copy 
    // [141] phi animate_init::memset_fast5_x#2 = animate_init::memset_fast5_x#1 [phi:animate_init::memset_fast5_@1->animate_init::memset_fast5_@1#1] -- register_copy 
    // animate_init::memset_fast5_@1
  memset_fast5___b1:
    // destination[x] = ch
    // [142] animate_init::memset_fast5_destination#0[animate_init::memset_fast5_x#2] = animate_init::memset_fast5_ch#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast5_ch
    sta memset_fast5_destination,x
    // x++;
    // [143] animate_init::memset_fast5_x#1 = ++ animate_init::memset_fast5_x#2 -- vbuxx=_inc_vbuxx 
    inx
    // num--;
    // [144] animate_init::memset_fast5_num#1 = -- animate_init::memset_fast5_num#2 -- vbuyy=_dec_vbuyy 
    dey
    // while(num)
    // [145] if(0!=animate_init::memset_fast5_num#1) goto animate_init::memset_fast5_@1 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne memset_fast5___b1
    // [146] phi from animate_init::memset_fast5_@1 to animate_init::memset_fast6 [phi:animate_init::memset_fast5_@1->animate_init::memset_fast6]
    // animate_init::memset_fast6
    // [147] phi from animate_init::memset_fast6 to animate_init::memset_fast6_@1 [phi:animate_init::memset_fast6->animate_init::memset_fast6_@1]
    // [147] phi animate_init::memset_fast6_num#2 = $80 [phi:animate_init::memset_fast6->animate_init::memset_fast6_@1#0] -- vbuyy=vbuc1 
    ldy #$80
    // [147] phi animate_init::memset_fast6_x#2 = 0 [phi:animate_init::memset_fast6->animate_init::memset_fast6_@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [147] phi from animate_init::memset_fast6_@1 to animate_init::memset_fast6_@1 [phi:animate_init::memset_fast6_@1->animate_init::memset_fast6_@1]
    // [147] phi animate_init::memset_fast6_num#2 = animate_init::memset_fast6_num#1 [phi:animate_init::memset_fast6_@1->animate_init::memset_fast6_@1#0] -- register_copy 
    // [147] phi animate_init::memset_fast6_x#2 = animate_init::memset_fast6_x#1 [phi:animate_init::memset_fast6_@1->animate_init::memset_fast6_@1#1] -- register_copy 
    // animate_init::memset_fast6_@1
  memset_fast6___b1:
    // destination[x] = ch
    // [148] animate_init::memset_fast6_destination#0[animate_init::memset_fast6_x#2] = animate_init::memset_fast6_ch#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast6_ch
    sta memset_fast6_destination,x
    // x++;
    // [149] animate_init::memset_fast6_x#1 = ++ animate_init::memset_fast6_x#2 -- vbuxx=_inc_vbuxx 
    inx
    // num--;
    // [150] animate_init::memset_fast6_num#1 = -- animate_init::memset_fast6_num#2 -- vbuyy=_dec_vbuyy 
    dey
    // while(num)
    // [151] if(0!=animate_init::memset_fast6_num#1) goto animate_init::memset_fast6_@1 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne memset_fast6___b1
    // [152] phi from animate_init::memset_fast6_@1 to animate_init::memset_fast7 [phi:animate_init::memset_fast6_@1->animate_init::memset_fast7]
    // animate_init::memset_fast7
    // [153] phi from animate_init::memset_fast7 to animate_init::memset_fast7_@1 [phi:animate_init::memset_fast7->animate_init::memset_fast7_@1]
    // [153] phi animate_init::memset_fast7_num#2 = $80 [phi:animate_init::memset_fast7->animate_init::memset_fast7_@1#0] -- vbuyy=vbuc1 
    ldy #$80
    // [153] phi animate_init::memset_fast7_x#2 = 0 [phi:animate_init::memset_fast7->animate_init::memset_fast7_@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [153] phi from animate_init::memset_fast7_@1 to animate_init::memset_fast7_@1 [phi:animate_init::memset_fast7_@1->animate_init::memset_fast7_@1]
    // [153] phi animate_init::memset_fast7_num#2 = animate_init::memset_fast7_num#1 [phi:animate_init::memset_fast7_@1->animate_init::memset_fast7_@1#0] -- register_copy 
    // [153] phi animate_init::memset_fast7_x#2 = animate_init::memset_fast7_x#1 [phi:animate_init::memset_fast7_@1->animate_init::memset_fast7_@1#1] -- register_copy 
    // animate_init::memset_fast7_@1
  memset_fast7___b1:
    // destination[x] = ch
    // [154] animate_init::memset_fast7_destination#0[animate_init::memset_fast7_x#2] = animate_init::memset_fast7_ch#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast7_ch
    sta memset_fast7_destination,x
    // x++;
    // [155] animate_init::memset_fast7_x#1 = ++ animate_init::memset_fast7_x#2 -- vbuxx=_inc_vbuxx 
    inx
    // num--;
    // [156] animate_init::memset_fast7_num#1 = -- animate_init::memset_fast7_num#2 -- vbuyy=_dec_vbuyy 
    dey
    // while(num)
    // [157] if(0!=animate_init::memset_fast7_num#1) goto animate_init::memset_fast7_@1 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne memset_fast7___b1
    // [158] phi from animate_init::memset_fast7_@1 to animate_init::memset_fast8 [phi:animate_init::memset_fast7_@1->animate_init::memset_fast8]
    // animate_init::memset_fast8
    // [159] phi from animate_init::memset_fast8 to animate_init::memset_fast8_@1 [phi:animate_init::memset_fast8->animate_init::memset_fast8_@1]
    // [159] phi animate_init::memset_fast8_num#2 = $80 [phi:animate_init::memset_fast8->animate_init::memset_fast8_@1#0] -- vbuyy=vbuc1 
    ldy #$80
    // [159] phi animate_init::memset_fast8_x#2 = 0 [phi:animate_init::memset_fast8->animate_init::memset_fast8_@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [159] phi from animate_init::memset_fast8_@1 to animate_init::memset_fast8_@1 [phi:animate_init::memset_fast8_@1->animate_init::memset_fast8_@1]
    // [159] phi animate_init::memset_fast8_num#2 = animate_init::memset_fast8_num#1 [phi:animate_init::memset_fast8_@1->animate_init::memset_fast8_@1#0] -- register_copy 
    // [159] phi animate_init::memset_fast8_x#2 = animate_init::memset_fast8_x#1 [phi:animate_init::memset_fast8_@1->animate_init::memset_fast8_@1#1] -- register_copy 
    // animate_init::memset_fast8_@1
  memset_fast8___b1:
    // destination[x] = ch
    // [160] animate_init::memset_fast8_destination#0[animate_init::memset_fast8_x#2] = animate_init::memset_fast8_ch#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast8_ch
    sta memset_fast8_destination,x
    // x++;
    // [161] animate_init::memset_fast8_x#1 = ++ animate_init::memset_fast8_x#2 -- vbuxx=_inc_vbuxx 
    inx
    // num--;
    // [162] animate_init::memset_fast8_num#1 = -- animate_init::memset_fast8_num#2 -- vbuyy=_dec_vbuyy 
    dey
    // while(num)
    // [163] if(0!=animate_init::memset_fast8_num#1) goto animate_init::memset_fast8_@1 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne memset_fast8___b1
    // animate_init::@1
    // animate.pool = 0
    // [164] *((char *)&animate+OFFSET_STRUCT_ANIMATE_S_POOL) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta animate+OFFSET_STRUCT_ANIMATE_S_POOL
    // animate.used = 0
    // [165] *((char *)&animate+OFFSET_STRUCT_ANIMATE_S_USED) = 0 -- _deref_pbuc1=vbuc2 
    sta animate+OFFSET_STRUCT_ANIMATE_S_USED
    // animate_init::@return
    // }
    // [166] return 
    rts
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
    // [167] rand::$0 = rand_state << 7 -- vwum1=vwum2_rol_7 
    lda rand_state+1
    lsr
    lda rand_state
    ror
    sta rand__0+1
    lda #0
    ror
    sta rand__0
    // rand_state ^= rand_state << 7
    // [168] rand_state = rand_state ^ rand::$0 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__0
    sta rand_state
    lda rand_state+1
    eor rand__0+1
    sta rand_state+1
    // rand_state >> 9
    // [169] rand::$1 = rand_state >> 9 -- vwum1=vwum2_ror_9 
    lsr
    sta rand__1
    lda #0
    sta rand__1+1
    // rand_state ^= rand_state >> 9
    // [170] rand_state = rand_state ^ rand::$1 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__1
    sta rand_state
    lda rand_state+1
    eor rand__1+1
    sta rand_state+1
    // rand_state << 8
    // [171] rand::$2 = rand_state << 8 -- vwum1=vwum2_rol_8 
    lda rand_state
    sta rand__2+1
    lda #0
    sta rand__2
    // rand_state ^= rand_state << 8
    // [172] rand_state = rand_state ^ rand::$2 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__2
    sta rand_state
    lda rand_state+1
    eor rand__2+1
    sta rand_state+1
    // return rand_state;
    // [173] rand::return#0 = rand_state -- vwum1=vwum2 
    lda rand_state
    sta return
    lda rand_state+1
    sta return+1
    // rand::@return
    // }
    // [174] return 
    rts
  .segment Data
    .label rand__0 = return
    .label rand__1 = return
    .label rand__2 = return
    return: .word 0
}
  // Exported Global Data
  // The random state variable
  rand_state: .word 1
.segment DataEngineAnimate
  animate: .fill equinoxe_animate.SIZEOF_STRUCT_ANIMATE_S, 0
} // namespace
