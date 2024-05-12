  //
#importonce
  // File Comments
  // Library
.namespace equinoxe_stage_flight {
  // Upstart
.cpu _65c02
#if !__asm_import__equinoxe_stage_flight__
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
  .label OFFSET_STRUCT_FLIGHT_T_TYPE = $180
  .label OFFSET_STRUCT_STAGE_T_BULLET_COUNT = $11
  .label OFFSET_STRUCT_STAGE_FLIGHTPATH_T_TYPE = 4
  .label OFFSET_STRUCT_STAGE_FLIGHTPATH_T_NEXT = 5
  .label OFFSET_STRUCT_STAGE_ACTION_MOVE_T_TURN = 2
  .label OFFSET_STRUCT_STAGE_ACTION_MOVE_T_SPEED = 3
  .label OFFSET_STRUCT_STAGE_ACTION_TURN_T_RADIUS = 1
  .label OFFSET_STRUCT_STAGE_ACTION_TURN_T_SPEED = 2
  .label OFFSET_STRUCT_FLIGHT_T_ENGINE = $6c0
  .label OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN = $35
  .label OFFSET_STRUCT_STAGE_T_PLAYER_COUNT = $12
  .label OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN = 8
  .label OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE = $28
  .label OFFSET_STRUCT_STAGE_T_ENEMY_COUNT = $13
  .label OFFSET_STRUCT_STAGE_T_TOWER_COUNT = $14
  .label SIZEOF_STRUCT_STAGE_T = $38
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __equinoxe_stage_flight_start
// void __equinoxe_stage_flight_start()
__equinoxe_stage_flight_start: {
    // __equinoxe_stage_flight_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __equinoxe_stage_flight_start::@return
    // [3] return 
    rts
}
.segment CodeEngineStages
  // stage_tower_remove
// void stage_tower_remove(__mem() char t)
// __bank(cx16_ram, 3) 
stage_tower_remove: {
    // flight_remove(FLIGHT_TOWER, t)
    // [4] flight_remove::type = 2 -- vbum1=vbuc1 
    lda #2
    sta equinoxe_flightengine.flight_remove.type
    // [5] flight_remove::f = stage_tower_remove::t -- vbum1=vbum2 
    lda t
    sta equinoxe_flightengine.flight_remove.f
    // [6] callexecute flight_remove  -- call_var_near 
    jsr equinoxe_flightengine.flight_remove
    // stage.tower_count--;
    // [7] *((char *)&stage+OFFSET_STRUCT_STAGE_T_TOWER_COUNT) = -- *((char *)&stage+OFFSET_STRUCT_STAGE_T_TOWER_COUNT) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_TOWER_COUNT
    // stage_tower_remove::@return
    // }
    // [8] return 
    rts
  .segment Data
    .label t = stage_get_flightpath_action_turn_speed.return
}
.segment CodeEngineStages
  // stage_enemy_remove
// void stage_enemy_remove(__mem() char w, __mem() char e)
// __bank(cx16_ram, 3) 
stage_enemy_remove: {
    // wave.enemy_spawn[w] += 1
    // [9] ((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN)[stage_enemy_remove::w] = ((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN)[stage_enemy_remove::w] + 1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_1 
    ldy w
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN,y
    inc
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN,y
    // wave.enemy_alive[w] -= 1
    // [10] ((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE)[stage_enemy_remove::w] = ((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE)[stage_enemy_remove::w] - 1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_minus_1 
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE,y
    sec
    sbc #1
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE,y
    // flight_remove(FLIGHT_ENEMY, e)
    // [11] flight_remove::type = 1 -- vbum1=vbuc1 
    lda #1
    sta equinoxe_flightengine.flight_remove.type
    // [12] flight_remove::f = stage_enemy_remove::e -- vbum1=vbum2 
    lda e
    sta equinoxe_flightengine.flight_remove.f
    // [13] callexecute flight_remove  -- call_var_near 
    jsr equinoxe_flightengine.flight_remove
    // stage.enemy_count--;
    // [14] *((char *)&stage+OFFSET_STRUCT_STAGE_T_ENEMY_COUNT) = -- *((char *)&stage+OFFSET_STRUCT_STAGE_T_ENEMY_COUNT) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_ENEMY_COUNT
    // stage_enemy_remove::@return
    // }
    // [15] return 
    rts
  .segment Data
    w: .byte 0
    .label e = stage_get_flightpath_action_turn_speed.return
}
.segment CodeEngineStages
  // stage_player_remove
// void stage_player_remove(__mem() char p)
// __bank(cx16_ram, 3) 
stage_player_remove: {
    // flight_index_t n = flight.engine[p]
    // [16] stage_player_remove::n#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ENGINE)[stage_player_remove::p] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy p
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ENGINE,y
    // flight_remove(FLIGHT_ENGINE, n)
    // [17] flight_remove::type = 4 -- vbum1=vbuc1 
    lda #4
    sta equinoxe_flightengine.flight_remove.type
    // [18] flight_remove::f = stage_player_remove::n#0 -- vbum1=vbuxx 
    stx equinoxe_flightengine.flight_remove.f
    // [19] callexecute flight_remove  -- call_var_near 
    jsr equinoxe_flightengine.flight_remove
    // flight_remove(FLIGHT_PLAYER, p)
    // [20] flight_remove::type = 0 -- vbum1=vbuc1 
    lda #0
    sta equinoxe_flightengine.flight_remove.type
    // [21] flight_remove::f = stage_player_remove::p -- vbum1=vbum2 
    lda p
    sta equinoxe_flightengine.flight_remove.f
    // [22] callexecute flight_remove  -- call_var_near 
    jsr equinoxe_flightengine.flight_remove
    // stage.player_respawn = 8
    // [23] *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN) = 8 -- _deref_pbuc1=vbuc2 
    lda #8
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN
    // stage.player_count--;
    // [24] *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_COUNT) = -- *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_COUNT) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYER_COUNT
    // stage_player_remove::@return
    // }
    // [25] return 
    rts
  .segment Data
    .label p = stage_get_flightpath_action_turn_speed.return
}
.segment CodeEngineStages
  // stage_get_flightpath_action_turn_speed
// __mem() char stage_get_flightpath_action_turn_speed(__zp($22) stage_action_t *action_turn)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_turn_speed: {
    .label action_turn = $22
    // return ((stage_action_turn_t*)action_turn)->speed;
    // [34] stage_get_flightpath_action_turn_speed::return = ((char *)(stage_action_turn_t *)stage_get_flightpath_action_turn_speed::action_turn)[OFFSET_STRUCT_STAGE_ACTION_TURN_T_SPEED] -- vbum1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ACTION_TURN_T_SPEED
    lda (action_turn),y
    sta return
    // stage_get_flightpath_action_turn_speed::@return
    // }
    // [35] return 
    rts
  .segment Data
    return: .byte 0
}
.segment CodeEngineStages
  // stage_get_flightpath_action_turn_radius
