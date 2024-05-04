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
  /**
 * @file kernal.h
 * @author your name (you@domain.com)
 * @brief Most common CBM Kernal calls with it's dialects in the different CBM kernal family platforms.
 * Please refer to http://sta.c64.org/cbm64krnfunc.html for the list of standard CBM C64 kernal functions.
 *
 * @version 1.0
 * @date 2023-03-22
 *
 * @copyright Copyright (c) 2023
 *
 */
  .label CBM_SETNAM = $ffbd
  ///< Set the name of a file.
  .label CBM_SETLFS = $ffba
  ///< Set the logical file.
  .label CBM_OPEN = $ffc0
  ///< Open the file for the current logical file.
  .label CBM_CHKIN = $ffc6
  ///< Set the logical channel for input.
  .label CBM_READST = $ffb7
  ///< Check I/O errors.
  .label CBM_CHRIN = $ffcf
  ///< Scan a character from the keyboard.
  .label CBM_CLOSE = $ffc3
  ///< CX16 Set character set.
  .label CX16_MACPTR = $ff44
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
  .label FE_CACHE = $10
  .label SIZEOF_STRUCT_SPRITE_FILE_HEADER_T = $10
  .label OFFSET_STRUCT_FILE_CHANNEL = $80
  .label OFFSET_STRUCT_FILE_DEVICE = $84
  .label OFFSET_STRUCT_FILE_SECONDARY = $88
  .label OFFSET_STRUCT_FILE_STATUS = $8c
  .label OFFSET_STRUCT_FLIGHT_T_INDEX = $a55
  .label OFFSET_STRUCT_FLIGHT_T_USED = $c0
  .label OFFSET_STRUCT_FLIGHT_T_ROOT = $a41
  .label OFFSET_STRUCT_FLIGHT_T_NEXT = $9c1
  .label OFFSET_STRUCT_FLIGHT_T_PREV = $a01
  .label OFFSET_STRUCT_FLIGHT_T_COUNT = $a4b
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
  .label SIZEOF_STRUCT_FILE = $90
  .label SIZEOF_STRUCT_AABB_T = 4
  .label SIZEOF_STRUCT_FLOOR_SEGMENT_T = 5
  .label SIZEOF_STRUCT_FLOOR_COMPOSITION_T = $c
  .label SIZEOF_STRUCT_FE_SPRITE_CACHE_T = $250
  .label SIZEOF_STRUCT_FLIGHT_T = $a56
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
  .label __errno = $d5
  .label BRAM = 0
  .label BROM = 1
  .label __stdio_filecount = $e5
  .label sprite_cache_pool = $d8
  .label flight_sprite_offset_pool = $d4
.segment Code
  // __equinoxe_flightengine_start
// void __equinoxe_flightengine_start()
__equinoxe_flightengine_start: {
    // __equinoxe_flightengine_start::__init1
    // int __errno
    // [1] __errno = 0 -- vwsz1=vwsc1 
    lda #<0
    sta.z __errno
    sta.z __errno+1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [2] BRAM = 0 -- vbuz1=vbuc1 
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [3] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // volatile unsigned char __stdio_filecount = 0
    // [4] __stdio_filecount = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z __stdio_filecount
    // volatile fe_t sprite_cache_pool
    // [5] sprite_cache_pool = 0 -- vbuz1=vbuc1 
    sta.z sprite_cache_pool
    // volatile unsigned char flight_sprite_offset_pool = 1
    // [6] flight_sprite_offset_pool = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z flight_sprite_offset_pool
    // __equinoxe_flightengine_start::@return
    // [7] return 
    rts
}
.segment CodeEngineFlight
  // flight_draw
// void flight_draw()
flight_draw: {
    .label i = $de
    .label flight_draw__13 = $c9
    .label f = $bc
    .label x = $dc
    .label y = $e2
    .label sprite_offset = $c9
    .label a = $a2
    .label s = $b4
    .label sprite_image_offset = $ad
    // [9] phi from flight_draw to flight_draw::@1 [phi:flight_draw->flight_draw::@1]
    // [9] phi flight_draw::f#10 = 0 [phi:flight_draw->flight_draw::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z f
    // flight_draw::@1
  __b1:
    // for (unsigned char f = 0; f < FLIGHT_OBJECTS; f++)
    // [10] if(flight_draw::f#10<$40) goto flight_draw::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z f
    cmp #$40
    bcc __b2
    // flight_draw::@return
    // }
    // [11] return 
    rts
    // flight_draw::@2
  __b2:
    // if (flight.used[f])
    // [12] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[flight_draw::f#10]) goto flight_draw::@3 -- 0_eq_pbuc1_derefidx_vbuz1_then_la1 
    ldy.z f
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    bne !__b3+
    jmp __b3
  !__b3:
    // flight_draw::@7
    // unsigned int x = flight.xi[f]
    // [13] flight_draw::$22 = flight_draw::f#10 << 1 -- vbuxx=vbuz1_rol_1 
    tya
    asl
    tax
    // [14] flight_draw::x#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[flight_draw::$22] -- vwuz1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    sta.z x
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    sta.z x+1
    // unsigned int y = flight.yi[f]
    // [15] flight_draw::y#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[flight_draw::$22] -- vwuz1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    sta.z y
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    sta.z y+1
    // vera_sprite_offset sprite_offset = flight.sprite_offset[f]
    // [16] flight_draw::sprite_offset#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET)[flight_draw::$22] -- vwuz1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET,x
    sta.z sprite_offset
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET+1,x
    sta.z sprite_offset+1
    // unsigned char a = flight.animate[f]
    // [17] flight_draw::a#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[flight_draw::f#10] -- vbuz1=pbuc1_derefidx_vbuz2 
    // if( x<640+68 && y<480+68 && (signed int)x>-68 && (signed int)y>-68 ) {
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    sta.z a
    // unsigned char s = animate_get_image(a)
    // [18] animate_get_image::a = flight_draw::a#0 -- vbuz1=vbuz2 
    sta.z equinoxe_animate.animate_get_image.a
    // [19] callexecute animate_get_image  -- call_var_near 
    jsr equinoxe_animate.animate_get_image
    // [20] flight_draw::s#0 = animate_get_image::return -- vbuz1=vbuz2 
    lda.z equinoxe_animate.animate_get_image.return
    sta.z s
    // volatile unsigned char i = flight.cache[f]
    // [21] flight_draw::i = ((char *)&flight)[flight_draw::f#10] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z f
    lda equinoxe_flightengine.flight,y
    sta.z i
    // animate_is_waiting(a)
    // [22] animate_is_waiting::a = flight_draw::a#0 -- vbuz1=vbuz2 
    lda.z a
    sta.z equinoxe_animate.animate_is_waiting.a
    // [23] callexecute animate_is_waiting  -- call_var_near 
    jsr equinoxe_animate.animate_is_waiting
    // [24] flight_draw::$3 = animate_is_waiting::return -- vbuaa=vbuz1 
    lda.z equinoxe_animate.animate_is_waiting.return
    // if (animate_is_waiting(a))
    // [25] if(0!=flight_draw::$3) goto flight_draw::@4 -- 0_neq_vbuaa_then_la1 
    // This variable needs to be volatile or the kickc optimizer kills it.
    cmp #0
    bne __b4
    // flight_draw::@8
    // vera_sprite_image_offset sprite_image_offset = sprite_image_cache_vram(i, s)
    // [26] sprite_image_cache_vram::sprite_cache_index = flight_draw::i -- vbuz1=vbuz2 
    lda.z i
    sta.z equinoxe_flightengine.sprite_image_cache_vram.sprite_cache_index
    // [27] sprite_image_cache_vram::fe_sprite_image_index = flight_draw::s#0
    // [28] callexecute sprite_image_cache_vram  -- call_var_near 
    jsr sprite_image_cache_vram
    // [29] flight_draw::sprite_image_offset#0 = sprite_image_cache_vram::return
    // if(sprite_image_offset==0x0)
    // [30] if(flight_draw::sprite_image_offset#0!=0) goto flight_draw::@5 -- vwuz1_neq_0_then_la1 
    lda.z sprite_image_offset
    ora.z sprite_image_offset+1
    bne __b5
    // flight_draw::@9
    // BREAKPOINT
    // asm { .byte$db  }
    .byte $db
    // flight_draw::@5
  __b5:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [32] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // gotoxy(0,0);
    // printf("%02x %04x, ", f, sprite_image_offset);
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_H = 1 | VERA_INC_1
    // [33] *VERA_ADDRX_H = 1|VERA_INC_1 -- _deref_pbuc1=vbuc2 
    // Select DATA0
    lda #1|VERA_INC_1
    sta VERA_ADDRX_H
    // BYTE1(sprite_offset)
    // [34] flight_draw::$7 = byte1  flight_draw::sprite_offset#0 -- vbuaa=_byte1_vwuz1 
    lda.z sprite_offset+1
    // *VERA_ADDRX_M = BYTE1(sprite_offset)
    // [35] *VERA_ADDRX_M = flight_draw::$7 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // BYTE0(sprite_offset)
    // [36] flight_draw::$8 = byte0  flight_draw::sprite_offset#0 -- vbuaa=_byte0_vwuz1 
    lda.z sprite_offset
    // *VERA_ADDRX_L = BYTE0(sprite_offset)
    // [37] *VERA_ADDRX_L = flight_draw::$8 -- _deref_pbuc1=vbuaa 
    // Normally the +2 should not be an issue.
    sta VERA_ADDRX_L
    // BYTE0(sprite_image_offset)
    // [38] flight_draw::$9 = byte0  flight_draw::sprite_image_offset#0 -- vbuaa=_byte0_vwuz1 
    lda.z sprite_image_offset
    // *VERA_DATA0 = BYTE0(sprite_image_offset)
    // [39] *VERA_DATA0 = flight_draw::$9 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // BYTE1(sprite_image_offset)
    // [40] flight_draw::$10 = byte1  flight_draw::sprite_image_offset#0 -- vbuaa=_byte1_vwuz1 
    lda.z sprite_image_offset+1
    // *VERA_DATA0 = BYTE1(sprite_image_offset)
    // [41] *VERA_DATA0 = flight_draw::$10 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // flight_draw::@6
  __b6:
    // BYTE0(x)
    // [42] flight_draw::$15 = byte0  flight_draw::x#0 -- vbuaa=_byte0_vwuz1 
    lda.z x
    // *VERA_DATA0 = BYTE0(x)
    // [43] *VERA_DATA0 = flight_draw::$15 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // BYTE1(x)
    // [44] flight_draw::$16 = byte1  flight_draw::x#0 -- vbuaa=_byte1_vwuz1 
    lda.z x+1
    // *VERA_DATA0 = BYTE1(x)
    // [45] *VERA_DATA0 = flight_draw::$16 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // BYTE0(y)
    // [46] flight_draw::$17 = byte0  flight_draw::y#0 -- vbuaa=_byte0_vwuz1 
    lda.z y
    // *VERA_DATA0 = BYTE0(y)
    // [47] *VERA_DATA0 = flight_draw::$17 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // BYTE1(y)
    // [48] flight_draw::$18 = byte1  flight_draw::y#0 -- vbuaa=_byte1_vwuz1 
    lda.z y+1
    // *VERA_DATA0 = BYTE1(y)
    // [49] *VERA_DATA0 = flight_draw::$18 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_ADDRX_H = 1 | VERA_INC_0
    // [50] *VERA_ADDRX_H = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [51] flight_draw::$19 = *VERA_DATA0 & ~$c -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$c^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | sprite_cache.zdepth[flight.cache[f]]
    // [52] flight_draw::$20 = flight_draw::$19 | ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_ZDEPTH)[((char *)&flight)[flight_draw::f#10]] -- vbuaa=vbuaa_bor_pbuc1_derefidx_(pbuc2_derefidx_vbuz1) 
    ldx.z f
    ldy equinoxe_flightengine.flight,x
    ora equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_ZDEPTH,y
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | sprite_cache.zdepth[flight.cache[f]]
    // [53] *VERA_DATA0 = flight_draw::$20 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // flight_draw::@3
  __b3:
    // for (unsigned char f = 0; f < FLIGHT_OBJECTS; f++)
    // [54] flight_draw::f#1 = ++ flight_draw::f#10 -- vbuz1=_inc_vbuz1 
    inc.z f
    // [9] phi from flight_draw::@3 to flight_draw::@1 [phi:flight_draw::@3->flight_draw::@1]
    // [9] phi flight_draw::f#10 = flight_draw::f#1 [phi:flight_draw::@3->flight_draw::@1#0] -- register_copy 
    jmp __b1
    // flight_draw::@4
  __b4:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [55] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_H = 1 | VERA_INC_1
    // [56] *VERA_ADDRX_H = 1|VERA_INC_1 -- _deref_pbuc1=vbuc2 
    // Select DATA0
    lda #1|VERA_INC_1
    sta VERA_ADDRX_H
    // sprite_offset + 2
    // [57] flight_draw::$13 = flight_draw::sprite_offset#0 + 2 -- vwuz1=vwuz1_plus_vbuc1 
    lda #2
    clc
    adc.z flight_draw__13
    sta.z flight_draw__13
    bcc !+
    inc.z flight_draw__13+1
  !:
    // BYTE1(sprite_offset + 2)
    // [58] flight_draw::$12 = byte1  flight_draw::$13 -- vbuaa=_byte1_vwuz1 
    lda.z flight_draw__13+1
    // *VERA_ADDRX_M = BYTE1(sprite_offset + 2)
    // [59] *VERA_ADDRX_M = flight_draw::$12 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // BYTE0(sprite_offset + 2)
    // [60] flight_draw::$14 = byte0  flight_draw::$13 -- vbuaa=_byte0_vwuz1 
    lda.z flight_draw__13
    // *VERA_ADDRX_L = BYTE0(sprite_offset + 2)
    // [61] *VERA_ADDRX_L = flight_draw::$14 -- _deref_pbuc1=vbuaa 
    // Normally the +2 should not be an issue.
    sta VERA_ADDRX_L
    jmp __b6
}
  // flight_init
// void flight_init()
flight_init: {
    .const memset_fast1_ch = $ff
    .const memset_fast2_ch = 0
    .const memset_fast3_ch = 0
    .label memset_fast1_destination = equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SPRITE_BRAM
    .label memset_fast2_destination = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT
    .label memset_fast3_destination = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COUNT
    // [63] phi from flight_init to flight_init::memset_fast1 [phi:flight_init->flight_init::memset_fast1]
    // flight_init::memset_fast1
    // [64] phi from flight_init::memset_fast1 to flight_init::memset_fast1_@1 [phi:flight_init::memset_fast1->flight_init::memset_fast1_@1]
    // [64] phi flight_init::memset_fast1_num#2 = $10 [phi:flight_init::memset_fast1->flight_init::memset_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #$10
    // [64] phi flight_init::memset_fast1_x#2 = 0 [phi:flight_init::memset_fast1->flight_init::memset_fast1_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [64] phi from flight_init::memset_fast1_@1 to flight_init::memset_fast1_@1 [phi:flight_init::memset_fast1_@1->flight_init::memset_fast1_@1]
    // [64] phi flight_init::memset_fast1_num#2 = flight_init::memset_fast1_num#1 [phi:flight_init::memset_fast1_@1->flight_init::memset_fast1_@1#0] -- register_copy 
    // [64] phi flight_init::memset_fast1_x#2 = flight_init::memset_fast1_x#1 [phi:flight_init::memset_fast1_@1->flight_init::memset_fast1_@1#1] -- register_copy 
    // flight_init::memset_fast1_@1
  memset_fast1___b1:
    // destination[x] = ch
    // [65] flight_init::memset_fast1_destination#0[flight_init::memset_fast1_x#2] = flight_init::memset_fast1_ch#0 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #memset_fast1_ch
    sta memset_fast1_destination,y
    // x++;
    // [66] flight_init::memset_fast1_x#1 = ++ flight_init::memset_fast1_x#2 -- vbuyy=_inc_vbuyy 
    iny
    // num--;
    // [67] flight_init::memset_fast1_num#1 = -- flight_init::memset_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [68] if(0!=flight_init::memset_fast1_num#1) goto flight_init::memset_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast1___b1
    // flight_init::@1
    // flight_sprite_offset_pool = 1
    // [69] flight_sprite_offset_pool = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z flight_sprite_offset_pool
    // [70] phi from flight_init::@1 to flight_init::memset_fast2 [phi:flight_init::@1->flight_init::memset_fast2]
    // flight_init::memset_fast2
    // [71] phi from flight_init::memset_fast2 to flight_init::memset_fast2_@1 [phi:flight_init::memset_fast2->flight_init::memset_fast2_@1]
    // [71] phi flight_init::memset_fast2_num#2 = $a [phi:flight_init::memset_fast2->flight_init::memset_fast2_@1#0] -- vbuyy=vbuc1 
    ldy #$a
    // [71] phi flight_init::memset_fast2_x#2 = 0 [phi:flight_init::memset_fast2->flight_init::memset_fast2_@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [71] phi from flight_init::memset_fast2_@1 to flight_init::memset_fast2_@1 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast2_@1]
    // [71] phi flight_init::memset_fast2_num#2 = flight_init::memset_fast2_num#1 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast2_@1#0] -- register_copy 
    // [71] phi flight_init::memset_fast2_x#2 = flight_init::memset_fast2_x#1 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast2_@1#1] -- register_copy 
    // flight_init::memset_fast2_@1
  memset_fast2___b1:
    // destination[x] = ch
    // [72] flight_init::memset_fast2_destination#0[flight_init::memset_fast2_x#2] = flight_init::memset_fast2_ch#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast2_ch
    sta memset_fast2_destination,x
    // x++;
    // [73] flight_init::memset_fast2_x#1 = ++ flight_init::memset_fast2_x#2 -- vbuxx=_inc_vbuxx 
    inx
    // num--;
    // [74] flight_init::memset_fast2_num#1 = -- flight_init::memset_fast2_num#2 -- vbuyy=_dec_vbuyy 
    dey
    // while(num)
    // [75] if(0!=flight_init::memset_fast2_num#1) goto flight_init::memset_fast2_@1 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne memset_fast2___b1
    // [76] phi from flight_init::memset_fast2_@1 to flight_init::memset_fast3 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast3]
    // flight_init::memset_fast3
    // [77] phi from flight_init::memset_fast3 to flight_init::memset_fast3_@1 [phi:flight_init::memset_fast3->flight_init::memset_fast3_@1]
    // [77] phi flight_init::memset_fast3_num#2 = $a [phi:flight_init::memset_fast3->flight_init::memset_fast3_@1#0] -- vbuyy=vbuc1 
    ldy #$a
    // [77] phi flight_init::memset_fast3_x#2 = 0 [phi:flight_init::memset_fast3->flight_init::memset_fast3_@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [77] phi from flight_init::memset_fast3_@1 to flight_init::memset_fast3_@1 [phi:flight_init::memset_fast3_@1->flight_init::memset_fast3_@1]
    // [77] phi flight_init::memset_fast3_num#2 = flight_init::memset_fast3_num#1 [phi:flight_init::memset_fast3_@1->flight_init::memset_fast3_@1#0] -- register_copy 
    // [77] phi flight_init::memset_fast3_x#2 = flight_init::memset_fast3_x#1 [phi:flight_init::memset_fast3_@1->flight_init::memset_fast3_@1#1] -- register_copy 
    // flight_init::memset_fast3_@1
  memset_fast3___b1:
    // destination[x] = ch
    // [78] flight_init::memset_fast3_destination#0[flight_init::memset_fast3_x#2] = flight_init::memset_fast3_ch#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast3_ch
    sta memset_fast3_destination,x
    // x++;
    // [79] flight_init::memset_fast3_x#1 = ++ flight_init::memset_fast3_x#2 -- vbuxx=_inc_vbuxx 
    inx
    // num--;
    // [80] flight_init::memset_fast3_num#1 = -- flight_init::memset_fast3_num#2 -- vbuyy=_dec_vbuyy 
    dey
    // while(num)
    // [81] if(0!=flight_init::memset_fast3_num#1) goto flight_init::memset_fast3_@1 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne memset_fast3___b1
    // flight_init::@return
    // }
    // [82] return 
    rts
}
  // fe_sprite_bram_load
