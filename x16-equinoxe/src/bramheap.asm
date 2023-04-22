
  // Global Constants & labels
  .const STACK_BASE = $103
  .const isr_vsync = $314
  .const SIZEOF_STRUCT___1 = $800
  .const SIZEOF_STRUCT___2 = $67
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
    // [176] phi from __start::@1 to main [phi:__start::@1->main] -- call_phi_near 
    jsr main
    // __start::@return
    // [5] return 
    rts
}
.segment CodeBramHeap
  // bram_heap_get_size
// unsigned long bram_heap_get_size(char s, __register(X) char index)
bram_heap_get_size: {
    .const OFFSET_STACK_INDEX = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [6] bram_heap_get_size::index#0 = stackidx(char,bram_heap_get_size::OFFSET_STACK_INDEX) -- vbuxx=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_INDEX,x
    tax
    // bram_heap_get_size::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // bram_heap_get_size::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [8] bram_heap_get_size::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_get_size::bank_set_bram1
    // BRAM = bank
    // [9] BRAM = bram_heap_get_size::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_get_size::@2
    // bram_heap_size_t size_packed = bram_heap_get_size_packed(s, index)
    // [10] bram_heap_get_size_packed::index#1 = bram_heap_get_size::index#0
    // [11] call bram_heap_get_size_packed
    // [178] phi from bram_heap_get_size::@2 to bram_heap_get_size_packed [phi:bram_heap_get_size::@2->bram_heap_get_size_packed]
    // [178] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#1 [phi:bram_heap_get_size::@2->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_t size_packed = bram_heap_get_size_packed(s, index)
    // [12] bram_heap_get_size_packed::return#1 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return_1
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return_1+1
    // bram_heap_get_size::@3
    // [13] bram_heap_get_size::size_packed#0 = bram_heap_get_size_packed::return#1 -- vdum1=vwum2 
    lda bram_heap_get_size_packed.return_1
    sta size_packed
    lda bram_heap_get_size_packed.return_1+1
    sta size_packed+1
    lda #0
    sta size_packed+2
    sta size_packed+3
    // bram_heap_size_t size = size_packed << 5
    // [14] bram_heap_get_size::size#0 = bram_heap_get_size::size_packed#0 << 5 -- vdum1=vdum2_rol_5 
    lda size_packed
    asl
    sta size
    lda size_packed+1
    rol
    sta size+1
    lda size_packed+2
    rol
    sta size+2
    lda size_packed+3
    rol
    sta size+3
    asl size
    rol size+1
    rol size+2
    rol size+3
    asl size
    rol size+1
    rol size+2
    rol size+3
    asl size
    rol size+1
    rol size+2
    rol size+3
    asl size
    rol size+1
    rol size+2
    rol size+3
    // bram_heap_get_size::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // bram_heap_get_size::@return
    // }
    // [16] stackidx(unsigned long,bram_heap_get_size::OFFSET_STACK_RETURN_0) = bram_heap_get_size::size#0 -- _stackidxdword_vbuc1=vdum1 
    tsx
    lda size
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda size+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    lda size+2
    sta STACK_BASE+OFFSET_STACK_RETURN_0+2,x
    lda size+3
    sta STACK_BASE+OFFSET_STACK_RETURN_0+3,x
    // [17] return 
    rts
  .segment DataBramHeap
    size_packed: .dword 0
    size: .dword 0
}
.segment CodeBramHeap
  // bram_heap_data_get_bank
// char bram_heap_data_get_bank(char s, __register(X) char index)
bram_heap_data_get_bank: {
    .const OFFSET_STACK_INDEX = 0
    .const OFFSET_STACK_RETURN_1 = 1
    // [18] bram_heap_data_get_bank::index#0 = stackidx(char,bram_heap_data_get_bank::OFFSET_STACK_INDEX) -- vbuxx=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_INDEX,x
    tax
    // bram_heap_data_get_bank::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // bram_heap_data_get_bank::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [20] bram_heap_data_get_bank::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_data_get_bank::bank_set_bram1
    // BRAM = bank
    // [21] BRAM = bram_heap_data_get_bank::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_data_get_bank::@2
    // bram_bank_t bram_bank = bram_heap_index.data1[index]
    // [22] bram_heap_data_get_bank::bram_bank#0 = ((char *)&bram_heap_index+$100)[bram_heap_data_get_bank::index#0] -- vbuyy=pbuc1_derefidx_vbuxx 
    ldy bram_heap_index+$100,x
    // bram_heap_data_get_bank::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // bram_heap_data_get_bank::@return
    // }
    // [24] stackidx(char,bram_heap_data_get_bank::OFFSET_STACK_RETURN_1) = bram_heap_data_get_bank::bram_bank#0 -- _stackidxbyte_vbuc1=vbuyy 
    tya
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    // [25] return 
    rts
}
  // bram_heap_data_get_offset
// char * bram_heap_data_get_offset(char s, __register(X) char index)
bram_heap_data_get_offset: {
    .const OFFSET_STACK_INDEX = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [26] bram_heap_data_get_offset::index#0 = stackidx(char,bram_heap_data_get_offset::OFFSET_STACK_INDEX) -- vbuxx=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_INDEX,x
    tax
    // bram_heap_data_get_offset::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // bram_heap_data_get_offset::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [28] bram_heap_data_get_offset::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_data_get_offset::bank_set_bram1
    // BRAM = bank
    // [29] BRAM = bram_heap_data_get_offset::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_data_get_offset::@2
    // (unsigned int)bram_heap_index.data0[index] << 5
    // [30] bram_heap_data_get_offset::$5 = (unsigned int)((char *)&bram_heap_index)[bram_heap_data_get_offset::index#0] -- vwum1=_word_pbuc1_derefidx_vbuxx 
    lda bram_heap_index,x
    sta bram_heap_data_get_offset__5
    lda #0
    sta bram_heap_data_get_offset__5+1
    // [31] bram_heap_data_get_offset::$2 = bram_heap_data_get_offset::$5 << 5 -- vwum1=vwum1_rol_5 
    asl bram_heap_data_get_offset__2
    rol bram_heap_data_get_offset__2+1
    asl bram_heap_data_get_offset__2
    rol bram_heap_data_get_offset__2+1
    asl bram_heap_data_get_offset__2
    rol bram_heap_data_get_offset__2+1
    asl bram_heap_data_get_offset__2
    rol bram_heap_data_get_offset__2+1
    asl bram_heap_data_get_offset__2
    rol bram_heap_data_get_offset__2+1
    // ((unsigned int)bram_heap_index.data0[index] << 5) | 0xA000
    // [32] bram_heap_data_get_offset::bram_ptr#0 = bram_heap_data_get_offset::$2 | $a000 -- vwum1=vwum1_bor_vwuc1 
    lda bram_ptr
    ora #<$a000
    sta bram_ptr
    lda bram_ptr+1
    ora #>$a000
    sta bram_ptr+1
    // bram_heap_data_get_offset::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // bram_heap_data_get_offset::@return
    // }
    // [34] stackidx(char *,bram_heap_data_get_offset::OFFSET_STACK_RETURN_0) = (char *)bram_heap_data_get_offset::bram_ptr#0 -- _stackidxptr_vbuc1=pbum1 
    tsx
    lda bram_ptr
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda bram_ptr+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [35] return 
    rts
  .segment DataBramHeap
    .label bram_heap_data_get_offset__2 = bram_ptr
    .label bram_heap_data_get_offset__5 = bram_ptr
    bram_ptr: .word 0
}
.segment CodeBramHeap
  // bram_heap_free
/**
 * @brief Free a memory block from the heap using the handle of allocated memory of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @param handle The handle referring to the heap memory block.
 * @return heap_handle 
 */
// void bram_heap_free(__mem() char s, __mem() char free_index)
bram_heap_free: {
    .const OFFSET_STACK_S = 1
    .const OFFSET_STACK_FREE_INDEX = 0
    // [36] bram_heap_free::s#0 = stackidx(char,bram_heap_free::OFFSET_STACK_S) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_S,x
    sta s
    // [37] bram_heap_free::free_index#0 = stackidx(char,bram_heap_free::OFFSET_STACK_FREE_INDEX) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_FREE_INDEX,x
    sta free_index
    // bram_heap_free::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // bram_heap_free::@5
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [39] bram_heap_free::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_free::bank_set_bram1
    // BRAM = bank
    // [40] BRAM = bram_heap_free::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_free::@6
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [41] bram_heap_get_size_packed::index#0 = bram_heap_free::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [42] call bram_heap_get_size_packed
    // [178] phi from bram_heap_free::@6 to bram_heap_get_size_packed [phi:bram_heap_free::@6->bram_heap_get_size_packed]
    // [178] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#0 [phi:bram_heap_free::@6->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [43] bram_heap_get_size_packed::return#0 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return+1
    // bram_heap_free::@7
    // [44] bram_heap_free::free_size#0 = bram_heap_get_size_packed::return#0 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return
    sta free_size
    lda bram_heap_get_size_packed.return+1
    sta free_size+1
    // bram_heap_data_packed_t free_offset = bram_heap_get_data_packed(s, free_index)
    // [45] bram_heap_get_data_packed::index#0 = bram_heap_free::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [46] call bram_heap_get_data_packed
    // [182] phi from bram_heap_free::@7 to bram_heap_get_data_packed [phi:bram_heap_free::@7->bram_heap_get_data_packed]
    // [182] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#0 [phi:bram_heap_free::@7->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t free_offset = bram_heap_get_data_packed(s, free_index)
    // [47] bram_heap_get_data_packed::return#0 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return+1
    // bram_heap_free::@8
    // [48] bram_heap_free::free_offset#0 = bram_heap_get_data_packed::return#0 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return
    sta free_offset
    lda bram_heap_get_data_packed.return+1
    sta free_offset+1
    // bram_heap_heap_remove(s, free_index)
    // [49] bram_heap_heap_remove::s#0 = bram_heap_free::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_heap_remove.s
    // [50] bram_heap_heap_remove::heap_index#0 = bram_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_heap_remove.heap_index
    // [51] call bram_heap_heap_remove -- call_phi_near 
    // TODO: only remove allocated indexes!
    jsr bram_heap_heap_remove
    // bram_heap_free::@9
    // bram_heap_free_insert(s, free_index, free_offset, free_size)
    // [52] bram_heap_free_insert::s#0 = bram_heap_free::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_free_insert.s
    // [53] bram_heap_free_insert::free_index#0 = bram_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_free_insert.free_index
    // [54] bram_heap_free_insert::data#0 = bram_heap_free::free_offset#0 -- vwum1=vwum2 
    lda free_offset
    sta bram_heap_free_insert.data
    lda free_offset+1
    sta bram_heap_free_insert.data+1
    // [55] bram_heap_free_insert::size#0 = bram_heap_free::free_size#0 -- vwum1=vwum2 
    lda free_size
    sta bram_heap_free_insert.size
    lda free_size+1
    sta bram_heap_free_insert.size+1
    // [56] call bram_heap_free_insert -- call_phi_near 
    jsr bram_heap_free_insert
    // bram_heap_free::@10
    // bram_heap_index_t free_left_index = bram_heap_can_coalesce_left(s, free_index)
    // [57] bram_heap_can_coalesce_left::heap_index#0 = bram_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_can_coalesce_left.heap_index
    // [58] call bram_heap_can_coalesce_left -- call_phi_near 
    jsr bram_heap_can_coalesce_left
    // [59] bram_heap_can_coalesce_left::return#0 = bram_heap_can_coalesce_left::return#3 -- vbuaa=vbuyy 
    tya
    // bram_heap_free::@11
    // [60] bram_heap_free::free_left_index#0 = bram_heap_can_coalesce_left::return#0 -- vbuxx=vbuaa 
    tax
    // if(free_left_index != BRAM_HEAP_NULL)
    // [61] if(bram_heap_free::free_left_index#0==$ff) goto bram_heap_free::@1 -- vbuxx_eq_vbuc1_then_la1 
    cpx #$ff
    beq __b1
    // bram_heap_free::@3
    // bram_heap_coalesce(s, free_left_index, free_index)
    // [62] bram_heap_coalesce::s#0 = bram_heap_free::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_coalesce.s
    // [63] bram_heap_coalesce::left_index#0 = bram_heap_free::free_left_index#0 -- vbum1=vbuxx 
    stx bram_heap_coalesce.left_index
    // [64] bram_heap_coalesce::right_index#0 = bram_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_coalesce.right_index
    // [65] call bram_heap_coalesce
    // [230] phi from bram_heap_free::@3 to bram_heap_coalesce [phi:bram_heap_free::@3->bram_heap_coalesce]
    // [230] phi bram_heap_coalesce::left_index#10 = bram_heap_coalesce::left_index#0 [phi:bram_heap_free::@3->bram_heap_coalesce#0] -- register_copy 
    // [230] phi bram_heap_coalesce::right_index#10 = bram_heap_coalesce::right_index#0 [phi:bram_heap_free::@3->bram_heap_coalesce#1] -- register_copy 
    // [230] phi bram_heap_coalesce::s#10 = bram_heap_coalesce::s#0 [phi:bram_heap_free::@3->bram_heap_coalesce#2] -- call_phi_near 
    jsr bram_heap_coalesce
    // bram_heap_coalesce(s, free_left_index, free_index)
    // [66] bram_heap_coalesce::return#0 = bram_heap_coalesce::right_index#10 -- vbuaa=vbum1 
    lda bram_heap_coalesce.right_index
    // bram_heap_free::@13
    // free_index = bram_heap_coalesce(s, free_left_index, free_index)
    // [67] bram_heap_free::free_index#1 = bram_heap_coalesce::return#0 -- vbum1=vbuaa 
    sta free_index
    // [68] phi from bram_heap_free::@11 bram_heap_free::@13 to bram_heap_free::@1 [phi:bram_heap_free::@11/bram_heap_free::@13->bram_heap_free::@1]
    // [68] phi bram_heap_free::free_index#10 = bram_heap_free::free_index#0 [phi:bram_heap_free::@11/bram_heap_free::@13->bram_heap_free::@1#0] -- register_copy 
    // bram_heap_free::@1
  __b1:
    // bram_heap_index_t free_right_index = heap_can_coalesce_right(s, free_index)
    // [69] heap_can_coalesce_right::heap_index#0 = bram_heap_free::free_index#10 -- vbum1=vbum2 
    lda free_index
    sta heap_can_coalesce_right.heap_index
    // [70] call heap_can_coalesce_right -- call_phi_near 
    jsr heap_can_coalesce_right
    // [71] heap_can_coalesce_right::return#0 = heap_can_coalesce_right::return#3 -- vbuaa=vbum1 
    lda heap_can_coalesce_right.return
    // bram_heap_free::@12
    // [72] bram_heap_free::free_right_index#0 = heap_can_coalesce_right::return#0 -- vbuxx=vbuaa 
    tax
    // if(free_right_index != BRAM_HEAP_NULL)
    // [73] if(bram_heap_free::free_right_index#0==$ff) goto bram_heap_free::@2 -- vbuxx_eq_vbuc1_then_la1 
    cpx #$ff
    beq __b2
    // bram_heap_free::@4
    // bram_heap_coalesce(s, free_index, free_right_index)
    // [74] bram_heap_coalesce::s#1 = bram_heap_free::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_coalesce.s
    // [75] bram_heap_coalesce::left_index#1 = bram_heap_free::free_index#10 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_coalesce.left_index
    // [76] bram_heap_coalesce::right_index#1 = bram_heap_free::free_right_index#0 -- vbum1=vbuxx 
    stx bram_heap_coalesce.right_index
    // [77] call bram_heap_coalesce
    // [230] phi from bram_heap_free::@4 to bram_heap_coalesce [phi:bram_heap_free::@4->bram_heap_coalesce]
    // [230] phi bram_heap_coalesce::left_index#10 = bram_heap_coalesce::left_index#1 [phi:bram_heap_free::@4->bram_heap_coalesce#0] -- register_copy 
    // [230] phi bram_heap_coalesce::right_index#10 = bram_heap_coalesce::right_index#1 [phi:bram_heap_free::@4->bram_heap_coalesce#1] -- register_copy 
    // [230] phi bram_heap_coalesce::s#10 = bram_heap_coalesce::s#1 [phi:bram_heap_free::@4->bram_heap_coalesce#2] -- call_phi_near 
    jsr bram_heap_coalesce
    // bram_heap_free::@2
  __b2:
    // bram_heap_segment.freeSize[s] += free_size
    // [78] bram_heap_free::$16 = bram_heap_free::s#0 << 1 -- vbuxx=vbum1_rol_1 
    lda s
    asl
    tax
    // [79] ((unsigned int *)&bram_heap_segment+$5e)[bram_heap_free::$16] = ((unsigned int *)&bram_heap_segment+$5e)[bram_heap_free::$16] + bram_heap_free::free_size#0 -- pwuc1_derefidx_vbuxx=pwuc1_derefidx_vbuxx_plus_vwum1 
    lda bram_heap_segment+$5e,x
    clc
    adc free_size
    sta bram_heap_segment+$5e,x
    lda bram_heap_segment+$5e+1,x
    adc free_size+1
    sta bram_heap_segment+$5e+1,x
    // bram_heap_segment.heapSize[s] -= free_size
    // [80] ((unsigned int *)&bram_heap_segment+$56)[bram_heap_free::$16] = ((unsigned int *)&bram_heap_segment+$56)[bram_heap_free::$16] - bram_heap_free::free_size#0 -- pwuc1_derefidx_vbuxx=pwuc1_derefidx_vbuxx_minus_vwum1 
    lda bram_heap_segment+$56,x
    sec
    sbc free_size
    sta bram_heap_segment+$56,x
    lda bram_heap_segment+$56+1,x
    sbc free_size+1
    sta bram_heap_segment+$56+1,x
    // bram_heap_free::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // bram_heap_free::@return
    // }
    // [82] return 
    rts
  .segment Data
    s: .byte 0
    free_index: .byte 0
  .segment DataBramHeap
    free_size: .word 0
    free_offset: .word 0
}
.segment CodeBramHeap
  // bram_heap_alloc
/**
 * @brief Allocated a specified size of memory on the heap of the segment.
 * 
 * @param size Specifies the size of memory to be allocated.
 * Note that the size is aligned to an 8 byte boundary by the memory manager.
 * When the size of the memory block is enquired, an 8 byte aligned value will be returned.
 * @return heap_handle The handle referring to the free record in the index.
 */
