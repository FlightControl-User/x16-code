  //
  // Commodore 128 PRG executable file
.file [name="c128-vdc-ram-refresh.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$1c01]
.segmentdef Code [start=$1c0e]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
    // File Comments
/// @file
/// Commodore 128 Registers and Memory
///
/// https://archive.org/details/C128_Programmers_Reference_Guide_1986_Bamtam_Books/page/n299/mode/2up
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Global constants and variables

    // constants
  // VDC Horizontal Total Register (R0-HTOT)
  // Bits 7-0: Total Number of Character Cells per Line
  .label VDC_R0_HTOT = 0
  // VDC Horizontal Displayed Register (R1-HDIS)
  // Bits 7-0: Number of Character Cells Displayed per Line
  .label VDC_R1_HDIS = 1
  // VDC Horizontal Sync Position Register (R2-HSST)
  // Bits 7-0: Horizontal Sync Position
  .label VDC_R2_HSST = 2
  // VDC Vertical Total Register (R4-VTOT)
  // Bits 7-0: Total Number of Raster Lines per Frame
  .label VDC_R4_VTOT = 4
  // VDC Vertical Sync Position Register (R7-VSST)
  // Bits 7-0: Vertical Sync Position
  .label VDC_R7_VSST = 7
  // VDC Display Start Address High Byte Register (R12-SAH)
  // Bits 7-0: Display Start Address High Byte
  .label VDC_R12_SAH = $c
  // VDC Display Start Address Low Byte Register (R13-SAL)
  // Bits 7-0: Display Start Address Low Byte
  .label VDC_R13_SAL = $d
  // VDC Update Address High Byte Register (R18-UADH)
  // Bits 7-0: Update Address High Byte
  .label VDC_R18_UADH = $12
  // VDC Update Address Low Byte Register (R19-UADL)
  // Bits 7-0: Update Address Low Byte
  .label VDC_R19_UADL = $13
  // VDC Character Total Horizontal Register (R22-CTHO)
  // R22(3-0) CHARACTER DISPLAYED, HORIZONTAL
  // This number sets the width of the displayed part of the character and defines the 
  // horizontal intercharacter spacing to the right of the displayed part.
  // R22(7-4) CHARACTER TOTAL, HORIZONTAL
  // The number of pixels (horizontal) in a character, minus 1. This number includes 
  // the displayed part of a character and the horizontal intercharacter spacing to the 
  // right of the displayed part.
  .label VDC_R22_CTHO = $16
  // VDC Mode Control and Smooth Horizontal Scroll Register (R25-MODE)
  // R25(3-0) SMOOTH HORIZONTAL SCROLL
  // Controls smooth horizontal scrolling by moving all characters on the screen to the left by the specified 
  // number of pixels. The value can range from 0 to R22(7-4), which defines the maximum scroll distance.
  // 
  // R25(4) PIXEL DOUBLE WIDTH
  // Controls the width of each pixel. If set to 0, the pixel width is one DCLK period. If set to 1, the pixel 
  // width is doubled, resulting in a 40-column display instead of 80.
  // 
  // R25(5) SEMIGRAPHIC MODE
  // Enables semigraphic mode, which allows the last displayed pixel of a character to extend into the 
  // horizontal intercharacter space. If set to 1, semigraphics operation occurs, allowing characters to 
  // touch the next character.
  // 
  // R25(6) ATTRIBUTE ENABLE
  // Enables or disables attribute usage. If set to 1, attributes like underline, reverse, and blink are enabled. 
  // If set to 0, attributes are disabled, reducing RAM usage, and the foreground color for all characters 
  // will be determined by R26(7-4).
  // 
  // R25(7) MODE SELECT (Text/Bitmap)
  // Selects the display mode. If set to 0, the 8563 operates in text mode. If set to 1, the 8563 operates in 
  // bitmap mode, where each pixel is controlled by a unique bit in 8563 RAM memory.
  .label VDC_R25_MODE = $19
  // R25 - 0-3 - Smooth Horizontal Scroll
  .label VDC_R25_MODE_4_PIXEL_DOUBLE_WIDTH = $10
  // R25 - 6   - Attribute Enable
  .label VDC_R25_MODE_7_MODE_SELECT = $80
  // VDC Data Register (R31-DATA)
  // Bits 7-0: Data for Block Operations
  .label VDC_R31_DATA = $1f
  // VDC DRAM Refresh Rate Register (R36-REFR)
  // R36(3-0) 8563 RAM REFRESH/SCAN LINE
  // Specifies the number of Dynamic RAM refresh cycles that occur every scan line. 
  // These refresh cycles are essential for maintaining data integrity in the 8563 RAM. 
  // The refresh operation occurs on both displayed and non-displayed scan lines, 
  // and across all areas of the screen, including blanked scan lines and vertical borders. 
  // The refresh address increments through all 65,536 addresses of the 8563 RAM.
  .label VDC_R36_REFR = $24
  // VDC Sync Polarity Register (R37-SYPL)
  // R37(3-0) HORIZONTAL SYNC POLARITY
  // Controls the polarity of the horizontal sync signal. This setting determines whether the 
  // horizontal sync pulse is active high or active low.
  //
  // R37(7-4) VERTICAL SYNC POLARITY
  // Controls the polarity of the vertical sync signal. This setting determines whether the 
  // vertical sync pulse is active high or active low.
  .label VDC_R37_SYPL = $25
  .label OFFSET_STRUCT_VDC_CONFIGURATION_VDC_TYPE = 1
  .label OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES = 2
  // VDC Ports
  .label VDC_REGISTER_PORT = $d600
  // VDC Register Select Port
  .label VDC_DATA_PORT = $d601
  .label c128_mmu = $ff00

    // variables

  .label vram = 2
    // code segment
.segment Code
  // c128_cpu_mode_fast
/**
 * @file c128-cpu.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief C128 CPU functions
 * @version 1.0
 * @date 2024-08-10
 * 
 * @copyright Copyright (c) 2024
 * 
 */
// void c128_cpu_mode_fast()
c128_cpu_mode_fast: {

    // constants

    // variables

    // asm { sei lda$D011 and#$6F ldx#$01 stx$D030 sta$D011 cli  }
  sei
  lda $d011
  and #$6f
  ldx #1
  stx $d030
  sta $d011
  cli
  // c128_cpu_mode_fast::@return
  // [39] return 
  rts
}

    // code segment
.segment Code
  // vdc_initialize
// void vdc_initialize()
vdc_initialize: {

    // constants
  .const vdc_write_register2_d = $ff
  .const vdc_write_register4_d = $27
  .const vdc_write_register5_d = $20

    // variables

    // [40] vdc_initialize::vdc_mode#0 = *VDC_REGISTER_PORT -- vbuaa=_deref_pbuc1 
  lda VDC_REGISTER_PORT
  // [41] *((char *)&vdc_config) = vdc_initialize::vdc_mode#0 -- _deref_pbuc1=vbuaa 
  sta vdc_config
  // [42] vdc_initialize::vdc_type#0 = vdc_initialize::vdc_mode#0 & 3 -- vbuaa=vbuaa_band_vbuc1 
  and #3
  // [43] *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_VDC_TYPE) = vdc_initialize::vdc_type#0 -- _deref_pbuc1=vbuaa 
  sta vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_VDC_TYPE
  // [44] if(0!=vdc_initialize::vdc_type#0) goto vdc_initialize::@1 -- 0_neq_vbuaa_then_la1 
  cmp #0
  bne __b2
  // [45] phi from vdc_initialize to vdc_initialize::@2 [phi:vdc_initialize->vdc_initialize::@2]
  // vdc_initialize::@2
  // [46] phi from vdc_initialize::@2 to vdc_initialize::@1 [phi:vdc_initialize::@2->vdc_initialize::@1]
  // [46] phi vdc_initialize::vdc_write_register1_d#0 = $40 [phi:vdc_initialize::@2->vdc_initialize::@1#0] -- vbuxx=vbuc1 
  ldx #$40
  jmp __b1
  // [46] phi from vdc_initialize to vdc_initialize::@1 [phi:vdc_initialize->vdc_initialize::@1]
__b2:
  // [46] phi vdc_initialize::vdc_write_register1_d#0 = $47 [phi:vdc_initialize->vdc_initialize::@1#0] -- vbuxx=vbuc1 
  ldx #$47
  // vdc_initialize::@1
__b1:
  // [47] phi from vdc_initialize::@1 to vdc_initialize::vdc_write_register1 [phi:vdc_initialize::@1->vdc_initialize::vdc_write_register1]
  // vdc_initialize::vdc_write_register1
  // vdc_initialize::vdc_register1
  // [48] *VDC_REGISTER_PORT = VDC_R25_MODE -- _deref_pbuc1=vbuc2 
  lda #VDC_R25_MODE
  sta VDC_REGISTER_PORT
  // [49] phi from vdc_initialize::vdc_register1 to vdc_initialize::vdc_write1 [phi:vdc_initialize::vdc_register1->vdc_initialize::vdc_write1]
  // vdc_initialize::vdc_write1
  // vdc_initialize::vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_initialize::@7
  // [51] *VDC_DATA_PORT = vdc_initialize::vdc_write_register1_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // [52] phi from vdc_initialize::@7 to vdc_initialize::@3 [phi:vdc_initialize::@7->vdc_initialize::@3]
  // [52] phi vdc_initialize::r#10 = 0 [phi:vdc_initialize::@7->vdc_initialize::@3#0] -- vbuxx=vbuc1 
  ldx #0
  // vdc_initialize::@3
__b3:
  // [53] if(vdc_initialize::r#10<$25) goto vdc_initialize::@4 -- vbuxx_lt_vbuc1_then_la1 
  cpx #$25
  bcc __b4
  // [54] phi from vdc_initialize::@3 to vdc_initialize::vdc_write_register2 [phi:vdc_initialize::@3->vdc_initialize::vdc_write_register2]
  // vdc_initialize::vdc_write_register2
  // vdc_initialize::vdc_register2
  // [55] *VDC_REGISTER_PORT = VDC_R37_SYPL -- _deref_pbuc1=vbuc2 
  lda #VDC_R37_SYPL
  sta VDC_REGISTER_PORT
  // [56] phi from vdc_initialize::vdc_register2 to vdc_initialize::vdc_write2 [phi:vdc_initialize::vdc_register2->vdc_initialize::vdc_write2]
  // vdc_initialize::vdc_write2
  // vdc_initialize::vdc_wait2
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_initialize::@9
  // [58] *VDC_DATA_PORT = vdc_initialize::vdc_write_register2_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register2_d
  sta VDC_DATA_PORT
  // vdc_initialize::@8
  // [59] vdc_initialize::vdc_pal#0 = *((char *) 678) -- vbuaa=_deref_pbuc1 
  // Patch for PAL systems
  lda $2a6
  // [60] if(0!=vdc_initialize::vdc_pal#0) goto vdc_initialize::@return -- 0_neq_vbuaa_then_la1 
  cmp #0
  bne __breturn
  // [61] phi from vdc_initialize::@8 to vdc_initialize::vdc_write_register4 [phi:vdc_initialize::@8->vdc_initialize::vdc_write_register4]
  // vdc_initialize::vdc_write_register4
  // vdc_initialize::vdc_register4
  // [62] *VDC_REGISTER_PORT = VDC_R4_VTOT -- _deref_pbuc1=vbuc2 
  lda #VDC_R4_VTOT
  sta VDC_REGISTER_PORT
  // [63] phi from vdc_initialize::vdc_register4 to vdc_initialize::vdc_write4 [phi:vdc_initialize::vdc_register4->vdc_initialize::vdc_write4]
  // vdc_initialize::vdc_write4
  // vdc_initialize::vdc_wait4
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_initialize::@11
  // [65] *VDC_DATA_PORT = vdc_initialize::vdc_write_register4_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register4_d
  sta VDC_DATA_PORT
  // [66] phi from vdc_initialize::@11 to vdc_initialize::vdc_write_register5 [phi:vdc_initialize::@11->vdc_initialize::vdc_write_register5]
  // vdc_initialize::vdc_write_register5
  // vdc_initialize::vdc_register5
  // [67] *VDC_REGISTER_PORT = VDC_R7_VSST -- _deref_pbuc1=vbuc2 
  lda #VDC_R7_VSST
  sta VDC_REGISTER_PORT
  // [68] phi from vdc_initialize::vdc_register5 to vdc_initialize::vdc_write5 [phi:vdc_initialize::vdc_register5->vdc_initialize::vdc_write5]
  // vdc_initialize::vdc_write5
  // vdc_initialize::vdc_wait5
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_initialize::@12
  // [70] *VDC_DATA_PORT = vdc_initialize::vdc_write_register5_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register5_d
  sta VDC_DATA_PORT
  // vdc_initialize::@return
__breturn:
  // [71] return 
  rts
  // vdc_initialize::@4
__b4:
  // [72] if(vdc_initialize::vdc_init[vdc_initialize::r#10]==$ff) goto vdc_initialize::@5 -- pbuc1_derefidx_vbuxx_eq_vbuc2_then_la1 
  lda vdc_init,x
  cmp #$ff
  beq __b5
  // vdc_initialize::@6
  // [73] vdc_initialize::vdc_write_register3_d#0 = vdc_initialize::vdc_init[vdc_initialize::r#10] -- vbuaa=pbuc1_derefidx_vbuxx 
  lda vdc_init,x
  // [74] phi from vdc_initialize::@6 to vdc_initialize::vdc_write_register3 [phi:vdc_initialize::@6->vdc_initialize::vdc_write_register3]
  // vdc_initialize::vdc_write_register3
  // vdc_initialize::vdc_register3
  // [75] *VDC_REGISTER_PORT = vdc_initialize::r#10 -- _deref_pbuc1=vbuxx 
  stx VDC_REGISTER_PORT
  // [76] phi from vdc_initialize::vdc_register3 to vdc_initialize::vdc_write3 [phi:vdc_initialize::vdc_register3->vdc_initialize::vdc_write3]
  // vdc_initialize::vdc_write3
  // vdc_initialize::vdc_wait3
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_initialize::@10
  // [78] *VDC_DATA_PORT = vdc_initialize::vdc_write_register3_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // vdc_initialize::@5
__b5:
  // [79] vdc_initialize::r#1 = ++ vdc_initialize::r#10 -- vbuxx=_inc_vbuxx 
  inx
  // [52] phi from vdc_initialize::@5 to vdc_initialize::@3 [phi:vdc_initialize::@5->vdc_initialize::@3]
  // [52] phi vdc_initialize::r#10 = vdc_initialize::r#1 [phi:vdc_initialize::@5->vdc_initialize::@3#0] -- register_copy 
  jmp __b3
.segment Data
  vdc_init: .byte $7e, $50, $66, $49, $20, $e0, $19, $1d, $fc, $e7, $e0, $f0, 0, 0, $20, 0, $ff, $ff, 0, 0, 8, 0, $78, $e8, $20, $ff, $f0, 0, $2f, $e7, $ff, $ff, $ff, $ff, $7d, $64, $f5
  .fill 1, 0
}

    // code segment
.segment Code
  // vdc_bitmap_256x200_wide
// void vdc_bitmap_256x200_wide(__zp(2) unsigned int start_address)
vdc_bitmap_256x200_wide: {

    // constants
  .const vdc_write_register1_d = VDC_R25_MODE_7_MODE_SELECT|VDC_R25_MODE_4_PIXEL_DOUBLE_WIDTH|7
  .const vdc_write_register2_d = $20
  .const vdc_write_register3_d = $3f
  .const vdc_write_register4_d = $33
  .const vdc_write_register5_d = $89
  .const vdc_write_register8_d = 0

    // variables

  .label start_address = 3
    // [81] phi from vdc_bitmap_256x200_wide to vdc_bitmap_256x200_wide::vdc_write_register1 [phi:vdc_bitmap_256x200_wide->vdc_bitmap_256x200_wide::vdc_write_register1]
  // vdc_bitmap_256x200_wide::vdc_write_register1
  // vdc_bitmap_256x200_wide::vdc_write_register1_vdc_register1
  // [82] *VDC_REGISTER_PORT = VDC_R25_MODE -- _deref_pbuc1=vbuc2 
  lda #VDC_R25_MODE
  sta VDC_REGISTER_PORT
  // [83] phi from vdc_bitmap_256x200_wide::vdc_write_register1_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register1_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register1_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register1_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register1_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register1_@3
  // [85] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register1_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register1_d
  sta VDC_DATA_PORT
  // [86] phi from vdc_bitmap_256x200_wide::vdc_write_register1_@3 to vdc_bitmap_256x200_wide::vdc_write_register2 [phi:vdc_bitmap_256x200_wide::vdc_write_register1_@3->vdc_bitmap_256x200_wide::vdc_write_register2]
  // vdc_bitmap_256x200_wide::vdc_write_register2
  // vdc_bitmap_256x200_wide::vdc_write_register2_vdc_register1
  // [87] *VDC_REGISTER_PORT = VDC_R1_HDIS -- _deref_pbuc1=vbuc2 
  lda #VDC_R1_HDIS
  sta VDC_REGISTER_PORT
  // [88] phi from vdc_bitmap_256x200_wide::vdc_write_register2_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register2_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register2_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register2_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register2_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register2_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register2_@3
  // [90] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register2_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register2_d
  sta VDC_DATA_PORT
  // [91] phi from vdc_bitmap_256x200_wide::vdc_write_register2_@3 to vdc_bitmap_256x200_wide::vdc_write_register3 [phi:vdc_bitmap_256x200_wide::vdc_write_register2_@3->vdc_bitmap_256x200_wide::vdc_write_register3]
  // vdc_bitmap_256x200_wide::vdc_write_register3
  // vdc_bitmap_256x200_wide::vdc_write_register3_vdc_register1
  // [92] *VDC_REGISTER_PORT = VDC_R0_HTOT -- _deref_pbuc1=vbuc2 
  lda #VDC_R0_HTOT
  sta VDC_REGISTER_PORT
  // [93] phi from vdc_bitmap_256x200_wide::vdc_write_register3_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register3_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register3_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register3_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register3_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register3_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register3_@3
  // [95] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register3_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register3_d
  sta VDC_DATA_PORT
  // [96] phi from vdc_bitmap_256x200_wide::vdc_write_register3_@3 to vdc_bitmap_256x200_wide::vdc_write_register4 [phi:vdc_bitmap_256x200_wide::vdc_write_register3_@3->vdc_bitmap_256x200_wide::vdc_write_register4]
  // vdc_bitmap_256x200_wide::vdc_write_register4
  // vdc_bitmap_256x200_wide::vdc_write_register4_vdc_register1
  // [97] *VDC_REGISTER_PORT = VDC_R2_HSST -- _deref_pbuc1=vbuc2 
  lda #VDC_R2_HSST
  sta VDC_REGISTER_PORT
  // [98] phi from vdc_bitmap_256x200_wide::vdc_write_register4_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register4_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register4_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register4_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register4_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register4_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register4_@3
  // [100] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register4_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register4_d
  sta VDC_DATA_PORT
  // [101] phi from vdc_bitmap_256x200_wide::vdc_write_register4_@3 to vdc_bitmap_256x200_wide::vdc_write_register5 [phi:vdc_bitmap_256x200_wide::vdc_write_register4_@3->vdc_bitmap_256x200_wide::vdc_write_register5]
  // vdc_bitmap_256x200_wide::vdc_write_register5
  // vdc_bitmap_256x200_wide::vdc_write_register5_vdc_register1
  // [102] *VDC_REGISTER_PORT = VDC_R22_CTHO -- _deref_pbuc1=vbuc2 
  lda #VDC_R22_CTHO
  sta VDC_REGISTER_PORT
  // [103] phi from vdc_bitmap_256x200_wide::vdc_write_register5_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register5_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register5_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register5_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register5_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register5_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register5_@3
  // [105] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register5_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register5_d
  sta VDC_DATA_PORT
  // vdc_bitmap_256x200_wide::@1
  // [106] vdc_bitmap_256x200_wide::vdc_write_register6_d#0 = byte1  vdc_bitmap_256x200_wide::start_address#0 -- vbuxx=_byte1_vwuz1 
  ldx.z start_address+1
  // [107] phi from vdc_bitmap_256x200_wide::@1 to vdc_bitmap_256x200_wide::vdc_write_register6 [phi:vdc_bitmap_256x200_wide::@1->vdc_bitmap_256x200_wide::vdc_write_register6]
  // vdc_bitmap_256x200_wide::vdc_write_register6
  // vdc_bitmap_256x200_wide::vdc_write_register6_vdc_register1
  // [108] *VDC_REGISTER_PORT = VDC_R12_SAH -- _deref_pbuc1=vbuc2 
  lda #VDC_R12_SAH
  sta VDC_REGISTER_PORT
  // [109] phi from vdc_bitmap_256x200_wide::vdc_write_register6_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register6_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register6_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register6_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register6_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register6_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register6_@3
  // [111] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register6_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // vdc_bitmap_256x200_wide::@2
  // [112] vdc_bitmap_256x200_wide::vdc_write_register7_d#0 = byte0  vdc_bitmap_256x200_wide::start_address#0 -- vbuxx=_byte0_vwuz1 
  ldx.z start_address
  // [113] phi from vdc_bitmap_256x200_wide::@2 to vdc_bitmap_256x200_wide::vdc_write_register7 [phi:vdc_bitmap_256x200_wide::@2->vdc_bitmap_256x200_wide::vdc_write_register7]
  // vdc_bitmap_256x200_wide::vdc_write_register7
  // vdc_bitmap_256x200_wide::vdc_write_register7_vdc_register1
  // [114] *VDC_REGISTER_PORT = VDC_R13_SAL -- _deref_pbuc1=vbuc2 
  lda #VDC_R13_SAL
  sta VDC_REGISTER_PORT
  // [115] phi from vdc_bitmap_256x200_wide::vdc_write_register7_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register7_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register7_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register7_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register7_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register7_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register7_@3
  // [117] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register7_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // [118] phi from vdc_bitmap_256x200_wide::vdc_write_register7_@3 to vdc_bitmap_256x200_wide::vdc_write_register8 [phi:vdc_bitmap_256x200_wide::vdc_write_register7_@3->vdc_bitmap_256x200_wide::vdc_write_register8]
  // vdc_bitmap_256x200_wide::vdc_write_register8
  // vdc_bitmap_256x200_wide::vdc_write_register8_vdc_register1
  // [119] *VDC_REGISTER_PORT = VDC_R36_REFR -- _deref_pbuc1=vbuc2 
  lda #VDC_R36_REFR
  sta VDC_REGISTER_PORT
  // [120] phi from vdc_bitmap_256x200_wide::vdc_write_register8_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register8_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register8_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register8_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register8_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register8_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register8_@3
  // [122] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register8_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register8_d
  sta VDC_DATA_PORT
  // vdc_bitmap_256x200_wide::@3
  // [123] *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) = $20 -- _deref_pbuc1=vbuc2 
  // Set DRAM refresh to minimum.
  lda #$20
  sta vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  // vdc_bitmap_256x200_wide::@return
  // [124] return 
  rts
}

    // code segment
.segment Code
  // vdc_bitmap_start
// void vdc_bitmap_start(__zp(2) unsigned int vram)
vdc_bitmap_start: {

    // constants

    // variables

  .label vram = 3
    // [238] vdc_bitmap_start::vdc_write_register1_d#0 = byte1  vdc_bitmap_start::vram#0 -- vbuxx=_byte1_vwuz1 
  ldx.z vram+1
  // [239] phi from vdc_bitmap_start to vdc_bitmap_start::vdc_write_register1 [phi:vdc_bitmap_start->vdc_bitmap_start::vdc_write_register1]
  // vdc_bitmap_start::vdc_write_register1
  // vdc_bitmap_start::vdc_write_register1_vdc_register1
  // [240] *VDC_REGISTER_PORT = VDC_R12_SAH -- _deref_pbuc1=vbuc2 
  lda #VDC_R12_SAH
  sta VDC_REGISTER_PORT
  // [241] phi from vdc_bitmap_start::vdc_write_register1_vdc_register1 to vdc_bitmap_start::vdc_write_register1_vdc_write1 [phi:vdc_bitmap_start::vdc_write_register1_vdc_register1->vdc_bitmap_start::vdc_write_register1_vdc_write1]
  // vdc_bitmap_start::vdc_write_register1_vdc_write1
  // vdc_bitmap_start::vdc_write_register1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_start::vdc_write_register1_@3
  // [243] *VDC_DATA_PORT = vdc_bitmap_start::vdc_write_register1_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // vdc_bitmap_start::@1
  // [244] vdc_bitmap_start::vdc_write_register2_d#0 = byte0  vdc_bitmap_start::vram#0 -- vbuxx=_byte0_vwuz1 
  ldx.z vram
  // [245] phi from vdc_bitmap_start::@1 to vdc_bitmap_start::vdc_write_register2 [phi:vdc_bitmap_start::@1->vdc_bitmap_start::vdc_write_register2]
  // vdc_bitmap_start::vdc_write_register2
  // vdc_bitmap_start::vdc_write_register2_vdc_register1
  // [246] *VDC_REGISTER_PORT = VDC_R13_SAL -- _deref_pbuc1=vbuc2 
  lda #VDC_R13_SAL
  sta VDC_REGISTER_PORT
  // [247] phi from vdc_bitmap_start::vdc_write_register2_vdc_register1 to vdc_bitmap_start::vdc_write_register2_vdc_write1 [phi:vdc_bitmap_start::vdc_write_register2_vdc_register1->vdc_bitmap_start::vdc_write_register2_vdc_write1]
  // vdc_bitmap_start::vdc_write_register2_vdc_write1
  // vdc_bitmap_start::vdc_write_register2_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_start::vdc_write_register2_@3
  // [249] *VDC_DATA_PORT = vdc_bitmap_start::vdc_write_register2_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // vdc_bitmap_start::@return
  // [250] return 
  rts
}

    // code segment
.segment Code
  // vdc_bitmap_background
// void vdc_bitmap_background(__zp(2) unsigned int vram, __register(Y) char b)
vdc_bitmap_background: {

    // constants

    // variables

  .label vram = 3
    // [125] vdc_bitmap_background::vdc_write_register1_d#0 = byte1  vdc_bitmap_background::vram#0 -- vbuxx=_byte1_vwuz1 
  ldx.z vram+1
  // [126] phi from vdc_bitmap_background to vdc_bitmap_background::vdc_write_register1 [phi:vdc_bitmap_background->vdc_bitmap_background::vdc_write_register1]
  // vdc_bitmap_background::vdc_write_register1
  // vdc_bitmap_background::vdc_write_register1_vdc_register1
  // [127] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [128] phi from vdc_bitmap_background::vdc_write_register1_vdc_register1 to vdc_bitmap_background::vdc_write_register1_vdc_write1 [phi:vdc_bitmap_background::vdc_write_register1_vdc_register1->vdc_bitmap_background::vdc_write_register1_vdc_write1]
  // vdc_bitmap_background::vdc_write_register1_vdc_write1
  // vdc_bitmap_background::vdc_write_register1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write_register1_@3
  // [130] *VDC_DATA_PORT = vdc_bitmap_background::vdc_write_register1_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // vdc_bitmap_background::@2
  // [131] vdc_bitmap_background::vdc_write_register2_d#0 = byte0  vdc_bitmap_background::vram#0 -- vbuxx=_byte0_vwuz1 
  ldx.z vram
  // [132] phi from vdc_bitmap_background::@2 to vdc_bitmap_background::vdc_write_register2 [phi:vdc_bitmap_background::@2->vdc_bitmap_background::vdc_write_register2]
  // vdc_bitmap_background::vdc_write_register2
  // vdc_bitmap_background::vdc_write_register2_vdc_register1
  // [133] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // [134] phi from vdc_bitmap_background::vdc_write_register2_vdc_register1 to vdc_bitmap_background::vdc_write_register2_vdc_write1 [phi:vdc_bitmap_background::vdc_write_register2_vdc_register1->vdc_bitmap_background::vdc_write_register2_vdc_write1]
  // vdc_bitmap_background::vdc_write_register2_vdc_write1
  // vdc_bitmap_background::vdc_write_register2_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write_register2_@3
  // [136] *VDC_DATA_PORT = vdc_bitmap_background::vdc_write_register2_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // vdc_bitmap_background::vdc_register1
  // [137] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // [138] phi from vdc_bitmap_background::vdc_register1 to vdc_bitmap_background::@1 [phi:vdc_bitmap_background::vdc_register1->vdc_bitmap_background::@1]
  // [138] phi vdc_bitmap_background::y#10 = 0 [phi:vdc_bitmap_background::vdc_register1->vdc_bitmap_background::@1#0] -- vbuxx=vbuc1 
  ldx #0
  // vdc_bitmap_background::@1
__b1:
  // [139] if(vdc_bitmap_background::y#10<$c8) goto vdc_bitmap_background::vdc_write1 -- vbuxx_lt_vbuc1_then_la1 
  cpx #$c8
  bcc vdc_write1
  // vdc_bitmap_background::@return
  // [140] return 
  rts
  // [141] phi from vdc_bitmap_background::@1 to vdc_bitmap_background::vdc_write1 [phi:vdc_bitmap_background::@1->vdc_bitmap_background::vdc_write1]
  // vdc_bitmap_background::vdc_write1
vdc_write1:
  // vdc_bitmap_background::vdc_write1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write1_@1
  // [143] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [144] phi from vdc_bitmap_background::vdc_write1_@1 to vdc_bitmap_background::vdc_write2 [phi:vdc_bitmap_background::vdc_write1_@1->vdc_bitmap_background::vdc_write2]
  // vdc_bitmap_background::vdc_write2
  // vdc_bitmap_background::vdc_write2_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write2_@1
  // [146] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [147] phi from vdc_bitmap_background::vdc_write2_@1 to vdc_bitmap_background::vdc_write3 [phi:vdc_bitmap_background::vdc_write2_@1->vdc_bitmap_background::vdc_write3]
  // vdc_bitmap_background::vdc_write3
  // vdc_bitmap_background::vdc_write3_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write3_@1
  // [149] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [150] phi from vdc_bitmap_background::vdc_write3_@1 to vdc_bitmap_background::vdc_write4 [phi:vdc_bitmap_background::vdc_write3_@1->vdc_bitmap_background::vdc_write4]
  // vdc_bitmap_background::vdc_write4
  // vdc_bitmap_background::vdc_write4_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write4_@1
  // [152] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [153] phi from vdc_bitmap_background::vdc_write4_@1 to vdc_bitmap_background::vdc_write5 [phi:vdc_bitmap_background::vdc_write4_@1->vdc_bitmap_background::vdc_write5]
  // vdc_bitmap_background::vdc_write5
  // vdc_bitmap_background::vdc_write5_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write5_@1
  // [155] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [156] phi from vdc_bitmap_background::vdc_write5_@1 to vdc_bitmap_background::vdc_write6 [phi:vdc_bitmap_background::vdc_write5_@1->vdc_bitmap_background::vdc_write6]
  // vdc_bitmap_background::vdc_write6
  // vdc_bitmap_background::vdc_write6_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write6_@1
  // [158] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [159] phi from vdc_bitmap_background::vdc_write6_@1 to vdc_bitmap_background::vdc_write7 [phi:vdc_bitmap_background::vdc_write6_@1->vdc_bitmap_background::vdc_write7]
  // vdc_bitmap_background::vdc_write7
  // vdc_bitmap_background::vdc_write7_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write7_@1
  // [161] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [162] phi from vdc_bitmap_background::vdc_write7_@1 to vdc_bitmap_background::vdc_write8 [phi:vdc_bitmap_background::vdc_write7_@1->vdc_bitmap_background::vdc_write8]
  // vdc_bitmap_background::vdc_write8
  // vdc_bitmap_background::vdc_write8_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write8_@1
  // [164] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [165] phi from vdc_bitmap_background::vdc_write8_@1 to vdc_bitmap_background::vdc_write9 [phi:vdc_bitmap_background::vdc_write8_@1->vdc_bitmap_background::vdc_write9]
  // vdc_bitmap_background::vdc_write9
  // vdc_bitmap_background::vdc_write9_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write9_@1
  // [167] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [168] phi from vdc_bitmap_background::vdc_write9_@1 to vdc_bitmap_background::vdc_write10 [phi:vdc_bitmap_background::vdc_write9_@1->vdc_bitmap_background::vdc_write10]
  // vdc_bitmap_background::vdc_write10
  // vdc_bitmap_background::vdc_write10_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write10_@1
  // [170] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [171] phi from vdc_bitmap_background::vdc_write10_@1 to vdc_bitmap_background::vdc_write11 [phi:vdc_bitmap_background::vdc_write10_@1->vdc_bitmap_background::vdc_write11]
  // vdc_bitmap_background::vdc_write11
  // vdc_bitmap_background::vdc_write11_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write11_@1
  // [173] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [174] phi from vdc_bitmap_background::vdc_write11_@1 to vdc_bitmap_background::vdc_write12 [phi:vdc_bitmap_background::vdc_write11_@1->vdc_bitmap_background::vdc_write12]
  // vdc_bitmap_background::vdc_write12
  // vdc_bitmap_background::vdc_write12_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write12_@1
  // [176] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [177] phi from vdc_bitmap_background::vdc_write12_@1 to vdc_bitmap_background::vdc_write13 [phi:vdc_bitmap_background::vdc_write12_@1->vdc_bitmap_background::vdc_write13]
  // vdc_bitmap_background::vdc_write13
  // vdc_bitmap_background::vdc_write13_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write13_@1
  // [179] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [180] phi from vdc_bitmap_background::vdc_write13_@1 to vdc_bitmap_background::vdc_write14 [phi:vdc_bitmap_background::vdc_write13_@1->vdc_bitmap_background::vdc_write14]
  // vdc_bitmap_background::vdc_write14
  // vdc_bitmap_background::vdc_write14_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write14_@1
  // [182] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [183] phi from vdc_bitmap_background::vdc_write14_@1 to vdc_bitmap_background::vdc_write15 [phi:vdc_bitmap_background::vdc_write14_@1->vdc_bitmap_background::vdc_write15]
  // vdc_bitmap_background::vdc_write15
  // vdc_bitmap_background::vdc_write15_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write15_@1
  // [185] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [186] phi from vdc_bitmap_background::vdc_write15_@1 to vdc_bitmap_background::vdc_write16 [phi:vdc_bitmap_background::vdc_write15_@1->vdc_bitmap_background::vdc_write16]
  // vdc_bitmap_background::vdc_write16
  // vdc_bitmap_background::vdc_write16_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write16_@1
  // [188] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [189] phi from vdc_bitmap_background::vdc_write16_@1 to vdc_bitmap_background::vdc_write17 [phi:vdc_bitmap_background::vdc_write16_@1->vdc_bitmap_background::vdc_write17]
  // vdc_bitmap_background::vdc_write17
  // vdc_bitmap_background::vdc_write17_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write17_@1
  // [191] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [192] phi from vdc_bitmap_background::vdc_write17_@1 to vdc_bitmap_background::vdc_write18 [phi:vdc_bitmap_background::vdc_write17_@1->vdc_bitmap_background::vdc_write18]
  // vdc_bitmap_background::vdc_write18
  // vdc_bitmap_background::vdc_write18_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write18_@1
  // [194] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [195] phi from vdc_bitmap_background::vdc_write18_@1 to vdc_bitmap_background::vdc_write19 [phi:vdc_bitmap_background::vdc_write18_@1->vdc_bitmap_background::vdc_write19]
  // vdc_bitmap_background::vdc_write19
  // vdc_bitmap_background::vdc_write19_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write19_@1
  // [197] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [198] phi from vdc_bitmap_background::vdc_write19_@1 to vdc_bitmap_background::vdc_write20 [phi:vdc_bitmap_background::vdc_write19_@1->vdc_bitmap_background::vdc_write20]
  // vdc_bitmap_background::vdc_write20
  // vdc_bitmap_background::vdc_write20_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write20_@1
  // [200] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [201] phi from vdc_bitmap_background::vdc_write20_@1 to vdc_bitmap_background::vdc_write21 [phi:vdc_bitmap_background::vdc_write20_@1->vdc_bitmap_background::vdc_write21]
  // vdc_bitmap_background::vdc_write21
  // vdc_bitmap_background::vdc_write21_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write21_@1
  // [203] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [204] phi from vdc_bitmap_background::vdc_write21_@1 to vdc_bitmap_background::vdc_write22 [phi:vdc_bitmap_background::vdc_write21_@1->vdc_bitmap_background::vdc_write22]
  // vdc_bitmap_background::vdc_write22
  // vdc_bitmap_background::vdc_write22_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write22_@1
  // [206] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [207] phi from vdc_bitmap_background::vdc_write22_@1 to vdc_bitmap_background::vdc_write23 [phi:vdc_bitmap_background::vdc_write22_@1->vdc_bitmap_background::vdc_write23]
  // vdc_bitmap_background::vdc_write23
  // vdc_bitmap_background::vdc_write23_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write23_@1
  // [209] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [210] phi from vdc_bitmap_background::vdc_write23_@1 to vdc_bitmap_background::vdc_write24 [phi:vdc_bitmap_background::vdc_write23_@1->vdc_bitmap_background::vdc_write24]
  // vdc_bitmap_background::vdc_write24
  // vdc_bitmap_background::vdc_write24_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write24_@1
  // [212] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [213] phi from vdc_bitmap_background::vdc_write24_@1 to vdc_bitmap_background::vdc_write25 [phi:vdc_bitmap_background::vdc_write24_@1->vdc_bitmap_background::vdc_write25]
  // vdc_bitmap_background::vdc_write25
  // vdc_bitmap_background::vdc_write25_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write25_@1
  // [215] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [216] phi from vdc_bitmap_background::vdc_write25_@1 to vdc_bitmap_background::vdc_write26 [phi:vdc_bitmap_background::vdc_write25_@1->vdc_bitmap_background::vdc_write26]
  // vdc_bitmap_background::vdc_write26
  // vdc_bitmap_background::vdc_write26_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write26_@1
  // [218] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [219] phi from vdc_bitmap_background::vdc_write26_@1 to vdc_bitmap_background::vdc_write27 [phi:vdc_bitmap_background::vdc_write26_@1->vdc_bitmap_background::vdc_write27]
  // vdc_bitmap_background::vdc_write27
  // vdc_bitmap_background::vdc_write27_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write27_@1
  // [221] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [222] phi from vdc_bitmap_background::vdc_write27_@1 to vdc_bitmap_background::vdc_write28 [phi:vdc_bitmap_background::vdc_write27_@1->vdc_bitmap_background::vdc_write28]
  // vdc_bitmap_background::vdc_write28
  // vdc_bitmap_background::vdc_write28_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write28_@1
  // [224] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [225] phi from vdc_bitmap_background::vdc_write28_@1 to vdc_bitmap_background::vdc_write29 [phi:vdc_bitmap_background::vdc_write28_@1->vdc_bitmap_background::vdc_write29]
  // vdc_bitmap_background::vdc_write29
  // vdc_bitmap_background::vdc_write29_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write29_@1
  // [227] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [228] phi from vdc_bitmap_background::vdc_write29_@1 to vdc_bitmap_background::vdc_write30 [phi:vdc_bitmap_background::vdc_write29_@1->vdc_bitmap_background::vdc_write30]
  // vdc_bitmap_background::vdc_write30
  // vdc_bitmap_background::vdc_write30_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write30_@1
  // [230] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [231] phi from vdc_bitmap_background::vdc_write30_@1 to vdc_bitmap_background::vdc_write31 [phi:vdc_bitmap_background::vdc_write30_@1->vdc_bitmap_background::vdc_write31]
  // vdc_bitmap_background::vdc_write31
  // vdc_bitmap_background::vdc_write31_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write31_@1
  // [233] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // [234] phi from vdc_bitmap_background::vdc_write31_@1 to vdc_bitmap_background::vdc_write32 [phi:vdc_bitmap_background::vdc_write31_@1->vdc_bitmap_background::vdc_write32]
  // vdc_bitmap_background::vdc_write32
  // vdc_bitmap_background::vdc_write32_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write32_@1
  // [236] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuyy 
  sty VDC_DATA_PORT
  // vdc_bitmap_background::@3
  // [237] vdc_bitmap_background::y#1 = ++ vdc_bitmap_background::y#10 -- vbuxx=_inc_vbuxx 
  inx
  // [138] phi from vdc_bitmap_background::@3 to vdc_bitmap_background::@1 [phi:vdc_bitmap_background::@3->vdc_bitmap_background::@1]
  // [138] phi vdc_bitmap_background::y#10 = vdc_bitmap_background::y#1 [phi:vdc_bitmap_background::@3->vdc_bitmap_background::@1#0] -- register_copy 
  jmp __b1
}

    // code segment
.segment Code
  // main
// void main()
main: {

    // constants
  .const vdc_write_register1_d = 0
  .const vdc_write_register2_d = 0
  .const vdc_write_register3_d = 0
  .const vdc_write_register4_d = 1

    // variables

  .label background = 5
    // asm { sei  }
  sei
  // [1] *c128_mmu = $e -- _deref_pbuc1=vbuc2 
  // Disable interrupts
  // Set the bank to RAM all
  lda #$e
  sta c128_mmu
  // [2] call c128_cpu_mode_fast
  // Set the CPU to fast mode
  jsr c128_cpu_mode_fast
  // [3] phi from main to main::@4 [phi:main->main::@4]
  // main::@4
  // [4] call vdc_initialize
  jsr vdc_initialize
  // [5] phi from main::@4 to main::vdc_write_register1 [phi:main::@4->main::vdc_write_register1]
  // main::vdc_write_register1
  // main::vdc_write_register1_vdc_register1
  // [6] *VDC_REGISTER_PORT = VDC_R36_REFR -- _deref_pbuc1=vbuc2 
  lda #VDC_R36_REFR
  sta VDC_REGISTER_PORT
  // [7] phi from main::vdc_write_register1_vdc_register1 to main::vdc_write_register1_vdc_write1 [phi:main::vdc_write_register1_vdc_register1->main::vdc_write_register1_vdc_write1]
  // main::vdc_write_register1_vdc_write1
  // main::vdc_write_register1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::vdc_write_register1_@3
  // [9] *VDC_DATA_PORT = main::vdc_write_register1_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register1_d
  sta VDC_DATA_PORT
  // [10] phi from main::vdc_write_register1_@3 to main::vdc_write_register2 [phi:main::vdc_write_register1_@3->main::vdc_write_register2]
  // main::vdc_write_register2
  // main::vdc_write_register2_vdc_register1
  // [11] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [12] phi from main::vdc_write_register2_vdc_register1 to main::vdc_write_register2_vdc_write1 [phi:main::vdc_write_register2_vdc_register1->main::vdc_write_register2_vdc_write1]
  // main::vdc_write_register2_vdc_write1
  // main::vdc_write_register2_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::vdc_write_register2_@3
  // [14] *VDC_DATA_PORT = main::vdc_write_register2_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register2_d
  sta VDC_DATA_PORT
  // [15] phi from main::vdc_write_register2_@3 to main::vdc_write_register3 [phi:main::vdc_write_register2_@3->main::vdc_write_register3]
  // main::vdc_write_register3
  // main::vdc_write_register3_vdc_register1
  // [16] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // [17] phi from main::vdc_write_register3_vdc_register1 to main::vdc_write_register3_vdc_write1 [phi:main::vdc_write_register3_vdc_register1->main::vdc_write_register3_vdc_write1]
  // main::vdc_write_register3_vdc_write1
  // main::vdc_write_register3_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::vdc_write_register3_@3
  // [19] *VDC_DATA_PORT = main::vdc_write_register3_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register3_d
  sta VDC_DATA_PORT
  // [20] phi from main::vdc_write_register3_@3 to main::vdc_write_register4 [phi:main::vdc_write_register3_@3->main::vdc_write_register4]
  // main::vdc_write_register4
  // main::vdc_write_register4_vdc_register1
  // [21] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // [22] phi from main::vdc_write_register4_vdc_register1 to main::vdc_write_register4_vdc_write1 [phi:main::vdc_write_register4_vdc_register1->main::vdc_write_register4_vdc_write1]
  // main::vdc_write_register4_vdc_write1
  // main::vdc_write_register4_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::vdc_write_register4_@3
  // [24] *VDC_DATA_PORT = main::vdc_write_register4_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register4_d
  sta VDC_DATA_PORT
  // main::@2
  // [25] vdc_bitmap_256x200_wide::start_address#0 = *vram_addresses -- vwuz1=_deref_pwuc1 
  lda vram_addresses
  sta.z vdc_bitmap_256x200_wide.start_address
  lda vram_addresses+1
  sta.z vdc_bitmap_256x200_wide.start_address+1
  // [26] call vdc_bitmap_256x200_wide
// Configure the VDC for 320x200 bitmap mode with the specified start address
  // [80] phi from main::@2 to vdc_bitmap_256x200_wide [phi:main::@2->vdc_bitmap_256x200_wide]
  jsr vdc_bitmap_256x200_wide
  // [27] phi from main::@2 to main::@1 [phi:main::@2->main::@1]
  // [27] phi main::background#2 = 0 [phi:main::@2->main::@1#0] -- vbuz1=vbuc1 
  lda #0
  sta.z background
  // [27] phi vram#10 = 1 [phi:main::@2->main::@1#1] -- vbuz1=vbuc1 
  lda #1
  sta.z vram
  // main::@1
__b1:
  // main::vdc_wait_vblank1
  // asm { lda#$20 !: bitVDC_REGISTER_PORT beq!-  }
  lda #$20
!:
  bit VDC_REGISTER_PORT
  beq !-
  // main::@3
  // [29] main::$11 = vram#10 << 1 -- vbuaa=vbuz1_rol_1 
  lda.z vram
  asl
  // [30] vdc_bitmap_background::vram#0 = vram_addresses[main::$11] -- vwuz1=pwuc1_derefidx_vbuaa 
  tay
  lda vram_addresses,y
  sta.z vdc_bitmap_background.vram
  lda vram_addresses+1,y
  sta.z vdc_bitmap_background.vram+1
  // [31] vdc_bitmap_background::b#0 = main::background#2 -- vbuyy=vbuz1 
  ldy.z background
  // [32] call vdc_bitmap_background
  jsr vdc_bitmap_background
  // main::@5
  // [33] main::background#1 = ++ main::background#2 -- vbuz1=_inc_vbuz1 
  inc.z background
  // [34] main::$12 = vram#10 << 1 -- vbuaa=vbuz1_rol_1 
  lda.z vram
  asl
  // [35] vdc_bitmap_start::vram#0 = vram_addresses[main::$12] -- vwuz1=pwuc1_derefidx_vbuaa 
  tay
  lda vram_addresses,y
  sta.z vdc_bitmap_start.vram
  lda vram_addresses+1,y
  sta.z vdc_bitmap_start.vram+1
  // [36] call vdc_bitmap_start
  jsr vdc_bitmap_start
  // main::@6
  // [37] vram#1 = vram#10 ^ 1 -- vbuz1=vbuz1_bxor_vbuc1 
  lda #1
  eor.z vram
  sta.z vram
  // [27] phi from main::@6 to main::@1 [phi:main::@6->main::@1]
  // [27] phi main::background#2 = main::background#1 [phi:main::@6->main::@1#0] -- register_copy 
  // [27] phi vram#10 = vram#1 [phi:main::@6->main::@1#1] -- register_copy 
  jmp __b1
}

    // File Data Internal or Ignore
.segment Data
  vram_addresses: .word 0, $2000
.segment Data
  vdc_config: .byte 0, 0, $50