// __mem() char stage_get_flightpath_action_turn_radius(__zp($22) stage_action_t *action_turn)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_turn_radius: {
    .label action_turn = $22
    // return ((stage_action_turn_t*)action_turn)->radius;
    // [36] stage_get_flightpath_action_turn_radius::return = ((char *)(stage_action_turn_t *)stage_get_flightpath_action_turn_radius::action_turn)[OFFSET_STRUCT_STAGE_ACTION_TURN_T_RADIUS] -- vbum1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ACTION_TURN_T_RADIUS
    lda (action_turn),y
    sta return
    // stage_get_flightpath_action_turn_radius::@return
    // }
    // [37] return 
    rts
  .segment Data
    .label return = stage_get_flightpath_action_turn_speed.return
}
.segment CodeEngineStages
  // stage_get_flightpath_action_turn_turn
// __mem() signed char stage_get_flightpath_action_turn_turn(__zp($22) volatile stage_action_t *action_turn)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_turn_turn: {
    .label action_turn = $22
    // return ((stage_action_turn_t*)action_turn)->turn;
    // [38] stage_get_flightpath_action_turn_turn::return = *((signed char *)(stage_action_turn_t *)stage_get_flightpath_action_turn_turn::action_turn) -- vbsm1=_deref_pbsz2 
    ldy #0
    lda (action_turn),y
    sta return
    // stage_get_flightpath_action_turn_turn::@return
    // }
    // [39] return 
    rts
  .segment Data
    .label return = stage_get_flightpath_action_turn_speed.return
}
.segment CodeEngineStages
  // stage_get_flightpath_action_move_speed
// __mem() char stage_get_flightpath_action_move_speed(__zp($22) stage_action_t *action_move)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_move_speed: {
    .label action_move = $22
    // return ((stage_action_move_t*)action_move)->speed;
    // [40] stage_get_flightpath_action_move_speed::return = ((char *)(stage_action_move_t *)stage_get_flightpath_action_move_speed::action_move)[OFFSET_STRUCT_STAGE_ACTION_MOVE_T_SPEED] -- vbum1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ACTION_MOVE_T_SPEED
    lda (action_move),y
    sta return
    // stage_get_flightpath_action_move_speed::@return
    // }
    // [41] return 
    rts
  .segment Data
    .label return = stage_get_flightpath_action_turn_speed.return
}
.segment CodeEngineStages
  // stage_get_flightpath_action_move_turn
