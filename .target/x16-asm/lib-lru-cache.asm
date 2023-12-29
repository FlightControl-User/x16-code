  // File Comments
  // Library
.namespace lib_lru_cache {
  // Upstart
.cpu _65c02
  
#if __asm_import__
#else
#if __lru_cache__

#else

.segmentdef Code                    [start=$80d]
.segmentdef CodeLruCache            [startAfter="Code"]
.segmentdef Data                    [startAfter="CodeLruCache"]

:BasicUpstart(__lib_lru_cache_start)

#endif
#endif
  // Global Constants & labels
  .const SIZEOF_UNSIGNED_INT = 2
  .const SIZEOF_CHAR = 1
  .const SIZEOF_STRUCT___0 = $384
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __lib_lru_cache_start
// void __lib_lru_cache_start()
__lib_lru_cache_start: {
    // __lib_lru_cache_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __lib_lru_cache_start::@return
    // [3] return 
    rts
}
.segment CodeLruCache
  // lru_cache_delete
// __zp(2) unsigned int lru_cache_delete(__zp($a) unsigned int key)
lru_cache_delete: {
    .label key = $a
    .label return = 2
    .label lru_cache_delete__16 = 4
    .label lru_cache_move_link1_lru_cache_delete__9 = $c
    // move in array until an empty
    .label index_prev = 5
    .label data = 2
    .label next = 6
    .label prev = 9
    .label lru_cache_move_link1_index = $d
    .label lru_cache_move_link1_key = 7
    .label lru_cache_move_link1_data = 7
    .label lru_cache_move_link1_next = 5
    .label lru_cache_move_link1_prev = 6
    // lru_cache_index_t index = lru_cache_hash(key)
    // [4] lru_cache_hash::key#2 = lru_cache_delete::key -- vwuz1=vwuz2 
    lda.z key
    sta.z lru_cache_hash.key
    lda.z key+1
    sta.z lru_cache_hash.key+1
    // [5] call lru_cache_hash
    // [210] phi from lru_cache_delete to lru_cache_hash [phi:lru_cache_delete->lru_cache_hash]
    // [210] phi lru_cache_hash::key#4 = lru_cache_hash::key#2 [phi:lru_cache_delete->lru_cache_hash#0] -- register_copy 
    jsr lru_cache_hash
    // lru_cache_index_t index = lru_cache_hash(key)
    // [6] lru_cache_hash::return#4 = lru_cache_hash::return#0
    // lru_cache_delete::@15
    // [7] lru_cache_delete::index#0 = lru_cache_hash::return#4 -- vbuxx=vbuaa 
    tax
    // [8] phi from lru_cache_delete::@15 to lru_cache_delete::@1 [phi:lru_cache_delete::@15->lru_cache_delete::@1]
    // [8] phi lru_cache_delete::index_prev#10 = $ff [phi:lru_cache_delete::@15->lru_cache_delete::@1#0] -- vbuz1=vbuc1 
    lda #$ff
    sta.z index_prev
    // [8] phi lru_cache_delete::index#2 = lru_cache_delete::index#0 [phi:lru_cache_delete::@15->lru_cache_delete::@1#1] -- register_copy 
    // lru_cache_delete::@1
  __b1:
    // lru_cache.key[index] != LRU_CACHE_NOTHING
    // [9] lru_cache_delete::$16 = lru_cache_delete::index#2 << 1 -- vbuz1=vbuxx_rol_1 
    txa
    asl
    sta.z lru_cache_delete__16
    // while (lru_cache.key[index] != LRU_CACHE_NOTHING)
    // [10] if(((unsigned int *)&lru_cache)[lru_cache_delete::$16]!=$ffff) goto lru_cache_delete::@2 -- pwuc1_derefidx_vbuz1_neq_vwuc2_then_la1 
    tay
    lda lru_cache+1,y
    cmp #>$ffff
    bne __b2
    lda lru_cache,y
    cmp #<$ffff
    bne __b2
    // lru_cache_delete::@3
    // return LRU_CACHE_NOTHING;
    // [11] lru_cache_delete::return = $ffff -- vwuz1=vwuc1 
    lda #<$ffff
    sta.z return
    lda #>$ffff
    sta.z return+1
    // lru_cache_delete::@return
    // }
    // [12] return 
    rts
    // lru_cache_delete::@2
  __b2:
    // if (lru_cache.key[index] == key)
    // [13] if(((unsigned int *)&lru_cache)[lru_cache_delete::$16]!=lru_cache_delete::key) goto lru_cache_delete::@4 -- pwuc1_derefidx_vbuz1_neq_vwuz2_then_la1 
    ldy.z lru_cache_delete__16
    lda.z key+1
    cmp lru_cache+1,y
    beq !__b4+
    jmp __b4
  !__b4:
    lda.z key
    cmp lru_cache,y
    beq !__b4+
    jmp __b4
  !__b4:
    // lru_cache_delete::@12
    // lru_cache_data_t data = lru_cache.data[index]
    // [14] lru_cache_delete::data#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_delete::$16] -- vwuz1=pwuc1_derefidx_vbuz2 
    lda lru_cache+$100,y
    sta.z data
    lda lru_cache+$100+1,y
    sta.z data+1
    // lru_cache.key[index] = LRU_CACHE_NOTHING
    // [15] ((unsigned int *)&lru_cache)[lru_cache_delete::$16] = $ffff -- pwuc1_derefidx_vbuz1=vwuc2 
    // First remove the index node.
    lda #<$ffff
    sta lru_cache,y
    lda #>$ffff
    sta lru_cache+1,y
    // lru_cache.data[index] = LRU_CACHE_NOTHING
    // [16] ((unsigned int *)&lru_cache+$100)[lru_cache_delete::$16] = $ffff -- pwuc1_derefidx_vbuz1=vwuc2 
    lda #<$ffff
    sta lru_cache+$100,y
    lda #>$ffff
    sta lru_cache+$100+1,y
    // lru_cache_index_t next = lru_cache.next[index]
    // [17] lru_cache_delete::next#0 = ((char *)&lru_cache+$280)[lru_cache_delete::index#2] -- vbuz1=pbuc1_derefidx_vbuxx 
    lda lru_cache+$280,x
    sta.z next
    // lru_cache_index_t prev = lru_cache.prev[index]
    // [18] lru_cache_delete::prev#0 = ((char *)&lru_cache+$200)[lru_cache_delete::index#2] -- vbuz1=pbuc1_derefidx_vbuxx 
    lda lru_cache+$200,x
    sta.z prev
    // lru_cache.next[index] = LRU_CACHE_INDEX_NULL
    // [19] ((char *)&lru_cache+$280)[lru_cache_delete::index#2] = $ff -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #$ff
    sta lru_cache+$280,x
    // lru_cache.prev[index] = LRU_CACHE_INDEX_NULL
    // [20] ((char *)&lru_cache+$200)[lru_cache_delete::index#2] = $ff -- pbuc1_derefidx_vbuxx=vbuc2 
    sta lru_cache+$200,x
    // if (lru_cache.next[index] == index)
    // [21] if(((char *)&lru_cache+$280)[lru_cache_delete::index#2]==lru_cache_delete::index#2) goto lru_cache_delete::@5 -- pbuc1_derefidx_vbuxx_eq_vbuxx_then_la1 
    lda lru_cache+$280,x
    tay
    sty.z $ff
    cpx.z $ff
    bne !__b5+
    jmp __b5
  !__b5:
    // lru_cache_delete::@13
    // lru_cache.next[prev] = next
    // [22] ((char *)&lru_cache+$280)[lru_cache_delete::prev#0] = lru_cache_delete::next#0 -- pbuc1_derefidx_vbuz1=vbuz2 
    // Delete the node from the list.
    lda.z next
    ldy.z prev
    sta lru_cache+$280,y
    // lru_cache.prev[next] = prev
    // [23] ((char *)&lru_cache+$200)[lru_cache_delete::next#0] = lru_cache_delete::prev#0 -- pbuc1_derefidx_vbuz1=vbuz2 
    tya
    ldy.z next
    sta lru_cache+$200,y
    // if (index == lru_cache.first)
    // [24] if(lru_cache_delete::index#2!=*((char *)&lru_cache+$381)) goto lru_cache_delete::@6 -- vbuxx_neq__deref_pbuc1_then_la1 
    cpx lru_cache+$381
    bne __b6
    // lru_cache_delete::@14
    // lru_cache.first = next
    // [25] *((char *)&lru_cache+$381) = lru_cache_delete::next#0 -- _deref_pbuc1=vbuz1 
    tya
    sta lru_cache+$381
    // lru_cache_delete::@6
  __b6:
    // if (index == lru_cache.last)
    // [26] if(lru_cache_delete::index#2!=*((char *)&lru_cache+$382)) goto lru_cache_delete::@8 -- vbuxx_neq__deref_pbuc1_then_la1 
    cpx lru_cache+$382
    bne __b8
    // lru_cache_delete::@7
    // lru_cache.last = prev
    // [27] *((char *)&lru_cache+$382) = lru_cache_delete::prev#0 -- _deref_pbuc1=vbuz1 
    lda.z prev
    sta lru_cache+$382
    // lru_cache_delete::@8
  __b8:
    // lru_cache_index_t link = lru_cache.link[index]
    // [28] lru_cache_delete::lru_cache_move_link1_index#0 = ((char *)&lru_cache+$300)[lru_cache_delete::index#2] -- vbuz1=pbuc1_derefidx_vbuxx 
    lda lru_cache+$300,x
    sta.z lru_cache_move_link1_index
    // if (index_prev != LRU_CACHE_INDEX_NULL)
    // [29] if(lru_cache_delete::index_prev#10==$ff) goto lru_cache_delete::@9 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z index_prev
    beq __b9
    // lru_cache_delete::@11
    // lru_cache.link[index_prev] = link
    // [30] ((char *)&lru_cache+$300)[lru_cache_delete::index_prev#10] = lru_cache_delete::lru_cache_move_link1_index#0 -- pbuc1_derefidx_vbuz1=vbuz2 
    // The node is not the first node but the middle of a list.
    lda.z lru_cache_move_link1_index
    ldy.z index_prev
    sta lru_cache+$300,y
    // lru_cache_delete::@9
  __b9:
    // if (link != LRU_CACHE_INDEX_NULL)
    // [31] if(lru_cache_delete::lru_cache_move_link1_index#0==$ff) goto lru_cache_delete::@10 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z lru_cache_move_link1_index
    bne !__b10+
    jmp __b10
  !__b10:
    // lru_cache_delete::lru_cache_move_link1
    // lru_cache_index_t l = lru_cache.link[index]
    // [32] lru_cache_delete::lru_cache_move_link1_l#0 = ((char *)&lru_cache+$300)[lru_cache_delete::lru_cache_move_link1_index#0] -- vbuaa=pbuc1_derefidx_vbuz1 
    ldy.z lru_cache_move_link1_index
    lda lru_cache+$300,y
    // lru_cache.link[link] = l
    // [33] ((char *)&lru_cache+$300)[lru_cache_delete::index#2] = lru_cache_delete::lru_cache_move_link1_l#0 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta lru_cache+$300,x
    // lru_cache_key_t key = lru_cache.key[index]
    // [34] lru_cache_delete::lru_cache_move_link1_$9 = lru_cache_delete::lru_cache_move_link1_index#0 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z lru_cache_move_link1_lru_cache_delete__9
    // [35] lru_cache_delete::lru_cache_move_link1_key#0 = ((unsigned int *)&lru_cache)[lru_cache_delete::lru_cache_move_link1_$9] -- vwuz1=pwuc1_derefidx_vbuz2 
    tay
    lda lru_cache,y
    sta.z lru_cache_move_link1_key
    lda lru_cache+1,y
    sta.z lru_cache_move_link1_key+1
    // lru_cache.key[link] = key
    // [36] ((unsigned int *)&lru_cache)[lru_cache_delete::$16] = lru_cache_delete::lru_cache_move_link1_key#0 -- pwuc1_derefidx_vbuz1=vwuz2 
    ldy.z lru_cache_delete__16
    lda.z lru_cache_move_link1_key
    sta lru_cache,y
    lda.z lru_cache_move_link1_key+1
    sta lru_cache+1,y
    // lru_cache_data_t data = lru_cache.data[index]
    // [37] lru_cache_delete::lru_cache_move_link1_data#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_delete::lru_cache_move_link1_$9] -- vwuz1=pwuc1_derefidx_vbuz2 
    ldy.z lru_cache_move_link1_lru_cache_delete__9
    lda lru_cache+$100,y
    sta.z lru_cache_move_link1_data
    lda lru_cache+$100+1,y
    sta.z lru_cache_move_link1_data+1
    // lru_cache.data[link] = data
    // [38] ((unsigned int *)&lru_cache+$100)[lru_cache_delete::$16] = lru_cache_delete::lru_cache_move_link1_data#0 -- pwuc1_derefidx_vbuz1=vwuz2 
    ldy.z lru_cache_delete__16
    lda.z lru_cache_move_link1_data
    sta lru_cache+$100,y
    lda.z lru_cache_move_link1_data+1
    sta lru_cache+$100+1,y
    // lru_cache_index_t next = lru_cache.next[index]
    // [39] lru_cache_delete::lru_cache_move_link1_next#0 = ((char *)&lru_cache+$280)[lru_cache_delete::lru_cache_move_link1_index#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z lru_cache_move_link1_index
    lda lru_cache+$280,y
    sta.z lru_cache_move_link1_next
    // lru_cache_index_t prev = lru_cache.prev[index]
    // [40] lru_cache_delete::lru_cache_move_link1_prev#0 = ((char *)&lru_cache+$200)[lru_cache_delete::lru_cache_move_link1_index#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    lda lru_cache+$200,y
    sta.z lru_cache_move_link1_prev
    // lru_cache.next[link] = next
    // [41] ((char *)&lru_cache+$280)[lru_cache_delete::index#2] = lru_cache_delete::lru_cache_move_link1_next#0 -- pbuc1_derefidx_vbuxx=vbuz1 
    lda.z lru_cache_move_link1_next
    sta lru_cache+$280,x
    // lru_cache.prev[link] = prev
    // [42] ((char *)&lru_cache+$200)[lru_cache_delete::index#2] = lru_cache_delete::lru_cache_move_link1_prev#0 -- pbuc1_derefidx_vbuxx=vbuz1 
    lda.z lru_cache_move_link1_prev
    sta lru_cache+$200,x
    // lru_cache.next[prev] = link
    // [43] ((char *)&lru_cache+$280)[lru_cache_delete::lru_cache_move_link1_prev#0] = lru_cache_delete::index#2 -- pbuc1_derefidx_vbuz1=vbuxx 
    tay
    txa
    sta lru_cache+$280,y
    // lru_cache.prev[next] = link
    // [44] ((char *)&lru_cache+$200)[lru_cache_delete::lru_cache_move_link1_next#0] = lru_cache_delete::index#2 -- pbuc1_derefidx_vbuz1=vbuxx 
    ldy.z lru_cache_move_link1_next
    txa
    sta lru_cache+$200,y
    // if (lru_cache.last == index)
    // [45] if(*((char *)&lru_cache+$382)!=lru_cache_delete::lru_cache_move_link1_index#0) goto lru_cache_delete::lru_cache_move_link1_@1 -- _deref_pbuc1_neq_vbuz1_then_la1 
    lda lru_cache+$382
    cmp.z lru_cache_move_link1_index
    bne lru_cache_move_link1___b1
    // lru_cache_delete::lru_cache_move_link1_@3
    // lru_cache.last = link
    // [46] *((char *)&lru_cache+$382) = lru_cache_delete::index#2 -- _deref_pbuc1=vbuxx 
    stx lru_cache+$382
    // lru_cache_delete::lru_cache_move_link1_@1
  lru_cache_move_link1___b1:
    // if (lru_cache.first == index)
    // [47] if(*((char *)&lru_cache+$381)!=lru_cache_delete::lru_cache_move_link1_index#0) goto lru_cache_delete::lru_cache_move_link1_@2 -- _deref_pbuc1_neq_vbuz1_then_la1 
    lda lru_cache+$381
    cmp.z lru_cache_move_link1_index
    bne lru_cache_move_link1___b2
    // lru_cache_delete::lru_cache_move_link1_@4
    // lru_cache.first = link
    // [48] *((char *)&lru_cache+$381) = lru_cache_delete::index#2 -- _deref_pbuc1=vbuxx 
    stx lru_cache+$381
    // lru_cache_delete::lru_cache_move_link1_@2
  lru_cache_move_link1___b2:
    // lru_cache.key[index] = LRU_CACHE_NOTHING
    // [49] ((unsigned int *)&lru_cache)[lru_cache_delete::lru_cache_move_link1_$9] = $ffff -- pwuc1_derefidx_vbuz1=vwuc2 
    ldy.z lru_cache_move_link1_lru_cache_delete__9
    lda #<$ffff
    sta lru_cache,y
    lda #>$ffff
    sta lru_cache+1,y
    // lru_cache.data[index] = LRU_CACHE_NOTHING
    // [50] ((unsigned int *)&lru_cache+$100)[lru_cache_delete::lru_cache_move_link1_$9] = $ffff -- pwuc1_derefidx_vbuz1=vwuc2 
    lda #<$ffff
    sta lru_cache+$100,y
    lda #>$ffff
    sta lru_cache+$100+1,y
    // lru_cache.next[index] = LRU_CACHE_INDEX_NULL
    // [51] ((char *)&lru_cache+$280)[lru_cache_delete::lru_cache_move_link1_index#0] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #$ff
    ldy.z lru_cache_move_link1_index
    sta lru_cache+$280,y
    // lru_cache.prev[index] = LRU_CACHE_INDEX_NULL
    // [52] ((char *)&lru_cache+$200)[lru_cache_delete::lru_cache_move_link1_index#0] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    sta lru_cache+$200,y
    // lru_cache.link[index] = LRU_CACHE_INDEX_NULL
    // [53] ((char *)&lru_cache+$300)[lru_cache_delete::lru_cache_move_link1_index#0] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    sta lru_cache+$300,y
    // lru_cache_delete::@10
  __b10:
    // lru_cache.count--;
    // [54] *((char *)&lru_cache+$380) = -- *((char *)&lru_cache+$380) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec lru_cache+$380
    // return data;
    // [55] lru_cache_delete::return = lru_cache_delete::data#0
    rts
    // lru_cache_delete::@5
  __b5:
    // lru_cache.first = 0xff
    // [56] *((char *)&lru_cache+$381) = $ff -- _deref_pbuc1=vbuc2 
    // Reset first and last node.
    lda #$ff
    sta lru_cache+$381
    // lru_cache.last = 0xff
    // [57] *((char *)&lru_cache+$382) = $ff -- _deref_pbuc1=vbuc2 
    sta lru_cache+$382
    jmp __b8
    // lru_cache_delete::@4
  __b4:
    // index_prev = index
    // [58] lru_cache_delete::index_prev#1 = lru_cache_delete::index#2 -- vbuz1=vbuxx 
    stx.z index_prev
    // index = lru_cache.link[index]
    // [59] lru_cache_delete::index#1 = ((char *)&lru_cache+$300)[lru_cache_delete::index#2] -- vbuxx=pbuc1_derefidx_vbuxx 
    lda lru_cache+$300,x
    tax
    // [8] phi from lru_cache_delete::@4 to lru_cache_delete::@1 [phi:lru_cache_delete::@4->lru_cache_delete::@1]
    // [8] phi lru_cache_delete::index_prev#10 = lru_cache_delete::index_prev#1 [phi:lru_cache_delete::@4->lru_cache_delete::@1#0] -- register_copy 
    // [8] phi lru_cache_delete::index#2 = lru_cache_delete::index#1 [phi:lru_cache_delete::@4->lru_cache_delete::@1#1] -- register_copy 
    jmp __b1
}
  // lru_cache_insert
// __zp(6) char lru_cache_insert(__zp($e) unsigned int key, __zp($10) unsigned int data)
lru_cache_insert: {
    .label key = $e
    .label data = $10
    .label return = 6
    .label lru_cache_move_link1_lru_cache_insert__6 = $c
    .label index = 4
    .label link_head = 9
    .label link_prev = $d
    .label index_prev = 5
    .label index_1 = 6
    .label lru_cache_move_link1_link = 5
    .label lru_cache_move_link1_key = 7
    .label lru_cache_move_link1_data = 7
    .label lru_cache_move_link1_next = 6
    // lru_cache_index_t index = lru_cache_hash(key)
    // [60] lru_cache_hash::key#1 = lru_cache_insert::key -- vwuz1=vwuz2 
    lda.z key
    sta.z lru_cache_hash.key
    lda.z key+1
    sta.z lru_cache_hash.key+1
    // [61] call lru_cache_hash
    // [210] phi from lru_cache_insert to lru_cache_hash [phi:lru_cache_insert->lru_cache_hash]
    // [210] phi lru_cache_hash::key#4 = lru_cache_hash::key#1 [phi:lru_cache_insert->lru_cache_hash#0] -- register_copy 
    jsr lru_cache_hash
    // lru_cache_index_t index = lru_cache_hash(key)
    // [62] lru_cache_hash::return#3 = lru_cache_hash::return#0
    // lru_cache_insert::@10
    // [63] lru_cache_insert::index#0 = lru_cache_hash::return#3 -- vbuz1=vbuaa 
    sta.z index
    // lru_cache_index_t link_head = lru_cache_find_head(index)
    // [64] lru_cache_find_head::index#0 = lru_cache_insert::index#0 -- vbuz1=vbuz2 
    sta.z lru_cache_find_head.index
    // [65] call lru_cache_find_head
    // Check if there is already a link node in place in the hash table at the index.
    jsr lru_cache_find_head
    // [66] lru_cache_find_head::return#0 = lru_cache_find_head::return#3
    // lru_cache_insert::@11
    // [67] lru_cache_insert::link_head#0 = lru_cache_find_head::return#0 -- vbuz1=vbuaa 
    sta.z link_head
    // lru_cache_index_t link_prev = lru_cache_find_duplicate(link_head, index)
    // [68] lru_cache_find_duplicate::index#0 = lru_cache_insert::link_head#0 -- vbuxx=vbuz1 
    tax
    // [69] lru_cache_find_duplicate::link#0 = lru_cache_insert::index#0 -- vbuz1=vbuz2 
    lda.z index
    sta.z lru_cache_find_duplicate.link
    // [70] call lru_cache_find_duplicate
    // [224] phi from lru_cache_insert::@11 to lru_cache_find_duplicate [phi:lru_cache_insert::@11->lru_cache_find_duplicate]
    // [224] phi lru_cache_find_duplicate::link#3 = lru_cache_find_duplicate::link#0 [phi:lru_cache_insert::@11->lru_cache_find_duplicate#0] -- register_copy 
    // [224] phi lru_cache_find_duplicate::index#6 = lru_cache_find_duplicate::index#0 [phi:lru_cache_insert::@11->lru_cache_find_duplicate#1] -- register_copy 
    jsr lru_cache_find_duplicate
    // lru_cache_index_t link_prev = lru_cache_find_duplicate(link_head, index)
    // [71] lru_cache_find_duplicate::return#0 = lru_cache_find_duplicate::index#3
    // lru_cache_insert::@12
    // [72] lru_cache_insert::link_prev#0 = lru_cache_find_duplicate::return#0 -- vbuz1=vbuxx 
    stx.z link_prev
    // lru_cache.key[index] != LRU_CACHE_NOTHING
    // [73] lru_cache_insert::lru_cache_move_link1_$6 = lru_cache_insert::index#0 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z index
    asl
    sta.z lru_cache_move_link1_lru_cache_insert__6
    // if (lru_cache.key[index] != LRU_CACHE_NOTHING && link_head != LRU_CACHE_INDEX_NULL)
    // [74] if(((unsigned int *)&lru_cache)[lru_cache_insert::lru_cache_move_link1_$6]==$ffff) goto lru_cache_insert::@1 -- pwuc1_derefidx_vbuz1_eq_vwuc2_then_la1 
    tay
    lda lru_cache,y
    cmp #<$ffff
    bne !+
    lda lru_cache+1,y
    cmp #>$ffff
    beq __b1
  !:
    // lru_cache_insert::@16
    // [75] if(lru_cache_insert::link_head#0!=$ff) goto lru_cache_insert::@5 -- vbuz1_neq_vbuc1_then_la1 
    lda #$ff
    cmp.z link_head
    bne __b5
    // lru_cache_insert::@1
  __b1:
    // lru_cache_index_t index_prev = lru_cache_find_duplicate(index, LRU_CACHE_INDEX_NULL)
    // [76] lru_cache_find_duplicate::index#1 = lru_cache_insert::index#0 -- vbuxx=vbuz1 
    ldx.z index
    // [77] call lru_cache_find_duplicate
  // We just follow the duplicate chain and find the last duplicate.
    // [224] phi from lru_cache_insert::@1 to lru_cache_find_duplicate [phi:lru_cache_insert::@1->lru_cache_find_duplicate]
    // [224] phi lru_cache_find_duplicate::link#3 = $ff [phi:lru_cache_insert::@1->lru_cache_find_duplicate#0] -- vbuz1=vbuc1 
    lda #$ff
    sta.z lru_cache_find_duplicate.link
    // [224] phi lru_cache_find_duplicate::index#6 = lru_cache_find_duplicate::index#1 [phi:lru_cache_insert::@1->lru_cache_find_duplicate#1] -- register_copy 
    jsr lru_cache_find_duplicate
    // lru_cache_index_t index_prev = lru_cache_find_duplicate(index, LRU_CACHE_INDEX_NULL)
    // [78] lru_cache_find_duplicate::return#1 = lru_cache_find_duplicate::index#3
    // lru_cache_insert::@13
    // [79] lru_cache_insert::index_prev#0 = lru_cache_find_duplicate::return#1 -- vbuz1=vbuxx 
    stx.z index_prev
    // lru_cache_find_empty(index_prev)
    // [80] lru_cache_find_empty::index#0 = lru_cache_insert::index_prev#0 -- vbuxx=vbuz1 
    // [81] call lru_cache_find_empty
    // [230] phi from lru_cache_insert::@13 to lru_cache_find_empty [phi:lru_cache_insert::@13->lru_cache_find_empty]
    // [230] phi lru_cache_find_empty::index#7 = lru_cache_find_empty::index#0 [phi:lru_cache_insert::@13->lru_cache_find_empty#0] -- register_copy 
    jsr lru_cache_find_empty
    // lru_cache_find_empty(index_prev)
    // [82] lru_cache_find_empty::return#0 = lru_cache_find_empty::index#4 -- vbuaa=vbuxx 
    txa
    // lru_cache_insert::@14
    // index = lru_cache_find_empty(index_prev)
    // [83] lru_cache_insert::index#1 = lru_cache_find_empty::return#0 -- vbuz1=vbuaa 
    sta.z index_1
    // lru_cache.link[index] = LRU_CACHE_INDEX_NULL
    // [84] ((char *)&lru_cache+$300)[lru_cache_insert::index#1] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    // We set the link of the free node to INDEX_NULL, 
    // and point the link of the previous node to the empty node.
    // index != index_prev indicates there is a duplicate chain. 
    lda #$ff
    ldy.z index_1
    sta lru_cache+$300,y
    // if (index_prev != index)
    // [85] if(lru_cache_insert::index_prev#0==lru_cache_insert::index#1) goto lru_cache_insert::@2 -- vbuz1_eq_vbuz2_then_la1 
    lda.z index_prev
    cmp.z index_1
    beq __b2
    // lru_cache_insert::@6
    // lru_cache.link[index_prev] = index
    // [86] ((char *)&lru_cache+$300)[lru_cache_insert::index_prev#0] = lru_cache_insert::index#1 -- pbuc1_derefidx_vbuz1=vbuz2 
    tya
    ldy.z index_prev
    sta lru_cache+$300,y
    // lru_cache_insert::@2
  __b2:
    // lru_cache.key[index] = key
    // [87] lru_cache_insert::$20 = lru_cache_insert::index#1 << 1 -- vbuxx=vbuz1_rol_1 
    lda.z index_1
    asl
    tax
    // [88] ((unsigned int *)&lru_cache)[lru_cache_insert::$20] = lru_cache_insert::key -- pwuc1_derefidx_vbuxx=vwuz1 
    // Now assign the key and the data.
    lda.z key
    sta lru_cache,x
    lda.z key+1
    sta lru_cache+1,x
    // lru_cache.data[index] = data
    // [89] ((unsigned int *)&lru_cache+$100)[lru_cache_insert::$20] = lru_cache_insert::data -- pwuc1_derefidx_vbuxx=vwuz1 
    lda.z data
    sta lru_cache+$100,x
    lda.z data+1
    sta lru_cache+$100+1,x
    // if (lru_cache.first == 0xff)
    // [90] if(*((char *)&lru_cache+$381)!=$ff) goto lru_cache_insert::@3 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #$ff
    cmp lru_cache+$381
    bne __b3
    // lru_cache_insert::@7
    // lru_cache.first = index
    // [91] *((char *)&lru_cache+$381) = lru_cache_insert::index#1 -- _deref_pbuc1=vbuz1 
    lda.z index_1
    sta lru_cache+$381
    // lru_cache_insert::@3
  __b3:
    // if (lru_cache.last == 0xff)
    // [92] if(*((char *)&lru_cache+$382)!=$ff) goto lru_cache_insert::@4 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #$ff
    cmp lru_cache+$382
    bne __b4
    // lru_cache_insert::@8
    // lru_cache.last = index
    // [93] *((char *)&lru_cache+$382) = lru_cache_insert::index#1 -- _deref_pbuc1=vbuz1 
    lda.z index_1
    sta lru_cache+$382
    // lru_cache_insert::@4
  __b4:
    // lru_cache.next[index] = lru_cache.first
    // [94] ((char *)&lru_cache+$280)[lru_cache_insert::index#1] = *((char *)&lru_cache+$381) -- pbuc1_derefidx_vbuz1=_deref_pbuc2 
    // Now insert the node as the first node in the list.
    lda lru_cache+$381
    ldy.z index_1
    sta lru_cache+$280,y
    // lru_cache.prev[lru_cache.first] = index
    // [95] ((char *)&lru_cache+$200)[*((char *)&lru_cache+$381)] = lru_cache_insert::index#1 -- pbuc1_derefidx_(_deref_pbuc2)=vbuz1 
    tya
    ldy lru_cache+$381
    sta lru_cache+$200,y
    // lru_cache.next[lru_cache.last] = index
    // [96] ((char *)&lru_cache+$280)[*((char *)&lru_cache+$382)] = lru_cache_insert::index#1 -- pbuc1_derefidx_(_deref_pbuc2)=vbuz1 
    ldy lru_cache+$382
    sta lru_cache+$280,y
    // lru_cache.prev[index] = lru_cache.last
    // [97] ((char *)&lru_cache+$200)[lru_cache_insert::index#1] = *((char *)&lru_cache+$382) -- pbuc1_derefidx_vbuz1=_deref_pbuc2 
    tya
    ldy.z index_1
    sta lru_cache+$200,y
    // lru_cache.first = index
    // [98] *((char *)&lru_cache+$381) = lru_cache_insert::index#1 -- _deref_pbuc1=vbuz1 
    tya
    sta lru_cache+$381
    // lru_cache.count++;
    // [99] *((char *)&lru_cache+$380) = ++ *((char *)&lru_cache+$380) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc lru_cache+$380
    // return index;
    // [100] lru_cache_insert::return = lru_cache_insert::index#1
    // lru_cache_insert::@return
    // }
    // [101] return 
    rts
    // lru_cache_insert::@5
  __b5:
    // lru_cache_index_t link = lru_cache_find_empty(index)
    // [102] lru_cache_find_empty::index#1 = lru_cache_insert::index#0 -- vbuxx=vbuz1 
    ldx.z index
    // [103] call lru_cache_find_empty
  // There is already a link node, so this node is not a head node and needs to be moved.
  // Get the head node of this chain, we know this because we can get the head of the key.
  // The link of the head_link must be changed once the new place of the link node has been found.
    // [230] phi from lru_cache_insert::@5 to lru_cache_find_empty [phi:lru_cache_insert::@5->lru_cache_find_empty]
    // [230] phi lru_cache_find_empty::index#7 = lru_cache_find_empty::index#1 [phi:lru_cache_insert::@5->lru_cache_find_empty#0] -- register_copy 
    jsr lru_cache_find_empty
    // lru_cache_index_t link = lru_cache_find_empty(index)
    // [104] lru_cache_find_empty::return#1 = lru_cache_find_empty::index#4
    // lru_cache_insert::@15
    // [105] lru_cache_insert::lru_cache_move_link1_link#0 = lru_cache_find_empty::return#1 -- vbuz1=vbuxx 
    stx.z lru_cache_move_link1_link
    // lru_cache_insert::lru_cache_move_link1
    // lru_cache_index_t l = lru_cache.link[index]
    // [106] lru_cache_insert::lru_cache_move_link1_l#0 = ((char *)&lru_cache+$300)[lru_cache_insert::index#0] -- vbuaa=pbuc1_derefidx_vbuz1 
    ldy.z index
    lda lru_cache+$300,y
    // lru_cache.link[link] = l
    // [107] ((char *)&lru_cache+$300)[lru_cache_insert::lru_cache_move_link1_link#0] = lru_cache_insert::lru_cache_move_link1_l#0 -- pbuc1_derefidx_vbuz1=vbuaa 
    ldy.z lru_cache_move_link1_link
    sta lru_cache+$300,y
    // lru_cache_key_t key = lru_cache.key[index]
    // [108] lru_cache_insert::lru_cache_move_link1_key#0 = ((unsigned int *)&lru_cache)[lru_cache_insert::lru_cache_move_link1_$6] -- vwuz1=pwuc1_derefidx_vbuz2 
    ldy.z lru_cache_move_link1_lru_cache_insert__6
    lda lru_cache,y
    sta.z lru_cache_move_link1_key
    lda lru_cache+1,y
    sta.z lru_cache_move_link1_key+1
    // lru_cache.key[link] = key
    // [109] lru_cache_insert::lru_cache_move_link1_$7 = lru_cache_insert::lru_cache_move_link1_link#0 << 1 -- vbuxx=vbuz1_rol_1 
    txa
    asl
    tax
    // [110] ((unsigned int *)&lru_cache)[lru_cache_insert::lru_cache_move_link1_$7] = lru_cache_insert::lru_cache_move_link1_key#0 -- pwuc1_derefidx_vbuxx=vwuz1 
    lda.z lru_cache_move_link1_key
    sta lru_cache,x
    lda.z lru_cache_move_link1_key+1
    sta lru_cache+1,x
    // lru_cache_data_t data = lru_cache.data[index]
    // [111] lru_cache_insert::lru_cache_move_link1_data#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_insert::lru_cache_move_link1_$6] -- vwuz1=pwuc1_derefidx_vbuz2 
    lda lru_cache+$100,y
    sta.z lru_cache_move_link1_data
    lda lru_cache+$100+1,y
    sta.z lru_cache_move_link1_data+1
    // lru_cache.data[link] = data
    // [112] ((unsigned int *)&lru_cache+$100)[lru_cache_insert::lru_cache_move_link1_$7] = lru_cache_insert::lru_cache_move_link1_data#0 -- pwuc1_derefidx_vbuxx=vwuz1 
    lda.z lru_cache_move_link1_data
    sta lru_cache+$100,x
    lda.z lru_cache_move_link1_data+1
    sta lru_cache+$100+1,x
    // lru_cache_index_t next = lru_cache.next[index]
    // [113] lru_cache_insert::lru_cache_move_link1_next#0 = ((char *)&lru_cache+$280)[lru_cache_insert::index#0] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z index
    lda lru_cache+$280,y
    sta.z lru_cache_move_link1_next
    // lru_cache_index_t prev = lru_cache.prev[index]
    // [114] lru_cache_insert::lru_cache_move_link1_prev#0 = ((char *)&lru_cache+$200)[lru_cache_insert::index#0] -- vbuxx=pbuc1_derefidx_vbuz1 
    ldx lru_cache+$200,y
    // lru_cache.next[link] = next
    // [115] ((char *)&lru_cache+$280)[lru_cache_insert::lru_cache_move_link1_link#0] = lru_cache_insert::lru_cache_move_link1_next#0 -- pbuc1_derefidx_vbuz1=vbuz2 
    ldy.z lru_cache_move_link1_link
    sta lru_cache+$280,y
    // lru_cache.prev[link] = prev
    // [116] ((char *)&lru_cache+$200)[lru_cache_insert::lru_cache_move_link1_link#0] = lru_cache_insert::lru_cache_move_link1_prev#0 -- pbuc1_derefidx_vbuz1=vbuxx 
    txa
    sta lru_cache+$200,y
    // lru_cache.next[prev] = link
    // [117] ((char *)&lru_cache+$280)[lru_cache_insert::lru_cache_move_link1_prev#0] = lru_cache_insert::lru_cache_move_link1_link#0 -- pbuc1_derefidx_vbuxx=vbuz1 
    tya
    sta lru_cache+$280,x
    // lru_cache.prev[next] = link
    // [118] ((char *)&lru_cache+$200)[lru_cache_insert::lru_cache_move_link1_next#0] = lru_cache_insert::lru_cache_move_link1_link#0 -- pbuc1_derefidx_vbuz1=vbuz2 
    ldy.z lru_cache_move_link1_next
    sta lru_cache+$200,y
    // if (lru_cache.last == index)
    // [119] if(*((char *)&lru_cache+$382)!=lru_cache_insert::index#0) goto lru_cache_insert::lru_cache_move_link1_@1 -- _deref_pbuc1_neq_vbuz1_then_la1 
    lda lru_cache+$382
    cmp.z index
    bne lru_cache_move_link1___b1
    // lru_cache_insert::lru_cache_move_link1_@3
    // lru_cache.last = link
    // [120] *((char *)&lru_cache+$382) = lru_cache_insert::lru_cache_move_link1_link#0 -- _deref_pbuc1=vbuz1 
    lda.z lru_cache_move_link1_link
    sta lru_cache+$382
    // lru_cache_insert::lru_cache_move_link1_@1
  lru_cache_move_link1___b1:
    // if (lru_cache.first == index)
    // [121] if(*((char *)&lru_cache+$381)!=lru_cache_insert::index#0) goto lru_cache_insert::lru_cache_move_link1_@2 -- _deref_pbuc1_neq_vbuz1_then_la1 
    lda lru_cache+$381
    cmp.z index
    bne lru_cache_move_link1___b2
    // lru_cache_insert::lru_cache_move_link1_@4
    // lru_cache.first = link
    // [122] *((char *)&lru_cache+$381) = lru_cache_insert::lru_cache_move_link1_link#0 -- _deref_pbuc1=vbuz1 
    lda.z lru_cache_move_link1_link
    sta lru_cache+$381
    // lru_cache_insert::lru_cache_move_link1_@2
  lru_cache_move_link1___b2:
    // lru_cache.key[index] = LRU_CACHE_NOTHING
    // [123] ((unsigned int *)&lru_cache)[lru_cache_insert::lru_cache_move_link1_$6] = $ffff -- pwuc1_derefidx_vbuz1=vwuc2 
    ldy.z lru_cache_move_link1_lru_cache_insert__6
    lda #<$ffff
    sta lru_cache,y
    lda #>$ffff
    sta lru_cache+1,y
    // lru_cache.data[index] = LRU_CACHE_NOTHING
    // [124] ((unsigned int *)&lru_cache+$100)[lru_cache_insert::lru_cache_move_link1_$6] = $ffff -- pwuc1_derefidx_vbuz1=vwuc2 
    lda #<$ffff
    sta lru_cache+$100,y
    lda #>$ffff
    sta lru_cache+$100+1,y
    // lru_cache.next[index] = LRU_CACHE_INDEX_NULL
    // [125] ((char *)&lru_cache+$280)[lru_cache_insert::index#0] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #$ff
    ldy.z index
    sta lru_cache+$280,y
    // lru_cache.prev[index] = LRU_CACHE_INDEX_NULL
    // [126] ((char *)&lru_cache+$200)[lru_cache_insert::index#0] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    sta lru_cache+$200,y
    // lru_cache.link[index] = LRU_CACHE_INDEX_NULL
    // [127] ((char *)&lru_cache+$300)[lru_cache_insert::index#0] = $ff -- pbuc1_derefidx_vbuz1=vbuc2 
    sta lru_cache+$300,y
    // lru_cache_insert::@9
    // lru_cache.link[link_prev] = link
    // [128] ((char *)&lru_cache+$300)[lru_cache_insert::link_prev#0] = lru_cache_insert::lru_cache_move_link1_link#0 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z lru_cache_move_link1_link
    ldy.z link_prev
    sta lru_cache+$300,y
    jmp __b1
}
  // lru_cache_data
// __zp(2) unsigned int lru_cache_data(__zp(9) char index)
lru_cache_data: {
    .label index = 9
    .label return = 2
    // return lru_cache.data[index];
    // [129] lru_cache_data::$0 = lru_cache_data::index << 1 -- vbuaa=vbuz1_rol_1 
    lda.z index
    asl
    // [130] lru_cache_data::return = ((unsigned int *)&lru_cache+$100)[lru_cache_data::$0] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda lru_cache+$100,y
    sta.z return
    lda lru_cache+$100+1,y
    sta.z return+1
    // lru_cache_data::@return
    // }
    // [131] return 
    rts
}
  // lru_cache_set
// __zp(2) unsigned int lru_cache_set(__zp(5) char index, __zp($e) unsigned int data)
lru_cache_set: {
    .label index = 5
    .label data = $e
    .label return = 2
    .label lru_cache_set__2 = 2
    // if (index != LRU_CACHE_INDEX_NULL)
    // [132] if(lru_cache_set::index==$ff) goto lru_cache_set::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z index
    beq __b1
    // lru_cache_set::@2
    // lru_cache.data[index] = data
    // [133] lru_cache_set::$3 = lru_cache_set::index << 1 -- vbuaa=vbuz1_rol_1 
    lda.z index
    asl
    // [134] ((unsigned int *)&lru_cache+$100)[lru_cache_set::$3] = lru_cache_set::data -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z data
    sta lru_cache+$100,y
    lda.z data+1
    sta lru_cache+$100+1,y
    // lru_cache_get(index)
    // [135] lru_cache_get::index = lru_cache_set::index
    // [136] callexecute lru_cache_get  -- call_var_near 
    jsr lru_cache_get
    // [137] lru_cache_set::$2 = lru_cache_get::return
    // return lru_cache_get(index);
    // [138] lru_cache_set::return = lru_cache_set::$2
    // lru_cache_set::@return
    // }
    // [139] return 
    rts
    // lru_cache_set::@1
  __b1:
    // return LRU_CACHE_NOTHING;
    // [140] lru_cache_set::return = $ffff -- vwuz1=vwuc1 
    lda #<$ffff
    sta.z return
    lda #>$ffff
    sta.z return+1
    rts
}
  // lru_cache_get
// __zp(2) unsigned int lru_cache_get(__zp(5) char index)
lru_cache_get: {
    .label index = 5
    .label return = 2
    .label data = 2
    .label prev = 6
    // if (index != LRU_CACHE_INDEX_NULL)
    // [141] if(lru_cache_get::index==$ff) goto lru_cache_get::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z index
    beq __b1
    // lru_cache_get::@2
    // lru_cache_data_t data = lru_cache.data[index]
    // [142] lru_cache_get::$6 = lru_cache_get::index << 1 -- vbuaa=vbuz1_rol_1 
    lda.z index
    asl
    // [143] lru_cache_get::data#0 = ((unsigned int *)&lru_cache+$100)[lru_cache_get::$6] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda lru_cache+$100,y
    sta.z data
    lda lru_cache+$100+1,y
    sta.z data+1
    // lru_cache_index_t next = lru_cache.next[index]
    // [144] lru_cache_get::next#0 = ((char *)&lru_cache+$280)[lru_cache_get::index] -- vbuxx=pbuc1_derefidx_vbuz1 
    ldy.z index
    ldx lru_cache+$280,y
    // lru_cache_index_t prev = lru_cache.prev[index]
    // [145] lru_cache_get::prev#0 = ((char *)&lru_cache+$200)[lru_cache_get::index] -- vbuz1=pbuc1_derefidx_vbuz2 
    lda lru_cache+$200,y
    sta.z prev
    // lru_cache.next[prev] = next
    // [146] ((char *)&lru_cache+$280)[lru_cache_get::prev#0] = lru_cache_get::next#0 -- pbuc1_derefidx_vbuz1=vbuxx 
    // Delete the node from the list.
    tay
    txa
    sta lru_cache+$280,y
    // lru_cache.prev[next] = prev
    // [147] ((char *)&lru_cache+$200)[lru_cache_get::next#0] = lru_cache_get::prev#0 -- pbuc1_derefidx_vbuxx=vbuz1 
    //lru_cache.next[next] = prev;
    tya
    sta lru_cache+$200,x
    // if (index == lru_cache.first)
    // [148] if(lru_cache_get::index!=*((char *)&lru_cache+$381)) goto lru_cache_get::@4 -- vbuz1_neq__deref_pbuc1_then_la1 
    lda lru_cache+$381
    cmp.z index
    bne __b4
    // lru_cache_get::@3
    // lru_cache.first = next
    // [149] *((char *)&lru_cache+$381) = lru_cache_get::next#0 -- _deref_pbuc1=vbuxx 
    stx lru_cache+$381
    // lru_cache_get::@4
  __b4:
    // if (index == lru_cache.last)
    // [150] if(lru_cache_get::index!=*((char *)&lru_cache+$382)) goto lru_cache_get::@5 -- vbuz1_neq__deref_pbuc1_then_la1 
    lda lru_cache+$382
    cmp.z index
    bne __b5
    // lru_cache_get::@6
    // lru_cache.last = prev
    // [151] *((char *)&lru_cache+$382) = lru_cache_get::prev#0 -- _deref_pbuc1=vbuz1 
    lda.z prev
    sta lru_cache+$382
    // lru_cache_get::@5
  __b5:
    // lru_cache.next[index] = lru_cache.first
    // [152] ((char *)&lru_cache+$280)[lru_cache_get::index] = *((char *)&lru_cache+$381) -- pbuc1_derefidx_vbuz1=_deref_pbuc2 
    // Now insert the node as the first node in the list.
    lda lru_cache+$381
    ldy.z index
    sta lru_cache+$280,y
    // lru_cache.prev[lru_cache.first] = index
    // [153] ((char *)&lru_cache+$200)[*((char *)&lru_cache+$381)] = lru_cache_get::index -- pbuc1_derefidx_(_deref_pbuc2)=vbuz1 
    tya
    ldy lru_cache+$381
    sta lru_cache+$200,y
    // lru_cache.next[lru_cache.last] = index
    // [154] ((char *)&lru_cache+$280)[*((char *)&lru_cache+$382)] = lru_cache_get::index -- pbuc1_derefidx_(_deref_pbuc2)=vbuz1 
    ldy lru_cache+$382
    sta lru_cache+$280,y
    // lru_cache.prev[index] = lru_cache.last
    // [155] ((char *)&lru_cache+$200)[lru_cache_get::index] = *((char *)&lru_cache+$382) -- pbuc1_derefidx_vbuz1=_deref_pbuc2 
    tya
    ldy.z index
    sta lru_cache+$200,y
    // lru_cache.first = index
    // [156] *((char *)&lru_cache+$381) = lru_cache_get::index -- _deref_pbuc1=vbuz1 
    // Now the first node in the list is the node referenced!
    // All other nodes are moved one position down!
    tya
    sta lru_cache+$381
    // lru_cache.last = lru_cache.prev[index]
    // [157] *((char *)&lru_cache+$382) = ((char *)&lru_cache+$200)[lru_cache_get::index] -- _deref_pbuc1=pbuc2_derefidx_vbuz1 
    lda lru_cache+$200,y
    sta lru_cache+$382
    // return data;
    // [158] lru_cache_get::return = lru_cache_get::data#0
    // lru_cache_get::@return
    // }
    // [159] return 
    rts
    // lru_cache_get::@1
  __b1:
    // return LRU_CACHE_NOTHING;
    // [160] lru_cache_get::return = $ffff -- vwuz1=vwuc1 
    lda #<$ffff
    sta.z return
    lda #>$ffff
    sta.z return+1
    rts
}
  // lru_cache_index
// __zp(4) char lru_cache_index(__zp(7) unsigned int key)
lru_cache_index: {
    .label key = 7
    .label return = 4
    // lru_cache_index_t index = lru_cache_hash(key)
    // [161] lru_cache_hash::key#0 = lru_cache_index::key -- vwuz1=vwuz2 
    lda.z key
    sta.z lru_cache_hash.key
    lda.z key+1
    sta.z lru_cache_hash.key+1
    // [162] call lru_cache_hash
    // [210] phi from lru_cache_index to lru_cache_hash [phi:lru_cache_index->lru_cache_hash]
    // [210] phi lru_cache_hash::key#4 = lru_cache_hash::key#0 [phi:lru_cache_index->lru_cache_hash#0] -- register_copy 
    jsr lru_cache_hash
    // lru_cache_index_t index = lru_cache_hash(key)
    // [163] lru_cache_hash::return#2 = lru_cache_hash::return#0
    // lru_cache_index::@6
    // [164] lru_cache_index::index#0 = lru_cache_hash::return#2 -- vbuxx=vbuaa 
    tax
    // [165] phi from lru_cache_index::@4 lru_cache_index::@6 to lru_cache_index::@1 [phi:lru_cache_index::@4/lru_cache_index::@6->lru_cache_index::@1]
  __b1:
    // [165] phi lru_cache_index::index#2 = lru_cache_index::index#1 [phi:lru_cache_index::@4/lru_cache_index::@6->lru_cache_index::@1#0] -- register_copy 
  // Search till index == 0xFF, following the links.
    // lru_cache_index::@1
    // while (index != LRU_CACHE_INDEX_NULL)
    // [166] if(lru_cache_index::index#2!=$ff) goto lru_cache_index::@2 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$ff
    bne __b2
    // lru_cache_index::@3
    // return LRU_CACHE_INDEX_NULL;
    // [167] lru_cache_index::return = $ff -- vbuz1=vbuc1 
    lda #$ff
    sta.z return
    // lru_cache_index::@return
    // }
    // [168] return 
    rts
    // lru_cache_index::@2
  __b2:
    // lru_cache.key[index] == key
    // [169] lru_cache_index::$4 = lru_cache_index::index#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // if (lru_cache.key[index] == key)
    // [170] if(((unsigned int *)&lru_cache)[lru_cache_index::$4]!=lru_cache_index::key) goto lru_cache_index::@4 -- pwuc1_derefidx_vbuaa_neq_vwuz1_then_la1 
    tay
    lda.z key+1
    cmp lru_cache+1,y
    bne __b4
    lda.z key
    cmp lru_cache,y
    bne __b4
    // lru_cache_index::@5
    // return index;
    // [171] lru_cache_index::return = lru_cache_index::index#2 -- vbuz1=vbuxx 
    stx.z return
    rts
    // lru_cache_index::@4
  __b4:
    // index = lru_cache.link[index]
    // [172] lru_cache_index::index#1 = ((char *)&lru_cache+$300)[lru_cache_index::index#2] -- vbuxx=pbuc1_derefidx_vbuxx 
    lda lru_cache+$300,x
    tax
    jmp __b1
}
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
// __zp(4) bool lru_cache_is_max()
lru_cache_is_max: {
    .label return = 4
    // lru_cache.count >= LRU_CACHE_MAX
    // [173] lru_cache_is_max::$0 = *((char *)&lru_cache+$380) >= $60 -- vboaa=_deref_pbuc1_ge_vbuc2 
    lda lru_cache+$380
    cmp #$60
    bcs !+
    lda #0
    jmp !e+
  !:
    lda #1
  !e:
    // return lru_cache.count >= LRU_CACHE_MAX;
    // [174] lru_cache_is_max::return = lru_cache_is_max::$0 -- vboz1=vboaa 
    sta.z return
    // lru_cache_is_max::@return
    // }
    // [175] return 
    rts
}
  // lru_cache_find_last
// __zp(7) unsigned int lru_cache_find_last()
lru_cache_find_last: {
    .label return = 7
    // return lru_cache.key[lru_cache.last];
    // [176] lru_cache_find_last::$0 = *((char *)&lru_cache+$382) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda lru_cache+$382
    asl
    // [177] lru_cache_find_last::return = ((unsigned int *)&lru_cache)[lru_cache_find_last::$0] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda lru_cache,y
    sta.z return
    lda lru_cache+1,y
    sta.z return+1
    // lru_cache_find_last::@return
    // }
    // [178] return 
    rts
}
  // lru_cache_init
// void lru_cache_init()
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
    // [180] phi from lru_cache_init to lru_cache_init::memset_fast1 [phi:lru_cache_init->lru_cache_init::memset_fast1]
    // lru_cache_init::memset_fast1
    // [181] phi from lru_cache_init::memset_fast1 to lru_cache_init::memset_fast1_@1 [phi:lru_cache_init::memset_fast1->lru_cache_init::memset_fast1_@1]
    // [181] phi lru_cache_init::memset_fast1_num#2 = SIZEOF_UNSIGNED_INT*$80 [phi:lru_cache_init::memset_fast1->lru_cache_init::memset_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #SIZEOF_UNSIGNED_INT*$80
    // [181] phi from lru_cache_init::memset_fast1_@1 to lru_cache_init::memset_fast1_@1 [phi:lru_cache_init::memset_fast1_@1->lru_cache_init::memset_fast1_@1]
    // [181] phi lru_cache_init::memset_fast1_num#2 = lru_cache_init::memset_fast1_num#1 [phi:lru_cache_init::memset_fast1_@1->lru_cache_init::memset_fast1_@1#0] -- register_copy 
    // lru_cache_init::memset_fast1_@1
  memset_fast1___b1:
    // *(destination+num) = c
    // [182] lru_cache_init::memset_fast1_destination#0[lru_cache_init::memset_fast1_num#2] = lru_cache_init::memset_fast1_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast1_c
    sta memset_fast1_destination,x
    // num--;
    // [183] lru_cache_init::memset_fast1_num#1 = -- lru_cache_init::memset_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [184] if(0!=lru_cache_init::memset_fast1_num#1) goto lru_cache_init::memset_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast1___b1
    // [185] phi from lru_cache_init::memset_fast1_@1 to lru_cache_init::memset_fast2 [phi:lru_cache_init::memset_fast1_@1->lru_cache_init::memset_fast2]
    // lru_cache_init::memset_fast2
    // [186] phi from lru_cache_init::memset_fast2 to lru_cache_init::memset_fast2_@1 [phi:lru_cache_init::memset_fast2->lru_cache_init::memset_fast2_@1]
    // [186] phi lru_cache_init::memset_fast2_num#2 = SIZEOF_UNSIGNED_INT*$80 [phi:lru_cache_init::memset_fast2->lru_cache_init::memset_fast2_@1#0] -- vbuxx=vbuc1 
    ldx #SIZEOF_UNSIGNED_INT*$80
    // [186] phi from lru_cache_init::memset_fast2_@1 to lru_cache_init::memset_fast2_@1 [phi:lru_cache_init::memset_fast2_@1->lru_cache_init::memset_fast2_@1]
    // [186] phi lru_cache_init::memset_fast2_num#2 = lru_cache_init::memset_fast2_num#1 [phi:lru_cache_init::memset_fast2_@1->lru_cache_init::memset_fast2_@1#0] -- register_copy 
    // lru_cache_init::memset_fast2_@1
  memset_fast2___b1:
    // *(destination+num) = c
    // [187] lru_cache_init::memset_fast2_destination#0[lru_cache_init::memset_fast2_num#2] = lru_cache_init::memset_fast2_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast2_c
    sta memset_fast2_destination,x
    // num--;
    // [188] lru_cache_init::memset_fast2_num#1 = -- lru_cache_init::memset_fast2_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [189] if(0!=lru_cache_init::memset_fast2_num#1) goto lru_cache_init::memset_fast2_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast2___b1
    // [190] phi from lru_cache_init::memset_fast2_@1 to lru_cache_init::memset_fast3 [phi:lru_cache_init::memset_fast2_@1->lru_cache_init::memset_fast3]
    // lru_cache_init::memset_fast3
    // [191] phi from lru_cache_init::memset_fast3 to lru_cache_init::memset_fast3_@1 [phi:lru_cache_init::memset_fast3->lru_cache_init::memset_fast3_@1]
    // [191] phi lru_cache_init::memset_fast3_num#2 = SIZEOF_CHAR*$80 [phi:lru_cache_init::memset_fast3->lru_cache_init::memset_fast3_@1#0] -- vbuxx=vbuc1 
    ldx #SIZEOF_CHAR*$80
    // [191] phi from lru_cache_init::memset_fast3_@1 to lru_cache_init::memset_fast3_@1 [phi:lru_cache_init::memset_fast3_@1->lru_cache_init::memset_fast3_@1]
    // [191] phi lru_cache_init::memset_fast3_num#2 = lru_cache_init::memset_fast3_num#1 [phi:lru_cache_init::memset_fast3_@1->lru_cache_init::memset_fast3_@1#0] -- register_copy 
    // lru_cache_init::memset_fast3_@1
  memset_fast3___b1:
    // *(destination+num) = c
    // [192] lru_cache_init::memset_fast3_destination#0[lru_cache_init::memset_fast3_num#2] = lru_cache_init::memset_fast3_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast3_c
    sta memset_fast3_destination,x
    // num--;
    // [193] lru_cache_init::memset_fast3_num#1 = -- lru_cache_init::memset_fast3_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [194] if(0!=lru_cache_init::memset_fast3_num#1) goto lru_cache_init::memset_fast3_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast3___b1
    // [195] phi from lru_cache_init::memset_fast3_@1 to lru_cache_init::memset_fast4 [phi:lru_cache_init::memset_fast3_@1->lru_cache_init::memset_fast4]
    // lru_cache_init::memset_fast4
    // [196] phi from lru_cache_init::memset_fast4 to lru_cache_init::memset_fast4_@1 [phi:lru_cache_init::memset_fast4->lru_cache_init::memset_fast4_@1]
    // [196] phi lru_cache_init::memset_fast4_num#2 = SIZEOF_CHAR*$80 [phi:lru_cache_init::memset_fast4->lru_cache_init::memset_fast4_@1#0] -- vbuxx=vbuc1 
    ldx #SIZEOF_CHAR*$80
    // [196] phi from lru_cache_init::memset_fast4_@1 to lru_cache_init::memset_fast4_@1 [phi:lru_cache_init::memset_fast4_@1->lru_cache_init::memset_fast4_@1]
    // [196] phi lru_cache_init::memset_fast4_num#2 = lru_cache_init::memset_fast4_num#1 [phi:lru_cache_init::memset_fast4_@1->lru_cache_init::memset_fast4_@1#0] -- register_copy 
    // lru_cache_init::memset_fast4_@1
  memset_fast4___b1:
    // *(destination+num) = c
    // [197] lru_cache_init::memset_fast4_destination#0[lru_cache_init::memset_fast4_num#2] = lru_cache_init::memset_fast4_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast4_c
    sta memset_fast4_destination,x
    // num--;
    // [198] lru_cache_init::memset_fast4_num#1 = -- lru_cache_init::memset_fast4_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [199] if(0!=lru_cache_init::memset_fast4_num#1) goto lru_cache_init::memset_fast4_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast4___b1
    // [200] phi from lru_cache_init::memset_fast4_@1 to lru_cache_init::memset_fast5 [phi:lru_cache_init::memset_fast4_@1->lru_cache_init::memset_fast5]
    // lru_cache_init::memset_fast5
    // [201] phi from lru_cache_init::memset_fast5 to lru_cache_init::memset_fast5_@1 [phi:lru_cache_init::memset_fast5->lru_cache_init::memset_fast5_@1]
    // [201] phi lru_cache_init::memset_fast5_num#2 = SIZEOF_CHAR*$80 [phi:lru_cache_init::memset_fast5->lru_cache_init::memset_fast5_@1#0] -- vbuxx=vbuc1 
    ldx #SIZEOF_CHAR*$80
    // [201] phi from lru_cache_init::memset_fast5_@1 to lru_cache_init::memset_fast5_@1 [phi:lru_cache_init::memset_fast5_@1->lru_cache_init::memset_fast5_@1]
    // [201] phi lru_cache_init::memset_fast5_num#2 = lru_cache_init::memset_fast5_num#1 [phi:lru_cache_init::memset_fast5_@1->lru_cache_init::memset_fast5_@1#0] -- register_copy 
    // lru_cache_init::memset_fast5_@1
  memset_fast5___b1:
    // *(destination+num) = c
    // [202] lru_cache_init::memset_fast5_destination#0[lru_cache_init::memset_fast5_num#2] = lru_cache_init::memset_fast5_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast5_c
    sta memset_fast5_destination,x
    // num--;
    // [203] lru_cache_init::memset_fast5_num#1 = -- lru_cache_init::memset_fast5_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [204] if(0!=lru_cache_init::memset_fast5_num#1) goto lru_cache_init::memset_fast5_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast5___b1
    // lru_cache_init::@1
    // lru_cache.first = 0xFF
    // [205] *((char *)&lru_cache+$381) = $ff -- _deref_pbuc1=vbuc2 
    lda #$ff
    sta lru_cache+$381
    // lru_cache.last = 0xFF
    // [206] *((char *)&lru_cache+$382) = $ff -- _deref_pbuc1=vbuc2 
    sta lru_cache+$382
    // lru_cache.count = 0
    // [207] *((char *)&lru_cache+$380) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta lru_cache+$380
    // lru_cache.size = LRU_CACHE_SIZE
    // [208] *((char *)&lru_cache+$383) = $80 -- _deref_pbuc1=vbuc2 
    lda #$80
    sta lru_cache+$383
    // lru_cache_init::@return
    // }
    // [209] return 
    rts
}
  // lru_cache_hash
