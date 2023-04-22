
  // Global Constants & labels
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
  // VERA Palette address in VRAM  $1FA00 - $1FBFF
  // 256 entries of 2 bytes
  // byte 0 bits 4-7: Green
  // byte 0 bits 0-3: Blue
  // byte 1 bits 0-3: Red
  .const VERA_PALETTE_BANK = 1
  .const STACK_BASE = $103
  .const isr_vsync = $314
  .const SIZEOF_STRUCT___2 = $1000
  .const SIZEOF_STRUCT___6 = $c3
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
  // __start
__start: {
    // __start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // [3] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [4] call main
    // [86] phi from __start::@1 to main [phi:__start::@1->main] -- call_phi_near 
    jsr main
    // __start::@return
    // [5] return 
    rts
}
.segment CodeEnginePalette
  // palette_free_vram
// void palette_free_vram(__mem() unsigned int bram_index)
palette_free_vram: {
    .const OFFSET_STACK_BRAM_INDEX = 0
    // [6] palette_free_vram::bram_index#0 = stackidx(unsigned int,palette_free_vram::OFFSET_STACK_BRAM_INDEX) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_INDEX,x
    sta bram_index
    lda STACK_BASE+OFFSET_STACK_BRAM_INDEX+1,x
    sta bram_index+1
    // unsigned char vram_index = palette.bram.vram_index[bram_index]
    // [7] palette_free_vram::$0 = (char *)(struct $3 *)&palette+$43 + palette_free_vram::bram_index#0 -- pbum1=pbuc1_plus_vwum2 
    lda bram_index
    clc
    adc #<palette+$43
    sta palette_free_vram__0
    lda bram_index+1
    adc #>palette+$43
    sta palette_free_vram__0+1
    // [8] palette_free_vram::vram_index#0 = *palette_free_vram::$0 -- vbuaa=_deref_pbum1 
    ldy palette_free_vram__0
    sty.z $fe
    tay
    sty.z $ff
    ldy #0
    lda ($fe),y
    // palette.vram.used[vram_index] = 0
    // [9] ((char *)(struct $4 *)&palette+3+$10)[palette_free_vram::vram_index#0] = 0 -- pbuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta palette+3+$10,y
    // palette.bram.vram_index[bram_index] = 0
    // [10] palette_free_vram::$1 = (char *)(struct $3 *)&palette+$43 + palette_free_vram::bram_index#0 -- pbum1=pbuc1_plus_vwum2 
    lda bram_index
    clc
    adc #<palette+$43
    sta palette_free_vram__1
    lda bram_index+1
    adc #>palette+$43
    sta palette_free_vram__1+1
    // [11] *palette_free_vram::$1 = 0 -- _deref_pbum1=vbuc1 
    lda #0
    ldy palette_free_vram__1
    sty.z $fe
    ldy palette_free_vram__1+1
    sty.z $ff
    tay
    sta ($fe),y
    // palette_free_vram::@return
    // }
    // [12] return 
    rts
  .segment Data
    bram_index: .word 0
  .segment DataEnginePalette
    palette_free_vram__0: .word 0
    .label palette_free_vram__1 = palette_free_vram__0
}
.segment CodeEnginePalette
  // palette_unuse_vram
