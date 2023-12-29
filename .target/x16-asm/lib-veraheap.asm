  // File Comments
  // Library
.namespace lib_veraheap {
  // Upstart
.cpu _65c02
  
#if __asm_import__
#else

#if __veraheap__

#else

.segmentdef Code                    [start=$80d]
.segmentdef CodeVeraHeap            [startAfter="Code"]
.segmentdef Data                    [startAfter="CodeVeraHeap"]
.segmentdef DataVeraHeap            [startAfter="Data"]

.segmentdef BramVeraHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]

:BasicUpstart(__lib_veraheap_start)

#endif
#endif
  // Global Constants & labels
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
  .const SIZEOF_STRUCT___2 = $a00
  .const SIZEOF_STRUCT___3 = $67
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
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __lib_veraheap_start
// void __lib_veraheap_start()
__lib_veraheap_start: {
    // __lib_veraheap_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __mem unsigned char veraheap_color = 0
    // [3] veraheap_color = 0 -- vbum1=vbuc1 
    lda #0
    sta veraheap_color
    // __lib_veraheap_start::@return
    // [4] return 
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
// __zp($2b) bool vera_heap_has_free(__zp($43) char s, __zp($2c) unsigned int size_requested)
vera_heap_has_free: {
    .label s = $43
    .label size_requested = $2c
    .label return = $2b
    .label packed_size = $16
    // bank_push_set_bram(vera_heap_segment.bram_bank)
    // [5] vera_heap_has_free::bank_push_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbuxx=_deref_pbuc1 
    ldx vera_heap_segment
    // vera_heap_has_free::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [7] BRAM = vera_heap_has_free::bank_push_set_bram1_bank#0 -- vbuz1=vbuxx 
    stx.z BRAM
    // vera_heap_has_free::@1
    // vera_heap_size_packed_t packed_size = vera_heap_alloc_size_get(size_requested)
    // [8] vera_heap_alloc_size_get::size#1 = vera_heap_has_free::size_requested -- vduz1=vwuz2 
    lda.z size_requested
    sta.z vera_heap_alloc_size_get.size
    lda.z size_requested+1
    sta.z vera_heap_alloc_size_get.size+1
    lda #0
    sta.z vera_heap_alloc_size_get.size+2
    sta.z vera_heap_alloc_size_get.size+3
    // [9] call vera_heap_alloc_size_get
  // Adjust given size to 8 bytes boundary (shift right with 5 bits).
    // [222] phi from vera_heap_has_free::@1 to vera_heap_alloc_size_get [phi:vera_heap_has_free::@1->vera_heap_alloc_size_get]
    // [222] phi vera_heap_alloc_size_get::size#2 = vera_heap_alloc_size_get::size#1 [phi:vera_heap_has_free::@1->vera_heap_alloc_size_get#0] -- register_copy 
    jsr vera_heap_alloc_size_get
    // vera_heap_size_packed_t packed_size = vera_heap_alloc_size_get(size_requested)
    // [10] vera_heap_alloc_size_get::return#1 = vera_heap_alloc_size_get::return#2
    // vera_heap_has_free::@3
    // [11] vera_heap_has_free::packed_size#0 = vera_heap_alloc_size_get::return#1
    // vera_heap_index_t free_index = vera_heap_find_best_fit(s, packed_size)
    // [12] vera_heap_find_best_fit::s#1 = vera_heap_has_free::s -- vbuxx=vbuz1 
    ldx.z s
    // [13] vera_heap_find_best_fit::requested_size#1 = vera_heap_has_free::packed_size#0
    // [14] call vera_heap_find_best_fit
    // [229] phi from vera_heap_has_free::@3 to vera_heap_find_best_fit [phi:vera_heap_has_free::@3->vera_heap_find_best_fit]
    // [229] phi vera_heap_find_best_fit::requested_size#6 = vera_heap_find_best_fit::requested_size#1 [phi:vera_heap_has_free::@3->vera_heap_find_best_fit#0] -- register_copy 
    // [229] phi vera_heap_find_best_fit::s#2 = vera_heap_find_best_fit::s#1 [phi:vera_heap_has_free::@3->vera_heap_find_best_fit#1] -- register_copy 
    jsr vera_heap_find_best_fit
    // vera_heap_index_t free_index = vera_heap_find_best_fit(s, packed_size)
    // [15] vera_heap_find_best_fit::return#1 = vera_heap_find_best_fit::return#3 -- vbuaa=vbuz1 
    lda.z vera_heap_find_best_fit.return
    // vera_heap_has_free::@4
    // [16] vera_heap_has_free::free_index#0 = vera_heap_find_best_fit::return#1
    // bool has_free = free_index != VERAHEAP_NULL
    // [17] vera_heap_has_free::has_free#0 = vera_heap_has_free::free_index#0 != $ff -- vboxx=vbuaa_neq_vbuc1 
    eor #$ff
    beq !+
    lda #1
  !:
    tax
    // vera_heap_has_free::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // vera_heap_has_free::@2
    // return has_free;
    // [19] vera_heap_has_free::return = vera_heap_has_free::has_free#0 -- vboz1=vboxx 
    txa
    sta.z return
    // vera_heap_has_free::@return
    // }
    // [20] return 
    rts
}
  // vera_heap_set_image
// void vera_heap_set_image(__zp($2e) char s, __zp($42) char index, __zp($44) unsigned int image)
vera_heap_set_image: {
    .label s = $2e
    .label index = $42
    .label image = $44
    // BYTE1(image)
    // [21] vera_heap_set_image::$0 = byte1  vera_heap_set_image::image -- vbuaa=_byte1_vwuz1 
    lda.z image+1
    // vera_heap_index.image1[index] = BYTE1(image)
    // [22] ((char *)&vera_heap_index+$100)[vera_heap_set_image::index] = vera_heap_set_image::$0 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z index
    sta vera_heap_index+$100,y
    // BYTE0(image)
    // [23] vera_heap_set_image::$1 = byte0  vera_heap_set_image::image -- vbuaa=_byte0_vwuz1 
    lda.z image
    // vera_heap_index.image0[index] = BYTE0(image)
    // [24] ((char *)&vera_heap_index)[vera_heap_set_image::index] = vera_heap_set_image::$1 -- pbuc1_derefidx_vbuz1=vbuaa 
    sta vera_heap_index,y
    // vera_heap_set_image::@return
    // }
    // [25] return 
    rts
}
  // vera_heap_get_image
// __zp(8) unsigned int vera_heap_get_image(__zp($48) char s, __zp($3c) char index)
vera_heap_get_image: {
    .label s = $48
    .label index = $3c
    .label return = 8
    .label vera_heap_get_image__0 = 8
    // MAKEWORD(vera_heap_index.image1[index], vera_heap_index.image0[index])
    // [26] vera_heap_get_image::$0 = ((char *)&vera_heap_index+$100)[vera_heap_get_image::index] w= ((char *)&vera_heap_index)[vera_heap_get_image::index] -- vwuz1=pbuc1_derefidx_vbuz2_word_pbuc2_derefidx_vbuz2 
    ldy.z index
    lda vera_heap_index+$100,y
    sta.z vera_heap_get_image__0+1
    lda vera_heap_index,y
    sta.z vera_heap_get_image__0
    // return MAKEWORD(vera_heap_index.image1[index], vera_heap_index.image0[index]);
    // [27] vera_heap_get_image::return = vera_heap_get_image::$0
    // vera_heap_get_image::@return
    // }
    // [28] return 
    rts
}
  // vera_heap_data_get_bank
// __zp($c) char vera_heap_data_get_bank(__zp($36) char s, __zp($3b) char index)
vera_heap_data_get_bank: {
    .label s = $36
    .label index = $3b
    .label return = $c
    // vera_heap_data_get_bank::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // vera_heap_data_get_bank::@1
    // bank_set_bram(vera_heap_segment.bram_bank)
    // [31] vera_heap_data_get_bank::bank_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbuaa=_deref_pbuc1 
    lda vera_heap_segment
    // vera_heap_data_get_bank::bank_set_bram1
    // BRAM = bank
    // [32] BRAM = vera_heap_data_get_bank::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // vera_heap_data_get_bank::@2
    // vram_bank_t vram_bank = vera_heap_index.data1[index] >> 5
    // [33] vera_heap_data_get_bank::vram_bank#0 = ((char *)&vera_heap_index+$300)[vera_heap_data_get_bank::index] >> 5 -- vbuxx=pbuc1_derefidx_vbuz1_ror_5 
    ldx.z index
    lda vera_heap_index+$300,x
    lsr
    lsr
    lsr
    lsr
    lsr
    tax
    // vera_heap_data_get_bank::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // vera_heap_data_get_bank::@3
    // return vram_bank;
    // [35] vera_heap_data_get_bank::return = vera_heap_data_get_bank::vram_bank#0 -- vbuz1=vbuxx 
    stx.z return
    // vera_heap_data_get_bank::@return
    // }
    // [36] return 
    rts
}
  // vera_heap_data_get_offset
// __zp($1c) unsigned int vera_heap_data_get_offset(__zp(7) char s, __zp($41) char index)
vera_heap_data_get_offset: {
    .label s = 7
    .label index = $41
    .label return = $1c
    .label vera_heap_data_get_offset__5 = $1c
    .label vram_offset = $1c
    // vera_heap_data_get_offset::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // vera_heap_data_get_offset::@1
    // bank_set_bram(vera_heap_segment.bram_bank)
    // [39] vera_heap_data_get_offset::bank_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbuaa=_deref_pbuc1 
    lda vera_heap_segment
    // vera_heap_data_get_offset::bank_set_bram1
    // BRAM = bank
    // [40] BRAM = vera_heap_data_get_offset::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // vera_heap_data_get_offset::@2
    // vera_heap_get_data_packed(s, index)
    // [41] vera_heap_get_data_packed::index#1 = vera_heap_data_get_offset::index -- vbuxx=vbuz1 
    ldx.z index
    // [42] call vera_heap_get_data_packed
    // [253] phi from vera_heap_data_get_offset::@2 to vera_heap_get_data_packed [phi:vera_heap_data_get_offset::@2->vera_heap_get_data_packed]
    // [253] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#1 [phi:vera_heap_data_get_offset::@2->vera_heap_get_data_packed#0] -- register_copy 
    jsr vera_heap_get_data_packed
    // vera_heap_get_data_packed(s, index)
    // [43] vera_heap_get_data_packed::return#13 = vera_heap_get_data_packed::return#1
    // vera_heap_data_get_offset::@4
    // vram_offset_t vram_offset = (vram_offset_t)vera_heap_get_data_packed(s, index) << 3
    // [44] vera_heap_data_get_offset::$5 = vera_heap_get_data_packed::return#13
    // [45] vera_heap_data_get_offset::vram_offset#0 = vera_heap_data_get_offset::$5 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vram_offset
    rol.z vram_offset+1
    asl.z vram_offset
    rol.z vram_offset+1
    asl.z vram_offset
    rol.z vram_offset+1
    // vera_heap_data_get_offset::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // vera_heap_data_get_offset::@3
    // return vram_offset;
    // [47] vera_heap_data_get_offset::return = vera_heap_data_get_offset::vram_offset#0
    // vera_heap_data_get_offset::@return
    // }
    // [48] return 
    rts
}
  // vera_heap_free
/**
 * @brief Free a memory block from the heap using the handle of allocated memory of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @param handle The handle referring to the heap memory block.
 * @return heap_handle 
 */
// void vera_heap_free(__zp($47) char s, __zp($41) char free_index)
vera_heap_free: {
    .label s = $47
    .label free_index = $41
    .label free_size = $30
    .label free_offset = $1c
    .label free_size_coalesced = $16
    .label free_bank_coalesced = $c
    .label free_offset_coalesced = $1c
    // vera_heap_free::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // vera_heap_free::@5
    // bank_set_bram(vera_heap_segment.bram_bank)
    // [51] vera_heap_free::bank_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbuaa=_deref_pbuc1 
    lda vera_heap_segment
    // vera_heap_free::bank_set_bram1
    // BRAM = bank
    // [52] BRAM = vera_heap_free::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // vera_heap_free::@6
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [53] vera_heap_get_size_packed::index#0 = vera_heap_free::free_index -- vbuxx=vbuz1 
    ldx.z free_index
    // [54] call vera_heap_get_size_packed
    // [256] phi from vera_heap_free::@6 to vera_heap_get_size_packed [phi:vera_heap_free::@6->vera_heap_get_size_packed]
    // [256] phi vera_heap_get_size_packed::index#8 = vera_heap_get_size_packed::index#0 [phi:vera_heap_free::@6->vera_heap_get_size_packed#0] -- register_copy 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [55] vera_heap_get_size_packed::return#0 = vera_heap_get_size_packed::return#12 -- vwuz1=vwuz2 
    lda.z vera_heap_get_size_packed.return_1
    sta.z vera_heap_get_size_packed.return
    lda.z vera_heap_get_size_packed.return_1+1
    sta.z vera_heap_get_size_packed.return+1
    // vera_heap_free::@7
    // [56] vera_heap_free::free_size#0 = vera_heap_get_size_packed::return#0
    // vera_heap_data_packed_t free_offset = vera_heap_get_data_packed(s, free_index)
    // [57] vera_heap_get_data_packed::index#0 = vera_heap_free::free_index -- vbuxx=vbuz1 
    ldx.z free_index
    // [58] call vera_heap_get_data_packed
    // [253] phi from vera_heap_free::@7 to vera_heap_get_data_packed [phi:vera_heap_free::@7->vera_heap_get_data_packed]
    // [253] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#0 [phi:vera_heap_free::@7->vera_heap_get_data_packed#0] -- register_copy 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t free_offset = vera_heap_get_data_packed(s, free_index)
    // [59] vera_heap_get_data_packed::return#0 = vera_heap_get_data_packed::return#1
    // vera_heap_free::@8
    // [60] vera_heap_free::free_offset#0 = vera_heap_get_data_packed::return#0
    // vera_heap_heap_remove(s, free_index)
    // [61] vera_heap_heap_remove::s#0 = vera_heap_free::s -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_heap_remove.s
    // [62] vera_heap_heap_remove::heap_index#0 = vera_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z vera_heap_heap_remove.heap_index
    // [63] call vera_heap_heap_remove
    // TODO: only remove allocated indexes!
    jsr vera_heap_heap_remove
    // vera_heap_free::@9
    // vera_heap_free_insert(s, free_index, free_offset, free_size)
    // [64] vera_heap_free_insert::s#0 = vera_heap_free::s -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_free_insert.s
    // [65] vera_heap_free_insert::free_index#0 = vera_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z vera_heap_free_insert.free_index
    // [66] vera_heap_free_insert::data#0 = vera_heap_free::free_offset#0 -- vwuz1=vwuz2 
    lda.z free_offset
    sta.z vera_heap_free_insert.data
    lda.z free_offset+1
    sta.z vera_heap_free_insert.data+1
    // [67] vera_heap_free_insert::size#0 = vera_heap_free::free_size#0 -- vwuz1=vwuz2 
    lda.z free_size
    sta.z vera_heap_free_insert.size
    lda.z free_size+1
    sta.z vera_heap_free_insert.size+1
    // [68] call vera_heap_free_insert
    jsr vera_heap_free_insert
    // vera_heap_free::@10
    // vera_heap_index_t free_left_index = vera_heap_can_coalesce_left(s, free_index)
    // [69] vera_heap_can_coalesce_left::heap_index#0 = vera_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z vera_heap_can_coalesce_left.heap_index
    // [70] call vera_heap_can_coalesce_left
    jsr vera_heap_can_coalesce_left
    // [71] vera_heap_can_coalesce_left::return#0 = vera_heap_can_coalesce_left::return#3
    // vera_heap_free::@11
    // [72] vera_heap_free::free_left_index#0 = vera_heap_can_coalesce_left::return#0
    // if(free_left_index != VERAHEAP_NULL)
    // [73] if(vera_heap_free::free_left_index#0==$ff) goto vera_heap_free::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #$ff
    beq __b1
    // vera_heap_free::@3
    // vera_heap_coalesce(s, free_left_index, free_index)
    // [74] vera_heap_coalesce::s#0 = vera_heap_free::s -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_coalesce.s
    // [75] vera_heap_coalesce::left_index#0 = vera_heap_free::free_left_index#0 -- vbuz1=vbuyy 
    sty.z vera_heap_coalesce.left_index
    // [76] vera_heap_coalesce::right_index#0 = vera_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z vera_heap_coalesce.right_index
    // [77] call vera_heap_coalesce
    // [308] phi from vera_heap_free::@3 to vera_heap_coalesce [phi:vera_heap_free::@3->vera_heap_coalesce]
    // [308] phi vera_heap_coalesce::left_index#10 = vera_heap_coalesce::left_index#0 [phi:vera_heap_free::@3->vera_heap_coalesce#0] -- register_copy 
    // [308] phi vera_heap_coalesce::right_index#10 = vera_heap_coalesce::right_index#0 [phi:vera_heap_free::@3->vera_heap_coalesce#1] -- register_copy 
    // [308] phi vera_heap_coalesce::s#10 = vera_heap_coalesce::s#0 [phi:vera_heap_free::@3->vera_heap_coalesce#2] -- register_copy 
    jsr vera_heap_coalesce
    // vera_heap_coalesce(s, free_left_index, free_index)
    // [78] vera_heap_coalesce::return#0 = vera_heap_coalesce::right_index#10 -- vbuaa=vbuz1 
    lda.z vera_heap_coalesce.right_index
    // vera_heap_free::@13
    // [79] vera_heap_free::$17 = vera_heap_coalesce::return#0
    // free_index = vera_heap_coalesce(s, free_left_index, free_index)
    // [80] vera_heap_free::free_index = vera_heap_free::$17 -- vbuz1=vbuaa 
    sta.z free_index
    // vera_heap_free::@1
  __b1:
    // vera_heap_index_t free_right_index = heap_can_coalesce_right(s, free_index)
    // [81] heap_can_coalesce_right::heap_index#0 = vera_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z heap_can_coalesce_right.heap_index
    // [82] call heap_can_coalesce_right
    jsr heap_can_coalesce_right
    // [83] heap_can_coalesce_right::return#0 = heap_can_coalesce_right::return#3 -- vbuaa=vbuz1 
    lda.z heap_can_coalesce_right.return
    // vera_heap_free::@12
    // [84] vera_heap_free::free_right_index#0 = heap_can_coalesce_right::return#0 -- vbuxx=vbuaa 
    tax
    // if(free_right_index != VERAHEAP_NULL)
    // [85] if(vera_heap_free::free_right_index#0==$ff) goto vera_heap_free::@2 -- vbuxx_eq_vbuc1_then_la1 
    cpx #$ff
    beq __b2
    // vera_heap_free::@4
    // vera_heap_coalesce(s, free_index, free_right_index)
    // [86] vera_heap_coalesce::s#1 = vera_heap_free::s -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_coalesce.s
    // [87] vera_heap_coalesce::left_index#1 = vera_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z vera_heap_coalesce.left_index
    // [88] vera_heap_coalesce::right_index#1 = vera_heap_free::free_right_index#0 -- vbuz1=vbuxx 
    stx.z vera_heap_coalesce.right_index
    // [89] call vera_heap_coalesce
    // [308] phi from vera_heap_free::@4 to vera_heap_coalesce [phi:vera_heap_free::@4->vera_heap_coalesce]
    // [308] phi vera_heap_coalesce::left_index#10 = vera_heap_coalesce::left_index#1 [phi:vera_heap_free::@4->vera_heap_coalesce#0] -- register_copy 
    // [308] phi vera_heap_coalesce::right_index#10 = vera_heap_coalesce::right_index#1 [phi:vera_heap_free::@4->vera_heap_coalesce#1] -- register_copy 
    // [308] phi vera_heap_coalesce::s#10 = vera_heap_coalesce::s#1 [phi:vera_heap_free::@4->vera_heap_coalesce#2] -- register_copy 
    jsr vera_heap_coalesce
    // vera_heap_coalesce(s, free_index, free_right_index)
    // [90] vera_heap_coalesce::return#1 = vera_heap_coalesce::right_index#10 -- vbuaa=vbuz1 
    lda.z vera_heap_coalesce.right_index
    // vera_heap_free::@16
    // [91] vera_heap_free::$18 = vera_heap_coalesce::return#1
    // free_index = vera_heap_coalesce(s, free_index, free_right_index)
    // [92] vera_heap_free::free_index = vera_heap_free::$18 -- vbuz1=vbuaa 
    sta.z free_index
    // vera_heap_free::@2
  __b2:
    // vera_heap_size_int_t free_size_coalesced = vera_heap_get_size_int(s, free_index)
    // [93] vera_heap_get_size_int::index#0 = vera_heap_free::free_index -- vbuxx=vbuz1 
    ldx.z free_index
    // [94] call vera_heap_get_size_int
    // [383] phi from vera_heap_free::@2 to vera_heap_get_size_int [phi:vera_heap_free::@2->vera_heap_get_size_int]
    jsr vera_heap_get_size_int
    // vera_heap_size_int_t free_size_coalesced = vera_heap_get_size_int(s, free_index)
    // [95] vera_heap_get_size_int::return#0 = vera_heap_get_size_int::return#1
    // vera_heap_free::@14
    // [96] vera_heap_free::free_size_coalesced#0 = vera_heap_get_size_int::return#0
    // vera_heap_bank_t free_bank_coalesced = vera_heap_data_get_bank(s, free_index)
    // [97] vera_heap_data_get_bank::s = vera_heap_free::s -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_data_get_bank.s
    // [98] vera_heap_data_get_bank::index = vera_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z vera_heap_data_get_bank.index
    // [99] callexecute vera_heap_data_get_bank  -- call_var_near 
    jsr vera_heap_data_get_bank
    // [100] vera_heap_free::free_bank_coalesced#0 = vera_heap_data_get_bank::return
    // vera_heap_offset_t free_offset_coalesced = vera_heap_data_get_offset(s, free_index)
    // [101] vera_heap_data_get_offset::s = vera_heap_free::s -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_data_get_offset.s
    // [102] vera_heap_data_get_offset::index = vera_heap_free::free_index
    // [103] callexecute vera_heap_data_get_offset  -- call_var_near 
    jsr vera_heap_data_get_offset
    // [104] vera_heap_free::free_offset_coalesced#0 = vera_heap_data_get_offset::return
    // memset_vram(free_bank_coalesced, free_offset_coalesced, veraheap_color++, free_size_coalesced)
    // [105] memset_vram::dbank_vram#0 = vera_heap_free::free_bank_coalesced#0 -- vbuxx=vbuz1 
    ldx.z free_bank_coalesced
    // [106] memset_vram::doffset_vram#0 = vera_heap_free::free_offset_coalesced#0 -- vwuz1=vwuz2 
    lda.z free_offset_coalesced
    sta.z memset_vram.doffset_vram
    lda.z free_offset_coalesced+1
    sta.z memset_vram.doffset_vram+1
    // [107] memset_vram::data#0 = veraheap_color -- vbuyy=vbum1 
    ldy veraheap_color
    // [108] memset_vram::num#0 = vera_heap_free::free_size_coalesced#0 -- vwuz1=vwuz2 
    lda.z free_size_coalesced
    sta.z memset_vram.num
    lda.z free_size_coalesced+1
    sta.z memset_vram.num+1
    // [109] call memset_vram
    jsr memset_vram
    // vera_heap_free::@15
    // memset_vram(free_bank_coalesced, free_offset_coalesced, veraheap_color++, free_size_coalesced);
    // [110] veraheap_color = ++ veraheap_color -- vbum1=_inc_vbum1 
    inc veraheap_color
    // vera_heap_segment.freeSize[s] += free_size
    // [111] vera_heap_free::$19 = vera_heap_free::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [112] ((unsigned int *)&vera_heap_segment+$5e)[vera_heap_free::$19] = ((unsigned int *)&vera_heap_segment+$5e)[vera_heap_free::$19] + vera_heap_free::free_size#0 -- pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_plus_vwuz1 
    tay
    lda vera_heap_segment+$5e,y
    clc
    adc.z free_size
    sta vera_heap_segment+$5e,y
    lda vera_heap_segment+$5e+1,y
    adc.z free_size+1
    sta vera_heap_segment+$5e+1,y
    // vera_heap_segment.heapSize[s] -= free_size
    // [113] vera_heap_free::$20 = vera_heap_free::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [114] ((unsigned int *)&vera_heap_segment+$56)[vera_heap_free::$20] = ((unsigned int *)&vera_heap_segment+$56)[vera_heap_free::$20] - vera_heap_free::free_size#0 -- pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_minus_vwuz1 
    tay
    lda vera_heap_segment+$56,y
    sec
    sbc.z free_size
    sta vera_heap_segment+$56,y
    lda vera_heap_segment+$56+1,y
    sbc.z free_size+1
    sta vera_heap_segment+$56+1,y
    // vera_heap_free::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // vera_heap_free::@return
    // }
    // [116] return 
    rts
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
// __zp(4) char vera_heap_alloc(__zp($46) char s, __zp($1e) unsigned long size)
vera_heap_alloc: {
    .label s = $46
    .label size = $1e
    .label return = 4
    .label packed_size = $3d
    // vera_heap_alloc::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // vera_heap_alloc::@2
    // bank_set_bram(vera_heap_segment.bram_bank)
    // [119] vera_heap_alloc::bank_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbuaa=_deref_pbuc1 
    lda vera_heap_segment
    // vera_heap_alloc::bank_set_bram1
    // BRAM = bank
    // [120] BRAM = vera_heap_alloc::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // vera_heap_alloc::@3
    // vera_heap_size_packed_t packed_size = vera_heap_alloc_size_get(size)
    // [121] vera_heap_alloc_size_get::size#0 = vera_heap_alloc::size
    // [122] call vera_heap_alloc_size_get
  // Adjust given size to 8 bytes boundary (shift right with 3 bits).
    // [222] phi from vera_heap_alloc::@3 to vera_heap_alloc_size_get [phi:vera_heap_alloc::@3->vera_heap_alloc_size_get]
    // [222] phi vera_heap_alloc_size_get::size#2 = vera_heap_alloc_size_get::size#0 [phi:vera_heap_alloc::@3->vera_heap_alloc_size_get#0] -- register_copy 
    jsr vera_heap_alloc_size_get
    // vera_heap_size_packed_t packed_size = vera_heap_alloc_size_get(size)
    // [123] vera_heap_alloc_size_get::return#0 = vera_heap_alloc_size_get::return#2 -- vwuz1=vwuz2 
    lda.z vera_heap_alloc_size_get.return_1
    sta.z vera_heap_alloc_size_get.return
    lda.z vera_heap_alloc_size_get.return_1+1
    sta.z vera_heap_alloc_size_get.return+1
    // vera_heap_alloc::@5
    // [124] vera_heap_alloc::packed_size#0 = vera_heap_alloc_size_get::return#0
    // vera_heap_index_t free_index = vera_heap_find_best_fit(s, packed_size)
    // [125] vera_heap_find_best_fit::s#0 = vera_heap_alloc::s -- vbuxx=vbuz1 
    ldx.z s
    // [126] vera_heap_find_best_fit::requested_size#0 = vera_heap_alloc::packed_size#0 -- vwuz1=vwuz2 
    lda.z packed_size
    sta.z vera_heap_find_best_fit.requested_size
    lda.z packed_size+1
    sta.z vera_heap_find_best_fit.requested_size+1
    // [127] call vera_heap_find_best_fit
    // [229] phi from vera_heap_alloc::@5 to vera_heap_find_best_fit [phi:vera_heap_alloc::@5->vera_heap_find_best_fit]
    // [229] phi vera_heap_find_best_fit::requested_size#6 = vera_heap_find_best_fit::requested_size#0 [phi:vera_heap_alloc::@5->vera_heap_find_best_fit#0] -- register_copy 
    // [229] phi vera_heap_find_best_fit::s#2 = vera_heap_find_best_fit::s#0 [phi:vera_heap_alloc::@5->vera_heap_find_best_fit#1] -- register_copy 
    jsr vera_heap_find_best_fit
    // vera_heap_index_t free_index = vera_heap_find_best_fit(s, packed_size)
    // [128] vera_heap_find_best_fit::return#0 = vera_heap_find_best_fit::return#3 -- vbuaa=vbuz1 
    lda.z vera_heap_find_best_fit.return
    // vera_heap_alloc::@6
    // [129] vera_heap_alloc::free_index#0 = vera_heap_find_best_fit::return#0 -- vbuxx=vbuaa 
    tax
    // if(free_index != VERAHEAP_NULL)
    // [130] if(vera_heap_alloc::free_index#0!=$ff) goto vera_heap_alloc::@1 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$ff
    bne __b1
    // [131] phi from vera_heap_alloc::@6 to vera_heap_alloc::bank_pull_bram1 [phi:vera_heap_alloc::@6->vera_heap_alloc::bank_pull_bram1]
    // [131] phi vera_heap_alloc::heap_index#3 = $ff [phi:vera_heap_alloc::@6->vera_heap_alloc::bank_pull_bram1#0] -- vbuxx=vbuc1 
    ldx #$ff
    // vera_heap_alloc::bank_pull_bram1
  bank_pull_bram1:
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // vera_heap_alloc::@4
    // return heap_index;
    // [133] vera_heap_alloc::return = vera_heap_alloc::heap_index#3 -- vbuz1=vbuxx 
    stx.z return
    // vera_heap_alloc::@return
    // }
    // [134] return 
    rts
    // vera_heap_alloc::@1
  __b1:
    // vera_heap_allocate(s, free_index, packed_size)
    // [135] vera_heap_allocate::s#0 = vera_heap_alloc::s -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_allocate.s
    // [136] vera_heap_allocate::free_index#0 = vera_heap_alloc::free_index#0 -- vbuz1=vbuxx 
    stx.z vera_heap_allocate.free_index
    // [137] vera_heap_allocate::required_size#0 = vera_heap_alloc::packed_size#0 -- vwuz1=vwuz2 
    lda.z packed_size
    sta.z vera_heap_allocate.required_size
    lda.z packed_size+1
    sta.z vera_heap_allocate.required_size+1
    // [138] call vera_heap_allocate
    jsr vera_heap_allocate
    // [139] vera_heap_allocate::return#0 = vera_heap_allocate::return#4
    // vera_heap_alloc::@7
    // heap_index = vera_heap_allocate(s, free_index, packed_size)
    // [140] vera_heap_alloc::heap_index#1 = vera_heap_allocate::return#0 -- vbuxx=vbuaa 
    tax
    // vera_heap_segment.freeSize[s] -= packed_size
    // [141] vera_heap_alloc::$7 = vera_heap_alloc::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [142] ((unsigned int *)&vera_heap_segment+$5e)[vera_heap_alloc::$7] = ((unsigned int *)&vera_heap_segment+$5e)[vera_heap_alloc::$7] - vera_heap_alloc::packed_size#0 -- pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_minus_vwuz1 
    tay
    lda vera_heap_segment+$5e,y
    sec
    sbc.z packed_size
    sta vera_heap_segment+$5e,y
    lda vera_heap_segment+$5e+1,y
    sbc.z packed_size+1
    sta vera_heap_segment+$5e+1,y
    // vera_heap_segment.heapSize[s] += packed_size
    // [143] vera_heap_alloc::$8 = vera_heap_alloc::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [144] ((unsigned int *)&vera_heap_segment+$56)[vera_heap_alloc::$8] = ((unsigned int *)&vera_heap_segment+$56)[vera_heap_alloc::$8] + vera_heap_alloc::packed_size#0 -- pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_plus_vwuz1 
    tay
    lda vera_heap_segment+$56,y
    clc
    adc.z packed_size
    sta vera_heap_segment+$56,y
    lda vera_heap_segment+$56+1,y
    adc.z packed_size+1
    sta vera_heap_segment+$56+1,y
    // [131] phi from vera_heap_alloc::@7 to vera_heap_alloc::bank_pull_bram1 [phi:vera_heap_alloc::@7->vera_heap_alloc::bank_pull_bram1]
    // [131] phi vera_heap_alloc::heap_index#3 = vera_heap_alloc::heap_index#1 [phi:vera_heap_alloc::@7->vera_heap_alloc::bank_pull_bram1#0] -- register_copy 
    jmp bank_pull_bram1
}
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
// __zp($2e) char vera_heap_segment_init(__zp($2e) char s, __zp($40) char vram_bank_floor, __zp($16) unsigned int vram_offset_floor, __zp($41) char vram_bank_ceil, __zp($3d) unsigned int vram_offset_ceil)
vera_heap_segment_init: {
    .label s = $2e
    .label vram_bank_floor = $40
    .label vram_offset_floor = $16
    .label vram_bank_ceil = $41
    .label vram_offset_ceil = $3d
    .label return = $2e
    .label vera_heap_segment_init__0 = $16
    .label vera_heap_segment_init__1 = $16
    .label free_size = $28
    .label bank_old = $48
    .label free_index = $3c
    // vera_heap_segment.vram_bank_floor[s] = vram_bank_floor
    // [145] ((char *)&vera_heap_segment+2)[vera_heap_segment_init::s] = vera_heap_segment_init::vram_bank_floor -- pbuc1_derefidx_vbuz1=vbuz2 
    // TODO initialize segment to all zero
    lda.z vram_bank_floor
    ldy.z s
    sta vera_heap_segment+2,y
    // vera_heap_segment.vram_offset_floor[s] = vram_offset_floor
    // [146] vera_heap_segment_init::$14 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [147] ((unsigned int *)&vera_heap_segment+6)[vera_heap_segment_init::$14] = vera_heap_segment_init::vram_offset_floor -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z vram_offset_floor
    sta vera_heap_segment+6,y
    lda.z vram_offset_floor+1
    sta vera_heap_segment+6+1,y
    // vera_heap_segment.vram_bank_ceil[s] = vram_bank_ceil
    // [148] ((char *)&vera_heap_segment+$16)[vera_heap_segment_init::s] = vera_heap_segment_init::vram_bank_ceil -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z vram_bank_ceil
    ldy.z s
    sta vera_heap_segment+$16,y
    // vera_heap_segment.vram_offset_ceil[s] = vram_offset_ceil
    // [149] vera_heap_segment_init::$15 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [150] ((unsigned int *)&vera_heap_segment+$1a)[vera_heap_segment_init::$15] = vera_heap_segment_init::vram_offset_ceil -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z vram_offset_ceil
    sta vera_heap_segment+$1a,y
    lda.z vram_offset_ceil+1
    sta vera_heap_segment+$1a+1,y
    // vera_heap_data_pack(vram_bank_floor, vram_offset_floor)
    // [151] vera_heap_data_pack::vram_bank#0 = vera_heap_segment_init::vram_bank_floor -- vbuxx=vbuz1 
    ldx.z vram_bank_floor
    // [152] vera_heap_data_pack::vram_offset#0 = vera_heap_segment_init::vram_offset_floor
    // [153] call vera_heap_data_pack
    // [425] phi from vera_heap_segment_init to vera_heap_data_pack [phi:vera_heap_segment_init->vera_heap_data_pack]
    // [425] phi vera_heap_data_pack::vram_offset#2 = vera_heap_data_pack::vram_offset#0 [phi:vera_heap_segment_init->vera_heap_data_pack#0] -- register_copy 
    // [425] phi vera_heap_data_pack::vram_bank#2 = vera_heap_data_pack::vram_bank#0 [phi:vera_heap_segment_init->vera_heap_data_pack#1] -- register_copy 
    jsr vera_heap_data_pack
    // vera_heap_data_pack(vram_bank_floor, vram_offset_floor)
    // [154] vera_heap_data_pack::return#0 = vera_heap_data_pack::return#2
    // vera_heap_segment_init::@4
    // [155] vera_heap_segment_init::$0 = vera_heap_data_pack::return#0
    // vera_heap_segment.floor[s] = vera_heap_data_pack(vram_bank_floor, vram_offset_floor)
    // [156] vera_heap_segment_init::$16 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [157] ((unsigned int *)&vera_heap_segment+$e)[vera_heap_segment_init::$16] = vera_heap_segment_init::$0 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z vera_heap_segment_init__0
    sta vera_heap_segment+$e,y
    lda.z vera_heap_segment_init__0+1
    sta vera_heap_segment+$e+1,y
    // vera_heap_data_pack(vram_bank_ceil, vram_offset_ceil)
    // [158] vera_heap_data_pack::vram_bank#1 = vera_heap_segment_init::vram_bank_ceil -- vbuxx=vbuz1 
    ldx.z vram_bank_ceil
    // [159] vera_heap_data_pack::vram_offset#1 = vera_heap_segment_init::vram_offset_ceil -- vwuz1=vwuz2 
    lda.z vram_offset_ceil
    sta.z vera_heap_data_pack.vram_offset
    lda.z vram_offset_ceil+1
    sta.z vera_heap_data_pack.vram_offset+1
    // [160] call vera_heap_data_pack
    // [425] phi from vera_heap_segment_init::@4 to vera_heap_data_pack [phi:vera_heap_segment_init::@4->vera_heap_data_pack]
    // [425] phi vera_heap_data_pack::vram_offset#2 = vera_heap_data_pack::vram_offset#1 [phi:vera_heap_segment_init::@4->vera_heap_data_pack#0] -- register_copy 
    // [425] phi vera_heap_data_pack::vram_bank#2 = vera_heap_data_pack::vram_bank#1 [phi:vera_heap_segment_init::@4->vera_heap_data_pack#1] -- register_copy 
    jsr vera_heap_data_pack
    // vera_heap_data_pack(vram_bank_ceil, vram_offset_ceil)
    // [161] vera_heap_data_pack::return#1 = vera_heap_data_pack::return#2
    // vera_heap_segment_init::@5
    // [162] vera_heap_segment_init::$1 = vera_heap_data_pack::return#1
    // vera_heap_segment.ceil[s]  = vera_heap_data_pack(vram_bank_ceil, vram_offset_ceil)
    // [163] vera_heap_segment_init::$17 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [164] ((unsigned int *)&vera_heap_segment+$22)[vera_heap_segment_init::$17] = vera_heap_segment_init::$1 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z vera_heap_segment_init__1
    sta vera_heap_segment+$22,y
    lda.z vera_heap_segment_init__1+1
    sta vera_heap_segment+$22+1,y
    // vera_heap_segment.heap_offset[s] = 0
    // [165] vera_heap_segment_init::$18 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [166] ((unsigned int *)&vera_heap_segment+$36)[vera_heap_segment_init::$18] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta vera_heap_segment+$36,y
    sta vera_heap_segment+$36+1,y
    // vera_heap_size_packed_t free_size = vera_heap_segment.ceil[s]
    // [167] vera_heap_segment_init::$19 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [168] vera_heap_segment_init::free_size#0 = ((unsigned int *)&vera_heap_segment+$22)[vera_heap_segment_init::$19] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda vera_heap_segment+$22,y
    sta.z free_size
    lda vera_heap_segment+$22+1,y
    sta.z free_size+1
    // free_size -= vera_heap_segment.floor[s]
    // [169] vera_heap_segment_init::$20 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [170] vera_heap_segment_init::free_size#1 = vera_heap_segment_init::free_size#0 - ((unsigned int *)&vera_heap_segment+$e)[vera_heap_segment_init::$20] -- vwuz1=vwuz1_minus_pwuc1_derefidx_vbuaa 
    tay
    lda.z free_size
    sec
    sbc vera_heap_segment+$e,y
    sta.z free_size
    lda.z free_size+1
    sbc vera_heap_segment+$e+1,y
    sta.z free_size+1
    // vera_heap_segment.heapCount[s] = 0
    // [171] vera_heap_segment_init::$21 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [172] ((unsigned int *)&vera_heap_segment+$3e)[vera_heap_segment_init::$21] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta vera_heap_segment+$3e,y
    sta vera_heap_segment+$3e+1,y
    // vera_heap_segment.freeCount[s] = 0
    // [173] vera_heap_segment_init::$22 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [174] ((unsigned int *)&vera_heap_segment+$46)[vera_heap_segment_init::$22] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta vera_heap_segment+$46,y
    sta vera_heap_segment+$46+1,y
    // vera_heap_segment.idleCount[s] = 0
    // [175] vera_heap_segment_init::$23 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [176] ((unsigned int *)&vera_heap_segment+$4e)[vera_heap_segment_init::$23] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta vera_heap_segment+$4e,y
    sta vera_heap_segment+$4e+1,y
    // vera_heap_segment.heap_list[s] = VERAHEAP_NULL
    // [177] ((char *)&vera_heap_segment+$2a)[vera_heap_segment_init::s] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #$ff
    ldy.z s
    sta vera_heap_segment+$2a,y
    // vera_heap_segment.idle_list[s] = VERAHEAP_NULL
    // [178] ((char *)&vera_heap_segment+$32)[vera_heap_segment_init::s] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    sta vera_heap_segment+$32,y
    // vera_heap_segment.free_list[s] = VERAHEAP_NULL
    // [179] ((char *)&vera_heap_segment+$2e)[vera_heap_segment_init::s] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    sta vera_heap_segment+$2e,y
    // vera_heap_segment_init::bank_get_bram1
    // return BRAM;
    // [180] vera_heap_segment_init::bank_old#0 = BRAM -- vbuz1=vbuz2 
    lda.z BRAM
    sta.z bank_old
    // vera_heap_segment_init::@1
    // bank_set_bram(vera_heap_segment.bram_bank)
    // [181] vera_heap_segment_init::bank_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbuaa=_deref_pbuc1 
    lda vera_heap_segment
    // vera_heap_segment_init::bank_set_bram1
    // BRAM = bank
    // [182] BRAM = vera_heap_segment_init::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // vera_heap_segment_init::@2
    // vera_heap_index_t free_index = vera_heap_index_add(s)
    // [183] vera_heap_index_add::s#0 = vera_heap_segment_init::s -- vbuxx=vbuz1 
    ldx.z s
    // [184] call vera_heap_index_add
    // [431] phi from vera_heap_segment_init::@2 to vera_heap_index_add [phi:vera_heap_segment_init::@2->vera_heap_index_add]
    // [431] phi vera_heap_index_add::s#2 = vera_heap_index_add::s#0 [phi:vera_heap_segment_init::@2->vera_heap_index_add#0] -- register_copy 
    jsr vera_heap_index_add
    // vera_heap_index_t free_index = vera_heap_index_add(s)
    // [185] vera_heap_index_add::return#0 = vera_heap_index_add::return#1 -- vbuaa=vbuz1 
    lda.z vera_heap_index_add.return
    // vera_heap_segment_init::@6
    // [186] vera_heap_segment_init::free_index#0 = vera_heap_index_add::return#0 -- vbuxx=vbuaa 
    tax
    // vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, free_index)
    // [187] vera_heap_list_insert_at::list#0 = ((char *)&vera_heap_segment+$2e)[vera_heap_segment_init::s] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda vera_heap_segment+$2e,y
    sta.z vera_heap_list_insert_at.list
    // [188] vera_heap_list_insert_at::index#0 = vera_heap_segment_init::free_index#0 -- vbuz1=vbuxx 
    stx.z vera_heap_list_insert_at.index
    // [189] vera_heap_list_insert_at::at#0 = vera_heap_segment_init::free_index#0 -- vbuz1=vbuxx 
    stx.z vera_heap_list_insert_at.at
    // [190] call vera_heap_list_insert_at
    // [441] phi from vera_heap_segment_init::@6 to vera_heap_list_insert_at [phi:vera_heap_segment_init::@6->vera_heap_list_insert_at]
    // [441] phi vera_heap_list_insert_at::index#10 = vera_heap_list_insert_at::index#0 [phi:vera_heap_segment_init::@6->vera_heap_list_insert_at#0] -- register_copy 
    // [441] phi vera_heap_list_insert_at::at#10 = vera_heap_list_insert_at::at#0 [phi:vera_heap_segment_init::@6->vera_heap_list_insert_at#1] -- register_copy 
    // [441] phi vera_heap_list_insert_at::list#5 = vera_heap_list_insert_at::list#0 [phi:vera_heap_segment_init::@6->vera_heap_list_insert_at#2] -- register_copy 
    jsr vera_heap_list_insert_at
    // vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, free_index)
    // [191] vera_heap_list_insert_at::return#0 = vera_heap_list_insert_at::list#11 -- vbuaa=vbuz1 
    lda.z vera_heap_list_insert_at.list
    // vera_heap_segment_init::@7
    // free_index = vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, free_index)
    // [192] vera_heap_segment_init::free_index#1 = vera_heap_list_insert_at::return#0 -- vbuz1=vbuaa 
    sta.z free_index
    // vera_heap_set_data_packed(s, free_index, vera_heap_segment.floor[s])
    // [193] vera_heap_segment_init::$24 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [194] vera_heap_set_data_packed::index#0 = vera_heap_segment_init::free_index#1 -- vbuxx=vbuz1 
    ldx.z free_index
    // [195] vera_heap_set_data_packed::data_packed#0 = ((unsigned int *)&vera_heap_segment+$e)[vera_heap_segment_init::$24] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda vera_heap_segment+$e,y
    sta.z vera_heap_set_data_packed.data_packed
    lda vera_heap_segment+$e+1,y
    sta.z vera_heap_set_data_packed.data_packed+1
    // [196] call vera_heap_set_data_packed
    // [471] phi from vera_heap_segment_init::@7 to vera_heap_set_data_packed [phi:vera_heap_segment_init::@7->vera_heap_set_data_packed]
    // [471] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#0 [phi:vera_heap_segment_init::@7->vera_heap_set_data_packed#0] -- register_copy 
    // [471] phi vera_heap_set_data_packed::data_packed#7 = vera_heap_set_data_packed::data_packed#0 [phi:vera_heap_segment_init::@7->vera_heap_set_data_packed#1] -- register_copy 
    jsr vera_heap_set_data_packed
    // vera_heap_segment_init::@8
    // vera_heap_segment.ceil[s] - vera_heap_segment.floor[s]
    // [197] vera_heap_segment_init::$25 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // vera_heap_set_size_packed(s, free_index, vera_heap_segment.ceil[s] - vera_heap_segment.floor[s])
    // [198] vera_heap_set_size_packed::size_packed#0 = ((unsigned int *)&vera_heap_segment+$22)[vera_heap_segment_init::$25] - ((unsigned int *)&vera_heap_segment+$e)[vera_heap_segment_init::$25] -- vwuz1=pwuc1_derefidx_vbuaa_minus_pwuc2_derefidx_vbuaa 
    tay
    lda vera_heap_segment+$22,y
    sec
    sbc vera_heap_segment+$e,y
    sta.z vera_heap_set_size_packed.size_packed
    lda vera_heap_segment+$22+1,y
    sbc vera_heap_segment+$e+1,y
    sta.z vera_heap_set_size_packed.size_packed+1
    // [199] vera_heap_set_size_packed::index#0 = vera_heap_segment_init::free_index#1 -- vbuxx=vbuz1 
    ldx.z free_index
    // [200] call vera_heap_set_size_packed
    // [477] phi from vera_heap_segment_init::@8 to vera_heap_set_size_packed [phi:vera_heap_segment_init::@8->vera_heap_set_size_packed]
    // [477] phi vera_heap_set_size_packed::size_packed#6 = vera_heap_set_size_packed::size_packed#0 [phi:vera_heap_segment_init::@8->vera_heap_set_size_packed#0] -- register_copy 
    // [477] phi vera_heap_set_size_packed::index#6 = vera_heap_set_size_packed::index#0 [phi:vera_heap_segment_init::@8->vera_heap_set_size_packed#1] -- register_copy 
    jsr vera_heap_set_size_packed
    // vera_heap_segment_init::@9
    // vera_heap_set_free(s, free_index)
    // [201] vera_heap_set_free::index#0 = vera_heap_segment_init::free_index#1 -- vbuxx=vbuz1 
    ldx.z free_index
    // [202] call vera_heap_set_free
    // [486] phi from vera_heap_segment_init::@9 to vera_heap_set_free [phi:vera_heap_segment_init::@9->vera_heap_set_free]
    // [486] phi vera_heap_set_free::index#5 = vera_heap_set_free::index#0 [phi:vera_heap_segment_init::@9->vera_heap_set_free#0] -- register_copy 
    jsr vera_heap_set_free
    // vera_heap_segment_init::@10
    // vera_heap_set_next(s, free_index, free_index)
    // [203] vera_heap_set_next::index#0 = vera_heap_segment_init::free_index#1 -- vbuxx=vbuz1 
    ldx.z free_index
    // [204] vera_heap_set_next::next#0 = vera_heap_segment_init::free_index#1 -- vbuaa=vbuz1 
    txa
    // [205] call vera_heap_set_next
    // [489] phi from vera_heap_segment_init::@10 to vera_heap_set_next [phi:vera_heap_segment_init::@10->vera_heap_set_next]
    // [489] phi vera_heap_set_next::index#6 = vera_heap_set_next::index#0 [phi:vera_heap_segment_init::@10->vera_heap_set_next#0] -- register_copy 
    // [489] phi vera_heap_set_next::next#6 = vera_heap_set_next::next#0 [phi:vera_heap_segment_init::@10->vera_heap_set_next#1] -- register_copy 
    jsr vera_heap_set_next
    // vera_heap_segment_init::@11
    // vera_heap_set_prev(s, free_index, free_index)
    // [206] vera_heap_set_prev::index#0 = vera_heap_segment_init::free_index#1 -- vbuxx=vbuz1 
    ldx.z free_index
    // [207] vera_heap_set_prev::prev#0 = vera_heap_segment_init::free_index#1 -- vbuaa=vbuz1 
    txa
    // [208] call vera_heap_set_prev
    // [492] phi from vera_heap_segment_init::@11 to vera_heap_set_prev [phi:vera_heap_segment_init::@11->vera_heap_set_prev]
    // [492] phi vera_heap_set_prev::index#6 = vera_heap_set_prev::index#0 [phi:vera_heap_segment_init::@11->vera_heap_set_prev#0] -- register_copy 
    // [492] phi vera_heap_set_prev::prev#6 = vera_heap_set_prev::prev#0 [phi:vera_heap_segment_init::@11->vera_heap_set_prev#1] -- register_copy 
    jsr vera_heap_set_prev
    // vera_heap_segment_init::@12
    // vera_heap_segment.freeCount[s]++;
    // [209] vera_heap_segment_init::$27 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [210] ((unsigned int *)&vera_heap_segment+$46)[vera_heap_segment_init::$27] = ++ ((unsigned int *)&vera_heap_segment+$46)[vera_heap_segment_init::$27] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc vera_heap_segment+$46,x
    bne !+
    inc vera_heap_segment+$46+1,x
  !:
    // vera_heap_segment.free_list[s] = free_index
    // [211] ((char *)&vera_heap_segment+$2e)[vera_heap_segment_init::s] = vera_heap_segment_init::free_index#1 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z free_index
    ldy.z s
    sta vera_heap_segment+$2e,y
    // vera_heap_segment.freeSize[s] = free_size
    // [212] vera_heap_segment_init::$28 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [213] ((unsigned int *)&vera_heap_segment+$5e)[vera_heap_segment_init::$28] = vera_heap_segment_init::free_size#1 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z free_size
    sta vera_heap_segment+$5e,y
    lda.z free_size+1
    sta vera_heap_segment+$5e+1,y
    // vera_heap_segment.heapSize[s] = 0
    // [214] vera_heap_segment_init::$29 = vera_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [215] ((unsigned int *)&vera_heap_segment+$56)[vera_heap_segment_init::$29] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta vera_heap_segment+$56,y
    sta vera_heap_segment+$56+1,y
    // vera_heap_segment_init::bank_set_bram2
    // BRAM = bank
    // [216] BRAM = vera_heap_segment_init::bank_old#0 -- vbuz1=vbuz2 
    lda.z bank_old
    sta.z BRAM
    // vera_heap_segment_init::@3
    // return s;
    // [217] vera_heap_segment_init::return = vera_heap_segment_init::s
    // vera_heap_segment_init::@return
    // }
    // [218] return 
    rts
}
  // vera_heap_bram_bank_init
// void vera_heap_bram_bank_init(__zp($3f) char bram_bank)
vera_heap_bram_bank_init: {
    .label bram_bank = $3f
    // vera_heap_segment.bram_bank = bram_bank
    // [219] *((char *)&vera_heap_segment) = vera_heap_bram_bank_init::bram_bank -- _deref_pbuc1=vbuz1 
    lda.z bram_bank
    sta vera_heap_segment
    // vera_heap_segment.index_position = 0
    // [220] *((char *)&vera_heap_segment+1) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta vera_heap_segment+1
    // vera_heap_bram_bank_init::@return
    // }
    // [221] return 
    rts
}
  // vera_heap_alloc_size_get
/**
 * Returns total allocation size, aligned to 8;
 */
/* inline */
// __zp($16) unsigned int vera_heap_alloc_size_get(__zp($1e) unsigned long size)
vera_heap_alloc_size_get: {
    .label vera_heap_alloc_size_get__1 = $16
    .label size = $1e
    .label return = $3d
    .label return_1 = $16
    // vera_heap_size_pack(size-1)
    // [223] vera_heap_size_pack::size#0 = vera_heap_alloc_size_get::size#2 - 1 -- vduz1=vduz1_minus_1 
    sec
    lda.z vera_heap_size_pack.size
    sbc #1
    sta.z vera_heap_size_pack.size
    lda.z vera_heap_size_pack.size+1
    sbc #0
    sta.z vera_heap_size_pack.size+1
    lda.z vera_heap_size_pack.size+2
    sbc #0
    sta.z vera_heap_size_pack.size+2
    lda.z vera_heap_size_pack.size+3
    sbc #0
    sta.z vera_heap_size_pack.size+3
    // [224] call vera_heap_size_pack
    jsr vera_heap_size_pack
    // [225] vera_heap_size_pack::return#2 = vera_heap_size_pack::return#0
    // vera_heap_alloc_size_get::@1
    // [226] vera_heap_alloc_size_get::$1 = vera_heap_size_pack::return#2
    // return (vera_heap_size_packed_t)((vera_heap_size_pack(size-1) + 1));
    // [227] vera_heap_alloc_size_get::return#2 = vera_heap_alloc_size_get::$1 + 1 -- vwuz1=vwuz1_plus_1 
    inc.z return_1
    bne !+
    inc.z return_1+1
  !:
    // vera_heap_alloc_size_get::@return
    // }
    // [228] return 
    rts
}
  // vera_heap_find_best_fit
/**
 * Best-fit algorithm.
 */
// __zp(7) char vera_heap_find_best_fit(__register(X) char s, __zp($16) unsigned int requested_size)
vera_heap_find_best_fit: {
    .label requested_size = $16
    .label free_end = $11
    .label return = 7
    .label free_size = 8
    .label best_size = $d
    .label best_size_1 = 8
    .label best_index = 7
    // vera_heap_index_t free_index = vera_heap_segment.free_list[s]
    // [230] vera_heap_find_best_fit::free_index#0 = ((char *)&vera_heap_segment+$2e)[vera_heap_find_best_fit::s#2] -- vbuyy=pbuc1_derefidx_vbuxx 
    ldy vera_heap_segment+$2e,x
    // if(free_index == VERAHEAP_NULL)
    // [231] if(vera_heap_find_best_fit::free_index#0!=$ff) goto vera_heap_find_best_fit::@1 -- vbuyy_neq_vbuc1_then_la1 
    cpy #$ff
    bne __b1
    // [232] phi from vera_heap_find_best_fit vera_heap_find_best_fit::@2 to vera_heap_find_best_fit::@return [phi:vera_heap_find_best_fit/vera_heap_find_best_fit::@2->vera_heap_find_best_fit::@return]
  __b5:
    // [232] phi vera_heap_find_best_fit::return#3 = $ff [phi:vera_heap_find_best_fit/vera_heap_find_best_fit::@2->vera_heap_find_best_fit::@return#0] -- vbuz1=vbuc1 
    lda #$ff
    sta.z return
    // vera_heap_find_best_fit::@return
    // }
    // [233] return 
    rts
    // vera_heap_find_best_fit::@1
  __b1:
    // vera_heap_index_t free_end = vera_heap_segment.free_list[s]
    // [234] vera_heap_find_best_fit::free_end#0 = ((char *)&vera_heap_segment+$2e)[vera_heap_find_best_fit::s#2] -- vbuz1=pbuc1_derefidx_vbuxx 
    lda vera_heap_segment+$2e,x
    sta.z free_end
    // [235] phi from vera_heap_find_best_fit::@1 to vera_heap_find_best_fit::@3 [phi:vera_heap_find_best_fit::@1->vera_heap_find_best_fit::@3]
    // [235] phi vera_heap_find_best_fit::best_index#6 = $ff [phi:vera_heap_find_best_fit::@1->vera_heap_find_best_fit::@3#0] -- vbuz1=vbuc1 
    lda #$ff
    sta.z best_index
    // [235] phi vera_heap_find_best_fit::best_size#2 = $ffff [phi:vera_heap_find_best_fit::@1->vera_heap_find_best_fit::@3#1] -- vwuz1=vwuc1 
    lda #<$ffff
    sta.z best_size
    lda #>$ffff
    sta.z best_size+1
    // [235] phi vera_heap_find_best_fit::free_index#2 = vera_heap_find_best_fit::free_index#0 [phi:vera_heap_find_best_fit::@1->vera_heap_find_best_fit::@3#2] -- register_copy 
    // vera_heap_find_best_fit::@3
  __b3:
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [236] vera_heap_get_size_packed::index#5 = vera_heap_find_best_fit::free_index#2 -- vbuxx=vbuyy 
    tya
    tax
    // [237] call vera_heap_get_size_packed
  // O(n) search.
    // [256] phi from vera_heap_find_best_fit::@3 to vera_heap_get_size_packed [phi:vera_heap_find_best_fit::@3->vera_heap_get_size_packed]
    // [256] phi vera_heap_get_size_packed::index#8 = vera_heap_get_size_packed::index#5 [phi:vera_heap_find_best_fit::@3->vera_heap_get_size_packed#0] -- register_copy 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [238] vera_heap_get_size_packed::return#15 = vera_heap_get_size_packed::return#12
    // vera_heap_find_best_fit::@7
    // [239] vera_heap_find_best_fit::free_size#0 = vera_heap_get_size_packed::return#15
    // if(free_size >= requested_size && free_size < best_size)
    // [240] if(vera_heap_find_best_fit::free_size#0<vera_heap_find_best_fit::requested_size#6) goto vera_heap_find_best_fit::@11 -- vwuz1_lt_vwuz2_then_la1 
    lda.z free_size+1
    cmp.z requested_size+1
    bcc __b11
    bne !+
    lda.z free_size
    cmp.z requested_size
    bcc __b11
  !:
    // vera_heap_find_best_fit::@9
    // [241] if(vera_heap_find_best_fit::free_size#0>=vera_heap_find_best_fit::best_size#2) goto vera_heap_find_best_fit::@4 -- vwuz1_ge_vwuz2_then_la1 
    lda.z best_size+1
    cmp.z free_size+1
    bne !+
    lda.z best_size
    cmp.z free_size
    beq __b4
  !:
    bcc __b4
    // vera_heap_find_best_fit::@5
    // [242] vera_heap_find_best_fit::best_index#9 = vera_heap_find_best_fit::free_index#2 -- vbuz1=vbuyy 
    sty.z best_index
    // [243] phi from vera_heap_find_best_fit::@11 vera_heap_find_best_fit::@5 to vera_heap_find_best_fit::@4 [phi:vera_heap_find_best_fit::@11/vera_heap_find_best_fit::@5->vera_heap_find_best_fit::@4]
    // [243] phi vera_heap_find_best_fit::best_index#2 = vera_heap_find_best_fit::best_index#6 [phi:vera_heap_find_best_fit::@11/vera_heap_find_best_fit::@5->vera_heap_find_best_fit::@4#0] -- register_copy 
    // [243] phi vera_heap_find_best_fit::best_size#3 = vera_heap_find_best_fit::best_size#9 [phi:vera_heap_find_best_fit::@11/vera_heap_find_best_fit::@5->vera_heap_find_best_fit::@4#1] -- register_copy 
    // [243] phi from vera_heap_find_best_fit::@9 to vera_heap_find_best_fit::@4 [phi:vera_heap_find_best_fit::@9->vera_heap_find_best_fit::@4]
    // vera_heap_find_best_fit::@4
  __b4:
    // vera_heap_get_next(s, free_index)
    // [244] vera_heap_get_next::index#3 = vera_heap_find_best_fit::free_index#2 -- vbuxx=vbuyy 
    tya
    tax
    // [245] call vera_heap_get_next
    // [502] phi from vera_heap_find_best_fit::@4 to vera_heap_get_next [phi:vera_heap_find_best_fit::@4->vera_heap_get_next]
    // [502] phi vera_heap_get_next::index#4 = vera_heap_get_next::index#3 [phi:vera_heap_find_best_fit::@4->vera_heap_get_next#0] -- register_copy 
    jsr vera_heap_get_next
    // vera_heap_get_next(s, free_index)
    // [246] vera_heap_get_next::return#10 = vera_heap_get_next::return#3
    // vera_heap_find_best_fit::@8
    // free_index = vera_heap_get_next(s, free_index)
    // [247] vera_heap_find_best_fit::free_index#1 = vera_heap_get_next::return#10 -- vbuyy=vbuaa 
    tay
    // while(free_index != free_end)
    // [248] if(vera_heap_find_best_fit::free_index#1!=vera_heap_find_best_fit::free_end#0) goto vera_heap_find_best_fit::@10 -- vbuyy_neq_vbuz1_then_la1 
    cpy.z free_end
    bne __b10
    // vera_heap_find_best_fit::@6
    // if(requested_size <= best_size)
    // [249] if(vera_heap_find_best_fit::requested_size#6>vera_heap_find_best_fit::best_size#3) goto vera_heap_find_best_fit::@2 -- vwuz1_gt_vwuz2_then_la1 
    lda.z best_size_1+1
    cmp.z requested_size+1
    bcc __b5
    bne !+
    lda.z best_size_1
    cmp.z requested_size
    bcc __b5
  !:
    // [232] phi from vera_heap_find_best_fit::@6 to vera_heap_find_best_fit::@return [phi:vera_heap_find_best_fit::@6->vera_heap_find_best_fit::@return]
    // [232] phi vera_heap_find_best_fit::return#3 = vera_heap_find_best_fit::best_index#2 [phi:vera_heap_find_best_fit::@6->vera_heap_find_best_fit::@return#0] -- register_copy 
    rts
    // [250] phi from vera_heap_find_best_fit::@6 to vera_heap_find_best_fit::@2 [phi:vera_heap_find_best_fit::@6->vera_heap_find_best_fit::@2]
    // vera_heap_find_best_fit::@2
    // vera_heap_find_best_fit::@10
  __b10:
    // [251] vera_heap_find_best_fit::best_size#7 = vera_heap_find_best_fit::best_size#3 -- vwuz1=vwuz2 
    lda.z best_size_1
    sta.z best_size
    lda.z best_size_1+1
    sta.z best_size+1
    // [235] phi from vera_heap_find_best_fit::@10 to vera_heap_find_best_fit::@3 [phi:vera_heap_find_best_fit::@10->vera_heap_find_best_fit::@3]
    // [235] phi vera_heap_find_best_fit::best_index#6 = vera_heap_find_best_fit::best_index#2 [phi:vera_heap_find_best_fit::@10->vera_heap_find_best_fit::@3#0] -- register_copy 
    // [235] phi vera_heap_find_best_fit::best_size#2 = vera_heap_find_best_fit::best_size#7 [phi:vera_heap_find_best_fit::@10->vera_heap_find_best_fit::@3#1] -- register_copy 
    // [235] phi vera_heap_find_best_fit::free_index#2 = vera_heap_find_best_fit::free_index#1 [phi:vera_heap_find_best_fit::@10->vera_heap_find_best_fit::@3#2] -- register_copy 
    jmp __b3
    // vera_heap_find_best_fit::@11
  __b11:
    // [252] vera_heap_find_best_fit::best_size#9 = vera_heap_find_best_fit::best_size#2 -- vwuz1=vwuz2 
    lda.z best_size
    sta.z best_size_1
    lda.z best_size+1
    sta.z best_size_1+1
    jmp __b4
}
  // vera_heap_get_data_packed
// __zp($24) unsigned int vera_heap_get_data_packed(char s, __register(X) char index)
vera_heap_get_data_packed: {
    .label return = $1c
    .label return_1 = $2c
    .label return_2 = $1a
    .label return_3 = $18
    .label return_4 = $28
    .label return_5 = $d
    .label return_6 = $24
    // MAKEWORD(vera_heap_index.data1[index], vera_heap_index.data0[index])
    // [254] vera_heap_get_data_packed::return#1 = ((char *)&vera_heap_index+$300)[vera_heap_get_data_packed::index#9] w= ((char *)&vera_heap_index+$200)[vera_heap_get_data_packed::index#9] -- vwuz1=pbuc1_derefidx_vbuxx_word_pbuc2_derefidx_vbuxx 
    lda vera_heap_index+$300,x
    sta.z return+1
    lda vera_heap_index+$200,x
    sta.z return
    // vera_heap_get_data_packed::@return
    // }
    // [255] return 
    rts
}
  // vera_heap_get_size_packed
// __zp(8) unsigned int vera_heap_get_size_packed(char s, __register(X) char index)
vera_heap_get_size_packed: {
    .label return = $30
    .label return_1 = 8
    // vera_heap_index.size1[index] & 0x7F
    // [257] vera_heap_get_size_packed::$0 = ((char *)&vera_heap_index+$500)[vera_heap_get_size_packed::index#8] & $7f -- vbuaa=pbuc1_derefidx_vbuxx_band_vbuc2 
    lda #$7f
    and vera_heap_index+$500,x
    // MAKEWORD(vera_heap_index.size1[index] & 0x7F, vera_heap_index.size0[index])
    // [258] vera_heap_get_size_packed::return#12 = vera_heap_get_size_packed::$0 w= ((char *)&vera_heap_index+$400)[vera_heap_get_size_packed::index#8] -- vwuz1=vbuaa_word_pbuc1_derefidx_vbuxx 
    sta.z return_1+1
    lda vera_heap_index+$400,x
    sta.z return_1
    // vera_heap_get_size_packed::@return
    // }
    // [259] return 
    rts
}
  // vera_heap_heap_remove
// void vera_heap_heap_remove(__zp($26) char s, __zp(4) char heap_index)
vera_heap_heap_remove: {
    .label s = $26
    .label heap_index = 4
    // vera_heap_segment.heapCount[s]--;
    // [260] vera_heap_heap_remove::$3 = vera_heap_heap_remove::s#0 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [261] ((unsigned int *)&vera_heap_segment+$3e)[vera_heap_heap_remove::$3] = -- ((unsigned int *)&vera_heap_segment+$3e)[vera_heap_heap_remove::$3] -- pwuc1_derefidx_vbuaa=_dec_pwuc1_derefidx_vbuaa 
    tax
    lda vera_heap_segment+$3e,x
    bne !+
    dec vera_heap_segment+$3e+1,x
  !:
    dec vera_heap_segment+$3e,x
    // vera_heap_list_remove(s, vera_heap_segment.heap_list[s], heap_index)
    // [262] vera_heap_list_remove::list#2 = ((char *)&vera_heap_segment+$2a)[vera_heap_heap_remove::s#0] -- vbuyy=pbuc1_derefidx_vbuz1 
    ldx.z s
    ldy vera_heap_segment+$2a,x
    // [263] vera_heap_list_remove::index#0 = vera_heap_heap_remove::heap_index#0
    // [264] call vera_heap_list_remove
    // [505] phi from vera_heap_heap_remove to vera_heap_list_remove [phi:vera_heap_heap_remove->vera_heap_list_remove]
    // [505] phi vera_heap_list_remove::index#10 = vera_heap_list_remove::index#0 [phi:vera_heap_heap_remove->vera_heap_list_remove#0] -- register_copy 
    // [505] phi vera_heap_list_remove::list#10 = vera_heap_list_remove::list#2 [phi:vera_heap_heap_remove->vera_heap_list_remove#1] -- register_copy 
    jsr vera_heap_list_remove
    // vera_heap_list_remove(s, vera_heap_segment.heap_list[s], heap_index)
    // [265] vera_heap_list_remove::return#4 = vera_heap_list_remove::return#1 -- vbuaa=vbuyy 
    tya
    // vera_heap_heap_remove::@1
    // [266] vera_heap_heap_remove::$1 = vera_heap_list_remove::return#4
    // vera_heap_segment.heap_list[s] = vera_heap_list_remove(s, vera_heap_segment.heap_list[s], heap_index)
    // [267] ((char *)&vera_heap_segment+$2a)[vera_heap_heap_remove::s#0] = vera_heap_heap_remove::$1 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z s
    sta vera_heap_segment+$2a,y
    // vera_heap_heap_remove::@return
    // }
    // [268] return 
    rts
}
  // vera_heap_free_insert
// char vera_heap_free_insert(__zp($3f) char s, __zp($40) char free_index, __zp($d) unsigned int data, __zp($16) unsigned int size)
vera_heap_free_insert: {
    .label s = $3f
    .label free_index = $40
    .label data = $d
    .label size = $16
    // vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, vera_heap_segment.free_list[s])
    // [269] vera_heap_list_insert_at::list#3 = ((char *)&vera_heap_segment+$2e)[vera_heap_free_insert::s#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda vera_heap_segment+$2e,y
    sta.z vera_heap_list_insert_at.list
    // [270] vera_heap_list_insert_at::index#2 = vera_heap_free_insert::free_index#0 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z vera_heap_list_insert_at.index
    // [271] vera_heap_list_insert_at::at#3 = ((char *)&vera_heap_segment+$2e)[vera_heap_free_insert::s#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    lda vera_heap_segment+$2e,y
    sta.z vera_heap_list_insert_at.at
    // [272] call vera_heap_list_insert_at
    // [441] phi from vera_heap_free_insert to vera_heap_list_insert_at [phi:vera_heap_free_insert->vera_heap_list_insert_at]
    // [441] phi vera_heap_list_insert_at::index#10 = vera_heap_list_insert_at::index#2 [phi:vera_heap_free_insert->vera_heap_list_insert_at#0] -- register_copy 
    // [441] phi vera_heap_list_insert_at::at#10 = vera_heap_list_insert_at::at#3 [phi:vera_heap_free_insert->vera_heap_list_insert_at#1] -- register_copy 
    // [441] phi vera_heap_list_insert_at::list#5 = vera_heap_list_insert_at::list#3 [phi:vera_heap_free_insert->vera_heap_list_insert_at#2] -- register_copy 
    jsr vera_heap_list_insert_at
    // vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, vera_heap_segment.free_list[s])
    // [273] vera_heap_list_insert_at::return#4 = vera_heap_list_insert_at::list#11 -- vbuaa=vbuz1 
    lda.z vera_heap_list_insert_at.list
    // vera_heap_free_insert::@1
    // [274] vera_heap_free_insert::$0 = vera_heap_list_insert_at::return#4
    // vera_heap_segment.free_list[s] = vera_heap_list_insert_at(s, vera_heap_segment.free_list[s], free_index, vera_heap_segment.free_list[s])
    // [275] ((char *)&vera_heap_segment+$2e)[vera_heap_free_insert::s#0] = vera_heap_free_insert::$0 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z s
    sta vera_heap_segment+$2e,y
    // vera_heap_set_data_packed(s, free_index, data)
    // [276] vera_heap_set_data_packed::index#1 = vera_heap_free_insert::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [277] vera_heap_set_data_packed::data_packed#1 = vera_heap_free_insert::data#0
    // [278] call vera_heap_set_data_packed
    // [471] phi from vera_heap_free_insert::@1 to vera_heap_set_data_packed [phi:vera_heap_free_insert::@1->vera_heap_set_data_packed]
    // [471] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#1 [phi:vera_heap_free_insert::@1->vera_heap_set_data_packed#0] -- register_copy 
    // [471] phi vera_heap_set_data_packed::data_packed#7 = vera_heap_set_data_packed::data_packed#1 [phi:vera_heap_free_insert::@1->vera_heap_set_data_packed#1] -- register_copy 
    jsr vera_heap_set_data_packed
    // vera_heap_free_insert::@2
    // vera_heap_set_size_packed(s, free_index, size)
    // [279] vera_heap_set_size_packed::index#2 = vera_heap_free_insert::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [280] vera_heap_set_size_packed::size_packed#2 = vera_heap_free_insert::size#0 -- vwuz1=vwuz2 
    lda.z size
    sta.z vera_heap_set_size_packed.size_packed
    lda.z size+1
    sta.z vera_heap_set_size_packed.size_packed+1
    // [281] call vera_heap_set_size_packed
    // [477] phi from vera_heap_free_insert::@2 to vera_heap_set_size_packed [phi:vera_heap_free_insert::@2->vera_heap_set_size_packed]
    // [477] phi vera_heap_set_size_packed::size_packed#6 = vera_heap_set_size_packed::size_packed#2 [phi:vera_heap_free_insert::@2->vera_heap_set_size_packed#0] -- register_copy 
    // [477] phi vera_heap_set_size_packed::index#6 = vera_heap_set_size_packed::index#2 [phi:vera_heap_free_insert::@2->vera_heap_set_size_packed#1] -- register_copy 
    jsr vera_heap_set_size_packed
    // vera_heap_free_insert::@3
    // vera_heap_set_free(s, free_index)
    // [282] vera_heap_set_free::index#1 = vera_heap_free_insert::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [283] call vera_heap_set_free
    // [486] phi from vera_heap_free_insert::@3 to vera_heap_set_free [phi:vera_heap_free_insert::@3->vera_heap_set_free]
    // [486] phi vera_heap_set_free::index#5 = vera_heap_set_free::index#1 [phi:vera_heap_free_insert::@3->vera_heap_set_free#0] -- register_copy 
    jsr vera_heap_set_free
    // vera_heap_free_insert::@4
    // vera_heap_segment.freeCount[s]++;
    // [284] vera_heap_free_insert::$6 = vera_heap_free_insert::s#0 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [285] ((unsigned int *)&vera_heap_segment+$46)[vera_heap_free_insert::$6] = ++ ((unsigned int *)&vera_heap_segment+$46)[vera_heap_free_insert::$6] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc vera_heap_segment+$46,x
    bne !+
    inc vera_heap_segment+$46+1,x
  !:
    // vera_heap_free_insert::@return
    // }
    // [286] return 
    rts
}
  // vera_heap_can_coalesce_left
/**
 * Whether we should merge this header to the left.
 */
// __register(Y) char vera_heap_can_coalesce_left(char s, __zp($a) char heap_index)
vera_heap_can_coalesce_left: {
    .label heap_index = $a
    .label heap_offset = $28
    .label left_offset = $1c
    // vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(s, heap_index)
    // [287] vera_heap_get_data_packed::index#4 = vera_heap_can_coalesce_left::heap_index#0 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [288] call vera_heap_get_data_packed
    // [253] phi from vera_heap_can_coalesce_left to vera_heap_get_data_packed [phi:vera_heap_can_coalesce_left->vera_heap_get_data_packed]
    // [253] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#4 [phi:vera_heap_can_coalesce_left->vera_heap_get_data_packed#0] -- register_copy 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(s, heap_index)
    // [289] vera_heap_get_data_packed::return#16 = vera_heap_get_data_packed::return#1 -- vwuz1=vwuz2 
    lda.z vera_heap_get_data_packed.return
    sta.z vera_heap_get_data_packed.return_4
    lda.z vera_heap_get_data_packed.return+1
    sta.z vera_heap_get_data_packed.return_4+1
    // vera_heap_can_coalesce_left::@2
    // [290] vera_heap_can_coalesce_left::heap_offset#0 = vera_heap_get_data_packed::return#16
    // vera_heap_index_t left_index = vera_heap_get_left(s, heap_index)
    // [291] vera_heap_get_left::index#2 = vera_heap_can_coalesce_left::heap_index#0 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [292] call vera_heap_get_left
    // [538] phi from vera_heap_can_coalesce_left::@2 to vera_heap_get_left [phi:vera_heap_can_coalesce_left::@2->vera_heap_get_left]
    // [538] phi vera_heap_get_left::index#4 = vera_heap_get_left::index#2 [phi:vera_heap_can_coalesce_left::@2->vera_heap_get_left#0] -- register_copy 
    jsr vera_heap_get_left
    // vera_heap_index_t left_index = vera_heap_get_left(s, heap_index)
    // [293] vera_heap_get_left::return#4 = vera_heap_get_left::return#0
    // vera_heap_can_coalesce_left::@3
    // [294] vera_heap_can_coalesce_left::left_index#0 = vera_heap_get_left::return#4 -- vbuyy=vbuaa 
    tay
    // vera_heap_data_packed_t left_offset = vera_heap_get_data_packed(s, left_index)
    // [295] vera_heap_get_data_packed::index#5 = vera_heap_can_coalesce_left::left_index#0 -- vbuxx=vbuyy 
    tya
    tax
    // [296] call vera_heap_get_data_packed
    // [253] phi from vera_heap_can_coalesce_left::@3 to vera_heap_get_data_packed [phi:vera_heap_can_coalesce_left::@3->vera_heap_get_data_packed]
    // [253] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#5 [phi:vera_heap_can_coalesce_left::@3->vera_heap_get_data_packed#0] -- register_copy 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t left_offset = vera_heap_get_data_packed(s, left_index)
    // [297] vera_heap_get_data_packed::return#17 = vera_heap_get_data_packed::return#1
    // vera_heap_can_coalesce_left::@4
    // [298] vera_heap_can_coalesce_left::left_offset#0 = vera_heap_get_data_packed::return#17
    // bool left_free = vera_heap_is_free(s, left_index)
    // [299] vera_heap_is_free::index#0 = vera_heap_can_coalesce_left::left_index#0 -- vbuxx=vbuyy 
    tya
    tax
    // [300] call vera_heap_is_free
    // [541] phi from vera_heap_can_coalesce_left::@4 to vera_heap_is_free [phi:vera_heap_can_coalesce_left::@4->vera_heap_is_free]
    // [541] phi vera_heap_is_free::index#2 = vera_heap_is_free::index#0 [phi:vera_heap_can_coalesce_left::@4->vera_heap_is_free#0] -- register_copy 
    jsr vera_heap_is_free
    // bool left_free = vera_heap_is_free(s, left_index)
    // [301] vera_heap_is_free::return#2 = vera_heap_is_free::return#0
    // vera_heap_can_coalesce_left::@5
    // [302] vera_heap_can_coalesce_left::left_free#0 = vera_heap_is_free::return#2
    // if(left_free && (left_offset < heap_offset))
    // [303] if(vera_heap_can_coalesce_left::left_free#0) goto vera_heap_can_coalesce_left::@6 -- vboaa_then_la1 
    cmp #0
    bne __b6
    // [306] phi from vera_heap_can_coalesce_left::@5 vera_heap_can_coalesce_left::@6 to vera_heap_can_coalesce_left::@return [phi:vera_heap_can_coalesce_left::@5/vera_heap_can_coalesce_left::@6->vera_heap_can_coalesce_left::@return]
  __b2:
    // [306] phi vera_heap_can_coalesce_left::return#3 = $ff [phi:vera_heap_can_coalesce_left::@5/vera_heap_can_coalesce_left::@6->vera_heap_can_coalesce_left::@return#0] -- vbuyy=vbuc1 
    ldy #$ff
    rts
    // vera_heap_can_coalesce_left::@6
  __b6:
    // if(left_free && (left_offset < heap_offset))
    // [304] if(vera_heap_can_coalesce_left::left_offset#0<vera_heap_can_coalesce_left::heap_offset#0) goto vera_heap_can_coalesce_left::@1 -- vwuz1_lt_vwuz2_then_la1 
    lda.z left_offset+1
    cmp.z heap_offset+1
    bcc __b1
    bne !+
    lda.z left_offset
    cmp.z heap_offset
    bcc __b1
  !:
    jmp __b2
    // [305] phi from vera_heap_can_coalesce_left::@6 to vera_heap_can_coalesce_left::@1 [phi:vera_heap_can_coalesce_left::@6->vera_heap_can_coalesce_left::@1]
    // vera_heap_can_coalesce_left::@1
  __b1:
    // [306] phi from vera_heap_can_coalesce_left::@1 to vera_heap_can_coalesce_left::@return [phi:vera_heap_can_coalesce_left::@1->vera_heap_can_coalesce_left::@return]
    // [306] phi vera_heap_can_coalesce_left::return#3 = vera_heap_can_coalesce_left::left_index#0 [phi:vera_heap_can_coalesce_left::@1->vera_heap_can_coalesce_left::@return#0] -- register_copy 
    // vera_heap_can_coalesce_left::@return
    // }
    // [307] return 
    rts
}
  // vera_heap_coalesce
/**
 * Coalesces two adjacent blocks to the left.
 * The left is a free index and the right is the heap index to be freed.
 * The free index remains free, and the heap to the right stays heap.
 * The free index is returned as the new remaining (free) block.
 */
// __register(A) char vera_heap_coalesce(__zp($2b) char s, __zp($3b) char left_index, __zp($36) char right_index)
vera_heap_coalesce: {
    .label s = $2b
    .label left_index = $3b
    .label right_index = $36
    .label right_size = $12
    .label left_size = $44
    .label left_offset = $2c
    .label free_left = $42
    .label free_right = $43
    // vera_heap_size_packed_t right_size = vera_heap_get_size_packed(s, right_index)
    // [309] vera_heap_get_size_packed::index#6 = vera_heap_coalesce::right_index#10 -- vbuxx=vbuz1 
    ldx.z right_index
    // [310] call vera_heap_get_size_packed
    // [256] phi from vera_heap_coalesce to vera_heap_get_size_packed [phi:vera_heap_coalesce->vera_heap_get_size_packed]
    // [256] phi vera_heap_get_size_packed::index#8 = vera_heap_get_size_packed::index#6 [phi:vera_heap_coalesce->vera_heap_get_size_packed#0] -- register_copy 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t right_size = vera_heap_get_size_packed(s, right_index)
    // [311] vera_heap_get_size_packed::return#16 = vera_heap_get_size_packed::return#12
    // vera_heap_coalesce::@1
    // [312] vera_heap_coalesce::right_size#0 = vera_heap_get_size_packed::return#16 -- vwuz1=vwuz2 
    lda.z vera_heap_get_size_packed.return_1
    sta.z right_size
    lda.z vera_heap_get_size_packed.return_1+1
    sta.z right_size+1
    // vera_heap_size_packed_t left_size = vera_heap_get_size_packed(s, left_index)
    // [313] vera_heap_get_size_packed::index#7 = vera_heap_coalesce::left_index#10 -- vbuxx=vbuz1 
    ldx.z left_index
    // [314] call vera_heap_get_size_packed
    // [256] phi from vera_heap_coalesce::@1 to vera_heap_get_size_packed [phi:vera_heap_coalesce::@1->vera_heap_get_size_packed]
    // [256] phi vera_heap_get_size_packed::index#8 = vera_heap_get_size_packed::index#7 [phi:vera_heap_coalesce::@1->vera_heap_get_size_packed#0] -- register_copy 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t left_size = vera_heap_get_size_packed(s, left_index)
    // [315] vera_heap_get_size_packed::return#17 = vera_heap_get_size_packed::return#12
    // vera_heap_coalesce::@2
    // [316] vera_heap_coalesce::left_size#0 = vera_heap_get_size_packed::return#17 -- vwuz1=vwuz2 
    lda.z vera_heap_get_size_packed.return_1
    sta.z left_size
    lda.z vera_heap_get_size_packed.return_1+1
    sta.z left_size+1
    // vera_heap_data_packed_t left_offset = vera_heap_get_data_packed(s, left_index)
    // [317] vera_heap_get_data_packed::index#8 = vera_heap_coalesce::left_index#10 -- vbuxx=vbuz1 
    ldx.z left_index
    // [318] call vera_heap_get_data_packed
    // [253] phi from vera_heap_coalesce::@2 to vera_heap_get_data_packed [phi:vera_heap_coalesce::@2->vera_heap_get_data_packed]
    // [253] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#8 [phi:vera_heap_coalesce::@2->vera_heap_get_data_packed#0] -- register_copy 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t left_offset = vera_heap_get_data_packed(s, left_index)
    // [319] vera_heap_get_data_packed::return#10 = vera_heap_get_data_packed::return#1 -- vwuz1=vwuz2 
    lda.z vera_heap_get_data_packed.return
    sta.z vera_heap_get_data_packed.return_1
    lda.z vera_heap_get_data_packed.return+1
    sta.z vera_heap_get_data_packed.return_1+1
    // vera_heap_coalesce::@3
    // [320] vera_heap_coalesce::left_offset#0 = vera_heap_get_data_packed::return#10
    // vera_heap_index_t free_left = vera_heap_get_left(s, left_index)
    // [321] vera_heap_get_left::index#3 = vera_heap_coalesce::left_index#10 -- vbuxx=vbuz1 
    ldx.z left_index
    // [322] call vera_heap_get_left
    // [538] phi from vera_heap_coalesce::@3 to vera_heap_get_left [phi:vera_heap_coalesce::@3->vera_heap_get_left]
    // [538] phi vera_heap_get_left::index#4 = vera_heap_get_left::index#3 [phi:vera_heap_coalesce::@3->vera_heap_get_left#0] -- register_copy 
    jsr vera_heap_get_left
    // vera_heap_index_t free_left = vera_heap_get_left(s, left_index)
    // [323] vera_heap_get_left::return#10 = vera_heap_get_left::return#0
    // vera_heap_coalesce::@4
    // [324] vera_heap_coalesce::free_left#0 = vera_heap_get_left::return#10 -- vbuz1=vbuaa 
    sta.z free_left
    // vera_heap_index_t free_right = vera_heap_get_right(s, right_index)
    // [325] vera_heap_get_right::index#2 = vera_heap_coalesce::right_index#10 -- vbuxx=vbuz1 
    ldx.z right_index
    // [326] call vera_heap_get_right
    // [545] phi from vera_heap_coalesce::@4 to vera_heap_get_right [phi:vera_heap_coalesce::@4->vera_heap_get_right]
    // [545] phi vera_heap_get_right::index#3 = vera_heap_get_right::index#2 [phi:vera_heap_coalesce::@4->vera_heap_get_right#0] -- register_copy 
    jsr vera_heap_get_right
    // vera_heap_index_t free_right = vera_heap_get_right(s, right_index)
    // [327] vera_heap_get_right::return#4 = vera_heap_get_right::return#0
    // vera_heap_coalesce::@5
    // [328] vera_heap_coalesce::free_right#0 = vera_heap_get_right::return#4 -- vbuz1=vbuaa 
    sta.z free_right
    // vera_heap_free_remove(s, left_index)
    // [329] vera_heap_free_remove::s#1 = vera_heap_coalesce::s#10 -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_free_remove.s
    // [330] vera_heap_free_remove::free_index#1 = vera_heap_coalesce::left_index#10 -- vbuz1=vbuz2 
    lda.z left_index
    sta.z vera_heap_free_remove.free_index
    // [331] call vera_heap_free_remove
  // We detach the left index from the free list and add it to the idle list.
    // [548] phi from vera_heap_coalesce::@5 to vera_heap_free_remove [phi:vera_heap_coalesce::@5->vera_heap_free_remove]
    // [548] phi vera_heap_free_remove::free_index#2 = vera_heap_free_remove::free_index#1 [phi:vera_heap_coalesce::@5->vera_heap_free_remove#0] -- register_copy 
    // [548] phi vera_heap_free_remove::s#2 = vera_heap_free_remove::s#1 [phi:vera_heap_coalesce::@5->vera_heap_free_remove#1] -- register_copy 
    jsr vera_heap_free_remove
    // vera_heap_coalesce::@6
    // vera_heap_idle_insert(s, left_index)
    // [332] vera_heap_idle_insert::s#0 = vera_heap_coalesce::s#10 -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_idle_insert.s
    // [333] vera_heap_idle_insert::idle_index#0 = vera_heap_coalesce::left_index#10 -- vbuz1=vbuz2 
    lda.z left_index
    sta.z vera_heap_idle_insert.idle_index
    // [334] call vera_heap_idle_insert
    jsr vera_heap_idle_insert
    // vera_heap_coalesce::@7
    // vera_heap_set_left(s, right_index, free_left)
    // [335] vera_heap_set_left::index#3 = vera_heap_coalesce::right_index#10 -- vbuxx=vbuz1 
    ldx.z right_index
    // [336] vera_heap_set_left::left#3 = vera_heap_coalesce::free_left#0 -- vbuaa=vbuz1 
    lda.z free_left
    // [337] call vera_heap_set_left
    // [574] phi from vera_heap_coalesce::@7 to vera_heap_set_left [phi:vera_heap_coalesce::@7->vera_heap_set_left]
    // [574] phi vera_heap_set_left::index#6 = vera_heap_set_left::index#3 [phi:vera_heap_coalesce::@7->vera_heap_set_left#0] -- register_copy 
    // [574] phi vera_heap_set_left::left#6 = vera_heap_set_left::left#3 [phi:vera_heap_coalesce::@7->vera_heap_set_left#1] -- register_copy 
    jsr vera_heap_set_left
    // vera_heap_coalesce::@8
    // vera_heap_set_right(s, right_index, free_right)
    // [338] vera_heap_set_right::index#3 = vera_heap_coalesce::right_index#10 -- vbuxx=vbuz1 
    ldx.z right_index
    // [339] vera_heap_set_right::right#3 = vera_heap_coalesce::free_right#0 -- vbuaa=vbuz1 
    lda.z free_right
    // [340] call vera_heap_set_right
    // [577] phi from vera_heap_coalesce::@8 to vera_heap_set_right [phi:vera_heap_coalesce::@8->vera_heap_set_right]
    // [577] phi vera_heap_set_right::index#6 = vera_heap_set_right::index#3 [phi:vera_heap_coalesce::@8->vera_heap_set_right#0] -- register_copy 
    // [577] phi vera_heap_set_right::right#6 = vera_heap_set_right::right#3 [phi:vera_heap_coalesce::@8->vera_heap_set_right#1] -- register_copy 
    jsr vera_heap_set_right
    // vera_heap_coalesce::@9
    // vera_heap_set_left(s, free_right, right_index)
    // [341] vera_heap_set_left::index#4 = vera_heap_coalesce::free_right#0 -- vbuxx=vbuz1 
    ldx.z free_right
    // [342] vera_heap_set_left::left#4 = vera_heap_coalesce::right_index#10 -- vbuaa=vbuz1 
    lda.z right_index
    // [343] call vera_heap_set_left
    // [574] phi from vera_heap_coalesce::@9 to vera_heap_set_left [phi:vera_heap_coalesce::@9->vera_heap_set_left]
    // [574] phi vera_heap_set_left::index#6 = vera_heap_set_left::index#4 [phi:vera_heap_coalesce::@9->vera_heap_set_left#0] -- register_copy 
    // [574] phi vera_heap_set_left::left#6 = vera_heap_set_left::left#4 [phi:vera_heap_coalesce::@9->vera_heap_set_left#1] -- register_copy 
    jsr vera_heap_set_left
    // vera_heap_coalesce::@10
    // vera_heap_set_right(s, free_left, right_index)
    // [344] vera_heap_set_right::index#4 = vera_heap_coalesce::free_left#0 -- vbuxx=vbuz1 
    ldx.z free_left
    // [345] vera_heap_set_right::right#4 = vera_heap_coalesce::right_index#10 -- vbuaa=vbuz1 
    lda.z right_index
    // [346] call vera_heap_set_right
    // [577] phi from vera_heap_coalesce::@10 to vera_heap_set_right [phi:vera_heap_coalesce::@10->vera_heap_set_right]
    // [577] phi vera_heap_set_right::index#6 = vera_heap_set_right::index#4 [phi:vera_heap_coalesce::@10->vera_heap_set_right#0] -- register_copy 
    // [577] phi vera_heap_set_right::right#6 = vera_heap_set_right::right#4 [phi:vera_heap_coalesce::@10->vera_heap_set_right#1] -- register_copy 
    jsr vera_heap_set_right
    // vera_heap_coalesce::@11
    // vera_heap_set_left(s, left_index, VERAHEAP_NULL)
    // [347] vera_heap_set_left::index#5 = vera_heap_coalesce::left_index#10 -- vbuxx=vbuz1 
    ldx.z left_index
    // [348] call vera_heap_set_left
    // [574] phi from vera_heap_coalesce::@11 to vera_heap_set_left [phi:vera_heap_coalesce::@11->vera_heap_set_left]
    // [574] phi vera_heap_set_left::index#6 = vera_heap_set_left::index#5 [phi:vera_heap_coalesce::@11->vera_heap_set_left#0] -- register_copy 
    // [574] phi vera_heap_set_left::left#6 = $ff [phi:vera_heap_coalesce::@11->vera_heap_set_left#1] -- vbuaa=vbuc1 
    lda #$ff
    jsr vera_heap_set_left
    // vera_heap_coalesce::@12
    // vera_heap_set_right(s, left_index, VERAHEAP_NULL)
    // [349] vera_heap_set_right::index#5 = vera_heap_coalesce::left_index#10 -- vbuxx=vbuz1 
    ldx.z left_index
    // [350] call vera_heap_set_right
    // [577] phi from vera_heap_coalesce::@12 to vera_heap_set_right [phi:vera_heap_coalesce::@12->vera_heap_set_right]
    // [577] phi vera_heap_set_right::index#6 = vera_heap_set_right::index#5 [phi:vera_heap_coalesce::@12->vera_heap_set_right#0] -- register_copy 
    // [577] phi vera_heap_set_right::right#6 = $ff [phi:vera_heap_coalesce::@12->vera_heap_set_right#1] -- vbuaa=vbuc1 
    lda #$ff
    jsr vera_heap_set_right
    // vera_heap_coalesce::@13
    // vera_heap_set_size_packed(s, right_index, left_size + right_size)
    // [351] vera_heap_set_size_packed::size_packed#5 = vera_heap_coalesce::left_size#0 + vera_heap_coalesce::right_size#0 -- vwuz1=vwuz2_plus_vwuz3 
    lda.z left_size
    clc
    adc.z right_size
    sta.z vera_heap_set_size_packed.size_packed
    lda.z left_size+1
    adc.z right_size+1
    sta.z vera_heap_set_size_packed.size_packed+1
    // [352] vera_heap_set_size_packed::index#5 = vera_heap_coalesce::right_index#10 -- vbuxx=vbuz1 
    ldx.z right_index
    // [353] call vera_heap_set_size_packed
    // [477] phi from vera_heap_coalesce::@13 to vera_heap_set_size_packed [phi:vera_heap_coalesce::@13->vera_heap_set_size_packed]
    // [477] phi vera_heap_set_size_packed::size_packed#6 = vera_heap_set_size_packed::size_packed#5 [phi:vera_heap_coalesce::@13->vera_heap_set_size_packed#0] -- register_copy 
    // [477] phi vera_heap_set_size_packed::index#6 = vera_heap_set_size_packed::index#5 [phi:vera_heap_coalesce::@13->vera_heap_set_size_packed#1] -- register_copy 
    jsr vera_heap_set_size_packed
    // vera_heap_coalesce::@14
    // vera_heap_set_data_packed(s, right_index, left_offset)
    // [354] vera_heap_set_data_packed::index#6 = vera_heap_coalesce::right_index#10 -- vbuxx=vbuz1 
    ldx.z right_index
    // [355] vera_heap_set_data_packed::data_packed#6 = vera_heap_coalesce::left_offset#0 -- vwuz1=vwuz2 
    lda.z left_offset
    sta.z vera_heap_set_data_packed.data_packed
    lda.z left_offset+1
    sta.z vera_heap_set_data_packed.data_packed+1
    // [356] call vera_heap_set_data_packed
    // [471] phi from vera_heap_coalesce::@14 to vera_heap_set_data_packed [phi:vera_heap_coalesce::@14->vera_heap_set_data_packed]
    // [471] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#6 [phi:vera_heap_coalesce::@14->vera_heap_set_data_packed#0] -- register_copy 
    // [471] phi vera_heap_set_data_packed::data_packed#7 = vera_heap_set_data_packed::data_packed#6 [phi:vera_heap_coalesce::@14->vera_heap_set_data_packed#1] -- register_copy 
    jsr vera_heap_set_data_packed
    // vera_heap_coalesce::@15
    // vera_heap_set_free(s, left_index)
    // [357] vera_heap_set_free::index#3 = vera_heap_coalesce::left_index#10 -- vbuxx=vbuz1 
    ldx.z left_index
    // [358] call vera_heap_set_free
    // [486] phi from vera_heap_coalesce::@15 to vera_heap_set_free [phi:vera_heap_coalesce::@15->vera_heap_set_free]
    // [486] phi vera_heap_set_free::index#5 = vera_heap_set_free::index#3 [phi:vera_heap_coalesce::@15->vera_heap_set_free#0] -- register_copy 
    jsr vera_heap_set_free
    // vera_heap_coalesce::@16
    // vera_heap_set_free(s, right_index)
    // [359] vera_heap_set_free::index#4 = vera_heap_coalesce::right_index#10 -- vbuxx=vbuz1 
    ldx.z right_index
    // [360] call vera_heap_set_free
    // [486] phi from vera_heap_coalesce::@16 to vera_heap_set_free [phi:vera_heap_coalesce::@16->vera_heap_set_free]
    // [486] phi vera_heap_set_free::index#5 = vera_heap_set_free::index#4 [phi:vera_heap_coalesce::@16->vera_heap_set_free#0] -- register_copy 
    jsr vera_heap_set_free
    // vera_heap_coalesce::@return
    // }
    // [361] return 
    rts
}
  // heap_can_coalesce_right
/**
 * Whether we should merge this header to the right.
 */
// __zp(7) char heap_can_coalesce_right(char s, __zp(6) char heap_index)
heap_can_coalesce_right: {
    .label heap_index = 6
    .label heap_offset = $d
    .label right_index = 7
    .label right_offset = $24
    // A free_index is not found, we cannot coalesce.
    .label return = 7
    // vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(s, heap_index)
    // [362] vera_heap_get_data_packed::index#6 = heap_can_coalesce_right::heap_index#0 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [363] call vera_heap_get_data_packed
    // [253] phi from heap_can_coalesce_right to vera_heap_get_data_packed [phi:heap_can_coalesce_right->vera_heap_get_data_packed]
    // [253] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#6 [phi:heap_can_coalesce_right->vera_heap_get_data_packed#0] -- register_copy 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t heap_offset = vera_heap_get_data_packed(s, heap_index)
    // [364] vera_heap_get_data_packed::return#18 = vera_heap_get_data_packed::return#1 -- vwuz1=vwuz2 
    lda.z vera_heap_get_data_packed.return
    sta.z vera_heap_get_data_packed.return_5
    lda.z vera_heap_get_data_packed.return+1
    sta.z vera_heap_get_data_packed.return_5+1
    // heap_can_coalesce_right::@2
    // [365] heap_can_coalesce_right::heap_offset#0 = vera_heap_get_data_packed::return#18
    // vera_heap_index_t right_index = vera_heap_get_right(s, heap_index)
    // [366] vera_heap_get_right::index#1 = heap_can_coalesce_right::heap_index#0 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [367] call vera_heap_get_right
    // [545] phi from heap_can_coalesce_right::@2 to vera_heap_get_right [phi:heap_can_coalesce_right::@2->vera_heap_get_right]
    // [545] phi vera_heap_get_right::index#3 = vera_heap_get_right::index#1 [phi:heap_can_coalesce_right::@2->vera_heap_get_right#0] -- register_copy 
    jsr vera_heap_get_right
    // vera_heap_index_t right_index = vera_heap_get_right(s, heap_index)
    // [368] vera_heap_get_right::return#3 = vera_heap_get_right::return#0
    // heap_can_coalesce_right::@3
    // [369] heap_can_coalesce_right::right_index#0 = vera_heap_get_right::return#3 -- vbuz1=vbuaa 
    sta.z right_index
    // vera_heap_data_packed_t right_offset = vera_heap_get_data_packed(s, right_index)
    // [370] vera_heap_get_data_packed::index#7 = heap_can_coalesce_right::right_index#0 -- vbuxx=vbuz1 
    tax
    // [371] call vera_heap_get_data_packed
    // [253] phi from heap_can_coalesce_right::@3 to vera_heap_get_data_packed [phi:heap_can_coalesce_right::@3->vera_heap_get_data_packed]
    // [253] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#7 [phi:heap_can_coalesce_right::@3->vera_heap_get_data_packed#0] -- register_copy 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t right_offset = vera_heap_get_data_packed(s, right_index)
    // [372] vera_heap_get_data_packed::return#19 = vera_heap_get_data_packed::return#1 -- vwuz1=vwuz2 
    lda.z vera_heap_get_data_packed.return
    sta.z vera_heap_get_data_packed.return_6
    lda.z vera_heap_get_data_packed.return+1
    sta.z vera_heap_get_data_packed.return_6+1
    // heap_can_coalesce_right::@4
    // [373] heap_can_coalesce_right::right_offset#0 = vera_heap_get_data_packed::return#19
    // bool right_free = vera_heap_is_free(s, right_index)
    // [374] vera_heap_is_free::index#1 = heap_can_coalesce_right::right_index#0 -- vbuxx=vbuz1 
    ldx.z right_index
    // [375] call vera_heap_is_free
    // [541] phi from heap_can_coalesce_right::@4 to vera_heap_is_free [phi:heap_can_coalesce_right::@4->vera_heap_is_free]
    // [541] phi vera_heap_is_free::index#2 = vera_heap_is_free::index#1 [phi:heap_can_coalesce_right::@4->vera_heap_is_free#0] -- register_copy 
    jsr vera_heap_is_free
    // bool right_free = vera_heap_is_free(s, right_index)
    // [376] vera_heap_is_free::return#3 = vera_heap_is_free::return#0
    // heap_can_coalesce_right::@5
    // [377] heap_can_coalesce_right::right_free#0 = vera_heap_is_free::return#3
    // if(right_free && (heap_offset < right_offset))
    // [378] if(heap_can_coalesce_right::right_free#0) goto heap_can_coalesce_right::@6 -- vboaa_then_la1 
    cmp #0
    bne __b6
    // [381] phi from heap_can_coalesce_right::@5 heap_can_coalesce_right::@6 to heap_can_coalesce_right::@return [phi:heap_can_coalesce_right::@5/heap_can_coalesce_right::@6->heap_can_coalesce_right::@return]
  __b2:
    // [381] phi heap_can_coalesce_right::return#3 = $ff [phi:heap_can_coalesce_right::@5/heap_can_coalesce_right::@6->heap_can_coalesce_right::@return#0] -- vbuz1=vbuc1 
    lda #$ff
    sta.z return
    rts
    // heap_can_coalesce_right::@6
  __b6:
    // if(right_free && (heap_offset < right_offset))
    // [379] if(heap_can_coalesce_right::heap_offset#0<heap_can_coalesce_right::right_offset#0) goto heap_can_coalesce_right::@1 -- vwuz1_lt_vwuz2_then_la1 
    lda.z heap_offset+1
    cmp.z right_offset+1
    bcc __b1
    bne !+
    lda.z heap_offset
    cmp.z right_offset
    bcc __b1
  !:
    jmp __b2
    // [380] phi from heap_can_coalesce_right::@6 to heap_can_coalesce_right::@1 [phi:heap_can_coalesce_right::@6->heap_can_coalesce_right::@1]
    // heap_can_coalesce_right::@1
  __b1:
    // [381] phi from heap_can_coalesce_right::@1 to heap_can_coalesce_right::@return [phi:heap_can_coalesce_right::@1->heap_can_coalesce_right::@return]
    // [381] phi heap_can_coalesce_right::return#3 = heap_can_coalesce_right::right_index#0 [phi:heap_can_coalesce_right::@1->heap_can_coalesce_right::@return#0] -- register_copy 
    // heap_can_coalesce_right::@return
    // }
    // [382] return 
    rts
}
  // vera_heap_get_size_int
// __zp($16) unsigned int vera_heap_get_size_int(char s, __register(X) char index)
vera_heap_get_size_int: {
    .label return = $16
    .label size = $16
    // vera_heap_get_size_int::bank_push_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // vera_heap_get_size_int::@1
    // bank_set_bram(vera_heap_segment.bram_bank)
    // [385] vera_heap_get_size_int::bank_set_bram1_bank#0 = *((char *)&vera_heap_segment) -- vbuaa=_deref_pbuc1 
    lda vera_heap_segment
    // vera_heap_get_size_int::bank_set_bram1
    // BRAM = bank
    // [386] BRAM = vera_heap_get_size_int::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // vera_heap_get_size_int::@2
    // vera_heap_size_packed_t size = vera_heap_get_size_packed(s, index)
    // [387] vera_heap_get_size_packed::index#1 = vera_heap_get_size_int::index#0
    // [388] call vera_heap_get_size_packed
    // [256] phi from vera_heap_get_size_int::@2 to vera_heap_get_size_packed [phi:vera_heap_get_size_int::@2->vera_heap_get_size_packed]
    // [256] phi vera_heap_get_size_packed::index#8 = vera_heap_get_size_packed::index#1 [phi:vera_heap_get_size_int::@2->vera_heap_get_size_packed#0] -- register_copy 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t size = vera_heap_get_size_packed(s, index)
    // [389] vera_heap_get_size_packed::return#1 = vera_heap_get_size_packed::return#12
    // vera_heap_get_size_int::@4
    // [390] vera_heap_get_size_int::size#0 = vera_heap_get_size_packed::return#1 -- vwuz1=vwuz2 
    lda.z vera_heap_get_size_packed.return_1
    sta.z size
    lda.z vera_heap_get_size_packed.return_1+1
    sta.z size+1
    // vera_heap_get_size_int::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // vera_heap_get_size_int::@3
    // size << 3
    // [392] vera_heap_get_size_int::return#1 = vera_heap_get_size_int::size#0 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z return
    rol.z return+1
    asl.z return
    rol.z return+1
    asl.z return
    rol.z return+1
    // vera_heap_get_size_int::@return
    // }
    // [393] return 
    rts
}
.segment Code
  // memset_vram
/**
 * @brief Set block of memory in vram to a value.
 * Sets num bytes to the destination vram bank/offset to the specified data value.
 *
 * @param dbank_vram Destination vram bank between 0 and 1.
 * @param doffset_vram Destination vram offset between 0x0000 and 0xFFFF.
 * @param data The data to be set in char value.
 * @param num Amount of bytes to set.
 */
// void memset_vram(__register(X) char dbank_vram, __zp($14) unsigned int doffset_vram, __register(Y) char data, __zp($39) unsigned int num)
memset_vram: {
    .label i = $14
    .label doffset_vram = $14
    .label num = $39
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [394] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [395] memset_vram::$0 = byte0  memset_vram::doffset_vram#0 -- vbuaa=_byte0_vwuz1 
    lda.z doffset_vram
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [396] *VERA_ADDRX_L = memset_vram::$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [397] memset_vram::$1 = byte1  memset_vram::doffset_vram#0 -- vbuaa=_byte1_vwuz1 
    lda.z doffset_vram+1
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [398] *VERA_ADDRX_M = memset_vram::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // dbank_vram | VERA_INC_1
    // [399] memset_vram::$2 = memset_vram::dbank_vram#0 | VERA_INC_1 -- vbuaa=vbuxx_bor_vbuc1 
    txa
    ora #VERA_INC_1
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [400] *VERA_ADDRX_H = memset_vram::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [401] phi from memset_vram to memset_vram::@1 [phi:memset_vram->memset_vram::@1]
    // [401] phi memset_vram::i#2 = 0 [phi:memset_vram->memset_vram::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // memset_vram::@1
  __b1:
    // for (word i = 0; i < num; i++)
    // [402] if(memset_vram::i#2<memset_vram::num#0) goto memset_vram::@2 -- vwuz1_lt_vwuz2_then_la1 
    lda.z i+1
    cmp.z num+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z num
    bcc __b2
  !:
    // memset_vram::@return
    // }
    // [403] return 
    rts
    // memset_vram::@2
  __b2:
    // *VERA_DATA0 = data
    // [404] *VERA_DATA0 = memset_vram::data#0 -- _deref_pbuc1=vbuyy 
    sty VERA_DATA0
    // for (word i = 0; i < num; i++)
    // [405] memset_vram::i#1 = ++ memset_vram::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [401] phi from memset_vram::@2 to memset_vram::@1 [phi:memset_vram::@2->memset_vram::@1]
    // [401] phi memset_vram::i#2 = memset_vram::i#1 [phi:memset_vram::@2->memset_vram::@1#0] -- register_copy 
    jmp __b1
}
.segment CodeVeraHeap
  // vera_heap_allocate
/**
 * Allocates a header from the list, splitting if needed.
 */
// __register(A) char vera_heap_allocate(__zp($f) char s, __zp($10) char free_index, __zp($1c) unsigned int required_size)
vera_heap_allocate: {
    .label s = $f
    .label free_index = $10
    .label required_size = $1c
    .label free_size = 8
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [406] vera_heap_get_size_packed::index#4 = vera_heap_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [407] call vera_heap_get_size_packed
    // [256] phi from vera_heap_allocate to vera_heap_get_size_packed [phi:vera_heap_allocate->vera_heap_get_size_packed]
    // [256] phi vera_heap_get_size_packed::index#8 = vera_heap_get_size_packed::index#4 [phi:vera_heap_allocate->vera_heap_get_size_packed#0] -- register_copy 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [408] vera_heap_get_size_packed::return#14 = vera_heap_get_size_packed::return#12
    // vera_heap_allocate::@4
    // [409] vera_heap_allocate::free_size#0 = vera_heap_get_size_packed::return#14
    // if(free_size > required_size)
    // [410] if(vera_heap_allocate::free_size#0>vera_heap_allocate::required_size#0) goto vera_heap_allocate::@1 -- vwuz1_gt_vwuz2_then_la1 
    lda.z required_size+1
    cmp.z free_size+1
    bcc __b1
    bne !+
    lda.z required_size
    cmp.z free_size
    bcc __b1
  !:
    // vera_heap_allocate::@2
    // if(free_size == required_size)
    // [411] if(vera_heap_allocate::free_size#0==vera_heap_allocate::required_size#0) goto vera_heap_allocate::@3 -- vwuz1_eq_vwuz2_then_la1 
    lda.z free_size
    cmp.z required_size
    bne !+
    lda.z free_size+1
    cmp.z required_size+1
    beq __b3
  !:
    // [412] phi from vera_heap_allocate::@2 to vera_heap_allocate::@return [phi:vera_heap_allocate::@2->vera_heap_allocate::@return]
    // [412] phi vera_heap_allocate::return#4 = $ff [phi:vera_heap_allocate::@2->vera_heap_allocate::@return#0] -- vbuaa=vbuc1 
    lda #$ff
    // vera_heap_allocate::@return
    // }
    // [413] return 
    rts
    // vera_heap_allocate::@3
  __b3:
    // vera_heap_replace_free_with_heap(s, free_index, required_size)
    // [414] vera_heap_replace_free_with_heap::s#0 = vera_heap_allocate::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_replace_free_with_heap.s
    // [415] vera_heap_replace_free_with_heap::return#2 = vera_heap_allocate::free_index#0 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z vera_heap_replace_free_with_heap.return
    // [416] vera_heap_replace_free_with_heap::required_size#0 = vera_heap_allocate::required_size#0 -- vwuz1=vwuz2 
    lda.z required_size
    sta.z vera_heap_replace_free_with_heap.required_size
    lda.z required_size+1
    sta.z vera_heap_replace_free_with_heap.required_size+1
    // [417] call vera_heap_replace_free_with_heap
    jsr vera_heap_replace_free_with_heap
    // vera_heap_allocate::@6
    // return vera_heap_replace_free_with_heap(s, free_index, required_size);
    // [418] vera_heap_allocate::return#2 = vera_heap_replace_free_with_heap::return#2 -- vbuaa=vbuz1 
    lda.z vera_heap_replace_free_with_heap.return
    // [412] phi from vera_heap_allocate::@5 vera_heap_allocate::@6 to vera_heap_allocate::@return [phi:vera_heap_allocate::@5/vera_heap_allocate::@6->vera_heap_allocate::@return]
    // [412] phi vera_heap_allocate::return#4 = vera_heap_allocate::return#1 [phi:vera_heap_allocate::@5/vera_heap_allocate::@6->vera_heap_allocate::@return#0] -- register_copy 
    rts
    // vera_heap_allocate::@1
  __b1:
    // vera_heap_split_free_and_allocate(s, free_index, required_size)
    // [419] vera_heap_split_free_and_allocate::s#0 = vera_heap_allocate::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_split_free_and_allocate.s
    // [420] vera_heap_split_free_and_allocate::free_index#0 = vera_heap_allocate::free_index#0 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z vera_heap_split_free_and_allocate.free_index
    // [421] vera_heap_split_free_and_allocate::required_size#0 = vera_heap_allocate::required_size#0 -- vwuz1=vwuz2 
    lda.z required_size
    sta.z vera_heap_split_free_and_allocate.required_size
    lda.z required_size+1
    sta.z vera_heap_split_free_and_allocate.required_size+1
    // [422] call vera_heap_split_free_and_allocate
    jsr vera_heap_split_free_and_allocate
    // [423] vera_heap_split_free_and_allocate::return#2 = vera_heap_split_free_and_allocate::heap_index#0 -- vbuaa=vbuz1 
    lda.z vera_heap_split_free_and_allocate.heap_index
    // vera_heap_allocate::@5
    // return vera_heap_split_free_and_allocate(s, free_index, required_size);
    // [424] vera_heap_allocate::return#1 = vera_heap_split_free_and_allocate::return#2
    rts
}
  // vera_heap_data_pack
// __zp($16) unsigned int vera_heap_data_pack(__register(X) char vram_bank, __zp($16) unsigned int vram_offset)
vera_heap_data_pack: {
    .label vera_heap_data_pack__1 = $30
    .label vera_heap_data_pack__2 = $16
    .label vram_offset = $16
    .label return = $16
    // vram_bank<<5
    // [426] vera_heap_data_pack::$0 = vera_heap_data_pack::vram_bank#2 << 5 -- vbuaa=vbuxx_rol_5 
    txa
    asl
    asl
    asl
    asl
    asl
    // MAKEWORD(vram_bank<<5, 0)
    // [427] vera_heap_data_pack::$1 = vera_heap_data_pack::$0 w= 0 -- vwuz1=vbuaa_word_vbuc1 
    ldy #0
    sta.z vera_heap_data_pack__1+1
    sty.z vera_heap_data_pack__1
    // vram_offset>>3
    // [428] vera_heap_data_pack::$2 = vera_heap_data_pack::vram_offset#2 >> 3 -- vwuz1=vwuz1_ror_3 
    lsr.z vera_heap_data_pack__2+1
    ror.z vera_heap_data_pack__2
    lsr.z vera_heap_data_pack__2+1
    ror.z vera_heap_data_pack__2
    lsr.z vera_heap_data_pack__2+1
    ror.z vera_heap_data_pack__2
    // MAKEWORD(vram_bank<<5, 0) | (vram_offset>>3)
    // [429] vera_heap_data_pack::return#2 = vera_heap_data_pack::$1 | vera_heap_data_pack::$2 -- vwuz1=vwuz2_bor_vwuz1 
    lda.z return
    ora.z vera_heap_data_pack__1
    sta.z return
    lda.z return+1
    ora.z vera_heap_data_pack__1+1
    sta.z return+1
    // vera_heap_data_pack::@return
    // }
    // [430] return 
    rts
}
  // vera_heap_index_add
// __register(A) char vera_heap_index_add(__register(X) char s)
vera_heap_index_add: {
    .label index = $c
    .label return = $c
    // vera_heap_index_t index = vera_heap_segment.idle_list[s]
    // [432] vera_heap_index_add::index#0 = ((char *)&vera_heap_segment+$32)[vera_heap_index_add::s#2] -- vbuz1=pbuc1_derefidx_vbuxx 
    // TODO: Search idle list.
    lda vera_heap_segment+$32,x
    sta.z index
    // if(index != VERAHEAP_NULL)
    // [433] if(vera_heap_index_add::index#0!=$ff) goto vera_heap_index_add::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #$ff
    cmp.z index
    bne __b1
    // vera_heap_index_add::@3
    // index = vera_heap_segment.index_position
    // [434] vera_heap_index_add::index#1 = *((char *)&vera_heap_segment+1) -- vbuz1=_deref_pbuc1 
    // The current header gets the current heap position handle.
    lda vera_heap_segment+1
    sta.z index
    // vera_heap_segment.index_position += 1
    // [435] *((char *)&vera_heap_segment+1) = *((char *)&vera_heap_segment+1) + 1 -- _deref_pbuc1=_deref_pbuc1_plus_1 
    // We adjust to the next index position.
    inc vera_heap_segment+1
    // [436] phi from vera_heap_index_add::@1 vera_heap_index_add::@3 to vera_heap_index_add::@2 [phi:vera_heap_index_add::@1/vera_heap_index_add::@3->vera_heap_index_add::@2]
    // [436] phi vera_heap_index_add::return#1 = vera_heap_index_add::index#0 [phi:vera_heap_index_add::@1/vera_heap_index_add::@3->vera_heap_index_add::@2#0] -- register_copy 
    // vera_heap_index_add::@2
    // vera_heap_index_add::@return
    // }
    // [437] return 
    rts
    // vera_heap_index_add::@1
  __b1:
    // heap_idle_remove(s, index)
    // [438] heap_idle_remove::s#0 = vera_heap_index_add::s#2 -- vbuz1=vbuxx 
    stx.z heap_idle_remove.s
    // [439] heap_idle_remove::idle_index#0 = vera_heap_index_add::index#0 -- vbuz1=vbuz2 
    lda.z index
    sta.z heap_idle_remove.idle_index
    // [440] call heap_idle_remove
    jsr heap_idle_remove
    rts
}
  // vera_heap_list_insert_at
/**
* Insert index in list at sorted position.
*/
// __register(A) char vera_heap_list_insert_at(char s, __zp(6) char list, __zp($a) char index, __zp(7) char at)
vera_heap_list_insert_at: {
    .label list = 6
    .label index = $a
    .label at = 7
    .label last = 5
    .label first = 7
    // if(list == VERAHEAP_NULL)
    // [442] if(vera_heap_list_insert_at::list#5!=$ff) goto vera_heap_list_insert_at::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #$ff
    cmp.z list
    bne __b1
    // vera_heap_list_insert_at::@3
    // vera_heap_set_prev(s, index, index)
    // [443] vera_heap_set_prev::index#3 = vera_heap_list_insert_at::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [444] vera_heap_set_prev::prev#3 = vera_heap_list_insert_at::index#10 -- vbuaa=vbuz1 
    txa
    // [445] call vera_heap_set_prev
    // [492] phi from vera_heap_list_insert_at::@3 to vera_heap_set_prev [phi:vera_heap_list_insert_at::@3->vera_heap_set_prev]
    // [492] phi vera_heap_set_prev::index#6 = vera_heap_set_prev::index#3 [phi:vera_heap_list_insert_at::@3->vera_heap_set_prev#0] -- register_copy 
    // [492] phi vera_heap_set_prev::prev#6 = vera_heap_set_prev::prev#3 [phi:vera_heap_list_insert_at::@3->vera_heap_set_prev#1] -- register_copy 
    jsr vera_heap_set_prev
    // vera_heap_list_insert_at::@5
    // vera_heap_set_next(s, index, index)
    // [446] vera_heap_set_next::index#3 = vera_heap_list_insert_at::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [447] vera_heap_set_next::next#3 = vera_heap_list_insert_at::index#10 -- vbuaa=vbuz1 
    txa
    // [448] call vera_heap_set_next
    // [489] phi from vera_heap_list_insert_at::@5 to vera_heap_set_next [phi:vera_heap_list_insert_at::@5->vera_heap_set_next]
    // [489] phi vera_heap_set_next::index#6 = vera_heap_set_next::index#3 [phi:vera_heap_list_insert_at::@5->vera_heap_set_next#0] -- register_copy 
    // [489] phi vera_heap_set_next::next#6 = vera_heap_set_next::next#3 [phi:vera_heap_list_insert_at::@5->vera_heap_set_next#1] -- register_copy 
    jsr vera_heap_set_next
    // vera_heap_list_insert_at::@6
    // [449] vera_heap_list_insert_at::list#21 = vera_heap_list_insert_at::index#10 -- vbuz1=vbuz2 
    lda.z index
    sta.z list
    // [450] phi from vera_heap_list_insert_at vera_heap_list_insert_at::@6 to vera_heap_list_insert_at::@1 [phi:vera_heap_list_insert_at/vera_heap_list_insert_at::@6->vera_heap_list_insert_at::@1]
    // [450] phi vera_heap_list_insert_at::list#11 = vera_heap_list_insert_at::list#5 [phi:vera_heap_list_insert_at/vera_heap_list_insert_at::@6->vera_heap_list_insert_at::@1#0] -- register_copy 
    // vera_heap_list_insert_at::@1
  __b1:
    // if(at == VERAHEAP_NULL)
    // [451] if(vera_heap_list_insert_at::at#10!=$ff) goto vera_heap_list_insert_at::@2 -- vbuz1_neq_vbuc1_then_la1 
    lda #$ff
    cmp.z at
    bne __b2
    // vera_heap_list_insert_at::@4
    // [452] vera_heap_list_insert_at::first#5 = vera_heap_list_insert_at::list#11 -- vbuz1=vbuz2 
    lda.z list
    sta.z first
    // [453] phi from vera_heap_list_insert_at::@1 vera_heap_list_insert_at::@4 to vera_heap_list_insert_at::@2 [phi:vera_heap_list_insert_at::@1/vera_heap_list_insert_at::@4->vera_heap_list_insert_at::@2]
    // [453] phi vera_heap_list_insert_at::first#0 = vera_heap_list_insert_at::at#10 [phi:vera_heap_list_insert_at::@1/vera_heap_list_insert_at::@4->vera_heap_list_insert_at::@2#0] -- register_copy 
    // vera_heap_list_insert_at::@2
  __b2:
    // vera_heap_index_t last = vera_heap_get_prev(s, at)
    // [454] vera_heap_get_prev::index#1 = vera_heap_list_insert_at::first#0 -- vbuxx=vbuz1 
    ldx.z first
    // [455] call vera_heap_get_prev
    // [666] phi from vera_heap_list_insert_at::@2 to vera_heap_get_prev [phi:vera_heap_list_insert_at::@2->vera_heap_get_prev]
    // [666] phi vera_heap_get_prev::index#2 = vera_heap_get_prev::index#1 [phi:vera_heap_list_insert_at::@2->vera_heap_get_prev#0] -- register_copy 
    jsr vera_heap_get_prev
    // vera_heap_index_t last = vera_heap_get_prev(s, at)
    // [456] vera_heap_get_prev::return#3 = vera_heap_get_prev::return#1
    // vera_heap_list_insert_at::@7
    // [457] vera_heap_list_insert_at::last#0 = vera_heap_get_prev::return#3 -- vbuz1=vbuaa 
    sta.z last
    // vera_heap_set_prev(s, index, last)
    // [458] vera_heap_set_prev::index#4 = vera_heap_list_insert_at::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [459] vera_heap_set_prev::prev#4 = vera_heap_list_insert_at::last#0 -- vbuaa=vbuz1 
    // [460] call vera_heap_set_prev
  // Add index to list at last position.
    // [492] phi from vera_heap_list_insert_at::@7 to vera_heap_set_prev [phi:vera_heap_list_insert_at::@7->vera_heap_set_prev]
    // [492] phi vera_heap_set_prev::index#6 = vera_heap_set_prev::index#4 [phi:vera_heap_list_insert_at::@7->vera_heap_set_prev#0] -- register_copy 
    // [492] phi vera_heap_set_prev::prev#6 = vera_heap_set_prev::prev#4 [phi:vera_heap_list_insert_at::@7->vera_heap_set_prev#1] -- register_copy 
    jsr vera_heap_set_prev
    // vera_heap_list_insert_at::@8
    // vera_heap_set_next(s, last, index)
    // [461] vera_heap_set_next::index#4 = vera_heap_list_insert_at::last#0 -- vbuxx=vbuz1 
    ldx.z last
    // [462] vera_heap_set_next::next#4 = vera_heap_list_insert_at::index#10 -- vbuaa=vbuz1 
    lda.z index
    // [463] call vera_heap_set_next
    // [489] phi from vera_heap_list_insert_at::@8 to vera_heap_set_next [phi:vera_heap_list_insert_at::@8->vera_heap_set_next]
    // [489] phi vera_heap_set_next::index#6 = vera_heap_set_next::index#4 [phi:vera_heap_list_insert_at::@8->vera_heap_set_next#0] -- register_copy 
    // [489] phi vera_heap_set_next::next#6 = vera_heap_set_next::next#4 [phi:vera_heap_list_insert_at::@8->vera_heap_set_next#1] -- register_copy 
    jsr vera_heap_set_next
    // vera_heap_list_insert_at::@9
    // vera_heap_set_next(s, index, first)
    // [464] vera_heap_set_next::index#5 = vera_heap_list_insert_at::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [465] vera_heap_set_next::next#5 = vera_heap_list_insert_at::first#0 -- vbuaa=vbuz1 
    lda.z first
    // [466] call vera_heap_set_next
    // [489] phi from vera_heap_list_insert_at::@9 to vera_heap_set_next [phi:vera_heap_list_insert_at::@9->vera_heap_set_next]
    // [489] phi vera_heap_set_next::index#6 = vera_heap_set_next::index#5 [phi:vera_heap_list_insert_at::@9->vera_heap_set_next#0] -- register_copy 
    // [489] phi vera_heap_set_next::next#6 = vera_heap_set_next::next#5 [phi:vera_heap_list_insert_at::@9->vera_heap_set_next#1] -- register_copy 
    jsr vera_heap_set_next
    // vera_heap_list_insert_at::@10
    // vera_heap_set_prev(s, first, index)
    // [467] vera_heap_set_prev::index#5 = vera_heap_list_insert_at::first#0 -- vbuxx=vbuz1 
    ldx.z first
    // [468] vera_heap_set_prev::prev#5 = vera_heap_list_insert_at::index#10 -- vbuaa=vbuz1 
    lda.z index
    // [469] call vera_heap_set_prev
    // [492] phi from vera_heap_list_insert_at::@10 to vera_heap_set_prev [phi:vera_heap_list_insert_at::@10->vera_heap_set_prev]
    // [492] phi vera_heap_set_prev::index#6 = vera_heap_set_prev::index#5 [phi:vera_heap_list_insert_at::@10->vera_heap_set_prev#0] -- register_copy 
    // [492] phi vera_heap_set_prev::prev#6 = vera_heap_set_prev::prev#5 [phi:vera_heap_list_insert_at::@10->vera_heap_set_prev#1] -- register_copy 
    jsr vera_heap_set_prev
    // vera_heap_list_insert_at::@return
    // }
    // [470] return 
    rts
}
  // vera_heap_set_data_packed
// void vera_heap_set_data_packed(char s, __register(X) char index, __zp($d) unsigned int data_packed)
vera_heap_set_data_packed: {
    .label data_packed = $d
    // BYTE1(data_packed)
    // [472] vera_heap_set_data_packed::$0 = byte1  vera_heap_set_data_packed::data_packed#7 -- vbuaa=_byte1_vwuz1 
    lda.z data_packed+1
    // vera_heap_index.data1[index] = BYTE1(data_packed)
    // [473] ((char *)&vera_heap_index+$300)[vera_heap_set_data_packed::index#7] = vera_heap_set_data_packed::$0 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta vera_heap_index+$300,x
    // BYTE0(data_packed)
    // [474] vera_heap_set_data_packed::$1 = byte0  vera_heap_set_data_packed::data_packed#7 -- vbuaa=_byte0_vwuz1 
    lda.z data_packed
    // vera_heap_index.data0[index] = BYTE0(data_packed)
    // [475] ((char *)&vera_heap_index+$200)[vera_heap_set_data_packed::index#7] = vera_heap_set_data_packed::$1 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta vera_heap_index+$200,x
    // vera_heap_set_data_packed::@return
    // }
    // [476] return 
    rts
}
  // vera_heap_set_size_packed
// void vera_heap_set_size_packed(char s, __register(X) char index, __zp(8) unsigned int size_packed)
vera_heap_set_size_packed: {
    .label size_packed = 8
    // vera_heap_index.size1[index] & 0x80
    // [478] vera_heap_set_size_packed::$0 = ((char *)&vera_heap_index+$500)[vera_heap_set_size_packed::index#6] & $80 -- vbuaa=pbuc1_derefidx_vbuxx_band_vbuc2 
    lda #$80
    and vera_heap_index+$500,x
    // vera_heap_index.size1[index] &= vera_heap_index.size1[index] & 0x80
    // [479] ((char *)&vera_heap_index+$500)[vera_heap_set_size_packed::index#6] = ((char *)&vera_heap_index+$500)[vera_heap_set_size_packed::index#6] & vera_heap_set_size_packed::$0 -- pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_band_vbuaa 
    and vera_heap_index+$500,x
    sta vera_heap_index+$500,x
    // BYTE1(size_packed)
    // [480] vera_heap_set_size_packed::$1 = byte1  vera_heap_set_size_packed::size_packed#6 -- vbuaa=_byte1_vwuz1 
    lda.z size_packed+1
    // BYTE1(size_packed) & 0x7F
    // [481] vera_heap_set_size_packed::$2 = vera_heap_set_size_packed::$1 & $7f -- vbuaa=vbuaa_band_vbuc1 
    and #$7f
    // vera_heap_index.size1[index] = BYTE1(size_packed) & 0x7F
    // [482] ((char *)&vera_heap_index+$500)[vera_heap_set_size_packed::index#6] = vera_heap_set_size_packed::$2 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta vera_heap_index+$500,x
    // BYTE0(size_packed)
    // [483] vera_heap_set_size_packed::$3 = byte0  vera_heap_set_size_packed::size_packed#6 -- vbuaa=_byte0_vwuz1 
    lda.z size_packed
    // vera_heap_index.size0[index] = BYTE0(size_packed)
    // [484] ((char *)&vera_heap_index+$400)[vera_heap_set_size_packed::index#6] = vera_heap_set_size_packed::$3 -- pbuc1_derefidx_vbuxx=vbuaa 
    // Ignore free flag.
    sta vera_heap_index+$400,x
    // vera_heap_set_size_packed::@return
    // }
    // [485] return 
    rts
}
  // vera_heap_set_free
// void vera_heap_set_free(char s, __register(X) char index)
vera_heap_set_free: {
    // vera_heap_index.size1[index] |= 0x80
    // [487] ((char *)&vera_heap_index+$500)[vera_heap_set_free::index#5] = ((char *)&vera_heap_index+$500)[vera_heap_set_free::index#5] | $80 -- pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_bor_vbuc2 
    lda #$80
    ora vera_heap_index+$500,x
    sta vera_heap_index+$500,x
    // vera_heap_set_free::@return
    // }
    // [488] return 
    rts
}
  // vera_heap_set_next
// void vera_heap_set_next(char s, __register(X) char index, __register(A) char next)
vera_heap_set_next: {
    // vera_heap_index.next[index] = next
    // [490] ((char *)&vera_heap_index+$600)[vera_heap_set_next::index#6] = vera_heap_set_next::next#6 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta vera_heap_index+$600,x
    // vera_heap_set_next::@return
    // }
    // [491] return 
    rts
}
  // vera_heap_set_prev
// void vera_heap_set_prev(char s, __register(X) char index, __register(A) char prev)
vera_heap_set_prev: {
    // vera_heap_index.prev[index] = prev
    // [493] ((char *)&vera_heap_index+$700)[vera_heap_set_prev::index#6] = vera_heap_set_prev::prev#6 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta vera_heap_index+$700,x
    // vera_heap_set_prev::@return
    // }
    // [494] return 
    rts
}
  // vera_heap_size_pack
// __zp($16) unsigned int vera_heap_size_pack(__zp($1e) unsigned long size)
vera_heap_size_pack: {
    .label vera_heap_size_pack__3 = $12
    .label vera_heap_size_pack__4 = $12
    .label vera_heap_size_pack__6 = $16
    .label return = $16
    .label size = $1e
    // BYTE2(size)
    // [495] vera_heap_size_pack::$0 = byte2  vera_heap_size_pack::size#0 -- vbuaa=_byte2_vduz1 
    lda.z size+2
    // BYTE2(size)<<5
    // [496] vera_heap_size_pack::$1 = vera_heap_size_pack::$0 << 5 -- vbuaa=vbuaa_rol_5 
    asl
    asl
    asl
    asl
    asl
    // (vera_heap_size_packed_t)MAKEWORD(BYTE2(size)<<5, 0) | (WORD0(size) >> 3)
    // [497] vera_heap_size_pack::$6 = vera_heap_size_pack::$1 w= 0 -- vwuz1=vbuaa_word_vbuc1 
    ldy #0
    sta.z vera_heap_size_pack__6+1
    sty.z vera_heap_size_pack__6
    // WORD0(size)
    // [498] vera_heap_size_pack::$3 = word0  vera_heap_size_pack::size#0 -- vwuz1=_word0_vduz2 
    lda.z size
    sta.z vera_heap_size_pack__3
    lda.z size+1
    sta.z vera_heap_size_pack__3+1
    // WORD0(size) >> 3
    // [499] vera_heap_size_pack::$4 = vera_heap_size_pack::$3 >> 3 -- vwuz1=vwuz1_ror_3 
    lsr.z vera_heap_size_pack__4+1
    ror.z vera_heap_size_pack__4
    lsr.z vera_heap_size_pack__4+1
    ror.z vera_heap_size_pack__4
    lsr.z vera_heap_size_pack__4+1
    ror.z vera_heap_size_pack__4
    // (vera_heap_size_packed_t)MAKEWORD(BYTE2(size)<<5, 0) | (WORD0(size) >> 3)
    // [500] vera_heap_size_pack::return#0 = vera_heap_size_pack::$6 | vera_heap_size_pack::$4 -- vwuz1=vwuz1_bor_vwuz2 
    lda.z return
    ora.z vera_heap_size_pack__4
    sta.z return
    lda.z return+1
    ora.z vera_heap_size_pack__4+1
    sta.z return+1
    // vera_heap_size_pack::@return
    // }
    // [501] return 
    rts
}
  // vera_heap_get_next
// __register(A) char vera_heap_get_next(char s, __register(X) char index)
vera_heap_get_next: {
    // return vera_heap_index.next[index];
    // [503] vera_heap_get_next::return#3 = ((char *)&vera_heap_index+$600)[vera_heap_get_next::index#4] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_heap_index+$600,x
    // vera_heap_get_next::@return
    // }
    // [504] return 
    rts
}
  // vera_heap_list_remove
/**
* Remove header from List
*/
// __register(A) char vera_heap_list_remove(char s, __register(Y) char list, __zp(4) char index)
vera_heap_list_remove: {
    .label vera_heap_list_remove__2 = 2
    .label next = 5
    .label prev = 3
    .label index = 4
    // if(list == VERAHEAP_NULL)
    // [506] if(vera_heap_list_remove::list#10!=$ff) goto vera_heap_list_remove::@1 -- vbuyy_neq_vbuc1_then_la1 
    cpy #$ff
    bne __b1
    // [507] phi from vera_heap_list_remove vera_heap_list_remove::@11 to vera_heap_list_remove::@return [phi:vera_heap_list_remove/vera_heap_list_remove::@11->vera_heap_list_remove::@return]
  __b4:
    // [507] phi vera_heap_list_remove::return#1 = $ff [phi:vera_heap_list_remove/vera_heap_list_remove::@11->vera_heap_list_remove::@return#0] -- vbuyy=vbuc1 
    ldy #$ff
    // vera_heap_list_remove::@return
  __breturn:
    // }
    // [508] return 
    rts
    // vera_heap_list_remove::@1
  __b1:
    // vera_heap_get_next(s, list)
    // [509] vera_heap_get_next::index#0 = vera_heap_list_remove::list#10 -- vbuxx=vbuyy 
    tya
    tax
    // [510] call vera_heap_get_next
    // [502] phi from vera_heap_list_remove::@1 to vera_heap_get_next [phi:vera_heap_list_remove::@1->vera_heap_get_next]
    // [502] phi vera_heap_get_next::index#4 = vera_heap_get_next::index#0 [phi:vera_heap_list_remove::@1->vera_heap_get_next#0] -- register_copy 
    jsr vera_heap_get_next
    // vera_heap_get_next(s, list)
    // [511] vera_heap_get_next::return#0 = vera_heap_get_next::return#3
    // vera_heap_list_remove::@6
    // [512] vera_heap_list_remove::$2 = vera_heap_get_next::return#0 -- vbuz1=vbuaa 
    sta.z vera_heap_list_remove__2
    // if(list == vera_heap_get_next(s, list))
    // [513] if(vera_heap_list_remove::list#10!=vera_heap_list_remove::$2) goto vera_heap_list_remove::@2 -- vbuyy_neq_vbuz1_then_la1 
    cpy.z vera_heap_list_remove__2
    bne __b2
    // vera_heap_list_remove::@4
    // vera_heap_set_next(s, index, VERAHEAP_NULL)
    // [514] vera_heap_set_next::index#2 = vera_heap_list_remove::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [515] call vera_heap_set_next
  // We initialize the start of the list to null.
    // [489] phi from vera_heap_list_remove::@4 to vera_heap_set_next [phi:vera_heap_list_remove::@4->vera_heap_set_next]
    // [489] phi vera_heap_set_next::index#6 = vera_heap_set_next::index#2 [phi:vera_heap_list_remove::@4->vera_heap_set_next#0] -- register_copy 
    // [489] phi vera_heap_set_next::next#6 = $ff [phi:vera_heap_list_remove::@4->vera_heap_set_next#1] -- vbuaa=vbuc1 
    lda #$ff
    jsr vera_heap_set_next
    // vera_heap_list_remove::@11
    // vera_heap_set_prev(s, index, VERAHEAP_NULL)
    // [516] vera_heap_set_prev::index#2 = vera_heap_list_remove::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [517] call vera_heap_set_prev
    // [492] phi from vera_heap_list_remove::@11 to vera_heap_set_prev [phi:vera_heap_list_remove::@11->vera_heap_set_prev]
    // [492] phi vera_heap_set_prev::index#6 = vera_heap_set_prev::index#2 [phi:vera_heap_list_remove::@11->vera_heap_set_prev#0] -- register_copy 
    // [492] phi vera_heap_set_prev::prev#6 = $ff [phi:vera_heap_list_remove::@11->vera_heap_set_prev#1] -- vbuaa=vbuc1 
    lda #$ff
    jsr vera_heap_set_prev
    jmp __b4
    // vera_heap_list_remove::@2
  __b2:
    // vera_heap_index_t next = vera_heap_get_next(s, index)
    // [518] vera_heap_get_next::index#1 = vera_heap_list_remove::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [519] call vera_heap_get_next
    // [502] phi from vera_heap_list_remove::@2 to vera_heap_get_next [phi:vera_heap_list_remove::@2->vera_heap_get_next]
    // [502] phi vera_heap_get_next::index#4 = vera_heap_get_next::index#1 [phi:vera_heap_list_remove::@2->vera_heap_get_next#0] -- register_copy 
    jsr vera_heap_get_next
    // vera_heap_index_t next = vera_heap_get_next(s, index)
    // [520] vera_heap_get_next::return#1 = vera_heap_get_next::return#3
    // vera_heap_list_remove::@7
    // [521] vera_heap_list_remove::next#0 = vera_heap_get_next::return#1 -- vbuz1=vbuaa 
    sta.z next
    // vera_heap_index_t prev = vera_heap_get_prev(s, index)
    // [522] vera_heap_get_prev::index#0 = vera_heap_list_remove::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [523] call vera_heap_get_prev
    // [666] phi from vera_heap_list_remove::@7 to vera_heap_get_prev [phi:vera_heap_list_remove::@7->vera_heap_get_prev]
    // [666] phi vera_heap_get_prev::index#2 = vera_heap_get_prev::index#0 [phi:vera_heap_list_remove::@7->vera_heap_get_prev#0] -- register_copy 
    jsr vera_heap_get_prev
    // vera_heap_index_t prev = vera_heap_get_prev(s, index)
    // [524] vera_heap_get_prev::return#0 = vera_heap_get_prev::return#1
    // vera_heap_list_remove::@8
    // [525] vera_heap_list_remove::prev#0 = vera_heap_get_prev::return#0 -- vbuz1=vbuaa 
    sta.z prev
    // vera_heap_set_next(s, prev, next)
    // [526] vera_heap_set_next::index#1 = vera_heap_list_remove::prev#0 -- vbuxx=vbuz1 
    tax
    // [527] vera_heap_set_next::next#1 = vera_heap_list_remove::next#0 -- vbuaa=vbuz1 
    lda.z next
    // [528] call vera_heap_set_next
  // TODO, why can't this be coded in one statement ...
    // [489] phi from vera_heap_list_remove::@8 to vera_heap_set_next [phi:vera_heap_list_remove::@8->vera_heap_set_next]
    // [489] phi vera_heap_set_next::index#6 = vera_heap_set_next::index#1 [phi:vera_heap_list_remove::@8->vera_heap_set_next#0] -- register_copy 
    // [489] phi vera_heap_set_next::next#6 = vera_heap_set_next::next#1 [phi:vera_heap_list_remove::@8->vera_heap_set_next#1] -- register_copy 
    jsr vera_heap_set_next
    // vera_heap_list_remove::@9
    // vera_heap_set_prev(s, next, prev)
    // [529] vera_heap_set_prev::index#1 = vera_heap_list_remove::next#0 -- vbuxx=vbuz1 
    ldx.z next
    // [530] vera_heap_set_prev::prev#1 = vera_heap_list_remove::prev#0 -- vbuaa=vbuz1 
    lda.z prev
    // [531] call vera_heap_set_prev
    // [492] phi from vera_heap_list_remove::@9 to vera_heap_set_prev [phi:vera_heap_list_remove::@9->vera_heap_set_prev]
    // [492] phi vera_heap_set_prev::index#6 = vera_heap_set_prev::index#1 [phi:vera_heap_list_remove::@9->vera_heap_set_prev#0] -- register_copy 
    // [492] phi vera_heap_set_prev::prev#6 = vera_heap_set_prev::prev#1 [phi:vera_heap_list_remove::@9->vera_heap_set_prev#1] -- register_copy 
    jsr vera_heap_set_prev
    // vera_heap_list_remove::@10
    // if(index == list)
    // [532] if(vera_heap_list_remove::index#10!=vera_heap_list_remove::list#10) goto vera_heap_list_remove::@3 -- vbuz1_neq_vbuyy_then_la1 
    cpy.z index
    bne __breturn
    // vera_heap_list_remove::@5
    // vera_heap_get_next(s, list)
    // [533] vera_heap_get_next::index#2 = vera_heap_list_remove::list#10 -- vbuxx=vbuyy 
    tya
    tax
    // [534] call vera_heap_get_next
    // [502] phi from vera_heap_list_remove::@5 to vera_heap_get_next [phi:vera_heap_list_remove::@5->vera_heap_get_next]
    // [502] phi vera_heap_get_next::index#4 = vera_heap_get_next::index#2 [phi:vera_heap_list_remove::@5->vera_heap_get_next#0] -- register_copy 
    jsr vera_heap_get_next
    // vera_heap_get_next(s, list)
    // [535] vera_heap_get_next::return#2 = vera_heap_get_next::return#3
    // vera_heap_list_remove::@12
    // list = vera_heap_get_next(s, list)
    // [536] vera_heap_list_remove::list#1 = vera_heap_get_next::return#2 -- vbuyy=vbuaa 
    tay
    // [537] phi from vera_heap_list_remove::@10 vera_heap_list_remove::@12 to vera_heap_list_remove::@3 [phi:vera_heap_list_remove::@10/vera_heap_list_remove::@12->vera_heap_list_remove::@3]
    // [537] phi vera_heap_list_remove::return#3 = vera_heap_list_remove::list#10 [phi:vera_heap_list_remove::@10/vera_heap_list_remove::@12->vera_heap_list_remove::@3#0] -- register_copy 
    // vera_heap_list_remove::@3
    // [507] phi from vera_heap_list_remove::@3 to vera_heap_list_remove::@return [phi:vera_heap_list_remove::@3->vera_heap_list_remove::@return]
    // [507] phi vera_heap_list_remove::return#1 = vera_heap_list_remove::return#3 [phi:vera_heap_list_remove::@3->vera_heap_list_remove::@return#0] -- register_copy 
    rts
}
  // vera_heap_get_left
// __register(A) char vera_heap_get_left(char s, __register(X) char index)
vera_heap_get_left: {
    // return vera_heap_index.left[index];
    // [539] vera_heap_get_left::return#0 = ((char *)&vera_heap_index+$900)[vera_heap_get_left::index#4] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_heap_index+$900,x
    // vera_heap_get_left::@return
    // }
    // [540] return 
    rts
}
  // vera_heap_is_free
// __register(A) bool vera_heap_is_free(char s, __register(X) char index)
vera_heap_is_free: {
    // vera_heap_index.size1[index] & 0x80
    // [542] vera_heap_is_free::$0 = ((char *)&vera_heap_index+$500)[vera_heap_is_free::index#2] & $80 -- vbuaa=pbuc1_derefidx_vbuxx_band_vbuc2 
    lda #$80
    and vera_heap_index+$500,x
    // (vera_heap_index.size1[index] & 0x80) == 0x80
    // [543] vera_heap_is_free::return#0 = vera_heap_is_free::$0 == $80 -- vboaa=vbuaa_eq_vbuc1 
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // vera_heap_is_free::@return
    // }
    // [544] return 
    rts
}
  // vera_heap_get_right
// __register(A) char vera_heap_get_right(char s, __register(X) char index)
vera_heap_get_right: {
    // return vera_heap_index.right[index];
    // [546] vera_heap_get_right::return#0 = ((char *)&vera_heap_index+$800)[vera_heap_get_right::index#3] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_heap_index+$800,x
    // vera_heap_get_right::@return
    // }
    // [547] return 
    rts
}
  // vera_heap_free_remove
// void vera_heap_free_remove(__zp($f) char s, __zp($10) char free_index)
vera_heap_free_remove: {
    .label s = $f
    .label free_index = $10
    // vera_heap_segment.freeCount[s]--;
    // [549] vera_heap_free_remove::$4 = vera_heap_free_remove::s#2 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [550] ((unsigned int *)&vera_heap_segment+$46)[vera_heap_free_remove::$4] = -- ((unsigned int *)&vera_heap_segment+$46)[vera_heap_free_remove::$4] -- pwuc1_derefidx_vbuaa=_dec_pwuc1_derefidx_vbuaa 
    tax
    lda vera_heap_segment+$46,x
    bne !+
    dec vera_heap_segment+$46+1,x
  !:
    dec vera_heap_segment+$46,x
    // vera_heap_list_remove(s, vera_heap_segment.free_list[s], free_index)
    // [551] vera_heap_list_remove::list#3 = ((char *)&vera_heap_segment+$2e)[vera_heap_free_remove::s#2] -- vbuyy=pbuc1_derefidx_vbuz1 
    ldx.z s
    ldy vera_heap_segment+$2e,x
    // [552] vera_heap_list_remove::index#1 = vera_heap_free_remove::free_index#2 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z vera_heap_list_remove.index
    // [553] call vera_heap_list_remove
    // [505] phi from vera_heap_free_remove to vera_heap_list_remove [phi:vera_heap_free_remove->vera_heap_list_remove]
    // [505] phi vera_heap_list_remove::index#10 = vera_heap_list_remove::index#1 [phi:vera_heap_free_remove->vera_heap_list_remove#0] -- register_copy 
    // [505] phi vera_heap_list_remove::list#10 = vera_heap_list_remove::list#3 [phi:vera_heap_free_remove->vera_heap_list_remove#1] -- register_copy 
    jsr vera_heap_list_remove
    // vera_heap_list_remove(s, vera_heap_segment.free_list[s], free_index)
    // [554] vera_heap_list_remove::return#5 = vera_heap_list_remove::return#1 -- vbuaa=vbuyy 
    tya
    // vera_heap_free_remove::@1
    // [555] vera_heap_free_remove::$1 = vera_heap_list_remove::return#5
    // vera_heap_segment.free_list[s] = vera_heap_list_remove(s, vera_heap_segment.free_list[s], free_index)
    // [556] ((char *)&vera_heap_segment+$2e)[vera_heap_free_remove::s#2] = vera_heap_free_remove::$1 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z s
    sta vera_heap_segment+$2e,y
    // vera_heap_clear_free(s, free_index)
    // [557] vera_heap_clear_free::index#0 = vera_heap_free_remove::free_index#2 -- vbuxx=vbuz1 
    ldx.z free_index
    // [558] call vera_heap_clear_free
    // [669] phi from vera_heap_free_remove::@1 to vera_heap_clear_free [phi:vera_heap_free_remove::@1->vera_heap_clear_free]
    // [669] phi vera_heap_clear_free::index#2 = vera_heap_clear_free::index#0 [phi:vera_heap_free_remove::@1->vera_heap_clear_free#0] -- register_copy 
    jsr vera_heap_clear_free
    // vera_heap_free_remove::@return
    // }
    // [559] return 
    rts
}
  // vera_heap_idle_insert
// char vera_heap_idle_insert(__zp($22) char s, __zp($23) char idle_index)
vera_heap_idle_insert: {
    .label s = $22
    .label idle_index = $23
    // vera_heap_list_insert_at(s, vera_heap_segment.idle_list[s], idle_index, vera_heap_segment.idle_list[s])
    // [560] vera_heap_list_insert_at::list#4 = ((char *)&vera_heap_segment+$32)[vera_heap_idle_insert::s#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda vera_heap_segment+$32,y
    sta.z vera_heap_list_insert_at.list
    // [561] vera_heap_list_insert_at::index#3 = vera_heap_idle_insert::idle_index#0 -- vbuz1=vbuz2 
    lda.z idle_index
    sta.z vera_heap_list_insert_at.index
    // [562] vera_heap_list_insert_at::at#4 = ((char *)&vera_heap_segment+$32)[vera_heap_idle_insert::s#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    lda vera_heap_segment+$32,y
    sta.z vera_heap_list_insert_at.at
    // [563] call vera_heap_list_insert_at
    // [441] phi from vera_heap_idle_insert to vera_heap_list_insert_at [phi:vera_heap_idle_insert->vera_heap_list_insert_at]
    // [441] phi vera_heap_list_insert_at::index#10 = vera_heap_list_insert_at::index#3 [phi:vera_heap_idle_insert->vera_heap_list_insert_at#0] -- register_copy 
    // [441] phi vera_heap_list_insert_at::at#10 = vera_heap_list_insert_at::at#4 [phi:vera_heap_idle_insert->vera_heap_list_insert_at#1] -- register_copy 
    // [441] phi vera_heap_list_insert_at::list#5 = vera_heap_list_insert_at::list#4 [phi:vera_heap_idle_insert->vera_heap_list_insert_at#2] -- register_copy 
    jsr vera_heap_list_insert_at
    // vera_heap_list_insert_at(s, vera_heap_segment.idle_list[s], idle_index, vera_heap_segment.idle_list[s])
    // [564] vera_heap_list_insert_at::return#10 = vera_heap_list_insert_at::list#11 -- vbuaa=vbuz1 
    lda.z vera_heap_list_insert_at.list
    // vera_heap_idle_insert::@1
    // [565] vera_heap_idle_insert::$0 = vera_heap_list_insert_at::return#10
    // vera_heap_segment.idle_list[s] = vera_heap_list_insert_at(s, vera_heap_segment.idle_list[s], idle_index, vera_heap_segment.idle_list[s])
    // [566] ((char *)&vera_heap_segment+$32)[vera_heap_idle_insert::s#0] = vera_heap_idle_insert::$0 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z s
    sta vera_heap_segment+$32,y
    // vera_heap_set_data_packed(s, idle_index, 0)
    // [567] vera_heap_set_data_packed::index#2 = vera_heap_idle_insert::idle_index#0 -- vbuxx=vbuz1 
    ldx.z idle_index
    // [568] call vera_heap_set_data_packed
    // [471] phi from vera_heap_idle_insert::@1 to vera_heap_set_data_packed [phi:vera_heap_idle_insert::@1->vera_heap_set_data_packed]
    // [471] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#2 [phi:vera_heap_idle_insert::@1->vera_heap_set_data_packed#0] -- register_copy 
    // [471] phi vera_heap_set_data_packed::data_packed#7 = 0 [phi:vera_heap_idle_insert::@1->vera_heap_set_data_packed#1] -- vwuz1=vbuc1 
    lda #<0
    sta.z vera_heap_set_data_packed.data_packed
    sta.z vera_heap_set_data_packed.data_packed+1
    jsr vera_heap_set_data_packed
    // vera_heap_idle_insert::@2
    // vera_heap_set_size_packed(s, idle_index, 0)
    // [569] vera_heap_set_size_packed::index#3 = vera_heap_idle_insert::idle_index#0 -- vbuxx=vbuz1 
    ldx.z idle_index
    // [570] call vera_heap_set_size_packed
    // [477] phi from vera_heap_idle_insert::@2 to vera_heap_set_size_packed [phi:vera_heap_idle_insert::@2->vera_heap_set_size_packed]
    // [477] phi vera_heap_set_size_packed::size_packed#6 = 0 [phi:vera_heap_idle_insert::@2->vera_heap_set_size_packed#0] -- vwuz1=vbuc1 
    lda #<0
    sta.z vera_heap_set_size_packed.size_packed
    sta.z vera_heap_set_size_packed.size_packed+1
    // [477] phi vera_heap_set_size_packed::index#6 = vera_heap_set_size_packed::index#3 [phi:vera_heap_idle_insert::@2->vera_heap_set_size_packed#1] -- register_copy 
    jsr vera_heap_set_size_packed
    // vera_heap_idle_insert::@3
    // vera_heap_segment.idleCount[s]++;
    // [571] vera_heap_idle_insert::$5 = vera_heap_idle_insert::s#0 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [572] ((unsigned int *)&vera_heap_segment+$4e)[vera_heap_idle_insert::$5] = ++ ((unsigned int *)&vera_heap_segment+$4e)[vera_heap_idle_insert::$5] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc vera_heap_segment+$4e,x
    bne !+
    inc vera_heap_segment+$4e+1,x
  !:
    // vera_heap_idle_insert::@return
    // }
    // [573] return 
    rts
}
  // vera_heap_set_left
// void vera_heap_set_left(char s, __register(X) char index, __register(A) char left)
vera_heap_set_left: {
    // vera_heap_index.left[index] = left
    // [575] ((char *)&vera_heap_index+$900)[vera_heap_set_left::index#6] = vera_heap_set_left::left#6 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta vera_heap_index+$900,x
    // vera_heap_set_left::@return
    // }
    // [576] return 
    rts
}
  // vera_heap_set_right
// void vera_heap_set_right(char s, __register(X) char index, __register(A) char right)
vera_heap_set_right: {
    // vera_heap_index.right[index] = right
    // [578] ((char *)&vera_heap_index+$800)[vera_heap_set_right::index#6] = vera_heap_set_right::right#6 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta vera_heap_index+$800,x
    // vera_heap_set_right::@return
    // }
    // [579] return 
    rts
}
  // vera_heap_replace_free_with_heap
/**
 * The free size matches exactly the required heap size.
 * The free index is replaced by a heap index.
 */
// __zp($27) char vera_heap_replace_free_with_heap(__zp($37) char s, char free_index, __zp($24) unsigned int required_size)
vera_heap_replace_free_with_heap: {
    .label free_data = $1a
    .label free_left = $35
    .label free_right = $32
    .label s = $37
    .label required_size = $24
    .label return = $27
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [580] vera_heap_get_size_packed::index#2 = vera_heap_replace_free_with_heap::return#2 -- vbuxx=vbuz1 
    ldx.z return
    // [581] call vera_heap_get_size_packed
    // [256] phi from vera_heap_replace_free_with_heap to vera_heap_get_size_packed [phi:vera_heap_replace_free_with_heap->vera_heap_get_size_packed]
    // [256] phi vera_heap_get_size_packed::index#8 = vera_heap_get_size_packed::index#2 [phi:vera_heap_replace_free_with_heap->vera_heap_get_size_packed#0] -- register_copy 
    jsr vera_heap_get_size_packed
    // vera_heap_replace_free_with_heap::@1
    // vera_heap_data_packed_t free_data = vera_heap_get_data_packed(s, free_index)
    // [582] vera_heap_get_data_packed::index#2 = vera_heap_replace_free_with_heap::return#2 -- vbuxx=vbuz1 
    ldx.z return
    // [583] call vera_heap_get_data_packed
    // [253] phi from vera_heap_replace_free_with_heap::@1 to vera_heap_get_data_packed [phi:vera_heap_replace_free_with_heap::@1->vera_heap_get_data_packed]
    // [253] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#2 [phi:vera_heap_replace_free_with_heap::@1->vera_heap_get_data_packed#0] -- register_copy 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t free_data = vera_heap_get_data_packed(s, free_index)
    // [584] vera_heap_get_data_packed::return#14 = vera_heap_get_data_packed::return#1 -- vwuz1=vwuz2 
    lda.z vera_heap_get_data_packed.return
    sta.z vera_heap_get_data_packed.return_2
    lda.z vera_heap_get_data_packed.return+1
    sta.z vera_heap_get_data_packed.return_2+1
    // vera_heap_replace_free_with_heap::@2
    // [585] vera_heap_replace_free_with_heap::free_data#0 = vera_heap_get_data_packed::return#14
    // vera_heap_index_t free_left = vera_heap_get_left(s, free_index)
    // [586] vera_heap_get_left::index#0 = vera_heap_replace_free_with_heap::return#2 -- vbuxx=vbuz1 
    ldx.z return
    // [587] call vera_heap_get_left
    // [538] phi from vera_heap_replace_free_with_heap::@2 to vera_heap_get_left [phi:vera_heap_replace_free_with_heap::@2->vera_heap_get_left]
    // [538] phi vera_heap_get_left::index#4 = vera_heap_get_left::index#0 [phi:vera_heap_replace_free_with_heap::@2->vera_heap_get_left#0] -- register_copy 
    jsr vera_heap_get_left
    // vera_heap_index_t free_left = vera_heap_get_left(s, free_index)
    // [588] vera_heap_get_left::return#2 = vera_heap_get_left::return#0
    // vera_heap_replace_free_with_heap::@3
    // [589] vera_heap_replace_free_with_heap::free_left#0 = vera_heap_get_left::return#2 -- vbuz1=vbuaa 
    sta.z free_left
    // vera_heap_index_t free_right = vera_heap_get_right(s, free_index)
    // [590] vera_heap_get_right::index#0 = vera_heap_replace_free_with_heap::return#2 -- vbuxx=vbuz1 
    ldx.z return
    // [591] call vera_heap_get_right
    // [545] phi from vera_heap_replace_free_with_heap::@3 to vera_heap_get_right [phi:vera_heap_replace_free_with_heap::@3->vera_heap_get_right]
    // [545] phi vera_heap_get_right::index#3 = vera_heap_get_right::index#0 [phi:vera_heap_replace_free_with_heap::@3->vera_heap_get_right#0] -- register_copy 
    jsr vera_heap_get_right
    // vera_heap_index_t free_right = vera_heap_get_right(s, free_index)
    // [592] vera_heap_get_right::return#2 = vera_heap_get_right::return#0
    // vera_heap_replace_free_with_heap::@4
    // [593] vera_heap_replace_free_with_heap::free_right#0 = vera_heap_get_right::return#2 -- vbuz1=vbuaa 
    sta.z free_right
    // vera_heap_free_remove(s, free_index)
    // [594] vera_heap_free_remove::s#0 = vera_heap_replace_free_with_heap::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_free_remove.s
    // [595] vera_heap_free_remove::free_index#0 = vera_heap_replace_free_with_heap::return#2 -- vbuz1=vbuz2 
    lda.z return
    sta.z vera_heap_free_remove.free_index
    // [596] call vera_heap_free_remove
    // [548] phi from vera_heap_replace_free_with_heap::@4 to vera_heap_free_remove [phi:vera_heap_replace_free_with_heap::@4->vera_heap_free_remove]
    // [548] phi vera_heap_free_remove::free_index#2 = vera_heap_free_remove::free_index#0 [phi:vera_heap_replace_free_with_heap::@4->vera_heap_free_remove#0] -- register_copy 
    // [548] phi vera_heap_free_remove::s#2 = vera_heap_free_remove::s#0 [phi:vera_heap_replace_free_with_heap::@4->vera_heap_free_remove#1] -- register_copy 
    jsr vera_heap_free_remove
    // vera_heap_replace_free_with_heap::@5
    // vera_heap_heap_insert_at(s, heap_index, VERAHEAP_NULL, required_size)
    // [597] vera_heap_heap_insert_at::s#0 = vera_heap_replace_free_with_heap::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_heap_insert_at.s
    // [598] vera_heap_heap_insert_at::heap_index#0 = vera_heap_replace_free_with_heap::return#2 -- vbuz1=vbuz2 
    lda.z return
    sta.z vera_heap_heap_insert_at.heap_index
    // [599] vera_heap_heap_insert_at::size#0 = vera_heap_replace_free_with_heap::required_size#0 -- vwuz1=vwuz2 
    lda.z required_size
    sta.z vera_heap_heap_insert_at.size
    lda.z required_size+1
    sta.z vera_heap_heap_insert_at.size+1
    // [600] call vera_heap_heap_insert_at
    // [672] phi from vera_heap_replace_free_with_heap::@5 to vera_heap_heap_insert_at [phi:vera_heap_replace_free_with_heap::@5->vera_heap_heap_insert_at]
    // [672] phi vera_heap_heap_insert_at::size#2 = vera_heap_heap_insert_at::size#0 [phi:vera_heap_replace_free_with_heap::@5->vera_heap_heap_insert_at#0] -- register_copy 
    // [672] phi vera_heap_heap_insert_at::heap_index#2 = vera_heap_heap_insert_at::heap_index#0 [phi:vera_heap_replace_free_with_heap::@5->vera_heap_heap_insert_at#1] -- register_copy 
    // [672] phi vera_heap_heap_insert_at::s#2 = vera_heap_heap_insert_at::s#0 [phi:vera_heap_replace_free_with_heap::@5->vera_heap_heap_insert_at#2] -- register_copy 
    jsr vera_heap_heap_insert_at
    // vera_heap_replace_free_with_heap::@6
    // vera_heap_set_data_packed(s, heap_index, free_data)
    // [601] vera_heap_set_data_packed::index#3 = vera_heap_replace_free_with_heap::return#2 -- vbuxx=vbuz1 
    ldx.z return
    // [602] vera_heap_set_data_packed::data_packed#3 = vera_heap_replace_free_with_heap::free_data#0 -- vwuz1=vwuz2 
    lda.z free_data
    sta.z vera_heap_set_data_packed.data_packed
    lda.z free_data+1
    sta.z vera_heap_set_data_packed.data_packed+1
    // [603] call vera_heap_set_data_packed
    // [471] phi from vera_heap_replace_free_with_heap::@6 to vera_heap_set_data_packed [phi:vera_heap_replace_free_with_heap::@6->vera_heap_set_data_packed]
    // [471] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#3 [phi:vera_heap_replace_free_with_heap::@6->vera_heap_set_data_packed#0] -- register_copy 
    // [471] phi vera_heap_set_data_packed::data_packed#7 = vera_heap_set_data_packed::data_packed#3 [phi:vera_heap_replace_free_with_heap::@6->vera_heap_set_data_packed#1] -- register_copy 
    jsr vera_heap_set_data_packed
    // vera_heap_replace_free_with_heap::@7
    // vera_heap_set_left(s, heap_index, free_left)
    // [604] vera_heap_set_left::index#0 = vera_heap_replace_free_with_heap::return#2 -- vbuxx=vbuz1 
    ldx.z return
    // [605] vera_heap_set_left::left#0 = vera_heap_replace_free_with_heap::free_left#0 -- vbuaa=vbuz1 
    lda.z free_left
    // [606] call vera_heap_set_left
    // [574] phi from vera_heap_replace_free_with_heap::@7 to vera_heap_set_left [phi:vera_heap_replace_free_with_heap::@7->vera_heap_set_left]
    // [574] phi vera_heap_set_left::index#6 = vera_heap_set_left::index#0 [phi:vera_heap_replace_free_with_heap::@7->vera_heap_set_left#0] -- register_copy 
    // [574] phi vera_heap_set_left::left#6 = vera_heap_set_left::left#0 [phi:vera_heap_replace_free_with_heap::@7->vera_heap_set_left#1] -- register_copy 
    jsr vera_heap_set_left
    // vera_heap_replace_free_with_heap::@8
    // vera_heap_set_right(s, heap_index, free_right)
    // [607] vera_heap_set_right::index#0 = vera_heap_replace_free_with_heap::return#2 -- vbuxx=vbuz1 
    ldx.z return
    // [608] vera_heap_set_right::right#0 = vera_heap_replace_free_with_heap::free_right#0 -- vbuaa=vbuz1 
    lda.z free_right
    // [609] call vera_heap_set_right
    // [577] phi from vera_heap_replace_free_with_heap::@8 to vera_heap_set_right [phi:vera_heap_replace_free_with_heap::@8->vera_heap_set_right]
    // [577] phi vera_heap_set_right::index#6 = vera_heap_set_right::index#0 [phi:vera_heap_replace_free_with_heap::@8->vera_heap_set_right#0] -- register_copy 
    // [577] phi vera_heap_set_right::right#6 = vera_heap_set_right::right#0 [phi:vera_heap_replace_free_with_heap::@8->vera_heap_set_right#1] -- register_copy 
    jsr vera_heap_set_right
    // vera_heap_replace_free_with_heap::@return
    // }
    // [610] return 
    rts
}
  // vera_heap_split_free_and_allocate
/**
 * Splits the header on two, returns the pointer to the smaller sub-header.
 */
// __register(A) char vera_heap_split_free_and_allocate(__zp($38) char s, __zp($2f) char free_index, __zp($33) unsigned int required_size)
vera_heap_split_free_and_allocate: {
    .label free_size = 8
    .label free_data = $18
    .label heap_index = $2a
    .label heap_left = $26
    .label s = $38
    .label free_index = $2f
    .label required_size = $33
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [611] vera_heap_get_size_packed::index#3 = vera_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [612] call vera_heap_get_size_packed
  // The free block is reduced in size with the required size.
    // [256] phi from vera_heap_split_free_and_allocate to vera_heap_get_size_packed [phi:vera_heap_split_free_and_allocate->vera_heap_get_size_packed]
    // [256] phi vera_heap_get_size_packed::index#8 = vera_heap_get_size_packed::index#3 [phi:vera_heap_split_free_and_allocate->vera_heap_get_size_packed#0] -- register_copy 
    jsr vera_heap_get_size_packed
    // vera_heap_size_packed_t free_size = vera_heap_get_size_packed(s, free_index)
    // [613] vera_heap_get_size_packed::return#13 = vera_heap_get_size_packed::return#12
    // vera_heap_split_free_and_allocate::@1
    // [614] vera_heap_split_free_and_allocate::free_size#0 = vera_heap_get_size_packed::return#13
    // vera_heap_data_packed_t free_data = vera_heap_get_data_packed(s, free_index)
    // [615] vera_heap_get_data_packed::index#3 = vera_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [616] call vera_heap_get_data_packed
    // [253] phi from vera_heap_split_free_and_allocate::@1 to vera_heap_get_data_packed [phi:vera_heap_split_free_and_allocate::@1->vera_heap_get_data_packed]
    // [253] phi vera_heap_get_data_packed::index#9 = vera_heap_get_data_packed::index#3 [phi:vera_heap_split_free_and_allocate::@1->vera_heap_get_data_packed#0] -- register_copy 
    jsr vera_heap_get_data_packed
    // vera_heap_data_packed_t free_data = vera_heap_get_data_packed(s, free_index)
    // [617] vera_heap_get_data_packed::return#15 = vera_heap_get_data_packed::return#1 -- vwuz1=vwuz2 
    lda.z vera_heap_get_data_packed.return
    sta.z vera_heap_get_data_packed.return_3
    lda.z vera_heap_get_data_packed.return+1
    sta.z vera_heap_get_data_packed.return_3+1
    // vera_heap_split_free_and_allocate::@2
    // [618] vera_heap_split_free_and_allocate::free_data#0 = vera_heap_get_data_packed::return#15
    // vera_heap_set_size_packed(s, free_index, free_size - required_size)
    // [619] vera_heap_set_size_packed::size_packed#4 = vera_heap_split_free_and_allocate::free_size#0 - vera_heap_split_free_and_allocate::required_size#0 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z vera_heap_set_size_packed.size_packed
    sec
    sbc.z required_size
    sta.z vera_heap_set_size_packed.size_packed
    lda.z vera_heap_set_size_packed.size_packed+1
    sbc.z required_size+1
    sta.z vera_heap_set_size_packed.size_packed+1
    // [620] vera_heap_set_size_packed::index#4 = vera_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [621] call vera_heap_set_size_packed
    // [477] phi from vera_heap_split_free_and_allocate::@2 to vera_heap_set_size_packed [phi:vera_heap_split_free_and_allocate::@2->vera_heap_set_size_packed]
    // [477] phi vera_heap_set_size_packed::size_packed#6 = vera_heap_set_size_packed::size_packed#4 [phi:vera_heap_split_free_and_allocate::@2->vera_heap_set_size_packed#0] -- register_copy 
    // [477] phi vera_heap_set_size_packed::index#6 = vera_heap_set_size_packed::index#4 [phi:vera_heap_split_free_and_allocate::@2->vera_heap_set_size_packed#1] -- register_copy 
    jsr vera_heap_set_size_packed
    // vera_heap_split_free_and_allocate::@3
    // vera_heap_set_data_packed(s, free_index, free_data + required_size)
    // [622] vera_heap_set_data_packed::data_packed#4 = vera_heap_split_free_and_allocate::free_data#0 + vera_heap_split_free_and_allocate::required_size#0 -- vwuz1=vwuz2_plus_vwuz3 
    lda.z free_data
    clc
    adc.z required_size
    sta.z vera_heap_set_data_packed.data_packed
    lda.z free_data+1
    adc.z required_size+1
    sta.z vera_heap_set_data_packed.data_packed+1
    // [623] vera_heap_set_data_packed::index#4 = vera_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [624] call vera_heap_set_data_packed
    // [471] phi from vera_heap_split_free_and_allocate::@3 to vera_heap_set_data_packed [phi:vera_heap_split_free_and_allocate::@3->vera_heap_set_data_packed]
    // [471] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#4 [phi:vera_heap_split_free_and_allocate::@3->vera_heap_set_data_packed#0] -- register_copy 
    // [471] phi vera_heap_set_data_packed::data_packed#7 = vera_heap_set_data_packed::data_packed#4 [phi:vera_heap_split_free_and_allocate::@3->vera_heap_set_data_packed#1] -- register_copy 
    jsr vera_heap_set_data_packed
    // vera_heap_split_free_and_allocate::@4
    // vera_heap_index_t heap_index = vera_heap_index_add(s)
    // [625] vera_heap_index_add::s#1 = vera_heap_split_free_and_allocate::s#0 -- vbuxx=vbuz1 
    ldx.z s
    // [626] call vera_heap_index_add
  // We create a new heap block with the required size.
  // The data is the offset in vram.
    // [431] phi from vera_heap_split_free_and_allocate::@4 to vera_heap_index_add [phi:vera_heap_split_free_and_allocate::@4->vera_heap_index_add]
    // [431] phi vera_heap_index_add::s#2 = vera_heap_index_add::s#1 [phi:vera_heap_split_free_and_allocate::@4->vera_heap_index_add#0] -- register_copy 
    jsr vera_heap_index_add
    // vera_heap_index_t heap_index = vera_heap_index_add(s)
    // [627] vera_heap_index_add::return#3 = vera_heap_index_add::return#1 -- vbuaa=vbuz1 
    lda.z vera_heap_index_add.return
    // vera_heap_split_free_and_allocate::@5
    // [628] vera_heap_split_free_and_allocate::heap_index#0 = vera_heap_index_add::return#3 -- vbuz1=vbuaa 
    sta.z heap_index
    // vera_heap_set_data_packed(s, heap_index, free_data)
    // [629] vera_heap_set_data_packed::index#5 = vera_heap_split_free_and_allocate::heap_index#0 -- vbuxx=vbuz1 
    tax
    // [630] vera_heap_set_data_packed::data_packed#5 = vera_heap_split_free_and_allocate::free_data#0 -- vwuz1=vwuz2 
    lda.z free_data
    sta.z vera_heap_set_data_packed.data_packed
    lda.z free_data+1
    sta.z vera_heap_set_data_packed.data_packed+1
    // [631] call vera_heap_set_data_packed
    // [471] phi from vera_heap_split_free_and_allocate::@5 to vera_heap_set_data_packed [phi:vera_heap_split_free_and_allocate::@5->vera_heap_set_data_packed]
    // [471] phi vera_heap_set_data_packed::index#7 = vera_heap_set_data_packed::index#5 [phi:vera_heap_split_free_and_allocate::@5->vera_heap_set_data_packed#0] -- register_copy 
    // [471] phi vera_heap_set_data_packed::data_packed#7 = vera_heap_set_data_packed::data_packed#5 [phi:vera_heap_split_free_and_allocate::@5->vera_heap_set_data_packed#1] -- register_copy 
    jsr vera_heap_set_data_packed
    // vera_heap_split_free_and_allocate::@6
    // vera_heap_heap_insert_at(s, heap_index, VERAHEAP_NULL, required_size)
    // [632] vera_heap_heap_insert_at::s#1 = vera_heap_split_free_and_allocate::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z vera_heap_heap_insert_at.s
    // [633] vera_heap_heap_insert_at::heap_index#1 = vera_heap_split_free_and_allocate::heap_index#0 -- vbuz1=vbuz2 
    lda.z heap_index
    sta.z vera_heap_heap_insert_at.heap_index
    // [634] vera_heap_heap_insert_at::size#1 = vera_heap_split_free_and_allocate::required_size#0 -- vwuz1=vwuz2 
    lda.z required_size
    sta.z vera_heap_heap_insert_at.size
    lda.z required_size+1
    sta.z vera_heap_heap_insert_at.size+1
    // [635] call vera_heap_heap_insert_at
    // [672] phi from vera_heap_split_free_and_allocate::@6 to vera_heap_heap_insert_at [phi:vera_heap_split_free_and_allocate::@6->vera_heap_heap_insert_at]
    // [672] phi vera_heap_heap_insert_at::size#2 = vera_heap_heap_insert_at::size#1 [phi:vera_heap_split_free_and_allocate::@6->vera_heap_heap_insert_at#0] -- register_copy 
    // [672] phi vera_heap_heap_insert_at::heap_index#2 = vera_heap_heap_insert_at::heap_index#1 [phi:vera_heap_split_free_and_allocate::@6->vera_heap_heap_insert_at#1] -- register_copy 
    // [672] phi vera_heap_heap_insert_at::s#2 = vera_heap_heap_insert_at::s#1 [phi:vera_heap_split_free_and_allocate::@6->vera_heap_heap_insert_at#2] -- register_copy 
    jsr vera_heap_heap_insert_at
    // vera_heap_split_free_and_allocate::@7
    // vera_heap_index_t heap_left = vera_heap_get_left(s, free_index)
    // [636] vera_heap_get_left::index#1 = vera_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [637] call vera_heap_get_left
    // [538] phi from vera_heap_split_free_and_allocate::@7 to vera_heap_get_left [phi:vera_heap_split_free_and_allocate::@7->vera_heap_get_left]
    // [538] phi vera_heap_get_left::index#4 = vera_heap_get_left::index#1 [phi:vera_heap_split_free_and_allocate::@7->vera_heap_get_left#0] -- register_copy 
    jsr vera_heap_get_left
    // vera_heap_index_t heap_left = vera_heap_get_left(s, free_index)
    // [638] vera_heap_get_left::return#3 = vera_heap_get_left::return#0
    // vera_heap_split_free_and_allocate::@8
    // [639] vera_heap_split_free_and_allocate::heap_left#0 = vera_heap_get_left::return#3 -- vbuz1=vbuaa 
    sta.z heap_left
    // vera_heap_set_left(s, heap_index, heap_left)
    // [640] vera_heap_set_left::index#1 = vera_heap_split_free_and_allocate::heap_index#0 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [641] vera_heap_set_left::left#1 = vera_heap_split_free_and_allocate::heap_left#0 -- vbuaa=vbuz1 
    // [642] call vera_heap_set_left
    // [574] phi from vera_heap_split_free_and_allocate::@8 to vera_heap_set_left [phi:vera_heap_split_free_and_allocate::@8->vera_heap_set_left]
    // [574] phi vera_heap_set_left::index#6 = vera_heap_set_left::index#1 [phi:vera_heap_split_free_and_allocate::@8->vera_heap_set_left#0] -- register_copy 
    // [574] phi vera_heap_set_left::left#6 = vera_heap_set_left::left#1 [phi:vera_heap_split_free_and_allocate::@8->vera_heap_set_left#1] -- register_copy 
    jsr vera_heap_set_left
    // vera_heap_split_free_and_allocate::@9
    // vera_heap_set_right(s, heap_index, heap_right)
    // [643] vera_heap_set_right::index#1 = vera_heap_split_free_and_allocate::heap_index#0 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [644] vera_heap_set_right::right#1 = vera_heap_split_free_and_allocate::free_index#0 -- vbuaa=vbuz1 
    lda.z free_index
    // [645] call vera_heap_set_right
  // printf("\nright = %03x", heap_right);
    // [577] phi from vera_heap_split_free_and_allocate::@9 to vera_heap_set_right [phi:vera_heap_split_free_and_allocate::@9->vera_heap_set_right]
    // [577] phi vera_heap_set_right::index#6 = vera_heap_set_right::index#1 [phi:vera_heap_split_free_and_allocate::@9->vera_heap_set_right#0] -- register_copy 
    // [577] phi vera_heap_set_right::right#6 = vera_heap_set_right::right#1 [phi:vera_heap_split_free_and_allocate::@9->vera_heap_set_right#1] -- register_copy 
    jsr vera_heap_set_right
    // vera_heap_split_free_and_allocate::@10
    // vera_heap_set_right(s, heap_left, heap_index)
    // [646] vera_heap_set_right::index#2 = vera_heap_split_free_and_allocate::heap_left#0 -- vbuxx=vbuz1 
    ldx.z heap_left
    // [647] vera_heap_set_right::right#2 = vera_heap_split_free_and_allocate::heap_index#0 -- vbuaa=vbuz1 
    lda.z heap_index
    // [648] call vera_heap_set_right
    // [577] phi from vera_heap_split_free_and_allocate::@10 to vera_heap_set_right [phi:vera_heap_split_free_and_allocate::@10->vera_heap_set_right]
    // [577] phi vera_heap_set_right::index#6 = vera_heap_set_right::index#2 [phi:vera_heap_split_free_and_allocate::@10->vera_heap_set_right#0] -- register_copy 
    // [577] phi vera_heap_set_right::right#6 = vera_heap_set_right::right#2 [phi:vera_heap_split_free_and_allocate::@10->vera_heap_set_right#1] -- register_copy 
    jsr vera_heap_set_right
    // vera_heap_split_free_and_allocate::@11
    // vera_heap_set_left(s, heap_right, heap_index)
    // [649] vera_heap_set_left::index#2 = vera_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [650] vera_heap_set_left::left#2 = vera_heap_split_free_and_allocate::heap_index#0 -- vbuaa=vbuz1 
    lda.z heap_index
    // [651] call vera_heap_set_left
    // [574] phi from vera_heap_split_free_and_allocate::@11 to vera_heap_set_left [phi:vera_heap_split_free_and_allocate::@11->vera_heap_set_left]
    // [574] phi vera_heap_set_left::index#6 = vera_heap_set_left::index#2 [phi:vera_heap_split_free_and_allocate::@11->vera_heap_set_left#0] -- register_copy 
    // [574] phi vera_heap_set_left::left#6 = vera_heap_set_left::left#2 [phi:vera_heap_split_free_and_allocate::@11->vera_heap_set_left#1] -- register_copy 
    jsr vera_heap_set_left
    // vera_heap_split_free_and_allocate::@12
    // vera_heap_set_free(s, heap_right)
    // [652] vera_heap_set_free::index#2 = vera_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [653] call vera_heap_set_free
    // [486] phi from vera_heap_split_free_and_allocate::@12 to vera_heap_set_free [phi:vera_heap_split_free_and_allocate::@12->vera_heap_set_free]
    // [486] phi vera_heap_set_free::index#5 = vera_heap_set_free::index#2 [phi:vera_heap_split_free_and_allocate::@12->vera_heap_set_free#0] -- register_copy 
    jsr vera_heap_set_free
    // vera_heap_split_free_and_allocate::@13
    // vera_heap_clear_free(s, heap_left)
    // [654] vera_heap_clear_free::index#1 = vera_heap_split_free_and_allocate::heap_left#0 -- vbuxx=vbuz1 
    ldx.z heap_left
    // [655] call vera_heap_clear_free
    // [669] phi from vera_heap_split_free_and_allocate::@13 to vera_heap_clear_free [phi:vera_heap_split_free_and_allocate::@13->vera_heap_clear_free]
    // [669] phi vera_heap_clear_free::index#2 = vera_heap_clear_free::index#1 [phi:vera_heap_split_free_and_allocate::@13->vera_heap_clear_free#0] -- register_copy 
    jsr vera_heap_clear_free
    // vera_heap_split_free_and_allocate::@return
    // }
    // [656] return 
    rts
}
  // heap_idle_remove
// void heap_idle_remove(__zp($b) char s, __zp(4) char idle_index)
heap_idle_remove: {
    .label s = $b
    .label idle_index = 4
    // vera_heap_segment.idleCount[s]--;
    // [657] heap_idle_remove::$3 = heap_idle_remove::s#0 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [658] ((unsigned int *)&vera_heap_segment+$4e)[heap_idle_remove::$3] = -- ((unsigned int *)&vera_heap_segment+$4e)[heap_idle_remove::$3] -- pwuc1_derefidx_vbuaa=_dec_pwuc1_derefidx_vbuaa 
    tax
    lda vera_heap_segment+$4e,x
    bne !+
    dec vera_heap_segment+$4e+1,x
  !:
    dec vera_heap_segment+$4e,x
    // vera_heap_list_remove(s, vera_heap_segment.idle_list[s], idle_index)
    // [659] vera_heap_list_remove::list#4 = ((char *)&vera_heap_segment+$32)[heap_idle_remove::s#0] -- vbuyy=pbuc1_derefidx_vbuz1 
    ldx.z s
    ldy vera_heap_segment+$32,x
    // [660] vera_heap_list_remove::index#2 = heap_idle_remove::idle_index#0
    // [661] call vera_heap_list_remove
    // [505] phi from heap_idle_remove to vera_heap_list_remove [phi:heap_idle_remove->vera_heap_list_remove]
    // [505] phi vera_heap_list_remove::index#10 = vera_heap_list_remove::index#2 [phi:heap_idle_remove->vera_heap_list_remove#0] -- register_copy 
    // [505] phi vera_heap_list_remove::list#10 = vera_heap_list_remove::list#4 [phi:heap_idle_remove->vera_heap_list_remove#1] -- register_copy 
    jsr vera_heap_list_remove
    // vera_heap_list_remove(s, vera_heap_segment.idle_list[s], idle_index)
    // [662] vera_heap_list_remove::return#10 = vera_heap_list_remove::return#1 -- vbuaa=vbuyy 
    tya
    // heap_idle_remove::@1
    // [663] heap_idle_remove::$1 = vera_heap_list_remove::return#10
    // vera_heap_segment.idle_list[s] = vera_heap_list_remove(s, vera_heap_segment.idle_list[s], idle_index)
    // [664] ((char *)&vera_heap_segment+$32)[heap_idle_remove::s#0] = heap_idle_remove::$1 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z s
    sta vera_heap_segment+$32,y
    // heap_idle_remove::@return
    // }
    // [665] return 
    rts
}
  // vera_heap_get_prev
// __register(A) char vera_heap_get_prev(char s, __register(X) char index)
vera_heap_get_prev: {
    // return vera_heap_index.prev[index];
    // [667] vera_heap_get_prev::return#1 = ((char *)&vera_heap_index+$700)[vera_heap_get_prev::index#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_heap_index+$700,x
    // vera_heap_get_prev::@return
    // }
    // [668] return 
    rts
}
  // vera_heap_clear_free
// void vera_heap_clear_free(char s, __register(X) char index)
vera_heap_clear_free: {
    // vera_heap_index.size1[index] &= 0x7F
    // [670] ((char *)&vera_heap_index+$500)[vera_heap_clear_free::index#2] = ((char *)&vera_heap_index+$500)[vera_heap_clear_free::index#2] & $7f -- pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_band_vbuc2 
    lda #$7f
    and vera_heap_index+$500,x
    sta vera_heap_index+$500,x
    // vera_heap_clear_free::@return
    // }
    // [671] return 
    rts
}
  // vera_heap_heap_insert_at
// char vera_heap_heap_insert_at(__zp($11) char s, __zp(2) char heap_index, char at, __zp(8) unsigned int size)
vera_heap_heap_insert_at: {
    .label s = $11
    .label heap_index = 2
    .label size = 8
    // vera_heap_list_insert_at(s, vera_heap_segment.heap_list[s], heap_index, at)
    // [673] vera_heap_list_insert_at::list#1 = ((char *)&vera_heap_segment+$2a)[vera_heap_heap_insert_at::s#2] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda vera_heap_segment+$2a,y
    sta.z vera_heap_list_insert_at.list
    // [674] vera_heap_list_insert_at::index#1 = vera_heap_heap_insert_at::heap_index#2 -- vbuz1=vbuz2 
    lda.z heap_index
    sta.z vera_heap_list_insert_at.index
    // [675] call vera_heap_list_insert_at
    // [441] phi from vera_heap_heap_insert_at to vera_heap_list_insert_at [phi:vera_heap_heap_insert_at->vera_heap_list_insert_at]
    // [441] phi vera_heap_list_insert_at::index#10 = vera_heap_list_insert_at::index#1 [phi:vera_heap_heap_insert_at->vera_heap_list_insert_at#0] -- register_copy 
    // [441] phi vera_heap_list_insert_at::at#10 = $ff [phi:vera_heap_heap_insert_at->vera_heap_list_insert_at#1] -- vbuz1=vbuc1 
    lda #$ff
    sta.z vera_heap_list_insert_at.at
    // [441] phi vera_heap_list_insert_at::list#5 = vera_heap_list_insert_at::list#1 [phi:vera_heap_heap_insert_at->vera_heap_list_insert_at#2] -- register_copy 
    jsr vera_heap_list_insert_at
    // vera_heap_list_insert_at(s, vera_heap_segment.heap_list[s], heap_index, at)
    // [676] vera_heap_list_insert_at::return#1 = vera_heap_list_insert_at::list#11 -- vbuaa=vbuz1 
    lda.z vera_heap_list_insert_at.list
    // vera_heap_heap_insert_at::@1
    // [677] vera_heap_heap_insert_at::$0 = vera_heap_list_insert_at::return#1
    // vera_heap_segment.heap_list[s] = vera_heap_list_insert_at(s, vera_heap_segment.heap_list[s], heap_index, at)
    // [678] ((char *)&vera_heap_segment+$2a)[vera_heap_heap_insert_at::s#2] = vera_heap_heap_insert_at::$0 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z s
    sta vera_heap_segment+$2a,y
    // vera_heap_set_size_packed(s, heap_index, size)
    // [679] vera_heap_set_size_packed::index#1 = vera_heap_heap_insert_at::heap_index#2 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [680] vera_heap_set_size_packed::size_packed#1 = vera_heap_heap_insert_at::size#2
    // [681] call vera_heap_set_size_packed
    // [477] phi from vera_heap_heap_insert_at::@1 to vera_heap_set_size_packed [phi:vera_heap_heap_insert_at::@1->vera_heap_set_size_packed]
    // [477] phi vera_heap_set_size_packed::size_packed#6 = vera_heap_set_size_packed::size_packed#1 [phi:vera_heap_heap_insert_at::@1->vera_heap_set_size_packed#0] -- register_copy 
    // [477] phi vera_heap_set_size_packed::index#6 = vera_heap_set_size_packed::index#1 [phi:vera_heap_heap_insert_at::@1->vera_heap_set_size_packed#1] -- register_copy 
    jsr vera_heap_set_size_packed
    // vera_heap_heap_insert_at::@2
    // vera_heap_segment.heapCount[s]++;
    // [682] vera_heap_heap_insert_at::$4 = vera_heap_heap_insert_at::s#2 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [683] ((unsigned int *)&vera_heap_segment+$3e)[vera_heap_heap_insert_at::$4] = ++ ((unsigned int *)&vera_heap_segment+$3e)[vera_heap_heap_insert_at::$4] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc vera_heap_segment+$3e,x
    bne !+
    inc vera_heap_segment+$3e+1,x
  !:
    // vera_heap_heap_insert_at::@return
    // }
    // [684] return 
    rts
}
  // File Data
.segment BramVeraHeap
  vera_heap_index: .fill SIZEOF_STRUCT___2, 0
.segment DataVeraHeap
  vera_heap_segment: .fill SIZEOF_STRUCT___3, 0
  veraheap_color: .byte 0
}
