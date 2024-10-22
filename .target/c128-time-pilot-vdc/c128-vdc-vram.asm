  //
  // Commodore 128 PRG executable file
.file [name="c128-vdc-vram.prg", type="prg", segments="Program"]
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
  // VDC Vertical Smooth Scroll and Control Register (R24-VSST)
  // R24(4-0) VERTICAL SMOOTH SCROLL
  // Controls vertical smooth scrolling by skipping scan lines to create a smooth upward
  // scroll effect. The value can range from 0 to R9(4-0), which defines the maximum
  // number of scan lines that can be scrolled smoothly before needing to adjust the 
  // display start address.
  //
  // R24(5) CHARACTER BLINK RATE
  // Determines the blink rate of characters when the attribute is enabled. 
  // 0 = Blink rate is 1/16th of the frame rate, 1 = Blink rate is 1/32nd of the frame rate.
  //
  // R24(6) REVERSE SCREEN
  // Controls the screen color inversion. 
  // 0 = Normal foreground/background colors, 1 = Reversed foreground/background colors.
  //
  // R24(7) BLOCK COPY
  // Enables block copy operations. 
  // 0 = Block Write mode, 1 = Block Copy mode.
  .label VDC_R24_VSST = $18
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
  // VDC Word Count Register (R30-WORD)
  // Bits 7-0: Word Count for Block Operations
  .label VDC_R30_WORD = $1e
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
  .label OFFSET_STRUCT_SPRITE_S_X = 6
  .label OFFSET_STRUCT_SPRITE_S_Y = 7
  .label OFFSET_STRUCT_SPRITE_S_PX = 4
  .label OFFSET_STRUCT_SPRITE_S_PY = 5
  .label OFFSET_STRUCT_SPRITE_S_SX = 8
  .label OFFSET_STRUCT_SPRITE_S_SY = 9
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
  // [619] return 
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

    // [620] vdc_initialize::vdc_mode#0 = *VDC_REGISTER_PORT -- vbuaa=_deref_pbuc1 
  lda VDC_REGISTER_PORT
  // [621] *((char *)&vdc_config) = vdc_initialize::vdc_mode#0 -- _deref_pbuc1=vbuaa 
  sta vdc_config
  // [622] vdc_initialize::vdc_type#0 = vdc_initialize::vdc_mode#0 & 3 -- vbuaa=vbuaa_band_vbuc1 
  and #3
  // [623] *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_VDC_TYPE) = vdc_initialize::vdc_type#0 -- _deref_pbuc1=vbuaa 
  sta vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_VDC_TYPE
  // [624] if(0!=vdc_initialize::vdc_type#0) goto vdc_initialize::@1 -- 0_neq_vbuaa_then_la1 
  cmp #0
  bne __b2
  // [625] phi from vdc_initialize to vdc_initialize::@2 [phi:vdc_initialize->vdc_initialize::@2]
  // vdc_initialize::@2
  // [626] phi from vdc_initialize::@2 to vdc_initialize::@1 [phi:vdc_initialize::@2->vdc_initialize::@1]
  // [626] phi vdc_initialize::vdc_write_register1_d#0 = $40 [phi:vdc_initialize::@2->vdc_initialize::@1#0] -- vbuxx=vbuc1 
  ldx #$40
  jmp __b1
  // [626] phi from vdc_initialize to vdc_initialize::@1 [phi:vdc_initialize->vdc_initialize::@1]
__b2:
  // [626] phi vdc_initialize::vdc_write_register1_d#0 = $47 [phi:vdc_initialize->vdc_initialize::@1#0] -- vbuxx=vbuc1 
  ldx #$47
  // vdc_initialize::@1
__b1:
  // [627] phi from vdc_initialize::@1 to vdc_initialize::vdc_write_register1 [phi:vdc_initialize::@1->vdc_initialize::vdc_write_register1]
  // vdc_initialize::vdc_write_register1
  // vdc_initialize::vdc_register1
  // [628] *VDC_REGISTER_PORT = VDC_R25_MODE -- _deref_pbuc1=vbuc2 
  lda #VDC_R25_MODE
  sta VDC_REGISTER_PORT
  // [629] phi from vdc_initialize::vdc_register1 to vdc_initialize::vdc_write1 [phi:vdc_initialize::vdc_register1->vdc_initialize::vdc_write1]
  // vdc_initialize::vdc_write1
  // vdc_initialize::vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_initialize::@7
  // [631] *VDC_DATA_PORT = vdc_initialize::vdc_write_register1_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // [632] phi from vdc_initialize::@7 to vdc_initialize::@3 [phi:vdc_initialize::@7->vdc_initialize::@3]
  // [632] phi vdc_initialize::r#10 = 0 [phi:vdc_initialize::@7->vdc_initialize::@3#0] -- vbuxx=vbuc1 
  ldx #0
  // vdc_initialize::@3
__b3:
  // [633] if(vdc_initialize::r#10<$25) goto vdc_initialize::@4 -- vbuxx_lt_vbuc1_then_la1 
  cpx #$25
  bcc __b4
  // [634] phi from vdc_initialize::@3 to vdc_initialize::vdc_write_register2 [phi:vdc_initialize::@3->vdc_initialize::vdc_write_register2]
  // vdc_initialize::vdc_write_register2
  // vdc_initialize::vdc_register2
  // [635] *VDC_REGISTER_PORT = VDC_R37_SYPL -- _deref_pbuc1=vbuc2 
  lda #VDC_R37_SYPL
  sta VDC_REGISTER_PORT
  // [636] phi from vdc_initialize::vdc_register2 to vdc_initialize::vdc_write2 [phi:vdc_initialize::vdc_register2->vdc_initialize::vdc_write2]
  // vdc_initialize::vdc_write2
  // vdc_initialize::vdc_wait2
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_initialize::@9
  // [638] *VDC_DATA_PORT = vdc_initialize::vdc_write_register2_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register2_d
  sta VDC_DATA_PORT
  // vdc_initialize::@8
  // [639] vdc_initialize::vdc_pal#0 = *((char *) 678) -- vbuaa=_deref_pbuc1 
  // Patch for PAL systems
  lda $2a6
  // [640] if(0!=vdc_initialize::vdc_pal#0) goto vdc_initialize::@return -- 0_neq_vbuaa_then_la1 
  cmp #0
  bne __breturn
  // [641] phi from vdc_initialize::@8 to vdc_initialize::vdc_write_register4 [phi:vdc_initialize::@8->vdc_initialize::vdc_write_register4]
  // vdc_initialize::vdc_write_register4
  // vdc_initialize::vdc_register4
  // [642] *VDC_REGISTER_PORT = VDC_R4_VTOT -- _deref_pbuc1=vbuc2 
  lda #VDC_R4_VTOT
  sta VDC_REGISTER_PORT
  // [643] phi from vdc_initialize::vdc_register4 to vdc_initialize::vdc_write4 [phi:vdc_initialize::vdc_register4->vdc_initialize::vdc_write4]
  // vdc_initialize::vdc_write4
  // vdc_initialize::vdc_wait4
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_initialize::@11
  // [645] *VDC_DATA_PORT = vdc_initialize::vdc_write_register4_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register4_d
  sta VDC_DATA_PORT
  // [646] phi from vdc_initialize::@11 to vdc_initialize::vdc_write_register5 [phi:vdc_initialize::@11->vdc_initialize::vdc_write_register5]
  // vdc_initialize::vdc_write_register5
  // vdc_initialize::vdc_register5
  // [647] *VDC_REGISTER_PORT = VDC_R7_VSST -- _deref_pbuc1=vbuc2 
  lda #VDC_R7_VSST
  sta VDC_REGISTER_PORT
  // [648] phi from vdc_initialize::vdc_register5 to vdc_initialize::vdc_write5 [phi:vdc_initialize::vdc_register5->vdc_initialize::vdc_write5]
  // vdc_initialize::vdc_write5
  // vdc_initialize::vdc_wait5
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_initialize::@12
  // [650] *VDC_DATA_PORT = vdc_initialize::vdc_write_register5_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register5_d
  sta VDC_DATA_PORT
  // vdc_initialize::@return
__breturn:
  // [651] return 
  rts
  // vdc_initialize::@4
__b4:
  // [652] if(vdc_initialize::vdc_init[vdc_initialize::r#10]==$ff) goto vdc_initialize::@5 -- pbuc1_derefidx_vbuxx_eq_vbuc2_then_la1 
  lda vdc_init,x
  cmp #$ff
  beq __b5
  // vdc_initialize::@6
  // [653] vdc_initialize::vdc_write_register3_d#0 = vdc_initialize::vdc_init[vdc_initialize::r#10] -- vbuaa=pbuc1_derefidx_vbuxx 
  lda vdc_init,x
  // [654] phi from vdc_initialize::@6 to vdc_initialize::vdc_write_register3 [phi:vdc_initialize::@6->vdc_initialize::vdc_write_register3]
  // vdc_initialize::vdc_write_register3
  // vdc_initialize::vdc_register3
  // [655] *VDC_REGISTER_PORT = vdc_initialize::r#10 -- _deref_pbuc1=vbuxx 
  stx VDC_REGISTER_PORT
  // [656] phi from vdc_initialize::vdc_register3 to vdc_initialize::vdc_write3 [phi:vdc_initialize::vdc_register3->vdc_initialize::vdc_write3]
  // vdc_initialize::vdc_write3
  // vdc_initialize::vdc_wait3
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_initialize::@10
  // [658] *VDC_DATA_PORT = vdc_initialize::vdc_write_register3_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // vdc_initialize::@5
__b5:
  // [659] vdc_initialize::r#1 = ++ vdc_initialize::r#10 -- vbuxx=_inc_vbuxx 
  inx
  // [632] phi from vdc_initialize::@5 to vdc_initialize::@3 [phi:vdc_initialize::@5->vdc_initialize::@3]
  // [632] phi vdc_initialize::r#10 = vdc_initialize::r#1 [phi:vdc_initialize::@5->vdc_initialize::@3#0] -- register_copy 
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
  .const vdc_write_register4_d = $89
  .const vdc_write_register5_d = $33
  .const vdc_write_register8_d = 0

    // variables

  .label start_address = 3
    // [661] phi from vdc_bitmap_256x200_wide to vdc_bitmap_256x200_wide::vdc_write_register1 [phi:vdc_bitmap_256x200_wide->vdc_bitmap_256x200_wide::vdc_write_register1]
  // vdc_bitmap_256x200_wide::vdc_write_register1
  // vdc_bitmap_256x200_wide::vdc_write_register1_vdc_register1
  // [662] *VDC_REGISTER_PORT = VDC_R25_MODE -- _deref_pbuc1=vbuc2 
  lda #VDC_R25_MODE
  sta VDC_REGISTER_PORT
  // [663] phi from vdc_bitmap_256x200_wide::vdc_write_register1_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register1_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register1_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register1_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register1_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register1_@3
  // [665] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register1_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register1_d
  sta VDC_DATA_PORT
  // [666] phi from vdc_bitmap_256x200_wide::vdc_write_register1_@3 to vdc_bitmap_256x200_wide::vdc_write_register2 [phi:vdc_bitmap_256x200_wide::vdc_write_register1_@3->vdc_bitmap_256x200_wide::vdc_write_register2]
  // vdc_bitmap_256x200_wide::vdc_write_register2
  // vdc_bitmap_256x200_wide::vdc_write_register2_vdc_register1
  // [667] *VDC_REGISTER_PORT = VDC_R1_HDIS -- _deref_pbuc1=vbuc2 
  lda #VDC_R1_HDIS
  sta VDC_REGISTER_PORT
  // [668] phi from vdc_bitmap_256x200_wide::vdc_write_register2_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register2_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register2_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register2_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register2_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register2_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register2_@3
  // [670] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register2_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register2_d
  sta VDC_DATA_PORT
  // [671] phi from vdc_bitmap_256x200_wide::vdc_write_register2_@3 to vdc_bitmap_256x200_wide::vdc_write_register3 [phi:vdc_bitmap_256x200_wide::vdc_write_register2_@3->vdc_bitmap_256x200_wide::vdc_write_register3]
  // vdc_bitmap_256x200_wide::vdc_write_register3
  // vdc_bitmap_256x200_wide::vdc_write_register3_vdc_register1
  // [672] *VDC_REGISTER_PORT = VDC_R0_HTOT -- _deref_pbuc1=vbuc2 
  lda #VDC_R0_HTOT
  sta VDC_REGISTER_PORT
  // [673] phi from vdc_bitmap_256x200_wide::vdc_write_register3_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register3_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register3_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register3_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register3_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register3_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register3_@3
  // [675] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register3_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register3_d
  sta VDC_DATA_PORT
  // [676] phi from vdc_bitmap_256x200_wide::vdc_write_register3_@3 to vdc_bitmap_256x200_wide::vdc_write_register4 [phi:vdc_bitmap_256x200_wide::vdc_write_register3_@3->vdc_bitmap_256x200_wide::vdc_write_register4]
  // vdc_bitmap_256x200_wide::vdc_write_register4
  // vdc_bitmap_256x200_wide::vdc_write_register4_vdc_register1
  // [677] *VDC_REGISTER_PORT = VDC_R22_CTHO -- _deref_pbuc1=vbuc2 
  lda #VDC_R22_CTHO
  sta VDC_REGISTER_PORT
  // [678] phi from vdc_bitmap_256x200_wide::vdc_write_register4_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register4_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register4_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register4_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register4_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register4_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register4_@3
  // [680] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register4_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register4_d
  sta VDC_DATA_PORT
  // [681] phi from vdc_bitmap_256x200_wide::vdc_write_register4_@3 to vdc_bitmap_256x200_wide::vdc_write_register5 [phi:vdc_bitmap_256x200_wide::vdc_write_register4_@3->vdc_bitmap_256x200_wide::vdc_write_register5]
  // vdc_bitmap_256x200_wide::vdc_write_register5
  // vdc_bitmap_256x200_wide::vdc_write_register5_vdc_register1
  // [682] *VDC_REGISTER_PORT = VDC_R2_HSST -- _deref_pbuc1=vbuc2 
  lda #VDC_R2_HSST
  sta VDC_REGISTER_PORT
  // [683] phi from vdc_bitmap_256x200_wide::vdc_write_register5_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register5_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register5_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register5_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register5_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register5_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register5_@3
  // [685] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register5_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register5_d
  sta VDC_DATA_PORT
  // vdc_bitmap_256x200_wide::@1
  // [686] vdc_bitmap_256x200_wide::vdc_write_register6_d#0 = byte1  vdc_bitmap_256x200_wide::start_address#0 -- vbuxx=_byte1_vwuz1 
  ldx.z start_address+1
  // [687] phi from vdc_bitmap_256x200_wide::@1 to vdc_bitmap_256x200_wide::vdc_write_register6 [phi:vdc_bitmap_256x200_wide::@1->vdc_bitmap_256x200_wide::vdc_write_register6]
  // vdc_bitmap_256x200_wide::vdc_write_register6
  // vdc_bitmap_256x200_wide::vdc_write_register6_vdc_register1
  // [688] *VDC_REGISTER_PORT = VDC_R12_SAH -- _deref_pbuc1=vbuc2 
  lda #VDC_R12_SAH
  sta VDC_REGISTER_PORT
  // [689] phi from vdc_bitmap_256x200_wide::vdc_write_register6_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register6_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register6_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register6_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register6_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register6_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register6_@3
  // [691] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register6_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // vdc_bitmap_256x200_wide::@2
  // [692] vdc_bitmap_256x200_wide::vdc_write_register7_d#0 = byte0  vdc_bitmap_256x200_wide::start_address#0 -- vbuxx=_byte0_vwuz1 
  ldx.z start_address
  // [693] phi from vdc_bitmap_256x200_wide::@2 to vdc_bitmap_256x200_wide::vdc_write_register7 [phi:vdc_bitmap_256x200_wide::@2->vdc_bitmap_256x200_wide::vdc_write_register7]
  // vdc_bitmap_256x200_wide::vdc_write_register7
  // vdc_bitmap_256x200_wide::vdc_write_register7_vdc_register1
  // [694] *VDC_REGISTER_PORT = VDC_R13_SAL -- _deref_pbuc1=vbuc2 
  lda #VDC_R13_SAL
  sta VDC_REGISTER_PORT
  // [695] phi from vdc_bitmap_256x200_wide::vdc_write_register7_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register7_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register7_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register7_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register7_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register7_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register7_@3
  // [697] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register7_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // [698] phi from vdc_bitmap_256x200_wide::vdc_write_register7_@3 to vdc_bitmap_256x200_wide::vdc_write_register8 [phi:vdc_bitmap_256x200_wide::vdc_write_register7_@3->vdc_bitmap_256x200_wide::vdc_write_register8]
  // vdc_bitmap_256x200_wide::vdc_write_register8
  // vdc_bitmap_256x200_wide::vdc_write_register8_vdc_register1
  // [699] *VDC_REGISTER_PORT = VDC_R36_REFR -- _deref_pbuc1=vbuc2 
  lda #VDC_R36_REFR
  sta VDC_REGISTER_PORT
  // [700] phi from vdc_bitmap_256x200_wide::vdc_write_register8_vdc_register1 to vdc_bitmap_256x200_wide::vdc_write_register8_vdc_write1 [phi:vdc_bitmap_256x200_wide::vdc_write_register8_vdc_register1->vdc_bitmap_256x200_wide::vdc_write_register8_vdc_write1]
  // vdc_bitmap_256x200_wide::vdc_write_register8_vdc_write1
  // vdc_bitmap_256x200_wide::vdc_write_register8_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_256x200_wide::vdc_write_register8_@3
  // [702] *VDC_DATA_PORT = vdc_bitmap_256x200_wide::vdc_write_register8_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register8_d
  sta VDC_DATA_PORT
  // vdc_bitmap_256x200_wide::@3
  // [703] *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) = $20 -- _deref_pbuc1=vbuc2 
  // Set DRAM refresh to minimum.
  lda #$20
  sta vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  // vdc_bitmap_256x200_wide::@return
  // [704] return 
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
    // [783] vdc_bitmap_start::vdc_write_register1_d#0 = byte1  vdc_bitmap_start::vram#0 -- vbuxx=_byte1_vwuz1 
  ldx.z vram+1
  // [784] phi from vdc_bitmap_start to vdc_bitmap_start::vdc_write_register1 [phi:vdc_bitmap_start->vdc_bitmap_start::vdc_write_register1]
  // vdc_bitmap_start::vdc_write_register1
  // vdc_bitmap_start::vdc_write_register1_vdc_register1
  // [785] *VDC_REGISTER_PORT = VDC_R12_SAH -- _deref_pbuc1=vbuc2 
  lda #VDC_R12_SAH
  sta VDC_REGISTER_PORT
  // [786] phi from vdc_bitmap_start::vdc_write_register1_vdc_register1 to vdc_bitmap_start::vdc_write_register1_vdc_write1 [phi:vdc_bitmap_start::vdc_write_register1_vdc_register1->vdc_bitmap_start::vdc_write_register1_vdc_write1]
  // vdc_bitmap_start::vdc_write_register1_vdc_write1
  // vdc_bitmap_start::vdc_write_register1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_start::vdc_write_register1_@3
  // [788] *VDC_DATA_PORT = vdc_bitmap_start::vdc_write_register1_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // vdc_bitmap_start::@1
  // [789] vdc_bitmap_start::vdc_write_register2_d#0 = byte0  vdc_bitmap_start::vram#0 -- vbuxx=_byte0_vwuz1 
  ldx.z vram
  // [790] phi from vdc_bitmap_start::@1 to vdc_bitmap_start::vdc_write_register2 [phi:vdc_bitmap_start::@1->vdc_bitmap_start::vdc_write_register2]
  // vdc_bitmap_start::vdc_write_register2
  // vdc_bitmap_start::vdc_write_register2_vdc_register1
  // [791] *VDC_REGISTER_PORT = VDC_R13_SAL -- _deref_pbuc1=vbuc2 
  lda #VDC_R13_SAL
  sta VDC_REGISTER_PORT
  // [792] phi from vdc_bitmap_start::vdc_write_register2_vdc_register1 to vdc_bitmap_start::vdc_write_register2_vdc_write1 [phi:vdc_bitmap_start::vdc_write_register2_vdc_register1->vdc_bitmap_start::vdc_write_register2_vdc_write1]
  // vdc_bitmap_start::vdc_write_register2_vdc_write1
  // vdc_bitmap_start::vdc_write_register2_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_start::vdc_write_register2_@3
  // [794] *VDC_DATA_PORT = vdc_bitmap_start::vdc_write_register2_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // vdc_bitmap_start::@return
  // [795] return 
  rts
}

    // code segment
