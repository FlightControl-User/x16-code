

  // Global Constants & labels
  .const SIZEOF_UNSIGNED_INT = 2
  .const SIZEOF_CHAR = 1
  .const STACK_BASE = $103
  .const isr_vsync = $314
  .const SIZEOF_STRUCT___0 = $384
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
    // [223] phi from __start::@1 to main [phi:__start::@1->main] -- call_phi_near 
    jsr main
    // __start::@return
    // [5] return 
    rts
}
.segment CodeLruCache
  // lru_cache_delete
// __mem() unsigned int lru_cache_delete(__mem() unsigned int key)
lru_cache_delete: {
    .const OFFSET_STACK_KEY = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [6] lru_cache_delete::key#0 = stackidx(unsigned int,lru_cache_delete::OFFSET_STACK_KEY) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_KEY,x
    sta key
    lda STACK_BASE+OFFSET_STACK_KEY+1,x
    sta key+1
    // lru_cache_index_t index = lru_cache_hash(key)
    // [7] lru_cache_hash::key#2 = lru_cache_delete::key#0 -- vwum1=vwum2 
    lda key
    sta lru_cache_hash.key
    lda key+1
    sta lru_cache_hash.key+1
    // [8] call lru_cache_hash
    // [225] phi from lru_cache_delete to lru_cache_hash [phi:lru_cache_delete->lru_cache_hash]
    // [225] phi lru_cache_hash::key#4 = lru_cache_hash::key#2 [phi:lru_cache_delete->lru_cache_hash#0] -- call_phi_near 
    jsr lru_cache_hash
    // lru_cache_index_t index = lru_cache_hash(key)
    // [9] lru_cache_hash::return#4 = lru_cache_hash::return#0 -- vbum1=vbum2 
    lda lru_cache_hash.return
    sta lru_cache_hash.return_3
    // lru_cache_delete::@14
    // [10] lru_cache_delete::index#0 = lru_cache_hash::return#4 -- vbum1=vbum2 
    sta index
    // [11] phi from lru_cache_delete::@14 to lru_cache_delete::@1 [phi:lru_cache_delete::@14->lru_cache_delete::@1]
    // [11] phi lru_cache_delete::index_prev#10 = $ff [phi:lru_cache_delete::@14->lru_cache_delete::@1#0] -- vbum1=vbuc1 
    lda #$ff
    sta index_prev
    // [11] phi lru_cache_delete::index#2 = lru_cache_delete::index#0 [phi:lru_cache_delete::@14->lru_cache_delete::@1#1] -- register_copy 
    // lru_cache_delete::@1
  __b1:
    // lru_cache.key[index] != LRU_CACHE_NOTHING
    // [12] lru_cache_delete::$16 = lru_cache_delete::index#2 << 1 -- vbum1=vbum2_rol_1 
    lda index
    asl
    sta lru_cache_delete__16
    // while (lru_cache.key[index] != LRU_CACHE_NOTHING)
    // [13] if(((unsigned int *)&lru_cache)[lru_cache_delete::$16]!=$ffff) goto lru_cache_delete::@2 -- pwuc1_derefidx_vbum1_neq_vwuc2_then_la1 
    tay
    lda lru_cache+1,y
    cmp #>$ffff
    bne __b2
    lda lru_cache,y
    cmp #<$ffff
    bne __b2
    // [14] phi from lru_cache_delete::@1 to lru_cache_delete::@return [phi:lru_cache_delete::@1->lru_cache_delete::@return]
    // [14] phi lru_cache_delete::return#2 = $ffff [phi:lru_cache_delete::@1->lru_cache_delete::@return#0] -- vwum1=vwuc1 
    lda #<$ffff
    sta return
    lda #>$ffff
    sta return+1
    // lru_cache_delete::@return
  __breturn:
    // }
    // [15] stackidx(unsigned int,lru_cache_delete::OFFSET_STACK_RETURN_0) = lru_cache_delete::return#2 -- _stackidxword_vbuc1=vwum1 
    tsx
    lda return
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [16] return 
    rts
    // lru_cache_delete::@2
  __b2:
    // if (lru_cache.key[index] == key)
    // [17] if(((unsigned int *)&lru_cache)[lru_cache_delete::$16]!=lru_cache_delete::key#0) goto lru_cache_delete::@3 -- pwuc1_derefidx_vbum1_neq_vwum2_then_la1 
    ldy lru_cache_delete__16
    lda key+1
    cmp lru_cache+1,y
    beq !__b3+
    jmp __b3
  !__b3:
    lda key
    cmp lru_cache,y
    beq !__b3+
    jmp __b3
  !__b3:
    // lru_cache_delete::@11
    // lru_cache_data_t data = lru_cache.data[index]
    // [18] lru_cache_delete::data#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_delete::$16] -- vwum1=pwuc1_derefidx_vbum2 
    lda lru_cache+$100,y
    sta data
    lda lru_cache+$100+1,y
    sta data+1
    // lru_cache.key[index] = LRU_CACHE_NOTHING
    // [19] ((unsigned int *)&lru_cache)[lru_cache_delete::$16] = $ffff -- pwuc1_derefidx_vbum1=vwuc2 
    // First remove the index node.
    lda #<$ffff
    sta lru_cache,y
    lda #>$ffff
    sta lru_cache+1,y
    // lru_cache.data[index] = LRU_CACHE_NOTHING
    // [20] ((unsigned int *)&lru_cache+$100)[lru_cache_delete::$16] = $ffff -- pwuc1_derefidx_vbum1=vwuc2 
    lda #<$ffff
    sta lru_cache+$100,y
    lda #>$ffff
    sta lru_cache+$100+1,y
    // lru_cache_index_t next = lru_cache.next[index]
    // [21] lru_cache_delete::next#0 = ((char *)&lru_cache+$280)[lru_cache_delete::index#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy index
    lda lru_cache+$280,y
    sta next
    // lru_cache_index_t prev = lru_cache.prev[index]
    // [22] lru_cache_delete::prev#0 = ((char *)&lru_cache+$200)[lru_cache_delete::index#2] -- vbum1=pbuc1_derefidx_vbum2 
    lda lru_cache+$200,y
    sta prev
    // lru_cache.next[index] = LRU_CACHE_INDEX_NULL
    // [23] ((char *)&lru_cache+$280)[lru_cache_delete::index#2] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    lda #$ff
    sta lru_cache+$280,y
    // lru_cache.prev[index] = LRU_CACHE_INDEX_NULL
    // [24] ((char *)&lru_cache+$200)[lru_cache_delete::index#2] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta lru_cache+$200,y
    // if (lru_cache.next[index] == index)
    // [25] if(((char *)&lru_cache+$280)[lru_cache_delete::index#2]==lru_cache_delete::index#2) goto lru_cache_delete::@4 -- pbuc1_derefidx_vbum1_eq_vbum1_then_la1 
    lda lru_cache+$280,y
    cmp index
    bne !__b4+
    jmp __b4
  !__b4:
    // lru_cache_delete::@12
    // lru_cache.next[prev] = next
    // [26] ((char *)&lru_cache+$280)[lru_cache_delete::prev#0] = lru_cache_delete::next#0 -- pbuc1_derefidx_vbum1=vbum2 
    // Delete the node from the list.
    lda next
    ldy prev
    sta lru_cache+$280,y
    // lru_cache.prev[next] = prev
    // [27] ((char *)&lru_cache+$200)[lru_cache_delete::next#0] = lru_cache_delete::prev#0 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy next
    sta lru_cache+$200,y
    // if (index == lru_cache.first)
    // [28] if(lru_cache_delete::index#2!=*((char *)&lru_cache+$381)) goto lru_cache_delete::@5 -- vbum1_neq__deref_pbuc1_then_la1 
    lda lru_cache+$381
    cmp index
    bne __b5
    // lru_cache_delete::@13
    // lru_cache.first = next
    // [29] *((char *)&lru_cache+$381) = lru_cache_delete::next#0 -- _deref_pbuc1=vbum1 
    tya
    sta lru_cache+$381
    // lru_cache_delete::@5
  __b5:
    // if (index == lru_cache.last)
    // [30] if(lru_cache_delete::index#2!=*((char *)&lru_cache+$382)) goto lru_cache_delete::@7 -- vbum1_neq__deref_pbuc1_then_la1 
    lda lru_cache+$382
    cmp index
    bne __b7
    // lru_cache_delete::@6
    // lru_cache.last = prev
    // [31] *((char *)&lru_cache+$382) = lru_cache_delete::prev#0 -- _deref_pbuc1=vbum1 
    lda prev
    sta lru_cache+$382
    // lru_cache_delete::@7
  __b7:
    // lru_cache_index_t link = lru_cache.link[index]
    // [32] lru_cache_delete::lru_cache_move_link1_index#0 = ((char *)&lru_cache+$300)[lru_cache_delete::index#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy index
    lda lru_cache+$300,y
    sta lru_cache_move_link1_index
    // if (index_prev != LRU_CACHE_INDEX_NULL)
    // [33] if(lru_cache_delete::index_prev#10==$ff) goto lru_cache_delete::@8 -- vbum1_eq_vbuc1_then_la1 
    lda #$ff
    cmp index_prev
    beq __b8
    // lru_cache_delete::@10
    // lru_cache.link[index_prev] = link
    // [34] ((char *)&lru_cache+$300)[lru_cache_delete::index_prev#10] = lru_cache_delete::lru_cache_move_link1_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    // The node is not the first node but the middle of a list.
    lda lru_cache_move_link1_index
    ldy index_prev
    sta lru_cache+$300,y
    // lru_cache_delete::@8
  __b8:
    // if (link != LRU_CACHE_INDEX_NULL)
    // [35] if(lru_cache_delete::lru_cache_move_link1_index#0==$ff) goto lru_cache_delete::@9 -- vbum1_eq_vbuc1_then_la1 
    lda #$ff
    cmp lru_cache_move_link1_index
    bne !__b9+
    jmp __b9
  !__b9:
    // lru_cache_delete::lru_cache_move_link1
    // lru_cache_index_t l = lru_cache.link[index]
    // [36] lru_cache_delete::lru_cache_move_link1_l#0 = ((char *)&lru_cache+$300)[lru_cache_delete::lru_cache_move_link1_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy lru_cache_move_link1_index
    lda lru_cache+$300,y
    sta lru_cache_move_link1_l
    // lru_cache.link[link] = l
    // [37] ((char *)&lru_cache+$300)[lru_cache_delete::index#2] = lru_cache_delete::lru_cache_move_link1_l#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy index
    sta lru_cache+$300,y
    // lru_cache_key_t key = lru_cache.key[index]
    // [38] lru_cache_delete::lru_cache_move_link1_$9 = lru_cache_delete::lru_cache_move_link1_index#0 << 1 -- vbum1=vbum2_rol_1 
    lda lru_cache_move_link1_index
    asl
    sta lru_cache_move_link1_lru_cache_delete__9
    // [39] lru_cache_delete::lru_cache_move_link1_key#0 = ((unsigned int *)&lru_cache)[lru_cache_delete::lru_cache_move_link1_$9] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda lru_cache,y
    sta lru_cache_move_link1_key
    lda lru_cache+1,y
    sta lru_cache_move_link1_key+1
    // lru_cache.key[link] = key
    // [40] ((unsigned int *)&lru_cache)[lru_cache_delete::$16] = lru_cache_delete::lru_cache_move_link1_key#0 -- pwuc1_derefidx_vbum1=vwum2 
    ldy lru_cache_delete__16
    lda lru_cache_move_link1_key
    sta lru_cache,y
    lda lru_cache_move_link1_key+1
    sta lru_cache+1,y
    // lru_cache_data_t data = lru_cache.data[index]
    // [41] lru_cache_delete::lru_cache_move_link1_data#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_delete::lru_cache_move_link1_$9] -- vwum1=pwuc1_derefidx_vbum2 
    ldy lru_cache_move_link1_lru_cache_delete__9
    lda lru_cache+$100,y
    sta lru_cache_move_link1_data
    lda lru_cache+$100+1,y
    sta lru_cache_move_link1_data+1
    // lru_cache.data[link] = data
    // [42] ((unsigned int *)&lru_cache+$100)[lru_cache_delete::$16] = lru_cache_delete::lru_cache_move_link1_data#0 -- pwuc1_derefidx_vbum1=vwum2 
    ldy lru_cache_delete__16
    lda lru_cache_move_link1_data
    sta lru_cache+$100,y
    lda lru_cache_move_link1_data+1
    sta lru_cache+$100+1,y
    // lru_cache_index_t next = lru_cache.next[index]
    // [43] lru_cache_delete::lru_cache_move_link1_next#0 = ((char *)&lru_cache+$280)[lru_cache_delete::lru_cache_move_link1_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy lru_cache_move_link1_index
    lda lru_cache+$280,y
    sta lru_cache_move_link1_next
    // lru_cache_index_t prev = lru_cache.prev[index]
    // [44] lru_cache_delete::lru_cache_move_link1_prev#0 = ((char *)&lru_cache+$200)[lru_cache_delete::lru_cache_move_link1_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda lru_cache+$200,y
    sta lru_cache_move_link1_prev
    // lru_cache.next[link] = next
    // [45] ((char *)&lru_cache+$280)[lru_cache_delete::index#2] = lru_cache_delete::lru_cache_move_link1_next#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda lru_cache_move_link1_next
    ldy index
    sta lru_cache+$280,y
    // lru_cache.prev[link] = prev
    // [46] ((char *)&lru_cache+$200)[lru_cache_delete::index#2] = lru_cache_delete::lru_cache_move_link1_prev#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda lru_cache_move_link1_prev
    sta lru_cache+$200,y
    // lru_cache.next[prev] = link
    // [47] ((char *)&lru_cache+$280)[lru_cache_delete::lru_cache_move_link1_prev#0] = lru_cache_delete::index#2 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy lru_cache_move_link1_prev
    sta lru_cache+$280,y
    // lru_cache.prev[next] = link
    // [48] ((char *)&lru_cache+$200)[lru_cache_delete::lru_cache_move_link1_next#0] = lru_cache_delete::index#2 -- pbuc1_derefidx_vbum1=vbum2 
    ldy lru_cache_move_link1_next
    sta lru_cache+$200,y
    // if (lru_cache.last == index)
    // [49] if(*((char *)&lru_cache+$382)!=lru_cache_delete::lru_cache_move_link1_index#0) goto lru_cache_delete::lru_cache_move_link1_@1 -- _deref_pbuc1_neq_vbum1_then_la1 
    lda lru_cache+$382
    cmp lru_cache_move_link1_index
    bne lru_cache_move_link1___b1
    // lru_cache_delete::lru_cache_move_link1_@3
    // lru_cache.last = link
    // [50] *((char *)&lru_cache+$382) = lru_cache_delete::index#2 -- _deref_pbuc1=vbum1 
    lda index
    sta lru_cache+$382
    // lru_cache_delete::lru_cache_move_link1_@1
  lru_cache_move_link1___b1:
    // if (lru_cache.first == index)
    // [51] if(*((char *)&lru_cache+$381)!=lru_cache_delete::lru_cache_move_link1_index#0) goto lru_cache_delete::lru_cache_move_link1_@2 -- _deref_pbuc1_neq_vbum1_then_la1 
    lda lru_cache+$381
    cmp lru_cache_move_link1_index
    bne lru_cache_move_link1___b2
    // lru_cache_delete::lru_cache_move_link1_@4
    // lru_cache.first = link
    // [52] *((char *)&lru_cache+$381) = lru_cache_delete::index#2 -- _deref_pbuc1=vbum1 
    lda index
    sta lru_cache+$381
    // lru_cache_delete::lru_cache_move_link1_@2
  lru_cache_move_link1___b2:
    // lru_cache.key[index] = LRU_CACHE_NOTHING
    // [53] ((unsigned int *)&lru_cache)[lru_cache_delete::lru_cache_move_link1_$9] = $ffff -- pwuc1_derefidx_vbum1=vwuc2 
    ldy lru_cache_move_link1_lru_cache_delete__9
    lda #<$ffff
    sta lru_cache,y
    lda #>$ffff
    sta lru_cache+1,y
    // lru_cache.data[index] = LRU_CACHE_NOTHING
    // [54] ((unsigned int *)&lru_cache+$100)[lru_cache_delete::lru_cache_move_link1_$9] = $ffff -- pwuc1_derefidx_vbum1=vwuc2 
    lda #<$ffff
    sta lru_cache+$100,y
    lda #>$ffff
    sta lru_cache+$100+1,y
    // lru_cache.next[index] = LRU_CACHE_INDEX_NULL
    // [55] ((char *)&lru_cache+$280)[lru_cache_delete::lru_cache_move_link1_index#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    lda #$ff
    ldy lru_cache_move_link1_index
    sta lru_cache+$280,y
    // lru_cache.prev[index] = LRU_CACHE_INDEX_NULL
    // [56] ((char *)&lru_cache+$200)[lru_cache_delete::lru_cache_move_link1_index#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta lru_cache+$200,y
    // lru_cache.link[index] = LRU_CACHE_INDEX_NULL
    // [57] ((char *)&lru_cache+$300)[lru_cache_delete::lru_cache_move_link1_index#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta lru_cache+$300,y
    // lru_cache_delete::@9
  __b9:
    // lru_cache.count--;
    // [58] *((char *)&lru_cache+$380) = -- *((char *)&lru_cache+$380) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec lru_cache+$380
    // [14] phi from lru_cache_delete::@9 to lru_cache_delete::@return [phi:lru_cache_delete::@9->lru_cache_delete::@return]
    // [14] phi lru_cache_delete::return#2 = lru_cache_delete::data#0 [phi:lru_cache_delete::@9->lru_cache_delete::@return#0] -- register_copy 
    jmp __breturn
    // lru_cache_delete::@4
  __b4:
    // lru_cache.first = 0xff
    // [59] *((char *)&lru_cache+$381) = $ff -- _deref_pbuc1=vbuc2 
    // Reset first and last node.
    lda #$ff
    sta lru_cache+$381
    // lru_cache.last = 0xff
    // [60] *((char *)&lru_cache+$382) = $ff -- _deref_pbuc1=vbuc2 
    sta lru_cache+$382
    jmp __b7
    // lru_cache_delete::@3
  __b3:
    // index_prev = index
    // [61] lru_cache_delete::index_prev#1 = lru_cache_delete::index#2 -- vbum1=vbum2 
    lda index
    sta index_prev
    // index = lru_cache.link[index]
    // [62] lru_cache_delete::index#1 = ((char *)&lru_cache+$300)[lru_cache_delete::index#2] -- vbum1=pbuc1_derefidx_vbum1 
    ldy index
    lda lru_cache+$300,y
    sta index
    // [11] phi from lru_cache_delete::@3 to lru_cache_delete::@1 [phi:lru_cache_delete::@3->lru_cache_delete::@1]
    // [11] phi lru_cache_delete::index_prev#10 = lru_cache_delete::index_prev#1 [phi:lru_cache_delete::@3->lru_cache_delete::@1#0] -- register_copy 
    // [11] phi lru_cache_delete::index#2 = lru_cache_delete::index#1 [phi:lru_cache_delete::@3->lru_cache_delete::@1#1] -- register_copy 
    jmp __b1
    lru_cache_delete__16: .byte 0
    lru_cache_move_link1_lru_cache_delete__9: .byte 0
  .segment Data
    key: .word 0
  .segment CodeLruCache
    index: .byte 0
    // move in array until an empty
    index_prev: .byte 0
    .label data = return
    next: .byte 0
    prev: .byte 0
    lru_cache_move_link1_index: .byte 0
    lru_cache_move_link1_l: .byte 0
    lru_cache_move_link1_key: .word 0
    lru_cache_move_link1_data: .word 0
    lru_cache_move_link1_next: .byte 0
    lru_cache_move_link1_prev: .byte 0
  .segment Data
    return: .word 0
}
.segment CodeLruCache
  // lru_cache_insert
