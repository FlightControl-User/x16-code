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
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .const SIZEOF_STRUCT___1 = $8f
  .const SIZEOF_STRUCT___3 = $36
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
    // __mem __export word isr_vsync = 0x0314
    // [3] isr_vsync = $314 -- vwum1=vwuc1 
    lda #<$314
    sta isr_vsync
    lda #>$314
    sta isr_vsync+1
    // __mem unsigned char bramheap_dx = 0
    // [4] bramheap_dx = 0 -- vbum1=vbuc1 
    lda #0
    sta bramheap_dx
    // __mem unsigned char bramheap_dy = 0
    // [5] bramheap_dy = 0 -- vbum1=vbuc1 
    sta bramheap_dy
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [6] callexecute conio_x16_init  -- call_vprc1 
    jsr conio_x16_init
    // __lib_bramheap_start::@return
    // [7] return 
    rts
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
    .label bram_heap_dump_index_print__9 = $f
    // if (list == BRAM_HEAP_NULL)
    // [8] if(bram_heap_dump_index_print::list!=$ff) goto bram_heap_dump_index_print::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp list
    bne __b1
    // bram_heap_dump_index_print::@return
    // }
    // [9] return 
    rts
    // bram_heap_dump_index_print::@1
  __b1:
    // bram_heap_index_t index = list
    // [10] bram_heap_dump_index_print::index#0 = bram_heap_dump_index_print::list -- vbum1=vbum2 
    lda list
    sta index
    // bram_heap_index_t end_index = list
    // [11] bram_heap_dump_index_print::end_index#0 = bram_heap_dump_index_print::list -- vbum1=vbum2 
    lda list
    sta end_index
    // [12] phi from bram_heap_dump_index_print::@1 to bram_heap_dump_index_print::@2 [phi:bram_heap_dump_index_print::@1->bram_heap_dump_index_print::@2]
    // [12] phi bram_heap_dump_index_print::count#2 = 0 [phi:bram_heap_dump_index_print::@1->bram_heap_dump_index_print::@2#0] -- vwum1=vwuc1 
    lda #<0
    sta count
    sta count+1
    // [12] phi bram_heap_dump_index_print::index#2 = bram_heap_dump_index_print::index#0 [phi:bram_heap_dump_index_print::@1->bram_heap_dump_index_print::@2#1] -- register_copy 
    // [12] phi from bram_heap_dump_index_print::@5 to bram_heap_dump_index_print::@2 [phi:bram_heap_dump_index_print::@5->bram_heap_dump_index_print::@2]
    // [12] phi bram_heap_dump_index_print::count#2 = bram_heap_dump_index_print::count#1 [phi:bram_heap_dump_index_print::@5->bram_heap_dump_index_print::@2#0] -- register_copy 
    // [12] phi bram_heap_dump_index_print::index#2 = bram_heap_dump_index_print::index#1 [phi:bram_heap_dump_index_print::@5->bram_heap_dump_index_print::@2#1] -- register_copy 
    // bram_heap_dump_index_print::@2
  __b2:
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [13] gotoxy::x = bramheap_dx -- vbum1=vbum2 
    lda bramheap_dx
    sta gotoxy.x
    // [14] gotoxy::y = bramheap_dy -- vbum1=vbum2 
    lda bramheap_dy
    sta gotoxy.y
    // [15] callexecute gotoxy  -- call_vprc1 
    jsr gotoxy
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [16] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // bram_heap_is_free(s, index)
    // [17] bram_heap_is_free::s = bram_heap_dump_index_print::s -- vbum1=vbum2 
    lda s
    sta bram_heap_is_free.s
    // [18] bram_heap_is_free::index = bram_heap_dump_index_print::index#2 -- vbum1=vbum2 
    lda index
    sta bram_heap_is_free.index
    // [19] callexecute bram_heap_is_free  -- call_vprc1 
    jsr bram_heap_is_free
    // [20] bram_heap_dump_index_print::$3 = bram_heap_is_free::return
    // bram_heap_is_free(s, index)?'*':' '
    // [21] if(bram_heap_dump_index_print::$3) goto bram_heap_dump_index_print::@3 -- vbom1_then_la1 
    lda bram_heap_dump_index_print__3
    cmp #0
    bne __b3
    // [23] phi from bram_heap_dump_index_print::@2 to bram_heap_dump_index_print::@4 [phi:bram_heap_dump_index_print::@2->bram_heap_dump_index_print::@4]
    // [23] phi bram_heap_dump_index_print::$6 = ' 'pm [phi:bram_heap_dump_index_print::@2->bram_heap_dump_index_print::@4#0] -- vbum1=vbuc1 
  .encoding "petscii_mixed"
    lda #' '
    sta bram_heap_dump_index_print__6
    jmp __b4
    // [22] phi from bram_heap_dump_index_print::@2 to bram_heap_dump_index_print::@3 [phi:bram_heap_dump_index_print::@2->bram_heap_dump_index_print::@3]
    // bram_heap_dump_index_print::@3
  __b3:
    // bram_heap_is_free(s, index)?'*':' '
    // [23] phi from bram_heap_dump_index_print::@3 to bram_heap_dump_index_print::@4 [phi:bram_heap_dump_index_print::@3->bram_heap_dump_index_print::@4]
    // [23] phi bram_heap_dump_index_print::$6 = '*'pm [phi:bram_heap_dump_index_print::@3->bram_heap_dump_index_print::@4#0] -- vbum1=vbuc1 
    lda #'*'
    sta bram_heap_dump_index_print__6
    // bram_heap_dump_index_print::@4
  __b4:
    // printf("%03x %c%c ", index, prefix, (bram_heap_is_free(s, index)?'*':' '))
    // [24] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [25] printf_uchar::uvalue = bram_heap_dump_index_print::index#2 -- vbum1=vbum2 
    lda index
    sta printf_uchar.uvalue
    // [26] printf_uchar::format_min_length = 3 -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [27] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [28] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [29] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [30] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [31] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [32] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // [33] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [34] printf_str::s = bram_heap_dump_index_print::s1 -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    // [35] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [36] stackpush(char) = bram_heap_dump_index_print::prefix -- _stackpushbyte_=vbum1 
    lda prefix
    pha
    // [37] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // [39] stackpush(char) = bram_heap_dump_index_print::$6 -- _stackpushbyte_=vbum1 
    lda bram_heap_dump_index_print__6
    pha
    // [40] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // [42] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [43] printf_str::s = bram_heap_dump_index_print::s1 -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    // [44] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // bram_heap_data_get_bank(s, index)
    // [45] bram_heap_data_get_bank::s = bram_heap_dump_index_print::s -- vbum1=vbum2 
    lda s
    sta lib_bramheap.bram_heap_data_get_bank.s
    // [46] bram_heap_data_get_bank::index = bram_heap_dump_index_print::index#2 -- vbum1=vbum2 
    lda index
    sta lib_bramheap.bram_heap_data_get_bank.index
    // [47] callexecute bram_heap_data_get_bank  -- call_var_near 
    jsr bram_heap_data_get_bank
    // [48] bram_heap_dump_index_print::$8 = bram_heap_data_get_bank::return
    // bram_heap_data_get_offset(s, index)
    // [49] bram_heap_data_get_offset::s = bram_heap_dump_index_print::s -- vbum1=vbum2 
    lda s
    sta lib_bramheap.bram_heap_data_get_offset.s
    // [50] bram_heap_data_get_offset::index = bram_heap_dump_index_print::index#2 -- vbum1=vbum2 
    lda index
    sta lib_bramheap.bram_heap_data_get_offset.index
    // [51] callexecute bram_heap_data_get_offset  -- call_var_near 
    jsr bram_heap_data_get_offset
    // [52] bram_heap_dump_index_print::$9 = bram_heap_data_get_offset::return
    // bram_heap_get_size(s, index)
    // [53] bram_heap_get_size::s = bram_heap_dump_index_print::s -- vbum1=vbum2 
    lda s
    sta lib_bramheap.bram_heap_get_size.s
    // [54] bram_heap_get_size::index = bram_heap_dump_index_print::index#2 -- vbum1=vbum2 
    lda index
    sta lib_bramheap.bram_heap_get_size.index
    // [55] callexecute bram_heap_get_size  -- call_var_near 
    jsr bram_heap_get_size
    // [56] bram_heap_dump_index_print::$10 = bram_heap_get_size::return
    // printf("%02x%04p %05x  ", bram_heap_data_get_bank(s, index), bram_heap_data_get_offset(s, index), bram_heap_get_size(s, index))
    // [57] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [58] printf_uchar::uvalue = bram_heap_dump_index_print::$8 -- vbum1=vbum2 
    lda bram_heap_dump_index_print__8
    sta printf_uchar.uvalue
    // [59] printf_uchar::format_min_length = 2 -- vbum1=vbuc1 
    lda #2
    sta printf_uchar.format_min_length
    // [60] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [61] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [62] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [63] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [64] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [65] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // [66] printf_uint::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uint.putc
    lda #>cputc
    sta.z printf_uint.putc+1
    // [67] printf_uint::uvalue = (unsigned int)bram_heap_dump_index_print::$9 -- vwum1=vwuz2 
    lda.z bram_heap_dump_index_print__9
    sta printf_uint.uvalue
    lda.z bram_heap_dump_index_print__9+1
    sta printf_uint.uvalue+1
    // [68] printf_uint::format_min_length = 4 -- vbum1=vbuc1 
    lda #4
    sta printf_uint.format_min_length
    // [69] printf_uint::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uint.format_justify_left
    // [70] printf_uint::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uint.format_sign_always
    // [71] printf_uint::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uint.format_zero_padding
    // [72] printf_uint::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uint.format_upper_case
    // [73] printf_uint::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uint.format_radix
    // [74] callexecute printf_uint  -- call_vprc1 
    jsr printf_uint
    // [75] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [76] printf_str::s = bram_heap_dump_index_print::s1 -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    // [77] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [78] printf_ulong::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_ulong.putc
    lda #>cputc
    sta.z printf_ulong.putc+1
    // [79] printf_ulong::uvalue = bram_heap_dump_index_print::$10 -- vdum1=vdum2 
    lda bram_heap_dump_index_print__10
    sta printf_ulong.uvalue
    lda bram_heap_dump_index_print__10+1
    sta printf_ulong.uvalue+1
    lda bram_heap_dump_index_print__10+2
    sta printf_ulong.uvalue+2
    lda bram_heap_dump_index_print__10+3
    sta printf_ulong.uvalue+3
    // [80] printf_ulong::format_min_length = 5 -- vbum1=vbuc1 
    lda #5
    sta printf_ulong.format_min_length
    // [81] printf_ulong::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_ulong.format_justify_left
    // [82] printf_ulong::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_ulong.format_sign_always
    // [83] printf_ulong::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_ulong.format_zero_padding
    // [84] printf_ulong::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_ulong.format_upper_case
    // [85] printf_ulong::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_ulong.format_radix
    // [86] callexecute printf_ulong  -- call_vprc1 
    jsr printf_ulong
    // [87] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [88] printf_str::s = bram_heap_dump_index_print::s4 -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    // [89] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // bram_heap_get_next(s, index)
    // [90] bram_heap_get_next::s = bram_heap_dump_index_print::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_next.s
    // [91] bram_heap_get_next::index = bram_heap_dump_index_print::index#2 -- vbum1=vbum2 
    lda index
    sta bram_heap_get_next.index
    // [92] callexecute bram_heap_get_next  -- call_vprc1 
    jsr bram_heap_get_next
    // [93] bram_heap_dump_index_print::$12 = bram_heap_get_next::return
    // bram_heap_get_prev(s, index)
    // [94] bram_heap_get_prev::s = bram_heap_dump_index_print::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_prev.s
    // [95] bram_heap_get_prev::index = bram_heap_dump_index_print::index#2 -- vbum1=vbum2 
    lda index
    sta bram_heap_get_prev.index
    // [96] callexecute bram_heap_get_prev  -- call_vprc1 
    jsr bram_heap_get_prev
    // [97] bram_heap_dump_index_print::$13 = bram_heap_get_prev::return
    // printf("%03x  %03x  ", bram_heap_get_next(s, index), bram_heap_get_prev(s, index))
    // [98] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [99] printf_uchar::uvalue = bram_heap_dump_index_print::$12 -- vbum1=vbum2 
    lda bram_heap_dump_index_print__12
    sta printf_uchar.uvalue
    // [100] printf_uchar::format_min_length = 3 -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [101] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [102] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [103] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [104] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [105] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [106] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // [107] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [108] printf_str::s = bram_heap_dump_index_print::s4 -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    // [109] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [110] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [111] printf_uchar::uvalue = bram_heap_dump_index_print::$13 -- vbum1=vbum2 
    lda bram_heap_dump_index_print__13
    sta printf_uchar.uvalue
    // [112] printf_uchar::format_min_length = 3 -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [113] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [114] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [115] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [116] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [117] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [118] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // [119] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [120] printf_str::s = bram_heap_dump_index_print::s4 -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    // [121] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // bram_heap_get_left(s, index)
    // [122] bram_heap_get_left::s = bram_heap_dump_index_print::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_left.s
    // [123] bram_heap_get_left::index = bram_heap_dump_index_print::index#2 -- vbum1=vbum2 
    lda index
    sta bram_heap_get_left.index
    // [124] callexecute bram_heap_get_left  -- call_vprc1 
    jsr bram_heap_get_left
    // [125] bram_heap_dump_index_print::$15 = bram_heap_get_left::return
    // bram_heap_get_right(s, index)
    // [126] bram_heap_get_right::s = bram_heap_dump_index_print::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_right.s
    // [127] bram_heap_get_right::index = bram_heap_dump_index_print::index#2 -- vbum1=vbum2 
    lda index
    sta bram_heap_get_right.index
    // [128] callexecute bram_heap_get_right  -- call_vprc1 
    jsr bram_heap_get_right
    // [129] bram_heap_dump_index_print::$16 = bram_heap_get_right::return
    // printf("%03x  %03x", bram_heap_get_left(s, index), bram_heap_get_right(s, index))
    // [130] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [131] printf_uchar::uvalue = bram_heap_dump_index_print::$15 -- vbum1=vbum2 
    lda bram_heap_dump_index_print__15
    sta printf_uchar.uvalue
    // [132] printf_uchar::format_min_length = 3 -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [133] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [134] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [135] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [136] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [137] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [138] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // [139] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [140] printf_str::s = bram_heap_dump_index_print::s4 -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    // [141] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [142] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [143] printf_uchar::uvalue = bram_heap_dump_index_print::$16 -- vbum1=vbum2 
    lda bram_heap_dump_index_print__16
    sta printf_uchar.uvalue
    // [144] printf_uchar::format_min_length = 3 -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [145] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [146] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [147] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [148] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [149] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [150] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // bram_heap_get_next(s, index)
    // [151] bram_heap_get_next::s = bram_heap_dump_index_print::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_next.s
    // [152] bram_heap_get_next::index = bram_heap_dump_index_print::index#2 -- vbum1=vbum2 
    lda index
    sta bram_heap_get_next.index
    // [153] callexecute bram_heap_get_next  -- call_vprc1 
    jsr bram_heap_get_next
    // index = bram_heap_get_next(s, index)
    // [154] bram_heap_dump_index_print::index#1 = bram_heap_get_next::return -- vbum1=vbum2 
    lda bram_heap_get_next.return
    sta index
    // if(++count > heap_count && index!=end_index)
    // [155] bram_heap_dump_index_print::count#1 = ++ bram_heap_dump_index_print::count#2 -- vwum1=_inc_vwum1 
    inc count
    bne !+
    inc count+1
  !:
    // [156] if(bram_heap_dump_index_print::count#1<=bram_heap_dump_index_print::heap_count) goto bram_heap_dump_index_print::@5 -- vwum1_le_vwum2_then_la1 
    lda count+1
    cmp heap_count+1
    bne !+
    lda count
    cmp heap_count
    beq __b5
  !:
    bcc __b5
    // bram_heap_dump_index_print::@7
    // [157] if(bram_heap_dump_index_print::index#1!=bram_heap_dump_index_print::end_index#0) goto bram_heap_dump_index_print::@6 -- vbum1_neq_vbum2_then_la1 
    lda index
    cmp end_index
    bne __b6
    // bram_heap_dump_index_print::@5
  __b5:
    // while (index != end_index)
    // [158] if(bram_heap_dump_index_print::index#1!=bram_heap_dump_index_print::end_index#0) goto bram_heap_dump_index_print::@2 -- vbum1_neq_vbum2_then_la1 
    lda index
    cmp end_index
    beq !__b2+
    jmp __b2
  !__b2:
    rts
    // bram_heap_dump_index_print::@6
  __b6:
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [159] gotoxy::x = bramheap_dx -- vbum1=vbum2 
    lda bramheap_dx
    sta gotoxy.x
    // [160] gotoxy::y = bramheap_dy -- vbum1=vbum2 
    lda bramheap_dy
    sta gotoxy.y
    // [161] callexecute gotoxy  -- call_vprc1 
    jsr gotoxy
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [162] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // printf("ABORT i: %03x e:%03x, l:%03x\n", index, end_index, list)
    // [163] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [164] printf_str::s = bram_heap_dump_index_print::s8 -- pbuz1=pbuc1 
    lda #<s8
    sta.z printf_str.s
    lda #>s8
    sta.z printf_str.s+1
    // [165] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [166] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [167] printf_uchar::uvalue = bram_heap_dump_index_print::index#1 -- vbum1=vbum2 
    lda index
    sta printf_uchar.uvalue
    // [168] printf_uchar::format_min_length = 3 -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [169] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [170] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [171] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [172] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [173] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [174] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // [175] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [176] printf_str::s = bram_heap_dump_index_print::s9 -- pbuz1=pbuc1 
    lda #<s9
    sta.z printf_str.s
    lda #>s9
    sta.z printf_str.s+1
    // [177] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [178] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [179] printf_uchar::uvalue = bram_heap_dump_index_print::end_index#0 -- vbum1=vbum2 
    lda end_index
    sta printf_uchar.uvalue
    // [180] printf_uchar::format_min_length = 3 -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [181] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [182] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [183] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [184] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [185] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [186] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // [187] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [188] printf_str::s = bram_heap_dump_index_print::s10 -- pbuz1=pbuc1 
    lda #<s10
    sta.z printf_str.s
    lda #>s10
    sta.z printf_str.s+1
    // [189] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [190] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [191] printf_uchar::uvalue = bram_heap_dump_index_print::list -- vbum1=vbum2 
    lda list
    sta printf_uchar.uvalue
    // [192] printf_uchar::format_min_length = 3 -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [193] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [194] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [195] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [196] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [197] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [198] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // [199] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [200] printf_str::s = bram_heap_dump_index_print::s11 -- pbuz1=pbuc1 
    lda #<s11
    sta.z printf_str.s
    lda #>s11
    sta.z printf_str.s+1
    // [201] callexecute printf_str  -- call_vprc1 
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
    s11: .text @"\n"
    .byte 0
    s: .byte 0
    prefix: .byte 0
    list: .byte 0
    heap_count: .word 0
    .label bram_heap_dump_index_print__3 = bram_heap_find_best_fit.best_index
    bram_heap_dump_index_print__6: .byte 0
    .label bram_heap_dump_index_print__8 = bram_heap_index_add.index
    bram_heap_dump_index_print__10: .dword 0
    .label bram_heap_dump_index_print__12 = bram_heap_dump_index_print__6
    .label bram_heap_dump_index_print__13 = lib_bramheap.bram_heap_get_size.index
    .label bram_heap_dump_index_print__15 = bram_heap_get_left.index
    .label bram_heap_dump_index_print__16 = bram_heap_get_right.index
    index: .byte 0
    end_index: .byte 0
    count: .word 0
}
.segment CodeBramHeap
  // bram_heap_coalesce
/**
 * Coalesces two adjacent blocks to the left.
 * The left is a free index and the right is the heap index to be freed.
 * The free index remains free, and the heap to the right stays heap.
 * The free index is returned as the new remaining (free) block.
 */
// __mem() char bram_heap_coalesce(__mem() char s, __mem() char left_index, __mem() char right_index)
bram_heap_coalesce: {
    // bram_heap_size_packed_t right_size = bram_heap_get_size_packed(s, right_index)
    // [202] bram_heap_get_size_packed::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_size_packed.s
    // [203] bram_heap_get_size_packed::index = bram_heap_coalesce::right_index -- vbum1=vbum2 
    lda right_index
    sta bram_heap_get_size_packed.index
    // [204] callexecute bram_heap_get_size_packed  -- call_vprc1 
    jsr bram_heap_get_size_packed
    // [205] bram_heap_coalesce::right_size#0 = bram_heap_get_size_packed::return -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return
    sta right_size
    lda bram_heap_get_size_packed.return+1
    sta right_size+1
    // bram_heap_size_packed_t left_size = bram_heap_get_size_packed(s, left_index)
    // [206] bram_heap_get_size_packed::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_size_packed.s
    // [207] bram_heap_get_size_packed::index = bram_heap_coalesce::left_index -- vbum1=vbum2 
    lda left_index
    sta bram_heap_get_size_packed.index
    // [208] callexecute bram_heap_get_size_packed  -- call_vprc1 
    jsr bram_heap_get_size_packed
    // [209] bram_heap_coalesce::left_size#0 = bram_heap_get_size_packed::return -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return
    sta left_size
    lda bram_heap_get_size_packed.return+1
    sta left_size+1
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [210] bram_heap_get_data_packed::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_data_packed.s
    // [211] bram_heap_get_data_packed::index = bram_heap_coalesce::left_index -- vbum1=vbum2 
    lda left_index
    sta bram_heap_get_data_packed.index
    // [212] callexecute bram_heap_get_data_packed  -- call_vprc1 
    jsr bram_heap_get_data_packed
    // [213] bram_heap_coalesce::left_offset#0 = bram_heap_get_data_packed::return
    // bram_heap_index_t free_left = bram_heap_get_left(s, left_index)
    // [214] bram_heap_get_left::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_left.s
    // [215] bram_heap_get_left::index = bram_heap_coalesce::left_index -- vbum1=vbum2 
    lda left_index
    sta bram_heap_get_left.index
    // [216] callexecute bram_heap_get_left  -- call_vprc1 
    jsr bram_heap_get_left
    // [217] bram_heap_coalesce::free_left#0 = bram_heap_get_left::return -- vbum1=vbum2 
    lda bram_heap_get_left.return
    sta free_left
    // bram_heap_index_t free_right = bram_heap_get_right(s, right_index)
    // [218] bram_heap_get_right::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_right.s
    // [219] bram_heap_get_right::index = bram_heap_coalesce::right_index -- vbum1=vbum2 
    lda right_index
    sta bram_heap_get_right.index
    // [220] callexecute bram_heap_get_right  -- call_vprc1 
    jsr bram_heap_get_right
    // [221] bram_heap_coalesce::free_right#0 = bram_heap_get_right::return
    // bram_heap_free_remove(s, left_index)
    // [222] bram_heap_free_remove::s = bram_heap_coalesce::s -- vbum1=vbum2 
    // We detach the left index from the free list and add it to the idle list.
    lda s
    sta bram_heap_free_remove.s
    // [223] bram_heap_free_remove::free_index = bram_heap_coalesce::left_index -- vbum1=vbum2 
    lda left_index
    sta bram_heap_free_remove.free_index
    // [224] callexecute bram_heap_free_remove  -- call_vprc1 
    jsr bram_heap_free_remove
    // bram_heap_idle_insert(s, left_index)
    // [225] bram_heap_idle_insert::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_idle_insert.s
    // [226] bram_heap_idle_insert::idle_index = bram_heap_coalesce::left_index -- vbum1=vbum2 
    lda left_index
    sta bram_heap_idle_insert.idle_index
    // [227] callexecute bram_heap_idle_insert  -- call_vprc1 
    jsr bram_heap_idle_insert
    // bram_heap_set_left(s, right_index, free_left)
    // [228] bram_heap_set_left::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_left.s
    // [229] bram_heap_set_left::index = bram_heap_coalesce::right_index -- vbum1=vbum2 
    lda right_index
    sta bram_heap_set_left.index
    // [230] bram_heap_set_left::left = bram_heap_coalesce::free_left#0 -- vbum1=vbum2 
    lda free_left
    sta bram_heap_set_left.left
    // [231] callexecute bram_heap_set_left  -- call_vprc1 
    jsr bram_heap_set_left
    // bram_heap_set_right(s, right_index, free_right)
    // [232] bram_heap_set_right::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_right.s
    // [233] bram_heap_set_right::index = bram_heap_coalesce::right_index -- vbum1=vbum2 
    lda right_index
    sta bram_heap_set_right.index
    // [234] bram_heap_set_right::right = bram_heap_coalesce::free_right#0 -- vbum1=vbum2 
    lda free_right
    sta bram_heap_set_right.right
    // [235] callexecute bram_heap_set_right  -- call_vprc1 
    jsr bram_heap_set_right
    // bram_heap_set_left(s, free_right, right_index)
    // [236] bram_heap_set_left::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_left.s
    // [237] bram_heap_set_left::index = bram_heap_coalesce::free_right#0 -- vbum1=vbum2 
    lda free_right
    sta bram_heap_set_left.index
    // [238] bram_heap_set_left::left = bram_heap_coalesce::right_index -- vbum1=vbum2 
    lda right_index
    sta bram_heap_set_left.left
    // [239] callexecute bram_heap_set_left  -- call_vprc1 
    jsr bram_heap_set_left
    // bram_heap_set_right(s, free_left, right_index)
    // [240] bram_heap_set_right::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_right.s
    // [241] bram_heap_set_right::index = bram_heap_coalesce::free_left#0 -- vbum1=vbum2 
    lda free_left
    sta bram_heap_set_right.index
    // [242] bram_heap_set_right::right = bram_heap_coalesce::right_index -- vbum1=vbum2 
    lda right_index
    sta bram_heap_set_right.right
    // [243] callexecute bram_heap_set_right  -- call_vprc1 
    jsr bram_heap_set_right
    // bram_heap_set_left(s, left_index, BRAM_HEAP_NULL)
    // [244] bram_heap_set_left::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_left.s
    // [245] bram_heap_set_left::index = bram_heap_coalesce::left_index -- vbum1=vbum2 
    lda left_index
    sta bram_heap_set_left.index
    // [246] bram_heap_set_left::left = $ff -- vbum1=vbuc1 
    lda #$ff
    sta bram_heap_set_left.left
    // [247] callexecute bram_heap_set_left  -- call_vprc1 
    jsr bram_heap_set_left
    // bram_heap_set_right(s, left_index, BRAM_HEAP_NULL)
    // [248] bram_heap_set_right::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_right.s
    // [249] bram_heap_set_right::index = bram_heap_coalesce::left_index -- vbum1=vbum2 
    lda left_index
    sta bram_heap_set_right.index
    // [250] bram_heap_set_right::right = $ff -- vbum1=vbuc1 
    lda #$ff
    sta bram_heap_set_right.right
    // [251] callexecute bram_heap_set_right  -- call_vprc1 
    jsr bram_heap_set_right
    // left_size + right_size
    // [252] bram_heap_coalesce::$13 = bram_heap_coalesce::left_size#0 + bram_heap_coalesce::right_size#0 -- vwum1=vwum2_plus_vwum1 
    clc
    lda bram_heap_coalesce__13
    adc left_size
    sta bram_heap_coalesce__13
    lda bram_heap_coalesce__13+1
    adc left_size+1
    sta bram_heap_coalesce__13+1
    // bram_heap_set_size_packed(s, right_index, left_size + right_size)
    // [253] bram_heap_set_size_packed::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_size_packed.s
    // [254] bram_heap_set_size_packed::index = bram_heap_coalesce::right_index -- vbum1=vbum2 
    lda right_index
    sta bram_heap_set_size_packed.index
    // [255] bram_heap_set_size_packed::size_packed = bram_heap_coalesce::$13 -- vwum1=vwum2 
    lda bram_heap_coalesce__13
    sta bram_heap_set_size_packed.size_packed
    lda bram_heap_coalesce__13+1
    sta bram_heap_set_size_packed.size_packed+1
    // [256] callexecute bram_heap_set_size_packed  -- call_vprc1 
    jsr bram_heap_set_size_packed
    // bram_heap_set_data_packed(s, right_index, left_offset)
    // [257] bram_heap_set_data_packed::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_data_packed.s
    // [258] bram_heap_set_data_packed::index = bram_heap_coalesce::right_index -- vbum1=vbum2 
    lda right_index
    sta bram_heap_set_data_packed.index
    // [259] bram_heap_set_data_packed::data_packed = bram_heap_coalesce::left_offset#0 -- vwum1=vwum2 
    lda left_offset
    sta bram_heap_set_data_packed.data_packed
    lda left_offset+1
    sta bram_heap_set_data_packed.data_packed+1
    // [260] callexecute bram_heap_set_data_packed  -- call_vprc1 
    jsr bram_heap_set_data_packed
    // bram_heap_set_free(s, left_index)
    // [261] bram_heap_set_free::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_free.s
    // [262] bram_heap_set_free::index = bram_heap_coalesce::left_index -- vbum1=vbum2 
    lda left_index
    sta bram_heap_set_free.index
    // [263] callexecute bram_heap_set_free  -- call_vprc1 
    jsr bram_heap_set_free
    // bram_heap_set_free(s, right_index)
    // [264] bram_heap_set_free::s = bram_heap_coalesce::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_free.s
    // [265] bram_heap_set_free::index = bram_heap_coalesce::right_index -- vbum1=vbum2 
    lda right_index
    sta bram_heap_set_free.index
    // [266] callexecute bram_heap_set_free  -- call_vprc1 
    jsr bram_heap_set_free
    // return right_index;
    // [267] bram_heap_coalesce::return = bram_heap_coalesce::right_index
    // bram_heap_coalesce::@return
    // }
    // [268] return 
    rts
  .segment DataBramHeap
    s: .byte 0
    .label left_index = bram_heap_free.free_left_index
    .label right_index = return
    return: .byte 0
    .label bram_heap_coalesce__13 = right_size
    right_size: .word 0
    .label left_size = bram_heap_find_best_fit.best_size
    left_offset: .word 0
    free_left: .byte 0
    .label free_right = bram_heap_get_right.index
}
.segment CodeBramHeap
  // heap_can_coalesce_right
/**
 * Whether we should merge this header to the right.
 */
// __mem() char heap_can_coalesce_right(__mem() char s, __mem() char heap_index)
heap_can_coalesce_right: {
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [269] bram_heap_get_data_packed::s = heap_can_coalesce_right::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_data_packed.s
    // [270] bram_heap_get_data_packed::index = heap_can_coalesce_right::heap_index -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_get_data_packed.index
    // [271] callexecute bram_heap_get_data_packed  -- call_vprc1 
    jsr bram_heap_get_data_packed
    // [272] heap_can_coalesce_right::heap_offset#0 = bram_heap_get_data_packed::return -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return
    sta heap_offset
    lda bram_heap_get_data_packed.return+1
    sta heap_offset+1
    // bram_heap_index_t right_index = bram_heap_get_right(s, heap_index)
    // [273] bram_heap_get_right::s = heap_can_coalesce_right::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_right.s
    // [274] bram_heap_get_right::index = heap_can_coalesce_right::heap_index
    // [275] callexecute bram_heap_get_right  -- call_vprc1 
    jsr bram_heap_get_right
    // [276] heap_can_coalesce_right::right_index#0 = bram_heap_get_right::return -- vbum1=vbum2 
    lda bram_heap_get_right.return
    sta right_index
    // bram_heap_data_packed_t right_offset = bram_heap_get_data_packed(s, right_index)
    // [277] bram_heap_get_data_packed::s = heap_can_coalesce_right::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_data_packed.s
    // [278] bram_heap_get_data_packed::index = heap_can_coalesce_right::right_index#0 -- vbum1=vbum2 
    lda right_index
    sta bram_heap_get_data_packed.index
    // [279] callexecute bram_heap_get_data_packed  -- call_vprc1 
    jsr bram_heap_get_data_packed
    // [280] heap_can_coalesce_right::right_offset#0 = bram_heap_get_data_packed::return
    // bool right_free = bram_heap_is_free(s, right_index)
    // [281] bram_heap_is_free::s = heap_can_coalesce_right::s -- vbum1=vbum2 
    lda s
    sta bram_heap_is_free.s
    // [282] bram_heap_is_free::index = heap_can_coalesce_right::right_index#0 -- vbum1=vbum2 
    lda right_index
    sta bram_heap_is_free.index
    // [283] callexecute bram_heap_is_free  -- call_vprc1 
    jsr bram_heap_is_free
    // [284] heap_can_coalesce_right::right_free#0 = bram_heap_is_free::return
    // if(right_free && (heap_offset < right_offset))
    // [285] if(heap_can_coalesce_right::right_free#0) goto heap_can_coalesce_right::@3 -- vbom1_then_la1 
    lda right_free
    cmp #0
    bne __b3
    jmp __b1
    // heap_can_coalesce_right::@3
  __b3:
    // [286] if(heap_can_coalesce_right::heap_offset#0<heap_can_coalesce_right::right_offset#0) goto heap_can_coalesce_right::@2 -- vwum1_lt_vwum2_then_la1 
    lda heap_offset+1
    cmp right_offset+1
    bcc __breturn
    bne !+
    lda heap_offset
    cmp right_offset
    bcc __breturn
  !:
    // heap_can_coalesce_right::@1
  __b1:
    // return BRAM_HEAP_NULL;
    // [287] heap_can_coalesce_right::return = $ff -- vbum1=vbuc1 
    // A free_index is not found, we cannot coalesce.
    lda #$ff
    sta return
    // heap_can_coalesce_right::@return
  __breturn:
    // }
    // [288] return 
    rts
    // heap_can_coalesce_right::@2
    // return right_index;
    // [289] heap_can_coalesce_right::return = heap_can_coalesce_right::right_index#0
  .segment DataBramHeap
    .label s = lib_bramheap.bram_heap_get_size.index
    .label heap_index = bram_heap_get_right.index
    .label return = bram_heap_index_add.index
    heap_offset: .word 0
    .label right_index = bram_heap_index_add.index
    .label right_offset = bram_heap_coalesce.left_offset
    .label right_free = bram_heap_find_best_fit.best_index
}
.segment CodeBramHeap
  // bram_heap_can_coalesce_left
/**
 * Whether we should merge this header to the left.
 */
// __mem() char bram_heap_can_coalesce_left(__mem() char s, __mem() char heap_index)
bram_heap_can_coalesce_left: {
    // bram_heap_data_packed_t heap_offset = bram_heap_get_data_packed(s, heap_index)
    // [290] bram_heap_get_data_packed::s = bram_heap_can_coalesce_left::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_data_packed.s
    // [291] bram_heap_get_data_packed::index = bram_heap_can_coalesce_left::heap_index -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_get_data_packed.index
    // [292] callexecute bram_heap_get_data_packed  -- call_vprc1 
    jsr bram_heap_get_data_packed
    // [293] bram_heap_can_coalesce_left::heap_offset#0 = bram_heap_get_data_packed::return -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return
    sta heap_offset
    lda bram_heap_get_data_packed.return+1
    sta heap_offset+1
    // bram_heap_index_t left_index = bram_heap_get_left(s, heap_index)
    // [294] bram_heap_get_left::s = bram_heap_can_coalesce_left::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_left.s
    // [295] bram_heap_get_left::index = bram_heap_can_coalesce_left::heap_index
    // [296] callexecute bram_heap_get_left  -- call_vprc1 
    jsr bram_heap_get_left
    // [297] bram_heap_can_coalesce_left::left_index#0 = bram_heap_get_left::return -- vbum1=vbum2 
    lda bram_heap_get_left.return
    sta left_index
    // bram_heap_data_packed_t left_offset = bram_heap_get_data_packed(s, left_index)
    // [298] bram_heap_get_data_packed::s = bram_heap_can_coalesce_left::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_data_packed.s
    // [299] bram_heap_get_data_packed::index = bram_heap_can_coalesce_left::left_index#0 -- vbum1=vbum2 
    lda left_index
    sta bram_heap_get_data_packed.index
    // [300] callexecute bram_heap_get_data_packed  -- call_vprc1 
    jsr bram_heap_get_data_packed
    // [301] bram_heap_can_coalesce_left::left_offset#0 = bram_heap_get_data_packed::return -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return
    sta left_offset
    lda bram_heap_get_data_packed.return+1
    sta left_offset+1
    // bool left_free = bram_heap_is_free(s, left_index)
    // [302] bram_heap_is_free::s = bram_heap_can_coalesce_left::s
    // [303] bram_heap_is_free::index = bram_heap_can_coalesce_left::left_index#0 -- vbum1=vbum2 
    lda left_index
    sta bram_heap_is_free.index
    // [304] callexecute bram_heap_is_free  -- call_vprc1 
    jsr bram_heap_is_free
    // [305] bram_heap_can_coalesce_left::left_free#0 = bram_heap_is_free::return
    // if(left_free && (left_offset < heap_offset))
    // [306] if(bram_heap_can_coalesce_left::left_free#0) goto bram_heap_can_coalesce_left::@3 -- vbom1_then_la1 
    lda left_free
    cmp #0
    bne __b3
    jmp __b1
    // bram_heap_can_coalesce_left::@3
  __b3:
    // [307] if(bram_heap_can_coalesce_left::left_offset#0<bram_heap_can_coalesce_left::heap_offset#0) goto bram_heap_can_coalesce_left::@2 -- vwum1_lt_vwum2_then_la1 
    lda left_offset+1
    cmp heap_offset+1
    bcc __breturn
    bne !+
    lda left_offset
    cmp heap_offset
    bcc __breturn
  !:
    // bram_heap_can_coalesce_left::@1
  __b1:
    // return BRAM_HEAP_NULL;
    // [308] bram_heap_can_coalesce_left::return = $ff -- vbum1=vbuc1 
    lda #$ff
    sta return
    // bram_heap_can_coalesce_left::@return
  __breturn:
    // }
    // [309] return 
    rts
    // bram_heap_can_coalesce_left::@2
    // return left_index;
    // [310] bram_heap_can_coalesce_left::return = bram_heap_can_coalesce_left::left_index#0
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    .label heap_index = bram_heap_get_left.index
    .label return = lib_bramheap.bram_heap_get_size.s
    heap_offset: .word 0
    .label left_index = lib_bramheap.bram_heap_get_size.s
    .label left_offset = bram_heap_find_best_fit.best_size
    .label left_free = bram_heap_find_best_fit.best_index
}
.segment CodeBramHeap
  // bram_heap_find_best_fit
/**
 * Best-fit algorithm.
 */