// Load the sprite into bram using the new cx16 heap manager.
// __zp($a0) unsigned int fe_sprite_bram_load(__zp($da) char sprite_index, __zp($a0) unsigned int sprite_offset)
fe_sprite_bram_load: {
    .const bank_push_set_bram1_bank = 4
    .const bank_push_set_bram2_bank = 6
    .label sprite_index = $da
    .label sprite_offset = $a0
    .label return = $a0
    .label sprite_file_header = $e6
    .label fe_sprite_bram_load__24 = $c9
    .label fp = $ad
    .label read = $dc
    .label palette_index = $d7
    .label palette_ptr = $e2
    .label sprite_size = $b1
    .label handle_bram = $c3
    .label sprite_ptr = $cb
    .label bank_push_set_bram3_bank = $b3
    .label read1 = $a5
    .label s = $a2
    .label fe_sprite_bram_load__34 = $a5
    // fe_sprite_bram_load::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [117] BRAM = fe_sprite_bram_load::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // fe_sprite_bram_load::@10
    // if (!sprites.loaded[sprite_index])
    // [118] if(0!=((char *)&sprites+OFFSET_STRUCT_SPRITE_T_LOADED)[fe_sprite_bram_load::sprite_index]) goto fe_sprite_bram_load::bank_pull_bram1 -- 0_neq_pbuc1_derefidx_vbuz1_then_la1 
    ldy.z sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_LOADED,y
    cmp #0
    beq !bank_pull_bram1+
    jmp bank_pull_bram1
  !bank_pull_bram1:
    // fe_sprite_bram_load::@1
    // strcpy(filename, sprites.file[sprite_index])
    // [119] fe_sprite_bram_load::$25 = fe_sprite_bram_load::sprite_index << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [120] strcpy::source#1 = ((char **)&sprites)[fe_sprite_bram_load::$25] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda sprites,y
    sta.z strcpy.source
    lda sprites+1,y
    sta.z strcpy.source+1
    // [121] call strcpy
    // [404] phi from fe_sprite_bram_load::@1 to strcpy [phi:fe_sprite_bram_load::@1->strcpy]
    // [404] phi strcpy::dst#0 = fe_sprite_bram_load::filename [phi:fe_sprite_bram_load::@1->strcpy#0] -- pbuz1=pbuc1 
    lda #<filename
    sta.z strcpy.dst
    lda #>filename
    sta.z strcpy.dst+1
    // [404] phi strcpy::src#0 = strcpy::source#1 [phi:fe_sprite_bram_load::@1->strcpy#1] -- register_copy 
    jsr strcpy
    // [122] phi from fe_sprite_bram_load::@1 to fe_sprite_bram_load::@16 [phi:fe_sprite_bram_load::@1->fe_sprite_bram_load::@16]
    // fe_sprite_bram_load::@16
    // strcat(filename, ".bin")
    // [123] call strcat
    // [412] phi from fe_sprite_bram_load::@16 to strcat [phi:fe_sprite_bram_load::@16->strcat]
    jsr strcat
    // [124] phi from fe_sprite_bram_load::@16 to fe_sprite_bram_load::@17 [phi:fe_sprite_bram_load::@16->fe_sprite_bram_load::@17]
    // fe_sprite_bram_load::@17
    // FILE *fp = fopen(filename, "r")
    // [125] call fopen
    jsr fopen
    // [126] fopen::return#3 = fopen::return#2
    // fe_sprite_bram_load::@18
    // [127] fe_sprite_bram_load::fp#0 = fopen::return#3 -- pssz1=pssz2 
    lda.z fopen.return
    sta.z fp
    lda.z fopen.return+1
    sta.z fp+1
    // if (!fp)
    // [128] if((FILE *)0==fe_sprite_bram_load::fp#0) goto fe_sprite_bram_load::bank_pull_bram1 -- pssc1_eq_pssz1_then_la1 
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
    // [129] *(&fe_sprite_bram_load::sprite_file_header) = memset(sprite_file_header_t, SIZEOF_STRUCT_SPRITE_FILE_HEADER_T) -- _deref_pssc1=_memset_vbuc2 
    ldy #SIZEOF_STRUCT_SPRITE_FILE_HEADER_T
    lda #0
  !:
    dey
    sta sprite_file_header,y
    bne !-
    // unsigned int read = fgets((char *)&sprite_file_header, sizeof(sprite_file_header_t), fp)
    // [130] fgets::stream#0 = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fgets.stream
    lda.z fp+1
    sta.z fgets.stream+1
    // [131] call fgets
  // Read the header of the file into the sprite_file_header structure.
    // [503] phi from fe_sprite_bram_load::@2 to fgets [phi:fe_sprite_bram_load::@2->fgets]
    // [503] phi fgets::ptr#13 = (char *)&fe_sprite_bram_load::sprite_file_header [phi:fe_sprite_bram_load::@2->fgets#0] -- pbuz1=pbuc1 
    lda #<sprite_file_header
    sta.z fgets.ptr
    lda #>sprite_file_header
    sta.z fgets.ptr+1
    // [503] phi fgets::size#11 = SIZEOF_STRUCT_SPRITE_FILE_HEADER_T [phi:fe_sprite_bram_load::@2->fgets#1] -- vwuz1=vbuc1 
    lda #<SIZEOF_STRUCT_SPRITE_FILE_HEADER_T
    sta.z fgets.size
    lda #>SIZEOF_STRUCT_SPRITE_FILE_HEADER_T
    sta.z fgets.size+1
    // [503] phi fgets::stream#3 = fgets::stream#0 [phi:fe_sprite_bram_load::@2->fgets#2] -- register_copy 
    jsr fgets
    // unsigned int read = fgets((char *)&sprite_file_header, sizeof(sprite_file_header_t), fp)
    // [132] fgets::return#5 = fgets::return#1
    // fe_sprite_bram_load::@19
    // [133] fe_sprite_bram_load::read#0 = fgets::return#5 -- vwuz1=vwuz2 
    lda.z fgets.return
    sta.z read
    lda.z fgets.return+1
    sta.z read+1
    // if (!read)
    // [134] if(0==fe_sprite_bram_load::read#0) goto fe_sprite_bram_load::bank_pull_bram1 -- 0_eq_vwuz1_then_la1 
    lda.z read
    ora.z read+1
    bne !bank_pull_bram1+
    jmp bank_pull_bram1
  !bank_pull_bram1:
    // fe_sprite_bram_load::@3
    // sprite_map_header(&sprite_file_header, sprite_index)
    // [135] sprite_map_header::sprite#0 = fe_sprite_bram_load::sprite_index -- vbuz1=vbuz2 
    lda.z sprite_index
    sta.z sprite_map_header.sprite
    // [136] call sprite_map_header
    jsr sprite_map_header
    // [137] phi from fe_sprite_bram_load::@3 to fe_sprite_bram_load::@20 [phi:fe_sprite_bram_load::@3->fe_sprite_bram_load::@20]
    // fe_sprite_bram_load::@20
    // palette_index_t palette_index = palette_alloc_bram()
    // [138] callexecute palette_alloc_bram  -- call_var_near 
    jsr equinoxe_palette.palette_alloc_bram
    // [139] fe_sprite_bram_load::palette_index#0 = palette_alloc_bram::return -- vbuz1=vbuz2 
    lda.z equinoxe_palette.palette_alloc_bram.return
    sta.z palette_index
    // palette_ptr_t palette_ptr = palette_ptr_bram(palette_index)
    // [140] palette_ptr_bram::palette_index = fe_sprite_bram_load::palette_index#0 -- vbuz1=vbuz2 
    sta.z equinoxe_palette.palette_ptr_bram.palette_index
    // [141] callexecute palette_ptr_bram  -- call_var_near 
    jsr equinoxe_palette.palette_ptr_bram
    // [142] fe_sprite_bram_load::palette_ptr#0 = palette_ptr_bram::return -- pssz1=pssz2 
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
    // [144] BRAM = fe_sprite_bram_load::bank_push_set_bram2_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram2_bank
    sta.z BRAM
    // fe_sprite_bram_load::@12
    // fgets((char *)palette_ptr, 32, fp)
    // [145] fgets::ptr#3 = (char *)fe_sprite_bram_load::palette_ptr#0 -- pbuz1=pbuz2 
    lda.z palette_ptr
    sta.z fgets.ptr
    lda.z palette_ptr+1
    sta.z fgets.ptr+1
    // [146] fgets::stream#1 = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fgets.stream
    lda.z fp+1
    sta.z fgets.stream+1
    // [147] call fgets
    // [503] phi from fe_sprite_bram_load::@12 to fgets [phi:fe_sprite_bram_load::@12->fgets]
    // [503] phi fgets::ptr#13 = fgets::ptr#3 [phi:fe_sprite_bram_load::@12->fgets#0] -- register_copy 
    // [503] phi fgets::size#11 = $20 [phi:fe_sprite_bram_load::@12->fgets#1] -- vwuz1=vbuc1 
    lda #<$20
    sta.z fgets.size
    lda #>$20
    sta.z fgets.size+1
    // [503] phi fgets::stream#3 = fgets::stream#1 [phi:fe_sprite_bram_load::@12->fgets#2] -- register_copy 
    jsr fgets
    // fe_sprite_bram_load::bank_pull_bram2
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_bram_load::@13
    // sprites.PaletteOffset[sprite_index] = palette_index
    // [149] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET)[fe_sprite_bram_load::sprite_index] = fe_sprite_bram_load::palette_index#0 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z palette_index
    ldy.z sprite_index
    sta sprites+OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET,y
    // sprites.offset[sprite_index] = sprite_offset
    // [150] fe_sprite_bram_load::$26 = fe_sprite_bram_load::sprite_index << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [151] ((unsigned int *)&sprites+OFFSET_STRUCT_SPRITE_T_OFFSET)[fe_sprite_bram_load::$26] = fe_sprite_bram_load::sprite_offset -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z sprite_offset
    sta sprites+OFFSET_STRUCT_SPRITE_T_OFFSET,y
    lda.z sprite_offset+1
    sta sprites+OFFSET_STRUCT_SPRITE_T_OFFSET+1,y
    // unsigned int sprite_size = sprites.SpriteSize[sprite_index]
    // [152] fe_sprite_bram_load::$27 = fe_sprite_bram_load::sprite_index << 1 -- vbuaa=vbuz1_rol_1 
    lda.z sprite_index
    asl
    // [153] fe_sprite_bram_load::sprite_size#0 = ((unsigned int *)&sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE)[fe_sprite_bram_load::$27] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE,y
    sta.z sprite_size
    lda sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE+1,y
    sta.z sprite_size+1
    // [154] phi from fe_sprite_bram_load::@13 to fe_sprite_bram_load::@4 [phi:fe_sprite_bram_load::@13->fe_sprite_bram_load::@4]
    // [154] phi fe_sprite_bram_load::s#10 = 0 [phi:fe_sprite_bram_load::@13->fe_sprite_bram_load::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z s
    // fe_sprite_bram_load::@4
  __b4:
    // for (unsigned char s = 0; s < sprites.count[sprite_index]; s++)
    // [155] if(fe_sprite_bram_load::s#10<((char *)&sprites+OFFSET_STRUCT_SPRITE_T_COUNT)[fe_sprite_bram_load::sprite_index]) goto fe_sprite_bram_load::@5 -- vbuz1_lt_pbuc1_derefidx_vbuz2_then_la1 
    lda.z s
    ldy.z sprite_index
    cmp sprites+OFFSET_STRUCT_SPRITE_T_COUNT,y
    bcc __b5
    // fe_sprite_bram_load::@6
    // fclose(fp)
    // [156] fclose::stream#0 = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fclose.stream
    lda.z fp+1
    sta.z fclose.stream+1
    // [157] call fclose
    jsr fclose
    // [158] fclose::return#4 = fclose::return#1
    // fe_sprite_bram_load::@22
    // [159] fe_sprite_bram_load::$24 = fclose::return#4 -- vwsz1=vwsz2 
    lda.z fclose.return
    sta.z fe_sprite_bram_load__24
    lda.z fclose.return+1
    sta.z fe_sprite_bram_load__24+1
    // if (fclose(fp))
    // [160] if(0!=fe_sprite_bram_load::$24) goto fe_sprite_bram_load::bank_pull_bram1 -- 0_neq_vwsz1_then_la1 
    // Now we have read everything and we close the file.
    ora.z fe_sprite_bram_load__24
    bne bank_pull_bram1
    // fe_sprite_bram_load::@9
    // sprites.loaded[sprite_index] = 1
    // [161] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_LOADED)[fe_sprite_bram_load::sprite_index] = 1 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #1
    ldy.z sprite_index
    sta sprites+OFFSET_STRUCT_SPRITE_T_LOADED,y
    // fe_sprite_bram_load::bank_pull_bram1
  bank_pull_bram1:
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_bram_load::@11
    // return sprite_offset;
    // [163] fe_sprite_bram_load::return = fe_sprite_bram_load::sprite_offset
    // fe_sprite_bram_load::@return
    // }
    // [164] return 
    rts
    // fe_sprite_bram_load::@5
  __b5:
    // bram_heap_handle_t handle_bram = bram_heap_alloc(0, sprite_size)
    // [165] bram_heap_alloc::s = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_bramheap.bram_heap_alloc.s
    // [166] bram_heap_alloc::size = fe_sprite_bram_load::sprite_size#0 -- vduz1=vwuz2 
    lda.z sprite_size
    sta.z lib_bramheap.bram_heap_alloc.size
    lda.z sprite_size+1
    sta.z lib_bramheap.bram_heap_alloc.size+1
    lda #0
    sta.z lib_bramheap.bram_heap_alloc.size+2
    sta.z lib_bramheap.bram_heap_alloc.size+3
    // [167] callexecute bram_heap_alloc  -- call_var_near 
    jsr lib_bramheap.bram_heap_alloc
    // [168] fe_sprite_bram_load::handle_bram#0 = bram_heap_alloc::return -- vbuz1=vbuz2 
    lda.z lib_bramheap.bram_heap_alloc.return
    sta.z handle_bram
    // bram_bank_t sprite_bank = bram_heap_data_get_bank(0, handle_bram)
    // [169] bram_heap_data_get_bank::s = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_bramheap.bram_heap_data_get_bank.s
    // [170] bram_heap_data_get_bank::index = fe_sprite_bram_load::handle_bram#0 -- vbuz1=vbuz2 
    lda.z handle_bram
    sta.z lib_bramheap.bram_heap_data_get_bank.index
    // [171] callexecute bram_heap_data_get_bank  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_bank
    // [172] fe_sprite_bram_load::bank_push_set_bram3_bank#0 = bram_heap_data_get_bank::return -- vbuz1=vbuz2 
    lda.z lib_bramheap.bram_heap_data_get_bank.return
    sta.z bank_push_set_bram3_bank
    // bram_ptr_t sprite_ptr = bram_heap_data_get_offset(0, handle_bram)
    // [173] bram_heap_data_get_offset::s = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_bramheap.bram_heap_data_get_offset.s
    // [174] bram_heap_data_get_offset::index = fe_sprite_bram_load::handle_bram#0 -- vbuz1=vbuz2 
    lda.z handle_bram
    sta.z lib_bramheap.bram_heap_data_get_offset.index
    // [175] callexecute bram_heap_data_get_offset  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_offset
    // [176] fe_sprite_bram_load::sprite_ptr#0 = bram_heap_data_get_offset::return -- pbuz1=pbuz2 
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
    // [178] BRAM = fe_sprite_bram_load::bank_push_set_bram3_bank#0 -- vbuz1=vbuz2 
    lda.z bank_push_set_bram3_bank
    sta.z BRAM
    // fe_sprite_bram_load::@14
    // unsigned int read = fgets(sprite_ptr, sprite_size, fp)
    // [179] fgets::ptr#4 = fe_sprite_bram_load::sprite_ptr#0 -- pbuz1=pbuz2 
    lda.z sprite_ptr
    sta.z fgets.ptr
    lda.z sprite_ptr+1
    sta.z fgets.ptr+1
    // [180] fgets::size#2 = fe_sprite_bram_load::sprite_size#0 -- vwuz1=vwuz2 
    lda.z sprite_size
    sta.z fgets.size
    lda.z sprite_size+1
    sta.z fgets.size+1
    // [181] fgets::stream#2 = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fgets.stream
    lda.z fp+1
    sta.z fgets.stream+1
    // [182] call fgets
    // [503] phi from fe_sprite_bram_load::@14 to fgets [phi:fe_sprite_bram_load::@14->fgets]
    // [503] phi fgets::ptr#13 = fgets::ptr#4 [phi:fe_sprite_bram_load::@14->fgets#0] -- register_copy 
    // [503] phi fgets::size#11 = fgets::size#2 [phi:fe_sprite_bram_load::@14->fgets#1] -- register_copy 
    // [503] phi fgets::stream#3 = fgets::stream#2 [phi:fe_sprite_bram_load::@14->fgets#2] -- register_copy 
    jsr fgets
    // unsigned int read = fgets(sprite_ptr, sprite_size, fp)
    // [183] fgets::return#11 = fgets::return#1
    // fe_sprite_bram_load::@21
    // [184] fe_sprite_bram_load::read1#0 = fgets::return#11 -- vwuz1=vwuz2 
    lda.z fgets.return
    sta.z read1
    lda.z fgets.return+1
    sta.z read1+1
    // fe_sprite_bram_load::bank_pull_bram3
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_bram_load::@15
    // if (!read)
    // [186] if(0==fe_sprite_bram_load::read1#0) goto fe_sprite_bram_load::@7 -- 0_eq_vwuz1_then_la1 
    lda.z read1
    ora.z read1+1
    beq __b7
    // fe_sprite_bram_load::@8
    // sprite_bram_handles[sprite_offset] = handle_bram
    // [187] fe_sprite_bram_load::$34 = sprite_bram_handles + fe_sprite_bram_load::sprite_offset -- pbuz1=pbuc1_plus_vwuz2 
    lda.z sprite_offset
    clc
    adc #<sprite_bram_handles
    sta.z fe_sprite_bram_load__34
    lda.z sprite_offset+1
    adc #>sprite_bram_handles
    sta.z fe_sprite_bram_load__34+1
    // [188] *fe_sprite_bram_load::$34 = fe_sprite_bram_load::handle_bram#0 -- _deref_pbuz1=vbuz2 
    lda.z handle_bram
    ldy #0
    sta (fe_sprite_bram_load__34),y
    // sprite_offset++;
    // [189] fe_sprite_bram_load::sprite_offset = ++ fe_sprite_bram_load::sprite_offset -- vwuz1=_inc_vwuz1 
    inc.z sprite_offset
    bne !+
    inc.z sprite_offset+1
  !:
    // fe_sprite_bram_load::@7
  __b7:
    // for (unsigned char s = 0; s < sprites.count[sprite_index]; s++)
    // [190] fe_sprite_bram_load::s#1 = ++ fe_sprite_bram_load::s#10 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [154] phi from fe_sprite_bram_load::@7 to fe_sprite_bram_load::@4 [phi:fe_sprite_bram_load::@7->fe_sprite_bram_load::@4]
    // [154] phi fe_sprite_bram_load::s#10 = fe_sprite_bram_load::s#1 [phi:fe_sprite_bram_load::@7->fe_sprite_bram_load::@4#0] -- register_copy 
    jmp __b4
  .segment DataEngineFlight
    filename: .fill $10, 0
  .encoding "petscii_mixed"
    source: .text ".bin"
    .byte 0
}
.segment CodeEngineFlight
  // sprite_image_cache_vram
