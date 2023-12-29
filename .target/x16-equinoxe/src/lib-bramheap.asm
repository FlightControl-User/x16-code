  // File Comments
  // Library
.namespace lib_bramheap {
  // Upstart
.cpu _65c02
  
#if __asm_import__
#else
#if __bramheap__

#else

.segmentdef Code                    [start=$80d]
.segmentdef CodeBramHeap            [startAfter="Code"]
.segmentdef Data                    [startAfter="CodeBramHeap"]
.segmentdef DataBramHeap            [startAfter="Data"]

.segmentdef BramBramHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]

:BasicUpstart(__lib_bramheap_start)

#endif
#endif
  // Global Constants & labels
  .const SIZEOF_STRUCT___3 = $36
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __lib_bramheap_start
// void __lib_bramheap_start()
__lib_bramheap_start: {
    // __lib_bramheap_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __lib_bramheap_start::@return
    // [3] return 
    rts
}
.segment CodeBramHeap
  // bram_heap_get_size
// __zp($28) unsigned long bram_heap_get_size(__zp($4c) char s, __zp($41) char index)
bram_heap_get_size: {
    .label s = $4c
    .label index = $41
    .label return = $28
    .label bram_heap_get_size__2 = $18
    .label size_packed = $28
    .label size = $28
    // bram_heap_get_size::bank_get_bram1
    // return BRAM;
    // [5] bram_heap_get_size::bank_get_bram1_return#0 = BRAM -- vbuxx=vbuz1 
    ldx.z BRAM
    // bram_heap_get_size::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [6] bram_heap_get_size::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment+$35
    // bram_heap_get_size::bank_set_bram1
    // BRAM = bank
    // [7] BRAM = bram_heap_get_size::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_get_size::@2
    // bram_heap_get_size_packed(s, index)
    // [8] bram_heap_get_size_packed::s#1 = bram_heap_get_size::s -- vbuaa=vbuz1 
    lda.z s
    // [9] bram_heap_get_size_packed::index#1 = bram_heap_get_size::index -- vbuxx=vbuz1 
    ldx.z index
    // [10] call bram_heap_get_size_packed
    // [214] phi from bram_heap_get_size::@2 to bram_heap_get_size_packed [phi:bram_heap_get_size::@2->bram_heap_get_size_packed]
    // [214] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#1 [phi:bram_heap_get_size::@2->bram_heap_get_size_packed#0] -- register_copy 
    // [214] phi bram_heap_get_size_packed::s#8 = bram_heap_get_size_packed::s#1 [phi:bram_heap_get_size::@2->bram_heap_get_size_packed#1] -- register_copy 
    jsr bram_heap_get_size_packed
    // bram_heap_get_size_packed(s, index)
    // [11] bram_heap_get_size_packed::return#1 = bram_heap_get_size_packed::return#12
    // bram_heap_get_size::@4
    // [12] bram_heap_get_size::$2 = bram_heap_get_size_packed::return#1
    // bram_heap_size_t size_packed = (bram_heap_size_t)bram_heap_get_size_packed(s, index)
    // [13] bram_heap_get_size::size_packed#0 = (unsigned long)bram_heap_get_size::$2 -- vduz1=_dword_vwuz2 
    lda.z bram_heap_get_size__2
    sta.z size_packed
    lda.z bram_heap_get_size__2+1
    sta.z size_packed+1
    lda #0
    sta.z size_packed+2
    sta.z size_packed+3
    // bram_heap_get_size::bank_set_bram2
    // BRAM = bank
    // [14] BRAM = bram_heap_get_size::bank_get_bram1_return#0 -- vbuz1=vbuxx 
    stx.z BRAM
    // bram_heap_get_size::@3
    // bram_heap_size_t size = size_packed << 5
    // [15] bram_heap_get_size::size#0 = bram_heap_get_size::size_packed#0 << 5 -- vduz1=vduz1_rol_5 
    asl.z size
    rol.z size+1
    rol.z size+2
    rol.z size+3
    asl.z size
    rol.z size+1
    rol.z size+2
    rol.z size+3
    asl.z size
    rol.z size+1
    rol.z size+2
    rol.z size+3
    asl.z size
    rol.z size+1
    rol.z size+2
    rol.z size+3
    asl.z size
    rol.z size+1
    rol.z size+2
    rol.z size+3
    // return size;
    // [16] bram_heap_get_size::return = bram_heap_get_size::size#0
    // bram_heap_get_size::@return
    // }
    // [17] return 
    rts
}
  // bram_heap_data_get_bank
// __zp($38) char bram_heap_data_get_bank(__zp($4e) char s, __zp($51) char index)
bram_heap_data_get_bank: {
    .label s = $4e
    .label index = $51
    .label return = $38
    .label bram_heap_data_get_bank__4 = $18
    .label bram_heap_data_get_bank__5 = $18
    .label bram_heap_data_get_bank__6 = $18
    .label bram_heap_map = $18
    // bram_heap_data_get_bank::bank_get_bram1
    // return BRAM;
    // [19] bram_heap_data_get_bank::bank_get_bram1_return#0 = BRAM -- vbuxx=vbuz1 
    ldx.z BRAM
    // bram_heap_data_get_bank::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [20] bram_heap_data_get_bank::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment+$35
    // bram_heap_data_get_bank::bank_set_bram1
    // BRAM = bank
    // [21] BRAM = bram_heap_data_get_bank::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_data_get_bank::@2
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [22] bram_heap_data_get_bank::$6 = (unsigned int)bram_heap_data_get_bank::s -- vwuz1=_word_vbuz2 
    lda.z s
    sta.z bram_heap_data_get_bank__6
    lda #0
    sta.z bram_heap_data_get_bank__6+1
    // [23] bram_heap_data_get_bank::$4 = bram_heap_data_get_bank::$6 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_data_get_bank__4
    rol.z bram_heap_data_get_bank__4+1
    dey
    bne !-
  !e:
    // [24] bram_heap_data_get_bank::bram_heap_map#0 = bram_heap_index + bram_heap_data_get_bank::$4 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_bank_t bram_bank = bram_heap_map->data1[index]
    // [25] bram_heap_data_get_bank::$5 = (char *)bram_heap_data_get_bank::bram_heap_map#0 + $100 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_data_get_bank__5
    clc
    adc #<$100
    sta.z bram_heap_data_get_bank__5
    lda.z bram_heap_data_get_bank__5+1
    adc #>$100
    sta.z bram_heap_data_get_bank__5+1
    // [26] bram_heap_data_get_bank::bram_bank#0 = bram_heap_data_get_bank::$5[bram_heap_data_get_bank::index] -- vbuaa=pbuz1_derefidx_vbuz2 
    ldy.z index
    lda (bram_heap_data_get_bank__5),y
    // bram_heap_data_get_bank::bank_set_bram2
    // BRAM = bank
    // [27] BRAM = bram_heap_data_get_bank::bank_get_bram1_return#0 -- vbuz1=vbuxx 
    stx.z BRAM
    // bram_heap_data_get_bank::@3
    // return bram_bank;
    // [28] bram_heap_data_get_bank::return = bram_heap_data_get_bank::bram_bank#0 -- vbuz1=vbuaa 
    sta.z return
    // bram_heap_data_get_bank::@return
    // }
    // [29] return 
    rts
}
  // bram_heap_data_get_offset
// __zp($14) char * bram_heap_data_get_offset(__zp($48) char s, __zp($49) char index)
bram_heap_data_get_offset: {
    .label s = $48
    .label index = $49
    .label return = $14
    .label bram_heap_data_get_offset__3 = $14
    .label bram_heap_data_get_offset__6 = $14
    .label bram_heap_data_get_offset__8 = $14
    .label bram_heap_data_get_offset__10 = $14
    .label bram_heap_map = $14
    .label bram_ptr = $14
    // bram_heap_data_get_offset::bank_get_bram1
    // return BRAM;
    // [31] bram_heap_data_get_offset::bank_get_bram1_return#0 = BRAM -- vbuxx=vbuz1 
    ldx.z BRAM
    // bram_heap_data_get_offset::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [32] bram_heap_data_get_offset::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment+$35
    // bram_heap_data_get_offset::bank_set_bram1
    // BRAM = bank
    // [33] BRAM = bram_heap_data_get_offset::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_data_get_offset::@2
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [34] bram_heap_data_get_offset::$8 = (unsigned int)bram_heap_data_get_offset::s -- vwuz1=_word_vbuz2 
    lda.z s
    sta.z bram_heap_data_get_offset__8
    lda #0
    sta.z bram_heap_data_get_offset__8+1
    // [35] bram_heap_data_get_offset::$6 = bram_heap_data_get_offset::$8 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_data_get_offset__6
    rol.z bram_heap_data_get_offset__6+1
    dey
    bne !-
  !e:
    // [36] bram_heap_data_get_offset::bram_heap_map#0 = bram_heap_index + bram_heap_data_get_offset::$6 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // (unsigned int)bram_heap_map->data0[index] << 5
    // [37] bram_heap_data_get_offset::$10 = (unsigned int)((char *)bram_heap_data_get_offset::bram_heap_map#0)[bram_heap_data_get_offset::index] -- vwuz1=_word_pbuz1_derefidx_vbuz2 
    ldy.z index
    lda (bram_heap_data_get_offset__10),y
    sta.z bram_heap_data_get_offset__10
    lda #0
    sta.z bram_heap_data_get_offset__10+1
    // [38] bram_heap_data_get_offset::$3 = bram_heap_data_get_offset::$10 << 5 -- vwuz1=vwuz1_rol_5 
    asl.z bram_heap_data_get_offset__3
    rol.z bram_heap_data_get_offset__3+1
    asl.z bram_heap_data_get_offset__3
    rol.z bram_heap_data_get_offset__3+1
    asl.z bram_heap_data_get_offset__3
    rol.z bram_heap_data_get_offset__3+1
    asl.z bram_heap_data_get_offset__3
    rol.z bram_heap_data_get_offset__3+1
    asl.z bram_heap_data_get_offset__3
    rol.z bram_heap_data_get_offset__3+1
    // ((unsigned int)bram_heap_map->data0[index] << 5) | 0xA000
    // [39] bram_heap_data_get_offset::bram_ptr#0 = bram_heap_data_get_offset::$3 | $a000 -- vwuz1=vwuz1_bor_vwuc1 
    lda.z bram_ptr
    ora #<$a000
    sta.z bram_ptr
    lda.z bram_ptr+1
    ora #>$a000
    sta.z bram_ptr+1
    // bram_heap_data_get_offset::bank_set_bram2
    // BRAM = bank
    // [40] BRAM = bram_heap_data_get_offset::bank_get_bram1_return#0 -- vbuz1=vbuxx 
    stx.z BRAM
    // bram_heap_data_get_offset::@3
    // return bram_ptr;
    // [41] bram_heap_data_get_offset::return = (char *)bram_heap_data_get_offset::bram_ptr#0
    // bram_heap_data_get_offset::@return
    // }
    // [42] return 
    rts
}
  // bram_heap_free
/**
 * @brief Free a memory block from the heap using the handle of allocated memory of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @param handle The handle referring to the heap memory block.
 * @return heap_handle 
 */
// void bram_heap_free(__zp($4f) char s, __zp($4e) char free_index)
bram_heap_free: {
    .label s = $4f
    .label free_index = $4e
    .label bram_bank = $4d
    .label free_size = $36
    .label free_offset = $30
    // bram_heap_free::bank_get_bram1
    // return BRAM;
    // [44] bram_heap_free::bram_bank#0 = BRAM -- vbuz1=vbuz2 
    lda.z BRAM
    sta.z bram_bank
    // bram_heap_free::@5
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [45] bram_heap_free::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment+$35
    // bram_heap_free::bank_set_bram1
    // BRAM = bank
    // [46] BRAM = bram_heap_free::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_free::@6
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [47] bram_heap_get_size_packed::s#0 = bram_heap_free::s -- vbuaa=vbuz1 
    lda.z s
    // [48] bram_heap_get_size_packed::index#0 = bram_heap_free::free_index -- vbuxx=vbuz1 
    ldx.z free_index
    // [49] call bram_heap_get_size_packed
    // [214] phi from bram_heap_free::@6 to bram_heap_get_size_packed [phi:bram_heap_free::@6->bram_heap_get_size_packed]
    // [214] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#0 [phi:bram_heap_free::@6->bram_heap_get_size_packed#0] -- register_copy 
    // [214] phi bram_heap_get_size_packed::s#8 = bram_heap_get_size_packed::s#0 [phi:bram_heap_free::@6->bram_heap_get_size_packed#1] -- register_copy 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [50] bram_heap_get_size_packed::return#0 = bram_heap_get_size_packed::return#12 -- vwuz1=vwuz2 
    lda.z bram_heap_get_size_packed.return_1
    sta.z bram_heap_get_size_packed.return
    lda.z bram_heap_get_size_packed.return_1+1
    sta.z bram_heap_get_size_packed.return+1
    // bram_heap_free::@7
    // [51] bram_heap_free::free_size#0 = bram_heap_get_size_packed::return#0
    // bram_heap_data_packed_t free_offset = bram_heap_get_data_packed(s, free_index)
    // [52] bram_heap_get_data_packed::s#0 = bram_heap_free::s -- vbuaa=vbuz1 
    lda.z s
    // [53] bram_heap_get_data_packed::index#0 = bram_heap_free::free_index -- vbuxx=vbuz1 
    ldx.z free_index
    // [54] call bram_heap_get_data_packed
    // [225] phi from bram_heap_free::@7 to bram_heap_get_data_packed [phi:bram_heap_free::@7->bram_heap_get_data_packed]
    // [225] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#0 [phi:bram_heap_free::@7->bram_heap_get_data_packed#0] -- register_copy 
    // [225] phi bram_heap_get_data_packed::s#8 = bram_heap_get_data_packed::s#0 [phi:bram_heap_free::@7->bram_heap_get_data_packed#1] -- register_copy 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t free_offset = bram_heap_get_data_packed(s, free_index)
    // [55] bram_heap_get_data_packed::return#0 = bram_heap_get_data_packed::return#1
    // bram_heap_free::@8
    // [56] bram_heap_free::free_offset#0 = bram_heap_get_data_packed::return#0
    // bram_heap_heap_remove(s, free_index)
    // [57] bram_heap_heap_remove::s#0 = bram_heap_free::s -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_heap_remove.s
    // [58] bram_heap_heap_remove::heap_index#0 = bram_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_heap_remove.heap_index
    // [59] call bram_heap_heap_remove
    // TODO: only remove allocated indexes!
    jsr bram_heap_heap_remove
    // bram_heap_free::@9
    // bram_heap_free_insert(s, free_index, free_offset, free_size)
    // [60] bram_heap_free_insert::s#0 = bram_heap_free::s -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_free_insert.s
    // [61] bram_heap_free_insert::free_index#0 = bram_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_free_insert.free_index
    // [62] bram_heap_free_insert::data#0 = bram_heap_free::free_offset#0 -- vwuz1=vwuz2 
    lda.z free_offset
    sta.z bram_heap_free_insert.data
    lda.z free_offset+1
    sta.z bram_heap_free_insert.data+1
    // [63] bram_heap_free_insert::size#0 = bram_heap_free::free_size#0 -- vwuz1=vwuz2 
    lda.z free_size
    sta.z bram_heap_free_insert.size
    lda.z free_size+1
    sta.z bram_heap_free_insert.size+1
    // [64] call bram_heap_free_insert
    jsr bram_heap_free_insert
    // bram_heap_free::@10
    // bram_heap_index_t free_left_index = bram_heap_can_coalesce_left(s, free_index)
    // [65] bram_heap_can_coalesce_left::s#0 = bram_heap_free::s -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_can_coalesce_left.s
    // [66] bram_heap_can_coalesce_left::heap_index#0 = bram_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_can_coalesce_left.heap_index
    // [67] call bram_heap_can_coalesce_left
    jsr bram_heap_can_coalesce_left
    // [68] bram_heap_can_coalesce_left::return#0 = bram_heap_can_coalesce_left::return#3 -- vbuaa=vbuz1 
    lda.z bram_heap_can_coalesce_left.return
    // bram_heap_free::@11
    // [69] bram_heap_free::free_left_index#0 = bram_heap_can_coalesce_left::return#0 -- vbuxx=vbuaa 
    tax
    // if(free_left_index != BRAM_HEAP_NULL)
    // [70] if(bram_heap_free::free_left_index#0==$ff) goto bram_heap_free::@1 -- vbuxx_eq_vbuc1_then_la1 
    cpx #$ff
    beq __b1
    // bram_heap_free::@3
    // bram_heap_coalesce(s, free_left_index, free_index)
    // [71] bram_heap_coalesce::s#0 = bram_heap_free::s -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_coalesce.s
    // [72] bram_heap_coalesce::left_index#0 = bram_heap_free::free_left_index#0 -- vbuz1=vbuxx 
    stx.z bram_heap_coalesce.left_index
    // [73] bram_heap_coalesce::right_index#0 = bram_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_coalesce.right_index
    // [74] call bram_heap_coalesce
    // [291] phi from bram_heap_free::@3 to bram_heap_coalesce [phi:bram_heap_free::@3->bram_heap_coalesce]
    // [291] phi bram_heap_coalesce::left_index#10 = bram_heap_coalesce::left_index#0 [phi:bram_heap_free::@3->bram_heap_coalesce#0] -- register_copy 
    // [291] phi bram_heap_coalesce::right_index#10 = bram_heap_coalesce::right_index#0 [phi:bram_heap_free::@3->bram_heap_coalesce#1] -- register_copy 
    // [291] phi bram_heap_coalesce::s#10 = bram_heap_coalesce::s#0 [phi:bram_heap_free::@3->bram_heap_coalesce#2] -- register_copy 
    jsr bram_heap_coalesce
    // bram_heap_coalesce(s, free_left_index, free_index)
    // [75] bram_heap_coalesce::return#0 = bram_heap_coalesce::right_index#10 -- vbuaa=vbuz1 
    lda.z bram_heap_coalesce.right_index
    // bram_heap_free::@13
    // [76] bram_heap_free::$13 = bram_heap_coalesce::return#0
    // free_index = bram_heap_coalesce(s, free_left_index, free_index)
    // [77] bram_heap_free::free_index = bram_heap_free::$13 -- vbuz1=vbuaa 
    sta.z free_index
    // bram_heap_free::@1
  __b1:
    // bram_heap_index_t free_right_index = heap_can_coalesce_right(s, free_index)
    // [78] heap_can_coalesce_right::s#0 = bram_heap_free::s -- vbuz1=vbuz2 
    lda.z s
    sta.z heap_can_coalesce_right.s
    // [79] heap_can_coalesce_right::heap_index#0 = bram_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z heap_can_coalesce_right.heap_index
    // [80] call heap_can_coalesce_right
    jsr heap_can_coalesce_right
    // [81] heap_can_coalesce_right::return#0 = heap_can_coalesce_right::return#3 -- vbuaa=vbuz1 
    lda.z heap_can_coalesce_right.return
    // bram_heap_free::@12
    // [82] bram_heap_free::free_right_index#0 = heap_can_coalesce_right::return#0 -- vbuxx=vbuaa 
    tax
    // if(free_right_index != BRAM_HEAP_NULL)
    // [83] if(bram_heap_free::free_right_index#0==$ff) goto bram_heap_free::@2 -- vbuxx_eq_vbuc1_then_la1 
    cpx #$ff
    beq __b2
    // bram_heap_free::@4
    // bram_heap_coalesce(s, free_index, free_right_index)
    // [84] bram_heap_coalesce::s#1 = bram_heap_free::s -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_coalesce.s
    // [85] bram_heap_coalesce::left_index#1 = bram_heap_free::free_index -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_coalesce.left_index
    // [86] bram_heap_coalesce::right_index#1 = bram_heap_free::free_right_index#0 -- vbuz1=vbuxx 
    stx.z bram_heap_coalesce.right_index
    // [87] call bram_heap_coalesce
    // [291] phi from bram_heap_free::@4 to bram_heap_coalesce [phi:bram_heap_free::@4->bram_heap_coalesce]
    // [291] phi bram_heap_coalesce::left_index#10 = bram_heap_coalesce::left_index#1 [phi:bram_heap_free::@4->bram_heap_coalesce#0] -- register_copy 
    // [291] phi bram_heap_coalesce::right_index#10 = bram_heap_coalesce::right_index#1 [phi:bram_heap_free::@4->bram_heap_coalesce#1] -- register_copy 
    // [291] phi bram_heap_coalesce::s#10 = bram_heap_coalesce::s#1 [phi:bram_heap_free::@4->bram_heap_coalesce#2] -- register_copy 
    jsr bram_heap_coalesce
    // bram_heap_coalesce(s, free_index, free_right_index)
    // [88] bram_heap_coalesce::return#1 = bram_heap_coalesce::right_index#10 -- vbuaa=vbuz1 
    lda.z bram_heap_coalesce.right_index
    // bram_heap_free::@14
    // [89] bram_heap_free::$14 = bram_heap_coalesce::return#1
    // free_index = bram_heap_coalesce(s, free_index, free_right_index)
    // [90] bram_heap_free::free_index = bram_heap_free::$14 -- vbuz1=vbuaa 
    sta.z free_index
    // bram_heap_free::@2
  __b2:
    // bram_heap_segment.freeSize[s] += free_size
    // [91] bram_heap_free::$15 = bram_heap_free::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [92] ((unsigned int *)&bram_heap_segment+$31)[bram_heap_free::$15] = ((unsigned int *)&bram_heap_segment+$31)[bram_heap_free::$15] + bram_heap_free::free_size#0 -- pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_plus_vwuz1 
    tay
    lda bram_heap_segment+$31,y
    clc
    adc.z free_size
    sta bram_heap_segment+$31,y
    lda bram_heap_segment+$31+1,y
    adc.z free_size+1
    sta bram_heap_segment+$31+1,y
    // bram_heap_segment.heapSize[s] -= free_size
    // [93] bram_heap_free::$16 = bram_heap_free::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [94] ((unsigned int *)&bram_heap_segment+$2d)[bram_heap_free::$16] = ((unsigned int *)&bram_heap_segment+$2d)[bram_heap_free::$16] - bram_heap_free::free_size#0 -- pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_minus_vwuz1 
    tay
    lda bram_heap_segment+$2d,y
    sec
    sbc.z free_size
    sta bram_heap_segment+$2d,y
    lda bram_heap_segment+$2d+1,y
    sbc.z free_size+1
    sta bram_heap_segment+$2d+1,y
    // bram_heap_free::bank_set_bram2
    // BRAM = bank
    // [95] BRAM = bram_heap_free::bram_bank#0 -- vbuz1=vbuz2 
    lda.z bram_bank
    sta.z BRAM
    // bram_heap_free::@return
    // }
    // [96] return 
    rts
}
  // bram_heap_alloc
/**
 * @brief Allocated a specified size of memory on the heap of the segment.
 * 
 * @param size Specifies the size of memory to be allocated.
 * Note that the size is aligned to an 8 byte boundary by the memory manager.
 * When the size of the memory block is enquired, an 8 byte aligned value will be returned.
 * @return heap_handle The handle referring to the free record in the index.
 */