// char lru_cache_insert(__mem() unsigned int key, __mem() unsigned int data)
lru_cache_insert: {
    .const OFFSET_STACK_KEY = 2
    .const OFFSET_STACK_DATA = 0
    .const OFFSET_STACK_RETURN_3 = 3
    // [63] lru_cache_insert::key#0 = stackidx(unsigned int,lru_cache_insert::OFFSET_STACK_KEY) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_KEY,x
    sta key
    lda STACK_BASE+OFFSET_STACK_KEY+1,x
    sta key+1
    // [64] lru_cache_insert::data#0 = stackidx(unsigned int,lru_cache_insert::OFFSET_STACK_DATA) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_DATA,x
    sta data
    lda STACK_BASE+OFFSET_STACK_DATA+1,x
    sta data+1
    // lru_cache_index_t index = lru_cache_hash(key)
    // [65] lru_cache_hash::key#1 = lru_cache_insert::key#0 -- vwum1=vwum2 
    lda key
    sta lru_cache_hash.key
    lda key+1
    sta lru_cache_hash.key+1
    // [66] call lru_cache_hash
    // [225] phi from lru_cache_insert to lru_cache_hash [phi:lru_cache_insert->lru_cache_hash]
    // [225] phi lru_cache_hash::key#4 = lru_cache_hash::key#1 [phi:lru_cache_insert->lru_cache_hash#0] -- call_phi_near 
    jsr lru_cache_hash
    // lru_cache_index_t index = lru_cache_hash(key)
    // [67] lru_cache_hash::return#3 = lru_cache_hash::return#0 -- vbum1=vbum2 
    lda lru_cache_hash.return
    sta lru_cache_hash.return_2
    // lru_cache_insert::@10
    // [68] lru_cache_insert::index#0 = lru_cache_hash::return#3 -- vbum1=vbum2 
    sta index
    // lru_cache_index_t link_head = lru_cache_find_head(index)
    // [69] lru_cache_find_head::index#0 = lru_cache_insert::index#0 -- vbum1=vbum2 
    sta lru_cache_find_head.index
    // [70] call lru_cache_find_head -- call_phi_near 
    // Check if there is already a link node in place in the hash table at the index.
    jsr lru_cache_find_head
    // [71] lru_cache_find_head::return#0 = lru_cache_find_head::return#3 -- vbum1=vbum2 
    lda lru_cache_find_head.return_1
    sta lru_cache_find_head.return
    // lru_cache_insert::@11
    // [72] lru_cache_insert::link_head#0 = lru_cache_find_head::return#0 -- vbum1=vbum2 
    sta link_head
    // lru_cache_index_t link_prev = lru_cache_find_duplicate(link_head, index)
    // [73] lru_cache_find_duplicate::index#0 = lru_cache_insert::link_head#0 -- vbum1=vbum2 
    sta lru_cache_find_duplicate.index
    // [74] lru_cache_find_duplicate::link#0 = lru_cache_insert::index#0 -- vbum1=vbum2 
    lda index
    sta lru_cache_find_duplicate.link
    // [75] call lru_cache_find_duplicate
    // [239] phi from lru_cache_insert::@11 to lru_cache_find_duplicate [phi:lru_cache_insert::@11->lru_cache_find_duplicate]
    // [239] phi lru_cache_find_duplicate::link#3 = lru_cache_find_duplicate::link#0 [phi:lru_cache_insert::@11->lru_cache_find_duplicate#0] -- register_copy 
    // [239] phi lru_cache_find_duplicate::index#6 = lru_cache_find_duplicate::index#0 [phi:lru_cache_insert::@11->lru_cache_find_duplicate#1] -- call_phi_near 
    jsr lru_cache_find_duplicate
    // lru_cache_index_t link_prev = lru_cache_find_duplicate(link_head, index)
    // [76] lru_cache_find_duplicate::return#0 = lru_cache_find_duplicate::index#3 -- vbum1=vbum2 
    lda lru_cache_find_duplicate.index
    sta lru_cache_find_duplicate.return
    // lru_cache_insert::@12
    // [77] lru_cache_insert::link_prev#0 = lru_cache_find_duplicate::return#0 -- vbum1=vbum2 
    sta link_prev
    // lru_cache.key[index] != LRU_CACHE_NOTHING
    // [78] lru_cache_insert::lru_cache_move_link1_$6 = lru_cache_insert::index#0 << 1 -- vbum1=vbum2_rol_1 
    lda index
    asl
    sta lru_cache_move_link1_lru_cache_insert__6
    // if (lru_cache.key[index] != LRU_CACHE_NOTHING && link_head != LRU_CACHE_INDEX_NULL)
    // [79] if(((unsigned int *)&lru_cache)[lru_cache_insert::lru_cache_move_link1_$6]==$ffff) goto lru_cache_insert::@1 -- pwuc1_derefidx_vbum1_eq_vwuc2_then_la1 
    tay
    lda lru_cache,y
    cmp #<$ffff
    bne !+
    lda lru_cache+1,y
    cmp #>$ffff
    beq __b1
  !:
    // lru_cache_insert::@16
    // [80] if(lru_cache_insert::link_head#0!=$ff) goto lru_cache_insert::@5 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp link_head
    beq !__b5+
    jmp __b5
  !__b5:
    // lru_cache_insert::@1
  __b1:
    // lru_cache_index_t index_prev = lru_cache_find_duplicate(index, LRU_CACHE_INDEX_NULL)
    // [81] lru_cache_find_duplicate::index#1 = lru_cache_insert::index#0 -- vbum1=vbum2 
    lda index
    sta lru_cache_find_duplicate.index
    // [82] call lru_cache_find_duplicate
  // We just follow the duplicate chain and find the last duplicate.
    // [239] phi from lru_cache_insert::@1 to lru_cache_find_duplicate [phi:lru_cache_insert::@1->lru_cache_find_duplicate]
    // [239] phi lru_cache_find_duplicate::link#3 = $ff [phi:lru_cache_insert::@1->lru_cache_find_duplicate#0] -- vbum1=vbuc1 
    lda #$ff
    sta lru_cache_find_duplicate.link
    // [239] phi lru_cache_find_duplicate::index#6 = lru_cache_find_duplicate::index#1 [phi:lru_cache_insert::@1->lru_cache_find_duplicate#1] -- call_phi_near 
    jsr lru_cache_find_duplicate
    // lru_cache_index_t index_prev = lru_cache_find_duplicate(index, LRU_CACHE_INDEX_NULL)
    // [83] lru_cache_find_duplicate::return#1 = lru_cache_find_duplicate::index#3 -- vbum1=vbum2 
    lda lru_cache_find_duplicate.index
    sta lru_cache_find_duplicate.return_1
    // lru_cache_insert::@13
    // [84] lru_cache_insert::index_prev#0 = lru_cache_find_duplicate::return#1 -- vbum1=vbum2 
    sta index_prev
    // lru_cache_find_empty(index_prev)
    // [85] lru_cache_find_empty::index#0 = lru_cache_insert::index_prev#0 -- vbum1=vbum2 
    sta lru_cache_find_empty.index
    // [86] call lru_cache_find_empty
    // [245] phi from lru_cache_insert::@13 to lru_cache_find_empty [phi:lru_cache_insert::@13->lru_cache_find_empty]
    // [245] phi lru_cache_find_empty::index#7 = lru_cache_find_empty::index#0 [phi:lru_cache_insert::@13->lru_cache_find_empty#0] -- call_phi_near 
    jsr lru_cache_find_empty
    // lru_cache_find_empty(index_prev)
    // [87] lru_cache_find_empty::return#0 = lru_cache_find_empty::index#4 -- vbum1=vbum2 
    lda lru_cache_find_empty.index
    sta lru_cache_find_empty.return
    // lru_cache_insert::@14
    // index = lru_cache_find_empty(index_prev)
    // [88] lru_cache_insert::index#1 = lru_cache_find_empty::return#0 -- vbum1=vbum2 
    sta index_1
    // lru_cache.link[index] = LRU_CACHE_INDEX_NULL
    // [89] ((char *)&lru_cache+$300)[lru_cache_insert::index#1] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    // We set the link of the free node to INDEX_NULL, 
    // and point the link of the previous node to the empty node.
    // index != index_prev indicates there is a duplicate chain. 
    lda #$ff
    ldy index_1
    sta lru_cache+$300,y
    // if (index_prev != index)
    // [90] if(lru_cache_insert::index_prev#0==lru_cache_insert::index#1) goto lru_cache_insert::@2 -- vbum1_eq_vbum2_then_la1 
    lda index_prev
    cmp index_1
    beq __b2
    // lru_cache_insert::@6
    // lru_cache.link[index_prev] = index
    // [91] ((char *)&lru_cache+$300)[lru_cache_insert::index_prev#0] = lru_cache_insert::index#1 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy index_prev
    sta lru_cache+$300,y
    // lru_cache_insert::@2
  __b2:
    // lru_cache.key[index] = key
    // [92] lru_cache_insert::$20 = lru_cache_insert::index#1 << 1 -- vbum1=vbum2_rol_1 
    lda index_1
    asl
    sta lru_cache_insert__20
    // [93] ((unsigned int *)&lru_cache)[lru_cache_insert::$20] = lru_cache_insert::key#0 -- pwuc1_derefidx_vbum1=vwum2 
    // Now assign the key and the data.
    tay
    lda key
    sta lru_cache,y
    lda key+1
    sta lru_cache+1,y
    // lru_cache.data[index] = data
    // [94] ((unsigned int *)&lru_cache+$100)[lru_cache_insert::$20] = lru_cache_insert::data#0 -- pwuc1_derefidx_vbum1=vwum2 
    lda data
    sta lru_cache+$100,y
    lda data+1
    sta lru_cache+$100+1,y
    // if (lru_cache.first == 0xff)
    // [95] if(*((char *)&lru_cache+$381)!=$ff) goto lru_cache_insert::@3 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #$ff
    cmp lru_cache+$381
    bne __b3
    // lru_cache_insert::@7
    // lru_cache.first = index
    // [96] *((char *)&lru_cache+$381) = lru_cache_insert::index#1 -- _deref_pbuc1=vbum1 
    lda index_1
    sta lru_cache+$381
    // lru_cache_insert::@3
  __b3:
    // if (lru_cache.last == 0xff)
    // [97] if(*((char *)&lru_cache+$382)!=$ff) goto lru_cache_insert::@4 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #$ff
    cmp lru_cache+$382
    bne __b4
    // lru_cache_insert::@8
    // lru_cache.last = index
    // [98] *((char *)&lru_cache+$382) = lru_cache_insert::index#1 -- _deref_pbuc1=vbum1 
    lda index_1
    sta lru_cache+$382
    // lru_cache_insert::@4
  __b4:
    // lru_cache.next[index] = lru_cache.first
    // [99] ((char *)&lru_cache+$280)[lru_cache_insert::index#1] = *((char *)&lru_cache+$381) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    // Now insert the node as the first node in the list.
    lda lru_cache+$381
    ldy index_1
    sta lru_cache+$280,y
    // lru_cache.prev[lru_cache.first] = index
    // [100] ((char *)&lru_cache+$200)[*((char *)&lru_cache+$381)] = lru_cache_insert::index#1 -- pbuc1_derefidx_(_deref_pbuc2)=vbum1 
    tya
    ldy lru_cache+$381
    sta lru_cache+$200,y
    // lru_cache.next[lru_cache.last] = index
    // [101] ((char *)&lru_cache+$280)[*((char *)&lru_cache+$382)] = lru_cache_insert::index#1 -- pbuc1_derefidx_(_deref_pbuc2)=vbum1 
    ldy lru_cache+$382
    sta lru_cache+$280,y
    // lru_cache.prev[index] = lru_cache.last
    // [102] ((char *)&lru_cache+$200)[lru_cache_insert::index#1] = *((char *)&lru_cache+$382) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    tya
    ldy index_1
    sta lru_cache+$200,y
    // lru_cache.first = index
    // [103] *((char *)&lru_cache+$381) = lru_cache_insert::index#1 -- _deref_pbuc1=vbum1 
    tya
    sta lru_cache+$381
    // lru_cache.count++;
    // [104] *((char *)&lru_cache+$380) = ++ *((char *)&lru_cache+$380) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc lru_cache+$380
    // lru_cache_insert::@return
    // }
    // [105] stackidx(char,lru_cache_insert::OFFSET_STACK_RETURN_3) = lru_cache_insert::index#1 -- _stackidxbyte_vbuc1=vbum1 
    tya
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_3,x
    // [106] return 
    rts
    // lru_cache_insert::@5
  __b5:
    // lru_cache_index_t link = lru_cache_find_empty(index)
    // [107] lru_cache_find_empty::index#1 = lru_cache_insert::index#0 -- vbum1=vbum2 
    lda index
    sta lru_cache_find_empty.index
    // [108] call lru_cache_find_empty
  // There is already a link node, so this node is not a head node and needs to be moved.
  // Get the head node of this chain, we know this because we can get the head of the key.
  // The link of the head_link must be changed once the new place of the link node has been found.
    // [245] phi from lru_cache_insert::@5 to lru_cache_find_empty [phi:lru_cache_insert::@5->lru_cache_find_empty]
    // [245] phi lru_cache_find_empty::index#7 = lru_cache_find_empty::index#1 [phi:lru_cache_insert::@5->lru_cache_find_empty#0] -- call_phi_near 
    jsr lru_cache_find_empty
    // lru_cache_index_t link = lru_cache_find_empty(index)
    // [109] lru_cache_find_empty::return#1 = lru_cache_find_empty::index#4 -- vbum1=vbum2 
    lda lru_cache_find_empty.index
    sta lru_cache_find_empty.return_1
    // lru_cache_insert::@15
    // [110] lru_cache_insert::lru_cache_move_link1_link#0 = lru_cache_find_empty::return#1 -- vbum1=vbum2 
    sta lru_cache_move_link1_link
    // lru_cache_insert::lru_cache_move_link1
    // lru_cache_index_t l = lru_cache.link[index]
    // [111] lru_cache_insert::lru_cache_move_link1_l#0 = ((char *)&lru_cache+$300)[lru_cache_insert::index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy index
    lda lru_cache+$300,y
    sta lru_cache_move_link1_l
    // lru_cache.link[link] = l
    // [112] ((char *)&lru_cache+$300)[lru_cache_insert::lru_cache_move_link1_link#0] = lru_cache_insert::lru_cache_move_link1_l#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy lru_cache_move_link1_link
    sta lru_cache+$300,y
    // lru_cache_key_t key = lru_cache.key[index]
    // [113] lru_cache_insert::lru_cache_move_link1_key#0 = ((unsigned int *)&lru_cache)[lru_cache_insert::lru_cache_move_link1_$6] -- vwum1=pwuc1_derefidx_vbum2 
    ldy lru_cache_move_link1_lru_cache_insert__6
    lda lru_cache,y
    sta lru_cache_move_link1_key
    lda lru_cache+1,y
    sta lru_cache_move_link1_key+1
    // lru_cache.key[link] = key
    // [114] lru_cache_insert::lru_cache_move_link1_$7 = lru_cache_insert::lru_cache_move_link1_link#0 << 1 -- vbum1=vbum2_rol_1 
    lda lru_cache_move_link1_link
    asl
    sta lru_cache_move_link1_lru_cache_insert__7
    // [115] ((unsigned int *)&lru_cache)[lru_cache_insert::lru_cache_move_link1_$7] = lru_cache_insert::lru_cache_move_link1_key#0 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda lru_cache_move_link1_key
    sta lru_cache,y
    lda lru_cache_move_link1_key+1
    sta lru_cache+1,y
    // lru_cache_data_t data = lru_cache.data[index]
    // [116] lru_cache_insert::lru_cache_move_link1_data#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_insert::lru_cache_move_link1_$6] -- vwum1=pwuc1_derefidx_vbum2 
    ldy lru_cache_move_link1_lru_cache_insert__6
    lda lru_cache+$100,y
    sta lru_cache_move_link1_data
    lda lru_cache+$100+1,y
    sta lru_cache_move_link1_data+1
    // lru_cache.data[link] = data
    // [117] ((unsigned int *)&lru_cache+$100)[lru_cache_insert::lru_cache_move_link1_$7] = lru_cache_insert::lru_cache_move_link1_data#0 -- pwuc1_derefidx_vbum1=vwum2 
    ldy lru_cache_move_link1_lru_cache_insert__7
    lda lru_cache_move_link1_data
    sta lru_cache+$100,y
    lda lru_cache_move_link1_data+1
    sta lru_cache+$100+1,y
    // lru_cache_index_t next = lru_cache.next[index]
    // [118] lru_cache_insert::lru_cache_move_link1_next#0 = ((char *)&lru_cache+$280)[lru_cache_insert::index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy index
    lda lru_cache+$280,y
    sta lru_cache_move_link1_next
    // lru_cache_index_t prev = lru_cache.prev[index]
    // [119] lru_cache_insert::lru_cache_move_link1_prev#0 = ((char *)&lru_cache+$200)[lru_cache_insert::index#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda lru_cache+$200,y
    sta lru_cache_move_link1_prev
    // lru_cache.next[link] = next
    // [120] ((char *)&lru_cache+$280)[lru_cache_insert::lru_cache_move_link1_link#0] = lru_cache_insert::lru_cache_move_link1_next#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda lru_cache_move_link1_next
    ldy lru_cache_move_link1_link
    sta lru_cache+$280,y
    // lru_cache.prev[link] = prev
    // [121] ((char *)&lru_cache+$200)[lru_cache_insert::lru_cache_move_link1_link#0] = lru_cache_insert::lru_cache_move_link1_prev#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda lru_cache_move_link1_prev
    sta lru_cache+$200,y
    // lru_cache.next[prev] = link
    // [122] ((char *)&lru_cache+$280)[lru_cache_insert::lru_cache_move_link1_prev#0] = lru_cache_insert::lru_cache_move_link1_link#0 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy lru_cache_move_link1_prev
    sta lru_cache+$280,y
    // lru_cache.prev[next] = link
    // [123] ((char *)&lru_cache+$200)[lru_cache_insert::lru_cache_move_link1_next#0] = lru_cache_insert::lru_cache_move_link1_link#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy lru_cache_move_link1_next
    sta lru_cache+$200,y
    // if (lru_cache.last == index)
    // [124] if(*((char *)&lru_cache+$382)!=lru_cache_insert::index#0) goto lru_cache_insert::lru_cache_move_link1_@1 -- _deref_pbuc1_neq_vbum1_then_la1 
    lda lru_cache+$382
    cmp index
    bne lru_cache_move_link1___b1
    // lru_cache_insert::lru_cache_move_link1_@3
    // lru_cache.last = link
    // [125] *((char *)&lru_cache+$382) = lru_cache_insert::lru_cache_move_link1_link#0 -- _deref_pbuc1=vbum1 
    lda lru_cache_move_link1_link
    sta lru_cache+$382
    // lru_cache_insert::lru_cache_move_link1_@1
  lru_cache_move_link1___b1:
    // if (lru_cache.first == index)
    // [126] if(*((char *)&lru_cache+$381)!=lru_cache_insert::index#0) goto lru_cache_insert::lru_cache_move_link1_@2 -- _deref_pbuc1_neq_vbum1_then_la1 
    lda lru_cache+$381
    cmp index
    bne lru_cache_move_link1___b2
    // lru_cache_insert::lru_cache_move_link1_@4
    // lru_cache.first = link
    // [127] *((char *)&lru_cache+$381) = lru_cache_insert::lru_cache_move_link1_link#0 -- _deref_pbuc1=vbum1 
    lda lru_cache_move_link1_link
    sta lru_cache+$381
    // lru_cache_insert::lru_cache_move_link1_@2
  lru_cache_move_link1___b2:
    // lru_cache.key[index] = LRU_CACHE_NOTHING
    // [128] ((unsigned int *)&lru_cache)[lru_cache_insert::lru_cache_move_link1_$6] = $ffff -- pwuc1_derefidx_vbum1=vwuc2 
    ldy lru_cache_move_link1_lru_cache_insert__6
    lda #<$ffff
    sta lru_cache,y
    lda #>$ffff
    sta lru_cache+1,y
    // lru_cache.data[index] = LRU_CACHE_NOTHING
    // [129] ((unsigned int *)&lru_cache+$100)[lru_cache_insert::lru_cache_move_link1_$6] = $ffff -- pwuc1_derefidx_vbum1=vwuc2 
    lda #<$ffff
    sta lru_cache+$100,y
    lda #>$ffff
    sta lru_cache+$100+1,y
    // lru_cache.next[index] = LRU_CACHE_INDEX_NULL
    // [130] ((char *)&lru_cache+$280)[lru_cache_insert::index#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    lda #$ff
    ldy index
    sta lru_cache+$280,y
    // lru_cache.prev[index] = LRU_CACHE_INDEX_NULL
    // [131] ((char *)&lru_cache+$200)[lru_cache_insert::index#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta lru_cache+$200,y
    // lru_cache.link[index] = LRU_CACHE_INDEX_NULL
    // [132] ((char *)&lru_cache+$300)[lru_cache_insert::index#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta lru_cache+$300,y
    // lru_cache_insert::@9
    // lru_cache.link[link_prev] = link
    // [133] ((char *)&lru_cache+$300)[lru_cache_insert::link_prev#0] = lru_cache_insert::lru_cache_move_link1_link#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda lru_cache_move_link1_link
    ldy link_prev
    sta lru_cache+$300,y
    jmp __b1
    lru_cache_insert__20: .byte 0
    lru_cache_move_link1_lru_cache_insert__6: .byte 0
    lru_cache_move_link1_lru_cache_insert__7: .byte 0
  .segment Data
    key: .word 0
    data: .word 0
  .segment CodeLruCache
    index: .byte 0
    link_head: .byte 0
    link_prev: .byte 0
    index_prev: .byte 0
    index_1: .byte 0
    lru_cache_move_link1_link: .byte 0
    lru_cache_move_link1_l: .byte 0
    lru_cache_move_link1_key: .word 0
    lru_cache_move_link1_data: .word 0
    lru_cache_move_link1_next: .byte 0
    lru_cache_move_link1_prev: .byte 0
}
  // lru_cache_data
