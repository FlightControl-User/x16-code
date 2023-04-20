.namespace palette {
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
    // [74] phi from __start::@1 to main [phi:__start::@1->main] -- call_phi_near 
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
    .label palette_free_vram__0 = $c
    .label palette_free_vram__1 = $c
    // [6] palette_free_vram::bram_index#0 = stackidx(unsigned int,palette_free_vram::OFFSET_STACK_BRAM_INDEX) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_INDEX,x
    sta bram_index
    lda STACK_BASE+OFFSET_STACK_BRAM_INDEX+1,x
    sta bram_index+1
    // unsigned char vram_index = palette.bram.vram_index[bram_index]
    // [7] palette_free_vram::$0 = (char *)(struct $3 *)&palette+$43 + palette_free_vram::bram_index#0 -- pbuz1=pbuc1_plus_vwum2 
    lda bram_index
    clc
    adc #<palette+$43
    sta.z palette_free_vram__0
    lda bram_index+1
    adc #>palette+$43
    sta.z palette_free_vram__0+1
    // [8] palette_free_vram::vram_index#0 = *palette_free_vram::$0 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (palette_free_vram__0),y
    // palette.vram.used[vram_index] = 0
    // [9] ((char *)(struct $4 *)&palette+3+$10)[palette_free_vram::vram_index#0] = 0 -- pbuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta palette+3+$10,y
    // palette.bram.vram_index[bram_index] = 0
    // [10] palette_free_vram::$1 = (char *)(struct $3 *)&palette+$43 + palette_free_vram::bram_index#0 -- pbuz1=pbuc1_plus_vwum2 
    lda bram_index
    clc
    adc #<palette+$43
    sta.z palette_free_vram__1
    lda bram_index+1
    adc #>palette+$43
    sta.z palette_free_vram__1+1
    // [11] *palette_free_vram::$1 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (palette_free_vram__1),y
    // palette_free_vram::@return
    // }
    // [12] return 
    rts
  .segment Data
    bram_index: .word 0
}
.segment CodeEnginePalette
  // palette_unuse_vram