// __zp($ad) unsigned int sprite_image_cache_vram(__zp($d7) char sprite_cache_index, __zp($b4) char fe_sprite_image_index)
sprite_image_cache_vram: {
    .const bank_push_set_bram1_bank = 4
    .label sprite_cache_index = $d7
    .label fe_sprite_image_index = $b4
    .label return = $ad
    .label sprite_image_cache_vram__30 = $ad
    .label vera_sprite_get_image_offset1_sprite_image_cache_vram__1 = $6c
    .label vera_sprite_get_image_offset1_sprite_image_cache_vram__2 = $6c
    .label image_index = $cb
    .label vram_handle2 = $c3
    // lru_cache_data_t lru_cache_data;
    .label sprite_offset = $ad
    .label vram_size_required = $b1
    .label vram_has_free = $a2
    .label vram_last = $a0
    .label vram_handle = $a5
    .label vram_handle1 = $c4
    .label vram_bank = $c1
    .label vram_offset = $a5
    .label handle_bram = $b4
    .label sprite_bank = $c2
    .label sprite_ptr = $b1
    .label sprite_size = $ad
    .label vera_sprite_get_image_offset1_sprite_image_offset = $7b
    .label vera_sprite_get_image_offset1_return = $ad
    .label sprite_image_cache_vram__40 = $ad
    // unsigned int image_index = sprite_cache.offset[sprite_cache_index] + fe_sprite_image_index
    // [191] sprite_image_cache_vram::$36 = sprite_image_cache_vram::sprite_cache_index << 1 -- vbuaa=vbuz1_rol_1 
    lda.z sprite_cache_index
    asl
    // [192] sprite_image_cache_vram::image_index#0 = ((unsigned int *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET)[sprite_image_cache_vram::$36] + sprite_image_cache_vram::fe_sprite_image_index -- vwuz1=pwuc1_derefidx_vbuaa_plus_vbuz2 
    // check if the image in vram is in use where the fe_sprite_vram_image_index is pointing to.
    // if this vram_image_used is false, that means that the image in vram is not in use anymore (not displayed or destroyed).
    tay
    lda.z fe_sprite_image_index
    clc
    adc equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET,y
    sta.z image_index
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET+1,y
    adc #0
    sta.z image_index+1
    // lru_cache_index_t vram_index = lru_cache_index(image_index)
    // [193] lru_cache_index::key = sprite_image_cache_vram::image_index#0 -- vwuz1=vwuz2 
    // We check if there is a cache hit?
    lda.z image_index
    sta.z lib_lru_cache.lru_cache_index.key
    lda.z image_index+1
    sta.z lib_lru_cache.lru_cache_index.key+1
    // [194] callexecute lru_cache_index  -- call_var_near 
    jsr lib_lru_cache.lru_cache_index
    // [195] sprite_image_cache_vram::vram_index#0 = lru_cache_index::return -- vbuaa=vbuz1 
    lda.z lib_lru_cache.lru_cache_index.return
    // if (vram_index != 0xFF)
    // [196] if(sprite_image_cache_vram::vram_index#0!=$ff) goto sprite_image_cache_vram::@1 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$ff
    beq !__b1+
    jmp __b1
  !__b1:
    // sprite_image_cache_vram::vera_display_set_border_color1
    // *VERA_CTRL &= 0b10000001
    // [197] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [198] *VERA_DC_BORDER = RED -- _deref_pbuc1=vbuc2 
    lda #RED
    sta VERA_DC_BORDER
    // sprite_image_cache_vram::@8
    // vera_heap_size_int_t vram_size_required = sprite_cache.size[sprite_cache_index]
    // [199] sprite_image_cache_vram::$37 = sprite_image_cache_vram::sprite_cache_index << 1 -- vbuaa=vbuz1_rol_1 
    lda.z sprite_cache_index
    asl
    // [200] sprite_image_cache_vram::vram_size_required#0 = ((unsigned int *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE)[sprite_image_cache_vram::$37] -- vwuz1=pwuc1_derefidx_vbuaa 
    // The idea of this section is to free up lru_cache and/or vram memory until there is sufficient space available.
    // The size requested contains the required size to be allocated on vram.
    tay
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE,y
    sta.z vram_size_required
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE+1,y
    sta.z vram_size_required+1
    // bool vram_has_free = vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required)
    // [201] vera_heap_has_free::s = 1 -- vbuz1=vbuc1 
    // We check if the vram heap has sufficient memory available for the size requested.
    // We also check if the lru cache has sufficient elements left to contain the new sprite image.
    lda #1
    sta.z lib_veraheap.vera_heap_has_free.s
    // [202] vera_heap_has_free::size_requested = sprite_image_cache_vram::vram_size_required#0 -- vwuz1=vwuz2 
    lda.z vram_size_required
    sta.z lib_veraheap.vera_heap_has_free.size_requested
    lda.z vram_size_required+1
    sta.z lib_veraheap.vera_heap_has_free.size_requested+1
    // [203] callexecute vera_heap_has_free  -- call_var_near 
    jsr lib_veraheap.vera_heap_has_free
    // [204] sprite_image_cache_vram::vram_has_free#0 = vera_heap_has_free::return -- vboz1=vboz2 
    lda.z lib_veraheap.vera_heap_has_free.return
    sta.z vram_has_free
    // bool lru_cache_max = lru_cache_is_max()
    // [205] callexecute lru_cache_is_max  -- call_var_near 
    jsr lib_lru_cache.lru_cache_is_max
    // [206] sprite_image_cache_vram::lru_cache_max#0 = lru_cache_is_max::return -- vboaa=vboz1 
    lda.z lib_lru_cache.lru_cache_is_max.return
    // [207] phi from sprite_image_cache_vram::@6 sprite_image_cache_vram::@8 to sprite_image_cache_vram::@3 [phi:sprite_image_cache_vram::@6/sprite_image_cache_vram::@8->sprite_image_cache_vram::@3]
  __b3:
    // [207] phi sprite_image_cache_vram::lru_cache_max#2 = sprite_image_cache_vram::lru_cache_max#1 [phi:sprite_image_cache_vram::@6/sprite_image_cache_vram::@8->sprite_image_cache_vram::@3#0] -- register_copy 
    // [207] phi sprite_image_cache_vram::vram_has_free#2 = sprite_image_cache_vram::vram_has_free#1 [phi:sprite_image_cache_vram::@6/sprite_image_cache_vram::@8->sprite_image_cache_vram::@3#1] -- register_copy 
  // Free up the lru_cache and vram memory until the requested size is available!
  // This ensures that vram has sufficient place to allocate the new sprite image.
    // sprite_image_cache_vram::@3
    // while (lru_cache_max || !vram_has_free)
    // [208] if(sprite_image_cache_vram::lru_cache_max#2) goto sprite_image_cache_vram::@4 -- vboaa_then_la1 
    cmp #0
    bne __b4
    // sprite_image_cache_vram::@12
    // [209] if(sprite_image_cache_vram::vram_has_free#2) goto sprite_image_cache_vram::@5 -- vboz1_then_la1 
    lda.z vram_has_free
    cmp #0
    bne __b5
    // [210] phi from sprite_image_cache_vram::@12 sprite_image_cache_vram::@3 to sprite_image_cache_vram::@4 [phi:sprite_image_cache_vram::@12/sprite_image_cache_vram::@3->sprite_image_cache_vram::@4]
    // sprite_image_cache_vram::@4
  __b4:
    // lru_cache_key_t vram_last = lru_cache_find_last()
    // [211] callexecute lru_cache_find_last  -- call_var_near 
    jsr lib_lru_cache.lru_cache_find_last
    // [212] sprite_image_cache_vram::vram_last#0 = lru_cache_find_last::return -- vwuz1=vwuz2 
    lda.z lib_lru_cache.lru_cache_find_last.return
    sta.z vram_last
    lda.z lib_lru_cache.lru_cache_find_last.return+1
    sta.z vram_last+1
    // lru_cache_data_t vram_handle = lru_cache_delete(vram_last)
    // [213] lru_cache_delete::key = sprite_image_cache_vram::vram_last#0 -- vwuz1=vwuz2 
    // We delete the least used image from the vram cache, and this function returns the stored vram handle obtained by the vram heap manager.
    lda.z vram_last
    sta.z lib_lru_cache.lru_cache_delete.key
    lda.z vram_last+1
    sta.z lib_lru_cache.lru_cache_delete.key+1
    // [214] callexecute lru_cache_delete  -- call_var_near 
    jsr lib_lru_cache.lru_cache_delete
    // [215] sprite_image_cache_vram::vram_handle#0 = lru_cache_delete::return -- vwuz1=vwuz2 
    lda.z lib_lru_cache.lru_cache_delete.return
    sta.z vram_handle
    lda.z lib_lru_cache.lru_cache_delete.return+1
    sta.z vram_handle+1
    // if (vram_handle == 0xFFFF)
    // [216] if(sprite_image_cache_vram::vram_handle#0!=$ffff) goto sprite_image_cache_vram::@6 -- vwuz1_neq_vwuc1_then_la1 
    cmp #>$ffff
    bne __b6
    lda.z vram_handle
    cmp #<$ffff
    // [217] phi from sprite_image_cache_vram::@4 to sprite_image_cache_vram::@7 [phi:sprite_image_cache_vram::@4->sprite_image_cache_vram::@7]
    // sprite_image_cache_vram::@7
    // sprite_image_cache_vram::@6
  __b6:
    // BYTE0(vram_handle)
    // [218] sprite_image_cache_vram::$12 = byte0  sprite_image_cache_vram::vram_handle#0 -- vbuxx=_byte0_vwuz1 
    ldx.z vram_handle
    // vera_heap_free(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [219] vera_heap_free::s = 1 -- vbuz1=vbuc1 
    // And we free the vram heap with the vram handle that we received.
    // But before we can free the heap, we must first convert back from the sprite offset to the vram address.
    // And then to a valid vram handle :-).
    lda #1
    sta.z lib_veraheap.vera_heap_free.s
    // [220] vera_heap_free::free_index = sprite_image_cache_vram::$12 -- vbuz1=vbuxx 
    stx.z lib_veraheap.vera_heap_free.free_index
    // [221] callexecute vera_heap_free  -- call_var_near 
    jsr lib_veraheap.vera_heap_free
    // vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required)
    // [222] vera_heap_has_free::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_has_free.s
    // [223] vera_heap_has_free::size_requested = sprite_image_cache_vram::vram_size_required#0 -- vwuz1=vwuz2 
    lda.z vram_size_required
    sta.z lib_veraheap.vera_heap_has_free.size_requested
    lda.z vram_size_required+1
    sta.z lib_veraheap.vera_heap_has_free.size_requested+1
    // [224] callexecute vera_heap_has_free  -- call_var_near 
    jsr lib_veraheap.vera_heap_has_free
    // vram_has_free = vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required)
    // [225] sprite_image_cache_vram::vram_has_free#1 = vera_heap_has_free::return -- vboz1=vboz2 
    lda.z lib_veraheap.vera_heap_has_free.return
    sta.z vram_has_free
    // lru_cache_is_max()
    // [226] callexecute lru_cache_is_max  -- call_var_near 
    jsr lib_lru_cache.lru_cache_is_max
    // lru_cache_max = lru_cache_is_max()
    // [227] sprite_image_cache_vram::lru_cache_max#1 = lru_cache_is_max::return -- vboaa=vboz1 
    lda.z lib_lru_cache.lru_cache_is_max.return
    jmp __b3
    // sprite_image_cache_vram::@5
  __b5:
    // vera_heap_index_t vram_handle = vera_heap_alloc(VERA_HEAP_SEGMENT_SPRITES, (unsigned long)sprite_cache.size[sprite_cache_index])
    // [228] sprite_image_cache_vram::$38 = sprite_image_cache_vram::sprite_cache_index << 1 -- vbuxx=vbuz1_rol_1 
    lda.z sprite_cache_index
    asl
    tax
    // [229] vera_heap_alloc::s = 1 -- vbuz1=vbuc1 
    // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
    // Dynamic allocation of sprites in vera vram.
    lda #1
    sta.z lib_veraheap.vera_heap_alloc.s
    // [230] vera_heap_alloc::size = (unsigned long)((unsigned int *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE)[sprite_image_cache_vram::$38] -- vduz1=_dword_pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE,x
    sta.z lib_veraheap.vera_heap_alloc.size
    inx
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE,x
    sta.z lib_veraheap.vera_heap_alloc.size+1
    lda #0
    sta.z lib_veraheap.vera_heap_alloc.size+2
    sta.z lib_veraheap.vera_heap_alloc.size+3
    // [231] callexecute vera_heap_alloc  -- call_var_near 
    jsr lib_veraheap.vera_heap_alloc
    // [232] sprite_image_cache_vram::vram_handle1#0 = vera_heap_alloc::return -- vbuz1=vbuz2 
    lda.z lib_veraheap.vera_heap_alloc.return
    sta.z vram_handle1
    // BYTE0(vram_handle)
    // [233] sprite_image_cache_vram::$17 = byte0  sprite_image_cache_vram::vram_handle1#0 -- vbuxx=_byte0_vbuz1 
    tax
    // vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [234] vera_heap_data_get_bank::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_data_get_bank.s
    // [235] vera_heap_data_get_bank::index = sprite_image_cache_vram::$17 -- vbuz1=vbuxx 
    stx.z lib_veraheap.vera_heap_data_get_bank.index
    // [236] callexecute vera_heap_data_get_bank  -- call_var_near 
    jsr lib_veraheap.vera_heap_data_get_bank
    // [237] sprite_image_cache_vram::vram_bank#0 = vera_heap_data_get_bank::return -- vbuz1=vbuz2 
    lda.z lib_veraheap.vera_heap_data_get_bank.return
    sta.z vram_bank
    // BYTE0(vram_handle)
    // [238] sprite_image_cache_vram::$19 = byte0  sprite_image_cache_vram::vram_handle1#0 -- vbuxx=_byte0_vbuz1 
    lda.z vram_handle1
    tax
    // vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [239] vera_heap_data_get_offset::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_data_get_offset.s
    // [240] vera_heap_data_get_offset::index = sprite_image_cache_vram::$19 -- vbuz1=vbuxx 
    stx.z lib_veraheap.vera_heap_data_get_offset.index
    // [241] callexecute vera_heap_data_get_offset  -- call_var_near 
    jsr lib_veraheap.vera_heap_data_get_offset
    // [242] sprite_image_cache_vram::vram_offset#0 = vera_heap_data_get_offset::return -- vwuz1=vwuz2 
    lda.z lib_veraheap.vera_heap_data_get_offset.return
    sta.z vram_offset
    lda.z lib_veraheap.vera_heap_data_get_offset.return+1
    sta.z vram_offset+1
    // sprite_image_cache_vram::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [244] BRAM = sprite_image_cache_vram::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // sprite_image_cache_vram::@9
    // sprite_bram_handles_t handle_bram = sprite_bram_handles[image_index]
    // [245] sprite_image_cache_vram::$40 = sprite_bram_handles + sprite_image_cache_vram::image_index#0 -- pbuz1=pbuc1_plus_vwuz2 
    lda.z image_index
    clc
    adc #<sprite_bram_handles
    sta.z sprite_image_cache_vram__40
    lda.z image_index+1
    adc #>sprite_bram_handles
    sta.z sprite_image_cache_vram__40+1
    // [246] sprite_image_cache_vram::handle_bram#0 = *sprite_image_cache_vram::$40 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (sprite_image_cache_vram__40),y
    sta.z handle_bram
    // sprite_image_cache_vram::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // sprite_image_cache_vram::@10
    // bram_bank_t sprite_bank = bram_heap_data_get_bank(0, handle_bram)
    // [248] bram_heap_data_get_bank::s = 0 -- vbuz1=vbuc1 
    tya
    sta.z lib_bramheap.bram_heap_data_get_bank.s
    // [249] bram_heap_data_get_bank::index = sprite_image_cache_vram::handle_bram#0 -- vbuz1=vbuz2 
    lda.z handle_bram
    sta.z lib_bramheap.bram_heap_data_get_bank.index
    // [250] callexecute bram_heap_data_get_bank  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_bank
    // [251] sprite_image_cache_vram::sprite_bank#0 = bram_heap_data_get_bank::return -- vbuz1=vbuz2 
    lda.z lib_bramheap.bram_heap_data_get_bank.return
    sta.z sprite_bank
    // bram_ptr_t sprite_ptr = bram_heap_data_get_offset(0, handle_bram)
    // [252] bram_heap_data_get_offset::s = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_bramheap.bram_heap_data_get_offset.s
    // [253] bram_heap_data_get_offset::index = sprite_image_cache_vram::handle_bram#0 -- vbuz1=vbuz2 
    lda.z handle_bram
    sta.z lib_bramheap.bram_heap_data_get_offset.index
    // [254] callexecute bram_heap_data_get_offset  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_offset
    // [255] sprite_image_cache_vram::sprite_ptr#0 = bram_heap_data_get_offset::return -- pbuz1=pbuz2 
    lda.z lib_bramheap.bram_heap_data_get_offset.return
    sta.z sprite_ptr
    lda.z lib_bramheap.bram_heap_data_get_offset.return+1
    sta.z sprite_ptr+1
    // unsigned int sprite_size = sprite_cache.size[sprite_cache_index]
    // [256] sprite_image_cache_vram::$39 = sprite_image_cache_vram::sprite_cache_index << 1 -- vbuaa=vbuz1_rol_1 
    lda.z sprite_cache_index
    asl
    // [257] sprite_image_cache_vram::sprite_size#0 = ((unsigned int *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE)[sprite_image_cache_vram::$39] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE,y
    sta.z sprite_size
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE+1,y
    sta.z sprite_size+1
    // memcpy_vram_bram(vram_bank, vram_offset, sprite_bank, sprite_ptr, sprite_size)
    // [258] memcpy_vram_bram::dbank_vram#0 = sprite_image_cache_vram::vram_bank#0 -- vbuxx=vbuz1 
    ldx.z vram_bank
    // [259] memcpy_vram_bram::doffset_vram#0 = sprite_image_cache_vram::vram_offset#0 -- vwuz1=vwuz2 
    lda.z vram_offset
    sta.z memcpy_vram_bram.doffset_vram
    lda.z vram_offset+1
    sta.z memcpy_vram_bram.doffset_vram+1
    // [260] memcpy_vram_bram::sbank_bram#2 = sprite_image_cache_vram::sprite_bank#0 -- vbuz1=vbuz2 
    lda.z sprite_bank
    sta.z memcpy_vram_bram.sbank_bram
    // [261] memcpy_vram_bram::sptr_bram#0 = sprite_image_cache_vram::sprite_ptr#0 -- pbuz1=pbuz2 
    lda.z sprite_ptr
    sta.z memcpy_vram_bram.sptr_bram
    lda.z sprite_ptr+1
    sta.z memcpy_vram_bram.sptr_bram+1
    // [262] memcpy_vram_bram::num = sprite_image_cache_vram::sprite_size#0 -- vwuz1=vwuz2 
    lda.z sprite_size
    sta.z memcpy_vram_bram.num
    lda.z sprite_size+1
    sta.z memcpy_vram_bram.num+1
    // [263] call memcpy_vram_bram
    // [640] phi from sprite_image_cache_vram::@10 to memcpy_vram_bram [phi:sprite_image_cache_vram::@10->memcpy_vram_bram]
    jsr memcpy_vram_bram
    // sprite_image_cache_vram::vera_sprite_get_image_offset1
    // vera_sprite_image_offset sprite_image_offset = offset >> 5
    // [264] sprite_image_cache_vram::vera_sprite_get_image_offset1_sprite_image_offset#0 = sprite_image_cache_vram::vram_offset#0 >> 5 -- vwuz1=vwuz2_ror_5 
    lda.z vram_offset+1
    lsr
    sta.z vera_sprite_get_image_offset1_sprite_image_offset+1
    lda.z vram_offset
    ror
    sta.z vera_sprite_get_image_offset1_sprite_image_offset
    lsr.z vera_sprite_get_image_offset1_sprite_image_offset+1
    ror.z vera_sprite_get_image_offset1_sprite_image_offset
    lsr.z vera_sprite_get_image_offset1_sprite_image_offset+1
    ror.z vera_sprite_get_image_offset1_sprite_image_offset
    lsr.z vera_sprite_get_image_offset1_sprite_image_offset+1
    ror.z vera_sprite_get_image_offset1_sprite_image_offset
    lsr.z vera_sprite_get_image_offset1_sprite_image_offset+1
    ror.z vera_sprite_get_image_offset1_sprite_image_offset
    // (unsigned int)bank << 11
    // [265] sprite_image_cache_vram::vera_sprite_get_image_offset1_$2 = (unsigned int)sprite_image_cache_vram::vram_bank#0 -- vwuz1=_word_vbuz2 
    lda.z vram_bank
    sta.z vera_sprite_get_image_offset1_sprite_image_cache_vram__2
    lda #0
    sta.z vera_sprite_get_image_offset1_sprite_image_cache_vram__2+1
    // [266] sprite_image_cache_vram::vera_sprite_get_image_offset1_$1 = sprite_image_cache_vram::vera_sprite_get_image_offset1_$2 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z vera_sprite_get_image_offset1_sprite_image_cache_vram__1
    rol.z vera_sprite_get_image_offset1_sprite_image_cache_vram__1+1
    dey
    bne !-
  !e:
    // sprite_image_offset |= ((unsigned int)bank << 11)
    // [267] sprite_image_cache_vram::vera_sprite_get_image_offset1_return#0 = sprite_image_cache_vram::vera_sprite_get_image_offset1_sprite_image_offset#0 | sprite_image_cache_vram::vera_sprite_get_image_offset1_$1 -- vwuz1=vwuz2_bor_vwuz3 
    lda.z vera_sprite_get_image_offset1_sprite_image_offset
    ora.z vera_sprite_get_image_offset1_sprite_image_cache_vram__1
    sta.z vera_sprite_get_image_offset1_return
    lda.z vera_sprite_get_image_offset1_sprite_image_offset+1
    ora.z vera_sprite_get_image_offset1_sprite_image_cache_vram__1+1
    sta.z vera_sprite_get_image_offset1_return+1
    // sprite_image_cache_vram::@11
    // vera_heap_set_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle, sprite_offset)
    // [268] vera_heap_set_image::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_set_image.s
    // [269] vera_heap_set_image::index = sprite_image_cache_vram::vram_handle1#0 -- vbuz1=vbuz2 
    lda.z vram_handle1
    sta.z lib_veraheap.vera_heap_set_image.index
    // [270] vera_heap_set_image::image = sprite_image_cache_vram::vera_sprite_get_image_offset1_return#0 -- vwuz1=vwuz2 
    lda.z vera_sprite_get_image_offset1_return
    sta.z lib_veraheap.vera_heap_set_image.image
    lda.z vera_sprite_get_image_offset1_return+1
    sta.z lib_veraheap.vera_heap_set_image.image+1
    // [271] callexecute vera_heap_set_image  -- call_var_near 
    jsr lib_veraheap.vera_heap_set_image
    // lru_cache_insert(image_index, (lru_cache_data_t)vram_handle)
    // [272] lru_cache_insert::key = sprite_image_cache_vram::image_index#0 -- vwuz1=vwuz2 
    lda.z image_index
    sta.z lib_lru_cache.lru_cache_insert.key
    lda.z image_index+1
    sta.z lib_lru_cache.lru_cache_insert.key+1
    // [273] lru_cache_insert::data = (unsigned int)sprite_image_cache_vram::vram_handle1#0 -- vwuz1=_word_vbuz2 
    lda.z vram_handle1
    sta.z lib_lru_cache.lru_cache_insert.data
    lda #0
    sta.z lib_lru_cache.lru_cache_insert.data+1
    // [274] callexecute lru_cache_insert  -- call_var_near 
    jsr lib_lru_cache.lru_cache_insert
    // sprite_image_cache_vram::vera_display_set_border_color2
    // *VERA_CTRL &= 0b10000001
    // [275] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [276] *VERA_DC_BORDER = BLACK -- _deref_pbuc1=vbuc2 
    lda #BLACK
    sta VERA_DC_BORDER
    // [277] phi from sprite_image_cache_vram::@1 sprite_image_cache_vram::vera_display_set_border_color2 to sprite_image_cache_vram::@2 [phi:sprite_image_cache_vram::@1/sprite_image_cache_vram::vera_display_set_border_color2->sprite_image_cache_vram::@2]
    // [277] phi sprite_image_cache_vram::sprite_offset#3 = sprite_image_cache_vram::sprite_offset#1 [phi:sprite_image_cache_vram::@1/sprite_image_cache_vram::vera_display_set_border_color2->sprite_image_cache_vram::@2#0] -- register_copy 
    // sprite_image_cache_vram::@2
    // return sprite_offset;
    // [278] sprite_image_cache_vram::return = sprite_image_cache_vram::sprite_offset#3
  // We return the image offset in vram of the sprite to be drawn.
  // This offset is used by the vera image set offset function to directly change the image displayed of the sprite!
    // sprite_image_cache_vram::@return
    // }
    // [279] return 
    rts
    // sprite_image_cache_vram::@1
  __b1:
    // lru_cache_get(vram_index)
    // [280] lru_cache_get::index = sprite_image_cache_vram::vram_index#0 -- vbuz1=vbuaa 
    sta.z lib_lru_cache.lru_cache_get.index
    // [281] callexecute lru_cache_get  -- call_var_near 
    jsr lib_lru_cache.lru_cache_get
    // [282] sprite_image_cache_vram::$30 = lru_cache_get::return -- vwuz1=vwuz2 
    lda.z lib_lru_cache.lru_cache_get.return
    sta.z sprite_image_cache_vram__30
    lda.z lib_lru_cache.lru_cache_get.return+1
    sta.z sprite_image_cache_vram__30+1
    // vera_heap_index_t vram_handle = (vera_heap_index_t)lru_cache_get(vram_index)
    // [283] sprite_image_cache_vram::vram_handle2#0 = (char)sprite_image_cache_vram::$30 -- vbuz1=_byte_vwuz2 
    // So we have a cache hit, so we can re-use the same image from the cache and we win time!
    lda.z sprite_image_cache_vram__30
    sta.z vram_handle2
    // BYTE0(vram_handle)
    // [284] sprite_image_cache_vram::$31 = byte0  sprite_image_cache_vram::vram_handle2#0 -- vbuxx=_byte0_vbuz1 
    tax
    // vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [285] vera_heap_data_get_bank::s = 1 -- vbuz1=vbuc1 
    // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
    // Dynamic allocation of sprites in vera vram.
    lda #1
    sta.z lib_veraheap.vera_heap_data_get_bank.s
    // [286] vera_heap_data_get_bank::index = sprite_image_cache_vram::$31 -- vbuz1=vbuxx 
    stx.z lib_veraheap.vera_heap_data_get_bank.index
    // [287] callexecute vera_heap_data_get_bank  -- call_var_near 
    jsr lib_veraheap.vera_heap_data_get_bank
    // BYTE0(vram_handle)
    // [288] sprite_image_cache_vram::$33 = byte0  sprite_image_cache_vram::vram_handle2#0 -- vbuxx=_byte0_vbuz1 
    lda.z vram_handle2
    tax
    // vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [289] vera_heap_data_get_offset::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_data_get_offset.s
    // [290] vera_heap_data_get_offset::index = sprite_image_cache_vram::$33 -- vbuz1=vbuxx 
    stx.z lib_veraheap.vera_heap_data_get_offset.index
    // [291] callexecute vera_heap_data_get_offset  -- call_var_near 
    jsr lib_veraheap.vera_heap_data_get_offset
    // vera_heap_get_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle)
    // [292] vera_heap_get_image::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_get_image.s
    // [293] vera_heap_get_image::index = sprite_image_cache_vram::vram_handle2#0 -- vbuz1=vbuz2 
    lda.z vram_handle2
    sta.z lib_veraheap.vera_heap_get_image.index
    // [294] callexecute vera_heap_get_image  -- call_var_near 
    jsr lib_veraheap.vera_heap_get_image
    // sprite_offset = vera_heap_get_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle)
    // [295] sprite_image_cache_vram::sprite_offset#1 = vera_heap_get_image::return -- vwuz1=vwuz2 
    lda.z lib_veraheap.vera_heap_get_image.return
    sta.z sprite_offset
    lda.z lib_veraheap.vera_heap_get_image.return+1
    sta.z sprite_offset+1
    rts
}
  // flight_has_collided
// This will need rework
// __zp($c4) char flight_has_collided(__zp($da) char f)
flight_has_collided: {
    .label f = $da
    .label return = $c4
    // unsigned char collided = flight.collided[f]
    // [296] flight_has_collided::collided#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED)[flight_has_collided::f] -- vbuxx=pbuc1_derefidx_vbuz1 
    ldy.z f
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED,y
    // flight.collided[f] = 1
    // [297] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED)[flight_has_collided::f] = 1 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED,y
    // return collided;
    // [298] flight_has_collided::return = flight_has_collided::collided#0 -- vbuz1=vbuxx 
    stx.z return
    // flight_has_collided::@return
    // }
    // [299] return 
    rts
}
  // flight_hit
// __zp($c1) signed char flight_hit(__zp($c2) char f, __zp($da) signed char impact)
flight_hit: {
    .label f = $c2
    .label impact = $da
    .label return = $c1
    // flight.health[f] += impact
    // [300] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[flight_hit::f] = ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[flight_hit::f] + flight_hit::impact -- pbsc1_derefidx_vbuz1=pbsc1_derefidx_vbuz1_plus_vbsz2 
    lda.z impact
    ldy.z f
    clc
    adc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    // if(flight.health[f] <= 0)
    // [301] if(((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[flight_hit::f]>0) goto flight_hit::@1 -- pbsc1_derefidx_vbuz1_gt_0_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    cmp #0
    beq !+
    bpl __b1
  !:
    // flight_hit::@2
    // flight.collided[f] = 1
    // [302] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED)[flight_hit::f] = 1 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #1
    ldy.z f
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED,y
    // return 1;
    // [303] flight_hit::return = 1 -- vbsz1=vbsc1 
    sta.z return
    // flight_hit::@return
    // }
    // [304] return 
    rts
    // flight_hit::@1
  __b1:
    // return 0;
    // [305] flight_hit::return = 0 -- vbsz1=vbsc1 
    lda #0
    sta.z return
    rts
}
  // flight_impact
// __zp($b4) signed char flight_impact(__zp($c2) char f)
flight_impact: {
    .label f = $c2
    .label return = $b4
    // signed char impact = flight.impact[f]
    // [306] flight_impact::impact#0 = ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_IMPACT)[flight_impact::f] -- vbsaa=pbsc1_derefidx_vbuz1 
    ldy.z f
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_IMPACT,y
    // return impact;
    // [307] flight_impact::return = flight_impact::impact#0 -- vbsz1=vbsaa 
    sta.z return
    // flight_impact::@return
    // }
    // [308] return 
    rts
}
  // flight_next
// __zp($c2) char flight_next(__zp($b4) char i)
flight_next: {
    .label i = $b4
    .label return = $c2
    // return flight.next[i];
    // [309] flight_next::return = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_NEXT)[flight_next::i] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z i
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_NEXT,y
    sta.z return
    // flight_next::@return
    // }
    // [310] return 
    rts
}
  // flight_root
// __zp($bc) char flight_root(__zp($b4) char type)
flight_root: {
    .label type = $b4
    .label return = $bc
    // return flight.root[type];
    // [311] flight_root::return = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ROOT)[flight_root::type] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z type
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT,y
    sta.z return
    // flight_root::@return
    // }
    // [312] return 
    rts
}
  // flight_remove
// void flight_remove(__zp($c4) char type, __zp($c1) char f)
flight_remove: {
    .const vera_sprite_disable1_vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    .label type = $c4
    .label f = $c1
    .label r = $bc
    .label n = $b4
    .label sprite_offset = $ad
    .label vera_sprite_disable1_vera_vram_data0_bank_offset1_offset = $7b
    // if (flight.used[f])
    // [313] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[flight_remove::f]) goto flight_remove::@return -- 0_eq_pbuc1_derefidx_vbuz1_then_la1 
    ldy.z f
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    bne !__breturn+
    jmp __breturn
  !__breturn:
    // flight_remove::@1
    // flight.used[f] = 0
    // [314] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[flight_remove::f] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    // flight.enabled[f] = 0
    // [315] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ENABLED)[flight_remove::f] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ENABLED,y
    // flight.collided[f] = 1
    // [316] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED)[flight_remove::f] = 1 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED,y
    // flight.count[type]--;
    // [317] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COUNT)[flight_remove::type] = -- ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COUNT)[flight_remove::type] -- pbuc1_derefidx_vbuz1=_dec_pbuc1_derefidx_vbuz1 
    ldx.z type
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COUNT,x
    // flight_index_t r = flight.root[type]
    // [318] flight_remove::r#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ROOT)[flight_remove::type] -- vbuz1=pbuc1_derefidx_vbuz2 
    // p.r = 4 => f[4].n = 3, f[3].n = 2, f[2].n = 1, f[1].n = -
    // p.r = 4 => f[4].p = -, f[3].p = 4, f[2].p = 3, f[1].p = 2
    // Remove 4
    // p.r = 3 => f[3].n = 2, f[2].n = 1, f[1].n = -
    //         => f[3].p = -, f[2].p = 3, f[1].p = 2
    ldy.z type
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT,y
    sta.z r
    // if(!flight.next[r])
    // [319] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_NEXT)[flight_remove::r#0]) goto flight_remove::@4 -- 0_eq_pbuc1_derefidx_vbuz1_then_la1 
    tay
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_NEXT,y
    cmp #0
    bne !__b4+
    jmp __b4
  !__b4:
    // flight_remove::@2
    // flight_index_t n = flight.next[f]
    // [320] flight_remove::n#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_NEXT)[flight_remove::f] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z f
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_NEXT,y
    sta.z n
    // flight_index_t p = flight.prev[f]
    // [321] flight_remove::p#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_PREV)[flight_remove::f] -- vbuxx=pbuc1_derefidx_vbuz1 
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_PREV,y
    // if (n)
    // [322] if(0==flight_remove::n#0) goto flight_remove::@5 -- 0_eq_vbuz1_then_la1 
    beq __b5
    // flight_remove::@3
    // flight.prev[n] = p
    // [323] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_PREV)[flight_remove::n#0] = flight_remove::p#0 -- pbuc1_derefidx_vbuz1=vbuxx 
    tay
    txa
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_PREV,y
    // flight_remove::@5
  __b5:
    // if (p)
    // [324] if(0==flight_remove::p#0) goto flight_remove::@6 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq __b6
    // flight_remove::@7
    // flight.next[p] = n
    // [325] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_NEXT)[flight_remove::p#0] = flight_remove::n#0 -- pbuc1_derefidx_vbuxx=vbuz1 
    lda.z n
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_NEXT,x
    // flight_remove::@6
  __b6:
    // if (r == f)
    // [326] if(flight_remove::r#0!=flight_remove::f) goto flight_remove::@9 -- vbuz1_neq_vbuz2_then_la1 
    lda.z r
    cmp.z f
    bne __b9
    // flight_remove::@8
    // flight.root[type] = n
    // [327] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ROOT)[flight_remove::type] = flight_remove::n#0 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z n
    ldy.z type
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT,y
    // flight_remove::@9
  __b9:
    // flight.next[f] = NULL
    // [328] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_NEXT)[flight_remove::f] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z f
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_NEXT,y
    // flight.prev[f] = NULL
    // [329] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_PREV)[flight_remove::f] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_PREV,y
    // vera_sprite_offset sprite_offset = flight.sprite_offset[f]
    // [330] flight_remove::$11 = flight_remove::f << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [331] flight_remove::sprite_offset#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET)[flight_remove::$11] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET,y
    sta.z sprite_offset
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET+1,y
    sta.z sprite_offset+1
    // flight_sprite_free_offset(sprite_offset)
    // [332] flight_sprite_free_offset::sprite_offset#0 = flight_remove::sprite_offset#0 -- vwuz1=vwuz2 
    lda.z sprite_offset
    sta.z flight_sprite_free_offset.sprite_offset
    lda.z sprite_offset+1
    sta.z flight_sprite_free_offset.sprite_offset+1
    // [333] call flight_sprite_free_offset
    // [687] phi from flight_remove::@9 to flight_sprite_free_offset [phi:flight_remove::@9->flight_sprite_free_offset]
    jsr flight_sprite_free_offset
    // flight_remove::vera_sprite_disable1
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0)
    // [334] flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_offset#0 = flight_remove::sprite_offset#0 + 6 -- vwuz1=vwuz2_plus_vbuc1 
    lda #6
    clc
    adc.z sprite_offset
    sta.z vera_sprite_disable1_vera_vram_data0_bank_offset1_offset
    lda #0
    adc.z sprite_offset+1
    sta.z vera_sprite_disable1_vera_vram_data0_bank_offset1_offset+1
    // flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [335] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [336] flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_$0 = byte0  flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwuz1 
    lda.z vera_sprite_disable1_vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [337] *VERA_ADDRX_L = flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [338] flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_$1 = byte1  flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwuz1 
    lda.z vera_sprite_disable1_vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [339] *VERA_ADDRX_M = flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [340] *VERA_ADDRX_H = flight_remove::vera_sprite_disable1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_sprite_disable1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // flight_remove::vera_sprite_disable1_@1
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [341] flight_remove::vera_sprite_disable1_$2 = *VERA_DATA0 & ~$c -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$c^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [342] *VERA_DATA0 = flight_remove::vera_sprite_disable1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // flight_remove::@10
    // palette_unuse_vram(sprite_cache.palette_offset[flight.cache[f]])
    // [343] palette_unuse_vram::bram_index = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET)[((char *)&flight)[flight_remove::f]] -- vwuz1=pbuc1_derefidx_(pbuc2_derefidx_vbuz2) 
    ldx.z f
    ldy equinoxe_flightengine.flight,x
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET,y
    sta.z equinoxe_palette.palette_unuse_vram.bram_index
    lda #0
    sta.z equinoxe_palette.palette_unuse_vram.bram_index+1
    // [344] callexecute palette_unuse_vram  -- call_var_near 
    jsr equinoxe_palette.palette_unuse_vram
    // fe_sprite_cache_free(flight.cache[f])
    // [345] fe_sprite_cache_free::fe_sprite_index#0 = ((char *)&flight)[flight_remove::f] -- vbuxx=pbuc1_derefidx_vbuz1 
    ldy.z f
    ldx equinoxe_flightengine.flight,y
    // [346] call fe_sprite_cache_free
    jsr fe_sprite_cache_free
    // flight_remove::@return
  __breturn:
    // }
    // [347] return 
    rts
    // flight_remove::@4
  __b4:
    // flight.root[type] = NULL
    // [348] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ROOT)[flight_remove::type] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z type
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT,y
    jmp __b9
}
  // flight_add
