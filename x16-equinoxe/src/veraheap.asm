.namespace veraheap {
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
    // [184] phi from __start::@1 to main [phi:__start::@1->main] -- call_phi_near 
    jsr main
    // __start::@return
    // [5] return 
    rts
}
.segment CodeVeraHeap
  // vera_heap_has_free
/**
 * @brief Return if there is free memory according to the requested size.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @param size_requested The requested size in uint16 format.
 * @return bool indicating if there is free memory or not.
 */
// bool vera_heap_has_free(__mem() char s, __mem() unsigned int size_requested)
vera_heap_has_free: {
    .const OFFSET_STACK_S = 2
    .const OFFSET_STACK_SIZE_REQUESTED = 0
    .const OFFSET_STACK_RETURN_2 = 2
    // [6] vera_heap_has_free::s#0 = stackidx(char,vera_heap_has_free::OFFSET_STACK_S) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_S,x
    sta s
    // [7] vera_heap_has_free::size_requested#0 = stackidx(unsigned int,vera_heap_has_free::OFFSET_STACK_SIZE_REQUESTED) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_SIZE_REQUESTED,x
    sta size_requested
    lda STACK_BASE+OFFSET_STACK_SIZE_REQUESTED+1,x
    sta size_requested+1
    // bank_push_set_bram(vera_heap_segment.bram_bank)
    // [8] vera_heap_has_free::bank_push_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbum1=_deref_pbuc1 
    lda vera_heap_segment
    sta bank_push_set_bram1_bank
    // vera_heap_has_free::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [10] BRAM = vera_heap_has_free::bank_push_set_bram1_bank#0 -- vbuz1=vbum2 
    lda bank_push_set_bram1_bank
    sta.z BRAM
    // vera_heap_has_free::@1
    // vera_heap_size_packed_t packed_size = vera_heap_alloc_size_get(size_requested)
    // [11] vera_heap_alloc_size_get::size#1 = vera_heap_has_free::size_requested#0 -- vdum1=vwum2 
    lda size_requested
    sta vera_heap_alloc_size_get.size
    lda size_requested+1
    sta vera_heap_alloc_size_get.size+1
    lda #0
    sta vera_heap_alloc_size_get.size+2
    sta vera_heap_alloc_size_get.size+3
    // [12] call vera_heap_alloc_size_get
  // Adjust given size to 8 bytes boundary (shift right with 3 bits).
    // [186] phi from vera_heap_has_free::@1 to vera_heap_alloc_size_get [phi:vera_heap_has_free::@1->vera_heap_alloc_size_get]
    // [186] phi vera_heap_alloc_size_get::size#2 = vera_heap_alloc_size_get::size#1 [phi:vera_heap_has_free::@1->vera_heap_alloc_size_get#0] -- call_phi_near 
    jsr vera_heap_alloc_size_get
    // vera_heap_size_packed_t packed_size = vera_heap_alloc_size_get(size_requested)
    // [13] vera_heap_alloc_size_get::return#1 = vera_heap_alloc_size_get::return#2 -- vwum1=vwum2 
    lda vera_heap_alloc_size_get.return_2
    sta vera_heap_alloc_size_get.return_1
    lda vera_heap_alloc_size_get.return_2+1
    sta vera_heap_alloc_size_get.return_1+1
    // vera_heap_has_free::@2
    // [14] vera_heap_has_free::packed_size#0 = vera_heap_alloc_size_get::return#1 -- vwum1=vwum2 
    lda vera_heap_alloc_size_get.return_1
    sta packed_size
    lda vera_heap_alloc_size_get.return_1+1
    sta packed_size+1
    // vera_heap_index_t free_index = vera_heap_find_best_fit(s, packed_size)
    // [15] vera_heap_find_best_fit::s#1 = vera_heap_has_free::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_find_best_fit.s
    // [16] vera_heap_find_best_fit::requested_size#1 = vera_heap_has_free::packed_size#0 -- vwum1=vwum2 
    lda packed_size
    sta vera_heap_find_best_fit.requested_size
    lda packed_size+1
    sta vera_heap_find_best_fit.requested_size+1
    // [17] call vera_heap_find_best_fit
    // [193] phi from vera_heap_has_free::@2 to vera_heap_find_best_fit [phi:vera_heap_has_free::@2->vera_heap_find_best_fit]
    // [193] phi vera_heap_find_best_fit::requested_size#6 = vera_heap_find_best_fit::requested_size#1 [phi:vera_heap_has_free::@2->vera_heap_find_best_fit#0] -- register_copy 
    // [193] phi vera_heap_find_best_fit::s#2 = vera_heap_find_best_fit::s#1 [phi:vera_heap_has_free::@2->vera_heap_find_best_fit#1] -- call_phi_near 
    jsr vera_heap_find_best_fit
    // vera_heap_index_t free_index = vera_heap_find_best_fit(s, packed_size)
    // [18] vera_heap_find_best_fit::return#1 = vera_heap_find_best_fit::return#3 -- vbum1=vbum2 
    lda vera_heap_find_best_fit.return_2
    sta vera_heap_find_best_fit.return_1
    // vera_heap_has_free::@3
    // [19] vera_heap_has_free::free_index#0 = vera_heap_find_best_fit::return#1 -- vbum1=vbum2 
    sta free_index
    // bool has_free = free_index != VERAHEAP_NULL
    // [20] vera_heap_has_free::has_free#0 = vera_heap_has_free::free_index#0 != $ff -- vbom1=vbum2_neq_vbuc1 
    eor #$ff
    beq !+
    lda #1
  !:
    sta has_free
    // vera_heap_has_free::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // vera_heap_has_free::@return
    // }
    // [22] stackidx(bool,vera_heap_has_free::OFFSET_STACK_RETURN_2) = vera_heap_has_free::has_free#0 -- _stackidxbool_vbuc1=vbom1 
    lda has_free
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_2,x
    // [23] return 
    rts
  .segment Data
    s: .byte 0
    size_requested: .word 0
    bank_push_set_bram1_bank: .byte 0
  .segment CodeVeraHeap
    packed_size: .word 0
    free_index: .byte 0
    has_free: .byte 0
}
  // vera_heap_data_get_bank
// char vera_heap_data_get_bank(char s, __mem() char index)
vera_heap_data_get_bank: {
    .const OFFSET_STACK_INDEX = 0
    .const OFFSET_STACK_RETURN_1 = 1
    // [24] vera_heap_data_get_bank::index#0 = stackidx(char,vera_heap_data_get_bank::OFFSET_STACK_INDEX) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_INDEX,x
    sta index
    // vera_heap_data_get_bank::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // vera_heap_data_get_bank::@1
    // bank_set_bram(vera_heap_segment.bram_bank)
    // [26] vera_heap_data_get_bank::bank_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbum1=_deref_pbuc1 
    lda vera_heap_segment
    sta bank_set_bram1_bank
    // vera_heap_data_get_bank::bank_set_bram1
    // BRAM = bank
    // [27] BRAM = vera_heap_data_get_bank::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // vera_heap_data_get_bank::@2
    // vram_bank_t vram_bank = vera_heap_index.data1[index] >> 5
    // [28] vera_heap_data_get_bank::vram_bank#0 = ((char *)&vera_heap_index+$100)[vera_heap_data_get_bank::index#0] >> 5 -- vbum1=pbuc1_derefidx_vbum2_ror_5 
    ldy index
    lda vera_heap_index+$100,y
    lsr
    lsr
    lsr
    lsr
    lsr
    sta vram_bank
    // vera_heap_data_get_bank::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // vera_heap_data_get_bank::@return
    // }
    // [30] stackidx(char,vera_heap_data_get_bank::OFFSET_STACK_RETURN_1) = vera_heap_data_get_bank::vram_bank#0 -- _stackidxbyte_vbuc1=vbum1 
    lda vram_bank
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    // [31] return 
    rts
  .segment Data
    index: .byte 0
    bank_set_bram1_bank: .byte 0
  .segment CodeVeraHeap
    vram_bank: .byte 0
}
  // vera_heap_data_get_offset
// unsigned int vera_heap_data_get_offset(char s, __mem() char index)
vera_heap_data_get_offset: {
    .const OFFSET_STACK_INDEX = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [32] vera_heap_data_get_offset::index#0 = stackidx(char,vera_heap_data_get_offset::OFFSET_STACK_INDEX) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_INDEX,x
    sta index
    // vera_heap_data_get_offset::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // vera_heap_data_get_offset::@1
    // bank_set_bram(vera_heap_segment.bram_bank)
    // [34] vera_heap_data_get_offset::bank_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbum1=_deref_pbuc1 
    lda vera_heap_segment
    sta bank_set_bram1_bank
    // vera_heap_data_get_offset::bank_set_bram1
    // BRAM = bank
    // [35] BRAM = vera_heap_data_get_offset::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // vera_heap_data_get_offset::@2
    // vera_heap_get_data_packed(s, index)
    // [36] vera_heap_get_data_packed::index#1 = vera_heap_data_get_offset::index#0 -- vbum1=vbum2 
    lda index
    sta vera_heap_get_data_packed.index
    // [37] call vera_heap_get_data_packed
    // [214] phi from vera_heap_data_get_offset::@2 to vera_heap_get_data_packed [phi:vera_heap_data_get_offset::@2->vera_heap_get_data_packed]
    // [214] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#1 [phi:vera_heap_data_get_offset::@2->vera_heap_get_data_packed#0] -- call_phi_near 
    jsr vera_heap_get_data_packed
    // vera_heap_get_data_packed(s, index)
    // [38] vera_heap_get_data_packed::return#13 = vera_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_1
    sta vera_heap_get_data_packed.return_3
    lda vera_heap_get_data_packed.return_1+1
    sta vera_heap_get_data_packed.return_3+1
    // vera_heap_data_get_offset::@3
    // vram_offset_t vram_offset = (vram_offset_t)vera_heap_get_data_packed(s, index) << 3
    // [39] vera_heap_data_get_offset::$5 = vera_heap_get_data_packed::return#13 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_3
    sta vera_heap_data_get_offset__5
    lda vera_heap_get_data_packed.return_3+1
    sta vera_heap_data_get_offset__5+1
    // [40] vera_heap_data_get_offset::vram_offset#0 = vera_heap_data_get_offset::$5 << 3 -- vwum1=vwum2_rol_3 
    lda vera_heap_data_get_offset__5
    asl
    sta vram_offset
    lda vera_heap_data_get_offset__5+1
    rol
    sta vram_offset+1
    asl vram_offset
    rol vram_offset+1
    asl vram_offset
    rol vram_offset+1
    // vera_heap_data_get_offset::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // vera_heap_data_get_offset::@return
    // }
    // [42] stackidx(unsigned int,vera_heap_data_get_offset::OFFSET_STACK_RETURN_0) = vera_heap_data_get_offset::vram_offset#0 -- _stackidxword_vbuc1=vwum1 
    tsx
    lda vram_offset
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda vram_offset+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [43] return 
    rts
    vera_heap_data_get_offset__5: .word 0
  .segment Data
    index: .byte 0
    bank_set_bram1_bank: .byte 0
  .segment CodeVeraHeap
    vram_offset: .word 0
}
  // vera_heap_free
/**
 * @brief Free a memory block from the heap using the handle of allocated memory of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @param handle The handle referring to the heap memory block.
 * @return heap_handle 
 */
// void vera_heap_free(__mem() char s, __mem() char free_index)
vera_heap_free: {
    .const OFFSET_STACK_S = 1
    .const OFFSET_STACK_FREE_INDEX = 0
    // [44] vera_heap_free::s#0 = stackidx(char,vera_heap_free::OFFSET_STACK_S) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_S,x
    sta s
    // [45] vera_heap_free::free_index#0 = stackidx(char,vera_heap_free::OFFSET_STACK_FREE_INDEX) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_FREE_INDEX,x
    sta free_index
    // vera_heap_free::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // vera_heap_free::@5
    // bank_set_bram(vera_heap_segment.bram_bank)
    // [47] vera_heap_free::bank_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbum1=_deref_pbuc1 
    lda vera_heap_segment
    sta bank_set_bram1_bank
    // vera_heap_free::bank_set_bram1
    // BRAM = bank
    // [48] BRAM = vera_heap_free::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // vera_heap_free::@6
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [49] vera_heap_get_size_packed::index#0 = vera_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_get_size_packed.index
    // [50] call vera_heap_get_size_packed
    // [217] phi from vera_heap_free::@6 to vera_heap_get_size_packed [phi:vera_heap_free::@6->vera_heap_get_size_packed]
    // [217] phi vera_heap_get_size_packed::index#7 = vera_heap_get_size_packed::index#0 [phi:vera_heap_free::@6->vera_heap_get_size_packed#0] -- call_phi_near 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [51] vera_heap_get_size_packed::return#0 = vera_heap_get_size_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_size_packed.return_1
    sta vera_heap_get_size_packed.return
    lda vera_heap_get_size_packed.return_1+1
    sta vera_heap_get_size_packed.return+1
    // vera_heap_free::@7
    // [52] vera_heap_free::free_size#0 = vera_heap_get_size_packed::return#0 -- vwum1=vwum2 
    lda vera_heap_get_size_packed.return
    sta free_size
    lda vera_heap_get_size_packed.return+1
    sta free_size+1
    // vera_heap_data_packed_t free_offset = vera_heap_get_data_packed(s, free_index)
    // [53] vera_heap_get_data_packed::index#0 = vera_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_get_data_packed.index
    // [54] call vera_heap_get_data_packed
    // [214] phi from vera_heap_free::@7 to vera_heap_get_data_packed [phi:vera_heap_free::@7->vera_heap_get_data_packed]
    // [214] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#0 [phi:vera_heap_free::@7->vera_heap_get_data_packed#0] -- call_phi_near 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t free_offset = vera_heap_get_data_packed(s, free_index)
    // [55] vera_heap_get_data_packed::return#0 = vera_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_1
    sta vera_heap_get_data_packed.return
    lda vera_heap_get_data_packed.return_1+1
    sta vera_heap_get_data_packed.return+1
    // vera_heap_free::@8
    // [56] vera_heap_free::free_offset#0 = vera_heap_get_data_packed::return#0 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return
    sta free_offset
    lda vera_heap_get_data_packed.return+1
    sta free_offset+1
    // vera_heap_heap_remove(s, free_index)
    // [57] vera_heap_heap_remove::s#0 = vera_heap_free::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_heap_remove.s
    // [58] vera_heap_heap_remove::heap_index#0 = vera_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_heap_remove.heap_index
    // [59] call vera_heap_heap_remove -- call_phi_near 
    // TODO: only remove allocated indexes!
    jsr vera_heap_heap_remove
    // vera_heap_free::@9
    // vera_heap_free_insert(s, free_index, free_offset, free_size)
    // [60] vera_heap_free_insert::s#0 = vera_heap_free::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_free_insert.s
    // [61] vera_heap_free_insert::free_index#0 = vera_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_free_insert.free_index
    // [62] vera_heap_free_insert::data#0 = vera_heap_free::free_offset#0 -- vwum1=vwum2 
    lda free_offset
    sta vera_heap_free_insert.data
    lda free_offset+1
    sta vera_heap_free_insert.data+1
    // [63] vera_heap_free_insert::size#0 = vera_heap_free::free_size#0 -- vwum1=vwum2 
    lda free_size
    sta vera_heap_free_insert.size
    lda free_size+1
    sta vera_heap_free_insert.size+1
    // [64] call vera_heap_free_insert -- call_phi_near 
    jsr vera_heap_free_insert
    // vera_heap_free::@10
    // vera_heap_index_t free_left_index = vera_heap_can_coalesce_left(s, free_index)
    // [65] vera_heap_can_coalesce_left::heap_index#0 = vera_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_can_coalesce_left.heap_index
    // [66] call vera_heap_can_coalesce_left -- call_phi_near 
    jsr vera_heap_can_coalesce_left
    // [67] vera_heap_can_coalesce_left::return#0 = vera_heap_can_coalesce_left::return#3 -- vbum1=vbum2 
    lda vera_heap_can_coalesce_left.return_1
    sta vera_heap_can_coalesce_left.return
    // vera_heap_free::@11
    // [68] vera_heap_free::free_left_index#0 = vera_heap_can_coalesce_left::return#0 -- vbum1=vbum2 
    sta free_left_index
    // if(free_left_index != VERAHEAP_NULL)
    // [69] if(vera_heap_free::free_left_index#0==$ff) goto vera_heap_free::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #$ff
    cmp free_left_index
    beq __b1
    // vera_heap_free::@3
    // vera_heap_coalesce(s, free_left_index, free_index)
    // [70] vera_heap_coalesce::s#0 = vera_heap_free::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_coalesce.s
    // [71] vera_heap_coalesce::left_index#0 = vera_heap_free::free_left_index#0 -- vbum1=vbum2 
    lda free_left_index
    sta vera_heap_coalesce.left_index
    // [72] vera_heap_coalesce::right_index#0 = vera_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_coalesce.right_index
    // [73] call vera_heap_coalesce
    // [266] phi from vera_heap_free::@3 to vera_heap_coalesce [phi:vera_heap_free::@3->vera_heap_coalesce]
    // [266] phi vera_heap_coalesce::left_index#10 = vera_heap_coalesce::left_index#0 [phi:vera_heap_free::@3->vera_heap_coalesce#0] -- register_copy 
    // [266] phi vera_heap_coalesce::right_index#10 = vera_heap_coalesce::right_index#0 [phi:vera_heap_free::@3->vera_heap_coalesce#1] -- register_copy 
    // [266] phi vera_heap_coalesce::s#10 = vera_heap_coalesce::s#0 [phi:vera_heap_free::@3->vera_heap_coalesce#2] -- call_phi_near 
    jsr vera_heap_coalesce
    // vera_heap_coalesce(s, free_left_index, free_index)
    // [74] vera_heap_coalesce::return#0 = vera_heap_coalesce::right_index#10 -- vbum1=vbum2 
    lda vera_heap_coalesce.right_index
    sta vera_heap_coalesce.return
    // vera_heap_free::@13
    // free_index = vera_heap_coalesce(s, free_left_index, free_index)
    // [75] vera_heap_free::free_index#1 = vera_heap_coalesce::return#0 -- vbum1=vbum2 
    sta free_index
    // [76] phi from vera_heap_free::@11 vera_heap_free::@13 to vera_heap_free::@1 [phi:vera_heap_free::@11/vera_heap_free::@13->vera_heap_free::@1]
    // [76] phi vera_heap_free::free_index#10 = vera_heap_free::free_index#0 [phi:vera_heap_free::@11/vera_heap_free::@13->vera_heap_free::@1#0] -- register_copy 
    // vera_heap_free::@1
  __b1:
    // vera_heap_index_t free_right_index = heap_can_coalesce_right(s, free_index)
    // [77] heap_can_coalesce_right::heap_index#0 = vera_heap_free::free_index#10 -- vbum1=vbum2 
    lda free_index
    sta heap_can_coalesce_right.heap_index
    // [78] call heap_can_coalesce_right -- call_phi_near 
    jsr heap_can_coalesce_right
    // [79] heap_can_coalesce_right::return#0 = heap_can_coalesce_right::return#3 -- vbum1=vbum2 
    lda heap_can_coalesce_right.return_1
    sta heap_can_coalesce_right.return
    // vera_heap_free::@12
    // [80] vera_heap_free::free_right_index#0 = heap_can_coalesce_right::return#0 -- vbum1=vbum2 
    sta free_right_index
    // if(free_right_index != VERAHEAP_NULL)
    // [81] if(vera_heap_free::free_right_index#0==$ff) goto vera_heap_free::@2 -- vbum1_eq_vbuc1_then_la1 
    lda #$ff
    cmp free_right_index
    beq __b2
    // vera_heap_free::@4
    // vera_heap_coalesce(s, free_index, free_right_index)
    // [82] vera_heap_coalesce::s#1 = vera_heap_free::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_coalesce.s
    // [83] vera_heap_coalesce::left_index#1 = vera_heap_free::free_index#10 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_coalesce.left_index
    // [84] vera_heap_coalesce::right_index#1 = vera_heap_free::free_right_index#0 -- vbum1=vbum2 
    lda free_right_index
    sta vera_heap_coalesce.right_index
    // [85] call vera_heap_coalesce
    // [266] phi from vera_heap_free::@4 to vera_heap_coalesce [phi:vera_heap_free::@4->vera_heap_coalesce]
    // [266] phi vera_heap_coalesce::left_index#10 = vera_heap_coalesce::left_index#1 [phi:vera_heap_free::@4->vera_heap_coalesce#0] -- register_copy 
    // [266] phi vera_heap_coalesce::right_index#10 = vera_heap_coalesce::right_index#1 [phi:vera_heap_free::@4->vera_heap_coalesce#1] -- register_copy 
    // [266] phi vera_heap_coalesce::s#10 = vera_heap_coalesce::s#1 [phi:vera_heap_free::@4->vera_heap_coalesce#2] -- call_phi_near 
    jsr vera_heap_coalesce
    // vera_heap_free::@2
  __b2:
    // vera_heap_segment.freeSize[s] += free_size
    // [86] vera_heap_free::$16 = vera_heap_free::s#0 << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta vera_heap_free__16
    // [87] ((unsigned int *)&vera_heap_segment+$5e)[vera_heap_free::$16] = ((unsigned int *)&vera_heap_segment+$5e)[vera_heap_free::$16] + vera_heap_free::free_size#0 -- pwuc1_derefidx_vbum1=pwuc1_derefidx_vbum1_plus_vwum2 
    tay
    lda vera_heap_segment+$5e,y
    clc
    adc free_size
    sta vera_heap_segment+$5e,y
    lda vera_heap_segment+$5e+1,y
    adc free_size+1
    sta vera_heap_segment+$5e+1,y
    // vera_heap_segment.heapSize[s] -= free_size
    // [88] ((unsigned int *)&vera_heap_segment+$56)[vera_heap_free::$16] = ((unsigned int *)&vera_heap_segment+$56)[vera_heap_free::$16] - vera_heap_free::free_size#0 -- pwuc1_derefidx_vbum1=pwuc1_derefidx_vbum1_minus_vwum2 
    lda vera_heap_segment+$56,y
    sec
    sbc free_size
    sta vera_heap_segment+$56,y
    lda vera_heap_segment+$56+1,y
    sbc free_size+1
    sta vera_heap_segment+$56+1,y
    // vera_heap_free::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // vera_heap_free::@return
    // }
    // [90] return 
    rts
    vera_heap_free__16: .byte 0
  .segment Data
    s: .byte 0
    free_index: .byte 0
    bank_set_bram1_bank: .byte 0
  .segment CodeVeraHeap
    free_size: .word 0
    free_offset: .word 0
    free_left_index: .byte 0
    free_right_index: .byte 0
}
  // vera_heap_alloc
