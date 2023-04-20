  // File Comments
// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="tilemap_8bpp_8_x_8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  // Global Constants & labels
  // The colors of the CX16
  .const BLACK = 0
  .const WHITE = 1
  .const BLUE = 6
  .const VERA_INC_1 = $10
  .const VERA_DCSEL = 2
  .const VERA_ADDRSEL = 1
  .const VERA_LAYER1_ENABLE = $20
  .const VERA_LAYER0_ENABLE = $10
  .const VERA_LAYER_WIDTH_64 = $10
  .const VERA_LAYER_WIDTH_128 = $20
  .const VERA_LAYER_WIDTH_256 = $30
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_64 = $40
  .const VERA_LAYER_HEIGHT_128 = $80
  .const VERA_LAYER_HEIGHT_256 = $c0
  .const VERA_LAYER_HEIGHT_MASK = $c0
  // Bit 0-1: Color Depth (0: 1 bpp, 1: 2 bpp, 2: 4 bpp, 3: 8 bpp)
  .const VERA_LAYER_COLOR_DEPTH_1BPP = 0
  .const VERA_LAYER_COLOR_DEPTH_2BPP = 1
  .const VERA_LAYER_COLOR_DEPTH_4BPP = 2
  .const VERA_LAYER_COLOR_DEPTH_8BPP = 3
  .const VERA_LAYER_CONFIG_256C = 8
  .const VERA_TILEBASE_WIDTH_16 = 1
  .const VERA_TILEBASE_HEIGHT_16 = 2
  .const VERA_LAYER_TILEBASE_MASK = $fc
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH = 4
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT = 5
  .const SIZEOF_WORD = 2
  .const SIZEOF_POINTER = 2
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT = 1
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT = 8
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH = 6
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK = 3
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP = $b
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT = $a
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR = $d
  .const SIZEOF_STRUCT_CX16_CONIO = $e
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
  // $9F25	CTRL Control
  // Bit 7: Reset
  // Bit 1: DCSEL
  // Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  // $9F29	DC_VIDEO (DCSEL=0)
  // Bit 7: Current Field     Read-only bit which reflects the active interlaced field in composite and RGB modes. (0: even, 1: odd)
  // Bit 6: Sprites Enable	Enable output from the Sprites renderer
  // Bit 5: Layer1 Enable	    Enable output from the Layer1 renderer
  // Bit 4: Layer0 Enable	    Enable output from the Layer0 renderer
  // Bit 2: Chroma Disable    Setting 'Chroma Disable' disables output of chroma in NTSC composite mode and will give a better picture on a monochrome display. (Setting this bit will also disable the chroma output on the S-video output.)
  // Bit 0-1: Output Mode     0: Video disabled, 1: VGA output, 2: NTSC composite, 3: RGB interlaced, composite sync (via VGA connector)
  .label VERA_DC_VIDEO = $9f29
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
  // $9F23	DATA0	VRAM Data port 0
  .label VERA_DATA0 = $9f23
  // $9F24	DATA1	VRAM Data port 1
  .label VERA_DATA1 = $9f24
.segment Code
  // __start
__start: {
    // [1] phi from __start to __start::__init1 [phi:__start->__start::__init1]
    // __start::__init1
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [2] call conio_x16_init 
    jsr conio_x16_init
    // [3] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [4] call main 
    // [28] phi from __start::@1 to main [phi:__start::@1->main]
    jsr main
    // __start::@return
    // [5] return 
    rts
}
  // conio_x16_init
// Set initial cursor position
conio_x16_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label line = 3
    // char line = *BASIC_CURSOR_LINE
    // [6] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda BASIC_CURSOR_LINE
    sta.z line
    // vera_layer_mode_text(1, {0, 0x0000},{0, 0xF800},128,64,8,8,16)
    // [7] call vera_layer_mode_text 
    // [104] phi from conio_x16_init to vera_layer_mode_text [phi:conio_x16_init->vera_layer_mode_text]
    jsr vera_layer_mode_text
    // [8] phi from conio_x16_init to conio_x16_init::@3 [phi:conio_x16_init->conio_x16_init::@3]
    // conio_x16_init::@3
    // screensize(&cx16_conio.conio_screen_width, &cx16_conio.conio_screen_height)
    // [9] call screensize 
    jsr screensize
    // [10] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // screenlayer(1)
    // [11] call screenlayer 
    jsr screenlayer
    // [12] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // vera_layer_set_textcolor(1, WHITE)
    // [13] call vera_layer_set_textcolor 
    // [146] phi from conio_x16_init::@5 to vera_layer_set_textcolor [phi:conio_x16_init::@5->vera_layer_set_textcolor]
    // [146] phi vera_layer_set_textcolor::layer#2 = 1 [phi:conio_x16_init::@5->vera_layer_set_textcolor#0] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_set_textcolor
    // [14] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // vera_layer_set_backcolor(1, BLUE)
    // [15] call vera_layer_set_backcolor 
    // [149] phi from conio_x16_init::@6 to vera_layer_set_backcolor [phi:conio_x16_init::@6->vera_layer_set_backcolor]
    // [149] phi vera_layer_set_backcolor::color#2 = BLUE [phi:conio_x16_init::@6->vera_layer_set_backcolor#0] -- vbuaa=vbuc1 
    lda #BLUE
    // [149] phi vera_layer_set_backcolor::layer#2 = 1 [phi:conio_x16_init::@6->vera_layer_set_backcolor#1] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_set_backcolor
    // [16] phi from conio_x16_init::@6 to conio_x16_init::@7 [phi:conio_x16_init::@6->conio_x16_init::@7]
    // conio_x16_init::@7
    // vera_layer_set_mapbase(0,0x20)
    // [17] call vera_layer_set_mapbase 
    // [152] phi from conio_x16_init::@7 to vera_layer_set_mapbase [phi:conio_x16_init::@7->vera_layer_set_mapbase]
    // [152] phi vera_layer_set_mapbase::mapbase#3 = $20 [phi:conio_x16_init::@7->vera_layer_set_mapbase#0] -- vbuxx=vbuc1 
    ldx #$20
    // [152] phi vera_layer_set_mapbase::layer#3 = 0 [phi:conio_x16_init::@7->vera_layer_set_mapbase#1] -- vbuaa=vbuc1 
    lda #0
    jsr vera_layer_set_mapbase
    // [18] phi from conio_x16_init::@7 to conio_x16_init::@8 [phi:conio_x16_init::@7->conio_x16_init::@8]
    // conio_x16_init::@8
    // vera_layer_set_mapbase(1,0x00)
    // [19] call vera_layer_set_mapbase 
    // [152] phi from conio_x16_init::@8 to vera_layer_set_mapbase [phi:conio_x16_init::@8->vera_layer_set_mapbase]
    // [152] phi vera_layer_set_mapbase::mapbase#3 = 0 [phi:conio_x16_init::@8->vera_layer_set_mapbase#0] -- vbuxx=vbuc1 
    ldx #0
    // [152] phi vera_layer_set_mapbase::layer#3 = 1 [phi:conio_x16_init::@8->vera_layer_set_mapbase#1] -- vbuaa=vbuc1 
    lda #1
    jsr vera_layer_set_mapbase
    // [20] phi from conio_x16_init::@8 to conio_x16_init::@9 [phi:conio_x16_init::@8->conio_x16_init::@9]
    // conio_x16_init::@9
    // cursor(0)
    // [21] call cursor 
    jsr cursor
    // conio_x16_init::@10
    // if(line>=cx16_conio.conio_screen_height)
    // [22] if(conio_x16_init::line#0<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto conio_x16_init::@1 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z line
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b1
    // conio_x16_init::@2
    // line=cx16_conio.conio_screen_height-1
    // [23] conio_x16_init::line#1 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    stx.z line
    // [24] phi from conio_x16_init::@10 conio_x16_init::@2 to conio_x16_init::@1 [phi:conio_x16_init::@10/conio_x16_init::@2->conio_x16_init::@1]
    // [24] phi conio_x16_init::line#3 = conio_x16_init::line#0 [phi:conio_x16_init::@10/conio_x16_init::@2->conio_x16_init::@1#0] -- register_copy 
    // conio_x16_init::@1
  __b1:
    // gotoxy(0, line)
    // [25] gotoxy::y#0 = conio_x16_init::line#3 -- vbuxx=vbuz1 
    ldx.z line
    // [26] call gotoxy 
    // [159] phi from conio_x16_init::@1 to gotoxy [phi:conio_x16_init::@1->gotoxy]
    // [159] phi gotoxy::y#4 = gotoxy::y#0 [phi:conio_x16_init::@1->gotoxy#0] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [27] return 
    rts
}
  // main