// __zp($35) char bram_heap_alloc(__zp($50) char s, __zp($28) unsigned long size)
bram_heap_alloc: {
    .label s = $50
    .label size = $28
    .label return = $35
    .label packed_size = $20
    .label bank_set_bram2_bank = $52
    // bram_heap_alloc::bank_get_bram1
    // return BRAM;
    // [98] bram_heap_alloc::bank_set_bram2_bank#0 = BRAM -- vbuz1=vbuz2 
    lda.z BRAM
    sta.z bank_set_bram2_bank
    // bram_heap_alloc::@3
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [99] bram_heap_alloc::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment+$35
    // bram_heap_alloc::bank_set_bram1
    // BRAM = bank
    // [100] BRAM = bram_heap_alloc::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_alloc::@4
    // bram_heap_size_packed_t packed_size = bram_heap_alloc_size_get(size)
    // [101] bram_heap_alloc_size_get::size#0 = bram_heap_alloc::size
    // [102] call bram_heap_alloc_size_get
    // Adjust given size to 8 bytes boundary (shift right with 3 bits).
    jsr bram_heap_alloc_size_get
    // [103] bram_heap_alloc_size_get::return#0 = bram_heap_alloc_size_get::return#1
    // bram_heap_alloc::@6
    // [104] bram_heap_alloc::packed_size#0 = bram_heap_alloc_size_get::return#0
    // bram_heap_index_t free_index = bram_heap_find_best_fit(s, packed_size)
    // [105] bram_heap_find_best_fit::s#0 = bram_heap_alloc::s -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_find_best_fit.s
    // [106] bram_heap_find_best_fit::requested_size#0 = bram_heap_alloc::packed_size#0 -- vwuz1=vwuz2 
    lda.z packed_size
    sta.z bram_heap_find_best_fit.requested_size
    lda.z packed_size+1
    sta.z bram_heap_find_best_fit.requested_size+1
    // [107] call bram_heap_find_best_fit
    jsr bram_heap_find_best_fit
    // [108] bram_heap_find_best_fit::return#0 = bram_heap_find_best_fit::return#2 -- vbuaa=vbuz1 
    lda.z bram_heap_find_best_fit.return
    // bram_heap_alloc::@7
    // [109] bram_heap_alloc::free_index#0 = bram_heap_find_best_fit::return#0 -- vbuxx=vbuaa 
    tax
    // if(free_index != BRAM_HEAP_NULL)
    // [110] if(bram_heap_alloc::free_index#0!=$ff) goto bram_heap_alloc::@1 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$ff
    bne __b1
    // [111] phi from bram_heap_alloc::@7 to bram_heap_alloc::@2 [phi:bram_heap_alloc::@7->bram_heap_alloc::@2]
    // [111] phi bram_heap_alloc::heap_index#4 = $ff [phi:bram_heap_alloc::@7->bram_heap_alloc::@2#0] -- vbuxx=vbuc1 
    ldx #$ff
    // bram_heap_alloc::@2
  __b2:
    // bram_heap_alloc::bank_set_bram2
    // BRAM = bank
    // [112] BRAM = bram_heap_alloc::bank_set_bram2_bank#0 -- vbuz1=vbuz2 
    lda.z bank_set_bram2_bank
    sta.z BRAM
    // bram_heap_alloc::@5
    // return heap_index;
    // [113] bram_heap_alloc::return = bram_heap_alloc::heap_index#4 -- vbuz1=vbuxx 
    stx.z return
    // bram_heap_alloc::@return
    // }
    // [114] return 
    rts
    // bram_heap_alloc::@1
  __b1:
    // bram_heap_allocate(s, free_index, packed_size)
    // [115] bram_heap_allocate::s#0 = bram_heap_alloc::s -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_allocate.s
    // [116] bram_heap_allocate::free_index#0 = bram_heap_alloc::free_index#0 -- vbuz1=vbuxx 
    stx.z bram_heap_allocate.free_index
    // [117] bram_heap_allocate::required_size#0 = bram_heap_alloc::packed_size#0 -- vwuz1=vwuz2 
    lda.z packed_size
    sta.z bram_heap_allocate.required_size
    lda.z packed_size+1
    sta.z bram_heap_allocate.required_size+1
    // [118] call bram_heap_allocate
    jsr bram_heap_allocate
    // [119] bram_heap_allocate::return#0 = bram_heap_allocate::return#4
    // bram_heap_alloc::@8
    // heap_index = bram_heap_allocate(s, free_index, packed_size)
    // [120] bram_heap_alloc::heap_index#1 = bram_heap_allocate::return#0 -- vbuxx=vbuaa 
    tax
    // bram_heap_segment.freeSize[s] -= packed_size
    // [121] bram_heap_alloc::$7 = bram_heap_alloc::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [122] ((unsigned int *)&bram_heap_segment+$31)[bram_heap_alloc::$7] = ((unsigned int *)&bram_heap_segment+$31)[bram_heap_alloc::$7] - bram_heap_alloc::packed_size#0 -- pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_minus_vwuz1 
    tay
    lda bram_heap_segment+$31,y
    sec
    sbc.z packed_size
    sta bram_heap_segment+$31,y
    lda bram_heap_segment+$31+1,y
    sbc.z packed_size+1
    sta bram_heap_segment+$31+1,y
    // bram_heap_segment.heapSize[s] += packed_size
    // [123] bram_heap_alloc::$8 = bram_heap_alloc::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [124] ((unsigned int *)&bram_heap_segment+$2d)[bram_heap_alloc::$8] = ((unsigned int *)&bram_heap_segment+$2d)[bram_heap_alloc::$8] + bram_heap_alloc::packed_size#0 -- pwuc1_derefidx_vbuaa=pwuc1_derefidx_vbuaa_plus_vwuz1 
    tay
    lda bram_heap_segment+$2d,y
    clc
    adc.z packed_size
    sta bram_heap_segment+$2d,y
    lda bram_heap_segment+$2d+1,y
    adc.z packed_size+1
    sta bram_heap_segment+$2d+1,y
    // [111] phi from bram_heap_alloc::@8 to bram_heap_alloc::@2 [phi:bram_heap_alloc::@8->bram_heap_alloc::@2]
    // [111] phi bram_heap_alloc::heap_index#4 = bram_heap_alloc::heap_index#1 [phi:bram_heap_alloc::@8->bram_heap_alloc::@2#0] -- register_copy 
    jmp __b2
}
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
// __zp($41) char bram_heap_segment_init(__zp($41) char s, __zp($4d) char bram_bank_floor, __zp($26) char *bram_ptr_floor, __zp($47) char bram_bank_ceil, __zp($3d) char *bram_ptr_ceil)
bram_heap_segment_init: {
    .label s = $41
    .label bram_bank_floor = $4d
    .label bram_ptr_floor = $26
    .label bram_bank_ceil = $47
    .label bram_ptr_ceil = $3d
    .label return = $41
    .label bram_heap_segment_init__0 = $36
    .label bram_heap_segment_init__1 = $36
    .label free_size = $b
    .label bank_old = $51
    .label free_index = $4c
    // bram_heap_segment.index_position[s] = 0
    // [125] ((char *)&bram_heap_segment+1)[bram_heap_segment_init::s] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z s
    sta bram_heap_segment+1,y
    // bram_heap_segment.bram_bank_floor[s] = bram_bank_floor
    // [126] ((char *)&bram_heap_segment+3)[bram_heap_segment_init::s] = bram_heap_segment_init::bram_bank_floor -- pbuc1_derefidx_vbuz1=vbuz2 
    // TODO initialize segment to all zero
    lda.z bram_bank_floor
    sta bram_heap_segment+3,y
    // bram_heap_segment.bram_ptr_floor[s] = bram_ptr_floor
    // [127] bram_heap_segment_init::$13 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [128] ((void **)&bram_heap_segment+5)[bram_heap_segment_init::$13] = (void *)bram_heap_segment_init::bram_ptr_floor -- qvoc1_derefidx_vbuaa=pvoz1 
    tay
    lda.z bram_ptr_floor
    sta bram_heap_segment+5,y
    lda.z bram_ptr_floor+1
    sta bram_heap_segment+5+1,y
    // bram_heap_segment.bram_bank_ceil[s] = bram_bank_ceil
    // [129] ((char *)&bram_heap_segment+$d)[bram_heap_segment_init::s] = bram_heap_segment_init::bram_bank_ceil -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z bram_bank_ceil
    ldy.z s
    sta bram_heap_segment+$d,y
    // bram_heap_segment.bram_ptr_ceil[s] = bram_ptr_ceil
    // [130] bram_heap_segment_init::$14 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [131] ((void **)&bram_heap_segment+$f)[bram_heap_segment_init::$14] = (void *)bram_heap_segment_init::bram_ptr_ceil -- qvoc1_derefidx_vbuaa=pvoz1 
    tay
    lda.z bram_ptr_ceil
    sta bram_heap_segment+$f,y
    lda.z bram_ptr_ceil+1
    sta bram_heap_segment+$f+1,y
    // bram_heap_data_pack(bram_bank_floor, bram_ptr_floor)
    // [132] bram_heap_data_pack::bram_bank#0 = bram_heap_segment_init::bram_bank_floor -- vbuxx=vbuz1 
    ldx.z bram_bank_floor
    // [133] bram_heap_data_pack::bram_ptr#0 = bram_heap_segment_init::bram_ptr_floor
    // [134] call bram_heap_data_pack
    // [436] phi from bram_heap_segment_init to bram_heap_data_pack [phi:bram_heap_segment_init->bram_heap_data_pack]
    // [436] phi bram_heap_data_pack::bram_ptr#2 = bram_heap_data_pack::bram_ptr#0 [phi:bram_heap_segment_init->bram_heap_data_pack#0] -- register_copy 
    // [436] phi bram_heap_data_pack::bram_bank#2 = bram_heap_data_pack::bram_bank#0 [phi:bram_heap_segment_init->bram_heap_data_pack#1] -- register_copy 
    jsr bram_heap_data_pack
    // bram_heap_data_pack(bram_bank_floor, bram_ptr_floor)
    // [135] bram_heap_data_pack::return#0 = bram_heap_data_pack::return#2
    // bram_heap_segment_init::@4
    // [136] bram_heap_segment_init::$0 = bram_heap_data_pack::return#0
    // bram_heap_segment.floor[s] = bram_heap_data_pack(bram_bank_floor, bram_ptr_floor)
    // [137] bram_heap_segment_init::$15 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [138] ((unsigned int *)&bram_heap_segment+9)[bram_heap_segment_init::$15] = bram_heap_segment_init::$0 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z bram_heap_segment_init__0
    sta bram_heap_segment+9,y
    lda.z bram_heap_segment_init__0+1
    sta bram_heap_segment+9+1,y
    // bram_heap_data_pack(bram_bank_ceil, bram_ptr_ceil)
    // [139] bram_heap_data_pack::bram_bank#1 = bram_heap_segment_init::bram_bank_ceil -- vbuxx=vbuz1 
    ldx.z bram_bank_ceil
    // [140] bram_heap_data_pack::bram_ptr#1 = bram_heap_segment_init::bram_ptr_ceil -- pbuz1=pbuz2 
    lda.z bram_ptr_ceil
    sta.z bram_heap_data_pack.bram_ptr
    lda.z bram_ptr_ceil+1
    sta.z bram_heap_data_pack.bram_ptr+1
    // [141] call bram_heap_data_pack
    // [436] phi from bram_heap_segment_init::@4 to bram_heap_data_pack [phi:bram_heap_segment_init::@4->bram_heap_data_pack]
    // [436] phi bram_heap_data_pack::bram_ptr#2 = bram_heap_data_pack::bram_ptr#1 [phi:bram_heap_segment_init::@4->bram_heap_data_pack#0] -- register_copy 
    // [436] phi bram_heap_data_pack::bram_bank#2 = bram_heap_data_pack::bram_bank#1 [phi:bram_heap_segment_init::@4->bram_heap_data_pack#1] -- register_copy 
    jsr bram_heap_data_pack
    // bram_heap_data_pack(bram_bank_ceil, bram_ptr_ceil)
    // [142] bram_heap_data_pack::return#1 = bram_heap_data_pack::return#2
    // bram_heap_segment_init::@5
    // [143] bram_heap_segment_init::$1 = bram_heap_data_pack::return#1
    // bram_heap_segment.ceil[s]  = bram_heap_data_pack(bram_bank_ceil, bram_ptr_ceil)
    // [144] bram_heap_segment_init::$16 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [145] ((unsigned int *)&bram_heap_segment+$13)[bram_heap_segment_init::$16] = bram_heap_segment_init::$1 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z bram_heap_segment_init__1
    sta bram_heap_segment+$13,y
    lda.z bram_heap_segment_init__1+1
    sta bram_heap_segment+$13+1,y
    // bram_heap_segment.heap_offset[s] = 0
    // [146] bram_heap_segment_init::$17 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [147] ((unsigned int *)&bram_heap_segment+$1d)[bram_heap_segment_init::$17] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta bram_heap_segment+$1d,y
    sta bram_heap_segment+$1d+1,y
    // bram_heap_size_packed_t free_size = bram_heap_segment.ceil[s]
    // [148] bram_heap_segment_init::$18 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [149] bram_heap_segment_init::free_size#0 = ((unsigned int *)&bram_heap_segment+$13)[bram_heap_segment_init::$18] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda bram_heap_segment+$13,y
    sta.z free_size
    lda bram_heap_segment+$13+1,y
    sta.z free_size+1
    // free_size -= bram_heap_segment.floor[s]
    // [150] bram_heap_segment_init::$19 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [151] bram_heap_segment_init::free_size#1 = bram_heap_segment_init::free_size#0 - ((unsigned int *)&bram_heap_segment+9)[bram_heap_segment_init::$19] -- vwuz1=vwuz1_minus_pwuc1_derefidx_vbuaa 
    tay
    lda.z free_size
    sec
    sbc bram_heap_segment+9,y
    sta.z free_size
    lda.z free_size+1
    sbc bram_heap_segment+9+1,y
    sta.z free_size+1
    // bram_heap_segment.heapCount[s] = 0
    // [152] bram_heap_segment_init::$20 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [153] ((unsigned int *)&bram_heap_segment+$21)[bram_heap_segment_init::$20] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta bram_heap_segment+$21,y
    sta bram_heap_segment+$21+1,y
    // bram_heap_segment.freeCount[s] = 0
    // [154] bram_heap_segment_init::$21 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [155] ((unsigned int *)&bram_heap_segment+$25)[bram_heap_segment_init::$21] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta bram_heap_segment+$25,y
    sta bram_heap_segment+$25+1,y
    // bram_heap_segment.idleCount[s] = 0
    // [156] bram_heap_segment_init::$22 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [157] ((unsigned int *)&bram_heap_segment+$29)[bram_heap_segment_init::$22] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta bram_heap_segment+$29,y
    sta bram_heap_segment+$29+1,y
    // bram_heap_segment.heap_list[s] = BRAM_HEAP_NULL
    // [158] ((char *)&bram_heap_segment+$17)[bram_heap_segment_init::s] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #$ff
    ldy.z s
    sta bram_heap_segment+$17,y
    // bram_heap_segment.idle_list[s] = BRAM_HEAP_NULL
    // [159] ((char *)&bram_heap_segment+$1b)[bram_heap_segment_init::s] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    sta bram_heap_segment+$1b,y
    // bram_heap_segment.free_list[s] = BRAM_HEAP_NULL
    // [160] ((char *)&bram_heap_segment+$19)[bram_heap_segment_init::s] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    sta bram_heap_segment+$19,y
    // bram_heap_segment_init::bank_get_bram1
    // return BRAM;
    // [161] bram_heap_segment_init::bank_old#0 = BRAM -- vbuz1=vbuz2 
    lda.z BRAM
    sta.z bank_old
    // bram_heap_segment_init::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [162] bram_heap_segment_init::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment+$35
    // bram_heap_segment_init::bank_set_bram1
    // BRAM = bank
    // [163] BRAM = bram_heap_segment_init::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_segment_init::@2
    // bram_heap_index_t free_index = bram_heap_index_add(s)
    // [164] bram_heap_index_add::s#0 = bram_heap_segment_init::s -- vbuxx=vbuz1 
    ldx.z s
    // [165] call bram_heap_index_add
    // [442] phi from bram_heap_segment_init::@2 to bram_heap_index_add [phi:bram_heap_segment_init::@2->bram_heap_index_add]
    // [442] phi bram_heap_index_add::s#2 = bram_heap_index_add::s#0 [phi:bram_heap_segment_init::@2->bram_heap_index_add#0] -- register_copy 
    jsr bram_heap_index_add
    // bram_heap_index_t free_index = bram_heap_index_add(s)
    // [166] bram_heap_index_add::return#0 = bram_heap_index_add::return#1 -- vbuaa=vbuz1 
    lda.z bram_heap_index_add.return
    // bram_heap_segment_init::@6
    // [167] bram_heap_segment_init::free_index#0 = bram_heap_index_add::return#0 -- vbuxx=vbuaa 
    tax
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, free_index)
    // [168] bram_heap_list_insert_at::s#0 = bram_heap_segment_init::s -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_list_insert_at.s
    // [169] bram_heap_list_insert_at::list#0 = ((char *)&bram_heap_segment+$19)[bram_heap_segment_init::s] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda bram_heap_segment+$19,y
    sta.z bram_heap_list_insert_at.list
    // [170] bram_heap_list_insert_at::index#0 = bram_heap_segment_init::free_index#0 -- vbuz1=vbuxx 
    stx.z bram_heap_list_insert_at.index
    // [171] bram_heap_list_insert_at::at#0 = bram_heap_segment_init::free_index#0 -- vbuz1=vbuxx 
    stx.z bram_heap_list_insert_at.at
    // [172] call bram_heap_list_insert_at
    // [453] phi from bram_heap_segment_init::@6 to bram_heap_list_insert_at [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at]
    // [453] phi bram_heap_list_insert_at::s#10 = bram_heap_list_insert_at::s#0 [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at#0] -- register_copy 
    // [453] phi bram_heap_list_insert_at::index#10 = bram_heap_list_insert_at::index#0 [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at#1] -- register_copy 
    // [453] phi bram_heap_list_insert_at::at#10 = bram_heap_list_insert_at::at#0 [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at#2] -- register_copy 
    // [453] phi bram_heap_list_insert_at::list#5 = bram_heap_list_insert_at::list#0 [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at#3] -- register_copy 
    jsr bram_heap_list_insert_at
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, free_index)
    // [173] bram_heap_list_insert_at::return#0 = bram_heap_list_insert_at::list#11 -- vbuaa=vbuz1 
    lda.z bram_heap_list_insert_at.list
    // bram_heap_segment_init::@7
    // free_index = bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, free_index)
    // [174] bram_heap_segment_init::free_index#1 = bram_heap_list_insert_at::return#0 -- vbuz1=vbuaa 
    sta.z free_index
    // bram_heap_set_data_packed(s, free_index, bram_heap_segment.floor[s])
    // [175] bram_heap_segment_init::$23 = bram_heap_segment_init::s << 1 -- vbuyy=vbuz1_rol_1 
    lda.z s
    asl
    tay
    // [176] bram_heap_set_data_packed::s#0 = bram_heap_segment_init::s -- vbuxx=vbuz1 
    ldx.z s
    // [177] bram_heap_set_data_packed::index#0 = bram_heap_segment_init::free_index#1 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_set_data_packed.index
    // [178] bram_heap_set_data_packed::data_packed#0 = ((unsigned int *)&bram_heap_segment+9)[bram_heap_segment_init::$23] -- vwuz1=pwuc1_derefidx_vbuyy 
    lda bram_heap_segment+9,y
    sta.z bram_heap_set_data_packed.data_packed
    lda bram_heap_segment+9+1,y
    sta.z bram_heap_set_data_packed.data_packed+1
    // [179] call bram_heap_set_data_packed
    // [490] phi from bram_heap_segment_init::@7 to bram_heap_set_data_packed [phi:bram_heap_segment_init::@7->bram_heap_set_data_packed]
    // [490] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#0 [phi:bram_heap_segment_init::@7->bram_heap_set_data_packed#0] -- register_copy 
    // [490] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#0 [phi:bram_heap_segment_init::@7->bram_heap_set_data_packed#1] -- register_copy 
    // [490] phi bram_heap_set_data_packed::s#7 = bram_heap_set_data_packed::s#0 [phi:bram_heap_segment_init::@7->bram_heap_set_data_packed#2] -- register_copy 
    jsr bram_heap_set_data_packed
    // bram_heap_segment_init::@8
    // bram_heap_set_size_packed(s, free_index, free_size)
    // [180] bram_heap_set_size_packed::s#0 = bram_heap_segment_init::s -- vbuxx=vbuz1 
    ldx.z s
    // [181] bram_heap_set_size_packed::index#0 = bram_heap_segment_init::free_index#1 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_set_size_packed.index
    // [182] bram_heap_set_size_packed::size_packed#0 = bram_heap_segment_init::free_size#1 -- vwuz1=vwuz2 
    lda.z free_size
    sta.z bram_heap_set_size_packed.size_packed
    lda.z free_size+1
    sta.z bram_heap_set_size_packed.size_packed+1
    // [183] call bram_heap_set_size_packed
    // [500] phi from bram_heap_segment_init::@8 to bram_heap_set_size_packed [phi:bram_heap_segment_init::@8->bram_heap_set_size_packed]
    // [500] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#0 [phi:bram_heap_segment_init::@8->bram_heap_set_size_packed#0] -- register_copy 
    // [500] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#0 [phi:bram_heap_segment_init::@8->bram_heap_set_size_packed#1] -- register_copy 
    // [500] phi bram_heap_set_size_packed::s#6 = bram_heap_set_size_packed::s#0 [phi:bram_heap_segment_init::@8->bram_heap_set_size_packed#2] -- register_copy 
    jsr bram_heap_set_size_packed
    // bram_heap_segment_init::@9
    // bram_heap_set_free(s, free_index)
    // [184] bram_heap_set_free::s#0 = bram_heap_segment_init::s -- vbuaa=vbuz1 
    lda.z s
    // [185] bram_heap_set_free::index#0 = bram_heap_segment_init::free_index#1 -- vbuxx=vbuz1 
    ldx.z free_index
    // [186] call bram_heap_set_free
    // [512] phi from bram_heap_segment_init::@9 to bram_heap_set_free [phi:bram_heap_segment_init::@9->bram_heap_set_free]
    // [512] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#0 [phi:bram_heap_segment_init::@9->bram_heap_set_free#0] -- register_copy 
    // [512] phi bram_heap_set_free::s#5 = bram_heap_set_free::s#0 [phi:bram_heap_segment_init::@9->bram_heap_set_free#1] -- register_copy 
    jsr bram_heap_set_free
    // bram_heap_segment_init::@10
    // bram_heap_set_next(s, free_index, free_index)
    // [187] bram_heap_set_next::s#0 = bram_heap_segment_init::s -- vbuyy=vbuz1 
    ldy.z s
    // [188] bram_heap_set_next::index#0 = bram_heap_segment_init::free_index#1 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_set_next.index
    // [189] bram_heap_set_next::next#0 = bram_heap_segment_init::free_index#1 -- vbuxx=vbuz1 
    ldx.z free_index
    // [190] call bram_heap_set_next
    // [520] phi from bram_heap_segment_init::@10 to bram_heap_set_next [phi:bram_heap_segment_init::@10->bram_heap_set_next]
    // [520] phi bram_heap_set_next::index#6 = bram_heap_set_next::index#0 [phi:bram_heap_segment_init::@10->bram_heap_set_next#0] -- register_copy 
    // [520] phi bram_heap_set_next::next#6 = bram_heap_set_next::next#0 [phi:bram_heap_segment_init::@10->bram_heap_set_next#1] -- register_copy 
    // [520] phi bram_heap_set_next::s#6 = bram_heap_set_next::s#0 [phi:bram_heap_segment_init::@10->bram_heap_set_next#2] -- register_copy 
    jsr bram_heap_set_next
    // bram_heap_segment_init::@11
    // bram_heap_set_prev(s, free_index, free_index)
    // [191] bram_heap_set_prev::s#0 = bram_heap_segment_init::s -- vbuyy=vbuz1 
    ldy.z s
    // [192] bram_heap_set_prev::index#0 = bram_heap_segment_init::free_index#1 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_set_prev.index
    // [193] bram_heap_set_prev::prev#0 = bram_heap_segment_init::free_index#1 -- vbuxx=vbuz1 
    ldx.z free_index
    // [194] call bram_heap_set_prev
    // [527] phi from bram_heap_segment_init::@11 to bram_heap_set_prev [phi:bram_heap_segment_init::@11->bram_heap_set_prev]
    // [527] phi bram_heap_set_prev::index#6 = bram_heap_set_prev::index#0 [phi:bram_heap_segment_init::@11->bram_heap_set_prev#0] -- register_copy 
    // [527] phi bram_heap_set_prev::prev#6 = bram_heap_set_prev::prev#0 [phi:bram_heap_segment_init::@11->bram_heap_set_prev#1] -- register_copy 
    // [527] phi bram_heap_set_prev::s#6 = bram_heap_set_prev::s#0 [phi:bram_heap_segment_init::@11->bram_heap_set_prev#2] -- register_copy 
    jsr bram_heap_set_prev
    // bram_heap_segment_init::@12
    // bram_heap_segment.freeCount[s]++;
    // [195] bram_heap_segment_init::$25 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [196] ((unsigned int *)&bram_heap_segment+$25)[bram_heap_segment_init::$25] = ++ ((unsigned int *)&bram_heap_segment+$25)[bram_heap_segment_init::$25] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc bram_heap_segment+$25,x
    bne !+
    inc bram_heap_segment+$25+1,x
  !:
    // bram_heap_segment.free_list[s] = free_index
    // [197] ((char *)&bram_heap_segment+$19)[bram_heap_segment_init::s] = bram_heap_segment_init::free_index#1 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z free_index
    ldy.z s
    sta bram_heap_segment+$19,y
    // bram_heap_segment.freeSize[s] = free_size
    // [198] bram_heap_segment_init::$26 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [199] ((unsigned int *)&bram_heap_segment+$31)[bram_heap_segment_init::$26] = bram_heap_segment_init::free_size#1 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z free_size
    sta bram_heap_segment+$31,y
    lda.z free_size+1
    sta bram_heap_segment+$31+1,y
    // bram_heap_segment.heapSize[s] = 0
    // [200] bram_heap_segment_init::$27 = bram_heap_segment_init::s << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [201] ((unsigned int *)&bram_heap_segment+$2d)[bram_heap_segment_init::$27] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta bram_heap_segment+$2d,y
    sta bram_heap_segment+$2d+1,y
    // bram_heap_segment_init::bank_set_bram2
    // BRAM = bank
    // [202] BRAM = bram_heap_segment_init::bank_old#0 -- vbuz1=vbuz2 
    lda.z bank_old
    sta.z BRAM
    // bram_heap_segment_init::@3
    // return s;
    // [203] bram_heap_segment_init::return = bram_heap_segment_init::s
    // bram_heap_segment_init::@return
    // }
    // [204] return 
    rts
}
  // bram_heap_bram_bank_init
// void bram_heap_bram_bank_init(__zp($46) char bram_bank)
bram_heap_bram_bank_init: {
    .label bram_bank = $46
    // bram_heap_segment.bram_bank = bram_bank
    // [205] *((char *)&bram_heap_segment+$35) = bram_heap_bram_bank_init::bram_bank -- _deref_pbuc1=vbuz1 
    lda.z bram_bank
    sta bram_heap_segment+$35
    // bram_heap_segment.segments = BRAM_HEAP_SEGMENTS
    // [206] *((char *)&bram_heap_segment) = 2 -- _deref_pbuc1=vbuc2 
    lda #2
    sta bram_heap_segment
    // bram_heap_bram_bank_init::bank_get_bram1
    // return BRAM;
    // [207] bram_heap_bram_bank_init::bank_get_bram1_return#0 = BRAM -- vbuaa=vbuz1 
    lda.z BRAM
    // bram_heap_bram_bank_init::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [208] bram_heap_bram_bank_init::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment+$35
    // bram_heap_bram_bank_init::bank_set_bram1
    // BRAM = bank
    // [209] BRAM = bram_heap_bram_bank_init::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // [210] phi from bram_heap_bram_bank_init::bank_set_bram1 to bram_heap_bram_bank_init::@2 [phi:bram_heap_bram_bank_init::bank_set_bram1->bram_heap_bram_bank_init::@2]
    // bram_heap_bram_bank_init::@2
    // memset((void*)0xA000, 0, 0x2000)
    // [211] call memset
    // [534] phi from bram_heap_bram_bank_init::@2 to memset [phi:bram_heap_bram_bank_init::@2->memset]
    jsr memset
    // bram_heap_bram_bank_init::bank_set_bram2
    // BRAM = bank
    // [212] BRAM = bram_heap_bram_bank_init::bank_get_bram1_return#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_bram_bank_init::@return
    // }
    // [213] return 
    rts
}
  // bram_heap_get_size_packed
// __zp($3f) unsigned int bram_heap_get_size_packed(__register(A) char s, __register(X) char index)
bram_heap_get_size_packed: {
    .label bram_heap_get_size_packed__2 = $b
    .label bram_heap_get_size_packed__3 = $14
    .label bram_heap_get_size_packed__4 = $b
    .label bram_heap_get_size_packed__5 = $b
    .label return = $36
    .label return_1 = $18
    .label bram_heap_map = $b
    .label hi = $a
    .label return_2 = $3d
    .label return_3 = $3f
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [215] bram_heap_get_size_packed::$5 = (unsigned int)bram_heap_get_size_packed::s#8 -- vwuz1=_word_vbuaa 
    sta.z bram_heap_get_size_packed__5
    lda #0
    sta.z bram_heap_get_size_packed__5+1
    // [216] bram_heap_get_size_packed::$2 = bram_heap_get_size_packed::$5 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_get_size_packed__2
    rol.z bram_heap_get_size_packed__2+1
    dey
    bne !-
  !e:
    // [217] bram_heap_get_size_packed::bram_heap_map#0 = bram_heap_index + bram_heap_get_size_packed::$2 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // unsigned char hi = bram_heap_map->size1[index]
    // [218] bram_heap_get_size_packed::$3 = (char *)bram_heap_get_size_packed::bram_heap_map#0 + $300 -- pbuz1=pbuz2_plus_vwuc1 
    lda.z bram_heap_map
    clc
    adc #<$300
    sta.z bram_heap_get_size_packed__3
    lda.z bram_heap_map+1
    adc #>$300
    sta.z bram_heap_get_size_packed__3+1
    // [219] bram_heap_get_size_packed::hi#0 = bram_heap_get_size_packed::$3[bram_heap_get_size_packed::index#8] -- vbuaa=pbuz1_derefidx_vbuxx 
    txa
    tay
    lda (bram_heap_get_size_packed__3),y
    // hi &= 0x7F
    // [220] bram_heap_get_size_packed::hi#1 = bram_heap_get_size_packed::hi#0 & $7f -- vbuz1=vbuaa_band_vbuc1 
    and #$7f
    sta.z hi
    // unsigned char lo = bram_heap_map->size0[index]
    // [221] bram_heap_get_size_packed::$4 = (char *)bram_heap_get_size_packed::bram_heap_map#0 + $200 -- pbuz1=pbuz1_plus_vwuc1 
    // Ignore free flag!
    lda.z bram_heap_get_size_packed__4
    clc
    adc #<$200
    sta.z bram_heap_get_size_packed__4
    lda.z bram_heap_get_size_packed__4+1
    adc #>$200
    sta.z bram_heap_get_size_packed__4+1
    // [222] bram_heap_get_size_packed::lo#0 = bram_heap_get_size_packed::$4[bram_heap_get_size_packed::index#8] -- vbuaa=pbuz1_derefidx_vbuxx 
    // Ignore free flag!
    txa
    tay
    lda (bram_heap_get_size_packed__4),y
    // MAKEWORD(hi, lo)
    // [223] bram_heap_get_size_packed::return#12 = bram_heap_get_size_packed::hi#1 w= bram_heap_get_size_packed::lo#0 -- vwuz1=vbuz2_word_vbuaa 
    ldy.z hi
    sty.z return_1+1
    sta.z return_1
    // bram_heap_get_size_packed::@return
    // }
    // [224] return 
    rts
}
  // bram_heap_get_data_packed