// void palette_unuse_vram(__mem() unsigned int bram_index)
palette_unuse_vram: {
    .const OFFSET_STACK_BRAM_INDEX = 0
    // [13] palette_unuse_vram::bram_index#0 = stackidx(unsigned int,palette_unuse_vram::OFFSET_STACK_BRAM_INDEX) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_INDEX,x
    sta bram_index
    lda STACK_BASE+OFFSET_STACK_BRAM_INDEX+1,x
    sta bram_index+1
    // unsigned char vram_index = palette.bram.vram_index[bram_index]
    // [14] palette_unuse_vram::$1 = (char *)(struct $3 *)&palette+$43 + palette_unuse_vram::bram_index#0 -- pbum1=pbuc1_plus_vwum1 
    lda palette_unuse_vram__1
    clc
    adc #<palette+$43
    sta palette_unuse_vram__1
    lda palette_unuse_vram__1+1
    adc #>palette+$43
    sta palette_unuse_vram__1+1
    // [15] palette_unuse_vram::vram_index#0 = *palette_unuse_vram::$1 -- vbuaa=_deref_pbum1 
    ldy palette_unuse_vram__1
    sty.z $fe
    tay
    sty.z $ff
    ldy #0
    lda ($fe),y
    // palette.vram.used[vram_index]--;
    // [16] ((char *)(struct $4 *)&palette+3+$10)[palette_unuse_vram::vram_index#0] = -- ((char *)(struct $4 *)&palette+3+$10)[palette_unuse_vram::vram_index#0] -- pbuc1_derefidx_vbuaa=_dec_pbuc1_derefidx_vbuaa 
    tax
    dec palette+3+$10,x
    // palette_unuse_vram::@return
    // }
    // [17] return 
    rts
  .segment Data
    .label bram_index = palette_unuse_vram__1
  .segment DataEnginePalette
    palette_unuse_vram__1: .word 0
}
.segment CodeEnginePalette
  // palette_use_vram