// __mem() unsigned int lru_cache_data(__mem() char index)
lru_cache_data: {
    .const OFFSET_STACK_INDEX = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [134] lru_cache_data::index#0 = stackidx(char,lru_cache_data::OFFSET_STACK_INDEX) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_INDEX,x
    sta index
    // return lru_cache.data[index];
    // [135] lru_cache_data::$0 = lru_cache_data::index#0 << 1 -- vbum1=vbum2_rol_1 
    asl
    sta lru_cache_data__0
    // [136] lru_cache_data::return#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_data::$0] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda lru_cache+$100,y
    sta return
    lda lru_cache+$100+1,y
    sta return+1
    // lru_cache_data::@return
    // }
    // [137] stackidx(unsigned int,lru_cache_data::OFFSET_STACK_RETURN_0) = lru_cache_data::return#0 -- _stackidxword_vbuc1=vwum1 
    tsx
    lda return
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [138] return 
    rts
    lru_cache_data__0: .byte 0
  .segment Data
    index: .byte 0
    return: .word 0
}
.segment CodeLruCache
  // lru_cache_set
// __mem() unsigned int lru_cache_set(__mem() char index, __mem() unsigned int data)
lru_cache_set: {
    .const OFFSET_STACK_INDEX = 2
    .const OFFSET_STACK_DATA = 0
    .const OFFSET_STACK_RETURN_1 = 1
    // [139] lru_cache_set::index#0 = stackidx(char,lru_cache_set::OFFSET_STACK_INDEX) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_INDEX,x
    sta index
    // [140] lru_cache_set::data#0 = stackidx(unsigned int,lru_cache_set::OFFSET_STACK_DATA) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_DATA,x
    sta data
    lda STACK_BASE+OFFSET_STACK_DATA+1,x
    sta data+1
    // if (index != LRU_CACHE_INDEX_NULL)
    // [141] if(lru_cache_set::index#0==$ff) goto lru_cache_set::@return -- vbum1_eq_vbuc1_then_la1 
    lda #$ff
    cmp index
    beq __b1
    // lru_cache_set::@1
    // lru_cache.data[index] = data
    // [142] lru_cache_set::$3 = lru_cache_set::index#0 << 1 -- vbum1=vbum2_rol_1 
    lda index
    asl
    sta lru_cache_set__3
    // [143] ((unsigned int *)&lru_cache+$100)[lru_cache_set::$3] = lru_cache_set::data#0 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda data
    sta lru_cache+$100,y
    lda data+1
    sta lru_cache+$100+1,y
    // lru_cache_get(index)
    // [144] stackpush(char) = lru_cache_set::index#0 -- _stackpushbyte_=vbum1 
    lda index
    pha
    // sideeffect stackpushpadding(1) -- _stackpushpadding_1 
    pha
    // [146] callexecute lru_cache_get  -- call_vprc1 
    jsr lru_cache_get
    // return lru_cache_get(index);
    // [147] lru_cache_set::return#1 = stackpull(unsigned int) -- vwum1=_stackpullword_ 
    pla
    sta return
    pla
    sta return+1
    // [148] phi from lru_cache_set::@1 to lru_cache_set::@return [phi:lru_cache_set::@1->lru_cache_set::@return]
    // [148] phi lru_cache_set::return#2 = lru_cache_set::return#1 [phi:lru_cache_set::@1->lru_cache_set::@return#0] -- register_copy 
    jmp __breturn
    // [148] phi from lru_cache_set to lru_cache_set::@return [phi:lru_cache_set->lru_cache_set::@return]
  __b1:
    // [148] phi lru_cache_set::return#2 = $ffff [phi:lru_cache_set->lru_cache_set::@return#0] -- vwum1=vwuc1 
    lda #<$ffff
    sta return
    lda #>$ffff
    sta return+1
    // lru_cache_set::@return
  __breturn:
    // }
    // [149] stackidx(unsigned int,lru_cache_set::OFFSET_STACK_RETURN_1) = lru_cache_set::return#2 -- _stackidxword_vbuc1=vwum1 
    tsx
    lda return
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    lda return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_1+1,x
    // [150] return 
    rts
    lru_cache_set__3: .byte 0
  .segment Data
    index: .byte 0
    data: .word 0
    return: .word 0
}
.segment CodeLruCache
  // lru_cache_get