// __zp($bc) char flight_add(__zp($d7) char type, __zp($c3) char side, __zp($c4) char sprite)
flight_add: {
    .label type = $d7
    .label side = $c3
    .label sprite = $c4
    .label return = $bc
    .label flight_add__4 = $ad
    .label flight_add__12 = $b4
    .label f = $bc
    .label s = $c1
    // unsigned char f = flight.index % FLIGHT_OBJECTS
    // [349] flight_add::f#0 = *((char *)&flight+OFFSET_STRUCT_FLIGHT_T_INDEX) & $40-1 -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #$40-1
    and equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_INDEX
    sta.z f
    // [350] phi from flight_add flight_add::@3 to flight_add::@2 [phi:flight_add/flight_add::@3->flight_add::@2]
    // [350] phi flight_add::f#2 = flight_add::f#0 [phi:flight_add/flight_add::@3->flight_add::@2#0] -- register_copy 
    // flight_add::@2
  __b2:
    // while (!f || flight.used[f])
    // [351] if(0==flight_add::f#2) goto flight_add::@3 -- 0_eq_vbuz1_then_la1 
    lda.z f
    bne !__b3+
    jmp __b3
  !__b3:
    // flight_add::@9
    // [352] if(0!=((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[flight_add::f#2]) goto flight_add::@3 -- 0_neq_pbuc1_derefidx_vbuz1_then_la1 
    tay
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    beq !__b3+
    jmp __b3
  !__b3:
    // flight_add::@4
    // flight.index = f
    // [353] *((char *)&flight+OFFSET_STRUCT_FLIGHT_T_INDEX) = flight_add::f#2 -- _deref_pbuc1=vbuz1 
    tya
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_INDEX
    // flight_index_t r = flight.root[type]
    // [354] flight_add::r#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ROOT)[flight_add::type] -- vbuxx=pbuc1_derefidx_vbuz1 
    // p.r = 3 => f[3].n = 2, f[2].n = 1, f[1].n = -
    //         => f[3].p = -, f[2].p = 3, f[1].p = 2
    // Add 4
    // p.r = 4 => f[4].n = 3, f[3].n = 2, f[2].n = 1, f[1].n = -
    // p.r = 4 => f[4].p = -, f[3].p = 4, f[2].p = 3, f[1].p = 2
    ldy.z type
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT,y
    // flight.next[f] = r
    // [355] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_NEXT)[flight_add::f#2] = flight_add::r#0 -- pbuc1_derefidx_vbuz1=vbuxx 
    ldy.z f
    txa
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_NEXT,y
    // flight.prev[f] = NULL
    // [356] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_PREV)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_PREV,y
    // if (r)
    // [357] if(0==flight_add::r#0) goto flight_add::@1 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq __b1
    // flight_add::@5
    // flight.prev[r] = f
    // [358] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_PREV)[flight_add::r#0] = flight_add::f#2 -- pbuc1_derefidx_vbuxx=vbuz1 
    tya
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_PREV,x
    // flight_add::@1
  __b1:
    // flight.root[type] = f
    // [359] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ROOT)[flight_add::type] = flight_add::f#2 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z f
    ldy.z type
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ROOT,y
    // flight.count[type]++;
    // [360] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COUNT)[flight_add::type] = ++ ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COUNT)[flight_add::type] -- pbuc1_derefidx_vbuz1=_inc_pbuc1_derefidx_vbuz1 
    ldx.z type
    inc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COUNT,x
    // flight.type[f] = type
    // [361] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[flight_add::f#2] = flight_add::type -- pbuc1_derefidx_vbuz1=vbuz2 
    txa
    ldy.z f
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    // flight.side[f] = side
    // [362] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SIDE)[flight_add::f#2] = flight_add::side -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z side
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SIDE,y
    // flight.used[f] = 1
    // [363] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[flight_add::f#2] = 1 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    // flight.enabled[f] = 0
    // [364] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ENABLED)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ENABLED,y
    // flight.move[f] = 0
    // [365] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    // flight.moved[f] = 0
    // [366] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVED)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVED,y
    // flight.moving[f] = 0
    // [367] flight_add::$12 = flight_add::f#2 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z flight_add__12
    // [368] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVING)[flight_add::$12] = 0 -- pwuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z flight_add__12
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING+1,y
    // flight.angle[f] = 0
    // [369] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    ldy.z f
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // flight.speed[f] = 0
    // [370] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    // flight.action[f] = 0
    // [371] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ACTION)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ACTION,y
    // flight.turn[f] = 0
    // [372] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TURN)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TURN,y
    // flight.radius[f] = 0
    // [373] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RADIUS)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RADIUS,y
    // flight.reload[f] = 0
    // [374] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    // flight.delay[f] = 0
    // [375] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_DELAY)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_DELAY,y
    // unsigned char s = fe_sprite_cache_copy(sprite)
    // [376] fe_sprite_cache_copy::sprite_index#0 = flight_add::sprite
    // [377] call fe_sprite_cache_copy
    // [696] phi from flight_add::@1 to fe_sprite_cache_copy [phi:flight_add::@1->fe_sprite_cache_copy]
    jsr fe_sprite_cache_copy
    // unsigned char s = fe_sprite_cache_copy(sprite)
    // [378] fe_sprite_cache_copy::return#0 = fe_sprite_cache_copy::c#2 -- vbuaa=vbuz1 
    lda.z fe_sprite_cache_copy.c
    // flight_add::@6
    // [379] flight_add::s#0 = fe_sprite_cache_copy::return#0 -- vbuz1=vbuaa 
    sta.z s
    // flight.cache[f] = s
    // [380] ((char *)&flight)[flight_add::f#2] = flight_add::s#0 -- pbuc1_derefidx_vbuz1=vbuz2 
    ldy.z f
    sta equinoxe_flightengine.flight,y
    // flight_sprite_next_offset()
    // [381] call flight_sprite_next_offset
    // [742] phi from flight_add::@6 to flight_sprite_next_offset [phi:flight_add::@6->flight_sprite_next_offset]
    jsr flight_sprite_next_offset
    // flight_sprite_next_offset()
    // [382] flight_sprite_next_offset::return#0 = flight_sprite_next_offset::vera_sprite_get_offset1_return#0 -- vwuz1=vwuz2 
    lda.z flight_sprite_next_offset.vera_sprite_get_offset1_return
    sta.z flight_sprite_next_offset.return
    lda.z flight_sprite_next_offset.vera_sprite_get_offset1_return+1
    sta.z flight_sprite_next_offset.return+1
    // flight_add::@7
    // [383] flight_add::$4 = flight_sprite_next_offset::return#0
    // flight.sprite_offset[f] = flight_sprite_next_offset()
    // [384] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET)[flight_add::$12] = flight_add::$4 -- pwuc1_derefidx_vbuz1=vwuz2 
    ldy.z flight_add__12
    lda.z flight_add__4
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET,y
    lda.z flight_add__4+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET+1,y
    // fe_sprite_configure(flight.sprite_offset[f], s)
    // [385] fe_sprite_configure::sprite_offset#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET)[flight_add::$12] -- vwuz1=pwuc1_derefidx_vbuz2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET,y
    sta.z fe_sprite_configure.sprite_offset
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPRITE_OFFSET+1,y
    sta.z fe_sprite_configure.sprite_offset+1
    // [386] fe_sprite_configure::s#0 = flight_add::s#0 -- vbuyy=vbuz1 
    ldy.z s
    // [387] call fe_sprite_configure
    jsr fe_sprite_configure
    // flight_add::@8
    // return f;
    // [388] flight_add::return = flight_add::f#2
    // flight_add::@return
    // }
    // [389] return 
    rts
    // flight_add::@3
  __b3:
    // f + 1
    // [390] flight_add::$8 = flight_add::f#2 + 1 -- vbuaa=vbuz1_plus_1 
    lda.z f
    inc
    // f = (f + 1) % FLIGHT_OBJECTS
    // [391] flight_add::f#1 = flight_add::$8 & $40-1 -- vbuz1=vbuaa_band_vbuc1 
    and #$40-1
    sta.z f
    jmp __b2
}
.segment Code
  // strcpy
// Copies the C string pointed by source into the array pointed by destination, including the terminating null character (and stopping at that point).
// char * strcpy(__zp($6c) char *destination, __zp($75) char *source)
strcpy: {
    .label src = $75
    .label dst = $6c
    .label destination = $6c
    .label source = $75
    // [405] phi from strcpy strcpy::@2 to strcpy::@1 [phi:strcpy/strcpy::@2->strcpy::@1]
    // [405] phi strcpy::dst#2 = strcpy::dst#0 [phi:strcpy/strcpy::@2->strcpy::@1#0] -- register_copy 
    // [405] phi strcpy::src#2 = strcpy::src#0 [phi:strcpy/strcpy::@2->strcpy::@1#1] -- register_copy 
    // strcpy::@1
  __b1:
    // while(*src)
    // [406] if(0!=*strcpy::src#2) goto strcpy::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strcpy::@3
    // *dst = 0
    // [407] *strcpy::dst#2 = 0 -- _deref_pbuz1=vbuc1 
    tya
    tay
    sta (dst),y
    // strcpy::@return
    // }
    // [408] return 
    rts
    // strcpy::@2
  __b2:
    // *dst++ = *src++
    // [409] *strcpy::dst#2 = *strcpy::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [410] strcpy::dst#1 = ++ strcpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [411] strcpy::src#1 = ++ strcpy::src#2 -- pbuz1=_inc_pbuz1 
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
    .label strcat__0 = $6c
    .label dst = $6c
    .label src = $75
    // strlen(destination)
    // [413] call strlen
    // [793] phi from strcat to strlen [phi:strcat->strlen]
    // [793] phi strlen::str#6 = fe_sprite_bram_load::filename [phi:strcat->strlen#0] -- pbuz1=pbuc1 
    lda #<fe_sprite_bram_load.filename
    sta.z strlen.str
    lda #>fe_sprite_bram_load.filename
    sta.z strlen.str+1
    jsr strlen
    // strlen(destination)
    // [414] strlen::return#0 = strlen::len#2
    // strcat::@4
    // [415] strcat::$0 = strlen::return#0
    // char* dst = destination + strlen(destination)
    // [416] strcat::dst#0 = fe_sprite_bram_load::filename + strcat::$0 -- pbuz1=pbuc1_plus_vwuz1 
    lda.z dst
    clc
    adc #<fe_sprite_bram_load.filename
    sta.z dst
    lda.z dst+1
    adc #>fe_sprite_bram_load.filename
    sta.z dst+1
    // [417] phi from strcat::@4 to strcat::@1 [phi:strcat::@4->strcat::@1]
    // [417] phi strcat::dst#2 = strcat::dst#0 [phi:strcat::@4->strcat::@1#0] -- register_copy 
    // [417] phi strcat::src#2 = fe_sprite_bram_load::source [phi:strcat::@4->strcat::@1#1] -- pbuz1=pbuc1 
    lda #<fe_sprite_bram_load.source
    sta.z src
    lda #>fe_sprite_bram_load.source
    sta.z src+1
    // strcat::@1
  __b1:
    // while(*src)
    // [418] if(0!=*strcat::src#2) goto strcat::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strcat::@3
    // *dst = 0
    // [419] *strcat::dst#2 = 0 -- _deref_pbuz1=vbuc1 
    tya
    tay
    sta (dst),y
    // strcat::@return
    // }
    // [420] return 
    rts
    // strcat::@2
  __b2:
    // *dst++ = *src++
    // [421] *strcat::dst#2 = *strcat::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [422] strcat::dst#1 = ++ strcat::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [423] strcat::src#1 = ++ strcat::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [417] phi from strcat::@2 to strcat::@1 [phi:strcat::@2->strcat::@1]
    // [417] phi strcat::dst#2 = strcat::dst#1 [phi:strcat::@2->strcat::@1#0] -- register_copy 
    // [417] phi strcat::src#2 = strcat::src#1 [phi:strcat::@2->strcat::@1#1] -- register_copy 
    jmp __b1
}
  // fopen
/**
 * @brief Load a file to banked ram located between address 0xA000 and 0xBFFF incrementing the banks.
 *
 * @param channel Input channel.
 * @param device Input device.
 * @param secondary Secondary channel.
 * @param filename Name of the file to be loaded.
 * @return
 *  - 0x0000: Something is wrong! Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
 *  - other: OK! The last pointer between 0xA000 and 0xBFFF is returned. Note that the last pointer is indicating the first free byte.
 */
// __zp($79) FILE * fopen(__zp($7b) const char *path, const char *mode)
fopen: {
    .label fopen__11 = $75
    .label fopen__16 = $75
    .label fopen__26 = $6a
    .label fopen__28 = $6c
    .label fopen__30 = $79
    .label cbm_k_setnam1_filename = $e0
    .label cbm_k_setnam1_filename_len = $cd
    .label cbm_k_setnam1_fopen__0 = $6c
    .label cbm_k_readst1_status = $ce
    .label cbm_k_close1_channel = $cf
    .label sp = $d9
    .label stream = $79
    .label pathpos = $e4
    .label pathpos_1 = $b3
    .label pathtoken = $75
    .label pathcmp = $be
    .label path = $7b
    // Parse path
    .label pathstep = $7d
    .label return = $79
    // unsigned char sp = __stdio_filecount
    // [424] fopen::sp#0 = __stdio_filecount -- vbuz1=vbuz2 
    lda.z __stdio_filecount
    sta.z sp
    // (unsigned int)sp | 0x8000
    // [425] fopen::$30 = (unsigned int)fopen::sp#0 -- vwuz1=_word_vbuz2 
    sta.z fopen__30
    lda #0
    sta.z fopen__30+1
    // [426] fopen::stream#0 = fopen::$30 | $8000 -- vwuz1=vwuz1_bor_vwuc1 
    lda.z stream
    ora #<$8000
    sta.z stream
    lda.z stream+1
    ora #>$8000
    sta.z stream+1
    // char pathpos = sp * __STDIO_FILECOUNT
    // [427] fopen::pathpos#0 = fopen::sp#0 << 2 -- vbuz1=vbuz2_rol_2 
    lda.z sp
    asl
    asl
    sta.z pathpos
    // __logical = 0
    // [428] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z sp
    sta __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    // __device = 0
    // [429] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    // __channel = 0
    // [430] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    // [431] fopen::pathpos#21 = fopen::pathpos#0 -- vbuz1=vbuz2 
    lda.z pathpos
    sta.z pathpos_1
    // [432] phi from fopen to fopen::@8 [phi:fopen->fopen::@8]
    // [432] phi fopen::num#10 = 0 [phi:fopen->fopen::@8#0] -- vbuxx=vbuc1 
    ldx #0
    // [432] phi fopen::pathpos#10 = fopen::pathpos#21 [phi:fopen->fopen::@8#1] -- register_copy 
    // [432] phi fopen::path#13 = fe_sprite_bram_load::filename [phi:fopen->fopen::@8#2] -- pbuz1=pbuc1 
    lda #<fe_sprite_bram_load.filename
    sta.z path
    lda #>fe_sprite_bram_load.filename
    sta.z path+1
    // [432] phi fopen::pathstep#10 = 0 [phi:fopen->fopen::@8#3] -- vbuz1=vbuc1 
    txa
    sta.z pathstep
    // [432] phi fopen::pathtoken#10 = fe_sprite_bram_load::filename [phi:fopen->fopen::@8#4] -- pbuz1=pbuc1 
    lda #<fe_sprite_bram_load.filename
    sta.z pathtoken
    lda #>fe_sprite_bram_load.filename
    sta.z pathtoken+1
  // Iterate while path is not \0.
    // [432] phi from fopen::@22 to fopen::@8 [phi:fopen::@22->fopen::@8]
    // [432] phi fopen::num#10 = fopen::num#13 [phi:fopen::@22->fopen::@8#0] -- register_copy 
    // [432] phi fopen::pathpos#10 = fopen::pathpos#7 [phi:fopen::@22->fopen::@8#1] -- register_copy 
    // [432] phi fopen::path#13 = fopen::path#10 [phi:fopen::@22->fopen::@8#2] -- register_copy 
    // [432] phi fopen::pathstep#10 = fopen::pathstep#11 [phi:fopen::@22->fopen::@8#3] -- register_copy 
    // [432] phi fopen::pathtoken#10 = fopen::pathtoken#1 [phi:fopen::@22->fopen::@8#4] -- register_copy 
    // fopen::@8
  __b8:
    // if (*pathtoken == ',' || *pathtoken == '\0')
    // [433] if(*fopen::pathtoken#10==','pm) goto fopen::@9 -- _deref_pbuz1_eq_vbuc1_then_la1 
    lda #','
    ldy #0
    cmp (pathtoken),y
    bne !__b9+
    jmp __b9
  !__b9:
    // fopen::@33
    // [434] if(*fopen::pathtoken#10=='?'pm) goto fopen::@9 -- _deref_pbuz1_eq_vbuc1_then_la1 
    lda #'\$00'
    cmp (pathtoken),y
    bne !__b9+
    jmp __b9
  !__b9:
    // fopen::@23
    // if (pathstep == 0)
    // [435] if(fopen::pathstep#10!=0) goto fopen::@10 -- vbuz1_neq_0_then_la1 
    lda.z pathstep
    bne __b10
    // fopen::@24
    // __stdio_file.filename[pathpos] = *pathtoken
    // [436] ((char *)&__stdio_file)[fopen::pathpos#10] = *fopen::pathtoken#10 -- pbuc1_derefidx_vbuz1=_deref_pbuz2 
    lda (pathtoken),y
    ldy.z pathpos_1
    sta __stdio_file,y
    // pathpos++;
    // [437] fopen::pathpos#1 = ++ fopen::pathpos#10 -- vbuz1=_inc_vbuz1 
    inc.z pathpos_1
    // [438] phi from fopen::@12 fopen::@23 fopen::@24 to fopen::@10 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10]
    // [438] phi fopen::num#13 = fopen::num#15 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#0] -- register_copy 
    // [438] phi fopen::pathpos#7 = fopen::pathpos#10 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#1] -- register_copy 
    // [438] phi fopen::path#10 = fopen::path#12 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#2] -- register_copy 
    // [438] phi fopen::pathstep#11 = fopen::pathstep#1 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#3] -- register_copy 
    // fopen::@10
  __b10:
    // pathtoken++;
    // [439] fopen::pathtoken#1 = ++ fopen::pathtoken#10 -- pbuz1=_inc_pbuz1 
    inc.z pathtoken
    bne !+
    inc.z pathtoken+1
  !:
    // fopen::@22
    // pathtoken - 1
    // [440] fopen::$28 = fopen::pathtoken#1 - 1 -- pbuz1=pbuz2_minus_1 
    lda.z pathtoken
    sec
    sbc #1
    sta.z fopen__28
    lda.z pathtoken+1
    sbc #0
    sta.z fopen__28+1
    // while (*(pathtoken - 1))
    // [441] if(0!=*fopen::$28) goto fopen::@8 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (fopen__28),y
    cmp #0
    bne __b8
    // fopen::@26
    // __status = 0
    // [442] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    tya
    ldy.z sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if(!__logical)
    // [443] if(0!=((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0]) goto fopen::@1 -- 0_neq_pbuc1_derefidx_vbuz1_then_la1 
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    cmp #0
    bne __b1
    // fopen::@27
    // __stdio_filecount+1
    // [444] fopen::$4 = __stdio_filecount + 1 -- vbuaa=vbuz1_plus_1 
    lda.z __stdio_filecount
    inc
    // __logical = __stdio_filecount+1
    // [445] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] = fopen::$4 -- pbuc1_derefidx_vbuz1=vbuaa 
    sta __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    // fopen::@1
  __b1:
    // if(!__device)
    // [446] if(0!=((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0]) goto fopen::@2 -- 0_neq_pbuc1_derefidx_vbuz1_then_la1 
    ldy.z sp
    lda __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    cmp #0
    bne __b2
    // fopen::@5
    // __device = 8
    // [447] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0] = 8 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #8
    sta __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    // fopen::@2
  __b2:
    // if(!__channel)
    // [448] if(0!=((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0]) goto fopen::@3 -- 0_neq_pbuc1_derefidx_vbuz1_then_la1 
    ldy.z sp
    lda __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    cmp #0
    bne __b3
    // fopen::@6
    // __stdio_filecount+2
    // [449] fopen::$9 = __stdio_filecount + 2 -- vbuaa=vbuz1_plus_2 
    lda.z __stdio_filecount
    clc
    adc #2
    // __channel = __stdio_filecount+2
    // [450] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0] = fopen::$9 -- pbuc1_derefidx_vbuz1=vbuaa 
    sta __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    // fopen::@3
  __b3:
    // __filename
    // [451] fopen::$11 = (char *)&__stdio_file + fopen::pathpos#0 -- pbuz1=pbuc1_plus_vbuz2 
    lda.z pathpos
    clc
    adc #<__stdio_file
    sta.z fopen__11
    lda #>__stdio_file
    adc #0
    sta.z fopen__11+1
    // cbm_k_setnam(__filename)
    // [452] fopen::cbm_k_setnam1_filename = fopen::$11 -- pbuz1=pbuz2 
    lda.z fopen__11
    sta.z cbm_k_setnam1_filename
    lda.z fopen__11+1
    sta.z cbm_k_setnam1_filename+1
    // fopen::cbm_k_setnam1
    // strlen(filename)
    // [453] strlen::str#2 = fopen::cbm_k_setnam1_filename -- pbuz1=pbuz2 
    lda.z cbm_k_setnam1_filename
    sta.z strlen.str
    lda.z cbm_k_setnam1_filename+1
    sta.z strlen.str+1
    // [454] call strlen
    // [793] phi from fopen::cbm_k_setnam1 to strlen [phi:fopen::cbm_k_setnam1->strlen]
    // [793] phi strlen::str#6 = strlen::str#2 [phi:fopen::cbm_k_setnam1->strlen#0] -- register_copy 
    jsr strlen
    // strlen(filename)
    // [455] strlen::return#3 = strlen::len#2
    // fopen::@31
    // [456] fopen::cbm_k_setnam1_$0 = strlen::return#3
    // char filename_len = (char)strlen(filename)
    // [457] fopen::cbm_k_setnam1_filename_len = (char)fopen::cbm_k_setnam1_$0 -- vbuz1=_byte_vwuz2 
    lda.z cbm_k_setnam1_fopen__0
    sta.z cbm_k_setnam1_filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx cbm_k_setnam1_filename
    ldy cbm_k_setnam1_filename+1
    jsr CBM_SETNAM
    // fopen::@28
    // cbm_k_setlfs(__logical, __device, __channel)
    // [459] cbm_k_setlfs::channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z sp
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta.z cbm_k_setlfs.channel
    // [460] cbm_k_setlfs::device = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    lda __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    sta.z cbm_k_setlfs.device
    // [461] cbm_k_setlfs::command = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    lda __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    sta.z cbm_k_setlfs.command
    // [462] call cbm_k_setlfs
    jsr cbm_k_setlfs
    // fopen::cbm_k_open1
    // asm
    // asm { jsrCBM_OPEN  }
    jsr CBM_OPEN
    // fopen::cbm_k_readst1
    // char status
    // [464] fopen::cbm_k_readst1_status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [466] fopen::cbm_k_readst1_return#0 = fopen::cbm_k_readst1_status -- vbuaa=vbuz1 
    // fopen::cbm_k_readst1_@return
    // }
    // [467] fopen::cbm_k_readst1_return#1 = fopen::cbm_k_readst1_return#0
    // fopen::@29
    // cbm_k_readst()
    // [468] fopen::$15 = fopen::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [469] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fopen::sp#0] = fopen::$15 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // ferror(stream)
    // [470] ferror::stream#0 = (FILE *)fopen::stream#0
    // [471] call ferror
    jsr ferror
    // [472] ferror::return#0 = ferror::return#1
    // fopen::@32
    // [473] fopen::$16 = ferror::return#0
    // if (ferror(stream))
    // [474] if(0==fopen::$16) goto fopen::@4 -- 0_eq_vwsz1_then_la1 
    lda.z fopen__16
    ora.z fopen__16+1
    beq __b4
    // fopen::@7
    // cbm_k_close(__logical)
    // [475] fopen::cbm_k_close1_channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z sp
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta.z cbm_k_close1_channel
    // fopen::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // [477] phi from fopen::cbm_k_close1 to fopen::@return [phi:fopen::cbm_k_close1->fopen::@return]
    // [477] phi fopen::return#2 = 0 [phi:fopen::cbm_k_close1->fopen::@return#0] -- pssz1=vbuc1 
    lda #<0
    sta.z return
    sta.z return+1
    // fopen::@return
    // }
    // [478] return 
    rts
    // fopen::@4
  __b4:
    // __stdio_filecount++;
    // [479] __stdio_filecount = ++ __stdio_filecount -- vbuz1=_inc_vbuz1 
    inc.z __stdio_filecount
    // [480] fopen::return#6 = (FILE *)fopen::stream#0
    // [477] phi from fopen::@4 to fopen::@return [phi:fopen::@4->fopen::@return]
    // [477] phi fopen::return#2 = fopen::return#6 [phi:fopen::@4->fopen::@return#0] -- register_copy 
    rts
    // fopen::@9
  __b9:
    // if (pathstep > 0)
    // [481] if(fopen::pathstep#10>0) goto fopen::@11 -- vbuz1_gt_0_then_la1 
    lda.z pathstep
    bne __b11
    // fopen::@25
    // __stdio_file.filename[pathpos] = '\0'
    // [482] ((char *)&__stdio_file)[fopen::pathpos#10] = '?'pm -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #'\$00'
    ldy.z pathpos_1
    sta __stdio_file,y
    // path = pathtoken + 1
    // [483] fopen::path#0 = fopen::pathtoken#10 + 1 -- pbuz1=pbuz2_plus_1 
    clc
    lda.z pathtoken
    adc #1
    sta.z path
    lda.z pathtoken+1
    adc #0
    sta.z path+1
    // [484] phi from fopen::@16 fopen::@17 fopen::@18 fopen::@19 fopen::@25 to fopen::@12 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12]
    // [484] phi fopen::num#15 = fopen::num#2 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12#0] -- register_copy 
    // [484] phi fopen::path#12 = fopen::path#15 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12#1] -- register_copy 
    // fopen::@12
  __b12:
    // pathstep++;
    // [485] fopen::pathstep#1 = ++ fopen::pathstep#10 -- vbuz1=_inc_vbuz1 
    inc.z pathstep
    jmp __b10
    // fopen::@11
  __b11:
    // char pathcmp = *path
    // [486] fopen::pathcmp#0 = *fopen::path#13 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (path),y
    sta.z pathcmp
    // case 'D':
    // [487] if(fopen::pathcmp#0=='D'pm) goto fopen::@13 -- vbuz1_eq_vbuc1_then_la1 
    lda #'D'
    cmp.z pathcmp
    beq __b13
    // fopen::@20
    // case 'L':
    // [488] if(fopen::pathcmp#0=='L'pm) goto fopen::@13 -- vbuz1_eq_vbuc1_then_la1 
    lda #'L'
    cmp.z pathcmp
    beq __b13
    // fopen::@21
    // case 'C':
    //                     num = (char)atoi(path + 1);
    //                     path = pathtoken + 1;
    // [489] if(fopen::pathcmp#0=='C'pm) goto fopen::@13 -- vbuz1_eq_vbuc1_then_la1 
    lda #'C'
    cmp.z pathcmp
    beq __b13
    // [490] phi from fopen::@21 fopen::@30 to fopen::@14 [phi:fopen::@21/fopen::@30->fopen::@14]
    // [490] phi fopen::path#15 = fopen::path#13 [phi:fopen::@21/fopen::@30->fopen::@14#0] -- register_copy 
    // [490] phi fopen::num#2 = fopen::num#10 [phi:fopen::@21/fopen::@30->fopen::@14#1] -- register_copy 
    // fopen::@14
  __b14:
    // case 'L':
    //                     __logical = num;
    //                     break;
    // [491] if(fopen::pathcmp#0=='L'pm) goto fopen::@17 -- vbuz1_eq_vbuc1_then_la1 
    lda #'L'
    cmp.z pathcmp
    beq __b17
    // fopen::@15
    // case 'D':
    //                     __device = num;
    //                     break;
    // [492] if(fopen::pathcmp#0=='D'pm) goto fopen::@18 -- vbuz1_eq_vbuc1_then_la1 
    lda #'D'
    cmp.z pathcmp
    beq __b18
    // fopen::@16
    // case 'C':
    //                     __channel = num;
    //                     break;
    // [493] if(fopen::pathcmp#0!='C'pm) goto fopen::@12 -- vbuz1_neq_vbuc1_then_la1 
    lda #'C'
    cmp.z pathcmp
    bne __b12
    // fopen::@19
    // __channel = num
    // [494] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbuz1=vbuxx 
    ldy.z sp
    txa
    sta __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    jmp __b12
    // fopen::@18
  __b18:
    // __device = num
    // [495] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbuz1=vbuxx 
    ldy.z sp
    txa
    sta __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    jmp __b12
    // fopen::@17
  __b17:
    // __logical = num
    // [496] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbuz1=vbuxx 
    ldy.z sp
    txa
    sta __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    jmp __b12
    // fopen::@13
  __b13:
    // atoi(path + 1)
    // [497] atoi::str#0 = fopen::path#13 + 1 -- pbuz1=pbuz1_plus_1 
    inc.z atoi.str
    bne !+
    inc.z atoi.str+1
  !:
    // [498] call atoi
    // [854] phi from fopen::@13 to atoi [phi:fopen::@13->atoi]
    // [854] phi atoi::str#2 = atoi::str#0 [phi:fopen::@13->atoi#0] -- register_copy 
    jsr atoi
    // atoi(path + 1)
    // [499] atoi::return#3 = atoi::return#2
    // fopen::@30
    // [500] fopen::$26 = atoi::return#3
    // num = (char)atoi(path + 1)
    // [501] fopen::num#1 = (char)fopen::$26 -- vbuxx=_byte_vwsz1 
    lda.z fopen__26
    tax
    // path = pathtoken + 1
    // [502] fopen::path#1 = fopen::pathtoken#10 + 1 -- pbuz1=pbuz2_plus_1 
    clc
    lda.z pathtoken
    adc #1
    sta.z path
    lda.z pathtoken+1
    adc #0
    sta.z path+1
    jmp __b14
}
  // fgets
