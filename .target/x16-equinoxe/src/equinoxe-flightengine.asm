  //
#importonce
  // File Comments
  // Library
.namespace equinoxe_flightengine {
  // Upstart
.cpu _65c02
#if !__asm_import__equinoxe_flightengine__
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
  /// The colors of the C64
  .label BLACK = 0
  .label RED = 2
  .label VERA_INC_1 = $10
  .label VERA_ADDRSEL = 1
  /// Sprite Attributes address in VERA VRAM $1FC00 - $1FFFF
  .label VERA_SPRITE_ATTR = $1fc00
  // xBPP sprite modes
  // Sprite flip
  // Sprite ZDepth
  // Sprite width
  // Sprite height
  .label VERA_SPRITE_PALETTE_OFFSET_MASK = $f
  .label STAGE_ACTION_MOVE = 2
  .label STAGE_ACTION_TURN = 3
  .label STAGE_ACTION_END = $ff
  .label FE_CACHE = $10
  .label SIZEOF_STRUCT_SPRITE_FILE_HEADER_T = $10
  .label OFFSET_STRUCT_FLIGHT_T_INDEX = $ad5
  .label OFFSET_STRUCT_FLIGHT_T_USED = $c0
  .label OFFSET_STRUCT_FLIGHT_T_ROOT = $ac1
  .label OFFSET_STRUCT_FLIGHT_T_NEXT = $a41
  .label OFFSET_STRUCT_FLIGHT_T_PREV = $a81
  .label OFFSET_STRUCT_FLIGHT_T_COUNT = $acb
  .label OFFSET_STRUCT_FLIGHT_T_TYPE = $180
  .label OFFSET_STRUCT_FLIGHT_T_SIDE = $1c0
  .label OFFSET_STRUCT_FLIGHT_T_ENABLED = $100
  .label OFFSET_STRUCT_FLIGHT_T_MOVE = $580
  .label OFFSET_STRUCT_FLIGHT_T_MOVED = $5c0
  .label OFFSET_STRUCT_FLIGHT_T_MOVING = $600
  .label OFFSET_STRUCT_FLIGHT_T_ANGLE = $780
  .label OFFSET_STRUCT_FLIGHT_T_SPEED = $7c0
  .label OFFSET_STRUCT_FLIGHT_T_ACTION = $940
  .label OFFSET_STRUCT_FLIGHT_T_TURN = $800
  .label OFFSET_STRUCT_FLIGHT_T_RADIUS = $840
  .label OFFSET_STRUCT_FLIGHT_T_RELOAD = $740
  .label OFFSET_STRUCT_FLIGHT_T_DELAY = $680
  .label OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET = $40
  .label OFFSET_STRUCT_FLIGHT_T_COLLIDED = $140
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET = $100
  .label OFFSET_STRUCT_FLIGHT_T_IMPACT = $8c0
  .label OFFSET_STRUCT_FLIGHT_T_HEALTH = $880
  .label OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE = $2a0
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_SPRITE_BRAM = $10
  .label OFFSET_STRUCT_SPRITE_T_COUNT = $60
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT = $20
  .label OFFSET_STRUCT_SPRITE_T_OFFSET = $240
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET = $30
  .label OFFSET_STRUCT_SPRITE_T_SPRITESIZE = $80
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE = $50
  .label OFFSET_STRUCT_SPRITE_T_ZDEPTH = $100
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_ZDEPTH = $70
  .label OFFSET_STRUCT_SPRITE_T_BPP = $160
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_BPP = $80
  .label OFFSET_STRUCT_SPRITE_T_HEIGHT = $c0
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_HEIGHT = $a0
  .label OFFSET_STRUCT_SPRITE_T_WIDTH = $e0
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_WIDTH = $90
  .label OFFSET_STRUCT_SPRITE_T_HFLIP = $120
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_HFLIP = $b0
  .label OFFSET_STRUCT_SPRITE_T_VFLIP = $140
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_VFLIP = $c0
  .label OFFSET_STRUCT_SPRITE_T_REVERSE = $1a0
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_REVERSE = $d0
  .label OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET = $180
  .label OFFSET_STRUCT_SPRITE_T_LOOP = $280
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_LOOP = $f0
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_FILE = $110
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMIN = $210
  .label OFFSET_STRUCT_AABB_T_YMIN = 1
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMIN = $220
  .label OFFSET_STRUCT_AABB_T_XMAX = 2
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMAX = $230
  .label OFFSET_STRUCT_AABB_T_YMAX = 3
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMAX = $240
  .label OFFSET_STRUCT_SPRITE_T_LOADED = $40
  .label OFFSET_STRUCT_FLIGHT_T_XI = $300
  .label OFFSET_STRUCT_FLIGHT_T_YI = $380
  .label OFFSET_STRUCT_FLIGHT_T_ANIMATE = $900
  .label OFFSET_STRUCT_SPRITE_FILE_HEADER_T_SIZE = 1
  .label OFFSET_STRUCT_SPRITE_FILE_HEADER_T_WIDTH = 3
  .label OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HEIGHT = 4
  .label OFFSET_STRUCT_SPRITE_FILE_HEADER_T_ZDEPTH = 5
  .label OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HFLIP = 6
  .label OFFSET_STRUCT_SPRITE_FILE_HEADER_T_VFLIP = 7
  .label OFFSET_STRUCT_SPRITE_FILE_HEADER_T_BPP = 8
  .label OFFSET_STRUCT_SPRITE_FILE_HEADER_T_REVERSE = $a
  .label OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION = 9
  .label OFFSET_STRUCT_SPRITE_FILE_HEADER_T_LOOP = $b
  .label OFFSET_STRUCT_SPRITE_T_AABB = $1c0
  .label SIZEOF_STRUCT_STAGE_SCENARIO_T = $10
  .label SIZEOF_STRUCT_AABB_T = 4
  .label SIZEOF_STRUCT_FLOOR_SEGMENT_T = 5
  .label SIZEOF_STRUCT_FLOOR_COMPOSITION_T = $c
  .label SIZEOF_STRUCT_FE_SPRITE_CACHE_T = $250
  .label SIZEOF_STRUCT_FLIGHT_T = $ad6
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
  /// $9F25	CTRL Control
  /// Bit 7: Reset
  /// Bit 1: DCSEL
  /// Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  /// $9F2C	DC_BORDER (DCSEL=0)	Border Color
  .label VERA_DC_BORDER = $9f2c
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __equinoxe_flightengine_start
// void __equinoxe_flightengine_start()
__equinoxe_flightengine_start: {
    // __equinoxe_flightengine_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __equinoxe_flightengine_start::@return
    // [3] return 
    rts
}
.segment CodeEngineFlight
  // flight_draw
// void flight_draw()
flight_draw: {
    // [5] phi from flight_draw to flight_draw::@1 [phi:flight_draw->flight_draw::@1]
    // [5] phi flight_draw::f#10 = 0 [phi:flight_draw->flight_draw::@1#0] -- vbum1=vbuc1 
    lda #0
    sta f
    // flight_draw::@1
  __b1:
    // for (unsigned char f = 0; f < FLIGHT_OBJECTS; f++)
    // [6] if(flight_draw::f#10<$40) goto flight_draw::@2 -- vbum1_lt_vbuc1_then_la1 
    lda f
    cmp #$40
    bcc __b2
    // flight_draw::@return
    // }
    // [7] return 
    rts
    // flight_draw::@2
  __b2:
    // if (flight.used[f])
    // [8] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[flight_draw::f#10]) goto flight_draw::@3 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy f
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    bne !__b3+
    jmp __b3
  !__b3:
    // flight_draw::@7
    // unsigned int x = flight.xi[f]
    // [9] flight_draw::$22 = flight_draw::f#10 << 1 -- vbuxx=vbum1_rol_1 
    tya
    asl
    tax
    // [10] flight_draw::x#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[flight_draw::$22] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    sta x
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    sta x+1
    // unsigned int y = flight.yi[f]
    // [11] flight_draw::y#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[flight_draw::$22] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    sta y
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    sta y+1
    // vera_sprite_offset sprite_offset = flight.sprite_offset[f]
    // [12] flight_draw::sprite_offset#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET)[flight_draw::$22] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET,x
    sta sprite_offset
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET+1,x
    sta sprite_offset+1
    // unsigned char a = flight.animate[f]
    // [13] flight_draw::a#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[flight_draw::f#10] -- vbum1=pbuc1_derefidx_vbum2 
    // if( x<640+68 && y<480+68 && (signed int)x>-68 && (signed int)y>-68 ) {
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    sta a
    // unsigned char s = animate_get_image(a)
    // [14] animate_get_image::a = flight_draw::a#0 -- vbum1=vbum2 
    sta equinoxe_animate.animate_get_image.a
    // [15] callexecute animate_get_image  -- call_var_near 
    jsr equinoxe_animate.animate_get_image
    // [16] flight_draw::s#0 = animate_get_image::return -- vbum1=vbum2 
    lda equinoxe_animate.animate_get_image.return
    sta s
    // volatile unsigned char i = flight.cache[f]
    // [17] flight_draw::i = ((char *)&flight)[flight_draw::f#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy f
    lda equinoxe_flightengine.flight,y
    sta i
    // animate_is_waiting(a)
    // [18] animate_is_waiting::a = flight_draw::a#0 -- vbum1=vbum2 
    lda a
    sta equinoxe_animate.animate_is_waiting.a
    // [19] callexecute animate_is_waiting  -- call_var_near 
    jsr equinoxe_animate.animate_is_waiting
    // [20] flight_draw::$3 = animate_is_waiting::return -- vbuaa=vbum1 
    lda equinoxe_animate.animate_is_waiting.return
    // if (animate_is_waiting(a))
    // [21] if(0!=flight_draw::$3) goto flight_draw::@4 -- 0_neq_vbuaa_then_la1 
    // This variable needs to be volatile or the kickc optimizer kills it.
    cmp #0
    bne __b4
    // flight_draw::@8
    // vera_sprite_image_offset sprite_image_offset = sprite_image_cache_vram(i, s)
    // [22] sprite_image_cache_vram::sprite_cache_index = flight_draw::i -- vbum1=vbum2 
    lda i
    sta equinoxe_flightengine.sprite_image_cache_vram.sprite_cache_index
    // [23] sprite_image_cache_vram::fe_sprite_image_index = flight_draw::s#0
    // [24] callexecute sprite_image_cache_vram  -- call_var_near 
    jsr sprite_image_cache_vram
    // [25] flight_draw::sprite_image_offset#0 = sprite_image_cache_vram::return
    // if(sprite_image_offset==0x0)
    // [26] if(flight_draw::sprite_image_offset#0!=0) goto flight_draw::@5 -- vwum1_neq_0_then_la1 
    lda sprite_image_offset
    ora sprite_image_offset+1
    bne __b5
    // flight_draw::@9
    // BREAKPOINT
    // asm { .byte$db  }
    .byte $db
    // flight_draw::@5
  __b5:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [28] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // gotoxy(0,0);
    // printf("%02x %04x, ", f, sprite_image_offset);
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_H = 1 | VERA_INC_1
    // [29] *VERA_ADDRX_H = 1|VERA_INC_1 -- _deref_pbuc1=vbuc2 
    // Select DATA0
    lda #1|VERA_INC_1
    sta VERA_ADDRX_H
    // BYTE1(sprite_offset)
    // [30] flight_draw::$7 = byte1  flight_draw::sprite_offset#0 -- vbuaa=_byte1_vwum1 
    lda sprite_offset+1
    // *VERA_ADDRX_M = BYTE1(sprite_offset)
    // [31] *VERA_ADDRX_M = flight_draw::$7 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // BYTE0(sprite_offset)
    // [32] flight_draw::$8 = byte0  flight_draw::sprite_offset#0 -- vbuaa=_byte0_vwum1 
    lda sprite_offset
    // *VERA_ADDRX_L = BYTE0(sprite_offset)
    // [33] *VERA_ADDRX_L = flight_draw::$8 -- _deref_pbuc1=vbuaa 
    // Normally the +2 should not be an issue.
    sta VERA_ADDRX_L
    // BYTE0(sprite_image_offset)
    // [34] flight_draw::$9 = byte0  flight_draw::sprite_image_offset#0 -- vbuaa=_byte0_vwum1 
    lda sprite_image_offset
    // *VERA_DATA0 = BYTE0(sprite_image_offset)
    // [35] *VERA_DATA0 = flight_draw::$9 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // BYTE1(sprite_image_offset)
    // [36] flight_draw::$10 = byte1  flight_draw::sprite_image_offset#0 -- vbuaa=_byte1_vwum1 
    lda sprite_image_offset+1
    // *VERA_DATA0 = BYTE1(sprite_image_offset)
    // [37] *VERA_DATA0 = flight_draw::$10 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // flight_draw::@6
  __b6:
    // BYTE0(x)
    // [38] flight_draw::$15 = byte0  flight_draw::x#0 -- vbuaa=_byte0_vwum1 
    lda x
    // *VERA_DATA0 = BYTE0(x)
    // [39] *VERA_DATA0 = flight_draw::$15 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // BYTE1(x)
    // [40] flight_draw::$16 = byte1  flight_draw::x#0 -- vbuaa=_byte1_vwum1 
    lda x+1
    // *VERA_DATA0 = BYTE1(x)
    // [41] *VERA_DATA0 = flight_draw::$16 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // BYTE0(y)
    // [42] flight_draw::$17 = byte0  flight_draw::y#0 -- vbuaa=_byte0_vwum1 
    lda y
    // *VERA_DATA0 = BYTE0(y)
    // [43] *VERA_DATA0 = flight_draw::$17 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // BYTE1(y)
    // [44] flight_draw::$18 = byte1  flight_draw::y#0 -- vbuaa=_byte1_vwum1 
    lda y+1
    // *VERA_DATA0 = BYTE1(y)
    // [45] *VERA_DATA0 = flight_draw::$18 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_ADDRX_H = 1 | VERA_INC_0
    // [46] *VERA_ADDRX_H = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [47] flight_draw::$19 = *VERA_DATA0 & ~$c -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$c^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | sprite_cache.zdepth[flight.cache[f]]
    // [48] flight_draw::$20 = flight_draw::$19 | ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_ZDEPTH)[((char *)&flight)[flight_draw::f#10]] -- vbuaa=vbuaa_bor_pbuc1_derefidx_(pbuc2_derefidx_vbum1) 
    ldx f
    ldy equinoxe_flightengine.flight,x
    ora equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_ZDEPTH,y
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | sprite_cache.zdepth[flight.cache[f]]
    // [49] *VERA_DATA0 = flight_draw::$20 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // flight_draw::@3
  __b3:
    // for (unsigned char f = 0; f < FLIGHT_OBJECTS; f++)
    // [50] flight_draw::f#1 = ++ flight_draw::f#10 -- vbum1=_inc_vbum1 
    inc f
    // [5] phi from flight_draw::@3 to flight_draw::@1 [phi:flight_draw::@3->flight_draw::@1]
    // [5] phi flight_draw::f#10 = flight_draw::f#1 [phi:flight_draw::@3->flight_draw::@1#0] -- register_copy 
    jmp __b1
    // flight_draw::@4
  __b4:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [51] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_H = 1 | VERA_INC_1
    // [52] *VERA_ADDRX_H = 1|VERA_INC_1 -- _deref_pbuc1=vbuc2 
    // Select DATA0
    lda #1|VERA_INC_1
    sta VERA_ADDRX_H
    // sprite_offset + 2
    // [53] flight_draw::$13 = flight_draw::sprite_offset#0 + 2 -- vwum1=vwum1_plus_vbuc1 
    lda #2
    clc
    adc flight_draw__13
    sta flight_draw__13
    bcc !+
    inc flight_draw__13+1
  !:
    // BYTE1(sprite_offset + 2)
    // [54] flight_draw::$12 = byte1  flight_draw::$13 -- vbuaa=_byte1_vwum1 
    lda flight_draw__13+1
    // *VERA_ADDRX_M = BYTE1(sprite_offset + 2)
    // [55] *VERA_ADDRX_M = flight_draw::$12 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // BYTE0(sprite_offset + 2)
    // [56] flight_draw::$14 = byte0  flight_draw::$13 -- vbuaa=_byte0_vwum1 
    lda flight_draw__13
    // *VERA_ADDRX_L = BYTE0(sprite_offset + 2)
    // [57] *VERA_ADDRX_L = flight_draw::$14 -- _deref_pbuc1=vbuaa 
    // Normally the +2 should not be an issue.
    sta VERA_ADDRX_L
    jmp __b6
  .segment DataEngineFlight
    i: .byte 0
    .label flight_draw__13 = sprite_offset
    f: .byte 0
    x: .word 0
    y: .word 0
    sprite_offset: .word 0
    .label a = fe_sprite_bram_load.s
    s: .byte 0
    .label sprite_image_offset = sprite_image_cache_vram.sprite_offset
}
.segment CodeEngineFlight
  // flight_init
// void flight_init()
flight_init: {
    .const memset_fast1_ch = $ff
    .const memset_fast2_ch = 0
    .const memset_fast3_ch = 0
    .label memset_fast1_destination = equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SPRITE_BRAM
    .label memset_fast2_destination = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT
    .label memset_fast3_destination = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COUNT
    // [59] phi from flight_init to flight_init::memset_fast1 [phi:flight_init->flight_init::memset_fast1]
    // flight_init::memset_fast1
    // [60] phi from flight_init::memset_fast1 to flight_init::memset_fast1_@1 [phi:flight_init::memset_fast1->flight_init::memset_fast1_@1]
    // [60] phi flight_init::memset_fast1_num#2 = $10 [phi:flight_init::memset_fast1->flight_init::memset_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #$10
    // [60] phi flight_init::memset_fast1_x#2 = 0 [phi:flight_init::memset_fast1->flight_init::memset_fast1_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [60] phi from flight_init::memset_fast1_@1 to flight_init::memset_fast1_@1 [phi:flight_init::memset_fast1_@1->flight_init::memset_fast1_@1]
    // [60] phi flight_init::memset_fast1_num#2 = flight_init::memset_fast1_num#1 [phi:flight_init::memset_fast1_@1->flight_init::memset_fast1_@1#0] -- register_copy 
    // [60] phi flight_init::memset_fast1_x#2 = flight_init::memset_fast1_x#1 [phi:flight_init::memset_fast1_@1->flight_init::memset_fast1_@1#1] -- register_copy 
    // flight_init::memset_fast1_@1
  memset_fast1___b1:
    // destination[x] = ch
    // [61] flight_init::memset_fast1_destination#0[flight_init::memset_fast1_x#2] = flight_init::memset_fast1_ch#0 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #memset_fast1_ch
    sta memset_fast1_destination,y
    // x++;
    // [62] flight_init::memset_fast1_x#1 = ++ flight_init::memset_fast1_x#2 -- vbuyy=_inc_vbuyy 
    iny
    // num--;
    // [63] flight_init::memset_fast1_num#1 = -- flight_init::memset_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [64] if(0!=flight_init::memset_fast1_num#1) goto flight_init::memset_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast1___b1
    // flight_init::@1
    // flight_sprite_offset_pool = 1
    // [65] flight_sprite_offset_pool = 1 -- vbum1=vbuc1 
    lda #1
    sta flight_sprite_offset_pool
    // [66] phi from flight_init::@1 to flight_init::memset_fast2 [phi:flight_init::@1->flight_init::memset_fast2]
    // flight_init::memset_fast2
    // [67] phi from flight_init::memset_fast2 to flight_init::memset_fast2_@1 [phi:flight_init::memset_fast2->flight_init::memset_fast2_@1]
    // [67] phi flight_init::memset_fast2_num#2 = $a [phi:flight_init::memset_fast2->flight_init::memset_fast2_@1#0] -- vbuxx=vbuc1 
    ldx #$a
    // [67] phi flight_init::memset_fast2_x#2 = 0 [phi:flight_init::memset_fast2->flight_init::memset_fast2_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [67] phi from flight_init::memset_fast2_@1 to flight_init::memset_fast2_@1 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast2_@1]
    // [67] phi flight_init::memset_fast2_num#2 = flight_init::memset_fast2_num#1 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast2_@1#0] -- register_copy 
    // [67] phi flight_init::memset_fast2_x#2 = flight_init::memset_fast2_x#1 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast2_@1#1] -- register_copy 
    // flight_init::memset_fast2_@1
  memset_fast2___b1:
    // destination[x] = ch
    // [68] flight_init::memset_fast2_destination#0[flight_init::memset_fast2_x#2] = flight_init::memset_fast2_ch#0 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #memset_fast2_ch
    sta memset_fast2_destination,y
    // x++;
    // [69] flight_init::memset_fast2_x#1 = ++ flight_init::memset_fast2_x#2 -- vbuyy=_inc_vbuyy 
    iny
    // num--;
    // [70] flight_init::memset_fast2_num#1 = -- flight_init::memset_fast2_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [71] if(0!=flight_init::memset_fast2_num#1) goto flight_init::memset_fast2_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast2___b1
    // [72] phi from flight_init::memset_fast2_@1 to flight_init::memset_fast3 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast3]
    // flight_init::memset_fast3
    // [73] phi from flight_init::memset_fast3 to flight_init::memset_fast3_@1 [phi:flight_init::memset_fast3->flight_init::memset_fast3_@1]
    // [73] phi flight_init::memset_fast3_num#2 = $a [phi:flight_init::memset_fast3->flight_init::memset_fast3_@1#0] -- vbuyy=vbuc1 
    ldy #$a
    // [73] phi flight_init::memset_fast3_x#2 = 0 [phi:flight_init::memset_fast3->flight_init::memset_fast3_@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [73] phi from flight_init::memset_fast3_@1 to flight_init::memset_fast3_@1 [phi:flight_init::memset_fast3_@1->flight_init::memset_fast3_@1]
    // [73] phi flight_init::memset_fast3_num#2 = flight_init::memset_fast3_num#1 [phi:flight_init::memset_fast3_@1->flight_init::memset_fast3_@1#0] -- register_copy 
    // [73] phi flight_init::memset_fast3_x#2 = flight_init::memset_fast3_x#1 [phi:flight_init::memset_fast3_@1->flight_init::memset_fast3_@1#1] -- register_copy 
    // flight_init::memset_fast3_@1
  memset_fast3___b1:
    // destination[x] = ch
    // [74] flight_init::memset_fast3_destination#0[flight_init::memset_fast3_x#2] = flight_init::memset_fast3_ch#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast3_ch
    sta memset_fast3_destination,x
    // x++;
    // [75] flight_init::memset_fast3_x#1 = ++ flight_init::memset_fast3_x#2 -- vbuxx=_inc_vbuxx 
    inx
    // num--;
    // [76] flight_init::memset_fast3_num#1 = -- flight_init::memset_fast3_num#2 -- vbuyy=_dec_vbuyy 
    dey
    // while(num)
    // [77] if(0!=flight_init::memset_fast3_num#1) goto flight_init::memset_fast3_@1 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne memset_fast3___b1
    // flight_init::@return
    // }
    // [78] return 
    rts
}
  // fe_sprite_bram_load
// Load the sprite into bram using the new cx16 heap manager.
// __mem() unsigned int fe_sprite_bram_load(__mem() char sprite_index, __mem() unsigned int sprite_offset)
fe_sprite_bram_load: {
    .const bank_push_set_bram1_bank = 4
    .const bank_push_set_bram2_bank = 6
    .label fp = $37
    .label palette_ptr = $39
    .label sprite_ptr = $39
    .label fe_sprite_bram_load__34 = $39
    // fe_sprite_bram_load::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [81] BRAM = fe_sprite_bram_load::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // fe_sprite_bram_load::@10
    // if (!sprites.loaded[sprite_index])
    // [82] if(0!=((char *)&sprites+OFFSET_STRUCT_SPRITE_T_LOADED)[fe_sprite_bram_load::sprite_index]) goto fe_sprite_bram_load::bank_pull_bram1 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_LOADED,y
    cmp #0
    beq !bank_pull_bram1+
    jmp bank_pull_bram1
  !bank_pull_bram1:
    // fe_sprite_bram_load::@1
    // strcpy(filename, sprites.file[sprite_index])
    // [83] fe_sprite_bram_load::$25 = fe_sprite_bram_load::sprite_index << 1 -- vbuaa=vbum1_rol_1 
    tya
    asl
    // [84] strcpy::source#1 = ((char **)&sprites)[fe_sprite_bram_load::$25] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda sprites,y
    sta.z strcpy.source
    lda sprites+1,y
    sta.z strcpy.source+1
    // [85] call strcpy
    // [406] phi from fe_sprite_bram_load::@1 to strcpy [phi:fe_sprite_bram_load::@1->strcpy]
    // [406] phi strcpy::dst#0 = fe_sprite_bram_load::filename [phi:fe_sprite_bram_load::@1->strcpy#0] -- pbuz1=pbuc1 
    lda #<filename
    sta.z strcpy.dst
    lda #>filename
    sta.z strcpy.dst+1
    // [406] phi strcpy::src#0 = strcpy::source#1 [phi:fe_sprite_bram_load::@1->strcpy#1] -- register_copy 
    jsr strcpy
    // [86] phi from fe_sprite_bram_load::@1 to fe_sprite_bram_load::@16 [phi:fe_sprite_bram_load::@1->fe_sprite_bram_load::@16]
    // fe_sprite_bram_load::@16
    // strcat(filename, ".bin")
    // [87] call strcat
    // [414] phi from fe_sprite_bram_load::@16 to strcat [phi:fe_sprite_bram_load::@16->strcat]
    jsr strcat
    // fe_sprite_bram_load::@17
    // FILE *fp = fopen(filename, "r")
    // [88] fopen::path = fe_sprite_bram_load::filename -- pbuz1=pbuc1 
    lda #<filename
    sta.z lib_file.fopen.path
    lda #>filename
    sta.z lib_file.fopen.path+1
    // [89] fopen::mode = fe_sprite_bram_load::mode -- pbuz1=pbuc1 
    lda #<mode
    sta.z lib_file.fopen.mode
    lda #>mode
    sta.z lib_file.fopen.mode+1
    // [90] callexecute fopen  -- call_var_near 
    jsr lib_file.fopen
    // [91] fe_sprite_bram_load::fp#0 = fopen::return -- pssz1=pssz2 
    lda.z lib_file.fopen.return
    sta.z fp
    lda.z lib_file.fopen.return+1
    sta.z fp+1
    // if (!fp)
    // [92] if((struct file_handle_s *)0==fe_sprite_bram_load::fp#0) goto fe_sprite_bram_load::bank_pull_bram1 -- pssc1_eq_pssz1_then_la1 
    lda.z fp
    cmp #<0
    bne !+
    lda.z fp+1
    cmp #>0
    bne !bank_pull_bram1+
    jmp bank_pull_bram1
  !bank_pull_bram1:
  !:
    // fe_sprite_bram_load::@2
    // sprite_file_header_t sprite_file_header
    // [93] *(&fe_sprite_bram_load::sprite_file_header) = memset(sprite_file_header_t, SIZEOF_STRUCT_SPRITE_FILE_HEADER_T) -- _deref_pssc1=_memset_vbuc2 
    ldy #SIZEOF_STRUCT_SPRITE_FILE_HEADER_T
    lda #0
  !:
    dey
    sta sprite_file_header,y
    bne !-
    // unsigned int read = fgets((char *)&sprite_file_header, sizeof(sprite_file_header_t), fp)
    // [94] fgets::ptr = (char *)&fe_sprite_bram_load::sprite_file_header -- pbuz1=pbuc1 
    // Read the header of the file into the sprite_file_header structure.
    lda #<sprite_file_header
    sta.z lib_file.fgets.ptr
    lda #>sprite_file_header
    sta.z lib_file.fgets.ptr+1
    // [95] fgets::size = SIZEOF_STRUCT_SPRITE_FILE_HEADER_T -- vwum1=vbuc1 
    lda #<SIZEOF_STRUCT_SPRITE_FILE_HEADER_T
    sta lib_file.fgets.size
    lda #>SIZEOF_STRUCT_SPRITE_FILE_HEADER_T
    sta lib_file.fgets.size+1
    // [96] fgets::stream = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z lib_file.fgets.stream
    lda.z fp+1
    sta.z lib_file.fgets.stream+1
    // [97] callexecute fgets  -- call_var_near 
    jsr lib_file.fgets
    // [98] fe_sprite_bram_load::read#0 = fgets::return -- vwum1=vwum2 
    lda lib_file.fgets.return
    sta read
    lda lib_file.fgets.return+1
    sta read+1
    // if (!read)
    // [99] if(0==fe_sprite_bram_load::read#0) goto fe_sprite_bram_load::bank_pull_bram1 -- 0_eq_vwum1_then_la1 
    lda read
    ora read+1
    bne !bank_pull_bram1+
    jmp bank_pull_bram1
  !bank_pull_bram1:
    // fe_sprite_bram_load::@3
    // sprite_map_header(&sprite_file_header, sprite_index)
    // [100] sprite_map_header::sprite#0 = fe_sprite_bram_load::sprite_index -- vbum1=vbum2 
    lda sprite_index
    sta sprite_map_header.sprite
    // [101] call sprite_map_header
    jsr sprite_map_header
    // [102] phi from fe_sprite_bram_load::@3 to fe_sprite_bram_load::@18 [phi:fe_sprite_bram_load::@3->fe_sprite_bram_load::@18]
    // fe_sprite_bram_load::@18
    // palette_index_t palette_index = palette_alloc_bram()
    // [103] callexecute palette_alloc_bram  -- call_var_near 
    jsr equinoxe_palette.palette_alloc_bram
    // [104] fe_sprite_bram_load::palette_index#0 = palette_alloc_bram::return -- vbum1=vbum2 
    lda equinoxe_palette.palette_alloc_bram.return
    sta palette_index
    // palette_ptr_t palette_ptr = palette_ptr_bram(palette_index)
    // [105] palette_ptr_bram::palette_index = fe_sprite_bram_load::palette_index#0 -- vbum1=vbum2 
    sta equinoxe_palette.palette_ptr_bram.palette_index
    // [106] callexecute palette_ptr_bram  -- call_var_near 
    jsr equinoxe_palette.palette_ptr_bram
    // [107] fe_sprite_bram_load::palette_ptr#0 = palette_ptr_bram::return -- pssz1=pssz2 
    lda.z equinoxe_palette.palette_ptr_bram.return
    sta.z palette_ptr
    lda.z equinoxe_palette.palette_ptr_bram.return+1
    sta.z palette_ptr+1
    // fe_sprite_bram_load::bank_push_set_bram2
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [109] BRAM = fe_sprite_bram_load::bank_push_set_bram2_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram2_bank
    sta.z BRAM
    // fe_sprite_bram_load::@12
    // fgets((char *)palette_ptr, 32, fp)
    // [110] fgets::ptr = (char *)fe_sprite_bram_load::palette_ptr#0 -- pbuz1=pbuz2 
    lda.z palette_ptr
    sta.z lib_file.fgets.ptr
    lda.z palette_ptr+1
    sta.z lib_file.fgets.ptr+1
    // [111] fgets::size = $20 -- vwum1=vbuc1 
    lda #<$20
    sta lib_file.fgets.size
    lda #>$20
    sta lib_file.fgets.size+1
    // [112] fgets::stream = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z lib_file.fgets.stream
    lda.z fp+1
    sta.z lib_file.fgets.stream+1
    // [113] callexecute fgets  -- call_var_near 
    jsr lib_file.fgets
    // fe_sprite_bram_load::bank_pull_bram2
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_bram_load::@13
    // sprites.PaletteOffset[sprite_index] = palette_index
    // [115] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET)[fe_sprite_bram_load::sprite_index] = fe_sprite_bram_load::palette_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda palette_index
    ldy sprite_index
    sta sprites+OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET,y
    // sprites.offset[sprite_index] = sprite_offset
    // [116] fe_sprite_bram_load::$26 = fe_sprite_bram_load::sprite_index << 1 -- vbuaa=vbum1_rol_1 
    tya
    asl
    // [117] ((unsigned int *)&sprites+OFFSET_STRUCT_SPRITE_T_OFFSET)[fe_sprite_bram_load::$26] = fe_sprite_bram_load::sprite_offset -- pwuc1_derefidx_vbuaa=vwum1 
    tay
    lda sprite_offset
    sta sprites+OFFSET_STRUCT_SPRITE_T_OFFSET,y
    lda sprite_offset+1
    sta sprites+OFFSET_STRUCT_SPRITE_T_OFFSET+1,y
    // unsigned int sprite_size = sprites.SpriteSize[sprite_index]
    // [118] fe_sprite_bram_load::$27 = fe_sprite_bram_load::sprite_index << 1 -- vbuaa=vbum1_rol_1 
    lda sprite_index
    asl
    // [119] fe_sprite_bram_load::sprite_size#0 = ((unsigned int *)&sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE)[fe_sprite_bram_load::$27] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE,y
    sta sprite_size
    lda sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE+1,y
    sta sprite_size+1
    // [120] phi from fe_sprite_bram_load::@13 to fe_sprite_bram_load::@4 [phi:fe_sprite_bram_load::@13->fe_sprite_bram_load::@4]
    // [120] phi fe_sprite_bram_load::s#2 = 0 [phi:fe_sprite_bram_load::@13->fe_sprite_bram_load::@4#0] -- vbum1=vbuc1 
    lda #0
    sta s
    // fe_sprite_bram_load::@4
  __b4:
    // for (unsigned char s = 0; s < sprites.count[sprite_index]; s++)
    // [121] if(fe_sprite_bram_load::s#2<((char *)&sprites+OFFSET_STRUCT_SPRITE_T_COUNT)[fe_sprite_bram_load::sprite_index]) goto fe_sprite_bram_load::@5 -- vbum1_lt_pbuc1_derefidx_vbum2_then_la1 
    lda s
    ldy sprite_index
    cmp sprites+OFFSET_STRUCT_SPRITE_T_COUNT,y
    bcc __b5
    // fe_sprite_bram_load::@6
    // fclose(fp)
    // [122] fclose::stream = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z lib_file.fclose.stream
    lda.z fp+1
    sta.z lib_file.fclose.stream+1
    // [123] callexecute fclose  -- call_var_near 
    jsr lib_file.fclose
    // [124] fe_sprite_bram_load::$24 = fclose::return -- vwsm1=vwsm2 
    lda lib_file.fclose.return
    sta fe_sprite_bram_load__24
    lda lib_file.fclose.return+1
    sta fe_sprite_bram_load__24+1
    // if (fclose(fp))
    // [125] if(0!=fe_sprite_bram_load::$24) goto fe_sprite_bram_load::bank_pull_bram1 -- 0_neq_vwsm1_then_la1 
    // Now we have read everything and we close the file.
    ora fe_sprite_bram_load__24
    bne bank_pull_bram1
    // fe_sprite_bram_load::@9
    // sprites.loaded[sprite_index] = 1
    // [126] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_LOADED)[fe_sprite_bram_load::sprite_index] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    ldy sprite_index
    sta sprites+OFFSET_STRUCT_SPRITE_T_LOADED,y
    // fe_sprite_bram_load::bank_pull_bram1
  bank_pull_bram1:
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_bram_load::@11
    // return sprite_offset;
    // [128] fe_sprite_bram_load::return = fe_sprite_bram_load::sprite_offset
    // fe_sprite_bram_load::@return
    // }
    // [129] return 
    rts
    // fe_sprite_bram_load::@5
  __b5:
    // bram_heap_handle_t handle_bram = bram_heap_alloc(0, sprite_size)
    // [130] bram_heap_alloc::s = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_bramheap.bram_heap_alloc.s
    // [131] bram_heap_alloc::size = fe_sprite_bram_load::sprite_size#0 -- vdum1=vwum2 
    lda sprite_size
    sta lib_bramheap.bram_heap_alloc.size
    lda sprite_size+1
    sta lib_bramheap.bram_heap_alloc.size+1
    lda #0
    sta lib_bramheap.bram_heap_alloc.size+2
    sta lib_bramheap.bram_heap_alloc.size+3
    // [132] callexecute bram_heap_alloc  -- call_var_near 
    jsr lib_bramheap.bram_heap_alloc
    // [133] fe_sprite_bram_load::handle_bram#0 = bram_heap_alloc::return -- vbum1=vbum2 
    lda lib_bramheap.bram_heap_alloc.return
    sta handle_bram
    // bram_bank_t sprite_bank = bram_heap_data_get_bank(0, handle_bram)
    // [134] bram_heap_data_get_bank::s = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_bramheap.bram_heap_data_get_bank.s
    // [135] bram_heap_data_get_bank::index = fe_sprite_bram_load::handle_bram#0 -- vbum1=vbum2 
    lda handle_bram
    sta lib_bramheap.bram_heap_data_get_bank.index
    // [136] callexecute bram_heap_data_get_bank  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_bank
    // [137] fe_sprite_bram_load::bank_push_set_bram3_bank#0 = bram_heap_data_get_bank::return -- vbum1=vbum2 
    lda lib_bramheap.bram_heap_data_get_bank.return
    sta bank_push_set_bram3_bank
    // bram_ptr_t sprite_ptr = bram_heap_data_get_offset(0, handle_bram)
    // [138] bram_heap_data_get_offset::s = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_bramheap.bram_heap_data_get_offset.s
    // [139] bram_heap_data_get_offset::index = fe_sprite_bram_load::handle_bram#0 -- vbum1=vbum2 
    lda handle_bram
    sta lib_bramheap.bram_heap_data_get_offset.index
    // [140] callexecute bram_heap_data_get_offset  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_offset
    // [141] fe_sprite_bram_load::sprite_ptr#0 = bram_heap_data_get_offset::return -- pbuz1=pbuz2 
    lda.z lib_bramheap.bram_heap_data_get_offset.return
    sta.z sprite_ptr
    lda.z lib_bramheap.bram_heap_data_get_offset.return+1
    sta.z sprite_ptr+1
    // fe_sprite_bram_load::bank_push_set_bram3
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [143] BRAM = fe_sprite_bram_load::bank_push_set_bram3_bank#0 -- vbuz1=vbum2 
    lda bank_push_set_bram3_bank
    sta.z BRAM
    // fe_sprite_bram_load::@14
    // unsigned int read = fgets(sprite_ptr, sprite_size, fp)
    // [144] fgets::ptr = fe_sprite_bram_load::sprite_ptr#0 -- pbuz1=pbuz2 
    lda.z sprite_ptr
    sta.z lib_file.fgets.ptr
    lda.z sprite_ptr+1
    sta.z lib_file.fgets.ptr+1
    // [145] fgets::size = fe_sprite_bram_load::sprite_size#0 -- vwum1=vwum2 
    lda sprite_size
    sta lib_file.fgets.size
    lda sprite_size+1
    sta lib_file.fgets.size+1
    // [146] fgets::stream = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z lib_file.fgets.stream
    lda.z fp+1
    sta.z lib_file.fgets.stream+1
    // [147] callexecute fgets  -- call_var_near 
    jsr lib_file.fgets
    // [148] fe_sprite_bram_load::read1#0 = fgets::return -- vwum1=vwum2 
    lda lib_file.fgets.return
    sta read1
    lda lib_file.fgets.return+1
    sta read1+1
    // fe_sprite_bram_load::bank_pull_bram3
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_bram_load::@15
    // if (!read)
    // [150] if(0==fe_sprite_bram_load::read1#0) goto fe_sprite_bram_load::@7 -- 0_eq_vwum1_then_la1 
    lda read1
    ora read1+1
    beq __b7
    // fe_sprite_bram_load::@8
    // sprite_bram_handles[sprite_offset] = handle_bram
    // [151] fe_sprite_bram_load::$34 = sprite_bram_handles + fe_sprite_bram_load::sprite_offset -- pbuz1=pbuc1_plus_vwum2 
    lda sprite_offset
    clc
    adc #<sprite_bram_handles
    sta.z fe_sprite_bram_load__34
    lda sprite_offset+1
    adc #>sprite_bram_handles
    sta.z fe_sprite_bram_load__34+1
    // [152] *fe_sprite_bram_load::$34 = fe_sprite_bram_load::handle_bram#0 -- _deref_pbuz1=vbum2 
    lda handle_bram
    ldy #0
    sta (fe_sprite_bram_load__34),y
    // sprite_offset++;
    // [153] fe_sprite_bram_load::sprite_offset = ++ fe_sprite_bram_load::sprite_offset -- vwum1=_inc_vwum1 
    inc sprite_offset
    bne !+
    inc sprite_offset+1
  !:
    // fe_sprite_bram_load::@7
  __b7:
    // for (unsigned char s = 0; s < sprites.count[sprite_index]; s++)
    // [154] fe_sprite_bram_load::s#1 = ++ fe_sprite_bram_load::s#2 -- vbum1=_inc_vbum1 
    inc s
    // [120] phi from fe_sprite_bram_load::@7 to fe_sprite_bram_load::@4 [phi:fe_sprite_bram_load::@7->fe_sprite_bram_load::@4]
    // [120] phi fe_sprite_bram_load::s#2 = fe_sprite_bram_load::s#1 [phi:fe_sprite_bram_load::@7->fe_sprite_bram_load::@4#0] -- register_copy 
    jmp __b4
  .segment DataEngineFlight
    filename: .fill $10, 0
  .encoding "petscii_mixed"
    source: .text ".bin"
    .byte 0
    mode: .text "r"
    .byte 0
    sprite_index: .byte 0
    .label sprite_offset = return
    return: .word 0
    sprite_file_header: .fill SIZEOF_STRUCT_SPRITE_FILE_HEADER_T, 0
    .label fe_sprite_bram_load__24 = sprite_image_cache_vram.sprite_offset
    .label read = sprite_image_cache_vram.sprite_offset
    .label palette_index = flight_draw.f
    .label sprite_size = sprite_image_cache_vram.sprite_offset
    .label handle_bram = flight_draw.s
  .segment Data
    .label bank_push_set_bram3_bank = memcpy_vram_bram.sbank_bram
  .segment DataEngineFlight
    .label read1 = flight_draw.x
    s: .byte 0
}
.segment CodeEngineFlight
  // sprite_image_cache_vram
// __mem() unsigned int sprite_image_cache_vram(__mem() char sprite_cache_index, __mem() char fe_sprite_image_index)
sprite_image_cache_vram: {
    .const bank_push_set_bram1_bank = 4
    .label sprite_ptr = $39
    .label sprite_image_cache_vram__40 = $37
    // unsigned int image_index = sprite_cache.offset[sprite_cache_index] + fe_sprite_image_index
    // [155] sprite_image_cache_vram::$36 = sprite_image_cache_vram::sprite_cache_index << 1 -- vbuaa=vbum1_rol_1 
    lda sprite_cache_index
    asl
    // [156] sprite_image_cache_vram::image_index#0 = ((unsigned int *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET)[sprite_image_cache_vram::$36] + sprite_image_cache_vram::fe_sprite_image_index -- vwum1=pwuc1_derefidx_vbuaa_plus_vbum2 
    // check if the image in vram is in use where the fe_sprite_vram_image_index is pointing to.
    // if this vram_image_used is false, that means that the image in vram is not in use anymore (not displayed or destroyed).
    tay
    lda fe_sprite_image_index
    clc
    adc equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET,y
    sta image_index
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET+1,y
    adc #0
    sta image_index+1
    // lru_cache_index_t vram_index = lru_cache_index(image_index)
    // [157] lru_cache_index::key = sprite_image_cache_vram::image_index#0 -- vwum1=vwum2 
    // We check if there is a cache hit?
    lda image_index
    sta lib_lru_cache.lru_cache_index.key
    lda image_index+1
    sta lib_lru_cache.lru_cache_index.key+1
    // [158] callexecute lru_cache_index  -- call_var_near 
    jsr lib_lru_cache.lru_cache_index
    // [159] sprite_image_cache_vram::vram_index#0 = lru_cache_index::return -- vbuaa=vbum1 
    lda lib_lru_cache.lru_cache_index.return
    // if (vram_index != 0xFF)
    // [160] if(sprite_image_cache_vram::vram_index#0!=$ff) goto sprite_image_cache_vram::@1 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$ff
    beq !__b1+
    jmp __b1
  !__b1:
    // sprite_image_cache_vram::vera_display_set_border_color1
    // *VERA_CTRL &= 0b10000001
    // [161] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [162] *VERA_DC_BORDER = RED -- _deref_pbuc1=vbuc2 
    lda #RED
    sta VERA_DC_BORDER
    // sprite_image_cache_vram::@8
    // vera_heap_size_int_t vram_size_required = sprite_cache.size[sprite_cache_index]
    // [163] sprite_image_cache_vram::$37 = sprite_image_cache_vram::sprite_cache_index << 1 -- vbuaa=vbum1_rol_1 
    lda sprite_cache_index
    asl
    // [164] sprite_image_cache_vram::vram_size_required#0 = ((unsigned int *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE)[sprite_image_cache_vram::$37] -- vwum1=pwuc1_derefidx_vbuaa 
    // The idea of this section is to free up lru_cache and/or vram memory until there is sufficient space available.
    // The size requested contains the required size to be allocated on vram.
    tay
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE,y
    sta vram_size_required
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE+1,y
    sta vram_size_required+1
    // bool vram_has_free = vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required)
    // [165] vera_heap_has_free::s = 1 -- vbum1=vbuc1 
    // We check if the vram heap has sufficient memory available for the size requested.
    // We also check if the lru cache has sufficient elements left to contain the new sprite image.
    lda #1
    sta lib_veraheap.vera_heap_has_free.s
    // [166] vera_heap_has_free::size_requested = sprite_image_cache_vram::vram_size_required#0 -- vwum1=vwum2 
    lda vram_size_required
    sta lib_veraheap.vera_heap_has_free.size_requested
    lda vram_size_required+1
    sta lib_veraheap.vera_heap_has_free.size_requested+1
    // [167] callexecute vera_heap_has_free  -- call_var_near 
    jsr lib_veraheap.vera_heap_has_free
    // [168] sprite_image_cache_vram::vram_has_free#0 = vera_heap_has_free::return -- vbom1=vbom2 
    lda lib_veraheap.vera_heap_has_free.return
    sta vram_has_free
    // bool lru_cache_max = lru_cache_is_max()
    // [169] callexecute lru_cache_is_max  -- call_var_near 
    jsr lib_lru_cache.lru_cache_is_max
    // [170] sprite_image_cache_vram::lru_cache_max#0 = lru_cache_is_max::return -- vboaa=vbom1 
    lda lib_lru_cache.lru_cache_is_max.return
    // [171] phi from sprite_image_cache_vram::@6 sprite_image_cache_vram::@8 to sprite_image_cache_vram::@3 [phi:sprite_image_cache_vram::@6/sprite_image_cache_vram::@8->sprite_image_cache_vram::@3]
  __b3:
    // [171] phi sprite_image_cache_vram::lru_cache_max#2 = sprite_image_cache_vram::lru_cache_max#1 [phi:sprite_image_cache_vram::@6/sprite_image_cache_vram::@8->sprite_image_cache_vram::@3#0] -- register_copy 
    // [171] phi sprite_image_cache_vram::vram_has_free#2 = sprite_image_cache_vram::vram_has_free#1 [phi:sprite_image_cache_vram::@6/sprite_image_cache_vram::@8->sprite_image_cache_vram::@3#1] -- register_copy 
  // Free up the lru_cache and vram memory until the requested size is available!
  // This ensures that vram has sufficient place to allocate the new sprite image.
    // sprite_image_cache_vram::@3
    // while (lru_cache_max || !vram_has_free)
    // [172] if(sprite_image_cache_vram::lru_cache_max#2) goto sprite_image_cache_vram::@4 -- vboaa_then_la1 
    cmp #0
    bne __b4
    // sprite_image_cache_vram::@12
    // [173] if(sprite_image_cache_vram::vram_has_free#2) goto sprite_image_cache_vram::@5 -- vbom1_then_la1 
    lda vram_has_free
    cmp #0
    bne __b5
    // [174] phi from sprite_image_cache_vram::@12 sprite_image_cache_vram::@3 to sprite_image_cache_vram::@4 [phi:sprite_image_cache_vram::@12/sprite_image_cache_vram::@3->sprite_image_cache_vram::@4]
    // sprite_image_cache_vram::@4
  __b4:
    // lru_cache_key_t vram_last = lru_cache_find_last()
    // [175] callexecute lru_cache_find_last  -- call_var_near 
    jsr lib_lru_cache.lru_cache_find_last
    // [176] sprite_image_cache_vram::vram_last#0 = lru_cache_find_last::return -- vwum1=vwum2 
    lda lib_lru_cache.lru_cache_find_last.return
    sta vram_last
    lda lib_lru_cache.lru_cache_find_last.return+1
    sta vram_last+1
    // lru_cache_data_t vram_handle = lru_cache_delete(vram_last)
    // [177] lru_cache_delete::key = sprite_image_cache_vram::vram_last#0 -- vwum1=vwum2 
    // We delete the least used image from the vram cache, and this function returns the stored vram handle obtained by the vram heap manager.
    lda vram_last
    sta lib_lru_cache.lru_cache_delete.key
    lda vram_last+1
    sta lib_lru_cache.lru_cache_delete.key+1
    // [178] callexecute lru_cache_delete  -- call_var_near 
    jsr lib_lru_cache.lru_cache_delete
    // [179] sprite_image_cache_vram::vram_handle#0 = lru_cache_delete::return -- vwum1=vwum2 
    lda lib_lru_cache.lru_cache_delete.return
    sta vram_handle
    lda lib_lru_cache.lru_cache_delete.return+1
    sta vram_handle+1
    // if (vram_handle == 0xFFFF)
    // [180] if(sprite_image_cache_vram::vram_handle#0!=$ffff) goto sprite_image_cache_vram::@6 -- vwum1_neq_vwuc1_then_la1 
    cmp #>$ffff
    bne __b6
    lda vram_handle
    cmp #<$ffff
    // [181] phi from sprite_image_cache_vram::@4 to sprite_image_cache_vram::@7 [phi:sprite_image_cache_vram::@4->sprite_image_cache_vram::@7]
    // sprite_image_cache_vram::@7
    // sprite_image_cache_vram::@6
  __b6:
    // BYTE0(vram_handle)
    // [182] sprite_image_cache_vram::$12 = byte0  sprite_image_cache_vram::vram_handle#0 -- vbuxx=_byte0_vwum1 
    ldx vram_handle
    // vera_heap_free(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [183] vera_heap_free::s = 1 -- vbum1=vbuc1 
    // And we free the vram heap with the vram handle that we received.
    // But before we can free the heap, we must first convert back from the sprite offset to the vram address.
    // And then to a valid vram handle :-).
    lda #1
    sta lib_veraheap.vera_heap_free.s
    // [184] vera_heap_free::free_index = sprite_image_cache_vram::$12 -- vbum1=vbuxx 
    stx lib_veraheap.vera_heap_free.free_index
    // [185] callexecute vera_heap_free  -- call_var_near 
    jsr lib_veraheap.vera_heap_free
    // vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required)
    // [186] vera_heap_has_free::s = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_veraheap.vera_heap_has_free.s
    // [187] vera_heap_has_free::size_requested = sprite_image_cache_vram::vram_size_required#0 -- vwum1=vwum2 
    lda vram_size_required
    sta lib_veraheap.vera_heap_has_free.size_requested
    lda vram_size_required+1
    sta lib_veraheap.vera_heap_has_free.size_requested+1
    // [188] callexecute vera_heap_has_free  -- call_var_near 
    jsr lib_veraheap.vera_heap_has_free
    // vram_has_free = vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required)
    // [189] sprite_image_cache_vram::vram_has_free#1 = vera_heap_has_free::return -- vbom1=vbom2 
    lda lib_veraheap.vera_heap_has_free.return
    sta vram_has_free
    // lru_cache_is_max()
    // [190] callexecute lru_cache_is_max  -- call_var_near 
    jsr lib_lru_cache.lru_cache_is_max
    // lru_cache_max = lru_cache_is_max()
    // [191] sprite_image_cache_vram::lru_cache_max#1 = lru_cache_is_max::return -- vboaa=vbom1 
    lda lib_lru_cache.lru_cache_is_max.return
    jmp __b3
    // sprite_image_cache_vram::@5
  __b5:
    // vera_heap_index_t vram_handle = vera_heap_alloc(VERA_HEAP_SEGMENT_SPRITES, (unsigned long)sprite_cache.size[sprite_cache_index])
    // [192] sprite_image_cache_vram::$38 = sprite_image_cache_vram::sprite_cache_index << 1 -- vbuxx=vbum1_rol_1 
    lda sprite_cache_index
    asl
    tax
    // [193] vera_heap_alloc::s = 1 -- vbum1=vbuc1 
    // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
    // Dynamic allocation of sprites in vera vram.
    lda #1
    sta lib_veraheap.vera_heap_alloc.s
    // [194] vera_heap_alloc::size = (unsigned long)((unsigned int *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE)[sprite_image_cache_vram::$38] -- vdum1=_dword_pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE,x
    sta lib_veraheap.vera_heap_alloc.size
    inx
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE,x
    sta lib_veraheap.vera_heap_alloc.size+1
    lda #0
    sta lib_veraheap.vera_heap_alloc.size+2
    sta lib_veraheap.vera_heap_alloc.size+3
    // [195] callexecute vera_heap_alloc  -- call_var_near 
    jsr lib_veraheap.vera_heap_alloc
    // [196] sprite_image_cache_vram::vram_handle1#0 = vera_heap_alloc::return -- vbum1=vbum2 
    lda lib_veraheap.vera_heap_alloc.return
    sta vram_handle1
    // BYTE0(vram_handle)
    // [197] sprite_image_cache_vram::$17 = byte0  sprite_image_cache_vram::vram_handle1#0 -- vbuxx=_byte0_vbum1 
    tax
    // vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [198] vera_heap_data_get_bank::s = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_veraheap.vera_heap_data_get_bank.s
    // [199] vera_heap_data_get_bank::index = sprite_image_cache_vram::$17 -- vbum1=vbuxx 
    stx lib_veraheap.vera_heap_data_get_bank.index
    // [200] callexecute vera_heap_data_get_bank  -- call_var_near 
    jsr lib_veraheap.vera_heap_data_get_bank
    // [201] sprite_image_cache_vram::vram_bank#0 = vera_heap_data_get_bank::return -- vbum1=vbum2 
    lda lib_veraheap.vera_heap_data_get_bank.return
    sta vram_bank
    // BYTE0(vram_handle)
    // [202] sprite_image_cache_vram::$19 = byte0  sprite_image_cache_vram::vram_handle1#0 -- vbuxx=_byte0_vbum1 
    lda vram_handle1
    tax
    // vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [203] vera_heap_data_get_offset::s = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_veraheap.vera_heap_data_get_offset.s
    // [204] vera_heap_data_get_offset::index = sprite_image_cache_vram::$19 -- vbum1=vbuxx 
    stx lib_veraheap.vera_heap_data_get_offset.index
    // [205] callexecute vera_heap_data_get_offset  -- call_var_near 
    jsr lib_veraheap.vera_heap_data_get_offset
    // [206] sprite_image_cache_vram::vram_offset#0 = vera_heap_data_get_offset::return -- vwum1=vwum2 
    lda lib_veraheap.vera_heap_data_get_offset.return
    sta vram_offset
    lda lib_veraheap.vera_heap_data_get_offset.return+1
    sta vram_offset+1
    // sprite_image_cache_vram::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [208] BRAM = sprite_image_cache_vram::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // sprite_image_cache_vram::@9
    // sprite_bram_handles_t handle_bram = sprite_bram_handles[image_index]
    // [209] sprite_image_cache_vram::$40 = sprite_bram_handles + sprite_image_cache_vram::image_index#0 -- pbuz1=pbuc1_plus_vwum2 
    lda image_index
    clc
    adc #<sprite_bram_handles
    sta.z sprite_image_cache_vram__40
    lda image_index+1
    adc #>sprite_bram_handles
    sta.z sprite_image_cache_vram__40+1
    // [210] sprite_image_cache_vram::handle_bram#0 = *sprite_image_cache_vram::$40 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (sprite_image_cache_vram__40),y
    sta handle_bram
    // sprite_image_cache_vram::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // sprite_image_cache_vram::@10
    // bram_bank_t sprite_bank = bram_heap_data_get_bank(0, handle_bram)
    // [212] bram_heap_data_get_bank::s = 0 -- vbum1=vbuc1 
    tya
    sta lib_bramheap.bram_heap_data_get_bank.s
    // [213] bram_heap_data_get_bank::index = sprite_image_cache_vram::handle_bram#0 -- vbum1=vbum2 
    lda handle_bram
    sta lib_bramheap.bram_heap_data_get_bank.index
    // [214] callexecute bram_heap_data_get_bank  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_bank
    // [215] sprite_image_cache_vram::sprite_bank#0 = bram_heap_data_get_bank::return -- vbum1=vbum2 
    lda lib_bramheap.bram_heap_data_get_bank.return
    sta sprite_bank
    // bram_ptr_t sprite_ptr = bram_heap_data_get_offset(0, handle_bram)
    // [216] bram_heap_data_get_offset::s = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_bramheap.bram_heap_data_get_offset.s
    // [217] bram_heap_data_get_offset::index = sprite_image_cache_vram::handle_bram#0 -- vbum1=vbum2 
    lda handle_bram
    sta lib_bramheap.bram_heap_data_get_offset.index
    // [218] callexecute bram_heap_data_get_offset  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_offset
    // [219] sprite_image_cache_vram::sprite_ptr#0 = bram_heap_data_get_offset::return -- pbuz1=pbuz2 
    lda.z lib_bramheap.bram_heap_data_get_offset.return
    sta.z sprite_ptr
    lda.z lib_bramheap.bram_heap_data_get_offset.return+1
    sta.z sprite_ptr+1
    // unsigned int sprite_size = sprite_cache.size[sprite_cache_index]
    // [220] sprite_image_cache_vram::$39 = sprite_image_cache_vram::sprite_cache_index << 1 -- vbuaa=vbum1_rol_1 
    lda sprite_cache_index
    asl
    // [221] sprite_image_cache_vram::sprite_size#0 = ((unsigned int *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE)[sprite_image_cache_vram::$39] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE,y
    sta sprite_size
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE+1,y
    sta sprite_size+1
    // memcpy_vram_bram(vram_bank, vram_offset, sprite_bank, sprite_ptr, sprite_size)
    // [222] memcpy_vram_bram::dbank_vram#0 = sprite_image_cache_vram::vram_bank#0 -- vbuxx=vbum1 
    ldx vram_bank
    // [223] memcpy_vram_bram::doffset_vram#0 = sprite_image_cache_vram::vram_offset#0 -- vwum1=vwum2 
    lda vram_offset
    sta memcpy_vram_bram.doffset_vram
    lda vram_offset+1
    sta memcpy_vram_bram.doffset_vram+1
    // [224] memcpy_vram_bram::sbank_bram#2 = sprite_image_cache_vram::sprite_bank#0 -- vbum1=vbum2 
    lda sprite_bank
    sta memcpy_vram_bram.sbank_bram
    // [225] memcpy_vram_bram::sptr_bram#0 = sprite_image_cache_vram::sprite_ptr#0 -- pbuz1=pbuz2 
    lda.z sprite_ptr
    sta.z memcpy_vram_bram.sptr_bram
    lda.z sprite_ptr+1
    sta.z memcpy_vram_bram.sptr_bram+1
    // [226] memcpy_vram_bram::num = sprite_image_cache_vram::sprite_size#0 -- vwum1=vwum2 
    lda sprite_size
    sta memcpy_vram_bram.num
    lda sprite_size+1
    sta memcpy_vram_bram.num+1
    // [227] call memcpy_vram_bram
    // [481] phi from sprite_image_cache_vram::@10 to memcpy_vram_bram [phi:sprite_image_cache_vram::@10->memcpy_vram_bram]
    jsr memcpy_vram_bram
    // sprite_image_cache_vram::vera_sprite_get_image_offset1
    // vera_sprite_image_offset sprite_image_offset = offset >> 5
    // [228] sprite_image_cache_vram::vera_sprite_get_image_offset1_sprite_image_offset#0 = sprite_image_cache_vram::vram_offset#0 >> 5 -- vwum1=vwum2_ror_5 
    lda vram_offset+1
    lsr
    sta vera_sprite_get_image_offset1_sprite_image_offset+1
    lda vram_offset
    ror
    sta vera_sprite_get_image_offset1_sprite_image_offset
    lsr vera_sprite_get_image_offset1_sprite_image_offset+1
    ror vera_sprite_get_image_offset1_sprite_image_offset
    lsr vera_sprite_get_image_offset1_sprite_image_offset+1
    ror vera_sprite_get_image_offset1_sprite_image_offset
    lsr vera_sprite_get_image_offset1_sprite_image_offset+1
    ror vera_sprite_get_image_offset1_sprite_image_offset
    lsr vera_sprite_get_image_offset1_sprite_image_offset+1
    ror vera_sprite_get_image_offset1_sprite_image_offset
    // (unsigned int)bank << 11
    // [229] sprite_image_cache_vram::vera_sprite_get_image_offset1_$2 = (unsigned int)sprite_image_cache_vram::vram_bank#0 -- vwum1=_word_vbum2 
    lda vram_bank
    sta vera_sprite_get_image_offset1_sprite_image_cache_vram__2
    lda #0
    sta vera_sprite_get_image_offset1_sprite_image_cache_vram__2+1
    // [230] sprite_image_cache_vram::vera_sprite_get_image_offset1_$1 = sprite_image_cache_vram::vera_sprite_get_image_offset1_$2 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl vera_sprite_get_image_offset1_sprite_image_cache_vram__1
    rol vera_sprite_get_image_offset1_sprite_image_cache_vram__1+1
    dey
    bne !-
  !e:
    // sprite_image_offset |= ((unsigned int)bank << 11)
    // [231] sprite_image_cache_vram::vera_sprite_get_image_offset1_return#0 = sprite_image_cache_vram::vera_sprite_get_image_offset1_sprite_image_offset#0 | sprite_image_cache_vram::vera_sprite_get_image_offset1_$1 -- vwum1=vwum2_bor_vwum3 
    lda vera_sprite_get_image_offset1_sprite_image_offset
    ora vera_sprite_get_image_offset1_sprite_image_cache_vram__1
    sta vera_sprite_get_image_offset1_return
    lda vera_sprite_get_image_offset1_sprite_image_offset+1
    ora vera_sprite_get_image_offset1_sprite_image_cache_vram__1+1
    sta vera_sprite_get_image_offset1_return+1
    // sprite_image_cache_vram::@11
    // vera_heap_set_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle, sprite_offset)
    // [232] vera_heap_set_image::s = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_veraheap.vera_heap_set_image.s
    // [233] vera_heap_set_image::index = sprite_image_cache_vram::vram_handle1#0 -- vbum1=vbum2 
    lda vram_handle1
    sta lib_veraheap.vera_heap_set_image.index
    // [234] vera_heap_set_image::image = sprite_image_cache_vram::vera_sprite_get_image_offset1_return#0 -- vwum1=vwum2 
    lda vera_sprite_get_image_offset1_return
    sta lib_veraheap.vera_heap_set_image.image
    lda vera_sprite_get_image_offset1_return+1
    sta lib_veraheap.vera_heap_set_image.image+1
    // [235] callexecute vera_heap_set_image  -- call_var_near 
    jsr lib_veraheap.vera_heap_set_image
    // lru_cache_insert(image_index, (lru_cache_data_t)vram_handle)
    // [236] lru_cache_insert::key = sprite_image_cache_vram::image_index#0 -- vwum1=vwum2 
    lda image_index
    sta lib_lru_cache.lru_cache_insert.key
    lda image_index+1
    sta lib_lru_cache.lru_cache_insert.key+1
    // [237] lru_cache_insert::data = (unsigned int)sprite_image_cache_vram::vram_handle1#0 -- vwum1=_word_vbum2 
    lda vram_handle1
    sta lib_lru_cache.lru_cache_insert.data
    lda #0
    sta lib_lru_cache.lru_cache_insert.data+1
    // [238] callexecute lru_cache_insert  -- call_var_near 
    jsr lib_lru_cache.lru_cache_insert
    // sprite_image_cache_vram::vera_display_set_border_color2
    // *VERA_CTRL &= 0b10000001
    // [239] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [240] *VERA_DC_BORDER = BLACK -- _deref_pbuc1=vbuc2 
    lda #BLACK
    sta VERA_DC_BORDER
    // [241] phi from sprite_image_cache_vram::@1 sprite_image_cache_vram::vera_display_set_border_color2 to sprite_image_cache_vram::@2 [phi:sprite_image_cache_vram::@1/sprite_image_cache_vram::vera_display_set_border_color2->sprite_image_cache_vram::@2]
    // [241] phi sprite_image_cache_vram::sprite_offset#3 = sprite_image_cache_vram::sprite_offset#1 [phi:sprite_image_cache_vram::@1/sprite_image_cache_vram::vera_display_set_border_color2->sprite_image_cache_vram::@2#0] -- register_copy 
    // sprite_image_cache_vram::@2
    // return sprite_offset;
    // [242] sprite_image_cache_vram::return = sprite_image_cache_vram::sprite_offset#3
  // We return the image offset in vram of the sprite to be drawn.
  // This offset is used by the vera image set offset function to directly change the image displayed of the sprite!
    // sprite_image_cache_vram::@return
    // }
    // [243] return 
    rts
    // sprite_image_cache_vram::@1
  __b1:
    // lru_cache_get(vram_index)
    // [244] lru_cache_get::index = sprite_image_cache_vram::vram_index#0 -- vbum1=vbuaa 
    sta lib_lru_cache.lru_cache_get.index
    // [245] callexecute lru_cache_get  -- call_var_near 
    jsr lib_lru_cache.lru_cache_get
    // [246] sprite_image_cache_vram::$30 = lru_cache_get::return -- vwum1=vwum2 
    lda lib_lru_cache.lru_cache_get.return
    sta sprite_image_cache_vram__30
    lda lib_lru_cache.lru_cache_get.return+1
    sta sprite_image_cache_vram__30+1
    // vera_heap_index_t vram_handle = (vera_heap_index_t)lru_cache_get(vram_index)
    // [247] sprite_image_cache_vram::vram_handle2#0 = (char)sprite_image_cache_vram::$30 -- vbum1=_byte_vwum2 
    // So we have a cache hit, so we can re-use the same image from the cache and we win time!
    lda sprite_image_cache_vram__30
    sta vram_handle2
    // BYTE0(vram_handle)
    // [248] sprite_image_cache_vram::$31 = byte0  sprite_image_cache_vram::vram_handle2#0 -- vbuxx=_byte0_vbum1 
    tax
    // vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [249] vera_heap_data_get_bank::s = 1 -- vbum1=vbuc1 
    // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
    // Dynamic allocation of sprites in vera vram.
    lda #1
    sta lib_veraheap.vera_heap_data_get_bank.s
    // [250] vera_heap_data_get_bank::index = sprite_image_cache_vram::$31 -- vbum1=vbuxx 
    stx lib_veraheap.vera_heap_data_get_bank.index
    // [251] callexecute vera_heap_data_get_bank  -- call_var_near 
    jsr lib_veraheap.vera_heap_data_get_bank
    // BYTE0(vram_handle)
    // [252] sprite_image_cache_vram::$33 = byte0  sprite_image_cache_vram::vram_handle2#0 -- vbuxx=_byte0_vbum1 
    lda vram_handle2
    tax
    // vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [253] vera_heap_data_get_offset::s = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_veraheap.vera_heap_data_get_offset.s
    // [254] vera_heap_data_get_offset::index = sprite_image_cache_vram::$33 -- vbum1=vbuxx 
    stx lib_veraheap.vera_heap_data_get_offset.index
    // [255] callexecute vera_heap_data_get_offset  -- call_var_near 
    jsr lib_veraheap.vera_heap_data_get_offset
    // vera_heap_get_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle)
    // [256] vera_heap_get_image::s = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_veraheap.vera_heap_get_image.s
    // [257] vera_heap_get_image::index = sprite_image_cache_vram::vram_handle2#0 -- vbum1=vbum2 
    lda vram_handle2
    sta lib_veraheap.vera_heap_get_image.index
    // [258] callexecute vera_heap_get_image  -- call_var_near 
    jsr lib_veraheap.vera_heap_get_image
    // sprite_offset = vera_heap_get_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle)
    // [259] sprite_image_cache_vram::sprite_offset#1 = vera_heap_get_image::return -- vwum1=vwum2 
    lda lib_veraheap.vera_heap_get_image.return
    sta sprite_offset
    lda lib_veraheap.vera_heap_get_image.return+1
    sta sprite_offset+1
    rts
  .segment DataEngineFlight
    sprite_cache_index: .byte 0
    .label fe_sprite_image_index = flight_draw.s
    .label return = sprite_offset
    .label sprite_image_cache_vram__30 = sprite_offset
  .segment Data
    .label vera_sprite_get_image_offset1_sprite_image_cache_vram__1 = vera_sprite_get_image_offset1_sprite_image_cache_vram__2
    vera_sprite_get_image_offset1_sprite_image_cache_vram__2: .word 0
  .segment DataEngineFlight
    image_index: .word 0
    .label vram_handle2 = fe_sprite_bram_load.s
    // lru_cache_data_t lru_cache_data;
    sprite_offset: .word 0
    .label vram_size_required = sprite_offset
    .label vram_has_free = fe_sprite_bram_load.s
    .label vram_last = fe_sprite_bram_load.return
    .label vram_handle = fe_sprite_bram_load.return
    vram_handle1: .byte 0
    vram_bank: .byte 0
    vram_offset: .word 0
    handle_bram: .byte 0
    sprite_bank: .byte 0
    .label sprite_size = sprite_offset
  .segment Data
    .label vera_sprite_get_image_offset1_sprite_image_offset = strlen.len
    .label vera_sprite_get_image_offset1_return = sprite_offset
}
.segment CodeEngineFlight
  // flight_has_collided
// This will need rework
// __mem() char flight_has_collided(__mem() char f)
flight_has_collided: {
    // unsigned char collided = flight.collided[f]
    // [260] flight_has_collided::collided#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED)[flight_has_collided::f] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy f
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED,y
    // flight.collided[f] = 1
    // [261] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED)[flight_has_collided::f] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED,y
    // return collided;
    // [262] flight_has_collided::return = flight_has_collided::collided#0 -- vbum1=vbuxx 
    stx return
    // flight_has_collided::@return
    // }
    // [263] return 
    rts
  .segment DataEngineFlight
    .label f = flight_draw.f
    .label return = flight_draw.f
}
.segment CodeEngineFlight
  // flight_hit
// __mem() signed char flight_hit(__mem() char f, __mem() signed char impact)
flight_hit: {
    // flight.health[f] += impact
    // [264] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[flight_hit::f] = ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[flight_hit::f] + flight_hit::impact -- pbsc1_derefidx_vbum1=pbsc1_derefidx_vbum1_plus_vbsm2 
    lda impact
    ldy f
    clc
    adc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    // if(flight.health[f] <= 0)
    // [265] if(((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[flight_hit::f]>0) goto flight_hit::@1 -- pbsc1_derefidx_vbum1_gt_0_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    cmp #0
    beq !+
    bpl __b1
  !:
    // flight_hit::@2
    // flight.collided[f] = 1
    // [266] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED)[flight_hit::f] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    ldy f
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED,y
    // return 1;
    // [267] flight_hit::return = 1 -- vbsm1=vbsc1 
    sta return
    // flight_hit::@return
    // }
    // [268] return 
    rts
    // flight_hit::@1
  __b1:
    // return 0;
    // [269] flight_hit::return = 0 -- vbsm1=vbsc1 
    lda #0
    sta return
    rts
  .segment DataEngineFlight
    .label f = flight_draw.f
    .label impact = fe_sprite_bram_load.s
    .label return = flight_draw.f
}
.segment CodeEngineFlight
  // flight_impact
// __mem() signed char flight_impact(__mem() char f)
flight_impact: {
    // signed char impact = flight.impact[f]
    // [270] flight_impact::impact#0 = ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_IMPACT)[flight_impact::f] -- vbsaa=pbsc1_derefidx_vbum1 
    ldy f
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_IMPACT,y
    // return impact;
    // [271] flight_impact::return = flight_impact::impact#0 -- vbsm1=vbsaa 
    sta return
    // flight_impact::@return
    // }
    // [272] return 
    rts
  .segment DataEngineFlight
    .label f = flight_draw.f
    .label return = flight_draw.f
}
.segment CodeEngineFlight
  // flight_next
// __mem() char flight_next(__mem() char i)
flight_next: {
    // return flight.next[i];
    // [273] flight_next::return = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_NEXT)[flight_next::i] -- vbum1=pbuc1_derefidx_vbum2 
    ldy i
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_NEXT,y
    sta return
    // flight_next::@return
    // }
    // [274] return 
    rts
  .segment DataEngineFlight
    .label i = fe_sprite_bram_load.s
    .label return = flight_draw.f
}
.segment CodeEngineFlight
  // flight_root
// __mem() char flight_root(__mem() char type)
flight_root: {
    // return flight.root[type];
    // [275] flight_root::return = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ROOT)[flight_root::type] -- vbum1=pbuc1_derefidx_vbum2 
    ldy type
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT,y
    sta return
    // flight_root::@return
    // }
    // [276] return 
    rts
  .segment DataEngineFlight
    .label type = fe_sprite_bram_load.s
    .label return = flight_draw.f
}
.segment CodeEngineFlight
  // flight_remove
// void flight_remove(__mem() char type, __mem() char f)
flight_remove: {
    .const vera_sprite_disable1_vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // if (flight.used[f])
    // [277] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[flight_remove::f]) goto flight_remove::@return -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy f
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    bne !__breturn+
    jmp __breturn
  !__breturn:
    // flight_remove::@1
    // flight.used[f] = 0
    // [278] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[flight_remove::f] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    // flight.enabled[f] = 0
    // [279] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ENABLED)[flight_remove::f] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ENABLED,y
    // flight.collided[f] = 1
    // [280] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED)[flight_remove::f] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED,y
    // flight.count[type]--;
    // [281] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COUNT)[flight_remove::type] = -- ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COUNT)[flight_remove::type] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx type
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COUNT,x
    // vera_sprite_offset sprite_offset = flight.sprite_offset[f]
    // [282] flight_remove::$11 = flight_remove::f << 1 -- vbuaa=vbum1_rol_1 
    tya
    asl
    // [283] flight_remove::sprite_offset#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET)[flight_remove::$11] -- vwum1=pwuc1_derefidx_vbuaa 
    // p.r = 4 => f[4].n = 3, f[3].n = 2, f[2].n = 1, f[1].n = -
    // p.r = 4 => f[4].p = -, f[3].p = 4, f[2].p = 3, f[1].p = 2
    // Remove 4
    // p.r = 3 => f[3].n = 2, f[2].n = 1, f[1].n = -
    //         => f[3].p = -, f[2].p = 3, f[1].p = 2
    tay
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET,y
    sta sprite_offset
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET+1,y
    sta sprite_offset+1
    // flight_sprite_free_offset(sprite_offset)
    // [284] flight_sprite_free_offset::sprite_offset#0 = flight_remove::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta flight_sprite_free_offset.sprite_offset
    lda sprite_offset+1
    sta flight_sprite_free_offset.sprite_offset+1
    // [285] call flight_sprite_free_offset
    // [528] phi from flight_remove::@1 to flight_sprite_free_offset [phi:flight_remove::@1->flight_sprite_free_offset]
    jsr flight_sprite_free_offset
    // flight_remove::vera_sprite_disable1
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0)
    // [286] flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_offset#0 = flight_remove::sprite_offset#0 + 6 -- vwum1=vwum2_plus_vbuc1 
    lda #6
    clc
    adc sprite_offset
    sta vera_sprite_disable1_vera_vram_data0_bank_offset1_offset
    lda #0
    adc sprite_offset+1
    sta vera_sprite_disable1_vera_vram_data0_bank_offset1_offset+1
    // flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [287] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [288] flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_$0 = byte0  flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_sprite_disable1_vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [289] *VERA_ADDRX_L = flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [290] flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_$1 = byte1  flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_sprite_disable1_vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [291] *VERA_ADDRX_M = flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [292] *VERA_ADDRX_H = flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_sprite_disable1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // flight_remove::vera_sprite_disable1_@1
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [293] flight_remove::vera_sprite_disable1_$2 = *VERA_DATA0 & ~$c -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$c^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [294] *VERA_DATA0 = flight_remove::vera_sprite_disable1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // flight_remove::@10
    // palette_unuse_vram(sprite_cache.palette_offset[flight.cache[f]])
    // [295] palette_unuse_vram::bram_index = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET)[((char *)&flight)[flight_remove::f]] -- vwum1=pbuc1_derefidx_(pbuc2_derefidx_vbum2) 
    ldx f
    ldy equinoxe_flightengine.flight,x
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET,y
    sta equinoxe_palette.palette_unuse_vram.bram_index
    lda #0
    sta equinoxe_palette.palette_unuse_vram.bram_index+1
    // [296] callexecute palette_unuse_vram  -- call_var_near 
    jsr equinoxe_palette.palette_unuse_vram
    // fe_sprite_cache_free(flight.cache[f])
    // [297] fe_sprite_cache_free::fe_sprite_index#0 = ((char *)&flight)[flight_remove::f] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy f
    ldx equinoxe_flightengine.flight,y
    // [298] call fe_sprite_cache_free
    jsr fe_sprite_cache_free
    // flight_remove::@11
    // flight_index_t r = flight.root[type]
    // [299] flight_remove::r#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ROOT)[flight_remove::type] -- vbum1=pbuc1_derefidx_vbum2 
    ldy type
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT,y
    sta r
    // if(!flight.next[r])
    // [300] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_NEXT)[flight_remove::r#0]) goto flight_remove::@4 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    tay
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_NEXT,y
    cmp #0
    beq __b4
    // flight_remove::@2
    // flight_index_t n = flight.next[f]
    // [301] flight_remove::n#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_NEXT)[flight_remove::f] -- vbum1=pbuc1_derefidx_vbum2 
    ldy f
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_NEXT,y
    sta n
    // flight_index_t p = flight.prev[f]
    // [302] flight_remove::p#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_PREV)[flight_remove::f] -- vbuxx=pbuc1_derefidx_vbum1 
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_PREV,y
    // if (n)
    // [303] if(0==flight_remove::n#0) goto flight_remove::@5 -- 0_eq_vbum1_then_la1 
    beq __b5
    // flight_remove::@3
    // flight.prev[n] = p
    // [304] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_PREV)[flight_remove::n#0] = flight_remove::p#0 -- pbuc1_derefidx_vbum1=vbuxx 
    tay
    txa
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_PREV,y
    // flight_remove::@5
  __b5:
    // if (p)
    // [305] if(0==flight_remove::p#0) goto flight_remove::@6 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq __b6
    // flight_remove::@7
    // flight.next[p] = n
    // [306] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_NEXT)[flight_remove::p#0] = flight_remove::n#0 -- pbuc1_derefidx_vbuxx=vbum1 
    lda n
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_NEXT,x
    // flight_remove::@6
  __b6:
    // if (r == f)
    // [307] if(flight_remove::r#0!=flight_remove::f) goto flight_remove::@9 -- vbum1_neq_vbum2_then_la1 
    lda r
    cmp f
    bne __b9
    // flight_remove::@8
    // flight.root[type] = n
    // [308] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ROOT)[flight_remove::type] = flight_remove::n#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda n
    ldy type
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT,y
    // flight_remove::@9
  __b9:
    // flight.next[f] = NULL
    // [309] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_NEXT)[flight_remove::f] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy f
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_NEXT,y
    // flight.prev[f] = NULL
    // [310] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_PREV)[flight_remove::f] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_PREV,y
    // flight_remove::@return
  __breturn:
    // }
    // [311] return 
    rts
    // flight_remove::@4
  __b4:
    // flight.root[type] = NULL
    // [312] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ROOT)[flight_remove::type] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy type
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT,y
    jmp __b9
  .segment DataEngineFlight
    .label type = flight_draw.s
    .label f = equinoxe_flightengine.sprite_image_cache_vram.sprite_cache_index
    .label sprite_offset = sprite_image_cache_vram.sprite_offset
  .segment Data
    .label vera_sprite_disable1_vera_vram_data0_bank_offset1_offset = strlen.len
  .segment DataEngineFlight
    .label r = flight_draw.f
    .label n = fe_sprite_bram_load.s
}
.segment CodeEngineFlight
  // flight_add