// __mem() char palette_use_vram(__mem() char palette_index)
palette_use_vram: {
    .const OFFSET_STACK_PALETTE_INDEX = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [18] palette_use_vram::palette_index#0 = stackidx(char,palette_use_vram::OFFSET_STACK_PALETTE_INDEX) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_PALETTE_INDEX,x
    sta palette_index
    // unsigned char vram_index = palette.bram.vram_index[palette_index]
    // [19] palette_use_vram::vram_index#0 = ((char *)(struct $3 *)&palette+$43)[palette_use_vram::palette_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    tay
    lda palette+$43,y
    sta vram_index
    // if(!vram_index)
    // [20] if(0!=palette_use_vram::vram_index#0) goto palette_use_vram::@1 -- 0_neq_vbum1_then_la1 
    beq !__b1+
    jmp __b1
  !__b1:
    // [21] phi from palette_use_vram to palette_use_vram::@2 [phi:palette_use_vram->palette_use_vram::@2]
    // palette_use_vram::@2
    // palette_alloc_vram()
    // [22] call palette_alloc_vram
    // [88] phi from palette_use_vram::@2 to palette_alloc_vram [phi:palette_use_vram::@2->palette_alloc_vram] -- call_phi_near 
    jsr palette_alloc_vram
    // palette_alloc_vram()
    // [23] palette_alloc_vram::return#3 = palette_alloc_vram::return#2
    // palette_use_vram::@7
    // vram_index = palette_alloc_vram()
    // [24] palette_use_vram::vram_index#1 = palette_alloc_vram::return#3 -- vbum1=vbuaa 
    sta vram_index
    // if(vram_index)
    // [25] if(0==palette_use_vram::vram_index#1) goto palette_use_vram::@1 -- 0_eq_vbum1_then_la1 
    beq __b1
    // palette_use_vram::@3
    // if(palette.vram.bram_index[vram_index])
    // [26] if(0==((char *)(struct $4 *)&palette+3)[palette_use_vram::vram_index#1]) goto palette_use_vram::@5 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    tay
    lda palette+3,y
    cmp #0
    beq __b5
    // palette_use_vram::@4
    // palette.bram.vram_index[palette.vram.bram_index[vram_index]] = 0
    // [27] ((char *)(struct $3 *)&palette+$43)[((char *)(struct $4 *)&palette+3)[palette_use_vram::vram_index#1]] = 0 -- pbuc1_derefidx_(pbuc2_derefidx_vbum1)=vbuc3 
    lda #0
    ldx palette+3,y
    sta palette+$43,x
    // palette_use_vram::@5
  __b5:
    // palette.vram.bram_index[vram_index] = palette_index
    // [28] ((char *)(struct $4 *)&palette+3)[palette_use_vram::vram_index#1] = palette_use_vram::palette_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda palette_index
    ldy vram_index
    sta palette+3,y
    // palette_ptr_bram(palette_index)
    // [29] stackpush(char) = palette_use_vram::palette_index#0 -- _stackpushbyte_=vbum1 
    pha
    // sideeffect stackpushpadding(1) -- _stackpushpadding_1 
    pha
    // [31] callexecute palette_ptr_bram  -- call_vprc1 
    jsr palette_ptr_bram
    // [32] palette_use_vram::memcpy_vram_bram_fast1_sptr_bram#0 = stackpull(struct $0 *) -- pssm1=_stackpullptr_ 
    pla
    sta memcpy_vram_bram_fast1_sptr_bram
    pla
    sta memcpy_vram_bram_fast1_sptr_bram+1
    // memcpy_vram_bram_fast(VERA_PALETTE_BANK, palette.vram.offset[vram_index], palette.bram_bank, (bram_ptr_t)palette_ptr_bram(palette_index), 32)
    // [33] palette_use_vram::$8 = palette_use_vram::vram_index#1 << 1 -- vbuaa=vbum1_rol_1 
    lda vram_index
    asl
    // [34] palette_use_vram::memcpy_vram_bram_fast1_doffset_vram#0 = ((unsigned int *)(struct $4 *)&palette+3+$20)[palette_use_vram::$8] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda palette+3+$20,y
    sta memcpy_vram_bram_fast1_doffset_vram
    lda palette+3+$20+1,y
    sta memcpy_vram_bram_fast1_doffset_vram+1
    // [35] palette_use_vram::memcpy_vram_bram_fast1_sbank_bram#0 = *((char *)&palette) -- vbuxx=_deref_pbuc1 
    ldx palette
    // [36] phi from palette_use_vram::@5 to palette_use_vram::memcpy_vram_bram_fast1 [phi:palette_use_vram::@5->palette_use_vram::memcpy_vram_bram_fast1]
    // palette_use_vram::memcpy_vram_bram_fast1
    // palette_use_vram::memcpy_vram_bram_fast1_bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [38] BRAM = palette_use_vram::memcpy_vram_bram_fast1_sbank_bram#0 -- vbuz1=vbuxx 
    stx.z BRAM
    // palette_use_vram::memcpy_vram_bram_fast1_@3
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [39] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [40] palette_use_vram::memcpy_vram_bram_fast1_$1 = byte0  palette_use_vram::memcpy_vram_bram_fast1_doffset_vram#0 -- vbuaa=_byte0_vwum1 
    lda memcpy_vram_bram_fast1_doffset_vram
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [41] *VERA_ADDRX_L = palette_use_vram::memcpy_vram_bram_fast1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [42] palette_use_vram::memcpy_vram_bram_fast1_$2 = byte1  palette_use_vram::memcpy_vram_bram_fast1_doffset_vram#0 -- vbuaa=_byte1_vwum1 
    lda memcpy_vram_bram_fast1_doffset_vram+1
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [43] *VERA_ADDRX_M = palette_use_vram::memcpy_vram_bram_fast1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [44] *VERA_ADDRX_H = VERA_PALETTE_BANK|VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_PALETTE_BANK|VERA_INC_1
    sta VERA_ADDRX_H
    // [45] phi from palette_use_vram::memcpy_vram_bram_fast1_@3 to palette_use_vram::memcpy_vram_bram_fast1_@1 [phi:palette_use_vram::memcpy_vram_bram_fast1_@3->palette_use_vram::memcpy_vram_bram_fast1_@1]
    // [45] phi palette_use_vram::memcpy_vram_bram_fast1_num#2 = $20 [phi:palette_use_vram::memcpy_vram_bram_fast1_@3->palette_use_vram::memcpy_vram_bram_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #$20
    // [45] phi palette_use_vram::memcpy_vram_bram_fast1_add#2 = 0 [phi:palette_use_vram::memcpy_vram_bram_fast1_@3->palette_use_vram::memcpy_vram_bram_fast1_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [45] phi from palette_use_vram::memcpy_vram_bram_fast1_@1 to palette_use_vram::memcpy_vram_bram_fast1_@1 [phi:palette_use_vram::memcpy_vram_bram_fast1_@1->palette_use_vram::memcpy_vram_bram_fast1_@1]
    // [45] phi palette_use_vram::memcpy_vram_bram_fast1_num#2 = palette_use_vram::memcpy_vram_bram_fast1_num#1 [phi:palette_use_vram::memcpy_vram_bram_fast1_@1->palette_use_vram::memcpy_vram_bram_fast1_@1#0] -- register_copy 
    // [45] phi palette_use_vram::memcpy_vram_bram_fast1_add#2 = palette_use_vram::memcpy_vram_bram_fast1_add#1 [phi:palette_use_vram::memcpy_vram_bram_fast1_@1->palette_use_vram::memcpy_vram_bram_fast1_@1#1] -- register_copy 
    // palette_use_vram::memcpy_vram_bram_fast1_@1
  memcpy_vram_bram_fast1___b1:
    // *VERA_DATA0 = sptr_bram[add]
    // [46] *VERA_DATA0 = ((char *)palette_use_vram::memcpy_vram_bram_fast1_sptr_bram#0)[palette_use_vram::memcpy_vram_bram_fast1_add#2] -- _deref_pbuc1=pbum1_derefidx_vbuyy 
    lda memcpy_vram_bram_fast1_sptr_bram
    sta.z $fe
    lda memcpy_vram_bram_fast1_sptr_bram+1
    sta.z $ff
    lda ($fe),y
    sta VERA_DATA0
    // add++;
    // [47] palette_use_vram::memcpy_vram_bram_fast1_add#1 = ++ palette_use_vram::memcpy_vram_bram_fast1_add#2 -- vbuyy=_inc_vbuyy 
    iny
    // num--;
    // [48] palette_use_vram::memcpy_vram_bram_fast1_num#1 = -- palette_use_vram::memcpy_vram_bram_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [49] if(0!=palette_use_vram::memcpy_vram_bram_fast1_num#1) goto palette_use_vram::memcpy_vram_bram_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memcpy_vram_bram_fast1___b1
    // palette_use_vram::memcpy_vram_bram_fast1_bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // palette_use_vram::@6
    // palette.bram.vram_index[palette_index] = vram_index
    // [51] ((char *)(struct $3 *)&palette+$43)[palette_use_vram::palette_index#0] = palette_use_vram::vram_index#1 -- pbuc1_derefidx_vbum1=vbum2 
    lda vram_index
    ldy palette_index
    sta palette+$43,y
    // [52] phi from palette_use_vram palette_use_vram::@6 palette_use_vram::@7 to palette_use_vram::@1 [phi:palette_use_vram/palette_use_vram::@6/palette_use_vram::@7->palette_use_vram::@1]
    // [52] phi palette_use_vram::return#0 = palette_use_vram::vram_index#0 [phi:palette_use_vram/palette_use_vram::@6/palette_use_vram::@7->palette_use_vram::@1#0] -- register_copy 
    // palette_use_vram::@1
  __b1:
    // palette.vram.used[vram_index]++;
    // [53] ((char *)(struct $4 *)&palette+3+$10)[palette_use_vram::return#0] = ++ ((char *)(struct $4 *)&palette+3+$10)[palette_use_vram::return#0] -- pbuc1_derefidx_vbum1=_inc_pbuc1_derefidx_vbum1 
    ldx return
    inc palette+3+$10,x
    // palette_use_vram::@return
    // }
    // [54] stackidx(char,palette_use_vram::OFFSET_STACK_RETURN_0) = palette_use_vram::return#0 -- _stackidxbyte_vbuc1=vbum1 
    txa
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    // [55] return 
    rts
  .segment Data
    palette_index: .byte 0
  .segment DataEnginePalette
    .label vram_index = return
  .segment Data
    return: .byte 0
  .segment DataEnginePalette
    memcpy_vram_bram_fast1_doffset_vram: .word 0
    memcpy_vram_bram_fast1_sptr_bram: .word 0
}
.segment CodeEnginePalette
  // palette_alloc_bram
