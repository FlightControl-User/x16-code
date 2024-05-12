  //
#importonce
  // File Comments
  // Library
.namespace equinoxe_stage_flightpath {
  // Upstart
.cpu _65c02
#if !__asm_import__equinoxe_stage_flightpath__
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
  .label OFFSET_STRUCT_STAGE_FLIGHTPATH_T_TYPE = 4
  .label OFFSET_STRUCT_STAGE_FLIGHTPATH_T_NEXT = 5
  .label OFFSET_STRUCT_STAGE_ACTION_MOVE_T_TURN = 2
  .label OFFSET_STRUCT_STAGE_ACTION_MOVE_T_SPEED = 3
  .label OFFSET_STRUCT_STAGE_ACTION_TURN_T_RADIUS = 1
  .label OFFSET_STRUCT_STAGE_ACTION_TURN_T_SPEED = 2
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __equinoxe_stage_flightpath_start
// void __equinoxe_stage_flightpath_start()
__equinoxe_stage_flightpath_start: {
    // __equinoxe_stage_flightpath_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __equinoxe_stage_flightpath_start::@return
    // [3] return 
    rts
}
.segment CodeEngineStages
  // stage_get_flightpath_action_turn_speed
// __mem() char stage_get_flightpath_action_turn_speed(__zp($22) stage_action_t *action_turn)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_turn_speed: {
    .label action_turn = $22
    // return ((stage_action_turn_t*)action_turn)->speed;
    // [4] stage_get_flightpath_action_turn_speed::return = ((char *)(stage_action_turn_t *)stage_get_flightpath_action_turn_speed::action_turn)[OFFSET_STRUCT_STAGE_ACTION_TURN_T_SPEED] -- vbum1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ACTION_TURN_T_SPEED
    lda (action_turn),y
    sta return
    // stage_get_flightpath_action_turn_speed::@return
    // }
    // [5] return 
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
    // [6] stage_get_flightpath_action_turn_radius::return = ((char *)(stage_action_turn_t *)stage_get_flightpath_action_turn_radius::action_turn)[OFFSET_STRUCT_STAGE_ACTION_TURN_T_RADIUS] -- vbum1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ACTION_TURN_T_RADIUS
    lda (action_turn),y
    sta return
    // stage_get_flightpath_action_turn_radius::@return
    // }
    // [7] return 
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
    // [8] stage_get_flightpath_action_turn_turn::return = *((signed char *)(stage_action_turn_t *)stage_get_flightpath_action_turn_turn::action_turn) -- vbsm1=_deref_pbsz2 
    ldy #0
    lda (action_turn),y
    sta return
    // stage_get_flightpath_action_turn_turn::@return
    // }
    // [9] return 
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
    // [10] stage_get_flightpath_action_move_speed::return = ((char *)(stage_action_move_t *)stage_get_flightpath_action_move_speed::action_move)[OFFSET_STRUCT_STAGE_ACTION_MOVE_T_SPEED] -- vbum1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ACTION_MOVE_T_SPEED
    lda (action_move),y
    sta return
    // stage_get_flightpath_action_move_speed::@return
    // }
    // [11] return 
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
    // [12] stage_get_flightpath_action_move_turn::return = ((signed char *)(stage_action_move_t *)stage_get_flightpath_action_move_turn::action_move)[OFFSET_STRUCT_STAGE_ACTION_MOVE_T_TURN] -- vbsm1=pbsz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ACTION_MOVE_T_TURN
    lda (action_move),y
    sta return
    // stage_get_flightpath_action_move_turn::@return
    // }
    // [13] return 
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
    // [14] stage_get_flightpath_action_move_flight::return = *((unsigned int *)(stage_action_move_t *)stage_get_flightpath_action_move_flight::action_move) -- vwum1=_deref_pwuz2 
    ldy #0
    lda (action_move),y
    sta return
    iny
    lda (action_move),y
    sta return+1
    // stage_get_flightpath_action_move_flight::@return
    // }
    // [15] return 
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
    // [16] stage_get_flightpath_next::$3 = stage_get_flightpath_next::action << 1 -- vbuaa=vbum1_rol_1 
    lda action
    asl
    // [17] stage_get_flightpath_next::$4 = stage_get_flightpath_next::$3 + stage_get_flightpath_next::action -- vbuaa=vbuaa_plus_vbum1 
    clc
    adc action
    // [18] stage_get_flightpath_next::$0 = stage_get_flightpath_next::$4 << 1 -- vbuxx=vbuaa_rol_1 
    asl
    tax
    // [19] stage_get_flightpath_next::$1 = (char *)stage_get_flightpath_next::flightpath + OFFSET_STRUCT_STAGE_FLIGHTPATH_T_NEXT -- pbuz1=pbuz2_plus_vbuc1 
    lda #OFFSET_STRUCT_STAGE_FLIGHTPATH_T_NEXT
    clc
    adc.z flightpath
    sta.z stage_get_flightpath_next__1
    lda #0
    adc.z flightpath+1
    sta.z stage_get_flightpath_next__1+1
    // [20] stage_get_flightpath_next::next#0 = stage_get_flightpath_next::$1[stage_get_flightpath_next::$0] -- vbuaa=pbuz1_derefidx_vbuxx 
    txa
    tay
    lda (stage_get_flightpath_next__1),y
    // return next;
    // [21] stage_get_flightpath_next::return = stage_get_flightpath_next::next#0 -- vbum1=vbuaa 
    sta return
    // stage_get_flightpath_next::@return
    // }
    // [22] return 
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
    // [23] stage_get_flightpath_type::$3 = stage_get_flightpath_type::action << 1 -- vbuaa=vbum1_rol_1 
    lda action
    asl
    // [24] stage_get_flightpath_type::$4 = stage_get_flightpath_type::$3 + stage_get_flightpath_type::action -- vbuaa=vbuaa_plus_vbum1 
    clc
    adc action
    // [25] stage_get_flightpath_type::$0 = stage_get_flightpath_type::$4 << 1 -- vbuxx=vbuaa_rol_1 
    asl
    tax
    // [26] stage_get_flightpath_type::$1 = (char *)stage_get_flightpath_type::flightpath + OFFSET_STRUCT_STAGE_FLIGHTPATH_T_TYPE -- pbuz1=pbuz2_plus_vbuc1 
    lda #OFFSET_STRUCT_STAGE_FLIGHTPATH_T_TYPE
    clc
    adc.z flightpath
    sta.z stage_get_flightpath_type__1
    lda #0
    adc.z flightpath+1
    sta.z stage_get_flightpath_type__1+1
    // [27] stage_get_flightpath_type::type#0 = stage_get_flightpath_type::$1[stage_get_flightpath_type::$0] -- vbuaa=pbuz1_derefidx_vbuxx 
    txa
    tay
    lda (stage_get_flightpath_type__1),y
    // return type;
    // [28] stage_get_flightpath_type::return = stage_get_flightpath_type::type#0 -- vbum1=vbuaa 
    sta return
    // stage_get_flightpath_type::@return
    // }
    // [29] return 
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
    // [30] stage_get_flightpath_action::$4 = stage_get_flightpath_action::action << 1 -- vbuaa=vbum1_rol_1 
    lda action
    asl
    // [31] stage_get_flightpath_action::$5 = stage_get_flightpath_action::$4 + stage_get_flightpath_action::action -- vbuaa=vbuaa_plus_vbum1 
    clc
    adc action
    // [32] stage_get_flightpath_action::$1 = stage_get_flightpath_action::$5 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [33] stage_get_flightpath_action::flightpath_action#0 = (stage_action_t *)stage_get_flightpath_action::flightpath + stage_get_flightpath_action::$1 -- pssz1=pssz2_plus_vbuaa 
    clc
    adc.z flightpath
    sta.z flightpath_action
    lda #0
    adc.z flightpath+1
    sta.z flightpath_action+1
    // return flightpath_action;
    // [34] stage_get_flightpath_action::return = stage_get_flightpath_action::flightpath_action#0 -- pssz1=pssz2 
    lda.z flightpath_action
    sta.z return
    lda.z flightpath_action+1
    sta.z return+1
    // stage_get_flightpath_action::@return
    // }
    // [35] return 
    rts
  .segment Data
    .label action = stage_get_flightpath_action_turn_speed.return
}
  // Exported Global Data
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