main: {
    .label tilebase = 4
    .label t = 6
    .label column = 8
    .label tile = 4
    .label c = 9
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label row = 6
    .label r = 7
    .label column1 = $e
    .label tile_1 = $c
    .label c1 = $f
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label row_1 = $a
    .label r1 = $b
    // textcolor(WHITE)
    // [29] call textcolor 
    jsr textcolor
    // [30] phi from main to main::@13 [phi:main->main::@13]
    // main::@13
    // bgcolor(BLACK)
    // [31] call bgcolor 
    jsr bgcolor
    // [32] phi from main::@13 to main::@14 [phi:main::@13->main::@14]
    // main::@14
    // clrscr()
    // [33] call clrscr 
    jsr clrscr
    // [34] phi from main::@14 to main::@15 [phi:main::@14->main::@15]
    // main::@15
    // vera_layer_mode_tile(0, {0, 0x4000}, {1, 0x4000}, 128, 128, 8, 8, 8)
    // [35] call vera_layer_mode_tile 
    // [212] phi from main::@15 to vera_layer_mode_tile [phi:main::@15->vera_layer_mode_tile]
    // [212] phi vera_layer_mode_tile::tileheight#10 = 8 [phi:main::@15->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [212] phi vera_layer_mode_tile::tilewidth#10 = 8 [phi:main::@15->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [212] phi vera_layer_mode_tile::tilebase_address_bank#10 = 1 [phi:main::@15->vera_layer_mode_tile#2] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.tilebase_address_bank
    // [212] phi vera_layer_mode_tile::tilebase_address_ptr#10 = $4000 [phi:main::@15->vera_layer_mode_tile#3] -- vwuz1=vwuc1 
    lda #<$4000
    sta.z vera_layer_mode_tile.tilebase_address_ptr
    lda #>$4000
    sta.z vera_layer_mode_tile.tilebase_address_ptr+1
    // [212] phi vera_layer_mode_tile::mapbase_address_bank#10 = 0 [phi:main::@15->vera_layer_mode_tile#4] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.mapbase_address_bank
    // [212] phi vera_layer_mode_tile::mapbase_address_ptr#10 = $4000 [phi:main::@15->vera_layer_mode_tile#5] -- vwuz1=vwuc1 
    lda #<$4000
    sta.z vera_layer_mode_tile.mapbase_address_ptr
    lda #>$4000
    sta.z vera_layer_mode_tile.mapbase_address_ptr+1
    // [212] phi vera_layer_mode_tile::mapheight#10 = $80 [phi:main::@15->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapheight
    lda #>$80
    sta.z vera_layer_mode_tile.mapheight+1
    // [212] phi vera_layer_mode_tile::layer#10 = 0 [phi:main::@15->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.layer
    // [212] phi vera_layer_mode_tile::mapwidth#10 = $80 [phi:main::@15->vera_layer_mode_tile#8] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [212] phi vera_layer_mode_tile::color_depth#2 = 8 [phi:main::@15->vera_layer_mode_tile#9] -- vbuxx=vbuc1 
    ldx #8
    jsr vera_layer_mode_tile
    // [36] phi from main::@15 to main::@16 [phi:main::@15->main::@16]
    // main::@16
    // cx16_cpy_vram_from_ram(1, tilebase, tiles, 64)
    // [37] call cx16_cpy_vram_from_ram 
    // [284] phi from main::@16 to cx16_cpy_vram_from_ram [phi:main::@16->cx16_cpy_vram_from_ram]
    // [284] phi cx16_cpy_vram_from_ram::dptr_vram#2 = (void*)$4000 [phi:main::@16->cx16_cpy_vram_from_ram#0] -- pvoz1=pvoc1 
    lda #<$4000
    sta.z cx16_cpy_vram_from_ram.dptr_vram
    lda #>$4000
    sta.z cx16_cpy_vram_from_ram.dptr_vram+1
    jsr cx16_cpy_vram_from_ram
    // [38] phi from main::@16 to main::@1 [phi:main::@16->main::@1]
    // [38] phi main::t#5 = 1 [phi:main::@16->main::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z t
    // [38] phi main::tilebase#7 = $4000+$40 [phi:main::@16->main::@1#1] -- vwuz1=vwuc1 
    lda #<$4000+$40
    sta.z tilebase
    lda #>$4000+$40
    sta.z tilebase+1
    // [38] phi from main::@17 to main::@1 [phi:main::@17->main::@1]
    // [38] phi main::t#5 = main::t#1 [phi:main::@17->main::@1#0] -- register_copy 
    // [38] phi main::tilebase#7 = main::tilebase#2 [phi:main::@17->main::@1#1] -- register_copy 
    // main::@1
  __b1:
    // [39] phi from main::@1 to main::@2 [phi:main::@1->main::@2]
    // [39] phi main::p#2 = 0 [phi:main::@1->main::@2#0] -- vbuxx=vbuc1 
    ldx #0
    // [39] phi from main::@2 to main::@2 [phi:main::@2->main::@2]
    // [39] phi main::p#2 = main::p#1 [phi:main::@2->main::@2#0] -- register_copy 
    // main::@2
  __b2:
    // tiles[p]+=1
    // [40] main::tiles[main::p#2] = main::tiles[main::p#2] + 1 -- pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_plus_1 
    lda tiles,x
    inc
    sta tiles,x
    // for(byte p:0..63)
    // [41] main::p#1 = ++ main::p#2 -- vbuxx=_inc_vbuxx 
    inx
    // [42] if(main::p#1!=$40) goto main::@2 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$40
    bne __b2
    // main::@3
    // cx16_cpy_vram_from_ram(1, tilebase, tiles, 64)
    // [43] cx16_cpy_vram_from_ram::dptr_vram#1 = (void*)main::tilebase#7 -- pvoz1=pvoz2 
    lda.z tilebase
    sta.z cx16_cpy_vram_from_ram.dptr_vram
    lda.z tilebase+1
    sta.z cx16_cpy_vram_from_ram.dptr_vram+1
    // [44] call cx16_cpy_vram_from_ram 
    // [284] phi from main::@3 to cx16_cpy_vram_from_ram [phi:main::@3->cx16_cpy_vram_from_ram]
    // [284] phi cx16_cpy_vram_from_ram::dptr_vram#2 = cx16_cpy_vram_from_ram::dptr_vram#1 [phi:main::@3->cx16_cpy_vram_from_ram#0] -- register_copy 
    jsr cx16_cpy_vram_from_ram
    // main::@17
    // tilebase+=64
    // [45] main::tilebase#2 = main::tilebase#7 + $40 -- vwuz1=vwuz1_plus_vbuc1 
    lda #$40
    clc
    adc.z tilebase
    sta.z tilebase
    bcc !+
    inc.z tilebase+1
  !:
    // for(byte t:1..255)
    // [46] main::t#1 = ++ main::t#5 -- vbuz1=_inc_vbuz1 
    inc.z t
    // [47] if(main::t#1!=0) goto main::@1 -- vbuz1_neq_0_then_la1 
    lda.z t
    bne __b1
    // [48] phi from main::@17 to main::@4 [phi:main::@17->main::@4]
    // main::@4
    // vera_tile_area(0, 0, 0, 0, 80, 60, 0, 0, 0)
    // [49] call vera_tile_area 
  //vera_tile_area(byte layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset)
    // [296] phi from main::@4 to vera_tile_area [phi:main::@4->vera_tile_area]
    // [296] phi vera_tile_area::w#11 = $50 [phi:main::@4->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$50
    sta.z vera_tile_area.w
    // [296] phi vera_tile_area::h#10 = $3c [phi:main::@4->vera_tile_area#1] -- vbuz1=vbuc1 
    lda #$3c
    sta.z vera_tile_area.h
    // [296] phi vera_tile_area::x#3 = 0 [phi:main::@4->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.x
    // [296] phi vera_tile_area::y#3 = 0 [phi:main::@4->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [296] phi vera_tile_area::tileindex#3 = 0 [phi:main::@4->vera_tile_area#4] -- vwuz1=vbuc1 
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    jsr vera_tile_area
    // [50] phi from main::@4 to main::@5 [phi:main::@4->main::@5]
    // [50] phi main::r#5 = 0 [phi:main::@4->main::@5#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // [50] phi main::row#9 = 1 [phi:main::@4->main::@5#1] -- vbuz1=vbuc1 
    lda #1
    sta.z row
    // [50] phi main::tile#10 = 0 [phi:main::@4->main::@5#2] -- vwuz1=vwuc1 
    lda #<0
    sta.z tile
    sta.z tile+1
    // [50] phi from main::@7 to main::@5 [phi:main::@7->main::@5]
    // [50] phi main::r#5 = main::r#1 [phi:main::@7->main::@5#0] -- register_copy 
    // [50] phi main::row#9 = main::row#1 [phi:main::@7->main::@5#1] -- register_copy 
    // [50] phi main::tile#10 = main::tile#12 [phi:main::@7->main::@5#2] -- register_copy 
    // main::@5
  __b5:
    // [51] phi from main::@5 to main::@6 [phi:main::@5->main::@6]
    // [51] phi main::c#2 = 0 [phi:main::@5->main::@6#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // [51] phi main::column#2 = 1 [phi:main::@5->main::@6#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column
    // [51] phi main::tile#6 = main::tile#10 [phi:main::@5->main::@6#2] -- register_copy 
    // [51] phi from main::@18 to main::@6 [phi:main::@18->main::@6]
    // [51] phi main::c#2 = main::c#1 [phi:main::@18->main::@6#0] -- register_copy 
    // [51] phi main::column#2 = main::column#1 [phi:main::@18->main::@6#1] -- register_copy 
    // [51] phi main::tile#6 = main::tile#12 [phi:main::@18->main::@6#2] -- register_copy 
    // main::@6
  __b6:
    // vera_tile_area(0, tile, column, row, 1, 1, 0, 0, 0)
    // [52] vera_tile_area::tileindex#1 = main::tile#6 -- vwuz1=vwuz2 
    lda.z tile
    sta.z vera_tile_area.tileindex
    lda.z tile+1
    sta.z vera_tile_area.tileindex+1
    // [53] vera_tile_area::x#1 = main::column#2 -- vbuz1=vbuz2 
    lda.z column
    sta.z vera_tile_area.x
    // [54] vera_tile_area::y#1 = main::row#9 -- vbuz1=vbuz2 
    lda.z row
    sta.z vera_tile_area.y
    // [55] call vera_tile_area 
    // [296] phi from main::@6 to vera_tile_area [phi:main::@6->vera_tile_area]
    // [296] phi vera_tile_area::w#11 = 1 [phi:main::@6->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [296] phi vera_tile_area::h#10 = 1 [phi:main::@6->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [296] phi vera_tile_area::x#3 = vera_tile_area::x#1 [phi:main::@6->vera_tile_area#2] -- register_copy 
    // [296] phi vera_tile_area::y#3 = vera_tile_area::y#1 [phi:main::@6->vera_tile_area#3] -- register_copy 
    // [296] phi vera_tile_area::tileindex#3 = vera_tile_area::tileindex#1 [phi:main::@6->vera_tile_area#4] -- register_copy 
    jsr vera_tile_area
    // main::@18
    // column+=2
    // [56] main::column#1 = main::column#2 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z column
    clc
    adc #2
    sta.z column
    // tile++;
    // [57] main::tile#1 = ++ main::tile#6 -- vwuz1=_inc_vwuz1 
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // tile &= 0xff
    // [58] main::tile#12 = main::tile#1 & $ff -- vwuz1=vwuz1_band_vbuc1 
    lda #$ff
    and.z tile
    sta.z tile
    lda #0
    sta.z tile+1
    // for(byte c:0..31)
    // [59] main::c#1 = ++ main::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [60] if(main::c#1!=$20) goto main::@6 -- vbuz1_neq_vbuc1_then_la1 
    lda #$20
    cmp.z c
    bne __b6
    // main::@7
    // row += 2
    // [61] main::row#1 = main::row#9 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z row
    clc
    adc #2
    sta.z row
    // for(byte r:0..7)
    // [62] main::r#1 = ++ main::r#5 -- vbuz1=_inc_vbuz1 
    inc.z r
    // [63] if(main::r#1!=8) goto main::@5 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z r
    bne __b5
    // [64] phi from main::@7 to main::@8 [phi:main::@7->main::@8]
    // [64] phi main::r1#5 = 0 [phi:main::@7->main::@8#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r1
    // [64] phi main::row#11 = $14 [phi:main::@7->main::@8#1] -- vbuz1=vbuc1 
    lda #$14
    sta.z row_1
    // [64] phi main::tile#11 = 0 [phi:main::@7->main::@8#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z tile_1
    sta.z tile_1+1
    // [64] phi from main::@10 to main::@8 [phi:main::@10->main::@8]
    // [64] phi main::r1#5 = main::r1#1 [phi:main::@10->main::@8#0] -- register_copy 
    // [64] phi main::row#11 = main::row#3 [phi:main::@10->main::@8#1] -- register_copy 
    // [64] phi main::tile#11 = main::tile#13 [phi:main::@10->main::@8#2] -- register_copy 
    // main::@8
  __b8:
    // [65] phi from main::@8 to main::@9 [phi:main::@8->main::@9]
    // [65] phi main::c1#2 = 0 [phi:main::@8->main::@9#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c1
    // [65] phi main::column1#2 = 1 [phi:main::@8->main::@9#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column1
    // [65] phi main::tile#8 = main::tile#11 [phi:main::@8->main::@9#2] -- register_copy 
    // [65] phi from main::@19 to main::@9 [phi:main::@19->main::@9]
    // [65] phi main::c1#2 = main::c1#1 [phi:main::@19->main::@9#0] -- register_copy 
    // [65] phi main::column1#2 = main::column1#1 [phi:main::@19->main::@9#1] -- register_copy 
    // [65] phi main::tile#8 = main::tile#13 [phi:main::@19->main::@9#2] -- register_copy 
    // main::@9
  __b9:
    // vera_tile_area(0, tile, column, row, 2, 2, 0, 0, 0)
    // [66] vera_tile_area::tileindex#2 = main::tile#8 -- vwuz1=vwuz2 
    lda.z tile_1
    sta.z vera_tile_area.tileindex
    lda.z tile_1+1
    sta.z vera_tile_area.tileindex+1
    // [67] vera_tile_area::x#2 = main::column1#2 -- vbuz1=vbuz2 
    lda.z column1
    sta.z vera_tile_area.x
    // [68] vera_tile_area::y#2 = main::row#11 -- vbuz1=vbuz2 
    lda.z row_1
    sta.z vera_tile_area.y
    // [69] call vera_tile_area 
    // [296] phi from main::@9 to vera_tile_area [phi:main::@9->vera_tile_area]
    // [296] phi vera_tile_area::w#11 = 2 [phi:main::@9->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #2
    sta.z vera_tile_area.w
    // [296] phi vera_tile_area::h#10 = 2 [phi:main::@9->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [296] phi vera_tile_area::x#3 = vera_tile_area::x#2 [phi:main::@9->vera_tile_area#2] -- register_copy 
    // [296] phi vera_tile_area::y#3 = vera_tile_area::y#2 [phi:main::@9->vera_tile_area#3] -- register_copy 
    // [296] phi vera_tile_area::tileindex#3 = vera_tile_area::tileindex#2 [phi:main::@9->vera_tile_area#4] -- register_copy 
    jsr vera_tile_area
    // main::@19
    // column+=2
    // [70] main::column1#1 = main::column1#2 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z column1
    clc
    adc #2
    sta.z column1
    // tile++;
    // [71] main::tile#4 = ++ main::tile#8 -- vwuz1=_inc_vwuz1 
    inc.z tile_1
    bne !+
    inc.z tile_1+1
  !:
    // tile &= 0xff
    // [72] main::tile#13 = main::tile#4 & $ff -- vwuz1=vwuz1_band_vbuc1 
    lda #$ff
    and.z tile_1
    sta.z tile_1
    lda #0
    sta.z tile_1+1
    // for(byte c:0..31)
    // [73] main::c1#1 = ++ main::c1#2 -- vbuz1=_inc_vbuz1 
    inc.z c1
    // [74] if(main::c1#1!=$20) goto main::@9 -- vbuz1_neq_vbuc1_then_la1 
    lda #$20
    cmp.z c1
    bne __b9
    // main::@10
    // row += 2
    // [75] main::row#3 = main::row#11 + 2 -- vbuz1=vbuz1_plus_2 
    lda.z row_1
    clc
    adc #2
    sta.z row_1
    // for(byte r:0..7)
    // [76] main::r1#1 = ++ main::r1#5 -- vbuz1=_inc_vbuz1 
    inc.z r1
    // [77] if(main::r1#1!=8) goto main::@8 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z r1
    bne __b8
    // main::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [78] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [79] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [80] phi from main::vera_layer_show1 to main::@12 [phi:main::vera_layer_show1->main::@12]
    // main::@12
    // gotoxy(0,50)
    // [81] call gotoxy 
    // [159] phi from main::@12 to gotoxy [phi:main::@12->gotoxy]
    // [159] phi gotoxy::y#4 = $32 [phi:main::@12->gotoxy#0] -- vbuxx=vbuc1 
    ldx #$32
    jsr gotoxy
    // [82] phi from main::@12 to main::@20 [phi:main::@12->main::@20]
    // main::@20
    // printf("vera in tile mode 8 x 8, color depth 8 bits per pixel.\n")
    // [83] call cputs 
    // [358] phi from main::@20 to cputs [phi:main::@20->cputs]
    // [358] phi cputs::s#10 = main::s [phi:main::@20->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // [84] phi from main::@20 to main::@21 [phi:main::@20->main::@21]
    // main::@21
    // printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n")
    // [85] call cputs 
    // [358] phi from main::@21 to cputs [phi:main::@21->cputs]
    // [358] phi cputs::s#10 = main::s1 [phi:main::@21->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [86] phi from main::@21 to main::@22 [phi:main::@21->main::@22]
    // main::@22
    // printf("each tile can have a variation of 256 colors.\n")
    // [87] call cputs 
    // [358] phi from main::@22 to cputs [phi:main::@22->cputs]
    // [358] phi cputs::s#10 = main::s2 [phi:main::@22->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // [88] phi from main::@22 to main::@23 [phi:main::@22->main::@23]
    // main::@23
    // printf("the vera palette of 256 colors, can be used by setting the palette\n")
    // [89] call cputs 
    // [358] phi from main::@23 to cputs [phi:main::@23->cputs]
    // [358] phi cputs::s#10 = main::s3 [phi:main::@23->cputs#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // [90] phi from main::@23 to main::@24 [phi:main::@23->main::@24]
    // main::@24
    // printf("offset for each tile.\n")
    // [91] call cputs 
    // [358] phi from main::@24 to cputs [phi:main::@24->cputs]
    // [358] phi cputs::s#10 = main::s4 [phi:main::@24->cputs#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // [92] phi from main::@24 to main::@25 [phi:main::@24->main::@25]
    // main::@25
    // printf("here each column is displaying the same tile, but with different offsets!\n")
    // [93] call cputs 
    // [358] phi from main::@25 to cputs [phi:main::@25->cputs]
    // [358] phi cputs::s#10 = main::s5 [phi:main::@25->cputs#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    // [94] phi from main::@25 to main::@26 [phi:main::@25->main::@26]
    // main::@26
    // printf("each offset aligns to multiples of 16 colors in the palette!.\n")
    // [95] call cputs 
    // [358] phi from main::@26 to cputs [phi:main::@26->cputs]
    // [358] phi cputs::s#10 = main::s6 [phi:main::@26->cputs#0] -- pbuz1=pbuc1 
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
    // [96] phi from main::@26 to main::@27 [phi:main::@26->main::@27]
    // main::@27
    // printf("however, the first color will always be transparent (black).\n")
    // [97] call cputs 
    // [358] phi from main::@27 to cputs [phi:main::@27->cputs]
    // [358] phi cputs::s#10 = main::s7 [phi:main::@27->cputs#0] -- pbuz1=pbuc1 
    lda #<s7
    sta.z cputs.s
    lda #>s7
    sta.z cputs.s+1
    jsr cputs
    // [98] phi from main::@27 main::@28 to main::@11 [phi:main::@27/main::@28->main::@11]
    // main::@11
  __b11:
    // kbhit()
    // [99] call kbhit 
    jsr kbhit
    // [100] kbhit::return#2 = kbhit::return#1
    // main::@28
    // [101] main::$25 = kbhit::return#2
    // while(!kbhit())
    // [102] if(0==main::$25) goto main::@11 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b11
    // main::@return
    // }
    // [103] return 
    rts
  .segment Data
    tiles: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    s: .text @"vera in tile mode 8 x 8, color depth 8 bits per pixel.\n"
    .byte 0
    s1: .text @"in this mode, tiles are 8 pixels wide and 8 pixels tall.\n"
    .byte 0
    s2: .text @"each tile can have a variation of 256 colors.\n"
    .byte 0
    s3: .text @"the vera palette of 256 colors, can be used by setting the palette\n"
    .byte 0
    s4: .text @"offset for each tile.\n"
    .byte 0
    s5: .text @"here each column is displaying the same tile, but with different offsets!\n"
    .byte 0
    s6: .text @"each offset aligns to multiples of 16 colors in the palette!.\n"
    .byte 0
    s7: .text @"however, the first color will always be transparent (black).\n"
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
    .const mapbase_address_bank = 0
    .const mapbase_address_ptr = 0
    .const tilebase_address_bank = 0
    .const tilebase_address_ptr = $f800
    .const mapwidth = $80
    .const mapheight = $40
    .const tilewidth = 8
    .const tileheight = 8
    .label layer = 1
    // vera_layer_mode_tile( layer, mapbase_address, tilebase_address, mapwidth, mapheight, tilewidth, tileheight, 1 )
    // [105] call vera_layer_mode_tile 
    // [212] phi from vera_layer_mode_text to vera_layer_mode_tile [phi:vera_layer_mode_text->vera_layer_mode_tile]
    // [212] phi vera_layer_mode_tile::tileheight#10 = vera_layer_mode_text::tileheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #tileheight
    sta.z vera_layer_mode_tile.tileheight
    // [212] phi vera_layer_mode_tile::tilewidth#10 = vera_layer_mode_text::tilewidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    lda #tilewidth
    sta.z vera_layer_mode_tile.tilewidth
    // [212] phi vera_layer_mode_tile::tilebase_address_bank#10 = vera_layer_mode_text::tilebase_address_bank#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#2] -- vbuz1=vbuc1 
    lda #tilebase_address_bank
    sta.z vera_layer_mode_tile.tilebase_address_bank
    // [212] phi vera_layer_mode_tile::tilebase_address_ptr#10 = vera_layer_mode_text::tilebase_address_ptr#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#3] -- vwuz1=vwuc1 
    lda #<tilebase_address_ptr
    sta.z vera_layer_mode_tile.tilebase_address_ptr
    lda #>tilebase_address_ptr
    sta.z vera_layer_mode_tile.tilebase_address_ptr+1
    // [212] phi vera_layer_mode_tile::mapbase_address_bank#10 = vera_layer_mode_text::mapbase_address_bank#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#4] -- vbuz1=vbuc1 
    lda #mapbase_address_bank
    sta.z vera_layer_mode_tile.mapbase_address_bank
    // [212] phi vera_layer_mode_tile::mapbase_address_ptr#10 = vera_layer_mode_text::mapbase_address_ptr#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#5] -- vwuz1=vwuc1 
    lda #<mapbase_address_ptr
    sta.z vera_layer_mode_tile.mapbase_address_ptr
    lda #>mapbase_address_ptr
    sta.z vera_layer_mode_tile.mapbase_address_ptr+1
    // [212] phi vera_layer_mode_tile::mapheight#10 = vera_layer_mode_text::mapheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#6] -- vwuz1=vwuc1 
    lda #<mapheight
    sta.z vera_layer_mode_tile.mapheight
    lda #>mapheight
    sta.z vera_layer_mode_tile.mapheight+1
    // [212] phi vera_layer_mode_tile::layer#10 = vera_layer_mode_text::layer#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #layer
    sta.z vera_layer_mode_tile.layer
    // [212] phi vera_layer_mode_tile::mapwidth#10 = vera_layer_mode_text::mapwidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#8] -- vwuz1=vwuc1 
    lda #<mapwidth
    sta.z vera_layer_mode_tile.mapwidth
    lda #>mapwidth
    sta.z vera_layer_mode_tile.mapwidth+1
    // [212] phi vera_layer_mode_tile::color_depth#2 = 1 [phi:vera_layer_mode_text->vera_layer_mode_tile#9] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_mode_tile
    // [106] phi from vera_layer_mode_text to vera_layer_mode_text::@1 [phi:vera_layer_mode_text->vera_layer_mode_text::@1]
    // vera_layer_mode_text::@1
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C )
    // [107] call vera_layer_set_text_color_mode 
    jsr vera_layer_set_text_color_mode
    // vera_layer_mode_text::@return
    // }
    // [108] return 
    rts
}
  // screensize
