  // File Comments
// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="tilemap_4bpp_16_x_16.prg", type="prg", segments="Program"]
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
  .const vera_inc_1 = $10
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
    .label line = 2
    // char line = *BASIC_CURSOR_LINE
    // [6] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda BASIC_CURSOR_LINE
    sta.z line
    // vera_layer_mode_text(1,(dword)0x00000,(dword)0x0F800,128,64,8,8,16)
    // [7] call vera_layer_mode_text 
    // [117] phi from conio_x16_init to vera_layer_mode_text [phi:conio_x16_init->vera_layer_mode_text]
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
    // [155] phi from conio_x16_init::@5 to vera_layer_set_textcolor [phi:conio_x16_init::@5->vera_layer_set_textcolor]
    // [155] phi vera_layer_set_textcolor::layer#2 = 1 [phi:conio_x16_init::@5->vera_layer_set_textcolor#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_set_textcolor.layer
    jsr vera_layer_set_textcolor
    // [14] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // vera_layer_set_backcolor(1, BLUE)
    // [15] call vera_layer_set_backcolor 
    // [158] phi from conio_x16_init::@6 to vera_layer_set_backcolor [phi:conio_x16_init::@6->vera_layer_set_backcolor]
    // [158] phi vera_layer_set_backcolor::color#2 = BLUE [phi:conio_x16_init::@6->vera_layer_set_backcolor#0] -- vbuz1=vbuc1 
    lda #BLUE
    sta.z vera_layer_set_backcolor.color
    // [158] phi vera_layer_set_backcolor::layer#2 = 1 [phi:conio_x16_init::@6->vera_layer_set_backcolor#1] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_set_backcolor.layer
    jsr vera_layer_set_backcolor
    // [16] phi from conio_x16_init::@6 to conio_x16_init::@7 [phi:conio_x16_init::@6->conio_x16_init::@7]
    // conio_x16_init::@7
    // vera_layer_set_mapbase(0,0x20)
    // [17] call vera_layer_set_mapbase 
    // [161] phi from conio_x16_init::@7 to vera_layer_set_mapbase [phi:conio_x16_init::@7->vera_layer_set_mapbase]
    // [161] phi vera_layer_set_mapbase::mapbase#3 = $20 [phi:conio_x16_init::@7->vera_layer_set_mapbase#0] -- vbuz1=vbuc1 
    lda #$20
    sta.z vera_layer_set_mapbase.mapbase
    // [161] phi vera_layer_set_mapbase::layer#3 = 0 [phi:conio_x16_init::@7->vera_layer_set_mapbase#1] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_set_mapbase.layer
    jsr vera_layer_set_mapbase
    // [18] phi from conio_x16_init::@7 to conio_x16_init::@8 [phi:conio_x16_init::@7->conio_x16_init::@8]
    // conio_x16_init::@8
    // vera_layer_set_mapbase(1,0x00)
    // [19] call vera_layer_set_mapbase 
    // [161] phi from conio_x16_init::@8 to vera_layer_set_mapbase [phi:conio_x16_init::@8->vera_layer_set_mapbase]
    // [161] phi vera_layer_set_mapbase::mapbase#3 = 0 [phi:conio_x16_init::@8->vera_layer_set_mapbase#0] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_set_mapbase.mapbase
    // [161] phi vera_layer_set_mapbase::layer#3 = 1 [phi:conio_x16_init::@8->vera_layer_set_mapbase#1] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_set_mapbase.layer
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
    // [25] gotoxy::y#1 = conio_x16_init::line#3
    // [26] call gotoxy 
    // [168] phi from conio_x16_init::@1 to gotoxy [phi:conio_x16_init::@1->gotoxy]
    // [168] phi gotoxy::y#4 = gotoxy::y#1 [phi:conio_x16_init::@1->gotoxy#0] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [27] return 
    rts
}
  // main
