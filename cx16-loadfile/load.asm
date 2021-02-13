  // File Comments
//#pragma link("load.ld")
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="load.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  // Global Constants & labels
  .const WHITE = 1
  .const BLUE = 6
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
  .const VERA_LAYER_WIDTH_128 = $20
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_64 = $40
  .const VERA_LAYER_HEIGHT_MASK = $c0
  .const VERA_LAYER_CONFIG_256C = 8
  .const VERA_LAYER_TILEBASE_MASK = $fc
  // Common CBM Kernal Routines
  .const CBM_SETNAM = $ffbd
  // Set the name of a file.
  .const CBM_SETLFS = $ffba
  // Set the logical file.
  .const CBM_OPEN = $ffc0
  // Open the file for the current logical file.
  .const CBM_CHKIN = $ffc6
  // Set the logical channel for input.
  .const CBM_READST = $ffb7
  // Check I/O errors.
  .const CBM_CHRIN = $ffcf
  // Read a character from the current channel for input.
  .const CBM_CLOSE = $ffc3
  // Close a logical file.
  .const CBM_CLRCHN = $ffcc
  // Address to load to banked memory.
  .const loadtext = $2000
  .const SIZEOF_WORD = 2
  .const SIZEOF_POINTER = 2
  .const SIZEOF_DWORD = 4
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const OFFSET_STRUCT_MOS6522_VIA_PORT_A = 1
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  // $9F20 VRAM Address (7:0)
  .label VERA_ADDRX_L = $9f20
  // $9F21 VRAM Address (15:8)
  .label VERA_ADDRX_M = $9f21
  // $9F22 VRAM Address (7:0)
  // Bit 4-7: Address Increment  The following is the amount incremented per value value:increment
  //                             0:0, 1:1, 2:2, 3:4, 4:8, 5:16, 6:32, 7:64, 8:128, 9:256, 10:512, 11:40, 12:80, 13:160, 14:320, 15:640
  // Bit 3: DECR Setting the DECR bit, will decrement instead of increment by the value set by the 'Address Increment' field.
  // Bit 0: VRAM Address (16)
  .label VERA_ADDRX_H = $9f22
  // $9F23	DATA0	VRAM Data port 0
  .label VERA_DATA0 = $9f23
  // $9F24	DATA1	VRAM Data port 1
  .label VERA_DATA1 = $9f24
  // $9F25	CTRL Control
  // Bit 7: Reset
  // Bit 1: DCSEL
  // Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  // $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
  .label VERA_DC_HSCALE = $9f2a
  // $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
  .label VERA_DC_VSCALE = $9f2b
  // $9F2D	L0_CONFIG   Layer 0 Configuration
  .label VERA_L0_CONFIG = $9f2d
  // $9F2E	L0_MAPBASE	    Layer 0 Map Base Address (16:9)
  .label VERA_L0_MAPBASE = $9f2e
  // Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L0_TILEBASE = $9f2f
  // $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  // $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  // $9F36	L1_TILEBASE	    Layer 1 Tile Base
  // Bit 2-7: Tile Base Address (16:11)
  // Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  // Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L1_TILEBASE = $9f36
  // to POKE the address space.
  // The VIA#1: ROM/RAM Bank Control
  // Port A Bits 0-7 RAM bank
  // Port B Bits 0-2 ROM bank
  // Port B Bits 3-7 [TBD]
  .label VIA1 = $9f60
  .label text = $a000
  // Variable holding the screen width;
  .label conio_screen_width = 5
  // Variable holding the screen height;
  .label conio_screen_height = 6
  // Variable holding the screen layer on the VERA card with which conio interacts;
  .label conio_screen_layer = 7
  // Variables holding the current map width and map height of the layer.
  .label conio_width = 8
  .label conio_height = $a
  .label conio_rowshift = $c
  .label conio_rowskip = $d
  .label CONIO_SCREEN_BANK = $10
  // The screen width
  // The screen height
  // The text screen base address, which is a 16:0 bit value in VERA VRAM.
  // That is 128KB addressable space, thus 17 bits in total.
  // CONIO_SCREEN_TEXT contains bits 15:0 of the address.
  // CONIO_SCREEN_BANK contains bit 16, the the 64K memory bank in VERA VRAM (the upper 17th bit).
  // !!! note that these values are not const for the cx16!
  // This conio implements the two layers of VERA, which can be layer 0 or layer 1.
  // Configuring conio to output to a different layer, will change these fields to the address base
  // configured using VERA_L0_MAPBASE = 0x9f2e or VERA_L1_MAPBASE = 0x9f35.
  // Using the function setscreenlayer(layer) will re-calculate using CONIO_SCREEN_TEXT and CONIO_SCREEN_BASE
  // based on the values of VERA_L0_MAPBASE or VERA_L1_MAPBASE, mapping the base address of the selected layer.
  // The function setscreenlayermapbase(layer,mapbase) allows to configure bit 16:9 of the
  // mapbase address of the time map in VRAM of the selected layer VERA_L0_MAPBASE or VERA_L1_MAPBASE.
  .label CONIO_SCREEN_TEXT = $11
.segment Code
  // __start
__start: {
    // __start::__init1
    // conio_screen_width = 0
    // [1] conio_screen_width = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z conio_screen_width
    // conio_screen_height = 0
    // [2] conio_screen_height = 0 -- vbuz1=vbuc1 
    sta.z conio_screen_height
    // conio_screen_layer = 1
    // [3] conio_screen_layer = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z conio_screen_layer
    // conio_width = 0
    // [4] conio_width = 0 -- vwuz1=vwuc1 
    lda #<0
    sta.z conio_width
    sta.z conio_width+1
    // conio_height = 0
    // [5] conio_height = 0 -- vwuz1=vwuc1 
    sta.z conio_height
    sta.z conio_height+1
    // conio_rowshift = 0
    // [6] conio_rowshift = 0 -- vbuz1=vbuc1 
    sta.z conio_rowshift
    // conio_rowskip = 0
    // [7] conio_rowskip = 0 -- vwuz1=vwuc1 
    sta.z conio_rowskip
    sta.z conio_rowskip+1
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [8] call conio_x16_init 
    jsr conio_x16_init
    // [9] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [10] call main 
    // [32] phi from __start::@1 to main [phi:__start::@1->main]
    jsr main
    // __start::@return
    // [11] return 
    rts
}
  // conio_x16_init
// Set initial cursor position
conio_x16_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label line = 2
    // line = *BASIC_CURSOR_LINE
    // [12] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda BASIC_CURSOR_LINE
    sta.z line
    // vera_layer_mode_text(1,(dword)0x00000,(dword)0x0F800,128,64,8,8,16)
    // [13] call vera_layer_mode_text 
    // [52] phi from conio_x16_init to vera_layer_mode_text [phi:conio_x16_init->vera_layer_mode_text]
    jsr vera_layer_mode_text
    // [14] phi from conio_x16_init to conio_x16_init::@3 [phi:conio_x16_init->conio_x16_init::@3]
    // conio_x16_init::@3
    // screensize(&conio_screen_width, &conio_screen_height)
    // [15] call screensize 
    jsr screensize
    // [16] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // screenlayer(1)
    // [17] call screenlayer 
    jsr screenlayer
    // [18] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // vera_layer_set_textcolor(1, WHITE)
    // [19] call vera_layer_set_textcolor 
    jsr vera_layer_set_textcolor
    // [20] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // vera_layer_set_backcolor(1, BLUE)
    // [21] call vera_layer_set_backcolor 
    jsr vera_layer_set_backcolor
    // [22] phi from conio_x16_init::@6 to conio_x16_init::@7 [phi:conio_x16_init::@6->conio_x16_init::@7]
    // conio_x16_init::@7
    // vera_layer_set_mapbase(0,0x20)
    // [23] call vera_layer_set_mapbase 
    // [108] phi from conio_x16_init::@7 to vera_layer_set_mapbase [phi:conio_x16_init::@7->vera_layer_set_mapbase]
    // [108] phi vera_layer_set_mapbase::mapbase#3 = $20 [phi:conio_x16_init::@7->vera_layer_set_mapbase#0] -- vbuxx=vbuc1 
    ldx #$20
    // [108] phi vera_layer_set_mapbase::layer#3 = 0 [phi:conio_x16_init::@7->vera_layer_set_mapbase#1] -- vbuaa=vbuc1 
    lda #0
    jsr vera_layer_set_mapbase
    // [24] phi from conio_x16_init::@7 to conio_x16_init::@8 [phi:conio_x16_init::@7->conio_x16_init::@8]
    // conio_x16_init::@8
    // vera_layer_set_mapbase(1,0x00)
    // [25] call vera_layer_set_mapbase 
    // [108] phi from conio_x16_init::@8 to vera_layer_set_mapbase [phi:conio_x16_init::@8->vera_layer_set_mapbase]
    // [108] phi vera_layer_set_mapbase::mapbase#3 = 0 [phi:conio_x16_init::@8->vera_layer_set_mapbase#0] -- vbuxx=vbuc1 
    ldx #0
    // [108] phi vera_layer_set_mapbase::layer#3 = 1 [phi:conio_x16_init::@8->vera_layer_set_mapbase#1] -- vbuaa=vbuc1 
    lda #1
    jsr vera_layer_set_mapbase
    // conio_x16_init::@9
    // if(line>=CONIO_HEIGHT)
    // [26] if(conio_x16_init::line#0<conio_screen_height) goto conio_x16_init::@1 -- vbuz1_lt_vbuz2_then_la1 
    lda.z line
    cmp.z conio_screen_height
    bcc __b1
    // conio_x16_init::@2
    // line=CONIO_HEIGHT-1
    // [27] conio_x16_init::line#1 = conio_screen_height - 1 -- vbuz1=vbuz2_minus_1 
    ldx.z conio_screen_height
    dex
    stx.z line
    // [28] phi from conio_x16_init::@2 conio_x16_init::@9 to conio_x16_init::@1 [phi:conio_x16_init::@2/conio_x16_init::@9->conio_x16_init::@1]
    // [28] phi conio_x16_init::line#3 = conio_x16_init::line#1 [phi:conio_x16_init::@2/conio_x16_init::@9->conio_x16_init::@1#0] -- register_copy 
    // conio_x16_init::@1
  __b1:
    // gotoxy(0, line)
    // [29] gotoxy::y#0 = conio_x16_init::line#3 -- vbuxx=vbuz1 
    ldx.z line
    // [30] call gotoxy 
    // [113] phi from conio_x16_init::@1 to gotoxy [phi:conio_x16_init::@1->gotoxy]
    // [113] phi gotoxy::y#3 = gotoxy::y#0 [phi:conio_x16_init::@1->gotoxy#0] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [31] return 
    rts
}
  // main
main: {
    .label status = $f
    // clrscr()
    // [33] call clrscr 
    // Load sprite file into memory
    jsr clrscr
    // [34] phi from main to main::@3 [phi:main->main::@3]
    // main::@3
    // cx16_load_ram_banked(1, 8, 0, "TEXT", loadtext)
    // [35] call cx16_load_ram_banked 
    // [158] phi from main::@3 to cx16_load_ram_banked [phi:main::@3->cx16_load_ram_banked]
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, "TEXT", loadtext)
    // [36] cx16_load_ram_banked::return#4 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@4
    // status = cx16_load_ram_banked(1, 8, 0, "TEXT", loadtext)
    // [37] main::status#0 = cx16_load_ram_banked::return#4 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=0xff)
    // [38] if(main::status#0==$ff) goto main::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [39] phi from main::@4 to main::@2 [phi:main::@4->main::@2]
    // main::@2
    // printf("status = %x\n",status)
    // [40] call cputs 
    // [202] phi from main::@2 to cputs [phi:main::@2->cputs]
    // [202] phi cputs::s#8 = main::s2 [phi:main::@2->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@7
    // printf("status = %x\n",status)
    // [41] printf_uchar::uvalue#0 = main::status#0 -- vbuxx=vbuz1 
    ldx.z status
    // [42] call printf_uchar 
    // [210] phi from main::@7 to printf_uchar [phi:main::@7->printf_uchar]
    jsr printf_uchar
    // [43] phi from main::@7 to main::@8 [phi:main::@7->main::@8]
    // main::@8
    // printf("status = %x\n",status)
    // [44] call cputs 
    // [202] phi from main::@8 to cputs [phi:main::@8->cputs]
    // [202] phi cputs::s#8 = main::s1 [phi:main::@8->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [45] phi from main::@4 main::@8 to main::@1 [phi:main::@4/main::@8->main::@1]
    // main::@1
  __b1:
    // printf("text = %s\n", text)
    // [46] call cputs 
    // [202] phi from main::@1 to cputs [phi:main::@1->cputs]
    // [202] phi cputs::s#8 = main::s [phi:main::@1->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // [47] phi from main::@1 to main::@5 [phi:main::@1->main::@5]
    // main::@5
    // printf("text = %s\n", text)
    // [48] call printf_string 
    // [217] phi from main::@5 to printf_string [phi:main::@5->printf_string]
    jsr printf_string
    // [49] phi from main::@5 to main::@6 [phi:main::@5->main::@6]
    // main::@6
    // printf("text = %s\n", text)
    // [50] call cputs 
    // [202] phi from main::@6 to cputs [phi:main::@6->cputs]
    // [202] phi cputs::s#8 = main::s1 [phi:main::@6->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // main::@return
    // }
    // [51] return 
    rts
  .segment Data
    filename: .text "TEXT"
    .byte 0
    s: .text "text = "
    .byte 0
    s1: .text @"\n"
    .byte 0
    s2: .text "status = "
    .byte 0
}
.segment Code
  // vera_layer_mode_text