// __register(X) char bram_heap_alloc(__mem() char s, __mem() unsigned long size)
bram_heap_alloc: {
    .const OFFSET_STACK_S = 4
    .const OFFSET_STACK_SIZE = 0
    .const OFFSET_STACK_RETURN_4 = 4
    // [83] bram_heap_alloc::s#0 = stackidx(char,bram_heap_alloc::OFFSET_STACK_S) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_S,x
    sta s
    // [84] bram_heap_alloc::size#0 = stackidx(unsigned long,bram_heap_alloc::OFFSET_STACK_SIZE) -- vdum1=_stackidxdword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_SIZE,x
    sta size
    lda STACK_BASE+OFFSET_STACK_SIZE+1,x
    sta size+1
    lda STACK_BASE+OFFSET_STACK_SIZE+2,x
    sta size+2
    lda STACK_BASE+OFFSET_STACK_SIZE+3,x
    sta size+3
    // bram_heap_alloc::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // bram_heap_alloc::@2
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [86] bram_heap_alloc::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_alloc::bank_set_bram1
    // BRAM = bank
    // [87] BRAM = bram_heap_alloc::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_alloc::@3
    // bram_heap_size_packed_t packed_size = bram_heap_alloc_size_get(size)
    // [88] bram_heap_alloc_size_get::size#0 = bram_heap_alloc::size#0 -- vdum1=vdum2 
    lda size
    sta bram_heap_alloc_size_get.size
    lda size+1
    sta bram_heap_alloc_size_get.size+1
    lda size+2
    sta bram_heap_alloc_size_get.size+2
    lda size+3
    sta bram_heap_alloc_size_get.size+3
    // [89] call bram_heap_alloc_size_get -- call_phi_near 
    // Adjust given size to 8 bytes boundary (shift right with 3 bits).
    jsr bram_heap_alloc_size_get
    // [90] bram_heap_alloc_size_get::return#0 = bram_heap_alloc_size_get::return#1 -- vwum1=vwum2 
    lda bram_heap_alloc_size_get.return_1
    sta bram_heap_alloc_size_get.return
    lda bram_heap_alloc_size_get.return_1+1
    sta bram_heap_alloc_size_get.return+1
    // bram_heap_alloc::@4
    // [91] bram_heap_alloc::packed_size#0 = bram_heap_alloc_size_get::return#0 -- vwum1=vwum2 
    lda bram_heap_alloc_size_get.return
    sta packed_size
    lda bram_heap_alloc_size_get.return+1
    sta packed_size+1
    // bram_heap_index_t free_index = bram_heap_find_best_fit(s, packed_size)
    // [92] bram_heap_find_best_fit::s#0 = bram_heap_alloc::s#0 -- vbuxx=vbum1 
    ldx s
    // [93] bram_heap_find_best_fit::requested_size#0 = bram_heap_alloc::packed_size#0 -- vwum1=vwum2 
    lda packed_size
    sta bram_heap_find_best_fit.requested_size
    lda packed_size+1
    sta bram_heap_find_best_fit.requested_size+1
    // [94] call bram_heap_find_best_fit -- call_phi_near 
    jsr bram_heap_find_best_fit
    // [95] bram_heap_find_best_fit::return#0 = bram_heap_find_best_fit::return#2 -- vbuxx=vbum1 
    ldx bram_heap_find_best_fit.return
    // bram_heap_alloc::@5
    // [96] bram_heap_alloc::free_index#0 = bram_heap_find_best_fit::return#0
    // if(free_index != BRAM_HEAP_NULL)
    // [97] if(bram_heap_alloc::free_index#0!=$ff) goto bram_heap_alloc::@1 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$ff
    bne __b1
    // [98] phi from bram_heap_alloc::@5 to bram_heap_alloc::bank_pull_bram1 [phi:bram_heap_alloc::@5->bram_heap_alloc::bank_pull_bram1]
    // [98] phi bram_heap_alloc::return#0 = $ff [phi:bram_heap_alloc::@5->bram_heap_alloc::bank_pull_bram1#0] -- vbuxx=vbuc1 
    ldx #$ff
    // bram_heap_alloc::bank_pull_bram1
  bank_pull_bram1:
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // bram_heap_alloc::@return
    // }
    // [100] stackidx(char,bram_heap_alloc::OFFSET_STACK_RETURN_4) = bram_heap_alloc::return#0 -- _stackidxbyte_vbuc1=vbuxx 
    txa
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_4,x
    // [101] return 
    rts
    // bram_heap_alloc::@1
  __b1:
    // bram_heap_allocate(s, free_index, packed_size)
    // [102] bram_heap_allocate::s#0 = bram_heap_alloc::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_allocate.s
    // [103] bram_heap_allocate::free_index#0 = bram_heap_alloc::free_index#0 -- vbum1=vbuxx 
    stx bram_heap_allocate.free_index
    // [104] bram_heap_allocate::required_size#0 = bram_heap_alloc::packed_size#0 -- vwum1=vwum2 
    lda packed_size
    sta bram_heap_allocate.required_size
    lda packed_size+1
    sta bram_heap_allocate.required_size+1
    // [105] call bram_heap_allocate -- call_phi_near 
    jsr bram_heap_allocate
    // [106] bram_heap_allocate::return#0 = bram_heap_allocate::return#4
    // bram_heap_alloc::@6
    // heap_index = bram_heap_allocate(s, free_index, packed_size)
    // [107] bram_heap_alloc::heap_index#1 = bram_heap_allocate::return#0 -- vbuxx=vbuaa 
    tax
    // bram_heap_segment.freeSize[s] -= packed_size
    // [108] bram_heap_alloc::$8 = bram_heap_alloc::s#0 << 1 -- vbuyy=vbum1_rol_1 
    lda s
    asl
    tay
    // [109] ((unsigned int *)&bram_heap_segment+$5e)[bram_heap_alloc::$8] = ((unsigned int *)&bram_heap_segment+$5e)[bram_heap_alloc::$8] - bram_heap_alloc::packed_size#0 -- pwuc1_derefidx_vbuyy=pwuc1_derefidx_vbuyy_minus_vwum1 
    lda bram_heap_segment+$5e,y
    sec
    sbc packed_size
    sta bram_heap_segment+$5e,y
    lda bram_heap_segment+$5e+1,y
    sbc packed_size+1
    sta bram_heap_segment+$5e+1,y
    // bram_heap_segment.heapSize[s] += packed_size
    // [110] ((unsigned int *)&bram_heap_segment+$56)[bram_heap_alloc::$8] = ((unsigned int *)&bram_heap_segment+$56)[bram_heap_alloc::$8] + bram_heap_alloc::packed_size#0 -- pwuc1_derefidx_vbuyy=pwuc1_derefidx_vbuyy_plus_vwum1 
    lda bram_heap_segment+$56,y
    clc
    adc packed_size
    sta bram_heap_segment+$56,y
    lda bram_heap_segment+$56+1,y
    adc packed_size+1
    sta bram_heap_segment+$56+1,y
    // [98] phi from bram_heap_alloc::@6 to bram_heap_alloc::bank_pull_bram1 [phi:bram_heap_alloc::@6->bram_heap_alloc::bank_pull_bram1]
    // [98] phi bram_heap_alloc::return#0 = bram_heap_alloc::heap_index#1 [phi:bram_heap_alloc::@6->bram_heap_alloc::bank_pull_bram1#0] -- register_copy 
    jmp bank_pull_bram1
  .segment Data
    s: .byte 0
    size: .dword 0
  .segment DataBramHeap
    packed_size: .word 0
}
.segment CodeBramHeap
  // bram_heap_segment_init
/**
 * @brief Create a heap segment in cx16 vera ram.
 * For the given segment, a value between 0 and 15, define a heap in vera ram.
 * A heap in vera ram is useful to dynamically load tiles or sprites 
 * without having to be concerned of memmory management anymore.
 * The heap memory manager will manage the memory for you!
 * The heapCeilVram and heapSizeVram define the heap in the VERA ram.
 * An index needs to be created, and is managed by the heap memory manager, which
 * is specified by the indexFloorBram and indexSizeBram parameters.
 * Note that all these parameters are in packed format, and must be specified using
 * the respective packed functions.
 * 
 * @example 
 * // Allocate the segment for the sprites in vram.
 * heap_vram_packed vram_sprites = heap_segment_vram_ceil( 1,
 *    vram_petscii,
 *    vram_petscii,
 *    heap_bram_pack(2, (heap_ptr)0xA000),
 *    heap_size_pack(0x2000)
 * );
 * 
 * @return void 
 */
// char bram_heap_segment_init(__mem() char s, __mem() char bram_bank_floor, __mem() char *bram_ptr_floor, __mem() char bram_bank_ceil, __mem() char *bram_ptr_ceil)
bram_heap_segment_init: {
    .const OFFSET_STACK_S = 6
    .const OFFSET_STACK_BRAM_BANK_FLOOR = 5
    .const OFFSET_STACK_BRAM_PTR_FLOOR = 3
    .const OFFSET_STACK_BRAM_BANK_CEIL = 2
    .const OFFSET_STACK_BRAM_PTR_CEIL = 0
    .const OFFSET_STACK_RETURN_6 = 6
    // [111] bram_heap_segment_init::s#0 = stackidx(char,bram_heap_segment_init::OFFSET_STACK_S) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_S,x
    sta s
    // [112] bram_heap_segment_init::bram_bank_floor#0 = stackidx(char,bram_heap_segment_init::OFFSET_STACK_BRAM_BANK_FLOOR) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_BANK_FLOOR,x
    sta bram_bank_floor
    // [113] bram_heap_segment_init::bram_ptr_floor#0 = stackidx(char *,bram_heap_segment_init::OFFSET_STACK_BRAM_PTR_FLOOR) -- pbum1=_stackidxptr_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_PTR_FLOOR,x
    sta bram_ptr_floor
    lda STACK_BASE+OFFSET_STACK_BRAM_PTR_FLOOR+1,x
    sta bram_ptr_floor+1
    // [114] bram_heap_segment_init::bram_bank_ceil#0 = stackidx(char,bram_heap_segment_init::OFFSET_STACK_BRAM_BANK_CEIL) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_BANK_CEIL,x
    sta bram_bank_ceil
    // [115] bram_heap_segment_init::bram_ptr_ceil#0 = stackidx(char *,bram_heap_segment_init::OFFSET_STACK_BRAM_PTR_CEIL) -- pbum1=_stackidxptr_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_PTR_CEIL,x
    sta bram_ptr_ceil
    lda STACK_BASE+OFFSET_STACK_BRAM_PTR_CEIL+1,x
    sta bram_ptr_ceil+1
    // bram_heap_segment.bram_bank_floor[s] = bram_bank_floor
    // [116] ((char *)&bram_heap_segment+2)[bram_heap_segment_init::s#0] = bram_heap_segment_init::bram_bank_floor#0 -- pbuc1_derefidx_vbum1=vbum2 
    // TODO initialize segment to all zero
    lda bram_bank_floor
    ldy s
    sta bram_heap_segment+2,y
    // bram_heap_segment.bram_ptr_floor[s] = bram_ptr_floor
    // [117] bram_heap_segment_init::$16 = bram_heap_segment_init::s#0 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta bram_heap_segment_init__16
    // [118] ((void **)&bram_heap_segment+6)[bram_heap_segment_init::$16] = (void *)bram_heap_segment_init::bram_ptr_floor#0 -- qvoc1_derefidx_vbum1=pvom2 
    tay
    lda bram_ptr_floor
    sta bram_heap_segment+6,y
    lda bram_ptr_floor+1
    sta bram_heap_segment+6+1,y
    // bram_heap_segment.bram_bank_ceil[s] = bram_bank_ceil
    // [119] ((char *)&bram_heap_segment+$16)[bram_heap_segment_init::s#0] = bram_heap_segment_init::bram_bank_ceil#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda bram_bank_ceil
    ldy s
    sta bram_heap_segment+$16,y
    // bram_heap_segment.bram_ptr_ceil[s] = bram_ptr_ceil
    // [120] ((void **)&bram_heap_segment+$1a)[bram_heap_segment_init::$16] = (void *)bram_heap_segment_init::bram_ptr_ceil#0 -- qvoc1_derefidx_vbum1=pvom2 
    ldy bram_heap_segment_init__16
    lda bram_ptr_ceil
    sta bram_heap_segment+$1a,y
    lda bram_ptr_ceil+1
    sta bram_heap_segment+$1a+1,y
    // bram_heap_data_pack(bram_bank_floor, bram_ptr_floor)
    // [121] bram_heap_data_pack::bram_bank#0 = bram_heap_segment_init::bram_bank_floor#0 -- vbuxx=vbum1 
    ldx bram_bank_floor
    // [122] bram_heap_data_pack::bram_ptr#0 = bram_heap_segment_init::bram_ptr_floor#0
    // [123] call bram_heap_data_pack
    // [331] phi from bram_heap_segment_init to bram_heap_data_pack [phi:bram_heap_segment_init->bram_heap_data_pack]
    // [331] phi bram_heap_data_pack::bram_ptr#2 = bram_heap_data_pack::bram_ptr#0 [phi:bram_heap_segment_init->bram_heap_data_pack#0] -- register_copy 
    // [331] phi bram_heap_data_pack::bram_bank#2 = bram_heap_data_pack::bram_bank#0 [phi:bram_heap_segment_init->bram_heap_data_pack#1] -- call_phi_near 
    jsr bram_heap_data_pack
    // bram_heap_data_pack(bram_bank_floor, bram_ptr_floor)
    // [124] bram_heap_data_pack::return#0 = bram_heap_data_pack::return#2
    // bram_heap_segment_init::@4
    // [125] bram_heap_segment_init::$0 = bram_heap_data_pack::return#0
    // bram_heap_segment.floor[s] = bram_heap_data_pack(bram_bank_floor, bram_ptr_floor)
    // [126] ((unsigned int *)&bram_heap_segment+$e)[bram_heap_segment_init::$16] = bram_heap_segment_init::$0 -- pwuc1_derefidx_vbum1=vwum2 
    ldy bram_heap_segment_init__16
    lda bram_heap_segment_init__0
    sta bram_heap_segment+$e,y
    lda bram_heap_segment_init__0+1
    sta bram_heap_segment+$e+1,y
    // bram_heap_data_pack(bram_bank_ceil, bram_ptr_ceil)
    // [127] bram_heap_data_pack::bram_bank#1 = bram_heap_segment_init::bram_bank_ceil#0 -- vbuxx=vbum1 
    ldx bram_bank_ceil
    // [128] bram_heap_data_pack::bram_ptr#1 = bram_heap_segment_init::bram_ptr_ceil#0 -- pbum1=pbum2 
    lda bram_ptr_ceil
    sta bram_heap_data_pack.bram_ptr
    lda bram_ptr_ceil+1
    sta bram_heap_data_pack.bram_ptr+1
    // [129] call bram_heap_data_pack
    // [331] phi from bram_heap_segment_init::@4 to bram_heap_data_pack [phi:bram_heap_segment_init::@4->bram_heap_data_pack]
    // [331] phi bram_heap_data_pack::bram_ptr#2 = bram_heap_data_pack::bram_ptr#1 [phi:bram_heap_segment_init::@4->bram_heap_data_pack#0] -- register_copy 
    // [331] phi bram_heap_data_pack::bram_bank#2 = bram_heap_data_pack::bram_bank#1 [phi:bram_heap_segment_init::@4->bram_heap_data_pack#1] -- call_phi_near 
    jsr bram_heap_data_pack
    // bram_heap_data_pack(bram_bank_ceil, bram_ptr_ceil)
    // [130] bram_heap_data_pack::return#1 = bram_heap_data_pack::return#2
    // bram_heap_segment_init::@5
    // [131] bram_heap_segment_init::$1 = bram_heap_data_pack::return#1
    // bram_heap_segment.ceil[s]  = bram_heap_data_pack(bram_bank_ceil, bram_ptr_ceil)
    // [132] ((unsigned int *)&bram_heap_segment+$22)[bram_heap_segment_init::$16] = bram_heap_segment_init::$1 -- pwuc1_derefidx_vbum1=vwum2 
    ldy bram_heap_segment_init__16
    lda bram_heap_segment_init__1
    sta bram_heap_segment+$22,y
    lda bram_heap_segment_init__1+1
    sta bram_heap_segment+$22+1,y
    // bram_heap_segment.heap_offset[s] = 0
    // [133] ((unsigned int *)&bram_heap_segment+$36)[bram_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta bram_heap_segment+$36,y
    sta bram_heap_segment+$36+1,y
    // bram_heap_size_packed_t free_size = bram_heap_segment.ceil[s]
    // [134] bram_heap_segment_init::free_size#0 = ((unsigned int *)&bram_heap_segment+$22)[bram_heap_segment_init::$16] -- vwum1=pwuc1_derefidx_vbum2 
    lda bram_heap_segment+$22,y
    sta free_size
    lda bram_heap_segment+$22+1,y
    sta free_size+1
    // free_size -= bram_heap_segment.floor[s]
    // [135] bram_heap_segment_init::free_size#1 = bram_heap_segment_init::free_size#0 - ((unsigned int *)&bram_heap_segment+$e)[bram_heap_segment_init::$16] -- vwum1=vwum1_minus_pwuc1_derefidx_vbum2 
    lda free_size
    sec
    sbc bram_heap_segment+$e,y
    sta free_size
    lda free_size+1
    sbc bram_heap_segment+$e+1,y
    sta free_size+1
    // bram_heap_segment.heapCount[s] = 0
    // [136] ((unsigned int *)&bram_heap_segment+$3e)[bram_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta bram_heap_segment+$3e,y
    sta bram_heap_segment+$3e+1,y
    // bram_heap_segment.freeCount[s] = 0
    // [137] ((unsigned int *)&bram_heap_segment+$46)[bram_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    sta bram_heap_segment+$46,y
    sta bram_heap_segment+$46+1,y
    // bram_heap_segment.idleCount[s] = 0
    // [138] ((unsigned int *)&bram_heap_segment+$4e)[bram_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    sta bram_heap_segment+$4e,y
    sta bram_heap_segment+$4e+1,y
    // bram_heap_segment.heap_list[s] = BRAM_HEAP_NULL
    // [139] ((char *)&bram_heap_segment+$2a)[bram_heap_segment_init::s#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    lda #$ff
    ldy s
    sta bram_heap_segment+$2a,y
    // bram_heap_segment.idle_list[s] = BRAM_HEAP_NULL
    // [140] ((char *)&bram_heap_segment+$32)[bram_heap_segment_init::s#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta bram_heap_segment+$32,y
    // bram_heap_segment.free_list[s] = BRAM_HEAP_NULL
    // [141] ((char *)&bram_heap_segment+$2e)[bram_heap_segment_init::s#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta bram_heap_segment+$2e,y
    // bram_heap_segment_init::bank_get_bram1
    // return BRAM;
    // [142] bram_heap_segment_init::bank_old#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_old
    // bram_heap_segment_init::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [143] bram_heap_segment_init::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_segment_init::bank_set_bram1
    // BRAM = bank
    // [144] BRAM = bram_heap_segment_init::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_segment_init::@2
    // bram_heap_index_t free_index = bram_heap_index_add(s)
    // [145] bram_heap_index_add::s#0 = bram_heap_segment_init::s#0 -- vbuxx=vbum1 
    ldx s
    // [146] call bram_heap_index_add
    // [337] phi from bram_heap_segment_init::@2 to bram_heap_index_add [phi:bram_heap_segment_init::@2->bram_heap_index_add]
    // [337] phi bram_heap_index_add::s#2 = bram_heap_index_add::s#0 [phi:bram_heap_segment_init::@2->bram_heap_index_add#0] -- call_phi_near 
    jsr bram_heap_index_add
    // bram_heap_index_t free_index = bram_heap_index_add(s)
    // [147] bram_heap_index_add::return#0 = bram_heap_index_add::return#1 -- vbuaa=vbum1 
    lda bram_heap_index_add.return
    // bram_heap_segment_init::@6
    // [148] bram_heap_segment_init::free_index#0 = bram_heap_index_add::return#0
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, free_index)
    // [149] bram_heap_list_insert_at::list#0 = ((char *)&bram_heap_segment+$2e)[bram_heap_segment_init::s#0] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$2e,y
    // [150] bram_heap_list_insert_at::index#0 = bram_heap_segment_init::free_index#0 -- vbum1=vbuaa 
    sta bram_heap_list_insert_at.index
    // [151] bram_heap_list_insert_at::at#0 = bram_heap_segment_init::free_index#0 -- vbum1=vbuaa 
    sta bram_heap_list_insert_at.at
    // [152] call bram_heap_list_insert_at
    // [347] phi from bram_heap_segment_init::@6 to bram_heap_list_insert_at [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at]
    // [347] phi bram_heap_list_insert_at::index#10 = bram_heap_list_insert_at::index#0 [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at#0] -- register_copy 
    // [347] phi bram_heap_list_insert_at::at#11 = bram_heap_list_insert_at::at#0 [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at#1] -- register_copy 
    // [347] phi bram_heap_list_insert_at::list#5 = bram_heap_list_insert_at::list#0 [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at#2] -- call_phi_near 
    jsr bram_heap_list_insert_at
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, free_index)
    // [153] bram_heap_list_insert_at::return#0 = bram_heap_list_insert_at::list#11
    // bram_heap_segment_init::@7
    // [154] bram_heap_segment_init::free_index#1 = bram_heap_list_insert_at::return#0 -- vbum1=vbuxx 
    stx free_index
    // bram_heap_set_data_packed(s, free_index, bram_heap_segment.floor[s])
    // [155] bram_heap_set_data_packed::index#0 = bram_heap_segment_init::free_index#1 -- vbuxx=vbum1 
    // [156] bram_heap_set_data_packed::data_packed#0 = ((unsigned int *)&bram_heap_segment+$e)[bram_heap_segment_init::$16] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_segment_init__16
    lda bram_heap_segment+$e,y
    sta bram_heap_set_data_packed.data_packed
    lda bram_heap_segment+$e+1,y
    sta bram_heap_set_data_packed.data_packed+1
    // [157] call bram_heap_set_data_packed
    // [362] phi from bram_heap_segment_init::@7 to bram_heap_set_data_packed [phi:bram_heap_segment_init::@7->bram_heap_set_data_packed]
    // [362] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#0 [phi:bram_heap_segment_init::@7->bram_heap_set_data_packed#0] -- register_copy 
    // [362] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#0 [phi:bram_heap_segment_init::@7->bram_heap_set_data_packed#1] -- call_phi_near 
    jsr bram_heap_set_data_packed
    // bram_heap_segment_init::@8
    // bram_heap_set_size_packed(s, free_index, bram_heap_segment.ceil[s] - bram_heap_segment.floor[s])
    // [158] bram_heap_set_size_packed::size_packed#0 = ((unsigned int *)&bram_heap_segment+$22)[bram_heap_segment_init::$16] - ((unsigned int *)&bram_heap_segment+$e)[bram_heap_segment_init::$16] -- vwum1=pwuc1_derefidx_vbum2_minus_pwuc2_derefidx_vbum2 
    ldy bram_heap_segment_init__16
    lda bram_heap_segment+$22,y
    sec
    sbc bram_heap_segment+$e,y
    sta bram_heap_set_size_packed.size_packed
    lda bram_heap_segment+$22+1,y
    sbc bram_heap_segment+$e+1,y
    sta bram_heap_set_size_packed.size_packed+1
    // [159] bram_heap_set_size_packed::index#0 = bram_heap_segment_init::free_index#1 -- vbuxx=vbum1 
    ldx free_index
    // [160] call bram_heap_set_size_packed
    // [368] phi from bram_heap_segment_init::@8 to bram_heap_set_size_packed [phi:bram_heap_segment_init::@8->bram_heap_set_size_packed]
    // [368] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#0 [phi:bram_heap_segment_init::@8->bram_heap_set_size_packed#0] -- register_copy 
    // [368] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#0 [phi:bram_heap_segment_init::@8->bram_heap_set_size_packed#1] -- call_phi_near 
    jsr bram_heap_set_size_packed
    // bram_heap_segment_init::@9
    // bram_heap_set_free(s, free_index)
    // [161] bram_heap_set_free::index#0 = bram_heap_segment_init::free_index#1 -- vbuxx=vbum1 
    ldx free_index
    // [162] call bram_heap_set_free
    // [377] phi from bram_heap_segment_init::@9 to bram_heap_set_free [phi:bram_heap_segment_init::@9->bram_heap_set_free]
    // [377] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#0 [phi:bram_heap_segment_init::@9->bram_heap_set_free#0] -- call_phi_near 
    jsr bram_heap_set_free
    // bram_heap_segment_init::bram_heap_set_next1
    // bram_heap_index.next[index] = next
    // [163] ((char *)&bram_heap_index+$400)[bram_heap_segment_init::free_index#1] = bram_heap_segment_init::free_index#1 -- pbuc1_derefidx_vbum1=vbum1 
    ldy free_index
    tya
    sta bram_heap_index+$400,y
    // bram_heap_segment_init::bram_heap_set_prev1
    // bram_heap_index.prev[index] = prev
    // [164] ((char *)&bram_heap_index+$500)[bram_heap_segment_init::free_index#1] = bram_heap_segment_init::free_index#1 -- pbuc1_derefidx_vbum1=vbum1 
    tya
    sta bram_heap_index+$500,y
    // bram_heap_segment_init::@3
    // bram_heap_segment.freeCount[s]++;
    // [165] ((unsigned int *)&bram_heap_segment+$46)[bram_heap_segment_init::$16] = ++ ((unsigned int *)&bram_heap_segment+$46)[bram_heap_segment_init::$16] -- pwuc1_derefidx_vbum1=_inc_pwuc1_derefidx_vbum1 
    ldx bram_heap_segment_init__16
    inc bram_heap_segment+$46,x
    bne !+
    inc bram_heap_segment+$46+1,x
  !:
    // bram_heap_segment.free_list[s] = free_index
    // [166] ((char *)&bram_heap_segment+$2e)[bram_heap_segment_init::s#0] = bram_heap_segment_init::free_index#1 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_index
    ldy s
    sta bram_heap_segment+$2e,y
    // bram_heap_segment.freeSize[s] = free_size
    // [167] ((unsigned int *)&bram_heap_segment+$5e)[bram_heap_segment_init::$16] = bram_heap_segment_init::free_size#1 -- pwuc1_derefidx_vbum1=vwum2 
    ldy bram_heap_segment_init__16
    lda free_size
    sta bram_heap_segment+$5e,y
    lda free_size+1
    sta bram_heap_segment+$5e+1,y
    // bram_heap_segment.heapSize[s] = 0
    // [168] ((unsigned int *)&bram_heap_segment+$56)[bram_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta bram_heap_segment+$56,y
    sta bram_heap_segment+$56+1,y
    // bram_heap_segment_init::bank_set_bram2
    // BRAM = bank
    // [169] BRAM = bram_heap_segment_init::bank_old#0 -- vbuz1=vbum2 
    lda bank_old
    sta.z BRAM
    // bram_heap_segment_init::@return
    // }
    // [170] stackidx(char,bram_heap_segment_init::OFFSET_STACK_RETURN_6) = bram_heap_segment_init::s#0 -- _stackidxbyte_vbuc1=vbum1 
    lda s
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_6,x
    // [171] return 
    rts
  .segment DataBramHeap
    .label bram_heap_segment_init__0 = bram_heap_data_pack.bram_ptr
    .label bram_heap_segment_init__1 = bram_heap_data_pack.bram_ptr
    bram_heap_segment_init__16: .byte 0
  .segment Data
    s: .byte 0
    bram_bank_floor: .byte 0
    .label bram_ptr_floor = bram_heap_data_pack.bram_ptr
    bram_bank_ceil: .byte 0
    bram_ptr_ceil: .word 0
  .segment DataBramHeap
    .label free_size = bram_heap_data_pack.bram_ptr
    bank_old: .byte 0
    free_index: .byte 0
}
.segment CodeBramHeap
  // bram_heap_bram_bank_init
