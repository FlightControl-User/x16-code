  // File Comments
/// @file
/// Functions for printing formatted strings
/// @file
/// C standard library stdlib.h
///
/// Implementation of functions found int C stdlib.h / stdlib.c
/// NULL pointer
  // Upstart
.cpu _65c02
  // Commander X16 PRG executable file
.file [name="cx16-asm-call.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)

  // Global Constants & labels
  .const g1 = 0
  .const l1 = 0
  .const l2 = 0
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
    jsr main
    // __start::@return
    // [5] return 
    rts
}
  // main
main: {
    .label ch = $3000
    // *ch = var.m1
    // [6] *main::ch = 3+1+2 -- _deref_pbuc1=vbuc2 
    lda #3+1+2
    sta ch
    // *ch = var.m2
    // [7] *main::ch = 3+1 -- _deref_pbuc1=vbuc2 
    lda #3+1
    sta ch
    // main::@return
    // }
    // [8] return 
    rts
}
  // File Data
.segment Data
  isr_vsync: .word $314