palette_alloc_bram: {
    .const OFFSET_STACK_RETURN_0 = 0
  // Search for an empty slot.
  // There are a maximum of 64 different palettes that can be loaded in bram.
    // palette_alloc_bram::@1
  __b1:
    // while(palette.bram.used[palette.pool])
    // [57] if(0!=((char *)(struct $3 *)&palette+$43+$40)[*((char *)&palette+1)]) goto palette_alloc_bram::@2 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy palette+1
    lda palette+$43+$40,y
    cmp #0
    bne __b2
    // palette_alloc_bram::@3
    // palette.bram.used[palette.pool] = 1
    // [58] ((char *)(struct $3 *)&palette+$43+$40)[*((char *)&palette+1)] = 1 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #1
    sta palette+$43+$40,y
    // return palette.pool;
    // [59] palette_alloc_bram::return#0 = *((char *)&palette+1) -- vbuaa=_deref_pbuc1 
    tya
    // palette_alloc_bram::@return
    // }
    // [60] stackidx(char,palette_alloc_bram::OFFSET_STACK_RETURN_0) = palette_alloc_bram::return#0 -- _stackidxbyte_vbuc1=vbuaa 
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    // [61] return 
    rts
    // palette_alloc_bram::@2
  __b2:
    // palette.pool + 1
    // [62] palette_alloc_bram::$0 = *((char *)&palette+1) + 1 -- vbuaa=_deref_pbuc1_plus_1 
    lda palette+1
    inc
    // (palette.pool + 1) % 64
    // [63] palette_alloc_bram::$1 = palette_alloc_bram::$0 & $40-1 -- vbuaa=vbuaa_band_vbuc1 
    and #$40-1
    // palette.pool = (palette.pool + 1) % 64
    // [64] *((char *)&palette+1) = palette_alloc_bram::$1 -- _deref_pbuc1=vbuaa 
    sta palette+1
    jmp __b1
}
  // palette_ptr_bram