// void palette_unuse_vram(__zp($e) unsigned int bram_index)
palette_unuse_vram: {
    .const OFFSET_STACK_BRAM_INDEX = 0
    .label bram_index = $e
    .label palette_unuse_vram__1 = $e
    // [13] palette_unuse_vram::bram_index#0 = stackidx(unsigned int,palette_unuse_vram::OFFSET_STACK_BRAM_INDEX) -- vwuz1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_INDEX,x
    sta.z bram_index
    lda STACK_BASE+OFFSET_STACK_BRAM_INDEX+1,x
    sta.z bram_index+1
    // unsigned char vram_index = palette.bram.vram_index[bram_index]
    // [14] palette_unuse_vram::$1 = (char *)(struct $3 *)&palette+$43 + palette_unuse_vram::bram_index#0 -- pbuz1=pbuc1_plus_vwuz1 
    lda.z palette_unuse_vram__1
    clc
    adc #<palette+$43
    sta.z palette_unuse_vram__1
    lda.z palette_unuse_vram__1+1
    adc #>palette+$43
    sta.z palette_unuse_vram__1+1
    // [15] palette_unuse_vram::vram_index#0 = *palette_unuse_vram::$1 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (palette_unuse_vram__1),y
    // palette.vram.used[vram_index]--;
    // [16] ((char *)(struct $4 *)&palette+3+$10)[palette_unuse_vram::vram_index#0] = -- ((char *)(struct $4 *)&palette+3+$10)[palette_unuse_vram::vram_index#0] -- pbuc1_derefidx_vbuaa=_dec_pbuc1_derefidx_vbuaa 
    tax
    dec palette+3+$10,x
    // palette_unuse_vram::@return
    // }
    // [17] return 
    rts
}
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
    bne __b1
    // [21] phi from palette_use_vram to palette_use_vram::@2 [phi:palette_use_vram->palette_use_vram::@2]
    // palette_use_vram::@2
    // palette_alloc_vram()
    // [22] call palette_alloc_vram
    // [76] phi from palette_use_vram::@2 to palette_alloc_vram [phi:palette_use_vram::@2->palette_alloc_vram] -- call_phi_near 
    jsr palette_alloc_vram
    // palette_alloc_vram()
    // [23] palette_alloc_vram::return#3 = palette_alloc_vram::return#2
    // palette_use_vram::@6
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
    // [32] memcpy_vram_bram::sptr_bram#0 = stackpull(struct $0 *) -- pssz1=_stackpullptr_ 
    pla
    sta.z memcpy_vram_bram.sptr_bram
    pla
    sta.z memcpy_vram_bram.sptr_bram+1
    // memcpy_vram_bram(VERA_PALETTE_BANK, palette.vram.offset[vram_index], palette.bram_bank, (bram_ptr_t)palette_ptr_bram(palette_index), 32)
    // [33] palette_use_vram::$8 = palette_use_vram::vram_index#1 << 1 -- vbuaa=vbum1_rol_1 
    lda vram_index
    asl
    // [34] memcpy_vram_bram::doffset_vram#0 = ((unsigned int *)(struct $4 *)&palette+3+$20)[palette_use_vram::$8] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda palette+3+$20,y
    sta memcpy_vram_bram.doffset_vram
    lda palette+3+$20+1,y
    sta memcpy_vram_bram.doffset_vram+1
    // [35] memcpy_vram_bram::sbank_bram#2 = *((char *)&palette) -- vbum1=_deref_pbuc1 
    lda palette
    sta memcpy_vram_bram.sbank_bram
    // [36] memcpy_vram_bram::num = $20 -- vwum1=vbuc1 
    lda #<$20
    sta memcpy_vram_bram.num
    lda #>$20
    sta memcpy_vram_bram.num+1
    // [37] call memcpy_vram_bram
    // [87] phi from palette_use_vram::@5 to memcpy_vram_bram [phi:palette_use_vram::@5->memcpy_vram_bram] -- call_phi_near 
    jsr memcpy_vram_bram
    // palette_use_vram::@7
    // palette.bram.vram_index[palette_index] = vram_index
    // [38] ((char *)(struct $3 *)&palette+$43)[palette_use_vram::palette_index#0] = palette_use_vram::vram_index#1 -- pbuc1_derefidx_vbum1=vbum2 
    lda vram_index
    ldy palette_index
    sta palette+$43,y
    // [39] phi from palette_use_vram palette_use_vram::@6 palette_use_vram::@7 to palette_use_vram::@1 [phi:palette_use_vram/palette_use_vram::@6/palette_use_vram::@7->palette_use_vram::@1]
    // [39] phi palette_use_vram::return#0 = palette_use_vram::vram_index#0 [phi:palette_use_vram/palette_use_vram::@6/palette_use_vram::@7->palette_use_vram::@1#0] -- register_copy 
    // palette_use_vram::@1
  __b1:
    // palette.vram.used[vram_index]++;
    // [40] ((char *)(struct $4 *)&palette+3+$10)[palette_use_vram::return#0] = ++ ((char *)(struct $4 *)&palette+3+$10)[palette_use_vram::return#0] -- pbuc1_derefidx_vbum1=_inc_pbuc1_derefidx_vbum1 
    ldx return
    inc palette+3+$10,x
    // palette_use_vram::@return
    // }
    // [41] stackidx(char,palette_use_vram::OFFSET_STACK_RETURN_0) = palette_use_vram::return#0 -- _stackidxbyte_vbuc1=vbum1 
    txa
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    // [42] return 
    rts
  .segment Data
    palette_index: .byte 0
  .segment DataEnginePalette
    .label vram_index = return
  .segment Data
    return: .byte 0
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
    // [44] if(0!=((char *)(struct $3 *)&palette+$43+$40)[*((char *)&palette+1)]) goto palette_alloc_bram::@2 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy palette+1
    lda palette+$43+$40,y
    cmp #0
    bne __b2
    // palette_alloc_bram::@3
    // palette.bram.used[palette.pool] = 1
    // [45] ((char *)(struct $3 *)&palette+$43+$40)[*((char *)&palette+1)] = 1 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #1
    sta palette+$43+$40,y
    // return palette.pool;
    // [46] palette_alloc_bram::return#0 = *((char *)&palette+1) -- vbuaa=_deref_pbuc1 
    tya
    // palette_alloc_bram::@return
    // }
    // [47] stackidx(char,palette_alloc_bram::OFFSET_STACK_RETURN_0) = palette_alloc_bram::return#0 -- _stackidxbyte_vbuc1=vbuaa 
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    // [48] return 
    rts
    // palette_alloc_bram::@2
  __b2:
    // palette.pool + 1
    // [49] palette_alloc_bram::$0 = *((char *)&palette+1) + 1 -- vbuaa=_deref_pbuc1_plus_1 
    lda palette+1
    inc
    // (palette.pool + 1) % 64
    // [50] palette_alloc_bram::$1 = palette_alloc_bram::$0 & $40-1 -- vbuaa=vbuaa_band_vbuc1 
    and #$40-1
    // palette.pool = (palette.pool + 1) % 64
    // [51] *((char *)&palette+1) = palette_alloc_bram::$1 -- _deref_pbuc1=vbuaa 
    sta palette+1
    jmp __b1
}
  // palette_ptr_bram
