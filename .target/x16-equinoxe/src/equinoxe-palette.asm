  //
#importonce
  // File Comments
/**
 * @file equinoxe-palette.c
 * @author your name (you@domain.com)
 * @brief 
 * @version 0.1
 * @date 2022-05-03
 * 
 * @copyright Copyright (c) 2022
 * 
 */
  // Library
.namespace equinoxe_palette {
  // Upstart
.cpu _65c02
#if !__asm_import__equinoxe_palette__
.file                               [name="equinoxe-palette.prg", type="prg", segments="Program"]
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
:BasicUpstart(__equinoxe_palette_start)
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
  .label VERA_INC_1 = $10
  .label VERA_ADDRSEL = 1
  // VERA Palette address in VRAM  $1FA00 - $1FBFF
  // 256 entries of 2 bytes
  // byte 0 bits 4-7: Green
  // byte 0 bits 0-3: Blue
  // byte 1 bits 0-3: Red
  .label VERA_PALETTE_BANK = 1
  .label OFFSET_STRUCT_PALETTE_T_VRAM = 3
  .label OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_OFFSET = $20
  .label OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED = $10
  .label OFFSET_STRUCT_PALETTE_T_VRAM_INDEX = 2
  .label OFFSET_STRUCT_PALETTE_T_POOL = 1
  .label OFFSET_STRUCT_PALETTE_T_BRAM = $43
  .label OFFSET_STRUCT_PALETTE_BRAM_INDEX_S_USED = $40
  .label SIZEOF_STRUCT_PALETTE_BRAM_S = $1000
  .label SIZEOF_STRUCT_PALETTE_T = $c3
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
  .label VERA_PALETTE_PTR = $fa00
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __equinoxe_palette_start
// void __equinoxe_palette_start()
__equinoxe_palette_start: {
    // __equinoxe_palette_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __equinoxe_palette_start::@return
    // [3] return 
    rts
}
.segment CodeEnginePalette
  // palette_free_vram
// void palette_free_vram(__mem() unsigned int bram_index)
palette_free_vram: {
    .label palette_free_vram__0 = $22
    .label palette_free_vram__1 = $22
    // unsigned char vram_index = palette.bram.vram_index[bram_index]
    // [4] palette_free_vram::$0 = (char *)(struct palette_bram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_BRAM + palette_free_vram::bram_index -- pbuz1=pbuc1_plus_vwum2 
    lda bram_index
    clc
    adc #<palette+OFFSET_STRUCT_PALETTE_T_BRAM
    sta.z palette_free_vram__0
    lda bram_index+1
    adc #>palette+OFFSET_STRUCT_PALETTE_T_BRAM
    sta.z palette_free_vram__0+1
    // [5] palette_free_vram::vram_index#0 = *palette_free_vram::$0 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (palette_free_vram__0),y
    // palette.vram.used[vram_index] = 0
    // [6] ((char *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED)[palette_free_vram::vram_index#0] = 0 -- pbuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED,y
    // palette.bram.vram_index[bram_index] = 0
    // [7] palette_free_vram::$1 = (char *)(struct palette_bram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_BRAM + palette_free_vram::bram_index -- pbuz1=pbuc1_plus_vwum2 
    lda bram_index
    clc
    adc #<palette+OFFSET_STRUCT_PALETTE_T_BRAM
    sta.z palette_free_vram__1
    lda bram_index+1
    adc #>palette+OFFSET_STRUCT_PALETTE_T_BRAM
    sta.z palette_free_vram__1+1
    // [8] *palette_free_vram::$1 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (palette_free_vram__1),y
    // palette_free_vram::@return
    // }
    // [9] return 
    rts
  .segment DataEnginePalette
    .label bram_index = palette_use_vram.memcpy_vram_bram_fast1_doffset_vram
}
.segment CodeEnginePalette
  // palette_unuse_vram
// void palette_unuse_vram(__mem() unsigned int bram_index)
palette_unuse_vram: {
    .label palette_unuse_vram__1 = $22
    // unsigned char vram_index = palette.bram.vram_index[bram_index]
    // [10] palette_unuse_vram::$1 = (char *)(struct palette_bram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_BRAM + palette_unuse_vram::bram_index -- pbuz1=pbuc1_plus_vwum2 
    lda bram_index
    clc
    adc #<palette+OFFSET_STRUCT_PALETTE_T_BRAM
    sta.z palette_unuse_vram__1
    lda bram_index+1
    adc #>palette+OFFSET_STRUCT_PALETTE_T_BRAM
    sta.z palette_unuse_vram__1+1
    // [11] palette_unuse_vram::vram_index#0 = *palette_unuse_vram::$1 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (palette_unuse_vram__1),y
    // palette.vram.used[vram_index]--;
    // [12] ((char *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED)[palette_unuse_vram::vram_index#0] = -- ((char *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED)[palette_unuse_vram::vram_index#0] -- pbuc1_derefidx_vbuaa=_dec_pbuc1_derefidx_vbuaa 
    tax
    dec palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED,x
    // palette_unuse_vram::@return
    // }
    // [13] return 
    rts
  .segment DataEnginePalette
    .label bram_index = palette_use_vram.memcpy_vram_bram_fast1_doffset_vram
}
.segment CodeEnginePalette
  // palette_use_vram
// __mem() char palette_use_vram(__mem() char palette_index)
palette_use_vram: {
    .label memcpy_vram_bram_fast1_sptr_bram = $22
    // unsigned char vram_index = palette.bram.vram_index[palette_index]
    // [14] palette_use_vram::vram_index#0 = ((char *)(struct palette_bram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_BRAM)[palette_use_vram::palette_index] -- vbum1=pbuc1_derefidx_vbum2 
    ldy palette_index
    lda palette+OFFSET_STRUCT_PALETTE_T_BRAM,y
    sta vram_index
    // if(!vram_index)
    // [15] if(0!=palette_use_vram::vram_index#0) goto palette_use_vram::@1 -- 0_neq_vbum1_then_la1 
    bne __b1
    // [16] phi from palette_use_vram to palette_use_vram::@2 [phi:palette_use_vram->palette_use_vram::@2]
    // palette_use_vram::@2
    // palette_alloc_vram()
    // [17] call palette_alloc_vram
    // [77] phi from palette_use_vram::@2 to palette_alloc_vram [phi:palette_use_vram::@2->palette_alloc_vram]
    jsr palette_alloc_vram
    // palette_alloc_vram()
    // [18] palette_alloc_vram::return#3 = palette_alloc_vram::return#2
    // palette_use_vram::@7
    // vram_index = palette_alloc_vram()
    // [19] palette_use_vram::vram_index#1 = palette_alloc_vram::return#3 -- vbum1=vbuaa 
    sta vram_index
    // if(vram_index)
    // [20] if(0==palette_use_vram::vram_index#1) goto palette_use_vram::@1 -- 0_eq_vbum1_then_la1 
    beq __b1
    // palette_use_vram::@3
    // if(palette.vram.bram_index[vram_index])
    // [21] if(0==((char *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM)[palette_use_vram::vram_index#1]) goto palette_use_vram::@5 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    tay
    lda palette+OFFSET_STRUCT_PALETTE_T_VRAM,y
    cmp #0
    beq __b5
    // palette_use_vram::@4
    // palette.bram.vram_index[palette.vram.bram_index[vram_index]] = 0
    // [22] ((char *)(struct palette_bram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_BRAM)[((char *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM)[palette_use_vram::vram_index#1]] = 0 -- pbuc1_derefidx_(pbuc2_derefidx_vbum1)=vbuc3 
    lda #0
    ldx palette+OFFSET_STRUCT_PALETTE_T_VRAM,y
    sta palette+OFFSET_STRUCT_PALETTE_T_BRAM,x
    // palette_use_vram::@5
  __b5:
    // palette.vram.bram_index[vram_index] = palette_index
    // [23] ((char *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM)[palette_use_vram::vram_index#1] = palette_use_vram::palette_index -- pbuc1_derefidx_vbum1=vbum2 
    lda palette_index
    ldy vram_index
    sta palette+OFFSET_STRUCT_PALETTE_T_VRAM,y
    // palette_ptr_bram(palette_index)
    // [24] palette_ptr_bram::palette_index = palette_use_vram::palette_index -- vbum1=vbum2 
    sta equinoxe_palette.palette_ptr_bram.palette_index
    // [25] callexecute palette_ptr_bram  -- call_var_near 
    jsr palette_ptr_bram
    // [26] palette_use_vram::memcpy_vram_bram_fast1_sptr_bram#0 = palette_ptr_bram::return
    // memcpy_vram_bram_fast(VERA_PALETTE_BANK, palette.vram.offset[vram_index], palette.bram_bank, (bram_ptr_t)palette_ptr_bram(palette_index), 32)
    // [27] palette_use_vram::$8 = palette_use_vram::vram_index#1 << 1 -- vbuaa=vbum1_rol_1 
    lda vram_index
    asl
    // [28] palette_use_vram::memcpy_vram_bram_fast1_doffset_vram#0 = ((unsigned int *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_OFFSET)[palette_use_vram::$8] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_OFFSET,y
    sta memcpy_vram_bram_fast1_doffset_vram
    lda palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_OFFSET+1,y
    sta memcpy_vram_bram_fast1_doffset_vram+1
    // [29] palette_use_vram::memcpy_vram_bram_fast1_sbank_bram#0 = *((char *)&palette) -- vbuxx=_deref_pbuc1 
    ldx palette
    // [30] phi from palette_use_vram::@5 to palette_use_vram::memcpy_vram_bram_fast1 [phi:palette_use_vram::@5->palette_use_vram::memcpy_vram_bram_fast1]
    // palette_use_vram::memcpy_vram_bram_fast1
    // palette_use_vram::memcpy_vram_bram_fast1_bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [32] BRAM = palette_use_vram::memcpy_vram_bram_fast1_sbank_bram#0 -- vbuz1=vbuxx 
    stx.z BRAM
    // palette_use_vram::memcpy_vram_bram_fast1_@3
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [33] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [34] palette_use_vram::memcpy_vram_bram_fast1_$1 = byte0  palette_use_vram::memcpy_vram_bram_fast1_doffset_vram#0 -- vbuaa=_byte0_vwum1 
    lda memcpy_vram_bram_fast1_doffset_vram
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [35] *VERA_ADDRX_L = palette_use_vram::memcpy_vram_bram_fast1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [36] palette_use_vram::memcpy_vram_bram_fast1_$2 = byte1  palette_use_vram::memcpy_vram_bram_fast1_doffset_vram#0 -- vbuaa=_byte1_vwum1 
    lda memcpy_vram_bram_fast1_doffset_vram+1
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [37] *VERA_ADDRX_M = palette_use_vram::memcpy_vram_bram_fast1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [38] *VERA_ADDRX_H = VERA_PALETTE_BANK|VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_PALETTE_BANK|VERA_INC_1
    sta VERA_ADDRX_H
    // [39] phi from palette_use_vram::memcpy_vram_bram_fast1_@3 to palette_use_vram::memcpy_vram_bram_fast1_@1 [phi:palette_use_vram::memcpy_vram_bram_fast1_@3->palette_use_vram::memcpy_vram_bram_fast1_@1]
    // [39] phi palette_use_vram::memcpy_vram_bram_fast1_num#2 = $20 [phi:palette_use_vram::memcpy_vram_bram_fast1_@3->palette_use_vram::memcpy_vram_bram_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #$20
    // [39] phi palette_use_vram::memcpy_vram_bram_fast1_add#2 = 0 [phi:palette_use_vram::memcpy_vram_bram_fast1_@3->palette_use_vram::memcpy_vram_bram_fast1_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [39] phi from palette_use_vram::memcpy_vram_bram_fast1_@1 to palette_use_vram::memcpy_vram_bram_fast1_@1 [phi:palette_use_vram::memcpy_vram_bram_fast1_@1->palette_use_vram::memcpy_vram_bram_fast1_@1]
    // [39] phi palette_use_vram::memcpy_vram_bram_fast1_num#2 = palette_use_vram::memcpy_vram_bram_fast1_num#1 [phi:palette_use_vram::memcpy_vram_bram_fast1_@1->palette_use_vram::memcpy_vram_bram_fast1_@1#0] -- register_copy 
    // [39] phi palette_use_vram::memcpy_vram_bram_fast1_add#2 = palette_use_vram::memcpy_vram_bram_fast1_add#1 [phi:palette_use_vram::memcpy_vram_bram_fast1_@1->palette_use_vram::memcpy_vram_bram_fast1_@1#1] -- register_copy 
    // palette_use_vram::memcpy_vram_bram_fast1_@1
  memcpy_vram_bram_fast1___b1:
    // *VERA_DATA0 = sptr_bram[add]
    // [40] *VERA_DATA0 = ((char *)palette_use_vram::memcpy_vram_bram_fast1_sptr_bram#0)[palette_use_vram::memcpy_vram_bram_fast1_add#2] -- _deref_pbuc1=pbuz1_derefidx_vbuyy 
    lda (memcpy_vram_bram_fast1_sptr_bram),y
    sta VERA_DATA0
    // add++;
    // [41] palette_use_vram::memcpy_vram_bram_fast1_add#1 = ++ palette_use_vram::memcpy_vram_bram_fast1_add#2 -- vbuyy=_inc_vbuyy 
    iny
    // num--;
    // [42] palette_use_vram::memcpy_vram_bram_fast1_num#1 = -- palette_use_vram::memcpy_vram_bram_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [43] if(0!=palette_use_vram::memcpy_vram_bram_fast1_num#1) goto palette_use_vram::memcpy_vram_bram_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memcpy_vram_bram_fast1___b1
    // palette_use_vram::memcpy_vram_bram_fast1_bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // palette_use_vram::@6
    // palette.bram.vram_index[palette_index] = vram_index
    // [45] ((char *)(struct palette_bram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_BRAM)[palette_use_vram::palette_index] = palette_use_vram::vram_index#1 -- pbuc1_derefidx_vbum1=vbum2 
    lda vram_index
    ldy palette_index
    sta palette+OFFSET_STRUCT_PALETTE_T_BRAM,y
    // [46] phi from palette_use_vram palette_use_vram::@6 palette_use_vram::@7 to palette_use_vram::@1 [phi:palette_use_vram/palette_use_vram::@6/palette_use_vram::@7->palette_use_vram::@1]
    // [46] phi palette_use_vram::vram_index#2 = palette_use_vram::vram_index#0 [phi:palette_use_vram/palette_use_vram::@6/palette_use_vram::@7->palette_use_vram::@1#0] -- register_copy 
    // palette_use_vram::@1
  __b1:
    // palette.vram.used[vram_index]++;
    // [47] ((char *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED)[palette_use_vram::vram_index#2] = ++ ((char *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED)[palette_use_vram::vram_index#2] -- pbuc1_derefidx_vbum1=_inc_pbuc1_derefidx_vbum1 
    ldx vram_index
    inc palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED,x
    // return vram_index;
    // [48] palette_use_vram::return = palette_use_vram::vram_index#2
    // palette_use_vram::@return
    // }
    // [49] return 
    rts
  .segment DataEnginePalette
    palette_index: .byte 0
    .label return = vram_index
    vram_index: .byte 0
    memcpy_vram_bram_fast1_doffset_vram: .word 0
}
.segment CodeEnginePalette
  // palette_alloc_bram
// __mem() char palette_alloc_bram()
palette_alloc_bram: {
  // Search for an empty slot.
  // There are a maximum of 64 different palettes that can be loaded in bram.
    // palette_alloc_bram::@1
  __b1:
    // while(palette.bram.used[palette.pool])
    // [51] if(0!=((char *)(struct palette_bram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_BRAM+OFFSET_STRUCT_PALETTE_BRAM_INDEX_S_USED)[*((char *)&palette+OFFSET_STRUCT_PALETTE_T_POOL)]) goto palette_alloc_bram::@2 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy palette+OFFSET_STRUCT_PALETTE_T_POOL
    lda palette+OFFSET_STRUCT_PALETTE_T_BRAM+OFFSET_STRUCT_PALETTE_BRAM_INDEX_S_USED,y
    cmp #0
    bne __b2
    // palette_alloc_bram::@3
    // palette.bram.used[palette.pool] = 1
    // [52] ((char *)(struct palette_bram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_BRAM+OFFSET_STRUCT_PALETTE_BRAM_INDEX_S_USED)[*((char *)&palette+OFFSET_STRUCT_PALETTE_T_POOL)] = 1 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #1
    sta palette+OFFSET_STRUCT_PALETTE_T_BRAM+OFFSET_STRUCT_PALETTE_BRAM_INDEX_S_USED,y
    // return palette.pool;
    // [53] palette_alloc_bram::return = *((char *)&palette+OFFSET_STRUCT_PALETTE_T_POOL) -- vbum1=_deref_pbuc1 
    tya
    sta return
    // palette_alloc_bram::@return
    // }
    // [54] return 
    rts
    // palette_alloc_bram::@2
  __b2:
    // palette.pool + 1
    // [55] palette_alloc_bram::$0 = *((char *)&palette+OFFSET_STRUCT_PALETTE_T_POOL) + 1 -- vbuaa=_deref_pbuc1_plus_1 
    lda palette+OFFSET_STRUCT_PALETTE_T_POOL
    inc
    // (palette.pool + 1) % 64
    // [56] palette_alloc_bram::$1 = palette_alloc_bram::$0 & $40-1 -- vbuaa=vbuaa_band_vbuc1 
    and #$40-1
    // palette.pool = (palette.pool + 1) % 64
    // [57] *((char *)&palette+OFFSET_STRUCT_PALETTE_T_POOL) = palette_alloc_bram::$1 -- _deref_pbuc1=vbuaa 
    sta palette+OFFSET_STRUCT_PALETTE_T_POOL
    jmp __b1
  .segment DataEnginePalette
    .label return = palette_use_vram.vram_index
}
.segment CodeEnginePalette
  // palette_ptr_bram
/**
 * @brief Return the address of palette slot in bram. 
 * 
 * @return palette_ptr_t The address in bram. Note that the bank must be properly set to use the data behind the pointer.
 */
// __zp($22) struct palette_16_s * palette_ptr_bram(__mem() char palette_index)
palette_ptr_bram: {
    .label return = $22
    .label palette_ptr_bram__0 = $22
    // &palette_bram.palette_16[(unsigned int)palette_index]
    // [58] palette_ptr_bram::$2 = (unsigned int)palette_ptr_bram::palette_index -- vwum1=_word_vbum2 
    lda palette_index
    sta palette_ptr_bram__2
    lda #0
    sta palette_ptr_bram__2+1
    // [59] palette_ptr_bram::$1 = palette_ptr_bram::$2 << 5 -- vwum1=vwum1_rol_5 
    asl palette_ptr_bram__1
    rol palette_ptr_bram__1+1
    asl palette_ptr_bram__1
    rol palette_ptr_bram__1+1
    asl palette_ptr_bram__1
    rol palette_ptr_bram__1+1
    asl palette_ptr_bram__1
    rol palette_ptr_bram__1+1
    asl palette_ptr_bram__1
    rol palette_ptr_bram__1+1
    // [60] palette_ptr_bram::$0 = (struct palette_16_s *)&palette_bram + palette_ptr_bram::$1 -- pssz1=pssc1_plus_vwum2 
    lda palette_ptr_bram__1
    clc
    adc #<palette_bram
    sta.z palette_ptr_bram__0
    lda palette_ptr_bram__1+1
    adc #>palette_bram
    sta.z palette_ptr_bram__0+1
    // return (palette_ptr_t)&palette_bram.palette_16[(unsigned int)palette_index];
    // [61] palette_ptr_bram::return = palette_ptr_bram::$0
    // palette_ptr_bram::@return
    // }
    // [62] return 
    rts
  .segment DataEnginePalette
    palette_index: .byte 0
    .label palette_ptr_bram__1 = palette_use_vram.memcpy_vram_bram_fast1_doffset_vram
    .label palette_ptr_bram__2 = palette_use_vram.memcpy_vram_bram_fast1_doffset_vram
}
.segment CodeEnginePalette
  // palette_init
// void palette_init(__mem() char bram_bank)
palette_init: {
    .label palette_init__2 = $22
    // palette.bram_bank = bram_bank
    // [63] *((char *)&palette) = palette_init::bram_bank -- _deref_pbuc1=vbum1 
    lda bram_bank
    sta palette
    // [64] phi from palette_init to palette_init::@1 [phi:palette_init->palette_init::@1]
    // [64] phi palette_init::i#2 = 0 [phi:palette_init->palette_init::@1#0] -- vbuxx=vbuc1 
    ldx #0
  // Doubled to save zeropage...
    // palette_init::@1
  __b1:
    // for(unsigned char i=0; i<16; i++)
    // [65] if(palette_init::i#2<$10) goto palette_init::@2 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$10
    bcc __b2
    // palette_init::@3
    // palette.vram.used[0] = 1
    // [66] *((char *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED
    // palette.vram_index = 1
    // [67] *((char *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM_INDEX) = 1 -- _deref_pbuc1=vbuc2 
    sta palette+OFFSET_STRUCT_PALETTE_T_VRAM_INDEX
    // palette.pool = 0
    // [68] *((char *)&palette+OFFSET_STRUCT_PALETTE_T_POOL) = 0 -- _deref_pbuc1=vbuc2 
    // this needs to be revisited, a hardcoding that is meant to skip the tiles, but this will vary during play.
    lda #0
    sta palette+OFFSET_STRUCT_PALETTE_T_POOL
    // palette_init::@return
    // }
    // [69] return 
    rts
    // palette_init::@2
  __b2:
    // (unsigned int)i*(unsigned int)32
    // [70] palette_init::$4 = (unsigned int)palette_init::i#2 -- vwum1=_word_vbuxx 
    txa
    sta palette_init__4
    lda #0
    sta palette_init__4+1
    // VERA_PALETTE_PTR+(unsigned int)((unsigned int)i*(unsigned int)32)
    // [71] palette_init::$5 = palette_init::$4 << 5 -- vwum1=vwum1_rol_5 
    asl palette_init__5
    rol palette_init__5+1
    asl palette_init__5
    rol palette_init__5+1
    asl palette_init__5
    rol palette_init__5+1
    asl palette_init__5
    rol palette_init__5+1
    asl palette_init__5
    rol palette_init__5+1
    // [72] palette_init::$2 = VERA_PALETTE_PTR + palette_init::$5 -- pbuz1=pbuc1_plus_vwum2 
    lda palette_init__5
    clc
    adc #<VERA_PALETTE_PTR
    sta.z palette_init__2
    lda palette_init__5+1
    adc #>VERA_PALETTE_PTR
    sta.z palette_init__2+1
    // palette.vram.offset[i] = (vram_offset_t)(VERA_PALETTE_PTR+(unsigned int)((unsigned int)i*(unsigned int)32))
    // [73] palette_init::$3 = palette_init::i#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [74] ((unsigned int *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_OFFSET)[palette_init::$3] = (unsigned int)palette_init::$2 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z palette_init__2
    sta palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_OFFSET,y
    lda.z palette_init__2+1
    sta palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_OFFSET+1,y
    // palette.vram.used[i] = 0
    // [75] ((char *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED)[palette_init::i#2] = 0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #0
    sta palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED,x
    // for(unsigned char i=0; i<16; i++)
    // [76] palette_init::i#1 = ++ palette_init::i#2 -- vbuxx=_inc_vbuxx 
    inx
    // [64] phi from palette_init::@2 to palette_init::@1 [phi:palette_init::@2->palette_init::@1]
    // [64] phi palette_init::i#2 = palette_init::i#1 [phi:palette_init::@2->palette_init::@1#0] -- register_copy 
    jmp __b1
  .segment DataEnginePalette
    .label bram_bank = palette_use_vram.vram_index
    .label palette_init__4 = palette_use_vram.memcpy_vram_bram_fast1_doffset_vram
    .label palette_init__5 = palette_use_vram.memcpy_vram_bram_fast1_doffset_vram
}
.segment CodeEnginePalette
  // palette_alloc_vram
// __register(A) char palette_alloc_vram()
palette_alloc_vram: {
    // [78] phi from palette_alloc_vram to palette_alloc_vram::@1 [phi:palette_alloc_vram->palette_alloc_vram::@1]
    // [78] phi palette_alloc_vram::vram_index#2 = 1 [phi:palette_alloc_vram->palette_alloc_vram::@1#0] -- vbuxx=vbuc1 
    ldx #1
    // palette_alloc_vram::@1
  __b1:
    // for(unsigned char vram_index=1; vram_index<16; vram_index++)
    // [79] if(palette_alloc_vram::vram_index#2<$10) goto palette_alloc_vram::@2 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$10
    bcc __b2
    // [80] phi from palette_alloc_vram::@1 to palette_alloc_vram::@return [phi:palette_alloc_vram::@1->palette_alloc_vram::@return]
    // [80] phi palette_alloc_vram::return#2 = 0 [phi:palette_alloc_vram::@1->palette_alloc_vram::@return#0] -- vbuaa=vbuc1 
    lda #0
    // palette_alloc_vram::@return
    // }
    // [81] return 
    rts
    // palette_alloc_vram::@2
  __b2:
    // if(palette.vram_index >= 16)
    // [82] if(*((char *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM_INDEX)<$10) goto palette_alloc_vram::@3 -- _deref_pbuc1_lt_vbuc2_then_la1 
    lda palette+OFFSET_STRUCT_PALETTE_T_VRAM_INDEX
    cmp #$10
    bcc __b3
    // palette_alloc_vram::@5
    // palette.vram_index=1
    // [83] *((char *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM_INDEX) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta palette+OFFSET_STRUCT_PALETTE_T_VRAM_INDEX
    // palette_alloc_vram::@3
  __b3:
    // if(!palette.vram.used[palette.vram_index])
    // [84] if(0!=((char *)(struct palette_vram_index_s *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED)[*((char *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM_INDEX)]) goto palette_alloc_vram::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy palette+OFFSET_STRUCT_PALETTE_T_VRAM_INDEX
    lda palette+OFFSET_STRUCT_PALETTE_T_VRAM+OFFSET_STRUCT_PALETTE_VRAM_INDEX_S_USED,y
    cmp #0
    bne __b4
    // palette_alloc_vram::@6
    // return palette.vram_index;
    // [85] palette_alloc_vram::return#1 = *((char *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM_INDEX) -- vbuaa=_deref_pbuc1 
    tya
    // [80] phi from palette_alloc_vram::@6 to palette_alloc_vram::@return [phi:palette_alloc_vram::@6->palette_alloc_vram::@return]
    // [80] phi palette_alloc_vram::return#2 = palette_alloc_vram::return#1 [phi:palette_alloc_vram::@6->palette_alloc_vram::@return#0] -- register_copy 
    rts
    // palette_alloc_vram::@4
  __b4:
    // palette.vram_index++;
    // [86] *((char *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM_INDEX) = ++ *((char *)&palette+OFFSET_STRUCT_PALETTE_T_VRAM_INDEX) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc palette+OFFSET_STRUCT_PALETTE_T_VRAM_INDEX
    // for(unsigned char vram_index=1; vram_index<16; vram_index++)
    // [87] palette_alloc_vram::vram_index#1 = ++ palette_alloc_vram::vram_index#2 -- vbuxx=_inc_vbuxx 
    inx
    // [78] phi from palette_alloc_vram::@4 to palette_alloc_vram::@1 [phi:palette_alloc_vram::@4->palette_alloc_vram::@1]
    // [78] phi palette_alloc_vram::vram_index#2 = palette_alloc_vram::vram_index#1 [phi:palette_alloc_vram::@4->palette_alloc_vram::@1#0] -- register_copy 
    jmp __b1
}
  // Exported Global Data
.segment BramEnginePalette
  palette_bram: .fill equinoxe_palette.SIZEOF_STRUCT_PALETTE_BRAM_S, 0
.segment DataEnginePalette
  palette: .fill equinoxe_palette.SIZEOF_STRUCT_PALETTE_T, 0
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