// __mem unsigned char lru_cache_seed;
// __register(A) char lru_cache_hash(__zp(2) unsigned int key)
lru_cache_hash: {
    .label lru_cache_hash__0 = 2
    .label key = 2
    // key % LRU_CACHE_SIZE
    // [211] lru_cache_hash::$0 = lru_cache_hash::key#4 & $80-1 -- vwuz1=vwuz1_band_vbuc1 
    lda #$80-1
    and.z lru_cache_hash__0
    sta.z lru_cache_hash__0
    lda #0
    sta.z lru_cache_hash__0+1
    // return (lru_cache_index_t)(key % LRU_CACHE_SIZE);
    // [212] lru_cache_hash::return#0 = (char)lru_cache_hash::$0 -- vbuaa=_byte_vwuz1 
    lda.z lru_cache_hash__0
    // lru_cache_hash::@return
    // }
    // [213] return 
    rts
}
  // lru_cache_find_head
// __register(A) char lru_cache_find_head(__zp(6) char index)
lru_cache_find_head: {
    .label index = 6
    .label key_link = 2
    // lru_cache_key_t key_link = lru_cache.key[index]
    // [214] lru_cache_find_head::$2 = lru_cache_find_head::index#0 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z index
    asl
    // [215] lru_cache_find_head::key_link#0 = ((unsigned int *)&lru_cache)[lru_cache_find_head::$2] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda lru_cache,y
    sta.z key_link
    lda lru_cache+1,y
    sta.z key_link+1
    // lru_cache_index_t head_link = lru_cache_hash(key_link)
    // [216] lru_cache_hash::key#3 = lru_cache_find_head::key_link#0
    // [217] call lru_cache_hash
    // [210] phi from lru_cache_find_head to lru_cache_hash [phi:lru_cache_find_head->lru_cache_hash]
    // [210] phi lru_cache_hash::key#4 = lru_cache_hash::key#3 [phi:lru_cache_find_head->lru_cache_hash#0] -- register_copy 
    jsr lru_cache_hash
    // lru_cache_index_t head_link = lru_cache_hash(key_link)
    // [218] lru_cache_hash::return#10 = lru_cache_hash::return#0
    // lru_cache_find_head::@2
    // [219] lru_cache_find_head::head_link#0 = lru_cache_hash::return#10
    // if (head_link != index)
    // [220] if(lru_cache_find_head::head_link#0!=lru_cache_find_head::index#0) goto lru_cache_find_head::@1 -- vbuaa_neq_vbuz1_then_la1 
    cmp.z index
    bne __b1
    // [222] phi from lru_cache_find_head::@2 to lru_cache_find_head::@return [phi:lru_cache_find_head::@2->lru_cache_find_head::@return]
    // [222] phi lru_cache_find_head::return#3 = $ff [phi:lru_cache_find_head::@2->lru_cache_find_head::@return#0] -- vbuaa=vbuc1 
    lda #$ff
    rts
    // [221] phi from lru_cache_find_head::@2 to lru_cache_find_head::@1 [phi:lru_cache_find_head::@2->lru_cache_find_head::@1]
    // lru_cache_find_head::@1
  __b1:
    // [222] phi from lru_cache_find_head::@1 to lru_cache_find_head::@return [phi:lru_cache_find_head::@1->lru_cache_find_head::@return]
    // [222] phi lru_cache_find_head::return#3 = lru_cache_find_head::head_link#0 [phi:lru_cache_find_head::@1->lru_cache_find_head::@return#0] -- register_copy 
    // lru_cache_find_head::@return
    // }
    // [223] return 
    rts
}
  // lru_cache_find_duplicate