// Set a vera layer in text mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// - mapwidth: The width of the map in number of tiles.
// - mapheight: The height of the map in number of tiles.
// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
// - tileheight: The height of a tile, which can be 8 or 16 pixels.
// - color_mode: The color mode, which can be 16 or 256.
vera_layer_mode_text: {
    .label layer = 1
    .label mapbase_address = 0
    .label tilebase_address = $f800
    // vera_layer_mode_tile( layer, mapbase_address, tilebase_address, mapwidth, mapheight, tilewidth, tileheight, 1 )
    // [53] call vera_layer_mode_tile 
    // [221] phi from vera_layer_mode_text to vera_layer_mode_tile [phi:vera_layer_mode_text->vera_layer_mode_tile]
    jsr vera_layer_mode_tile
    // [54] phi from vera_layer_mode_text to vera_layer_mode_text::@1 [phi:vera_layer_mode_text->vera_layer_mode_text::@1]
    // vera_layer_mode_text::@1
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C )
    // [55] call vera_layer_set_text_color_mode 
    jsr vera_layer_set_text_color_mode
    // vera_layer_mode_text::@return
    // }
    // [56] return 
    rts
}
  // screensize
// Return the current screen size.
screensize: {
    .label x = conio_screen_width
    .label y = conio_screen_height
    // hscale = (*VERA_DC_HSCALE) >> 7
    // [57] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuaa=_deref_pbuc1_ror_7 
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    // 40 << hscale
    // [58] screensize::$1 = $28 << screensize::hscale#0 -- vbuaa=vbuc1_rol_vbuaa 
    tay
    lda #$28
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    // *x = 40 << hscale
    // [59] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbuaa 
    sta.z x
    // vscale = (*VERA_DC_VSCALE) >> 7
    // [60] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuaa=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    // 30 << vscale
    // [61] screensize::$3 = $1e << screensize::vscale#0 -- vbuaa=vbuc1_rol_vbuaa 
    tay
    lda #$1e
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    // *y = 30 << vscale
    // [62] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbuaa 
    sta.z y
    // screensize::@return
    // }
    // [63] return 
    rts
}
  // screenlayer
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer: {
    .const layer = 1
    .label __2 = $13
    .label __4 = $15
    .label __5 = $2b
    .label vera_layer_get_width1_config = $2d
    .label vera_layer_get_width1_return = $13
    .label vera_layer_get_height1_config = $1e
    .label vera_layer_get_height1_return = $2b
    // conio_screen_layer = layer
    // [64] conio_screen_layer = screenlayer::layer#0 -- vbuz1=vbuc1 
    lda #layer
    sta.z conio_screen_layer
    // vera_layer_get_mapbase_bank(conio_screen_layer)
    // [65] vera_layer_get_mapbase_bank::layer#0 = conio_screen_layer -- vbuxx=vbuz1 
    tax
    // [66] call vera_layer_get_mapbase_bank 
    jsr vera_layer_get_mapbase_bank
    // [67] vera_layer_get_mapbase_bank::return#2 = vera_layer_get_mapbase_bank::return#0
    // screenlayer::@3
    // [68] CONIO_SCREEN_BANK#11 = vera_layer_get_mapbase_bank::return#2 -- vbuz1=vbuaa 
    sta.z CONIO_SCREEN_BANK
    // vera_layer_get_mapbase_offset(conio_screen_layer)
    // [69] vera_layer_get_mapbase_offset::layer#0 = conio_screen_layer -- vbuaa=vbuz1 
    lda.z conio_screen_layer
    // [70] call vera_layer_get_mapbase_offset 
    jsr vera_layer_get_mapbase_offset
    // [71] vera_layer_get_mapbase_offset::return#2 = vera_layer_get_mapbase_offset::return#0
    // screenlayer::@4
    // [72] CONIO_SCREEN_TEXT#13 = vera_layer_get_mapbase_offset::return#2 -- vwuz1=vwuz2 
    lda.z vera_layer_get_mapbase_offset.return
    sta.z CONIO_SCREEN_TEXT
    lda.z vera_layer_get_mapbase_offset.return+1
    sta.z CONIO_SCREEN_TEXT+1
    // vera_layer_get_width(conio_screen_layer)
    // [73] screenlayer::vera_layer_get_width1_layer#0 = conio_screen_layer -- vbuaa=vbuz1 
    lda.z conio_screen_layer
    // screenlayer::vera_layer_get_width1
    // config = vera_layer_config[layer]
    // [74] screenlayer::vera_layer_get_width1_$2 = screenlayer::vera_layer_get_width1_layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [75] screenlayer::vera_layer_get_width1_config#0 = vera_layer_config[screenlayer::vera_layer_get_width1_$2] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z vera_layer_get_width1_config
    lda vera_layer_config+1,y
    sta.z vera_layer_get_width1_config+1
    // *config & VERA_LAYER_WIDTH_MASK
    // [76] screenlayer::vera_layer_get_width1_$0 = *screenlayer::vera_layer_get_width1_config#0 & VERA_LAYER_WIDTH_MASK -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    ldy #0
    and (vera_layer_get_width1_config),y
    // (*config & VERA_LAYER_WIDTH_MASK) >> 4
    // [77] screenlayer::vera_layer_get_width1_$1 = screenlayer::vera_layer_get_width1_$0 >> 4 -- vbuaa=vbuaa_ror_4 
    lsr
    lsr
    lsr
    lsr
    // return VERA_LAYER_WIDTH[ (*config & VERA_LAYER_WIDTH_MASK) >> 4];
    // [78] screenlayer::vera_layer_get_width1_$3 = screenlayer::vera_layer_get_width1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [79] screenlayer::vera_layer_get_width1_return#0 = VERA_LAYER_WIDTH[screenlayer::vera_layer_get_width1_$3] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda VERA_LAYER_WIDTH,y
    sta.z vera_layer_get_width1_return
    lda VERA_LAYER_WIDTH+1,y
    sta.z vera_layer_get_width1_return+1
    // screenlayer::vera_layer_get_width1_@return
    // }
    // [80] screenlayer::vera_layer_get_width1_return#1 = screenlayer::vera_layer_get_width1_return#0
    // screenlayer::@1
    // vera_layer_get_width(conio_screen_layer)
    // [81] screenlayer::$2 = screenlayer::vera_layer_get_width1_return#1
    // conio_width = vera_layer_get_width(conio_screen_layer)
    // [82] conio_width = screenlayer::$2 -- vwuz1=vwuz2 
    lda.z __2
    sta.z conio_width
    lda.z __2+1
    sta.z conio_width+1
    // vera_layer_get_rowshift(conio_screen_layer)
    // [83] vera_layer_get_rowshift::layer#0 = conio_screen_layer -- vbuxx=vbuz1 
    ldx.z conio_screen_layer
    // [84] call vera_layer_get_rowshift 
    jsr vera_layer_get_rowshift
    // [85] vera_layer_get_rowshift::return#2 = vera_layer_get_rowshift::return#0
    // screenlayer::@5
    // [86] screenlayer::$3 = vera_layer_get_rowshift::return#2
    // conio_rowshift = vera_layer_get_rowshift(conio_screen_layer)
    // [87] conio_rowshift = screenlayer::$3 -- vbuz1=vbuaa 
    sta.z conio_rowshift
    // vera_layer_get_rowskip(conio_screen_layer)
    // [88] vera_layer_get_rowskip::layer#0 = conio_screen_layer -- vbuaa=vbuz1 
    lda.z conio_screen_layer
    // [89] call vera_layer_get_rowskip 
    jsr vera_layer_get_rowskip
    // [90] vera_layer_get_rowskip::return#2 = vera_layer_get_rowskip::return#0
    // screenlayer::@6
    // [91] screenlayer::$4 = vera_layer_get_rowskip::return#2
    // conio_rowskip = vera_layer_get_rowskip(conio_screen_layer)
    // [92] conio_rowskip = screenlayer::$4 -- vwuz1=vwuz2 
    lda.z __4
    sta.z conio_rowskip
    lda.z __4+1
    sta.z conio_rowskip+1
    // vera_layer_get_height(conio_screen_layer)
    // [93] screenlayer::vera_layer_get_height1_layer#0 = conio_screen_layer -- vbuaa=vbuz1 
    lda.z conio_screen_layer
    // screenlayer::vera_layer_get_height1
    // config = vera_layer_config[layer]
    // [94] screenlayer::vera_layer_get_height1_$2 = screenlayer::vera_layer_get_height1_layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [95] screenlayer::vera_layer_get_height1_config#0 = vera_layer_config[screenlayer::vera_layer_get_height1_$2] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z vera_layer_get_height1_config
    lda vera_layer_config+1,y
    sta.z vera_layer_get_height1_config+1
    // *config & VERA_LAYER_HEIGHT_MASK
    // [96] screenlayer::vera_layer_get_height1_$0 = *screenlayer::vera_layer_get_height1_config#0 & VERA_LAYER_HEIGHT_MASK -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    ldy #0
    and (vera_layer_get_height1_config),y
    // (*config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [97] screenlayer::vera_layer_get_height1_$1 = screenlayer::vera_layer_get_height1_$0 >> 6 -- vbuaa=vbuaa_ror_6 
    rol
    rol
    rol
    and #3
    // return VERA_LAYER_HEIGHT[ (*config & VERA_LAYER_HEIGHT_MASK) >> 6];
    // [98] screenlayer::vera_layer_get_height1_$3 = screenlayer::vera_layer_get_height1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [99] screenlayer::vera_layer_get_height1_return#0 = VERA_LAYER_HEIGHT[screenlayer::vera_layer_get_height1_$3] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda VERA_LAYER_HEIGHT,y
    sta.z vera_layer_get_height1_return
    lda VERA_LAYER_HEIGHT+1,y
    sta.z vera_layer_get_height1_return+1
    // screenlayer::vera_layer_get_height1_@return
    // }
    // [100] screenlayer::vera_layer_get_height1_return#1 = screenlayer::vera_layer_get_height1_return#0
    // screenlayer::@2
    // vera_layer_get_height(conio_screen_layer)
    // [101] screenlayer::$5 = screenlayer::vera_layer_get_height1_return#1
    // conio_height = vera_layer_get_height(conio_screen_layer)
    // [102] conio_height = screenlayer::$5 -- vwuz1=vwuz2 
    lda.z __5
    sta.z conio_height
    lda.z __5+1
    sta.z conio_height+1
    // screenlayer::@return
    // }
    // [103] return 
    rts
}
  // vera_layer_set_textcolor
// Set the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15) when the VERA works in 16x16 color text mode.
//   An 8 bit value (decimal between 0 and 255) when the VERA works in 256 text mode.
//   Note that on the VERA, the transparent color has value 0.
vera_layer_set_textcolor: {
    .const layer = 1
    // vera_layer_textcolor[layer] = color
    // [104] *(vera_layer_textcolor+vera_layer_set_textcolor::layer#0) = WHITE -- _deref_pbuc1=vbuc2 
    lda #WHITE
    sta vera_layer_textcolor+layer
    // vera_layer_set_textcolor::@return
    // }
    // [105] return 
    rts
}
  // vera_layer_set_backcolor