/**
 * @brief Return the address of palette slot in bram. 
 * 
 * @return palette_ptr_t The address in bram. Note that the bank must be properly set to use the data behind the pointer.
 */
// __mem() struct $0 * palette_ptr_bram(__register(A) char palette_index)
palette_ptr_bram: {
    .const OFFSET_STACK_PALETTE_INDEX = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [65] palette_ptr_bram::palette_index#0 = stackidx(char,palette_ptr_bram::OFFSET_STACK_PALETTE_INDEX) -- vbuaa=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_PALETTE_INDEX,x
    // &palette_bram.palette_16[(unsigned int)palette_index]
    // [66] palette_ptr_bram::$2 = (unsigned int)palette_ptr_bram::palette_index#0 -- vwum1=_word_vbuaa 
    sta palette_ptr_bram__2
    lda #0
    sta palette_ptr_bram__2+1
    // [67] palette_ptr_bram::$1 = palette_ptr_bram::$2 << 5 -- vwum1=vwum1_rol_5 
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
    // [68] palette_ptr_bram::return#0 = (struct $0 *)&palette_bram + palette_ptr_bram::$1 -- pssm1=pssc1_plus_vwum1 
    lda return
    clc
    adc #<palette_bram
    sta return
    lda return+1
    adc #>palette_bram
    sta return+1
    // palette_ptr_bram::@return
    // }
    // [69] stackidx(struct $0 *,palette_ptr_bram::OFFSET_STACK_RETURN_0) = palette_ptr_bram::return#0 -- _stackidxptr_vbuc1=pssm1 
    tsx
    lda return
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [70] return 
    rts
  .segment DataEnginePalette
    .label palette_ptr_bram__1 = return
    .label palette_ptr_bram__2 = return
  .segment Data
    return: .word 0
}
.segment CodeEnginePalette
  // palette_init