// Return the current screen size.
screensize: {
    .label x = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    .label y = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    // char hscale = (*VERA_DC_HSCALE) >> 7
    // [109] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuaa=_deref_pbuc1_ror_7 
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    // 40 << hscale
    // [110] screensize::$1 = $28 << screensize::hscale#0 -- vbuaa=vbuc1_rol_vbuaa 
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
    // [111] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbuaa 
    sta x
    // char vscale = (*VERA_DC_VSCALE) >> 7
    // [112] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuaa=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    // 30 << vscale
    // [113] screensize::$3 = $1e << screensize::vscale#0 -- vbuaa=vbuc1_rol_vbuaa 
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
    // [114] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbuaa 
    sta y
    // screensize::@return
    // }
    // [115] return 
    rts
}
  // screenlayer
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer: {
    .label layer = 1
    .label __1 = $1a
    .label __5 = $1a
    .label vera_layer_get_width1_config = $1c
    .label vera_layer_get_width1_return = $1e
    .label vera_layer_get_height1_config = $20
    .label vera_layer_get_height1_return = $1a
    // cx16_conio.conio_screen_layer = layer
    // [116] *((byte*)&cx16_conio) = screenlayer::layer#0 -- _deref_pbuc1=vbuc2 
    lda #layer
    sta cx16_conio
    // vera_layer_get_mapbase_bank(layer)
    // [117] call vera_layer_get_mapbase_bank 
    // [375] phi from screenlayer to vera_layer_get_mapbase_bank [phi:screenlayer->vera_layer_get_mapbase_bank]
    // [375] phi vera_layer_get_mapbase_bank::layer#2 = screenlayer::layer#0 [phi:screenlayer->vera_layer_get_mapbase_bank#0] -- vbuxx=vbuc1 
    tax
    jsr vera_layer_get_mapbase_bank
    // vera_layer_get_mapbase_bank(layer)
    // [118] vera_layer_get_mapbase_bank::return#3 = vera_layer_get_mapbase_bank::return#0
    // screenlayer::@3
    // [119] screenlayer::$0 = vera_layer_get_mapbase_bank::return#3
    // cx16_conio.conio_screen_bank = vera_layer_get_mapbase_bank(layer)
    // [120] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) = screenlayer::$0 -- _deref_pbuc1=vbuaa 
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // vera_layer_get_mapbase_offset(layer)
    // [121] call vera_layer_get_mapbase_offset 
    // [378] phi from screenlayer::@3 to vera_layer_get_mapbase_offset [phi:screenlayer::@3->vera_layer_get_mapbase_offset]
    // [378] phi vera_layer_get_mapbase_offset::layer#2 = screenlayer::layer#0 [phi:screenlayer::@3->vera_layer_get_mapbase_offset#0] -- vbuaa=vbuc1 
    lda #layer
    jsr vera_layer_get_mapbase_offset
    // vera_layer_get_mapbase_offset(layer)
    // [122] vera_layer_get_mapbase_offset::return#3 = vera_layer_get_mapbase_offset::return#0
    // screenlayer::@4
    // [123] screenlayer::$1 = vera_layer_get_mapbase_offset::return#3
    // cx16_conio.conio_screen_text = vera_layer_get_mapbase_offset(layer)
    // [124] *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) = (byte*)screenlayer::$1 -- _deref_qbuc1=pbuz1 
    lda.z __1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    lda.z __1+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    // screenlayer::vera_layer_get_width1
    // byte* config = vera_layer_config[layer]
    // [125] screenlayer::vera_layer_get_width1_config#0 = *(vera_layer_config+screenlayer::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+layer*SIZEOF_POINTER
    sta.z vera_layer_get_width1_config
    lda vera_layer_config+layer*SIZEOF_POINTER+1
    sta.z vera_layer_get_width1_config+1
    // *config & VERA_LAYER_WIDTH_MASK
    // [126] screenlayer::vera_layer_get_width1_$0 = *screenlayer::vera_layer_get_width1_config#0 & VERA_LAYER_WIDTH_MASK -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    ldy #0
    and (vera_layer_get_width1_config),y
    // (*config & VERA_LAYER_WIDTH_MASK) >> 4
    // [127] screenlayer::vera_layer_get_width1_$1 = screenlayer::vera_layer_get_width1_$0 >> 4 -- vbuaa=vbuaa_ror_4 
    lsr
    lsr
    lsr
    lsr
    // return VERA_LAYER_WIDTH[ (*config & VERA_LAYER_WIDTH_MASK) >> 4];
    // [128] screenlayer::vera_layer_get_width1_$3 = screenlayer::vera_layer_get_width1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [129] screenlayer::vera_layer_get_width1_return#0 = VERA_LAYER_WIDTH[screenlayer::vera_layer_get_width1_$3] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda VERA_LAYER_WIDTH,y
    sta.z vera_layer_get_width1_return
    lda VERA_LAYER_WIDTH+1,y
    sta.z vera_layer_get_width1_return+1
    // screenlayer::@1
    // cx16_conio.conio_map_width = vera_layer_get_width(layer)
    // [130] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) = screenlayer::vera_layer_get_width1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_width1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    lda.z vera_layer_get_width1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    // screenlayer::vera_layer_get_height1
    // byte* config = vera_layer_config[layer]
    // [131] screenlayer::vera_layer_get_height1_config#0 = *(vera_layer_config+screenlayer::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+layer*SIZEOF_POINTER
    sta.z vera_layer_get_height1_config
    lda vera_layer_config+layer*SIZEOF_POINTER+1
    sta.z vera_layer_get_height1_config+1
    // *config & VERA_LAYER_HEIGHT_MASK
    // [132] screenlayer::vera_layer_get_height1_$0 = *screenlayer::vera_layer_get_height1_config#0 & VERA_LAYER_HEIGHT_MASK -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    ldy #0
    and (vera_layer_get_height1_config),y
    // (*config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [133] screenlayer::vera_layer_get_height1_$1 = screenlayer::vera_layer_get_height1_$0 >> 6 -- vbuaa=vbuaa_ror_6 
    rol
    rol
    rol
    and #3
    // return VERA_LAYER_HEIGHT[ (*config & VERA_LAYER_HEIGHT_MASK) >> 6];
    // [134] screenlayer::vera_layer_get_height1_$3 = screenlayer::vera_layer_get_height1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [135] screenlayer::vera_layer_get_height1_return#0 = VERA_LAYER_HEIGHT[screenlayer::vera_layer_get_height1_$3] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda VERA_LAYER_HEIGHT,y
    sta.z vera_layer_get_height1_return
    lda VERA_LAYER_HEIGHT+1,y
    sta.z vera_layer_get_height1_return+1
    // screenlayer::@2
    // cx16_conio.conio_map_height = vera_layer_get_height(layer)
    // [136] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) = screenlayer::vera_layer_get_height1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_height1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    lda.z vera_layer_get_height1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    // vera_layer_get_rowshift(layer)
    // [137] call vera_layer_get_rowshift 
    jsr vera_layer_get_rowshift
    // [138] vera_layer_get_rowshift::return#2 = vera_layer_get_rowshift::return#0
    // screenlayer::@5
    // [139] screenlayer::$4 = vera_layer_get_rowshift::return#2
    // cx16_conio.conio_rowshift = vera_layer_get_rowshift(layer)
    // [140] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) = screenlayer::$4 -- _deref_pbuc1=vbuaa 
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
    // vera_layer_get_rowskip(layer)
    // [141] call vera_layer_get_rowskip 
    jsr vera_layer_get_rowskip
    // [142] vera_layer_get_rowskip::return#2 = vera_layer_get_rowskip::return#0
    // screenlayer::@6
    // [143] screenlayer::$5 = vera_layer_get_rowskip::return#2
    // cx16_conio.conio_rowskip = vera_layer_get_rowskip(layer)
    // [144] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) = screenlayer::$5 -- _deref_pwuc1=vwuz1 
    lda.z __5
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    lda.z __5+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    // screenlayer::@return
    // }
    // [145] return 
    rts
}
  // vera_layer_set_textcolor
// Set the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15) when the VERA works in 16x16 color text mode.
//   An 8 bit value (decimal between 0 and 255) when the VERA works in 256 text mode.
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_set_textcolor(byte register(X) layer)
vera_layer_set_textcolor: {
    // vera_layer_textcolor[layer] = color
    // [147] vera_layer_textcolor[vera_layer_set_textcolor::layer#2] = WHITE -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #WHITE
    sta vera_layer_textcolor,x
    // vera_layer_set_textcolor::@return
    // }
    // [148] return 
    rts
}
  // vera_layer_set_backcolor
// Set the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_set_backcolor(byte register(X) layer, byte register(A) color)
vera_layer_set_backcolor: {
    // vera_layer_backcolor[layer] = color
    // [150] vera_layer_backcolor[vera_layer_set_backcolor::layer#2] = vera_layer_set_backcolor::color#2 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta vera_layer_backcolor,x
    // vera_layer_set_backcolor::@return
    // }
    // [151] return 
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
    .label addr = $1a
    // byte* addr = vera_layer_mapbase[layer]
    // [153] vera_layer_set_mapbase::$0 = vera_layer_set_mapbase::layer#3 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [154] vera_layer_set_mapbase::addr#0 = vera_layer_mapbase[vera_layer_set_mapbase::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_mapbase,y
    sta.z addr
    lda vera_layer_mapbase+1,y
    sta.z addr+1
    // *addr = mapbase
    // [155] *vera_layer_set_mapbase::addr#0 = vera_layer_set_mapbase::mapbase#3 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_mapbase::@return
    // }
    // [156] return 
    rts
}
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
cursor: {
    .const onoff = 0
    // cx16_conio.conio_display_cursor = onoff
    // [157] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR
    // cursor::@return
    // }
    // [158] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .label __6 = $1a
    .label line_offset = $1a
    // if(y>cx16_conio.conio_screen_height)
    // [160] if(gotoxy::y#4<=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto gotoxy::@4 -- vbuxx_le__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    stx.z $ff
    cmp.z $ff
    bcs __b1
    // [162] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [162] phi gotoxy::y#5 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [161] phi from gotoxy to gotoxy::@4 [phi:gotoxy->gotoxy::@4]
    // gotoxy::@4
    // [162] phi from gotoxy::@4 to gotoxy::@1 [phi:gotoxy::@4->gotoxy::@1]
    // [162] phi gotoxy::y#5 = gotoxy::y#4 [phi:gotoxy::@4->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=cx16_conio.conio_screen_width)
    // [163] if(0<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto gotoxy::@2 -- 0_lt__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    cmp #0
    // [164] phi from gotoxy::@1 to gotoxy::@3 [phi:gotoxy::@1->gotoxy::@3]
    // gotoxy::@3
    // gotoxy::@2
    // conio_cursor_x[cx16_conio.conio_screen_layer] = x
    // [165] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = y
    // [166] conio_cursor_y[*((byte*)&cx16_conio)] = gotoxy::y#5 -- pbuc1_derefidx_(_deref_pbuc2)=vbuxx 
    txa
    sta conio_cursor_y,y
    // (unsigned int)y << cx16_conio.conio_rowshift
    // [167] gotoxy::$6 = (word)gotoxy::y#5 -- vwuz1=_word_vbuxx 
    txa
    sta.z __6
    lda #0
    sta.z __6+1
    // unsigned int line_offset = (unsigned int)y << cx16_conio.conio_rowshift
    // [168] gotoxy::line_offset#0 = gotoxy::$6 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vwuz1_rol__deref_pbuc1 
    ldy cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
    cpy #0
    beq !e+
  !:
    asl.z line_offset
    rol.z line_offset+1
    dey
    bne !-
  !e:
    // conio_line_text[cx16_conio.conio_screen_layer] = line_offset
    // [169] gotoxy::$5 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // [170] conio_line_text[gotoxy::$5] = gotoxy::line_offset#0 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z line_offset
    sta conio_line_text,y
    lda.z line_offset+1
    sta conio_line_text+1,y
    // gotoxy::@return
    // }
    // [171] return 
    rts
}
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
textcolor: {
    // vera_layer_set_textcolor(cx16_conio.conio_screen_layer, color)
    // [172] vera_layer_set_textcolor::layer#1 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [173] call vera_layer_set_textcolor 
    // [146] phi from textcolor to vera_layer_set_textcolor [phi:textcolor->vera_layer_set_textcolor]
    // [146] phi vera_layer_set_textcolor::layer#2 = vera_layer_set_textcolor::layer#1 [phi:textcolor->vera_layer_set_textcolor#0] -- register_copy 
    jsr vera_layer_set_textcolor
    // textcolor::@return
    // }
    // [174] return 
    rts
}
  // bgcolor