// Set the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
vera_layer_set_backcolor: {
    .const layer = 1
    // vera_layer_backcolor[layer] = color
    // [106] *(vera_layer_backcolor+vera_layer_set_backcolor::layer#0) = BLUE -- _deref_pbuc1=vbuc2 
    lda #BLUE
    sta vera_layer_backcolor+layer
    // vera_layer_set_backcolor::@return
    // }
    // [107] return 
    rts
}
  // vera_layer_set_mapbase
// Set the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - mapbase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// vera_layer_set_mapbase(byte register(A) layer, byte register(X) mapbase)
vera_layer_set_mapbase: {
    .label addr = $13
    // addr = vera_layer_mapbase[layer]
    // [109] vera_layer_set_mapbase::$0 = vera_layer_set_mapbase::layer#3 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [110] vera_layer_set_mapbase::addr#0 = vera_layer_mapbase[vera_layer_set_mapbase::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_mapbase,y
    sta.z addr
    lda vera_layer_mapbase+1,y
    sta.z addr+1
    // *addr = mapbase
    // [111] *vera_layer_set_mapbase::addr#0 = vera_layer_set_mapbase::mapbase#3 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_mapbase::@return
    // }
    // [112] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .label __6 = $15
    .label line_offset = $15
    // if(y>CONIO_HEIGHT)
    // [114] if(gotoxy::y#3<=conio_screen_height) goto gotoxy::@4 -- vbuxx_le_vbuz1_then_la1 
    lda.z conio_screen_height
    stx.z $ff
    cmp.z $ff
    bcs __b1
    // [116] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [116] phi gotoxy::y#4 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [115] phi from gotoxy to gotoxy::@4 [phi:gotoxy->gotoxy::@4]
    // gotoxy::@4
    // [116] phi from gotoxy::@4 to gotoxy::@1 [phi:gotoxy::@4->gotoxy::@1]
    // [116] phi gotoxy::y#4 = gotoxy::y#3 [phi:gotoxy::@4->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=CONIO_WIDTH)
    // [117] if(0<conio_screen_width) goto gotoxy::@2 -- 0_lt_vbuz1_then_la1 
    lda.z conio_screen_width
    // [118] phi from gotoxy::@1 to gotoxy::@3 [phi:gotoxy::@1->gotoxy::@3]
    // gotoxy::@3
    // gotoxy::@2
    // conio_cursor_x[conio_screen_layer] = x
    // [119] conio_cursor_x[conio_screen_layer] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z conio_screen_layer
    sta conio_cursor_x,y
    // conio_cursor_y[conio_screen_layer] = y
    // [120] conio_cursor_y[conio_screen_layer] = gotoxy::y#4 -- pbuc1_derefidx_vbuz1=vbuxx 
    txa
    sta conio_cursor_y,y
    // (unsigned int)y << conio_rowshift
    // [121] gotoxy::$6 = (word)gotoxy::y#4 -- vwuz1=_word_vbuxx 
    txa
    sta.z __6
    lda #0
    sta.z __6+1
    // line_offset = (unsigned int)y << conio_rowshift
    // [122] gotoxy::line_offset#0 = gotoxy::$6 << conio_rowshift -- vwuz1=vwuz1_rol_vbuz2 
    ldy.z conio_rowshift
    beq !e+
  !:
    asl.z line_offset
    rol.z line_offset+1
    dey
    bne !-
  !e:
    // conio_line_text[conio_screen_layer] = line_offset
    // [123] gotoxy::$5 = conio_screen_layer << 1 -- vbuaa=vbuz1_rol_1 
    lda.z conio_screen_layer
    asl
    // [124] conio_line_text[gotoxy::$5] = gotoxy::line_offset#0 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z line_offset
    sta conio_line_text,y
    lda.z line_offset+1
    sta conio_line_text+1,y
    // gotoxy::@return
    // }
    // [125] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __1 = $28
    .label line_text = 3
    .label color = $28
    // line_text = CONIO_SCREEN_TEXT
    // [126] clrscr::line_text#0 = (byte*)CONIO_SCREEN_TEXT#13 -- pbuz1=pbuz2 
    lda.z CONIO_SCREEN_TEXT
    sta.z line_text
    lda.z CONIO_SCREEN_TEXT+1
    sta.z line_text+1
    // vera_layer_get_backcolor(conio_screen_layer)
    // [127] vera_layer_get_backcolor::layer#0 = conio_screen_layer -- vbuxx=vbuz1 
    ldx.z conio_screen_layer
    // [128] call vera_layer_get_backcolor 
    jsr vera_layer_get_backcolor
    // [129] vera_layer_get_backcolor::return#2 = vera_layer_get_backcolor::return#0
    // clrscr::@7
    // [130] clrscr::$0 = vera_layer_get_backcolor::return#2
    // vera_layer_get_backcolor(conio_screen_layer) << 4
    // [131] clrscr::$1 = clrscr::$0 << 4 -- vbuz1=vbuaa_rol_4 
    asl
    asl
    asl
    asl
    sta.z __1
    // vera_layer_get_textcolor(conio_screen_layer)
    // [132] vera_layer_get_textcolor::layer#0 = conio_screen_layer -- vbuxx=vbuz1 
    ldx.z conio_screen_layer
    // [133] call vera_layer_get_textcolor 
    jsr vera_layer_get_textcolor
    // [134] vera_layer_get_textcolor::return#2 = vera_layer_get_textcolor::return#0
    // clrscr::@8
    // [135] clrscr::$2 = vera_layer_get_textcolor::return#2
    // color = ( vera_layer_get_backcolor(conio_screen_layer) << 4 ) | vera_layer_get_textcolor(conio_screen_layer)
    // [136] clrscr::color#0 = clrscr::$1 | clrscr::$2 -- vbuz1=vbuz1_bor_vbuaa 
    ora.z color
    sta.z color
    // [137] phi from clrscr::@8 to clrscr::@1 [phi:clrscr::@8->clrscr::@1]
    // [137] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr::@8->clrscr::@1#0] -- register_copy 
    // [137] phi clrscr::l#2 = 0 [phi:clrscr::@8->clrscr::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // clrscr::@1
  __b1:
    // for( char l=0;l<conio_height; l++ )
    // [138] if(clrscr::l#2<conio_height) goto clrscr::@2 -- vbuxx_lt_vwuz1_then_la1 
    lda.z conio_height+1
    bne __b2
    cpx.z conio_height
    bcc __b2
    // clrscr::@3
    // conio_cursor_x[conio_screen_layer] = 0
    // [139] conio_cursor_x[conio_screen_layer] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z conio_screen_layer
    sta conio_cursor_x,y
    // conio_cursor_y[conio_screen_layer] = 0
    // [140] conio_cursor_y[conio_screen_layer] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta conio_cursor_y,y
    // conio_line_text[conio_screen_layer] = 0
    // [141] clrscr::$9 = conio_screen_layer << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [142] conio_line_text[clrscr::$9] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta conio_line_text,y
    sta conio_line_text+1,y
    // clrscr::@return
    // }
    // [143] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [144] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <ch
    // [145] clrscr::$5 = < clrscr::line_text#2 -- vbuaa=_lo_pbuz1 
    lda.z line_text
    // *VERA_ADDRX_L = <ch
    // [146] *VERA_ADDRX_L = clrscr::$5 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >ch
    // [147] clrscr::$6 = > clrscr::line_text#2 -- vbuaa=_hi_pbuz1 
    lda.z line_text+1
    // *VERA_ADDRX_M = >ch
    // [148] *VERA_ADDRX_M = clrscr::$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // CONIO_SCREEN_BANK | VERA_INC_1
    // [149] clrscr::$7 = CONIO_SCREEN_BANK#11 | VERA_INC_1 -- vbuaa=vbuz1_bor_vbuc1 
    lda #VERA_INC_1
    ora.z CONIO_SCREEN_BANK
    // *VERA_ADDRX_H = CONIO_SCREEN_BANK | VERA_INC_1
    // [150] *VERA_ADDRX_H = clrscr::$7 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [151] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [151] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuyy=vbuc1 
    ldy #0
    // clrscr::@4
  __b4:
    // for( char c=0;c<conio_width; c++ )
    // [152] if(clrscr::c#2<conio_width) goto clrscr::@5 -- vbuyy_lt_vwuz1_then_la1 
    lda.z conio_width+1
    bne __b5
    cpy.z conio_width
    bcc __b5
    // clrscr::@6
    // line_text += conio_rowskip
    // [153] clrscr::line_text#1 = clrscr::line_text#2 + conio_rowskip -- pbuz1=pbuz1_plus_vwuz2 
    lda.z line_text
    clc
    adc.z conio_rowskip
    sta.z line_text
    lda.z line_text+1
    adc.z conio_rowskip+1
    sta.z line_text+1
    // for( char l=0;l<conio_height; l++ )
    // [154] clrscr::l#1 = ++ clrscr::l#2 -- vbuxx=_inc_vbuxx 
    inx
    // [137] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [137] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [137] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [155] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [156] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<conio_width; c++ )
    // [157] clrscr::c#1 = ++ clrscr::c#2 -- vbuyy=_inc_vbuyy 
    iny
    // [151] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [151] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
}
  // cx16_load_ram_banked