// __mem() unsigned int lru_cache_get(__mem() char index)
lru_cache_get: {
    .const OFFSET_STACK_INDEX = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [151] lru_cache_get::index#0 = stackidx(char,lru_cache_get::OFFSET_STACK_INDEX) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_INDEX,x
    sta index
    // if (index != LRU_CACHE_INDEX_NULL)
    // [152] if(lru_cache_get::index#0==$ff) goto lru_cache_get::@return -- vbum1_eq_vbuc1_then_la1 
    lda #$ff
    cmp index
    beq __b1
    // lru_cache_get::@1
    // lru_cache_data_t data = lru_cache.data[index]
    // [153] lru_cache_get::$6 = lru_cache_get::index#0 << 1 -- vbum1=vbum2_rol_1 
    lda index
    asl
    sta lru_cache_get__6
    // [154] lru_cache_get::data#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_get::$6] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda lru_cache+$100,y
    sta data
    lda lru_cache+$100+1,y
    sta data+1
    // lru_cache_index_t next = lru_cache.next[index]
    // [155] lru_cache_get::next#0 = ((char *)&lru_cache+$280)[lru_cache_get::index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy index
    lda lru_cache+$280,y
    sta next
    // lru_cache_index_t prev = lru_cache.prev[index]
    // [156] lru_cache_get::prev#0 = ((char *)&lru_cache+$200)[lru_cache_get::index#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda lru_cache+$200,y
    sta prev
    // lru_cache.next[prev] = next
    // [157] ((char *)&lru_cache+$280)[lru_cache_get::prev#0] = lru_cache_get::next#0 -- pbuc1_derefidx_vbum1=vbum2 
    // Delete the node from the list.
    lda next
    ldy prev
    sta lru_cache+$280,y
    // lru_cache.prev[next] = prev
    // [158] ((char *)&lru_cache+$200)[lru_cache_get::next#0] = lru_cache_get::prev#0 -- pbuc1_derefidx_vbum1=vbum2 
    //lru_cache.next[next] = prev;
    tya
    ldy next
    sta lru_cache+$200,y
    // if (index == lru_cache.first)
    // [159] if(lru_cache_get::index#0!=*((char *)&lru_cache+$381)) goto lru_cache_get::@3 -- vbum1_neq__deref_pbuc1_then_la1 
    lda lru_cache+$381
    cmp index
    bne __b3
    // lru_cache_get::@2
    // lru_cache.first = next
    // [160] *((char *)&lru_cache+$381) = lru_cache_get::next#0 -- _deref_pbuc1=vbum1 
    tya
    sta lru_cache+$381
    // lru_cache_get::@3
  __b3:
    // if (index == lru_cache.last)
    // [161] if(lru_cache_get::index#0!=*((char *)&lru_cache+$382)) goto lru_cache_get::@4 -- vbum1_neq__deref_pbuc1_then_la1 
    lda lru_cache+$382
    cmp index
    bne __b4
    // lru_cache_get::@5
    // lru_cache.last = prev
    // [162] *((char *)&lru_cache+$382) = lru_cache_get::prev#0 -- _deref_pbuc1=vbum1 
    lda prev
    sta lru_cache+$382
    // lru_cache_get::@4
  __b4:
    // lru_cache.next[index] = lru_cache.first
    // [163] ((char *)&lru_cache+$280)[lru_cache_get::index#0] = *((char *)&lru_cache+$381) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    // Now insert the node as the first node in the list.
    lda lru_cache+$381
    ldy index
    sta lru_cache+$280,y
    // lru_cache.prev[lru_cache.first] = index
    // [164] ((char *)&lru_cache+$200)[*((char *)&lru_cache+$381)] = lru_cache_get::index#0 -- pbuc1_derefidx_(_deref_pbuc2)=vbum1 
    tya
    ldy lru_cache+$381
    sta lru_cache+$200,y
    // lru_cache.next[lru_cache.last] = index
    // [165] ((char *)&lru_cache+$280)[*((char *)&lru_cache+$382)] = lru_cache_get::index#0 -- pbuc1_derefidx_(_deref_pbuc2)=vbum1 
    ldy lru_cache+$382
    sta lru_cache+$280,y
    // lru_cache.prev[index] = lru_cache.last
    // [166] ((char *)&lru_cache+$200)[lru_cache_get::index#0] = *((char *)&lru_cache+$382) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    tya
    ldy index
    sta lru_cache+$200,y
    // lru_cache.first = index
    // [167] *((char *)&lru_cache+$381) = lru_cache_get::index#0 -- _deref_pbuc1=vbum1 
    // Now the first node in the list is the node referenced!
    // All other nodes are moved one position down!
    tya
    sta lru_cache+$381
    // lru_cache.last = lru_cache.prev[index]
    // [168] *((char *)&lru_cache+$382) = ((char *)&lru_cache+$200)[lru_cache_get::index#0] -- _deref_pbuc1=pbuc2_derefidx_vbum1 
    lda lru_cache+$200,y
    sta lru_cache+$382
    // [169] phi from lru_cache_get::@4 to lru_cache_get::@return [phi:lru_cache_get::@4->lru_cache_get::@return]
    // [169] phi lru_cache_get::return#2 = lru_cache_get::data#0 [phi:lru_cache_get::@4->lru_cache_get::@return#0] -- register_copy 
    jmp __breturn
    // [169] phi from lru_cache_get to lru_cache_get::@return [phi:lru_cache_get->lru_cache_get::@return]
  __b1:
    // [169] phi lru_cache_get::return#2 = $ffff [phi:lru_cache_get->lru_cache_get::@return#0] -- vwum1=vwuc1 
    lda #<$ffff
    sta return
    lda #>$ffff
    sta return+1
    // lru_cache_get::@return
  __breturn:
    // }
    // [170] stackidx(unsigned int,lru_cache_get::OFFSET_STACK_RETURN_0) = lru_cache_get::return#2 -- _stackidxword_vbuc1=vwum1 
    tsx
    lda return
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [171] return 
    rts
    lru_cache_get__6: .byte 0
  .segment Data
    index: .byte 0
  .segment CodeLruCache
    .label data = return
    next: .byte 0
    prev: .byte 0
  .segment Data
    return: .word 0
}
.segment CodeLruCache
  // lru_cache_index