// __zp($26) unsigned int bram_heap_get_data_packed(__register(A) char s, __register(X) char index)
bram_heap_get_data_packed: {
    .label bram_heap_get_data_packed__2 = $14
    .label bram_heap_get_data_packed__3 = 2
    .label bram_heap_get_data_packed__5 = $14
    .label return = $30
    .label bram_heap_map = $14
    .label hi = $1f
    .label return_1 = $2e
    .label return_2 = $2c
    .label return_3 = 6
    .label return_4 = 4
    .label return_5 = $33
    .label return_6 = $26
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [226] bram_heap_get_data_packed::$5 = (unsigned int)bram_heap_get_data_packed::s#8 -- vwuz1=_word_vbuaa 
    sta.z bram_heap_get_data_packed__5
    lda #0
    sta.z bram_heap_get_data_packed__5+1
    // [227] bram_heap_get_data_packed::$2 = bram_heap_get_data_packed::$5 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_get_data_packed__2
    rol.z bram_heap_get_data_packed__2+1
    dey
    bne !-
  !e:
    // [228] bram_heap_get_data_packed::bram_heap_map#0 = bram_heap_index + bram_heap_get_data_packed::$2 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // unsigned char hi = bram_heap_map->data1[index]
    // [229] bram_heap_get_data_packed::$3 = (char *)bram_heap_get_data_packed::bram_heap_map#0 + $100 -- pbuz1=pbuz2_plus_vwuc1 
    lda.z bram_heap_map
    clc
    adc #<$100
    sta.z bram_heap_get_data_packed__3
    lda.z bram_heap_map+1
    adc #>$100
    sta.z bram_heap_get_data_packed__3+1
    // [230] bram_heap_get_data_packed::hi#0 = bram_heap_get_data_packed::$3[bram_heap_get_data_packed::index#8] -- vbuz1=pbuz2_derefidx_vbuxx 
    txa
    tay
    lda (bram_heap_get_data_packed__3),y
    sta.z hi
    // unsigned char lo = bram_heap_map->data0[index]
    // [231] bram_heap_get_data_packed::lo#0 = ((char *)bram_heap_get_data_packed::bram_heap_map#0)[bram_heap_get_data_packed::index#8] -- vbuaa=pbuz1_derefidx_vbuxx 
    txa
    tay
    lda (bram_heap_map),y
    // MAKEWORD(hi, lo)
    // [232] bram_heap_get_data_packed::return#1 = bram_heap_get_data_packed::hi#0 w= bram_heap_get_data_packed::lo#0 -- vwuz1=vbuz2_word_vbuaa 
    ldy.z hi
    sty.z return+1
    sta.z return
    // bram_heap_get_data_packed::@return
    // }
    // [233] return 
    rts
}
  // bram_heap_heap_remove
// void bram_heap_heap_remove(__zp($47) char s, __zp($e) char heap_index)
bram_heap_heap_remove: {
    .label s = $47
    .label heap_index = $e
    // bram_heap_segment.heapCount[s]--;
    // [234] bram_heap_heap_remove::$3 = bram_heap_heap_remove::s#0 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [235] ((unsigned int *)&bram_heap_segment+$21)[bram_heap_heap_remove::$3] = -- ((unsigned int *)&bram_heap_segment+$21)[bram_heap_heap_remove::$3] -- pwuc1_derefidx_vbuaa=_dec_pwuc1_derefidx_vbuaa 
    tax
    lda bram_heap_segment+$21,x
    bne !+
    dec bram_heap_segment+$21+1,x
  !:
    dec bram_heap_segment+$21,x
    // bram_heap_list_remove(s, bram_heap_segment.heap_list[s], heap_index)
    // [236] bram_heap_list_remove::s#0 = bram_heap_heap_remove::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_list_remove.s
    // [237] bram_heap_list_remove::list#2 = ((char *)&bram_heap_segment+$17)[bram_heap_heap_remove::s#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda bram_heap_segment+$17,y
    sta.z bram_heap_list_remove.list
    // [238] bram_heap_list_remove::index#0 = bram_heap_heap_remove::heap_index#0
    // [239] call bram_heap_list_remove
    // [540] phi from bram_heap_heap_remove to bram_heap_list_remove [phi:bram_heap_heap_remove->bram_heap_list_remove]
    // [540] phi bram_heap_list_remove::index#10 = bram_heap_list_remove::index#0 [phi:bram_heap_heap_remove->bram_heap_list_remove#0] -- register_copy 
    // [540] phi bram_heap_list_remove::s#10 = bram_heap_list_remove::s#0 [phi:bram_heap_heap_remove->bram_heap_list_remove#1] -- register_copy 
    // [540] phi bram_heap_list_remove::list#10 = bram_heap_list_remove::list#2 [phi:bram_heap_heap_remove->bram_heap_list_remove#2] -- register_copy 
    jsr bram_heap_list_remove
    // bram_heap_list_remove(s, bram_heap_segment.heap_list[s], heap_index)
    // [240] bram_heap_list_remove::return#4 = bram_heap_list_remove::return#1 -- vbuaa=vbuz1 
    lda.z bram_heap_list_remove.return
    // bram_heap_heap_remove::@1
    // [241] bram_heap_heap_remove::$1 = bram_heap_list_remove::return#4
    // bram_heap_segment.heap_list[s] = bram_heap_list_remove(s, bram_heap_segment.heap_list[s], heap_index)
    // [242] ((char *)&bram_heap_segment+$17)[bram_heap_heap_remove::s#0] = bram_heap_heap_remove::$1 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z s
    sta bram_heap_segment+$17,y
    // bram_heap_heap_remove::@return
    // }
    // [243] return 
    rts
}
  // bram_heap_free_insert
// char bram_heap_free_insert(__zp($48) char s, __zp($49) char free_index, __zp($14) unsigned int data, __zp($12) unsigned int size)
bram_heap_free_insert: {
    .label s = $48
    .label free_index = $49
    .label data = $14
    .label size = $12
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, bram_heap_segment.free_list[s])
    // [244] bram_heap_list_insert_at::s#2 = bram_heap_free_insert::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_list_insert_at.s
    // [245] bram_heap_list_insert_at::list#3 = ((char *)&bram_heap_segment+$19)[bram_heap_free_insert::s#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda bram_heap_segment+$19,y
    sta.z bram_heap_list_insert_at.list
    // [246] bram_heap_list_insert_at::index#2 = bram_heap_free_insert::free_index#0 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_list_insert_at.index
    // [247] bram_heap_list_insert_at::at#3 = ((char *)&bram_heap_segment+$19)[bram_heap_free_insert::s#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    lda bram_heap_segment+$19,y
    sta.z bram_heap_list_insert_at.at
    // [248] call bram_heap_list_insert_at
    // [453] phi from bram_heap_free_insert to bram_heap_list_insert_at [phi:bram_heap_free_insert->bram_heap_list_insert_at]
    // [453] phi bram_heap_list_insert_at::s#10 = bram_heap_list_insert_at::s#2 [phi:bram_heap_free_insert->bram_heap_list_insert_at#0] -- register_copy 
    // [453] phi bram_heap_list_insert_at::index#10 = bram_heap_list_insert_at::index#2 [phi:bram_heap_free_insert->bram_heap_list_insert_at#1] -- register_copy 
    // [453] phi bram_heap_list_insert_at::at#10 = bram_heap_list_insert_at::at#3 [phi:bram_heap_free_insert->bram_heap_list_insert_at#2] -- register_copy 
    // [453] phi bram_heap_list_insert_at::list#5 = bram_heap_list_insert_at::list#3 [phi:bram_heap_free_insert->bram_heap_list_insert_at#3] -- register_copy 
    jsr bram_heap_list_insert_at
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, bram_heap_segment.free_list[s])
    // [249] bram_heap_list_insert_at::return#4 = bram_heap_list_insert_at::list#11 -- vbuaa=vbuz1 
    lda.z bram_heap_list_insert_at.list
    // bram_heap_free_insert::@1
    // [250] bram_heap_free_insert::$0 = bram_heap_list_insert_at::return#4
    // bram_heap_segment.free_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, bram_heap_segment.free_list[s])
    // [251] ((char *)&bram_heap_segment+$19)[bram_heap_free_insert::s#0] = bram_heap_free_insert::$0 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z s
    sta bram_heap_segment+$19,y
    // bram_heap_set_data_packed(s, free_index, data)
    // [252] bram_heap_set_data_packed::s#1 = bram_heap_free_insert::s#0 -- vbuxx=vbuz1 
    ldx.z s
    // [253] bram_heap_set_data_packed::index#1 = bram_heap_free_insert::free_index#0 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_set_data_packed.index
    // [254] bram_heap_set_data_packed::data_packed#1 = bram_heap_free_insert::data#0
    // [255] call bram_heap_set_data_packed
    // [490] phi from bram_heap_free_insert::@1 to bram_heap_set_data_packed [phi:bram_heap_free_insert::@1->bram_heap_set_data_packed]
    // [490] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#1 [phi:bram_heap_free_insert::@1->bram_heap_set_data_packed#0] -- register_copy 
    // [490] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#1 [phi:bram_heap_free_insert::@1->bram_heap_set_data_packed#1] -- register_copy 
    // [490] phi bram_heap_set_data_packed::s#7 = bram_heap_set_data_packed::s#1 [phi:bram_heap_free_insert::@1->bram_heap_set_data_packed#2] -- register_copy 
    jsr bram_heap_set_data_packed
    // bram_heap_free_insert::@2
    // bram_heap_set_size_packed(s, free_index, size)
    // [256] bram_heap_set_size_packed::s#2 = bram_heap_free_insert::s#0 -- vbuxx=vbuz1 
    ldx.z s
    // [257] bram_heap_set_size_packed::index#2 = bram_heap_free_insert::free_index#0 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_set_size_packed.index
    // [258] bram_heap_set_size_packed::size_packed#2 = bram_heap_free_insert::size#0 -- vwuz1=vwuz2 
    lda.z size
    sta.z bram_heap_set_size_packed.size_packed
    lda.z size+1
    sta.z bram_heap_set_size_packed.size_packed+1
    // [259] call bram_heap_set_size_packed
    // [500] phi from bram_heap_free_insert::@2 to bram_heap_set_size_packed [phi:bram_heap_free_insert::@2->bram_heap_set_size_packed]
    // [500] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#2 [phi:bram_heap_free_insert::@2->bram_heap_set_size_packed#0] -- register_copy 
    // [500] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#2 [phi:bram_heap_free_insert::@2->bram_heap_set_size_packed#1] -- register_copy 
    // [500] phi bram_heap_set_size_packed::s#6 = bram_heap_set_size_packed::s#2 [phi:bram_heap_free_insert::@2->bram_heap_set_size_packed#2] -- register_copy 
    jsr bram_heap_set_size_packed
    // bram_heap_free_insert::@3
    // bram_heap_set_free(s, free_index)
    // [260] bram_heap_set_free::s#1 = bram_heap_free_insert::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [261] bram_heap_set_free::index#1 = bram_heap_free_insert::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [262] call bram_heap_set_free
    // [512] phi from bram_heap_free_insert::@3 to bram_heap_set_free [phi:bram_heap_free_insert::@3->bram_heap_set_free]
    // [512] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#1 [phi:bram_heap_free_insert::@3->bram_heap_set_free#0] -- register_copy 
    // [512] phi bram_heap_set_free::s#5 = bram_heap_set_free::s#1 [phi:bram_heap_free_insert::@3->bram_heap_set_free#1] -- register_copy 
    jsr bram_heap_set_free
    // bram_heap_free_insert::@4
    // bram_heap_segment.freeCount[s]++;
    // [263] bram_heap_free_insert::$6 = bram_heap_free_insert::s#0 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [264] ((unsigned int *)&bram_heap_segment+$25)[bram_heap_free_insert::$6] = ++ ((unsigned int *)&bram_heap_segment+$25)[bram_heap_free_insert::$6] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc bram_heap_segment+$25,x
    bne !+
    inc bram_heap_segment+$25+1,x
  !:
    // bram_heap_free_insert::@return
    // }
    // [265] return 
    rts
}
  // bram_heap_can_coalesce_left
/**
 * Whether we should merge this header to the left.
 */
// __zp($1e) char bram_heap_can_coalesce_left(__zp($10) char s, __zp($11) char heap_index)
bram_heap_can_coalesce_left: {
    .label s = $10
    .label heap_index = $11
    .label heap_offset = 6
    .label left_index = $1e
    .label left_offset = $30
    .label return = $1e
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [266] bram_heap_get_data_packed::s#3 = bram_heap_can_coalesce_left::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [267] bram_heap_get_data_packed::index#3 = bram_heap_can_coalesce_left::heap_index#0 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [268] call bram_heap_get_data_packed
    // [225] phi from bram_heap_can_coalesce_left to bram_heap_get_data_packed [phi:bram_heap_can_coalesce_left->bram_heap_get_data_packed]
    // [225] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#3 [phi:bram_heap_can_coalesce_left->bram_heap_get_data_packed#0] -- register_copy 
    // [225] phi bram_heap_get_data_packed::s#8 = bram_heap_get_data_packed::s#3 [phi:bram_heap_can_coalesce_left->bram_heap_get_data_packed#1] -- register_copy 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [269] bram_heap_get_data_packed::return#14 = bram_heap_get_data_packed::return#1 -- vwuz1=vwuz2 
    lda.z bram_heap_get_data_packed.return
    sta.z bram_heap_get_data_packed.return_3
    lda.z bram_heap_get_data_packed.return+1
    sta.z bram_heap_get_data_packed.return_3+1
    // bram_heap_can_coalesce_left::@2
    // [270] bram_heap_can_coalesce_left::heap_offset#0 = bram_heap_get_data_packed::return#14
    // bram_heap_index_t left_index = bram_heap_get_left(s, heap_index)
    // [271] bram_heap_get_left::s#2 = bram_heap_can_coalesce_left::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [272] bram_heap_get_left::index#2 = bram_heap_can_coalesce_left::heap_index#0 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [273] call bram_heap_get_left
    // [581] phi from bram_heap_can_coalesce_left::@2 to bram_heap_get_left [phi:bram_heap_can_coalesce_left::@2->bram_heap_get_left]
    // [581] phi bram_heap_get_left::index#4 = bram_heap_get_left::index#2 [phi:bram_heap_can_coalesce_left::@2->bram_heap_get_left#0] -- register_copy 
    // [581] phi bram_heap_get_left::s#4 = bram_heap_get_left::s#2 [phi:bram_heap_can_coalesce_left::@2->bram_heap_get_left#1] -- register_copy 
    jsr bram_heap_get_left
    // bram_heap_index_t left_index = bram_heap_get_left(s, heap_index)
    // [274] bram_heap_get_left::return#4 = bram_heap_get_left::return#0
    // bram_heap_can_coalesce_left::@3
    // [275] bram_heap_can_coalesce_left::left_index#0 = bram_heap_get_left::return#4 -- vbuz1=vbuaa 
    sta.z left_index
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [276] bram_heap_get_data_packed::s#4 = bram_heap_can_coalesce_left::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [277] bram_heap_get_data_packed::index#4 = bram_heap_can_coalesce_left::left_index#0 -- vbuxx=vbuz1 
    ldx.z left_index
    // [278] call bram_heap_get_data_packed
    // [225] phi from bram_heap_can_coalesce_left::@3 to bram_heap_get_data_packed [phi:bram_heap_can_coalesce_left::@3->bram_heap_get_data_packed]
    // [225] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#4 [phi:bram_heap_can_coalesce_left::@3->bram_heap_get_data_packed#0] -- register_copy 
    // [225] phi bram_heap_get_data_packed::s#8 = bram_heap_get_data_packed::s#4 [phi:bram_heap_can_coalesce_left::@3->bram_heap_get_data_packed#1] -- register_copy 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [279] bram_heap_get_data_packed::return#15 = bram_heap_get_data_packed::return#1
    // bram_heap_can_coalesce_left::@4
    // [280] bram_heap_can_coalesce_left::left_offset#0 = bram_heap_get_data_packed::return#15
    // bool left_free = bram_heap_is_free(s, left_index)
    // [281] bram_heap_is_free::s#0 = bram_heap_can_coalesce_left::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [282] bram_heap_is_free::index#0 = bram_heap_can_coalesce_left::left_index#0 -- vbuxx=vbuz1 
    ldx.z left_index
    // [283] call bram_heap_is_free
    // [588] phi from bram_heap_can_coalesce_left::@4 to bram_heap_is_free [phi:bram_heap_can_coalesce_left::@4->bram_heap_is_free]
    // [588] phi bram_heap_is_free::index#2 = bram_heap_is_free::index#0 [phi:bram_heap_can_coalesce_left::@4->bram_heap_is_free#0] -- register_copy 
    // [588] phi bram_heap_is_free::s#2 = bram_heap_is_free::s#0 [phi:bram_heap_can_coalesce_left::@4->bram_heap_is_free#1] -- register_copy 
    jsr bram_heap_is_free
    // bool left_free = bram_heap_is_free(s, left_index)
    // [284] bram_heap_is_free::return#2 = bram_heap_is_free::return#0
    // bram_heap_can_coalesce_left::@5
    // [285] bram_heap_can_coalesce_left::left_free#0 = bram_heap_is_free::return#2
    // if(left_free && (left_offset < heap_offset))
    // [286] if(bram_heap_can_coalesce_left::left_free#0) goto bram_heap_can_coalesce_left::@6 -- vboaa_then_la1 
    cmp #0
    bne __b6
    // [289] phi from bram_heap_can_coalesce_left::@5 bram_heap_can_coalesce_left::@6 to bram_heap_can_coalesce_left::@return [phi:bram_heap_can_coalesce_left::@5/bram_heap_can_coalesce_left::@6->bram_heap_can_coalesce_left::@return]
  __b2:
    // [289] phi bram_heap_can_coalesce_left::return#3 = $ff [phi:bram_heap_can_coalesce_left::@5/bram_heap_can_coalesce_left::@6->bram_heap_can_coalesce_left::@return#0] -- vbuz1=vbuc1 
    lda #$ff
    sta.z return
    rts
    // bram_heap_can_coalesce_left::@6
  __b6:
    // if(left_free && (left_offset < heap_offset))
    // [287] if(bram_heap_can_coalesce_left::left_offset#0<bram_heap_can_coalesce_left::heap_offset#0) goto bram_heap_can_coalesce_left::@1 -- vwuz1_lt_vwuz2_then_la1 
    lda.z left_offset+1
    cmp.z heap_offset+1
    bcc __b1
    bne !+
    lda.z left_offset
    cmp.z heap_offset
    bcc __b1
  !:
    jmp __b2
    // [288] phi from bram_heap_can_coalesce_left::@6 to bram_heap_can_coalesce_left::@1 [phi:bram_heap_can_coalesce_left::@6->bram_heap_can_coalesce_left::@1]
    // bram_heap_can_coalesce_left::@1
  __b1:
    // [289] phi from bram_heap_can_coalesce_left::@1 to bram_heap_can_coalesce_left::@return [phi:bram_heap_can_coalesce_left::@1->bram_heap_can_coalesce_left::@return]
    // [289] phi bram_heap_can_coalesce_left::return#3 = bram_heap_can_coalesce_left::left_index#0 [phi:bram_heap_can_coalesce_left::@1->bram_heap_can_coalesce_left::@return#0] -- register_copy 
    // bram_heap_can_coalesce_left::@return
    // }
    // [290] return 
    rts
}
  // bram_heap_coalesce
/**
 * Coalesces two adjacent blocks to the left.
 * The left is a free index and the right is the heap index to be freed.
 * The free index remains free, and the heap to the right stays heap.
 * The free index is returned as the new remaining (free) block.
 */