// void bram_heap_bram_bank_init(__register(A) char bram_bank)
bram_heap_bram_bank_init: {
    .const OFFSET_STACK_BRAM_BANK = 0
    // [172] bram_heap_bram_bank_init::bram_bank#0 = stackidx(char,bram_heap_bram_bank_init::OFFSET_STACK_BRAM_BANK) -- vbuaa=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_BANK,x
    // bram_heap_segment.bram_bank = bram_bank
    // [173] *((char *)&bram_heap_segment) = bram_heap_bram_bank_init::bram_bank#0 -- _deref_pbuc1=vbuaa 
    sta bram_heap_segment
    // bram_heap_segment.index_position = 0
    // [174] *((char *)&bram_heap_segment+1) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta bram_heap_segment+1
    // bram_heap_bram_bank_init::@return
    // }
    // [175] return 
    rts
}
.segment Code
  // main
main: {
    // main::@return
    // [177] return 
    rts
}
.segment CodeBramHeap
  // bram_heap_get_size_packed
// __mem() unsigned int bram_heap_get_size_packed(char s, __register(X) char index)
bram_heap_get_size_packed: {
    // bram_heap_index.size1[index] & 0x7F
    // [179] bram_heap_get_size_packed::$0 = ((char *)&bram_heap_index+$300)[bram_heap_get_size_packed::index#8] & $7f -- vbuaa=pbuc1_derefidx_vbuxx_band_vbuc2 
    lda #$7f
    and bram_heap_index+$300,x
    // MAKEWORD(bram_heap_index.size1[index] & 0x7F, bram_heap_index.size0[index])
    // [180] bram_heap_get_size_packed::return#12 = bram_heap_get_size_packed::$0 w= ((char *)&bram_heap_index+$200)[bram_heap_get_size_packed::index#8] -- vwum1=vbuaa_word_pbuc1_derefidx_vbuxx 
    sta return_2+1
    lda bram_heap_index+$200,x
    sta return_2
    // bram_heap_get_size_packed::@return
    // }
    // [181] return 
    rts
  .segment Data
    return: .word 0
    return_1: .word 0
    return_2: .word 0
    return_3: .word 0
    return_4: .word 0
    return_5: .word 0
    return_6: .word 0
    return_7: .word 0
}
.segment CodeBramHeap
  // bram_heap_get_data_packed
// __mem() unsigned int bram_heap_get_data_packed(char s, __register(X) char index)
bram_heap_get_data_packed: {
    // MAKEWORD(bram_heap_index.data1[index],bram_heap_index.data0[index])
    // [183] bram_heap_get_data_packed::return#1 = ((char *)&bram_heap_index+$100)[bram_heap_get_data_packed::index#8] w= ((char *)&bram_heap_index)[bram_heap_get_data_packed::index#8] -- vwum1=pbuc1_derefidx_vbuxx_word_pbuc2_derefidx_vbuxx 
    lda bram_heap_index+$100,x
    sta return_1+1
    lda bram_heap_index,x
    sta return_1
    // bram_heap_get_data_packed::@return
    // }
    // [184] return 
    rts
  .segment Data
    return: .word 0
    return_1: .word 0
    return_2: .word 0
    return_3: .word 0
    return_4: .word 0
    return_5: .word 0
    return_6: .word 0
    return_7: .word 0
    return_8: .word 0
}
.segment CodeBramHeap
  // bram_heap_heap_remove
// void bram_heap_heap_remove(__mem() char s, __mem() char heap_index)
bram_heap_heap_remove: {
    // bram_heap_segment.heapCount[s]--;
    // [185] bram_heap_heap_remove::$3 = bram_heap_heap_remove::s#0 << 1 -- vbuaa=vbum1_rol_1 
    lda s
    asl
    // [186] ((unsigned int *)&bram_heap_segment+$3e)[bram_heap_heap_remove::$3] = -- ((unsigned int *)&bram_heap_segment+$3e)[bram_heap_heap_remove::$3] -- pwuc1_derefidx_vbuaa=_dec_pwuc1_derefidx_vbuaa 
    tax
    lda bram_heap_segment+$3e,x
    bne !+
    dec bram_heap_segment+$3e+1,x
  !:
    dec bram_heap_segment+$3e,x
    // bram_heap_list_remove(s, bram_heap_segment.heap_list[s], heap_index)
    // [187] bram_heap_list_remove::list#2 = ((char *)&bram_heap_segment+$2a)[bram_heap_heap_remove::s#0] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$2a,y
    // [188] bram_heap_list_remove::index#0 = bram_heap_heap_remove::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_list_remove.index
    // [189] call bram_heap_list_remove
    // [380] phi from bram_heap_heap_remove to bram_heap_list_remove [phi:bram_heap_heap_remove->bram_heap_list_remove]
    // [380] phi bram_heap_list_remove::index#10 = bram_heap_list_remove::index#0 [phi:bram_heap_heap_remove->bram_heap_list_remove#0] -- register_copy 
    // [380] phi bram_heap_list_remove::list#10 = bram_heap_list_remove::list#2 [phi:bram_heap_heap_remove->bram_heap_list_remove#1] -- call_phi_near 
    jsr bram_heap_list_remove
    // bram_heap_list_remove(s, bram_heap_segment.heap_list[s], heap_index)
    // [190] bram_heap_list_remove::return#4 = bram_heap_list_remove::return#1 -- vbuaa=vbuxx 
    txa
    // bram_heap_heap_remove::@1
    // [191] bram_heap_heap_remove::$1 = bram_heap_list_remove::return#4
    // bram_heap_segment.heap_list[s] = bram_heap_list_remove(s, bram_heap_segment.heap_list[s], heap_index)
    // [192] ((char *)&bram_heap_segment+$2a)[bram_heap_heap_remove::s#0] = bram_heap_heap_remove::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy s
    sta bram_heap_segment+$2a,y
    // bram_heap_heap_remove::@return
    // }
    // [193] return 
    rts
  .segment Data
    s: .byte 0
    heap_index: .byte 0
}
.segment CodeBramHeap
  // bram_heap_free_insert
// char bram_heap_free_insert(__mem() char s, __mem() char free_index, __mem() unsigned int data, __mem() unsigned int size)
bram_heap_free_insert: {
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, bram_heap_segment.free_list[s])
    // [194] bram_heap_list_insert_at::list#3 = ((char *)&bram_heap_segment+$2e)[bram_heap_free_insert::s#0] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$2e,y
    // [195] bram_heap_list_insert_at::index#2 = bram_heap_free_insert::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_list_insert_at.index
    // [196] bram_heap_list_insert_at::at#3 = ((char *)&bram_heap_segment+$2e)[bram_heap_free_insert::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda bram_heap_segment+$2e,y
    sta bram_heap_list_insert_at.at
    // [197] call bram_heap_list_insert_at
    // [347] phi from bram_heap_free_insert to bram_heap_list_insert_at [phi:bram_heap_free_insert->bram_heap_list_insert_at]
    // [347] phi bram_heap_list_insert_at::index#10 = bram_heap_list_insert_at::index#2 [phi:bram_heap_free_insert->bram_heap_list_insert_at#0] -- register_copy 
    // [347] phi bram_heap_list_insert_at::at#11 = bram_heap_list_insert_at::at#3 [phi:bram_heap_free_insert->bram_heap_list_insert_at#1] -- register_copy 
    // [347] phi bram_heap_list_insert_at::list#5 = bram_heap_list_insert_at::list#3 [phi:bram_heap_free_insert->bram_heap_list_insert_at#2] -- call_phi_near 
    jsr bram_heap_list_insert_at
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, bram_heap_segment.free_list[s])
    // [198] bram_heap_list_insert_at::return#4 = bram_heap_list_insert_at::list#11 -- vbuaa=vbuxx 
    txa
    // bram_heap_free_insert::@1
    // [199] bram_heap_free_insert::$0 = bram_heap_list_insert_at::return#4
    // bram_heap_segment.free_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, bram_heap_segment.free_list[s])
    // [200] ((char *)&bram_heap_segment+$2e)[bram_heap_free_insert::s#0] = bram_heap_free_insert::$0 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy s
    sta bram_heap_segment+$2e,y
    // bram_heap_set_data_packed(s, free_index, data)
    // [201] bram_heap_set_data_packed::index#1 = bram_heap_free_insert::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [202] bram_heap_set_data_packed::data_packed#1 = bram_heap_free_insert::data#0 -- vwum1=vwum2 
    lda data
    sta bram_heap_set_data_packed.data_packed
    lda data+1
    sta bram_heap_set_data_packed.data_packed+1
    // [203] call bram_heap_set_data_packed
    // [362] phi from bram_heap_free_insert::@1 to bram_heap_set_data_packed [phi:bram_heap_free_insert::@1->bram_heap_set_data_packed]
    // [362] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#1 [phi:bram_heap_free_insert::@1->bram_heap_set_data_packed#0] -- register_copy 
    // [362] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#1 [phi:bram_heap_free_insert::@1->bram_heap_set_data_packed#1] -- call_phi_near 
    jsr bram_heap_set_data_packed
    // bram_heap_free_insert::@2
    // bram_heap_set_size_packed(s, free_index, size)
    // [204] bram_heap_set_size_packed::index#2 = bram_heap_free_insert::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [205] bram_heap_set_size_packed::size_packed#2 = bram_heap_free_insert::size#0 -- vwum1=vwum2 
    lda size
    sta bram_heap_set_size_packed.size_packed
    lda size+1
    sta bram_heap_set_size_packed.size_packed+1
    // [206] call bram_heap_set_size_packed
    // [368] phi from bram_heap_free_insert::@2 to bram_heap_set_size_packed [phi:bram_heap_free_insert::@2->bram_heap_set_size_packed]
    // [368] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#2 [phi:bram_heap_free_insert::@2->bram_heap_set_size_packed#0] -- register_copy 
    // [368] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#2 [phi:bram_heap_free_insert::@2->bram_heap_set_size_packed#1] -- call_phi_near 
    jsr bram_heap_set_size_packed
    // bram_heap_free_insert::@3
    // bram_heap_set_free(s, free_index)
    // [207] bram_heap_set_free::index#1 = bram_heap_free_insert::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [208] call bram_heap_set_free
    // [377] phi from bram_heap_free_insert::@3 to bram_heap_set_free [phi:bram_heap_free_insert::@3->bram_heap_set_free]
    // [377] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#1 [phi:bram_heap_free_insert::@3->bram_heap_set_free#0] -- call_phi_near 
    jsr bram_heap_set_free
    // bram_heap_free_insert::@4
    // bram_heap_segment.freeCount[s]++;
    // [209] bram_heap_free_insert::$6 = bram_heap_free_insert::s#0 << 1 -- vbuaa=vbum1_rol_1 
    lda s
    asl
    // [210] ((unsigned int *)&bram_heap_segment+$46)[bram_heap_free_insert::$6] = ++ ((unsigned int *)&bram_heap_segment+$46)[bram_heap_free_insert::$6] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc bram_heap_segment+$46,x
    bne !+
    inc bram_heap_segment+$46+1,x
  !:
    // bram_heap_free_insert::@return
    // }
    // [211] return 
    rts
  .segment Data
    s: .byte 0
    free_index: .byte 0
    data: .word 0
    size: .word 0
}
.segment CodeBramHeap
  // bram_heap_can_coalesce_left