.segment Code
  // vdc_bitmap_background
// void vdc_bitmap_background(__zp(2) unsigned int vram, char b)
vdc_bitmap_background: {

    // constants
  .const vdc_write_register2_d = 0
  .const vdc_write_register3_d = $1f
  .const vdc_write_register4_d = 0
  .const b = 0

    // variables

  .label vram = 3
    // [749] phi from vdc_bitmap_background to vdc_bitmap_background::@1 [phi:vdc_bitmap_background->vdc_bitmap_background::@1]
  // [749] phi vdc_bitmap_background::vram#10 = vdc_bitmap_background::vram#1 [phi:vdc_bitmap_background->vdc_bitmap_background::@1#0] -- register_copy 
  // [749] phi vdc_bitmap_background::y#10 = 0 [phi:vdc_bitmap_background->vdc_bitmap_background::@1#1] -- vbuyy=vbuc1 
  ldy #0
  // vdc_bitmap_background::@1
__b1:
  // [750] if(vdc_bitmap_background::y#10<$c8) goto vdc_bitmap_background::@2 -- vbuyy_lt_vbuc1_then_la1 
  cpy #$c8
  bcc __b2
  // [751] phi from vdc_bitmap_background::@1 to vdc_bitmap_background::vdc_write_register4 [phi:vdc_bitmap_background::@1->vdc_bitmap_background::vdc_write_register4]
  // vdc_bitmap_background::vdc_write_register4
  // vdc_bitmap_background::vdc_write_register4_vdc_register1
  // [752] *VDC_REGISTER_PORT = VDC_R30_WORD -- _deref_pbuc1=vbuc2 
  lda #VDC_R30_WORD
  sta VDC_REGISTER_PORT
  // [753] phi from vdc_bitmap_background::vdc_write_register4_vdc_register1 to vdc_bitmap_background::vdc_write_register4_vdc_write1 [phi:vdc_bitmap_background::vdc_write_register4_vdc_register1->vdc_bitmap_background::vdc_write_register4_vdc_write1]
  // vdc_bitmap_background::vdc_write_register4_vdc_write1
  // vdc_bitmap_background::vdc_write_register4_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write_register4_@3
  // [755] *VDC_DATA_PORT = vdc_bitmap_background::vdc_write_register4_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register4_d
  sta VDC_DATA_PORT
  // vdc_bitmap_background::@return
  // [756] return 
  rts
  // vdc_bitmap_background::@2
__b2:
  // [757] vdc_bitmap_background::vdc_write_register1_d#0 = byte1  vdc_bitmap_background::vram#10 -- vbuxx=_byte1_vwuz1 
  ldx.z vram+1
  // [758] phi from vdc_bitmap_background::@2 to vdc_bitmap_background::vdc_write_register1 [phi:vdc_bitmap_background::@2->vdc_bitmap_background::vdc_write_register1]
  // vdc_bitmap_background::vdc_write_register1
  // vdc_bitmap_background::vdc_write_register1_vdc_register1
  // [759] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [760] phi from vdc_bitmap_background::vdc_write_register1_vdc_register1 to vdc_bitmap_background::vdc_write_register1_vdc_write1 [phi:vdc_bitmap_background::vdc_write_register1_vdc_register1->vdc_bitmap_background::vdc_write_register1_vdc_write1]
  // vdc_bitmap_background::vdc_write_register1_vdc_write1
  // vdc_bitmap_background::vdc_write_register1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write_register1_@3
  // [762] *VDC_DATA_PORT = vdc_bitmap_background::vdc_write_register1_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // vdc_bitmap_background::@3
  // [763] vdc_bitmap_background::vdc_write_register_nowait1_d#0 = byte0  vdc_bitmap_background::vram#10 -- vbuxx=_byte0_vwuz1 
  ldx.z vram
  // [764] phi from vdc_bitmap_background::@3 to vdc_bitmap_background::vdc_write_register_nowait1 [phi:vdc_bitmap_background::@3->vdc_bitmap_background::vdc_write_register_nowait1]
  // vdc_bitmap_background::vdc_write_register_nowait1
  // vdc_bitmap_background::vdc_write_register_nowait1_vdc_register1
  // [765] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // vdc_bitmap_background::vdc_write_register_nowait1_vdc_write_nowait1
  // [766] *VDC_DATA_PORT = vdc_bitmap_background::vdc_write_register_nowait1_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // vdc_bitmap_background::vdc_register1
  // [767] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // [768] phi from vdc_bitmap_background::vdc_register1 to vdc_bitmap_background::vdc_write1 [phi:vdc_bitmap_background::vdc_register1->vdc_bitmap_background::vdc_write1]
  // vdc_bitmap_background::vdc_write1
  // vdc_bitmap_background::vdc_write1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write1_@1
  // [770] *VDC_DATA_PORT = vdc_bitmap_background::b#0 -- _deref_pbuc1=vbuc2 
  lda #b
  sta VDC_DATA_PORT
  // [771] phi from vdc_bitmap_background::vdc_write1_@1 to vdc_bitmap_background::vdc_write_register2 [phi:vdc_bitmap_background::vdc_write1_@1->vdc_bitmap_background::vdc_write_register2]
  // vdc_bitmap_background::vdc_write_register2
  // vdc_bitmap_background::vdc_write_register2_vdc_register1
  // [772] *VDC_REGISTER_PORT = VDC_R24_VSST -- _deref_pbuc1=vbuc2 
  lda #VDC_R24_VSST
  sta VDC_REGISTER_PORT
  // [773] phi from vdc_bitmap_background::vdc_write_register2_vdc_register1 to vdc_bitmap_background::vdc_write_register2_vdc_write1 [phi:vdc_bitmap_background::vdc_write_register2_vdc_register1->vdc_bitmap_background::vdc_write_register2_vdc_write1]
  // vdc_bitmap_background::vdc_write_register2_vdc_write1
  // vdc_bitmap_background::vdc_write_register2_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write_register2_@3
  // [775] *VDC_DATA_PORT = vdc_bitmap_background::vdc_write_register2_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register2_d
  sta VDC_DATA_PORT
  // [776] phi from vdc_bitmap_background::vdc_write_register2_@3 to vdc_bitmap_background::vdc_write_register3 [phi:vdc_bitmap_background::vdc_write_register2_@3->vdc_bitmap_background::vdc_write_register3]
  // vdc_bitmap_background::vdc_write_register3
  // vdc_bitmap_background::vdc_write_register3_vdc_register1
  // [777] *VDC_REGISTER_PORT = VDC_R30_WORD -- _deref_pbuc1=vbuc2 
  lda #VDC_R30_WORD
  sta VDC_REGISTER_PORT
  // [778] phi from vdc_bitmap_background::vdc_write_register3_vdc_register1 to vdc_bitmap_background::vdc_write_register3_vdc_write1 [phi:vdc_bitmap_background::vdc_write_register3_vdc_register1->vdc_bitmap_background::vdc_write_register3_vdc_write1]
  // vdc_bitmap_background::vdc_write_register3_vdc_write1
  // vdc_bitmap_background::vdc_write_register3_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // vdc_bitmap_background::vdc_write_register3_@3
  // [780] *VDC_DATA_PORT = vdc_bitmap_background::vdc_write_register3_d#0 -- _deref_pbuc1=vbuc2 
  lda #vdc_write_register3_d
  sta VDC_DATA_PORT
  // vdc_bitmap_background::@4
  // [781] vdc_bitmap_background::vram#0 = vdc_bitmap_background::vram#10 + $20 -- vwuz1=vwuz1_plus_vbuc1 
  lda #$20
  clc
  adc.z vram
  sta.z vram
  bcc !+
  inc.z vram+1
!:
  // [782] vdc_bitmap_background::y#1 = ++ vdc_bitmap_background::y#10 -- vbuyy=_inc_vbuyy 
  iny
  // [749] phi from vdc_bitmap_background::@4 to vdc_bitmap_background::@1 [phi:vdc_bitmap_background::@4->vdc_bitmap_background::@1]
  // [749] phi vdc_bitmap_background::vram#10 = vdc_bitmap_background::vram#0 [phi:vdc_bitmap_background::@4->vdc_bitmap_background::@1#0] -- register_copy 
  // [749] phi vdc_bitmap_background::y#10 = vdc_bitmap_background::y#1 [phi:vdc_bitmap_background::@4->vdc_bitmap_background::@1#1] -- register_copy 
  jmp __b1
}

    // code segment
.segment Code
  // sprite_init
// void sprite_init()
sprite_init: {

    // constants

    // variables

  .label s = 3
  .label sprite_init__10 = 5
  .label sprite_init__15 = 5
  .label sprite_init__16 = 5
  .label sprite_init__2 = 5
  .label sprite_init__8 = 7
    // [706] phi from sprite_init to sprite_init::@1 [phi:sprite_init->sprite_init::@1]
  // [706] phi sprite_init::s#2 = 0 [phi:sprite_init->sprite_init::@1#0] -- vwuz1=vwuc1 
  lda #<0
  sta.z s
  sta.z s+1
  // sprite_init::@1
__b1:
  // [707] if(sprite_init::s#2<8) goto sprite_init::@2 -- vwuz1_lt_vbuc1_then_la1 
  lda.z s+1
  bne !+
  lda.z s
  cmp #8
  bcc __b2
!:
  // sprite_init::@return
  // [708] return 
  rts
  // sprite_init::@2
__b2:
  // [709] sprite_init::$15 = sprite_init::s#2 << 2 -- vwuz1=vwuz2_rol_2 
  lda.z s
  asl
  sta.z sprite_init__15
  lda.z s+1
  rol
  sta.z sprite_init__15+1
  asl.z sprite_init__15
  rol.z sprite_init__15+1
  // [710] sprite_init::$16 = sprite_init::$15 + sprite_init::s#2 -- vwuz1=vwuz1_plus_vwuz2 
  clc
  lda.z sprite_init__16
  adc.z s
  sta.z sprite_init__16
  lda.z sprite_init__16+1
  adc.z s+1
  sta.z sprite_init__16+1
  // [711] sprite_init::$2 = sprite_init::$16 << 1 -- vwuz1=vwuz1_rol_1 
  asl.z sprite_init__2
  rol.z sprite_init__2+1
  // [712] sprite_init::$8 = (char **)sprites + sprite_init::$2 -- qbuz1=qbuc1_plus_vwuz2 
  lda #<sprites
  clc
  adc.z sprite_init__2
  sta.z sprite_init__8
  lda #>sprites
  adc.z sprite_init__2+1
  sta.z sprite_init__8+1
  // [713] *sprite_init::$8 = fly -- _deref_qbuz1=pbuc1 
  ldy #0
  lda #<fly
  sta (sprite_init__8),y
  iny
  lda #>fly
  sta (sprite_init__8),y
  // [714] sprite_init::$10 = (char *)sprites + sprite_init::$2 -- pbuz1=pbuc1_plus_vwuz1 
  lda.z sprite_init__10
  clc
  adc #<sprites
  sta.z sprite_init__10
  lda.z sprite_init__10+1
  adc #>sprites
  sta.z sprite_init__10+1
  // [715] sprite_init::$10[OFFSET_STRUCT_SPRITE_S_X] = $ff -- pbuz1_derefidx_vbuc1=vbuc2 
  lda #$ff
  ldy #OFFSET_STRUCT_SPRITE_S_X
  sta (sprite_init__10),y
  // [716] sprite_init::$10[OFFSET_STRUCT_SPRITE_S_Y] = $ff -- pbuz1_derefidx_vbuc1=vbuc2 
  ldy #OFFSET_STRUCT_SPRITE_S_Y
  sta (sprite_init__10),y
  // [717] sprite_init::$10[OFFSET_STRUCT_SPRITE_S_PX] = 0 -- pbuz1_derefidx_vbuc1=vbuc2 
  lda #0
  ldy #OFFSET_STRUCT_SPRITE_S_PX
  sta (sprite_init__10),y
  // [718] sprite_init::$10[OFFSET_STRUCT_SPRITE_S_PY] = 0 -- pbuz1_derefidx_vbuc1=vbuc2 
  ldy #OFFSET_STRUCT_SPRITE_S_PY
  sta (sprite_init__10),y
  // [719] sprite_init::$10[OFFSET_STRUCT_SPRITE_S_SX] = $ff -- pbuz1_derefidx_vbuc1=vbuc2 
  lda #$ff
  ldy #OFFSET_STRUCT_SPRITE_S_SX
  sta (sprite_init__10),y
  // [720] sprite_init::$10[OFFSET_STRUCT_SPRITE_S_SY] = $ff -- pbuz1_derefidx_vbuc1=vbuc2 
  ldy #OFFSET_STRUCT_SPRITE_S_SY
  sta (sprite_init__10),y
  // [721] sprite_init::s#1 = ++ sprite_init::s#2 -- vwuz1=_inc_vwuz1 
  inc.z s
  bne !+
  inc.z s+1
!:
  // [706] phi from sprite_init::@2 to sprite_init::@1 [phi:sprite_init::@2->sprite_init::@1]
  // [706] phi sprite_init::s#2 = sprite_init::s#1 [phi:sprite_init::@2->sprite_init::@1#0] -- register_copy 
  jmp __b1
}

    // code segment
.segment Code
  // shift16