// __mem() char lru_cache_index(__mem() unsigned int key)
lru_cache_index: {
    .const OFFSET_STACK_KEY = 0
    .const OFFSET_STACK_RETURN_1 = 1
    // [172] lru_cache_index::key#0 = stackidx(unsigned int,lru_cache_index::OFFSET_STACK_KEY) -- vwum1=_stackidxword_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_KEY,x
    sta key
    lda STACK_BASE+OFFSET_STACK_KEY+1,x
    sta key+1
    // lru_cache_index_t index = lru_cache_hash(key)
    // [173] lru_cache_hash::key#0 = lru_cache_index::key#0 -- vwum1=vwum2 
    lda key
    sta lru_cache_hash.key
    lda key+1
    sta lru_cache_hash.key+1
    // [174] call lru_cache_hash
    // [225] phi from lru_cache_index to lru_cache_hash [phi:lru_cache_index->lru_cache_hash]
    // [225] phi lru_cache_hash::key#4 = lru_cache_hash::key#0 [phi:lru_cache_index->lru_cache_hash#0] -- call_phi_near 
    jsr lru_cache_hash
    // lru_cache_index_t index = lru_cache_hash(key)
    // [175] lru_cache_hash::return#2 = lru_cache_hash::return#0 -- vbum1=vbum2 
    lda lru_cache_hash.return
    sta lru_cache_hash.return_1
    // lru_cache_index::@4
    // [176] lru_cache_index::index#0 = lru_cache_hash::return#2 -- vbum1=vbum2 
    sta index
    // [177] phi from lru_cache_index::@3 lru_cache_index::@4 to lru_cache_index::@1 [phi:lru_cache_index::@3/lru_cache_index::@4->lru_cache_index::@1]
  __b1:
    // [177] phi lru_cache_index::index#2 = lru_cache_index::index#1 [phi:lru_cache_index::@3/lru_cache_index::@4->lru_cache_index::@1#0] -- register_copy 
  // Search till index == 0xFF, following the links.
    // lru_cache_index::@1
    // while (index != LRU_CACHE_INDEX_NULL)
    // [178] if(lru_cache_index::index#2!=$ff) goto lru_cache_index::@2 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp index
    bne __b2
    // [181] phi from lru_cache_index::@1 to lru_cache_index::@return [phi:lru_cache_index::@1->lru_cache_index::@return]
    // [181] phi lru_cache_index::return#2 = $ff [phi:lru_cache_index::@1->lru_cache_index::@return#0] -- vbum1=vbuc1 
    sta return
    jmp __breturn
    // lru_cache_index::@2
  __b2:
    // lru_cache.key[index] == key
    // [179] lru_cache_index::$4 = lru_cache_index::index#2 << 1 -- vbum1=vbum2_rol_1 
    lda index
    asl
    sta lru_cache_index__4
    // if (lru_cache.key[index] == key)
    // [180] if(((unsigned int *)&lru_cache)[lru_cache_index::$4]!=lru_cache_index::key#0) goto lru_cache_index::@3 -- pwuc1_derefidx_vbum1_neq_vwum2_then_la1 
    tay
    lda key+1
    cmp lru_cache+1,y
    bne __b3
    lda key
    cmp lru_cache,y
    bne __b3
    // [181] phi from lru_cache_index::@2 to lru_cache_index::@return [phi:lru_cache_index::@2->lru_cache_index::@return]
    // [181] phi lru_cache_index::return#2 = lru_cache_index::index#2 [phi:lru_cache_index::@2->lru_cache_index::@return#0] -- register_copy 
    // lru_cache_index::@return
  __breturn:
    // }
    // [182] stackidx(char,lru_cache_index::OFFSET_STACK_RETURN_1) = lru_cache_index::return#2 -- _stackidxbyte_vbuc1=vbum1 
    lda return
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    // [183] return 
    rts
    // lru_cache_index::@3
  __b3:
    // index = lru_cache.link[index]
    // [184] lru_cache_index::index#1 = ((char *)&lru_cache+$300)[lru_cache_index::index#2] -- vbum1=pbuc1_derefidx_vbum1 
    ldy index
    lda lru_cache+$300,y
    sta index
    jmp __b1
    lru_cache_index__4: .byte 0
  .segment Data
    key: .word 0
  .segment CodeLruCache
    .label index = return
  .segment Data
    return: .byte 0
}
.segment CodeLruCache
  // lru_cache_is_max