/**
 * @brief Load a file to ram or (banked ram located between address 0xA000 and 0xBFFF), incrementing the banks.
 * This function uses the new CX16 macptr kernal API at address $FF44.
 *
 * @param sptr The pointer between 0xA000 and 0xBFFF in banked ram.
 * @param size The amount of bytes to be read.
 * @param filename Name of the file to be loaded.
 * @return ptr the pointer advanced to the point where the stream ends.
 */
// __zp($75) unsigned int fgets(__zp($79) char *ptr, __zp($7b) unsigned int size, __zp($75) FILE *stream)
fgets: {
    .label cbm_k_chkin1_channel = $bf
    .label cbm_k_chkin1_status = $b6
    .label cbm_k_readst1_status = $b7
    .label cbm_k_readst2_status = $7e
    .label sp = $a7
    .label return = $75
    .label bytes = $6a
    .label read = $75
    .label ptr = $79
    .label remaining = $6c
    .label stream = $75
    .label size = $7b
    // unsigned char sp = (unsigned char)stream
    // [504] fgets::sp#0 = (char)fgets::stream#3 -- vbuz1=_byte_pssz2 
    lda.z stream
    sta.z sp
    // cbm_k_chkin(__logical)
    // [505] fgets::cbm_k_chkin1_channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fgets::sp#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    tay
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta.z cbm_k_chkin1_channel
    // fgets::cbm_k_chkin1
    // char status
    // [506] fgets::cbm_k_chkin1_status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // fgets::cbm_k_readst1
    // char status
    // [508] fgets::cbm_k_readst1_status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [510] fgets::cbm_k_readst1_return#0 = fgets::cbm_k_readst1_status -- vbuaa=vbuz1 
    // fgets::cbm_k_readst1_@return
    // }
    // [511] fgets::cbm_k_readst1_return#1 = fgets::cbm_k_readst1_return#0
    // fgets::@11
    // cbm_k_readst()
    // [512] fgets::$1 = fgets::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [513] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0] = fgets::$1 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if (__status)
    // [514] if(0==((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0]) goto fgets::@1 -- 0_eq_pbuc1_derefidx_vbuz1_then_la1 
    lda __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    cmp #0
    beq __b1
    // [515] phi from fgets::@11 fgets::@12 fgets::@5 to fgets::@return [phi:fgets::@11/fgets::@12/fgets::@5->fgets::@return]
  __b8:
    // [515] phi fgets::return#1 = 0 [phi:fgets::@11/fgets::@12/fgets::@5->fgets::@return#0] -- vwuz1=vbuc1 
    lda #<0
    sta.z return
    sta.z return+1
    // fgets::@return
    // }
    // [516] return 
    rts
    // fgets::@1
  __b1:
    // [517] fgets::remaining#22 = fgets::size#11 -- vwuz1=vwuz2 
    lda.z size
    sta.z remaining
    lda.z size+1
    sta.z remaining+1
    // [518] phi from fgets::@1 to fgets::@2 [phi:fgets::@1->fgets::@2]
    // [518] phi fgets::read#10 = 0 [phi:fgets::@1->fgets::@2#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z read
    sta.z read+1
    // [518] phi fgets::remaining#11 = fgets::remaining#22 [phi:fgets::@1->fgets::@2#1] -- register_copy 
    // [518] phi fgets::ptr#10 = fgets::ptr#13 [phi:fgets::@1->fgets::@2#2] -- register_copy 
    // [518] phi from fgets::@17 fgets::@18 to fgets::@2 [phi:fgets::@17/fgets::@18->fgets::@2]
    // [518] phi fgets::read#10 = fgets::read#1 [phi:fgets::@17/fgets::@18->fgets::@2#0] -- register_copy 
    // [518] phi fgets::remaining#11 = fgets::remaining#1 [phi:fgets::@17/fgets::@18->fgets::@2#1] -- register_copy 
    // [518] phi fgets::ptr#10 = fgets::ptr#14 [phi:fgets::@17/fgets::@18->fgets::@2#2] -- register_copy 
    // fgets::@2
  __b2:
    // if (!size)
    // [519] if(0==fgets::size#11) goto fgets::@3 -- 0_eq_vwuz1_then_la1 
    lda.z size
    ora.z size+1
    bne !__b3+
    jmp __b3
  !__b3:
    // fgets::@8
    // if (remaining >= 512)
    // [520] if(fgets::remaining#11>=$200) goto fgets::@4 -- vwuz1_ge_vwuc1_then_la1 
    lda.z remaining+1
    cmp #>$200
    bcc !+
    beq !__b4+
    jmp __b4
  !__b4:
    lda.z remaining
    cmp #<$200
    bcc !__b4+
    jmp __b4
  !__b4:
  !:
    // fgets::@9
    // cx16_k_macptr(remaining, ptr)
    // [521] cx16_k_macptr::bytes = fgets::remaining#11 -- vbuz1=vwuz2 
    lda.z remaining
    sta.z cx16_k_macptr.bytes
    // [522] cx16_k_macptr::buffer = (void *)fgets::ptr#10 -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [523] call cx16_k_macptr
    jsr cx16_k_macptr
    // [524] cx16_k_macptr::return#4 = cx16_k_macptr::return#1
    // fgets::@15
  __b15:
    // bytes = cx16_k_macptr(remaining, ptr)
    // [525] fgets::bytes#3 = cx16_k_macptr::return#4
    // [526] phi from fgets::@13 fgets::@14 fgets::@15 to fgets::cbm_k_readst2 [phi:fgets::@13/fgets::@14/fgets::@15->fgets::cbm_k_readst2]
    // [526] phi fgets::bytes#10 = fgets::bytes#1 [phi:fgets::@13/fgets::@14/fgets::@15->fgets::cbm_k_readst2#0] -- register_copy 
    // fgets::cbm_k_readst2
    // char status
    // [527] fgets::cbm_k_readst2_status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_readst2_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst2_status
    // return status;
    // [529] fgets::cbm_k_readst2_return#0 = fgets::cbm_k_readst2_status -- vbuaa=vbuz1 
    // fgets::cbm_k_readst2_@return
    // }
    // [530] fgets::cbm_k_readst2_return#1 = fgets::cbm_k_readst2_return#0
    // fgets::@12
    // cbm_k_readst()
    // [531] fgets::$8 = fgets::cbm_k_readst2_return#1
    // __status = cbm_k_readst()
    // [532] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0] = fgets::$8 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // __status & 0xBF
    // [533] fgets::$9 = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0] & $bf -- vbuaa=pbuc1_derefidx_vbuz1_band_vbuc2 
    lda #$bf
    and __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if (__status & 0xBF)
    // [534] if(0==fgets::$9) goto fgets::@5 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b5
    jmp __b8
    // fgets::@5
  __b5:
    // if (bytes == 0xFFFF)
    // [535] if(fgets::bytes#10!=$ffff) goto fgets::@6 -- vwuz1_neq_vwuc1_then_la1 
    lda.z bytes+1
    cmp #>$ffff
    bne __b6
    lda.z bytes
    cmp #<$ffff
    bne __b6
    jmp __b8
    // fgets::@6
  __b6:
    // read += bytes
    // [536] fgets::read#1 = fgets::read#10 + fgets::bytes#10 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z read
    adc.z bytes
    sta.z read
    lda.z read+1
    adc.z bytes+1
    sta.z read+1
    // ptr += bytes
    // [537] fgets::ptr#0 = fgets::ptr#10 + fgets::bytes#10 -- pbuz1=pbuz1_plus_vwuz2 
    clc
    lda.z ptr
    adc.z bytes
    sta.z ptr
    lda.z ptr+1
    adc.z bytes+1
    sta.z ptr+1
    // BYTE1(ptr)
    // [538] fgets::$13 = byte1  fgets::ptr#0 -- vbuaa=_byte1_pbuz1 
    // if (BYTE1(ptr) == 0xC0)
    // [539] if(fgets::$13!=$c0) goto fgets::@7 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$c0
    bne __b7
    // fgets::@10
    // ptr -= 0x2000
    // [540] fgets::ptr#1 = fgets::ptr#0 - $2000 -- pbuz1=pbuz1_minus_vwuc1 
    lda.z ptr
    sec
    sbc #<$2000
    sta.z ptr
    lda.z ptr+1
    sbc #>$2000
    sta.z ptr+1
    // [541] phi from fgets::@10 fgets::@6 to fgets::@7 [phi:fgets::@10/fgets::@6->fgets::@7]
    // [541] phi fgets::ptr#14 = fgets::ptr#1 [phi:fgets::@10/fgets::@6->fgets::@7#0] -- register_copy 
    // fgets::@7
  __b7:
    // remaining -= bytes
    // [542] fgets::remaining#1 = fgets::remaining#11 - fgets::bytes#10 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z remaining
    sec
    sbc.z bytes
    sta.z remaining
    lda.z remaining+1
    sbc.z bytes+1
    sta.z remaining+1
    // while ((__status == 0) && ((size && remaining) || !size))
    // [543] if(((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0]==0) goto fgets::@16 -- pbuc1_derefidx_vbuz1_eq_0_then_la1 
    ldy.z sp
    lda __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    cmp #0
    beq __b16
    // [515] phi from fgets::@17 fgets::@7 to fgets::@return [phi:fgets::@17/fgets::@7->fgets::@return]
    // [515] phi fgets::return#1 = fgets::read#1 [phi:fgets::@17/fgets::@7->fgets::@return#0] -- register_copy 
    rts
    // fgets::@16
  __b16:
    // while ((__status == 0) && ((size && remaining) || !size))
    // [544] if(0==fgets::size#11) goto fgets::@17 -- 0_eq_vwuz1_then_la1 
    lda.z size
    ora.z size+1
    beq __b17
    // fgets::@18
    // [545] if(0!=fgets::remaining#1) goto fgets::@2 -- 0_neq_vwuz1_then_la1 
    lda.z remaining
    ora.z remaining+1
    beq !__b2+
    jmp __b2
  !__b2:
    // fgets::@17
  __b17:
    // [546] if(0==fgets::size#11) goto fgets::@2 -- 0_eq_vwuz1_then_la1 
    lda.z size
    ora.z size+1
    bne !__b2+
    jmp __b2
  !__b2:
    rts
    // fgets::@4
  __b4:
    // cx16_k_macptr(512, ptr)
    // [547] cx16_k_macptr::bytes = $200 -- vbuz1=vwuc1 
    lda #<$200
    sta.z cx16_k_macptr.bytes
    // [548] cx16_k_macptr::buffer = (void *)fgets::ptr#10 -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [549] call cx16_k_macptr
    jsr cx16_k_macptr
    // [550] cx16_k_macptr::return#3 = cx16_k_macptr::return#1
    // fgets::@14
    // bytes = cx16_k_macptr(512, ptr)
    // [551] fgets::bytes#2 = cx16_k_macptr::return#3
    jmp __b15
    // fgets::@3
  __b3:
    // cx16_k_macptr(0, ptr)
    // [552] cx16_k_macptr::bytes = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_k_macptr.bytes
    // [553] cx16_k_macptr::buffer = (void *)fgets::ptr#10 -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [554] call cx16_k_macptr
    jsr cx16_k_macptr
    // [555] cx16_k_macptr::return#2 = cx16_k_macptr::return#1
    // fgets::@13
    // bytes = cx16_k_macptr(0, ptr)
    // [556] fgets::bytes#1 = cx16_k_macptr::return#2
    jmp __b15
}
.segment CodeEngineFlight
  // sprite_map_header
// void sprite_map_header(sprite_file_header_t *sprite_file_header, __zp($b4) char sprite)
sprite_map_header: {
    .label sprite_file_header = fe_sprite_bram_load.sprite_file_header
    .label sprite = $b4
    // sprites.count[sprite] = sprite_file_header->count
    // [557] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_COUNT)[sprite_map_header::sprite#0] = *((char *)sprite_map_header::sprite_file_header#0) -- pbuc1_derefidx_vbuz1=_deref_pbuc2 
    lda.z sprite_file_header
    ldy.z sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_COUNT,y
    // sprites.SpriteSize[sprite] = sprite_file_header->size
    // [558] sprite_map_header::$8 = sprite_map_header::sprite#0 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [559] ((unsigned int *)&sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE)[sprite_map_header::$8] = *((unsigned int *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_SIZE) -- pwuc1_derefidx_vbuaa=_deref_pwuc2 
    tay
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_SIZE
    sta sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE,y
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_SIZE+1
    sta sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE+1,y
    // vera_sprite_width_get_bitmap(sprite_file_header->width)
    // [560] sprite_map_header::vera_sprite_width_get_bitmap1_width#0 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_WIDTH) -- vbuaa=_deref_pbuc1 
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_WIDTH
    // sprite_map_header::vera_sprite_width_get_bitmap1
    // case 8:
    //             return VERA_SPRITE_WIDTH_8;
    // [561] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==8) goto sprite_map_header::vera_sprite_width_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #8
    beq __b5
    // sprite_map_header::vera_sprite_width_get_bitmap1_@1
    // case 16:
    //             return VERA_SPRITE_WIDTH_16;
    // [562] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==$10) goto sprite_map_header::vera_sprite_width_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #$10
    beq __b6
    // sprite_map_header::vera_sprite_width_get_bitmap1_@2
    // case 32:
    //             return VERA_SPRITE_WIDTH_32;
    // [563] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==$20) goto sprite_map_header::vera_sprite_width_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #$20
    beq __b7
    // sprite_map_header::vera_sprite_width_get_bitmap1_@3
    // case 64:
    //             return VERA_SPRITE_WIDTH_64;
    //         other:
    // [564] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==$40) goto sprite_map_header::vera_sprite_width_get_bitmap1_@9 -- vbuaa_eq_vbuc1_then_la1 
    cmp #$40
    beq vera_sprite_width_get_bitmap1___b9
    // [566] phi from sprite_map_header::vera_sprite_width_get_bitmap1 sprite_map_header::vera_sprite_width_get_bitmap1_@3 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1/sprite_map_header::vera_sprite_width_get_bitmap1_@3->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
  __b5:
    // [566] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = 0 [phi:sprite_map_header::vera_sprite_width_get_bitmap1/sprite_map_header::vera_sprite_width_get_bitmap1_@3->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b1
    // [565] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@3 to sprite_map_header::vera_sprite_width_get_bitmap1_@9 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@3->sprite_map_header::vera_sprite_width_get_bitmap1_@9]
    // sprite_map_header::vera_sprite_width_get_bitmap1_@9
  vera_sprite_width_get_bitmap1___b9:
    // [566] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@9 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@9->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
    // [566] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = $30 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@9->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$30
    jmp __b1
    // [566] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@1 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@1->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
  __b6:
    // [566] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = $10 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@1->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$10
    jmp __b1
    // [566] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@2 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@2->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
  __b7:
    // [566] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = $20 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@2->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$20
    // sprite_map_header::vera_sprite_width_get_bitmap1_@return
    // sprite_map_header::@1
  __b1:
    // sprites.Width[sprite] = vera_sprite_width_get_bitmap(sprite_file_header->width)
    // [567] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_WIDTH)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_width_get_bitmap1_return#5 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_WIDTH,y
    // vera_sprite_height_get_bitmap(sprite_file_header->height)
    // [568] sprite_map_header::vera_sprite_height_get_bitmap1_height#0 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HEIGHT) -- vbuaa=_deref_pbuc1 
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HEIGHT
    // sprite_map_header::vera_sprite_height_get_bitmap1
    // case 8:
    //             return VERA_SPRITE_HEIGHT_8;
    // [569] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==8) goto sprite_map_header::vera_sprite_height_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #8
    beq __b8
    // sprite_map_header::vera_sprite_height_get_bitmap1_@1
    // case 16:
    //             return VERA_SPRITE_HEIGHT_16;
    // [570] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==$10) goto sprite_map_header::vera_sprite_height_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #$10
    beq __b9
    // sprite_map_header::vera_sprite_height_get_bitmap1_@2
    // case 32:
    //             return VERA_SPRITE_HEIGHT_32;
    // [571] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==$20) goto sprite_map_header::vera_sprite_height_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #$20
    beq __b10
    // sprite_map_header::vera_sprite_height_get_bitmap1_@3
    // case 64:
    //             return VERA_SPRITE_HEIGHT_64;
    //         other:
    // [572] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==$40) goto sprite_map_header::vera_sprite_height_get_bitmap1_@9 -- vbuaa_eq_vbuc1_then_la1 
    cmp #$40
    beq vera_sprite_height_get_bitmap1___b9
    // [574] phi from sprite_map_header::vera_sprite_height_get_bitmap1 sprite_map_header::vera_sprite_height_get_bitmap1_@3 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1/sprite_map_header::vera_sprite_height_get_bitmap1_@3->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
  __b8:
    // [574] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = 0 [phi:sprite_map_header::vera_sprite_height_get_bitmap1/sprite_map_header::vera_sprite_height_get_bitmap1_@3->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b2
    // [573] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@3 to sprite_map_header::vera_sprite_height_get_bitmap1_@9 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@3->sprite_map_header::vera_sprite_height_get_bitmap1_@9]
    // sprite_map_header::vera_sprite_height_get_bitmap1_@9
  vera_sprite_height_get_bitmap1___b9:
    // [574] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@9 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@9->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
    // [574] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = $c0 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@9->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$c0
    jmp __b2
    // [574] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@1 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@1->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
  __b9:
    // [574] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = $40 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@1->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$40
    jmp __b2
    // [574] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@2 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@2->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
  __b10:
    // [574] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = $80 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@2->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$80
    // sprite_map_header::vera_sprite_height_get_bitmap1_@return
    // sprite_map_header::@2
  __b2:
    // sprites.Height[sprite] = vera_sprite_height_get_bitmap(sprite_file_header->height)
    // [575] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_HEIGHT)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_height_get_bitmap1_return#5 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_HEIGHT,y
    // vera_sprite_zdepth_get_bitmap(sprite_file_header->zdepth)
    // [576] sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_ZDEPTH) -- vbuaa=_deref_pbuc1 
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_ZDEPTH
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1
    // case 0:
    //             return VERA_SPRITE_ZDEPTH_DISABLED;
    // [577] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==0) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b11
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1
    // case 1:
    //             return VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0;
    // [578] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==1) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #1
    beq __b12
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2
    // case 2:
    //             return VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1;
    // [579] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==2) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #2
    beq __b13
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3
    // case 3:
    //             return VERA_SPRITE_ZDEPTH_IN_FRONT;
    //         other:
    // [580] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==3) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9 -- vbuaa_eq_vbuc1_then_la1 
    cmp #3
    beq vera_sprite_zdepth_get_bitmap1___b9
    // [582] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1 sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1/sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
  __b11:
    // [582] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = 0 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1/sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b3
    // [581] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9]
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9
  vera_sprite_zdepth_get_bitmap1___b9:
    // [582] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
    // [582] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = $c [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$c
    jmp __b3
    // [582] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
  __b12:
    // [582] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = 4 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #4
    jmp __b3
    // [582] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
  __b13:
    // [582] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = 8 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #8
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return
    // sprite_map_header::@3
  __b3:
    // sprites.Zdepth[sprite] = vera_sprite_zdepth_get_bitmap(sprite_file_header->zdepth)
    // [583] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_ZDEPTH)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_ZDEPTH,y
    // vera_sprite_hflip_get_bitmap(sprite_file_header->hflip)
    // [584] sprite_map_header::vera_sprite_hflip_get_bitmap1_hflip#0 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HFLIP) -- vbuaa=_deref_pbuc1 
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HFLIP
    // sprite_map_header::vera_sprite_hflip_get_bitmap1
    // case 0:
    //             return VERA_SPRITE_NFLIP;
    // [585] if(sprite_map_header::vera_sprite_hflip_get_bitmap1_hflip#0==0) goto sprite_map_header::vera_sprite_hflip_get_bitmap1_@return -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b14
    // sprite_map_header::vera_sprite_hflip_get_bitmap1_@1
    // case 1:
    //             return VERA_SPRITE_HFLIP;
    //         other:
    // [586] if(sprite_map_header::vera_sprite_hflip_get_bitmap1_hflip#0==1) goto sprite_map_header::vera_sprite_hflip_get_bitmap1_@5 -- vbuaa_eq_vbuc1_then_la1 
    cmp #1
    beq vera_sprite_hflip_get_bitmap1___b5
    // [588] phi from sprite_map_header::vera_sprite_hflip_get_bitmap1 sprite_map_header::vera_sprite_hflip_get_bitmap1_@1 to sprite_map_header::vera_sprite_hflip_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1/sprite_map_header::vera_sprite_hflip_get_bitmap1_@1->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return]
  __b14:
    // [588] phi sprite_map_header::vera_sprite_hflip_get_bitmap1_return#3 = 0 [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1/sprite_map_header::vera_sprite_hflip_get_bitmap1_@1->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b4
    // [587] phi from sprite_map_header::vera_sprite_hflip_get_bitmap1_@1 to sprite_map_header::vera_sprite_hflip_get_bitmap1_@5 [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1_@1->sprite_map_header::vera_sprite_hflip_get_bitmap1_@5]
    // sprite_map_header::vera_sprite_hflip_get_bitmap1_@5
  vera_sprite_hflip_get_bitmap1___b5:
    // [588] phi from sprite_map_header::vera_sprite_hflip_get_bitmap1_@5 to sprite_map_header::vera_sprite_hflip_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1_@5->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return]
    // [588] phi sprite_map_header::vera_sprite_hflip_get_bitmap1_return#3 = 1 [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1_@5->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #1
    // sprite_map_header::vera_sprite_hflip_get_bitmap1_@return
    // sprite_map_header::@4
  __b4:
    // sprites.Hflip[sprite] = vera_sprite_hflip_get_bitmap(sprite_file_header->hflip)
    // [589] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_HFLIP)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_hflip_get_bitmap1_return#3 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_HFLIP,y
    // vera_sprite_vflip_get_bitmap(sprite_file_header->vflip)
    // [590] vera_sprite_vflip_get_bitmap::vflip#0 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_VFLIP) -- vbuaa=_deref_pbuc1 
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_VFLIP
    // [591] call vera_sprite_vflip_get_bitmap
    jsr vera_sprite_vflip_get_bitmap
    // [592] vera_sprite_vflip_get_bitmap::return#4 = vera_sprite_vflip_get_bitmap::return#3
    // sprite_map_header::@5
    // [593] sprite_map_header::$4 = vera_sprite_vflip_get_bitmap::return#4
    // sprites.Vflip[sprite] = vera_sprite_vflip_get_bitmap(sprite_file_header->vflip)
    // [594] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_VFLIP)[sprite_map_header::sprite#0] = sprite_map_header::$4 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_VFLIP,y
    // vera_sprite_bpp_get_bitmap(sprite_file_header->bpp)
    // [595] vera_sprite_bpp_get_bitmap::bpp#0 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_BPP) -- vbuaa=_deref_pbuc1 
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_BPP
    // [596] call vera_sprite_bpp_get_bitmap
    jsr vera_sprite_bpp_get_bitmap
    // [597] vera_sprite_bpp_get_bitmap::return#4 = vera_sprite_bpp_get_bitmap::return#3
    // sprite_map_header::@6
    // [598] sprite_map_header::$5 = vera_sprite_bpp_get_bitmap::return#4
    // sprites.BPP[sprite] = vera_sprite_bpp_get_bitmap(sprite_file_header->bpp)
    // [599] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_BPP)[sprite_map_header::sprite#0] = sprite_map_header::$5 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z sprite
    sta sprites+OFFSET_STRUCT_SPRITE_T_BPP,y
    // sprites.reverse[sprite] = sprite_file_header->reverse
    // [600] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_REVERSE)[sprite_map_header::sprite#0] = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_REVERSE) -- pbuc1_derefidx_vbuz1=_deref_pbuc2 
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_REVERSE
    sta sprites+OFFSET_STRUCT_SPRITE_T_REVERSE,y
    // sprites.aabb[sprite].xmin = sprite_file_header->collision
    // [601] sprite_map_header::$10 = sprite_map_header::sprite#0 << 2 -- vbuxx=vbuz1_rol_2 
    tya
    asl
    asl
    tax
    // [602] ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB)[sprite_map_header::$10] = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION) -- pbuc1_derefidx_vbuxx=_deref_pbuc2 
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION
    sta sprites+OFFSET_STRUCT_SPRITE_T_AABB,x
    // sprites.aabb[sprite].ymin = sprite_file_header->collision
    // [603] ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMIN)[sprite_map_header::$10] = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION) -- pbuc1_derefidx_vbuxx=_deref_pbuc2 
    sta sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMIN,x
    // sprite_file_header->width - sprite_file_header->collision
    // [604] sprite_map_header::$6 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_WIDTH) - *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION) -- vbuaa=_deref_pbuc1_minus__deref_pbuc2 
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_WIDTH
    sec
    sbc.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION
    // sprites.aabb[sprite].xmax = sprite_file_header->width - sprite_file_header->collision
    // [605] ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_XMAX)[sprite_map_header::$10] = sprite_map_header::$6 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_XMAX,x
    // sprite_file_header->height - sprite_file_header->collision
    // [606] sprite_map_header::$7 = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HEIGHT) - *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION) -- vbuaa=_deref_pbuc1_minus__deref_pbuc2 
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_HEIGHT
    sec
    sbc.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_COLLISION
    // sprites.aabb[sprite].ymax = sprite_file_header->height - sprite_file_header->collision
    // [607] ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMAX)[sprite_map_header::$10] = sprite_map_header::$7 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMAX,x
    // sprites.PaletteOffset[sprite] = 0
    // [608] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET)[sprite_map_header::sprite#0] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    sta sprites+OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET,y
    // sprites.loop[sprite] = sprite_file_header->loop
    // [609] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_LOOP)[sprite_map_header::sprite#0] = *((char *)sprite_map_header::sprite_file_header#0+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_LOOP) -- pbuc1_derefidx_vbuz1=_deref_pbuc2 
    lda.z sprite_file_header+OFFSET_STRUCT_SPRITE_FILE_HEADER_T_LOOP
    sta sprites+OFFSET_STRUCT_SPRITE_T_LOOP,y
    // sprites.sprite_cache[sprite] = 0
    // [610] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE)[sprite_map_header::sprite#0] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    sta sprites+OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE,y
    // sprite_map_header::@return
    // }
    // [611] return 
    rts
}
.segment Code
  // fclose