/**
 * @brief Return the address of palette slot in bram. 
 * 
 * @return palette_ptr_t The address in bram. Note that the bank must be properly set to use the data behind the pointer.
 */
// __zp(2) struct $0 * palette_ptr_bram(__register(A) char palette_index)
palette_ptr_bram: {
    .const OFFSET_STACK_PALETTE_INDEX = 0
    .const OFFSET_STACK_RETURN_0 = 0
    .label palette_ptr_bram__1 = 2
    .label palette_ptr_bram__2 = 2
    .label return = 2
    // [52] palette_ptr_bram::palette_index#0 = stackidx(char,palette_ptr_bram::OFFSET_STACK_PALETTE_INDEX) -- vbuaa=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_PALETTE_INDEX,x
    // &palette_bram.palette_16[(unsigned int)palette_index]
    // [53] palette_ptr_bram::$2 = (unsigned int)palette_ptr_bram::palette_index#0 -- vwuz1=_word_vbuaa 
    sta.z palette_ptr_bram__2
    lda #0
    sta.z palette_ptr_bram__2+1
    // [54] palette_ptr_bram::$1 = palette_ptr_bram::$2 << 5 -- vwuz1=vwuz1_rol_5 
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
    // [55] palette_ptr_bram::return#0 = (struct $0 *)&palette_bram + palette_ptr_bram::$1 -- pssz1=pssc1_plus_vwuz1 
    lda.z return
    clc
    adc #<palette_bram
    sta.z return
    lda.z return+1
    adc #>palette_bram
    sta.z return+1
    // palette_ptr_bram::@return
    // }
    // [56] stackidx(struct $0 *,palette_ptr_bram::OFFSET_STACK_RETURN_0) = palette_ptr_bram::return#0 -- _stackidxptr_vbuc1=pssz1 
    tsx
    lda.z return
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda.z return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [57] return 
    rts
}
  // palette_init