// __mem() char flight_add(__mem() char type, __mem() char side, __mem() char sprite)
flight_add: {
    // unsigned char f = flight.index % FLIGHT_OBJECTS
    // [313] flight_add::f#0 = *((char *)&flight+OFFSET_STRUCT_FLIGHT_T_INDEX) & $40-1 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$40-1
    and equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_INDEX
    sta f
    // [314] phi from flight_add flight_add::@3 to flight_add::@2 [phi:flight_add/flight_add::@3->flight_add::@2]
    // [314] phi flight_add::f#2 = flight_add::f#0 [phi:flight_add/flight_add::@3->flight_add::@2#0] -- register_copy 
    // flight_add::@2
  __b2:
    // while (!f || flight.used[f])
    // [315] if(0==flight_add::f#2) goto flight_add::@3 -- 0_eq_vbum1_then_la1 
    lda f
    bne !__b3+
    jmp __b3
  !__b3:
    // flight_add::@9
    // [316] if(0!=((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[flight_add::f#2]) goto flight_add::@3 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    tay
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    beq !__b3+
    jmp __b3
  !__b3:
    // flight_add::@4
    // flight.index = f
    // [317] *((char *)&flight+OFFSET_STRUCT_FLIGHT_T_INDEX) = flight_add::f#2 -- _deref_pbuc1=vbum1 
    tya
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_INDEX
    // flight_index_t r = flight.root[type]
    // [318] flight_add::r#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ROOT)[flight_add::type] -- vbuxx=pbuc1_derefidx_vbum1 
    // p.r = 3 => f[3].n = 2, f[2].n = 1, f[1].n = -
    //         => f[3].p = -, f[2].p = 3, f[1].p = 2
    // Add 4
    // p.r = 4 => f[4].n = 3, f[3].n = 2, f[2].n = 1, f[1].n = -
    // p.r = 4 => f[4].p = -, f[3].p = 4, f[2].p = 3, f[1].p = 2
    ldy type
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT,y
    // flight.next[f] = r
    // [319] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_NEXT)[flight_add::f#2] = flight_add::r#0 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy f
    txa
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_NEXT,y
    // flight.prev[f] = NULL
    // [320] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_PREV)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_PREV,y
    // if (r)
    // [321] if(0==flight_add::r#0) goto flight_add::@1 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq __b1
    // flight_add::@5
    // flight.prev[r] = f
    // [322] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_PREV)[flight_add::r#0] = flight_add::f#2 -- pbuc1_derefidx_vbuxx=vbum1 
    tya
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_PREV,x
    // flight_add::@1
  __b1:
    // flight.root[type] = f
    // [323] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ROOT)[flight_add::type] = flight_add::f#2 -- pbuc1_derefidx_vbum1=vbum2 
    lda f
    ldy type
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT,y
    // flight.count[type]++;
    // [324] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COUNT)[flight_add::type] = ++ ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COUNT)[flight_add::type] -- pbuc1_derefidx_vbum1=_inc_pbuc1_derefidx_vbum1 
    ldx type
    inc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COUNT,x
    // flight.type[f] = type
    // [325] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[flight_add::f#2] = flight_add::type -- pbuc1_derefidx_vbum1=vbum2 
    txa
    ldy f
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    // flight.side[f] = side
    // [326] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SIDE)[flight_add::f#2] = flight_add::side -- pbuc1_derefidx_vbum1=vbum2 
    lda side
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SIDE,y
    // flight.used[f] = 1
    // [327] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[flight_add::f#2] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    // flight.enabled[f] = 0
    // [328] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ENABLED)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ENABLED,y
    // flight.move[f] = 0
    // [329] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    // flight.moved[f] = 0
    // [330] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVED)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVED,y
    // flight.moving[f] = 0
    // [331] flight_add::$13 = flight_add::f#2 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta flight_add__13
    // [332] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVING)[flight_add::$13] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy flight_add__13
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING+1,y
    // flight.angle[f] = 0
    // [333] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    ldy f
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // flight.speed[f] = 0
    // [334] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    // flight.action[f] = 0
    // [335] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ACTION)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ACTION,y
    // flight.turn[f] = 0
    // [336] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TURN)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TURN,y
    // flight.radius[f] = 0
    // [337] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RADIUS)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RADIUS,y
    // flight.reload[f] = 0
    // [338] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    // flight.delay[f] = 0
    // [339] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_DELAY)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_DELAY,y
    // unsigned char si = fe_sprite_cache_copy(sprite)
    // [340] fe_sprite_cache_copy::sprite_index#0 = flight_add::sprite
    // [341] call fe_sprite_cache_copy
    // [537] phi from flight_add::@1 to fe_sprite_cache_copy [phi:flight_add::@1->fe_sprite_cache_copy]
    jsr fe_sprite_cache_copy
    // unsigned char si = fe_sprite_cache_copy(sprite)
    // [342] fe_sprite_cache_copy::return#0 = fe_sprite_cache_copy::c#2 -- vbuaa=vbum1 
    lda fe_sprite_cache_copy.c
    // flight_add::@6
    // [343] flight_add::si#0 = fe_sprite_cache_copy::return#0 -- vbum1=vbuaa 
    sta si
    // flight.cache[f] = si
    // [344] ((char *)&flight)[flight_add::f#2] = flight_add::si#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy f
    sta equinoxe_flightengine.flight,y
    // flight_sprite_next_offset()
    // [345] call flight_sprite_next_offset
    // [583] phi from flight_add::@6 to flight_sprite_next_offset [phi:flight_add::@6->flight_sprite_next_offset]
    jsr flight_sprite_next_offset
    // flight_sprite_next_offset()
    // [346] flight_sprite_next_offset::return#0 = flight_sprite_next_offset::vera_sprite_get_offset1_return#0 -- vwum1=vwum2 
    lda flight_sprite_next_offset.vera_sprite_get_offset1_return
    sta flight_sprite_next_offset.return
    lda flight_sprite_next_offset.vera_sprite_get_offset1_return+1
    sta flight_sprite_next_offset.return+1
    // flight_add::@7
    // [347] flight_add::$4 = flight_sprite_next_offset::return#0
    // flight.sprite_offset[f] = flight_sprite_next_offset()
    // [348] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET)[flight_add::$13] = flight_add::$4 -- pwuc1_derefidx_vbum1=vwum2 
    ldy flight_add__13
    lda flight_add__4
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET,y
    lda flight_add__4+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET+1,y
    // fe_sprite_configure(flight.sprite_offset[f], si)
    // [349] fe_sprite_configure::sprite_offset#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET)[flight_add::$13] -- vwum1=pwuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET,y
    sta fe_sprite_configure.sprite_offset
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET+1,y
    sta fe_sprite_configure.sprite_offset+1
    // [350] fe_sprite_configure::s#0 = flight_add::si#0 -- vbuyy=vbum1 
    ldy si
    // [351] call fe_sprite_configure
    jsr fe_sprite_configure
    // flight_add::@8
    // return f;
    // [352] flight_add::return = flight_add::f#2
  // gotoxy(0,2);
  // printf("flight add:sprite offset %u = %x", f, sprite_offset);
    // flight_add::@return
    // }
    // [353] return 
    rts
    // flight_add::@3
  __b3:
    // f + 1
    // [354] flight_add::$8 = flight_add::f#2 + 1 -- vbuaa=vbum1_plus_1 
    lda f
    inc
    // f = (f + 1) % FLIGHT_OBJECTS
    // [355] flight_add::f#1 = flight_add::$8 & $40-1 -- vbum1=vbuaa_band_vbuc1 
    and #$40-1
    sta f
    jmp __b2
  .segment DataEngineFlight
    .label type = fe_sprite_bram_load.s
    .label side = flight_draw.s
    .label sprite = equinoxe_flightengine.sprite_image_cache_vram.sprite_cache_index
    .label return = flight_draw.f
    .label flight_add__4 = sprite_image_cache_vram.sprite_offset
    .label flight_add__13 = flight_draw.s
    .label f = flight_draw.f
    .label si = fe_sprite_bram_load.s
}
.segment Code
  // strcpy