// __mem() char bram_heap_find_best_fit(__mem() char s, __mem() unsigned int requested_size)
bram_heap_find_best_fit: {
    // bram_heap_index_t free_index = bram_heap_segment.free_list[s]
    // [311] bram_heap_find_best_fit::free_index#0 = ((char *)&bram_heap_segment+$19)[bram_heap_find_best_fit::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$19,y
    sta free_index
    // if(free_index == BRAM_HEAP_NULL)
    // [312] if(bram_heap_find_best_fit::free_index#0!=$ff) goto bram_heap_find_best_fit::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp free_index
    bne __b1
    // bram_heap_find_best_fit::@3
    // return BRAM_HEAP_NULL;
    // [313] bram_heap_find_best_fit::return = $ff -- vbum1=vbuc1 
    sta return
    // bram_heap_find_best_fit::@return
    // }
    // [314] return 
    rts
    // bram_heap_find_best_fit::@1
  __b1:
    // bram_heap_index_t free_end = bram_heap_segment.free_list[s]
    // [315] bram_heap_find_best_fit::free_end#0 = ((char *)&bram_heap_segment+$19)[bram_heap_find_best_fit::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$19,y
    sta free_end
    // [316] phi from bram_heap_find_best_fit::@1 to bram_heap_find_best_fit::@4 [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@4]
    // [316] phi bram_heap_find_best_fit::best_index#5 = $ff [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@4#0] -- vbum1=vbuc1 
    lda #$ff
    sta best_index
    // [316] phi bram_heap_find_best_fit::best_size#2 = $ffff [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@4#1] -- vwum1=vwuc1 
    lda #<$ffff
    sta best_size
    lda #>$ffff
    sta best_size+1
    // [316] phi bram_heap_find_best_fit::free_index#2 = bram_heap_find_best_fit::free_index#0 [phi:bram_heap_find_best_fit::@1->bram_heap_find_best_fit::@4#2] -- register_copy 
    // bram_heap_find_best_fit::@4
  __b4:
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [317] bram_heap_get_size_packed::s = bram_heap_find_best_fit::s -- vbum1=vbum2 
    // O(n) search.
    lda s
    sta bram_heap_get_size_packed.s
    // [318] bram_heap_get_size_packed::index = bram_heap_find_best_fit::free_index#2 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_get_size_packed.index
    // [319] callexecute bram_heap_get_size_packed  -- call_vprc1 
    jsr bram_heap_get_size_packed
    // [320] bram_heap_find_best_fit::free_size#0 = bram_heap_get_size_packed::return
    // if(free_size >= requested_size && free_size < best_size)
    // [321] if(bram_heap_find_best_fit::free_size#0<bram_heap_find_best_fit::requested_size) goto bram_heap_find_best_fit::@11 -- vwum1_lt_vwum2_then_la1 
    lda free_size+1
    cmp requested_size+1
    bcc __b11
    bne !+
    lda free_size
    cmp requested_size
    bcc __b11
  !:
    // bram_heap_find_best_fit::@9
    // [322] if(bram_heap_find_best_fit::free_size#0>=bram_heap_find_best_fit::best_size#2) goto bram_heap_find_best_fit::@5 -- vwum1_ge_vwum2_then_la1 
    lda best_size+1
    cmp free_size+1
    bne !+
    lda best_size
    cmp free_size
    beq __b5
  !:
    bcc __b5
    // bram_heap_find_best_fit::@6
    // [323] bram_heap_find_best_fit::best_index#8 = bram_heap_find_best_fit::free_index#2 -- vbum1=vbum2 
    lda free_index
    sta best_index
    // [324] phi from bram_heap_find_best_fit::@11 bram_heap_find_best_fit::@6 to bram_heap_find_best_fit::@5 [phi:bram_heap_find_best_fit::@11/bram_heap_find_best_fit::@6->bram_heap_find_best_fit::@5]
    // [324] phi bram_heap_find_best_fit::best_index#4 = bram_heap_find_best_fit::best_index#5 [phi:bram_heap_find_best_fit::@11/bram_heap_find_best_fit::@6->bram_heap_find_best_fit::@5#0] -- register_copy 
    // [324] phi bram_heap_find_best_fit::best_size#3 = bram_heap_find_best_fit::best_size#6 [phi:bram_heap_find_best_fit::@11/bram_heap_find_best_fit::@6->bram_heap_find_best_fit::@5#1] -- register_copy 
    // [324] phi from bram_heap_find_best_fit::@9 to bram_heap_find_best_fit::@5 [phi:bram_heap_find_best_fit::@9->bram_heap_find_best_fit::@5]
    // bram_heap_find_best_fit::@5
  __b5:
    // bram_heap_get_next(s, free_index)
    // [325] bram_heap_get_next::s = bram_heap_find_best_fit::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_next.s
    // [326] bram_heap_get_next::index = bram_heap_find_best_fit::free_index#2
    // [327] callexecute bram_heap_get_next  -- call_vprc1 
    jsr bram_heap_get_next
    // free_index = bram_heap_get_next(s, free_index)
    // [328] bram_heap_find_best_fit::free_index#1 = bram_heap_get_next::return
    // while(free_index != free_end)
    // [329] if(bram_heap_find_best_fit::free_index#1!=bram_heap_find_best_fit::free_end#0) goto bram_heap_find_best_fit::@10 -- vbum1_neq_vbum2_then_la1 
    lda free_index
    cmp free_end
    bne __b10
    // bram_heap_find_best_fit::@7
    // if(requested_size <= best_size)
    // [330] if(bram_heap_find_best_fit::requested_size>bram_heap_find_best_fit::best_size#3) goto bram_heap_find_best_fit::@2 -- vwum1_gt_vwum2_then_la1 
    lda best_size_1+1
    cmp requested_size+1
    bcc __b2
    bne !+
    lda best_size_1
    cmp requested_size
    bcc __b2
  !:
    // bram_heap_find_best_fit::@8
    // return best_index;
    // [331] bram_heap_find_best_fit::return = bram_heap_find_best_fit::best_index#4
    rts
    // bram_heap_find_best_fit::@2
  __b2:
    // return BRAM_HEAP_NULL;
    // [332] bram_heap_find_best_fit::return = $ff -- vbum1=vbuc1 
    lda #$ff
    sta return
    rts
    // bram_heap_find_best_fit::@10
  __b10:
    // [333] bram_heap_find_best_fit::best_size#5 = bram_heap_find_best_fit::best_size#3 -- vwum1=vwum2 
    lda best_size_1
    sta best_size
    lda best_size_1+1
    sta best_size+1
    // [316] phi from bram_heap_find_best_fit::@10 to bram_heap_find_best_fit::@4 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@4]
    // [316] phi bram_heap_find_best_fit::best_index#5 = bram_heap_find_best_fit::best_index#4 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@4#0] -- register_copy 
    // [316] phi bram_heap_find_best_fit::best_size#2 = bram_heap_find_best_fit::best_size#5 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@4#1] -- register_copy 
    // [316] phi bram_heap_find_best_fit::free_index#2 = bram_heap_find_best_fit::free_index#1 [phi:bram_heap_find_best_fit::@10->bram_heap_find_best_fit::@4#2] -- register_copy 
    jmp __b4
    // bram_heap_find_best_fit::@11
  __b11:
    // [334] bram_heap_find_best_fit::best_size#6 = bram_heap_find_best_fit::best_size#2 -- vwum1=vwum2 
    lda best_size
    sta best_size_1
    lda best_size+1
    sta best_size_1+1
    jmp __b5
  .segment DataBramHeap
    .label s = bram_heap_idle_insert.idle_index
    .label requested_size = bram_heap_free_insert.data
    .label return = best_index
    .label free_index = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    .label free_end = bram_heap_idle_insert.s
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
// __mem() char bram_heap_allocate(__mem() char s, __mem() char free_index, __mem() unsigned int required_size)
bram_heap_allocate: {
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [335] bram_heap_get_size_packed::s = bram_heap_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_size_packed.s
    // [336] bram_heap_get_size_packed::index = bram_heap_allocate::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_get_size_packed.index
    // [337] callexecute bram_heap_get_size_packed  -- call_vprc1 
    jsr bram_heap_get_size_packed
    // [338] bram_heap_allocate::free_size#0 = bram_heap_get_size_packed::return
    // if(free_size > required_size)
    // [339] if(bram_heap_allocate::free_size#0>bram_heap_allocate::required_size) goto bram_heap_allocate::@1 -- vwum1_gt_vwum2_then_la1 
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
    // [340] if(bram_heap_allocate::free_size#0==bram_heap_allocate::required_size) goto bram_heap_allocate::@4 -- vwum1_eq_vwum2_then_la1 
    lda free_size
    cmp required_size
    bne !+
    lda free_size+1
    cmp required_size+1
    beq __b4
  !:
    // bram_heap_allocate::@3
    // return BRAM_HEAP_NULL;
    // [341] bram_heap_allocate::return = $ff -- vbum1=vbuc1 
    lda #$ff
    sta return
    // bram_heap_allocate::@return
    // }
    // [342] return 
    rts
    // bram_heap_allocate::@4
  __b4:
    // bram_heap_replace_free_with_heap(s, free_index, required_size)
    // [343] bram_heap_replace_free_with_heap::s = bram_heap_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_replace_free_with_heap.s
    // [344] bram_heap_replace_free_with_heap::free_index = bram_heap_allocate::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_replace_free_with_heap.free_index
    // [345] bram_heap_replace_free_with_heap::required_size = bram_heap_allocate::required_size -- vwum1=vwum2 
    lda required_size
    sta bram_heap_replace_free_with_heap.required_size
    lda required_size+1
    sta bram_heap_replace_free_with_heap.required_size+1
    // [346] callexecute bram_heap_replace_free_with_heap  -- call_vprc1 
    jsr bram_heap_replace_free_with_heap
    // [347] bram_heap_allocate::$3 = bram_heap_replace_free_with_heap::return
    // return bram_heap_replace_free_with_heap(s, free_index, required_size);
    // [348] bram_heap_allocate::return = bram_heap_allocate::$3
    rts
    // bram_heap_allocate::@1
  __b1:
    // bram_heap_split_free_and_allocate(s, free_index, required_size)
    // [349] bram_heap_split_free_and_allocate::s = bram_heap_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_split_free_and_allocate.s
    // [350] bram_heap_split_free_and_allocate::free_index = bram_heap_allocate::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_split_free_and_allocate.free_index
    // [351] bram_heap_split_free_and_allocate::required_size = bram_heap_allocate::required_size -- vwum1=vwum2 
    lda required_size
    sta bram_heap_split_free_and_allocate.required_size
    lda required_size+1
    sta bram_heap_split_free_and_allocate.required_size+1
    // [352] callexecute bram_heap_split_free_and_allocate  -- call_vprc1 
    jsr bram_heap_split_free_and_allocate
    // [353] bram_heap_allocate::$4 = bram_heap_split_free_and_allocate::return
    // return bram_heap_split_free_and_allocate(s, free_index, required_size);
    // [354] bram_heap_allocate::return = bram_heap_allocate::$4
    rts
  .segment DataBramHeap
    .label s = bram_heap_get_right.index
    .label free_index = bram_heap_get_left.index
    .label required_size = bram_heap_coalesce.left_offset
    .label return = bram_heap_find_best_fit.best_index
    .label bram_heap_allocate__3 = bram_heap_find_best_fit.best_index
    .label bram_heap_allocate__4 = bram_heap_find_best_fit.best_index
    .label free_size = bram_heap_find_best_fit.best_size_1
}
.segment CodeBramHeap
  // bram_heap_split_free_and_allocate
/**
 * Splits the header on two, returns the pointer to the smaller sub-header.
 */
// __mem() char bram_heap_split_free_and_allocate(__mem() char s, __mem() char free_index, __mem() unsigned int required_size)
bram_heap_split_free_and_allocate: {
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [355] bram_heap_get_size_packed::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    // The free block is reduced in size with the required size.
    lda s
    sta bram_heap_get_size_packed.s
    // [356] bram_heap_get_size_packed::index = bram_heap_split_free_and_allocate::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_get_size_packed.index
    // [357] callexecute bram_heap_get_size_packed  -- call_vprc1 
    jsr bram_heap_get_size_packed
    // [358] bram_heap_split_free_and_allocate::free_size#0 = bram_heap_get_size_packed::return
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [359] bram_heap_get_data_packed::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_data_packed.s
    // [360] bram_heap_get_data_packed::index = bram_heap_split_free_and_allocate::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_get_data_packed.index
    // [361] callexecute bram_heap_get_data_packed  -- call_vprc1 
    jsr bram_heap_get_data_packed
    // [362] bram_heap_split_free_and_allocate::free_data#0 = bram_heap_get_data_packed::return -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return
    sta free_data
    lda bram_heap_get_data_packed.return+1
    sta free_data+1
    // free_size - required_size
    // [363] bram_heap_split_free_and_allocate::$2 = bram_heap_split_free_and_allocate::free_size#0 - bram_heap_split_free_and_allocate::required_size -- vwum1=vwum1_minus_vwum2 
    lda bram_heap_split_free_and_allocate__2
    sec
    sbc required_size
    sta bram_heap_split_free_and_allocate__2
    lda bram_heap_split_free_and_allocate__2+1
    sbc required_size+1
    sta bram_heap_split_free_and_allocate__2+1
    // bram_heap_set_size_packed(s, free_index, free_size - required_size)
    // [364] bram_heap_set_size_packed::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_size_packed.s
    // [365] bram_heap_set_size_packed::index = bram_heap_split_free_and_allocate::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_set_size_packed.index
    // [366] bram_heap_set_size_packed::size_packed = bram_heap_split_free_and_allocate::$2
    // [367] callexecute bram_heap_set_size_packed  -- call_vprc1 
    jsr bram_heap_set_size_packed
    // free_data + required_size
    // [368] bram_heap_split_free_and_allocate::$4 = bram_heap_split_free_and_allocate::free_data#0 + bram_heap_split_free_and_allocate::required_size -- vwum1=vwum2_plus_vwum3 
    lda free_data
    clc
    adc required_size
    sta bram_heap_split_free_and_allocate__4
    lda free_data+1
    adc required_size+1
    sta bram_heap_split_free_and_allocate__4+1
    // bram_heap_set_data_packed(s, free_index, free_data + required_size)
    // [369] bram_heap_set_data_packed::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_data_packed.s
    // [370] bram_heap_set_data_packed::index = bram_heap_split_free_and_allocate::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_set_data_packed.index
    // [371] bram_heap_set_data_packed::data_packed = bram_heap_split_free_and_allocate::$4
    // [372] callexecute bram_heap_set_data_packed  -- call_vprc1 
    jsr bram_heap_set_data_packed
    // bram_heap_index_t heap_index = bram_heap_index_add(s)
    // [373] bram_heap_index_add::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    // We create a new heap block with the required size.
    // The data is the offset in vram.
    lda s
    sta bram_heap_index_add.s
    // [374] callexecute bram_heap_index_add  -- call_vprc1 
    jsr bram_heap_index_add
    // [375] bram_heap_split_free_and_allocate::heap_index#0 = bram_heap_index_add::return -- vbum1=vbum2 
    lda bram_heap_index_add.return
    sta heap_index
    // bram_heap_set_data_packed(s, heap_index, free_data)
    // [376] bram_heap_set_data_packed::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_data_packed.s
    // [377] bram_heap_set_data_packed::index = bram_heap_split_free_and_allocate::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_set_data_packed.index
    // [378] bram_heap_set_data_packed::data_packed = bram_heap_split_free_and_allocate::free_data#0 -- vwum1=vwum2 
    lda free_data
    sta bram_heap_set_data_packed.data_packed
    lda free_data+1
    sta bram_heap_set_data_packed.data_packed+1
    // [379] callexecute bram_heap_set_data_packed  -- call_vprc1 
    jsr bram_heap_set_data_packed
    // bram_heap_heap_insert_at(s, heap_index, BRAM_HEAP_NULL, required_size)
    // [380] bram_heap_heap_insert_at::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_heap_insert_at.s
    // [381] bram_heap_heap_insert_at::heap_index = bram_heap_split_free_and_allocate::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_heap_insert_at.heap_index
    // [382] bram_heap_heap_insert_at::at = $ff -- vbum1=vbuc1 
    lda #$ff
    sta bram_heap_heap_insert_at.at
    // [383] bram_heap_heap_insert_at::size = bram_heap_split_free_and_allocate::required_size -- vwum1=vwum2 
    lda required_size
    sta bram_heap_heap_insert_at.size
    lda required_size+1
    sta bram_heap_heap_insert_at.size+1
    // [384] callexecute bram_heap_heap_insert_at  -- call_vprc1 
    jsr bram_heap_heap_insert_at
    // bram_heap_index_t heap_left = bram_heap_get_left(s, free_index)
    // [385] bram_heap_get_left::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_left.s
    // [386] bram_heap_get_left::index = bram_heap_split_free_and_allocate::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_get_left.index
    // [387] callexecute bram_heap_get_left  -- call_vprc1 
    jsr bram_heap_get_left
    // [388] bram_heap_split_free_and_allocate::heap_left#0 = bram_heap_get_left::return
    // bram_heap_index_t heap_right = free_index
    // [389] bram_heap_split_free_and_allocate::heap_right#0 = bram_heap_split_free_and_allocate::free_index -- vbum1=vbum2 
    lda free_index
    sta heap_right
    // bram_heap_set_left(s, heap_index, heap_left)
    // [390] bram_heap_set_left::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_left.s
    // [391] bram_heap_set_left::index = bram_heap_split_free_and_allocate::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_set_left.index
    // [392] bram_heap_set_left::left = bram_heap_split_free_and_allocate::heap_left#0 -- vbum1=vbum2 
    lda heap_left
    sta bram_heap_set_left.left
    // [393] callexecute bram_heap_set_left  -- call_vprc1 
    jsr bram_heap_set_left
    // bram_heap_set_right(s, heap_index, heap_right)
    // [394] bram_heap_set_right::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    // printf("\nright = %03x", heap_right);
    lda s
    sta bram_heap_set_right.s
    // [395] bram_heap_set_right::index = bram_heap_split_free_and_allocate::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_set_right.index
    // [396] bram_heap_set_right::right = bram_heap_split_free_and_allocate::heap_right#0 -- vbum1=vbum2 
    lda heap_right
    sta bram_heap_set_right.right
    // [397] callexecute bram_heap_set_right  -- call_vprc1 
    jsr bram_heap_set_right
    // bram_heap_set_right(s, heap_left, heap_index)
    // [398] bram_heap_set_right::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_right.s
    // [399] bram_heap_set_right::index = bram_heap_split_free_and_allocate::heap_left#0 -- vbum1=vbum2 
    lda heap_left
    sta bram_heap_set_right.index
    // [400] bram_heap_set_right::right = bram_heap_split_free_and_allocate::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_set_right.right
    // [401] callexecute bram_heap_set_right  -- call_vprc1 
    jsr bram_heap_set_right
    // bram_heap_set_left(s, heap_right, heap_index)
    // [402] bram_heap_set_left::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_left.s
    // [403] bram_heap_set_left::index = bram_heap_split_free_and_allocate::heap_right#0 -- vbum1=vbum2 
    lda heap_right
    sta bram_heap_set_left.index
    // [404] bram_heap_set_left::left = bram_heap_split_free_and_allocate::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_set_left.left
    // [405] callexecute bram_heap_set_left  -- call_vprc1 
    jsr bram_heap_set_left
    // bram_heap_set_free(s, heap_right)
    // [406] bram_heap_set_free::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_free.s
    // [407] bram_heap_set_free::index = bram_heap_split_free_and_allocate::heap_right#0
    // [408] callexecute bram_heap_set_free  -- call_vprc1 
    jsr bram_heap_set_free
    // bram_heap_clear_free(s, heap_left)
    // [409] bram_heap_clear_free::s = bram_heap_split_free_and_allocate::s -- vbum1=vbum2 
    lda s
    sta bram_heap_clear_free.s
    // [410] bram_heap_clear_free::index = bram_heap_split_free_and_allocate::heap_left#0
    // [411] callexecute bram_heap_clear_free  -- call_vprc1 
    jsr bram_heap_clear_free
    // return heap_index;
    // [412] bram_heap_split_free_and_allocate::return = bram_heap_split_free_and_allocate::heap_index#0
    // bram_heap_split_free_and_allocate::@return
    // }
    // [413] return 
    rts
  .segment DataBramHeap
    s: .byte 0
    free_index: .byte 0
    required_size: .word 0
    .label return = bram_heap_find_best_fit.best_index
    .label bram_heap_split_free_and_allocate__2 = bram_heap_find_best_fit.best_size_1
    .label bram_heap_split_free_and_allocate__4 = bram_heap_set_data_packed.data_packed
    .label free_size = bram_heap_find_best_fit.best_size_1
    .label free_data = heap_can_coalesce_right.heap_offset
    .label heap_index = bram_heap_find_best_fit.best_index
    .label heap_left = bram_heap_get_left.index
    .label heap_right = bram_heap_set_free.index
}
.segment CodeBramHeap
  // bram_heap_replace_free_with_heap
/**
 * The free size matches exactly the required heap size.
 * The free index is replaced by a heap index.
 */
// __mem() char bram_heap_replace_free_with_heap(__mem() char s, __mem() char free_index, __mem() unsigned int required_size)
bram_heap_replace_free_with_heap: {
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [414] bram_heap_get_size_packed::s = bram_heap_replace_free_with_heap::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_size_packed.s
    // [415] bram_heap_get_size_packed::index = bram_heap_replace_free_with_heap::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_get_size_packed.index
    // [416] callexecute bram_heap_get_size_packed  -- call_vprc1 
    jsr bram_heap_get_size_packed
    // bram_heap_data_packed_t free_data = bram_heap_get_data_packed(s, free_index)
    // [417] bram_heap_get_data_packed::s = bram_heap_replace_free_with_heap::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_data_packed.s
    // [418] bram_heap_get_data_packed::index = bram_heap_replace_free_with_heap::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_get_data_packed.index
    // [419] callexecute bram_heap_get_data_packed  -- call_vprc1 
    jsr bram_heap_get_data_packed
    // [420] bram_heap_replace_free_with_heap::free_data#0 = bram_heap_get_data_packed::return -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return
    sta free_data
    lda bram_heap_get_data_packed.return+1
    sta free_data+1
    // bram_heap_index_t free_left = bram_heap_get_left(s, free_index)
    // [421] bram_heap_get_left::s = bram_heap_replace_free_with_heap::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_left.s
    // [422] bram_heap_get_left::index = bram_heap_replace_free_with_heap::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_get_left.index
    // [423] callexecute bram_heap_get_left  -- call_vprc1 
    jsr bram_heap_get_left
    // [424] bram_heap_replace_free_with_heap::free_left#0 = bram_heap_get_left::return -- vbum1=vbum2 
    lda bram_heap_get_left.return
    sta free_left
    // bram_heap_index_t free_right = bram_heap_get_right(s, free_index)
    // [425] bram_heap_get_right::s = bram_heap_replace_free_with_heap::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_right.s
    // [426] bram_heap_get_right::index = bram_heap_replace_free_with_heap::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_get_right.index
    // [427] callexecute bram_heap_get_right  -- call_vprc1 
    jsr bram_heap_get_right
    // [428] bram_heap_replace_free_with_heap::free_right#0 = bram_heap_get_right::return -- vbum1=vbum2 
    lda bram_heap_get_right.return
    sta free_right
    // bram_heap_free_remove(s, free_index)
    // [429] bram_heap_free_remove::s = bram_heap_replace_free_with_heap::s -- vbum1=vbum2 
    lda s
    sta bram_heap_free_remove.s
    // [430] bram_heap_free_remove::free_index = bram_heap_replace_free_with_heap::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_free_remove.free_index
    // [431] callexecute bram_heap_free_remove  -- call_vprc1 
    jsr bram_heap_free_remove
    // bram_heap_index_t heap_index = free_index
    // [432] bram_heap_replace_free_with_heap::heap_index#0 = bram_heap_replace_free_with_heap::free_index -- vbum1=vbum2 
    lda free_index
    sta heap_index
    // bram_heap_heap_insert_at(s, heap_index, BRAM_HEAP_NULL, required_size)
    // [433] bram_heap_heap_insert_at::s = bram_heap_replace_free_with_heap::s -- vbum1=vbum2 
    lda s
    sta bram_heap_heap_insert_at.s
    // [434] bram_heap_heap_insert_at::heap_index = bram_heap_replace_free_with_heap::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_heap_insert_at.heap_index
    // [435] bram_heap_heap_insert_at::at = $ff -- vbum1=vbuc1 
    lda #$ff
    sta bram_heap_heap_insert_at.at
    // [436] bram_heap_heap_insert_at::size = bram_heap_replace_free_with_heap::required_size -- vwum1=vwum2 
    lda required_size
    sta bram_heap_heap_insert_at.size
    lda required_size+1
    sta bram_heap_heap_insert_at.size+1
    // [437] callexecute bram_heap_heap_insert_at  -- call_vprc1 
    jsr bram_heap_heap_insert_at
    // bram_heap_set_data_packed(s, heap_index, free_data)
    // [438] bram_heap_set_data_packed::s = bram_heap_replace_free_with_heap::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_data_packed.s
    // [439] bram_heap_set_data_packed::index = bram_heap_replace_free_with_heap::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_set_data_packed.index
    // [440] bram_heap_set_data_packed::data_packed = bram_heap_replace_free_with_heap::free_data#0
    // [441] callexecute bram_heap_set_data_packed  -- call_vprc1 
    jsr bram_heap_set_data_packed
    // bram_heap_set_left(s, heap_index, free_left)
    // [442] bram_heap_set_left::s = bram_heap_replace_free_with_heap::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_left.s
    // [443] bram_heap_set_left::index = bram_heap_replace_free_with_heap::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_set_left.index
    // [444] bram_heap_set_left::left = bram_heap_replace_free_with_heap::free_left#0
    // [445] callexecute bram_heap_set_left  -- call_vprc1 
    jsr bram_heap_set_left
    // bram_heap_set_right(s, heap_index, free_right)
    // [446] bram_heap_set_right::s = bram_heap_replace_free_with_heap::s
    // [447] bram_heap_set_right::index = bram_heap_replace_free_with_heap::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_set_right.index
    // [448] bram_heap_set_right::right = bram_heap_replace_free_with_heap::free_right#0
    // [449] callexecute bram_heap_set_right  -- call_vprc1 
    jsr bram_heap_set_right
    // return heap_index;
    // [450] bram_heap_replace_free_with_heap::return = bram_heap_replace_free_with_heap::heap_index#0 -- vbum1=vbum2 
    lda heap_index
    sta return
    // bram_heap_replace_free_with_heap::@return
    // }
    // [451] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_set_right.s
    free_index: .byte 0
    required_size: .word 0
    .label return = bram_heap_find_best_fit.best_index
    .label free_data = bram_heap_set_data_packed.data_packed
    .label free_left = bram_heap_set_left.left
    .label free_right = bram_heap_set_right.right
    heap_index: .byte 0
}
.segment CodeBramHeap
  // bram_heap_index_add
// __mem() char bram_heap_index_add(__mem() char s)
bram_heap_index_add: {
    // bram_heap_index_t index = bram_heap_segment.idle_list[s]
    // [452] bram_heap_index_add::index#0 = ((char *)&bram_heap_segment+$1b)[bram_heap_index_add::s] -- vbum1=pbuc1_derefidx_vbum2 
    // TODO: Search idle list.
    ldy s
    lda bram_heap_segment+$1b,y
    sta index
    // if(index != BRAM_HEAP_NULL)
    // [453] if(bram_heap_index_add::index#0!=$ff) goto bram_heap_index_add::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp index
    bne __b1
    // bram_heap_index_add::@3
    // index = bram_heap_segment.index_position[s]
    // [454] bram_heap_index_add::index#1 = ((char *)&bram_heap_segment+1)[bram_heap_index_add::s] -- vbum1=pbuc1_derefidx_vbum2 
    // The current header gets the current heap position handle.
    lda bram_heap_segment+1,y
    sta index
    // bram_heap_segment.index_position[s] + 1
    // [455] bram_heap_index_add::$1 = ((char *)&bram_heap_segment+1)[bram_heap_index_add::s] + 1 -- vbum1=pbuc1_derefidx_vbum2_plus_1 
    lda bram_heap_segment+1,y
    inc
    sta bram_heap_index_add__1
    // bram_heap_segment.index_position[s] = bram_heap_segment.index_position[s] + 1
    // [456] ((char *)&bram_heap_segment+1)[bram_heap_index_add::s] = bram_heap_index_add::$1 -- pbuc1_derefidx_vbum1=vbum2 
    // We adjust to the next index position.
    sta bram_heap_segment+1,y
    // [457] phi from bram_heap_index_add::@1 bram_heap_index_add::@3 to bram_heap_index_add::@2 [phi:bram_heap_index_add::@1/bram_heap_index_add::@3->bram_heap_index_add::@2]
    // [457] phi bram_heap_index_add::index#3 = bram_heap_index_add::index#0 [phi:bram_heap_index_add::@1/bram_heap_index_add::@3->bram_heap_index_add::@2#0] -- register_copy 
    // bram_heap_index_add::@2
    // return index;
    // [458] bram_heap_index_add::return = bram_heap_index_add::index#3
  // TODO: out of memory check.
    // bram_heap_index_add::@return
    // }
    // [459] return 
    rts
    // bram_heap_index_add::@1
  __b1:
    // heap_idle_remove(s, index)
    // [460] heap_idle_remove::s = bram_heap_index_add::s
    // [461] heap_idle_remove::idle_index = bram_heap_index_add::index#0 -- vbum1=vbum2 
    lda index
    sta heap_idle_remove.idle_index
    // [462] callexecute heap_idle_remove  -- call_vprc1 
    jsr heap_idle_remove
    rts
  .segment DataBramHeap
    s: .byte 0
    .label return = index
    .label bram_heap_index_add__1 = bram_heap_dump_index_print.index
    index: .byte 0
}
.segment CodeBramHeap
  // bram_heap_alloc_size_get
/**
 * Returns total allocation size, aligned to 8;
 */
/* inline */
// __mem() unsigned int bram_heap_alloc_size_get(__mem() unsigned long size)
bram_heap_alloc_size_get: {
    // size-1
    // [463] bram_heap_alloc_size_get::$0 = bram_heap_alloc_size_get::size - 1 -- vdum1=vdum1_minus_1 
    sec
    lda bram_heap_alloc_size_get__0
    sbc #1
    sta bram_heap_alloc_size_get__0
    lda bram_heap_alloc_size_get__0+1
    sbc #0
    sta bram_heap_alloc_size_get__0+1
    lda bram_heap_alloc_size_get__0+2
    sbc #0
    sta bram_heap_alloc_size_get__0+2
    lda bram_heap_alloc_size_get__0+3
    sbc #0
    sta bram_heap_alloc_size_get__0+3
    // bram_heap_size_pack(size-1)
    // [464] bram_heap_size_pack::size = bram_heap_alloc_size_get::$0
    // [465] callexecute bram_heap_size_pack  -- call_vprc1 
    jsr bram_heap_size_pack
    // [466] bram_heap_alloc_size_get::$1 = bram_heap_size_pack::return
    // bram_heap_size_pack(size-1) + 1
    // [467] bram_heap_alloc_size_get::$2 = bram_heap_alloc_size_get::$1 + 1 -- vwum1=vwum1_plus_1 
    inc bram_heap_alloc_size_get__2
    bne !+
    inc bram_heap_alloc_size_get__2+1
  !:
    // return (bram_heap_size_packed_t)((bram_heap_size_pack(size-1) + 1));
    // [468] bram_heap_alloc_size_get::return = bram_heap_alloc_size_get::$2
    // bram_heap_alloc_size_get::@return
    // }
    // [469] return 
    rts
  .segment DataBramHeap
    .label size = bram_heap_dump_index_print.bram_heap_dump_index_print__10
    .label return = bram_heap_alloc_size_get__1
    .label bram_heap_alloc_size_get__0 = bram_heap_dump_index_print.bram_heap_dump_index_print__10
    bram_heap_alloc_size_get__1: .word 0
    .label bram_heap_alloc_size_get__2 = bram_heap_alloc_size_get__1
}
.segment CodeBramHeap
  // heap_idle_remove
// void heap_idle_remove(__mem() char s, __mem() char idle_index)
heap_idle_remove: {
    // bram_heap_segment.idleCount[s]--;
    // [470] heap_idle_remove::$3 = heap_idle_remove::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta heap_idle_remove__3
    // [471] ((unsigned int *)&bram_heap_segment+$29)[heap_idle_remove::$3] = -- ((unsigned int *)&bram_heap_segment+$29)[heap_idle_remove::$3] -- pwuc1_derefidx_vbum1=_dec_pwuc1_derefidx_vbum1 
    tax
    lda bram_heap_segment+$29,x
    bne !+
    dec bram_heap_segment+$29+1,x
  !:
    dec bram_heap_segment+$29,x
    // bram_heap_list_remove(s, bram_heap_segment.idle_list[s], idle_index)
    // [472] bram_heap_list_remove::s = heap_idle_remove::s -- vbum1=vbum2 
    lda s
    sta bram_heap_list_remove.s
    // [473] bram_heap_list_remove::list = ((char *)&bram_heap_segment+$1b)[heap_idle_remove::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$1b,y
    sta bram_heap_list_remove.list
    // [474] bram_heap_list_remove::index = heap_idle_remove::idle_index
    // [475] callexecute bram_heap_list_remove  -- call_vprc1 
    jsr bram_heap_list_remove
    // [476] heap_idle_remove::$1 = bram_heap_list_remove::return
    // bram_heap_segment.idle_list[s] = bram_heap_list_remove(s, bram_heap_segment.idle_list[s], idle_index)
    // [477] ((char *)&bram_heap_segment+$1b)[heap_idle_remove::s] = heap_idle_remove::$1 -- pbuc1_derefidx_vbum1=vbum2 
    lda heap_idle_remove__1
    ldy s
    sta bram_heap_segment+$1b,y
    // heap_idle_remove::@return
    // }
    // [478] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_index_add.s
    idle_index: .byte 0
    .label heap_idle_remove__1 = bram_heap_list_remove.list
    .label heap_idle_remove__3 = bram_heap_dump_index_print.index
}
.segment CodeBramHeap
  // bram_heap_idle_insert
// char bram_heap_idle_insert(__mem() char s, __mem() char idle_index)
bram_heap_idle_insert: {
    // bram_heap_list_insert_at(s, bram_heap_segment.idle_list[s], idle_index, bram_heap_segment.idle_list[s])
    // [479] bram_heap_list_insert_at::s = bram_heap_idle_insert::s -- vbum1=vbum2 
    lda s
    sta bram_heap_list_insert_at.s
    // [480] bram_heap_list_insert_at::list = ((char *)&bram_heap_segment+$1b)[bram_heap_idle_insert::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$1b,y
    sta bram_heap_list_insert_at.list
    // [481] bram_heap_list_insert_at::index = bram_heap_idle_insert::idle_index -- vbum1=vbum2 
    lda idle_index
    sta bram_heap_list_insert_at.index
    // [482] bram_heap_list_insert_at::at = ((char *)&bram_heap_segment+$1b)[bram_heap_idle_insert::s] -- vbum1=pbuc1_derefidx_vbum2 
    lda bram_heap_segment+$1b,y
    sta bram_heap_list_insert_at.at
    // [483] callexecute bram_heap_list_insert_at  -- call_vprc1 
    jsr bram_heap_list_insert_at
    // [484] bram_heap_idle_insert::$0 = bram_heap_list_insert_at::return
    // bram_heap_segment.idle_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.idle_list[s], idle_index, bram_heap_segment.idle_list[s])
    // [485] ((char *)&bram_heap_segment+$1b)[bram_heap_idle_insert::s] = bram_heap_idle_insert::$0 -- pbuc1_derefidx_vbum1=vbum2 
    lda bram_heap_idle_insert__0
    ldy s
    sta bram_heap_segment+$1b,y
    // bram_heap_set_data_packed(s, idle_index, 0)
    // [486] bram_heap_set_data_packed::s = bram_heap_idle_insert::s -- vbum1=vbum2 
    tya
    sta bram_heap_set_data_packed.s
    // [487] bram_heap_set_data_packed::index = bram_heap_idle_insert::idle_index -- vbum1=vbum2 
    lda idle_index
    sta bram_heap_set_data_packed.index
    // [488] bram_heap_set_data_packed::data_packed = 0 -- vwum1=vbuc1 
    lda #<0
    sta bram_heap_set_data_packed.data_packed
    sta bram_heap_set_data_packed.data_packed+1
    // [489] callexecute bram_heap_set_data_packed  -- call_vprc1 
    jsr bram_heap_set_data_packed
    // bram_heap_set_size_packed(s, idle_index, 0)
    // [490] bram_heap_set_size_packed::s = bram_heap_idle_insert::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_size_packed.s
    // [491] bram_heap_set_size_packed::index = bram_heap_idle_insert::idle_index
    // [492] bram_heap_set_size_packed::size_packed = 0 -- vwum1=vbuc1 
    lda #<0
    sta bram_heap_set_size_packed.size_packed
    sta bram_heap_set_size_packed.size_packed+1
    // [493] callexecute bram_heap_set_size_packed  -- call_vprc1 
    jsr bram_heap_set_size_packed
    // bram_heap_segment.idleCount[s]++;
    // [494] bram_heap_idle_insert::$5 = bram_heap_idle_insert::s << 1 -- vbum1=vbum1_rol_1 
    asl bram_heap_idle_insert__5
    // [495] ((unsigned int *)&bram_heap_segment+$29)[bram_heap_idle_insert::$5] = ++ ((unsigned int *)&bram_heap_segment+$29)[bram_heap_idle_insert::$5] -- pwuc1_derefidx_vbum1=_inc_pwuc1_derefidx_vbum1 
    ldx bram_heap_idle_insert__5
    inc bram_heap_segment+$29,x
    bne !+
    inc bram_heap_segment+$29+1,x
  !:
    // bram_heap_idle_insert::@return
    // }
    // [496] return 
    rts
  .segment DataBramHeap
    s: .byte 0
    idle_index: .byte 0
    .label bram_heap_idle_insert__0 = bram_heap_list_insert_at.list
    .label bram_heap_idle_insert__5 = s
}
.segment CodeBramHeap
  // bram_heap_free_remove
// void bram_heap_free_remove(__mem() char s, __mem() char free_index)
bram_heap_free_remove: {
    // bram_heap_segment.freeCount[s]--;
    // [497] bram_heap_free_remove::$4 = bram_heap_free_remove::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_free_remove__4
    // [498] ((unsigned int *)&bram_heap_segment+$25)[bram_heap_free_remove::$4] = -- ((unsigned int *)&bram_heap_segment+$25)[bram_heap_free_remove::$4] -- pwuc1_derefidx_vbum1=_dec_pwuc1_derefidx_vbum1 
    tax
    lda bram_heap_segment+$25,x
    bne !+
    dec bram_heap_segment+$25+1,x
  !:
    dec bram_heap_segment+$25,x
    // bram_heap_list_remove(s, bram_heap_segment.free_list[s], free_index)
    // [499] bram_heap_list_remove::s = bram_heap_free_remove::s -- vbum1=vbum2 
    lda s
    sta bram_heap_list_remove.s
    // [500] bram_heap_list_remove::list = ((char *)&bram_heap_segment+$19)[bram_heap_free_remove::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$19,y
    sta bram_heap_list_remove.list
    // [501] bram_heap_list_remove::index = bram_heap_free_remove::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_list_remove.index
    // [502] callexecute bram_heap_list_remove  -- call_vprc1 
    jsr bram_heap_list_remove
    // [503] bram_heap_free_remove::$1 = bram_heap_list_remove::return
    // bram_heap_segment.free_list[s] = bram_heap_list_remove(s, bram_heap_segment.free_list[s], free_index)
    // [504] ((char *)&bram_heap_segment+$19)[bram_heap_free_remove::s] = bram_heap_free_remove::$1 -- pbuc1_derefidx_vbum1=vbum2 
    lda bram_heap_free_remove__1
    ldy s
    sta bram_heap_segment+$19,y
    // bram_heap_clear_free(s, free_index)
    // [505] bram_heap_clear_free::s = bram_heap_free_remove::s
    // [506] bram_heap_clear_free::index = bram_heap_free_remove::free_index
    // [507] callexecute bram_heap_clear_free  -- call_vprc1 
    jsr bram_heap_clear_free
    // bram_heap_free_remove::@return
    // }
    // [508] return 
    rts
  .segment DataBramHeap
    s: .byte 0
    .label free_index = bram_heap_get_left.index
    .label bram_heap_free_remove__1 = bram_heap_list_remove.list
    .label bram_heap_free_remove__4 = bram_heap_dump_index_print.index
}
.segment CodeBramHeap
  // bram_heap_free_insert
// char bram_heap_free_insert(__mem() char s, __mem() char free_index, __mem() unsigned int data, __mem() unsigned int size)
bram_heap_free_insert: {
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, bram_heap_segment.free_list[s])
    // [509] bram_heap_list_insert_at::s = bram_heap_free_insert::s -- vbum1=vbum2 
    lda s
    sta bram_heap_list_insert_at.s
    // [510] bram_heap_list_insert_at::list = ((char *)&bram_heap_segment+$19)[bram_heap_free_insert::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$19,y
    sta bram_heap_list_insert_at.list
    // [511] bram_heap_list_insert_at::index = bram_heap_free_insert::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_list_insert_at.index
    // [512] bram_heap_list_insert_at::at = ((char *)&bram_heap_segment+$19)[bram_heap_free_insert::s] -- vbum1=pbuc1_derefidx_vbum2 
    lda bram_heap_segment+$19,y
    sta bram_heap_list_insert_at.at
    // [513] callexecute bram_heap_list_insert_at  -- call_vprc1 
    jsr bram_heap_list_insert_at
    // [514] bram_heap_free_insert::$0 = bram_heap_list_insert_at::return
    // bram_heap_segment.free_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, bram_heap_segment.free_list[s])
    // [515] ((char *)&bram_heap_segment+$19)[bram_heap_free_insert::s] = bram_heap_free_insert::$0 -- pbuc1_derefidx_vbum1=vbum2 
    lda bram_heap_free_insert__0
    ldy s
    sta bram_heap_segment+$19,y
    // bram_heap_set_data_packed(s, free_index, data)
    // [516] bram_heap_set_data_packed::s = bram_heap_free_insert::s -- vbum1=vbum2 
    tya
    sta bram_heap_set_data_packed.s
    // [517] bram_heap_set_data_packed::index = bram_heap_free_insert::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_set_data_packed.index
    // [518] bram_heap_set_data_packed::data_packed = bram_heap_free_insert::data -- vwum1=vwum2 
    lda data
    sta bram_heap_set_data_packed.data_packed
    lda data+1
    sta bram_heap_set_data_packed.data_packed+1
    // [519] callexecute bram_heap_set_data_packed  -- call_vprc1 
    jsr bram_heap_set_data_packed
    // bram_heap_set_size_packed(s, free_index, size)
    // [520] bram_heap_set_size_packed::s = bram_heap_free_insert::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_size_packed.s
    // [521] bram_heap_set_size_packed::index = bram_heap_free_insert::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_set_size_packed.index
    // [522] bram_heap_set_size_packed::size_packed = bram_heap_free_insert::size -- vwum1=vwum2 
    lda size
    sta bram_heap_set_size_packed.size_packed
    lda size+1
    sta bram_heap_set_size_packed.size_packed+1
    // [523] callexecute bram_heap_set_size_packed  -- call_vprc1 
    jsr bram_heap_set_size_packed
    // bram_heap_set_free(s, free_index)
    // [524] bram_heap_set_free::s = bram_heap_free_insert::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_free.s
    // [525] bram_heap_set_free::index = bram_heap_free_insert::free_index
    // [526] callexecute bram_heap_set_free  -- call_vprc1 
    jsr bram_heap_set_free
    // bram_heap_segment.freeCount[s]++;
    // [527] bram_heap_free_insert::$6 = bram_heap_free_insert::s << 1 -- vbum1=vbum1_rol_1 
    asl bram_heap_free_insert__6
    // [528] ((unsigned int *)&bram_heap_segment+$25)[bram_heap_free_insert::$6] = ++ ((unsigned int *)&bram_heap_segment+$25)[bram_heap_free_insert::$6] -- pwuc1_derefidx_vbum1=_inc_pwuc1_derefidx_vbum1 
    ldx bram_heap_free_insert__6
    inc bram_heap_segment+$25,x
    bne !+
    inc bram_heap_segment+$25+1,x
  !:
    // bram_heap_free_insert::@return
    // }
    // [529] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_free_insert__6
    .label free_index = bram_heap_set_free.index
    data: .word 0
    size: .word 0
    .label bram_heap_free_insert__0 = bram_heap_list_insert_at.list
    bram_heap_free_insert__6: .byte 0
}
.segment CodeBramHeap
  // bram_heap_heap_remove