// void shift16(char **sprites, char *sprite)
shift16: {

    // constants

    // variables

  .label d = 9
  .label dsprite = 5
  .label i = $a
  .label r = $b
  .label row = $c
  .label s = $10
  .label shift16__2 = 7
    // [723] phi from shift16 to shift16::@1 [phi:shift16->shift16::@1]
  // [723] phi shift16::i#2 = 0 [phi:shift16->shift16::@1#0] -- vbuz1=vbuc1 
  lda #0
  sta.z i
  // shift16::@1
__b1:
  // [724] if(shift16::i#2<8) goto shift16::@2 -- vbuz1_lt_vbuc1_then_la1 
  lda.z i
  cmp #8
  bcc __b2
  // shift16::@return
  // [725] return 
  rts
  // shift16::@2
__b2:
  // [726] shift16::$7 = shift16::i#2 << 1 -- vbuaa=vbuz1_rol_1 
  lda.z i
  asl
  // [727] shift16::dsprite#0 = sprite_shifts[shift16::$7] -- pbuz1=qbuc1_derefidx_vbuaa 
  tay
  lda sprite_shifts,y
  sta.z dsprite
  lda sprite_shifts+1,y
  sta.z dsprite+1
  // [728] phi from shift16::@2 to shift16::@3 [phi:shift16::@2->shift16::@3]
  // [728] phi shift16::d#4 = 0 [phi:shift16::@2->shift16::@3#0] -- vbuz1=vbuc1 
  lda #0
  sta.z d
  // [728] phi shift16::s#3 = 0 [phi:shift16::@2->shift16::@3#1] -- vbuz1=vbuc1 
  sta.z s
  // [728] phi shift16::r#2 = 0 [phi:shift16::@2->shift16::@3#2] -- vbuz1=vbuc1 
  sta.z r
  // shift16::@3
__b3:
  // [729] if(shift16::r#2<$15) goto shift16::@4 -- vbuz1_lt_vbuc1_then_la1 
  lda.z r
  cmp #$15
  bcc __b4
  // shift16::@5
  // [730] shift16::i#1 = ++ shift16::i#2 -- vbuz1=_inc_vbuz1 
  inc.z i
  // [723] phi from shift16::@5 to shift16::@1 [phi:shift16::@5->shift16::@1]
  // [723] phi shift16::i#2 = shift16::i#1 [phi:shift16::@5->shift16::@1#0] -- register_copy 
  jmp __b1
  // shift16::@4
__b4:
  // [731] shift16::byte1#0 = fly[shift16::s#3] -- vbuyy=pbuc1_derefidx_vbuz1 
  // shift the sprite row (16 bits) one bit to the right and store in sprites[i][r] (24 bits)
  ldx.z s
  ldy fly,x
  // [732] shift16::s#1 = ++ shift16::s#3 -- vbuxx=_inc_vbuz1 
  inx
  // [733] shift16::byte2#0 = fly[shift16::s#1] -- vbuaa=pbuc1_derefidx_vbuxx 
  lda fly,x
  // [734] shift16::s#2 = ++ shift16::s#1 -- vbuz1=_inc_vbuxx 
  inx
  stx.z s
  // [735] shift16::$2 = shift16::byte1#0 w= shift16::byte2#0 -- vwuz1=vbuyy_word_vbuaa 
  sty.z shift16__2+1
  sta.z shift16__2
  // [736] shift16::row#0 = shift16::$2 dw= 0 -- vduz1=vwuz2_dword_vwuc1 
  lda #<0
  sta.z row
  sta.z row+1
  lda.z shift16__2
  sta.z row+2
  tya
  sta.z row+3
  // [737] shift16::row#1 = shift16::row#0 >> shift16::i#2 -- vduz1=vduz1_ror_vbuz2 
  ldy.z i
  cpy #0
  beq !e+
!:
  lsr.z row+3
  ror.z row+2
  ror.z row+1
  ror.z row
  dey
  bne !-
!e:
  // [738] shift16::$4 = byte3  shift16::row#1 -- vbuaa=_byte3_vduz1 
  lda.z row+3
  // [739] shift16::dsprite#0[shift16::d#4] = shift16::$4 -- pbuz1_derefidx_vbuz2=vbuaa 
  ldy.z d
  sta (dsprite),y
  // [740] shift16::d#1 = ++ shift16::d#4 -- vbuyy=_inc_vbuz1 
  iny
  // [741] shift16::$5 = byte2  shift16::row#1 -- vbuaa=_byte2_vduz1 
  lda.z row+2
  // [742] shift16::dsprite#0[shift16::d#1] = shift16::$5 -- pbuz1_derefidx_vbuyy=vbuaa 
  sta (dsprite),y
  // [743] shift16::d#2 = ++ shift16::d#1 -- vbuyy=_inc_vbuyy 
  iny
  // [744] shift16::$6 = byte1  shift16::row#1 -- vbuaa=_byte1_vduz1 
  lda.z row+1
  // [745] shift16::dsprite#0[shift16::d#2] = shift16::$6 -- pbuz1_derefidx_vbuyy=vbuaa 
  sta (dsprite),y
  // [746] shift16::d#3 = ++ shift16::d#2 -- vbuz1=_inc_vbuyy 
  iny
  sty.z d
  // [747] shift16::r#1 = ++ shift16::r#2 -- vbuz1=_inc_vbuz1 
  inc.z r
  // [728] phi from shift16::@4 to shift16::@3 [phi:shift16::@4->shift16::@3]
  // [728] phi shift16::d#4 = shift16::d#3 [phi:shift16::@4->shift16::@3#0] -- register_copy 
  // [728] phi shift16::s#3 = shift16::s#2 [phi:shift16::@4->shift16::@3#1] -- register_copy 
  // [728] phi shift16::r#2 = shift16::r#1 [phi:shift16::@4->shift16::@3#2] -- register_copy 
  jmp __b3
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

  .label draw241_main__0 = 5
  .label draw241_main__1 = 5
  .label draw241_main__5 = 5
  .label draw241_vdc_24x16_vram_ram1_vram_address = 5
  .label read241_main__0 = 5
  .label read241_main__1 = 5
  .label read241_main__5 = 5
  .label read241_vdc_24x16_ram_vram1_vdc_write_register1_d = 9
  .label read241_vdc_24x16_ram_vram1_vdc_write_register_nowait1_d = 9
  .label read241_vdc_24x16_ram_vram1_vram_address = 5
  .label s = $11
  .label sprite_shift = 3
  .label sx = $b
  .label sy = $10
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
  // [3] phi from main to main::@16 [phi:main->main::@16]
  // main::@16
  // [4] call vdc_initialize
  jsr vdc_initialize
  // [5] phi from main::@16 to main::vdc_write_register1 [phi:main::@16->main::vdc_write_register1]
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
  // main::@13
  // [25] vdc_bitmap_256x200_wide::start_address#0 = *vram_addresses -- vwuz1=_deref_pwuc1 
  lda vram_addresses
  sta.z vdc_bitmap_256x200_wide.start_address
  lda vram_addresses+1
  sta.z vdc_bitmap_256x200_wide.start_address+1
  // [26] call vdc_bitmap_256x200_wide
// Configure the VDC for 320x200 bitmap mode with the specified start address
  // [660] phi from main::@13 to vdc_bitmap_256x200_wide [phi:main::@13->vdc_bitmap_256x200_wide]
  jsr vdc_bitmap_256x200_wide
  // [27] phi from main::@13 to main::@17 [phi:main::@13->main::@17]
  // main::@17
  // [28] call sprite_init
  // [705] phi from main::@17 to sprite_init [phi:main::@17->sprite_init]
  jsr sprite_init
  // [29] phi from main::@17 to main::@18 [phi:main::@17->main::@18]
  // main::@18
  // [30] call shift16
  // [722] phi from main::@18 to shift16 [phi:main::@18->shift16]
  jsr shift16
  // main::@19
  // [31] *main::sm = 1 -- _deref_pbuc1=vbuc2 
  // Stationary matrix, the byte indicates the type of enemy, 0 is none.
  lda #1
  sta sm
  // [32] *(main::sm+1) = 1 -- _deref_pbuc1=vbuc2 
  sta sm+1
  // [33] *(main::sm+2) = 1 -- _deref_pbuc1=vbuc2 
  sta sm+2
  // [34] *(main::sm+3) = 1 -- _deref_pbuc1=vbuc2 
  sta sm+3
  // [35] *(main::sm+4) = 1 -- _deref_pbuc1=vbuc2 
  sta sm+4
  // [36] *(main::sm+5) = 1 -- _deref_pbuc1=vbuc2 
  sta sm+5
  // [37] *(main::sm+6) = 1 -- _deref_pbuc1=vbuc2 
  sta sm+6
  // [38] *(main::sm+7) = 1 -- _deref_pbuc1=vbuc2 
  sta sm+7
  // [39] phi from main::@19 to main::@1 [phi:main::@19->main::@1]
  // [39] phi vram#17 = 1 [phi:main::@19->main::@1#0] -- vbuz1=vbuc1 
  sta.z vram
  // main::@1
__b1:
  // main::vdc_wait_vblank1
  // asm { lda#$20 !: bitVDC_REGISTER_PORT beq!-  }
  lda #$20
!:
  bit VDC_REGISTER_PORT
  beq !-
  // main::@14
  // [41] main::$27 = vram#17 << 1 -- vbuaa=vbuz1_rol_1 
  lda.z vram
  asl
  // [42] vdc_bitmap_background::vram#1 = vram_addresses[main::$27] -- vwuz1=pwuc1_derefidx_vbuaa 
  tay
  lda vram_addresses,y
  sta.z vdc_bitmap_background.vram
  lda vram_addresses+1,y
  sta.z vdc_bitmap_background.vram+1
  // [43] call vdc_bitmap_background
  // [748] phi from main::@14 to vdc_bitmap_background [phi:main::@14->vdc_bitmap_background]
  jsr vdc_bitmap_background
  // [44] phi from main::@14 to main::@2 [phi:main::@14->main::@2]
  // [44] phi main::s#10 = 0 [phi:main::@14->main::@2#0] -- vbuz1=vbuc1 
  lda #0
  sta.z s
  // main::@2
__b2:
  // [45] if(main::s#10<8) goto main::@3 -- vbuz1_lt_vbuc1_then_la1 
  lda.z s
  cmp #8
  bcc __b3
  // main::@4
  // [46] main::$28 = vram#17 << 1 -- vbuaa=vbuz1_rol_1 
  lda.z vram
  asl
  // [47] vdc_bitmap_start::vram#0 = vram_addresses[main::$28] -- vwuz1=pwuc1_derefidx_vbuaa 
  tay
  lda vram_addresses,y
  sta.z vdc_bitmap_start.vram
  lda vram_addresses+1,y
  sta.z vdc_bitmap_start.vram+1
  // [48] call vdc_bitmap_start
  // // Draw stationary.
  // for(byte e = 0; e < 8*4; e++) {
  //     byte x = e % 8;
  //     byte y = e / 8;
  //     byte m = sm[e];
  //     if(m) {
  //         byte* sprite_shift = sprite_shifts[fx[s] % 8];
  //         draw24(sp + x, y, sprite_shift);
  //     }
  // }
  // if(sp >= 0x28) sd = -1;
  // if(sp <= 0x10) sd = 1;
  // sp += sd;
  jsr vdc_bitmap_start
  // main::@20
  // [49] vram#1 = vram#17 ^ 1 -- vbuz1=vbuz1_bxor_vbuc1 
  lda #1
  eor.z vram
  sta.z vram
  // [39] phi from main::@20 to main::@1 [phi:main::@20->main::@1]
  // [39] phi vram#17 = vram#1 [phi:main::@20->main::@1#0] -- register_copy 
  jmp __b1
  // main::@3
__b3:
  // [50] if(main::fx[main::s#10]<$fe-$18) goto main::@5 -- pbuc1_derefidx_vbuz1_lt_vbuc2_then_la1 
  ldy.z s
  lda fx,y
  cmp #$fe-$18
  bcc __b5
  // main::@9
  // [51] main::dx[main::s#10] = -1 -- pbsc1_derefidx_vbuz1=vbsc2 
  lda #-1
  sta dx,y
  // main::@5
__b5:
  // [52] if(main::fx[main::s#10]>=2+1) goto main::@6 -- pbuc1_derefidx_vbuz1_ge_vbuc2_then_la1 
  ldy.z s
  lda fx,y
  cmp #2+1
  bcs __b6
  // main::@10
  // [53] main::dx[main::s#10] = 1 -- pbsc1_derefidx_vbuz1=vbsc2 
  lda #1
  sta dx,y
  // main::@6
__b6:
  // [54] if(main::fy[main::s#10]<$c6-$15) goto main::@7 -- pbuc1_derefidx_vbuz1_lt_vbuc2_then_la1 
  ldy.z s
  lda fy,y
  cmp #$c6-$15
  bcc __b7
  // main::@11
  // [55] main::dy[main::s#10] = -1 -- pbsc1_derefidx_vbuz1=vbsc2 
  lda #-1
  sta dy,y
  // main::@7
__b7:
  // [56] if(main::fy[main::s#10]>=2+1) goto main::@8 -- pbuc1_derefidx_vbuz1_ge_vbuc2_then_la1 
  ldy.z s
  lda fy,y
  cmp #2+1
  bcs __b8
  // main::@12
  // [57] main::dy[main::s#10] = 1 -- pbsc1_derefidx_vbuz1=vbsc2 
  lda #1
  sta dy,y
  // main::@8
__b8:
  // [58] main::fx[main::s#10] = main::fx[main::s#10] + main::dx[main::s#10] -- pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_plus_pbsc2_derefidx_vbuz1 
  ldx.z s
  lda fx,x
  ldy dx,x
  sty.z $ff
  clc
  adc.z $ff
  sta fx,x
  // [59] main::fy[main::s#10] = main::fy[main::s#10] + main::dy[main::s#10] -- pbuc1_derefidx_vbuz1=pbuc1_derefidx_vbuz1_plus_pbsc2_derefidx_vbuz1 
  lda fy,x
  ldy dy,x
  sty.z $ff
  clc
  adc.z $ff
  sta fy,x
  // [60] main::$32 = main::fx[main::s#10] -- vbuaa=pbuc1_derefidx_vbuz1 
  ldy.z s
  lda fx,y
  // [61] main::sx#0 = main::$32 >> 3 -- vbuz1=vbuaa_ror_3 
  lsr
  lsr
  lsr
  sta.z sx
  // [62] main::sy#0 = main::fy[main::s#10] -- vbuz1=pbuc1_derefidx_vbuz2 
  lda fy,y
  sta.z sy
  // [63] main::$21 = main::fx[main::s#10] & 8-1 -- vbuaa=pbuc1_derefidx_vbuz1_band_vbuc2 
  lda #8-1
  and fx,y
  // [64] main::$31 = main::$21 << 1 -- vbuaa=vbuaa_rol_1 
  asl
  // [65] main::sprite_shift#0 = sprite_shifts[main::$31] -- pbuz1=qbuc1_derefidx_vbuaa 
  tay
  lda sprite_shifts,y
  sta.z sprite_shift
  lda sprite_shifts+1,y
  sta.z sprite_shift+1
  // main::read241
  // [66] main::read241_$5 = (unsigned int)main::sy#0 -- vwuz1=_word_vbuz2 
  lda.z sy
  sta.z read241_main__5
  lda #0
  sta.z read241_main__5+1
  // [67] main::read241_$0 = main::read241_$5 << 5 -- vwuz1=vwuz1_rol_5 
  asl.z read241_main__0
  rol.z read241_main__0+1
  asl.z read241_main__0
  rol.z read241_main__0+1
  asl.z read241_main__0
  rol.z read241_main__0+1
  asl.z read241_main__0
  rol.z read241_main__0+1
  asl.z read241_main__0
  rol.z read241_main__0+1
  // [68] main::read241_$4 = vram#17 << 1 -- vbuaa=vbuz1_rol_1 
  lda.z vram
  asl
  // [69] main::read241_$1 = vram_addresses[main::read241_$4] + main::read241_$0 -- vwuz1=pwuc1_derefidx_vbuaa_plus_vwuz1 
  tay
  clc
  lda.z read241_main__1
  adc vram_addresses,y
  sta.z read241_main__1
  lda.z read241_main__1+1
  adc vram_addresses+1,y
  sta.z read241_main__1+1
  // [70] main::read241_vdc_24x16_ram_vram1_vram_address#0 = main::read241_$1 + main::sx#0 -- vwuz1=vwuz1_plus_vbuz2 
  lda.z sx
  clc
  adc.z read241_vdc_24x16_ram_vram1_vram_address
  sta.z read241_vdc_24x16_ram_vram1_vram_address
  bcc !+
  inc.z read241_vdc_24x16_ram_vram1_vram_address+1
!:
  // [71] phi from main::read241 to main::read241_vdc_24x16_ram_vram1 [phi:main::read241->main::read241_vdc_24x16_ram_vram1]
  // main::read241_vdc_24x16_ram_vram1
  // [72] phi from main::read241_vdc_24x16_ram_vram1 to main::read241_vdc_24x16_ram_vram1_@1 [phi:main::read241_vdc_24x16_ram_vram1->main::read241_vdc_24x16_ram_vram1_@1]
  // [72] phi main::read241_vdc_24x16_ram_vram1_b#10 = 0 [phi:main::read241_vdc_24x16_ram_vram1->main::read241_vdc_24x16_ram_vram1_@1#0] -- vbuyy=vbuc1 
  ldy #0
  // [72] phi main::read241_vdc_24x16_ram_vram1_vram_address#10 = main::read241_vdc_24x16_ram_vram1_vram_address#0 [phi:main::read241_vdc_24x16_ram_vram1->main::read241_vdc_24x16_ram_vram1_@1#1] -- register_copy 
  // [72] phi main::read241_vdc_24x16_ram_vram1_row#10 = 0 [phi:main::read241_vdc_24x16_ram_vram1->main::read241_vdc_24x16_ram_vram1_@1#2] -- vbuxx=vbuc1 
  ldx #0
  // main::read241_vdc_24x16_ram_vram1_@1
read241_vdc_24x16_ram_vram1___b1:
  // [73] if(main::read241_vdc_24x16_ram_vram1_row#10<$10) goto main::read241_vdc_24x16_ram_vram1_@2 -- vbuxx_lt_vbuc1_then_la1 
  cpx #$10
  bcs !read241_vdc_24x16_ram_vram1___b2+
  jmp read241_vdc_24x16_ram_vram1___b2
!read241_vdc_24x16_ram_vram1___b2:
  // [74] phi from main::read241_vdc_24x16_ram_vram1_@1 to main::merge241 [phi:main::read241_vdc_24x16_ram_vram1_@1->main::merge241]
  // main::merge241
  // main::merge241_@2
  // [75] *sprite_buffer = *sprite_buffer | *main::sprite_shift#0 -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuz1 
  lda sprite_buffer
  ldy #0
  ora (sprite_shift),y
  sta sprite_buffer
  // [76] phi from main::merge241_@2 to main::merge241_1 [phi:main::merge241_@2->main::merge241_1]
  // main::merge241_1
  // main::merge241_2
  // [77] *(sprite_buffer+1) = *(sprite_buffer+1) | main::sprite_shift#0[1] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+1
  ldy #1
  ora (sprite_shift),y
  sta sprite_buffer+1
  // [78] phi from main::merge241_2 to main::merge241_3 [phi:main::merge241_2->main::merge241_3]
  // main::merge241_3
  // main::merge241_4
  // [79] *(sprite_buffer+2) = *(sprite_buffer+2) | main::sprite_shift#0[2] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+2
  ldy #2
  ora (sprite_shift),y
  sta sprite_buffer+2
  // [80] phi from main::merge241_4 to main::merge241_5 [phi:main::merge241_4->main::merge241_5]
  // main::merge241_5
  // main::merge241_6
  // [81] *(sprite_buffer+3) = *(sprite_buffer+3) | main::sprite_shift#0[3] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+3
  ldy #3
  ora (sprite_shift),y
  sta sprite_buffer+3
  // [82] phi from main::merge241_6 to main::merge241_7 [phi:main::merge241_6->main::merge241_7]
  // main::merge241_7
  // main::merge241_8
  // [83] *(sprite_buffer+4) = *(sprite_buffer+4) | main::sprite_shift#0[4] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+4
  ldy #4
  ora (sprite_shift),y
  sta sprite_buffer+4
  // [84] phi from main::merge241_8 to main::merge241_9 [phi:main::merge241_8->main::merge241_9]
  // main::merge241_9
  // main::merge241_10
  // [85] *(sprite_buffer+5) = *(sprite_buffer+5) | main::sprite_shift#0[5] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+5
  ldy #5
  ora (sprite_shift),y
  sta sprite_buffer+5
  // [86] phi from main::merge241_10 to main::merge241_11 [phi:main::merge241_10->main::merge241_11]
  // main::merge241_11
  // main::merge241_12
  // [87] *(sprite_buffer+6) = *(sprite_buffer+6) | main::sprite_shift#0[6] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+6
  ldy #6
  ora (sprite_shift),y
  sta sprite_buffer+6
  // [88] phi from main::merge241_12 to main::merge241_13 [phi:main::merge241_12->main::merge241_13]
  // main::merge241_13
  // main::merge241_14
  // [89] *(sprite_buffer+7) = *(sprite_buffer+7) | main::sprite_shift#0[7] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+7
  ldy #7
  ora (sprite_shift),y
  sta sprite_buffer+7
  // [90] phi from main::merge241_14 to main::merge241_15 [phi:main::merge241_14->main::merge241_15]
  // main::merge241_15
  // main::merge241_16
  // [91] *(sprite_buffer+8) = *(sprite_buffer+8) | main::sprite_shift#0[8] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+8
  ldy #8
  ora (sprite_shift),y
  sta sprite_buffer+8
  // [92] phi from main::merge241_16 to main::merge241_17 [phi:main::merge241_16->main::merge241_17]
  // main::merge241_17
  // main::merge241_18
  // [93] *(sprite_buffer+9) = *(sprite_buffer+9) | main::sprite_shift#0[9] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+9
  ldy #9
  ora (sprite_shift),y
  sta sprite_buffer+9
  // [94] phi from main::merge241_18 to main::merge241_19 [phi:main::merge241_18->main::merge241_19]
  // main::merge241_19
  // main::merge241_20
  // [95] *(sprite_buffer+$a) = *(sprite_buffer+$a) | main::sprite_shift#0[$a] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$a
  ldy #$a
  ora (sprite_shift),y
  sta sprite_buffer+$a
  // [96] phi from main::merge241_20 to main::merge241_21 [phi:main::merge241_20->main::merge241_21]
  // main::merge241_21
  // main::merge241_22
  // [97] *(sprite_buffer+$b) = *(sprite_buffer+$b) | main::sprite_shift#0[$b] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$b
  ldy #$b
  ora (sprite_shift),y
  sta sprite_buffer+$b
  // [98] phi from main::merge241_22 to main::merge241_23 [phi:main::merge241_22->main::merge241_23]
  // main::merge241_23
  // main::merge241_24
  // [99] *(sprite_buffer+$c) = *(sprite_buffer+$c) | main::sprite_shift#0[$c] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$c
  ldy #$c
  ora (sprite_shift),y
  sta sprite_buffer+$c
  // [100] phi from main::merge241_24 to main::merge241_25 [phi:main::merge241_24->main::merge241_25]
  // main::merge241_25
  // main::merge241_26
  // [101] *(sprite_buffer+$d) = *(sprite_buffer+$d) | main::sprite_shift#0[$d] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$d
  ldy #$d
  ora (sprite_shift),y
  sta sprite_buffer+$d
  // [102] phi from main::merge241_26 to main::merge241_27 [phi:main::merge241_26->main::merge241_27]
  // main::merge241_27
  // main::merge241_28
  // [103] *(sprite_buffer+$e) = *(sprite_buffer+$e) | main::sprite_shift#0[$e] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$e
  ldy #$e
  ora (sprite_shift),y
  sta sprite_buffer+$e
  // [104] phi from main::merge241_28 to main::merge241_29 [phi:main::merge241_28->main::merge241_29]
  // main::merge241_29
  // main::merge241_30
  // [105] *(sprite_buffer+$f) = *(sprite_buffer+$f) | main::sprite_shift#0[$f] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$f
  ldy #$f
  ora (sprite_shift),y
  sta sprite_buffer+$f
  // [106] phi from main::merge241_30 to main::merge241_31 [phi:main::merge241_30->main::merge241_31]
  // main::merge241_31
  // main::merge241_32
  // [107] *(sprite_buffer+$10) = *(sprite_buffer+$10) | main::sprite_shift#0[$10] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$10
  ldy #$10
  ora (sprite_shift),y
  sta sprite_buffer+$10
  // [108] phi from main::merge241_32 to main::merge241_33 [phi:main::merge241_32->main::merge241_33]
  // main::merge241_33
  // main::merge241_34
  // [109] *(sprite_buffer+$11) = *(sprite_buffer+$11) | main::sprite_shift#0[$11] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$11
  ldy #$11
  ora (sprite_shift),y
  sta sprite_buffer+$11
  // [110] phi from main::merge241_34 to main::merge241_35 [phi:main::merge241_34->main::merge241_35]
  // main::merge241_35
  // main::merge241_36
  // [111] *(sprite_buffer+$12) = *(sprite_buffer+$12) | main::sprite_shift#0[$12] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$12
  ldy #$12
  ora (sprite_shift),y
  sta sprite_buffer+$12
  // [112] phi from main::merge241_36 to main::merge241_37 [phi:main::merge241_36->main::merge241_37]
  // main::merge241_37
  // main::merge241_38
  // [113] *(sprite_buffer+$13) = *(sprite_buffer+$13) | main::sprite_shift#0[$13] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$13
  ldy #$13
  ora (sprite_shift),y
  sta sprite_buffer+$13
  // [114] phi from main::merge241_38 to main::merge241_39 [phi:main::merge241_38->main::merge241_39]
  // main::merge241_39
  // main::merge241_40
  // [115] *(sprite_buffer+$14) = *(sprite_buffer+$14) | main::sprite_shift#0[$14] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$14
  ldy #$14
  ora (sprite_shift),y
  sta sprite_buffer+$14
  // [116] phi from main::merge241_40 to main::merge241_41 [phi:main::merge241_40->main::merge241_41]
  // main::merge241_41
  // main::merge241_42
  // [117] *(sprite_buffer+$15) = *(sprite_buffer+$15) | main::sprite_shift#0[$15] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$15
  ldy #$15
  ora (sprite_shift),y
  sta sprite_buffer+$15
  // [118] phi from main::merge241_42 to main::merge241_43 [phi:main::merge241_42->main::merge241_43]
  // main::merge241_43
  // main::merge241_44
  // [119] *(sprite_buffer+$16) = *(sprite_buffer+$16) | main::sprite_shift#0[$16] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$16
  ldy #$16
  ora (sprite_shift),y
  sta sprite_buffer+$16
  // [120] phi from main::merge241_44 to main::merge241_45 [phi:main::merge241_44->main::merge241_45]
  // main::merge241_45
  // main::merge241_46
  // [121] *(sprite_buffer+$17) = *(sprite_buffer+$17) | main::sprite_shift#0[$17] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$17
  ldy #$17
  ora (sprite_shift),y
  sta sprite_buffer+$17
  // [122] phi from main::merge241_46 to main::merge241_47 [phi:main::merge241_46->main::merge241_47]
  // main::merge241_47
  // main::merge241_48
  // [123] *(sprite_buffer+$18) = *(sprite_buffer+$18) | main::sprite_shift#0[$18] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$18
  ldy #$18
  ora (sprite_shift),y
  sta sprite_buffer+$18
  // [124] phi from main::merge241_48 to main::merge241_49 [phi:main::merge241_48->main::merge241_49]
  // main::merge241_49
  // main::merge241_50
  // [125] *(sprite_buffer+$19) = *(sprite_buffer+$19) | main::sprite_shift#0[$19] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$19
  ldy #$19
  ora (sprite_shift),y
  sta sprite_buffer+$19
  // [126] phi from main::merge241_50 to main::merge241_51 [phi:main::merge241_50->main::merge241_51]
  // main::merge241_51
  // main::merge241_52
  // [127] *(sprite_buffer+$1a) = *(sprite_buffer+$1a) | main::sprite_shift#0[$1a] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$1a
  ldy #$1a
  ora (sprite_shift),y
  sta sprite_buffer+$1a
  // [128] phi from main::merge241_52 to main::merge241_53 [phi:main::merge241_52->main::merge241_53]
  // main::merge241_53
  // main::merge241_54
  // [129] *(sprite_buffer+$1b) = *(sprite_buffer+$1b) | main::sprite_shift#0[$1b] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$1b
  ldy #$1b
  ora (sprite_shift),y
  sta sprite_buffer+$1b
  // [130] phi from main::merge241_54 to main::merge241_55 [phi:main::merge241_54->main::merge241_55]
  // main::merge241_55
  // main::merge241_56
  // [131] *(sprite_buffer+$1c) = *(sprite_buffer+$1c) | main::sprite_shift#0[$1c] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$1c
  ldy #$1c
  ora (sprite_shift),y
  sta sprite_buffer+$1c
  // [132] phi from main::merge241_56 to main::merge241_57 [phi:main::merge241_56->main::merge241_57]
  // main::merge241_57
  // main::merge241_58
  // [133] *(sprite_buffer+$1d) = *(sprite_buffer+$1d) | main::sprite_shift#0[$1d] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$1d
  ldy #$1d
  ora (sprite_shift),y
  sta sprite_buffer+$1d
  // [134] phi from main::merge241_58 to main::merge241_59 [phi:main::merge241_58->main::merge241_59]
  // main::merge241_59
  // main::merge241_60
  // [135] *(sprite_buffer+$1e) = *(sprite_buffer+$1e) | main::sprite_shift#0[$1e] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$1e
  ldy #$1e
  ora (sprite_shift),y
  sta sprite_buffer+$1e
  // [136] phi from main::merge241_60 to main::merge241_61 [phi:main::merge241_60->main::merge241_61]
  // main::merge241_61
  // main::merge241_62
  // [137] *(sprite_buffer+$1f) = *(sprite_buffer+$1f) | main::sprite_shift#0[$1f] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$1f
  ldy #$1f
  ora (sprite_shift),y
  sta sprite_buffer+$1f
  // [138] phi from main::merge241_62 to main::merge241_63 [phi:main::merge241_62->main::merge241_63]
  // main::merge241_63
  // main::merge241_64
  // [139] *(sprite_buffer+$20) = *(sprite_buffer+$20) | main::sprite_shift#0[$20] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$20
  ldy #$20
  ora (sprite_shift),y
  sta sprite_buffer+$20
  // [140] phi from main::merge241_64 to main::merge241_65 [phi:main::merge241_64->main::merge241_65]
  // main::merge241_65
  // main::merge241_66
  // [141] *(sprite_buffer+$21) = *(sprite_buffer+$21) | main::sprite_shift#0[$21] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$21
  ldy #$21
  ora (sprite_shift),y
  sta sprite_buffer+$21
  // [142] phi from main::merge241_66 to main::merge241_67 [phi:main::merge241_66->main::merge241_67]
  // main::merge241_67
  // main::merge241_68
  // [143] *(sprite_buffer+$22) = *(sprite_buffer+$22) | main::sprite_shift#0[$22] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$22
  ldy #$22
  ora (sprite_shift),y
  sta sprite_buffer+$22
  // [144] phi from main::merge241_68 to main::merge241_69 [phi:main::merge241_68->main::merge241_69]
  // main::merge241_69
  // main::merge241_70
  // [145] *(sprite_buffer+$23) = *(sprite_buffer+$23) | main::sprite_shift#0[$23] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$23
  ldy #$23
  ora (sprite_shift),y
  sta sprite_buffer+$23
  // [146] phi from main::merge241_70 to main::merge241_71 [phi:main::merge241_70->main::merge241_71]
  // main::merge241_71
  // main::merge241_72
  // [147] *(sprite_buffer+$24) = *(sprite_buffer+$24) | main::sprite_shift#0[$24] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$24
  ldy #$24
  ora (sprite_shift),y
  sta sprite_buffer+$24
  // [148] phi from main::merge241_72 to main::merge241_73 [phi:main::merge241_72->main::merge241_73]
  // main::merge241_73
  // main::merge241_74
  // [149] *(sprite_buffer+$25) = *(sprite_buffer+$25) | main::sprite_shift#0[$25] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$25
  ldy #$25
  ora (sprite_shift),y
  sta sprite_buffer+$25
  // [150] phi from main::merge241_74 to main::merge241_75 [phi:main::merge241_74->main::merge241_75]
  // main::merge241_75
  // main::merge241_76
  // [151] *(sprite_buffer+$26) = *(sprite_buffer+$26) | main::sprite_shift#0[$26] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$26
  ldy #$26
  ora (sprite_shift),y
  sta sprite_buffer+$26
  // [152] phi from main::merge241_76 to main::merge241_77 [phi:main::merge241_76->main::merge241_77]
  // main::merge241_77
  // main::merge241_78
  // [153] *(sprite_buffer+$27) = *(sprite_buffer+$27) | main::sprite_shift#0[$27] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$27
  ldy #$27
  ora (sprite_shift),y
  sta sprite_buffer+$27
  // [154] phi from main::merge241_78 to main::merge241_79 [phi:main::merge241_78->main::merge241_79]
  // main::merge241_79
  // main::merge241_80
  // [155] *(sprite_buffer+$28) = *(sprite_buffer+$28) | main::sprite_shift#0[$28] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$28
  ldy #$28
  ora (sprite_shift),y
  sta sprite_buffer+$28
  // [156] phi from main::merge241_80 to main::merge241_81 [phi:main::merge241_80->main::merge241_81]
  // main::merge241_81
  // main::merge241_82
  // [157] *(sprite_buffer+$29) = *(sprite_buffer+$29) | main::sprite_shift#0[$29] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$29
  ldy #$29
  ora (sprite_shift),y
  sta sprite_buffer+$29
  // [158] phi from main::merge241_82 to main::merge241_83 [phi:main::merge241_82->main::merge241_83]
  // main::merge241_83
  // main::merge241_84
  // [159] *(sprite_buffer+$2a) = *(sprite_buffer+$2a) | main::sprite_shift#0[$2a] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$2a
  ldy #$2a
  ora (sprite_shift),y
  sta sprite_buffer+$2a
  // [160] phi from main::merge241_84 to main::merge241_85 [phi:main::merge241_84->main::merge241_85]
  // main::merge241_85
  // main::merge241_86
  // [161] *(sprite_buffer+$2b) = *(sprite_buffer+$2b) | main::sprite_shift#0[$2b] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$2b
  ldy #$2b
  ora (sprite_shift),y
  sta sprite_buffer+$2b
  // [162] phi from main::merge241_86 to main::merge241_87 [phi:main::merge241_86->main::merge241_87]
  // main::merge241_87
  // main::merge241_88
  // [163] *(sprite_buffer+$2c) = *(sprite_buffer+$2c) | main::sprite_shift#0[$2c] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$2c
  ldy #$2c
  ora (sprite_shift),y
  sta sprite_buffer+$2c
  // [164] phi from main::merge241_88 to main::merge241_89 [phi:main::merge241_88->main::merge241_89]
  // main::merge241_89
  // main::merge241_90
  // [165] *(sprite_buffer+$2d) = *(sprite_buffer+$2d) | main::sprite_shift#0[$2d] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$2d
  ldy #$2d
  ora (sprite_shift),y
  sta sprite_buffer+$2d
  // [166] phi from main::merge241_90 to main::merge241_91 [phi:main::merge241_90->main::merge241_91]
  // main::merge241_91
  // main::merge241_92
  // [167] *(sprite_buffer+$2e) = *(sprite_buffer+$2e) | main::sprite_shift#0[$2e] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$2e
  ldy #$2e
  ora (sprite_shift),y
  sta sprite_buffer+$2e
  // [168] phi from main::merge241_92 to main::merge241_93 [phi:main::merge241_92->main::merge241_93]
  // main::merge241_93
  // main::merge241_94
  // [169] *(sprite_buffer+$2f) = *(sprite_buffer+$2f) | main::sprite_shift#0[$2f] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$2f
  ldy #$2f
  ora (sprite_shift),y
  sta sprite_buffer+$2f
  // [170] phi from main::merge241_94 to main::merge241_95 [phi:main::merge241_94->main::merge241_95]
  // main::merge241_95
  // main::merge241_96
  // [171] *(sprite_buffer+$30) = *(sprite_buffer+$30) | main::sprite_shift#0[$30] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$30
  ldy #$30
  ora (sprite_shift),y
  sta sprite_buffer+$30
  // [172] phi from main::merge241_96 to main::merge241_97 [phi:main::merge241_96->main::merge241_97]
  // main::merge241_97
  // main::merge241_98
  // [173] *(sprite_buffer+$31) = *(sprite_buffer+$31) | main::sprite_shift#0[$31] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$31
  ldy #$31
  ora (sprite_shift),y
  sta sprite_buffer+$31
  // [174] phi from main::merge241_98 to main::merge241_99 [phi:main::merge241_98->main::merge241_99]
  // main::merge241_99
  // main::merge241_100
  // [175] *(sprite_buffer+$32) = *(sprite_buffer+$32) | main::sprite_shift#0[$32] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$32
  ldy #$32
  ora (sprite_shift),y
  sta sprite_buffer+$32
  // [176] phi from main::merge241_100 to main::merge241_101 [phi:main::merge241_100->main::merge241_101]
  // main::merge241_101
  // main::merge241_102
  // [177] *(sprite_buffer+$33) = *(sprite_buffer+$33) | main::sprite_shift#0[$33] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$33
  ldy #$33
  ora (sprite_shift),y
  sta sprite_buffer+$33
  // [178] phi from main::merge241_102 to main::merge241_103 [phi:main::merge241_102->main::merge241_103]
  // main::merge241_103
  // main::merge241_104
  // [179] *(sprite_buffer+$34) = *(sprite_buffer+$34) | main::sprite_shift#0[$34] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$34
  ldy #$34
  ora (sprite_shift),y
  sta sprite_buffer+$34
  // [180] phi from main::merge241_104 to main::merge241_105 [phi:main::merge241_104->main::merge241_105]
  // main::merge241_105
  // main::merge241_106
  // [181] *(sprite_buffer+$35) = *(sprite_buffer+$35) | main::sprite_shift#0[$35] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$35
  ldy #$35
  ora (sprite_shift),y
  sta sprite_buffer+$35
  // [182] phi from main::merge241_106 to main::merge241_107 [phi:main::merge241_106->main::merge241_107]
  // main::merge241_107
  // main::merge241_108
  // [183] *(sprite_buffer+$36) = *(sprite_buffer+$36) | main::sprite_shift#0[$36] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$36
  ldy #$36
  ora (sprite_shift),y
  sta sprite_buffer+$36
  // [184] phi from main::merge241_108 to main::merge241_109 [phi:main::merge241_108->main::merge241_109]
  // main::merge241_109
  // main::merge241_110
  // [185] *(sprite_buffer+$37) = *(sprite_buffer+$37) | main::sprite_shift#0[$37] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$37
  ldy #$37
  ora (sprite_shift),y
  sta sprite_buffer+$37
  // [186] phi from main::merge241_110 to main::merge241_111 [phi:main::merge241_110->main::merge241_111]
  // main::merge241_111
  // main::merge241_112
  // [187] *(sprite_buffer+$38) = *(sprite_buffer+$38) | main::sprite_shift#0[$38] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$38
  ldy #$38
  ora (sprite_shift),y
  sta sprite_buffer+$38
  // [188] phi from main::merge241_112 to main::merge241_113 [phi:main::merge241_112->main::merge241_113]
  // main::merge241_113
  // main::merge241_114
  // [189] *(sprite_buffer+$39) = *(sprite_buffer+$39) | main::sprite_shift#0[$39] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$39
  ldy #$39
  ora (sprite_shift),y
  sta sprite_buffer+$39
  // [190] phi from main::merge241_114 to main::merge241_115 [phi:main::merge241_114->main::merge241_115]
  // main::merge241_115
  // main::merge241_116
  // [191] *(sprite_buffer+$3a) = *(sprite_buffer+$3a) | main::sprite_shift#0[$3a] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$3a
  ldy #$3a
  ora (sprite_shift),y
  sta sprite_buffer+$3a
  // [192] phi from main::merge241_116 to main::merge241_117 [phi:main::merge241_116->main::merge241_117]
  // main::merge241_117
  // main::merge241_118
  // [193] *(sprite_buffer+$3b) = *(sprite_buffer+$3b) | main::sprite_shift#0[$3b] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$3b
  ldy #$3b
  ora (sprite_shift),y
  sta sprite_buffer+$3b
  // [194] phi from main::merge241_118 to main::merge241_119 [phi:main::merge241_118->main::merge241_119]
  // main::merge241_119
  // main::merge241_120
  // [195] *(sprite_buffer+$3c) = *(sprite_buffer+$3c) | main::sprite_shift#0[$3c] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$3c
  ldy #$3c
  ora (sprite_shift),y
  sta sprite_buffer+$3c
  // [196] phi from main::merge241_120 to main::merge241_121 [phi:main::merge241_120->main::merge241_121]
  // main::merge241_121
  // main::merge241_122
  // [197] *(sprite_buffer+$3d) = *(sprite_buffer+$3d) | main::sprite_shift#0[$3d] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$3d
  ldy #$3d
  ora (sprite_shift),y
  sta sprite_buffer+$3d
  // [198] phi from main::merge241_122 to main::merge241_123 [phi:main::merge241_122->main::merge241_123]
  // main::merge241_123
  // main::merge241_124
  // [199] *(sprite_buffer+$3e) = *(sprite_buffer+$3e) | main::sprite_shift#0[$3e] -- _deref_pbuc1=_deref_pbuc1_bor_pbuz1_derefidx_vbuc2 
  lda sprite_buffer+$3e
  ldy #$3e
  ora (sprite_shift),y
  sta sprite_buffer+$3e
  // [200] phi from main::merge241_124 to main::merge241_125 [phi:main::merge241_124->main::merge241_125]
  // main::merge241_125
  // main::draw241
  // [201] main::draw241_$5 = (unsigned int)main::sy#0 -- vwuz1=_word_vbuz2 
  lda.z sy
  sta.z draw241_main__5
  lda #0
  sta.z draw241_main__5+1
  // [202] main::draw241_$0 = main::draw241_$5 << 5 -- vwuz1=vwuz1_rol_5 
  asl.z draw241_main__0
  rol.z draw241_main__0+1
  asl.z draw241_main__0
  rol.z draw241_main__0+1
  asl.z draw241_main__0
  rol.z draw241_main__0+1
  asl.z draw241_main__0
  rol.z draw241_main__0+1
  asl.z draw241_main__0
  rol.z draw241_main__0+1
  // [203] main::draw241_$4 = vram#17 << 1 -- vbuaa=vbuz1_rol_1 
  lda.z vram
  asl
  // [204] main::draw241_$1 = vram_addresses[main::draw241_$4] + main::draw241_$0 -- vwuz1=pwuc1_derefidx_vbuaa_plus_vwuz1 
  tay
  clc
  lda.z draw241_main__1
  adc vram_addresses,y
  sta.z draw241_main__1
  lda.z draw241_main__1+1
  adc vram_addresses+1,y
  sta.z draw241_main__1+1
  // [205] main::draw241_vdc_24x16_vram_ram1_vram_address#0 = main::draw241_$1 + main::sx#0 -- vwuz1=vwuz1_plus_vbuz2 
  lda.z sx
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // main::draw241_vdc_24x16_vram_ram1
  // [206] main::draw241_vdc_24x16_vram_ram1_vdc_write_register1_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#0 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [207] phi from main::draw241_vdc_24x16_vram_ram1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register1 [phi:main::draw241_vdc_24x16_vram_ram1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register1_vdc_register1
  // [208] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [209] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register1_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register1_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register1_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register1_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register1_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register1_@3
  // [211] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register1_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@1
  // [212] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait1_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#0 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [213] phi from main::draw241_vdc_24x16_vram_ram1_@1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait1 [phi:main::draw241_vdc_24x16_vram_ram1_@1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait1_vdc_register1
  // [214] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait1_vdc_write_nowait1
  // [215] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait1_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register1
  // [216] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@3
  // [217] main::draw241_vdc_24x16_vram_ram1_vdc_write1_d#0 = *sprite_buffer -- vbuaa=_deref_pbuc1 
  lda sprite_buffer
  // [218] phi from main::draw241_vdc_24x16_vram_ram1_@3 to main::draw241_vdc_24x16_vram_ram1_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_@3->main::draw241_vdc_24x16_vram_ram1_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write1_@1
  // [220] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write1_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@4
  // [221] main::draw241_vdc_24x16_vram_ram1_vdc_write2_d#0 = *(sprite_buffer+1) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+1
  // [222] phi from main::draw241_vdc_24x16_vram_ram1_@4 to main::draw241_vdc_24x16_vram_ram1_vdc_write2 [phi:main::draw241_vdc_24x16_vram_ram1_@4->main::draw241_vdc_24x16_vram_ram1_vdc_write2]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write2
  // main::draw241_vdc_24x16_vram_ram1_vdc_write2_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write2_@1
  // [224] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write2_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@5
  // [225] main::draw241_vdc_24x16_vram_ram1_vdc_write3_d#0 = *(sprite_buffer+2) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+2
  // [226] phi from main::draw241_vdc_24x16_vram_ram1_@5 to main::draw241_vdc_24x16_vram_ram1_vdc_write3 [phi:main::draw241_vdc_24x16_vram_ram1_@5->main::draw241_vdc_24x16_vram_ram1_vdc_write3]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write3
  // main::draw241_vdc_24x16_vram_ram1_vdc_write3_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write3_@1
  // [228] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write3_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@6
  // [229] main::draw241_vdc_24x16_vram_ram1_vram_address#1 = main::draw241_vdc_24x16_vram_ram1_vram_address#0 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [230] main::draw241_vdc_24x16_vram_ram1_vdc_write_register2_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#1 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [231] phi from main::draw241_vdc_24x16_vram_ram1_@6 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register2 [phi:main::draw241_vdc_24x16_vram_ram1_@6->main::draw241_vdc_24x16_vram_ram1_vdc_write_register2]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register2
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register2_vdc_register1
  // [232] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [233] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register2_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register2_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register2_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register2_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register2_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register2_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register2_@3
  // [235] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register2_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@7
  // [236] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait2_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#1 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [237] phi from main::draw241_vdc_24x16_vram_ram1_@7 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait2 [phi:main::draw241_vdc_24x16_vram_ram1_@7->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait2]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait2
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait2_vdc_register1
  // [238] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait2_vdc_write_nowait1
  // [239] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait2_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register2
  // [240] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@9
  // [241] main::draw241_vdc_24x16_vram_ram1_vdc_write4_d#0 = *(sprite_buffer+3) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+3
  // [242] phi from main::draw241_vdc_24x16_vram_ram1_@9 to main::draw241_vdc_24x16_vram_ram1_vdc_write4 [phi:main::draw241_vdc_24x16_vram_ram1_@9->main::draw241_vdc_24x16_vram_ram1_vdc_write4]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write4
  // main::draw241_vdc_24x16_vram_ram1_vdc_write4_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write4_@1
  // [244] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write4_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@10
  // [245] main::draw241_vdc_24x16_vram_ram1_vdc_write5_d#0 = *(sprite_buffer+4) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+4
  // [246] phi from main::draw241_vdc_24x16_vram_ram1_@10 to main::draw241_vdc_24x16_vram_ram1_vdc_write5 [phi:main::draw241_vdc_24x16_vram_ram1_@10->main::draw241_vdc_24x16_vram_ram1_vdc_write5]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write5
  // main::draw241_vdc_24x16_vram_ram1_vdc_write5_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write5_@1
  // [248] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write5_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@11
  // [249] main::draw241_vdc_24x16_vram_ram1_vdc_write6_d#0 = *(sprite_buffer+5) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+5
  // [250] phi from main::draw241_vdc_24x16_vram_ram1_@11 to main::draw241_vdc_24x16_vram_ram1_vdc_write6 [phi:main::draw241_vdc_24x16_vram_ram1_@11->main::draw241_vdc_24x16_vram_ram1_vdc_write6]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write6
  // main::draw241_vdc_24x16_vram_ram1_vdc_write6_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write6_@1
  // [252] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write6_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@12
  // [253] main::draw241_vdc_24x16_vram_ram1_vram_address#118 = main::draw241_vdc_24x16_vram_ram1_vram_address#1 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [254] main::draw241_vdc_24x16_vram_ram1_vdc_write_register3_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#118 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [255] phi from main::draw241_vdc_24x16_vram_ram1_@12 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register3 [phi:main::draw241_vdc_24x16_vram_ram1_@12->main::draw241_vdc_24x16_vram_ram1_vdc_write_register3]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register3
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register3_vdc_register1
  // [256] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [257] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register3_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register3_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register3_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register3_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register3_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register3_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register3_@3
  // [259] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register3_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@13
  // [260] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait3_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#118 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [261] phi from main::draw241_vdc_24x16_vram_ram1_@13 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait3 [phi:main::draw241_vdc_24x16_vram_ram1_@13->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait3]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait3
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait3_vdc_register1
  // [262] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait3_vdc_write_nowait1
  // [263] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait3_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register3
  // [264] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@15
  // [265] main::draw241_vdc_24x16_vram_ram1_vdc_write7_d#0 = *(sprite_buffer+6) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+6
  // [266] phi from main::draw241_vdc_24x16_vram_ram1_@15 to main::draw241_vdc_24x16_vram_ram1_vdc_write7 [phi:main::draw241_vdc_24x16_vram_ram1_@15->main::draw241_vdc_24x16_vram_ram1_vdc_write7]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write7
  // main::draw241_vdc_24x16_vram_ram1_vdc_write7_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write7_@1
  // [268] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write7_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@16
  // [269] main::draw241_vdc_24x16_vram_ram1_vdc_write8_d#0 = *(sprite_buffer+7) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+7
  // [270] phi from main::draw241_vdc_24x16_vram_ram1_@16 to main::draw241_vdc_24x16_vram_ram1_vdc_write8 [phi:main::draw241_vdc_24x16_vram_ram1_@16->main::draw241_vdc_24x16_vram_ram1_vdc_write8]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write8
  // main::draw241_vdc_24x16_vram_ram1_vdc_write8_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write8_@1
  // [272] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write8_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@17
  // [273] main::draw241_vdc_24x16_vram_ram1_vdc_write9_d#0 = *(sprite_buffer+8) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+8
  // [274] phi from main::draw241_vdc_24x16_vram_ram1_@17 to main::draw241_vdc_24x16_vram_ram1_vdc_write9 [phi:main::draw241_vdc_24x16_vram_ram1_@17->main::draw241_vdc_24x16_vram_ram1_vdc_write9]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write9
  // main::draw241_vdc_24x16_vram_ram1_vdc_write9_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write9_@1
  // [276] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write9_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@18
  // [277] main::draw241_vdc_24x16_vram_ram1_vram_address#120 = main::draw241_vdc_24x16_vram_ram1_vram_address#118 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [278] main::draw241_vdc_24x16_vram_ram1_vdc_write_register4_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#120 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [279] phi from main::draw241_vdc_24x16_vram_ram1_@18 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register4 [phi:main::draw241_vdc_24x16_vram_ram1_@18->main::draw241_vdc_24x16_vram_ram1_vdc_write_register4]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register4
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register4_vdc_register1
  // [280] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [281] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register4_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register4_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register4_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register4_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register4_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register4_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register4_@3
  // [283] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register4_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@19
  // [284] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait4_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#120 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [285] phi from main::draw241_vdc_24x16_vram_ram1_@19 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait4 [phi:main::draw241_vdc_24x16_vram_ram1_@19->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait4]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait4
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait4_vdc_register1
  // [286] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait4_vdc_write_nowait1
  // [287] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait4_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register4
  // [288] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@21
  // [289] main::draw241_vdc_24x16_vram_ram1_vdc_write10_d#0 = *(sprite_buffer+9) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+9
  // [290] phi from main::draw241_vdc_24x16_vram_ram1_@21 to main::draw241_vdc_24x16_vram_ram1_vdc_write10 [phi:main::draw241_vdc_24x16_vram_ram1_@21->main::draw241_vdc_24x16_vram_ram1_vdc_write10]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write10
  // main::draw241_vdc_24x16_vram_ram1_vdc_write10_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write10_@1
  // [292] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write10_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@22
  // [293] main::draw241_vdc_24x16_vram_ram1_vdc_write11_d#0 = *(sprite_buffer+$a) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$a
  // [294] phi from main::draw241_vdc_24x16_vram_ram1_@22 to main::draw241_vdc_24x16_vram_ram1_vdc_write11 [phi:main::draw241_vdc_24x16_vram_ram1_@22->main::draw241_vdc_24x16_vram_ram1_vdc_write11]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write11
  // main::draw241_vdc_24x16_vram_ram1_vdc_write11_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write11_@1
  // [296] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write11_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@23
  // [297] main::draw241_vdc_24x16_vram_ram1_vdc_write12_d#0 = *(sprite_buffer+$b) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$b
  // [298] phi from main::draw241_vdc_24x16_vram_ram1_@23 to main::draw241_vdc_24x16_vram_ram1_vdc_write12 [phi:main::draw241_vdc_24x16_vram_ram1_@23->main::draw241_vdc_24x16_vram_ram1_vdc_write12]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write12
  // main::draw241_vdc_24x16_vram_ram1_vdc_write12_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write12_@1
  // [300] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write12_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@24
  // [301] main::draw241_vdc_24x16_vram_ram1_vram_address#122 = main::draw241_vdc_24x16_vram_ram1_vram_address#120 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [302] main::draw241_vdc_24x16_vram_ram1_vdc_write_register5_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#122 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [303] phi from main::draw241_vdc_24x16_vram_ram1_@24 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register5 [phi:main::draw241_vdc_24x16_vram_ram1_@24->main::draw241_vdc_24x16_vram_ram1_vdc_write_register5]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register5
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register5_vdc_register1
  // [304] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [305] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register5_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register5_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register5_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register5_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register5_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register5_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register5_@3
  // [307] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register5_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@25
  // [308] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait5_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#122 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [309] phi from main::draw241_vdc_24x16_vram_ram1_@25 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait5 [phi:main::draw241_vdc_24x16_vram_ram1_@25->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait5]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait5
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait5_vdc_register1
  // [310] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait5_vdc_write_nowait1
  // [311] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait5_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register5
  // [312] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@27
  // [313] main::draw241_vdc_24x16_vram_ram1_vdc_write13_d#0 = *(sprite_buffer+$c) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$c
  // [314] phi from main::draw241_vdc_24x16_vram_ram1_@27 to main::draw241_vdc_24x16_vram_ram1_vdc_write13 [phi:main::draw241_vdc_24x16_vram_ram1_@27->main::draw241_vdc_24x16_vram_ram1_vdc_write13]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write13
  // main::draw241_vdc_24x16_vram_ram1_vdc_write13_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write13_@1
  // [316] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write13_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@28
  // [317] main::draw241_vdc_24x16_vram_ram1_vdc_write14_d#0 = *(sprite_buffer+$d) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$d
  // [318] phi from main::draw241_vdc_24x16_vram_ram1_@28 to main::draw241_vdc_24x16_vram_ram1_vdc_write14 [phi:main::draw241_vdc_24x16_vram_ram1_@28->main::draw241_vdc_24x16_vram_ram1_vdc_write14]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write14
  // main::draw241_vdc_24x16_vram_ram1_vdc_write14_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write14_@1
  // [320] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write14_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@29
  // [321] main::draw241_vdc_24x16_vram_ram1_vdc_write15_d#0 = *(sprite_buffer+$e) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$e
  // [322] phi from main::draw241_vdc_24x16_vram_ram1_@29 to main::draw241_vdc_24x16_vram_ram1_vdc_write15 [phi:main::draw241_vdc_24x16_vram_ram1_@29->main::draw241_vdc_24x16_vram_ram1_vdc_write15]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write15
  // main::draw241_vdc_24x16_vram_ram1_vdc_write15_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write15_@1
  // [324] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write15_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@30
  // [325] main::draw241_vdc_24x16_vram_ram1_vram_address#124 = main::draw241_vdc_24x16_vram_ram1_vram_address#122 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [326] main::draw241_vdc_24x16_vram_ram1_vdc_write_register6_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#124 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [327] phi from main::draw241_vdc_24x16_vram_ram1_@30 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register6 [phi:main::draw241_vdc_24x16_vram_ram1_@30->main::draw241_vdc_24x16_vram_ram1_vdc_write_register6]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register6
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register6_vdc_register1
  // [328] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [329] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register6_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register6_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register6_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register6_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register6_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register6_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register6_@3
  // [331] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register6_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@31
  // [332] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait6_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#124 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [333] phi from main::draw241_vdc_24x16_vram_ram1_@31 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait6 [phi:main::draw241_vdc_24x16_vram_ram1_@31->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait6]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait6
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait6_vdc_register1
  // [334] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait6_vdc_write_nowait1
  // [335] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait6_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register6
  // [336] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@33
  // [337] main::draw241_vdc_24x16_vram_ram1_vdc_write16_d#0 = *(sprite_buffer+$f) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$f
  // [338] phi from main::draw241_vdc_24x16_vram_ram1_@33 to main::draw241_vdc_24x16_vram_ram1_vdc_write16 [phi:main::draw241_vdc_24x16_vram_ram1_@33->main::draw241_vdc_24x16_vram_ram1_vdc_write16]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write16
  // main::draw241_vdc_24x16_vram_ram1_vdc_write16_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write16_@1
  // [340] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write16_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@34
  // [341] main::draw241_vdc_24x16_vram_ram1_vdc_write17_d#0 = *(sprite_buffer+$10) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$10
  // [342] phi from main::draw241_vdc_24x16_vram_ram1_@34 to main::draw241_vdc_24x16_vram_ram1_vdc_write17 [phi:main::draw241_vdc_24x16_vram_ram1_@34->main::draw241_vdc_24x16_vram_ram1_vdc_write17]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write17
  // main::draw241_vdc_24x16_vram_ram1_vdc_write17_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write17_@1
  // [344] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write17_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@35
  // [345] main::draw241_vdc_24x16_vram_ram1_vdc_write18_d#0 = *(sprite_buffer+$11) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$11
  // [346] phi from main::draw241_vdc_24x16_vram_ram1_@35 to main::draw241_vdc_24x16_vram_ram1_vdc_write18 [phi:main::draw241_vdc_24x16_vram_ram1_@35->main::draw241_vdc_24x16_vram_ram1_vdc_write18]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write18
  // main::draw241_vdc_24x16_vram_ram1_vdc_write18_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write18_@1
  // [348] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write18_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@36
  // [349] main::draw241_vdc_24x16_vram_ram1_vram_address#126 = main::draw241_vdc_24x16_vram_ram1_vram_address#124 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [350] main::draw241_vdc_24x16_vram_ram1_vdc_write_register7_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#126 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [351] phi from main::draw241_vdc_24x16_vram_ram1_@36 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register7 [phi:main::draw241_vdc_24x16_vram_ram1_@36->main::draw241_vdc_24x16_vram_ram1_vdc_write_register7]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register7
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register7_vdc_register1
  // [352] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [353] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register7_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register7_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register7_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register7_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register7_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register7_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register7_@3
  // [355] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register7_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@37
  // [356] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait7_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#126 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [357] phi from main::draw241_vdc_24x16_vram_ram1_@37 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait7 [phi:main::draw241_vdc_24x16_vram_ram1_@37->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait7]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait7
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait7_vdc_register1
  // [358] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait7_vdc_write_nowait1
  // [359] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait7_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register7
  // [360] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@39
  // [361] main::draw241_vdc_24x16_vram_ram1_vdc_write19_d#0 = *(sprite_buffer+$12) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$12
  // [362] phi from main::draw241_vdc_24x16_vram_ram1_@39 to main::draw241_vdc_24x16_vram_ram1_vdc_write19 [phi:main::draw241_vdc_24x16_vram_ram1_@39->main::draw241_vdc_24x16_vram_ram1_vdc_write19]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write19
  // main::draw241_vdc_24x16_vram_ram1_vdc_write19_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write19_@1
  // [364] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write19_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@40
  // [365] main::draw241_vdc_24x16_vram_ram1_vdc_write20_d#0 = *(sprite_buffer+$13) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$13
  // [366] phi from main::draw241_vdc_24x16_vram_ram1_@40 to main::draw241_vdc_24x16_vram_ram1_vdc_write20 [phi:main::draw241_vdc_24x16_vram_ram1_@40->main::draw241_vdc_24x16_vram_ram1_vdc_write20]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write20
  // main::draw241_vdc_24x16_vram_ram1_vdc_write20_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write20_@1
  // [368] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write20_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@41
  // [369] main::draw241_vdc_24x16_vram_ram1_vdc_write21_d#0 = *(sprite_buffer+$14) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$14
  // [370] phi from main::draw241_vdc_24x16_vram_ram1_@41 to main::draw241_vdc_24x16_vram_ram1_vdc_write21 [phi:main::draw241_vdc_24x16_vram_ram1_@41->main::draw241_vdc_24x16_vram_ram1_vdc_write21]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write21
  // main::draw241_vdc_24x16_vram_ram1_vdc_write21_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write21_@1
  // [372] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write21_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@42
  // [373] main::draw241_vdc_24x16_vram_ram1_vram_address#128 = main::draw241_vdc_24x16_vram_ram1_vram_address#126 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [374] main::draw241_vdc_24x16_vram_ram1_vdc_write_register8_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#128 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [375] phi from main::draw241_vdc_24x16_vram_ram1_@42 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register8 [phi:main::draw241_vdc_24x16_vram_ram1_@42->main::draw241_vdc_24x16_vram_ram1_vdc_write_register8]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register8
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register8_vdc_register1
  // [376] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [377] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register8_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register8_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register8_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register8_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register8_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register8_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register8_@3
  // [379] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register8_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@43
  // [380] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait8_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#128 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [381] phi from main::draw241_vdc_24x16_vram_ram1_@43 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait8 [phi:main::draw241_vdc_24x16_vram_ram1_@43->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait8]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait8
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait8_vdc_register1
  // [382] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait8_vdc_write_nowait1
  // [383] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait8_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register8
  // [384] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@45
  // [385] main::draw241_vdc_24x16_vram_ram1_vdc_write22_d#0 = *(sprite_buffer+$15) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$15
  // [386] phi from main::draw241_vdc_24x16_vram_ram1_@45 to main::draw241_vdc_24x16_vram_ram1_vdc_write22 [phi:main::draw241_vdc_24x16_vram_ram1_@45->main::draw241_vdc_24x16_vram_ram1_vdc_write22]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write22
  // main::draw241_vdc_24x16_vram_ram1_vdc_write22_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write22_@1
  // [388] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write22_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@46
  // [389] main::draw241_vdc_24x16_vram_ram1_vdc_write23_d#0 = *(sprite_buffer+$16) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$16
  // [390] phi from main::draw241_vdc_24x16_vram_ram1_@46 to main::draw241_vdc_24x16_vram_ram1_vdc_write23 [phi:main::draw241_vdc_24x16_vram_ram1_@46->main::draw241_vdc_24x16_vram_ram1_vdc_write23]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write23
  // main::draw241_vdc_24x16_vram_ram1_vdc_write23_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write23_@1
  // [392] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write23_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@47
  // [393] main::draw241_vdc_24x16_vram_ram1_vdc_write24_d#0 = *(sprite_buffer+$17) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$17
  // [394] phi from main::draw241_vdc_24x16_vram_ram1_@47 to main::draw241_vdc_24x16_vram_ram1_vdc_write24 [phi:main::draw241_vdc_24x16_vram_ram1_@47->main::draw241_vdc_24x16_vram_ram1_vdc_write24]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write24
  // main::draw241_vdc_24x16_vram_ram1_vdc_write24_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write24_@1
  // [396] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write24_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@48
  // [397] main::draw241_vdc_24x16_vram_ram1_vram_address#130 = main::draw241_vdc_24x16_vram_ram1_vram_address#128 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [398] main::draw241_vdc_24x16_vram_ram1_vdc_write_register9_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#130 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [399] phi from main::draw241_vdc_24x16_vram_ram1_@48 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register9 [phi:main::draw241_vdc_24x16_vram_ram1_@48->main::draw241_vdc_24x16_vram_ram1_vdc_write_register9]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register9
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register9_vdc_register1
  // [400] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [401] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register9_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register9_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register9_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register9_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register9_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register9_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register9_@3
  // [403] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register9_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@49
  // [404] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait9_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#130 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [405] phi from main::draw241_vdc_24x16_vram_ram1_@49 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait9 [phi:main::draw241_vdc_24x16_vram_ram1_@49->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait9]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait9
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait9_vdc_register1
  // [406] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait9_vdc_write_nowait1
  // [407] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait9_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register9
  // [408] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@51
  // [409] main::draw241_vdc_24x16_vram_ram1_vdc_write25_d#0 = *(sprite_buffer+$18) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$18
  // [410] phi from main::draw241_vdc_24x16_vram_ram1_@51 to main::draw241_vdc_24x16_vram_ram1_vdc_write25 [phi:main::draw241_vdc_24x16_vram_ram1_@51->main::draw241_vdc_24x16_vram_ram1_vdc_write25]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write25
  // main::draw241_vdc_24x16_vram_ram1_vdc_write25_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write25_@1
  // [412] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write25_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@52
  // [413] main::draw241_vdc_24x16_vram_ram1_vdc_write26_d#0 = *(sprite_buffer+$19) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$19
  // [414] phi from main::draw241_vdc_24x16_vram_ram1_@52 to main::draw241_vdc_24x16_vram_ram1_vdc_write26 [phi:main::draw241_vdc_24x16_vram_ram1_@52->main::draw241_vdc_24x16_vram_ram1_vdc_write26]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write26
  // main::draw241_vdc_24x16_vram_ram1_vdc_write26_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write26_@1
  // [416] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write26_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@53
  // [417] main::draw241_vdc_24x16_vram_ram1_vdc_write27_d#0 = *(sprite_buffer+$1a) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$1a
  // [418] phi from main::draw241_vdc_24x16_vram_ram1_@53 to main::draw241_vdc_24x16_vram_ram1_vdc_write27 [phi:main::draw241_vdc_24x16_vram_ram1_@53->main::draw241_vdc_24x16_vram_ram1_vdc_write27]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write27
  // main::draw241_vdc_24x16_vram_ram1_vdc_write27_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write27_@1
  // [420] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write27_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@54
  // [421] main::draw241_vdc_24x16_vram_ram1_vram_address#100 = main::draw241_vdc_24x16_vram_ram1_vram_address#130 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [422] main::draw241_vdc_24x16_vram_ram1_vdc_write_register10_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#100 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [423] phi from main::draw241_vdc_24x16_vram_ram1_@54 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register10 [phi:main::draw241_vdc_24x16_vram_ram1_@54->main::draw241_vdc_24x16_vram_ram1_vdc_write_register10]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register10
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register10_vdc_register1
  // [424] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [425] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register10_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register10_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register10_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register10_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register10_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register10_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register10_@3
  // [427] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register10_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@55
  // [428] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait10_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#100 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [429] phi from main::draw241_vdc_24x16_vram_ram1_@55 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait10 [phi:main::draw241_vdc_24x16_vram_ram1_@55->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait10]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait10
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait10_vdc_register1
  // [430] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait10_vdc_write_nowait1
  // [431] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait10_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register10
  // [432] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@57
  // [433] main::draw241_vdc_24x16_vram_ram1_vdc_write28_d#0 = *(sprite_buffer+$1b) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$1b
  // [434] phi from main::draw241_vdc_24x16_vram_ram1_@57 to main::draw241_vdc_24x16_vram_ram1_vdc_write28 [phi:main::draw241_vdc_24x16_vram_ram1_@57->main::draw241_vdc_24x16_vram_ram1_vdc_write28]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write28
  // main::draw241_vdc_24x16_vram_ram1_vdc_write28_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write28_@1
  // [436] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write28_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@58
  // [437] main::draw241_vdc_24x16_vram_ram1_vdc_write29_d#0 = *(sprite_buffer+$1c) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$1c
  // [438] phi from main::draw241_vdc_24x16_vram_ram1_@58 to main::draw241_vdc_24x16_vram_ram1_vdc_write29 [phi:main::draw241_vdc_24x16_vram_ram1_@58->main::draw241_vdc_24x16_vram_ram1_vdc_write29]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write29
  // main::draw241_vdc_24x16_vram_ram1_vdc_write29_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write29_@1
  // [440] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write29_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@59
  // [441] main::draw241_vdc_24x16_vram_ram1_vdc_write30_d#0 = *(sprite_buffer+$1d) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$1d
  // [442] phi from main::draw241_vdc_24x16_vram_ram1_@59 to main::draw241_vdc_24x16_vram_ram1_vdc_write30 [phi:main::draw241_vdc_24x16_vram_ram1_@59->main::draw241_vdc_24x16_vram_ram1_vdc_write30]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write30
  // main::draw241_vdc_24x16_vram_ram1_vdc_write30_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write30_@1
  // [444] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write30_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@60
  // [445] main::draw241_vdc_24x16_vram_ram1_vram_address#10 = main::draw241_vdc_24x16_vram_ram1_vram_address#100 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [446] main::draw241_vdc_24x16_vram_ram1_vdc_write_register11_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#10 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [447] phi from main::draw241_vdc_24x16_vram_ram1_@60 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register11 [phi:main::draw241_vdc_24x16_vram_ram1_@60->main::draw241_vdc_24x16_vram_ram1_vdc_write_register11]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register11
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register11_vdc_register1
  // [448] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [449] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register11_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register11_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register11_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register11_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register11_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register11_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register11_@3
  // [451] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register11_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@61
  // [452] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait11_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#10 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [453] phi from main::draw241_vdc_24x16_vram_ram1_@61 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait11 [phi:main::draw241_vdc_24x16_vram_ram1_@61->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait11]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait11
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait11_vdc_register1
  // [454] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait11_vdc_write_nowait1
  // [455] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait11_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register11
  // [456] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@63
  // [457] main::draw241_vdc_24x16_vram_ram1_vdc_write31_d#0 = *(sprite_buffer+$1e) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$1e
  // [458] phi from main::draw241_vdc_24x16_vram_ram1_@63 to main::draw241_vdc_24x16_vram_ram1_vdc_write31 [phi:main::draw241_vdc_24x16_vram_ram1_@63->main::draw241_vdc_24x16_vram_ram1_vdc_write31]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write31
  // main::draw241_vdc_24x16_vram_ram1_vdc_write31_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write31_@1
  // [460] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write31_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@64
  // [461] main::draw241_vdc_24x16_vram_ram1_vdc_write32_d#0 = *(sprite_buffer+$1f) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$1f
  // [462] phi from main::draw241_vdc_24x16_vram_ram1_@64 to main::draw241_vdc_24x16_vram_ram1_vdc_write32 [phi:main::draw241_vdc_24x16_vram_ram1_@64->main::draw241_vdc_24x16_vram_ram1_vdc_write32]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write32
  // main::draw241_vdc_24x16_vram_ram1_vdc_write32_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write32_@1
  // [464] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write32_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@65
  // [465] main::draw241_vdc_24x16_vram_ram1_vdc_write33_d#0 = *(sprite_buffer+$20) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$20
  // [466] phi from main::draw241_vdc_24x16_vram_ram1_@65 to main::draw241_vdc_24x16_vram_ram1_vdc_write33 [phi:main::draw241_vdc_24x16_vram_ram1_@65->main::draw241_vdc_24x16_vram_ram1_vdc_write33]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write33
  // main::draw241_vdc_24x16_vram_ram1_vdc_write33_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write33_@1
  // [468] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write33_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@66
  // [469] main::draw241_vdc_24x16_vram_ram1_vram_address#104 = main::draw241_vdc_24x16_vram_ram1_vram_address#10 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [470] main::draw241_vdc_24x16_vram_ram1_vdc_write_register12_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#104 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [471] phi from main::draw241_vdc_24x16_vram_ram1_@66 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register12 [phi:main::draw241_vdc_24x16_vram_ram1_@66->main::draw241_vdc_24x16_vram_ram1_vdc_write_register12]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register12
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register12_vdc_register1
  // [472] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [473] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register12_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register12_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register12_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register12_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register12_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register12_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register12_@3
  // [475] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register12_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@67
  // [476] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait12_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#104 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [477] phi from main::draw241_vdc_24x16_vram_ram1_@67 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait12 [phi:main::draw241_vdc_24x16_vram_ram1_@67->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait12]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait12
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait12_vdc_register1
  // [478] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait12_vdc_write_nowait1
  // [479] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait12_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register12
  // [480] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@69
  // [481] main::draw241_vdc_24x16_vram_ram1_vdc_write34_d#0 = *(sprite_buffer+$21) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$21
  // [482] phi from main::draw241_vdc_24x16_vram_ram1_@69 to main::draw241_vdc_24x16_vram_ram1_vdc_write34 [phi:main::draw241_vdc_24x16_vram_ram1_@69->main::draw241_vdc_24x16_vram_ram1_vdc_write34]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write34
  // main::draw241_vdc_24x16_vram_ram1_vdc_write34_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write34_@1
  // [484] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write34_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@70
  // [485] main::draw241_vdc_24x16_vram_ram1_vdc_write35_d#0 = *(sprite_buffer+$22) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$22
  // [486] phi from main::draw241_vdc_24x16_vram_ram1_@70 to main::draw241_vdc_24x16_vram_ram1_vdc_write35 [phi:main::draw241_vdc_24x16_vram_ram1_@70->main::draw241_vdc_24x16_vram_ram1_vdc_write35]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write35
  // main::draw241_vdc_24x16_vram_ram1_vdc_write35_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write35_@1
  // [488] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write35_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@71
  // [489] main::draw241_vdc_24x16_vram_ram1_vdc_write36_d#0 = *(sprite_buffer+$23) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$23
  // [490] phi from main::draw241_vdc_24x16_vram_ram1_@71 to main::draw241_vdc_24x16_vram_ram1_vdc_write36 [phi:main::draw241_vdc_24x16_vram_ram1_@71->main::draw241_vdc_24x16_vram_ram1_vdc_write36]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write36
  // main::draw241_vdc_24x16_vram_ram1_vdc_write36_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write36_@1
  // [492] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write36_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@72
  // [493] main::draw241_vdc_24x16_vram_ram1_vram_address#106 = main::draw241_vdc_24x16_vram_ram1_vram_address#104 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [494] main::draw241_vdc_24x16_vram_ram1_vdc_write_register13_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#106 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [495] phi from main::draw241_vdc_24x16_vram_ram1_@72 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register13 [phi:main::draw241_vdc_24x16_vram_ram1_@72->main::draw241_vdc_24x16_vram_ram1_vdc_write_register13]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register13
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register13_vdc_register1
  // [496] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [497] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register13_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register13_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register13_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register13_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register13_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register13_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register13_@3
  // [499] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register13_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@73
  // [500] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait13_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#106 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [501] phi from main::draw241_vdc_24x16_vram_ram1_@73 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait13 [phi:main::draw241_vdc_24x16_vram_ram1_@73->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait13]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait13
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait13_vdc_register1
  // [502] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait13_vdc_write_nowait1
  // [503] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait13_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register13
  // [504] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@75
  // [505] main::draw241_vdc_24x16_vram_ram1_vdc_write37_d#0 = *(sprite_buffer+$24) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$24
  // [506] phi from main::draw241_vdc_24x16_vram_ram1_@75 to main::draw241_vdc_24x16_vram_ram1_vdc_write37 [phi:main::draw241_vdc_24x16_vram_ram1_@75->main::draw241_vdc_24x16_vram_ram1_vdc_write37]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write37
  // main::draw241_vdc_24x16_vram_ram1_vdc_write37_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write37_@1
  // [508] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write37_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@76
  // [509] main::draw241_vdc_24x16_vram_ram1_vdc_write38_d#0 = *(sprite_buffer+$25) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$25
  // [510] phi from main::draw241_vdc_24x16_vram_ram1_@76 to main::draw241_vdc_24x16_vram_ram1_vdc_write38 [phi:main::draw241_vdc_24x16_vram_ram1_@76->main::draw241_vdc_24x16_vram_ram1_vdc_write38]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write38
  // main::draw241_vdc_24x16_vram_ram1_vdc_write38_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write38_@1
  // [512] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write38_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@77
  // [513] main::draw241_vdc_24x16_vram_ram1_vdc_write39_d#0 = *(sprite_buffer+$26) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$26
  // [514] phi from main::draw241_vdc_24x16_vram_ram1_@77 to main::draw241_vdc_24x16_vram_ram1_vdc_write39 [phi:main::draw241_vdc_24x16_vram_ram1_@77->main::draw241_vdc_24x16_vram_ram1_vdc_write39]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write39
  // main::draw241_vdc_24x16_vram_ram1_vdc_write39_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write39_@1
  // [516] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write39_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@78
  // [517] main::draw241_vdc_24x16_vram_ram1_vram_address#108 = main::draw241_vdc_24x16_vram_ram1_vram_address#106 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [518] main::draw241_vdc_24x16_vram_ram1_vdc_write_register14_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#108 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [519] phi from main::draw241_vdc_24x16_vram_ram1_@78 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register14 [phi:main::draw241_vdc_24x16_vram_ram1_@78->main::draw241_vdc_24x16_vram_ram1_vdc_write_register14]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register14
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register14_vdc_register1
  // [520] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [521] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register14_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register14_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register14_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register14_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register14_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register14_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register14_@3
  // [523] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register14_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@79
  // [524] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait14_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#108 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [525] phi from main::draw241_vdc_24x16_vram_ram1_@79 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait14 [phi:main::draw241_vdc_24x16_vram_ram1_@79->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait14]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait14
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait14_vdc_register1
  // [526] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait14_vdc_write_nowait1
  // [527] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait14_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register14
  // [528] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@81
  // [529] main::draw241_vdc_24x16_vram_ram1_vdc_write40_d#0 = *(sprite_buffer+$27) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$27
  // [530] phi from main::draw241_vdc_24x16_vram_ram1_@81 to main::draw241_vdc_24x16_vram_ram1_vdc_write40 [phi:main::draw241_vdc_24x16_vram_ram1_@81->main::draw241_vdc_24x16_vram_ram1_vdc_write40]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write40
  // main::draw241_vdc_24x16_vram_ram1_vdc_write40_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write40_@1
  // [532] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write40_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@82
  // [533] main::draw241_vdc_24x16_vram_ram1_vdc_write41_d#0 = *(sprite_buffer+$28) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$28
  // [534] phi from main::draw241_vdc_24x16_vram_ram1_@82 to main::draw241_vdc_24x16_vram_ram1_vdc_write41 [phi:main::draw241_vdc_24x16_vram_ram1_@82->main::draw241_vdc_24x16_vram_ram1_vdc_write41]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write41
  // main::draw241_vdc_24x16_vram_ram1_vdc_write41_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write41_@1
  // [536] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write41_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@83
  // [537] main::draw241_vdc_24x16_vram_ram1_vdc_write42_d#0 = *(sprite_buffer+$29) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$29
  // [538] phi from main::draw241_vdc_24x16_vram_ram1_@83 to main::draw241_vdc_24x16_vram_ram1_vdc_write42 [phi:main::draw241_vdc_24x16_vram_ram1_@83->main::draw241_vdc_24x16_vram_ram1_vdc_write42]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write42
  // main::draw241_vdc_24x16_vram_ram1_vdc_write42_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write42_@1
  // [540] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write42_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@84
  // [541] main::draw241_vdc_24x16_vram_ram1_vram_address#110 = main::draw241_vdc_24x16_vram_ram1_vram_address#108 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [542] main::draw241_vdc_24x16_vram_ram1_vdc_write_register15_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#110 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [543] phi from main::draw241_vdc_24x16_vram_ram1_@84 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register15 [phi:main::draw241_vdc_24x16_vram_ram1_@84->main::draw241_vdc_24x16_vram_ram1_vdc_write_register15]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register15
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register15_vdc_register1
  // [544] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [545] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register15_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register15_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register15_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register15_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register15_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register15_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register15_@3
  // [547] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register15_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@85
  // [548] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait15_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#110 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [549] phi from main::draw241_vdc_24x16_vram_ram1_@85 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait15 [phi:main::draw241_vdc_24x16_vram_ram1_@85->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait15]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait15
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait15_vdc_register1
  // [550] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait15_vdc_write_nowait1
  // [551] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait15_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register15
  // [552] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@87
  // [553] main::draw241_vdc_24x16_vram_ram1_vdc_write43_d#0 = *(sprite_buffer+$2a) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$2a
  // [554] phi from main::draw241_vdc_24x16_vram_ram1_@87 to main::draw241_vdc_24x16_vram_ram1_vdc_write43 [phi:main::draw241_vdc_24x16_vram_ram1_@87->main::draw241_vdc_24x16_vram_ram1_vdc_write43]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write43
  // main::draw241_vdc_24x16_vram_ram1_vdc_write43_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write43_@1
  // [556] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write43_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@88
  // [557] main::draw241_vdc_24x16_vram_ram1_vdc_write44_d#0 = *(sprite_buffer+$2b) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$2b
  // [558] phi from main::draw241_vdc_24x16_vram_ram1_@88 to main::draw241_vdc_24x16_vram_ram1_vdc_write44 [phi:main::draw241_vdc_24x16_vram_ram1_@88->main::draw241_vdc_24x16_vram_ram1_vdc_write44]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write44
  // main::draw241_vdc_24x16_vram_ram1_vdc_write44_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write44_@1
  // [560] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write44_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@89
  // [561] main::draw241_vdc_24x16_vram_ram1_vdc_write45_d#0 = *(sprite_buffer+$2c) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$2c
  // [562] phi from main::draw241_vdc_24x16_vram_ram1_@89 to main::draw241_vdc_24x16_vram_ram1_vdc_write45 [phi:main::draw241_vdc_24x16_vram_ram1_@89->main::draw241_vdc_24x16_vram_ram1_vdc_write45]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write45
  // main::draw241_vdc_24x16_vram_ram1_vdc_write45_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write45_@1
  // [564] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write45_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@90
  // [565] main::draw241_vdc_24x16_vram_ram1_vram_address#112 = main::draw241_vdc_24x16_vram_ram1_vram_address#110 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z draw241_vdc_24x16_vram_ram1_vram_address
  sta.z draw241_vdc_24x16_vram_ram1_vram_address
  bcc !+
  inc.z draw241_vdc_24x16_vram_ram1_vram_address+1
!:
  // [566] main::draw241_vdc_24x16_vram_ram1_vdc_write_register16_d#0 = byte1  main::draw241_vdc_24x16_vram_ram1_vram_address#112 -- vbuxx=_byte1_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address+1
  // [567] phi from main::draw241_vdc_24x16_vram_ram1_@90 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register16 [phi:main::draw241_vdc_24x16_vram_ram1_@90->main::draw241_vdc_24x16_vram_ram1_vdc_write_register16]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register16
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register16_vdc_register1
  // [568] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [569] phi from main::draw241_vdc_24x16_vram_ram1_vdc_write_register16_vdc_register1 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register16_vdc_write1 [phi:main::draw241_vdc_24x16_vram_ram1_vdc_write_register16_vdc_register1->main::draw241_vdc_24x16_vram_ram1_vdc_write_register16_vdc_write1]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register16_vdc_write1
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register16_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register16_@3
  // [571] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register16_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@91
  // [572] main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait16_d#0 = byte0  main::draw241_vdc_24x16_vram_ram1_vram_address#112 -- vbuxx=_byte0_vwuz1 
  ldx.z draw241_vdc_24x16_vram_ram1_vram_address
  // [573] phi from main::draw241_vdc_24x16_vram_ram1_@91 to main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait16 [phi:main::draw241_vdc_24x16_vram_ram1_@91->main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait16]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait16
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait16_vdc_register1
  // [574] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait16_vdc_write_nowait1
  // [575] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write_register_nowait16_d#0 -- _deref_pbuc1=vbuxx 
  stx VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_vdc_register16
  // [576] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // main::draw241_vdc_24x16_vram_ram1_@93
  // [577] main::draw241_vdc_24x16_vram_ram1_vdc_write46_d#0 = *(sprite_buffer+$2d) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$2d
  // [578] phi from main::draw241_vdc_24x16_vram_ram1_@93 to main::draw241_vdc_24x16_vram_ram1_vdc_write46 [phi:main::draw241_vdc_24x16_vram_ram1_@93->main::draw241_vdc_24x16_vram_ram1_vdc_write46]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write46
  // main::draw241_vdc_24x16_vram_ram1_vdc_write46_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write46_@1
  // [580] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write46_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@94
  // [581] main::draw241_vdc_24x16_vram_ram1_vdc_write47_d#0 = *(sprite_buffer+$2e) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$2e
  // [582] phi from main::draw241_vdc_24x16_vram_ram1_@94 to main::draw241_vdc_24x16_vram_ram1_vdc_write47 [phi:main::draw241_vdc_24x16_vram_ram1_@94->main::draw241_vdc_24x16_vram_ram1_vdc_write47]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write47
  // main::draw241_vdc_24x16_vram_ram1_vdc_write47_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write47_@1
  // [584] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write47_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::draw241_vdc_24x16_vram_ram1_@95
  // [585] main::draw241_vdc_24x16_vram_ram1_vdc_write48_d#0 = *(sprite_buffer+$2f) -- vbuaa=_deref_pbuc1 
  lda sprite_buffer+$2f
  // [586] phi from main::draw241_vdc_24x16_vram_ram1_@95 to main::draw241_vdc_24x16_vram_ram1_vdc_write48 [phi:main::draw241_vdc_24x16_vram_ram1_@95->main::draw241_vdc_24x16_vram_ram1_vdc_write48]
  // main::draw241_vdc_24x16_vram_ram1_vdc_write48
  // main::draw241_vdc_24x16_vram_ram1_vdc_write48_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::draw241_vdc_24x16_vram_ram1_vdc_write48_@1
  // [588] *VDC_DATA_PORT = main::draw241_vdc_24x16_vram_ram1_vdc_write48_d#0 -- _deref_pbuc1=vbuaa 
  sta VDC_DATA_PORT
  // main::@15
  // [589] main::s#1 = ++ main::s#10 -- vbuz1=_inc_vbuz1 
  inc.z s
  // [44] phi from main::@15 to main::@2 [phi:main::@15->main::@2]
  // [44] phi main::s#10 = main::s#1 [phi:main::@15->main::@2#0] -- register_copy 
  jmp __b2
  // main::read241_vdc_24x16_ram_vram1_@2
read241_vdc_24x16_ram_vram1___b2:
  // [590] main::read241_vdc_24x16_ram_vram1_vdc_write_register1_d#0 = byte1  main::read241_vdc_24x16_ram_vram1_vram_address#10 -- vbuz1=_byte1_vwuz2 
  lda.z read241_vdc_24x16_ram_vram1_vram_address+1
  sta.z read241_vdc_24x16_ram_vram1_vdc_write_register1_d
  // [591] phi from main::read241_vdc_24x16_ram_vram1_@2 to main::read241_vdc_24x16_ram_vram1_vdc_write_register1 [phi:main::read241_vdc_24x16_ram_vram1_@2->main::read241_vdc_24x16_ram_vram1_vdc_write_register1]
  // main::read241_vdc_24x16_ram_vram1_vdc_write_register1
  // main::read241_vdc_24x16_ram_vram1_vdc_write_register1_vdc_register1
  // [592] *VDC_REGISTER_PORT = VDC_R18_UADH -- _deref_pbuc1=vbuc2 
  lda #VDC_R18_UADH
  sta VDC_REGISTER_PORT
  // [593] phi from main::read241_vdc_24x16_ram_vram1_vdc_write_register1_vdc_register1 to main::read241_vdc_24x16_ram_vram1_vdc_write_register1_vdc_write1 [phi:main::read241_vdc_24x16_ram_vram1_vdc_write_register1_vdc_register1->main::read241_vdc_24x16_ram_vram1_vdc_write_register1_vdc_write1]
  // main::read241_vdc_24x16_ram_vram1_vdc_write_register1_vdc_write1
  // main::read241_vdc_24x16_ram_vram1_vdc_write_register1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::read241_vdc_24x16_ram_vram1_vdc_write_register1_@3
  // [595] *VDC_DATA_PORT = main::read241_vdc_24x16_ram_vram1_vdc_write_register1_d#0 -- _deref_pbuc1=vbuz1 
  lda.z read241_vdc_24x16_ram_vram1_vdc_write_register1_d
  sta VDC_DATA_PORT
  // main::read241_vdc_24x16_ram_vram1_@7
  // [596] main::read241_vdc_24x16_ram_vram1_vdc_write_register_nowait1_d#0 = byte0  main::read241_vdc_24x16_ram_vram1_vram_address#10 -- vbuz1=_byte0_vwuz2 
  lda.z read241_vdc_24x16_ram_vram1_vram_address
  sta.z read241_vdc_24x16_ram_vram1_vdc_write_register_nowait1_d
  // [597] phi from main::read241_vdc_24x16_ram_vram1_@7 to main::read241_vdc_24x16_ram_vram1_vdc_write_register_nowait1 [phi:main::read241_vdc_24x16_ram_vram1_@7->main::read241_vdc_24x16_ram_vram1_vdc_write_register_nowait1]
  // main::read241_vdc_24x16_ram_vram1_vdc_write_register_nowait1
  // main::read241_vdc_24x16_ram_vram1_vdc_write_register_nowait1_vdc_register1
  // [598] *VDC_REGISTER_PORT = VDC_R19_UADL -- _deref_pbuc1=vbuc2 
  lda #VDC_R19_UADL
  sta VDC_REGISTER_PORT
  // main::read241_vdc_24x16_ram_vram1_vdc_write_register_nowait1_vdc_write_nowait1
  // [599] *VDC_DATA_PORT = main::read241_vdc_24x16_ram_vram1_vdc_write_register_nowait1_d#0 -- _deref_pbuc1=vbuz1 
  lda.z read241_vdc_24x16_ram_vram1_vdc_write_register_nowait1_d
  sta VDC_DATA_PORT
  // main::read241_vdc_24x16_ram_vram1_vdc_register1
  // [600] *VDC_REGISTER_PORT = VDC_R31_DATA -- _deref_pbuc1=vbuc2 
  lda #VDC_R31_DATA
  sta VDC_REGISTER_PORT
  // [601] phi from main::read241_vdc_24x16_ram_vram1_vdc_register1 to main::read241_vdc_24x16_ram_vram1_vdc_read1 [phi:main::read241_vdc_24x16_ram_vram1_vdc_register1->main::read241_vdc_24x16_ram_vram1_vdc_read1]
  // main::read241_vdc_24x16_ram_vram1_vdc_read1
  // main::read241_vdc_24x16_ram_vram1_vdc_read1_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::read241_vdc_24x16_ram_vram1_vdc_read1_@2
  // [603] main::read241_vdc_24x16_ram_vram1_vdc_read1_return#0 = *VDC_DATA_PORT -- vbuaa=_deref_pbuc1 
  lda VDC_DATA_PORT
  // main::read241_vdc_24x16_ram_vram1_@10
  // [604] sprite_buffer[main::read241_vdc_24x16_ram_vram1_b#10] = main::read241_vdc_24x16_ram_vram1_vdc_read1_return#0 -- pbuc1_derefidx_vbuyy=vbuaa 
  sta sprite_buffer,y
  // [605] main::read241_vdc_24x16_ram_vram1_b#1 = ++ main::read241_vdc_24x16_ram_vram1_b#10 -- vbuyy=_inc_vbuyy 
  iny
  // [606] phi from main::read241_vdc_24x16_ram_vram1_@10 to main::read241_vdc_24x16_ram_vram1_vdc_read2 [phi:main::read241_vdc_24x16_ram_vram1_@10->main::read241_vdc_24x16_ram_vram1_vdc_read2]
  // main::read241_vdc_24x16_ram_vram1_vdc_read2
  // main::read241_vdc_24x16_ram_vram1_vdc_read2_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::read241_vdc_24x16_ram_vram1_vdc_read2_@2
  // [608] main::read241_vdc_24x16_ram_vram1_vdc_read2_return#0 = *VDC_DATA_PORT -- vbuaa=_deref_pbuc1 
  lda VDC_DATA_PORT
  // main::read241_vdc_24x16_ram_vram1_@11
  // [609] sprite_buffer[main::read241_vdc_24x16_ram_vram1_b#1] = main::read241_vdc_24x16_ram_vram1_vdc_read2_return#0 -- pbuc1_derefidx_vbuyy=vbuaa 
  sta sprite_buffer,y
  // [610] main::read241_vdc_24x16_ram_vram1_b#12 = ++ main::read241_vdc_24x16_ram_vram1_b#1 -- vbuyy=_inc_vbuyy 
  iny
  // [611] phi from main::read241_vdc_24x16_ram_vram1_@11 to main::read241_vdc_24x16_ram_vram1_vdc_read3 [phi:main::read241_vdc_24x16_ram_vram1_@11->main::read241_vdc_24x16_ram_vram1_vdc_read3]
  // main::read241_vdc_24x16_ram_vram1_vdc_read3
  // main::read241_vdc_24x16_ram_vram1_vdc_read3_vdc_wait1
  // asm { !: bitVDC_REGISTER_PORT bpl!-  }
!:
  bit VDC_REGISTER_PORT
  bpl !-
  // main::read241_vdc_24x16_ram_vram1_vdc_read3_@2
  // [613] main::read241_vdc_24x16_ram_vram1_vdc_read3_return#0 = *VDC_DATA_PORT -- vbuaa=_deref_pbuc1 
  lda VDC_DATA_PORT
  // main::read241_vdc_24x16_ram_vram1_@12
  // [614] sprite_buffer[main::read241_vdc_24x16_ram_vram1_b#12] = main::read241_vdc_24x16_ram_vram1_vdc_read3_return#0 -- pbuc1_derefidx_vbuyy=vbuaa 
  sta sprite_buffer,y
  // [615] main::read241_vdc_24x16_ram_vram1_b#3 = ++ main::read241_vdc_24x16_ram_vram1_b#12 -- vbuyy=_inc_vbuyy 
  iny
  // [616] main::read241_vdc_24x16_ram_vram1_vram_address#1 = main::read241_vdc_24x16_ram_vram1_vram_address#10 + *((char *)&vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES) -- vwuz1=vwuz1_plus__deref_pbuc1 
  lda vdc_config+OFFSET_STRUCT_VDC_CONFIGURATION_XBYTES
  clc
  adc.z read241_vdc_24x16_ram_vram1_vram_address
  sta.z read241_vdc_24x16_ram_vram1_vram_address
  bcc !+
  inc.z read241_vdc_24x16_ram_vram1_vram_address+1
!:
  // [617] main::read241_vdc_24x16_ram_vram1_row#1 = ++ main::read241_vdc_24x16_ram_vram1_row#10 -- vbuxx=_inc_vbuxx 
  inx
  // [72] phi from main::read241_vdc_24x16_ram_vram1_@12 to main::read241_vdc_24x16_ram_vram1_@1 [phi:main::read241_vdc_24x16_ram_vram1_@12->main::read241_vdc_24x16_ram_vram1_@1]
  // [72] phi main::read241_vdc_24x16_ram_vram1_b#10 = main::read241_vdc_24x16_ram_vram1_b#3 [phi:main::read241_vdc_24x16_ram_vram1_@12->main::read241_vdc_24x16_ram_vram1_@1#0] -- register_copy 
  // [72] phi main::read241_vdc_24x16_ram_vram1_vram_address#10 = main::read241_vdc_24x16_ram_vram1_vram_address#1 [phi:main::read241_vdc_24x16_ram_vram1_@12->main::read241_vdc_24x16_ram_vram1_@1#1] -- register_copy 
  // [72] phi main::read241_vdc_24x16_ram_vram1_row#10 = main::read241_vdc_24x16_ram_vram1_row#1 [phi:main::read241_vdc_24x16_ram_vram1_@12->main::read241_vdc_24x16_ram_vram1_@1#2] -- register_copy 
  jmp read241_vdc_24x16_ram_vram1___b1
.segment Data
  fx: .byte 0, $20, $40, $60, $80, $a0, $c0, $e0
.segment Data
  fy: .byte 0, $20, $40, $60, $80, $a0, $c0, $e0
.segment Data
  dx: .byte 1, 1, 1, 1, 1, 1, 1, 1
.segment Data
  dy: .byte -1, -1, -1, -1, -1, -1, -1, -1
.segment Data
  // Stationary direction.
  sm: .fill 8*4, 0
}

    // File Data Internal or Ignore
