  //
#importonce
  // File Comments
  // Library
.namespace equinoxe_enemy {
  // Upstart
.cpu _65c02
#if !__asm_import__equinoxe_enemy__
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

#endif

  // Global Constants & labels
  .label STAGE_ACTION_MOVE = 2
  .label STAGE_ACTION_TURN = 3
  .label STAGE_ACTION_END = $ff
  .label OFFSET_STRUCT_FLIGHT_T_XF = $280
  .label OFFSET_STRUCT_FLIGHT_T_YF = $2c0
  .label OFFSET_STRUCT_FLIGHT_T_XI = $300
  .label OFFSET_STRUCT_FLIGHT_T_YI = $380
  .label OFFSET_STRUCT_FLIGHT_T_XD = $400
  .label OFFSET_STRUCT_FLIGHT_T_YD = $480
  .label OFFSET_STRUCT_FLIGHT_T_WAVE = $a01
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT = $20
  .label OFFSET_STRUCT_WAVE_T_ANIMATION_SPEED = $98
  .label OFFSET_STRUCT_WAVE_T_ANIMATION_REVERSE = $a0
  .label OFFSET_STRUCT_FLIGHT_T_ANIMATE = $900
  .label OFFSET_STRUCT_FLIGHT_T_HEALTH = $880
  .label OFFSET_STRUCT_FLIGHT_T_IMPACT = $8c0
  .label OFFSET_STRUCT_WAVE_T_ENEMY_FLIGHTPATH = $18
  .label OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH = $980
  .label OFFSET_STRUCT_WAVE_T_X = $30
  .label OFFSET_STRUCT_WAVE_T_Y = $40
  .label OFFSET_STRUCT_FLIGHT_T_MOVE = $580
  .label OFFSET_STRUCT_FLIGHT_T_MOVING = $600
  .label OFFSET_STRUCT_FLIGHT_T_ANGLE = $780
  .label OFFSET_STRUCT_FLIGHT_T_SPEED = $7c0
  .label OFFSET_STRUCT_FLIGHT_T_TURN = $800
  .label OFFSET_STRUCT_FLIGHT_T_RADIUS = $840
  .label OFFSET_STRUCT_FLIGHT_T_DELAY = $680
  .label OFFSET_STRUCT_FLIGHT_T_TYPE = $180
  .label OFFSET_STRUCT_FLIGHT_T_USED = $c0
  .label OFFSET_STRUCT_FLIGHT_T_ACTION = $940
  .label OFFSET_STRUCT_FLIGHT_T_RELOAD = $740
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __equinoxe_enemy_start
// void __equinoxe_enemy_start()
__equinoxe_enemy_start: {
    // __equinoxe_enemy_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __equinoxe_enemy_start::@return
    // [3] return 
    rts
}
.segment CodeEngineEnemies
  // enemy_get_wave
// __mem() char enemy_get_wave(__mem() char e)
// __bank(cx16_ram, 8) 
enemy_get_wave: {
    // return flight.wave[e];
    // [4] enemy_get_wave::return = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_WAVE)[enemy_get_wave::e] -- vbum1=pbuc1_derefidx_vbum2 
    ldy e
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_WAVE,y
    sta return
    // enemy_get_wave::@return
    // }
    // [5] return 
    rts
  .segment Data
    .label e = equinoxe_enemy.enemy_arc.turn
    return: .byte 0
}
.segment CodeEngineEnemies
  // enemy_logic
// void enemy_logic()
// __bank(cx16_ram, 8) 
enemy_logic: {
    .label xf = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XF
    .label yf = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YF
    .label xi = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI
    .label yi = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI
    .label xd = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD
    .label yd = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD
    .label enemy_flightpath = $32
    .label action = $3a
    .label math_vecx1_return = $2f
    .label math_vecy1_return = $2f
    .label math_vecx2_return = $2f
    .label math_vecy2_return = $2f
    // flight_index_t e = flight_root(FLIGHT_ENEMY)
    // [6] flight_root::type = 1 -- vbum1=vbuc1 
    lda #1
    sta equinoxe_flightengine.flight_root.type
    // [7] callexecute flight_root  -- call_var_near 
    jsr equinoxe_flightengine.flight_root
    // [8] enemy_logic::e#0 = flight_root::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_root.return
    sta e
    // [9] phi from enemy_logic enemy_logic::@12 enemy_logic::@3 to enemy_logic::@1 [phi:enemy_logic/enemy_logic::@12/enemy_logic::@3->enemy_logic::@1]
    // [9] phi enemy_logic::e#10 = enemy_logic::e#0 [phi:enemy_logic/enemy_logic::@12/enemy_logic::@3->enemy_logic::@1#0] -- register_copy 
    // enemy_logic::@1
  __b1:
    // while(e)
    // [10] if(0!=enemy_logic::e#10) goto enemy_logic::@2 -- 0_neq_vbum1_then_la1 
    lda e
    bne __b2
    // enemy_logic::@return
    // }
    // [11] return 
    rts
    // enemy_logic::@2
  __b2:
    // flight_index_t en = flight_next(e)
    // [12] flight_next::i = enemy_logic::e#10 -- vbum1=vbum2 
    lda e
    sta equinoxe_flightengine.flight_next.i
    // [13] callexecute flight_next  -- call_var_near 
    jsr equinoxe_flightengine.flight_next
    // [14] enemy_logic::e#1 = flight_next::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_next.return
    sta e_1
    // if(flight.type[e] == FLIGHT_ENEMY && flight.used[e])
    // [15] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[enemy_logic::e#10]!=1) goto enemy_logic::@3 -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #1
    ldy e
    cmp equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    bne __b3
    // enemy_logic::@28
    // [16] if(0!=((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[enemy_logic::e#10]) goto enemy_logic::@19 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    bne __b19
    // enemy_logic::@3
  __b3:
    // [17] enemy_logic::e#46 = enemy_logic::e#1 -- vbum1=vbum2 
    lda e_1
    sta e
    jmp __b1
    // enemy_logic::@19
  __b19:
    // !flight.moving[e]
    // [18] enemy_logic::$40 = enemy_logic::e#10 << 1 -- vbum1=vbum2_rol_1 
    lda e
    asl
    sta enemy_logic__40
    // if(!flight.moving[e])
    // [19] if(0==((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVING)[enemy_logic::$40]) goto enemy_logic::@4 -- 0_eq_pwuc1_derefidx_vbum1_then_la1 
    tay
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING,y
    ora equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING+1,y
    bne !__b4+
    jmp __b4
  !__b4:
    // enemy_logic::@20
    // flight.moving[e]--;
    // [20] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVING)[enemy_logic::$40] = -- ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVING)[enemy_logic::$40] -- pwuc1_derefidx_vbum1=_dec_pwuc1_derefidx_vbum1 
    ldx enemy_logic__40
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING,x
    bne !+
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING+1,x
  !:
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING,x
    // if( flight.move[e])
    // [21] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[enemy_logic::e#10]) goto enemy_logic::@9 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy e
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    cmp #0
    bne !__b9+
    jmp __b9
  !__b9:
    // enemy_logic::@21
    // if(flight.move[e] == 1)
    // [22] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[enemy_logic::e#10]!=1) goto enemy_logic::@5 -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #1
    cmp equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    beq !__b5+
    jmp __b5
  !__b5:
    // enemy_logic::@22
    // math_vecx(flight.angle[e], flight.speed[e])
    // [23] enemy_logic::math_vecx1_angle#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // [24] enemy_logic::math_vecx1_speed#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[enemy_logic::e#10] -- vbum1=pbuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    sta math_vecx1_speed
    // enemy_logic::math_vecx1
    // if (speed)
    // [25] if(0==enemy_logic::math_vecx1_speed#0) goto enemy_logic::math_vecx1_@1 -- 0_eq_vbum1_then_la1 
    beq __b7
    // enemy_logic::math_vecx1_@2
    // angle % 64
    // [26] enemy_logic::math_vecx1_$1 = enemy_logic::math_vecx1_angle#0 & $40-1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #$40-1
    // dx = math_cos[angle % 64]
    // [27] enemy_logic::math_vecx1_$2 = enemy_logic::math_vecx1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [28] enemy_logic::math_vecx1_dx#1 = math_cos[enemy_logic::math_vecx1_$2] -- vwsm1=pwsc1_derefidx_vbuaa 
    tay
    lda math_cos,y
    sta math_vecx1_dx
    lda math_cos+1,y
    sta math_vecx1_dx+1
    // dx <<= speed
    // [29] enemy_logic::math_vecx1_dx#2 = enemy_logic::math_vecx1_dx#1 << enemy_logic::math_vecx1_speed#0 -- vwsm1=vwsm1_rol_vbum2 
    ldy math_vecx1_speed
    beq !e+
  !:
    asl math_vecx1_dx
    rol math_vecx1_dx+1
    dey
    bne !-
  !e:
    // [30] phi from enemy_logic::math_vecx1_@2 to enemy_logic::math_vecx1_@1 [phi:enemy_logic::math_vecx1_@2->enemy_logic::math_vecx1_@1]
    // [30] phi enemy_logic::math_vecx1_return#0 = enemy_logic::math_vecx1_dx#2 [phi:enemy_logic::math_vecx1_@2->enemy_logic::math_vecx1_@1#0] -- vwsz1=vwsm2 
    lda math_vecx1_dx
    sta.z math_vecx1_return
    lda math_vecx1_dx+1
    sta.z math_vecx1_return+1
    jmp __b23
    // [30] phi from enemy_logic::math_vecx1 to enemy_logic::math_vecx1_@1 [phi:enemy_logic::math_vecx1->enemy_logic::math_vecx1_@1]
  __b7:
    // [30] phi enemy_logic::math_vecx1_return#0 = 0 [phi:enemy_logic::math_vecx1->enemy_logic::math_vecx1_@1#0] -- vwsz1=vwsc1 
    lda #<0
    sta.z math_vecx1_return
    sta.z math_vecx1_return+1
    // enemy_logic::math_vecx1_@1
    // enemy_logic::@23
  __b23:
    // flight.xd[e] = (unsigned int)math_vecx(flight.angle[e], flight.speed[e])
    // [31] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XD)[enemy_logic::$40] = (unsigned int)enemy_logic::math_vecx1_return#0 -- pwuc1_derefidx_vbum1=vwuz2 
    ldy enemy_logic__40
    lda.z math_vecx1_return
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD,y
    lda.z math_vecx1_return+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD+1,y
    // math_vecy(flight.angle[e], flight.speed[e])
    // [32] enemy_logic::math_vecy1_angle#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy e
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // [33] enemy_logic::math_vecy1_speed#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[enemy_logic::e#10] -- vbum1=pbuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    sta math_vecy1_speed
    // enemy_logic::math_vecy1
    // if (speed)
    // [34] if(0==enemy_logic::math_vecy1_speed#0) goto enemy_logic::math_vecy1_@1 -- 0_eq_vbum1_then_la1 
    beq __b8
    // enemy_logic::math_vecy1_@2
    // angle % 64
    // [35] enemy_logic::math_vecy1_$1 = enemy_logic::math_vecy1_angle#0 & $40-1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #$40-1
    // dy = math_sin[angle % 64]
    // [36] enemy_logic::math_vecy1_$2 = enemy_logic::math_vecy1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [37] enemy_logic::math_vecy1_dy#1 = math_sin[enemy_logic::math_vecy1_$2] -- vwsm1=pwsc1_derefidx_vbuaa 
    tay
    lda math_sin,y
    sta math_vecy1_dy
    lda math_sin+1,y
    sta math_vecy1_dy+1
    // dy <<= speed
    // [38] enemy_logic::math_vecy1_dy#2 = enemy_logic::math_vecy1_dy#1 << enemy_logic::math_vecy1_speed#0 -- vwsm1=vwsm1_rol_vbum2 
    ldy math_vecy1_speed
    beq !e+
  !:
    asl math_vecy1_dy
    rol math_vecy1_dy+1
    dey
    bne !-
  !e:
    // [39] phi from enemy_logic::math_vecy1_@2 to enemy_logic::math_vecy1_@1 [phi:enemy_logic::math_vecy1_@2->enemy_logic::math_vecy1_@1]
    // [39] phi enemy_logic::math_vecy1_return#0 = enemy_logic::math_vecy1_dy#2 [phi:enemy_logic::math_vecy1_@2->enemy_logic::math_vecy1_@1#0] -- vwsz1=vwsm2 
    lda math_vecy1_dy
    sta.z math_vecy1_return
    lda math_vecy1_dy+1
    sta.z math_vecy1_return+1
    jmp __b24
    // [39] phi from enemy_logic::math_vecy1 to enemy_logic::math_vecy1_@1 [phi:enemy_logic::math_vecy1->enemy_logic::math_vecy1_@1]
  __b8:
    // [39] phi enemy_logic::math_vecy1_return#0 = 0 [phi:enemy_logic::math_vecy1->enemy_logic::math_vecy1_@1#0] -- vwsz1=vwsc1 
    lda #<0
    sta.z math_vecy1_return
    sta.z math_vecy1_return+1
    // enemy_logic::math_vecy1_@1
    // enemy_logic::@24
  __b24:
    // flight.yd[e] = (unsigned int)math_vecy(flight.angle[e], flight.speed[e])
    // [40] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YD)[enemy_logic::$40] = (unsigned int)enemy_logic::math_vecy1_return#0 -- pwuc1_derefidx_vbum1=vwuz2 
    ldy enemy_logic__40
    lda.z math_vecy1_return
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD,y
    lda.z math_vecy1_return+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD+1,y
    // flight.move[e] = 0
    // [41] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[enemy_logic::e#10] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    // enemy_logic::@5
  __b5:
    // if(flight.move[e] == 2)
    // [42] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[enemy_logic::e#10]!=2) goto enemy_logic::@9 -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #2
    ldy e
    cmp equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    beq !__b9+
    jmp __b9
  !__b9:
    // enemy_logic::@7
    // if(!flight.delay[e])
    // [43] if(0!=((char *)&flight+OFFSET_STRUCT_FLIGHT_T_DELAY)[enemy_logic::e#10]) goto enemy_logic::@6 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_DELAY,y
    cmp #0
    beq !__b6+
    jmp __b6
  !__b6:
    // enemy_logic::@8
    // flight.angle[e] += flight.turn[e]
    // [44] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] + ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TURN)[enemy_logic::e#10] -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_pbuc2_derefidx_vbum1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    clc
    adc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TURN,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // flight.angle[e] %= 64
    // [45] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] & $40-1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_band_vbuc2 
    lda #$40-1
    and equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // flight.delay[e] = flight.radius[e]
    // [46] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_DELAY)[enemy_logic::e#10] = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RADIUS)[enemy_logic::e#10] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RADIUS,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_DELAY,y
    // math_vecx(flight.angle[e], flight.speed[e])
    // [47] enemy_logic::math_vecx2_angle#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // [48] enemy_logic::math_vecx2_speed#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[enemy_logic::e#10] -- vbum1=pbuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    sta math_vecx2_speed
    // enemy_logic::math_vecx2
    // if (speed)
    // [49] if(0==enemy_logic::math_vecx2_speed#0) goto enemy_logic::math_vecx2_@1 -- 0_eq_vbum1_then_la1 
    beq __b15
    // enemy_logic::math_vecx2_@2
    // angle % 64
    // [50] enemy_logic::math_vecx2_$1 = enemy_logic::math_vecx2_angle#0 & $40-1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #$40-1
    // dx = math_cos[angle % 64]
    // [51] enemy_logic::math_vecx2_$2 = enemy_logic::math_vecx2_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [52] enemy_logic::math_vecx2_dx#1 = math_cos[enemy_logic::math_vecx2_$2] -- vwsm1=pwsc1_derefidx_vbuaa 
    tay
    lda math_cos,y
    sta math_vecx2_dx
    lda math_cos+1,y
    sta math_vecx2_dx+1
    // dx <<= speed
    // [53] enemy_logic::math_vecx2_dx#2 = enemy_logic::math_vecx2_dx#1 << enemy_logic::math_vecx2_speed#0 -- vwsm1=vwsm1_rol_vbum2 
    ldy math_vecx2_speed
    beq !e+
  !:
    asl math_vecx2_dx
    rol math_vecx2_dx+1
    dey
    bne !-
  !e:
    // [54] phi from enemy_logic::math_vecx2_@2 to enemy_logic::math_vecx2_@1 [phi:enemy_logic::math_vecx2_@2->enemy_logic::math_vecx2_@1]
    // [54] phi enemy_logic::math_vecx2_return#0 = enemy_logic::math_vecx2_dx#2 [phi:enemy_logic::math_vecx2_@2->enemy_logic::math_vecx2_@1#0] -- vwsz1=vwsm2 
    lda math_vecx2_dx
    sta.z math_vecx2_return
    lda math_vecx2_dx+1
    sta.z math_vecx2_return+1
    jmp __b25
    // [54] phi from enemy_logic::math_vecx2 to enemy_logic::math_vecx2_@1 [phi:enemy_logic::math_vecx2->enemy_logic::math_vecx2_@1]
  __b15:
    // [54] phi enemy_logic::math_vecx2_return#0 = 0 [phi:enemy_logic::math_vecx2->enemy_logic::math_vecx2_@1#0] -- vwsz1=vwsc1 
    lda #<0
    sta.z math_vecx2_return
    sta.z math_vecx2_return+1
    // enemy_logic::math_vecx2_@1
    // enemy_logic::@25
  __b25:
    // flight.xd[e] = (unsigned int)math_vecx(flight.angle[e], flight.speed[e])
    // [55] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XD)[enemy_logic::$40] = (unsigned int)enemy_logic::math_vecx2_return#0 -- pwuc1_derefidx_vbum1=vwuz2 
    ldy enemy_logic__40
    lda.z math_vecx2_return
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD,y
    lda.z math_vecx2_return+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD+1,y
    // math_vecy(flight.angle[e], flight.speed[e])
    // [56] enemy_logic::math_vecy2_angle#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy e
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // [57] enemy_logic::math_vecy2_speed#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[enemy_logic::e#10] -- vbum1=pbuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    sta math_vecy2_speed
    // enemy_logic::math_vecy2
    // if (speed)
    // [58] if(0==enemy_logic::math_vecy2_speed#0) goto enemy_logic::math_vecy2_@1 -- 0_eq_vbum1_then_la1 
    beq __b16
    // enemy_logic::math_vecy2_@2
    // angle % 64
    // [59] enemy_logic::math_vecy2_$1 = enemy_logic::math_vecy2_angle#0 & $40-1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #$40-1
    // dy = math_sin[angle % 64]
    // [60] enemy_logic::math_vecy2_$2 = enemy_logic::math_vecy2_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [61] enemy_logic::math_vecy2_dy#1 = math_sin[enemy_logic::math_vecy2_$2] -- vwsm1=pwsc1_derefidx_vbuaa 
    tay
    lda math_sin,y
    sta math_vecy2_dy
    lda math_sin+1,y
    sta math_vecy2_dy+1
    // dy <<= speed
    // [62] enemy_logic::math_vecy2_dy#2 = enemy_logic::math_vecy2_dy#1 << enemy_logic::math_vecy2_speed#0 -- vwsm1=vwsm1_rol_vbum2 
    ldy math_vecy2_speed
    beq !e+
  !:
    asl math_vecy2_dy
    rol math_vecy2_dy+1
    dey
    bne !-
  !e:
    // [63] phi from enemy_logic::math_vecy2_@2 to enemy_logic::math_vecy2_@1 [phi:enemy_logic::math_vecy2_@2->enemy_logic::math_vecy2_@1]
    // [63] phi enemy_logic::math_vecy2_return#0 = enemy_logic::math_vecy2_dy#2 [phi:enemy_logic::math_vecy2_@2->enemy_logic::math_vecy2_@1#0] -- vwsz1=vwsm2 
    lda math_vecy2_dy
    sta.z math_vecy2_return
    lda math_vecy2_dy+1
    sta.z math_vecy2_return+1
    jmp __b26
    // [63] phi from enemy_logic::math_vecy2 to enemy_logic::math_vecy2_@1 [phi:enemy_logic::math_vecy2->enemy_logic::math_vecy2_@1]
  __b16:
    // [63] phi enemy_logic::math_vecy2_return#0 = 0 [phi:enemy_logic::math_vecy2->enemy_logic::math_vecy2_@1#0] -- vwsz1=vwsc1 
    lda #<0
    sta.z math_vecy2_return
    sta.z math_vecy2_return+1
    // enemy_logic::math_vecy2_@1
    // enemy_logic::@26
  __b26:
    // flight.yd[e] = (unsigned int)math_vecy(flight.angle[e], flight.speed[e])
    // [64] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YD)[enemy_logic::$40] = (unsigned int)enemy_logic::math_vecy2_return#0 -- pwuc1_derefidx_vbum1=vwuz2 
    ldy enemy_logic__40
    lda.z math_vecy2_return
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD,y
    lda.z math_vecy2_return+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD+1,y
    // enemy_logic::@6
  __b6:
    // flight.delay[e]--;
    // [65] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_DELAY)[enemy_logic::e#10] = -- ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_DELAY)[enemy_logic::e#10] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx e
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_DELAY,x
    // enemy_logic::@9
  __b9:
    // kickasm
    // kickasm( uses enemy_logic::xf uses enemy_logic::yf uses enemy_logic::xi uses enemy_logic::yi uses enemy_logic::xd uses enemy_logic::yd) {{ lda e                 asl                 tay                 ldx e                 lda xf,x        // Load the fractional part of the coordinate.                 clc             // For addition, clear the carry.                 adc xd,y        // Add the low byte (=fractional part) of the delta.                 sta xf,x        // Store the low byte of the delta in the fractional part of the coordinate.                 lda xi,y        // Load the low byte of the integer part of the coordinate.                 adc xd+1,y      // Add the high byte (=integer part) of the delta.                 sta xi,y        // Store the result in the low byte of the integer part of the coordinate.                 lda xd+1,y      // Load back the high byte of the axis delta, it may be negative.                 ora #$7f        // We check the sign bit.                 bmi !+          // If it was minus, the result in A will be $FF.                 lda #0          // The result was not minus, so just add carry.                 !:                 adc xi+1,y      // Now do the signed final addition.                 sta xi+1,y      // And store the result, we're done.                  lda yf,x        // Load the fractional part of the coordinate.                 clc             // For addition, clear the carry.                 adc yd,y        // Add the low byte (=fractional part) of the delta.                 sta yf,x        // Store the low byte of the delta in the fractional part of the coordinate.                 lda yi,y        // Load the low byte of the integer part of the coordinate.                 adc yd+1,y      // Add the high byte (=integer part) of the delta.                 sta yi,y        // Store the result in the low byte of the integer part of the coordinate.                 lda yd+1,y      // Load back the high byte of the delta, it may be negative.                 ora #$7f        // We check the sign bit.                 bmi !+          // If it was minus, the result in A will be $FF.                 lda #0          // The result was not minus, so just add carry.                 !:                 adc yi+1,y      // Now do the signed final addition.                 sta yi+1,y      // And store the result, we're done.              }}
    lda e
                asl
                tay
                ldx e
                lda xf,x        // Load the fractional part of the coordinate.
                clc             // For addition, clear the carry.
                adc xd,y        // Add the low byte (=fractional part) of the delta.
                sta xf,x        // Store the low byte of the delta in the fractional part of the coordinate.
                lda xi,y        // Load the low byte of the integer part of the coordinate.
                adc xd+1,y      // Add the high byte (=integer part) of the delta.
                sta xi,y        // Store the result in the low byte of the integer part of the coordinate.
                lda xd+1,y      // Load back the high byte of the axis delta, it may be negative.
                ora #$7f        // We check the sign bit.
                bmi !+          // If it was minus, the result in A will be $FF.
                lda #0          // The result was not minus, so just add carry.
                !:
                adc xi+1,y      // Now do the signed final addition.
                sta xi+1,y      // And store the result, we're done.

                lda yf,x        // Load the fractional part of the coordinate.
                clc             // For addition, clear the carry.
                adc yd,y        // Add the low byte (=fractional part) of the delta.
                sta yf,x        // Store the low byte of the delta in the fractional part of the coordinate.
                lda yi,y        // Load the low byte of the integer part of the coordinate.
                adc yd+1,y      // Add the high byte (=integer part) of the delta.
                sta yi,y        // Store the result in the low byte of the integer part of the coordinate.
                lda yd+1,y      // Load back the high byte of the delta, it may be negative.
                ora #$7f        // We check the sign bit.
                bmi !+          // If it was minus, the result in A will be $FF.
                lda #0          // The result was not minus, so just add carry.
                !:
                adc yi+1,y      // Now do the signed final addition.
                sta yi+1,y      // And store the result, we're done.
            
    // if (flight.reload[e] > 0)
    // [67] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[enemy_logic::e#10]<=0) goto enemy_logic::@13 -- pbuc1_derefidx_vbum1_le_0_then_la1 
    ldy e
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    cmp #0
    beq __b13
    // enemy_logic::@17
    // flight.reload[e]--;
    // [68] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[enemy_logic::e#10] = -- ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[enemy_logic::e#10] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx e
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,x
    // [69] phi from enemy_logic::@17 enemy_logic::@9 to enemy_logic::@13 [phi:enemy_logic::@17/enemy_logic::@9->enemy_logic::@13]
    // enemy_logic::@13
  __b13:
    // unsigned int r = rand()
    // [70] call rand
    // 	if(animate_is_waiting(flight.animate[e])) {
    // 		vera_sprite_set_xy(sprite_offset, x, y);
    // 	} else {
    // 		// vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_cache.vram_image_offset[(unsigned int)flight.sprite[e]*16+flight.state_animation[e]]);
    // 		vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, 
    // 			sprite_image_cache_vram(flight.sprite[e], animate_get_state(flight.animate[e])));
    // 	}
    jsr rand
    // [71] rand::return#2 = rand::return#0
    // enemy_logic::@27
    // [72] enemy_logic::r#0 = rand::return#2 -- vwum1=vwum2 
    lda rand.return
    sta r
    lda rand.return+1
    sta r+1
    // if(r>=65300)
    // [73] if(enemy_logic::r#0<$ff14) goto enemy_logic::@14 -- vwum1_lt_vwuc1_then_la1 
    cmp #>$ff14
    bcc __b14
    bne !+
    lda r
    cmp #<$ff14
  !:
    // [74] phi from enemy_logic::@27 to enemy_logic::@18 [phi:enemy_logic::@27->enemy_logic::@18]
    // enemy_logic::@18
    // enemy_logic::@14
  __b14:
    // animate_logic(flight.animate[e])
    // [75] animate_logic::a = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[enemy_logic::e#10] -- vbuz1=pbuc1_derefidx_vbum2 
    ldy e
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    sta.z equinoxe_animate.animate_logic.a
    // [76] callexecute animate_logic  -- call_var_near 
    jsr equinoxe_animate.animate_logic
    // collision_insert(e)
    // [77] collision_insert::f = enemy_logic::e#10 -- vbuz1=vbum2 
    lda e
    sta.z equinoxe_collision.collision_insert.f
    // [78] callexecute collision_insert  -- call_var_near 
    jsr equinoxe_collision.collision_insert
    jmp __b3
    // enemy_logic::@4
  __b4:
    // stage_flightpath_t* enemy_flightpath = flight.flightpath[e]
    // [79] enemy_logic::enemy_flightpath#0 = ((stage_flightpath_t **)&flight+OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH)[enemy_logic::$40] -- pssz1=qssc1_derefidx_vbum2 
    // gotoxy(0, e);
    // printf("%02u - used", e);
    ldy enemy_logic__40
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH,y
    sta.z enemy_flightpath
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH+1,y
    sta.z enemy_flightpath+1
    // unsigned char enemy_action = flight.action[e]
    // [80] enemy_logic::enemy_action#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ACTION)[enemy_logic::e#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy e
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ACTION,y
    sta enemy_action
    // stage_action_t* action = stage_get_flightpath_action(enemy_flightpath, enemy_action)
    // [81] stage_get_flightpath_action::flightpath = enemy_logic::enemy_flightpath#0 -- pssz1=pssz2 
    lda.z enemy_flightpath
    sta.z equinoxe_stage_flight.stage_get_flightpath_action.flightpath
    lda.z enemy_flightpath+1
    sta.z equinoxe_stage_flight.stage_get_flightpath_action.flightpath+1
    // [82] stage_get_flightpath_action::action = enemy_logic::enemy_action#0 -- vbum1=vbum2 
    lda enemy_action
    sta equinoxe_stage_flight.stage_get_flightpath_action.action
    // [83] callexecute stage_get_flightpath_action  -- call_var_far_cx16_ram 
    jsr $ff6e
    .byte <equinoxe_stage_flight.stage_get_flightpath_action
    .byte >equinoxe_stage_flight.stage_get_flightpath_action
    .byte 3
    // [84] enemy_logic::action#0 = stage_get_flightpath_action::return -- pssz1=pssz2 
    lda.z equinoxe_stage_flight.stage_get_flightpath_action.return
    sta.z action
    lda.z equinoxe_stage_flight.stage_get_flightpath_action.return+1
    sta.z action+1
    // unsigned char type = stage_get_flightpath_type(enemy_flightpath, enemy_action)
    // [85] stage_get_flightpath_type::flightpath = enemy_logic::enemy_flightpath#0 -- pssz1=pssz2 
    lda.z enemy_flightpath
    sta.z equinoxe_stage_flight.stage_get_flightpath_type.flightpath
    lda.z enemy_flightpath+1
    sta.z equinoxe_stage_flight.stage_get_flightpath_type.flightpath+1
    // [86] stage_get_flightpath_type::action = enemy_logic::enemy_action#0 -- vbum1=vbum2 
    lda enemy_action
    sta equinoxe_stage_flight.stage_get_flightpath_type.action
    // [87] callexecute stage_get_flightpath_type  -- call_var_far_cx16_ram 
    jsr $ff6e
    .byte <equinoxe_stage_flight.stage_get_flightpath_type
    .byte >equinoxe_stage_flight.stage_get_flightpath_type
    .byte 3
    // [88] enemy_logic::type#0 = stage_get_flightpath_type::return -- vbum1=vbum2 
    lda equinoxe_stage_flight.stage_get_flightpath_type.return
    sta type
    // unsigned char next = stage_get_flightpath_next(enemy_flightpath, enemy_action)
    // [89] stage_get_flightpath_next::flightpath = enemy_logic::enemy_flightpath#0 -- pssz1=pssz2 
    lda.z enemy_flightpath
    sta.z equinoxe_stage_flight.stage_get_flightpath_next.flightpath
    lda.z enemy_flightpath+1
    sta.z equinoxe_stage_flight.stage_get_flightpath_next.flightpath+1
    // [90] stage_get_flightpath_next::action = enemy_logic::enemy_action#0 -- vbum1=vbum2 
    lda enemy_action
    sta equinoxe_stage_flight.stage_get_flightpath_next.action
    // [91] callexecute stage_get_flightpath_next  -- call_var_far_cx16_ram 
    jsr $ff6e
    .byte <equinoxe_stage_flight.stage_get_flightpath_next
    .byte >equinoxe_stage_flight.stage_get_flightpath_next
    .byte 3
    // [92] enemy_logic::next#0 = stage_get_flightpath_next::return -- vbum1=vbum2 
    lda equinoxe_stage_flight.stage_get_flightpath_next.return
    sta next
    // case STAGE_ACTION_MOVE:
    //                     path = stage_get_flightpath_action_move_flight(action);
    //                     turn = stage_get_flightpath_action_move_turn(action);
    //                     speed = stage_get_flightpath_action_move_speed(action);
    //                     // printf("move f=%03u, t=%03d, s=%03u, a=%03u - ", flight, turn, speed, next );
    // 
    // 					enemy_move(e, path, (unsigned char)turn, speed);
    //                     flight.action[e] = next;
    // 					break;
    // [93] if(enemy_logic::type#0==STAGE_ACTION_MOVE) goto enemy_logic::@10 -- vbum1_eq_vbuc1_then_la1 
    lda #STAGE_ACTION_MOVE
    cmp type
    bne !__b10+
    jmp __b10
  !__b10:
    // enemy_logic::@15
    // case STAGE_ACTION_TURN:
    //                     turn = stage_get_flightpath_action_turn_turn(action);
    //                     radius = stage_get_flightpath_action_turn_radius(action);
    //                     speed = stage_get_flightpath_action_turn_speed(action);
    //                     // printf("turn t=%03d, r=%03u, s=%03u, a=%03u - ", turn, radius, speed, next );
    // 
    // 					enemy_arc( e, (unsigned char)turn, radius, speed);
    //                     flight.action[e] = next;
    // 					break;
    // [94] if(enemy_logic::type#0==STAGE_ACTION_TURN) goto enemy_logic::@11 -- vbum1_eq_vbuc1_then_la1 
    lda #STAGE_ACTION_TURN
    cmp type
    beq __b11
    // enemy_logic::@16
    // case STAGE_ACTION_END:
    //                     stage_enemy_remove(flight.wave[e], e);
    // 					continue;
    // [95] if(enemy_logic::type#0==STAGE_ACTION_END) goto enemy_logic::@12 -- vbum1_eq_vbuc1_then_la1 
    lda #STAGE_ACTION_END
    cmp type
    beq __b12
    jmp __b9
    // enemy_logic::@12
  __b12:
    // stage_enemy_remove(flight.wave[e], e)
    // [96] stage_enemy_remove::w = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_WAVE)[enemy_logic::e#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy e
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_WAVE,y
    sta equinoxe_stage_flight.stage_enemy_remove.w
    // [97] stage_enemy_remove::e = enemy_logic::e#10 -- vbum1=vbum2 
    tya
    sta equinoxe_stage_flight.stage_enemy_remove.e
    // [98] callexecute stage_enemy_remove  -- call_var_far_cx16_ram 
    jsr $ff6e
    .byte <equinoxe_stage_flight.stage_enemy_remove
    .byte >equinoxe_stage_flight.stage_enemy_remove
    .byte 3
    jmp __b1
    // enemy_logic::@11
  __b11:
    // stage_get_flightpath_action_turn_turn(action)
    // [99] stage_get_flightpath_action_turn_turn::action_turn = enemy_logic::action#0 -- pssz1=pssz2 
    lda.z action
    sta.z equinoxe_stage_flight.stage_get_flightpath_action_turn_turn.action_turn
    lda.z action+1
    sta.z equinoxe_stage_flight.stage_get_flightpath_action_turn_turn.action_turn+1
    // [100] callexecute stage_get_flightpath_action_turn_turn  -- call_var_far_cx16_ram 
    jsr $ff6e
    .byte <equinoxe_stage_flight.stage_get_flightpath_action_turn_turn
    .byte >equinoxe_stage_flight.stage_get_flightpath_action_turn_turn
    .byte 3
    // turn = stage_get_flightpath_action_turn_turn(action)
    // [101] enemy_logic::turn#2 = stage_get_flightpath_action_turn_turn::return -- vbsm1=vbsm2 
    lda equinoxe_stage_flight.stage_get_flightpath_action_turn_turn.return
    sta turn
    // stage_get_flightpath_action_turn_radius(action)
    // [102] stage_get_flightpath_action_turn_radius::action_turn = enemy_logic::action#0 -- pssz1=pssz2 
    lda.z action
    sta.z equinoxe_stage_flight.stage_get_flightpath_action_turn_radius.action_turn
    lda.z action+1
    sta.z equinoxe_stage_flight.stage_get_flightpath_action_turn_radius.action_turn+1
    // [103] callexecute stage_get_flightpath_action_turn_radius  -- call_var_far_cx16_ram 
    jsr $ff6e
    .byte <equinoxe_stage_flight.stage_get_flightpath_action_turn_radius
    .byte >equinoxe_stage_flight.stage_get_flightpath_action_turn_radius
    .byte 3
    // radius = stage_get_flightpath_action_turn_radius(action)
    // [104] enemy_logic::radius#1 = stage_get_flightpath_action_turn_radius::return -- vbum1=vbum2 
    lda equinoxe_stage_flight.stage_get_flightpath_action_turn_radius.return
    sta radius
    // stage_get_flightpath_action_turn_speed(action)
    // [105] stage_get_flightpath_action_turn_speed::action_turn = enemy_logic::action#0 -- pssz1=pssz2 
    lda.z action
    sta.z equinoxe_stage_flight.stage_get_flightpath_action_turn_speed.action_turn
    lda.z action+1
    sta.z equinoxe_stage_flight.stage_get_flightpath_action_turn_speed.action_turn+1
    // [106] callexecute stage_get_flightpath_action_turn_speed  -- call_var_far_cx16_ram 
    jsr $ff6e
    .byte <equinoxe_stage_flight.stage_get_flightpath_action_turn_speed
    .byte >equinoxe_stage_flight.stage_get_flightpath_action_turn_speed
    .byte 3
    // speed = stage_get_flightpath_action_turn_speed(action)
    // [107] enemy_logic::speed#2 = stage_get_flightpath_action_turn_speed::return -- vbuxx=vbum1 
    ldx equinoxe_stage_flight.stage_get_flightpath_action_turn_speed.return
    // enemy_arc( e, (unsigned char)turn, radius, speed)
    // [108] enemy_arc::e = enemy_logic::e#10 -- vbum1=vbum2 
    // printf("turn t=%03d, r=%03u, s=%03u, a=%03u - ", turn, radius, speed, next );
    lda e
    sta equinoxe_enemy.enemy_arc.e
    // [109] enemy_arc::turn = (char)enemy_logic::turn#2 -- vbum1=vbum2 
    lda turn
    sta equinoxe_enemy.enemy_arc.turn
    // [110] enemy_arc::radius = enemy_logic::radius#1 -- vbum1=vbum2 
    lda radius
    sta equinoxe_enemy.enemy_arc.radius
    // [111] enemy_arc::speed = enemy_logic::speed#2 -- vbum1=vbuxx 
    stx equinoxe_enemy.enemy_arc.speed
    // [112] callexecute enemy_arc  -- call_var_near 
    jsr enemy_arc
    // flight.action[e] = next
    // [113] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ACTION)[enemy_logic::e#10] = enemy_logic::next#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda next
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ACTION,y
    jmp __b9
    // enemy_logic::@10
  __b10:
    // stage_get_flightpath_action_move_flight(action)
    // [114] stage_get_flightpath_action_move_flight::action_move = enemy_logic::action#0 -- pssz1=pssz2 
    lda.z action
    sta.z equinoxe_stage_flight.stage_get_flightpath_action_move_flight.action_move
    lda.z action+1
    sta.z equinoxe_stage_flight.stage_get_flightpath_action_move_flight.action_move+1
    // [115] callexecute stage_get_flightpath_action_move_flight  -- call_var_far_cx16_ram 
    jsr $ff6e
    .byte <equinoxe_stage_flight.stage_get_flightpath_action_move_flight
    .byte >equinoxe_stage_flight.stage_get_flightpath_action_move_flight
    .byte 3
    // path = stage_get_flightpath_action_move_flight(action)
    // [116] enemy_logic::path#1 = stage_get_flightpath_action_move_flight::return -- vwum1=vwum2 
    lda equinoxe_stage_flight.stage_get_flightpath_action_move_flight.return
    sta path
    lda equinoxe_stage_flight.stage_get_flightpath_action_move_flight.return+1
    sta path+1
    // stage_get_flightpath_action_move_turn(action)
    // [117] stage_get_flightpath_action_move_turn::action_move = enemy_logic::action#0 -- pssz1=pssz2 
    lda.z action
    sta.z equinoxe_stage_flight.stage_get_flightpath_action_move_turn.action_move
    lda.z action+1
    sta.z equinoxe_stage_flight.stage_get_flightpath_action_move_turn.action_move+1
    // [118] callexecute stage_get_flightpath_action_move_turn  -- call_var_far_cx16_ram 
    jsr $ff6e
    .byte <equinoxe_stage_flight.stage_get_flightpath_action_move_turn
    .byte >equinoxe_stage_flight.stage_get_flightpath_action_move_turn
    .byte 3
    // turn = stage_get_flightpath_action_move_turn(action)
    // [119] enemy_logic::turn#1 = stage_get_flightpath_action_move_turn::return -- vbsm1=vbsm2 
    lda equinoxe_stage_flight.stage_get_flightpath_action_move_turn.return
    sta turn
    // stage_get_flightpath_action_move_speed(action)
    // [120] stage_get_flightpath_action_move_speed::action_move = enemy_logic::action#0 -- pssz1=pssz2 
    lda.z action
    sta.z equinoxe_stage_flight.stage_get_flightpath_action_move_speed.action_move
    lda.z action+1
    sta.z equinoxe_stage_flight.stage_get_flightpath_action_move_speed.action_move+1
    // [121] callexecute stage_get_flightpath_action_move_speed  -- call_var_far_cx16_ram 
    jsr $ff6e
    .byte <equinoxe_stage_flight.stage_get_flightpath_action_move_speed
    .byte >equinoxe_stage_flight.stage_get_flightpath_action_move_speed
    .byte 3
    // speed = stage_get_flightpath_action_move_speed(action)
    // [122] enemy_logic::speed#1 = stage_get_flightpath_action_move_speed::return -- vbuxx=vbum1 
    ldx equinoxe_stage_flight.stage_get_flightpath_action_move_speed.return
    // enemy_move(e, path, (unsigned char)turn, speed)
    // [123] enemy_move::e = enemy_logic::e#10 -- vbum1=vbum2 
    // printf("move f=%03u, t=%03d, s=%03u, a=%03u - ", flight, turn, speed, next );
    lda e
    sta equinoxe_enemy.enemy_move.e
    // [124] enemy_move::moving = enemy_logic::path#1 -- vwum1=vwum2 
    lda path
    sta equinoxe_enemy.enemy_move.moving
    lda path+1
    sta equinoxe_enemy.enemy_move.moving+1
    // [125] enemy_move::turn = (char)enemy_logic::turn#1 -- vbum1=vbum2 
    lda turn
    sta equinoxe_enemy.enemy_move.turn
    // [126] enemy_move::speed = enemy_logic::speed#1 -- vbum1=vbuxx 
    stx equinoxe_enemy.enemy_move.speed
    // [127] callexecute enemy_move  -- call_var_near 
    jsr enemy_move
    // flight.action[e] = next
    // [128] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ACTION)[enemy_logic::e#10] = enemy_logic::next#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda next
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ACTION,y
    jmp __b9
  .segment DataEngineEnemies
    enemy_logic__40: .byte 0
    e: .byte 0
    e_1: .byte 0
    .label enemy_action = enemy_logic__40
    type: .byte 0
    .label next = enemy_logic__40
  .segment Data
    .label math_vecx1_speed = enemy_get_wave.return
    math_vecx1_dx: .word 0
    .label math_vecy1_speed = enemy_get_wave.return
    .label math_vecy1_dy = math_vecx1_dx
    .label math_vecx2_speed = enemy_get_wave.return
    .label math_vecx2_dx = math_vecx1_dx
    .label math_vecy2_speed = enemy_get_wave.return
    .label math_vecy2_dy = math_vecx1_dx
  .segment DataEngineEnemies
    // printf("efp=%p, ac=%03u, ty=%03u, ne=%03u - ", enemy_flightpath, enemy_action, type, next );
    .label path = r
    .label turn = type
    radius: .byte 0
    r: .word 0
}
.segment CodeEngineEnemies
  // enemy_arc
// void enemy_arc(__mem() char e, __mem() char turn, __mem() char radius, __mem() char speed)
// __bank(cx16_ram, 8) 
enemy_arc: {
    // flight.move[e] = 2
    // [129] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[enemy_arc::e] = 2 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #2
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    // sgn_u8(turn)
    // [130] sgn_u8::b#0 = enemy_arc::turn -- vbuaa=vbum1 
    lda turn
    // [131] call sgn_u8
    jsr sgn_u8
    // [132] sgn_u8::return#3 = sgn_u8::return#2
    // enemy_arc::@1
    // [133] enemy_arc::$0 = sgn_u8::return#3
    // flight.turn[e] = sgn_u8(turn)
    // [134] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TURN)[enemy_arc::e] = enemy_arc::$0 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TURN,y
    // flight.radius[e] = radius
    // [135] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RADIUS)[enemy_arc::e] = enemy_arc::radius -- pbuc1_derefidx_vbum1=vbum2 
    lda radius
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RADIUS,y
    // flight.delay[e] = 0
    // [136] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_DELAY)[enemy_arc::e] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_DELAY,y
    // abs_u8((unsigned char)turn)
    // [137] abs_u8::b#0 = enemy_arc::turn -- vbuxx=vbum1 
    ldx turn
    // [138] call abs_u8
    jsr abs_u8
    // [139] abs_u8::return#3 = abs_u8::return#2
    // enemy_arc::@2
    // mul8u(abs_u8((unsigned char)turn), radius)
    // [140] mul8u::a#1 = abs_u8::return#3 -- vbuxx=vbuaa 
    tax
    // [141] mul8u::b#0 = enemy_arc::radius -- vbuaa=vbum1 
    lda radius
    // [142] call mul8u
    jsr mul8u
    // [143] mul8u::return#2 = mul8u::res#2
    // enemy_arc::@3
    // [144] enemy_arc::$2 = mul8u::return#2 -- vwum1=vwum2 
    lda mul8u.return
    sta enemy_arc__2
    lda mul8u.return+1
    sta enemy_arc__2+1
    // flight.moving[e] = mul8u(abs_u8((unsigned char)turn), radius)
    // [145] enemy_arc::$3 = enemy_arc::e << 1 -- vbuaa=vbum1_rol_1 
    lda e
    asl
    // [146] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVING)[enemy_arc::$3] = enemy_arc::$2 -- pwuc1_derefidx_vbuaa=vwum1 
    tay
    lda enemy_arc__2
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING,y
    lda enemy_arc__2+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING+1,y
    // flight.speed[e] = speed
    // [147] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[enemy_arc::e] = enemy_arc::speed -- pbuc1_derefidx_vbum1=vbum2 
    lda speed
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    // enemy_arc::@return
    // }
    // [148] return 
    rts
  .segment Data
    .label e = enemy_get_wave.return
    turn: .byte 0
    radius: .byte 0
    speed: .byte 0
  .segment DataEngineEnemies
    .label enemy_arc__2 = enemy_logic.r
}
.segment CodeEngineEnemies
  // enemy_move
// void enemy_move(__mem() char e, __mem() unsigned int moving, __mem() char turn, __mem() char speed)
// __bank(cx16_ram, 8) 
enemy_move: {
    // flight.move[e] = 1
    // [149] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[enemy_move::e] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    // if(speed>1)
    // [150] if(enemy_move::speed<1+1) goto enemy_move::@1 -- vbum1_lt_vbuc1_then_la1 
    lda speed
    cmp #1+1
    bcc __b1
    // enemy_move::@2
    // speed-1
    // [151] enemy_move::$2 = enemy_move::speed - 1 -- vbuxx=vbum1_minus_1 
    tax
    dex
    // moving >>= (speed-1)
    // [152] enemy_move::moving = enemy_move::moving >> enemy_move::$2 -- vwum1=vwum1_ror_vbuxx 
  !:
    lsr moving+1
    ror moving
    dex
    bne !-
  !e:
    // enemy_move::@1
  __b1:
    // flight.moving[e] = moving
    // [153] enemy_move::$4 = enemy_move::e << 1 -- vbuaa=vbum1_rol_1 
    lda e
    asl
    // [154] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVING)[enemy_move::$4] = enemy_move::moving -- pwuc1_derefidx_vbuaa=vwum1 
    tay
    lda moving
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING,y
    lda moving+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING+1,y
    // flight.angle[e] + turn
    // [155] enemy_move::$3 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_move::e] + enemy_move::turn -- vbuaa=pbuc1_derefidx_vbum1_plus_vbum2 
    lda turn
    ldy e
    clc
    adc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // flight.angle[e] = flight.angle[e] + turn
    // [156] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_move::e] = enemy_move::$3 -- pbuc1_derefidx_vbum1=vbuaa 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // flight.speed[e] = speed
    // [157] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[enemy_move::e] = enemy_move::speed -- pbuc1_derefidx_vbum1=vbum2 
    lda speed
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    // enemy_move::@return
    // }
    // [158] return 
    rts
  .segment Data
    .label e = enemy_get_wave.return
    .label moving = enemy_logic.math_vecx1_dx
    .label turn = equinoxe_enemy.enemy_arc.turn
    .label speed = equinoxe_enemy.enemy_arc.radius
}
.segment CodeEngineEnemies
  // enemy_add
// char enemy_add(__mem() char w, __mem() char sprite_enemy)
// __bank(cx16_ram, 8) 
enemy_add: {
    .label flightpath = $32
    // unsigned char e = flight_add(FLIGHT_ENEMY, SIDE_ENEMY, sprite_enemy)
    // [159] flight_add::type = 1 -- vbum1=vbuc1 
    lda #1
    sta equinoxe_flightengine.flight_add.type
    // [160] flight_add::side = 1 -- vbum1=vbuc1 
    sta equinoxe_flightengine.flight_add.side
    // [161] flight_add::sprite = enemy_add::sprite_enemy -- vbum1=vbum2 
    lda sprite_enemy
    sta equinoxe_flightengine.flight_add.sprite
    // [162] callexecute flight_add  -- call_var_near 
    jsr equinoxe_flightengine.flight_add
    // [163] enemy_add::e#0 = flight_add::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_add.return
    sta e
    // flight.wave[e] = w
    // [164] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_WAVE)[enemy_add::e#0] = enemy_add::w -- pbuc1_derefidx_vbum1=vbum2 
    lda w
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_WAVE,y
    // sprite_cache.count[flight.cache[e]]-1
    // [165] enemy_add::$1 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT)[((char *)&flight)[enemy_add::e#0]] - 1 -- vbuxx=pbuc1_derefidx_(pbuc2_derefidx_vbum1)_minus_1 
    ldx e
    ldy equinoxe_flightengine.flight,x
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT,y
    dex
    // animate_add(
    // 		sprite_cache.count[flight.cache[e]]-1, 
    // 		0,
    // 		0,
    // 		wave.animation_speed[w],
    // 		1, 
    // 		wave.animation_reverse[w]
    // 		)
    // [166] animate_add::count = enemy_add::$1 -- vbuz1=vbuxx 
    stx.z equinoxe_animate.animate_add.count
    // [167] animate_add::state = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z equinoxe_animate.animate_add.state
    // [168] animate_add::loop = 0 -- vbuz1=vbuc1 
    sta.z equinoxe_animate.animate_add.loop
    // [169] animate_add::speed = ((char *)&wave+OFFSET_STRUCT_WAVE_T_ANIMATION_SPEED)[enemy_add::w] -- vbuz1=pbuc1_derefidx_vbum2 
    ldy w
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ANIMATION_SPEED,y
    sta.z equinoxe_animate.animate_add.speed
    // [170] animate_add::direction = 1 -- vbsz1=vbsc1 
    lda #1
    sta.z equinoxe_animate.animate_add.direction
    // [171] animate_add::reverse = ((char *)&wave+OFFSET_STRUCT_WAVE_T_ANIMATION_REVERSE)[enemy_add::w] -- vbuz1=pbuc1_derefidx_vbum2 
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ANIMATION_REVERSE,y
    sta.z equinoxe_animate.animate_add.reverse
    // [172] callexecute animate_add  -- call_var_near 
    jsr equinoxe_animate.animate_add
    // [173] enemy_add::$2 = animate_add::return -- vbuaa=vbuz1 
    lda.z equinoxe_animate.animate_add.return
    // flight.animate[e] = animate_add(
    // 		sprite_cache.count[flight.cache[e]]-1, 
    // 		0,
    // 		0,
    // 		wave.animation_speed[w],
    // 		1, 
    // 		wave.animation_reverse[w]
    // 		)
    // [174] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[enemy_add::e#0] = enemy_add::$2 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // flight.health[e] = 100
    // [175] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[enemy_add::e#0] = $64 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #$64
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    // flight.impact[e] = -30
    // [176] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_IMPACT)[enemy_add::e#0] = -$1e -- pbsc1_derefidx_vbum1=vbsc2 
    lda #-$1e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_IMPACT,y
    // stage_flightpath_t* flightpath = wave.enemy_flightpath[w]
    // [177] enemy_add::$3 = enemy_add::w << 1 -- vbuaa=vbum1_rol_1 
    lda w
    asl
    // [178] enemy_add::flightpath#0 = ((stage_flightpath_t **)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_FLIGHTPATH)[enemy_add::$3] -- pssz1=qssc1_derefidx_vbuaa 
    tay
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_FLIGHTPATH,y
    sta.z flightpath
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_FLIGHTPATH+1,y
    sta.z flightpath+1
    // flight.flightpath[e] = flightpath
    // [179] enemy_add::$8 = enemy_add::e#0 << 1 -- vbuxx=vbum1_rol_1 
    lda e
    asl
    tax
    // [180] ((stage_flightpath_t **)&flight+OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH)[enemy_add::$8] = enemy_add::flightpath#0 -- qssc1_derefidx_vbuxx=pssz1 
    lda.z flightpath
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH,x
    lda.z flightpath+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH+1,x
    // flight.xf[e] = 0
    // [181] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_XF)[enemy_add::e#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XF,y
    // flight.yf[e] = 0
    // [182] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_YF)[enemy_add::e#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YF,y
    // flight.xi[e] = (unsigned int)wave.x[w]
    // [183] enemy_add::$5 = enemy_add::w << 1 -- vbuaa=vbum1_rol_1 
    lda w
    asl
    // [184] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[enemy_add::$8] = (unsigned int)((int *)&wave+OFFSET_STRUCT_WAVE_T_X)[enemy_add::$5] -- pwuc1_derefidx_vbuxx=pwuc2_derefidx_vbuaa 
    tay
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_X,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_X+1,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    // flight.yi[e] = (unsigned int)wave.y[w]
    // [185] enemy_add::$7 = enemy_add::w << 1 -- vbuaa=vbum1_rol_1 
    lda w
    asl
    // [186] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[enemy_add::$8] = (unsigned int)((int *)&wave+OFFSET_STRUCT_WAVE_T_Y)[enemy_add::$7] -- pwuc1_derefidx_vbuxx=pwuc2_derefidx_vbuaa 
    tay
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_Y,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_Y+1,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    // flight.xd[e] = 0
    // [187] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XD)[enemy_add::$8] = 0 -- pwuc1_derefidx_vbuxx=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD,x
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD+1,x
    // flight.yd[e] = 0
    // [188] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YD)[enemy_add::$8] = 0 -- pwuc1_derefidx_vbuxx=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD,x
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD+1,x
    // enemy_add::@return
    // }
    // [189] return 
    rts
  .segment Data
    .label w = enemy_get_wave.return
    .label sprite_enemy = equinoxe_enemy.enemy_arc.turn
  .segment DataEngineEnemies
    .label e = enemy_logic.e
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
    // [222] rand::$0 = rand_state << 7 -- vwum1=vwum2_rol_7 
    lda rand_state+1
    lsr
    lda rand_state
    ror
    sta rand__0+1
    lda #0
    ror
    sta rand__0
    // rand_state ^= rand_state << 7
    // [223] rand_state = rand_state ^ rand::$0 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__0
    sta rand_state
    lda rand_state+1
    eor rand__0+1
    sta rand_state+1
    // rand_state >> 9
    // [224] rand::$1 = rand_state >> 9 -- vwum1=vwum2_ror_9 
    lsr
    sta rand__1
    lda #0
    sta rand__1+1
    // rand_state ^= rand_state >> 9
    // [225] rand_state = rand_state ^ rand::$1 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__1
    sta rand_state
    lda rand_state+1
    eor rand__1+1
    sta rand_state+1
    // rand_state << 8
    // [226] rand::$2 = rand_state << 8 -- vwum1=vwum2_rol_8 
    lda rand_state
    sta rand__2+1
    lda #0
    sta rand__2
    // rand_state ^= rand_state << 8
    // [227] rand_state = rand_state ^ rand::$2 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__2
    sta rand_state
    lda rand_state+1
    eor rand__2+1
    sta rand_state+1
    // return rand_state;
    // [228] rand::return#0 = rand_state -- vwum1=vwum2 
    lda rand_state
    sta return
    lda rand_state+1
    sta return+1
    // rand::@return
    // }
    // [229] return 
    rts
  .segment Data
    .label rand__0 = enemy_logic.math_vecx1_dx
    .label rand__1 = enemy_logic.math_vecx1_dx
    .label rand__2 = enemy_logic.math_vecx1_dx
    .label return = enemy_logic.math_vecx1_dx
}
.segment Code
  // sgn_u8
// Get the sign of a 8-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is <0.
// __register(A) char sgn_u8(__register(A) char b)
sgn_u8: {
    // b & 0x80
    // [230] sgn_u8::$0 = sgn_u8::b#0 & $80 -- vbuaa=vbuaa_band_vbuc1 
    and #$80
    // if (b & 0x80)
    // [231] if(0!=sgn_u8::$0) goto sgn_u8::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // [233] phi from sgn_u8 to sgn_u8::@return [phi:sgn_u8->sgn_u8::@return]
    // [233] phi sgn_u8::return#2 = 1 [phi:sgn_u8->sgn_u8::@return#0] -- vbuaa=vbuc1 
    lda #1
    rts
    // [232] phi from sgn_u8 to sgn_u8::@1 [phi:sgn_u8->sgn_u8::@1]
    // sgn_u8::@1
  __b1:
    // [233] phi from sgn_u8::@1 to sgn_u8::@return [phi:sgn_u8::@1->sgn_u8::@return]
    // [233] phi sgn_u8::return#2 = -1 [phi:sgn_u8::@1->sgn_u8::@return#0] -- vbuaa=vbuc1 
    lda #-1
    // sgn_u8::@return
    // }
    // [234] return 
    rts
}
  // abs_u8
// Get the absolute value of an 8-bit unsigned number treated as a signed number.
// __register(A) char abs_u8(__register(X) char b)
abs_u8: {
    // b & 0x80
    // [235] abs_u8::$0 = abs_u8::b#0 & $80 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #$80
    // if (b & 0x80)
    // [236] if(0!=abs_u8::$0) goto abs_u8::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // [238] phi from abs_u8 to abs_u8::@return [phi:abs_u8->abs_u8::@return]
    // [238] phi abs_u8::return#2 = abs_u8::b#0 [phi:abs_u8->abs_u8::@return#0] -- vbuaa=vbuxx 
    txa
    rts
    // abs_u8::@1
  __b1:
    // return -b;
    // [237] abs_u8::return#0 = - abs_u8::b#0 -- vbuaa=_neg_vbuxx 
    dex
    txa
    eor #$ff
    // [238] phi from abs_u8::@1 to abs_u8::@return [phi:abs_u8::@1->abs_u8::@return]
    // [238] phi abs_u8::return#2 = abs_u8::return#0 [phi:abs_u8::@1->abs_u8::@return#0] -- register_copy 
    // abs_u8::@return
    // }
    // [239] return 
    rts
}
  // mul8u
// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
// __mem() unsigned int mul8u(__register(X) char a, __register(A) char b)
mul8u: {
    // unsigned int mb = b
    // [240] mul8u::mb#0 = (unsigned int)mul8u::b#0 -- vwum1=_word_vbuaa 
    sta mb
    lda #0
    sta mb+1
    // [241] phi from mul8u to mul8u::@1 [phi:mul8u->mul8u::@1]
    // [241] phi mul8u::mb#2 = mul8u::mb#0 [phi:mul8u->mul8u::@1#0] -- register_copy 
    // [241] phi mul8u::res#2 = 0 [phi:mul8u->mul8u::@1#1] -- vwum1=vwuc1 
    sta res
    sta res+1
    // [241] phi mul8u::a#2 = mul8u::a#1 [phi:mul8u->mul8u::@1#2] -- register_copy 
    // mul8u::@1
  __b1:
    // while(a!=0)
    // [242] if(mul8u::a#2!=0) goto mul8u::@2 -- vbuxx_neq_0_then_la1 
    cpx #0
    bne __b2
    // mul8u::@return
    // }
    // [243] return 
    rts
    // mul8u::@2
  __b2:
    // a&1
    // [244] mul8u::$1 = mul8u::a#2 & 1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #1
    // if( (a&1) != 0)
    // [245] if(mul8u::$1==0) goto mul8u::@3 -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b3
    // mul8u::@4
    // res = res + mb
    // [246] mul8u::res#1 = mul8u::res#2 + mul8u::mb#2 -- vwum1=vwum1_plus_vwum2 
    clc
    lda res
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
    // [247] phi from mul8u::@2 mul8u::@4 to mul8u::@3 [phi:mul8u::@2/mul8u::@4->mul8u::@3]
    // [247] phi mul8u::res#6 = mul8u::res#2 [phi:mul8u::@2/mul8u::@4->mul8u::@3#0] -- register_copy 
    // mul8u::@3
  __b3:
    // a = a>>1
    // [248] mul8u::a#0 = mul8u::a#2 >> 1 -- vbuxx=vbuxx_ror_1 
    txa
    lsr
    tax
    // mb = mb<<1
    // [249] mul8u::mb#1 = mul8u::mb#2 << 1 -- vwum1=vwum1_rol_1 
    asl mb
    rol mb+1
    // [241] phi from mul8u::@3 to mul8u::@1 [phi:mul8u::@3->mul8u::@1]
    // [241] phi mul8u::mb#2 = mul8u::mb#1 [phi:mul8u::@3->mul8u::@1#0] -- register_copy 
    // [241] phi mul8u::res#2 = mul8u::res#6 [phi:mul8u::@3->mul8u::@1#1] -- register_copy 
    // [241] phi mul8u::a#2 = mul8u::a#0 [phi:mul8u::@3->mul8u::@1#2] -- register_copy 
    jmp __b1
  .segment Data
    mb: .word 0
    .label res = enemy_logic.math_vecx1_dx
    .label return = enemy_logic.math_vecx1_dx
}
  // Exported Global Data
  // #pragma data_seg(Math)
math_sin:
.fillword 64, 128*sin(toRadians(i*360/64))

math_cos:
.fillword 64, 128*cos(toRadians(i*360/64))

  // The random state variable
  rand_state: .word 1
} // namespace
 // Asm import library equinoxe-layers:
#define __asm_import__equinoxe_layers__
#import "equinoxe-layers.asm"

 // Asm import library equinoxe-animate:
#define __asm_import__equinoxe_animate__
#import "equinoxe-animate.asm"

 // Asm import library equinoxe-palette:
#define __asm_import__equinoxe_palette__
#import "equinoxe-palette.asm"

 // Asm import library equinoxe-collision:
#define __asm_import__equinoxe_collision__
#import "equinoxe-collision.asm"

 // Asm import library equinoxe-flightengine:
#define __asm_import__equinoxe_flightengine__
#import "equinoxe-flightengine.asm"

 // Asm import library equinoxe-waves:
#define __asm_import__equinoxe_waves__
#import "equinoxe-waves.asm"

 // Asm import library equinoxe-stage-flight:
#define __asm_import__equinoxe_stage_flight__
#import "equinoxe-stage-flight.asm"

 // Asm import library lib_conio:
#define __asm_import__lib_conio__
#import "lib_conio.asm"

 // Asm import library lib_lru_cache:
#define __asm_import__lib_lru_cache__
#import "lib_lru_cache.asm"

 // Asm import library lib_veraheap:
#define __asm_import__lib_veraheap__
#import "lib_veraheap.asm"

 // Asm import library lib_bramheap:
#define __asm_import__lib_bramheap__
#import "lib_bramheap.asm"

 // Asm import library lib_file:
#define __asm_import__lib_file__
#import "lib_file.asm"