// void bram_heap_heap_remove(__mem() char s, __mem() char heap_index)
bram_heap_heap_remove: {
    // bram_heap_segment.heapCount[s]--;
    // [530] bram_heap_heap_remove::$3 = bram_heap_heap_remove::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_heap_remove__3
    // [531] ((unsigned int *)&bram_heap_segment+$21)[bram_heap_heap_remove::$3] = -- ((unsigned int *)&bram_heap_segment+$21)[bram_heap_heap_remove::$3] -- pwuc1_derefidx_vbum1=_dec_pwuc1_derefidx_vbum1 
    tax
    lda bram_heap_segment+$21,x
    bne !+
    dec bram_heap_segment+$21+1,x
  !:
    dec bram_heap_segment+$21,x
    // bram_heap_list_remove(s, bram_heap_segment.heap_list[s], heap_index)
    // [532] bram_heap_list_remove::s = bram_heap_heap_remove::s -- vbum1=vbum2 
    lda s
    sta bram_heap_list_remove.s
    // [533] bram_heap_list_remove::list = ((char *)&bram_heap_segment+$17)[bram_heap_heap_remove::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$17,y
    sta bram_heap_list_remove.list
    // [534] bram_heap_list_remove::index = bram_heap_heap_remove::heap_index
    // [535] callexecute bram_heap_list_remove  -- call_vprc1 
    jsr bram_heap_list_remove
    // [536] bram_heap_heap_remove::$1 = bram_heap_list_remove::return
    // bram_heap_segment.heap_list[s] = bram_heap_list_remove(s, bram_heap_segment.heap_list[s], heap_index)
    // [537] ((char *)&bram_heap_segment+$17)[bram_heap_heap_remove::s] = bram_heap_heap_remove::$1 -- pbuc1_derefidx_vbum1=vbum2 
    lda bram_heap_heap_remove__1
    ldy s
    sta bram_heap_segment+$17,y
    // bram_heap_heap_remove::@return
    // }
    // [538] return 
    rts
  .segment DataBramHeap
    s: .byte 0
    .label heap_index = heap_idle_remove.idle_index
    .label bram_heap_heap_remove__1 = bram_heap_list_remove.list
    .label bram_heap_heap_remove__3 = bram_heap_dump_index_print.index
}
.segment CodeBramHeap
  // bram_heap_list_insert_at
/**
* Insert index in list at sorted position.
*/
// __mem() char bram_heap_list_insert_at(__mem() char s, __mem() char list, __mem() char index, __mem() char at)
bram_heap_list_insert_at: {
    // if(list == BRAM_HEAP_NULL)
    // [539] if(bram_heap_list_insert_at::list!=$ff) goto bram_heap_list_insert_at::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp list
    bne __b1
    // bram_heap_list_insert_at::@3
    // list = index
    // [540] bram_heap_list_insert_at::list = bram_heap_list_insert_at::index -- vbum1=vbum2 
    // empty list
    lda index
    sta list
    // bram_heap_set_prev(s, index, index)
    // [541] bram_heap_set_prev::s = bram_heap_list_insert_at::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_prev.s
    // [542] bram_heap_set_prev::index = bram_heap_list_insert_at::index -- vbum1=vbum2 
    lda index
    sta bram_heap_set_prev.index
    // [543] bram_heap_set_prev::prev = bram_heap_list_insert_at::index -- vbum1=vbum2 
    lda index
    sta bram_heap_set_prev.prev
    // [544] callexecute bram_heap_set_prev  -- call_vprc1 
    jsr bram_heap_set_prev
    // bram_heap_set_next(s, index, index)
    // [545] bram_heap_set_next::s = bram_heap_list_insert_at::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_next.s
    // [546] bram_heap_set_next::index = bram_heap_list_insert_at::index -- vbum1=vbum2 
    lda index
    sta bram_heap_set_next.index
    // [547] bram_heap_set_next::next = bram_heap_list_insert_at::index -- vbum1=vbum2 
    lda index
    sta bram_heap_set_next.next
    // [548] callexecute bram_heap_set_next  -- call_vprc1 
    jsr bram_heap_set_next
    // bram_heap_list_insert_at::@1
  __b1:
    // if(at == BRAM_HEAP_NULL)
    // [549] if(bram_heap_list_insert_at::at!=$ff) goto bram_heap_list_insert_at::@2 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp at
    bne __b2
    // bram_heap_list_insert_at::@4
    // at=list
    // [550] bram_heap_list_insert_at::at = bram_heap_list_insert_at::list -- vbum1=vbum2 
    lda list
    sta at
    // bram_heap_list_insert_at::@2
  __b2:
    // bram_heap_index_t last = bram_heap_get_prev(s, at)
    // [551] bram_heap_get_prev::s = bram_heap_list_insert_at::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_prev.s
    // [552] bram_heap_get_prev::index = bram_heap_list_insert_at::at -- vbum1=vbum2 
    lda at
    sta bram_heap_get_prev.index
    // [553] callexecute bram_heap_get_prev  -- call_vprc1 
    jsr bram_heap_get_prev
    // [554] bram_heap_list_insert_at::last#0 = bram_heap_get_prev::return -- vbum1=vbum2 
    lda bram_heap_get_prev.return
    sta last
    // bram_heap_index_t first = at
    // [555] bram_heap_list_insert_at::first#0 = bram_heap_list_insert_at::at -- vbum1=vbum2 
    lda at
    sta first
    // bram_heap_set_prev(s, index, last)
    // [556] bram_heap_set_prev::s = bram_heap_list_insert_at::s -- vbum1=vbum2 
    // Add index to list at last position.
    lda s
    sta bram_heap_set_prev.s
    // [557] bram_heap_set_prev::index = bram_heap_list_insert_at::index -- vbum1=vbum2 
    lda index
    sta bram_heap_set_prev.index
    // [558] bram_heap_set_prev::prev = bram_heap_list_insert_at::last#0 -- vbum1=vbum2 
    lda last
    sta bram_heap_set_prev.prev
    // [559] callexecute bram_heap_set_prev  -- call_vprc1 
    jsr bram_heap_set_prev
    // bram_heap_set_next(s, last, index)
    // [560] bram_heap_set_next::s = bram_heap_list_insert_at::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_next.s
    // [561] bram_heap_set_next::index = bram_heap_list_insert_at::last#0
    // [562] bram_heap_set_next::next = bram_heap_list_insert_at::index -- vbum1=vbum2 
    lda index
    sta bram_heap_set_next.next
    // [563] callexecute bram_heap_set_next  -- call_vprc1 
    jsr bram_heap_set_next
    // bram_heap_set_next(s, index, first)
    // [564] bram_heap_set_next::s = bram_heap_list_insert_at::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_next.s
    // [565] bram_heap_set_next::index = bram_heap_list_insert_at::index -- vbum1=vbum2 
    lda index
    sta bram_heap_set_next.index
    // [566] bram_heap_set_next::next = bram_heap_list_insert_at::first#0 -- vbum1=vbum2 
    lda first
    sta bram_heap_set_next.next
    // [567] callexecute bram_heap_set_next  -- call_vprc1 
    jsr bram_heap_set_next
    // bram_heap_set_prev(s, first, index)
    // [568] bram_heap_set_prev::s = bram_heap_list_insert_at::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_prev.s
    // [569] bram_heap_set_prev::index = bram_heap_list_insert_at::first#0 -- vbum1=vbum2 
    lda first
    sta bram_heap_set_prev.index
    // [570] bram_heap_set_prev::prev = bram_heap_list_insert_at::index -- vbum1=vbum2 
    lda index
    sta bram_heap_set_prev.prev
    // [571] callexecute bram_heap_set_prev  -- call_vprc1 
    jsr bram_heap_set_prev
    // return list;
    // [572] bram_heap_list_insert_at::return = bram_heap_list_insert_at::list
    // bram_heap_list_insert_at::@return
    // }
    // [573] return 
    rts
  .segment DataBramHeap
    s: .byte 0
    list: .byte 0
    index: .byte 0
    .label at = bram_heap_heap_insert_at.at
    .label return = list
    .label last = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    .label first = bramheap_dy
}
.segment CodeBramHeap
  // bram_heap_set_right
/*inline*/
// void bram_heap_set_right(__mem() char s, __mem() char index, __mem() char right)
bram_heap_set_right: {
    .label bram_heap_set_right__2 = $f
    .label bram_heap_map = $f
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [574] bram_heap_set_right::$3 = (unsigned int)bram_heap_set_right::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_set_right__3
    lda #0
    sta bram_heap_set_right__3+1
    // [575] bram_heap_set_right::$1 = bram_heap_set_right::$3 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_set_right__1
    rol bram_heap_set_right__1+1
    dey
    bne !-
  !e:
    // [576] bram_heap_set_right::bram_heap_map#0 = bram_heap_index + bram_heap_set_right::$1 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_set_right__1
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_set_right__1+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->right[index] = right
    // [577] bram_heap_set_right::$2 = (char *)bram_heap_set_right::bram_heap_map#0 + $600 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_set_right__2
    clc
    adc #<$600
    sta.z bram_heap_set_right__2
    lda.z bram_heap_set_right__2+1
    adc #>$600
    sta.z bram_heap_set_right__2+1
    // [578] bram_heap_set_right::$2[bram_heap_set_right::index] = bram_heap_set_right::right -- pbuz1_derefidx_vbum2=vbum3 
    lda right
    ldy index
    sta (bram_heap_set_right__2),y
    // bram_heap_set_right::@return
    // }
    // [579] return 
    rts
  .segment DataBramHeap
    s: .byte 0
    .label index = bram_heap_dump_index_print.index
    right: .byte 0
    .label bram_heap_set_right__1 = bram_heap_dump_index_print.count
    .label bram_heap_set_right__3 = bram_heap_dump_index_print.count
}
.segment CodeBramHeap
  // bram_heap_get_right
/*inline*/
// __mem() char bram_heap_get_right(__mem() char s, __mem() char index)
bram_heap_get_right: {
    .label bram_heap_get_right__2 = $b
    .label bram_heap_map = $b
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [580] bram_heap_get_right::$3 = (unsigned int)bram_heap_get_right::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_get_right__3
    lda #0
    sta bram_heap_get_right__3+1
    // [581] bram_heap_get_right::$1 = bram_heap_get_right::$3 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_get_right__1
    rol bram_heap_get_right__1+1
    dey
    bne !-
  !e:
    // [582] bram_heap_get_right::bram_heap_map#0 = bram_heap_index + bram_heap_get_right::$1 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_get_right__1
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_get_right__1+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // return bram_heap_map->right[index];
    // [583] bram_heap_get_right::$2 = (char *)bram_heap_get_right::bram_heap_map#0 + $600 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_get_right__2
    clc
    adc #<$600
    sta.z bram_heap_get_right__2
    lda.z bram_heap_get_right__2+1
    adc #>$600
    sta.z bram_heap_get_right__2+1
    // [584] bram_heap_get_right::return = bram_heap_get_right::$2[bram_heap_get_right::index] -- vbum1=pbuz2_derefidx_vbum1 
    ldy return
    lda (bram_heap_get_right__2),y
    sta return
    // bram_heap_get_right::@return
    // }
    // [585] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    index: .byte 0
    .label return = index
    .label bram_heap_get_right__1 = bram_heap_find_best_fit.best_size_1
    .label bram_heap_get_right__3 = bram_heap_find_best_fit.best_size_1
}
.segment CodeBramHeap
  // bram_heap_set_left
/*inline*/
// void bram_heap_set_left(__mem() char s, __mem() char index, __mem() char left)
bram_heap_set_left: {
    .label bram_heap_set_left__2 = $b
    .label bram_heap_map = $b
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [586] bram_heap_set_left::$3 = (unsigned int)bram_heap_set_left::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_set_left__3
    lda #0
    sta bram_heap_set_left__3+1
    // [587] bram_heap_set_left::$1 = bram_heap_set_left::$3 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_set_left__1
    rol bram_heap_set_left__1+1
    dey
    bne !-
  !e:
    // [588] bram_heap_set_left::bram_heap_map#0 = bram_heap_index + bram_heap_set_left::$1 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_set_left__1
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_set_left__1+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->left[index] = left
    // [589] bram_heap_set_left::$2 = (char *)bram_heap_set_left::bram_heap_map#0 + $700 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_set_left__2
    clc
    adc #<$700
    sta.z bram_heap_set_left__2
    lda.z bram_heap_set_left__2+1
    adc #>$700
    sta.z bram_heap_set_left__2+1
    // [590] bram_heap_set_left::$2[bram_heap_set_left::index] = bram_heap_set_left::left -- pbuz1_derefidx_vbum2=vbum3 
    lda left
    ldy index
    sta (bram_heap_set_left__2),y
    // bram_heap_set_left::@return
    // }
    // [591] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.index
    .label index = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    left: .byte 0
    .label bram_heap_set_left__1 = bram_heap_dump_index_print.count
    .label bram_heap_set_left__3 = bram_heap_dump_index_print.count
}
.segment CodeBramHeap
  // bram_heap_get_left
/*inline*/
// __mem() char bram_heap_get_left(__mem() char s, __mem() char index)
bram_heap_get_left: {
    .label bram_heap_get_left__2 = $b
    .label bram_heap_map = $b
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [592] bram_heap_get_left::$3 = (unsigned int)bram_heap_get_left::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_get_left__3
    lda #0
    sta bram_heap_get_left__3+1
    // [593] bram_heap_get_left::$1 = bram_heap_get_left::$3 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_get_left__1
    rol bram_heap_get_left__1+1
    dey
    bne !-
  !e:
    // [594] bram_heap_get_left::bram_heap_map#0 = bram_heap_index + bram_heap_get_left::$1 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_get_left__1
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_get_left__1+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // return bram_heap_map->left[index];
    // [595] bram_heap_get_left::$2 = (char *)bram_heap_get_left::bram_heap_map#0 + $700 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_get_left__2
    clc
    adc #<$700
    sta.z bram_heap_get_left__2
    lda.z bram_heap_get_left__2+1
    adc #>$700
    sta.z bram_heap_get_left__2+1
    // [596] bram_heap_get_left::return = bram_heap_get_left::$2[bram_heap_get_left::index] -- vbum1=pbuz2_derefidx_vbum1 
    ldy return
    lda (bram_heap_get_left__2),y
    sta return
    // bram_heap_get_left::@return
    // }
    // [597] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_index_add.index
    index: .byte 0
    .label return = index
    .label bram_heap_get_left__1 = bram_heap_find_best_fit.best_size_1
    .label bram_heap_get_left__3 = bram_heap_find_best_fit.best_size_1
}
.segment CodeBramHeap
  // bram_heap_set_prev
/*inline*/
// void bram_heap_set_prev(__mem() char s, __mem() char index, __mem() char prev)
bram_heap_set_prev: {
    .label bram_heap_set_prev__2 = $b
    .label bram_heap_map = $b
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [598] bram_heap_set_prev::$3 = (unsigned int)bram_heap_set_prev::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_set_prev__3
    lda #0
    sta bram_heap_set_prev__3+1
    // [599] bram_heap_set_prev::$1 = bram_heap_set_prev::$3 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_set_prev__1
    rol bram_heap_set_prev__1+1
    dey
    bne !-
  !e:
    // [600] bram_heap_set_prev::bram_heap_map#0 = bram_heap_index + bram_heap_set_prev::$1 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_set_prev__1
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_set_prev__1+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->prev[index] = prev
    // [601] bram_heap_set_prev::$2 = (char *)bram_heap_set_prev::bram_heap_map#0 + $500 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_set_prev__2
    clc
    adc #<$500
    sta.z bram_heap_set_prev__2
    lda.z bram_heap_set_prev__2+1
    adc #>$500
    sta.z bram_heap_set_prev__2+1
    // [602] bram_heap_set_prev::$2[bram_heap_set_prev::index] = bram_heap_set_prev::prev -- pbuz1_derefidx_vbum2=vbum3 
    lda prev
    ldy index
    sta (bram_heap_set_prev__2),y
    // bram_heap_set_prev::@return
    // }
    // [603] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.index
    index: .byte 0
    .label prev = lib_bramheap.bram_heap_get_size.index
    .label bram_heap_set_prev__1 = bram_heap_dump_index_print.count
    .label bram_heap_set_prev__3 = bram_heap_dump_index_print.count
}
.segment CodeBramHeap
  // bram_heap_get_prev
/*inline*/
// __mem() char bram_heap_get_prev(__mem() char s, __mem() char index)
bram_heap_get_prev: {
    .label bram_heap_get_prev__2 = $b
    .label bram_heap_map = $b
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [604] bram_heap_get_prev::$3 = (unsigned int)bram_heap_get_prev::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_get_prev__3
    lda #0
    sta bram_heap_get_prev__3+1
    // [605] bram_heap_get_prev::$1 = bram_heap_get_prev::$3 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_get_prev__1
    rol bram_heap_get_prev__1+1
    dey
    bne !-
  !e:
    // [606] bram_heap_get_prev::bram_heap_map#0 = bram_heap_index + bram_heap_get_prev::$1 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_get_prev__1
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_get_prev__1+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // return bram_heap_map->prev[index];
    // [607] bram_heap_get_prev::$2 = (char *)bram_heap_get_prev::bram_heap_map#0 + $500 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_get_prev__2
    clc
    adc #<$500
    sta.z bram_heap_get_prev__2
    lda.z bram_heap_get_prev__2+1
    adc #>$500
    sta.z bram_heap_get_prev__2+1
    // [608] bram_heap_get_prev::return = bram_heap_get_prev::$2[bram_heap_get_prev::index] -- vbum1=pbuz2_derefidx_vbum1 
    ldy return
    lda (bram_heap_get_prev__2),y
    sta return
    // bram_heap_get_prev::@return
    // }
    // [609] return 
    rts
  .segment DataBramHeap
    .label s = lib_bramheap.bram_heap_get_size.s
    .label index = lib_bramheap.bram_heap_get_size.index
    .label return = lib_bramheap.bram_heap_get_size.index
    .label bram_heap_get_prev__1 = bram_heap_can_coalesce_left.heap_offset
    .label bram_heap_get_prev__3 = bram_heap_can_coalesce_left.heap_offset
}
.segment CodeBramHeap
  // bram_heap_set_next
/*inline*/
// void bram_heap_set_next(__mem() char s, __mem() char index, __mem() char next)
bram_heap_set_next: {
    .label bram_heap_set_next__2 = $b
    .label bram_heap_map = $b
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [610] bram_heap_set_next::$3 = (unsigned int)bram_heap_set_next::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_set_next__3
    lda #0
    sta bram_heap_set_next__3+1
    // [611] bram_heap_set_next::$1 = bram_heap_set_next::$3 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_set_next__1
    rol bram_heap_set_next__1+1
    dey
    bne !-
  !e:
    // [612] bram_heap_set_next::bram_heap_map#0 = bram_heap_index + bram_heap_set_next::$1 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_set_next__1
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_set_next__1+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->next[index] = next
    // [613] bram_heap_set_next::$2 = (char *)bram_heap_set_next::bram_heap_map#0 + $400 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_set_next__2
    clc
    adc #<$400
    sta.z bram_heap_set_next__2
    lda.z bram_heap_set_next__2+1
    adc #>$400
    sta.z bram_heap_set_next__2+1
    // [614] bram_heap_set_next::$2[bram_heap_set_next::index] = bram_heap_set_next::next -- pbuz1_derefidx_vbum2=vbum3 
    lda next
    ldy index
    sta (bram_heap_set_next__2),y
    // bram_heap_set_next::@return
    // }
    // [615] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.index
    .label index = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    .label next = bramheap_dx
    .label bram_heap_set_next__1 = bram_heap_dump_index_print.count
    .label bram_heap_set_next__3 = bram_heap_dump_index_print.count
}
.segment CodeBramHeap
  // bram_heap_get_next
/*inline*/
// __mem() char bram_heap_get_next(__mem() char s, __mem() char index)
bram_heap_get_next: {
    .label bram_heap_get_next__2 = $b
    .label bram_heap_map = $b
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [616] bram_heap_get_next::$3 = (unsigned int)bram_heap_get_next::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_get_next__3
    lda #0
    sta bram_heap_get_next__3+1
    // [617] bram_heap_get_next::$1 = bram_heap_get_next::$3 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_get_next__1
    rol bram_heap_get_next__1+1
    dey
    bne !-
  !e:
    // [618] bram_heap_get_next::bram_heap_map#0 = bram_heap_index + bram_heap_get_next::$1 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_get_next__1
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_get_next__1+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // return bram_heap_map->next[index];
    // [619] bram_heap_get_next::$2 = (char *)bram_heap_get_next::bram_heap_map#0 + $400 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_get_next__2
    clc
    adc #<$400
    sta.z bram_heap_get_next__2
    lda.z bram_heap_get_next__2+1
    adc #>$400
    sta.z bram_heap_get_next__2+1
    // [620] bram_heap_get_next::return = bram_heap_get_next::$2[bram_heap_get_next::index] -- vbum1=pbuz2_derefidx_vbum1 
    ldy return
    lda (bram_heap_get_next__2),y
    sta return
    // bram_heap_get_next::@return
    // }
    // [621] return 
    rts
  .segment DataBramHeap
    .label s = lib_bramheap.bram_heap_get_size.s
    .label index = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    .label return = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    .label bram_heap_get_next__1 = bram_heap_can_coalesce_left.heap_offset
    .label bram_heap_get_next__3 = bram_heap_can_coalesce_left.heap_offset
}
.segment CodeBramHeap
  // bram_heap_set_size_packed
// void bram_heap_set_size_packed(__mem() char s, __mem() char index, __mem() unsigned int size_packed)
bram_heap_set_size_packed: {
    .label bram_heap_set_size_packed__5 = $f
    .label bram_heap_set_size_packed__6 = $b
    .label bram_heap_map = $b
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [622] bram_heap_set_size_packed::$7 = (unsigned int)bram_heap_set_size_packed::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_set_size_packed__7
    lda #0
    sta bram_heap_set_size_packed__7+1
    // [623] bram_heap_set_size_packed::$4 = bram_heap_set_size_packed::$7 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_set_size_packed__4
    rol bram_heap_set_size_packed__4+1
    dey
    bne !-
  !e:
    // [624] bram_heap_set_size_packed::bram_heap_map#0 = bram_heap_index + bram_heap_set_size_packed::$4 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_set_size_packed__4
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_set_size_packed__4+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // BYTE1(size_packed)
    // [625] bram_heap_set_size_packed::$1 = byte1  bram_heap_set_size_packed::size_packed -- vbum1=_byte1_vwum2 
    lda size_packed+1
    sta bram_heap_set_size_packed__1
    // BYTE1(size_packed) & 0x7F
    // [626] bram_heap_set_size_packed::$2 = bram_heap_set_size_packed::$1 & $7f -- vbum1=vbum1_band_vbuc1 
    lda #$7f
    and bram_heap_set_size_packed__2
    sta bram_heap_set_size_packed__2
    // bram_heap_map->size1[index] = BYTE1(size_packed) & 0x7F
    // [627] bram_heap_set_size_packed::$5 = (char *)bram_heap_set_size_packed::bram_heap_map#0 + $300 -- pbuz1=pbuz2_plus_vwuc1 
    // bram_heap_map->size1[index] &= bram_heap_map->size1[index] & 0x80;
    lda.z bram_heap_map
    clc
    adc #<$300
    sta.z bram_heap_set_size_packed__5
    lda.z bram_heap_map+1
    adc #>$300
    sta.z bram_heap_set_size_packed__5+1
    // [628] bram_heap_set_size_packed::$5[bram_heap_set_size_packed::index] = bram_heap_set_size_packed::$2 -- pbuz1_derefidx_vbum2=vbum3 
    // bram_heap_map->size1[index] &= bram_heap_map->size1[index] & 0x80;
    lda bram_heap_set_size_packed__2
    ldy index
    sta (bram_heap_set_size_packed__5),y
    // BYTE0(size_packed)
    // [629] bram_heap_set_size_packed::$3 = byte0  bram_heap_set_size_packed::size_packed -- vbum1=_byte0_vwum2 
    lda size_packed
    sta bram_heap_set_size_packed__3
    // bram_heap_map->size0[index] = BYTE0(size_packed)
    // [630] bram_heap_set_size_packed::$6 = (char *)bram_heap_set_size_packed::bram_heap_map#0 + $200 -- pbuz1=pbuz1_plus_vwuc1 
    // Ignore free flag.
    lda.z bram_heap_set_size_packed__6
    clc
    adc #<$200
    sta.z bram_heap_set_size_packed__6
    lda.z bram_heap_set_size_packed__6+1
    adc #>$200
    sta.z bram_heap_set_size_packed__6+1
    // [631] bram_heap_set_size_packed::$6[bram_heap_set_size_packed::index] = bram_heap_set_size_packed::$3 -- pbuz1_derefidx_vbum2=vbum3 
    // Ignore free flag.
    lda bram_heap_set_size_packed__3
    sta (bram_heap_set_size_packed__6),y
    // bram_heap_set_size_packed::@return
    // }
    // [632] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.index
    .label index = bram_heap_idle_insert.idle_index
    .label size_packed = bram_heap_find_best_fit.best_size_1
    .label bram_heap_set_size_packed__1 = bram_heap_dump_index_print.index
    .label bram_heap_set_size_packed__2 = bram_heap_dump_index_print.index
    .label bram_heap_set_size_packed__3 = bram_heap_dump_index_print.index
    .label bram_heap_set_size_packed__4 = bram_heap_dump_index_print.count
    .label bram_heap_set_size_packed__7 = bram_heap_dump_index_print.count
}
.segment CodeBramHeap
  // bram_heap_size_unpack
// __mem() unsigned long bram_heap_size_unpack(__mem() unsigned int size)
bram_heap_size_unpack: {
    // (bram_heap_size_t)size << 5
    // [633] bram_heap_size_unpack::$1 = (unsigned long)bram_heap_size_unpack::size -- vdum1=_dword_vwum2 
    lda size
    sta bram_heap_size_unpack__1
    lda size+1
    sta bram_heap_size_unpack__1+1
    lda #0
    sta bram_heap_size_unpack__1+2
    sta bram_heap_size_unpack__1+3
    // [634] bram_heap_size_unpack::$0 = bram_heap_size_unpack::$1 << 5 -- vdum1=vdum1_rol_5 
    asl bram_heap_size_unpack__0
    rol bram_heap_size_unpack__0+1
    rol bram_heap_size_unpack__0+2
    rol bram_heap_size_unpack__0+3
    asl bram_heap_size_unpack__0
    rol bram_heap_size_unpack__0+1
    rol bram_heap_size_unpack__0+2
    rol bram_heap_size_unpack__0+3
    asl bram_heap_size_unpack__0
    rol bram_heap_size_unpack__0+1
    rol bram_heap_size_unpack__0+2
    rol bram_heap_size_unpack__0+3
    asl bram_heap_size_unpack__0
    rol bram_heap_size_unpack__0+1
    rol bram_heap_size_unpack__0+2
    rol bram_heap_size_unpack__0+3
    asl bram_heap_size_unpack__0
    rol bram_heap_size_unpack__0+1
    rol bram_heap_size_unpack__0+2
    rol bram_heap_size_unpack__0+3
    // return (bram_heap_size_t)size << 5;
    // [635] bram_heap_size_unpack::return = bram_heap_size_unpack::$0
    // bram_heap_size_unpack::@return
    // }
    // [636] return 
    rts
  .segment DataBramHeap
    .label size = bram_heap_dump_index_print.count
    .label return = bram_heap_size_unpack__1
    .label bram_heap_size_unpack__0 = bram_heap_size_unpack__1
    bram_heap_size_unpack__1: .dword 0
}
.segment CodeBramHeap
  // bram_heap_size_pack
// __mem() unsigned int bram_heap_size_pack(__mem() unsigned long size)
bram_heap_size_pack: {
    // size >> 5
    // [637] bram_heap_size_pack::$0 = bram_heap_size_pack::size >> 5 -- vdum1=vdum1_ror_5 
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
    lsr bram_heap_size_pack__0+3
    ror bram_heap_size_pack__0+2
    ror bram_heap_size_pack__0+1
    ror bram_heap_size_pack__0
    // return (bram_heap_size_packed_t)(size >> 5);
    // [638] bram_heap_size_pack::return = (unsigned int)bram_heap_size_pack::$0 -- vwum1=_word_vdum2 
    lda bram_heap_size_pack__0
    sta return
    lda bram_heap_size_pack__0+1
    sta return+1
    // bram_heap_size_pack::@return
    // }
    // [639] return 
    rts
  .segment DataBramHeap
    .label size = bram_heap_dump_index_print.bram_heap_dump_index_print__10
    .label return = bram_heap_alloc_size_get.bram_heap_alloc_size_get__1
    .label bram_heap_size_pack__0 = bram_heap_dump_index_print.bram_heap_dump_index_print__10
}
.segment CodeBramHeap
  // bram_heap_clear_free
// void bram_heap_clear_free(__mem() char s, __mem() char index)
bram_heap_clear_free: {
    .label bram_heap_clear_free__2 = $d
    .label bram_heap_clear_free__3 = $f
    .label bram_heap_map = $f
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [640] bram_heap_clear_free::$4 = (unsigned int)bram_heap_clear_free::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_clear_free__4
    lda #0
    sta bram_heap_clear_free__4+1
    // [641] bram_heap_clear_free::$1 = bram_heap_clear_free::$4 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_clear_free__1
    rol bram_heap_clear_free__1+1
    dey
    bne !-
  !e:
    // [642] bram_heap_clear_free::bram_heap_map#0 = bram_heap_index + bram_heap_clear_free::$1 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_clear_free__1
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_clear_free__1+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->size1[index] &= 0x7F
    // [643] bram_heap_clear_free::$2 = (char *)bram_heap_clear_free::bram_heap_map#0 + $300 -- pbuz1=pbuz2_plus_vwuc1 
    lda.z bram_heap_map
    clc
    adc #<$300
    sta.z bram_heap_clear_free__2
    lda.z bram_heap_map+1
    adc #>$300
    sta.z bram_heap_clear_free__2+1
    // [644] bram_heap_clear_free::$3 = (char *)bram_heap_clear_free::bram_heap_map#0 + $300 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_clear_free__3
    clc
    adc #<$300
    sta.z bram_heap_clear_free__3
    lda.z bram_heap_clear_free__3+1
    adc #>$300
    sta.z bram_heap_clear_free__3+1
    // [645] bram_heap_clear_free::$3[bram_heap_clear_free::index] = bram_heap_clear_free::$2[bram_heap_clear_free::index] & $7f -- pbuz1_derefidx_vbum2=pbuz3_derefidx_vbum2_band_vbuc1 
    lda #$7f
    ldy index
    and (bram_heap_clear_free__2),y
    sta (bram_heap_clear_free__3),y
    // bram_heap_clear_free::@return
    // }
    // [646] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_free_remove.s
    .label index = bram_heap_get_left.index
    .label bram_heap_clear_free__1 = bram_heap_dump_index_print.count
    .label bram_heap_clear_free__4 = bram_heap_dump_index_print.count
}
.segment CodeBramHeap
  // bram_heap_set_free
// void bram_heap_set_free(__mem() char s, __mem() char index)
bram_heap_set_free: {
    .label bram_heap_set_free__2 = $b
    .label bram_heap_set_free__3 = $d
    .label bram_heap_map = $d
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [647] bram_heap_set_free::$4 = (unsigned int)bram_heap_set_free::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_set_free__4
    lda #0
    sta bram_heap_set_free__4+1
    // [648] bram_heap_set_free::$1 = bram_heap_set_free::$4 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_set_free__1
    rol bram_heap_set_free__1+1
    dey
    bne !-
  !e:
    // [649] bram_heap_set_free::bram_heap_map#0 = bram_heap_index + bram_heap_set_free::$1 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_set_free__1
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_set_free__1+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->size1[index] |= 0x80
    // [650] bram_heap_set_free::$2 = (char *)bram_heap_set_free::bram_heap_map#0 + $300 -- pbuz1=pbuz2_plus_vwuc1 
    lda.z bram_heap_map
    clc
    adc #<$300
    sta.z bram_heap_set_free__2
    lda.z bram_heap_map+1
    adc #>$300
    sta.z bram_heap_set_free__2+1
    // [651] bram_heap_set_free::$3 = (char *)bram_heap_set_free::bram_heap_map#0 + $300 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_set_free__3
    clc
    adc #<$300
    sta.z bram_heap_set_free__3
    lda.z bram_heap_set_free__3+1
    adc #>$300
    sta.z bram_heap_set_free__3+1
    // [652] bram_heap_set_free::$3[bram_heap_set_free::index] = bram_heap_set_free::$2[bram_heap_set_free::index] | $80 -- pbuz1_derefidx_vbum2=pbuz3_derefidx_vbum2_bor_vbuc1 
    lda #$80
    ldy index
    ora (bram_heap_set_free__2),y
    sta (bram_heap_set_free__3),y
    // bram_heap_set_free::@return
    // }
    // [653] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.index
    index: .byte 0
    .label bram_heap_set_free__1 = bram_heap_dump_index_print.count
    .label bram_heap_set_free__4 = bram_heap_dump_index_print.count
}
.segment CodeBramHeap
  // bram_heap_set_data_packed