// inline lru_cache_index_t lru_cache_hash(lru_cache_key_t key) {
//     lru_cache_seed = key;
//     asm {
//                     lda lru_cache_seed
//                     beq !doEor+
//                     asl
//                     beq !noEor+
//                     bcc !noEor+
//         !doEor:     eor #$2b
//         !noEor:     sta lru_cache_seed
//     }
//     return lru_cache_seed % LRU_CACHE_SIZE;
// }
lru_cache_is_max: {
    .const OFFSET_STACK_RETURN_0 = 0
    // lru_cache.count >= LRU_CACHE_MAX
    // [185] lru_cache_is_max::return#0 = *((char *)&lru_cache+$380) >= $7c -- vbom1=_deref_pbuc1_ge_vbuc2 
    lda lru_cache+$380
    cmp #$7c
    bcs !+
    lda #0
    jmp !e+
  !:
    lda #1
  !e:
    sta return
    // lru_cache_is_max::@return
    // }
    // [186] stackidx(bool,lru_cache_is_max::OFFSET_STACK_RETURN_0) = lru_cache_is_max::return#0 -- _stackidxbool_vbuc1=vbom1 
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    // [187] return 
    rts
  .segment Data
    return: .byte 0
}
.segment CodeLruCache
  // lru_cache_find_last
lru_cache_find_last: {
    .const OFFSET_STACK_RETURN_0 = 0
    // return lru_cache.key[lru_cache.last];
    // [188] lru_cache_find_last::$0 = *((char *)&lru_cache+$382) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda lru_cache+$382
    asl
    sta lru_cache_find_last__0
    // [189] lru_cache_find_last::return#0 = ((unsigned int *)&lru_cache)[lru_cache_find_last::$0] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda lru_cache,y
    sta return
    lda lru_cache+1,y
    sta return+1
    // lru_cache_find_last::@return
    // }
    // [190] stackidx(unsigned int,lru_cache_find_last::OFFSET_STACK_RETURN_0) = lru_cache_find_last::return#0 -- _stackidxword_vbuc1=vwum1 
    tsx
    lda return
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda return+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [191] return 
    rts
    lru_cache_find_last__0: .byte 0
  .segment Data
    return: .word 0
}
.segment CodeLruCache
  // lru_cache_init