// void palette_init(__register(A) char bram_bank)
palette_init: {
    .const OFFSET_STACK_BRAM_BANK = 0
    // [71] palette_init::bram_bank#0 = stackidx(char,palette_init::OFFSET_STACK_BRAM_BANK) -- vbuaa=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_BANK,x
    // palette.bram_bank = bram_bank
    // [72] *((char *)&palette) = palette_init::bram_bank#0 -- _deref_pbuc1=vbuaa 
    sta palette
    // [73] phi from palette_init to palette_init::@1 [phi:palette_init->palette_init::@1]
    // [73] phi palette_init::i#2 = 0 [phi:palette_init->palette_init::@1#0] -- vbuxx=vbuc1 
    ldx #0
  // Doubled to save zeropage...
    // palette_init::@1
  __b1:
    // for(unsigned char i=0; i<16; i++)
    // [74] if(palette_init::i#2<$10) goto palette_init::@2 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$10
    bcc __b2
    // palette_init::@3
    // palette.vram.used[0] = 1
    // [75] *((char *)(struct $4 *)&palette+3+$10) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta palette+3+$10
    // palette.vram_index = 1
    // [76] *((char *)&palette+2) = 1 -- _deref_pbuc1=vbuc2 
    sta palette+2
    // palette.pool = 0
    // [77] *((char *)&palette+1) = 0 -- _deref_pbuc1=vbuc2 
    // this needs to be revisited, a hardcoding that is meant to skip the tiles, but this will vary during play.
    lda #0
    sta palette+1
    // palette_init::@return
    // }
    // [78] return 
    rts
    // palette_init::@2
  __b2:
    // (unsigned int)i*32
    // [79] palette_init::$4 = (unsigned int)palette_init::i#2 -- vwum1=_word_vbuxx 
    txa
    sta palette_init__4
    lda #0
    sta palette_init__4+1
    // [80] palette_init::$1 = palette_init::$4 << 5 -- vwum1=vwum1_rol_5 
    asl palette_init__1
    rol palette_init__1+1
    asl palette_init__1
    rol palette_init__1+1
    asl palette_init__1
    rol palette_init__1+1
    asl palette_init__1
    rol palette_init__1+1
    asl palette_init__1
    rol palette_init__1+1
    // VERA_PALETTE_PTR+((unsigned int)i*32)
    // [81] palette_init::$2 = VERA_PALETTE_PTR + palette_init::$1 -- pbum1=pbuc1_plus_vwum1 
    lda palette_init__2
    clc
    adc #<VERA_PALETTE_PTR
    sta palette_init__2
    lda palette_init__2+1
    adc #>VERA_PALETTE_PTR
    sta palette_init__2+1
    // palette.vram.offset[i] = (vram_offset_t)(VERA_PALETTE_PTR+((unsigned int)i*32))
    // [82] palette_init::$3 = palette_init::i#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [83] ((unsigned int *)(struct $4 *)&palette+3+$20)[palette_init::$3] = (unsigned int)palette_init::$2 -- pwuc1_derefidx_vbuaa=vwum1 
    tay
    lda palette_init__2
    sta palette+3+$20,y
    lda palette_init__2+1
    sta palette+3+$20+1,y
    // palette.vram.used[i] = 0
    // [84] ((char *)(struct $4 *)&palette+3+$10)[palette_init::i#2] = 0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #0
    sta palette+3+$10,x
    // for(unsigned char i=0; i<16; i++)
    // [85] palette_init::i#1 = ++ palette_init::i#2 -- vbuxx=_inc_vbuxx 
    inx
    // [73] phi from palette_init::@2 to palette_init::@1 [phi:palette_init::@2->palette_init::@1]
    // [73] phi palette_init::i#2 = palette_init::i#1 [phi:palette_init::@2->palette_init::@1#0] -- register_copy 
    jmp __b1
  .segment DataEnginePalette
    .label palette_init__1 = palette_init__2
    palette_init__2: .word 0
    .label palette_init__4 = palette_init__2
}
.segment Code
  // main