// __register(A) char bram_heap_coalesce(__zp($38) char s, __zp($46) char left_index, __zp($35) char right_index)
bram_heap_coalesce: {
    .label s = $38
    .label left_index = $46
    .label right_index = $35
    .label right_size = $3d
    .label left_size = $3f
    .label left_offset = $26
    .label free_left = $4b
    .label free_right = $4a
    // bram_heap_size_packed_t right_size = bram_heap_get_size_packed(s, right_index)
    // [292] bram_heap_get_size_packed::s#6 = bram_heap_coalesce::s#10 -- vbuaa=vbuz1 
    lda.z s
    // [293] bram_heap_get_size_packed::index#6 = bram_heap_coalesce::right_index#10 -- vbuxx=vbuz1 
    ldx.z right_index
    // [294] call bram_heap_get_size_packed
    // [214] phi from bram_heap_coalesce to bram_heap_get_size_packed [phi:bram_heap_coalesce->bram_heap_get_size_packed]
    // [214] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#6 [phi:bram_heap_coalesce->bram_heap_get_size_packed#0] -- register_copy 
    // [214] phi bram_heap_get_size_packed::s#8 = bram_heap_get_size_packed::s#6 [phi:bram_heap_coalesce->bram_heap_get_size_packed#1] -- register_copy 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t right_size = bram_heap_get_size_packed(s, right_index)
    // [295] bram_heap_get_size_packed::return#16 = bram_heap_get_size_packed::return#12 -- vwuz1=vwuz2 
    lda.z bram_heap_get_size_packed.return_1
    sta.z bram_heap_get_size_packed.return_2
    lda.z bram_heap_get_size_packed.return_1+1
    sta.z bram_heap_get_size_packed.return_2+1
    // bram_heap_coalesce::@1
    // [296] bram_heap_coalesce::right_size#0 = bram_heap_get_size_packed::return#16
    // bram_heap_size_packed_t left_size = bram_heap_get_size_packed(s, left_index)
    // [297] bram_heap_get_size_packed::s#7 = bram_heap_coalesce::s#10 -- vbuaa=vbuz1 
    lda.z s
    // [298] bram_heap_get_size_packed::index#7 = bram_heap_coalesce::left_index#10 -- vbuxx=vbuz1 
    ldx.z left_index
    // [299] call bram_heap_get_size_packed
    // [214] phi from bram_heap_coalesce::@1 to bram_heap_get_size_packed [phi:bram_heap_coalesce::@1->bram_heap_get_size_packed]
    // [214] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#7 [phi:bram_heap_coalesce::@1->bram_heap_get_size_packed#0] -- register_copy 
    // [214] phi bram_heap_get_size_packed::s#8 = bram_heap_get_size_packed::s#7 [phi:bram_heap_coalesce::@1->bram_heap_get_size_packed#1] -- register_copy 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t left_size = bram_heap_get_size_packed(s, left_index)
    // [300] bram_heap_get_size_packed::return#17 = bram_heap_get_size_packed::return#12 -- vwuz1=vwuz2 
    lda.z bram_heap_get_size_packed.return_1
    sta.z bram_heap_get_size_packed.return_3
    lda.z bram_heap_get_size_packed.return_1+1
    sta.z bram_heap_get_size_packed.return_3+1
    // bram_heap_coalesce::@2
    // [301] bram_heap_coalesce::left_size#0 = bram_heap_get_size_packed::return#17
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [302] bram_heap_get_data_packed::s#7 = bram_heap_coalesce::s#10 -- vbuaa=vbuz1 
    lda.z s
    // [303] bram_heap_get_data_packed::index#7 = bram_heap_coalesce::left_index#10 -- vbuxx=vbuz1 
    ldx.z left_index
    // [304] call bram_heap_get_data_packed
    // [225] phi from bram_heap_coalesce::@2 to bram_heap_get_data_packed [phi:bram_heap_coalesce::@2->bram_heap_get_data_packed]
    // [225] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#7 [phi:bram_heap_coalesce::@2->bram_heap_get_data_packed#0] -- register_copy 
    // [225] phi bram_heap_get_data_packed::s#8 = bram_heap_get_data_packed::s#7 [phi:bram_heap_coalesce::@2->bram_heap_get_data_packed#1] -- register_copy 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [305] bram_heap_get_data_packed::return#18 = bram_heap_get_data_packed::return#1 -- vwuz1=vwuz2 
    lda.z bram_heap_get_data_packed.return
    sta.z bram_heap_get_data_packed.return_6
    lda.z bram_heap_get_data_packed.return+1
    sta.z bram_heap_get_data_packed.return_6+1
    // bram_heap_coalesce::@3
    // [306] bram_heap_coalesce::left_offset#0 = bram_heap_get_data_packed::return#18
    // bram_heap_index_t free_left = bram_heap_get_left(s, left_index)
    // [307] bram_heap_get_left::s#3 = bram_heap_coalesce::s#10 -- vbuaa=vbuz1 
    lda.z s
    // [308] bram_heap_get_left::index#3 = bram_heap_coalesce::left_index#10 -- vbuxx=vbuz1 
    ldx.z left_index
    // [309] call bram_heap_get_left
    // [581] phi from bram_heap_coalesce::@3 to bram_heap_get_left [phi:bram_heap_coalesce::@3->bram_heap_get_left]
    // [581] phi bram_heap_get_left::index#4 = bram_heap_get_left::index#3 [phi:bram_heap_coalesce::@3->bram_heap_get_left#0] -- register_copy 
    // [581] phi bram_heap_get_left::s#4 = bram_heap_get_left::s#3 [phi:bram_heap_coalesce::@3->bram_heap_get_left#1] -- register_copy 
    jsr bram_heap_get_left
    // bram_heap_index_t free_left = bram_heap_get_left(s, left_index)
    // [310] bram_heap_get_left::return#10 = bram_heap_get_left::return#0
    // bram_heap_coalesce::@4
    // [311] bram_heap_coalesce::free_left#0 = bram_heap_get_left::return#10 -- vbuz1=vbuaa 
    sta.z free_left
    // bram_heap_index_t free_right = bram_heap_get_right(s, right_index)
    // [312] bram_heap_get_right::s#2 = bram_heap_coalesce::s#10 -- vbuaa=vbuz1 
    lda.z s
    // [313] bram_heap_get_right::index#2 = bram_heap_coalesce::right_index#10 -- vbuxx=vbuz1 
    ldx.z right_index
    // [314] call bram_heap_get_right
    // [596] phi from bram_heap_coalesce::@4 to bram_heap_get_right [phi:bram_heap_coalesce::@4->bram_heap_get_right]
    // [596] phi bram_heap_get_right::index#3 = bram_heap_get_right::index#2 [phi:bram_heap_coalesce::@4->bram_heap_get_right#0] -- register_copy 
    // [596] phi bram_heap_get_right::s#3 = bram_heap_get_right::s#2 [phi:bram_heap_coalesce::@4->bram_heap_get_right#1] -- register_copy 
    jsr bram_heap_get_right
    // bram_heap_index_t free_right = bram_heap_get_right(s, right_index)
    // [315] bram_heap_get_right::return#4 = bram_heap_get_right::return#0
    // bram_heap_coalesce::@5
    // [316] bram_heap_coalesce::free_right#0 = bram_heap_get_right::return#4 -- vbuz1=vbuaa 
    sta.z free_right
    // bram_heap_free_remove(s, left_index)
    // [317] bram_heap_free_remove::s#1 = bram_heap_coalesce::s#10 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_free_remove.s
    // [318] bram_heap_free_remove::free_index#1 = bram_heap_coalesce::left_index#10 -- vbuz1=vbuz2 
    lda.z left_index
    sta.z bram_heap_free_remove.free_index
    // [319] call bram_heap_free_remove
  // We detach the left index from the free list and add it to the idle list.
    // [603] phi from bram_heap_coalesce::@5 to bram_heap_free_remove [phi:bram_heap_coalesce::@5->bram_heap_free_remove]
    // [603] phi bram_heap_free_remove::free_index#2 = bram_heap_free_remove::free_index#1 [phi:bram_heap_coalesce::@5->bram_heap_free_remove#0] -- register_copy 
    // [603] phi bram_heap_free_remove::s#2 = bram_heap_free_remove::s#1 [phi:bram_heap_coalesce::@5->bram_heap_free_remove#1] -- register_copy 
    jsr bram_heap_free_remove
    // bram_heap_coalesce::@6
    // bram_heap_idle_insert(s, left_index)
    // [320] bram_heap_idle_insert::s#0 = bram_heap_coalesce::s#10 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_idle_insert.s
    // [321] bram_heap_idle_insert::idle_index#0 = bram_heap_coalesce::left_index#10 -- vbuz1=vbuz2 
    lda.z left_index
    sta.z bram_heap_idle_insert.idle_index
    // [322] call bram_heap_idle_insert
    jsr bram_heap_idle_insert
    // bram_heap_coalesce::@7
    // bram_heap_set_left(s, right_index, free_left)
    // [323] bram_heap_set_left::s#3 = bram_heap_coalesce::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [324] bram_heap_set_left::index#3 = bram_heap_coalesce::right_index#10 -- vbuz1=vbuz2 
    lda.z right_index
    sta.z bram_heap_set_left.index
    // [325] bram_heap_set_left::left#3 = bram_heap_coalesce::free_left#0 -- vbuxx=vbuz1 
    ldx.z free_left
    // [326] call bram_heap_set_left
    // [634] phi from bram_heap_coalesce::@7 to bram_heap_set_left [phi:bram_heap_coalesce::@7->bram_heap_set_left]
    // [634] phi bram_heap_set_left::index#6 = bram_heap_set_left::index#3 [phi:bram_heap_coalesce::@7->bram_heap_set_left#0] -- register_copy 
    // [634] phi bram_heap_set_left::left#6 = bram_heap_set_left::left#3 [phi:bram_heap_coalesce::@7->bram_heap_set_left#1] -- register_copy 
    // [634] phi bram_heap_set_left::s#6 = bram_heap_set_left::s#3 [phi:bram_heap_coalesce::@7->bram_heap_set_left#2] -- register_copy 
    jsr bram_heap_set_left
    // bram_heap_coalesce::@8
    // bram_heap_set_right(s, right_index, free_right)
    // [327] bram_heap_set_right::s#3 = bram_heap_coalesce::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [328] bram_heap_set_right::index#3 = bram_heap_coalesce::right_index#10 -- vbuz1=vbuz2 
    lda.z right_index
    sta.z bram_heap_set_right.index
    // [329] bram_heap_set_right::right#3 = bram_heap_coalesce::free_right#0 -- vbuxx=vbuz1 
    ldx.z free_right
    // [330] call bram_heap_set_right
    // [641] phi from bram_heap_coalesce::@8 to bram_heap_set_right [phi:bram_heap_coalesce::@8->bram_heap_set_right]
    // [641] phi bram_heap_set_right::index#6 = bram_heap_set_right::index#3 [phi:bram_heap_coalesce::@8->bram_heap_set_right#0] -- register_copy 
    // [641] phi bram_heap_set_right::right#6 = bram_heap_set_right::right#3 [phi:bram_heap_coalesce::@8->bram_heap_set_right#1] -- register_copy 
    // [641] phi bram_heap_set_right::s#6 = bram_heap_set_right::s#3 [phi:bram_heap_coalesce::@8->bram_heap_set_right#2] -- register_copy 
    jsr bram_heap_set_right
    // bram_heap_coalesce::@9
    // bram_heap_set_left(s, free_right, right_index)
    // [331] bram_heap_set_left::s#4 = bram_heap_coalesce::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [332] bram_heap_set_left::index#4 = bram_heap_coalesce::free_right#0 -- vbuz1=vbuz2 
    lda.z free_right
    sta.z bram_heap_set_left.index
    // [333] bram_heap_set_left::left#4 = bram_heap_coalesce::right_index#10 -- vbuxx=vbuz1 
    ldx.z right_index
    // [334] call bram_heap_set_left
    // [634] phi from bram_heap_coalesce::@9 to bram_heap_set_left [phi:bram_heap_coalesce::@9->bram_heap_set_left]
    // [634] phi bram_heap_set_left::index#6 = bram_heap_set_left::index#4 [phi:bram_heap_coalesce::@9->bram_heap_set_left#0] -- register_copy 
    // [634] phi bram_heap_set_left::left#6 = bram_heap_set_left::left#4 [phi:bram_heap_coalesce::@9->bram_heap_set_left#1] -- register_copy 
    // [634] phi bram_heap_set_left::s#6 = bram_heap_set_left::s#4 [phi:bram_heap_coalesce::@9->bram_heap_set_left#2] -- register_copy 
    jsr bram_heap_set_left
    // bram_heap_coalesce::@10
    // bram_heap_set_right(s, free_left, right_index)
    // [335] bram_heap_set_right::s#4 = bram_heap_coalesce::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [336] bram_heap_set_right::index#4 = bram_heap_coalesce::free_left#0 -- vbuz1=vbuz2 
    lda.z free_left
    sta.z bram_heap_set_right.index
    // [337] bram_heap_set_right::right#4 = bram_heap_coalesce::right_index#10 -- vbuxx=vbuz1 
    ldx.z right_index
    // [338] call bram_heap_set_right
    // [641] phi from bram_heap_coalesce::@10 to bram_heap_set_right [phi:bram_heap_coalesce::@10->bram_heap_set_right]
    // [641] phi bram_heap_set_right::index#6 = bram_heap_set_right::index#4 [phi:bram_heap_coalesce::@10->bram_heap_set_right#0] -- register_copy 
    // [641] phi bram_heap_set_right::right#6 = bram_heap_set_right::right#4 [phi:bram_heap_coalesce::@10->bram_heap_set_right#1] -- register_copy 
    // [641] phi bram_heap_set_right::s#6 = bram_heap_set_right::s#4 [phi:bram_heap_coalesce::@10->bram_heap_set_right#2] -- register_copy 
    jsr bram_heap_set_right
    // bram_heap_coalesce::@11
    // bram_heap_set_left(s, left_index, BRAM_HEAP_NULL)
    // [339] bram_heap_set_left::s#5 = bram_heap_coalesce::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [340] bram_heap_set_left::index#5 = bram_heap_coalesce::left_index#10 -- vbuz1=vbuz2 
    lda.z left_index
    sta.z bram_heap_set_left.index
    // [341] call bram_heap_set_left
    // [634] phi from bram_heap_coalesce::@11 to bram_heap_set_left [phi:bram_heap_coalesce::@11->bram_heap_set_left]
    // [634] phi bram_heap_set_left::index#6 = bram_heap_set_left::index#5 [phi:bram_heap_coalesce::@11->bram_heap_set_left#0] -- register_copy 
    // [634] phi bram_heap_set_left::left#6 = $ff [phi:bram_heap_coalesce::@11->bram_heap_set_left#1] -- vbuxx=vbuc1 
    ldx #$ff
    // [634] phi bram_heap_set_left::s#6 = bram_heap_set_left::s#5 [phi:bram_heap_coalesce::@11->bram_heap_set_left#2] -- register_copy 
    jsr bram_heap_set_left
    // bram_heap_coalesce::@12
    // bram_heap_set_right(s, left_index, BRAM_HEAP_NULL)
    // [342] bram_heap_set_right::s#5 = bram_heap_coalesce::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [343] bram_heap_set_right::index#5 = bram_heap_coalesce::left_index#10 -- vbuz1=vbuz2 
    lda.z left_index
    sta.z bram_heap_set_right.index
    // [344] call bram_heap_set_right
    // [641] phi from bram_heap_coalesce::@12 to bram_heap_set_right [phi:bram_heap_coalesce::@12->bram_heap_set_right]
    // [641] phi bram_heap_set_right::index#6 = bram_heap_set_right::index#5 [phi:bram_heap_coalesce::@12->bram_heap_set_right#0] -- register_copy 
    // [641] phi bram_heap_set_right::right#6 = $ff [phi:bram_heap_coalesce::@12->bram_heap_set_right#1] -- vbuxx=vbuc1 
    ldx #$ff
    // [641] phi bram_heap_set_right::s#6 = bram_heap_set_right::s#5 [phi:bram_heap_coalesce::@12->bram_heap_set_right#2] -- register_copy 
    jsr bram_heap_set_right
    // bram_heap_coalesce::@13
    // bram_heap_set_size_packed(s, right_index, left_size + right_size)
    // [345] bram_heap_set_size_packed::size_packed#5 = bram_heap_coalesce::left_size#0 + bram_heap_coalesce::right_size#0 -- vwuz1=vwuz2_plus_vwuz3 
    lda.z left_size
    clc
    adc.z right_size
    sta.z bram_heap_set_size_packed.size_packed
    lda.z left_size+1
    adc.z right_size+1
    sta.z bram_heap_set_size_packed.size_packed+1
    // [346] bram_heap_set_size_packed::s#5 = bram_heap_coalesce::s#10 -- vbuxx=vbuz1 
    ldx.z s
    // [347] bram_heap_set_size_packed::index#5 = bram_heap_coalesce::right_index#10 -- vbuz1=vbuz2 
    lda.z right_index
    sta.z bram_heap_set_size_packed.index
    // [348] call bram_heap_set_size_packed
    // [500] phi from bram_heap_coalesce::@13 to bram_heap_set_size_packed [phi:bram_heap_coalesce::@13->bram_heap_set_size_packed]
    // [500] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#5 [phi:bram_heap_coalesce::@13->bram_heap_set_size_packed#0] -- register_copy 
    // [500] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#5 [phi:bram_heap_coalesce::@13->bram_heap_set_size_packed#1] -- register_copy 
    // [500] phi bram_heap_set_size_packed::s#6 = bram_heap_set_size_packed::s#5 [phi:bram_heap_coalesce::@13->bram_heap_set_size_packed#2] -- register_copy 
    jsr bram_heap_set_size_packed
    // bram_heap_coalesce::@14
    // bram_heap_set_data_packed(s, right_index, left_offset)
    // [349] bram_heap_set_data_packed::s#6 = bram_heap_coalesce::s#10 -- vbuxx=vbuz1 
    ldx.z s
    // [350] bram_heap_set_data_packed::index#6 = bram_heap_coalesce::right_index#10 -- vbuz1=vbuz2 
    lda.z right_index
    sta.z bram_heap_set_data_packed.index
    // [351] bram_heap_set_data_packed::data_packed#6 = bram_heap_coalesce::left_offset#0 -- vwuz1=vwuz2 
    lda.z left_offset
    sta.z bram_heap_set_data_packed.data_packed
    lda.z left_offset+1
    sta.z bram_heap_set_data_packed.data_packed+1
    // [352] call bram_heap_set_data_packed
    // [490] phi from bram_heap_coalesce::@14 to bram_heap_set_data_packed [phi:bram_heap_coalesce::@14->bram_heap_set_data_packed]
    // [490] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#6 [phi:bram_heap_coalesce::@14->bram_heap_set_data_packed#0] -- register_copy 
    // [490] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#6 [phi:bram_heap_coalesce::@14->bram_heap_set_data_packed#1] -- register_copy 
    // [490] phi bram_heap_set_data_packed::s#7 = bram_heap_set_data_packed::s#6 [phi:bram_heap_coalesce::@14->bram_heap_set_data_packed#2] -- register_copy 
    jsr bram_heap_set_data_packed
    // bram_heap_coalesce::@15
    // bram_heap_set_free(s, left_index)
    // [353] bram_heap_set_free::s#3 = bram_heap_coalesce::s#10 -- vbuaa=vbuz1 
    lda.z s
    // [354] bram_heap_set_free::index#3 = bram_heap_coalesce::left_index#10 -- vbuxx=vbuz1 
    ldx.z left_index
    // [355] call bram_heap_set_free
    // [512] phi from bram_heap_coalesce::@15 to bram_heap_set_free [phi:bram_heap_coalesce::@15->bram_heap_set_free]
    // [512] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#3 [phi:bram_heap_coalesce::@15->bram_heap_set_free#0] -- register_copy 
    // [512] phi bram_heap_set_free::s#5 = bram_heap_set_free::s#3 [phi:bram_heap_coalesce::@15->bram_heap_set_free#1] -- register_copy 
    jsr bram_heap_set_free
    // bram_heap_coalesce::@16
    // bram_heap_set_free(s, right_index)
    // [356] bram_heap_set_free::s#4 = bram_heap_coalesce::s#10 -- vbuaa=vbuz1 
    lda.z s
    // [357] bram_heap_set_free::index#4 = bram_heap_coalesce::right_index#10 -- vbuxx=vbuz1 
    ldx.z right_index
    // [358] call bram_heap_set_free
    // [512] phi from bram_heap_coalesce::@16 to bram_heap_set_free [phi:bram_heap_coalesce::@16->bram_heap_set_free]
    // [512] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#4 [phi:bram_heap_coalesce::@16->bram_heap_set_free#0] -- register_copy 
    // [512] phi bram_heap_set_free::s#5 = bram_heap_set_free::s#4 [phi:bram_heap_coalesce::@16->bram_heap_set_free#1] -- register_copy 
    jsr bram_heap_set_free
    // bram_heap_coalesce::@return
    // }
    // [359] return 
    rts
}
  // heap_can_coalesce_right
/**
 * Whether we should merge this header to the right.
 */
// __zp($1a) char heap_can_coalesce_right(__zp($1c) char s, __zp(9) char heap_index)
heap_can_coalesce_right: {
    .label s = $1c
    .label heap_index = 9
    .label heap_offset = 4
    .label right_index = $1a
    .label right_offset = $33
    // A free_index is not found, we cannot coalesce.
    .label return = $1a
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [360] bram_heap_get_data_packed::s#5 = heap_can_coalesce_right::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [361] bram_heap_get_data_packed::index#5 = heap_can_coalesce_right::heap_index#0 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [362] call bram_heap_get_data_packed
    // [225] phi from heap_can_coalesce_right to bram_heap_get_data_packed [phi:heap_can_coalesce_right->bram_heap_get_data_packed]
    // [225] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#5 [phi:heap_can_coalesce_right->bram_heap_get_data_packed#0] -- register_copy 
    // [225] phi bram_heap_get_data_packed::s#8 = bram_heap_get_data_packed::s#5 [phi:heap_can_coalesce_right->bram_heap_get_data_packed#1] -- register_copy 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [363] bram_heap_get_data_packed::return#16 = bram_heap_get_data_packed::return#1 -- vwuz1=vwuz2 
    lda.z bram_heap_get_data_packed.return
    sta.z bram_heap_get_data_packed.return_4
    lda.z bram_heap_get_data_packed.return+1
    sta.z bram_heap_get_data_packed.return_4+1
    // heap_can_coalesce_right::@2
    // [364] heap_can_coalesce_right::heap_offset#0 = bram_heap_get_data_packed::return#16
    // bram_heap_index_t right_index = bram_heap_get_right(s, heap_index)
    // [365] bram_heap_get_right::s#1 = heap_can_coalesce_right::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [366] bram_heap_get_right::index#1 = heap_can_coalesce_right::heap_index#0 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [367] call bram_heap_get_right
    // [596] phi from heap_can_coalesce_right::@2 to bram_heap_get_right [phi:heap_can_coalesce_right::@2->bram_heap_get_right]
    // [596] phi bram_heap_get_right::index#3 = bram_heap_get_right::index#1 [phi:heap_can_coalesce_right::@2->bram_heap_get_right#0] -- register_copy 
    // [596] phi bram_heap_get_right::s#3 = bram_heap_get_right::s#1 [phi:heap_can_coalesce_right::@2->bram_heap_get_right#1] -- register_copy 
    jsr bram_heap_get_right
    // bram_heap_index_t right_index = bram_heap_get_right(s, heap_index)
    // [368] bram_heap_get_right::return#3 = bram_heap_get_right::return#0
    // heap_can_coalesce_right::@3
    // [369] heap_can_coalesce_right::right_index#0 = bram_heap_get_right::return#3 -- vbuz1=vbuaa 
    sta.z right_index
    // bram_heap_data_packed_t right_offset = bram_heap_get_data_packed(s, right_index)
    // [370] bram_heap_get_data_packed::s#6 = heap_can_coalesce_right::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [371] bram_heap_get_data_packed::index#6 = heap_can_coalesce_right::right_index#0 -- vbuxx=vbuz1 
    ldx.z right_index
    // [372] call bram_heap_get_data_packed
    // [225] phi from heap_can_coalesce_right::@3 to bram_heap_get_data_packed [phi:heap_can_coalesce_right::@3->bram_heap_get_data_packed]
    // [225] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#6 [phi:heap_can_coalesce_right::@3->bram_heap_get_data_packed#0] -- register_copy 
    // [225] phi bram_heap_get_data_packed::s#8 = bram_heap_get_data_packed::s#6 [phi:heap_can_coalesce_right::@3->bram_heap_get_data_packed#1] -- register_copy 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t right_offset = bram_heap_get_data_packed(s, right_index)
    // [373] bram_heap_get_data_packed::return#17 = bram_heap_get_data_packed::return#1 -- vwuz1=vwuz2 
    lda.z bram_heap_get_data_packed.return
    sta.z bram_heap_get_data_packed.return_5
    lda.z bram_heap_get_data_packed.return+1
    sta.z bram_heap_get_data_packed.return_5+1
    // heap_can_coalesce_right::@4
    // [374] heap_can_coalesce_right::right_offset#0 = bram_heap_get_data_packed::return#17
    // bool right_free = bram_heap_is_free(s, right_index)
    // [375] bram_heap_is_free::s#1 = heap_can_coalesce_right::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [376] bram_heap_is_free::index#1 = heap_can_coalesce_right::right_index#0 -- vbuxx=vbuz1 
    ldx.z right_index
    // [377] call bram_heap_is_free
    // [588] phi from heap_can_coalesce_right::@4 to bram_heap_is_free [phi:heap_can_coalesce_right::@4->bram_heap_is_free]
    // [588] phi bram_heap_is_free::index#2 = bram_heap_is_free::index#1 [phi:heap_can_coalesce_right::@4->bram_heap_is_free#0] -- register_copy 
    // [588] phi bram_heap_is_free::s#2 = bram_heap_is_free::s#1 [phi:heap_can_coalesce_right::@4->bram_heap_is_free#1] -- register_copy 
    jsr bram_heap_is_free
    // bool right_free = bram_heap_is_free(s, right_index)
    // [378] bram_heap_is_free::return#3 = bram_heap_is_free::return#0
    // heap_can_coalesce_right::@5
    // [379] heap_can_coalesce_right::right_free#0 = bram_heap_is_free::return#3
    // if(right_free && (heap_offset < right_offset))
    // [380] if(heap_can_coalesce_right::right_free#0) goto heap_can_coalesce_right::@6 -- vboaa_then_la1 
    cmp #0
    bne __b6
    // [383] phi from heap_can_coalesce_right::@5 heap_can_coalesce_right::@6 to heap_can_coalesce_right::@return [phi:heap_can_coalesce_right::@5/heap_can_coalesce_right::@6->heap_can_coalesce_right::@return]
  __b2:
    // [383] phi heap_can_coalesce_right::return#3 = $ff [phi:heap_can_coalesce_right::@5/heap_can_coalesce_right::@6->heap_can_coalesce_right::@return#0] -- vbuz1=vbuc1 
    lda #$ff
    sta.z return
    rts
    // heap_can_coalesce_right::@6
  __b6:
    // if(right_free && (heap_offset < right_offset))
    // [381] if(heap_can_coalesce_right::heap_offset#0<heap_can_coalesce_right::right_offset#0) goto heap_can_coalesce_right::@1 -- vwuz1_lt_vwuz2_then_la1 
    lda.z heap_offset+1
    cmp.z right_offset+1
    bcc __b1
    bne !+
    lda.z heap_offset
    cmp.z right_offset
    bcc __b1
  !:
    jmp __b2
    // [382] phi from heap_can_coalesce_right::@6 to heap_can_coalesce_right::@1 [phi:heap_can_coalesce_right::@6->heap_can_coalesce_right::@1]
    // heap_can_coalesce_right::@1
  __b1:
    // [383] phi from heap_can_coalesce_right::@1 to heap_can_coalesce_right::@return [phi:heap_can_coalesce_right::@1->heap_can_coalesce_right::@return]
    // [383] phi heap_can_coalesce_right::return#3 = heap_can_coalesce_right::right_index#0 [phi:heap_can_coalesce_right::@1->heap_can_coalesce_right::@return#0] -- register_copy 
    // heap_can_coalesce_right::@return
    // }
    // [384] return 
    rts
}
  // bram_heap_alloc_size_get
/**
 * Returns total allocation size, aligned to 8;
 */
/* inline */
// __zp($20) unsigned int bram_heap_alloc_size_get(__zp($28) unsigned long size)
bram_heap_alloc_size_get: {
    .label bram_heap_alloc_size_get__1 = $20
    .label size = $28
    .label return = $20
    // bram_heap_size_pack(size-1)
    // [385] bram_heap_size_pack::size#0 = bram_heap_alloc_size_get::size#0 - 1 -- vduz1=vduz1_minus_1 
    sec
    lda.z bram_heap_size_pack.size
    sbc #1
    sta.z bram_heap_size_pack.size
    lda.z bram_heap_size_pack.size+1
    sbc #0
    sta.z bram_heap_size_pack.size+1
    lda.z bram_heap_size_pack.size+2
    sbc #0
    sta.z bram_heap_size_pack.size+2
    lda.z bram_heap_size_pack.size+3
    sbc #0
    sta.z bram_heap_size_pack.size+3
    // [386] call bram_heap_size_pack
    jsr bram_heap_size_pack
    // [387] bram_heap_size_pack::return#2 = bram_heap_size_pack::return#0
    // bram_heap_alloc_size_get::@1
    // [388] bram_heap_alloc_size_get::$1 = bram_heap_size_pack::return#2
    // return (bram_heap_size_packed_t)((bram_heap_size_pack(size-1) + 1));
    // [389] bram_heap_alloc_size_get::return#1 = bram_heap_alloc_size_get::$1 + 1 -- vwuz1=vwuz1_plus_1 
    inc.z return
    bne !+
    inc.z return+1
  !:
    // bram_heap_alloc_size_get::@return
    // }
    // [390] return 
    rts
}
  // bram_heap_find_best_fit
/**
 * Best-fit algorithm.
 */
// __zp($1a) char bram_heap_find_best_fit(__zp(8) char s, __zp($12) unsigned int requested_size)
bram_heap_find_best_fit: {
    .label s = 8
    .label requested_size = $12
    .label free_index = $1e
    .label free_end = $22
    .label return = $1a
    .label free_size = $18
    .label best_size = $26
    .label best_size_1 = $18
    .label best_index = $1a
    // bram_heap_index_t free_index = bram_heap_segment.free_list[s]
    // [391] bram_heap_find_best_fit::free_index#0 = ((char *)&bram_heap_segment+$19)[bram_heap_find_best_fit::s#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda bram_heap_segment+$19,y
    sta.z free_index
    // if(free_index == BRAM_HEAP_NULL)
    // [392] if(bram_heap_find_best_fit::free_index#0!=$ff) goto bram_heap_find_best_fit::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #$ff
    cmp.z free_index
    bne __b1
    // [393] phi from bram_heap_find_best_fit bram_heap_find_best_fit::@2 to bram_heap_find_best_fit::@return [phi:bram_heap_find_best_fit/bram_heap_find_best_fit::@2->bram_heap_find_best_fit::@return]
  __b5:
    // [393] phi bram_heap_find_best_fit::return#2 = $ff [phi:bram_heap_find_best_fit/bram_heap_find_best_fit::@2->bram_heap_find_best_fit::@return#0] -- vbuz1=vbuc1 
    lda #$ff
    sta.z return
    // bram_heap_find_best_fit::@return
    // }
    // [394] return 
    rts
    // bram_heap_find_best_fit::@1
  __b1:
    // bram_heap_index_t free_end = bram_heap_segment.free_list[s]
    // [395] bram_heap_find_best_fit::free_end#0 = ((char *)&bram_heap_segment+$19)[bram_heap_find_best_fit::s#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda bram_heap_segment+$19,y
    sta.z free_end
    // [396] phi from bram_heap_find_best_fit::@1 to bram_heap_find_best_fit::@3 [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@3]
    // [396] phi bram_heap_find_best_fit::best_index#6 = $ff [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@3#0] -- vbuz1=vbuc1 
    lda #$ff
    sta.z best_index
    // [396] phi bram_heap_find_best_fit::best_size#2 = $ffff [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@3#1] -- vwuz1=vwuc1 
    lda #<$ffff
    sta.z best_size
    lda #>$ffff
    sta.z best_size+1
    // [396] phi bram_heap_find_best_fit::free_index#2 = bram_heap_find_best_fit::free_index#0 [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@3#2] -- register_copy 
    // bram_heap_find_best_fit::@3
  __b3:
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [397] bram_heap_get_size_packed::s#5 = bram_heap_find_best_fit::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [398] bram_heap_get_size_packed::index#5 = bram_heap_find_best_fit::free_index#2 -- vbuxx=vbuz1 
    ldx.z free_index
    // [399] call bram_heap_get_size_packed
  // O(n) search.
    // [214] phi from bram_heap_find_best_fit::@3 to bram_heap_get_size_packed [phi:bram_heap_find_best_fit::@3->bram_heap_get_size_packed]
    // [214] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#5 [phi:bram_heap_find_best_fit::@3->bram_heap_get_size_packed#0] -- register_copy 
    // [214] phi bram_heap_get_size_packed::s#8 = bram_heap_get_size_packed::s#5 [phi:bram_heap_find_best_fit::@3->bram_heap_get_size_packed#1] -- register_copy 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [400] bram_heap_get_size_packed::return#15 = bram_heap_get_size_packed::return#12
    // bram_heap_find_best_fit::@7
    // [401] bram_heap_find_best_fit::free_size#0 = bram_heap_get_size_packed::return#15
    // if(free_size >= requested_size && free_size < best_size)
    // [402] if(bram_heap_find_best_fit::free_size#0<bram_heap_find_best_fit::requested_size#0) goto bram_heap_find_best_fit::@11 -- vwuz1_lt_vwuz2_then_la1 
    lda.z free_size+1
    cmp.z requested_size+1
    bcc __b11
    bne !+
    lda.z free_size
    cmp.z requested_size
    bcc __b11
  !:
    // bram_heap_find_best_fit::@9
    // [403] if(bram_heap_find_best_fit::free_size#0>=bram_heap_find_best_fit::best_size#2) goto bram_heap_find_best_fit::@4 -- vwuz1_ge_vwuz2_then_la1 
    lda.z best_size+1
    cmp.z free_size+1
    bne !+
    lda.z best_size
    cmp.z free_size
    beq __b4
  !:
    bcc __b4
    // bram_heap_find_best_fit::@5
    // [404] bram_heap_find_best_fit::best_index#9 = bram_heap_find_best_fit::free_index#2 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z best_index
    // [405] phi from bram_heap_find_best_fit::@11 bram_heap_find_best_fit::@5 to bram_heap_find_best_fit::@4 [phi:bram_heap_find_best_fit::@11/bram_heap_find_best_fit::@5->bram_heap_find_best_fit::@4]
    // [405] phi bram_heap_find_best_fit::best_index#2 = bram_heap_find_best_fit::best_index#6 [phi:bram_heap_find_best_fit::@11/bram_heap_find_best_fit::@5->bram_heap_find_best_fit::@4#0] -- register_copy 
    // [405] phi bram_heap_find_best_fit::best_size#3 = bram_heap_find_best_fit::best_size#9 [phi:bram_heap_find_best_fit::@11/bram_heap_find_best_fit::@5->bram_heap_find_best_fit::@4#1] -- register_copy 
    // [405] phi from bram_heap_find_best_fit::@9 to bram_heap_find_best_fit::@4 [phi:bram_heap_find_best_fit::@9->bram_heap_find_best_fit::@4]
    // bram_heap_find_best_fit::@4
  __b4:
    // bram_heap_get_next(s, free_index)
    // [406] bram_heap_get_next::s#3 = bram_heap_find_best_fit::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [407] bram_heap_get_next::index#3 = bram_heap_find_best_fit::free_index#2 -- vbuxx=vbuz1 
    ldx.z free_index
    // [408] call bram_heap_get_next
    // [651] phi from bram_heap_find_best_fit::@4 to bram_heap_get_next [phi:bram_heap_find_best_fit::@4->bram_heap_get_next]
    // [651] phi bram_heap_get_next::index#4 = bram_heap_get_next::index#3 [phi:bram_heap_find_best_fit::@4->bram_heap_get_next#0] -- register_copy 
    // [651] phi bram_heap_get_next::s#4 = bram_heap_get_next::s#3 [phi:bram_heap_find_best_fit::@4->bram_heap_get_next#1] -- register_copy 
    jsr bram_heap_get_next
    // bram_heap_get_next(s, free_index)
    // [409] bram_heap_get_next::return#10 = bram_heap_get_next::return#3
    // bram_heap_find_best_fit::@8
    // free_index = bram_heap_get_next(s, free_index)
    // [410] bram_heap_find_best_fit::free_index#1 = bram_heap_get_next::return#10 -- vbuz1=vbuaa 
    sta.z free_index
    // while(free_index != free_end)
    // [411] if(bram_heap_find_best_fit::free_index#1!=bram_heap_find_best_fit::free_end#0) goto bram_heap_find_best_fit::@10 -- vbuz1_neq_vbuz2_then_la1 
    cmp.z free_end
    bne __b10
    // bram_heap_find_best_fit::@6
    // if(requested_size <= best_size)
    // [412] if(bram_heap_find_best_fit::requested_size#0>bram_heap_find_best_fit::best_size#3) goto bram_heap_find_best_fit::@2 -- vwuz1_gt_vwuz2_then_la1 
    lda.z best_size_1+1
    cmp.z requested_size+1
    bcc __b5
    bne !+
    lda.z best_size_1
    cmp.z requested_size
    bcc __b5
  !:
    // [393] phi from bram_heap_find_best_fit::@6 to bram_heap_find_best_fit::@return [phi:bram_heap_find_best_fit::@6->bram_heap_find_best_fit::@return]
    // [393] phi bram_heap_find_best_fit::return#2 = bram_heap_find_best_fit::best_index#2 [phi:bram_heap_find_best_fit::@6->bram_heap_find_best_fit::@return#0] -- register_copy 
    rts
    // [413] phi from bram_heap_find_best_fit::@6 to bram_heap_find_best_fit::@2 [phi:bram_heap_find_best_fit::@6->bram_heap_find_best_fit::@2]
    // bram_heap_find_best_fit::@2
    // bram_heap_find_best_fit::@10
  __b10:
    // [414] bram_heap_find_best_fit::best_size#7 = bram_heap_find_best_fit::best_size#3 -- vwuz1=vwuz2 
    lda.z best_size_1
    sta.z best_size
    lda.z best_size_1+1
    sta.z best_size+1
    // [396] phi from bram_heap_find_best_fit::@10 to bram_heap_find_best_fit::@3 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@3]
    // [396] phi bram_heap_find_best_fit::best_index#6 = bram_heap_find_best_fit::best_index#2 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@3#0] -- register_copy 
    // [396] phi bram_heap_find_best_fit::best_size#2 = bram_heap_find_best_fit::best_size#7 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@3#1] -- register_copy 
    // [396] phi bram_heap_find_best_fit::free_index#2 = bram_heap_find_best_fit::free_index#1 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@3#2] -- register_copy 
    jmp __b3
    // bram_heap_find_best_fit::@11
  __b11:
    // [415] bram_heap_find_best_fit::best_size#9 = bram_heap_find_best_fit::best_size#2 -- vwuz1=vwuz2 
    lda.z best_size
    sta.z best_size_1
    lda.z best_size+1
    sta.z best_size_1+1
    jmp __b4
}
  // bram_heap_allocate