// __mem() signed char stage_get_flightpath_action_move_turn(__zp($22) stage_action_t *action_move)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_move_turn: {
    .label action_move = $22
    // return ((stage_action_move_t*)action_move)->turn;
    // [42] stage_get_flightpath_action_move_turn::return = ((signed char *)(stage_action_move_t *)stage_get_flightpath_action_move_turn::action_move)[OFFSET_STRUCT_STAGE_ACTION_MOVE_T_TURN] -- vbsm1=pbsz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ACTION_MOVE_T_TURN
    lda (action_move),y
    sta return
    // stage_get_flightpath_action_move_turn::@return
    // }
    // [43] return 
    rts
  .segment Data
    .label return = stage_get_flightpath_action_turn_speed.return
}
.segment CodeEngineStages
  // stage_get_flightpath_action_move_flight
// __mem() unsigned int stage_get_flightpath_action_move_flight(__zp($22) stage_action_t *action_move)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_move_flight: {
    .label action_move = $22
    // return ((stage_action_move_t*)action_move)->flight;
    // [44] stage_get_flightpath_action_move_flight::return = *((unsigned int *)(stage_action_move_t *)stage_get_flightpath_action_move_flight::action_move) -- vwum1=_deref_pwuz2 
    ldy #0
    lda (action_move),y
    sta return
    iny
    lda (action_move),y
    sta return+1
    // stage_get_flightpath_action_move_flight::@return
    // }
    // [45] return 
    rts
  .segment Data
    return: .word 0
}
.segment CodeEngineStages
  // stage_get_flightpath_next
// __mem() char stage_get_flightpath_next(__zp($22) stage_flightpath_t *flightpath, __mem() char action)
// __bank(cx16_ram, 3) 
stage_get_flightpath_next: {
    .label flightpath = $22
    .label stage_get_flightpath_next__1 = $24
    // unsigned char next = flightpath[action].next
    // [46] stage_get_flightpath_next::$3 = stage_get_flightpath_next::action << 1 -- vbuaa=vbum1_rol_1 
    lda action
    asl
    // [47] stage_get_flightpath_next::$4 = stage_get_flightpath_next::$3 + stage_get_flightpath_next::action -- vbuaa=vbuaa_plus_vbum1 
    clc
    adc action
    // [48] stage_get_flightpath_next::$0 = stage_get_flightpath_next::$4 << 1 -- vbuxx=vbuaa_rol_1 
    asl
    tax
    // [49] stage_get_flightpath_next::$1 = (char *)stage_get_flightpath_next::flightpath + OFFSET_STRUCT_STAGE_FLIGHTPATH_T_NEXT -- pbuz1=pbuz2_plus_vbuc1 
    lda #OFFSET_STRUCT_STAGE_FLIGHTPATH_T_NEXT
    clc
    adc.z flightpath
    sta.z stage_get_flightpath_next__1
    lda #0
    adc.z flightpath+1
    sta.z stage_get_flightpath_next__1+1
    // [50] stage_get_flightpath_next::next#0 = stage_get_flightpath_next::$1[stage_get_flightpath_next::$0] -- vbuaa=pbuz1_derefidx_vbuxx 
    txa
    tay
    lda (stage_get_flightpath_next__1),y
    // return next;
    // [51] stage_get_flightpath_next::return = stage_get_flightpath_next::next#0 -- vbum1=vbuaa 
    sta return
    // stage_get_flightpath_next::@return
    // }
    // [52] return 
    rts
  .segment Data
    .label action = stage_get_flightpath_action_turn_speed.return
    .label return = stage_get_flightpath_action_turn_speed.return
}
.segment CodeEngineStages
  // stage_get_flightpath_type