// Load a file to cx16 banked RAM at address A000-BFFF.
// Returns a status:
// - 0xff: Success
// - other: Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
cx16_load_ram_banked: {
    .const channel = 1
    .const device = 8
    .const secondary = 0
    .label bank = (>((loadtext&$ffff)))>>5
    .label status = $28
    .label return = $28
    .label ch = $31
    // stip off the top 3 bits, which are representing the bank of the word!
    .label addr = 3
    // cx16_ram_bank(bank)
    // [159] call cx16_ram_bank 
    jsr cx16_ram_bank
    // cx16_load_ram_banked::@6
    // cbm_k_setnam(filename)
    // [160] cbm_k_setnam::filename = main::filename -- pbuz1=pbuc1 
    lda #<main.filename
    sta.z cbm_k_setnam.filename
    lda #>main.filename
    sta.z cbm_k_setnam.filename+1
    // [161] call cbm_k_setnam 
    jsr cbm_k_setnam
    // cx16_load_ram_banked::@7
    // cbm_k_setlfs(channel, device, secondary)
    // [162] cbm_k_setlfs::channel = cx16_load_ram_banked::channel#0 -- vbuz1=vbuc1 
    lda #channel
    sta.z cbm_k_setlfs.channel
    // [163] cbm_k_setlfs::device = cx16_load_ram_banked::device#0 -- vbuz1=vbuc1 
    lda #device
    sta.z cbm_k_setlfs.device
    // [164] cbm_k_setlfs::secondary = cx16_load_ram_banked::secondary#0 -- vbuz1=vbuc1 
    lda #secondary
    sta.z cbm_k_setlfs.secondary
    // [165] call cbm_k_setlfs 
    jsr cbm_k_setlfs
    // [166] phi from cx16_load_ram_banked::@7 to cx16_load_ram_banked::@8 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@8]
    // cx16_load_ram_banked::@8
    // cbm_k_open()
    // [167] call cbm_k_open 
    jsr cbm_k_open
    // [168] cbm_k_open::return#2 = cbm_k_open::return#1
    // cx16_load_ram_banked::@9
    // [169] cx16_load_ram_banked::status#1 = cbm_k_open::return#2 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$FF)
    // [170] if(cx16_load_ram_banked::status#1==$ff) goto cx16_load_ram_banked::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [171] phi from cx16_load_ram_banked::@10 cx16_load_ram_banked::@16 cx16_load_ram_banked::@9 to cx16_load_ram_banked::@return [phi:cx16_load_ram_banked::@10/cx16_load_ram_banked::@16/cx16_load_ram_banked::@9->cx16_load_ram_banked::@return]
    // [171] phi cx16_load_ram_banked::return#1 = cx16_load_ram_banked::status#2 [phi:cx16_load_ram_banked::@10/cx16_load_ram_banked::@16/cx16_load_ram_banked::@9->cx16_load_ram_banked::@return#0] -- register_copy 
    // cx16_load_ram_banked::@return
    // }
    // [172] return 
    rts
    // cx16_load_ram_banked::@1
  __b1:
    // cbm_k_chkin(channel)
    // [173] cbm_k_chkin::channel = cx16_load_ram_banked::channel#0 -- vbuz1=vbuc1 
    lda #channel
    sta.z cbm_k_chkin.channel
    // [174] call cbm_k_chkin 
    jsr cbm_k_chkin
    // [175] cbm_k_chkin::return#2 = cbm_k_chkin::return#1
    // cx16_load_ram_banked::@10
    // [176] cx16_load_ram_banked::status#2 = cbm_k_chkin::return#2 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$FF)
    // [177] if(cx16_load_ram_banked::status#2==$ff) goto cx16_load_ram_banked::@2 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b2
    rts
    // [178] phi from cx16_load_ram_banked::@10 to cx16_load_ram_banked::@2 [phi:cx16_load_ram_banked::@10->cx16_load_ram_banked::@2]
    // cx16_load_ram_banked::@2
  __b2:
    // cbm_k_chrin()
    // [179] call cbm_k_chrin 
    jsr cbm_k_chrin
    // [180] cbm_k_chrin::return#2 = cbm_k_chrin::return#1
    // cx16_load_ram_banked::@11
    // ch = cbm_k_chrin()
    // [181] cx16_load_ram_banked::ch#1 = cbm_k_chrin::return#2 -- vbuz1=vbuaa 
    sta.z ch
    // cbm_k_readst()
    // [182] call cbm_k_readst 
    jsr cbm_k_readst
    // [183] cbm_k_readst::return#2 = cbm_k_readst::return#1
    // cx16_load_ram_banked::@12
    // status = cbm_k_readst()
    // [184] cx16_load_ram_banked::status#3 = cbm_k_readst::return#2 -- vbuxx=vbuaa 
    tax
    // [185] phi from cx16_load_ram_banked::@12 to cx16_load_ram_banked::@3 [phi:cx16_load_ram_banked::@12->cx16_load_ram_banked::@3]
    // [185] phi cx16_load_ram_banked::addr#3 = (byte*)0+$a000 [phi:cx16_load_ram_banked::@12->cx16_load_ram_banked::@3#0] -- pbuz1=pbuc1 
    lda #<0+$a000
    sta.z addr
    lda #>0+$a000
    sta.z addr+1
    // [185] phi cx16_load_ram_banked::ch#3 = cx16_load_ram_banked::ch#1 [phi:cx16_load_ram_banked::@12->cx16_load_ram_banked::@3#1] -- register_copy 
    // [185] phi cx16_load_ram_banked::status#8 = cx16_load_ram_banked::status#3 [phi:cx16_load_ram_banked::@12->cx16_load_ram_banked::@3#2] -- register_copy 
    // cx16_load_ram_banked::@3
  __b3:
    // while (!status)
    // [186] if(0==cx16_load_ram_banked::status#8) goto cx16_load_ram_banked::@4 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq __b4
    // cx16_load_ram_banked::@5
    // cbm_k_close(channel)
    // [187] cbm_k_close::channel = cx16_load_ram_banked::channel#0 -- vbuz1=vbuc1 
    lda #channel
    sta.z cbm_k_close.channel
    // [188] call cbm_k_close 
    jsr cbm_k_close
    // [189] cbm_k_close::return#2 = cbm_k_close::return#1
    // cx16_load_ram_banked::@15
    // [190] cx16_load_ram_banked::status#10 = cbm_k_close::return#2 -- vbuz1=vbuaa 
    sta.z status
    // cbm_k_clrchn()
    // [191] call cbm_k_clrchn 
    jsr cbm_k_clrchn
    // [192] phi from cx16_load_ram_banked::@15 to cx16_load_ram_banked::@16 [phi:cx16_load_ram_banked::@15->cx16_load_ram_banked::@16]
    // cx16_load_ram_banked::@16
    // cx16_ram_bank(bank)
    // [193] call cx16_ram_bank 
    jsr cx16_ram_bank
    rts
    // cx16_load_ram_banked::@4
  __b4:
    // *addr = ch
    // [194] *cx16_load_ram_banked::addr#3 = cx16_load_ram_banked::ch#3 -- _deref_pbuz1=vbuz2 
    lda.z ch
    ldy #0
    sta (addr),y
    // addr++;
    // [195] cx16_load_ram_banked::addr#2 = ++ cx16_load_ram_banked::addr#3 -- pbuz1=_inc_pbuz1 
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    // cbm_k_chrin()
    // [196] call cbm_k_chrin 
    jsr cbm_k_chrin
    // [197] cbm_k_chrin::return#3 = cbm_k_chrin::return#1
    // cx16_load_ram_banked::@13
    // ch = cbm_k_chrin()
    // [198] cx16_load_ram_banked::ch#2 = cbm_k_chrin::return#3 -- vbuz1=vbuaa 
    sta.z ch
    // cbm_k_readst()
    // [199] call cbm_k_readst 
    jsr cbm_k_readst
    // [200] cbm_k_readst::return#3 = cbm_k_readst::return#1
    // cx16_load_ram_banked::@14
    // status = cbm_k_readst()
    // [201] cx16_load_ram_banked::status#4 = cbm_k_readst::return#3 -- vbuxx=vbuaa 
    tax
    // [185] phi from cx16_load_ram_banked::@14 to cx16_load_ram_banked::@3 [phi:cx16_load_ram_banked::@14->cx16_load_ram_banked::@3]
    // [185] phi cx16_load_ram_banked::addr#3 = cx16_load_ram_banked::addr#2 [phi:cx16_load_ram_banked::@14->cx16_load_ram_banked::@3#0] -- register_copy 
    // [185] phi cx16_load_ram_banked::ch#3 = cx16_load_ram_banked::ch#2 [phi:cx16_load_ram_banked::@14->cx16_load_ram_banked::@3#1] -- register_copy 
    // [185] phi cx16_load_ram_banked::status#8 = cx16_load_ram_banked::status#4 [phi:cx16_load_ram_banked::@14->cx16_load_ram_banked::@3#2] -- register_copy 
    jmp __b3
}
  // cputs
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp(3) s)
cputs: {
    .label s = 3
    // [203] phi from cputs cputs::@2 to cputs::@1 [phi:cputs/cputs::@2->cputs::@1]
    // [203] phi cputs::s#7 = cputs::s#8 [phi:cputs/cputs::@2->cputs::@1#0] -- register_copy 
    // cputs::@1
  __b1:
    // while(c=*s++)
    // [204] cputs::c#1 = *cputs::s#7 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (s),y
    // [205] cputs::s#0 = ++ cputs::s#7 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [206] if(0!=cputs::c#1) goto cputs::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // cputs::@return
    // }
    // [207] return 
    rts
    // cputs::@2
  __b2:
    // cputc(c)
    // [208] cputc::c#0 = cputs::c#1 -- vbuz1=vbuaa 
    sta.z cputc.c
    // [209] call cputc 
    // [292] phi from cputs::@2 to cputc [phi:cputs::@2->cputc]
    // [292] phi cputc::c#3 = cputc::c#0 [phi:cputs::@2->cputc#0] -- register_copy 
    jsr cputc
    jmp __b1
}
  // printf_uchar
// Print an unsigned char using a specific format
// printf_uchar(byte register(X) uvalue)
printf_uchar: {
    // printf_uchar::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [211] *((byte*)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    // [212] uctoa::value#1 = printf_uchar::uvalue#0
    // [213] call uctoa 
  // Format number into buffer
    // [324] phi from printf_uchar::@1 to uctoa [phi:printf_uchar::@1->uctoa]
    jsr uctoa
    // printf_uchar::@2
    // printf_number_buffer(printf_buffer, format)
    // [214] printf_number_buffer::buffer_sign#0 = *((byte*)&printf_buffer) -- vbuaa=_deref_pbuc1 
    lda printf_buffer
    // [215] call printf_number_buffer 
  // Print using format
    // [343] phi from printf_uchar::@2 to printf_number_buffer [phi:printf_uchar::@2->printf_number_buffer]
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [216] return 
    rts
}
  // printf_string
// Print a string value using a specific format
// Handles justification and min length 
printf_string: {
    // [218] phi from printf_string to printf_string::@1 [phi:printf_string->printf_string::@1]
    // printf_string::@1
    // cputs(str)
    // [219] call cputs 
    // [202] phi from printf_string::@1 to cputs [phi:printf_string::@1->cputs]
    // [202] phi cputs::s#8 = text [phi:printf_string::@1->cputs#0] -- pbuz1=pbuc1 
    lda #<text
    sta.z cputs.s
    lda #>text
    sta.z cputs.s+1
    jsr cputs
    // printf_string::@return
    // }
    // [220] return 
    rts
}
  // vera_layer_mode_tile
// Set a vera layer in tile mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// - mapwidth: The width of the map in number of tiles.
// - mapheight: The height of the map in number of tiles.
// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
// - tileheight: The height of a tile, which can be 8 or 16 pixels.
// - color_depth: The color depth in bits per pixel (BPP), which can be 1, 2, 4 or 8.
vera_layer_mode_tile: {
    .const mapbase = 0
    .label tilebase_address = vera_layer_mode_text.tilebase_address>>1
    // config
    .label config = VERA_LAYER_WIDTH_128|VERA_LAYER_HEIGHT_64
    // vera_layer_mode_tile::@1
    // vera_layer_rowshift[layer] = 8
    // [222] *(vera_layer_rowshift+vera_layer_mode_text::layer#0) = 8 -- _deref_pbuc1=vbuc2 
    lda #8
    sta vera_layer_rowshift+vera_layer_mode_text.layer
    // vera_layer_rowskip[layer] = 256
    // [223] *(vera_layer_rowskip+vera_layer_mode_text::layer#0*SIZEOF_WORD) = $100 -- _deref_pwuc1=vwuc2 
    lda #<$100
    sta vera_layer_rowskip+vera_layer_mode_text.layer*SIZEOF_WORD
    lda #>$100
    sta vera_layer_rowskip+vera_layer_mode_text.layer*SIZEOF_WORD+1
    // [224] phi from vera_layer_mode_tile::@1 to vera_layer_mode_tile::@2 [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@2]
    // vera_layer_mode_tile::@2
    // vera_layer_set_config(layer, config)
    // [225] call vera_layer_set_config 
    jsr vera_layer_set_config
    // vera_layer_mode_tile::@4
    // vera_mapbase_offset[layer] = <mapbase_address
    // [226] *(vera_mapbase_offset+vera_layer_mode_text::layer#0*SIZEOF_WORD) = 0 -- _deref_pwuc1=vwuc2 
    // mapbase
    lda #<0
    sta vera_mapbase_offset+vera_layer_mode_text.layer*SIZEOF_WORD
    sta vera_mapbase_offset+vera_layer_mode_text.layer*SIZEOF_WORD+1
    // vera_mapbase_bank[layer] = (byte)(>mapbase_address)
    // [227] *(vera_mapbase_bank+vera_layer_mode_text::layer#0) = 0 -- _deref_pbuc1=vbuc2 
    sta vera_mapbase_bank+vera_layer_mode_text.layer
    // vera_mapbase_address[layer] = mapbase_address
    // [228] *(vera_mapbase_address+vera_layer_mode_text::layer#0*SIZEOF_DWORD) = vera_layer_mode_text::mapbase_address#0 -- _deref_pduc1=vduc2 
    lda #<vera_layer_mode_text.mapbase_address
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_DWORD
    lda #>vera_layer_mode_text.mapbase_address
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+1
    lda #<vera_layer_mode_text.mapbase_address>>$10
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+2
    lda #>vera_layer_mode_text.mapbase_address>>$10
    sta vera_mapbase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+3
    // vera_layer_set_mapbase(layer,mapbase)
    // [229] call vera_layer_set_mapbase 
    // [108] phi from vera_layer_mode_tile::@4 to vera_layer_set_mapbase [phi:vera_layer_mode_tile::@4->vera_layer_set_mapbase]
    // [108] phi vera_layer_set_mapbase::mapbase#3 = vera_layer_mode_tile::mapbase#0 [phi:vera_layer_mode_tile::@4->vera_layer_set_mapbase#0] -- vbuxx=vbuc1 
    ldx #mapbase
    // [108] phi vera_layer_set_mapbase::layer#3 = vera_layer_mode_text::layer#0 [phi:vera_layer_mode_tile::@4->vera_layer_set_mapbase#1] -- vbuaa=vbuc1 
    lda #vera_layer_mode_text.layer
    jsr vera_layer_set_mapbase
    // vera_layer_mode_tile::@5
    // vera_tilebase_offset[layer] = <tilebase_address
    // [230] *(vera_tilebase_offset+vera_layer_mode_text::layer#0*SIZEOF_WORD) = <vera_layer_mode_text::tilebase_address#0 -- _deref_pwuc1=vwuc2 
    // tilebase
    lda #<vera_layer_mode_text.tilebase_address&$ffff
    sta vera_tilebase_offset+vera_layer_mode_text.layer*SIZEOF_WORD
    lda #>vera_layer_mode_text.tilebase_address&$ffff
    sta vera_tilebase_offset+vera_layer_mode_text.layer*SIZEOF_WORD+1
    // vera_tilebase_bank[layer] = (byte)>tilebase_address
    // [231] *(vera_tilebase_bank+vera_layer_mode_text::layer#0) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta vera_tilebase_bank+vera_layer_mode_text.layer
    // vera_tilebase_address[layer] = tilebase_address
    // [232] *(vera_tilebase_address+vera_layer_mode_text::layer#0*SIZEOF_DWORD) = vera_layer_mode_text::tilebase_address#0 -- _deref_pduc1=vduc2 
    lda #<vera_layer_mode_text.tilebase_address
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_DWORD
    lda #>vera_layer_mode_text.tilebase_address
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+1
    lda #<vera_layer_mode_text.tilebase_address>>$10
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+2
    lda #>vera_layer_mode_text.tilebase_address>>$10
    sta vera_tilebase_address+vera_layer_mode_text.layer*SIZEOF_DWORD+3
    // [233] phi from vera_layer_mode_tile::@5 to vera_layer_mode_tile::@3 [phi:vera_layer_mode_tile::@5->vera_layer_mode_tile::@3]
    // vera_layer_mode_tile::@3
    // vera_layer_set_tilebase(layer,tilebase)
    // [234] call vera_layer_set_tilebase 
    jsr vera_layer_set_tilebase
    // vera_layer_mode_tile::@return
    // }
    // [235] return 
    rts
}
  // vera_layer_set_text_color_mode