// void bram_heap_set_data_packed(__mem() char s, __mem() char index, __mem() unsigned int data_packed)
bram_heap_set_data_packed: {
    .label bram_heap_set_data_packed__4 = $d
    .label bram_heap_map = $b
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [654] bram_heap_set_data_packed::$6 = (unsigned int)bram_heap_set_data_packed::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_set_data_packed__6
    lda #0
    sta bram_heap_set_data_packed__6+1
    // [655] bram_heap_set_data_packed::$3 = bram_heap_set_data_packed::$6 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_set_data_packed__3
    rol bram_heap_set_data_packed__3+1
    dey
    bne !-
  !e:
    // [656] bram_heap_set_data_packed::bram_heap_map#0 = bram_heap_index + bram_heap_set_data_packed::$3 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_set_data_packed__3
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_set_data_packed__3+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // BYTE1(data_packed)
    // [657] bram_heap_set_data_packed::$1 = byte1  bram_heap_set_data_packed::data_packed -- vbum1=_byte1_vwum2 
    lda data_packed+1
    sta bram_heap_set_data_packed__1
    // bram_heap_map->data1[index] = BYTE1(data_packed)
    // [658] bram_heap_set_data_packed::$4 = (char *)bram_heap_set_data_packed::bram_heap_map#0 + $100 -- pbuz1=pbuz2_plus_vwuc1 
    lda.z bram_heap_map
    clc
    adc #<$100
    sta.z bram_heap_set_data_packed__4
    lda.z bram_heap_map+1
    adc #>$100
    sta.z bram_heap_set_data_packed__4+1
    // [659] bram_heap_set_data_packed::$4[bram_heap_set_data_packed::index] = bram_heap_set_data_packed::$1 -- pbuz1_derefidx_vbum2=vbum3 
    lda bram_heap_set_data_packed__1
    ldy index
    sta (bram_heap_set_data_packed__4),y
    // BYTE0(data_packed)
    // [660] bram_heap_set_data_packed::$2 = byte0  bram_heap_set_data_packed::data_packed -- vbum1=_byte0_vwum2 
    lda data_packed
    sta bram_heap_set_data_packed__2
    // bram_heap_map->data0[index] = BYTE0(data_packed)
    // [661] ((char *)bram_heap_set_data_packed::bram_heap_map#0)[bram_heap_set_data_packed::index] = bram_heap_set_data_packed::$2 -- pbuz1_derefidx_vbum2=vbum3 
    sta (bram_heap_map),y
    // bram_heap_set_data_packed::@return
    // }
    // [662] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.index
    .label index = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    data_packed: .word 0
    .label bram_heap_set_data_packed__1 = bram_heap_dump_index_print.index
    .label bram_heap_set_data_packed__2 = bram_heap_dump_index_print.index
    .label bram_heap_set_data_packed__3 = bram_heap_dump_index_print.count
    .label bram_heap_set_data_packed__6 = bram_heap_dump_index_print.count
}
.segment CodeBramHeap
  // bram_heap_data_pack
// __mem() unsigned int bram_heap_data_pack(__mem() char bram_bank, __zp($d) char *bram_ptr)
bram_heap_data_pack: {
    .label bram_ptr = $d
    // MAKEWORD(bram_bank, 0)
    // [663] bram_heap_data_pack::$0 = bram_heap_data_pack::bram_bank w= 0 -- vwum1=vbum2_word_vbuc1 
    lda #0
    ldy bram_bank
    sty bram_heap_data_pack__0+1
    sta bram_heap_data_pack__0
    // (unsigned int)bram_ptr & 0x1FFF
    // [664] bram_heap_data_pack::$1 = (unsigned int)bram_heap_data_pack::bram_ptr & $1fff -- vwum1=vwuz2_band_vwuc1 
    lda.z bram_ptr
    and #<$1fff
    sta bram_heap_data_pack__1
    lda.z bram_ptr+1
    and #>$1fff
    sta bram_heap_data_pack__1+1
    // ((unsigned int)bram_ptr & 0x1FFF ) >> 5
    // [665] bram_heap_data_pack::$2 = bram_heap_data_pack::$1 >> 5 -- vwum1=vwum1_ror_5 
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
    // [666] bram_heap_data_pack::$3 = bram_heap_data_pack::$0 | bram_heap_data_pack::$2 -- vwum1=vwum1_bor_vwum2 
    lda bram_heap_data_pack__3
    ora bram_heap_data_pack__2
    sta bram_heap_data_pack__3
    lda bram_heap_data_pack__3+1
    ora bram_heap_data_pack__2+1
    sta bram_heap_data_pack__3+1
    // return MAKEWORD(bram_bank, 0) | (((unsigned int)bram_ptr & 0x1FFF ) >> 5);
    // [667] bram_heap_data_pack::return = bram_heap_data_pack::$3
    // bram_heap_data_pack::@return
    // }
    // [668] return 
    rts
  .segment DataBramHeap
    .label bram_bank = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    .label return = bram_heap_dump_index_print.count
    .label bram_heap_data_pack__0 = bram_heap_dump_index_print.count
    .label bram_heap_data_pack__1 = bram_heap_find_best_fit.best_size
    .label bram_heap_data_pack__2 = bram_heap_find_best_fit.best_size
    .label bram_heap_data_pack__3 = bram_heap_dump_index_print.count
}
.segment CodeBramHeap
  // bram_heap_heap_insert_at
// char bram_heap_heap_insert_at(__mem() char s, __mem() char heap_index, __mem() char at, __mem() unsigned int size)
bram_heap_heap_insert_at: {
    // bram_heap_list_insert_at(s, bram_heap_segment.heap_list[s], heap_index, at)
    // [669] bram_heap_list_insert_at::s = bram_heap_heap_insert_at::s -- vbum1=vbum2 
    lda s
    sta bram_heap_list_insert_at.s
    // [670] bram_heap_list_insert_at::list = ((char *)&bram_heap_segment+$17)[bram_heap_heap_insert_at::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$17,y
    sta bram_heap_list_insert_at.list
    // [671] bram_heap_list_insert_at::index = bram_heap_heap_insert_at::heap_index -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_list_insert_at.index
    // [672] bram_heap_list_insert_at::at = bram_heap_heap_insert_at::at
    // [673] callexecute bram_heap_list_insert_at  -- call_vprc1 
    jsr bram_heap_list_insert_at
    // [674] bram_heap_heap_insert_at::$0 = bram_heap_list_insert_at::return
    // bram_heap_segment.heap_list[s] = bram_heap_list_insert_at(s, bram_heap_segment.heap_list[s], heap_index, at)
    // [675] ((char *)&bram_heap_segment+$17)[bram_heap_heap_insert_at::s] = bram_heap_heap_insert_at::$0 -- pbuc1_derefidx_vbum1=vbum2 
    lda bram_heap_heap_insert_at__0
    ldy s
    sta bram_heap_segment+$17,y
    // bram_heap_set_size_packed(s, heap_index, size)
    // [676] bram_heap_set_size_packed::s = bram_heap_heap_insert_at::s -- vbum1=vbum2 
    tya
    sta bram_heap_set_size_packed.s
    // [677] bram_heap_set_size_packed::index = bram_heap_heap_insert_at::heap_index -- vbum1=vbum2 
    lda heap_index
    sta bram_heap_set_size_packed.index
    // [678] bram_heap_set_size_packed::size_packed = bram_heap_heap_insert_at::size
    // [679] callexecute bram_heap_set_size_packed  -- call_vprc1 
    jsr bram_heap_set_size_packed
    // bram_heap_segment.heapCount[s]++;
    // [680] bram_heap_heap_insert_at::$4 = bram_heap_heap_insert_at::s << 1 -- vbum1=vbum1_rol_1 
    asl bram_heap_heap_insert_at__4
    // [681] ((unsigned int *)&bram_heap_segment+$21)[bram_heap_heap_insert_at::$4] = ++ ((unsigned int *)&bram_heap_segment+$21)[bram_heap_heap_insert_at::$4] -- pwuc1_derefidx_vbum1=_inc_pwuc1_derefidx_vbum1 
    ldx bram_heap_heap_insert_at__4
    inc bram_heap_segment+$21,x
    bne !+
    inc bram_heap_segment+$21+1,x
  !:
    // bram_heap_heap_insert_at::@return
    // }
    // [682] return 
    rts
  .segment DataBramHeap
    s: .byte 0
    heap_index: .byte 0
    at: .byte 0
    .label size = bram_heap_find_best_fit.best_size_1
    .label bram_heap_heap_insert_at__0 = bram_heap_list_insert_at.list
    .label bram_heap_heap_insert_at__4 = s
}
.segment CodeBramHeap
  // bram_heap_list_remove
/**
* Remove header from List
*/
// __mem() char bram_heap_list_remove(__mem() char s, __mem() char list, __mem() char index)
bram_heap_list_remove: {
    // if(list == BRAM_HEAP_NULL)
    // [683] if(bram_heap_list_remove::list!=$ff) goto bram_heap_list_remove::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp list
    bne __b1
    // bram_heap_list_remove::@4
    // return BRAM_HEAP_NULL;
    // [684] bram_heap_list_remove::return = $ff -- vbum1=vbuc1 
    // empty list
    sta return
    // bram_heap_list_remove::@return
  __breturn:
    // }
    // [685] return 
    rts
    // bram_heap_list_remove::@1
  __b1:
    // bram_heap_get_next(s, list)
    // [686] bram_heap_get_next::s = bram_heap_list_remove::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_next.s
    // [687] bram_heap_get_next::index = bram_heap_list_remove::list -- vbum1=vbum2 
    lda list
    sta bram_heap_get_next.index
    // [688] callexecute bram_heap_get_next  -- call_vprc1 
    jsr bram_heap_get_next
    // [689] bram_heap_list_remove::$2 = bram_heap_get_next::return
    // if(list == bram_heap_get_next(s, list))
    // [690] if(bram_heap_list_remove::list!=bram_heap_list_remove::$2) goto bram_heap_list_remove::@2 -- vbum1_neq_vbum2_then_la1 
    lda list
    cmp bram_heap_list_remove__2
    bne __b2
    // bram_heap_list_remove::@5
    // list = 0
    // [691] bram_heap_list_remove::list = 0 -- vbum1=vbuc1 
    lda #0
    sta list
    // bram_heap_set_next(s, index, BRAM_HEAP_NULL)
    // [692] bram_heap_set_next::s = bram_heap_list_remove::s -- vbum1=vbum2 
    // We initialize the start of the list to null.
    lda s
    sta bram_heap_set_next.s
    // [693] bram_heap_set_next::index = bram_heap_list_remove::index -- vbum1=vbum2 
    lda index
    sta bram_heap_set_next.index
    // [694] bram_heap_set_next::next = $ff -- vbum1=vbuc1 
    lda #$ff
    sta bram_heap_set_next.next
    // [695] callexecute bram_heap_set_next  -- call_vprc1 
    jsr bram_heap_set_next
    // bram_heap_set_prev(s, index, BRAM_HEAP_NULL)
    // [696] bram_heap_set_prev::s = bram_heap_list_remove::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_prev.s
    // [697] bram_heap_set_prev::index = bram_heap_list_remove::index -- vbum1=vbum2 
    lda index
    sta bram_heap_set_prev.index
    // [698] bram_heap_set_prev::prev = $ff -- vbum1=vbuc1 
    lda #$ff
    sta bram_heap_set_prev.prev
    // [699] callexecute bram_heap_set_prev  -- call_vprc1 
    jsr bram_heap_set_prev
    // return BRAM_HEAP_NULL;
    // [700] bram_heap_list_remove::return = $ff -- vbum1=vbuc1 
    lda #$ff
    sta return
    rts
    // bram_heap_list_remove::@2
  __b2:
    // bram_heap_index_t next = bram_heap_get_next(s, index)
    // [701] bram_heap_get_next::s = bram_heap_list_remove::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_next.s
    // [702] bram_heap_get_next::index = bram_heap_list_remove::index -- vbum1=vbum2 
    lda index
    sta bram_heap_get_next.index
    // [703] callexecute bram_heap_get_next  -- call_vprc1 
    jsr bram_heap_get_next
    // [704] bram_heap_list_remove::next#0 = bram_heap_get_next::return -- vbum1=vbum2 
    lda bram_heap_get_next.return
    sta next
    // bram_heap_index_t prev = bram_heap_get_prev(s, index)
    // [705] bram_heap_get_prev::s = bram_heap_list_remove::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_prev.s
    // [706] bram_heap_get_prev::index = bram_heap_list_remove::index -- vbum1=vbum2 
    lda index
    sta bram_heap_get_prev.index
    // [707] callexecute bram_heap_get_prev  -- call_vprc1 
    jsr bram_heap_get_prev
    // [708] bram_heap_list_remove::prev#0 = bram_heap_get_prev::return
    // bram_heap_set_next(s, prev, next)
    // [709] bram_heap_set_next::s = bram_heap_list_remove::s -- vbum1=vbum2 
    // TODO, why can't this be coded in one statement ...
    lda s
    sta bram_heap_set_next.s
    // [710] bram_heap_set_next::index = bram_heap_list_remove::prev#0 -- vbum1=vbum2 
    lda prev
    sta bram_heap_set_next.index
    // [711] bram_heap_set_next::next = bram_heap_list_remove::next#0 -- vbum1=vbum2 
    lda next
    sta bram_heap_set_next.next
    // [712] callexecute bram_heap_set_next  -- call_vprc1 
    jsr bram_heap_set_next
    // bram_heap_set_prev(s, next, prev)
    // [713] bram_heap_set_prev::s = bram_heap_list_remove::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_prev.s
    // [714] bram_heap_set_prev::index = bram_heap_list_remove::next#0
    // [715] bram_heap_set_prev::prev = bram_heap_list_remove::prev#0
    // [716] callexecute bram_heap_set_prev  -- call_vprc1 
    jsr bram_heap_set_prev
    // if(index == list)
    // [717] if(bram_heap_list_remove::index!=bram_heap_list_remove::list) goto bram_heap_list_remove::@3 -- vbum1_neq_vbum2_then_la1 
    lda index
    cmp list
    beq !__breturn+
    jmp __breturn
  !__breturn:
    // bram_heap_list_remove::@6
    // bram_heap_get_next(s, list)
    // [718] bram_heap_get_next::s = bram_heap_list_remove::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_next.s
    // [719] bram_heap_get_next::index = bram_heap_list_remove::list -- vbum1=vbum2 
    lda list
    sta bram_heap_get_next.index
    // [720] callexecute bram_heap_get_next  -- call_vprc1 
    jsr bram_heap_get_next
    // [721] bram_heap_list_remove::$13 = bram_heap_get_next::return -- vbum1=vbum2 
    lda bram_heap_get_next.return
    sta bram_heap_list_remove__13
    // list = bram_heap_get_next(s, list)
    // [722] bram_heap_list_remove::list = bram_heap_list_remove::$13
    // bram_heap_list_remove::@3
    // return list;
    // [723] bram_heap_list_remove::return = bram_heap_list_remove::list
    rts
  .segment DataBramHeap
    s: .byte 0
    list: .byte 0
    .label index = heap_idle_remove.idle_index
    .label return = list
    .label bram_heap_list_remove__2 = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    .label bram_heap_list_remove__13 = list
    .label next = bram_heap_set_prev.index
    .label prev = lib_bramheap.bram_heap_get_size.index
}
.segment CodeBramHeap
  // bram_heap_is_free
// __mem() bool bram_heap_is_free(__mem() char s, __mem() char index)
bram_heap_is_free: {
    .label bram_heap_is_free__4 = $d
    .label bram_heap_map = $d
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [724] bram_heap_is_free::$5 = (unsigned int)bram_heap_is_free::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_is_free__5
    lda #0
    sta bram_heap_is_free__5+1
    // [725] bram_heap_is_free::$3 = bram_heap_is_free::$5 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_is_free__3
    rol bram_heap_is_free__3+1
    dey
    bne !-
  !e:
    // [726] bram_heap_is_free::bram_heap_map#0 = bram_heap_index + bram_heap_is_free::$3 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_is_free__3
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_is_free__3+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_heap_map->size1[index] & 0x80
    // [727] bram_heap_is_free::$4 = (char *)bram_heap_is_free::bram_heap_map#0 + $300 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_is_free__4
    clc
    adc #<$300
    sta.z bram_heap_is_free__4
    lda.z bram_heap_is_free__4+1
    adc #>$300
    sta.z bram_heap_is_free__4+1
    // [728] bram_heap_is_free::$1 = bram_heap_is_free::$4[bram_heap_is_free::index] & $80 -- vbum1=pbuz2_derefidx_vbum1_band_vbuc1 
    lda #$80
    ldy bram_heap_is_free__1
    and (bram_heap_is_free__4),y
    sta bram_heap_is_free__1
    // (bram_heap_map->size1[index] & 0x80) == 0x80
    // [729] bram_heap_is_free::$2 = bram_heap_is_free::$1 == $80 -- vbom1=vbum1_eq_vbuc1 
    lda bram_heap_is_free__2
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    sta bram_heap_is_free__2
    // return (bram_heap_map->size1[index] & 0x80) == 0x80;
    // [730] bram_heap_is_free::return = bram_heap_is_free::$2
    // bram_heap_is_free::@return
    // }
    // [731] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    .label index = bram_heap_find_best_fit.best_index
    .label return = bram_heap_find_best_fit.best_index
    .label bram_heap_is_free__1 = bram_heap_find_best_fit.best_index
    .label bram_heap_is_free__2 = bram_heap_find_best_fit.best_index
    .label bram_heap_is_free__3 = bram_heap_find_best_fit.best_size_1
    .label bram_heap_is_free__5 = bram_heap_find_best_fit.best_size_1
}
.segment CodeBramHeap
  // bram_heap_idle_count
/**
 * @brief Return the amount of idle records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
// __mem() unsigned int bram_heap_idle_count(__mem() char s)
bram_heap_idle_count: {
    // return bram_heap_segment.idleCount[s];
    // [732] bram_heap_idle_count::$0 = bram_heap_idle_count::s << 1 -- vbum1=vbum1_rol_1 
    asl bram_heap_idle_count__0
    // [733] bram_heap_idle_count::return = ((unsigned int *)&bram_heap_segment+$29)[bram_heap_idle_count::$0] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_idle_count__0
    lda bram_heap_segment+$29,y
    sta return
    lda bram_heap_segment+$29+1,y
    sta return+1
    // bram_heap_idle_count::@return
    // }
    // [734] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.index
    .label return = bram_heap_find_best_fit.best_size
    .label bram_heap_idle_count__0 = bram_heap_dump_index_print.index
}
.segment CodeBramHeap
  // bram_heap_free_count
/**
 * @brief Return the amount of free records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
// __mem() unsigned int bram_heap_free_count(__mem() char s)
bram_heap_free_count: {
    // return bram_heap_segment.freeCount[s];
    // [735] bram_heap_free_count::$0 = bram_heap_free_count::s << 1 -- vbum1=vbum1_rol_1 
    asl bram_heap_free_count__0
    // [736] bram_heap_free_count::return = ((unsigned int *)&bram_heap_segment+$25)[bram_heap_free_count::$0] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_free_count__0
    lda bram_heap_segment+$25,y
    sta return
    lda bram_heap_segment+$25+1,y
    sta return+1
    // bram_heap_free_count::@return
    // }
    // [737] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.index
    .label return = bram_heap_find_best_fit.best_size_1
    .label bram_heap_free_count__0 = bram_heap_dump_index_print.index
}
.segment CodeBramHeap
  // bram_heap_alloc_count
/**
 * @brief Return the amount of heap records in the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_count 
 */
// __mem() unsigned int bram_heap_alloc_count(__mem() char s)
bram_heap_alloc_count: {
    // return bram_heap_segment.heapCount[s];
    // [738] bram_heap_alloc_count::$0 = bram_heap_alloc_count::s << 1 -- vbum1=vbum1_rol_1 
    asl bram_heap_alloc_count__0
    // [739] bram_heap_alloc_count::return = ((unsigned int *)&bram_heap_segment+$21)[bram_heap_alloc_count::$0] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_alloc_count__0
    lda bram_heap_segment+$21,y
    sta return
    lda bram_heap_segment+$21+1,y
    sta return+1
    // bram_heap_alloc_count::@return
    // }
    // [740] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.index
    .label return = bram_heap_coalesce.right_size
    .label bram_heap_alloc_count__0 = bram_heap_dump_index_print.index
}
.segment CodeBramHeap
  // bram_heap_free_size
/**
 * @brief Return the size of free heap of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 * @return heap_size_large
 */
// __mem() unsigned long bram_heap_free_size(__mem() char s)
bram_heap_free_size: {
    // bram_heap_size_packed_t freeSize = bram_heap_segment.freeSize[s]
    // [741] bram_heap_free_size::$1 = bram_heap_free_size::s << 1 -- vbum1=vbum1_rol_1 
    asl bram_heap_free_size__1
    // [742] bram_heap_free_size::freeSize#0 = ((unsigned int *)&bram_heap_segment+$31)[bram_heap_free_size::$1] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_free_size__1
    lda bram_heap_segment+$31,y
    sta freeSize
    lda bram_heap_segment+$31+1,y
    sta freeSize+1
    // bram_heap_size_unpack(freeSize)
    // [743] bram_heap_size_unpack::size = bram_heap_free_size::freeSize#0
    // [744] callexecute bram_heap_size_unpack  -- call_vprc1 
    jsr bram_heap_size_unpack
    // [745] bram_heap_free_size::$0 = bram_heap_size_unpack::return
    // return (bram_heap_size_t)bram_heap_size_unpack(freeSize);
    // [746] bram_heap_free_size::return = bram_heap_free_size::$0
    // bram_heap_free_size::@return
    // }
    // [747] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.index
    .label return = bram_heap_size_unpack.bram_heap_size_unpack__1
    .label bram_heap_free_size__0 = bram_heap_size_unpack.bram_heap_size_unpack__1
    .label bram_heap_free_size__1 = bram_heap_dump_index_print.index
    .label freeSize = bram_heap_dump_index_print.count
}
.segment CodeBramHeap
  // bram_heap_alloc_size
// TODO - make long
// __mem() unsigned long bram_heap_alloc_size(__mem() char s)
bram_heap_alloc_size: {
    // bram_heap_size_packed_t heapSize = bram_heap_segment.heapSize[s]
    // [748] bram_heap_alloc_size::$1 = bram_heap_alloc_size::s << 1 -- vbum1=vbum1_rol_1 
    asl bram_heap_alloc_size__1
    // [749] bram_heap_alloc_size::heapSize#0 = ((unsigned int *)&bram_heap_segment+$2d)[bram_heap_alloc_size::$1] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_alloc_size__1
    lda bram_heap_segment+$2d,y
    sta heapSize
    lda bram_heap_segment+$2d+1,y
    sta heapSize+1
    // bram_heap_size_unpack(heapSize)
    // [750] bram_heap_size_unpack::size = bram_heap_alloc_size::heapSize#0
    // [751] callexecute bram_heap_size_unpack  -- call_vprc1 
    jsr bram_heap_size_unpack
    // [752] bram_heap_alloc_size::$0 = bram_heap_size_unpack::return
    // return (bram_heap_size_t)bram_heap_size_unpack(heapSize);
    // [753] bram_heap_alloc_size::return = bram_heap_alloc_size::$0 -- vdum1=vdum2 
    lda bram_heap_alloc_size__0
    sta return
    lda bram_heap_alloc_size__0+1
    sta return+1
    lda bram_heap_alloc_size__0+2
    sta return+2
    lda bram_heap_alloc_size__0+3
    sta return+3
    // bram_heap_alloc_size::@return
    // }
    // [754] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.index
    return: .dword 0
    .label bram_heap_alloc_size__0 = bram_heap_size_unpack.bram_heap_size_unpack__1
    .label bram_heap_alloc_size__1 = bram_heap_dump_index_print.index
    .label heapSize = bram_heap_dump_index_print.count
}
.segment CodeBramHeap
  // bram_heap_get_size_packed
// __mem() unsigned int bram_heap_get_size_packed(__mem() char s, __mem() char index)
bram_heap_get_size_packed: {
    .label bram_heap_get_size_packed__3 = $d
    .label bram_heap_get_size_packed__4 = $b
    .label bram_heap_map = $b
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [755] bram_heap_get_size_packed::$5 = (unsigned int)bram_heap_get_size_packed::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_get_size_packed__5
    lda #0
    sta bram_heap_get_size_packed__5+1
    // [756] bram_heap_get_size_packed::$2 = bram_heap_get_size_packed::$5 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_get_size_packed__2
    rol bram_heap_get_size_packed__2+1
    dey
    bne !-
  !e:
    // [757] bram_heap_get_size_packed::bram_heap_map#0 = bram_heap_index + bram_heap_get_size_packed::$2 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_get_size_packed__2
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_get_size_packed__2+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // unsigned char hi = bram_heap_map->size1[index]
    // [758] bram_heap_get_size_packed::$3 = (char *)bram_heap_get_size_packed::bram_heap_map#0 + $300 -- pbuz1=pbuz2_plus_vwuc1 
    lda.z bram_heap_map
    clc
    adc #<$300
    sta.z bram_heap_get_size_packed__3
    lda.z bram_heap_map+1
    adc #>$300
    sta.z bram_heap_get_size_packed__3+1
    // [759] bram_heap_get_size_packed::hi#0 = bram_heap_get_size_packed::$3[bram_heap_get_size_packed::index] -- vbum1=pbuz2_derefidx_vbum3 
    ldy index
    lda (bram_heap_get_size_packed__3),y
    sta hi
    // hi &= 0x7F
    // [760] bram_heap_get_size_packed::hi#1 = bram_heap_get_size_packed::hi#0 & $7f -- vbum1=vbum1_band_vbuc1 
    lda #$7f
    and hi
    sta hi
    // unsigned char lo = bram_heap_map->size0[index]
    // [761] bram_heap_get_size_packed::$4 = (char *)bram_heap_get_size_packed::bram_heap_map#0 + $200 -- pbuz1=pbuz1_plus_vwuc1 
    // Ignore free flag!
    lda.z bram_heap_get_size_packed__4
    clc
    adc #<$200
    sta.z bram_heap_get_size_packed__4
    lda.z bram_heap_get_size_packed__4+1
    adc #>$200
    sta.z bram_heap_get_size_packed__4+1
    // [762] bram_heap_get_size_packed::lo#0 = bram_heap_get_size_packed::$4[bram_heap_get_size_packed::index] -- vbum1=pbuz2_derefidx_vbum1 
    // Ignore free flag!
    ldy lo
    lda (bram_heap_get_size_packed__4),y
    sta lo
    // MAKEWORD(hi, lo)
    // [763] bram_heap_get_size_packed::$1 = bram_heap_get_size_packed::hi#1 w= bram_heap_get_size_packed::lo#0 -- vwum1=vbum2_word_vbum3 
    lda hi
    sta bram_heap_get_size_packed__1+1
    lda lo
    sta bram_heap_get_size_packed__1
    // return MAKEWORD(hi, lo);
    // [764] bram_heap_get_size_packed::return = bram_heap_get_size_packed::$1
  // return MAKEWORD(bram_heap_map->size1[index] & 0x7F, bram_heap_map->size0[index]); // Ignore free flag!
    // bram_heap_get_size_packed::@return
    // }
    // [765] return 
    rts
  .segment DataBramHeap
    .label s = lib_bramheap.bram_heap_get_size.s
    .label index = lib_bramheap.bram_heap_get_size.index
    .label return = bram_heap_find_best_fit.best_size_1
    .label bram_heap_get_size_packed__1 = bram_heap_find_best_fit.best_size_1
    .label bram_heap_get_size_packed__2 = bram_heap_find_best_fit.best_size_1
    .label bram_heap_get_size_packed__5 = bram_heap_find_best_fit.best_size_1
    .label hi = lib_bramheap.bram_heap_get_size.s
    .label lo = lib_bramheap.bram_heap_get_size.index
}
.segment CodeBramHeap
  // bram_heap_get_size
// __mem() unsigned long bram_heap_get_size(__mem() char s, __mem() char index)
bram_heap_get_size: {
    // bram_heap_get_size::bank_get_bram1
    // return BRAM;
    // [767] bram_heap_get_size::bank_get_bram1_return#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_get_bram1_return
    // bram_heap_get_size::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [768] bram_heap_get_size::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbum1=_deref_pbuc1 
    lda bram_heap_segment+$35
    sta bank_set_bram1_bank
    // bram_heap_get_size::bank_set_bram1
    // BRAM = bank
    // [769] BRAM = bram_heap_get_size::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // bram_heap_get_size::@2
    // bram_heap_get_size_packed(s, index)
    // [770] bram_heap_get_size_packed::s = bram_heap_get_size::s
    // [771] bram_heap_get_size_packed::index = bram_heap_get_size::index
    // [772] callexecute bram_heap_get_size_packed  -- call_vprc1 
    jsr bram_heap_get_size_packed
    // [773] bram_heap_get_size::$2 = bram_heap_get_size_packed::return
    // bram_heap_size_t size_packed = (bram_heap_size_t)bram_heap_get_size_packed(s, index)
    // [774] bram_heap_get_size::size_packed#0 = (unsigned long)bram_heap_get_size::$2 -- vdum1=_dword_vwum2 
    lda bram_heap_get_size__2
    sta size_packed
    lda bram_heap_get_size__2+1
    sta size_packed+1
    lda #0
    sta size_packed+2
    sta size_packed+3
    // bram_heap_get_size::bank_set_bram2
    // BRAM = bank
    // [775] BRAM = bram_heap_get_size::bank_get_bram1_return#0 -- vbuz1=vbum2 
    lda bank_get_bram1_return
    sta.z BRAM
    // bram_heap_get_size::@3
    // bram_heap_size_t size = size_packed << 5
    // [776] bram_heap_get_size::size#0 = bram_heap_get_size::size_packed#0 << 5 -- vdum1=vdum1_rol_5 
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
    asl size
    rol size+1
    rol size+2
    rol size+3
    // return size;
    // [777] bram_heap_get_size::return = bram_heap_get_size::size#0
    // bram_heap_get_size::@return
    // }
    // [778] return 
    rts
  .segment DataBramHeap
    s: .byte 0
    index: .byte 0
    .label return = bram_heap_dump_index_print.bram_heap_dump_index_print__10
    .label bram_heap_get_size__2 = bram_heap_find_best_fit.best_size_1
  .segment Data
    .label bank_get_bram1_return = printf_number_buffer.len
    .label bank_set_bram1_bank = printf_number_buffer.len
  .segment DataBramHeap
    .label size_packed = bram_heap_dump_index_print.bram_heap_dump_index_print__10
    .label size = bram_heap_dump_index_print.bram_heap_dump_index_print__10
}
.segment CodeBramHeap
  // bram_heap_data_get_bank
// __mem() char bram_heap_data_get_bank(__mem() char s, __mem() char index)
bram_heap_data_get_bank: {
    .label bram_heap_data_get_bank__5 = $b
    .label bram_heap_map = $b
    // bram_heap_data_get_bank::bank_get_bram1
    // return BRAM;
    // [780] bram_heap_data_get_bank::bank_get_bram1_return#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_get_bram1_return
    // bram_heap_data_get_bank::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [781] bram_heap_data_get_bank::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbum1=_deref_pbuc1 
    lda bram_heap_segment+$35
    sta bank_set_bram1_bank
    // bram_heap_data_get_bank::bank_set_bram1
    // BRAM = bank
    // [782] BRAM = bram_heap_data_get_bank::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // bram_heap_data_get_bank::@2
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [783] bram_heap_data_get_bank::$6 = (unsigned int)bram_heap_data_get_bank::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_data_get_bank__6
    lda #0
    sta bram_heap_data_get_bank__6+1
    // [784] bram_heap_data_get_bank::$4 = bram_heap_data_get_bank::$6 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_data_get_bank__4
    rol bram_heap_data_get_bank__4+1
    dey
    bne !-
  !e:
    // [785] bram_heap_data_get_bank::bram_heap_map#0 = bram_heap_index + bram_heap_data_get_bank::$4 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_data_get_bank__4
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_data_get_bank__4+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // bram_bank_t bram_bank = bram_heap_map->data1[index]
    // [786] bram_heap_data_get_bank::$5 = (char *)bram_heap_data_get_bank::bram_heap_map#0 + $100 -- pbuz1=pbuz1_plus_vwuc1 
    lda.z bram_heap_data_get_bank__5
    clc
    adc #<$100
    sta.z bram_heap_data_get_bank__5
    lda.z bram_heap_data_get_bank__5+1
    adc #>$100
    sta.z bram_heap_data_get_bank__5+1
    // [787] bram_heap_data_get_bank::bram_bank#0 = bram_heap_data_get_bank::$5[bram_heap_data_get_bank::index] -- vbum1=pbuz2_derefidx_vbum1 
    ldy bram_bank
    lda (bram_heap_data_get_bank__5),y
    sta bram_bank
    // bram_heap_data_get_bank::bank_set_bram2
    // BRAM = bank
    // [788] BRAM = bram_heap_data_get_bank::bank_get_bram1_return#0 -- vbuz1=vbum2 
    lda bank_get_bram1_return
    sta.z BRAM
    // bram_heap_data_get_bank::@3
    // return bram_bank;
    // [789] bram_heap_data_get_bank::return = bram_heap_data_get_bank::bram_bank#0
    // bram_heap_data_get_bank::@return
    // }
    // [790] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    .label index = bram_heap_index_add.index
    .label return = bram_heap_index_add.index
    .label bram_heap_data_get_bank__4 = bram_heap_find_best_fit.best_size
    .label bram_heap_data_get_bank__6 = bram_heap_find_best_fit.best_size
  .segment Data
    .label bank_get_bram1_return = printf_number_buffer.len
    .label bank_set_bram1_bank = printf_padding.i
  .segment DataBramHeap
    .label bram_bank = bram_heap_index_add.index
}
.segment CodeBramHeap
  // bram_heap_data_get_offset
// __zp($f) char * bram_heap_data_get_offset(__mem() char s, __mem() char index)
bram_heap_data_get_offset: {
    .label return = $f
    .label bram_heap_map = $d
    .label bram_ptr = $f
    // bram_heap_data_get_offset::bank_get_bram1
    // return BRAM;
    // [792] bram_heap_data_get_offset::bank_get_bram1_return#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_get_bram1_return
    // bram_heap_data_get_offset::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [793] bram_heap_data_get_offset::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbum1=_deref_pbuc1 
    lda bram_heap_segment+$35
    sta bank_set_bram1_bank
    // bram_heap_data_get_offset::bank_set_bram1
    // BRAM = bank
    // [794] BRAM = bram_heap_data_get_offset::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // bram_heap_data_get_offset::@2
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [795] bram_heap_data_get_offset::$8 = (unsigned int)bram_heap_data_get_offset::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_data_get_offset__8
    lda #0
    sta bram_heap_data_get_offset__8+1
    // [796] bram_heap_data_get_offset::$6 = bram_heap_data_get_offset::$8 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_data_get_offset__6
    rol bram_heap_data_get_offset__6+1
    dey
    bne !-
  !e:
    // [797] bram_heap_data_get_offset::bram_heap_map#0 = bram_heap_index + bram_heap_data_get_offset::$6 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_data_get_offset__6
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_data_get_offset__6+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // (unsigned int)bram_heap_map->data0[index] << 5
    // [798] bram_heap_data_get_offset::$10 = (unsigned int)((char *)bram_heap_data_get_offset::bram_heap_map#0)[bram_heap_data_get_offset::index] -- vwum1=_word_pbuz2_derefidx_vbum3 
    ldy index
    lda (bram_heap_map),y
    sta bram_heap_data_get_offset__10
    lda #0
    sta bram_heap_data_get_offset__10+1
    // [799] bram_heap_data_get_offset::$3 = bram_heap_data_get_offset::$10 << 5 -- vwum1=vwum1_rol_5 
    asl bram_heap_data_get_offset__3
    rol bram_heap_data_get_offset__3+1
    asl bram_heap_data_get_offset__3
    rol bram_heap_data_get_offset__3+1
    asl bram_heap_data_get_offset__3
    rol bram_heap_data_get_offset__3+1
    asl bram_heap_data_get_offset__3
    rol bram_heap_data_get_offset__3+1
    asl bram_heap_data_get_offset__3
    rol bram_heap_data_get_offset__3+1
    // ((unsigned int)bram_heap_map->data0[index] << 5) | 0xA000
    // [800] bram_heap_data_get_offset::bram_ptr#0 = bram_heap_data_get_offset::$3 | $a000 -- vwuz1=vwum2_bor_vwuc1 
    lda bram_heap_data_get_offset__3
    ora #<$a000
    sta.z bram_ptr
    lda bram_heap_data_get_offset__3+1
    ora #>$a000
    sta.z bram_ptr+1
    // bram_heap_data_get_offset::bank_set_bram2
    // BRAM = bank
    // [801] BRAM = bram_heap_data_get_offset::bank_get_bram1_return#0 -- vbuz1=vbum2 
    lda bank_get_bram1_return
    sta.z BRAM
    // bram_heap_data_get_offset::@3
    // return bram_ptr;
    // [802] bram_heap_data_get_offset::return = (char *)bram_heap_data_get_offset::bram_ptr#0
    // bram_heap_data_get_offset::@return
    // }
    // [803] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    .label index = bram_heap_find_best_fit.best_index
    .label bram_heap_data_get_offset__3 = bram_heap_find_best_fit.best_size
    .label bram_heap_data_get_offset__6 = bram_heap_find_best_fit.best_size
    .label bram_heap_data_get_offset__8 = bram_heap_find_best_fit.best_size
    .label bram_heap_data_get_offset__10 = bram_heap_find_best_fit.best_size
  .segment Data
    .label bank_get_bram1_return = printf_number_buffer.len
    .label bank_set_bram1_bank = printf_padding.i
}
.segment CodeBramHeap
  // bram_heap_get_data_packed