/**
 * @brief Close a file.
 *
 * @param fp The FILE pointer.
 * @return
 *  - 0x0000: Something is wrong! Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
 *  - other: OK! The last pointer between 0xA000 and 0xBFFF is returned. Note that the last pointer is indicating the first free byte.
 */
// __zp($6c) int fclose(__zp($75) FILE *stream)
fclose: {
    .label cbm_k_chkin1_channel = $db
    .label cbm_k_chkin1_status = $d0
    .label cbm_k_readst1_status = $d1
    .label cbm_k_close1_channel = $d2
    .label cbm_k_readst2_status = $d3
    .label sp = $aa
    .label return = $6c
    .label stream = $75
    // unsigned char sp = (unsigned char)stream
    // [612] fclose::sp#0 = (char)fclose::stream#0 -- vbuz1=_byte_pssz2 
    lda.z stream
    sta.z sp
    // cbm_k_chkin(__logical)
    // [613] fclose::cbm_k_chkin1_channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fclose::sp#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    tay
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta.z cbm_k_chkin1_channel
    // fclose::cbm_k_chkin1
    // char status
    // [614] fclose::cbm_k_chkin1_status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // fclose::cbm_k_readst1
    // char status
    // [616] fclose::cbm_k_readst1_status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [618] fclose::cbm_k_readst1_return#0 = fclose::cbm_k_readst1_status -- vbuaa=vbuz1 
    // fclose::cbm_k_readst1_@return
    // }
    // [619] fclose::cbm_k_readst1_return#1 = fclose::cbm_k_readst1_return#0
    // fclose::@3
    // cbm_k_readst()
    // [620] fclose::$1 = fclose::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [621] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fclose::sp#0] = fclose::$1 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if (__status)
    // [622] if(0==((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fclose::sp#0]) goto fclose::@1 -- 0_eq_pbuc1_derefidx_vbuz1_then_la1 
    lda __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    cmp #0
    beq __b1
    // [623] phi from fclose::@2 fclose::@3 to fclose::@return [phi:fclose::@2/fclose::@3->fclose::@return]
  __b3:
    // [623] phi fclose::return#1 = 0 [phi:fclose::@2/fclose::@3->fclose::@return#0] -- vwsz1=vbsc1 
    lda #<0
    sta.z return
    sta.z return+1
    // fclose::@return
    // }
    // [624] return 
    rts
    // fclose::@1
  __b1:
    // cbm_k_close(__logical)
    // [625] fclose::cbm_k_close1_channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fclose::sp#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z sp
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta.z cbm_k_close1_channel
    // fclose::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // fclose::cbm_k_readst2
    // char status
    // [627] fclose::cbm_k_readst2_status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_readst2_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst2_status
    // return status;
    // [629] fclose::cbm_k_readst2_return#0 = fclose::cbm_k_readst2_status -- vbuaa=vbuz1 
    // fclose::cbm_k_readst2_@return
    // }
    // [630] fclose::cbm_k_readst2_return#1 = fclose::cbm_k_readst2_return#0
    // fclose::@4
    // cbm_k_readst()
    // [631] fclose::$4 = fclose::cbm_k_readst2_return#1
    // __status = cbm_k_readst()
    // [632] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fclose::sp#0] = fclose::$4 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if (__status)
    // [633] if(0==((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fclose::sp#0]) goto fclose::@2 -- 0_eq_pbuc1_derefidx_vbuz1_then_la1 
    lda __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    cmp #0
    beq __b2
    // [623] phi from fclose::@4 to fclose::@return [phi:fclose::@4->fclose::@return]
    // [623] phi fclose::return#1 = -1 [phi:fclose::@4->fclose::@return#0] -- vwsz1=vbsc1 
    lda #<-1
    sta.z return
    sta.z return+1
    rts
    // fclose::@2
  __b2:
    // __logical = 0
    // [634] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z sp
    sta __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    // __device = 0
    // [635] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    // __channel = 0
    // [636] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    // __filename
    // [637] fclose::$6 = fclose::sp#0 << 2 -- vbuaa=vbuz1_rol_2 
    tya
    asl
    asl
    // *__filename = '\0'
    // [638] ((char *)&__stdio_file)[fclose::$6] = '?'pm -- pbuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #'\$00'
    sta __stdio_file,y
    // __stdio_filecount--;
    // [639] __stdio_filecount = -- __stdio_filecount -- vbuz1=_dec_vbuz1 
    dec.z __stdio_filecount
    jmp __b3
}
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
// void memcpy_vram_bram(__register(X) char dbank_vram, __zp($6c) unsigned int doffset_vram, __zp($7d) char sbank_bram, __zp($73) char *sptr_bram, __zp($a8) volatile unsigned int num)
memcpy_vram_bram: {
    .label pagemask = $ff00
    .label num = $a8
    .label ptr = $a3
    .label memcpy_vram_bram__5 = $75
    .label pos = $b5
    .label len = $af
    .label memcpy_vram_bram__27 = $75
    .label bank_set_bram2_bank = $7d
    .label bank_set_bram3_bank = $7d
    .label doffset_vram = $6c
    .label sbank_bram = $7d
    .label sptr_bram = $73
    .label bank = $b0
    // memcpy_vram_bram::bank_get_bram1
    // return BRAM;
    // [641] memcpy_vram_bram::bank#10 = BRAM -- vbuz1=vbuz2 
    lda.z BRAM
    sta.z bank
    // memcpy_vram_bram::bank_set_bram1
    // BRAM = bank
    // [642] BRAM = memcpy_vram_bram::sbank_bram#2 -- vbuz1=vbuz2 
    lda.z sbank_bram
    sta.z BRAM
    // memcpy_vram_bram::@12
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [643] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [644] memcpy_vram_bram::$2 = byte0  memcpy_vram_bram::doffset_vram#0 -- vbuaa=_byte0_vwuz1 
    lda.z doffset_vram
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [645] *VERA_ADDRX_L = memcpy_vram_bram::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [646] memcpy_vram_bram::$3 = byte1  memcpy_vram_bram::doffset_vram#0 -- vbuaa=_byte1_vwuz1 
    lda.z doffset_vram+1
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [647] *VERA_ADDRX_M = memcpy_vram_bram::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // dbank_vram | VERA_INC_1
    // [648] memcpy_vram_bram::$4 = memcpy_vram_bram::dbank_vram#0 | VERA_INC_1 -- vbuaa=vbuxx_bor_vbuc1 
    txa
    ora #VERA_INC_1
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [649] *VERA_ADDRX_H = memcpy_vram_bram::$4 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // (unsigned int)sptr_bram & (unsigned int)pagemask
    // [650] memcpy_vram_bram::$5 = (unsigned int)memcpy_vram_bram::sptr_bram#0 & (unsigned int)memcpy_vram_bram::pagemask -- vwuz1=vwuz2_band_vwuc1 
    lda.z sptr_bram
    and #<pagemask
    sta.z memcpy_vram_bram__5
    lda.z sptr_bram+1
    and #>pagemask
    sta.z memcpy_vram_bram__5+1
    // bram_ptr_t ptr = (bram_ptr_t)((unsigned int)sptr_bram & (unsigned int)pagemask)
    // [651] memcpy_vram_bram::ptr = (char *)memcpy_vram_bram::$5 -- pbuz1=pbuz2 
    // Set the page boundary.
    lda.z memcpy_vram_bram__5
    sta.z ptr
    lda.z memcpy_vram_bram__5+1
    sta.z ptr+1
    // unsigned char pos = BYTE0(sptr_bram)
    // [652] memcpy_vram_bram::pos = byte0  memcpy_vram_bram::sptr_bram#0 -- vbuz1=_byte0_pbuz2 
    lda.z sptr_bram
    sta.z pos
    // BYTE0(sptr_bram)
    // [653] memcpy_vram_bram::$7 = byte0  memcpy_vram_bram::sptr_bram#0 -- vbuaa=_byte0_pbuz1 
    lda.z sptr_bram
    // unsigned char len = -BYTE0(sptr_bram)
    // [654] memcpy_vram_bram::len = - memcpy_vram_bram::$7 -- vbuz1=_neg_vbuaa 
    eor #$ff
    clc
    adc #1
    sta.z len
    // num <= (unsigned int)len
    // [655] memcpy_vram_bram::$27 = (unsigned int)memcpy_vram_bram::len -- vwuz1=_word_vbuz2 
    sta.z memcpy_vram_bram__27
    lda #0
    sta.z memcpy_vram_bram__27+1
    // if (num <= (unsigned int)len)
    // [656] if(memcpy_vram_bram::num>memcpy_vram_bram::$27) goto memcpy_vram_bram::@1 -- vwuz1_gt_vwuz2_then_la1 
    cmp.z num+1
    bcc __b1
    bne !+
    lda.z memcpy_vram_bram__27
    cmp.z num
    bcc __b1
  !:
    // memcpy_vram_bram::@5
    // BYTE0(num)
    // [657] memcpy_vram_bram::$11 = byte0  memcpy_vram_bram::num -- vbuaa=_byte0_vwuz1 
    lda.z num
    // len = BYTE0(num)
    // [658] memcpy_vram_bram::len = memcpy_vram_bram::$11 -- vbuz1=vbuaa 
    sta.z len
    // memcpy_vram_bram::@1
  __b1:
    // if (len)
    // [659] if(0==memcpy_vram_bram::len) goto memcpy_vram_bram::@2 -- 0_eq_vbuz1_then_la1 
    lda.z len
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
    // [661] memcpy_vram_bram::ptr = memcpy_vram_bram::ptr + $100 -- pbuz1=pbuz1_plus_vwuc1 
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
    // [662] memcpy_vram_bram::num = memcpy_vram_bram::num - memcpy_vram_bram::len -- vwuz1=vwuz1_minus_vbuz2 
    sec
    lda.z num
    sbc.z len
    sta.z num
    bcs !+
    dec.z num+1
  !:
    // memcpy_vram_bram::@2
  __b2:
    // BYTE1(ptr)
    // [663] memcpy_vram_bram::$13 = byte1  memcpy_vram_bram::ptr -- vbuaa=_byte1_pbuz1 
    lda.z ptr+1
    // if (BYTE1(ptr) == 0xC0)
    // [664] if(memcpy_vram_bram::$13!=$c0) goto memcpy_vram_bram::@3 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$c0
    bne __b3
    // memcpy_vram_bram::@7
    // ptr = (unsigned char *)0xA000
    // [665] memcpy_vram_bram::ptr = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z ptr
    lda #>$a000
    sta.z ptr+1
    // bank_set_bram(++sbank_bram);
    // [666] memcpy_vram_bram::bank_set_bram2_bank#0 = ++ memcpy_vram_bram::sbank_bram#2 -- vbuz1=_inc_vbuz1 
    inc.z bank_set_bram2_bank
    // memcpy_vram_bram::bank_set_bram2
    // BRAM = bank
    // [667] BRAM = memcpy_vram_bram::bank_set_bram2_bank#0 -- vbuz1=vbuz2 
    lda.z bank_set_bram2_bank
    sta.z BRAM
    // [668] phi from memcpy_vram_bram::@2 memcpy_vram_bram::bank_set_bram2 to memcpy_vram_bram::@3 [phi:memcpy_vram_bram::@2/memcpy_vram_bram::bank_set_bram2->memcpy_vram_bram::@3]
    // [668] phi memcpy_vram_bram::sbank_bram#13 = memcpy_vram_bram::sbank_bram#2 [phi:memcpy_vram_bram::@2/memcpy_vram_bram::bank_set_bram2->memcpy_vram_bram::@3#0] -- register_copy 
    // memcpy_vram_bram::@3
  __b3:
    // BYTE1(num)
    // [669] memcpy_vram_bram::$16 = byte1  memcpy_vram_bram::num -- vbuaa=_byte1_vwuz1 
    lda.z num+1
    // if (BYTE1(num))
    // [670] if(0==memcpy_vram_bram::$16) goto memcpy_vram_bram::@4 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b4
    // [671] phi from memcpy_vram_bram::@10 memcpy_vram_bram::@3 to memcpy_vram_bram::@9 [phi:memcpy_vram_bram::@10/memcpy_vram_bram::@3->memcpy_vram_bram::@9]
    // [671] phi memcpy_vram_bram::sbank_bram#5 = memcpy_vram_bram::sbank_bram#12 [phi:memcpy_vram_bram::@10/memcpy_vram_bram::@3->memcpy_vram_bram::@9#0] -- register_copy 
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
    // [673] memcpy_vram_bram::ptr = memcpy_vram_bram::ptr + $100 -- pbuz1=pbuz1_plus_vwuc1 
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
    // [674] memcpy_vram_bram::$21 = byte1  memcpy_vram_bram::ptr -- vbuaa=_byte1_pbuz1 
    // if (BYTE1(ptr) == 0xC0)
    // [675] if(memcpy_vram_bram::$21!=$c0) goto memcpy_vram_bram::@10 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$c0
    bne __b10
    // memcpy_vram_bram::@11
    // ptr = (unsigned char *)0xA000
    // [676] memcpy_vram_bram::ptr = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z ptr
    lda #>$a000
    sta.z ptr+1
    // bank_set_bram(++sbank_bram);
    // [677] memcpy_vram_bram::bank_set_bram3_bank#0 = ++ memcpy_vram_bram::sbank_bram#5 -- vbuz1=_inc_vbuz1 
    inc.z bank_set_bram3_bank
    // memcpy_vram_bram::bank_set_bram3
    // BRAM = bank
    // [678] BRAM = memcpy_vram_bram::bank_set_bram3_bank#0 -- vbuz1=vbuz2 
    lda.z bank_set_bram3_bank
    sta.z BRAM
    // [679] phi from memcpy_vram_bram::@9 memcpy_vram_bram::bank_set_bram3 to memcpy_vram_bram::@10 [phi:memcpy_vram_bram::@9/memcpy_vram_bram::bank_set_bram3->memcpy_vram_bram::@10]
    // [679] phi memcpy_vram_bram::sbank_bram#12 = memcpy_vram_bram::sbank_bram#5 [phi:memcpy_vram_bram::@9/memcpy_vram_bram::bank_set_bram3->memcpy_vram_bram::@10#0] -- register_copy 
    // memcpy_vram_bram::@10
  __b10:
    // num -= 256
    // [680] memcpy_vram_bram::num = memcpy_vram_bram::num - $100 -- vwuz1=vwuz1_minus_vwuc1 
    lda.z num
    sec
    sbc #<$100
    sta.z num
    lda.z num+1
    sbc #>$100
    sta.z num+1
    // BYTE1(num)
    // [681] memcpy_vram_bram::$25 = byte1  memcpy_vram_bram::num -- vbuaa=_byte1_vwuz1 
    // while (BYTE1(num))
    // [682] if(0!=memcpy_vram_bram::$25) goto memcpy_vram_bram::@9 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b9
    // memcpy_vram_bram::@4
  __b4:
    // if (num)
    // [683] if(0==memcpy_vram_bram::num) goto memcpy_vram_bram::bank_set_bram4 -- 0_eq_vwuz1_then_la1 
    lda.z num
    ora.z num+1
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
    // [685] BRAM = memcpy_vram_bram::bank#10 -- vbuz1=vbuz2 
    lda.z bank
    sta.z BRAM
    // memcpy_vram_bram::@return
    // }
    // [686] return 
    rts
}
.segment CodeEngineFlight
  // flight_sprite_free_offset
// void flight_sprite_free_offset(__zp($b1) unsigned int sprite_offset)
flight_sprite_free_offset: {
    .label vera_sprite_get_id1_flight_sprite_free_offset__0 = $79
    .label vera_sprite_get_id1_flight_sprite_free_offset__1 = $79
    .label sprite_offset = $b1
    // flight_sprite_free_offset::vera_sprite_get_id1
    // sprite_offset - WORD0(VERA_SPRITE_ATTR)
    // [688] flight_sprite_free_offset::vera_sprite_get_id1_$0 = flight_sprite_free_offset::sprite_offset#0 - word0 VERA_SPRITE_ATTR -- vwuz1=vwuz2_minus_vwuc1 
    sec
    lda.z sprite_offset
    sbc #<VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_get_id1_flight_sprite_free_offset__0
    lda.z sprite_offset+1
    sbc #>VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_get_id1_flight_sprite_free_offset__0+1
    // (sprite_offset - WORD0(VERA_SPRITE_ATTR)) >> 3
    // [689] flight_sprite_free_offset::vera_sprite_get_id1_$1 = flight_sprite_free_offset::vera_sprite_get_id1_$0 >> 3 -- vwuz1=vwuz1_ror_3 
    lsr.z vera_sprite_get_id1_flight_sprite_free_offset__1+1
    ror.z vera_sprite_get_id1_flight_sprite_free_offset__1
    lsr.z vera_sprite_get_id1_flight_sprite_free_offset__1+1
    ror.z vera_sprite_get_id1_flight_sprite_free_offset__1
    lsr.z vera_sprite_get_id1_flight_sprite_free_offset__1+1
    ror.z vera_sprite_get_id1_flight_sprite_free_offset__1
    // BYTE0((sprite_offset - WORD0(VERA_SPRITE_ATTR)) >> 3)
    // [690] flight_sprite_free_offset::vera_sprite_get_id1_return#0 = byte0  flight_sprite_free_offset::vera_sprite_get_id1_$1 -- vbuaa=_byte0_vwuz1 
    lda.z vera_sprite_get_id1_flight_sprite_free_offset__1
    // flight_sprite_free_offset::@1
    // flight_sprite_offsets[sprite_id] = 0
    // [691] flight_sprite_free_offset::$1 = flight_sprite_free_offset::vera_sprite_get_id1_return#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [692] flight_sprite_offsets[flight_sprite_free_offset::$1] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta flight_sprite_offsets,y
    sta flight_sprite_offsets+1,y
    // flight_sprite_free_offset::@return
    // }
    // [693] return 
    rts
}
  // fe_sprite_cache_free
// void fe_sprite_cache_free(__register(X) char fe_sprite_index)
fe_sprite_cache_free: {
    // sprite_cache.used[fe_sprite_index]--;
    // [694] ((char *)&sprite_cache)[fe_sprite_cache_free::fe_sprite_index#0] = -- ((char *)&sprite_cache)[fe_sprite_cache_free::fe_sprite_index#0] -- pbuc1_derefidx_vbuxx=_dec_pbuc1_derefidx_vbuxx 
    dec equinoxe_flightengine.sprite_cache,x
    // fe_sprite_cache_free::@return
    // }
    // [695] return 
    rts
}
  // fe_sprite_cache_copy