.segment Data
header:
.struct Sprite {tile, ext, start, count, skip, size, width, height, zorder, flipv, fliph, bpp, collision, reverse, palettecount, loop}

    .macro Data(sprite, tiledata, pallistdata) {
        // Header
//        .byte sprite.count, sprite.size, sprite.width, sprite.height, sprite.zorder, sprite.fliph, sprite.flipv, sprite.bpp, sprite.collision, sprite.reverse, sprite.loop,0,0,0,0

        // Sprite
        .print "tiledata.size = " + tiledata.size()
        .var col = 0
        .var line = ""
        .for(var i=0;i<tiledata.size();i++) {
            .eval line = line.string() + toBinaryString(tiledata.get(i),8) + " "
            .eval col = col + 1
            .if(col == sprite.width / 8) {
                .eval col = 0
                .print line 
                .eval line = ""
            }
            .byte tiledata.get(i)
        }
    }

.segment Data
functions:
.function GetPalette(bitmap) {
        .var palette = Hashtable()
        .var palList = List()
        .var nxt_idx = 0;
        .eval palette.put(0,0);
        .eval palList.add(0)
        .eval bitmap.size = (bitmap.width * bitmap.height) / (8 / bitmap.bpp)
        .eval bitmap.count = round((bitmap.count / bitmap.skip))
        .print "count = " + bitmap.count + "size = " + bitmap.size + ", width = " + bitmap.width + ", height = " + bitmap.height + ", bpp = " + bitmap.bpp
        .var image = bitmap.tile + "_" + bitmap.width + "x" + bitmap.height + "." + bitmap.ext
        .print image
        .var pic = LoadPicture(image)
        .var xoff = bitmap.width * bitmap.start
        .var yoff = 0
        .for(var p=0;p<bitmap.count;p++) {
            .for (var y=0; y<bitmap.height; y++) {
                .for (var x=xoff;x<bitmap.width+xoff; x++) {
                    // Find palette index (add if not known)
                    .var rgb = pic.getPixel(x,y)
                    .var idx = palette.get(rgb)
                    .if(idx==null) {
                        .eval idx = nxt_idx++
                        .eval palette.put(rgb,idx)
                        .eval palList.add(rgb)
                        .print "get rgb = " + toHexString(rgb) + " image = " + image + " x = " + x + " y = " + y
                    }
                }
            }
            .eval xoff += bitmap.width * bitmap.skip
        }
        .return palList
    }

    .function MakeTile(bitmap,pallist) {
        .var palette = Hashtable()
        .print "bpp=" + bitmap.bpp
        .for(var p=0;p<pallist.size();p++) {
            .eval palette.put(pallist.get(p),p);
        }
        .var tiledata = List()
        .var image = bitmap.tile + "_" + bitmap.width + "x" + bitmap.height + "." + bitmap.ext
        .var pic = LoadPicture(image)
        .var xoff = bitmap.width * bitmap.start
        .var yoff = 0
        .for(var p=0;p<bitmap.count;p++) {
            .var hstep = 8 / bitmap.bpp
            .var vstep = 1
            .var hinc = 8 / bitmap.bpp
            .var vinc = 1
//            .print "bitmap = " + p
            .for(var j=0; j<bitmap.height; j+=vstep) {
//                .print "j = " + j
                .for(var i=0+xoff; i<bitmap.width+xoff; i+=hstep) {
//                    .print "i = " + i
                    .for (var y=j; y<j+vstep; y+=vinc) {
//                        .print "y = " + y
                        .for (var x=i; x<i+hstep; x+=hinc) {
//                            .print "x = " + x
                            .var val = 0
                            .for(var v=0; v<hinc; v++) {
                                // Find palette index (add if not known)
                                .var rgb = pic.getPixel(x+v,y)
                                //.print "rgb == " + rgb
                                .if(rgb == 0) {
                                    .eval val = val * 2;
                                } else {
                                    .eval val = val * 2 + 1;
                                }
                            }
                            //.print "val = " + val
                            .eval tiledata.add(val);
                        }
                    }
                }
            }
            .eval xoff += bitmap.width * bitmap.skip
        }
        .return tiledata
    }

    .function MakePalette(bitmap,pallist) {
        .var palettedata = List()
        .print "put palette size = " + pallist.size()
        .if(pallist.size()>bitmap.palettecount) .error "Tile " + bitmap.tile + " has too many colours "+pallist.size()
        .for(var i=0;i<bitmap.palettecount;i++) {
            .var rgb = 0
            .if(i<pallist.size())
                .eval rgb = pallist.get(i)
            .var green = ((rgb >> 8) & $ff) & $f0
            .var blue = (rgb & $ff) >> 4
            .var red = (rgb >>16) >> 4
            .print "put rgb = " + toHexString(rgb) + " green = " + toHexString(green) + " blue = " + toHexString(blue) + " red = " + toHexString(red)
            // bits 4-8: green, bits 0-3 blue
            .eval palettedata.add(green | blue)
            // bits bits 0-3 red
            .eval palettedata.add(red)
            // .printnow "tile large: rgb = " + rgb + ", i = " + i
        }
        .return palettedata
    }