// void palette_init(__register(A) char bram_bank)
palette_init: {
    .const OFFSET_STACK_BRAM_BANK = 0
    .label palette_init__1 = 4
    .label palette_init__2 = 4
    .label palette_init__3 = 6
    .label palette_init__4 = 6
    .label palette_init__5 = 4
    // [58] palette_init::bram_bank#0 = stackidx(char,palette_init::OFFSET_STACK_BRAM_BANK) -- vbuaa=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_BANK,x
    // palette.bram_bank = bram_bank
    // [59] *((char *)&palette) = palette_init::bram_bank#0 -- _deref_pbuc1=vbuaa 
    sta palette
    // [60] phi from palette_init to palette_init::@1 [phi:palette_init->palette_init::@1]
    // [60] phi palette_init::i#2 = 0 [phi:palette_init->palette_init::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta i
    sta i+1
    // palette_init::@1
  __b1:
    // for(unsigned int i=0; i<16; i++)
    // [61] if(palette_init::i#2<$10) goto palette_init::@2 -- vwum1_lt_vbuc1_then_la1 
    lda i+1
    bne !+
    lda i
    cmp #$10
    bcc __b2
  !:
    // palette_init::@3
    // palette.vram.used[0] = 1
    // [62] *((char *)(struct $4 *)&palette+3+$10) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta palette+3+$10
    // palette.vram_index = 1
    // [63] *((char *)&palette+2) = 1 -- _deref_pbuc1=vbuc2 
    sta palette+2
    // palette.pool = 0
    // [64] *((char *)&palette+1) = 0 -- _deref_pbuc1=vbuc2 
    // this needs to be revisited, a hardcoding that is meant to skip the tiles, but this will vary during play.
    lda #0
    sta palette+1
    // palette_init::@return
    // }
    // [65] return 
    rts
    // palette_init::@2
  __b2:
    // i*32
    // [66] palette_init::$1 = palette_init::i#2 << 5 -- vwuz1=vwum2_rol_5 
    lda i
    asl
    sta.z palette_init__1
    lda i+1
    rol
    sta.z palette_init__1+1
    asl.z palette_init__1
    rol.z palette_init__1+1
    asl.z palette_init__1
    rol.z palette_init__1+1
    asl.z palette_init__1
    rol.z palette_init__1+1
    asl.z palette_init__1
    rol.z palette_init__1+1
    // VERA_PALETTE_PTR+(i*32)
    // [67] palette_init::$2 = VERA_PALETTE_PTR + palette_init::$1 -- pbuz1=pbuc1_plus_vwuz1 
    lda.z palette_init__2
    clc
    adc #<VERA_PALETTE_PTR
    sta.z palette_init__2
    lda.z palette_init__2+1
    adc #>VERA_PALETTE_PTR
    sta.z palette_init__2+1
    // palette.vram.offset[i] = (vram_offset_t)(VERA_PALETTE_PTR+(i*32))
    // [68] palette_init::$3 = palette_init::i#2 << 1 -- vwuz1=vwum2_rol_1 
    lda i
    asl
    sta.z palette_init__3
    lda i+1
    rol
    sta.z palette_init__3+1
    // [69] palette_init::$4 = (unsigned int *)(struct $4 *)&palette+3+$20 + palette_init::$3 -- pwuz1=pwuc1_plus_vwuz1 
    lda.z palette_init__4
    clc
    adc #<palette+3+$20
    sta.z palette_init__4
    lda.z palette_init__4+1
    adc #>palette+3+$20
    sta.z palette_init__4+1
    // [70] *palette_init::$4 = (unsigned int)palette_init::$2 -- _deref_pwuz1=vwuz2 
    ldy #0
    lda.z palette_init__2
    sta (palette_init__4),y
    iny
    lda.z palette_init__2+1
    sta (palette_init__4),y
    // palette.vram.used[i] = 0
    // [71] palette_init::$5 = (char *)(struct $4 *)&palette+3+$10 + palette_init::i#2 -- pbuz1=pbuc1_plus_vwum2 
    lda i
    clc
    adc #<palette+3+$10
    sta.z palette_init__5
    lda i+1
    adc #>palette+3+$10
    sta.z palette_init__5+1
    // [72] *palette_init::$5 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (palette_init__5),y
    // for(unsigned int i=0; i<16; i++)
    // [73] palette_init::i#1 = ++ palette_init::i#2 -- vwum1=_inc_vwum1 
    inc i
    bne !+
    inc i+1
  !:
    // [60] phi from palette_init::@2 to palette_init::@1 [phi:palette_init::@2->palette_init::@1]
    // [60] phi palette_init::i#2 = palette_init::i#1 [phi:palette_init::@2->palette_init::@1#0] -- register_copy 
    jmp __b1
  .segment DataEnginePalette
    i: .word 0
}
.segment Code
  // main
main: {
    // main::@return
    // [75] return 
    rts
}
.segment CodeEnginePalette
  // palette_alloc_vram
