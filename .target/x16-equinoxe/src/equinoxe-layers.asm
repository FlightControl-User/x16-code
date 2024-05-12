  //
#importonce
  // File Comments
  // Library
.namespace equinoxe_layers {
  // Upstart
.cpu _65c02
#if !__asm_import__equinoxe_layers__

   .segmentdef Code
   .segmentdef Data
#endif

  // Global Constants & labels
  /// The colors of the C64
  .label BLACK = 0
  .label WHITE = 1
  ///< CX16 Set/Get screen mode.
  .label CX16_SCREEN_SET_CHARSET = $ff62
  .label VERA_DCSEL = 2
  .label VERA_LAYER1_ENABLE = $20
  .label VERA_LAYER0_ENABLE = $10
  .label VERA_LAYER_WIDTH_64 = $10
  .label VERA_LAYER_WIDTH_128 = $20
  .label VERA_LAYER_WIDTH_MASK = $30
  /// Bit 6-7: Map Height	(0:32 tiles, 1:64 tiles, 2:128 tiles, 3:256 tiles)
  .label VERA_LAYER_HEIGHT_32 = 0
  .label VERA_LAYER_HEIGHT_64 = $40
  .label VERA_LAYER_HEIGHT_MASK = $c0
  /// Bit 0-1: Color Depth (0: 1 bpp, 1: 2 bpp, 2: 4 bpp, 3: 8 bpp)
  .label VERA_LAYER_COLOR_DEPTH_1BPP = 0
  .label VERA_LAYER_COLOR_DEPTH_4BPP = 2
  .label VERA_LAYER_COLOR_DEPTH_MASK = 3
  /// $9F2F	L0_TILEBASE	    Layer 0 Tile Base
  /// Bit 2-7: Tile Base Address (16:11)
  /// Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  .label VERA_TILEBASE_WIDTH_8 = 0
  .label VERA_TILEBASE_WIDTH_16 = 1
  .label VERA_TILEBASE_WIDTH_MASK = 1
  .label VERA_TILEBASE_HEIGHT_8 = 0
  .label VERA_TILEBASE_HEIGHT_16 = 2
  .label VERA_TILEBASE_HEIGHT_MASK = 2
  .label VERA_LAYER_TILEBASE_MASK = $fc
  /// $9F25	CTRL Control
  /// Bit 7: Reset
  /// Bit 1: DCSEL
  /// Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  /// $9F29	DC_VIDEO (DCSEL=0)
  /// Bit 7: Current Field     Read-only bit which reflects the active interlaced field in composite and RGB modes. (0: even, 1: odd)
  /// Bit 6: Sprites Enable	Enable output from the Sprites renderer
  /// Bit 5: Layer1 Enable	    Enable output from the Layer1 renderer
  /// Bit 4: Layer0 Enable	    Enable output from the Layer0 renderer
  /// Bit 2: Chroma Disable    Setting 'Chroma Disable' disables output of chroma in NTSC composite mode and will give a better picture on a monochrome display. (Setting this bit will also disable the chroma output on the S-video output.)
  /// Bit 0-1: Output Mode     0: Video disabled, 1: VGA output, 2: NTSC composite, 3: RGB interlaced, composite sync (via VGA connector)
  .label VERA_DC_VIDEO = $9f29
  /// $9F2D	L0_CONFIG   Layer 0 Configuration
  .label VERA_L0_CONFIG = $9f2d
  /// $9F2E	L0_MAPBASE	    Layer 0 Map Base Address (16:9)
  .label VERA_L0_MAPBASE = $9f2e
  /// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L0_TILEBASE = $9f2f
  /// $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  /// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  /// $9F36	L1_TILEBASE	    Layer 1 Tile Base
  /// Bit 2-7: Tile Base Address (16:11)
  /// Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  /// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L1_TILEBASE = $9f36
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __equinoxe_layers_start
// void __equinoxe_layers_start()
__equinoxe_layers_start: {
    // __equinoxe_layers_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // __equinoxe_layers_start::@return
    // [3] return 
    rts
}
  // vera_floor_layer1_show
// void vera_floor_layer1_show()
vera_floor_layer1_show: {
    // vera_floor_layer1_show::vera_layer1_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [5] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_LAYER1_ENABLE
    // [6] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_LAYER1_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER1_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_floor_layer1_show::@return
    // }
    // [7] return 
    rts
}
  // vera_floor_layer0_show
// void vera_floor_layer0_show()
vera_floor_layer0_show: {
    // vera_floor_layer0_show::vera_layer0_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [9] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_LAYER0_ENABLE
    // [10] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_LAYER0_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER0_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_floor_layer0_show::@return
    // }
    // [11] return 
    rts
}
  // vera_floor_layer1_hide
// void vera_floor_layer1_hide()
vera_floor_layer1_hide: {
    // vera_layer1_hide()
    // [13] call vera_layer1_hide
    jsr vera_layer1_hide
    // vera_floor_layer1_hide::@return
    // }
    // [14] return 
    rts
}
  // vera_floor_layer0_hide
// void vera_floor_layer0_hide()
vera_floor_layer0_hide: {
    // vera_floor_layer0_hide::vera_layer0_hide1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [16] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER0_ENABLE
    // [17] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER0_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER0_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_floor_layer0_hide::@return
    // }
    // [18] return 
    rts
}
  // vera_petscii_layer1
// void vera_petscii_layer1()
vera_petscii_layer1: {
    // vera_layer1_mode_tile( 
    //         FLOOR_MAP1_BANK_VRAM, (vram_offset_t)FLOOR_MAP1_OFFSET_VRAM, 
    //         1, (vram_offset_t)0xF000, 
    //         VERA_LAYER_WIDTH_64, VERA_LAYER_HEIGHT_32,
    //         VERA_TILEBASE_WIDTH_8, VERA_TILEBASE_HEIGHT_8, 
    //         VERA_LAYER_COLOR_DEPTH_1BPP
    //     )
    // [20] call vera_layer1_mode_tile
    // [66] phi from vera_petscii_layer1 to vera_layer1_mode_tile [phi:vera_petscii_layer1->vera_layer1_mode_tile]
    // [66] phi vera_layer1_mode_tile::tileheight#10 = VERA_TILEBASE_HEIGHT_8 [phi:vera_petscii_layer1->vera_layer1_mode_tile#0] -- vbum1=vbuc1 
    lda #VERA_TILEBASE_HEIGHT_8
    sta vera_layer1_mode_tile.tileheight
    // [66] phi vera_layer1_mode_tile::tilewidth#10 = VERA_TILEBASE_WIDTH_8 [phi:vera_petscii_layer1->vera_layer1_mode_tile#1] -- vbum1=vbuc1 
    lda #VERA_TILEBASE_WIDTH_8
    sta vera_layer1_mode_tile.tilewidth
    // [66] phi vera_layer1_mode_tile::tilebase_offset#10 = $f000 [phi:vera_petscii_layer1->vera_layer1_mode_tile#2] -- vwum1=vwuc1 
    lda #<$f000
    sta vera_layer1_mode_tile.tilebase_offset
    lda #>$f000
    sta vera_layer1_mode_tile.tilebase_offset+1
    // [66] phi vera_layer1_mode_tile::tilebase_bank#10 = 1 [phi:vera_petscii_layer1->vera_layer1_mode_tile#3] -- vbum1=vbuc1 
    lda #1
    sta vera_layer1_mode_tile.tilebase_bank
    // [66] phi vera_layer1_mode_tile::mapheight#3 = VERA_LAYER_HEIGHT_32 [phi:vera_petscii_layer1->vera_layer1_mode_tile#4] -- vbum1=vbuc1 
    lda #VERA_LAYER_HEIGHT_32
    sta vera_layer1_mode_tile.mapheight
    // [66] phi vera_layer1_mode_tile::mapwidth#3 = VERA_LAYER_WIDTH_64 [phi:vera_petscii_layer1->vera_layer1_mode_tile#5] -- vbuyy=vbuc1 
    ldy #VERA_LAYER_WIDTH_64
    // [66] phi vera_layer1_mode_tile::vera_layer1_set_color_depth1_bpp#0 = VERA_LAYER_COLOR_DEPTH_1BPP [phi:vera_petscii_layer1->vera_layer1_mode_tile#6] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_1BPP
    jsr vera_layer1_mode_tile
    // [21] phi from vera_petscii_layer1 to vera_petscii_layer1::@1 [phi:vera_petscii_layer1->vera_petscii_layer1::@1]
    // vera_petscii_layer1::@1
    // screenlayer1()
    // [22] callexecute screenlayer1  -- call_var_near 
    jsr lib_conio.screenlayer1
    // clrscr()
    // [23] callexecute clrscr  -- call_var_near 
    jsr lib_conio.clrscr
    // vera_floor_layer1_show()
    // [24] callexecute vera_floor_layer1_show  -- call_var_near 
    jsr vera_floor_layer1_show
    // vera_petscii_layer1::@return
    // }
    // [25] return 
    rts
}
  // vera_floor_layer1
// void vera_floor_layer1()
vera_floor_layer1: {
    // vera_layer1_mode_tile( 
    //         FLOOR_MAP1_BANK_VRAM, (vram_offset_t)FLOOR_MAP1_OFFSET_VRAM, 
    //         FLOOR_TILE_BANK_VRAM, (vram_offset_t)FLOOR_TILE_OFFSET_VRAM, 
    //         VERA_LAYER_WIDTH_64, VERA_LAYER_HEIGHT_32,
    //         VERA_TILEBASE_WIDTH_16, VERA_TILEBASE_HEIGHT_16, 
    //         VERA_LAYER_COLOR_DEPTH_4BPP
    //     )
    // [27] call vera_layer1_mode_tile
    // [66] phi from vera_floor_layer1 to vera_layer1_mode_tile [phi:vera_floor_layer1->vera_layer1_mode_tile]
    // [66] phi vera_layer1_mode_tile::tileheight#10 = VERA_TILEBASE_HEIGHT_16 [phi:vera_floor_layer1->vera_layer1_mode_tile#0] -- vbum1=vbuc1 
    lda #VERA_TILEBASE_HEIGHT_16
    sta vera_layer1_mode_tile.tileheight
    // [66] phi vera_layer1_mode_tile::tilewidth#10 = VERA_TILEBASE_WIDTH_16 [phi:vera_floor_layer1->vera_layer1_mode_tile#1] -- vbum1=vbuc1 
    lda #VERA_TILEBASE_WIDTH_16
    sta vera_layer1_mode_tile.tilewidth
    // [66] phi vera_layer1_mode_tile::tilebase_offset#10 = 0 [phi:vera_floor_layer1->vera_layer1_mode_tile#2] -- vwum1=vwuc1 
    lda #<0
    sta vera_layer1_mode_tile.tilebase_offset
    sta vera_layer1_mode_tile.tilebase_offset+1
    // [66] phi vera_layer1_mode_tile::tilebase_bank#10 = 0 [phi:vera_floor_layer1->vera_layer1_mode_tile#3] -- vbum1=vbuc1 
    sta vera_layer1_mode_tile.tilebase_bank
    // [66] phi vera_layer1_mode_tile::mapheight#3 = VERA_LAYER_HEIGHT_32 [phi:vera_floor_layer1->vera_layer1_mode_tile#4] -- vbum1=vbuc1 
    lda #VERA_LAYER_HEIGHT_32
    sta vera_layer1_mode_tile.mapheight
    // [66] phi vera_layer1_mode_tile::mapwidth#3 = VERA_LAYER_WIDTH_64 [phi:vera_floor_layer1->vera_layer1_mode_tile#5] -- vbuyy=vbuc1 
    ldy #VERA_LAYER_WIDTH_64
    // [66] phi vera_layer1_mode_tile::vera_layer1_set_color_depth1_bpp#0 = VERA_LAYER_COLOR_DEPTH_4BPP [phi:vera_floor_layer1->vera_layer1_mode_tile#6] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_4BPP
    jsr vera_layer1_mode_tile
    // [28] phi from vera_floor_layer1 to vera_floor_layer1::@1 [phi:vera_floor_layer1->vera_floor_layer1::@1]
    // vera_floor_layer1::@1
    // vera_floor_layer1_show()
    // [29] callexecute vera_floor_layer1_show  -- call_var_near 
    jsr vera_floor_layer1_show
    // vera_floor_layer1::@return
    // }
    // [30] return 
    rts
}
  // vera_floor_layer0
// void vera_floor_layer0()
vera_floor_layer0: {
    // vera_layer0_mode_tile( 
    //         FLOOR_MAP0_BANK_VRAM, (vram_offset_t)FLOOR_MAP0_OFFSET_VRAM, 
    //         FLOOR_TILE_BANK_VRAM, (vram_offset_t)FLOOR_TILE_OFFSET_VRAM, 
    //         VERA_LAYER_WIDTH_64, VERA_LAYER_HEIGHT_32,
    //         VERA_TILEBASE_WIDTH_16, VERA_TILEBASE_HEIGHT_16, 
    //         VERA_LAYER_COLOR_DEPTH_4BPP
    //     )
    // [32] call vera_layer0_mode_tile
    // [85] phi from vera_floor_layer0 to vera_layer0_mode_tile [phi:vera_floor_layer0->vera_layer0_mode_tile]
    jsr vera_layer0_mode_tile
    // [33] phi from vera_floor_layer0 to vera_floor_layer0::@1 [phi:vera_floor_layer0->vera_floor_layer0::@1]
    // vera_floor_layer0::@1
    // vera_floor_layer0_show()
    // [34] callexecute vera_floor_layer0_show  -- call_var_near 
    jsr vera_floor_layer0_show
    // vera_floor_layer0::@return
    // }
    // [35] return 
    rts
}
  // vera_petscii_init
// void vera_petscii_init()
vera_petscii_init: {
    .label cx16_k_screen_set_charset1_offset = $22
    // cx16_k_screen_set_charset(3, (char *)0)
    // [36] vera_petscii_init::cx16_k_screen_set_charset1_charset = 3 -- vbum1=vbuc1 
    lda #3
    sta cx16_k_screen_set_charset1_charset
    // [37] vera_petscii_init::cx16_k_screen_set_charset1_offset = (char *) 0 -- pbuz1=pbuc1 
    lda #<0
    sta.z cx16_k_screen_set_charset1_offset
    sta.z cx16_k_screen_set_charset1_offset+1
    // vera_petscii_init::cx16_k_screen_set_charset1
    // asm
    // asm { ldacharset ldx<offset ldy>offset jsrCX16_SCREEN_SET_CHARSET  }
    lda cx16_k_screen_set_charset1_charset
    ldx.z <cx16_k_screen_set_charset1_offset
    ldy.z >cx16_k_screen_set_charset1_offset
    jsr CX16_SCREEN_SET_CHARSET
    // [39] phi from vera_petscii_init::cx16_k_screen_set_charset1 to vera_petscii_init::@1 [phi:vera_petscii_init::cx16_k_screen_set_charset1->vera_petscii_init::@1]
    // vera_petscii_init::@1
    // vera_layer1_mode_tile(
    //         // Maps must be aligned to 512 bytes, so allocate the map second.
    //         1, (vram_offset_t)0xB000, 
    //         // Tiles must be aligned to 2048 bytes, to allocate the tile map first. Note that the size parameter does the actual alignment to 2048 bytes.
    //         1, (vram_offset_t)0xF000, 
    //         VERA_LAYER_WIDTH_128, VERA_LAYER_HEIGHT_64, 
    //         VERA_TILEBASE_WIDTH_8, VERA_TILEBASE_HEIGHT_8, 
    //         VERA_LAYER_COLOR_DEPTH_1BPP
    //     )
    // [40] call vera_layer1_mode_tile
    // [66] phi from vera_petscii_init::@1 to vera_layer1_mode_tile [phi:vera_petscii_init::@1->vera_layer1_mode_tile]
    // [66] phi vera_layer1_mode_tile::tileheight#10 = VERA_TILEBASE_HEIGHT_8 [phi:vera_petscii_init::@1->vera_layer1_mode_tile#0] -- vbum1=vbuc1 
    lda #VERA_TILEBASE_HEIGHT_8
    sta vera_layer1_mode_tile.tileheight
    // [66] phi vera_layer1_mode_tile::tilewidth#10 = VERA_TILEBASE_WIDTH_8 [phi:vera_petscii_init::@1->vera_layer1_mode_tile#1] -- vbum1=vbuc1 
    lda #VERA_TILEBASE_WIDTH_8
    sta vera_layer1_mode_tile.tilewidth
    // [66] phi vera_layer1_mode_tile::tilebase_offset#10 = $f000 [phi:vera_petscii_init::@1->vera_layer1_mode_tile#2] -- vwum1=vwuc1 
    lda #<$f000
    sta vera_layer1_mode_tile.tilebase_offset
    lda #>$f000
    sta vera_layer1_mode_tile.tilebase_offset+1
    // [66] phi vera_layer1_mode_tile::tilebase_bank#10 = 1 [phi:vera_petscii_init::@1->vera_layer1_mode_tile#3] -- vbum1=vbuc1 
    lda #1
    sta vera_layer1_mode_tile.tilebase_bank
    // [66] phi vera_layer1_mode_tile::mapheight#3 = VERA_LAYER_HEIGHT_64 [phi:vera_petscii_init::@1->vera_layer1_mode_tile#4] -- vbum1=vbuc1 
    lda #VERA_LAYER_HEIGHT_64
    sta vera_layer1_mode_tile.mapheight
    // [66] phi vera_layer1_mode_tile::mapwidth#3 = VERA_LAYER_WIDTH_128 [phi:vera_petscii_init::@1->vera_layer1_mode_tile#5] -- vbuyy=vbuc1 
    ldy #VERA_LAYER_WIDTH_128
    // [66] phi vera_layer1_mode_tile::vera_layer1_set_color_depth1_bpp#0 = VERA_LAYER_COLOR_DEPTH_1BPP [phi:vera_petscii_init::@1->vera_layer1_mode_tile#6] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_1BPP
    jsr vera_layer1_mode_tile
    // [41] phi from vera_petscii_init::@1 to vera_petscii_init::@2 [phi:vera_petscii_init::@1->vera_petscii_init::@2]
    // vera_petscii_init::@2
    // screenlayer1()
    // [42] callexecute screenlayer1  -- call_var_near 
    jsr lib_conio.screenlayer1
    // textcolor(WHITE)
    // [43] textcolor::color = WHITE -- vbum1=vbuc1 
    lda #WHITE
    sta lib_conio.textcolor.color
    // [44] callexecute textcolor  -- call_var_near 
    jsr lib_conio.textcolor
    // bgcolor(BLACK)
    // [45] bgcolor::color = BLACK -- vbum1=vbuc1 
    lda #BLACK
    sta lib_conio.bgcolor.color
    // [46] callexecute bgcolor  -- call_var_near 
    jsr lib_conio.bgcolor
    // clrscr()
    // [47] callexecute clrscr  -- call_var_near 
    jsr lib_conio.clrscr
    // scroll(0)
    // [48] scroll::onoff = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_conio.scroll.onoff
    // [49] callexecute scroll  -- call_var_near 
    jsr lib_conio.scroll
    // vera_floor_layer1_show()
    // [50] callexecute vera_floor_layer1_show  -- call_var_near 
    jsr vera_floor_layer1_show
    // vera_floor_layer0_hide()
    // [51] callexecute vera_floor_layer0_hide  -- call_var_near 
    jsr vera_floor_layer0_hide
    // vera_petscii_init::@return
    // }
    // [52] return 
    rts
  .segment Data
    cx16_k_screen_set_charset1_charset: .byte 0
}
.segment Code
  // vera_layer1_hide
/**
 * @brief Hide the layer 1 to be displayed from the screen.
 */
// void vera_layer1_hide()
vera_layer1_hide: {
    // *VERA_CTRL &= ~VERA_DCSEL
    // [63] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER1_ENABLE
    // [64] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER1_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER1_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_layer1_hide::@return
    // }
    // [65] return 
    rts
}
  // vera_layer1_mode_tile
// void vera_layer1_mode_tile(char mapbase_bank, unsigned int mapbase_offset, __mem() char tilebase_bank, __mem() unsigned int tilebase_offset, __register(Y) char mapwidth, __mem() char mapheight, __mem() char tilewidth, __mem() char tileheight, char bpp)
vera_layer1_mode_tile: {
    // vera_layer1_mode_tile::vera_layer1_set_color_depth1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK
    // [67] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_COLOR_DEPTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= bpp
    // [68] *VERA_L1_CONFIG = *VERA_L1_CONFIG | vera_layer1_mode_tile::vera_layer1_set_color_depth1_bpp#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_width1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_WIDTH_MASK
    // [69] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= mapwidth
    // [70] *VERA_L1_CONFIG = *VERA_L1_CONFIG | vera_layer1_mode_tile::mapwidth#3 -- _deref_pbuc1=_deref_pbuc1_bor_vbuyy 
    tya
    ora VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_height1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_HEIGHT_MASK
    // [71] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= mapheight
    // [72] *VERA_L1_CONFIG = *VERA_L1_CONFIG | vera_layer1_mode_tile::mapheight#3 -- _deref_pbuc1=_deref_pbuc1_bor_vbum1 
    ora mapheight
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_mapbase1
    // *VERA_L1_MAPBASE = (mapbase_bank<<7) | (BYTE1(mapbase_offset)>>1)
    // [73] *VERA_L1_MAPBASE = 1<<7|byte1 $b000>>1 -- _deref_pbuc1=vbuc2 
    lda #1<<7|(>$b000)>>1
    sta VERA_L1_MAPBASE
    // vera_layer1_mode_tile::vera_layer1_set_tilebase1
    // *VERA_L1_TILEBASE &= ~VERA_LAYER_TILEBASE_MASK
    // [74] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_LAYER_TILEBASE_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_TILEBASE_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // tilebase_bank << 7
    // [75] vera_layer1_mode_tile::vera_layer1_set_tilebase1_$0 = vera_layer1_mode_tile::tilebase_bank#10 << 7 -- vbum1=vbum1_rol_7 
    lda vera_layer1_set_tilebase1_vera_layer1_mode_tile__0
    asl
    asl
    asl
    asl
    asl
    asl
    asl
    sta vera_layer1_set_tilebase1_vera_layer1_mode_tile__0
    // BYTE1(tilebase_offset)
    // [76] vera_layer1_mode_tile::vera_layer1_set_tilebase1_$1 = byte1  vera_layer1_mode_tile::tilebase_offset#10 -- vbuaa=_byte1_vwum1 
    lda tilebase_offset+1
    // BYTE1(tilebase_offset)>>1
    // [77] vera_layer1_mode_tile::vera_layer1_set_tilebase1_$2 = vera_layer1_mode_tile::vera_layer1_set_tilebase1_$1 >> 1 -- vbuaa=vbuaa_ror_1 
    lsr
    // (tilebase_bank << 7) | BYTE1(tilebase_offset)>>1
    // [78] vera_layer1_mode_tile::vera_layer1_set_tilebase1_$3 = vera_layer1_mode_tile::vera_layer1_set_tilebase1_$0 | vera_layer1_mode_tile::vera_layer1_set_tilebase1_$2 -- vbuaa=vbum1_bor_vbuaa 
    ora vera_layer1_set_tilebase1_vera_layer1_mode_tile__0
    // *VERA_L1_TILEBASE |= ((tilebase_bank << 7) | BYTE1(tilebase_offset)>>1)
    // [79] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE | vera_layer1_mode_tile::vera_layer1_set_tilebase1_$3 -- _deref_pbuc1=_deref_pbuc1_bor_vbuaa 
    ora VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::vera_layer1_set_tile_width1
    // *VERA_L1_TILEBASE &= ~VERA_TILEBASE_WIDTH_MASK
    // [80] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_TILEBASE_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_WIDTH_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= tilewidth
    // [81] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE | vera_layer1_mode_tile::tilewidth#10 -- _deref_pbuc1=_deref_pbuc1_bor_vbum1 
    ora tilewidth
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::vera_layer1_set_tile_height1
    // *VERA_L1_TILEBASE &= ~VERA_TILEBASE_HEIGHT_MASK
    // [82] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_TILEBASE_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_HEIGHT_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= tileheight
    // [83] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE | vera_layer1_mode_tile::tileheight#10 -- _deref_pbuc1=_deref_pbuc1_bor_vbum1 
    ora tileheight
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::@return
    // }
    // [84] return 
    rts
  .segment Data
    .label vera_layer1_set_tilebase1_vera_layer1_mode_tile__0 = tilebase_bank
    mapheight: .byte 0
    tilebase_bank: .byte 0
    tilebase_offset: .word 0
    tilewidth: .byte 0
    tileheight: .byte 0
}
.segment Code
  // vera_layer0_mode_tile
// void vera_layer0_mode_tile(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char bpp)
vera_layer0_mode_tile: {
    // vera_layer0_mode_tile::vera_layer0_set_color_depth1
    // *VERA_L0_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK
    // [86] *VERA_L0_CONFIG = *VERA_L0_CONFIG & ~VERA_LAYER_COLOR_DEPTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_MASK^$ff
    and VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // *VERA_L0_CONFIG |= bpp
    // [87] *VERA_L0_CONFIG = *VERA_L0_CONFIG | VERA_LAYER_COLOR_DEPTH_4BPP -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_4BPP
    ora VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // vera_layer0_mode_tile::vera_layer0_set_width1
    // *VERA_L0_CONFIG &= ~VERA_LAYER_WIDTH_MASK
    // [88] *VERA_L0_CONFIG = *VERA_L0_CONFIG & ~VERA_LAYER_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK^$ff
    and VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // *VERA_L0_CONFIG |= mapwidth
    // [89] *VERA_L0_CONFIG = *VERA_L0_CONFIG | VERA_LAYER_WIDTH_64 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_WIDTH_64
    ora VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // vera_layer0_mode_tile::vera_layer0_set_height1
    // *VERA_L0_CONFIG &= ~VERA_LAYER_HEIGHT_MASK
    // [90] *VERA_L0_CONFIG = *VERA_L0_CONFIG & ~VERA_LAYER_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK^$ff
    and VERA_L0_CONFIG
    sta VERA_L0_CONFIG
    // *VERA_L0_CONFIG |= mapheight
    // [91] *VERA_L0_CONFIG = *VERA_L0_CONFIG -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L0_CONFIG
    // vera_layer0_mode_tile::vera_layer0_set_mapbase1
    // *VERA_L0_MAPBASE = (mapbase_bank<<7) | (BYTE1(mapbase_offset)>>1)
    // [92] *VERA_L0_MAPBASE = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta VERA_L0_MAPBASE
    // vera_layer0_mode_tile::vera_layer0_set_tilebase1
    // *VERA_L0_TILEBASE &= ~VERA_LAYER_TILEBASE_MASK
    // [93] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE & ~VERA_LAYER_TILEBASE_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_TILEBASE_MASK^$ff
    and VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // *VERA_L0_TILEBASE |= ((tilebase_bank << 7) | BYTE1(tilebase_offset)>>1)
    // [94] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L0_TILEBASE
    // vera_layer0_mode_tile::vera_layer0_set_tile_width1
    // *VERA_L0_TILEBASE &= ~VERA_TILEBASE_WIDTH_MASK
    // [95] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE & ~VERA_TILEBASE_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_WIDTH_MASK^$ff
    and VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // *VERA_L0_TILEBASE |= tilewidth
    // [96] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE | VERA_TILEBASE_WIDTH_16 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_TILEBASE_WIDTH_16
    ora VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // vera_layer0_mode_tile::vera_layer0_set_tile_height1
    // *VERA_L0_TILEBASE &= ~VERA_TILEBASE_HEIGHT_MASK
    // [97] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE & ~VERA_TILEBASE_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_HEIGHT_MASK^$ff
    and VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // *VERA_L0_TILEBASE |= tileheight
    // [98] *VERA_L0_TILEBASE = *VERA_L0_TILEBASE | VERA_TILEBASE_HEIGHT_16 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_TILEBASE_HEIGHT_16
    ora VERA_L0_TILEBASE
    sta VERA_L0_TILEBASE
    // vera_layer0_mode_tile::@return
    // }
    // [99] return 
    rts
}
  // Exported Global Data
} // namespace
 // Asm import library lib_conio:
#define __asm_import__lib_conio__
#import "lib_conio.asm"