// todo, need to detach vram allocation from cache management.
// __register(A) char fe_sprite_cache_copy(__zp($c4) char sprite_index)
fe_sprite_cache_copy: {
    .const bank_push_set_bram1_bank = 4
    .label fe_sprite_cache_copy__19 = $c3
    .label sprite_index = $c4
    .label c = $a2
    .label co = $d7
    // fe_sprite_cache_copy::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [698] BRAM = fe_sprite_cache_copy::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // fe_sprite_cache_copy::@7
    // unsigned char c = sprites.sprite_cache[sprite_index]
    // [699] fe_sprite_cache_copy::c#0 = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE)[fe_sprite_cache_copy::sprite_index#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE,y
    sta.z c
    // sprite_index_t cache_bram = (sprite_index_t)sprite_cache.sprite_bram[c]
    // [700] fe_sprite_cache_copy::cache_bram#0 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SPRITE_BRAM)[fe_sprite_cache_copy::c#0] -- vbuaa=pbuc1_derefidx_vbuz1 
    tay
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SPRITE_BRAM,y
    // if (cache_bram != sprite_index)
    // [701] if(fe_sprite_cache_copy::cache_bram#0==fe_sprite_cache_copy::sprite_index#0) goto fe_sprite_cache_copy::@1 -- vbuaa_eq_vbuz1_then_la1 
    cmp.z sprite_index
    bne !__b1+
    jmp __b1
  !__b1:
    // fe_sprite_cache_copy::@2
    // if (sprite_cache.used[c])
    // [702] if(0==((char *)&sprite_cache)[fe_sprite_cache_copy::c#0]) goto fe_sprite_cache_copy::@3 -- 0_eq_pbuc1_derefidx_vbuz1_then_la1 
    lda equinoxe_flightengine.sprite_cache,y
    cmp #0
    beq __b3
    // fe_sprite_cache_copy::@4
  __b4:
    // while (sprite_cache.used[sprite_cache_pool])
    // [703] if(0!=((char *)&sprite_cache)[sprite_cache_pool]) goto fe_sprite_cache_copy::@5 -- 0_neq_pbuc1_derefidx_vbuz1_then_la1 
    ldy.z sprite_cache_pool
    lda equinoxe_flightengine.sprite_cache,y
    cmp #0
    beq !__b5+
    jmp __b5
  !__b5:
    // fe_sprite_cache_copy::@6
    // c = sprite_cache_pool
    // [704] fe_sprite_cache_copy::c#1 = sprite_cache_pool -- vbuz1=vbuz2 
    tya
    sta.z c
    // [705] phi from fe_sprite_cache_copy::@2 fe_sprite_cache_copy::@6 to fe_sprite_cache_copy::@3 [phi:fe_sprite_cache_copy::@2/fe_sprite_cache_copy::@6->fe_sprite_cache_copy::@3]
    // [705] phi fe_sprite_cache_copy::c#5 = fe_sprite_cache_copy::c#0 [phi:fe_sprite_cache_copy::@2/fe_sprite_cache_copy::@6->fe_sprite_cache_copy::@3#0] -- register_copy 
    // fe_sprite_cache_copy::@3
  __b3:
    // unsigned char co = c * FE_CACHE
    // [706] fe_sprite_cache_copy::co#0 = fe_sprite_cache_copy::c#5 << 4 -- vbuz1=vbuz2_rol_4 
    lda.z c
    asl
    asl
    asl
    asl
    sta.z co
    // sprites.sprite_cache[sprite_index] = c
    // [707] ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE)[fe_sprite_cache_copy::sprite_index#0] = fe_sprite_cache_copy::c#5 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z c
    ldy.z sprite_index
    sta sprites+OFFSET_STRUCT_SPRITE_T_SPRITE_CACHE,y
    // sprite_cache.sprite_bram[c] = sprite_index
    // [708] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SPRITE_BRAM)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::sprite_index#0 -- pbuc1_derefidx_vbuz1=vbuz2 
    tya
    ldy.z c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SPRITE_BRAM,y
    // sprite_cache.count[c] = sprites.count[sprite_index]
    // [709] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_COUNT)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2 
    tay
    lda sprites+OFFSET_STRUCT_SPRITE_T_COUNT,y
    ldy.z c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT,y
    // sprite_cache.offset[c] = sprites.offset[sprite_index]
    // [710] fe_sprite_cache_copy::$19 = fe_sprite_cache_copy::sprite_index#0 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z sprite_index
    asl
    sta.z fe_sprite_cache_copy__19
    // [711] fe_sprite_cache_copy::$18 = fe_sprite_cache_copy::c#5 << 1 -- vbuxx=vbuz1_rol_1 
    tya
    asl
    tax
    // [712] ((unsigned int *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET)[fe_sprite_cache_copy::$18] = ((unsigned int *)&sprites+OFFSET_STRUCT_SPRITE_T_OFFSET)[fe_sprite_cache_copy::$19] -- pwuc1_derefidx_vbuxx=pwuc2_derefidx_vbuz1 
    ldy.z fe_sprite_cache_copy__19
    lda sprites+OFFSET_STRUCT_SPRITE_T_OFFSET,y
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET,x
    lda sprites+OFFSET_STRUCT_SPRITE_T_OFFSET+1,y
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_OFFSET+1,x
    // sprite_cache.size[c] = sprites.SpriteSize[sprite_index]
    // [713] ((unsigned int *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE)[fe_sprite_cache_copy::$18] = ((unsigned int *)&sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE)[fe_sprite_cache_copy::$19] -- pwuc1_derefidx_vbuxx=pwuc2_derefidx_vbuz1 
    lda sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE,y
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE,x
    lda sprites+OFFSET_STRUCT_SPRITE_T_SPRITESIZE+1,y
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_SIZE+1,x
    // sprite_cache.zdepth[c] = sprites.Zdepth[sprite_index]
    // [714] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_ZDEPTH)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_ZDEPTH)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2 
    ldy.z sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_ZDEPTH,y
    ldy.z c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_ZDEPTH,y
    // sprite_cache.bpp[c] = sprites.BPP[sprite_index]
    // [715] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_BPP)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_BPP)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2 
    ldy.z sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_BPP,y
    ldy.z c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_BPP,y
    // sprite_cache.height[c] = sprites.Height[sprite_index]
    // [716] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HEIGHT)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_HEIGHT)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2 
    ldy.z sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_HEIGHT,y
    ldy.z c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HEIGHT,y
    // sprite_cache.width[c] = sprites.Width[sprite_index]
    // [717] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_WIDTH)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_WIDTH)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2 
    ldy.z sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_WIDTH,y
    ldy.z c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_WIDTH,y
    // sprite_cache.hflip[c] = sprites.Hflip[sprite_index]
    // [718] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HFLIP)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_HFLIP)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2 
    ldy.z sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_HFLIP,y
    ldy.z c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HFLIP,y
    // sprite_cache.vflip[c] = sprites.Vflip[sprite_index]
    // [719] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_VFLIP)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_VFLIP)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2 
    ldy.z sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_VFLIP,y
    ldy.z c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_VFLIP,y
    // sprite_cache.reverse[c] = sprites.reverse[sprite_index]
    // [720] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_REVERSE)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_REVERSE)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2 
    ldy.z sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_REVERSE,y
    ldy.z c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_REVERSE,y
    // sprite_cache.palette_offset[c] = sprites.PaletteOffset[sprite_index]
    // [721] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2 
    ldy.z sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_PALETTEOFFSET,y
    ldy.z c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET,y
    // sprite_cache.loop[c] = sprites.loop[sprite_index]
    // [722] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_LOOP)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+OFFSET_STRUCT_SPRITE_T_LOOP)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbuz1=pbuc2_derefidx_vbuz2 
    ldy.z sprite_index
    lda sprites+OFFSET_STRUCT_SPRITE_T_LOOP,y
    ldy.z c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_LOOP,y
    // strcpy(&sprite_cache.file[co], sprites.file[sprite_index])
    // [723] strcpy::destination#0 = (char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_FILE + fe_sprite_cache_copy::co#0 -- pbuz1=pbuc1_plus_vbuz2 
    lda.z co
    clc
    adc #<equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_FILE
    sta.z strcpy.destination
    lda #>equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_FILE
    adc #0
    sta.z strcpy.destination+1
    // [724] strcpy::source#0 = ((char **)&sprites)[fe_sprite_cache_copy::$19] -- pbuz1=qbuc1_derefidx_vbuz2 
    ldy.z fe_sprite_cache_copy__19
    lda sprites,y
    sta.z strcpy.source
    lda sprites+1,y
    sta.z strcpy.source+1
    // [725] call strcpy
    // [404] phi from fe_sprite_cache_copy::@3 to strcpy [phi:fe_sprite_cache_copy::@3->strcpy]
    // [404] phi strcpy::dst#0 = strcpy::destination#0 [phi:fe_sprite_cache_copy::@3->strcpy#0] -- register_copy 
    // [404] phi strcpy::src#0 = strcpy::source#0 [phi:fe_sprite_cache_copy::@3->strcpy#1] -- register_copy 
    jsr strcpy
    // fe_sprite_cache_copy::@8
    // sprites.aabb[sprite_index].xmin >> 2
    // [726] fe_sprite_cache_copy::$21 = fe_sprite_cache_copy::sprite_index#0 << 2 -- vbuxx=vbuz1_rol_2 
    lda.z sprite_index
    asl
    asl
    tax
    // [727] fe_sprite_cache_copy::$11 = ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB)[fe_sprite_cache_copy::$21] >> 2 -- vbuaa=pbuc1_derefidx_vbuxx_ror_2 
    lda sprites+OFFSET_STRUCT_SPRITE_T_AABB,x
    lsr
    lsr
    // sprite_cache.xmin[c] = sprites.aabb[sprite_index].xmin >> 2
    // [728] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMIN)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$11 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z c
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMIN,y
    // sprites.aabb[sprite_index].ymin >> 2
    // [729] fe_sprite_cache_copy::$12 = ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMIN)[fe_sprite_cache_copy::$21] >> 2 -- vbuaa=pbuc1_derefidx_vbuxx_ror_2 
    lda sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMIN,x
    lsr
    lsr
    // sprite_cache.ymin[c] = sprites.aabb[sprite_index].ymin >> 2
    // [730] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMIN)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$12 -- pbuc1_derefidx_vbuz1=vbuaa 
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMIN,y
    // sprites.aabb[sprite_index].xmax >> 2
    // [731] fe_sprite_cache_copy::$13 = ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_XMAX)[fe_sprite_cache_copy::$21] >> 2 -- vbuaa=pbuc1_derefidx_vbuxx_ror_2 
    lda sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_XMAX,x
    lsr
    lsr
    // sprite_cache.xmax[c] = sprites.aabb[sprite_index].xmax >> 2
    // [732] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMAX)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$13 -- pbuc1_derefidx_vbuz1=vbuaa 
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMAX,y
    // sprites.aabb[sprite_index].ymax >> 2
    // [733] fe_sprite_cache_copy::$14 = ((char *)(aabb_t *)&sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMAX)[fe_sprite_cache_copy::$21] >> 2 -- vbuaa=pbuc1_derefidx_vbuxx_ror_2 
    lda sprites+OFFSET_STRUCT_SPRITE_T_AABB+OFFSET_STRUCT_AABB_T_YMAX,x
    lsr
    lsr
    // sprite_cache.ymax[c] = sprites.aabb[sprite_index].ymax >> 2
    // [734] ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMAX)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$14 -- pbuc1_derefidx_vbuz1=vbuaa 
    sta equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMAX,y
    // [735] phi from fe_sprite_cache_copy::@7 fe_sprite_cache_copy::@8 to fe_sprite_cache_copy::@1 [phi:fe_sprite_cache_copy::@7/fe_sprite_cache_copy::@8->fe_sprite_cache_copy::@1]
    // [735] phi fe_sprite_cache_copy::c#2 = fe_sprite_cache_copy::c#0 [phi:fe_sprite_cache_copy::@7/fe_sprite_cache_copy::@8->fe_sprite_cache_copy::@1#0] -- register_copy 
    // fe_sprite_cache_copy::@1
  __b1:
    // sprite_cache.used[c]++;
    // [736] ((char *)&sprite_cache)[fe_sprite_cache_copy::c#2] = ++ ((char *)&sprite_cache)[fe_sprite_cache_copy::c#2] -- pbuc1_derefidx_vbuz1=_inc_pbuc1_derefidx_vbuz1 
    ldx.z c
    inc equinoxe_flightengine.sprite_cache,x
    // fe_sprite_cache_copy::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_cache_copy::@return
    // }
    // [738] return 
    rts
    // fe_sprite_cache_copy::@5
  __b5:
    // sprite_cache_pool + 1
    // [739] fe_sprite_cache_copy::$6 = sprite_cache_pool + 1 -- vbuaa=vbuz1_plus_1 
    lda.z sprite_cache_pool
    inc
    // (sprite_cache_pool + 1) % FE_CACHE
    // [740] fe_sprite_cache_copy::$7 = fe_sprite_cache_copy::$6 & FE_CACHE-1 -- vbuaa=vbuaa_band_vbuc1 
    and #FE_CACHE-1
    // sprite_cache_pool = (sprite_cache_pool + 1) % FE_CACHE
    // [741] sprite_cache_pool = fe_sprite_cache_copy::$7 -- vbuz1=vbuaa 
    sta.z sprite_cache_pool
    jmp __b4
}
  // flight_sprite_next_offset
//     char x =  (i / 32) * 16;
//     char y = i % 32;
//     gotoxy(x, y);
//     printf("i:%02x n:%02x p:%02x t:%01x", i, flight.next[i], flight.prev[i], flight.type[i]);
// }
// __zp($ad) unsigned int flight_sprite_next_offset()
flight_sprite_next_offset: {
    .label vera_sprite_get_offset1_flight_sprite_next_offset__0 = $79
    .label vera_sprite_get_offset1_flight_sprite_next_offset__2 = $79
    .label return = $ad
    .label vera_sprite_get_offset1_return = $79
    // flight_sprite_next_offset::@1
  __b1:
    // !flight_sprite_offset_pool || flight_sprite_offsets[flight_sprite_offset_pool]
    // [743] flight_sprite_next_offset::$5 = flight_sprite_offset_pool << 1 -- vbuxx=vbuz1_rol_1 
    lda.z flight_sprite_offset_pool
    asl
    tax
    // while (!flight_sprite_offset_pool || flight_sprite_offsets[flight_sprite_offset_pool])
    // [744] if(0==flight_sprite_offset_pool) goto flight_sprite_next_offset::@2 -- 0_eq_vbuz1_then_la1 
    lda.z flight_sprite_offset_pool
    beq __b2
    // flight_sprite_next_offset::@5
    // [745] if(0!=flight_sprite_offsets[flight_sprite_next_offset::$5]) goto flight_sprite_next_offset::@2 -- 0_neq_pwuc1_derefidx_vbuxx_then_la1 
    lda flight_sprite_offsets+1,x
    ora flight_sprite_offsets,x
    bne __b2
    // flight_sprite_next_offset::@3
    // vera_sprite_offset sprite_offset = vera_sprite_get_offset(flight_sprite_offset_pool)
    // [746] flight_sprite_next_offset::vera_sprite_get_offset1_sprite_id#0 = flight_sprite_offset_pool -- vbuaa=vbuz1 
    lda.z flight_sprite_offset_pool
    // flight_sprite_next_offset::vera_sprite_get_offset1
    // ((unsigned int)sprite_id) << 3
    // [747] flight_sprite_next_offset::vera_sprite_get_offset1_$2 = (unsigned int)flight_sprite_next_offset::vera_sprite_get_offset1_sprite_id#0 -- vwuz1=_word_vbuaa 
    sta.z vera_sprite_get_offset1_flight_sprite_next_offset__2
    lda #0
    sta.z vera_sprite_get_offset1_flight_sprite_next_offset__2+1
    // [748] flight_sprite_next_offset::vera_sprite_get_offset1_$0 = flight_sprite_next_offset::vera_sprite_get_offset1_$2 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_get_offset1_flight_sprite_next_offset__0
    rol.z vera_sprite_get_offset1_flight_sprite_next_offset__0+1
    asl.z vera_sprite_get_offset1_flight_sprite_next_offset__0
    rol.z vera_sprite_get_offset1_flight_sprite_next_offset__0+1
    asl.z vera_sprite_get_offset1_flight_sprite_next_offset__0
    rol.z vera_sprite_get_offset1_flight_sprite_next_offset__0+1
    // WORD0(VERA_SPRITE_ATTR)+(((unsigned int)sprite_id) << 3)
    // [749] flight_sprite_next_offset::vera_sprite_get_offset1_return#0 = word0 VERA_SPRITE_ATTR + flight_sprite_next_offset::vera_sprite_get_offset1_$0 -- vwuz1=vwuc1_plus_vwuz1 
    lda.z vera_sprite_get_offset1_return
    clc
    adc #<VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_get_offset1_return
    lda.z vera_sprite_get_offset1_return+1
    adc #>VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_get_offset1_return+1
    // flight_sprite_next_offset::@4
    // flight_sprite_offsets[flight_sprite_offset_pool] = sprite_offset
    // [750] flight_sprite_next_offset::$6 = flight_sprite_offset_pool << 1 -- vbuaa=vbuz1_rol_1 
    lda.z flight_sprite_offset_pool
    asl
    // [751] flight_sprite_offsets[flight_sprite_next_offset::$6] = flight_sprite_next_offset::vera_sprite_get_offset1_return#0 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z vera_sprite_get_offset1_return
    sta flight_sprite_offsets,y
    lda.z vera_sprite_get_offset1_return+1
    sta flight_sprite_offsets+1,y
    // flight_sprite_next_offset::@return
    // }
    // [752] return 
    rts
    // flight_sprite_next_offset::@2
  __b2:
    // flight_sprite_offset_pool + 1
    // [753] flight_sprite_next_offset::$3 = flight_sprite_offset_pool + 1 -- vbuaa=vbuz1_plus_1 
    lda.z flight_sprite_offset_pool
    inc
    // (flight_sprite_offset_pool + 1) % 128
    // [754] flight_sprite_next_offset::$4 = flight_sprite_next_offset::$3 & $80-1 -- vbuaa=vbuaa_band_vbuc1 
    and #$80-1
    // flight_sprite_offset_pool = (flight_sprite_offset_pool + 1) % 128
    // [755] flight_sprite_offset_pool = flight_sprite_next_offset::$4 -- vbuz1=vbuaa 
    sta.z flight_sprite_offset_pool
    jmp __b1
}
  // fe_sprite_configure
// void fe_sprite_configure(__zp($ad) unsigned int sprite_offset, __register(Y) char s)
fe_sprite_configure: {
    .const vera_sprite_bpp1_vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    .const vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    .label sprite_offset = $ad
    .label vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset = $7b
    .label vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset = $73
    // vera_sprite_bpp(sprite_offset, sprite_cache.bpp[s])
    // [756] fe_sprite_configure::vera_sprite_bpp1_bpp#0 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_BPP)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_BPP,y
    // fe_sprite_configure::vera_sprite_bpp1
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+1, vera_inc_0)
    // [757] fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset#0 = fe_sprite_configure::sprite_offset#0 + 1 -- vwuz1=vwuz2_plus_1 
    clc
    lda.z sprite_offset
    adc #1
    sta.z vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset
    lda.z sprite_offset+1
    adc #0
    sta.z vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset+1
    // fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [758] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [759] fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$0 = byte0  fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwuz1 
    lda.z vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [760] *VERA_ADDRX_L = fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [761] fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$1 = byte1  fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwuz1 
    lda.z vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [762] *VERA_ADDRX_M = fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [763] *VERA_ADDRX_H = fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_sprite_bpp1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // fe_sprite_configure::vera_sprite_bpp1_@1
    // *VERA_DATA0 & ~VERA_SPRITE_8BPP
    // [764] fe_sprite_configure::vera_sprite_bpp1_$2 = *VERA_DATA0 & ~$80 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$80^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_8BPP
    // [765] *VERA_DATA0 = fe_sprite_configure::vera_sprite_bpp1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= bpp
    // [766] *VERA_DATA0 = *VERA_DATA0 | fe_sprite_configure::vera_sprite_bpp1_bpp#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // fe_sprite_configure::@1
    // vera_sprite_height(sprite_offset, sprite_cache.height[s])
    // [767] vera_sprite_height::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwuz1=vwuz2 
    lda.z sprite_offset
    sta.z vera_sprite_height.sprite_offset
    lda.z sprite_offset+1
    sta.z vera_sprite_height.sprite_offset+1
    // [768] vera_sprite_height::height#0 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HEIGHT)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HEIGHT,y
    // [769] call vera_sprite_height
    jsr vera_sprite_height
    // fe_sprite_configure::@2
    // vera_sprite_width(sprite_offset, sprite_cache.width[s])
    // [770] vera_sprite_width::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwuz1=vwuz2 
    lda.z sprite_offset
    sta.z vera_sprite_width.sprite_offset
    lda.z sprite_offset+1
    sta.z vera_sprite_width.sprite_offset+1
    // [771] vera_sprite_width::width#0 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_WIDTH)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_WIDTH,y
    // [772] call vera_sprite_width
    jsr vera_sprite_width
    // fe_sprite_configure::@3
    // vera_sprite_hflip(sprite_offset, sprite_cache.hflip[s])
    // [773] vera_sprite_hflip::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwuz1=vwuz2 
    lda.z sprite_offset
    sta.z vera_sprite_hflip.sprite_offset
    lda.z sprite_offset+1
    sta.z vera_sprite_hflip.sprite_offset+1
    // [774] vera_sprite_hflip::hflip#0 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HFLIP)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_HFLIP,y
    // [775] call vera_sprite_hflip
    jsr vera_sprite_hflip
    // fe_sprite_configure::@4
    // vera_sprite_vflip(sprite_offset, sprite_cache.vflip[s])
    // [776] vera_sprite_vflip::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwuz1=vwuz2 
    lda.z sprite_offset
    sta.z vera_sprite_vflip.sprite_offset
    lda.z sprite_offset+1
    sta.z vera_sprite_vflip.sprite_offset+1
    // [777] vera_sprite_vflip::vflip#0 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_VFLIP)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_VFLIP,y
    // [778] call vera_sprite_vflip
    jsr vera_sprite_vflip
    // fe_sprite_configure::@5
    // palette_use_vram(sprite_cache.palette_offset[s])
    // [779] palette_use_vram::palette_index = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET)[fe_sprite_configure::s#0] -- vbuz1=pbuc1_derefidx_vbuyy 
    lda equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_PALETTE_OFFSET,y
    sta.z equinoxe_palette.palette_use_vram.palette_index
    // [780] callexecute palette_use_vram  -- call_var_near 
    jsr equinoxe_palette.palette_use_vram
    // vera_sprite_palette_offset(sprite_offset, palette_use_vram(sprite_cache.palette_offset[s]))
    // [781] fe_sprite_configure::vera_sprite_palette_offset1_palette_offset#0 = palette_use_vram::return -- vbuxx=vbuz1 
    ldx.z equinoxe_palette.palette_use_vram.return
    // fe_sprite_configure::vera_sprite_palette_offset1
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0)
    // [782] fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset#0 = fe_sprite_configure::sprite_offset#0 + 7 -- vwuz1=vwuz2_plus_vbuc1 
    lda #7
    clc
    adc.z sprite_offset
    sta.z vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset
    lda #0
    adc.z sprite_offset+1
    sta.z vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset+1
    // fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [783] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [784] fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$0 = byte0  fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwuz1 
    lda.z vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [785] *VERA_ADDRX_L = fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [786] fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$1 = byte1  fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwuz1 
    lda.z vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [787] *VERA_ADDRX_M = fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [788] *VERA_ADDRX_H = fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // fe_sprite_configure::vera_sprite_palette_offset1_@1
    // *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK
    // [789] fe_sprite_configure::vera_sprite_palette_offset1_$2 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_PALETTE_OFFSET_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK
    // [790] *VERA_DATA0 = fe_sprite_configure::vera_sprite_palette_offset1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= palette_offset
    // [791] *VERA_DATA0 = *VERA_DATA0 | fe_sprite_configure::vera_sprite_palette_offset1_palette_offset#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // fe_sprite_configure::@return
    // }
    // [792] return 
    rts
}
.segment Code
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __zp($6c) unsigned int strlen(__zp($75) char *str)
strlen: {
    .label return = $6c
    .label len = $6c
    .label str = $75
    // [794] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [794] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z len
    sta.z len+1
    // [794] phi strlen::str#4 = strlen::str#6 [phi:strlen->strlen::@1#1] -- register_copy 
    // strlen::@1
  __b1:
    // while(*str)
    // [795] if(0!=*strlen::str#4) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [796] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [797] strlen::len#1 = ++ strlen::len#2 -- vwuz1=_inc_vwuz1 
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    // [798] strlen::str#1 = ++ strlen::str#4 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [794] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [794] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [794] phi strlen::str#4 = strlen::str#1 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
}
  // cbm_k_setlfs
/**
 * @brief Sets the logical file channel.
 *
 * @param channel the logical file number.
 * @param device the device number.
 * @param command the command.
 */
// void cbm_k_setlfs(__zp($c8) volatile char channel, __zp($c7) volatile char device, __zp($bd) volatile char command)
cbm_k_setlfs: {
    .label channel = $c8
    .label device = $c7
    .label command = $bd
    // asm
    // asm { ldxdevice ldachannel ldycommand jsrCBM_SETLFS  }
    ldx device
    lda channel
    ldy command
    jsr CBM_SETLFS
    // cbm_k_setlfs::@return
    // }
    // [800] return 
    rts
}
  // ferror
/**
 * @brief POSIX equivalent of ferror for the CBM C language.
 * This routine reads from secondary 15 the error message from the device!
 * The result is an error string, including the error code, message, track, sector.
 * The error string can be a maximum of 32 characters.
 *
 * @param stream FILE* stream.
 * @return int Contains a non-zero value if there is an error.
 */
// __zp($75) int ferror(__zp($79) FILE *stream)
ferror: {
    .label ferror__14 = $6a
    .label cbm_k_setnam1_filename = $c5
    .label cbm_k_setnam1_filename_len = $b8
    .label cbm_k_setnam1_ferror__0 = $6c
    .label cbm_k_chkin1_channel = $c0
    .label cbm_k_chkin1_status = $b9
    .label cbm_k_chrin1_ch = $ba
    .label cbm_k_readst1_status = $ab
    .label cbm_k_close1_channel = $bb
    .label cbm_k_chrin2_ch = $ac
    .label stream = $79
    .label return = $75
    .label sp = $df
    .label ch = $aa
    .label errno_len = $b0
    .label errno_parsed = $a7
    // unsigned char sp = (unsigned char)stream
    // [801] ferror::sp#0 = (char)ferror::stream#0 -- vbuz1=_byte_pssz2 
    lda.z stream
    sta.z sp
    // cbm_k_setlfs(15, 8, 15)
    // [802] cbm_k_setlfs::channel = $f -- vbuz1=vbuc1 
    lda #$f
    sta.z cbm_k_setlfs.channel
    // [803] cbm_k_setlfs::device = 8 -- vbuz1=vbuc1 
    lda #8
    sta.z cbm_k_setlfs.device
    // [804] cbm_k_setlfs::command = $f -- vbuz1=vbuc1 
    lda #$f
    sta.z cbm_k_setlfs.command
    // [805] call cbm_k_setlfs
    jsr cbm_k_setlfs
    // ferror::@11
    // cbm_k_setnam("")
    // [806] ferror::cbm_k_setnam1_filename = ferror::$18 -- pbuz1=pbuc1 
    lda #<ferror__18
    sta.z cbm_k_setnam1_filename
    lda #>ferror__18
    sta.z cbm_k_setnam1_filename+1
    // ferror::cbm_k_setnam1
    // strlen(filename)
    // [807] strlen::str#3 = ferror::cbm_k_setnam1_filename -- pbuz1=pbuz2 
    lda.z cbm_k_setnam1_filename
    sta.z strlen.str
    lda.z cbm_k_setnam1_filename+1
    sta.z strlen.str+1
    // [808] call strlen
    // [793] phi from ferror::cbm_k_setnam1 to strlen [phi:ferror::cbm_k_setnam1->strlen]
    // [793] phi strlen::str#6 = strlen::str#3 [phi:ferror::cbm_k_setnam1->strlen#0] -- register_copy 
    jsr strlen
    // strlen(filename)
    // [809] strlen::return#4 = strlen::len#2
    // ferror::@12
    // [810] ferror::cbm_k_setnam1_$0 = strlen::return#4
    // char filename_len = (char)strlen(filename)
    // [811] ferror::cbm_k_setnam1_filename_len = (char)ferror::cbm_k_setnam1_$0 -- vbuz1=_byte_vwuz2 
    lda.z cbm_k_setnam1_ferror__0
    sta.z cbm_k_setnam1_filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx cbm_k_setnam1_filename
    ldy cbm_k_setnam1_filename+1
    jsr CBM_SETNAM
    // ferror::cbm_k_open1
    // asm { jsrCBM_OPEN  }
    jsr CBM_OPEN
    // ferror::@6
    // cbm_k_chkin(15)
    // [814] ferror::cbm_k_chkin1_channel = $f -- vbuz1=vbuc1 
    lda #$f
    sta.z cbm_k_chkin1_channel
    // ferror::cbm_k_chkin1
    // char status
    // [815] ferror::cbm_k_chkin1_status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // ferror::cbm_k_chrin1
    // char ch
    // [817] ferror::cbm_k_chrin1_ch = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_chrin1_ch
    // asm
    // asm { jsrCBM_CHRIN stach  }
    jsr CBM_CHRIN
    sta cbm_k_chrin1_ch
    // return ch;
    // [819] ferror::cbm_k_chrin1_return#0 = ferror::cbm_k_chrin1_ch -- vbuaa=vbuz1 
    // ferror::cbm_k_chrin1_@return
    // }
    // [820] ferror::cbm_k_chrin1_return#1 = ferror::cbm_k_chrin1_return#0
    // ferror::@7
    // char ch = cbm_k_chrin()
    // [821] ferror::ch#0 = ferror::cbm_k_chrin1_return#1 -- vbuz1=vbuaa 
    sta.z ch
    // [822] phi from ferror::@7 to ferror::cbm_k_readst1 [phi:ferror::@7->ferror::cbm_k_readst1]
    // [822] phi ferror::errno_len#10 = 0 [phi:ferror::@7->ferror::cbm_k_readst1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z errno_len
    // [822] phi ferror::ch#10 = ferror::ch#0 [phi:ferror::@7->ferror::cbm_k_readst1#1] -- register_copy 
    // [822] phi ferror::errno_parsed#2 = 0 [phi:ferror::@7->ferror::cbm_k_readst1#2] -- vbuz1=vbuc1 
    sta.z errno_parsed
    // ferror::cbm_k_readst1
  cbm_k_readst1:
    // char status
    // [823] ferror::cbm_k_readst1_status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [825] ferror::cbm_k_readst1_return#0 = ferror::cbm_k_readst1_status -- vbuaa=vbuz1 
    // ferror::cbm_k_readst1_@return
    // }
    // [826] ferror::cbm_k_readst1_return#1 = ferror::cbm_k_readst1_return#0
    // ferror::@8
    // cbm_k_readst()
    // [827] ferror::$6 = ferror::cbm_k_readst1_return#1
    // st = cbm_k_readst()
    // [828] ferror::st#1 = ferror::$6
    // while (!(st = cbm_k_readst()))
    // [829] if(0==ferror::st#1) goto ferror::@1 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b1
    // ferror::@2
    // __status = st
    // [830] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[ferror::sp#0] = ferror::st#1 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // cbm_k_close(15)
    // [831] ferror::cbm_k_close1_channel = $f -- vbuz1=vbuc1 
    lda #$f
    sta.z cbm_k_close1_channel
    // ferror::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // ferror::@9
    // return __errno;
    // [833] ferror::return#1 = __errno -- vwsz1=vwsz2 
    lda.z __errno
    sta.z return
    lda.z __errno+1
    sta.z return+1
    // ferror::@return
    // }
    // [834] return 
    rts
    // ferror::@1
  __b1:
    // if (!errno_parsed)
    // [835] if(0!=ferror::errno_parsed#2) goto ferror::@3 -- 0_neq_vbuz1_then_la1 
    lda.z errno_parsed
    bne __b3
    // ferror::@4
    // if (ch == ',')
    // [836] if(ferror::ch#10!=','pm) goto ferror::@3 -- vbuz1_neq_vbuc1_then_la1 
    lda #','
    cmp.z ch
    bne __b3
    // ferror::@5
    // errno_parsed++;
    // [837] ferror::errno_parsed#1 = ++ ferror::errno_parsed#2 -- vbuz1=_inc_vbuz1 
    inc.z errno_parsed
    // strncpy(temp, __errno_error, errno_len+1)
    // [838] strncpy::n#0 = ferror::errno_len#10 + 1 -- vwuz1=vbuz2_plus_1 
    lda.z errno_len
    clc
    adc #1
    sta.z strncpy.n
    lda #0
    adc #0
    sta.z strncpy.n+1
    // [839] call strncpy
    // [929] phi from ferror::@5 to strncpy [phi:ferror::@5->strncpy]
    jsr strncpy
    // [840] phi from ferror::@5 to ferror::@13 [phi:ferror::@5->ferror::@13]
    // ferror::@13
    // atoi(temp)
    // [841] call atoi
    // [854] phi from ferror::@13 to atoi [phi:ferror::@13->atoi]
    // [854] phi atoi::str#2 = ferror::temp [phi:ferror::@13->atoi#0] -- pbuz1=pbuc1 
    lda #<temp
    sta.z atoi.str
    lda #>temp
    sta.z atoi.str+1
    jsr atoi
    // atoi(temp)
    // [842] atoi::return#4 = atoi::return#2
    // ferror::@14
    // [843] ferror::$14 = atoi::return#4
    // __errno = atoi(temp)
    // [844] __errno = ferror::$14 -- vwsz1=vwsz2 
    lda.z ferror__14
    sta.z __errno
    lda.z ferror__14+1
    sta.z __errno+1
    // [845] phi from ferror::@1 ferror::@14 ferror::@4 to ferror::@3 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3]
    // [845] phi ferror::errno_parsed#11 = ferror::errno_parsed#2 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3#0] -- register_copy 
    // ferror::@3
  __b3:
    // __errno_error[errno_len] = ch
    // [846] __errno_error[ferror::errno_len#10] = ferror::ch#10 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z ch
    ldy.z errno_len
    sta __errno_error,y
    // errno_len++;
    // [847] ferror::errno_len#1 = ++ ferror::errno_len#10 -- vbuz1=_inc_vbuz1 
    inc.z errno_len
    // ferror::cbm_k_chrin2
    // char ch
    // [848] ferror::cbm_k_chrin2_ch = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_chrin2_ch
    // asm
    // asm { jsrCBM_CHRIN stach  }
    jsr CBM_CHRIN
    sta cbm_k_chrin2_ch
    // return ch;
    // [850] ferror::cbm_k_chrin2_return#0 = ferror::cbm_k_chrin2_ch -- vbuaa=vbuz1 
    // ferror::cbm_k_chrin2_@return
    // }
    // [851] ferror::cbm_k_chrin2_return#1 = ferror::cbm_k_chrin2_return#0
    // ferror::@10
    // cbm_k_chrin()
    // [852] ferror::$15 = ferror::cbm_k_chrin2_return#1
    // ch = cbm_k_chrin()
    // [853] ferror::ch#1 = ferror::$15 -- vbuz1=vbuaa 
    sta.z ch
    // [822] phi from ferror::@10 to ferror::cbm_k_readst1 [phi:ferror::@10->ferror::cbm_k_readst1]
    // [822] phi ferror::errno_len#10 = ferror::errno_len#1 [phi:ferror::@10->ferror::cbm_k_readst1#0] -- register_copy 
    // [822] phi ferror::ch#10 = ferror::ch#1 [phi:ferror::@10->ferror::cbm_k_readst1#1] -- register_copy 
    // [822] phi ferror::errno_parsed#2 = ferror::errno_parsed#11 [phi:ferror::@10->ferror::cbm_k_readst1#2] -- register_copy 
    jmp cbm_k_readst1
  .segment Data
    temp: .fill 4, 0
    ferror__18: .text ""
    .byte 0
}
.segment Code
  // atoi