/**
 * @brief Allocated a specified size of memory on the heap of the segment.
 * 
 * @param size Specifies the size of memory to be allocated.
 * Note that the size is aligned to an 8 byte boundary by the memory manager.
 * When the size of the memory block is enquired, an 8 byte aligned value will be returned.
 * @return heap_handle The handle referring to the free record in the index.
 */
// __mem() char vera_heap_alloc(__mem() char s, __mem() unsigned long size)
vera_heap_alloc: {
    .const OFFSET_STACK_S = 4
    .const OFFSET_STACK_SIZE = 0
    .const OFFSET_STACK_RETURN_4 = 4
    // [91] vera_heap_alloc::s#0 = stackidx(char,vera_heap_alloc::OFFSET_STACK_S) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_S,x
    sta s
    // [92] vera_heap_alloc::size#0 = stackidx(unsigned long,vera_heap_alloc::OFFSET_STACK_SIZE) -- vdum1=_stackidxdword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_SIZE,x
    sta size
    lda STACK_BASE+OFFSET_STACK_SIZE+1,x
    sta size+1
    lda STACK_BASE+OFFSET_STACK_SIZE+2,x
    sta size+2
    lda STACK_BASE+OFFSET_STACK_SIZE+3,x
    sta size+3
    // vera_heap_alloc::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // vera_heap_alloc::@2
    // bank_set_bram(vera_heap_segment.bram_bank)
    // [94] vera_heap_alloc::bank_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbum1=_deref_pbuc1 
    lda vera_heap_segment
    sta bank_set_bram1_bank
    // vera_heap_alloc::bank_set_bram1
    // BRAM = bank
    // [95] BRAM = vera_heap_alloc::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // vera_heap_alloc::@3
    // vera_heap_size_packed_t packed_size = vera_heap_alloc_size_get(size)
    // [96] vera_heap_alloc_size_get::size#0 = vera_heap_alloc::size#0 -- vdum1=vdum2 
    lda size
    sta vera_heap_alloc_size_get.size
    lda size+1
    sta vera_heap_alloc_size_get.size+1
    lda size+2
    sta vera_heap_alloc_size_get.size+2
    lda size+3
    sta vera_heap_alloc_size_get.size+3
    // [97] call vera_heap_alloc_size_get
  // Adjust given size to 8 bytes boundary (shift right with 3 bits).
    // [186] phi from vera_heap_alloc::@3 to vera_heap_alloc_size_get [phi:vera_heap_alloc::@3->vera_heap_alloc_size_get]
    // [186] phi vera_heap_alloc_size_get::size#2 = vera_heap_alloc_size_get::size#0 [phi:vera_heap_alloc::@3->vera_heap_alloc_size_get#0] -- call_phi_near 
    jsr vera_heap_alloc_size_get
    // vera_heap_size_packed_t packed_size = vera_heap_alloc_size_get(size)
    // [98] vera_heap_alloc_size_get::return#0 = vera_heap_alloc_size_get::return#2 -- vwum1=vwum2 
    lda vera_heap_alloc_size_get.return_2
    sta vera_heap_alloc_size_get.return
    lda vera_heap_alloc_size_get.return_2+1
    sta vera_heap_alloc_size_get.return+1
    // vera_heap_alloc::@4
    // [99] vera_heap_alloc::packed_size#0 = vera_heap_alloc_size_get::return#0 -- vwum1=vwum2 
    lda vera_heap_alloc_size_get.return
    sta packed_size
    lda vera_heap_alloc_size_get.return+1
    sta packed_size+1
    // vera_heap_index_t free_index = vera_heap_find_best_fit(s, packed_size)
    // [100] vera_heap_find_best_fit::s#0 = vera_heap_alloc::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_find_best_fit.s
    // [101] vera_heap_find_best_fit::requested_size#0 = vera_heap_alloc::packed_size#0 -- vwum1=vwum2 
    lda packed_size
    sta vera_heap_find_best_fit.requested_size
    lda packed_size+1
    sta vera_heap_find_best_fit.requested_size+1
    // [102] call vera_heap_find_best_fit
    // [193] phi from vera_heap_alloc::@4 to vera_heap_find_best_fit [phi:vera_heap_alloc::@4->vera_heap_find_best_fit]
    // [193] phi vera_heap_find_best_fit::requested_size#6 = vera_heap_find_best_fit::requested_size#0 [phi:vera_heap_alloc::@4->vera_heap_find_best_fit#0] -- register_copy 
    // [193] phi vera_heap_find_best_fit::s#2 = vera_heap_find_best_fit::s#0 [phi:vera_heap_alloc::@4->vera_heap_find_best_fit#1] -- call_phi_near 
    jsr vera_heap_find_best_fit
    // vera_heap_index_t free_index = vera_heap_find_best_fit(s, packed_size)
    // [103] vera_heap_find_best_fit::return#0 = vera_heap_find_best_fit::return#3 -- vbum1=vbum2 
    lda vera_heap_find_best_fit.return_2
    sta vera_heap_find_best_fit.return
    // vera_heap_alloc::@5
    // [104] vera_heap_alloc::free_index#0 = vera_heap_find_best_fit::return#0 -- vbum1=vbum2 
    sta free_index
    // if(free_index != VERAHEAP_NULL)
    // [105] if(vera_heap_alloc::free_index#0!=$ff) goto vera_heap_alloc::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp free_index
    bne __b1
    // [106] phi from vera_heap_alloc::@5 to vera_heap_alloc::bank_pull_bram1 [phi:vera_heap_alloc::@5->vera_heap_alloc::bank_pull_bram1]
    // [106] phi vera_heap_alloc::return#0 = $ff [phi:vera_heap_alloc::@5->vera_heap_alloc::bank_pull_bram1#0] -- vbum1=vbuc1 
    sta return
    // vera_heap_alloc::bank_pull_bram1
  bank_pull_bram1:
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // vera_heap_alloc::@return
    // }
    // [108] stackidx(char,vera_heap_alloc::OFFSET_STACK_RETURN_4) = vera_heap_alloc::return#0 -- _stackidxbyte_vbuc1=vbum1 
    lda return
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_4,x
    // [109] return 
    rts
    // vera_heap_alloc::@1
  __b1:
    // vera_heap_allocate(s, free_index, packed_size)
    // [110] vera_heap_allocate::s#0 = vera_heap_alloc::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_allocate.s
    // [111] vera_heap_allocate::free_index#0 = vera_heap_alloc::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_allocate.free_index
    // [112] vera_heap_allocate::required_size#0 = vera_heap_alloc::packed_size#0 -- vwum1=vwum2 
    lda packed_size
    sta vera_heap_allocate.required_size
    lda packed_size+1
    sta vera_heap_allocate.required_size+1
    // [113] call vera_heap_allocate -- call_phi_near 
    jsr vera_heap_allocate
    // [114] vera_heap_allocate::return#0 = vera_heap_allocate::return#4 -- vbum1=vbum2 
    lda vera_heap_allocate.return_1
    sta vera_heap_allocate.return
    // vera_heap_alloc::@6
    // heap_index = vera_heap_allocate(s, free_index, packed_size)
    // [115] vera_heap_alloc::heap_index#1 = vera_heap_allocate::return#0 -- vbum1=vbum2 
    sta heap_index
    // vera_heap_segment.freeSize[s] -= packed_size
    // [116] vera_heap_alloc::$8 = vera_heap_alloc::s#0 << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta vera_heap_alloc__8
    // [117] ((unsigned int *)&vera_heap_segment+$5e)[vera_heap_alloc::$8] = ((unsigned int *)&vera_heap_segment+$5e)[vera_heap_alloc::$8] - vera_heap_alloc::packed_size#0 -- pwuc1_derefidx_vbum1=pwuc1_derefidx_vbum1_minus_vwum2 
    tay
    lda vera_heap_segment+$5e,y
    sec
    sbc packed_size
    sta vera_heap_segment+$5e,y
    lda vera_heap_segment+$5e+1,y
    sbc packed_size+1
    sta vera_heap_segment+$5e+1,y
    // vera_heap_segment.heapSize[s] += packed_size
    // [118] ((unsigned int *)&vera_heap_segment+$56)[vera_heap_alloc::$8] = ((unsigned int *)&vera_heap_segment+$56)[vera_heap_alloc::$8] + vera_heap_alloc::packed_size#0 -- pwuc1_derefidx_vbum1=pwuc1_derefidx_vbum1_plus_vwum2 
    lda vera_heap_segment+$56,y
    clc
    adc packed_size
    sta vera_heap_segment+$56,y
    lda vera_heap_segment+$56+1,y
    adc packed_size+1
    sta vera_heap_segment+$56+1,y
    // [106] phi from vera_heap_alloc::@6 to vera_heap_alloc::bank_pull_bram1 [phi:vera_heap_alloc::@6->vera_heap_alloc::bank_pull_bram1]
    // [106] phi vera_heap_alloc::return#0 = vera_heap_alloc::heap_index#1 [phi:vera_heap_alloc::@6->vera_heap_alloc::bank_pull_bram1#0] -- register_copy 
    jmp bank_pull_bram1
    vera_heap_alloc__8: .byte 0
  .segment Data
    s: .byte 0
    size: .dword 0
    bank_set_bram1_bank: .byte 0
  .segment CodeVeraHeap
    packed_size: .word 0
    free_index: .byte 0
    .label heap_index = return
  .segment Data
    return: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_segment_init
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
// char vera_heap_segment_init(__mem() char s, __mem() char vram_bank_floor, __mem() unsigned int vram_offset_floor, __mem() char vram_bank_ceil, __mem() unsigned int vram_offset_ceil)
vera_heap_segment_init: {
    .const OFFSET_STACK_S = 6
    .const OFFSET_STACK_VRAM_BANK_FLOOR = 5
    .const OFFSET_STACK_VRAM_OFFSET_FLOOR = 3
    .const OFFSET_STACK_VRAM_BANK_CEIL = 2
    .const OFFSET_STACK_VRAM_OFFSET_CEIL = 0
    .const OFFSET_STACK_RETURN_6 = 6
    // [119] vera_heap_segment_init::s#0 = stackidx(char,vera_heap_segment_init::OFFSET_STACK_S) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_S,x
    sta s
    // [120] vera_heap_segment_init::vram_bank_floor#0 = stackidx(char,vera_heap_segment_init::OFFSET_STACK_VRAM_BANK_FLOOR) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_VRAM_BANK_FLOOR,x
    sta vram_bank_floor
    // [121] vera_heap_segment_init::vram_offset_floor#0 = stackidx(unsigned int,vera_heap_segment_init::OFFSET_STACK_VRAM_OFFSET_FLOOR) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_VRAM_OFFSET_FLOOR,x
    sta vram_offset_floor
    lda STACK_BASE+OFFSET_STACK_VRAM_OFFSET_FLOOR+1,x
    sta vram_offset_floor+1
    // [122] vera_heap_segment_init::vram_bank_ceil#0 = stackidx(char,vera_heap_segment_init::OFFSET_STACK_VRAM_BANK_CEIL) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_VRAM_BANK_CEIL,x
    sta vram_bank_ceil
    // [123] vera_heap_segment_init::vram_offset_ceil#0 = stackidx(unsigned int,vera_heap_segment_init::OFFSET_STACK_VRAM_OFFSET_CEIL) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_VRAM_OFFSET_CEIL,x
    sta vram_offset_ceil
    lda STACK_BASE+OFFSET_STACK_VRAM_OFFSET_CEIL+1,x
    sta vram_offset_ceil+1
    // vera_heap_segment.vram_bank_floor[s] = vram_bank_floor
    // [124] ((char *)&vera_heap_segment+2)[vera_heap_segment_init::s#0] = vera_heap_segment_init::vram_bank_floor#0 -- pbuc1_derefidx_vbum1=vbum2 
    // TODO initialize segment to all zero
    lda vram_bank_floor
    ldy s
    sta vera_heap_segment+2,y
    // vera_heap_segment.vram_offset_floor[s] = vram_offset_floor
    // [125] vera_heap_segment_init::$16 = vera_heap_segment_init::s#0 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta vera_heap_segment_init__16
    // [126] ((unsigned int *)&vera_heap_segment+6)[vera_heap_segment_init::$16] = vera_heap_segment_init::vram_offset_floor#0 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda vram_offset_floor
    sta vera_heap_segment+6,y
    lda vram_offset_floor+1
    sta vera_heap_segment+6+1,y
    // vera_heap_segment.vram_bank_ceil[s] = vram_bank_ceil
    // [127] ((char *)&vera_heap_segment+$16)[vera_heap_segment_init::s#0] = vera_heap_segment_init::vram_bank_ceil#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda vram_bank_ceil
    ldy s
    sta vera_heap_segment+$16,y
    // vera_heap_segment.vram_offset_ceil[s] = vram_offset_ceil
    // [128] ((unsigned int *)&vera_heap_segment+$1a)[vera_heap_segment_init::$16] = vera_heap_segment_init::vram_offset_ceil#0 -- pwuc1_derefidx_vbum1=vwum2 
    ldy vera_heap_segment_init__16
    lda vram_offset_ceil
    sta vera_heap_segment+$1a,y
    lda vram_offset_ceil+1
    sta vera_heap_segment+$1a+1,y
    // vera_heap_data_pack(vram_bank_floor, vram_offset_floor)
    // [129] vera_heap_data_pack::vram_bank#0 = vera_heap_segment_init::vram_bank_floor#0 -- vbum1=vbum2 
    lda vram_bank_floor
    sta vera_heap_data_pack.vram_bank
    // [130] vera_heap_data_pack::vram_offset#0 = vera_heap_segment_init::vram_offset_floor#0 -- vwum1=vwum2 
    lda vram_offset_floor
    sta vera_heap_data_pack.vram_offset
    lda vram_offset_floor+1
    sta vera_heap_data_pack.vram_offset+1
    // [131] call vera_heap_data_pack
    // [341] phi from vera_heap_segment_init to vera_heap_data_pack [phi:vera_heap_segment_init->vera_heap_data_pack]
    // [341] phi vera_heap_data_pack::vram_offset#2 = vera_heap_data_pack::vram_offset#0 [phi:vera_heap_segment_init->vera_heap_data_pack#0] -- register_copy 
    // [341] phi vera_heap_data_pack::vram_bank#2 = vera_heap_data_pack::vram_bank#0 [phi:vera_heap_segment_init->vera_heap_data_pack#1] -- call_phi_near 
    jsr vera_heap_data_pack
    // vera_heap_data_pack(vram_bank_floor, vram_offset_floor)
    // [132] vera_heap_data_pack::return#0 = vera_heap_data_pack::return#2 -- vwum1=vwum2 
    lda vera_heap_data_pack.return_2
    sta vera_heap_data_pack.return
    lda vera_heap_data_pack.return_2+1
    sta vera_heap_data_pack.return+1
    // vera_heap_segment_init::@4
    // [133] vera_heap_segment_init::$0 = vera_heap_data_pack::return#0 -- vwum1=vwum2 
    lda vera_heap_data_pack.return
    sta vera_heap_segment_init__0
    lda vera_heap_data_pack.return+1
    sta vera_heap_segment_init__0+1
    // vera_heap_segment.floor[s] = vera_heap_data_pack(vram_bank_floor, vram_offset_floor)
    // [134] ((unsigned int *)&vera_heap_segment+$e)[vera_heap_segment_init::$16] = vera_heap_segment_init::$0 -- pwuc1_derefidx_vbum1=vwum2 
    ldy vera_heap_segment_init__16
    lda vera_heap_segment_init__0
    sta vera_heap_segment+$e,y
    lda vera_heap_segment_init__0+1
    sta vera_heap_segment+$e+1,y
    // vera_heap_data_pack(vram_bank_ceil, vram_offset_ceil)
    // [135] vera_heap_data_pack::vram_bank#1 = vera_heap_segment_init::vram_bank_ceil#0 -- vbum1=vbum2 
    lda vram_bank_ceil
    sta vera_heap_data_pack.vram_bank
    // [136] vera_heap_data_pack::vram_offset#1 = vera_heap_segment_init::vram_offset_ceil#0 -- vwum1=vwum2 
    lda vram_offset_ceil
    sta vera_heap_data_pack.vram_offset
    lda vram_offset_ceil+1
    sta vera_heap_data_pack.vram_offset+1
    // [137] call vera_heap_data_pack
    // [341] phi from vera_heap_segment_init::@4 to vera_heap_data_pack [phi:vera_heap_segment_init::@4->vera_heap_data_pack]
    // [341] phi vera_heap_data_pack::vram_offset#2 = vera_heap_data_pack::vram_offset#1 [phi:vera_heap_segment_init::@4->vera_heap_data_pack#0] -- register_copy 
    // [341] phi vera_heap_data_pack::vram_bank#2 = vera_heap_data_pack::vram_bank#1 [phi:vera_heap_segment_init::@4->vera_heap_data_pack#1] -- call_phi_near 
    jsr vera_heap_data_pack
    // vera_heap_data_pack(vram_bank_ceil, vram_offset_ceil)
    // [138] vera_heap_data_pack::return#1 = vera_heap_data_pack::return#2 -- vwum1=vwum2 
    lda vera_heap_data_pack.return_2
    sta vera_heap_data_pack.return_1
    lda vera_heap_data_pack.return_2+1
    sta vera_heap_data_pack.return_1+1
    // vera_heap_segment_init::@5
    // [139] vera_heap_segment_init::$1 = vera_heap_data_pack::return#1 -- vwum1=vwum2 
    lda vera_heap_data_pack.return_1
    sta vera_heap_segment_init__1
    lda vera_heap_data_pack.return_1+1
    sta vera_heap_segment_init__1+1
    // vera_heap_segment.ceil[s]  = vera_heap_data_pack(vram_bank_ceil, vram_offset_ceil)
    // [140] ((unsigned int *)&vera_heap_segment+$22)[vera_heap_segment_init::$16] = vera_heap_segment_init::$1 -- pwuc1_derefidx_vbum1=vwum2 
    ldy vera_heap_segment_init__16
    lda vera_heap_segment_init__1
    sta vera_heap_segment+$22,y
    lda vera_heap_segment_init__1+1
    sta vera_heap_segment+$22+1,y
    // vera_heap_segment.heap_offset[s] = 0
    // [141] ((unsigned int *)&vera_heap_segment+$36)[vera_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta vera_heap_segment+$36,y
    sta vera_heap_segment+$36+1,y
    // vera_heap_size_packed_t free_size = vera_heap_segment.ceil[s]
    // [142] vera_heap_segment_init::free_size#0 = ((unsigned int *)&vera_heap_segment+$22)[vera_heap_segment_init::$16] -- vwum1=pwuc1_derefidx_vbum2 
    lda vera_heap_segment+$22,y
    sta free_size
    lda vera_heap_segment+$22+1,y
    sta free_size+1
    // free_size -= vera_heap_segment.floor[s]
    // [143] vera_heap_segment_init::free_size#1 = vera_heap_segment_init::free_size#0 - ((unsigned int *)&vera_heap_segment+$e)[vera_heap_segment_init::$16] -- vwum1=vwum2_minus_pwuc1_derefidx_vbum3 
    lda free_size
    sec
    sbc vera_heap_segment+$e,y
    sta free_size_1
    lda free_size+1
    sbc vera_heap_segment+$e+1,y
    sta free_size_1+1
    // vera_heap_segment.heapCount[s] = 0
    // [144] ((unsigned int *)&vera_heap_segment+$3e)[vera_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta vera_heap_segment+$3e,y
    sta vera_heap_segment+$3e+1,y
    // vera_heap_segment.freeCount[s] = 0
    // [145] ((unsigned int *)&vera_heap_segment+$46)[vera_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    sta vera_heap_segment+$46,y
    sta vera_heap_segment+$46+1,y
    // vera_heap_segment.idleCount[s] = 0
    // [146] ((unsigned int *)&vera_heap_segment+$4e)[vera_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    sta vera_heap_segment+$4e,y
    sta vera_heap_segment+$4e+1,y
    // vera_heap_segment.heap_list[s] = VERAHEAP_NULL
    // [147] ((char *)&vera_heap_segment+$2a)[vera_heap_segment_init::s#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    lda #$ff
    ldy s
    sta vera_heap_segment+$2a,y
    // vera_heap_segment.idle_list[s] = VERAHEAP_NULL
    // [148] ((char *)&vera_heap_segment+$32)[vera_heap_segment_init::s#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta vera_heap_segment+$32,y
    // vera_heap_segment.free_list[s] = VERAHEAP_NULL
    // [149] ((char *)&vera_heap_segment+$2e)[vera_heap_segment_init::s#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta vera_heap_segment+$2e,y
    // vera_heap_segment_init::bank_get_bram1
    // return BRAM;
    // [150] vera_heap_segment_init::bank_old#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_old
    // vera_heap_segment_init::@1
    // bank_set_bram(vera_heap_segment.bram_bank)
    // [151] vera_heap_segment_init::bank_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbum1=_deref_pbuc1 
    lda vera_heap_segment
    sta bank_set_bram1_bank
    // vera_heap_segment_init::bank_set_bram1
    // BRAM = bank
    // [152] BRAM = vera_heap_segment_init::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // vera_heap_segment_init::@2
    // vera_heap_index_t free_index = vera_heap_index_add(s)
    // [153] vera_heap_index_add::s#0 = vera_heap_segment_init::s#0 -- vbum1=vbum2 
    tya
    sta vera_heap_index_add.s
    // [154] call vera_heap_index_add
    // [347] phi from vera_heap_segment_init::@2 to vera_heap_index_add [phi:vera_heap_segment_init::@2->vera_heap_index_add]
    // [347] phi vera_heap_index_add::s#2 = vera_heap_index_add::s#0 [phi:vera_heap_segment_init::@2->vera_heap_index_add#0] -- call_phi_near 
    jsr vera_heap_index_add
    // vera_heap_index_t free_index = vera_heap_index_add(s)
    // [155] vera_heap_index_add::return#0 = vera_heap_index_add::return#1 -- vbum1=vbum2 
    lda vera_heap_index_add.return_1
    sta vera_heap_index_add.return
    // vera_heap_segment_init::@6
    // [156] vera_heap_segment_init::free_index#0 = vera_heap_index_add::return#0 -- vbum1=vbum2 
    sta free_index
    // vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, free_index)
    // [157] vera_heap_list_insert_at::list#0 = ((char *)&vera_heap_segment+$2e)[vera_heap_segment_init::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda vera_heap_segment+$2e,y
    sta vera_heap_list_insert_at.list
    // [158] vera_heap_list_insert_at::index#0 = vera_heap_segment_init::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_list_insert_at.index
    // [159] vera_heap_list_insert_at::at#0 = vera_heap_segment_init::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_list_insert_at.at
    // [160] call vera_heap_list_insert_at
    // [357] phi from vera_heap_segment_init::@6 to vera_heap_list_insert_at [phi:vera_heap_segment_init::@6->vera_heap_list_insert_at]
    // [357] phi vera_heap_list_insert_at::index#10 = vera_heap_list_insert_at::index#0 [phi:vera_heap_segment_init::@6->vera_heap_list_insert_at#0] -- register_copy 
    // [357] phi vera_heap_list_insert_at::at#11 = vera_heap_list_insert_at::at#0 [phi:vera_heap_segment_init::@6->vera_heap_list_insert_at#1] -- register_copy 
    // [357] phi vera_heap_list_insert_at::list#5 = vera_heap_list_insert_at::list#0 [phi:vera_heap_segment_init::@6->vera_heap_list_insert_at#2] -- call_phi_near 
    jsr vera_heap_list_insert_at
    // vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, free_index)
    // [161] vera_heap_list_insert_at::return#0 = vera_heap_list_insert_at::list#11 -- vbum1=vbum2 
    lda vera_heap_list_insert_at.list
    sta vera_heap_list_insert_at.return
    // vera_heap_segment_init::@7
    // [162] vera_heap_segment_init::free_index#1 = vera_heap_list_insert_at::return#0 -- vbum1=vbum2 
    sta free_index_1
    // vera_heap_set_data_packed(s, free_index, vera_heap_segment.floor[s])
    // [163] vera_heap_set_data_packed::index#0 = vera_heap_segment_init::free_index#1 -- vbum1=vbum2 
    sta vera_heap_set_data_packed.index
    // [164] vera_heap_set_data_packed::data_packed#0 = ((unsigned int *)&vera_heap_segment+$e)[vera_heap_segment_init::$16] -- vwum1=pwuc1_derefidx_vbum2 
    ldy vera_heap_segment_init__16
    lda vera_heap_segment+$e,y
    sta vera_heap_set_data_packed.data_packed
    lda vera_heap_segment+$e+1,y
    sta vera_heap_set_data_packed.data_packed+1
    // [165] call vera_heap_set_data_packed
    // [372] phi from vera_heap_segment_init::@7 to vera_heap_set_data_packed [phi:vera_heap_segment_init::@7->vera_heap_set_data_packed]
    // [372] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#0 [phi:vera_heap_segment_init::@7->vera_heap_set_data_packed#0] -- register_copy 
    // [372] phi vera_heap_set_data_packed::data_packed#7 = vera_heap_set_data_packed::data_packed#0 [phi:vera_heap_segment_init::@7->vera_heap_set_data_packed#1] -- call_phi_near 
    jsr vera_heap_set_data_packed
    // vera_heap_segment_init::@8
    // vera_heap_set_size_packed(s, free_index, vera_heap_segment.ceil[s] - vera_heap_segment.floor[s])
    // [166] vera_heap_set_size_packed::size_packed#0 = ((unsigned int *)&vera_heap_segment+$22)[vera_heap_segment_init::$16] - ((unsigned int *)&vera_heap_segment+$e)[vera_heap_segment_init::$16] -- vwum1=pwuc1_derefidx_vbum2_minus_pwuc2_derefidx_vbum2 
    ldy vera_heap_segment_init__16
    lda vera_heap_segment+$22,y
    sec
    sbc vera_heap_segment+$e,y
    sta vera_heap_set_size_packed.size_packed
    lda vera_heap_segment+$22+1,y
    sbc vera_heap_segment+$e+1,y
    sta vera_heap_set_size_packed.size_packed+1
    // [167] vera_heap_set_size_packed::index#0 = vera_heap_segment_init::free_index#1 -- vbum1=vbum2 
    lda free_index_1
    sta vera_heap_set_size_packed.index
    // [168] call vera_heap_set_size_packed
    // [378] phi from vera_heap_segment_init::@8 to vera_heap_set_size_packed [phi:vera_heap_segment_init::@8->vera_heap_set_size_packed]
    // [378] phi vera_heap_set_size_packed::size_packed#6 = vera_heap_set_size_packed::size_packed#0 [phi:vera_heap_segment_init::@8->vera_heap_set_size_packed#0] -- register_copy 
    // [378] phi vera_heap_set_size_packed::index#6 = vera_heap_set_size_packed::index#0 [phi:vera_heap_segment_init::@8->vera_heap_set_size_packed#1] -- call_phi_near 
    jsr vera_heap_set_size_packed
    // vera_heap_segment_init::@9
    // vera_heap_set_free(s, free_index)
    // [169] vera_heap_set_free::index#0 = vera_heap_segment_init::free_index#1 -- vbum1=vbum2 
    lda free_index_1
    sta vera_heap_set_free.index
    // [170] call vera_heap_set_free
    // [387] phi from vera_heap_segment_init::@9 to vera_heap_set_free [phi:vera_heap_segment_init::@9->vera_heap_set_free]
    // [387] phi vera_heap_set_free::index#5 = vera_heap_set_free::index#0 [phi:vera_heap_segment_init::@9->vera_heap_set_free#0] -- call_phi_near 
    jsr vera_heap_set_free
    // vera_heap_segment_init::vera_heap_set_next1
    // vera_heap_index.next[index] = next
    // [171] ((char *)&vera_heap_index+$400)[vera_heap_segment_init::free_index#1] = vera_heap_segment_init::free_index#1 -- pbuc1_derefidx_vbum1=vbum1 
    ldy free_index_1
    tya
    sta vera_heap_index+$400,y
    // vera_heap_segment_init::vera_heap_set_prev1
    // vera_heap_index.prev[index] = prev
    // [172] ((char *)&vera_heap_index+$500)[vera_heap_segment_init::free_index#1] = vera_heap_segment_init::free_index#1 -- pbuc1_derefidx_vbum1=vbum1 
    tya
    sta vera_heap_index+$500,y
    // vera_heap_segment_init::@3
    // vera_heap_segment.freeCount[s]++;
    // [173] ((unsigned int *)&vera_heap_segment+$46)[vera_heap_segment_init::$16] = ++ ((unsigned int *)&vera_heap_segment+$46)[vera_heap_segment_init::$16] -- pwuc1_derefidx_vbum1=_inc_pwuc1_derefidx_vbum1 
    ldx vera_heap_segment_init__16
    inc vera_heap_segment+$46,x
    bne !+
    inc vera_heap_segment+$46+1,x
  !:
    // vera_heap_segment.free_list[s] = free_index
    // [174] ((char *)&vera_heap_segment+$2e)[vera_heap_segment_init::s#0] = vera_heap_segment_init::free_index#1 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_index_1
    ldy s
    sta vera_heap_segment+$2e,y
    // vera_heap_segment.freeSize[s] = free_size
    // [175] ((unsigned int *)&vera_heap_segment+$5e)[vera_heap_segment_init::$16] = vera_heap_segment_init::free_size#1 -- pwuc1_derefidx_vbum1=vwum2 
    ldy vera_heap_segment_init__16
    lda free_size_1
    sta vera_heap_segment+$5e,y
    lda free_size_1+1
    sta vera_heap_segment+$5e+1,y
    // vera_heap_segment.heapSize[s] = 0
    // [176] ((unsigned int *)&vera_heap_segment+$56)[vera_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta vera_heap_segment+$56,y
    sta vera_heap_segment+$56+1,y
    // vera_heap_segment_init::bank_set_bram2
    // BRAM = bank
    // [177] BRAM = vera_heap_segment_init::bank_old#0 -- vbuz1=vbum2 
    lda bank_old
    sta.z BRAM
    // vera_heap_segment_init::@return
    // }
    // [178] stackidx(char,vera_heap_segment_init::OFFSET_STACK_RETURN_6) = vera_heap_segment_init::s#0 -- _stackidxbyte_vbuc1=vbum1 
    lda s
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_6,x
    // [179] return 
    rts
    vera_heap_segment_init__0: .word 0
    vera_heap_segment_init__1: .word 0
    vera_heap_segment_init__16: .byte 0
  .segment Data
    s: .byte 0
    vram_bank_floor: .byte 0
    vram_offset_floor: .word 0
    vram_bank_ceil: .byte 0
    vram_offset_ceil: .word 0
  .segment CodeVeraHeap
    free_size: .word 0
    free_size_1: .word 0
    bank_old: .byte 0
  .segment Data
    bank_set_bram1_bank: .byte 0
  .segment CodeVeraHeap
    free_index: .byte 0
    free_index_1: .byte 0
}
  // vera_heap_bram_bank_init
// void vera_heap_bram_bank_init(__mem() char bram_bank)
vera_heap_bram_bank_init: {
    .const OFFSET_STACK_BRAM_BANK = 0
    // [180] vera_heap_bram_bank_init::bram_bank#0 = stackidx(char,vera_heap_bram_bank_init::OFFSET_STACK_BRAM_BANK) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_BANK,x
    sta bram_bank
    // vera_heap_segment.bram_bank = bram_bank
    // [181] *((char *)&vera_heap_segment) = vera_heap_bram_bank_init::bram_bank#0 -- _deref_pbuc1=vbum1 
    sta vera_heap_segment
    // vera_heap_segment.index_position = 0
    // [182] *((char *)&vera_heap_segment+1) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta vera_heap_segment+1
    // vera_heap_bram_bank_init::@return
    // }
    // [183] return 
    rts
  .segment Data
    bram_bank: .byte 0
}
.segment Code
  // main
main: {
    // main::@return
    // [185] return 
    rts
}
.segment CodeVeraHeap
  // vera_heap_alloc_size_get
/**
 * Returns total allocation size, aligned to 8;
 */
/* inline */
// __mem() unsigned int vera_heap_alloc_size_get(__mem() unsigned long size)
vera_heap_alloc_size_get: {
    // vera_heap_size_pack(size-1)
    // [187] vera_heap_size_pack::size#0 = vera_heap_alloc_size_get::size#2 - 1 -- vdum1=vdum2_minus_1 
    sec
    lda size
    sbc #1
    sta vera_heap_size_pack.size
    lda size+1
    sbc #0
    sta vera_heap_size_pack.size+1
    lda size+2
    sbc #0
    sta vera_heap_size_pack.size+2
    lda size+3
    sbc #0
    sta vera_heap_size_pack.size+3
    // [188] call vera_heap_size_pack -- call_phi_near 
    jsr vera_heap_size_pack
    // [189] vera_heap_size_pack::return#2 = vera_heap_size_pack::return#0 -- vwum1=vwum2 
    lda vera_heap_size_pack.return
    sta vera_heap_size_pack.return_1
    lda vera_heap_size_pack.return+1
    sta vera_heap_size_pack.return_1+1
    // vera_heap_alloc_size_get::@1
    // [190] vera_heap_alloc_size_get::$1 = vera_heap_size_pack::return#2 -- vwum1=vwum2 
    lda vera_heap_size_pack.return_1
    sta vera_heap_alloc_size_get__1
    lda vera_heap_size_pack.return_1+1
    sta vera_heap_alloc_size_get__1+1
    // return (vera_heap_size_packed_t)((vera_heap_size_pack(size-1) + 1));
    // [191] vera_heap_alloc_size_get::return#2 = vera_heap_alloc_size_get::$1 + 1 -- vwum1=vwum2_plus_1 
    clc
    lda vera_heap_alloc_size_get__1
    adc #1
    sta return_2
    lda vera_heap_alloc_size_get__1+1
    adc #0
    sta return_2+1
    // vera_heap_alloc_size_get::@return
    // }
    // [192] return 
    rts
    vera_heap_alloc_size_get__1: .word 0
  .segment Data
    size: .dword 0
    return: .word 0
    return_1: .word 0
    return_2: .word 0
}
.segment CodeVeraHeap
  // vera_heap_find_best_fit
/**
 * Best-fit algorithm.
 */
// __mem() char vera_heap_find_best_fit(__mem() char s, __mem() unsigned int requested_size)
vera_heap_find_best_fit: {
    // vera_heap_index_t free_index = vera_heap_segment.free_list[s]
    // [194] vera_heap_find_best_fit::free_index#0 = ((char *)&vera_heap_segment+$2e)[vera_heap_find_best_fit::s#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda vera_heap_segment+$2e,y
    sta free_index
    // if(free_index == VERAHEAP_NULL)
    // [195] if(vera_heap_find_best_fit::free_index#0!=$ff) goto vera_heap_find_best_fit::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp free_index
    bne __b1
    // [196] phi from vera_heap_find_best_fit vera_heap_find_best_fit::@2 to vera_heap_find_best_fit::@return [phi:vera_heap_find_best_fit/vera_heap_find_best_fit::@2->vera_heap_find_best_fit::@return]
  __b5:
    // [196] phi vera_heap_find_best_fit::return#3 = $ff [phi:vera_heap_find_best_fit/vera_heap_find_best_fit::@2->vera_heap_find_best_fit::@return#0] -- vbum1=vbuc1 
    lda #$ff
    sta return_2
    // vera_heap_find_best_fit::@return
    // }
    // [197] return 
    rts
    // vera_heap_find_best_fit::@1
  __b1:
    // vera_heap_index_t free_end = vera_heap_segment.free_list[s]
    // [198] vera_heap_find_best_fit::free_end#0 = ((char *)&vera_heap_segment+$2e)[vera_heap_find_best_fit::s#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda vera_heap_segment+$2e,y
    sta free_end
    // [199] phi from vera_heap_find_best_fit::@1 to vera_heap_find_best_fit::@3 [phi:vera_heap_find_best_fit::@1->vera_heap_find_best_fit::@3]
    // [199] phi vera_heap_find_best_fit::best_index#8 = $ff [phi:vera_heap_find_best_fit::@1->vera_heap_find_best_fit::@3#0] -- vbum1=vbuc1 
    lda #$ff
    sta best_index
    // [199] phi vera_heap_find_best_fit::best_size#2 = $ffff [phi:vera_heap_find_best_fit::@1->vera_heap_find_best_fit::@3#1] -- vwum1=vwuc1 
    lda #<$ffff
    sta best_size
    lda #>$ffff
    sta best_size+1
    // [199] phi vera_heap_find_best_fit::free_index#2 = vera_heap_find_best_fit::free_index#0 [phi:vera_heap_find_best_fit::@1->vera_heap_find_best_fit::@3#2] -- register_copy 
    // vera_heap_find_best_fit::@3
  __b3:
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [200] vera_heap_get_size_packed::index#4 = vera_heap_find_best_fit::free_index#2 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_get_size_packed.index
    // [201] call vera_heap_get_size_packed
  // O(n) search.
    // [217] phi from vera_heap_find_best_fit::@3 to vera_heap_get_size_packed [phi:vera_heap_find_best_fit::@3->vera_heap_get_size_packed]
    // [217] phi vera_heap_get_size_packed::index#7 = vera_heap_get_size_packed::index#4 [phi:vera_heap_find_best_fit::@3->vera_heap_get_size_packed#0] -- call_phi_near 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [202] vera_heap_get_size_packed::return#13 = vera_heap_get_size_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_size_packed.return_1
    sta vera_heap_get_size_packed.return_4
    lda vera_heap_get_size_packed.return_1+1
    sta vera_heap_get_size_packed.return_4+1
    // vera_heap_find_best_fit::@8
    // [203] vera_heap_find_best_fit::free_size#0 = vera_heap_get_size_packed::return#13 -- vwum1=vwum2 
    lda vera_heap_get_size_packed.return_4
    sta free_size
    lda vera_heap_get_size_packed.return_4+1
    sta free_size+1
    // if(free_size >= requested_size && free_size < best_size)
    // [204] if(vera_heap_find_best_fit::free_size#0<vera_heap_find_best_fit::requested_size#6) goto vera_heap_find_best_fit::@11 -- vwum1_lt_vwum2_then_la1 
    cmp requested_size+1
    bcc __b11
    bne !+
    lda free_size
    cmp requested_size
    bcc __b11
  !:
    // vera_heap_find_best_fit::@9
    // [205] if(vera_heap_find_best_fit::free_size#0>=vera_heap_find_best_fit::best_size#2) goto vera_heap_find_best_fit::@4 -- vwum1_ge_vwum2_then_la1 
    lda best_size+1
    cmp free_size+1
    bne !+
    lda best_size
    cmp free_size
    beq __b4
  !:
    bcc __b4
    // vera_heap_find_best_fit::@5
    // [206] vera_heap_find_best_fit::best_index#12 = vera_heap_find_best_fit::free_index#2 -- vbum1=vbum2 
    lda free_index
    sta best_index
    // [207] phi from vera_heap_find_best_fit::@11 vera_heap_find_best_fit::@5 to vera_heap_find_best_fit::@4 [phi:vera_heap_find_best_fit::@11/vera_heap_find_best_fit::@5->vera_heap_find_best_fit::@4]
    // [207] phi vera_heap_find_best_fit::best_index#2 = vera_heap_find_best_fit::best_index#8 [phi:vera_heap_find_best_fit::@11/vera_heap_find_best_fit::@5->vera_heap_find_best_fit::@4#0] -- register_copy 
    // [207] phi vera_heap_find_best_fit::best_size#3 = vera_heap_find_best_fit::best_size#10 [phi:vera_heap_find_best_fit::@11/vera_heap_find_best_fit::@5->vera_heap_find_best_fit::@4#1] -- register_copy 
    // [207] phi from vera_heap_find_best_fit::@9 to vera_heap_find_best_fit::@4 [phi:vera_heap_find_best_fit::@9->vera_heap_find_best_fit::@4]
    // vera_heap_find_best_fit::@4
  __b4:
    // vera_heap_find_best_fit::vera_heap_get_next1
    // return vera_heap_index.next[index];
    // [208] vera_heap_find_best_fit::vera_heap_get_next1_return#0 = ((char *)&vera_heap_index+$400)[vera_heap_find_best_fit::free_index#2] -- vbum1=pbuc1_derefidx_vbum1 
    ldy vera_heap_get_next1_return
    lda vera_heap_index+$400,y
    sta vera_heap_get_next1_return
    // vera_heap_find_best_fit::@7
    // while(free_index != free_end)
    // [209] if(vera_heap_find_best_fit::vera_heap_get_next1_return#0!=vera_heap_find_best_fit::free_end#0) goto vera_heap_find_best_fit::@10 -- vbum1_neq_vbum2_then_la1 
    cmp free_end
    bne __b10
    // vera_heap_find_best_fit::@6
    // if(requested_size <= best_size)
    // [210] if(vera_heap_find_best_fit::requested_size#6>vera_heap_find_best_fit::best_size#3) goto vera_heap_find_best_fit::@2 -- vwum1_gt_vwum2_then_la1 
    lda best_size_1+1
    cmp requested_size+1
    bcc __b5
    bne !+
    lda best_size_1
    cmp requested_size
    bcs !__b5+
    jmp __b5
  !__b5:
  !:
    // [196] phi from vera_heap_find_best_fit::@6 to vera_heap_find_best_fit::@return [phi:vera_heap_find_best_fit::@6->vera_heap_find_best_fit::@return]
    // [196] phi vera_heap_find_best_fit::return#3 = vera_heap_find_best_fit::best_index#2 [phi:vera_heap_find_best_fit::@6->vera_heap_find_best_fit::@return#0] -- register_copy 
    rts
    // [211] phi from vera_heap_find_best_fit::@6 to vera_heap_find_best_fit::@2 [phi:vera_heap_find_best_fit::@6->vera_heap_find_best_fit::@2]
    // vera_heap_find_best_fit::@2
    // vera_heap_find_best_fit::@10
  __b10:
    // [212] vera_heap_find_best_fit::best_size#9 = vera_heap_find_best_fit::best_size#3 -- vwum1=vwum2 
    lda best_size_1
    sta best_size
    lda best_size_1+1
    sta best_size+1
    // [199] phi from vera_heap_find_best_fit::@10 to vera_heap_find_best_fit::@3 [phi:vera_heap_find_best_fit::@10->vera_heap_find_best_fit::@3]
    // [199] phi vera_heap_find_best_fit::best_index#8 = vera_heap_find_best_fit::best_index#2 [phi:vera_heap_find_best_fit::@10->vera_heap_find_best_fit::@3#0] -- register_copy 
    // [199] phi vera_heap_find_best_fit::best_size#2 = vera_heap_find_best_fit::best_size#9 [phi:vera_heap_find_best_fit::@10->vera_heap_find_best_fit::@3#1] -- register_copy 
    // [199] phi vera_heap_find_best_fit::free_index#2 = vera_heap_find_best_fit::vera_heap_get_next1_return#0 [phi:vera_heap_find_best_fit::@10->vera_heap_find_best_fit::@3#2] -- register_copy 
    jmp __b3
    // vera_heap_find_best_fit::@11
  __b11:
    // [213] vera_heap_find_best_fit::best_size#10 = vera_heap_find_best_fit::best_size#2 -- vwum1=vwum2 
    lda best_size
    sta best_size_1
    lda best_size+1
    sta best_size_1+1
    jmp __b4
  .segment Data
    s: .byte 0
    requested_size: .word 0
    return: .byte 0
    return_1: .byte 0
  .segment CodeVeraHeap
    free_index: .byte 0
    free_end: .byte 0
  .segment Data
    .label return_2 = best_index
  .segment CodeVeraHeap
    .label free_size = best_size_1
    .label vera_heap_get_next1_return = free_index
    best_size: .word 0
    best_size_1: .word 0
    best_index: .byte 0
}
  // vera_heap_get_data_packed
// __mem() unsigned int vera_heap_get_data_packed(char s, __mem() char index)
vera_heap_get_data_packed: {
    // MAKEWORD(vera_heap_index.data1[index],vera_heap_index.data0[index])
    // [215] vera_heap_get_data_packed::return#1 = ((char *)&vera_heap_index+$100)[vera_heap_get_data_packed::index#9] w= ((char *)&vera_heap_index)[vera_heap_get_data_packed::index#9] -- vwum1=pbuc1_derefidx_vbum2_word_pbuc2_derefidx_vbum2 
    ldy index
    lda vera_heap_index+$100,y
    sta return_1+1
    lda vera_heap_index,y
    sta return_1
    // vera_heap_get_data_packed::@return
    // }
    // [216] return 
    rts
  .segment Data
    index: .byte 0
    return: .word 0
    return_1: .word 0
    return_2: .word 0
    return_3: .word 0
    return_4: .word 0
    return_5: .word 0
    return_6: .word 0
    return_7: .word 0
    return_8: .word 0
    return_9: .word 0
}
.segment CodeVeraHeap
  // vera_heap_get_size_packed
// __mem() unsigned int vera_heap_get_size_packed(char s, __mem() char index)
vera_heap_get_size_packed: {
    // vera_heap_index.size1[index] & 0x7F
    // [218] vera_heap_get_size_packed::$0 = ((char *)&vera_heap_index+$300)[vera_heap_get_size_packed::index#7] & $7f -- vbum1=pbuc1_derefidx_vbum2_band_vbuc2 
    lda #$7f
    ldy index
    and vera_heap_index+$300,y
    sta vera_heap_get_size_packed__0
    // MAKEWORD(vera_heap_index.size1[index] & 0x7F, vera_heap_index.size0[index])
    // [219] vera_heap_get_size_packed::return#1 = vera_heap_get_size_packed::$0 w= ((char *)&vera_heap_index+$200)[vera_heap_get_size_packed::index#7] -- vwum1=vbum2_word_pbuc1_derefidx_vbum3 
    sta return_1+1
    lda vera_heap_index+$200,y
    sta return_1
    // vera_heap_get_size_packed::@return
    // }
    // [220] return 
    rts
    vera_heap_get_size_packed__0: .byte 0
  .segment Data
    index: .byte 0
    return: .word 0
    return_1: .word 0
    return_2: .word 0
    return_3: .word 0
    return_4: .word 0
    return_5: .word 0
    return_6: .word 0
}
.segment CodeVeraHeap
  // vera_heap_heap_remove
// void vera_heap_heap_remove(__mem() char s, __mem() char heap_index)
vera_heap_heap_remove: {
    // vera_heap_segment.heapCount[s]--;
    // [221] vera_heap_heap_remove::$3 = vera_heap_heap_remove::s#0 << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta vera_heap_heap_remove__3
    // [222] ((unsigned int *)&vera_heap_segment+$3e)[vera_heap_heap_remove::$3] = -- ((unsigned int *)&vera_heap_segment+$3e)[vera_heap_heap_remove::$3] -- pwuc1_derefidx_vbum1=_dec_pwuc1_derefidx_vbum1 
    tax
    lda vera_heap_segment+$3e,x
    bne !+
    dec vera_heap_segment+$3e+1,x
  !:
    dec vera_heap_segment+$3e,x
    // vera_heap_list_remove(s, vera_heap_segment.heap_list[s], heap_index)
    // [223] vera_heap_list_remove::list#2 = ((char *)&vera_heap_segment+$2a)[vera_heap_heap_remove::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda vera_heap_segment+$2a,y
    sta vera_heap_list_remove.list
    // [224] vera_heap_list_remove::index#0 = vera_heap_heap_remove::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta vera_heap_list_remove.index
    // [225] call vera_heap_list_remove
    // [397] phi from vera_heap_heap_remove to vera_heap_list_remove [phi:vera_heap_heap_remove->vera_heap_list_remove]
    // [397] phi vera_heap_list_remove::index#10 = vera_heap_list_remove::index#0 [phi:vera_heap_heap_remove->vera_heap_list_remove#0] -- register_copy 
    // [397] phi vera_heap_list_remove::list#10 = vera_heap_list_remove::list#2 [phi:vera_heap_heap_remove->vera_heap_list_remove#1] -- call_phi_near 
    jsr vera_heap_list_remove
    // vera_heap_list_remove(s, vera_heap_segment.heap_list[s], heap_index)
    // [226] vera_heap_list_remove::return#4 = vera_heap_list_remove::return#1 -- vbum1=vbum2 
    lda vera_heap_list_remove.return
    sta vera_heap_list_remove.return_1
    // vera_heap_heap_remove::@1
    // [227] vera_heap_heap_remove::$1 = vera_heap_list_remove::return#4 -- vbum1=vbum2 
    sta vera_heap_heap_remove__1
    // vera_heap_segment.heap_list[s] = vera_heap_list_remove(s, vera_heap_segment.heap_list[s], heap_index)
    // [228] ((char *)&vera_heap_segment+$2a)[vera_heap_heap_remove::s#0] = vera_heap_heap_remove::$1 -- pbuc1_derefidx_vbum1=vbum2 
    ldy s
    sta vera_heap_segment+$2a,y
    // vera_heap_heap_remove::@return
    // }
    // [229] return 
    rts
    vera_heap_heap_remove__1: .byte 0
    vera_heap_heap_remove__3: .byte 0
  .segment Data
    s: .byte 0
    heap_index: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_free_insert
// char vera_heap_free_insert(__mem() char s, __mem() char free_index, __mem() unsigned int data, __mem() unsigned int size)
vera_heap_free_insert: {
    // vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, vera_heap_segment.free_list[s])
    // [230] vera_heap_list_insert_at::list#3 = ((char *)&vera_heap_segment+$2e)[vera_heap_free_insert::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda vera_heap_segment+$2e,y
    sta vera_heap_list_insert_at.list
    // [231] vera_heap_list_insert_at::index#2 = vera_heap_free_insert::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_list_insert_at.index
    // [232] vera_heap_list_insert_at::at#3 = ((char *)&vera_heap_segment+$2e)[vera_heap_free_insert::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda vera_heap_segment+$2e,y
    sta vera_heap_list_insert_at.at
    // [233] call vera_heap_list_insert_at
    // [357] phi from vera_heap_free_insert to vera_heap_list_insert_at [phi:vera_heap_free_insert->vera_heap_list_insert_at]
    // [357] phi vera_heap_list_insert_at::index#10 = vera_heap_list_insert_at::index#2 [phi:vera_heap_free_insert->vera_heap_list_insert_at#0] -- register_copy 
    // [357] phi vera_heap_list_insert_at::at#11 = vera_heap_list_insert_at::at#3 [phi:vera_heap_free_insert->vera_heap_list_insert_at#1] -- register_copy 
    // [357] phi vera_heap_list_insert_at::list#5 = vera_heap_list_insert_at::list#3 [phi:vera_heap_free_insert->vera_heap_list_insert_at#2] -- call_phi_near 
    jsr vera_heap_list_insert_at
    // vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, vera_heap_segment.free_list[s])
    // [234] vera_heap_list_insert_at::return#4 = vera_heap_list_insert_at::list#11 -- vbum1=vbum2 
    lda vera_heap_list_insert_at.list
    sta vera_heap_list_insert_at.return_2
    // vera_heap_free_insert::@1
    // [235] vera_heap_free_insert::$0 = vera_heap_list_insert_at::return#4 -- vbum1=vbum2 
    sta vera_heap_free_insert__0
    // vera_heap_segment.free_list[s] = vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, vera_heap_segment.free_list[s])
    // [236] ((char *)&vera_heap_segment+$2e)[vera_heap_free_insert::s#0] = vera_heap_free_insert::$0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy s
    sta vera_heap_segment+$2e,y
    // vera_heap_set_data_packed(s, free_index, data)
    // [237] vera_heap_set_data_packed::index#1 = vera_heap_free_insert::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_set_data_packed.index
    // [238] vera_heap_set_data_packed::data_packed#1 = vera_heap_free_insert::data#0 -- vwum1=vwum2 
    lda data
    sta vera_heap_set_data_packed.data_packed
    lda data+1
    sta vera_heap_set_data_packed.data_packed+1
    // [239] call vera_heap_set_data_packed
    // [372] phi from vera_heap_free_insert::@1 to vera_heap_set_data_packed [phi:vera_heap_free_insert::@1->vera_heap_set_data_packed]
    // [372] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#1 [phi:vera_heap_free_insert::@1->vera_heap_set_data_packed#0] -- register_copy 
    // [372] phi vera_heap_set_data_packed::data_packed#7 = vera_heap_set_data_packed::data_packed#1 [phi:vera_heap_free_insert::@1->vera_heap_set_data_packed#1] -- call_phi_near 
    jsr vera_heap_set_data_packed
    // vera_heap_free_insert::@2
    // vera_heap_set_size_packed(s, free_index, size)
    // [240] vera_heap_set_size_packed::index#2 = vera_heap_free_insert::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_set_size_packed.index
    // [241] vera_heap_set_size_packed::size_packed#2 = vera_heap_free_insert::size#0 -- vwum1=vwum2 
    lda size
    sta vera_heap_set_size_packed.size_packed
    lda size+1
    sta vera_heap_set_size_packed.size_packed+1
    // [242] call vera_heap_set_size_packed
    // [378] phi from vera_heap_free_insert::@2 to vera_heap_set_size_packed [phi:vera_heap_free_insert::@2->vera_heap_set_size_packed]
    // [378] phi vera_heap_set_size_packed::size_packed#6 = vera_heap_set_size_packed::size_packed#2 [phi:vera_heap_free_insert::@2->vera_heap_set_size_packed#0] -- register_copy 
    // [378] phi vera_heap_set_size_packed::index#6 = vera_heap_set_size_packed::index#2 [phi:vera_heap_free_insert::@2->vera_heap_set_size_packed#1] -- call_phi_near 
    jsr vera_heap_set_size_packed
    // vera_heap_free_insert::@3
    // vera_heap_set_free(s, free_index)
    // [243] vera_heap_set_free::index#1 = vera_heap_free_insert::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_set_free.index
    // [244] call vera_heap_set_free
    // [387] phi from vera_heap_free_insert::@3 to vera_heap_set_free [phi:vera_heap_free_insert::@3->vera_heap_set_free]
    // [387] phi vera_heap_set_free::index#5 = vera_heap_set_free::index#1 [phi:vera_heap_free_insert::@3->vera_heap_set_free#0] -- call_phi_near 
    jsr vera_heap_set_free
    // vera_heap_free_insert::@4
    // vera_heap_segment.freeCount[s]++;
    // [245] vera_heap_free_insert::$6 = vera_heap_free_insert::s#0 << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta vera_heap_free_insert__6
    // [246] ((unsigned int *)&vera_heap_segment+$46)[vera_heap_free_insert::$6] = ++ ((unsigned int *)&vera_heap_segment+$46)[vera_heap_free_insert::$6] -- pwuc1_derefidx_vbum1=_inc_pwuc1_derefidx_vbum1 
    tax
    inc vera_heap_segment+$46,x
    bne !+
    inc vera_heap_segment+$46+1,x
  !:
    // vera_heap_free_insert::@return
    // }
    // [247] return 
    rts
    vera_heap_free_insert__0: .byte 0
    vera_heap_free_insert__6: .byte 0
  .segment Data
    s: .byte 0
    free_index: .byte 0
    data: .word 0
    size: .word 0
}
.segment CodeVeraHeap
  // vera_heap_can_coalesce_left
/**
 * Whether we should merge this header to the left.
 */
// __mem() char vera_heap_can_coalesce_left(char s, __mem() char heap_index)
vera_heap_can_coalesce_left: {
    // vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(s, heap_index)
    // [248] vera_heap_get_data_packed::index#4 = vera_heap_can_coalesce_left::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta vera_heap_get_data_packed.index
    // [249] call vera_heap_get_data_packed
    // [214] phi from vera_heap_can_coalesce_left to vera_heap_get_data_packed [phi:vera_heap_can_coalesce_left->vera_heap_get_data_packed]
    // [214] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#4 [phi:vera_heap_can_coalesce_left->vera_heap_get_data_packed#0] -- call_phi_near 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(s, heap_index)
    // [250] vera_heap_get_data_packed::return#16 = vera_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_1
    sta vera_heap_get_data_packed.return_6
    lda vera_heap_get_data_packed.return_1+1
    sta vera_heap_get_data_packed.return_6+1
    // vera_heap_can_coalesce_left::@3
    // [251] vera_heap_can_coalesce_left::heap_offset#0 = vera_heap_get_data_packed::return#16 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_6
    sta heap_offset
    lda vera_heap_get_data_packed.return_6+1
    sta heap_offset+1
    // vera_heap_can_coalesce_left::vera_heap_get_left1
    // return vera_heap_index.left[index];
    // [252] vera_heap_can_coalesce_left::vera_heap_get_left1_return#0 = ((char *)&vera_heap_index+$700)[vera_heap_can_coalesce_left::heap_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy heap_index
    lda vera_heap_index+$700,y
    sta vera_heap_get_left1_return
    // vera_heap_can_coalesce_left::@2
    // vera_heap_data_packed_t left_offset = vera_heap_get_data_packed(s, left_index)
    // [253] vera_heap_get_data_packed::index#5 = vera_heap_can_coalesce_left::vera_heap_get_left1_return#0 -- vbum1=vbum2 
    sta vera_heap_get_data_packed.index
    // [254] call vera_heap_get_data_packed
    // [214] phi from vera_heap_can_coalesce_left::@2 to vera_heap_get_data_packed [phi:vera_heap_can_coalesce_left::@2->vera_heap_get_data_packed]
    // [214] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#5 [phi:vera_heap_can_coalesce_left::@2->vera_heap_get_data_packed#0] -- call_phi_near 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t left_offset = vera_heap_get_data_packed(s, left_index)
    // [255] vera_heap_get_data_packed::return#17 = vera_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_1
    sta vera_heap_get_data_packed.return_7
    lda vera_heap_get_data_packed.return_1+1
    sta vera_heap_get_data_packed.return_7+1
    // vera_heap_can_coalesce_left::@4
    // [256] vera_heap_can_coalesce_left::left_offset#0 = vera_heap_get_data_packed::return#17 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_7
    sta left_offset
    lda vera_heap_get_data_packed.return_7+1
    sta left_offset+1
    // bool left_free = vera_heap_is_free(s, left_index)
    // [257] vera_heap_is_free::index#0 = vera_heap_can_coalesce_left::vera_heap_get_left1_return#0 -- vbum1=vbum2 
    lda vera_heap_get_left1_return
    sta vera_heap_is_free.index
    // [258] call vera_heap_is_free
    // [412] phi from vera_heap_can_coalesce_left::@4 to vera_heap_is_free [phi:vera_heap_can_coalesce_left::@4->vera_heap_is_free]
    // [412] phi vera_heap_is_free::index#2 = vera_heap_is_free::index#0 [phi:vera_heap_can_coalesce_left::@4->vera_heap_is_free#0] -- call_phi_near 
    jsr vera_heap_is_free
    // bool left_free = vera_heap_is_free(s, left_index)
    // [259] vera_heap_is_free::return#2 = vera_heap_is_free::return#0 -- vbom1=vbom2 
    lda vera_heap_is_free.return
    sta vera_heap_is_free.return_1
    // vera_heap_can_coalesce_left::@5
    // [260] vera_heap_can_coalesce_left::left_free#0 = vera_heap_is_free::return#2 -- vbom1=vbom2 
    sta left_free
    // if(left_free && (left_offset < heap_offset))
    // [261] if(vera_heap_can_coalesce_left::left_free#0) goto vera_heap_can_coalesce_left::@6 -- vbom1_then_la1 
    cmp #0
    bne __b6
    // [264] phi from vera_heap_can_coalesce_left::@5 vera_heap_can_coalesce_left::@6 to vera_heap_can_coalesce_left::@return [phi:vera_heap_can_coalesce_left::@5/vera_heap_can_coalesce_left::@6->vera_heap_can_coalesce_left::@return]
  __b2:
    // [264] phi vera_heap_can_coalesce_left::return#3 = $ff [phi:vera_heap_can_coalesce_left::@5/vera_heap_can_coalesce_left::@6->vera_heap_can_coalesce_left::@return#0] -- vbum1=vbuc1 
    lda #$ff
    sta return_1
    rts
    // vera_heap_can_coalesce_left::@6
  __b6:
    // if(left_free && (left_offset < heap_offset))
    // [262] if(vera_heap_can_coalesce_left::left_offset#0<vera_heap_can_coalesce_left::heap_offset#0) goto vera_heap_can_coalesce_left::@1 -- vwum1_lt_vwum2_then_la1 
    lda left_offset+1
    cmp heap_offset+1
    bcc __b1
    bne !+
    lda left_offset
    cmp heap_offset
    bcc __b1
  !:
    jmp __b2
    // [263] phi from vera_heap_can_coalesce_left::@6 to vera_heap_can_coalesce_left::@1 [phi:vera_heap_can_coalesce_left::@6->vera_heap_can_coalesce_left::@1]
    // vera_heap_can_coalesce_left::@1
  __b1:
    // [264] phi from vera_heap_can_coalesce_left::@1 to vera_heap_can_coalesce_left::@return [phi:vera_heap_can_coalesce_left::@1->vera_heap_can_coalesce_left::@return]
    // [264] phi vera_heap_can_coalesce_left::return#3 = vera_heap_can_coalesce_left::vera_heap_get_left1_return#0 [phi:vera_heap_can_coalesce_left::@1->vera_heap_can_coalesce_left::@return#0] -- register_copy 
    // vera_heap_can_coalesce_left::@return
    // }
    // [265] return 
    rts
  .segment Data
    heap_index: .byte 0
    return: .byte 0
  .segment CodeVeraHeap
    heap_offset: .word 0
    .label vera_heap_get_left1_return = return_1
    left_offset: .word 0
    left_free: .byte 0
  .segment Data
    return_1: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_coalesce
/**
 * Coalesces two adjacent blocks to the left.
 * The left is a free index and the right is the heap index to be freed.
 * The free index remains free, and the heap to the right stays heap.
 * The free index is returned as the new remaining (free) block.
 */
// __mem() char vera_heap_coalesce(__mem() char s, __mem() char left_index, __mem() char right_index)
vera_heap_coalesce: {
    .const vera_heap_set_left3_left = $ff
    .const vera_heap_set_right3_right = $ff
    // vera_heap_size_packed_t right_size = vera_heap_get_size_packed(s, right_index)
    // [267] vera_heap_get_size_packed::index#5 = vera_heap_coalesce::right_index#10 -- vbum1=vbum2 
    lda right_index
    sta vera_heap_get_size_packed.index
    // [268] call vera_heap_get_size_packed
    // [217] phi from vera_heap_coalesce to vera_heap_get_size_packed [phi:vera_heap_coalesce->vera_heap_get_size_packed]
    // [217] phi vera_heap_get_size_packed::index#7 = vera_heap_get_size_packed::index#5 [phi:vera_heap_coalesce->vera_heap_get_size_packed#0] -- call_phi_near 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t right_size = vera_heap_get_size_packed(s, right_index)
    // [269] vera_heap_get_size_packed::return#14 = vera_heap_get_size_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_size_packed.return_1
    sta vera_heap_get_size_packed.return_5
    lda vera_heap_get_size_packed.return_1+1
    sta vera_heap_get_size_packed.return_5+1
    // vera_heap_coalesce::@3
    // [270] vera_heap_coalesce::right_size#0 = vera_heap_get_size_packed::return#14 -- vwum1=vwum2 
    lda vera_heap_get_size_packed.return_5
    sta right_size
    lda vera_heap_get_size_packed.return_5+1
    sta right_size+1
    // vera_heap_size_packed_t left_size = vera_heap_get_size_packed(s, left_index)
    // [271] vera_heap_get_size_packed::index#6 = vera_heap_coalesce::left_index#10 -- vbum1=vbum2 
    lda left_index
    sta vera_heap_get_size_packed.index
    // [272] call vera_heap_get_size_packed
    // [217] phi from vera_heap_coalesce::@3 to vera_heap_get_size_packed [phi:vera_heap_coalesce::@3->vera_heap_get_size_packed]
    // [217] phi vera_heap_get_size_packed::index#7 = vera_heap_get_size_packed::index#6 [phi:vera_heap_coalesce::@3->vera_heap_get_size_packed#0] -- call_phi_near 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t left_size = vera_heap_get_size_packed(s, left_index)
    // [273] vera_heap_get_size_packed::return#15 = vera_heap_get_size_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_size_packed.return_1
    sta vera_heap_get_size_packed.return_6
    lda vera_heap_get_size_packed.return_1+1
    sta vera_heap_get_size_packed.return_6+1
    // vera_heap_coalesce::@4
    // [274] vera_heap_coalesce::left_size#0 = vera_heap_get_size_packed::return#15 -- vwum1=vwum2 
    lda vera_heap_get_size_packed.return_6
    sta left_size
    lda vera_heap_get_size_packed.return_6+1
    sta left_size+1
    // vera_heap_data_packed_t left_offset = vera_heap_get_data_packed(s, left_index)
    // [275] vera_heap_get_data_packed::index#8 = vera_heap_coalesce::left_index#10 -- vbum1=vbum2 
    lda left_index
    sta vera_heap_get_data_packed.index
    // [276] call vera_heap_get_data_packed
    // [214] phi from vera_heap_coalesce::@4 to vera_heap_get_data_packed [phi:vera_heap_coalesce::@4->vera_heap_get_data_packed]
    // [214] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#8 [phi:vera_heap_coalesce::@4->vera_heap_get_data_packed#0] -- call_phi_near 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t left_offset = vera_heap_get_data_packed(s, left_index)
    // [277] vera_heap_get_data_packed::return#10 = vera_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_1
    sta vera_heap_get_data_packed.return_2
    lda vera_heap_get_data_packed.return_1+1
    sta vera_heap_get_data_packed.return_2+1
    // vera_heap_coalesce::@5
    // [278] vera_heap_coalesce::left_offset#0 = vera_heap_get_data_packed::return#10 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_2
    sta left_offset
    lda vera_heap_get_data_packed.return_2+1
    sta left_offset+1
    // vera_heap_coalesce::vera_heap_get_left1
    // return vera_heap_index.left[index];
    // [279] vera_heap_coalesce::free_left#0 = ((char *)&vera_heap_index+$700)[vera_heap_coalesce::left_index#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy left_index
    lda vera_heap_index+$700,y
    sta free_left
    // vera_heap_coalesce::vera_heap_get_right1
    // return vera_heap_index.right[index];
    // [280] vera_heap_coalesce::free_right#0 = ((char *)&vera_heap_index+$600)[vera_heap_coalesce::right_index#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy right_index
    lda vera_heap_index+$600,y
    sta free_right
    // vera_heap_coalesce::@1
    // vera_heap_free_remove(s, left_index)
    // [281] vera_heap_free_remove::s#1 = vera_heap_coalesce::s#10 -- vbum1=vbum2 
    lda s
    sta vera_heap_free_remove.s
    // [282] vera_heap_free_remove::free_index#1 = vera_heap_coalesce::left_index#10 -- vbum1=vbum2 
    lda left_index
    sta vera_heap_free_remove.free_index
    // [283] call vera_heap_free_remove
  // We detach the left index from the free list and add it to the idle list.
    // [416] phi from vera_heap_coalesce::@1 to vera_heap_free_remove [phi:vera_heap_coalesce::@1->vera_heap_free_remove]
    // [416] phi vera_heap_free_remove::free_index#2 = vera_heap_free_remove::free_index#1 [phi:vera_heap_coalesce::@1->vera_heap_free_remove#0] -- register_copy 
    // [416] phi vera_heap_free_remove::s#2 = vera_heap_free_remove::s#1 [phi:vera_heap_coalesce::@1->vera_heap_free_remove#1] -- call_phi_near 
    jsr vera_heap_free_remove
    // vera_heap_coalesce::@6
    // vera_heap_idle_insert(s, left_index)
    // [284] vera_heap_idle_insert::s#0 = vera_heap_coalesce::s#10 -- vbum1=vbum2 
    lda s
    sta vera_heap_idle_insert.s
    // [285] vera_heap_idle_insert::idle_index#0 = vera_heap_coalesce::left_index#10 -- vbum1=vbum2 
    lda left_index
    sta vera_heap_idle_insert.idle_index
    // [286] call vera_heap_idle_insert -- call_phi_near 
    jsr vera_heap_idle_insert
    // vera_heap_coalesce::vera_heap_set_left1
    // vera_heap_index.left[index] = left
    // [287] ((char *)&vera_heap_index+$700)[vera_heap_coalesce::right_index#10] = vera_heap_coalesce::free_left#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_left
    ldy right_index
    sta vera_heap_index+$700,y
    // vera_heap_coalesce::vera_heap_set_right1
    // vera_heap_index.right[index] = right
    // [288] ((char *)&vera_heap_index+$600)[vera_heap_coalesce::right_index#10] = vera_heap_coalesce::free_right#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_right
    sta vera_heap_index+$600,y
    // vera_heap_coalesce::vera_heap_set_left2
    // vera_heap_index.left[index] = left
    // [289] ((char *)&vera_heap_index+$700)[vera_heap_coalesce::free_right#0] = vera_heap_coalesce::right_index#10 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy free_right
    sta vera_heap_index+$700,y
    // vera_heap_coalesce::vera_heap_set_right2
    // vera_heap_index.right[index] = right
    // [290] ((char *)&vera_heap_index+$600)[vera_heap_coalesce::free_left#0] = vera_heap_coalesce::right_index#10 -- pbuc1_derefidx_vbum1=vbum2 
    ldy free_left
    sta vera_heap_index+$600,y
    // vera_heap_coalesce::vera_heap_set_left3
    // vera_heap_index.left[index] = left
    // [291] ((char *)&vera_heap_index+$700)[vera_heap_coalesce::left_index#10] = vera_heap_coalesce::vera_heap_set_left3_left#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #vera_heap_set_left3_left
    ldy left_index
    sta vera_heap_index+$700,y
    // vera_heap_coalesce::vera_heap_set_right3
    // vera_heap_index.right[index] = right
    // [292] ((char *)&vera_heap_index+$600)[vera_heap_coalesce::left_index#10] = vera_heap_coalesce::vera_heap_set_right3_right#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #vera_heap_set_right3_right
    sta vera_heap_index+$600,y
    // vera_heap_coalesce::@2
    // vera_heap_set_size_packed(s, right_index, left_size + right_size)
    // [293] vera_heap_set_size_packed::size_packed#5 = vera_heap_coalesce::left_size#0 + vera_heap_coalesce::right_size#0 -- vwum1=vwum2_plus_vwum3 
    lda left_size
    clc
    adc right_size
    sta vera_heap_set_size_packed.size_packed
    lda left_size+1
    adc right_size+1
    sta vera_heap_set_size_packed.size_packed+1
    // [294] vera_heap_set_size_packed::index#5 = vera_heap_coalesce::right_index#10 -- vbum1=vbum2 
    lda right_index
    sta vera_heap_set_size_packed.index
    // [295] call vera_heap_set_size_packed
    // [378] phi from vera_heap_coalesce::@2 to vera_heap_set_size_packed [phi:vera_heap_coalesce::@2->vera_heap_set_size_packed]
    // [378] phi vera_heap_set_size_packed::size_packed#6 = vera_heap_set_size_packed::size_packed#5 [phi:vera_heap_coalesce::@2->vera_heap_set_size_packed#0] -- register_copy 
    // [378] phi vera_heap_set_size_packed::index#6 = vera_heap_set_size_packed::index#5 [phi:vera_heap_coalesce::@2->vera_heap_set_size_packed#1] -- call_phi_near 
    jsr vera_heap_set_size_packed
    // vera_heap_coalesce::@7
    // vera_heap_set_data_packed(s, right_index, left_offset)
    // [296] vera_heap_set_data_packed::index#6 = vera_heap_coalesce::right_index#10 -- vbum1=vbum2 
    lda right_index
    sta vera_heap_set_data_packed.index
    // [297] vera_heap_set_data_packed::data_packed#6 = vera_heap_coalesce::left_offset#0 -- vwum1=vwum2 
    lda left_offset
    sta vera_heap_set_data_packed.data_packed
    lda left_offset+1
    sta vera_heap_set_data_packed.data_packed+1
    // [298] call vera_heap_set_data_packed
    // [372] phi from vera_heap_coalesce::@7 to vera_heap_set_data_packed [phi:vera_heap_coalesce::@7->vera_heap_set_data_packed]
    // [372] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#6 [phi:vera_heap_coalesce::@7->vera_heap_set_data_packed#0] -- register_copy 
    // [372] phi vera_heap_set_data_packed::data_packed#7 = vera_heap_set_data_packed::data_packed#6 [phi:vera_heap_coalesce::@7->vera_heap_set_data_packed#1] -- call_phi_near 
    jsr vera_heap_set_data_packed
    // vera_heap_coalesce::@8
    // vera_heap_set_free(s, left_index)
    // [299] vera_heap_set_free::index#3 = vera_heap_coalesce::left_index#10 -- vbum1=vbum2 
    lda left_index
    sta vera_heap_set_free.index
    // [300] call vera_heap_set_free
    // [387] phi from vera_heap_coalesce::@8 to vera_heap_set_free [phi:vera_heap_coalesce::@8->vera_heap_set_free]
    // [387] phi vera_heap_set_free::index#5 = vera_heap_set_free::index#3 [phi:vera_heap_coalesce::@8->vera_heap_set_free#0] -- call_phi_near 
    jsr vera_heap_set_free
    // vera_heap_coalesce::@9
    // vera_heap_set_free(s, right_index)
    // [301] vera_heap_set_free::index#4 = vera_heap_coalesce::right_index#10 -- vbum1=vbum2 
    lda right_index
    sta vera_heap_set_free.index
    // [302] call vera_heap_set_free
    // [387] phi from vera_heap_coalesce::@9 to vera_heap_set_free [phi:vera_heap_coalesce::@9->vera_heap_set_free]
    // [387] phi vera_heap_set_free::index#5 = vera_heap_set_free::index#4 [phi:vera_heap_coalesce::@9->vera_heap_set_free#0] -- call_phi_near 
    jsr vera_heap_set_free
    // vera_heap_coalesce::@return
    // }
    // [303] return 
    rts
  .segment Data
    s: .byte 0
    left_index: .byte 0
    right_index: .byte 0
    return: .byte 0
  .segment CodeVeraHeap
    right_size: .word 0
    left_size: .word 0
    left_offset: .word 0
    free_left: .byte 0
    free_right: .byte 0
}
  // heap_can_coalesce_right
/**
 * Whether we should merge this header to the right.
 */
// __mem() char heap_can_coalesce_right(char s, __mem() char heap_index)
heap_can_coalesce_right: {
    // vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(s, heap_index)
    // [304] vera_heap_get_data_packed::index#6 = heap_can_coalesce_right::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta vera_heap_get_data_packed.index
    // [305] call vera_heap_get_data_packed
    // [214] phi from heap_can_coalesce_right to vera_heap_get_data_packed [phi:heap_can_coalesce_right->vera_heap_get_data_packed]
    // [214] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#6 [phi:heap_can_coalesce_right->vera_heap_get_data_packed#0] -- call_phi_near 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(s, heap_index)
    // [306] vera_heap_get_data_packed::return#18 = vera_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_1
    sta vera_heap_get_data_packed.return_8
    lda vera_heap_get_data_packed.return_1+1
    sta vera_heap_get_data_packed.return_8+1
    // heap_can_coalesce_right::@3
    // [307] heap_can_coalesce_right::heap_offset#0 = vera_heap_get_data_packed::return#18 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_8
    sta heap_offset
    lda vera_heap_get_data_packed.return_8+1
    sta heap_offset+1
    // heap_can_coalesce_right::vera_heap_get_right1
    // return vera_heap_index.right[index];
    // [308] heap_can_coalesce_right::vera_heap_get_right1_return#0 = ((char *)&vera_heap_index+$600)[heap_can_coalesce_right::heap_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy heap_index
    lda vera_heap_index+$600,y
    sta vera_heap_get_right1_return
    // heap_can_coalesce_right::@2
    // vera_heap_data_packed_t right_offset = vera_heap_get_data_packed(s, right_index)
    // [309] vera_heap_get_data_packed::index#7 = heap_can_coalesce_right::vera_heap_get_right1_return#0 -- vbum1=vbum2 
    sta vera_heap_get_data_packed.index
    // [310] call vera_heap_get_data_packed
    // [214] phi from heap_can_coalesce_right::@2 to vera_heap_get_data_packed [phi:heap_can_coalesce_right::@2->vera_heap_get_data_packed]
    // [214] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#7 [phi:heap_can_coalesce_right::@2->vera_heap_get_data_packed#0] -- call_phi_near 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t right_offset = vera_heap_get_data_packed(s, right_index)
    // [311] vera_heap_get_data_packed::return#19 = vera_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_1
    sta vera_heap_get_data_packed.return_9
    lda vera_heap_get_data_packed.return_1+1
    sta vera_heap_get_data_packed.return_9+1
    // heap_can_coalesce_right::@4
    // [312] heap_can_coalesce_right::right_offset#0 = vera_heap_get_data_packed::return#19 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_9
    sta right_offset
    lda vera_heap_get_data_packed.return_9+1
    sta right_offset+1
    // bool right_free = vera_heap_is_free(s, right_index)
    // [313] vera_heap_is_free::index#1 = heap_can_coalesce_right::vera_heap_get_right1_return#0 -- vbum1=vbum2 
    lda vera_heap_get_right1_return
    sta vera_heap_is_free.index
    // [314] call vera_heap_is_free
    // [412] phi from heap_can_coalesce_right::@4 to vera_heap_is_free [phi:heap_can_coalesce_right::@4->vera_heap_is_free]
    // [412] phi vera_heap_is_free::index#2 = vera_heap_is_free::index#1 [phi:heap_can_coalesce_right::@4->vera_heap_is_free#0] -- call_phi_near 
    jsr vera_heap_is_free
    // bool right_free = vera_heap_is_free(s, right_index)
    // [315] vera_heap_is_free::return#3 = vera_heap_is_free::return#0 -- vbom1=vbom2 
    lda vera_heap_is_free.return
    sta vera_heap_is_free.return_2
    // heap_can_coalesce_right::@5
    // [316] heap_can_coalesce_right::right_free#0 = vera_heap_is_free::return#3 -- vbom1=vbom2 
    sta right_free
    // if(right_free && (heap_offset < right_offset))
    // [317] if(heap_can_coalesce_right::right_free#0) goto heap_can_coalesce_right::@6 -- vbom1_then_la1 
    cmp #0
    bne __b6
    // [320] phi from heap_can_coalesce_right::@5 heap_can_coalesce_right::@6 to heap_can_coalesce_right::@return [phi:heap_can_coalesce_right::@5/heap_can_coalesce_right::@6->heap_can_coalesce_right::@return]
  __b2:
    // [320] phi heap_can_coalesce_right::return#3 = $ff [phi:heap_can_coalesce_right::@5/heap_can_coalesce_right::@6->heap_can_coalesce_right::@return#0] -- vbum1=vbuc1 
    lda #$ff
    sta return_1
    rts
    // heap_can_coalesce_right::@6
  __b6:
    // if(right_free && (heap_offset < right_offset))
    // [318] if(heap_can_coalesce_right::heap_offset#0<heap_can_coalesce_right::right_offset#0) goto heap_can_coalesce_right::@1 -- vwum1_lt_vwum2_then_la1 
    lda heap_offset+1
    cmp right_offset+1
    bcc __b1
    bne !+
    lda heap_offset
    cmp right_offset
    bcc __b1
  !:
    jmp __b2
    // [319] phi from heap_can_coalesce_right::@6 to heap_can_coalesce_right::@1 [phi:heap_can_coalesce_right::@6->heap_can_coalesce_right::@1]
    // heap_can_coalesce_right::@1
  __b1:
    // [320] phi from heap_can_coalesce_right::@1 to heap_can_coalesce_right::@return [phi:heap_can_coalesce_right::@1->heap_can_coalesce_right::@return]
    // [320] phi heap_can_coalesce_right::return#3 = heap_can_coalesce_right::vera_heap_get_right1_return#0 [phi:heap_can_coalesce_right::@1->heap_can_coalesce_right::@return#0] -- register_copy 
    // heap_can_coalesce_right::@return
    // }
    // [321] return 
    rts
  .segment Data
    heap_index: .byte 0
    // A free_index is not found, we cannot coalesce.
    return: .byte 0
  .segment CodeVeraHeap
    heap_offset: .word 0
    .label vera_heap_get_right1_return = return_1
    right_offset: .word 0
    right_free: .byte 0
  .segment Data
    // A free_index is not found, we cannot coalesce.
    return_1: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_allocate
/**
 * Allocates a header from the list, splitting if needed.
 */
// __mem() char vera_heap_allocate(__mem() char s, __mem() char free_index, __mem() unsigned int required_size)
vera_heap_allocate: {
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [322] vera_heap_get_size_packed::index#3 = vera_heap_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_get_size_packed.index
    // [323] call vera_heap_get_size_packed
    // [217] phi from vera_heap_allocate to vera_heap_get_size_packed [phi:vera_heap_allocate->vera_heap_get_size_packed]
    // [217] phi vera_heap_get_size_packed::index#7 = vera_heap_get_size_packed::index#3 [phi:vera_heap_allocate->vera_heap_get_size_packed#0] -- call_phi_near 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [324] vera_heap_get_size_packed::return#12 = vera_heap_get_size_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_size_packed.return_1
    sta vera_heap_get_size_packed.return_3
    lda vera_heap_get_size_packed.return_1+1
    sta vera_heap_get_size_packed.return_3+1
    // vera_heap_allocate::@4
    // [325] vera_heap_allocate::free_size#0 = vera_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda vera_heap_get_size_packed.return_3
    sta free_size
    lda vera_heap_get_size_packed.return_3+1
    sta free_size+1
    // if(free_size > required_size)
    // [326] if(vera_heap_allocate::free_size#0>vera_heap_allocate::required_size#0) goto vera_heap_allocate::@1 -- vwum1_gt_vwum2_then_la1 
    lda required_size+1
    cmp free_size+1
    bcc __b1
    bne !+
    lda required_size
    cmp free_size
    bcc __b1
  !:
    // vera_heap_allocate::@2
    // if(free_size == required_size)
    // [327] if(vera_heap_allocate::free_size#0==vera_heap_allocate::required_size#0) goto vera_heap_allocate::@3 -- vwum1_eq_vwum2_then_la1 
    lda free_size
    cmp required_size
    bne !+
    lda free_size+1
    cmp required_size+1
    beq __b3
  !:
    // [328] phi from vera_heap_allocate::@2 to vera_heap_allocate::@return [phi:vera_heap_allocate::@2->vera_heap_allocate::@return]
    // [328] phi vera_heap_allocate::return#4 = $ff [phi:vera_heap_allocate::@2->vera_heap_allocate::@return#0] -- vbum1=vbuc1 
    lda #$ff
    sta return_1
    // vera_heap_allocate::@return
    // }
    // [329] return 
    rts
    // vera_heap_allocate::@3
  __b3:
    // vera_heap_replace_free_with_heap(s, free_index, required_size)
    // [330] vera_heap_replace_free_with_heap::s#0 = vera_heap_allocate::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_replace_free_with_heap.s
    // [331] vera_heap_replace_free_with_heap::return#2 = vera_heap_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_replace_free_with_heap.return
    // [332] vera_heap_replace_free_with_heap::required_size#0 = vera_heap_allocate::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta vera_heap_replace_free_with_heap.required_size
    lda required_size+1
    sta vera_heap_replace_free_with_heap.required_size+1
    // [333] call vera_heap_replace_free_with_heap -- call_phi_near 
    jsr vera_heap_replace_free_with_heap
    // vera_heap_allocate::@6
    // return vera_heap_replace_free_with_heap(s, free_index, required_size);
    // [334] vera_heap_allocate::return#2 = vera_heap_replace_free_with_heap::return#2 -- vbum1=vbum2 
    lda vera_heap_replace_free_with_heap.return
    sta return_1
    // [328] phi from vera_heap_allocate::@5 vera_heap_allocate::@6 to vera_heap_allocate::@return [phi:vera_heap_allocate::@5/vera_heap_allocate::@6->vera_heap_allocate::@return]
    // [328] phi vera_heap_allocate::return#4 = vera_heap_allocate::return#1 [phi:vera_heap_allocate::@5/vera_heap_allocate::@6->vera_heap_allocate::@return#0] -- register_copy 
    rts
    // vera_heap_allocate::@1
  __b1:
    // vera_heap_split_free_and_allocate(s, free_index, required_size)
    // [335] vera_heap_split_free_and_allocate::s#0 = vera_heap_allocate::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_split_free_and_allocate.s
    // [336] vera_heap_split_free_and_allocate::free_index#0 = vera_heap_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_split_free_and_allocate.free_index
    // [337] vera_heap_split_free_and_allocate::required_size#0 = vera_heap_allocate::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta vera_heap_split_free_and_allocate.required_size
    lda required_size+1
    sta vera_heap_split_free_and_allocate.required_size+1
    // [338] call vera_heap_split_free_and_allocate -- call_phi_near 
    jsr vera_heap_split_free_and_allocate
    // [339] vera_heap_split_free_and_allocate::return#2 = vera_heap_split_free_and_allocate::heap_index#0 -- vbum1=vbum2 
    lda vera_heap_split_free_and_allocate.heap_index
    sta vera_heap_split_free_and_allocate.return
    // vera_heap_allocate::@5
    // return vera_heap_split_free_and_allocate(s, free_index, required_size);
    // [340] vera_heap_allocate::return#1 = vera_heap_split_free_and_allocate::return#2 -- vbum1=vbum2 
    sta return_1
    rts
  .segment Data
    s: .byte 0
    free_index: .byte 0
    required_size: .word 0
    return: .byte 0
  .segment CodeVeraHeap
    free_size: .word 0
  .segment Data
    return_1: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_data_pack
// __mem() unsigned int vera_heap_data_pack(__mem() char vram_bank, __mem() unsigned int vram_offset)
vera_heap_data_pack: {
    // vram_bank<<5
    // [342] vera_heap_data_pack::$0 = vera_heap_data_pack::vram_bank#2 << 5 -- vbum1=vbum2_rol_5 
    lda vram_bank
    asl
    asl
    asl
    asl
    asl
    sta vera_heap_data_pack__0
    // MAKEWORD(vram_bank<<5, 0)
    // [343] vera_heap_data_pack::$1 = vera_heap_data_pack::$0 w= 0 -- vwum1=vbum2_word_vbuc1 
    lda #0
    ldy vera_heap_data_pack__0
    sty vera_heap_data_pack__1+1
    sta vera_heap_data_pack__1
    // vram_offset>>3
    // [344] vera_heap_data_pack::$2 = vera_heap_data_pack::vram_offset#2 >> 3 -- vwum1=vwum2_ror_3 
    lda vram_offset+1
    lsr
    sta vera_heap_data_pack__2+1
    lda vram_offset
    ror
    sta vera_heap_data_pack__2
    lsr vera_heap_data_pack__2+1
    ror vera_heap_data_pack__2
    lsr vera_heap_data_pack__2+1
    ror vera_heap_data_pack__2
    // MAKEWORD(vram_bank<<5, 0) | (vram_offset>>3)
    // [345] vera_heap_data_pack::return#2 = vera_heap_data_pack::$1 | vera_heap_data_pack::$2 -- vwum1=vwum2_bor_vwum3 
    lda vera_heap_data_pack__1
    ora vera_heap_data_pack__2
    sta return_2
    tya
    ora vera_heap_data_pack__2+1
    sta return_2+1
    // vera_heap_data_pack::@return
    // }
    // [346] return 
    rts
    vera_heap_data_pack__0: .byte 0
    vera_heap_data_pack__1: .word 0
    vera_heap_data_pack__2: .word 0
  .segment Data
    vram_bank: .byte 0
    vram_offset: .word 0
    return: .word 0
    return_1: .word 0
    return_2: .word 0
}
.segment CodeVeraHeap
  // vera_heap_index_add
// __mem() char vera_heap_index_add(__mem() char s)
vera_heap_index_add: {
    // vera_heap_index_t index = vera_heap_segment.idle_list[s]
    // [348] vera_heap_index_add::index#0 = ((char *)&vera_heap_segment+$32)[vera_heap_index_add::s#2] -- vbum1=pbuc1_derefidx_vbum2 
    // TODO: Search idle list.
    ldy s
    lda vera_heap_segment+$32,y
    sta index
    // if(index != VERAHEAP_NULL)
    // [349] if(vera_heap_index_add::index#0!=$ff) goto vera_heap_index_add::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp index
    bne __b1
    // vera_heap_index_add::@3
    // index = vera_heap_segment.index_position
    // [350] vera_heap_index_add::index#1 = *((char *)&vera_heap_segment+1) -- vbum1=_deref_pbuc1 
    // The current header gets the current heap position handle.
    lda vera_heap_segment+1
    sta index
    // vera_heap_segment.index_position += 1
    // [351] *((char *)&vera_heap_segment+1) = *((char *)&vera_heap_segment+1) + 1 -- _deref_pbuc1=_deref_pbuc1_plus_1 
    // We adjust to the next index position.
    inc vera_heap_segment+1
    // [352] phi from vera_heap_index_add::@1 vera_heap_index_add::@3 to vera_heap_index_add::@2 [phi:vera_heap_index_add::@1/vera_heap_index_add::@3->vera_heap_index_add::@2]
    // [352] phi vera_heap_index_add::return#1 = vera_heap_index_add::index#0 [phi:vera_heap_index_add::@1/vera_heap_index_add::@3->vera_heap_index_add::@2#0] -- register_copy 
    // vera_heap_index_add::@2
    // vera_heap_index_add::@return
    // }
    // [353] return 
    rts
    // vera_heap_index_add::@1
  __b1:
    // heap_idle_remove(s, index)
    // [354] heap_idle_remove::s#0 = vera_heap_index_add::s#2 -- vbum1=vbum2 
    lda s
    sta heap_idle_remove.s
    // [355] heap_idle_remove::idle_index#0 = vera_heap_index_add::index#0 -- vbum1=vbum2 
    lda index
    sta heap_idle_remove.idle_index
    // [356] call heap_idle_remove -- call_phi_near 
    jsr heap_idle_remove
    rts
  .segment Data
    s: .byte 0
    return: .byte 0
  .segment CodeVeraHeap
    .label index = return_1
  .segment Data
    return_1: .byte 0
    return_2: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_list_insert_at
/**
* Insert index in list at sorted position.
*/
// __mem() char vera_heap_list_insert_at(char s, __mem() char list, __mem() char index, __mem() char at)
vera_heap_list_insert_at: {
    // if(list == VERAHEAP_NULL)
    // [358] if(vera_heap_list_insert_at::list#5!=$ff) goto vera_heap_list_insert_at::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp list
    bne __b1
    // vera_heap_list_insert_at::vera_heap_set_prev1
    // vera_heap_index.prev[index] = prev
    // [359] ((char *)&vera_heap_index+$500)[vera_heap_list_insert_at::index#10] = vera_heap_list_insert_at::index#10 -- pbuc1_derefidx_vbum1=vbum1 
    ldy index
    tya
    sta vera_heap_index+$500,y
    // vera_heap_list_insert_at::vera_heap_set_next1
    // vera_heap_index.next[index] = next
    // [360] ((char *)&vera_heap_index+$400)[vera_heap_list_insert_at::index#10] = vera_heap_list_insert_at::index#10 -- pbuc1_derefidx_vbum1=vbum1 
    tya
    sta vera_heap_index+$400,y
    // [361] vera_heap_list_insert_at::list#28 = vera_heap_list_insert_at::index#10 -- vbum1=vbum2 
    sta list
    // [362] phi from vera_heap_list_insert_at vera_heap_list_insert_at::vera_heap_set_next1 to vera_heap_list_insert_at::@1 [phi:vera_heap_list_insert_at/vera_heap_list_insert_at::vera_heap_set_next1->vera_heap_list_insert_at::@1]
    // [362] phi vera_heap_list_insert_at::list#11 = vera_heap_list_insert_at::list#5 [phi:vera_heap_list_insert_at/vera_heap_list_insert_at::vera_heap_set_next1->vera_heap_list_insert_at::@1#0] -- register_copy 
    // vera_heap_list_insert_at::@1
  __b1:
    // if(at == VERAHEAP_NULL)
    // [363] if(vera_heap_list_insert_at::at#11!=$ff) goto vera_heap_list_insert_at::@2 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp at
    bne __b2
    // vera_heap_list_insert_at::@3
    // [364] vera_heap_list_insert_at::first#8 = vera_heap_list_insert_at::list#11 -- vbum1=vbum2 
    lda list
    sta first
    // [365] phi from vera_heap_list_insert_at::@1 vera_heap_list_insert_at::@3 to vera_heap_list_insert_at::@2 [phi:vera_heap_list_insert_at::@1/vera_heap_list_insert_at::@3->vera_heap_list_insert_at::@2]
    // [365] phi vera_heap_list_insert_at::first#0 = vera_heap_list_insert_at::at#11 [phi:vera_heap_list_insert_at::@1/vera_heap_list_insert_at::@3->vera_heap_list_insert_at::@2#0] -- register_copy 
    // vera_heap_list_insert_at::@2
  __b2:
    // vera_heap_list_insert_at::vera_heap_get_prev1
    // return vera_heap_index.prev[index];
    // [366] vera_heap_list_insert_at::vera_heap_get_prev1_return#0 = ((char *)&vera_heap_index+$500)[vera_heap_list_insert_at::first#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy first
    lda vera_heap_index+$500,y
    sta vera_heap_get_prev1_return
    // vera_heap_list_insert_at::vera_heap_set_prev2
    // vera_heap_index.prev[index] = prev
    // [367] ((char *)&vera_heap_index+$500)[vera_heap_list_insert_at::index#10] = vera_heap_list_insert_at::vera_heap_get_prev1_return#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy index
    sta vera_heap_index+$500,y
    // vera_heap_list_insert_at::vera_heap_set_next2
    // vera_heap_index.next[index] = next
    // [368] ((char *)&vera_heap_index+$400)[vera_heap_list_insert_at::vera_heap_get_prev1_return#0] = vera_heap_list_insert_at::index#10 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy vera_heap_get_prev1_return
    sta vera_heap_index+$400,y
    // vera_heap_list_insert_at::vera_heap_set_next3
    // [369] ((char *)&vera_heap_index+$400)[vera_heap_list_insert_at::index#10] = vera_heap_list_insert_at::first#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda first
    ldy index
    sta vera_heap_index+$400,y
    // vera_heap_list_insert_at::vera_heap_set_prev3
    // vera_heap_index.prev[index] = prev
    // [370] ((char *)&vera_heap_index+$500)[vera_heap_list_insert_at::first#0] = vera_heap_list_insert_at::index#10 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy first
    sta vera_heap_index+$500,y
    // vera_heap_list_insert_at::@return
    // }
    // [371] return 
    rts
  .segment Data
    list: .byte 0
    index: .byte 0
    .label at = first
    return: .byte 0
    return_1: .byte 0
  .segment CodeVeraHeap
    vera_heap_get_prev1_return: .byte 0
    first: .byte 0
  .segment Data
    return_2: .byte 0
    return_3: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_set_data_packed
// void vera_heap_set_data_packed(char s, __mem() char index, __mem() unsigned int data_packed)
vera_heap_set_data_packed: {
    // BYTE1(data_packed)
    // [373] vera_heap_set_data_packed::$0 = byte1  vera_heap_set_data_packed::data_packed#7 -- vbum1=_byte1_vwum2 
    lda data_packed+1
    sta vera_heap_set_data_packed__0
    // vera_heap_index.data1[index] = BYTE1(data_packed)
    // [374] ((char *)&vera_heap_index+$100)[vera_heap_set_data_packed::index#7] = vera_heap_set_data_packed::$0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy index
    sta vera_heap_index+$100,y
    // BYTE0(data_packed)
    // [375] vera_heap_set_data_packed::$1 = byte0  vera_heap_set_data_packed::data_packed#7 -- vbum1=_byte0_vwum2 
    lda data_packed
    sta vera_heap_set_data_packed__1
    // vera_heap_index.data0[index] = BYTE0(data_packed)
    // [376] ((char *)&vera_heap_index)[vera_heap_set_data_packed::index#7] = vera_heap_set_data_packed::$1 -- pbuc1_derefidx_vbum1=vbum2 
    sta vera_heap_index,y
    // vera_heap_set_data_packed::@return
    // }
    // [377] return 
    rts
    vera_heap_set_data_packed__0: .byte 0
    vera_heap_set_data_packed__1: .byte 0
  .segment Data
    index: .byte 0
    data_packed: .word 0
}
.segment CodeVeraHeap
  // vera_heap_set_size_packed
// void vera_heap_set_size_packed(char s, __mem() char index, __mem() unsigned int size_packed)
vera_heap_set_size_packed: {
    // vera_heap_index.size1[index] & 0x80
    // [379] vera_heap_set_size_packed::$0 = ((char *)&vera_heap_index+$300)[vera_heap_set_size_packed::index#6] & $80 -- vbum1=pbuc1_derefidx_vbum2_band_vbuc2 
    lda #$80
    ldy index
    and vera_heap_index+$300,y
    sta vera_heap_set_size_packed__0
    // vera_heap_index.size1[index] &= vera_heap_index.size1[index] & 0x80
    // [380] ((char *)&vera_heap_index+$300)[vera_heap_set_size_packed::index#6] = ((char *)&vera_heap_index+$300)[vera_heap_set_size_packed::index#6] & vera_heap_set_size_packed::$0 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_band_vbum2 
    and vera_heap_index+$300,y
    sta vera_heap_index+$300,y
    // BYTE1(size_packed)
    // [381] vera_heap_set_size_packed::$1 = byte1  vera_heap_set_size_packed::size_packed#6 -- vbum1=_byte1_vwum2 
    lda size_packed+1
    sta vera_heap_set_size_packed__1
    // BYTE1(size_packed) & 0x7F
    // [382] vera_heap_set_size_packed::$2 = vera_heap_set_size_packed::$1 & $7f -- vbum1=vbum2_band_vbuc1 
    lda #$7f
    and vera_heap_set_size_packed__1
    sta vera_heap_set_size_packed__2
    // vera_heap_index.size1[index] = BYTE1(size_packed) & 0x7F
    // [383] ((char *)&vera_heap_index+$300)[vera_heap_set_size_packed::index#6] = vera_heap_set_size_packed::$2 -- pbuc1_derefidx_vbum1=vbum2 
    sta vera_heap_index+$300,y
    // BYTE0(size_packed)
    // [384] vera_heap_set_size_packed::$3 = byte0  vera_heap_set_size_packed::size_packed#6 -- vbum1=_byte0_vwum2 
    lda size_packed
    sta vera_heap_set_size_packed__3
    // vera_heap_index.size0[index] = BYTE0(size_packed)
    // [385] ((char *)&vera_heap_index+$200)[vera_heap_set_size_packed::index#6] = vera_heap_set_size_packed::$3 -- pbuc1_derefidx_vbum1=vbum2 
    // Ignore free flag.
    sta vera_heap_index+$200,y
    // vera_heap_set_size_packed::@return
    // }
    // [386] return 
    rts
    vera_heap_set_size_packed__0: .byte 0
    vera_heap_set_size_packed__1: .byte 0
    vera_heap_set_size_packed__2: .byte 0
    vera_heap_set_size_packed__3: .byte 0
  .segment Data
    index: .byte 0
    size_packed: .word 0
}
.segment CodeVeraHeap
  // vera_heap_set_free
// void vera_heap_set_free(char s, __mem() char index)
vera_heap_set_free: {
    // vera_heap_index.size1[index] |= 0x80
    // [388] ((char *)&vera_heap_index+$300)[vera_heap_set_free::index#5] = ((char *)&vera_heap_index+$300)[vera_heap_set_free::index#5] | $80 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_bor_vbuc2 
    lda #$80
    ldy index
    ora vera_heap_index+$300,y
    sta vera_heap_index+$300,y
    // vera_heap_set_free::@return
    // }
    // [389] return 
    rts
  .segment Data
    index: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_size_pack
// __mem() unsigned int vera_heap_size_pack(__mem() unsigned long size)
vera_heap_size_pack: {
    // BYTE2(size)
    // [390] vera_heap_size_pack::$0 = byte2  vera_heap_size_pack::size#0 -- vbum1=_byte2_vdum2 
    lda size+2
    sta vera_heap_size_pack__0
    // BYTE2(size)<<5
    // [391] vera_heap_size_pack::$1 = vera_heap_size_pack::$0 << 5 -- vbum1=vbum2_rol_5 
    asl
    asl
    asl
    asl
    asl
    sta vera_heap_size_pack__1
    // (vera_heap_size_packed_t)MAKEWORD(BYTE2(size)<<5, 0) | (WORD0(size) >> 3)
    // [392] vera_heap_size_pack::$6 = vera_heap_size_pack::$1 w= 0 -- vwum1=vbum2_word_vbuc1 
    lda #0
    ldy vera_heap_size_pack__1
    sty vera_heap_size_pack__6+1
    sta vera_heap_size_pack__6
    // WORD0(size)
    // [393] vera_heap_size_pack::$3 = word0  vera_heap_size_pack::size#0 -- vwum1=_word0_vdum2 
    lda size
    sta vera_heap_size_pack__3
    lda size+1
    sta vera_heap_size_pack__3+1
    // WORD0(size) >> 3
    // [394] vera_heap_size_pack::$4 = vera_heap_size_pack::$3 >> 3 -- vwum1=vwum2_ror_3 
    lsr
    sta vera_heap_size_pack__4+1
    lda vera_heap_size_pack__3
    ror
    sta vera_heap_size_pack__4
    lsr vera_heap_size_pack__4+1
    ror vera_heap_size_pack__4
    lsr vera_heap_size_pack__4+1
    ror vera_heap_size_pack__4
    // (vera_heap_size_packed_t)MAKEWORD(BYTE2(size)<<5, 0) | (WORD0(size) >> 3)
    // [395] vera_heap_size_pack::return#0 = vera_heap_size_pack::$6 | vera_heap_size_pack::$4 -- vwum1=vwum2_bor_vwum3 
    lda vera_heap_size_pack__6
    ora vera_heap_size_pack__4
    sta return
    tya
    ora vera_heap_size_pack__4+1
    sta return+1
    // vera_heap_size_pack::@return
    // }
    // [396] return 
    rts
    vera_heap_size_pack__0: .byte 0
    vera_heap_size_pack__1: .byte 0
    vera_heap_size_pack__3: .word 0
    vera_heap_size_pack__4: .word 0
    vera_heap_size_pack__6: .word 0
  .segment Data
    return: .word 0
    size: .dword 0
    return_1: .word 0
}
.segment CodeVeraHeap
  // vera_heap_list_remove
/**
* Remove header from List
*/
// __mem() char vera_heap_list_remove(char s, __mem() char list, __mem() char index)
vera_heap_list_remove: {
    .const vera_heap_set_next2_next = $ff
    .const vera_heap_set_prev2_prev = $ff
    // if(list == VERAHEAP_NULL)
    // [398] if(vera_heap_list_remove::list#10!=$ff) goto vera_heap_list_remove::vera_heap_get_next1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp list
    bne vera_heap_get_next1
    // [399] phi from vera_heap_list_remove vera_heap_list_remove::vera_heap_set_prev2 to vera_heap_list_remove::@return [phi:vera_heap_list_remove/vera_heap_list_remove::vera_heap_set_prev2->vera_heap_list_remove::@return]
  __b2:
    // [399] phi vera_heap_list_remove::return#1 = $ff [phi:vera_heap_list_remove/vera_heap_list_remove::vera_heap_set_prev2->vera_heap_list_remove::@return#0] -- vbum1=vbuc1 
    lda #$ff
    sta return
    // vera_heap_list_remove::@return
  __breturn:
    // }
    // [400] return 
    rts
    // vera_heap_list_remove::vera_heap_get_next1
  vera_heap_get_next1:
    // return vera_heap_index.next[index];
    // [401] vera_heap_list_remove::vera_heap_get_next1_return#0 = ((char *)&vera_heap_index+$400)[vera_heap_list_remove::list#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy list
    lda vera_heap_index+$400,y
    sta vera_heap_get_next1_return
    // vera_heap_list_remove::@2
    // if(list == vera_heap_get_next(s, list))
    // [402] if(vera_heap_list_remove::list#10!=vera_heap_list_remove::vera_heap_get_next1_return#0) goto vera_heap_list_remove::vera_heap_get_next2 -- vbum1_neq_vbum2_then_la1 
    tya
    cmp vera_heap_get_next1_return
    bne vera_heap_get_next2
    // vera_heap_list_remove::vera_heap_set_next2
    // vera_heap_index.next[index] = next
    // [403] ((char *)&vera_heap_index+$400)[vera_heap_list_remove::index#10] = vera_heap_list_remove::vera_heap_set_next2_next#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #vera_heap_set_next2_next
    ldy index
    sta vera_heap_index+$400,y
    // vera_heap_list_remove::vera_heap_set_prev2
    // vera_heap_index.prev[index] = prev
    // [404] ((char *)&vera_heap_index+$500)[vera_heap_list_remove::index#10] = vera_heap_list_remove::vera_heap_set_prev2_prev#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #vera_heap_set_prev2_prev
    sta vera_heap_index+$500,y
    jmp __b2
    // vera_heap_list_remove::vera_heap_get_next2
  vera_heap_get_next2:
    // return vera_heap_index.next[index];
    // [405] vera_heap_list_remove::next#0 = ((char *)&vera_heap_index+$400)[vera_heap_list_remove::index#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy index
    lda vera_heap_index+$400,y
    sta next
    // vera_heap_list_remove::vera_heap_get_prev1
    // return vera_heap_index.prev[index];
    // [406] vera_heap_list_remove::vera_heap_get_prev1_return#0 = ((char *)&vera_heap_index+$500)[vera_heap_list_remove::index#10] -- vbum1=pbuc1_derefidx_vbum2 
    lda vera_heap_index+$500,y
    sta vera_heap_get_prev1_return
    // vera_heap_list_remove::vera_heap_set_next1
    // vera_heap_index.next[index] = next
    // [407] ((char *)&vera_heap_index+$400)[vera_heap_list_remove::vera_heap_get_prev1_return#0] = vera_heap_list_remove::next#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda next
    ldy vera_heap_get_prev1_return
    sta vera_heap_index+$400,y
    // vera_heap_list_remove::vera_heap_set_prev1
    // vera_heap_index.prev[index] = prev
    // [408] ((char *)&vera_heap_index+$500)[vera_heap_list_remove::next#0] = vera_heap_list_remove::vera_heap_get_prev1_return#0 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy next
    sta vera_heap_index+$500,y
    // vera_heap_list_remove::@3
    // if(index == list)
    // [409] if(vera_heap_list_remove::index#10!=vera_heap_list_remove::list#10) goto vera_heap_list_remove::@1 -- vbum1_neq_vbum2_then_la1 
    lda index
    cmp list
    bne __breturn
    // vera_heap_list_remove::vera_heap_get_next3
    // return vera_heap_index.next[index];
    // [410] vera_heap_list_remove::vera_heap_get_next3_return#0 = ((char *)&vera_heap_index+$400)[vera_heap_list_remove::list#10] -- vbum1=pbuc1_derefidx_vbum1 
    ldy vera_heap_get_next3_return
    lda vera_heap_index+$400,y
    sta vera_heap_get_next3_return
    // [411] phi from vera_heap_list_remove::@3 vera_heap_list_remove::vera_heap_get_next3 to vera_heap_list_remove::@1 [phi:vera_heap_list_remove::@3/vera_heap_list_remove::vera_heap_get_next3->vera_heap_list_remove::@1]
    // [411] phi vera_heap_list_remove::return#3 = vera_heap_list_remove::list#10 [phi:vera_heap_list_remove::@3/vera_heap_list_remove::vera_heap_get_next3->vera_heap_list_remove::@1#0] -- register_copy 
    // vera_heap_list_remove::@1
    // [399] phi from vera_heap_list_remove::@1 to vera_heap_list_remove::@return [phi:vera_heap_list_remove::@1->vera_heap_list_remove::@return]
    // [399] phi vera_heap_list_remove::return#1 = vera_heap_list_remove::return#3 [phi:vera_heap_list_remove::@1->vera_heap_list_remove::@return#0] -- register_copy 
    rts
    vera_heap_get_next1_return: .byte 0
  .segment Data
    // empty list
    return: .byte 0
  .segment CodeVeraHeap
    next: .byte 0
    vera_heap_get_prev1_return: .byte 0
    .label vera_heap_get_next3_return = return
  .segment Data
    .label list = return
    index: .byte 0
    // empty list
    return_1: .byte 0
    // empty list
    return_2: .byte 0
    // empty list
    return_3: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_is_free
// __mem() bool vera_heap_is_free(char s, __mem() char index)
vera_heap_is_free: {
    // vera_heap_index.size1[index] & 0x80
    // [413] vera_heap_is_free::$0 = ((char *)&vera_heap_index+$300)[vera_heap_is_free::index#2] & $80 -- vbum1=pbuc1_derefidx_vbum2_band_vbuc2 
    lda #$80
    ldy index
    and vera_heap_index+$300,y
    sta vera_heap_is_free__0
    // (vera_heap_index.size1[index] & 0x80) == 0x80
    // [414] vera_heap_is_free::return#0 = vera_heap_is_free::$0 == $80 -- vbom1=vbum2_eq_vbuc1 
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    sta return
    // vera_heap_is_free::@return
    // }
    // [415] return 
    rts
    vera_heap_is_free__0: .byte 0
  .segment Data
    return: .byte 0
    index: .byte 0
    return_1: .byte 0
    return_2: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_free_remove
// void vera_heap_free_remove(__mem() char s, __mem() char free_index)
vera_heap_free_remove: {
    // vera_heap_segment.freeCount[s]--;
    // [417] vera_heap_free_remove::$4 = vera_heap_free_remove::s#2 << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta vera_heap_free_remove__4
    // [418] ((unsigned int *)&vera_heap_segment+$46)[vera_heap_free_remove::$4] = -- ((unsigned int *)&vera_heap_segment+$46)[vera_heap_free_remove::$4] -- pwuc1_derefidx_vbum1=_dec_pwuc1_derefidx_vbum1 
    tax
    lda vera_heap_segment+$46,x
    bne !+
    dec vera_heap_segment+$46+1,x
  !:
    dec vera_heap_segment+$46,x
    // vera_heap_list_remove(s, vera_heap_segment.free_list[s], free_index)
    // [419] vera_heap_list_remove::list#3 = ((char *)&vera_heap_segment+$2e)[vera_heap_free_remove::s#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda vera_heap_segment+$2e,y
    sta vera_heap_list_remove.list
    // [420] vera_heap_list_remove::index#1 = vera_heap_free_remove::free_index#2 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_list_remove.index
    // [421] call vera_heap_list_remove
    // [397] phi from vera_heap_free_remove to vera_heap_list_remove [phi:vera_heap_free_remove->vera_heap_list_remove]
    // [397] phi vera_heap_list_remove::index#10 = vera_heap_list_remove::index#1 [phi:vera_heap_free_remove->vera_heap_list_remove#0] -- register_copy 
    // [397] phi vera_heap_list_remove::list#10 = vera_heap_list_remove::list#3 [phi:vera_heap_free_remove->vera_heap_list_remove#1] -- call_phi_near 
    jsr vera_heap_list_remove
    // vera_heap_list_remove(s, vera_heap_segment.free_list[s], free_index)
    // [422] vera_heap_list_remove::return#5 = vera_heap_list_remove::return#1 -- vbum1=vbum2 
    lda vera_heap_list_remove.return
    sta vera_heap_list_remove.return_2
    // vera_heap_free_remove::@1
    // [423] vera_heap_free_remove::$1 = vera_heap_list_remove::return#5 -- vbum1=vbum2 
    sta vera_heap_free_remove__1
    // vera_heap_segment.free_list[s] = vera_heap_list_remove(s, vera_heap_segment.free_list[s], free_index)
    // [424] ((char *)&vera_heap_segment+$2e)[vera_heap_free_remove::s#2] = vera_heap_free_remove::$1 -- pbuc1_derefidx_vbum1=vbum2 
    ldy s
    sta vera_heap_segment+$2e,y
    // vera_heap_clear_free(s, free_index)
    // [425] vera_heap_clear_free::index#0 = vera_heap_free_remove::free_index#2 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_clear_free.index
    // [426] call vera_heap_clear_free
    // [507] phi from vera_heap_free_remove::@1 to vera_heap_clear_free [phi:vera_heap_free_remove::@1->vera_heap_clear_free]
    // [507] phi vera_heap_clear_free::index#2 = vera_heap_clear_free::index#0 [phi:vera_heap_free_remove::@1->vera_heap_clear_free#0] -- call_phi_near 
    jsr vera_heap_clear_free
    // vera_heap_free_remove::@return
    // }
    // [427] return 
    rts
    vera_heap_free_remove__1: .byte 0
    vera_heap_free_remove__4: .byte 0
  .segment Data
    s: .byte 0
    free_index: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_idle_insert
// char vera_heap_idle_insert(__mem() char s, __mem() char idle_index)
vera_heap_idle_insert: {
    // vera_heap_list_insert_at(s, vera_heap_segment.idle_list[s], idle_index, vera_heap_segment.idle_list[s])
    // [428] vera_heap_list_insert_at::list#4 = ((char *)&vera_heap_segment+$32)[vera_heap_idle_insert::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda vera_heap_segment+$32,y
    sta vera_heap_list_insert_at.list
    // [429] vera_heap_list_insert_at::index#3 = vera_heap_idle_insert::idle_index#0 -- vbum1=vbum2 
    lda idle_index
    sta vera_heap_list_insert_at.index
    // [430] vera_heap_list_insert_at::at#4 = ((char *)&vera_heap_segment+$32)[vera_heap_idle_insert::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda vera_heap_segment+$32,y
    sta vera_heap_list_insert_at.at
    // [431] call vera_heap_list_insert_at
    // [357] phi from vera_heap_idle_insert to vera_heap_list_insert_at [phi:vera_heap_idle_insert->vera_heap_list_insert_at]
    // [357] phi vera_heap_list_insert_at::index#10 = vera_heap_list_insert_at::index#3 [phi:vera_heap_idle_insert->vera_heap_list_insert_at#0] -- register_copy 
    // [357] phi vera_heap_list_insert_at::at#11 = vera_heap_list_insert_at::at#4 [phi:vera_heap_idle_insert->vera_heap_list_insert_at#1] -- register_copy 
    // [357] phi vera_heap_list_insert_at::list#5 = vera_heap_list_insert_at::list#4 [phi:vera_heap_idle_insert->vera_heap_list_insert_at#2] -- call_phi_near 
    jsr vera_heap_list_insert_at
    // vera_heap_list_insert_at(s, vera_heap_segment.idle_list[s], idle_index, vera_heap_segment.idle_list[s])
    // [432] vera_heap_list_insert_at::return#10 = vera_heap_list_insert_at::list#11 -- vbum1=vbum2 
    lda vera_heap_list_insert_at.list
    sta vera_heap_list_insert_at.return_3
    // vera_heap_idle_insert::@1
    // [433] vera_heap_idle_insert::$0 = vera_heap_list_insert_at::return#10 -- vbum1=vbum2 
    sta vera_heap_idle_insert__0
    // vera_heap_segment.idle_list[s] = vera_heap_list_insert_at(s, vera_heap_segment.idle_list[s], idle_index, vera_heap_segment.idle_list[s])
    // [434] ((char *)&vera_heap_segment+$32)[vera_heap_idle_insert::s#0] = vera_heap_idle_insert::$0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy s
    sta vera_heap_segment+$32,y
    // vera_heap_set_data_packed(s, idle_index, 0)
    // [435] vera_heap_set_data_packed::index#2 = vera_heap_idle_insert::idle_index#0 -- vbum1=vbum2 
    lda idle_index
    sta vera_heap_set_data_packed.index
    // [436] call vera_heap_set_data_packed
    // [372] phi from vera_heap_idle_insert::@1 to vera_heap_set_data_packed [phi:vera_heap_idle_insert::@1->vera_heap_set_data_packed]
    // [372] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#2 [phi:vera_heap_idle_insert::@1->vera_heap_set_data_packed#0] -- register_copy 
    // [372] phi vera_heap_set_data_packed::data_packed#7 = 0 [phi:vera_heap_idle_insert::@1->vera_heap_set_data_packed#1] -- call_phi_near 
    lda #<0
    sta vera_heap_set_data_packed.data_packed
    sta vera_heap_set_data_packed.data_packed+1
    jsr vera_heap_set_data_packed
    // vera_heap_idle_insert::@2
    // vera_heap_set_size_packed(s, idle_index, 0)
    // [437] vera_heap_set_size_packed::index#3 = vera_heap_idle_insert::idle_index#0 -- vbum1=vbum2 
    lda idle_index
    sta vera_heap_set_size_packed.index
    // [438] call vera_heap_set_size_packed
    // [378] phi from vera_heap_idle_insert::@2 to vera_heap_set_size_packed [phi:vera_heap_idle_insert::@2->vera_heap_set_size_packed]
    // [378] phi vera_heap_set_size_packed::size_packed#6 = 0 [phi:vera_heap_idle_insert::@2->vera_heap_set_size_packed#0] -- vwum1=vbuc1 
    lda #<0
    sta vera_heap_set_size_packed.size_packed
    sta vera_heap_set_size_packed.size_packed+1
    // [378] phi vera_heap_set_size_packed::index#6 = vera_heap_set_size_packed::index#3 [phi:vera_heap_idle_insert::@2->vera_heap_set_size_packed#1] -- call_phi_near 
    jsr vera_heap_set_size_packed
    // vera_heap_idle_insert::@3
    // vera_heap_segment.idleCount[s]++;
    // [439] vera_heap_idle_insert::$5 = vera_heap_idle_insert::s#0 << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta vera_heap_idle_insert__5
    // [440] ((unsigned int *)&vera_heap_segment+$4e)[vera_heap_idle_insert::$5] = ++ ((unsigned int *)&vera_heap_segment+$4e)[vera_heap_idle_insert::$5] -- pwuc1_derefidx_vbum1=_inc_pwuc1_derefidx_vbum1 
    tax
    inc vera_heap_segment+$4e,x
    bne !+
    inc vera_heap_segment+$4e+1,x
  !:
    // vera_heap_idle_insert::@return
    // }
    // [441] return 
    rts
    vera_heap_idle_insert__0: .byte 0
    vera_heap_idle_insert__5: .byte 0
  .segment Data
    s: .byte 0
    idle_index: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_replace_free_with_heap
/**
 * The free size matches exactly the required heap size.
 * The free index is replaced by a heap index.
 */
// __mem() char vera_heap_replace_free_with_heap(__mem() char s, char free_index, __mem() unsigned int required_size)
vera_heap_replace_free_with_heap: {
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [442] vera_heap_get_size_packed::index#1 = vera_heap_replace_free_with_heap::return#2 -- vbum1=vbum2 
    lda return
    sta vera_heap_get_size_packed.index
    // [443] call vera_heap_get_size_packed
    // [217] phi from vera_heap_replace_free_with_heap to vera_heap_get_size_packed [phi:vera_heap_replace_free_with_heap->vera_heap_get_size_packed]
    // [217] phi vera_heap_get_size_packed::index#7 = vera_heap_get_size_packed::index#1 [phi:vera_heap_replace_free_with_heap->vera_heap_get_size_packed#0] -- call_phi_near 
    jsr vera_heap_get_size_packed
    // vera_heap_replace_free_with_heap::@2
    // vera_heap_data_packed_t free_data = vera_heap_get_data_packed(s, free_index)
    // [444] vera_heap_get_data_packed::index#2 = vera_heap_replace_free_with_heap::return#2 -- vbum1=vbum2 
    lda return
    sta vera_heap_get_data_packed.index
    // [445] call vera_heap_get_data_packed
    // [214] phi from vera_heap_replace_free_with_heap::@2 to vera_heap_get_data_packed [phi:vera_heap_replace_free_with_heap::@2->vera_heap_get_data_packed]
    // [214] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#2 [phi:vera_heap_replace_free_with_heap::@2->vera_heap_get_data_packed#0] -- call_phi_near 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t free_data = vera_heap_get_data_packed(s, free_index)
    // [446] vera_heap_get_data_packed::return#14 = vera_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_1
    sta vera_heap_get_data_packed.return_4
    lda vera_heap_get_data_packed.return_1+1
    sta vera_heap_get_data_packed.return_4+1
    // vera_heap_replace_free_with_heap::@3
    // [447] vera_heap_replace_free_with_heap::free_data#0 = vera_heap_get_data_packed::return#14 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_4
    sta free_data
    lda vera_heap_get_data_packed.return_4+1
    sta free_data+1
    // vera_heap_replace_free_with_heap::vera_heap_get_left1
    // return vera_heap_index.left[index];
    // [448] vera_heap_replace_free_with_heap::free_left#0 = ((char *)&vera_heap_index+$700)[vera_heap_replace_free_with_heap::return#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy return
    lda vera_heap_index+$700,y
    sta free_left
    // vera_heap_replace_free_with_heap::vera_heap_get_right1
    // return vera_heap_index.right[index];
    // [449] vera_heap_replace_free_with_heap::free_right#0 = ((char *)&vera_heap_index+$600)[vera_heap_replace_free_with_heap::return#2] -- vbum1=pbuc1_derefidx_vbum2 
    lda vera_heap_index+$600,y
    sta free_right
    // vera_heap_replace_free_with_heap::@1
    // vera_heap_free_remove(s, free_index)
    // [450] vera_heap_free_remove::s#0 = vera_heap_replace_free_with_heap::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_free_remove.s
    // [451] vera_heap_free_remove::free_index#0 = vera_heap_replace_free_with_heap::return#2 -- vbum1=vbum2 
    tya
    sta vera_heap_free_remove.free_index
    // [452] call vera_heap_free_remove
    // [416] phi from vera_heap_replace_free_with_heap::@1 to vera_heap_free_remove [phi:vera_heap_replace_free_with_heap::@1->vera_heap_free_remove]
    // [416] phi vera_heap_free_remove::free_index#2 = vera_heap_free_remove::free_index#0 [phi:vera_heap_replace_free_with_heap::@1->vera_heap_free_remove#0] -- register_copy 
    // [416] phi vera_heap_free_remove::s#2 = vera_heap_free_remove::s#0 [phi:vera_heap_replace_free_with_heap::@1->vera_heap_free_remove#1] -- call_phi_near 
    jsr vera_heap_free_remove
    // vera_heap_replace_free_with_heap::@4
    // vera_heap_heap_insert_at(s, heap_index, VERAHEAP_NULL, required_size)
    // [453] vera_heap_heap_insert_at::s#0 = vera_heap_replace_free_with_heap::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_heap_insert_at.s
    // [454] vera_heap_heap_insert_at::heap_index#0 = vera_heap_replace_free_with_heap::return#2 -- vbum1=vbum2 
    lda return
    sta vera_heap_heap_insert_at.heap_index
    // [455] vera_heap_heap_insert_at::size#0 = vera_heap_replace_free_with_heap::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta vera_heap_heap_insert_at.size
    lda required_size+1
    sta vera_heap_heap_insert_at.size+1
    // [456] call vera_heap_heap_insert_at
    // [510] phi from vera_heap_replace_free_with_heap::@4 to vera_heap_heap_insert_at [phi:vera_heap_replace_free_with_heap::@4->vera_heap_heap_insert_at]
    // [510] phi vera_heap_heap_insert_at::size#2 = vera_heap_heap_insert_at::size#0 [phi:vera_heap_replace_free_with_heap::@4->vera_heap_heap_insert_at#0] -- register_copy 
    // [510] phi vera_heap_heap_insert_at::heap_index#2 = vera_heap_heap_insert_at::heap_index#0 [phi:vera_heap_replace_free_with_heap::@4->vera_heap_heap_insert_at#1] -- register_copy 
    // [510] phi vera_heap_heap_insert_at::s#2 = vera_heap_heap_insert_at::s#0 [phi:vera_heap_replace_free_with_heap::@4->vera_heap_heap_insert_at#2] -- call_phi_near 
    jsr vera_heap_heap_insert_at
    // vera_heap_replace_free_with_heap::@5
    // vera_heap_set_data_packed(s, heap_index, free_data)
    // [457] vera_heap_set_data_packed::index#3 = vera_heap_replace_free_with_heap::return#2 -- vbum1=vbum2 
    lda return
    sta vera_heap_set_data_packed.index
    // [458] vera_heap_set_data_packed::data_packed#3 = vera_heap_replace_free_with_heap::free_data#0 -- vwum1=vwum2 
    lda free_data
    sta vera_heap_set_data_packed.data_packed
    lda free_data+1
    sta vera_heap_set_data_packed.data_packed+1
    // [459] call vera_heap_set_data_packed
    // [372] phi from vera_heap_replace_free_with_heap::@5 to vera_heap_set_data_packed [phi:vera_heap_replace_free_with_heap::@5->vera_heap_set_data_packed]
    // [372] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#3 [phi:vera_heap_replace_free_with_heap::@5->vera_heap_set_data_packed#0] -- register_copy 
    // [372] phi vera_heap_set_data_packed::data_packed#7 = vera_heap_set_data_packed::data_packed#3 [phi:vera_heap_replace_free_with_heap::@5->vera_heap_set_data_packed#1] -- call_phi_near 
    jsr vera_heap_set_data_packed
    // vera_heap_replace_free_with_heap::vera_heap_set_left1
    // vera_heap_index.left[index] = left
    // [460] ((char *)&vera_heap_index+$700)[vera_heap_replace_free_with_heap::return#2] = vera_heap_replace_free_with_heap::free_left#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_left
    ldy return
    sta vera_heap_index+$700,y
    // vera_heap_replace_free_with_heap::vera_heap_set_right1
    // vera_heap_index.right[index] = right
    // [461] ((char *)&vera_heap_index+$600)[vera_heap_replace_free_with_heap::return#2] = vera_heap_replace_free_with_heap::free_right#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_right
    sta vera_heap_index+$600,y
    // vera_heap_replace_free_with_heap::@return
    // }
    // [462] return 
    rts
    free_data: .word 0
    free_left: .byte 0
    free_right: .byte 0
  .segment Data
    s: .byte 0
    required_size: .word 0
    return: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_split_free_and_allocate
/**
 * Splits the header on two, returns the pointer to the smaller sub-header.
 */
// __mem() char vera_heap_split_free_and_allocate(__mem() char s, __mem() char free_index, __mem() unsigned int required_size)
vera_heap_split_free_and_allocate: {
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [463] vera_heap_get_size_packed::index#2 = vera_heap_split_free_and_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_get_size_packed.index
    // [464] call vera_heap_get_size_packed
  // The free block is reduced in size with the required size.
    // [217] phi from vera_heap_split_free_and_allocate to vera_heap_get_size_packed [phi:vera_heap_split_free_and_allocate->vera_heap_get_size_packed]
    // [217] phi vera_heap_get_size_packed::index#7 = vera_heap_get_size_packed::index#2 [phi:vera_heap_split_free_and_allocate->vera_heap_get_size_packed#0] -- call_phi_near 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [465] vera_heap_get_size_packed::return#11 = vera_heap_get_size_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_size_packed.return_1
    sta vera_heap_get_size_packed.return_2
    lda vera_heap_get_size_packed.return_1+1
    sta vera_heap_get_size_packed.return_2+1
    // vera_heap_split_free_and_allocate::@2
    // [466] vera_heap_split_free_and_allocate::free_size#0 = vera_heap_get_size_packed::return#11 -- vwum1=vwum2 
    lda vera_heap_get_size_packed.return_2
    sta free_size
    lda vera_heap_get_size_packed.return_2+1
    sta free_size+1
    // vera_heap_data_packed_t free_data = vera_heap_get_data_packed(s, free_index)
    // [467] vera_heap_get_data_packed::index#3 = vera_heap_split_free_and_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_get_data_packed.index
    // [468] call vera_heap_get_data_packed
    // [214] phi from vera_heap_split_free_and_allocate::@2 to vera_heap_get_data_packed [phi:vera_heap_split_free_and_allocate::@2->vera_heap_get_data_packed]
    // [214] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#3 [phi:vera_heap_split_free_and_allocate::@2->vera_heap_get_data_packed#0] -- call_phi_near 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t free_data = vera_heap_get_data_packed(s, free_index)
    // [469] vera_heap_get_data_packed::return#15 = vera_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_1
    sta vera_heap_get_data_packed.return_5
    lda vera_heap_get_data_packed.return_1+1
    sta vera_heap_get_data_packed.return_5+1
    // vera_heap_split_free_and_allocate::@3
    // [470] vera_heap_split_free_and_allocate::free_data#0 = vera_heap_get_data_packed::return#15 -- vwum1=vwum2 
    lda vera_heap_get_data_packed.return_5
    sta free_data
    lda vera_heap_get_data_packed.return_5+1
    sta free_data+1
    // vera_heap_set_size_packed(s, free_index, free_size - required_size)
    // [471] vera_heap_set_size_packed::size_packed#4 = vera_heap_split_free_and_allocate::free_size#0 - vera_heap_split_free_and_allocate::required_size#0 -- vwum1=vwum2_minus_vwum3 
    lda free_size
    sec
    sbc required_size
    sta vera_heap_set_size_packed.size_packed
    lda free_size+1
    sbc required_size+1
    sta vera_heap_set_size_packed.size_packed+1
    // [472] vera_heap_set_size_packed::index#4 = vera_heap_split_free_and_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_set_size_packed.index
    // [473] call vera_heap_set_size_packed
    // [378] phi from vera_heap_split_free_and_allocate::@3 to vera_heap_set_size_packed [phi:vera_heap_split_free_and_allocate::@3->vera_heap_set_size_packed]
    // [378] phi vera_heap_set_size_packed::size_packed#6 = vera_heap_set_size_packed::size_packed#4 [phi:vera_heap_split_free_and_allocate::@3->vera_heap_set_size_packed#0] -- register_copy 
    // [378] phi vera_heap_set_size_packed::index#6 = vera_heap_set_size_packed::index#4 [phi:vera_heap_split_free_and_allocate::@3->vera_heap_set_size_packed#1] -- call_phi_near 
    jsr vera_heap_set_size_packed
    // vera_heap_split_free_and_allocate::@4
    // vera_heap_set_data_packed(s, free_index, free_data + required_size)
    // [474] vera_heap_set_data_packed::data_packed#4 = vera_heap_split_free_and_allocate::free_data#0 + vera_heap_split_free_and_allocate::required_size#0 -- vwum1=vwum2_plus_vwum3 
    lda free_data
    clc
    adc required_size
    sta vera_heap_set_data_packed.data_packed
    lda free_data+1
    adc required_size+1
    sta vera_heap_set_data_packed.data_packed+1
    // [475] vera_heap_set_data_packed::index#4 = vera_heap_split_free_and_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta vera_heap_set_data_packed.index
    // [476] call vera_heap_set_data_packed
    // [372] phi from vera_heap_split_free_and_allocate::@4 to vera_heap_set_data_packed [phi:vera_heap_split_free_and_allocate::@4->vera_heap_set_data_packed]
    // [372] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#4 [phi:vera_heap_split_free_and_allocate::@4->vera_heap_set_data_packed#0] -- register_copy 
    // [372] phi vera_heap_set_data_packed::data_packed#7 = vera_heap_set_data_packed::data_packed#4 [phi:vera_heap_split_free_and_allocate::@4->vera_heap_set_data_packed#1] -- call_phi_near 
    jsr vera_heap_set_data_packed
    // vera_heap_split_free_and_allocate::@5
    // vera_heap_index_t heap_index = vera_heap_index_add(s)
    // [477] vera_heap_index_add::s#1 = vera_heap_split_free_and_allocate::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_index_add.s
    // [478] call vera_heap_index_add
  // We create a new heap block with the required size.
  // The data is the offset in vram.
    // [347] phi from vera_heap_split_free_and_allocate::@5 to vera_heap_index_add [phi:vera_heap_split_free_and_allocate::@5->vera_heap_index_add]
    // [347] phi vera_heap_index_add::s#2 = vera_heap_index_add::s#1 [phi:vera_heap_split_free_and_allocate::@5->vera_heap_index_add#0] -- call_phi_near 
    jsr vera_heap_index_add
    // vera_heap_index_t heap_index = vera_heap_index_add(s)
    // [479] vera_heap_index_add::return#3 = vera_heap_index_add::return#1 -- vbum1=vbum2 
    lda vera_heap_index_add.return_1
    sta vera_heap_index_add.return_2
    // vera_heap_split_free_and_allocate::@6
    // [480] vera_heap_split_free_and_allocate::heap_index#0 = vera_heap_index_add::return#3 -- vbum1=vbum2 
    sta heap_index
    // vera_heap_set_data_packed(s, heap_index, free_data)
    // [481] vera_heap_set_data_packed::index#5 = vera_heap_split_free_and_allocate::heap_index#0 -- vbum1=vbum2 
    sta vera_heap_set_data_packed.index
    // [482] vera_heap_set_data_packed::data_packed#5 = vera_heap_split_free_and_allocate::free_data#0 -- vwum1=vwum2 
    lda free_data
    sta vera_heap_set_data_packed.data_packed
    lda free_data+1
    sta vera_heap_set_data_packed.data_packed+1
    // [483] call vera_heap_set_data_packed
    // [372] phi from vera_heap_split_free_and_allocate::@6 to vera_heap_set_data_packed [phi:vera_heap_split_free_and_allocate::@6->vera_heap_set_data_packed]
    // [372] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#5 [phi:vera_heap_split_free_and_allocate::@6->vera_heap_set_data_packed#0] -- register_copy 
    // [372] phi vera_heap_set_data_packed::data_packed#7 = vera_heap_set_data_packed::data_packed#5 [phi:vera_heap_split_free_and_allocate::@6->vera_heap_set_data_packed#1] -- call_phi_near 
    jsr vera_heap_set_data_packed
    // vera_heap_split_free_and_allocate::@7
    // vera_heap_heap_insert_at(s, heap_index, VERAHEAP_NULL, required_size)
    // [484] vera_heap_heap_insert_at::s#1 = vera_heap_split_free_and_allocate::s#0 -- vbum1=vbum2 
    lda s
    sta vera_heap_heap_insert_at.s
    // [485] vera_heap_heap_insert_at::heap_index#1 = vera_heap_split_free_and_allocate::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta vera_heap_heap_insert_at.heap_index
    // [486] vera_heap_heap_insert_at::size#1 = vera_heap_split_free_and_allocate::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta vera_heap_heap_insert_at.size
    lda required_size+1
    sta vera_heap_heap_insert_at.size+1
    // [487] call vera_heap_heap_insert_at
    // [510] phi from vera_heap_split_free_and_allocate::@7 to vera_heap_heap_insert_at [phi:vera_heap_split_free_and_allocate::@7->vera_heap_heap_insert_at]
    // [510] phi vera_heap_heap_insert_at::size#2 = vera_heap_heap_insert_at::size#1 [phi:vera_heap_split_free_and_allocate::@7->vera_heap_heap_insert_at#0] -- register_copy 
    // [510] phi vera_heap_heap_insert_at::heap_index#2 = vera_heap_heap_insert_at::heap_index#1 [phi:vera_heap_split_free_and_allocate::@7->vera_heap_heap_insert_at#1] -- register_copy 
    // [510] phi vera_heap_heap_insert_at::s#2 = vera_heap_heap_insert_at::s#1 [phi:vera_heap_split_free_and_allocate::@7->vera_heap_heap_insert_at#2] -- call_phi_near 
    jsr vera_heap_heap_insert_at
    // vera_heap_split_free_and_allocate::vera_heap_get_left1
    // return vera_heap_index.left[index];
    // [488] vera_heap_split_free_and_allocate::heap_left#0 = ((char *)&vera_heap_index+$700)[vera_heap_split_free_and_allocate::free_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy free_index
    lda vera_heap_index+$700,y
    sta heap_left
    // vera_heap_split_free_and_allocate::vera_heap_set_left1
    // vera_heap_index.left[index] = left
    // [489] ((char *)&vera_heap_index+$700)[vera_heap_split_free_and_allocate::heap_index#0] = vera_heap_split_free_and_allocate::heap_left#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy heap_index
    sta vera_heap_index+$700,y
    // vera_heap_split_free_and_allocate::vera_heap_set_right1
    // vera_heap_index.right[index] = right
    // [490] ((char *)&vera_heap_index+$600)[vera_heap_split_free_and_allocate::heap_index#0] = vera_heap_split_free_and_allocate::free_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_index
    sta vera_heap_index+$600,y
    // vera_heap_split_free_and_allocate::vera_heap_set_right2
    // [491] ((char *)&vera_heap_index+$600)[vera_heap_split_free_and_allocate::heap_left#0] = vera_heap_split_free_and_allocate::heap_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy heap_left
    sta vera_heap_index+$600,y
    // vera_heap_split_free_and_allocate::vera_heap_set_left2
    // vera_heap_index.left[index] = left
    // [492] ((char *)&vera_heap_index+$700)[vera_heap_split_free_and_allocate::free_index#0] = vera_heap_split_free_and_allocate::heap_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy free_index
    sta vera_heap_index+$700,y
    // vera_heap_split_free_and_allocate::@1
    // vera_heap_set_free(s, heap_right)
    // [493] vera_heap_set_free::index#2 = vera_heap_split_free_and_allocate::free_index#0 -- vbum1=vbum2 
    tya
    sta vera_heap_set_free.index
    // [494] call vera_heap_set_free
    // [387] phi from vera_heap_split_free_and_allocate::@1 to vera_heap_set_free [phi:vera_heap_split_free_and_allocate::@1->vera_heap_set_free]
    // [387] phi vera_heap_set_free::index#5 = vera_heap_set_free::index#2 [phi:vera_heap_split_free_and_allocate::@1->vera_heap_set_free#0] -- call_phi_near 
    jsr vera_heap_set_free
    // vera_heap_split_free_and_allocate::@8
    // vera_heap_clear_free(s, heap_left)
    // [495] vera_heap_clear_free::index#1 = vera_heap_split_free_and_allocate::heap_left#0 -- vbum1=vbum2 
    lda heap_left
    sta vera_heap_clear_free.index
    // [496] call vera_heap_clear_free
    // [507] phi from vera_heap_split_free_and_allocate::@8 to vera_heap_clear_free [phi:vera_heap_split_free_and_allocate::@8->vera_heap_clear_free]
    // [507] phi vera_heap_clear_free::index#2 = vera_heap_clear_free::index#1 [phi:vera_heap_split_free_and_allocate::@8->vera_heap_clear_free#0] -- call_phi_near 
    jsr vera_heap_clear_free
    // vera_heap_split_free_and_allocate::@return
    // }
    // [497] return 
    rts
    free_size: .word 0
    free_data: .word 0
    heap_index: .byte 0
    heap_left: .byte 0
  .segment Data
    s: .byte 0
    free_index: .byte 0
    required_size: .word 0
    return: .byte 0
}
.segment CodeVeraHeap
  // heap_idle_remove
// void heap_idle_remove(__mem() char s, __mem() char idle_index)
heap_idle_remove: {
    // vera_heap_segment.idleCount[s]--;
    // [498] heap_idle_remove::$3 = heap_idle_remove::s#0 << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta heap_idle_remove__3
    // [499] ((unsigned int *)&vera_heap_segment+$4e)[heap_idle_remove::$3] = -- ((unsigned int *)&vera_heap_segment+$4e)[heap_idle_remove::$3] -- pwuc1_derefidx_vbum1=_dec_pwuc1_derefidx_vbum1 
    tax
    lda vera_heap_segment+$4e,x
    bne !+
    dec vera_heap_segment+$4e+1,x
  !:
    dec vera_heap_segment+$4e,x
    // vera_heap_list_remove(s, vera_heap_segment.idle_list[s], idle_index)
    // [500] vera_heap_list_remove::list#4 = ((char *)&vera_heap_segment+$32)[heap_idle_remove::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda vera_heap_segment+$32,y
    sta vera_heap_list_remove.list
    // [501] vera_heap_list_remove::index#2 = heap_idle_remove::idle_index#0 -- vbum1=vbum2 
    lda idle_index
    sta vera_heap_list_remove.index
    // [502] call vera_heap_list_remove
    // [397] phi from heap_idle_remove to vera_heap_list_remove [phi:heap_idle_remove->vera_heap_list_remove]
    // [397] phi vera_heap_list_remove::index#10 = vera_heap_list_remove::index#2 [phi:heap_idle_remove->vera_heap_list_remove#0] -- register_copy 
    // [397] phi vera_heap_list_remove::list#10 = vera_heap_list_remove::list#4 [phi:heap_idle_remove->vera_heap_list_remove#1] -- call_phi_near 
    jsr vera_heap_list_remove
    // vera_heap_list_remove(s, vera_heap_segment.idle_list[s], idle_index)
    // [503] vera_heap_list_remove::return#10 = vera_heap_list_remove::return#1 -- vbum1=vbum2 
    lda vera_heap_list_remove.return
    sta vera_heap_list_remove.return_3
    // heap_idle_remove::@1
    // [504] heap_idle_remove::$1 = vera_heap_list_remove::return#10 -- vbum1=vbum2 
    sta heap_idle_remove__1
    // vera_heap_segment.idle_list[s] = vera_heap_list_remove(s, vera_heap_segment.idle_list[s], idle_index)
    // [505] ((char *)&vera_heap_segment+$32)[heap_idle_remove::s#0] = heap_idle_remove::$1 -- pbuc1_derefidx_vbum1=vbum2 
    ldy s
    sta vera_heap_segment+$32,y
    // heap_idle_remove::@return
    // }
    // [506] return 
    rts
    heap_idle_remove__1: .byte 0
    heap_idle_remove__3: .byte 0
  .segment Data
    s: .byte 0
    idle_index: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_clear_free
// void vera_heap_clear_free(char s, __mem() char index)
vera_heap_clear_free: {
    // vera_heap_index.size1[index] &= 0x7F
    // [508] ((char *)&vera_heap_index+$300)[vera_heap_clear_free::index#2] = ((char *)&vera_heap_index+$300)[vera_heap_clear_free::index#2] & $7f -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_band_vbuc2 
    lda #$7f
    ldy index
    and vera_heap_index+$300,y
    sta vera_heap_index+$300,y
    // vera_heap_clear_free::@return
    // }
    // [509] return 
    rts
  .segment Data
    index: .byte 0
}
.segment CodeVeraHeap
  // vera_heap_heap_insert_at
// char vera_heap_heap_insert_at(__mem() char s, __mem() char heap_index, char at, __mem() unsigned int size)
vera_heap_heap_insert_at: {
    // vera_heap_list_insert_at(s, vera_heap_segment.heap_list[s], heap_index, at)
    // [511] vera_heap_list_insert_at::list#1 = ((char *)&vera_heap_segment+$2a)[vera_heap_heap_insert_at::s#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda vera_heap_segment+$2a,y
    sta vera_heap_list_insert_at.list
    // [512] vera_heap_list_insert_at::index#1 = vera_heap_heap_insert_at::heap_index#2 -- vbum1=vbum2 
    lda heap_index
    sta vera_heap_list_insert_at.index
    // [513] call vera_heap_list_insert_at
    // [357] phi from vera_heap_heap_insert_at to vera_heap_list_insert_at [phi:vera_heap_heap_insert_at->vera_heap_list_insert_at]
    // [357] phi vera_heap_list_insert_at::index#10 = vera_heap_list_insert_at::index#1 [phi:vera_heap_heap_insert_at->vera_heap_list_insert_at#0] -- register_copy 
    // [357] phi vera_heap_list_insert_at::at#11 = $ff [phi:vera_heap_heap_insert_at->vera_heap_list_insert_at#1] -- vbum1=vbuc1 
    lda #$ff
    sta vera_heap_list_insert_at.at
    // [357] phi vera_heap_list_insert_at::list#5 = vera_heap_list_insert_at::list#1 [phi:vera_heap_heap_insert_at->vera_heap_list_insert_at#2] -- call_phi_near 
    jsr vera_heap_list_insert_at
    // vera_heap_list_insert_at(s, vera_heap_segment.heap_list[s], heap_index, at)
    // [514] vera_heap_list_insert_at::return#1 = vera_heap_list_insert_at::list#11 -- vbum1=vbum2 
    lda vera_heap_list_insert_at.list
    sta vera_heap_list_insert_at.return_1
    // vera_heap_heap_insert_at::@1
    // [515] vera_heap_heap_insert_at::$0 = vera_heap_list_insert_at::return#1 -- vbum1=vbum2 
    sta vera_heap_heap_insert_at__0
    // vera_heap_segment.heap_list[s] = vera_heap_list_insert_at(s, vera_heap_segment.heap_list[s], heap_index, at)
    // [516] ((char *)&vera_heap_segment+$2a)[vera_heap_heap_insert_at::s#2] = vera_heap_heap_insert_at::$0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy s
    sta vera_heap_segment+$2a,y
    // vera_heap_set_size_packed(s, heap_index, size)
    // [517] vera_heap_set_size_packed::index#1 = vera_heap_heap_insert_at::heap_index#2 -- vbum1=vbum2 
    lda heap_index
    sta vera_heap_set_size_packed.index
    // [518] vera_heap_set_size_packed::size_packed#1 = vera_heap_heap_insert_at::size#2 -- vwum1=vwum2 
    lda size
    sta vera_heap_set_size_packed.size_packed
    lda size+1
    sta vera_heap_set_size_packed.size_packed+1
    // [519] call vera_heap_set_size_packed
    // [378] phi from vera_heap_heap_insert_at::@1 to vera_heap_set_size_packed [phi:vera_heap_heap_insert_at::@1->vera_heap_set_size_packed]
    // [378] phi vera_heap_set_size_packed::size_packed#6 = vera_heap_set_size_packed::size_packed#1 [phi:vera_heap_heap_insert_at::@1->vera_heap_set_size_packed#0] -- register_copy 
    // [378] phi vera_heap_set_size_packed::index#6 = vera_heap_set_size_packed::index#1 [phi:vera_heap_heap_insert_at::@1->vera_heap_set_size_packed#1] -- call_phi_near 
    jsr vera_heap_set_size_packed
    // vera_heap_heap_insert_at::@2
    // vera_heap_segment.heapCount[s]++;
    // [520] vera_heap_heap_insert_at::$4 = vera_heap_heap_insert_at::s#2 << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta vera_heap_heap_insert_at__4
    // [521] ((unsigned int *)&vera_heap_segment+$3e)[vera_heap_heap_insert_at::$4] = ++ ((unsigned int *)&vera_heap_segment+$3e)[vera_heap_heap_insert_at::$4] -- pwuc1_derefidx_vbum1=_inc_pwuc1_derefidx_vbum1 
    tax
    inc vera_heap_segment+$3e,x
    bne !+
    inc vera_heap_segment+$3e+1,x
  !:
    // vera_heap_heap_insert_at::@return
    // }
    // [522] return 
    rts
    vera_heap_heap_insert_at__0: .byte 0
    vera_heap_heap_insert_at__4: .byte 0
  .segment Data
    s: .byte 0
    heap_index: .byte 0
    size: .word 0
}
  // File Data
.segment CodeVeraHeap
  funcs: .word vera_heap_alloc, vera_heap_free, vera_heap_bram_bank_init, vera_heap_segment_init, vera_heap_data_get_offset, vera_heap_data_get_bank, vera_heap_has_free
.segment BramVeraHeap
  vera_heap_index: .fill SIZEOF_STRUCT___1, 0
.segment CodeVeraHeap
  vera_heap_segment: .fill SIZEOF_STRUCT___2, 0
}