// __mem() unsigned int bram_heap_get_data_packed(__mem() char s, __mem() char index)
bram_heap_get_data_packed: {
    .label bram_heap_get_data_packed__3 = $f
    .label bram_heap_map = $d
    // bram_heap_map_t* bram_heap_map = &bram_heap_index[(unsigned int)s]
    // [804] bram_heap_get_data_packed::$5 = (unsigned int)bram_heap_get_data_packed::s -- vwum1=_word_vbum2 
    lda s
    sta bram_heap_get_data_packed__5
    lda #0
    sta bram_heap_get_data_packed__5+1
    // [805] bram_heap_get_data_packed::$2 = bram_heap_get_data_packed::$5 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl bram_heap_get_data_packed__2
    rol bram_heap_get_data_packed__2+1
    dey
    bne !-
  !e:
    // [806] bram_heap_get_data_packed::bram_heap_map#0 = bram_heap_index + bram_heap_get_data_packed::$2 -- pssz1=pssc1_plus_vwum2 
    lda bram_heap_get_data_packed__2
    clc
    adc #<bram_heap_index
    sta.z bram_heap_map
    lda bram_heap_get_data_packed__2+1
    adc #>bram_heap_index
    sta.z bram_heap_map+1
    // unsigned char hi = bram_heap_map->data1[index]
    // [807] bram_heap_get_data_packed::$3 = (char *)bram_heap_get_data_packed::bram_heap_map#0 + $100 -- pbuz1=pbuz2_plus_vwuc1 
    lda.z bram_heap_map
    clc
    adc #<$100
    sta.z bram_heap_get_data_packed__3
    lda.z bram_heap_map+1
    adc #>$100
    sta.z bram_heap_get_data_packed__3+1
    // [808] bram_heap_get_data_packed::hi#0 = bram_heap_get_data_packed::$3[bram_heap_get_data_packed::index] -- vbum1=pbuz2_derefidx_vbum3 
    ldy index
    lda (bram_heap_get_data_packed__3),y
    sta hi
    // unsigned char lo = bram_heap_map->data0[index]
    // [809] bram_heap_get_data_packed::lo#0 = ((char *)bram_heap_get_data_packed::bram_heap_map#0)[bram_heap_get_data_packed::index] -- vbum1=pbuz2_derefidx_vbum1 
    ldy lo
    lda (bram_heap_map),y
    sta lo
    // MAKEWORD(hi, lo)
    // [810] bram_heap_get_data_packed::$1 = bram_heap_get_data_packed::hi#0 w= bram_heap_get_data_packed::lo#0 -- vwum1=vbum2_word_vbum3 
    lda hi
    sta bram_heap_get_data_packed__1+1
    lda lo
    sta bram_heap_get_data_packed__1
    // return MAKEWORD(hi, lo);
    // [811] bram_heap_get_data_packed::return = bram_heap_get_data_packed::$1
  // return MAKEWORD(bram_heap_map->data1[index], bram_heap_map->data0[index]);
    // bram_heap_get_data_packed::@return
    // }
    // [812] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_dump_index_print.index
    .label index = bram_heap_find_best_fit.best_index
    .label return = bram_heap_coalesce.left_offset
    .label bram_heap_get_data_packed__1 = bram_heap_coalesce.left_offset
    .label bram_heap_get_data_packed__2 = bram_heap_dump_index_print.count
    .label bram_heap_get_data_packed__5 = bram_heap_dump_index_print.count
    .label hi = bram_heap_dump_index_print.index
    .label lo = bram_heap_find_best_fit.best_index
}
.segment CodeBramHeap
  // bram_heap_dump_xy
// void bram_heap_dump_xy(__mem() char x, __mem() char y)
bram_heap_dump_xy: {
    // bramheap_dx = x
    // [813] bramheap_dx = bram_heap_dump_xy::x
    // bramheap_dy = y
    // [814] bramheap_dy = bram_heap_dump_xy::y
    // bram_heap_dump_xy::@return
    // }
    // [815] return 
    rts
  .segment DataBramHeap
    .label x = bramheap_dx
    .label y = bramheap_dy
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
    // [817] bram_heap_dump_index::bank_get_bram1_return#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_get_bram1_return
    // bram_heap_dump_index::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [818] bram_heap_dump_index::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbum1=_deref_pbuc1 
    lda bram_heap_segment+$35
    sta bank_set_bram1_bank
    // bram_heap_dump_index::bank_set_bram1
    // BRAM = bank
    // [819] BRAM = bram_heap_dump_index::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // bram_heap_dump_index::@2
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [820] gotoxy::x = bramheap_dx -- vbum1=vbum2 
    lda bramheap_dx
    sta gotoxy.x
    // [821] gotoxy::y = bramheap_dy -- vbum1=vbum2 
    lda bramheap_dy
    sta gotoxy.y
    // [822] callexecute gotoxy  -- call_vprc1 
    jsr gotoxy
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [823] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // printf("#   T  OFFS  SIZE   N    P    L    R")
    // [824] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [825] printf_str::s = bram_heap_dump_index::s1 -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    // [826] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [827] gotoxy::x = bramheap_dx -- vbum1=vbum2 
    lda bramheap_dx
    sta gotoxy.x
    // [828] gotoxy::y = bramheap_dy -- vbum1=vbum2 
    lda bramheap_dy
    sta gotoxy.y
    // [829] callexecute gotoxy  -- call_vprc1 
    jsr gotoxy
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [830] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // printf("--- -  ------ -----  ---  ---  ---  ---")
    // [831] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [832] printf_str::s = bram_heap_dump_index::s2 -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    // [833] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // bram_heap_dump_index_print(s, 'I', bram_heap_segment.idle_list[s], bram_heap_segment.idleCount[s])
    // [834] bram_heap_dump_index::$10 = bram_heap_dump_index::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_dump_index__10
    // [835] bram_heap_dump_index_print::s = bram_heap_dump_index::s -- vbum1=vbum2 
    lda s
    sta bram_heap_dump_index_print.s
    // [836] bram_heap_dump_index_print::prefix = 'I'pm -- vbum1=vbuc1 
    lda #'I'
    sta bram_heap_dump_index_print.prefix
    // [837] bram_heap_dump_index_print::list = ((char *)&bram_heap_segment+$1b)[bram_heap_dump_index::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$1b,y
    sta bram_heap_dump_index_print.list
    // [838] bram_heap_dump_index_print::heap_count = ((unsigned int *)&bram_heap_segment+$29)[bram_heap_dump_index::$10] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_dump_index__10
    lda bram_heap_segment+$29,y
    sta bram_heap_dump_index_print.heap_count
    lda bram_heap_segment+$29+1,y
    sta bram_heap_dump_index_print.heap_count+1
    // [839] callexecute bram_heap_dump_index_print  -- call_vprc1 
    jsr bram_heap_dump_index_print
    // bram_heap_dump_index_print(s, 'F', bram_heap_segment.free_list[s], bram_heap_segment.freeCount[s])
    // [840] bram_heap_dump_index::$11 = bram_heap_dump_index::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_dump_index__11
    // [841] bram_heap_dump_index_print::s = bram_heap_dump_index::s -- vbum1=vbum2 
    lda s
    sta bram_heap_dump_index_print.s
    // [842] bram_heap_dump_index_print::prefix = 'F'pm -- vbum1=vbuc1 
    lda #'F'
    sta bram_heap_dump_index_print.prefix
    // [843] bram_heap_dump_index_print::list = ((char *)&bram_heap_segment+$19)[bram_heap_dump_index::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$19,y
    sta bram_heap_dump_index_print.list
    // [844] bram_heap_dump_index_print::heap_count = ((unsigned int *)&bram_heap_segment+$25)[bram_heap_dump_index::$11] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_dump_index__11
    lda bram_heap_segment+$25,y
    sta bram_heap_dump_index_print.heap_count
    lda bram_heap_segment+$25+1,y
    sta bram_heap_dump_index_print.heap_count+1
    // [845] callexecute bram_heap_dump_index_print  -- call_vprc1 
    jsr bram_heap_dump_index_print
    // bram_heap_dump_index_print(s, 'H', bram_heap_segment.heap_list[s], bram_heap_segment.heapCount[s])
    // [846] bram_heap_dump_index::$12 = bram_heap_dump_index::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_dump_index__12
    // [847] bram_heap_dump_index_print::s = bram_heap_dump_index::s -- vbum1=vbum2 
    lda s
    sta bram_heap_dump_index_print.s
    // [848] bram_heap_dump_index_print::prefix = 'H'pm -- vbum1=vbuc1 
    lda #'H'
    sta bram_heap_dump_index_print.prefix
    // [849] bram_heap_dump_index_print::list = ((char *)&bram_heap_segment+$17)[bram_heap_dump_index::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$17,y
    sta bram_heap_dump_index_print.list
    // [850] bram_heap_dump_index_print::heap_count = ((unsigned int *)&bram_heap_segment+$21)[bram_heap_dump_index::$12] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_dump_index__12
    lda bram_heap_segment+$21,y
    sta bram_heap_dump_index_print.heap_count
    lda bram_heap_segment+$21+1,y
    sta bram_heap_dump_index_print.heap_count+1
    // [851] callexecute bram_heap_dump_index_print  -- call_vprc1 
    jsr bram_heap_dump_index_print
    // bram_heap_dump_index::bank_set_bram2
    // BRAM = bank
    // [852] BRAM = bram_heap_dump_index::bank_get_bram1_return#0 -- vbuz1=vbum2 
    lda bank_get_bram1_return
    sta.z BRAM
    // bram_heap_dump_index::@return
    // }
    // [853] return 
    rts
  .segment DataBramHeap
    s1: .text "#   T  OFFS  SIZE   N    P    L    R"
    .byte 0
    s2: .text "--- -  ------ -----  ---  ---  ---  ---"
    .byte 0
    s: .byte 0
    .label bram_heap_dump_index__10 = bram_heap_dump_index_print.index
    .label bram_heap_dump_index__11 = bram_heap_dump_index_print.index
    .label bram_heap_dump_index__12 = bram_heap_dump_index_print.index
  .segment Data
    bank_get_bram1_return: .byte 0
    .label bank_set_bram1_bank = printf_number_buffer.len
}
.segment CodeBramHeap
  // bram_heap_dump_stats
/**
 * @brief Print the heap memory manager statistics of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
// void bram_heap_dump_stats(__mem() char s)
bram_heap_dump_stats: {
    // bram_heap_size_t alloc_size = bram_heap_alloc_size(s)
    // [854] bram_heap_alloc_size::s = bram_heap_dump_stats::s -- vbum1=vbum2 
    lda s
    sta bram_heap_alloc_size.s
    // [855] callexecute bram_heap_alloc_size  -- call_vprc1 
    jsr bram_heap_alloc_size
    // [856] bram_heap_dump_stats::alloc_size#0 = bram_heap_alloc_size::return
    // bram_heap_size_t free_size = bram_heap_free_size(s)
    // [857] bram_heap_free_size::s = bram_heap_dump_stats::s -- vbum1=vbum2 
    lda s
    sta bram_heap_free_size.s
    // [858] callexecute bram_heap_free_size  -- call_vprc1 
    jsr bram_heap_free_size
    // [859] bram_heap_dump_stats::free_size#0 = bram_heap_free_size::return
    // unsigned int alloc_count = bram_heap_alloc_count(s)
    // [860] bram_heap_alloc_count::s = bram_heap_dump_stats::s -- vbum1=vbum2 
    lda s
    sta bram_heap_alloc_count.s
    // [861] callexecute bram_heap_alloc_count  -- call_vprc1 
    jsr bram_heap_alloc_count
    // [862] bram_heap_dump_stats::alloc_count#0 = bram_heap_alloc_count::return
    // unsigned int free_count = bram_heap_free_count(s)
    // [863] bram_heap_free_count::s = bram_heap_dump_stats::s -- vbum1=vbum2 
    lda s
    sta bram_heap_free_count.s
    // [864] callexecute bram_heap_free_count  -- call_vprc1 
    jsr bram_heap_free_count
    // [865] bram_heap_dump_stats::free_count#0 = bram_heap_free_count::return
    // unsigned int idle_count = bram_heap_idle_count(s)
    // [866] bram_heap_idle_count::s = bram_heap_dump_stats::s -- vbum1=vbum2 
    lda s
    sta bram_heap_idle_count.s
    // [867] callexecute bram_heap_idle_count  -- call_vprc1 
    jsr bram_heap_idle_count
    // [868] bram_heap_dump_stats::idle_count#0 = bram_heap_idle_count::return
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [869] gotoxy::x = bramheap_dx -- vbum1=vbum2 
    lda bramheap_dx
    sta gotoxy.x
    // [870] gotoxy::y = bramheap_dy -- vbum1=vbum2 
    lda bramheap_dy
    sta gotoxy.y
    // [871] callexecute gotoxy  -- call_vprc1 
    jsr gotoxy
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [872] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // printf("size  heap:%05x  free:%05x   pos:%03x", alloc_size, free_size, bram_heap_segment.index_position[s])
    // [873] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [874] printf_str::s = bram_heap_dump_stats::s1 -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    // [875] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [876] printf_ulong::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_ulong.putc
    lda #>cputc
    sta.z printf_ulong.putc+1
    // [877] printf_ulong::uvalue = bram_heap_dump_stats::alloc_size#0 -- vdum1=vdum2 
    lda alloc_size
    sta printf_ulong.uvalue
    lda alloc_size+1
    sta printf_ulong.uvalue+1
    lda alloc_size+2
    sta printf_ulong.uvalue+2
    lda alloc_size+3
    sta printf_ulong.uvalue+3
    // [878] printf_ulong::format_min_length = 5 -- vbum1=vbuc1 
    lda #5
    sta printf_ulong.format_min_length
    // [879] printf_ulong::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_ulong.format_justify_left
    // [880] printf_ulong::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_ulong.format_sign_always
    // [881] printf_ulong::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_ulong.format_zero_padding
    // [882] printf_ulong::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_ulong.format_upper_case
    // [883] printf_ulong::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_ulong.format_radix
    // [884] callexecute printf_ulong  -- call_vprc1 
    jsr printf_ulong
    // [885] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [886] printf_str::s = bram_heap_dump_stats::s2 -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    // [887] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [888] printf_ulong::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_ulong.putc
    lda #>cputc
    sta.z printf_ulong.putc+1
    // [889] printf_ulong::uvalue = bram_heap_dump_stats::free_size#0 -- vdum1=vdum2 
    lda free_size
    sta printf_ulong.uvalue
    lda free_size+1
    sta printf_ulong.uvalue+1
    lda free_size+2
    sta printf_ulong.uvalue+2
    lda free_size+3
    sta printf_ulong.uvalue+3
    // [890] printf_ulong::format_min_length = 5 -- vbum1=vbuc1 
    lda #5
    sta printf_ulong.format_min_length
    // [891] printf_ulong::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_ulong.format_justify_left
    // [892] printf_ulong::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_ulong.format_sign_always
    // [893] printf_ulong::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_ulong.format_zero_padding
    // [894] printf_ulong::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_ulong.format_upper_case
    // [895] printf_ulong::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_ulong.format_radix
    // [896] callexecute printf_ulong  -- call_vprc1 
    jsr printf_ulong
    // [897] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [898] printf_str::s = bram_heap_dump_stats::s3 -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    // [899] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [900] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [901] printf_uchar::uvalue = ((char *)&bram_heap_segment+1)[bram_heap_dump_stats::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+1,y
    sta printf_uchar.uvalue
    // [902] printf_uchar::format_min_length = 3 -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [903] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [904] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [905] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [906] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [907] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [908] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [909] gotoxy::x = bramheap_dx -- vbum1=vbum2 
    lda bramheap_dx
    sta gotoxy.x
    // [910] gotoxy::y = bramheap_dy -- vbum1=vbum2 
    lda bramheap_dy
    sta gotoxy.y
    // [911] callexecute gotoxy  -- call_vprc1 
    jsr gotoxy
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [912] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // printf("count  heap:%04u  free:%04u  idle:%04u", alloc_count, free_count, idle_count)
    // [913] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [914] printf_str::s = bram_heap_dump_stats::s4 -- pbuz1=pbuc1 
    lda #<s4
    sta.z printf_str.s
    lda #>s4
    sta.z printf_str.s+1
    // [915] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [916] printf_uint::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uint.putc
    lda #>cputc
    sta.z printf_uint.putc+1
    // [917] printf_uint::uvalue = bram_heap_dump_stats::alloc_count#0 -- vwum1=vwum2 
    lda alloc_count
    sta printf_uint.uvalue
    lda alloc_count+1
    sta printf_uint.uvalue+1
    // [918] printf_uint::format_min_length = 4 -- vbum1=vbuc1 
    lda #4
    sta printf_uint.format_min_length
    // [919] printf_uint::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uint.format_justify_left
    // [920] printf_uint::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uint.format_sign_always
    // [921] printf_uint::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uint.format_zero_padding
    // [922] printf_uint::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uint.format_upper_case
    // [923] printf_uint::format_radix = DECIMAL -- vbum1=vbuc1 
    lda #DECIMAL
    sta printf_uint.format_radix
    // [924] callexecute printf_uint  -- call_vprc1 
    jsr printf_uint
    // [925] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [926] printf_str::s = bram_heap_dump_stats::s2 -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    // [927] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [928] printf_uint::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uint.putc
    lda #>cputc
    sta.z printf_uint.putc+1
    // [929] printf_uint::uvalue = bram_heap_dump_stats::free_count#0 -- vwum1=vwum2 
    lda free_count
    sta printf_uint.uvalue
    lda free_count+1
    sta printf_uint.uvalue+1
    // [930] printf_uint::format_min_length = 4 -- vbum1=vbuc1 
    lda #4
    sta printf_uint.format_min_length
    // [931] printf_uint::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uint.format_justify_left
    // [932] printf_uint::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uint.format_sign_always
    // [933] printf_uint::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uint.format_zero_padding
    // [934] printf_uint::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uint.format_upper_case
    // [935] printf_uint::format_radix = DECIMAL -- vbum1=vbuc1 
    lda #DECIMAL
    sta printf_uint.format_radix
    // [936] callexecute printf_uint  -- call_vprc1 
    jsr printf_uint
    // [937] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [938] printf_str::s = bram_heap_dump_stats::s6 -- pbuz1=pbuc1 
    lda #<s6
    sta.z printf_str.s
    lda #>s6
    sta.z printf_str.s+1
    // [939] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [940] printf_uint::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uint.putc
    lda #>cputc
    sta.z printf_uint.putc+1
    // [941] printf_uint::uvalue = bram_heap_dump_stats::idle_count#0 -- vwum1=vwum2 
    lda idle_count
    sta printf_uint.uvalue
    lda idle_count+1
    sta printf_uint.uvalue+1
    // [942] printf_uint::format_min_length = 4 -- vbum1=vbuc1 
    lda #4
    sta printf_uint.format_min_length
    // [943] printf_uint::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uint.format_justify_left
    // [944] printf_uint::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uint.format_sign_always
    // [945] printf_uint::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uint.format_zero_padding
    // [946] printf_uint::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uint.format_upper_case
    // [947] printf_uint::format_radix = DECIMAL -- vbum1=vbuc1 
    lda #DECIMAL
    sta printf_uint.format_radix
    // [948] callexecute printf_uint  -- call_vprc1 
    jsr printf_uint
    // gotoxy(bramheap_dx, bramheap_dy++)
    // [949] gotoxy::x = bramheap_dx -- vbum1=vbum2 
    lda bramheap_dx
    sta gotoxy.x
    // [950] gotoxy::y = bramheap_dy -- vbum1=vbum2 
    lda bramheap_dy
    sta gotoxy.y
    // [951] callexecute gotoxy  -- call_vprc1 
    jsr gotoxy
    // gotoxy(bramheap_dx, bramheap_dy++);
    // [952] bramheap_dy = ++ bramheap_dy -- vbum1=_inc_vbum1 
    inc bramheap_dy
    // printf("list   heap:%03x   free:%03x   idle:%03x", bram_heap_segment.heap_list[s], bram_heap_segment.free_list[s], bram_heap_segment.idle_list[s])
    // [953] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [954] printf_str::s = bram_heap_dump_stats::s7 -- pbuz1=pbuc1 
    lda #<s7
    sta.z printf_str.s
    lda #>s7
    sta.z printf_str.s+1
    // [955] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [956] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [957] printf_uchar::uvalue = ((char *)&bram_heap_segment+$17)[bram_heap_dump_stats::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$17,y
    sta printf_uchar.uvalue
    // [958] printf_uchar::format_min_length = 3 -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [959] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [960] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [961] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [962] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [963] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [964] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // [965] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [966] printf_str::s = bram_heap_dump_stats::s8 -- pbuz1=pbuc1 
    lda #<s8
    sta.z printf_str.s
    lda #>s8
    sta.z printf_str.s+1
    // [967] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [968] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [969] printf_uchar::uvalue = ((char *)&bram_heap_segment+$19)[bram_heap_dump_stats::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$19,y
    sta printf_uchar.uvalue
    // [970] printf_uchar::format_min_length = 3 -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [971] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [972] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [973] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [974] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [975] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [976] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // [977] printf_str::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [978] printf_str::s = bram_heap_dump_stats::s9 -- pbuz1=pbuc1 
    lda #<s9
    sta.z printf_str.s
    lda #>s9
    sta.z printf_str.s+1
    // [979] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // [980] printf_uchar::putc = &cputc -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uchar.putc
    lda #>cputc
    sta.z printf_uchar.putc+1
    // [981] printf_uchar::uvalue = ((char *)&bram_heap_segment+$1b)[bram_heap_dump_stats::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$1b,y
    sta printf_uchar.uvalue
    // [982] printf_uchar::format_min_length = 3 -- vbum1=vbuc1 
    lda #3
    sta printf_uchar.format_min_length
    // [983] printf_uchar::format_justify_left = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_justify_left
    // [984] printf_uchar::format_sign_always = 0 -- vbum1=vbuc1 
    sta printf_uchar.format_sign_always
    // [985] printf_uchar::format_zero_padding = 1 -- vbum1=vbuc1 
    lda #1
    sta printf_uchar.format_zero_padding
    // [986] printf_uchar::format_upper_case = 0 -- vbum1=vbuc1 
    lda #0
    sta printf_uchar.format_upper_case
    // [987] printf_uchar::format_radix = HEXADECIMAL -- vbum1=vbuc1 
    lda #HEXADECIMAL
    sta printf_uchar.format_radix
    // [988] callexecute printf_uchar  -- call_vprc1 
    jsr printf_uchar
    // bram_heap_dump_stats::@return
    // }
    // [989] return 
    rts
  .segment DataBramHeap
    s1: .text "size  heap:"
    .byte 0
    s2: .text "  free:"
    .byte 0
    s3: .text "   pos:"
    .byte 0
    s4: .text "count  heap:"
    .byte 0
    s6: .text "  idle:"
    .byte 0
    s7: .text "list   heap:"
    .byte 0
    s8: .text "   free:"
    .byte 0
    s9: .text "   idle:"
    .byte 0
    .label s = bram_heap_find_best_fit.best_index
    .label alloc_size = bram_heap_alloc_size.return
    .label free_size = bram_heap_size_unpack.bram_heap_size_unpack__1
    .label alloc_count = bram_heap_coalesce.right_size
    .label free_count = bram_heap_find_best_fit.best_size_1
    .label idle_count = bram_heap_find_best_fit.best_size
}
.segment CodeBramHeap
  // bram_heap_dump
/**
 * @brief Print the heap memory manager statistics and dump the index of the segment.
 * 
 * @param segment The segment identifier, a value between 0 and 15.
 */