/**
 * Whether we should merge this header to the left.
 */
// __register(Y) char bram_heap_can_coalesce_left(char s, __mem() char heap_index)
bram_heap_can_coalesce_left: {
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [212] bram_heap_get_data_packed::index#3 = bram_heap_can_coalesce_left::heap_index#0 -- vbuxx=vbum1 
    ldx heap_index
    // [213] call bram_heap_get_data_packed
    // [182] phi from bram_heap_can_coalesce_left to bram_heap_get_data_packed [phi:bram_heap_can_coalesce_left->bram_heap_get_data_packed]
    // [182] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#3 [phi:bram_heap_can_coalesce_left->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [214] bram_heap_get_data_packed::return#14 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_4
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_4+1
    // bram_heap_can_coalesce_left::@3
    // [215] bram_heap_can_coalesce_left::heap_offset#0 = bram_heap_get_data_packed::return#14 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_4
    sta heap_offset
    lda bram_heap_get_data_packed.return_4+1
    sta heap_offset+1
    // bram_heap_can_coalesce_left::bram_heap_get_left1
    // return bram_heap_index.left[index];
    // [216] bram_heap_can_coalesce_left::bram_heap_get_left1_return#0 = ((char *)&bram_heap_index+$700)[bram_heap_can_coalesce_left::heap_index#0] -- vbuyy=pbuc1_derefidx_vbum1 
    ldx heap_index
    ldy bram_heap_index+$700,x
    // bram_heap_can_coalesce_left::@2
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [217] bram_heap_get_data_packed::index#4 = bram_heap_can_coalesce_left::bram_heap_get_left1_return#0 -- vbuxx=vbuyy 
    tya
    tax
    // [218] call bram_heap_get_data_packed
    // [182] phi from bram_heap_can_coalesce_left::@2 to bram_heap_get_data_packed [phi:bram_heap_can_coalesce_left::@2->bram_heap_get_data_packed]
    // [182] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#4 [phi:bram_heap_can_coalesce_left::@2->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [219] bram_heap_get_data_packed::return#15 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_5
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_5+1
    // bram_heap_can_coalesce_left::@4
    // [220] bram_heap_can_coalesce_left::left_offset#0 = bram_heap_get_data_packed::return#15 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_5
    sta left_offset
    lda bram_heap_get_data_packed.return_5+1
    sta left_offset+1
    // bool left_free = bram_heap_is_free(s, left_index)
    // [221] bram_heap_is_free::index#0 = bram_heap_can_coalesce_left::bram_heap_get_left1_return#0 -- vbuxx=vbuyy 
    tya
    tax
    // [222] call bram_heap_is_free
    // [395] phi from bram_heap_can_coalesce_left::@4 to bram_heap_is_free [phi:bram_heap_can_coalesce_left::@4->bram_heap_is_free]
    // [395] phi bram_heap_is_free::index#2 = bram_heap_is_free::index#0 [phi:bram_heap_can_coalesce_left::@4->bram_heap_is_free#0] -- call_phi_near 
    jsr bram_heap_is_free
    // bool left_free = bram_heap_is_free(s, left_index)
    // [223] bram_heap_is_free::return#2 = bram_heap_is_free::return#0
    // bram_heap_can_coalesce_left::@5
    // [224] bram_heap_can_coalesce_left::left_free#0 = bram_heap_is_free::return#2
    // if(left_free && (left_offset < heap_offset))
    // [225] if(bram_heap_can_coalesce_left::left_free#0) goto bram_heap_can_coalesce_left::@6 -- vboaa_then_la1 
    cmp #0
    bne __b6
    // [228] phi from bram_heap_can_coalesce_left::@5 bram_heap_can_coalesce_left::@6 to bram_heap_can_coalesce_left::@return [phi:bram_heap_can_coalesce_left::@5/bram_heap_can_coalesce_left::@6->bram_heap_can_coalesce_left::@return]
  __b2:
    // [228] phi bram_heap_can_coalesce_left::return#3 = $ff [phi:bram_heap_can_coalesce_left::@5/bram_heap_can_coalesce_left::@6->bram_heap_can_coalesce_left::@return#0] -- vbuyy=vbuc1 
    ldy #$ff
    rts
    // bram_heap_can_coalesce_left::@6
  __b6:
    // if(left_free && (left_offset < heap_offset))
    // [226] if(bram_heap_can_coalesce_left::left_offset#0<bram_heap_can_coalesce_left::heap_offset#0) goto bram_heap_can_coalesce_left::@1 -- vwum1_lt_vwum2_then_la1 
    lda left_offset+1
    cmp heap_offset+1
    bcc __b1
    bne !+
    lda left_offset
    cmp heap_offset
    bcc __b1
  !:
    jmp __b2
    // [227] phi from bram_heap_can_coalesce_left::@6 to bram_heap_can_coalesce_left::@1 [phi:bram_heap_can_coalesce_left::@6->bram_heap_can_coalesce_left::@1]
    // bram_heap_can_coalesce_left::@1
  __b1:
    // [228] phi from bram_heap_can_coalesce_left::@1 to bram_heap_can_coalesce_left::@return [phi:bram_heap_can_coalesce_left::@1->bram_heap_can_coalesce_left::@return]
    // [228] phi bram_heap_can_coalesce_left::return#3 = bram_heap_can_coalesce_left::bram_heap_get_left1_return#0 [phi:bram_heap_can_coalesce_left::@1->bram_heap_can_coalesce_left::@return#0] -- register_copy 
    // bram_heap_can_coalesce_left::@return
    // }
    // [229] return 
    rts
  .segment Data
    heap_index: .byte 0
  .segment DataBramHeap
    heap_offset: .word 0
    left_offset: .word 0
}
.segment CodeBramHeap
  // bram_heap_coalesce
/**
 * Coalesces two adjacent blocks to the left.
 * The left is a free index and the right is the heap index to be freed.
 * The free index remains free, and the heap to the right stays heap.
 * The free index is returned as the new remaining (free) block.
 */
// __register(A) char bram_heap_coalesce(__mem() char s, __mem() char left_index, __mem() char right_index)
bram_heap_coalesce: {
    .const bram_heap_set_left3_left = $ff
    .const bram_heap_set_right3_right = $ff
    // bram_heap_size_packed_t right_size = bram_heap_get_size_packed(s, right_index)
    // [231] bram_heap_get_size_packed::index#6 = bram_heap_coalesce::right_index#10 -- vbuxx=vbum1 
    ldx right_index
    // [232] call bram_heap_get_size_packed
    // [178] phi from bram_heap_coalesce to bram_heap_get_size_packed [phi:bram_heap_coalesce->bram_heap_get_size_packed]
    // [178] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#6 [phi:bram_heap_coalesce->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t right_size = bram_heap_get_size_packed(s, right_index)
    // [233] bram_heap_get_size_packed::return#16 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return_6
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return_6+1
    // bram_heap_coalesce::@3
    // [234] bram_heap_coalesce::right_size#0 = bram_heap_get_size_packed::return#16 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_6
    sta right_size
    lda bram_heap_get_size_packed.return_6+1
    sta right_size+1
    // bram_heap_size_packed_t left_size = bram_heap_get_size_packed(s, left_index)
    // [235] bram_heap_get_size_packed::index#7 = bram_heap_coalesce::left_index#10 -- vbuxx=vbum1 
    ldx left_index
    // [236] call bram_heap_get_size_packed
    // [178] phi from bram_heap_coalesce::@3 to bram_heap_get_size_packed [phi:bram_heap_coalesce::@3->bram_heap_get_size_packed]
    // [178] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#7 [phi:bram_heap_coalesce::@3->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t left_size = bram_heap_get_size_packed(s, left_index)
    // [237] bram_heap_get_size_packed::return#17 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return_7
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return_7+1
    // bram_heap_coalesce::@4
    // [238] bram_heap_coalesce::left_size#0 = bram_heap_get_size_packed::return#17 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_7
    sta left_size
    lda bram_heap_get_size_packed.return_7+1
    sta left_size+1
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [239] bram_heap_get_data_packed::index#7 = bram_heap_coalesce::left_index#10 -- vbuxx=vbum1 
    ldx left_index
    // [240] call bram_heap_get_data_packed
    // [182] phi from bram_heap_coalesce::@4 to bram_heap_get_data_packed [phi:bram_heap_coalesce::@4->bram_heap_get_data_packed]
    // [182] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#7 [phi:bram_heap_coalesce::@4->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [241] bram_heap_get_data_packed::return#18 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_8
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_8+1
    // bram_heap_coalesce::@5
    // [242] bram_heap_coalesce::left_offset#0 = bram_heap_get_data_packed::return#18 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_8
    sta left_offset
    lda bram_heap_get_data_packed.return_8+1
    sta left_offset+1
    // bram_heap_coalesce::bram_heap_get_left1
    // return bram_heap_index.left[index];
    // [243] bram_heap_coalesce::free_left#0 = ((char *)&bram_heap_index+$700)[bram_heap_coalesce::left_index#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy left_index
    lda bram_heap_index+$700,y
    sta free_left
    // bram_heap_coalesce::bram_heap_get_right1
    // return bram_heap_index.right[index];
    // [244] bram_heap_coalesce::free_right#0 = ((char *)&bram_heap_index+$600)[bram_heap_coalesce::right_index#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy right_index
    lda bram_heap_index+$600,y
    sta free_right
    // bram_heap_coalesce::@1
    // bram_heap_free_remove(s, left_index)
    // [245] bram_heap_free_remove::s#1 = bram_heap_coalesce::s#10 -- vbum1=vbum2 
    lda s
    sta bram_heap_free_remove.s
    // [246] bram_heap_free_remove::free_index#1 = bram_heap_coalesce::left_index#10 -- vbum1=vbum2 
    lda left_index
    sta bram_heap_free_remove.free_index
    // [247] call bram_heap_free_remove
  // We detach the left index from the free list and add it to the idle list.
    // [399] phi from bram_heap_coalesce::@1 to bram_heap_free_remove [phi:bram_heap_coalesce::@1->bram_heap_free_remove]
    // [399] phi bram_heap_free_remove::free_index#2 = bram_heap_free_remove::free_index#1 [phi:bram_heap_coalesce::@1->bram_heap_free_remove#0] -- register_copy 
    // [399] phi bram_heap_free_remove::s#2 = bram_heap_free_remove::s#1 [phi:bram_heap_coalesce::@1->bram_heap_free_remove#1] -- call_phi_near 
    jsr bram_heap_free_remove
    // bram_heap_coalesce::@6
    // bram_heap_idle_insert(s, left_index)
    // [248] bram_heap_idle_insert::s#0 = bram_heap_coalesce::s#10 -- vbum1=vbum2 
    lda s
    sta bram_heap_idle_insert.s
    // [249] bram_heap_idle_insert::idle_index#0 = bram_heap_coalesce::left_index#10 -- vbum1=vbum2 
    lda left_index
    sta bram_heap_idle_insert.idle_index
    // [250] call bram_heap_idle_insert -- call_phi_near 
    jsr bram_heap_idle_insert
    // bram_heap_coalesce::bram_heap_set_left1
    // bram_heap_index.left[index] = left
    // [251] ((char *)&bram_heap_index+$700)[bram_heap_coalesce::right_index#10] = bram_heap_coalesce::free_left#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_left
    ldy right_index
    sta bram_heap_index+$700,y
    // bram_heap_coalesce::bram_heap_set_right1
    // bram_heap_index.right[index] = right
    // [252] ((char *)&bram_heap_index+$600)[bram_heap_coalesce::right_index#10] = bram_heap_coalesce::free_right#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_right
    sta bram_heap_index+$600,y
    // bram_heap_coalesce::bram_heap_set_left2
    // bram_heap_index.left[index] = left
    // [253] ((char *)&bram_heap_index+$700)[bram_heap_coalesce::free_right#0] = bram_heap_coalesce::right_index#10 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy free_right
    sta bram_heap_index+$700,y
    // bram_heap_coalesce::bram_heap_set_right2
    // bram_heap_index.right[index] = right
    // [254] ((char *)&bram_heap_index+$600)[bram_heap_coalesce::free_left#0] = bram_heap_coalesce::right_index#10 -- pbuc1_derefidx_vbum1=vbum2 
    ldy free_left
    sta bram_heap_index+$600,y
    // bram_heap_coalesce::bram_heap_set_left3
    // bram_heap_index.left[index] = left
    // [255] ((char *)&bram_heap_index+$700)[bram_heap_coalesce::left_index#10] = bram_heap_coalesce::bram_heap_set_left3_left#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #bram_heap_set_left3_left
    ldy left_index
    sta bram_heap_index+$700,y
    // bram_heap_coalesce::bram_heap_set_right3
    // bram_heap_index.right[index] = right
    // [256] ((char *)&bram_heap_index+$600)[bram_heap_coalesce::left_index#10] = bram_heap_coalesce::bram_heap_set_right3_right#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #bram_heap_set_right3_right
    sta bram_heap_index+$600,y
    // bram_heap_coalesce::@2
    // bram_heap_set_size_packed(s, right_index, left_size + right_size)
    // [257] bram_heap_set_size_packed::size_packed#5 = bram_heap_coalesce::left_size#0 + bram_heap_coalesce::right_size#0 -- vwum1=vwum2_plus_vwum3 
    lda left_size
    clc
    adc right_size
    sta bram_heap_set_size_packed.size_packed
    lda left_size+1
    adc right_size+1
    sta bram_heap_set_size_packed.size_packed+1
    // [258] bram_heap_set_size_packed::index#5 = bram_heap_coalesce::right_index#10 -- vbuxx=vbum1 
    ldx right_index
    // [259] call bram_heap_set_size_packed
    // [368] phi from bram_heap_coalesce::@2 to bram_heap_set_size_packed [phi:bram_heap_coalesce::@2->bram_heap_set_size_packed]
    // [368] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#5 [phi:bram_heap_coalesce::@2->bram_heap_set_size_packed#0] -- register_copy 
    // [368] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#5 [phi:bram_heap_coalesce::@2->bram_heap_set_size_packed#1] -- call_phi_near 
    jsr bram_heap_set_size_packed
    // bram_heap_coalesce::@7
    // bram_heap_set_data_packed(s, right_index, left_offset)
    // [260] bram_heap_set_data_packed::index#6 = bram_heap_coalesce::right_index#10 -- vbuxx=vbum1 
    ldx right_index
    // [261] bram_heap_set_data_packed::data_packed#6 = bram_heap_coalesce::left_offset#0 -- vwum1=vwum2 
    lda left_offset
    sta bram_heap_set_data_packed.data_packed
    lda left_offset+1
    sta bram_heap_set_data_packed.data_packed+1
    // [262] call bram_heap_set_data_packed
    // [362] phi from bram_heap_coalesce::@7 to bram_heap_set_data_packed [phi:bram_heap_coalesce::@7->bram_heap_set_data_packed]
    // [362] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#6 [phi:bram_heap_coalesce::@7->bram_heap_set_data_packed#0] -- register_copy 
    // [362] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#6 [phi:bram_heap_coalesce::@7->bram_heap_set_data_packed#1] -- call_phi_near 
    jsr bram_heap_set_data_packed
    // bram_heap_coalesce::@8
    // bram_heap_set_free(s, left_index)
    // [263] bram_heap_set_free::index#3 = bram_heap_coalesce::left_index#10 -- vbuxx=vbum1 
    ldx left_index
    // [264] call bram_heap_set_free
    // [377] phi from bram_heap_coalesce::@8 to bram_heap_set_free [phi:bram_heap_coalesce::@8->bram_heap_set_free]
    // [377] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#3 [phi:bram_heap_coalesce::@8->bram_heap_set_free#0] -- call_phi_near 
    jsr bram_heap_set_free
    // bram_heap_coalesce::@9
    // bram_heap_set_free(s, right_index)
    // [265] bram_heap_set_free::index#4 = bram_heap_coalesce::right_index#10 -- vbuxx=vbum1 
    ldx right_index
    // [266] call bram_heap_set_free
    // [377] phi from bram_heap_coalesce::@9 to bram_heap_set_free [phi:bram_heap_coalesce::@9->bram_heap_set_free]
    // [377] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#4 [phi:bram_heap_coalesce::@9->bram_heap_set_free#0] -- call_phi_near 
    jsr bram_heap_set_free
    // bram_heap_coalesce::@return
    // }
    // [267] return 
    rts
  .segment Data
    s: .byte 0
    left_index: .byte 0
    right_index: .byte 0
  .segment DataBramHeap
    right_size: .word 0
    left_size: .word 0
    left_offset: .word 0
    free_left: .byte 0
    free_right: .byte 0
}
.segment CodeBramHeap
  // heap_can_coalesce_right
/**
 * Whether we should merge this header to the right.
 */