// Copies the C string pointed by source into the array pointed by destination, including the terminating null character (and stopping at that point).
// char * strcpy(__zp($35) char *destination, __zp($33) char *source)
strcpy: {
    .label src = $33
    .label dst = $35
    .label destination = $35
    .label source = $33
    // [407] phi from strcpy strcpy::@2 to strcpy::@1 [phi:strcpy/strcpy::@2->strcpy::@1]
    // [407] phi strcpy::dst#2 = strcpy::dst#0 [phi:strcpy/strcpy::@2->strcpy::@1#0] -- register_copy 
    // [407] phi strcpy::src#2 = strcpy::src#0 [phi:strcpy/strcpy::@2->strcpy::@1#1] -- register_copy 
    // strcpy::@1
  __b1:
    // while(*src)
    // [408] if(0!=*strcpy::src#2) goto strcpy::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strcpy::@3
    // *dst = 0
    // [409] *strcpy::dst#2 = 0 -- _deref_pbuz1=vbuc1 
    tya
    tay
    sta (dst),y
    // strcpy::@return
    // }
    // [410] return 
    rts
    // strcpy::@2
  __b2:
    // *dst++ = *src++
    // [411] *strcpy::dst#2 = *strcpy::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [412] strcpy::dst#1 = ++ strcpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [413] strcpy::src#1 = ++ strcpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
  // strcat
// Concatenates the C string pointed by source into the array pointed by destination, including the terminating null character (and stopping at that point).
// char * strcat(char *destination, char *source)
strcat: {
    .label dst = $35
    .label src = $33
    // strlen(destination)
    // [415] call strlen
    // [634] phi from strcat to strlen [phi:strcat->strlen]
    jsr strlen
    // strlen(destination)
    // [416] strlen::return#0 = strlen::len#2
    // strcat::@4
    // [417] strcat::$0 = strlen::return#0
    // char* dst = destination + strlen(destination)
    // [418] strcat::dst#0 = fe_sprite_bram_load::filename + strcat::$0 -- pbuz1=pbuc1_plus_vwum2 
    lda strcat__0
    clc
    adc #<fe_sprite_bram_load.filename
    sta.z dst
    lda strcat__0+1
    adc #>fe_sprite_bram_load.filename
    sta.z dst+1
    // [419] phi from strcat::@4 to strcat::@1 [phi:strcat::@4->strcat::@1]
    // [419] phi strcat::dst#2 = strcat::dst#0 [phi:strcat::@4->strcat::@1#0] -- register_copy 
    // [419] phi strcat::src#2 = fe_sprite_bram_load::source [phi:strcat::@4->strcat::@1#1] -- pbuz1=pbuc1 
    lda #<fe_sprite_bram_load.source
    sta.z src
    lda #>fe_sprite_bram_load.source
    sta.z src+1
    // strcat::@1
  __b1:
    // while(*src)
    // [420] if(0!=*strcat::src#2) goto strcat::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strcat::@3
    // *dst = 0
    // [421] *strcat::dst#2 = 0 -- _deref_pbuz1=vbuc1 
    tya
    tay
    sta (dst),y
    // strcat::@return
    // }
    // [422] return 
    rts
    // strcat::@2
  __b2:
    // *dst++ = *src++
    // [423] *strcat::dst#2 = *strcat::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [424] strcat::dst#1 = ++ strcat::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [425] strcat::src#1 = ++ strcat::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [419] phi from strcat::@2 to strcat::@1 [phi:strcat::@2->strcat::@1]
    // [419] phi strcat::dst#2 = strcat::dst#1 [phi:strcat::@2->strcat::@1#0] -- register_copy 
    // [419] phi strcat::src#2 = strcat::src#1 [phi:strcat::@2->strcat::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label strcat__0 = strlen.len
}
.segment CodeEngineFlight
  // sprite_map_header
// void sprite_map_header(sprite_file_header_t *sprite_file_header, __mem() char sprite)
sprite_map_header: {
    .label sprite_file_header = fe_sprite_bram_load.sprite_file_header
    // sprites.count[sprite] = sprite_file_header->count
    // [426] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_COUNT)[sprite_map_header::sprite#0] = *((char *)sprite_map_header::sprite_file_header#0) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    lda sprite_file_header
    ldy sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_COUNT,y
    // sprites.SpriteSize[sprite] = sprite_file_header->size
    // [427] sprite_map_header::$8 = sprite_map_header::sprite#0 << 1 -- vbuaa=vbum1_rol_1 
    tya
    asl
    // [428] ((unsigned int *)&sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE)[sprite_map_header::$8] = *((unsigned int *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_SIZE) -- pwuc1_derefidx_vbuaa=_deref_pwuc2 
    tay
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_SIZE
    sta sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE,y
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_SIZE+1
    sta sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE+1,y
    // vera_sprite_width_get_bitmap(sprite_file_header->width)
    // [429] sprite_map_header::vera_sprite_width_get_bitmap1_width#0 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_WIDTH) -- vbuaa=_deref_pbuc1 
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_WIDTH
    // sprite_map_header::vera_sprite_width_get_bitmap1
    // case 8:
    //             return VERA_SPRITE_WIDTH_8;
    // [430] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==8) goto sprite_map_header::vera_sprite_width_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #8
    beq __b5
    // sprite_map_header::vera_sprite_width_get_bitmap1_@1
    // case 16:
    //             return VERA_SPRITE_WIDTH_16;
    // [431] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==$10) goto sprite_map_header::vera_sprite_width_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #$10
    beq __b6
    // sprite_map_header::vera_sprite_width_get_bitmap1_@2
    // case 32:
    //             return VERA_SPRITE_WIDTH_32;
    // [432] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==$20) goto sprite_map_header::vera_sprite_width_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #$20
    beq __b7
    // sprite_map_header::vera_sprite_width_get_bitmap1_@3
    // case 64:
    //             return VERA_SPRITE_WIDTH_64;
    //         other:
    // [433] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==$40) goto sprite_map_header::vera_sprite_width_get_bitmap1_@9 -- vbuaa_eq_vbuc1_then_la1 
    cmp #$40
    beq vera_sprite_width_get_bitmap1___b9
    // [435] phi from sprite_map_header::vera_sprite_width_get_bitmap1 sprite_map_header::vera_sprite_width_get_bitmap1_@3 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1/sprite_map_header::vera_sprite_width_get_bitmap1_@3->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
  __b5:
    // [435] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = 0 [phi:sprite_map_header::vera_sprite_width_get_bitmap1/sprite_map_header::vera_sprite_width_get_bitmap1_@3->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b1
    // [434] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@3 to sprite_map_header::vera_sprite_width_get_bitmap1_@9 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@3->sprite_map_header::vera_sprite_width_get_bitmap1_@9]
    // sprite_map_header::vera_sprite_width_get_bitmap1_@9
  vera_sprite_width_get_bitmap1___b9:
    // [435] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@9 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@9->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
    // [435] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = $30 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@9->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$30
    jmp __b1
    // [435] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@1 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@1->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
  __b6:
    // [435] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = $10 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@1->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$10
    jmp __b1
    // [435] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@2 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@2->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
  __b7:
    // [435] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = $20 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@2->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$20
    // sprite_map_header::vera_sprite_width_get_bitmap1_@return
    // sprite_map_header::@1
  __b1:
    // sprites.Width[sprite] = vera_sprite_width_get_bitmap(sprite_file_header->width)
    // [436] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_WIDTH)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_width_get_bitmap1_return#5 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_WIDTH,y
    // vera_sprite_height_get_bitmap(sprite_file_header->height)
    // [437] sprite_map_header::vera_sprite_height_get_bitmap1_height#0 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HEIGHT) -- vbuaa=_deref_pbuc1 
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HEIGHT
    // sprite_map_header::vera_sprite_height_get_bitmap1
    // case 8:
    //             return VERA_SPRITE_HEIGHT_8;
    // [438] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==8) goto sprite_map_header::vera_sprite_height_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #8
    beq __b8
    // sprite_map_header::vera_sprite_height_get_bitmap1_@1
    // case 16:
    //             return VERA_SPRITE_HEIGHT_16;
    // [439] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==$10) goto sprite_map_header::vera_sprite_height_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #$10
    beq __b9
    // sprite_map_header::vera_sprite_height_get_bitmap1_@2
    // case 32:
    //             return VERA_SPRITE_HEIGHT_32;
    // [440] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==$20) goto sprite_map_header::vera_sprite_height_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #$20
    beq __b10
    // sprite_map_header::vera_sprite_height_get_bitmap1_@3
    // case 64:
    //             return VERA_SPRITE_HEIGHT_64;
    //         other:
    // [441] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==$40) goto sprite_map_header::vera_sprite_height_get_bitmap1_@9 -- vbuaa_eq_vbuc1_then_la1 
    cmp #$40
    beq vera_sprite_height_get_bitmap1___b9
    // [443] phi from sprite_map_header::vera_sprite_height_get_bitmap1 sprite_map_header::vera_sprite_height_get_bitmap1_@3 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1/sprite_map_header::vera_sprite_height_get_bitmap1_@3->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
  __b8:
    // [443] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = 0 [phi:sprite_map_header::vera_sprite_height_get_bitmap1/sprite_map_header::vera_sprite_height_get_bitmap1_@3->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b2
    // [442] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@3 to sprite_map_header::vera_sprite_height_get_bitmap1_@9 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@3->sprite_map_header::vera_sprite_height_get_bitmap1_@9]
    // sprite_map_header::vera_sprite_height_get_bitmap1_@9
  vera_sprite_height_get_bitmap1___b9:
    // [443] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@9 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@9->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
    // [443] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = $c0 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@9->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$c0
    jmp __b2
    // [443] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@1 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@1->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
  __b9:
    // [443] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = $40 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@1->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$40
    jmp __b2
    // [443] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@2 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@2->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
  __b10:
    // [443] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = $80 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@2->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$80
    // sprite_map_header::vera_sprite_height_get_bitmap1_@return
    // sprite_map_header::@2
  __b2:
    // sprites.Height[sprite] = vera_sprite_height_get_bitmap(sprite_file_header->height)
    // [444] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_HEIGHT)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_height_get_bitmap1_return#5 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_HEIGHT,y
    // vera_sprite_zdepth_get_bitmap(sprite_file_header->zdepth)
    // [445] sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_ZDEPTH) -- vbuaa=_deref_pbuc1 
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_ZDEPTH
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1
    // case 0:
    //             return VERA_SPRITE_ZDEPTH_DISABLED;
    // [446] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==0) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b11
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1
    // case 1:
    //             return VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0;
    // [447] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==1) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #1
    beq __b12
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2
    // case 2:
    //             return VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1;
    // [448] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==2) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #2
    beq __b13
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3
    // case 3:
    //             return VERA_SPRITE_ZDEPTH_IN_FRONT;
    //         other:
    // [449] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==3) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9 -- vbuaa_eq_vbuc1_then_la1 
    cmp #3
    beq vera_sprite_zdepth_get_bitmap1___b9
    // [451] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1 sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1/sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
  __b11:
    // [451] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = 0 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1/sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b3
    // [450] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9]
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9
  vera_sprite_zdepth_get_bitmap1___b9:
    // [451] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
    // [451] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = $c [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$c
    jmp __b3
    // [451] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
  __b12:
    // [451] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = 4 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #4
    jmp __b3
    // [451] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
  __b13:
    // [451] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = 8 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #8
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return
    // sprite_map_header::@3
  __b3:
    // sprites.Zdepth[sprite] = vera_sprite_zdepth_get_bitmap(sprite_file_header->zdepth)
    // [452] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_ZDEPTH)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_ZDEPTH,y
    // vera_sprite_hflip_get_bitmap(sprite_file_header->hflip)
    // [453] sprite_map_header::vera_sprite_hflip_get_bitmap1_hflip#0 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HFLIP) -- vbuaa=_deref_pbuc1 
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HFLIP
    // sprite_map_header::vera_sprite_hflip_get_bitmap1
    // case 0:
    //             return VERA_SPRITE_NFLIP;
    // [454] if(sprite_map_header::vera_sprite_hflip_get_bitmap1_hflip#0==0) goto sprite_map_header::vera_sprite_hflip_get_bitmap1_@return -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b14
    // sprite_map_header::vera_sprite_hflip_get_bitmap1_@1
    // case 1:
    //             return VERA_SPRITE_HFLIP;
    //         other:
    // [455] if(sprite_map_header::vera_sprite_hflip_get_bitmap1_hflip#0==1) goto sprite_map_header::vera_sprite_hflip_get_bitmap1_@5 -- vbuaa_eq_vbuc1_then_la1 
    cmp #1
    beq vera_sprite_hflip_get_bitmap1___b5
    // [457] phi from sprite_map_header::vera_sprite_hflip_get_bitmap1 sprite_map_header::vera_sprite_hflip_get_bitmap1_@1 to sprite_map_header::vera_sprite_hflip_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1/sprite_map_header::vera_sprite_hflip_get_bitmap1_@1->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return]
  __b14:
    // [457] phi sprite_map_header::vera_sprite_hflip_get_bitmap1_return#3 = 0 [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1/sprite_map_header::vera_sprite_hflip_get_bitmap1_@1->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b4
    // [456] phi from sprite_map_header::vera_sprite_hflip_get_bitmap1_@1 to sprite_map_header::vera_sprite_hflip_get_bitmap1_@5 [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1_@1->sprite_map_header::vera_sprite_hflip_get_bitmap1_@5]
    // sprite_map_header::vera_sprite_hflip_get_bitmap1_@5
  vera_sprite_hflip_get_bitmap1___b5:
    // [457] phi from sprite_map_header::vera_sprite_hflip_get_bitmap1_@5 to sprite_map_header::vera_sprite_hflip_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1_@5->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return]
    // [457] phi sprite_map_header::vera_sprite_hflip_get_bitmap1_return#3 = 1 [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1_@5->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #1
    // sprite_map_header::vera_sprite_hflip_get_bitmap1_@return
    // sprite_map_header::@4
  __b4:
    // sprites.Hflip[sprite] = vera_sprite_hflip_get_bitmap(sprite_file_header->hflip)
    // [458] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_HFLIP)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_hflip_get_bitmap1_return#3 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_HFLIP,y
    // vera_sprite_vflip_get_bitmap(sprite_file_header->vflip)
    // [459] vera_sprite_vflip_get_bitmap::vflip#0 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_VFLIP) -- vbuaa=_deref_pbuc1 
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_VFLIP
    // [460] call vera_sprite_vflip_get_bitmap
    jsr vera_sprite_vflip_get_bitmap
    // [461] vera_sprite_vflip_get_bitmap::return#4 = vera_sprite_vflip_get_bitmap::return#3
    // sprite_map_header::@5
    // [462] sprite_map_header::$4 = vera_sprite_vflip_get_bitmap::return#4
    // sprites.Vflip[sprite] = vera_sprite_vflip_get_bitmap(sprite_file_header->vflip)
    // [463] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_VFLIP)[sprite_map_header::sprite#0] = sprite_map_header::$4 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_VFLIP,y
    // vera_sprite_bpp_get_bitmap(sprite_file_header->bpp)
    // [464] vera_sprite_bpp_get_bitmap::bpp#0 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_BPP) -- vbuaa=_deref_pbuc1 
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_BPP
    // [465] call vera_sprite_bpp_get_bitmap
    jsr vera_sprite_bpp_get_bitmap
    // [466] vera_sprite_bpp_get_bitmap::return#4 = vera_sprite_bpp_get_bitmap::return#3
    // sprite_map_header::@6
    // [467] sprite_map_header::$5 = vera_sprite_bpp_get_bitmap::return#4
    // sprites.BPP[sprite] = vera_sprite_bpp_get_bitmap(sprite_file_header->bpp)
    // [468] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_BPP)[sprite_map_header::sprite#0] = sprite_map_header::$5 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_BPP,y
    // sprites.reverse[sprite] = sprite_file_header->reverse
    // [469] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_REVERSE)[sprite_map_header::sprite#0] = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_REVERSE) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_REVERSE
    sta sprites+OFFSET_STRUCT_SPRITE_T_REVERSE,y
    // sprites.aabb[sprite].xmin = sprite_file_header->collision
    // [470] sprite_map_header::$10 = sprite_map_header::sprite#0 << 2 -- vbuxx=vbum1_rol_2 
    tya
    asl
    asl
    tax
    // [471] ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB)[sprite_map_header::$10] = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION) -- pbuc1_derefidx_vbuxx=_deref_pbuc2 
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION
    sta sprites+OFFSET_STRUCT_SPRITE_T_AABB,x
    // sprites.aabb[sprite].ymin = sprite_file_header->collision
    // [472] ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMIN)[sprite_map_header::$10] = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION) -- pbuc1_derefidx_vbuxx=_deref_pbuc2 
    sta sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMIN,x
    // sprite_file_header->width - sprite_file_header->collision
    // [473] sprite_map_header::$6 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_WIDTH) - *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION) -- vbuaa=_deref_pbuc1_minus__deref_pbuc2 
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_WIDTH
    sec
    sbc sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION
    // sprites.aabb[sprite].xmax = sprite_file_header->width - sprite_file_header->collision
    // [474] ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_XMAX)[sprite_map_header::$10] = sprite_map_header::$6 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_XMAX,x
    // sprite_file_header->height - sprite_file_header->collision
    // [475] sprite_map_header::$7 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HEIGHT) - *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION) -- vbuaa=_deref_pbuc1_minus__deref_pbuc2 
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HEIGHT
    sec
    sbc sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION
    // sprites.aabb[sprite].ymax = sprite_file_header->height - sprite_file_header->collision
    // [476] ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMAX)[sprite_map_header::$10] = sprite_map_header::$7 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMAX,x
    // sprites.PaletteOffset[sprite] = 0
    // [477] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET)[sprite_map_header::sprite#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta sprites+OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET,y
    // sprites.loop[sprite] = sprite_file_header->loop
    // [478] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_LOOP)[sprite_map_header::sprite#0] = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_LOOP) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    lda sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_LOOP
    sta sprites+OFFSET_STRUCT_SPRITE_T_LOOP,y
    // sprites.sprite_cache[sprite] = 0
    // [479] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE)[sprite_map_header::sprite#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta sprites+OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE,y
    // sprite_map_header::@return
    // }
    // [480] return 
    rts
  .segment DataEngineFlight
    .label sprite = flight_draw.f
}
.segment Code
  // memcpy_vram_bram
/**
 * @brief Copy block of memory from bram to vram.
 * Copies num bytes from the source bram bank/pointer to the destination vram bank/offset.
 *
 * @param dbank_vram Destination vram bank between 0 and 1.
 * @param doffset_vram Destination vram offset between 0x0000 and 0xFFFF.
 * @param sbank_vram Source bram bank between 0 and 255 (Depending on banked ram availability, maxima can be 63, 127, 191 or 255).
 * @param sptr_bram Source bram pointer between 0xA000 and 0xBFFF.
 * @param num Amount of bytes to copy.
 */
// void memcpy_vram_bram(__register(X) char dbank_vram, __mem() unsigned int doffset_vram, __mem() char sbank_bram, __zp($33) char *sptr_bram, __mem() volatile unsigned int num)
memcpy_vram_bram: {
    .label pagemask = $ff00
    .label ptr = $31
    .label sptr_bram = $33
    // memcpy_vram_bram::bank_get_bram1
    // return BRAM;
    // [482] memcpy_vram_bram::bank#10 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank
    // memcpy_vram_bram::bank_set_bram1
    // BRAM = bank
    // [483] BRAM = memcpy_vram_bram::sbank_bram#2 -- vbuz1=vbum2 
    lda sbank_bram
    sta.z BRAM
    // memcpy_vram_bram::@12
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [484] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [485] memcpy_vram_bram::$2 = byte0  memcpy_vram_bram::doffset_vram#0 -- vbuaa=_byte0_vwum1 
    lda doffset_vram
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [486] *VERA_ADDRX_L = memcpy_vram_bram::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [487] memcpy_vram_bram::$3 = byte1  memcpy_vram_bram::doffset_vram#0 -- vbuaa=_byte1_vwum1 
    lda doffset_vram+1
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [488] *VERA_ADDRX_M = memcpy_vram_bram::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // dbank_vram | VERA_INC_1
    // [489] memcpy_vram_bram::$4 = memcpy_vram_bram::dbank_vram#0 | VERA_INC_1 -- vbuaa=vbuxx_bor_vbuc1 
    txa
    ora #VERA_INC_1
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [490] *VERA_ADDRX_H = memcpy_vram_bram::$4 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // (unsigned int)sptr_bram & (unsigned int)pagemask
    // [491] memcpy_vram_bram::$5 = (unsigned int)memcpy_vram_bram::sptr_bram#0 & (unsigned int)memcpy_vram_bram::pagemask -- vwum1=vwuz2_band_vwuc1 
    lda.z sptr_bram
    and #<pagemask
    sta memcpy_vram_bram__5
    lda.z sptr_bram+1
    and #>pagemask
    sta memcpy_vram_bram__5+1
    // bram_ptr_t ptr = (bram_ptr_t)((unsigned int)sptr_bram & (unsigned int)pagemask)
    // [492] memcpy_vram_bram::ptr = (char *)memcpy_vram_bram::$5 -- pbuz1=pbum2 
    // Set the page boundary.
    lda memcpy_vram_bram__5
    sta.z ptr
    lda memcpy_vram_bram__5+1
    sta.z ptr+1
    // unsigned char pos = BYTE0(sptr_bram)
    // [493] memcpy_vram_bram::pos = byte0  memcpy_vram_bram::sptr_bram#0 -- vbum1=_byte0_pbuz2 
    lda.z sptr_bram
    sta pos
    // BYTE0(sptr_bram)
    // [494] memcpy_vram_bram::$7 = byte0  memcpy_vram_bram::sptr_bram#0 -- vbuaa=_byte0_pbuz1 
    lda.z sptr_bram
    // unsigned char len = -BYTE0(sptr_bram)
    // [495] memcpy_vram_bram::len = - memcpy_vram_bram::$7 -- vbum1=_neg_vbuaa 
    eor #$ff
    clc
    adc #1
    sta len
    // num <= (unsigned int)len
    // [496] memcpy_vram_bram::$27 = (unsigned int)memcpy_vram_bram::len -- vwum1=_word_vbum2 
    sta memcpy_vram_bram__27
    lda #0
    sta memcpy_vram_bram__27+1
    // if (num <= (unsigned int)len)
    // [497] if(memcpy_vram_bram::num>memcpy_vram_bram::$27) goto memcpy_vram_bram::@1 -- vwum1_gt_vwum2_then_la1 
    cmp num+1
    bcc __b1
    bne !+
    lda memcpy_vram_bram__27
    cmp num
    bcc __b1
  !:
    // memcpy_vram_bram::@5
    // BYTE0(num)
    // [498] memcpy_vram_bram::$11 = byte0  memcpy_vram_bram::num -- vbuaa=_byte0_vwum1 
    lda num
    // len = BYTE0(num)
    // [499] memcpy_vram_bram::len = memcpy_vram_bram::$11 -- vbum1=vbuaa 
    sta len
    // memcpy_vram_bram::@1
  __b1:
    // if (len)
    // [500] if(0==memcpy_vram_bram::len) goto memcpy_vram_bram::@2 -- 0_eq_vbum1_then_la1 
    lda len
    beq __b2
    // memcpy_vram_bram::@6
    // asm
    // asm { ldypos ldxlen inx ldaptr sta!ptr++1 ldaptr+1 sta!ptr++2 !ptr: lda$ffff,y staVERA_DATA0 iny dex bne!ptr-  }
    ldy pos
    tax
    inx
    lda ptr
    sta !ptr+ +1
    lda ptr+1
    sta !ptr+ +2
  !ptr:
    lda $ffff,y
    sta VERA_DATA0
    iny
    dex
    bne !ptr-
    // ptr += 0x100
    // [502] memcpy_vram_bram::ptr = memcpy_vram_bram::ptr + $100 -- pbuz1=pbuz1_plus_vwuc1 
    // do {
    //     // *VERA_DATA0 = ptr[y];
    //     asm {
    //         !ptr: lda $ffff,y
    //         sta VERA_DATA0
    //     }
    //     y++;
    //     // ptr++;
    // } while(y<x);
    lda.z ptr
    clc
    adc #<$100
    sta.z ptr
    lda.z ptr+1
    adc #>$100
    sta.z ptr+1
    // num -= len
    // [503] memcpy_vram_bram::num = memcpy_vram_bram::num - memcpy_vram_bram::len -- vwum1=vwum1_minus_vbum2 
    sec
    lda num
    sbc len
    sta num
    bcs !+
    dec num+1
  !:
    // memcpy_vram_bram::@2
  __b2:
    // BYTE1(ptr)
    // [504] memcpy_vram_bram::$13 = byte1  memcpy_vram_bram::ptr -- vbuaa=_byte1_pbuz1 
    lda.z ptr+1
    // if (BYTE1(ptr) == 0xC0)
    // [505] if(memcpy_vram_bram::$13!=$c0) goto memcpy_vram_bram::@3 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$c0
    bne __b3
    // memcpy_vram_bram::@7
    // ptr = (unsigned char *)0xA000
    // [506] memcpy_vram_bram::ptr = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z ptr
    lda #>$a000
    sta.z ptr+1
    // bank_set_bram(++sbank_bram);
    // [507] memcpy_vram_bram::bank_set_bram2_bank#0 = ++ memcpy_vram_bram::sbank_bram#2 -- vbum1=_inc_vbum1 
    inc bank_set_bram2_bank
    // memcpy_vram_bram::bank_set_bram2
    // BRAM = bank
    // [508] BRAM = memcpy_vram_bram::bank_set_bram2_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram2_bank
    sta.z BRAM
    // [509] phi from memcpy_vram_bram::@2 memcpy_vram_bram::bank_set_bram2 to memcpy_vram_bram::@3 [phi:memcpy_vram_bram::@2/memcpy_vram_bram::bank_set_bram2->memcpy_vram_bram::@3]
    // [509] phi memcpy_vram_bram::sbank_bram#13 = memcpy_vram_bram::sbank_bram#2 [phi:memcpy_vram_bram::@2/memcpy_vram_bram::bank_set_bram2->memcpy_vram_bram::@3#0] -- register_copy 
    // memcpy_vram_bram::@3
  __b3:
    // BYTE1(num)
    // [510] memcpy_vram_bram::$16 = byte1  memcpy_vram_bram::num -- vbuaa=_byte1_vwum1 
    lda num+1
    // if (BYTE1(num))
    // [511] if(0==memcpy_vram_bram::$16) goto memcpy_vram_bram::@4 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b4
    // [512] phi from memcpy_vram_bram::@10 memcpy_vram_bram::@3 to memcpy_vram_bram::@9 [phi:memcpy_vram_bram::@10/memcpy_vram_bram::@3->memcpy_vram_bram::@9]
    // [512] phi memcpy_vram_bram::sbank_bram#5 = memcpy_vram_bram::sbank_bram#12 [phi:memcpy_vram_bram::@10/memcpy_vram_bram::@3->memcpy_vram_bram::@9#0] -- register_copy 
    // memcpy_vram_bram::@9
  __b9:
    // asm
    // asm { ldy#0 ldaptr sta!ptr++1 ldaptr+1 sta!ptr++2 !: !ptr: lda$ffff,y staVERA_DATA0 iny bne!-  }
    // register unsigned char y = 0;
    ldy #0
    lda ptr
    sta !ptr+ +1
    lda ptr+1
    sta !ptr+ +2
  !:
  !ptr:
    lda $ffff,y
    sta VERA_DATA0
    iny
    bne !-
    // ptr += 0x100
    // [514] memcpy_vram_bram::ptr = memcpy_vram_bram::ptr + $100 -- pbuz1=pbuz1_plus_vwuc1 
    // do {
    //     // *VERA_DATA0 = ptr[y];
    //     asm {
    //         !ptr: lda $ffff,y
    //         sta VERA_DATA0
    //     }
    //     y++;
    //     // ptr++;
    // } while(y);
    lda.z ptr
    clc
    adc #<$100
    sta.z ptr
    lda.z ptr+1
    adc #>$100
    sta.z ptr+1
    // BYTE1(ptr)
    // [515] memcpy_vram_bram::$21 = byte1  memcpy_vram_bram::ptr -- vbuaa=_byte1_pbuz1 
    // if (BYTE1(ptr) == 0xC0)
    // [516] if(memcpy_vram_bram::$21!=$c0) goto memcpy_vram_bram::@10 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$c0
    bne __b10
    // memcpy_vram_bram::@11
    // ptr = (unsigned char *)0xA000
    // [517] memcpy_vram_bram::ptr = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z ptr
    lda #>$a000
    sta.z ptr+1
    // bank_set_bram(++sbank_bram);
    // [518] memcpy_vram_bram::bank_set_bram3_bank#0 = ++ memcpy_vram_bram::sbank_bram#5 -- vbum1=_inc_vbum1 
    inc bank_set_bram3_bank
    // memcpy_vram_bram::bank_set_bram3
    // BRAM = bank
    // [519] BRAM = memcpy_vram_bram::bank_set_bram3_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram3_bank
    sta.z BRAM
    // [520] phi from memcpy_vram_bram::@9 memcpy_vram_bram::bank_set_bram3 to memcpy_vram_bram::@10 [phi:memcpy_vram_bram::@9/memcpy_vram_bram::bank_set_bram3->memcpy_vram_bram::@10]
    // [520] phi memcpy_vram_bram::sbank_bram#12 = memcpy_vram_bram::sbank_bram#5 [phi:memcpy_vram_bram::@9/memcpy_vram_bram::bank_set_bram3->memcpy_vram_bram::@10#0] -- register_copy 
    // memcpy_vram_bram::@10
  __b10:
    // num -= 256
    // [521] memcpy_vram_bram::num = memcpy_vram_bram::num - $100 -- vwum1=vwum1_minus_vwuc1 
    lda num
    sec
    sbc #<$100
    sta num
    lda num+1
    sbc #>$100
    sta num+1
    // BYTE1(num)
    // [522] memcpy_vram_bram::$25 = byte1  memcpy_vram_bram::num -- vbuaa=_byte1_vwum1 
    // while (BYTE1(num))
    // [523] if(0!=memcpy_vram_bram::$25) goto memcpy_vram_bram::@9 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b9
    // memcpy_vram_bram::@4
  __b4:
    // if (num)
    // [524] if(0==memcpy_vram_bram::num) goto memcpy_vram_bram::bank_set_bram4 -- 0_eq_vwum1_then_la1 
    lda num
    ora num+1
    beq bank_set_bram4
    // memcpy_vram_bram::@8
    // asm
    // asm { ldy#0 ldxnum inx ldaptr sta!ptr++1 ldaptr+1 sta!ptr++2 !ptr: lda$ffff,y staVERA_DATA0 iny dex bne!ptr-  }
    ldy #0
    ldx num
    inx
    lda ptr
    sta !ptr+ +1
    lda ptr+1
    sta !ptr+ +2
  !ptr:
    lda $ffff,y
    sta VERA_DATA0
    iny
    dex
    bne !ptr-
    // memcpy_vram_bram::bank_set_bram4
  bank_set_bram4:
    // BRAM = bank
    // [526] BRAM = memcpy_vram_bram::bank#10 -- vbuz1=vbum2 
    lda bank
    sta.z BRAM
    // memcpy_vram_bram::@return
    // }
    // [527] return 
    rts
  .segment Data
    num: .word 0
    .label memcpy_vram_bram__5 = strlen.len
    pos: .byte 0
    len: .byte 0
    .label memcpy_vram_bram__27 = strlen.len
    .label bank_set_bram2_bank = sbank_bram
    .label bank_set_bram3_bank = sbank_bram
    .label doffset_vram = strlen.len
    sbank_bram: .byte 0
    bank: .byte 0
}
.segment CodeEngineFlight
  // flight_sprite_free_offset
// void flight_sprite_free_offset(__mem() unsigned int sprite_offset)
flight_sprite_free_offset: {
    // flight_sprite_free_offset::vera_sprite_get_id1
    // sprite_offset - WORD0(VERA_SPRITE_ATTR)
    // [529] flight_sprite_free_offset::vera_sprite_get_id1_$0 = flight_sprite_free_offset::sprite_offset#0 - word0 VERA_SPRITE_ATTR -- vwum1=vwum2_minus_vwuc1 
    sec
    lda sprite_offset
    sbc #<VERA_SPRITE_ATTR&$ffff
    sta vera_sprite_get_id1_flight_sprite_free_offset__0
    lda sprite_offset+1
    sbc #>VERA_SPRITE_ATTR&$ffff
    sta vera_sprite_get_id1_flight_sprite_free_offset__0+1
    // (sprite_offset - WORD0(VERA_SPRITE_ATTR)) >> 3
    // [530] flight_sprite_free_offset::vera_sprite_get_id1_$1 = flight_sprite_free_offset::vera_sprite_get_id1_$0 >> 3 -- vwum1=vwum1_ror_3 
    lsr vera_sprite_get_id1_flight_sprite_free_offset__1+1
    ror vera_sprite_get_id1_flight_sprite_free_offset__1
    lsr vera_sprite_get_id1_flight_sprite_free_offset__1+1
    ror vera_sprite_get_id1_flight_sprite_free_offset__1
    lsr vera_sprite_get_id1_flight_sprite_free_offset__1+1
    ror vera_sprite_get_id1_flight_sprite_free_offset__1
    // BYTE0((sprite_offset - WORD0(VERA_SPRITE_ATTR)) >> 3)
    // [531] flight_sprite_free_offset::vera_sprite_get_id1_return#0 = byte0  flight_sprite_free_offset::vera_sprite_get_id1_$1 -- vbuaa=_byte0_vwum1 
    lda vera_sprite_get_id1_flight_sprite_free_offset__1
    // flight_sprite_free_offset::@1
    // flight_sprite_offsets[sprite_id] = 0
    // [532] flight_sprite_free_offset::$1 = flight_sprite_free_offset::vera_sprite_get_id1_return#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [533] flight_sprite_offsets[flight_sprite_free_offset::$1] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta flight_sprite_offsets,y
    sta flight_sprite_offsets+1,y
    // flight_sprite_free_offset::@return
    // }
    // [534] return 
    rts
  .segment Data
    .label vera_sprite_get_id1_flight_sprite_free_offset__0 = strlen.len
    .label vera_sprite_get_id1_flight_sprite_free_offset__1 = strlen.len
  .segment DataEngineFlight
    .label sprite_offset = flight_draw.x
}
.segment CodeEngineFlight
  // fe_sprite_cache_free
// void fe_sprite_cache_free(__register(X) char fe_sprite_index)
fe_sprite_cache_free: {
    // sprite_cache.used[fe_sprite_index]--;
    // [535] ((char *)&sprite_cache)[fe_sprite_cache_free::fe_sprite_index#0] = -- ((char *)&sprite_cache)[fe_sprite_cache_free::fe_sprite_index#0] -- pbuc1_derefidx_vbuxx=_dec_pbuc1_derefidx_vbuxx 
    dec equinoxe_flightengine.sprite_cache,x
    // fe_sprite_cache_free::@return
    // }
    // [536] return 
    rts
}
  // fe_sprite_cache_copy
// todo, need to detach vram allocation from cache management.
// __register(A) char fe_sprite_cache_copy(__mem() char sprite_index)
fe_sprite_cache_copy: {
    .const bank_push_set_bram1_bank = 4
    // fe_sprite_cache_copy::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [539] BRAM = fe_sprite_cache_copy::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // fe_sprite_cache_copy::@7
    // unsigned char c = sprites.sprite_cache[sprite_index]
    // [540] fe_sprite_cache_copy::c#0 = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE)[fe_sprite_cache_copy::sprite_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE,y
    sta c
    // sprite_index_t cache_bram = (sprite_index_t)sprite_cache.sprite_bram[c]
    // [541] fe_sprite_cache_copy::cache_bram#0 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SPRITE_BRAM)[fe_sprite_cache_copy::c#0] -- vbuaa=pbuc1_derefidx_vbum1 
    tay
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SPRITE_BRAM,y
    // if (cache_bram != sprite_index)
    // [542] if(fe_sprite_cache_copy::cache_bram#0==fe_sprite_cache_copy::sprite_index#0) goto fe_sprite_cache_copy::@1 -- vbuaa_eq_vbum1_then_la1 
    cmp sprite_index
    bne !__b1+
    jmp __b1
  !__b1:
    // fe_sprite_cache_copy::@2
    // if (sprite_cache.used[c])
    // [543] if(0==((char *)&sprite_cache)[fe_sprite_cache_copy::c#0]) goto fe_sprite_cache_copy::@3 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda equinoxe_flightengine.sprite_cache,y
    cmp #0
    beq __b3
    // fe_sprite_cache_copy::@4
  __b4:
    // while (sprite_cache.used[sprite_cache_pool])
    // [544] if(0!=((char *)&sprite_cache)[sprite_cache_pool]) goto fe_sprite_cache_copy::@5 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sprite_cache_pool
    lda equinoxe_flightengine.sprite_cache,y
    cmp #0
    beq !__b5+
    jmp __b5
  !__b5:
    // fe_sprite_cache_copy::@6
    // c = sprite_cache_pool
    // [545] fe_sprite_cache_copy::c#1 = sprite_cache_pool -- vbum1=vbum2 
    tya
    sta c
    // [546] phi from fe_sprite_cache_copy::@2 fe_sprite_cache_copy::@6 to fe_sprite_cache_copy::@3 [phi:fe_sprite_cache_copy::@2/fe_sprite_cache_copy::@6->fe_sprite_cache_copy::@3]
    // [546] phi fe_sprite_cache_copy::c#5 = fe_sprite_cache_copy::c#0 [phi:fe_sprite_cache_copy::@2/fe_sprite_cache_copy::@6->fe_sprite_cache_copy::@3#0] -- register_copy 
    // fe_sprite_cache_copy::@3
  __b3:
    // unsigned char co = c * FE_CACHE
    // [547] fe_sprite_cache_copy::co#0 = fe_sprite_cache_copy::c#5 << 4 -- vbum1=vbum2_rol_4 
    lda c
    asl
    asl
    asl
    asl
    sta co
    // sprites.sprite_cache[sprite_index] = c
    // [548] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE)[fe_sprite_cache_copy::sprite_index#0] = fe_sprite_cache_copy::c#5 -- pbuc1_derefidx_vbum1=vbum2 
    lda c
    ldy sprite_index
    sta sprites+OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE,y
    // sprite_cache.sprite_bram[c] = sprite_index
    // [549] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SPRITE_BRAM)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::sprite_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SPRITE_BRAM,y
    // sprite_cache.count[c] = sprites.count[sprite_index]
    // [550] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_COUNT)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    tay
    lda sprites+OFFSET_STRUCT_SPRITE_T_COUNT,y
    ldy c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT,y
    // sprite_cache.offset[c] = sprites.offset[sprite_index]
    // [551] fe_sprite_cache_copy::$19 = fe_sprite_cache_copy::sprite_index#0 << 1 -- vbum1=vbum2_rol_1 
    lda sprite_index
    asl
    sta fe_sprite_cache_copy__19
    // [552] fe_sprite_cache_copy::$18 = fe_sprite_cache_copy::c#5 << 1 -- vbuxx=vbum1_rol_1 
    tya
    asl
    tax
    // [553] ((unsigned int *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET)[fe_sprite_cache_copy::$18] = ((unsigned int *)&sprites+OFFSET_STRUCT_SPRITE_T_OFFSET)[fe_sprite_cache_copy::$19] -- pwuc1_derefidx_vbuxx=pwuc2_derefidx_vbum1 
    ldy fe_sprite_cache_copy__19
    lda sprites+OFFSET_STRUCT_SPRITE_T_OFFSET,y
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET,x
    lda sprites+OFFSET_STRUCT_SPRITE_T_OFFSET+1,y
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET+1,x
    // sprite_cache.size[c] = sprites.SpriteSize[sprite_index]
    // [554] ((unsigned int *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE)[fe_sprite_cache_copy::$18] = ((unsigned int *)&sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE)[fe_sprite_cache_copy::$19] -- pwuc1_derefidx_vbuxx=pwuc2_derefidx_vbum1 
    lda sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE,y
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE,x
    lda sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE+1,y
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE+1,x
    // sprite_cache.zdepth[c] = sprites.Zdepth[sprite_index]
    // [555] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_ZDEPTH)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_ZDEPTH)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_ZDEPTH,y
    ldy c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_ZDEPTH,y
    // sprite_cache.bpp[c] = sprites.BPP[sprite_index]
    // [556] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_BPP)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_BPP)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_BPP,y
    ldy c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_BPP,y
    // sprite_cache.height[c] = sprites.Height[sprite_index]
    // [557] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HEIGHT)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_HEIGHT)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_HEIGHT,y
    ldy c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HEIGHT,y
    // sprite_cache.width[c] = sprites.Width[sprite_index]
    // [558] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_WIDTH)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_WIDTH)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_WIDTH,y
    ldy c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_WIDTH,y
    // sprite_cache.hflip[c] = sprites.Hflip[sprite_index]
    // [559] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HFLIP)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_HFLIP)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_HFLIP,y
    ldy c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HFLIP,y
    // sprite_cache.vflip[c] = sprites.Vflip[sprite_index]
    // [560] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_VFLIP)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_VFLIP)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_VFLIP,y
    ldy c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_VFLIP,y
    // sprite_cache.reverse[c] = sprites.reverse[sprite_index]
    // [561] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_REVERSE)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_REVERSE)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_REVERSE,y
    ldy c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_REVERSE,y
    // sprite_cache.palette_offset[c] = sprites.PaletteOffset[sprite_index]
    // [562] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET,y
    ldy c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET,y
    // sprite_cache.loop[c] = sprites.loop[sprite_index]
    // [563] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_LOOP)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_LOOP)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_LOOP,y
    ldy c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_LOOP,y
    // strcpy(&sprite_cache.file[co], sprites.file[sprite_index])
    // [564] strcpy::destination#0 = (char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_FILE + fe_sprite_cache_copy::co#0 -- pbuz1=pbuc1_plus_vbum2 
    lda co
    clc
    adc #<equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_FILE
    sta.z strcpy.destination
    lda #>equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_FILE
    adc #0
    sta.z strcpy.destination+1
    // [565] strcpy::source#0 = ((char **)&sprites)[fe_sprite_cache_copy::$19] -- pbuz1=qbuc1_derefidx_vbum2 
    ldy fe_sprite_cache_copy__19
    lda sprites,y
    sta.z strcpy.source
    lda sprites+1,y
    sta.z strcpy.source+1
    // [566] call strcpy
    // [406] phi from fe_sprite_cache_copy::@3 to strcpy [phi:fe_sprite_cache_copy::@3->strcpy]
    // [406] phi strcpy::dst#0 = strcpy::destination#0 [phi:fe_sprite_cache_copy::@3->strcpy#0] -- register_copy 
    // [406] phi strcpy::src#0 = strcpy::source#0 [phi:fe_sprite_cache_copy::@3->strcpy#1] -- register_copy 
    jsr strcpy
    // fe_sprite_cache_copy::@8
    // sprites.aabb[sprite_index].xmin >> 2
    // [567] fe_sprite_cache_copy::$21 = fe_sprite_cache_copy::sprite_index#0 << 2 -- vbuxx=vbum1_rol_2 
    lda sprite_index
    asl
    asl
    tax
    // [568] fe_sprite_cache_copy::$11 = ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB)[fe_sprite_cache_copy::$21] >> 2 -- vbuaa=pbuc1_derefidx_vbuxx_ror_2 
    lda sprites+OFFSET_STRUCT_SPRITE_T_AABB,x
    lsr
    lsr
    // sprite_cache.xmin[c] = sprites.aabb[sprite_index].xmin >> 2
    // [569] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMIN)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$11 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMIN,y
    // sprites.aabb[sprite_index].ymin >> 2
    // [570] fe_sprite_cache_copy::$12 = ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMIN)[fe_sprite_cache_copy::$21] >> 2 -- vbuaa=pbuc1_derefidx_vbuxx_ror_2 
    lda sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMIN,x
    lsr
    lsr
    // sprite_cache.ymin[c] = sprites.aabb[sprite_index].ymin >> 2
    // [571] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMIN)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$12 -- pbuc1_derefidx_vbum1=vbuaa 
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMIN,y
    // sprites.aabb[sprite_index].xmax >> 2
    // [572] fe_sprite_cache_copy::$13 = ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_XMAX)[fe_sprite_cache_copy::$21] >> 2 -- vbuaa=pbuc1_derefidx_vbuxx_ror_2 
    lda sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_XMAX,x
    lsr
    lsr
    // sprite_cache.xmax[c] = sprites.aabb[sprite_index].xmax >> 2
    // [573] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMAX)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$13 -- pbuc1_derefidx_vbum1=vbuaa 
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMAX,y
    // sprites.aabb[sprite_index].ymax >> 2
    // [574] fe_sprite_cache_copy::$14 = ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMAX)[fe_sprite_cache_copy::$21] >> 2 -- vbuaa=pbuc1_derefidx_vbuxx_ror_2 
    lda sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMAX,x
    lsr
    lsr
    // sprite_cache.ymax[c] = sprites.aabb[sprite_index].ymax >> 2
    // [575] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMAX)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$14 -- pbuc1_derefidx_vbum1=vbuaa 
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMAX,y
    // [576] phi from fe_sprite_cache_copy::@7 fe_sprite_cache_copy::@8 to fe_sprite_cache_copy::@1 [phi:fe_sprite_cache_copy::@7/fe_sprite_cache_copy::@8->fe_sprite_cache_copy::@1]
    // [576] phi fe_sprite_cache_copy::c#2 = fe_sprite_cache_copy::c#0 [phi:fe_sprite_cache_copy::@7/fe_sprite_cache_copy::@8->fe_sprite_cache_copy::@1#0] -- register_copy 
    // fe_sprite_cache_copy::@1
  __b1:
    // sprite_cache.used[c]++;
    // [577] ((char *)&sprite_cache)[fe_sprite_cache_copy::c#2] = ++ ((char *)&sprite_cache)[fe_sprite_cache_copy::c#2] -- pbuc1_derefidx_vbum1=_inc_pbuc1_derefidx_vbum1 
    ldx c
    inc equinoxe_flightengine.sprite_cache,x
    // fe_sprite_cache_copy::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_cache_copy::@return
    // }
    // [579] return 
    rts
    // fe_sprite_cache_copy::@5
  __b5:
    // sprite_cache_pool + 1
    // [580] fe_sprite_cache_copy::$6 = sprite_cache_pool + 1 -- vbuaa=vbum1_plus_1 
    lda sprite_cache_pool
    inc
    // (sprite_cache_pool + 1) % FE_CACHE
    // [581] fe_sprite_cache_copy::$7 = fe_sprite_cache_copy::$6 & FE_CACHE-1 -- vbuaa=vbuaa_band_vbuc1 
    and #FE_CACHE-1
    // sprite_cache_pool = (sprite_cache_pool + 1) % FE_CACHE
    // [582] sprite_cache_pool = fe_sprite_cache_copy::$7 -- vbum1=vbuaa 
    sta sprite_cache_pool
    jmp __b4
  .segment DataEngineFlight
    .label fe_sprite_cache_copy__19 = sprite_image_cache_vram.vram_bank
    .label sprite_index = equinoxe_flightengine.sprite_image_cache_vram.sprite_cache_index
    .label c = fe_sprite_bram_load.s
    .label co = sprite_image_cache_vram.vram_handle1
}
.segment CodeEngineFlight
  // flight_sprite_next_offset
//     char x =  (i / 32) * 16;
//     char y = i % 32;
//     gotoxy(x, y);
//     printf("i:%02x n:%02x p:%02x t:%01x", i, flight.next[i], flight.prev[i], flight.type[i]);
// }
// __mem() unsigned int flight_sprite_next_offset()
flight_sprite_next_offset: {
    // flight_sprite_next_offset::@1
  __b1:
    // !flight_sprite_offset_pool || flight_sprite_offsets[flight_sprite_offset_pool]
    // [584] flight_sprite_next_offset::$5 = flight_sprite_offset_pool << 1 -- vbuxx=vbum1_rol_1 
    lda flight_sprite_offset_pool
    asl
    tax
    // while (!flight_sprite_offset_pool || flight_sprite_offsets[flight_sprite_offset_pool])
    // [585] if(0==flight_sprite_offset_pool) goto flight_sprite_next_offset::@2 -- 0_eq_vbum1_then_la1 
    lda flight_sprite_offset_pool
    beq __b2
    // flight_sprite_next_offset::@5
    // [586] if(0!=flight_sprite_offsets[flight_sprite_next_offset::$5]) goto flight_sprite_next_offset::@2 -- 0_neq_pwuc1_derefidx_vbuxx_then_la1 
    lda flight_sprite_offsets+1,x
    ora flight_sprite_offsets,x
    bne __b2
    // flight_sprite_next_offset::@3
    // vera_sprite_offset sprite_offset = vera_sprite_get_offset(flight_sprite_offset_pool)
    // [587] flight_sprite_next_offset::vera_sprite_get_offset1_sprite_id#0 = flight_sprite_offset_pool -- vbuaa=vbum1 
    lda flight_sprite_offset_pool
    // flight_sprite_next_offset::vera_sprite_get_offset1
    // ((unsigned int)sprite_id) << 3
    // [588] flight_sprite_next_offset::vera_sprite_get_offset1_$2 = (unsigned int)flight_sprite_next_offset::vera_sprite_get_offset1_sprite_id#0 -- vwum1=_word_vbuaa 
    sta vera_sprite_get_offset1_flight_sprite_next_offset__2
    lda #0
    sta vera_sprite_get_offset1_flight_sprite_next_offset__2+1
    // [589] flight_sprite_next_offset::vera_sprite_get_offset1_$0 = flight_sprite_next_offset::vera_sprite_get_offset1_$2 << 3 -- vwum1=vwum1_rol_3 
    asl vera_sprite_get_offset1_flight_sprite_next_offset__0
    rol vera_sprite_get_offset1_flight_sprite_next_offset__0+1
    asl vera_sprite_get_offset1_flight_sprite_next_offset__0
    rol vera_sprite_get_offset1_flight_sprite_next_offset__0+1
    asl vera_sprite_get_offset1_flight_sprite_next_offset__0
    rol vera_sprite_get_offset1_flight_sprite_next_offset__0+1
    // WORD0(VERA_SPRITE_ATTR)+(((unsigned int)sprite_id) << 3)
    // [590] flight_sprite_next_offset::vera_sprite_get_offset1_return#0 = word0 VERA_SPRITE_ATTR + flight_sprite_next_offset::vera_sprite_get_offset1_$0 -- vwum1=vwuc1_plus_vwum1 
    lda vera_sprite_get_offset1_return
    clc
    adc #<VERA_SPRITE_ATTR&$ffff
    sta vera_sprite_get_offset1_return
    lda vera_sprite_get_offset1_return+1
    adc #>VERA_SPRITE_ATTR&$ffff
    sta vera_sprite_get_offset1_return+1
    // flight_sprite_next_offset::@4
    // flight_sprite_offsets[flight_sprite_offset_pool] = sprite_offset
    // [591] flight_sprite_next_offset::$6 = flight_sprite_offset_pool << 1 -- vbuaa=vbum1_rol_1 
    lda flight_sprite_offset_pool
    asl
    // [592] flight_sprite_offsets[flight_sprite_next_offset::$6] = flight_sprite_next_offset::vera_sprite_get_offset1_return#0 -- pwuc1_derefidx_vbuaa=vwum1 
    tay
    lda vera_sprite_get_offset1_return
    sta flight_sprite_offsets,y
    lda vera_sprite_get_offset1_return+1
    sta flight_sprite_offsets+1,y
    // flight_sprite_next_offset::@return
    // }
    // [593] return 
    rts
    // flight_sprite_next_offset::@2
  __b2:
    // flight_sprite_offset_pool + 1
    // [594] flight_sprite_next_offset::$3 = flight_sprite_offset_pool + 1 -- vbuaa=vbum1_plus_1 
    lda flight_sprite_offset_pool
    inc
    // (flight_sprite_offset_pool + 1) % 128
    // [595] flight_sprite_next_offset::$4 = flight_sprite_next_offset::$3 & $80-1 -- vbuaa=vbuaa_band_vbuc1 
    and #$80-1
    // flight_sprite_offset_pool = (flight_sprite_offset_pool + 1) % 128
    // [596] flight_sprite_offset_pool = flight_sprite_next_offset::$4 -- vbum1=vbuaa 
    sta flight_sprite_offset_pool
    jmp __b1
  .segment Data
    .label vera_sprite_get_offset1_flight_sprite_next_offset__0 = strlen.len
    .label vera_sprite_get_offset1_flight_sprite_next_offset__2 = strlen.len
  .segment DataEngineFlight
    .label return = sprite_image_cache_vram.sprite_offset
  .segment Data
    .label vera_sprite_get_offset1_return = strlen.len
}
.segment CodeEngineFlight
  // fe_sprite_configure
// void fe_sprite_configure(__mem() unsigned int sprite_offset, __register(Y) char s)
fe_sprite_configure: {
    .const vera_sprite_bpp1_vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    .const vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_sprite_bpp(sprite_offset, sprite_cache.bpp[s])
    // [597] fe_sprite_configure::vera_sprite_bpp1_bpp#0 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_BPP)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_BPP,y
    // fe_sprite_configure::vera_sprite_bpp1
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+1, vera_inc_0)
    // [598] fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset#0 = fe_sprite_configure::sprite_offset#0 + 1 -- vwum1=vwum2_plus_1 
    clc
    lda sprite_offset
    adc #1
    sta vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset
    lda sprite_offset+1
    adc #0
    sta vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset+1
    // fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [599] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [600] fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$0 = byte0  fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [601] *VERA_ADDRX_L = fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [602] fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$1 = byte1  fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [603] *VERA_ADDRX_M = fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [604] *VERA_ADDRX_H = fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_sprite_bpp1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // fe_sprite_configure::vera_sprite_bpp1_@1
    // *VERA_DATA0 & ~VERA_SPRITE_8BPP
    // [605] fe_sprite_configure::vera_sprite_bpp1_$2 = *VERA_DATA0 & ~$80 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$80^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_8BPP
    // [606] *VERA_DATA0 = fe_sprite_configure::vera_sprite_bpp1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= bpp
    // [607] *VERA_DATA0 = *VERA_DATA0 | fe_sprite_configure::vera_sprite_bpp1_bpp#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // fe_sprite_configure::@1
    // vera_sprite_height(sprite_offset, sprite_cache.height[s])
    // [608] vera_sprite_height::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta vera_sprite_height.sprite_offset
    lda sprite_offset+1
    sta vera_sprite_height.sprite_offset+1
    // [609] vera_sprite_height::height#0 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HEIGHT)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HEIGHT,y
    // [610] call vera_sprite_height
    jsr vera_sprite_height
    // fe_sprite_configure::@2
    // vera_sprite_width(sprite_offset, sprite_cache.width[s])
    // [611] vera_sprite_width::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta vera_sprite_width.sprite_offset
    lda sprite_offset+1
    sta vera_sprite_width.sprite_offset+1
    // [612] vera_sprite_width::width#0 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_WIDTH)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_WIDTH,y
    // [613] call vera_sprite_width
    jsr vera_sprite_width
    // fe_sprite_configure::@3
    // vera_sprite_hflip(sprite_offset, sprite_cache.hflip[s])
    // [614] vera_sprite_hflip::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta vera_sprite_hflip.sprite_offset
    lda sprite_offset+1
    sta vera_sprite_hflip.sprite_offset+1
    // [615] vera_sprite_hflip::hflip#0 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HFLIP)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HFLIP,y
    // [616] call vera_sprite_hflip
    jsr vera_sprite_hflip
    // fe_sprite_configure::@4
    // vera_sprite_vflip(sprite_offset, sprite_cache.vflip[s])
    // [617] vera_sprite_vflip::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta vera_sprite_vflip.sprite_offset
    lda sprite_offset+1
    sta vera_sprite_vflip.sprite_offset+1
    // [618] vera_sprite_vflip::vflip#0 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_VFLIP)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_VFLIP,y
    // [619] call vera_sprite_vflip
    jsr vera_sprite_vflip
    // fe_sprite_configure::@5
    // palette_use_vram(sprite_cache.palette_offset[s])
    // [620] palette_use_vram::palette_index = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET)[fe_sprite_configure::s#0] -- vbum1=pbuc1_derefidx_vbuyy 
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET,y
    sta equinoxe_palette.palette_use_vram.palette_index
    // [621] callexecute palette_use_vram  -- call_var_near 
    jsr equinoxe_palette.palette_use_vram
    // vera_sprite_palette_offset(sprite_offset, palette_use_vram(sprite_cache.palette_offset[s]))
    // [622] fe_sprite_configure::vera_sprite_palette_offset1_palette_offset#0 = palette_use_vram::return -- vbuxx=vbum1 
    ldx equinoxe_palette.palette_use_vram.return
    // fe_sprite_configure::vera_sprite_palette_offset1
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0)
    // [623] fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset#0 = fe_sprite_configure::sprite_offset#0 + 7 -- vwum1=vwum2_plus_vbuc1 
    lda #7
    clc
    adc sprite_offset
    sta vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset
    lda #0
    adc sprite_offset+1
    sta vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset+1
    // fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [624] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [625] fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$0 = byte0  fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [626] *VERA_ADDRX_L = fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [627] fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$1 = byte1  fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [628] *VERA_ADDRX_M = fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [629] *VERA_ADDRX_H = fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // fe_sprite_configure::vera_sprite_palette_offset1_@1
    // *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK
    // [630] fe_sprite_configure::vera_sprite_palette_offset1_$2 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_PALETTE_OFFSET_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK
    // [631] *VERA_DATA0 = fe_sprite_configure::vera_sprite_palette_offset1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= palette_offset
    // [632] *VERA_DATA0 = *VERA_DATA0 | fe_sprite_configure::vera_sprite_palette_offset1_palette_offset#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // fe_sprite_configure::@return
    // }
    // [633] return 
    rts
  .segment DataEngineFlight
    .label sprite_offset = sprite_image_cache_vram.sprite_offset
  .segment Data
    .label vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset = strlen.len
    .label vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset = strlen.len
}
.segment Code
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __mem() unsigned int strlen(__zp($33) char *str)
strlen: {
    .label str = $33
    // [635] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [635] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta len
    sta len+1
    // [635] phi strlen::str#2 = fe_sprite_bram_load::filename [phi:strlen->strlen::@1#1] -- pbuz1=pbuc1 
    lda #<fe_sprite_bram_load.filename
    sta.z str
    lda #>fe_sprite_bram_load.filename
    sta.z str+1
    // strlen::@1
  __b1:
    // while(*str)
    // [636] if(0!=*strlen::str#2) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [637] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [638] strlen::len#1 = ++ strlen::len#2 -- vwum1=_inc_vwum1 
    inc len
    bne !+
    inc len+1
  !:
    // str++;
    // [639] strlen::str#1 = ++ strlen::str#2 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [635] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [635] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [635] phi strlen::str#2 = strlen::str#1 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label return = len
    len: .word 0
}
.segment Code
  // vera_sprite_vflip_get_bitmap