// Set the configuration of the layer text color mode.
// - layer: Value of 0 or 1.
// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
vera_layer_set_text_color_mode: {
    .label addr = $1e
    // addr = vera_layer_config[layer]
    // [236] vera_layer_set_text_color_mode::addr#0 = *(vera_layer_config+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr &= ~VERA_LAYER_CONFIG_256C
    // [237] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 & ~VERA_LAYER_CONFIG_256C -- _deref_pbuz1=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C^$ff
    ldy #0
    and (addr),y
    sta (addr),y
    // *addr |= color_mode
    // [238] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 -- _deref_pbuz1=_deref_pbuz1 
    lda (addr),y
    sta (addr),y
    // vera_layer_set_text_color_mode::@return
    // }
    // [239] return 
    rts
}
  // vera_layer_get_mapbase_bank
// Get the map base bank of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Bank in vera vram.
// vera_layer_get_mapbase_bank(byte register(X) layer)
vera_layer_get_mapbase_bank: {
    // return vera_mapbase_bank[layer];
    // [240] vera_layer_get_mapbase_bank::return#0 = vera_mapbase_bank[vera_layer_get_mapbase_bank::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_mapbase_bank,x
    // vera_layer_get_mapbase_bank::@return
    // }
    // [241] return 
    rts
}
  // vera_layer_get_mapbase_offset
// Get the map base lower 16-bit address (offset) of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Offset in vera vram of the specified bank.
// vera_layer_get_mapbase_offset(byte register(A) layer)
vera_layer_get_mapbase_offset: {
    .label return = $2d
    // return vera_mapbase_offset[layer];
    // [242] vera_layer_get_mapbase_offset::$0 = vera_layer_get_mapbase_offset::layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [243] vera_layer_get_mapbase_offset::return#0 = vera_mapbase_offset[vera_layer_get_mapbase_offset::$0] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda vera_mapbase_offset,y
    sta.z return
    lda vera_mapbase_offset+1,y
    sta.z return+1
    // vera_layer_get_mapbase_offset::@return
    // }
    // [244] return 
    rts
}
  // vera_layer_get_rowshift
// Get the bit shift value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
// vera_layer_get_rowshift(byte register(X) layer)
vera_layer_get_rowshift: {
    // return vera_layer_rowshift[layer];
    // [245] vera_layer_get_rowshift::return#0 = vera_layer_rowshift[vera_layer_get_rowshift::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_rowshift,x
    // vera_layer_get_rowshift::@return
    // }
    // [246] return 
    rts
}
  // vera_layer_get_rowskip
// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
// vera_layer_get_rowskip(byte register(A) layer)
vera_layer_get_rowskip: {
    .label return = $15
    // return vera_layer_rowskip[layer];
    // [247] vera_layer_get_rowskip::$0 = vera_layer_get_rowskip::layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [248] vera_layer_get_rowskip::return#0 = vera_layer_rowskip[vera_layer_get_rowskip::$0] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda vera_layer_rowskip,y
    sta.z return
    lda vera_layer_rowskip+1,y
    sta.z return+1
    // vera_layer_get_rowskip::@return
    // }
    // [249] return 
    rts
}
  // vera_layer_get_backcolor
// Get the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_get_backcolor(byte register(X) layer)
vera_layer_get_backcolor: {
    // return vera_layer_backcolor[layer];
    // [250] vera_layer_get_backcolor::return#0 = vera_layer_backcolor[vera_layer_get_backcolor::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_backcolor,x
    // vera_layer_get_backcolor::@return
    // }
    // [251] return 
    rts
}
  // vera_layer_get_textcolor
// Get the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_get_textcolor(byte register(X) layer)
vera_layer_get_textcolor: {
    // return vera_layer_textcolor[layer];
    // [252] vera_layer_get_textcolor::return#0 = vera_layer_textcolor[vera_layer_get_textcolor::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_textcolor,x
    // vera_layer_get_textcolor::@return
    // }
    // [253] return 
    rts
}
  // cx16_ram_bank
// Configure the bank of a banked ram.
cx16_ram_bank: {
    // VIA1->PORT_A = bank
    // [254] *((byte*)VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A) = cx16_load_ram_banked::bank#0 -- _deref_pbuc1=vbuc2 
    lda #cx16_load_ram_banked.bank
    sta VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    // cx16_ram_bank::@return
    // }
    // [255] return 
    rts
}
  // cbm_k_setnam
/*
B-30. Function Name: SETNAM

  Purpose: Set file name
  Call address: $FFBD (hex) 65469 (decimal)
  Communication registers: A, X, Y
  Preparatory routines:
  Stack requirements: 2
  Registers affected:

  Description: This routine is used to set up the file name for the OPEN,
SAVE, or LOAD routines. The accumulator must be loaded with the length of
the file name. The X and Y registers must be loaded with the address of
the file name, in standard 6502 low-byte/high-byte format. The address
can be any valid memory address in the system where a string of
characters for the file name is stored. If no file name is desired, the
accumulator must be set to 0, representing a zero file length. The X and
Y registers can be set to any memory address in that case.

How to Use:

  1) Load the accumulator with the length of the file name.
  2) Load the X index register with the low order address of the file
     name.
  3) Load the Y index register with the high order address.
  4) Call this routine.

EXAMPLE:

  LDA #NAME2-NAME     ;LOAD LENGTH OF FILE NAME
  LDX #<NAME          ;LOAD ADDRESS OF FILE NAME
  LDY #>NAME
  JSR SETNAM
*/
// cbm_k_setnam(byte* zp($17) filename)
cbm_k_setnam: {
    .label filename = $17
    .label filename_len = $20
    .label __0 = $29
    // strlen(filename)
    // [256] strlen::str#1 = cbm_k_setnam::filename -- pbuz1=pbuz2 
    lda.z filename
    sta.z strlen.str
    lda.z filename+1
    sta.z strlen.str+1
    // [257] call strlen 
    // [356] phi from cbm_k_setnam to strlen [phi:cbm_k_setnam->strlen]
    jsr strlen
    // strlen(filename)
    // [258] strlen::return#2 = strlen::len#2
    // cbm_k_setnam::@1
    // [259] cbm_k_setnam::$0 = strlen::return#2
    // filename_len = (char)strlen(filename)
    // [260] cbm_k_setnam::filename_len = (byte)cbm_k_setnam::$0 -- vbuz1=_byte_vwuz2 
    lda.z __0
    sta.z filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx filename
    ldy filename+1
    jsr CBM_SETNAM
    // cbm_k_setnam::@return
    // }
    // [262] return 
    rts
}
  // cbm_k_setlfs
/*
B-28. Function Name: SETLFS

  Purpose: Set up a logical file
  Call address: $FFBA (hex) 65466 (decimal)
  Communication registers: A, X, Y
  Preparatory routines: None
  Error returns: None
  Stack requirements: 2
  Registers affected: None


  Description: This routine sets the logical file number, device address,
and secondary address (command number) for other KERNAL routines.
  The logical file number is used by the system as a key to the file
table created by the OPEN file routine. Device addresses can range from 0
to 31. The following codes are used by the Commodore 64 to stand for the
CBM devices listed below:


                ADDRESS          DEVICE

                   0            Keyboard
                   1            Datassette(TM)
                   2            RS-232C device
                   3            CRT display
                   4            Serial bus printer
                   8            CBM serial bus disk drive


  Device numbers 4 or greater automatically refer to devices on the
serial bus.
  A command to the device is sent as a secondary address on the serial
bus after the device number is sent during the serial attention
handshaking sequence. If no secondary address is to be sent, the Y index
register should be set to 255.

How to Use:

  1) Load the accumulator with the logical file number.
  2) Load the X index register with the device number.
  3) Load the Y index register with the command.

EXAMPLE:

  FOR LOGICAL FILE 32, DEVICE #4, AND NO COMMAND:
  LDA #32
  LDX #4
  LDY #255
  JSR SETLFS
*/
// cbm_k_setlfs(byte zp($19) channel, byte zp($1a) device, byte zp($1b) secondary)
cbm_k_setlfs: {
    .label channel = $19
    .label device = $1a
    .label secondary = $1b
    // asm
    // asm { ldxdevice ldachannel ldysecondary jsrCBM_SETLFS  }
    ldx device
    lda channel
    ldy secondary
    jsr CBM_SETLFS
    // cbm_k_setlfs::@return
    // }
    // [264] return 
    rts
}
  // cbm_k_open
/*
B-18. Function Name: OPEN

  Purpose: Open a logical file
  Call address: $FFC0 (hex) 65472 (decimal)
  Communication registers: None
  Preparatory routines: SETLFS, SETNAM
  Error returns: 1,2,4,5,6,240, READST
  Stack requirements: None
  Registers affected: A, X, Y

  Description: This routine is used to OPEN a logical file. Once the
logical file is set up, it can be used for input/output operations. Most
of the I/O KERNAL routines call on this routine to create the logical
files to operate on. No arguments need to be set up to use this routine,
but both the SETLFS and SETNAM KERNAL routines must be called before
using this routine.

How to Use:

  0) Use the SETLFS routine.
  1) Use the SETNAM routine.
  2) Call this routine.
*/
cbm_k_open: {
    .label status = $21
    // status
    // [265] cbm_k_open::status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z status
    // asm
    // asm { jsrCBM_OPEN bcs!error+ lda#$ff !error: stastatus  }
    jsr CBM_OPEN
    bcs !error+
    lda #$ff
  !error:
    sta status
    // return status;
    // [267] cbm_k_open::return#0 = cbm_k_open::status -- vbuaa=vbuz1 
    // cbm_k_open::@return
    // }
    // [268] cbm_k_open::return#1 = cbm_k_open::return#0
    // [269] return 
    rts
}
  // cbm_k_chkin