// Set the back color for text output. The old back text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
bgcolor: {
    // vera_layer_set_backcolor(cx16_conio.conio_screen_layer, color)
    // [175] vera_layer_set_backcolor::layer#1 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [176] call vera_layer_set_backcolor 
    // [149] phi from bgcolor to vera_layer_set_backcolor [phi:bgcolor->vera_layer_set_backcolor]
    // [149] phi vera_layer_set_backcolor::color#2 = BLACK [phi:bgcolor->vera_layer_set_backcolor#0] -- vbuaa=vbuc1 
    lda #BLACK
    // [149] phi vera_layer_set_backcolor::layer#2 = vera_layer_set_backcolor::layer#1 [phi:bgcolor->vera_layer_set_backcolor#1] -- register_copy 
    jsr vera_layer_set_backcolor
    // bgcolor::@return
    // }
    // [177] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __1 = $15
    .label line_text = $16
    .label color = $15
    .label conio_map_height = $2e
    .label conio_map_width = $30
    // char* line_text = cx16_conio.conio_screen_text
    // [178] clrscr::line_text#0 = *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- pbuz1=_deref_qbuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z line_text+1
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer)
    // [179] vera_layer_get_backcolor::layer#0 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [180] call vera_layer_get_backcolor 
    jsr vera_layer_get_backcolor
    // [181] vera_layer_get_backcolor::return#2 = vera_layer_get_backcolor::return#0
    // clrscr::@7
    // [182] clrscr::$0 = vera_layer_get_backcolor::return#2
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4
    // [183] clrscr::$1 = clrscr::$0 << 4 -- vbuz1=vbuaa_rol_4 
    asl
    asl
    asl
    asl
    sta.z __1
    // vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [184] vera_layer_get_textcolor::layer#0 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [185] call vera_layer_get_textcolor 
    jsr vera_layer_get_textcolor
    // [186] vera_layer_get_textcolor::return#2 = vera_layer_get_textcolor::return#0
    // clrscr::@8
    // [187] clrscr::$2 = vera_layer_get_textcolor::return#2
    // char color = ( vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4 ) | vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [188] clrscr::color#0 = clrscr::$1 | clrscr::$2 -- vbuz1=vbuz1_bor_vbuaa 
    ora.z color
    sta.z color
    // word conio_map_height = cx16_conio.conio_map_height
    // [189] clrscr::conio_map_height#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    sta.z conio_map_height
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    sta.z conio_map_height+1
    // word conio_map_width = cx16_conio.conio_map_width
    // [190] clrscr::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // [191] phi from clrscr::@8 to clrscr::@1 [phi:clrscr::@8->clrscr::@1]
    // [191] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr::@8->clrscr::@1#0] -- register_copy 
    // [191] phi clrscr::l#2 = 0 [phi:clrscr::@8->clrscr::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // clrscr::@1
  __b1:
    // for( char l=0;l<conio_map_height; l++ )
    // [192] if(clrscr::l#2<clrscr::conio_map_height#0) goto clrscr::@2 -- vbuxx_lt_vwuz1_then_la1 
    lda.z conio_map_height+1
    bne __b2
    cpx.z conio_map_height
    bcc __b2
    // clrscr::@3
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [193] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = 0
    // [194] conio_cursor_y[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    sta conio_cursor_y,y
    // conio_line_text[cx16_conio.conio_screen_layer] = 0
    // [195] clrscr::$9 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    tya
    asl
    // [196] conio_line_text[clrscr::$9] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta conio_line_text,y
    sta conio_line_text+1,y
    // clrscr::@return
    // }
    // [197] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [198] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <ch
    // [199] clrscr::$5 = < clrscr::line_text#2 -- vbuaa=_lo_pbuz1 
    lda.z line_text
    // *VERA_ADDRX_L = <ch
    // [200] *VERA_ADDRX_L = clrscr::$5 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >ch
    // [201] clrscr::$6 = > clrscr::line_text#2 -- vbuaa=_hi_pbuz1 
    lda.z line_text+1
    // *VERA_ADDRX_M = >ch
    // [202] *VERA_ADDRX_M = clrscr::$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [203] clrscr::$7 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [204] *VERA_ADDRX_H = clrscr::$7 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [205] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [205] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuyy=vbuc1 
    ldy #0
    // clrscr::@4
  __b4:
    // for( char c=0;c<conio_map_width; c++ )
    // [206] if(clrscr::c#2<clrscr::conio_map_width#0) goto clrscr::@5 -- vbuyy_lt_vwuz1_then_la1 
    lda.z conio_map_width+1
    bne __b5
    cpy.z conio_map_width
    bcc __b5
    // clrscr::@6
    // line_text += cx16_conio.conio_rowskip
    // [207] clrscr::line_text#1 = clrscr::line_text#2 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- pbuz1=pbuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z line_text
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z line_text+1
    sta.z line_text+1
    // for( char l=0;l<conio_map_height; l++ )
    // [208] clrscr::l#1 = ++ clrscr::l#2 -- vbuxx=_inc_vbuxx 
    inx
    // [191] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [191] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [191] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [209] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [210] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<conio_map_width; c++ )
    // [211] clrscr::c#1 = ++ clrscr::c#2 -- vbuyy=_inc_vbuyy 
    iny
    // [205] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [205] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
}
  // vera_layer_mode_tile