// __mem() char stage_get_flightpath_type(__zp($22) stage_flightpath_t *flightpath, __mem() char action)
// __bank(cx16_ram, 3) 
stage_get_flightpath_type: {
    .label flightpath = $22
    .label stage_get_flightpath_type__1 = $24
    // unsigned char type = flightpath[action].type
    // [53] stage_get_flightpath_type::$3 = stage_get_flightpath_type::action << 1 -- vbuaa=vbum1_rol_1 
    lda action
    asl
    // [54] stage_get_flightpath_type::$4 = stage_get_flightpath_type::$3 + stage_get_flightpath_type::action -- vbuaa=vbuaa_plus_vbum1 
    clc
    adc action
    // [55] stage_get_flightpath_type::$0 = stage_get_flightpath_type::$4 << 1 -- vbuxx=vbuaa_rol_1 
    asl
    tax
    // [56] stage_get_flightpath_type::$1 = (char *)stage_get_flightpath_type::flightpath + OFFSET_STRUCT_STAGE_FLIGHTPATH_T_TYPE -- pbuz1=pbuz2_plus_vbuc1 
    lda #OFFSET_STRUCT_STAGE_FLIGHTPATH_T_TYPE
    clc
    adc.z flightpath
    sta.z stage_get_flightpath_type__1
    lda #0
    adc.z flightpath+1
    sta.z stage_get_flightpath_type__1+1
    // [57] stage_get_flightpath_type::type#0 = stage_get_flightpath_type::$1[stage_get_flightpath_type::$0] -- vbuaa=pbuz1_derefidx_vbuxx 
    txa
    tay
    lda (stage_get_flightpath_type__1),y
    // return type;
    // [58] stage_get_flightpath_type::return = stage_get_flightpath_type::type#0 -- vbum1=vbuaa 
    sta return
    // stage_get_flightpath_type::@return
    // }
    // [59] return 
    rts
  .segment Data
    .label action = stage_get_flightpath_action_turn_speed.return
    .label return = stage_get_flightpath_action_turn_speed.return
}
.segment CodeEngineStages
  // stage_get_flightpath_action
// __zp($22) stage_action_t * stage_get_flightpath_action(__zp($22) stage_flightpath_t *flightpath, __mem() char action)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action: {
    .label flightpath = $22
    .label return = $22
    .label flightpath_action = $24
    // stage_action_t* flightpath_action = &flightpath[action].action
    // [60] stage_get_flightpath_action::$4 = stage_get_flightpath_action::action << 1 -- vbuaa=vbum1_rol_1 
    lda action
    asl
    // [61] stage_get_flightpath_action::$5 = stage_get_flightpath_action::$4 + stage_get_flightpath_action::action -- vbuaa=vbuaa_plus_vbum1 
    clc
    adc action
    // [62] stage_get_flightpath_action::$1 = stage_get_flightpath_action::$5 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [63] stage_get_flightpath_action::flightpath_action#0 = (stage_action_t *)stage_get_flightpath_action::flightpath + stage_get_flightpath_action::$1 -- pssz1=pssz2_plus_vbuaa 
    clc
    adc.z flightpath
    sta.z flightpath_action
    lda #0
    adc.z flightpath+1
    sta.z flightpath_action+1
    // return flightpath_action;
    // [64] stage_get_flightpath_action::return = stage_get_flightpath_action::flightpath_action#0 -- pssz1=pssz2 
    lda.z flightpath_action
    sta.z return
    lda.z flightpath_action+1
    sta.z return+1
    // stage_get_flightpath_action::@return
    // }
    // [65] return 
    rts
  .segment Data
    .label action = stage_get_flightpath_action_turn_speed.return
}
.segment CodeEngineStages
  // stage_bullet_remove
// void stage_bullet_remove(__mem() char b)
// __bank(cx16_ram, 3) 
stage_bullet_remove: {
    // flight_remove(FLIGHT_BULLET, b)
    // [66] flight_remove::type = 3 -- vbum1=vbuc1 
    lda #3
    sta equinoxe_flightengine.flight_remove.type
    // [67] flight_remove::f = stage_bullet_remove::b -- vbum1=vbum2 
    lda b
    sta equinoxe_flightengine.flight_remove.f
    // [68] callexecute flight_remove  -- call_var_near 
    jsr equinoxe_flightengine.flight_remove
    // stage.bullet_count--;
    // [69] *((char *)&stage+OFFSET_STRUCT_STAGE_T_BULLET_COUNT) = -- *((char *)&stage+OFFSET_STRUCT_STAGE_T_BULLET_COUNT) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_BULLET_COUNT
    // stage_bullet_remove::@return
    // }
    // [70] return 
    rts
  .segment Data
    .label b = stage_get_flightpath_action_turn_speed.return
}
.segment CodeEngineStages
  // stage_impact