// __register(X) char lru_cache_find_duplicate(__register(X) char index, __zp(5) char link)
lru_cache_find_duplicate: {
    .label link = 5
    // [225] phi from lru_cache_find_duplicate lru_cache_find_duplicate::@2 to lru_cache_find_duplicate::@1 [phi:lru_cache_find_duplicate/lru_cache_find_duplicate::@2->lru_cache_find_duplicate::@1]
  __b1:
    // [225] phi lru_cache_find_duplicate::index#3 = lru_cache_find_duplicate::index#6 [phi:lru_cache_find_duplicate/lru_cache_find_duplicate::@2->lru_cache_find_duplicate::@1#0] -- register_copy 
  // First find the last duplicate node.
    // lru_cache_find_duplicate::@1
    // while (lru_cache.link[index] != link && lru_cache.link[index] != LRU_CACHE_INDEX_NULL)
    // [226] if(((char *)&lru_cache+$300)[lru_cache_find_duplicate::index#3]==lru_cache_find_duplicate::link#3) goto lru_cache_find_duplicate::@return -- pbuc1_derefidx_vbuxx_eq_vbuz1_then_la1 
    lda lru_cache+$300,x
    cmp.z link
    beq __breturn
    // lru_cache_find_duplicate::@3
    // [227] if(((char *)&lru_cache+$300)[lru_cache_find_duplicate::index#3]!=$ff) goto lru_cache_find_duplicate::@2 -- pbuc1_derefidx_vbuxx_neq_vbuc2_then_la1 
    lda lru_cache+$300,x
    cmp #$ff
    bne __b2
    // lru_cache_find_duplicate::@return
  __breturn:
    // }
    // [228] return 
    rts
    // lru_cache_find_duplicate::@2
  __b2:
    // index = lru_cache.link[index]
    // [229] lru_cache_find_duplicate::index#2 = ((char *)&lru_cache+$300)[lru_cache_find_duplicate::index#3] -- vbuxx=pbuc1_derefidx_vbuxx 
    lda lru_cache+$300,x
    tax
    jmp __b1
}
  // lru_cache_find_empty