lru_cache_init: {
    .const memset_fast1_c = $ff
    .const memset_fast2_c = $ff
    .const memset_fast3_c = $ff
    .const memset_fast4_c = $ff
    .const memset_fast5_c = $ff
    .label memset_fast1_destination = lru_cache
    .label memset_fast2_destination = lru_cache+$100
    .label memset_fast3_destination = lru_cache+$280
    .label memset_fast4_destination = lru_cache+$200
    .label memset_fast5_destination = lru_cache+$300
    // [193] phi from lru_cache_init to lru_cache_init::memset_fast1 [phi:lru_cache_init->lru_cache_init::memset_fast1]
    // lru_cache_init::memset_fast1
    // [194] phi from lru_cache_init::memset_fast1 to lru_cache_init::memset_fast1_@1 [phi:lru_cache_init::memset_fast1->lru_cache_init::memset_fast1_@1]
    // [194] phi lru_cache_init::memset_fast1_num#2 = SIZEOF_UNSIGNED_INT*$80 [phi:lru_cache_init::memset_fast1->lru_cache_init::memset_fast1_@1#0] -- vbum1=vbuc1 
    lda #SIZEOF_UNSIGNED_INT*$80
    sta memset_fast1_num
    // [194] phi from lru_cache_init::memset_fast1_@1 to lru_cache_init::memset_fast1_@1 [phi:lru_cache_init::memset_fast1_@1->lru_cache_init::memset_fast1_@1]
    // [194] phi lru_cache_init::memset_fast1_num#2 = lru_cache_init::memset_fast1_num#1 [phi:lru_cache_init::memset_fast1_@1->lru_cache_init::memset_fast1_@1#0] -- register_copy 
    // lru_cache_init::memset_fast1_@1
  memset_fast1___b1:
    // *(destination+num) = c
    // [195] lru_cache_init::memset_fast1_destination#0[lru_cache_init::memset_fast1_num#2] = lru_cache_init::memset_fast1_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast1_c
    ldy memset_fast1_num
    sta memset_fast1_destination,y
    // num--;
    // [196] lru_cache_init::memset_fast1_num#1 = -- lru_cache_init::memset_fast1_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast1_num
    // while(num)
    // [197] if(0!=lru_cache_init::memset_fast1_num#1) goto lru_cache_init::memset_fast1_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast1_num
    bne memset_fast1___b1
    // [198] phi from lru_cache_init::memset_fast1_@1 to lru_cache_init::memset_fast2 [phi:lru_cache_init::memset_fast1_@1->lru_cache_init::memset_fast2]
    // lru_cache_init::memset_fast2
    // [199] phi from lru_cache_init::memset_fast2 to lru_cache_init::memset_fast2_@1 [phi:lru_cache_init::memset_fast2->lru_cache_init::memset_fast2_@1]
    // [199] phi lru_cache_init::memset_fast2_num#2 = SIZEOF_UNSIGNED_INT*$80 [phi:lru_cache_init::memset_fast2->lru_cache_init::memset_fast2_@1#0] -- vbum1=vbuc1 
    lda #SIZEOF_UNSIGNED_INT*$80
    sta memset_fast2_num
    // [199] phi from lru_cache_init::memset_fast2_@1 to lru_cache_init::memset_fast2_@1 [phi:lru_cache_init::memset_fast2_@1->lru_cache_init::memset_fast2_@1]
    // [199] phi lru_cache_init::memset_fast2_num#2 = lru_cache_init::memset_fast2_num#1 [phi:lru_cache_init::memset_fast2_@1->lru_cache_init::memset_fast2_@1#0] -- register_copy 
    // lru_cache_init::memset_fast2_@1
  memset_fast2___b1:
    // *(destination+num) = c
    // [200] lru_cache_init::memset_fast2_destination#0[lru_cache_init::memset_fast2_num#2] = lru_cache_init::memset_fast2_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast2_c
    ldy memset_fast2_num
    sta memset_fast2_destination,y
    // num--;
    // [201] lru_cache_init::memset_fast2_num#1 = -- lru_cache_init::memset_fast2_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast2_num
    // while(num)
    // [202] if(0!=lru_cache_init::memset_fast2_num#1) goto lru_cache_init::memset_fast2_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast2_num
    bne memset_fast2___b1
    // [203] phi from lru_cache_init::memset_fast2_@1 to lru_cache_init::memset_fast3 [phi:lru_cache_init::memset_fast2_@1->lru_cache_init::memset_fast3]
    // lru_cache_init::memset_fast3
    // [204] phi from lru_cache_init::memset_fast3 to lru_cache_init::memset_fast3_@1 [phi:lru_cache_init::memset_fast3->lru_cache_init::memset_fast3_@1]
    // [204] phi lru_cache_init::memset_fast3_num#2 = SIZEOF_CHAR*$80 [phi:lru_cache_init::memset_fast3->lru_cache_init::memset_fast3_@1#0] -- vbum1=vbuc1 
    lda #SIZEOF_CHAR*$80
    sta memset_fast3_num
    // [204] phi from lru_cache_init::memset_fast3_@1 to lru_cache_init::memset_fast3_@1 [phi:lru_cache_init::memset_fast3_@1->lru_cache_init::memset_fast3_@1]
    // [204] phi lru_cache_init::memset_fast3_num#2 = lru_cache_init::memset_fast3_num#1 [phi:lru_cache_init::memset_fast3_@1->lru_cache_init::memset_fast3_@1#0] -- register_copy 
    // lru_cache_init::memset_fast3_@1
  memset_fast3___b1:
    // *(destination+num) = c
    // [205] lru_cache_init::memset_fast3_destination#0[lru_cache_init::memset_fast3_num#2] = lru_cache_init::memset_fast3_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast3_c
    ldy memset_fast3_num
    sta memset_fast3_destination,y
    // num--;
    // [206] lru_cache_init::memset_fast3_num#1 = -- lru_cache_init::memset_fast3_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast3_num
    // while(num)
    // [207] if(0!=lru_cache_init::memset_fast3_num#1) goto lru_cache_init::memset_fast3_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast3_num
    bne memset_fast3___b1
    // [208] phi from lru_cache_init::memset_fast3_@1 to lru_cache_init::memset_fast4 [phi:lru_cache_init::memset_fast3_@1->lru_cache_init::memset_fast4]
    // lru_cache_init::memset_fast4
    // [209] phi from lru_cache_init::memset_fast4 to lru_cache_init::memset_fast4_@1 [phi:lru_cache_init::memset_fast4->lru_cache_init::memset_fast4_@1]
    // [209] phi lru_cache_init::memset_fast4_num#2 = SIZEOF_CHAR*$80 [phi:lru_cache_init::memset_fast4->lru_cache_init::memset_fast4_@1#0] -- vbum1=vbuc1 
    lda #SIZEOF_CHAR*$80
    sta memset_fast4_num
    // [209] phi from lru_cache_init::memset_fast4_@1 to lru_cache_init::memset_fast4_@1 [phi:lru_cache_init::memset_fast4_@1->lru_cache_init::memset_fast4_@1]
    // [209] phi lru_cache_init::memset_fast4_num#2 = lru_cache_init::memset_fast4_num#1 [phi:lru_cache_init::memset_fast4_@1->lru_cache_init::memset_fast4_@1#0] -- register_copy 
    // lru_cache_init::memset_fast4_@1
  memset_fast4___b1:
    // *(destination+num) = c
    // [210] lru_cache_init::memset_fast4_destination#0[lru_cache_init::memset_fast4_num#2] = lru_cache_init::memset_fast4_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast4_c
    ldy memset_fast4_num
    sta memset_fast4_destination,y
    // num--;
    // [211] lru_cache_init::memset_fast4_num#1 = -- lru_cache_init::memset_fast4_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast4_num
    // while(num)
    // [212] if(0!=lru_cache_init::memset_fast4_num#1) goto lru_cache_init::memset_fast4_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast4_num
    bne memset_fast4___b1
    // [213] phi from lru_cache_init::memset_fast4_@1 to lru_cache_init::memset_fast5 [phi:lru_cache_init::memset_fast4_@1->lru_cache_init::memset_fast5]
    // lru_cache_init::memset_fast5
    // [214] phi from lru_cache_init::memset_fast5 to lru_cache_init::memset_fast5_@1 [phi:lru_cache_init::memset_fast5->lru_cache_init::memset_fast5_@1]
    // [214] phi lru_cache_init::memset_fast5_num#2 = SIZEOF_CHAR*$80 [phi:lru_cache_init::memset_fast5->lru_cache_init::memset_fast5_@1#0] -- vbum1=vbuc1 
    lda #SIZEOF_CHAR*$80
    sta memset_fast5_num
    // [214] phi from lru_cache_init::memset_fast5_@1 to lru_cache_init::memset_fast5_@1 [phi:lru_cache_init::memset_fast5_@1->lru_cache_init::memset_fast5_@1]
    // [214] phi lru_cache_init::memset_fast5_num#2 = lru_cache_init::memset_fast5_num#1 [phi:lru_cache_init::memset_fast5_@1->lru_cache_init::memset_fast5_@1#0] -- register_copy 
    // lru_cache_init::memset_fast5_@1
  memset_fast5___b1:
    // *(destination+num) = c
    // [215] lru_cache_init::memset_fast5_destination#0[lru_cache_init::memset_fast5_num#2] = lru_cache_init::memset_fast5_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast5_c
    ldy memset_fast5_num
    sta memset_fast5_destination,y
    // num--;
    // [216] lru_cache_init::memset_fast5_num#1 = -- lru_cache_init::memset_fast5_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast5_num
    // while(num)
    // [217] if(0!=lru_cache_init::memset_fast5_num#1) goto lru_cache_init::memset_fast5_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast5_num
    bne memset_fast5___b1
    // lru_cache_init::@1
    // lru_cache.first = 0xFF
    // [218] *((char *)&lru_cache+$381) = $ff -- _deref_pbuc1=vbuc2 
    lda #$ff
    sta lru_cache+$381
    // lru_cache.last = 0xFF
    // [219] *((char *)&lru_cache+$382) = $ff -- _deref_pbuc1=vbuc2 
    sta lru_cache+$382
    // lru_cache.count = 0
    // [220] *((char *)&lru_cache+$380) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta lru_cache+$380
    // lru_cache.size = LRU_CACHE_SIZE
    // [221] *((char *)&lru_cache+$383) = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta lru_cache+$383
    // lru_cache_init::@return
    // }
    // [222] return 
    rts
    memset_fast1_num: .byte 0
    memset_fast2_num: .byte 0
    memset_fast3_num: .byte 0
    memset_fast4_num: .byte 0
    memset_fast5_num: .byte 0
}
.segment Code
  // main
