.namespace bramheap {
  // Global Constants & labels
  .const WHITE = 1
  .const BLUE = 6
  ///< Load a logical file.
  .const CBM_PLOT = $fff0
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_MASK = $c0
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const isr_vsync = $314
  .const SIZEOF_STRUCT___0 = $8f
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .const SIZEOF_STRUCT___1 = $800
  .const SIZEOF_STRUCT___2 = $67
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
  /// $9F24	DATA1	VRAM Data port 1
  .label VERA_DATA1 = $9f24
  /// $9F25	CTRL Control
  /// Bit 7: Reset
  /// Bit 1: DCSEL
  /// Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  /// $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
  .label VERA_DC_HSCALE = $9f2a
  /// $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
  .label VERA_DC_VSCALE = $9f2b
  /// $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  /// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
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
    // __mem unsigned char bramheap_dx = 0
    // [3] bramheap_dx = 0 -- vbum1=vbuc1 
    lda #0
    sta bramheap_dx
    // __mem unsigned char bramheap_dy = 0
    // [4] bramheap_dy = 0 -- vbum1=vbuc1 
    sta bramheap_dy
    // [5] phi from __start::__init1 to __start::@2 [phi:__start::__init1->__start::@2]
    // __start::@2
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [6] call conio_x16_init
    // [221] phi from __start::@2 to conio_x16_init [phi:__start::@2->conio_x16_init] -- call_phi_near 
    jsr conio_x16_init
    // [7] phi from __start::@2 to __start::@1 [phi:__start::@2->__start::@1]
    // __start::@1
    // [8] call main
    // [273] phi from __start::@1 to main [phi:__start::@1->main] -- call_phi_near 
    jsr main
    // __start::@return
    // [9] return 
    rts
}
.segment CodeBramHeap
  // bram_heap_get_size
// unsigned long bram_heap_get_size(char s, __register(X) char index)
bram_heap_get_size: {
    .const OFFSET_STACK_INDEX = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [10] bram_heap_get_size::index#0 = stackidx(char,bram_heap_get_size::OFFSET_STACK_INDEX) -- vbuxx=_stackidxbyte_vbuc1 
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
    // [12] bram_heap_get_size::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_get_size::bank_set_bram1
    // BRAM = bank
    // [13] BRAM = bram_heap_get_size::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_get_size::@2
    // bram_heap_get_size_packed(s, index)
    // [14] bram_heap_get_size_packed::index#1 = bram_heap_get_size::index#0
    // [15] call bram_heap_get_size_packed
    // [275] phi from bram_heap_get_size::@2 to bram_heap_get_size_packed [phi:bram_heap_get_size::@2->bram_heap_get_size_packed]
    // [275] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#1 [phi:bram_heap_get_size::@2->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_get_size_packed(s, index)
    // [16] bram_heap_get_size_packed::return#1 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return_1
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return_1+1
    // bram_heap_get_size::@3
    // [17] bram_heap_get_size::$2 = bram_heap_get_size_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_1
    sta bram_heap_get_size__2
    lda bram_heap_get_size_packed.return_1+1
    sta bram_heap_get_size__2+1
    // bram_heap_size_t size = bram_heap_get_size_packed(s, index) << 3
    // [18] bram_heap_get_size::size#0 = bram_heap_get_size::$2 << 3 -- vdum1=vwum2_rol_3 
    lda bram_heap_get_size__2
    asl
    sta size
    lda bram_heap_get_size__2+1
    rol
    sta size+1
    lda #0
    sta size+3
    rol
    sta size+2
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
    // [20] stackidx(unsigned long,bram_heap_get_size::OFFSET_STACK_RETURN_0) = bram_heap_get_size::size#0 -- _stackidxdword_vbuc1=vdum1 
    tsx
    lda size
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda size+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    lda size+2
    sta STACK_BASE+OFFSET_STACK_RETURN_0+2,x
    lda size+3
    sta STACK_BASE+OFFSET_STACK_RETURN_0+3,x
    // [21] return 
    rts
  .segment DataBramHeap
    bram_heap_get_size__2: .word 0
    size: .dword 0
}
.segment CodeBramHeap
  // bram_heap_data_get_bank
// char bram_heap_data_get_bank(char s, __register(X) char index)
bram_heap_data_get_bank: {
    .const OFFSET_STACK_INDEX = 0
    .const OFFSET_STACK_RETURN_1 = 1
    // [22] bram_heap_data_get_bank::index#0 = stackidx(char,bram_heap_data_get_bank::OFFSET_STACK_INDEX) -- vbuxx=_stackidxbyte_vbuc1 
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
    // [24] bram_heap_data_get_bank::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_data_get_bank::bank_set_bram1
    // BRAM = bank
    // [25] BRAM = bram_heap_data_get_bank::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_data_get_bank::@2
    // bram_bank_t bram_bank = bram_heap_index.data1[index] >> 2
    // [26] bram_heap_data_get_bank::bram_bank#0 = ((char *)&bram_heap_index+$100)[bram_heap_data_get_bank::index#0] >> 2 -- vbuxx=pbuc1_derefidx_vbuxx_ror_2 
    lda bram_heap_index+$100,x
    lsr
    lsr
    tax
    // bram_heap_data_get_bank::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // bram_heap_data_get_bank::@return
    // }
    // [28] stackidx(char,bram_heap_data_get_bank::OFFSET_STACK_RETURN_1) = bram_heap_data_get_bank::bram_bank#0 -- _stackidxbyte_vbuc1=vbuxx 
    txa
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    // [29] return 
    rts
}
  // bram_heap_data_get_offset
// char * bram_heap_data_get_offset(char s, __register(X) char index)
bram_heap_data_get_offset: {
    .const OFFSET_STACK_INDEX = 0
    .const OFFSET_STACK_RETURN_0 = 0
    // [30] bram_heap_data_get_offset::index#0 = stackidx(char,bram_heap_data_get_offset::OFFSET_STACK_INDEX) -- vbuxx=_stackidxbyte_vbuc1 
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
    // [32] bram_heap_data_get_offset::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_data_get_offset::bank_set_bram1
    // BRAM = bank
    // [33] BRAM = bram_heap_data_get_offset::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_data_get_offset::@2
    // bram_heap_get_data_packed(s, index)
    // [34] bram_heap_get_data_packed::index#1 = bram_heap_data_get_offset::index#0
    // [35] call bram_heap_get_data_packed
    // [279] phi from bram_heap_data_get_offset::@2 to bram_heap_get_data_packed [phi:bram_heap_data_get_offset::@2->bram_heap_get_data_packed]
    // [279] phi bram_heap_get_data_packed::index#9 = bram_heap_get_data_packed::index#1 [phi:bram_heap_data_get_offset::@2->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_get_data_packed(s, index)
    // [36] bram_heap_get_data_packed::return#13 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_3
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_3+1
    // bram_heap_data_get_offset::@3
    // (unsigned int)bram_heap_get_data_packed(s, index) & 0x3FF << 3
    // [37] bram_heap_data_get_offset::$6 = bram_heap_get_data_packed::return#13 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_3
    sta bram_heap_data_get_offset__6
    lda bram_heap_get_data_packed.return_3+1
    sta bram_heap_data_get_offset__6+1
    // [38] bram_heap_data_get_offset::$3 = bram_heap_data_get_offset::$6 & $3ff<<3 -- vwum1=vwum1_band_vwuc1 
    lda bram_heap_data_get_offset__3
    and #<$3ff<<3
    sta bram_heap_data_get_offset__3
    lda bram_heap_data_get_offset__3+1
    and #>$3ff<<3
    sta bram_heap_data_get_offset__3+1
    // ((unsigned int)bram_heap_get_data_packed(s, index) & 0x3FF << 3) | 0xA000
    // [39] bram_heap_data_get_offset::bram_ptr#0 = bram_heap_data_get_offset::$3 | $a000 -- vwum1=vwum1_bor_vwuc1 
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
    // [41] stackidx(char *,bram_heap_data_get_offset::OFFSET_STACK_RETURN_0) = (char *)bram_heap_data_get_offset::bram_ptr#0 -- _stackidxptr_vbuc1=pbum1 
    tsx
    lda bram_ptr
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    lda bram_ptr+1
    sta STACK_BASE+OFFSET_STACK_RETURN_0+1,x
    // [42] return 
    rts
  .segment DataBramHeap
    .label bram_heap_data_get_offset__3 = bram_ptr
    .label bram_heap_data_get_offset__6 = bram_ptr
    bram_ptr: .word 0
}
.segment CodeBramHeap
  // bram_heap_dump
/**
 * @brief Print the heap memory manager statistics and dump the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
// void bram_heap_dump(__mem() char s, __mem() char x, __register(A) char y)
bram_heap_dump: {
    .const OFFSET_STACK_S = 2
    .const OFFSET_STACK_X = 1
    .const OFFSET_STACK_Y = 0
    // [43] bram_heap_dump::s#0 = stackidx(char,bram_heap_dump::OFFSET_STACK_S) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_S,x
    sta s
    // [44] bram_heap_dump::x#0 = stackidx(char,bram_heap_dump::OFFSET_STACK_X) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_X,x
    sta x
    // [45] bram_heap_dump::y#0 = stackidx(char,bram_heap_dump::OFFSET_STACK_Y) -- vbuaa=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_Y,x
    // bram_heap_dump_xy(x, y)
    // [46] bram_heap_dump_xy::x#0 = bram_heap_dump::x#0 -- vbuxx=vbum1 
    ldx x
    // [47] bram_heap_dump_xy::y#0 = bram_heap_dump::y#0
    // [48] call bram_heap_dump_xy -- call_phi_near 
    jsr bram_heap_dump_xy
    // bram_heap_dump::@1
    // bram_heap_dump_stats(s)
    // [49] bram_heap_dump_stats::s#0 = bram_heap_dump::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_dump_stats.s
    // [50] call bram_heap_dump_stats -- call_phi_near 
    jsr bram_heap_dump_stats
    // bram_heap_dump::@2
    // bram_heap_dump_index(s)
    // [51] bram_heap_dump_index::s#0 = bram_heap_dump::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_dump_index.s
    // [52] call bram_heap_dump_index
    // [347] phi from bram_heap_dump::@2 to bram_heap_dump_index [phi:bram_heap_dump::@2->bram_heap_dump_index] -- call_phi_near 
    jsr bram_heap_dump_index
    // bram_heap_dump::@return
    // }
    // [53] return 
    rts
  .segment Data
    s: .byte 0
    x: .byte 0
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
    // [54] bram_heap_free::s#0 = stackidx(char,bram_heap_free::OFFSET_STACK_S) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_S,x
    sta s
    // [55] bram_heap_free::free_index#0 = stackidx(char,bram_heap_free::OFFSET_STACK_FREE_INDEX) -- vbum1=_stackidxbyte_vbuc1 
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
    // [57] bram_heap_free::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_free::bank_set_bram1
    // BRAM = bank
    // [58] BRAM = bram_heap_free::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_free::@6
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [59] bram_heap_get_size_packed::index#0 = bram_heap_free::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [60] call bram_heap_get_size_packed
    // [275] phi from bram_heap_free::@6 to bram_heap_get_size_packed [phi:bram_heap_free::@6->bram_heap_get_size_packed]
    // [275] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#0 [phi:bram_heap_free::@6->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [61] bram_heap_get_size_packed::return#0 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return+1
    // bram_heap_free::@7
    // [62] bram_heap_free::free_size#0 = bram_heap_get_size_packed::return#0 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return
    sta free_size
    lda bram_heap_get_size_packed.return+1
    sta free_size+1
    // bram_heap_size_unpack(free_size)
    // [63] bram_heap_size_unpack::size#0 = bram_heap_free::free_size#0 -- vwum1=vwum2 
    lda free_size
    sta bram_heap_size_unpack.size
    lda free_size+1
    sta bram_heap_size_unpack.size+1
    // [64] call bram_heap_size_unpack
    // [376] phi from bram_heap_free::@7 to bram_heap_size_unpack [phi:bram_heap_free::@7->bram_heap_size_unpack]
    // [376] phi bram_heap_size_unpack::size#7 = bram_heap_size_unpack::size#0 [phi:bram_heap_free::@7->bram_heap_size_unpack#0] -- call_phi_near 
    jsr bram_heap_size_unpack
    // bram_heap_size_unpack(free_size)
    // [65] bram_heap_size_unpack::return#0 = bram_heap_size_unpack::return#12 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_3
    sta bram_heap_size_unpack.return
    lda bram_heap_size_unpack.return_3+1
    sta bram_heap_size_unpack.return+1
    lda bram_heap_size_unpack.return_3+2
    sta bram_heap_size_unpack.return+2
    lda bram_heap_size_unpack.return_3+3
    sta bram_heap_size_unpack.return+3
    // bram_heap_free::@8
    // printf("\n > Free index %03x size %05x.", free_index, bram_heap_size_unpack(free_size))
    // [66] printf_ulong::uvalue#1 = bram_heap_size_unpack::return#0 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return
    sta printf_ulong.uvalue
    lda bram_heap_size_unpack.return+1
    sta printf_ulong.uvalue+1
    lda bram_heap_size_unpack.return+2
    sta printf_ulong.uvalue+2
    lda bram_heap_size_unpack.return+3
    sta printf_ulong.uvalue+3
    // [67] call printf_str
    // [380] phi from bram_heap_free::@8 to printf_str [phi:bram_heap_free::@8->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_free::s1 [phi:bram_heap_free::@8->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_free::@9
    // printf("\n > Free index %03x size %05x.", free_index, bram_heap_size_unpack(free_size))
    // [68] printf_uchar::uvalue#2 = bram_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta printf_uchar.uvalue
    // [69] call printf_uchar
    // [389] phi from bram_heap_free::@9 to printf_uchar [phi:bram_heap_free::@9->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_free::@9->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#2 [phi:bram_heap_free::@9->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [70] phi from bram_heap_free::@9 to bram_heap_free::@10 [phi:bram_heap_free::@9->bram_heap_free::@10]
    // bram_heap_free::@10
    // printf("\n > Free index %03x size %05x.", free_index, bram_heap_size_unpack(free_size))
    // [71] call printf_str
    // [380] phi from bram_heap_free::@10 to printf_str [phi:bram_heap_free::@10->printf_str]
    // [380] phi printf_str::s#69 = s2 [phi:bram_heap_free::@10->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // [72] phi from bram_heap_free::@10 to bram_heap_free::@11 [phi:bram_heap_free::@10->bram_heap_free::@11]
    // bram_heap_free::@11
    // printf("\n > Free index %03x size %05x.", free_index, bram_heap_size_unpack(free_size))
    // [73] call printf_ulong
    // [397] phi from bram_heap_free::@11 to printf_ulong [phi:bram_heap_free::@11->printf_ulong]
    // [397] phi printf_ulong::uvalue#12 = printf_ulong::uvalue#1 [phi:bram_heap_free::@11->printf_ulong#0] -- call_phi_near 
    jsr printf_ulong
    // [74] phi from bram_heap_free::@11 to bram_heap_free::@12 [phi:bram_heap_free::@11->bram_heap_free::@12]
    // bram_heap_free::@12
    // printf("\n > Free index %03x size %05x.", free_index, bram_heap_size_unpack(free_size))
    // [75] call printf_str
    // [380] phi from bram_heap_free::@12 to printf_str [phi:bram_heap_free::@12->printf_str]
    // [380] phi printf_str::s#69 = s3 [phi:bram_heap_free::@12->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_free::@13
    // bram_heap_data_packed_t free_offset = bram_heap_get_data_packed(s, free_index)
    // [76] bram_heap_get_data_packed::index#0 = bram_heap_free::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [77] call bram_heap_get_data_packed
    // [279] phi from bram_heap_free::@13 to bram_heap_get_data_packed [phi:bram_heap_free::@13->bram_heap_get_data_packed]
    // [279] phi bram_heap_get_data_packed::index#9 = bram_heap_get_data_packed::index#0 [phi:bram_heap_free::@13->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t free_offset = bram_heap_get_data_packed(s, free_index)
    // [78] bram_heap_get_data_packed::return#0 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return+1
    // bram_heap_free::@14
    // [79] bram_heap_free::free_offset#0 = bram_heap_get_data_packed::return#0 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return
    sta free_offset
    lda bram_heap_get_data_packed.return+1
    sta free_offset+1
    // bram_heap_heap_remove(s, free_index)
    // [80] bram_heap_heap_remove::s#0 = bram_heap_free::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_heap_remove.s
    // [81] bram_heap_heap_remove::heap_index#0 = bram_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_heap_remove.heap_index
    // [82] call bram_heap_heap_remove -- call_phi_near 
    // TODO: only remove allocated indexes!
    jsr bram_heap_heap_remove
    // bram_heap_free::@15
    // bram_heap_free_insert(s, free_index, free_offset, free_size)
    // [83] bram_heap_free_insert::s#0 = bram_heap_free::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_free_insert.s
    // [84] bram_heap_free_insert::free_index#0 = bram_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_free_insert.free_index
    // [85] bram_heap_free_insert::data#0 = bram_heap_free::free_offset#0
    // [86] bram_heap_free_insert::size#0 = bram_heap_free::free_size#0 -- vwum1=vwum2 
    lda free_size
    sta bram_heap_free_insert.size
    lda free_size+1
    sta bram_heap_free_insert.size+1
    // [87] call bram_heap_free_insert -- call_phi_near 
    jsr bram_heap_free_insert
    // bram_heap_free::@16
    // bram_heap_index_t free_left_index = bram_heap_can_coalesce_left(s, free_index)
    // [88] bram_heap_can_coalesce_left::heap_index#0 = bram_heap_free::free_index#0 -- vbuyy=vbum1 
    ldy free_index
    // [89] call bram_heap_can_coalesce_left -- call_phi_near 
    jsr bram_heap_can_coalesce_left
    // [90] bram_heap_can_coalesce_left::return#0 = bram_heap_can_coalesce_left::return#3 -- vbuaa=vbum1 
    lda bram_heap_can_coalesce_left.return
    // bram_heap_free::@17
    // [91] bram_heap_free::free_left_index#0 = bram_heap_can_coalesce_left::return#0 -- vbuxx=vbuaa 
    tax
    // if(free_left_index != BRAM_HEAP_NULL)
    // [92] if(bram_heap_free::free_left_index#0==$ff) goto bram_heap_free::@1 -- vbuxx_eq_vbuc1_then_la1 
    cpx #$ff
    beq __b1
    // bram_heap_free::@3
    // bram_heap_coalesce(s, free_left_index, free_index)
    // [93] bram_heap_coalesce::s#0 = bram_heap_free::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_coalesce.s
    // [94] bram_heap_coalesce::left_index#0 = bram_heap_free::free_left_index#0 -- vbum1=vbuxx 
    stx bram_heap_coalesce.left_index
    // [95] bram_heap_coalesce::right_index#0 = bram_heap_free::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_coalesce.right_index
    // [96] call bram_heap_coalesce
    // [472] phi from bram_heap_free::@3 to bram_heap_coalesce [phi:bram_heap_free::@3->bram_heap_coalesce]
    // [472] phi bram_heap_coalesce::left_index#10 = bram_heap_coalesce::left_index#0 [phi:bram_heap_free::@3->bram_heap_coalesce#0] -- register_copy 
    // [472] phi bram_heap_coalesce::right_index#10 = bram_heap_coalesce::right_index#0 [phi:bram_heap_free::@3->bram_heap_coalesce#1] -- register_copy 
    // [472] phi bram_heap_coalesce::s#10 = bram_heap_coalesce::s#0 [phi:bram_heap_free::@3->bram_heap_coalesce#2] -- call_phi_near 
    jsr bram_heap_coalesce
    // bram_heap_coalesce(s, free_left_index, free_index)
    // [97] bram_heap_coalesce::return#0 = bram_heap_coalesce::right_index#10 -- vbuaa=vbum1 
    lda bram_heap_coalesce.right_index
    // bram_heap_free::@19
    // free_index = bram_heap_coalesce(s, free_left_index, free_index)
    // [98] bram_heap_free::free_index#1 = bram_heap_coalesce::return#0 -- vbum1=vbuaa 
    sta free_index
    // [99] phi from bram_heap_free::@17 bram_heap_free::@19 to bram_heap_free::@1 [phi:bram_heap_free::@17/bram_heap_free::@19->bram_heap_free::@1]
    // [99] phi bram_heap_free::free_index#11 = bram_heap_free::free_index#0 [phi:bram_heap_free::@17/bram_heap_free::@19->bram_heap_free::@1#0] -- register_copy 
    // bram_heap_free::@1
  __b1:
    // bram_heap_index_t free_right_index = heap_can_coalesce_right(s, free_index)
    // [100] heap_can_coalesce_right::heap_index#0 = bram_heap_free::free_index#11 -- vbum1=vbum2 
    lda free_index
    sta heap_can_coalesce_right.heap_index
    // [101] call heap_can_coalesce_right -- call_phi_near 
    jsr heap_can_coalesce_right
    // [102] heap_can_coalesce_right::return#0 = heap_can_coalesce_right::return#3 -- vbuaa=vbum1 
    lda heap_can_coalesce_right.return
    // bram_heap_free::@18
    // [103] bram_heap_free::free_right_index#0 = heap_can_coalesce_right::return#0 -- vbuxx=vbuaa 
    tax
    // if(free_right_index != BRAM_HEAP_NULL)
    // [104] if(bram_heap_free::free_right_index#0==$ff) goto bram_heap_free::@2 -- vbuxx_eq_vbuc1_then_la1 
    cpx #$ff
    beq __b2
    // bram_heap_free::@4
    // bram_heap_coalesce(s, free_index, free_right_index)
    // [105] bram_heap_coalesce::s#1 = bram_heap_free::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_coalesce.s
    // [106] bram_heap_coalesce::left_index#1 = bram_heap_free::free_index#11 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_coalesce.left_index
    // [107] bram_heap_coalesce::right_index#1 = bram_heap_free::free_right_index#0 -- vbum1=vbuxx 
    stx bram_heap_coalesce.right_index
    // [108] call bram_heap_coalesce
    // [472] phi from bram_heap_free::@4 to bram_heap_coalesce [phi:bram_heap_free::@4->bram_heap_coalesce]
    // [472] phi bram_heap_coalesce::left_index#10 = bram_heap_coalesce::left_index#1 [phi:bram_heap_free::@4->bram_heap_coalesce#0] -- register_copy 
    // [472] phi bram_heap_coalesce::right_index#10 = bram_heap_coalesce::right_index#1 [phi:bram_heap_free::@4->bram_heap_coalesce#1] -- register_copy 
    // [472] phi bram_heap_coalesce::s#10 = bram_heap_coalesce::s#1 [phi:bram_heap_free::@4->bram_heap_coalesce#2] -- call_phi_near 
    jsr bram_heap_coalesce
    // [109] phi from bram_heap_free::@18 bram_heap_free::@4 to bram_heap_free::@2 [phi:bram_heap_free::@18/bram_heap_free::@4->bram_heap_free::@2]
    // bram_heap_free::@2
  __b2:
    // printf("\n")
    // [110] call printf_str
    // [380] phi from bram_heap_free::@2 to printf_str [phi:bram_heap_free::@2->printf_str]
    // [380] phi printf_str::s#69 = s4 [phi:bram_heap_free::@2->printf_str#0] -- call_phi_near 
    lda #<s4
    sta printf_str.s
    lda #>s4
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_free::@20
    // bram_heap_segment.freeSize[s] += free_size
    // [111] bram_heap_free::$19 = bram_heap_free::s#0 << 1 -- vbuxx=vbum1_rol_1 
    lda s
    asl
    tax
    // [112] ((unsigned int *)&bram_heap_segment+$5e)[bram_heap_free::$19] = ((unsigned int *)&bram_heap_segment+$5e)[bram_heap_free::$19] + bram_heap_free::free_size#0 -- pwuc1_derefidx_vbuxx=pwuc1_derefidx_vbuxx_plus_vwum1 
    lda bram_heap_segment+$5e,x
    clc
    adc free_size
    sta bram_heap_segment+$5e,x
    lda bram_heap_segment+$5e+1,x
    adc free_size+1
    sta bram_heap_segment+$5e+1,x
    // bram_heap_segment.heapSize[s] -= free_size
    // [113] ((unsigned int *)&bram_heap_segment+$56)[bram_heap_free::$19] = ((unsigned int *)&bram_heap_segment+$56)[bram_heap_free::$19] - bram_heap_free::free_size#0 -- pwuc1_derefidx_vbuxx=pwuc1_derefidx_vbuxx_minus_vwum1 
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
    // [115] return 
    rts
  .segment DataBramHeap
  .encoding "petscii_mixed"
    s1: .text @"\n > Free index "
    .byte 0
  .segment Data
    s: .byte 0
    free_index: .byte 0
  .segment DataBramHeap
    free_size: .word 0
    .label free_offset = printf_string.str
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
// char bram_heap_alloc(__mem() char s, __mem() unsigned long size)
bram_heap_alloc: {
    .const OFFSET_STACK_S = 4
    .const OFFSET_STACK_SIZE = 0
    .const OFFSET_STACK_RETURN_4 = 4
    // [116] bram_heap_alloc::s#0 = stackidx(char,bram_heap_alloc::OFFSET_STACK_S) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_S,x
    sta s
    // [117] bram_heap_alloc::size#0 = stackidx(unsigned long,bram_heap_alloc::OFFSET_STACK_SIZE) -- vdum1=_stackidxdword_vbuc1 
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
    // bram_heap_alloc::@3
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [119] bram_heap_alloc::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_alloc::bank_set_bram1
    // BRAM = bank
    // [120] BRAM = bram_heap_alloc::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_alloc::@4
    // bram_heap_size_packed_t packed_size = bram_heap_alloc_size_get(size)
    // [121] bram_heap_alloc_size_get::size#0 = bram_heap_alloc::size#0 -- vdum1=vdum2 
    lda size
    sta bram_heap_alloc_size_get.size
    lda size+1
    sta bram_heap_alloc_size_get.size+1
    lda size+2
    sta bram_heap_alloc_size_get.size+2
    lda size+3
    sta bram_heap_alloc_size_get.size+3
    // [122] call bram_heap_alloc_size_get -- call_phi_near 
    // Adjust given size to 8 bytes boundary (shift right with 3 bits).
    jsr bram_heap_alloc_size_get
    // [123] bram_heap_alloc_size_get::return#0 = bram_heap_alloc_size_get::return#1 -- vwum1=vwum2 
    lda bram_heap_alloc_size_get.return_1
    sta bram_heap_alloc_size_get.return
    lda bram_heap_alloc_size_get.return_1+1
    sta bram_heap_alloc_size_get.return+1
    // bram_heap_alloc::@5
    // [124] bram_heap_alloc::packed_size#0 = bram_heap_alloc_size_get::return#0 -- vwum1=vwum2 
    lda bram_heap_alloc_size_get.return
    sta packed_size
    lda bram_heap_alloc_size_get.return+1
    sta packed_size+1
    // printf("\n > Allocate segment %02x, size %05x", s, size)
    // [125] call printf_str
    // [380] phi from bram_heap_alloc::@5 to printf_str [phi:bram_heap_alloc::@5->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_alloc::s1 [phi:bram_heap_alloc::@5->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_alloc::@6
    // printf("\n > Allocate segment %02x, size %05x", s, size)
    // [126] printf_uchar::uvalue#0 = bram_heap_alloc::s#0 -- vbum1=vbum2 
    lda s
    sta printf_uchar.uvalue
    // [127] call printf_uchar
    // [389] phi from bram_heap_alloc::@6 to printf_uchar [phi:bram_heap_alloc::@6->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 2 [phi:bram_heap_alloc::@6->printf_uchar#0] -- vbum1=vbuc1 
    lda #2
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#0 [phi:bram_heap_alloc::@6->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [128] phi from bram_heap_alloc::@6 to bram_heap_alloc::@7 [phi:bram_heap_alloc::@6->bram_heap_alloc::@7]
    // bram_heap_alloc::@7
    // printf("\n > Allocate segment %02x, size %05x", s, size)
    // [129] call printf_str
    // [380] phi from bram_heap_alloc::@7 to printf_str [phi:bram_heap_alloc::@7->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_alloc::s2 [phi:bram_heap_alloc::@7->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_alloc::@8
    // printf("\n > Allocate segment %02x, size %05x", s, size)
    // [130] printf_ulong::uvalue#0 = bram_heap_alloc::size#0 -- vdum1=vdum2 
    lda size
    sta printf_ulong.uvalue
    lda size+1
    sta printf_ulong.uvalue+1
    lda size+2
    sta printf_ulong.uvalue+2
    lda size+3
    sta printf_ulong.uvalue+3
    // [131] call printf_ulong
    // [397] phi from bram_heap_alloc::@8 to printf_ulong [phi:bram_heap_alloc::@8->printf_ulong]
    // [397] phi printf_ulong::uvalue#12 = printf_ulong::uvalue#0 [phi:bram_heap_alloc::@8->printf_ulong#0] -- call_phi_near 
    jsr printf_ulong
    // bram_heap_alloc::@9
    // bram_heap_index_t free_index = bram_heap_find_best_fit(s, packed_size)
    // [132] bram_heap_find_best_fit::s#0 = bram_heap_alloc::s#0 -- vbuxx=vbum1 
    ldx s
    // [133] bram_heap_find_best_fit::requested_size#0 = bram_heap_alloc::packed_size#0 -- vwum1=vwum2 
    lda packed_size
    sta bram_heap_find_best_fit.requested_size
    lda packed_size+1
    sta bram_heap_find_best_fit.requested_size+1
    // [134] call bram_heap_find_best_fit -- call_phi_near 
    jsr bram_heap_find_best_fit
    // [135] bram_heap_find_best_fit::return#0 = bram_heap_find_best_fit::return#2 -- vbuaa=vbum1 
    lda bram_heap_find_best_fit.return
    // bram_heap_alloc::@10
    // [136] bram_heap_alloc::free_index#0 = bram_heap_find_best_fit::return#0 -- vbuxx=vbuaa 
    tax
    // if(free_index != BRAM_HEAP_NULL)
    // [137] if(bram_heap_alloc::free_index#0!=$ff) goto bram_heap_alloc::@1 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$ff
    bne __b1
    // [138] phi from bram_heap_alloc::@10 to bram_heap_alloc::@2 [phi:bram_heap_alloc::@10->bram_heap_alloc::@2]
    // [138] phi bram_heap_alloc::heap_index#2 = $ff [phi:bram_heap_alloc::@10->bram_heap_alloc::@2#0] -- vbum1=vbuc1 
    lda #$ff
    sta heap_index
    // bram_heap_alloc::@2
  __b2:
    // printf("\n > returning heap index %03x.\n", heap_index)
    // [139] call printf_str
    // [380] phi from bram_heap_alloc::@2 to printf_str [phi:bram_heap_alloc::@2->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_alloc::s3 [phi:bram_heap_alloc::@2->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_alloc::@12
    // printf("\n > returning heap index %03x.\n", heap_index)
    // [140] printf_uchar::uvalue#1 = bram_heap_alloc::heap_index#2 -- vbum1=vbum2 
    lda heap_index
    sta printf_uchar.uvalue
    // [141] call printf_uchar
    // [389] phi from bram_heap_alloc::@12 to printf_uchar [phi:bram_heap_alloc::@12->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_alloc::@12->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#1 [phi:bram_heap_alloc::@12->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [142] phi from bram_heap_alloc::@12 to bram_heap_alloc::@13 [phi:bram_heap_alloc::@12->bram_heap_alloc::@13]
    // bram_heap_alloc::@13
    // printf("\n > returning heap index %03x.\n", heap_index)
    // [143] call printf_str
    // [380] phi from bram_heap_alloc::@13 to printf_str [phi:bram_heap_alloc::@13->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_alloc::s4 [phi:bram_heap_alloc::@13->printf_str#0] -- call_phi_near 
    lda #<s4
    sta printf_str.s
    lda #>s4
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_alloc::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // bram_heap_alloc::@return
    // }
    // [145] stackidx(char,bram_heap_alloc::OFFSET_STACK_RETURN_4) = bram_heap_alloc::heap_index#2 -- _stackidxbyte_vbuc1=vbum1 
    lda heap_index
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_4,x
    // [146] return 
    rts
    // bram_heap_alloc::@1
  __b1:
    // bram_heap_allocate(s, free_index, packed_size)
    // [147] bram_heap_allocate::s#0 = bram_heap_alloc::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_allocate.s
    // [148] bram_heap_allocate::free_index#0 = bram_heap_alloc::free_index#0 -- vbum1=vbuxx 
    stx bram_heap_allocate.free_index
    // [149] bram_heap_allocate::required_size#0 = bram_heap_alloc::packed_size#0 -- vwum1=vwum2 
    lda packed_size
    sta bram_heap_allocate.required_size
    lda packed_size+1
    sta bram_heap_allocate.required_size+1
    // [150] call bram_heap_allocate -- call_phi_near 
    jsr bram_heap_allocate
    // [151] bram_heap_allocate::return#0 = bram_heap_allocate::return#4
    // bram_heap_alloc::@11
    // heap_index = bram_heap_allocate(s, free_index, packed_size)
    // [152] bram_heap_alloc::heap_index#1 = bram_heap_allocate::return#0 -- vbum1=vbuaa 
    sta heap_index
    // bram_heap_segment.freeSize[s] -= packed_size
    // [153] bram_heap_alloc::$10 = bram_heap_alloc::s#0 << 1 -- vbuxx=vbum1_rol_1 
    lda s
    asl
    tax
    // [154] ((unsigned int *)&bram_heap_segment+$5e)[bram_heap_alloc::$10] = ((unsigned int *)&bram_heap_segment+$5e)[bram_heap_alloc::$10] - bram_heap_alloc::packed_size#0 -- pwuc1_derefidx_vbuxx=pwuc1_derefidx_vbuxx_minus_vwum1 
    lda bram_heap_segment+$5e,x
    sec
    sbc packed_size
    sta bram_heap_segment+$5e,x
    lda bram_heap_segment+$5e+1,x
    sbc packed_size+1
    sta bram_heap_segment+$5e+1,x
    // bram_heap_segment.heapSize[s] += packed_size
    // [155] ((unsigned int *)&bram_heap_segment+$56)[bram_heap_alloc::$10] = ((unsigned int *)&bram_heap_segment+$56)[bram_heap_alloc::$10] + bram_heap_alloc::packed_size#0 -- pwuc1_derefidx_vbuxx=pwuc1_derefidx_vbuxx_plus_vwum1 
    lda bram_heap_segment+$56,x
    clc
    adc packed_size
    sta bram_heap_segment+$56,x
    lda bram_heap_segment+$56+1,x
    adc packed_size+1
    sta bram_heap_segment+$56+1,x
    // [138] phi from bram_heap_alloc::@11 to bram_heap_alloc::@2 [phi:bram_heap_alloc::@11->bram_heap_alloc::@2]
    // [138] phi bram_heap_alloc::heap_index#2 = bram_heap_alloc::heap_index#1 [phi:bram_heap_alloc::@11->bram_heap_alloc::@2#0] -- register_copy 
    jmp __b2
  .segment DataBramHeap
    s1: .text @"\n > Allocate segment "
    .byte 0
    s2: .text ", size "
    .byte 0
    s3: .text @"\n > returning heap index "
    .byte 0
    s4: .text @".\n"
    .byte 0
  .segment Data
    s: .byte 0
    size: .dword 0
  .segment DataBramHeap
    packed_size: .word 0
    heap_index: .byte 0
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
    // [156] bram_heap_segment_init::s#0 = stackidx(char,bram_heap_segment_init::OFFSET_STACK_S) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_S,x
    sta s
    // [157] bram_heap_segment_init::bram_bank_floor#0 = stackidx(char,bram_heap_segment_init::OFFSET_STACK_BRAM_BANK_FLOOR) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_BANK_FLOOR,x
    sta bram_bank_floor
    // [158] bram_heap_segment_init::bram_ptr_floor#0 = stackidx(char *,bram_heap_segment_init::OFFSET_STACK_BRAM_PTR_FLOOR) -- pbum1=_stackidxptr_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_PTR_FLOOR,x
    sta bram_ptr_floor
    lda STACK_BASE+OFFSET_STACK_BRAM_PTR_FLOOR+1,x
    sta bram_ptr_floor+1
    // [159] bram_heap_segment_init::bram_bank_ceil#0 = stackidx(char,bram_heap_segment_init::OFFSET_STACK_BRAM_BANK_CEIL) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_BANK_CEIL,x
    sta bram_bank_ceil
    // [160] bram_heap_segment_init::bram_ptr_ceil#0 = stackidx(char *,bram_heap_segment_init::OFFSET_STACK_BRAM_PTR_CEIL) -- pbum1=_stackidxptr_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_PTR_CEIL,x
    sta bram_ptr_ceil
    lda STACK_BASE+OFFSET_STACK_BRAM_PTR_CEIL+1,x
    sta bram_ptr_ceil+1
    // bram_heap_segment.bram_bank_floor[s] = bram_bank_floor
    // [161] ((char *)&bram_heap_segment+2)[bram_heap_segment_init::s#0] = bram_heap_segment_init::bram_bank_floor#0 -- pbuc1_derefidx_vbum1=vbum2 
    // TODO initialize segment to all zero
    lda bram_bank_floor
    ldy s
    sta bram_heap_segment+2,y
    // bram_heap_segment.bram_ptr_floor[s] = bram_ptr_floor
    // [162] bram_heap_segment_init::$16 = bram_heap_segment_init::s#0 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta bram_heap_segment_init__16
    // [163] ((void **)&bram_heap_segment+6)[bram_heap_segment_init::$16] = (void *)bram_heap_segment_init::bram_ptr_floor#0 -- qvoc1_derefidx_vbum1=pvom2 
    tay
    lda bram_ptr_floor
    sta bram_heap_segment+6,y
    lda bram_ptr_floor+1
    sta bram_heap_segment+6+1,y
    // bram_heap_segment.bram_bank_ceil[s] = bram_bank_ceil
    // [164] ((char *)&bram_heap_segment+$16)[bram_heap_segment_init::s#0] = bram_heap_segment_init::bram_bank_ceil#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda bram_bank_ceil
    ldy s
    sta bram_heap_segment+$16,y
    // bram_heap_segment.bram_ptr_ceil[s] = bram_ptr_ceil
    // [165] ((void **)&bram_heap_segment+$1a)[bram_heap_segment_init::$16] = (void *)bram_heap_segment_init::bram_ptr_ceil#0 -- qvoc1_derefidx_vbum1=pvom2 
    ldy bram_heap_segment_init__16
    lda bram_ptr_ceil
    sta bram_heap_segment+$1a,y
    lda bram_ptr_ceil+1
    sta bram_heap_segment+$1a+1,y
    // bram_heap_data_pack(bram_bank_floor, bram_ptr_floor)
    // [166] bram_heap_data_pack::bram_bank#0 = bram_heap_segment_init::bram_bank_floor#0 -- vbuxx=vbum1 
    ldx bram_bank_floor
    // [167] bram_heap_data_pack::bram_ptr#0 = bram_heap_segment_init::bram_ptr_floor#0
    // [168] call bram_heap_data_pack
    // [654] phi from bram_heap_segment_init to bram_heap_data_pack [phi:bram_heap_segment_init->bram_heap_data_pack]
    // [654] phi bram_heap_data_pack::bram_ptr#2 = bram_heap_data_pack::bram_ptr#0 [phi:bram_heap_segment_init->bram_heap_data_pack#0] -- register_copy 
    // [654] phi bram_heap_data_pack::bram_bank#2 = bram_heap_data_pack::bram_bank#0 [phi:bram_heap_segment_init->bram_heap_data_pack#1] -- call_phi_near 
    jsr bram_heap_data_pack
    // bram_heap_data_pack(bram_bank_floor, bram_ptr_floor)
    // [169] bram_heap_data_pack::return#0 = bram_heap_data_pack::return#2
    // bram_heap_segment_init::@4
    // [170] bram_heap_segment_init::$0 = bram_heap_data_pack::return#0
    // bram_heap_segment.floor[s] = bram_heap_data_pack(bram_bank_floor, bram_ptr_floor)
    // [171] ((unsigned int *)&bram_heap_segment+$e)[bram_heap_segment_init::$16] = bram_heap_segment_init::$0 -- pwuc1_derefidx_vbum1=vwum2 
    ldy bram_heap_segment_init__16
    lda bram_heap_segment_init__0
    sta bram_heap_segment+$e,y
    lda bram_heap_segment_init__0+1
    sta bram_heap_segment+$e+1,y
    // bram_heap_data_pack(bram_bank_ceil, bram_ptr_ceil)
    // [172] bram_heap_data_pack::bram_bank#1 = bram_heap_segment_init::bram_bank_ceil#0 -- vbuxx=vbum1 
    ldx bram_bank_ceil
    // [173] bram_heap_data_pack::bram_ptr#1 = bram_heap_segment_init::bram_ptr_ceil#0 -- pbum1=pbum2 
    lda bram_ptr_ceil
    sta bram_heap_data_pack.bram_ptr
    lda bram_ptr_ceil+1
    sta bram_heap_data_pack.bram_ptr+1
    // [174] call bram_heap_data_pack
    // [654] phi from bram_heap_segment_init::@4 to bram_heap_data_pack [phi:bram_heap_segment_init::@4->bram_heap_data_pack]
    // [654] phi bram_heap_data_pack::bram_ptr#2 = bram_heap_data_pack::bram_ptr#1 [phi:bram_heap_segment_init::@4->bram_heap_data_pack#0] -- register_copy 
    // [654] phi bram_heap_data_pack::bram_bank#2 = bram_heap_data_pack::bram_bank#1 [phi:bram_heap_segment_init::@4->bram_heap_data_pack#1] -- call_phi_near 
    jsr bram_heap_data_pack
    // bram_heap_data_pack(bram_bank_ceil, bram_ptr_ceil)
    // [175] bram_heap_data_pack::return#1 = bram_heap_data_pack::return#2
    // bram_heap_segment_init::@5
    // [176] bram_heap_segment_init::$1 = bram_heap_data_pack::return#1
    // bram_heap_segment.ceil[s]  = bram_heap_data_pack(bram_bank_ceil, bram_ptr_ceil)
    // [177] ((unsigned int *)&bram_heap_segment+$22)[bram_heap_segment_init::$16] = bram_heap_segment_init::$1 -- pwuc1_derefidx_vbum1=vwum2 
    ldy bram_heap_segment_init__16
    lda bram_heap_segment_init__1
    sta bram_heap_segment+$22,y
    lda bram_heap_segment_init__1+1
    sta bram_heap_segment+$22+1,y
    // bram_heap_segment.heap_offset[s] = 0
    // [178] ((unsigned int *)&bram_heap_segment+$36)[bram_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta bram_heap_segment+$36,y
    sta bram_heap_segment+$36+1,y
    // bram_heap_size_packed_t free_size = bram_heap_segment.ceil[s]
    // [179] bram_heap_segment_init::free_size#0 = ((unsigned int *)&bram_heap_segment+$22)[bram_heap_segment_init::$16] -- vwum1=pwuc1_derefidx_vbum2 
    lda bram_heap_segment+$22,y
    sta free_size
    lda bram_heap_segment+$22+1,y
    sta free_size+1
    // free_size -= bram_heap_segment.floor[s]
    // [180] bram_heap_segment_init::free_size#1 = bram_heap_segment_init::free_size#0 - ((unsigned int *)&bram_heap_segment+$e)[bram_heap_segment_init::$16] -- vwum1=vwum1_minus_pwuc1_derefidx_vbum2 
    lda free_size
    sec
    sbc bram_heap_segment+$e,y
    sta free_size
    lda free_size+1
    sbc bram_heap_segment+$e+1,y
    sta free_size+1
    // bram_heap_segment.heapCount[s] = 0
    // [181] ((unsigned int *)&bram_heap_segment+$3e)[bram_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta bram_heap_segment+$3e,y
    sta bram_heap_segment+$3e+1,y
    // bram_heap_segment.freeCount[s] = 0
    // [182] ((unsigned int *)&bram_heap_segment+$46)[bram_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    sta bram_heap_segment+$46,y
    sta bram_heap_segment+$46+1,y
    // bram_heap_segment.idleCount[s] = 0
    // [183] ((unsigned int *)&bram_heap_segment+$4e)[bram_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    sta bram_heap_segment+$4e,y
    sta bram_heap_segment+$4e+1,y
    // bram_heap_segment.heap_list[s] = BRAM_HEAP_NULL
    // [184] ((char *)&bram_heap_segment+$2a)[bram_heap_segment_init::s#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    lda #$ff
    ldy s
    sta bram_heap_segment+$2a,y
    // bram_heap_segment.idle_list[s] = BRAM_HEAP_NULL
    // [185] ((char *)&bram_heap_segment+$32)[bram_heap_segment_init::s#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta bram_heap_segment+$32,y
    // bram_heap_segment.free_list[s] = BRAM_HEAP_NULL
    // [186] ((char *)&bram_heap_segment+$2e)[bram_heap_segment_init::s#0] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta bram_heap_segment+$2e,y
    // bram_heap_segment_init::bank_get_bram1
    // return BRAM;
    // [187] bram_heap_segment_init::bank_old#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_old
    // bram_heap_segment_init::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [188] bram_heap_segment_init::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_segment_init::bank_set_bram1
    // BRAM = bank
    // [189] BRAM = bram_heap_segment_init::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_segment_init::@2
    // bram_heap_index_t free_index = bram_heap_index_add(s)
    // [190] bram_heap_index_add::s#0 = bram_heap_segment_init::s#0 -- vbuxx=vbum1 
    ldx s
    // [191] call bram_heap_index_add
    // [661] phi from bram_heap_segment_init::@2 to bram_heap_index_add [phi:bram_heap_segment_init::@2->bram_heap_index_add]
    // [661] phi bram_heap_index_add::s#2 = bram_heap_index_add::s#0 [phi:bram_heap_segment_init::@2->bram_heap_index_add#0] -- call_phi_near 
    jsr bram_heap_index_add
    // bram_heap_index_t free_index = bram_heap_index_add(s)
    // [192] bram_heap_index_add::return#0 = bram_heap_index_add::return#1 -- vbuaa=vbum1 
    lda bram_heap_index_add.return
    // bram_heap_segment_init::@6
    // [193] bram_heap_segment_init::free_index#0 = bram_heap_index_add::return#0
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, free_index)
    // [194] bram_heap_list_insert_at::list#0 = ((char *)&bram_heap_segment+$2e)[bram_heap_segment_init::s#0] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$2e,y
    // [195] bram_heap_list_insert_at::index#0 = bram_heap_segment_init::free_index#0 -- vbum1=vbuaa 
    sta bram_heap_list_insert_at.index
    // [196] bram_heap_list_insert_at::at#0 = bram_heap_segment_init::free_index#0 -- vbum1=vbuaa 
    sta bram_heap_list_insert_at.at
    // [197] call bram_heap_list_insert_at
    // [671] phi from bram_heap_segment_init::@6 to bram_heap_list_insert_at [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at]
    // [671] phi bram_heap_list_insert_at::index#10 = bram_heap_list_insert_at::index#0 [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at#0] -- register_copy 
    // [671] phi bram_heap_list_insert_at::at#11 = bram_heap_list_insert_at::at#0 [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at#1] -- register_copy 
    // [671] phi bram_heap_list_insert_at::list#5 = bram_heap_list_insert_at::list#0 [phi:bram_heap_segment_init::@6->bram_heap_list_insert_at#2] -- call_phi_near 
    jsr bram_heap_list_insert_at
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, free_index)
    // [198] bram_heap_list_insert_at::return#0 = bram_heap_list_insert_at::list#11
    // bram_heap_segment_init::@7
    // [199] bram_heap_segment_init::free_index#1 = bram_heap_list_insert_at::return#0 -- vbum1=vbuxx 
    stx free_index
    // bram_heap_set_data_packed(s, free_index, bram_heap_segment.floor[s])
    // [200] bram_heap_set_data_packed::index#0 = bram_heap_segment_init::free_index#1 -- vbuxx=vbum1 
    // [201] bram_heap_set_data_packed::data_packed#0 = ((unsigned int *)&bram_heap_segment+$e)[bram_heap_segment_init::$16] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_segment_init__16
    lda bram_heap_segment+$e,y
    sta bram_heap_set_data_packed.data_packed
    lda bram_heap_segment+$e+1,y
    sta bram_heap_set_data_packed.data_packed+1
    // [202] call bram_heap_set_data_packed
    // [686] phi from bram_heap_segment_init::@7 to bram_heap_set_data_packed [phi:bram_heap_segment_init::@7->bram_heap_set_data_packed]
    // [686] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#0 [phi:bram_heap_segment_init::@7->bram_heap_set_data_packed#0] -- register_copy 
    // [686] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#0 [phi:bram_heap_segment_init::@7->bram_heap_set_data_packed#1] -- call_phi_near 
    jsr bram_heap_set_data_packed
    // bram_heap_segment_init::@8
    // bram_heap_set_size_packed(s, free_index, bram_heap_segment.ceil[s] - bram_heap_segment.floor[s])
    // [203] bram_heap_set_size_packed::size_packed#0 = ((unsigned int *)&bram_heap_segment+$22)[bram_heap_segment_init::$16] - ((unsigned int *)&bram_heap_segment+$e)[bram_heap_segment_init::$16] -- vwum1=pwuc1_derefidx_vbum2_minus_pwuc2_derefidx_vbum2 
    ldy bram_heap_segment_init__16
    lda bram_heap_segment+$22,y
    sec
    sbc bram_heap_segment+$e,y
    sta bram_heap_set_size_packed.size_packed
    lda bram_heap_segment+$22+1,y
    sbc bram_heap_segment+$e+1,y
    sta bram_heap_set_size_packed.size_packed+1
    // [204] bram_heap_set_size_packed::index#0 = bram_heap_segment_init::free_index#1 -- vbuxx=vbum1 
    ldx free_index
    // [205] call bram_heap_set_size_packed
    // [692] phi from bram_heap_segment_init::@8 to bram_heap_set_size_packed [phi:bram_heap_segment_init::@8->bram_heap_set_size_packed]
    // [692] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#0 [phi:bram_heap_segment_init::@8->bram_heap_set_size_packed#0] -- register_copy 
    // [692] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#0 [phi:bram_heap_segment_init::@8->bram_heap_set_size_packed#1] -- call_phi_near 
    jsr bram_heap_set_size_packed
    // bram_heap_segment_init::@9
    // bram_heap_set_free(s, free_index)
    // [206] bram_heap_set_free::index#0 = bram_heap_segment_init::free_index#1 -- vbuxx=vbum1 
    ldx free_index
    // [207] call bram_heap_set_free
    // [701] phi from bram_heap_segment_init::@9 to bram_heap_set_free [phi:bram_heap_segment_init::@9->bram_heap_set_free]
    // [701] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#0 [phi:bram_heap_segment_init::@9->bram_heap_set_free#0] -- call_phi_near 
    jsr bram_heap_set_free
    // bram_heap_segment_init::bram_heap_set_next1
    // bram_heap_index.next[index] = next
    // [208] ((char *)&bram_heap_index+$400)[bram_heap_segment_init::free_index#1] = bram_heap_segment_init::free_index#1 -- pbuc1_derefidx_vbum1=vbum1 
    ldy free_index
    tya
    sta bram_heap_index+$400,y
    // bram_heap_segment_init::bram_heap_set_prev1
    // bram_heap_index.prev[index] = prev
    // [209] ((char *)&bram_heap_index+$500)[bram_heap_segment_init::free_index#1] = bram_heap_segment_init::free_index#1 -- pbuc1_derefidx_vbum1=vbum1 
    tya
    sta bram_heap_index+$500,y
    // bram_heap_segment_init::@3
    // bram_heap_segment.freeCount[s]++;
    // [210] ((unsigned int *)&bram_heap_segment+$46)[bram_heap_segment_init::$16] = ++ ((unsigned int *)&bram_heap_segment+$46)[bram_heap_segment_init::$16] -- pwuc1_derefidx_vbum1=_inc_pwuc1_derefidx_vbum1 
    ldx bram_heap_segment_init__16
    inc bram_heap_segment+$46,x
    bne !+
    inc bram_heap_segment+$46+1,x
  !:
    // bram_heap_segment.free_list[s] = free_index
    // [211] ((char *)&bram_heap_segment+$2e)[bram_heap_segment_init::s#0] = bram_heap_segment_init::free_index#1 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_index
    ldy s
    sta bram_heap_segment+$2e,y
    // bram_heap_segment.freeSize[s] = free_size
    // [212] ((unsigned int *)&bram_heap_segment+$5e)[bram_heap_segment_init::$16] = bram_heap_segment_init::free_size#1 -- pwuc1_derefidx_vbum1=vwum2 
    ldy bram_heap_segment_init__16
    lda free_size
    sta bram_heap_segment+$5e,y
    lda free_size+1
    sta bram_heap_segment+$5e+1,y
    // bram_heap_segment.heapSize[s] = 0
    // [213] ((unsigned int *)&bram_heap_segment+$56)[bram_heap_segment_init::$16] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta bram_heap_segment+$56,y
    sta bram_heap_segment+$56+1,y
    // bram_heap_segment_init::bank_set_bram2
    // BRAM = bank
    // [214] BRAM = bram_heap_segment_init::bank_old#0 -- vbuz1=vbum2 
    lda bank_old
    sta.z BRAM
    // bram_heap_segment_init::@return
    // }
    // [215] stackidx(char,bram_heap_segment_init::OFFSET_STACK_RETURN_6) = bram_heap_segment_init::s#0 -- _stackidxbyte_vbuc1=vbum1 
    lda s
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_6,x
    // [216] return 
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
    // [217] bram_heap_bram_bank_init::bram_bank#0 = stackidx(char,bram_heap_bram_bank_init::OFFSET_STACK_BRAM_BANK) -- vbuaa=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_BRAM_BANK,x
    // bram_heap_segment.bram_bank = bram_bank
    // [218] *((char *)&bram_heap_segment) = bram_heap_bram_bank_init::bram_bank#0 -- _deref_pbuc1=vbuaa 
    sta bram_heap_segment
    // bram_heap_segment.index_position = 0
    // [219] *((char *)&bram_heap_segment+1) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta bram_heap_segment+1
    // bram_heap_bram_bank_init::@return
    // }
    // [220] return 
    rts
}
.segment Code
  // conio_x16_init
/// Set initial screen values.
conio_x16_init: {
    // screenlayer1()
    // [222] call screenlayer1 -- call_phi_near 
    jsr screenlayer1
    // [223] phi from conio_x16_init to conio_x16_init::@1 [phi:conio_x16_init->conio_x16_init::@1]
    // conio_x16_init::@1
    // textcolor(CONIO_TEXTCOLOR_DEFAULT)
    // [224] call textcolor -- call_phi_near 
    jsr textcolor
    // [225] phi from conio_x16_init::@1 to conio_x16_init::@2 [phi:conio_x16_init::@1->conio_x16_init::@2]
    // conio_x16_init::@2
    // bgcolor(CONIO_BACKCOLOR_DEFAULT)
    // [226] call bgcolor -- call_phi_near 
    jsr bgcolor
    // [227] phi from conio_x16_init::@2 to conio_x16_init::@3 [phi:conio_x16_init::@2->conio_x16_init::@3]
    // conio_x16_init::@3
    // cursor(0)
    // [228] call cursor -- call_phi_near 
    jsr cursor
    // [229] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // cbm_k_plot_get()
    // [230] call cbm_k_plot_get -- call_phi_near 
    jsr cbm_k_plot_get
    // [231] cbm_k_plot_get::return#2 = cbm_k_plot_get::return#0 -- vwum1=vwum2 
    lda cbm_k_plot_get.return
    sta cbm_k_plot_get.return_1
    lda cbm_k_plot_get.return+1
    sta cbm_k_plot_get.return_1+1
    // conio_x16_init::@5
    // [232] conio_x16_init::$4 = cbm_k_plot_get::return#2 -- vwum1=vwum2 
    lda cbm_k_plot_get.return_1
    sta conio_x16_init__4
    lda cbm_k_plot_get.return_1+1
    sta conio_x16_init__4+1
    // BYTE1(cbm_k_plot_get())
    // [233] conio_x16_init::$5 = byte1  conio_x16_init::$4 -- vbuaa=_byte1_vwum1 
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [234] *((char *)&__conio) = conio_x16_init::$5 -- _deref_pbuc1=vbuaa 
    sta __conio
    // cbm_k_plot_get()
    // [235] call cbm_k_plot_get -- call_phi_near 
    jsr cbm_k_plot_get
    // [236] cbm_k_plot_get::return#3 = cbm_k_plot_get::return#0 -- vwum1=vwum2 
    lda cbm_k_plot_get.return
    sta cbm_k_plot_get.return_2
    lda cbm_k_plot_get.return+1
    sta cbm_k_plot_get.return_2+1
    // conio_x16_init::@6
    // [237] conio_x16_init::$6 = cbm_k_plot_get::return#3 -- vwum1=vwum2 
    lda cbm_k_plot_get.return_2
    sta conio_x16_init__6
    lda cbm_k_plot_get.return_2+1
    sta conio_x16_init__6+1
    // BYTE0(cbm_k_plot_get())
    // [238] conio_x16_init::$7 = byte0  conio_x16_init::$6 -- vbuaa=_byte0_vwum1 
    lda conio_x16_init__6
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [239] *((char *)&__conio+1) = conio_x16_init::$7 -- _deref_pbuc1=vbuaa 
    sta __conio+1
    // gotoxy(__conio.cursor_x, __conio.cursor_y)
    // [240] gotoxy::x#0 = *((char *)&__conio) -- vbuxx=_deref_pbuc1 
    ldx __conio
    // [241] gotoxy::y#0 = *((char *)&__conio+1) -- vbuyy=_deref_pbuc1 
    tay
    // [242] call gotoxy
    // [723] phi from conio_x16_init::@6 to gotoxy [phi:conio_x16_init::@6->gotoxy]
    // [723] phi gotoxy::y#10 = gotoxy::y#0 [phi:conio_x16_init::@6->gotoxy#0] -- register_copy 
    // [723] phi gotoxy::x#10 = gotoxy::x#0 [phi:conio_x16_init::@6->gotoxy#1] -- call_phi_near 
    jsr gotoxy
    // conio_x16_init::@7
    // __conio.scroll[0] = 1
    // [243] *((char *)&__conio+$f) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta __conio+$f
    // __conio.scroll[1] = 1
    // [244] *((char *)&__conio+$f+1) = 1 -- _deref_pbuc1=vbuc2 
    sta __conio+$f+1
    // conio_x16_init::@return
    // }
    // [245] return 
    rts
  .segment Data
    conio_x16_init__4: .word 0
    conio_x16_init__6: .word 0
}
.segment Code
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__register(X) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    // [246] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbuxx=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    tax
    // if(c=='\n')
    // [247] if(cputc::c#0==' 'pm) goto cputc::@1 -- vbuxx_eq_vbuc1_then_la1 
    cpx #'\n'
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [248] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(__conio.offset)
    // [249] cputc::$1 = byte0  *((unsigned int *)&__conio+$13) -- vbuaa=_byte0__deref_pwuc1 
    lda __conio+$13
    // *VERA_ADDRX_L = BYTE0(__conio.offset)
    // [250] *VERA_ADDRX_L = cputc::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(__conio.offset)
    // [251] cputc::$2 = byte1  *((unsigned int *)&__conio+$13) -- vbuaa=_byte1__deref_pwuc1 
    lda __conio+$13+1
    // *VERA_ADDRX_M = BYTE1(__conio.offset)
    // [252] *VERA_ADDRX_M = cputc::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [253] cputc::$3 = *((char *)&__conio+5) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [254] *VERA_ADDRX_H = cputc::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [255] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [256] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // if(!__conio.hscroll[__conio.layer])
    // [257] if(0==((char *)&__conio+$11)[*((char *)&__conio+2)]) goto cputc::@5 -- 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$11,y
    cmp #0
    beq __b5
    // cputc::@3
    // if(__conio.cursor_x >= __conio.mapwidth)
    // [258] if(*((char *)&__conio)>=*((char *)&__conio+8)) goto cputc::@6 -- _deref_pbuc1_ge__deref_pbuc2_then_la1 
    lda __conio
    cmp __conio+8
    bcs __b6
    // cputc::@4
    // __conio.cursor_x++;
    // [259] *((char *)&__conio) = ++ *((char *)&__conio) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio
    // cputc::@7
  __b7:
    // __conio.offset++;
    // [260] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // [261] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // cputc::@return
    // }
    // [262] return 
    rts
    // [263] phi from cputc::@3 to cputc::@6 [phi:cputc::@3->cputc::@6]
    // cputc::@6
  __b6:
    // cputln()
    // [264] call cputln -- call_phi_near 
    jsr cputln
    jmp __b7
    // cputc::@5
  __b5:
    // if(__conio.cursor_x >= __conio.width)
    // [265] if(*((char *)&__conio)>=*((char *)&__conio+6)) goto cputc::@8 -- _deref_pbuc1_ge__deref_pbuc2_then_la1 
    lda __conio
    cmp __conio+6
    bcs __b8
    // cputc::@9
    // __conio.cursor_x++;
    // [266] *((char *)&__conio) = ++ *((char *)&__conio) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio
    // __conio.offset++;
    // [267] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // [268] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    rts
    // [269] phi from cputc::@5 to cputc::@8 [phi:cputc::@5->cputc::@8]
    // cputc::@8
  __b8:
    // cputln()
    // [270] call cputln -- call_phi_near 
    jsr cputln
    rts
    // [271] phi from cputc to cputc::@1 [phi:cputc->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [272] call cputln -- call_phi_near 
    jsr cputln
    rts
}
  // main
main: {
    // main::@return
    // [274] return 
    rts
}
.segment CodeBramHeap
  // bram_heap_get_size_packed
// __mem() unsigned int bram_heap_get_size_packed(char s, __register(X) char index)
bram_heap_get_size_packed: {
    // bram_heap_index.size1[index] & 0x7F
    // [276] bram_heap_get_size_packed::$0 = ((char *)&bram_heap_index+$300)[bram_heap_get_size_packed::index#8] & $7f -- vbuaa=pbuc1_derefidx_vbuxx_band_vbuc2 
    lda #$7f
    and bram_heap_index+$300,x
    // MAKEWORD(bram_heap_index.size1[index] & 0x7F, bram_heap_index.size0[index])
    // [277] bram_heap_get_size_packed::return#12 = bram_heap_get_size_packed::$0 w= ((char *)&bram_heap_index+$200)[bram_heap_get_size_packed::index#8] -- vwum1=vbuaa_word_pbuc1_derefidx_vbuxx 
    sta return_2+1
    lda bram_heap_index+$200,x
    sta return_2
    // bram_heap_get_size_packed::@return
    // }
    // [278] return 
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
    // [280] bram_heap_get_data_packed::return#1 = ((char *)&bram_heap_index+$100)[bram_heap_get_data_packed::index#9] w= ((char *)&bram_heap_index)[bram_heap_get_data_packed::index#9] -- vwum1=pbuc1_derefidx_vbuxx_word_pbuc2_derefidx_vbuxx 
    lda bram_heap_index+$100,x
    sta return_1+1
    lda bram_heap_index,x
    sta return_1
    // bram_heap_get_data_packed::@return
    // }
    // [281] return 
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
    return_9: .word 0
}
.segment CodeBramHeap
  // bram_heap_dump_xy
// void bram_heap_dump_xy(__register(X) char x, __register(A) char y)
bram_heap_dump_xy: {
    // bramheap_dx = x
    // [282] bramheap_dx = bram_heap_dump_xy::x#0 -- vbum1=vbuxx 
    stx bramheap_dx
    // bramheap_dy = y
    // [283] bramheap_dy = bram_heap_dump_xy::y#0 -- vbum1=vbuaa 
    sta bramheap_dy
    // bram_heap_dump_xy::@return
    // }
    // [284] return 
    rts
}
  // bram_heap_dump_stats
/**
 * @brief Print the heap memory manager statistics of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
// void bram_heap_dump_stats(__mem() char s)
bram_heap_dump_stats: {
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [285] gotoxy::x#3 = bramheap_dx -- vbuxx=vbum1 
    ldx bramheap_dx
    // [286] gotoxy::y#3 = bramheap_dy -- vbuyy=vbum1 
    ldy bramheap_dy
    // [287] call gotoxy
    // [723] phi from bram_heap_dump_stats to gotoxy [phi:bram_heap_dump_stats->gotoxy]
    // [723] phi gotoxy::y#10 = gotoxy::y#3 [phi:bram_heap_dump_stats->gotoxy#0] -- register_copy 
    // [723] phi gotoxy::x#10 = gotoxy::x#3 [phi:bram_heap_dump_stats->gotoxy#1] -- call_phi_near 
    jsr gotoxy
    // bram_heap_dump_stats::@1
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [288] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // bram_heap_alloc_size(s)
    // [289] bram_heap_alloc_size::s#0 = bram_heap_dump_stats::s#0 -- vbuaa=vbum1 
    lda s
    // [290] call bram_heap_alloc_size -- call_phi_near 
    jsr bram_heap_alloc_size
    // [291] bram_heap_alloc_size::return#0 = bram_heap_alloc_size::return#1 -- vdum1=vdum2 
    lda bram_heap_alloc_size.return_1
    sta bram_heap_alloc_size.return
    lda bram_heap_alloc_size.return_1+1
    sta bram_heap_alloc_size.return+1
    lda bram_heap_alloc_size.return_1+2
    sta bram_heap_alloc_size.return+2
    lda bram_heap_alloc_size.return_1+3
    sta bram_heap_alloc_size.return+3
    // bram_heap_dump_stats::@2
    // printf("size  heap:%05x  free:%05x", bram_heap_alloc_size(s), bram_heap_free_size(s))
    // [292] printf_ulong::uvalue#2 = bram_heap_alloc_size::return#0 -- vdum1=vdum2 
    lda bram_heap_alloc_size.return
    sta printf_ulong.uvalue
    lda bram_heap_alloc_size.return+1
    sta printf_ulong.uvalue+1
    lda bram_heap_alloc_size.return+2
    sta printf_ulong.uvalue+2
    lda bram_heap_alloc_size.return+3
    sta printf_ulong.uvalue+3
    // bram_heap_free_size(s)
    // [293] bram_heap_free_size::s#0 = bram_heap_dump_stats::s#0 -- vbuaa=vbum1 
    lda s
    // [294] call bram_heap_free_size -- call_phi_near 
    jsr bram_heap_free_size
    // [295] bram_heap_free_size::return#0 = bram_heap_free_size::return#1 -- vdum1=vdum2 
    lda bram_heap_free_size.return_1
    sta bram_heap_free_size.return
    lda bram_heap_free_size.return_1+1
    sta bram_heap_free_size.return+1
    lda bram_heap_free_size.return_1+2
    sta bram_heap_free_size.return+2
    lda bram_heap_free_size.return_1+3
    sta bram_heap_free_size.return+3
    // bram_heap_dump_stats::@3
    // printf("size  heap:%05x  free:%05x", bram_heap_alloc_size(s), bram_heap_free_size(s))
    // [296] printf_ulong::uvalue#3 = bram_heap_free_size::return#0 -- vdum1=vdum2 
    lda bram_heap_free_size.return
    sta printf_ulong.uvalue_1
    lda bram_heap_free_size.return+1
    sta printf_ulong.uvalue_1+1
    lda bram_heap_free_size.return+2
    sta printf_ulong.uvalue_1+2
    lda bram_heap_free_size.return+3
    sta printf_ulong.uvalue_1+3
    // [297] call printf_str
    // [380] phi from bram_heap_dump_stats::@3 to printf_str [phi:bram_heap_dump_stats::@3->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_stats::s1 [phi:bram_heap_dump_stats::@3->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // [298] phi from bram_heap_dump_stats::@3 to bram_heap_dump_stats::@4 [phi:bram_heap_dump_stats::@3->bram_heap_dump_stats::@4]
    // bram_heap_dump_stats::@4
    // printf("size  heap:%05x  free:%05x", bram_heap_alloc_size(s), bram_heap_free_size(s))
    // [299] call printf_ulong
    // [397] phi from bram_heap_dump_stats::@4 to printf_ulong [phi:bram_heap_dump_stats::@4->printf_ulong]
    // [397] phi printf_ulong::uvalue#12 = printf_ulong::uvalue#2 [phi:bram_heap_dump_stats::@4->printf_ulong#0] -- call_phi_near 
    jsr printf_ulong
    // [300] phi from bram_heap_dump_stats::@4 to bram_heap_dump_stats::@5 [phi:bram_heap_dump_stats::@4->bram_heap_dump_stats::@5]
    // bram_heap_dump_stats::@5
    // printf("size  heap:%05x  free:%05x", bram_heap_alloc_size(s), bram_heap_free_size(s))
    // [301] call printf_str
    // [380] phi from bram_heap_dump_stats::@5 to printf_str [phi:bram_heap_dump_stats::@5->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_stats::s2 [phi:bram_heap_dump_stats::@5->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_stats::@6
    // [302] printf_ulong::uvalue#22 = printf_ulong::uvalue#3 -- vdum1=vdum2 
    lda printf_ulong.uvalue_1
    sta printf_ulong.uvalue
    lda printf_ulong.uvalue_1+1
    sta printf_ulong.uvalue+1
    lda printf_ulong.uvalue_1+2
    sta printf_ulong.uvalue+2
    lda printf_ulong.uvalue_1+3
    sta printf_ulong.uvalue+3
    // printf("size  heap:%05x  free:%05x", bram_heap_alloc_size(s), bram_heap_free_size(s))
    // [303] call printf_ulong
    // [397] phi from bram_heap_dump_stats::@6 to printf_ulong [phi:bram_heap_dump_stats::@6->printf_ulong]
    // [397] phi printf_ulong::uvalue#12 = printf_ulong::uvalue#22 [phi:bram_heap_dump_stats::@6->printf_ulong#0] -- call_phi_near 
    jsr printf_ulong
    // bram_heap_dump_stats::@7
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [304] gotoxy::x#4 = bramheap_dx -- vbuxx=vbum1 
    ldx bramheap_dx
    // [305] gotoxy::y#4 = bramheap_dy -- vbuyy=vbum1 
    ldy bramheap_dy
    // [306] call gotoxy
    // [723] phi from bram_heap_dump_stats::@7 to gotoxy [phi:bram_heap_dump_stats::@7->gotoxy]
    // [723] phi gotoxy::y#10 = gotoxy::y#4 [phi:bram_heap_dump_stats::@7->gotoxy#0] -- register_copy 
    // [723] phi gotoxy::x#10 = gotoxy::x#4 [phi:bram_heap_dump_stats::@7->gotoxy#1] -- call_phi_near 
    jsr gotoxy
    // bram_heap_dump_stats::@8
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [307] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // bram_heap_alloc_count(s)
    // [308] bram_heap_alloc_count::s#0 = bram_heap_dump_stats::s#0 -- vbuaa=vbum1 
    lda s
    // [309] call bram_heap_alloc_count -- call_phi_near 
    jsr bram_heap_alloc_count
    // [310] bram_heap_alloc_count::return#0 = bram_heap_alloc_count::return#1 -- vwum1=vwum2 
    lda bram_heap_alloc_count.return_1
    sta bram_heap_alloc_count.return
    lda bram_heap_alloc_count.return_1+1
    sta bram_heap_alloc_count.return+1
    // bram_heap_dump_stats::@9
    // printf("count  heap:%04u  free:%04u  idle:%04u", bram_heap_alloc_count(s), bram_heap_free_count(s), bram_heap_idle_count(s))
    // [311] printf_uint::uvalue#0 = bram_heap_alloc_count::return#0 -- vwum1=vwum2 
    lda bram_heap_alloc_count.return
    sta printf_uint.uvalue
    lda bram_heap_alloc_count.return+1
    sta printf_uint.uvalue+1
    // bram_heap_free_count(s)
    // [312] bram_heap_free_count::s#0 = bram_heap_dump_stats::s#0 -- vbuaa=vbum1 
    lda s
    // [313] call bram_heap_free_count -- call_phi_near 
    jsr bram_heap_free_count
    // [314] bram_heap_free_count::return#0 = bram_heap_free_count::return#1 -- vwum1=vwum2 
    lda bram_heap_free_count.return_1
    sta bram_heap_free_count.return
    lda bram_heap_free_count.return_1+1
    sta bram_heap_free_count.return+1
    // bram_heap_dump_stats::@10
    // printf("count  heap:%04u  free:%04u  idle:%04u", bram_heap_alloc_count(s), bram_heap_free_count(s), bram_heap_idle_count(s))
    // [315] printf_uint::uvalue#1 = bram_heap_free_count::return#0 -- vwum1=vwum2 
    lda bram_heap_free_count.return
    sta printf_uint.uvalue_1
    lda bram_heap_free_count.return+1
    sta printf_uint.uvalue_1+1
    // bram_heap_idle_count(s)
    // [316] bram_heap_idle_count::s#0 = bram_heap_dump_stats::s#0 -- vbuaa=vbum1 
    lda s
    // [317] call bram_heap_idle_count -- call_phi_near 
    jsr bram_heap_idle_count
    // [318] bram_heap_idle_count::return#0 = bram_heap_idle_count::return#1 -- vwum1=vwum2 
    lda bram_heap_idle_count.return_1
    sta bram_heap_idle_count.return
    lda bram_heap_idle_count.return_1+1
    sta bram_heap_idle_count.return+1
    // bram_heap_dump_stats::@11
    // printf("count  heap:%04u  free:%04u  idle:%04u", bram_heap_alloc_count(s), bram_heap_free_count(s), bram_heap_idle_count(s))
    // [319] printf_uint::uvalue#2 = bram_heap_idle_count::return#0 -- vwum1=vwum2 
    lda bram_heap_idle_count.return
    sta printf_uint.uvalue_2
    lda bram_heap_idle_count.return+1
    sta printf_uint.uvalue_2+1
    // [320] call printf_str
    // [380] phi from bram_heap_dump_stats::@11 to printf_str [phi:bram_heap_dump_stats::@11->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_stats::s3 [phi:bram_heap_dump_stats::@11->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // [321] phi from bram_heap_dump_stats::@11 to bram_heap_dump_stats::@12 [phi:bram_heap_dump_stats::@11->bram_heap_dump_stats::@12]
    // bram_heap_dump_stats::@12
    // printf("count  heap:%04u  free:%04u  idle:%04u", bram_heap_alloc_count(s), bram_heap_free_count(s), bram_heap_idle_count(s))
    // [322] call printf_uint
    // [769] phi from bram_heap_dump_stats::@12 to printf_uint [phi:bram_heap_dump_stats::@12->printf_uint]
    // [769] phi printf_uint::format_radix#10 = DECIMAL [phi:bram_heap_dump_stats::@12->printf_uint#0] -- vbuxx=vbuc1 
    ldx #DECIMAL
    // [769] phi printf_uint::uvalue#6 = printf_uint::uvalue#0 [phi:bram_heap_dump_stats::@12->printf_uint#1] -- call_phi_near 
    jsr printf_uint
    // [323] phi from bram_heap_dump_stats::@12 to bram_heap_dump_stats::@13 [phi:bram_heap_dump_stats::@12->bram_heap_dump_stats::@13]
    // bram_heap_dump_stats::@13
    // printf("count  heap:%04u  free:%04u  idle:%04u", bram_heap_alloc_count(s), bram_heap_free_count(s), bram_heap_idle_count(s))
    // [324] call printf_str
    // [380] phi from bram_heap_dump_stats::@13 to printf_str [phi:bram_heap_dump_stats::@13->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_stats::s2 [phi:bram_heap_dump_stats::@13->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_stats::@14
    // [325] printf_uint::uvalue#13 = printf_uint::uvalue#1 -- vwum1=vwum2 
    lda printf_uint.uvalue_1
    sta printf_uint.uvalue
    lda printf_uint.uvalue_1+1
    sta printf_uint.uvalue+1
    // printf("count  heap:%04u  free:%04u  idle:%04u", bram_heap_alloc_count(s), bram_heap_free_count(s), bram_heap_idle_count(s))
    // [326] call printf_uint
    // [769] phi from bram_heap_dump_stats::@14 to printf_uint [phi:bram_heap_dump_stats::@14->printf_uint]
    // [769] phi printf_uint::format_radix#10 = DECIMAL [phi:bram_heap_dump_stats::@14->printf_uint#0] -- vbuxx=vbuc1 
    ldx #DECIMAL
    // [769] phi printf_uint::uvalue#6 = printf_uint::uvalue#13 [phi:bram_heap_dump_stats::@14->printf_uint#1] -- call_phi_near 
    jsr printf_uint
    // [327] phi from bram_heap_dump_stats::@14 to bram_heap_dump_stats::@15 [phi:bram_heap_dump_stats::@14->bram_heap_dump_stats::@15]
    // bram_heap_dump_stats::@15
    // printf("count  heap:%04u  free:%04u  idle:%04u", bram_heap_alloc_count(s), bram_heap_free_count(s), bram_heap_idle_count(s))
    // [328] call printf_str
    // [380] phi from bram_heap_dump_stats::@15 to printf_str [phi:bram_heap_dump_stats::@15->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_stats::s5 [phi:bram_heap_dump_stats::@15->printf_str#0] -- call_phi_near 
    lda #<s5
    sta printf_str.s
    lda #>s5
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_stats::@16
    // [329] printf_uint::uvalue#14 = printf_uint::uvalue#2 -- vwum1=vwum2 
    lda printf_uint.uvalue_2
    sta printf_uint.uvalue
    lda printf_uint.uvalue_2+1
    sta printf_uint.uvalue+1
    // printf("count  heap:%04u  free:%04u  idle:%04u", bram_heap_alloc_count(s), bram_heap_free_count(s), bram_heap_idle_count(s))
    // [330] call printf_uint
    // [769] phi from bram_heap_dump_stats::@16 to printf_uint [phi:bram_heap_dump_stats::@16->printf_uint]
    // [769] phi printf_uint::format_radix#10 = DECIMAL [phi:bram_heap_dump_stats::@16->printf_uint#0] -- vbuxx=vbuc1 
    ldx #DECIMAL
    // [769] phi printf_uint::uvalue#6 = printf_uint::uvalue#14 [phi:bram_heap_dump_stats::@16->printf_uint#1] -- call_phi_near 
    jsr printf_uint
    // bram_heap_dump_stats::@17
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [331] gotoxy::x#5 = bramheap_dx -- vbuxx=vbum1 
    ldx bramheap_dx
    // [332] gotoxy::y#5 = bramheap_dy -- vbuyy=vbum1 
    ldy bramheap_dy
    // [333] call gotoxy
    // [723] phi from bram_heap_dump_stats::@17 to gotoxy [phi:bram_heap_dump_stats::@17->gotoxy]
    // [723] phi gotoxy::y#10 = gotoxy::y#5 [phi:bram_heap_dump_stats::@17->gotoxy#0] -- register_copy 
    // [723] phi gotoxy::x#10 = gotoxy::x#5 [phi:bram_heap_dump_stats::@17->gotoxy#1] -- call_phi_near 
    jsr gotoxy
    // bram_heap_dump_stats::@18
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [334] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // printf("list   heap:%03x   free:%03x   idle:%03x", bram_heap_segment.heap_list[s], bram_heap_segment.free_list[s], bram_heap_segment.idle_list[s])
    // [335] call printf_str
    // [380] phi from bram_heap_dump_stats::@18 to printf_str [phi:bram_heap_dump_stats::@18->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_stats::s6 [phi:bram_heap_dump_stats::@18->printf_str#0] -- call_phi_near 
    lda #<s6
    sta printf_str.s
    lda #>s6
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_stats::@19
    // printf("list   heap:%03x   free:%03x   idle:%03x", bram_heap_segment.heap_list[s], bram_heap_segment.free_list[s], bram_heap_segment.idle_list[s])
    // [336] printf_uchar::uvalue#3 = ((char *)&bram_heap_segment+$2a)[bram_heap_dump_stats::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$2a,y
    sta printf_uchar.uvalue
    // [337] call printf_uchar
    // [389] phi from bram_heap_dump_stats::@19 to printf_uchar [phi:bram_heap_dump_stats::@19->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_dump_stats::@19->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#3 [phi:bram_heap_dump_stats::@19->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [338] phi from bram_heap_dump_stats::@19 to bram_heap_dump_stats::@20 [phi:bram_heap_dump_stats::@19->bram_heap_dump_stats::@20]
    // bram_heap_dump_stats::@20
    // printf("list   heap:%03x   free:%03x   idle:%03x", bram_heap_segment.heap_list[s], bram_heap_segment.free_list[s], bram_heap_segment.idle_list[s])
    // [339] call printf_str
    // [380] phi from bram_heap_dump_stats::@20 to printf_str [phi:bram_heap_dump_stats::@20->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_stats::s7 [phi:bram_heap_dump_stats::@20->printf_str#0] -- call_phi_near 
    lda #<s7
    sta printf_str.s
    lda #>s7
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_stats::@21
    // printf("list   heap:%03x   free:%03x   idle:%03x", bram_heap_segment.heap_list[s], bram_heap_segment.free_list[s], bram_heap_segment.idle_list[s])
    // [340] printf_uchar::uvalue#4 = ((char *)&bram_heap_segment+$2e)[bram_heap_dump_stats::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$2e,y
    sta printf_uchar.uvalue
    // [341] call printf_uchar
    // [389] phi from bram_heap_dump_stats::@21 to printf_uchar [phi:bram_heap_dump_stats::@21->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_dump_stats::@21->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#4 [phi:bram_heap_dump_stats::@21->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [342] phi from bram_heap_dump_stats::@21 to bram_heap_dump_stats::@22 [phi:bram_heap_dump_stats::@21->bram_heap_dump_stats::@22]
    // bram_heap_dump_stats::@22
    // printf("list   heap:%03x   free:%03x   idle:%03x", bram_heap_segment.heap_list[s], bram_heap_segment.free_list[s], bram_heap_segment.idle_list[s])
    // [343] call printf_str
    // [380] phi from bram_heap_dump_stats::@22 to printf_str [phi:bram_heap_dump_stats::@22->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_stats::s8 [phi:bram_heap_dump_stats::@22->printf_str#0] -- call_phi_near 
    lda #<s8
    sta printf_str.s
    lda #>s8
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_stats::@23
    // printf("list   heap:%03x   free:%03x   idle:%03x", bram_heap_segment.heap_list[s], bram_heap_segment.free_list[s], bram_heap_segment.idle_list[s])
    // [344] printf_uchar::uvalue#5 = ((char *)&bram_heap_segment+$32)[bram_heap_dump_stats::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$32,y
    sta printf_uchar.uvalue
    // [345] call printf_uchar
    // [389] phi from bram_heap_dump_stats::@23 to printf_uchar [phi:bram_heap_dump_stats::@23->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_dump_stats::@23->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#5 [phi:bram_heap_dump_stats::@23->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // bram_heap_dump_stats::@return
    // }
    // [346] return 
    rts
  .segment DataBramHeap
    s1: .text "size  heap:"
    .byte 0
    s2: .text "  free:"
    .byte 0
    s3: .text "count  heap:"
    .byte 0
    s5: .text "  idle:"
    .byte 0
    s6: .text "list   heap:"
    .byte 0
    s7: .text "   free:"
    .byte 0
    s8: .text "   idle:"
    .byte 0
  .segment Data
    s: .byte 0
}
.segment CodeBramHeap
  // bram_heap_dump_index
/**
 * @brief Ddump the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
// void bram_heap_dump_index(__mem() char s)
bram_heap_dump_index: {
    // bram_heap_dump_index::bank_get_bram1
    // return BRAM;
    // [348] bram_heap_dump_index::bank_old#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_old
    // bram_heap_dump_index::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [349] bram_heap_dump_index::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment) -- vbuaa=_deref_pbuc1 
    lda bram_heap_segment
    // bram_heap_dump_index::bank_set_bram1
    // BRAM = bank
    // [350] BRAM = bram_heap_dump_index::bank_set_bram1_bank#0 -- vbuz1=vbuaa 
    sta.z BRAM
    // bram_heap_dump_index::@2
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [351] gotoxy::x#6 = bramheap_dx -- vbuxx=vbum1 
    ldx bramheap_dx
    // [352] gotoxy::y#6 = bramheap_dy -- vbuyy=vbum1 
    ldy bramheap_dy
    // [353] call gotoxy
    // [723] phi from bram_heap_dump_index::@2 to gotoxy [phi:bram_heap_dump_index::@2->gotoxy]
    // [723] phi gotoxy::y#10 = gotoxy::y#6 [phi:bram_heap_dump_index::@2->gotoxy#0] -- register_copy 
    // [723] phi gotoxy::x#10 = gotoxy::x#6 [phi:bram_heap_dump_index::@2->gotoxy#1] -- call_phi_near 
    jsr gotoxy
    // bram_heap_dump_index::@3
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [354] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // printf("#   T  OFFS  SIZE   N    P    L    R")
    // [355] call printf_str
    // [380] phi from bram_heap_dump_index::@3 to printf_str [phi:bram_heap_dump_index::@3->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_index::s1 [phi:bram_heap_dump_index::@3->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_index::@4
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [356] gotoxy::x#7 = bramheap_dx -- vbuxx=vbum1 
    ldx bramheap_dx
    // [357] gotoxy::y#7 = bramheap_dy -- vbuyy=vbum1 
    ldy bramheap_dy
    // [358] call gotoxy
    // [723] phi from bram_heap_dump_index::@4 to gotoxy [phi:bram_heap_dump_index::@4->gotoxy]
    // [723] phi gotoxy::y#10 = gotoxy::y#7 [phi:bram_heap_dump_index::@4->gotoxy#0] -- register_copy 
    // [723] phi gotoxy::x#10 = gotoxy::x#7 [phi:bram_heap_dump_index::@4->gotoxy#1] -- call_phi_near 
    jsr gotoxy
    // bram_heap_dump_index::@5
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [359] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // printf("--- -  ------ -----  ---  ---  ---  ---")
    // [360] call printf_str
    // [380] phi from bram_heap_dump_index::@5 to printf_str [phi:bram_heap_dump_index::@5->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_index::s2 [phi:bram_heap_dump_index::@5->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_index::@6
    // bram_heap_dump_index_print(s, 'I', bram_heap_segment.idle_list[s], bram_heap_segment.idleCount[s])
    // [361] bram_heap_dump_index::$11 = bram_heap_dump_index::s#0 << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_dump_index__11
    // [362] bram_heap_dump_index_print::s#0 = bram_heap_dump_index::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_dump_index_print.s
    // [363] bram_heap_dump_index_print::list#0 = ((char *)&bram_heap_segment+$32)[bram_heap_dump_index::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$32,y
    sta bram_heap_dump_index_print.list
    // [364] bram_heap_dump_index_print::heap_count#0 = ((unsigned int *)&bram_heap_segment+$4e)[bram_heap_dump_index::$11] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_dump_index__11
    lda bram_heap_segment+$4e,y
    sta bram_heap_dump_index_print.heap_count
    lda bram_heap_segment+$4e+1,y
    sta bram_heap_dump_index_print.heap_count+1
    // [365] call bram_heap_dump_index_print
    // [777] phi from bram_heap_dump_index::@6 to bram_heap_dump_index_print [phi:bram_heap_dump_index::@6->bram_heap_dump_index_print]
    // [777] phi bram_heap_dump_index_print::heap_count#39 = bram_heap_dump_index_print::heap_count#0 [phi:bram_heap_dump_index::@6->bram_heap_dump_index_print#0] -- register_copy 
    // [777] phi bram_heap_dump_index_print::prefix#11 = 'I'pm [phi:bram_heap_dump_index::@6->bram_heap_dump_index_print#1] -- vbum1=vbuc1 
    lda #'I'
    sta bram_heap_dump_index_print.prefix
    // [777] phi bram_heap_dump_index_print::s#10 = bram_heap_dump_index_print::s#0 [phi:bram_heap_dump_index::@6->bram_heap_dump_index_print#2] -- register_copy 
    // [777] phi bram_heap_dump_index_print::list#3 = bram_heap_dump_index_print::list#0 [phi:bram_heap_dump_index::@6->bram_heap_dump_index_print#3] -- call_phi_near 
    jsr bram_heap_dump_index_print
    // bram_heap_dump_index::@7
    // bram_heap_dump_index_print(s, 'F', bram_heap_segment.free_list[s], bram_heap_segment.freeCount[s])
    // [366] bram_heap_dump_index_print::s#1 = bram_heap_dump_index::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_dump_index_print.s
    // [367] bram_heap_dump_index_print::list#1 = ((char *)&bram_heap_segment+$2e)[bram_heap_dump_index::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$2e,y
    sta bram_heap_dump_index_print.list
    // [368] bram_heap_dump_index_print::heap_count#1 = ((unsigned int *)&bram_heap_segment+$46)[bram_heap_dump_index::$11] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_dump_index__11
    lda bram_heap_segment+$46,y
    sta bram_heap_dump_index_print.heap_count
    lda bram_heap_segment+$46+1,y
    sta bram_heap_dump_index_print.heap_count+1
    // [369] call bram_heap_dump_index_print
    // [777] phi from bram_heap_dump_index::@7 to bram_heap_dump_index_print [phi:bram_heap_dump_index::@7->bram_heap_dump_index_print]
    // [777] phi bram_heap_dump_index_print::heap_count#39 = bram_heap_dump_index_print::heap_count#1 [phi:bram_heap_dump_index::@7->bram_heap_dump_index_print#0] -- register_copy 
    // [777] phi bram_heap_dump_index_print::prefix#11 = 'F'pm [phi:bram_heap_dump_index::@7->bram_heap_dump_index_print#1] -- vbum1=vbuc1 
    lda #'F'
    sta bram_heap_dump_index_print.prefix
    // [777] phi bram_heap_dump_index_print::s#10 = bram_heap_dump_index_print::s#1 [phi:bram_heap_dump_index::@7->bram_heap_dump_index_print#2] -- register_copy 
    // [777] phi bram_heap_dump_index_print::list#3 = bram_heap_dump_index_print::list#1 [phi:bram_heap_dump_index::@7->bram_heap_dump_index_print#3] -- call_phi_near 
    jsr bram_heap_dump_index_print
    // bram_heap_dump_index::@8
    // bram_heap_dump_index_print(s, 'H', bram_heap_segment.heap_list[s], bram_heap_segment.heapCount[s])
    // [370] bram_heap_dump_index_print::s#2 = bram_heap_dump_index::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_dump_index_print.s
    // [371] bram_heap_dump_index_print::list#2 = ((char *)&bram_heap_segment+$2a)[bram_heap_dump_index::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$2a,y
    sta bram_heap_dump_index_print.list
    // [372] bram_heap_dump_index_print::heap_count#2 = ((unsigned int *)&bram_heap_segment+$3e)[bram_heap_dump_index::$11] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_dump_index__11
    lda bram_heap_segment+$3e,y
    sta bram_heap_dump_index_print.heap_count
    lda bram_heap_segment+$3e+1,y
    sta bram_heap_dump_index_print.heap_count+1
    // [373] call bram_heap_dump_index_print
    // [777] phi from bram_heap_dump_index::@8 to bram_heap_dump_index_print [phi:bram_heap_dump_index::@8->bram_heap_dump_index_print]
    // [777] phi bram_heap_dump_index_print::heap_count#39 = bram_heap_dump_index_print::heap_count#2 [phi:bram_heap_dump_index::@8->bram_heap_dump_index_print#0] -- register_copy 
    // [777] phi bram_heap_dump_index_print::prefix#11 = 'H'pm [phi:bram_heap_dump_index::@8->bram_heap_dump_index_print#1] -- vbum1=vbuc1 
    lda #'H'
    sta bram_heap_dump_index_print.prefix
    // [777] phi bram_heap_dump_index_print::s#10 = bram_heap_dump_index_print::s#2 [phi:bram_heap_dump_index::@8->bram_heap_dump_index_print#2] -- register_copy 
    // [777] phi bram_heap_dump_index_print::list#3 = bram_heap_dump_index_print::list#2 [phi:bram_heap_dump_index::@8->bram_heap_dump_index_print#3] -- call_phi_near 
    jsr bram_heap_dump_index_print
    // bram_heap_dump_index::bank_set_bram2
    // BRAM = bank
    // [374] BRAM = bram_heap_dump_index::bank_old#0 -- vbuz1=vbum2 
    lda bank_old
    sta.z BRAM
    // bram_heap_dump_index::@return
    // }
    // [375] return 
    rts
  .segment DataBramHeap
    s1: .text "#   T  OFFS  SIZE   N    P    L    R"
    .byte 0
    s2: .text "--- -  ------ -----  ---  ---  ---  ---"
    .byte 0
    bram_heap_dump_index__11: .byte 0
  .segment Data
    s: .byte 0
  .segment DataBramHeap
    bank_old: .byte 0
}
.segment CodeBramHeap
  // bram_heap_size_unpack
// __mem() unsigned long bram_heap_size_unpack(__mem() unsigned int size)
bram_heap_size_unpack: {
    // (bram_heap_size_t)size << 3
    // [377] bram_heap_size_unpack::$1 = (unsigned long)bram_heap_size_unpack::size#7 -- vdum1=_dword_vwum2 
    lda size
    sta bram_heap_size_unpack__1
    lda size+1
    sta bram_heap_size_unpack__1+1
    lda #0
    sta bram_heap_size_unpack__1+2
    sta bram_heap_size_unpack__1+3
    // [378] bram_heap_size_unpack::return#12 = bram_heap_size_unpack::$1 << 3 -- vdum1=vdum2_rol_3 
    lda bram_heap_size_unpack__1
    asl
    sta return_3
    lda bram_heap_size_unpack__1+1
    rol
    sta return_3+1
    lda bram_heap_size_unpack__1+2
    rol
    sta return_3+2
    lda bram_heap_size_unpack__1+3
    rol
    sta return_3+3
    asl return_3
    rol return_3+1
    rol return_3+2
    rol return_3+3
    asl return_3
    rol return_3+1
    rol return_3+2
    rol return_3+3
    // bram_heap_size_unpack::@return
    // }
    // [379] return 
    rts
  .segment DataBramHeap
    bram_heap_size_unpack__1: .dword 0
  .segment Data
    .label size = strlen.str
    return: .dword 0
    return_1: .dword 0
    return_2: .dword 0
    return_3: .dword 0
    return_4: .dword 0
    return_5: .dword 0
    return_6: .dword 0
    return_7: .dword 0
}
.segment Code
  // printf_str
/// Print a NUL-terminated string
// void printf_str(void (*putc)(char), __mem() const char *s)
printf_str: {
    // [381] phi from printf_str printf_str::@2 to printf_str::@1 [phi:printf_str/printf_str::@2->printf_str::@1]
    // [381] phi printf_str::s#68 = printf_str::s#69 [phi:printf_str/printf_str::@2->printf_str::@1#0] -- register_copy 
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [382] printf_str::c#1 = *printf_str::s#68 -- vbuaa=_deref_pbum1 
    ldy s
    sty.z $fe
    ldy s+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    // [383] printf_str::s#0 = ++ printf_str::s#68 -- pbum1=_inc_pbum1 
    inc s
    bne !+
    inc s+1
  !:
    // [384] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // printf_str::@return
    // }
    // [385] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [386] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbuaa 
    pha
    // [387] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
  .segment Data
    .label s = strlen.str
}
.segment Code
  // printf_uchar
// Print an unsigned char using a specific format
// void printf_uchar(void (*putc)(char), __mem() char uvalue, __mem() char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_uchar: {
    // printf_uchar::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [390] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    // [391] uctoa::value#1 = printf_uchar::uvalue#27 -- vbuxx=vbum1 
    ldx uvalue
    // [392] call uctoa
  // Format number into buffer
    // [867] phi from printf_uchar::@1 to uctoa [phi:printf_uchar::@1->uctoa] -- call_phi_near 
    jsr uctoa
    // printf_uchar::@2
    // printf_number_buffer(putc, printf_buffer, format)
    // [393] printf_number_buffer::buffer_sign#2 = *((char *)&printf_buffer) -- vbuxx=_deref_pbuc1 
    ldx printf_buffer
    // [394] printf_number_buffer::format_min_length#2 = printf_uchar::format_min_length#27 -- vbum1=vbum2 
    lda format_min_length
    sta printf_number_buffer.format_min_length
    // [395] call printf_number_buffer
  // Print using format
    // [886] phi from printf_uchar::@2 to printf_number_buffer [phi:printf_uchar::@2->printf_number_buffer]
    // [886] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#2 [phi:printf_uchar::@2->printf_number_buffer#0] -- register_copy 
    // [886] phi printf_number_buffer::format_min_length#3 = printf_number_buffer::format_min_length#2 [phi:printf_uchar::@2->printf_number_buffer#1] -- call_phi_near 
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [396] return 
    rts
  .segment Data
    uvalue: .byte 0
    format_min_length: .byte 0
}
.segment Code
  // printf_ulong
// Print an unsigned int using a specific format
// void printf_ulong(void (*putc)(char), __mem() unsigned long uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_ulong: {
    // printf_ulong::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [398] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format.radix)
    // [399] ultoa::value#1 = printf_ulong::uvalue#12 -- vdum1=vdum2 
    lda uvalue
    sta ultoa.value
    lda uvalue+1
    sta ultoa.value+1
    lda uvalue+2
    sta ultoa.value+2
    lda uvalue+3
    sta ultoa.value+3
    // [400] call ultoa
  // Format number into buffer
    // [910] phi from printf_ulong::@1 to ultoa [phi:printf_ulong::@1->ultoa] -- call_phi_near 
    jsr ultoa
    // printf_ulong::@2
    // printf_number_buffer(putc, printf_buffer, format)
    // [401] printf_number_buffer::buffer_sign#0 = *((char *)&printf_buffer) -- vbuxx=_deref_pbuc1 
    ldx printf_buffer
    // [402] call printf_number_buffer
  // Print using format
    // [886] phi from printf_ulong::@2 to printf_number_buffer [phi:printf_ulong::@2->printf_number_buffer]
    // [886] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#0 [phi:printf_ulong::@2->printf_number_buffer#0] -- register_copy 
    // [886] phi printf_number_buffer::format_min_length#3 = 5 [phi:printf_ulong::@2->printf_number_buffer#1] -- call_phi_near 
    lda #5
    sta printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // printf_ulong::@return
    // }
    // [403] return 
    rts
  .segment Data
    uvalue: .dword 0
    uvalue_1: .dword 0
    uvalue_2: .dword 0
    uvalue_3: .dword 0
}
.segment CodeBramHeap
  // bram_heap_heap_remove
// void bram_heap_heap_remove(__mem() char s, __mem() char heap_index)
bram_heap_heap_remove: {
    // bram_heap_segment.heapCount[s]--;
    // [404] bram_heap_heap_remove::$3 = bram_heap_heap_remove::s#0 << 1 -- vbuaa=vbum1_rol_1 
    lda s
    asl
    // [405] ((unsigned int *)&bram_heap_segment+$3e)[bram_heap_heap_remove::$3] = -- ((unsigned int *)&bram_heap_segment+$3e)[bram_heap_heap_remove::$3] -- pwuc1_derefidx_vbuaa=_dec_pwuc1_derefidx_vbuaa 
    tax
    lda bram_heap_segment+$3e,x
    bne !+
    dec bram_heap_segment+$3e+1,x
  !:
    dec bram_heap_segment+$3e,x
    // bram_heap_list_remove(s, bram_heap_segment.heap_list[s], heap_index)
    // [406] bram_heap_list_remove::list#2 = ((char *)&bram_heap_segment+$2a)[bram_heap_heap_remove::s#0] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$2a,y
    // [407] bram_heap_list_remove::index#0 = bram_heap_heap_remove::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_list_remove.index
    // [408] call bram_heap_list_remove
    // [931] phi from bram_heap_heap_remove to bram_heap_list_remove [phi:bram_heap_heap_remove->bram_heap_list_remove]
    // [931] phi bram_heap_list_remove::index#10 = bram_heap_list_remove::index#0 [phi:bram_heap_heap_remove->bram_heap_list_remove#0] -- register_copy 
    // [931] phi bram_heap_list_remove::list#10 = bram_heap_list_remove::list#2 [phi:bram_heap_heap_remove->bram_heap_list_remove#1] -- call_phi_near 
    jsr bram_heap_list_remove
    // bram_heap_list_remove(s, bram_heap_segment.heap_list[s], heap_index)
    // [409] bram_heap_list_remove::return#4 = bram_heap_list_remove::return#1 -- vbuaa=vbuxx 
    txa
    // bram_heap_heap_remove::@1
    // [410] bram_heap_heap_remove::$1 = bram_heap_list_remove::return#4
    // bram_heap_segment.heap_list[s] = bram_heap_list_remove(s, bram_heap_segment.heap_list[s], heap_index)
    // [411] ((char *)&bram_heap_segment+$2a)[bram_heap_heap_remove::s#0] = bram_heap_heap_remove::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy s
    sta bram_heap_segment+$2a,y
    // bram_heap_heap_remove::@return
    // }
    // [412] return 
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
    // [413] bram_heap_list_insert_at::list#3 = ((char *)&bram_heap_segment+$2e)[bram_heap_free_insert::s#0] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$2e,y
    // [414] bram_heap_list_insert_at::index#2 = bram_heap_free_insert::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_list_insert_at.index
    // [415] bram_heap_list_insert_at::at#3 = ((char *)&bram_heap_segment+$2e)[bram_heap_free_insert::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda bram_heap_segment+$2e,y
    sta bram_heap_list_insert_at.at
    // [416] call bram_heap_list_insert_at
    // [671] phi from bram_heap_free_insert to bram_heap_list_insert_at [phi:bram_heap_free_insert->bram_heap_list_insert_at]
    // [671] phi bram_heap_list_insert_at::index#10 = bram_heap_list_insert_at::index#2 [phi:bram_heap_free_insert->bram_heap_list_insert_at#0] -- register_copy 
    // [671] phi bram_heap_list_insert_at::at#11 = bram_heap_list_insert_at::at#3 [phi:bram_heap_free_insert->bram_heap_list_insert_at#1] -- register_copy 
    // [671] phi bram_heap_list_insert_at::list#5 = bram_heap_list_insert_at::list#3 [phi:bram_heap_free_insert->bram_heap_list_insert_at#2] -- call_phi_near 
    jsr bram_heap_list_insert_at
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, bram_heap_segment.free_list[s])
    // [417] bram_heap_list_insert_at::return#4 = bram_heap_list_insert_at::list#11 -- vbuaa=vbuxx 
    txa
    // bram_heap_free_insert::@1
    // [418] bram_heap_free_insert::$0 = bram_heap_list_insert_at::return#4
    // bram_heap_segment.free_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, bram_heap_segment.free_list[s])
    // [419] ((char *)&bram_heap_segment+$2e)[bram_heap_free_insert::s#0] = bram_heap_free_insert::$0 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy s
    sta bram_heap_segment+$2e,y
    // bram_heap_set_data_packed(s, free_index, data)
    // [420] bram_heap_set_data_packed::index#1 = bram_heap_free_insert::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [421] bram_heap_set_data_packed::data_packed#1 = bram_heap_free_insert::data#0 -- vwum1=vwum2 
    lda data
    sta bram_heap_set_data_packed.data_packed
    lda data+1
    sta bram_heap_set_data_packed.data_packed+1
    // [422] call bram_heap_set_data_packed
    // [686] phi from bram_heap_free_insert::@1 to bram_heap_set_data_packed [phi:bram_heap_free_insert::@1->bram_heap_set_data_packed]
    // [686] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#1 [phi:bram_heap_free_insert::@1->bram_heap_set_data_packed#0] -- register_copy 
    // [686] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#1 [phi:bram_heap_free_insert::@1->bram_heap_set_data_packed#1] -- call_phi_near 
    jsr bram_heap_set_data_packed
    // bram_heap_free_insert::@2
    // bram_heap_set_size_packed(s, free_index, size)
    // [423] bram_heap_set_size_packed::index#2 = bram_heap_free_insert::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [424] bram_heap_set_size_packed::size_packed#2 = bram_heap_free_insert::size#0 -- vwum1=vwum2 
    lda size
    sta bram_heap_set_size_packed.size_packed
    lda size+1
    sta bram_heap_set_size_packed.size_packed+1
    // [425] call bram_heap_set_size_packed
    // [692] phi from bram_heap_free_insert::@2 to bram_heap_set_size_packed [phi:bram_heap_free_insert::@2->bram_heap_set_size_packed]
    // [692] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#2 [phi:bram_heap_free_insert::@2->bram_heap_set_size_packed#0] -- register_copy 
    // [692] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#2 [phi:bram_heap_free_insert::@2->bram_heap_set_size_packed#1] -- call_phi_near 
    jsr bram_heap_set_size_packed
    // bram_heap_free_insert::@3
    // bram_heap_set_free(s, free_index)
    // [426] bram_heap_set_free::index#1 = bram_heap_free_insert::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [427] call bram_heap_set_free
    // [701] phi from bram_heap_free_insert::@3 to bram_heap_set_free [phi:bram_heap_free_insert::@3->bram_heap_set_free]
    // [701] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#1 [phi:bram_heap_free_insert::@3->bram_heap_set_free#0] -- call_phi_near 
    jsr bram_heap_set_free
    // bram_heap_free_insert::@4
    // bram_heap_segment.freeCount[s]++;
    // [428] bram_heap_free_insert::$6 = bram_heap_free_insert::s#0 << 1 -- vbuaa=vbum1_rol_1 
    lda s
    asl
    // [429] ((unsigned int *)&bram_heap_segment+$46)[bram_heap_free_insert::$6] = ++ ((unsigned int *)&bram_heap_segment+$46)[bram_heap_free_insert::$6] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc bram_heap_segment+$46,x
    bne !+
    inc bram_heap_segment+$46+1,x
  !:
    // bram_heap_free_insert::@return
    // }
    // [430] return 
    rts
  .segment Data
    s: .byte 0
    free_index: .byte 0
    .label data = printf_string.str
    size: .word 0
}
.segment CodeBramHeap
  // bram_heap_can_coalesce_left
/**
 * Whether we should merge this header to the left.
 */
// __mem() char bram_heap_can_coalesce_left(char s, __register(Y) char heap_index)
bram_heap_can_coalesce_left: {
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [431] bram_heap_get_data_packed::index#4 = bram_heap_can_coalesce_left::heap_index#0 -- vbuxx=vbuyy 
    tya
    tax
    // [432] call bram_heap_get_data_packed
    // [279] phi from bram_heap_can_coalesce_left to bram_heap_get_data_packed [phi:bram_heap_can_coalesce_left->bram_heap_get_data_packed]
    // [279] phi bram_heap_get_data_packed::index#9 = bram_heap_get_data_packed::index#4 [phi:bram_heap_can_coalesce_left->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [433] bram_heap_get_data_packed::return#16 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_6
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_6+1
    // bram_heap_can_coalesce_left::@6
    // [434] bram_heap_can_coalesce_left::heap_offset#0 = bram_heap_get_data_packed::return#16 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_6
    sta heap_offset
    lda bram_heap_get_data_packed.return_6+1
    sta heap_offset+1
    // bram_heap_can_coalesce_left::bram_heap_get_left1
    // return bram_heap_index.left[index];
    // [435] bram_heap_can_coalesce_left::left_index#0 = ((char *)&bram_heap_index+$700)[bram_heap_can_coalesce_left::heap_index#0] -- vbum1=pbuc1_derefidx_vbuyy 
    lda bram_heap_index+$700,y
    sta left_index
    // bram_heap_can_coalesce_left::@5
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [436] bram_heap_get_data_packed::index#5 = bram_heap_can_coalesce_left::left_index#0 -- vbuxx=vbum1 
    tax
    // [437] call bram_heap_get_data_packed
    // [279] phi from bram_heap_can_coalesce_left::@5 to bram_heap_get_data_packed [phi:bram_heap_can_coalesce_left::@5->bram_heap_get_data_packed]
    // [279] phi bram_heap_get_data_packed::index#9 = bram_heap_get_data_packed::index#5 [phi:bram_heap_can_coalesce_left::@5->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [438] bram_heap_get_data_packed::return#17 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_7
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_7+1
    // bram_heap_can_coalesce_left::@7
    // [439] bram_heap_can_coalesce_left::left_offset#0 = bram_heap_get_data_packed::return#17 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_7
    sta left_offset
    lda bram_heap_get_data_packed.return_7+1
    sta left_offset+1
    // bool left_free = bram_heap_is_free(s, left_index)
    // [440] bram_heap_is_free::index#0 = bram_heap_can_coalesce_left::left_index#0 -- vbuxx=vbum1 
    ldx left_index
    // [441] call bram_heap_is_free
    // [946] phi from bram_heap_can_coalesce_left::@7 to bram_heap_is_free [phi:bram_heap_can_coalesce_left::@7->bram_heap_is_free]
    // [946] phi bram_heap_is_free::index#3 = bram_heap_is_free::index#0 [phi:bram_heap_can_coalesce_left::@7->bram_heap_is_free#0] -- call_phi_near 
    jsr bram_heap_is_free
    // bool left_free = bram_heap_is_free(s, left_index)
    // [442] bram_heap_is_free::return#2 = bram_heap_is_free::return#0
    // bram_heap_can_coalesce_left::@8
    // [443] bram_heap_can_coalesce_left::left_free#0 = bram_heap_is_free::return#2 -- vboxx=vboaa 
    tax
    // if(left_free && (left_offset < heap_offset))
    // [444] if(bram_heap_can_coalesce_left::left_free#0) goto bram_heap_can_coalesce_left::@18 -- vboxx_then_la1 
    cpx #0
    bne __b18
    // [446] phi from bram_heap_can_coalesce_left::@18 bram_heap_can_coalesce_left::@8 to bram_heap_can_coalesce_left::@1 [phi:bram_heap_can_coalesce_left::@18/bram_heap_can_coalesce_left::@8->bram_heap_can_coalesce_left::@1]
    jmp __b1
    // bram_heap_can_coalesce_left::@18
  __b18:
    // if(left_free && (left_offset < heap_offset))
    // [445] if(bram_heap_can_coalesce_left::left_offset#0<bram_heap_can_coalesce_left::heap_offset#0) goto bram_heap_can_coalesce_left::@2 -- vwum1_lt_vwum2_then_la1 
    lda left_offset+1
    cmp heap_offset+1
    bcc __b2
    bne !+
    lda left_offset
    cmp heap_offset
    bcc __b2
  !:
    // bram_heap_can_coalesce_left::@1
  __b1:
    // printf("\n > Cannot coalesce to the left.")
    // [447] call printf_str
    // [380] phi from bram_heap_can_coalesce_left::@1 to printf_str [phi:bram_heap_can_coalesce_left::@1->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_can_coalesce_left::s1 [phi:bram_heap_can_coalesce_left::@1->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // [448] phi from bram_heap_can_coalesce_left::@1 to bram_heap_can_coalesce_left::@return [phi:bram_heap_can_coalesce_left::@1->bram_heap_can_coalesce_left::@return]
    // [448] phi bram_heap_can_coalesce_left::return#3 = $ff [phi:bram_heap_can_coalesce_left::@1->bram_heap_can_coalesce_left::@return#0] -- vbum1=vbuc1 
    lda #$ff
    sta return
    // bram_heap_can_coalesce_left::@return
    // }
    // [449] return 
    rts
    // bram_heap_can_coalesce_left::@2
  __b2:
    // left_free?"true":"false"
    // [450] if(bram_heap_can_coalesce_left::left_free#0) goto bram_heap_can_coalesce_left::@3 -- vboxx_then_la1 
    cpx #0
    bne __b3
    // [452] phi from bram_heap_can_coalesce_left::@2 to bram_heap_can_coalesce_left::@4 [phi:bram_heap_can_coalesce_left::@2->bram_heap_can_coalesce_left::@4]
    // [452] phi printf_string::str#0 = string_1 [phi:bram_heap_can_coalesce_left::@2->bram_heap_can_coalesce_left::@4#0] -- pbum1=pbuc1 
    lda #<string_1
    sta printf_string.str
    lda #>string_1
    sta printf_string.str+1
    jmp __b4
    // [451] phi from bram_heap_can_coalesce_left::@2 to bram_heap_can_coalesce_left::@3 [phi:bram_heap_can_coalesce_left::@2->bram_heap_can_coalesce_left::@3]
    // bram_heap_can_coalesce_left::@3
  __b3:
    // left_free?"true":"false"
    // [452] phi from bram_heap_can_coalesce_left::@3 to bram_heap_can_coalesce_left::@4 [phi:bram_heap_can_coalesce_left::@3->bram_heap_can_coalesce_left::@4]
    // [452] phi printf_string::str#0 = string_0 [phi:bram_heap_can_coalesce_left::@3->bram_heap_can_coalesce_left::@4#0] -- pbum1=pbuc1 
    lda #<string_0
    sta printf_string.str
    lda #>string_0
    sta printf_string.str+1
    // bram_heap_can_coalesce_left::@4
  __b4:
    // printf("\n > Left index %02x is free %s with offset %04x\n", left_index, left_free?"true":"false", left_offset)
    // [453] call printf_str
    // [380] phi from bram_heap_can_coalesce_left::@4 to printf_str [phi:bram_heap_can_coalesce_left::@4->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_can_coalesce_left::s2 [phi:bram_heap_can_coalesce_left::@4->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_can_coalesce_left::@9
    // printf("\n > Left index %02x is free %s with offset %04x\n", left_index, left_free?"true":"false", left_offset)
    // [454] printf_uchar::uvalue#12 = bram_heap_can_coalesce_left::left_index#0 -- vbum1=vbum2 
    lda left_index
    sta printf_uchar.uvalue
    // [455] call printf_uchar
    // [389] phi from bram_heap_can_coalesce_left::@9 to printf_uchar [phi:bram_heap_can_coalesce_left::@9->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 2 [phi:bram_heap_can_coalesce_left::@9->printf_uchar#0] -- vbum1=vbuc1 
    lda #2
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#12 [phi:bram_heap_can_coalesce_left::@9->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [456] phi from bram_heap_can_coalesce_left::@9 to bram_heap_can_coalesce_left::@10 [phi:bram_heap_can_coalesce_left::@9->bram_heap_can_coalesce_left::@10]
    // bram_heap_can_coalesce_left::@10
    // printf("\n > Left index %02x is free %s with offset %04x\n", left_index, left_free?"true":"false", left_offset)
    // [457] call printf_str
    // [380] phi from bram_heap_can_coalesce_left::@10 to printf_str [phi:bram_heap_can_coalesce_left::@10->printf_str]
    // [380] phi printf_str::s#69 = string_2 [phi:bram_heap_can_coalesce_left::@10->printf_str#0] -- call_phi_near 
    lda #<string_2
    sta printf_str.s
    lda #>string_2
    sta printf_str.s+1
    jsr printf_str
    // [458] phi from bram_heap_can_coalesce_left::@10 to bram_heap_can_coalesce_left::@11 [phi:bram_heap_can_coalesce_left::@10->bram_heap_can_coalesce_left::@11]
    // bram_heap_can_coalesce_left::@11
    // printf("\n > Left index %02x is free %s with offset %04x\n", left_index, left_free?"true":"false", left_offset)
    // [459] call printf_string
    // [950] phi from bram_heap_can_coalesce_left::@11 to printf_string [phi:bram_heap_can_coalesce_left::@11->printf_string]
    // [950] phi printf_string::str#2 = printf_string::str#0 [phi:bram_heap_can_coalesce_left::@11->printf_string#0] -- call_phi_near 
    jsr printf_string
    // [460] phi from bram_heap_can_coalesce_left::@11 to bram_heap_can_coalesce_left::@12 [phi:bram_heap_can_coalesce_left::@11->bram_heap_can_coalesce_left::@12]
    // bram_heap_can_coalesce_left::@12
    // printf("\n > Left index %02x is free %s with offset %04x\n", left_index, left_free?"true":"false", left_offset)
    // [461] call printf_str
    // [380] phi from bram_heap_can_coalesce_left::@12 to printf_str [phi:bram_heap_can_coalesce_left::@12->printf_str]
    // [380] phi printf_str::s#69 = string_3 [phi:bram_heap_can_coalesce_left::@12->printf_str#0] -- call_phi_near 
    lda #<string_3
    sta printf_str.s
    lda #>string_3
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_can_coalesce_left::@13
    // printf("\n > Left index %02x is free %s with offset %04x\n", left_index, left_free?"true":"false", left_offset)
    // [462] printf_uint::uvalue#3 = bram_heap_can_coalesce_left::left_offset#0 -- vwum1=vwum2 
    lda left_offset
    sta printf_uint.uvalue
    lda left_offset+1
    sta printf_uint.uvalue+1
    // [463] call printf_uint
    // [769] phi from bram_heap_can_coalesce_left::@13 to printf_uint [phi:bram_heap_can_coalesce_left::@13->printf_uint]
    // [769] phi printf_uint::format_radix#10 = HEXADECIMAL [phi:bram_heap_can_coalesce_left::@13->printf_uint#0] -- vbuxx=vbuc1 
    ldx #HEXADECIMAL
    // [769] phi printf_uint::uvalue#6 = printf_uint::uvalue#3 [phi:bram_heap_can_coalesce_left::@13->printf_uint#1] -- call_phi_near 
    jsr printf_uint
    // [464] phi from bram_heap_can_coalesce_left::@13 to bram_heap_can_coalesce_left::@14 [phi:bram_heap_can_coalesce_left::@13->bram_heap_can_coalesce_left::@14]
    // bram_heap_can_coalesce_left::@14
    // printf("\n > Left index %02x is free %s with offset %04x\n", left_index, left_free?"true":"false", left_offset)
    // [465] call printf_str
    // [380] phi from bram_heap_can_coalesce_left::@14 to printf_str [phi:bram_heap_can_coalesce_left::@14->printf_str]
    // [380] phi printf_str::s#69 = s4 [phi:bram_heap_can_coalesce_left::@14->printf_str#0] -- call_phi_near 
    lda #<s4
    sta printf_str.s
    lda #>s4
    sta printf_str.s+1
    jsr printf_str
    // [466] phi from bram_heap_can_coalesce_left::@14 to bram_heap_can_coalesce_left::@15 [phi:bram_heap_can_coalesce_left::@14->bram_heap_can_coalesce_left::@15]
    // bram_heap_can_coalesce_left::@15
    // printf("\n > Can coalesce to the left with free index %03x.", left_index)
    // [467] call printf_str
    // [380] phi from bram_heap_can_coalesce_left::@15 to printf_str [phi:bram_heap_can_coalesce_left::@15->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_can_coalesce_left::s6 [phi:bram_heap_can_coalesce_left::@15->printf_str#0] -- call_phi_near 
    lda #<s6
    sta printf_str.s
    lda #>s6
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_can_coalesce_left::@16
    // printf("\n > Can coalesce to the left with free index %03x.", left_index)
    // [468] printf_uchar::uvalue#13 = bram_heap_can_coalesce_left::left_index#0 -- vbum1=vbum2 
    lda left_index
    sta printf_uchar.uvalue
    // [469] call printf_uchar
    // [389] phi from bram_heap_can_coalesce_left::@16 to printf_uchar [phi:bram_heap_can_coalesce_left::@16->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_can_coalesce_left::@16->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#13 [phi:bram_heap_can_coalesce_left::@16->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [470] phi from bram_heap_can_coalesce_left::@16 to bram_heap_can_coalesce_left::@17 [phi:bram_heap_can_coalesce_left::@16->bram_heap_can_coalesce_left::@17]
    // bram_heap_can_coalesce_left::@17
    // printf("\n > Can coalesce to the left with free index %03x.", left_index)
    // [471] call printf_str
    // [380] phi from bram_heap_can_coalesce_left::@17 to printf_str [phi:bram_heap_can_coalesce_left::@17->printf_str]
    // [380] phi printf_str::s#69 = s3 [phi:bram_heap_can_coalesce_left::@17->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // [448] phi from bram_heap_can_coalesce_left::@17 to bram_heap_can_coalesce_left::@return [phi:bram_heap_can_coalesce_left::@17->bram_heap_can_coalesce_left::@return]
    // [448] phi bram_heap_can_coalesce_left::return#3 = bram_heap_can_coalesce_left::left_index#0 [phi:bram_heap_can_coalesce_left::@17->bram_heap_can_coalesce_left::@return#0] -- register_copy 
    rts
  .segment DataBramHeap
    s1: .text @"\n > Cannot coalesce to the left."
    .byte 0
    s2: .text @"\n > Left index "
    .byte 0
    s6: .text @"\n > Can coalesce to the left with free index "
    .byte 0
    .label heap_offset = printf_string.str
    .label left_index = return
    left_offset: .word 0
  .segment Data
    return: .byte 0
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
    // [473] bram_heap_get_size_packed::index#6 = bram_heap_coalesce::right_index#10 -- vbuxx=vbum1 
    ldx right_index
    // [474] call bram_heap_get_size_packed
    // [275] phi from bram_heap_coalesce to bram_heap_get_size_packed [phi:bram_heap_coalesce->bram_heap_get_size_packed]
    // [275] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#6 [phi:bram_heap_coalesce->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t right_size = bram_heap_get_size_packed(s, right_index)
    // [475] bram_heap_get_size_packed::return#16 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return_6
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return_6+1
    // bram_heap_coalesce::@3
    // [476] bram_heap_coalesce::right_size#0 = bram_heap_get_size_packed::return#16 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_6
    sta right_size
    lda bram_heap_get_size_packed.return_6+1
    sta right_size+1
    // bram_heap_size_packed_t left_size = bram_heap_get_size_packed(s, left_index)
    // [477] bram_heap_get_size_packed::index#7 = bram_heap_coalesce::left_index#10 -- vbuxx=vbum1 
    ldx left_index
    // [478] call bram_heap_get_size_packed
    // [275] phi from bram_heap_coalesce::@3 to bram_heap_get_size_packed [phi:bram_heap_coalesce::@3->bram_heap_get_size_packed]
    // [275] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#7 [phi:bram_heap_coalesce::@3->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t left_size = bram_heap_get_size_packed(s, left_index)
    // [479] bram_heap_get_size_packed::return#17 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return_7
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return_7+1
    // bram_heap_coalesce::@4
    // [480] bram_heap_coalesce::left_size#0 = bram_heap_get_size_packed::return#17 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_7
    sta left_size
    lda bram_heap_get_size_packed.return_7+1
    sta left_size+1
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [481] bram_heap_get_data_packed::index#8 = bram_heap_coalesce::left_index#10 -- vbuxx=vbum1 
    ldx left_index
    // [482] call bram_heap_get_data_packed
    // [279] phi from bram_heap_coalesce::@4 to bram_heap_get_data_packed [phi:bram_heap_coalesce::@4->bram_heap_get_data_packed]
    // [279] phi bram_heap_get_data_packed::index#9 = bram_heap_get_data_packed::index#8 [phi:bram_heap_coalesce::@4->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [483] bram_heap_get_data_packed::return#10 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_2
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_2+1
    // bram_heap_coalesce::@5
    // [484] bram_heap_coalesce::left_offset#0 = bram_heap_get_data_packed::return#10 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_2
    sta left_offset
    lda bram_heap_get_data_packed.return_2+1
    sta left_offset+1
    // bram_heap_coalesce::bram_heap_get_left1
    // return bram_heap_index.left[index];
    // [485] bram_heap_coalesce::free_left#0 = ((char *)&bram_heap_index+$700)[bram_heap_coalesce::left_index#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy left_index
    lda bram_heap_index+$700,y
    sta free_left
    // bram_heap_coalesce::bram_heap_get_right1
    // return bram_heap_index.right[index];
    // [486] bram_heap_coalesce::free_right#0 = ((char *)&bram_heap_index+$600)[bram_heap_coalesce::right_index#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy right_index
    lda bram_heap_index+$600,y
    sta free_right
    // bram_heap_coalesce::@1
    // bram_heap_free_remove(s, left_index)
    // [487] bram_heap_free_remove::s#1 = bram_heap_coalesce::s#10 -- vbum1=vbum2 
    lda s
    sta bram_heap_free_remove.s
    // [488] bram_heap_free_remove::free_index#1 = bram_heap_coalesce::left_index#10 -- vbum1=vbum2 
    lda left_index
    sta bram_heap_free_remove.free_index
    // [489] call bram_heap_free_remove
  // We detach the left index from the free list and add it to the idle list.
    // [954] phi from bram_heap_coalesce::@1 to bram_heap_free_remove [phi:bram_heap_coalesce::@1->bram_heap_free_remove]
    // [954] phi bram_heap_free_remove::free_index#2 = bram_heap_free_remove::free_index#1 [phi:bram_heap_coalesce::@1->bram_heap_free_remove#0] -- register_copy 
    // [954] phi bram_heap_free_remove::s#2 = bram_heap_free_remove::s#1 [phi:bram_heap_coalesce::@1->bram_heap_free_remove#1] -- call_phi_near 
    jsr bram_heap_free_remove
    // bram_heap_coalesce::@6
    // bram_heap_idle_insert(s, left_index)
    // [490] bram_heap_idle_insert::s#0 = bram_heap_coalesce::s#10 -- vbum1=vbum2 
    lda s
    sta bram_heap_idle_insert.s
    // [491] bram_heap_idle_insert::idle_index#0 = bram_heap_coalesce::left_index#10 -- vbum1=vbum2 
    lda left_index
    sta bram_heap_idle_insert.idle_index
    // [492] call bram_heap_idle_insert -- call_phi_near 
    jsr bram_heap_idle_insert
    // bram_heap_coalesce::bram_heap_set_left1
    // bram_heap_index.left[index] = left
    // [493] ((char *)&bram_heap_index+$700)[bram_heap_coalesce::right_index#10] = bram_heap_coalesce::free_left#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_left
    ldy right_index
    sta bram_heap_index+$700,y
    // bram_heap_coalesce::bram_heap_set_right1
    // bram_heap_index.right[index] = right
    // [494] ((char *)&bram_heap_index+$600)[bram_heap_coalesce::right_index#10] = bram_heap_coalesce::free_right#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_right
    sta bram_heap_index+$600,y
    // bram_heap_coalesce::bram_heap_set_left2
    // bram_heap_index.left[index] = left
    // [495] ((char *)&bram_heap_index+$700)[bram_heap_coalesce::free_right#0] = bram_heap_coalesce::right_index#10 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy free_right
    sta bram_heap_index+$700,y
    // bram_heap_coalesce::bram_heap_set_right2
    // bram_heap_index.right[index] = right
    // [496] ((char *)&bram_heap_index+$600)[bram_heap_coalesce::free_left#0] = bram_heap_coalesce::right_index#10 -- pbuc1_derefidx_vbum1=vbum2 
    ldy free_left
    sta bram_heap_index+$600,y
    // bram_heap_coalesce::bram_heap_set_left3
    // bram_heap_index.left[index] = left
    // [497] ((char *)&bram_heap_index+$700)[bram_heap_coalesce::left_index#10] = bram_heap_coalesce::bram_heap_set_left3_left#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #bram_heap_set_left3_left
    ldy left_index
    sta bram_heap_index+$700,y
    // bram_heap_coalesce::bram_heap_set_right3
    // bram_heap_index.right[index] = right
    // [498] ((char *)&bram_heap_index+$600)[bram_heap_coalesce::left_index#10] = bram_heap_coalesce::bram_heap_set_right3_right#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #bram_heap_set_right3_right
    sta bram_heap_index+$600,y
    // bram_heap_coalesce::@2
    // bram_heap_set_size_packed(s, right_index, left_size + right_size)
    // [499] bram_heap_set_size_packed::size_packed#5 = bram_heap_coalesce::left_size#0 + bram_heap_coalesce::right_size#0 -- vwum1=vwum2_plus_vwum3 
    lda left_size
    clc
    adc right_size
    sta bram_heap_set_size_packed.size_packed
    lda left_size+1
    adc right_size+1
    sta bram_heap_set_size_packed.size_packed+1
    // [500] bram_heap_set_size_packed::index#5 = bram_heap_coalesce::right_index#10 -- vbuxx=vbum1 
    ldx right_index
    // [501] call bram_heap_set_size_packed
    // [692] phi from bram_heap_coalesce::@2 to bram_heap_set_size_packed [phi:bram_heap_coalesce::@2->bram_heap_set_size_packed]
    // [692] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#5 [phi:bram_heap_coalesce::@2->bram_heap_set_size_packed#0] -- register_copy 
    // [692] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#5 [phi:bram_heap_coalesce::@2->bram_heap_set_size_packed#1] -- call_phi_near 
    jsr bram_heap_set_size_packed
    // bram_heap_coalesce::@7
    // bram_heap_set_data_packed(s, right_index, left_offset)
    // [502] bram_heap_set_data_packed::index#6 = bram_heap_coalesce::right_index#10 -- vbuxx=vbum1 
    ldx right_index
    // [503] bram_heap_set_data_packed::data_packed#6 = bram_heap_coalesce::left_offset#0 -- vwum1=vwum2 
    lda left_offset
    sta bram_heap_set_data_packed.data_packed
    lda left_offset+1
    sta bram_heap_set_data_packed.data_packed+1
    // [504] call bram_heap_set_data_packed
    // [686] phi from bram_heap_coalesce::@7 to bram_heap_set_data_packed [phi:bram_heap_coalesce::@7->bram_heap_set_data_packed]
    // [686] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#6 [phi:bram_heap_coalesce::@7->bram_heap_set_data_packed#0] -- register_copy 
    // [686] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#6 [phi:bram_heap_coalesce::@7->bram_heap_set_data_packed#1] -- call_phi_near 
    jsr bram_heap_set_data_packed
    // bram_heap_coalesce::@8
    // bram_heap_set_free(s, left_index)
    // [505] bram_heap_set_free::index#3 = bram_heap_coalesce::left_index#10 -- vbuxx=vbum1 
    ldx left_index
    // [506] call bram_heap_set_free
    // [701] phi from bram_heap_coalesce::@8 to bram_heap_set_free [phi:bram_heap_coalesce::@8->bram_heap_set_free]
    // [701] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#3 [phi:bram_heap_coalesce::@8->bram_heap_set_free#0] -- call_phi_near 
    jsr bram_heap_set_free
    // bram_heap_coalesce::@9
    // bram_heap_set_free(s, right_index)
    // [507] bram_heap_set_free::index#4 = bram_heap_coalesce::right_index#10 -- vbuxx=vbum1 
    ldx right_index
    // [508] call bram_heap_set_free
    // [701] phi from bram_heap_coalesce::@9 to bram_heap_set_free [phi:bram_heap_coalesce::@9->bram_heap_set_free]
    // [701] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#4 [phi:bram_heap_coalesce::@9->bram_heap_set_free#0] -- call_phi_near 
    jsr bram_heap_set_free
    // [509] phi from bram_heap_coalesce::@9 to bram_heap_coalesce::@10 [phi:bram_heap_coalesce::@9->bram_heap_coalesce::@10]
    // bram_heap_coalesce::@10
    // printf("\n > Coalesce idling index %03x and expanding free index %03x.", left_index, right_index)
    // [510] call printf_str
    // [380] phi from bram_heap_coalesce::@10 to printf_str [phi:bram_heap_coalesce::@10->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_coalesce::s1 [phi:bram_heap_coalesce::@10->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_coalesce::@11
    // printf("\n > Coalesce idling index %03x and expanding free index %03x.", left_index, right_index)
    // [511] printf_uchar::uvalue#16 = bram_heap_coalesce::left_index#10 -- vbum1=vbum2 
    lda left_index
    sta printf_uchar.uvalue
    // [512] call printf_uchar
    // [389] phi from bram_heap_coalesce::@11 to printf_uchar [phi:bram_heap_coalesce::@11->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_coalesce::@11->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#16 [phi:bram_heap_coalesce::@11->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [513] phi from bram_heap_coalesce::@11 to bram_heap_coalesce::@12 [phi:bram_heap_coalesce::@11->bram_heap_coalesce::@12]
    // bram_heap_coalesce::@12
    // printf("\n > Coalesce idling index %03x and expanding free index %03x.", left_index, right_index)
    // [514] call printf_str
    // [380] phi from bram_heap_coalesce::@12 to printf_str [phi:bram_heap_coalesce::@12->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_coalesce::s2 [phi:bram_heap_coalesce::@12->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_coalesce::@13
    // printf("\n > Coalesce idling index %03x and expanding free index %03x.", left_index, right_index)
    // [515] printf_uchar::uvalue#17 = bram_heap_coalesce::right_index#10 -- vbum1=vbum2 
    lda right_index
    sta printf_uchar.uvalue
    // [516] call printf_uchar
    // [389] phi from bram_heap_coalesce::@13 to printf_uchar [phi:bram_heap_coalesce::@13->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_coalesce::@13->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#17 [phi:bram_heap_coalesce::@13->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [517] phi from bram_heap_coalesce::@13 to bram_heap_coalesce::@14 [phi:bram_heap_coalesce::@13->bram_heap_coalesce::@14]
    // bram_heap_coalesce::@14
    // printf("\n > Coalesce idling index %03x and expanding free index %03x.", left_index, right_index)
    // [518] call printf_str
    // [380] phi from bram_heap_coalesce::@14 to printf_str [phi:bram_heap_coalesce::@14->printf_str]
    // [380] phi printf_str::s#69 = s3 [phi:bram_heap_coalesce::@14->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_coalesce::@return
    // }
    // [519] return 
    rts
  .segment DataBramHeap
    s1: .text @"\n > Coalesce idling index "
    .byte 0
    s2: .text " and expanding free index "
    .byte 0
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
    // [520] bram_heap_get_data_packed::index#6 = heap_can_coalesce_right::heap_index#0 -- vbuxx=vbum1 
    ldx heap_index
    // [521] call bram_heap_get_data_packed
    // [279] phi from heap_can_coalesce_right to bram_heap_get_data_packed [phi:heap_can_coalesce_right->bram_heap_get_data_packed]
    // [279] phi bram_heap_get_data_packed::index#9 = bram_heap_get_data_packed::index#6 [phi:heap_can_coalesce_right->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [522] bram_heap_get_data_packed::return#18 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_8
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_8+1
    // heap_can_coalesce_right::@6
    // [523] heap_can_coalesce_right::heap_offset#0 = bram_heap_get_data_packed::return#18 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_8
    sta heap_offset
    lda bram_heap_get_data_packed.return_8+1
    sta heap_offset+1
    // heap_can_coalesce_right::bram_heap_get_right1
    // return bram_heap_index.right[index];
    // [524] heap_can_coalesce_right::right_index#0 = ((char *)&bram_heap_index+$600)[heap_can_coalesce_right::heap_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy heap_index
    lda bram_heap_index+$600,y
    sta right_index
    // heap_can_coalesce_right::@5
    // bram_heap_data_packed_t right_offset = bram_heap_get_data_packed(s, right_index)
    // [525] bram_heap_get_data_packed::index#7 = heap_can_coalesce_right::right_index#0 -- vbuxx=vbum1 
    tax
    // [526] call bram_heap_get_data_packed
    // [279] phi from heap_can_coalesce_right::@5 to bram_heap_get_data_packed [phi:heap_can_coalesce_right::@5->bram_heap_get_data_packed]
    // [279] phi bram_heap_get_data_packed::index#9 = bram_heap_get_data_packed::index#7 [phi:heap_can_coalesce_right::@5->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t right_offset = bram_heap_get_data_packed(s, right_index)
    // [527] bram_heap_get_data_packed::return#19 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_9
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_9+1
    // heap_can_coalesce_right::@7
    // [528] heap_can_coalesce_right::right_offset#0 = bram_heap_get_data_packed::return#19 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_9
    sta right_offset
    lda bram_heap_get_data_packed.return_9+1
    sta right_offset+1
    // bool right_free = bram_heap_is_free(s, right_index)
    // [529] bram_heap_is_free::index#1 = heap_can_coalesce_right::right_index#0 -- vbuxx=vbum1 
    ldx right_index
    // [530] call bram_heap_is_free
    // [946] phi from heap_can_coalesce_right::@7 to bram_heap_is_free [phi:heap_can_coalesce_right::@7->bram_heap_is_free]
    // [946] phi bram_heap_is_free::index#3 = bram_heap_is_free::index#1 [phi:heap_can_coalesce_right::@7->bram_heap_is_free#0] -- call_phi_near 
    jsr bram_heap_is_free
    // bool right_free = bram_heap_is_free(s, right_index)
    // [531] bram_heap_is_free::return#3 = bram_heap_is_free::return#0
    // heap_can_coalesce_right::@8
    // [532] heap_can_coalesce_right::right_free#0 = bram_heap_is_free::return#3 -- vboxx=vboaa 
    tax
    // if(right_free && (heap_offset < right_offset))
    // [533] if(heap_can_coalesce_right::right_free#0) goto heap_can_coalesce_right::@18 -- vboxx_then_la1 
    cpx #0
    bne __b18
    // [535] phi from heap_can_coalesce_right::@18 heap_can_coalesce_right::@8 to heap_can_coalesce_right::@1 [phi:heap_can_coalesce_right::@18/heap_can_coalesce_right::@8->heap_can_coalesce_right::@1]
    jmp __b1
    // heap_can_coalesce_right::@18
  __b18:
    // if(right_free && (heap_offset < right_offset))
    // [534] if(heap_can_coalesce_right::heap_offset#0<heap_can_coalesce_right::right_offset#0) goto heap_can_coalesce_right::@2 -- vwum1_lt_vwum2_then_la1 
    lda heap_offset+1
    cmp right_offset+1
    bcc __b2
    bne !+
    lda heap_offset
    cmp right_offset
    bcc __b2
  !:
    // heap_can_coalesce_right::@1
  __b1:
    // printf("\n > Cannot coalesce to the right.")
    // [536] call printf_str
    // [380] phi from heap_can_coalesce_right::@1 to printf_str [phi:heap_can_coalesce_right::@1->printf_str]
    // [380] phi printf_str::s#69 = heap_can_coalesce_right::s1 [phi:heap_can_coalesce_right::@1->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // [537] phi from heap_can_coalesce_right::@1 to heap_can_coalesce_right::@return [phi:heap_can_coalesce_right::@1->heap_can_coalesce_right::@return]
    // [537] phi heap_can_coalesce_right::return#3 = $ff [phi:heap_can_coalesce_right::@1->heap_can_coalesce_right::@return#0] -- vbum1=vbuc1 
    lda #$ff
    sta return
    // heap_can_coalesce_right::@return
    // }
    // [538] return 
    rts
    // heap_can_coalesce_right::@2
  __b2:
    // right_free?"true":"false"
    // [539] if(heap_can_coalesce_right::right_free#0) goto heap_can_coalesce_right::@3 -- vboxx_then_la1 
    cpx #0
    bne __b3
    // [541] phi from heap_can_coalesce_right::@2 to heap_can_coalesce_right::@4 [phi:heap_can_coalesce_right::@2->heap_can_coalesce_right::@4]
    // [541] phi printf_string::str#1 = string_1 [phi:heap_can_coalesce_right::@2->heap_can_coalesce_right::@4#0] -- pbum1=pbuc1 
    lda #<string_1
    sta printf_string.str
    lda #>string_1
    sta printf_string.str+1
    jmp __b4
    // [540] phi from heap_can_coalesce_right::@2 to heap_can_coalesce_right::@3 [phi:heap_can_coalesce_right::@2->heap_can_coalesce_right::@3]
    // heap_can_coalesce_right::@3
  __b3:
    // right_free?"true":"false"
    // [541] phi from heap_can_coalesce_right::@3 to heap_can_coalesce_right::@4 [phi:heap_can_coalesce_right::@3->heap_can_coalesce_right::@4]
    // [541] phi printf_string::str#1 = string_0 [phi:heap_can_coalesce_right::@3->heap_can_coalesce_right::@4#0] -- pbum1=pbuc1 
    lda #<string_0
    sta printf_string.str
    lda #>string_0
    sta printf_string.str+1
    // heap_can_coalesce_right::@4
  __b4:
    // printf("\n > Right index %02x is free %s with offset %04x\n", right_index, right_free?"true":"false", right_offset)
    // [542] call printf_str
    // [380] phi from heap_can_coalesce_right::@4 to printf_str [phi:heap_can_coalesce_right::@4->printf_str]
    // [380] phi printf_str::s#69 = heap_can_coalesce_right::s2 [phi:heap_can_coalesce_right::@4->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // heap_can_coalesce_right::@9
    // printf("\n > Right index %02x is free %s with offset %04x\n", right_index, right_free?"true":"false", right_offset)
    // [543] printf_uchar::uvalue#14 = heap_can_coalesce_right::right_index#0 -- vbum1=vbum2 
    lda right_index
    sta printf_uchar.uvalue
    // [544] call printf_uchar
    // [389] phi from heap_can_coalesce_right::@9 to printf_uchar [phi:heap_can_coalesce_right::@9->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 2 [phi:heap_can_coalesce_right::@9->printf_uchar#0] -- vbum1=vbuc1 
    lda #2
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#14 [phi:heap_can_coalesce_right::@9->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [545] phi from heap_can_coalesce_right::@9 to heap_can_coalesce_right::@10 [phi:heap_can_coalesce_right::@9->heap_can_coalesce_right::@10]
    // heap_can_coalesce_right::@10
    // printf("\n > Right index %02x is free %s with offset %04x\n", right_index, right_free?"true":"false", right_offset)
    // [546] call printf_str
    // [380] phi from heap_can_coalesce_right::@10 to printf_str [phi:heap_can_coalesce_right::@10->printf_str]
    // [380] phi printf_str::s#69 = string_2 [phi:heap_can_coalesce_right::@10->printf_str#0] -- call_phi_near 
    lda #<string_2
    sta printf_str.s
    lda #>string_2
    sta printf_str.s+1
    jsr printf_str
    // [547] phi from heap_can_coalesce_right::@10 to heap_can_coalesce_right::@11 [phi:heap_can_coalesce_right::@10->heap_can_coalesce_right::@11]
    // heap_can_coalesce_right::@11
    // printf("\n > Right index %02x is free %s with offset %04x\n", right_index, right_free?"true":"false", right_offset)
    // [548] call printf_string
    // [950] phi from heap_can_coalesce_right::@11 to printf_string [phi:heap_can_coalesce_right::@11->printf_string]
    // [950] phi printf_string::str#2 = printf_string::str#1 [phi:heap_can_coalesce_right::@11->printf_string#0] -- call_phi_near 
    jsr printf_string
    // [549] phi from heap_can_coalesce_right::@11 to heap_can_coalesce_right::@12 [phi:heap_can_coalesce_right::@11->heap_can_coalesce_right::@12]
    // heap_can_coalesce_right::@12
    // printf("\n > Right index %02x is free %s with offset %04x\n", right_index, right_free?"true":"false", right_offset)
    // [550] call printf_str
    // [380] phi from heap_can_coalesce_right::@12 to printf_str [phi:heap_can_coalesce_right::@12->printf_str]
    // [380] phi printf_str::s#69 = string_3 [phi:heap_can_coalesce_right::@12->printf_str#0] -- call_phi_near 
    lda #<string_3
    sta printf_str.s
    lda #>string_3
    sta printf_str.s+1
    jsr printf_str
    // heap_can_coalesce_right::@13
    // printf("\n > Right index %02x is free %s with offset %04x\n", right_index, right_free?"true":"false", right_offset)
    // [551] printf_uint::uvalue#4 = heap_can_coalesce_right::right_offset#0 -- vwum1=vwum2 
    lda right_offset
    sta printf_uint.uvalue
    lda right_offset+1
    sta printf_uint.uvalue+1
    // [552] call printf_uint
    // [769] phi from heap_can_coalesce_right::@13 to printf_uint [phi:heap_can_coalesce_right::@13->printf_uint]
    // [769] phi printf_uint::format_radix#10 = HEXADECIMAL [phi:heap_can_coalesce_right::@13->printf_uint#0] -- vbuxx=vbuc1 
    ldx #HEXADECIMAL
    // [769] phi printf_uint::uvalue#6 = printf_uint::uvalue#4 [phi:heap_can_coalesce_right::@13->printf_uint#1] -- call_phi_near 
    jsr printf_uint
    // [553] phi from heap_can_coalesce_right::@13 to heap_can_coalesce_right::@14 [phi:heap_can_coalesce_right::@13->heap_can_coalesce_right::@14]
    // heap_can_coalesce_right::@14
    // printf("\n > Right index %02x is free %s with offset %04x\n", right_index, right_free?"true":"false", right_offset)
    // [554] call printf_str
    // [380] phi from heap_can_coalesce_right::@14 to printf_str [phi:heap_can_coalesce_right::@14->printf_str]
    // [380] phi printf_str::s#69 = s4 [phi:heap_can_coalesce_right::@14->printf_str#0] -- call_phi_near 
    lda #<s4
    sta printf_str.s
    lda #>s4
    sta printf_str.s+1
    jsr printf_str
    // [555] phi from heap_can_coalesce_right::@14 to heap_can_coalesce_right::@15 [phi:heap_can_coalesce_right::@14->heap_can_coalesce_right::@15]
    // heap_can_coalesce_right::@15
    // printf("\n > Can coalesce to the right with free index %03x.", right_index)
    // [556] call printf_str
    // [380] phi from heap_can_coalesce_right::@15 to printf_str [phi:heap_can_coalesce_right::@15->printf_str]
    // [380] phi printf_str::s#69 = heap_can_coalesce_right::s6 [phi:heap_can_coalesce_right::@15->printf_str#0] -- call_phi_near 
    lda #<s6
    sta printf_str.s
    lda #>s6
    sta printf_str.s+1
    jsr printf_str
    // heap_can_coalesce_right::@16
    // printf("\n > Can coalesce to the right with free index %03x.", right_index)
    // [557] printf_uchar::uvalue#15 = heap_can_coalesce_right::right_index#0 -- vbum1=vbum2 
    lda right_index
    sta printf_uchar.uvalue
    // [558] call printf_uchar
    // [389] phi from heap_can_coalesce_right::@16 to printf_uchar [phi:heap_can_coalesce_right::@16->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:heap_can_coalesce_right::@16->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#15 [phi:heap_can_coalesce_right::@16->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [559] phi from heap_can_coalesce_right::@16 to heap_can_coalesce_right::@17 [phi:heap_can_coalesce_right::@16->heap_can_coalesce_right::@17]
    // heap_can_coalesce_right::@17
    // printf("\n > Can coalesce to the right with free index %03x.", right_index)
    // [560] call printf_str
    // [380] phi from heap_can_coalesce_right::@17 to printf_str [phi:heap_can_coalesce_right::@17->printf_str]
    // [380] phi printf_str::s#69 = s3 [phi:heap_can_coalesce_right::@17->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // [537] phi from heap_can_coalesce_right::@17 to heap_can_coalesce_right::@return [phi:heap_can_coalesce_right::@17->heap_can_coalesce_right::@return]
    // [537] phi heap_can_coalesce_right::return#3 = heap_can_coalesce_right::right_index#0 [phi:heap_can_coalesce_right::@17->heap_can_coalesce_right::@return#0] -- register_copy 
    rts
  .segment DataBramHeap
    s1: .text @"\n > Cannot coalesce to the right."
    .byte 0
    s2: .text @"\n > Right index "
    .byte 0
    s6: .text @"\n > Can coalesce to the right with free index "
    .byte 0
  .segment Data
    heap_index: .byte 0
  .segment DataBramHeap
    heap_offset: .word 0
    .label right_index = return
    right_offset: .word 0
  .segment Data
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
    // [561] bram_heap_size_pack::size#0 = bram_heap_alloc_size_get::size#0 - 1 -- vdum1=vdum2_minus_1 
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
    // [562] call bram_heap_size_pack -- call_phi_near 
    jsr bram_heap_size_pack
    // [563] bram_heap_size_pack::return#2 = bram_heap_size_pack::return#0 -- vwum1=vwum2 
    lda bram_heap_size_pack.return
    sta bram_heap_size_pack.return_1
    lda bram_heap_size_pack.return+1
    sta bram_heap_size_pack.return_1+1
    // bram_heap_alloc_size_get::@1
    // [564] bram_heap_alloc_size_get::$1 = bram_heap_size_pack::return#2 -- vwum1=vwum2 
    lda bram_heap_size_pack.return_1
    sta bram_heap_alloc_size_get__1
    lda bram_heap_size_pack.return_1+1
    sta bram_heap_alloc_size_get__1+1
    // return (bram_heap_size_packed_t)((bram_heap_size_pack(size-1) + 1));
    // [565] bram_heap_alloc_size_get::return#1 = bram_heap_alloc_size_get::$1 + 1 -- vwum1=vwum2_plus_1 
    clc
    lda bram_heap_alloc_size_get__1
    adc #1
    sta return_1
    lda bram_heap_alloc_size_get__1+1
    adc #0
    sta return_1+1
    // bram_heap_alloc_size_get::@return
    // }
    // [566] return 
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
    // [567] bram_heap_find_best_fit::free_index#0 = ((char *)&bram_heap_segment+$2e)[bram_heap_find_best_fit::s#0] -- vbum1=pbuc1_derefidx_vbuxx 
    lda bram_heap_segment+$2e,x
    sta free_index
    // if(free_index == BRAM_HEAP_NULL)
    // [568] if(bram_heap_find_best_fit::free_index#0!=$ff) goto bram_heap_find_best_fit::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp free_index
    bne __b1
    // [569] phi from bram_heap_find_best_fit bram_heap_find_best_fit::@2 to bram_heap_find_best_fit::@return [phi:bram_heap_find_best_fit/bram_heap_find_best_fit::@2->bram_heap_find_best_fit::@return]
  __b5:
    // [569] phi bram_heap_find_best_fit::return#2 = $ff [phi:bram_heap_find_best_fit/bram_heap_find_best_fit::@2->bram_heap_find_best_fit::@return#0] -- vbum1=vbuc1 
    lda #$ff
    sta return
    // bram_heap_find_best_fit::@return
    // }
    // [570] return 
    rts
    // bram_heap_find_best_fit::@1
  __b1:
    // bram_heap_index_t free_end = bram_heap_segment.free_list[s]
    // [571] bram_heap_find_best_fit::free_end#0 = ((char *)&bram_heap_segment+$2e)[bram_heap_find_best_fit::s#0] -- vbum1=pbuc1_derefidx_vbuxx 
    lda bram_heap_segment+$2e,x
    sta free_end
    // printf(", best fit is ")
    // [572] call printf_str
    // [380] phi from bram_heap_find_best_fit::@1 to printf_str [phi:bram_heap_find_best_fit::@1->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_find_best_fit::s1 [phi:bram_heap_find_best_fit::@1->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // [573] phi from bram_heap_find_best_fit::@1 to bram_heap_find_best_fit::@3 [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@3]
    // [573] phi bram_heap_find_best_fit::best_index#14 = $ff [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@3#0] -- vbum1=vbuc1 
    lda #$ff
    sta best_index
    // [573] phi bram_heap_find_best_fit::best_size#2 = $ffff [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@3#1] -- vwum1=vwuc1 
    lda #<$ffff
    sta best_size
    lda #>$ffff
    sta best_size+1
    // [573] phi bram_heap_find_best_fit::free_index#2 = bram_heap_find_best_fit::free_index#0 [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@3#2] -- register_copy 
    // bram_heap_find_best_fit::@3
  __b3:
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [574] bram_heap_get_size_packed::index#5 = bram_heap_find_best_fit::free_index#2 -- vbuxx=vbum1 
    ldx free_index
    // [575] call bram_heap_get_size_packed
  // O(n) search.
    // [275] phi from bram_heap_find_best_fit::@3 to bram_heap_get_size_packed [phi:bram_heap_find_best_fit::@3->bram_heap_get_size_packed]
    // [275] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#5 [phi:bram_heap_find_best_fit::@3->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [576] bram_heap_get_size_packed::return#15 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return_5
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return_5+1
    // bram_heap_find_best_fit::@8
    // [577] bram_heap_find_best_fit::free_size#0 = bram_heap_get_size_packed::return#15 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_5
    sta free_size
    lda bram_heap_get_size_packed.return_5+1
    sta free_size+1
    // if(free_size >= requested_size && free_size < best_size)
    // [578] if(bram_heap_find_best_fit::free_size#0<bram_heap_find_best_fit::requested_size#0) goto bram_heap_find_best_fit::@17 -- vwum1_lt_vwum2_then_la1 
    cmp requested_size+1
    bcs !__b17+
    jmp __b17
  !__b17:
    bne !+
    lda free_size
    cmp requested_size
    bcs !__b17+
    jmp __b17
  !__b17:
  !:
    // bram_heap_find_best_fit::@15
    // [579] if(bram_heap_find_best_fit::free_size#0>=bram_heap_find_best_fit::best_size#2) goto bram_heap_find_best_fit::@4 -- vwum1_ge_vwum2_then_la1 
    lda best_size+1
    cmp free_size+1
    bne !+
    lda best_size
    cmp free_size
    beq __b4
  !:
    bcc __b4
    // bram_heap_find_best_fit::@5
    // [580] bram_heap_find_best_fit::best_index#18 = bram_heap_find_best_fit::free_index#2 -- vbum1=vbum2 
    lda free_index
    sta best_index
    // [581] phi from bram_heap_find_best_fit::@17 bram_heap_find_best_fit::@5 to bram_heap_find_best_fit::@4 [phi:bram_heap_find_best_fit::@17/bram_heap_find_best_fit::@5->bram_heap_find_best_fit::@4]
    // [581] phi bram_heap_find_best_fit::best_index#10 = bram_heap_find_best_fit::best_index#14 [phi:bram_heap_find_best_fit::@17/bram_heap_find_best_fit::@5->bram_heap_find_best_fit::@4#0] -- register_copy 
    // [581] phi bram_heap_find_best_fit::best_size#10 = bram_heap_find_best_fit::best_size#16 [phi:bram_heap_find_best_fit::@17/bram_heap_find_best_fit::@5->bram_heap_find_best_fit::@4#1] -- register_copy 
    // [581] phi from bram_heap_find_best_fit::@15 to bram_heap_find_best_fit::@4 [phi:bram_heap_find_best_fit::@15->bram_heap_find_best_fit::@4]
    // bram_heap_find_best_fit::@4
  __b4:
    // bram_heap_find_best_fit::bram_heap_get_next1
    // return bram_heap_index.next[index];
    // [582] bram_heap_find_best_fit::bram_heap_get_next1_return#0 = ((char *)&bram_heap_index+$400)[bram_heap_find_best_fit::free_index#2] -- vbum1=pbuc1_derefidx_vbum1 
    ldy bram_heap_get_next1_return
    lda bram_heap_index+$400,y
    sta bram_heap_get_next1_return
    // bram_heap_find_best_fit::@7
    // while(free_index != free_end)
    // [583] if(bram_heap_find_best_fit::bram_heap_get_next1_return#0!=bram_heap_find_best_fit::free_end#0) goto bram_heap_find_best_fit::@16 -- vbum1_neq_vbum2_then_la1 
    cmp free_end
    beq !__b16+
    jmp __b16
  !__b16:
    // bram_heap_find_best_fit::@6
    // bram_heap_size_unpack(best_size)
    // [584] bram_heap_size_unpack::size#6 = bram_heap_find_best_fit::best_size#10 -- vwum1=vwum2 
    lda best_size_1
    sta bram_heap_size_unpack.size
    lda best_size_1+1
    sta bram_heap_size_unpack.size+1
    // [585] call bram_heap_size_unpack
    // [376] phi from bram_heap_find_best_fit::@6 to bram_heap_size_unpack [phi:bram_heap_find_best_fit::@6->bram_heap_size_unpack]
    // [376] phi bram_heap_size_unpack::size#7 = bram_heap_size_unpack::size#6 [phi:bram_heap_find_best_fit::@6->bram_heap_size_unpack#0] -- call_phi_near 
    jsr bram_heap_size_unpack
    // bram_heap_size_unpack(best_size)
    // [586] bram_heap_size_unpack::return#16 = bram_heap_size_unpack::return#12 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_3
    sta bram_heap_size_unpack.return_7
    lda bram_heap_size_unpack.return_3+1
    sta bram_heap_size_unpack.return_7+1
    lda bram_heap_size_unpack.return_3+2
    sta bram_heap_size_unpack.return_7+2
    lda bram_heap_size_unpack.return_3+3
    sta bram_heap_size_unpack.return_7+3
    // bram_heap_find_best_fit::@9
    // printf("free index %03x size %05x.", best_index, bram_heap_size_unpack(best_size) )
    // [587] printf_ulong::uvalue#10 = bram_heap_size_unpack::return#16 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_7
    sta printf_ulong.uvalue
    lda bram_heap_size_unpack.return_7+1
    sta printf_ulong.uvalue+1
    lda bram_heap_size_unpack.return_7+2
    sta printf_ulong.uvalue+2
    lda bram_heap_size_unpack.return_7+3
    sta printf_ulong.uvalue+3
    // [588] call printf_str
    // [380] phi from bram_heap_find_best_fit::@9 to printf_str [phi:bram_heap_find_best_fit::@9->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_find_best_fit::s2 [phi:bram_heap_find_best_fit::@9->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_find_best_fit::@10
    // printf("free index %03x size %05x.", best_index, bram_heap_size_unpack(best_size) )
    // [589] printf_uchar::uvalue#11 = bram_heap_find_best_fit::best_index#10 -- vbum1=vbum2 
    lda best_index
    sta printf_uchar.uvalue
    // [590] call printf_uchar
    // [389] phi from bram_heap_find_best_fit::@10 to printf_uchar [phi:bram_heap_find_best_fit::@10->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_find_best_fit::@10->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#11 [phi:bram_heap_find_best_fit::@10->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [591] phi from bram_heap_find_best_fit::@10 to bram_heap_find_best_fit::@11 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@11]
    // bram_heap_find_best_fit::@11
    // printf("free index %03x size %05x.", best_index, bram_heap_size_unpack(best_size) )
    // [592] call printf_str
    // [380] phi from bram_heap_find_best_fit::@11 to printf_str [phi:bram_heap_find_best_fit::@11->printf_str]
    // [380] phi printf_str::s#69 = s2 [phi:bram_heap_find_best_fit::@11->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // [593] phi from bram_heap_find_best_fit::@11 to bram_heap_find_best_fit::@12 [phi:bram_heap_find_best_fit::@11->bram_heap_find_best_fit::@12]
    // bram_heap_find_best_fit::@12
    // printf("free index %03x size %05x.", best_index, bram_heap_size_unpack(best_size) )
    // [594] call printf_ulong
    // [397] phi from bram_heap_find_best_fit::@12 to printf_ulong [phi:bram_heap_find_best_fit::@12->printf_ulong]
    // [397] phi printf_ulong::uvalue#12 = printf_ulong::uvalue#10 [phi:bram_heap_find_best_fit::@12->printf_ulong#0] -- call_phi_near 
    jsr printf_ulong
    // [595] phi from bram_heap_find_best_fit::@12 to bram_heap_find_best_fit::@13 [phi:bram_heap_find_best_fit::@12->bram_heap_find_best_fit::@13]
    // bram_heap_find_best_fit::@13
    // printf("free index %03x size %05x.", best_index, bram_heap_size_unpack(best_size) )
    // [596] call printf_str
    // [380] phi from bram_heap_find_best_fit::@13 to printf_str [phi:bram_heap_find_best_fit::@13->printf_str]
    // [380] phi printf_str::s#69 = s3 [phi:bram_heap_find_best_fit::@13->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_find_best_fit::@14
    // if(requested_size <= best_size)
    // [597] if(bram_heap_find_best_fit::requested_size#0>bram_heap_find_best_fit::best_size#10) goto bram_heap_find_best_fit::@2 -- vwum1_gt_vwum2_then_la1 
    lda best_size_1+1
    cmp requested_size+1
    bcs !__b5+
    jmp __b5
  !__b5:
    bne !+
    lda best_size_1
    cmp requested_size
    bcs !__b5+
    jmp __b5
  !__b5:
  !:
    // [569] phi from bram_heap_find_best_fit::@14 to bram_heap_find_best_fit::@return [phi:bram_heap_find_best_fit::@14->bram_heap_find_best_fit::@return]
    // [569] phi bram_heap_find_best_fit::return#2 = bram_heap_find_best_fit::best_index#10 [phi:bram_heap_find_best_fit::@14->bram_heap_find_best_fit::@return#0] -- register_copy 
    rts
    // [598] phi from bram_heap_find_best_fit::@14 to bram_heap_find_best_fit::@2 [phi:bram_heap_find_best_fit::@14->bram_heap_find_best_fit::@2]
    // bram_heap_find_best_fit::@2
    // bram_heap_find_best_fit::@16
  __b16:
    // [599] bram_heap_find_best_fit::best_size#15 = bram_heap_find_best_fit::best_size#10 -- vwum1=vwum2 
    lda best_size_1
    sta best_size
    lda best_size_1+1
    sta best_size+1
    // [573] phi from bram_heap_find_best_fit::@16 to bram_heap_find_best_fit::@3 [phi:bram_heap_find_best_fit::@16->bram_heap_find_best_fit::@3]
    // [573] phi bram_heap_find_best_fit::best_index#14 = bram_heap_find_best_fit::best_index#10 [phi:bram_heap_find_best_fit::@16->bram_heap_find_best_fit::@3#0] -- register_copy 
    // [573] phi bram_heap_find_best_fit::best_size#2 = bram_heap_find_best_fit::best_size#15 [phi:bram_heap_find_best_fit::@16->bram_heap_find_best_fit::@3#1] -- register_copy 
    // [573] phi bram_heap_find_best_fit::free_index#2 = bram_heap_find_best_fit::bram_heap_get_next1_return#0 [phi:bram_heap_find_best_fit::@16->bram_heap_find_best_fit::@3#2] -- register_copy 
    jmp __b3
    // bram_heap_find_best_fit::@17
  __b17:
    // [600] bram_heap_find_best_fit::best_size#16 = bram_heap_find_best_fit::best_size#2 -- vwum1=vwum2 
    lda best_size
    sta best_size_1
    lda best_size+1
    sta best_size_1+1
    jmp __b4
  .segment DataBramHeap
    s1: .text ", best fit is "
    .byte 0
    s2: .text "free index "
    .byte 0
  .segment Data
    requested_size: .word 0
  .segment DataBramHeap
    free_index: .byte 0
    free_end: .byte 0
  .segment Data
    .label return = best_index
  .segment DataBramHeap
    .label free_size = best_size_1
    .label bram_heap_get_next1_return = free_index
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
    // [601] bram_heap_get_size_packed::index#4 = bram_heap_allocate::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [602] call bram_heap_get_size_packed
    // [275] phi from bram_heap_allocate to bram_heap_get_size_packed [phi:bram_heap_allocate->bram_heap_get_size_packed]
    // [275] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#4 [phi:bram_heap_allocate->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [603] bram_heap_get_size_packed::return#14 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return_4
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return_4+1
    // bram_heap_allocate::@4
    // [604] bram_heap_allocate::free_size#0 = bram_heap_get_size_packed::return#14 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_4
    sta free_size
    lda bram_heap_get_size_packed.return_4+1
    sta free_size+1
    // if(free_size > required_size)
    // [605] if(bram_heap_allocate::free_size#0>bram_heap_allocate::required_size#0) goto bram_heap_allocate::@1 -- vwum1_gt_vwum2_then_la1 
    lda required_size+1
    cmp free_size+1
    bcs !__b1+
    jmp __b1
  !__b1:
    bne !+
    lda required_size
    cmp free_size
    bcs !__b1+
    jmp __b1
  !__b1:
  !:
    // bram_heap_allocate::@2
    // if(free_size == required_size)
    // [606] if(bram_heap_allocate::free_size#0==bram_heap_allocate::required_size#0) goto bram_heap_allocate::@3 -- vwum1_eq_vwum2_then_la1 
    lda free_size
    cmp required_size
    bne !+
    lda free_size+1
    cmp required_size+1
    beq __b3
  !:
    // [607] phi from bram_heap_allocate::@2 to bram_heap_allocate::@return [phi:bram_heap_allocate::@2->bram_heap_allocate::@return]
    // [607] phi bram_heap_allocate::return#4 = $ff [phi:bram_heap_allocate::@2->bram_heap_allocate::@return#0] -- vbuaa=vbuc1 
    lda #$ff
    // bram_heap_allocate::@return
    // }
    // [608] return 
    rts
    // bram_heap_allocate::@3
  __b3:
    // bram_heap_size_unpack(required_size)
    // [609] bram_heap_size_unpack::size#5 = bram_heap_allocate::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta bram_heap_size_unpack.size
    lda required_size+1
    sta bram_heap_size_unpack.size+1
    // [610] call bram_heap_size_unpack
    // [376] phi from bram_heap_allocate::@3 to bram_heap_size_unpack [phi:bram_heap_allocate::@3->bram_heap_size_unpack]
    // [376] phi bram_heap_size_unpack::size#7 = bram_heap_size_unpack::size#5 [phi:bram_heap_allocate::@3->bram_heap_size_unpack#0] -- call_phi_near 
    jsr bram_heap_size_unpack
    // bram_heap_size_unpack(required_size)
    // [611] bram_heap_size_unpack::return#15 = bram_heap_size_unpack::return#12 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_3
    sta bram_heap_size_unpack.return_6
    lda bram_heap_size_unpack.return_3+1
    sta bram_heap_size_unpack.return_6+1
    lda bram_heap_size_unpack.return_3+2
    sta bram_heap_size_unpack.return_6+2
    lda bram_heap_size_unpack.return_3+3
    sta bram_heap_size_unpack.return_6+3
    // bram_heap_allocate::@15
    // printf("\n > Can replace free index %03x with heap size %05x.", free_index, bram_heap_size_unpack(required_size))
    // [612] printf_ulong::uvalue#9 = bram_heap_size_unpack::return#15 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_6
    sta printf_ulong.uvalue
    lda bram_heap_size_unpack.return_6+1
    sta printf_ulong.uvalue+1
    lda bram_heap_size_unpack.return_6+2
    sta printf_ulong.uvalue+2
    lda bram_heap_size_unpack.return_6+3
    sta printf_ulong.uvalue+3
    // [613] call printf_str
    // [380] phi from bram_heap_allocate::@15 to printf_str [phi:bram_heap_allocate::@15->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_allocate::s5 [phi:bram_heap_allocate::@15->printf_str#0] -- call_phi_near 
    lda #<s5
    sta printf_str.s
    lda #>s5
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_allocate::@16
    // printf("\n > Can replace free index %03x with heap size %05x.", free_index, bram_heap_size_unpack(required_size))
    // [614] printf_uchar::uvalue#10 = bram_heap_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta printf_uchar.uvalue
    // [615] call printf_uchar
    // [389] phi from bram_heap_allocate::@16 to printf_uchar [phi:bram_heap_allocate::@16->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_allocate::@16->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#10 [phi:bram_heap_allocate::@16->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [616] phi from bram_heap_allocate::@16 to bram_heap_allocate::@17 [phi:bram_heap_allocate::@16->bram_heap_allocate::@17]
    // bram_heap_allocate::@17
    // printf("\n > Can replace free index %03x with heap size %05x.", free_index, bram_heap_size_unpack(required_size))
    // [617] call printf_str
    // [380] phi from bram_heap_allocate::@17 to printf_str [phi:bram_heap_allocate::@17->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_allocate::s6 [phi:bram_heap_allocate::@17->printf_str#0] -- call_phi_near 
    lda #<s6
    sta printf_str.s
    lda #>s6
    sta printf_str.s+1
    jsr printf_str
    // [618] phi from bram_heap_allocate::@17 to bram_heap_allocate::@18 [phi:bram_heap_allocate::@17->bram_heap_allocate::@18]
    // bram_heap_allocate::@18
    // printf("\n > Can replace free index %03x with heap size %05x.", free_index, bram_heap_size_unpack(required_size))
    // [619] call printf_ulong
    // [397] phi from bram_heap_allocate::@18 to printf_ulong [phi:bram_heap_allocate::@18->printf_ulong]
    // [397] phi printf_ulong::uvalue#12 = printf_ulong::uvalue#9 [phi:bram_heap_allocate::@18->printf_ulong#0] -- call_phi_near 
    jsr printf_ulong
    // [620] phi from bram_heap_allocate::@18 to bram_heap_allocate::@19 [phi:bram_heap_allocate::@18->bram_heap_allocate::@19]
    // bram_heap_allocate::@19
    // printf("\n > Can replace free index %03x with heap size %05x.", free_index, bram_heap_size_unpack(required_size))
    // [621] call printf_str
    // [380] phi from bram_heap_allocate::@19 to printf_str [phi:bram_heap_allocate::@19->printf_str]
    // [380] phi printf_str::s#69 = s3 [phi:bram_heap_allocate::@19->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_allocate::@20
    // bram_heap_replace_free_with_heap(s, free_index, required_size)
    // [622] bram_heap_replace_free_with_heap::s#0 = bram_heap_allocate::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_replace_free_with_heap.s
    // [623] bram_heap_replace_free_with_heap::return#2 = bram_heap_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_replace_free_with_heap.return
    // [624] bram_heap_replace_free_with_heap::required_size#0 = bram_heap_allocate::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta bram_heap_replace_free_with_heap.required_size
    lda required_size+1
    sta bram_heap_replace_free_with_heap.required_size+1
    // [625] call bram_heap_replace_free_with_heap -- call_phi_near 
    jsr bram_heap_replace_free_with_heap
    // bram_heap_allocate::@21
    // return bram_heap_replace_free_with_heap(s, free_index, required_size);
    // [626] bram_heap_allocate::return#2 = bram_heap_replace_free_with_heap::return#2 -- vbuaa=vbum1 
    lda bram_heap_replace_free_with_heap.return
    // [607] phi from bram_heap_allocate::@14 bram_heap_allocate::@21 to bram_heap_allocate::@return [phi:bram_heap_allocate::@14/bram_heap_allocate::@21->bram_heap_allocate::@return]
    // [607] phi bram_heap_allocate::return#4 = bram_heap_allocate::return#1 [phi:bram_heap_allocate::@14/bram_heap_allocate::@21->bram_heap_allocate::@return#0] -- register_copy 
    rts
    // bram_heap_allocate::@1
  __b1:
    // bram_heap_size_unpack(free_size - required_size)
    // [627] bram_heap_size_unpack::size#3 = bram_heap_allocate::free_size#0 - bram_heap_allocate::required_size#0 -- vwum1=vwum2_minus_vwum3 
    lda free_size
    sec
    sbc required_size
    sta bram_heap_size_unpack.size
    lda free_size+1
    sbc required_size+1
    sta bram_heap_size_unpack.size+1
    // [628] call bram_heap_size_unpack
    // [376] phi from bram_heap_allocate::@1 to bram_heap_size_unpack [phi:bram_heap_allocate::@1->bram_heap_size_unpack]
    // [376] phi bram_heap_size_unpack::size#7 = bram_heap_size_unpack::size#3 [phi:bram_heap_allocate::@1->bram_heap_size_unpack#0] -- call_phi_near 
    jsr bram_heap_size_unpack
    // bram_heap_size_unpack(free_size - required_size)
    // [629] bram_heap_size_unpack::return#13 = bram_heap_size_unpack::return#12 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_3
    sta bram_heap_size_unpack.return_4
    lda bram_heap_size_unpack.return_3+1
    sta bram_heap_size_unpack.return_4+1
    lda bram_heap_size_unpack.return_3+2
    sta bram_heap_size_unpack.return_4+2
    lda bram_heap_size_unpack.return_3+3
    sta bram_heap_size_unpack.return_4+3
    // bram_heap_allocate::@5
    // printf("\n > Can split free index %03x to size %05x, heap size %05x.", free_index, bram_heap_size_unpack(free_size - required_size), bram_heap_size_unpack(required_size))
    // [630] printf_ulong::uvalue#7 = bram_heap_size_unpack::return#13 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_4
    sta printf_ulong.uvalue
    lda bram_heap_size_unpack.return_4+1
    sta printf_ulong.uvalue+1
    lda bram_heap_size_unpack.return_4+2
    sta printf_ulong.uvalue+2
    lda bram_heap_size_unpack.return_4+3
    sta printf_ulong.uvalue+3
    // bram_heap_size_unpack(required_size)
    // [631] bram_heap_size_unpack::size#4 = bram_heap_allocate::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta bram_heap_size_unpack.size
    lda required_size+1
    sta bram_heap_size_unpack.size+1
    // [632] call bram_heap_size_unpack
    // [376] phi from bram_heap_allocate::@5 to bram_heap_size_unpack [phi:bram_heap_allocate::@5->bram_heap_size_unpack]
    // [376] phi bram_heap_size_unpack::size#7 = bram_heap_size_unpack::size#4 [phi:bram_heap_allocate::@5->bram_heap_size_unpack#0] -- call_phi_near 
    jsr bram_heap_size_unpack
    // bram_heap_size_unpack(required_size)
    // [633] bram_heap_size_unpack::return#14 = bram_heap_size_unpack::return#12 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_3
    sta bram_heap_size_unpack.return_5
    lda bram_heap_size_unpack.return_3+1
    sta bram_heap_size_unpack.return_5+1
    lda bram_heap_size_unpack.return_3+2
    sta bram_heap_size_unpack.return_5+2
    lda bram_heap_size_unpack.return_3+3
    sta bram_heap_size_unpack.return_5+3
    // bram_heap_allocate::@6
    // printf("\n > Can split free index %03x to size %05x, heap size %05x.", free_index, bram_heap_size_unpack(free_size - required_size), bram_heap_size_unpack(required_size))
    // [634] printf_ulong::uvalue#8 = bram_heap_size_unpack::return#14 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_5
    sta printf_ulong.uvalue_3
    lda bram_heap_size_unpack.return_5+1
    sta printf_ulong.uvalue_3+1
    lda bram_heap_size_unpack.return_5+2
    sta printf_ulong.uvalue_3+2
    lda bram_heap_size_unpack.return_5+3
    sta printf_ulong.uvalue_3+3
    // [635] call printf_str
    // [380] phi from bram_heap_allocate::@6 to printf_str [phi:bram_heap_allocate::@6->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_allocate::s1 [phi:bram_heap_allocate::@6->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_allocate::@7
    // printf("\n > Can split free index %03x to size %05x, heap size %05x.", free_index, bram_heap_size_unpack(free_size - required_size), bram_heap_size_unpack(required_size))
    // [636] printf_uchar::uvalue#9 = bram_heap_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta printf_uchar.uvalue
    // [637] call printf_uchar
    // [389] phi from bram_heap_allocate::@7 to printf_uchar [phi:bram_heap_allocate::@7->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_allocate::@7->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#9 [phi:bram_heap_allocate::@7->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [638] phi from bram_heap_allocate::@7 to bram_heap_allocate::@8 [phi:bram_heap_allocate::@7->bram_heap_allocate::@8]
    // bram_heap_allocate::@8
    // printf("\n > Can split free index %03x to size %05x, heap size %05x.", free_index, bram_heap_size_unpack(free_size - required_size), bram_heap_size_unpack(required_size))
    // [639] call printf_str
    // [380] phi from bram_heap_allocate::@8 to printf_str [phi:bram_heap_allocate::@8->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_allocate::s2 [phi:bram_heap_allocate::@8->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // [640] phi from bram_heap_allocate::@8 to bram_heap_allocate::@9 [phi:bram_heap_allocate::@8->bram_heap_allocate::@9]
    // bram_heap_allocate::@9
    // printf("\n > Can split free index %03x to size %05x, heap size %05x.", free_index, bram_heap_size_unpack(free_size - required_size), bram_heap_size_unpack(required_size))
    // [641] call printf_ulong
    // [397] phi from bram_heap_allocate::@9 to printf_ulong [phi:bram_heap_allocate::@9->printf_ulong]
    // [397] phi printf_ulong::uvalue#12 = printf_ulong::uvalue#7 [phi:bram_heap_allocate::@9->printf_ulong#0] -- call_phi_near 
    jsr printf_ulong
    // [642] phi from bram_heap_allocate::@9 to bram_heap_allocate::@10 [phi:bram_heap_allocate::@9->bram_heap_allocate::@10]
    // bram_heap_allocate::@10
    // printf("\n > Can split free index %03x to size %05x, heap size %05x.", free_index, bram_heap_size_unpack(free_size - required_size), bram_heap_size_unpack(required_size))
    // [643] call printf_str
    // [380] phi from bram_heap_allocate::@10 to printf_str [phi:bram_heap_allocate::@10->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_allocate::s3 [phi:bram_heap_allocate::@10->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_allocate::@11
    // [644] printf_ulong::uvalue#18 = printf_ulong::uvalue#8 -- vdum1=vdum2 
    lda printf_ulong.uvalue_3
    sta printf_ulong.uvalue
    lda printf_ulong.uvalue_3+1
    sta printf_ulong.uvalue+1
    lda printf_ulong.uvalue_3+2
    sta printf_ulong.uvalue+2
    lda printf_ulong.uvalue_3+3
    sta printf_ulong.uvalue+3
    // printf("\n > Can split free index %03x to size %05x, heap size %05x.", free_index, bram_heap_size_unpack(free_size - required_size), bram_heap_size_unpack(required_size))
    // [645] call printf_ulong
    // [397] phi from bram_heap_allocate::@11 to printf_ulong [phi:bram_heap_allocate::@11->printf_ulong]
    // [397] phi printf_ulong::uvalue#12 = printf_ulong::uvalue#18 [phi:bram_heap_allocate::@11->printf_ulong#0] -- call_phi_near 
    jsr printf_ulong
    // [646] phi from bram_heap_allocate::@11 to bram_heap_allocate::@12 [phi:bram_heap_allocate::@11->bram_heap_allocate::@12]
    // bram_heap_allocate::@12
    // printf("\n > Can split free index %03x to size %05x, heap size %05x.", free_index, bram_heap_size_unpack(free_size - required_size), bram_heap_size_unpack(required_size))
    // [647] call printf_str
    // [380] phi from bram_heap_allocate::@12 to printf_str [phi:bram_heap_allocate::@12->printf_str]
    // [380] phi printf_str::s#69 = s3 [phi:bram_heap_allocate::@12->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_allocate::@13
    // bram_heap_split_free_and_allocate(s, free_index, required_size)
    // [648] bram_heap_split_free_and_allocate::s#0 = bram_heap_allocate::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_split_free_and_allocate.s
    // [649] bram_heap_split_free_and_allocate::free_index#0 = bram_heap_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_split_free_and_allocate.free_index
    // [650] bram_heap_split_free_and_allocate::required_size#0 = bram_heap_allocate::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta bram_heap_split_free_and_allocate.required_size
    lda required_size+1
    sta bram_heap_split_free_and_allocate.required_size+1
    // [651] call bram_heap_split_free_and_allocate -- call_phi_near 
    jsr bram_heap_split_free_and_allocate
    // [652] bram_heap_split_free_and_allocate::return#2 = bram_heap_split_free_and_allocate::heap_index#0 -- vbuaa=vbum1 
    lda bram_heap_split_free_and_allocate.heap_index
    // bram_heap_allocate::@14
    // return bram_heap_split_free_and_allocate(s, free_index, required_size);
    // [653] bram_heap_allocate::return#1 = bram_heap_split_free_and_allocate::return#2
    rts
  .segment DataBramHeap
    s1: .text @"\n > Can split free index "
    .byte 0
    s2: .text " to size "
    .byte 0
    s3: .text ", heap size "
    .byte 0
    s5: .text @"\n > Can replace free index "
    .byte 0
    s6: .text " with heap size "
    .byte 0
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
    // bram_bank<<2
    // [655] bram_heap_data_pack::$0 = bram_heap_data_pack::bram_bank#2 << 2 -- vbuaa=vbuxx_rol_2 
    txa
    asl
    asl
    // MAKEWORD(bram_bank<<2, 0)
    // [656] bram_heap_data_pack::$1 = bram_heap_data_pack::$0 w= 0 -- vwum1=vbuaa_word_vbuc1 
    ldy #0
    sta bram_heap_data_pack__1+1
    sty bram_heap_data_pack__1
    // (unsigned int)bram_ptr & 0x1FFF
    // [657] bram_heap_data_pack::$2 = (unsigned int)bram_heap_data_pack::bram_ptr#2 & $1fff -- vwum1=vwum1_band_vwuc1 
    lda bram_heap_data_pack__2
    and #<$1fff
    sta bram_heap_data_pack__2
    lda bram_heap_data_pack__2+1
    and #>$1fff
    sta bram_heap_data_pack__2+1
    // ((unsigned int)bram_ptr & 0x1FFF ) >> 3
    // [658] bram_heap_data_pack::$3 = bram_heap_data_pack::$2 >> 3 -- vwum1=vwum1_ror_3 
    lsr bram_heap_data_pack__3+1
    ror bram_heap_data_pack__3
    lsr bram_heap_data_pack__3+1
    ror bram_heap_data_pack__3
    lsr bram_heap_data_pack__3+1
    ror bram_heap_data_pack__3
    // MAKEWORD(bram_bank<<2, 0) | (((unsigned int)bram_ptr & 0x1FFF ) >> 3)
    // [659] bram_heap_data_pack::return#2 = bram_heap_data_pack::$1 | bram_heap_data_pack::$3 -- vwum1=vwum2_bor_vwum1 
    lda return
    ora bram_heap_data_pack__1
    sta return
    lda return+1
    ora bram_heap_data_pack__1+1
    sta return+1
    // bram_heap_data_pack::@return
    // }
    // [660] return 
    rts
  .segment DataBramHeap
    bram_heap_data_pack__1: .word 0
    .label bram_heap_data_pack__2 = bram_ptr
    .label bram_heap_data_pack__3 = bram_ptr
  .segment Data
    bram_ptr: .word 0
    .label return = bram_ptr
}
.segment CodeBramHeap
  // bram_heap_index_add
// __register(A) char bram_heap_index_add(__register(X) char s)
bram_heap_index_add: {
    // bram_heap_index_t index = bram_heap_segment.idle_list[s]
    // [662] bram_heap_index_add::index#0 = ((char *)&bram_heap_segment+$32)[bram_heap_index_add::s#2] -- vbum1=pbuc1_derefidx_vbuxx 
    // TODO: Search idle list.
    lda bram_heap_segment+$32,x
    sta index
    // if(index != BRAM_HEAP_NULL)
    // [663] if(bram_heap_index_add::index#0!=$ff) goto bram_heap_index_add::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp index
    bne __b1
    // bram_heap_index_add::@3
    // index = bram_heap_segment.index_position
    // [664] bram_heap_index_add::index#1 = *((char *)&bram_heap_segment+1) -- vbum1=_deref_pbuc1 
    // The current header gets the current heap position handle.
    lda bram_heap_segment+1
    sta index
    // bram_heap_segment.index_position += 1
    // [665] *((char *)&bram_heap_segment+1) = *((char *)&bram_heap_segment+1) + 1 -- _deref_pbuc1=_deref_pbuc1_plus_1 
    // We adjust to the next index position.
    inc bram_heap_segment+1
    // [666] phi from bram_heap_index_add::@1 bram_heap_index_add::@3 to bram_heap_index_add::@2 [phi:bram_heap_index_add::@1/bram_heap_index_add::@3->bram_heap_index_add::@2]
    // [666] phi bram_heap_index_add::return#1 = bram_heap_index_add::index#0 [phi:bram_heap_index_add::@1/bram_heap_index_add::@3->bram_heap_index_add::@2#0] -- register_copy 
    // bram_heap_index_add::@2
    // bram_heap_index_add::@return
    // }
    // [667] return 
    rts
    // bram_heap_index_add::@1
  __b1:
    // heap_idle_remove(s, index)
    // [668] heap_idle_remove::s#0 = bram_heap_index_add::s#2 -- vbum1=vbuxx 
    stx heap_idle_remove.s
    // [669] heap_idle_remove::idle_index#0 = bram_heap_index_add::index#0 -- vbum1=vbum2 
    lda index
    sta heap_idle_remove.idle_index
    // [670] call heap_idle_remove -- call_phi_near 
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
    // [672] if(bram_heap_list_insert_at::list#5!=$ff) goto bram_heap_list_insert_at::@1 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$ff
    bne __b1
    // bram_heap_list_insert_at::bram_heap_set_prev1
    // bram_heap_index.prev[index] = prev
    // [673] ((char *)&bram_heap_index+$500)[bram_heap_list_insert_at::index#10] = bram_heap_list_insert_at::index#10 -- pbuc1_derefidx_vbum1=vbum1 
    ldy index
    tya
    sta bram_heap_index+$500,y
    // bram_heap_list_insert_at::bram_heap_set_next1
    // bram_heap_index.next[index] = next
    // [674] ((char *)&bram_heap_index+$400)[bram_heap_list_insert_at::index#10] = bram_heap_list_insert_at::index#10 -- pbuc1_derefidx_vbum1=vbum1 
    tya
    sta bram_heap_index+$400,y
    // [675] bram_heap_list_insert_at::list#28 = bram_heap_list_insert_at::index#10 -- vbuxx=vbum1 
    tax
    // [676] phi from bram_heap_list_insert_at bram_heap_list_insert_at::bram_heap_set_next1 to bram_heap_list_insert_at::@1 [phi:bram_heap_list_insert_at/bram_heap_list_insert_at::bram_heap_set_next1->bram_heap_list_insert_at::@1]
    // [676] phi bram_heap_list_insert_at::list#11 = bram_heap_list_insert_at::list#5 [phi:bram_heap_list_insert_at/bram_heap_list_insert_at::bram_heap_set_next1->bram_heap_list_insert_at::@1#0] -- register_copy 
    // bram_heap_list_insert_at::@1
  __b1:
    // if(at == BRAM_HEAP_NULL)
    // [677] if(bram_heap_list_insert_at::at#11!=$ff) goto bram_heap_list_insert_at::@2 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp at
    bne __b2
    // bram_heap_list_insert_at::@3
    // [678] bram_heap_list_insert_at::first#8 = bram_heap_list_insert_at::list#11 -- vbum1=vbuxx 
    stx first
    // [679] phi from bram_heap_list_insert_at::@1 bram_heap_list_insert_at::@3 to bram_heap_list_insert_at::@2 [phi:bram_heap_list_insert_at::@1/bram_heap_list_insert_at::@3->bram_heap_list_insert_at::@2]
    // [679] phi bram_heap_list_insert_at::first#0 = bram_heap_list_insert_at::at#11 [phi:bram_heap_list_insert_at::@1/bram_heap_list_insert_at::@3->bram_heap_list_insert_at::@2#0] -- register_copy 
    // bram_heap_list_insert_at::@2
  __b2:
    // bram_heap_list_insert_at::bram_heap_get_prev1
    // return bram_heap_index.prev[index];
    // [680] bram_heap_list_insert_at::bram_heap_get_prev1_return#0 = ((char *)&bram_heap_index+$500)[bram_heap_list_insert_at::first#0] -- vbuaa=pbuc1_derefidx_vbum1 
    ldy first
    lda bram_heap_index+$500,y
    // bram_heap_list_insert_at::bram_heap_set_prev2
    // bram_heap_index.prev[index] = prev
    // [681] ((char *)&bram_heap_index+$500)[bram_heap_list_insert_at::index#10] = bram_heap_list_insert_at::bram_heap_get_prev1_return#0 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy index
    sta bram_heap_index+$500,y
    // bram_heap_list_insert_at::bram_heap_set_next2
    // bram_heap_index.next[index] = next
    // [682] ((char *)&bram_heap_index+$400)[bram_heap_list_insert_at::bram_heap_get_prev1_return#0] = bram_heap_list_insert_at::index#10 -- pbuc1_derefidx_vbuaa=vbum1 
    tay
    lda index
    sta bram_heap_index+$400,y
    // bram_heap_list_insert_at::bram_heap_set_next3
    // [683] ((char *)&bram_heap_index+$400)[bram_heap_list_insert_at::index#10] = bram_heap_list_insert_at::first#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda first
    ldy index
    sta bram_heap_index+$400,y
    // bram_heap_list_insert_at::bram_heap_set_prev3
    // bram_heap_index.prev[index] = prev
    // [684] ((char *)&bram_heap_index+$500)[bram_heap_list_insert_at::first#0] = bram_heap_list_insert_at::index#10 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy first
    sta bram_heap_index+$500,y
    // bram_heap_list_insert_at::@return
    // }
    // [685] return 
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
    // [687] bram_heap_set_data_packed::$0 = byte1  bram_heap_set_data_packed::data_packed#7 -- vbuaa=_byte1_vwum1 
    lda data_packed+1
    // bram_heap_index.data1[index] = BYTE1(data_packed)
    // [688] ((char *)&bram_heap_index+$100)[bram_heap_set_data_packed::index#7] = bram_heap_set_data_packed::$0 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta bram_heap_index+$100,x
    // BYTE0(data_packed)
    // [689] bram_heap_set_data_packed::$1 = byte0  bram_heap_set_data_packed::data_packed#7 -- vbuaa=_byte0_vwum1 
    lda data_packed
    // bram_heap_index.data0[index] = BYTE0(data_packed)
    // [690] ((char *)&bram_heap_index)[bram_heap_set_data_packed::index#7] = bram_heap_set_data_packed::$1 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta bram_heap_index,x
    // bram_heap_set_data_packed::@return
    // }
    // [691] return 
    rts
  .segment Data
    data_packed: .word 0
}
.segment CodeBramHeap
  // bram_heap_set_size_packed
// void bram_heap_set_size_packed(char s, __register(X) char index, __mem() unsigned int size_packed)
bram_heap_set_size_packed: {
    // bram_heap_index.size1[index] & 0x80
    // [693] bram_heap_set_size_packed::$0 = ((char *)&bram_heap_index+$300)[bram_heap_set_size_packed::index#6] & $80 -- vbuaa=pbuc1_derefidx_vbuxx_band_vbuc2 
    lda #$80
    and bram_heap_index+$300,x
    // bram_heap_index.size1[index] &= bram_heap_index.size1[index] & 0x80
    // [694] ((char *)&bram_heap_index+$300)[bram_heap_set_size_packed::index#6] = ((char *)&bram_heap_index+$300)[bram_heap_set_size_packed::index#6] & bram_heap_set_size_packed::$0 -- pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_band_vbuaa 
    and bram_heap_index+$300,x
    sta bram_heap_index+$300,x
    // BYTE1(size_packed)
    // [695] bram_heap_set_size_packed::$1 = byte1  bram_heap_set_size_packed::size_packed#6 -- vbuaa=_byte1_vwum1 
    lda size_packed+1
    // BYTE1(size_packed) & 0x7F
    // [696] bram_heap_set_size_packed::$2 = bram_heap_set_size_packed::$1 & $7f -- vbuaa=vbuaa_band_vbuc1 
    and #$7f
    // bram_heap_index.size1[index] = BYTE1(size_packed) & 0x7F
    // [697] ((char *)&bram_heap_index+$300)[bram_heap_set_size_packed::index#6] = bram_heap_set_size_packed::$2 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta bram_heap_index+$300,x
    // BYTE0(size_packed)
    // [698] bram_heap_set_size_packed::$3 = byte0  bram_heap_set_size_packed::size_packed#6 -- vbuaa=_byte0_vwum1 
    lda size_packed
    // bram_heap_index.size0[index] = BYTE0(size_packed)
    // [699] ((char *)&bram_heap_index+$200)[bram_heap_set_size_packed::index#6] = bram_heap_set_size_packed::$3 -- pbuc1_derefidx_vbuxx=vbuaa 
    // Ignore free flag.
    sta bram_heap_index+$200,x
    // bram_heap_set_size_packed::@return
    // }
    // [700] return 
    rts
  .segment Data
    size_packed: .word 0
}
.segment CodeBramHeap
  // bram_heap_set_free
// void bram_heap_set_free(char s, __register(X) char index)
bram_heap_set_free: {
    // bram_heap_index.size1[index] |= 0x80
    // [702] ((char *)&bram_heap_index+$300)[bram_heap_set_free::index#5] = ((char *)&bram_heap_index+$300)[bram_heap_set_free::index#5] | $80 -- pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_bor_vbuc2 
    lda #$80
    ora bram_heap_index+$300,x
    sta bram_heap_index+$300,x
    // bram_heap_set_free::@return
    // }
    // [703] return 
    rts
}
.segment Code
  // screenlayer1
// Set the layer with which the conio will interact.
screenlayer1: {
    // screenlayer(1, *VERA_L1_MAPBASE, *VERA_L1_CONFIG)
    // [704] screenlayer::mapbase#0 = *VERA_L1_MAPBASE -- vbuxx=_deref_pbuc1 
    ldx VERA_L1_MAPBASE
    // [705] screenlayer::config#0 = *VERA_L1_CONFIG -- vbum1=_deref_pbuc1 
    lda VERA_L1_CONFIG
    sta screenlayer.config
    // [706] call screenlayer -- call_phi_near 
    jsr screenlayer
    // screenlayer1::@return
    // }
    // [707] return 
    rts
}
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char textcolor(char color)
textcolor: {
    // __conio.color & 0xF0
    // [708] textcolor::$0 = *((char *)&__conio+$d) & $f0 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and __conio+$d
    // __conio.color & 0xF0 | color
    // [709] textcolor::$1 = textcolor::$0 | WHITE -- vbuaa=vbuaa_bor_vbuc1 
    ora #WHITE
    // __conio.color = __conio.color & 0xF0 | color
    // [710] *((char *)&__conio+$d) = textcolor::$1 -- _deref_pbuc1=vbuaa 
    sta __conio+$d
    // textcolor::@return
    // }
    // [711] return 
    rts
}
  // bgcolor
// Set the back color for text output.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor(char color)
bgcolor: {
    // __conio.color & 0x0F
    // [712] bgcolor::$0 = *((char *)&__conio+$d) & $f -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$f
    and __conio+$d
    // __conio.color & 0x0F | color << 4
    // [713] bgcolor::$2 = bgcolor::$0 | BLUE<<4 -- vbuaa=vbuaa_bor_vbuc1 
    ora #BLUE<<4
    // __conio.color = __conio.color & 0x0F | color << 4
    // [714] *((char *)&__conio+$d) = bgcolor::$2 -- _deref_pbuc1=vbuaa 
    sta __conio+$d
    // bgcolor::@return
    // }
    // [715] return 
    rts
}
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
// char cursor(char onoff)
cursor: {
    .const onoff = 0
    // __conio.cursor = onoff
    // [716] *((char *)&__conio+$c) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta __conio+$c
    // cursor::@return
    // }
    // [717] return 
    rts
}
  // cbm_k_plot_get
/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
cbm_k_plot_get: {
    // __mem unsigned char x
    // [718] cbm_k_plot_get::x = 0 -- vbum1=vbuc1 
    lda #0
    sta x
    // __mem unsigned char y
    // [719] cbm_k_plot_get::y = 0 -- vbum1=vbuc1 
    sta y
    // kickasm
    // kickasm( uses cbm_k_plot_get::x uses cbm_k_plot_get::y uses CBM_PLOT) {{ sec         jsr CBM_PLOT         stx y         sty x      }}
    sec
        jsr CBM_PLOT
        stx y
        sty x
    
    // MAKEWORD(x,y)
    // [721] cbm_k_plot_get::return#0 = cbm_k_plot_get::x w= cbm_k_plot_get::y -- vwum1=vbum2_word_vbum3 
    lda x
    sta return+1
    lda y
    sta return
    // cbm_k_plot_get::@return
    // }
    // [722] return 
    rts
  .segment Data
    x: .byte 0
    y: .byte 0
    return: .word 0
    return_1: .word 0
    return_2: .word 0
}
.segment Code
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__register(X) char x, __register(Y) char y)
gotoxy: {
    // (x>=__conio.width)?__conio.width:x
    // [724] if(gotoxy::x#10>=*((char *)&__conio+6)) goto gotoxy::@1 -- vbuxx_ge__deref_pbuc1_then_la1 
    cpx __conio+6
    bcs __b1
    // [726] phi from gotoxy gotoxy::@1 to gotoxy::@2 [phi:gotoxy/gotoxy::@1->gotoxy::@2]
    // [726] phi gotoxy::$3 = gotoxy::x#10 [phi:gotoxy/gotoxy::@1->gotoxy::@2#0] -- register_copy 
    jmp __b2
    // gotoxy::@1
  __b1:
    // [725] gotoxy::$2 = *((char *)&__conio+6) -- vbuxx=_deref_pbuc1 
    ldx __conio+6
    // gotoxy::@2
  __b2:
    // __conio.cursor_x = (x>=__conio.width)?__conio.width:x
    // [727] *((char *)&__conio) = gotoxy::$3 -- _deref_pbuc1=vbuxx 
    stx __conio
    // (y>=__conio.height)?__conio.height:y
    // [728] if(gotoxy::y#10>=*((char *)&__conio+7)) goto gotoxy::@3 -- vbuyy_ge__deref_pbuc1_then_la1 
    cpy __conio+7
    bcs __b3
    // gotoxy::@4
    // [729] gotoxy::$14 = gotoxy::y#10 -- vbuaa=vbuyy 
    tya
    // [730] phi from gotoxy::@3 gotoxy::@4 to gotoxy::@5 [phi:gotoxy::@3/gotoxy::@4->gotoxy::@5]
    // [730] phi gotoxy::$7 = gotoxy::$6 [phi:gotoxy::@3/gotoxy::@4->gotoxy::@5#0] -- register_copy 
    // gotoxy::@5
  __b5:
    // __conio.cursor_y = (y>=__conio.height)?__conio.height:y
    // [731] *((char *)&__conio+1) = gotoxy::$7 -- _deref_pbuc1=vbuaa 
    sta __conio+1
    // __conio.cursor_x << 1
    // [732] gotoxy::$8 = *((char *)&__conio) << 1 -- vbuxx=_deref_pbuc1_rol_1 
    lda __conio
    asl
    tax
    // __conio.offsets[y] + __conio.cursor_x << 1
    // [733] gotoxy::$10 = gotoxy::y#10 << 1 -- vbuaa=vbuyy_rol_1 
    tya
    asl
    // [734] gotoxy::$9 = ((unsigned int *)&__conio+$15)[gotoxy::$10] + gotoxy::$8 -- vwum1=pwuc1_derefidx_vbuaa_plus_vbuxx 
    tay
    txa
    clc
    adc __conio+$15,y
    sta gotoxy__9
    lda __conio+$15+1,y
    adc #0
    sta gotoxy__9+1
    // __conio.offset = __conio.offsets[y] + __conio.cursor_x << 1
    // [735] *((unsigned int *)&__conio+$13) = gotoxy::$9 -- _deref_pwuc1=vwum1 
    lda gotoxy__9
    sta __conio+$13
    lda gotoxy__9+1
    sta __conio+$13+1
    // gotoxy::@return
    // }
    // [736] return 
    rts
    // gotoxy::@3
  __b3:
    // (y>=__conio.height)?__conio.height:y
    // [737] gotoxy::$6 = *((char *)&__conio+7) -- vbuaa=_deref_pbuc1 
    lda __conio+7
    jmp __b5
  .segment Data
    gotoxy__9: .word 0
}
.segment Code
  // cputln
// Print a newline
cputln: {
    // __conio.cursor_x = 0
    // [738] *((char *)&__conio) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio
    // __conio.cursor_y++;
    // [739] *((char *)&__conio+1) = ++ *((char *)&__conio+1) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+1
    // __conio.offset = __conio.offsets[__conio.cursor_y]
    // [740] cputln::$3 = *((char *)&__conio+1) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda __conio+1
    asl
    // [741] *((unsigned int *)&__conio+$13) = ((unsigned int *)&__conio+$15)[cputln::$3] -- _deref_pwuc1=pwuc2_derefidx_vbuaa 
    tay
    lda __conio+$15,y
    sta __conio+$13
    lda __conio+$15+1,y
    sta __conio+$13+1
    // if(__conio.scroll[__conio.layer])
    // [742] if(0==((char *)&__conio+$f)[*((char *)&__conio+2)]) goto cputln::@return -- 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$f,y
    cmp #0
    beq __breturn
    // [743] phi from cputln to cputln::@1 [phi:cputln->cputln::@1]
    // cputln::@1
    // cscroll()
    // [744] call cscroll -- call_phi_near 
    jsr cscroll
    // cputln::@return
  __breturn:
    // }
    // [745] return 
    rts
}
.segment CodeBramHeap
  // bram_heap_alloc_size
// TODO - make long
// __mem() unsigned long bram_heap_alloc_size(__register(A) char s)
bram_heap_alloc_size: {
    // bram_heap_size_packed_t heapSize = bram_heap_segment.heapSize[s]
    // [746] bram_heap_alloc_size::$1 = bram_heap_alloc_size::s#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [747] bram_heap_alloc_size::heapSize#0 = ((unsigned int *)&bram_heap_segment+$56)[bram_heap_alloc_size::$1] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda bram_heap_segment+$56,y
    sta heapSize
    lda bram_heap_segment+$56+1,y
    sta heapSize+1
    // bram_heap_size_unpack(heapSize)
    // [748] bram_heap_size_unpack::size#1 = bram_heap_alloc_size::heapSize#0 -- vwum1=vwum2 
    lda heapSize
    sta bram_heap_size_unpack.size
    lda heapSize+1
    sta bram_heap_size_unpack.size+1
    // [749] call bram_heap_size_unpack
    // [376] phi from bram_heap_alloc_size to bram_heap_size_unpack [phi:bram_heap_alloc_size->bram_heap_size_unpack]
    // [376] phi bram_heap_size_unpack::size#7 = bram_heap_size_unpack::size#1 [phi:bram_heap_alloc_size->bram_heap_size_unpack#0] -- call_phi_near 
    jsr bram_heap_size_unpack
    // bram_heap_size_unpack(heapSize)
    // [750] bram_heap_size_unpack::return#1 = bram_heap_size_unpack::return#12 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_3
    sta bram_heap_size_unpack.return_1
    lda bram_heap_size_unpack.return_3+1
    sta bram_heap_size_unpack.return_1+1
    lda bram_heap_size_unpack.return_3+2
    sta bram_heap_size_unpack.return_1+2
    lda bram_heap_size_unpack.return_3+3
    sta bram_heap_size_unpack.return_1+3
    // bram_heap_alloc_size::@1
    // [751] bram_heap_alloc_size::return#1 = bram_heap_size_unpack::return#1 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_1
    sta return_1
    lda bram_heap_size_unpack.return_1+1
    sta return_1+1
    lda bram_heap_size_unpack.return_1+2
    sta return_1+2
    lda bram_heap_size_unpack.return_1+3
    sta return_1+3
    // bram_heap_alloc_size::@return
    // }
    // [752] return 
    rts
  .segment Data
    return: .dword 0
  .segment DataBramHeap
    heapSize: .word 0
  .segment Data
    return_1: .dword 0
}
.segment CodeBramHeap
  // bram_heap_free_size
/**
 * @brief Return the size of free heap of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_size_large
 */
// __mem() unsigned long bram_heap_free_size(__register(A) char s)
bram_heap_free_size: {
    // bram_heap_size_packed_t freeSize = bram_heap_segment.freeSize[s]
    // [753] bram_heap_free_size::$1 = bram_heap_free_size::s#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [754] bram_heap_free_size::freeSize#0 = ((unsigned int *)&bram_heap_segment+$5e)[bram_heap_free_size::$1] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda bram_heap_segment+$5e,y
    sta freeSize
    lda bram_heap_segment+$5e+1,y
    sta freeSize+1
    // bram_heap_size_unpack(freeSize)
    // [755] bram_heap_size_unpack::size#2 = bram_heap_free_size::freeSize#0 -- vwum1=vwum2 
    lda freeSize
    sta bram_heap_size_unpack.size
    lda freeSize+1
    sta bram_heap_size_unpack.size+1
    // [756] call bram_heap_size_unpack
    // [376] phi from bram_heap_free_size to bram_heap_size_unpack [phi:bram_heap_free_size->bram_heap_size_unpack]
    // [376] phi bram_heap_size_unpack::size#7 = bram_heap_size_unpack::size#2 [phi:bram_heap_free_size->bram_heap_size_unpack#0] -- call_phi_near 
    jsr bram_heap_size_unpack
    // bram_heap_size_unpack(freeSize)
    // [757] bram_heap_size_unpack::return#11 = bram_heap_size_unpack::return#12 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_3
    sta bram_heap_size_unpack.return_2
    lda bram_heap_size_unpack.return_3+1
    sta bram_heap_size_unpack.return_2+1
    lda bram_heap_size_unpack.return_3+2
    sta bram_heap_size_unpack.return_2+2
    lda bram_heap_size_unpack.return_3+3
    sta bram_heap_size_unpack.return_2+3
    // bram_heap_free_size::@1
    // [758] bram_heap_free_size::return#1 = bram_heap_size_unpack::return#11 -- vdum1=vdum2 
    lda bram_heap_size_unpack.return_2
    sta return_1
    lda bram_heap_size_unpack.return_2+1
    sta return_1+1
    lda bram_heap_size_unpack.return_2+2
    sta return_1+2
    lda bram_heap_size_unpack.return_2+3
    sta return_1+3
    // bram_heap_free_size::@return
    // }
    // [759] return 
    rts
  .segment Data
    return: .dword 0
  .segment DataBramHeap
    freeSize: .word 0
  .segment Data
    return_1: .dword 0
}
.segment CodeBramHeap
  // bram_heap_alloc_count
/**
 * @brief Return the amount of heap records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
// __mem() unsigned int bram_heap_alloc_count(__register(A) char s)
bram_heap_alloc_count: {
    // return bram_heap_segment.heapCount[s];
    // [760] bram_heap_alloc_count::$0 = bram_heap_alloc_count::s#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [761] bram_heap_alloc_count::return#1 = ((unsigned int *)&bram_heap_segment+$3e)[bram_heap_alloc_count::$0] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda bram_heap_segment+$3e,y
    sta return_1
    lda bram_heap_segment+$3e+1,y
    sta return_1+1
    // bram_heap_alloc_count::@return
    // }
    // [762] return 
    rts
  .segment Data
    return: .word 0
    return_1: .word 0
}
.segment CodeBramHeap
  // bram_heap_free_count
/**
 * @brief Return the amount of free records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
// __mem() unsigned int bram_heap_free_count(__register(A) char s)
bram_heap_free_count: {
    // return bram_heap_segment.freeCount[s];
    // [763] bram_heap_free_count::$0 = bram_heap_free_count::s#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [764] bram_heap_free_count::return#1 = ((unsigned int *)&bram_heap_segment+$46)[bram_heap_free_count::$0] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda bram_heap_segment+$46,y
    sta return_1
    lda bram_heap_segment+$46+1,y
    sta return_1+1
    // bram_heap_free_count::@return
    // }
    // [765] return 
    rts
  .segment Data
    return: .word 0
    return_1: .word 0
}
.segment CodeBramHeap
  // bram_heap_idle_count
/**
 * @brief Return the amount of idle records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
// __mem() unsigned int bram_heap_idle_count(__register(A) char s)
bram_heap_idle_count: {
    // return bram_heap_segment.idleCount[s];
    // [766] bram_heap_idle_count::$0 = bram_heap_idle_count::s#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [767] bram_heap_idle_count::return#1 = ((unsigned int *)&bram_heap_segment+$4e)[bram_heap_idle_count::$0] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda bram_heap_segment+$4e,y
    sta return_1
    lda bram_heap_segment+$4e+1,y
    sta return_1+1
    // bram_heap_idle_count::@return
    // }
    // [768] return 
    rts
  .segment Data
    return: .word 0
    return_1: .word 0
}
.segment Code
  // printf_uint
// Print an unsigned int using a specific format
// void printf_uint(void (*putc)(char), __mem() unsigned int uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, __register(X) char format_radix)
printf_uint: {
    // printf_uint::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [770] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
    // [771] utoa::value#1 = printf_uint::uvalue#6 -- vwum1=vwum2 
    lda uvalue
    sta utoa.value
    lda uvalue+1
    sta utoa.value+1
    // [772] utoa::radix#0 = printf_uint::format_radix#10
    // [773] call utoa -- call_phi_near 
    // Format number into buffer
    jsr utoa
    // printf_uint::@2
    // printf_number_buffer(putc, printf_buffer, format)
    // [774] printf_number_buffer::buffer_sign#1 = *((char *)&printf_buffer) -- vbuxx=_deref_pbuc1 
    ldx printf_buffer
    // [775] call printf_number_buffer
  // Print using format
    // [886] phi from printf_uint::@2 to printf_number_buffer [phi:printf_uint::@2->printf_number_buffer]
    // [886] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#1 [phi:printf_uint::@2->printf_number_buffer#0] -- register_copy 
    // [886] phi printf_number_buffer::format_min_length#3 = 4 [phi:printf_uint::@2->printf_number_buffer#1] -- call_phi_near 
    lda #4
    sta printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // printf_uint::@return
    // }
    // [776] return 
    rts
  .segment Data
    .label uvalue = utoa.digit_values
    .label uvalue_1 = utoa.buffer
    .label uvalue_2 = utoa_append.buffer
    uvalue_3: .word 0
}
.segment CodeBramHeap
  // bram_heap_dump_index_print
/**
 * @brief Print an index list.
 * 
 * @param prefix The chain code.
 * @param list The index list with packed next and prev pointers.
 */
// void bram_heap_dump_index_print(__mem() char s, __mem() char prefix, __mem() char list, __mem() unsigned int heap_count)
bram_heap_dump_index_print: {
    // if (list == BRAM_HEAP_NULL)
    // [778] if(bram_heap_dump_index_print::list#3!=$ff) goto bram_heap_dump_index_print::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp list
    bne __b1
    // bram_heap_dump_index_print::@return
    // }
    // [779] return 
    rts
    // bram_heap_dump_index_print::@1
  __b1:
    // [780] bram_heap_dump_index_print::index#39 = bram_heap_dump_index_print::list#3 -- vbum1=vbum2 
    lda list
    sta index
    // [781] phi from bram_heap_dump_index_print::@1 to bram_heap_dump_index_print::@2 [phi:bram_heap_dump_index_print::@1->bram_heap_dump_index_print::@2]
    // [781] phi bram_heap_dump_index_print::count#10 = 0 [phi:bram_heap_dump_index_print::@1->bram_heap_dump_index_print::@2#0] -- vwum1=vwuc1 
    lda #<0
    sta count
    sta count+1
    // [781] phi bram_heap_dump_index_print::index#12 = bram_heap_dump_index_print::index#39 [phi:bram_heap_dump_index_print::@1->bram_heap_dump_index_print::@2#1] -- register_copy 
    // [781] phi from bram_heap_dump_index_print::@5 to bram_heap_dump_index_print::@2 [phi:bram_heap_dump_index_print::@5->bram_heap_dump_index_print::@2]
    // [781] phi bram_heap_dump_index_print::count#10 = bram_heap_dump_index_print::count#1 [phi:bram_heap_dump_index_print::@5->bram_heap_dump_index_print::@2#0] -- register_copy 
    // [781] phi bram_heap_dump_index_print::index#12 = bram_heap_dump_index_print::index#1 [phi:bram_heap_dump_index_print::@5->bram_heap_dump_index_print::@2#1] -- register_copy 
    // bram_heap_dump_index_print::@2
  __b2:
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [782] gotoxy::x#8 = bramheap_dx -- vbuxx=vbum1 
    ldx bramheap_dx
    // [783] gotoxy::y#8 = bramheap_dy -- vbuyy=vbum1 
    ldy bramheap_dy
    // [784] call gotoxy
    // [723] phi from bram_heap_dump_index_print::@2 to gotoxy [phi:bram_heap_dump_index_print::@2->gotoxy]
    // [723] phi gotoxy::y#10 = gotoxy::y#8 [phi:bram_heap_dump_index_print::@2->gotoxy#0] -- register_copy 
    // [723] phi gotoxy::x#10 = gotoxy::x#8 [phi:bram_heap_dump_index_print::@2->gotoxy#1] -- call_phi_near 
    jsr gotoxy
    // bram_heap_dump_index_print::@10
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [785] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // bram_heap_is_free(s, index)
    // [786] bram_heap_is_free::index#2 = bram_heap_dump_index_print::index#12 -- vbuxx=vbum1 
    ldx index
    // [787] call bram_heap_is_free
    // [946] phi from bram_heap_dump_index_print::@10 to bram_heap_is_free [phi:bram_heap_dump_index_print::@10->bram_heap_is_free]
    // [946] phi bram_heap_is_free::index#3 = bram_heap_is_free::index#2 [phi:bram_heap_dump_index_print::@10->bram_heap_is_free#0] -- call_phi_near 
    jsr bram_heap_is_free
    // bram_heap_is_free(s, index)
    // [788] bram_heap_is_free::return#4 = bram_heap_is_free::return#0
    // bram_heap_dump_index_print::@11
    // [789] bram_heap_dump_index_print::$3 = bram_heap_is_free::return#4
    // bram_heap_is_free(s, index)?'*':' '
    // [790] if(bram_heap_dump_index_print::$3) goto bram_heap_dump_index_print::@3 -- vboaa_then_la1 
    cmp #0
    bne __b3
    // [792] phi from bram_heap_dump_index_print::@11 to bram_heap_dump_index_print::@4 [phi:bram_heap_dump_index_print::@11->bram_heap_dump_index_print::@4]
    // [792] phi bram_heap_dump_index_print::$6 = ' 'pm [phi:bram_heap_dump_index_print::@11->bram_heap_dump_index_print::@4#0] -- vbum1=vbuc1 
    lda #' '
    sta bram_heap_dump_index_print__6
    jmp __b4
    // [791] phi from bram_heap_dump_index_print::@11 to bram_heap_dump_index_print::@3 [phi:bram_heap_dump_index_print::@11->bram_heap_dump_index_print::@3]
    // bram_heap_dump_index_print::@3
  __b3:
    // bram_heap_is_free(s, index)?'*':' '
    // [792] phi from bram_heap_dump_index_print::@3 to bram_heap_dump_index_print::@4 [phi:bram_heap_dump_index_print::@3->bram_heap_dump_index_print::@4]
    // [792] phi bram_heap_dump_index_print::$6 = '*'pm [phi:bram_heap_dump_index_print::@3->bram_heap_dump_index_print::@4#0] -- vbum1=vbuc1 
    lda #'*'
    sta bram_heap_dump_index_print__6
    // bram_heap_dump_index_print::@4
  __b4:
    // printf("%03x %c%c ", index, prefix, (bram_heap_is_free(s, index)?'*':' '))
    // [793] printf_uchar::uvalue#18 = bram_heap_dump_index_print::index#12 -- vbum1=vbum2 
    lda index
    sta printf_uchar.uvalue
    // [794] call printf_uchar
    // [389] phi from bram_heap_dump_index_print::@4 to printf_uchar [phi:bram_heap_dump_index_print::@4->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_dump_index_print::@4->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#18 [phi:bram_heap_dump_index_print::@4->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [795] phi from bram_heap_dump_index_print::@4 to bram_heap_dump_index_print::@12 [phi:bram_heap_dump_index_print::@4->bram_heap_dump_index_print::@12]
    // bram_heap_dump_index_print::@12
    // printf("%03x %c%c ", index, prefix, (bram_heap_is_free(s, index)?'*':' '))
    // [796] call printf_str
    // [380] phi from bram_heap_dump_index_print::@12 to printf_str [phi:bram_heap_dump_index_print::@12->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_index_print::s1 [phi:bram_heap_dump_index_print::@12->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_index_print::@13
    // printf("%03x %c%c ", index, prefix, (bram_heap_is_free(s, index)?'*':' '))
    // [797] stackpush(char) = bram_heap_dump_index_print::prefix#11 -- _stackpushbyte_=vbum1 
    lda prefix
    pha
    // [798] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // [800] stackpush(char) = bram_heap_dump_index_print::$6 -- _stackpushbyte_=vbum1 
    lda bram_heap_dump_index_print__6
    pha
    // [801] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // [803] call printf_str
    // [380] phi from bram_heap_dump_index_print::@13 to printf_str [phi:bram_heap_dump_index_print::@13->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_index_print::s1 [phi:bram_heap_dump_index_print::@13->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_index_print::@14
    // bram_heap_data_get_bank(s, index)
    // [804] stackpush(char) = bram_heap_dump_index_print::s#10 -- _stackpushbyte_=vbum1 
    lda s
    pha
    // [805] stackpush(char) = bram_heap_dump_index_print::index#12 -- _stackpushbyte_=vbum1 
    lda index
    pha
    // [806] callexecute bram_heap_data_get_bank  -- call_vprc1 
    jsr bram_heap_data_get_bank
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf("%02x%04p %05x  ", bram_heap_data_get_bank(s, index), bram_heap_data_get_offset(s, index), bram_heap_get_size(s, index))
    // [808] printf_uchar::uvalue#19 = stackpull(char) -- vbum1=_stackpullbyte_ 
    pla
    sta printf_uchar.uvalue
    // bram_heap_data_get_offset(s, index)
    // [809] stackpush(char) = bram_heap_dump_index_print::s#10 -- _stackpushbyte_=vbum1 
    lda s
    pha
    // [810] stackpush(char) = bram_heap_dump_index_print::index#12 -- _stackpushbyte_=vbum1 
    lda index
    pha
    // [811] callexecute bram_heap_data_get_offset  -- call_vprc1 
    jsr bram_heap_data_get_offset
    // [812] printf_uint::uvalue#5 = stackpull(char *) -- pbum1=_stackpullptr_ 
    pla
    sta printf_uint.uvalue_3
    pla
    sta printf_uint.uvalue_3+1
    // bram_heap_get_size(s, index)
    // [813] stackpush(char) = bram_heap_dump_index_print::s#10 -- _stackpushbyte_=vbum1 
    lda s
    pha
    // [814] stackpush(char) = bram_heap_dump_index_print::index#12 -- _stackpushbyte_=vbum1 
    lda index
    pha
    // sideeffect stackpushpadding(2) -- _stackpushpadding_2 
    pha
    pha
    // [816] callexecute bram_heap_get_size  -- call_vprc1 
    jsr bram_heap_get_size
    // printf("%02x%04p %05x  ", bram_heap_data_get_bank(s, index), bram_heap_data_get_offset(s, index), bram_heap_get_size(s, index))
    // [817] printf_ulong::uvalue#11 = stackpull(unsigned long) -- vdum1=_stackpulldword_ 
    pla
    sta printf_ulong.uvalue
    pla
    sta printf_ulong.uvalue+1
    pla
    sta printf_ulong.uvalue+2
    pla
    sta printf_ulong.uvalue+3
    // [818] call printf_uchar
    // [389] phi from bram_heap_dump_index_print::@14 to printf_uchar [phi:bram_heap_dump_index_print::@14->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 2 [phi:bram_heap_dump_index_print::@14->printf_uchar#0] -- vbum1=vbuc1 
    lda #2
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#19 [phi:bram_heap_dump_index_print::@14->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // bram_heap_dump_index_print::@15
    // [819] printf_uint::uvalue#11 = (unsigned int)printf_uint::uvalue#5 -- vwum1=vwum2 
    lda printf_uint.uvalue_3
    sta printf_uint.uvalue
    lda printf_uint.uvalue_3+1
    sta printf_uint.uvalue+1
    // printf("%02x%04p %05x  ", bram_heap_data_get_bank(s, index), bram_heap_data_get_offset(s, index), bram_heap_get_size(s, index))
    // [820] call printf_uint
    // [769] phi from bram_heap_dump_index_print::@15 to printf_uint [phi:bram_heap_dump_index_print::@15->printf_uint]
    // [769] phi printf_uint::format_radix#10 = HEXADECIMAL [phi:bram_heap_dump_index_print::@15->printf_uint#0] -- vbuxx=vbuc1 
    ldx #HEXADECIMAL
    // [769] phi printf_uint::uvalue#6 = printf_uint::uvalue#11 [phi:bram_heap_dump_index_print::@15->printf_uint#1] -- call_phi_near 
    jsr printf_uint
    // [821] phi from bram_heap_dump_index_print::@15 to bram_heap_dump_index_print::@16 [phi:bram_heap_dump_index_print::@15->bram_heap_dump_index_print::@16]
    // bram_heap_dump_index_print::@16
    // printf("%02x%04p %05x  ", bram_heap_data_get_bank(s, index), bram_heap_data_get_offset(s, index), bram_heap_get_size(s, index))
    // [822] call printf_str
    // [380] phi from bram_heap_dump_index_print::@16 to printf_str [phi:bram_heap_dump_index_print::@16->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_index_print::s1 [phi:bram_heap_dump_index_print::@16->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // [823] phi from bram_heap_dump_index_print::@16 to bram_heap_dump_index_print::@17 [phi:bram_heap_dump_index_print::@16->bram_heap_dump_index_print::@17]
    // bram_heap_dump_index_print::@17
    // printf("%02x%04p %05x  ", bram_heap_data_get_bank(s, index), bram_heap_data_get_offset(s, index), bram_heap_get_size(s, index))
    // [824] call printf_ulong
    // [397] phi from bram_heap_dump_index_print::@17 to printf_ulong [phi:bram_heap_dump_index_print::@17->printf_ulong]
    // [397] phi printf_ulong::uvalue#12 = printf_ulong::uvalue#11 [phi:bram_heap_dump_index_print::@17->printf_ulong#0] -- call_phi_near 
    jsr printf_ulong
    // [825] phi from bram_heap_dump_index_print::@17 to bram_heap_dump_index_print::@18 [phi:bram_heap_dump_index_print::@17->bram_heap_dump_index_print::@18]
    // bram_heap_dump_index_print::@18
    // printf("%02x%04p %05x  ", bram_heap_data_get_bank(s, index), bram_heap_data_get_offset(s, index), bram_heap_get_size(s, index))
    // [826] call printf_str
    // [380] phi from bram_heap_dump_index_print::@18 to printf_str [phi:bram_heap_dump_index_print::@18->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_index_print::s4 [phi:bram_heap_dump_index_print::@18->printf_str#0] -- call_phi_near 
    lda #<s4
    sta printf_str.s
    lda #>s4
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_index_print::bram_heap_get_next1
    // return bram_heap_index.next[index];
    // [827] bram_heap_dump_index_print::bram_heap_get_next1_return#0 = ((char *)&bram_heap_index+$400)[bram_heap_dump_index_print::index#12] -- vbum1=pbuc1_derefidx_vbum2 
    ldy index
    lda bram_heap_index+$400,y
    sta bram_heap_get_next1_return
    // bram_heap_dump_index_print::bram_heap_get_prev1
    // return bram_heap_index.prev[index];
    // [828] bram_heap_dump_index_print::bram_heap_get_prev1_return#0 = ((char *)&bram_heap_index+$500)[bram_heap_dump_index_print::index#12] -- vbum1=pbuc1_derefidx_vbum2 
    lda bram_heap_index+$500,y
    sta bram_heap_get_prev1_return
    // [829] phi from bram_heap_dump_index_print::bram_heap_get_prev1 to bram_heap_dump_index_print::@7 [phi:bram_heap_dump_index_print::bram_heap_get_prev1->bram_heap_dump_index_print::@7]
    // bram_heap_dump_index_print::@7
    // printf("%03x  %03x  ", bram_heap_get_next(s, index), bram_heap_get_prev(s, index))
    // [830] call printf_uchar
    // [389] phi from bram_heap_dump_index_print::@7 to printf_uchar [phi:bram_heap_dump_index_print::@7->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_dump_index_print::@7->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = bram_heap_dump_index_print::bram_heap_get_next1_return#0 [phi:bram_heap_dump_index_print::@7->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [831] phi from bram_heap_dump_index_print::@7 to bram_heap_dump_index_print::@19 [phi:bram_heap_dump_index_print::@7->bram_heap_dump_index_print::@19]
    // bram_heap_dump_index_print::@19
    // printf("%03x  %03x  ", bram_heap_get_next(s, index), bram_heap_get_prev(s, index))
    // [832] call printf_str
    // [380] phi from bram_heap_dump_index_print::@19 to printf_str [phi:bram_heap_dump_index_print::@19->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_index_print::s4 [phi:bram_heap_dump_index_print::@19->printf_str#0] -- call_phi_near 
    lda #<s4
    sta printf_str.s
    lda #>s4
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_index_print::@20
    // [833] printf_uchar::uvalue#41 = bram_heap_dump_index_print::bram_heap_get_prev1_return#0 -- vbum1=vbum2 
    lda bram_heap_get_prev1_return
    sta printf_uchar.uvalue
    // printf("%03x  %03x  ", bram_heap_get_next(s, index), bram_heap_get_prev(s, index))
    // [834] call printf_uchar
    // [389] phi from bram_heap_dump_index_print::@20 to printf_uchar [phi:bram_heap_dump_index_print::@20->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_dump_index_print::@20->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#41 [phi:bram_heap_dump_index_print::@20->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [835] phi from bram_heap_dump_index_print::@20 to bram_heap_dump_index_print::@21 [phi:bram_heap_dump_index_print::@20->bram_heap_dump_index_print::@21]
    // bram_heap_dump_index_print::@21
    // printf("%03x  %03x  ", bram_heap_get_next(s, index), bram_heap_get_prev(s, index))
    // [836] call printf_str
    // [380] phi from bram_heap_dump_index_print::@21 to printf_str [phi:bram_heap_dump_index_print::@21->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_index_print::s4 [phi:bram_heap_dump_index_print::@21->printf_str#0] -- call_phi_near 
    lda #<s4
    sta printf_str.s
    lda #>s4
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_index_print::bram_heap_get_left1
    // return bram_heap_index.left[index];
    // [837] bram_heap_dump_index_print::bram_heap_get_left1_return#0 = ((char *)&bram_heap_index+$700)[bram_heap_dump_index_print::index#12] -- vbum1=pbuc1_derefidx_vbum2 
    ldy index
    lda bram_heap_index+$700,y
    sta bram_heap_get_left1_return
    // bram_heap_dump_index_print::bram_heap_get_right1
    // return bram_heap_index.right[index];
    // [838] bram_heap_dump_index_print::bram_heap_get_right1_return#0 = ((char *)&bram_heap_index+$600)[bram_heap_dump_index_print::index#12] -- vbum1=pbuc1_derefidx_vbum2 
    lda bram_heap_index+$600,y
    sta bram_heap_get_right1_return
    // [839] phi from bram_heap_dump_index_print::bram_heap_get_right1 to bram_heap_dump_index_print::@8 [phi:bram_heap_dump_index_print::bram_heap_get_right1->bram_heap_dump_index_print::@8]
    // bram_heap_dump_index_print::@8
    // printf("%03x  %03x", bram_heap_get_left(s, index), bram_heap_get_right(s, index))
    // [840] call printf_uchar
    // [389] phi from bram_heap_dump_index_print::@8 to printf_uchar [phi:bram_heap_dump_index_print::@8->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_dump_index_print::@8->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = bram_heap_dump_index_print::bram_heap_get_left1_return#0 [phi:bram_heap_dump_index_print::@8->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [841] phi from bram_heap_dump_index_print::@8 to bram_heap_dump_index_print::@22 [phi:bram_heap_dump_index_print::@8->bram_heap_dump_index_print::@22]
    // bram_heap_dump_index_print::@22
    // printf("%03x  %03x", bram_heap_get_left(s, index), bram_heap_get_right(s, index))
    // [842] call printf_str
    // [380] phi from bram_heap_dump_index_print::@22 to printf_str [phi:bram_heap_dump_index_print::@22->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_index_print::s4 [phi:bram_heap_dump_index_print::@22->printf_str#0] -- call_phi_near 
    lda #<s4
    sta printf_str.s
    lda #>s4
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_index_print::@23
    // [843] printf_uchar::uvalue#42 = bram_heap_dump_index_print::bram_heap_get_right1_return#0 -- vbum1=vbum2 
    lda bram_heap_get_right1_return
    sta printf_uchar.uvalue
    // printf("%03x  %03x", bram_heap_get_left(s, index), bram_heap_get_right(s, index))
    // [844] call printf_uchar
    // [389] phi from bram_heap_dump_index_print::@23 to printf_uchar [phi:bram_heap_dump_index_print::@23->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_dump_index_print::@23->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#42 [phi:bram_heap_dump_index_print::@23->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // bram_heap_dump_index_print::bram_heap_get_next2
    // return bram_heap_index.next[index];
    // [845] bram_heap_dump_index_print::index#1 = ((char *)&bram_heap_index+$400)[bram_heap_dump_index_print::index#12] -- vbum1=pbuc1_derefidx_vbum1 
    ldy index
    lda bram_heap_index+$400,y
    sta index
    // bram_heap_dump_index_print::@9
    // if(++count > heap_count && index!=end_index)
    // [846] bram_heap_dump_index_print::count#1 = ++ bram_heap_dump_index_print::count#10 -- vwum1=_inc_vwum1 
    inc count
    bne !+
    inc count+1
  !:
    // [847] if(bram_heap_dump_index_print::count#1<=bram_heap_dump_index_print::heap_count#39) goto bram_heap_dump_index_print::@5 -- vwum1_le_vwum2_then_la1 
    lda count+1
    cmp heap_count+1
    bne !+
    lda count
    cmp heap_count
    beq __b5
  !:
    bcc __b5
    // bram_heap_dump_index_print::@31
    // [848] if(bram_heap_dump_index_print::index#1!=bram_heap_dump_index_print::list#3) goto bram_heap_dump_index_print::@6 -- vbum1_neq_vbum2_then_la1 
    lda index
    cmp list
    bne __b6
    // bram_heap_dump_index_print::@5
  __b5:
    // while (index != end_index)
    // [849] if(bram_heap_dump_index_print::index#1!=bram_heap_dump_index_print::list#3) goto bram_heap_dump_index_print::@2 -- vbum1_neq_vbum2_then_la1 
    lda index
    cmp list
    beq !__b2+
    jmp __b2
  !__b2:
    rts
    // bram_heap_dump_index_print::@6
  __b6:
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [850] gotoxy::x#9 = bramheap_dx -- vbuxx=vbum1 
    ldx bramheap_dx
    // [851] gotoxy::y#9 = bramheap_dy -- vbuyy=vbum1 
    ldy bramheap_dy
    // [852] call gotoxy
    // [723] phi from bram_heap_dump_index_print::@6 to gotoxy [phi:bram_heap_dump_index_print::@6->gotoxy]
    // [723] phi gotoxy::y#10 = gotoxy::y#9 [phi:bram_heap_dump_index_print::@6->gotoxy#0] -- register_copy 
    // [723] phi gotoxy::x#10 = gotoxy::x#9 [phi:bram_heap_dump_index_print::@6->gotoxy#1] -- call_phi_near 
    jsr gotoxy
    // bram_heap_dump_index_print::@24
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [853] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // printf("ABORT i: %03x e:%03x, l:%03x\n", index, end_index, list)
    // [854] call printf_str
    // [380] phi from bram_heap_dump_index_print::@24 to printf_str [phi:bram_heap_dump_index_print::@24->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_index_print::s8 [phi:bram_heap_dump_index_print::@24->printf_str#0] -- call_phi_near 
    lda #<s8
    sta printf_str.s
    lda #>s8
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_index_print::@25
    // printf("ABORT i: %03x e:%03x, l:%03x\n", index, end_index, list)
    // [855] printf_uchar::uvalue#24 = bram_heap_dump_index_print::index#1 -- vbum1=vbum2 
    lda index
    sta printf_uchar.uvalue
    // [856] call printf_uchar
    // [389] phi from bram_heap_dump_index_print::@25 to printf_uchar [phi:bram_heap_dump_index_print::@25->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_dump_index_print::@25->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#24 [phi:bram_heap_dump_index_print::@25->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [857] phi from bram_heap_dump_index_print::@25 to bram_heap_dump_index_print::@26 [phi:bram_heap_dump_index_print::@25->bram_heap_dump_index_print::@26]
    // bram_heap_dump_index_print::@26
    // printf("ABORT i: %03x e:%03x, l:%03x\n", index, end_index, list)
    // [858] call printf_str
    // [380] phi from bram_heap_dump_index_print::@26 to printf_str [phi:bram_heap_dump_index_print::@26->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_index_print::s9 [phi:bram_heap_dump_index_print::@26->printf_str#0] -- call_phi_near 
    lda #<s9
    sta printf_str.s
    lda #>s9
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_index_print::@27
    // printf("ABORT i: %03x e:%03x, l:%03x\n", index, end_index, list)
    // [859] printf_uchar::uvalue#25 = bram_heap_dump_index_print::list#3 -- vbum1=vbum2 
    lda list
    sta printf_uchar.uvalue
    // [860] call printf_uchar
    // [389] phi from bram_heap_dump_index_print::@27 to printf_uchar [phi:bram_heap_dump_index_print::@27->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_dump_index_print::@27->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#25 [phi:bram_heap_dump_index_print::@27->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [861] phi from bram_heap_dump_index_print::@27 to bram_heap_dump_index_print::@28 [phi:bram_heap_dump_index_print::@27->bram_heap_dump_index_print::@28]
    // bram_heap_dump_index_print::@28
    // printf("ABORT i: %03x e:%03x, l:%03x\n", index, end_index, list)
    // [862] call printf_str
    // [380] phi from bram_heap_dump_index_print::@28 to printf_str [phi:bram_heap_dump_index_print::@28->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_dump_index_print::s10 [phi:bram_heap_dump_index_print::@28->printf_str#0] -- call_phi_near 
    lda #<s10
    sta printf_str.s
    lda #>s10
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_dump_index_print::@29
    // printf("ABORT i: %03x e:%03x, l:%03x\n", index, end_index, list)
    // [863] printf_uchar::uvalue#26 = bram_heap_dump_index_print::list#3 -- vbum1=vbum2 
    lda list
    sta printf_uchar.uvalue
    // [864] call printf_uchar
    // [389] phi from bram_heap_dump_index_print::@29 to printf_uchar [phi:bram_heap_dump_index_print::@29->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_dump_index_print::@29->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#26 [phi:bram_heap_dump_index_print::@29->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [865] phi from bram_heap_dump_index_print::@29 to bram_heap_dump_index_print::@30 [phi:bram_heap_dump_index_print::@29->bram_heap_dump_index_print::@30]
    // bram_heap_dump_index_print::@30
    // printf("ABORT i: %03x e:%03x, l:%03x\n", index, end_index, list)
    // [866] call printf_str
    // [380] phi from bram_heap_dump_index_print::@30 to printf_str [phi:bram_heap_dump_index_print::@30->printf_str]
    // [380] phi printf_str::s#69 = s4 [phi:bram_heap_dump_index_print::@30->printf_str#0] -- call_phi_near 
    lda #<s4
    sta printf_str.s
    lda #>s4
    sta printf_str.s+1
    jsr printf_str
    rts
  .segment DataBramHeap
    s1: .text " "
    .byte 0
    s4: .text "  "
    .byte 0
    s8: .text "ABORT i: "
    .byte 0
    s9: .text " e:"
    .byte 0
    s10: .text ", l:"
    .byte 0
    bram_heap_dump_index_print__6: .byte 0
  .segment Data
    s: .byte 0
    list: .byte 0
    heap_count: .word 0
  .segment DataBramHeap
    .label bram_heap_get_next1_return = printf_uchar.uvalue
    bram_heap_get_prev1_return: .byte 0
    .label bram_heap_get_left1_return = printf_uchar.uvalue
    bram_heap_get_right1_return: .byte 0
    index: .byte 0
    count: .word 0
  .segment Data
    prefix: .byte 0
}
.segment Code
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void uctoa(__register(X) char value, __mem() char *buffer, char radix)
uctoa: {
    // [868] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
    // [868] phi uctoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:uctoa->uctoa::@1#0] -- pbum1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta buffer+1
    // [868] phi uctoa::started#2 = 0 [phi:uctoa->uctoa::@1#1] -- vbum1=vbuc1 
    lda #0
    sta started
    // [868] phi uctoa::value#2 = uctoa::value#1 [phi:uctoa->uctoa::@1#2] -- register_copy 
    // [868] phi uctoa::digit#2 = 0 [phi:uctoa->uctoa::@1#3] -- vbum1=vbuc1 
    sta digit
    // uctoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [869] if(uctoa::digit#2<2-1) goto uctoa::@2 -- vbum1_lt_vbuc1_then_la1 
    lda digit
    cmp #2-1
    bcc __b2
    // uctoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [870] *uctoa::buffer#11 = DIGITS[uctoa::value#2] -- _deref_pbum1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy buffer
    sty.z $fe
    ldy buffer+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // *buffer++ = DIGITS[(char)value];
    // [871] uctoa::buffer#3 = ++ uctoa::buffer#11 -- pbum1=_inc_pbum1 
    inc buffer
    bne !+
    inc buffer+1
  !:
    // *buffer = 0
    // [872] *uctoa::buffer#3 = 0 -- _deref_pbum1=vbuc1 
    lda #0
    ldy buffer
    sty.z $fe
    ldy buffer+1
    sty.z $ff
    tay
    sta ($fe),y
    // uctoa::@return
    // }
    // [873] return 
    rts
    // uctoa::@2
  __b2:
    // unsigned char digit_value = digit_values[digit]
    // [874] uctoa::digit_value#0 = RADIX_HEXADECIMAL_VALUES_CHAR[uctoa::digit#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy digit
    lda RADIX_HEXADECIMAL_VALUES_CHAR,y
    sta digit_value
    // if (started || value >= digit_value)
    // [875] if(0!=uctoa::started#2) goto uctoa::@5 -- 0_neq_vbum1_then_la1 
    lda started
    bne __b5
    // uctoa::@7
    // [876] if(uctoa::value#2>=uctoa::digit_value#0) goto uctoa::@5 -- vbuxx_ge_vbum1_then_la1 
    cpx digit_value
    bcs __b5
    // [877] phi from uctoa::@7 to uctoa::@4 [phi:uctoa::@7->uctoa::@4]
    // [877] phi uctoa::buffer#14 = uctoa::buffer#11 [phi:uctoa::@7->uctoa::@4#0] -- register_copy 
    // [877] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@7->uctoa::@4#1] -- register_copy 
    // [877] phi uctoa::value#6 = uctoa::value#2 [phi:uctoa::@7->uctoa::@4#2] -- register_copy 
    // uctoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [878] uctoa::digit#1 = ++ uctoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [868] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
    // [868] phi uctoa::buffer#11 = uctoa::buffer#14 [phi:uctoa::@4->uctoa::@1#0] -- register_copy 
    // [868] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@4->uctoa::@1#1] -- register_copy 
    // [868] phi uctoa::value#2 = uctoa::value#6 [phi:uctoa::@4->uctoa::@1#2] -- register_copy 
    // [868] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@4->uctoa::@1#3] -- register_copy 
    jmp __b1
    // uctoa::@5
  __b5:
    // uctoa_append(buffer++, value, digit_value)
    // [879] uctoa_append::buffer#0 = uctoa::buffer#11 -- pbum1=pbum2 
    lda buffer
    sta uctoa_append.buffer
    lda buffer+1
    sta uctoa_append.buffer+1
    // [880] uctoa_append::value#0 = uctoa::value#2
    // [881] uctoa_append::sub#0 = uctoa::digit_value#0 -- vbum1=vbum2 
    lda digit_value
    sta uctoa_append.sub
    // [882] call uctoa_append
    // [1169] phi from uctoa::@5 to uctoa_append [phi:uctoa::@5->uctoa_append] -- call_phi_near 
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // [883] uctoa_append::return#0 = uctoa_append::value#2
    // uctoa::@6
    // value = uctoa_append(buffer++, value, digit_value)
    // [884] uctoa::value#0 = uctoa_append::return#0
    // value = uctoa_append(buffer++, value, digit_value);
    // [885] uctoa::buffer#4 = ++ uctoa::buffer#11 -- pbum1=_inc_pbum1 
    inc buffer
    bne !+
    inc buffer+1
  !:
    // [877] phi from uctoa::@6 to uctoa::@4 [phi:uctoa::@6->uctoa::@4]
    // [877] phi uctoa::buffer#14 = uctoa::buffer#4 [phi:uctoa::@6->uctoa::@4#0] -- register_copy 
    // [877] phi uctoa::started#4 = 1 [phi:uctoa::@6->uctoa::@4#1] -- vbum1=vbuc1 
    lda #1
    sta started
    // [877] phi uctoa::value#6 = uctoa::value#0 [phi:uctoa::@6->uctoa::@4#2] -- register_copy 
    jmp __b4
  .segment Data
    digit_value: .byte 0
    .label buffer = strlen.str
    digit: .byte 0
    started: .byte 0
}
.segment Code
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(void (*putc)(char), __register(X) char buffer_sign, char *buffer_digits, __mem() char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_number_buffer: {
    // if(format.min_length)
    // [887] if(0==printf_number_buffer::format_min_length#3) goto printf_number_buffer::@1 -- 0_eq_vbum1_then_la1 
    lda format_min_length
    beq __b1
    // [888] phi from printf_number_buffer to printf_number_buffer::@4 [phi:printf_number_buffer->printf_number_buffer::@4]
    // printf_number_buffer::@4
    // strlen(buffer.digits)
    // [889] call strlen
    // [1176] phi from printf_number_buffer::@4 to strlen [phi:printf_number_buffer::@4->strlen] -- call_phi_near 
    jsr strlen
    // strlen(buffer.digits)
    // [890] strlen::return#2 = strlen::len#2 -- vwum1=vwum2 
    lda strlen.len
    sta strlen.return
    lda strlen.len+1
    sta strlen.return+1
    // printf_number_buffer::@9
    // [891] printf_number_buffer::$19 = strlen::return#2
    // signed char len = (signed char)strlen(buffer.digits)
    // [892] printf_number_buffer::len#0 = (signed char)printf_number_buffer::$19 -- vbsaa=_sbyte_vwum1 
    // There is a minimum length - work out the padding
    lda printf_number_buffer__19
    // if(buffer.sign)
    // [893] if(0==printf_number_buffer::buffer_sign#10) goto printf_number_buffer::@8 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq __b8
    // printf_number_buffer::@5
    // len++;
    // [894] printf_number_buffer::len#1 = ++ printf_number_buffer::len#0 -- vbsaa=_inc_vbsaa 
    inc
    // [895] phi from printf_number_buffer::@5 printf_number_buffer::@9 to printf_number_buffer::@8 [phi:printf_number_buffer::@5/printf_number_buffer::@9->printf_number_buffer::@8]
    // [895] phi printf_number_buffer::len#2 = printf_number_buffer::len#1 [phi:printf_number_buffer::@5/printf_number_buffer::@9->printf_number_buffer::@8#0] -- register_copy 
    // printf_number_buffer::@8
  __b8:
    // padding = (signed char)format.min_length - len
    // [896] printf_number_buffer::padding#1 = (signed char)printf_number_buffer::format_min_length#3 - printf_number_buffer::len#2 -- vbsm1=vbsm2_minus_vbsaa 
    eor #$ff
    sec
    adc format_min_length
    sta padding
    // if(padding<0)
    // [897] if(printf_number_buffer::padding#1>=0) goto printf_number_buffer::@11 -- vbsm1_ge_0_then_la1 
    cmp #0
    bpl __b2
    // [899] phi from printf_number_buffer printf_number_buffer::@8 to printf_number_buffer::@1 [phi:printf_number_buffer/printf_number_buffer::@8->printf_number_buffer::@1]
  __b1:
    // [899] phi printf_number_buffer::padding#10 = 0 [phi:printf_number_buffer/printf_number_buffer::@8->printf_number_buffer::@1#0] -- vbsm1=vbsc1 
    lda #0
    sta padding
    // [898] phi from printf_number_buffer::@8 to printf_number_buffer::@11 [phi:printf_number_buffer::@8->printf_number_buffer::@11]
    // printf_number_buffer::@11
    // [899] phi from printf_number_buffer::@11 to printf_number_buffer::@1 [phi:printf_number_buffer::@11->printf_number_buffer::@1]
    // [899] phi printf_number_buffer::padding#10 = printf_number_buffer::padding#1 [phi:printf_number_buffer::@11->printf_number_buffer::@1#0] -- register_copy 
    // printf_number_buffer::@1
    // printf_number_buffer::@2
  __b2:
    // if(buffer.sign)
    // [900] if(0==printf_number_buffer::buffer_sign#10) goto printf_number_buffer::@10 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq __b10
    // printf_number_buffer::@6
    // putc(buffer.sign)
    // [901] stackpush(char) = printf_number_buffer::buffer_sign#10 -- _stackpushbyte_=vbuxx 
    txa
    pha
    // [902] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_number_buffer::@10
  __b10:
    // if(format.zero_padding && padding)
    // [904] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@7 -- 0_neq_vbsm1_then_la1 
    lda padding
    cmp #0
    bne __b7
    // [907] phi from printf_number_buffer::@10 printf_number_buffer::@7 to printf_number_buffer::@3 [phi:printf_number_buffer::@10/printf_number_buffer::@7->printf_number_buffer::@3]
    jmp __b3
    // printf_number_buffer::@7
  __b7:
    // printf_padding(putc, '0',(char)padding)
    // [905] printf_padding::length#1 = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [906] call printf_padding
    // [1182] phi from printf_number_buffer::@7 to printf_padding [phi:printf_number_buffer::@7->printf_padding] -- call_phi_near 
    jsr printf_padding
    // printf_number_buffer::@3
  __b3:
    // printf_str(putc, buffer.digits)
    // [908] call printf_str
    // [380] phi from printf_number_buffer::@3 to printf_str [phi:printf_number_buffer::@3->printf_str]
    // [380] phi printf_str::s#69 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:printf_number_buffer::@3->printf_str#0] -- call_phi_near 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta printf_str.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta printf_str.s+1
    jsr printf_str
    // printf_number_buffer::@return
    // }
    // [909] return 
    rts
  .segment Data
    .label printf_number_buffer__19 = strlen.str
    format_min_length: .byte 0
    padding: .byte 0
}
.segment Code
  // ultoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void ultoa(__mem() unsigned long value, __mem() char *buffer, char radix)
ultoa: {
    // [911] phi from ultoa to ultoa::@1 [phi:ultoa->ultoa::@1]
    // [911] phi ultoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:ultoa->ultoa::@1#0] -- pbum1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta buffer+1
    // [911] phi ultoa::started#2 = 0 [phi:ultoa->ultoa::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [911] phi ultoa::value#2 = ultoa::value#1 [phi:ultoa->ultoa::@1#2] -- register_copy 
    // [911] phi ultoa::digit#2 = 0 [phi:ultoa->ultoa::@1#3] -- vbum1=vbuc1 
    txa
    sta digit
    // ultoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [912] if(ultoa::digit#2<8-1) goto ultoa::@2 -- vbum1_lt_vbuc1_then_la1 
    lda digit
    cmp #8-1
    bcc __b2
    // ultoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [913] ultoa::$11 = (char)ultoa::value#2 -- vbuaa=_byte_vdum1 
    lda value
    // [914] *ultoa::buffer#11 = DIGITS[ultoa::$11] -- _deref_pbum1=pbuc1_derefidx_vbuaa 
    tay
    lda DIGITS,y
    ldy buffer
    sty.z $fe
    ldy buffer+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // *buffer++ = DIGITS[(char)value];
    // [915] ultoa::buffer#3 = ++ ultoa::buffer#11 -- pbum1=_inc_pbum1 
    inc buffer
    bne !+
    inc buffer+1
  !:
    // *buffer = 0
    // [916] *ultoa::buffer#3 = 0 -- _deref_pbum1=vbuc1 
    lda #0
    ldy buffer
    sty.z $fe
    ldy buffer+1
    sty.z $ff
    tay
    sta ($fe),y
    // ultoa::@return
    // }
    // [917] return 
    rts
    // ultoa::@2
  __b2:
    // unsigned long digit_value = digit_values[digit]
    // [918] ultoa::$10 = ultoa::digit#2 << 2 -- vbuaa=vbum1_rol_2 
    lda digit
    asl
    asl
    // [919] ultoa::digit_value#0 = RADIX_HEXADECIMAL_VALUES_LONG[ultoa::$10] -- vdum1=pduc1_derefidx_vbuaa 
    tay
    lda RADIX_HEXADECIMAL_VALUES_LONG,y
    sta digit_value
    lda RADIX_HEXADECIMAL_VALUES_LONG+1,y
    sta digit_value+1
    lda RADIX_HEXADECIMAL_VALUES_LONG+2,y
    sta digit_value+2
    lda RADIX_HEXADECIMAL_VALUES_LONG+3,y
    sta digit_value+3
    // if (started || value >= digit_value)
    // [920] if(0!=ultoa::started#2) goto ultoa::@5 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b5
    // ultoa::@7
    // [921] if(ultoa::value#2>=ultoa::digit_value#0) goto ultoa::@5 -- vdum1_ge_vdum2_then_la1 
    lda value+3
    cmp digit_value+3
    bcc !+
    bne __b5
    lda value+2
    cmp digit_value+2
    bcc !+
    bne __b5
    lda value+1
    cmp digit_value+1
    bcc !+
    bne __b5
    lda value
    cmp digit_value
    bcs __b5
  !:
    // [922] phi from ultoa::@7 to ultoa::@4 [phi:ultoa::@7->ultoa::@4]
    // [922] phi ultoa::buffer#14 = ultoa::buffer#11 [phi:ultoa::@7->ultoa::@4#0] -- register_copy 
    // [922] phi ultoa::started#4 = ultoa::started#2 [phi:ultoa::@7->ultoa::@4#1] -- register_copy 
    // [922] phi ultoa::value#6 = ultoa::value#2 [phi:ultoa::@7->ultoa::@4#2] -- register_copy 
    // ultoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [923] ultoa::digit#1 = ++ ultoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [911] phi from ultoa::@4 to ultoa::@1 [phi:ultoa::@4->ultoa::@1]
    // [911] phi ultoa::buffer#11 = ultoa::buffer#14 [phi:ultoa::@4->ultoa::@1#0] -- register_copy 
    // [911] phi ultoa::started#2 = ultoa::started#4 [phi:ultoa::@4->ultoa::@1#1] -- register_copy 
    // [911] phi ultoa::value#2 = ultoa::value#6 [phi:ultoa::@4->ultoa::@1#2] -- register_copy 
    // [911] phi ultoa::digit#2 = ultoa::digit#1 [phi:ultoa::@4->ultoa::@1#3] -- register_copy 
    jmp __b1
    // ultoa::@5
  __b5:
    // ultoa_append(buffer++, value, digit_value)
    // [924] ultoa_append::buffer#0 = ultoa::buffer#11 -- pbum1=pbum2 
    lda buffer
    sta ultoa_append.buffer
    lda buffer+1
    sta ultoa_append.buffer+1
    // [925] ultoa_append::value#0 = ultoa::value#2 -- vdum1=vdum2 
    lda value
    sta ultoa_append.value
    lda value+1
    sta ultoa_append.value+1
    lda value+2
    sta ultoa_append.value+2
    lda value+3
    sta ultoa_append.value+3
    // [926] ultoa_append::sub#0 = ultoa::digit_value#0 -- vdum1=vdum2 
    lda digit_value
    sta ultoa_append.sub
    lda digit_value+1
    sta ultoa_append.sub+1
    lda digit_value+2
    sta ultoa_append.sub+2
    lda digit_value+3
    sta ultoa_append.sub+3
    // [927] call ultoa_append
    // [1190] phi from ultoa::@5 to ultoa_append [phi:ultoa::@5->ultoa_append] -- call_phi_near 
    jsr ultoa_append
    // ultoa_append(buffer++, value, digit_value)
    // [928] ultoa_append::return#0 = ultoa_append::value#2 -- vdum1=vdum2 
    lda ultoa_append.value
    sta ultoa_append.return
    lda ultoa_append.value+1
    sta ultoa_append.return+1
    lda ultoa_append.value+2
    sta ultoa_append.return+2
    lda ultoa_append.value+3
    sta ultoa_append.return+3
    // ultoa::@6
    // value = ultoa_append(buffer++, value, digit_value)
    // [929] ultoa::value#0 = ultoa_append::return#0 -- vdum1=vdum2 
    lda ultoa_append.return
    sta value
    lda ultoa_append.return+1
    sta value+1
    lda ultoa_append.return+2
    sta value+2
    lda ultoa_append.return+3
    sta value+3
    // value = ultoa_append(buffer++, value, digit_value);
    // [930] ultoa::buffer#4 = ++ ultoa::buffer#11 -- pbum1=_inc_pbum1 
    inc buffer
    bne !+
    inc buffer+1
  !:
    // [922] phi from ultoa::@6 to ultoa::@4 [phi:ultoa::@6->ultoa::@4]
    // [922] phi ultoa::buffer#14 = ultoa::buffer#4 [phi:ultoa::@6->ultoa::@4#0] -- register_copy 
    // [922] phi ultoa::started#4 = 1 [phi:ultoa::@6->ultoa::@4#1] -- vbuxx=vbuc1 
    ldx #1
    // [922] phi ultoa::value#6 = ultoa::value#0 [phi:ultoa::@6->ultoa::@4#2] -- register_copy 
    jmp __b4
  .segment Data
    digit_value: .dword 0
    .label buffer = strlen.str
    digit: .byte 0
    value: .dword 0
}
.segment CodeBramHeap
  // bram_heap_list_remove
/**
* Remove header from List
*/
// __register(A) char bram_heap_list_remove(char s, __register(X) char list, __mem() char index)
bram_heap_list_remove: {
    .const bram_heap_set_next2_next = $ff
    .const bram_heap_set_prev2_prev = $ff
    // if(list == BRAM_HEAP_NULL)
    // [932] if(bram_heap_list_remove::list#10!=$ff) goto bram_heap_list_remove::bram_heap_get_next1 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$ff
    bne bram_heap_get_next1
    // [933] phi from bram_heap_list_remove bram_heap_list_remove::bram_heap_set_prev2 to bram_heap_list_remove::@return [phi:bram_heap_list_remove/bram_heap_list_remove::bram_heap_set_prev2->bram_heap_list_remove::@return]
  __b2:
    // [933] phi bram_heap_list_remove::return#1 = $ff [phi:bram_heap_list_remove/bram_heap_list_remove::bram_heap_set_prev2->bram_heap_list_remove::@return#0] -- vbuxx=vbuc1 
    ldx #$ff
    // bram_heap_list_remove::@return
  __breturn:
    // }
    // [934] return 
    rts
    // bram_heap_list_remove::bram_heap_get_next1
  bram_heap_get_next1:
    // return bram_heap_index.next[index];
    // [935] bram_heap_list_remove::bram_heap_get_next1_return#0 = ((char *)&bram_heap_index+$400)[bram_heap_list_remove::list#10] -- vbuyy=pbuc1_derefidx_vbuxx 
    ldy bram_heap_index+$400,x
    // bram_heap_list_remove::@2
    // if(list == bram_heap_get_next(s, list))
    // [936] if(bram_heap_list_remove::list#10!=bram_heap_list_remove::bram_heap_get_next1_return#0) goto bram_heap_list_remove::bram_heap_get_next2 -- vbuxx_neq_vbuyy_then_la1 
    stx.z $ff
    cpy.z $ff
    bne bram_heap_get_next2
    // bram_heap_list_remove::bram_heap_set_next2
    // bram_heap_index.next[index] = next
    // [937] ((char *)&bram_heap_index+$400)[bram_heap_list_remove::index#10] = bram_heap_list_remove::bram_heap_set_next2_next#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #bram_heap_set_next2_next
    ldy index
    sta bram_heap_index+$400,y
    // bram_heap_list_remove::bram_heap_set_prev2
    // bram_heap_index.prev[index] = prev
    // [938] ((char *)&bram_heap_index+$500)[bram_heap_list_remove::index#10] = bram_heap_list_remove::bram_heap_set_prev2_prev#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #bram_heap_set_prev2_prev
    sta bram_heap_index+$500,y
    jmp __b2
    // bram_heap_list_remove::bram_heap_get_next2
  bram_heap_get_next2:
    // return bram_heap_index.next[index];
    // [939] bram_heap_list_remove::next#0 = ((char *)&bram_heap_index+$400)[bram_heap_list_remove::index#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy index
    lda bram_heap_index+$400,y
    sta next
    // bram_heap_list_remove::bram_heap_get_prev1
    // return bram_heap_index.prev[index];
    // [940] bram_heap_list_remove::bram_heap_get_prev1_return#0 = ((char *)&bram_heap_index+$500)[bram_heap_list_remove::index#10] -- vbum1=pbuc1_derefidx_vbum2 
    lda bram_heap_index+$500,y
    sta bram_heap_get_prev1_return
    // bram_heap_list_remove::bram_heap_set_next1
    // bram_heap_index.next[index] = next
    // [941] ((char *)&bram_heap_index+$400)[bram_heap_list_remove::bram_heap_get_prev1_return#0] = bram_heap_list_remove::next#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda next
    ldy bram_heap_get_prev1_return
    sta bram_heap_index+$400,y
    // bram_heap_list_remove::bram_heap_set_prev1
    // bram_heap_index.prev[index] = prev
    // [942] ((char *)&bram_heap_index+$500)[bram_heap_list_remove::next#0] = bram_heap_list_remove::bram_heap_get_prev1_return#0 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy next
    sta bram_heap_index+$500,y
    // bram_heap_list_remove::@3
    // if(index == list)
    // [943] if(bram_heap_list_remove::index#10!=bram_heap_list_remove::list#10) goto bram_heap_list_remove::@1 -- vbum1_neq_vbuxx_then_la1 
    cpx index
    bne __breturn
    // bram_heap_list_remove::bram_heap_get_next3
    // return bram_heap_index.next[index];
    // [944] bram_heap_list_remove::bram_heap_get_next3_return#0 = ((char *)&bram_heap_index+$400)[bram_heap_list_remove::list#10] -- vbuxx=pbuc1_derefidx_vbuxx 
    lda bram_heap_index+$400,x
    tax
    // [945] phi from bram_heap_list_remove::@3 bram_heap_list_remove::bram_heap_get_next3 to bram_heap_list_remove::@1 [phi:bram_heap_list_remove::@3/bram_heap_list_remove::bram_heap_get_next3->bram_heap_list_remove::@1]
    // [945] phi bram_heap_list_remove::return#3 = bram_heap_list_remove::list#10 [phi:bram_heap_list_remove::@3/bram_heap_list_remove::bram_heap_get_next3->bram_heap_list_remove::@1#0] -- register_copy 
    // bram_heap_list_remove::@1
    // [933] phi from bram_heap_list_remove::@1 to bram_heap_list_remove::@return [phi:bram_heap_list_remove::@1->bram_heap_list_remove::@return]
    // [933] phi bram_heap_list_remove::return#1 = bram_heap_list_remove::return#3 [phi:bram_heap_list_remove::@1->bram_heap_list_remove::@return#0] -- register_copy 
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
    // [947] bram_heap_is_free::$0 = ((char *)&bram_heap_index+$300)[bram_heap_is_free::index#3] & $80 -- vbuaa=pbuc1_derefidx_vbuxx_band_vbuc2 
    lda #$80
    and bram_heap_index+$300,x
    // (bram_heap_index.size1[index] & 0x80) == 0x80
    // [948] bram_heap_is_free::return#0 = bram_heap_is_free::$0 == $80 -- vboaa=vbuaa_eq_vbuc1 
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // bram_heap_is_free::@return
    // }
    // [949] return 
    rts
}
.segment Code
  // printf_string
// Print a string value using a specific format
// Handles justification and min length 
// void printf_string(void (*putc)(char), __mem() char *str, char format_min_length, char format_justify_left)
printf_string: {
    // printf_string::@1
    // printf_str(putc, str)
    // [951] printf_str::s#2 = printf_string::str#2 -- pbum1=pbum2 
    lda str
    sta printf_str.s
    lda str+1
    sta printf_str.s+1
    // [952] call printf_str
    // [380] phi from printf_string::@1 to printf_str [phi:printf_string::@1->printf_str]
    // [380] phi printf_str::s#69 = printf_str::s#2 [phi:printf_string::@1->printf_str#0] -- call_phi_near 
    jsr printf_str
    // printf_string::@return
    // }
    // [953] return 
    rts
  .segment Data
    str: .word 0
}
.segment CodeBramHeap
  // bram_heap_free_remove
// void bram_heap_free_remove(__mem() char s, __mem() char free_index)
bram_heap_free_remove: {
    // bram_heap_segment.freeCount[s]--;
    // [955] bram_heap_free_remove::$4 = bram_heap_free_remove::s#2 << 1 -- vbuaa=vbum1_rol_1 
    lda s
    asl
    // [956] ((unsigned int *)&bram_heap_segment+$46)[bram_heap_free_remove::$4] = -- ((unsigned int *)&bram_heap_segment+$46)[bram_heap_free_remove::$4] -- pwuc1_derefidx_vbuaa=_dec_pwuc1_derefidx_vbuaa 
    tax
    lda bram_heap_segment+$46,x
    bne !+
    dec bram_heap_segment+$46+1,x
  !:
    dec bram_heap_segment+$46,x
    // bram_heap_list_remove(s, bram_heap_segment.free_list[s], free_index)
    // [957] bram_heap_list_remove::list#3 = ((char *)&bram_heap_segment+$2e)[bram_heap_free_remove::s#2] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$2e,y
    // [958] bram_heap_list_remove::index#1 = bram_heap_free_remove::free_index#2 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_list_remove.index
    // [959] call bram_heap_list_remove
    // [931] phi from bram_heap_free_remove to bram_heap_list_remove [phi:bram_heap_free_remove->bram_heap_list_remove]
    // [931] phi bram_heap_list_remove::index#10 = bram_heap_list_remove::index#1 [phi:bram_heap_free_remove->bram_heap_list_remove#0] -- register_copy 
    // [931] phi bram_heap_list_remove::list#10 = bram_heap_list_remove::list#3 [phi:bram_heap_free_remove->bram_heap_list_remove#1] -- call_phi_near 
    jsr bram_heap_list_remove
    // bram_heap_list_remove(s, bram_heap_segment.free_list[s], free_index)
    // [960] bram_heap_list_remove::return#5 = bram_heap_list_remove::return#1 -- vbuaa=vbuxx 
    txa
    // bram_heap_free_remove::@1
    // [961] bram_heap_free_remove::$1 = bram_heap_list_remove::return#5
    // bram_heap_segment.free_list[s] = bram_heap_list_remove(s, bram_heap_segment.free_list[s], free_index)
    // [962] ((char *)&bram_heap_segment+$2e)[bram_heap_free_remove::s#2] = bram_heap_free_remove::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy s
    sta bram_heap_segment+$2e,y
    // bram_heap_clear_free(s, free_index)
    // [963] bram_heap_clear_free::index#0 = bram_heap_free_remove::free_index#2 -- vbuxx=vbum1 
    ldx free_index
    // [964] call bram_heap_clear_free
    // [1197] phi from bram_heap_free_remove::@1 to bram_heap_clear_free [phi:bram_heap_free_remove::@1->bram_heap_clear_free]
    // [1197] phi bram_heap_clear_free::index#2 = bram_heap_clear_free::index#0 [phi:bram_heap_free_remove::@1->bram_heap_clear_free#0] -- call_phi_near 
    jsr bram_heap_clear_free
    // bram_heap_free_remove::@return
    // }
    // [965] return 
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
    // [966] bram_heap_list_insert_at::list#4 = ((char *)&bram_heap_segment+$32)[bram_heap_idle_insert::s#0] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$32,y
    // [967] bram_heap_list_insert_at::index#3 = bram_heap_idle_insert::idle_index#0 -- vbum1=vbum2 
    lda idle_index
    sta bram_heap_list_insert_at.index
    // [968] bram_heap_list_insert_at::at#4 = ((char *)&bram_heap_segment+$32)[bram_heap_idle_insert::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda bram_heap_segment+$32,y
    sta bram_heap_list_insert_at.at
    // [969] call bram_heap_list_insert_at
    // [671] phi from bram_heap_idle_insert to bram_heap_list_insert_at [phi:bram_heap_idle_insert->bram_heap_list_insert_at]
    // [671] phi bram_heap_list_insert_at::index#10 = bram_heap_list_insert_at::index#3 [phi:bram_heap_idle_insert->bram_heap_list_insert_at#0] -- register_copy 
    // [671] phi bram_heap_list_insert_at::at#11 = bram_heap_list_insert_at::at#4 [phi:bram_heap_idle_insert->bram_heap_list_insert_at#1] -- register_copy 
    // [671] phi bram_heap_list_insert_at::list#5 = bram_heap_list_insert_at::list#4 [phi:bram_heap_idle_insert->bram_heap_list_insert_at#2] -- call_phi_near 
    jsr bram_heap_list_insert_at
    // bram_heap_list_insert_at(s, bram_heap_segment.idle_list[s], idle_index, bram_heap_segment.idle_list[s])
    // [970] bram_heap_list_insert_at::return#10 = bram_heap_list_insert_at::list#11 -- vbuaa=vbuxx 
    txa
    // bram_heap_idle_insert::@1
    // [971] bram_heap_idle_insert::$0 = bram_heap_list_insert_at::return#10
    // bram_heap_segment.idle_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.idle_list[s], idle_index, bram_heap_segment.idle_list[s])
    // [972] ((char *)&bram_heap_segment+$32)[bram_heap_idle_insert::s#0] = bram_heap_idle_insert::$0 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy s
    sta bram_heap_segment+$32,y
    // bram_heap_set_data_packed(s, idle_index, 0)
    // [973] bram_heap_set_data_packed::index#2 = bram_heap_idle_insert::idle_index#0 -- vbuxx=vbum1 
    ldx idle_index
    // [974] call bram_heap_set_data_packed
    // [686] phi from bram_heap_idle_insert::@1 to bram_heap_set_data_packed [phi:bram_heap_idle_insert::@1->bram_heap_set_data_packed]
    // [686] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#2 [phi:bram_heap_idle_insert::@1->bram_heap_set_data_packed#0] -- register_copy 
    // [686] phi bram_heap_set_data_packed::data_packed#7 = 0 [phi:bram_heap_idle_insert::@1->bram_heap_set_data_packed#1] -- call_phi_near 
    lda #<0
    sta bram_heap_set_data_packed.data_packed
    sta bram_heap_set_data_packed.data_packed+1
    jsr bram_heap_set_data_packed
    // bram_heap_idle_insert::@2
    // bram_heap_set_size_packed(s, idle_index, 0)
    // [975] bram_heap_set_size_packed::index#3 = bram_heap_idle_insert::idle_index#0 -- vbuxx=vbum1 
    ldx idle_index
    // [976] call bram_heap_set_size_packed
    // [692] phi from bram_heap_idle_insert::@2 to bram_heap_set_size_packed [phi:bram_heap_idle_insert::@2->bram_heap_set_size_packed]
    // [692] phi bram_heap_set_size_packed::size_packed#6 = 0 [phi:bram_heap_idle_insert::@2->bram_heap_set_size_packed#0] -- vwum1=vbuc1 
    lda #<0
    sta bram_heap_set_size_packed.size_packed
    sta bram_heap_set_size_packed.size_packed+1
    // [692] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#3 [phi:bram_heap_idle_insert::@2->bram_heap_set_size_packed#1] -- call_phi_near 
    jsr bram_heap_set_size_packed
    // bram_heap_idle_insert::@3
    // bram_heap_segment.idleCount[s]++;
    // [977] bram_heap_idle_insert::$5 = bram_heap_idle_insert::s#0 << 1 -- vbuaa=vbum1_rol_1 
    lda s
    asl
    // [978] ((unsigned int *)&bram_heap_segment+$4e)[bram_heap_idle_insert::$5] = ++ ((unsigned int *)&bram_heap_segment+$4e)[bram_heap_idle_insert::$5] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc bram_heap_segment+$4e,x
    bne !+
    inc bram_heap_segment+$4e+1,x
  !:
    // bram_heap_idle_insert::@return
    // }
    // [979] return 
    rts
  .segment Data
    s: .byte 0
    idle_index: .byte 0
}
.segment CodeBramHeap
  // bram_heap_size_pack
// __mem() unsigned int bram_heap_size_pack(__mem() unsigned long size)
bram_heap_size_pack: {
    // BYTE2(size)
    // [980] bram_heap_size_pack::$0 = byte2  bram_heap_size_pack::size#0 -- vbuaa=_byte2_vdum1 
    lda size+2
    // BYTE2(size)<<2
    // [981] bram_heap_size_pack::$1 = bram_heap_size_pack::$0 << 2 -- vbuaa=vbuaa_rol_2 
    asl
    asl
    // (bram_heap_size_packed_t)MAKEWORD(BYTE2(size)<<2, 0) | (WORD0(size) >> 3)
    // [982] bram_heap_size_pack::$6 = bram_heap_size_pack::$1 w= 0 -- vwum1=vbuaa_word_vbuc1 
    ldy #0
    sta bram_heap_size_pack__6+1
    sty bram_heap_size_pack__6
    // WORD0(size)
    // [983] bram_heap_size_pack::$3 = word0  bram_heap_size_pack::size#0 -- vwum1=_word0_vdum2 
    lda size
    sta bram_heap_size_pack__3
    lda size+1
    sta bram_heap_size_pack__3+1
    // WORD0(size) >> 3
    // [984] bram_heap_size_pack::$4 = bram_heap_size_pack::$3 >> 3 -- vwum1=vwum2_ror_3 
    lsr
    sta bram_heap_size_pack__4+1
    lda bram_heap_size_pack__3
    ror
    sta bram_heap_size_pack__4
    lsr bram_heap_size_pack__4+1
    ror bram_heap_size_pack__4
    lsr bram_heap_size_pack__4+1
    ror bram_heap_size_pack__4
    // (bram_heap_size_packed_t)MAKEWORD(BYTE2(size)<<2, 0) | (WORD0(size) >> 3)
    // [985] bram_heap_size_pack::return#0 = bram_heap_size_pack::$6 | bram_heap_size_pack::$4 -- vwum1=vwum2_bor_vwum3 
    tya
    ora bram_heap_size_pack__4
    sta return
    lda bram_heap_size_pack__6+1
    ora bram_heap_size_pack__4+1
    sta return+1
    // bram_heap_size_pack::@return
    // }
    // [986] return 
    rts
  .segment DataBramHeap
    bram_heap_size_pack__3: .word 0
    bram_heap_size_pack__4: .word 0
    bram_heap_size_pack__6: .word 0
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
    // [987] bram_heap_get_size_packed::index#2 = bram_heap_replace_free_with_heap::return#2 -- vbuxx=vbum1 
    ldx return
    // [988] call bram_heap_get_size_packed
    // [275] phi from bram_heap_replace_free_with_heap to bram_heap_get_size_packed [phi:bram_heap_replace_free_with_heap->bram_heap_get_size_packed]
    // [275] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#2 [phi:bram_heap_replace_free_with_heap->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_replace_free_with_heap::@3
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [989] bram_heap_get_data_packed::index#2 = bram_heap_replace_free_with_heap::return#2 -- vbuxx=vbum1 
    ldx return
    // [990] call bram_heap_get_data_packed
    // [279] phi from bram_heap_replace_free_with_heap::@3 to bram_heap_get_data_packed [phi:bram_heap_replace_free_with_heap::@3->bram_heap_get_data_packed]
    // [279] phi bram_heap_get_data_packed::index#9 = bram_heap_get_data_packed::index#2 [phi:bram_heap_replace_free_with_heap::@3->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [991] bram_heap_get_data_packed::return#14 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_4
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_4+1
    // bram_heap_replace_free_with_heap::@4
    // [992] bram_heap_replace_free_with_heap::free_data#0 = bram_heap_get_data_packed::return#14 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_4
    sta free_data
    lda bram_heap_get_data_packed.return_4+1
    sta free_data+1
    // bram_heap_replace_free_with_heap::bram_heap_get_left1
    // return bram_heap_index.left[index];
    // [993] bram_heap_replace_free_with_heap::free_left#0 = ((char *)&bram_heap_index+$700)[bram_heap_replace_free_with_heap::return#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy return
    lda bram_heap_index+$700,y
    sta free_left
    // bram_heap_replace_free_with_heap::bram_heap_get_right1
    // return bram_heap_index.right[index];
    // [994] bram_heap_replace_free_with_heap::free_right#0 = ((char *)&bram_heap_index+$600)[bram_heap_replace_free_with_heap::return#2] -- vbum1=pbuc1_derefidx_vbum2 
    lda bram_heap_index+$600,y
    sta free_right
    // bram_heap_replace_free_with_heap::@1
    // bram_heap_free_remove(s, free_index)
    // [995] bram_heap_free_remove::s#0 = bram_heap_replace_free_with_heap::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_free_remove.s
    // [996] bram_heap_free_remove::free_index#0 = bram_heap_replace_free_with_heap::return#2 -- vbum1=vbum2 
    tya
    sta bram_heap_free_remove.free_index
    // [997] call bram_heap_free_remove
    // [954] phi from bram_heap_replace_free_with_heap::@1 to bram_heap_free_remove [phi:bram_heap_replace_free_with_heap::@1->bram_heap_free_remove]
    // [954] phi bram_heap_free_remove::free_index#2 = bram_heap_free_remove::free_index#0 [phi:bram_heap_replace_free_with_heap::@1->bram_heap_free_remove#0] -- register_copy 
    // [954] phi bram_heap_free_remove::s#2 = bram_heap_free_remove::s#0 [phi:bram_heap_replace_free_with_heap::@1->bram_heap_free_remove#1] -- call_phi_near 
    jsr bram_heap_free_remove
    // bram_heap_replace_free_with_heap::@5
    // bram_heap_heap_insert_at(s, heap_index, BRAM_HEAP_NULL, required_size)
    // [998] bram_heap_heap_insert_at::s#0 = bram_heap_replace_free_with_heap::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_heap_insert_at.s
    // [999] bram_heap_heap_insert_at::heap_index#0 = bram_heap_replace_free_with_heap::return#2 -- vbum1=vbum2 
    lda return
    sta bram_heap_heap_insert_at.heap_index
    // [1000] bram_heap_heap_insert_at::size#0 = bram_heap_replace_free_with_heap::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta bram_heap_heap_insert_at.size
    lda required_size+1
    sta bram_heap_heap_insert_at.size+1
    // [1001] call bram_heap_heap_insert_at
    // [1200] phi from bram_heap_replace_free_with_heap::@5 to bram_heap_heap_insert_at [phi:bram_heap_replace_free_with_heap::@5->bram_heap_heap_insert_at]
    // [1200] phi bram_heap_heap_insert_at::size#2 = bram_heap_heap_insert_at::size#0 [phi:bram_heap_replace_free_with_heap::@5->bram_heap_heap_insert_at#0] -- register_copy 
    // [1200] phi bram_heap_heap_insert_at::heap_index#2 = bram_heap_heap_insert_at::heap_index#0 [phi:bram_heap_replace_free_with_heap::@5->bram_heap_heap_insert_at#1] -- register_copy 
    // [1200] phi bram_heap_heap_insert_at::s#2 = bram_heap_heap_insert_at::s#0 [phi:bram_heap_replace_free_with_heap::@5->bram_heap_heap_insert_at#2] -- call_phi_near 
    jsr bram_heap_heap_insert_at
    // bram_heap_replace_free_with_heap::@6
    // bram_heap_set_data_packed(s, heap_index, free_data)
    // [1002] bram_heap_set_data_packed::index#3 = bram_heap_replace_free_with_heap::return#2 -- vbuxx=vbum1 
    ldx return
    // [1003] bram_heap_set_data_packed::data_packed#3 = bram_heap_replace_free_with_heap::free_data#0 -- vwum1=vwum2 
    lda free_data
    sta bram_heap_set_data_packed.data_packed
    lda free_data+1
    sta bram_heap_set_data_packed.data_packed+1
    // [1004] call bram_heap_set_data_packed
    // [686] phi from bram_heap_replace_free_with_heap::@6 to bram_heap_set_data_packed [phi:bram_heap_replace_free_with_heap::@6->bram_heap_set_data_packed]
    // [686] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#3 [phi:bram_heap_replace_free_with_heap::@6->bram_heap_set_data_packed#0] -- register_copy 
    // [686] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#3 [phi:bram_heap_replace_free_with_heap::@6->bram_heap_set_data_packed#1] -- call_phi_near 
    jsr bram_heap_set_data_packed
    // bram_heap_replace_free_with_heap::bram_heap_set_left1
    // bram_heap_index.left[index] = left
    // [1005] ((char *)&bram_heap_index+$700)[bram_heap_replace_free_with_heap::return#2] = bram_heap_replace_free_with_heap::free_left#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_left
    ldy return
    sta bram_heap_index+$700,y
    // bram_heap_replace_free_with_heap::bram_heap_set_right1
    // bram_heap_index.right[index] = right
    // [1006] ((char *)&bram_heap_index+$600)[bram_heap_replace_free_with_heap::return#2] = bram_heap_replace_free_with_heap::free_right#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_right
    sta bram_heap_index+$600,y
    // bram_heap_replace_free_with_heap::@2
    // bram_heap_get_size(s, heap_index)
    // [1007] stackpush(char) = bram_heap_replace_free_with_heap::s#0 -- _stackpushbyte_=vbum1 
    lda s
    pha
    // [1008] stackpush(char) = bram_heap_replace_free_with_heap::return#2 -- _stackpushbyte_=vbum1 
    tya
    pha
    // sideeffect stackpushpadding(2) -- _stackpushpadding_2 
    pha
    pha
    // [1010] callexecute bram_heap_get_size  -- call_vprc1 
    jsr bram_heap_get_size
    // printf("\n > Replaced free index with heap index %03x size %05x.", heap_index, bram_heap_get_size(s, heap_index))
    // [1011] printf_ulong::uvalue#4 = stackpull(unsigned long) -- vdum1=_stackpulldword_ 
    pla
    sta printf_ulong.uvalue
    pla
    sta printf_ulong.uvalue+1
    pla
    sta printf_ulong.uvalue+2
    pla
    sta printf_ulong.uvalue+3
    // [1012] call printf_str
    // [380] phi from bram_heap_replace_free_with_heap::@2 to printf_str [phi:bram_heap_replace_free_with_heap::@2->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_replace_free_with_heap::s1 [phi:bram_heap_replace_free_with_heap::@2->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_replace_free_with_heap::@7
    // printf("\n > Replaced free index with heap index %03x size %05x.", heap_index, bram_heap_get_size(s, heap_index))
    // [1013] printf_uchar::uvalue#6 = bram_heap_replace_free_with_heap::return#2 -- vbum1=vbum2 
    lda return
    sta printf_uchar.uvalue
    // [1014] call printf_uchar
    // [389] phi from bram_heap_replace_free_with_heap::@7 to printf_uchar [phi:bram_heap_replace_free_with_heap::@7->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_replace_free_with_heap::@7->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#6 [phi:bram_heap_replace_free_with_heap::@7->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [1015] phi from bram_heap_replace_free_with_heap::@7 to bram_heap_replace_free_with_heap::@8 [phi:bram_heap_replace_free_with_heap::@7->bram_heap_replace_free_with_heap::@8]
    // bram_heap_replace_free_with_heap::@8
    // printf("\n > Replaced free index with heap index %03x size %05x.", heap_index, bram_heap_get_size(s, heap_index))
    // [1016] call printf_str
    // [380] phi from bram_heap_replace_free_with_heap::@8 to printf_str [phi:bram_heap_replace_free_with_heap::@8->printf_str]
    // [380] phi printf_str::s#69 = s2 [phi:bram_heap_replace_free_with_heap::@8->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // [1017] phi from bram_heap_replace_free_with_heap::@8 to bram_heap_replace_free_with_heap::@9 [phi:bram_heap_replace_free_with_heap::@8->bram_heap_replace_free_with_heap::@9]
    // bram_heap_replace_free_with_heap::@9
    // printf("\n > Replaced free index with heap index %03x size %05x.", heap_index, bram_heap_get_size(s, heap_index))
    // [1018] call printf_ulong
    // [397] phi from bram_heap_replace_free_with_heap::@9 to printf_ulong [phi:bram_heap_replace_free_with_heap::@9->printf_ulong]
    // [397] phi printf_ulong::uvalue#12 = printf_ulong::uvalue#4 [phi:bram_heap_replace_free_with_heap::@9->printf_ulong#0] -- call_phi_near 
    jsr printf_ulong
    // [1019] phi from bram_heap_replace_free_with_heap::@9 to bram_heap_replace_free_with_heap::@10 [phi:bram_heap_replace_free_with_heap::@9->bram_heap_replace_free_with_heap::@10]
    // bram_heap_replace_free_with_heap::@10
    // printf("\n > Replaced free index with heap index %03x size %05x.", heap_index, bram_heap_get_size(s, heap_index))
    // [1020] call printf_str
    // [380] phi from bram_heap_replace_free_with_heap::@10 to printf_str [phi:bram_heap_replace_free_with_heap::@10->printf_str]
    // [380] phi printf_str::s#69 = s3 [phi:bram_heap_replace_free_with_heap::@10->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_replace_free_with_heap::@return
    // }
    // [1021] return 
    rts
  .segment DataBramHeap
    s1: .text @"\n > Replaced free index with heap index "
    .byte 0
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
    // [1022] bram_heap_get_size_packed::index#3 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [1023] call bram_heap_get_size_packed
  // The free block is reduced in size with the required size.
    // [275] phi from bram_heap_split_free_and_allocate to bram_heap_get_size_packed [phi:bram_heap_split_free_and_allocate->bram_heap_get_size_packed]
    // [275] phi bram_heap_get_size_packed::index#8 = bram_heap_get_size_packed::index#3 [phi:bram_heap_split_free_and_allocate->bram_heap_get_size_packed#0] -- call_phi_near 
    jsr bram_heap_get_size_packed
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [1024] bram_heap_get_size_packed::return#13 = bram_heap_get_size_packed::return#12 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_2
    sta bram_heap_get_size_packed.return_3
    lda bram_heap_get_size_packed.return_2+1
    sta bram_heap_get_size_packed.return_3+1
    // bram_heap_split_free_and_allocate::@2
    // [1025] bram_heap_split_free_and_allocate::free_size#0 = bram_heap_get_size_packed::return#13 -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return_3
    sta free_size
    lda bram_heap_get_size_packed.return_3+1
    sta free_size+1
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [1026] bram_heap_get_data_packed::index#3 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [1027] call bram_heap_get_data_packed
    // [279] phi from bram_heap_split_free_and_allocate::@2 to bram_heap_get_data_packed [phi:bram_heap_split_free_and_allocate::@2->bram_heap_get_data_packed]
    // [279] phi bram_heap_get_data_packed::index#9 = bram_heap_get_data_packed::index#3 [phi:bram_heap_split_free_and_allocate::@2->bram_heap_get_data_packed#0] -- call_phi_near 
    jsr bram_heap_get_data_packed
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [1028] bram_heap_get_data_packed::return#15 = bram_heap_get_data_packed::return#1 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_1
    sta bram_heap_get_data_packed.return_5
    lda bram_heap_get_data_packed.return_1+1
    sta bram_heap_get_data_packed.return_5+1
    // bram_heap_split_free_and_allocate::@3
    // [1029] bram_heap_split_free_and_allocate::free_data#0 = bram_heap_get_data_packed::return#15 -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return_5
    sta free_data
    lda bram_heap_get_data_packed.return_5+1
    sta free_data+1
    // bram_heap_set_size_packed(s, free_index, free_size - required_size)
    // [1030] bram_heap_set_size_packed::size_packed#4 = bram_heap_split_free_and_allocate::free_size#0 - bram_heap_split_free_and_allocate::required_size#0 -- vwum1=vwum2_minus_vwum3 
    lda free_size
    sec
    sbc required_size
    sta bram_heap_set_size_packed.size_packed
    lda free_size+1
    sbc required_size+1
    sta bram_heap_set_size_packed.size_packed+1
    // [1031] bram_heap_set_size_packed::index#4 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [1032] call bram_heap_set_size_packed
    // [692] phi from bram_heap_split_free_and_allocate::@3 to bram_heap_set_size_packed [phi:bram_heap_split_free_and_allocate::@3->bram_heap_set_size_packed]
    // [692] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#4 [phi:bram_heap_split_free_and_allocate::@3->bram_heap_set_size_packed#0] -- register_copy 
    // [692] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#4 [phi:bram_heap_split_free_and_allocate::@3->bram_heap_set_size_packed#1] -- call_phi_near 
    jsr bram_heap_set_size_packed
    // bram_heap_split_free_and_allocate::@4
    // bram_heap_set_data_packed(s, free_index, free_data + required_size)
    // [1033] bram_heap_set_data_packed::data_packed#4 = bram_heap_split_free_and_allocate::free_data#0 + bram_heap_split_free_and_allocate::required_size#0 -- vwum1=vwum2_plus_vwum3 
    lda free_data
    clc
    adc required_size
    sta bram_heap_set_data_packed.data_packed
    lda free_data+1
    adc required_size+1
    sta bram_heap_set_data_packed.data_packed+1
    // [1034] bram_heap_set_data_packed::index#4 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [1035] call bram_heap_set_data_packed
    // [686] phi from bram_heap_split_free_and_allocate::@4 to bram_heap_set_data_packed [phi:bram_heap_split_free_and_allocate::@4->bram_heap_set_data_packed]
    // [686] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#4 [phi:bram_heap_split_free_and_allocate::@4->bram_heap_set_data_packed#0] -- register_copy 
    // [686] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#4 [phi:bram_heap_split_free_and_allocate::@4->bram_heap_set_data_packed#1] -- call_phi_near 
    jsr bram_heap_set_data_packed
    // bram_heap_split_free_and_allocate::@5
    // bram_heap_index_t heap_index = bram_heap_index_add(s)
    // [1036] bram_heap_index_add::s#1 = bram_heap_split_free_and_allocate::s#0 -- vbuxx=vbum1 
    ldx s
    // [1037] call bram_heap_index_add
  // We create a new heap block with the required size.
  // The data is the offset in vram.
    // [661] phi from bram_heap_split_free_and_allocate::@5 to bram_heap_index_add [phi:bram_heap_split_free_and_allocate::@5->bram_heap_index_add]
    // [661] phi bram_heap_index_add::s#2 = bram_heap_index_add::s#1 [phi:bram_heap_split_free_and_allocate::@5->bram_heap_index_add#0] -- call_phi_near 
    jsr bram_heap_index_add
    // bram_heap_index_t heap_index = bram_heap_index_add(s)
    // [1038] bram_heap_index_add::return#3 = bram_heap_index_add::return#1 -- vbuaa=vbum1 
    lda bram_heap_index_add.return
    // bram_heap_split_free_and_allocate::@6
    // [1039] bram_heap_split_free_and_allocate::heap_index#0 = bram_heap_index_add::return#3 -- vbum1=vbuaa 
    sta heap_index
    // bram_heap_set_data_packed(s, heap_index, free_data)
    // [1040] bram_heap_set_data_packed::index#5 = bram_heap_split_free_and_allocate::heap_index#0 -- vbuxx=vbum1 
    tax
    // [1041] bram_heap_set_data_packed::data_packed#5 = bram_heap_split_free_and_allocate::free_data#0 -- vwum1=vwum2 
    lda free_data
    sta bram_heap_set_data_packed.data_packed
    lda free_data+1
    sta bram_heap_set_data_packed.data_packed+1
    // [1042] call bram_heap_set_data_packed
    // [686] phi from bram_heap_split_free_and_allocate::@6 to bram_heap_set_data_packed [phi:bram_heap_split_free_and_allocate::@6->bram_heap_set_data_packed]
    // [686] phi bram_heap_set_data_packed::index#7 = bram_heap_set_data_packed::index#5 [phi:bram_heap_split_free_and_allocate::@6->bram_heap_set_data_packed#0] -- register_copy 
    // [686] phi bram_heap_set_data_packed::data_packed#7 = bram_heap_set_data_packed::data_packed#5 [phi:bram_heap_split_free_and_allocate::@6->bram_heap_set_data_packed#1] -- call_phi_near 
    jsr bram_heap_set_data_packed
    // bram_heap_split_free_and_allocate::@7
    // bram_heap_heap_insert_at(s, heap_index, BRAM_HEAP_NULL, required_size)
    // [1043] bram_heap_heap_insert_at::s#1 = bram_heap_split_free_and_allocate::s#0 -- vbum1=vbum2 
    lda s
    sta bram_heap_heap_insert_at.s
    // [1044] bram_heap_heap_insert_at::heap_index#1 = bram_heap_split_free_and_allocate::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_heap_insert_at.heap_index
    // [1045] bram_heap_heap_insert_at::size#1 = bram_heap_split_free_and_allocate::required_size#0 -- vwum1=vwum2 
    lda required_size
    sta bram_heap_heap_insert_at.size
    lda required_size+1
    sta bram_heap_heap_insert_at.size+1
    // [1046] call bram_heap_heap_insert_at
    // [1200] phi from bram_heap_split_free_and_allocate::@7 to bram_heap_heap_insert_at [phi:bram_heap_split_free_and_allocate::@7->bram_heap_heap_insert_at]
    // [1200] phi bram_heap_heap_insert_at::size#2 = bram_heap_heap_insert_at::size#1 [phi:bram_heap_split_free_and_allocate::@7->bram_heap_heap_insert_at#0] -- register_copy 
    // [1200] phi bram_heap_heap_insert_at::heap_index#2 = bram_heap_heap_insert_at::heap_index#1 [phi:bram_heap_split_free_and_allocate::@7->bram_heap_heap_insert_at#1] -- register_copy 
    // [1200] phi bram_heap_heap_insert_at::s#2 = bram_heap_heap_insert_at::s#1 [phi:bram_heap_split_free_and_allocate::@7->bram_heap_heap_insert_at#2] -- call_phi_near 
    jsr bram_heap_heap_insert_at
    // bram_heap_split_free_and_allocate::bram_heap_get_left1
    // return bram_heap_index.left[index];
    // [1047] bram_heap_split_free_and_allocate::heap_left#0 = ((char *)&bram_heap_index+$700)[bram_heap_split_free_and_allocate::free_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy free_index
    lda bram_heap_index+$700,y
    sta heap_left
    // bram_heap_split_free_and_allocate::bram_heap_set_left1
    // bram_heap_index.left[index] = left
    // [1048] ((char *)&bram_heap_index+$700)[bram_heap_split_free_and_allocate::heap_index#0] = bram_heap_split_free_and_allocate::heap_left#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy heap_index
    sta bram_heap_index+$700,y
    // bram_heap_split_free_and_allocate::bram_heap_set_right1
    // bram_heap_index.right[index] = right
    // [1049] ((char *)&bram_heap_index+$600)[bram_heap_split_free_and_allocate::heap_index#0] = bram_heap_split_free_and_allocate::free_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_index
    sta bram_heap_index+$600,y
    // bram_heap_split_free_and_allocate::bram_heap_set_right2
    // [1050] ((char *)&bram_heap_index+$600)[bram_heap_split_free_and_allocate::heap_left#0] = bram_heap_split_free_and_allocate::heap_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy heap_left
    sta bram_heap_index+$600,y
    // bram_heap_split_free_and_allocate::bram_heap_set_left2
    // bram_heap_index.left[index] = left
    // [1051] ((char *)&bram_heap_index+$700)[bram_heap_split_free_and_allocate::free_index#0] = bram_heap_split_free_and_allocate::heap_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy free_index
    sta bram_heap_index+$700,y
    // bram_heap_split_free_and_allocate::@1
    // bram_heap_set_free(s, heap_right)
    // [1052] bram_heap_set_free::index#2 = bram_heap_split_free_and_allocate::free_index#0 -- vbuxx=vbum1 
    ldx free_index
    // [1053] call bram_heap_set_free
    // [701] phi from bram_heap_split_free_and_allocate::@1 to bram_heap_set_free [phi:bram_heap_split_free_and_allocate::@1->bram_heap_set_free]
    // [701] phi bram_heap_set_free::index#5 = bram_heap_set_free::index#2 [phi:bram_heap_split_free_and_allocate::@1->bram_heap_set_free#0] -- call_phi_near 
    jsr bram_heap_set_free
    // bram_heap_split_free_and_allocate::@8
    // bram_heap_clear_free(s, heap_left)
    // [1054] bram_heap_clear_free::index#1 = bram_heap_split_free_and_allocate::heap_left#0 -- vbuxx=vbum1 
    ldx heap_left
    // [1055] call bram_heap_clear_free
    // [1197] phi from bram_heap_split_free_and_allocate::@8 to bram_heap_clear_free [phi:bram_heap_split_free_and_allocate::@8->bram_heap_clear_free]
    // [1197] phi bram_heap_clear_free::index#2 = bram_heap_clear_free::index#1 [phi:bram_heap_split_free_and_allocate::@8->bram_heap_clear_free#0] -- call_phi_near 
    jsr bram_heap_clear_free
    // bram_heap_split_free_and_allocate::@9
    // bram_heap_get_size(s, free_index)
    // [1056] stackpush(char) = bram_heap_split_free_and_allocate::s#0 -- _stackpushbyte_=vbum1 
    lda s
    pha
    // [1057] stackpush(char) = bram_heap_split_free_and_allocate::free_index#0 -- _stackpushbyte_=vbum1 
    lda free_index
    pha
    // sideeffect stackpushpadding(2) -- _stackpushpadding_2 
    pha
    pha
    // [1059] callexecute bram_heap_get_size  -- call_vprc1 
    jsr bram_heap_get_size
    // printf("\n > Split free index %03x size %05x and allocate heap index %03x size %05x.", free_index, bram_heap_get_size(s, free_index), heap_index, bram_heap_get_size(s, heap_index))
    // [1060] printf_ulong::uvalue#5 = stackpull(unsigned long) -- vdum1=_stackpulldword_ 
    pla
    sta printf_ulong.uvalue
    pla
    sta printf_ulong.uvalue+1
    pla
    sta printf_ulong.uvalue+2
    pla
    sta printf_ulong.uvalue+3
    // bram_heap_get_size(s, heap_index)
    // [1061] stackpush(char) = bram_heap_split_free_and_allocate::s#0 -- _stackpushbyte_=vbum1 
    lda s
    pha
    // [1062] stackpush(char) = bram_heap_split_free_and_allocate::heap_index#0 -- _stackpushbyte_=vbum1 
    lda heap_index
    pha
    // sideeffect stackpushpadding(2) -- _stackpushpadding_2 
    pha
    pha
    // [1064] callexecute bram_heap_get_size  -- call_vprc1 
    jsr bram_heap_get_size
    // printf("\n > Split free index %03x size %05x and allocate heap index %03x size %05x.", free_index, bram_heap_get_size(s, free_index), heap_index, bram_heap_get_size(s, heap_index))
    // [1065] printf_ulong::uvalue#6 = stackpull(unsigned long) -- vdum1=_stackpulldword_ 
    pla
    sta printf_ulong.uvalue_2
    pla
    sta printf_ulong.uvalue_2+1
    pla
    sta printf_ulong.uvalue_2+2
    pla
    sta printf_ulong.uvalue_2+3
    // [1066] call printf_str
    // [380] phi from bram_heap_split_free_and_allocate::@9 to printf_str [phi:bram_heap_split_free_and_allocate::@9->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_split_free_and_allocate::s1 [phi:bram_heap_split_free_and_allocate::@9->printf_str#0] -- call_phi_near 
    lda #<s1
    sta printf_str.s
    lda #>s1
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_split_free_and_allocate::@10
    // printf("\n > Split free index %03x size %05x and allocate heap index %03x size %05x.", free_index, bram_heap_get_size(s, free_index), heap_index, bram_heap_get_size(s, heap_index))
    // [1067] printf_uchar::uvalue#7 = bram_heap_split_free_and_allocate::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta printf_uchar.uvalue
    // [1068] call printf_uchar
    // [389] phi from bram_heap_split_free_and_allocate::@10 to printf_uchar [phi:bram_heap_split_free_and_allocate::@10->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_split_free_and_allocate::@10->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#7 [phi:bram_heap_split_free_and_allocate::@10->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [1069] phi from bram_heap_split_free_and_allocate::@10 to bram_heap_split_free_and_allocate::@11 [phi:bram_heap_split_free_and_allocate::@10->bram_heap_split_free_and_allocate::@11]
    // bram_heap_split_free_and_allocate::@11
    // printf("\n > Split free index %03x size %05x and allocate heap index %03x size %05x.", free_index, bram_heap_get_size(s, free_index), heap_index, bram_heap_get_size(s, heap_index))
    // [1070] call printf_str
    // [380] phi from bram_heap_split_free_and_allocate::@11 to printf_str [phi:bram_heap_split_free_and_allocate::@11->printf_str]
    // [380] phi printf_str::s#69 = s2 [phi:bram_heap_split_free_and_allocate::@11->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // [1071] phi from bram_heap_split_free_and_allocate::@11 to bram_heap_split_free_and_allocate::@12 [phi:bram_heap_split_free_and_allocate::@11->bram_heap_split_free_and_allocate::@12]
    // bram_heap_split_free_and_allocate::@12
    // printf("\n > Split free index %03x size %05x and allocate heap index %03x size %05x.", free_index, bram_heap_get_size(s, free_index), heap_index, bram_heap_get_size(s, heap_index))
    // [1072] call printf_ulong
    // [397] phi from bram_heap_split_free_and_allocate::@12 to printf_ulong [phi:bram_heap_split_free_and_allocate::@12->printf_ulong]
    // [397] phi printf_ulong::uvalue#12 = printf_ulong::uvalue#5 [phi:bram_heap_split_free_and_allocate::@12->printf_ulong#0] -- call_phi_near 
    jsr printf_ulong
    // [1073] phi from bram_heap_split_free_and_allocate::@12 to bram_heap_split_free_and_allocate::@13 [phi:bram_heap_split_free_and_allocate::@12->bram_heap_split_free_and_allocate::@13]
    // bram_heap_split_free_and_allocate::@13
    // printf("\n > Split free index %03x size %05x and allocate heap index %03x size %05x.", free_index, bram_heap_get_size(s, free_index), heap_index, bram_heap_get_size(s, heap_index))
    // [1074] call printf_str
    // [380] phi from bram_heap_split_free_and_allocate::@13 to printf_str [phi:bram_heap_split_free_and_allocate::@13->printf_str]
    // [380] phi printf_str::s#69 = bram_heap_split_free_and_allocate::s3 [phi:bram_heap_split_free_and_allocate::@13->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_split_free_and_allocate::@14
    // printf("\n > Split free index %03x size %05x and allocate heap index %03x size %05x.", free_index, bram_heap_get_size(s, free_index), heap_index, bram_heap_get_size(s, heap_index))
    // [1075] printf_uchar::uvalue#8 = bram_heap_split_free_and_allocate::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta printf_uchar.uvalue
    // [1076] call printf_uchar
    // [389] phi from bram_heap_split_free_and_allocate::@14 to printf_uchar [phi:bram_heap_split_free_and_allocate::@14->printf_uchar]
    // [389] phi printf_uchar::format_min_length#27 = 3 [phi:bram_heap_split_free_and_allocate::@14->printf_uchar#0] -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [389] phi printf_uchar::uvalue#27 = printf_uchar::uvalue#8 [phi:bram_heap_split_free_and_allocate::@14->printf_uchar#1] -- call_phi_near 
    jsr printf_uchar
    // [1077] phi from bram_heap_split_free_and_allocate::@14 to bram_heap_split_free_and_allocate::@15 [phi:bram_heap_split_free_and_allocate::@14->bram_heap_split_free_and_allocate::@15]
    // bram_heap_split_free_and_allocate::@15
    // printf("\n > Split free index %03x size %05x and allocate heap index %03x size %05x.", free_index, bram_heap_get_size(s, free_index), heap_index, bram_heap_get_size(s, heap_index))
    // [1078] call printf_str
    // [380] phi from bram_heap_split_free_and_allocate::@15 to printf_str [phi:bram_heap_split_free_and_allocate::@15->printf_str]
    // [380] phi printf_str::s#69 = s2 [phi:bram_heap_split_free_and_allocate::@15->printf_str#0] -- call_phi_near 
    lda #<s2
    sta printf_str.s
    lda #>s2
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_split_free_and_allocate::@16
    // [1079] printf_ulong::uvalue#27 = printf_ulong::uvalue#6 -- vdum1=vdum2 
    lda printf_ulong.uvalue_2
    sta printf_ulong.uvalue
    lda printf_ulong.uvalue_2+1
    sta printf_ulong.uvalue+1
    lda printf_ulong.uvalue_2+2
    sta printf_ulong.uvalue+2
    lda printf_ulong.uvalue_2+3
    sta printf_ulong.uvalue+3
    // printf("\n > Split free index %03x size %05x and allocate heap index %03x size %05x.", free_index, bram_heap_get_size(s, free_index), heap_index, bram_heap_get_size(s, heap_index))
    // [1080] call printf_ulong
    // [397] phi from bram_heap_split_free_and_allocate::@16 to printf_ulong [phi:bram_heap_split_free_and_allocate::@16->printf_ulong]
    // [397] phi printf_ulong::uvalue#12 = printf_ulong::uvalue#27 [phi:bram_heap_split_free_and_allocate::@16->printf_ulong#0] -- call_phi_near 
    jsr printf_ulong
    // [1081] phi from bram_heap_split_free_and_allocate::@16 to bram_heap_split_free_and_allocate::@17 [phi:bram_heap_split_free_and_allocate::@16->bram_heap_split_free_and_allocate::@17]
    // bram_heap_split_free_and_allocate::@17
    // printf("\n > Split free index %03x size %05x and allocate heap index %03x size %05x.", free_index, bram_heap_get_size(s, free_index), heap_index, bram_heap_get_size(s, heap_index))
    // [1082] call printf_str
    // [380] phi from bram_heap_split_free_and_allocate::@17 to printf_str [phi:bram_heap_split_free_and_allocate::@17->printf_str]
    // [380] phi printf_str::s#69 = s3 [phi:bram_heap_split_free_and_allocate::@17->printf_str#0] -- call_phi_near 
    lda #<s3
    sta printf_str.s
    lda #>s3
    sta printf_str.s+1
    jsr printf_str
    // bram_heap_split_free_and_allocate::@return
    // }
    // [1083] return 
    rts
  .segment DataBramHeap
    s1: .text @"\n > Split free index "
    .byte 0
    s3: .text " and allocate heap index "
    .byte 0
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
    // [1084] heap_idle_remove::$3 = heap_idle_remove::s#0 << 1 -- vbuaa=vbum1_rol_1 
    lda s
    asl
    // [1085] ((unsigned int *)&bram_heap_segment+$4e)[heap_idle_remove::$3] = -- ((unsigned int *)&bram_heap_segment+$4e)[heap_idle_remove::$3] -- pwuc1_derefidx_vbuaa=_dec_pwuc1_derefidx_vbuaa 
    tax
    lda bram_heap_segment+$4e,x
    bne !+
    dec bram_heap_segment+$4e+1,x
  !:
    dec bram_heap_segment+$4e,x
    // bram_heap_list_remove(s, bram_heap_segment.idle_list[s], idle_index)
    // [1086] bram_heap_list_remove::list#4 = ((char *)&bram_heap_segment+$32)[heap_idle_remove::s#0] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$32,y
    // [1087] bram_heap_list_remove::index#2 = heap_idle_remove::idle_index#0 -- vbum1=vbum2 
    lda idle_index
    sta bram_heap_list_remove.index
    // [1088] call bram_heap_list_remove
    // [931] phi from heap_idle_remove to bram_heap_list_remove [phi:heap_idle_remove->bram_heap_list_remove]
    // [931] phi bram_heap_list_remove::index#10 = bram_heap_list_remove::index#2 [phi:heap_idle_remove->bram_heap_list_remove#0] -- register_copy 
    // [931] phi bram_heap_list_remove::list#10 = bram_heap_list_remove::list#4 [phi:heap_idle_remove->bram_heap_list_remove#1] -- call_phi_near 
    jsr bram_heap_list_remove
    // bram_heap_list_remove(s, bram_heap_segment.idle_list[s], idle_index)
    // [1089] bram_heap_list_remove::return#10 = bram_heap_list_remove::return#1 -- vbuaa=vbuxx 
    txa
    // heap_idle_remove::@1
    // [1090] heap_idle_remove::$1 = bram_heap_list_remove::return#10
    // bram_heap_segment.idle_list[s] = bram_heap_list_remove(s, bram_heap_segment.idle_list[s], idle_index)
    // [1091] ((char *)&bram_heap_segment+$32)[heap_idle_remove::s#0] = heap_idle_remove::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy s
    sta bram_heap_segment+$32,y
    // heap_idle_remove::@return
    // }
    // [1092] return 
    rts
  .segment Data
    s: .byte 0
    idle_index: .byte 0
}
.segment Code
  // screenlayer
// --- layer management in VERA ---
// void screenlayer(char layer, __register(X) char mapbase, __mem() char config)
screenlayer: {
    // __mem char vera_dc_hscale_temp = *VERA_DC_HSCALE
    // [1093] screenlayer::vera_dc_hscale_temp#0 = *VERA_DC_HSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_HSCALE
    sta vera_dc_hscale_temp
    // __mem char vera_dc_vscale_temp = *VERA_DC_VSCALE
    // [1094] screenlayer::vera_dc_vscale_temp#0 = *VERA_DC_VSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_VSCALE
    sta vera_dc_vscale_temp
    // __conio.layer = 0
    // [1095] *((char *)&__conio+2) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+2
    // mapbase >> 7
    // [1096] screenlayer::$0 = screenlayer::mapbase#0 >> 7 -- vbuaa=vbuxx_ror_7 
    txa
    rol
    rol
    and #1
    // __conio.mapbase_bank = mapbase >> 7
    // [1097] *((char *)&__conio+5) = screenlayer::$0 -- _deref_pbuc1=vbuaa 
    sta __conio+5
    // (mapbase)<<1
    // [1098] screenlayer::$1 = screenlayer::mapbase#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // MAKEWORD((mapbase)<<1,0)
    // [1099] screenlayer::$2 = screenlayer::$1 w= 0 -- vwum1=vbuaa_word_vbuc1 
    ldy #0
    sta screenlayer__2+1
    sty screenlayer__2
    // __conio.mapbase_offset = MAKEWORD((mapbase)<<1,0)
    // [1100] *((unsigned int *)&__conio+3) = screenlayer::$2 -- _deref_pwuc1=vwum1 
    tya
    sta __conio+3
    lda screenlayer__2+1
    sta __conio+3+1
    // config & VERA_LAYER_WIDTH_MASK
    // [1101] screenlayer::$7 = screenlayer::config#0 & VERA_LAYER_WIDTH_MASK -- vbuaa=vbum1_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    and config
    // (config & VERA_LAYER_WIDTH_MASK) >> 4
    // [1102] screenlayer::$8 = screenlayer::$7 >> 4 -- vbuxx=vbuaa_ror_4 
    lsr
    lsr
    lsr
    lsr
    tax
    // __conio.mapwidth = VERA_LAYER_DIM[ (config & VERA_LAYER_WIDTH_MASK) >> 4]
    // [1103] *((char *)&__conio+8) = screenlayer::VERA_LAYER_DIM[screenlayer::$8] -- _deref_pbuc1=pbuc2_derefidx_vbuxx 
    lda VERA_LAYER_DIM,x
    sta __conio+8
    // config & VERA_LAYER_HEIGHT_MASK
    // [1104] screenlayer::$5 = screenlayer::config#0 & VERA_LAYER_HEIGHT_MASK -- vbuaa=vbum1_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    and config
    // (config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [1105] screenlayer::$6 = screenlayer::$5 >> 6 -- vbuaa=vbuaa_ror_6 
    rol
    rol
    rol
    and #3
    // __conio.mapheight = VERA_LAYER_DIM[ (config & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [1106] *((char *)&__conio+9) = screenlayer::VERA_LAYER_DIM[screenlayer::$6] -- _deref_pbuc1=pbuc2_derefidx_vbuaa 
    tay
    lda VERA_LAYER_DIM,y
    sta __conio+9
    // __conio.rowskip = VERA_LAYER_SKIP[(config & VERA_LAYER_WIDTH_MASK)>>4]
    // [1107] screenlayer::$16 = screenlayer::$8 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [1108] *((unsigned int *)&__conio+$a) = screenlayer::VERA_LAYER_SKIP[screenlayer::$16] -- _deref_pwuc1=pwuc2_derefidx_vbuaa 
    // __conio.rowshift = ((config & VERA_LAYER_WIDTH_MASK)>>4)+6;
    tay
    lda VERA_LAYER_SKIP,y
    sta __conio+$a
    lda VERA_LAYER_SKIP+1,y
    sta __conio+$a+1
    // vera_dc_hscale_temp == 0x80
    // [1109] screenlayer::$9 = screenlayer::vera_dc_hscale_temp#0 == $80 -- vboaa=vbum1_eq_vbuc1 
    lda vera_dc_hscale_temp
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // 40 << (char)(vera_dc_hscale_temp == 0x80)
    // [1110] screenlayer::$18 = (char)screenlayer::$9 -- vbuxx=vbuaa 
    tax
    // [1111] screenlayer::$10 = $28 << screenlayer::$18 -- vbuaa=vbuc1_rol_vbuxx 
    lda #$28
    cpx #0
    beq !e+
  !:
    asl
    dex
    bne !-
  !e:
    // (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [1112] screenlayer::$11 = screenlayer::$10 - 1 -- vbuaa=vbuaa_minus_1 
    sec
    sbc #1
    // __conio.width = (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [1113] *((char *)&__conio+6) = screenlayer::$11 -- _deref_pbuc1=vbuaa 
    sta __conio+6
    // vera_dc_vscale_temp == 0x80
    // [1114] screenlayer::$12 = screenlayer::vera_dc_vscale_temp#0 == $80 -- vboaa=vbum1_eq_vbuc1 
    lda vera_dc_vscale_temp
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // 30 << (char)(vera_dc_vscale_temp == 0x80)
    // [1115] screenlayer::$19 = (char)screenlayer::$12 -- vbuxx=vbuaa 
    tax
    // [1116] screenlayer::$13 = $1e << screenlayer::$19 -- vbuaa=vbuc1_rol_vbuxx 
    lda #$1e
    cpx #0
    beq !e+
  !:
    asl
    dex
    bne !-
  !e:
    // (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [1117] screenlayer::$14 = screenlayer::$13 - 1 -- vbuaa=vbuaa_minus_1 
    sec
    sbc #1
    // __conio.height = (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [1118] *((char *)&__conio+7) = screenlayer::$14 -- _deref_pbuc1=vbuaa 
    sta __conio+7
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [1119] screenlayer::mapbase_offset#0 = *((unsigned int *)&__conio+3) -- vwum1=_deref_pwuc1 
    lda __conio+3
    sta mapbase_offset
    lda __conio+3+1
    sta mapbase_offset+1
    // [1120] phi from screenlayer to screenlayer::@1 [phi:screenlayer->screenlayer::@1]
    // [1120] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#0 [phi:screenlayer->screenlayer::@1#0] -- register_copy 
    // [1120] phi screenlayer::y#2 = 0 [phi:screenlayer->screenlayer::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // screenlayer::@1
  __b1:
    // for(register char y=0; y<=__conio.height; y++)
    // [1121] if(screenlayer::y#2<=*((char *)&__conio+7)) goto screenlayer::@2 -- vbuxx_le__deref_pbuc1_then_la1 
    lda __conio+7
    stx.z $ff
    cmp.z $ff
    bcs __b2
    // screenlayer::@return
    // }
    // [1122] return 
    rts
    // screenlayer::@2
  __b2:
    // __conio.offsets[y] = mapbase_offset
    // [1123] screenlayer::$17 = screenlayer::y#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [1124] ((unsigned int *)&__conio+$15)[screenlayer::$17] = screenlayer::mapbase_offset#2 -- pwuc1_derefidx_vbuaa=vwum1 
    tay
    lda mapbase_offset
    sta __conio+$15,y
    lda mapbase_offset+1
    sta __conio+$15+1,y
    // mapbase_offset += __conio.rowskip
    // [1125] screenlayer::mapbase_offset#1 = screenlayer::mapbase_offset#2 + *((unsigned int *)&__conio+$a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda mapbase_offset
    adc __conio+$a
    sta mapbase_offset
    lda mapbase_offset+1
    adc __conio+$a+1
    sta mapbase_offset+1
    // for(register char y=0; y<=__conio.height; y++)
    // [1126] screenlayer::y#1 = ++ screenlayer::y#2 -- vbuxx=_inc_vbuxx 
    inx
    // [1120] phi from screenlayer::@2 to screenlayer::@1 [phi:screenlayer::@2->screenlayer::@1]
    // [1120] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#1 [phi:screenlayer::@2->screenlayer::@1#0] -- register_copy 
    // [1120] phi screenlayer::y#2 = screenlayer::y#1 [phi:screenlayer::@2->screenlayer::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    VERA_LAYER_DIM: .byte $1f, $3f, $7f, $ff
    VERA_LAYER_SKIP: .word $40, $80, $100, $200
    screenlayer__2: .word 0
    vera_dc_hscale_temp: .byte 0
    vera_dc_vscale_temp: .byte 0
    mapbase_offset: .word 0
    config: .byte 0
}
.segment Code
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(__conio.cursor_y>__conio.height)
    // [1127] if(*((char *)&__conio+1)<=*((char *)&__conio+7)) goto cscroll::@return -- _deref_pbuc1_le__deref_pbuc2_then_la1 
    lda __conio+7
    cmp __conio+1
    bcs __breturn
    // cscroll::@1
    // if(__conio.scroll[__conio.layer])
    // [1128] if(0!=((char *)&__conio+$f)[*((char *)&__conio+2)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$f,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(__conio.cursor_y>__conio.height)
    // [1129] if(*((char *)&__conio+1)<=*((char *)&__conio+7)) goto cscroll::@return -- _deref_pbuc1_le__deref_pbuc2_then_la1 
    lda __conio+7
    cmp __conio+1
    bcs __breturn
    // [1130] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
    // gotoxy(0,0)
    // [1131] call gotoxy
    // [723] phi from cscroll::@3 to gotoxy [phi:cscroll::@3->gotoxy]
    // [723] phi gotoxy::y#10 = 0 [phi:cscroll::@3->gotoxy#0] -- vbuyy=vbuc1 
    ldy #0
    // [723] phi gotoxy::x#10 = 0 [phi:cscroll::@3->gotoxy#1] -- call_phi_near 
    ldx #0
    jsr gotoxy
    // cscroll::@return
  __breturn:
    // }
    // [1132] return 
    rts
    // [1133] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup(1)
    // [1134] call insertup -- call_phi_near 
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, __conio.height)
    // [1135] gotoxy::y#1 = *((char *)&__conio+7) -- vbuyy=_deref_pbuc1 
    ldy __conio+7
    // [1136] call gotoxy
    // [723] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [723] phi gotoxy::y#10 = gotoxy::y#1 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    // [723] phi gotoxy::x#10 = 0 [phi:cscroll::@5->gotoxy#1] -- call_phi_near 
    ldx #0
    jsr gotoxy
    // [1137] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [1138] call clearline -- call_phi_near 
    jsr clearline
    rts
}
  // utoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__mem() unsigned int value, __mem() char *buffer, __register(X) char radix)
utoa: {
    // if(radix==DECIMAL)
    // [1139] if(utoa::radix#0==DECIMAL) goto utoa::@1 -- vbuxx_eq_vbuc1_then_la1 
    cpx #DECIMAL
    beq __b2
    // utoa::@2
    // if(radix==HEXADECIMAL)
    // [1140] if(utoa::radix#0==HEXADECIMAL) goto utoa::@1 -- vbuxx_eq_vbuc1_then_la1 
    cpx #HEXADECIMAL
    beq __b3
    // utoa::@3
    // if(radix==OCTAL)
    // [1141] if(utoa::radix#0==OCTAL) goto utoa::@1 -- vbuxx_eq_vbuc1_then_la1 
    cpx #OCTAL
    beq __b4
    // utoa::@4
    // if(radix==BINARY)
    // [1142] if(utoa::radix#0==BINARY) goto utoa::@1 -- vbuxx_eq_vbuc1_then_la1 
    cpx #BINARY
    beq __b5
    // utoa::@5
    // *buffer++ = 'e'
    // [1143] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS) = 'e'pm -- _deref_pbuc1=vbuc2 
    // Unknown radix
    lda #'e'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    // [1144] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1) = 'r'pm -- _deref_pbuc1=vbuc2 
    lda #'r'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    // [1145] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2) = 'r'pm -- _deref_pbuc1=vbuc2 
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    // [1146] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // utoa::@return
    // }
    // [1147] return 
    rts
    // [1148] phi from utoa to utoa::@1 [phi:utoa->utoa::@1]
  __b2:
    // [1148] phi utoa::digit_values#8 = RADIX_DECIMAL_VALUES [phi:utoa->utoa::@1#0] -- pwum1=pwuc1 
    lda #<RADIX_DECIMAL_VALUES
    sta digit_values
    lda #>RADIX_DECIMAL_VALUES
    sta digit_values+1
    // [1148] phi utoa::max_digits#7 = 5 [phi:utoa->utoa::@1#1] -- vbum1=vbuc1 
    lda #5
    sta max_digits
    jmp __b1
    // [1148] phi from utoa::@2 to utoa::@1 [phi:utoa::@2->utoa::@1]
  __b3:
    // [1148] phi utoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES [phi:utoa::@2->utoa::@1#0] -- pwum1=pwuc1 
    lda #<RADIX_HEXADECIMAL_VALUES
    sta digit_values
    lda #>RADIX_HEXADECIMAL_VALUES
    sta digit_values+1
    // [1148] phi utoa::max_digits#7 = 4 [phi:utoa::@2->utoa::@1#1] -- vbum1=vbuc1 
    lda #4
    sta max_digits
    jmp __b1
    // [1148] phi from utoa::@3 to utoa::@1 [phi:utoa::@3->utoa::@1]
  __b4:
    // [1148] phi utoa::digit_values#8 = RADIX_OCTAL_VALUES [phi:utoa::@3->utoa::@1#0] -- pwum1=pwuc1 
    lda #<RADIX_OCTAL_VALUES
    sta digit_values
    lda #>RADIX_OCTAL_VALUES
    sta digit_values+1
    // [1148] phi utoa::max_digits#7 = 6 [phi:utoa::@3->utoa::@1#1] -- vbum1=vbuc1 
    lda #6
    sta max_digits
    jmp __b1
    // [1148] phi from utoa::@4 to utoa::@1 [phi:utoa::@4->utoa::@1]
  __b5:
    // [1148] phi utoa::digit_values#8 = RADIX_BINARY_VALUES [phi:utoa::@4->utoa::@1#0] -- pwum1=pwuc1 
    lda #<RADIX_BINARY_VALUES
    sta digit_values
    lda #>RADIX_BINARY_VALUES
    sta digit_values+1
    // [1148] phi utoa::max_digits#7 = $10 [phi:utoa::@4->utoa::@1#1] -- vbum1=vbuc1 
    lda #$10
    sta max_digits
    // utoa::@1
  __b1:
    // [1149] phi from utoa::@1 to utoa::@6 [phi:utoa::@1->utoa::@6]
    // [1149] phi utoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:utoa::@1->utoa::@6#0] -- pbum1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta buffer+1
    // [1149] phi utoa::started#2 = 0 [phi:utoa::@1->utoa::@6#1] -- vbuxx=vbuc1 
    ldx #0
    // [1149] phi utoa::value#2 = utoa::value#1 [phi:utoa::@1->utoa::@6#2] -- register_copy 
    // [1149] phi utoa::digit#2 = 0 [phi:utoa::@1->utoa::@6#3] -- vbum1=vbuc1 
    txa
    sta digit
    // utoa::@6
  __b6:
    // max_digits-1
    // [1150] utoa::$4 = utoa::max_digits#7 - 1 -- vbuaa=vbum1_minus_1 
    lda max_digits
    sec
    sbc #1
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1151] if(utoa::digit#2<utoa::$4) goto utoa::@7 -- vbum1_lt_vbuaa_then_la1 
    cmp digit
    beq !+
    bcs __b7
  !:
    // utoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [1152] utoa::$11 = (char)utoa::value#2 -- vbuxx=_byte_vwum1 
    ldx value
    // [1153] *utoa::buffer#11 = DIGITS[utoa::$11] -- _deref_pbum1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy buffer
    sty.z $fe
    ldy buffer+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // *buffer++ = DIGITS[(char)value];
    // [1154] utoa::buffer#3 = ++ utoa::buffer#11 -- pbum1=_inc_pbum1 
    inc buffer
    bne !+
    inc buffer+1
  !:
    // *buffer = 0
    // [1155] *utoa::buffer#3 = 0 -- _deref_pbum1=vbuc1 
    lda #0
    ldy buffer
    sty.z $fe
    ldy buffer+1
    sty.z $ff
    tay
    sta ($fe),y
    rts
    // utoa::@7
  __b7:
    // unsigned int digit_value = digit_values[digit]
    // [1156] utoa::$10 = utoa::digit#2 << 1 -- vbuaa=vbum1_rol_1 
    lda digit
    asl
    // [1157] utoa::digit_value#0 = utoa::digit_values#8[utoa::$10] -- vwum1=pwum2_derefidx_vbuaa 
    tay
    lda digit_values
    sta.z $fe
    lda digit_values+1
    sta.z $ff
    lda ($fe),y
    sta digit_value
    iny
    lda ($fe),y
    sta digit_value+1
    // if (started || value >= digit_value)
    // [1158] if(0!=utoa::started#2) goto utoa::@10 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b10
    // utoa::@12
    // [1159] if(utoa::value#2>=utoa::digit_value#0) goto utoa::@10 -- vwum1_ge_vwum2_then_la1 
    cmp value+1
    bne !+
    lda digit_value
    cmp value
    beq __b10
  !:
    bcc __b10
    // [1160] phi from utoa::@12 to utoa::@9 [phi:utoa::@12->utoa::@9]
    // [1160] phi utoa::buffer#14 = utoa::buffer#11 [phi:utoa::@12->utoa::@9#0] -- register_copy 
    // [1160] phi utoa::started#4 = utoa::started#2 [phi:utoa::@12->utoa::@9#1] -- register_copy 
    // [1160] phi utoa::value#6 = utoa::value#2 [phi:utoa::@12->utoa::@9#2] -- register_copy 
    // utoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1161] utoa::digit#1 = ++ utoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [1149] phi from utoa::@9 to utoa::@6 [phi:utoa::@9->utoa::@6]
    // [1149] phi utoa::buffer#11 = utoa::buffer#14 [phi:utoa::@9->utoa::@6#0] -- register_copy 
    // [1149] phi utoa::started#2 = utoa::started#4 [phi:utoa::@9->utoa::@6#1] -- register_copy 
    // [1149] phi utoa::value#2 = utoa::value#6 [phi:utoa::@9->utoa::@6#2] -- register_copy 
    // [1149] phi utoa::digit#2 = utoa::digit#1 [phi:utoa::@9->utoa::@6#3] -- register_copy 
    jmp __b6
    // utoa::@10
  __b10:
    // utoa_append(buffer++, value, digit_value)
    // [1162] utoa_append::buffer#0 = utoa::buffer#11 -- pbum1=pbum2 
    lda buffer
    sta utoa_append.buffer
    lda buffer+1
    sta utoa_append.buffer+1
    // [1163] utoa_append::value#0 = utoa::value#2 -- vwum1=vwum2 
    lda value
    sta utoa_append.value
    lda value+1
    sta utoa_append.value+1
    // [1164] utoa_append::sub#0 = utoa::digit_value#0 -- vwum1=vwum2 
    lda digit_value
    sta utoa_append.sub
    lda digit_value+1
    sta utoa_append.sub+1
    // [1165] call utoa_append
    // [1246] phi from utoa::@10 to utoa_append [phi:utoa::@10->utoa_append] -- call_phi_near 
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // [1166] utoa_append::return#0 = utoa_append::value#2 -- vwum1=vwum2 
    lda utoa_append.value
    sta utoa_append.return
    lda utoa_append.value+1
    sta utoa_append.return+1
    // utoa::@11
    // value = utoa_append(buffer++, value, digit_value)
    // [1167] utoa::value#0 = utoa_append::return#0 -- vwum1=vwum2 
    lda utoa_append.return
    sta value
    lda utoa_append.return+1
    sta value+1
    // value = utoa_append(buffer++, value, digit_value);
    // [1168] utoa::buffer#4 = ++ utoa::buffer#11 -- pbum1=_inc_pbum1 
    inc buffer
    bne !+
    inc buffer+1
  !:
    // [1160] phi from utoa::@11 to utoa::@9 [phi:utoa::@11->utoa::@9]
    // [1160] phi utoa::buffer#14 = utoa::buffer#4 [phi:utoa::@11->utoa::@9#0] -- register_copy 
    // [1160] phi utoa::started#4 = 1 [phi:utoa::@11->utoa::@9#1] -- vbuxx=vbuc1 
    ldx #1
    // [1160] phi utoa::value#6 = utoa::value#0 [phi:utoa::@11->utoa::@9#2] -- register_copy 
    jmp __b9
  .segment Data
    digit_value: .word 0
    buffer: .word 0
    digit: .byte 0
    value: .word 0
    max_digits: .byte 0
    digit_values: .word 0
}
.segment Code
  // uctoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __register(X) char uctoa_append(__mem() char *buffer, __register(X) char value, __mem() char sub)
uctoa_append: {
    // [1170] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [1170] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbuyy=vbuc1 
    ldy #0
    // [1170] phi uctoa_append::value#2 = uctoa_append::value#0 [phi:uctoa_append->uctoa_append::@1#1] -- register_copy 
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [1171] if(uctoa_append::value#2>=uctoa_append::sub#0) goto uctoa_append::@2 -- vbuxx_ge_vbum1_then_la1 
    cpx sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [1172] *uctoa_append::buffer#0 = DIGITS[uctoa_append::digit#2] -- _deref_pbum1=pbuc1_derefidx_vbuyy 
    lda DIGITS,y
    ldy buffer
    sty.z $fe
    ldy buffer+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // uctoa_append::@return
    // }
    // [1173] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [1174] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbuyy=_inc_vbuyy 
    iny
    // value -= sub
    // [1175] uctoa_append::value#1 = uctoa_append::value#2 - uctoa_append::sub#0 -- vbuxx=vbuxx_minus_vbum1 
    txa
    sec
    sbc sub
    tax
    // [1170] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [1170] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    // [1170] phi uctoa_append::value#2 = uctoa_append::value#1 [phi:uctoa_append::@2->uctoa_append::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label buffer = ultoa_append.buffer
    sub: .byte 0
}
.segment Code
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __mem() unsigned int strlen(__mem() char *str)
strlen: {
    // [1177] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [1177] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta len
    sta len+1
    // [1177] phi strlen::str#3 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:strlen->strlen::@1#1] -- pbum1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta str+1
    // strlen::@1
  __b1:
    // while(*str)
    // [1178] if(0!=*strlen::str#3) goto strlen::@2 -- 0_neq__deref_pbum1_then_la1 
    ldy str
    sty.z $fe
    ldy str+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [1179] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [1180] strlen::len#1 = ++ strlen::len#2 -- vwum1=_inc_vwum1 
    inc len
    bne !+
    inc len+1
  !:
    // str++;
    // [1181] strlen::str#0 = ++ strlen::str#3 -- pbum1=_inc_pbum1 
    inc str
    bne !+
    inc str+1
  !:
    // [1177] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [1177] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [1177] phi strlen::str#3 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label len = ultoa_append.buffer
    str: .word 0
    .label return = str
}
.segment Code
  // printf_padding
// Print a padding char a number of times
// void printf_padding(void (*putc)(char), char pad, __mem() char length)
printf_padding: {
    // [1183] phi from printf_padding to printf_padding::@1 [phi:printf_padding->printf_padding::@1]
    // [1183] phi printf_padding::i#2 = 0 [phi:printf_padding->printf_padding::@1#0] -- vbum1=vbuc1 
    lda #0
    sta i
    // printf_padding::@1
  __b1:
    // for(char i=0;i<length; i++)
    // [1184] if(printf_padding::i#2<printf_padding::length#1) goto printf_padding::@2 -- vbum1_lt_vbum2_then_la1 
    lda i
    cmp length
    bcc __b2
    // printf_padding::@return
    // }
    // [1185] return 
    rts
    // printf_padding::@2
  __b2:
    // putc(pad)
    // [1186] stackpush(char) = '0'pm -- _stackpushbyte_=vbuc1 
    lda #'0'
    pha
    // [1187] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_padding::@3
    // for(char i=0;i<length; i++)
    // [1189] printf_padding::i#1 = ++ printf_padding::i#2 -- vbum1=_inc_vbum1 
    inc i
    // [1183] phi from printf_padding::@3 to printf_padding::@1 [phi:printf_padding::@3->printf_padding::@1]
    // [1183] phi printf_padding::i#2 = printf_padding::i#1 [phi:printf_padding::@3->printf_padding::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    i: .byte 0
    length: .byte 0
}
.segment Code
  // ultoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __mem() unsigned long ultoa_append(__mem() char *buffer, __mem() unsigned long value, __mem() unsigned long sub)
ultoa_append: {
    // [1191] phi from ultoa_append to ultoa_append::@1 [phi:ultoa_append->ultoa_append::@1]
    // [1191] phi ultoa_append::digit#2 = 0 [phi:ultoa_append->ultoa_append::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [1191] phi ultoa_append::value#2 = ultoa_append::value#0 [phi:ultoa_append->ultoa_append::@1#1] -- register_copy 
    // ultoa_append::@1
  __b1:
    // while (value >= sub)
    // [1192] if(ultoa_append::value#2>=ultoa_append::sub#0) goto ultoa_append::@2 -- vdum1_ge_vdum2_then_la1 
    lda value+3
    cmp sub+3
    bcc !+
    bne __b2
    lda value+2
    cmp sub+2
    bcc !+
    bne __b2
    lda value+1
    cmp sub+1
    bcc !+
    bne __b2
    lda value
    cmp sub
    bcs __b2
  !:
    // ultoa_append::@3
    // *buffer = DIGITS[digit]
    // [1193] *ultoa_append::buffer#0 = DIGITS[ultoa_append::digit#2] -- _deref_pbum1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy buffer
    sty.z $fe
    ldy buffer+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // ultoa_append::@return
    // }
    // [1194] return 
    rts
    // ultoa_append::@2
  __b2:
    // digit++;
    // [1195] ultoa_append::digit#1 = ++ ultoa_append::digit#2 -- vbuxx=_inc_vbuxx 
    inx
    // value -= sub
    // [1196] ultoa_append::value#1 = ultoa_append::value#2 - ultoa_append::sub#0 -- vdum1=vdum1_minus_vdum2 
    lda value
    sec
    sbc sub
    sta value
    lda value+1
    sbc sub+1
    sta value+1
    lda value+2
    sbc sub+2
    sta value+2
    lda value+3
    sbc sub+3
    sta value+3
    // [1191] phi from ultoa_append::@2 to ultoa_append::@1 [phi:ultoa_append::@2->ultoa_append::@1]
    // [1191] phi ultoa_append::digit#2 = ultoa_append::digit#1 [phi:ultoa_append::@2->ultoa_append::@1#0] -- register_copy 
    // [1191] phi ultoa_append::value#2 = ultoa_append::value#1 [phi:ultoa_append::@2->ultoa_append::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    buffer: .word 0
    value: .dword 0
    sub: .dword 0
    return: .dword 0
}
.segment CodeBramHeap
  // bram_heap_clear_free
// void bram_heap_clear_free(char s, __register(X) char index)
bram_heap_clear_free: {
    // bram_heap_index.size1[index] &= 0x7F
    // [1198] ((char *)&bram_heap_index+$300)[bram_heap_clear_free::index#2] = ((char *)&bram_heap_index+$300)[bram_heap_clear_free::index#2] & $7f -- pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_band_vbuc2 
    lda #$7f
    and bram_heap_index+$300,x
    sta bram_heap_index+$300,x
    // bram_heap_clear_free::@return
    // }
    // [1199] return 
    rts
}
  // bram_heap_heap_insert_at
// char bram_heap_heap_insert_at(__mem() char s, __mem() char heap_index, char at, __mem() unsigned int size)
bram_heap_heap_insert_at: {
    // bram_heap_list_insert_at(s, bram_heap_segment.heap_list[s], heap_index, at)
    // [1201] bram_heap_list_insert_at::list#1 = ((char *)&bram_heap_segment+$2a)[bram_heap_heap_insert_at::s#2] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy s
    ldx bram_heap_segment+$2a,y
    // [1202] bram_heap_list_insert_at::index#1 = bram_heap_heap_insert_at::heap_index#2 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_list_insert_at.index
    // [1203] call bram_heap_list_insert_at
    // [671] phi from bram_heap_heap_insert_at to bram_heap_list_insert_at [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at]
    // [671] phi bram_heap_list_insert_at::index#10 = bram_heap_list_insert_at::index#1 [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at#0] -- register_copy 
    // [671] phi bram_heap_list_insert_at::at#11 = $ff [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at#1] -- vbum1=vbuc1 
    lda #$ff
    sta bram_heap_list_insert_at.at
    // [671] phi bram_heap_list_insert_at::list#5 = bram_heap_list_insert_at::list#1 [phi:bram_heap_heap_insert_at->bram_heap_list_insert_at#2] -- call_phi_near 
    jsr bram_heap_list_insert_at
    // bram_heap_list_insert_at(s, bram_heap_segment.heap_list[s], heap_index, at)
    // [1204] bram_heap_list_insert_at::return#1 = bram_heap_list_insert_at::list#11 -- vbuaa=vbuxx 
    txa
    // bram_heap_heap_insert_at::@1
    // [1205] bram_heap_heap_insert_at::$0 = bram_heap_list_insert_at::return#1
    // bram_heap_segment.heap_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.heap_list[s], heap_index, at)
    // [1206] ((char *)&bram_heap_segment+$2a)[bram_heap_heap_insert_at::s#2] = bram_heap_heap_insert_at::$0 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy s
    sta bram_heap_segment+$2a,y
    // bram_heap_set_size_packed(s, heap_index, size)
    // [1207] bram_heap_set_size_packed::index#1 = bram_heap_heap_insert_at::heap_index#2 -- vbuxx=vbum1 
    ldx heap_index
    // [1208] bram_heap_set_size_packed::size_packed#1 = bram_heap_heap_insert_at::size#2 -- vwum1=vwum2 
    lda size
    sta bram_heap_set_size_packed.size_packed
    lda size+1
    sta bram_heap_set_size_packed.size_packed+1
    // [1209] call bram_heap_set_size_packed
    // [692] phi from bram_heap_heap_insert_at::@1 to bram_heap_set_size_packed [phi:bram_heap_heap_insert_at::@1->bram_heap_set_size_packed]
    // [692] phi bram_heap_set_size_packed::size_packed#6 = bram_heap_set_size_packed::size_packed#1 [phi:bram_heap_heap_insert_at::@1->bram_heap_set_size_packed#0] -- register_copy 
    // [692] phi bram_heap_set_size_packed::index#6 = bram_heap_set_size_packed::index#1 [phi:bram_heap_heap_insert_at::@1->bram_heap_set_size_packed#1] -- call_phi_near 
    jsr bram_heap_set_size_packed
    // bram_heap_heap_insert_at::@2
    // bram_heap_segment.heapCount[s]++;
    // [1210] bram_heap_heap_insert_at::$4 = bram_heap_heap_insert_at::s#2 << 1 -- vbuaa=vbum1_rol_1 
    lda s
    asl
    // [1211] ((unsigned int *)&bram_heap_segment+$3e)[bram_heap_heap_insert_at::$4] = ++ ((unsigned int *)&bram_heap_segment+$3e)[bram_heap_heap_insert_at::$4] -- pwuc1_derefidx_vbuaa=_inc_pwuc1_derefidx_vbuaa 
    tax
    inc bram_heap_segment+$3e,x
    bne !+
    inc bram_heap_segment+$3e+1,x
  !:
    // bram_heap_heap_insert_at::@return
    // }
    // [1212] return 
    rts
  .segment Data
    s: .byte 0
    heap_index: .byte 0
    size: .word 0
}
.segment Code
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
// void insertup(char rows)
insertup: {
    // __conio.width+1
    // [1213] insertup::$0 = *((char *)&__conio+6) + 1 -- vbuaa=_deref_pbuc1_plus_1 
    lda __conio+6
    inc
    // unsigned char width = (__conio.width+1) * 2
    // [1214] insertup::width#0 = insertup::$0 << 1 -- vbum1=vbuaa_rol_1 
    // {asm{.byte $db}}
    asl
    sta width
    // [1215] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [1215] phi insertup::y#2 = 0 [phi:insertup->insertup::@1#0] -- vbum1=vbuc1 
    lda #0
    sta y
    // insertup::@1
  __b1:
    // for(unsigned char y=0; y<__conio.cursor_y; y++)
    // [1216] if(insertup::y#2<*((char *)&__conio+1)) goto insertup::@2 -- vbum1_lt__deref_pbuc1_then_la1 
    lda y
    cmp __conio+1
    bcc __b2
    // [1217] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [1218] call clearline -- call_phi_near 
    jsr clearline
    // insertup::@return
    // }
    // [1219] return 
    rts
    // insertup::@2
  __b2:
    // y+1
    // [1220] insertup::$4 = insertup::y#2 + 1 -- vbuxx=vbum1_plus_1 
    ldx y
    inx
    // memcpy8_vram_vram(__conio.mapbase_bank, __conio.offsets[y], __conio.mapbase_bank, __conio.offsets[y+1], width)
    // [1221] insertup::$6 = insertup::y#2 << 1 -- vbuyy=vbum1_rol_1 
    lda y
    asl
    tay
    // [1222] insertup::$7 = insertup::$4 << 1 -- vbuxx=vbuxx_rol_1 
    txa
    asl
    tax
    // [1223] memcpy8_vram_vram::dbank_vram#0 = *((char *)&__conio+5) -- vbum1=_deref_pbuc1 
    lda __conio+5
    sta memcpy8_vram_vram.dbank_vram
    // [1224] memcpy8_vram_vram::doffset_vram#0 = ((unsigned int *)&__conio+$15)[insertup::$6] -- vwum1=pwuc1_derefidx_vbuyy 
    lda __conio+$15,y
    sta memcpy8_vram_vram.doffset_vram
    lda __conio+$15+1,y
    sta memcpy8_vram_vram.doffset_vram+1
    // [1225] memcpy8_vram_vram::sbank_vram#0 = *((char *)&__conio+5) -- vbum1=_deref_pbuc1 
    lda __conio+5
    sta memcpy8_vram_vram.sbank_vram
    // [1226] memcpy8_vram_vram::soffset_vram#0 = ((unsigned int *)&__conio+$15)[insertup::$7] -- vwum1=pwuc1_derefidx_vbuxx 
    lda __conio+$15,x
    sta memcpy8_vram_vram.soffset_vram
    lda __conio+$15+1,x
    sta memcpy8_vram_vram.soffset_vram+1
    // [1227] memcpy8_vram_vram::num8#1 = insertup::width#0 -- vbuyy=vbum1 
    ldy width
    // [1228] call memcpy8_vram_vram -- call_phi_near 
    jsr memcpy8_vram_vram
    // insertup::@4
    // for(unsigned char y=0; y<__conio.cursor_y; y++)
    // [1229] insertup::y#1 = ++ insertup::y#2 -- vbum1=_inc_vbum1 
    inc y
    // [1215] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [1215] phi insertup::y#2 = insertup::y#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    width: .byte 0
    y: .byte 0
}
.segment Code
  // clearline
clearline: {
    // unsigned int addr = __conio.offsets[__conio.cursor_y]
    // [1230] clearline::$3 = *((char *)&__conio+1) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda __conio+1
    asl
    // [1231] clearline::addr#0 = ((unsigned int *)&__conio+$15)[clearline::$3] -- vwum1=pwuc1_derefidx_vbuaa 
    tay
    lda __conio+$15,y
    sta addr
    lda __conio+$15+1,y
    sta addr+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1232] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(addr)
    // [1233] clearline::$0 = byte0  clearline::addr#0 -- vbuaa=_byte0_vwum1 
    lda addr
    // *VERA_ADDRX_L = BYTE0(addr)
    // [1234] *VERA_ADDRX_L = clearline::$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(addr)
    // [1235] clearline::$1 = byte1  clearline::addr#0 -- vbuaa=_byte1_vwum1 
    lda addr+1
    // *VERA_ADDRX_M = BYTE1(addr)
    // [1236] *VERA_ADDRX_M = clearline::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [1237] clearline::$2 = *((char *)&__conio+5) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [1238] *VERA_ADDRX_H = clearline::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // register unsigned char c=__conio.width
    // [1239] clearline::c#0 = *((char *)&__conio+6) -- vbuxx=_deref_pbuc1 
    ldx __conio+6
    // [1240] phi from clearline clearline::@1 to clearline::@1 [phi:clearline/clearline::@1->clearline::@1]
    // [1240] phi clearline::c#2 = clearline::c#0 [phi:clearline/clearline::@1->clearline::@1#0] -- register_copy 
    // clearline::@1
  __b1:
    // *VERA_DATA0 = ' '
    // [1241] *VERA_DATA0 = ' 'pm -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [1242] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // c--;
    // [1243] clearline::c#1 = -- clearline::c#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(c)
    // [1244] if(0!=clearline::c#1) goto clearline::@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b1
    // clearline::@return
    // }
    // [1245] return 
    rts
  .segment Data
    .label addr = ultoa_append.buffer
}
.segment Code
  // utoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __mem() unsigned int utoa_append(__mem() char *buffer, __mem() unsigned int value, __mem() unsigned int sub)
utoa_append: {
    // [1247] phi from utoa_append to utoa_append::@1 [phi:utoa_append->utoa_append::@1]
    // [1247] phi utoa_append::digit#2 = 0 [phi:utoa_append->utoa_append::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [1247] phi utoa_append::value#2 = utoa_append::value#0 [phi:utoa_append->utoa_append::@1#1] -- register_copy 
    // utoa_append::@1
  __b1:
    // while (value >= sub)
    // [1248] if(utoa_append::value#2>=utoa_append::sub#0) goto utoa_append::@2 -- vwum1_ge_vwum2_then_la1 
    lda sub+1
    cmp value+1
    bne !+
    lda sub
    cmp value
    beq __b2
  !:
    bcc __b2
    // utoa_append::@3
    // *buffer = DIGITS[digit]
    // [1249] *utoa_append::buffer#0 = DIGITS[utoa_append::digit#2] -- _deref_pbum1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy buffer
    sty.z $fe
    ldy buffer+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // utoa_append::@return
    // }
    // [1250] return 
    rts
    // utoa_append::@2
  __b2:
    // digit++;
    // [1251] utoa_append::digit#1 = ++ utoa_append::digit#2 -- vbuxx=_inc_vbuxx 
    inx
    // value -= sub
    // [1252] utoa_append::value#1 = utoa_append::value#2 - utoa_append::sub#0 -- vwum1=vwum1_minus_vwum2 
    lda value
    sec
    sbc sub
    sta value
    lda value+1
    sbc sub+1
    sta value+1
    // [1247] phi from utoa_append::@2 to utoa_append::@1 [phi:utoa_append::@2->utoa_append::@1]
    // [1247] phi utoa_append::digit#2 = utoa_append::digit#1 [phi:utoa_append::@2->utoa_append::@1#0] -- register_copy 
    // [1247] phi utoa_append::value#2 = utoa_append::value#1 [phi:utoa_append::@2->utoa_append::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    buffer: .word 0
    value: .word 0
    sub: .word 0
    .label return = buffer
}
.segment Code
  // memcpy8_vram_vram
/**
 * @brief Copy a block of memory in VRAM from a source to a target destination.
 * This function is designed to copy maximum 255 bytes of memory in one step.
 * If more than 255 bytes need to be copied, use the memcpy_vram_vram function.
 *
 * @see memcpy_vram_vram
 *
 * @param dbank_vram Bank of the destination location in vram.
 * @param doffset_vram Offset of the destination location in vram.
 * @param sbank_vram Bank of the source location in vram.
 * @param soffset_vram Offset of the source location in vram.
 * @param num16 Specified the amount of bytes to be copied.
 */
// void memcpy8_vram_vram(__mem() char dbank_vram, __mem() unsigned int doffset_vram, __mem() char sbank_vram, __mem() unsigned int soffset_vram, __register(X) char num8)
memcpy8_vram_vram: {
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1253] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(soffset_vram)
    // [1254] memcpy8_vram_vram::$0 = byte0  memcpy8_vram_vram::soffset_vram#0 -- vbuaa=_byte0_vwum1 
    lda soffset_vram
    // *VERA_ADDRX_L = BYTE0(soffset_vram)
    // [1255] *VERA_ADDRX_L = memcpy8_vram_vram::$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(soffset_vram)
    // [1256] memcpy8_vram_vram::$1 = byte1  memcpy8_vram_vram::soffset_vram#0 -- vbuaa=_byte1_vwum1 
    lda soffset_vram+1
    // *VERA_ADDRX_M = BYTE1(soffset_vram)
    // [1257] *VERA_ADDRX_M = memcpy8_vram_vram::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // sbank_vram | VERA_INC_1
    // [1258] memcpy8_vram_vram::$2 = memcpy8_vram_vram::sbank_vram#0 | VERA_INC_1 -- vbuaa=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora sbank_vram
    // *VERA_ADDRX_H = sbank_vram | VERA_INC_1
    // [1259] *VERA_ADDRX_H = memcpy8_vram_vram::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [1260] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [1261] memcpy8_vram_vram::$3 = byte0  memcpy8_vram_vram::doffset_vram#0 -- vbuaa=_byte0_vwum1 
    lda doffset_vram
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [1262] *VERA_ADDRX_L = memcpy8_vram_vram::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [1263] memcpy8_vram_vram::$4 = byte1  memcpy8_vram_vram::doffset_vram#0 -- vbuaa=_byte1_vwum1 
    lda doffset_vram+1
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [1264] *VERA_ADDRX_M = memcpy8_vram_vram::$4 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // dbank_vram | VERA_INC_1
    // [1265] memcpy8_vram_vram::$5 = memcpy8_vram_vram::dbank_vram#0 | VERA_INC_1 -- vbuaa=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora dbank_vram
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [1266] *VERA_ADDRX_H = memcpy8_vram_vram::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [1267] phi from memcpy8_vram_vram memcpy8_vram_vram::@2 to memcpy8_vram_vram::@1 [phi:memcpy8_vram_vram/memcpy8_vram_vram::@2->memcpy8_vram_vram::@1]
  __b1:
    // [1267] phi memcpy8_vram_vram::num8#2 = memcpy8_vram_vram::num8#1 [phi:memcpy8_vram_vram/memcpy8_vram_vram::@2->memcpy8_vram_vram::@1#0] -- register_copy 
  // the size is only a byte, this is the fastest loop!
    // memcpy8_vram_vram::@1
    // while (num8--)
    // [1268] memcpy8_vram_vram::num8#0 = -- memcpy8_vram_vram::num8#2 -- vbuxx=_dec_vbuyy 
    tya
    tax
    dex
    // [1269] if(0!=memcpy8_vram_vram::num8#2) goto memcpy8_vram_vram::@2 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne __b2
    // memcpy8_vram_vram::@return
    // }
    // [1270] return 
    rts
    // memcpy8_vram_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [1271] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // [1272] memcpy8_vram_vram::num8#6 = memcpy8_vram_vram::num8#0 -- vbuyy=vbuxx 
    txa
    tay
    jmp __b1
  .segment Data
    dbank_vram: .byte 0
    .label doffset_vram = ultoa_append.buffer
    sbank_vram: .byte 0
    soffset_vram: .word 0
}
  // File Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // Values of binary digits
  RADIX_BINARY_VALUES: .word $8000, $4000, $2000, $1000, $800, $400, $200, $100, $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES: .word $8000, $1000, $200, $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES: .word $1000, $100, $10
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_LONG: .dword $10000000, $1000000, $100000, $10000, $1000, $100, $10
.segment DataBramHeap
  funcs: .word bram_heap_alloc, bram_heap_free, bram_heap_bram_bank_init, bram_heap_segment_init, bram_heap_data_get_bank, bram_heap_data_get_offset, bram_heap_get_size, bram_heap_dump
  s2: .text " size "
  .byte 0
  s3: .text "."
  .byte 0
  s4: .text @"\n"
  .byte 0
  string_0: .text "true"
  .byte 0
  string_1: .text "false"
  .byte 0
  string_2: .text " is free "
  .byte 0
  string_3: .text " with offset "
  .byte 0
.segment Data
  __conio: .fill SIZEOF_STRUCT___0, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
.segment BramBramHeap
  bram_heap_index: .fill SIZEOF_STRUCT___1, 0
.segment DataBramHeap
  bram_heap_segment: .fill SIZEOF_STRUCT___2, 0
  // The segment management is in main memory.
  bramheap_dx: .byte 0
  bramheap_dy: .byte 0
}