// void bram_heap_dump(__mem() char s, __mem() char x, __mem() char y)
bram_heap_dump: {
    // bram_heap_dump_xy(x, y)
    // [990] bram_heap_dump_xy::x = bram_heap_dump::x -- vbum1=vbum2 
    lda x
    sta bram_heap_dump_xy.x
    // [991] bram_heap_dump_xy::y = bram_heap_dump::y
    // [992] callexecute bram_heap_dump_xy  -- call_vprc1 
    jsr bram_heap_dump_xy
    // bram_heap_dump_stats(s)
    // [993] bram_heap_dump_stats::s = bram_heap_dump::s -- vbum1=vbum2 
    lda s
    sta bram_heap_dump_stats.s
    // [994] callexecute bram_heap_dump_stats  -- call_vprc1 
    jsr bram_heap_dump_stats
    // bram_heap_dump_index(s)
    // [995] bram_heap_dump_index::s = bram_heap_dump::s -- vbum1=vbum2 
    lda s
    sta bram_heap_dump_index.s
    // [996] callexecute bram_heap_dump_index  -- call_vprc1 
    jsr bram_heap_dump_index
    // bram_heap_dump::@return
    // }
    // [997] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_index_add.index
    .label x = bram_heap_dump_index_print.index
    .label y = bramheap_dy
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
    // bram_heap_free::bank_get_bram1
    // return BRAM;
    // [999] bram_heap_free::bram_bank#2 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bram_bank
    // bram_heap_free::@5
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [1000] bram_heap_free::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbum1=_deref_pbuc1 
    lda bram_heap_segment+$35
    sta bank_set_bram1_bank
    // bram_heap_free::bank_set_bram1
    // BRAM = bank
    // [1001] BRAM = bram_heap_free::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // bram_heap_free::@6
    // bram_heap_size_packed_t free_size = bram_heap_get_size_packed(s, free_index)
    // [1002] bram_heap_get_size_packed::s = bram_heap_free::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_size_packed.s
    // [1003] bram_heap_get_size_packed::index = bram_heap_free::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_get_size_packed.index
    // [1004] callexecute bram_heap_get_size_packed  -- call_vprc1 
    jsr bram_heap_get_size_packed
    // [1005] bram_heap_free::free_size#0 = bram_heap_get_size_packed::return -- vwum1=vwum2 
    lda bram_heap_get_size_packed.return
    sta free_size
    lda bram_heap_get_size_packed.return+1
    sta free_size+1
    // bram_heap_data_packed_t free_offset = bram_heap_get_data_packed(s, free_index)
    // [1006] bram_heap_get_data_packed::s = bram_heap_free::s -- vbum1=vbum2 
    lda s
    sta bram_heap_get_data_packed.s
    // [1007] bram_heap_get_data_packed::index = bram_heap_free::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_get_data_packed.index
    // [1008] callexecute bram_heap_get_data_packed  -- call_vprc1 
    jsr bram_heap_get_data_packed
    // [1009] bram_heap_free::free_offset#0 = bram_heap_get_data_packed::return -- vwum1=vwum2 
    lda bram_heap_get_data_packed.return
    sta free_offset
    lda bram_heap_get_data_packed.return+1
    sta free_offset+1
    // bram_heap_heap_remove(s, free_index)
    // [1010] bram_heap_heap_remove::s = bram_heap_free::s -- vbum1=vbum2 
    // TODO: only remove allocated indexes!
    lda s
    sta bram_heap_heap_remove.s
    // [1011] bram_heap_heap_remove::heap_index = bram_heap_free::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_heap_remove.heap_index
    // [1012] callexecute bram_heap_heap_remove  -- call_vprc1 
    jsr bram_heap_heap_remove
    // bram_heap_free_insert(s, free_index, free_offset, free_size)
    // [1013] bram_heap_free_insert::s = bram_heap_free::s -- vbum1=vbum2 
    lda s
    sta bram_heap_free_insert.s
    // [1014] bram_heap_free_insert::free_index = bram_heap_free::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_free_insert.free_index
    // [1015] bram_heap_free_insert::data = bram_heap_free::free_offset#0 -- vwum1=vwum2 
    lda free_offset
    sta bram_heap_free_insert.data
    lda free_offset+1
    sta bram_heap_free_insert.data+1
    // [1016] bram_heap_free_insert::size = bram_heap_free::free_size#0 -- vwum1=vwum2 
    lda free_size
    sta bram_heap_free_insert.size
    lda free_size+1
    sta bram_heap_free_insert.size+1
    // [1017] callexecute bram_heap_free_insert  -- call_vprc1 
    jsr bram_heap_free_insert
    // bram_heap_index_t free_left_index = bram_heap_can_coalesce_left(s, free_index)
    // [1018] bram_heap_can_coalesce_left::s = bram_heap_free::s -- vbum1=vbum2 
    lda s
    sta bram_heap_can_coalesce_left.s
    // [1019] bram_heap_can_coalesce_left::heap_index = bram_heap_free::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_can_coalesce_left.heap_index
    // [1020] callexecute bram_heap_can_coalesce_left  -- call_vprc1 
    jsr bram_heap_can_coalesce_left
    // [1021] bram_heap_free::free_left_index#0 = bram_heap_can_coalesce_left::return -- vbum1=vbum2 
    lda bram_heap_can_coalesce_left.return
    sta free_left_index
    // if(free_left_index != BRAM_HEAP_NULL)
    // [1022] if(bram_heap_free::free_left_index#0==$ff) goto bram_heap_free::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #$ff
    cmp free_left_index
    beq __b1
    // bram_heap_free::@3
    // bram_heap_coalesce(s, free_left_index, free_index)
    // [1023] bram_heap_coalesce::s = bram_heap_free::s -- vbum1=vbum2 
    lda s
    sta bram_heap_coalesce.s
    // [1024] bram_heap_coalesce::left_index = bram_heap_free::free_left_index#0
    // [1025] bram_heap_coalesce::right_index = bram_heap_free::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_coalesce.right_index
    // [1026] callexecute bram_heap_coalesce  -- call_vprc1 
    jsr bram_heap_coalesce
    // [1027] bram_heap_free::$13 = bram_heap_coalesce::return
    // free_index = bram_heap_coalesce(s, free_left_index, free_index)
    // [1028] bram_heap_free::free_index = bram_heap_free::$13 -- vbum1=vbum2 
    lda bram_heap_free__13
    sta free_index
    // bram_heap_free::@1
  __b1:
    // bram_heap_index_t free_right_index = heap_can_coalesce_right(s, free_index)
    // [1029] heap_can_coalesce_right::s = bram_heap_free::s -- vbum1=vbum2 
    lda s
    sta heap_can_coalesce_right.s
    // [1030] heap_can_coalesce_right::heap_index = bram_heap_free::free_index -- vbum1=vbum2 
    lda free_index
    sta heap_can_coalesce_right.heap_index
    // [1031] callexecute heap_can_coalesce_right  -- call_vprc1 
    jsr heap_can_coalesce_right
    // [1032] bram_heap_free::free_right_index#0 = heap_can_coalesce_right::return -- vbum1=vbum2 
    lda heap_can_coalesce_right.return
    sta free_right_index
    // if(free_right_index != BRAM_HEAP_NULL)
    // [1033] if(bram_heap_free::free_right_index#0==$ff) goto bram_heap_free::@2 -- vbum1_eq_vbuc1_then_la1 
    lda #$ff
    cmp free_right_index
    beq __b2
    // bram_heap_free::@4
    // bram_heap_coalesce(s, free_index, free_right_index)
    // [1034] bram_heap_coalesce::s = bram_heap_free::s -- vbum1=vbum2 
    lda s
    sta bram_heap_coalesce.s
    // [1035] bram_heap_coalesce::left_index = bram_heap_free::free_index -- vbum1=vbum2 
    lda free_index
    sta bram_heap_coalesce.left_index
    // [1036] bram_heap_coalesce::right_index = bram_heap_free::free_right_index#0
    // [1037] callexecute bram_heap_coalesce  -- call_vprc1 
    jsr bram_heap_coalesce
    // [1038] bram_heap_free::$14 = bram_heap_coalesce::return
    // free_index = bram_heap_coalesce(s, free_index, free_right_index)
    // [1039] bram_heap_free::free_index = bram_heap_free::$14 -- vbum1=vbum2 
    lda bram_heap_free__14
    sta free_index
    // bram_heap_free::@2
  __b2:
    // bram_heap_segment.freeSize[s] += free_size
    // [1040] bram_heap_free::$15 = bram_heap_free::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_free__15
    // [1041] ((unsigned int *)&bram_heap_segment+$31)[bram_heap_free::$15] = ((unsigned int *)&bram_heap_segment+$31)[bram_heap_free::$15] + bram_heap_free::free_size#0 -- pwuc1_derefidx_vbum1=pwuc1_derefidx_vbum1_plus_vwum2 
    tay
    lda bram_heap_segment+$31,y
    clc
    adc free_size
    sta bram_heap_segment+$31,y
    lda bram_heap_segment+$31+1,y
    adc free_size+1
    sta bram_heap_segment+$31+1,y
    // bram_heap_segment.heapSize[s] -= free_size
    // [1042] bram_heap_free::$16 = bram_heap_free::s << 1 -- vbum1=vbum1_rol_1 
    asl bram_heap_free__16
    // [1043] ((unsigned int *)&bram_heap_segment+$2d)[bram_heap_free::$16] = ((unsigned int *)&bram_heap_segment+$2d)[bram_heap_free::$16] - bram_heap_free::free_size#0 -- pwuc1_derefidx_vbum1=pwuc1_derefidx_vbum1_minus_vwum2 
    ldy bram_heap_free__16
    lda bram_heap_segment+$2d,y
    sec
    sbc free_size
    sta bram_heap_segment+$2d,y
    lda bram_heap_segment+$2d+1,y
    sbc free_size+1
    sta bram_heap_segment+$2d+1,y
    // bram_heap_free::bank_set_bram2
    // BRAM = bank
    // [1044] BRAM = bram_heap_free::bram_bank#2 -- vbuz1=vbum2 
    lda bram_bank
    sta.z BRAM
    // bram_heap_free::@return
    // }
    // [1045] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_free__16
    free_index: .byte 0
    .label bram_heap_free__13 = bram_heap_coalesce.return
    .label bram_heap_free__14 = bram_heap_coalesce.return
    .label bram_heap_free__15 = bram_heap_dump_index_print.index
    bram_heap_free__16: .byte 0
  .segment Data
    .label bank_set_bram1_bank = printf_number_buffer.len
  .segment DataBramHeap
    free_size: .word 0
    free_offset: .word 0
    free_left_index: .byte 0
    .label free_right_index = bram_heap_coalesce.return
    bram_bank: .byte 0
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
// __mem() char bram_heap_alloc(__mem() char s, __mem() unsigned long size)
bram_heap_alloc: {
    // bram_heap_alloc::bank_get_bram1
    // return BRAM;
    // [1047] bram_heap_alloc::bank_set_bram2_bank#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_set_bram2_bank
    // bram_heap_alloc::@3
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [1048] bram_heap_alloc::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbum1=_deref_pbuc1 
    lda bram_heap_segment+$35
    sta bank_set_bram1_bank
    // bram_heap_alloc::bank_set_bram1
    // BRAM = bank
    // [1049] BRAM = bram_heap_alloc::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // bram_heap_alloc::@4
    // bram_heap_size_packed_t packed_size = bram_heap_alloc_size_get(size)
    // [1050] bram_heap_alloc_size_get::size = bram_heap_alloc::size
  // Adjust given size to 8 bytes boundary (shift right with 3 bits).
    // [1051] callexecute bram_heap_alloc_size_get  -- call_vprc1 
    jsr bram_heap_alloc_size_get
    // [1052] bram_heap_alloc::packed_size#0 = bram_heap_alloc_size_get::return
    // bram_heap_index_t free_index = bram_heap_find_best_fit(s, packed_size)
    // [1053] bram_heap_find_best_fit::s = bram_heap_alloc::s -- vbum1=vbum2 
    lda s
    sta bram_heap_find_best_fit.s
    // [1054] bram_heap_find_best_fit::requested_size = bram_heap_alloc::packed_size#0 -- vwum1=vwum2 
    lda packed_size
    sta bram_heap_find_best_fit.requested_size
    lda packed_size+1
    sta bram_heap_find_best_fit.requested_size+1
    // [1055] callexecute bram_heap_find_best_fit  -- call_vprc1 
    jsr bram_heap_find_best_fit
    // [1056] bram_heap_alloc::free_index#0 = bram_heap_find_best_fit::return -- vbum1=vbum2 
    lda bram_heap_find_best_fit.return
    sta free_index
    // if(free_index != BRAM_HEAP_NULL)
    // [1057] if(bram_heap_alloc::free_index#0==$ff) goto bram_heap_alloc::@2 -- vbum1_eq_vbuc1_then_la1 
    lda #$ff
    cmp free_index
    beq __b1
    // bram_heap_alloc::@1
    // bram_heap_allocate(s, free_index, packed_size)
    // [1058] bram_heap_allocate::s = bram_heap_alloc::s -- vbum1=vbum2 
    lda s
    sta bram_heap_allocate.s
    // [1059] bram_heap_allocate::free_index = bram_heap_alloc::free_index#0
    // [1060] bram_heap_allocate::required_size = bram_heap_alloc::packed_size#0 -- vwum1=vwum2 
    lda packed_size
    sta bram_heap_allocate.required_size
    lda packed_size+1
    sta bram_heap_allocate.required_size+1
    // [1061] callexecute bram_heap_allocate  -- call_vprc1 
    jsr bram_heap_allocate
    // heap_index = bram_heap_allocate(s, free_index, packed_size)
    // [1062] bram_heap_alloc::heap_index#1 = bram_heap_allocate::return
    // bram_heap_segment.freeSize[s] -= packed_size
    // [1063] bram_heap_alloc::$7 = bram_heap_alloc::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_alloc__7
    // [1064] ((unsigned int *)&bram_heap_segment+$31)[bram_heap_alloc::$7] = ((unsigned int *)&bram_heap_segment+$31)[bram_heap_alloc::$7] - bram_heap_alloc::packed_size#0 -- pwuc1_derefidx_vbum1=pwuc1_derefidx_vbum1_minus_vwum2 
    tay
    lda bram_heap_segment+$31,y
    sec
    sbc packed_size
    sta bram_heap_segment+$31,y
    lda bram_heap_segment+$31+1,y
    sbc packed_size+1
    sta bram_heap_segment+$31+1,y
    // bram_heap_segment.heapSize[s] += packed_size
    // [1065] bram_heap_alloc::$8 = bram_heap_alloc::s << 1 -- vbum1=vbum1_rol_1 
    asl bram_heap_alloc__8
    // [1066] ((unsigned int *)&bram_heap_segment+$2d)[bram_heap_alloc::$8] = ((unsigned int *)&bram_heap_segment+$2d)[bram_heap_alloc::$8] + bram_heap_alloc::packed_size#0 -- pwuc1_derefidx_vbum1=pwuc1_derefidx_vbum1_plus_vwum2 
    ldy bram_heap_alloc__8
    lda bram_heap_segment+$2d,y
    clc
    adc packed_size
    sta bram_heap_segment+$2d,y
    lda bram_heap_segment+$2d+1,y
    adc packed_size+1
    sta bram_heap_segment+$2d+1,y
    // [1067] phi from bram_heap_alloc::@1 to bram_heap_alloc::@2 [phi:bram_heap_alloc::@1->bram_heap_alloc::@2]
    // [1067] phi bram_heap_alloc::heap_index#4 = bram_heap_alloc::heap_index#1 [phi:bram_heap_alloc::@1->bram_heap_alloc::@2#0] -- register_copy 
    jmp __b2
    // [1067] phi from bram_heap_alloc::@4 to bram_heap_alloc::@2 [phi:bram_heap_alloc::@4->bram_heap_alloc::@2]
  __b1:
    // [1067] phi bram_heap_alloc::heap_index#4 = $ff [phi:bram_heap_alloc::@4->bram_heap_alloc::@2#0] -- vbum1=vbuc1 
    lda #$ff
    sta heap_index
    // bram_heap_alloc::@2
  __b2:
    // bram_heap_alloc::bank_set_bram2
    // BRAM = bank
    // [1068] BRAM = bram_heap_alloc::bank_set_bram2_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram2_bank
    sta.z BRAM
    // bram_heap_alloc::@5
    // return heap_index;
    // [1069] bram_heap_alloc::return = bram_heap_alloc::heap_index#4
    // bram_heap_alloc::@return
    // }
    // [1070] return 
    rts
  .segment DataBramHeap
    .label s = bram_heap_alloc__8
    .label size = bram_heap_dump_index_print.bram_heap_dump_index_print__10
    .label return = bram_heap_find_best_fit.best_index
    .label bram_heap_alloc__7 = bram_heap_dump_index_print.index
    bram_heap_alloc__8: .byte 0
  .segment Data
    .label bank_set_bram1_bank = printf_padding.i
  .segment DataBramHeap
    .label packed_size = bram_heap_alloc_size_get.bram_heap_alloc_size_get__1
    .label free_index = bram_heap_get_left.index
    .label heap_index = bram_heap_find_best_fit.best_index
  .segment Data
    .label bank_set_bram2_bank = printf_number_buffer.len
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
// __mem() char bram_heap_segment_init(__mem() char s, __mem() char bram_bank_floor, __zp($d) char *bram_ptr_floor, __mem() char bram_bank_ceil, __zp($f) char *bram_ptr_ceil)
bram_heap_segment_init: {
    .label bram_ptr_floor = $d
    .label bram_ptr_ceil = $f
    // bram_heap_segment.index_position[s] = 0
    // [1071] ((char *)&bram_heap_segment+1)[bram_heap_segment_init::s] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy s
    sta bram_heap_segment+1,y
    // bram_heap_segment.bram_bank_floor[s] = bram_bank_floor
    // [1072] ((char *)&bram_heap_segment+3)[bram_heap_segment_init::s] = bram_heap_segment_init::bram_bank_floor -- pbuc1_derefidx_vbum1=vbum2 
    // TODO initialize segment to all zero
    lda bram_bank_floor
    sta bram_heap_segment+3,y
    // bram_heap_segment.bram_ptr_floor[s] = bram_ptr_floor
    // [1073] bram_heap_segment_init::$13 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta bram_heap_segment_init__13
    // [1074] ((void **)&bram_heap_segment+5)[bram_heap_segment_init::$13] = (void *)bram_heap_segment_init::bram_ptr_floor -- qvoc1_derefidx_vbum1=pvoz2 
    tay
    lda.z bram_ptr_floor
    sta bram_heap_segment+5,y
    lda.z bram_ptr_floor+1
    sta bram_heap_segment+5+1,y
    // bram_heap_segment.bram_bank_ceil[s] = bram_bank_ceil
    // [1075] ((char *)&bram_heap_segment+$d)[bram_heap_segment_init::s] = bram_heap_segment_init::bram_bank_ceil -- pbuc1_derefidx_vbum1=vbum2 
    lda bram_bank_ceil
    ldy s
    sta bram_heap_segment+$d,y
    // bram_heap_segment.bram_ptr_ceil[s] = bram_ptr_ceil
    // [1076] bram_heap_segment_init::$14 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta bram_heap_segment_init__14
    // [1077] ((void **)&bram_heap_segment+$f)[bram_heap_segment_init::$14] = (void *)bram_heap_segment_init::bram_ptr_ceil -- qvoc1_derefidx_vbum1=pvoz2 
    tay
    lda.z bram_ptr_ceil
    sta bram_heap_segment+$f,y
    lda.z bram_ptr_ceil+1
    sta bram_heap_segment+$f+1,y
    // bram_heap_data_pack(bram_bank_floor, bram_ptr_floor)
    // [1078] bram_heap_data_pack::bram_bank = bram_heap_segment_init::bram_bank_floor
    // [1079] bram_heap_data_pack::bram_ptr = bram_heap_segment_init::bram_ptr_floor
    // [1080] callexecute bram_heap_data_pack  -- call_vprc1 
    jsr bram_heap_data_pack
    // [1081] bram_heap_segment_init::$0 = bram_heap_data_pack::return
    // bram_heap_segment.floor[s] = bram_heap_data_pack(bram_bank_floor, bram_ptr_floor)
    // [1082] bram_heap_segment_init::$15 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_segment_init__15
    // [1083] ((unsigned int *)&bram_heap_segment+9)[bram_heap_segment_init::$15] = bram_heap_segment_init::$0 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda bram_heap_segment_init__0
    sta bram_heap_segment+9,y
    lda bram_heap_segment_init__0+1
    sta bram_heap_segment+9+1,y
    // bram_heap_data_pack(bram_bank_ceil, bram_ptr_ceil)
    // [1084] bram_heap_data_pack::bram_bank = bram_heap_segment_init::bram_bank_ceil -- vbum1=vbum2 
    lda bram_bank_ceil
    sta bram_heap_data_pack.bram_bank
    // [1085] bram_heap_data_pack::bram_ptr = bram_heap_segment_init::bram_ptr_ceil -- pbuz1=pbuz2 
    lda.z bram_ptr_ceil
    sta.z bram_heap_data_pack.bram_ptr
    lda.z bram_ptr_ceil+1
    sta.z bram_heap_data_pack.bram_ptr+1
    // [1086] callexecute bram_heap_data_pack  -- call_vprc1 
    jsr bram_heap_data_pack
    // [1087] bram_heap_segment_init::$1 = bram_heap_data_pack::return
    // bram_heap_segment.ceil[s]  = bram_heap_data_pack(bram_bank_ceil, bram_ptr_ceil)
    // [1088] bram_heap_segment_init::$16 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_segment_init__16
    // [1089] ((unsigned int *)&bram_heap_segment+$13)[bram_heap_segment_init::$16] = bram_heap_segment_init::$1 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda bram_heap_segment_init__1
    sta bram_heap_segment+$13,y
    lda bram_heap_segment_init__1+1
    sta bram_heap_segment+$13+1,y
    // bram_heap_segment.heap_offset[s] = 0
    // [1090] bram_heap_segment_init::$17 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_segment_init__17
    // [1091] ((unsigned int *)&bram_heap_segment+$1d)[bram_heap_segment_init::$17] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy bram_heap_segment_init__17
    sta bram_heap_segment+$1d,y
    sta bram_heap_segment+$1d+1,y
    // bram_heap_size_packed_t free_size = bram_heap_segment.ceil[s]
    // [1092] bram_heap_segment_init::$18 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_segment_init__18
    // [1093] bram_heap_segment_init::free_size#0 = ((unsigned int *)&bram_heap_segment+$13)[bram_heap_segment_init::$18] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda bram_heap_segment+$13,y
    sta free_size
    lda bram_heap_segment+$13+1,y
    sta free_size+1
    // free_size -= bram_heap_segment.floor[s]
    // [1094] bram_heap_segment_init::$19 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_segment_init__19
    // [1095] bram_heap_segment_init::free_size#1 = bram_heap_segment_init::free_size#0 - ((unsigned int *)&bram_heap_segment+9)[bram_heap_segment_init::$19] -- vwum1=vwum1_minus_pwuc1_derefidx_vbum2 
    tay
    lda free_size
    sec
    sbc bram_heap_segment+9,y
    sta free_size
    lda free_size+1
    sbc bram_heap_segment+9+1,y
    sta free_size+1
    // bram_heap_segment.heapCount[s] = 0
    // [1096] bram_heap_segment_init::$20 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_segment_init__20
    // [1097] ((unsigned int *)&bram_heap_segment+$21)[bram_heap_segment_init::$20] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy bram_heap_segment_init__20
    sta bram_heap_segment+$21,y
    sta bram_heap_segment+$21+1,y
    // bram_heap_segment.freeCount[s] = 0
    // [1098] bram_heap_segment_init::$21 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_segment_init__21
    // [1099] ((unsigned int *)&bram_heap_segment+$25)[bram_heap_segment_init::$21] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy bram_heap_segment_init__21
    sta bram_heap_segment+$25,y
    sta bram_heap_segment+$25+1,y
    // bram_heap_segment.idleCount[s] = 0
    // [1100] bram_heap_segment_init::$22 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_segment_init__22
    // [1101] ((unsigned int *)&bram_heap_segment+$29)[bram_heap_segment_init::$22] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy bram_heap_segment_init__22
    sta bram_heap_segment+$29,y
    sta bram_heap_segment+$29+1,y
    // bram_heap_segment.heap_list[s] = BRAM_HEAP_NULL
    // [1102] ((char *)&bram_heap_segment+$17)[bram_heap_segment_init::s] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    lda #$ff
    ldy s
    sta bram_heap_segment+$17,y
    // bram_heap_segment.idle_list[s] = BRAM_HEAP_NULL
    // [1103] ((char *)&bram_heap_segment+$1b)[bram_heap_segment_init::s] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta bram_heap_segment+$1b,y
    // bram_heap_segment.free_list[s] = BRAM_HEAP_NULL
    // [1104] ((char *)&bram_heap_segment+$19)[bram_heap_segment_init::s] = $ff -- pbuc1_derefidx_vbum1=vbuc2 
    sta bram_heap_segment+$19,y
    // bram_heap_segment_init::bank_get_bram1
    // return BRAM;
    // [1105] bram_heap_segment_init::bank_get_bram1_return#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_get_bram1_return
    // bram_heap_segment_init::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [1106] bram_heap_segment_init::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbum1=_deref_pbuc1 
    lda bram_heap_segment+$35
    sta bank_set_bram1_bank
    // bram_heap_segment_init::bank_set_bram1
    // BRAM = bank
    // [1107] BRAM = bram_heap_segment_init::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // bram_heap_segment_init::@2
    // bram_heap_index_t free_index = bram_heap_index_add(s)
    // [1108] bram_heap_index_add::s = bram_heap_segment_init::s -- vbum1=vbum2 
    tya
    sta bram_heap_index_add.s
    // [1109] callexecute bram_heap_index_add  -- call_vprc1 
    jsr bram_heap_index_add
    // [1110] bram_heap_segment_init::free_index#0 = bram_heap_index_add::return
    // bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, free_index)
    // [1111] bram_heap_list_insert_at::s = bram_heap_segment_init::s -- vbum1=vbum2 
    lda s
    sta bram_heap_list_insert_at.s
    // [1112] bram_heap_list_insert_at::list = ((char *)&bram_heap_segment+$19)[bram_heap_segment_init::s] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda bram_heap_segment+$19,y
    sta bram_heap_list_insert_at.list
    // [1113] bram_heap_list_insert_at::index = bram_heap_segment_init::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_list_insert_at.index
    // [1114] bram_heap_list_insert_at::at = bram_heap_segment_init::free_index#0 -- vbum1=vbum2 
    lda free_index
    sta bram_heap_list_insert_at.at
    // [1115] callexecute bram_heap_list_insert_at  -- call_vprc1 
    jsr bram_heap_list_insert_at
    // free_index = bram_heap_list_insert_at(s, bram_heap_segment.free_list[s], free_index, free_index)
    // [1116] bram_heap_segment_init::free_index#1 = bram_heap_list_insert_at::return -- vbum1=vbum2 
    lda bram_heap_list_insert_at.return
    sta free_index_1
    // bram_heap_set_data_packed(s, free_index, bram_heap_segment.floor[s])
    // [1117] bram_heap_segment_init::$23 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_segment_init__23
    // [1118] bram_heap_set_data_packed::s = bram_heap_segment_init::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_data_packed.s
    // [1119] bram_heap_set_data_packed::index = bram_heap_segment_init::free_index#1 -- vbum1=vbum2 
    lda free_index_1
    sta bram_heap_set_data_packed.index
    // [1120] bram_heap_set_data_packed::data_packed = ((unsigned int *)&bram_heap_segment+9)[bram_heap_segment_init::$23] -- vwum1=pwuc1_derefidx_vbum2 
    ldy bram_heap_segment_init__23
    lda bram_heap_segment+9,y
    sta bram_heap_set_data_packed.data_packed
    lda bram_heap_segment+9+1,y
    sta bram_heap_set_data_packed.data_packed+1
    // [1121] callexecute bram_heap_set_data_packed  -- call_vprc1 
    jsr bram_heap_set_data_packed
    // bram_heap_set_size_packed(s, free_index, free_size)
    // [1122] bram_heap_set_size_packed::s = bram_heap_segment_init::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_size_packed.s
    // [1123] bram_heap_set_size_packed::index = bram_heap_segment_init::free_index#1 -- vbum1=vbum2 
    lda free_index_1
    sta bram_heap_set_size_packed.index
    // [1124] bram_heap_set_size_packed::size_packed = bram_heap_segment_init::free_size#1 -- vwum1=vwum2 
    lda free_size
    sta bram_heap_set_size_packed.size_packed
    lda free_size+1
    sta bram_heap_set_size_packed.size_packed+1
    // [1125] callexecute bram_heap_set_size_packed  -- call_vprc1 
    jsr bram_heap_set_size_packed
    // bram_heap_set_free(s, free_index)
    // [1126] bram_heap_set_free::s = bram_heap_segment_init::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_free.s
    // [1127] bram_heap_set_free::index = bram_heap_segment_init::free_index#1 -- vbum1=vbum2 
    lda free_index_1
    sta bram_heap_set_free.index
    // [1128] callexecute bram_heap_set_free  -- call_vprc1 
    jsr bram_heap_set_free
    // bram_heap_set_next(s, free_index, free_index)
    // [1129] bram_heap_set_next::s = bram_heap_segment_init::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_next.s
    // [1130] bram_heap_set_next::index = bram_heap_segment_init::free_index#1 -- vbum1=vbum2 
    lda free_index_1
    sta bram_heap_set_next.index
    // [1131] bram_heap_set_next::next = bram_heap_segment_init::free_index#1 -- vbum1=vbum2 
    lda free_index_1
    sta bram_heap_set_next.next
    // [1132] callexecute bram_heap_set_next  -- call_vprc1 
    jsr bram_heap_set_next
    // bram_heap_set_prev(s, free_index, free_index)
    // [1133] bram_heap_set_prev::s = bram_heap_segment_init::s -- vbum1=vbum2 
    lda s
    sta bram_heap_set_prev.s
    // [1134] bram_heap_set_prev::index = bram_heap_segment_init::free_index#1 -- vbum1=vbum2 
    lda free_index_1
    sta bram_heap_set_prev.index
    // [1135] bram_heap_set_prev::prev = bram_heap_segment_init::free_index#1 -- vbum1=vbum2 
    lda free_index_1
    sta bram_heap_set_prev.prev
    // [1136] callexecute bram_heap_set_prev  -- call_vprc1 
    jsr bram_heap_set_prev
    // bram_heap_segment.freeCount[s]++;
    // [1137] bram_heap_segment_init::$25 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_segment_init__25
    // [1138] ((unsigned int *)&bram_heap_segment+$25)[bram_heap_segment_init::$25] = ++ ((unsigned int *)&bram_heap_segment+$25)[bram_heap_segment_init::$25] -- pwuc1_derefidx_vbum1=_inc_pwuc1_derefidx_vbum1 
    tax
    inc bram_heap_segment+$25,x
    bne !+
    inc bram_heap_segment+$25+1,x
  !:
    // bram_heap_segment.free_list[s] = free_index
    // [1139] ((char *)&bram_heap_segment+$19)[bram_heap_segment_init::s] = bram_heap_segment_init::free_index#1 -- pbuc1_derefidx_vbum1=vbum2 
    lda free_index_1
    ldy s
    sta bram_heap_segment+$19,y
    // bram_heap_segment.freeSize[s] = free_size
    // [1140] bram_heap_segment_init::$26 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta bram_heap_segment_init__26
    // [1141] ((unsigned int *)&bram_heap_segment+$31)[bram_heap_segment_init::$26] = bram_heap_segment_init::free_size#1 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda free_size
    sta bram_heap_segment+$31,y
    lda free_size+1
    sta bram_heap_segment+$31+1,y
    // bram_heap_segment.heapSize[s] = 0
    // [1142] bram_heap_segment_init::$27 = bram_heap_segment_init::s << 1 -- vbum1=vbum2_rol_1 
    lda s
    asl
    sta bram_heap_segment_init__27
    // [1143] ((unsigned int *)&bram_heap_segment+$2d)[bram_heap_segment_init::$27] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy bram_heap_segment_init__27
    sta bram_heap_segment+$2d,y
    sta bram_heap_segment+$2d+1,y
    // bram_heap_segment_init::bank_set_bram2
    // BRAM = bank
    // [1144] BRAM = bram_heap_segment_init::bank_get_bram1_return#0 -- vbuz1=vbum2 
    lda bank_get_bram1_return
    sta.z BRAM
    // bram_heap_segment_init::@3
    // return s;
    // [1145] bram_heap_segment_init::return = bram_heap_segment_init::s
    // bram_heap_segment_init::@return
    // }
    // [1146] return 
    rts
  .segment DataBramHeap
    .label s = return
    .label bram_bank_floor = bram_heap_dump_index_print.bram_heap_dump_index_print__6
    .label bram_bank_ceil = bram_heap_find_best_fit.best_index
    return: .byte 0
    .label bram_heap_segment_init__0 = bram_heap_dump_index_print.count
    .label bram_heap_segment_init__1 = bram_heap_dump_index_print.count
    .label bram_heap_segment_init__13 = bram_heap_dump_index_print.index
    .label bram_heap_segment_init__14 = bram_heap_dump_index_print.index
    .label bram_heap_segment_init__15 = bram_heap_dump_index_print.index
    .label bram_heap_segment_init__16 = bram_heap_dump_index_print.index
    .label bram_heap_segment_init__17 = bram_heap_dump_index_print.index
    .label bram_heap_segment_init__18 = bram_heap_dump_index_print.index
    .label bram_heap_segment_init__19 = bram_heap_dump_index_print.index
    .label bram_heap_segment_init__20 = bram_heap_dump_index_print.index
    .label bram_heap_segment_init__21 = bram_heap_dump_index_print.index
    .label bram_heap_segment_init__22 = bram_heap_dump_index_print.index
    .label bram_heap_segment_init__23 = bram_heap_find_best_fit.best_index
    .label bram_heap_segment_init__25 = bram_heap_dump_index_print.index
    .label bram_heap_segment_init__26 = bram_heap_dump_index_print.index
    .label bram_heap_segment_init__27 = bram_heap_dump_index_print.index
    free_size: .word 0
  .segment Data
    .label bank_get_bram1_return = printf_number_buffer.len
    .label bank_set_bram1_bank = printf_number_buffer.len
  .segment DataBramHeap
    .label free_index = bram_heap_index_add.index
    .label free_index_1 = bram_heap_dump_index_print.end_index
}
.segment CodeBramHeap
  // bram_heap_bram_bank_init
// void bram_heap_bram_bank_init(__mem() char bram_bank)
bram_heap_bram_bank_init: {
    // bram_heap_segment.bram_bank = bram_bank
    // [1147] *((char *)&bram_heap_segment+$35) = bram_heap_bram_bank_init::bram_bank -- _deref_pbuc1=vbum1 
    lda bram_bank
    sta bram_heap_segment+$35
    // bram_heap_segment.segments = BRAM_HEAP_SEGMENTS
    // [1148] *((char *)&bram_heap_segment) = 2 -- _deref_pbuc1=vbuc2 
    lda #2
    sta bram_heap_segment
    // bram_heap_bram_bank_init::bank_get_bram1
    // return BRAM;
    // [1149] bram_heap_bram_bank_init::bank_get_bram1_return#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_get_bram1_return
    // bram_heap_bram_bank_init::@1
    // bank_set_bram(bram_heap_segment.bram_bank)
    // [1150] bram_heap_bram_bank_init::bank_set_bram1_bank#0 = *((char *)&bram_heap_segment+$35) -- vbum1=_deref_pbuc1 
    lda bram_heap_segment+$35
    sta bank_set_bram1_bank
    // bram_heap_bram_bank_init::bank_set_bram1
    // BRAM = bank
    // [1151] BRAM = bram_heap_bram_bank_init::bank_set_bram1_bank#0 -- vbuz1=vbum2 
    sta.z BRAM
    // [1152] phi from bram_heap_bram_bank_init::bank_set_bram1 to bram_heap_bram_bank_init::@2 [phi:bram_heap_bram_bank_init::bank_set_bram1->bram_heap_bram_bank_init::@2]
    // bram_heap_bram_bank_init::@2
    // memset((void*)0xA000, 0, 0x2000)
    // [1153] callexecute memset  -- call_vprc1 
    jsr memset
    // bram_heap_bram_bank_init::bank_set_bram2
    // BRAM = bank
    // [1154] BRAM = bram_heap_bram_bank_init::bank_get_bram1_return#0 -- vbuz1=vbum2 
    lda bank_get_bram1_return
    sta.z BRAM
    // bram_heap_bram_bank_init::@return
    // }
    // [1155] return 
    rts
  .segment DataBramHeap
    .label bram_bank = bram_heap_dump_index_print.index
  .segment Data
    .label bank_get_bram1_return = printf_number_buffer.len
    .label bank_set_bram1_bank = printf_number_buffer.len
}
.segment Code
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(__zp($12) void (*putc)(char), __mem() struct printf_buffer_number buffer, __mem() char format_min_length, __mem() char format_justify_left, __mem() char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, __mem() char format_radix)
printf_number_buffer: {
    .label putc = $12
    // if(format_min_length)
    // [1156] if(0==printf_number_buffer::format_min_length) goto printf_number_buffer::@1 -- 0_eq_vbum1_then_la1 
    lda format_min_length
    beq __b6
    // printf_number_buffer::@6
    // strlen(buffer.digits)
    // [1157] strlen::str = (char *)&printf_number_buffer::buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS -- pbuz1=pbuc1 
    lda #<buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z strlen.str
    lda #>buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z strlen.str+1
    // [1158] callexecute strlen  -- call_vprc1 
    jsr strlen
    // [1159] printf_number_buffer::$19 = strlen::return
    // signed char len = (signed char)strlen(buffer.digits)
    // [1160] printf_number_buffer::len#0 = (signed char)printf_number_buffer::$19 -- vbsm1=_sbyte_vwum2 
    // There is a minimum length - work out the padding
    lda printf_number_buffer__19
    sta len
    // if(buffer.sign)
    // [1161] if(0==*((char *)&printf_number_buffer::buffer)) goto printf_number_buffer::@13 -- 0_eq__deref_pbuc1_then_la1 
    lda buffer
    beq __b13
    // printf_number_buffer::@7
    // len++;
    // [1162] printf_number_buffer::len#1 = ++ printf_number_buffer::len#0 -- vbsm1=_inc_vbsm1 
    inc len
    // [1163] phi from printf_number_buffer::@6 printf_number_buffer::@7 to printf_number_buffer::@13 [phi:printf_number_buffer::@6/printf_number_buffer::@7->printf_number_buffer::@13]
    // [1163] phi printf_number_buffer::len#2 = printf_number_buffer::len#0 [phi:printf_number_buffer::@6/printf_number_buffer::@7->printf_number_buffer::@13#0] -- register_copy 
    // printf_number_buffer::@13
  __b13:
    // padding = (signed char)format_min_length - len
    // [1164] printf_number_buffer::padding#1 = (signed char)printf_number_buffer::format_min_length - printf_number_buffer::len#2 -- vbsm1=vbsm2_minus_vbsm1 
    lda format_min_length
    sec
    sbc padding
    sta padding
    // if(padding<0)
    // [1165] if(printf_number_buffer::padding#1>=0) goto printf_number_buffer::@19 -- vbsm1_ge_0_then_la1 
    cmp #0
    bpl __b1
    // [1167] phi from printf_number_buffer printf_number_buffer::@13 to printf_number_buffer::@1 [phi:printf_number_buffer/printf_number_buffer::@13->printf_number_buffer::@1]
  __b6:
    // [1167] phi printf_number_buffer::padding#10 = 0 [phi:printf_number_buffer/printf_number_buffer::@13->printf_number_buffer::@1#0] -- vbsm1=vbsc1 
    lda #0
    sta padding
    // [1166] phi from printf_number_buffer::@13 to printf_number_buffer::@19 [phi:printf_number_buffer::@13->printf_number_buffer::@19]
    // printf_number_buffer::@19
    // [1167] phi from printf_number_buffer::@19 to printf_number_buffer::@1 [phi:printf_number_buffer::@19->printf_number_buffer::@1]
    // [1167] phi printf_number_buffer::padding#10 = printf_number_buffer::padding#1 [phi:printf_number_buffer::@19->printf_number_buffer::@1#0] -- register_copy 
    // printf_number_buffer::@1
  __b1:
    // if(!format_justify_left && !format_zero_padding && padding)
    // [1168] if(0!=printf_number_buffer::format_justify_left) goto printf_number_buffer::@2 -- 0_neq_vbum1_then_la1 
    lda format_justify_left
    bne __b2
    // printf_number_buffer::@15
    // [1169] if(0==printf_number_buffer::format_zero_padding) goto printf_number_buffer::@14 -- 0_eq_vbum1_then_la1 
    lda format_zero_padding
    beq __b14
    // printf_number_buffer::@2
  __b2:
    // if(buffer.sign)
    // [1170] if(0==*((char *)&printf_number_buffer::buffer)) goto printf_number_buffer::@3 -- 0_eq__deref_pbuc1_then_la1 
    lda buffer
    beq __b3
    // printf_number_buffer::@9
    // putc(buffer.sign)
    // [1171] stackpush(char) = *((char *)&printf_number_buffer::buffer) -- _stackpushbyte_=_deref_pbuc1 
    pha
    // [1172] callexecute *printf_number_buffer::putc  -- call__deref_pprz1 
    jsr icall178
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_number_buffer::@3
  __b3:
    // if(format_zero_padding && padding)
    // [1174] if(0==printf_number_buffer::format_zero_padding) goto printf_number_buffer::@4 -- 0_eq_vbum1_then_la1 
    lda format_zero_padding
    beq __b4
    // printf_number_buffer::@16
    // [1175] if(0==printf_number_buffer::padding#10) goto printf_number_buffer::@4 -- 0_eq_vbsm1_then_la1 
    lda padding
    cmp #0
    beq __b4
    // printf_number_buffer::@10
    // printf_padding(putc, '0',(char)padding)
    // [1176] printf_padding::putc = printf_number_buffer::putc -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [1177] printf_padding::pad = '0'pm -- vbum1=vbuc1 
    lda #'0'
    sta printf_padding.pad
    // [1178] printf_padding::length = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [1179] callexecute printf_padding  -- call_vprc1 
    jsr printf_padding
    // printf_number_buffer::@4
  __b4:
    // if(format_upper_case)
    // [1180] if(0==printf_number_buffer::format_upper_case) goto printf_number_buffer::@5 -- 0_eq_vbum1_then_la1 
    lda format_upper_case
    beq __b5
    // [1181] phi from printf_number_buffer::@4 to printf_number_buffer::@11 [phi:printf_number_buffer::@4->printf_number_buffer::@11]
    // printf_number_buffer::@11
    // strupr(buffer.digits)
    // [1182] callexecute strupr  -- call_vprc1 
    jsr strupr
    // printf_number_buffer::@5
  __b5:
    // printf_str(putc, buffer.digits)
    // [1183] printf_str::putc = printf_number_buffer::putc -- pprz1=pprz2 
    lda.z putc
    sta.z printf_str.putc
    lda.z putc+1
    sta.z printf_str.putc+1
    // [1184] printf_str::s = (char *)&printf_number_buffer::buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS -- pbuz1=pbuc1 
    lda #<buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.s
    lda #>buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.s+1
    // [1185] callexecute printf_str  -- call_vprc1 
    jsr printf_str
    // if(format_justify_left && !format_zero_padding && padding)
    // [1186] if(0==printf_number_buffer::format_justify_left) goto printf_number_buffer::@return -- 0_eq_vbum1_then_la1 
    lda format_justify_left
    beq __breturn
    // printf_number_buffer::@18
    // [1187] if(0==printf_number_buffer::format_zero_padding) goto printf_number_buffer::@17 -- 0_eq_vbum1_then_la1 
    lda format_zero_padding
    beq __b17
    // printf_number_buffer::@return
  __breturn:
    // }
    // [1188] return 
    rts
    // printf_number_buffer::@17
  __b17:
    // if(format_justify_left && !format_zero_padding && padding)
    // [1189] if(0==printf_number_buffer::padding#10) goto printf_number_buffer::@return -- 0_eq_vbsm1_then_la1 
    lda padding
    cmp #0
    beq __breturn
    // printf_number_buffer::@12
    // printf_padding(putc, ' ',(char)padding)
    // [1190] printf_padding::putc = printf_number_buffer::putc -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [1191] printf_padding::pad = ' 'pm -- vbum1=vbuc1 
    lda #' '
    sta printf_padding.pad
    // [1192] printf_padding::length = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [1193] callexecute printf_padding  -- call_vprc1 
    jsr printf_padding
    rts
    // printf_number_buffer::@14
  __b14:
    // if(!format_justify_left && !format_zero_padding && padding)
    // [1194] if(0==printf_number_buffer::padding#10) goto printf_number_buffer::@2 -- 0_eq_vbsm1_then_la1 
    lda padding
    cmp #0
    beq __b2
    // printf_number_buffer::@8
    // printf_padding(putc, ' ',(char)padding)
    // [1195] printf_padding::putc = printf_number_buffer::putc -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [1196] printf_padding::pad = ' 'pm -- vbum1=vbuc1 
    lda #' '
    sta printf_padding.pad
    // [1197] printf_padding::length = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [1198] callexecute printf_padding  -- call_vprc1 
    jsr printf_padding
    jmp __b2
    // Outside Flow
  icall178:
    jmp (putc)
  .segment Data
    buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
    .label format_min_length = printf_uchar.format_min_length
    .label format_justify_left = printf_uchar.format_justify_left
    .label format_sign_always = printf_uchar.format_sign_always
    .label format_zero_padding = printf_uchar.format_zero_padding
    .label format_upper_case = printf_uchar.format_upper_case
    .label format_radix = printf_uchar.format_radix
    .label printf_number_buffer__19 = strlen.len
    len: .byte 0
    .label padding = len
}
.segment Code
  // printf_uchar
// Print an unsigned char using a specific format
// void printf_uchar(__zp($12) void (*putc)(char), __mem() char uvalue, __mem() char format_min_length, __mem() char format_justify_left, __mem() char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, __mem() char format_radix)
printf_uchar: {
    .label putc = $12
    // format_sign_always?'+':0
    // [1199] if(0!=printf_uchar::format_sign_always) goto printf_uchar::@1 -- 0_neq_vbum1_then_la1 
    lda format_sign_always
    bne __b1
    // [1201] phi from printf_uchar to printf_uchar::@2 [phi:printf_uchar->printf_uchar::@2]
    // [1201] phi printf_uchar::$2 = 0 [phi:printf_uchar->printf_uchar::@2#0] -- vbum1=vbuc1 
    lda #0
    sta printf_uchar__2
    jmp __b2
    // [1200] phi from printf_uchar to printf_uchar::@1 [phi:printf_uchar->printf_uchar::@1]
    // printf_uchar::@1
  __b1:
    // format_sign_always?'+':0
    // [1201] phi from printf_uchar::@1 to printf_uchar::@2 [phi:printf_uchar::@1->printf_uchar::@2]
    // [1201] phi printf_uchar::$2 = '+'pm [phi:printf_uchar::@1->printf_uchar::@2#0] -- vbum1=vbuc1 
    lda #'+'
    sta printf_uchar__2
    // printf_uchar::@2
  __b2:
    // printf_buffer.sign = format_sign_always?'+':0
    // [1202] *((char *)&printf_buffer) = printf_uchar::$2 -- _deref_pbuc1=vbum1 
    // Handle any sign
    lda printf_uchar__2
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format_radix)
    // [1203] uctoa::value = printf_uchar::uvalue
  // Format number into buffer
    // [1204] uctoa::buffer = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z uctoa.buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z uctoa.buffer+1
    // [1205] uctoa::radix = printf_uchar::format_radix -- vbum1=vbum2 
    lda format_radix
    sta uctoa.radix
    // [1206] callexecute uctoa  -- call_vprc1 
    jsr uctoa
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [1207] printf_number_buffer::putc = printf_uchar::putc
  // Print using format
    // [1208] *(&printf_number_buffer::buffer) = memcpy(*(&printf_buffer), struct printf_buffer_number, SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER
  !:
    lda printf_buffer-1,y
    sta printf_number_buffer.buffer-1,y
    dey
    bne !-
    // [1209] printf_number_buffer::format_min_length = printf_uchar::format_min_length
    // [1210] printf_number_buffer::format_justify_left = printf_uchar::format_justify_left
    // [1211] printf_number_buffer::format_sign_always = printf_uchar::format_sign_always
    // [1212] printf_number_buffer::format_zero_padding = printf_uchar::format_zero_padding
    // [1213] printf_number_buffer::format_upper_case = printf_uchar::format_upper_case
    // [1214] printf_number_buffer::format_radix = printf_uchar::format_radix
    // [1215] callexecute printf_number_buffer  -- call_vprc1 
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [1216] return 
    rts
  .segment Data
    uvalue: .byte 0
    format_min_length: .byte 0
    format_justify_left: .byte 0
    format_sign_always: .byte 0
    format_zero_padding: .byte 0
    format_upper_case: .byte 0
    format_radix: .byte 0
    .label printf_uchar__2 = printf_number_buffer.len
}
.segment Code
  // printf_uint
// Print an unsigned int using a specific format
// void printf_uint(__zp($12) void (*putc)(char), __mem() unsigned int uvalue, __mem() char format_min_length, __mem() char format_justify_left, __mem() char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, __mem() char format_radix)
printf_uint: {
    .label putc = $12
    // format_sign_always?'+':0
    // [1217] if(0!=printf_uint::format_sign_always) goto printf_uint::@1 -- 0_neq_vbum1_then_la1 
    lda format_sign_always
    bne __b1
    // [1219] phi from printf_uint to printf_uint::@2 [phi:printf_uint->printf_uint::@2]
    // [1219] phi printf_uint::$2 = 0 [phi:printf_uint->printf_uint::@2#0] -- vbum1=vbuc1 
    lda #0
    sta printf_uint__2
    jmp __b2
    // [1218] phi from printf_uint to printf_uint::@1 [phi:printf_uint->printf_uint::@1]
    // printf_uint::@1
  __b1:
    // format_sign_always?'+':0
    // [1219] phi from printf_uint::@1 to printf_uint::@2 [phi:printf_uint::@1->printf_uint::@2]
    // [1219] phi printf_uint::$2 = '+'pm [phi:printf_uint::@1->printf_uint::@2#0] -- vbum1=vbuc1 
    lda #'+'
    sta printf_uint__2
    // printf_uint::@2
  __b2:
    // printf_buffer.sign = format_sign_always?'+':0
    // [1220] *((char *)&printf_buffer) = printf_uint::$2 -- _deref_pbuc1=vbum1 
    // void printf_uint(void (*putc)(char), unsigned int uvalue, struct printf_format_number format) {
    // Handle any sign
    lda printf_uint__2
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format_radix)
    // [1221] utoa::value = printf_uint::uvalue
  // Format number into buffer
    // [1222] utoa::buffer = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z utoa.buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z utoa.buffer+1
    // [1223] utoa::radix = printf_uint::format_radix -- vbum1=vbum2 
    lda format_radix
    sta utoa.radix
    // [1224] callexecute utoa  -- call_vprc1 
    jsr utoa
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [1225] printf_number_buffer::putc = printf_uint::putc
  // Print using format
    // [1226] *(&printf_number_buffer::buffer) = memcpy(*(&printf_buffer), struct printf_buffer_number, SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER
  !:
    lda printf_buffer-1,y
    sta printf_number_buffer.buffer-1,y
    dey
    bne !-
    // [1227] printf_number_buffer::format_min_length = printf_uint::format_min_length
    // [1228] printf_number_buffer::format_justify_left = printf_uint::format_justify_left
    // [1229] printf_number_buffer::format_sign_always = printf_uint::format_sign_always
    // [1230] printf_number_buffer::format_zero_padding = printf_uint::format_zero_padding
    // [1231] printf_number_buffer::format_upper_case = printf_uint::format_upper_case
    // [1232] printf_number_buffer::format_radix = printf_uint::format_radix
    // [1233] callexecute printf_number_buffer  -- call_vprc1 
    jsr printf_number_buffer
    // printf_uint::@return
    // }
    // [1234] return 
    rts
  .segment Data
    .label uvalue = strlen.len
    .label format_min_length = printf_uchar.format_min_length
    .label format_justify_left = printf_uchar.format_justify_left
    .label format_sign_always = printf_uchar.format_sign_always
    .label format_zero_padding = printf_uchar.format_zero_padding
    .label format_upper_case = printf_uchar.format_upper_case
    .label format_radix = printf_uchar.format_radix
    .label printf_uint__2 = printf_number_buffer.len
}
.segment Code
  // printf_ulong