/**
 * Allocates a header from the list, splitting if needed.
 */
// __register(A) char bram_heap_allocate(__zp($f) char s, __zp($e) char free_index, __zp($30) unsigned int required_size)
bram_heap_allocate: {
    .label s = $f
    .label free_index = $e
    .label required_size = $30
    .label free_size = $18
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [416] bram_heap_get_size_packed::s#4 = bram_heap_allocate::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [417] bram_heap_get_size_packed::index#4 = bram_heap_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [418] call bram_heap_get_size_packed
    // [214] phi from bram_heap_allocate to bram_heap_get_size_packed [phi:bram_heap_allocate->bram_heap_get_size_packed]
    // [214] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#4 [phi:bram_heap_allocate->bram_heap_get_size_packed#0] -- register_copy 
    // [214] phi bram_heap_get_size_packed::s#8 = bram_heap_get_size_packed::s#4 [phi:bram_heap_allocate->bram_heap_get_size_packed#1] -- register_copy 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [419] bram_heap_get_size_packed::return#14 = bram_heap_get_size_packed::return#12
    // bram_heap_allocate::@4
    // [420] bram_heap_allocate::free_size#0 = bram_heap_get_size_packed::return#14
    // if(free_size > required_size)
    // [421] if(bram_heap_allocate::free_size#0>bram_heap_allocate::required_size#0) goto bram_heap_allocate::@1 -- vwuz1_gt_vwuz2_then_la1 
    lda.z required_size+1
    cmp.z free_size+1
    bcc __b1
    bne !+
    lda.z required_size
    cmp.z free_size
    bcc __b1
  !:
    // bram_heap_allocate::@2
    // if(free_size == required_size)
    // [422] if(bram_heap_allocate::free_size#0==bram_heap_allocate::required_size#0) goto bram_heap_allocate::@3 -- vwuz1_eq_vwuz2_then_la1 
    lda.z free_size
    cmp.z required_size
    bne !+
    lda.z free_size+1
    cmp.z required_size+1
    beq __b3
  !:
    // [423] phi from bram_heap_allocate::@2 to bram_heap_allocate::@return [phi:bram_heap_allocate::@2->bram_heap_allocate::@return]
    // [423] phi bram_heap_allocate::return#4 = $ff [phi:bram_heap_allocate::@2->bram_heap_allocate::@return#0] -- vbuaa=vbuc1 
    lda #$ff
    // bram_heap_allocate::@return
    // }
    // [424] return 
    rts
    // bram_heap_allocate::@3
  __b3:
    // bram_heap_replace_free_with_heap(s, free_index, required_size)
    // [425] bram_heap_replace_free_with_heap::s#0 = bram_heap_allocate::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_replace_free_with_heap.s
    // [426] bram_heap_replace_free_with_heap::return#2 = bram_heap_allocate::free_index#0 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_replace_free_with_heap.return
    // [427] bram_heap_replace_free_with_heap::required_size#0 = bram_heap_allocate::required_size#0 -- vwuz1=vwuz2 
    lda.z required_size
    sta.z bram_heap_replace_free_with_heap.required_size
    lda.z required_size+1
    sta.z bram_heap_replace_free_with_heap.required_size+1
    // [428] call bram_heap_replace_free_with_heap
    jsr bram_heap_replace_free_with_heap
    // bram_heap_allocate::@6
    // return bram_heap_replace_free_with_heap(s, free_index, required_size);
    // [429] bram_heap_allocate::return#2 = bram_heap_replace_free_with_heap::return#2 -- vbuaa=vbuz1 
    lda.z bram_heap_replace_free_with_heap.return
    // [423] phi from bram_heap_allocate::@5 bram_heap_allocate::@6 to bram_heap_allocate::@return [phi:bram_heap_allocate::@5/bram_heap_allocate::@6->bram_heap_allocate::@return]
    // [423] phi bram_heap_allocate::return#4 = bram_heap_allocate::return#1 [phi:bram_heap_allocate::@5/bram_heap_allocate::@6->bram_heap_allocate::@return#0] -- register_copy 
    rts
    // bram_heap_allocate::@1
  __b1:
    // bram_heap_split_free_and_allocate(s, free_index, required_size)
    // [430] bram_heap_split_free_and_allocate::s#0 = bram_heap_allocate::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_split_free_and_allocate.s
    // [431] bram_heap_split_free_and_allocate::free_index#0 = bram_heap_allocate::free_index#0 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_split_free_and_allocate.free_index
    // [432] bram_heap_split_free_and_allocate::required_size#0 = bram_heap_allocate::required_size#0 -- vwuz1=vwuz2 
    lda.z required_size
    sta.z bram_heap_split_free_and_allocate.required_size
    lda.z required_size+1
    sta.z bram_heap_split_free_and_allocate.required_size+1
    // [433] call bram_heap_split_free_and_allocate
    jsr bram_heap_split_free_and_allocate
    // [434] bram_heap_split_free_and_allocate::return#2 = bram_heap_split_free_and_allocate::heap_index#0 -- vbuaa=vbuz1 
    lda.z bram_heap_split_free_and_allocate.heap_index
    // bram_heap_allocate::@5
    // return bram_heap_split_free_and_allocate(s, free_index, required_size);
    // [435] bram_heap_allocate::return#1 = bram_heap_split_free_and_allocate::return#2
    rts
}
  // bram_heap_data_pack
// __zp($36) unsigned int bram_heap_data_pack(__register(X) char bram_bank, __zp($26) char *bram_ptr)
bram_heap_data_pack: {
    .label bram_heap_data_pack__0 = $36
    .label bram_heap_data_pack__1 = $26
    .label bram_heap_data_pack__2 = $26
    .label bram_ptr = $26
    .label return = $36
    // MAKEWORD(bram_bank, 0)
    // [437] bram_heap_data_pack::$0 = bram_heap_data_pack::bram_bank#2 w= 0 -- vwuz1=vbuxx_word_vbuc1 
    lda #0
    stx.z bram_heap_data_pack__0+1
    sta.z bram_heap_data_pack__0
    // (unsigned int)bram_ptr & 0x1FFF
    // [438] bram_heap_data_pack::$1 = (unsigned int)bram_heap_data_pack::bram_ptr#2 & $1fff -- vwuz1=vwuz1_band_vwuc1 
    lda.z bram_heap_data_pack__1
    and #<$1fff
    sta.z bram_heap_data_pack__1
    lda.z bram_heap_data_pack__1+1
    and #>$1fff
    sta.z bram_heap_data_pack__1+1
    // ((unsigned int)bram_ptr & 0x1FFF ) >> 5
    // [439] bram_heap_data_pack::$2 = bram_heap_data_pack::$1 >> 5 -- vwuz1=vwuz1_ror_5 
    lsr.z bram_heap_data_pack__2+1
    ror.z bram_heap_data_pack__2
    lsr.z bram_heap_data_pack__2+1
    ror.z bram_heap_data_pack__2
    lsr.z bram_heap_data_pack__2+1
    ror.z bram_heap_data_pack__2
    lsr.z bram_heap_data_pack__2+1
    ror.z bram_heap_data_pack__2
    lsr.z bram_heap_data_pack__2+1
    ror.z bram_heap_data_pack__2
    // MAKEWORD(bram_bank, 0) | (((unsigned int)bram_ptr & 0x1FFF ) >> 5)
    // [440] bram_heap_data_pack::return#2 = bram_heap_data_pack::$0 | bram_heap_data_pack::$2 -- vwuz1=vwuz1_bor_vwuz2 
    lda.z return
    ora.z bram_heap_data_pack__2
    sta.z return
    lda.z return+1
    ora.z bram_heap_data_pack__2+1
    sta.z return+1
    // bram_heap_data_pack::@return
    // }
    // [441] return 
    rts
}
  // bram_heap_index_add
// __register(A) char bram_heap_index_add(__register(X) char s)
bram_heap_index_add: {
    .label index = $1e
    .label return = $1e
    // bram_heap_index_t index = bram_heap_segment.idle_list[s]
    // [443] bram_heap_index_add::index#0 = ((char *)&bram_heap_segment+$1b)[bram_heap_index_add::s#2] -- vbuz1=pbuc1_derefidx_vbuxx 
    // TODO: Search idle list.
    lda bram_heap_segment+$1b,x
    sta.z index
    // if(index != BRAM_HEAP_NULL)
    // [444] if(bram_heap_index_add::index#0!=$ff) goto bram_heap_index_add::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #$ff
    cmp.z index
    bne __b1
    // bram_heap_index_add::@3
    // index = bram_heap_segment.index_position[s]
    // [445] bram_heap_index_add::index#1 = ((char *)&bram_heap_segment+1)[bram_heap_index_add::s#2] -- vbuz1=pbuc1_derefidx_vbuxx 
    // The current header gets the current heap position handle.
    lda bram_heap_segment+1,x
    sta.z index
    // bram_heap_segment.index_position[s] + 1
    // [446] bram_heap_index_add::$1 = ((char *)&bram_heap_segment+1)[bram_heap_index_add::s#2] + 1 -- vbuaa=pbuc1_derefidx_vbuxx_plus_1 
    lda bram_heap_segment+1,x
    inc
    // bram_heap_segment.index_position[s] = bram_heap_segment.index_position[s] + 1
    // [447] ((char *)&bram_heap_segment+1)[bram_heap_index_add::s#2] = bram_heap_index_add::$1 -- pbuc1_derefidx_vbuxx=vbuaa 
    // We adjust to the next index position.
    sta bram_heap_segment+1,x
    // [448] phi from bram_heap_index_add::@1 bram_heap_index_add::@3 to bram_heap_index_add::@2 [phi:bram_heap_index_add::@1/bram_heap_index_add::@3->bram_heap_index_add::@2]
    // [448] phi bram_heap_index_add::return#1 = bram_heap_index_add::index#0 [phi:bram_heap_index_add::@1/bram_heap_index_add::@3->bram_heap_index_add::@2#0] -- register_copy 
    // bram_heap_index_add::@2
    // bram_heap_index_add::@return
    // }
    // [449] return 
    rts
    // bram_heap_index_add::@1
  __b1:
    // heap_idle_remove(s, index)
    // [450] heap_idle_remove::s#0 = bram_heap_index_add::s#2 -- vbuz1=vbuxx 
    stx.z heap_idle_remove.s
    // [451] heap_idle_remove::idle_index#0 = bram_heap_index_add::index#0 -- vbuz1=vbuz2 
    lda.z index
    sta.z heap_idle_remove.idle_index
    // [452] call heap_idle_remove
    jsr heap_idle_remove
    rts
}
  // bram_heap_list_insert_at
/**
* Insert index in list at sorted position.
*/
// __register(A) char bram_heap_list_insert_at(__zp($1d) char s, __zp($10) char list, __zp($1a) char index, __zp($11) char at)
bram_heap_list_insert_at: {
    .label s = $1d
    .label list = $10
    .label index = $1a
    .label at = $11
    .label last = 9
    .label first = $11
    // if(list == BRAM_HEAP_NULL)
    // [454] if(bram_heap_list_insert_at::list#5!=$ff) goto bram_heap_list_insert_at::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #$ff
    cmp.z list
    bne __b1
    // bram_heap_list_insert_at::@3
    // bram_heap_set_prev(s, index, index)
    // [455] bram_heap_set_prev::s#3 = bram_heap_list_insert_at::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [456] bram_heap_set_prev::index#3 = bram_heap_list_insert_at::index#10 -- vbuz1=vbuz2 
    lda.z index
    sta.z bram_heap_set_prev.index
    // [457] bram_heap_set_prev::prev#3 = bram_heap_list_insert_at::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [458] call bram_heap_set_prev
    // [527] phi from bram_heap_list_insert_at::@3 to bram_heap_set_prev [phi:bram_heap_list_insert_at::@3->bram_heap_set_prev]
    // [527] phi bram_heap_set_prev::index#6 = bram_heap_set_prev::index#3 [phi:bram_heap_list_insert_at::@3->bram_heap_set_prev#0] -- register_copy 
    // [527] phi bram_heap_set_prev::prev#6 = bram_heap_set_prev::prev#3 [phi:bram_heap_list_insert_at::@3->bram_heap_set_prev#1] -- register_copy 
    // [527] phi bram_heap_set_prev::s#6 = bram_heap_set_prev::s#3 [phi:bram_heap_list_insert_at::@3->bram_heap_set_prev#2] -- register_copy 
    jsr bram_heap_set_prev
    // bram_heap_list_insert_at::@5
    // bram_heap_set_next(s, index, index)
    // [459] bram_heap_set_next::s#3 = bram_heap_list_insert_at::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [460] bram_heap_set_next::index#3 = bram_heap_list_insert_at::index#10 -- vbuz1=vbuz2 
    lda.z index
    sta.z bram_heap_set_next.index
    // [461] bram_heap_set_next::next#3 = bram_heap_list_insert_at::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [462] call bram_heap_set_next
    // [520] phi from bram_heap_list_insert_at::@5 to bram_heap_set_next [phi:bram_heap_list_insert_at::@5->bram_heap_set_next]
    // [520] phi bram_heap_set_next::index#6 = bram_heap_set_next::index#3 [phi:bram_heap_list_insert_at::@5->bram_heap_set_next#0] -- register_copy 
    // [520] phi bram_heap_set_next::next#6 = bram_heap_set_next::next#3 [phi:bram_heap_list_insert_at::@5->bram_heap_set_next#1] -- register_copy 
    // [520] phi bram_heap_set_next::s#6 = bram_heap_set_next::s#3 [phi:bram_heap_list_insert_at::@5->bram_heap_set_next#2] -- register_copy 
    jsr bram_heap_set_next
    // bram_heap_list_insert_at::@6
    // [463] bram_heap_list_insert_at::list#21 = bram_heap_list_insert_at::index#10 -- vbuz1=vbuz2 
    lda.z index
    sta.z list
    // [464] phi from bram_heap_list_insert_at bram_heap_list_insert_at::@6 to bram_heap_list_insert_at::@1 [phi:bram_heap_list_insert_at/bram_heap_list_insert_at::@6->bram_heap_list_insert_at::@1]
    // [464] phi bram_heap_list_insert_at::list#11 = bram_heap_list_insert_at::list#5 [phi:bram_heap_list_insert_at/bram_heap_list_insert_at::@6->bram_heap_list_insert_at::@1#0] -- register_copy 
    // bram_heap_list_insert_at::@1
  __b1:
    // if(at == BRAM_HEAP_NULL)
    // [465] if(bram_heap_list_insert_at::at#10!=$ff) goto bram_heap_list_insert_at::@2 -- vbuz1_neq_vbuc1_then_la1 
    lda #$ff
    cmp.z at
    bne __b2
    // bram_heap_list_insert_at::@4
    // [466] bram_heap_list_insert_at::first#5 = bram_heap_list_insert_at::list#11 -- vbuz1=vbuz2 
    lda.z list
    sta.z first
    // [467] phi from bram_heap_list_insert_at::@1 bram_heap_list_insert_at::@4 to bram_heap_list_insert_at::@2 [phi:bram_heap_list_insert_at::@1/bram_heap_list_insert_at::@4->bram_heap_list_insert_at::@2]
    // [467] phi bram_heap_list_insert_at::first#0 = bram_heap_list_insert_at::at#10 [phi:bram_heap_list_insert_at::@1/bram_heap_list_insert_at::@4->bram_heap_list_insert_at::@2#0] -- register_copy 
    // bram_heap_list_insert_at::@2
  __b2:
    // bram_heap_index_t last = bram_heap_get_prev(s, at)
    // [468] bram_heap_get_prev::s#1 = bram_heap_list_insert_at::s#10 -- vbuaa=vbuz1 
    lda.z s
    // [469] bram_heap_get_prev::index#1 = bram_heap_list_insert_at::first#0 -- vbuxx=vbuz1 
    ldx.z first
    // [470] call bram_heap_get_prev
    // [764] phi from bram_heap_list_insert_at::@2 to bram_heap_get_prev [phi:bram_heap_list_insert_at::@2->bram_heap_get_prev]
    // [764] phi bram_heap_get_prev::index#2 = bram_heap_get_prev::index#1 [phi:bram_heap_list_insert_at::@2->bram_heap_get_prev#0] -- register_copy 
    // [764] phi bram_heap_get_prev::s#2 = bram_heap_get_prev::s#1 [phi:bram_heap_list_insert_at::@2->bram_heap_get_prev#1] -- register_copy 
    jsr bram_heap_get_prev
    // bram_heap_index_t last = bram_heap_get_prev(s, at)
    // [471] bram_heap_get_prev::return#3 = bram_heap_get_prev::return#1
    // bram_heap_list_insert_at::@7
    // [472] bram_heap_list_insert_at::last#0 = bram_heap_get_prev::return#3 -- vbuz1=vbuaa 
    sta.z last
    // bram_heap_set_prev(s, index, last)
    // [473] bram_heap_set_prev::s#4 = bram_heap_list_insert_at::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [474] bram_heap_set_prev::index#4 = bram_heap_list_insert_at::index#10 -- vbuz1=vbuz2 
    lda.z index
    sta.z bram_heap_set_prev.index
    // [475] bram_heap_set_prev::prev#4 = bram_heap_list_insert_at::last#0 -- vbuxx=vbuz1 
    ldx.z last
    // [476] call bram_heap_set_prev
  // Add index to list at last position.
    // [527] phi from bram_heap_list_insert_at::@7 to bram_heap_set_prev [phi:bram_heap_list_insert_at::@7->bram_heap_set_prev]
    // [527] phi bram_heap_set_prev::index#6 = bram_heap_set_prev::index#4 [phi:bram_heap_list_insert_at::@7->bram_heap_set_prev#0] -- register_copy 
    // [527] phi bram_heap_set_prev::prev#6 = bram_heap_set_prev::prev#4 [phi:bram_heap_list_insert_at::@7->bram_heap_set_prev#1] -- register_copy 
    // [527] phi bram_heap_set_prev::s#6 = bram_heap_set_prev::s#4 [phi:bram_heap_list_insert_at::@7->bram_heap_set_prev#2] -- register_copy 
    jsr bram_heap_set_prev
    // bram_heap_list_insert_at::@8
    // bram_heap_set_next(s, last, index)
    // [477] bram_heap_set_next::s#4 = bram_heap_list_insert_at::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [478] bram_heap_set_next::index#4 = bram_heap_list_insert_at::last#0
    // [479] bram_heap_set_next::next#4 = bram_heap_list_insert_at::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [480] call bram_heap_set_next
    // [520] phi from bram_heap_list_insert_at::@8 to bram_heap_set_next [phi:bram_heap_list_insert_at::@8->bram_heap_set_next]
    // [520] phi bram_heap_set_next::index#6 = bram_heap_set_next::index#4 [phi:bram_heap_list_insert_at::@8->bram_heap_set_next#0] -- register_copy 
    // [520] phi bram_heap_set_next::next#6 = bram_heap_set_next::next#4 [phi:bram_heap_list_insert_at::@8->bram_heap_set_next#1] -- register_copy 
    // [520] phi bram_heap_set_next::s#6 = bram_heap_set_next::s#4 [phi:bram_heap_list_insert_at::@8->bram_heap_set_next#2] -- register_copy 
    jsr bram_heap_set_next
    // bram_heap_list_insert_at::@9
    // bram_heap_set_next(s, index, first)
    // [481] bram_heap_set_next::s#5 = bram_heap_list_insert_at::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [482] bram_heap_set_next::index#5 = bram_heap_list_insert_at::index#10 -- vbuz1=vbuz2 
    lda.z index
    sta.z bram_heap_set_next.index
    // [483] bram_heap_set_next::next#5 = bram_heap_list_insert_at::first#0 -- vbuxx=vbuz1 
    ldx.z first
    // [484] call bram_heap_set_next
    // [520] phi from bram_heap_list_insert_at::@9 to bram_heap_set_next [phi:bram_heap_list_insert_at::@9->bram_heap_set_next]
    // [520] phi bram_heap_set_next::index#6 = bram_heap_set_next::index#5 [phi:bram_heap_list_insert_at::@9->bram_heap_set_next#0] -- register_copy 
    // [520] phi bram_heap_set_next::next#6 = bram_heap_set_next::next#5 [phi:bram_heap_list_insert_at::@9->bram_heap_set_next#1] -- register_copy 
    // [520] phi bram_heap_set_next::s#6 = bram_heap_set_next::s#5 [phi:bram_heap_list_insert_at::@9->bram_heap_set_next#2] -- register_copy 
    jsr bram_heap_set_next
    // bram_heap_list_insert_at::@10
    // bram_heap_set_prev(s, first, index)
    // [485] bram_heap_set_prev::s#5 = bram_heap_list_insert_at::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [486] bram_heap_set_prev::index#5 = bram_heap_list_insert_at::first#0 -- vbuz1=vbuz2 
    lda.z first
    sta.z bram_heap_set_prev.index
    // [487] bram_heap_set_prev::prev#5 = bram_heap_list_insert_at::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [488] call bram_heap_set_prev
    // [527] phi from bram_heap_list_insert_at::@10 to bram_heap_set_prev [phi:bram_heap_list_insert_at::@10->bram_heap_set_prev]
    // [527] phi bram_heap_set_prev::index#6 = bram_heap_set_prev::index#5 [phi:bram_heap_list_insert_at::@10->bram_heap_set_prev#0] -- register_copy 
    // [527] phi bram_heap_set_prev::prev#6 = bram_heap_set_prev::prev#5 [phi:bram_heap_list_insert_at::@10->bram_heap_set_prev#1] -- register_copy 
    // [527] phi bram_heap_set_prev::s#6 = bram_heap_set_prev::s#5 [phi:bram_heap_list_insert_at::@10->bram_heap_set_prev#2] -- register_copy 
    jsr bram_heap_set_prev
    // bram_heap_list_insert_at::@return
    // }
    // [489] return 
    rts
}
  // bram_heap_set_data_packed
// void bram_heap_set_data_packed(__register(X) char s, __zp($1e) char index, __zp($14) unsigned int data_packed)
bram_heap_set_data_packed: {
    .label bram_heap_set_data_packed__3 = 2
    .label bram_heap_set_data_packed__4 = 6
    .label bram_heap_set_data_packed__6 = 2
    .label index = $1e
    .label data_packed = $14
    .label bram_heap_map = 2
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [491] bram_heap_set_data_packed::$6 = (unsigned int)bram_heap_set_data_packed::s#7 -- vwuz1=_word_vbuxx 
    txa
    sta.z bram_heap_set_data_packed__6
    lda #0
    sta.z bram_heap_set_data_packed__6+1
    // [492] bram_heap_set_data_packed::$3 = bram_heap_set_data_packed::$6 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_set_data_packed__3
    rol.z bram_heap_set_data_packed__3+1
    dey
    bne !-
  !e:
    // [493] bram_heap_set_data_packed::bram_heap_map#0 = bram_heap_index + bram_heap_set_data_packed::$3 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // BYTE1(data_packed)
    // [494] bram_heap_set_data_packed::$1 = byte1  bram_heap_set_data_packed::data_packed#7 -- vbuxx=_byte1_vwuz1 
    ldx.z data_packed+1
    // bram_heap_map->data1[index] = BYTE1(data_packed)
    // [495] bram_heap_set_data_packed::$4 = (char *)bram_heap_set_data_packed::bram_heap_map#0 + $100 -- pbuz1=pbuz2_plus_vwuc1 
    lda.z bram_heap_map
    clc
    adc #<$100
    sta.z bram_heap_set_data_packed__4
    lda.z bram_heap_map+1
    adc #>$100
    sta.z bram_heap_set_data_packed__4+1
    // [496] bram_heap_set_data_packed::$4[bram_heap_set_data_packed::index#7] = bram_heap_set_data_packed::$1 -- pbuz1_derefidx_vbuz2=vbuxx 
    ldy.z index
    txa
    sta (bram_heap_set_data_packed__4),y
    // BYTE0(data_packed)
    // [497] bram_heap_set_data_packed::$2 = byte0  bram_heap_set_data_packed::data_packed#7 -- vbuaa=_byte0_vwuz1 
    lda.z data_packed
    // bram_heap_map->data0[index] = BYTE0(data_packed)
    // [498] ((char *)bram_heap_set_data_packed::bram_heap_map#0)[bram_heap_set_data_packed::index#7] = bram_heap_set_data_packed::$2 -- pbuz1_derefidx_vbuz2=vbuaa 
    sta (bram_heap_map),y
    // bram_heap_set_data_packed::@return
    // }
    // [499] return 
    rts
}
  // bram_heap_set_size_packed
// void bram_heap_set_size_packed(__register(X) char s, __zp($1c) char index, __zp($18) unsigned int size_packed)
bram_heap_set_size_packed: {
    .label bram_heap_set_size_packed__4 = 4
    .label bram_heap_set_size_packed__5 = 2
    .label bram_heap_set_size_packed__6 = 4
    .label bram_heap_set_size_packed__7 = 4
    .label index = $1c
    .label size_packed = $18
    .label bram_heap_map = 4
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [501] bram_heap_set_size_packed::$7 = (unsigned int)bram_heap_set_size_packed::s#6 -- vwuz1=_word_vbuxx 
    txa
    sta.z bram_heap_set_size_packed__7
    lda #0
    sta.z bram_heap_set_size_packed__7+1
    // [502] bram_heap_set_size_packed::$4 = bram_heap_set_size_packed::$7 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_set_size_packed__4
    rol.z bram_heap_set_size_packed__4+1
    dey
    bne !-
  !e:
    // [503] bram_heap_set_size_packed::bram_heap_map#0 = bram_heap_index + bram_heap_set_size_packed::$4 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // BYTE1(size_packed)
    // [504] bram_heap_set_size_packed::$1 = byte1  bram_heap_set_size_packed::size_packed#6 -- vbuaa=_byte1_vwuz1 
    lda.z size_packed+1
    // BYTE1(size_packed) & 0x7F
    // [505] bram_heap_set_size_packed::$2 = bram_heap_set_size_packed::$1 & $7f -- vbuxx=vbuaa_band_vbuc1 
    and #$7f
    tax
    // bram_heap_map->size1[index] = BYTE1(size_packed) & 0x7F
    // [506] bram_heap_set_size_packed::$5 = (char *)bram_heap_set_size_packed::bram_heap_map#0 + $300 -- pbuz1=pbuz2_plus_vwuc1 
    // bram_heap_map->size1[index] &= bram_heap_map->size1[index] & 0x80;
    lda.z bram_heap_map
    clc
    adc #<$300
    sta.z bram_heap_set_size_packed__5
    lda.z bram_heap_map+1
    adc #>$300
    sta.z bram_heap_set_size_packed__5+1
    // [507] bram_heap_set_size_packed::$5[bram_heap_set_size_packed::index#6] = bram_heap_set_size_packed::$2 -- pbuz1_derefidx_vbuz2=vbuxx 
    // bram_heap_map->size1[index] &= bram_heap_map->size1[index] & 0x80;
    ldy.z index
    txa
    sta (bram_heap_set_size_packed__5),y
    // BYTE0(size_packed)
    // [508] bram_heap_set_size_packed::$3 = byte0  bram_heap_set_size_packed::size_packed#6 -- vbuxx=_byte0_vwuz1 
    ldx.z size_packed
    // bram_heap_map->size0[index] = BYTE0(size_packed)
    // [509] bram_heap_set_size_packed::$6 = (char *)bram_heap_set_size_packed::bram_heap_map#0 + $200 -- pbuz1=pbuz1_plus_vwuc1 
    // Ignore free flag.
    lda.z bram_heap_set_size_packed__6
    clc
    adc #<$200
    sta.z bram_heap_set_size_packed__6
    lda.z bram_heap_set_size_packed__6+1
    adc #>$200
    sta.z bram_heap_set_size_packed__6+1
    // [510] bram_heap_set_size_packed::$6[bram_heap_set_size_packed::index#6] = bram_heap_set_size_packed::$3 -- pbuz1_derefidx_vbuz2=vbuxx 
    // Ignore free flag.
    txa
    sta (bram_heap_set_size_packed__6),y
    // bram_heap_set_size_packed::@return
    // }
    // [511] return 
    rts
}
  // bram_heap_set_free