/*
B-2. Function Name: CHKIN

  Purpose: Open a channel for input
  Call address: $FFC6 (hex) 65478 (decimal)
  Communication registers: X
  Preparatory routines: (OPEN)
  Error returns:
  Stack requirements: None
  Registers affected: A, X

  Description: Any logical file that has already been opened by the
KERNAL OPEN routine can be defined as an input channel by this routine.
Naturally, the device on the channel must be an input device. Otherwise
an error will occur, and the routine will abort.
  If you are getting data from anywhere other than the keyboard, this
routine must be called before using either the CHRIN or the GETIN KERNAL
routines for data input. If you want to use the input from the keyboard,
and no other input channels are opened, then the calls to this routine,
and to the OPEN routine are not needed.
  When this routine is used with a device on the serial bus, it auto-
matically sends the talk address (and the secondary address if one was
specified by the OPEN routine) over the bus.

How to Use:

  0) OPEN the logical file (if necessary; see description above).
  1) Load the X register with number of the logical file to be used.
  2) Call this routine (using a JSR command).

Possible errors are:

  #3: File not open
  #5: Device not present
  #6: File not an input file
*/
// cbm_k_chkin(byte zp($1c) channel)
cbm_k_chkin: {
    .label channel = $1c
    .label status = $22
    // status
    // [270] cbm_k_chkin::status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN bcs!error+ lda#$ff !error: stastatus  }
    ldx channel
    jsr CBM_CHKIN
    bcs !error+
    lda #$ff
  !error:
    sta status
    // return status;
    // [272] cbm_k_chkin::return#0 = cbm_k_chkin::status -- vbuaa=vbuz1 
    // cbm_k_chkin::@return
    // }
    // [273] cbm_k_chkin::return#1 = cbm_k_chkin::return#0
    // [274] return 
    rts
}
  // cbm_k_chrin
/*
B-4. Function Name: CHRIN

  Purpose: Get a character from the input channel
  Call address: $FFCF (hex) 65487 (decimal)
  Communication registers: A
  Preparatory routines: (OPEN, CHKIN)
  Error returns: 0 (See READST)
  Stack requirements: 7+
  Registers affected: A, X

  Description: This routine gets a byte of data from a channel already
set up as the input channel by the KERNAL routine CHKIN. If the CHKIN has
NOT been used to define another input channel, then all your data is
expected from the keyboard. The data byte is returned in the accumulator.
The channel remains open after the call.
  Input from the keyboard is handled in a special way. First, the cursor
is turned on, and blinks until a carriage return is typed on the
keyboard. All characters on the line (up to 88 characters) are stored in
the BASIC input buffer. These characters can be retrieved one at a time
by calling this routine once for each character. When the carriage return
is retrieved, the entire line has been processed. The next time this
routine is called, the whole process begins again, i.e., by flashing the
cursor.

How to Use:

FROM THE KEYBOARD

  1) Retrieve a byte of data by calling this routine.
  2) Store the data byte.
  3) Check if it is the last data byte (is it a CR?)
  4) If not, go to step 1.

FROM OTHER DEVICES

  0) Use the KERNAL OPEN and CHKIN routines.
  1) Call this routine (using a JSR instruction).
  2) Store the data.
*/
cbm_k_chrin: {
    .label value = $23
    // value
    // [275] cbm_k_chrin::value = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z value
    // asm
    // asm { jsrCBM_CHRIN stavalue  }
    jsr CBM_CHRIN
    sta value
    // return value;
    // [277] cbm_k_chrin::return#0 = cbm_k_chrin::value -- vbuaa=vbuz1 
    // cbm_k_chrin::@return
    // }
    // [278] cbm_k_chrin::return#1 = cbm_k_chrin::return#0
    // [279] return 
    rts
}
  // cbm_k_readst
/*
B-22. Function Name: READST

  Purpose: Read status word
  Call address: $FFB7 (hex) 65463 (decimal)
  Communication registers: A
  Preparatory routines: None
  Error returns: None
  Stack requirements: 2
  Registers affected: A

  Description: This routine returns the current status of the I/O devices
in the accumulator. The routine is usually called after new communication
to an I/O device. The routine gives you information about device status,
or errors that have occurred during the I/O operation.
  The bits returned in the accumulator contain the following information:
(see table below)

+---------+------------+---------------+------------+-------------------+
|  ST Bit | ST Numeric |    Cassette   |   Serial   |    Tape Verify    |
| Position|    Value   |      Read     |  Bus R/W   |      + Load       |
+---------+------------+---------------+------------+-------------------+
|    0    |      1     |               |  time out  |                   |
|         |            |               |  write     |                   |
+---------+------------+---------------+------------+-------------------+
|    1    |      2     |               |  time out  |                   |
|         |            |               |    read    |                   |
+---------+------------+---------------+------------+-------------------+
|    2    |      4     |  short block  |            |    short block    |
+---------+------------+---------------+------------+-------------------+
|    3    |      8     |   long block  |            |    long block     |
+---------+------------+---------------+------------+-------------------+
|    4    |     16     | unrecoverable |            |   any mismatch    |
|         |            |   read error  |            |                   |
+---------+------------+---------------+------------+-------------------+
|    5    |     32     |    checksum   |            |     checksum      |
|         |            |     error     |            |       error       |
+---------+------------+---------------+------------+-------------------+
|    6    |     64     |  end of file  |  EOI line  |                   |
+---------+------------+---------------+------------+-------------------+
|    7    |   -128     |  end of tape  | device not |    end of tape    |
|         |            |               |   present  |                   |
+---------+------------+---------------+------------+-------------------+

How to Use:

  1) Call this routine.
  2) Decode the information in the A register as it refers to your pro-
     gram.
*/
cbm_k_readst: {
    .label status = $24
    // status
    // [280] cbm_k_readst::status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta status
    // return status;
    // [282] cbm_k_readst::return#0 = cbm_k_readst::status -- vbuaa=vbuz1 
    // cbm_k_readst::@return
    // }
    // [283] cbm_k_readst::return#1 = cbm_k_readst::return#0
    // [284] return 
    rts
}
  // cbm_k_close
/*
B-9. Function Name: CLOSE

  Purpose: Close a logical file
  Call address: $FFC3 (hex) 65475 (decimal)
  Communication registers: A
  Preparatory routines: None
  Error returns: 0,240 (See READST)
  Stack requirements: 2+
  Registers affected: A, X, Y

  Description: This routine is used to close a logical file after all I/O
operations have been completed on that file. This routine is called after
the accumulator is loaded with the logical file number to be closed (the
same number used when the file was opened using the OPEN routine).

How to Use:

  1) Load the accumulator with the number of the logical file to be
     closed.
  2) Call this routine.
*/
// cbm_k_close(byte zp($1d) channel)
cbm_k_close: {
    .label channel = $1d
    .label status = $25
    // status
    // [285] cbm_k_close::status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z status
    // asm
    // asm { ldachannel jsrCBM_CLOSE bcs!error+ lda#$ff !error: stastatus  }
    lda channel
    jsr CBM_CLOSE
    bcs !error+
    lda #$ff
  !error:
    sta status
    // return status;
    // [287] cbm_k_close::return#0 = cbm_k_close::status -- vbuaa=vbuz1 
    // cbm_k_close::@return
    // }
    // [288] cbm_k_close::return#1 = cbm_k_close::return#0
    // [289] return 
    rts
}
  // cbm_k_clrchn