main: {
    .label __25 = $25
    .label __30 = $26
    .label column = 3
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label tile = 5
    .label c = 4
    .label column_1 = 7
    .label c1 = 8
    .label column_2 = 9
    .label c2 = $a
    .label column_3 = $d
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label tile_1 = $b
    .label c3 = $e
    .label column1 = $13
    .label c4 = $15
    .label offset = $14
    .label row = $f
    .label r = $10
    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    .label tile_2 = $11
    // textcolor(WHITE)
    // [29] call textcolor 
    jsr textcolor
    // [30] phi from main to main::@12 [phi:main->main::@12]
    // main::@12
    // bgcolor(BLACK)
    // [31] call bgcolor 
    jsr bgcolor
    // [32] phi from main::@12 to main::@13 [phi:main::@12->main::@13]
    // main::@13
    // clrscr()
    // [33] call clrscr 
    jsr clrscr
    // [34] phi from main::@13 to main::@14 [phi:main::@13->main::@14]
    // main::@14
    // vera_layer_mode_tile(0, 0x04000, 0x14000, 128, 128, 16, 16, 4)
    // [35] call vera_layer_mode_tile 
    // [221] phi from main::@14 to vera_layer_mode_tile [phi:main::@14->vera_layer_mode_tile]
    // [221] phi vera_layer_mode_tile::tileheight#10 = $10 [phi:main::@14->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #$10
    sta.z vera_layer_mode_tile.tileheight
    // [221] phi vera_layer_mode_tile::tilewidth#10 = $10 [phi:main::@14->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [221] phi vera_layer_mode_tile::tilebase_address#10 = $14000 [phi:main::@14->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$14000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$14000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$14000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$14000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [221] phi vera_layer_mode_tile::mapbase_address#10 = $4000 [phi:main::@14->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$4000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$4000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$4000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$4000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [221] phi vera_layer_mode_tile::mapheight#10 = $80 [phi:main::@14->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapheight
    lda #>$80
    sta.z vera_layer_mode_tile.mapheight+1
    // [221] phi vera_layer_mode_tile::layer#10 = 0 [phi:main::@14->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.layer
    // [221] phi vera_layer_mode_tile::mapwidth#10 = $80 [phi:main::@14->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [221] phi vera_layer_mode_tile::color_depth#2 = 4 [phi:main::@14->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // [36] phi from main::@14 to main::@15 [phi:main::@14->main::@15]
    // main::@15
    // cx16_cpy_vram_from_ram(1, 0x4000, tiles, 2048)
    // [37] call cx16_cpy_vram_from_ram 
    // [293] phi from main::@15 to cx16_cpy_vram_from_ram [phi:main::@15->cx16_cpy_vram_from_ram]
    jsr cx16_cpy_vram_from_ram
    // [38] phi from main::@15 to main::@16 [phi:main::@15->main::@16]
    // main::@16
    // vera_tile_area(0, 0, 0, 0, 40, 30, 0, 0, 0)
    // [39] call vera_tile_area 
  //vera_tile_area(byte layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset)
    // [303] phi from main::@16 to vera_tile_area [phi:main::@16->vera_tile_area]
    // [303] phi vera_tile_area::w#13 = $28 [phi:main::@16->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #$28
    sta.z vera_tile_area.w
    // [303] phi vera_tile_area::h#7 = $1e [phi:main::@16->vera_tile_area#1] -- vbuz1=vbuc1 
    lda #$1e
    sta.z vera_tile_area.h
    // [303] phi vera_tile_area::x#6 = 0 [phi:main::@16->vera_tile_area#2] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.x
    // [303] phi vera_tile_area::y#6 = 0 [phi:main::@16->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [303] phi vera_tile_area::tileindex#6 = 0 [phi:main::@16->vera_tile_area#4] -- vwuz1=vbuc1 
    sta.z vera_tile_area.tileindex
    sta.z vera_tile_area.tileindex+1
    // [303] phi vera_tile_area::offset#7 = 0 [phi:main::@16->vera_tile_area#5] -- vbuz1=vbuc1 
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // [40] phi from main::@16 to main::@1 [phi:main::@16->main::@1]
    // [40] phi main::c#2 = 0 [phi:main::@16->main::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // [40] phi main::column#8 = 1 [phi:main::@16->main::@1#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column
    // [40] phi main::tile#10 = 0 [phi:main::@16->main::@1#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z tile
    sta.z tile+1
    // [40] phi from main::@17 to main::@1 [phi:main::@17->main::@1]
    // [40] phi main::c#2 = main::c#1 [phi:main::@17->main::@1#0] -- register_copy 
    // [40] phi main::column#8 = main::column#1 [phi:main::@17->main::@1#1] -- register_copy 
    // [40] phi main::tile#10 = main::tile#2 [phi:main::@17->main::@1#2] -- register_copy 
    // main::@1
  __b1:
    // vera_tile_area(0, tile, column, 1, 1, 1, 0, 0, 0)
    // [41] vera_tile_area::tileindex#1 = main::tile#10 -- vwuz1=vwuz2 
    lda.z tile
    sta.z vera_tile_area.tileindex
    lda.z tile+1
    sta.z vera_tile_area.tileindex+1
    // [42] vera_tile_area::x#1 = main::column#8 -- vbuz1=vbuz2 
    lda.z column
    sta.z vera_tile_area.x
    // [43] call vera_tile_area 
    // [303] phi from main::@1 to vera_tile_area [phi:main::@1->vera_tile_area]
    // [303] phi vera_tile_area::w#13 = 1 [phi:main::@1->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [303] phi vera_tile_area::h#7 = 1 [phi:main::@1->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [303] phi vera_tile_area::x#6 = vera_tile_area::x#1 [phi:main::@1->vera_tile_area#2] -- register_copy 
    // [303] phi vera_tile_area::y#6 = 1 [phi:main::@1->vera_tile_area#3] -- vbuz1=vbuc1 
    sta.z vera_tile_area.y
    // [303] phi vera_tile_area::tileindex#6 = vera_tile_area::tileindex#1 [phi:main::@1->vera_tile_area#4] -- register_copy 
    // [303] phi vera_tile_area::offset#7 = 0 [phi:main::@1->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // main::@17
    // column+=4
    // [44] main::column#1 = main::column#8 + 4 -- vbuz1=vbuz1_plus_vbuc1 
    lda #4
    clc
    adc.z column
    sta.z column
    // tile++;
    // [45] main::tile#2 = ++ main::tile#10 -- vwuz1=_inc_vwuz1 
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // for(byte c:0..7)
    // [46] main::c#1 = ++ main::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [47] if(main::c#1!=8) goto main::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z c
    bne __b1
    // [48] phi from main::@17 to main::@2 [phi:main::@17->main::@2]
    // [48] phi main::c1#2 = 0 [phi:main::@17->main::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c1
    // [48] phi main::column#10 = 1 [phi:main::@17->main::@2#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column_1
    // [48] phi main::tile#12 = main::tile#2 [phi:main::@17->main::@2#2] -- register_copy 
    // [48] phi from main::@18 to main::@2 [phi:main::@18->main::@2]
    // [48] phi main::c1#2 = main::c1#1 [phi:main::@18->main::@2#0] -- register_copy 
    // [48] phi main::column#10 = main::column#3 [phi:main::@18->main::@2#1] -- register_copy 
    // [48] phi main::tile#12 = main::tile#3 [phi:main::@18->main::@2#2] -- register_copy 
    // main::@2
  __b2:
    // vera_tile_area(0, tile, column, 3, 1, 1, 0, 0, 0)
    // [49] vera_tile_area::tileindex#2 = main::tile#12 -- vwuz1=vwuz2 
    lda.z tile
    sta.z vera_tile_area.tileindex
    lda.z tile+1
    sta.z vera_tile_area.tileindex+1
    // [50] vera_tile_area::x#2 = main::column#10 -- vbuz1=vbuz2 
    lda.z column_1
    sta.z vera_tile_area.x
    // [51] call vera_tile_area 
    // [303] phi from main::@2 to vera_tile_area [phi:main::@2->vera_tile_area]
    // [303] phi vera_tile_area::w#13 = 1 [phi:main::@2->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [303] phi vera_tile_area::h#7 = 1 [phi:main::@2->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [303] phi vera_tile_area::x#6 = vera_tile_area::x#2 [phi:main::@2->vera_tile_area#2] -- register_copy 
    // [303] phi vera_tile_area::y#6 = 3 [phi:main::@2->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #3
    sta.z vera_tile_area.y
    // [303] phi vera_tile_area::tileindex#6 = vera_tile_area::tileindex#2 [phi:main::@2->vera_tile_area#4] -- register_copy 
    // [303] phi vera_tile_area::offset#7 = 0 [phi:main::@2->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // main::@18
    // column+=4
    // [52] main::column#3 = main::column#10 + 4 -- vbuz1=vbuz1_plus_vbuc1 
    lda #4
    clc
    adc.z column_1
    sta.z column_1
    // tile++;
    // [53] main::tile#3 = ++ main::tile#12 -- vwuz1=_inc_vwuz1 
    inc.z tile
    bne !+
    inc.z tile+1
  !:
    // for(byte c:0..7)
    // [54] main::c1#1 = ++ main::c1#2 -- vbuz1=_inc_vbuz1 
    inc.z c1
    // [55] if(main::c1#1!=8) goto main::@2 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z c1
    bne __b2
    // [56] phi from main::@18 to main::@3 [phi:main::@18->main::@3]
    // [56] phi main::c2#2 = 0 [phi:main::@18->main::@3#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c2
    // [56] phi main::column#12 = 1 [phi:main::@18->main::@3#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column_2
    // [56] phi main::tile#14 = 0 [phi:main::@18->main::@3#2] -- vwuz1=vbuc1 
    lda #<0
    sta.z tile_1
    sta.z tile_1+1
    // [56] phi from main::@19 to main::@3 [phi:main::@19->main::@3]
    // [56] phi main::c2#2 = main::c2#1 [phi:main::@19->main::@3#0] -- register_copy 
    // [56] phi main::column#12 = main::column#5 [phi:main::@19->main::@3#1] -- register_copy 
    // [56] phi main::tile#14 = main::tile#22 [phi:main::@19->main::@3#2] -- register_copy 
    // main::@3
  __b3:
    // vera_tile_area(0, tile, column, 5, 3, 3, 0, 0, 0)
    // [57] vera_tile_area::tileindex#3 = main::tile#14 -- vwuz1=vwuz2 
    lda.z tile_1
    sta.z vera_tile_area.tileindex
    lda.z tile_1+1
    sta.z vera_tile_area.tileindex+1
    // [58] vera_tile_area::x#3 = main::column#12 -- vbuz1=vbuz2 
    lda.z column_2
    sta.z vera_tile_area.x
    // [59] call vera_tile_area 
    // [303] phi from main::@3 to vera_tile_area [phi:main::@3->vera_tile_area]
    // [303] phi vera_tile_area::w#13 = 3 [phi:main::@3->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #3
    sta.z vera_tile_area.w
    // [303] phi vera_tile_area::h#7 = 3 [phi:main::@3->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [303] phi vera_tile_area::x#6 = vera_tile_area::x#3 [phi:main::@3->vera_tile_area#2] -- register_copy 
    // [303] phi vera_tile_area::y#6 = 5 [phi:main::@3->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #5
    sta.z vera_tile_area.y
    // [303] phi vera_tile_area::tileindex#6 = vera_tile_area::tileindex#3 [phi:main::@3->vera_tile_area#4] -- register_copy 
    // [303] phi vera_tile_area::offset#7 = 0 [phi:main::@3->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // main::@19
    // column+=4
    // [60] main::column#5 = main::column#12 + 4 -- vbuz1=vbuz1_plus_vbuc1 
    lda #4
    clc
    adc.z column_2
    sta.z column_2
    // tile++;
    // [61] main::tile#22 = ++ main::tile#14 -- vwuz1=_inc_vwuz1 
    inc.z tile_1
    bne !+
    inc.z tile_1+1
  !:
    // for(byte c:0..7)
    // [62] main::c2#1 = ++ main::c2#2 -- vbuz1=_inc_vbuz1 
    inc.z c2
    // [63] if(main::c2#1!=8) goto main::@3 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z c2
    bne __b3
    // [64] phi from main::@19 to main::@4 [phi:main::@19->main::@4]
    // [64] phi main::c3#2 = 0 [phi:main::@19->main::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c3
    // [64] phi main::column#14 = 1 [phi:main::@19->main::@4#1] -- vbuz1=vbuc1 
    lda #1
    sta.z column_3
    // [64] phi main::tile#16 = main::tile#22 [phi:main::@19->main::@4#2] -- register_copy 
    // [64] phi from main::@20 to main::@4 [phi:main::@20->main::@4]
    // [64] phi main::c3#2 = main::c3#1 [phi:main::@20->main::@4#0] -- register_copy 
    // [64] phi main::column#14 = main::column#7 [phi:main::@20->main::@4#1] -- register_copy 
    // [64] phi main::tile#16 = main::tile#6 [phi:main::@20->main::@4#2] -- register_copy 
    // main::@4
  __b4:
    // vera_tile_area(0, tile, column, 9, 3, 3, 0, 0, 0)
    // [65] vera_tile_area::tileindex#4 = main::tile#16 -- vwuz1=vwuz2 
    lda.z tile_1
    sta.z vera_tile_area.tileindex
    lda.z tile_1+1
    sta.z vera_tile_area.tileindex+1
    // [66] vera_tile_area::x#4 = main::column#14 -- vbuz1=vbuz2 
    lda.z column_3
    sta.z vera_tile_area.x
    // [67] call vera_tile_area 
    // [303] phi from main::@4 to vera_tile_area [phi:main::@4->vera_tile_area]
    // [303] phi vera_tile_area::w#13 = 3 [phi:main::@4->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #3
    sta.z vera_tile_area.w
    // [303] phi vera_tile_area::h#7 = 3 [phi:main::@4->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [303] phi vera_tile_area::x#6 = vera_tile_area::x#4 [phi:main::@4->vera_tile_area#2] -- register_copy 
    // [303] phi vera_tile_area::y#6 = 9 [phi:main::@4->vera_tile_area#3] -- vbuz1=vbuc1 
    lda #9
    sta.z vera_tile_area.y
    // [303] phi vera_tile_area::tileindex#6 = vera_tile_area::tileindex#4 [phi:main::@4->vera_tile_area#4] -- register_copy 
    // [303] phi vera_tile_area::offset#7 = 0 [phi:main::@4->vera_tile_area#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_tile_area.offset
    jsr vera_tile_area
    // main::@20
    // column+=4
    // [68] main::column#7 = main::column#14 + 4 -- vbuz1=vbuz1_plus_vbuc1 
    lda #4
    clc
    adc.z column_3
    sta.z column_3
    // tile++;
    // [69] main::tile#6 = ++ main::tile#16 -- vwuz1=_inc_vwuz1 
    inc.z tile_1
    bne !+
    inc.z tile_1+1
  !:
    // for(byte c:0..7)
    // [70] main::c3#1 = ++ main::c3#2 -- vbuz1=_inc_vbuz1 
    inc.z c3
    // [71] if(main::c3#1!=8) goto main::@4 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z c3
    bne __b4
    // [72] phi from main::@20 to main::@5 [phi:main::@20->main::@5]
    // [72] phi main::r#7 = 0 [phi:main::@20->main::@5#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // [72] phi main::offset#5 = 0 [phi:main::@20->main::@5#1] -- vbuz1=vbuc1 
    sta.z offset
    // [72] phi main::row#5 = $d [phi:main::@20->main::@5#2] -- vbuz1=vbuc1 
    lda #$d
    sta.z row
    // [72] phi main::tile#23 = 0 [phi:main::@20->main::@5#3] -- vwuz1=vbuc1 
    lda #<0
    sta.z tile_2
    sta.z tile_2+1
    // [72] phi from main::@9 to main::@5 [phi:main::@9->main::@5]
    // [72] phi main::r#7 = main::r#1 [phi:main::@9->main::@5#0] -- register_copy 
    // [72] phi main::offset#5 = main::offset#4 [phi:main::@9->main::@5#1] -- register_copy 
    // [72] phi main::row#5 = main::row#1 [phi:main::@9->main::@5#2] -- register_copy 
    // [72] phi main::tile#23 = main::tile#25 [phi:main::@9->main::@5#3] -- register_copy 
    // main::@5
  __b5:
    // [73] phi from main::@5 to main::@6 [phi:main::@5->main::@6]
    // [73] phi main::c4#2 = 0 [phi:main::@5->main::@6#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c4
    // [73] phi main::offset#2 = main::offset#5 [phi:main::@5->main::@6#1] -- register_copy 
    // [73] phi main::column1#2 = 1 [phi:main::@5->main::@6#2] -- vbuz1=vbuc1 
    lda #1
    sta.z column1
    // [73] phi main::tile#18 = main::tile#23 [phi:main::@5->main::@6#3] -- register_copy 
    // [73] phi from main::@7 to main::@6 [phi:main::@7->main::@6]
    // [73] phi main::c4#2 = main::c4#1 [phi:main::@7->main::@6#0] -- register_copy 
    // [73] phi main::offset#2 = main::offset#4 [phi:main::@7->main::@6#1] -- register_copy 
    // [73] phi main::column1#2 = main::column1#1 [phi:main::@7->main::@6#2] -- register_copy 
    // [73] phi main::tile#18 = main::tile#25 [phi:main::@7->main::@6#3] -- register_copy 
    // main::@6
  __b6:
    // vera_tile_area(0, tile, column, row, 1, 1, 0, 0, offset)
    // [74] vera_tile_area::tileindex#5 = main::tile#18 -- vwuz1=vwuz2 
    lda.z tile_2
    sta.z vera_tile_area.tileindex
    lda.z tile_2+1
    sta.z vera_tile_area.tileindex+1
    // [75] vera_tile_area::x#5 = main::column1#2 -- vbuz1=vbuz2 
    lda.z column1
    sta.z vera_tile_area.x
    // [76] vera_tile_area::y#5 = main::row#5 -- vbuz1=vbuz2 
    lda.z row
    sta.z vera_tile_area.y
    // [77] vera_tile_area::offset#6 = main::offset#2 -- vbuz1=vbuz2 
    lda.z offset
    sta.z vera_tile_area.offset
    // [78] call vera_tile_area 
    // [303] phi from main::@6 to vera_tile_area [phi:main::@6->vera_tile_area]
    // [303] phi vera_tile_area::w#13 = 1 [phi:main::@6->vera_tile_area#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_tile_area.w
    // [303] phi vera_tile_area::h#7 = 1 [phi:main::@6->vera_tile_area#1] -- vbuz1=vbuc1 
    sta.z vera_tile_area.h
    // [303] phi vera_tile_area::x#6 = vera_tile_area::x#5 [phi:main::@6->vera_tile_area#2] -- register_copy 
    // [303] phi vera_tile_area::y#6 = vera_tile_area::y#5 [phi:main::@6->vera_tile_area#3] -- register_copy 
    // [303] phi vera_tile_area::tileindex#6 = vera_tile_area::tileindex#5 [phi:main::@6->vera_tile_area#4] -- register_copy 
    // [303] phi vera_tile_area::offset#7 = vera_tile_area::offset#6 [phi:main::@6->vera_tile_area#5] -- register_copy 
    jsr vera_tile_area
    // main::@21
    // column+=1
    // [79] main::column1#1 = main::column1#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z column1
    // tile++;
    // [80] main::tile#20 = ++ main::tile#18 -- vwuz1=_inc_vwuz1 
    inc.z tile_2
    bne !+
    inc.z tile_2+1
  !:
    // c & 0x0f
    // [81] main::$25 = main::c4#2 & $f -- vbuz1=vbuz2_band_vbuc1 
    lda #$f
    and.z c4
    sta.z __25
    // if((c & 0x0f) == 0x0f)
    // [82] if(main::$25!=$f) goto main::@7 -- vbuz1_neq_vbuc1_then_la1 
    lda #$f
    cmp.z __25
    bne __b7
    // main::@8
    // offset++;
    // [83] main::offset#1 = ++ main::offset#2 -- vbuz1=_inc_vbuz1 
    inc.z offset
    // [84] phi from main::@21 main::@8 to main::@7 [phi:main::@21/main::@8->main::@7]
    // [84] phi main::offset#4 = main::offset#2 [phi:main::@21/main::@8->main::@7#0] -- register_copy 
    // main::@7
  __b7:
    // tile &= 0x0f
    // [85] main::tile#25 = main::tile#20 & $f -- vwuz1=vwuz1_band_vbuc1 
    lda #$f
    and.z tile_2
    sta.z tile_2
    lda #0
    sta.z tile_2+1
    // for(byte c:0..31)
    // [86] main::c4#1 = ++ main::c4#2 -- vbuz1=_inc_vbuz1 
    inc.z c4
    // [87] if(main::c4#1!=$20) goto main::@6 -- vbuz1_neq_vbuc1_then_la1 
    lda #$20
    cmp.z c4
    bne __b6
    // main::@9
    // row += 1
    // [88] main::row#1 = main::row#5 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z row
    // for(byte r:0..7)
    // [89] main::r#1 = ++ main::r#7 -- vbuz1=_inc_vbuz1 
    inc.z r
    // [90] if(main::r#1!=8) goto main::@5 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z r
    bne __b5
    // main::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [91] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [92] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [93] phi from main::vera_layer_show1 to main::@11 [phi:main::vera_layer_show1->main::@11]
    // main::@11
    // gotoxy(0,50)
    // [94] call gotoxy 
    // [168] phi from main::@11 to gotoxy [phi:main::@11->gotoxy]
    // [168] phi gotoxy::y#4 = $32 [phi:main::@11->gotoxy#0] -- vbuz1=vbuc1 
    lda #$32
    sta.z gotoxy.y
    jsr gotoxy
    // [95] phi from main::@11 to main::@22 [phi:main::@11->main::@22]
    // main::@22
    // printf("vera in tile mode 16 x 16, color depth 4 bits per pixel.\n")
    // [96] call cputs 
    // [339] phi from main::@22 to cputs [phi:main::@22->cputs]
    // [339] phi cputs::s#10 = main::s [phi:main::@22->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // [97] phi from main::@22 to main::@23 [phi:main::@22->main::@23]
    // main::@23
    // printf("in this mode, tiles are 16 pixels wide and 16 pixels tall.\n")
    // [98] call cputs 
    // [339] phi from main::@23 to cputs [phi:main::@23->cputs]
    // [339] phi cputs::s#10 = main::s1 [phi:main::@23->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [99] phi from main::@23 to main::@24 [phi:main::@23->main::@24]
    // main::@24
    // printf("each tile can have a variation of 16 colors.\n")
    // [100] call cputs 
    // [339] phi from main::@24 to cputs [phi:main::@24->cputs]
    // [339] phi cputs::s#10 = main::s2 [phi:main::@24->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // [101] phi from main::@24 to main::@25 [phi:main::@24->main::@25]
    // main::@25
    // printf("the vera palette of 256 colors, can be used by setting the palette\n")
    // [102] call cputs 
    // [339] phi from main::@25 to cputs [phi:main::@25->cputs]
    // [339] phi cputs::s#10 = main::s3 [phi:main::@25->cputs#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // [103] phi from main::@25 to main::@26 [phi:main::@25->main::@26]
    // main::@26
    // printf("offset for each tile.\n")
    // [104] call cputs 
    // [339] phi from main::@26 to cputs [phi:main::@26->cputs]
    // [339] phi cputs::s#10 = main::s4 [phi:main::@26->cputs#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // [105] phi from main::@26 to main::@27 [phi:main::@26->main::@27]
    // main::@27
    // printf("here each column is displaying the same tile, but with different offsets!\n")
    // [106] call cputs 
    // [339] phi from main::@27 to cputs [phi:main::@27->cputs]
    // [339] phi cputs::s#10 = main::s5 [phi:main::@27->cputs#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    // [107] phi from main::@27 to main::@28 [phi:main::@27->main::@28]
    // main::@28
    // printf("each offset aligns to multiples of 16 colors in the palette!.\n")
    // [108] call cputs 
    // [339] phi from main::@28 to cputs [phi:main::@28->cputs]
    // [339] phi cputs::s#10 = main::s6 [phi:main::@28->cputs#0] -- pbuz1=pbuc1 
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
    // [109] phi from main::@28 to main::@29 [phi:main::@28->main::@29]
    // main::@29
    // printf("however, the first color will always be transparent (black).\n")
    // [110] call cputs 
    // [339] phi from main::@29 to cputs [phi:main::@29->cputs]
    // [339] phi cputs::s#10 = main::s7 [phi:main::@29->cputs#0] -- pbuz1=pbuc1 
    lda #<s7
    sta.z cputs.s
    lda #>s7
    sta.z cputs.s+1
    jsr cputs
    // [111] phi from main::@29 main::@30 to main::@10 [phi:main::@29/main::@30->main::@10]
    // main::@10
  __b10:
    // kbhit()
    // [112] call kbhit 
    jsr kbhit
    // [113] kbhit::return#2 = kbhit::return#1
    // main::@30
    // [114] main::$30 = kbhit::return#2
    // while(!kbhit())
    // [115] if(0==main::$30) goto main::@10 -- 0_eq_vbuz1_then_la1 
    lda.z __30
    beq __b10
    // main::@return
    // }
    // [116] return 
    rts
  .segment Data
    tiles: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $22, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $bb, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    s: .text @"vera in tile mode 16 x 16, color depth 4 bits per pixel.\n"
    .byte 0
    s1: .text @"in this mode, tiles are 16 pixels wide and 16 pixels tall.\n"
    .byte 0
    s2: .text @"each tile can have a variation of 16 colors.\n"
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
    .const mapbase_address = 0
    .const tilebase_address = $f800
    .const mapwidth = $80
    .const mapheight = $40
    .const tilewidth = 8
    .const tileheight = 8
    .label layer = 1
    // vera_layer_mode_tile( layer, mapbase_address, tilebase_address, mapwidth, mapheight, tilewidth, tileheight, 1 )
    // [118] call vera_layer_mode_tile 
    // [221] phi from vera_layer_mode_text to vera_layer_mode_tile [phi:vera_layer_mode_text->vera_layer_mode_tile]
    // [221] phi vera_layer_mode_tile::tileheight#10 = vera_layer_mode_text::tileheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #tileheight
    sta.z vera_layer_mode_tile.tileheight
    // [221] phi vera_layer_mode_tile::tilewidth#10 = vera_layer_mode_text::tilewidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    lda #tilewidth
    sta.z vera_layer_mode_tile.tilewidth
    // [221] phi vera_layer_mode_tile::tilebase_address#10 = vera_layer_mode_text::tilebase_address#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<tilebase_address>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>tilebase_address>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [221] phi vera_layer_mode_tile::mapbase_address#10 = vera_layer_mode_text::mapbase_address#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<mapbase_address>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>mapbase_address>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [221] phi vera_layer_mode_tile::mapheight#10 = vera_layer_mode_text::mapheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#4] -- vwuz1=vwuc1 
    lda #<mapheight
    sta.z vera_layer_mode_tile.mapheight
    lda #>mapheight
    sta.z vera_layer_mode_tile.mapheight+1
    // [221] phi vera_layer_mode_tile::layer#10 = vera_layer_mode_text::layer#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #layer
    sta.z vera_layer_mode_tile.layer
    // [221] phi vera_layer_mode_tile::mapwidth#10 = vera_layer_mode_text::mapwidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#6] -- vwuz1=vwuc1 
    lda #<mapwidth
    sta.z vera_layer_mode_tile.mapwidth
    lda #>mapwidth
    sta.z vera_layer_mode_tile.mapwidth+1
    // [221] phi vera_layer_mode_tile::color_depth#2 = 1 [phi:vera_layer_mode_text->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // [119] phi from vera_layer_mode_text to vera_layer_mode_text::@1 [phi:vera_layer_mode_text->vera_layer_mode_text::@1]
    // vera_layer_mode_text::@1
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C )
    // [120] call vera_layer_set_text_color_mode 
    jsr vera_layer_set_text_color_mode
    // vera_layer_mode_text::@return
    // }
    // [121] return 
    rts
}
  // screensize