// Set a vera layer in tile mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: the address of the mapbase.
//   Note that the mapbase register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - tilebase_address: the address of the tilebase.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// - mapwidth: The width of the map in number of tiles.
// - mapheight: The height of the map in number of tiles.
// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
// - tileheight: The height of a tile, which can be 8 or 16 pixels.
// - color_depth: The color depth in bits per pixel (BPP), which can be 1, 2, 4 or 8.
// vera_layer_mode_tile(byte zp($10) layer, byte zp($11) mapbase_address_bank, word zp($1e) mapbase_address_ptr, byte zp($12) tilebase_address_bank, word zp($20) tilebase_address_ptr, word zp($1a) mapwidth, word zp($1c) mapheight, byte zp($13) tilewidth, byte zp($14) tileheight, byte register(X) color_depth)
vera_layer_mode_tile: {
    .label __1 = $11
    .label __6 = $12
    .label __18 = $23
    .label mapwidth = $1a
    .label layer = $10
    .label mapheight = $1c
    .label mapbase_address_ptr = $1e
    .label mapbase_address_bank = $11
    .label tilewidth = $13
    .label tilebase_address_ptr = $20
    .label tilebase_address_bank = $12
    .label tileheight = $14
    .label __21 = $22
    // case 1:
    //             config |= VERA_LAYER_COLOR_DEPTH_1BPP;
    //             break;
    // [213] if(vera_layer_mode_tile::color_depth#2==1) goto vera_layer_mode_tile::@5 -- vbuxx_eq_vbuc1_then_la1 
    cpx #1
    beq __b1
    // vera_layer_mode_tile::@1
    // case 2:
    //             config |= VERA_LAYER_COLOR_DEPTH_2BPP;
    //             break;
    // [214] if(vera_layer_mode_tile::color_depth#2==2) goto vera_layer_mode_tile::@5 -- vbuxx_eq_vbuc1_then_la1 
    cpx #2
    beq __b2
    // vera_layer_mode_tile::@2
    // case 4:
    //             config |= VERA_LAYER_COLOR_DEPTH_4BPP;
    //             break;
    // [215] if(vera_layer_mode_tile::color_depth#2==4) goto vera_layer_mode_tile::@5 -- vbuxx_eq_vbuc1_then_la1 
    cpx #4
    beq __b3
    // vera_layer_mode_tile::@3
    // case 8:
    //             config |= VERA_LAYER_COLOR_DEPTH_8BPP;
    //             break;
    // [216] if(vera_layer_mode_tile::color_depth#2!=8) goto vera_layer_mode_tile::@5 -- vbuxx_neq_vbuc1_then_la1 
    cpx #8
    bne __b4
    // [217] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@4 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@4]
    // vera_layer_mode_tile::@4
    // [218] phi from vera_layer_mode_tile::@4 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5]
    // [218] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_8BPP [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_8BPP
    jmp __b5
    // [218] phi from vera_layer_mode_tile to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5]
  __b1:
    // [218] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_1BPP [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_1BPP
    jmp __b5
    // [218] phi from vera_layer_mode_tile::@1 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5]
  __b2:
    // [218] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_2BPP [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_2BPP
    jmp __b5
    // [218] phi from vera_layer_mode_tile::@2 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5]
  __b3:
    // [218] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_4BPP [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_4BPP
    jmp __b5
    // [218] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5]
  __b4:
    // [218] phi vera_layer_mode_tile::config#17 = 0 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #0
    // vera_layer_mode_tile::@5
  __b5:
    // case 32:
    //             config |= VERA_LAYER_WIDTH_32;
    //             vera_layer_rowshift[layer] = 6;
    //             vera_layer_rowskip[layer] = 64;
    //             break;
    // [219] if(vera_layer_mode_tile::mapwidth#10==$20) goto vera_layer_mode_tile::@9 -- vwuz1_eq_vbuc1_then_la1 
    lda #$20
    cmp.z mapwidth
    bne !+
    lda.z mapwidth+1
    bne !+
    jmp __b9
  !:
    // vera_layer_mode_tile::@6
    // case 64:
    //             config |= VERA_LAYER_WIDTH_64;
    //             vera_layer_rowshift[layer] = 7;
    //             vera_layer_rowskip[layer] = 128;
    //             break;
    // [220] if(vera_layer_mode_tile::mapwidth#10==$40) goto vera_layer_mode_tile::@10 -- vwuz1_eq_vbuc1_then_la1 
    lda #$40
    cmp.z mapwidth
    bne !+
    lda.z mapwidth+1
    bne !+
    jmp __b10
  !:
    // vera_layer_mode_tile::@7
    // case 128:
    //             config |= VERA_LAYER_WIDTH_128;
    //             vera_layer_rowshift[layer] = 8;
    //             vera_layer_rowskip[layer] = 256;
    //             break;
    // [221] if(vera_layer_mode_tile::mapwidth#10==$80) goto vera_layer_mode_tile::@11 -- vwuz1_eq_vbuc1_then_la1 
    lda #$80
    cmp.z mapwidth
    bne !+
    lda.z mapwidth+1
    bne !+
    jmp __b11
  !:
    // vera_layer_mode_tile::@8
    // case 256:
    //             config |= VERA_LAYER_WIDTH_256;
    //             vera_layer_rowshift[layer] = 9;
    //             vera_layer_rowskip[layer] = 512;
    //             break;
    // [222] if(vera_layer_mode_tile::mapwidth#10!=$100) goto vera_layer_mode_tile::@13 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapwidth+1
    cmp #>$100
    bne __b13
    lda.z mapwidth
    cmp #<$100
    bne __b13
    // vera_layer_mode_tile::@12
    // config |= VERA_LAYER_WIDTH_256
    // [223] vera_layer_mode_tile::config#8 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_256 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_WIDTH_256
    tax
    // vera_layer_rowshift[layer] = 9
    // [224] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 9 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #9
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 512
    // [225] vera_layer_mode_tile::$14 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [226] vera_layer_rowskip[vera_layer_mode_tile::$14] = $200 -- pwuc1_derefidx_vbuaa=vwuc2 
    tay
    lda #<$200
    sta vera_layer_rowskip,y
    lda #>$200
    sta vera_layer_rowskip+1,y
    // [227] phi from vera_layer_mode_tile::@10 vera_layer_mode_tile::@11 vera_layer_mode_tile::@12 vera_layer_mode_tile::@8 vera_layer_mode_tile::@9 to vera_layer_mode_tile::@13 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13]
    // [227] phi vera_layer_mode_tile::config#21 = vera_layer_mode_tile::config#6 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13#0] -- register_copy 
    // vera_layer_mode_tile::@13
  __b13:
    // case 32:
    //             config |= VERA_LAYER_HEIGHT_32;
    //             break;
    // [228] if(vera_layer_mode_tile::mapheight#10==$20) goto vera_layer_mode_tile::@20 -- vwuz1_eq_vbuc1_then_la1 
    lda #$20
    cmp.z mapheight
    bne !+
    lda.z mapheight+1
    bne !+
    jmp __b20
  !:
    // vera_layer_mode_tile::@14
    // case 64:
    //             config |= VERA_LAYER_HEIGHT_64;
    //             break;
    // [229] if(vera_layer_mode_tile::mapheight#10==$40) goto vera_layer_mode_tile::@17 -- vwuz1_eq_vbuc1_then_la1 
    lda #$40
    cmp.z mapheight
    bne !+
    lda.z mapheight+1
    bne !+
    jmp __b17
  !:
    // vera_layer_mode_tile::@15
    // case 128:
    //             config |= VERA_LAYER_HEIGHT_128;
    //             break;
    // [230] if(vera_layer_mode_tile::mapheight#10==$80) goto vera_layer_mode_tile::@18 -- vwuz1_eq_vbuc1_then_la1 
    lda #$80
    cmp.z mapheight
    bne !+
    lda.z mapheight+1
    bne !+
    jmp __b18
  !:
    // vera_layer_mode_tile::@16
    // case 256:
    //             config |= VERA_LAYER_HEIGHT_256;
    //             break;
    // [231] if(vera_layer_mode_tile::mapheight#10!=$100) goto vera_layer_mode_tile::@20 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapheight+1
    cmp #>$100
    bne __b20
    lda.z mapheight
    cmp #<$100
    bne __b20
    // vera_layer_mode_tile::@19
    // config |= VERA_LAYER_HEIGHT_256
    // [232] vera_layer_mode_tile::config#12 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_256 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_HEIGHT_256
    tax
    // [233] phi from vera_layer_mode_tile::@13 vera_layer_mode_tile::@16 vera_layer_mode_tile::@17 vera_layer_mode_tile::@18 vera_layer_mode_tile::@19 to vera_layer_mode_tile::@20 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20]
    // [233] phi vera_layer_mode_tile::config#25 = vera_layer_mode_tile::config#21 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20#0] -- register_copy 
    // vera_layer_mode_tile::@20
  __b20:
    // vera_layer_set_config(layer, config)
    // [234] vera_layer_set_config::layer#0 = vera_layer_mode_tile::layer#10 -- vbuaa=vbuz1 
    lda.z layer
    // [235] vera_layer_set_config::config#0 = vera_layer_mode_tile::config#25
    // [236] call vera_layer_set_config 
    jsr vera_layer_set_config
    // vera_layer_mode_tile::@27
    // vera_mapbase_offset[layer] = mapbase_address.ptr
    // [237] vera_layer_mode_tile::$21 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z layer
    asl
    sta.z __21
    // [238] vera_mapbase_offset[vera_layer_mode_tile::$21] = vera_layer_mode_tile::mapbase_address_ptr#10 -- pwuc1_derefidx_vbuz1=vwuz2 
    // mapbase
    tay
    lda.z mapbase_address_ptr
    sta vera_mapbase_offset,y
    lda.z mapbase_address_ptr+1
    sta vera_mapbase_offset+1,y
    // vera_mapbase_bank[layer] = mapbase_address.bank
    // [239] vera_mapbase_bank[vera_layer_mode_tile::layer#10] = vera_layer_mode_tile::mapbase_address_bank#10 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z mapbase_address_bank
    ldy.z layer
    sta vera_mapbase_bank,y
    // vera_mapbase_address[layer] = mapbase_address
    // [240] vera_layer_mode_tile::$18 = vera_layer_mode_tile::$21 + vera_layer_mode_tile::layer#10 -- vbuz1=vbuz2_plus_vbuz3 
    lda.z __21
    clc
    adc.z layer
    sta.z __18
    // [241] ((byte*)vera_mapbase_address)[vera_layer_mode_tile::$18] = vera_layer_mode_tile::mapbase_address_bank#10 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z mapbase_address_bank
    ldy.z __18
    sta vera_mapbase_address,y
    // [242] ((word*)vera_mapbase_address+1)[vera_layer_mode_tile::$18] = vera_layer_mode_tile::mapbase_address_ptr#10 -- pwuc1_derefidx_vbuz1=vwuz2 
    lda.z mapbase_address_ptr
    sta vera_mapbase_address+1,y
    lda.z mapbase_address_ptr+1
    sta vera_mapbase_address+1+1,y
    // (byte)mapbase_address.bank<<7
    // [243] vera_layer_mode_tile::$1 = vera_layer_mode_tile::mapbase_address_bank#10 << 7 -- vbuz1=vbuz1_rol_7 
    lda.z __1
    asl
    asl
    asl
    asl
    asl
    asl
    asl
    sta.z __1
    // <mapbase_address.ptr
    // [244] vera_layer_mode_tile::$2 = < vera_layer_mode_tile::mapbase_address_ptr#10 -- vbuaa=_lo_vwuz1 
    lda.z mapbase_address_ptr
    // (<mapbase_address.ptr)>>1
    // [245] vera_layer_mode_tile::$3 = vera_layer_mode_tile::$2 >> 1 -- vbuaa=vbuaa_ror_1 
    lsr
    // byte mapbase = (byte)mapbase_address.bank<<7 | (<mapbase_address.ptr)>>1
    // [246] vera_layer_mode_tile::mapbase#0 = vera_layer_mode_tile::$1 | vera_layer_mode_tile::$3 -- vbuxx=vbuz1_bor_vbuaa 
    ora.z __1
    tax
    // vera_layer_set_mapbase(layer,mapbase)
    // [247] vera_layer_set_mapbase::layer#0 = vera_layer_mode_tile::layer#10 -- vbuaa=vbuz1 
    lda.z layer
    // [248] vera_layer_set_mapbase::mapbase#0 = vera_layer_mode_tile::mapbase#0
    // [249] call vera_layer_set_mapbase 
    // [152] phi from vera_layer_mode_tile::@27 to vera_layer_set_mapbase [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase]
    // [152] phi vera_layer_set_mapbase::mapbase#3 = vera_layer_set_mapbase::mapbase#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#0] -- register_copy 
    // [152] phi vera_layer_set_mapbase::layer#3 = vera_layer_set_mapbase::layer#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#1] -- register_copy 
    jsr vera_layer_set_mapbase
    // vera_layer_mode_tile::@28
    // vera_tilebase_offset[layer] = tilebase_address.ptr
    // [250] vera_tilebase_offset[vera_layer_mode_tile::$21] = vera_layer_mode_tile::tilebase_address_ptr#10 -- pwuc1_derefidx_vbuz1=vwuz2 
    // tilebase
    ldy.z __21
    lda.z tilebase_address_ptr
    sta vera_tilebase_offset,y
    lda.z tilebase_address_ptr+1
    sta vera_tilebase_offset+1,y
    // vera_tilebase_bank[layer] = tilebase_address.bank
    // [251] vera_tilebase_bank[vera_layer_mode_tile::layer#10] = vera_layer_mode_tile::tilebase_address_bank#10 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z tilebase_address_bank
    ldy.z layer
    sta vera_tilebase_bank,y
    // vera_tilebase_address[layer] = tilebase_address
    // [252] ((byte*)vera_tilebase_address)[vera_layer_mode_tile::$18] = vera_layer_mode_tile::tilebase_address_bank#10 -- pbuc1_derefidx_vbuz1=vbuz2 
    ldy.z __18
    sta vera_tilebase_address,y
    // [253] ((word*)vera_tilebase_address+1)[vera_layer_mode_tile::$18] = vera_layer_mode_tile::tilebase_address_ptr#10 -- pwuc1_derefidx_vbuz1=vwuz2 
    lda.z tilebase_address_ptr
    sta vera_tilebase_address+1,y
    lda.z tilebase_address_ptr+1
    sta vera_tilebase_address+1+1,y
    // (byte)tilebase_address.bank<<7
    // [254] vera_layer_mode_tile::$6 = vera_layer_mode_tile::tilebase_address_bank#10 << 7 -- vbuz1=vbuz1_rol_7 
    lda.z __6
    asl
    asl
    asl
    asl
    asl
    asl
    asl
    sta.z __6
    // <tilebase_address.ptr
    // [255] vera_layer_mode_tile::$7 = < vera_layer_mode_tile::tilebase_address_ptr#10 -- vbuaa=_lo_vwuz1 
    lda.z tilebase_address_ptr
    // (<tilebase_address.ptr)>>1
    // [256] vera_layer_mode_tile::$8 = vera_layer_mode_tile::$7 >> 1 -- vbuaa=vbuaa_ror_1 
    lsr
    // byte tilebase = (byte)tilebase_address.bank<<7 | (<tilebase_address.ptr)>>1
    // [257] vera_layer_mode_tile::tilebase#0 = vera_layer_mode_tile::$6 | vera_layer_mode_tile::$8 -- vbuaa=vbuz1_bor_vbuaa 
    ora.z __6
    // tilebase &= VERA_LAYER_TILEBASE_MASK
    // [258] vera_layer_mode_tile::tilebase#1 = vera_layer_mode_tile::tilebase#0 & VERA_LAYER_TILEBASE_MASK -- vbuxx=vbuaa_band_vbuc1 
    and #VERA_LAYER_TILEBASE_MASK
    tax
    // case 8:
    //             tilebase |= VERA_TILEBASE_WIDTH_8;
    //             break;
    // [259] if(vera_layer_mode_tile::tilewidth#10==8) goto vera_layer_mode_tile::@23 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tilewidth
    beq __b23
    // vera_layer_mode_tile::@21
    // case 16:
    //             tilebase |= VERA_TILEBASE_WIDTH_16;
    //             break;
    // [260] if(vera_layer_mode_tile::tilewidth#10!=$10) goto vera_layer_mode_tile::@23 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tilewidth
    bne __b23
    // vera_layer_mode_tile::@22
    // tilebase |= VERA_TILEBASE_WIDTH_16
    // [261] vera_layer_mode_tile::tilebase#3 = vera_layer_mode_tile::tilebase#1 | VERA_TILEBASE_WIDTH_16 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_TILEBASE_WIDTH_16
    tax
    // [262] phi from vera_layer_mode_tile::@21 vera_layer_mode_tile::@22 vera_layer_mode_tile::@28 to vera_layer_mode_tile::@23 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23]
    // [262] phi vera_layer_mode_tile::tilebase#12 = vera_layer_mode_tile::tilebase#1 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23#0] -- register_copy 
    // vera_layer_mode_tile::@23
  __b23:
    // case 8:
    //             tilebase |= VERA_TILEBASE_HEIGHT_8;
    //             break;
    // [263] if(vera_layer_mode_tile::tileheight#10==8) goto vera_layer_mode_tile::@26 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tileheight
    beq __b26
    // vera_layer_mode_tile::@24
    // case 16:
    //             tilebase |= VERA_TILEBASE_HEIGHT_16;
    //             break;
    // [264] if(vera_layer_mode_tile::tileheight#10!=$10) goto vera_layer_mode_tile::@26 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tileheight
    bne __b26
    // vera_layer_mode_tile::@25
    // tilebase |= VERA_TILEBASE_HEIGHT_16
    // [265] vera_layer_mode_tile::tilebase#5 = vera_layer_mode_tile::tilebase#12 | VERA_TILEBASE_HEIGHT_16 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_TILEBASE_HEIGHT_16
    tax
    // [266] phi from vera_layer_mode_tile::@23 vera_layer_mode_tile::@24 vera_layer_mode_tile::@25 to vera_layer_mode_tile::@26 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26]
    // [266] phi vera_layer_mode_tile::tilebase#10 = vera_layer_mode_tile::tilebase#12 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26#0] -- register_copy 
    // vera_layer_mode_tile::@26
  __b26:
    // vera_layer_set_tilebase(layer,tilebase)
    // [267] vera_layer_set_tilebase::layer#0 = vera_layer_mode_tile::layer#10 -- vbuaa=vbuz1 
    lda.z layer
    // [268] vera_layer_set_tilebase::tilebase#0 = vera_layer_mode_tile::tilebase#10
    // [269] call vera_layer_set_tilebase 
    jsr vera_layer_set_tilebase
    // vera_layer_mode_tile::@return
    // }
    // [270] return 
    rts
    // vera_layer_mode_tile::@18
  __b18:
    // config |= VERA_LAYER_HEIGHT_128
    // [271] vera_layer_mode_tile::config#11 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_128 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_HEIGHT_128
    tax
    jmp __b20
    // vera_layer_mode_tile::@17
  __b17:
    // config |= VERA_LAYER_HEIGHT_64
    // [272] vera_layer_mode_tile::config#10 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_64 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_HEIGHT_64
    tax
    jmp __b20
    // vera_layer_mode_tile::@11
  __b11:
    // config |= VERA_LAYER_WIDTH_128
    // [273] vera_layer_mode_tile::config#7 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_128 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_WIDTH_128
    tax
    // vera_layer_rowshift[layer] = 8
    // [274] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 8 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #8
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 256
    // [275] vera_layer_mode_tile::$13 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [276] vera_layer_rowskip[vera_layer_mode_tile::$13] = $100 -- pwuc1_derefidx_vbuaa=vwuc2 
    tay
    lda #<$100
    sta vera_layer_rowskip,y
    lda #>$100
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@10
  __b10:
    // config |= VERA_LAYER_WIDTH_64
    // [277] vera_layer_mode_tile::config#6 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_64 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_WIDTH_64
    tax
    // vera_layer_rowshift[layer] = 7
    // [278] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 7 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #7
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 128
    // [279] vera_layer_mode_tile::$12 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [280] vera_layer_rowskip[vera_layer_mode_tile::$12] = $80 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #$80
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@9
  __b9:
    // vera_layer_rowshift[layer] = 6
    // [281] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 6 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #6
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 64
    // [282] vera_layer_mode_tile::$11 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [283] vera_layer_rowskip[vera_layer_mode_tile::$11] = $40 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #$40
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b13
}
  // cx16_cpy_vram_from_ram
// Copy block of memory (from RAM to VRAM)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - dbank_vram: Which 64K VRAM bank to put data into (0/1)
// - dptr_vram: The destination pointer in VERA VRAM (0x0000 till 0xffff)
// - sptr_vram: The source address in cx16 main RAM (cx16 banked ram can be included if bank is properly set).
// - num: The number of bytes to copy
// cx16_cpy_vram_from_ram(void* zp($16) dptr_vram)
cx16_cpy_vram_from_ram: {
    .label end = main.tiles+$40
    .label s = $18
    .label dptr_vram = $16
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [285] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <dptr_vram
    // [286] cx16_cpy_vram_from_ram::$0 = < cx16_cpy_vram_from_ram::dptr_vram#2 -- vbuaa=_lo_pvoz1 
    lda.z dptr_vram
    // *VERA_ADDRX_L = <dptr_vram
    // [287] *VERA_ADDRX_L = cx16_cpy_vram_from_ram::$0 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >dptr_vram
    // [288] cx16_cpy_vram_from_ram::$1 = > cx16_cpy_vram_from_ram::dptr_vram#2 -- vbuaa=_hi_pvoz1 
    lda.z dptr_vram+1
    // *VERA_ADDRX_M = >dptr_vram
    // [289] *VERA_ADDRX_M = cx16_cpy_vram_from_ram::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | dbank_vram
    // [290] *VERA_ADDRX_H = VERA_INC_1|1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|1
    sta VERA_ADDRX_H
    // [291] phi from cx16_cpy_vram_from_ram to cx16_cpy_vram_from_ram::@1 [phi:cx16_cpy_vram_from_ram->cx16_cpy_vram_from_ram::@1]
    // [291] phi cx16_cpy_vram_from_ram::s#2 = (byte*)(void*)main::tiles [phi:cx16_cpy_vram_from_ram->cx16_cpy_vram_from_ram::@1#0] -- pbuz1=pbuc1 
    lda #<main.tiles
    sta.z s
    lda #>main.tiles
    sta.z s+1
    // cx16_cpy_vram_from_ram::@1
  __b1:
    // for(char *s = sptr_vram; s!=end; s++)
    // [292] if(cx16_cpy_vram_from_ram::s#2!=cx16_cpy_vram_from_ram::end#0) goto cx16_cpy_vram_from_ram::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z s+1
    cmp #>end
    bne __b2
    lda.z s
    cmp #<end
    bne __b2
    // cx16_cpy_vram_from_ram::@return
    // }
    // [293] return 
    rts
    // cx16_cpy_vram_from_ram::@2
  __b2:
    // *VERA_DATA0 = *s
    // [294] *VERA_DATA0 = *cx16_cpy_vram_from_ram::s#2 -- _deref_pbuc1=_deref_pbuz1 
    ldy #0
    lda (s),y
    sta VERA_DATA0
    // for(char *s = sptr_vram; s!=end; s++)
    // [295] cx16_cpy_vram_from_ram::s#1 = ++ cx16_cpy_vram_from_ram::s#2 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [291] phi from cx16_cpy_vram_from_ram::@2 to cx16_cpy_vram_from_ram::@1 [phi:cx16_cpy_vram_from_ram::@2->cx16_cpy_vram_from_ram::@1]
    // [291] phi cx16_cpy_vram_from_ram::s#2 = cx16_cpy_vram_from_ram::s#1 [phi:cx16_cpy_vram_from_ram::@2->cx16_cpy_vram_from_ram::@1#0] -- register_copy 
    jmp __b1
}
  // vera_tile_area