// Converts the string argument str to an integer.
// __zp($6a) int atoi(__zp($7b) const char *str)
atoi: {
    .label atoi__6 = $6a
    .label atoi__7 = $6a
    .label res = $6a
    .label return = $6a
    .label str = $7b
    .label atoi__10 = $73
    .label atoi__11 = $6a
    // if (str[i] == '-')
    // [855] if(*atoi::str#2!='-'pm) goto atoi::@3 -- _deref_pbuz1_neq_vbuc1_then_la1 
    ldy #0
    lda (str),y
    cmp #'-'
    bne __b2
    // [856] phi from atoi to atoi::@2 [phi:atoi->atoi::@2]
    // atoi::@2
    // [857] phi from atoi::@2 to atoi::@3 [phi:atoi::@2->atoi::@3]
    // [857] phi atoi::negative#2 = 1 [phi:atoi::@2->atoi::@3#0] -- vbuxx=vbuc1 
    ldx #1
    // [857] phi atoi::res#2 = 0 [phi:atoi::@2->atoi::@3#1] -- vwsz1=vwsc1 
    tya
    sta.z res
    sta.z res+1
    // [857] phi atoi::i#4 = 1 [phi:atoi::@2->atoi::@3#2] -- vbuyy=vbuc1 
    ldy #1
    jmp __b3
  // Iterate through all digits and update the result
    // [857] phi from atoi to atoi::@3 [phi:atoi->atoi::@3]
  __b2:
    // [857] phi atoi::negative#2 = 0 [phi:atoi->atoi::@3#0] -- vbuxx=vbuc1 
    ldx #0
    // [857] phi atoi::res#2 = 0 [phi:atoi->atoi::@3#1] -- vwsz1=vwsc1 
    txa
    sta.z res
    sta.z res+1
    // [857] phi atoi::i#4 = 0 [phi:atoi->atoi::@3#2] -- vbuyy=vbuc1 
    tay
    // atoi::@3
  __b3:
    // for (; str[i]>='0' && str[i]<='9'; ++i)
    // [858] if(atoi::str#2[atoi::i#4]<'0'pm) goto atoi::@5 -- pbuz1_derefidx_vbuyy_lt_vbuc1_then_la1 
    lda (str),y
    cmp #'0'
    bcc __b5
    // atoi::@6
    // [859] if(atoi::str#2[atoi::i#4]<='9'pm) goto atoi::@4 -- pbuz1_derefidx_vbuyy_le_vbuc1_then_la1 
    lda (str),y
    cmp #'9'
    bcc __b4
    beq __b4
    // atoi::@5
  __b5:
    // if(negative)
    // [860] if(0!=atoi::negative#2) goto atoi::@1 -- 0_neq_vbuxx_then_la1 
    // Return result with sign
    cpx #0
    bne __b1
    // [862] phi from atoi::@1 atoi::@5 to atoi::@return [phi:atoi::@1/atoi::@5->atoi::@return]
    // [862] phi atoi::return#2 = atoi::return#0 [phi:atoi::@1/atoi::@5->atoi::@return#0] -- register_copy 
    rts
    // atoi::@1
  __b1:
    // return -res;
    // [861] atoi::return#0 = - atoi::res#2 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z return
    sta.z return
    lda #0
    sbc.z return+1
    sta.z return+1
    // atoi::@return
    // }
    // [863] return 
    rts
    // atoi::@4
  __b4:
    // res * 10
    // [864] atoi::$10 = atoi::res#2 << 2 -- vwsz1=vwsz2_rol_2 
    lda.z res
    asl
    sta.z atoi__10
    lda.z res+1
    rol
    sta.z atoi__10+1
    asl.z atoi__10
    rol.z atoi__10+1
    // [865] atoi::$11 = atoi::$10 + atoi::res#2 -- vwsz1=vwsz2_plus_vwsz1 
    clc
    lda.z atoi__11
    adc.z atoi__10
    sta.z atoi__11
    lda.z atoi__11+1
    adc.z atoi__10+1
    sta.z atoi__11+1
    // [866] atoi::$6 = atoi::$11 << 1 -- vwsz1=vwsz1_rol_1 
    asl.z atoi__6
    rol.z atoi__6+1
    // res * 10 + str[i]
    // [867] atoi::$7 = atoi::$6 + atoi::str#2[atoi::i#4] -- vwsz1=vwsz1_plus_pbuz2_derefidx_vbuyy 
    lda.z atoi__7
    clc
    adc (str),y
    sta.z atoi__7
    bcc !+
    inc.z atoi__7+1
  !:
    // res = res * 10 + str[i] - '0'
    // [868] atoi::res#1 = atoi::$7 - '0'pm -- vwsz1=vwsz1_minus_vbuc1 
    lda.z res
    sec
    sbc #'0'
    sta.z res
    bcs !+
    dec.z res+1
  !:
    // for (; str[i]>='0' && str[i]<='9'; ++i)
    // [869] atoi::i#2 = ++ atoi::i#4 -- vbuyy=_inc_vbuyy 
    iny
    // [857] phi from atoi::@4 to atoi::@3 [phi:atoi::@4->atoi::@3]
    // [857] phi atoi::negative#2 = atoi::negative#2 [phi:atoi::@4->atoi::@3#0] -- register_copy 
    // [857] phi atoi::res#2 = atoi::res#1 [phi:atoi::@4->atoi::@3#1] -- register_copy 
    // [857] phi atoi::i#4 = atoi::i#2 [phi:atoi::@4->atoi::@3#2] -- register_copy 
    jmp __b3
}
  // cx16_k_macptr
/**
 * @brief Read a number of bytes from the sdcard using kernal macptr call.
 * BRAM bank needs to be set properly before the load between adressed A000 and BFFF.
 *
 * @return x the size of bytes read
 * @return y the size of bytes read
 * @return if carry is set there is an error
 */
// __zp($6a) unsigned int cx16_k_macptr(__zp($9f) volatile char bytes, __zp($9d) void * volatile buffer)
cx16_k_macptr: {
    .label bytes = $9f
    .label buffer = $9d
    .label bytes_read = $77
    .label return = $6a
    // unsigned int bytes_read
    // [870] cx16_k_macptr::bytes_read = 0 -- vwuz1=vwuc1 
    lda #<0
    sta.z bytes_read
    sta.z bytes_read+1
    // asm
    // asm { ldabytes ldxbuffer ldybuffer+1 clc jsrCX16_MACPTR stxbytes_read stybytes_read+1 bcc!+ lda#$FF stabytes_read stabytes_read+1 !:  }
    lda bytes
    ldx buffer
    ldy buffer+1
    clc
    jsr CX16_MACPTR
    stx bytes_read
    sty bytes_read+1
    bcc !+
    lda #$ff
    sta bytes_read
    sta bytes_read+1
  !:
    // return bytes_read;
    // [872] cx16_k_macptr::return#0 = cx16_k_macptr::bytes_read -- vwuz1=vwuz2 
    lda.z bytes_read
    sta.z return
    lda.z bytes_read+1
    sta.z return+1
    // cx16_k_macptr::@return
    // }
    // [873] cx16_k_macptr::return#1 = cx16_k_macptr::return#0
    // [874] return 
    rts
}
  // vera_sprite_vflip_get_bitmap
// __register(A) char vera_sprite_vflip_get_bitmap(__register(A) char vflip)
vera_sprite_vflip_get_bitmap: {
    // case 0:
    //             return VERA_SPRITE_NFLIP;
    // [875] if(vera_sprite_vflip_get_bitmap::vflip#0==0) goto vera_sprite_vflip_get_bitmap::@return -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b1
    // vera_sprite_vflip_get_bitmap::@1
    // case 1:
    //             return VERA_SPRITE_VFLIP;
    //         other:
    // [876] if(vera_sprite_vflip_get_bitmap::vflip#0==1) goto vera_sprite_vflip_get_bitmap::@2 -- vbuaa_eq_vbuc1_then_la1 
    cmp #1
    beq __b2
    // [878] phi from vera_sprite_vflip_get_bitmap vera_sprite_vflip_get_bitmap::@1 to vera_sprite_vflip_get_bitmap::@return [phi:vera_sprite_vflip_get_bitmap/vera_sprite_vflip_get_bitmap::@1->vera_sprite_vflip_get_bitmap::@return]
  __b1:
    // [878] phi vera_sprite_vflip_get_bitmap::return#3 = 0 [phi:vera_sprite_vflip_get_bitmap/vera_sprite_vflip_get_bitmap::@1->vera_sprite_vflip_get_bitmap::@return#0] -- vbuaa=vbuc1 
    lda #0
    rts
    // [877] phi from vera_sprite_vflip_get_bitmap::@1 to vera_sprite_vflip_get_bitmap::@2 [phi:vera_sprite_vflip_get_bitmap::@1->vera_sprite_vflip_get_bitmap::@2]
    // vera_sprite_vflip_get_bitmap::@2
  __b2:
    // [878] phi from vera_sprite_vflip_get_bitmap::@2 to vera_sprite_vflip_get_bitmap::@return [phi:vera_sprite_vflip_get_bitmap::@2->vera_sprite_vflip_get_bitmap::@return]
    // [878] phi vera_sprite_vflip_get_bitmap::return#3 = 2 [phi:vera_sprite_vflip_get_bitmap::@2->vera_sprite_vflip_get_bitmap::@return#0] -- vbuaa=vbuc1 
    lda #2
    // vera_sprite_vflip_get_bitmap::@return
    // }
    // [879] return 
    rts
}
  // vera_sprite_bpp_get_bitmap
// __register(A) char vera_sprite_bpp_get_bitmap(__register(A) char bpp)
vera_sprite_bpp_get_bitmap: {
    // case 4:
    //             return VERA_SPRITE_4BPP;
    // [880] if(vera_sprite_bpp_get_bitmap::bpp#0==4) goto vera_sprite_bpp_get_bitmap::@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #4
    beq __b1
    // vera_sprite_bpp_get_bitmap::@1
    // case 8:
    //             return VERA_SPRITE_8BPP;
    //         other:
    // [881] if(vera_sprite_bpp_get_bitmap::bpp#0==8) goto vera_sprite_bpp_get_bitmap::@2 -- vbuaa_eq_vbuc1_then_la1 
    cmp #8
    beq __b2
    // [883] phi from vera_sprite_bpp_get_bitmap vera_sprite_bpp_get_bitmap::@1 to vera_sprite_bpp_get_bitmap::@return [phi:vera_sprite_bpp_get_bitmap/vera_sprite_bpp_get_bitmap::@1->vera_sprite_bpp_get_bitmap::@return]
  __b1:
    // [883] phi vera_sprite_bpp_get_bitmap::return#3 = 0 [phi:vera_sprite_bpp_get_bitmap/vera_sprite_bpp_get_bitmap::@1->vera_sprite_bpp_get_bitmap::@return#0] -- vbuaa=vbuc1 
    lda #0
    rts
    // [882] phi from vera_sprite_bpp_get_bitmap::@1 to vera_sprite_bpp_get_bitmap::@2 [phi:vera_sprite_bpp_get_bitmap::@1->vera_sprite_bpp_get_bitmap::@2]
    // vera_sprite_bpp_get_bitmap::@2
  __b2:
    // [883] phi from vera_sprite_bpp_get_bitmap::@2 to vera_sprite_bpp_get_bitmap::@return [phi:vera_sprite_bpp_get_bitmap::@2->vera_sprite_bpp_get_bitmap::@return]
    // [883] phi vera_sprite_bpp_get_bitmap::return#3 = $80 [phi:vera_sprite_bpp_get_bitmap::@2->vera_sprite_bpp_get_bitmap::@return#0] -- vbuaa=vbuc1 
    lda #$80
    // vera_sprite_bpp_get_bitmap::@return
    // }
    // [884] return 
    rts
}
  // vera_sprite_height
// void vera_sprite_height(__zp($6a) unsigned int sprite_offset, __register(X) char height)
vera_sprite_height: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    .label vera_vram_data0_bank_offset1_offset = $6a
    .label sprite_offset = $6a
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0)
    // [885] vera_sprite_height::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_height::sprite_offset#0 + 7 -- vwuz1=vwuz1_plus_vbuc1 
    lda #7
    clc
    adc.z vera_vram_data0_bank_offset1_offset
    sta.z vera_vram_data0_bank_offset1_offset
    bcc !+
    inc.z vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_height::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [886] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [887] vera_sprite_height::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_height::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwuz1 
    lda.z vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [888] *VERA_ADDRX_L = vera_sprite_height::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [889] vera_sprite_height::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_height::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwuz1 
    lda.z vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [890] *VERA_ADDRX_M = vera_sprite_height::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [891] *VERA_ADDRX_H = vera_sprite_height::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_height::@1
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [892] vera_sprite_height::$2 = *VERA_DATA0 & ~$c0 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$c0^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [893] *VERA_DATA0 = vera_sprite_height::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= height
    // [894] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_height::height#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // vera_sprite_height::@return
    // }
    // [895] return 
    rts
}
  // vera_sprite_width
// void vera_sprite_width(__zp($6a) unsigned int sprite_offset, __register(X) char width)
vera_sprite_width: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    .label vera_vram_data0_bank_offset1_offset = $6a
    .label sprite_offset = $6a
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0)
    // [896] vera_sprite_width::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_width::sprite_offset#0 + 7 -- vwuz1=vwuz1_plus_vbuc1 
    lda #7
    clc
    adc.z vera_vram_data0_bank_offset1_offset
    sta.z vera_vram_data0_bank_offset1_offset
    bcc !+
    inc.z vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_width::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [897] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [898] vera_sprite_width::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_width::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwuz1 
    lda.z vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [899] *VERA_ADDRX_L = vera_sprite_width::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [900] vera_sprite_width::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_width::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwuz1 
    lda.z vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [901] *VERA_ADDRX_M = vera_sprite_width::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [902] *VERA_ADDRX_H = vera_sprite_width::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_width::@1
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [903] vera_sprite_width::$2 = *VERA_DATA0 & ~$30 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$30^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [904] *VERA_DATA0 = vera_sprite_width::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= width
    // [905] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_width::width#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // vera_sprite_width::@return
    // }
    // [906] return 
    rts
}
  // vera_sprite_hflip
// void vera_sprite_hflip(__zp($73) unsigned int sprite_offset, __register(X) char hflip)
vera_sprite_hflip: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    .label vera_vram_data0_bank_offset1_offset = $73
    .label sprite_offset = $73
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0)
    // [907] vera_sprite_hflip::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_hflip::sprite_offset#0 + 6 -- vwuz1=vwuz1_plus_vbuc1 
    lda #6
    clc
    adc.z vera_vram_data0_bank_offset1_offset
    sta.z vera_vram_data0_bank_offset1_offset
    bcc !+
    inc.z vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_hflip::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [908] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [909] vera_sprite_hflip::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_hflip::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwuz1 
    lda.z vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [910] *VERA_ADDRX_L = vera_sprite_hflip::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [911] vera_sprite_hflip::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_hflip::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwuz1 
    lda.z vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [912] *VERA_ADDRX_M = vera_sprite_hflip::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [913] *VERA_ADDRX_H = vera_sprite_hflip::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_hflip::@1
    // *VERA_DATA0 & ~VERA_SPRITE_HFLIP
    // [914] vera_sprite_hflip::$2 = *VERA_DATA0 & ~1 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #1^$ff
    and VERA_DATA0
    // *VERA_DATA0 = (*VERA_DATA0 & ~VERA_SPRITE_HFLIP)
    // [915] *VERA_DATA0 = vera_sprite_hflip::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= hflip
    // [916] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_hflip::hflip#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // vera_sprite_hflip::@return
    // }
    // [917] return 
    rts
}
  // vera_sprite_vflip
// void vera_sprite_vflip(__zp($73) unsigned int sprite_offset, __register(X) char vflip)
vera_sprite_vflip: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    .label vera_vram_data0_bank_offset1_offset = $73
    .label sprite_offset = $73
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0)
    // [918] vera_sprite_vflip::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_vflip::sprite_offset#0 + 6 -- vwuz1=vwuz1_plus_vbuc1 
    lda #6
    clc
    adc.z vera_vram_data0_bank_offset1_offset
    sta.z vera_vram_data0_bank_offset1_offset
    bcc !+
    inc.z vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_vflip::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [919] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [920] vera_sprite_vflip::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_vflip::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwuz1 
    lda.z vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [921] *VERA_ADDRX_L = vera_sprite_vflip::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [922] vera_sprite_vflip::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_vflip::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwuz1 
    lda.z vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [923] *VERA_ADDRX_M = vera_sprite_vflip::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [924] *VERA_ADDRX_H = vera_sprite_vflip::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_vflip::@1
    // *VERA_DATA0 & ~VERA_SPRITE_VFLIP
    // [925] vera_sprite_vflip::$2 = *VERA_DATA0 & ~2 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #2^$ff
    and VERA_DATA0
    // *VERA_DATA0 = (*VERA_DATA0 & ~VERA_SPRITE_VFLIP)
    // [926] *VERA_DATA0 = vera_sprite_vflip::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= vflip
    // [927] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_vflip::vflip#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // vera_sprite_vflip::@return
    // }
    // [928] return 
    rts
}
  // strncpy
/// Copies up to n characters from the string pointed to, by src to dst.
/// In a case where the length of src is less than that of n, the remainder of dst will be padded with null bytes.
/// @param dst ? This is the pointer to the destination array where the content is to be copied.
/// @param src ? This is the string to be copied.
/// @param n ? The number of characters to be copied from source.
/// @return The destination
// char * strncpy(__zp($73) char *dst, __zp($6c) const char *src, __zp($7b) unsigned int n)
strncpy: {
    .label dst = $73
    .label i = $75
    .label src = $6c
    .label n = $7b
    // [930] phi from strncpy to strncpy::@1 [phi:strncpy->strncpy::@1]
    // [930] phi strncpy::dst#2 = ferror::temp [phi:strncpy->strncpy::@1#0] -- pbuz1=pbuc1 
    lda #<ferror.temp
    sta.z dst
    lda #>ferror.temp
    sta.z dst+1
    // [930] phi strncpy::src#2 = __errno_error [phi:strncpy->strncpy::@1#1] -- pbuz1=pbuc1 
    lda #<__errno_error
    sta.z src
    lda #>__errno_error
    sta.z src+1
    // [930] phi strncpy::i#2 = 0 [phi:strncpy->strncpy::@1#2] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
    // strncpy::@1
  __b1:
    // for(size_t i = 0;i<n;i++)
    // [931] if(strncpy::i#2<strncpy::n#0) goto strncpy::@2 -- vwuz1_lt_vwuz2_then_la1 
    lda.z i+1
    cmp.z n+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z n
    bcc __b2
  !:
    // strncpy::@return
    // }
    // [932] return 
    rts
    // strncpy::@2
  __b2:
    // char c = *src
    // [933] strncpy::c#0 = *strncpy::src#2 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (src),y
    // if(c)
    // [934] if(0==strncpy::c#0) goto strncpy::@3 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b3
    // strncpy::@4
    // src++;
    // [935] strncpy::src#0 = ++ strncpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [936] phi from strncpy::@2 strncpy::@4 to strncpy::@3 [phi:strncpy::@2/strncpy::@4->strncpy::@3]
    // [936] phi strncpy::src#6 = strncpy::src#2 [phi:strncpy::@2/strncpy::@4->strncpy::@3#0] -- register_copy 
    // strncpy::@3
  __b3:
    // *dst++ = c
    // [937] *strncpy::dst#2 = strncpy::c#0 -- _deref_pbuz1=vbuaa 
    ldy #0
    sta (dst),y
    // *dst++ = c;
    // [938] strncpy::dst#0 = ++ strncpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // for(size_t i = 0;i<n;i++)
    // [939] strncpy::i#1 = ++ strncpy::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [930] phi from strncpy::@3 to strncpy::@1 [phi:strncpy::@3->strncpy::@1]
    // [930] phi strncpy::dst#2 = strncpy::dst#0 [phi:strncpy::@3->strncpy::@1#0] -- register_copy 
    // [930] phi strncpy::src#2 = strncpy::src#6 [phi:strncpy::@3->strncpy::@1#1] -- register_copy 
    // [930] phi strncpy::i#2 = strncpy::i#1 [phi:strncpy::@3->strncpy::@1#2] -- register_copy 
    jmp __b1
}
  // Exported Global Data
.segment Data
  /**
 * @file errno.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Contains the POSIX implementation of errno, which contains the last error detected.
 * @version 0.1
 * @date 2023-03-18
 * 
 * @copyright Copyright (c) 2023
 * 
 */
  __errno_error: .fill $20, 0
.segment DataEngineFlight
  // Flight engine control.
  flight_sprite_offsets: .word 0
  .fill 2*$7e, 0
  sprite_bram_handles: .fill $100, 0
.segment BramEngineFlight
  __50: .text "t001"
  .byte 0
  __51: .text "p001"
  .byte 0
  __52: .text "n001"
  .byte 0
  __53: .text "e0701"
  .byte 0
  __54: .text "e0102"
  .byte 0
  __55: .text "e0201"
  .byte 0
  __56: .text "e0202"
  .byte 0
  __57: .text "e0301"
  .byte 0
  __58: .text "e0302"
  .byte 0
  __59: .text "e0401"
  .byte 0
  __60: .text "e0501"
  .byte 0
  __61: .text "e0502"
  .byte 0
  __62: .text "e0601"
  .byte 0
  __63: .text "e0602"
  .byte 0
  __64: .text "e0101"
  .byte 0
  __65: .text "e0702"
  .byte 0
  __66: .text "e0703"
  .byte 0
  __67: .text "b001"
  .byte 0
  __68: .text "b002"
  .byte 0
  __69: .text "b003"
  .byte 0
  __70: .text "b004"
  .byte 0
.segment Data
  __stdio_file: .fill equinoxe_flightengine.SIZEOF_STRUCT_FILE, 0
.segment BramEngineFlight
  sprites: .word equinoxe_flightengine.__50, equinoxe_flightengine.__51, equinoxe_flightengine.__52, equinoxe_flightengine.__53, equinoxe_flightengine.__54, equinoxe_flightengine.__55, equinoxe_flightengine.__56, equinoxe_flightengine.__57, equinoxe_flightengine.__58, equinoxe_flightengine.__59, equinoxe_flightengine.__60, equinoxe_flightengine.__61, equinoxe_flightengine.__62, equinoxe_flightengine.__63, equinoxe_flightengine.__64, equinoxe_flightengine.__65, equinoxe_flightengine.__66, equinoxe_flightengine.__67, equinoxe_flightengine.__68, equinoxe_flightengine.__69, equinoxe_flightengine.__70
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
  stage_player: .byte 1
  .word equinoxe_flightengine.stage_player_engine, equinoxe_flightengine.stage_player_bullet
  stage_player_engine: .byte 2
  stage_player_bullet: .byte $11
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
.segment DataSpriteCache
  // Cache to manage sprite control data fast, unbanked as making this banked will make things very, very complicated.
  sprite_cache: .fill equinoxe_flightengine.SIZEOF_STRUCT_FE_SPRITE_CACHE_T, 0
.segment DataEngineFlight
  flight: .fill equinoxe_flightengine.SIZEOF_STRUCT_FLIGHT_T, 0
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

 // Asm import library equinoxe-animate:
#define __asm_import__equinoxe_animate__
#import "equinoxe-animate.asm"

 // Asm import library equinoxe-palette:
#define __asm_import__equinoxe_palette__
#import "equinoxe-palette.asm"