.segment Data
fly:
{
    .var sprite = Sprite("graphics/flies/fly_01","png",0,1,1,32,16,16,2,0,0,1,2,0,2,1)
    .var pallist = GetPalette(sprite)
    .var tiledata = MakeTile(sprite,pallist)
    .var pallistdata = MakePalette(sprite,pallist)
    Data(sprite,tiledata,pallistdata)
};
.segment Data
  sprite_buffer: .fill $54, 0
.segment Data
  sprites: .fill $a*8, 0
.segment Data
  sprite_shift0: .fill 4*$15, 0
.segment Data
  sprite_shift1: .fill 4*$15, 0
.segment Data
  sprite_shift2: .fill 4*$15, 0
.segment Data
  sprite_shift3: .fill 4*$15, 0
.segment Data
  sprite_shift4: .fill 4*$15, 0
.segment Data
  sprite_shift5: .fill 4*$15, 0
.segment Data
  sprite_shift6: .fill 4*$15, 0
.segment Data
  sprite_shift7: .fill 4*$15, 0
.segment Data
  sprite_shifts: .word sprite_shift0, sprite_shift1, sprite_shift2, sprite_shift3, sprite_shift4, sprite_shift5, sprite_shift6, sprite_shift7
.segment Data
  vram_addresses: .word 0, $2000
.segment Data
  vdc_config: .byte 0, 0, $50