// void stage_impact(__mem() char f, __mem() char h)
// __bank(cx16_ram, 3) 
stage_impact: {
    // flight_impact(h)
    // [71] flight_impact::f = stage_impact::h -- vbum1=vbum2 
    lda h
    sta equinoxe_flightengine.flight_impact.f
    // [72] callexecute flight_impact  -- call_var_near 
    jsr equinoxe_flightengine.flight_impact
    // [73] stage_impact::$0 = flight_impact::return -- vbsxx=vbsm1 
    ldx equinoxe_flightengine.flight_impact.return
    // unsigned char hit = flight_hit(f, flight_impact(h))
    // [74] flight_hit::f = stage_impact::f -- vbum1=vbum2 
    lda f
    sta equinoxe_flightengine.flight_hit.f
    // [75] flight_hit::impact = stage_impact::$0 -- vbsm1=vbsxx 
    stx equinoxe_flightengine.flight_hit.impact
    // [76] callexecute flight_hit  -- call_var_near 
    jsr equinoxe_flightengine.flight_hit
    // [77] stage_impact::hit#0 = flight_hit::return -- vbuaa=vbum1 
    lda equinoxe_flightengine.flight_hit.return
    // if(hit)
    // [78] if(0==stage_impact::hit#0) goto stage_impact::@return -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __breturn
    // stage_impact::@1
    // case FLIGHT_ENEMY:
    //                 stage_enemy_remove(flight_wave(f), f);
    //                 break;
    // [79] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[stage_impact::f]==1) goto stage_impact::@5 -- pbuc1_derefidx_vbum1_eq_vbuc2_then_la1 
    ldy f
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    cmp #1
    beq __b5
    // stage_impact::@2
    // case FLIGHT_BULLET:
    //                 stage_bullet_remove(f);
    //                 break;
    // [80] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[stage_impact::f]==3) goto stage_impact::@6 -- pbuc1_derefidx_vbum1_eq_vbuc2_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    cmp #3
    beq __b6
    // stage_impact::@3
    // case FLIGHT_PLAYER:
    //                 stage_player_remove(f);
    //                 break;
    // [81] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[stage_impact::f]==0) goto stage_impact::@7 -- pbuc1_derefidx_vbum1_eq_0_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    cmp #0
    beq __b7
    // stage_impact::@4
    // case FLIGHT_TOWER:
    //                 stage_tower_remove(f);
    //                 break;
    // [82] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[stage_impact::f]!=2) goto stage_impact::@return -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #2
    cmp equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    bne __breturn
    // stage_impact::@8
    // stage_tower_remove(f)
    // [83] stage_tower_remove::t = stage_impact::f
    // [84] callexecute stage_tower_remove  -- call_var_near 
    jsr stage_tower_remove
    // stage_impact::@return
  __breturn:
    // }
    // [85] return 
    rts
    // stage_impact::@7
  __b7:
    // stage_player_remove(f)
    // [86] stage_player_remove::p = stage_impact::f
    // [87] callexecute stage_player_remove  -- call_var_near 
    jsr stage_player_remove
    rts
    // stage_impact::@6
  __b6:
    // stage_bullet_remove(f)
    // [88] stage_bullet_remove::b = stage_impact::f
    // [89] callexecute stage_bullet_remove  -- call_var_near 
    jsr stage_bullet_remove
    rts
    // stage_impact::@5
  __b5:
    // flight_wave(f)
    // [90] flight_wave::f = stage_impact::f -- vbum1=vbum2 
    lda f
    sta equinoxe_flightengine.flight_wave.f
    // [91] callexecute flight_wave  -- call_var_near 
    jsr equinoxe_flightengine.flight_wave
    // [92] stage_impact::$3 = flight_wave::return -- vbuaa=vbum1 
    lda equinoxe_flightengine.flight_wave.return
    // stage_enemy_remove(flight_wave(f), f)
    // [93] stage_enemy_remove::w = stage_impact::$3 -- vbum1=vbuaa 
    sta equinoxe_stage_flight.stage_enemy_remove.w
    // [94] stage_enemy_remove::e = stage_impact::f
    // [95] callexecute stage_enemy_remove  -- call_var_near 
    jsr stage_enemy_remove
    rts
  .segment Data
    .label f = stage_get_flightpath_action_turn_speed.return
    .label h = equinoxe_stage_flight.stage_enemy_remove.w
}
  // Exported Global Data
.segment DataEngineStages
  stage: .fill equinoxe_stage_flight.SIZEOF_STRUCT_STAGE_T, 0
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

 // Asm import library equinoxe-flightengine:
#define __asm_import__equinoxe_flightengine__
#import "equinoxe-flightengine.asm"

 // Asm import library equinoxe-waves:
#define __asm_import__equinoxe_waves__
#import "equinoxe-waves.asm"

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