// --- TILE FUNCTIONS ---
// vera_tile_area(word zp($18) tileindex, byte zp($2a) x, byte zp($15) y, byte zp($33) w, byte zp($32) h, byte zp($25) hflip, byte zp($26) vflip)
vera_tile_area: {
    .label __15 = $18
    .label __16 = $2c
    .label mapbase_ptr = $2e
    .label shift = $24
    .label rowskip = $30
    .label hflip = $25
    .label vflip = $26
    .label index_l = $27
    .label y_shifted = $18
    .label x_shifted = $2c
    .label mapbase_ptr_1 = $16
    .label mapbase_bank = $15
    .label tileindex = $18
    .label x = $2a
    .label y = $15
    .label h = $32
    .label w = $33
    .label index_h = $26
    // vera_layer_get_mapbase_bank(layer)
    // [297] call vera_layer_get_mapbase_bank 
    // [375] phi from vera_tile_area to vera_layer_get_mapbase_bank [phi:vera_tile_area->vera_layer_get_mapbase_bank]
    // [375] phi vera_layer_get_mapbase_bank::layer#2 = 0 [phi:vera_tile_area->vera_layer_get_mapbase_bank#0] -- vbuxx=vbuc1 
    ldx #0
    jsr vera_layer_get_mapbase_bank
    // [298] phi from vera_tile_area to vera_tile_area::@5 [phi:vera_tile_area->vera_tile_area::@5]
    // vera_tile_area::@5
    // vera_layer_get_mapbase_offset(layer)
    // [299] call vera_layer_get_mapbase_offset 
    // [378] phi from vera_tile_area::@5 to vera_layer_get_mapbase_offset [phi:vera_tile_area::@5->vera_layer_get_mapbase_offset]
    // [378] phi vera_layer_get_mapbase_offset::layer#2 = 0 [phi:vera_tile_area::@5->vera_layer_get_mapbase_offset#0] -- vbuaa=vbuc1 
    lda #0
    jsr vera_layer_get_mapbase_offset
    // [300] phi from vera_tile_area::@5 to vera_tile_area::@6 [phi:vera_tile_area::@5->vera_tile_area::@6]
    // vera_tile_area::@6
    // vera_layer_get_mapbase_address(layer)
    // [301] call vera_layer_get_mapbase_address 
    jsr vera_layer_get_mapbase_address
    // [302] vera_layer_get_mapbase_address::return_bank#2 = vera_layer_get_mapbase_address::return_bank#0
    // [303] vera_layer_get_mapbase_address::return_ptr#2 = vera_layer_get_mapbase_address::return_ptr#0
    // vera_tile_area::@7
    // vera_address mapbase = vera_layer_get_mapbase_address(layer)
    // [304] vera_tile_area::mapbase_bank#0 = vera_layer_get_mapbase_address::return_bank#2
    // [305] vera_tile_area::mapbase_ptr#0 = vera_layer_get_mapbase_address::return_ptr#2
    // byte shift = vera_layer_rowshift[layer]
    // [306] vera_tile_area::shift#0 = *vera_layer_rowshift -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift
    sta.z shift
    // word rowskip = (word)1 << shift
    // [307] vera_tile_area::rowskip#0 = 1 << vera_tile_area::shift#0 -- vwuz1=vwuc1_rol_vbuz2 
    tay
    lda #<1
    sta.z rowskip
    lda #>1+1
    sta.z rowskip+1
    cpy #0
    beq !e+
  !:
    asl.z rowskip
    rol.z rowskip+1
    dey
    bne !-
  !e:
    // hflip = vera_layer_hflip[hflip]
    // [308] vera_tile_area::hflip#0 = *vera_layer_hflip -- vbuz1=_deref_pbuc1 
    lda vera_layer_hflip
    sta.z hflip
    // vflip = vera_layer_vflip[vflip]
    // [309] vera_tile_area::vflip#0 = *vera_layer_vflip -- vbuz1=_deref_pbuc1 
    lda vera_layer_vflip
    sta.z vflip
    // byte index_l = <tileindex
    // [310] vera_tile_area::index_l#0 = < vera_tile_area::tileindex#3 -- vbuz1=_lo_vwuz2 
    lda.z tileindex
    sta.z index_l
    // byte index_h = >tileindex
    // [311] vera_tile_area::index_h#0 = > vera_tile_area::tileindex#3 -- vbuaa=_hi_vwuz1 
    lda.z tileindex+1
    // index_h |= hflip
    // [312] vera_tile_area::index_h#1 = vera_tile_area::index_h#0 | vera_tile_area::hflip#0 -- vbuaa=vbuaa_bor_vbuz1 
    ora.z hflip
    // index_h |= vflip
    // [313] vera_tile_area::index_h#10 = vera_tile_area::index_h#1 | vera_tile_area::vflip#0 -- vbuz1=vbuaa_bor_vbuz1 
    ora.z index_h
    sta.z index_h
    // (word)y << shift
    // [314] vera_tile_area::$15 = (word)vera_tile_area::y#3 -- vwuz1=_word_vbuz2 
    lda.z y
    sta.z __15
    lda #0
    sta.z __15+1
    // word y_shifted = ((word)y << shift)
    // [315] vera_tile_area::y_shifted#0 = vera_tile_area::$15 << vera_tile_area::shift#0 -- vwuz1=vwuz1_rol_vbuz2 
    ldy.z shift
    beq !e+
  !:
    asl.z y_shifted
    rol.z y_shifted+1
    dey
    bne !-
  !e:
    // (word)x << 1
    // [316] vera_tile_area::$16 = (word)vera_tile_area::x#3 -- vwuz1=_word_vbuz2 
    lda.z x
    sta.z __16
    lda #0
    sta.z __16+1
    // word x_shifted = ((word)x << 1)
    // [317] vera_tile_area::x_shifted#0 = vera_tile_area::$16 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z x_shifted
    rol.z x_shifted+1
    // vera_address_add(mapbase, y_shifted)
    // [318] *((byte*)&vera_address_add::address) = vera_tile_area::mapbase_bank#0 -- _deref_pbuc1=vbuxx 
    stx.z vera_address_add.address
    // [319] *((word*)&vera_address_add::address+1) = vera_tile_area::mapbase_ptr#0 -- _deref_pwuc1=vwuz1 
    lda.z mapbase_ptr
    sta vera_address_add.address+1
    lda.z mapbase_ptr+1
    sta vera_address_add.address+1+1
    // [320] vera_address_add::inc = vera_tile_area::y_shifted#0 -- vwuz1=vwuz2 
    lda.z y_shifted
    sta.z vera_address_add.inc
    lda.z y_shifted+1
    sta.z vera_address_add.inc+1
    // [321] call vera_address_add 
    jsr vera_address_add
    // [322] vera_address_add::return_bank#2 = vera_address_add::return_bank#0
    // [323] vera_address_add::return_ptr#2 = vera_address_add::return_ptr#0
    // vera_tile_area::@8
    // mapbase = vera_address_add(mapbase, y_shifted)
    // [324] vera_tile_area::mapbase_bank#1 = vera_address_add::return_bank#2
    // [325] vera_tile_area::mapbase_ptr#1 = vera_address_add::return_ptr#2
    // vera_address_add(mapbase, x_shifted)
    // [326] *((byte*)&vera_address_add::address) = vera_tile_area::mapbase_bank#1 -- _deref_pbuc1=vbuyy 
    sty.z vera_address_add.address
    // [327] *((word*)&vera_address_add::address+1) = vera_tile_area::mapbase_ptr#1 -- _deref_pwuc1=vwuz1 
    lda.z mapbase_ptr_1
    sta vera_address_add.address+1
    lda.z mapbase_ptr_1+1
    sta vera_address_add.address+1+1
    // [328] vera_address_add::inc = vera_tile_area::x_shifted#0 -- vwuz1=vwuz2 
    lda.z x_shifted
    sta.z vera_address_add.inc
    lda.z x_shifted+1
    sta.z vera_address_add.inc+1
    // [329] call vera_address_add 
    jsr vera_address_add
    // [330] vera_address_add::return_bank#3 = vera_address_add::return_bank#0
    // [331] vera_address_add::return_ptr#3 = vera_address_add::return_ptr#0
    // vera_tile_area::@9
    // mapbase = vera_address_add(mapbase, x_shifted)
    // [332] vera_tile_area::mapbase_bank#2 = vera_address_add::return_bank#3 -- vbuz1=vbuyy 
    sty.z mapbase_bank
    // [333] vera_tile_area::mapbase_ptr#2 = vera_address_add::return_ptr#3
    // [334] phi from vera_tile_area::@9 to vera_tile_area::@1 [phi:vera_tile_area::@9->vera_tile_area::@1]
    // [334] phi vera_tile_area::mapbase_ptr#10 = vera_tile_area::mapbase_ptr#2 [phi:vera_tile_area::@9->vera_tile_area::@1#0] -- register_copy 
    // [334] phi vera_tile_area::mapbase_bank#10 = vera_tile_area::mapbase_bank#2 [phi:vera_tile_area::@9->vera_tile_area::@1#1] -- register_copy 
    // [334] phi vera_tile_area::r#2 = 0 [phi:vera_tile_area::@9->vera_tile_area::@1#2] -- vbuxx=vbuc1 
    ldx #0
  // mapbase += ((word)y << shift);
  // mapbase += (x << 1);
    // vera_tile_area::@1
  __b1:
    // for(byte r=0; r<h; r++)
    // [335] if(vera_tile_area::r#2<vera_tile_area::h#10) goto vera_tile_area::vera_vram01 -- vbuxx_lt_vbuz1_then_la1 
    cpx.z h
    bcc vera_vram01
    // vera_tile_area::@return
    // }
    // [336] return 
    rts
    // vera_tile_area::vera_vram01
  vera_vram01:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [337] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <address.ptr
    // [338] vera_tile_area::vera_vram01_$0 = < vera_tile_area::mapbase_ptr#10 -- vbuaa=_lo_vwuz1 
    lda.z mapbase_ptr_1
    // *VERA_ADDRX_L = <address.ptr
    // [339] *VERA_ADDRX_L = vera_tile_area::vera_vram01_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >address.ptr
    // [340] vera_tile_area::vera_vram01_$1 = > vera_tile_area::mapbase_ptr#10 -- vbuaa=_hi_vwuz1 
    lda.z mapbase_ptr_1+1
    // *VERA_ADDRX_M = >address.ptr
    // [341] *VERA_ADDRX_M = vera_tile_area::vera_vram01_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // address.bank | incr
    // [342] vera_tile_area::vera_vram01_$2 = vera_tile_area::mapbase_bank#10 | VERA_INC_1 -- vbuaa=vbuz1_bor_vbuc1 
    lda #VERA_INC_1
    ora.z mapbase_bank
    // *VERA_ADDRX_H = address.bank | incr
    // [343] *VERA_ADDRX_H = vera_tile_area::vera_vram01_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [344] phi from vera_tile_area::vera_vram01 to vera_tile_area::@2 [phi:vera_tile_area::vera_vram01->vera_tile_area::@2]
    // [344] phi vera_tile_area::c#2 = 0 [phi:vera_tile_area::vera_vram01->vera_tile_area::@2#0] -- vbuyy=vbuc1 
    ldy #0
    // vera_tile_area::@2
  __b2:
    // for(byte c=0; c<w; c++)
    // [345] if(vera_tile_area::c#2<vera_tile_area::w#11) goto vera_tile_area::@3 -- vbuyy_lt_vbuz1_then_la1 
    cpy.z w
    bcc __b3
    // vera_tile_area::@4
    // vera_address_add(mapbase, rowskip)
    // [346] *((byte*)&vera_address_add::address) = vera_tile_area::mapbase_bank#10 -- _deref_pbuc1=vbuz1 
    lda.z mapbase_bank
    sta.z vera_address_add.address
    // [347] *((word*)&vera_address_add::address+1) = vera_tile_area::mapbase_ptr#10 -- _deref_pwuc1=vwuz1 
    lda.z mapbase_ptr_1
    sta vera_address_add.address+1
    lda.z mapbase_ptr_1+1
    sta vera_address_add.address+1+1
    // [348] vera_address_add::inc = vera_tile_area::rowskip#0 -- vwuz1=vwuz2 
    lda.z rowskip
    sta.z vera_address_add.inc
    lda.z rowskip+1
    sta.z vera_address_add.inc+1
    // [349] call vera_address_add 
    jsr vera_address_add
    // [350] vera_address_add::return_bank#4 = vera_address_add::return_bank#0
    // [351] vera_address_add::return_ptr#4 = vera_address_add::return_ptr#0
    // vera_tile_area::@10
    // mapbase = vera_address_add(mapbase, rowskip)
    // [352] vera_tile_area::mapbase_bank#3 = vera_address_add::return_bank#4 -- vbuz1=vbuyy 
    sty.z mapbase_bank
    // [353] vera_tile_area::mapbase_ptr#3 = vera_address_add::return_ptr#4
    // for(byte r=0; r<h; r++)
    // [354] vera_tile_area::r#1 = ++ vera_tile_area::r#2 -- vbuxx=_inc_vbuxx 
    inx
    // [334] phi from vera_tile_area::@10 to vera_tile_area::@1 [phi:vera_tile_area::@10->vera_tile_area::@1]
    // [334] phi vera_tile_area::mapbase_ptr#10 = vera_tile_area::mapbase_ptr#3 [phi:vera_tile_area::@10->vera_tile_area::@1#0] -- register_copy 
    // [334] phi vera_tile_area::mapbase_bank#10 = vera_tile_area::mapbase_bank#3 [phi:vera_tile_area::@10->vera_tile_area::@1#1] -- register_copy 
    // [334] phi vera_tile_area::r#2 = vera_tile_area::r#1 [phi:vera_tile_area::@10->vera_tile_area::@1#2] -- register_copy 
    jmp __b1
    // vera_tile_area::@3
  __b3:
    // *VERA_DATA0 = index_l
    // [355] *VERA_DATA0 = vera_tile_area::index_l#0 -- _deref_pbuc1=vbuz1 
    lda.z index_l
    sta VERA_DATA0
    // *VERA_DATA0 = index_h
    // [356] *VERA_DATA0 = vera_tile_area::index_h#10 -- _deref_pbuc1=vbuz1 
    lda.z index_h
    sta VERA_DATA0
    // for(byte c=0; c<w; c++)
    // [357] vera_tile_area::c#1 = ++ vera_tile_area::c#2 -- vbuyy=_inc_vbuyy 
    iny
    // [344] phi from vera_tile_area::@3 to vera_tile_area::@2 [phi:vera_tile_area::@3->vera_tile_area::@2]
    // [344] phi vera_tile_area::c#2 = vera_tile_area::c#1 [phi:vera_tile_area::@3->vera_tile_area::@2#0] -- register_copy 
    jmp __b2
}
  // cputs
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp($16) s)
cputs: {
    .label s = $16
    // [359] phi from cputs cputs::@2 to cputs::@1 [phi:cputs/cputs::@2->cputs::@1]
    // [359] phi cputs::s#9 = cputs::s#10 [phi:cputs/cputs::@2->cputs::@1#0] -- register_copy 
    // cputs::@1
  __b1:
    // while(c=*s++)
    // [360] cputs::c#1 = *cputs::s#9 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (s),y
    // [361] cputs::s#0 = ++ cputs::s#9 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [362] if(0!=cputs::c#1) goto cputs::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // cputs::@return
    // }
    // [363] return 
    rts
    // cputs::@2
  __b2:
    // cputc(c)
    // [364] cputc::c#0 = cputs::c#1 -- vbuz1=vbuaa 
    sta.z cputc.c
    // [365] call cputc 
    jsr cputc
    jmp __b1
}
  // kbhit