// void bram_heap_set_free(__register(A) char s, __register(X) char index)
bram_heap_set_free: {
    .label bram_heap_set_free__1 = 2
    .label bram_heap_set_free__2 = 6
    .label bram_heap_set_free__3 = 2
    .label bram_heap_set_free__4 = 2
    .label bram_heap_map = 2
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [513] bram_heap_set_free::$4 = (unsigned int)bram_heap_set_free::s#5 -- vwuz1=_word_vbuaa 
    sta.z bram_heap_set_free__4
    lda #0
    sta.z bram_heap_set_free__4+1
    // [514] bram_heap_set_free::$1 = bram_heap_set_free::$4 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_set_free__1
    rol.z bram_heap_set_free__1+1
    dey
    bne !-
  !e:
    // [515] bram_heap_set_free::bram_heap_map#0 = bram_heap_index + bram_heap_set_free::$1 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->size1[index] |= 0x80
    // [516] bram_heap_set_free::$2 = (char *)bram_heap_set_free::bram_heap_map#0 + $300 -- pbuz1=pbuz2_plus_vwuc1 
    lda.z bram_heap_map
    clc
    adc #<$300
    sta.z bram_heap_set_free__2
    lda.z bram_heap_map+1
    adc #>$300
    sta.z bram_heap_set_free__2+1
    // [517] bram_heap_set_free::$3 = (char *)bram_heap_set_free::bram_heap_map#0 + $300 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_set_free__3
    clc
    adc #<$300
    sta.z bram_heap_set_free__3
    lda.z bram_heap_set_free__3+1
    adc #>$300
    sta.z bram_heap_set_free__3+1
    // [518] bram_heap_set_free::$3[bram_heap_set_free::index#5] = bram_heap_set_free::$2[bram_heap_set_free::index#5] | $80 -- pbuz1_derefidx_vbuxx=pbuz2_derefidx_vbuxx_bor_vbuc1 
    txa
    tay
    lda #$80
    ora (bram_heap_set_free__2),y
    sta (bram_heap_set_free__3),y
    // bram_heap_set_free::@return
    // }
    // [519] return 
    rts
}
  // bram_heap_set_next
/*inline*/
// void bram_heap_set_next(__register(Y) char s, __zp(9) char index, __register(X) char next)
bram_heap_set_next: {
    .label bram_heap_set_next__1 = 6
    .label bram_heap_set_next__2 = 6
    .label bram_heap_set_next__3 = 6
    .label index = 9
    .label bram_heap_map = 6
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [521] bram_heap_set_next::$3 = (unsigned int)bram_heap_set_next::s#6 -- vwuz1=_word_vbuyy 
    tya
    sta.z bram_heap_set_next__3
    lda #0
    sta.z bram_heap_set_next__3+1
    // [522] bram_heap_set_next::$1 = bram_heap_set_next::$3 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_set_next__1
    rol.z bram_heap_set_next__1+1
    dey
    bne !-
  !e:
    // [523] bram_heap_set_next::bram_heap_map#0 = bram_heap_index + bram_heap_set_next::$1 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->next[index] = next
    // [524] bram_heap_set_next::$2 = (char *)bram_heap_set_next::bram_heap_map#0 + $400 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_set_next__2
    clc
    adc #<$400
    sta.z bram_heap_set_next__2
    lda.z bram_heap_set_next__2+1
    adc #>$400
    sta.z bram_heap_set_next__2+1
    // [525] bram_heap_set_next::$2[bram_heap_set_next::index#6] = bram_heap_set_next::next#6 -- pbuz1_derefidx_vbuz2=vbuxx 
    ldy.z index
    txa
    sta (bram_heap_set_next__2),y
    // bram_heap_set_next::@return
    // }
    // [526] return 
    rts
}
  // bram_heap_set_prev
/*inline*/
// void bram_heap_set_prev(__register(Y) char s, __zp(8) char index, __register(X) char prev)
bram_heap_set_prev: {
    .label bram_heap_set_prev__1 = 4
    .label bram_heap_set_prev__2 = 4
    .label bram_heap_set_prev__3 = 4
    .label index = 8
    .label bram_heap_map = 4
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [528] bram_heap_set_prev::$3 = (unsigned int)bram_heap_set_prev::s#6 -- vwuz1=_word_vbuyy 
    tya
    sta.z bram_heap_set_prev__3
    lda #0
    sta.z bram_heap_set_prev__3+1
    // [529] bram_heap_set_prev::$1 = bram_heap_set_prev::$3 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_set_prev__1
    rol.z bram_heap_set_prev__1+1
    dey
    bne !-
  !e:
    // [530] bram_heap_set_prev::bram_heap_map#0 = bram_heap_index + bram_heap_set_prev::$1 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->prev[index] = prev
    // [531] bram_heap_set_prev::$2 = (char *)bram_heap_set_prev::bram_heap_map#0 + $500 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_set_prev__2
    clc
    adc #<$500
    sta.z bram_heap_set_prev__2
    lda.z bram_heap_set_prev__2+1
    adc #>$500
    sta.z bram_heap_set_prev__2+1
    // [532] bram_heap_set_prev::$2[bram_heap_set_prev::index#6] = bram_heap_set_prev::prev#6 -- pbuz1_derefidx_vbuz2=vbuxx 
    ldy.z index
    txa
    sta (bram_heap_set_prev__2),y
    // bram_heap_set_prev::@return
    // }
    // [533] return 
    rts
}
.segment Code
  // memset
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const c = 0
    .const num = $2000
    .label str = $a000
    .label end = str+num
    .label dst = $24
    // [535] phi from memset to memset::@1 [phi:memset->memset::@1]
    // [535] phi memset::dst#2 = (char *)memset::str#0 [phi:memset->memset::@1#0] -- pbuz1=pbuc1 
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
    // memset::@1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    // [536] if(memset::dst#2!=memset::end#0) goto memset::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // memset::@return
    // }
    // [537] return 
    rts
    // memset::@2
  __b2:
    // *dst = c
    // [538] *memset::dst#2 = memset::c#0 -- _deref_pbuz1=vbuc1 
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    // [539] memset::dst#1 = ++ memset::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [535] phi from memset::@2 to memset::@1 [phi:memset::@2->memset::@1]
    // [535] phi memset::dst#2 = memset::dst#1 [phi:memset::@2->memset::@1#0] -- register_copy 
    jmp __b1
}
.segment CodeBramHeap
  // bram_heap_list_remove
/**
* Remove header from List
*/
// __register(A) char bram_heap_list_remove(__zp($f) char s, __zp($a) char list, __zp($e) char index)
bram_heap_list_remove: {
    // empty list
    .label return = $a
    .label next = 8
    .label prev = $d
    .label list = $a
    .label s = $f
    .label index = $e
    // if(list == BRAM_HEAP_NULL)
    // [541] if(bram_heap_list_remove::list#10!=$ff) goto bram_heap_list_remove::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #$ff
    cmp.z list
    bne __b1
    // [542] phi from bram_heap_list_remove bram_heap_list_remove::@11 to bram_heap_list_remove::@return [phi:bram_heap_list_remove/bram_heap_list_remove::@11->bram_heap_list_remove::@return]
  __b4:
    // [542] phi bram_heap_list_remove::return#1 = $ff [phi:bram_heap_list_remove/bram_heap_list_remove::@11->bram_heap_list_remove::@return#0] -- vbuz1=vbuc1 
    lda #$ff
    sta.z return
    // bram_heap_list_remove::@return
  __breturn:
    // }
    // [543] return 
    rts
    // bram_heap_list_remove::@1
  __b1:
    // bram_heap_get_next(s, list)
    // [544] bram_heap_get_next::s#0 = bram_heap_list_remove::s#10 -- vbuaa=vbuz1 
    lda.z s
    // [545] bram_heap_get_next::index#0 = bram_heap_list_remove::list#10 -- vbuxx=vbuz1 
    ldx.z list
    // [546] call bram_heap_get_next
    // [651] phi from bram_heap_list_remove::@1 to bram_heap_get_next [phi:bram_heap_list_remove::@1->bram_heap_get_next]
    // [651] phi bram_heap_get_next::index#4 = bram_heap_get_next::index#0 [phi:bram_heap_list_remove::@1->bram_heap_get_next#0] -- register_copy 
    // [651] phi bram_heap_get_next::s#4 = bram_heap_get_next::s#0 [phi:bram_heap_list_remove::@1->bram_heap_get_next#1] -- register_copy 
    jsr bram_heap_get_next
    // bram_heap_get_next(s, list)
    // [547] bram_heap_get_next::return#0 = bram_heap_get_next::return#3
    // bram_heap_list_remove::@6
    // [548] bram_heap_list_remove::$2 = bram_heap_get_next::return#0
    // if(list == bram_heap_get_next(s, list))
    // [549] if(bram_heap_list_remove::list#10!=bram_heap_list_remove::$2) goto bram_heap_list_remove::@2 -- vbuz1_neq_vbuaa_then_la1 
    cmp.z list
    bne __b2
    // bram_heap_list_remove::@4
    // bram_heap_set_next(s, index, BRAM_HEAP_NULL)
    // [550] bram_heap_set_next::s#2 = bram_heap_list_remove::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [551] bram_heap_set_next::index#2 = bram_heap_list_remove::index#10 -- vbuz1=vbuz2 
    lda.z index
    sta.z bram_heap_set_next.index
    // [552] call bram_heap_set_next
  // We initialize the start of the list to null.
    // [520] phi from bram_heap_list_remove::@4 to bram_heap_set_next [phi:bram_heap_list_remove::@4->bram_heap_set_next]
    // [520] phi bram_heap_set_next::index#6 = bram_heap_set_next::index#2 [phi:bram_heap_list_remove::@4->bram_heap_set_next#0] -- register_copy 
    // [520] phi bram_heap_set_next::next#6 = $ff [phi:bram_heap_list_remove::@4->bram_heap_set_next#1] -- vbuxx=vbuc1 
    ldx #$ff
    // [520] phi bram_heap_set_next::s#6 = bram_heap_set_next::s#2 [phi:bram_heap_list_remove::@4->bram_heap_set_next#2] -- register_copy 
    jsr bram_heap_set_next
    // bram_heap_list_remove::@11
    // bram_heap_set_prev(s, index, BRAM_HEAP_NULL)
    // [553] bram_heap_set_prev::s#2 = bram_heap_list_remove::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [554] bram_heap_set_prev::index#2 = bram_heap_list_remove::index#10 -- vbuz1=vbuz2 
    lda.z index
    sta.z bram_heap_set_prev.index
    // [555] call bram_heap_set_prev
    // [527] phi from bram_heap_list_remove::@11 to bram_heap_set_prev [phi:bram_heap_list_remove::@11->bram_heap_set_prev]
    // [527] phi bram_heap_set_prev::index#6 = bram_heap_set_prev::index#2 [phi:bram_heap_list_remove::@11->bram_heap_set_prev#0] -- register_copy 
    // [527] phi bram_heap_set_prev::prev#6 = $ff [phi:bram_heap_list_remove::@11->bram_heap_set_prev#1] -- vbuxx=vbuc1 
    ldx #$ff
    // [527] phi bram_heap_set_prev::s#6 = bram_heap_set_prev::s#2 [phi:bram_heap_list_remove::@11->bram_heap_set_prev#2] -- register_copy 
    jsr bram_heap_set_prev
    jmp __b4
    // bram_heap_list_remove::@2
  __b2:
    // bram_heap_index_t next = bram_heap_get_next(s, index)
    // [556] bram_heap_get_next::s#1 = bram_heap_list_remove::s#10 -- vbuaa=vbuz1 
    lda.z s
    // [557] bram_heap_get_next::index#1 = bram_heap_list_remove::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [558] call bram_heap_get_next
    // [651] phi from bram_heap_list_remove::@2 to bram_heap_get_next [phi:bram_heap_list_remove::@2->bram_heap_get_next]
    // [651] phi bram_heap_get_next::index#4 = bram_heap_get_next::index#1 [phi:bram_heap_list_remove::@2->bram_heap_get_next#0] -- register_copy 
    // [651] phi bram_heap_get_next::s#4 = bram_heap_get_next::s#1 [phi:bram_heap_list_remove::@2->bram_heap_get_next#1] -- register_copy 
    jsr bram_heap_get_next
    // bram_heap_index_t next = bram_heap_get_next(s, index)
    // [559] bram_heap_get_next::return#1 = bram_heap_get_next::return#3
    // bram_heap_list_remove::@7
    // [560] bram_heap_list_remove::next#0 = bram_heap_get_next::return#1 -- vbuz1=vbuaa 
    sta.z next
    // bram_heap_index_t prev = bram_heap_get_prev(s, index)
    // [561] bram_heap_get_prev::s#0 = bram_heap_list_remove::s#10 -- vbuaa=vbuz1 
    lda.z s
    // [562] bram_heap_get_prev::index#0 = bram_heap_list_remove::index#10 -- vbuxx=vbuz1 
    ldx.z index
    // [563] call bram_heap_get_prev
    // [764] phi from bram_heap_list_remove::@7 to bram_heap_get_prev [phi:bram_heap_list_remove::@7->bram_heap_get_prev]
    // [764] phi bram_heap_get_prev::index#2 = bram_heap_get_prev::index#0 [phi:bram_heap_list_remove::@7->bram_heap_get_prev#0] -- register_copy 
    // [764] phi bram_heap_get_prev::s#2 = bram_heap_get_prev::s#0 [phi:bram_heap_list_remove::@7->bram_heap_get_prev#1] -- register_copy 
    jsr bram_heap_get_prev
    // bram_heap_index_t prev = bram_heap_get_prev(s, index)
    // [564] bram_heap_get_prev::return#0 = bram_heap_get_prev::return#1
    // bram_heap_list_remove::@8
    // [565] bram_heap_list_remove::prev#0 = bram_heap_get_prev::return#0 -- vbuz1=vbuaa 
    sta.z prev
    // bram_heap_set_next(s, prev, next)
    // [566] bram_heap_set_next::s#1 = bram_heap_list_remove::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [567] bram_heap_set_next::index#1 = bram_heap_list_remove::prev#0 -- vbuz1=vbuz2 
    sta.z bram_heap_set_next.index
    // [568] bram_heap_set_next::next#1 = bram_heap_list_remove::next#0 -- vbuxx=vbuz1 
    ldx.z next
    // [569] call bram_heap_set_next
  // TODO, why can't this be coded in one statement ...
    // [520] phi from bram_heap_list_remove::@8 to bram_heap_set_next [phi:bram_heap_list_remove::@8->bram_heap_set_next]
    // [520] phi bram_heap_set_next::index#6 = bram_heap_set_next::index#1 [phi:bram_heap_list_remove::@8->bram_heap_set_next#0] -- register_copy 
    // [520] phi bram_heap_set_next::next#6 = bram_heap_set_next::next#1 [phi:bram_heap_list_remove::@8->bram_heap_set_next#1] -- register_copy 
    // [520] phi bram_heap_set_next::s#6 = bram_heap_set_next::s#1 [phi:bram_heap_list_remove::@8->bram_heap_set_next#2] -- register_copy 
    jsr bram_heap_set_next
    // bram_heap_list_remove::@9
    // bram_heap_set_prev(s, next, prev)
    // [570] bram_heap_set_prev::s#1 = bram_heap_list_remove::s#10 -- vbuyy=vbuz1 
    ldy.z s
    // [571] bram_heap_set_prev::index#1 = bram_heap_list_remove::next#0
    // [572] bram_heap_set_prev::prev#1 = bram_heap_list_remove::prev#0 -- vbuxx=vbuz1 
    ldx.z prev
    // [573] call bram_heap_set_prev
    // [527] phi from bram_heap_list_remove::@9 to bram_heap_set_prev [phi:bram_heap_list_remove::@9->bram_heap_set_prev]
    // [527] phi bram_heap_set_prev::index#6 = bram_heap_set_prev::index#1 [phi:bram_heap_list_remove::@9->bram_heap_set_prev#0] -- register_copy 
    // [527] phi bram_heap_set_prev::prev#6 = bram_heap_set_prev::prev#1 [phi:bram_heap_list_remove::@9->bram_heap_set_prev#1] -- register_copy 
    // [527] phi bram_heap_set_prev::s#6 = bram_heap_set_prev::s#1 [phi:bram_heap_list_remove::@9->bram_heap_set_prev#2] -- register_copy 
    jsr bram_heap_set_prev
    // bram_heap_list_remove::@10
    // if(index == list)
    // [574] if(bram_heap_list_remove::index#10!=bram_heap_list_remove::list#10) goto bram_heap_list_remove::@3 -- vbuz1_neq_vbuz2_then_la1 
    lda.z index
    cmp.z list
    bne __breturn
    // bram_heap_list_remove::@5
    // bram_heap_get_next(s, list)
    // [575] bram_heap_get_next::s#2 = bram_heap_list_remove::s#10 -- vbuaa=vbuz1 
    lda.z s
    // [576] bram_heap_get_next::index#2 = bram_heap_list_remove::list#10 -- vbuxx=vbuz1 
    ldx.z list
    // [577] call bram_heap_get_next
    // [651] phi from bram_heap_list_remove::@5 to bram_heap_get_next [phi:bram_heap_list_remove::@5->bram_heap_get_next]
    // [651] phi bram_heap_get_next::index#4 = bram_heap_get_next::index#2 [phi:bram_heap_list_remove::@5->bram_heap_get_next#0] -- register_copy 
    // [651] phi bram_heap_get_next::s#4 = bram_heap_get_next::s#2 [phi:bram_heap_list_remove::@5->bram_heap_get_next#1] -- register_copy 
    jsr bram_heap_get_next
    // bram_heap_get_next(s, list)
    // [578] bram_heap_get_next::return#2 = bram_heap_get_next::return#3
    // bram_heap_list_remove::@12
    // list = bram_heap_get_next(s, list)
    // [579] bram_heap_list_remove::list#1 = bram_heap_get_next::return#2 -- vbuz1=vbuaa 
    sta.z list
    // [580] phi from bram_heap_list_remove::@10 bram_heap_list_remove::@12 to bram_heap_list_remove::@3 [phi:bram_heap_list_remove::@10/bram_heap_list_remove::@12->bram_heap_list_remove::@3]
    // [580] phi bram_heap_list_remove::return#3 = bram_heap_list_remove::list#10 [phi:bram_heap_list_remove::@10/bram_heap_list_remove::@12->bram_heap_list_remove::@3#0] -- register_copy 
    // bram_heap_list_remove::@3
    // [542] phi from bram_heap_list_remove::@3 to bram_heap_list_remove::@return [phi:bram_heap_list_remove::@3->bram_heap_list_remove::@return]
    // [542] phi bram_heap_list_remove::return#1 = bram_heap_list_remove::return#3 [phi:bram_heap_list_remove::@3->bram_heap_list_remove::@return#0] -- register_copy 
    rts
}
  // bram_heap_get_left
/*inline*/
// __register(A) char bram_heap_get_left(__register(A) char s, __register(X) char index)
bram_heap_get_left: {
    .label bram_heap_get_left__1 = 4
    .label bram_heap_get_left__2 = 4
    .label bram_heap_get_left__3 = 4
    .label bram_heap_map = 4
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [582] bram_heap_get_left::$3 = (unsigned int)bram_heap_get_left::s#4 -- vwuz1=_word_vbuaa 
    sta.z bram_heap_get_left__3
    lda #0
    sta.z bram_heap_get_left__3+1
    // [583] bram_heap_get_left::$1 = bram_heap_get_left::$3 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_get_left__1
    rol.z bram_heap_get_left__1+1
    dey
    bne !-
  !e:
    // [584] bram_heap_get_left::bram_heap_map#0 = bram_heap_index + bram_heap_get_left::$1 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // return bram_heap_map->left[index];
    // [585] bram_heap_get_left::$2 = (char *)bram_heap_get_left::bram_heap_map#0 + $700 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_get_left__2
    clc
    adc #<$700
    sta.z bram_heap_get_left__2
    lda.z bram_heap_get_left__2+1
    adc #>$700
    sta.z bram_heap_get_left__2+1
    // [586] bram_heap_get_left::return#0 = bram_heap_get_left::$2[bram_heap_get_left::index#4] -- vbuaa=pbuz1_derefidx_vbuxx 
    txa
    tay
    lda (bram_heap_get_left__2),y
    // bram_heap_get_left::@return
    // }
    // [587] return 
    rts
}
  // bram_heap_is_free
// __register(A) bool bram_heap_is_free(__register(A) char s, __register(X) char index)
bram_heap_is_free: {
    .label bram_heap_is_free__3 = $20
    .label bram_heap_is_free__4 = $20
    .label bram_heap_is_free__5 = $20
    .label bram_heap_map = $20
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [589] bram_heap_is_free::$5 = (unsigned int)bram_heap_is_free::s#2 -- vwuz1=_word_vbuaa 
    sta.z bram_heap_is_free__5
    lda #0
    sta.z bram_heap_is_free__5+1
    // [590] bram_heap_is_free::$3 = bram_heap_is_free::$5 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_is_free__3
    rol.z bram_heap_is_free__3+1
    dey
    bne !-
  !e:
    // [591] bram_heap_is_free::bram_heap_map#0 = bram_heap_index + bram_heap_is_free::$3 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->size1[index] & 0x80
    // [592] bram_heap_is_free::$4 = (char *)bram_heap_is_free::bram_heap_map#0 + $300 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_is_free__4
    clc
    adc #<$300
    sta.z bram_heap_is_free__4
    lda.z bram_heap_is_free__4+1
    adc #>$300
    sta.z bram_heap_is_free__4+1
    // [593] bram_heap_is_free::$1 = bram_heap_is_free::$4[bram_heap_is_free::index#2] & $80 -- vbuaa=pbuz1_derefidx_vbuxx_band_vbuc1 
    txa
    tay
    lda #$80
    and (bram_heap_is_free__4),y
    // (bram_heap_map->size1[index] & 0x80) == 0x80
    // [594] bram_heap_is_free::return#0 = bram_heap_is_free::$1 == $80 -- vboaa=vbuaa_eq_vbuc1 
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // bram_heap_is_free::@return
    // }
    // [595] return 
    rts
}
  // bram_heap_get_right
/*inline*/
// __register(A) char bram_heap_get_right(__register(A) char s, __register(X) char index)
bram_heap_get_right: {
    .label bram_heap_get_right__1 = $16
    .label bram_heap_get_right__2 = $16
    .label bram_heap_get_right__3 = $16
    .label bram_heap_map = $16
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [597] bram_heap_get_right::$3 = (unsigned int)bram_heap_get_right::s#3 -- vwuz1=_word_vbuaa 
    sta.z bram_heap_get_right__3
    lda #0
    sta.z bram_heap_get_right__3+1
    // [598] bram_heap_get_right::$1 = bram_heap_get_right::$3 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_get_right__1
    rol.z bram_heap_get_right__1+1
    dey
    bne !-
  !e:
    // [599] bram_heap_get_right::bram_heap_map#0 = bram_heap_index + bram_heap_get_right::$1 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // return bram_heap_map->right[index];
    // [600] bram_heap_get_right::$2 = (char *)bram_heap_get_right::bram_heap_map#0 + $600 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_get_right__2
    clc
    adc #<$600
    sta.z bram_heap_get_right__2
    lda.z bram_heap_get_right__2+1
    adc #>$600
    sta.z bram_heap_get_right__2+1
    // [601] bram_heap_get_right::return#0 = bram_heap_get_right::$2[bram_heap_get_right::index#3] -- vbuaa=pbuz1_derefidx_vbuxx 
    txa
    tay
    lda (bram_heap_get_right__2),y
    // bram_heap_get_right::@return
    // }
    // [602] return 
    rts
}
  // bram_heap_free_remove
// void bram_heap_free_remove(__zp($1f) char s, __zp($23) char free_index)
bram_heap_free_remove: {
    .label s = $1f
    .label free_index = $23
    // bram_heap_segment.freeCount[s]--;
    // [604] bram_heap_free_remove::$4 = bram_heap_free_remove::s#2 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [605] ((unsigned int *)&bram_heap_segment+$25)[bram_heap_free_remove::$4] = -- ((unsigned int *)&bram_heap_segment+$25)[bram_heap_free_remove::$4] -- pwuc1_derefidx_vbuaa=_dec_pwuc1_derefidx_vbuaa 
    tax
    lda bram_heap_segment+$25,x
    bne !+
    dec bram_heap_segment+$25+1,x
  !:
    dec bram_heap_segment+$25,x
    // bram_heap_list_remove(s, bram_heap_segment.free_list[s], free_index)
    // [606] bram_heap_list_remove::s#1 = bram_heap_free_remove::s#2 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_list_remove.s
    // [607] bram_heap_list_remove::list#3 = ((char *)&bram_heap_segment+$19)[bram_heap_free_remove::s#2] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda bram_heap_segment+$19,y
    sta.z bram_heap_list_remove.list
    // [608] bram_heap_list_remove::index#1 = bram_heap_free_remove::free_index#2 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_list_remove.index
    // [609] call bram_heap_list_remove
    // [540] phi from bram_heap_free_remove to bram_heap_list_remove [phi:bram_heap_free_remove->bram_heap_list_remove]
    // [540] phi bram_heap_list_remove::index#10 = bram_heap_list_remove::index#1 [phi:bram_heap_free_remove->bram_heap_list_remove#0] -- register_copy 
    // [540] phi bram_heap_list_remove::s#10 = bram_heap_list_remove::s#1 [phi:bram_heap_free_remove->bram_heap_list_remove#1] -- register_copy 
    // [540] phi bram_heap_list_remove::list#10 = bram_heap_list_remove::list#3 [phi:bram_heap_free_remove->bram_heap_list_remove#2] -- register_copy 
    jsr bram_heap_list_remove
    // bram_heap_list_remove(s, bram_heap_segment.free_list[s], free_index)
    // [610] bram_heap_list_remove::return#5 = bram_heap_list_remove::return#1 -- vbuaa=vbuz1 
    lda.z bram_heap_list_remove.return
    // bram_heap_free_remove::@1
    // [611] bram_heap_free_remove::$1 = bram_heap_list_remove::return#5
    // bram_heap_segment.free_list[s] = bram_heap_list_remove(s, bram_heap_segment.free_list[s], free_index)
    // [612] ((char *)&bram_heap_segment+$19)[bram_heap_free_remove::s#2] = bram_heap_free_remove::$1 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z s
    sta bram_heap_segment+$19,y
    // bram_heap_clear_free(s, free_index)
    // [613] bram_heap_clear_free::s#0 = bram_heap_free_remove::s#2 -- vbuaa=vbuz1 
    tya
    // [614] bram_heap_clear_free::index#0 = bram_heap_free_remove::free_index#2 -- vbuxx=vbuz1 
    ldx.z free_index
    // [615] call bram_heap_clear_free
    // [771] phi from bram_heap_free_remove::@1 to bram_heap_clear_free [phi:bram_heap_free_remove::@1->bram_heap_clear_free]
    // [771] phi bram_heap_clear_free::index#2 = bram_heap_clear_free::index#0 [phi:bram_heap_free_remove::@1->bram_heap_clear_free#0] -- register_copy 
    // [771] phi bram_heap_clear_free::s#2 = bram_heap_clear_free::s#0 [phi:bram_heap_free_remove::@1->bram_heap_clear_free#1] -- register_copy 
    jsr bram_heap_clear_free
    // bram_heap_free_remove::@return
    // }
    // [616] return 
    rts
}
  // bram_heap_idle_insert