main: {
    // main::@return
    // [87] return 
    rts
}
.segment CodeEnginePalette
  // palette_alloc_vram
palette_alloc_vram: {
    // [89] phi from palette_alloc_vram to palette_alloc_vram::@1 [phi:palette_alloc_vram->palette_alloc_vram::@1]
    // [89] phi palette_alloc_vram::vram_index#2 = 1 [phi:palette_alloc_vram->palette_alloc_vram::@1#0] -- vbuxx=vbuc1 
    ldx #1
    // palette_alloc_vram::@1
  __b1:
    // for(unsigned char vram_index=1; vram_index<16; vram_index++)
    // [90] if(palette_alloc_vram::vram_index#2<$10) goto palette_alloc_vram::@2 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$10
    bcc __b2
    // [91] phi from palette_alloc_vram::@1 to palette_alloc_vram::@return [phi:palette_alloc_vram::@1->palette_alloc_vram::@return]
    // [91] phi palette_alloc_vram::return#2 = 0 [phi:palette_alloc_vram::@1->palette_alloc_vram::@return#0] -- vbuaa=vbuc1 
    lda #0
    // palette_alloc_vram::@return
    // }
    // [92] return 
    rts
    // palette_alloc_vram::@2
  __b2:
    // if(palette.vram_index >= 16)
    // [93] if(*((char *)&palette+2)<$10) goto palette_alloc_vram::@3 -- _deref_pbuc1_lt_vbuc2_then_la1 
    lda palette+2
    cmp #$10
    bcc __b3
    // palette_alloc_vram::@5
    // palette.vram_index=1
    // [94] *((char *)&palette+2) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta palette+2
    // palette_alloc_vram::@3
  __b3:
    // if(!palette.vram.used[palette.vram_index])
    // [95] if(0!=((char *)(struct $4 *)&palette+3+$10)[*((char *)&palette+2)]) goto palette_alloc_vram::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy palette+2
    lda palette+3+$10,y
    cmp #0
    bne __b4
    // palette_alloc_vram::@6
    // return palette.vram_index;
    // [96] palette_alloc_vram::return#1 = *((char *)&palette+2) -- vbuaa=_deref_pbuc1 
    tya
    // [91] phi from palette_alloc_vram::@6 to palette_alloc_vram::@return [phi:palette_alloc_vram::@6->palette_alloc_vram::@return]
    // [91] phi palette_alloc_vram::return#2 = palette_alloc_vram::return#1 [phi:palette_alloc_vram::@6->palette_alloc_vram::@return#0] -- register_copy 
    rts
    // palette_alloc_vram::@4
  __b4:
    // palette.vram_index++;
    // [97] *((char *)&palette+2) = ++ *((char *)&palette+2) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc palette+2
    // for(unsigned char vram_index=1; vram_index<16; vram_index++)
    // [98] palette_alloc_vram::vram_index#1 = ++ palette_alloc_vram::vram_index#2 -- vbuxx=_inc_vbuxx 
    inx
    // [89] phi from palette_alloc_vram::@4 to palette_alloc_vram::@1 [phi:palette_alloc_vram::@4->palette_alloc_vram::@1]
    // [89] phi palette_alloc_vram::vram_index#2 = palette_alloc_vram::vram_index#1 [phi:palette_alloc_vram::@4->palette_alloc_vram::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment Data
  funcs: .word palette_init, palette_alloc_bram, palette_ptr_bram, palette_use_vram, palette_unuse_vram, palette_free_vram
.segment BramEnginePalette
  palette_bram: .fill SIZEOF_STRUCT___2, 0
.segment DataEnginePalette
  palette: .fill SIZEOF_STRUCT___6, 0