// __register(A) char vera_sprite_vflip_get_bitmap(__register(A) char vflip)
vera_sprite_vflip_get_bitmap: {
    // case 0:
    //             return VERA_SPRITE_NFLIP;
    // [640] if(vera_sprite_vflip_get_bitmap::vflip#0==0) goto vera_sprite_vflip_get_bitmap::@return -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b1
    // vera_sprite_vflip_get_bitmap::@1
    // case 1:
    //             return VERA_SPRITE_VFLIP;
    //         other:
    // [641] if(vera_sprite_vflip_get_bitmap::vflip#0==1) goto vera_sprite_vflip_get_bitmap::@2 -- vbuaa_eq_vbuc1_then_la1 
    cmp #1
    beq __b2
    // [643] phi from vera_sprite_vflip_get_bitmap vera_sprite_vflip_get_bitmap::@1 to vera_sprite_vflip_get_bitmap::@return [phi:vera_sprite_vflip_get_bitmap/vera_sprite_vflip_get_bitmap::@1->vera_sprite_vflip_get_bitmap::@return]
  __b1:
    // [643] phi vera_sprite_vflip_get_bitmap::return#3 = 0 [phi:vera_sprite_vflip_get_bitmap/vera_sprite_vflip_get_bitmap::@1->vera_sprite_vflip_get_bitmap::@return#0] -- vbuaa=vbuc1 
    lda #0
    rts
    // [642] phi from vera_sprite_vflip_get_bitmap::@1 to vera_sprite_vflip_get_bitmap::@2 [phi:vera_sprite_vflip_get_bitmap::@1->vera_sprite_vflip_get_bitmap::@2]
    // vera_sprite_vflip_get_bitmap::@2
  __b2:
    // [643] phi from vera_sprite_vflip_get_bitmap::@2 to vera_sprite_vflip_get_bitmap::@return [phi:vera_sprite_vflip_get_bitmap::@2->vera_sprite_vflip_get_bitmap::@return]
    // [643] phi vera_sprite_vflip_get_bitmap::return#3 = 2 [phi:vera_sprite_vflip_get_bitmap::@2->vera_sprite_vflip_get_bitmap::@return#0] -- vbuaa=vbuc1 
    lda #2
    // vera_sprite_vflip_get_bitmap::@return
    // }
    // [644] return 
    rts
}
  // vera_sprite_bpp_get_bitmap
