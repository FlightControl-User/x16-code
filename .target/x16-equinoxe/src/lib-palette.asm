  // File Comments
  // Library
.namespace lib_palette {
  // Upstart
.cpu _65c02
  
#if __asm_import__
#else

.segmentdef Code                    
.segmentdef CodeEnginePalette       
.segmentdef Data                    
.segmentdef DataEnginePalette       
.segmentdef BramEnginePalette       

#endif
  // Global Constants & labels
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
  // VERA Palette address in VRAM  $1FA00 - $1FBFF
  // 256 entries of 2 bytes
  // byte 0 bits 4-7: Green
  // byte 0 bits 0-3: Blue
  // byte 1 bits 0-3: Red
  .const VERA_PALETTE_BANK = 1
  .const SIZEOF_STRUCT___3 = $1000
  .const SIZEOF_STRUCT___7 = $c3
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
  // __lib_palette_start
// void __lib_palette_start()
__lib_palette_start: {
    // __lib_palette_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __lib_palette_start::@return
    // [3] return 
    rts
}
.segment CodeEnginePalette
  // palette_free_vram
// void palette_free_vram(__zp(2) unsigned int bram_index)
palette_free_vram: {
    .label bram_index = 2
    .label palette_free_vram__0 = 4
    .label palette_free_vram__1 = 2
    // unsigned char vram_index = palette.bram.vram_index[bram_index]
    // [4] palette_free_vram::$0 = (char *)(struct $4 *)&palette+$43 + palette_free_vram::bram_index -- pbuz1=pbuc1_plus_vwuz2 
    lda.z bram_index
    clc
    adc #<palette+$43
    sta.z palette_free_vram__0
    lda.z bram_index+1
    adc #>palette+$43
    sta.z palette_free_vram__0+1
    // [5] palette_free_vram::vram_index#0 = *palette_free_vram::$0 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (palette_free_vram__0),y
    // palette.vram.used[vram_index] = 0
    // [6] ((char *)(struct $5 *)&palette+3+$10)[palette_free_vram::vram_index#0] = 0 -- pbuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta palette+3+$10,y
    // palette.bram.vram_index[bram_index] = 0
    // [7] palette_free_vram::$1 = (char *)(struct $4 *)&palette+$43 + palette_free_vram::bram_index -- pbuz1=pbuc1_plus_vwuz1 
    lda.z palette_free_vram__1
    clc
    adc #<palette+$43
    sta.z palette_free_vram__1
    lda.z palette_free_vram__1+1
    adc #>palette+$43
    sta.z palette_free_vram__1+1
    // [8] *palette_free_vram::$1 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (palette_free_vram__1),y
    // palette_free_vram::@return
    // }
    // [9] return 
    rts
}
  // palette_unuse_vram
// void palette_unuse_vram(__zp(2) unsigned int bram_index)
palette_unuse_vram: {
    .label bram_index = 2
    .label palette_unuse_vram__1 = 4
    // unsigned char vram_index = palette.bram.vram_index[bram_index]
    // [10] palette_unuse_vram::$1 = (char *)(struct $4 *)&palette+$43 + palette_unuse_vram::bram_index -- pbuz1=pbuc1_plus_vwuz2 
    lda.z bram_index
    clc
    adc #<palette+$43
    sta.z palette_unuse_vram__1
    lda.z bram_index+1
    adc #>palette+$43
    sta.z palette_unuse_vram__1+1
    // [11] palette_unuse_vram::vram_index#0 = *palette_unuse_vram::$1 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (palette_unuse_vram__1),y
    // palette.vram.used[vram_index]--;
    // [12] ((char *)(struct $5 *)&palette+3+$10)[palette_unuse_vram::vram_index#0] = -- ((char *)(struct $5 *)&palette+3+$10)[palette_unuse_vram::vram_index#0] -- pbuc1_derefidx_vbuaa=_dec_pbuc1_derefidx_vbuaa 
    tax
    dec palette+3+$10,x
    // palette_unuse_vram::@return
    // }
    // [13] return 
    rts
}
  // palette_use_vram
// __zp(6) char palette_use_vram(__zp(8) char palette_index)
palette_use_vram: {
    .label palette_index = 8
    .label return = 6
    .label vram_index = 6
    .label memcpy_vram_bram_fast1_doffset_vram = 4
    .label memcpy_vram_bram_fast1_sptr_bram = 2
    // unsigned char vram_index = palette.bram.vram_index[palette_index]
    // [14] palette_use_vram::vram_index#0 = ((char *)(struct $4 *)&palette+$43)[palette_use_vram::palette_index] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z palette_index
    lda palette+$43,y
    sta.z vram_index
    // if(!vram_index)
    // [15] if(0!=palette_use_vram::vram_index#0) goto palette_use_vram::@1 -- 0_neq_vbuz1_then_la1 
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
    // [19] palette_use_vram::vram_index#1 = palette_alloc_vram::return#3 -- vbuz1=vbuaa 
    sta.z vram_index
    // if(vram_index)
    // [20] if(0==palette_use_vram::vram_index#1) goto palette_use_vram::@1 -- 0_eq_vbuz1_then_la1 
    beq __b1
    // palette_use_vram::@3
    // if(palette.vram.bram_index[vram_index])
    // [21] if(0==((char *)(struct $5 *)&palette+3)[palette_use_vram::vram_index#1]) goto palette_use_vram::@5 -- 0_eq_pbuc1_derefidx_vbuz1_then_la1 
    tay
    lda palette+3,y
    cmp #0
    beq __b5
    // palette_use_vram::@4
    // palette.bram.vram_index[palette.vram.bram_index[vram_index]] = 0
    // [22] ((char *)(struct $4 *)&palette+$43)[((char *)(struct $5 *)&palette+3)[palette_use_vram::vram_index#1]] = 0 -- pbuc1_derefidx_(pbuc2_derefidx_vbuz1)=vbuc3 
    lda #0
    ldx palette+3,y
    sta palette+$43,x
    // palette_use_vram::@5
  __b5:
    // palette.vram.bram_index[vram_index] = palette_index
    // [23] ((char *)(struct $5 *)&palette+3)[palette_use_vram::vram_index#1] = palette_use_vram::palette_index -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z palette_index
    ldy.z vram_index
    sta palette+3,y
    // palette_ptr_bram(palette_index)
    // [24] palette_ptr_bram::palette_index = palette_use_vram::palette_index -- vbuz1=vbuz2 
    sta.z palette_ptr_bram.palette_index
    // [25] callexecute palette_ptr_bram  -- call_var_near 
    jsr palette_ptr_bram
    // [26] palette_use_vram::memcpy_vram_bram_fast1_sptr_bram#0 = palette_ptr_bram::return
    // memcpy_vram_bram_fast(VERA_PALETTE_BANK, palette.vram.offset[vram_index], palette.bram_bank, (bram_ptr_t)palette_ptr_bram(palette_index), 32)
    // [27] palette_use_vram::$8 = palette_use_vram::vram_index#1 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z vram_index
    asl
    // [28] palette_use_vram::memcpy_vram_bram_fast1_doffset_vram#0 = ((unsigned int *)(struct $5 *)&palette+3+$20)[palette_use_vram::$8] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda palette+3+$20,y
    sta.z memcpy_vram_bram_fast1_doffset_vram
    lda palette+3+$20+1,y
    sta.z memcpy_vram_bram_fast1_doffset_vram+1
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
    // [34] palette_use_vram::memcpy_vram_bram_fast1_$1 = byte0  palette_use_vram::memcpy_vram_bram_fast1_doffset_vram#0 -- vbuaa=_byte0_vwuz1 
    lda.z memcpy_vram_bram_fast1_doffset_vram
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [35] *VERA_ADDRX_L = palette_use_vram::memcpy_vram_bram_fast1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [36] palette_use_vram::memcpy_vram_bram_fast1_$2 = byte1  palette_use_vram::memcpy_vram_bram_fast1_doffset_vram#0 -- vbuaa=_byte1_vwuz1 
    lda.z memcpy_vram_bram_fast1_doffset_vram+1
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
    // [45] ((char *)(struct $4 *)&palette+$43)[palette_use_vram::palette_index] = palette_use_vram::vram_index#1 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z vram_index
    ldy.z palette_index
    sta palette+$43,y
    // [46] phi from palette_use_vram palette_use_vram::@6 palette_use_vram::@7 to palette_use_vram::@1 [phi:palette_use_vram/palette_use_vram::@6/palette_use_vram::@7->palette_use_vram::@1]
    // [46] phi palette_use_vram::vram_index#2 = palette_use_vram::vram_index#0 [phi:palette_use_vram/palette_use_vram::@6/palette_use_vram::@7->palette_use_vram::@1#0] -- register_copy 
    // palette_use_vram::@1
  __b1:
    // palette.vram.used[vram_index]++;
    // [47] ((char *)(struct $5 *)&palette+3+$10)[palette_use_vram::vram_index#2] = ++ ((char *)(struct $5 *)&palette+3+$10)[palette_use_vram::vram_index#2] -- pbuc1_derefidx_vbuz1=_inc_pbuc1_derefidx_vbuz1 
    ldx.z vram_index
    inc palette+3+$10,x
    // return vram_index;
    // [48] palette_use_vram::return = palette_use_vram::vram_index#2
    // palette_use_vram::@return
    // }
    // [49] return 
    rts
}
  // palette_alloc_bram
// __zp(6) char palette_alloc_bram()
palette_alloc_bram: {
    .label return = 6
  // Search for an empty slot.
  // There are a maximum of 64 different palettes that can be loaded in bram.
    // palette_alloc_bram::@1
  __b1:
    // while(palette.bram.used[palette.pool])
    // [51] if(0!=((char *)(struct $4 *)&palette+$43+$40)[*((char *)&palette+1)]) goto palette_alloc_bram::@2 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy palette+1
    lda palette+$43+$40,y
    cmp #0
    bne __b2
    // palette_alloc_bram::@3
    // palette.bram.used[palette.pool] = 1
    // [52] ((char *)(struct $4 *)&palette+$43+$40)[*((char *)&palette+1)] = 1 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #1
    sta palette+$43+$40,y
    // return palette.pool;
    // [53] palette_alloc_bram::return = *((char *)&palette+1) -- vbuz1=_deref_pbuc1 
    tya
    sta.z return
    // palette_alloc_bram::@return
    // }
    // [54] return 
    rts
    // palette_alloc_bram::@2
  __b2:
    // palette.pool + 1
    // [55] palette_alloc_bram::$0 = *((char *)&palette+1) + 1 -- vbuaa=_deref_pbuc1_plus_1 
    lda palette+1
    inc
    // (palette.pool + 1) % 64
    // [56] palette_alloc_bram::$1 = palette_alloc_bram::$0 & $40-1 -- vbuaa=vbuaa_band_vbuc1 
    and #$40-1
    // palette.pool = (palette.pool + 1) % 64
    // [57] *((char *)&palette+1) = palette_alloc_bram::$1 -- _deref_pbuc1=vbuaa 
    sta palette+1
    jmp __b1
}
  // palette_ptr_bram
/**
 * @brief Return the address of palette slot in bram. 
 * 
 * @return palette_ptr_t The address in bram. Note that the bank must be properly set to use the data behind the pointer.
 */
// __zp(2) struct $1 * palette_ptr_bram(__zp(7) char palette_index)
palette_ptr_bram: {
    .label palette_index = 7
    .label return = 2
    .label palette_ptr_bram__0 = 2
    .label palette_ptr_bram__1 = 2
    .label palette_ptr_bram__2 = 2
    // &palette_bram.palette_16[(unsigned int)palette_index]
    // [58] palette_ptr_bram::$2 = (unsigned int)palette_ptr_bram::palette_index -- vwuz1=_word_vbuz2 
    lda.z palette_index
    sta.z palette_ptr_bram__2
    lda #0
    sta.z palette_ptr_bram__2+1
    // [59] palette_ptr_bram::$1 = palette_ptr_bram::$2 << 5 -- vwuz1=vwuz1_rol_5 
    asl.z palette_ptr_bram__1
    rol.z palette_ptr_bram__1+1
    asl.z palette_ptr_bram__1
    rol.z palette_ptr_bram__1+1
    asl.z palette_ptr_bram__1
    rol.z palette_ptr_bram__1+1
    asl.z palette_ptr_bram__1
    rol.z palette_ptr_bram__1+1
    asl.z palette_ptr_bram__1
    rol.z palette_ptr_bram__1+1
    // [60] palette_ptr_bram::$0 = (struct $1 *)&palette_bram + palette_ptr_bram::$1 -- pssz1=pssc1_plus_vwuz1 
    lda.z palette_ptr_bram__0
    clc
    adc #<palette_bram
    sta.z palette_ptr_bram__0
    lda.z palette_ptr_bram__0+1
    adc #>palette_bram
    sta.z palette_ptr_bram__0+1
    // return (palette_ptr_t)&palette_bram.palette_16[(unsigned int)palette_index];
    // [61] palette_ptr_bram::return = palette_ptr_bram::$0
    // palette_ptr_bram::@return
    // }
    // [62] return 
    rts
}
  // palette_init
// void palette_init(__zp(7) char bram_bank)
palette_init: {
    .label bram_bank = 7
    .label palette_init__2 = 4
    .label palette_init__4 = 4
    .label palette_init__5 = 4
    // palette.bram_bank = bram_bank
    // [63] *((char *)&palette) = palette_init::bram_bank -- _deref_pbuc1=vbuz1 
    lda.z bram_bank
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
    // [66] *((char *)(struct $5 *)&palette+3+$10) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta palette+3+$10
    // palette.vram_index = 1
    // [67] *((char *)&palette+2) = 1 -- _deref_pbuc1=vbuc2 
    sta palette+2
    // palette.pool = 0
    // [68] *((char *)&palette+1) = 0 -- _deref_pbuc1=vbuc2 
    // this needs to be revisited, a hardcoding that is meant to skip the tiles, but this will vary during play.
    lda #0
    sta palette+1
    // palette_init::@return
    // }
    // [69] return 
    rts
    // palette_init::@2
  __b2:
    // (unsigned int)i*(unsigned int)32
    // [70] palette_init::$4 = (unsigned int)palette_init::i#2 -- vwuz1=_word_vbuxx 
    txa
    sta.z palette_init__4
    lda #0
    sta.z palette_init__4+1
    // VERA_PALETTE_PTR+(unsigned int)((unsigned int)i*(unsigned int)32)
    // [71] palette_init::$5 = palette_init::$4 << 5 -- vwuz1=vwuz1_rol_5 
    asl.z palette_init__5
    rol.z palette_init__5+1
    asl.z palette_init__5
    rol.z palette_init__5+1
    asl.z palette_init__5
    rol.z palette_init__5+1
    asl.z palette_init__5
    rol.z palette_init__5+1
    asl.z palette_init__5
    rol.z palette_init__5+1
    // [72] palette_init::$2 = VERA_PALETTE_PTR + palette_init::$5 -- pbuz1=pbuc1_plus_vwuz1 
    lda.z palette_init__2
    clc
    adc #<VERA_PALETTE_PTR
    sta.z palette_init__2
    lda.z palette_init__2+1
    adc #>VERA_PALETTE_PTR
    sta.z palette_init__2+1
    // palette.vram.offset[i] = (vram_offset_t)(VERA_PALETTE_PTR+(unsigned int)((unsigned int)i*(unsigned int)32))
    // [73] palette_init::$3 = palette_init::i#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [74] ((unsigned int *)(struct $5 *)&palette+3+$20)[palette_init::$3] = (unsigned int)palette_init::$2 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z palette_init__2
    sta palette+3+$20,y
    lda.z palette_init__2+1
    sta palette+3+$20+1,y
    // palette.vram.used[i] = 0
    // [75] ((char *)(struct $5 *)&palette+3+$10)[palette_init::i#2] = 0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #0
    sta palette+3+$10,x
    // for(unsigned char i=0; i<16; i++)
    // [76] palette_init::i#1 = ++ palette_init::i#2 -- vbuxx=_inc_vbuxx 
    inx
    // [64] phi from palette_init::@2 to palette_init::@1 [phi:palette_init::@2->palette_init::@1]
    // [64] phi palette_init::i#2 = palette_init::i#1 [phi:palette_init::@2->palette_init::@1#0] -- register_copy 
    jmp __b1
}
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
    // [82] if(*((char *)&palette+2)<$10) goto palette_alloc_vram::@3 -- _deref_pbuc1_lt_vbuc2_then_la1 
    lda palette+2
    cmp #$10
    bcc __b3
    // palette_alloc_vram::@5
    // palette.vram_index=1
    // [83] *((char *)&palette+2) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta palette+2
    // palette_alloc_vram::@3
  __b3:
    // if(!palette.vram.used[palette.vram_index])
    // [84] if(0!=((char *)(struct $5 *)&palette+3+$10)[*((char *)&palette+2)]) goto palette_alloc_vram::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy palette+2
    lda palette+3+$10,y
    cmp #0
    bne __b4
    // palette_alloc_vram::@6
    // return palette.vram_index;
    // [85] palette_alloc_vram::return#1 = *((char *)&palette+2) -- vbuaa=_deref_pbuc1 
    tya
    // [80] phi from palette_alloc_vram::@6 to palette_alloc_vram::@return [phi:palette_alloc_vram::@6->palette_alloc_vram::@return]
    // [80] phi palette_alloc_vram::return#2 = palette_alloc_vram::return#1 [phi:palette_alloc_vram::@6->palette_alloc_vram::@return#0] -- register_copy 
    rts
    // palette_alloc_vram::@4
  __b4:
    // palette.vram_index++;
    // [86] *((char *)&palette+2) = ++ *((char *)&palette+2) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc palette+2
    // for(unsigned char vram_index=1; vram_index<16; vram_index++)
    // [87] palette_alloc_vram::vram_index#1 = ++ palette_alloc_vram::vram_index#2 -- vbuxx=_inc_vbuxx 
    inx
    // [78] phi from palette_alloc_vram::@4 to palette_alloc_vram::@1 [phi:palette_alloc_vram::@4->palette_alloc_vram::@1]
    // [78] phi palette_alloc_vram::vram_index#2 = palette_alloc_vram::vram_index#1 [phi:palette_alloc_vram::@4->palette_alloc_vram::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment BramEnginePalette
  palette_bram: .fill SIZEOF_STRUCT___3, 0
.segment DataEnginePalette
  palette: .fill SIZEOF_STRUCT___7, 0
}