/*
B-10. Function Name: CLRCHN

  Purpose: Clear I/O channels
  Call address: $FFCC (hex) 65484 (decimal)
  Communication registers: None
  Preparatory routines: None
  Error returns:
  Stack requirements: 9
  Registers affected: A, X

  Description: This routine is called to clear all open channels and re-
store the I/O channels to their original default values. It is usually
called after opening other I/O channels (like a tape or disk drive) and
using them for input/output operations. The default input device is 0
(keyboard). The default output device is 3 (the Commodore 64 screen).
  If one of the channels to be closed is to the serial port, an UNTALK
signal is sent first to clear the input channel or an UNLISTEN is sent to
clear the output channel. By not calling this routine (and leaving lis-
tener(s) active on the serial bus) several devices can receive the same
data from the Commodore 64 at the same time. One way to take advantage
of this would be to command the printer to TALK and the disk to LISTEN.
This would allow direct printing of a disk file.
  This routine is automatically called when the KERNAL CLALL routine is
executed.

How to Use:
  1) Call this routine using the JSR instruction.
*/
cbm_k_clrchn: {
    // asm
    // asm { jsrCBM_CLRCHN  }
    jsr CBM_CLRCHN
    // cbm_k_clrchn::@return
    // }
    // [291] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($28) c)
cputc: {
    .label __16 = $26
    .label conio_addr = $29
    .label c = $28
    // vera_layer_get_color( conio_screen_layer)
    // [293] vera_layer_get_color::layer#0 = conio_screen_layer -- vbuxx=vbuz1 
    ldx.z conio_screen_layer
    // [294] call vera_layer_get_color 
    // [362] phi from cputc to vera_layer_get_color [phi:cputc->vera_layer_get_color]
    // [362] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#0 [phi:cputc->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color( conio_screen_layer)
    // [295] vera_layer_get_color::return#3 = vera_layer_get_color::return#2
    // cputc::@7
    // color = vera_layer_get_color( conio_screen_layer)
    // [296] cputc::color#0 = vera_layer_get_color::return#3 -- vbuxx=vbuaa 
    tax
    // CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    // [297] cputc::$15 = conio_screen_layer << 1 -- vbuaa=vbuz1_rol_1 
    lda.z conio_screen_layer
    asl
    // conio_addr = CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    // [298] cputc::conio_addr#0 = (byte*)CONIO_SCREEN_TEXT#13 + conio_line_text[cputc::$15] -- pbuz1=pbuz2_plus_pwuc1_derefidx_vbuaa 
    tay
    clc
    lda.z CONIO_SCREEN_TEXT
    adc conio_line_text,y
    sta.z conio_addr
    lda.z CONIO_SCREEN_TEXT+1
    adc conio_line_text+1,y
    sta.z conio_addr+1
    // conio_cursor_x[conio_screen_layer] << 1
    // [299] cputc::$2 = conio_cursor_x[conio_screen_layer] << 1 -- vbuaa=pbuc1_derefidx_vbuz1_rol_1 
    ldy.z conio_screen_layer
    lda conio_cursor_x,y
    asl
    // conio_addr += conio_cursor_x[conio_screen_layer] << 1
    // [300] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$2 -- pbuz1=pbuz1_plus_vbuaa 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [301] if(cputc::c#3==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [302] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <conio_addr
    // [303] cputc::$4 = < cputc::conio_addr#1 -- vbuaa=_lo_pbuz1 
    lda.z conio_addr
    // *VERA_ADDRX_L = <conio_addr
    // [304] *VERA_ADDRX_L = cputc::$4 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >conio_addr
    // [305] cputc::$5 = > cputc::conio_addr#1 -- vbuaa=_hi_pbuz1 
    lda.z conio_addr+1
    // *VERA_ADDRX_M = >conio_addr
    // [306] *VERA_ADDRX_M = cputc::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // CONIO_SCREEN_BANK | VERA_INC_1
    // [307] cputc::$6 = CONIO_SCREEN_BANK#11 | VERA_INC_1 -- vbuaa=vbuz1_bor_vbuc1 
    lda #VERA_INC_1
    ora.z CONIO_SCREEN_BANK
    // *VERA_ADDRX_H = CONIO_SCREEN_BANK | VERA_INC_1
    // [308] *VERA_ADDRX_H = cputc::$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [309] *VERA_DATA0 = cputc::c#3 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [310] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // conio_cursor_x[conio_screen_layer]++;
    // [311] conio_cursor_x[conio_screen_layer] = ++ conio_cursor_x[conio_screen_layer] -- pbuc1_derefidx_vbuz1=_inc_pbuc1_derefidx_vbuz1 
    ldx.z conio_screen_layer
    inc conio_cursor_x,x
    // scroll_enable = conio_scroll_enable[conio_screen_layer]
    // [312] cputc::scroll_enable#0 = conio_scroll_enable[conio_screen_layer] -- vbuaa=pbuc1_derefidx_vbuz1 
    ldy.z conio_screen_layer
    lda conio_scroll_enable,y
    // if(scroll_enable)
    // [313] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b5
    // cputc::@3
    // (unsigned int)conio_cursor_x[conio_screen_layer] == conio_width
    // [314] cputc::$16 = (word)conio_cursor_x[conio_screen_layer] -- vwuz1=_word_pbuc1_derefidx_vbuz2 
    lda conio_cursor_x,y
    sta.z __16
    lda #0
    sta.z __16+1
    // if((unsigned int)conio_cursor_x[conio_screen_layer] == conio_width)
    // [315] if(cputc::$16!=conio_width) goto cputc::@return -- vwuz1_neq_vwuz2_then_la1 
    cmp.z conio_width+1
    bne __breturn
    lda.z __16
    cmp.z conio_width
    bne __breturn
    // [316] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [317] call cputln 
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [318] return 
    rts
    // cputc::@5
  __b5:
    // if(conio_cursor_x[conio_screen_layer] == CONIO_WIDTH)
    // [319] if(conio_cursor_x[conio_screen_layer]!=conio_screen_width) goto cputc::@return -- pbuc1_derefidx_vbuz1_neq_vbuz2_then_la1 
    lda.z conio_screen_width
    ldy.z conio_screen_layer
    cmp conio_cursor_x,y
    bne __breturn
    // [320] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [321] call cputln 
    jsr cputln
    rts
    // [322] phi from cputc::@7 to cputc::@1 [phi:cputc::@7->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [323] call cputln 
    jsr cputln
    rts
}
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp(3) buffer)
uctoa: {
    .const max_digits = 2
    .label digit_value = $28
    .label buffer = 3
    .label digit = $31
    .label started = $f
    // [325] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
    // [325] phi uctoa::buffer#11 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:uctoa->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [325] phi uctoa::started#2 = 0 [phi:uctoa->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z started
    // [325] phi uctoa::value#2 = uctoa::value#1 [phi:uctoa->uctoa::@1#2] -- register_copy 
    // [325] phi uctoa::digit#2 = 0 [phi:uctoa->uctoa::@1#3] -- vbuz1=vbuc1 
    sta.z digit
    // uctoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [326] if(uctoa::digit#2<uctoa::max_digits#2-1) goto uctoa::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // uctoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [327] *uctoa::buffer#11 = DIGITS[uctoa::value#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [328] uctoa::buffer#3 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [329] *uctoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // uctoa::@return
    // }
    // [330] return 
    rts
    // uctoa::@2
  __b2:
    // digit_value = digit_values[digit]
    // [331] uctoa::digit_value#0 = RADIX_HEXADECIMAL_VALUES_CHAR[uctoa::digit#2] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z digit
    lda RADIX_HEXADECIMAL_VALUES_CHAR,y
    sta.z digit_value
    // if (started || value >= digit_value)
    // [332] if(0!=uctoa::started#2) goto uctoa::@5 -- 0_neq_vbuz1_then_la1 
    lda.z started
    cmp #0
    bne __b5
    // uctoa::@7
    // [333] if(uctoa::value#2>=uctoa::digit_value#0) goto uctoa::@5 -- vbuxx_ge_vbuz1_then_la1 
    cpx.z digit_value
    bcs __b5
    // [334] phi from uctoa::@7 to uctoa::@4 [phi:uctoa::@7->uctoa::@4]
    // [334] phi uctoa::buffer#14 = uctoa::buffer#11 [phi:uctoa::@7->uctoa::@4#0] -- register_copy 
    // [334] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@7->uctoa::@4#1] -- register_copy 
    // [334] phi uctoa::value#6 = uctoa::value#2 [phi:uctoa::@7->uctoa::@4#2] -- register_copy 
    // uctoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [335] uctoa::digit#1 = ++ uctoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [325] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
    // [325] phi uctoa::buffer#11 = uctoa::buffer#14 [phi:uctoa::@4->uctoa::@1#0] -- register_copy 
    // [325] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@4->uctoa::@1#1] -- register_copy 
    // [325] phi uctoa::value#2 = uctoa::value#6 [phi:uctoa::@4->uctoa::@1#2] -- register_copy 
    // [325] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@4->uctoa::@1#3] -- register_copy 
    jmp __b1
    // uctoa::@5
  __b5:
    // uctoa_append(buffer++, value, digit_value)
    // [336] uctoa_append::buffer#0 = uctoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z uctoa_append.buffer
    lda.z buffer+1
    sta.z uctoa_append.buffer+1
    // [337] uctoa_append::value#0 = uctoa::value#2
    // [338] uctoa_append::sub#0 = uctoa::digit_value#0
    // [339] call uctoa_append 
    // [381] phi from uctoa::@5 to uctoa_append [phi:uctoa::@5->uctoa_append]
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // [340] uctoa_append::return#0 = uctoa_append::value#2
    // uctoa::@6
    // value = uctoa_append(buffer++, value, digit_value)
    // [341] uctoa::value#0 = uctoa_append::return#0
    // value = uctoa_append(buffer++, value, digit_value);
    // [342] uctoa::buffer#4 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [334] phi from uctoa::@6 to uctoa::@4 [phi:uctoa::@6->uctoa::@4]
    // [334] phi uctoa::buffer#14 = uctoa::buffer#4 [phi:uctoa::@6->uctoa::@4#0] -- register_copy 
    // [334] phi uctoa::started#4 = 1 [phi:uctoa::@6->uctoa::@4#1] -- vbuz1=vbuc1 
    lda #1
    sta.z started
    // [334] phi uctoa::value#6 = uctoa::value#0 [phi:uctoa::@6->uctoa::@4#2] -- register_copy 
    jmp __b4
}
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte register(A) buffer_sign)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // printf_number_buffer::@1
    // if(buffer.sign)
    // [344] if(0==printf_number_buffer::buffer_sign#0) goto printf_number_buffer::@2 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b2
    // printf_number_buffer::@3
    // cputc(buffer.sign)
    // [345] cputc::c#2 = printf_number_buffer::buffer_sign#0 -- vbuz1=vbuaa 
    sta.z cputc.c
    // [346] call cputc 
    // [292] phi from printf_number_buffer::@3 to cputc [phi:printf_number_buffer::@3->cputc]
    // [292] phi cputc::c#3 = cputc::c#2 [phi:printf_number_buffer::@3->cputc#0] -- register_copy 
    jsr cputc
    // [347] phi from printf_number_buffer::@1 printf_number_buffer::@3 to printf_number_buffer::@2 [phi:printf_number_buffer::@1/printf_number_buffer::@3->printf_number_buffer::@2]
    // printf_number_buffer::@2
  __b2:
    // cputs(buffer.digits)
    // [348] call cputs 
    // [202] phi from printf_number_buffer::@2 to cputs [phi:printf_number_buffer::@2->cputs]
    // [202] phi cputs::s#8 = printf_number_buffer::buffer_digits#0 [phi:printf_number_buffer::@2->cputs#0] -- pbuz1=pbuc1 
    lda #<buffer_digits
    sta.z cputs.s
    lda #>buffer_digits
    sta.z cputs.s+1
    jsr cputs
    // printf_number_buffer::@return
    // }
    // [349] return 
    rts
}
  // vera_layer_set_config
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
vera_layer_set_config: {
    .label addr = $2b
    // addr = vera_layer_config[layer]
    // [350] vera_layer_set_config::addr#0 = *(vera_layer_config+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr = config
    // [351] *vera_layer_set_config::addr#0 = vera_layer_mode_tile::config#10 -- _deref_pbuz1=vbuc1 
    lda #vera_layer_mode_tile.config
    ldy #0
    sta (addr),y
    // vera_layer_set_config::@return
    // }
    // [352] return 
    rts
}
  // vera_layer_set_tilebase
// Set the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - tilebase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
vera_layer_set_tilebase: {
    .label addr = $2d
    // addr = vera_layer_tilebase[layer]
    // [353] vera_layer_set_tilebase::addr#0 = *(vera_layer_tilebase+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_tilebase+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_tilebase+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr = tilebase
    // [354] *vera_layer_set_tilebase::addr#0 = ><vera_layer_mode_tile::tilebase_address#0&VERA_LAYER_TILEBASE_MASK -- _deref_pbuz1=vbuc1 
    lda #(>(vera_layer_mode_tile.tilebase_address&$ffff))&VERA_LAYER_TILEBASE_MASK
    ldy #0
    sta (addr),y
    // vera_layer_set_tilebase::@return
    // }
    // [355] return 
    rts
}
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($26) str)
strlen: {
    .label len = $29
    .label str = $26
    .label return = $29
    // [357] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [357] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z len
    sta.z len+1
    // [357] phi strlen::str#4 = strlen::str#1 [phi:strlen->strlen::@1#1] -- register_copy 
    // strlen::@1
  __b1:
    // while(*str)
    // [358] if(0!=*strlen::str#4) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [359] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [360] strlen::len#1 = ++ strlen::len#2 -- vwuz1=_inc_vwuz1 
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    // [361] strlen::str#0 = ++ strlen::str#4 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [357] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [357] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [357] phi strlen::str#4 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
}
  // vera_layer_get_color
// Get the text and back color for text output in 16 color mode.
// - layer: Value of 0 or 1.
// - return: an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_get_color(byte register(X) layer)
vera_layer_get_color: {
    .label addr = $2f
    // addr = vera_layer_config[layer]
    // [363] vera_layer_get_color::$3 = vera_layer_get_color::layer#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [364] vera_layer_get_color::addr#0 = vera_layer_config[vera_layer_get_color::$3] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr & VERA_LAYER_CONFIG_256C
    // [365] vera_layer_get_color::$0 = *vera_layer_get_color::addr#0 & VERA_LAYER_CONFIG_256C -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C
    ldy #0
    and (addr),y
    // if( *addr & VERA_LAYER_CONFIG_256C )
    // [366] if(0!=vera_layer_get_color::$0) goto vera_layer_get_color::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // vera_layer_get_color::@2
    // vera_layer_backcolor[layer] << 4
    // [367] vera_layer_get_color::$1 = vera_layer_backcolor[vera_layer_get_color::layer#2] << 4 -- vbuaa=pbuc1_derefidx_vbuxx_rol_4 
    lda vera_layer_backcolor,x
    asl
    asl
    asl
    asl
    // return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
    // [368] vera_layer_get_color::return#1 = vera_layer_get_color::$1 | vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuaa=vbuaa_bor_pbuc1_derefidx_vbuxx 
    ora vera_layer_textcolor,x
    // [369] phi from vera_layer_get_color::@1 vera_layer_get_color::@2 to vera_layer_get_color::@return [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return]
    // [369] phi vera_layer_get_color::return#2 = vera_layer_get_color::return#0 [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return#0] -- register_copy 
    // vera_layer_get_color::@return
    // }
    // [370] return 
    rts
    // vera_layer_get_color::@1
  __b1:
    // return (vera_layer_textcolor[layer]);
    // [371] vera_layer_get_color::return#0 = vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_textcolor,x
    rts
}
  // cputln
// Print a newline
cputln: {
    .label temp = $2f
    // temp = conio_line_text[conio_screen_layer]
    // [372] cputln::$2 = conio_screen_layer << 1 -- vbuaa=vbuz1_rol_1 
    lda.z conio_screen_layer
    asl
    // [373] cputln::temp#0 = conio_line_text[cputln::$2] -- vwuz1=pwuc1_derefidx_vbuaa 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda conio_line_text,y
    sta.z temp
    lda conio_line_text+1,y
    sta.z temp+1
    // temp += conio_rowskip
    // [374] cputln::temp#1 = cputln::temp#0 + conio_rowskip -- vwuz1=vwuz1_plus_vwuz2 
    lda.z temp
    clc
    adc.z conio_rowskip
    sta.z temp
    lda.z temp+1
    adc.z conio_rowskip+1
    sta.z temp+1
    // conio_line_text[conio_screen_layer] = temp
    // [375] cputln::$3 = conio_screen_layer << 1 -- vbuaa=vbuz1_rol_1 
    lda.z conio_screen_layer
    asl
    // [376] conio_line_text[cputln::$3] = cputln::temp#1 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z temp
    sta conio_line_text,y
    lda.z temp+1
    sta conio_line_text+1,y
    // conio_cursor_x[conio_screen_layer] = 0
    // [377] conio_cursor_x[conio_screen_layer] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z conio_screen_layer
    sta conio_cursor_x,y
    // conio_cursor_y[conio_screen_layer]++;
    // [378] conio_cursor_y[conio_screen_layer] = ++ conio_cursor_y[conio_screen_layer] -- pbuc1_derefidx_vbuz1=_inc_pbuc1_derefidx_vbuz1 
    ldx.z conio_screen_layer
    inc conio_cursor_y,x
    // cscroll()
    // [379] call cscroll 
    jsr cscroll
    // cputln::@return
    // }
    // [380] return 
    rts
}
  // uctoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// uctoa_append(byte* zp($29) buffer, byte register(X) value, byte zp($28) sub)