// __register(A) char vera_sprite_bpp_get_bitmap(__register(A) char bpp)
vera_sprite_bpp_get_bitmap: {
    // case 4:
    //             return VERA_SPRITE_4BPP;
    // [645] if(vera_sprite_bpp_get_bitmap::bpp#0==4) goto vera_sprite_bpp_get_bitmap::@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #4
    beq __b1
    // vera_sprite_bpp_get_bitmap::@1
    // case 8:
    //             return VERA_SPRITE_8BPP;
    //         other:
    // [646] if(vera_sprite_bpp_get_bitmap::bpp#0==8) goto vera_sprite_bpp_get_bitmap::@2 -- vbuaa_eq_vbuc1_then_la1 
    cmp #8
    beq __b2
    // [648] phi from vera_sprite_bpp_get_bitmap vera_sprite_bpp_get_bitmap::@1 to vera_sprite_bpp_get_bitmap::@return [phi:vera_sprite_bpp_get_bitmap/vera_sprite_bpp_get_bitmap::@1->vera_sprite_bpp_get_bitmap::@return]
  __b1:
    // [648] phi vera_sprite_bpp_get_bitmap::return#3 = 0 [phi:vera_sprite_bpp_get_bitmap/vera_sprite_bpp_get_bitmap::@1->vera_sprite_bpp_get_bitmap::@return#0] -- vbuaa=vbuc1 
    lda #0
    rts
    // [647] phi from vera_sprite_bpp_get_bitmap::@1 to vera_sprite_bpp_get_bitmap::@2 [phi:vera_sprite_bpp_get_bitmap::@1->vera_sprite_bpp_get_bitmap::@2]
    // vera_sprite_bpp_get_bitmap::@2
  __b2:
    // [648] phi from vera_sprite_bpp_get_bitmap::@2 to vera_sprite_bpp_get_bitmap::@return [phi:vera_sprite_bpp_get_bitmap::@2->vera_sprite_bpp_get_bitmap::@return]
    // [648] phi vera_sprite_bpp_get_bitmap::return#3 = $80 [phi:vera_sprite_bpp_get_bitmap::@2->vera_sprite_bpp_get_bitmap::@return#0] -- vbuaa=vbuc1 
    lda #$80
    // vera_sprite_bpp_get_bitmap::@return
    // }
    // [649] return 
    rts
}
  // vera_sprite_height