// char bram_heap_idle_insert(__zp($32) char s, __zp($3b) char idle_index)
bram_heap_idle_insert: {
    .label s = $32
    .label idle_index = $3b
    // bram_heap_list_insert_at(s, bram_heap_segment.idle_list[s], idle_index, bram_heap_segment.idle_list[s])
    // [617] bram_heap_list_insert_at::s#3 = bram_heap_idle_insert::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_list_insert_at.s
    // [618] bram_heap_list_insert_at::list#4 = ((char *)&bram_heap_segment+$1b)[bram_heap_idle_insert::s#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda bram_heap_segment+$1b,y
    sta.z bram_heap_list_insert_at.list
    // [619] bram_heap_list_insert_at::index#3 = bram_heap_idle_insert::idle_index#0 -- vbuz1=vbuz2 
    lda.z idle_index
    sta.z bram_heap_list_insert_at.index
    // [620] bram_heap_list_insert_at::at#4 = ((char *)&bram_heap_segment+$1b)[bram_heap_idle_insert::s#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    lda bram_heap_segment+$1b,y
    sta.z bram_heap_list_insert_at.at
    // [621] call bram_heap_list_insert_at
    // [453] phi from bram_heap_idle_insert to bram_heap_list_insert_at [phi:bram_heap_idle_insert->bram_heap_list_insert_at]
    // [453] phi bram_heap_list_insert_at::s#10 = bram_heap_list_insert_at::s#3 [phi:bram_heap_idle_insert->bram_heap_list_insert_at#0] -- register_copy 
    // [453] phi bram_heap_list_insert_at::index#10 = bram_heap_list_insert_at::index#3 [phi:bram_heap_idle_insert->bram_heap_list_insert_at#1] -- register_copy 
    // [453] phi bram_heap_list_insert_at::at#10 = bram_heap_list_insert_at::at#4 [phi:bram_heap_idle_insert->bram_heap_list_insert_at#2] -- register_copy 
    // [453] phi bram_heap_list_insert_at::list#5 = bram_heap_list_insert_at::list#4 [phi:bram_heap_idle_insert->bram_heap_list_insert_at#3] -- register_copy 
    jsr bram_heap_list_insert_at
    // bram_heap_list_insert_at(s, bram_heap_segment.idle_list[s], idle_index, bram_heap_segment.idle_list[s])
    // [622] bram_heap_list_insert_at::return#10 = bram_heap_list_insert_at::list#11 -- vbuaa=vbuz1 
    lda.z bram_heap_list_insert_at.list
    // bram_heap_idle_insert::@1
    // [623] bram_heap_idle_insert::$0 = bram_heap_list_insert_at::return#10
    // bram_heap_segment.idle_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.idle_list[s], idle_index, bram_heap_segment.idle_list[s])
    // [624] ((char *)&bram_heap_segment+$1b)[bram_heap_idle_insert::s#0] = bram_heap_idle_insert::$0 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z s
    sta bram_heap_segment+$1b,y
    // bram_heap_set_data_packed(s, idle_index, 0)
    // [625] bram_heap_set_data_packed::s#2 = bram_heap_idle_insert::s#0 -- vbuxx=vbuz1 
    ldx.z s
    // [626] bram_heap_set_data_packed::index#2 = bram_heap_idle_insert::idle_index#0 -- vbuz1=vbuz2 
    lda.z idle_index
    sta.z bram_heap_set_data_packed.index
    // [627] call bram_heap_set_data_packed
    // [490] phi from bram_heap_idle_insert::@1 to bram_heap_set_data_packed [phi:bram_heap_idle_insert::@1->bram_heap_set_data_packed]
    // [490] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#2 [phi:bram_heap_idle_insert::@1->bram_heap_set_data_packed#0] -- register_copy 
    // [490] phi bram_heap_set_data_packed::data_packed#7 = 0 [phi:bram_heap_idle_insert::@1->bram_heap_set_data_packed#1] -- vwuz1=vbuc1 
    lda #<0
    sta.z bram_heap_set_data_packed.data_packed
    sta.z bram_heap_set_data_packed.data_packed+1
    // [490] phi bram_heap_set_data_packed::s#7 = bram_heap_set_data_packed::s#2 [phi:bram_heap_idle_insert::@1->bram_heap_set_data_packed#2] -- register_copy 
    jsr bram_heap_set_data_packed
    // bram_heap_idle_insert::@2
    // bram_heap_set_size_packed(s, idle_index, 0)
    // [628] bram_heap_set_size_packed::s#3 = bram_heap_idle_insert::s#0 -- vbuxx=vbuz1 
    ldx.z s
    // [629] bram_heap_set_size_packed::index#3 = bram_heap_idle_insert::idle_index#0 -- vbuz1=vbuz2 
    lda.z idle_index
    sta.z bram_heap_set_size_packed.index
    // [630] call bram_heap_set_size_packed
    // [500] phi from bram_heap_idle_insert::@2 to bram_heap_set_size_packed [phi:bram_heap_idle_insert::@2->bram_heap_set_size_packed]
    // [500] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#3 [phi:bram_heap_idle_insert::@2->bram_heap_set_size_packed#0] -- register_copy 
    // [500] phi bram_heap_set_size_packed::size_packed#6 = 0 [phi:bram_heap_idle_insert::@2->bram_heap_set_size_packed#1] -- vwuz1=vbuc1 
    lda #<0
    sta.z bram_heap_set_size_packed.size_packed
    sta.z bram_heap_set_size_packed.size_packed+1
    // [500] phi bram_heap_set_size_packed::s#6 = bram_heap_set_size_packed::s#3 [phi:bram_heap_idle_insert::@2->bram_heap_set_size_packed#2] -- register_copy 
    jsr bram_heap_set_size_packed
    // bram_heap_idle_insert::@3
    // bram_heap_segment.idleCount[s]++;
    // [631] bram_heap_idle_insert::$5 = bram_heap_idle_insert::s#0 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [632] ((unsigned int *)&bram_heap_segment+$29)[bram_heap_idle_insert::$5] = ++ ((unsigned int *)&bram_heap_segment+$29)[bram_heap_idle_insert::$5] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc bram_heap_segment+$29,x
    bne !+
    inc bram_heap_segment+$29+1,x
  !:
    // bram_heap_idle_insert::@return
    // }
    // [633] return 
    rts
}
  // bram_heap_set_left
/*inline*/
// void bram_heap_set_left(__register(Y) char s, __zp($1a) char index, __register(X) char left)
bram_heap_set_left: {
    .label bram_heap_set_left__1 = $12
    .label bram_heap_set_left__2 = $12
    .label bram_heap_set_left__3 = $12
    .label bram_heap_map = $12
    .label index = $1a
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [635] bram_heap_set_left::$3 = (unsigned int)bram_heap_set_left::s#6 -- vwuz1=_word_vbuyy 
    tya
    sta.z bram_heap_set_left__3
    lda #0
    sta.z bram_heap_set_left__3+1
    // [636] bram_heap_set_left::$1 = bram_heap_set_left::$3 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_set_left__1
    rol.z bram_heap_set_left__1+1
    dey
    bne !-
  !e:
    // [637] bram_heap_set_left::bram_heap_map#0 = bram_heap_index + bram_heap_set_left::$1 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->left[index] = left
    // [638] bram_heap_set_left::$2 = (char *)bram_heap_set_left::bram_heap_map#0 + $700 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_set_left__2
    clc
    adc #<$700
    sta.z bram_heap_set_left__2
    lda.z bram_heap_set_left__2+1
    adc #>$700
    sta.z bram_heap_set_left__2+1
    // [639] bram_heap_set_left::$2[bram_heap_set_left::index#6] = bram_heap_set_left::left#6 -- pbuz1_derefidx_vbuz2=vbuxx 
    ldy.z index
    txa
    sta (bram_heap_set_left__2),y
    // bram_heap_set_left::@return
    // }
    // [640] return 
    rts
}
  // bram_heap_set_right
/*inline*/
// void bram_heap_set_right(__register(Y) char s, __zp($1d) char index, __register(X) char right)
bram_heap_set_right: {
    .label bram_heap_set_right__1 = $12
    .label bram_heap_set_right__2 = $12
    .label bram_heap_set_right__3 = $12
    .label bram_heap_map = $12
    .label index = $1d
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [642] bram_heap_set_right::$3 = (unsigned int)bram_heap_set_right::s#6 -- vwuz1=_word_vbuyy 
    tya
    sta.z bram_heap_set_right__3
    lda #0
    sta.z bram_heap_set_right__3+1
    // [643] bram_heap_set_right::$1 = bram_heap_set_right::$3 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_set_right__1
    rol.z bram_heap_set_right__1+1
    dey
    bne !-
  !e:
    // [644] bram_heap_set_right::bram_heap_map#0 = bram_heap_index + bram_heap_set_right::$1 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->right[index] = right
    // [645] bram_heap_set_right::$2 = (char *)bram_heap_set_right::bram_heap_map#0 + $600 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_set_right__2
    clc
    adc #<$600
    sta.z bram_heap_set_right__2
    lda.z bram_heap_set_right__2+1
    adc #>$600
    sta.z bram_heap_set_right__2+1
    // [646] bram_heap_set_right::$2[bram_heap_set_right::index#6] = bram_heap_set_right::right#6 -- pbuz1_derefidx_vbuz2=vbuxx 
    ldy.z index
    txa
    sta (bram_heap_set_right__2),y
    // bram_heap_set_right::@return
    // }
    // [647] return 
    rts
}
  // bram_heap_size_pack
// __zp($20) unsigned int bram_heap_size_pack(__zp($28) unsigned long size)
bram_heap_size_pack: {
    .label bram_heap_size_pack__0 = $28
    .label return = $20
    .label size = $28
    // size >> 5
    // [648] bram_heap_size_pack::$0 = bram_heap_size_pack::size#0 >> 5 -- vduz1=vduz1_ror_5 
    lsr.z bram_heap_size_pack__0+3
    ror.z bram_heap_size_pack__0+2
    ror.z bram_heap_size_pack__0+1
    ror.z bram_heap_size_pack__0
    lsr.z bram_heap_size_pack__0+3
    ror.z bram_heap_size_pack__0+2
    ror.z bram_heap_size_pack__0+1
    ror.z bram_heap_size_pack__0
    lsr.z bram_heap_size_pack__0+3
    ror.z bram_heap_size_pack__0+2
    ror.z bram_heap_size_pack__0+1
    ror.z bram_heap_size_pack__0
    lsr.z bram_heap_size_pack__0+3
    ror.z bram_heap_size_pack__0+2
    ror.z bram_heap_size_pack__0+1
    ror.z bram_heap_size_pack__0
    lsr.z bram_heap_size_pack__0+3
    ror.z bram_heap_size_pack__0+2
    ror.z bram_heap_size_pack__0+1
    ror.z bram_heap_size_pack__0
    // return (bram_heap_size_packed_t)(size >> 5);
    // [649] bram_heap_size_pack::return#0 = (unsigned int)bram_heap_size_pack::$0 -- vwuz1=_word_vduz2 
    lda.z bram_heap_size_pack__0
    sta.z return
    lda.z bram_heap_size_pack__0+1
    sta.z return+1
    // bram_heap_size_pack::@return
    // }
    // [650] return 
    rts
}
  // bram_heap_get_next
/*inline*/
// __register(A) char bram_heap_get_next(__register(A) char s, __register(X) char index)
bram_heap_get_next: {
    .label bram_heap_get_next__1 = 2
    .label bram_heap_get_next__2 = 2
    .label bram_heap_get_next__3 = 2
    .label bram_heap_map = 2
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [652] bram_heap_get_next::$3 = (unsigned int)bram_heap_get_next::s#4 -- vwuz1=_word_vbuaa 
    sta.z bram_heap_get_next__3
    lda #0
    sta.z bram_heap_get_next__3+1
    // [653] bram_heap_get_next::$1 = bram_heap_get_next::$3 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_get_next__1
    rol.z bram_heap_get_next__1+1
    dey
    bne !-
  !e:
    // [654] bram_heap_get_next::bram_heap_map#0 = bram_heap_index + bram_heap_get_next::$1 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // return bram_heap_map->next[index];
    // [655] bram_heap_get_next::$2 = (char *)bram_heap_get_next::bram_heap_map#0 + $400 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_get_next__2
    clc
    adc #<$400
    sta.z bram_heap_get_next__2
    lda.z bram_heap_get_next__2+1
    adc #>$400
    sta.z bram_heap_get_next__2+1
    // [656] bram_heap_get_next::return#3 = bram_heap_get_next::$2[bram_heap_get_next::index#4] -- vbuaa=pbuz1_derefidx_vbuxx 
    txa
    tay
    lda (bram_heap_get_next__2),y
    // bram_heap_get_next::@return
    // }
    // [657] return 
    rts
}
  // bram_heap_replace_free_with_heap
/**
 * The free size matches exactly the required heap size.
 * The free index is replaced by a heap index.
 */
// __zp($3c) char bram_heap_replace_free_with_heap(__zp($39) char s, char free_index, __zp($33) unsigned int required_size)
bram_heap_replace_free_with_heap: {
    .label free_data = $2e
    .label free_left = $45
    .label free_right = $44
    .label s = $39
    .label required_size = $33
    .label return = $3c
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [658] bram_heap_get_size_packed::s#2 = bram_heap_replace_free_with_heap::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [659] bram_heap_get_size_packed::index#2 = bram_heap_replace_free_with_heap::return#2 -- vbuxx=vbuz1 
    ldx.z return
    // [660] call bram_heap_get_size_packed
    // [214] phi from bram_heap_replace_free_with_heap to bram_heap_get_size_packed [phi:bram_heap_replace_free_with_heap->bram_heap_get_size_packed]
    // [214] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#2 [phi:bram_heap_replace_free_with_heap->bram_heap_get_size_packed#0] -- register_copy 
    // [214] phi bram_heap_get_size_packed::s#8 = bram_heap_get_size_packed::s#2 [phi:bram_heap_replace_free_with_heap->bram_heap_get_size_packed#1] -- register_copy 
    jsr bram_heap_get_size_packed
    // bram_heap_replace_free_with_heap::@1
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [661] bram_heap_get_data_packed::s#1 = bram_heap_replace_free_with_heap::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [662] bram_heap_get_data_packed::index#1 = bram_heap_replace_free_with_heap::return#2 -- vbuxx=vbuz1 
    ldx.z return
    // [663] call bram_heap_get_data_packed
    // [225] phi from bram_heap_replace_free_with_heap::@1 to bram_heap_get_data_packed [phi:bram_heap_replace_free_with_heap::@1->bram_heap_get_data_packed]
    // [225] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#1 [phi:bram_heap_replace_free_with_heap::@1->bram_heap_get_data_packed#0] -- register_copy 
    // [225] phi bram_heap_get_data_packed::s#8 = bram_heap_get_data_packed::s#1 [phi:bram_heap_replace_free_with_heap::@1->bram_heap_get_data_packed#1] -- register_copy 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [664] bram_heap_get_data_packed::return#12 = bram_heap_get_data_packed::return#1 -- vwuz1=vwuz2 
    lda.z bram_heap_get_data_packed.return
    sta.z bram_heap_get_data_packed.return_1
    lda.z bram_heap_get_data_packed.return+1
    sta.z bram_heap_get_data_packed.return_1+1
    // bram_heap_replace_free_with_heap::@2
    // [665] bram_heap_replace_free_with_heap::free_data#0 = bram_heap_get_data_packed::return#12
    // bram_heap_index_t free_left = bram_heap_get_left(s, free_index)
    // [666] bram_heap_get_left::s#0 = bram_heap_replace_free_with_heap::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [667] bram_heap_get_left::index#0 = bram_heap_replace_free_with_heap::return#2 -- vbuxx=vbuz1 
    ldx.z return
    // [668] call bram_heap_get_left
    // [581] phi from bram_heap_replace_free_with_heap::@2 to bram_heap_get_left [phi:bram_heap_replace_free_with_heap::@2->bram_heap_get_left]
    // [581] phi bram_heap_get_left::index#4 = bram_heap_get_left::index#0 [phi:bram_heap_replace_free_with_heap::@2->bram_heap_get_left#0] -- register_copy 
    // [581] phi bram_heap_get_left::s#4 = bram_heap_get_left::s#0 [phi:bram_heap_replace_free_with_heap::@2->bram_heap_get_left#1] -- register_copy 
    jsr bram_heap_get_left
    // bram_heap_index_t free_left = bram_heap_get_left(s, free_index)
    // [669] bram_heap_get_left::return#2 = bram_heap_get_left::return#0
    // bram_heap_replace_free_with_heap::@3
    // [670] bram_heap_replace_free_with_heap::free_left#0 = bram_heap_get_left::return#2 -- vbuz1=vbuaa 
    sta.z free_left
    // bram_heap_index_t free_right = bram_heap_get_right(s, free_index)
    // [671] bram_heap_get_right::s#0 = bram_heap_replace_free_with_heap::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [672] bram_heap_get_right::index#0 = bram_heap_replace_free_with_heap::return#2 -- vbuxx=vbuz1 
    ldx.z return
    // [673] call bram_heap_get_right
    // [596] phi from bram_heap_replace_free_with_heap::@3 to bram_heap_get_right [phi:bram_heap_replace_free_with_heap::@3->bram_heap_get_right]
    // [596] phi bram_heap_get_right::index#3 = bram_heap_get_right::index#0 [phi:bram_heap_replace_free_with_heap::@3->bram_heap_get_right#0] -- register_copy 
    // [596] phi bram_heap_get_right::s#3 = bram_heap_get_right::s#0 [phi:bram_heap_replace_free_with_heap::@3->bram_heap_get_right#1] -- register_copy 
    jsr bram_heap_get_right
    // bram_heap_index_t free_right = bram_heap_get_right(s, free_index)
    // [674] bram_heap_get_right::return#2 = bram_heap_get_right::return#0
    // bram_heap_replace_free_with_heap::@4
    // [675] bram_heap_replace_free_with_heap::free_right#0 = bram_heap_get_right::return#2 -- vbuz1=vbuaa 
    sta.z free_right
    // bram_heap_free_remove(s, free_index)
    // [676] bram_heap_free_remove::s#0 = bram_heap_replace_free_with_heap::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_free_remove.s
    // [677] bram_heap_free_remove::free_index#0 = bram_heap_replace_free_with_heap::return#2 -- vbuz1=vbuz2 
    lda.z return
    sta.z bram_heap_free_remove.free_index
    // [678] call bram_heap_free_remove
    // [603] phi from bram_heap_replace_free_with_heap::@4 to bram_heap_free_remove [phi:bram_heap_replace_free_with_heap::@4->bram_heap_free_remove]
    // [603] phi bram_heap_free_remove::free_index#2 = bram_heap_free_remove::free_index#0 [phi:bram_heap_replace_free_with_heap::@4->bram_heap_free_remove#0] -- register_copy 
    // [603] phi bram_heap_free_remove::s#2 = bram_heap_free_remove::s#0 [phi:bram_heap_replace_free_with_heap::@4->bram_heap_free_remove#1] -- register_copy 
    jsr bram_heap_free_remove
    // bram_heap_replace_free_with_heap::@5
    // bram_heap_heap_insert_at(s, heap_index, BRAM_HEAP_NULL, required_size)
    // [679] bram_heap_heap_insert_at::s#0 = bram_heap_replace_free_with_heap::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_heap_insert_at.s
    // [680] bram_heap_heap_insert_at::heap_index#0 = bram_heap_replace_free_with_heap::return#2 -- vbuz1=vbuz2 
    lda.z return
    sta.z bram_heap_heap_insert_at.heap_index
    // [681] bram_heap_heap_insert_at::size#0 = bram_heap_replace_free_with_heap::required_size#0 -- vwuz1=vwuz2 
    lda.z required_size
    sta.z bram_heap_heap_insert_at.size
    lda.z required_size+1
    sta.z bram_heap_heap_insert_at.size+1
    // [682] call bram_heap_heap_insert_at
    // [779] phi from bram_heap_replace_free_with_heap::@5 to bram_heap_heap_insert_at [phi:bram_heap_replace_free_with_heap::@5->bram_heap_heap_insert_at]
    // [779] phi bram_heap_heap_insert_at::size#2 = bram_heap_heap_insert_at::size#0 [phi:bram_heap_replace_free_with_heap::@5->bram_heap_heap_insert_at#0] -- register_copy 
    // [779] phi bram_heap_heap_insert_at::heap_index#2 = bram_heap_heap_insert_at::heap_index#0 [phi:bram_heap_replace_free_with_heap::@5->bram_heap_heap_insert_at#1] -- register_copy 
    // [779] phi bram_heap_heap_insert_at::s#2 = bram_heap_heap_insert_at::s#0 [phi:bram_heap_replace_free_with_heap::@5->bram_heap_heap_insert_at#2] -- register_copy 
    jsr bram_heap_heap_insert_at
    // bram_heap_replace_free_with_heap::@6
    // bram_heap_set_data_packed(s, heap_index, free_data)
    // [683] bram_heap_set_data_packed::s#3 = bram_heap_replace_free_with_heap::s#0 -- vbuxx=vbuz1 
    ldx.z s
    // [684] bram_heap_set_data_packed::index#3 = bram_heap_replace_free_with_heap::return#2 -- vbuz1=vbuz2 
    lda.z return
    sta.z bram_heap_set_data_packed.index
    // [685] bram_heap_set_data_packed::data_packed#3 = bram_heap_replace_free_with_heap::free_data#0 -- vwuz1=vwuz2 
    lda.z free_data
    sta.z bram_heap_set_data_packed.data_packed
    lda.z free_data+1
    sta.z bram_heap_set_data_packed.data_packed+1
    // [686] call bram_heap_set_data_packed
    // [490] phi from bram_heap_replace_free_with_heap::@6 to bram_heap_set_data_packed [phi:bram_heap_replace_free_with_heap::@6->bram_heap_set_data_packed]
    // [490] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#3 [phi:bram_heap_replace_free_with_heap::@6->bram_heap_set_data_packed#0] -- register_copy 
    // [490] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#3 [phi:bram_heap_replace_free_with_heap::@6->bram_heap_set_data_packed#1] -- register_copy 
    // [490] phi bram_heap_set_data_packed::s#7 = bram_heap_set_data_packed::s#3 [phi:bram_heap_replace_free_with_heap::@6->bram_heap_set_data_packed#2] -- register_copy 
    jsr bram_heap_set_data_packed
    // bram_heap_replace_free_with_heap::@7
    // bram_heap_set_left(s, heap_index, free_left)
    // [687] bram_heap_set_left::s#0 = bram_heap_replace_free_with_heap::s#0 -- vbuyy=vbuz1 
    ldy.z s
    // [688] bram_heap_set_left::index#0 = bram_heap_replace_free_with_heap::return#2 -- vbuz1=vbuz2 
    lda.z return
    sta.z bram_heap_set_left.index
    // [689] bram_heap_set_left::left#0 = bram_heap_replace_free_with_heap::free_left#0 -- vbuxx=vbuz1 
    ldx.z free_left
    // [690] call bram_heap_set_left
    // [634] phi from bram_heap_replace_free_with_heap::@7 to bram_heap_set_left [phi:bram_heap_replace_free_with_heap::@7->bram_heap_set_left]
    // [634] phi bram_heap_set_left::index#6 = bram_heap_set_left::index#0 [phi:bram_heap_replace_free_with_heap::@7->bram_heap_set_left#0] -- register_copy 
    // [634] phi bram_heap_set_left::left#6 = bram_heap_set_left::left#0 [phi:bram_heap_replace_free_with_heap::@7->bram_heap_set_left#1] -- register_copy 
    // [634] phi bram_heap_set_left::s#6 = bram_heap_set_left::s#0 [phi:bram_heap_replace_free_with_heap::@7->bram_heap_set_left#2] -- register_copy 
    jsr bram_heap_set_left
    // bram_heap_replace_free_with_heap::@8
    // bram_heap_set_right(s, heap_index, free_right)
    // [691] bram_heap_set_right::s#0 = bram_heap_replace_free_with_heap::s#0 -- vbuyy=vbuz1 
    ldy.z s
    // [692] bram_heap_set_right::index#0 = bram_heap_replace_free_with_heap::return#2 -- vbuz1=vbuz2 
    lda.z return
    sta.z bram_heap_set_right.index
    // [693] bram_heap_set_right::right#0 = bram_heap_replace_free_with_heap::free_right#0 -- vbuxx=vbuz1 
    ldx.z free_right
    // [694] call bram_heap_set_right
    // [641] phi from bram_heap_replace_free_with_heap::@8 to bram_heap_set_right [phi:bram_heap_replace_free_with_heap::@8->bram_heap_set_right]
    // [641] phi bram_heap_set_right::index#6 = bram_heap_set_right::index#0 [phi:bram_heap_replace_free_with_heap::@8->bram_heap_set_right#0] -- register_copy 
    // [641] phi bram_heap_set_right::right#6 = bram_heap_set_right::right#0 [phi:bram_heap_replace_free_with_heap::@8->bram_heap_set_right#1] -- register_copy 
    // [641] phi bram_heap_set_right::s#6 = bram_heap_set_right::s#0 [phi:bram_heap_replace_free_with_heap::@8->bram_heap_set_right#2] -- register_copy 
    jsr bram_heap_set_right
    // bram_heap_replace_free_with_heap::@return
    // }
    // [695] return 
    rts
}
  // bram_heap_split_free_and_allocate
/**
 * Splits the header on two, returns the pointer to the smaller sub-header.
 */