// Return the current screen size.
screensize: {
    .label x = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    .label y = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    .label __1 = $27
    .label __3 = $28
    .label hscale = $27
    .label vscale = $28
    // char hscale = (*VERA_DC_HSCALE) >> 7
    // [122] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    sta.z hscale
    // 40 << hscale
    // [123] screensize::$1 = $28 << screensize::hscale#0 -- vbuz1=vbuc1_rol_vbuz1 
    lda #$28
    ldy.z __1
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta.z __1
    // *x = 40 << hscale
    // [124] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbuz1 
    sta x
    // char vscale = (*VERA_DC_VSCALE) >> 7
    // [125] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    sta.z vscale
    // 30 << vscale
    // [126] screensize::$3 = $1e << screensize::vscale#0 -- vbuz1=vbuc1_rol_vbuz1 
    lda #$1e
    ldy.z __3
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta.z __3
    // *y = 30 << vscale
    // [127] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbuz1 
    sta y
    // screensize::@return
    // }
    // [128] return 
    rts
}
  // screenlayer
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer: {
    .label layer = 1
    .label __0 = $29
    .label __1 = $2a
    .label vera_layer_get_width1___0 = $2e
    .label vera_layer_get_width1___1 = $2e
    .label vera_layer_get_width1___3 = $2e
    .label vera_layer_get_height1___0 = $2f
    .label vera_layer_get_height1___1 = $2f
    .label vera_layer_get_height1___3 = $2f
    .label vera_layer_get_width1_config = $2c
    .label vera_layer_get_width1_return = $39
    .label vera_layer_get_height1_config = $3b
    .label vera_layer_get_height1_return = $33
    .label vera_layer_get_rowshift1_return = $30
    .label vera_layer_get_rowskip1_return = $36
    // cx16_conio.conio_screen_layer = layer
    // [129] *((byte*)&cx16_conio) = screenlayer::layer#0 -- _deref_pbuc1=vbuc2 
    lda #layer
    sta cx16_conio
    // vera_layer_get_mapbase_bank(layer)
    // [130] call vera_layer_get_mapbase_bank 
    jsr vera_layer_get_mapbase_bank
    // [131] vera_layer_get_mapbase_bank::return#2 = vera_layer_get_mapbase_bank::return#0
    // screenlayer::@5
    // [132] screenlayer::$0 = vera_layer_get_mapbase_bank::return#2
    // cx16_conio.conio_screen_bank = vera_layer_get_mapbase_bank(layer)
    // [133] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) = screenlayer::$0 -- _deref_pbuc1=vbuz1 
    lda.z __0
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // vera_layer_get_mapbase_offset(layer)
    // [134] call vera_layer_get_mapbase_offset 
    jsr vera_layer_get_mapbase_offset
    // [135] vera_layer_get_mapbase_offset::return#2 = vera_layer_get_mapbase_offset::return#0
    // screenlayer::@6
    // [136] screenlayer::$1 = vera_layer_get_mapbase_offset::return#2
    // cx16_conio.conio_screen_text = vera_layer_get_mapbase_offset(layer)
    // [137] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) = screenlayer::$1 -- _deref_pwuc1=vwuz1 
    lda.z __1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    lda.z __1+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    // screenlayer::vera_layer_get_width1
    // byte* config = vera_layer_config[layer]
    // [138] screenlayer::vera_layer_get_width1_config#0 = *(vera_layer_config+screenlayer::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+layer*SIZEOF_POINTER
    sta.z vera_layer_get_width1_config
    lda vera_layer_config+layer*SIZEOF_POINTER+1
    sta.z vera_layer_get_width1_config+1
    // *config & VERA_LAYER_WIDTH_MASK
    // [139] screenlayer::vera_layer_get_width1_$0 = *screenlayer::vera_layer_get_width1_config#0 & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    ldy #0
    and (vera_layer_get_width1_config),y
    sta.z vera_layer_get_width1___0
    // (*config & VERA_LAYER_WIDTH_MASK) >> 4
    // [140] screenlayer::vera_layer_get_width1_$1 = screenlayer::vera_layer_get_width1_$0 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z vera_layer_get_width1___1
    lsr
    lsr
    lsr
    lsr
    sta.z vera_layer_get_width1___1
    // return VERA_LAYER_WIDTH[ (*config & VERA_LAYER_WIDTH_MASK) >> 4];
    // [141] screenlayer::vera_layer_get_width1_$3 = screenlayer::vera_layer_get_width1_$1 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z vera_layer_get_width1___3
    // [142] screenlayer::vera_layer_get_width1_return#0 = VERA_LAYER_WIDTH[screenlayer::vera_layer_get_width1_$3] -- vwuz1=pwuc1_derefidx_vbuz2 
    ldy.z vera_layer_get_width1___3
    lda VERA_LAYER_WIDTH,y
    sta.z vera_layer_get_width1_return
    lda VERA_LAYER_WIDTH+1,y
    sta.z vera_layer_get_width1_return+1
    // screenlayer::@1
    // cx16_conio.conio_map_width = vera_layer_get_width(layer)
    // [143] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) = screenlayer::vera_layer_get_width1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_width1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    lda.z vera_layer_get_width1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    // screenlayer::vera_layer_get_height1
    // byte* config = vera_layer_config[layer]
    // [144] screenlayer::vera_layer_get_height1_config#0 = *(vera_layer_config+screenlayer::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+layer*SIZEOF_POINTER
    sta.z vera_layer_get_height1_config
    lda vera_layer_config+layer*SIZEOF_POINTER+1
    sta.z vera_layer_get_height1_config+1
    // *config & VERA_LAYER_HEIGHT_MASK
    // [145] screenlayer::vera_layer_get_height1_$0 = *screenlayer::vera_layer_get_height1_config#0 & VERA_LAYER_HEIGHT_MASK -- vbuz1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    ldy #0
    and (vera_layer_get_height1_config),y
    sta.z vera_layer_get_height1___0
    // (*config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [146] screenlayer::vera_layer_get_height1_$1 = screenlayer::vera_layer_get_height1_$0 >> 6 -- vbuz1=vbuz1_ror_6 
    lda.z vera_layer_get_height1___1
    rol
    rol
    rol
    and #3
    sta.z vera_layer_get_height1___1
    // return VERA_LAYER_HEIGHT[ (*config & VERA_LAYER_HEIGHT_MASK) >> 6];
    // [147] screenlayer::vera_layer_get_height1_$3 = screenlayer::vera_layer_get_height1_$1 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z vera_layer_get_height1___3
    // [148] screenlayer::vera_layer_get_height1_return#0 = VERA_LAYER_HEIGHT[screenlayer::vera_layer_get_height1_$3] -- vwuz1=pwuc1_derefidx_vbuz2 
    ldy.z vera_layer_get_height1___3
    lda VERA_LAYER_HEIGHT,y
    sta.z vera_layer_get_height1_return
    lda VERA_LAYER_HEIGHT+1,y
    sta.z vera_layer_get_height1_return+1
    // screenlayer::@2
    // cx16_conio.conio_map_height = vera_layer_get_height(layer)
    // [149] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) = screenlayer::vera_layer_get_height1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_height1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    lda.z vera_layer_get_height1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    // screenlayer::vera_layer_get_rowshift1
    // return vera_layer_rowshift[layer];
    // [150] screenlayer::vera_layer_get_rowshift1_return#0 = *(vera_layer_rowshift+screenlayer::layer#0) -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift+layer
    sta.z vera_layer_get_rowshift1_return
    // screenlayer::@3
    // cx16_conio.conio_rowshift = vera_layer_get_rowshift(layer)
    // [151] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) = screenlayer::vera_layer_get_rowshift1_return#0 -- _deref_pbuc1=vbuz1 
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
    // screenlayer::vera_layer_get_rowskip1
    // return vera_layer_rowskip[layer];
    // [152] screenlayer::vera_layer_get_rowskip1_return#0 = *(vera_layer_rowskip+screenlayer::layer#0*SIZEOF_WORD) -- vwuz1=_deref_pwuc1 
    lda vera_layer_rowskip+layer*SIZEOF_WORD
    sta.z vera_layer_get_rowskip1_return
    lda vera_layer_rowskip+layer*SIZEOF_WORD+1
    sta.z vera_layer_get_rowskip1_return+1
    // screenlayer::@4
    // cx16_conio.conio_rowskip = vera_layer_get_rowskip(layer)
    // [153] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) = screenlayer::vera_layer_get_rowskip1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_rowskip1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    lda.z vera_layer_get_rowskip1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    // screenlayer::@return
    // }
    // [154] return 
    rts
}
  // vera_layer_set_textcolor
/**
 * @brief Set the front color for text output. The old front text color setting is returned.
 * 
 * @param layer The layer of the vera 0/1.
 * @param color a 4 bit value ( decimal between 0 and 15) when the VERA works in 16x16 color text mode.
 * An 8 bit value (decimal between 0 and 255) when the VERA works in 256 text mode.
 * Note that on the VERA, the transparent color has value 0.
 * @return vera_forecolor 
 */
// vera_layer_set_textcolor(byte zp($27) layer)
vera_layer_set_textcolor: {
    .label layer = $27
    // vera_layer_textcolor[layer] = color
    // [156] vera_layer_textcolor[vera_layer_set_textcolor::layer#2] = WHITE -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #WHITE
    ldy.z layer
    sta vera_layer_textcolor,y
    // vera_layer_set_textcolor::@return
    // }
    // [157] return 
    rts
}
  // vera_layer_set_backcolor