// __mem() char heap_can_coalesce_right(char s, __mem() char heap_index)
heap_can_coalesce_right: {
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [268] bram_heap_get_data_packed::index#5 = heap_can_coalesce_right::heap_index#0 -- vbuxx=vbum1 
    ldx heap_index
    // [269] call bram_heap_get_data_packed
    // [182] phi from heap_can_coalesce_right to bram_heap_get_data_packed [phi:heap_can_coalesce_right->bram_heap_get_data_packed]
    // [182] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#5 [phi:heap_can_coalesce_right->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [270] bram_heap_get_data_packed::return#16 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_6
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_6+1
    // heap_can_coalesce_right::@3
    // [271] heap_can_coalesce_right::heap_offset#0 = bram_heap_get_data_packed::return#16 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_6
    sta heap_offset
    lda bram_heap_get_data_packed.return_6+1
    sta heap_offset+1
    // heap_can_coalesce_right::bram_heap_get_right1
    // return bram_heap_index.right[index];
    // [272] heap_can_coalesce_right::bram_heap_get_right1_return#0 = ((char *)&bram_heap_index+$600)[heap_can_coalesce_right::heap_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy heap_index
    lda bram_heap_index+$600,y
    sta bram_heap_get_right1_return
    // heap_can_coalesce_right::@2
    // bram_heap_data_packed_t right_offset = bram_heap_get_data_packed(s, right_index)
    // [273] bram_heap_get_data_packed::index#6 = heap_can_coalesce_right::bram_heap_get_right1_return#0 -- vbuxx=vbum1 
    tax
    // [274] call bram_heap_get_data_packed
    // [182] phi from heap_can_coalesce_right::@2 to bram_heap_get_data_packed [phi:heap_can_coalesce_right::@2->bram_heap_get_data_packed]
    // [182] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#6 [phi:heap_can_coalesce_right::@2->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t right_offset = bram_heap_get_data_packed(s, right_index)
    // [275] bram_heap_get_data_packed::return#17 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_7
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_7+1
    // heap_can_coalesce_right::@4
    // [276] heap_can_coalesce_right::right_offset#0 = bram_heap_get_data_packed::return#17 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_7
    sta right_offset
    lda bram_heap_get_data_packed.return_7+1
    sta right_offset+1
    // bool right_free = bram_heap_is_free(s, right_index)
    // [277] bram_heap_is_free::index#1 = heap_can_coalesce_right::bram_heap_get_right1_return#0 -- vbuxx=vbum1 
    ldx bram_heap_get_right1_return
    // [278] call bram_heap_is_free
    // [395] phi from heap_can_coalesce_right::@4 to bram_heap_is_free [phi:heap_can_coalesce_right::@4->bram_heap_is_free]
    // [395] phi bram_heap_is_free::index#2 = bram_heap_is_free::index#1 [phi:heap_can_coalesce_right::@4->bram_heap_is_free#0] -- call_phi_near 
    jsr bram_heap_is_free
    // bool right_free = bram_heap_is_free(s, right_index)
    // [279] bram_heap_is_free::return#3 = bram_heap_is_free::return#0
    // heap_can_coalesce_right::@5
    // [280] heap_can_coalesce_right::right_free#0 = bram_heap_is_free::return#3
    // if(right_free && (heap_offset < right_offset))
    // [281] if(heap_can_coalesce_right::right_free#0) goto heap_can_coalesce_right::@6 -- vboaa_then_la1 
    cmp #0
    bne __b6
    // [284] phi from heap_can_coalesce_right::@5 heap_can_coalesce_right::@6 to heap_can_coalesce_right::@return [phi:heap_can_coalesce_right::@5/heap_can_coalesce_right::@6->heap_can_coalesce_right::@return]
  __b2:
    // [284] phi heap_can_coalesce_right::return#3 = $ff [phi:heap_can_coalesce_right::@5/heap_can_coalesce_right::@6->heap_can_coalesce_right::@return#0] -- vbum1=vbuc1 
    lda #$ff
    sta return
    rts
    // heap_can_coalesce_right::@6
  __b6:
    // if(right_free && (heap_offset < right_offset))
    // [282] if(heap_can_coalesce_right::heap_offset#0<heap_can_coalesce_right::right_offset#0) goto heap_can_coalesce_right::@1 -- vwum1_lt_vwum2_then_la1 
    lda heap_offset+1
    cmp right_offset+1
    bcc __b1
    bne !+
    lda heap_offset
    cmp right_offset
    bcc __b1
  !:
    jmp __b2
    // [283] phi from heap_can_coalesce_right::@6 to heap_can_coalesce_right::@1 [phi:heap_can_coalesce_right::@6->heap_can_coalesce_right::@1]
    // heap_can_coalesce_right::@1
  __b1:
    // [284] phi from heap_can_coalesce_right::@1 to heap_can_coalesce_right::@return [phi:heap_can_coalesce_right::@1->heap_can_coalesce_right::@return]
    // [284] phi heap_can_coalesce_right::return#3 = heap_can_coalesce_right::bram_heap_get_right1_return#0 [phi:heap_can_coalesce_right::@1->heap_can_coalesce_right::@return#0] -- register_copy 
    // heap_can_coalesce_right::@return
    // }
    // [285] return 
    rts
  .segment Data
    heap_index: .byte 0
  .segment DataBramHeap
    heap_offset: .word 0
    .label bram_heap_get_right1_return = return
    right_offset: .word 0
  .segment Data
    // A free_index is not found, we cannot coalesce.
    return: .byte 0
}
.segment CodeBramHeap
  // bram_heap_alloc_size_get
/**
 * Returns total allocation size, aligned to 8;
 */
/* inline */
// __mem() unsigned int bram_heap_alloc_size_get(__mem() unsigned long size)
bram_heap_alloc_size_get: {
    // bram_heap_size_pack(size-1)
    // [286] bram_heap_size_pack::size#0 = bram_heap_alloc_size_get::size#0 - 1 -- vdum1=vdum2_minus_1 
    sec
    lda size
    sbc #1
    sta bram_heap_size_pack.size
    lda size+1
    sbc #0
    sta bram_heap_size_pack.size+1
    lda size+2
    sbc #0
    sta bram_heap_size_pack.size+2
    lda size+3
    sbc #0
    sta bram_heap_size_pack.size+3
    // [287] call bram_heap_size_pack -- call_phi_near 
    jsr bram_heap_size_pack
    // [288] bram_heap_size_pack::return#2 = bram_heap_size_pack::return#0 -- vwum1=vwum2 
    lda bram_heap_size_pack.return
    sta bram_heap_size_pack.return_1
    lda bram_heap_size_pack.return+1
    sta bram_heap_size_pack.return_1+1
    // bram_heap_alloc_size_get::@1
    // [289] bram_heap_alloc_size_get::$1 = bram_heap_size_pack::return#2 -- vwum1=vwum2 
    lda bram_heap_size_pack.return_1
    sta bram_heap_alloc_size_get__1
    lda bram_heap_size_pack.return_1+1
    sta bram_heap_alloc_size_get__1+1
    // return (bram_heap_size_packed_t)((bram_heap_size_pack(size-1) + 1));
    // [290] bram_heap_alloc_size_get::return#1 = bram_heap_alloc_size_get::$1 + 1 -- vwum1=vwum2_plus_1 
    clc
    lda bram_heap_alloc_size_get__1
    adc #1
    sta return_1
    lda bram_heap_alloc_size_get__1+1
    adc #0
    sta return_1+1
    // bram_heap_alloc_size_get::@return
    // }
    // [291] return 
    rts
  .segment DataBramHeap
    bram_heap_alloc_size_get__1: .word 0
  .segment Data
    size: .dword 0
    return: .word 0
    return_1: .word 0
}
.segment CodeBramHeap
  // bram_heap_find_best_fit
/**
 * Best-fit algorithm.
 */
// __mem() char bram_heap_find_best_fit(__register(X) char s, __mem() unsigned int requested_size)
bram_heap_find_best_fit: {
    // bram_heap_index_t free_index = bram_heap_segment.free_list[s]
    // [292] bram_heap_find_best_fit::free_index#0 = ((char *)&bram_heap_segment+$2e)[bram_heap_find_best_fit::s#0] -- vbuyy=pbuc1_derefidx_vbuxx 
    ldy bram_heap_segment+$2e,x
    // if(free_index == BRAM_HEAP_NULL)
    // [293] if(bram_heap_find_best_fit::free_index#0!=$ff) goto bram_heap_find_best_fit::@1 -- vbuyy_neq_vbuc1_then_la1 
    cpy #$ff
    bne __b1
    // [294] phi from bram_heap_find_best_fit bram_heap_find_best_fit::@2 to bram_heap_find_best_fit::@return [phi:bram_heap_find_best_fit/bram_heap_find_best_fit::@2->bram_heap_find_best_fit::@return]
  __b5:
    // [294] phi bram_heap_find_best_fit::return#2 = $ff [phi:bram_heap_find_best_fit/bram_heap_find_best_fit::@2->bram_heap_find_best_fit::@return#0] -- vbum1=vbuc1 
    lda #$ff
    sta return
    // bram_heap_find_best_fit::@return
    // }
    // [295] return 
    rts
    // bram_heap_find_best_fit::@1
  __b1:
    // bram_heap_index_t free_end = bram_heap_segment.free_list[s]
    // [296] bram_heap_find_best_fit::free_end#0 = ((char *)&bram_heap_segment+$2e)[bram_heap_find_best_fit::s#0] -- vbum1=pbuc1_derefidx_vbuxx 
    lda bram_heap_segment+$2e,x
    sta free_end
    // [297] phi from bram_heap_find_best_fit::@1 to bram_heap_find_best_fit::@3 [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@3]
    // [297] phi bram_heap_find_best_fit::best_index#8 = $ff [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@3#0] -- vbum1=vbuc1 
    lda #$ff
    sta best_index
    // [297] phi bram_heap_find_best_fit::best_size#2 = $ffff [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@3#1] -- vwum1=vwuc1 
    lda #<$ffff
    sta best_size
    lda #>$ffff
    sta best_size+1
    // [297] phi bram_heap_find_best_fit::free_index#2 = bram_heap_find_best_fit::free_index#0 [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@3#2] -- register_copy 
    // bram_heap_find_best_fit::@3
  __b3:
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [298] bram_heap_get_size_packed::index#5 = bram_heap_find_best_fit::free_index#2 -- vbuxx=vbuyy 
    tya
    tax
    // [299] call bram_heap_get_size_packed
  // O(n) search.
    // [178] phi from bram_heap_find_best_fit::@3 to bram_heap_get_size_packed [phi:bram_heap_find_best_fit::@3->bram_heap_get_size_packed]
    // [178] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#5 [phi:bram_heap_find_best_fit::@3->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [300] bram_heap_get_size_packed::return#15 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return_5
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return_5+1
    // bram_heap_find_best_fit::@8
    // [301] bram_heap_find_best_fit::free_size#0 = bram_heap_get_size_packed::return#15 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_5
    sta free_size
    lda bram_heap_get_size_packed.return_5+1
    sta free_size+1
    // if(free_size >= requested_size && free_size < best_size)
    // [302] if(bram_heap_find_best_fit::free_size#0<bram_heap_find_best_fit::requested_size#0) goto bram_heap_find_best_fit::@11 -- vwum1_lt_vwum2_then_la1 
    cmp requested_size+1
    bcc __b11
    bne !+
    lda free_size
    cmp requested_size
    bcc __b11
  !:
    // bram_heap_find_best_fit::@9
    // [303] if(bram_heap_find_best_fit::free_size#0>=bram_heap_find_best_fit::best_size#2) goto bram_heap_find_best_fit::@4 -- vwum1_ge_vwum2_then_la1 
    lda best_size+1
    cmp free_size+1
    bne !+
    lda best_size
    cmp free_size
    beq __b4
  !:
    bcc __b4
    // bram_heap_find_best_fit::@5
    // [304] bram_heap_find_best_fit::best_index#12 = bram_heap_find_best_fit::free_index#2 -- vbum1=vbuyy 
    sty best_index
    // [305] phi from bram_heap_find_best_fit::@11 bram_heap_find_best_fit::@5 to bram_heap_find_best_fit::@4 [phi:bram_heap_find_best_fit::@11/bram_heap_find_best_fit::@5->bram_heap_find_best_fit::@4]
    // [305] phi bram_heap_find_best_fit::best_index#2 = bram_heap_find_best_fit::best_index#8 [phi:bram_heap_find_best_fit::@11/bram_heap_find_best_fit::@5->bram_heap_find_best_fit::@4#0] -- register_copy 
    // [305] phi bram_heap_find_best_fit::best_size#3 = bram_heap_find_best_fit::best_size#10 [phi:bram_heap_find_best_fit::@11/bram_heap_find_best_fit::@5->bram_heap_find_best_fit::@4#1] -- register_copy 
    // [305] phi from bram_heap_find_best_fit::@9 to bram_heap_find_best_fit::@4 [phi:bram_heap_find_best_fit::@9->bram_heap_find_best_fit::@4]
    // bram_heap_find_best_fit::@4
  __b4:
    // bram_heap_find_best_fit::bram_heap_get_next1
    // return bram_heap_index.next[index];
    // [306] bram_heap_find_best_fit::bram_heap_get_next1_return#0 = ((char *)&bram_heap_index+$400)[bram_heap_find_best_fit::free_index#2] -- vbuyy=pbuc1_derefidx_vbuyy 
    lda bram_heap_index+$400,y
    tay
    // bram_heap_find_best_fit::@7
    // while(free_index != free_end)
    // [307] if(bram_heap_find_best_fit::bram_heap_get_next1_return#0!=bram_heap_find_best_fit::free_end#0) goto bram_heap_find_best_fit::@10 -- vbuyy_neq_vbum1_then_la1 
    cpy free_end
    bne __b10
    // bram_heap_find_best_fit::@6
    // if(requested_size <= best_size)
    // [308] if(bram_heap_find_best_fit::requested_size#0>bram_heap_find_best_fit::best_size#3) goto bram_heap_find_best_fit::@2 -- vwum1_gt_vwum2_then_la1 
    lda best_size_1+1
    cmp requested_size+1
    bcc __b5
    bne !+
    lda best_size_1
    cmp requested_size
    bcc __b5
  !:
    // [294] phi from bram_heap_find_best_fit::@6 to bram_heap_find_best_fit::@return [phi:bram_heap_find_best_fit::@6->bram_heap_find_best_fit::@return]
    // [294] phi bram_heap_find_best_fit::return#2 = bram_heap_find_best_fit::best_index#2 [phi:bram_heap_find_best_fit::@6->bram_heap_find_best_fit::@return#0] -- register_copy 
    rts
    // [309] phi from bram_heap_find_best_fit::@6 to bram_heap_find_best_fit::@2 [phi:bram_heap_find_best_fit::@6->bram_heap_find_best_fit::@2]
    // bram_heap_find_best_fit::@2
    // bram_heap_find_best_fit::@10
  __b10:
    // [310] bram_heap_find_best_fit::best_size#9 = bram_heap_find_best_fit::best_size#3 -- vwum1=vwum2 
    lda best_size_1
    sta best_size
    lda best_size_1+1
    sta best_size+1
    // [297] phi from bram_heap_find_best_fit::@10 to bram_heap_find_best_fit::@3 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@3]
    // [297] phi bram_heap_find_best_fit::best_index#8 = bram_heap_find_best_fit::best_index#2 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@3#0] -- register_copy 
    // [297] phi bram_heap_find_best_fit::best_size#2 = bram_heap_find_best_fit::best_size#9 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@3#1] -- register_copy 
    // [297] phi bram_heap_find_best_fit::free_index#2 = bram_heap_find_best_fit::bram_heap_get_next1_return#0 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@3#2] -- register_copy 
    jmp __b3
    // bram_heap_find_best_fit::@11
  __b11:
    // [311] bram_heap_find_best_fit::best_size#10 = bram_heap_find_best_fit::best_size#2 -- vwum1=vwum2 
    lda best_size
    sta best_size_1
    lda best_size+1
    sta best_size_1+1
    jmp __b4
  .segment Data
    requested_size: .word 0
  .segment DataBramHeap
    free_end: .byte 0
  .segment Data
    .label return = best_index
  .segment DataBramHeap
    .label free_size = best_size_1
    best_size: .word 0
    best_size_1: .word 0
    best_index: .byte 0
}
.segment CodeBramHeap
  // bram_heap_allocate
/**
 * Allocates a header from the list, splitting if needed.
 */
// __register(A) char bram_heap_allocate(__mem() char s, __mem() char free_index, __mem() unsigned int required_size)
bram_heap_allocate: {
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [312] bram_heap_get_size_packed::index#4 = bram_heap_allocate::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [313] call bram_heap_get_size_packed
    // [178] phi from bram_heap_allocate to bram_heap_get_size_packed [phi:bram_heap_allocate->bram_heap_get_size_packed]
    // [178] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#4 [phi:bram_heap_allocate->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [314] bram_heap_get_size_packed::return#14 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return_4
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return_4+1
    // bram_heap_allocate::@4
    // [315] bram_heap_allocate::free_size#0 = bram_heap_get_size_packed::return#14 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_4
    sta free_size
    lda bram_heap_get_size_packed.return_4+1
    sta free_size+1
    // if(free_size > required_size)
    // [316] if(bram_heap_allocate::free_size#0>bram_heap_allocate::required_size#0) goto bram_heap_allocate::@1 -- vwum1_gt_vwum2_then_la1 
    lda required_size+1
    cmp free_size+1
    bcc __b1
    bne !+
    lda required_size
    cmp free_size
    bcc __b1
  !:
    // bram_heap_allocate::@2
    // if(free_size == required_size)
    // [317] if(bram_heap_allocate::free_size#0==bram_heap_allocate::required_size#0) goto bram_heap_allocate::@3 -- vwum1_eq_vwum2_then_la1 
    lda free_size
    cmp required_size
    bne !+
    lda free_size+1
    cmp required_size+1
    beq __b3
  !:
    // [318] phi from bram_heap_allocate::@2 to bram_heap_allocate::@return [phi:bram_heap_allocate::@2->bram_heap_allocate::@return]
    // [318] phi bram_heap_allocate::return#4 = $ff [phi:bram_heap_allocate::@2->bram_heap_allocate::@return#0] -- vbuaa=vbuc1 
    lda #$ff
    // bram_heap_allocate::@return
    // }
    // [319] return 
    rts
    // bram_heap_allocate::@3
  __b3:
    // bram_heap_replace_free_with_heap(s, free_index, required_size)
    // [320] bram_heap_replace_free_with_heap::s#0 = bram_heap_allocate::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_replace_free_with_heap.s
    // [321] bram_heap_replace_free_with_heap::return#2 = bram_heap_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_replace_free_with_heap.return
    // [322] bram_heap_replace_free_with_heap::required_size#0 = bram_heap_allocate::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta bram_heap_replace_free_with_heap.required_size
    lda required_size+1
    sta bram_heap_replace_free_with_heap.required_size+1
    // [323] call bram_heap_replace_free_with_heap -- call_phi_near 
    jsr bram_heap_replace_free_with_heap
    // bram_heap_allocate::@6
    // return bram_heap_replace_free_with_heap(s, free_index, required_size);
    // [324] bram_heap_allocate::return#2 = bram_heap_replace_free_with_heap::return#2 -- vbuaa=vbum1 
    lda bram_heap_replace_free_with_heap.return
    // [318] phi from bram_heap_allocate::@5 bram_heap_allocate::@6 to bram_heap_allocate::@return [phi:bram_heap_allocate::@5/bram_heap_allocate::@6->bram_heap_allocate::@return]
    // [318] phi bram_heap_allocate::return#4 = bram_heap_allocate::return#1 [phi:bram_heap_allocate::@5/bram_heap_allocate::@6->bram_heap_allocate::@return#0] -- register_copy 
    rts
    // bram_heap_allocate::@1
  __b1:
    // bram_heap_split_free_and_allocate(s, free_index, required_size)
    // [325] bram_heap_split_free_and_allocate::s#0 = bram_heap_allocate::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_split_free_and_allocate.s
    // [326] bram_heap_split_free_and_allocate::free_index#0 = bram_heap_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_split_free_and_allocate.free_index
    // [327] bram_heap_split_free_and_allocate::required_size#0 = bram_heap_allocate::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta bram_heap_split_free_and_allocate.required_size
    lda required_size+1
    sta bram_heap_split_free_and_allocate.required_size+1
    // [328] call bram_heap_split_free_and_allocate -- call_phi_near 
    jsr bram_heap_split_free_and_allocate
    // [329] bram_heap_split_free_and_allocate::return#2 = bram_heap_split_free_and_allocate::heap_index#0 -- vbuaa=vbum1 
    lda bram_heap_split_free_and_allocate.heap_index
    // bram_heap_allocate::@5
    // return bram_heap_split_free_and_allocate(s, free_index, required_size);
    // [330] bram_heap_allocate::return#1 = bram_heap_split_free_and_allocate::return#2
    rts
  .segment Data
    s: .byte 0
    free_index: .byte 0
    required_size: .word 0
  .segment DataBramHeap
    free_size: .word 0
}
.segment CodeBramHeap
  // bram_heap_data_pack