// Print an unsigned int using a specific format
// void printf_ulong(__zp($12) void (*putc)(char), __mem() unsigned long uvalue, __mem() char format_min_length, __mem() char format_justify_left, __mem() char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, __mem() char format_radix)
printf_ulong: {
    .label putc = $12
    // format_sign_always?'+':0
    // [1235] if(0!=printf_ulong::format_sign_always) goto printf_ulong::@1 -- 0_neq_vbum1_then_la1 
    lda format_sign_always
    bne __b1
    // [1237] phi from printf_ulong to printf_ulong::@2 [phi:printf_ulong->printf_ulong::@2]
    // [1237] phi printf_ulong::$2 = 0 [phi:printf_ulong->printf_ulong::@2#0] -- vbum1=vbuc1 
    lda #0
    sta printf_ulong__2
    jmp __b2
    // [1236] phi from printf_ulong to printf_ulong::@1 [phi:printf_ulong->printf_ulong::@1]
    // printf_ulong::@1
  __b1:
    // format_sign_always?'+':0
    // [1237] phi from printf_ulong::@1 to printf_ulong::@2 [phi:printf_ulong::@1->printf_ulong::@2]
    // [1237] phi printf_ulong::$2 = '+'pm [phi:printf_ulong::@1->printf_ulong::@2#0] -- vbum1=vbuc1 
    lda #'+'
    sta printf_ulong__2
    // printf_ulong::@2
  __b2:
    // printf_buffer.sign = format_sign_always?'+':0
    // [1238] *((char *)&printf_buffer) = printf_ulong::$2 -- _deref_pbuc1=vbum1 
    // Handle any sign
    lda printf_ulong__2
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format_radix)
    // [1239] ultoa::value = printf_ulong::uvalue
  // Format number into buffer
    // [1240] ultoa::buffer = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z ultoa.buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z ultoa.buffer+1
    // [1241] ultoa::radix = printf_ulong::format_radix -- vbum1=vbum2 
    lda format_radix
    sta ultoa.radix
    // [1242] callexecute ultoa  -- call_vprc1 
    jsr ultoa
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [1243] printf_number_buffer::putc = printf_ulong::putc
  // Print using format
    // [1244] *(&printf_number_buffer::buffer) = memcpy(*(&printf_buffer), struct printf_buffer_number, SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER
  !:
    lda printf_buffer-1,y
    sta printf_number_buffer.buffer-1,y
    dey
    bne !-
    // [1245] printf_number_buffer::format_min_length = printf_ulong::format_min_length
    // [1246] printf_number_buffer::format_justify_left = printf_ulong::format_justify_left
    // [1247] printf_number_buffer::format_sign_always = printf_ulong::format_sign_always
    // [1248] printf_number_buffer::format_zero_padding = printf_ulong::format_zero_padding
    // [1249] printf_number_buffer::format_upper_case = printf_ulong::format_upper_case
    // [1250] printf_number_buffer::format_radix = printf_ulong::format_radix
    // [1251] callexecute printf_number_buffer  -- call_vprc1 
    jsr printf_number_buffer
    // printf_ulong::@return
    // }
    // [1252] return 
    rts
  .segment Data
    uvalue: .dword 0
    .label format_min_length = printf_uchar.format_min_length
    .label format_justify_left = printf_uchar.format_justify_left
    .label format_sign_always = printf_uchar.format_sign_always
    .label format_zero_padding = printf_uchar.format_zero_padding
    .label format_upper_case = printf_uchar.format_upper_case
    .label format_radix = printf_uchar.format_radix
    .label printf_ulong__2 = printf_number_buffer.len
}
.segment Code
  // printf_padding
// Print a padding char a number of times
// void printf_padding(__zp(7) void (*putc)(char), __mem() char pad, __mem() char length)
printf_padding: {
    .label putc = 7
    // [1254] phi from printf_padding to printf_padding::@1 [phi:printf_padding->printf_padding::@1]
    // [1254] phi printf_padding::i#2 = 0 [phi:printf_padding->printf_padding::@1#0] -- vbum1=vbuc1 
    lda #0
    sta i
    // printf_padding::@1
  __b1:
    // for(char i=0;i<length; i++)
    // [1255] if(printf_padding::i#2<printf_padding::length) goto printf_padding::@2 -- vbum1_lt_vbum2_then_la1 
    lda i
    cmp length
    bcc __b2
    // printf_padding::@return
    // }
    // [1256] return 
    rts
    // printf_padding::@2
  __b2:
    // putc(pad)
    // [1257] stackpush(char) = printf_padding::pad -- _stackpushbyte_=vbum1 
    lda pad
    pha
    // [1258] callexecute *printf_padding::putc  -- call__deref_pprz1 
    jsr icall190
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_padding::@3
    // for(char i=0;i<length; i++)
    // [1260] printf_padding::i#1 = ++ printf_padding::i#2 -- vbum1=_inc_vbum1 
    inc i
    // [1254] phi from printf_padding::@3 to printf_padding::@1 [phi:printf_padding::@3->printf_padding::@1]
    // [1254] phi printf_padding::i#2 = printf_padding::i#1 [phi:printf_padding::@3->printf_padding::@1#0] -- register_copy 
    jmp __b1
    // Outside Flow
  icall190:
    jmp (putc)
  .segment Data
    .label pad = uctoa.digit
    .label length = printf_uchar.uvalue
    i: .byte 0
}
.segment Code
  // printf_str
/// Print a NUL-terminated string
// void printf_str(__zp(5) void (*putc)(char), __zp(7) const char *s)
printf_str: {
    .label putc = 5
    .label s = 7
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [1262] printf_str::c#1 = *printf_str::s -- vbum1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta c
    // [1263] printf_str::s = ++ printf_str::s -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [1264] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbum1_then_la1 
    lda c
    bne __b2
    // printf_str::@return
    // }
    // [1265] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [1266] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbum1 
    lda c
    pha
    // [1267] callexecute *printf_str::putc  -- call__deref_pprz1 
    jsr icall191
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
    // Outside Flow
  icall191:
    jmp (putc)
  .segment Data
    .label c = printf_padding.i
}
.segment Code
  // screenlayer
// --- layer management in VERA ---
// void screenlayer(char layer, __mem() char mapbase, __mem() char config)
screenlayer: {
    .const layer = 1
    .label y = $11
    // __mem char vera_dc_hscale_temp = *VERA_DC_HSCALE
    // [1269] screenlayer::vera_dc_hscale_temp#0 = *VERA_DC_HSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_HSCALE
    sta vera_dc_hscale_temp
    // __mem char vera_dc_vscale_temp = *VERA_DC_VSCALE
    // [1270] screenlayer::vera_dc_vscale_temp#0 = *VERA_DC_VSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_VSCALE
    sta vera_dc_vscale_temp
    // __conio.layer = 0
    // [1271] *((char *)&__conio+2) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+2
    // mapbase >> 7
    // [1272] screenlayer::$0 = screenlayer::mapbase >> 7 -- vbum1=vbum2_ror_7 
    lda mapbase
    rol
    rol
    and #1
    sta screenlayer__0
    // __conio.mapbase_bank = mapbase >> 7
    // [1273] *((char *)&__conio+5) = screenlayer::$0 -- _deref_pbuc1=vbum1 
    sta __conio+5
    // (mapbase)<<1
    // [1274] screenlayer::$1 = screenlayer::mapbase << 1 -- vbum1=vbum1_rol_1 
    asl screenlayer__1
    // MAKEWORD((mapbase)<<1,0)
    // [1275] screenlayer::$2 = screenlayer::$1 w= 0 -- vwum1=vbum2_word_vbuc1 
    lda #0
    ldy screenlayer__1
    sty screenlayer__2+1
    sta screenlayer__2
    // __conio.mapbase_offset = MAKEWORD((mapbase)<<1,0)
    // [1276] *((unsigned int *)&__conio+3) = screenlayer::$2 -- _deref_pwuc1=vwum1 
    sta __conio+3
    tya
    sta __conio+3+1
    // config & VERA_LAYER_WIDTH_MASK
    // [1277] screenlayer::$3 = screenlayer::config & VERA_LAYER_WIDTH_MASK -- vbum1=vbum2_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    and config
    sta screenlayer__3
    // (config & VERA_LAYER_WIDTH_MASK) >> 4
    // [1278] screenlayer::$4 = screenlayer::$3 >> 4 -- vbum1=vbum1_ror_4 
    lda screenlayer__4
    lsr
    lsr
    lsr
    lsr
    sta screenlayer__4
    // __conio.mapwidth = VERA_LAYER_DIM[ (config & VERA_LAYER_WIDTH_MASK) >> 4]
    // [1279] *((char *)&__conio+8) = screenlayer::VERA_LAYER_DIM[screenlayer::$4] -- _deref_pbuc1=pbuc2_derefidx_vbum1 
    tay
    lda VERA_LAYER_DIM,y
    sta __conio+8
    // config & VERA_LAYER_HEIGHT_MASK
    // [1280] screenlayer::$5 = screenlayer::config & VERA_LAYER_HEIGHT_MASK -- vbum1=vbum2_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    and config
    sta screenlayer__5
    // (config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [1281] screenlayer::$6 = screenlayer::$5 >> 6 -- vbum1=vbum1_ror_6 
    lda screenlayer__6
    rol
    rol
    rol
    and #3
    sta screenlayer__6
    // __conio.mapheight = VERA_LAYER_DIM[ (config & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [1282] *((char *)&__conio+9) = screenlayer::VERA_LAYER_DIM[screenlayer::$6] -- _deref_pbuc1=pbuc2_derefidx_vbum1 
    tay
    lda VERA_LAYER_DIM,y
    sta __conio+9
    // config & VERA_LAYER_WIDTH_MASK
    // [1283] screenlayer::$7 = screenlayer::config & VERA_LAYER_WIDTH_MASK -- vbum1=vbum1_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    and screenlayer__7
    sta screenlayer__7
    // (config & VERA_LAYER_WIDTH_MASK)>>4
    // [1284] screenlayer::$8 = screenlayer::$7 >> 4 -- vbum1=vbum1_ror_4 
    lda screenlayer__8
    lsr
    lsr
    lsr
    lsr
    sta screenlayer__8
    // __conio.rowskip = VERA_LAYER_SKIP[(config & VERA_LAYER_WIDTH_MASK)>>4]
    // [1285] screenlayer::$16 = screenlayer::$8 << 1 -- vbum1=vbum1_rol_1 
    asl screenlayer__16
    // [1286] *((unsigned int *)&__conio+$a) = screenlayer::VERA_LAYER_SKIP[screenlayer::$16] -- _deref_pwuc1=pwuc2_derefidx_vbum1 
    // __conio.rowshift = ((config & VERA_LAYER_WIDTH_MASK)>>4)+6;
    ldy screenlayer__16
    lda VERA_LAYER_SKIP,y
    sta __conio+$a
    lda VERA_LAYER_SKIP+1,y
    sta __conio+$a+1
    // vera_dc_hscale_temp == 0x80
    // [1287] screenlayer::$9 = screenlayer::vera_dc_hscale_temp#0 == $80 -- vbom1=vbum1_eq_vbuc1 
    lda screenlayer__9
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    sta screenlayer__9
    // 40 << (char)(vera_dc_hscale_temp == 0x80)
    // [1288] screenlayer::$18 = (char)screenlayer::$9
    // [1289] screenlayer::$10 = $28 << screenlayer::$18 -- vbum1=vbuc1_rol_vbum1 
    lda #$28
    ldy screenlayer__10
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta screenlayer__10
    // (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [1290] screenlayer::$11 = screenlayer::$10 - 1 -- vbum1=vbum1_minus_1 
    dec screenlayer__11
    // __conio.width = (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [1291] *((char *)&__conio+6) = screenlayer::$11 -- _deref_pbuc1=vbum1 
    lda screenlayer__11
    sta __conio+6
    // vera_dc_vscale_temp == 0x80
    // [1292] screenlayer::$12 = screenlayer::vera_dc_vscale_temp#0 == $80 -- vbom1=vbum1_eq_vbuc1 
    lda screenlayer__12
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    sta screenlayer__12
    // 30 << (char)(vera_dc_vscale_temp == 0x80)
    // [1293] screenlayer::$19 = (char)screenlayer::$12
    // [1294] screenlayer::$13 = $1e << screenlayer::$19 -- vbum1=vbuc1_rol_vbum1 
    lda #$1e
    ldy screenlayer__13
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta screenlayer__13
    // (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [1295] screenlayer::$14 = screenlayer::$13 - 1 -- vbum1=vbum1_minus_1 
    dec screenlayer__14
    // __conio.height = (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [1296] *((char *)&__conio+7) = screenlayer::$14 -- _deref_pbuc1=vbum1 
    lda screenlayer__14
    sta __conio+7
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [1297] screenlayer::mapbase_offset#0 = *((unsigned int *)&__conio+3) -- vwum1=_deref_pwuc1 
    lda __conio+3
    sta mapbase_offset
    lda __conio+3+1
    sta mapbase_offset+1
    // [1298] phi from screenlayer to screenlayer::@1 [phi:screenlayer->screenlayer::@1]
    // [1298] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#0 [phi:screenlayer->screenlayer::@1#0] -- register_copy 
    // [1298] phi screenlayer::y#2 = 0 [phi:screenlayer->screenlayer::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z y
    // screenlayer::@1
  __b1:
    // for(register char y=0; y<=__conio.height; y++)
    // [1299] if(screenlayer::y#2<=*((char *)&__conio+7)) goto screenlayer::@2 -- vbuz1_le__deref_pbuc1_then_la1 
    lda __conio+7
    cmp.z y
    bcs __b2
    // screenlayer::@return
    // }
    // [1300] return 
    rts
    // screenlayer::@2
  __b2:
    // __conio.offsets[y] = mapbase_offset
    // [1301] screenlayer::$17 = screenlayer::y#2 << 1 -- vbum1=vbuz2_rol_1 
    lda.z y
    asl
    sta screenlayer__17
    // [1302] ((unsigned int *)&__conio+$15)[screenlayer::$17] = screenlayer::mapbase_offset#2 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda mapbase_offset
    sta __conio+$15,y
    lda mapbase_offset+1
    sta __conio+$15+1,y
    // mapbase_offset += __conio.rowskip
    // [1303] screenlayer::mapbase_offset#1 = screenlayer::mapbase_offset#2 + *((unsigned int *)&__conio+$a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda mapbase_offset
    adc __conio+$a
    sta mapbase_offset
    lda mapbase_offset+1
    adc __conio+$a+1
    sta mapbase_offset+1
    // for(register char y=0; y<=__conio.height; y++)
    // [1304] screenlayer::y#1 = ++ screenlayer::y#2 -- vbuz1=_inc_vbuz1 
    inc.z y
    // [1298] phi from screenlayer::@2 to screenlayer::@1 [phi:screenlayer::@2->screenlayer::@1]
    // [1298] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#1 [phi:screenlayer::@2->screenlayer::@1#0] -- register_copy 
    // [1298] phi screenlayer::y#2 = screenlayer::y#1 [phi:screenlayer::@2->screenlayer::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    VERA_LAYER_DIM: .byte $1f, $3f, $7f, $ff
    VERA_LAYER_SKIP: .word $40, $80, $100, $200
    .label mapbase = screenlayer__1
    .label config = screenlayer__7
    screenlayer__0: .byte 0
    screenlayer__1: .byte 0
    .label screenlayer__2 = mapbase_offset
    .label screenlayer__3 = screenlayer__0
    .label screenlayer__4 = screenlayer__0
    .label screenlayer__5 = screenlayer__0
    .label screenlayer__6 = screenlayer__0
    screenlayer__7: .byte 0
    .label screenlayer__8 = screenlayer__7
    .label screenlayer__9 = vera_dc_hscale_temp
    .label screenlayer__10 = vera_dc_hscale_temp
    .label screenlayer__11 = vera_dc_hscale_temp
    .label screenlayer__12 = vera_dc_vscale_temp
    .label screenlayer__13 = vera_dc_vscale_temp
    .label screenlayer__14 = vera_dc_vscale_temp
    .label screenlayer__16 = screenlayer__7
    .label screenlayer__17 = vera_dc_hscale_temp
    .label screenlayer__18 = vera_dc_hscale_temp
    .label screenlayer__19 = vera_dc_vscale_temp
    vera_dc_hscale_temp: .byte 0
    vera_dc_vscale_temp: .byte 0
    mapbase_offset: .word 0
}
.segment Code
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
// void cscroll()
cscroll: {
    // if(__conio.cursor_y>__conio.height)
    // [1305] if(*((char *)&__conio+1)<=*((char *)&__conio+7)) goto cscroll::@return -- _deref_pbuc1_le__deref_pbuc2_then_la1 
    lda __conio+7
    cmp __conio+1
    bcs __breturn
    // cscroll::@1
    // if(__conio.scroll[__conio.layer])
    // [1306] if(0!=((char *)&__conio+$f)[*((char *)&__conio+2)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$f,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(__conio.cursor_y>__conio.height)
    // [1307] if(*((char *)&__conio+1)<=*((char *)&__conio+7)) goto cscroll::@return -- _deref_pbuc1_le__deref_pbuc2_then_la1 
    lda __conio+7
    cmp __conio+1
    bcs __breturn
    // cscroll::@3
    // gotoxy(0,0)
    // [1308] gotoxy::x = 0 -- vbum1=vbuc1 
    lda #0
    sta gotoxy.x
    // [1309] gotoxy::y = 0 -- vbum1=vbuc1 
    sta gotoxy.y
    // [1310] callexecute gotoxy  -- call_vprc1 
    jsr gotoxy
    // cscroll::@return
  __breturn:
    // }
    // [1311] return 
    rts
    // [1312] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup(1)
    // [1313] callexecute insertup  -- call_vprc1 
    jsr insertup
    // gotoxy( 0, __conio.height)
    // [1314] gotoxy::x = 0 -- vbum1=vbuc1 
    lda #0
    sta gotoxy.x
    // [1315] gotoxy::y = *((char *)&__conio+7) -- vbum1=_deref_pbuc1 
    lda __conio+7
    sta gotoxy.y
    // [1316] callexecute gotoxy  -- call_vprc1 
    jsr gotoxy
    // clearline()
    // [1317] callexecute clearline  -- call_vprc1 
    jsr clearline
    rts
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
// void insertup(char rows)
insertup: {
    .const rows = 1
    // __conio.width+1
    // [1318] insertup::$0 = *((char *)&__conio+6) + 1 -- vbum1=_deref_pbuc1_plus_1 
    lda __conio+6
    inc
    sta insertup__0
    // unsigned char width = (__conio.width+1) * 2
    // [1319] insertup::width#0 = insertup::$0 << 1 -- vbum1=vbum1_rol_1 
    // {asm{.byte $db}}
    asl width
    // [1320] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [1320] phi insertup::y#2 = 0 [phi:insertup->insertup::@1#0] -- vbum1=vbuc1 
    lda #0
    sta y
    // insertup::@1
  __b1:
    // for(unsigned char y=0; y<__conio.cursor_y; y++)
    // [1321] if(insertup::y#2<*((char *)&__conio+1)) goto insertup::@2 -- vbum1_lt__deref_pbuc1_then_la1 
    lda y
    cmp __conio+1
    bcc __b2
    // [1322] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [1323] callexecute clearline  -- call_vprc1 
    jsr clearline
    // insertup::@return
    // }
    // [1324] return 
    rts
    // insertup::@2
  __b2:
    // y+1
    // [1325] insertup::$4 = insertup::y#2 + 1 -- vbum1=vbum2_plus_1 
    lda y
    inc
    sta insertup__4
    // memcpy8_vram_vram(__conio.mapbase_bank, __conio.offsets[y], __conio.mapbase_bank, __conio.offsets[y+1], width)
    // [1326] insertup::$6 = insertup::y#2 << 1 -- vbum1=vbum2_rol_1 
    lda y
    asl
    sta insertup__6
    // [1327] insertup::$7 = insertup::$4 << 1 -- vbum1=vbum1_rol_1 
    asl insertup__7
    // [1328] memcpy8_vram_vram::dbank_vram = *((char *)&__conio+5) -- vbum1=_deref_pbuc1 
    lda __conio+5
    sta memcpy8_vram_vram.dbank_vram
    // [1329] memcpy8_vram_vram::doffset_vram = ((unsigned int *)&__conio+$15)[insertup::$6] -- vwum1=pwuc1_derefidx_vbum2 
    ldy insertup__6
    lda __conio+$15,y
    sta memcpy8_vram_vram.doffset_vram
    lda __conio+$15+1,y
    sta memcpy8_vram_vram.doffset_vram+1
    // [1330] memcpy8_vram_vram::sbank_vram = *((char *)&__conio+5) -- vbum1=_deref_pbuc1 
    lda __conio+5
    sta memcpy8_vram_vram.sbank_vram
    // [1331] memcpy8_vram_vram::soffset_vram = ((unsigned int *)&__conio+$15)[insertup::$7] -- vwum1=pwuc1_derefidx_vbum2 
    ldy insertup__7
    lda __conio+$15,y
    sta memcpy8_vram_vram.soffset_vram
    lda __conio+$15+1,y
    sta memcpy8_vram_vram.soffset_vram+1
    // [1332] memcpy8_vram_vram::num8 = insertup::width#0 -- vbum1=vbum2 
    lda width
    sta memcpy8_vram_vram.num8
    // [1333] callexecute memcpy8_vram_vram  -- call_vprc1 
    jsr memcpy8_vram_vram
    // for(unsigned char y=0; y<__conio.cursor_y; y++)
    // [1334] insertup::y#1 = ++ insertup::y#2 -- vbum1=_inc_vbum1 
    inc y
    // [1320] phi from insertup::@2 to insertup::@1 [phi:insertup::@2->insertup::@1]
    // [1320] phi insertup::y#2 = insertup::y#1 [phi:insertup::@2->insertup::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    insertup__0: .byte 0
    insertup__4: .byte 0
    insertup__6: .byte 0
    .label insertup__7 = insertup__4
    .label width = insertup__0
    y: .byte 0
}
.segment Code
  // clearline
// void clearline()
clearline: {
    .label c = 2
    // unsigned int addr = __conio.offsets[__conio.cursor_y]
    // [1335] clearline::$3 = *((char *)&__conio+1) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda __conio+1
    asl
    sta clearline__3
    // [1336] clearline::addr#0 = ((unsigned int *)&__conio+$15)[clearline::$3] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda __conio+$15,y
    sta addr
    lda __conio+$15+1,y
    sta addr+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1337] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(addr)
    // [1338] clearline::$0 = byte0  clearline::addr#0 -- vbum1=_byte0_vwum2 
    lda addr
    sta clearline__0
    // *VERA_ADDRX_L = BYTE0(addr)
    // [1339] *VERA_ADDRX_L = clearline::$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(addr)
    // [1340] clearline::$1 = byte1  clearline::addr#0 -- vbum1=_byte1_vwum2 
    lda addr+1
    sta clearline__1
    // *VERA_ADDRX_M = BYTE1(addr)
    // [1341] *VERA_ADDRX_M = clearline::$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [1342] clearline::$2 = *((char *)&__conio+5) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    sta clearline__2
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [1343] *VERA_ADDRX_H = clearline::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // register unsigned char c=__conio.width
    // [1344] clearline::c#0 = *((char *)&__conio+6) -- vbuz1=_deref_pbuc1 
    lda __conio+6
    sta.z c
    // [1345] phi from clearline clearline::@1 to clearline::@1 [phi:clearline/clearline::@1->clearline::@1]
    // [1345] phi clearline::c#2 = clearline::c#0 [phi:clearline/clearline::@1->clearline::@1#0] -- register_copy 
    // clearline::@1
  __b1:
    // *VERA_DATA0 = ' '
    // [1346] *VERA_DATA0 = ' 'pm -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [1347] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // c--;
    // [1348] clearline::c#1 = -- clearline::c#2 -- vbuz1=_dec_vbuz1 
    dec.z c
    // while(c)
    // [1349] if(0!=clearline::c#1) goto clearline::@1 -- 0_neq_vbuz1_then_la1 
    lda.z c
    bne __b1
    // clearline::@return
    // }
    // [1350] return 
    rts
  .segment Data
    .label clearline__0 = insertup.y
    .label clearline__1 = insertup.y
    .label clearline__2 = insertup.y
    .label clearline__3 = insertup.y
    .label addr = memcpy8_vram_vram.doffset_vram
}
.segment Code
  // conio_x16_init
/// Set initial screen values.
// void conio_x16_init()
conio_x16_init: {
    // screenlayer1()
    // [1352] callexecute screenlayer1  -- call_vprc1 
    jsr screenlayer1
    // textcolor(CONIO_TEXTCOLOR_DEFAULT)
    // [1353] callexecute textcolor  -- call_vprc1 
    jsr textcolor
    // bgcolor(CONIO_BACKCOLOR_DEFAULT)
    // [1354] callexecute bgcolor  -- call_vprc1 
    jsr bgcolor
    // cursor(0)
    // [1355] callexecute cursor  -- call_vprc1 
    jsr cursor
    // cbm_k_plot_get()
    // [1356] callexecute cbm_k_plot_get  -- call_vprc1 
    jsr cbm_k_plot_get
    // [1357] conio_x16_init::$4 = cbm_k_plot_get::return
    // BYTE1(cbm_k_plot_get())
    // [1358] conio_x16_init::$5 = byte1  conio_x16_init::$4 -- vbum1=_byte1_vwum2 
    lda conio_x16_init__4+1
    sta conio_x16_init__5
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [1359] *((char *)&__conio) = conio_x16_init::$5 -- _deref_pbuc1=vbum1 
    sta __conio
    // cbm_k_plot_get()
    // [1360] callexecute cbm_k_plot_get  -- call_vprc1 
    jsr cbm_k_plot_get
    // [1361] conio_x16_init::$6 = cbm_k_plot_get::return
    // BYTE0(cbm_k_plot_get())
    // [1362] conio_x16_init::$7 = byte0  conio_x16_init::$6 -- vbum1=_byte0_vwum2 
    lda conio_x16_init__6
    sta conio_x16_init__7
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [1363] *((char *)&__conio+1) = conio_x16_init::$7 -- _deref_pbuc1=vbum1 
    sta __conio+1
    // gotoxy(__conio.cursor_x, __conio.cursor_y)
    // [1364] gotoxy::x = *((char *)&__conio) -- vbum1=_deref_pbuc1 
    lda __conio
    sta gotoxy.x
    // [1365] gotoxy::y = *((char *)&__conio+1) -- vbum1=_deref_pbuc1 
    lda __conio+1
    sta gotoxy.y
    // [1366] callexecute gotoxy  -- call_vprc1 
    jsr gotoxy
    // __conio.scroll[0] = 1
    // [1367] *((char *)&__conio+$f) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta __conio+$f
    // __conio.scroll[1] = 1
    // [1368] *((char *)&__conio+$f+1) = 1 -- _deref_pbuc1=vbuc2 
    sta __conio+$f+1
    // conio_x16_init::@return
    // }
    // [1369] return 
    rts
  .segment Data
    .label conio_x16_init__4 = screenlayer.mapbase_offset
    .label conio_x16_init__5 = screenlayer.vera_dc_hscale_temp
    .label conio_x16_init__6 = screenlayer.mapbase_offset
    .label conio_x16_init__7 = screenlayer.vera_dc_hscale_temp
}
.segment Code
  // screenlayer1
// Set the layer with which the conio will interact.
// void screenlayer1()
screenlayer1: {
    // screenlayer(1, *VERA_L1_MAPBASE, *VERA_L1_CONFIG)
    // [1370] screenlayer::mapbase = *VERA_L1_MAPBASE -- vbum1=_deref_pbuc1 
    lda VERA_L1_MAPBASE
    sta screenlayer.mapbase
    // [1371] screenlayer::config = *VERA_L1_CONFIG -- vbum1=_deref_pbuc1 
    lda VERA_L1_CONFIG
    sta screenlayer.config
    // [1372] callexecute screenlayer  -- call_vprc1 
    jsr screenlayer
    // screenlayer1::@return
    // }
    // [1373] return 
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
    // [1374] *((char *)&__conio+$c) = cursor::onoff -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta __conio+$c
    // cursor::@return
    // }
    // [1375] return 
    rts
}
  // bgcolor
// Set the back color for text output.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor()
bgcolor: {
    // __conio.color & 0x0F
    // [1376] bgcolor::$0 = *((char *)&__conio+$d) & $f -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$f
    and __conio+$d
    sta bgcolor__0
    // __conio.color & 0x0F | color << 4
    // [1377] bgcolor::$2 = bgcolor::$0 | BLUE<<4 -- vbum1=vbum1_bor_vbuc1 
    lda #BLUE<<4
    ora bgcolor__2
    sta bgcolor__2
    // __conio.color = __conio.color & 0x0F | color << 4
    // [1378] *((char *)&__conio+$d) = bgcolor::$2 -- _deref_pbuc1=vbum1 
    sta __conio+$d
    // bgcolor::@return
    // }
    // [1379] return 
    rts
  .segment Data
    .label bgcolor__0 = screenlayer.vera_dc_hscale_temp
    .label bgcolor__2 = screenlayer.vera_dc_hscale_temp
}
.segment Code
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char textcolor()
textcolor: {
    // __conio.color & 0xF0
    // [1380] textcolor::$0 = *((char *)&__conio+$d) & $f0 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and __conio+$d
    sta textcolor__0
    // __conio.color & 0xF0 | color
    // [1381] textcolor::$1 = textcolor::$0 | WHITE -- vbum1=vbum1_bor_vbuc1 
    lda #WHITE
    ora textcolor__1
    sta textcolor__1
    // __conio.color = __conio.color & 0xF0 | color
    // [1382] *((char *)&__conio+$d) = textcolor::$1 -- _deref_pbuc1=vbum1 
    sta __conio+$d
    // textcolor::@return
    // }
    // [1383] return 
    rts
  .segment Data
    .label textcolor__0 = screenlayer.vera_dc_hscale_temp
    .label textcolor__1 = screenlayer.vera_dc_hscale_temp
}
.segment Code
  // cputln
// Print a newline
// void cputln()
cputln: {
    // __conio.cursor_x = 0
    // [1384] *((char *)&__conio) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio
    // __conio.cursor_y++;
    // [1385] *((char *)&__conio+1) = ++ *((char *)&__conio+1) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+1
    // __conio.offset = __conio.offsets[__conio.cursor_y]
    // [1386] cputln::$3 = *((char *)&__conio+1) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda __conio+1
    asl
    sta cputln__3
    // [1387] *((unsigned int *)&__conio+$13) = ((unsigned int *)&__conio+$15)[cputln::$3] -- _deref_pwuc1=pwuc2_derefidx_vbum1 
    tay
    lda __conio+$15,y
    sta __conio+$13
    lda __conio+$15+1,y
    sta __conio+$13+1
    // if(__conio.scroll[__conio.layer])
    // [1388] if(0==((char *)&__conio+$f)[*((char *)&__conio+2)]) goto cputln::@return -- 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$f,y
    cmp #0
    beq __breturn
    // [1389] phi from cputln to cputln::@1 [phi:cputln->cputln::@1]
    // cputln::@1
    // cscroll()
    // [1390] callexecute cscroll  -- call_vprc1 
    jsr cscroll
    // cputln::@return
  __breturn:
    // }
    // [1391] return 
    rts
  .segment Data
    .label cputln__3 = insertup.y
}
.segment Code
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__mem() char c)
cputc: {
    .const OFFSET_STACK_C = 0
    // [1392] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta c
    // if(c=='\n')
    // [1393] if(cputc::c#0==' 'pm) goto cputc::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1394] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(__conio.offset)
    // [1395] cputc::$1 = byte0  *((unsigned int *)&__conio+$13) -- vbum1=_byte0__deref_pwuc1 
    lda __conio+$13
    sta cputc__1
    // *VERA_ADDRX_L = BYTE0(__conio.offset)
    // [1396] *VERA_ADDRX_L = cputc::$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(__conio.offset)
    // [1397] cputc::$2 = byte1  *((unsigned int *)&__conio+$13) -- vbum1=_byte1__deref_pwuc1 
    lda __conio+$13+1
    sta cputc__2
    // *VERA_ADDRX_M = BYTE1(__conio.offset)
    // [1398] *VERA_ADDRX_M = cputc::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [1399] cputc::$3 = *((char *)&__conio+5) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    sta cputc__3
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [1400] *VERA_ADDRX_H = cputc::$3 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [1401] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbum1 
    lda c
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [1402] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // if(!__conio.hscroll[__conio.layer])
    // [1403] if(0==((char *)&__conio+$11)[*((char *)&__conio+2)]) goto cputc::@5 -- 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$11,y
    cmp #0
    beq __b5
    // cputc::@3
    // if(__conio.cursor_x >= __conio.mapwidth)
    // [1404] if(*((char *)&__conio)>=*((char *)&__conio+8)) goto cputc::@6 -- _deref_pbuc1_ge__deref_pbuc2_then_la1 
    lda __conio
    cmp __conio+8
    bcs __b6
    // cputc::@4
    // __conio.cursor_x++;
    // [1405] *((char *)&__conio) = ++ *((char *)&__conio) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio
    // cputc::@7
  __b7:
    // __conio.offset++;
    // [1406] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // [1407] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // cputc::@return
    // }
    // [1408] return 
    rts
    // [1409] phi from cputc::@3 to cputc::@6 [phi:cputc::@3->cputc::@6]
    // cputc::@6
  __b6:
    // cputln()
    // [1410] callexecute cputln  -- call_vprc1 
    jsr cputln
    jmp __b7
    // cputc::@5
  __b5:
    // if(__conio.cursor_x >= __conio.width)
    // [1411] if(*((char *)&__conio)>=*((char *)&__conio+6)) goto cputc::@8 -- _deref_pbuc1_ge__deref_pbuc2_then_la1 
    lda __conio
    cmp __conio+6
    bcs __b8
    // cputc::@9
    // __conio.cursor_x++;
    // [1412] *((char *)&__conio) = ++ *((char *)&__conio) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio
    // __conio.offset++;
    // [1413] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // [1414] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    rts
    // [1415] phi from cputc::@5 to cputc::@8 [phi:cputc::@5->cputc::@8]
    // cputc::@8
  __b8:
    // cputln()
    // [1416] callexecute cputln  -- call_vprc1 
    jsr cputln
    rts
    // [1417] phi from cputc to cputc::@1 [phi:cputc->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [1418] callexecute cputln  -- call_vprc1 
    jsr cputln
    rts
  .segment Data
    .label cputc__1 = insertup.insertup__0
    .label cputc__2 = insertup.insertup__0
    .label cputc__3 = insertup.insertup__0
    .label c = insertup.y
}
.segment Code
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__mem() char x, __mem() char y)
gotoxy: {
    // (x>=__conio.width)?__conio.width:x
    // [1419] if(gotoxy::x>=*((char *)&__conio+6)) goto gotoxy::@1 -- vbum1_ge__deref_pbuc1_then_la1 
    lda x
    cmp __conio+6
    bcs __b1
    // gotoxy::@2
    // [1420] gotoxy::$1 = gotoxy::x
    // [1421] phi from gotoxy::@1 gotoxy::@2 to gotoxy::@3 [phi:gotoxy::@1/gotoxy::@2->gotoxy::@3]
    // [1421] phi gotoxy::$3 = gotoxy::$2 [phi:gotoxy::@1/gotoxy::@2->gotoxy::@3#0] -- register_copy 
    // gotoxy::@3
  __b3:
    // __conio.cursor_x = (x>=__conio.width)?__conio.width:x
    // [1422] *((char *)&__conio) = gotoxy::$3 -- _deref_pbuc1=vbum1 
    lda gotoxy__3
    sta __conio
    // (y>=__conio.height)?__conio.height:y
    // [1423] if(gotoxy::y>=*((char *)&__conio+7)) goto gotoxy::@4 -- vbum1_ge__deref_pbuc1_then_la1 
    lda y
    cmp __conio+7
    bcs __b4
    // gotoxy::@5
    // [1424] gotoxy::$5 = gotoxy::y -- vbum1=vbum2 
    sta gotoxy__5
    // [1425] phi from gotoxy::@4 gotoxy::@5 to gotoxy::@6 [phi:gotoxy::@4/gotoxy::@5->gotoxy::@6]
    // [1425] phi gotoxy::$7 = gotoxy::$6 [phi:gotoxy::@4/gotoxy::@5->gotoxy::@6#0] -- register_copy 
    // gotoxy::@6
  __b6:
    // __conio.cursor_y = (y>=__conio.height)?__conio.height:y
    // [1426] *((char *)&__conio+1) = gotoxy::$7 -- _deref_pbuc1=vbum1 
    lda gotoxy__7
    sta __conio+1
    // __conio.cursor_x << 1
    // [1427] gotoxy::$8 = *((char *)&__conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda __conio
    asl
    sta gotoxy__8
    // __conio.offsets[y] + __conio.cursor_x << 1
    // [1428] gotoxy::$10 = gotoxy::y << 1 -- vbum1=vbum1_rol_1 
    asl gotoxy__10
    // [1429] gotoxy::$9 = ((unsigned int *)&__conio+$15)[gotoxy::$10] + gotoxy::$8 -- vwum1=pwuc1_derefidx_vbum2_plus_vbum3 
    ldy gotoxy__10
    clc
    adc __conio+$15,y
    sta gotoxy__9
    lda __conio+$15+1,y
    adc #0
    sta gotoxy__9+1
    // __conio.offset = __conio.offsets[y] + __conio.cursor_x << 1
    // [1430] *((unsigned int *)&__conio+$13) = gotoxy::$9 -- _deref_pwuc1=vwum1 
    lda gotoxy__9
    sta __conio+$13
    lda gotoxy__9+1
    sta __conio+$13+1
    // gotoxy::@return
    // }
    // [1431] return 
    rts
    // gotoxy::@4
  __b4:
    // (y>=__conio.height)?__conio.height:y
    // [1432] gotoxy::$6 = *((char *)&__conio+7) -- vbum1=_deref_pbuc1 
    lda __conio+7
    sta gotoxy__6
    jmp __b6
    // gotoxy::@1
  __b1:
    // (x>=__conio.width)?__conio.width:x
    // [1433] gotoxy::$2 = *((char *)&__conio+6) -- vbum1=_deref_pbuc1 
    lda __conio+6
    sta gotoxy__2
    jmp __b3
  .segment Data
    .label x = gotoxy__3
    y: .byte 0
    .label gotoxy__1 = gotoxy__3
    .label gotoxy__2 = gotoxy__3
    gotoxy__3: .byte 0
    .label gotoxy__5 = gotoxy__3
    .label gotoxy__6 = gotoxy__3
    .label gotoxy__7 = gotoxy__3
    .label gotoxy__8 = gotoxy__3
    gotoxy__9: .word 0
    .label gotoxy__10 = y
}
.segment Code
  // cx16_init
// void cx16_init()
cx16_init: {
    // isr_vsync = *(word *)0x0314
    // [1434] isr_vsync = *((unsigned int *) 788) -- vwum1=_deref_pwuc1 
    lda $314
    sta isr_vsync
    lda $314+1
    sta isr_vsync+1
    // cx16_init::@return
    // }
    // [1435] return 
    rts
}
  // ultoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __mem() unsigned long ultoa_append(__zp(9) char *buffer, __mem() unsigned long value, __mem() unsigned long sub)