uctoa_append: {
    .label buffer = $29
    .label sub = $28
    // [382] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [382] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbuyy=vbuc1 
    ldy #0
    // [382] phi uctoa_append::value#2 = uctoa_append::value#0 [phi:uctoa_append->uctoa_append::@1#1] -- register_copy 
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [383] if(uctoa_append::value#2>=uctoa_append::sub#0) goto uctoa_append::@2 -- vbuxx_ge_vbuz1_then_la1 
    cpx.z sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [384] *uctoa_append::buffer#0 = DIGITS[uctoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuyy 
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // uctoa_append::@return
    // }
    // [385] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [386] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbuyy=_inc_vbuyy 
    iny
    // value -= sub
    // [387] uctoa_append::value#1 = uctoa_append::value#2 - uctoa_append::sub#0 -- vbuxx=vbuxx_minus_vbuz1 
    txa
    sec
    sbc.z sub
    tax
    // [382] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [382] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    // [382] phi uctoa_append::value#2 = uctoa_append::value#1 [phi:uctoa_append::@2->uctoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y[conio_screen_layer]>=CONIO_HEIGHT)
    // [388] if(conio_cursor_y[conio_screen_layer]<conio_screen_height) goto cscroll::@return -- pbuc1_derefidx_vbuz1_lt_vbuz2_then_la1 
    ldy.z conio_screen_layer
    lda conio_cursor_y,y
    cmp.z conio_screen_height
    bcc __b3
    // cscroll::@1
    // if(conio_scroll_enable[conio_screen_layer])
    // [389] if(0!=conio_scroll_enable[conio_screen_layer]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_vbuz1_then_la1 
    lda conio_scroll_enable,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(conio_cursor_y[conio_screen_layer]>=conio_height)
    // [390] if(conio_cursor_y[conio_screen_layer]<conio_height) goto cscroll::@return -- pbuc1_derefidx_vbuz1_lt_vwuz2_then_la1 
    lda conio_cursor_y,y
    ldy.z conio_height+1
    bne __b3
    cmp.z conio_height
    // [391] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
  __b3:
    // cscroll::@return
    // }
    // [392] return 
    rts
    // [393] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [394] call insertup 
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, CONIO_HEIGHT-1)
    // [395] gotoxy::y#2 = conio_screen_height - 1 -- vbuxx=vbuz1_minus_1 
    ldx.z conio_screen_height
    dex
    // [396] call gotoxy 
    // [113] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [113] phi gotoxy::y#3 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    jsr gotoxy
    rts
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label cy = $31
    .label width = $32
    .label line = $33
    .label start = $33
    // cy = conio_cursor_y[conio_screen_layer]
    // [397] insertup::cy#0 = conio_cursor_y[conio_screen_layer] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z conio_screen_layer
    lda conio_cursor_y,y
    sta.z cy
    // width = CONIO_WIDTH * 2
    // [398] insertup::width#0 = conio_screen_width << 1 -- vbuz1=vbuz2_rol_1 
    lda.z conio_screen_width
    asl
    sta.z width
    // [399] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [399] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuxx=vbuc1 
    ldx #1
    // insertup::@1
  __b1:
    // for(unsigned byte i=1; i<=cy; i++)
    // [400] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuxx_le_vbuz1_then_la1 
    lda.z cy
    stx.z $ff
    cmp.z $ff
    bcs __b2
    // [401] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [402] call clearline 
    jsr clearline
    // insertup::@return
    // }
    // [403] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [404] insertup::$3 = insertup::i#2 - 1 -- vbuaa=vbuxx_minus_1 
    txa
    sec
    sbc #1
    // line = (i-1) << conio_rowshift
    // [405] insertup::line#0 = insertup::$3 << conio_rowshift -- vwuz1=vbuaa_rol_vbuz2 
    ldy.z conio_rowshift
    sta.z line
    lda #0
    sta.z line+1
    cpy #0
    beq !e+
  !:
    asl.z line
    rol.z line+1
    dey
    bne !-
  !e:
    // start = CONIO_SCREEN_TEXT + line
    // [406] insertup::start#0 = (byte*)CONIO_SCREEN_TEXT#13 + insertup::line#0 -- pbuz1=pbuz2_plus_vwuz1 
    lda.z start
    clc
    adc.z CONIO_SCREEN_TEXT
    sta.z start
    lda.z start+1
    adc.z CONIO_SCREEN_TEXT+1
    sta.z start+1
    // start+conio_rowskip
    // [407] memcpy_in_vram::src#0 = insertup::start#0 + conio_rowskip -- pbuz1=pbuz2_plus_vwuz3 
    lda.z start
    clc
    adc.z conio_rowskip
    sta.z memcpy_in_vram.src
    lda.z start+1
    adc.z conio_rowskip+1
    sta.z memcpy_in_vram.src+1
    // memcpy_in_vram(0, start, VERA_INC_1,  0, start+conio_rowskip, VERA_INC_1, width)
    // [408] memcpy_in_vram::dest#0 = (void*)insertup::start#0
    // [409] memcpy_in_vram::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z memcpy_in_vram.num
    lda #0
    sta.z memcpy_in_vram.num+1
    // [410] call memcpy_in_vram 
    jsr memcpy_in_vram
    // insertup::@4
    // for(unsigned byte i=1; i<=cy; i++)
    // [411] insertup::i#1 = ++ insertup::i#2 -- vbuxx=_inc_vbuxx 
    inx
    // [399] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [399] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
}
  // clearline
clearline: {
    .label addr = $37
    .label c = $26
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [412] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    // [413] clearline::$5 = conio_screen_layer << 1 -- vbuaa=vbuz1_rol_1 
    lda.z conio_screen_layer
    asl
    // addr = CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    // [414] clearline::addr#0 = (byte*)CONIO_SCREEN_TEXT#13 + conio_line_text[clearline::$5] -- pbuz1=pbuz2_plus_pwuc1_derefidx_vbuaa 
    tay
    clc
    lda.z CONIO_SCREEN_TEXT
    adc conio_line_text,y
    sta.z addr
    lda.z CONIO_SCREEN_TEXT+1
    adc conio_line_text+1,y
    sta.z addr+1
    // <addr
    // [415] clearline::$1 = < clearline::addr#0 -- vbuaa=_lo_pbuz1 
    lda.z addr
    // *VERA_ADDRX_L = <addr
    // [416] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >addr
    // [417] clearline::$2 = > clearline::addr#0 -- vbuaa=_hi_pbuz1 
    lda.z addr+1
    // *VERA_ADDRX_M = >addr
    // [418] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [419] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // vera_layer_get_color( conio_screen_layer)
    // [420] vera_layer_get_color::layer#1 = conio_screen_layer -- vbuxx=vbuz1 
    ldx.z conio_screen_layer
    // [421] call vera_layer_get_color 
    // [362] phi from clearline to vera_layer_get_color [phi:clearline->vera_layer_get_color]
    // [362] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#1 [phi:clearline->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color( conio_screen_layer)
    // [422] vera_layer_get_color::return#4 = vera_layer_get_color::return#2
    // clearline::@4
    // color = vera_layer_get_color( conio_screen_layer)
    // [423] clearline::color#0 = vera_layer_get_color::return#4 -- vbuxx=vbuaa 
    tax
    // [424] phi from clearline::@4 to clearline::@1 [phi:clearline::@4->clearline::@1]
    // [424] phi clearline::c#2 = 0 [phi:clearline::@4->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<CONIO_WIDTH; c++ )
    // [425] if(clearline::c#2<conio_screen_width) goto clearline::@2 -- vwuz1_lt_vbuz2_then_la1 
    lda.z c+1
    bne !+
    lda.z c
    cmp.z conio_screen_width
    bcc __b2
  !:
    // clearline::@3
    // conio_cursor_x[conio_screen_layer] = 0
    // [426] conio_cursor_x[conio_screen_layer] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z conio_screen_layer
    sta conio_cursor_x,y
    // clearline::@return
    // }
    // [427] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [428] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [429] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // for( unsigned int c=0;c<CONIO_WIDTH; c++ )
    // [430] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [424] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [424] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
    jmp __b1
}
  // memcpy_in_vram
// Copy block of memory (from VRAM to VRAM)
// Copies the values from the location pointed by src to the location pointed by dest.
// The method uses the VERA access ports 0 and 1 to copy data from and to in VRAM.
// - src_bank:  64K VRAM bank number to copy from (0/1).
// - src: pointer to the location to copy from. Note that the address is a 16 bit value!
// - src_increment: the increment indicator, VERA needs this because addressing increment is automated by VERA at each access.
// - dest_bank:  64K VRAM bank number to copy to (0/1).
// - dest: pointer to the location to copy to. Note that the address is a 16 bit value!
// - dest_increment: the increment indicator, VERA needs this because addressing increment is automated by VERA at each access.
// - num: The number of bytes to copy
// memcpy_in_vram(void* zp($33) dest, byte* zp($37) src, word zp($35) num)
memcpy_in_vram: {
    .label i = $29
    .label dest = $33
    .label src = $37
    .label num = $35
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [431] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <src
    // [432] memcpy_in_vram::$0 = < (void*)memcpy_in_vram::src#0 -- vbuaa=_lo_pvoz1 
    lda.z src
    // *VERA_ADDRX_L = <src
    // [433] *VERA_ADDRX_L = memcpy_in_vram::$0 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >src
    // [434] memcpy_in_vram::$1 = > (void*)memcpy_in_vram::src#0 -- vbuaa=_hi_pvoz1 
    lda.z src+1
    // *VERA_ADDRX_M = >src
    // [435] *VERA_ADDRX_M = memcpy_in_vram::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = src_increment | src_bank
    // [436] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [437] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    // Select DATA1
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // <dest
    // [438] memcpy_in_vram::$3 = < memcpy_in_vram::dest#0 -- vbuaa=_lo_pvoz1 
    lda.z dest
    // *VERA_ADDRX_L = <dest
    // [439] *VERA_ADDRX_L = memcpy_in_vram::$3 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >dest
    // [440] memcpy_in_vram::$4 = > memcpy_in_vram::dest#0 -- vbuaa=_hi_pvoz1 
    lda.z dest+1
    // *VERA_ADDRX_M = >dest
    // [441] *VERA_ADDRX_M = memcpy_in_vram::$4 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = dest_increment | dest_bank
    // [442] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // [443] phi from memcpy_in_vram to memcpy_in_vram::@1 [phi:memcpy_in_vram->memcpy_in_vram::@1]
    // [443] phi memcpy_in_vram::i#2 = 0 [phi:memcpy_in_vram->memcpy_in_vram::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // memcpy_in_vram::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [444] if(memcpy_in_vram::i#2<memcpy_in_vram::num#0) goto memcpy_in_vram::@2 -- vwuz1_lt_vwuz2_then_la1 
    lda.z i+1
    cmp.z num+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z num
    bcc __b2
  !:
    // memcpy_in_vram::@return
    // }
    // [445] return 
    rts
    // memcpy_in_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [446] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [447] memcpy_in_vram::i#1 = ++ memcpy_in_vram::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [443] phi from memcpy_in_vram::@2 to memcpy_in_vram::@1 [phi:memcpy_in_vram::@2->memcpy_in_vram::@1]
    // [443] phi memcpy_in_vram::i#2 = memcpy_in_vram::i#1 [phi:memcpy_in_vram::@2->memcpy_in_vram::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment Data
  VERA_LAYER_WIDTH: .word $20, $40, $80, $100
  VERA_LAYER_HEIGHT: .word $20, $40, $80, $100
  // --- VERA function encapsulation ---
  vera_mapbase_offset: .word 0, 0
  vera_mapbase_bank: .byte 0, 0
  vera_mapbase_address: .dword 0, 0
  vera_tilebase_offset: .word 0, 0
  vera_tilebase_bank: .byte 0, 0
  vera_tilebase_address: .dword 0, 0
  vera_layer_rowshift: .byte 0, 0
  vera_layer_rowskip: .word 0, 0
  vera_layer_config: .word VERA_L0_CONFIG, VERA_L1_CONFIG
  vera_layer_mapbase: .word VERA_L0_MAPBASE, VERA_L1_MAPBASE
  vera_layer_tilebase: .word VERA_L0_TILEBASE, VERA_L1_TILEBASE
  vera_layer_textcolor: .byte WHITE, WHITE
  vera_layer_backcolor: .byte BLUE, BLUE
  // The number of bytes on the screen
  // The current cursor x-position
  conio_cursor_x: .byte 0, 0
  // The current cursor y-position
  conio_cursor_y: .byte 0, 0
  // The current text cursor line start
  conio_line_text: .word 0, 0
  // Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
  // If disabled the cursor just moves back to (0,0) instead
  conio_scroll_enable: .byte 1, 1
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