// Return true if there's a key waiting, return false if not
kbhit: {
    .label chptr = ch
    .label IN_DEV = $28a
    // Current input device number
    .label GETIN = $ffe4
    .label ch = $2b
    // char ch = 0
    // [366] kbhit::ch = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z ch
    // kickasm
    // kickasm( uses kbhit::chptr uses kbhit::IN_DEV uses kbhit::GETIN) {{ jsr _kbhit         bne L3          jmp continue1          .var via1 = $9f60                  //VIA#1         .var d1pra = via1+1      _kbhit:         ldy     d1pra       // The count of keys pressed is stored in RAM bank 0.         stz     d1pra       // Set d1pra to zero to access RAM bank 0.         lda     $A00A       // Get number of characters from this address in the ROM of the CX16 (ROM 38).         sty     d1pra       // Set d1pra to previous value.         rts      L3:         ldy     IN_DEV          // Save current input device         stz     IN_DEV          // Keyboard         phy         jsr     GETIN           // Read char, and return in .A         ply         sta     chptr           // Store the character read in ch         sty     IN_DEV          // Restore input device         ldx     #>$0000         rts      continue1:         nop       }}
    // CBM GETIN API
    jsr _kbhit
        bne L3

        jmp continue1

        .var via1 = $9f60                  //VIA#1
        .var d1pra = via1+1

    _kbhit:
        ldy     d1pra       // The count of keys pressed is stored in RAM bank 0.
        stz     d1pra       // Set d1pra to zero to access RAM bank 0.
        lda     $A00A       // Get number of characters from this address in the ROM of the CX16 (ROM 38).
        sty     d1pra       // Set d1pra to previous value.
        rts

    L3:
        ldy     IN_DEV          // Save current input device
        stz     IN_DEV          // Keyboard
        phy
        jsr     GETIN           // Read char, and return in .A
        ply
        sta     chptr           // Store the character read in ch
        sty     IN_DEV          // Restore input device
        ldx     #>$0000
        rts

    continue1:
        nop
     
    // return ch;
    // [368] kbhit::return#0 = kbhit::ch -- vbuaa=vbuz1 
    // kbhit::@return
    // }
    // [369] kbhit::return#1 = kbhit::return#0
    // [370] return 
    rts
}
  // vera_layer_set_text_color_mode
// Set the configuration of the layer text color mode.
// - layer: Value of 0 or 1.
// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
vera_layer_set_text_color_mode: {
    .label addr = $1a
    // byte* addr = vera_layer_config[layer]
    // [371] vera_layer_set_text_color_mode::addr#0 = *(vera_layer_config+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr &= ~VERA_LAYER_CONFIG_256C
    // [372] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 & ~VERA_LAYER_CONFIG_256C -- _deref_pbuz1=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C^$ff
    ldy #0
    and (addr),y
    sta (addr),y
    // *addr |= color_mode
    // [373] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 -- _deref_pbuz1=_deref_pbuz1 
    lda (addr),y
    sta (addr),y
    // vera_layer_set_text_color_mode::@return
    // }
    // [374] return 
    rts
}
  // vera_layer_get_mapbase_bank
// Get the map base bank of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Bank in vera vram.
// vera_layer_get_mapbase_bank(byte register(X) layer)
vera_layer_get_mapbase_bank: {
    // return vera_mapbase_bank[layer];
    // [376] vera_layer_get_mapbase_bank::return#0 = vera_mapbase_bank[vera_layer_get_mapbase_bank::layer#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_mapbase_bank,x
    // vera_layer_get_mapbase_bank::@return
    // }
    // [377] return 
    rts
}
  // vera_layer_get_mapbase_offset
// Get the map base lower 16-bit address (offset) of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Offset in vera vram of the specified bank.
// vera_layer_get_mapbase_offset(byte register(A) layer)
vera_layer_get_mapbase_offset: {
    .label return = $1a
    // return vera_mapbase_offset[layer];
    // [379] vera_layer_get_mapbase_offset::$0 = vera_layer_get_mapbase_offset::layer#2 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [380] vera_layer_get_mapbase_offset::return#0 = vera_mapbase_offset[vera_layer_get_mapbase_offset::$0] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda vera_mapbase_offset,y
    sta.z return
    lda vera_mapbase_offset+1,y
    sta.z return+1
    // vera_layer_get_mapbase_offset::@return
    // }
    // [381] return 
    rts
}
  // vera_layer_get_rowshift
// Get the bit shift value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
vera_layer_get_rowshift: {
    // return vera_layer_rowshift[layer];
    // [382] vera_layer_get_rowshift::return#0 = *(vera_layer_rowshift+screenlayer::layer#0) -- vbuaa=_deref_pbuc1 
    lda vera_layer_rowshift+screenlayer.layer
    // vera_layer_get_rowshift::@return
    // }
    // [383] return 
    rts
}
  // vera_layer_get_rowskip
// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
vera_layer_get_rowskip: {
    .label return = $1a
    // return vera_layer_rowskip[layer];
    // [384] vera_layer_get_rowskip::return#0 = *(vera_layer_rowskip+screenlayer::layer#0*SIZEOF_WORD) -- vwuz1=_deref_pwuc1 
    lda vera_layer_rowskip+screenlayer.layer*SIZEOF_WORD
    sta.z return
    lda vera_layer_rowskip+screenlayer.layer*SIZEOF_WORD+1
    sta.z return+1
    // vera_layer_get_rowskip::@return
    // }
    // [385] return 
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
    // [386] vera_layer_get_backcolor::return#0 = vera_layer_backcolor[vera_layer_get_backcolor::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_backcolor,x
    // vera_layer_get_backcolor::@return
    // }
    // [387] return 
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
    // [388] vera_layer_get_textcolor::return#0 = vera_layer_textcolor[vera_layer_get_textcolor::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_textcolor,x
    // vera_layer_get_textcolor::@return
    // }
    // [389] return 
    rts
}
  // vera_layer_set_config
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
// vera_layer_set_config(byte register(A) layer, byte register(X) config)
vera_layer_set_config: {
    .label addr = $1a
    // byte* addr = vera_layer_config[layer]
    // [390] vera_layer_set_config::$0 = vera_layer_set_config::layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [391] vera_layer_set_config::addr#0 = vera_layer_config[vera_layer_set_config::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr = config
    // [392] *vera_layer_set_config::addr#0 = vera_layer_set_config::config#0 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_config::@return
    // }
    // [393] return 
    rts
}
  // vera_layer_set_tilebase
// Set the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - tilebase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// vera_layer_set_tilebase(byte register(A) layer, byte register(X) tilebase)
vera_layer_set_tilebase: {
    .label addr = $1a
    // byte* addr = vera_layer_tilebase[layer]
    // [394] vera_layer_set_tilebase::$0 = vera_layer_set_tilebase::layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [395] vera_layer_set_tilebase::addr#0 = vera_layer_tilebase[vera_layer_set_tilebase::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_tilebase,y
    sta.z addr
    lda vera_layer_tilebase+1,y
    sta.z addr+1
    // *addr = tilebase
    // [396] *vera_layer_set_tilebase::addr#0 = vera_layer_set_tilebase::tilebase#0 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_tilebase::@return
    // }
    // [397] return 
    rts
}
  // vera_layer_get_mapbase_address
// Get the map base address of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Specifies the map base address of the layer, which is returned as a dword.
//   Note that the register only specifies bits 16:9 of the 17 bit address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes!
vera_layer_get_mapbase_address: {
    .label return_ptr = $2e
    // return vera_mapbase_address[layer];
    // [398] vera_layer_get_mapbase_address::return_bank#0 = *((byte*)vera_mapbase_address) -- vbuxx=_deref_pbuc1 
    ldx vera_mapbase_address
    // [399] vera_layer_get_mapbase_address::return_ptr#0 = *((word*)vera_mapbase_address+1) -- vwuz1=_deref_pwuc1 
    lda vera_mapbase_address+1
    sta.z return_ptr
    lda vera_mapbase_address+1+1
    sta.z return_ptr+1
    // vera_layer_get_mapbase_address::@return
    // }
    // [400] return 
    rts
}
  // vera_address_add