ultoa_append: {
    .label buffer = 9
    // [1437] phi from ultoa_append to ultoa_append::@1 [phi:ultoa_append->ultoa_append::@1]
    // [1437] phi ultoa_append::digit#2 = 0 [phi:ultoa_append->ultoa_append::@1#0] -- vbum1=vbuc1 
    lda #0
    sta digit
    // ultoa_append::@1
  __b1:
    // while (value >= sub)
    // [1438] if(ultoa_append::value>=ultoa_append::sub) goto ultoa_append::@2 -- vdum1_ge_vdum2_then_la1 
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
    // [1439] *ultoa_append::buffer = DIGITS[ultoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    ldy digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // return value;
    // [1440] ultoa_append::return = ultoa_append::value
    // ultoa_append::@return
    // }
    // [1441] return 
    rts
    // ultoa_append::@2
  __b2:
    // digit++;
    // [1442] ultoa_append::digit#1 = ++ ultoa_append::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // value -= sub
    // [1443] ultoa_append::value = ultoa_append::value - ultoa_append::sub -- vdum1=vdum1_minus_vdum2 
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
    // [1437] phi from ultoa_append::@2 to ultoa_append::@1 [phi:ultoa_append::@2->ultoa_append::@1]
    // [1437] phi ultoa_append::digit#2 = ultoa_append::digit#1 [phi:ultoa_append::@2->ultoa_append::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    .label value = printf_ulong.uvalue
    .label sub = ultoa.digit_value
    .label return = printf_ulong.uvalue
    .label digit = printf_number_buffer.len
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
// __mem() unsigned int utoa_append(__zp(9) char *buffer, __mem() unsigned int value, __mem() unsigned int sub)
utoa_append: {
    .label buffer = 9
    // [1445] phi from utoa_append to utoa_append::@1 [phi:utoa_append->utoa_append::@1]
    // [1445] phi utoa_append::digit#2 = 0 [phi:utoa_append->utoa_append::@1#0] -- vbum1=vbuc1 
    lda #0
    sta digit
    // utoa_append::@1
  __b1:
    // while (value >= sub)
    // [1446] if(utoa_append::value>=utoa_append::sub) goto utoa_append::@2 -- vwum1_ge_vwum2_then_la1 
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
    // [1447] *utoa_append::buffer = DIGITS[utoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    ldy digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // return value;
    // [1448] utoa_append::return = utoa_append::value
    // utoa_append::@return
    // }
    // [1449] return 
    rts
    // utoa_append::@2
  __b2:
    // digit++;
    // [1450] utoa_append::digit#1 = ++ utoa_append::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // value -= sub
    // [1451] utoa_append::value = utoa_append::value - utoa_append::sub -- vwum1=vwum1_minus_vwum2 
    lda value
    sec
    sbc sub
    sta value
    lda value+1
    sbc sub+1
    sta value+1
    // [1445] phi from utoa_append::@2 to utoa_append::@1 [phi:utoa_append::@2->utoa_append::@1]
    // [1445] phi utoa_append::digit#2 = utoa_append::digit#1 [phi:utoa_append::@2->utoa_append::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    .label value = strlen.len
    .label sub = utoa.digit_value
    .label return = strlen.len
    .label digit = printf_number_buffer.len
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
// __mem() char uctoa_append(__zp(7) char *buffer, __mem() char value, __mem() char sub)
uctoa_append: {
    .label buffer = 7
    // [1453] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [1453] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbum1=vbuc1 
    lda #0
    sta digit
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [1454] if(uctoa_append::value>=uctoa_append::sub) goto uctoa_append::@2 -- vbum1_ge_vbum2_then_la1 
    lda value
    cmp sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [1455] *uctoa_append::buffer = DIGITS[uctoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    ldy digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // return value;
    // [1456] uctoa_append::return = uctoa_append::value
    // uctoa_append::@return
    // }
    // [1457] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [1458] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // value -= sub
    // [1459] uctoa_append::value = uctoa_append::value - uctoa_append::sub -- vbum1=vbum1_minus_vbum2 
    lda value
    sec
    sbc sub
    sta value
    // [1453] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [1453] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    .label value = printf_uchar.uvalue
    .label sub = uctoa.uctoa__4
    .label return = printf_uchar.uvalue
    .label digit = printf_number_buffer.len
}
.segment Code
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void uctoa(__mem() char value, __zp(5) char *buffer, __mem() char radix)
uctoa: {
    .label buffer = 5
    .label digit_values = 3
    // if(radix==DECIMAL)
    // [1460] if(uctoa::radix==DECIMAL) goto uctoa::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #DECIMAL
    cmp radix
    beq __b2
    // uctoa::@2
    // if(radix==HEXADECIMAL)
    // [1461] if(uctoa::radix==HEXADECIMAL) goto uctoa::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #HEXADECIMAL
    cmp radix
    beq __b3
    // uctoa::@3
    // if(radix==OCTAL)
    // [1462] if(uctoa::radix==OCTAL) goto uctoa::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #OCTAL
    cmp radix
    beq __b4
    // uctoa::@4
    // if(radix==BINARY)
    // [1463] if(uctoa::radix==BINARY) goto uctoa::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #BINARY
    cmp radix
    beq __b5
    // uctoa::@5
    // *buffer++ = 'e'
    // [1464] *uctoa::buffer = 'e'pm -- _deref_pbuz1=vbuc1 
    // Unknown radix
    lda #'e'
    ldy #0
    sta (buffer),y
    // *buffer++ = 'e';
    // [1465] uctoa::buffer = ++ uctoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer++ = 'r'
    // [1466] *uctoa::buffer = 'r'pm -- _deref_pbuz1=vbuc1 
    lda #'r'
    ldy #0
    sta (buffer),y
    // *buffer++ = 'r';
    // [1467] uctoa::buffer = ++ uctoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer++ = 'r'
    // [1468] *uctoa::buffer = 'r'pm -- _deref_pbuz1=vbuc1 
    lda #'r'
    ldy #0
    sta (buffer),y
    // *buffer++ = 'r';
    // [1469] uctoa::buffer = ++ uctoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1470] *uctoa::buffer = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // uctoa::@return
    // }
    // [1471] return 
    rts
    // [1472] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
  __b2:
    // [1472] phi uctoa::digit_values#8 = RADIX_DECIMAL_VALUES_CHAR [phi:uctoa->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values+1
    // [1472] phi uctoa::max_digits#7 = 3 [phi:uctoa->uctoa::@1#1] -- vbum1=vbuc1 
    lda #3
    sta max_digits
    jmp __b1
    // [1472] phi from uctoa::@2 to uctoa::@1 [phi:uctoa::@2->uctoa::@1]
  __b3:
    // [1472] phi uctoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES_CHAR [phi:uctoa::@2->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values+1
    // [1472] phi uctoa::max_digits#7 = 2 [phi:uctoa::@2->uctoa::@1#1] -- vbum1=vbuc1 
    lda #2
    sta max_digits
    jmp __b1
    // [1472] phi from uctoa::@3 to uctoa::@1 [phi:uctoa::@3->uctoa::@1]
  __b4:
    // [1472] phi uctoa::digit_values#8 = RADIX_OCTAL_VALUES_CHAR [phi:uctoa::@3->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values+1
    // [1472] phi uctoa::max_digits#7 = 3 [phi:uctoa::@3->uctoa::@1#1] -- vbum1=vbuc1 
    lda #3
    sta max_digits
    jmp __b1
    // [1472] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
  __b5:
    // [1472] phi uctoa::digit_values#8 = RADIX_BINARY_VALUES_CHAR [phi:uctoa::@4->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_BINARY_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES_CHAR
    sta.z digit_values+1
    // [1472] phi uctoa::max_digits#7 = 8 [phi:uctoa::@4->uctoa::@1#1] -- vbum1=vbuc1 
    lda #8
    sta max_digits
    // uctoa::@1
  __b1:
    // [1473] phi from uctoa::@1 to uctoa::@6 [phi:uctoa::@1->uctoa::@6]
    // [1473] phi uctoa::started#2 = 0 [phi:uctoa::@1->uctoa::@6#0] -- vbum1=vbuc1 
    lda #0
    sta started
    // [1473] phi uctoa::digit#2 = 0 [phi:uctoa::@1->uctoa::@6#1] -- vbum1=vbuc1 
    sta digit
    // uctoa::@6
  __b6:
    // max_digits-1
    // [1474] uctoa::$4 = uctoa::max_digits#7 - 1 -- vbum1=vbum2_minus_1 
    ldx max_digits
    dex
    stx uctoa__4
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1475] if(uctoa::digit#2<uctoa::$4) goto uctoa::@7 -- vbum1_lt_vbum2_then_la1 
    lda digit
    cmp uctoa__4
    bcc __b7
    // uctoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [1476] uctoa::$10 = uctoa::value
    // [1477] *uctoa::buffer = DIGITS[uctoa::$10] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    ldy uctoa__10
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1478] uctoa::buffer = ++ uctoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1479] *uctoa::buffer = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    rts
    // uctoa::@7
  __b7:
    // unsigned char digit_value = digit_values[digit]
    // [1480] uctoa::digit_value#0 = uctoa::digit_values#8[uctoa::digit#2] -- vbum1=pbuz2_derefidx_vbum3 
    ldy digit
    lda (digit_values),y
    sta digit_value
    // value >= digit_value
    // [1481] uctoa::$12 = uctoa::value -- vbum1=vbum2 
    lda value
    sta uctoa__12
    // if (started || value >= digit_value)
    // [1482] if(0!=uctoa::started#2) goto uctoa::@10 -- 0_neq_vbum1_then_la1 
    lda started
    bne __b10
    // uctoa::@11
    // [1483] if(uctoa::$12<uctoa::digit_value#0) goto uctoa::@9 -- vbum1_lt_vbum2_then_la1 
    lda uctoa__12
    cmp digit_value
    bcc __b9
    // uctoa::@10
  __b10:
    // uctoa_append(buffer++, value, digit_value)
    // [1484] uctoa_append::buffer = uctoa::buffer -- pbuz1=pbuz2 
    lda.z buffer
    sta.z uctoa_append.buffer
    lda.z buffer+1
    sta.z uctoa_append.buffer+1
    // [1485] uctoa_append::value = uctoa::value
    // [1486] uctoa_append::sub = uctoa::digit_value#0
    // [1487] callexecute uctoa_append  -- call_vprc1 
    jsr uctoa_append
    // [1488] uctoa::$9 = uctoa_append::return
    // value = uctoa_append(buffer++, value, digit_value)
    // [1489] uctoa::value = uctoa::$9
    // value = uctoa_append(buffer++, value, digit_value);
    // [1490] uctoa::buffer = ++ uctoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1491] phi from uctoa::@10 to uctoa::@9 [phi:uctoa::@10->uctoa::@9]
    // [1491] phi uctoa::started#4 = 1 [phi:uctoa::@10->uctoa::@9#0] -- vbum1=vbuc1 
    lda #1
    sta started
    // [1491] phi from uctoa::@11 to uctoa::@9 [phi:uctoa::@11->uctoa::@9]
    // [1491] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@11->uctoa::@9#0] -- register_copy 
    // uctoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1492] uctoa::digit#1 = ++ uctoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [1473] phi from uctoa::@9 to uctoa::@6 [phi:uctoa::@9->uctoa::@6]
    // [1473] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@9->uctoa::@6#0] -- register_copy 
    // [1473] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@9->uctoa::@6#1] -- register_copy 
    jmp __b6
  .segment Data
    .label value = printf_uchar.uvalue
    .label radix = printf_number_buffer.len
    uctoa__4: .byte 0
    .label uctoa__9 = printf_uchar.uvalue
    .label uctoa__10 = printf_uchar.uvalue
    .label digit_value = uctoa__4
    digit: .byte 0
    .label started = printf_number_buffer.len
    .label max_digits = printf_padding.i
    uctoa__12: .byte 0
}
.segment Code
  // ultoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void ultoa(__mem() unsigned long value, __zp(7) char *buffer, __mem() char radix)
ultoa: {
    .label buffer = 7
    .label digit_values = 3
    // if(radix==DECIMAL)
    // [1493] if(ultoa::radix==DECIMAL) goto ultoa::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #DECIMAL
    cmp radix
    beq __b2
    // ultoa::@2
    // if(radix==HEXADECIMAL)
    // [1494] if(ultoa::radix==HEXADECIMAL) goto ultoa::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #HEXADECIMAL
    cmp radix
    beq __b3
    // ultoa::@3
    // if(radix==OCTAL)
    // [1495] if(ultoa::radix==OCTAL) goto ultoa::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #OCTAL
    cmp radix
    beq __b4
    // ultoa::@4
    // if(radix==BINARY)
    // [1496] if(ultoa::radix==BINARY) goto ultoa::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #BINARY
    cmp radix
    beq __b5
    // ultoa::@5
    // *buffer++ = 'e'
    // [1497] *ultoa::buffer = 'e'pm -- _deref_pbuz1=vbuc1 
    // Unknown radix
    lda #'e'
    ldy #0
    sta (buffer),y
    // *buffer++ = 'e';
    // [1498] ultoa::buffer = ++ ultoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer++ = 'r'
    // [1499] *ultoa::buffer = 'r'pm -- _deref_pbuz1=vbuc1 
    lda #'r'
    ldy #0
    sta (buffer),y
    // *buffer++ = 'r';
    // [1500] ultoa::buffer = ++ ultoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer++ = 'r'
    // [1501] *ultoa::buffer = 'r'pm -- _deref_pbuz1=vbuc1 
    lda #'r'
    ldy #0
    sta (buffer),y
    // *buffer++ = 'r';
    // [1502] ultoa::buffer = ++ ultoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1503] *ultoa::buffer = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // ultoa::@return
    // }
    // [1504] return 
    rts
    // [1505] phi from ultoa to ultoa::@1 [phi:ultoa->ultoa::@1]
  __b2:
    // [1505] phi ultoa::digit_values#8 = RADIX_DECIMAL_VALUES_LONG [phi:ultoa->ultoa::@1#0] -- pduz1=pduc1 
    lda #<RADIX_DECIMAL_VALUES_LONG
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES_LONG
    sta.z digit_values+1
    // [1505] phi ultoa::max_digits#7 = $a [phi:ultoa->ultoa::@1#1] -- vbum1=vbuc1 
    lda #$a
    sta max_digits
    jmp __b1
    // [1505] phi from ultoa::@2 to ultoa::@1 [phi:ultoa::@2->ultoa::@1]
  __b3:
    // [1505] phi ultoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES_LONG [phi:ultoa::@2->ultoa::@1#0] -- pduz1=pduc1 
    lda #<RADIX_HEXADECIMAL_VALUES_LONG
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES_LONG
    sta.z digit_values+1
    // [1505] phi ultoa::max_digits#7 = 8 [phi:ultoa::@2->ultoa::@1#1] -- vbum1=vbuc1 
    lda #8
    sta max_digits
    jmp __b1
    // [1505] phi from ultoa::@3 to ultoa::@1 [phi:ultoa::@3->ultoa::@1]
  __b4:
    // [1505] phi ultoa::digit_values#8 = RADIX_OCTAL_VALUES_LONG [phi:ultoa::@3->ultoa::@1#0] -- pduz1=pduc1 
    lda #<RADIX_OCTAL_VALUES_LONG
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES_LONG
    sta.z digit_values+1
    // [1505] phi ultoa::max_digits#7 = $b [phi:ultoa::@3->ultoa::@1#1] -- vbum1=vbuc1 
    lda #$b
    sta max_digits
    jmp __b1
    // [1505] phi from ultoa::@4 to ultoa::@1 [phi:ultoa::@4->ultoa::@1]
  __b5:
    // [1505] phi ultoa::digit_values#8 = RADIX_BINARY_VALUES_LONG [phi:ultoa::@4->ultoa::@1#0] -- pduz1=pduc1 
    lda #<RADIX_BINARY_VALUES_LONG
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES_LONG
    sta.z digit_values+1
    // [1505] phi ultoa::max_digits#7 = $20 [phi:ultoa::@4->ultoa::@1#1] -- vbum1=vbuc1 
    lda #$20
    sta max_digits
    // ultoa::@1
  __b1:
    // [1506] phi from ultoa::@1 to ultoa::@6 [phi:ultoa::@1->ultoa::@6]
    // [1506] phi ultoa::started#2 = 0 [phi:ultoa::@1->ultoa::@6#0] -- vbum1=vbuc1 
    lda #0
    sta started
    // [1506] phi ultoa::digit#2 = 0 [phi:ultoa::@1->ultoa::@6#1] -- vbum1=vbuc1 
    sta digit
    // ultoa::@6
  __b6:
    // max_digits-1
    // [1507] ultoa::$4 = ultoa::max_digits#7 - 1 -- vbum1=vbum2_minus_1 
    ldx max_digits
    dex
    stx ultoa__4
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1508] if(ultoa::digit#2<ultoa::$4) goto ultoa::@7 -- vbum1_lt_vbum2_then_la1 
    lda digit
    cmp ultoa__4
    bcc __b7
    // ultoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [1509] ultoa::$11 = (char)ultoa::value -- vbum1=_byte_vdum2 
    lda value
    sta ultoa__11
    // [1510] *ultoa::buffer = DIGITS[ultoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1511] ultoa::buffer = ++ ultoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1512] *ultoa::buffer = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    rts
    // ultoa::@7
  __b7:
    // unsigned long digit_value = digit_values[digit]
    // [1513] ultoa::$10 = ultoa::digit#2 << 2 -- vbum1=vbum2_rol_2 
    lda digit
    asl
    asl
    sta ultoa__10
    // [1514] ultoa::digit_value#0 = ultoa::digit_values#8[ultoa::$10] -- vdum1=pduz2_derefidx_vbum3 
    tay
    lda (digit_values),y
    sta digit_value
    iny
    lda (digit_values),y
    sta digit_value+1
    iny
    lda (digit_values),y
    sta digit_value+2
    iny
    lda (digit_values),y
    sta digit_value+3
    // value >= digit_value
    // [1515] ultoa::$13 = ultoa::value -- vdum1=vdum2 
    lda value
    sta ultoa__13
    lda value+1
    sta ultoa__13+1
    lda value+2
    sta ultoa__13+2
    lda value+3
    sta ultoa__13+3
    // if (started || value >= digit_value)
    // [1516] if(0!=ultoa::started#2) goto ultoa::@10 -- 0_neq_vbum1_then_la1 
    lda started
    bne __b10
    // ultoa::@11
    // [1517] if(ultoa::$13<ultoa::digit_value#0) goto ultoa::@9 -- vdum1_lt_vdum2_then_la1 
    lda ultoa__13+3
    cmp digit_value+3
    bcc __b9
    bne !+
    lda ultoa__13+2
    cmp digit_value+2
    bcc __b9
    bne !+
    lda ultoa__13+1
    cmp digit_value+1
    bcc __b9
    bne !+
    lda ultoa__13
    cmp digit_value
    bcc __b9
  !:
    // ultoa::@10
  __b10:
    // ultoa_append(buffer++, value, digit_value)
    // [1518] ultoa_append::buffer = ultoa::buffer -- pbuz1=pbuz2 
    lda.z buffer
    sta.z ultoa_append.buffer
    lda.z buffer+1
    sta.z ultoa_append.buffer+1
    // [1519] ultoa_append::value = ultoa::value
    // [1520] ultoa_append::sub = ultoa::digit_value#0
    // [1521] callexecute ultoa_append  -- call_vprc1 
    jsr ultoa_append
    // [1522] ultoa::$9 = ultoa_append::return
    // value = ultoa_append(buffer++, value, digit_value)
    // [1523] ultoa::value = ultoa::$9
    // value = ultoa_append(buffer++, value, digit_value);
    // [1524] ultoa::buffer = ++ ultoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1525] phi from ultoa::@10 to ultoa::@9 [phi:ultoa::@10->ultoa::@9]
    // [1525] phi ultoa::started#4 = 1 [phi:ultoa::@10->ultoa::@9#0] -- vbum1=vbuc1 
    lda #1
    sta started
    // [1525] phi from ultoa::@11 to ultoa::@9 [phi:ultoa::@11->ultoa::@9]
    // [1525] phi ultoa::started#4 = ultoa::started#2 [phi:ultoa::@11->ultoa::@9#0] -- register_copy 
    // ultoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1526] ultoa::digit#1 = ++ ultoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [1506] phi from ultoa::@9 to ultoa::@6 [phi:ultoa::@9->ultoa::@6]
    // [1506] phi ultoa::started#2 = ultoa::started#4 [phi:ultoa::@9->ultoa::@6#0] -- register_copy 
    // [1506] phi ultoa::digit#2 = ultoa::digit#1 [phi:ultoa::@9->ultoa::@6#1] -- register_copy 
    jmp __b6
  .segment Data
    .label value = printf_ulong.uvalue
    .label radix = printf_number_buffer.len
    .label ultoa__4 = printf_uchar.uvalue
    .label ultoa__9 = printf_ulong.uvalue
    .label ultoa__10 = printf_uchar.uvalue
    .label ultoa__11 = printf_number_buffer.len
    digit_value: .dword 0
    .label digit = uctoa.digit
    .label started = printf_number_buffer.len
    .label max_digits = printf_padding.i
    ultoa__13: .dword 0
}
.segment Code
  // utoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__mem() unsigned int value, __zp(5) char *buffer, __mem() char radix)
utoa: {
    .label buffer = 5
    .label digit_values = 3
    // if(radix==DECIMAL)
    // [1527] if(utoa::radix==DECIMAL) goto utoa::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #DECIMAL
    cmp radix
    beq __b2
    // utoa::@2
    // if(radix==HEXADECIMAL)
    // [1528] if(utoa::radix==HEXADECIMAL) goto utoa::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #HEXADECIMAL
    cmp radix
    beq __b3
    // utoa::@3
    // if(radix==OCTAL)
    // [1529] if(utoa::radix==OCTAL) goto utoa::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #OCTAL
    cmp radix
    beq __b4
    // utoa::@4
    // if(radix==BINARY)
    // [1530] if(utoa::radix==BINARY) goto utoa::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #BINARY
    cmp radix
    beq __b5
    // utoa::@5
    // *buffer++ = 'e'
    // [1531] *utoa::buffer = 'e'pm -- _deref_pbuz1=vbuc1 
    // Unknown radix
    lda #'e'
    ldy #0
    sta (buffer),y
    // *buffer++ = 'e';
    // [1532] utoa::buffer = ++ utoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer++ = 'r'
    // [1533] *utoa::buffer = 'r'pm -- _deref_pbuz1=vbuc1 
    lda #'r'
    ldy #0
    sta (buffer),y
    // *buffer++ = 'r';
    // [1534] utoa::buffer = ++ utoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer++ = 'r'
    // [1535] *utoa::buffer = 'r'pm -- _deref_pbuz1=vbuc1 
    lda #'r'
    ldy #0
    sta (buffer),y
    // *buffer++ = 'r';
    // [1536] utoa::buffer = ++ utoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1537] *utoa::buffer = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // utoa::@return
    // }
    // [1538] return 
    rts
    // [1539] phi from utoa to utoa::@1 [phi:utoa->utoa::@1]
  __b2:
    // [1539] phi utoa::digit_values#8 = RADIX_DECIMAL_VALUES [phi:utoa->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_DECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES
    sta.z digit_values+1
    // [1539] phi utoa::max_digits#7 = 5 [phi:utoa->utoa::@1#1] -- vbum1=vbuc1 
    lda #5
    sta max_digits
    jmp __b1
    // [1539] phi from utoa::@2 to utoa::@1 [phi:utoa::@2->utoa::@1]
  __b3:
    // [1539] phi utoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES [phi:utoa::@2->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_HEXADECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES
    sta.z digit_values+1
    // [1539] phi utoa::max_digits#7 = 4 [phi:utoa::@2->utoa::@1#1] -- vbum1=vbuc1 
    lda #4
    sta max_digits
    jmp __b1
    // [1539] phi from utoa::@3 to utoa::@1 [phi:utoa::@3->utoa::@1]
  __b4:
    // [1539] phi utoa::digit_values#8 = RADIX_OCTAL_VALUES [phi:utoa::@3->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_OCTAL_VALUES
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES
    sta.z digit_values+1
    // [1539] phi utoa::max_digits#7 = 6 [phi:utoa::@3->utoa::@1#1] -- vbum1=vbuc1 
    lda #6
    sta max_digits
    jmp __b1
    // [1539] phi from utoa::@4 to utoa::@1 [phi:utoa::@4->utoa::@1]
  __b5:
    // [1539] phi utoa::digit_values#8 = RADIX_BINARY_VALUES [phi:utoa::@4->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_BINARY_VALUES
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES
    sta.z digit_values+1
    // [1539] phi utoa::max_digits#7 = $10 [phi:utoa::@4->utoa::@1#1] -- vbum1=vbuc1 
    lda #$10
    sta max_digits
    // utoa::@1
  __b1:
    // [1540] phi from utoa::@1 to utoa::@6 [phi:utoa::@1->utoa::@6]
    // [1540] phi utoa::started#2 = 0 [phi:utoa::@1->utoa::@6#0] -- vbum1=vbuc1 
    lda #0
    sta started
    // [1540] phi utoa::digit#2 = 0 [phi:utoa::@1->utoa::@6#1] -- vbum1=vbuc1 
    sta digit
    // utoa::@6
  __b6:
    // max_digits-1
    // [1541] utoa::$4 = utoa::max_digits#7 - 1 -- vbum1=vbum2_minus_1 
    ldx max_digits
    dex
    stx utoa__4
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1542] if(utoa::digit#2<utoa::$4) goto utoa::@7 -- vbum1_lt_vbum2_then_la1 
    lda digit
    cmp utoa__4
    bcc __b7
    // utoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [1543] utoa::$11 = (char)utoa::value -- vbum1=_byte_vwum2 
    lda value
    sta utoa__11
    // [1544] *utoa::buffer = DIGITS[utoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1545] utoa::buffer = ++ utoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1546] *utoa::buffer = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    rts
    // utoa::@7
  __b7:
    // unsigned int digit_value = digit_values[digit]
    // [1547] utoa::$10 = utoa::digit#2 << 1 -- vbum1=vbum2_rol_1 
    lda digit
    asl
    sta utoa__10
    // [1548] utoa::digit_value#0 = utoa::digit_values#8[utoa::$10] -- vwum1=pwuz2_derefidx_vbum3 
    tay
    lda (digit_values),y
    sta digit_value
    iny
    lda (digit_values),y
    sta digit_value+1
    // value >= digit_value
    // [1549] utoa::$13 = utoa::value -- vwum1=vwum2 
    lda value
    sta utoa__13
    lda value+1
    sta utoa__13+1
    // if (started || value >= digit_value)
    // [1550] if(0!=utoa::started#2) goto utoa::@10 -- 0_neq_vbum1_then_la1 
    lda started
    bne __b10
    // utoa::@11
    // [1551] if(utoa::$13<utoa::digit_value#0) goto utoa::@9 -- vwum1_lt_vwum2_then_la1 
    lda utoa__13+1
    cmp digit_value+1
    bcc __b9
    bne !+
    lda utoa__13
    cmp digit_value
    bcc __b9
  !:
    // utoa::@10
  __b10:
    // utoa_append(buffer++, value, digit_value)
    // [1552] utoa_append::buffer = utoa::buffer -- pbuz1=pbuz2 
    lda.z buffer
    sta.z utoa_append.buffer
    lda.z buffer+1
    sta.z utoa_append.buffer+1
    // [1553] utoa_append::value = utoa::value
    // [1554] utoa_append::sub = utoa::digit_value#0
    // [1555] callexecute utoa_append  -- call_vprc1 
    jsr utoa_append
    // [1556] utoa::$9 = utoa_append::return
    // value = utoa_append(buffer++, value, digit_value)
    // [1557] utoa::value = utoa::$9
    // value = utoa_append(buffer++, value, digit_value);
    // [1558] utoa::buffer = ++ utoa::buffer -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1559] phi from utoa::@10 to utoa::@9 [phi:utoa::@10->utoa::@9]
    // [1559] phi utoa::started#4 = 1 [phi:utoa::@10->utoa::@9#0] -- vbum1=vbuc1 
    lda #1
    sta started
    // [1559] phi from utoa::@11 to utoa::@9 [phi:utoa::@11->utoa::@9]
    // [1559] phi utoa::started#4 = utoa::started#2 [phi:utoa::@11->utoa::@9#0] -- register_copy 
    // utoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1560] utoa::digit#1 = ++ utoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [1540] phi from utoa::@9 to utoa::@6 [phi:utoa::@9->utoa::@6]
    // [1540] phi utoa::started#2 = utoa::started#4 [phi:utoa::@9->utoa::@6#0] -- register_copy 
    // [1540] phi utoa::digit#2 = utoa::digit#1 [phi:utoa::@9->utoa::@6#1] -- register_copy 
    jmp __b6
  .segment Data
    .label value = strlen.len
    .label radix = printf_number_buffer.len
    .label utoa__4 = printf_uchar.uvalue
    .label utoa__9 = strlen.len
    .label utoa__10 = printf_uchar.uvalue
    .label utoa__11 = printf_number_buffer.len
    digit_value: .word 0
    .label digit = uctoa.digit
    .label started = printf_number_buffer.len
    .label max_digits = printf_padding.i
    utoa__13: .word 0
}
.segment Code
  // strupr
// Converts a string to uppercase.
// char * strupr(char *str)
strupr: {
    .label str = printf_number_buffer.buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label src = 3
    // [1562] phi from strupr to strupr::@1 [phi:strupr->strupr::@1]
    // [1562] phi strupr::src#2 = strupr::str [phi:strupr->strupr::@1#0] -- pbuz1=pbuc1 
    lda #<str
    sta.z src
    lda #>str
    sta.z src+1
    // strupr::@1
  __b1:
    // while(*src)
    // [1563] if(0!=*strupr::src#2) goto strupr::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strupr::@return
    // }
    // [1564] return 
    rts
    // strupr::@2
  __b2:
    // toupper(*src)
    // [1565] toupper::ch = *strupr::src#2 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta toupper.ch
    // [1566] callexecute toupper  -- call_vprc1 
    jsr toupper
    // [1567] strupr::$0 = toupper::return
    // *src = toupper(*src)
    // [1568] *strupr::src#2 = strupr::$0 -- _deref_pbuz1=vbum2 
    lda strupr__0
    ldy #0
    sta (src),y
    // src++;
    // [1569] strupr::src#1 = ++ strupr::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [1562] phi from strupr::@2 to strupr::@1 [phi:strupr::@2->strupr::@1]
    // [1562] phi strupr::src#2 = strupr::src#1 [phi:strupr::@2->strupr::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    .label strupr__0 = printf_padding.i
}
.segment Code
  // toupper
// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
// __mem() char toupper(__mem() char ch)
toupper: {
    // if(ch>='a' && ch<='z')
    // [1570] if(toupper::ch<'a'pm) goto toupper::@2 -- vbum1_lt_vbuc1_then_la1 
    lda ch
    cmp #'a'
    bcc __b2
    // toupper::@3
    // [1571] if(toupper::ch<='z'pm) goto toupper::@1 -- vbum1_le_vbuc1_then_la1 
    lda #'z'
    cmp ch
    bcs __b1
    // toupper::@2
  __b2:
    // return ch;
    // [1572] toupper::return = toupper::ch
    // toupper::@return
    // }
    // [1573] return 
    rts
    // toupper::@1
  __b1:
    // ch + ('A'-'a')
    // [1574] toupper::$3 = toupper::ch + 'A'pm-'a'pm -- vbum1=vbum1_plus_vbuc1 
    lda #'A'-'a'
    clc
    adc toupper__3
    sta toupper__3
    // return ch + ('A'-'a');
    // [1575] toupper::return = toupper::$3
    rts
  .segment Data
    .label ch = printf_padding.i
    .label return = printf_padding.i
    .label toupper__3 = printf_padding.i
}
.segment Code
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __mem() unsigned int strlen(__zp(5) char *str)
strlen: {
    .label str = 5
    // [1577] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [1577] phi strlen::len#4 = 0 [phi:strlen->strlen::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta len
    sta len+1
    // strlen::@1
  __b1:
    // while(*str)
    // [1578] if(0!=*strlen::str) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@3
    // return len;
    // [1579] strlen::return = strlen::len#4
    // strlen::@return
    // }
    // [1580] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [1581] strlen::len#1 = ++ strlen::len#4 -- vwum1=_inc_vwum1 
    inc len
    bne !+
    inc len+1
  !:
    // str++;
    // [1582] strlen::str = ++ strlen::str -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [1577] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [1577] phi strlen::len#4 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    .label return = len
    len: .word 0
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
    .label dst = $12
    // [1584] phi from memset to memset::@1 [phi:memset->memset::@1]
    // [1584] phi memset::dst#2 = (char *)memset::str [phi:memset->memset::@1#0] -- pbuz1=pbuc1 
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
    // memset::@1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    // [1585] if(memset::dst#2!=memset::end#0) goto memset::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // memset::@return
    // }
    // [1586] return 
    rts
    // memset::@2
  __b2:
    // *dst = c
    // [1587] *memset::dst#2 = memset::c -- _deref_pbuz1=vbuc1 
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    // [1588] memset::dst#1 = ++ memset::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [1584] phi from memset::@2 to memset::@1 [phi:memset::@2->memset::@1]
    // [1584] phi memset::dst#2 = memset::dst#1 [phi:memset::@2->memset::@1#0] -- register_copy 
    jmp __b1
}
  // cbm_k_plot_get
/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
// __mem() unsigned int cbm_k_plot_get()
cbm_k_plot_get: {
    // __mem unsigned char x
    // [1589] cbm_k_plot_get::x = 0 -- vbum1=vbuc1 
    lda #0
    sta x
    // __mem unsigned char y
    // [1590] cbm_k_plot_get::y = 0 -- vbum1=vbuc1 
    sta y
    // kickasm
    // kickasm( uses cbm_k_plot_get::x uses cbm_k_plot_get::y uses CBM_PLOT) {{ sec         jsr CBM_PLOT         stx y         sty x      }}
    sec
        jsr CBM_PLOT
        stx y
        sty x
    
    // MAKEWORD(x,y)
    // [1592] cbm_k_plot_get::$0 = cbm_k_plot_get::x w= cbm_k_plot_get::y -- vwum1=vbum2_word_vbum3 
    lda x
    sta cbm_k_plot_get__0+1
    lda y
    sta cbm_k_plot_get__0
    // return MAKEWORD(x,y);
    // [1593] cbm_k_plot_get::return = cbm_k_plot_get::$0
    // cbm_k_plot_get::@return
    // }
    // [1594] return 
    rts
  .segment Data
    .label return = screenlayer.mapbase_offset
    x: .byte 0
    y: .byte 0
    .label cbm_k_plot_get__0 = screenlayer.mapbase_offset
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
// void memcpy8_vram_vram(__mem() char dbank_vram, __mem() unsigned int doffset_vram, __mem() char sbank_vram, __mem() unsigned int soffset_vram, __mem() char num8)
memcpy8_vram_vram: {
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1595] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(soffset_vram)
    // [1596] memcpy8_vram_vram::$0 = byte0  memcpy8_vram_vram::soffset_vram -- vbum1=_byte0_vwum2 
    lda soffset_vram
    sta memcpy8_vram_vram__0
    // *VERA_ADDRX_L = BYTE0(soffset_vram)
    // [1597] *VERA_ADDRX_L = memcpy8_vram_vram::$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(soffset_vram)
    // [1598] memcpy8_vram_vram::$1 = byte1  memcpy8_vram_vram::soffset_vram -- vbum1=_byte1_vwum2 
    lda soffset_vram+1
    sta memcpy8_vram_vram__1
    // *VERA_ADDRX_M = BYTE1(soffset_vram)
    // [1599] *VERA_ADDRX_M = memcpy8_vram_vram::$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // sbank_vram | VERA_INC_1
    // [1600] memcpy8_vram_vram::$2 = memcpy8_vram_vram::sbank_vram | VERA_INC_1 -- vbum1=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora memcpy8_vram_vram__2
    sta memcpy8_vram_vram__2
    // *VERA_ADDRX_H = sbank_vram | VERA_INC_1
    // [1601] *VERA_ADDRX_H = memcpy8_vram_vram::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [1602] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [1603] memcpy8_vram_vram::$3 = byte0  memcpy8_vram_vram::doffset_vram -- vbum1=_byte0_vwum2 
    lda doffset_vram
    sta memcpy8_vram_vram__3
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [1604] *VERA_ADDRX_L = memcpy8_vram_vram::$3 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [1605] memcpy8_vram_vram::$4 = byte1  memcpy8_vram_vram::doffset_vram -- vbum1=_byte1_vwum2 
    lda doffset_vram+1
    sta memcpy8_vram_vram__4
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [1606] *VERA_ADDRX_M = memcpy8_vram_vram::$4 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // dbank_vram | VERA_INC_1
    // [1607] memcpy8_vram_vram::$5 = memcpy8_vram_vram::dbank_vram | VERA_INC_1 -- vbum1=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora memcpy8_vram_vram__5
    sta memcpy8_vram_vram__5
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [1608] *VERA_ADDRX_H = memcpy8_vram_vram::$5 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
  // the size is only a byte, this is the fastest loop!
    // memcpy8_vram_vram::@1
  __b1:
    // while (num8--)
    // [1609] memcpy8_vram_vram::$6 = memcpy8_vram_vram::num8 -- vbum1=vbum2 
    lda num8
    sta memcpy8_vram_vram__6
    // [1610] memcpy8_vram_vram::num8 = -- memcpy8_vram_vram::num8 -- vbum1=_dec_vbum1 
    dec num8
    // [1611] if(0!=memcpy8_vram_vram::$6) goto memcpy8_vram_vram::@2 -- 0_neq_vbum1_then_la1 
    bne __b2
    // memcpy8_vram_vram::@return
    // }
    // [1612] return 
    rts
    // memcpy8_vram_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [1613] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    jmp __b1
  .segment Data
    dbank_vram: .byte 0
    doffset_vram: .word 0
    .label sbank_vram = insertup.insertup__6
    soffset_vram: .word 0
    .label num8 = insertup.insertup__4
    memcpy8_vram_vram__0: .byte 0
    .label memcpy8_vram_vram__1 = memcpy8_vram_vram__0
    .label memcpy8_vram_vram__2 = insertup.insertup__6
    .label memcpy8_vram_vram__3 = insertup.insertup__6
    .label memcpy8_vram_vram__4 = insertup.insertup__6
    .label memcpy8_vram_vram__5 = dbank_vram
    .label memcpy8_vram_vram__6 = insertup.insertup__6
}
  // File Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of binary digits
  RADIX_BINARY_VALUES_CHAR: .byte $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES_CHAR: .byte $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
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
  // Values of binary digits
  RADIX_BINARY_VALUES_LONG: .dword $80000000, $40000000, $20000000, $10000000, $8000000, $4000000, $2000000, $1000000, $800000, $400000, $200000, $100000, $80000, $40000, $20000, $10000, $8000, $4000, $2000, $1000, $800, $400, $200, $100, $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES_LONG: .dword $40000000, $8000000, $1000000, $200000, $40000, $8000, $1000, $200, $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_LONG: .dword $3b9aca00, $5f5e100, $989680, $f4240, $186a0, $2710, $3e8, $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_LONG: .dword $10000000, $1000000, $100000, $10000, $1000, $100, $10
.segment BramBramHeap
  bram_heap_index: .fill $800*2, 0
.segment Data
  .label isr_vsync = screenlayer.mapbase_offset
  __conio: .fill SIZEOF_STRUCT___1, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
.segment DataBramHeap
  bram_heap_segment: .fill SIZEOF_STRUCT___3, 0
  // The segment management is in main memory.
  bramheap_dx: .byte 0
  bramheap_dy: .byte 0
}