// void vera_sprite_height(__mem() unsigned int sprite_offset, __register(X) char height)
vera_sprite_height: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0)
    // [650] vera_sprite_height::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_height::sprite_offset#0 + 7 -- vwum1=vwum1_plus_vbuc1 
    lda #7
    clc
    adc vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_offset
    bcc !+
    inc vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_height::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [651] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [652] vera_sprite_height::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_height::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [653] *VERA_ADDRX_L = vera_sprite_height::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [654] vera_sprite_height::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_height::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [655] *VERA_ADDRX_M = vera_sprite_height::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [656] *VERA_ADDRX_H = vera_sprite_height::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_height::@1
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [657] vera_sprite_height::$2 = *VERA_DATA0 & ~$c0 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$c0^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [658] *VERA_DATA0 = vera_sprite_height::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= height
    // [659] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_height::height#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // vera_sprite_height::@return
    // }
    // [660] return 
    rts
  .segment Data
    .label vera_vram_data0_bank_offset1_offset = strlen.len
    .label sprite_offset = strlen.len
}
.segment Code
  // vera_sprite_width
// void vera_sprite_width(__mem() unsigned int sprite_offset, __register(X) char width)
vera_sprite_width: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0)
    // [661] vera_sprite_width::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_width::sprite_offset#0 + 7 -- vwum1=vwum1_plus_vbuc1 
    lda #7
    clc
    adc vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_offset
    bcc !+
    inc vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_width::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [662] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [663] vera_sprite_width::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_width::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [664] *VERA_ADDRX_L = vera_sprite_width::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [665] vera_sprite_width::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_width::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [666] *VERA_ADDRX_M = vera_sprite_width::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [667] *VERA_ADDRX_H = vera_sprite_width::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_width::@1
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [668] vera_sprite_width::$2 = *VERA_DATA0 & ~$30 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$30^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [669] *VERA_DATA0 = vera_sprite_width::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= width
    // [670] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_width::width#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // vera_sprite_width::@return
    // }
    // [671] return 
    rts
  .segment Data
    .label vera_vram_data0_bank_offset1_offset = strlen.len
    .label sprite_offset = strlen.len
}
.segment Code
  // vera_sprite_hflip