/**
 * @brief Set the back color for text output. The old back text color setting is returned.
 * 
 * @param layer The layer of the vera 0/1.
 * @param color a 4 bit value ( decimal between 0 and 15).
 * This will only work when the VERA is in 16 color mode!
 * Note that on the VERA, the transparent color has value 0.
 * @return vera_backcolor 
 */
// vera_layer_set_backcolor(byte zp($27) layer, byte zp($28) color)
vera_layer_set_backcolor: {
    .label layer = $27
    .label color = $28
    // vera_layer_backcolor[layer] = color
    // [159] vera_layer_backcolor[vera_layer_set_backcolor::layer#2] = vera_layer_set_backcolor::color#2 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z color
    ldy.z layer
    sta vera_layer_backcolor,y
    // vera_layer_set_backcolor::@return
    // }
    // [160] return 
    rts
}
  // vera_layer_set_mapbase
/**
 * @brief Set the base of the map layer with which the conio will interact.
 * 
 * @param layer The layer of the vera 0/1.
 * @param mapbase Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:9 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
 * 
 */
// vera_layer_set_mapbase(byte zp($28) layer, byte zp($27) mapbase)
vera_layer_set_mapbase: {
    .label __0 = $28
    .label addr = $39
    .label layer = $28
    .label mapbase = $27
    // byte* addr = vera_layer_mapbase[layer]
    // [162] vera_layer_set_mapbase::$0 = vera_layer_set_mapbase::layer#3 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __0
    // [163] vera_layer_set_mapbase::addr#0 = vera_layer_mapbase[vera_layer_set_mapbase::$0] -- pbuz1=qbuc1_derefidx_vbuz2 
    ldy.z __0
    lda vera_layer_mapbase,y
    sta.z addr
    lda vera_layer_mapbase+1,y
    sta.z addr+1
    // *addr = mapbase
    // [164] *vera_layer_set_mapbase::addr#0 = vera_layer_set_mapbase::mapbase#3 -- _deref_pbuz1=vbuz2 
    lda.z mapbase
    ldy #0
    sta (addr),y
    // vera_layer_set_mapbase::@return
    // }
    // [165] return 
    rts
}
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
cursor: {
    .const onoff = 0
    // cx16_conio.conio_display_cursor = onoff
    // [166] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR
    // cursor::@return
    // }
    // [167] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// gotoxy(byte zp(2) y)
gotoxy: {
    .label __5 = $31
    .label __6 = $3b
    .label line_offset = $3b
    .label y = 2
    // if(y>cx16_conio.conio_screen_height)
    // [169] if(gotoxy::y#4<=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto gotoxy::@4 -- vbuz1_le__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    cmp.z y
    bcs __b1
    // [171] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [171] phi gotoxy::y#5 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z y
    // [170] phi from gotoxy to gotoxy::@4 [phi:gotoxy->gotoxy::@4]
    // gotoxy::@4
    // [171] phi from gotoxy::@4 to gotoxy::@1 [phi:gotoxy::@4->gotoxy::@1]
    // [171] phi gotoxy::y#5 = gotoxy::y#4 [phi:gotoxy::@4->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=cx16_conio.conio_screen_width)
    // [172] if(0<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto gotoxy::@2 -- 0_lt__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    cmp #0
    // [173] phi from gotoxy::@1 to gotoxy::@3 [phi:gotoxy::@1->gotoxy::@3]
    // gotoxy::@3
    // gotoxy::@2
    // conio_cursor_x[cx16_conio.conio_screen_layer] = x
    // [174] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = y
    // [175] conio_cursor_y[*((byte*)&cx16_conio)] = gotoxy::y#5 -- pbuc1_derefidx_(_deref_pbuc2)=vbuz1 
    lda.z y
    sta conio_cursor_y,y
    // (unsigned int)y << cx16_conio.conio_rowshift
    // [176] gotoxy::$6 = (word)gotoxy::y#5 -- vwuz1=_word_vbuz2 
    sta.z __6
    lda #0
    sta.z __6+1
    // unsigned int line_offset = (unsigned int)y << cx16_conio.conio_rowshift
    // [177] gotoxy::line_offset#0 = gotoxy::$6 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vwuz1_rol__deref_pbuc1 
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
    // [178] gotoxy::$5 = *((byte*)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __5
    // [179] conio_line_text[gotoxy::$5] = gotoxy::line_offset#0 -- pwuc1_derefidx_vbuz1=vwuz2 
    tay
    lda.z line_offset
    sta conio_line_text,y
    lda.z line_offset+1
    sta conio_line_text+1,y
    // gotoxy::@return
    // }
    // [180] return 
    rts
}
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
textcolor: {
    // vera_layer_set_textcolor(cx16_conio.conio_screen_layer, color)
    // [181] vera_layer_set_textcolor::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_set_textcolor.layer
    // [182] call vera_layer_set_textcolor 
    // [155] phi from textcolor to vera_layer_set_textcolor [phi:textcolor->vera_layer_set_textcolor]
    // [155] phi vera_layer_set_textcolor::layer#2 = vera_layer_set_textcolor::layer#0 [phi:textcolor->vera_layer_set_textcolor#0] -- register_copy 
    jsr vera_layer_set_textcolor
    // textcolor::@return
    // }
    // [183] return 
    rts
}
  // bgcolor
// Set the back color for text output. The old back text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
bgcolor: {
    // vera_layer_set_backcolor(cx16_conio.conio_screen_layer, color)
    // [184] vera_layer_set_backcolor::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_set_backcolor.layer
    // [185] call vera_layer_set_backcolor 
    // [158] phi from bgcolor to vera_layer_set_backcolor [phi:bgcolor->vera_layer_set_backcolor]
    // [158] phi vera_layer_set_backcolor::color#2 = BLACK [phi:bgcolor->vera_layer_set_backcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z vera_layer_set_backcolor.color
    // [158] phi vera_layer_set_backcolor::layer#2 = vera_layer_set_backcolor::layer#0 [phi:bgcolor->vera_layer_set_backcolor#1] -- register_copy 
    jsr vera_layer_set_backcolor
    // bgcolor::@return
    // }
    // [186] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __0 = $52
    .label __1 = $52
    .label __2 = $55
    .label __5 = $59
    .label __6 = $5a
    .label __7 = $5b
    .label __9 = $58
    .label line_text = $22
    .label color = $52
    .label conio_map_height = $53
    .label conio_map_width = $4b
    .label c = $50
    .label l = $4f
    // unsigned int line_text = cx16_conio.conio_screen_text
    // [187] clrscr::line_text#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z line_text+1
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer)
    // [188] vera_layer_get_backcolor::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_backcolor.layer
    // [189] call vera_layer_get_backcolor 
    jsr vera_layer_get_backcolor
    // [190] vera_layer_get_backcolor::return#2 = vera_layer_get_backcolor::return#0
    // clrscr::@7
    // [191] clrscr::$0 = vera_layer_get_backcolor::return#2
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4
    // [192] clrscr::$1 = clrscr::$0 << 4 -- vbuz1=vbuz1_rol_4 
    lda.z __1
    asl
    asl
    asl
    asl
    sta.z __1
    // vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [193] vera_layer_get_textcolor::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_textcolor.layer
    // [194] call vera_layer_get_textcolor 
    jsr vera_layer_get_textcolor
    // [195] vera_layer_get_textcolor::return#2 = vera_layer_get_textcolor::return#0
    // clrscr::@8
    // [196] clrscr::$2 = vera_layer_get_textcolor::return#2
    // char color = ( vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4 ) | vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [197] clrscr::color#0 = clrscr::$1 | clrscr::$2 -- vbuz1=vbuz1_bor_vbuz2 
    lda.z color
    ora.z __2
    sta.z color
    // word conio_map_height = cx16_conio.conio_map_height
    // [198] clrscr::conio_map_height#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    sta.z conio_map_height
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    sta.z conio_map_height+1
    // word conio_map_width = cx16_conio.conio_map_width
    // [199] clrscr::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // [200] phi from clrscr::@8 to clrscr::@1 [phi:clrscr::@8->clrscr::@1]
    // [200] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr::@8->clrscr::@1#0] -- register_copy 
    // [200] phi clrscr::l#2 = 0 [phi:clrscr::@8->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<conio_map_height; l++ )
    // [201] if(clrscr::l#2<clrscr::conio_map_height#0) goto clrscr::@2 -- vbuz1_lt_vwuz2_then_la1 
    lda.z conio_map_height+1
    bne __b2
    lda.z l
    cmp.z conio_map_height
    bcc __b2
    // clrscr::@3
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [202] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = 0
    // [203] conio_cursor_y[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    sta conio_cursor_y,y
    // conio_line_text[cx16_conio.conio_screen_layer] = 0
    // [204] clrscr::$9 = *((byte*)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    tya
    asl
    sta.z __9
    // [205] conio_line_text[clrscr::$9] = 0 -- pwuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z __9
    sta conio_line_text,y
    sta conio_line_text+1,y
    // clrscr::@return
    // }
    // [206] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [207] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <ch
    // [208] clrscr::$5 = < clrscr::line_text#2 -- vbuz1=_lo_vwuz2 
    lda.z line_text
    sta.z __5
    // *VERA_ADDRX_L = <ch
    // [209] *VERA_ADDRX_L = clrscr::$5 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // >ch
    // [210] clrscr::$6 = > clrscr::line_text#2 -- vbuz1=_hi_vwuz2 
    lda.z line_text+1
    sta.z __6
    // *VERA_ADDRX_M = >ch
    // [211] *VERA_ADDRX_M = clrscr::$6 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [212] clrscr::$7 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    sta.z __7
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [213] *VERA_ADDRX_H = clrscr::$7 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [214] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [214] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@4
  __b4:
    // for( char c=0;c<conio_map_width; c++ )
    // [215] if(clrscr::c#2<clrscr::conio_map_width#0) goto clrscr::@5 -- vbuz1_lt_vwuz2_then_la1 
    lda.z conio_map_width+1
    bne __b5
    lda.z c
    cmp.z conio_map_width
    bcc __b5
    // clrscr::@6
    // line_text += cx16_conio.conio_rowskip
    // [216] clrscr::line_text#1 = clrscr::line_text#2 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z line_text
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z line_text+1
    sta.z line_text+1
    // for( char l=0;l<conio_map_height; l++ )
    // [217] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [200] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [200] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [200] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [218] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [219] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<conio_map_width; c++ )
    // [220] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [214] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [214] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
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
// vera_layer_mode_tile(byte zp($29) layer, dword zp($16) mapbase_address, dword zp($1a) tilebase_address, word zp($2a) mapwidth, word zp($2c) mapheight, byte zp($2e) tilewidth, byte zp($2f) tileheight, byte zp($28) color_depth)
vera_layer_mode_tile: {
    .label __1 = $33
    .label __2 = $36
    .label __4 = $44
    .label __7 = $39
    .label __8 = $3b
    .label __10 = $3d
    .label __13 = $41
    .label __14 = $40
    .label __15 = $3f
    .label __16 = $32
    .label __19 = $35
    .label __20 = $38
    // config
    .label config = $30
    .label mapbase_address = $16
    .label mapbase = $27
    .label tilebase_address = $1a
    .label tilebase = $31
    .label color_depth = $28
    .label mapwidth = $2a
    .label layer = $29
    .label mapheight = $2c
    .label tilewidth = $2e
    .label tileheight = $2f
    // case 1:
    //             config |= VERA_LAYER_COLOR_DEPTH_1BPP;
    //             break;
    // [222] if(vera_layer_mode_tile::color_depth#2==1) goto vera_layer_mode_tile::@5 -- vbuz1_eq_vbuc1_then_la1 
    lda #1
    cmp.z color_depth
    beq __b1
    // vera_layer_mode_tile::@1
    // case 2:
    //             config |= VERA_LAYER_COLOR_DEPTH_2BPP;
    //             break;
    // [223] if(vera_layer_mode_tile::color_depth#2==2) goto vera_layer_mode_tile::@5 -- vbuz1_eq_vbuc1_then_la1 
    lda #2
    cmp.z color_depth
    beq __b2
    // vera_layer_mode_tile::@2
    // case 4:
    //             config |= VERA_LAYER_COLOR_DEPTH_4BPP;
    //             break;
    // [224] if(vera_layer_mode_tile::color_depth#2==4) goto vera_layer_mode_tile::@5 -- vbuz1_eq_vbuc1_then_la1 
    lda #4
    cmp.z color_depth
    beq __b3
    // vera_layer_mode_tile::@3
    // case 8:
    //             config |= VERA_LAYER_COLOR_DEPTH_8BPP;
    //             break;
    // [225] if(vera_layer_mode_tile::color_depth#2!=8) goto vera_layer_mode_tile::@5 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z color_depth
    bne __b4
    // [226] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@4 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@4]
    // vera_layer_mode_tile::@4
    // [227] phi from vera_layer_mode_tile::@4 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5]
    // [227] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_8BPP [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_8BPP
    sta.z config
    jmp __b5
    // [227] phi from vera_layer_mode_tile to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5]
  __b1:
    // [227] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_1BPP [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_1BPP
    sta.z config
    jmp __b5
    // [227] phi from vera_layer_mode_tile::@1 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5]
  __b2:
    // [227] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_2BPP [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_2BPP
    sta.z config
    jmp __b5
    // [227] phi from vera_layer_mode_tile::@2 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5]
  __b3:
    // [227] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_4BPP [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_4BPP
    sta.z config
    jmp __b5
    // [227] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5]
  __b4:
    // [227] phi vera_layer_mode_tile::config#17 = 0 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #0
    sta.z config
    // vera_layer_mode_tile::@5
  __b5:
    // case 32:
    //             config |= VERA_LAYER_WIDTH_32;
    //             vera_layer_rowshift[layer] = 6;
    //             vera_layer_rowskip[layer] = 64;
    //             break;
    // [228] if(vera_layer_mode_tile::mapwidth#10==$20) goto vera_layer_mode_tile::@9 -- vwuz1_eq_vbuc1_then_la1 
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
    // [229] if(vera_layer_mode_tile::mapwidth#10==$40) goto vera_layer_mode_tile::@10 -- vwuz1_eq_vbuc1_then_la1 
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
    // [230] if(vera_layer_mode_tile::mapwidth#10==$80) goto vera_layer_mode_tile::@11 -- vwuz1_eq_vbuc1_then_la1 
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
    // [231] if(vera_layer_mode_tile::mapwidth#10!=$100) goto vera_layer_mode_tile::@13 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapwidth+1
    cmp #>$100
    bne __b13
    lda.z mapwidth
    cmp #<$100
    bne __b13
    // vera_layer_mode_tile::@12
    // config |= VERA_LAYER_WIDTH_256
    // [232] vera_layer_mode_tile::config#8 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_256 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_WIDTH_256
    ora.z config
    sta.z config
    // vera_layer_rowshift[layer] = 9
    // [233] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 9 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #9
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 512
    // [234] vera_layer_mode_tile::$16 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z __16
    // [235] vera_layer_rowskip[vera_layer_mode_tile::$16] = $200 -- pwuc1_derefidx_vbuz1=vwuc2 
    tay
    lda #<$200
    sta vera_layer_rowskip,y
    lda #>$200
    sta vera_layer_rowskip+1,y
    // [236] phi from vera_layer_mode_tile::@10 vera_layer_mode_tile::@11 vera_layer_mode_tile::@12 vera_layer_mode_tile::@8 vera_layer_mode_tile::@9 to vera_layer_mode_tile::@13 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13]
    // [236] phi vera_layer_mode_tile::config#21 = vera_layer_mode_tile::config#6 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13#0] -- register_copy 
    // vera_layer_mode_tile::@13
  __b13:
    // case 32:
    //             config |= VERA_LAYER_HEIGHT_32;
    //             break;
    // [237] if(vera_layer_mode_tile::mapheight#10==$20) goto vera_layer_mode_tile::@20 -- vwuz1_eq_vbuc1_then_la1 
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
    // [238] if(vera_layer_mode_tile::mapheight#10==$40) goto vera_layer_mode_tile::@17 -- vwuz1_eq_vbuc1_then_la1 
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
    // [239] if(vera_layer_mode_tile::mapheight#10==$80) goto vera_layer_mode_tile::@18 -- vwuz1_eq_vbuc1_then_la1 
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
    // [240] if(vera_layer_mode_tile::mapheight#10!=$100) goto vera_layer_mode_tile::@20 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapheight+1
    cmp #>$100
    bne __b20
    lda.z mapheight
    cmp #<$100
    bne __b20
    // vera_layer_mode_tile::@19
    // config |= VERA_LAYER_HEIGHT_256
    // [241] vera_layer_mode_tile::config#12 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_256 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_HEIGHT_256
    ora.z config
    sta.z config
    // [242] phi from vera_layer_mode_tile::@13 vera_layer_mode_tile::@16 vera_layer_mode_tile::@17 vera_layer_mode_tile::@18 vera_layer_mode_tile::@19 to vera_layer_mode_tile::@20 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20]
    // [242] phi vera_layer_mode_tile::config#25 = vera_layer_mode_tile::config#21 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20#0] -- register_copy 
    // vera_layer_mode_tile::@20
  __b20:
    // vera_layer_set_config(layer, config)
    // [243] vera_layer_set_config::layer#0 = vera_layer_mode_tile::layer#10
    // [244] vera_layer_set_config::config#0 = vera_layer_mode_tile::config#25
    // [245] call vera_layer_set_config 
    jsr vera_layer_set_config
    // vera_layer_mode_tile::@27
    // <mapbase_address
    // [246] vera_layer_mode_tile::$1 = < vera_layer_mode_tile::mapbase_address#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase_address
    sta.z __1
    lda.z mapbase_address+1
    sta.z __1+1
    // vera_mapbase_offset[layer] = <mapbase_address
    // [247] vera_layer_mode_tile::$19 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z layer
    asl
    sta.z __19
    // [248] vera_mapbase_offset[vera_layer_mode_tile::$19] = vera_layer_mode_tile::$1 -- pwuc1_derefidx_vbuz1=vwuz2 
    // mapbase
    tay
    lda.z __1
    sta vera_mapbase_offset,y
    lda.z __1+1
    sta vera_mapbase_offset+1,y
    // >mapbase_address
    // [249] vera_layer_mode_tile::$2 = > vera_layer_mode_tile::mapbase_address#10 -- vwuz1=_hi_vduz2 
    lda.z mapbase_address+2
    sta.z __2
    lda.z mapbase_address+3
    sta.z __2+1
    // vera_mapbase_bank[layer] = (byte)(>mapbase_address)
    // [250] vera_mapbase_bank[vera_layer_mode_tile::layer#10] = (byte)vera_layer_mode_tile::$2 -- pbuc1_derefidx_vbuz1=_byte_vwuz2 
    ldy.z layer
    lda.z __2
    sta vera_mapbase_bank,y
    // vera_mapbase_address[layer] = mapbase_address
    // [251] vera_layer_mode_tile::$20 = vera_layer_mode_tile::layer#10 << 2 -- vbuz1=vbuz2_rol_2 
    tya
    asl
    asl
    sta.z __20
    // [252] vera_mapbase_address[vera_layer_mode_tile::$20] = vera_layer_mode_tile::mapbase_address#10 -- pduc1_derefidx_vbuz1=vduz2 
    tay
    lda.z mapbase_address
    sta vera_mapbase_address,y
    lda.z mapbase_address+1
    sta vera_mapbase_address+1,y
    lda.z mapbase_address+2
    sta vera_mapbase_address+2,y
    lda.z mapbase_address+3
    sta vera_mapbase_address+3,y
    // mapbase_address = mapbase_address >> 1
    // [253] vera_layer_mode_tile::mapbase_address#0 = vera_layer_mode_tile::mapbase_address#10 >> 1 -- vduz1=vduz1_ror_1 
    lsr.z mapbase_address+3
    ror.z mapbase_address+2
    ror.z mapbase_address+1
    ror.z mapbase_address
    // <mapbase_address
    // [254] vera_layer_mode_tile::$4 = < vera_layer_mode_tile::mapbase_address#0 -- vwuz1=_lo_vduz2 
    lda.z mapbase_address
    sta.z __4
    lda.z mapbase_address+1
    sta.z __4+1
    // byte mapbase = >(<mapbase_address)
    // [255] vera_layer_mode_tile::mapbase#0 = > vera_layer_mode_tile::$4 -- vbuz1=_hi_vwuz2 
    sta.z mapbase
    // vera_layer_set_mapbase(layer,mapbase)
    // [256] vera_layer_set_mapbase::layer#0 = vera_layer_mode_tile::layer#10 -- vbuz1=vbuz2 
    lda.z layer
    sta.z vera_layer_set_mapbase.layer
    // [257] vera_layer_set_mapbase::mapbase#0 = vera_layer_mode_tile::mapbase#0
    // [258] call vera_layer_set_mapbase 
    // [161] phi from vera_layer_mode_tile::@27 to vera_layer_set_mapbase [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase]
    // [161] phi vera_layer_set_mapbase::mapbase#3 = vera_layer_set_mapbase::mapbase#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#0] -- register_copy 
    // [161] phi vera_layer_set_mapbase::layer#3 = vera_layer_set_mapbase::layer#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#1] -- register_copy 
    jsr vera_layer_set_mapbase
    // vera_layer_mode_tile::@28
    // <tilebase_address
    // [259] vera_layer_mode_tile::$7 = < vera_layer_mode_tile::tilebase_address#10 -- vwuz1=_lo_vduz2 
    lda.z tilebase_address
    sta.z __7
    lda.z tilebase_address+1
    sta.z __7+1
    // vera_tilebase_offset[layer] = <tilebase_address
    // [260] vera_tilebase_offset[vera_layer_mode_tile::$19] = vera_layer_mode_tile::$7 -- pwuc1_derefidx_vbuz1=vwuz2 
    // tilebase
    ldy.z __19
    lda.z __7
    sta vera_tilebase_offset,y
    lda.z __7+1
    sta vera_tilebase_offset+1,y
    // >tilebase_address
    // [261] vera_layer_mode_tile::$8 = > vera_layer_mode_tile::tilebase_address#10 -- vwuz1=_hi_vduz2 
    lda.z tilebase_address+2
    sta.z __8
    lda.z tilebase_address+3
    sta.z __8+1
    // vera_tilebase_bank[layer] = (byte)>tilebase_address
    // [262] vera_tilebase_bank[vera_layer_mode_tile::layer#10] = (byte)vera_layer_mode_tile::$8 -- pbuc1_derefidx_vbuz1=_byte_vwuz2 
    ldy.z layer
    lda.z __8
    sta vera_tilebase_bank,y
    // vera_tilebase_address[layer] = tilebase_address
    // [263] vera_tilebase_address[vera_layer_mode_tile::$20] = vera_layer_mode_tile::tilebase_address#10 -- pduc1_derefidx_vbuz1=vduz2 
    ldy.z __20
    lda.z tilebase_address
    sta vera_tilebase_address,y
    lda.z tilebase_address+1
    sta vera_tilebase_address+1,y
    lda.z tilebase_address+2
    sta vera_tilebase_address+2,y
    lda.z tilebase_address+3
    sta vera_tilebase_address+3,y
    // tilebase_address = tilebase_address >> 1
    // [264] vera_layer_mode_tile::tilebase_address#0 = vera_layer_mode_tile::tilebase_address#10 >> 1 -- vduz1=vduz1_ror_1 
    lsr.z tilebase_address+3
    ror.z tilebase_address+2
    ror.z tilebase_address+1
    ror.z tilebase_address
    // <tilebase_address
    // [265] vera_layer_mode_tile::$10 = < vera_layer_mode_tile::tilebase_address#0 -- vwuz1=_lo_vduz2 
    lda.z tilebase_address
    sta.z __10
    lda.z tilebase_address+1
    sta.z __10+1
    // byte tilebase = >(<tilebase_address)
    // [266] vera_layer_mode_tile::tilebase#0 = > vera_layer_mode_tile::$10 -- vbuz1=_hi_vwuz2 
    sta.z tilebase
    // tilebase &= VERA_LAYER_TILEBASE_MASK
    // [267] vera_layer_mode_tile::tilebase#1 = vera_layer_mode_tile::tilebase#0 & VERA_LAYER_TILEBASE_MASK -- vbuz1=vbuz1_band_vbuc1 
    lda #VERA_LAYER_TILEBASE_MASK
    and.z tilebase
    sta.z tilebase
    // case 8:
    //             tilebase |= VERA_TILEBASE_WIDTH_8;
    //             break;
    // [268] if(vera_layer_mode_tile::tilewidth#10==8) goto vera_layer_mode_tile::@23 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tilewidth
    beq __b23
    // vera_layer_mode_tile::@21
    // case 16:
    //             tilebase |= VERA_TILEBASE_WIDTH_16;
    //             break;
    // [269] if(vera_layer_mode_tile::tilewidth#10!=$10) goto vera_layer_mode_tile::@23 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tilewidth
    bne __b23
    // vera_layer_mode_tile::@22
    // tilebase |= VERA_TILEBASE_WIDTH_16
    // [270] vera_layer_mode_tile::tilebase#3 = vera_layer_mode_tile::tilebase#1 | VERA_TILEBASE_WIDTH_16 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_TILEBASE_WIDTH_16
    ora.z tilebase
    sta.z tilebase
    // [271] phi from vera_layer_mode_tile::@21 vera_layer_mode_tile::@22 vera_layer_mode_tile::@28 to vera_layer_mode_tile::@23 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23]
    // [271] phi vera_layer_mode_tile::tilebase#12 = vera_layer_mode_tile::tilebase#1 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23#0] -- register_copy 
    // vera_layer_mode_tile::@23
  __b23:
    // case 8:
    //             tilebase |= VERA_TILEBASE_HEIGHT_8;
    //             break;
    // [272] if(vera_layer_mode_tile::tileheight#10==8) goto vera_layer_mode_tile::@26 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tileheight
    beq __b26
    // vera_layer_mode_tile::@24
    // case 16:
    //             tilebase |= VERA_TILEBASE_HEIGHT_16;
    //             break;
    // [273] if(vera_layer_mode_tile::tileheight#10!=$10) goto vera_layer_mode_tile::@26 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tileheight
    bne __b26
    // vera_layer_mode_tile::@25
    // tilebase |= VERA_TILEBASE_HEIGHT_16
    // [274] vera_layer_mode_tile::tilebase#5 = vera_layer_mode_tile::tilebase#12 | VERA_TILEBASE_HEIGHT_16 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_TILEBASE_HEIGHT_16
    ora.z tilebase
    sta.z tilebase
    // [275] phi from vera_layer_mode_tile::@23 vera_layer_mode_tile::@24 vera_layer_mode_tile::@25 to vera_layer_mode_tile::@26 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26]
    // [275] phi vera_layer_mode_tile::tilebase#10 = vera_layer_mode_tile::tilebase#12 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26#0] -- register_copy 
    // vera_layer_mode_tile::@26
  __b26:
    // vera_layer_set_tilebase(layer,tilebase)
    // [276] vera_layer_set_tilebase::layer#0 = vera_layer_mode_tile::layer#10
    // [277] vera_layer_set_tilebase::tilebase#0 = vera_layer_mode_tile::tilebase#10
    // [278] call vera_layer_set_tilebase 
    jsr vera_layer_set_tilebase
    // vera_layer_mode_tile::@return
    // }
    // [279] return 
    rts
    // vera_layer_mode_tile::@18
  __b18:
    // config |= VERA_LAYER_HEIGHT_128
    // [280] vera_layer_mode_tile::config#11 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_128 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_HEIGHT_128
    ora.z config
    sta.z config
    jmp __b20
    // vera_layer_mode_tile::@17
  __b17:
    // config |= VERA_LAYER_HEIGHT_64
    // [281] vera_layer_mode_tile::config#10 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_64 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_HEIGHT_64
    ora.z config
    sta.z config
    jmp __b20
    // vera_layer_mode_tile::@11
  __b11:
    // config |= VERA_LAYER_WIDTH_128
    // [282] vera_layer_mode_tile::config#7 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_128 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_WIDTH_128
    ora.z config
    sta.z config
    // vera_layer_rowshift[layer] = 8
    // [283] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 8 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #8
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 256
    // [284] vera_layer_mode_tile::$15 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z __15
    // [285] vera_layer_rowskip[vera_layer_mode_tile::$15] = $100 -- pwuc1_derefidx_vbuz1=vwuc2 
    tay
    lda #<$100
    sta vera_layer_rowskip,y
    lda #>$100
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@10
  __b10:
    // config |= VERA_LAYER_WIDTH_64
    // [286] vera_layer_mode_tile::config#6 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_64 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_WIDTH_64
    ora.z config
    sta.z config
    // vera_layer_rowshift[layer] = 7
    // [287] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 7 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #7
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 128
    // [288] vera_layer_mode_tile::$14 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z __14
    // [289] vera_layer_rowskip[vera_layer_mode_tile::$14] = $80 -- pwuc1_derefidx_vbuz1=vbuc2 
    lda #$80
    ldy.z __14
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@9
  __b9:
    // vera_layer_rowshift[layer] = 6
    // [290] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 6 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #6
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 64
    // [291] vera_layer_mode_tile::$13 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z __13
    // [292] vera_layer_rowskip[vera_layer_mode_tile::$13] = $40 -- pwuc1_derefidx_vbuz1=vbuc2 
    lda #$40
    ldy.z __13
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b13
}
  // cx16_cpy_vram_from_ram
/**
 * @brief Copy block of memory from ram to vram.  
 * Copies num bytes from the ram source pointer to the vram bank/offset.
 * 
 * @param dbank_vram Destination vram bank.
 * @param doffset_vram The destination vram offset, 0x0000 till 0xFFFF)
 * @param sptr_ram Source pointer in ram.
 * @param num Amount of bytes to copy.
 */
cx16_cpy_vram_from_ram: {
    .const dbank_vram = 1
    .const doffset_vram = $4000
    .const num = $800
    .label sptr_ram = main.tiles
    .label end = sptr_ram+num
    .label s = $22
    // cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [294] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_L = BYTE0(offset)
    // [295] *VERA_ADDRX_L = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta VERA_ADDRX_L
    // *VERA_ADDRX_M = BYTE1(offset)
    // [296] *VERA_ADDRX_M = >cx16_cpy_vram_from_ram::doffset_vram#0 -- _deref_pbuc1=vbuc2 
    lda #>(doffset_vram)
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [297] *VERA_ADDRX_H = cx16_cpy_vram_from_ram::dbank_vram#0|vera_inc_1 -- _deref_pbuc1=vbuc2 
    lda #dbank_vram|vera_inc_1
    sta VERA_ADDRX_H
    // [298] phi from cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1 to cx16_cpy_vram_from_ram::@1 [phi:cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1->cx16_cpy_vram_from_ram::@1]
    // [298] phi cx16_cpy_vram_from_ram::s#2 = (byte*)cx16_cpy_vram_from_ram::sptr_ram#0 [phi:cx16_cpy_vram_from_ram::vera_vram_data0_bank_offset1->cx16_cpy_vram_from_ram::@1#0] -- pbuz1=pbuc1 
    lda #<sptr_ram
    sta.z s
    lda #>sptr_ram
    sta.z s+1
    // cx16_cpy_vram_from_ram::@1
  __b1:
    // for(char *s = sptr_ram; s!=end; s++)
    // [299] if(cx16_cpy_vram_from_ram::s#2!=cx16_cpy_vram_from_ram::end#0) goto cx16_cpy_vram_from_ram::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z s+1
    cmp #>end
    bne __b2
    lda.z s
    cmp #<end
    bne __b2
    // cx16_cpy_vram_from_ram::@return
    // }
    // [300] return 
    rts
    // cx16_cpy_vram_from_ram::@2
  __b2:
    // *VERA_DATA0 = *s
    // [301] *VERA_DATA0 = *cx16_cpy_vram_from_ram::s#2 -- _deref_pbuc1=_deref_pbuz1 
    ldy #0
    lda (s),y
    sta VERA_DATA0
    // for(char *s = sptr_ram; s!=end; s++)
    // [302] cx16_cpy_vram_from_ram::s#1 = ++ cx16_cpy_vram_from_ram::s#2 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [298] phi from cx16_cpy_vram_from_ram::@2 to cx16_cpy_vram_from_ram::@1 [phi:cx16_cpy_vram_from_ram::@2->cx16_cpy_vram_from_ram::@1]
    // [298] phi cx16_cpy_vram_from_ram::s#2 = cx16_cpy_vram_from_ram::s#1 [phi:cx16_cpy_vram_from_ram::@2->cx16_cpy_vram_from_ram::@1#0] -- register_copy 
    jmp __b1
}
  // vera_tile_area
/// VERA TILING
// vera_tile_area(word zp($22) tileindex, byte zp($24) x, byte zp($50) y, byte zp($25) w, byte zp($51) h, byte zp($58) hflip, byte zp($59) vflip, byte zp($4f) offset)
vera_tile_area: {
    .label __4 = $4b
    .label __5 = $24
    .label __10 = $4b
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1___0 = $4d
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1___1 = $4e
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1___2 = $42
    .label mapbase = $1e
    .label shift = $55
    .label rowskip = $53
    .label hflip = $58
    .label vflip = $59
    .label offset = $4f
    .label index_l = $5a
    .label index_h = $5b
    .label index_h_1 = $58
    .label index_h_2 = $59
    .label index_h_3 = $4f
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank = $42
    .label vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset = $49
    .label c = $52
    .label r = $26
    .label tileindex = $22
    .label x = $24
    .label y = $50
    .label h = $51
    .label w = $25
    // dword mapbase = vera_mapbase_address[layer]
    // [304] vera_tile_area::mapbase#0 = *vera_mapbase_address -- vduz1=_deref_pduc1 
    lda vera_mapbase_address
    sta.z mapbase
    lda vera_mapbase_address+1
    sta.z mapbase+1
    lda vera_mapbase_address+2
    sta.z mapbase+2
    lda vera_mapbase_address+3
    sta.z mapbase+3
    // byte shift = vera_layer_rowshift[layer]
    // [305] vera_tile_area::shift#0 = *vera_layer_rowshift -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift
    sta.z shift
    // word rowskip = (word)1 << shift
    // [306] vera_tile_area::rowskip#0 = 1 << vera_tile_area::shift#0 -- vwuz1=vwuc1_rol_vbuz2 
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
    // [307] vera_tile_area::hflip#0 = *vera_layer_hflip -- vbuz1=_deref_pbuc1 
    lda vera_layer_hflip
    sta.z hflip
    // vflip = vera_layer_vflip[vflip]
    // [308] vera_tile_area::vflip#0 = *vera_layer_vflip -- vbuz1=_deref_pbuc1 
    lda vera_layer_vflip
    sta.z vflip
    // offset = offset << 4
    // [309] vera_tile_area::offset#0 = vera_tile_area::offset#7 << 4 -- vbuz1=vbuz1_rol_4 
    lda.z offset
    asl
    asl
    asl
    asl
    sta.z offset
    // byte index_l = <tileindex
    // [310] vera_tile_area::index_l#0 = < vera_tile_area::tileindex#6 -- vbuz1=_lo_vwuz2 
    lda.z tileindex
    sta.z index_l
    // byte index_h = >tileindex
    // [311] vera_tile_area::index_h#0 = > vera_tile_area::tileindex#6 -- vbuz1=_hi_vwuz2 
    lda.z tileindex+1
    sta.z index_h
    // index_h |= hflip
    // [312] vera_tile_area::index_h#1 = vera_tile_area::index_h#0 | vera_tile_area::hflip#0 -- vbuz1=vbuz2_bor_vbuz1 
    lda.z index_h_1
    ora.z index_h
    sta.z index_h_1
    // index_h |= vflip
    // [313] vera_tile_area::index_h#2 = vera_tile_area::index_h#1 | vera_tile_area::vflip#0 -- vbuz1=vbuz2_bor_vbuz1 
    lda.z index_h_2
    ora.z index_h_1
    sta.z index_h_2
    // index_h |= offset
    // [314] vera_tile_area::index_h#3 = vera_tile_area::index_h#2 | vera_tile_area::offset#0 -- vbuz1=vbuz2_bor_vbuz1 
    lda.z index_h_3
    ora.z index_h_2
    sta.z index_h_3
    // (word)y << shift
    // [315] vera_tile_area::$10 = (word)vera_tile_area::y#6 -- vwuz1=_word_vbuz2 
    lda.z y
    sta.z __10
    lda #0
    sta.z __10+1
    // [316] vera_tile_area::$4 = vera_tile_area::$10 << vera_tile_area::shift#0 -- vwuz1=vwuz1_rol_vbuz2 
    ldy.z shift
    beq !e+
  !:
    asl.z __4
    rol.z __4+1
    dey
    bne !-
  !e:
    // mapbase += ((word)y << shift)
    // [317] vera_tile_area::mapbase#1 = vera_tile_area::mapbase#0 + vera_tile_area::$4 -- vduz1=vduz1_plus_vwuz2 
    lda.z mapbase
    clc
    adc.z __4
    sta.z mapbase
    lda.z mapbase+1
    adc.z __4+1
    sta.z mapbase+1
    lda.z mapbase+2
    adc #0
    sta.z mapbase+2
    lda.z mapbase+3
    adc #0
    sta.z mapbase+3
    // x << 1
    // [318] vera_tile_area::$5 = vera_tile_area::x#6 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __5
    // mapbase += (x << 1)
    // [319] vera_tile_area::mapbase#2 = vera_tile_area::mapbase#1 + vera_tile_area::$5 -- vduz1=vduz1_plus_vbuz2 
    lda.z __5
    clc
    adc.z mapbase
    sta.z mapbase
    lda.z mapbase+1
    adc #0
    sta.z mapbase+1
    lda.z mapbase+2
    adc #0
    sta.z mapbase+2
    lda.z mapbase+3
    adc #0
    sta.z mapbase+3
    // [320] phi from vera_tile_area to vera_tile_area::@1 [phi:vera_tile_area->vera_tile_area::@1]
    // [320] phi vera_tile_area::mapbase#10 = vera_tile_area::mapbase#2 [phi:vera_tile_area->vera_tile_area::@1#0] -- register_copy 
    // [320] phi vera_tile_area::r#2 = 0 [phi:vera_tile_area->vera_tile_area::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // vera_tile_area::@1
  __b1:
    // for(byte r=0; r<h; r++)
    // [321] if(vera_tile_area::r#2<vera_tile_area::h#7) goto vera_tile_area::vera_vram_data0_address1 -- vbuz1_lt_vbuz2_then_la1 
    lda.z r
    cmp.z h
    bcc vera_vram_data0_address1
    // vera_tile_area::@return
    // }
    // [322] return 
    rts
    // vera_tile_area::vera_vram_data0_address1
  vera_vram_data0_address1:
    // vera_vram_data0_bank_offset( BYTE2(bankaddr), WORD0(bankaddr), inc_dec )
    // [323] vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank#0 = _byte2_ vera_tile_area::mapbase#10 -- vbuz1=_byte2_vduz2 
    lda.z mapbase+2
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank
    // [324] vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 = _word0_ vera_tile_area::mapbase#10 -- vwuz1=_word0_vduz2 
    lda.z mapbase
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset
    lda.z mapbase+1
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset+1
    // vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [325] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [326] vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$0 = < vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 -- vbuz1=_byte0_vwuz2 
    lda.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [327] *VERA_ADDRX_L = vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [328] vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$1 = > vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset#0 -- vbuz1=_byte1_vwuz2 
    lda.z vera_vram_data0_address1_vera_vram_data0_bank_offset1_offset+1
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [329] *VERA_ADDRX_M = vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // bank | inc_dec
    // [330] vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$2 = vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_bank#0 | VERA_INC_1 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_INC_1
    ora.z vera_vram_data0_address1_vera_vram_data0_bank_offset1___2
    sta.z vera_vram_data0_address1_vera_vram_data0_bank_offset1___2
    // *VERA_ADDRX_H = bank | inc_dec
    // [331] *VERA_ADDRX_H = vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1_$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [332] phi from vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1 to vera_tile_area::@2 [phi:vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1->vera_tile_area::@2]
    // [332] phi vera_tile_area::c#2 = 0 [phi:vera_tile_area::vera_vram_data0_address1_vera_vram_data0_bank_offset1->vera_tile_area::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // vera_tile_area::@2
  __b2:
    // for(byte c=0; c<w; c++)
    // [333] if(vera_tile_area::c#2<vera_tile_area::w#13) goto vera_tile_area::@3 -- vbuz1_lt_vbuz2_then_la1 
    lda.z c
    cmp.z w
    bcc __b3
    // vera_tile_area::@4
    // mapbase += rowskip
    // [334] vera_tile_area::mapbase#3 = vera_tile_area::mapbase#10 + vera_tile_area::rowskip#0 -- vduz1=vduz1_plus_vwuz2 
    lda.z mapbase
    clc
    adc.z rowskip
    sta.z mapbase
    lda.z mapbase+1
    adc.z rowskip+1
    sta.z mapbase+1
    lda.z mapbase+2
    adc #0
    sta.z mapbase+2
    lda.z mapbase+3
    adc #0
    sta.z mapbase+3
    // for(byte r=0; r<h; r++)
    // [335] vera_tile_area::r#1 = ++ vera_tile_area::r#2 -- vbuz1=_inc_vbuz1 
    inc.z r
    // [320] phi from vera_tile_area::@4 to vera_tile_area::@1 [phi:vera_tile_area::@4->vera_tile_area::@1]
    // [320] phi vera_tile_area::mapbase#10 = vera_tile_area::mapbase#3 [phi:vera_tile_area::@4->vera_tile_area::@1#0] -- register_copy 
    // [320] phi vera_tile_area::r#2 = vera_tile_area::r#1 [phi:vera_tile_area::@4->vera_tile_area::@1#1] -- register_copy 
    jmp __b1
    // vera_tile_area::@3
  __b3:
    // *VERA_DATA0 = index_l
    // [336] *VERA_DATA0 = vera_tile_area::index_l#0 -- _deref_pbuc1=vbuz1 
    lda.z index_l
    sta VERA_DATA0
    // *VERA_DATA0 = index_h
    // [337] *VERA_DATA0 = vera_tile_area::index_h#3 -- _deref_pbuc1=vbuz1 
    lda.z index_h_3
    sta VERA_DATA0
    // for(byte c=0; c<w; c++)
    // [338] vera_tile_area::c#1 = ++ vera_tile_area::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [332] phi from vera_tile_area::@3 to vera_tile_area::@2 [phi:vera_tile_area::@3->vera_tile_area::@2]
    // [332] phi vera_tile_area::c#2 = vera_tile_area::c#1 [phi:vera_tile_area::@3->vera_tile_area::@2#0] -- register_copy 
    jmp __b2
}
  // cputs
// Output a NUL-terminated string at the current cursor position
// cputs(const byte* zp($22) s)
cputs: {
    .label c = $42
    .label s = $22
    // [340] phi from cputs cputs::@2 to cputs::@1 [phi:cputs/cputs::@2->cputs::@1]
    // [340] phi cputs::s#9 = cputs::s#10 [phi:cputs/cputs::@2->cputs::@1#0] -- register_copy 
    // cputs::@1
  __b1:
    // while(c=*s++)
    // [341] cputs::c#1 = *cputs::s#9 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta.z c
    // [342] cputs::s#0 = ++ cputs::s#9 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [343] if(0!=cputs::c#1) goto cputs::@2 -- 0_neq_vbuz1_then_la1 
    lda.z c
    bne __b2
    // cputs::@return
    // }
    // [344] return 
    rts
    // cputs::@2
  __b2:
    // cputc(c)
    // [345] cputc::c#0 = cputs::c#1
    // [346] call cputc 
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
    .label ch = $43
    .label return = $26
    // char ch = 0
    // [347] kbhit::ch = 0 -- vbuz1=vbuc1 
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
    // [349] kbhit::return#0 = kbhit::ch -- vbuz1=vbuz2 
    sta.z return
    // kbhit::@return
    // }
    // [350] kbhit::return#1 = kbhit::return#0
    // [351] return 
    rts
}
  // vera_layer_set_text_color_mode
/**
 * @brief Set the configuration of the layer text color mode.
 * 
 * @param layer The layer of the vera 0/1.
 * @param color_mode Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
 */
vera_layer_set_text_color_mode: {
    .label addr = $44
    // byte* addr = vera_layer_config[layer]
    // [352] vera_layer_set_text_color_mode::addr#0 = *(vera_layer_config+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr &= ~VERA_LAYER_CONFIG_256C
    // [353] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 & ~VERA_LAYER_CONFIG_256C -- _deref_pbuz1=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C^$ff
    ldy #0
    and (addr),y
    sta (addr),y
    // *addr |= color_mode
    // [354] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 -- _deref_pbuz1=_deref_pbuz1 
    lda (addr),y
    sta (addr),y
    // vera_layer_set_text_color_mode::@return
    // }
    // [355] return 
    rts
}
  // vera_layer_get_mapbase_bank
/**
 * @brief Get the map base bank of the tiles for the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_bank Bank in vera vram.
 */
vera_layer_get_mapbase_bank: {
    .label return = $29
    // return vera_mapbase_bank[layer];
    // [356] vera_layer_get_mapbase_bank::return#0 = *(vera_mapbase_bank+screenlayer::layer#0) -- vbuz1=_deref_pbuc1 
    lda vera_mapbase_bank+screenlayer.layer
    sta.z return
    // vera_layer_get_mapbase_bank::@return
    // }
    // [357] return 
    rts
}
  // vera_layer_get_mapbase_offset
/**
 * @brief Get the map base lower 16-bit address (offset) of the tiles for the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_offset Offset in vera vram of the specified bank.
 */
vera_layer_get_mapbase_offset: {
    .label return = $2a
    // return vera_mapbase_offset[layer];
    // [358] vera_layer_get_mapbase_offset::return#0 = *(vera_mapbase_offset+screenlayer::layer#0*SIZEOF_WORD) -- vwuz1=_deref_pwuc1 
    lda vera_mapbase_offset+screenlayer.layer*SIZEOF_WORD
    sta.z return
    lda vera_mapbase_offset+screenlayer.layer*SIZEOF_WORD+1
    sta.z return+1
    // vera_layer_get_mapbase_offset::@return
    // }
    // [359] return 
    rts
}
  // vera_layer_get_backcolor
/**
 * @brief Get the back color for text output. The old back text color setting is returned.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_backcolor a 4 bit value ( decimal between 0 and 15).
 * This will only work when the VERA is in 16 color mode!
 * Note that on the VERA, the transparent color has value 0.
 */
// vera_layer_get_backcolor(byte zp($52) layer)
vera_layer_get_backcolor: {
    .label return = $52
    .label layer = $52
    // return vera_layer_backcolor[layer];
    // [360] vera_layer_get_backcolor::return#0 = vera_layer_backcolor[vera_layer_get_backcolor::layer#0] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_backcolor,y
    sta.z return
    // vera_layer_get_backcolor::@return
    // }
    // [361] return 
    rts
}
  // vera_layer_get_textcolor
/**
 * @brief Get the front color for text output. The old front text color setting is returned.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_forecolor A 4 bit value ( decimal between 0 and 15).
 * This will only work when the VERA is in 16 color mode!
 * Note that on the VERA, the transparent color has value 0.
 */
// vera_layer_get_textcolor(byte zp($55) layer)
vera_layer_get_textcolor: {
    .label return = $55
    .label layer = $55
    // return vera_layer_textcolor[layer];
    // [362] vera_layer_get_textcolor::return#0 = vera_layer_textcolor[vera_layer_get_textcolor::layer#0] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_textcolor,y
    sta.z return
    // vera_layer_get_textcolor::@return
    // }
    // [363] return 
    rts
}
  // vera_layer_set_config
/**
 * @brief Set the configuration of the layer.
 * 
 * @param layer The layer of the vera 0/1.
 * @param config Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
 */
// vera_layer_set_config(byte zp($29) layer, byte zp($30) config)
vera_layer_set_config: {
    .label __0 = $46
    .label addr = $47
    .label layer = $29
    .label config = $30
    // byte* addr = vera_layer_config[layer]
    // [364] vera_layer_set_config::$0 = vera_layer_set_config::layer#0 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z layer
    asl
    sta.z __0
    // [365] vera_layer_set_config::addr#0 = vera_layer_config[vera_layer_set_config::$0] -- pbuz1=qbuc1_derefidx_vbuz2 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr = config
    // [366] *vera_layer_set_config::addr#0 = vera_layer_set_config::config#0 -- _deref_pbuz1=vbuz2 
    lda.z config
    ldy #0
    sta (addr),y
    // vera_layer_set_config::@return
    // }
    // [367] return 
    rts
}
  // vera_layer_set_tilebase
/**
 * @brief Set the base of the tiles for the layer with which the conio will interact.
 * 
 * @param layer The layer of the vera 0/1.
 * @param tilebase Specifies the base address of the tile map.
 * Note that the register only specifies bits 16:11 of the address,
 * so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
 */
// vera_layer_set_tilebase(byte zp($29) layer, byte zp($31) tilebase)
vera_layer_set_tilebase: {
    .label __0 = $29
    .label addr = $47
    .label layer = $29
    .label tilebase = $31
    // byte* addr = vera_layer_tilebase[layer]
    // [368] vera_layer_set_tilebase::$0 = vera_layer_set_tilebase::layer#0 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __0
    // [369] vera_layer_set_tilebase::addr#0 = vera_layer_tilebase[vera_layer_set_tilebase::$0] -- pbuz1=qbuc1_derefidx_vbuz2 
    ldy.z __0
    lda vera_layer_tilebase,y
    sta.z addr
    lda vera_layer_tilebase+1,y
    sta.z addr+1
    // *addr = tilebase
    // [370] *vera_layer_set_tilebase::addr#0 = vera_layer_set_tilebase::tilebase#0 -- _deref_pbuz1=vbuz2 
    lda.z tilebase
    ldy #0
    sta (addr),y
    // vera_layer_set_tilebase::@return
    // }
    // [371] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($42) c)
cputc: {
    .label __2 = $4e
    .label __4 = $4f
    .label __5 = $50
    .label __6 = $51
    .label __15 = $4d
    .label __16 = $53
    .label color = $24
    .label conio_screen_text = $49
    .label conio_map_width = $4b
    .label conio_addr = $49
    .label scroll_enable = $52
    .label c = $42
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [372] vera_layer_get_color::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_color.layer
    // [373] call vera_layer_get_color 
    // [405] phi from cputc to vera_layer_get_color [phi:cputc->vera_layer_get_color]
    // [405] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#0 [phi:cputc->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [374] vera_layer_get_color::return#3 = vera_layer_get_color::return#2
    // cputc::@7
    // char color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [375] cputc::color#0 = vera_layer_get_color::return#3
    // unsigned int conio_screen_text = cx16_conio.conio_screen_text
    // [376] cputc::conio_screen_text#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z conio_screen_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z conio_screen_text+1
    // word conio_map_width = cx16_conio.conio_map_width
    // [377] cputc::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [378] cputc::$15 = *((byte*)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __15
    // unsigned int conio_addr = conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [379] cputc::conio_addr#0 = cputc::conio_screen_text#0 + conio_line_text[cputc::$15] -- vwuz1=vwuz1_plus_pwuc1_derefidx_vbuz2 
    tay
    clc
    lda.z conio_addr
    adc conio_line_text,y
    sta.z conio_addr
    lda.z conio_addr+1
    adc conio_line_text+1,y
    sta.z conio_addr+1
    // conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [380] cputc::$2 = conio_cursor_x[*((byte*)&cx16_conio)] << 1 -- vbuz1=pbuc1_derefidx_(_deref_pbuc2)_rol_1 
    ldy cx16_conio
    lda conio_cursor_x,y
    asl
    sta.z __2
    // conio_addr += conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [381] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$2 -- vwuz1=vwuz1_plus_vbuz2 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [382] if(cputc::c#0==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [383] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <conio_addr
    // [384] cputc::$4 = < cputc::conio_addr#1 -- vbuz1=_lo_vwuz2 
    lda.z conio_addr
    sta.z __4
    // *VERA_ADDRX_L = <conio_addr
    // [385] *VERA_ADDRX_L = cputc::$4 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // >conio_addr
    // [386] cputc::$5 = > cputc::conio_addr#1 -- vbuz1=_hi_vwuz2 
    lda.z conio_addr+1
    sta.z __5
    // *VERA_ADDRX_M = >conio_addr
    // [387] *VERA_ADDRX_M = cputc::$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [388] cputc::$6 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    sta.z __6
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [389] *VERA_ADDRX_H = cputc::$6 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [390] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [391] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // conio_cursor_x[cx16_conio.conio_screen_layer]++;
    // [392] conio_cursor_x[*((byte*)&cx16_conio)] = ++ conio_cursor_x[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    ldy cx16_conio
    lda conio_cursor_x,x
    inc
    sta conio_cursor_x,y
    // byte scroll_enable = conio_scroll_enable[cx16_conio.conio_screen_layer]
    // [393] cputc::scroll_enable#0 = conio_scroll_enable[*((byte*)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_scroll_enable,y
    sta.z scroll_enable
    // if(scroll_enable)
    // [394] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuz1_then_la1 
    bne __b5
    // cputc::@3
    // (unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width
    // [395] cputc::$16 = (word)conio_cursor_x[*((byte*)&cx16_conio)] -- vwuz1=_word_pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_cursor_x,y
    sta.z __16
    lda #0
    sta.z __16+1
    // if((unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width)
    // [396] if(cputc::$16!=cputc::conio_map_width#0) goto cputc::@return -- vwuz1_neq_vwuz2_then_la1 
    cmp.z conio_map_width+1
    bne __breturn
    lda.z __16
    cmp.z conio_map_width
    bne __breturn
    // [397] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [398] call cputln 
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [399] return 
    rts
    // cputc::@5
  __b5:
    // if(conio_cursor_x[cx16_conio.conio_screen_layer] == cx16_conio.conio_screen_width)
    // [400] if(conio_cursor_x[*((byte*)&cx16_conio)]!=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto cputc::@return -- pbuc1_derefidx_(_deref_pbuc2)_neq__deref_pbuc3_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    ldy cx16_conio
    cmp conio_cursor_x,y
    bne __breturn
    // [401] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [402] call cputln 
    jsr cputln
    rts
    // [403] phi from cputc::@7 to cputc::@1 [phi:cputc::@7->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [404] call cputln 
    jsr cputln
    rts
}
  // vera_layer_get_color
/**
 * @brief Get the text and back color for text output in 16 color mode.
 * 
 * @param layer The layer of the vera 0/1.
 * @return vera_textcolor an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
 * This will only work when the VERA is in 16 color mode!
 * Note that on the VERA, the transparent color has value 0.
 */
// vera_layer_get_color(byte zp($24) layer)
vera_layer_get_color: {
    .label __0 = $58
    .label __1 = $59
    .label __3 = $55
    .label addr = $56
    .label return = $24
    .label layer = $24
    // byte* addr = vera_layer_config[layer]
    // [406] vera_layer_get_color::$3 = vera_layer_get_color::layer#2 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z layer
    asl
    sta.z __3
    // [407] vera_layer_get_color::addr#0 = vera_layer_config[vera_layer_get_color::$3] -- pbuz1=qbuc1_derefidx_vbuz2 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr & VERA_LAYER_CONFIG_256C
    // [408] vera_layer_get_color::$0 = *vera_layer_get_color::addr#0 & VERA_LAYER_CONFIG_256C -- vbuz1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C
    ldy #0
    and (addr),y
    sta.z __0
    // if( *addr & VERA_LAYER_CONFIG_256C )
    // [409] if(0!=vera_layer_get_color::$0) goto vera_layer_get_color::@1 -- 0_neq_vbuz1_then_la1 
    bne __b1
    // vera_layer_get_color::@2
    // vera_layer_backcolor[layer] << 4
    // [410] vera_layer_get_color::$1 = vera_layer_backcolor[vera_layer_get_color::layer#2] << 4 -- vbuz1=pbuc1_derefidx_vbuz2_rol_4 
    ldy.z layer
    lda vera_layer_backcolor,y
    asl
    asl
    asl
    asl
    sta.z __1
    // return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
    // [411] vera_layer_get_color::return#1 = vera_layer_get_color::$1 | vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuz1=vbuz2_bor_pbuc1_derefidx_vbuz1 
    ldy.z return
    ora vera_layer_textcolor,y
    sta.z return
    // [412] phi from vera_layer_get_color::@1 vera_layer_get_color::@2 to vera_layer_get_color::@return [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return]
    // [412] phi vera_layer_get_color::return#2 = vera_layer_get_color::return#0 [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return#0] -- register_copy 
    // vera_layer_get_color::@return
    // }
    // [413] return 
    rts
    // vera_layer_get_color::@1
  __b1:
    // return (vera_layer_textcolor[layer]);
    // [414] vera_layer_get_color::return#0 = vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_textcolor,y
    sta.z return
    rts
}
  // cputln
// Print a newline
cputln: {
    .label __2 = $55
    .label __3 = $58
    .label temp = $56
    // word temp = conio_line_text[cx16_conio.conio_screen_layer]
    // [415] cputln::$2 = *((byte*)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __2
    // [416] cputln::temp#0 = conio_line_text[cputln::$2] -- vwuz1=pwuc1_derefidx_vbuz2 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda conio_line_text,y
    sta.z temp
    lda conio_line_text+1,y
    sta.z temp+1
    // temp += cx16_conio.conio_rowskip
    // [417] cputln::temp#1 = cputln::temp#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z temp
    sta.z temp
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z temp+1
    sta.z temp+1
    // conio_line_text[cx16_conio.conio_screen_layer] = temp
    // [418] cputln::$3 = *((byte*)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __3
    // [419] conio_line_text[cputln::$3] = cputln::temp#1 -- pwuc1_derefidx_vbuz1=vwuz2 
    tay
    lda.z temp
    sta conio_line_text,y
    lda.z temp+1
    sta conio_line_text+1,y
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [420] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer]++;
    // [421] conio_cursor_y[*((byte*)&cx16_conio)] = ++ conio_cursor_y[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    lda conio_cursor_y,x
    inc
    sta conio_cursor_y,y
    // cscroll()
    // [422] call cscroll 
    jsr cscroll
    // cputln::@return
    // }
    // [423] return 
    rts
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [424] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    ldy cx16_conio
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b3
    // cscroll::@1
    // if(conio_scroll_enable[cx16_conio.conio_screen_layer])
    // [425] if(0!=conio_scroll_enable[*((byte*)&cx16_conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    lda conio_scroll_enable,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [426] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    // [427] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
  __b3:
    // cscroll::@return
    // }
    // [428] return 
    rts
    // [429] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [430] call insertup 
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, cx16_conio.conio_screen_height-1)
    // [431] gotoxy::y#2 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    stx.z gotoxy.y
    // [432] call gotoxy 
    // [168] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [168] phi gotoxy::y#4 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    jsr gotoxy
    // [433] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [434] call clearline 
    jsr clearline
    rts
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label __3 = $5b
    .label cy = $59
    .label width = $5a
    .label line = $5c
    .label start = $5c
    .label i = $51
    // unsigned byte cy = conio_cursor_y[cx16_conio.conio_screen_layer]
    // [435] insertup::cy#0 = conio_cursor_y[*((byte*)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy cx16_conio
    lda conio_cursor_y,y
    sta.z cy
    // unsigned byte width = cx16_conio.conio_screen_width * 2
    // [436] insertup::width#0 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    asl
    sta.z width
    // [437] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [437] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z i
    // insertup::@1
  __b1:
    // for(unsigned byte i=1; i<=cy; i++)
    // [438] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuz1_le_vbuz2_then_la1 
    lda.z cy
    cmp.z i
    bcs __b2
    // [439] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [440] call clearline 
    jsr clearline
    // insertup::@return
    // }
    // [441] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [442] insertup::$3 = insertup::i#2 - 1 -- vbuz1=vbuz2_minus_1 
    ldx.z i
    dex
    stx.z __3
    // unsigned int line = (i-1) << cx16_conio.conio_rowshift
    // [443] insertup::line#0 = insertup::$3 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vbuz2_rol__deref_pbuc1 
    txa
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
    // unsigned int start = cx16_conio.conio_screen_text + line
    // [444] insertup::start#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) + insertup::line#0 -- vwuz1=_deref_pwuc1_plus_vwuz1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    adc.z start
    sta.z start
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    adc.z start+1
    sta.z start+1
    // cx16_cpy_vram_from_vram_inc(0, start, VERA_INC_1, 0, start+cx16_conio.conio_rowskip, VERA_INC_1, width)
    // [445] cx16_cpy_vram_from_vram_inc::soffset_vram#0 = insertup::start#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz2_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z start
    sta.z cx16_cpy_vram_from_vram_inc.soffset_vram
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z start+1
    sta.z cx16_cpy_vram_from_vram_inc.soffset_vram+1
    // [446] cx16_cpy_vram_from_vram_inc::doffset_vram#0 = insertup::start#0
    // [447] cx16_cpy_vram_from_vram_inc::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z cx16_cpy_vram_from_vram_inc.num
    lda #0
    sta.z cx16_cpy_vram_from_vram_inc.num+1
    // [448] call cx16_cpy_vram_from_vram_inc 
    // [471] phi from insertup::@2 to cx16_cpy_vram_from_vram_inc [phi:insertup::@2->cx16_cpy_vram_from_vram_inc]
    jsr cx16_cpy_vram_from_vram_inc
    // insertup::@4
    // for(unsigned byte i=1; i<=cy; i++)
    // [449] insertup::i#1 = ++ insertup::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [437] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [437] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
}
  // clearline