// vera_address_add(struct $0 zp($34) address, word zp($28) inc)
vera_address_add: {
    .label address = $34
    .label inc = $28
    .label result = $37
    .label return_ptr = $16
    // vera_address result
    // [401] *(&vera_address_add::result) = memset(struct $0, 3) -- _deref_pssc1=_memset_vbuc2 
    ldy #3
    lda #0
  !:
    dey
    sta result,y
    bne !-
    // kickasm
    // kickasm( uses vera_address_add::address uses vera_address_add::inc uses vera_address_add::result) {{ lda address.ptr         clc         adc inc         sta result.ptr         lda address.ptr+1         adc inc+1         sta result.ptr+1         lda address.bank         adc #0         sta result.bank      }}
    lda address.ptr
        clc
        adc inc
        sta result.ptr
        lda address.ptr+1
        adc inc+1
        sta result.ptr+1
        lda address.bank
        adc #0
        sta result.bank
    
    // return result;
    // [403] vera_address_add::return_bank#0 = *((byte*)&vera_address_add::result) -- vbuyy=_deref_pbuc1 
    ldy.z result
    // [404] vera_address_add::return_ptr#0 = *((word*)&vera_address_add::result+1) -- vwuz1=_deref_pwuc1 
    lda result+1
    sta.z return_ptr
    lda result+1+1
    sta.z return_ptr+1
    // vera_address_add::@return
    // }
    // [405] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($2a) c)
cputc: {
    .label __16 = $2e
    .label conio_screen_text = $18
    .label conio_map_width = $2c
    .label conio_addr = $18
    .label c = $2a
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [406] vera_layer_get_color::layer#0 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [407] call vera_layer_get_color 
    // [439] phi from cputc to vera_layer_get_color [phi:cputc->vera_layer_get_color]
    // [439] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#0 [phi:cputc->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [408] vera_layer_get_color::return#3 = vera_layer_get_color::return#2
    // cputc::@7
    // char color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [409] cputc::color#0 = vera_layer_get_color::return#3 -- vbuxx=vbuaa 
    tax
    // char* conio_screen_text = cx16_conio.conio_screen_text
    // [410] cputc::conio_screen_text#0 = *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- pbuz1=_deref_qbuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z conio_screen_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z conio_screen_text+1
    // word conio_map_width = cx16_conio.conio_map_width
    // [411] cputc::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [412] cputc::$15 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // char* conio_addr = conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [413] cputc::conio_addr#0 = cputc::conio_screen_text#0 + conio_line_text[cputc::$15] -- pbuz1=pbuz1_plus_pwuc1_derefidx_vbuaa 
    tay
    clc
    lda.z conio_addr
    adc conio_line_text,y
    sta.z conio_addr
    lda.z conio_addr+1
    adc conio_line_text+1,y
    sta.z conio_addr+1
    // conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [414] cputc::$2 = conio_cursor_x[*((byte*)&cx16_conio)] << 1 -- vbuaa=pbuc1_derefidx_(_deref_pbuc2)_rol_1 
    ldy cx16_conio
    lda conio_cursor_x,y
    asl
    // conio_addr += conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [415] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$2 -- pbuz1=pbuz1_plus_vbuaa 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [416] if(cputc::c#0==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [417] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <conio_addr
    // [418] cputc::$4 = < cputc::conio_addr#1 -- vbuaa=_lo_pbuz1 
    lda.z conio_addr
    // *VERA_ADDRX_L = <conio_addr
    // [419] *VERA_ADDRX_L = cputc::$4 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >conio_addr
    // [420] cputc::$5 = > cputc::conio_addr#1 -- vbuaa=_hi_pbuz1 
    lda.z conio_addr+1
    // *VERA_ADDRX_M = >conio_addr
    // [421] *VERA_ADDRX_M = cputc::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [422] cputc::$6 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [423] *VERA_ADDRX_H = cputc::$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [424] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [425] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // conio_cursor_x[cx16_conio.conio_screen_layer]++;
    // [426] conio_cursor_x[*((byte*)&cx16_conio)] = ++ conio_cursor_x[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    ldy cx16_conio
    lda conio_cursor_x,x
    inc
    sta conio_cursor_x,y
    // byte scroll_enable = conio_scroll_enable[cx16_conio.conio_screen_layer]
    // [427] cputc::scroll_enable#0 = conio_scroll_enable[*((byte*)&cx16_conio)] -- vbuaa=pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_scroll_enable,y
    // if(scroll_enable)
    // [428] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b5
    // cputc::@3
    // (unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width
    // [429] cputc::$16 = (word)conio_cursor_x[*((byte*)&cx16_conio)] -- vwuz1=_word_pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_cursor_x,y
    sta.z __16
    lda #0
    sta.z __16+1
    // if((unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width)
    // [430] if(cputc::$16!=cputc::conio_map_width#0) goto cputc::@return -- vwuz1_neq_vwuz2_then_la1 
    cmp.z conio_map_width+1
    bne __breturn
    lda.z __16
    cmp.z conio_map_width
    bne __breturn
    // [431] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [432] call cputln 
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [433] return 
    rts
    // cputc::@5
  __b5:
    // if(conio_cursor_x[cx16_conio.conio_screen_layer] == cx16_conio.conio_screen_width)
    // [434] if(conio_cursor_x[*((byte*)&cx16_conio)]!=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto cputc::@return -- pbuc1_derefidx_(_deref_pbuc2)_neq__deref_pbuc3_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    ldy cx16_conio
    cmp conio_cursor_x,y
    bne __breturn
    // [435] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [436] call cputln 
    jsr cputln
    rts
    // [437] phi from cputc::@7 to cputc::@1 [phi:cputc::@7->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [438] call cputln 
    jsr cputln
    rts
}
  // vera_layer_get_color
// Get the text and back color for text output in 16 color mode.
// - layer: Value of 0 or 1.
// - return: an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_get_color(byte register(X) layer)
vera_layer_get_color: {
    .label addr = $30
    // byte* addr = vera_layer_config[layer]
    // [440] vera_layer_get_color::$3 = vera_layer_get_color::layer#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [441] vera_layer_get_color::addr#0 = vera_layer_config[vera_layer_get_color::$3] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr & VERA_LAYER_CONFIG_256C
    // [442] vera_layer_get_color::$0 = *vera_layer_get_color::addr#0 & VERA_LAYER_CONFIG_256C -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C
    ldy #0
    and (addr),y
    // if( *addr & VERA_LAYER_CONFIG_256C )
    // [443] if(0!=vera_layer_get_color::$0) goto vera_layer_get_color::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // vera_layer_get_color::@2
    // vera_layer_backcolor[layer] << 4
    // [444] vera_layer_get_color::$1 = vera_layer_backcolor[vera_layer_get_color::layer#2] << 4 -- vbuaa=pbuc1_derefidx_vbuxx_rol_4 
    lda vera_layer_backcolor,x
    asl
    asl
    asl
    asl
    // return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
    // [445] vera_layer_get_color::return#1 = vera_layer_get_color::$1 | vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuaa=vbuaa_bor_pbuc1_derefidx_vbuxx 
    ora vera_layer_textcolor,x
    // [446] phi from vera_layer_get_color::@1 vera_layer_get_color::@2 to vera_layer_get_color::@return [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return]
    // [446] phi vera_layer_get_color::return#2 = vera_layer_get_color::return#0 [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return#0] -- register_copy 
    // vera_layer_get_color::@return
    // }
    // [447] return 
    rts
    // vera_layer_get_color::@1
  __b1:
    // return (vera_layer_textcolor[layer]);
    // [448] vera_layer_get_color::return#0 = vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_textcolor,x
    rts
}
  // cputln
// Print a newline
cputln: {
    .label temp = $30
    // word temp = conio_line_text[cx16_conio.conio_screen_layer]
    // [449] cputln::$2 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // [450] cputln::temp#0 = conio_line_text[cputln::$2] -- vwuz1=pwuc1_derefidx_vbuaa 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda conio_line_text,y
    sta.z temp
    lda conio_line_text+1,y
    sta.z temp+1
    // temp += cx16_conio.conio_rowskip
    // [451] cputln::temp#1 = cputln::temp#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z temp
    sta.z temp
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z temp+1
    sta.z temp+1
    // conio_line_text[cx16_conio.conio_screen_layer] = temp
    // [452] cputln::$3 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // [453] conio_line_text[cputln::$3] = cputln::temp#1 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z temp
    sta conio_line_text,y
    lda.z temp+1
    sta conio_line_text+1,y
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [454] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer]++;
    // [455] conio_cursor_y[*((byte*)&cx16_conio)] = ++ conio_cursor_y[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    lda conio_cursor_y,x
    inc
    sta conio_cursor_y,y
    // cscroll()
    // [456] call cscroll 
    jsr cscroll
    // cputln::@return
    // }
    // [457] return 
    rts
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>cx16_conio.conio_screen_height)
    // [458] if(conio_cursor_y[*((byte*)&cx16_conio)]<=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_le__deref_pbuc3_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    ldy cx16_conio
    cmp conio_cursor_y,y
    bcs __b3
    // cscroll::@1
    // if(conio_scroll_enable[cx16_conio.conio_screen_layer])
    // [459] if(0!=conio_scroll_enable[*((byte*)&cx16_conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    lda conio_scroll_enable,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [460] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    // [461] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
  __b3:
    // cscroll::@return
    // }
    // [462] return 
    rts
    // [463] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [464] call insertup 
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, cx16_conio.conio_screen_height-1)
    // [465] gotoxy::y#2 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuxx=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    // [466] call gotoxy 
    // [159] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [159] phi gotoxy::y#4 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    jsr gotoxy
    rts
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label cy = $32
    .label width = $33
    .label line = 4
    .label start = 4
    // unsigned byte cy = conio_cursor_y[cx16_conio.conio_screen_layer]
    // [467] insertup::cy#0 = conio_cursor_y[*((byte*)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy cx16_conio
    lda conio_cursor_y,y
    sta.z cy
    // unsigned byte width = cx16_conio.conio_screen_width * 2
    // [468] insertup::width#0 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    asl
    sta.z width
    // [469] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [469] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuxx=vbuc1 
    ldx #1
    // insertup::@1
  __b1:
    // for(unsigned byte i=1; i<=cy; i++)
    // [470] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuxx_le_vbuz1_then_la1 
    lda.z cy
    stx.z $ff
    cmp.z $ff
    bcs __b2
    // [471] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [472] call clearline 
    jsr clearline
    // insertup::@return
    // }
    // [473] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [474] insertup::$3 = insertup::i#2 - 1 -- vbuaa=vbuxx_minus_1 
    txa
    sec
    sbc #1
    // unsigned int line = (i-1) << cx16_conio.conio_rowshift
    // [475] insertup::line#0 = insertup::$3 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vbuaa_rol__deref_pbuc1 
    ldy cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
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
    // unsigned char* start = cx16_conio.conio_screen_text + line
    // [476] insertup::start#0 = *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) + insertup::line#0 -- pbuz1=_deref_qbuc1_plus_vwuz1 
    clc
    lda.z start
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z start
    lda.z start+1
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z start+1
    // cx16_cpy_vram_from_vram_inc(0, start, VERA_INC_1, 0, start+cx16_conio.conio_rowskip, VERA_INC_1,  width)
    // [477] cx16_cpy_vram_from_vram_inc::sptr_vram#0 = insertup::start#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- pbuz1=pbuz2_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z start
    sta.z cx16_cpy_vram_from_vram_inc.sptr_vram
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z start+1
    sta.z cx16_cpy_vram_from_vram_inc.sptr_vram+1
    // [478] cx16_cpy_vram_from_vram_inc::dptr_vram#0 = insertup::start#0
    // [479] cx16_cpy_vram_from_vram_inc::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z cx16_cpy_vram_from_vram_inc.num
    lda #0
    sta.z cx16_cpy_vram_from_vram_inc.num+1
    // [480] call cx16_cpy_vram_from_vram_inc 
    jsr cx16_cpy_vram_from_vram_inc
    // insertup::@4
    // for(unsigned byte i=1; i<=cy; i++)
    // [481] insertup::i#1 = ++ insertup::i#2 -- vbuxx=_inc_vbuxx 
    inx
    // [469] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [469] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
}
  // clearline
clearline: {
    .label conio_line = $18
    .label addr = $18
    .label c = $18
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [482] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // word conio_line = conio_line_text[cx16_conio.conio_screen_layer]
    // [483] clearline::$5 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // [484] clearline::conio_line#0 = conio_line_text[clearline::$5] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda conio_line_text,y
    sta.z conio_line
    lda conio_line_text+1,y
    sta.z conio_line+1
    // conio_screen_text + conio_line
    // [485] clearline::addr#0 = (word)*((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) + clearline::conio_line#0 -- vwuz1=_deref_pwuc1_plus_vwuz1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    adc.z addr
    sta.z addr
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    adc.z addr+1
    sta.z addr+1
    // <addr
    // [486] clearline::$1 = < (byte*)clearline::addr#0 -- vbuaa=_lo_pbuz1 
    lda.z addr
    // *VERA_ADDRX_L = <addr
    // [487] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >addr
    // [488] clearline::$2 = > (byte*)clearline::addr#0 -- vbuaa=_hi_pbuz1 
    lda.z addr+1
    // *VERA_ADDRX_M = >addr
    // [489] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [490] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [491] vera_layer_get_color::layer#1 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [492] call vera_layer_get_color 
    // [439] phi from clearline to vera_layer_get_color [phi:clearline->vera_layer_get_color]
    // [439] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#1 [phi:clearline->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [493] vera_layer_get_color::return#4 = vera_layer_get_color::return#2
    // clearline::@4
    // char color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [494] clearline::color#0 = vera_layer_get_color::return#4 -- vbuxx=vbuaa 
    tax
    // [495] phi from clearline::@4 to clearline::@1 [phi:clearline::@4->clearline::@1]
    // [495] phi clearline::c#2 = 0 [phi:clearline::@4->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [496] if(clearline::c#2<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto clearline::@2 -- vwuz1_lt__deref_pbuc1_then_la1 
    ldy cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    lda.z c+1
    bne !+
    sty.z $ff
    lda.z c
    cmp.z $ff
    bcc __b2
  !:
    // clearline::@3
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [497] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // clearline::@return
    // }
    // [498] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [499] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [500] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [501] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [495] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [495] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
    jmp __b1
}
  // cx16_cpy_vram_from_vram_inc
// Copy block of memory (from VRAM to VRAM)
// Copies the values from the location pointed by src to the location pointed by dest.
// The method uses the VERA access ports 0 and 1 to copy data from and to in VRAM.
// - dbank_vram:  64K VRAM bank number to copy to (0/1).
// - dptr_vram: pointer to the location to copy to. Note that the address is a 16 bit value!
// - dinc: the increment indicator, VERA needs this because addressing increment is automated by VERA at each access.
// - sbank_vram:  64K VRAM bank number to copy from (0/1).
// - sptr_vram: pointer to the location to copy from. Note that the address is a 16 bit value!
// - sinc: the increment indicator, VERA needs this because addressing increment is automated by VERA at each access.
// - num: The number of bytes to copy
// cx16_cpy_vram_from_vram_inc(byte* zp(4) dptr_vram, byte* zp($18) sptr_vram, word zp($c) num)
cx16_cpy_vram_from_vram_inc: {
    .label i = $18
    .label dptr_vram = 4
    .label sptr_vram = $18
    .label num = $c
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [502] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <sptr_vram
    // [503] cx16_cpy_vram_from_vram_inc::$0 = < cx16_cpy_vram_from_vram_inc::sptr_vram#0 -- vbuaa=_lo_pbuz1 
    lda.z sptr_vram
    // *VERA_ADDRX_L = <sptr_vram
    // [504] *VERA_ADDRX_L = cx16_cpy_vram_from_vram_inc::$0 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >sptr_vram
    // [505] cx16_cpy_vram_from_vram_inc::$1 = > cx16_cpy_vram_from_vram_inc::sptr_vram#0 -- vbuaa=_hi_pbuz1 
    lda.z sptr_vram+1
    // *VERA_ADDRX_M = >sptr_vram
    // [506] *VERA_ADDRX_M = cx16_cpy_vram_from_vram_inc::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = sinc | sbank_vram
    // [507] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [508] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    // Select DATA1
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // <dptr_vram
    // [509] cx16_cpy_vram_from_vram_inc::$3 = < cx16_cpy_vram_from_vram_inc::dptr_vram#0 -- vbuaa=_lo_pbuz1 
    lda.z dptr_vram
    // *VERA_ADDRX_L = <dptr_vram
    // [510] *VERA_ADDRX_L = cx16_cpy_vram_from_vram_inc::$3 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >dptr_vram
    // [511] cx16_cpy_vram_from_vram_inc::$4 = > cx16_cpy_vram_from_vram_inc::dptr_vram#0 -- vbuaa=_hi_pbuz1 
    lda.z dptr_vram+1
    // *VERA_ADDRX_M = >dptr_vram
    // [512] *VERA_ADDRX_M = cx16_cpy_vram_from_vram_inc::$4 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = dinc | dbank_vram
    // [513] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // [514] phi from cx16_cpy_vram_from_vram_inc to cx16_cpy_vram_from_vram_inc::@1 [phi:cx16_cpy_vram_from_vram_inc->cx16_cpy_vram_from_vram_inc::@1]
    // [514] phi cx16_cpy_vram_from_vram_inc::i#2 = 0 [phi:cx16_cpy_vram_from_vram_inc->cx16_cpy_vram_from_vram_inc::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // cx16_cpy_vram_from_vram_inc::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [515] if(cx16_cpy_vram_from_vram_inc::i#2<cx16_cpy_vram_from_vram_inc::num#0) goto cx16_cpy_vram_from_vram_inc::@2 -- vwuz1_lt_vwuz2_then_la1 
    lda.z i+1
    cmp.z num+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z num
    bcc __b2
  !:
    // cx16_cpy_vram_from_vram_inc::@return
    // }
    // [516] return 
    rts
    // cx16_cpy_vram_from_vram_inc::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [517] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [518] cx16_cpy_vram_from_vram_inc::i#1 = ++ cx16_cpy_vram_from_vram_inc::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [514] phi from cx16_cpy_vram_from_vram_inc::@2 to cx16_cpy_vram_from_vram_inc::@1 [phi:cx16_cpy_vram_from_vram_inc::@2->cx16_cpy_vram_from_vram_inc::@1]
    // [514] phi cx16_cpy_vram_from_vram_inc::i#2 = cx16_cpy_vram_from_vram_inc::i#1 [phi:cx16_cpy_vram_from_vram_inc::@2->cx16_cpy_vram_from_vram_inc::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment Data
  VERA_LAYER_WIDTH: .word $20, $40, $80, $100
  VERA_LAYER_HEIGHT: .word $20, $40, $80, $100
  // Author: Sven Van de Velde
  vera_mapbase_offset: .word 0, 0
  vera_mapbase_bank: .byte 0, 0
  vera_tilebase_offset: .word 0, 0
  vera_tilebase_bank: .byte 0, 0
  vera_layer_rowshift: .byte 0, 0
  vera_layer_rowskip: .word 0, 0
  vera_layer_hflip: .byte 0, 4
  vera_layer_vflip: .byte 0, 8
  vera_layer_config: .word VERA_L0_CONFIG, VERA_L1_CONFIG
  vera_layer_enable: .byte VERA_LAYER0_ENABLE, VERA_LAYER1_ENABLE
  vera_layer_mapbase: .word VERA_L0_MAPBASE, VERA_L1_MAPBASE
  vera_layer_tilebase: .word VERA_L0_TILEBASE, VERA_L1_TILEBASE
  vera_layer_textcolor: .byte WHITE, WHITE
  vera_layer_backcolor: .byte BLUE, BLUE
  // The current cursor x-position
  conio_cursor_x: .byte 0, 0
  // The current cursor y-position
  conio_cursor_y: .byte 0, 0
  // The current text cursor line start
  conio_line_text: .word 0, 0
  // Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
  // If disabled the cursor just moves back to (0,0) instead
  conio_scroll_enable: .byte 1, 1
  cx16_conio: .fill SIZEOF_STRUCT_CX16_CONIO, 0