// __register(A) char bram_heap_split_free_and_allocate(__zp($3a) char s, __zp($43) char free_index, __zp($16) unsigned int required_size)
bram_heap_split_free_and_allocate: {
    .label free_size = $18
    .label free_data = $2c
    .label heap_index = $42
    .label heap_left = $23
    .label s = $3a
    .label free_index = $43
    .label required_size = $16
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [696] bram_heap_get_size_packed::s#3 = bram_heap_split_free_and_allocate::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [697] bram_heap_get_size_packed::index#3 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [698] call bram_heap_get_size_packed
  // The free block is reduced in size with the required size.
    // [214] phi from bram_heap_split_free_and_allocate to bram_heap_get_size_packed [phi:bram_heap_split_free_and_allocate->bram_heap_get_size_packed]
    // [214] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#3 [phi:bram_heap_split_free_and_allocate->bram_heap_get_size_packed#0] -- register_copy 
    // [214] phi bram_heap_get_size_packed::s#8 = bram_heap_get_size_packed::s#3 [phi:bram_heap_split_free_and_allocate->bram_heap_get_size_packed#1] -- register_copy 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [699] bram_heap_get_size_packed::return#13 = bram_heap_get_size_packed::return#12
    // bram_heap_split_free_and_allocate::@1
    // [700] bram_heap_split_free_and_allocate::free_size#0 = bram_heap_get_size_packed::return#13
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [701] bram_heap_get_data_packed::s#2 = bram_heap_split_free_and_allocate::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [702] bram_heap_get_data_packed::index#2 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [703] call bram_heap_get_data_packed
    // [225] phi from bram_heap_split_free_and_allocate::@1 to bram_heap_get_data_packed [phi:bram_heap_split_free_and_allocate::@1->bram_heap_get_data_packed]
    // [225] phi bram_heap_get_data_packed::index#8 = bram_heap_get_data_packed::index#2 [phi:bram_heap_split_free_and_allocate::@1->bram_heap_get_data_packed#0] -- register_copy 
    // [225] phi bram_heap_get_data_packed::s#8 = bram_heap_get_data_packed::s#2 [phi:bram_heap_split_free_and_allocate::@1->bram_heap_get_data_packed#1] -- register_copy 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [704] bram_heap_get_data_packed::return#13 = bram_heap_get_data_packed::return#1 -- vwuz1=vwuz2 
    lda.z bram_heap_get_data_packed.return
    sta.z bram_heap_get_data_packed.return_2
    lda.z bram_heap_get_data_packed.return+1
    sta.z bram_heap_get_data_packed.return_2+1
    // bram_heap_split_free_and_allocate::@2
    // [705] bram_heap_split_free_and_allocate::free_data#0 = bram_heap_get_data_packed::return#13
    // bram_heap_set_size_packed(s, free_index, free_size - required_size)
    // [706] bram_heap_set_size_packed::size_packed#4 = bram_heap_split_free_and_allocate::free_size#0 - bram_heap_split_free_and_allocate::required_size#0 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z bram_heap_set_size_packed.size_packed
    sec
    sbc.z required_size
    sta.z bram_heap_set_size_packed.size_packed
    lda.z bram_heap_set_size_packed.size_packed+1
    sbc.z required_size+1
    sta.z bram_heap_set_size_packed.size_packed+1
    // [707] bram_heap_set_size_packed::s#4 = bram_heap_split_free_and_allocate::s#0 -- vbuxx=vbuz1 
    ldx.z s
    // [708] bram_heap_set_size_packed::index#4 = bram_heap_split_free_and_allocate::free_index#0 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_set_size_packed.index
    // [709] call bram_heap_set_size_packed
    // [500] phi from bram_heap_split_free_and_allocate::@2 to bram_heap_set_size_packed [phi:bram_heap_split_free_and_allocate::@2->bram_heap_set_size_packed]
    // [500] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#4 [phi:bram_heap_split_free_and_allocate::@2->bram_heap_set_size_packed#0] -- register_copy 
    // [500] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#4 [phi:bram_heap_split_free_and_allocate::@2->bram_heap_set_size_packed#1] -- register_copy 
    // [500] phi bram_heap_set_size_packed::s#6 = bram_heap_set_size_packed::s#4 [phi:bram_heap_split_free_and_allocate::@2->bram_heap_set_size_packed#2] -- register_copy 
    jsr bram_heap_set_size_packed
    // bram_heap_split_free_and_allocate::@3
    // bram_heap_set_data_packed(s, free_index, free_data + required_size)
    // [710] bram_heap_set_data_packed::data_packed#4 = bram_heap_split_free_and_allocate::free_data#0 + bram_heap_split_free_and_allocate::required_size#0 -- vwuz1=vwuz2_plus_vwuz3 
    lda.z free_data
    clc
    adc.z required_size
    sta.z bram_heap_set_data_packed.data_packed
    lda.z free_data+1
    adc.z required_size+1
    sta.z bram_heap_set_data_packed.data_packed+1
    // [711] bram_heap_set_data_packed::s#4 = bram_heap_split_free_and_allocate::s#0 -- vbuxx=vbuz1 
    ldx.z s
    // [712] bram_heap_set_data_packed::index#4 = bram_heap_split_free_and_allocate::free_index#0 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_set_data_packed.index
    // [713] call bram_heap_set_data_packed
    // [490] phi from bram_heap_split_free_and_allocate::@3 to bram_heap_set_data_packed [phi:bram_heap_split_free_and_allocate::@3->bram_heap_set_data_packed]
    // [490] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#4 [phi:bram_heap_split_free_and_allocate::@3->bram_heap_set_data_packed#0] -- register_copy 
    // [490] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#4 [phi:bram_heap_split_free_and_allocate::@3->bram_heap_set_data_packed#1] -- register_copy 
    // [490] phi bram_heap_set_data_packed::s#7 = bram_heap_set_data_packed::s#4 [phi:bram_heap_split_free_and_allocate::@3->bram_heap_set_data_packed#2] -- register_copy 
    jsr bram_heap_set_data_packed
    // bram_heap_split_free_and_allocate::@4
    // bram_heap_index_t heap_index = bram_heap_index_add(s)
    // [714] bram_heap_index_add::s#1 = bram_heap_split_free_and_allocate::s#0 -- vbuxx=vbuz1 
    ldx.z s
    // [715] call bram_heap_index_add
  // We create a new heap block with the required size.
  // The data is the offset in vram.
    // [442] phi from bram_heap_split_free_and_allocate::@4 to bram_heap_index_add [phi:bram_heap_split_free_and_allocate::@4->bram_heap_index_add]
    // [442] phi bram_heap_index_add::s#2 = bram_heap_index_add::s#1 [phi:bram_heap_split_free_and_allocate::@4->bram_heap_index_add#0] -- register_copy 
    jsr bram_heap_index_add
    // bram_heap_index_t heap_index = bram_heap_index_add(s)
    // [716] bram_heap_index_add::return#3 = bram_heap_index_add::return#1 -- vbuaa=vbuz1 
    lda.z bram_heap_index_add.return
    // bram_heap_split_free_and_allocate::@5
    // [717] bram_heap_split_free_and_allocate::heap_index#0 = bram_heap_index_add::return#3 -- vbuz1=vbuaa 
    sta.z heap_index
    // bram_heap_set_data_packed(s, heap_index, free_data)
    // [718] bram_heap_set_data_packed::s#5 = bram_heap_split_free_and_allocate::s#0 -- vbuxx=vbuz1 
    ldx.z s
    // [719] bram_heap_set_data_packed::index#5 = bram_heap_split_free_and_allocate::heap_index#0 -- vbuz1=vbuz2 
    sta.z bram_heap_set_data_packed.index
    // [720] bram_heap_set_data_packed::data_packed#5 = bram_heap_split_free_and_allocate::free_data#0 -- vwuz1=vwuz2 
    lda.z free_data
    sta.z bram_heap_set_data_packed.data_packed
    lda.z free_data+1
    sta.z bram_heap_set_data_packed.data_packed+1
    // [721] call bram_heap_set_data_packed
    // [490] phi from bram_heap_split_free_and_allocate::@5 to bram_heap_set_data_packed [phi:bram_heap_split_free_and_allocate::@5->bram_heap_set_data_packed]
    // [490] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#5 [phi:bram_heap_split_free_and_allocate::@5->bram_heap_set_data_packed#0] -- register_copy 
    // [490] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#5 [phi:bram_heap_split_free_and_allocate::@5->bram_heap_set_data_packed#1] -- register_copy 
    // [490] phi bram_heap_set_data_packed::s#7 = bram_heap_set_data_packed::s#5 [phi:bram_heap_split_free_and_allocate::@5->bram_heap_set_data_packed#2] -- register_copy 
    jsr bram_heap_set_data_packed
    // bram_heap_split_free_and_allocate::@6
    // bram_heap_heap_insert_at(s, heap_index, BRAM_HEAP_NULL, required_size)
    // [722] bram_heap_heap_insert_at::s#1 = bram_heap_split_free_and_allocate::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_heap_insert_at.s
    // [723] bram_heap_heap_insert_at::heap_index#1 = bram_heap_split_free_and_allocate::heap_index#0 -- vbuz1=vbuz2 
    lda.z heap_index
    sta.z bram_heap_heap_insert_at.heap_index
    // [724] bram_heap_heap_insert_at::size#1 = bram_heap_split_free_and_allocate::required_size#0 -- vwuz1=vwuz2 
    lda.z required_size
    sta.z bram_heap_heap_insert_at.size
    lda.z required_size+1
    sta.z bram_heap_heap_insert_at.size+1
    // [725] call bram_heap_heap_insert_at
    // [779] phi from bram_heap_split_free_and_allocate::@6 to bram_heap_heap_insert_at [phi:bram_heap_split_free_and_allocate::@6->bram_heap_heap_insert_at]
    // [779] phi bram_heap_heap_insert_at::size#2 = bram_heap_heap_insert_at::size#1 [phi:bram_heap_split_free_and_allocate::@6->bram_heap_heap_insert_at#0] -- register_copy 
    // [779] phi bram_heap_heap_insert_at::heap_index#2 = bram_heap_heap_insert_at::heap_index#1 [phi:bram_heap_split_free_and_allocate::@6->bram_heap_heap_insert_at#1] -- register_copy 
    // [779] phi bram_heap_heap_insert_at::s#2 = bram_heap_heap_insert_at::s#1 [phi:bram_heap_split_free_and_allocate::@6->bram_heap_heap_insert_at#2] -- register_copy 
    jsr bram_heap_heap_insert_at
    // bram_heap_split_free_and_allocate::@7
    // bram_heap_index_t heap_left = bram_heap_get_left(s, free_index)
    // [726] bram_heap_get_left::s#1 = bram_heap_split_free_and_allocate::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [727] bram_heap_get_left::index#1 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [728] call bram_heap_get_left
    // [581] phi from bram_heap_split_free_and_allocate::@7 to bram_heap_get_left [phi:bram_heap_split_free_and_allocate::@7->bram_heap_get_left]
    // [581] phi bram_heap_get_left::index#4 = bram_heap_get_left::index#1 [phi:bram_heap_split_free_and_allocate::@7->bram_heap_get_left#0] -- register_copy 
    // [581] phi bram_heap_get_left::s#4 = bram_heap_get_left::s#1 [phi:bram_heap_split_free_and_allocate::@7->bram_heap_get_left#1] -- register_copy 
    jsr bram_heap_get_left
    // bram_heap_index_t heap_left = bram_heap_get_left(s, free_index)
    // [729] bram_heap_get_left::return#3 = bram_heap_get_left::return#0
    // bram_heap_split_free_and_allocate::@8
    // [730] bram_heap_split_free_and_allocate::heap_left#0 = bram_heap_get_left::return#3 -- vbuz1=vbuaa 
    sta.z heap_left
    // bram_heap_set_left(s, heap_index, heap_left)
    // [731] bram_heap_set_left::s#1 = bram_heap_split_free_and_allocate::s#0 -- vbuyy=vbuz1 
    ldy.z s
    // [732] bram_heap_set_left::index#1 = bram_heap_split_free_and_allocate::heap_index#0 -- vbuz1=vbuz2 
    lda.z heap_index
    sta.z bram_heap_set_left.index
    // [733] bram_heap_set_left::left#1 = bram_heap_split_free_and_allocate::heap_left#0 -- vbuxx=vbuz1 
    ldx.z heap_left
    // [734] call bram_heap_set_left
    // [634] phi from bram_heap_split_free_and_allocate::@8 to bram_heap_set_left [phi:bram_heap_split_free_and_allocate::@8->bram_heap_set_left]
    // [634] phi bram_heap_set_left::index#6 = bram_heap_set_left::index#1 [phi:bram_heap_split_free_and_allocate::@8->bram_heap_set_left#0] -- register_copy 
    // [634] phi bram_heap_set_left::left#6 = bram_heap_set_left::left#1 [phi:bram_heap_split_free_and_allocate::@8->bram_heap_set_left#1] -- register_copy 
    // [634] phi bram_heap_set_left::s#6 = bram_heap_set_left::s#1 [phi:bram_heap_split_free_and_allocate::@8->bram_heap_set_left#2] -- register_copy 
    jsr bram_heap_set_left
    // bram_heap_split_free_and_allocate::@9
    // bram_heap_set_right(s, heap_index, heap_right)
    // [735] bram_heap_set_right::s#1 = bram_heap_split_free_and_allocate::s#0 -- vbuyy=vbuz1 
    ldy.z s
    // [736] bram_heap_set_right::index#1 = bram_heap_split_free_and_allocate::heap_index#0 -- vbuz1=vbuz2 
    lda.z heap_index
    sta.z bram_heap_set_right.index
    // [737] bram_heap_set_right::right#1 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [738] call bram_heap_set_right
  // printf("\nright = %03x", heap_right);
    // [641] phi from bram_heap_split_free_and_allocate::@9 to bram_heap_set_right [phi:bram_heap_split_free_and_allocate::@9->bram_heap_set_right]
    // [641] phi bram_heap_set_right::index#6 = bram_heap_set_right::index#1 [phi:bram_heap_split_free_and_allocate::@9->bram_heap_set_right#0] -- register_copy 
    // [641] phi bram_heap_set_right::right#6 = bram_heap_set_right::right#1 [phi:bram_heap_split_free_and_allocate::@9->bram_heap_set_right#1] -- register_copy 
    // [641] phi bram_heap_set_right::s#6 = bram_heap_set_right::s#1 [phi:bram_heap_split_free_and_allocate::@9->bram_heap_set_right#2] -- register_copy 
    jsr bram_heap_set_right
    // bram_heap_split_free_and_allocate::@10
    // bram_heap_set_right(s, heap_left, heap_index)
    // [739] bram_heap_set_right::s#2 = bram_heap_split_free_and_allocate::s#0 -- vbuyy=vbuz1 
    ldy.z s
    // [740] bram_heap_set_right::index#2 = bram_heap_split_free_and_allocate::heap_left#0 -- vbuz1=vbuz2 
    lda.z heap_left
    sta.z bram_heap_set_right.index
    // [741] bram_heap_set_right::right#2 = bram_heap_split_free_and_allocate::heap_index#0 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [742] call bram_heap_set_right
    // [641] phi from bram_heap_split_free_and_allocate::@10 to bram_heap_set_right [phi:bram_heap_split_free_and_allocate::@10->bram_heap_set_right]
    // [641] phi bram_heap_set_right::index#6 = bram_heap_set_right::index#2 [phi:bram_heap_split_free_and_allocate::@10->bram_heap_set_right#0] -- register_copy 
    // [641] phi bram_heap_set_right::right#6 = bram_heap_set_right::right#2 [phi:bram_heap_split_free_and_allocate::@10->bram_heap_set_right#1] -- register_copy 
    // [641] phi bram_heap_set_right::s#6 = bram_heap_set_right::s#2 [phi:bram_heap_split_free_and_allocate::@10->bram_heap_set_right#2] -- register_copy 
    jsr bram_heap_set_right
    // bram_heap_split_free_and_allocate::@11
    // bram_heap_set_left(s, heap_right, heap_index)
    // [743] bram_heap_set_left::s#2 = bram_heap_split_free_and_allocate::s#0 -- vbuyy=vbuz1 
    ldy.z s
    // [744] bram_heap_set_left::index#2 = bram_heap_split_free_and_allocate::free_index#0 -- vbuz1=vbuz2 
    lda.z free_index
    sta.z bram_heap_set_left.index
    // [745] bram_heap_set_left::left#2 = bram_heap_split_free_and_allocate::heap_index#0 -- vbuxx=vbuz1 
    ldx.z heap_index
    // [746] call bram_heap_set_left
    // [634] phi from bram_heap_split_free_and_allocate::@11 to bram_heap_set_left [phi:bram_heap_split_free_and_allocate::@11->bram_heap_set_left]
    // [634] phi bram_heap_set_left::index#6 = bram_heap_set_left::index#2 [phi:bram_heap_split_free_and_allocate::@11->bram_heap_set_left#0] -- register_copy 
    // [634] phi bram_heap_set_left::left#6 = bram_heap_set_left::left#2 [phi:bram_heap_split_free_and_allocate::@11->bram_heap_set_left#1] -- register_copy 
    // [634] phi bram_heap_set_left::s#6 = bram_heap_set_left::s#2 [phi:bram_heap_split_free_and_allocate::@11->bram_heap_set_left#2] -- register_copy 
    jsr bram_heap_set_left
    // bram_heap_split_free_and_allocate::@12
    // bram_heap_set_free(s, heap_right)
    // [747] bram_heap_set_free::s#2 = bram_heap_split_free_and_allocate::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [748] bram_heap_set_free::index#2 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbuz1 
    ldx.z free_index
    // [749] call bram_heap_set_free
    // [512] phi from bram_heap_split_free_and_allocate::@12 to bram_heap_set_free [phi:bram_heap_split_free_and_allocate::@12->bram_heap_set_free]
    // [512] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#2 [phi:bram_heap_split_free_and_allocate::@12->bram_heap_set_free#0] -- register_copy 
    // [512] phi bram_heap_set_free::s#5 = bram_heap_set_free::s#2 [phi:bram_heap_split_free_and_allocate::@12->bram_heap_set_free#1] -- register_copy 
    jsr bram_heap_set_free
    // bram_heap_split_free_and_allocate::@13
    // bram_heap_clear_free(s, heap_left)
    // [750] bram_heap_clear_free::s#1 = bram_heap_split_free_and_allocate::s#0 -- vbuaa=vbuz1 
    lda.z s
    // [751] bram_heap_clear_free::index#1 = bram_heap_split_free_and_allocate::heap_left#0 -- vbuxx=vbuz1 
    ldx.z heap_left
    // [752] call bram_heap_clear_free
    // [771] phi from bram_heap_split_free_and_allocate::@13 to bram_heap_clear_free [phi:bram_heap_split_free_and_allocate::@13->bram_heap_clear_free]
    // [771] phi bram_heap_clear_free::index#2 = bram_heap_clear_free::index#1 [phi:bram_heap_split_free_and_allocate::@13->bram_heap_clear_free#0] -- register_copy 
    // [771] phi bram_heap_clear_free::s#2 = bram_heap_clear_free::s#1 [phi:bram_heap_split_free_and_allocate::@13->bram_heap_clear_free#1] -- register_copy 
    jsr bram_heap_clear_free
    // bram_heap_split_free_and_allocate::@return
    // }
    // [753] return 
    rts
}
  // heap_idle_remove
// void heap_idle_remove(__zp($1b) char s, __zp($e) char idle_index)
heap_idle_remove: {
    .label s = $1b
    .label idle_index = $e
    // bram_heap_segment.idleCount[s]--;
    // [754] heap_idle_remove::$3 = heap_idle_remove::s#0 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [755] ((unsigned int *)&bram_heap_segment+$29)[heap_idle_remove::$3] = -- ((unsigned int *)&bram_heap_segment+$29)[heap_idle_remove::$3] -- pwuc1_derefidx_vbuaa=_dec_pwuc1_derefidx_vbuaa 
    tax
    lda bram_heap_segment+$29,x
    bne !+
    dec bram_heap_segment+$29+1,x
  !:
    dec bram_heap_segment+$29,x
    // bram_heap_list_remove(s, bram_heap_segment.idle_list[s], idle_index)
    // [756] bram_heap_list_remove::s#2 = heap_idle_remove::s#0 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_list_remove.s
    // [757] bram_heap_list_remove::list#4 = ((char *)&bram_heap_segment+$1b)[heap_idle_remove::s#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda bram_heap_segment+$1b,y
    sta.z bram_heap_list_remove.list
    // [758] bram_heap_list_remove::index#2 = heap_idle_remove::idle_index#0
    // [759] call bram_heap_list_remove
    // [540] phi from heap_idle_remove to bram_heap_list_remove [phi:heap_idle_remove->bram_heap_list_remove]
    // [540] phi bram_heap_list_remove::index#10 = bram_heap_list_remove::index#2 [phi:heap_idle_remove->bram_heap_list_remove#0] -- register_copy 
    // [540] phi bram_heap_list_remove::s#10 = bram_heap_list_remove::s#2 [phi:heap_idle_remove->bram_heap_list_remove#1] -- register_copy 
    // [540] phi bram_heap_list_remove::list#10 = bram_heap_list_remove::list#4 [phi:heap_idle_remove->bram_heap_list_remove#2] -- register_copy 
    jsr bram_heap_list_remove
    // bram_heap_list_remove(s, bram_heap_segment.idle_list[s], idle_index)
    // [760] bram_heap_list_remove::return#10 = bram_heap_list_remove::return#1 -- vbuaa=vbuz1 
    lda.z bram_heap_list_remove.return
    // heap_idle_remove::@1
    // [761] heap_idle_remove::$1 = bram_heap_list_remove::return#10
    // bram_heap_segment.idle_list[s] = bram_heap_list_remove(s, bram_heap_segment.idle_list[s], idle_index)
    // [762] ((char *)&bram_heap_segment+$1b)[heap_idle_remove::s#0] = heap_idle_remove::$1 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z s
    sta bram_heap_segment+$1b,y
    // heap_idle_remove::@return
    // }
    // [763] return 
    rts
}
  // bram_heap_get_prev
/*inline*/
// __register(A) char bram_heap_get_prev(__register(A) char s, __register(X) char index)
bram_heap_get_prev: {
    .label bram_heap_get_prev__1 = 2
    .label bram_heap_get_prev__2 = 2
    .label bram_heap_get_prev__3 = 2
    .label bram_heap_map = 2
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [765] bram_heap_get_prev::$3 = (unsigned int)bram_heap_get_prev::s#2 -- vwuz1=_word_vbuaa 
    sta.z bram_heap_get_prev__3
    lda #0
    sta.z bram_heap_get_prev__3+1
    // [766] bram_heap_get_prev::$1 = bram_heap_get_prev::$3 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_get_prev__1
    rol.z bram_heap_get_prev__1+1
    dey
    bne !-
  !e:
    // [767] bram_heap_get_prev::bram_heap_map#0 = bram_heap_index + bram_heap_get_prev::$1 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // return bram_heap_map->prev[index];
    // [768] bram_heap_get_prev::$2 = (char *)bram_heap_get_prev::bram_heap_map#0 + $500 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_get_prev__2
    clc
    adc #<$500
    sta.z bram_heap_get_prev__2
    lda.z bram_heap_get_prev__2+1
    adc #>$500
    sta.z bram_heap_get_prev__2+1
    // [769] bram_heap_get_prev::return#1 = bram_heap_get_prev::$2[bram_heap_get_prev::index#2] -- vbuaa=pbuz1_derefidx_vbuxx 
    txa
    tay
    lda (bram_heap_get_prev__2),y
    // bram_heap_get_prev::@return
    // }
    // [770] return 
    rts
}
  // bram_heap_clear_free
// void bram_heap_clear_free(__register(A) char s, __register(X) char index)
bram_heap_clear_free: {
    .label bram_heap_clear_free__1 = $b
    .label bram_heap_clear_free__2 = 2
    .label bram_heap_clear_free__3 = $b
    .label bram_heap_clear_free__4 = $b
    .label bram_heap_map = $b
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [772] bram_heap_clear_free::$4 = (unsigned int)bram_heap_clear_free::s#2 -- vwuz1=_word_vbuaa 
    sta.z bram_heap_clear_free__4
    lda #0
    sta.z bram_heap_clear_free__4+1
    // [773] bram_heap_clear_free::$1 = bram_heap_clear_free::$4 << $b -- vwuz1=vwuz1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl.z bram_heap_clear_free__1
    rol.z bram_heap_clear_free__1+1
    dey
    bne !-
  !e:
    // [774] bram_heap_clear_free::bram_heap_map#0 = bram_heap_index + bram_heap_clear_free::$1 -- pssz1=pssc1_plus_vwuz1 
    lda.z bram_heap_map
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda.z bram_heap_map+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->size1[index] &= 0x7F
    // [775] bram_heap_clear_free::$2 = (char *)bram_heap_clear_free::bram_heap_map#0 + $300 -- pbuz1=pbuz2_plus_vwuc1 
    lda.z bram_heap_map
    clc
    adc #<$300
    sta.z bram_heap_clear_free__2
    lda.z bram_heap_map+1
    adc #>$300
    sta.z bram_heap_clear_free__2+1
    // [776] bram_heap_clear_free::$3 = (char *)bram_heap_clear_free::bram_heap_map#0 + $300 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_clear_free__3
    clc
    adc #<$300
    sta.z bram_heap_clear_free__3
    lda.z bram_heap_clear_free__3+1
    adc #>$300
    sta.z bram_heap_clear_free__3+1
    // [777] bram_heap_clear_free::$3[bram_heap_clear_free::index#2] = bram_heap_clear_free::$2[bram_heap_clear_free::index#2] & $7f -- pbuz1_derefidx_vbuxx=pbuz2_derefidx_vbuxx_band_vbuc1 
    txa
    tay
    lda #$7f
    and (bram_heap_clear_free__2),y
    sta (bram_heap_clear_free__3),y
    // bram_heap_clear_free::@return
    // }
    // [778] return 
    rts
}
  // bram_heap_heap_insert_at
// char bram_heap_heap_insert_at(__zp($22) char s, __zp($1c) char heap_index, char at, __zp($18) unsigned int size)
bram_heap_heap_insert_at: {
    .label s = $22
    .label heap_index = $1c
    .label size = $18
    // bram_heap_list_insert_at(s, bram_heap_segment.heap_list[s], heap_index, at)
    // [780] bram_heap_list_insert_at::s#1 = bram_heap_heap_insert_at::s#2 -- vbuz1=vbuz2 
    lda.z s
    sta.z bram_heap_list_insert_at.s
    // [781] bram_heap_list_insert_at::list#1 = ((char *)&bram_heap_segment+$17)[bram_heap_heap_insert_at::s#2] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z s
    lda bram_heap_segment+$17,y
    sta.z bram_heap_list_insert_at.list
    // [782] bram_heap_list_insert_at::index#1 = bram_heap_heap_insert_at::heap_index#2 -- vbuz1=vbuz2 
    lda.z heap_index
    sta.z bram_heap_list_insert_at.index
    // [783] call bram_heap_list_insert_at
    // [453] phi from bram_heap_heap_insert_at to bram_heap_list_insert_at [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at]
    // [453] phi bram_heap_list_insert_at::s#10 = bram_heap_list_insert_at::s#1 [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at#0] -- register_copy 
    // [453] phi bram_heap_list_insert_at::index#10 = bram_heap_list_insert_at::index#1 [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at#1] -- register_copy 
    // [453] phi bram_heap_list_insert_at::at#10 = $ff [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at#2] -- vbuz1=vbuc1 
    lda #$ff
    sta.z bram_heap_list_insert_at.at
    // [453] phi bram_heap_list_insert_at::list#5 = bram_heap_list_insert_at::list#1 [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at#3] -- register_copy 
    jsr bram_heap_list_insert_at
    // bram_heap_list_insert_at(s, bram_heap_segment.heap_list[s], heap_index, at)
    // [784] bram_heap_list_insert_at::return#1 = bram_heap_list_insert_at::list#11 -- vbuaa=vbuz1 
    lda.z bram_heap_list_insert_at.list
    // bram_heap_heap_insert_at::@1
    // [785] bram_heap_heap_insert_at::$0 = bram_heap_list_insert_at::return#1
    // bram_heap_segment.heap_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.heap_list[s], heap_index, at)
    // [786] ((char *)&bram_heap_segment+$17)[bram_heap_heap_insert_at::s#2] = bram_heap_heap_insert_at::$0 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z s
    sta bram_heap_segment+$17,y
    // bram_heap_set_size_packed(s, heap_index, size)
    // [787] bram_heap_set_size_packed::s#1 = bram_heap_heap_insert_at::s#2 -- vbuxx=vbuz1 
    ldx.z s
    // [788] bram_heap_set_size_packed::index#1 = bram_heap_heap_insert_at::heap_index#2
    // [789] bram_heap_set_size_packed::size_packed#1 = bram_heap_heap_insert_at::size#2
    // [790] call bram_heap_set_size_packed
    // [500] phi from bram_heap_heap_insert_at::@1 to bram_heap_set_size_packed [phi:bram_heap_heap_insert_at::@1->bram_heap_set_size_packed]
    // [500] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#1 [phi:bram_heap_heap_insert_at::@1->bram_heap_set_size_packed#0] -- register_copy 
    // [500] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#1 [phi:bram_heap_heap_insert_at::@1->bram_heap_set_size_packed#1] -- register_copy 
    // [500] phi bram_heap_set_size_packed::s#6 = bram_heap_set_size_packed::s#1 [phi:bram_heap_heap_insert_at::@1->bram_heap_set_size_packed#2] -- register_copy 
    jsr bram_heap_set_size_packed
    // bram_heap_heap_insert_at::@2
    // bram_heap_segment.heapCount[s]++;
    // [791] bram_heap_heap_insert_at::$4 = bram_heap_heap_insert_at::s#2 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [792] ((unsigned int *)&bram_heap_segment+$21)[bram_heap_heap_insert_at::$4] = ++ ((unsigned int *)&bram_heap_segment+$21)[bram_heap_heap_insert_at::$4] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc bram_heap_segment+$21,x
    bne !+
    inc bram_heap_segment+$21+1,x
  !:
    // bram_heap_heap_insert_at::@return
    // }
    // [793] return 
    rts
}
  // File Data
.segment BramBramHeap
  bram_heap_index: .fill $800*2, 0
.segment DataBramHeap
  bram_heap_segment: .fill SIZEOF_STRUCT___3, 0
}