// __mem() unsigned int bram_heap_data_pack(__register(X) char bram_bank, __mem() char *bram_ptr)
bram_heap_data_pack: {
    // MAKEWORD(bram_bank, 0)
    // [332] bram_heap_data_pack::$0 = bram_heap_data_pack::bram_bank#2 w= 0 -- vwum1=vbuxx_word_vbuc1 
    lda #0
    stx bram_heap_data_pack__0+1
    sta bram_heap_data_pack__0
    // (unsigned int)bram_ptr & 0x1FFF
    // [333] bram_heap_data_pack::$1 = (unsigned int)bram_heap_data_pack::bram_ptr#2 & $1fff -- vwum1=vwum1_band_vwuc1 
    lda bram_heap_data_pack__1
    and #<$1fff
    sta bram_heap_data_pack__1
    lda bram_heap_data_pack__1+1
    and #>$1fff
    sta bram_heap_data_pack__1+1
    // ((unsigned int)bram_ptr & 0x1FFF ) >> 5
    // [334] bram_heap_data_pack::$2 = bram_heap_data_pack::$1 >> 5 -- vwum1=vwum1_ror_5 
    lsr bram_heap_data_pack__2+1
    ror bram_heap_data_pack__2
    lsr bram_heap_data_pack__2+1
    ror bram_heap_data_pack__2
    lsr bram_heap_data_pack__2+1
    ror bram_heap_data_pack__2
    lsr bram_heap_data_pack__2+1
    ror bram_heap_data_pack__2
    lsr bram_heap_data_pack__2+1
    ror bram_heap_data_pack__2
    // MAKEWORD(bram_bank, 0) | (((unsigned int)bram_ptr & 0x1FFF ) >> 5)
    // [335] bram_heap_data_pack::return#2 = bram_heap_data_pack::$0 | bram_heap_data_pack::$2 -- vwum1=vwum2_bor_vwum1 
    lda return
    ora bram_heap_data_pack__0
    sta return
    lda return+1
    ora bram_heap_data_pack__0+1
    sta return+1
    // bram_heap_data_pack::@return
    // }
    // [336] return 
    rts
  .segment DataBramHeap
    bram_heap_data_pack__0: .word 0
    .label bram_heap_data_pack__1 = bram_ptr
    .label bram_heap_data_pack__2 = bram_ptr
  .segment Data
    bram_ptr: .word 0
    .label return = bram_ptr
}
.segment CodeBramHeap
  // bram_heap_index_add
// __register(A) char bram_heap_index_add(__register(X) char s)
bram_heap_index_add: {
    // bram_heap_index_t index = bram_heap_segment.idle_list[s]
    // [338] bram_heap_index_add::index#0 = ((char *)&bram_heap_segment+$32)[bram_heap_index_add::s#2] -- vbum1=pbuc1_derefidx_vbuxx 
    // TODO: Search idle list.
    lda bram_heap_segment+$32,x
    sta index
    // if(index != BRAM_HEAP_NULL)
    // [339] if(bram_heap_index_add::index#0!=$ff) goto bram_heap_index_add::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp index
    bne __b1
    // bram_heap_index_add::@3
    // index = bram_heap_segment.index_position
    // [340] bram_heap_index_add::index#1 = *((char *)&bram_heap_segment+1) -- vbum1=_deref_pbuc1 
    // The current header gets the current heap position handle.
    lda bram_heap_segment+1
    sta index
    // bram_heap_segment.index_position += 1
    // [341] *((char *)&bram_heap_segment+1) = *((char *)&bram_heap_segment+1) + 1 -- _deref_pbuc1=_deref_pbuc1_plus_1 
    // We adjust to the next index position.
    inc bram_heap_segment+1
    // [342] phi from bram_heap_index_add::@1 bram_heap_index_add::@3 to bram_heap_index_add::@2 [phi:bram_heap_index_add::@1/bram_heap_index_add::@3->bram_heap_index_add::@2]
    // [342] phi bram_heap_index_add::return#1 = bram_heap_index_add::index#0 [phi:bram_heap_index_add::@1/bram_heap_index_add::@3->bram_heap_index_add::@2#0] -- register_copy 
    // bram_heap_index_add::@2
    // bram_heap_index_add::@return
    // }
    // [343] return 
    rts
    // bram_heap_index_add::@1
  __b1:
    // heap_idle_remove(s, index)
    // [344] heap_idle_remove::s#0 = bram_heap_index_add::s#2 -- vbum1=vbuxx 
    stx heap_idle_remove.s
    // [345] heap_idle_remove::idle_index#0 = bram_heap_index_add::index#0 -- vbum1=vbum2 
    lda index
    sta heap_idle_remove.idle_index
    // [346] call heap_idle_remove -- call_phi_near 
    jsr heap_idle_remove
    rts
  .segment DataBramHeap
    .label index = return
  .segment Data
    return: .byte 0
}
.segment CodeBramHeap
  // bram_heap_list_insert_at
/**
* Insert index in list at sorted position.
*/
// __register(A) char bram_heap_list_insert_at(char s, __register(X) char list, __mem() char index, __mem() char at)
bram_heap_list_insert_at: {
    // if(list == BRAM_HEAP_NULL)
    // [348] if(bram_heap_list_insert_at::list#5!=$ff) goto bram_heap_list_insert_at::@1 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$ff
    bne __b1
    // bram_heap_list_insert_at::bram_heap_set_prev1
    // bram_heap_index.prev[index] = prev
    // [349] ((char *)&bram_heap_index+$500)[bram_heap_list_insert_at::index#10] = bram_heap_list_insert_at::index#10 -- pbuc1_derefidx_vbum1=vbum1 
    ldy index
    tya
    sta bram_heap_index+$500,y
    // bram_heap_list_insert_at::bram_heap_set_next1
    // bram_heap_index.next[index] = next
    // [350] ((char *)&bram_heap_index+$400)[bram_heap_list_insert_at::index#10] = bram_heap_list_insert_at::index#10 -- pbuc1_derefidx_vbum1=vbum1 
    tya
    sta bram_heap_index+$400,y
    // [351] bram_heap_list_insert_at::list#28 = bram_heap_list_insert_at::index#10 -- vbuxx=vbum1 
    tax
    // [352] phi from bram_heap_list_insert_at bram_heap_list_insert_at::bram_heap_set_next1 to bram_heap_list_insert_at::@1 [phi:bram_heap_list_insert_at/bram_heap_list_insert_at::bram_heap_set_next1->bram_heap_list_insert_at::@1]
    // [352] phi bram_heap_list_insert_at::list#11 = bram_heap_list_insert_at::list#5 [phi:bram_heap_list_insert_at/bram_heap_list_insert_at::bram_heap_set_next1->bram_heap_list_insert_at::@1#0] -- register_copy 
    // bram_heap_list_insert_at::@1
  __b1:
    // if(at == BRAM_HEAP_NULL)
    // [353] if(bram_heap_list_insert_at::at#11!=$ff) goto bram_heap_list_insert_at::@2 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp at
    bne __b2
    // bram_heap_list_insert_at::@3
    // [354] bram_heap_list_insert_at::first#8 = bram_heap_list_insert_at::list#11 -- vbum1=vbuxx 
    stx first
    // [355] phi from bram_heap_list_insert_at::@1 bram_heap_list_insert_at::@3 to bram_heap_list_insert_at::@2 [phi:bram_heap_list_insert_at::@1/bram_heap_list_insert_at::@3->bram_heap_list_insert_at::@2]
    // [355] phi bram_heap_list_insert_at::first#0 = bram_heap_list_insert_at::at#11 [phi:bram_heap_list_insert_at::@1/bram_heap_list_insert_at::@3->bram_heap_list_insert_at::@2#0] -- register_copy 
    // bram_heap_list_insert_at::@2
  __b2:
    // bram_heap_list_insert_at::bram_heap_get_prev1
    // return bram_heap_index.prev[index];
    // [356] bram_heap_list_insert_at::bram_heap_get_prev1_return#0 = ((char *)&bram_heap_index+$500)[bram_heap_list_insert_at::first#0] -- vbuaa=pbuc1_derefidx_vbum1 
    ldy first
    lda bram_heap_index+$500,y
    // bram_heap_list_insert_at::bram_heap_set_prev2
    // bram_heap_index.prev[index] = prev
    // [357] ((char *)&bram_heap_index+$500)[bram_heap_list_insert_at::index#10] = bram_heap_list_insert_at::bram_heap_get_prev1_return#0 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy index
    sta bram_heap_index+$500,y
    // bram_heap_list_insert_at::bram_heap_set_next2
    // bram_heap_index.next[index] = next
    // [358] ((char *)&bram_heap_index+$400)[bram_heap_list_insert_at::bram_heap_get_prev1_return#0] = bram_heap_list_insert_at::index#10 -- pbuc1_derefidx_vbuaa=vbum1 
    tay
    lda index
    sta bram_heap_index+$400,y
    // bram_heap_list_insert_at::bram_heap_set_next3
    // [359] ((char *)&bram_heap_index+$400)[bram_heap_list_insert_at::index#10] = bram_heap_list_insert_at::first#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda first
    ldy index
    sta bram_heap_index+$400,y
    // bram_heap_list_insert_at::bram_heap_set_prev3
    // bram_heap_index.prev[index] = prev
    // [360] ((char *)&bram_heap_index+$500)[bram_heap_list_insert_at::first#0] = bram_heap_list_insert_at::index#10 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy first
    sta bram_heap_index+$500,y
    // bram_heap_list_insert_at::@return
    // }
    // [361] return 
    rts
  .segment Data
    index: .byte 0
    .label at = first
  .segment DataBramHeap
    first: .byte 0
}
.segment CodeBramHeap
  // bram_heap_set_data_packed
// void bram_heap_set_data_packed(char s, __register(X) char index, __mem() unsigned int data_packed)
bram_heap_set_data_packed: {
    // BYTE1(data_packed)
    // [363] bram_heap_set_data_packed::$0 = byte1  bram_heap_set_data_packed::data_packed#7 -- vbuaa=_byte1_vwum1 
    lda data_packed+1
    // bram_heap_index.data1[index] = BYTE1(data_packed)
    // [364] ((char *)&bram_heap_index+$100)[bram_heap_set_data_packed::index#7] = bram_heap_set_data_packed::$0 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta bram_heap_index+$100,x
    // BYTE0(data_packed)
    // [365] bram_heap_set_data_packed::$1 = byte0  bram_heap_set_data_packed::data_packed#7 -- vbuaa=_byte0_vwum1 
    lda data_packed
    // bram_heap_index.data0[index] = BYTE0(data_packed)
    // [366] ((char *)&bram_heap_index)[bram_heap_set_data_packed::index#7] = bram_heap_set_data_packed::$1 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta bram_heap_index,x
    // bram_heap_set_data_packed::@return
    // }
    // [367] return 
    rts
  .segment Data
    data_packed: .word 0
}
.segment CodeBramHeap
  // bram_heap_set_size_packed
// void bram_heap_set_size_packed(char s, __register(X) char index, __mem() unsigned int size_packed)
bram_heap_set_size_packed: {
    // bram_heap_index.size1[index] & 0x80
    // [369] bram_heap_set_size_packed::$0 = ((char *)&bram_heap_index+$300)[bram_heap_set_size_packed::index#6] & $80 -- vbuaa=pbuc1_derefidx_vbuxx_band_vbuc2 
    lda #$80
    and bram_heap_index+$300,x
    // bram_heap_index.size1[index] &= bram_heap_index.size1[index] & 0x80
    // [370] ((char *)&bram_heap_index+$300)[bram_heap_set_size_packed::index#6] = ((char *)&bram_heap_index+$300)[bram_heap_set_size_packed::index#6] & bram_heap_set_size_packed::$0 -- pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_band_vbuaa 
    and bram_heap_index+$300,x
    sta bram_heap_index+$300,x
    // BYTE1(size_packed)
    // [371] bram_heap_set_size_packed::$1 = byte1  bram_heap_set_size_packed::size_packed#6 -- vbuaa=_byte1_vwum1 
    lda size_packed+1
    // BYTE1(size_packed) & 0x7F
    // [372] bram_heap_set_size_packed::$2 = bram_heap_set_size_packed::$1 & $7f -- vbuaa=vbuaa_band_vbuc1 
    and #$7f
    // bram_heap_index.size1[index] = BYTE1(size_packed) & 0x7F
    // [373] ((char *)&bram_heap_index+$300)[bram_heap_set_size_packed::index#6] = bram_heap_set_size_packed::$2 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta bram_heap_index+$300,x
    // BYTE0(size_packed)
    // [374] bram_heap_set_size_packed::$3 = byte0  bram_heap_set_size_packed::size_packed#6 -- vbuaa=_byte0_vwum1 
    lda size_packed
    // bram_heap_index.size0[index] = BYTE0(size_packed)
    // [375] ((char *)&bram_heap_index+$200)[bram_heap_set_size_packed::index#6] = bram_heap_set_size_packed::$3 -- pbuc1_derefidx_vbuxx=vbuaa 
    // Ignore free flag.
    sta bram_heap_index+$200,x
    // bram_heap_set_size_packed::@return
    // }
    // [376] return 
    rts
  .segment Data
    size_packed: .word 0
}
.segment CodeBramHeap
  // bram_heap_set_free
// void bram_heap_set_free(char s, __register(X) char index)
bram_heap_set_free: {
    // bram_heap_index.size1[index] |= 0x80
    // [378] ((char *)&bram_heap_index+$300)[bram_heap_set_free::index#5] = ((char *)&bram_heap_index+$300)[bram_heap_set_free::index#5] | $80 -- pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_bor_vbuc2 
    lda #$80
    ora bram_heap_index+$300,x
    sta bram_heap_index+$300,x
    // bram_heap_set_free::@return
    // }
    // [379] return 
    rts
}
  // bram_heap_list_remove
/**
* Remove header from List
*/
// __register(A) char bram_heap_list_remove(char s, __register(X) char list, __mem() char index)
bram_heap_list_remove: {
    .const bram_heap_set_next2_next = $ff
    .const bram_heap_set_prev2_prev = $ff
    // if(list == BRAM_HEAP_NULL)
    // [381] if(bram_heap_list_remove::list#10!=$ff) goto bram_heap_list_remove::bram_heap_get_next1 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$ff
    bne bram_heap_get_next1
    // [382] phi from bram_heap_list_remove bram_heap_list_remove::bram_heap_set_prev2 to bram_heap_list_remove::@return [phi:bram_heap_list_remove/bram_heap_list_remove::bram_heap_set_prev2->bram_heap_list_remove::@return]
  __b2:
    // [382] phi bram_heap_list_remove::return#1 = $ff [phi:bram_heap_list_remove/bram_heap_list_remove::bram_heap_set_prev2->bram_heap_list_remove::@return#0] -- vbuxx=vbuc1 
    ldx #$ff
    // bram_heap_list_remove::@return
  __breturn:
    // }
    // [383] return 
    rts
    // bram_heap_list_remove::bram_heap_get_next1
  bram_heap_get_next1:
    // return bram_heap_index.next[index];
    // [384] bram_heap_list_remove::bram_heap_get_next1_return#0 = ((char *)&bram_heap_index+$400)[bram_heap_list_remove::list#10] -- vbuyy=pbuc1_derefidx_vbuxx 
    ldy bram_heap_index+$400,x
    // bram_heap_list_remove::@2
    // if(list == bram_heap_get_next(s, list))
    // [385] if(bram_heap_list_remove::list#10!=bram_heap_list_remove::bram_heap_get_next1_return#0) goto bram_heap_list_remove::bram_heap_get_next2 -- vbuxx_neq_vbuyy_then_la1 
    stx.z $ff
    cpy.z $ff
    bne bram_heap_get_next2
    // bram_heap_list_remove::bram_heap_set_next2
    // bram_heap_index.next[index] = next
    // [386] ((char *)&bram_heap_index+$400)[bram_heap_list_remove::index#10] = bram_heap_list_remove::bram_heap_set_next2_next#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #bram_heap_set_next2_next
    ldy index
    sta bram_heap_index+$400,y
    // bram_heap_list_remove::bram_heap_set_prev2
    // bram_heap_index.prev[index] = prev
    // [387] ((char *)&bram_heap_index+$500)[bram_heap_list_remove::index#10] = bram_heap_list_remove::bram_heap_set_prev2_prev#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #bram_heap_set_prev2_prev
    sta bram_heap_index+$500,y
    jmp __b2
    // bram_heap_list_remove::bram_heap_get_next2
  bram_heap_get_next2:
    // return bram_heap_index.next[index];
    // [388] bram_heap_list_remove::next#0 = ((char *)&bram_heap_index+$400)[bram_heap_list_remove::index#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy index
    lda bram_heap_index+$400,y
    sta next
    // bram_heap_list_remove::bram_heap_get_prev1
    // return bram_heap_index.prev[index];
    // [389] bram_heap_list_remove::bram_heap_get_prev1_return#0 = ((char *)&bram_heap_index+$500)[bram_heap_list_remove::index#10] -- vbum1=pbuc1_derefidx_vbum2 
    lda bram_heap_index+$500,y
    sta bram_heap_get_prev1_return
    // bram_heap_list_remove::bram_heap_set_next1
    // bram_heap_index.next[index] = next
    // [390] ((char *)&bram_heap_index+$400)[bram_heap_list_remove::bram_heap_get_prev1_return#0] = bram_heap_list_remove::next#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda next
    ldy bram_heap_get_prev1_return
    sta bram_heap_index+$400,y
    // bram_heap_list_remove::bram_heap_set_prev1
    // bram_heap_index.prev[index] = prev
    // [391] ((char *)&bram_heap_index+$500)[bram_heap_list_remove::next#0] = bram_heap_list_remove::bram_heap_get_prev1_return#0 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy next
    sta bram_heap_index+$500,y
    // bram_heap_list_remove::@3
    // if(index == list)
    // [392] if(bram_heap_list_remove::index#10!=bram_heap_list_remove::list#10) goto bram_heap_list_remove::@1 -- vbum1_neq_vbuxx_then_la1 
    cpx index
    bne __breturn
    // bram_heap_list_remove::bram_heap_get_next3
    // return bram_heap_index.next[index];
    // [393] bram_heap_list_remove::bram_heap_get_next3_return#0 = ((char *)&bram_heap_index+$400)[bram_heap_list_remove::list#10] -- vbuxx=pbuc1_derefidx_vbuxx 
    lda bram_heap_index+$400,x
    tax
    // [394] phi from bram_heap_list_remove::@3 bram_heap_list_remove::bram_heap_get_next3 to bram_heap_list_remove::@1 [phi:bram_heap_list_remove::@3/bram_heap_list_remove::bram_heap_get_next3->bram_heap_list_remove::@1]
    // [394] phi bram_heap_list_remove::return#3 = bram_heap_list_remove::list#10 [phi:bram_heap_list_remove::@3/bram_heap_list_remove::bram_heap_get_next3->bram_heap_list_remove::@1#0] -- register_copy 
    // bram_heap_list_remove::@1
    // [382] phi from bram_heap_list_remove::@1 to bram_heap_list_remove::@return [phi:bram_heap_list_remove::@1->bram_heap_list_remove::@return]
    // [382] phi bram_heap_list_remove::return#1 = bram_heap_list_remove::return#3 [phi:bram_heap_list_remove::@1->bram_heap_list_remove::@return#0] -- register_copy 
    rts
  .segment DataBramHeap
    next: .byte 0
    bram_heap_get_prev1_return: .byte 0
  .segment Data
    index: .byte 0
}
.segment CodeBramHeap
  // bram_heap_is_free
