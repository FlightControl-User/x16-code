  //
#importonce
  // File Comments
  // Library
.namespace equinoxe_waves {
  // Upstart
.cpu _65c02
#if !__asm_import__equinoxe_waves__
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
  .label OFFSET_STRUCT_WAVE_T_X = $30
  .label OFFSET_STRUCT_WAVE_T_DX = $50
  .label OFFSET_STRUCT_WAVE_T_Y = $40
  .label OFFSET_STRUCT_WAVE_T_DY = $58
  .label OFFSET_STRUCT_WAVE_T_INTERVAL = $60
  .label OFFSET_STRUCT_WAVE_T_WAIT = $68
  .label OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN = 8
  .label OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE = $28
  .label SIZEOF_STRUCT_WAVE_T = $a8
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __equinoxe_waves_start
// void __equinoxe_waves_start()
__equinoxe_waves_start: {
    // __equinoxe_waves_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __equinoxe_waves_start::@return
    // [3] return 
    rts
}
  // wave_set
// void wave_set(__mem() char w)
wave_set: {
    // wave.x[w] += wave.dx[w]
    // [4] wave_set::$0 = wave_set::w << 1 -- vbuaa=vbum1_rol_1 
    lda w
    asl
    // [5] ((int *)&wave+OFFSET_STRUCT_WAVE_T_X)[wave_set::$0] = ((int *)&wave+OFFSET_STRUCT_WAVE_T_X)[wave_set::$0] + ((signed char *)&wave+OFFSET_STRUCT_WAVE_T_DX)[wave_set::w] -- pwsc1_derefidx_vbuaa=pwsc1_derefidx_vbuaa_plus_pbsc2_derefidx_vbum1 
    ldx w
    tay
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_DX,x
    sta.z $ff
    clc
    adc equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_X,y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_X,y
    iny
    lda.z $ff
    ora #$7f
    bmi !+
    lda #0
  !:
    adc equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_X+1,y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_X+1,y
    // wave.y[w] += wave.dy[w]
    // [6] wave_set::$1 = wave_set::w << 1 -- vbuaa=vbum1_rol_1 
    lda w
    asl
    // [7] ((int *)&wave+OFFSET_STRUCT_WAVE_T_Y)[wave_set::$1] = ((int *)&wave+OFFSET_STRUCT_WAVE_T_Y)[wave_set::$1] + ((signed char *)&wave+OFFSET_STRUCT_WAVE_T_DY)[wave_set::w] -- pwsc1_derefidx_vbuaa=pwsc1_derefidx_vbuaa_plus_pbsc2_derefidx_vbum1 
    ldx w
    tay
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_DY,x
    sta.z $ff
    clc
    adc equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_Y,y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_Y,y
    iny
    lda.z $ff
    ora #$7f
    bmi !+
    lda #0
  !:
    adc equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_Y+1,y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_Y+1,y
    // wave.wait[w] = wave.interval[w]
    // [8] ((char *)&wave+OFFSET_STRUCT_WAVE_T_WAIT)[wave_set::w] = ((char *)&wave+OFFSET_STRUCT_WAVE_T_INTERVAL)[wave_set::w] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    ldy w
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_INTERVAL,y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_WAIT,y
    // wave.enemy_spawn[w] -= 1
    // [9] ((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN)[wave_set::w] = ((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN)[wave_set::w] - 1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_minus_1 
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN,y
    sec
    sbc #1
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN,y
    // wave.enemy_count[w] -= 1
    // [10] ((char *)&wave)[wave_set::w] = ((char *)&wave)[wave_set::w] - 1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_minus_1 
    lda equinoxe_waves.wave,y
    sec
    sbc #1
    sta equinoxe_waves.wave,y
    // wave.enemy_alive[w] += 1
    // [11] ((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE)[wave_set::w] = ((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE)[wave_set::w] + 1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_1 
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE,y
    inc
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE,y
    // wave_set::@return
    // }
    // [12] return 
    rts
  .segment Data
    .label w = wave_add.return
}
.segment Code
  // wave_add
// __mem() char wave_add(__mem() char w)
wave_add: {
    // w+1
    // [13] wave_add::$0 = wave_add::w + 1 -- vbuaa=vbum1_plus_1 
    lda w
    inc
    // (w+1) & (WAVE_COUNT-1)
    // [14] wave_add::$1 = wave_add::$0 & 8-1 -- vbuaa=vbuaa_band_vbuc1 
    and #8-1
    // return (w+1) & (WAVE_COUNT-1);
    // [15] wave_add::return = wave_add::$1 -- vbum1=vbuaa 
    sta return
    // wave_add::@return
    // }
    // [16] return 
    rts
  .segment Data
    .label w = return
    return: .byte 0
}
  // Exported Global Data
  wave: .fill equinoxe_waves.SIZEOF_STRUCT_WAVE_T, 0
} // namespace
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