palette_alloc_vram: {
    // [77] phi from palette_alloc_vram to palette_alloc_vram::@1 [phi:palette_alloc_vram->palette_alloc_vram::@1]
    // [77] phi palette_alloc_vram::vram_index#2 = 1 [phi:palette_alloc_vram->palette_alloc_vram::@1#0] -- vbuxx=vbuc1 
    ldx #1
    // palette_alloc_vram::@1
  __b1:
    // for(unsigned char vram_index=1; vram_index<16; vram_index++)
    // [78] if(palette_alloc_vram::vram_index#2<$10) goto palette_alloc_vram::@2 -- vbuxx_lt_vbuc1_then_la1 
    cpx #$10
    bcc __b2
    // [79] phi from palette_alloc_vram::@1 to palette_alloc_vram::@return [phi:palette_alloc_vram::@1->palette_alloc_vram::@return]
    // [79] phi palette_alloc_vram::return#2 = 0 [phi:palette_alloc_vram::@1->palette_alloc_vram::@return#0] -- vbuaa=vbuc1 
    lda #0
    // palette_alloc_vram::@return
    // }
    // [80] return 
    rts
    // palette_alloc_vram::@2
  __b2:
    // if(palette.vram_index >= 16)
    // [81] if(*((char *)&palette+2)<$10) goto palette_alloc_vram::@3 -- _deref_pbuc1_lt_vbuc2_then_la1 
    lda palette+2
    cmp #$10
    bcc __b3
    // palette_alloc_vram::@5
    // palette.vram_index=1
    // [82] *((char *)&palette+2) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta palette+2
    // palette_alloc_vram::@3
  __b3:
    // if(!palette.vram.used[palette.vram_index])
    // [83] if(0!=((char *)(struct $4 *)&palette+3+$10)[*((char *)&palette+2)]) goto palette_alloc_vram::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy palette+2
    lda palette+3+$10,y
    cmp #0
    bne __b4
    // palette_alloc_vram::@6
    // return palette.vram_index;
    // [84] palette_alloc_vram::return#1 = *((char *)&palette+2) -- vbuaa=_deref_pbuc1 
    tya
    // [79] phi from palette_alloc_vram::@6 to palette_alloc_vram::@return [phi:palette_alloc_vram::@6->palette_alloc_vram::@return]
    // [79] phi palette_alloc_vram::return#2 = palette_alloc_vram::return#1 [phi:palette_alloc_vram::@6->palette_alloc_vram::@return#0] -- register_copy 
    rts
    // palette_alloc_vram::@4
  __b4:
    // palette.vram_index++;
    // [85] *((char *)&palette+2) = ++ *((char *)&palette+2) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc palette+2
    // for(unsigned char vram_index=1; vram_index<16; vram_index++)
    // [86] palette_alloc_vram::vram_index#1 = ++ palette_alloc_vram::vram_index#2 -- vbuxx=_inc_vbuxx 
    inx
    // [77] phi from palette_alloc_vram::@4 to palette_alloc_vram::@1 [phi:palette_alloc_vram::@4->palette_alloc_vram::@1]
    // [77] phi palette_alloc_vram::vram_index#2 = palette_alloc_vram::vram_index#1 [phi:palette_alloc_vram::@4->palette_alloc_vram::@1#0] -- register_copy 
    jmp __b1
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
// void memcpy_vram_bram(char dbank_vram, __mem() unsigned int doffset_vram, __mem() char sbank_bram, __zp(8) struct $0 *sptr_bram, __mem() volatile unsigned int num)
memcpy_vram_bram: {
    .label pagemask = $ff00
    .label ptr = $a
    .label memcpy_vram_bram__27 = 8
    .label sptr_bram = 8
    // memcpy_vram_bram::bank_get_bram1
    // return BRAM;
    // [88] memcpy_vram_bram::bank#10 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank
    // memcpy_vram_bram::bank_set_bram1
    // BRAM = bank
    // [89] BRAM = memcpy_vram_bram::sbank_bram#2 -- vbuz1=vbum2 
    lda sbank_bram
    sta.z BRAM
    // memcpy_vram_bram::@12
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [90] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [91] memcpy_vram_bram::$2 = byte0  memcpy_vram_bram::doffset_vram#0 -- vbuaa=_byte0_vwum1 
    lda doffset_vram
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [92] *VERA_ADDRX_L = memcpy_vram_bram::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [93] memcpy_vram_bram::$3 = byte1  memcpy_vram_bram::doffset_vram#0 -- vbuaa=_byte1_vwum1 
    lda doffset_vram+1
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [94] *VERA_ADDRX_M = memcpy_vram_bram::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [95] *VERA_ADDRX_H = VERA_PALETTE_BANK|VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_PALETTE_BANK|VERA_INC_1
    sta VERA_ADDRX_H
    // (unsigned int)sptr_bram & (unsigned int)pagemask
    // [96] memcpy_vram_bram::$5 = (unsigned int)(char *)memcpy_vram_bram::sptr_bram#0 & (unsigned int)memcpy_vram_bram::pagemask -- vwum1=vwuz2_band_vwuc1 
    lda.z sptr_bram
    and #<pagemask
    sta memcpy_vram_bram__5
    lda.z sptr_bram+1
    and #>pagemask
    sta memcpy_vram_bram__5+1
    // bram_ptr_t ptr = (bram_ptr_t)((unsigned int)sptr_bram & (unsigned int)pagemask)
    // [97] memcpy_vram_bram::ptr = (char *)memcpy_vram_bram::$5 -- pbuz1=pbum2 
    // Set the page boundary.
    lda memcpy_vram_bram__5
    sta.z ptr
    lda memcpy_vram_bram__5+1
    sta.z ptr+1
    // unsigned char pos = BYTE0(sptr_bram)
    // [98] memcpy_vram_bram::pos = byte0  (char *)memcpy_vram_bram::sptr_bram#0 -- vbum1=_byte0_pbuz2 
    lda.z sptr_bram
    sta pos
    // BYTE0(sptr_bram)
    // [99] memcpy_vram_bram::$7 = byte0  (char *)memcpy_vram_bram::sptr_bram#0 -- vbuaa=_byte0_pbuz1 
    lda.z sptr_bram
    // unsigned char len = -BYTE0(sptr_bram)
    // [100] memcpy_vram_bram::len = - memcpy_vram_bram::$7 -- vbum1=_neg_vbuaa 
    eor #$ff
    clc
    adc #1
    sta len
    // num <= (unsigned int)len
    // [101] memcpy_vram_bram::$27 = (unsigned int)memcpy_vram_bram::len -- vwuz1=_word_vbum2 
    sta.z memcpy_vram_bram__27
    lda #0
    sta.z memcpy_vram_bram__27+1
    // if (num <= (unsigned int)len)
    // [102] if(memcpy_vram_bram::num>memcpy_vram_bram::$27) goto memcpy_vram_bram::@1 -- vwum1_gt_vwuz2_then_la1 
    cmp num+1
    bcc __b1
    bne !+
    lda.z memcpy_vram_bram__27
    cmp num
    bcc __b1
  !:
    // memcpy_vram_bram::@5
    // BYTE0(num)
    // [103] memcpy_vram_bram::$11 = byte0  memcpy_vram_bram::num -- vbuaa=_byte0_vwum1 
    lda num
    // len = BYTE0(num)
    // [104] memcpy_vram_bram::len = memcpy_vram_bram::$11 -- vbum1=vbuaa 
    sta len
    // memcpy_vram_bram::@1
  __b1:
    // if (len)
    // [105] if(0==memcpy_vram_bram::len) goto memcpy_vram_bram::@2 -- 0_eq_vbum1_then_la1 
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
    // [107] memcpy_vram_bram::ptr = memcpy_vram_bram::ptr + $100 -- pbuz1=pbuz1_plus_vwuc1 
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
    // [108] memcpy_vram_bram::num = memcpy_vram_bram::num - memcpy_vram_bram::len -- vwum1=vwum1_minus_vbum2 
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
    // [109] memcpy_vram_bram::$13 = byte1  memcpy_vram_bram::ptr -- vbuaa=_byte1_pbuz1 
    lda.z ptr+1
    // if (BYTE1(ptr) == 0xC0)
    // [110] if(memcpy_vram_bram::$13!=$c0) goto memcpy_vram_bram::@3 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$c0
    bne __b3
    // memcpy_vram_bram::@7
    // ptr = (unsigned char *)0xA000
    // [111] memcpy_vram_bram::ptr = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z ptr
    lda #>$a000
    sta.z ptr+1
    // bank_set_bram(++sbank_bram);
    // [112] memcpy_vram_bram::bank_set_bram2_bank#0 = ++ memcpy_vram_bram::sbank_bram#2 -- vbum1=_inc_vbum1 
    inc bank_set_bram2_bank
    // memcpy_vram_bram::bank_set_bram2
    // BRAM = bank
    // [113] BRAM = memcpy_vram_bram::bank_set_bram2_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram2_bank
    sta.z BRAM
    // [114] phi from memcpy_vram_bram::@2 memcpy_vram_bram::bank_set_bram2 to memcpy_vram_bram::@3 [phi:memcpy_vram_bram::@2/memcpy_vram_bram::bank_set_bram2->memcpy_vram_bram::@3]
    // [114] phi memcpy_vram_bram::sbank_bram#13 = memcpy_vram_bram::sbank_bram#2 [phi:memcpy_vram_bram::@2/memcpy_vram_bram::bank_set_bram2->memcpy_vram_bram::@3#0] -- register_copy 
    // memcpy_vram_bram::@3
  __b3:
    // BYTE1(num)
    // [115] memcpy_vram_bram::$16 = byte1  memcpy_vram_bram::num -- vbuaa=_byte1_vwum1 
    lda num+1
    // if (BYTE1(num))
    // [116] if(0==memcpy_vram_bram::$16) goto memcpy_vram_bram::@4 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b4
    // [117] phi from memcpy_vram_bram::@10 memcpy_vram_bram::@3 to memcpy_vram_bram::@9 [phi:memcpy_vram_bram::@10/memcpy_vram_bram::@3->memcpy_vram_bram::@9]
    // [117] phi memcpy_vram_bram::sbank_bram#5 = memcpy_vram_bram::sbank_bram#12 [phi:memcpy_vram_bram::@10/memcpy_vram_bram::@3->memcpy_vram_bram::@9#0] -- register_copy 
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
    // [119] memcpy_vram_bram::ptr = memcpy_vram_bram::ptr + $100 -- pbuz1=pbuz1_plus_vwuc1 
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
    // [120] memcpy_vram_bram::$21 = byte1  memcpy_vram_bram::ptr -- vbuaa=_byte1_pbuz1 
    // if (BYTE1(ptr) == 0xC0)
    // [121] if(memcpy_vram_bram::$21!=$c0) goto memcpy_vram_bram::@10 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$c0
    bne __b10
    // memcpy_vram_bram::@11
    // ptr = (unsigned char *)0xA000
    // [122] memcpy_vram_bram::ptr = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z ptr
    lda #>$a000
    sta.z ptr+1
    // bank_set_bram(++sbank_bram);
    // [123] memcpy_vram_bram::bank_set_bram3_bank#0 = ++ memcpy_vram_bram::sbank_bram#5 -- vbum1=_inc_vbum1 
    inc bank_set_bram3_bank
    // memcpy_vram_bram::bank_set_bram3
    // BRAM = bank
    // [124] BRAM = memcpy_vram_bram::bank_set_bram3_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram3_bank
    sta.z BRAM
    // [125] phi from memcpy_vram_bram::@9 memcpy_vram_bram::bank_set_bram3 to memcpy_vram_bram::@10 [phi:memcpy_vram_bram::@9/memcpy_vram_bram::bank_set_bram3->memcpy_vram_bram::@10]
    // [125] phi memcpy_vram_bram::sbank_bram#12 = memcpy_vram_bram::sbank_bram#5 [phi:memcpy_vram_bram::@9/memcpy_vram_bram::bank_set_bram3->memcpy_vram_bram::@10#0] -- register_copy 
    // memcpy_vram_bram::@10
  __b10:
    // num -= 256
    // [126] memcpy_vram_bram::num = memcpy_vram_bram::num - $100 -- vwum1=vwum1_minus_vwuc1 
    lda num
    sec
    sbc #<$100
    sta num
    lda num+1
    sbc #>$100
    sta num+1
    // BYTE1(num)
    // [127] memcpy_vram_bram::$25 = byte1  memcpy_vram_bram::num -- vbuaa=_byte1_vwum1 
    // while (BYTE1(num))
    // [128] if(0!=memcpy_vram_bram::$25) goto memcpy_vram_bram::@9 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b9
    // memcpy_vram_bram::@4
  __b4:
    // if (num)
    // [129] if(0==memcpy_vram_bram::num) goto memcpy_vram_bram::bank_set_bram4 -- 0_eq_vwum1_then_la1 
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
    // [131] BRAM = memcpy_vram_bram::bank#10 -- vbuz1=vbum2 
    lda bank
    sta.z BRAM
    // memcpy_vram_bram::@return
    // }
    // [132] return 
    rts
  .segment DataEnginePalette
    num: .word 0
    memcpy_vram_bram__5: .word 0
    pos: .byte 0
    len: .byte 0
    .label bank_set_bram2_bank = sbank_bram
    .label bank_set_bram3_bank = sbank_bram
  .segment Data
    doffset_vram: .word 0
    sbank_bram: .byte 0
  .segment DataEnginePalette
    bank: .byte 0
}
  // File Data
.segment Data
  funcs: .word palette_init, palette_alloc_bram, palette_ptr_bram, palette_use_vram, palette_unuse_vram, palette_free_vram
.segment BramEnginePalette
  palette_bram: .fill SIZEOF_STRUCT___2, 0
.segment DataEnginePalette
  palette: .fill SIZEOF_STRUCT___6, 0
}