// __register(A) bool bram_heap_is_free(char s, __register(X) char index)
bram_heap_is_free: {
    // bram_heap_index.size1[index] & 0x80
    // [396] bram_heap_is_free::$0 = ((char *)&bram_heap_index+$300)[bram_heap_is_free::index#2] & $80 -- vbuaa=pbuc1_derefidx_vbuxx_band_vbuc2 
    lda #$80
    and bram_heap_index+$300,x
    // (bram_heap_index.size1[index] & 0x80) == 0x80
    // [397] bram_heap_is_free::return#0 = bram_heap_is_free::$0 == $80 -- vboaa=vbuaa_eq_vbuc1 
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // bram_heap_is_free::@return
    // }
    // [398] return 
    rts
}
  // bram_heap_free_remove
// void bram_heap_free_remove(__mem() char s, __mem() char free_index)
bram_heap_free_remove: {
    // bram_heap_segment.freeCount[s]--;
    // [400] bram_heap_free_remove::$4 = bram_heap_free_remove::s#2 << 1 -- vbuaa=vbum1_rol_1 
    lda s
    asl
    // [401] ((unsigned int *)&bram_heap_segment+$46)[bram_heap_free_remove::$4] = -- ((unsigned int *)&bram_heap_segment+$46)[bram_heap_free_remove::$4] -- pwuc1_derefidx_vbuaa=_dec_pwuc1_derefidx_vbuaa 
    tax
    lda bram_heap_segment+$46,x
    bne !+
    dec bram_heap_segment+$46+1,x
  !:
    dec bram_heap_segment+$46,x
    // bram_heap_list_remove(s, bram_heap_segment.free_list[s], free_index)
    // [402] bram_heap_list_remove::list#3 = ((char *)&bram_heap_segment+$2e)[bram_heap_free_remove::s#2] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$2e,y
    // [403] bram_heap_list_remove::index#1 = bram_heap_free_remove::free_index#2 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_list_remove.index
    // [404] call bram_heap_list_remove
    // [380] phi from bram_heap_free_remove to bram_heap_list_remove [phi:bram_heap_free_remove->bram_heap_list_remove]
    // [380] phi bram_heap_list_remove::index#10 = bram_heap_list_remove::index#1 [phi:bram_heap_free_remove->bram_heap_list_remove#0] -- register_copy 
    // [380] phi bram_heap_list_remove::list#10 = bram_heap_list_remove::list#3 [phi:bram_heap_free_remove->bram_heap_list_remove#1] -- call_phi_near 
    jsr bram_heap_list_remove
    // bram_heap_list_remove(s, bram_heap_segment.free_list[s], free_index)
    // [405] bram_heap_list_remove::return#5 = bram_heap_list_remove::return#1 -- vbuaa=vbuxx 
    txa
    // bram_heap_free_remove::@1
    // [406] bram_heap_free_remove::$1 = bram_heap_list_remove::return#5
    // bram_heap_segment.free_list[s] = bram_heap_list_remove(s, bram_heap_segment.free_list[s], free_index)
    // [407] ((char *)&bram_heap_segment+$2e)[bram_heap_free_remove::s#2] = bram_heap_free_remove::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy s
    sta bram_heap_segment+$2e,y
    // bram_heap_clear_free(s, free_index)
    // [408] bram_heap_clear_free::index#0 = bram_heap_free_remove::free_index#2 -- vbuxx=vbum1 
    ldx free_index
    // [409] call bram_heap_clear_free
    // [493] phi from bram_heap_free_remove::@1 to bram_heap_clear_free [phi:bram_heap_free_remove::@1->bram_heap_clear_free]
    // [493] phi bram_heap_clear_free::index#2 = bram_heap_clear_free::index#0 [phi:bram_heap_free_remove::@1->bram_heap_clear_free#0] -- call_phi_near 
    jsr bram_heap_clear_free
    // bram_heap_free_remove::@return
    // }
    // [410] return 
    rts
  .segment Data
    s: .byte 0
    free_index: .byte 0
}
.segment CodeBramHeap
  // bram_heap_idle_insert
// char bram_heap_idle_insert(__mem() char s, __mem() char idle_index)
bram_heap_idle_insert: {
    // bram_heap_list_insert_at(s, bram_heap_segment.idle_list[s], idle_index, bram_heap_segment.idle_list[s])
    // [411] bram_heap_list_insert_at::list#4 = ((char *)&bram_heap_segment+$32)[bram_heap_idle_insert::s#0] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$32,y
    // [412] bram_heap_list_insert_at::index#3 = bram_heap_idle_insert::idle_index#0 -- vbum1=vbum2 
    lda idle_index
    sta bram_heap_list_insert_at.index
    // [413] bram_heap_list_insert_at::at#4 = ((char *)&bram_heap_segment+$32)[bram_heap_idle_insert::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda bram_heap_segment+$32,y
    sta bram_heap_list_insert_at.at
    // [414] call bram_heap_list_insert_at
    // [347] phi from bram_heap_idle_insert to bram_heap_list_insert_at [phi:bram_heap_idle_insert->bram_heap_list_insert_at]
    // [347] phi bram_heap_list_insert_at::index#10 = bram_heap_list_insert_at::index#3 [phi:bram_heap_idle_insert->bram_heap_list_insert_at#0] -- register_copy 
    // [347] phi bram_heap_list_insert_at::at#11 = bram_heap_list_insert_at::at#4 [phi:bram_heap_idle_insert->bram_heap_list_insert_at#1] -- register_copy 
    // [347] phi bram_heap_list_insert_at::list#5 = bram_heap_list_insert_at::list#4 [phi:bram_heap_idle_insert->bram_heap_list_insert_at#2] -- call_phi_near 
    jsr bram_heap_list_insert_at
    // bram_heap_list_insert_at(s, bram_heap_segment.idle_list[s], idle_index, bram_heap_segment.idle_list[s])
    // [415] bram_heap_list_insert_at::return#10 = bram_heap_list_insert_at::list#11 -- vbuaa=vbuxx 
    txa
    // bram_heap_idle_insert::@1
    // [416] bram_heap_idle_insert::$0 = bram_heap_list_insert_at::return#10
    // bram_heap_segment.idle_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.idle_list[s], idle_index, bram_heap_segment.idle_list[s])
    // [417] ((char *)&bram_heap_segment+$32)[bram_heap_idle_insert::s#0] = bram_heap_idle_insert::$0 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy s
    sta bram_heap_segment+$32,y
    // bram_heap_set_data_packed(s, idle_index, 0)
    // [418] bram_heap_set_data_packed::index#2 = bram_heap_idle_insert::idle_index#0 -- vbuxx=vbum1 
    ldx idle_index
    // [419] call bram_heap_set_data_packed
    // [362] phi from bram_heap_idle_insert::@1 to bram_heap_set_data_packed [phi:bram_heap_idle_insert::@1->bram_heap_set_data_packed]
    // [362] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#2 [phi:bram_heap_idle_insert::@1->bram_heap_set_data_packed#0] -- register_copy 
    // [362] phi bram_heap_set_data_packed::data_packed#7 = 0 [phi:bram_heap_idle_insert::@1->bram_heap_set_data_packed#1] -- call_phi_near 
    lda #<0
    sta bram_heap_set_data_packed.data_packed
    sta bram_heap_set_data_packed.data_packed+1
    jsr bram_heap_set_data_packed
    // bram_heap_idle_insert::@2
    // bram_heap_set_size_packed(s, idle_index, 0)
    // [420] bram_heap_set_size_packed::index#3 = bram_heap_idle_insert::idle_index#0 -- vbuxx=vbum1 
    ldx idle_index
    // [421] call bram_heap_set_size_packed
    // [368] phi from bram_heap_idle_insert::@2 to bram_heap_set_size_packed [phi:bram_heap_idle_insert::@2->bram_heap_set_size_packed]
    // [368] phi bram_heap_set_size_packed::size_packed#6 = 0 [phi:bram_heap_idle_insert::@2->bram_heap_set_size_packed#0] -- vwum1=vbuc1 
    lda #<0
    sta bram_heap_set_size_packed.size_packed
    sta bram_heap_set_size_packed.size_packed+1
    // [368] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#3 [phi:bram_heap_idle_insert::@2->bram_heap_set_size_packed#1] -- call_phi_near 
    jsr bram_heap_set_size_packed
    // bram_heap_idle_insert::@3
    // bram_heap_segment.idleCount[s]++;
    // [422] bram_heap_idle_insert::$5 = bram_heap_idle_insert::s#0 << 1 -- vbuaa=vbum1_rol_1 
    lda s
    asl
    // [423] ((unsigned int *)&bram_heap_segment+$4e)[bram_heap_idle_insert::$5] = ++ ((unsigned int *)&bram_heap_segment+$4e)[bram_heap_idle_insert::$5] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc bram_heap_segment+$4e,x
    bne !+
    inc bram_heap_segment+$4e+1,x
  !:
    // bram_heap_idle_insert::@return
    // }
    // [424] return 
    rts
  .segment Data
    s: .byte 0
    idle_index: .byte 0
}
.segment CodeBramHeap
  // bram_heap_size_pack
// __mem() unsigned int bram_heap_size_pack(__mem() unsigned long size)
bram_heap_size_pack: {
    // size >> 5
    // [425] bram_heap_size_pack::$0 = bram_heap_size_pack::size#0 >> 5 -- vdum1=vdum2_ror_5 
    lda size+3
    lsr
    sta bram_heap_size_pack__0+3
    lda size+2
    ror
    sta bram_heap_size_pack__0+2
    lda size+1
    ror
    sta bram_heap_size_pack__0+1
    lda size
    ror
    sta bram_heap_size_pack__0
    lsr bram_heap_size_pack__0+3
    ror bram_heap_size_pack__0+2
    ror bram_heap_size_pack__0+1
    ror bram_heap_size_pack__0
    lsr bram_heap_size_pack__0+3
    ror bram_heap_size_pack__0+2
    ror bram_heap_size_pack__0+1
    ror bram_heap_size_pack__0
    lsr bram_heap_size_pack__0+3
    ror bram_heap_size_pack__0+2
    ror bram_heap_size_pack__0+1
    ror bram_heap_size_pack__0
    lsr bram_heap_size_pack__0+3
    ror bram_heap_size_pack__0+2
    ror bram_heap_size_pack__0+1
    ror bram_heap_size_pack__0
    // return (bram_heap_size_packed_t)(size >> 5);
    // [426] bram_heap_size_pack::return#0 = (unsigned int)bram_heap_size_pack::$0 -- vwum1=_word_vdum2 
    lda bram_heap_size_pack__0
    sta return
    lda bram_heap_size_pack__0+1
    sta return+1
    // bram_heap_size_pack::@return
    // }
    // [427] return 
    rts
  .segment DataBramHeap
    bram_heap_size_pack__0: .dword 0
  .segment Data
    return: .word 0
    size: .dword 0
    return_1: .word 0
}
.segment CodeBramHeap
  // bram_heap_replace_free_with_heap
/**
 * The free size matches exactly the required heap size.
 * The free index is replaced by a heap index.
 */
// __mem() char bram_heap_replace_free_with_heap(__mem() char s, char free_index, __mem() unsigned int required_size)
bram_heap_replace_free_with_heap: {
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [428] bram_heap_get_size_packed::index#2 = bram_heap_replace_free_with_heap::return#2 -- vbuxx=vbum1 
    ldx return
    // [429] call bram_heap_get_size_packed
    // [178] phi from bram_heap_replace_free_with_heap to bram_heap_get_size_packed [phi:bram_heap_replace_free_with_heap->bram_heap_get_size_packed]
    // [178] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#2 [phi:bram_heap_replace_free_with_heap->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_replace_free_with_heap::@2
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [430] bram_heap_get_data_packed::index#1 = bram_heap_replace_free_with_heap::return#2 -- vbuxx=vbum1 
    ldx return
    // [431] call bram_heap_get_data_packed
    // [182] phi from bram_heap_replace_free_with_heap::@2 to bram_heap_get_data_packed [phi:bram_heap_replace_free_with_heap::@2->bram_heap_get_data_packed]
    // [182] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#1 [phi:bram_heap_replace_free_with_heap::@2->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [432] bram_heap_get_data_packed::return#12 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_2
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_2+1
    // bram_heap_replace_free_with_heap::@3
    // [433] bram_heap_replace_free_with_heap::free_data#0 = bram_heap_get_data_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_2
    sta free_data
    lda bram_heap_get_data_packed.return_2+1
    sta free_data+1
    // bram_heap_replace_free_with_heap::bram_heap_get_left1
    // return bram_heap_index.left[index];
    // [434] bram_heap_replace_free_with_heap::free_left#0 = ((char *)&bram_heap_index+$700)[bram_heap_replace_free_with_heap::return#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy return
    lda bram_heap_index+$700,y
    sta free_left
    // bram_heap_replace_free_with_heap::bram_heap_get_right1
    // return bram_heap_index.right[index];
    // [435] bram_heap_replace_free_with_heap::free_right#0 = ((char *)&bram_heap_index+$600)[bram_heap_replace_free_with_heap::return#2] -- vbum1=pbuc1_derefidx_vbum2 
    lda bram_heap_index+$600,y
    sta free_right
    // bram_heap_replace_free_with_heap::@1
    // bram_heap_free_remove(s, free_index)
    // [436] bram_heap_free_remove::s#0 = bram_heap_replace_free_with_heap::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_free_remove.s
    // [437] bram_heap_free_remove::free_index#0 = bram_heap_replace_free_with_heap::return#2 -- vbum1=vbum2 
    tya
    sta bram_heap_free_remove.free_index
    // [438] call bram_heap_free_remove
    // [399] phi from bram_heap_replace_free_with_heap::@1 to bram_heap_free_remove [phi:bram_heap_replace_free_with_heap::@1->bram_heap_free_remove]
    // [399] phi bram_heap_free_remove::free_index#2 = bram_heap_free_remove::free_index#0 [phi:bram_heap_replace_free_with_heap::@1->bram_heap_free_remove#0] -- register_copy 
    // [399] phi bram_heap_free_remove::s#2 = bram_heap_free_remove::s#0 [phi:bram_heap_replace_free_with_heap::@1->bram_heap_free_remove#1] -- call_phi_near 
    jsr bram_heap_free_remove
    // bram_heap_replace_free_with_heap::@4
    // bram_heap_heap_insert_at(s, heap_index, BRAM_HEAP_NULL, required_size)
    // [439] bram_heap_heap_insert_at::s#0 = bram_heap_replace_free_with_heap::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_heap_insert_at.s
    // [440] bram_heap_heap_insert_at::heap_index#0 = bram_heap_replace_free_with_heap::return#2 -- vbum1=vbum2 
    lda return
    sta bram_heap_heap_insert_at.heap_index
    // [441] bram_heap_heap_insert_at::size#0 = bram_heap_replace_free_with_heap::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta bram_heap_heap_insert_at.size
    lda required_size+1
    sta bram_heap_heap_insert_at.size+1
    // [442] call bram_heap_heap_insert_at
    // [496] phi from bram_heap_replace_free_with_heap::@4 to bram_heap_heap_insert_at [phi:bram_heap_replace_free_with_heap::@4->bram_heap_heap_insert_at]
    // [496] phi bram_heap_heap_insert_at::size#2 = bram_heap_heap_insert_at::size#0 [phi:bram_heap_replace_free_with_heap::@4->bram_heap_heap_insert_at#0] -- register_copy 
    // [496] phi bram_heap_heap_insert_at::heap_index#2 = bram_heap_heap_insert_at::heap_index#0 [phi:bram_heap_replace_free_with_heap::@4->bram_heap_heap_insert_at#1] -- register_copy 
    // [496] phi bram_heap_heap_insert_at::s#2 = bram_heap_heap_insert_at::s#0 [phi:bram_heap_replace_free_with_heap::@4->bram_heap_heap_insert_at#2] -- call_phi_near 
    jsr bram_heap_heap_insert_at
    // bram_heap_replace_free_with_heap::@5
    // bram_heap_set_data_packed(s, heap_index, free_data)
    // [443] bram_heap_set_data_packed::index#3 = bram_heap_replace_free_with_heap::return#2 -- vbuxx=vbum1 
    ldx return
    // [444] bram_heap_set_data_packed::data_packed#3 = bram_heap_replace_free_with_heap::free_data#0 -- vwum1=vwum2 
    lda free_data
    sta bram_heap_set_data_packed.data_packed
    lda free_data+1
    sta bram_heap_set_data_packed.data_packed+1
    // [445] call bram_heap_set_data_packed
    // [362] phi from bram_heap_replace_free_with_heap::@5 to bram_heap_set_data_packed [phi:bram_heap_replace_free_with_heap::@5->bram_heap_set_data_packed]
    // [362] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#3 [phi:bram_heap_replace_free_with_heap::@5->bram_heap_set_data_packed#0] -- register_copy 
    // [362] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#3 [phi:bram_heap_replace_free_with_heap::@5->bram_heap_set_data_packed#1] -- call_phi_near 
    jsr bram_heap_set_data_packed
    // bram_heap_replace_free_with_heap::bram_heap_set_left1
    // bram_heap_index.left[index] = left
    // [446] ((char *)&bram_heap_index+$700)[bram_heap_replace_free_with_heap::return#2] = bram_heap_replace_free_with_heap::free_left#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_left
    ldy return
    sta bram_heap_index+$700,y
    // bram_heap_replace_free_with_heap::bram_heap_set_right1
    // bram_heap_index.right[index] = right
    // [447] ((char *)&bram_heap_index+$600)[bram_heap_replace_free_with_heap::return#2] = bram_heap_replace_free_with_heap::free_right#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_right
    sta bram_heap_index+$600,y
    // bram_heap_replace_free_with_heap::@return
    // }
    // [448] return 
    rts
  .segment DataBramHeap
    free_data: .word 0
    free_left: .byte 0
    free_right: .byte 0
  .segment Data
    s: .byte 0
    required_size: .word 0
    return: .byte 0
}
.segment CodeBramHeap
  // bram_heap_split_free_and_allocate