// void vera_sprite_hflip(__mem() unsigned int sprite_offset, __register(X) char hflip)
vera_sprite_hflip: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0)
    // [672] vera_sprite_hflip::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_hflip::sprite_offset#0 + 6 -- vwum1=vwum1_plus_vbuc1 
    lda #6
    clc
    adc vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_offset
    bcc !+
    inc vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_hflip::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [673] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [674] vera_sprite_hflip::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_hflip::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [675] *VERA_ADDRX_L = vera_sprite_hflip::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [676] vera_sprite_hflip::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_hflip::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [677] *VERA_ADDRX_M = vera_sprite_hflip::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [678] *VERA_ADDRX_H = vera_sprite_hflip::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_hflip::@1
    // *VERA_DATA0 & ~VERA_SPRITE_HFLIP
    // [679] vera_sprite_hflip::$2 = *VERA_DATA0 & ~1 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #1^$ff
    and VERA_DATA0
    // *VERA_DATA0 = (*VERA_DATA0 & ~VERA_SPRITE_HFLIP)
    // [680] *VERA_DATA0 = vera_sprite_hflip::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= hflip
    // [681] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_hflip::hflip#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // vera_sprite_hflip::@return
    // }
    // [682] return 
    rts
  .segment Data
    .label vera_vram_data0_bank_offset1_offset = strlen.len
    .label sprite_offset = strlen.len
}
.segment Code
  // vera_sprite_vflip