clearline: {
    .label __1 = $63
    .label __2 = $64
    .label __5 = $62
    .label conio_screen_text = $5e
    .label conio_line = $60
    .label addr = $5e
    .label color = $24
    .label c = $53
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [450] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // word conio_screen_text =  (word)cx16_conio.conio_screen_text
    // [451] clearline::conio_screen_text#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- vwuz1=_deref_pwuc1 
    // Set address
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z conio_screen_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z conio_screen_text+1
    // word conio_line = conio_line_text[cx16_conio.conio_screen_layer]
    // [452] clearline::$5 = *((byte*)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __5
    // [453] clearline::conio_line#0 = conio_line_text[clearline::$5] -- vwuz1=pwuc1_derefidx_vbuz2 
    tay
    lda conio_line_text,y
    sta.z conio_line
    lda conio_line_text+1,y
    sta.z conio_line+1
    // conio_screen_text + conio_line
    // [454] clearline::addr#0 = clearline::conio_screen_text#0 + clearline::conio_line#0 -- vwuz1=vwuz1_plus_vwuz2 
    lda.z addr
    clc
    adc.z conio_line
    sta.z addr
    lda.z addr+1
    adc.z conio_line+1
    sta.z addr+1
    // <addr
    // [455] clearline::$1 = < (byte*)clearline::addr#0 -- vbuz1=_lo_pbuz2 
    lda.z addr
    sta.z __1
    // *VERA_ADDRX_L = <addr
    // [456] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >addr
    // [457] clearline::$2 = > (byte*)clearline::addr#0 -- vbuz1=_hi_pbuz2 
    lda.z addr+1
    sta.z __2
    // *VERA_ADDRX_M = >addr
    // [458] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [459] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [460] vera_layer_get_color::layer#1 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_color.layer
    // [461] call vera_layer_get_color 
    // [405] phi from clearline to vera_layer_get_color [phi:clearline->vera_layer_get_color]
    // [405] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#1 [phi:clearline->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [462] vera_layer_get_color::return#4 = vera_layer_get_color::return#2
    // clearline::@4
    // char color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [463] clearline::color#0 = vera_layer_get_color::return#4
    // [464] phi from clearline::@4 to clearline::@1 [phi:clearline::@4->clearline::@1]
    // [464] phi clearline::c#2 = 0 [phi:clearline::@4->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [465] if(clearline::c#2<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto clearline::@2 -- vwuz1_lt__deref_pbuc1_then_la1 
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
    // [466] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // clearline::@return
    // }
    // [467] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [468] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [469] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [470] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [464] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [464] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
    jmp __b1
}
  // cx16_cpy_vram_from_vram_inc