main: {
    // main::@return
    // [224] return 
    rts
}
.segment CodeLruCache
  // lru_cache_hash
// __mem unsigned char lru_cache_seed;
// __mem() char lru_cache_hash(__mem() unsigned int key)
lru_cache_hash: {
    // key % LRU_CACHE_SIZE
    // [226] lru_cache_hash::$0 = lru_cache_hash::key#4 & $80-1 -- vwum1=vwum2_band_vbuc1 
    lda #$80-1
    and key
    sta lru_cache_hash__0
    lda #0
    sta lru_cache_hash__0+1
    // return (lru_cache_index_t)(key % LRU_CACHE_SIZE);
    // [227] lru_cache_hash::return#0 = (char)lru_cache_hash::$0 -- vbum1=_byte_vwum2 
    lda lru_cache_hash__0
    sta return
    // lru_cache_hash::@return
    // }
    // [228] return 
    rts
    lru_cache_hash__0: .word 0
  .segment Data
    return: .byte 0
    key: .word 0
    return_1: .byte 0
    return_2: .byte 0
    return_3: .byte 0
    return_4: .byte 0
}
.segment CodeLruCache
  // lru_cache_find_head
// __mem() char lru_cache_find_head(__mem() char index)
lru_cache_find_head: {
    // lru_cache_key_t key_link = lru_cache.key[index]
    // [229] lru_cache_find_head::$2 = lru_cache_find_head::index#0 << 1 -- vbum1=vbum2_rol_1 
    lda index
    asl
    sta lru_cache_find_head__2
    // [230] lru_cache_find_head::key_link#0 = ((unsigned int *)&lru_cache)[lru_cache_find_head::$2] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda lru_cache,y
    sta key_link
    lda lru_cache+1,y
    sta key_link+1
    // lru_cache_index_t head_link = lru_cache_hash(key_link)
    // [231] lru_cache_hash::key#3 = lru_cache_find_head::key_link#0 -- vwum1=vwum2 
    lda key_link
    sta lru_cache_hash.key
    lda key_link+1
    sta lru_cache_hash.key+1
    // [232] call lru_cache_hash
    // [225] phi from lru_cache_find_head to lru_cache_hash [phi:lru_cache_find_head->lru_cache_hash]
    // [225] phi lru_cache_hash::key#4 = lru_cache_hash::key#3 [phi:lru_cache_find_head->lru_cache_hash#0] -- call_phi_near 
    jsr lru_cache_hash
    // lru_cache_index_t head_link = lru_cache_hash(key_link)
    // [233] lru_cache_hash::return#10 = lru_cache_hash::return#0 -- vbum1=vbum2 
    lda lru_cache_hash.return
    sta lru_cache_hash.return_4
    // lru_cache_find_head::@2
    // [234] lru_cache_find_head::head_link#0 = lru_cache_hash::return#10 -- vbum1=vbum2 
    sta head_link
    // if (head_link != index)
    // [235] if(lru_cache_find_head::head_link#0!=lru_cache_find_head::index#0) goto lru_cache_find_head::@1 -- vbum1_neq_vbum2_then_la1 
    cmp index
    bne __b1
    // [237] phi from lru_cache_find_head::@2 to lru_cache_find_head::@return [phi:lru_cache_find_head::@2->lru_cache_find_head::@return]
    // [237] phi lru_cache_find_head::return#3 = $ff [phi:lru_cache_find_head::@2->lru_cache_find_head::@return#0] -- vbum1=vbuc1 
    lda #$ff
    sta return_1
    rts
    // [236] phi from lru_cache_find_head::@2 to lru_cache_find_head::@1 [phi:lru_cache_find_head::@2->lru_cache_find_head::@1]
    // lru_cache_find_head::@1
  __b1:
    // [237] phi from lru_cache_find_head::@1 to lru_cache_find_head::@return [phi:lru_cache_find_head::@1->lru_cache_find_head::@return]
    // [237] phi lru_cache_find_head::return#3 = lru_cache_find_head::head_link#0 [phi:lru_cache_find_head::@1->lru_cache_find_head::@return#0] -- register_copy 
    // lru_cache_find_head::@return
    // }
    // [238] return 
    rts
    lru_cache_find_head__2: .byte 0
  .segment Data
    index: .byte 0
    return: .byte 0
  .segment CodeLruCache
    key_link: .word 0
    .label head_link = return_1
  .segment Data
    return_1: .byte 0
}
.segment CodeLruCache
  // lru_cache_find_duplicate
// __mem() char lru_cache_find_duplicate(__mem() char index, __mem() char link)
lru_cache_find_duplicate: {
    // [240] phi from lru_cache_find_duplicate lru_cache_find_duplicate::@2 to lru_cache_find_duplicate::@1 [phi:lru_cache_find_duplicate/lru_cache_find_duplicate::@2->lru_cache_find_duplicate::@1]
  __b1:
    // [240] phi lru_cache_find_duplicate::index#3 = lru_cache_find_duplicate::index#6 [phi:lru_cache_find_duplicate/lru_cache_find_duplicate::@2->lru_cache_find_duplicate::@1#0] -- register_copy 
  // First find the last duplicate node.
    // lru_cache_find_duplicate::@1
    // while (lru_cache.link[index] != link && lru_cache.link[index] != LRU_CACHE_INDEX_NULL)
    // [241] if(((char *)&lru_cache+$300)[lru_cache_find_duplicate::index#3]==lru_cache_find_duplicate::link#3) goto lru_cache_find_duplicate::@return -- pbuc1_derefidx_vbum1_eq_vbum2_then_la1 
    ldy index
    lda lru_cache+$300,y
    cmp link
    beq __breturn
    // lru_cache_find_duplicate::@3
    // [242] if(((char *)&lru_cache+$300)[lru_cache_find_duplicate::index#3]!=$ff) goto lru_cache_find_duplicate::@2 -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #$ff
    cmp lru_cache+$300,y
    bne __b2
    // lru_cache_find_duplicate::@return
  __breturn:
    // }
    // [243] return 
    rts
    // lru_cache_find_duplicate::@2
  __b2:
    // index = lru_cache.link[index]
    // [244] lru_cache_find_duplicate::index#2 = ((char *)&lru_cache+$300)[lru_cache_find_duplicate::index#3] -- vbum1=pbuc1_derefidx_vbum1 
    ldy index
    lda lru_cache+$300,y
    sta index
    jmp __b1
  .segment Data
    index: .byte 0
    link: .byte 0
    return: .byte 0
    return_1: .byte 0
}
.segment CodeLruCache
  // lru_cache_find_empty
// __mem() char lru_cache_find_empty(__mem() char index)
lru_cache_find_empty: {
    // [246] phi from lru_cache_find_empty lru_cache_find_empty::@2 to lru_cache_find_empty::@1 [phi:lru_cache_find_empty/lru_cache_find_empty::@2->lru_cache_find_empty::@1]
    // [246] phi lru_cache_find_empty::index#4 = lru_cache_find_empty::index#7 [phi:lru_cache_find_empty/lru_cache_find_empty::@2->lru_cache_find_empty::@1#0] -- register_copy 
    // lru_cache_find_empty::@1
  __b1:
    // lru_cache.key[index] != LRU_CACHE_NOTHING
    // [247] lru_cache_find_empty::$1 = lru_cache_find_empty::index#4 << 1 -- vbum1=vbum2_rol_1 
    lda index
    asl
    sta lru_cache_find_empty__1
    // while (lru_cache.key[index] != LRU_CACHE_NOTHING)
    // [248] if(((unsigned int *)&lru_cache)[lru_cache_find_empty::$1]!=$ffff) goto lru_cache_find_empty::@2 -- pwuc1_derefidx_vbum1_neq_vwuc2_then_la1 
    tay
    lda lru_cache+1,y
    cmp #>$ffff
    bne __b2
    lda lru_cache,y
    cmp #<$ffff
    bne __b2
    // lru_cache_find_empty::@return
    // }
    // [249] return 
    rts
    // lru_cache_find_empty::@2
  __b2:
    // index++;
    // [250] lru_cache_find_empty::index#2 = ++ lru_cache_find_empty::index#4 -- vbum1=_inc_vbum2 
    lda index
    inc
    sta index_1
    // index %= LRU_CACHE_SIZE
    // [251] lru_cache_find_empty::index#3 = lru_cache_find_empty::index#2 & $80-1 -- vbum1=vbum2_band_vbuc1 
    lda #$80-1
    and index_1
    sta index
    jmp __b1
    lru_cache_find_empty__1: .byte 0
  .segment Data
    index: .byte 0
    return: .byte 0
    return_1: .byte 0
    index_1: .byte 0
}
  // File Data
.segment CodeLruCache
  funcs: .word lru_cache_init, lru_cache_index, lru_cache_get, lru_cache_set, lru_cache_data, lru_cache_is_max, lru_cache_find_last, lru_cache_delete, lru_cache_insert
  lru_cache: .fill SIZEOF_STRUCT___0, 0