// void vera_sprite_vflip(__mem() unsigned int sprite_offset, __register(X) char vflip)
vera_sprite_vflip: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0)
    // [683] vera_sprite_vflip::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_vflip::sprite_offset#0 + 6 -- vwum1=vwum1_plus_vbuc1 
    lda #6
    clc
    adc vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_offset
    bcc !+
    inc vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_vflip::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [684] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [685] vera_sprite_vflip::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_vflip::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [686] *VERA_ADDRX_L = vera_sprite_vflip::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [687] vera_sprite_vflip::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_vflip::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [688] *VERA_ADDRX_M = vera_sprite_vflip::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [689] *VERA_ADDRX_H = vera_sprite_vflip::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_vflip::@1
    // *VERA_DATA0 & ~VERA_SPRITE_VFLIP
    // [690] vera_sprite_vflip::$2 = *VERA_DATA0 & ~2 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #2^$ff
    and VERA_DATA0
    // *VERA_DATA0 = (*VERA_DATA0 & ~VERA_SPRITE_VFLIP)
    // [691] *VERA_DATA0 = vera_sprite_vflip::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= vflip
    // [692] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_vflip::vflip#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // vera_sprite_vflip::@return
    // }
    // [693] return 
    rts
  .segment Data
    .label vera_vram_data0_bank_offset1_offset = strlen.len
    .label sprite_offset = strlen.len
}
  // Exported Global Data
.segment BramEngineStages
  // const stage_action_end_t      action_end                      = { 0 };
  action_flightpath_000: .word $140
  .byte $10, 0, equinoxe_flightengine.STAGE_ACTION_MOVE, 0
  action_flightpath_left_circle_002: .word $140+$a0
  .byte $20, 3, equinoxe_flightengine.STAGE_ACTION_MOVE, 1, -$18, 4, 3
  .fill 1, 0
  .byte equinoxe_flightengine.STAGE_ACTION_TURN, 2
  .word $50
  .byte 0, 3, equinoxe_flightengine.STAGE_ACTION_MOVE, 1
  action_flightpath_right_circle_003: .word $140+$a0
  .byte 0, 3, equinoxe_flightengine.STAGE_ACTION_MOVE, 1, $18, 4, 3
  .fill 1, 0
  .byte equinoxe_flightengine.STAGE_ACTION_TURN, 2
  .word $50
  .byte 0, 3, equinoxe_flightengine.STAGE_ACTION_MOVE, 1
  action_flightpath_005: .word $300
  .byte $20, 2, equinoxe_flightengine.STAGE_ACTION_MOVE, 1, 0
  .fill 3, 0
  .byte equinoxe_flightengine.STAGE_ACTION_END, 0
  action_flightpath_006: .word $300
  .byte 0, 2, equinoxe_flightengine.STAGE_ACTION_MOVE, 1, 0
  .fill 3, 0
  .byte equinoxe_flightengine.STAGE_ACTION_END, 0
  stage_scenario_01_b: .byte 1, 1
  .word equinoxe_flightengine.stage_enemy_e0401, equinoxe_flightengine.action_flightpath_000, $140, $a0
  .byte 0, 0, 4, $a, $ff, 0, 1, 1
  .word equinoxe_flightengine.stage_enemy_e0701, equinoxe_flightengine.action_flightpath_000, $a0, $a0
  .byte 0, 0, 4, $14, 0, 0, 1, 1
  .word equinoxe_flightengine.stage_enemy_e0702, equinoxe_flightengine.action_flightpath_000, $1e0, $a0
  .byte 0, 0, 4, $1e, 0, 0, $10, $10
  .word equinoxe_flightengine.stage_enemy_e0201, equinoxe_flightengine.action_flightpath_005, $2c0, $20
  .byte 0, 0, $e, $14, 2, 0, $10, $10
  .word equinoxe_flightengine.stage_enemy_e0201, equinoxe_flightengine.action_flightpath_006, -$40, $60
  .byte 0, 0, $10, $14, 2, 0, $10, $10
  .word equinoxe_flightengine.stage_enemy_e0201, equinoxe_flightengine.action_flightpath_005, $2c0, $a0
  .byte 0, 0, $12, $14, 2, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0401, equinoxe_flightengine.action_flightpath_006, -$40, $20
  .byte 0, 0, 8, $14, 5, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0401, equinoxe_flightengine.action_flightpath_005, $2c0, $60
  .byte 0, 0, 8, $14, 5, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0301, equinoxe_flightengine.action_flightpath_006, -$40, $a0
  .byte 0, 0, 8, $14, 5, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0302, equinoxe_flightengine.action_flightpath_005, $2c0, $e0
  .byte 0, 0, 8, $14, 8, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0401, equinoxe_flightengine.action_flightpath_006, -$40, $20
  .byte 0, $20, 4, $14, 8, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0501, equinoxe_flightengine.action_flightpath_005, $2c0, $20
  .byte 0, $20, 2, $14, $a, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0601, equinoxe_flightengine.action_flightpath_006, -$40, $20
  .byte 0, $20, 2, $14, $a, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0701, equinoxe_flightengine.action_flightpath_005, $2c0, $20
  .byte 0, $20, 6, $14, $c, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0702, equinoxe_flightengine.action_flightpath_006, -$40, $20
  .byte 0, $20, 8, $14, $c, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0703, equinoxe_flightengine.action_flightpath_005, $2c0, $20
  .byte 0, $20, $a, $14, $c, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0101, equinoxe_flightengine.action_flightpath_left_circle_002, $2c0, $20
  .byte 0, $20, 6, $14, $f, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0202, equinoxe_flightengine.action_flightpath_right_circle_003, -$40, $20
  .byte 0, $20, 8, $14, $f, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0401, equinoxe_flightengine.action_flightpath_right_circle_003, $2c0, $20
  .byte 0, $20, $a, $14, $11, 0, 8, 8
  .word equinoxe_flightengine.stage_enemy_e0401, equinoxe_flightengine.action_flightpath_left_circle_002, $2c0, $20
  .byte 0, $20, $a, $14, $11, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  stage_floor_bram_tiles_01: .word equinoxe_flightengine.mars_land_bram, equinoxe_flightengine.mars_sand_bram, equinoxe_flightengine.mars_sea_bram, equinoxe_flightengine.metal_yellow_bram, equinoxe_flightengine.metal_red_bram, equinoxe_flightengine.metal_grey_bram
  stage_tower_bram_tiles_01: .word equinoxe_flightengine.tower_bram, equinoxe_flightengine.mars_sea_bram
  // This models the playbook of all the different levels in the game.
  // The embedded level field in the playbook is a pointer to a level composition.
  stage_playbooks_b: .byte $13
  .word equinoxe_flightengine.stage_scenario_01_b, equinoxe_flightengine.stage_player, equinoxe_flightengine.stage_floor_01
  .byte 1
  .word equinoxe_flightengine.stage_towers_01
.segment DataEngineFlight
  // Flight engine control.
  flight_sprite_offsets: .word 0
  .fill 2*$7e, 0
  sprite_bram_handles: .fill $100, 0
.segment BramEngineFlight
  __49: .text "t001"
  .byte 0
  __50: .text "p001"
  .byte 0
  __51: .text "n001"
  .byte 0
  __52: .text "e0701"
  .byte 0
  __53: .text "e0102"
  .byte 0
  __54: .text "e0201"
  .byte 0
  __55: .text "e0202"
  .byte 0
  __56: .text "e0301"
  .byte 0
  __57: .text "e0302"
  .byte 0
  __58: .text "e0401"
  .byte 0
  __59: .text "e0501"
  .byte 0
  __60: .text "e0502"
  .byte 0
  __61: .text "e0601"
  .byte 0
  __62: .text "e0602"
  .byte 0
  __63: .text "e0101"
  .byte 0
  __64: .text "e0702"
  .byte 0
  __65: .text "e0703"
  .byte 0
  __66: .text "b001"
  .byte 0
  __67: .text "b002"
  .byte 0
  __68: .text "b003"
  .byte 0
  __69: .text "b004"
  .byte 0
  // __export volatile sprite_bram_t sprite_t001 = { "t001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_p001 = { "p001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_n001 = { "n001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0101 = { "e0101", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0102 = { "e0102", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0201 = { "e0201", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0202 = { "e0202", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0301 = { "e0301", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0302 = { "e0302", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0401 = { "e0401", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0501 = { "e0501", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0502 = { "e0502", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0601 = { "e0601", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0602 = { "e0602", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0701 = { "e0701", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0702 = { "e0702", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0703 = { "e0703", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_b001 = { "b001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_b002 = { "b002", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_b003 = { "b003", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_b004 = { "b004", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  sprites: .word equinoxe_flightengine.__49, equinoxe_flightengine.__50, equinoxe_flightengine.__51, equinoxe_flightengine.__52, equinoxe_flightengine.__53, equinoxe_flightengine.__54, equinoxe_flightengine.__55, equinoxe_flightengine.__56, equinoxe_flightengine.__57, equinoxe_flightengine.__58, equinoxe_flightengine.__59, equinoxe_flightengine.__60, equinoxe_flightengine.__61, equinoxe_flightengine.__62, equinoxe_flightengine.__63, equinoxe_flightengine.__64, equinoxe_flightengine.__65, equinoxe_flightengine.__66, equinoxe_flightengine.__67, equinoxe_flightengine.__68, equinoxe_flightengine.__69
  .fill 2*$b, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .word 0
  .fill 2*$1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_AABB_T, 0
  .word 0
  .fill 2*$1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
.segment BramEngineFloor
  // FLOOR
  mars_land_bram: .byte 0
  .text "marsland"
  .byte 0
  .fill 7, 0
  .byte $5e
  .word $10*$10*$5e, $80, 0
  mars_sand_bram: .byte 0
  .text "marssand"
  .byte 0
  .fill 7, 0
  .byte 4
  .word $10*$10*4, $80, 0
  mars_sea_bram: .byte 0
  .text "marssea"
  .byte 0
  .fill 8, 0
  .byte $10
  .word $10*$10*$10, $80, 0
  metal_yellow_bram: .byte 0
  .text "metalyellow"
  .byte 0
  .fill 4, 0
  .byte $2a
  .word $10*$10*$2d, $80, 0
  metal_red_bram: .byte 0
  .text "metalred"
  .byte 0
  .fill 7, 0
  .byte 1
  .word $10*$10*1, $80, 0
  metal_grey_bram: .byte 0
  .text "metalgrey"
  .byte 0
  .fill 6, 0
  .byte 1
  .word $10*$10*1, $80, 0
  mars_parts: .word 0
  .fill 2*$9f, 0
  .word 0
  .fill 2*$9f, 0
  .byte 0
  .fill $9f, 0
  .byte 0
  .fill $9f, 0
  .byte 0
  .fill $9f, 0
  mars_land: .byte 0, $23, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, 1, 0, $1a, 8, $1b, 1, $54, 0, $55, $56, 2, 0, 0, $1c, 0, 3, 0, 0, $16, $17, 3, 0, 0, $2c, $2d, 3, 0, 0, $4e, $4f, 3, $52, $53, $50, $51, 4, 0, $20, 0, 0, 4, 0, $2e, 0, 0, 5, $48, $46, $49, $47, 5, $2a, $2b, $2f, $30, 5, $b, $c, $e, $f, 5, $4a, $4b, $4c, $4d, 6, $27, $22, $28, $29, 7, $12, $13, $18, $19, 7, $57, $58, $59, $5a, 8, $21, 0, 0, 0, 8, $31, 0, 0, 0, 9, $23, $24, $25, $26, $a, $a, 0, $d, 0, $a, $32, 0, $33, 0, $a, $5b, 0, $5c, 0, $a, $5d, 0, $5e, 0, $b, $10, $11, $14, $15, $c, 3, 4, 0, 0, $c, $34, $35, 0, 0, $d, 5, 6, 8, 9, $d, 5, 6, 0, $39, $e, 1, 2, 7, 0, $e, 1, $36, $3a, $3b, $f, $1d, $1e, $1f, $1d, $f, $37, $38, $3c, $3d, $f, $3e, $3f, $40, $41, $f, $45, $42, $43, $44
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  mars_sand: .byte $5e, 2, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, $f, 1, 2, 3, 4
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  mars_sea: .byte $62, 5, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, $f, 1, 2, 5, 1, $f, 3, 4, 7, 8, $f, 9, $a, $d, $e, $f, $b, $c, $f, $10
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  metal_yellow: .byte $72, $20, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, 1, $1d, $2a, $2a, $29, 2, $29, $16, $2a, $29, 3, $19, $1a, $2a, $29, 4, $29, $2a, $b, $29, 5, $11, $2a, $13, $29, 6, $25, $22, $23, $28, 7, $2a, $e, 7, $25, 8, $29, $2a, $2a, 4, 9, $29, $e, $2a, $10, $a, $d, $e, $f, $10, $b, $11, $29, $26, 8, $c, $2a, $29, 7, 8, $d, $19, $27, $29, $10, $e, $28, $1a, $13, $2a, $f, $29, $2a, $2a, $29, $10, 0, 0, 0, 0, $11, $29, $1e, $1f, $20, $12, $15, $2a, $17, $18, $13, $29, $2a, $1b, $1c, $14, 9, $a, $2a, $c, $15, $29, $12, $2a, $14, $16, $25, $22, $23, $28, $17, $21, $2a, $2a, $29, $18, 1, 2, 3, $29, $19, $d, $2a, $f, $29, $1a, $d, $2a, $f, $29, $1b, $2a, $22, $2a, $29, $1c, 5, 6, $2a, $29, $1d, $29, $2a, $23, $29, $1e, $29, $2a, $2a, $24, $1f, $29, $2a, $2a, $29
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  metal_red: .byte $86, 2, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, $f, 1, 1, 1, 1
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  mars: .word equinoxe_flightengine.mars_parts, equinoxe_flightengine.mars_land, equinoxe_flightengine.mars_sea, equinoxe_flightengine.mars_sand, equinoxe_flightengine.metal_yellow, equinoxe_flightengine.metal_red
  .fill 2*5, 0
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 0, 0, 0, 0
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 1, 3, 5, $f
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 3, 2, $f, $a
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 3, 3, $f, $f
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 5, $f, 4, $c
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 5, $f, 5, $f
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 7, $f, $f, $e
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 7, $f, $f, $f
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $a, $c, 8
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $b, $d, $f
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $a, $f, $a
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $b, $f, $f
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $f, $c, $c
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $f, $d, $f
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $f, $f, $e
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 0, 0, 0, 0
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 1, 3, 5, $f
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 3, 2, $f, $a
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 3, 3, $f, $f
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 5, $f, 4, $c
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 5, $f, 5, $f
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 7, $f, $f, $e
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 7, $f, $f, $f
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $a, $c, 8
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $b, $d, $f
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $a, $f, $a
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $b, $f, $f
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $f, $c, $c
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $f, $d, $f
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $f, $f, $e
  .word equinoxe_flightengine.mars_sand
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.metal_yellow
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 0, 0, 0, 0
  .word equinoxe_flightengine.metal_yellow
  .byte $1e, $13, $15, $e
  .word equinoxe_flightengine.mars_land
  .byte 0, 0, 0, 1
  .word equinoxe_flightengine.metal_yellow
  .byte $13, $1b, $d, $1a
  .word equinoxe_flightengine.mars_land
  .byte 0, 0, 2, 0
  .word equinoxe_flightengine.metal_yellow
  .byte $13, $13, 3, 3
  .word equinoxe_flightengine.mars_land
  .byte 0, 0, 3, 3
  .word equinoxe_flightengine.metal_yellow
  .byte $15, $b, $1b, $1c
  .word equinoxe_flightengine.mars_land
  .byte 0, 4, 0, 0
  .word equinoxe_flightengine.metal_yellow
  .byte $15, 5, $15, 5
  .word equinoxe_flightengine.mars_land
  .byte 0, 5, 0, 5
  .word equinoxe_flightengine.metal_yellow
  .byte $11, $b, $d, $18
  .word equinoxe_flightengine.mars_land
  .byte 0, 4, 2, 0
  .word equinoxe_flightengine.metal_yellow
  .byte $11, 5, 3, 1
  .word equinoxe_flightengine.mars_land
  .byte 0, 5, 3, 7
  .word equinoxe_flightengine.metal_yellow
  .byte 7, $1a, $1c, $17
  .word equinoxe_flightengine.mars_land
  .byte 8, 0, 0, 0
  .word equinoxe_flightengine.metal_yellow
  .byte 7, $12, $14, $e
  .word equinoxe_flightengine.mars_land
  .byte 8, 0, 0, 1
  .word equinoxe_flightengine.metal_yellow
  .byte $a, $1a, $a, $1a
  .word equinoxe_flightengine.mars_land
  .byte $a, 0, $a, 0
  .word equinoxe_flightengine.metal_yellow
  .byte $a, $12, 2, 3
  .word equinoxe_flightengine.mars_land
  .byte $a, 0, $b, 3
  .word equinoxe_flightengine.metal_yellow
  .byte $c, $c, $1c, $1c
  .word equinoxe_flightengine.mars_land
  .byte $c, $c, 0, 0
  .word equinoxe_flightengine.metal_yellow
  .byte $c, 4, $14, 5
  .word equinoxe_flightengine.mars_land
  .byte $c, $d, 0, 5
  .word equinoxe_flightengine.metal_yellow
  .byte 8, $c, $a, $18
  .word equinoxe_flightengine.mars_land
  .byte $e, $c, $a, 0
  .word equinoxe_flightengine.metal_yellow
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte $f, $f, $f, $f
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .byte 0
  // TOWER
  tower_bram: .byte 0
  .text "tower01"
  .byte 0
  .fill 8, 0
  .byte $10
  .word $10*$10*$10, $80, 0
  tower_parts_01: .word 0
  .fill 2*$9f, 0
  .word 0
  .fill 2*$9f, 0
  .byte 0
  .fill $9f, 0
  .byte 0
  .fill $9f, 0
  .byte 0
  .fill $9f, 0
  tower: .byte 0, 5, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, 1, 1, 2, 5, 6, 2, 3, 4, 7, 8, 3, 9, $a, $d, $e, 4, $b, $c, $f, $10
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  tower_01: .word equinoxe_flightengine.tower_parts_01, equinoxe_flightengine.mars_sea, equinoxe_flightengine.mars_land
  .fill 2*8, 0
  .word equinoxe_flightengine.mars_sea
  .byte $f, $f, $f, $f
  .word equinoxe_flightengine.mars_land
  .byte 0, 0, 0, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill equinoxe_flightengine.SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .byte 0
.segment BramEngineStages
  stage_bullet_fireball: .byte $12
  stage_bullet_vertical_laser: .byte $13
  stage_enemy_e0101: .byte 3, 3
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 0
  stage_enemy_e0102: .byte 4, 4
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 0
  stage_enemy_e0201: .byte 5, 5
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 0
  stage_enemy_e0202: .byte 6, 6
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 0
  stage_enemy_e0301: .byte 7, 7
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0302: .byte 8, 8
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0401: .byte 9, 9
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0501: .byte $a, $a
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0502: .byte $b, $b
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0601: .byte $c, $c
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0602: .byte $d, $d
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0701: .byte 3, 3
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0702: .byte $f, $f
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0703: .byte $10, $10
  .word equinoxe_flightengine.stage_bullet_fireball
  .byte 8, 1
  stage_player_engine: .byte 2
  stage_player_bullet: .byte $11
  stage_player: .byte 1
  .word equinoxe_flightengine.stage_player_engine, equinoxe_flightengine.stage_player_bullet
  stage_floor_01: .byte 6
  .word equinoxe_flightengine.stage_floor_bram_tiles_01, equinoxe_flightengine.mars
  stage_towers_01: .byte 2
  .word equinoxe_flightengine.stage_tower_bram_tiles_01, equinoxe_flightengine.tower_01
  .byte 0, $10, $10, 8, 8
  .word equinoxe_flightengine.stage_bullet_vertical_laser
  stage_script_b: .byte 1
  .word equinoxe_flightengine.stage_playbooks_b
.segment DataSpriteCache
  // Cache to manage sprite control data fast, unbanked as making this banked will make things very, very complicated.
  sprite_cache: .fill equinoxe_flightengine.SIZEOF_STRUCT_FE_SPRITE_CACHE_T, 0
.segment DataEngineFlight
  flight: .fill equinoxe_flightengine.SIZEOF_STRUCT_FLIGHT_T, 0
  sprite_cache_pool: .byte 0
  flight_sprite_offset_pool: .byte 1
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