/**
 * Splits the header on two, returns the pointer to the smaller sub-header.
 */
// __register(A) char bram_heap_split_free_and_allocate(__mem() char s, __mem() char free_index, __mem() unsigned int required_size)
bram_heap_split_free_and_allocate: {
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [449] bram_heap_get_size_packed::index#3 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [450] call bram_heap_get_size_packed
  // The free block is reduced in size with the required size.
    // [178] phi from bram_heap_split_free_and_allocate to bram_heap_get_size_packed [phi:bram_heap_split_free_and_allocate->bram_heap_get_size_packed]
    // [178] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#3 [phi:bram_heap_split_free_and_allocate->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [451] bram_heap_get_size_packed::return#13 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return_3
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return_3+1
    // bram_heap_split_free_and_allocate::@2
    // [452] bram_heap_split_free_and_allocate::free_size#0 = bram_heap_get_size_packed::return#13 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_3
    sta free_size
    lda bram_heap_get_size_packed.return_3+1
    sta free_size+1
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [453] bram_heap_get_data_packed::index#2 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [454] call bram_heap_get_data_packed
    // [182] phi from bram_heap_split_free_and_allocate::@2 to bram_heap_get_data_packed [phi:bram_heap_split_free_and_allocate::@2->bram_heap_get_data_packed]
    // [182] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#2 [phi:bram_heap_split_free_and_allocate::@2->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [455] bram_heap_get_data_packed::return#13 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_3
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_3+1
    // bram_heap_split_free_and_allocate::@3
    // [456] bram_heap_split_free_and_allocate::free_data#0 = bram_heap_get_data_packed::return#13 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_3
    sta free_data
    lda bram_heap_get_data_packed.return_3+1
    sta free_data+1
    // bram_heap_set_size_packed(s, free_index, free_size - required_size)
    // [457] bram_heap_set_size_packed::size_packed#4 = bram_heap_split_free_and_allocate::free_size#0 - bram_heap_split_free_and_allocate::required_size#0 -- vwum1=vwum2_minus_vwum3 
    lda free_size
    sec
    sbc required_size
    sta bram_heap_set_size_packed.size_packed
    lda free_size+1
    sbc required_size+1
    sta bram_heap_set_size_packed.size_packed+1
    // [458] bram_heap_set_size_packed::index#4 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [459] call bram_heap_set_size_packed
    // [368] phi from bram_heap_split_free_and_allocate::@3 to bram_heap_set_size_packed [phi:bram_heap_split_free_and_allocate::@3->bram_heap_set_size_packed]
    // [368] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#4 [phi:bram_heap_split_free_and_allocate::@3->bram_heap_set_size_packed#0] -- register_copy 
    // [368] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#4 [phi:bram_heap_split_free_and_allocate::@3->bram_heap_set_size_packed#1] -- call_phi_near 
    jsr bram_heap_set_size_packed
    // bram_heap_split_free_and_allocate::@4
    // bram_heap_set_data_packed(s, free_index, free_data + required_size)
    // [460] bram_heap_set_data_packed::data_packed#4 = bram_heap_split_free_and_allocate::free_data#0 + bram_heap_split_free_and_allocate::required_size#0 -- vwum1=vwum2_plus_vwum3 
    lda free_data
    clc
    adc required_size
    sta bram_heap_set_data_packed.data_packed
    lda free_data+1
    adc required_size+1
    sta bram_heap_set_data_packed.data_packed+1
    // [461] bram_heap_set_data_packed::index#4 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [462] call bram_heap_set_data_packed
    // [362] phi from bram_heap_split_free_and_allocate::@4 to bram_heap_set_data_packed [phi:bram_heap_split_free_and_allocate::@4->bram_heap_set_data_packed]
    // [362] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#4 [phi:bram_heap_split_free_and_allocate::@4->bram_heap_set_data_packed#0] -- register_copy 
    // [362] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#4 [phi:bram_heap_split_free_and_allocate::@4->bram_heap_set_data_packed#1] -- call_phi_near 
    jsr bram_heap_set_data_packed
    // bram_heap_split_free_and_allocate::@5
    // bram_heap_index_t heap_index = bram_heap_index_add(s)
    // [463] bram_heap_index_add::s#1 = bram_heap_split_free_and_allocate::s#0 -- vbuxx=vbum1 
    ldx s
    // [464] call bram_heap_index_add
  // We create a new heap block with the required size.
  // The data is the offset in vram.
    // [337] phi from bram_heap_split_free_and_allocate::@5 to bram_heap_index_add [phi:bram_heap_split_free_and_allocate::@5->bram_heap_index_add]
    // [337] phi bram_heap_index_add::s#2 = bram_heap_index_add::s#1 [phi:bram_heap_split_free_and_allocate::@5->bram_heap_index_add#0] -- call_phi_near 
    jsr bram_heap_index_add
    // bram_heap_index_t heap_index = bram_heap_index_add(s)
    // [465] bram_heap_index_add::return#3 = bram_heap_index_add::return#1 -- vbuaa=vbum1 
    lda bram_heap_index_add.return
    // bram_heap_split_free_and_allocate::@6
    // [466] bram_heap_split_free_and_allocate::heap_index#0 = bram_heap_index_add::return#3 -- vbum1=vbuaa 
    sta heap_index
    // bram_heap_set_data_packed(s, heap_index, free_data)
    // [467] bram_heap_set_data_packed::index#5 = bram_heap_split_free_and_allocate::heap_index#0 -- vbuxx=vbum1 
    tax
    // [468] bram_heap_set_data_packed::data_packed#5 = bram_heap_split_free_and_allocate::free_data#0 -- vwum1=vwum2 
    lda free_data
    sta bram_heap_set_data_packed.data_packed
    lda free_data+1
    sta bram_heap_set_data_packed.data_packed+1
    // [469] call bram_heap_set_data_packed
    // [362] phi from bram_heap_split_free_and_allocate::@6 to bram_heap_set_data_packed [phi:bram_heap_split_free_and_allocate::@6->bram_heap_set_data_packed]
    // [362] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#5 [phi:bram_heap_split_free_and_allocate::@6->bram_heap_set_data_packed#0] -- register_copy 
    // [362] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#5 [phi:bram_heap_split_free_and_allocate::@6->bram_heap_set_data_packed#1] -- call_phi_near 
    jsr bram_heap_set_data_packed
    // bram_heap_split_free_and_allocate::@7
    // bram_heap_heap_insert_at(s, heap_index, BRAM_HEAP_NULL, required_size)
    // [470] bram_heap_heap_insert_at::s#1 = bram_heap_split_free_and_allocate::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_heap_insert_at.s
    // [471] bram_heap_heap_insert_at::heap_index#1 = bram_heap_split_free_and_allocate::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_heap_insert_at.heap_index
    // [472] bram_heap_heap_insert_at::size#1 = bram_heap_split_free_and_allocate::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta bram_heap_heap_insert_at.size
    lda required_size+1
    sta bram_heap_heap_insert_at.size+1
    // [473] call bram_heap_heap_insert_at
    // [496] phi from bram_heap_split_free_and_allocate::@7 to bram_heap_heap_insert_at [phi:bram_heap_split_free_and_allocate::@7->bram_heap_heap_insert_at]
    // [496] phi bram_heap_heap_insert_at::size#2 = bram_heap_heap_insert_at::size#1 [phi:bram_heap_split_free_and_allocate::@7->bram_heap_heap_insert_at#0] -- register_copy 
    // [496] phi bram_heap_heap_insert_at::heap_index#2 = bram_heap_heap_insert_at::heap_index#1 [phi:bram_heap_split_free_and_allocate::@7->bram_heap_heap_insert_at#1] -- register_copy 
    // [496] phi bram_heap_heap_insert_at::s#2 = bram_heap_heap_insert_at::s#1 [phi:bram_heap_split_free_and_allocate::@7->bram_heap_heap_insert_at#2] -- call_phi_near 
    jsr bram_heap_heap_insert_at
    // bram_heap_split_free_and_allocate::bram_heap_get_left1
    // return bram_heap_index.left[index];
    // [474] bram_heap_split_free_and_allocate::heap_left#0 = ((char *)&bram_heap_index+$700)[bram_heap_split_free_and_allocate::free_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy free_index
    lda bram_heap_index+$700,y
    sta heap_left
    // bram_heap_split_free_and_allocate::bram_heap_set_left1
    // bram_heap_index.left[index] = left
    // [475] ((char *)&bram_heap_index+$700)[bram_heap_split_free_and_allocate::heap_index#0] = bram_heap_split_free_and_allocate::heap_left#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy heap_index
    sta bram_heap_index+$700,y
    // bram_heap_split_free_and_allocate::bram_heap_set_right1
    // bram_heap_index.right[index] = right
    // [476] ((char *)&bram_heap_index+$600)[bram_heap_split_free_and_allocate::heap_index#0] = bram_heap_split_free_and_allocate::free_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_index
    sta bram_heap_index+$600,y
    // bram_heap_split_free_and_allocate::bram_heap_set_right2
    // [477] ((char *)&bram_heap_index+$600)[bram_heap_split_free_and_allocate::heap_left#0] = bram_heap_split_free_and_allocate::heap_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy heap_left
    sta bram_heap_index+$600,y
    // bram_heap_split_free_and_allocate::bram_heap_set_left2
    // bram_heap_index.left[index] = left
    // [478] ((char *)&bram_heap_index+$700)[bram_heap_split_free_and_allocate::free_index#0] = bram_heap_split_free_and_allocate::heap_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy free_index
    sta bram_heap_index+$700,y
    // bram_heap_split_free_and_allocate::@1
    // bram_heap_set_free(s, heap_right)
    // [479] bram_heap_set_free::index#2 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [480] call bram_heap_set_free
    // [377] phi from bram_heap_split_free_and_allocate::@1 to bram_heap_set_free [phi:bram_heap_split_free_and_allocate::@1->bram_heap_set_free]
    // [377] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#2 [phi:bram_heap_split_free_and_allocate::@1->bram_heap_set_free#0] -- call_phi_near 
    jsr bram_heap_set_free
    // bram_heap_split_free_and_allocate::@8
    // bram_heap_clear_free(s, heap_left)
    // [481] bram_heap_clear_free::index#1 = bram_heap_split_free_and_allocate::heap_left#0 -- vbuxx=vbum1 
    ldx heap_left
    // [482] call bram_heap_clear_free
    // [493] phi from bram_heap_split_free_and_allocate::@8 to bram_heap_clear_free [phi:bram_heap_split_free_and_allocate::@8->bram_heap_clear_free]
    // [493] phi bram_heap_clear_free::index#2 = bram_heap_clear_free::index#1 [phi:bram_heap_split_free_and_allocate::@8->bram_heap_clear_free#0] -- call_phi_near 
    jsr bram_heap_clear_free
    // bram_heap_split_free_and_allocate::@return
    // }
    // [483] return 
    rts
  .segment DataBramHeap
    free_size: .word 0
    free_data: .word 0
    heap_index: .byte 0
    heap_left: .byte 0
  .segment Data
    s: .byte 0
    free_index: .byte 0
    required_size: .word 0
}
.segment CodeBramHeap
  // heap_idle_remove
// void heap_idle_remove(__mem() char s, __mem() char idle_index)
heap_idle_remove: {
    // bram_heap_segment.idleCount[s]--;
    // [484] heap_idle_remove::$3 = heap_idle_remove::s#0 << 1 -- vbuaa=vbum1_rol_1 
    lda s
    asl
    // [485] ((unsigned int *)&bram_heap_segment+$4e)[heap_idle_remove::$3] = -- ((unsigned int *)&bram_heap_segment+$4e)[heap_idle_remove::$3] -- pwuc1_derefidx_vbuaa=_dec_pwuc1_derefidx_vbuaa 
    tax
    lda bram_heap_segment+$4e,x
    bne !+
    dec bram_heap_segment+$4e+1,x
  !:
    dec bram_heap_segment+$4e,x
    // bram_heap_list_remove(s, bram_heap_segment.idle_list[s], idle_index)
    // [486] bram_heap_list_remove::list#4 = ((char *)&bram_heap_segment+$32)[heap_idle_remove::s#0] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$32,y
    // [487] bram_heap_list_remove::index#2 = heap_idle_remove::idle_index#0 -- vbum1=vbum2 
    lda idle_index
    sta bram_heap_list_remove.index
    // [488] call bram_heap_list_remove
    // [380] phi from heap_idle_remove to bram_heap_list_remove [phi:heap_idle_remove->bram_heap_list_remove]
    // [380] phi bram_heap_list_remove::index#10 = bram_heap_list_remove::index#2 [phi:heap_idle_remove->bram_heap_list_remove#0] -- register_copy 
    // [380] phi bram_heap_list_remove::list#10 = bram_heap_list_remove::list#4 [phi:heap_idle_remove->bram_heap_list_remove#1] -- call_phi_near 
    jsr bram_heap_list_remove
    // bram_heap_list_remove(s, bram_heap_segment.idle_list[s], idle_index)
    // [489] bram_heap_list_remove::return#10 = bram_heap_list_remove::return#1 -- vbuaa=vbuxx 
    txa
    // heap_idle_remove::@1
    // [490] heap_idle_remove::$1 = bram_heap_list_remove::return#10
    // bram_heap_segment.idle_list[s] = bram_heap_list_remove(s, bram_heap_segment.idle_list[s], idle_index)
    // [491] ((char *)&bram_heap_segment+$32)[heap_idle_remove::s#0] = heap_idle_remove::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy s
    sta bram_heap_segment+$32,y
    // heap_idle_remove::@return
    // }
    // [492] return 
    rts
  .segment Data
    s: .byte 0
    idle_index: .byte 0
}
.segment CodeBramHeap
  // bram_heap_clear_free
// void bram_heap_clear_free(char s, __register(X) char index)
bram_heap_clear_free: {
    // bram_heap_index.size1[index] &= 0x7F
    // [494] ((char *)&bram_heap_index+$300)[bram_heap_clear_free::index#2] = ((char *)&bram_heap_index+$300)[bram_heap_clear_free::index#2] & $7f -- pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_band_vbuc2 
    lda #$7f
    and bram_heap_index+$300,x
    sta bram_heap_index+$300,x
    // bram_heap_clear_free::@return
    // }
    // [495] return 
    rts
}
  // bram_heap_heap_insert_at
// char bram_heap_heap_insert_at(__mem() char s, __mem() char heap_index, char at, __mem() unsigned int size)
bram_heap_heap_insert_at: {
    // bram_heap_list_insert_at(s, bram_heap_segment.heap_list[s], heap_index, at)
    // [497] bram_heap_list_insert_at::list#1 = ((char *)&bram_heap_segment+$2a)[bram_heap_heap_insert_at::s#2] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$2a,y
    // [498] bram_heap_list_insert_at::index#1 = bram_heap_heap_insert_at::heap_index#2 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_list_insert_at.index
    // [499] call bram_heap_list_insert_at
    // [347] phi from bram_heap_heap_insert_at to bram_heap_list_insert_at [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at]
    // [347] phi bram_heap_list_insert_at::index#10 = bram_heap_list_insert_at::index#1 [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at#0] -- register_copy 
    // [347] phi bram_heap_list_insert_at::at#11 = $ff [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at#1] -- vbum1=vbuc1 
    lda #$ff
    sta bram_heap_list_insert_at.at
    // [347] phi bram_heap_list_insert_at::list#5 = bram_heap_list_insert_at::list#1 [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at#2] -- call_phi_near 
    jsr bram_heap_list_insert_at
    // bram_heap_list_insert_at(s, bram_heap_segment.heap_list[s], heap_index, at)
    // [500] bram_heap_list_insert_at::return#1 = bram_heap_list_insert_at::list#11 -- vbuaa=vbuxx 
    txa
    // bram_heap_heap_insert_at::@1
    // [501] bram_heap_heap_insert_at::$0 = bram_heap_list_insert_at::return#1
    // bram_heap_segment.heap_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.heap_list[s], heap_index, at)
    // [502] ((char *)&bram_heap_segment+$2a)[bram_heap_heap_insert_at::s#2] = bram_heap_heap_insert_at::$0 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy s
    sta bram_heap_segment+$2a,y
    // bram_heap_set_size_packed(s, heap_index, size)
    // [503] bram_heap_set_size_packed::index#1 = bram_heap_heap_insert_at::heap_index#2 -- vbuxx=vbum1 
    ldx heap_index
    // [504] bram_heap_set_size_packed::size_packed#1 = bram_heap_heap_insert_at::size#2 -- vwum1=vwum2 
    lda size
    sta bram_heap_set_size_packed.size_packed
    lda size+1
    sta bram_heap_set_size_packed.size_packed+1
    // [505] call bram_heap_set_size_packed
    // [368] phi from bram_heap_heap_insert_at::@1 to bram_heap_set_size_packed [phi:bram_heap_heap_insert_at::@1->bram_heap_set_size_packed]
    // [368] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#1 [phi:bram_heap_heap_insert_at::@1->bram_heap_set_size_packed#0] -- register_copy 
    // [368] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#1 [phi:bram_heap_heap_insert_at::@1->bram_heap_set_size_packed#1] -- call_phi_near 
    jsr bram_heap_set_size_packed
    // bram_heap_heap_insert_at::@2
    // bram_heap_segment.heapCount[s]++;
    // [506] bram_heap_heap_insert_at::$4 = bram_heap_heap_insert_at::s#2 << 1 -- vbuaa=vbum1_rol_1 
    lda s
    asl
    // [507] ((unsigned int *)&bram_heap_segment+$3e)[bram_heap_heap_insert_at::$4] = ++ ((unsigned int *)&bram_heap_segment+$3e)[bram_heap_heap_insert_at::$4] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc bram_heap_segment+$3e,x
    bne !+
    inc bram_heap_segment+$3e+1,x
  !:
    // bram_heap_heap_insert_at::@return
    // }
    // [508] return 
    rts
  .segment Data
    s: .byte 0
    heap_index: .byte 0
    size: .word 0
}
  // File Data
.segment DataBramHeap
  funcs: .word bram_heap_alloc, bram_heap_free, bram_heap_bram_bank_init, bram_heap_segment_init, bram_heap_data_get_bank, bram_heap_data_get_offset, bram_heap_get_size
.segment BramBramHeap
  bram_heap_index: .fill SIZEOF_STRUCT___1, 0
.segment DataBramHeap
  bram_heap_segment: .fill SIZEOF_STRUCT___2, 0