/**
 * @brief Copy block of memory from vram to vram with specified vera increments/decrements.  
 * Copies num bytes from the source vram bank/offset to the destination vram bank/offset, with specified increment/decrement.
 * 
 * @param dbank_vram Destination vram bank.
 * @param doffset_vram Destination vram offset.
 * @param dinc Destination vram increment/decrement. 
 * @param sbank_vram Source vram bank.
 * @param soffset_vram Source vram offset.
 * @param sinc Source vram increment/decrement.
 * @param num Amount of bytes to copy.
 */
// cx16_cpy_vram_from_vram_inc(word zp($5c) doffset_vram, word zp($5e) soffset_vram, word zp($60) num)
cx16_cpy_vram_from_vram_inc: {
    .label vera_vram_data0_bank_offset1___0 = $62
    .label vera_vram_data0_bank_offset1___1 = $63
    .label vera_vram_data1_bank_offset1___0 = $64
    .label vera_vram_data1_bank_offset1___1 = $65
    .label i = $53
    .label doffset_vram = $5c
    .label soffset_vram = $5e
    .label num = $60
    // cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [472] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [473] cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$0 = < cx16_cpy_vram_from_vram_inc::soffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z soffset_vram
    sta.z vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [474] *VERA_ADDRX_L = cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [475] cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$1 = > cx16_cpy_vram_from_vram_inc::soffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z soffset_vram+1
    sta.z vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [476] *VERA_ADDRX_M = cx16_cpy_vram_from_vram_inc::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [477] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1
    // *VERA_CTRL |= VERA_ADDRSEL
    // [478] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [479] cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$0 = < cx16_cpy_vram_from_vram_inc::doffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z doffset_vram
    sta.z vera_vram_data1_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [480] *VERA_ADDRX_L = cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [481] cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$1 = > cx16_cpy_vram_from_vram_inc::doffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z doffset_vram+1
    sta.z vera_vram_data1_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [482] *VERA_ADDRX_M = cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [483] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // [484] phi from cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1 to cx16_cpy_vram_from_vram_inc::@1 [phi:cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1->cx16_cpy_vram_from_vram_inc::@1]
    // [484] phi cx16_cpy_vram_from_vram_inc::i#2 = 0 [phi:cx16_cpy_vram_from_vram_inc::vera_vram_data1_bank_offset1->cx16_cpy_vram_from_vram_inc::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // cx16_cpy_vram_from_vram_inc::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [485] if(cx16_cpy_vram_from_vram_inc::i#2<cx16_cpy_vram_from_vram_inc::num#0) goto cx16_cpy_vram_from_vram_inc::@2 -- vwuz1_lt_vwuz2_then_la1 
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
    // [486] return 
    rts
    // cx16_cpy_vram_from_vram_inc::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [487] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [488] cx16_cpy_vram_from_vram_inc::i#1 = ++ cx16_cpy_vram_from_vram_inc::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [484] phi from cx16_cpy_vram_from_vram_inc::@2 to cx16_cpy_vram_from_vram_inc::@1 [phi:cx16_cpy_vram_from_vram_inc::@2->cx16_cpy_vram_from_vram_inc::@1]
    // [484] phi cx16_cpy_vram_from_vram_inc::i#2 = cx16_cpy_vram_from_vram_inc::i#1 [phi:cx16_cpy_vram_from_vram_inc::@2->cx16_cpy_vram_from_vram_inc::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment Data
  VERA_LAYER_WIDTH: .word $20, $40, $80, $100
  VERA_LAYER_HEIGHT: .word $20, $40, $80, $100
  /**
 * @file cx16-veralib.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Commander X16 vera library for the kickc compiler.
 * Commander X16 VERA (Versatile Embedded Retro Adapter) Video and Audio Processor
 * [https://github.com/commanderx16/x16-docs/blob/master/VERA%20Programmer's%20Reference.md]()
 * @version 0.1
 * @date 2021-06-14
 * 
 * @copyright Copyright (c) 2021
 * 
 */
  vera_mapbase_offset: .word 0, 0
  vera_mapbase_bank: .byte 0, 0
  vera_mapbase_address: .dword 0, 0
  vera_tilebase_offset: .word 0, 0
  vera_tilebase_bank: .byte 0, 0
  vera_tilebase_address: .dword 0, 0
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