// __register(X) char lru_cache_find_empty(__register(X) char index)
lru_cache_find_empty: {
    // [231] phi from lru_cache_find_empty lru_cache_find_empty::@2 to lru_cache_find_empty::@1 [phi:lru_cache_find_empty/lru_cache_find_empty::@2->lru_cache_find_empty::@1]
    // [231] phi lru_cache_find_empty::index#4 = lru_cache_find_empty::index#7 [phi:lru_cache_find_empty/lru_cache_find_empty::@2->lru_cache_find_empty::@1#0] -- register_copy 
    // lru_cache_find_empty::@1
  __b1:
    // lru_cache.key[index] != LRU_CACHE_NOTHING
    // [232] lru_cache_find_empty::$1 = lru_cache_find_empty::index#4 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // while (lru_cache.key[index] != LRU_CACHE_NOTHING)
    // [233] if(((unsigned int *)&lru_cache)[lru_cache_find_empty::$1]!=$ffff) goto lru_cache_find_empty::@2 -- pwuc1_derefidx_vbuaa_neq_vwuc2_then_la1 
    tay
    lda lru_cache+1,y
    cmp #>$ffff
    bne __b2
    lda lru_cache,y
    cmp #<$ffff
    bne __b2
    // lru_cache_find_empty::@return
    // }
    // [234] return 
    rts
    // lru_cache_find_empty::@2
  __b2:
    // index++;
    // [235] lru_cache_find_empty::index#2 = ++ lru_cache_find_empty::index#4 -- vbuaa=_inc_vbuxx 
    txa
    inc
    // index %= LRU_CACHE_SIZE
    // [236] lru_cache_find_empty::index#3 = lru_cache_find_empty::index#2 & $80-1 -- vbuxx=vbuaa_band_vbuc1 
    and #$80-1
    tax
    jmp __b1
}
  // File Data
  lru_cache: .fill SIZEOF_STRUCT___0, 0
}
