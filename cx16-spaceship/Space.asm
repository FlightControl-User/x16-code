  // File Comments
// Example program for the Commander X16
  // Upstart
.cpu _65c02
  // Create CX16 files containing the program and a sprite file
.file [name="Space.prg", type="prg", segments="Program"]
//.file [name="PLAYER", type="bin", segments="Player"]
//.file [name="ENEMY2", type="bin", segments="Enemy2"]
//.file [name="TILES", type="bin", segments="TileS"]
//.file [name="SQUAREMETAL", type="bin", segments="SquareMetal"]
//.file [name="TILEMETAL", type="bin", segments="TileMetal"]
//.file [name="SQUARERASTER", type="bin", segments="SquareRaster"]
//.file [name="PALETTES", type="bin", segments="Palettes"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code", align=$1000]
.segment Basic
:BasicUpstart(__start)
//.segmentdef Player 
//.segmentdef Enemy2 
//.segmentdef TileS 
//.segmentdef SquareMetal 
//.segmentdef TileMetal 
//.segmentdef SquareRaster 
//.segmentdef Palettes

  // Global Constants & labels
  // The colors of the CX16
  .const BLACK = 0
  .const WHITE = 1
  .const BLUE = 6
  // Location of default PETSCII character tiles in the VERA
  .const VERA_PETSCII_TILE = $f800
  .const VERA_PETSCII_TILE_SIZE = $80*8
  .const VERA_INC_1 = $10
  .const VERA_DCSEL = 2
  .const VERA_ADDRSEL = 1
  .const VERA_VSYNC = 1
  .const VERA_SPRITES_ENABLE = $40
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
  // VERA Palette address in VRAM  $1FA00 - $1FBFF
  // 256 entries of 2 bytes
  // byte 0 bits 4-7: Green
  // byte 0 bits 0-3: Blue
  // byte 1 bits 0-3: Red
  .const VERA_PALETTE = $1fa00
  // Sprite Attributes address in VERA VRAM $1FC00 - $1FFFF
  .const VERA_SPRITE_ATTR = $1fc00
  .const VERA_SPRITE_8BPP = $8000
  // Sprite flip
  .const VERA_SPRITE_HFLIP = 1
  // Horizontal flip of sprite
  .const VERA_SPRITE_VFLIP = 2
  .const VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0 = 4
  .const VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1 = 8
  .const VERA_SPRITE_ZDEPTH_IN_FRONT = $c
  .const VERA_SPRITE_ZDEPTH_MASK = $c
  .const VERA_SPRITE_WIDTH_16 = $10
  .const VERA_SPRITE_WIDTH_32 = $20
  .const VERA_SPRITE_WIDTH_64 = $30
  .const VERA_SPRITE_WIDTH_MASK = $30
  .const VERA_SPRITE_HEIGHT_16 = $40
  .const VERA_SPRITE_HEIGHT_32 = $80
  .const VERA_SPRITE_HEIGHT_64 = $c0
  .const VERA_SPRITE_HEIGHT_MASK = $c0
  .const VERA_SPRITE_PALETTE_OFFSET_MASK = $f
  .const CX16_ROM_KERNAL = 0
  .const CX16_ROM_BASIC = 4
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
  .const VERA_HEAP_EMPTY = 1
  .const VERA_HEAP_ADDRESS_16 = 2
  .const VERA_HEAP_SIZE_16 = 4
  .const VERA_HEAP_SIZE_MASK = $ffe0
  .const SIZEOF_STRUCT_VERA_HEAP = 8
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH = 4
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT = 5
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  .const SPRITE_PLAYER = 0
  .const SPRITE_ENEMY2 = 1
  .const TILE_TILEMETAL = 1
  .const TILE_SQUARERASTER = 2
  .const HEAP_SPRITES = 0
  .const HEAP_FLOOR_MAP = 1
  .const HEAP_FLOOR_TILE = 2
  .const HEAP_PETSCII = 3
  .const VRAM_PETSCII_TILE = $1f000
  .const SIZEOF_POINTER = 2
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const OFFSET_STRUCT_MOS6522_VIA_PORT_A = 1
  .const OFFSET_STRUCT_VERA_HEAP_SEGMENT_BASE_ADDRESS = $c
  .const OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS = 4
  .const OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS = 8
  .const OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK = $10
  .const OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK = $12
  .const OFFSET_STRUCT_VERA_HEAP_SIZE = 2
  .const OFFSET_STRUCT_VERA_HEAP_NEXT = 4
  .const OFFSET_STRUCT_VERA_HEAP_PREV = 6
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT = 1
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT = 8
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH = 6
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK = 3
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP = $b
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT = $a
  .const OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR = $d
  .const OFFSET_STRUCT_TILE_OFFSET = $10
  .const OFFSET_STRUCT_TILE_DRAWTOTAL = $17
  .const OFFSET_STRUCT_TILE_DRAWCOUNT = $18
  .const OFFSET_STRUCT_TILE_DRAWCOLUMNS = $1a
  .const OFFSET_STRUCT_TILE_PALETTE = $1b
  .const OFFSET_STRUCT_SPRITE_OFFSET = $10
  .const OFFSET_STRUCT_SPRITE_SPRITECOUNT = $11
  .const OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES = $21
  .const OFFSET_STRUCT_SPRITE_BPP = $1b
  .const OFFSET_STRUCT_SPRITE_HEIGHT = $17
  .const OFFSET_STRUCT_SPRITE_WIDTH = $16
  .const OFFSET_STRUCT_SPRITE_ZDEPTH = $1a
  .const OFFSET_STRUCT_SPRITE_HFLIP = $18
  .const OFFSET_STRUCT_SPRITE_VFLIP = $19
  .const OFFSET_STRUCT_SPRITE_PALETTE = $1c
  .const OFFSET_STRUCT_SPRITE_BRAM_ADDRESS = $1d
  .const OFFSET_STRUCT_TILE_BRAM_ADDRESS = $1c
  .const OFFSET_STRUCT_TILE_VRAM_ADDRESSES = $20
  .const OFFSET_STRUCT_SPRITE_SPRITESIZE = $14
  .const OFFSET_STRUCT_TILE_TILECOUNT = $12
  .const OFFSET_STRUCT_TILE_TILESIZE = $15
  .const OFFSET_STRUCT_SPRITE_TOTALSIZE = $12
  .const OFFSET_STRUCT_TILE_TOTALSIZE = $13
  // Implements functions for static and dynamic memory management for VERA VRAM memory.
  .const vera_heap_ram_bank = $3f
  .const SIZEOF_STRUCT_CX16_CONIO = $e
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
  // $9F26	IEN		Interrupt Enable
  // Bit 7: IRQ line (8)
  // Bit 3: AFLOW
  // Bit 2: SPRCOL
  // Bit 1: LINE
  // Bit 0: VSYNC
  .label VERA_IEN = $9f26
  // $9F27	ISR     Interrupt Status
  // Interrupts will be generated for the interrupt sources set in the lower 4 bits of IEN. ISR will indicate the interrupts that have occurred.
  // Writing a 1 to one of the lower 3 bits in ISR will clear that interrupt status. AFLOW can only be cleared by filling the audio FIFO for at least 1/4.
  // Bit 4-7: Sprite Collisions. This field indicates which groups of sprites have collided.
  // Bit 3: AFLOW
  // Bit 2: SPRCOL
  // Bit 1: LINE
  // Bit 0: VSYNC
  .label VERA_ISR = $9f27
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
  // $9F32	L0_VSCROLL_L	Layer 0 V-Scroll (7:0)
  .label VERA_L0_VSCROLL_L = $9f32
  // $9F33	L0_VSCROLL_H    Layer 0 V-Scroll (11:8)
  .label VERA_L0_VSCROLL_H = $9f33
  // $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  // $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  // $9F36	L1_TILEBASE	    Layer 1 Tile Base
  // Bit 2-7: Tile Base Address (16:11)
  // Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  // Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L1_TILEBASE = $9f36
  // $9F39	L1_VSCROLL_L	Layer 1 V-Scroll (7:0)
  .label VERA_L1_VSCROLL_L = $9f39
  // $9F3A	L1_VSCROLL_H	Layer 1 V-Scroll (11:8)
  .label VERA_L1_VSCROLL_H = $9f3a
  // The VIA#1: ROM/RAM Bank Control
  // Port A Bits 0-7 RAM bank
  // Port B Bits 0-2 ROM bank
  // Port B Bits 3-7 [TBD]
  .label VIA1 = $9f60
  // $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .label vram_floor_map = $28
  // The random state variable
  .label rand_state = $1d
  // Remainder after unsigned 16-bit division
  .label rem16u = $22
.segment Code
  // __start
__start: {
    // __start::__init1
    // vram_floor_map
    // [1] vram_floor_map = 0 -- vduz1=vduc1 
    lda #<0
    sta.z vram_floor_map
    sta.z vram_floor_map+1
    lda #<0>>$10
    sta.z vram_floor_map+2
    lda #>0>>$10
    sta.z vram_floor_map+3
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [2] call conio_x16_init 
    jsr conio_x16_init
    // [3] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [4] call main 
    jsr main
    // __start::@return
    // [5] return 
    rts
}
  // irq_vsync
//VSYNC Interrupt Routine
irq_vsync: {
    .label __2 = $2c
    .label __13 = 3
    .label __19 = $2e
    .label __20 = $2e
    .label __21 = $2e
    .label __22 = $2e
    .label __24 = $34
    .label __25 = $34
    .label __26 = $34
    .label __35 = $2c
    .label vera_layer_set_vertical_scroll1_scroll = $3a
    .label dest_row = $30
    .label src_row = $36
    .label c = 3
    // interrupt(isr_rom_sys_cx16_entry) -- isr_rom_sys_cx16_entry 
    // a--;
    // [7] a = -- a -- vbum1=_dec_vbum1 
    dec a
    // if(a==0)
    // [8] if(a!=0) goto irq_vsync::@1 -- vbum1_neq_0_then_la1 
    lda a
    bne __b1
    // irq_vsync::@3
    // a=4
    // [9] a = 4 -- vbum1=vbuc1 
    lda #4
    sta a
    // rotate_sprites(i,  SpriteDB[SPRITE_PLAYER], 40, 100)
    // [10] rotate_sprites::rotate#0 = i -- vwuz1=vbum2 
    lda i
    sta.z rotate_sprites.rotate
    lda #0
    sta.z rotate_sprites.rotate+1
    // [11] rotate_sprites::Sprite#0 = *SpriteDB -- pssz1=_deref_qssc1 
    lda SpriteDB
    sta.z rotate_sprites.Sprite
    lda SpriteDB+1
    sta.z rotate_sprites.Sprite+1
    // [12] call rotate_sprites 
    // [240] phi from irq_vsync::@3 to rotate_sprites [phi:irq_vsync::@3->rotate_sprites]
    // [240] phi rotate_sprites::basex#8 = $28 [phi:irq_vsync::@3->rotate_sprites#0] -- vwuz1=vbuc1 
    lda #<$28
    sta.z rotate_sprites.basex
    lda #>$28
    sta.z rotate_sprites.basex+1
    // [240] phi rotate_sprites::rotate#4 = rotate_sprites::rotate#0 [phi:irq_vsync::@3->rotate_sprites#1] -- register_copy 
    // [240] phi rotate_sprites::Sprite#2 = rotate_sprites::Sprite#0 [phi:irq_vsync::@3->rotate_sprites#2] -- register_copy 
    jsr rotate_sprites
    // irq_vsync::@16
    // rotate_sprites(j, SpriteDB[SPRITE_ENEMY2], 340, 100)
    // [13] rotate_sprites::rotate#1 = j -- vwuz1=vbum2 
    lda j
    sta.z rotate_sprites.rotate
    lda #0
    sta.z rotate_sprites.rotate+1
    // [14] rotate_sprites::Sprite#1 = *(SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER
    sta.z rotate_sprites.Sprite
    lda SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER+1
    sta.z rotate_sprites.Sprite+1
    // [15] call rotate_sprites 
    // [240] phi from irq_vsync::@16 to rotate_sprites [phi:irq_vsync::@16->rotate_sprites]
    // [240] phi rotate_sprites::basex#8 = $154 [phi:irq_vsync::@16->rotate_sprites#0] -- vwuz1=vwuc1 
    lda #<$154
    sta.z rotate_sprites.basex
    lda #>$154
    sta.z rotate_sprites.basex+1
    // [240] phi rotate_sprites::rotate#4 = rotate_sprites::rotate#1 [phi:irq_vsync::@16->rotate_sprites#1] -- register_copy 
    // [240] phi rotate_sprites::Sprite#2 = rotate_sprites::Sprite#1 [phi:irq_vsync::@16->rotate_sprites#2] -- register_copy 
    jsr rotate_sprites
    // irq_vsync::@17
    // i++;
    // [16] i = ++ i -- vbum1=_inc_vbum1 
    inc i
    // if(i>=12)
    // [17] if(i<$c) goto irq_vsync::@8 -- vbum1_lt_vbuc1_then_la1 
    lda i
    cmp #$c
    bcc __b8
    // irq_vsync::@4
    // i=0
    // [18] i = 0 -- vbum1=vbuc1 
    lda #0
    sta i
    // irq_vsync::@8
  __b8:
    // j++;
    // [19] j = ++ j -- vbum1=_inc_vbum1 
    inc j
    // if(j>=12)
    // [20] if(j<$c) goto irq_vsync::@1 -- vbum1_lt_vbuc1_then_la1 
    lda j
    cmp #$c
    bcc __b1
    // irq_vsync::@9
    // j=0
    // [21] j = 0 -- vbum1=vbuc1 
    lda #0
    sta j
    // irq_vsync::@1
  __b1:
    // if(scroll_action--)
    // [22] irq_vsync::$2 = scroll_action -- vwuz1=vwum2 
    lda scroll_action
    sta.z __2
    lda scroll_action+1
    sta.z __2+1
    // [23] scroll_action = -- scroll_action -- vwum1=_dec_vwum1 
    lda scroll_action
    bne !+
    dec scroll_action+1
  !:
    dec scroll_action
    // [24] if(0==irq_vsync::$2) goto irq_vsync::@2 -- 0_eq_vwuz1_then_la1 
    lda.z __2
    ora.z __2+1
    bne !__b2+
    jmp __b2
  !__b2:
    // irq_vsync::@5
    // scroll_action = 10
    // [25] scroll_action = $a -- vwum1=vbuc1 
    lda #<$a
    sta scroll_action
    lda #>$a
    sta scroll_action+1
    // <vscroll
    // [26] irq_vsync::$12 = < vscroll -- vbuaa=_lo_vwum1 
    lda vscroll
    // <vscroll & 0x80
    // [27] irq_vsync::$13 = irq_vsync::$12 & $80 -- vbuz1=vbuaa_band_vbuc1 
    and #$80
    sta.z __13
    // <vscroll
    // [28] irq_vsync::$14 = < vscroll -- vbuaa=_lo_vwum1 
    lda vscroll
    // if((<vscroll & 0x80)==<vscroll)
    // [29] if(irq_vsync::$13!=irq_vsync::$14) goto irq_vsync::@10 -- vbuz1_neq_vbuaa_then_la1 
    cmp.z __13
    beq !__b10+
    jmp __b10
  !__b10:
    // irq_vsync::@6
    // if(row<=4)
    // [30] if(row>=4+1) goto irq_vsync::@11 -- vwum1_ge_vbuc1_then_la1 
    lda row+1
    beq !__b11+
    jmp __b11
  !__b11:
    lda row
    cmp #4+1
    bcc !__b11+
    jmp __b11
  !__b11:
  !:
    // irq_vsync::@7
    // row+4
    // [31] irq_vsync::$19 = row + 4 -- vwuz1=vwum2_plus_vbuc1 
    lda #4
    clc
    adc row
    sta.z __19
    lda #0
    adc row+1
    sta.z __19+1
    // (row+4)*8
    // [32] irq_vsync::$20 = irq_vsync::$19 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z __20
    rol.z __20+1
    asl.z __20
    rol.z __20+1
    asl.z __20
    rol.z __20+1
    // (row+4)*8*64
    // [33] irq_vsync::$21 = irq_vsync::$20 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z __21+1
    lsr
    sta.z $ff
    lda.z __21
    ror
    sta.z __21+1
    lda #0
    ror
    sta.z __21
    lsr.z $ff
    ror.z __21+1
    ror.z __21
    // (row+4)*8*64*2
    // [34] irq_vsync::$22 = irq_vsync::$21 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z __22
    rol.z __22+1
    // dest_row = vram_floor_map+((row+4)*8*64*2)
    // [35] irq_vsync::dest_row#0 = vram_floor_map + irq_vsync::$22 -- vduz1=vduz2_plus_vwuz3 
    lda.z vram_floor_map
    clc
    adc.z __22
    sta.z dest_row
    lda.z vram_floor_map+1
    adc.z __22+1
    sta.z dest_row+1
    lda.z vram_floor_map+2
    adc #0
    sta.z dest_row+2
    lda.z vram_floor_map+3
    adc #0
    sta.z dest_row+3
    // row*8
    // [36] irq_vsync::$24 = row << 3 -- vwuz1=vwum2_rol_3 
    lda row
    asl
    sta.z __24
    lda row+1
    rol
    sta.z __24+1
    asl.z __24
    rol.z __24+1
    asl.z __24
    rol.z __24+1
    // row*8*64
    // [37] irq_vsync::$25 = irq_vsync::$24 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z __25+1
    lsr
    sta.z $ff
    lda.z __25
    ror
    sta.z __25+1
    lda #0
    ror
    sta.z __25
    lsr.z $ff
    ror.z __25+1
    ror.z __25
    // row*8*64*2
    // [38] irq_vsync::$26 = irq_vsync::$25 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z __26
    rol.z __26+1
    // src_row = vram_floor_map+(row*8*64*2)
    // [39] irq_vsync::src_row#0 = vram_floor_map + irq_vsync::$26 -- vduz1=vduz2_plus_vwuz3 
    lda.z vram_floor_map
    clc
    adc.z __26
    sta.z src_row
    lda.z vram_floor_map+1
    adc.z __26+1
    sta.z src_row+1
    lda.z vram_floor_map+2
    adc #0
    sta.z src_row+2
    lda.z vram_floor_map+3
    adc #0
    sta.z src_row+3
    // vera_cpy_vram_vram(src_row, dest_row, (dword)64*8*2)
    // [40] vera_cpy_vram_vram::vsrc#0 = irq_vsync::src_row#0 -- vduz1=vduz2 
    lda.z src_row
    sta.z vera_cpy_vram_vram.vsrc
    lda.z src_row+1
    sta.z vera_cpy_vram_vram.vsrc+1
    lda.z src_row+2
    sta.z vera_cpy_vram_vram.vsrc+2
    lda.z src_row+3
    sta.z vera_cpy_vram_vram.vsrc+3
    // [41] vera_cpy_vram_vram::vdest#0 = irq_vsync::dest_row#0 -- vduz1=vduz2 
    lda.z dest_row
    sta.z vera_cpy_vram_vram.vdest
    lda.z dest_row+1
    sta.z vera_cpy_vram_vram.vdest+1
    lda.z dest_row+2
    sta.z vera_cpy_vram_vram.vdest+2
    lda.z dest_row+3
    sta.z vera_cpy_vram_vram.vdest+3
    // [42] call vera_cpy_vram_vram 
    // [302] phi from irq_vsync::@7 to vera_cpy_vram_vram [phi:irq_vsync::@7->vera_cpy_vram_vram]
    // [302] phi vera_cpy_vram_vram::num#3 = $40*8*2 [phi:irq_vsync::@7->vera_cpy_vram_vram#0] -- vduz1=vduc1 
    lda #<$40*8*2
    sta.z vera_cpy_vram_vram.num
    lda #>$40*8*2
    sta.z vera_cpy_vram_vram.num+1
    lda #<$40*8*2>>$10
    sta.z vera_cpy_vram_vram.num+2
    lda #>$40*8*2>>$10
    sta.z vera_cpy_vram_vram.num+3
    // [302] phi vera_cpy_vram_vram::vdest#2 = vera_cpy_vram_vram::vdest#0 [phi:irq_vsync::@7->vera_cpy_vram_vram#1] -- register_copy 
    // [302] phi vera_cpy_vram_vram::vsrc#2 = vera_cpy_vram_vram::vsrc#0 [phi:irq_vsync::@7->vera_cpy_vram_vram#2] -- register_copy 
    jsr vera_cpy_vram_vram
    // [43] phi from irq_vsync::@7 to irq_vsync::@24 [phi:irq_vsync::@7->irq_vsync::@24]
    // irq_vsync::@24
    // gotoxy(0, 21)
    // [44] call gotoxy 
    // [330] phi from irq_vsync::@24 to gotoxy [phi:irq_vsync::@24->gotoxy]
    // [330] phi gotoxy::y#7 = $15 [phi:irq_vsync::@24->gotoxy#0] -- vbuxx=vbuc1 
    ldx #$15
    jsr gotoxy
    // [45] phi from irq_vsync::@24 to irq_vsync::@25 [phi:irq_vsync::@24->irq_vsync::@25]
    // irq_vsync::@25
    // printf("src_row:%x dest_row:%x vram_floor_map:%x   ",src_row, dest_row, vram_floor_map)
    // [46] call cputs 
    // [343] phi from irq_vsync::@25 to cputs [phi:irq_vsync::@25->cputs]
    // [343] phi cputs::s#26 = irq_vsync::s3 [phi:irq_vsync::@25->cputs#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // irq_vsync::@26
    // printf("src_row:%x dest_row:%x vram_floor_map:%x   ",src_row, dest_row, vram_floor_map)
    // [47] printf_ulong::uvalue#0 = irq_vsync::src_row#0 -- vduz1=vduz2 
    lda.z src_row
    sta.z printf_ulong.uvalue
    lda.z src_row+1
    sta.z printf_ulong.uvalue+1
    lda.z src_row+2
    sta.z printf_ulong.uvalue+2
    lda.z src_row+3
    sta.z printf_ulong.uvalue+3
    // [48] call printf_ulong 
    // [351] phi from irq_vsync::@26 to printf_ulong [phi:irq_vsync::@26->printf_ulong]
    // [351] phi printf_ulong::uvalue#10 = printf_ulong::uvalue#0 [phi:irq_vsync::@26->printf_ulong#0] -- register_copy 
    jsr printf_ulong
    // [49] phi from irq_vsync::@26 to irq_vsync::@27 [phi:irq_vsync::@26->irq_vsync::@27]
    // irq_vsync::@27
    // printf("src_row:%x dest_row:%x vram_floor_map:%x   ",src_row, dest_row, vram_floor_map)
    // [50] call cputs 
    // [343] phi from irq_vsync::@27 to cputs [phi:irq_vsync::@27->cputs]
    // [343] phi cputs::s#26 = irq_vsync::s4 [phi:irq_vsync::@27->cputs#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // irq_vsync::@28
    // printf("src_row:%x dest_row:%x vram_floor_map:%x   ",src_row, dest_row, vram_floor_map)
    // [51] printf_ulong::uvalue#1 = irq_vsync::dest_row#0 -- vduz1=vduz2 
    lda.z dest_row
    sta.z printf_ulong.uvalue
    lda.z dest_row+1
    sta.z printf_ulong.uvalue+1
    lda.z dest_row+2
    sta.z printf_ulong.uvalue+2
    lda.z dest_row+3
    sta.z printf_ulong.uvalue+3
    // [52] call printf_ulong 
    // [351] phi from irq_vsync::@28 to printf_ulong [phi:irq_vsync::@28->printf_ulong]
    // [351] phi printf_ulong::uvalue#10 = printf_ulong::uvalue#1 [phi:irq_vsync::@28->printf_ulong#0] -- register_copy 
    jsr printf_ulong
    // [53] phi from irq_vsync::@28 to irq_vsync::@29 [phi:irq_vsync::@28->irq_vsync::@29]
    // irq_vsync::@29
    // printf("src_row:%x dest_row:%x vram_floor_map:%x   ",src_row, dest_row, vram_floor_map)
    // [54] call cputs 
    // [343] phi from irq_vsync::@29 to cputs [phi:irq_vsync::@29->cputs]
    // [343] phi cputs::s#26 = irq_vsync::s5 [phi:irq_vsync::@29->cputs#0] -- pbuz1=pbuc1 
    lda #<s5
    sta.z cputs.s
    lda #>s5
    sta.z cputs.s+1
    jsr cputs
    // irq_vsync::@30
    // printf("src_row:%x dest_row:%x vram_floor_map:%x   ",src_row, dest_row, vram_floor_map)
    // [55] printf_ulong::uvalue#2 = vram_floor_map -- vduz1=vduz2 
    lda.z vram_floor_map
    sta.z printf_ulong.uvalue
    lda.z vram_floor_map+1
    sta.z printf_ulong.uvalue+1
    lda.z vram_floor_map+2
    sta.z printf_ulong.uvalue+2
    lda.z vram_floor_map+3
    sta.z printf_ulong.uvalue+3
    // [56] call printf_ulong 
    // [351] phi from irq_vsync::@30 to printf_ulong [phi:irq_vsync::@30->printf_ulong]
    // [351] phi printf_ulong::uvalue#10 = printf_ulong::uvalue#2 [phi:irq_vsync::@30->printf_ulong#0] -- register_copy 
    jsr printf_ulong
    // [57] phi from irq_vsync::@30 to irq_vsync::@31 [phi:irq_vsync::@30->irq_vsync::@31]
    // irq_vsync::@31
    // printf("src_row:%x dest_row:%x vram_floor_map:%x   ",src_row, dest_row, vram_floor_map)
    // [58] call cputs 
    // [343] phi from irq_vsync::@31 to cputs [phi:irq_vsync::@31->cputs]
    // [343] phi cputs::s#26 = irq_vsync::s6 [phi:irq_vsync::@31->cputs#0] -- pbuz1=pbuc1 
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
    // irq_vsync::@11
  __b11:
    // if(vscroll==0)
    // [59] if(vscroll!=0) goto irq_vsync::@12 -- vwum1_neq_0_then_la1 
    lda vscroll
    ora vscroll+1
    bne __b3
    // irq_vsync::@15
    // vscroll=128*4
    // [60] vscroll = (word)$80*4 -- vwum1=vwuc1 
    lda #<$80*4
    sta vscroll
    lda #>$80*4
    sta vscroll+1
    // row = 4
    // [61] row = 4 -- vwum1=vbuc1 
    lda #<4
    sta row
    lda #>4
    sta row+1
    // [62] phi from irq_vsync::@11 irq_vsync::@15 to irq_vsync::@12 [phi:irq_vsync::@11/irq_vsync::@15->irq_vsync::@12]
  __b3:
    // [62] phi rand_state#23 = rand_state#39 [phi:irq_vsync::@11/irq_vsync::@15->irq_vsync::@12#0] -- register_copy 
    // [62] phi irq_vsync::c#2 = 0 [phi:irq_vsync::@11/irq_vsync::@15->irq_vsync::@12#1] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // irq_vsync::@12
  __b12:
    // for(byte c=0;c<5;c++)
    // [63] if(irq_vsync::c#2<5) goto irq_vsync::@13 -- vbuz1_lt_vbuc1_then_la1 
    lda.z c
    cmp #5
    bcs !__b13+
    jmp __b13
  !__b13:
    // irq_vsync::@14
    // row--;
    // [64] row = -- row -- vwum1=_dec_vwum1 
    lda row
    bne !+
    dec row+1
  !:
    dec row
    // irq_vsync::@10
  __b10:
    // vscroll--;
    // [65] vscroll = -- vscroll -- vwum1=_dec_vwum1 
    lda vscroll
    bne !+
    dec vscroll+1
  !:
    dec vscroll
    // vera_layer_set_vertical_scroll(0,vscroll)
    // [66] irq_vsync::vera_layer_set_vertical_scroll1_scroll#0 = vscroll -- vwuz1=vwum2 
    lda vscroll
    sta.z vera_layer_set_vertical_scroll1_scroll
    lda vscroll+1
    sta.z vera_layer_set_vertical_scroll1_scroll+1
    // irq_vsync::vera_layer_set_vertical_scroll1
    // <scroll
    // [67] irq_vsync::vera_layer_set_vertical_scroll1_$0 = < irq_vsync::vera_layer_set_vertical_scroll1_scroll#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_layer_set_vertical_scroll1_scroll
    // *vera_layer_vscroll_l[layer] = <scroll
    // [68] *(*vera_layer_vscroll_l) = irq_vsync::vera_layer_set_vertical_scroll1_$0 -- _deref_(_deref_qbuc1)=vbuaa 
    ldy vera_layer_vscroll_l
    sty.z $fe
    ldy vera_layer_vscroll_l+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // >scroll
    // [69] irq_vsync::vera_layer_set_vertical_scroll1_$1 = > irq_vsync::vera_layer_set_vertical_scroll1_scroll#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_layer_set_vertical_scroll1_scroll+1
    // *vera_layer_vscroll_h[layer] = >scroll
    // [70] *(*vera_layer_vscroll_h) = irq_vsync::vera_layer_set_vertical_scroll1_$1 -- _deref_(_deref_qbuc1)=vbuaa 
    ldy vera_layer_vscroll_h
    sty.z $fe
    ldy vera_layer_vscroll_h+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // [71] phi from irq_vsync::@1 irq_vsync::vera_layer_set_vertical_scroll1 to irq_vsync::@2 [phi:irq_vsync::@1/irq_vsync::vera_layer_set_vertical_scroll1->irq_vsync::@2]
    // irq_vsync::@2
  __b2:
    // gotoxy(0, 20)
    // [72] call gotoxy 
    // [330] phi from irq_vsync::@2 to gotoxy [phi:irq_vsync::@2->gotoxy]
    // [330] phi gotoxy::y#7 = $14 [phi:irq_vsync::@2->gotoxy#0] -- vbuxx=vbuc1 
    ldx #$14
    jsr gotoxy
    // [73] phi from irq_vsync::@2 to irq_vsync::@18 [phi:irq_vsync::@2->irq_vsync::@18]
    // irq_vsync::@18
    // printf("vscroll:%u row:%u     ",vscroll, row)
    // [74] call cputs 
    // [343] phi from irq_vsync::@18 to cputs [phi:irq_vsync::@18->cputs]
    // [343] phi cputs::s#26 = irq_vsync::s [phi:irq_vsync::@18->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // irq_vsync::@19
    // printf("vscroll:%u row:%u     ",vscroll, row)
    // [75] printf_uint::uvalue#0 = vscroll -- vwuz1=vwum2 
    lda vscroll
    sta.z printf_uint.uvalue
    lda vscroll+1
    sta.z printf_uint.uvalue+1
    // [76] call printf_uint 
    // [358] phi from irq_vsync::@19 to printf_uint [phi:irq_vsync::@19->printf_uint]
    // [358] phi printf_uint::uvalue#2 = printf_uint::uvalue#0 [phi:irq_vsync::@19->printf_uint#0] -- register_copy 
    jsr printf_uint
    // [77] phi from irq_vsync::@19 to irq_vsync::@20 [phi:irq_vsync::@19->irq_vsync::@20]
    // irq_vsync::@20
    // printf("vscroll:%u row:%u     ",vscroll, row)
    // [78] call cputs 
    // [343] phi from irq_vsync::@20 to cputs [phi:irq_vsync::@20->cputs]
    // [343] phi cputs::s#26 = irq_vsync::s1 [phi:irq_vsync::@20->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // irq_vsync::@21
    // printf("vscroll:%u row:%u     ",vscroll, row)
    // [79] printf_uint::uvalue#1 = row -- vwuz1=vwum2 
    lda row
    sta.z printf_uint.uvalue
    lda row+1
    sta.z printf_uint.uvalue+1
    // [80] call printf_uint 
    // [358] phi from irq_vsync::@21 to printf_uint [phi:irq_vsync::@21->printf_uint]
    // [358] phi printf_uint::uvalue#2 = printf_uint::uvalue#1 [phi:irq_vsync::@21->printf_uint#0] -- register_copy 
    jsr printf_uint
    // [81] phi from irq_vsync::@21 to irq_vsync::@22 [phi:irq_vsync::@21->irq_vsync::@22]
    // irq_vsync::@22
    // printf("vscroll:%u row:%u     ",vscroll, row)
    // [82] call cputs 
    // [343] phi from irq_vsync::@22 to cputs [phi:irq_vsync::@22->cputs]
    // [343] phi cputs::s#26 = irq_vsync::s2 [phi:irq_vsync::@22->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // irq_vsync::@23
    // *VERA_ISR = VERA_VSYNC
    // [83] *VERA_ISR = VERA_VSYNC -- _deref_pbuc1=vbuc2 
    // Reset the VSYNC interrupt
    lda #VERA_VSYNC
    sta VERA_ISR
    // irq_vsync::@return
    // }
    // [84] return 
    // interrupt(isr_rom_sys_cx16_exit) -- isr_rom_sys_cx16_exit 
    jmp $e034
    // [85] phi from irq_vsync::@12 to irq_vsync::@13 [phi:irq_vsync::@12->irq_vsync::@13]
    // irq_vsync::@13
  __b13:
    // rand()
    // [86] call rand 
    // [365] phi from irq_vsync::@13 to rand [phi:irq_vsync::@13->rand]
    // [365] phi rand_state#13 = rand_state#23 [phi:irq_vsync::@13->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [87] rand::return#2 = rand::return#0
    // irq_vsync::@32
    // modr16u(rand(),3,0)
    // [88] modr16u::dividend#0 = rand::return#2
    // [89] call modr16u 
    // [374] phi from irq_vsync::@32 to modr16u [phi:irq_vsync::@32->modr16u]
    // [374] phi modr16u::dividend#2 = modr16u::dividend#0 [phi:irq_vsync::@32->modr16u#0] -- register_copy 
    jsr modr16u
    // modr16u(rand(),3,0)
    // [90] modr16u::return#2 = modr16u::return#0
    // irq_vsync::@33
    // [91] irq_vsync::$35 = modr16u::return#2 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z __35
    lda.z modr16u.return+1
    sta.z __35+1
    // rnd = (byte)modr16u(rand(),3,0)
    // [92] irq_vsync::rnd#0 = (byte)irq_vsync::$35 -- vbuxx=_byte_vwuz1 
    lda.z __35
    tax
    // (byte)row-1
    // [93] irq_vsync::$42 = (byte)row -- vbuaa=_byte_vwum1 
    lda row
    // vera_tile_element( 0, c, (byte)row-1, 3, TileDB[rnd])
    // [94] vera_tile_element::y#1 = irq_vsync::$42 - 1 -- vbuz1=vbuaa_minus_1 
    sec
    sbc #1
    sta.z vera_tile_element.y
    // [95] irq_vsync::$41 = irq_vsync::rnd#0 << 1 -- vbuxx=vbuxx_rol_1 
    txa
    asl
    tax
    // [96] vera_tile_element::x#1 = irq_vsync::c#2 -- vbuz1=vbuz2 
    lda.z c
    sta.z vera_tile_element.x
    // [97] vera_tile_element::Tile#0 = TileDB[irq_vsync::$41] -- pssz1=qssc1_derefidx_vbuxx 
    lda TileDB,x
    sta.z vera_tile_element.Tile
    lda TileDB+1,x
    sta.z vera_tile_element.Tile+1
    // [98] call vera_tile_element 
    // [379] phi from irq_vsync::@33 to vera_tile_element [phi:irq_vsync::@33->vera_tile_element]
    // [379] phi vera_tile_element::y#3 = vera_tile_element::y#1 [phi:irq_vsync::@33->vera_tile_element#0] -- register_copy 
    // [379] phi vera_tile_element::x#3 = vera_tile_element::x#1 [phi:irq_vsync::@33->vera_tile_element#1] -- register_copy 
    // [379] phi vera_tile_element::Tile#2 = vera_tile_element::Tile#0 [phi:irq_vsync::@33->vera_tile_element#2] -- register_copy 
    jsr vera_tile_element
    // irq_vsync::@34
    // for(byte c=0;c<5;c++)
    // [99] irq_vsync::c#1 = ++ irq_vsync::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [62] phi from irq_vsync::@34 to irq_vsync::@12 [phi:irq_vsync::@34->irq_vsync::@12]
    // [62] phi rand_state#23 = rand_state#14 [phi:irq_vsync::@34->irq_vsync::@12#0] -- register_copy 
    // [62] phi irq_vsync::c#2 = irq_vsync::c#1 [phi:irq_vsync::@34->irq_vsync::@12#1] -- register_copy 
    jmp __b12
  .segment Data
    s: .text "vscroll:"
    .byte 0
    s1: .text " row:"
    .byte 0
    s2: .text "     "
    .byte 0
    s3: .text "src_row:"
    .byte 0
    s4: .text " dest_row:"
    .byte 0
    s5: .text " vram_floor_map:"
    .byte 0
    s6: .text "   "
    .byte 0
}
.segment Code
  // conio_x16_init
// Set initial cursor position
conio_x16_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label line = 4
    // line = *BASIC_CURSOR_LINE
    // [100] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda BASIC_CURSOR_LINE
    sta.z line
    // vera_layer_mode_text(1,(dword)0x00000,(dword)0x0F800,128,64,8,8,16)
    // [101] call vera_layer_mode_text 
    // [432] phi from conio_x16_init to vera_layer_mode_text [phi:conio_x16_init->vera_layer_mode_text]
    jsr vera_layer_mode_text
    // [102] phi from conio_x16_init to conio_x16_init::@3 [phi:conio_x16_init->conio_x16_init::@3]
    // conio_x16_init::@3
    // screensize(&cx16_conio.conio_screen_width, &cx16_conio.conio_screen_height)
    // [103] call screensize 
    jsr screensize
    // [104] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // screenlayer(1)
    // [105] call screenlayer 
    jsr screenlayer
    // [106] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // vera_layer_set_textcolor(1, WHITE)
    // [107] call vera_layer_set_textcolor 
    // [474] phi from conio_x16_init::@5 to vera_layer_set_textcolor [phi:conio_x16_init::@5->vera_layer_set_textcolor]
    // [474] phi vera_layer_set_textcolor::layer#2 = 1 [phi:conio_x16_init::@5->vera_layer_set_textcolor#0] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_set_textcolor
    // [108] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // vera_layer_set_backcolor(1, BLUE)
    // [109] call vera_layer_set_backcolor 
    // [477] phi from conio_x16_init::@6 to vera_layer_set_backcolor [phi:conio_x16_init::@6->vera_layer_set_backcolor]
    // [477] phi vera_layer_set_backcolor::color#2 = BLUE [phi:conio_x16_init::@6->vera_layer_set_backcolor#0] -- vbuaa=vbuc1 
    lda #BLUE
    // [477] phi vera_layer_set_backcolor::layer#2 = 1 [phi:conio_x16_init::@6->vera_layer_set_backcolor#1] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_set_backcolor
    // [110] phi from conio_x16_init::@6 to conio_x16_init::@7 [phi:conio_x16_init::@6->conio_x16_init::@7]
    // conio_x16_init::@7
    // vera_layer_set_mapbase(0,0x20)
    // [111] call vera_layer_set_mapbase 
    // [480] phi from conio_x16_init::@7 to vera_layer_set_mapbase [phi:conio_x16_init::@7->vera_layer_set_mapbase]
    // [480] phi vera_layer_set_mapbase::mapbase#3 = $20 [phi:conio_x16_init::@7->vera_layer_set_mapbase#0] -- vbuxx=vbuc1 
    ldx #$20
    // [480] phi vera_layer_set_mapbase::layer#3 = 0 [phi:conio_x16_init::@7->vera_layer_set_mapbase#1] -- vbuaa=vbuc1 
    lda #0
    jsr vera_layer_set_mapbase
    // [112] phi from conio_x16_init::@7 to conio_x16_init::@8 [phi:conio_x16_init::@7->conio_x16_init::@8]
    // conio_x16_init::@8
    // vera_layer_set_mapbase(1,0x00)
    // [113] call vera_layer_set_mapbase 
    // [480] phi from conio_x16_init::@8 to vera_layer_set_mapbase [phi:conio_x16_init::@8->vera_layer_set_mapbase]
    // [480] phi vera_layer_set_mapbase::mapbase#3 = 0 [phi:conio_x16_init::@8->vera_layer_set_mapbase#0] -- vbuxx=vbuc1 
    ldx #0
    // [480] phi vera_layer_set_mapbase::layer#3 = 1 [phi:conio_x16_init::@8->vera_layer_set_mapbase#1] -- vbuaa=vbuc1 
    lda #1
    jsr vera_layer_set_mapbase
    // [114] phi from conio_x16_init::@8 to conio_x16_init::@9 [phi:conio_x16_init::@8->conio_x16_init::@9]
    // conio_x16_init::@9
    // cursor(0)
    // [115] call cursor 
    jsr cursor
    // conio_x16_init::@10
    // if(line>=cx16_conio.conio_screen_height)
    // [116] if(conio_x16_init::line#0<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto conio_x16_init::@1 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z line
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b1
    // conio_x16_init::@2
    // line=cx16_conio.conio_screen_height-1
    // [117] conio_x16_init::line#1 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    stx.z line
    // [118] phi from conio_x16_init::@10 conio_x16_init::@2 to conio_x16_init::@1 [phi:conio_x16_init::@10/conio_x16_init::@2->conio_x16_init::@1]
    // [118] phi conio_x16_init::line#3 = conio_x16_init::line#0 [phi:conio_x16_init::@10/conio_x16_init::@2->conio_x16_init::@1#0] -- register_copy 
    // conio_x16_init::@1
  __b1:
    // gotoxy(0, line)
    // [119] gotoxy::y#0 = conio_x16_init::line#3 -- vbuxx=vbuz1 
    ldx.z line
    // [120] call gotoxy 
    // [330] phi from conio_x16_init::@1 to gotoxy [phi:conio_x16_init::@1->gotoxy]
    // [330] phi gotoxy::y#7 = gotoxy::y#0 [phi:conio_x16_init::@1->gotoxy#0] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [121] return 
    rts
}
  // main
main: {
    // Handle the relocation of the CX16 petscii character set and map to the most upper corner in VERA VRAM.
    // This frees up the maximum space in VERA VRAM available for graphics.
    .const VRAM_PETSCII_MAP_SIZE = $80*$40*2
    // Set the vera heap parameters.
    .const VRAM_SPRITES_SIZE = $40*$20*$20/2
    .const VRAM_FLOOR_MAP_SIZE = $40*$40*2
    .const VRAM_FLOOR_TILE_SIZE = $c*$40*$40/2
    .const cx16_get_bram_base1_return = $2000
    .label status = $3c
    .label vram_petscii_map = $3f
    .label vram_petscii_tile = $e
    // TileDB[TILE_SQUAREMETAL] = &SquareMetal
    // [122] *TileDB = &SquareMetal -- _deref_qssc1=pssc2 
    lda #<SquareMetal
    sta TileDB
    lda #>SquareMetal
    sta TileDB+1
    // TileDB[TILE_TILEMETAL] = &TileMetal
    // [123] *(TileDB+TILE_TILEMETAL*SIZEOF_POINTER) = &TileMetal -- _deref_qssc1=pssc2 
    lda #<TileMetal
    sta TileDB+TILE_TILEMETAL*SIZEOF_POINTER
    lda #>TileMetal
    sta TileDB+TILE_TILEMETAL*SIZEOF_POINTER+1
    // TileDB[TILE_SQUARERASTER] = &SquareRaster
    // [124] *(TileDB+TILE_SQUARERASTER*SIZEOF_POINTER) = &SquareRaster -- _deref_qssc1=pssc2 
    lda #<SquareRaster
    sta TileDB+TILE_SQUARERASTER*SIZEOF_POINTER
    lda #>SquareRaster
    sta TileDB+TILE_SQUARERASTER*SIZEOF_POINTER+1
    // SpriteDB[SPRITE_PLAYER] = &SpritesPlayer
    // [125] *SpriteDB = &SpritesPlayer -- _deref_qssc1=pssc2 
    lda #<SpritesPlayer
    sta SpriteDB
    lda #>SpritesPlayer
    sta SpriteDB+1
    // SpriteDB[SPRITE_ENEMY2] = &SpritesEnemy2
    // [126] *(SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER) = &SpritesEnemy2 -- _deref_qssc1=pssc2 
    lda #<SpritesEnemy2
    sta SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER
    lda #>SpritesEnemy2
    sta SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER+1
    // [127] phi from main to main::cx16_get_bram_base1 [phi:main->main::cx16_get_bram_base1]
    // main::cx16_get_bram_base1
    // main::@5
    // load_sprite(SpriteDB[SPRITE_PLAYER], bram_sprites_ceil)
    // [128] load_sprite::Sprite#0 = *SpriteDB -- pssz1=_deref_qssc1 
    lda SpriteDB
    sta.z load_sprite.Sprite
    lda SpriteDB+1
    sta.z load_sprite.Sprite+1
    // [129] call load_sprite 
    // [487] phi from main::@5 to load_sprite [phi:main::@5->load_sprite]
    // [487] phi load_sprite::bram_address#10 = main::cx16_get_bram_base1_return#0 [phi:main::@5->load_sprite#0] -- vduz1=vduc1 
    lda #<cx16_get_bram_base1_return
    sta.z load_sprite.bram_address
    lda #>cx16_get_bram_base1_return
    sta.z load_sprite.bram_address+1
    lda #<cx16_get_bram_base1_return>>$10
    sta.z load_sprite.bram_address+2
    lda #>cx16_get_bram_base1_return>>$10
    sta.z load_sprite.bram_address+3
    // [487] phi load_sprite::Sprite#10 = load_sprite::Sprite#0 [phi:main::@5->load_sprite#1] -- register_copy 
    jsr load_sprite
    // load_sprite(SpriteDB[SPRITE_PLAYER], bram_sprites_ceil)
    // [130] load_sprite::return#2 = load_sprite::return#0
    // main::@10
    // bram_sprites_ceil = load_sprite(SpriteDB[SPRITE_PLAYER], bram_sprites_ceil)
    // [131] bram_sprites_ceil#1 = load_sprite::return#2 -- vdum1=vduz2 
    lda.z load_sprite.return
    sta bram_sprites_ceil
    lda.z load_sprite.return+1
    sta bram_sprites_ceil+1
    lda.z load_sprite.return+2
    sta bram_sprites_ceil+2
    lda.z load_sprite.return+3
    sta bram_sprites_ceil+3
    // load_sprite(SpriteDB[SPRITE_ENEMY2], bram_sprites_ceil)
    // [132] load_sprite::Sprite#1 = *(SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER
    sta.z load_sprite.Sprite
    lda SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER+1
    sta.z load_sprite.Sprite+1
    // [133] load_sprite::bram_address#1 = bram_sprites_ceil#1 -- vduz1=vdum2 
    lda bram_sprites_ceil
    sta.z load_sprite.bram_address
    lda bram_sprites_ceil+1
    sta.z load_sprite.bram_address+1
    lda bram_sprites_ceil+2
    sta.z load_sprite.bram_address+2
    lda bram_sprites_ceil+3
    sta.z load_sprite.bram_address+3
    // [134] call load_sprite 
    // [487] phi from main::@10 to load_sprite [phi:main::@10->load_sprite]
    // [487] phi load_sprite::bram_address#10 = load_sprite::bram_address#1 [phi:main::@10->load_sprite#0] -- register_copy 
    // [487] phi load_sprite::Sprite#10 = load_sprite::Sprite#1 [phi:main::@10->load_sprite#1] -- register_copy 
    jsr load_sprite
    // load_sprite(SpriteDB[SPRITE_ENEMY2], bram_sprites_ceil)
    // [135] load_sprite::return#3 = load_sprite::return#0
    // main::@11
    // [136] bram_sprites_ceil#16 = load_sprite::return#3 -- vdum1=vduz2 
    lda.z load_sprite.return
    sta bram_sprites_ceil
    lda.z load_sprite.return+1
    sta bram_sprites_ceil+1
    lda.z load_sprite.return+2
    sta bram_sprites_ceil+2
    lda.z load_sprite.return+3
    sta bram_sprites_ceil+3
    // load_tile(TileDB[TILE_SQUAREMETAL], bram_tiles_ceil)
    // [137] load_tile::Tile#0 = *TileDB -- pssz1=_deref_qssc1 
    lda TileDB
    sta.z load_tile.Tile
    lda TileDB+1
    sta.z load_tile.Tile+1
    // [138] load_tile::bram_address#0 = bram_sprites_ceil#16 -- vduz1=vdum2 
    lda bram_sprites_ceil
    sta.z load_tile.bram_address
    lda bram_sprites_ceil+1
    sta.z load_tile.bram_address+1
    lda bram_sprites_ceil+2
    sta.z load_tile.bram_address+2
    lda bram_sprites_ceil+3
    sta.z load_tile.bram_address+3
    // [139] call load_tile 
    // [508] phi from main::@11 to load_tile [phi:main::@11->load_tile]
    // [508] phi load_tile::bram_address#10 = load_tile::bram_address#0 [phi:main::@11->load_tile#0] -- register_copy 
    // [508] phi load_tile::Tile#10 = load_tile::Tile#0 [phi:main::@11->load_tile#1] -- register_copy 
    jsr load_tile
    // load_tile(TileDB[TILE_SQUAREMETAL], bram_tiles_ceil)
    // [140] load_tile::return#2 = load_tile::return#0
    // main::@12
    // bram_tiles_ceil = load_tile(TileDB[TILE_SQUAREMETAL], bram_tiles_ceil)
    // [141] bram_tiles_ceil#1 = load_tile::return#2 -- vdum1=vduz2 
    lda.z load_tile.return
    sta bram_tiles_ceil
    lda.z load_tile.return+1
    sta bram_tiles_ceil+1
    lda.z load_tile.return+2
    sta bram_tiles_ceil+2
    lda.z load_tile.return+3
    sta bram_tiles_ceil+3
    // load_tile(TileDB[TILE_TILEMETAL], bram_tiles_ceil)
    // [142] load_tile::Tile#1 = *(TileDB+TILE_TILEMETAL*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda TileDB+TILE_TILEMETAL*SIZEOF_POINTER
    sta.z load_tile.Tile
    lda TileDB+TILE_TILEMETAL*SIZEOF_POINTER+1
    sta.z load_tile.Tile+1
    // [143] load_tile::bram_address#1 = bram_tiles_ceil#1 -- vduz1=vdum2 
    lda bram_tiles_ceil
    sta.z load_tile.bram_address
    lda bram_tiles_ceil+1
    sta.z load_tile.bram_address+1
    lda bram_tiles_ceil+2
    sta.z load_tile.bram_address+2
    lda bram_tiles_ceil+3
    sta.z load_tile.bram_address+3
    // [144] call load_tile 
    // [508] phi from main::@12 to load_tile [phi:main::@12->load_tile]
    // [508] phi load_tile::bram_address#10 = load_tile::bram_address#1 [phi:main::@12->load_tile#0] -- register_copy 
    // [508] phi load_tile::Tile#10 = load_tile::Tile#1 [phi:main::@12->load_tile#1] -- register_copy 
    jsr load_tile
    // load_tile(TileDB[TILE_TILEMETAL], bram_tiles_ceil)
    // [145] load_tile::return#3 = load_tile::return#0
    // main::@13
    // bram_tiles_ceil = load_tile(TileDB[TILE_TILEMETAL], bram_tiles_ceil)
    // [146] bram_tiles_ceil#2 = load_tile::return#3 -- vdum1=vduz2 
    lda.z load_tile.return
    sta bram_tiles_ceil
    lda.z load_tile.return+1
    sta bram_tiles_ceil+1
    lda.z load_tile.return+2
    sta bram_tiles_ceil+2
    lda.z load_tile.return+3
    sta bram_tiles_ceil+3
    // load_tile(TileDB[TILE_SQUARERASTER], bram_tiles_ceil)
    // [147] load_tile::Tile#2 = *(TileDB+TILE_SQUARERASTER*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda TileDB+TILE_SQUARERASTER*SIZEOF_POINTER
    sta.z load_tile.Tile
    lda TileDB+TILE_SQUARERASTER*SIZEOF_POINTER+1
    sta.z load_tile.Tile+1
    // [148] load_tile::bram_address#2 = bram_tiles_ceil#2 -- vduz1=vdum2 
    lda bram_tiles_ceil
    sta.z load_tile.bram_address
    lda bram_tiles_ceil+1
    sta.z load_tile.bram_address+1
    lda bram_tiles_ceil+2
    sta.z load_tile.bram_address+2
    lda bram_tiles_ceil+3
    sta.z load_tile.bram_address+3
    // [149] call load_tile 
    // [508] phi from main::@13 to load_tile [phi:main::@13->load_tile]
    // [508] phi load_tile::bram_address#10 = load_tile::bram_address#2 [phi:main::@13->load_tile#0] -- register_copy 
    // [508] phi load_tile::Tile#10 = load_tile::Tile#2 [phi:main::@13->load_tile#1] -- register_copy 
    jsr load_tile
    // load_tile(TileDB[TILE_SQUARERASTER], bram_tiles_ceil)
    // [150] load_tile::return#4 = load_tile::return#0
    // main::@14
    // [151] bram_palette#0 = load_tile::return#4 -- vdum1=vduz2 
    lda.z load_tile.return
    sta bram_palette
    lda.z load_tile.return+1
    sta bram_palette+1
    lda.z load_tile.return+2
    sta bram_palette+2
    lda.z load_tile.return+3
    sta bram_palette+3
    // cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, bram_palette)
    // [152] cx16_load_ram_banked::address#2 = bram_palette#0 -- vduz1=vdum2 
    lda bram_palette
    sta.z cx16_load_ram_banked.address
    lda bram_palette+1
    sta.z cx16_load_ram_banked.address+1
    lda bram_palette+2
    sta.z cx16_load_ram_banked.address+2
    lda bram_palette+3
    sta.z cx16_load_ram_banked.address+3
    // [153] call cx16_load_ram_banked 
    // [529] phi from main::@14 to cx16_load_ram_banked [phi:main::@14->cx16_load_ram_banked]
    // [529] phi cx16_load_ram_banked::filename#3 = FILE_PALETTES [phi:main::@14->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_PALETTES
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_PALETTES
    sta.z cx16_load_ram_banked.filename+1
    // [529] phi cx16_load_ram_banked::address#3 = cx16_load_ram_banked::address#2 [phi:main::@14->cx16_load_ram_banked#1] -- register_copy 
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, bram_palette)
    // [154] cx16_load_ram_banked::return#10 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@15
    // status = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, bram_palette)
    // [155] main::status#0 = cx16_load_ram_banked::return#10 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$ff)
    // [156] if(main::status#0==$ff) goto main::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [157] phi from main::@15 to main::@2 [phi:main::@15->main::@2]
    // main::@2
    // printf("error file_palettes = %u",status)
    // [158] call cputs 
    // [343] phi from main::@2 to cputs [phi:main::@2->cputs]
    // [343] phi cputs::s#26 = main::s [phi:main::@2->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@36
    // printf("error file_palettes = %u",status)
    // [159] printf_uchar::uvalue#4 = main::status#0 -- vbuxx=vbuz1 
    ldx.z status
    // [160] call printf_uchar 
    // [596] phi from main::@36 to printf_uchar [phi:main::@36->printf_uchar]
    // [596] phi printf_uchar::format_radix#5 = DECIMAL [phi:main::@36->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #DECIMAL
    // [596] phi printf_uchar::uvalue#5 = printf_uchar::uvalue#4 [phi:main::@36->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [161] phi from main::@15 main::@36 to main::@1 [phi:main::@15/main::@36->main::@1]
    // main::@1
  __b1:
    // cx16_rom_bank(CX16_ROM_KERNAL)
    // [162] call cx16_rom_bank 
  // We are going to use only the kernal on the X16.
    // [604] phi from main::@1 to cx16_rom_bank [phi:main::@1->cx16_rom_bank]
    // [604] phi cx16_rom_bank::bank#2 = CX16_ROM_KERNAL [phi:main::@1->cx16_rom_bank#0] -- vbuaa=vbuc1 
    lda #CX16_ROM_KERNAL
    jsr cx16_rom_bank
    // [163] phi from main::@1 to main::@16 [phi:main::@1->main::@16]
    // main::@16
    // vera_heap_segment_init(HEAP_PETSCII, 0x1B000, VRAM_PETSCII_MAP_SIZE + VERA_PETSCII_TILE_SIZE)
    // [164] call vera_heap_segment_init 
    // [607] phi from main::@16 to vera_heap_segment_init [phi:main::@16->vera_heap_segment_init]
    // [607] phi vera_heap_segment_init::base#4 = $1b000 [phi:main::@16->vera_heap_segment_init#0] -- vduz1=vduc1 
    lda #<$1b000
    sta.z vera_heap_segment_init.base
    lda #>$1b000
    sta.z vera_heap_segment_init.base+1
    lda #<$1b000>>$10
    sta.z vera_heap_segment_init.base+2
    lda #>$1b000>>$10
    sta.z vera_heap_segment_init.base+3
    // [607] phi vera_heap_segment_init::size#4 = main::VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE [phi:main::@16->vera_heap_segment_init#1] -- vduz1=vduc1 
    lda #<VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE
    sta.z vera_heap_segment_init.size
    lda #>VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE
    sta.z vera_heap_segment_init.size+1
    lda #<VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+2
    lda #>VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+3
    // [607] phi vera_heap_segment_init::segmentid#4 = HEAP_PETSCII [phi:main::@16->vera_heap_segment_init#2] -- vbuxx=vbuc1 
    ldx #HEAP_PETSCII
    jsr vera_heap_segment_init
    // main::@17
    // vera_heap_malloc(HEAP_PETSCII, VRAM_PETSCII_MAP_SIZE)
    // [165] vera_heap_malloc::size = main::VRAM_PETSCII_MAP_SIZE -- vwuz1=vwuc1 
    lda #<VRAM_PETSCII_MAP_SIZE
    sta.z vera_heap_malloc.size
    lda #>VRAM_PETSCII_MAP_SIZE
    sta.z vera_heap_malloc.size+1
    // [166] call vera_heap_malloc 
    // [623] phi from main::@17 to vera_heap_malloc [phi:main::@17->vera_heap_malloc]
    // [623] phi vera_heap_malloc::segmentid#4 = HEAP_PETSCII [phi:main::@17->vera_heap_malloc#0] -- vbuxx=vbuc1 
    ldx #HEAP_PETSCII
    jsr vera_heap_malloc
    // vera_heap_malloc(HEAP_PETSCII, VRAM_PETSCII_MAP_SIZE)
    // [167] vera_heap_malloc::return#13 = vera_heap_malloc::return#1
    // main::@18
    // vram_petscii_map = vera_heap_malloc(HEAP_PETSCII, VRAM_PETSCII_MAP_SIZE)
    // [168] main::vram_petscii_map#0 = vera_heap_malloc::return#13 -- vduz1=vduz2 
    lda.z vera_heap_malloc.return
    sta.z vram_petscii_map
    lda.z vera_heap_malloc.return+1
    sta.z vram_petscii_map+1
    lda.z vera_heap_malloc.return+2
    sta.z vram_petscii_map+2
    lda.z vera_heap_malloc.return+3
    sta.z vram_petscii_map+3
    // vera_heap_malloc(HEAP_PETSCII, VERA_PETSCII_TILE_SIZE)
    // [169] vera_heap_malloc::size = VERA_PETSCII_TILE_SIZE -- vwuz1=vwuc1 
    lda #<VERA_PETSCII_TILE_SIZE
    sta.z vera_heap_malloc.size
    lda #>VERA_PETSCII_TILE_SIZE
    sta.z vera_heap_malloc.size+1
    // [170] call vera_heap_malloc 
    // [623] phi from main::@18 to vera_heap_malloc [phi:main::@18->vera_heap_malloc]
    // [623] phi vera_heap_malloc::segmentid#4 = HEAP_PETSCII [phi:main::@18->vera_heap_malloc#0] -- vbuxx=vbuc1 
    ldx #HEAP_PETSCII
    jsr vera_heap_malloc
    // vera_heap_malloc(HEAP_PETSCII, VERA_PETSCII_TILE_SIZE)
    // [171] vera_heap_malloc::return#14 = vera_heap_malloc::return#1
    // main::@19
    // vram_petscii_tile = vera_heap_malloc(HEAP_PETSCII, VERA_PETSCII_TILE_SIZE)
    // [172] main::vram_petscii_tile#0 = vera_heap_malloc::return#14
    // vera_cpy_vram_vram(VERA_PETSCII_TILE, VRAM_PETSCII_TILE, VERA_PETSCII_TILE_SIZE)
    // [173] call vera_cpy_vram_vram 
    // [302] phi from main::@19 to vera_cpy_vram_vram [phi:main::@19->vera_cpy_vram_vram]
    // [302] phi vera_cpy_vram_vram::num#3 = VERA_PETSCII_TILE_SIZE [phi:main::@19->vera_cpy_vram_vram#0] -- vduz1=vduc1 
    lda #<VERA_PETSCII_TILE_SIZE
    sta.z vera_cpy_vram_vram.num
    lda #>VERA_PETSCII_TILE_SIZE
    sta.z vera_cpy_vram_vram.num+1
    lda #<VERA_PETSCII_TILE_SIZE>>$10
    sta.z vera_cpy_vram_vram.num+2
    lda #>VERA_PETSCII_TILE_SIZE>>$10
    sta.z vera_cpy_vram_vram.num+3
    // [302] phi vera_cpy_vram_vram::vdest#2 = VRAM_PETSCII_TILE [phi:main::@19->vera_cpy_vram_vram#1] -- vduz1=vduc1 
    lda #<VRAM_PETSCII_TILE
    sta.z vera_cpy_vram_vram.vdest
    lda #>VRAM_PETSCII_TILE
    sta.z vera_cpy_vram_vram.vdest+1
    lda #<VRAM_PETSCII_TILE>>$10
    sta.z vera_cpy_vram_vram.vdest+2
    lda #>VRAM_PETSCII_TILE>>$10
    sta.z vera_cpy_vram_vram.vdest+3
    // [302] phi vera_cpy_vram_vram::vsrc#2 = VERA_PETSCII_TILE [phi:main::@19->vera_cpy_vram_vram#2] -- vduz1=vduc1 
    lda #<VERA_PETSCII_TILE
    sta.z vera_cpy_vram_vram.vsrc
    lda #>VERA_PETSCII_TILE
    sta.z vera_cpy_vram_vram.vsrc+1
    lda #<VERA_PETSCII_TILE>>$10
    sta.z vera_cpy_vram_vram.vsrc+2
    lda #>VERA_PETSCII_TILE>>$10
    sta.z vera_cpy_vram_vram.vsrc+3
    jsr vera_cpy_vram_vram
    // main::@20
    // vera_layer_mode_tile(1, vram_petscii_map, vram_petscii_tile, 128, 64, 8, 8, 1)
    // [174] vera_layer_mode_tile::mapbase_address#2 = main::vram_petscii_map#0 -- vduz1=vduz2 
    lda.z vram_petscii_map
    sta.z vera_layer_mode_tile.mapbase_address
    lda.z vram_petscii_map+1
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda.z vram_petscii_map+2
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda.z vram_petscii_map+3
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [175] vera_layer_mode_tile::tilebase_address#2 = main::vram_petscii_tile#0 -- vduz1=vduz2 
    lda.z vram_petscii_tile
    sta.z vera_layer_mode_tile.tilebase_address
    lda.z vram_petscii_tile+1
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda.z vram_petscii_tile+2
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda.z vram_petscii_tile+3
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [176] call vera_layer_mode_tile 
    // [689] phi from main::@20 to vera_layer_mode_tile [phi:main::@20->vera_layer_mode_tile]
    // [689] phi vera_layer_mode_tile::tileheight#10 = 8 [phi:main::@20->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [689] phi vera_layer_mode_tile::tilewidth#10 = 8 [phi:main::@20->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [689] phi vera_layer_mode_tile::tilebase_address#10 = vera_layer_mode_tile::tilebase_address#2 [phi:main::@20->vera_layer_mode_tile#2] -- register_copy 
    // [689] phi vera_layer_mode_tile::mapbase_address#10 = vera_layer_mode_tile::mapbase_address#2 [phi:main::@20->vera_layer_mode_tile#3] -- register_copy 
    // [689] phi vera_layer_mode_tile::mapheight#10 = $40 [phi:main::@20->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [689] phi vera_layer_mode_tile::layer#10 = 1 [phi:main::@20->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.layer
    // [689] phi vera_layer_mode_tile::mapwidth#10 = $80 [phi:main::@20->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [689] phi vera_layer_mode_tile::color_depth#3 = 1 [phi:main::@20->vera_layer_mode_tile#7] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_mode_tile
    // [177] phi from main::@20 to main::@21 [phi:main::@20->main::@21]
    // main::@21
    // screenlayer(1)
    // [178] call screenlayer 
    jsr screenlayer
    // main::textcolor1
    // vera_layer_set_textcolor(cx16_conio.conio_screen_layer, color)
    // [179] vera_layer_set_textcolor::layer#1 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [180] call vera_layer_set_textcolor 
    // [474] phi from main::textcolor1 to vera_layer_set_textcolor [phi:main::textcolor1->vera_layer_set_textcolor]
    // [474] phi vera_layer_set_textcolor::layer#2 = vera_layer_set_textcolor::layer#1 [phi:main::textcolor1->vera_layer_set_textcolor#0] -- register_copy 
    jsr vera_layer_set_textcolor
    // main::bgcolor1
    // vera_layer_set_backcolor(cx16_conio.conio_screen_layer, color)
    // [181] vera_layer_set_backcolor::layer#1 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [182] call vera_layer_set_backcolor 
    // [477] phi from main::bgcolor1 to vera_layer_set_backcolor [phi:main::bgcolor1->vera_layer_set_backcolor]
    // [477] phi vera_layer_set_backcolor::color#2 = BLACK [phi:main::bgcolor1->vera_layer_set_backcolor#0] -- vbuaa=vbuc1 
    lda #BLACK
    // [477] phi vera_layer_set_backcolor::layer#2 = vera_layer_set_backcolor::layer#1 [phi:main::bgcolor1->vera_layer_set_backcolor#1] -- register_copy 
    jsr vera_layer_set_backcolor
    // [183] phi from main::bgcolor1 to main::@6 [phi:main::bgcolor1->main::@6]
    // main::@6
    // clrscr()
    // [184] call clrscr 
    jsr clrscr
    // [185] phi from main::@6 to main::@22 [phi:main::@6->main::@22]
    // main::@22
    // vera_heap_segment_init(HEAP_SPRITES, 0x00000, VRAM_SPRITES_SIZE)
    // [186] call vera_heap_segment_init 
    // [607] phi from main::@22 to vera_heap_segment_init [phi:main::@22->vera_heap_segment_init]
    // [607] phi vera_heap_segment_init::base#4 = 0 [phi:main::@22->vera_heap_segment_init#0] -- vduz1=vbuc1 
    lda #0
    sta.z vera_heap_segment_init.base
    sta.z vera_heap_segment_init.base+1
    sta.z vera_heap_segment_init.base+2
    sta.z vera_heap_segment_init.base+3
    // [607] phi vera_heap_segment_init::size#4 = main::VRAM_SPRITES_SIZE [phi:main::@22->vera_heap_segment_init#1] -- vduz1=vduc1 
    lda #<VRAM_SPRITES_SIZE
    sta.z vera_heap_segment_init.size
    lda #>VRAM_SPRITES_SIZE
    sta.z vera_heap_segment_init.size+1
    lda #<VRAM_SPRITES_SIZE>>$10
    sta.z vera_heap_segment_init.size+2
    lda #>VRAM_SPRITES_SIZE>>$10
    sta.z vera_heap_segment_init.size+3
    // [607] phi vera_heap_segment_init::segmentid#4 = HEAP_SPRITES [phi:main::@22->vera_heap_segment_init#2] -- vbuxx=vbuc1 
    ldx #HEAP_SPRITES
    jsr vera_heap_segment_init
    // [187] phi from main::@22 to main::@23 [phi:main::@22->main::@23]
    // main::@23
    // vera_heap_segment_ceiling(HEAP_SPRITES)
    // [188] call vera_heap_segment_ceiling 
    // [795] phi from main::@23 to vera_heap_segment_ceiling [phi:main::@23->vera_heap_segment_ceiling]
    // [795] phi vera_heap_segment_ceiling::segmentid#2 = HEAP_SPRITES [phi:main::@23->vera_heap_segment_ceiling#0] -- vbuxx=vbuc1 
    ldx #HEAP_SPRITES
    jsr vera_heap_segment_ceiling
    // vera_heap_segment_ceiling(HEAP_SPRITES)
    // [189] vera_heap_segment_ceiling::return#2 = vera_heap_segment_ceiling::return#0
    // main::@24
    // vera_heap_segment_init(HEAP_FLOOR_MAP, vera_heap_segment_ceiling(HEAP_SPRITES), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [190] vera_heap_segment_init::base#2 = vera_heap_segment_ceiling::return#2
    // [191] call vera_heap_segment_init 
    // [607] phi from main::@24 to vera_heap_segment_init [phi:main::@24->vera_heap_segment_init]
    // [607] phi vera_heap_segment_init::base#4 = vera_heap_segment_init::base#2 [phi:main::@24->vera_heap_segment_init#0] -- register_copy 
    // [607] phi vera_heap_segment_init::size#4 = main::VRAM_FLOOR_MAP_SIZE+main::VRAM_FLOOR_TILE_SIZE [phi:main::@24->vera_heap_segment_init#1] -- vduz1=vduc1 
    lda #<VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE
    sta.z vera_heap_segment_init.size
    lda #>VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE
    sta.z vera_heap_segment_init.size+1
    lda #<VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+2
    lda #>VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+3
    // [607] phi vera_heap_segment_init::segmentid#4 = HEAP_FLOOR_MAP [phi:main::@24->vera_heap_segment_init#2] -- vbuxx=vbuc1 
    ldx #HEAP_FLOOR_MAP
    jsr vera_heap_segment_init
    // vera_heap_segment_init(HEAP_FLOOR_MAP, vera_heap_segment_ceiling(HEAP_SPRITES), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [192] vera_heap_segment_init::return#4 = vera_heap_segment_init::return#0
    // main::@25
    // vram_segment_floor_map = vera_heap_segment_init(HEAP_FLOOR_MAP, vera_heap_segment_ceiling(HEAP_SPRITES), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [193] main::vram_segment_floor_map#0 = vera_heap_segment_init::return#4 -- vdum1=vduz2 
    lda.z vera_heap_segment_init.return
    sta vram_segment_floor_map
    lda.z vera_heap_segment_init.return+1
    sta vram_segment_floor_map+1
    lda.z vera_heap_segment_init.return+2
    sta vram_segment_floor_map+2
    lda.z vera_heap_segment_init.return+3
    sta vram_segment_floor_map+3
    // vera_heap_segment_ceiling(HEAP_FLOOR_MAP)
    // [194] call vera_heap_segment_ceiling 
    // [795] phi from main::@25 to vera_heap_segment_ceiling [phi:main::@25->vera_heap_segment_ceiling]
    // [795] phi vera_heap_segment_ceiling::segmentid#2 = HEAP_FLOOR_MAP [phi:main::@25->vera_heap_segment_ceiling#0] -- vbuxx=vbuc1 
    ldx #HEAP_FLOOR_MAP
    jsr vera_heap_segment_ceiling
    // vera_heap_segment_ceiling(HEAP_FLOOR_MAP)
    // [195] vera_heap_segment_ceiling::return#3 = vera_heap_segment_ceiling::return#0
    // main::@26
    // vera_heap_segment_init(HEAP_FLOOR_TILE, vera_heap_segment_ceiling(HEAP_FLOOR_MAP), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [196] vera_heap_segment_init::base#3 = vera_heap_segment_ceiling::return#3
    // [197] call vera_heap_segment_init 
    // [607] phi from main::@26 to vera_heap_segment_init [phi:main::@26->vera_heap_segment_init]
    // [607] phi vera_heap_segment_init::base#4 = vera_heap_segment_init::base#3 [phi:main::@26->vera_heap_segment_init#0] -- register_copy 
    // [607] phi vera_heap_segment_init::size#4 = main::VRAM_FLOOR_MAP_SIZE+main::VRAM_FLOOR_TILE_SIZE [phi:main::@26->vera_heap_segment_init#1] -- vduz1=vduc1 
    lda #<VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE
    sta.z vera_heap_segment_init.size
    lda #>VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE
    sta.z vera_heap_segment_init.size+1
    lda #<VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+2
    lda #>VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+3
    // [607] phi vera_heap_segment_init::segmentid#4 = HEAP_FLOOR_TILE [phi:main::@26->vera_heap_segment_init#2] -- vbuxx=vbuc1 
    ldx #HEAP_FLOOR_TILE
    jsr vera_heap_segment_init
    // vera_heap_segment_init(HEAP_FLOOR_TILE, vera_heap_segment_ceiling(HEAP_FLOOR_MAP), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [198] vera_heap_segment_init::return#5 = vera_heap_segment_init::return#0
    // main::@27
    // vram_segment_floor_tile = vera_heap_segment_init(HEAP_FLOOR_TILE, vera_heap_segment_ceiling(HEAP_FLOOR_MAP), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [199] main::vram_segment_floor_tile#0 = vera_heap_segment_init::return#5 -- vdum1=vduz2 
    lda.z vera_heap_segment_init.return
    sta vram_segment_floor_tile
    lda.z vera_heap_segment_init.return+1
    sta vram_segment_floor_tile+1
    lda.z vera_heap_segment_init.return+2
    sta vram_segment_floor_tile+2
    lda.z vera_heap_segment_init.return+3
    sta vram_segment_floor_tile+3
    // vram_floor_map = vram_segment_floor_map
    // [200] vram_floor_map = main::vram_segment_floor_map#0 -- vduz1=vdum2 
    lda vram_segment_floor_map
    sta.z vram_floor_map
    lda vram_segment_floor_map+1
    sta.z vram_floor_map+1
    lda vram_segment_floor_map+2
    sta.z vram_floor_map+2
    lda vram_segment_floor_map+3
    sta.z vram_floor_map+3
    // sprite_cpy_vram(HEAP_SPRITES, SpriteDB[SPRITE_PLAYER])
    // [201] sprite_cpy_vram::Sprite#0 = *SpriteDB -- pssz1=_deref_qssc1 
    lda SpriteDB
    sta.z sprite_cpy_vram.Sprite
    lda SpriteDB+1
    sta.z sprite_cpy_vram.Sprite+1
    // [202] call sprite_cpy_vram 
  // Now we activate the tile mode.
    // [804] phi from main::@27 to sprite_cpy_vram [phi:main::@27->sprite_cpy_vram]
    // [804] phi sprite_cpy_vram::Sprite#2 = sprite_cpy_vram::Sprite#0 [phi:main::@27->sprite_cpy_vram#0] -- register_copy 
    jsr sprite_cpy_vram
    // main::@28
    // sprite_cpy_vram(HEAP_SPRITES, SpriteDB[SPRITE_ENEMY2])
    // [203] sprite_cpy_vram::Sprite#1 = *(SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER
    sta.z sprite_cpy_vram.Sprite
    lda SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER+1
    sta.z sprite_cpy_vram.Sprite+1
    // [204] call sprite_cpy_vram 
    // [804] phi from main::@28 to sprite_cpy_vram [phi:main::@28->sprite_cpy_vram]
    // [804] phi sprite_cpy_vram::Sprite#2 = sprite_cpy_vram::Sprite#1 [phi:main::@28->sprite_cpy_vram#0] -- register_copy 
    jsr sprite_cpy_vram
    // main::@29
    // tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_SQUAREMETAL])
    // [205] tile_cpy_vram::Tile#0 = *TileDB -- pssz1=_deref_qssc1 
    lda TileDB
    sta.z tile_cpy_vram.Tile
    lda TileDB+1
    sta.z tile_cpy_vram.Tile+1
    // [206] call tile_cpy_vram 
    // [828] phi from main::@29 to tile_cpy_vram [phi:main::@29->tile_cpy_vram]
    // [828] phi tile_cpy_vram::Tile#3 = tile_cpy_vram::Tile#0 [phi:main::@29->tile_cpy_vram#0] -- register_copy 
    jsr tile_cpy_vram
    // main::@30
    // tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_TILEMETAL])
    // [207] tile_cpy_vram::Tile#1 = *(TileDB+TILE_TILEMETAL*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda TileDB+TILE_TILEMETAL*SIZEOF_POINTER
    sta.z tile_cpy_vram.Tile
    lda TileDB+TILE_TILEMETAL*SIZEOF_POINTER+1
    sta.z tile_cpy_vram.Tile+1
    // [208] call tile_cpy_vram 
    // [828] phi from main::@30 to tile_cpy_vram [phi:main::@30->tile_cpy_vram]
    // [828] phi tile_cpy_vram::Tile#3 = tile_cpy_vram::Tile#1 [phi:main::@30->tile_cpy_vram#0] -- register_copy 
    jsr tile_cpy_vram
    // main::@31
    // tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_SQUARERASTER])
    // [209] tile_cpy_vram::Tile#2 = *(TileDB+TILE_SQUARERASTER*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda TileDB+TILE_SQUARERASTER*SIZEOF_POINTER
    sta.z tile_cpy_vram.Tile
    lda TileDB+TILE_SQUARERASTER*SIZEOF_POINTER+1
    sta.z tile_cpy_vram.Tile+1
    // [210] call tile_cpy_vram 
    // [828] phi from main::@31 to tile_cpy_vram [phi:main::@31->tile_cpy_vram]
    // [828] phi tile_cpy_vram::Tile#3 = tile_cpy_vram::Tile#2 [phi:main::@31->tile_cpy_vram#0] -- register_copy 
    jsr tile_cpy_vram
    // main::@32
    // vera_layer_mode_tile(0, vram_segment_floor_map, vram_segment_floor_tile, 64, 64, 16, 16, 4)
    // [211] vera_layer_mode_tile::mapbase_address#3 = main::vram_segment_floor_map#0 -- vduz1=vdum2 
    lda vram_segment_floor_map
    sta.z vera_layer_mode_tile.mapbase_address
    lda vram_segment_floor_map+1
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda vram_segment_floor_map+2
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda vram_segment_floor_map+3
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [212] vera_layer_mode_tile::tilebase_address#3 = main::vram_segment_floor_tile#0 -- vduz1=vdum2 
    lda vram_segment_floor_tile
    sta.z vera_layer_mode_tile.tilebase_address
    lda vram_segment_floor_tile+1
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda vram_segment_floor_tile+2
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda vram_segment_floor_tile+3
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [213] call vera_layer_mode_tile 
    // [689] phi from main::@32 to vera_layer_mode_tile [phi:main::@32->vera_layer_mode_tile]
    // [689] phi vera_layer_mode_tile::tileheight#10 = $10 [phi:main::@32->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #$10
    sta.z vera_layer_mode_tile.tileheight
    // [689] phi vera_layer_mode_tile::tilewidth#10 = $10 [phi:main::@32->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [689] phi vera_layer_mode_tile::tilebase_address#10 = vera_layer_mode_tile::tilebase_address#3 [phi:main::@32->vera_layer_mode_tile#2] -- register_copy 
    // [689] phi vera_layer_mode_tile::mapbase_address#10 = vera_layer_mode_tile::mapbase_address#3 [phi:main::@32->vera_layer_mode_tile#3] -- register_copy 
    // [689] phi vera_layer_mode_tile::mapheight#10 = $40 [phi:main::@32->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [689] phi vera_layer_mode_tile::layer#10 = 0 [phi:main::@32->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.layer
    // [689] phi vera_layer_mode_tile::mapwidth#10 = $40 [phi:main::@32->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$40
    sta.z vera_layer_mode_tile.mapwidth+1
    // [689] phi vera_layer_mode_tile::color_depth#3 = 4 [phi:main::@32->vera_layer_mode_tile#7] -- vbuxx=vbuc1 
    ldx #4
    jsr vera_layer_mode_tile
    // main::@33
    // vera_cpy_bank_vram(bram_palette, VERA_PALETTE+32, (dword)32*6)
    // [214] vera_cpy_bank_vram::bsrc#2 = bram_palette#0 -- vduz1=vdum2 
    lda bram_palette
    sta.z vera_cpy_bank_vram.bsrc
    lda bram_palette+1
    sta.z vera_cpy_bank_vram.bsrc+1
    lda bram_palette+2
    sta.z vera_cpy_bank_vram.bsrc+2
    lda bram_palette+3
    sta.z vera_cpy_bank_vram.bsrc+3
    // [215] call vera_cpy_bank_vram 
  // Load the palette in VERA palette registers, but keep the first 16 colors untouched.
    // [853] phi from main::@33 to vera_cpy_bank_vram [phi:main::@33->vera_cpy_bank_vram]
    // [853] phi vera_cpy_bank_vram::num#5 = $20*6 [phi:main::@33->vera_cpy_bank_vram#0] -- vduz1=vduc1 
    lda #<$20*6
    sta.z vera_cpy_bank_vram.num
    lda #>$20*6
    sta.z vera_cpy_bank_vram.num+1
    lda #<$20*6>>$10
    sta.z vera_cpy_bank_vram.num+2
    lda #>$20*6>>$10
    sta.z vera_cpy_bank_vram.num+3
    // [853] phi vera_cpy_bank_vram::bsrc#3 = vera_cpy_bank_vram::bsrc#2 [phi:main::@33->vera_cpy_bank_vram#1] -- register_copy 
    // [853] phi vera_cpy_bank_vram::vdest#3 = VERA_PALETTE+$20 [phi:main::@33->vera_cpy_bank_vram#2] -- vduz1=vduc1 
    lda #<VERA_PALETTE+$20
    sta.z vera_cpy_bank_vram.vdest
    lda #>VERA_PALETTE+$20
    sta.z vera_cpy_bank_vram.vdest+1
    lda #<VERA_PALETTE+$20>>$10
    sta.z vera_cpy_bank_vram.vdest+2
    lda #>VERA_PALETTE+$20>>$10
    sta.z vera_cpy_bank_vram.vdest+3
    jsr vera_cpy_bank_vram
    // main::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [216] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [217] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [218] phi from main::vera_layer_show1 to main::@7 [phi:main::vera_layer_show1->main::@7]
    // main::@7
    // tile_background()
    // [219] call tile_background 
    // [895] phi from main::@7 to tile_background [phi:main::@7->tile_background]
    jsr tile_background
    // [220] phi from main::@7 to main::@34 [phi:main::@7->main::@34]
    // main::@34
    // create_sprite(SPRITE_PLAYER)
    // [221] call create_sprite 
    // [916] phi from main::@34 to create_sprite [phi:main::@34->create_sprite]
    // [916] phi create_sprite::sprite#2 = SPRITE_PLAYER [phi:main::@34->create_sprite#0] -- vbuaa=vbuc1 
    lda #SPRITE_PLAYER
    jsr create_sprite
    // [222] phi from main::@34 to main::@35 [phi:main::@34->main::@35]
    // main::@35
    // create_sprite(SPRITE_ENEMY2)
    // [223] call create_sprite 
    // [916] phi from main::@35 to create_sprite [phi:main::@35->create_sprite]
    // [916] phi create_sprite::sprite#2 = SPRITE_ENEMY2 [phi:main::@35->create_sprite#0] -- vbuaa=vbuc1 
    lda #SPRITE_ENEMY2
    jsr create_sprite
    // main::vera_sprite_on1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [224] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE
    // [225] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_SPRITES_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITES_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [226] phi from main::vera_sprite_on1 to main::@8 [phi:main::vera_sprite_on1->main::@8]
    // main::@8
    // show_memory_map()
    // [227] call show_memory_map 
    // [1074] phi from main::@8 to show_memory_map [phi:main::@8->show_memory_map]
    jsr show_memory_map
    // main::SEI1
    // asm
    // asm { sei  }
    sei
    // main::@9
    // *KERNEL_IRQ = &irq_vsync
    // [229] *KERNEL_IRQ = &irq_vsync -- _deref_qprc1=pprc2 
    lda #<irq_vsync
    sta KERNEL_IRQ
    lda #>irq_vsync
    sta KERNEL_IRQ+1
    // *VERA_IEN = VERA_VSYNC
    // [230] *VERA_IEN = VERA_VSYNC -- _deref_pbuc1=vbuc2 
    lda #VERA_VSYNC
    sta VERA_IEN
    // main::CLI1
    // asm
    // asm { cli  }
    cli
    // [232] phi from main::@37 main::CLI1 to main::@3 [phi:main::@37/main::CLI1->main::@3]
    // main::@3
  __b3:
    // kbhit()
    // [233] call kbhit 
    jsr kbhit
    // [234] kbhit::return#2 = kbhit::return#1
    // main::@37
    // [235] main::$41 = kbhit::return#2
    // while(!kbhit())
    // [236] if(0==main::$41) goto main::@3 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b3
    // [237] phi from main::@37 to main::@4 [phi:main::@37->main::@4]
    // main::@4
    // cx16_rom_bank(CX16_ROM_BASIC)
    // [238] call cx16_rom_bank 
  // Back to basic.
    // [604] phi from main::@4 to cx16_rom_bank [phi:main::@4->cx16_rom_bank]
    // [604] phi cx16_rom_bank::bank#2 = CX16_ROM_BASIC [phi:main::@4->cx16_rom_bank#0] -- vbuaa=vbuc1 
    lda #CX16_ROM_BASIC
    jsr cx16_rom_bank
    // main::@return
    // }
    // [239] return 
    rts
  .segment Data
    s: .text "error file_palettes = "
    .byte 0
    vram_segment_floor_map: .dword 0
    vram_segment_floor_tile: .dword 0
}
.segment Code
  // rotate_sprites
// rotate_sprites(word zp($3a) rotate, struct Sprite* zp($34) Sprite, word zp($2c) basex)
rotate_sprites: {
    .label __8 = $2e
    .label __11 = $45
    .label __14 = $2e
    .label __17 = $45
    .label __21 = $2e
    .label __22 = $45
    .label vera_sprite_address1___0 = $2e
    .label vera_sprite_address1___4 = $2e
    .label vera_sprite_address1___5 = $2e
    .label vera_sprite_address1___7 = $2e
    .label vera_sprite_address1___9 = $44
    .label vera_sprite_address1___10 = $2e
    .label vera_sprite_address1___14 = $2e
    .label vera_sprite_xy1___4 = $47
    .label vera_sprite_xy1___10 = $47
    .label offset = 3
    .label max = $ba
    .label i = $2e
    .label vera_sprite_address1_address = $30
    .label vera_sprite_address1_sprite_offset = $2e
    .label vera_sprite_xy1_sprite = $43
    .label vera_sprite_xy1_x = $2e
    .label vera_sprite_xy1_y = $45
    .label vera_sprite_xy1_sprite_offset = $47
    .label rotate = $3a
    .label Sprite = $34
    .label basex = $2c
    .label __23 = $45
    // offset = Sprite->Offset
    // [241] rotate_sprites::offset#0 = ((byte*)rotate_sprites::Sprite#2)[OFFSET_STRUCT_SPRITE_OFFSET] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_OFFSET
    lda (Sprite),y
    sta.z offset
    // max = Sprite->SpriteCount
    // [242] rotate_sprites::max#0 = (word)((byte*)rotate_sprites::Sprite#2)[OFFSET_STRUCT_SPRITE_SPRITECOUNT] -- vwuz1=_word_pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_SPRITECOUNT
    lda (Sprite),y
    sta.z max
    lda #0
    sta.z max+1
    // [243] phi from rotate_sprites to rotate_sprites::@1 [phi:rotate_sprites->rotate_sprites::@1]
    // [243] phi rotate_sprites::s#2 = 0 [phi:rotate_sprites->rotate_sprites::@1#0] -- vbuxx=vbuc1 
    tax
    // rotate_sprites::@1
  __b1:
    // for(byte s=0;s<max;s++)
    // [244] if(rotate_sprites::s#2<rotate_sprites::max#0) goto rotate_sprites::@2 -- vbuxx_lt_vwuz1_then_la1 
    lda.z max+1
    bne __b2
    cpx.z max
    bcc __b2
    // rotate_sprites::@return
    // }
    // [245] return 
    rts
    // rotate_sprites::@2
  __b2:
    // i = s+rotate
    // [246] rotate_sprites::i#0 = rotate_sprites::s#2 + rotate_sprites::rotate#4 -- vwuz1=vbuxx_plus_vwuz2 
    txa
    clc
    adc.z rotate
    sta.z i
    lda #0
    adc.z rotate+1
    sta.z i+1
    // if(i>=max)
    // [247] if(rotate_sprites::i#0<rotate_sprites::max#0) goto rotate_sprites::@3 -- vwuz1_lt_vwuz2_then_la1 
    cmp.z max+1
    bcc __b3
    bne !+
    lda.z i
    cmp.z max
    bcc __b3
  !:
    // rotate_sprites::@4
    // i-=max
    // [248] rotate_sprites::i#1 = rotate_sprites::i#0 - rotate_sprites::max#0 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z i
    sec
    sbc.z max
    sta.z i
    lda.z i+1
    sbc.z max+1
    sta.z i+1
    // [249] phi from rotate_sprites::@2 rotate_sprites::@4 to rotate_sprites::@3 [phi:rotate_sprites::@2/rotate_sprites::@4->rotate_sprites::@3]
    // [249] phi rotate_sprites::i#2 = rotate_sprites::i#0 [phi:rotate_sprites::@2/rotate_sprites::@4->rotate_sprites::@3#0] -- register_copy 
    // rotate_sprites::@3
  __b3:
    // vera_sprite_address(s+offset, Sprite->VRAM_Addresses[i])
    // [250] rotate_sprites::vera_sprite_xy1_sprite#0 = rotate_sprites::s#2 + rotate_sprites::offset#0 -- vbuz1=vbuxx_plus_vbuz2 
    txa
    clc
    adc.z offset
    sta.z vera_sprite_xy1_sprite
    // [251] rotate_sprites::$14 = rotate_sprites::i#2 << 2 -- vwuz1=vwuz1_rol_2 
    asl.z __14
    rol.z __14+1
    asl.z __14
    rol.z __14+1
    // [252] rotate_sprites::$17 = (dword*)rotate_sprites::Sprite#2 + OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES -- pduz1=pduz2_plus_vbuc1 
    lda #OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES
    clc
    adc.z Sprite
    sta.z __17
    lda #0
    adc.z Sprite+1
    sta.z __17+1
    // [253] rotate_sprites::$23 = rotate_sprites::$17 + rotate_sprites::$14 -- pduz1=pduz1_plus_vwuz2 
    lda.z __23
    clc
    adc.z __14
    sta.z __23
    lda.z __23+1
    adc.z __14+1
    sta.z __23+1
    // [254] rotate_sprites::vera_sprite_address1_address#0 = *rotate_sprites::$23 -- vduz1=_deref_pduz2 
    ldy #0
    lda (__23),y
    sta.z vera_sprite_address1_address
    iny
    lda (__23),y
    sta.z vera_sprite_address1_address+1
    iny
    lda (__23),y
    sta.z vera_sprite_address1_address+2
    iny
    lda (__23),y
    sta.z vera_sprite_address1_address+3
    // rotate_sprites::vera_sprite_address1
    // (word)sprite << 3
    // [255] rotate_sprites::vera_sprite_address1_$14 = (word)rotate_sprites::vera_sprite_xy1_sprite#0 -- vwuz1=_word_vbuz2 
    lda.z vera_sprite_xy1_sprite
    sta.z vera_sprite_address1___14
    lda #0
    sta.z vera_sprite_address1___14+1
    // [256] rotate_sprites::vera_sprite_address1_$0 = rotate_sprites::vera_sprite_address1_$14 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [257] rotate_sprites::vera_sprite_address1_sprite_offset#0 = <VERA_SPRITE_ATTR + rotate_sprites::vera_sprite_address1_$0 -- vwuz1=vwuc1_plus_vwuz1 
    clc
    lda.z vera_sprite_address1_sprite_offset
    adc #<VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset
    lda.z vera_sprite_address1_sprite_offset+1
    adc #>VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [258] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <sprite_offset
    // [259] rotate_sprites::vera_sprite_address1_$2 = < rotate_sprites::vera_sprite_address1_sprite_offset#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1_sprite_offset
    // *VERA_ADDRX_L = <sprite_offset
    // [260] *VERA_ADDRX_L = rotate_sprites::vera_sprite_address1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset
    // [261] rotate_sprites::vera_sprite_address1_$3 = > rotate_sprites::vera_sprite_address1_sprite_offset#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_address1_sprite_offset+1
    // *VERA_ADDRX_M = >sprite_offset
    // [262] *VERA_ADDRX_M = rotate_sprites::vera_sprite_address1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [263] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <address
    // [264] rotate_sprites::vera_sprite_address1_$4 = < rotate_sprites::vera_sprite_address1_address#0 -- vwuz1=_lo_vduz2 
    lda.z vera_sprite_address1_address
    sta.z vera_sprite_address1___4
    lda.z vera_sprite_address1_address+1
    sta.z vera_sprite_address1___4+1
    // (<address)>>5
    // [265] rotate_sprites::vera_sprite_address1_$5 = rotate_sprites::vera_sprite_address1_$4 >> 5 -- vwuz1=vwuz1_ror_5 
    lsr.z vera_sprite_address1___5+1
    ror.z vera_sprite_address1___5
    lsr.z vera_sprite_address1___5+1
    ror.z vera_sprite_address1___5
    lsr.z vera_sprite_address1___5+1
    ror.z vera_sprite_address1___5
    lsr.z vera_sprite_address1___5+1
    ror.z vera_sprite_address1___5
    lsr.z vera_sprite_address1___5+1
    ror.z vera_sprite_address1___5
    // <((<address)>>5)
    // [266] rotate_sprites::vera_sprite_address1_$6 = < rotate_sprites::vera_sprite_address1_$5 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1___5
    // *VERA_DATA0 = <((<address)>>5)
    // [267] *VERA_DATA0 = rotate_sprites::vera_sprite_address1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // <address
    // [268] rotate_sprites::vera_sprite_address1_$7 = < rotate_sprites::vera_sprite_address1_address#0 -- vwuz1=_lo_vduz2 
    lda.z vera_sprite_address1_address
    sta.z vera_sprite_address1___7
    lda.z vera_sprite_address1_address+1
    sta.z vera_sprite_address1___7+1
    // >(<address)
    // [269] rotate_sprites::vera_sprite_address1_$8 = > rotate_sprites::vera_sprite_address1_$7 -- vbuaa=_hi_vwuz1 
    // (>(<address))>>5
    // [270] rotate_sprites::vera_sprite_address1_$9 = rotate_sprites::vera_sprite_address1_$8 >> 5 -- vbuz1=vbuaa_ror_5 
    lsr
    lsr
    lsr
    lsr
    lsr
    sta.z vera_sprite_address1___9
    // >address
    // [271] rotate_sprites::vera_sprite_address1_$10 = > rotate_sprites::vera_sprite_address1_address#0 -- vwuz1=_hi_vduz2 
    lda.z vera_sprite_address1_address+2
    sta.z vera_sprite_address1___10
    lda.z vera_sprite_address1_address+3
    sta.z vera_sprite_address1___10+1
    // <(>address)
    // [272] rotate_sprites::vera_sprite_address1_$11 = < rotate_sprites::vera_sprite_address1_$10 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1___10
    // (<(>address))<<3
    // [273] rotate_sprites::vera_sprite_address1_$12 = rotate_sprites::vera_sprite_address1_$11 << 3 -- vbuaa=vbuaa_rol_3 
    asl
    asl
    asl
    // ((>(<address))>>5)|((<(>address))<<3)
    // [274] rotate_sprites::vera_sprite_address1_$13 = rotate_sprites::vera_sprite_address1_$9 | rotate_sprites::vera_sprite_address1_$12 -- vbuaa=vbuz1_bor_vbuaa 
    ora.z vera_sprite_address1___9
    // *VERA_DATA0 = ((>(<address))>>5)|((<(>address))<<3)
    // [275] *VERA_DATA0 = rotate_sprites::vera_sprite_address1_$13 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // rotate_sprites::@5
    // s&03
    // [276] rotate_sprites::$7 = rotate_sprites::s#2 & 3 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #3
    // (word)(s&03)<<6
    // [277] rotate_sprites::$21 = (word)rotate_sprites::$7 -- vwuz1=_word_vbuaa 
    sta.z __21
    lda #0
    sta.z __21+1
    // [278] rotate_sprites::$8 = rotate_sprites::$21 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z __8+1
    lsr
    sta.z $ff
    lda.z __8
    ror
    sta.z __8+1
    lda #0
    ror
    sta.z __8
    lsr.z $ff
    ror.z __8+1
    ror.z __8
    // vera_sprite_xy(s+offset, basex+((word)(s&03)<<6), basey+((word)(s>>2)<<6))
    // [279] rotate_sprites::vera_sprite_xy1_x#0 = rotate_sprites::basex#8 + rotate_sprites::$8 -- vwuz1=vwuz2_plus_vwuz1 
    lda.z vera_sprite_xy1_x
    clc
    adc.z basex
    sta.z vera_sprite_xy1_x
    lda.z vera_sprite_xy1_x+1
    adc.z basex+1
    sta.z vera_sprite_xy1_x+1
    // s>>2
    // [280] rotate_sprites::$10 = rotate_sprites::s#2 >> 2 -- vbuaa=vbuxx_ror_2 
    txa
    lsr
    lsr
    // (word)(s>>2)<<6
    // [281] rotate_sprites::$22 = (word)rotate_sprites::$10 -- vwuz1=_word_vbuaa 
    sta.z __22
    lda #0
    sta.z __22+1
    // [282] rotate_sprites::$11 = rotate_sprites::$22 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z __11+1
    lsr
    sta.z $ff
    lda.z __11
    ror
    sta.z __11+1
    lda #0
    ror
    sta.z __11
    lsr.z $ff
    ror.z __11+1
    ror.z __11
    // vera_sprite_xy(s+offset, basex+((word)(s&03)<<6), basey+((word)(s>>2)<<6))
    // [283] rotate_sprites::vera_sprite_xy1_y#0 = $64 + rotate_sprites::$11 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$64
    clc
    adc.z vera_sprite_xy1_y
    sta.z vera_sprite_xy1_y
    bcc !+
    inc.z vera_sprite_xy1_y+1
  !:
    // rotate_sprites::vera_sprite_xy1
    // (word)sprite << 3
    // [284] rotate_sprites::vera_sprite_xy1_$10 = (word)rotate_sprites::vera_sprite_xy1_sprite#0 -- vwuz1=_word_vbuz2 
    lda.z vera_sprite_xy1_sprite
    sta.z vera_sprite_xy1___10
    lda #0
    sta.z vera_sprite_xy1___10+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [285] rotate_sprites::vera_sprite_xy1_sprite_offset#0 = rotate_sprites::vera_sprite_xy1_$10 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [286] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+2
    // [287] rotate_sprites::vera_sprite_xy1_$4 = rotate_sprites::vera_sprite_xy1_sprite_offset#0 + <VERA_SPRITE_ATTR+2 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_xy1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4
    lda.z vera_sprite_xy1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4+1
    // <sprite_offset+2
    // [288] rotate_sprites::vera_sprite_xy1_$3 = < rotate_sprites::vera_sprite_xy1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1___4
    // *VERA_ADDRX_L = <sprite_offset+2
    // [289] *VERA_ADDRX_L = rotate_sprites::vera_sprite_xy1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+2
    // [290] rotate_sprites::vera_sprite_xy1_$5 = > rotate_sprites::vera_sprite_xy1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1___4+1
    // *VERA_ADDRX_M = >sprite_offset+2
    // [291] *VERA_ADDRX_M = rotate_sprites::vera_sprite_xy1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [292] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <x
    // [293] rotate_sprites::vera_sprite_xy1_$6 = < rotate_sprites::vera_sprite_xy1_x#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1_x
    // *VERA_DATA0 = <x
    // [294] *VERA_DATA0 = rotate_sprites::vera_sprite_xy1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // >x
    // [295] rotate_sprites::vera_sprite_xy1_$7 = > rotate_sprites::vera_sprite_xy1_x#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1_x+1
    // *VERA_DATA0 = >x
    // [296] *VERA_DATA0 = rotate_sprites::vera_sprite_xy1_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // <y
    // [297] rotate_sprites::vera_sprite_xy1_$8 = < rotate_sprites::vera_sprite_xy1_y#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1_y
    // *VERA_DATA0 = <y
    // [298] *VERA_DATA0 = rotate_sprites::vera_sprite_xy1_$8 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // >y
    // [299] rotate_sprites::vera_sprite_xy1_$9 = > rotate_sprites::vera_sprite_xy1_y#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1_y+1
    // *VERA_DATA0 = >y
    // [300] *VERA_DATA0 = rotate_sprites::vera_sprite_xy1_$9 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // rotate_sprites::@6
    // for(byte s=0;s<max;s++)
    // [301] rotate_sprites::s#1 = ++ rotate_sprites::s#2 -- vbuxx=_inc_vbuxx 
    inx
    // [243] phi from rotate_sprites::@6 to rotate_sprites::@1 [phi:rotate_sprites::@6->rotate_sprites::@1]
    // [243] phi rotate_sprites::s#2 = rotate_sprites::s#1 [phi:rotate_sprites::@6->rotate_sprites::@1#0] -- register_copy 
    jmp __b1
}
  // vera_cpy_vram_vram
// Copy block of memory (from VRAM to VRAM)
// Copies the values from the location pointed by src to the location pointed by dest.
// The method uses the VERA access ports 0 and 1 to copy data from and to in VRAM.
// - vdest: pointer to the location to copy to. Note that the address is a dword value!
// - vsrc: pointer to the location to copy from. Note that the address is a dword value!
// - num: The number of bytes to copy
// vera_cpy_vram_vram(dword zp(5) vsrc, dword zp(9) vdest, dword zp($b6) num)
vera_cpy_vram_vram: {
    .label __0 = $b2
    .label __2 = $b4
    .label __4 = $b2
    .label __6 = $d2
    .label __8 = $ce
    .label __10 = $b2
    .label i = 5
    .label vsrc = 5
    .label vdest = 9
    .label num = $b6
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [303] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <vsrc
    // [304] vera_cpy_vram_vram::$0 = < vera_cpy_vram_vram::vsrc#2 -- vwuz1=_lo_vduz2 
    lda.z vsrc
    sta.z __0
    lda.z vsrc+1
    sta.z __0+1
    // <(<vsrc)
    // [305] vera_cpy_vram_vram::$1 = < vera_cpy_vram_vram::$0 -- vbuaa=_lo_vwuz1 
    lda.z __0
    // *VERA_ADDRX_L = <(<vsrc)
    // [306] *VERA_ADDRX_L = vera_cpy_vram_vram::$1 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // <vsrc
    // [307] vera_cpy_vram_vram::$2 = < vera_cpy_vram_vram::vsrc#2 -- vwuz1=_lo_vduz2 
    lda.z vsrc
    sta.z __2
    lda.z vsrc+1
    sta.z __2+1
    // >(<vsrc)
    // [308] vera_cpy_vram_vram::$3 = > vera_cpy_vram_vram::$2 -- vbuaa=_hi_vwuz1 
    // *VERA_ADDRX_M = >(<vsrc)
    // [309] *VERA_ADDRX_M = vera_cpy_vram_vram::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // >vsrc
    // [310] vera_cpy_vram_vram::$4 = > vera_cpy_vram_vram::vsrc#2 -- vwuz1=_hi_vduz2 
    lda.z vsrc+2
    sta.z __4
    lda.z vsrc+3
    sta.z __4+1
    // <(>vsrc)
    // [311] vera_cpy_vram_vram::$5 = < vera_cpy_vram_vram::$4 -- vbuaa=_lo_vwuz1 
    lda.z __4
    // *VERA_ADDRX_H = <(>vsrc)
    // [312] *VERA_ADDRX_H = vera_cpy_vram_vram::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_ADDRX_H |= VERA_INC_1
    // [313] *VERA_ADDRX_H = *VERA_ADDRX_H | VERA_INC_1 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora VERA_ADDRX_H
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [314] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    // Select DATA1
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // <vdest
    // [315] vera_cpy_vram_vram::$6 = < vera_cpy_vram_vram::vdest#2 -- vwuz1=_lo_vduz2 
    lda.z vdest
    sta.z __6
    lda.z vdest+1
    sta.z __6+1
    // <(<vdest)
    // [316] vera_cpy_vram_vram::$7 = < vera_cpy_vram_vram::$6 -- vbuaa=_lo_vwuz1 
    lda.z __6
    // *VERA_ADDRX_L = <(<vdest)
    // [317] *VERA_ADDRX_L = vera_cpy_vram_vram::$7 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // <vdest
    // [318] vera_cpy_vram_vram::$8 = < vera_cpy_vram_vram::vdest#2 -- vwuz1=_lo_vduz2 
    lda.z vdest
    sta.z __8
    lda.z vdest+1
    sta.z __8+1
    // >(<vdest)
    // [319] vera_cpy_vram_vram::$9 = > vera_cpy_vram_vram::$8 -- vbuaa=_hi_vwuz1 
    // *VERA_ADDRX_M = >(<vdest)
    // [320] *VERA_ADDRX_M = vera_cpy_vram_vram::$9 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // >vdest
    // [321] vera_cpy_vram_vram::$10 = > vera_cpy_vram_vram::vdest#2 -- vwuz1=_hi_vduz2 
    lda.z vdest+2
    sta.z __10
    lda.z vdest+3
    sta.z __10+1
    // <(>vdest)
    // [322] vera_cpy_vram_vram::$11 = < vera_cpy_vram_vram::$10 -- vbuaa=_lo_vwuz1 
    lda.z __10
    // *VERA_ADDRX_H = <(>vdest)
    // [323] *VERA_ADDRX_H = vera_cpy_vram_vram::$11 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_ADDRX_H |= VERA_INC_1
    // [324] *VERA_ADDRX_H = *VERA_ADDRX_H | VERA_INC_1 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora VERA_ADDRX_H
    sta VERA_ADDRX_H
    // [325] phi from vera_cpy_vram_vram to vera_cpy_vram_vram::@1 [phi:vera_cpy_vram_vram->vera_cpy_vram_vram::@1]
    // [325] phi vera_cpy_vram_vram::i#2 = 0 [phi:vera_cpy_vram_vram->vera_cpy_vram_vram::@1#0] -- vduz1=vduc1 
    lda #<0
    sta.z i
    sta.z i+1
    lda #<0>>$10
    sta.z i+2
    lda #>0>>$10
    sta.z i+3
  // Transfer the data
    // vera_cpy_vram_vram::@1
  __b1:
    // for(dword i=0; i<num; i++)
    // [326] if(vera_cpy_vram_vram::i#2<vera_cpy_vram_vram::num#3) goto vera_cpy_vram_vram::@2 -- vduz1_lt_vduz2_then_la1 
    lda.z i+3
    cmp.z num+3
    bcc __b2
    bne !+
    lda.z i+2
    cmp.z num+2
    bcc __b2
    bne !+
    lda.z i+1
    cmp.z num+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z num
    bcc __b2
  !:
    // vera_cpy_vram_vram::@return
    // }
    // [327] return 
    rts
    // vera_cpy_vram_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [328] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(dword i=0; i<num; i++)
    // [329] vera_cpy_vram_vram::i#1 = ++ vera_cpy_vram_vram::i#2 -- vduz1=_inc_vduz1 
    inc.z i
    bne !+
    inc.z i+1
    bne !+
    inc.z i+2
    bne !+
    inc.z i+3
  !:
    // [325] phi from vera_cpy_vram_vram::@2 to vera_cpy_vram_vram::@1 [phi:vera_cpy_vram_vram::@2->vera_cpy_vram_vram::@1]
    // [325] phi vera_cpy_vram_vram::i#2 = vera_cpy_vram_vram::i#1 [phi:vera_cpy_vram_vram::@2->vera_cpy_vram_vram::@1#0] -- register_copy 
    jmp __b1
}
  // gotoxy
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .label __6 = $49
    .label line_offset = $49
    // if(y>cx16_conio.conio_screen_height)
    // [331] if(gotoxy::y#7<=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto gotoxy::@4 -- vbuxx_le__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    stx.z $ff
    cmp.z $ff
    bcs __b1
    // [333] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [333] phi gotoxy::y#10 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [332] phi from gotoxy to gotoxy::@4 [phi:gotoxy->gotoxy::@4]
    // gotoxy::@4
    // [333] phi from gotoxy::@4 to gotoxy::@1 [phi:gotoxy::@4->gotoxy::@1]
    // [333] phi gotoxy::y#10 = gotoxy::y#7 [phi:gotoxy::@4->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=cx16_conio.conio_screen_width)
    // [334] if(0<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto gotoxy::@2 -- 0_lt__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    cmp #0
    // [335] phi from gotoxy::@1 to gotoxy::@3 [phi:gotoxy::@1->gotoxy::@3]
    // gotoxy::@3
    // gotoxy::@2
    // conio_cursor_x[cx16_conio.conio_screen_layer] = x
    // [336] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = y
    // [337] conio_cursor_y[*((byte*)&cx16_conio)] = gotoxy::y#10 -- pbuc1_derefidx_(_deref_pbuc2)=vbuxx 
    txa
    sta conio_cursor_y,y
    // (unsigned int)y << cx16_conio.conio_rowshift
    // [338] gotoxy::$6 = (word)gotoxy::y#10 -- vwuz1=_word_vbuxx 
    txa
    sta.z __6
    lda #0
    sta.z __6+1
    // line_offset = (unsigned int)y << cx16_conio.conio_rowshift
    // [339] gotoxy::line_offset#0 = gotoxy::$6 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vwuz1_rol__deref_pbuc1 
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
    // [340] gotoxy::$5 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // [341] conio_line_text[gotoxy::$5] = gotoxy::line_offset#0 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z line_offset
    sta conio_line_text,y
    lda.z line_offset+1
    sta conio_line_text+1,y
    // gotoxy::@return
    // }
    // [342] return 
    rts
}
  // cputs
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp($20) s)
cputs: {
    .label s = $20
    // [344] phi from cputs cputs::@2 to cputs::@1 [phi:cputs/cputs::@2->cputs::@1]
    // [344] phi cputs::s#25 = cputs::s#26 [phi:cputs/cputs::@2->cputs::@1#0] -- register_copy 
    // cputs::@1
  __b1:
    // while(c=*s++)
    // [345] cputs::c#1 = *cputs::s#25 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (s),y
    // [346] cputs::s#0 = ++ cputs::s#25 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [347] if(0!=cputs::c#1) goto cputs::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // cputs::@return
    // }
    // [348] return 
    rts
    // cputs::@2
  __b2:
    // cputc(c)
    // [349] cputc::c#0 = cputs::c#1 -- vbuz1=vbuaa 
    sta.z cputc.c
    // [350] call cputc 
    // [1133] phi from cputs::@2 to cputc [phi:cputs::@2->cputc]
    // [1133] phi cputc::c#3 = cputc::c#0 [phi:cputs::@2->cputc#0] -- register_copy 
    jsr cputc
    jmp __b1
}
  // printf_ulong
// Print an unsigned int using a specific format
// printf_ulong(dword zp(5) uvalue)
printf_ulong: {
    .label uvalue = 5
    // printf_ulong::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [352] *((byte*)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format.radix)
    // [353] ultoa::value#1 = printf_ulong::uvalue#10
    // [354] call ultoa 
  // Format number into buffer
    // [1167] phi from printf_ulong::@1 to ultoa [phi:printf_ulong::@1->ultoa]
    jsr ultoa
    // printf_ulong::@2
    // printf_number_buffer(printf_buffer, format)
    // [355] printf_number_buffer::buffer_sign#0 = *((byte*)&printf_buffer) -- vbuaa=_deref_pbuc1 
    lda printf_buffer
    // [356] call printf_number_buffer 
  // Print using format
    // [1188] phi from printf_ulong::@2 to printf_number_buffer [phi:printf_ulong::@2->printf_number_buffer]
    // [1188] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#0 [phi:printf_ulong::@2->printf_number_buffer#0] -- register_copy 
    jsr printf_number_buffer
    // printf_ulong::@return
    // }
    // [357] return 
    rts
}
  // printf_uint
// Print an unsigned int using a specific format
// printf_uint(word zp($34) uvalue)
printf_uint: {
    .label uvalue = $34
    // printf_uint::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [359] *((byte*)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
    // [360] utoa::value#1 = printf_uint::uvalue#2
    // [361] call utoa 
  // Format number into buffer
    // [1195] phi from printf_uint::@1 to utoa [phi:printf_uint::@1->utoa]
    jsr utoa
    // printf_uint::@2
    // printf_number_buffer(printf_buffer, format)
    // [362] printf_number_buffer::buffer_sign#1 = *((byte*)&printf_buffer) -- vbuaa=_deref_pbuc1 
    lda printf_buffer
    // [363] call printf_number_buffer 
  // Print using format
    // [1188] phi from printf_uint::@2 to printf_number_buffer [phi:printf_uint::@2->printf_number_buffer]
    // [1188] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#1 [phi:printf_uint::@2->printf_number_buffer#0] -- register_copy 
    jsr printf_number_buffer
    // printf_uint::@return
    // }
    // [364] return 
    rts
}
  // rand
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
rand: {
    .label __0 = $b2
    .label __1 = $b4
    .label __2 = $b2
    .label return = $20
    // rand_state << 7
    // [366] rand::$0 = rand_state#13 << 7 -- vwuz1=vwuz2_rol_7 
    lda.z rand_state+1
    lsr
    lda.z rand_state
    ror
    sta.z __0+1
    lda #0
    ror
    sta.z __0
    // rand_state ^= rand_state << 7
    // [367] rand_state#0 = rand_state#13 ^ rand::$0 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __0
    sta.z rand_state
    lda.z rand_state+1
    eor.z __0+1
    sta.z rand_state+1
    // rand_state >> 9
    // [368] rand::$1 = rand_state#0 >> 9 -- vwuz1=vwuz2_ror_9 
    lsr
    sta.z __1
    lda #0
    sta.z __1+1
    // rand_state ^= rand_state >> 9
    // [369] rand_state#1 = rand_state#0 ^ rand::$1 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __1
    sta.z rand_state
    lda.z rand_state+1
    eor.z __1+1
    sta.z rand_state+1
    // rand_state << 8
    // [370] rand::$2 = rand_state#1 << 8 -- vwuz1=vwuz2_rol_8 
    lda.z rand_state
    sta.z __2+1
    lda #0
    sta.z __2
    // rand_state ^= rand_state << 8
    // [371] rand_state#14 = rand_state#1 ^ rand::$2 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __2
    sta.z rand_state
    lda.z rand_state+1
    eor.z __2+1
    sta.z rand_state+1
    // return rand_state;
    // [372] rand::return#0 = rand_state#14 -- vwuz1=vwuz2 
    lda.z rand_state
    sta.z return
    lda.z rand_state+1
    sta.z return+1
    // rand::@return
    // }
    // [373] return 
    rts
}
  // modr16u
// Performs modulo on two 16 bit unsigned ints and an initial remainder
// Returns the remainder.
// Implemented using simple binary division
// modr16u(word zp($20) dividend)
modr16u: {
    .label return = $b2
    .label dividend = $20
    // divr16u(dividend, divisor, rem)
    // [375] divr16u::dividend#1 = modr16u::dividend#2
    // [376] call divr16u 
    // [1216] phi from modr16u to divr16u [phi:modr16u->divr16u]
    jsr divr16u
    // modr16u::@1
    // return rem16u;
    // [377] modr16u::return#0 = divr16u::rem#10 -- vwuz1=vwuz2 
    lda.z divr16u.rem
    sta.z return
    lda.z divr16u.rem+1
    sta.z return+1
    // modr16u::@return
    // }
    // [378] return 
    rts
}
  // vera_tile_element
// vera_tile_element(byte register(X) x, byte zp($1f) y, struct Tile* zp($20) Tile)
vera_tile_element: {
    .label __3 = $b2
    .label __16 = $1f
    .label __33 = $b2
    .label vera_vram_address01___0 = $b2
    .label vera_vram_address01___2 = $b4
    .label vera_vram_address01___4 = $b2
    .label TileOffset = $d2
    .label TileTotal = $4b
    .label TileCount = $4c
    .label TileColumns = $4d
    .label PaletteOffset = $4e
    .label y = $1f
    .label mapbase = 9
    .label shift = $d
    .label rowskip = $ce
    .label j = $d0
    .label i = $d1
    .label r = $d
    .label x = $d
    .label Tile = $20
    // TileOffset = Tile->Offset
    // [380] vera_tile_element::TileOffset#0 = ((word*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_OFFSET] -- vwuz1=pwuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_OFFSET
    lda (Tile),y
    sta.z TileOffset
    iny
    lda (Tile),y
    sta.z TileOffset+1
    // TileTotal = Tile->DrawTotal
    // [381] vera_tile_element::TileTotal#0 = ((byte*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_DRAWTOTAL] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_DRAWTOTAL
    lda (Tile),y
    sta.z TileTotal
    // TileCount = Tile->DrawCount
    // [382] vera_tile_element::TileCount#0 = ((byte*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_DRAWCOUNT] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_DRAWCOUNT
    lda (Tile),y
    sta.z TileCount
    // TileColumns = Tile->DrawColumns
    // [383] vera_tile_element::TileColumns#0 = ((byte*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_DRAWCOLUMNS] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_DRAWCOLUMNS
    lda (Tile),y
    sta.z TileColumns
    // PaletteOffset = Tile->Palette
    // [384] vera_tile_element::PaletteOffset#0 = ((byte*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_PALETTE] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_PALETTE
    lda (Tile),y
    sta.z PaletteOffset
    // x = x << resolution
    // [385] vera_tile_element::x#0 = vera_tile_element::x#3 << 3 -- vbuxx=vbuz1_rol_3 
    lda.z x
    asl
    asl
    asl
    tax
    // y = y << resolution
    // [386] vera_tile_element::y#0 = vera_tile_element::y#3 << 3 -- vbuz1=vbuz1_rol_3 
    lda.z y
    asl
    asl
    asl
    sta.z y
    // mapbase = vera_mapbase_address[layer]
    // [387] vera_tile_element::mapbase#0 = *vera_mapbase_address -- vduz1=_deref_pduc1 
    lda vera_mapbase_address
    sta.z mapbase
    lda vera_mapbase_address+1
    sta.z mapbase+1
    lda vera_mapbase_address+2
    sta.z mapbase+2
    lda vera_mapbase_address+3
    sta.z mapbase+3
    // shift = vera_layer_rowshift[layer]
    // [388] vera_tile_element::shift#0 = *vera_layer_rowshift -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift
    sta.z shift
    // rowskip = (word)1 << shift
    // [389] vera_tile_element::rowskip#0 = 1 << vera_tile_element::shift#0 -- vwuz1=vwuc1_rol_vbuz2 
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
    // (word)y << shift
    // [390] vera_tile_element::$33 = (word)vera_tile_element::y#0 -- vwuz1=_word_vbuz2 
    lda.z y
    sta.z __33
    lda #0
    sta.z __33+1
    // [391] vera_tile_element::$3 = vera_tile_element::$33 << vera_tile_element::shift#0 -- vwuz1=vwuz1_rol_vbuz2 
    ldy.z shift
    beq !e+
  !:
    asl.z __3
    rol.z __3+1
    dey
    bne !-
  !e:
    // mapbase += ((word)y << shift)
    // [392] vera_tile_element::mapbase#1 = vera_tile_element::mapbase#0 + vera_tile_element::$3 -- vduz1=vduz1_plus_vwuz2 
    lda.z mapbase
    clc
    adc.z __3
    sta.z mapbase
    lda.z mapbase+1
    adc.z __3+1
    sta.z mapbase+1
    lda.z mapbase+2
    adc #0
    sta.z mapbase+2
    lda.z mapbase+3
    adc #0
    sta.z mapbase+3
    // x << 1
    // [393] vera_tile_element::$4 = vera_tile_element::x#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // mapbase += (x << 1)
    // [394] vera_tile_element::mapbase#2 = vera_tile_element::mapbase#1 + vera_tile_element::$4 -- vduz1=vduz1_plus_vbuaa 
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
    // [395] phi from vera_tile_element to vera_tile_element::@1 [phi:vera_tile_element->vera_tile_element::@1]
    // [395] phi vera_tile_element::mapbase#11 = vera_tile_element::mapbase#2 [phi:vera_tile_element->vera_tile_element::@1#0] -- register_copy 
    // [395] phi vera_tile_element::j#2 = 0 [phi:vera_tile_element->vera_tile_element::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z j
    // vera_tile_element::@1
  __b1:
    // for(byte j=0;j<TileTotal;j+=(TileTotal>>1))
    // [396] if(vera_tile_element::j#2<vera_tile_element::TileTotal#0) goto vera_tile_element::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z j
    cmp.z TileTotal
    bcc __b3
    // vera_tile_element::@return
    // }
    // [397] return 
    rts
    // [398] phi from vera_tile_element::@1 to vera_tile_element::@2 [phi:vera_tile_element::@1->vera_tile_element::@2]
  __b3:
    // [398] phi vera_tile_element::mapbase#10 = vera_tile_element::mapbase#11 [phi:vera_tile_element::@1->vera_tile_element::@2#0] -- register_copy 
    // [398] phi vera_tile_element::i#10 = 0 [phi:vera_tile_element::@1->vera_tile_element::@2#1] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // vera_tile_element::@2
  __b2:
    // for(byte i=0;i<TileCount;i+=(TileColumns))
    // [399] if(vera_tile_element::i#10<vera_tile_element::TileCount#0) goto vera_tile_element::vera_vram_address01 -- vbuz1_lt_vbuz2_then_la1 
    lda.z i
    cmp.z TileCount
    bcc vera_vram_address01
    // vera_tile_element::@3
    // TileTotal>>1
    // [400] vera_tile_element::$19 = vera_tile_element::TileTotal#0 >> 1 -- vbuaa=vbuz1_ror_1 
    lda.z TileTotal
    lsr
    // j+=(TileTotal>>1)
    // [401] vera_tile_element::j#1 = vera_tile_element::j#2 + vera_tile_element::$19 -- vbuz1=vbuz1_plus_vbuaa 
    clc
    adc.z j
    sta.z j
    // [395] phi from vera_tile_element::@3 to vera_tile_element::@1 [phi:vera_tile_element::@3->vera_tile_element::@1]
    // [395] phi vera_tile_element::mapbase#11 = vera_tile_element::mapbase#10 [phi:vera_tile_element::@3->vera_tile_element::@1#0] -- register_copy 
    // [395] phi vera_tile_element::j#2 = vera_tile_element::j#1 [phi:vera_tile_element::@3->vera_tile_element::@1#1] -- register_copy 
    jmp __b1
    // vera_tile_element::vera_vram_address01
  vera_vram_address01:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [402] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <bankaddr
    // [403] vera_tile_element::vera_vram_address01_$0 = < vera_tile_element::mapbase#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase
    sta.z vera_vram_address01___0
    lda.z mapbase+1
    sta.z vera_vram_address01___0+1
    // <(<bankaddr)
    // [404] vera_tile_element::vera_vram_address01_$1 = < vera_tile_element::vera_vram_address01_$0 -- vbuaa=_lo_vwuz1 
    lda.z vera_vram_address01___0
    // *VERA_ADDRX_L = <(<bankaddr)
    // [405] *VERA_ADDRX_L = vera_tile_element::vera_vram_address01_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // <bankaddr
    // [406] vera_tile_element::vera_vram_address01_$2 = < vera_tile_element::mapbase#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase
    sta.z vera_vram_address01___2
    lda.z mapbase+1
    sta.z vera_vram_address01___2+1
    // >(<bankaddr)
    // [407] vera_tile_element::vera_vram_address01_$3 = > vera_tile_element::vera_vram_address01_$2 -- vbuaa=_hi_vwuz1 
    // *VERA_ADDRX_M = >(<bankaddr)
    // [408] *VERA_ADDRX_M = vera_tile_element::vera_vram_address01_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // >bankaddr
    // [409] vera_tile_element::vera_vram_address01_$4 = > vera_tile_element::mapbase#10 -- vwuz1=_hi_vduz2 
    lda.z mapbase+2
    sta.z vera_vram_address01___4
    lda.z mapbase+3
    sta.z vera_vram_address01___4+1
    // <(>bankaddr)
    // [410] vera_tile_element::vera_vram_address01_$5 = < vera_tile_element::vera_vram_address01_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_vram_address01___4
    // <(>bankaddr) | incr
    // [411] vera_tile_element::vera_vram_address01_$6 = vera_tile_element::vera_vram_address01_$5 | VERA_INC_1 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_INC_1
    // *VERA_ADDRX_H = <(>bankaddr) | incr
    // [412] *VERA_ADDRX_H = vera_tile_element::vera_vram_address01_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [413] phi from vera_tile_element::vera_vram_address01 to vera_tile_element::@4 [phi:vera_tile_element::vera_vram_address01->vera_tile_element::@4]
    // [413] phi vera_tile_element::r#2 = 0 [phi:vera_tile_element::vera_vram_address01->vera_tile_element::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // vera_tile_element::@4
  __b4:
    // TileTotal>>1
    // [414] vera_tile_element::$8 = vera_tile_element::TileTotal#0 >> 1 -- vbuaa=vbuz1_ror_1 
    lda.z TileTotal
    lsr
    // for(byte r=0;r<(TileTotal>>1);r+=TileCount)
    // [415] if(vera_tile_element::r#2<vera_tile_element::$8) goto vera_tile_element::@6 -- vbuz1_lt_vbuaa_then_la1 
    cmp.z r
    beq !+
    bcs __b5
  !:
    // vera_tile_element::@5
    // mapbase += rowskip
    // [416] vera_tile_element::mapbase#3 = vera_tile_element::mapbase#10 + vera_tile_element::rowskip#0 -- vduz1=vduz1_plus_vwuz2 
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
    // i+=(TileColumns)
    // [417] vera_tile_element::i#1 = vera_tile_element::i#10 + vera_tile_element::TileColumns#0 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z i
    clc
    adc.z TileColumns
    sta.z i
    // [398] phi from vera_tile_element::@5 to vera_tile_element::@2 [phi:vera_tile_element::@5->vera_tile_element::@2]
    // [398] phi vera_tile_element::mapbase#10 = vera_tile_element::mapbase#3 [phi:vera_tile_element::@5->vera_tile_element::@2#0] -- register_copy 
    // [398] phi vera_tile_element::i#10 = vera_tile_element::i#1 [phi:vera_tile_element::@5->vera_tile_element::@2#1] -- register_copy 
    jmp __b2
    // [418] phi from vera_tile_element::@4 to vera_tile_element::@6 [phi:vera_tile_element::@4->vera_tile_element::@6]
  __b5:
    // [418] phi vera_tile_element::c#2 = 0 [phi:vera_tile_element::@4->vera_tile_element::@6#0] -- vbuxx=vbuc1 
    ldx #0
    // vera_tile_element::@6
  __b6:
    // for(byte c=0;c<TileColumns;c+=1)
    // [419] if(vera_tile_element::c#2<vera_tile_element::TileColumns#0) goto vera_tile_element::@7 -- vbuxx_lt_vbuz1_then_la1 
    cpx.z TileColumns
    bcc __b7
    // vera_tile_element::@8
    // r+=TileCount
    // [420] vera_tile_element::r#1 = vera_tile_element::r#2 + vera_tile_element::TileCount#0 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z r
    clc
    adc.z TileCount
    sta.z r
    // [413] phi from vera_tile_element::@8 to vera_tile_element::@4 [phi:vera_tile_element::@8->vera_tile_element::@4]
    // [413] phi vera_tile_element::r#2 = vera_tile_element::r#1 [phi:vera_tile_element::@8->vera_tile_element::@4#0] -- register_copy 
    jmp __b4
    // vera_tile_element::@7
  __b7:
    // <TileOffset
    // [421] vera_tile_element::$11 = < vera_tile_element::TileOffset#0 -- vbuaa=_lo_vwuz1 
    lda.z TileOffset
    // (<TileOffset)+c
    // [422] vera_tile_element::$12 = vera_tile_element::$11 + vera_tile_element::c#2 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // (<TileOffset)+c+r
    // [423] vera_tile_element::$13 = vera_tile_element::$12 + vera_tile_element::r#2 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z r
    // (<TileOffset)+c+r+i
    // [424] vera_tile_element::$14 = vera_tile_element::$13 + vera_tile_element::i#10 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z i
    // (<TileOffset)+c+r+i+j
    // [425] vera_tile_element::$15 = vera_tile_element::$14 + vera_tile_element::j#2 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z j
    // *VERA_DATA0 = (<TileOffset)+c+r+i+j
    // [426] *VERA_DATA0 = vera_tile_element::$15 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // PaletteOffset << 4
    // [427] vera_tile_element::$16 = vera_tile_element::PaletteOffset#0 << 4 -- vbuz1=vbuz2_rol_4 
    lda.z PaletteOffset
    asl
    asl
    asl
    asl
    sta.z __16
    // >TileOffset
    // [428] vera_tile_element::$17 = > vera_tile_element::TileOffset#0 -- vbuaa=_hi_vwuz1 
    lda.z TileOffset+1
    // PaletteOffset << 4 | (>TileOffset)
    // [429] vera_tile_element::$18 = vera_tile_element::$16 | vera_tile_element::$17 -- vbuaa=vbuz1_bor_vbuaa 
    ora.z __16
    // *VERA_DATA0 = PaletteOffset << 4 | (>TileOffset)
    // [430] *VERA_DATA0 = vera_tile_element::$18 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // c+=1
    // [431] vera_tile_element::c#1 = vera_tile_element::c#2 + 1 -- vbuxx=vbuxx_plus_1 
    inx
    // [418] phi from vera_tile_element::@7 to vera_tile_element::@6 [phi:vera_tile_element::@7->vera_tile_element::@6]
    // [418] phi vera_tile_element::c#2 = vera_tile_element::c#1 [phi:vera_tile_element::@7->vera_tile_element::@6#0] -- register_copy 
    jmp __b6
}
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
    // [433] call vera_layer_mode_tile 
    // [689] phi from vera_layer_mode_text to vera_layer_mode_tile [phi:vera_layer_mode_text->vera_layer_mode_tile]
    // [689] phi vera_layer_mode_tile::tileheight#10 = vera_layer_mode_text::tileheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #tileheight
    sta.z vera_layer_mode_tile.tileheight
    // [689] phi vera_layer_mode_tile::tilewidth#10 = vera_layer_mode_text::tilewidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    lda #tilewidth
    sta.z vera_layer_mode_tile.tilewidth
    // [689] phi vera_layer_mode_tile::tilebase_address#10 = vera_layer_mode_text::tilebase_address#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<tilebase_address>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>tilebase_address>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [689] phi vera_layer_mode_tile::mapbase_address#10 = vera_layer_mode_text::mapbase_address#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<mapbase_address>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>mapbase_address>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [689] phi vera_layer_mode_tile::mapheight#10 = vera_layer_mode_text::mapheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#4] -- vwuz1=vwuc1 
    lda #<mapheight
    sta.z vera_layer_mode_tile.mapheight
    lda #>mapheight
    sta.z vera_layer_mode_tile.mapheight+1
    // [689] phi vera_layer_mode_tile::layer#10 = vera_layer_mode_text::layer#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #layer
    sta.z vera_layer_mode_tile.layer
    // [689] phi vera_layer_mode_tile::mapwidth#10 = vera_layer_mode_text::mapwidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#6] -- vwuz1=vwuc1 
    lda #<mapwidth
    sta.z vera_layer_mode_tile.mapwidth
    lda #>mapwidth
    sta.z vera_layer_mode_tile.mapwidth+1
    // [689] phi vera_layer_mode_tile::color_depth#3 = 1 [phi:vera_layer_mode_text->vera_layer_mode_tile#7] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_mode_tile
    // [434] phi from vera_layer_mode_text to vera_layer_mode_text::@1 [phi:vera_layer_mode_text->vera_layer_mode_text::@1]
    // vera_layer_mode_text::@1
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C )
    // [435] call vera_layer_set_text_color_mode 
    jsr vera_layer_set_text_color_mode
    // vera_layer_mode_text::@return
    // }
    // [436] return 
    rts
}
  // screensize
// Return the current screen size.
screensize: {
    .label x = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    .label y = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    // hscale = (*VERA_DC_HSCALE) >> 7
    // [437] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuaa=_deref_pbuc1_ror_7 
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    // 40 << hscale
    // [438] screensize::$1 = $28 << screensize::hscale#0 -- vbuaa=vbuc1_rol_vbuaa 
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
    // [439] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbuaa 
    sta x
    // vscale = (*VERA_DC_VSCALE) >> 7
    // [440] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuaa=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    // 30 << vscale
    // [441] screensize::$3 = $1e << screensize::vscale#0 -- vbuaa=vbuc1_rol_vbuaa 
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
    // [442] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbuaa 
    sta y
    // screensize::@return
    // }
    // [443] return 
    rts
}
  // screenlayer
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer: {
    .label __1 = $4f
    .label __5 = $4f
    .label vera_layer_get_width1_config = $51
    .label vera_layer_get_width1_return = $4f
    .label vera_layer_get_height1_config = $4f
    .label vera_layer_get_height1_return = $4f
    // cx16_conio.conio_screen_layer = layer
    // [444] *((byte*)&cx16_conio) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta cx16_conio
    // vera_layer_get_mapbase_bank(layer)
    // [445] call vera_layer_get_mapbase_bank 
    jsr vera_layer_get_mapbase_bank
    // [446] vera_layer_get_mapbase_bank::return#2 = vera_layer_get_mapbase_bank::return#0
    // screenlayer::@3
    // [447] screenlayer::$0 = vera_layer_get_mapbase_bank::return#2
    // cx16_conio.conio_screen_bank = vera_layer_get_mapbase_bank(layer)
    // [448] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) = screenlayer::$0 -- _deref_pbuc1=vbuaa 
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // vera_layer_get_mapbase_offset(layer)
    // [449] call vera_layer_get_mapbase_offset 
    jsr vera_layer_get_mapbase_offset
    // [450] vera_layer_get_mapbase_offset::return#2 = vera_layer_get_mapbase_offset::return#0
    // screenlayer::@4
    // [451] screenlayer::$1 = vera_layer_get_mapbase_offset::return#2
    // cx16_conio.conio_screen_text = vera_layer_get_mapbase_offset(layer)
    // [452] *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) = (byte*)screenlayer::$1 -- _deref_qbuc1=pbuz1 
    lda.z __1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    lda.z __1+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    // screenlayer::vera_layer_get_width1
    // config = vera_layer_config[layer]
    // [453] screenlayer::vera_layer_get_width1_config#0 = *(vera_layer_config+1<<1) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+(1<<1)
    sta.z vera_layer_get_width1_config
    lda vera_layer_config+(1<<1)+1
    sta.z vera_layer_get_width1_config+1
    // *config & VERA_LAYER_WIDTH_MASK
    // [454] screenlayer::vera_layer_get_width1_$0 = *screenlayer::vera_layer_get_width1_config#0 & VERA_LAYER_WIDTH_MASK -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    ldy #0
    and (vera_layer_get_width1_config),y
    // (*config & VERA_LAYER_WIDTH_MASK) >> 4
    // [455] screenlayer::vera_layer_get_width1_$1 = screenlayer::vera_layer_get_width1_$0 >> 4 -- vbuaa=vbuaa_ror_4 
    lsr
    lsr
    lsr
    lsr
    // return VERA_LAYER_WIDTH[ (*config & VERA_LAYER_WIDTH_MASK) >> 4];
    // [456] screenlayer::vera_layer_get_width1_$3 = screenlayer::vera_layer_get_width1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [457] screenlayer::vera_layer_get_width1_return#0 = VERA_LAYER_WIDTH[screenlayer::vera_layer_get_width1_$3] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda VERA_LAYER_WIDTH,y
    sta.z vera_layer_get_width1_return
    lda VERA_LAYER_WIDTH+1,y
    sta.z vera_layer_get_width1_return+1
    // screenlayer::@1
    // cx16_conio.conio_map_width = vera_layer_get_width(layer)
    // [458] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) = screenlayer::vera_layer_get_width1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_width1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    lda.z vera_layer_get_width1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    // screenlayer::vera_layer_get_height1
    // config = vera_layer_config[layer]
    // [459] screenlayer::vera_layer_get_height1_config#0 = *(vera_layer_config+1<<1) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+(1<<1)
    sta.z vera_layer_get_height1_config
    lda vera_layer_config+(1<<1)+1
    sta.z vera_layer_get_height1_config+1
    // *config & VERA_LAYER_HEIGHT_MASK
    // [460] screenlayer::vera_layer_get_height1_$0 = *screenlayer::vera_layer_get_height1_config#0 & VERA_LAYER_HEIGHT_MASK -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    ldy #0
    and (vera_layer_get_height1_config),y
    // (*config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [461] screenlayer::vera_layer_get_height1_$1 = screenlayer::vera_layer_get_height1_$0 >> 6 -- vbuaa=vbuaa_ror_6 
    rol
    rol
    rol
    and #3
    // return VERA_LAYER_HEIGHT[ (*config & VERA_LAYER_HEIGHT_MASK) >> 6];
    // [462] screenlayer::vera_layer_get_height1_$3 = screenlayer::vera_layer_get_height1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [463] screenlayer::vera_layer_get_height1_return#0 = VERA_LAYER_HEIGHT[screenlayer::vera_layer_get_height1_$3] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda VERA_LAYER_HEIGHT,y
    sta.z vera_layer_get_height1_return
    lda VERA_LAYER_HEIGHT+1,y
    sta.z vera_layer_get_height1_return+1
    // screenlayer::@2
    // cx16_conio.conio_map_height = vera_layer_get_height(layer)
    // [464] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) = screenlayer::vera_layer_get_height1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_height1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    lda.z vera_layer_get_height1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    // vera_layer_get_rowshift(layer)
    // [465] call vera_layer_get_rowshift 
    jsr vera_layer_get_rowshift
    // [466] vera_layer_get_rowshift::return#2 = vera_layer_get_rowshift::return#0
    // screenlayer::@5
    // [467] screenlayer::$4 = vera_layer_get_rowshift::return#2
    // cx16_conio.conio_rowshift = vera_layer_get_rowshift(layer)
    // [468] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) = screenlayer::$4 -- _deref_pbuc1=vbuaa 
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
    // vera_layer_get_rowskip(layer)
    // [469] call vera_layer_get_rowskip 
    jsr vera_layer_get_rowskip
    // [470] vera_layer_get_rowskip::return#2 = vera_layer_get_rowskip::return#0
    // screenlayer::@6
    // [471] screenlayer::$5 = vera_layer_get_rowskip::return#2
    // cx16_conio.conio_rowskip = vera_layer_get_rowskip(layer)
    // [472] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) = screenlayer::$5 -- _deref_pwuc1=vwuz1 
    lda.z __5
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    lda.z __5+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    // screenlayer::@return
    // }
    // [473] return 
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
    // [475] vera_layer_textcolor[vera_layer_set_textcolor::layer#2] = WHITE -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #WHITE
    sta vera_layer_textcolor,x
    // vera_layer_set_textcolor::@return
    // }
    // [476] return 
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
    // [478] vera_layer_backcolor[vera_layer_set_backcolor::layer#2] = vera_layer_set_backcolor::color#2 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta vera_layer_backcolor,x
    // vera_layer_set_backcolor::@return
    // }
    // [479] return 
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
    .label addr = $4f
    // addr = vera_layer_mapbase[layer]
    // [481] vera_layer_set_mapbase::$0 = vera_layer_set_mapbase::layer#3 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [482] vera_layer_set_mapbase::addr#0 = vera_layer_mapbase[vera_layer_set_mapbase::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_mapbase,y
    sta.z addr
    lda vera_layer_mapbase+1,y
    sta.z addr+1
    // *addr = mapbase
    // [483] *vera_layer_set_mapbase::addr#0 = vera_layer_set_mapbase::mapbase#3 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_mapbase::@return
    // }
    // [484] return 
    rts
}
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
cursor: {
    .const onoff = 0
    // cx16_conio.conio_display_cursor = onoff
    // [485] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR
    // cursor::@return
    // }
    // [486] return 
    rts
}
  // load_sprite
// load_sprite(struct Sprite* zp($67) Sprite, dword zp($24) bram_address)
load_sprite: {
    .label status = $53
    .label size = $67
    .label return = $24
    .label Sprite = $67
    .label bram_address = $24
    // cx16_load_ram_banked(1, 8, 0, Sprite->File, bram_address)
    // [488] cx16_load_ram_banked::filename#0 = (byte*)load_sprite::Sprite#10 -- pbuz1=pbuz2 
    lda.z Sprite
    sta.z cx16_load_ram_banked.filename
    lda.z Sprite+1
    sta.z cx16_load_ram_banked.filename+1
    // [489] cx16_load_ram_banked::address#0 = load_sprite::bram_address#10 -- vduz1=vduz2 
    lda.z bram_address
    sta.z cx16_load_ram_banked.address
    lda.z bram_address+1
    sta.z cx16_load_ram_banked.address+1
    lda.z bram_address+2
    sta.z cx16_load_ram_banked.address+2
    lda.z bram_address+3
    sta.z cx16_load_ram_banked.address+3
    // [490] call cx16_load_ram_banked 
    // [529] phi from load_sprite to cx16_load_ram_banked [phi:load_sprite->cx16_load_ram_banked]
    // [529] phi cx16_load_ram_banked::filename#3 = cx16_load_ram_banked::filename#0 [phi:load_sprite->cx16_load_ram_banked#0] -- register_copy 
    // [529] phi cx16_load_ram_banked::address#3 = cx16_load_ram_banked::address#0 [phi:load_sprite->cx16_load_ram_banked#1] -- register_copy 
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, Sprite->File, bram_address)
    // [491] cx16_load_ram_banked::return#4 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // load_sprite::@3
    // status = cx16_load_ram_banked(1, 8, 0, Sprite->File, bram_address)
    // [492] load_sprite::status#0 = cx16_load_ram_banked::return#4 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$ff)
    // [493] if(load_sprite::status#0==$ff) goto load_sprite::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [494] phi from load_sprite::@3 to load_sprite::@2 [phi:load_sprite::@3->load_sprite::@2]
    // load_sprite::@2
    // printf("error file %s: %x\n", Sprite->File, status)
    // [495] call cputs 
    // [343] phi from load_sprite::@2 to cputs [phi:load_sprite::@2->cputs]
    // [343] phi cputs::s#26 = s [phi:load_sprite::@2->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // load_sprite::@4
    // printf("error file %s: %x\n", Sprite->File, status)
    // [496] printf_string::str#0 = (byte*)load_sprite::Sprite#10 -- pbuz1=pbuz2 
    lda.z Sprite
    sta.z printf_string.str
    lda.z Sprite+1
    sta.z printf_string.str+1
    // [497] call printf_string 
    // [1245] phi from load_sprite::@4 to printf_string [phi:load_sprite::@4->printf_string]
    // [1245] phi printf_string::str#2 = printf_string::str#0 [phi:load_sprite::@4->printf_string#0] -- register_copy 
    jsr printf_string
    // [498] phi from load_sprite::@4 to load_sprite::@5 [phi:load_sprite::@4->load_sprite::@5]
    // load_sprite::@5
    // printf("error file %s: %x\n", Sprite->File, status)
    // [499] call cputs 
    // [343] phi from load_sprite::@5 to cputs [phi:load_sprite::@5->cputs]
    // [343] phi cputs::s#26 = s1 [phi:load_sprite::@5->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // load_sprite::@6
    // printf("error file %s: %x\n", Sprite->File, status)
    // [500] printf_uchar::uvalue#2 = load_sprite::status#0 -- vbuxx=vbuz1 
    ldx.z status
    // [501] call printf_uchar 
    // [596] phi from load_sprite::@6 to printf_uchar [phi:load_sprite::@6->printf_uchar]
    // [596] phi printf_uchar::format_radix#5 = HEXADECIMAL [phi:load_sprite::@6->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [596] phi printf_uchar::uvalue#5 = printf_uchar::uvalue#2 [phi:load_sprite::@6->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [502] phi from load_sprite::@6 to load_sprite::@7 [phi:load_sprite::@6->load_sprite::@7]
    // load_sprite::@7
    // printf("error file %s: %x\n", Sprite->File, status)
    // [503] call cputs 
    // [343] phi from load_sprite::@7 to cputs [phi:load_sprite::@7->cputs]
    // [343] phi cputs::s#26 = s2 [phi:load_sprite::@7->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // load_sprite::@1
  __b1:
    // Sprite->BRAM_Address = bram_address
    // [504] ((dword*)load_sprite::Sprite#10)[OFFSET_STRUCT_SPRITE_BRAM_ADDRESS] = load_sprite::bram_address#10 -- pduz1_derefidx_vbuc1=vduz2 
    ldy #OFFSET_STRUCT_SPRITE_BRAM_ADDRESS
    lda.z bram_address
    sta (Sprite),y
    iny
    lda.z bram_address+1
    sta (Sprite),y
    iny
    lda.z bram_address+2
    sta (Sprite),y
    iny
    lda.z bram_address+3
    sta (Sprite),y
    // size = Sprite->TotalSize
    // [505] load_sprite::size#0 = ((word*)load_sprite::Sprite#10)[OFFSET_STRUCT_SPRITE_TOTALSIZE] -- vwuz1=pwuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_TOTALSIZE
    lda (size),y
    pha
    iny
    lda (size),y
    sta.z size+1
    pla
    sta.z size
    // bram_address + size
    // [506] load_sprite::return#0 = load_sprite::bram_address#10 + load_sprite::size#0 -- vduz1=vduz1_plus_vwuz2 
    lda.z return
    clc
    adc.z size
    sta.z return
    lda.z return+1
    adc.z size+1
    sta.z return+1
    lda.z return+2
    adc #0
    sta.z return+2
    lda.z return+3
    adc #0
    sta.z return+3
    // load_sprite::@return
    // }
    // [507] return 
    rts
}
  // load_tile
// load_tile(struct Tile* zp($7b) Tile, dword zp($c4) bram_address)
load_tile: {
    .label status = $6d
    .label size = $7b
    .label return = $c4
    .label Tile = $7b
    .label bram_address = $c4
    // cx16_load_ram_banked(1, 8, 0, Tile->File, bram_address)
    // [509] cx16_load_ram_banked::filename#1 = (byte*)load_tile::Tile#10 -- pbuz1=pbuz2 
    lda.z Tile
    sta.z cx16_load_ram_banked.filename
    lda.z Tile+1
    sta.z cx16_load_ram_banked.filename+1
    // [510] cx16_load_ram_banked::address#1 = load_tile::bram_address#10 -- vduz1=vduz2 
    lda.z bram_address
    sta.z cx16_load_ram_banked.address
    lda.z bram_address+1
    sta.z cx16_load_ram_banked.address+1
    lda.z bram_address+2
    sta.z cx16_load_ram_banked.address+2
    lda.z bram_address+3
    sta.z cx16_load_ram_banked.address+3
    // [511] call cx16_load_ram_banked 
    // [529] phi from load_tile to cx16_load_ram_banked [phi:load_tile->cx16_load_ram_banked]
    // [529] phi cx16_load_ram_banked::filename#3 = cx16_load_ram_banked::filename#1 [phi:load_tile->cx16_load_ram_banked#0] -- register_copy 
    // [529] phi cx16_load_ram_banked::address#3 = cx16_load_ram_banked::address#1 [phi:load_tile->cx16_load_ram_banked#1] -- register_copy 
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, Tile->File, bram_address)
    // [512] cx16_load_ram_banked::return#5 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // load_tile::@3
    // status = cx16_load_ram_banked(1, 8, 0, Tile->File, bram_address)
    // [513] load_tile::status#0 = cx16_load_ram_banked::return#5 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$ff)
    // [514] if(load_tile::status#0==$ff) goto load_tile::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [515] phi from load_tile::@3 to load_tile::@2 [phi:load_tile::@3->load_tile::@2]
    // load_tile::@2
    // printf("error file %s: %x\n", Tile->File, status)
    // [516] call cputs 
    // [343] phi from load_tile::@2 to cputs [phi:load_tile::@2->cputs]
    // [343] phi cputs::s#26 = s [phi:load_tile::@2->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // load_tile::@4
    // printf("error file %s: %x\n", Tile->File, status)
    // [517] printf_string::str#1 = (byte*)load_tile::Tile#10 -- pbuz1=pbuz2 
    lda.z Tile
    sta.z printf_string.str
    lda.z Tile+1
    sta.z printf_string.str+1
    // [518] call printf_string 
    // [1245] phi from load_tile::@4 to printf_string [phi:load_tile::@4->printf_string]
    // [1245] phi printf_string::str#2 = printf_string::str#1 [phi:load_tile::@4->printf_string#0] -- register_copy 
    jsr printf_string
    // [519] phi from load_tile::@4 to load_tile::@5 [phi:load_tile::@4->load_tile::@5]
    // load_tile::@5
    // printf("error file %s: %x\n", Tile->File, status)
    // [520] call cputs 
    // [343] phi from load_tile::@5 to cputs [phi:load_tile::@5->cputs]
    // [343] phi cputs::s#26 = s1 [phi:load_tile::@5->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // load_tile::@6
    // printf("error file %s: %x\n", Tile->File, status)
    // [521] printf_uchar::uvalue#3 = load_tile::status#0 -- vbuxx=vbuz1 
    ldx.z status
    // [522] call printf_uchar 
    // [596] phi from load_tile::@6 to printf_uchar [phi:load_tile::@6->printf_uchar]
    // [596] phi printf_uchar::format_radix#5 = HEXADECIMAL [phi:load_tile::@6->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [596] phi printf_uchar::uvalue#5 = printf_uchar::uvalue#3 [phi:load_tile::@6->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [523] phi from load_tile::@6 to load_tile::@7 [phi:load_tile::@6->load_tile::@7]
    // load_tile::@7
    // printf("error file %s: %x\n", Tile->File, status)
    // [524] call cputs 
    // [343] phi from load_tile::@7 to cputs [phi:load_tile::@7->cputs]
    // [343] phi cputs::s#26 = s2 [phi:load_tile::@7->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // load_tile::@1
  __b1:
    // Tile->BRAM_Address = bram_address
    // [525] ((dword*)load_tile::Tile#10)[OFFSET_STRUCT_TILE_BRAM_ADDRESS] = load_tile::bram_address#10 -- pduz1_derefidx_vbuc1=vduz2 
    ldy #OFFSET_STRUCT_TILE_BRAM_ADDRESS
    lda.z bram_address
    sta (Tile),y
    iny
    lda.z bram_address+1
    sta (Tile),y
    iny
    lda.z bram_address+2
    sta (Tile),y
    iny
    lda.z bram_address+3
    sta (Tile),y
    // size = Tile->TotalSize
    // [526] load_tile::size#0 = ((word*)load_tile::Tile#10)[OFFSET_STRUCT_TILE_TOTALSIZE] -- vwuz1=pwuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_TOTALSIZE
    lda (size),y
    pha
    iny
    lda (size),y
    sta.z size+1
    pla
    sta.z size
    // bram_address + size
    // [527] load_tile::return#0 = load_tile::bram_address#10 + load_tile::size#0 -- vduz1=vduz1_plus_vwuz2 
    lda.z return
    clc
    adc.z size
    sta.z return
    lda.z return+1
    adc.z size+1
    sta.z return+1
    lda.z return+2
    adc #0
    sta.z return+2
    lda.z return+3
    adc #0
    sta.z return+3
    // load_tile::@return
    // }
    // [528] return 
    rts
}
  // cx16_load_ram_banked
// Load a file to cx16 banked RAM at address A000-BFFF.
// Returns a status:
// - 0xff: Success
// - other: Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
// cx16_load_ram_banked(byte* zp($c2) filename, dword zp($e) address)
cx16_load_ram_banked: {
    .label __0 = $65
    .label __1 = $65
    .label __3 = $cc
    .label __5 = $74
    .label __6 = $74
    .label __7 = $72
    .label __8 = $72
    .label __10 = $74
    .label __11 = $65
    .label __33 = $74
    .label __34 = $72
    .label bank = $7a
    // select the bank
    .label addr = $65
    .label status = $3c
    .label return = $3c
    .label ch = $53
    .label filename = $c2
    .label address = $e
    // >address
    // [530] cx16_load_ram_banked::$0 = > cx16_load_ram_banked::address#3 -- vwuz1=_hi_vduz2 
    lda.z address+2
    sta.z __0
    lda.z address+3
    sta.z __0+1
    // (>address)<<8
    // [531] cx16_load_ram_banked::$1 = cx16_load_ram_banked::$0 << 8 -- vwuz1=vwuz1_rol_8 
    lda.z __1
    sta.z __1+1
    lda #0
    sta.z __1
    // <(>address)<<8
    // [532] cx16_load_ram_banked::$2 = < cx16_load_ram_banked::$1 -- vbuxx=_lo_vwuz1 
    tax
    // <address
    // [533] cx16_load_ram_banked::$3 = < cx16_load_ram_banked::address#3 -- vwuz1=_lo_vduz2 
    lda.z address
    sta.z __3
    lda.z address+1
    sta.z __3+1
    // >(<address)
    // [534] cx16_load_ram_banked::$4 = > cx16_load_ram_banked::$3 -- vbuyy=_hi_vwuz1 
    tay
    // ((word)<(>address)<<8)|>(<address)
    // [535] cx16_load_ram_banked::$33 = (word)cx16_load_ram_banked::$2 -- vwuz1=_word_vbuxx 
    txa
    sta.z __33
    sta.z __33+1
    // [536] cx16_load_ram_banked::$5 = cx16_load_ram_banked::$33 | cx16_load_ram_banked::$4 -- vwuz1=vwuz1_bor_vbuyy 
    tya
    ora.z __5
    sta.z __5
    // (((word)<(>address)<<8)|>(<address))>>5
    // [537] cx16_load_ram_banked::$6 = cx16_load_ram_banked::$5 >> 5 -- vwuz1=vwuz1_ror_5 
    lsr.z __6+1
    ror.z __6
    lsr.z __6+1
    ror.z __6
    lsr.z __6+1
    ror.z __6
    lsr.z __6+1
    ror.z __6
    lsr.z __6+1
    ror.z __6
    // >address
    // [538] cx16_load_ram_banked::$7 = > cx16_load_ram_banked::address#3 -- vwuz1=_hi_vduz2 
    lda.z address+2
    sta.z __7
    lda.z address+3
    sta.z __7+1
    // (>address)<<3
    // [539] cx16_load_ram_banked::$8 = cx16_load_ram_banked::$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    // <(>address)<<3
    // [540] cx16_load_ram_banked::$9 = < cx16_load_ram_banked::$8 -- vbuaa=_lo_vwuz1 
    lda.z __8
    // ((((word)<(>address)<<8)|>(<address))>>5)+((word)<(>address)<<3)
    // [541] cx16_load_ram_banked::$34 = (word)cx16_load_ram_banked::$9 -- vwuz1=_word_vbuaa 
    sta.z __34
    txa
    sta.z __34+1
    // [542] cx16_load_ram_banked::$10 = cx16_load_ram_banked::$6 + cx16_load_ram_banked::$34 -- vwuz1=vwuz1_plus_vwuz2 
    lda.z __10
    clc
    adc.z __34
    sta.z __10
    lda.z __10+1
    adc.z __34+1
    sta.z __10+1
    // bank = (byte)(((((word)<(>address)<<8)|>(<address))>>5)+((word)<(>address)<<3))
    // [543] cx16_load_ram_banked::bank#0 = (byte)cx16_load_ram_banked::$10 -- vbuz1=_byte_vwuz2 
    lda.z __10
    sta.z bank
    // <address
    // [544] cx16_load_ram_banked::$11 = < cx16_load_ram_banked::address#3 -- vwuz1=_lo_vduz2 
    lda.z address
    sta.z __11
    lda.z address+1
    sta.z __11+1
    // (<address)&0x1FFF
    // [545] cx16_load_ram_banked::addr#0 = cx16_load_ram_banked::$11 & $1fff -- vwuz1=vwuz1_band_vwuc1 
    lda.z addr
    and #<$1fff
    sta.z addr
    lda.z addr+1
    and #>$1fff
    sta.z addr+1
    // addr += 0xA000
    // [546] cx16_load_ram_banked::addr#1 = (byte*)cx16_load_ram_banked::addr#0 + $a000 -- pbuz1=pbuz1_plus_vwuc1 
    // stip off the top 3 bits, which are representing the bank of the word!
    clc
    lda.z addr
    adc #<$a000
    sta.z addr
    lda.z addr+1
    adc #>$a000
    sta.z addr+1
    // cx16_ram_bank(bank)
    // [547] cx16_ram_bank::bank#0 = cx16_load_ram_banked::bank#0 -- vbuxx=vbuz1 
    ldx.z bank
    // [548] call cx16_ram_bank 
    // [1249] phi from cx16_load_ram_banked to cx16_ram_bank [phi:cx16_load_ram_banked->cx16_ram_bank]
    // [1249] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#0 [phi:cx16_load_ram_banked->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // cx16_load_ram_banked::@8
    // cbm_k_setnam(filename)
    // [549] cbm_k_setnam::filename = cx16_load_ram_banked::filename#3 -- pbuz1=pbuz2 
    lda.z filename
    sta.z cbm_k_setnam.filename
    lda.z filename+1
    sta.z cbm_k_setnam.filename+1
    // [550] call cbm_k_setnam 
    jsr cbm_k_setnam
    // cx16_load_ram_banked::@9
    // cbm_k_setlfs(channel, device, secondary)
    // [551] cbm_k_setlfs::channel = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cbm_k_setlfs.channel
    // [552] cbm_k_setlfs::device = 8 -- vbuz1=vbuc1 
    lda #8
    sta.z cbm_k_setlfs.device
    // [553] cbm_k_setlfs::secondary = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_setlfs.secondary
    // [554] call cbm_k_setlfs 
    jsr cbm_k_setlfs
    // [555] phi from cx16_load_ram_banked::@9 to cx16_load_ram_banked::@10 [phi:cx16_load_ram_banked::@9->cx16_load_ram_banked::@10]
    // cx16_load_ram_banked::@10
    // cbm_k_open()
    // [556] call cbm_k_open 
    jsr cbm_k_open
    // [557] cbm_k_open::return#2 = cbm_k_open::return#1
    // cx16_load_ram_banked::@11
    // [558] cx16_load_ram_banked::status#1 = cbm_k_open::return#2 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$FF)
    // [559] if(cx16_load_ram_banked::status#1==$ff) goto cx16_load_ram_banked::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [560] phi from cx16_load_ram_banked::@11 cx16_load_ram_banked::@12 cx16_load_ram_banked::@16 to cx16_load_ram_banked::@return [phi:cx16_load_ram_banked::@11/cx16_load_ram_banked::@12/cx16_load_ram_banked::@16->cx16_load_ram_banked::@return]
    // [560] phi cx16_load_ram_banked::return#1 = cx16_load_ram_banked::status#1 [phi:cx16_load_ram_banked::@11/cx16_load_ram_banked::@12/cx16_load_ram_banked::@16->cx16_load_ram_banked::@return#0] -- register_copy 
    // cx16_load_ram_banked::@return
    // }
    // [561] return 
    rts
    // cx16_load_ram_banked::@1
  __b1:
    // cbm_k_chkin(channel)
    // [562] cbm_k_chkin::channel = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cbm_k_chkin.channel
    // [563] call cbm_k_chkin 
    jsr cbm_k_chkin
    // [564] cbm_k_chkin::return#2 = cbm_k_chkin::return#1
    // cx16_load_ram_banked::@12
    // [565] cx16_load_ram_banked::status#2 = cbm_k_chkin::return#2 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$FF)
    // [566] if(cx16_load_ram_banked::status#2==$ff) goto cx16_load_ram_banked::@2 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b2
    rts
    // [567] phi from cx16_load_ram_banked::@12 to cx16_load_ram_banked::@2 [phi:cx16_load_ram_banked::@12->cx16_load_ram_banked::@2]
    // cx16_load_ram_banked::@2
  __b2:
    // cbm_k_chrin()
    // [568] call cbm_k_chrin 
    jsr cbm_k_chrin
    // [569] cbm_k_chrin::return#2 = cbm_k_chrin::return#1
    // cx16_load_ram_banked::@13
    // ch = cbm_k_chrin()
    // [570] cx16_load_ram_banked::ch#1 = cbm_k_chrin::return#2 -- vbuz1=vbuaa 
    sta.z ch
    // cbm_k_readst()
    // [571] call cbm_k_readst 
    jsr cbm_k_readst
    // [572] cbm_k_readst::return#2 = cbm_k_readst::return#1
    // cx16_load_ram_banked::@14
    // status = cbm_k_readst()
    // [573] cx16_load_ram_banked::status#3 = cbm_k_readst::return#2
    // [574] phi from cx16_load_ram_banked::@14 cx16_load_ram_banked::@18 to cx16_load_ram_banked::@3 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3]
    // [574] phi cx16_load_ram_banked::bank#2 = cx16_load_ram_banked::bank#0 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#0] -- register_copy 
    // [574] phi cx16_load_ram_banked::ch#3 = cx16_load_ram_banked::ch#1 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#1] -- register_copy 
    // [574] phi cx16_load_ram_banked::addr#4 = cx16_load_ram_banked::addr#1 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#2] -- register_copy 
    // [574] phi cx16_load_ram_banked::status#8 = cx16_load_ram_banked::status#3 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#3] -- register_copy 
    // cx16_load_ram_banked::@3
  __b3:
    // while (!status)
    // [575] if(0==cx16_load_ram_banked::status#8) goto cx16_load_ram_banked::@4 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b4
    // cx16_load_ram_banked::@5
    // cbm_k_close(channel)
    // [576] cbm_k_close::channel = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cbm_k_close.channel
    // [577] call cbm_k_close 
    jsr cbm_k_close
    // [578] cbm_k_close::return#2 = cbm_k_close::return#1
    // cx16_load_ram_banked::@15
    // [579] cx16_load_ram_banked::status#10 = cbm_k_close::return#2 -- vbuz1=vbuaa 
    sta.z status
    // cbm_k_clrchn()
    // [580] call cbm_k_clrchn 
    jsr cbm_k_clrchn
    // [581] phi from cx16_load_ram_banked::@15 to cx16_load_ram_banked::@16 [phi:cx16_load_ram_banked::@15->cx16_load_ram_banked::@16]
    // cx16_load_ram_banked::@16
    // cx16_ram_bank(1)
    // [582] call cx16_ram_bank 
    // [1249] phi from cx16_load_ram_banked::@16 to cx16_ram_bank [phi:cx16_load_ram_banked::@16->cx16_ram_bank]
    // [1249] phi cx16_ram_bank::bank#11 = 1 [phi:cx16_load_ram_banked::@16->cx16_ram_bank#0] -- vbuxx=vbuc1 
    ldx #1
    jsr cx16_ram_bank
    rts
    // cx16_load_ram_banked::@4
  __b4:
    // if(addr == 0xC000)
    // [583] if(cx16_load_ram_banked::addr#4!=$c000) goto cx16_load_ram_banked::@6 -- pbuz1_neq_vwuc1_then_la1 
    lda.z addr+1
    cmp #>$c000
    bne __b6
    lda.z addr
    cmp #<$c000
    bne __b6
    // cx16_load_ram_banked::@7
    // bank++;
    // [584] cx16_load_ram_banked::bank#1 = ++ cx16_load_ram_banked::bank#2 -- vbuz1=_inc_vbuz1 
    inc.z bank
    // cx16_ram_bank(bank)
    // [585] cx16_ram_bank::bank#2 = cx16_load_ram_banked::bank#1 -- vbuxx=vbuz1 
    ldx.z bank
    // [586] call cx16_ram_bank 
  //printf(", %u", (word)bank);
    // [1249] phi from cx16_load_ram_banked::@7 to cx16_ram_bank [phi:cx16_load_ram_banked::@7->cx16_ram_bank]
    // [1249] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#2 [phi:cx16_load_ram_banked::@7->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [587] phi from cx16_load_ram_banked::@7 to cx16_load_ram_banked::@6 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@6]
    // [587] phi cx16_load_ram_banked::bank#10 = cx16_load_ram_banked::bank#1 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@6#0] -- register_copy 
    // [587] phi cx16_load_ram_banked::addr#5 = (byte*) 40960 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@6#1] -- pbuz1=pbuc1 
    lda #<$a000
    sta.z addr
    lda #>$a000
    sta.z addr+1
    // [587] phi from cx16_load_ram_banked::@4 to cx16_load_ram_banked::@6 [phi:cx16_load_ram_banked::@4->cx16_load_ram_banked::@6]
    // [587] phi cx16_load_ram_banked::bank#10 = cx16_load_ram_banked::bank#2 [phi:cx16_load_ram_banked::@4->cx16_load_ram_banked::@6#0] -- register_copy 
    // [587] phi cx16_load_ram_banked::addr#5 = cx16_load_ram_banked::addr#4 [phi:cx16_load_ram_banked::@4->cx16_load_ram_banked::@6#1] -- register_copy 
    // cx16_load_ram_banked::@6
  __b6:
    // *addr = ch
    // [588] *cx16_load_ram_banked::addr#5 = cx16_load_ram_banked::ch#3 -- _deref_pbuz1=vbuz2 
    lda.z ch
    ldy #0
    sta (addr),y
    // addr++;
    // [589] cx16_load_ram_banked::addr#10 = ++ cx16_load_ram_banked::addr#5 -- pbuz1=_inc_pbuz1 
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    // cbm_k_chrin()
    // [590] call cbm_k_chrin 
    jsr cbm_k_chrin
    // [591] cbm_k_chrin::return#3 = cbm_k_chrin::return#1
    // cx16_load_ram_banked::@17
    // ch = cbm_k_chrin()
    // [592] cx16_load_ram_banked::ch#2 = cbm_k_chrin::return#3 -- vbuz1=vbuaa 
    sta.z ch
    // cbm_k_readst()
    // [593] call cbm_k_readst 
    jsr cbm_k_readst
    // [594] cbm_k_readst::return#3 = cbm_k_readst::return#1
    // cx16_load_ram_banked::@18
    // status = cbm_k_readst()
    // [595] cx16_load_ram_banked::status#5 = cbm_k_readst::return#3
    jmp __b3
}
  // printf_uchar
// Print an unsigned char using a specific format
// printf_uchar(byte register(X) uvalue, byte register(Y) format_radix)
printf_uchar: {
    // printf_uchar::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [597] *((byte*)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    // [598] uctoa::value#1 = printf_uchar::uvalue#5
    // [599] uctoa::radix#0 = printf_uchar::format_radix#5
    // [600] call uctoa 
    // Format number into buffer
    jsr uctoa
    // printf_uchar::@2
    // printf_number_buffer(printf_buffer, format)
    // [601] printf_number_buffer::buffer_sign#2 = *((byte*)&printf_buffer) -- vbuaa=_deref_pbuc1 
    lda printf_buffer
    // [602] call printf_number_buffer 
  // Print using format
    // [1188] phi from printf_uchar::@2 to printf_number_buffer [phi:printf_uchar::@2->printf_number_buffer]
    // [1188] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#2 [phi:printf_uchar::@2->printf_number_buffer#0] -- register_copy 
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [603] return 
    rts
}
  // cx16_rom_bank
// Configure the bank of a banked rom on the X16.
// cx16_rom_bank(byte register(A) bank)
cx16_rom_bank: {
    // VIA1->PORT_B = bank
    // [605] *((byte*)VIA1) = cx16_rom_bank::bank#2 -- _deref_pbuc1=vbuaa 
    sta VIA1
    // cx16_rom_bank::@return
    // }
    // [606] return 
    rts
}
  // vera_heap_segment_init
// vera heap
// vera_heap_segment_init(byte register(X) segmentid, dword zp($c4) base, dword zp($24) size)
vera_heap_segment_init: {
    .label __1 = $24
    .label segment = $cc
    .label return = $5f
    .label base = $c4
    .label size = $24
    // &vera_heap_segments[segmentid]
    // [608] vera_heap_segment_init::$17 = vera_heap_segment_init::segmentid#4 << 2 -- vbuaa=vbuxx_rol_2 
    txa
    asl
    asl
    // [609] vera_heap_segment_init::$18 = vera_heap_segment_init::$17 + vera_heap_segment_init::segmentid#4 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [610] vera_heap_segment_init::$19 = vera_heap_segment_init::$18 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [611] vera_heap_segment_init::$20 = vera_heap_segment_init::$19 + vera_heap_segment_init::segmentid#4 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [612] vera_heap_segment_init::$2 = vera_heap_segment_init::$20 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // segment = &vera_heap_segments[segmentid]
    // [613] vera_heap_segment_init::segment#0 = vera_heap_segments + vera_heap_segment_init::$2 -- pssz1=pssc1_plus_vbuaa 
    clc
    adc #<vera_heap_segments
    sta.z segment
    lda #>vera_heap_segments
    adc #0
    sta.z segment+1
    // segment->size = size
    // [614] *((dword*)vera_heap_segment_init::segment#0) = vera_heap_segment_init::size#4 -- _deref_pduz1=vduz2 
    ldy #0
    lda.z size
    sta (segment),y
    iny
    lda.z size+1
    sta (segment),y
    iny
    lda.z size+2
    sta (segment),y
    iny
    lda.z size+3
    sta (segment),y
    // segment->base_address = base
    // [615] ((dword*)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_BASE_ADDRESS] = vera_heap_segment_init::base#4 -- pduz1_derefidx_vbuc1=vduz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_BASE_ADDRESS
    lda.z base
    sta (segment),y
    iny
    lda.z base+1
    sta (segment),y
    iny
    lda.z base+2
    sta (segment),y
    iny
    lda.z base+3
    sta (segment),y
    // base+size
    // [616] vera_heap_segment_init::$1 = vera_heap_segment_init::base#4 + vera_heap_segment_init::size#4 -- vduz1=vduz2_plus_vduz1 
    lda.z __1
    clc
    adc.z base
    sta.z __1
    lda.z __1+1
    adc.z base+1
    sta.z __1+1
    lda.z __1+2
    adc.z base+2
    sta.z __1+2
    lda.z __1+3
    adc.z base+3
    sta.z __1+3
    // segment->ceil_address = base+size
    // [617] ((dword*)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS] = vera_heap_segment_init::$1 -- pduz1_derefidx_vbuc1=vduz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS
    lda.z __1
    sta (segment),y
    iny
    lda.z __1+1
    sta (segment),y
    iny
    lda.z __1+2
    sta (segment),y
    iny
    lda.z __1+3
    sta (segment),y
    // segment->next_address = base
    // [618] ((dword*)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS] = vera_heap_segment_init::base#4 -- pduz1_derefidx_vbuc1=vduz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS
    lda.z base
    sta (segment),y
    iny
    lda.z base+1
    sta (segment),y
    iny
    lda.z base+2
    sta (segment),y
    iny
    lda.z base+3
    sta (segment),y
    // segment->head_block = 0x0000
    // [619] ((struct vera_heap**)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK] = (struct vera_heap*) 0 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK
    lda #<0
    sta (segment),y
    iny
    sta (segment),y
    // segment->tail_block = 0x0000
    // [620] ((struct vera_heap**)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] = (struct vera_heap*) 0 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    sta (segment),y
    iny
    sta (segment),y
    // return segment->base_address;
    // [621] vera_heap_segment_init::return#0 = ((dword*)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_BASE_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_BASE_ADDRESS
    lda (segment),y
    sta.z return
    iny
    lda (segment),y
    sta.z return+1
    iny
    lda (segment),y
    sta.z return+2
    iny
    lda (segment),y
    sta.z return+3
    // vera_heap_segment_init::@return
    // }
    // [622] return 
    rts
}
  // vera_heap_malloc
// vera_heap_malloc(byte register(X) segmentid, word zp($3d) size)
vera_heap_malloc: {
    .label size = $3d
    .label address = $5b
    .label __8 = $24
    .label segment = $74
    .label size_test = $72
    .label return = $e
    .label block = $72
    .label block_1 = $67
    .label tail_block = $65
    // address
    // [624] vera_heap_malloc::address = 0 -- vduz1=vduc1 
    lda #<0
    sta.z address
    sta.z address+1
    lda #<0>>$10
    sta.z address+2
    lda #>0>>$10
    sta.z address+3
    // &(vera_heap_segments[segmentid])
    // [625] vera_heap_malloc::$49 = vera_heap_malloc::segmentid#4 << 2 -- vbuaa=vbuxx_rol_2 
    txa
    asl
    asl
    // [626] vera_heap_malloc::$50 = vera_heap_malloc::$49 + vera_heap_malloc::segmentid#4 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [627] vera_heap_malloc::$51 = vera_heap_malloc::$50 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [628] vera_heap_malloc::$52 = vera_heap_malloc::$51 + vera_heap_malloc::segmentid#4 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [629] vera_heap_malloc::$24 = vera_heap_malloc::$52 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // segment = &(vera_heap_segments[segmentid])
    // [630] vera_heap_malloc::segment#0 = vera_heap_segments + vera_heap_malloc::$24 -- pssz1=pssc1_plus_vbuaa 
    clc
    adc #<vera_heap_segments
    sta.z segment
    lda #>vera_heap_segments
    adc #0
    sta.z segment+1
    // cx16_ram_bank(vera_heap_ram_bank)
    // [631] call cx16_ram_bank 
    // [1249] phi from vera_heap_malloc to cx16_ram_bank [phi:vera_heap_malloc->cx16_ram_bank]
    // [1249] phi cx16_ram_bank::bank#11 = vera_heap_ram_bank#0 [phi:vera_heap_malloc->cx16_ram_bank#0] -- vbuxx=vbuc1 
    ldx #vera_heap_ram_bank
    jsr cx16_ram_bank
    // cx16_ram_bank(vera_heap_ram_bank)
    // [632] cx16_ram_bank::return#14 = cx16_ram_bank::return#0
    // vera_heap_malloc::@12
    // cx16_ram_bank_current = cx16_ram_bank(vera_heap_ram_bank)
    // [633] vera_heap_malloc::cx16_ram_bank_current#0 = cx16_ram_bank::return#14 -- vbuxx=vbuaa 
    tax
    // if (!size)
    // [634] if(0!=vera_heap_malloc::size) goto vera_heap_malloc::@1 -- 0_neq_vwuz1_then_la1 
    lda.z size
    ora.z size+1
    bne __b1
    // vera_heap_malloc::@7
    // cx16_ram_bank(cx16_ram_bank_current)
    // [635] cx16_ram_bank::bank#6 = vera_heap_malloc::cx16_ram_bank_current#0
    // [636] call cx16_ram_bank 
    // [1249] phi from vera_heap_malloc::@7 to cx16_ram_bank [phi:vera_heap_malloc::@7->cx16_ram_bank]
    // [1249] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#6 [phi:vera_heap_malloc::@7->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [637] phi from vera_heap_malloc::@10 vera_heap_malloc::@7 vera_heap_malloc::@8 to vera_heap_malloc::@return [phi:vera_heap_malloc::@10/vera_heap_malloc::@7/vera_heap_malloc::@8->vera_heap_malloc::@return]
  __b7:
    // [637] phi vera_heap_malloc::return#1 = 0 [phi:vera_heap_malloc::@10/vera_heap_malloc::@7/vera_heap_malloc::@8->vera_heap_malloc::@return#0] -- vduz1=vbuc1 
    lda #0
    sta.z return
    sta.z return+1
    sta.z return+2
    sta.z return+3
    // vera_heap_malloc::@return
    // }
    // [638] return 
    rts
    // vera_heap_malloc::@1
  __b1:
    // size_test = size
    // [639] vera_heap_malloc::size_test#0 = vera_heap_malloc::size -- vwuz1=vwuz2 
    // Validate if size is a multiple of 32!
    lda.z size
    sta.z size_test
    lda.z size+1
    sta.z size_test+1
    // size_test >>=5
    // [640] vera_heap_malloc::size_test#1 = vera_heap_malloc::size_test#0 >> 5 -- vwuz1=vwuz1_ror_5 
    lsr.z size_test+1
    ror.z size_test
    lsr.z size_test+1
    ror.z size_test
    lsr.z size_test+1
    ror.z size_test
    lsr.z size_test+1
    ror.z size_test
    lsr.z size_test+1
    ror.z size_test
    // size_test <<=5
    // [641] vera_heap_malloc::size_test#2 = vera_heap_malloc::size_test#1 << 5 -- vwuz1=vwuz1_rol_5 
    asl.z size_test
    rol.z size_test+1
    asl.z size_test
    rol.z size_test+1
    asl.z size_test
    rol.z size_test+1
    asl.z size_test
    rol.z size_test+1
    asl.z size_test
    rol.z size_test+1
    // if (size!=size_test)
    // [642] if(vera_heap_malloc::size==vera_heap_malloc::size_test#2) goto vera_heap_malloc::@2 -- vwuz1_eq_vwuz2_then_la1 
    lda.z size
    cmp.z size_test
    bne !+
    lda.z size+1
    cmp.z size_test+1
    beq __b2
  !:
    // vera_heap_malloc::@8
    // cx16_ram_bank(cx16_ram_bank_current)
    // [643] cx16_ram_bank::bank#7 = vera_heap_malloc::cx16_ram_bank_current#0
    // [644] call cx16_ram_bank 
    // [1249] phi from vera_heap_malloc::@8 to cx16_ram_bank [phi:vera_heap_malloc::@8->cx16_ram_bank]
    // [1249] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#7 [phi:vera_heap_malloc::@8->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    jmp __b7
    // vera_heap_malloc::@2
  __b2:
    // vera_heap_block_free_find(segment, size)
    // [645] vera_heap_block_free_find::segment#0 = vera_heap_malloc::segment#0 -- pssz1=pssz2 
    lda.z segment
    sta.z vera_heap_block_free_find.segment
    lda.z segment+1
    sta.z vera_heap_block_free_find.segment+1
    // [646] vera_heap_block_free_find::size#0 = vera_heap_malloc::size -- vduz1=vwuz2 
    lda.z size
    sta.z vera_heap_block_free_find.size
    lda.z size+1
    sta.z vera_heap_block_free_find.size+1
    lda #0
    sta.z vera_heap_block_free_find.size+2
    sta.z vera_heap_block_free_find.size+3
    // [647] call vera_heap_block_free_find 
    jsr vera_heap_block_free_find
    // [648] vera_heap_block_free_find::return#3 = vera_heap_block_free_find::return#2
    // vera_heap_malloc::@13
    // block = vera_heap_block_free_find(segment, size)
    // [649] vera_heap_malloc::block#1 = vera_heap_block_free_find::return#3
    // if (block)
    // [650] if((struct vera_heap*)0==vera_heap_malloc::block#1) goto vera_heap_malloc::@3 -- pssc1_eq_pssz1_then_la1 
    lda.z block
    cmp #<0
    bne !+
    lda.z block+1
    cmp #>0
    beq __b3
  !:
    // vera_heap_malloc::@9
    // vera_heap_block_empty_set(block, 0)
    // [651] vera_heap_block_empty_set::block#0 = vera_heap_malloc::block#1 -- pssz1=pssz2 
    lda.z block
    sta.z vera_heap_block_empty_set.block
    lda.z block+1
    sta.z vera_heap_block_empty_set.block+1
    // [652] call vera_heap_block_empty_set 
    // [1333] phi from vera_heap_malloc::@9 to vera_heap_block_empty_set [phi:vera_heap_malloc::@9->vera_heap_block_empty_set]
    // [1333] phi vera_heap_block_empty_set::block#2 = vera_heap_block_empty_set::block#0 [phi:vera_heap_malloc::@9->vera_heap_block_empty_set#0] -- register_copy 
    jsr vera_heap_block_empty_set
    // vera_heap_malloc::@15
    // cx16_ram_bank(cx16_ram_bank_current)
    // [653] cx16_ram_bank::bank#8 = vera_heap_malloc::cx16_ram_bank_current#0
    // [654] call cx16_ram_bank 
    // [1249] phi from vera_heap_malloc::@15 to cx16_ram_bank [phi:vera_heap_malloc::@15->cx16_ram_bank]
    // [1249] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#8 [phi:vera_heap_malloc::@15->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // vera_heap_malloc::@16
    // vera_heap_block_address_get(block)
    // [655] vera_heap_block_address_get::block#0 = vera_heap_malloc::block#1
    // [656] call vera_heap_block_address_get 
    jsr vera_heap_block_address_get
    // [657] vera_heap_block_address_get::return#2 = vera_heap_block_address_get::return#0
    // vera_heap_malloc::@17
    // return (vera_heap_block_address_get(block));
    // [658] vera_heap_malloc::return#3 = vera_heap_block_address_get::return#2
    // [637] phi from vera_heap_malloc::@17 vera_heap_malloc::@21 to vera_heap_malloc::@return [phi:vera_heap_malloc::@17/vera_heap_malloc::@21->vera_heap_malloc::@return]
    // [637] phi vera_heap_malloc::return#1 = vera_heap_malloc::return#3 [phi:vera_heap_malloc::@17/vera_heap_malloc::@21->vera_heap_malloc::@return#0] -- register_copy 
    rts
    // vera_heap_malloc::@3
  __b3:
    // vera_heap_address(segment, size)
    // [659] vera_heap_address::segment#0 = vera_heap_malloc::segment#0 -- pssz1=pssz2 
    lda.z segment
    sta.z vera_heap_address.segment
    lda.z segment+1
    sta.z vera_heap_address.segment+1
    // [660] vera_heap_address::size#0 = vera_heap_malloc::size -- vduz1=vwuz2 
    lda.z size
    sta.z vera_heap_address.size
    lda.z size+1
    sta.z vera_heap_address.size+1
    lda #0
    sta.z vera_heap_address.size+2
    sta.z vera_heap_address.size+3
    // [661] call vera_heap_address 
    jsr vera_heap_address
    // [662] vera_heap_address::return#3 = vera_heap_address::return#2
    // vera_heap_malloc::@14
    // [663] vera_heap_malloc::$8 = vera_heap_address::return#3
    // address = vera_heap_address(segment, size)
    // [664] vera_heap_malloc::address = vera_heap_malloc::$8 -- vduz1=vduz2 
    // There is no free block, so we need to allocate a new memory block in vera.
    lda.z __8
    sta.z address
    lda.z __8+1
    sta.z address+1
    lda.z __8+2
    sta.z address+2
    lda.z __8+3
    sta.z address+3
    // if (address == 0)
    // [665] if(vera_heap_malloc::address!=0) goto vera_heap_malloc::@4 -- vduz1_neq_0_then_la1 
    lda.z address
    ora.z address+1
    bne __b4
    ora.z address+2
    bne __b4
    ora.z address+3
    bne __b4
    // vera_heap_malloc::@10
    // cx16_ram_bank(cx16_ram_bank_current)
    // [666] cx16_ram_bank::bank#9 = vera_heap_malloc::cx16_ram_bank_current#0
    // [667] call cx16_ram_bank 
    // [1249] phi from vera_heap_malloc::@10 to cx16_ram_bank [phi:vera_heap_malloc::@10->cx16_ram_bank]
    // [1249] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#9 [phi:vera_heap_malloc::@10->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    jmp __b7
    // vera_heap_malloc::@4
  __b4:
    // if (segment->head_block==0x0000)
    // [668] if(((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK]==0) goto vera_heap_malloc::@5 -- qssz1_derefidx_vbuc1_eq_0_then_la1 
    //struct vera_heap *head_block = segment->head_block;
    // If the first block ever, en setup the head and start from A000.
    ldy #<OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK
    lda (segment),y
    bne !+
    iny
    lda (segment),y
    beq __b5
  !:
    // vera_heap_malloc::@11
    // block = segment->tail_block + sizeof(struct vera_heap)
    // [669] vera_heap_malloc::block#3 = ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] + SIZEOF_STRUCT_VERA_HEAP*SIZEOF_STRUCT_VERA_HEAP -- pssz1=qssz2_derefidx_vbuc1_plus_vbuc2 
    lda #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    tay
    clc
    lda (segment),y
    adc #<SIZEOF_STRUCT_VERA_HEAP*SIZEOF_STRUCT_VERA_HEAP
    sta.z block_1
    iny
    lda (segment),y
    adc #>SIZEOF_STRUCT_VERA_HEAP*SIZEOF_STRUCT_VERA_HEAP
    sta.z block_1+1
    // tail_block = segment->tail_block
    // [670] vera_heap_malloc::tail_block#0 = ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    lda (segment),y
    sta.z tail_block
    iny
    lda (segment),y
    sta.z tail_block+1
    // block->prev = tail_block
    // [671] ((struct vera_heap**)vera_heap_malloc::block#3)[OFFSET_STRUCT_VERA_HEAP_PREV] = vera_heap_malloc::tail_block#0 -- qssz1_derefidx_vbuc1=pssz2 
    //TODO: error or fragment
    ldy #OFFSET_STRUCT_VERA_HEAP_PREV
    lda.z tail_block
    sta (block_1),y
    iny
    lda.z tail_block+1
    sta (block_1),y
    // tail_block->next = block
    // [672] ((struct vera_heap**)vera_heap_malloc::tail_block#0)[OFFSET_STRUCT_VERA_HEAP_NEXT] = vera_heap_malloc::block#3 -- qssz1_derefidx_vbuc1=pssz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_NEXT
    lda.z block_1
    sta (tail_block),y
    iny
    lda.z block_1+1
    sta (tail_block),y
    // segment->tail_block = block
    // [673] ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] = vera_heap_malloc::block#3 -- qssz1_derefidx_vbuc1=pssz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    lda.z block_1
    sta (segment),y
    iny
    lda.z block_1+1
    sta (segment),y
    // block->next = 0x0000
    // [674] ((struct vera_heap**)vera_heap_malloc::block#3)[OFFSET_STRUCT_VERA_HEAP_NEXT] = (struct vera_heap*) 0 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_NEXT
    lda #<0
    sta (block_1),y
    iny
    sta (block_1),y
    // [675] phi from vera_heap_malloc::@11 to vera_heap_malloc::@6 [phi:vera_heap_malloc::@11->vera_heap_malloc::@6]
    // [675] phi vera_heap_malloc::block#6 = vera_heap_malloc::block#3 [phi:vera_heap_malloc::@11->vera_heap_malloc::@6#0] -- register_copy 
    // vera_heap_malloc::@6
  __b6:
    // vera_heap_block_address_set(block, &address)
    // [676] vera_heap_block_address_set::block#0 = vera_heap_malloc::block#6 -- pssz1=pssz2 
    lda.z block_1
    sta.z vera_heap_block_address_set.block
    lda.z block_1+1
    sta.z vera_heap_block_address_set.block+1
    // [677] call vera_heap_block_address_set 
    jsr vera_heap_block_address_set
    // vera_heap_malloc::@18
    // vera_heap_block_size_set(block, &size)
    // [678] vera_heap_block_size_set::block#0 = vera_heap_malloc::block#6 -- pssz1=pssz2 
    lda.z block_1
    sta.z vera_heap_block_size_set.block
    lda.z block_1+1
    sta.z vera_heap_block_size_set.block+1
    // [679] call vera_heap_block_size_set 
    jsr vera_heap_block_size_set
    // vera_heap_malloc::@19
    // vera_heap_block_empty_set(block, 0)
    // [680] vera_heap_block_empty_set::block#1 = vera_heap_malloc::block#6
    // [681] call vera_heap_block_empty_set 
    // [1333] phi from vera_heap_malloc::@19 to vera_heap_block_empty_set [phi:vera_heap_malloc::@19->vera_heap_block_empty_set]
    // [1333] phi vera_heap_block_empty_set::block#2 = vera_heap_block_empty_set::block#1 [phi:vera_heap_malloc::@19->vera_heap_block_empty_set#0] -- register_copy 
    jsr vera_heap_block_empty_set
    // vera_heap_malloc::@20
    // cx16_ram_bank(cx16_ram_bank_current)
    // [682] cx16_ram_bank::bank#10 = vera_heap_malloc::cx16_ram_bank_current#0
    // [683] call cx16_ram_bank 
    // [1249] phi from vera_heap_malloc::@20 to cx16_ram_bank [phi:vera_heap_malloc::@20->cx16_ram_bank]
    // [1249] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#10 [phi:vera_heap_malloc::@20->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // vera_heap_malloc::@21
    // return address;
    // [684] vera_heap_malloc::return#5 = vera_heap_malloc::address -- vduz1=vduz2 
    lda.z address
    sta.z return
    lda.z address+1
    sta.z return+1
    lda.z address+2
    sta.z return+2
    lda.z address+3
    sta.z return+3
    rts
    // vera_heap_malloc::@5
  __b5:
    // segment->head_block = 0xA000
    // [685] ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK] = (struct vera_heap*) 40960 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK
    lda #<$a000
    sta (segment),y
    iny
    lda #>$a000
    sta (segment),y
    // segment->tail_block = 0xA000
    // [686] ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] = (struct vera_heap*) 40960 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    lda #<$a000
    sta (segment),y
    iny
    lda #>$a000
    sta (segment),y
    // block->next = 0x0000
    // [687] *((struct vera_heap**)(struct vera_heap*) 40960+OFFSET_STRUCT_VERA_HEAP_NEXT) = (struct vera_heap*) 0 -- _deref_qssc1=pssc2 
    lda #<0
    sta $a000+OFFSET_STRUCT_VERA_HEAP_NEXT
    sta $a000+OFFSET_STRUCT_VERA_HEAP_NEXT+1
    // block->prev = 0x0000
    // [688] *((struct vera_heap**)(struct vera_heap*) 40960+OFFSET_STRUCT_VERA_HEAP_PREV) = (struct vera_heap*) 0 -- _deref_qssc1=pssc2 
    sta $a000+OFFSET_STRUCT_VERA_HEAP_PREV
    sta $a000+OFFSET_STRUCT_VERA_HEAP_PREV+1
    // [675] phi from vera_heap_malloc::@5 to vera_heap_malloc::@6 [phi:vera_heap_malloc::@5->vera_heap_malloc::@6]
    // [675] phi vera_heap_malloc::block#6 = (struct vera_heap*) 40960 [phi:vera_heap_malloc::@5->vera_heap_malloc::@6#0] -- pssz1=pssc1 
    lda #<$a000
    sta.z block_1
    lda #>$a000
    sta.z block_1+1
    jmp __b6
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
// vera_layer_mode_tile(byte zp($12) layer, dword zp($13) mapbase_address, dword zp($17) tilebase_address, word zp($4f) mapwidth, word zp($51) mapheight, byte zp($1b) tilewidth, byte zp($1c) tileheight, byte register(X) color_depth)
vera_layer_mode_tile: {
    .label __1 = $4f
    .label __2 = $4f
    .label __4 = $4f
    .label __7 = $4f
    .label __8 = $4f
    .label __10 = $4f
    .label __19 = $63
    .label __20 = $64
    .label mapbase_address = $13
    .label tilebase_address = $17
    .label layer = $12
    .label mapwidth = $4f
    .label mapheight = $51
    .label tilewidth = $1b
    .label tileheight = $1c
    // case 1:
    //             config |= VERA_LAYER_COLOR_DEPTH_1BPP;
    //             break;
    // [690] if(vera_layer_mode_tile::color_depth#3==1) goto vera_layer_mode_tile::@5 -- vbuxx_eq_vbuc1_then_la1 
    cpx #1
    beq __b1
    // vera_layer_mode_tile::@1
    // case 2:
    //             config |= VERA_LAYER_COLOR_DEPTH_2BPP;
    //             break;
    // [691] if(vera_layer_mode_tile::color_depth#3==2) goto vera_layer_mode_tile::@5 -- vbuxx_eq_vbuc1_then_la1 
    cpx #2
    beq __b2
    // vera_layer_mode_tile::@2
    // case 4:
    //             config |= VERA_LAYER_COLOR_DEPTH_4BPP;
    //             break;
    // [692] if(vera_layer_mode_tile::color_depth#3==4) goto vera_layer_mode_tile::@5 -- vbuxx_eq_vbuc1_then_la1 
    cpx #4
    beq __b3
    // vera_layer_mode_tile::@3
    // case 8:
    //             config |= VERA_LAYER_COLOR_DEPTH_8BPP;
    //             break;
    // [693] if(vera_layer_mode_tile::color_depth#3!=8) goto vera_layer_mode_tile::@5 -- vbuxx_neq_vbuc1_then_la1 
    cpx #8
    bne __b4
    // [694] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@4 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@4]
    // vera_layer_mode_tile::@4
    // [695] phi from vera_layer_mode_tile::@4 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5]
    // [695] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_8BPP [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_8BPP
    jmp __b5
    // [695] phi from vera_layer_mode_tile to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5]
  __b1:
    // [695] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_1BPP [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_1BPP
    jmp __b5
    // [695] phi from vera_layer_mode_tile::@1 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5]
  __b2:
    // [695] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_2BPP [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_2BPP
    jmp __b5
    // [695] phi from vera_layer_mode_tile::@2 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5]
  __b3:
    // [695] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_4BPP [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_4BPP
    jmp __b5
    // [695] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5]
  __b4:
    // [695] phi vera_layer_mode_tile::config#17 = 0 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #0
    // vera_layer_mode_tile::@5
  __b5:
    // case 32:
    //             config |= VERA_LAYER_WIDTH_32;
    //             vera_layer_rowshift[layer] = 6;
    //             vera_layer_rowskip[layer] = 64;
    //             break;
    // [696] if(vera_layer_mode_tile::mapwidth#10==$20) goto vera_layer_mode_tile::@9 -- vwuz1_eq_vbuc1_then_la1 
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
    // [697] if(vera_layer_mode_tile::mapwidth#10==$40) goto vera_layer_mode_tile::@10 -- vwuz1_eq_vbuc1_then_la1 
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
    // [698] if(vera_layer_mode_tile::mapwidth#10==$80) goto vera_layer_mode_tile::@11 -- vwuz1_eq_vbuc1_then_la1 
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
    // [699] if(vera_layer_mode_tile::mapwidth#10!=$100) goto vera_layer_mode_tile::@13 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapwidth+1
    cmp #>$100
    bne __b13
    lda.z mapwidth
    cmp #<$100
    bne __b13
    // vera_layer_mode_tile::@12
    // config |= VERA_LAYER_WIDTH_256
    // [700] vera_layer_mode_tile::config#8 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_256 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_WIDTH_256
    tax
    // vera_layer_rowshift[layer] = 9
    // [701] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 9 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #9
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 512
    // [702] vera_layer_mode_tile::$16 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [703] vera_layer_rowskip[vera_layer_mode_tile::$16] = $200 -- pwuc1_derefidx_vbuaa=vwuc2 
    tay
    lda #<$200
    sta vera_layer_rowskip,y
    lda #>$200
    sta vera_layer_rowskip+1,y
    // [704] phi from vera_layer_mode_tile::@10 vera_layer_mode_tile::@11 vera_layer_mode_tile::@12 vera_layer_mode_tile::@8 vera_layer_mode_tile::@9 to vera_layer_mode_tile::@13 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13]
    // [704] phi vera_layer_mode_tile::config#21 = vera_layer_mode_tile::config#6 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13#0] -- register_copy 
    // vera_layer_mode_tile::@13
  __b13:
    // case 32:
    //             config |= VERA_LAYER_HEIGHT_32;
    //             break;
    // [705] if(vera_layer_mode_tile::mapheight#10==$20) goto vera_layer_mode_tile::@20 -- vwuz1_eq_vbuc1_then_la1 
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
    // [706] if(vera_layer_mode_tile::mapheight#10==$40) goto vera_layer_mode_tile::@17 -- vwuz1_eq_vbuc1_then_la1 
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
    // [707] if(vera_layer_mode_tile::mapheight#10==$80) goto vera_layer_mode_tile::@18 -- vwuz1_eq_vbuc1_then_la1 
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
    // [708] if(vera_layer_mode_tile::mapheight#10!=$100) goto vera_layer_mode_tile::@20 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapheight+1
    cmp #>$100
    bne __b20
    lda.z mapheight
    cmp #<$100
    bne __b20
    // vera_layer_mode_tile::@19
    // config |= VERA_LAYER_HEIGHT_256
    // [709] vera_layer_mode_tile::config#12 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_256 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_HEIGHT_256
    tax
    // [710] phi from vera_layer_mode_tile::@13 vera_layer_mode_tile::@16 vera_layer_mode_tile::@17 vera_layer_mode_tile::@18 vera_layer_mode_tile::@19 to vera_layer_mode_tile::@20 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20]
    // [710] phi vera_layer_mode_tile::config#25 = vera_layer_mode_tile::config#21 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20#0] -- register_copy 
    // vera_layer_mode_tile::@20
  __b20:
    // vera_layer_set_config(layer, config)
    // [711] vera_layer_set_config::layer#0 = vera_layer_mode_tile::layer#10 -- vbuaa=vbuz1 
    lda.z layer
    // [712] vera_layer_set_config::config#0 = vera_layer_mode_tile::config#25
    // [713] call vera_layer_set_config 
    jsr vera_layer_set_config
    // vera_layer_mode_tile::@27
    // <mapbase_address
    // [714] vera_layer_mode_tile::$1 = < vera_layer_mode_tile::mapbase_address#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase_address
    sta.z __1
    lda.z mapbase_address+1
    sta.z __1+1
    // vera_mapbase_offset[layer] = <mapbase_address
    // [715] vera_layer_mode_tile::$19 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z layer
    asl
    sta.z __19
    // [716] vera_mapbase_offset[vera_layer_mode_tile::$19] = vera_layer_mode_tile::$1 -- pwuc1_derefidx_vbuz1=vwuz2 
    // mapbase
    tay
    lda.z __1
    sta vera_mapbase_offset,y
    lda.z __1+1
    sta vera_mapbase_offset+1,y
    // >mapbase_address
    // [717] vera_layer_mode_tile::$2 = > vera_layer_mode_tile::mapbase_address#10 -- vwuz1=_hi_vduz2 
    lda.z mapbase_address+2
    sta.z __2
    lda.z mapbase_address+3
    sta.z __2+1
    // vera_mapbase_bank[layer] = (byte)(>mapbase_address)
    // [718] vera_mapbase_bank[vera_layer_mode_tile::layer#10] = (byte)vera_layer_mode_tile::$2 -- pbuc1_derefidx_vbuz1=_byte_vwuz2 
    ldy.z layer
    lda.z __2
    sta vera_mapbase_bank,y
    // vera_mapbase_address[layer] = mapbase_address
    // [719] vera_layer_mode_tile::$20 = vera_layer_mode_tile::layer#10 << 2 -- vbuz1=vbuz2_rol_2 
    tya
    asl
    asl
    sta.z __20
    // [720] vera_mapbase_address[vera_layer_mode_tile::$20] = vera_layer_mode_tile::mapbase_address#10 -- pduc1_derefidx_vbuz1=vduz2 
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
    // [721] vera_layer_mode_tile::mapbase_address#0 = vera_layer_mode_tile::mapbase_address#10 >> 1 -- vduz1=vduz1_ror_1 
    lsr.z mapbase_address+3
    ror.z mapbase_address+2
    ror.z mapbase_address+1
    ror.z mapbase_address
    // <mapbase_address
    // [722] vera_layer_mode_tile::$4 = < vera_layer_mode_tile::mapbase_address#0 -- vwuz1=_lo_vduz2 
    lda.z mapbase_address
    sta.z __4
    lda.z mapbase_address+1
    sta.z __4+1
    // mapbase = >(<mapbase_address)
    // [723] vera_layer_mode_tile::mapbase#0 = > vera_layer_mode_tile::$4 -- vbuxx=_hi_vwuz1 
    tax
    // vera_layer_set_mapbase(layer,mapbase)
    // [724] vera_layer_set_mapbase::layer#0 = vera_layer_mode_tile::layer#10 -- vbuaa=vbuz1 
    lda.z layer
    // [725] vera_layer_set_mapbase::mapbase#0 = vera_layer_mode_tile::mapbase#0
    // [726] call vera_layer_set_mapbase 
    // [480] phi from vera_layer_mode_tile::@27 to vera_layer_set_mapbase [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase]
    // [480] phi vera_layer_set_mapbase::mapbase#3 = vera_layer_set_mapbase::mapbase#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#0] -- register_copy 
    // [480] phi vera_layer_set_mapbase::layer#3 = vera_layer_set_mapbase::layer#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#1] -- register_copy 
    jsr vera_layer_set_mapbase
    // vera_layer_mode_tile::@28
    // <tilebase_address
    // [727] vera_layer_mode_tile::$7 = < vera_layer_mode_tile::tilebase_address#10 -- vwuz1=_lo_vduz2 
    lda.z tilebase_address
    sta.z __7
    lda.z tilebase_address+1
    sta.z __7+1
    // vera_tilebase_offset[layer] = <tilebase_address
    // [728] vera_tilebase_offset[vera_layer_mode_tile::$19] = vera_layer_mode_tile::$7 -- pwuc1_derefidx_vbuz1=vwuz2 
    // tilebase
    ldy.z __19
    lda.z __7
    sta vera_tilebase_offset,y
    lda.z __7+1
    sta vera_tilebase_offset+1,y
    // >tilebase_address
    // [729] vera_layer_mode_tile::$8 = > vera_layer_mode_tile::tilebase_address#10 -- vwuz1=_hi_vduz2 
    lda.z tilebase_address+2
    sta.z __8
    lda.z tilebase_address+3
    sta.z __8+1
    // vera_tilebase_bank[layer] = (byte)>tilebase_address
    // [730] vera_tilebase_bank[vera_layer_mode_tile::layer#10] = (byte)vera_layer_mode_tile::$8 -- pbuc1_derefidx_vbuz1=_byte_vwuz2 
    ldy.z layer
    lda.z __8
    sta vera_tilebase_bank,y
    // vera_tilebase_address[layer] = tilebase_address
    // [731] vera_tilebase_address[vera_layer_mode_tile::$20] = vera_layer_mode_tile::tilebase_address#10 -- pduc1_derefidx_vbuz1=vduz2 
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
    // [732] vera_layer_mode_tile::tilebase_address#0 = vera_layer_mode_tile::tilebase_address#10 >> 1 -- vduz1=vduz1_ror_1 
    lsr.z tilebase_address+3
    ror.z tilebase_address+2
    ror.z tilebase_address+1
    ror.z tilebase_address
    // <tilebase_address
    // [733] vera_layer_mode_tile::$10 = < vera_layer_mode_tile::tilebase_address#0 -- vwuz1=_lo_vduz2 
    lda.z tilebase_address
    sta.z __10
    lda.z tilebase_address+1
    sta.z __10+1
    // tilebase = >(<tilebase_address)
    // [734] vera_layer_mode_tile::tilebase#0 = > vera_layer_mode_tile::$10 -- vbuaa=_hi_vwuz1 
    // tilebase &= VERA_LAYER_TILEBASE_MASK
    // [735] vera_layer_mode_tile::tilebase#1 = vera_layer_mode_tile::tilebase#0 & VERA_LAYER_TILEBASE_MASK -- vbuxx=vbuaa_band_vbuc1 
    and #VERA_LAYER_TILEBASE_MASK
    tax
    // case 8:
    //             tilebase |= VERA_TILEBASE_WIDTH_8;
    //             break;
    // [736] if(vera_layer_mode_tile::tilewidth#10==8) goto vera_layer_mode_tile::@23 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tilewidth
    beq __b23
    // vera_layer_mode_tile::@21
    // case 16:
    //             tilebase |= VERA_TILEBASE_WIDTH_16;
    //             break;
    // [737] if(vera_layer_mode_tile::tilewidth#10!=$10) goto vera_layer_mode_tile::@23 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tilewidth
    bne __b23
    // vera_layer_mode_tile::@22
    // tilebase |= VERA_TILEBASE_WIDTH_16
    // [738] vera_layer_mode_tile::tilebase#3 = vera_layer_mode_tile::tilebase#1 | VERA_TILEBASE_WIDTH_16 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_TILEBASE_WIDTH_16
    tax
    // [739] phi from vera_layer_mode_tile::@21 vera_layer_mode_tile::@22 vera_layer_mode_tile::@28 to vera_layer_mode_tile::@23 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23]
    // [739] phi vera_layer_mode_tile::tilebase#12 = vera_layer_mode_tile::tilebase#1 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23#0] -- register_copy 
    // vera_layer_mode_tile::@23
  __b23:
    // case 8:
    //             tilebase |= VERA_TILEBASE_HEIGHT_8;
    //             break;
    // [740] if(vera_layer_mode_tile::tileheight#10==8) goto vera_layer_mode_tile::@26 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tileheight
    beq __b26
    // vera_layer_mode_tile::@24
    // case 16:
    //             tilebase |= VERA_TILEBASE_HEIGHT_16;
    //             break;
    // [741] if(vera_layer_mode_tile::tileheight#10!=$10) goto vera_layer_mode_tile::@26 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tileheight
    bne __b26
    // vera_layer_mode_tile::@25
    // tilebase |= VERA_TILEBASE_HEIGHT_16
    // [742] vera_layer_mode_tile::tilebase#5 = vera_layer_mode_tile::tilebase#12 | VERA_TILEBASE_HEIGHT_16 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_TILEBASE_HEIGHT_16
    tax
    // [743] phi from vera_layer_mode_tile::@23 vera_layer_mode_tile::@24 vera_layer_mode_tile::@25 to vera_layer_mode_tile::@26 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26]
    // [743] phi vera_layer_mode_tile::tilebase#10 = vera_layer_mode_tile::tilebase#12 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26#0] -- register_copy 
    // vera_layer_mode_tile::@26
  __b26:
    // vera_layer_set_tilebase(layer,tilebase)
    // [744] vera_layer_set_tilebase::layer#0 = vera_layer_mode_tile::layer#10 -- vbuaa=vbuz1 
    lda.z layer
    // [745] vera_layer_set_tilebase::tilebase#0 = vera_layer_mode_tile::tilebase#10
    // [746] call vera_layer_set_tilebase 
    jsr vera_layer_set_tilebase
    // vera_layer_mode_tile::@return
    // }
    // [747] return 
    rts
    // vera_layer_mode_tile::@18
  __b18:
    // config |= VERA_LAYER_HEIGHT_128
    // [748] vera_layer_mode_tile::config#11 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_128 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_HEIGHT_128
    tax
    jmp __b20
    // vera_layer_mode_tile::@17
  __b17:
    // config |= VERA_LAYER_HEIGHT_64
    // [749] vera_layer_mode_tile::config#10 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_64 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_HEIGHT_64
    tax
    jmp __b20
    // vera_layer_mode_tile::@11
  __b11:
    // config |= VERA_LAYER_WIDTH_128
    // [750] vera_layer_mode_tile::config#7 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_128 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_WIDTH_128
    tax
    // vera_layer_rowshift[layer] = 8
    // [751] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 8 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #8
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 256
    // [752] vera_layer_mode_tile::$15 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [753] vera_layer_rowskip[vera_layer_mode_tile::$15] = $100 -- pwuc1_derefidx_vbuaa=vwuc2 
    tay
    lda #<$100
    sta vera_layer_rowskip,y
    lda #>$100
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@10
  __b10:
    // config |= VERA_LAYER_WIDTH_64
    // [754] vera_layer_mode_tile::config#6 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_64 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_WIDTH_64
    tax
    // vera_layer_rowshift[layer] = 7
    // [755] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 7 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #7
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 128
    // [756] vera_layer_mode_tile::$14 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [757] vera_layer_rowskip[vera_layer_mode_tile::$14] = $80 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #$80
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@9
  __b9:
    // vera_layer_rowshift[layer] = 6
    // [758] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 6 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #6
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 64
    // [759] vera_layer_mode_tile::$13 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [760] vera_layer_rowskip[vera_layer_mode_tile::$13] = $40 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #$40
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b13
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __1 = $6d
    .label line_text = $7b
    .label color = $6d
    .label conio_map_height = $65
    .label conio_map_width = $67
    // line_text = cx16_conio.conio_screen_text
    // [761] clrscr::line_text#0 = *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- pbuz1=_deref_qbuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z line_text+1
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer)
    // [762] vera_layer_get_backcolor::layer#0 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [763] call vera_layer_get_backcolor 
    jsr vera_layer_get_backcolor
    // [764] vera_layer_get_backcolor::return#2 = vera_layer_get_backcolor::return#0
    // clrscr::@7
    // [765] clrscr::$0 = vera_layer_get_backcolor::return#2
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4
    // [766] clrscr::$1 = clrscr::$0 << 4 -- vbuz1=vbuaa_rol_4 
    asl
    asl
    asl
    asl
    sta.z __1
    // vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [767] vera_layer_get_textcolor::layer#0 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [768] call vera_layer_get_textcolor 
    jsr vera_layer_get_textcolor
    // [769] vera_layer_get_textcolor::return#2 = vera_layer_get_textcolor::return#0
    // clrscr::@8
    // [770] clrscr::$2 = vera_layer_get_textcolor::return#2
    // color = ( vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4 ) | vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [771] clrscr::color#0 = clrscr::$1 | clrscr::$2 -- vbuz1=vbuz1_bor_vbuaa 
    ora.z color
    sta.z color
    // conio_map_height = cx16_conio.conio_map_height
    // [772] clrscr::conio_map_height#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    sta.z conio_map_height
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    sta.z conio_map_height+1
    // conio_map_width = cx16_conio.conio_map_width
    // [773] clrscr::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // [774] phi from clrscr::@8 to clrscr::@1 [phi:clrscr::@8->clrscr::@1]
    // [774] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr::@8->clrscr::@1#0] -- register_copy 
    // [774] phi clrscr::l#2 = 0 [phi:clrscr::@8->clrscr::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // clrscr::@1
  __b1:
    // for( char l=0;l<conio_map_height; l++ )
    // [775] if(clrscr::l#2<clrscr::conio_map_height#0) goto clrscr::@2 -- vbuxx_lt_vwuz1_then_la1 
    lda.z conio_map_height+1
    bne __b2
    cpx.z conio_map_height
    bcc __b2
    // clrscr::@3
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [776] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = 0
    // [777] conio_cursor_y[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    sta conio_cursor_y,y
    // conio_line_text[cx16_conio.conio_screen_layer] = 0
    // [778] clrscr::$9 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    tya
    asl
    // [779] conio_line_text[clrscr::$9] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta conio_line_text,y
    sta conio_line_text+1,y
    // clrscr::@return
    // }
    // [780] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [781] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <ch
    // [782] clrscr::$5 = < clrscr::line_text#2 -- vbuaa=_lo_pbuz1 
    lda.z line_text
    // *VERA_ADDRX_L = <ch
    // [783] *VERA_ADDRX_L = clrscr::$5 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >ch
    // [784] clrscr::$6 = > clrscr::line_text#2 -- vbuaa=_hi_pbuz1 
    lda.z line_text+1
    // *VERA_ADDRX_M = >ch
    // [785] *VERA_ADDRX_M = clrscr::$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [786] clrscr::$7 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [787] *VERA_ADDRX_H = clrscr::$7 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [788] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [788] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuyy=vbuc1 
    ldy #0
    // clrscr::@4
  __b4:
    // for( char c=0;c<conio_map_width; c++ )
    // [789] if(clrscr::c#2<clrscr::conio_map_width#0) goto clrscr::@5 -- vbuyy_lt_vwuz1_then_la1 
    lda.z conio_map_width+1
    bne __b5
    cpy.z conio_map_width
    bcc __b5
    // clrscr::@6
    // line_text += cx16_conio.conio_rowskip
    // [790] clrscr::line_text#1 = clrscr::line_text#2 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- pbuz1=pbuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z line_text
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z line_text+1
    sta.z line_text+1
    // for( char l=0;l<conio_map_height; l++ )
    // [791] clrscr::l#1 = ++ clrscr::l#2 -- vbuxx=_inc_vbuxx 
    inx
    // [774] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [774] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [774] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [792] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [793] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<conio_map_width; c++ )
    // [794] clrscr::c#1 = ++ clrscr::c#2 -- vbuyy=_inc_vbuyy 
    iny
    // [788] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [788] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
}
  // vera_heap_segment_ceiling
// vera_heap_segment_ceiling(byte register(X) segmentid)
vera_heap_segment_ceiling: {
    .label segment = $67
    .label return = $c4
    // &vera_heap_segments[segmentid]
    // [796] vera_heap_segment_ceiling::$4 = vera_heap_segment_ceiling::segmentid#2 << 2 -- vbuaa=vbuxx_rol_2 
    txa
    asl
    asl
    // [797] vera_heap_segment_ceiling::$5 = vera_heap_segment_ceiling::$4 + vera_heap_segment_ceiling::segmentid#2 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [798] vera_heap_segment_ceiling::$6 = vera_heap_segment_ceiling::$5 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [799] vera_heap_segment_ceiling::$7 = vera_heap_segment_ceiling::$6 + vera_heap_segment_ceiling::segmentid#2 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [800] vera_heap_segment_ceiling::$1 = vera_heap_segment_ceiling::$7 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // segment = &vera_heap_segments[segmentid]
    // [801] vera_heap_segment_ceiling::segment#0 = vera_heap_segments + vera_heap_segment_ceiling::$1 -- pssz1=pssc1_plus_vbuaa 
    clc
    adc #<vera_heap_segments
    sta.z segment
    lda #>vera_heap_segments
    adc #0
    sta.z segment+1
    // return segment->ceil_address;
    // [802] vera_heap_segment_ceiling::return#0 = ((dword*)vera_heap_segment_ceiling::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS
    lda (segment),y
    sta.z return
    iny
    lda (segment),y
    sta.z return+1
    iny
    lda (segment),y
    sta.z return+2
    iny
    lda (segment),y
    sta.z return+3
    // vera_heap_segment_ceiling::@return
    // }
    // [803] return 
    rts
}
  // sprite_cpy_vram
// sprite_cpy_vram(struct Sprite* zp($cc) Sprite)
sprite_cpy_vram: {
    .label __3 = $3f
    .label __12 = $ab
    .label bsrc = $76
    .label size = $ad
    .label vaddr = $e
    .label baddr = $3f
    .label s = $7d
    .label Sprite = $cc
    // bsrc = Sprite->BRAM_Address
    // [805] sprite_cpy_vram::bsrc#0 = ((dword*)sprite_cpy_vram::Sprite#2)[OFFSET_STRUCT_SPRITE_BRAM_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_BRAM_ADDRESS
    lda (Sprite),y
    sta.z bsrc
    iny
    lda (Sprite),y
    sta.z bsrc+1
    iny
    lda (Sprite),y
    sta.z bsrc+2
    iny
    lda (Sprite),y
    sta.z bsrc+3
    // size = Sprite->SpriteSize
    // [806] sprite_cpy_vram::size#0 = ((word*)sprite_cpy_vram::Sprite#2)[OFFSET_STRUCT_SPRITE_SPRITESIZE] -- vwuz1=pwuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_SPRITESIZE
    lda (Sprite),y
    sta.z size
    iny
    lda (Sprite),y
    sta.z size+1
    // [807] phi from sprite_cpy_vram to sprite_cpy_vram::@1 [phi:sprite_cpy_vram->sprite_cpy_vram::@1]
    // [807] phi sprite_cpy_vram::s#2 = 0 [phi:sprite_cpy_vram->sprite_cpy_vram::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z s
    // sprite_cpy_vram::@1
  __b1:
    // for(byte s=0;s<Sprite->SpriteCount;s++)
    // [808] if(sprite_cpy_vram::s#2<((byte*)sprite_cpy_vram::Sprite#2)[OFFSET_STRUCT_SPRITE_SPRITECOUNT]) goto sprite_cpy_vram::@2 -- vbuz1_lt_pbuz2_derefidx_vbuc1_then_la1 
    ldy #OFFSET_STRUCT_SPRITE_SPRITECOUNT
    lda (Sprite),y
    cmp.z s
    beq !+
    bcs __b2
  !:
    // sprite_cpy_vram::@return
    // }
    // [809] return 
    rts
    // sprite_cpy_vram::@2
  __b2:
    // vera_heap_malloc(segmentid, size)
    // [810] vera_heap_malloc::size = sprite_cpy_vram::size#0 -- vwuz1=vwuz2 
    lda.z size
    sta.z vera_heap_malloc.size
    lda.z size+1
    sta.z vera_heap_malloc.size+1
    // [811] call vera_heap_malloc 
    // [623] phi from sprite_cpy_vram::@2 to vera_heap_malloc [phi:sprite_cpy_vram::@2->vera_heap_malloc]
    // [623] phi vera_heap_malloc::segmentid#4 = HEAP_SPRITES [phi:sprite_cpy_vram::@2->vera_heap_malloc#0] -- vbuxx=vbuc1 
    ldx #HEAP_SPRITES
    jsr vera_heap_malloc
    // vera_heap_malloc(segmentid, size)
    // [812] vera_heap_malloc::return#11 = vera_heap_malloc::return#1
    // sprite_cpy_vram::@3
    // vaddr = vera_heap_malloc(segmentid, size)
    // [813] sprite_cpy_vram::vaddr#0 = vera_heap_malloc::return#11
    // mul16u((word)s,size)
    // [814] mul16u::a#1 = (word)sprite_cpy_vram::s#2 -- vwuz1=_word_vbuz2 
    lda.z s
    sta.z mul16u.a
    lda #0
    sta.z mul16u.a+1
    // [815] mul16u::b#0 = sprite_cpy_vram::size#0 -- vwuz1=vwuz2 
    lda.z size
    sta.z mul16u.b
    lda.z size+1
    sta.z mul16u.b+1
    // [816] call mul16u 
    // [1391] phi from sprite_cpy_vram::@3 to mul16u [phi:sprite_cpy_vram::@3->mul16u]
    // [1391] phi mul16u::a#6 = mul16u::a#1 [phi:sprite_cpy_vram::@3->mul16u#0] -- register_copy 
    // [1391] phi mul16u::b#2 = mul16u::b#0 [phi:sprite_cpy_vram::@3->mul16u#1] -- register_copy 
    jsr mul16u
    // mul16u((word)s,size)
    // [817] mul16u::return#2 = mul16u::res#2
    // sprite_cpy_vram::@4
    // [818] sprite_cpy_vram::$3 = mul16u::return#2
    // baddr = bsrc+mul16u((word)s,size)
    // [819] sprite_cpy_vram::baddr#0 = sprite_cpy_vram::bsrc#0 + sprite_cpy_vram::$3 -- vduz1=vduz2_plus_vduz1 
    lda.z baddr
    clc
    adc.z bsrc
    sta.z baddr
    lda.z baddr+1
    adc.z bsrc+1
    sta.z baddr+1
    lda.z baddr+2
    adc.z bsrc+2
    sta.z baddr+2
    lda.z baddr+3
    adc.z bsrc+3
    sta.z baddr+3
    // vera_cpy_bank_vram(baddr, vaddr, size)
    // [820] vera_cpy_bank_vram::bsrc#0 = sprite_cpy_vram::baddr#0
    // [821] vera_cpy_bank_vram::vdest#0 = sprite_cpy_vram::vaddr#0 -- vduz1=vduz2 
    lda.z vaddr
    sta.z vera_cpy_bank_vram.vdest
    lda.z vaddr+1
    sta.z vera_cpy_bank_vram.vdest+1
    lda.z vaddr+2
    sta.z vera_cpy_bank_vram.vdest+2
    lda.z vaddr+3
    sta.z vera_cpy_bank_vram.vdest+3
    // [822] vera_cpy_bank_vram::num#0 = sprite_cpy_vram::size#0 -- vduz1=vwuz2 
    lda.z size
    sta.z vera_cpy_bank_vram.num
    lda.z size+1
    sta.z vera_cpy_bank_vram.num+1
    lda #0
    sta.z vera_cpy_bank_vram.num+2
    sta.z vera_cpy_bank_vram.num+3
    // [823] call vera_cpy_bank_vram 
    // [853] phi from sprite_cpy_vram::@4 to vera_cpy_bank_vram [phi:sprite_cpy_vram::@4->vera_cpy_bank_vram]
    // [853] phi vera_cpy_bank_vram::num#5 = vera_cpy_bank_vram::num#0 [phi:sprite_cpy_vram::@4->vera_cpy_bank_vram#0] -- register_copy 
    // [853] phi vera_cpy_bank_vram::bsrc#3 = vera_cpy_bank_vram::bsrc#0 [phi:sprite_cpy_vram::@4->vera_cpy_bank_vram#1] -- register_copy 
    // [853] phi vera_cpy_bank_vram::vdest#3 = vera_cpy_bank_vram::vdest#0 [phi:sprite_cpy_vram::@4->vera_cpy_bank_vram#2] -- register_copy 
    jsr vera_cpy_bank_vram
    // sprite_cpy_vram::@5
    // Sprite->VRAM_Addresses[s] = vaddr
    // [824] sprite_cpy_vram::$6 = sprite_cpy_vram::s#2 << 2 -- vbuyy=vbuz1_rol_2 
    lda.z s
    asl
    asl
    tay
    // [825] sprite_cpy_vram::$12 = (dword*)sprite_cpy_vram::Sprite#2 + OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES -- pduz1=pduz2_plus_vbuc1 
    lda #OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES
    clc
    adc.z Sprite
    sta.z __12
    lda #0
    adc.z Sprite+1
    sta.z __12+1
    // [826] sprite_cpy_vram::$12[sprite_cpy_vram::$6] = sprite_cpy_vram::vaddr#0 -- pduz1_derefidx_vbuyy=vduz2 
    lda.z vaddr
    sta (__12),y
    iny
    lda.z vaddr+1
    sta (__12),y
    iny
    lda.z vaddr+2
    sta (__12),y
    iny
    lda.z vaddr+3
    sta (__12),y
    // for(byte s=0;s<Sprite->SpriteCount;s++)
    // [827] sprite_cpy_vram::s#1 = ++ sprite_cpy_vram::s#2 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [807] phi from sprite_cpy_vram::@5 to sprite_cpy_vram::@1 [phi:sprite_cpy_vram::@5->sprite_cpy_vram::@1]
    // [807] phi sprite_cpy_vram::s#2 = sprite_cpy_vram::s#1 [phi:sprite_cpy_vram::@5->sprite_cpy_vram::@1#0] -- register_copy 
    jmp __b1
}
  // tile_cpy_vram
// tile_cpy_vram(struct Tile* zp($a9) Tile)
tile_cpy_vram: {
    .label __2 = $3f
    .label __9 = $ad
    .label bsrc = $69
    .label num = $6d
    .label size = $ab
    .label vaddr = $6e
    .label baddr = $3f
    .label s = $7e
    .label Tile = $a9
    // bsrc = Tile->BRAM_Address
    // [829] tile_cpy_vram::bsrc#0 = ((dword*)tile_cpy_vram::Tile#3)[OFFSET_STRUCT_TILE_BRAM_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_BRAM_ADDRESS
    lda (Tile),y
    sta.z bsrc
    iny
    lda (Tile),y
    sta.z bsrc+1
    iny
    lda (Tile),y
    sta.z bsrc+2
    iny
    lda (Tile),y
    sta.z bsrc+3
    // num = Tile->TileCount
    // [830] tile_cpy_vram::num#0 = ((byte*)tile_cpy_vram::Tile#3)[OFFSET_STRUCT_TILE_TILECOUNT] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_TILECOUNT
    lda (Tile),y
    sta.z num
    // size = Tile->TileSize
    // [831] tile_cpy_vram::size#0 = ((word*)tile_cpy_vram::Tile#3)[OFFSET_STRUCT_TILE_TILESIZE] -- vwuz1=pwuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_TILESIZE
    lda (Tile),y
    sta.z size
    iny
    lda (Tile),y
    sta.z size+1
    // [832] phi from tile_cpy_vram to tile_cpy_vram::@1 [phi:tile_cpy_vram->tile_cpy_vram::@1]
    // [832] phi tile_cpy_vram::s#2 = 0 [phi:tile_cpy_vram->tile_cpy_vram::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z s
    // tile_cpy_vram::@1
  __b1:
    // for(byte s=0;s<num;s++)
    // [833] if(tile_cpy_vram::s#2<tile_cpy_vram::num#0) goto tile_cpy_vram::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z s
    cmp.z num
    bcc __b2
    // tile_cpy_vram::@return
    // }
    // [834] return 
    rts
    // tile_cpy_vram::@2
  __b2:
    // vera_heap_malloc(segmentid, size)
    // [835] vera_heap_malloc::size = tile_cpy_vram::size#0 -- vwuz1=vwuz2 
    lda.z size
    sta.z vera_heap_malloc.size
    lda.z size+1
    sta.z vera_heap_malloc.size+1
    // [836] call vera_heap_malloc 
    // [623] phi from tile_cpy_vram::@2 to vera_heap_malloc [phi:tile_cpy_vram::@2->vera_heap_malloc]
    // [623] phi vera_heap_malloc::segmentid#4 = HEAP_FLOOR_TILE [phi:tile_cpy_vram::@2->vera_heap_malloc#0] -- vbuxx=vbuc1 
    ldx #HEAP_FLOOR_TILE
    jsr vera_heap_malloc
    // vera_heap_malloc(segmentid, size)
    // [837] vera_heap_malloc::return#12 = vera_heap_malloc::return#1
    // tile_cpy_vram::@3
    // vaddr = vera_heap_malloc(segmentid, size)
    // [838] tile_cpy_vram::vaddr#0 = vera_heap_malloc::return#12 -- vduz1=vduz2 
    lda.z vera_heap_malloc.return
    sta.z vaddr
    lda.z vera_heap_malloc.return+1
    sta.z vaddr+1
    lda.z vera_heap_malloc.return+2
    sta.z vaddr+2
    lda.z vera_heap_malloc.return+3
    sta.z vaddr+3
    // mul16u((word)s,size)
    // [839] mul16u::a#2 = (word)tile_cpy_vram::s#2 -- vwuz1=_word_vbuz2 
    lda.z s
    sta.z mul16u.a
    lda #0
    sta.z mul16u.a+1
    // [840] mul16u::b#1 = tile_cpy_vram::size#0 -- vwuz1=vwuz2 
    lda.z size
    sta.z mul16u.b
    lda.z size+1
    sta.z mul16u.b+1
    // [841] call mul16u 
    // [1391] phi from tile_cpy_vram::@3 to mul16u [phi:tile_cpy_vram::@3->mul16u]
    // [1391] phi mul16u::a#6 = mul16u::a#2 [phi:tile_cpy_vram::@3->mul16u#0] -- register_copy 
    // [1391] phi mul16u::b#2 = mul16u::b#1 [phi:tile_cpy_vram::@3->mul16u#1] -- register_copy 
    jsr mul16u
    // mul16u((word)s,size)
    // [842] mul16u::return#3 = mul16u::res#2
    // tile_cpy_vram::@4
    // [843] tile_cpy_vram::$2 = mul16u::return#3
    // baddr = bsrc+mul16u((word)s,size)
    // [844] tile_cpy_vram::baddr#0 = tile_cpy_vram::bsrc#0 + tile_cpy_vram::$2 -- vduz1=vduz2_plus_vduz1 
    lda.z baddr
    clc
    adc.z bsrc
    sta.z baddr
    lda.z baddr+1
    adc.z bsrc+1
    sta.z baddr+1
    lda.z baddr+2
    adc.z bsrc+2
    sta.z baddr+2
    lda.z baddr+3
    adc.z bsrc+3
    sta.z baddr+3
    // vera_cpy_bank_vram(baddr, vaddr, size)
    // [845] vera_cpy_bank_vram::bsrc#1 = tile_cpy_vram::baddr#0
    // [846] vera_cpy_bank_vram::vdest#1 = tile_cpy_vram::vaddr#0 -- vduz1=vduz2 
    lda.z vaddr
    sta.z vera_cpy_bank_vram.vdest
    lda.z vaddr+1
    sta.z vera_cpy_bank_vram.vdest+1
    lda.z vaddr+2
    sta.z vera_cpy_bank_vram.vdest+2
    lda.z vaddr+3
    sta.z vera_cpy_bank_vram.vdest+3
    // [847] vera_cpy_bank_vram::num#1 = tile_cpy_vram::size#0 -- vduz1=vwuz2 
    lda.z size
    sta.z vera_cpy_bank_vram.num
    lda.z size+1
    sta.z vera_cpy_bank_vram.num+1
    lda #0
    sta.z vera_cpy_bank_vram.num+2
    sta.z vera_cpy_bank_vram.num+3
    // [848] call vera_cpy_bank_vram 
    // [853] phi from tile_cpy_vram::@4 to vera_cpy_bank_vram [phi:tile_cpy_vram::@4->vera_cpy_bank_vram]
    // [853] phi vera_cpy_bank_vram::num#5 = vera_cpy_bank_vram::num#1 [phi:tile_cpy_vram::@4->vera_cpy_bank_vram#0] -- register_copy 
    // [853] phi vera_cpy_bank_vram::bsrc#3 = vera_cpy_bank_vram::bsrc#1 [phi:tile_cpy_vram::@4->vera_cpy_bank_vram#1] -- register_copy 
    // [853] phi vera_cpy_bank_vram::vdest#3 = vera_cpy_bank_vram::vdest#1 [phi:tile_cpy_vram::@4->vera_cpy_bank_vram#2] -- register_copy 
    jsr vera_cpy_bank_vram
    // tile_cpy_vram::@5
    // Tile->VRAM_Addresses[s] = vaddr
    // [849] tile_cpy_vram::$5 = tile_cpy_vram::s#2 << 2 -- vbuyy=vbuz1_rol_2 
    lda.z s
    asl
    asl
    tay
    // [850] tile_cpy_vram::$9 = (dword*)tile_cpy_vram::Tile#3 + OFFSET_STRUCT_TILE_VRAM_ADDRESSES -- pduz1=pduz2_plus_vbuc1 
    lda #OFFSET_STRUCT_TILE_VRAM_ADDRESSES
    clc
    adc.z Tile
    sta.z __9
    lda #0
    adc.z Tile+1
    sta.z __9+1
    // [851] tile_cpy_vram::$9[tile_cpy_vram::$5] = tile_cpy_vram::vaddr#0 -- pduz1_derefidx_vbuyy=vduz2 
    lda.z vaddr
    sta (__9),y
    iny
    lda.z vaddr+1
    sta (__9),y
    iny
    lda.z vaddr+2
    sta (__9),y
    iny
    lda.z vaddr+3
    sta (__9),y
    // for(byte s=0;s<num;s++)
    // [852] tile_cpy_vram::s#1 = ++ tile_cpy_vram::s#2 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [832] phi from tile_cpy_vram::@5 to tile_cpy_vram::@1 [phi:tile_cpy_vram::@5->tile_cpy_vram::@1]
    // [832] phi tile_cpy_vram::s#2 = tile_cpy_vram::s#1 [phi:tile_cpy_vram::@5->tile_cpy_vram::@1#0] -- register_copy 
    jmp __b1
}
  // vera_cpy_bank_vram
// Copy block of banked internal memory (256 banks at A000-BFFF) to VERA VRAM.
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vdest: absolute address in VERA VRAM
// - bsrc: absolute address in the banked RAM of the CX16
// - num: dword of the number of bytes to copy
// Note: This function can switch RAM bank during copying to copy data from multiple RAM banks.
// vera_cpy_bank_vram(dword zp($3f) bsrc, dword zp($24) vdest, dword zp($5f) num)
vera_cpy_bank_vram: {
    .label __0 = $72
    .label __2 = $65
    .label __4 = $74
    .label __6 = $72
    .label __7 = $72
    .label __9 = $72
    .label __11 = $74
    .label __12 = $74
    .label __13 = $72
    .label __14 = $72
    .label __16 = $74
    .label __17 = $af
    .label __24 = $74
    .label __25 = $7b
    .label bank = $7f
    // select the bank
    .label addr = $af
    .label i = $c8
    .label bsrc = $3f
    .label vdest = $24
    .label num = $5f
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [854] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <vdest
    // [855] vera_cpy_bank_vram::$0 = < vera_cpy_bank_vram::vdest#3 -- vwuz1=_lo_vduz2 
    lda.z vdest
    sta.z __0
    lda.z vdest+1
    sta.z __0+1
    // <(<vdest)
    // [856] vera_cpy_bank_vram::$1 = < vera_cpy_bank_vram::$0 -- vbuaa=_lo_vwuz1 
    lda.z __0
    // *VERA_ADDRX_L = <(<vdest)
    // [857] *VERA_ADDRX_L = vera_cpy_bank_vram::$1 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // <vdest
    // [858] vera_cpy_bank_vram::$2 = < vera_cpy_bank_vram::vdest#3 -- vwuz1=_lo_vduz2 
    lda.z vdest
    sta.z __2
    lda.z vdest+1
    sta.z __2+1
    // >(<vdest)
    // [859] vera_cpy_bank_vram::$3 = > vera_cpy_bank_vram::$2 -- vbuaa=_hi_vwuz1 
    // *VERA_ADDRX_M = >(<vdest)
    // [860] *VERA_ADDRX_M = vera_cpy_bank_vram::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // >vdest
    // [861] vera_cpy_bank_vram::$4 = > vera_cpy_bank_vram::vdest#3 -- vwuz1=_hi_vduz2 
    lda.z vdest+2
    sta.z __4
    lda.z vdest+3
    sta.z __4+1
    // <(>vdest)
    // [862] vera_cpy_bank_vram::$5 = < vera_cpy_bank_vram::$4 -- vbuaa=_lo_vwuz1 
    lda.z __4
    // *VERA_ADDRX_H = <(>vdest)
    // [863] *VERA_ADDRX_H = vera_cpy_bank_vram::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_ADDRX_H |= VERA_INC_1
    // [864] *VERA_ADDRX_H = *VERA_ADDRX_H | VERA_INC_1 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora VERA_ADDRX_H
    sta VERA_ADDRX_H
    // >bsrc
    // [865] vera_cpy_bank_vram::$6 = > vera_cpy_bank_vram::bsrc#3 -- vwuz1=_hi_vduz2 
    lda.z bsrc+2
    sta.z __6
    lda.z bsrc+3
    sta.z __6+1
    // (>bsrc)<<8
    // [866] vera_cpy_bank_vram::$7 = vera_cpy_bank_vram::$6 << 8 -- vwuz1=vwuz1_rol_8 
    lda.z __7
    sta.z __7+1
    lda #0
    sta.z __7
    // <(>bsrc)<<8
    // [867] vera_cpy_bank_vram::$8 = < vera_cpy_bank_vram::$7 -- vbuyy=_lo_vwuz1 
    tay
    // <bsrc
    // [868] vera_cpy_bank_vram::$9 = < vera_cpy_bank_vram::bsrc#3 -- vwuz1=_lo_vduz2 
    lda.z bsrc
    sta.z __9
    lda.z bsrc+1
    sta.z __9+1
    // >(<bsrc)
    // [869] vera_cpy_bank_vram::$10 = > vera_cpy_bank_vram::$9 -- vbuxx=_hi_vwuz1 
    tax
    // ((word)<(>bsrc)<<8)|>(<bsrc)
    // [870] vera_cpy_bank_vram::$24 = (word)vera_cpy_bank_vram::$8 -- vwuz1=_word_vbuyy 
    tya
    sta.z __24
    sta.z __24+1
    // [871] vera_cpy_bank_vram::$11 = vera_cpy_bank_vram::$24 | vera_cpy_bank_vram::$10 -- vwuz1=vwuz1_bor_vbuxx 
    txa
    ora.z __11
    sta.z __11
    // (((word)<(>bsrc)<<8)|>(<bsrc))>>5
    // [872] vera_cpy_bank_vram::$12 = vera_cpy_bank_vram::$11 >> 5 -- vwuz1=vwuz1_ror_5 
    lsr.z __12+1
    ror.z __12
    lsr.z __12+1
    ror.z __12
    lsr.z __12+1
    ror.z __12
    lsr.z __12+1
    ror.z __12
    lsr.z __12+1
    ror.z __12
    // >bsrc
    // [873] vera_cpy_bank_vram::$13 = > vera_cpy_bank_vram::bsrc#3 -- vwuz1=_hi_vduz2 
    lda.z bsrc+2
    sta.z __13
    lda.z bsrc+3
    sta.z __13+1
    // (>bsrc)<<3
    // [874] vera_cpy_bank_vram::$14 = vera_cpy_bank_vram::$13 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z __14
    rol.z __14+1
    asl.z __14
    rol.z __14+1
    asl.z __14
    rol.z __14+1
    // <(>bsrc)<<3
    // [875] vera_cpy_bank_vram::$15 = < vera_cpy_bank_vram::$14 -- vbuaa=_lo_vwuz1 
    lda.z __14
    // ((((word)<(>bsrc)<<8)|>(<bsrc))>>5)+((word)<(>bsrc)<<3)
    // [876] vera_cpy_bank_vram::$25 = (word)vera_cpy_bank_vram::$15 -- vwuz1=_word_vbuaa 
    sta.z __25
    tya
    sta.z __25+1
    // [877] vera_cpy_bank_vram::$16 = vera_cpy_bank_vram::$12 + vera_cpy_bank_vram::$25 -- vwuz1=vwuz1_plus_vwuz2 
    lda.z __16
    clc
    adc.z __25
    sta.z __16
    lda.z __16+1
    adc.z __25+1
    sta.z __16+1
    // bank = (byte)(((((word)<(>bsrc)<<8)|>(<bsrc))>>5)+((word)<(>bsrc)<<3))
    // [878] vera_cpy_bank_vram::bank#0 = (byte)vera_cpy_bank_vram::$16 -- vbuz1=_byte_vwuz2 
    lda.z __16
    sta.z bank
    // <bsrc
    // [879] vera_cpy_bank_vram::$17 = < vera_cpy_bank_vram::bsrc#3 -- vwuz1=_lo_vduz2 
    lda.z bsrc
    sta.z __17
    lda.z bsrc+1
    sta.z __17+1
    // (<bsrc)&0x1FFF
    // [880] vera_cpy_bank_vram::addr#0 = vera_cpy_bank_vram::$17 & $1fff -- vwuz1=vwuz1_band_vwuc1 
    lda.z addr
    and #<$1fff
    sta.z addr
    lda.z addr+1
    and #>$1fff
    sta.z addr+1
    // addr += 0xA000
    // [881] vera_cpy_bank_vram::addr#1 = (byte*)vera_cpy_bank_vram::addr#0 + $a000 -- pbuz1=pbuz1_plus_vwuc1 
    // strip off the top 3 bits, which are representing the bank of the word!
    clc
    lda.z addr
    adc #<$a000
    sta.z addr
    lda.z addr+1
    adc #>$a000
    sta.z addr+1
    // cx16_ram_bank(bank)
    // [882] cx16_ram_bank::bank#3 = vera_cpy_bank_vram::bank#0 -- vbuxx=vbuz1 
    ldx.z bank
    // [883] call cx16_ram_bank 
    // [1249] phi from vera_cpy_bank_vram to cx16_ram_bank [phi:vera_cpy_bank_vram->cx16_ram_bank]
    // [1249] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#3 [phi:vera_cpy_bank_vram->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [884] phi from vera_cpy_bank_vram to vera_cpy_bank_vram::@1 [phi:vera_cpy_bank_vram->vera_cpy_bank_vram::@1]
    // [884] phi vera_cpy_bank_vram::bank#2 = vera_cpy_bank_vram::bank#0 [phi:vera_cpy_bank_vram->vera_cpy_bank_vram::@1#0] -- register_copy 
    // [884] phi vera_cpy_bank_vram::addr#4 = vera_cpy_bank_vram::addr#1 [phi:vera_cpy_bank_vram->vera_cpy_bank_vram::@1#1] -- register_copy 
    // [884] phi vera_cpy_bank_vram::i#2 = 0 [phi:vera_cpy_bank_vram->vera_cpy_bank_vram::@1#2] -- vduz1=vduc1 
    lda #<0
    sta.z i
    sta.z i+1
    lda #<0>>$10
    sta.z i+2
    lda #>0>>$10
    sta.z i+3
  // select the bank
    // vera_cpy_bank_vram::@1
  __b1:
    // for(dword i=0; i<num; i++)
    // [885] if(vera_cpy_bank_vram::i#2<vera_cpy_bank_vram::num#5) goto vera_cpy_bank_vram::@2 -- vduz1_lt_vduz2_then_la1 
    lda.z i+3
    cmp.z num+3
    bcc __b2
    bne !+
    lda.z i+2
    cmp.z num+2
    bcc __b2
    bne !+
    lda.z i+1
    cmp.z num+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z num
    bcc __b2
  !:
    // vera_cpy_bank_vram::@return
    // }
    // [886] return 
    rts
    // vera_cpy_bank_vram::@2
  __b2:
    // if(addr == 0xC000)
    // [887] if(vera_cpy_bank_vram::addr#4!=$c000) goto vera_cpy_bank_vram::@3 -- pbuz1_neq_vwuc1_then_la1 
    lda.z addr+1
    cmp #>$c000
    bne __b3
    lda.z addr
    cmp #<$c000
    bne __b3
    // vera_cpy_bank_vram::@4
    // bank++;
    // [888] vera_cpy_bank_vram::bank#1 = ++ vera_cpy_bank_vram::bank#2 -- vbuz1=_inc_vbuz1 
    inc.z bank
    // cx16_ram_bank(bank)
    // [889] cx16_ram_bank::bank#4 = vera_cpy_bank_vram::bank#1 -- vbuxx=vbuz1 
    ldx.z bank
    // [890] call cx16_ram_bank 
    // [1249] phi from vera_cpy_bank_vram::@4 to cx16_ram_bank [phi:vera_cpy_bank_vram::@4->cx16_ram_bank]
    // [1249] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#4 [phi:vera_cpy_bank_vram::@4->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [891] phi from vera_cpy_bank_vram::@4 to vera_cpy_bank_vram::@3 [phi:vera_cpy_bank_vram::@4->vera_cpy_bank_vram::@3]
    // [891] phi vera_cpy_bank_vram::bank#5 = vera_cpy_bank_vram::bank#1 [phi:vera_cpy_bank_vram::@4->vera_cpy_bank_vram::@3#0] -- register_copy 
    // [891] phi vera_cpy_bank_vram::addr#5 = (byte*) 40960 [phi:vera_cpy_bank_vram::@4->vera_cpy_bank_vram::@3#1] -- pbuz1=pbuc1 
    lda #<$a000
    sta.z addr
    lda #>$a000
    sta.z addr+1
    // [891] phi from vera_cpy_bank_vram::@2 to vera_cpy_bank_vram::@3 [phi:vera_cpy_bank_vram::@2->vera_cpy_bank_vram::@3]
    // [891] phi vera_cpy_bank_vram::bank#5 = vera_cpy_bank_vram::bank#2 [phi:vera_cpy_bank_vram::@2->vera_cpy_bank_vram::@3#0] -- register_copy 
    // [891] phi vera_cpy_bank_vram::addr#5 = vera_cpy_bank_vram::addr#4 [phi:vera_cpy_bank_vram::@2->vera_cpy_bank_vram::@3#1] -- register_copy 
    // vera_cpy_bank_vram::@3
  __b3:
    // *VERA_DATA0 = *addr
    // [892] *VERA_DATA0 = *vera_cpy_bank_vram::addr#5 -- _deref_pbuc1=_deref_pbuz1 
    ldy #0
    lda (addr),y
    sta VERA_DATA0
    // addr++;
    // [893] vera_cpy_bank_vram::addr#2 = ++ vera_cpy_bank_vram::addr#5 -- pbuz1=_inc_pbuz1 
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    // for(dword i=0; i<num; i++)
    // [894] vera_cpy_bank_vram::i#1 = ++ vera_cpy_bank_vram::i#2 -- vduz1=_inc_vduz1 
    inc.z i
    bne !+
    inc.z i+1
    bne !+
    inc.z i+2
    bne !+
    inc.z i+3
  !:
    // [884] phi from vera_cpy_bank_vram::@3 to vera_cpy_bank_vram::@1 [phi:vera_cpy_bank_vram::@3->vera_cpy_bank_vram::@1]
    // [884] phi vera_cpy_bank_vram::bank#2 = vera_cpy_bank_vram::bank#5 [phi:vera_cpy_bank_vram::@3->vera_cpy_bank_vram::@1#0] -- register_copy 
    // [884] phi vera_cpy_bank_vram::addr#4 = vera_cpy_bank_vram::addr#2 [phi:vera_cpy_bank_vram::@3->vera_cpy_bank_vram::@1#1] -- register_copy 
    // [884] phi vera_cpy_bank_vram::i#2 = vera_cpy_bank_vram::i#1 [phi:vera_cpy_bank_vram::@3->vera_cpy_bank_vram::@1#2] -- register_copy 
    jmp __b1
}
  // tile_background
tile_background: {
    .label __3 = $72
    .label c = $53
    .label r = $3c
    // [896] phi from tile_background to tile_background::@1 [phi:tile_background->tile_background::@1]
    // [896] phi rem16u#19 = 0 [phi:tile_background->tile_background::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z rem16u
    sta.z rem16u+1
    // [896] phi rand_state#18 = 1 [phi:tile_background->tile_background::@1#1] -- vwuz1=vwuc1 
    lda #<1
    sta.z rand_state
    lda #>1
    sta.z rand_state+1
    // [896] phi tile_background::r#2 = 5 [phi:tile_background->tile_background::@1#2] -- vbuz1=vbuc1 
    lda #5
    sta.z r
    // tile_background::@1
  __b1:
    // for(byte r=5;r<10;r+=1)
    // [897] if(tile_background::r#2<$a) goto tile_background::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z r
    cmp #$a
    bcc __b4
    // tile_background::@return
    // }
    // [898] return 
    rts
    // [899] phi from tile_background::@1 to tile_background::@2 [phi:tile_background::@1->tile_background::@2]
  __b4:
    // [899] phi rem16u#27 = rem16u#19 [phi:tile_background::@1->tile_background::@2#0] -- register_copy 
    // [899] phi rand_state#24 = rand_state#18 [phi:tile_background::@1->tile_background::@2#1] -- register_copy 
    // [899] phi tile_background::c#2 = 0 [phi:tile_background::@1->tile_background::@2#2] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // tile_background::@2
  __b2:
    // for(byte c=0;c<5;c+=1)
    // [900] if(tile_background::c#2<5) goto tile_background::@3 -- vbuz1_lt_vbuc1_then_la1 
    lda.z c
    cmp #5
    bcc __b3
    // tile_background::@4
    // r+=1
    // [901] tile_background::r#1 = tile_background::r#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z r
    // [896] phi from tile_background::@4 to tile_background::@1 [phi:tile_background::@4->tile_background::@1]
    // [896] phi rem16u#19 = rem16u#27 [phi:tile_background::@4->tile_background::@1#0] -- register_copy 
    // [896] phi rand_state#18 = rand_state#24 [phi:tile_background::@4->tile_background::@1#1] -- register_copy 
    // [896] phi tile_background::r#2 = tile_background::r#1 [phi:tile_background::@4->tile_background::@1#2] -- register_copy 
    jmp __b1
    // [902] phi from tile_background::@2 to tile_background::@3 [phi:tile_background::@2->tile_background::@3]
    // tile_background::@3
  __b3:
    // rand()
    // [903] call rand 
    // [365] phi from tile_background::@3 to rand [phi:tile_background::@3->rand]
    // [365] phi rand_state#13 = rand_state#24 [phi:tile_background::@3->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [904] rand::return#3 = rand::return#0
    // tile_background::@5
    // modr16u(rand(),3,0)
    // [905] modr16u::dividend#1 = rand::return#3
    // [906] call modr16u 
    // [374] phi from tile_background::@5 to modr16u [phi:tile_background::@5->modr16u]
    // [374] phi modr16u::dividend#2 = modr16u::dividend#1 [phi:tile_background::@5->modr16u#0] -- register_copy 
    jsr modr16u
    // modr16u(rand(),3,0)
    // [907] modr16u::return#3 = modr16u::return#0
    // tile_background::@6
    // [908] tile_background::$3 = modr16u::return#3 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z __3
    lda.z modr16u.return+1
    sta.z __3+1
    // rnd = (byte)modr16u(rand(),3,0)
    // [909] tile_background::rnd#0 = (byte)tile_background::$3 -- vbuaa=_byte_vwuz1 
    lda.z __3
    // vera_tile_element( 0, c, r, 3, TileDB[rnd])
    // [910] tile_background::$5 = tile_background::rnd#0 << 1 -- vbuxx=vbuaa_rol_1 
    asl
    tax
    // [911] vera_tile_element::x#2 = tile_background::c#2 -- vbuz1=vbuz2 
    lda.z c
    sta.z vera_tile_element.x
    // [912] vera_tile_element::y#2 = tile_background::r#2 -- vbuz1=vbuz2 
    lda.z r
    sta.z vera_tile_element.y
    // [913] vera_tile_element::Tile#1 = TileDB[tile_background::$5] -- pssz1=qssc1_derefidx_vbuxx 
    lda TileDB,x
    sta.z vera_tile_element.Tile
    lda TileDB+1,x
    sta.z vera_tile_element.Tile+1
    // [914] call vera_tile_element 
    // [379] phi from tile_background::@6 to vera_tile_element [phi:tile_background::@6->vera_tile_element]
    // [379] phi vera_tile_element::y#3 = vera_tile_element::y#2 [phi:tile_background::@6->vera_tile_element#0] -- register_copy 
    // [379] phi vera_tile_element::x#3 = vera_tile_element::x#2 [phi:tile_background::@6->vera_tile_element#1] -- register_copy 
    // [379] phi vera_tile_element::Tile#2 = vera_tile_element::Tile#1 [phi:tile_background::@6->vera_tile_element#2] -- register_copy 
    jsr vera_tile_element
    // tile_background::@7
    // c+=1
    // [915] tile_background::c#1 = tile_background::c#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z c
    // [899] phi from tile_background::@7 to tile_background::@2 [phi:tile_background::@7->tile_background::@2]
    // [899] phi rem16u#27 = divr16u::rem#10 [phi:tile_background::@7->tile_background::@2#0] -- register_copy 
    // [899] phi rand_state#24 = rand_state#14 [phi:tile_background::@7->tile_background::@2#1] -- register_copy 
    // [899] phi tile_background::c#2 = tile_background::c#1 [phi:tile_background::@7->tile_background::@2#2] -- register_copy 
    jmp __b2
}
  // create_sprite
// create_sprite(byte register(A) sprite)
create_sprite: {
    .label __5 = $a9
    .label __8 = $ab
    .label __22 = $72
    .label __33 = $a9
    .label __34 = $ab
    .label vera_sprite_bpp1_vera_sprite_4bpp1___4 = $72
    .label vera_sprite_bpp1_vera_sprite_4bpp1___7 = $72
    .label vera_sprite_bpp1_vera_sprite_8bpp1___4 = $74
    .label vera_sprite_bpp1_vera_sprite_8bpp1___7 = $74
    .label vera_sprite_address1___0 = $72
    .label vera_sprite_address1___4 = $74
    .label vera_sprite_address1___5 = $74
    .label vera_sprite_address1___7 = $72
    .label vera_sprite_address1___9 = $7a
    .label vera_sprite_address1___10 = $7b
    .label vera_sprite_address1___14 = $72
    .label vera_sprite_xy1___4 = $ad
    .label vera_sprite_xy1___10 = $ad
    .label vera_sprite_height1_vera_sprite_height_81___4 = $67
    .label vera_sprite_height1_vera_sprite_height_81___8 = $67
    .label vera_sprite_height1_vera_sprite_height_161___4 = $74
    .label vera_sprite_height1_vera_sprite_height_161___8 = $74
    .label vera_sprite_height1_vera_sprite_height_321___4 = $67
    .label vera_sprite_height1_vera_sprite_height_321___8 = $67
    .label vera_sprite_height1_vera_sprite_height_641___4 = $af
    .label vera_sprite_height1_vera_sprite_height_641___8 = $af
    .label vera_sprite_palette_offset1___4 = $c2
    .label vera_sprite_palette_offset1___8 = $c2
    .label Sprite = $65
    .label Offset = $6d
    .label vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset = $72
    .label vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset = $74
    .label vera_sprite_address1_address = $76
    .label vera_sprite_address1_sprite_offset = $72
    .label vera_sprite_xy1_x = $a9
    .label vera_sprite_xy1_y = $ab
    .label vera_sprite_xy1_sprite_offset = $ad
    .label vera_sprite_height1_vera_sprite_height_81_sprite_offset = $67
    .label vera_sprite_height1_vera_sprite_height_161_sprite_offset = $74
    .label vera_sprite_height1_vera_sprite_height_321_sprite_offset = $67
    .label vera_sprite_height1_vera_sprite_height_641_sprite_offset = $af
    .label vera_sprite_palette_offset1_palette_offset = $7f
    .label vera_sprite_palette_offset1_sprite_offset = $c2
    // Sprite = SpriteDB[sprite]
    // [917] create_sprite::$17 = create_sprite::sprite#2 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [918] create_sprite::Sprite#0 = SpriteDB[create_sprite::$17] -- pssz1=qssc1_derefidx_vbuaa 
    // Copy sprite palette to VRAM
    // Copy 8* sprite attributes to VRAM
    tay
    lda SpriteDB,y
    sta.z Sprite
    lda SpriteDB+1,y
    sta.z Sprite+1
    // [919] phi from create_sprite to create_sprite::@1 [phi:create_sprite->create_sprite::@1]
    // [919] phi create_sprite::s#10 = 0 [phi:create_sprite->create_sprite::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // create_sprite::@1
  __b1:
    // for(byte s=0;s<Sprite->SpriteCount;s++)
    // [920] if(create_sprite::s#10<((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_SPRITECOUNT]) goto create_sprite::@2 -- vbuxx_lt_pbuz1_derefidx_vbuc1_then_la1 
    ldy #OFFSET_STRUCT_SPRITE_SPRITECOUNT
    lda (Sprite),y
    sta.z $ff
    cpx.z $ff
    bcc __b2
    // create_sprite::@return
    // }
    // [921] return 
    rts
    // create_sprite::@2
  __b2:
    // Sprite->Offset+s
    // [922] create_sprite::Offset#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_OFFSET] + create_sprite::s#10 -- vbuz1=pbuz2_derefidx_vbuc1_plus_vbuxx 
    ldy #OFFSET_STRUCT_SPRITE_OFFSET
    txa
    clc
    adc (Sprite),y
    sta.z Offset
    // vera_sprite_bpp(Offset, Sprite->BPP)
    // [923] create_sprite::vera_sprite_bpp1_bpp#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_BPP] -- vbuaa=pbuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_BPP
    lda (Sprite),y
    // create_sprite::vera_sprite_bpp1
    // if(bpp==4)
    // [924] if(create_sprite::vera_sprite_bpp1_bpp#0==4) goto create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #4
    bne !vera_sprite_bpp1_vera_sprite_4bpp1+
    jmp vera_sprite_bpp1_vera_sprite_4bpp1
  !vera_sprite_bpp1_vera_sprite_4bpp1:
    // create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1
    // (word)sprite << 3
    // [925] create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$7 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_bpp1_vera_sprite_8bpp1___7
    lda #0
    sta.z vera_sprite_bpp1_vera_sprite_8bpp1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [926] create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset#0 = create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset
    rol.z vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset+1
    asl.z vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset
    rol.z vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset+1
    asl.z vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset
    rol.z vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [927] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+1
    // [928] create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$4 = create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset#0 + <VERA_SPRITE_ATTR+1 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_bpp1_vera_sprite_8bpp1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+1
    sta.z vera_sprite_bpp1_vera_sprite_8bpp1___4
    lda.z vera_sprite_bpp1_vera_sprite_8bpp1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+1
    sta.z vera_sprite_bpp1_vera_sprite_8bpp1___4+1
    // <sprite_offset+1
    // [929] create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$3 = < create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_bpp1_vera_sprite_8bpp1___4
    // *VERA_ADDRX_L = <sprite_offset+1
    // [930] *VERA_ADDRX_L = create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+1
    // [931] create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$5 = > create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_bpp1_vera_sprite_8bpp1___4+1
    // *VERA_ADDRX_M = >sprite_offset+1
    // [932] *VERA_ADDRX_M = create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [933] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 | >VERA_SPRITE_8BPP
    // [934] create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$6 = *VERA_DATA0 | >VERA_SPRITE_8BPP -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #>VERA_SPRITE_8BPP
    ora VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 | >VERA_SPRITE_8BPP
    // [935] *VERA_DATA0 = create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprite::@3
  __b3:
    // vera_sprite_address(Offset, Sprite->VRAM_Addresses[s])
    // [936] create_sprite::$18 = create_sprite::s#10 << 2 -- vbuyy=vbuxx_rol_2 
    txa
    asl
    asl
    tay
    // [937] create_sprite::$22 = (dword*)create_sprite::Sprite#0 + OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES -- pduz1=pduz2_plus_vbuc1 
    lda #OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES
    clc
    adc.z Sprite
    sta.z __22
    lda #0
    adc.z Sprite+1
    sta.z __22+1
    // [938] create_sprite::vera_sprite_address1_address#0 = create_sprite::$22[create_sprite::$18] -- vduz1=pduz2_derefidx_vbuyy 
    lda (__22),y
    sta.z vera_sprite_address1_address
    iny
    lda (__22),y
    sta.z vera_sprite_address1_address+1
    iny
    lda (__22),y
    sta.z vera_sprite_address1_address+2
    iny
    lda (__22),y
    sta.z vera_sprite_address1_address+3
    // create_sprite::vera_sprite_address1
    // (word)sprite << 3
    // [939] create_sprite::vera_sprite_address1_$14 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_address1___14
    lda #0
    sta.z vera_sprite_address1___14+1
    // [940] create_sprite::vera_sprite_address1_$0 = create_sprite::vera_sprite_address1_$14 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [941] create_sprite::vera_sprite_address1_sprite_offset#0 = <VERA_SPRITE_ATTR + create_sprite::vera_sprite_address1_$0 -- vwuz1=vwuc1_plus_vwuz1 
    clc
    lda.z vera_sprite_address1_sprite_offset
    adc #<VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset
    lda.z vera_sprite_address1_sprite_offset+1
    adc #>VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [942] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <sprite_offset
    // [943] create_sprite::vera_sprite_address1_$2 = < create_sprite::vera_sprite_address1_sprite_offset#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1_sprite_offset
    // *VERA_ADDRX_L = <sprite_offset
    // [944] *VERA_ADDRX_L = create_sprite::vera_sprite_address1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset
    // [945] create_sprite::vera_sprite_address1_$3 = > create_sprite::vera_sprite_address1_sprite_offset#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_address1_sprite_offset+1
    // *VERA_ADDRX_M = >sprite_offset
    // [946] *VERA_ADDRX_M = create_sprite::vera_sprite_address1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [947] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <address
    // [948] create_sprite::vera_sprite_address1_$4 = < create_sprite::vera_sprite_address1_address#0 -- vwuz1=_lo_vduz2 
    lda.z vera_sprite_address1_address
    sta.z vera_sprite_address1___4
    lda.z vera_sprite_address1_address+1
    sta.z vera_sprite_address1___4+1
    // (<address)>>5
    // [949] create_sprite::vera_sprite_address1_$5 = create_sprite::vera_sprite_address1_$4 >> 5 -- vwuz1=vwuz1_ror_5 
    lsr.z vera_sprite_address1___5+1
    ror.z vera_sprite_address1___5
    lsr.z vera_sprite_address1___5+1
    ror.z vera_sprite_address1___5
    lsr.z vera_sprite_address1___5+1
    ror.z vera_sprite_address1___5
    lsr.z vera_sprite_address1___5+1
    ror.z vera_sprite_address1___5
    lsr.z vera_sprite_address1___5+1
    ror.z vera_sprite_address1___5
    // <((<address)>>5)
    // [950] create_sprite::vera_sprite_address1_$6 = < create_sprite::vera_sprite_address1_$5 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1___5
    // *VERA_DATA0 = <((<address)>>5)
    // [951] *VERA_DATA0 = create_sprite::vera_sprite_address1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // <address
    // [952] create_sprite::vera_sprite_address1_$7 = < create_sprite::vera_sprite_address1_address#0 -- vwuz1=_lo_vduz2 
    lda.z vera_sprite_address1_address
    sta.z vera_sprite_address1___7
    lda.z vera_sprite_address1_address+1
    sta.z vera_sprite_address1___7+1
    // >(<address)
    // [953] create_sprite::vera_sprite_address1_$8 = > create_sprite::vera_sprite_address1_$7 -- vbuaa=_hi_vwuz1 
    // (>(<address))>>5
    // [954] create_sprite::vera_sprite_address1_$9 = create_sprite::vera_sprite_address1_$8 >> 5 -- vbuz1=vbuaa_ror_5 
    lsr
    lsr
    lsr
    lsr
    lsr
    sta.z vera_sprite_address1___9
    // >address
    // [955] create_sprite::vera_sprite_address1_$10 = > create_sprite::vera_sprite_address1_address#0 -- vwuz1=_hi_vduz2 
    lda.z vera_sprite_address1_address+2
    sta.z vera_sprite_address1___10
    lda.z vera_sprite_address1_address+3
    sta.z vera_sprite_address1___10+1
    // <(>address)
    // [956] create_sprite::vera_sprite_address1_$11 = < create_sprite::vera_sprite_address1_$10 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1___10
    // (<(>address))<<3
    // [957] create_sprite::vera_sprite_address1_$12 = create_sprite::vera_sprite_address1_$11 << 3 -- vbuaa=vbuaa_rol_3 
    asl
    asl
    asl
    // ((>(<address))>>5)|((<(>address))<<3)
    // [958] create_sprite::vera_sprite_address1_$13 = create_sprite::vera_sprite_address1_$9 | create_sprite::vera_sprite_address1_$12 -- vbuaa=vbuz1_bor_vbuaa 
    ora.z vera_sprite_address1___9
    // *VERA_DATA0 = ((>(<address))>>5)|((<(>address))<<3)
    // [959] *VERA_DATA0 = create_sprite::vera_sprite_address1_$13 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprite::@4
    // s&03
    // [960] create_sprite::$4 = create_sprite::s#10 & 3 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #3
    // (word)(s&03)<<6
    // [961] create_sprite::$33 = (word)create_sprite::$4 -- vwuz1=_word_vbuaa 
    sta.z __33
    lda #0
    sta.z __33+1
    // [962] create_sprite::$5 = create_sprite::$33 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z __5+1
    lsr
    sta.z $ff
    lda.z __5
    ror
    sta.z __5+1
    lda #0
    ror
    sta.z __5
    lsr.z $ff
    ror.z __5+1
    ror.z __5
    // vera_sprite_xy(Offset, 40+((word)(s&03)<<6), 100+((word)(s>>2)<<6))
    // [963] create_sprite::vera_sprite_xy1_x#0 = $28 + create_sprite::$5 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$28
    clc
    adc.z vera_sprite_xy1_x
    sta.z vera_sprite_xy1_x
    bcc !+
    inc.z vera_sprite_xy1_x+1
  !:
    // s>>2
    // [964] create_sprite::$7 = create_sprite::s#10 >> 2 -- vbuaa=vbuxx_ror_2 
    txa
    lsr
    lsr
    // (word)(s>>2)<<6
    // [965] create_sprite::$34 = (word)create_sprite::$7 -- vwuz1=_word_vbuaa 
    sta.z __34
    lda #0
    sta.z __34+1
    // [966] create_sprite::$8 = create_sprite::$34 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z __8+1
    lsr
    sta.z $ff
    lda.z __8
    ror
    sta.z __8+1
    lda #0
    ror
    sta.z __8
    lsr.z $ff
    ror.z __8+1
    ror.z __8
    // vera_sprite_xy(Offset, 40+((word)(s&03)<<6), 100+((word)(s>>2)<<6))
    // [967] create_sprite::vera_sprite_xy1_y#0 = $64 + create_sprite::$8 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$64
    clc
    adc.z vera_sprite_xy1_y
    sta.z vera_sprite_xy1_y
    bcc !+
    inc.z vera_sprite_xy1_y+1
  !:
    // create_sprite::vera_sprite_xy1
    // (word)sprite << 3
    // [968] create_sprite::vera_sprite_xy1_$10 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_xy1___10
    lda #0
    sta.z vera_sprite_xy1___10+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [969] create_sprite::vera_sprite_xy1_sprite_offset#0 = create_sprite::vera_sprite_xy1_$10 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [970] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+2
    // [971] create_sprite::vera_sprite_xy1_$4 = create_sprite::vera_sprite_xy1_sprite_offset#0 + <VERA_SPRITE_ATTR+2 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_xy1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4
    lda.z vera_sprite_xy1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4+1
    // <sprite_offset+2
    // [972] create_sprite::vera_sprite_xy1_$3 = < create_sprite::vera_sprite_xy1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1___4
    // *VERA_ADDRX_L = <sprite_offset+2
    // [973] *VERA_ADDRX_L = create_sprite::vera_sprite_xy1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+2
    // [974] create_sprite::vera_sprite_xy1_$5 = > create_sprite::vera_sprite_xy1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1___4+1
    // *VERA_ADDRX_M = >sprite_offset+2
    // [975] *VERA_ADDRX_M = create_sprite::vera_sprite_xy1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [976] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <x
    // [977] create_sprite::vera_sprite_xy1_$6 = < create_sprite::vera_sprite_xy1_x#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1_x
    // *VERA_DATA0 = <x
    // [978] *VERA_DATA0 = create_sprite::vera_sprite_xy1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // >x
    // [979] create_sprite::vera_sprite_xy1_$7 = > create_sprite::vera_sprite_xy1_x#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1_x+1
    // *VERA_DATA0 = >x
    // [980] *VERA_DATA0 = create_sprite::vera_sprite_xy1_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // <y
    // [981] create_sprite::vera_sprite_xy1_$8 = < create_sprite::vera_sprite_xy1_y#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1_y
    // *VERA_DATA0 = <y
    // [982] *VERA_DATA0 = create_sprite::vera_sprite_xy1_$8 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // >y
    // [983] create_sprite::vera_sprite_xy1_$9 = > create_sprite::vera_sprite_xy1_y#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1_y+1
    // *VERA_DATA0 = >y
    // [984] *VERA_DATA0 = create_sprite::vera_sprite_xy1_$9 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprite::@5
    // vera_sprite_height(Offset, Sprite->Height)
    // [985] create_sprite::vera_sprite_height1_height#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_HEIGHT] -- vbuaa=pbuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_HEIGHT
    lda (Sprite),y
    // create_sprite::vera_sprite_height1
    // case 8:
    //             vera_sprite_height_8(sprite);
    //             break;
    // [986] if(create_sprite::vera_sprite_height1_height#0==8) goto create_sprite::vera_sprite_height1_vera_sprite_height_81 -- vbuaa_eq_vbuc1_then_la1 
    cmp #8
    bne !vera_sprite_height1_vera_sprite_height_81+
    jmp vera_sprite_height1_vera_sprite_height_81
  !vera_sprite_height1_vera_sprite_height_81:
    // create_sprite::vera_sprite_height1_@1
    // case 16:
    //             vera_sprite_height_16(sprite);
    //             break;
    // [987] if(create_sprite::vera_sprite_height1_height#0==$10) goto create_sprite::vera_sprite_height1_vera_sprite_height_161 -- vbuaa_eq_vbuc1_then_la1 
    cmp #$10
    bne !vera_sprite_height1_vera_sprite_height_161+
    jmp vera_sprite_height1_vera_sprite_height_161
  !vera_sprite_height1_vera_sprite_height_161:
    // create_sprite::vera_sprite_height1_@2
    // case 32:
    //             vera_sprite_height_32(sprite);
    //             break;
    // [988] if(create_sprite::vera_sprite_height1_height#0==$20) goto create_sprite::vera_sprite_height1_vera_sprite_height_321 -- vbuaa_eq_vbuc1_then_la1 
    cmp #$20
    bne !vera_sprite_height1_vera_sprite_height_321+
    jmp vera_sprite_height1_vera_sprite_height_321
  !vera_sprite_height1_vera_sprite_height_321:
    // create_sprite::vera_sprite_height1_@3
    // case 64:
    //             vera_sprite_height_64(sprite);
    //             break;
    // [989] if(create_sprite::vera_sprite_height1_height#0==$40) goto create_sprite::vera_sprite_height1_vera_sprite_height_641 -- vbuaa_eq_vbuc1_then_la1 
    cmp #$40
    beq vera_sprite_height1_vera_sprite_height_641
    jmp __b6
    // create_sprite::vera_sprite_height1_vera_sprite_height_641
  vera_sprite_height1_vera_sprite_height_641:
    // (word)sprite << 3
    // [990] create_sprite::vera_sprite_height1_vera_sprite_height_641_$8 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_height1_vera_sprite_height_641___8
    lda #0
    sta.z vera_sprite_height1_vera_sprite_height_641___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [991] create_sprite::vera_sprite_height1_vera_sprite_height_641_sprite_offset#0 = create_sprite::vera_sprite_height1_vera_sprite_height_641_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_height1_vera_sprite_height_641_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_641_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_641_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_641_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_641_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_641_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [992] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [993] create_sprite::vera_sprite_height1_vera_sprite_height_641_$4 = create_sprite::vera_sprite_height1_vera_sprite_height_641_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_height1_vera_sprite_height_641___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_641___4
    lda.z vera_sprite_height1_vera_sprite_height_641___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_641___4+1
    // <sprite_offset+7
    // [994] create_sprite::vera_sprite_height1_vera_sprite_height_641_$3 = < create_sprite::vera_sprite_height1_vera_sprite_height_641_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_height1_vera_sprite_height_641___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [995] *VERA_ADDRX_L = create_sprite::vera_sprite_height1_vera_sprite_height_641_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [996] create_sprite::vera_sprite_height1_vera_sprite_height_641_$5 = > create_sprite::vera_sprite_height1_vera_sprite_height_641_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_height1_vera_sprite_height_641___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [997] *VERA_ADDRX_M = create_sprite::vera_sprite_height1_vera_sprite_height_641_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [998] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [999] create_sprite::vera_sprite_height1_vera_sprite_height_641_$6 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HEIGHT_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_64
    // [1000] create_sprite::vera_sprite_height1_vera_sprite_height_641_$7 = create_sprite::vera_sprite_height1_vera_sprite_height_641_$6 | VERA_SPRITE_HEIGHT_64 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_HEIGHT_64
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_64
    // [1001] *VERA_DATA0 = create_sprite::vera_sprite_height1_vera_sprite_height_641_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprite::@6
  __b6:
    // vera_sprite_width(Offset, Sprite->Width)
    // [1002] vera_sprite_width::sprite#0 = create_sprite::Offset#0 -- vbuz1=vbuz2 
    lda.z Offset
    sta.z vera_sprite_width.sprite
    // [1003] vera_sprite_width::width#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_WIDTH] -- vbuaa=pbuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_WIDTH
    lda (Sprite),y
    // [1004] call vera_sprite_width 
    jsr vera_sprite_width
    // create_sprite::@8
    // vera_sprite_zdepth(Offset, Sprite->Zdepth)
    // [1005] vera_sprite_zdepth::sprite#0 = create_sprite::Offset#0 -- vbuz1=vbuz2 
    lda.z Offset
    sta.z vera_sprite_zdepth.sprite
    // [1006] vera_sprite_zdepth::zdepth#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_ZDEPTH] -- vbuaa=pbuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_ZDEPTH
    lda (Sprite),y
    // [1007] call vera_sprite_zdepth 
    jsr vera_sprite_zdepth
    // create_sprite::@9
    // vera_sprite_hflip(Offset, Sprite->Hflip)
    // [1008] vera_sprite_hflip::sprite#0 = create_sprite::Offset#0 -- vbuz1=vbuz2 
    lda.z Offset
    sta.z vera_sprite_hflip.sprite
    // [1009] vera_sprite_hflip::hflip#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_HFLIP] -- vbuaa=pbuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_HFLIP
    lda (Sprite),y
    // [1010] call vera_sprite_hflip 
    jsr vera_sprite_hflip
    // create_sprite::@10
    // vera_sprite_vflip(Offset, Sprite->Vflip)
    // [1011] vera_sprite_vflip::sprite#0 = create_sprite::Offset#0 -- vbuz1=vbuz2 
    lda.z Offset
    sta.z vera_sprite_vflip.sprite
    // [1012] vera_sprite_vflip::vflip#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_VFLIP] -- vbuaa=pbuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_VFLIP
    lda (Sprite),y
    // [1013] call vera_sprite_vflip 
    jsr vera_sprite_vflip
    // create_sprite::@11
    // vera_sprite_palette_offset(Offset, Sprite->Palette)
    // [1014] create_sprite::vera_sprite_palette_offset1_palette_offset#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_PALETTE] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_PALETTE
    lda (Sprite),y
    sta.z vera_sprite_palette_offset1_palette_offset
    // create_sprite::vera_sprite_palette_offset1
    // (word)sprite << 3
    // [1015] create_sprite::vera_sprite_palette_offset1_$8 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_palette_offset1___8
    lda #0
    sta.z vera_sprite_palette_offset1___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1016] create_sprite::vera_sprite_palette_offset1_sprite_offset#0 = create_sprite::vera_sprite_palette_offset1_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_palette_offset1_sprite_offset
    rol.z vera_sprite_palette_offset1_sprite_offset+1
    asl.z vera_sprite_palette_offset1_sprite_offset
    rol.z vera_sprite_palette_offset1_sprite_offset+1
    asl.z vera_sprite_palette_offset1_sprite_offset
    rol.z vera_sprite_palette_offset1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1017] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1018] create_sprite::vera_sprite_palette_offset1_$4 = create_sprite::vera_sprite_palette_offset1_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_palette_offset1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_palette_offset1___4
    lda.z vera_sprite_palette_offset1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_palette_offset1___4+1
    // <sprite_offset+7
    // [1019] create_sprite::vera_sprite_palette_offset1_$3 = < create_sprite::vera_sprite_palette_offset1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_palette_offset1___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1020] *VERA_ADDRX_L = create_sprite::vera_sprite_palette_offset1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1021] create_sprite::vera_sprite_palette_offset1_$5 = > create_sprite::vera_sprite_palette_offset1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_palette_offset1___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1022] *VERA_ADDRX_M = create_sprite::vera_sprite_palette_offset1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1023] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK
    // [1024] create_sprite::vera_sprite_palette_offset1_$6 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_PALETTE_OFFSET_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK | palette_offset
    // [1025] create_sprite::vera_sprite_palette_offset1_$7 = create_sprite::vera_sprite_palette_offset1_$6 | create_sprite::vera_sprite_palette_offset1_palette_offset#0 -- vbuaa=vbuaa_bor_vbuz1 
    ora.z vera_sprite_palette_offset1_palette_offset
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK | palette_offset
    // [1026] *VERA_DATA0 = create_sprite::vera_sprite_palette_offset1_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprite::@7
    // for(byte s=0;s<Sprite->SpriteCount;s++)
    // [1027] create_sprite::s#1 = ++ create_sprite::s#10 -- vbuxx=_inc_vbuxx 
    inx
    // [919] phi from create_sprite::@7 to create_sprite::@1 [phi:create_sprite::@7->create_sprite::@1]
    // [919] phi create_sprite::s#10 = create_sprite::s#1 [phi:create_sprite::@7->create_sprite::@1#0] -- register_copy 
    jmp __b1
    // create_sprite::vera_sprite_height1_vera_sprite_height_321
  vera_sprite_height1_vera_sprite_height_321:
    // (word)sprite << 3
    // [1028] create_sprite::vera_sprite_height1_vera_sprite_height_321_$8 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_height1_vera_sprite_height_321___8
    lda #0
    sta.z vera_sprite_height1_vera_sprite_height_321___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1029] create_sprite::vera_sprite_height1_vera_sprite_height_321_sprite_offset#0 = create_sprite::vera_sprite_height1_vera_sprite_height_321_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_height1_vera_sprite_height_321_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_321_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_321_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_321_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_321_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_321_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1030] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1031] create_sprite::vera_sprite_height1_vera_sprite_height_321_$4 = create_sprite::vera_sprite_height1_vera_sprite_height_321_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_height1_vera_sprite_height_321___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_321___4
    lda.z vera_sprite_height1_vera_sprite_height_321___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_321___4+1
    // <sprite_offset+7
    // [1032] create_sprite::vera_sprite_height1_vera_sprite_height_321_$3 = < create_sprite::vera_sprite_height1_vera_sprite_height_321_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_height1_vera_sprite_height_321___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1033] *VERA_ADDRX_L = create_sprite::vera_sprite_height1_vera_sprite_height_321_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1034] create_sprite::vera_sprite_height1_vera_sprite_height_321_$5 = > create_sprite::vera_sprite_height1_vera_sprite_height_321_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_height1_vera_sprite_height_321___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1035] *VERA_ADDRX_M = create_sprite::vera_sprite_height1_vera_sprite_height_321_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1036] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [1037] create_sprite::vera_sprite_height1_vera_sprite_height_321_$6 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HEIGHT_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_32
    // [1038] create_sprite::vera_sprite_height1_vera_sprite_height_321_$7 = create_sprite::vera_sprite_height1_vera_sprite_height_321_$6 | VERA_SPRITE_HEIGHT_32 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_HEIGHT_32
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_32
    // [1039] *VERA_DATA0 = create_sprite::vera_sprite_height1_vera_sprite_height_321_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    jmp __b6
    // create_sprite::vera_sprite_height1_vera_sprite_height_161
  vera_sprite_height1_vera_sprite_height_161:
    // (word)sprite << 3
    // [1040] create_sprite::vera_sprite_height1_vera_sprite_height_161_$8 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_height1_vera_sprite_height_161___8
    lda #0
    sta.z vera_sprite_height1_vera_sprite_height_161___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1041] create_sprite::vera_sprite_height1_vera_sprite_height_161_sprite_offset#0 = create_sprite::vera_sprite_height1_vera_sprite_height_161_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_height1_vera_sprite_height_161_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_161_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_161_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_161_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_161_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_161_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1042] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1043] create_sprite::vera_sprite_height1_vera_sprite_height_161_$4 = create_sprite::vera_sprite_height1_vera_sprite_height_161_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_height1_vera_sprite_height_161___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_161___4
    lda.z vera_sprite_height1_vera_sprite_height_161___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_161___4+1
    // <sprite_offset+7
    // [1044] create_sprite::vera_sprite_height1_vera_sprite_height_161_$3 = < create_sprite::vera_sprite_height1_vera_sprite_height_161_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_height1_vera_sprite_height_161___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1045] *VERA_ADDRX_L = create_sprite::vera_sprite_height1_vera_sprite_height_161_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1046] create_sprite::vera_sprite_height1_vera_sprite_height_161_$5 = > create_sprite::vera_sprite_height1_vera_sprite_height_161_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_height1_vera_sprite_height_161___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1047] *VERA_ADDRX_M = create_sprite::vera_sprite_height1_vera_sprite_height_161_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1048] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [1049] create_sprite::vera_sprite_height1_vera_sprite_height_161_$6 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HEIGHT_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_16
    // [1050] create_sprite::vera_sprite_height1_vera_sprite_height_161_$7 = create_sprite::vera_sprite_height1_vera_sprite_height_161_$6 | VERA_SPRITE_HEIGHT_16 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_HEIGHT_16
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_16
    // [1051] *VERA_DATA0 = create_sprite::vera_sprite_height1_vera_sprite_height_161_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    jmp __b6
    // create_sprite::vera_sprite_height1_vera_sprite_height_81
  vera_sprite_height1_vera_sprite_height_81:
    // (word)sprite << 3
    // [1052] create_sprite::vera_sprite_height1_vera_sprite_height_81_$8 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_height1_vera_sprite_height_81___8
    lda #0
    sta.z vera_sprite_height1_vera_sprite_height_81___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1053] create_sprite::vera_sprite_height1_vera_sprite_height_81_sprite_offset#0 = create_sprite::vera_sprite_height1_vera_sprite_height_81_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_height1_vera_sprite_height_81_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_81_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_81_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_81_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_81_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_81_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1054] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1055] create_sprite::vera_sprite_height1_vera_sprite_height_81_$4 = create_sprite::vera_sprite_height1_vera_sprite_height_81_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_height1_vera_sprite_height_81___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_81___4
    lda.z vera_sprite_height1_vera_sprite_height_81___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_81___4+1
    // <sprite_offset+7
    // [1056] create_sprite::vera_sprite_height1_vera_sprite_height_81_$3 = < create_sprite::vera_sprite_height1_vera_sprite_height_81_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_height1_vera_sprite_height_81___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1057] *VERA_ADDRX_L = create_sprite::vera_sprite_height1_vera_sprite_height_81_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1058] create_sprite::vera_sprite_height1_vera_sprite_height_81_$5 = > create_sprite::vera_sprite_height1_vera_sprite_height_81_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_height1_vera_sprite_height_81___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1059] *VERA_ADDRX_M = create_sprite::vera_sprite_height1_vera_sprite_height_81_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1060] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_8
    // [1061] create_sprite::vera_sprite_height1_vera_sprite_height_81_$7 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HEIGHT_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_8
    // [1062] *VERA_DATA0 = create_sprite::vera_sprite_height1_vera_sprite_height_81_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    jmp __b6
    // create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1
  vera_sprite_bpp1_vera_sprite_4bpp1:
    // (word)sprite << 3
    // [1063] create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$7 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_bpp1_vera_sprite_4bpp1___7
    lda #0
    sta.z vera_sprite_bpp1_vera_sprite_4bpp1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1064] create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset#0 = create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset
    rol.z vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset+1
    asl.z vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset
    rol.z vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset+1
    asl.z vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset
    rol.z vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1065] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+1
    // [1066] create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$4 = create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset#0 + <VERA_SPRITE_ATTR+1 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_bpp1_vera_sprite_4bpp1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+1
    sta.z vera_sprite_bpp1_vera_sprite_4bpp1___4
    lda.z vera_sprite_bpp1_vera_sprite_4bpp1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+1
    sta.z vera_sprite_bpp1_vera_sprite_4bpp1___4+1
    // <sprite_offset+1
    // [1067] create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$3 = < create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_bpp1_vera_sprite_4bpp1___4
    // *VERA_ADDRX_L = <sprite_offset+1
    // [1068] *VERA_ADDRX_L = create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+1
    // [1069] create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$5 = > create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_bpp1_vera_sprite_4bpp1___4+1
    // *VERA_ADDRX_M = >sprite_offset+1
    // [1070] *VERA_ADDRX_M = create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1071] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~>VERA_SPRITE_8BPP
    // [1072] create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$6 = *VERA_DATA0 & ~>VERA_SPRITE_8BPP -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #(>VERA_SPRITE_8BPP)^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~>VERA_SPRITE_8BPP
    // [1073] *VERA_DATA0 = create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    jmp __b3
}
  // show_memory_map
show_memory_map: {
    .label __17 = $af
    .label __19 = $ab
    .label Sprite = $ad
    .label j = $7f
    .label i = $7a
    .label Tile = $a9
    .label j1 = $7e
    .label i1 = $7d
    // [1075] phi from show_memory_map to show_memory_map::@1 [phi:show_memory_map->show_memory_map::@1]
    // [1075] phi show_memory_map::i#10 = 0 [phi:show_memory_map->show_memory_map::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // show_memory_map::@1
  __b1:
    // for(byte i=0;i<2;i++)
    // [1076] if(show_memory_map::i#10<2) goto show_memory_map::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z i
    cmp #2
    bcs !__b2+
    jmp __b2
  !__b2:
    // [1077] phi from show_memory_map::@1 to show_memory_map::@6 [phi:show_memory_map::@1->show_memory_map::@6]
    // [1077] phi show_memory_map::i1#10 = 0 [phi:show_memory_map::@1->show_memory_map::@6#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i1
    // show_memory_map::@6
  __b6:
    // for(byte i=0;i<3;i++)
    // [1078] if(show_memory_map::i1#10<3) goto show_memory_map::@7 -- vbuz1_lt_vbuc1_then_la1 
    lda.z i1
    cmp #3
    bcc __b7
    // show_memory_map::@return
    // }
    // [1079] return 
    rts
    // show_memory_map::@7
  __b7:
    // Tile = TileDB[i]
    // [1080] show_memory_map::$14 = show_memory_map::i1#10 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z i1
    asl
    // [1081] show_memory_map::Tile#0 = TileDB[show_memory_map::$14] -- pssz1=qssc1_derefidx_vbuaa 
    tay
    lda TileDB,y
    sta.z Tile
    lda TileDB+1,y
    sta.z Tile+1
    // gotoxy(0, 4+i)
    // [1082] gotoxy::y#6 = 4 + show_memory_map::i1#10 -- vbuxx=vbuc1_plus_vbuz1 
    lda #4
    clc
    adc.z i1
    tax
    // [1083] call gotoxy 
    // [330] phi from show_memory_map::@7 to gotoxy [phi:show_memory_map::@7->gotoxy]
    // [330] phi gotoxy::y#7 = gotoxy::y#6 [phi:show_memory_map::@7->gotoxy#0] -- register_copy 
    jsr gotoxy
    // [1084] phi from show_memory_map::@7 to show_memory_map::@18 [phi:show_memory_map::@7->show_memory_map::@18]
    // show_memory_map::@18
    // printf("t:%u bram:%x, vram:", i, Tile->BRAM_Address)
    // [1085] call cputs 
    // [343] phi from show_memory_map::@18 to cputs [phi:show_memory_map::@18->cputs]
    // [343] phi cputs::s#26 = show_memory_map::s4 [phi:show_memory_map::@18->cputs#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // show_memory_map::@19
    // printf("t:%u bram:%x, vram:", i, Tile->BRAM_Address)
    // [1086] printf_uchar::uvalue#1 = show_memory_map::i1#10 -- vbuxx=vbuz1 
    ldx.z i1
    // [1087] call printf_uchar 
    // [596] phi from show_memory_map::@19 to printf_uchar [phi:show_memory_map::@19->printf_uchar]
    // [596] phi printf_uchar::format_radix#5 = DECIMAL [phi:show_memory_map::@19->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #DECIMAL
    // [596] phi printf_uchar::uvalue#5 = printf_uchar::uvalue#1 [phi:show_memory_map::@19->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [1088] phi from show_memory_map::@19 to show_memory_map::@20 [phi:show_memory_map::@19->show_memory_map::@20]
    // show_memory_map::@20
    // printf("t:%u bram:%x, vram:", i, Tile->BRAM_Address)
    // [1089] call cputs 
    // [343] phi from show_memory_map::@20 to cputs [phi:show_memory_map::@20->cputs]
    // [343] phi cputs::s#26 = show_memory_map::s1 [phi:show_memory_map::@20->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // show_memory_map::@21
    // printf("t:%u bram:%x, vram:", i, Tile->BRAM_Address)
    // [1090] printf_ulong::uvalue#5 = ((dword*)show_memory_map::Tile#0)[OFFSET_STRUCT_TILE_BRAM_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_BRAM_ADDRESS
    lda (Tile),y
    sta.z printf_ulong.uvalue
    iny
    lda (Tile),y
    sta.z printf_ulong.uvalue+1
    iny
    lda (Tile),y
    sta.z printf_ulong.uvalue+2
    iny
    lda (Tile),y
    sta.z printf_ulong.uvalue+3
    // [1091] call printf_ulong 
    // [351] phi from show_memory_map::@21 to printf_ulong [phi:show_memory_map::@21->printf_ulong]
    // [351] phi printf_ulong::uvalue#10 = printf_ulong::uvalue#5 [phi:show_memory_map::@21->printf_ulong#0] -- register_copy 
    jsr printf_ulong
    // [1092] phi from show_memory_map::@21 to show_memory_map::@22 [phi:show_memory_map::@21->show_memory_map::@22]
    // show_memory_map::@22
    // printf("t:%u bram:%x, vram:", i, Tile->BRAM_Address)
    // [1093] call cputs 
    // [343] phi from show_memory_map::@22 to cputs [phi:show_memory_map::@22->cputs]
    // [343] phi cputs::s#26 = show_memory_map::s2 [phi:show_memory_map::@22->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // [1094] phi from show_memory_map::@22 to show_memory_map::@8 [phi:show_memory_map::@22->show_memory_map::@8]
    // [1094] phi show_memory_map::j1#2 = 0 [phi:show_memory_map::@22->show_memory_map::@8#0] -- vbuz1=vbuc1 
    lda #0
    sta.z j1
    // show_memory_map::@8
  __b8:
    // for(byte j=0;j<4;j++)
    // [1095] if(show_memory_map::j1#2<4) goto show_memory_map::@9 -- vbuz1_lt_vbuc1_then_la1 
    lda.z j1
    cmp #4
    bcc __b9
    // show_memory_map::@10
    // for(byte i=0;i<3;i++)
    // [1096] show_memory_map::i1#1 = ++ show_memory_map::i1#10 -- vbuz1=_inc_vbuz1 
    inc.z i1
    // [1077] phi from show_memory_map::@10 to show_memory_map::@6 [phi:show_memory_map::@10->show_memory_map::@6]
    // [1077] phi show_memory_map::i1#10 = show_memory_map::i1#1 [phi:show_memory_map::@10->show_memory_map::@6#0] -- register_copy 
    jmp __b6
    // show_memory_map::@9
  __b9:
    // printf("%x ", Tile->VRAM_Addresses[j])
    // [1097] show_memory_map::$15 = show_memory_map::j1#2 << 2 -- vbuyy=vbuz1_rol_2 
    lda.z j1
    asl
    asl
    tay
    // [1098] show_memory_map::$19 = (dword*)show_memory_map::Tile#0 + OFFSET_STRUCT_TILE_VRAM_ADDRESSES -- pduz1=pduz2_plus_vbuc1 
    lda #OFFSET_STRUCT_TILE_VRAM_ADDRESSES
    clc
    adc.z Tile
    sta.z __19
    lda #0
    adc.z Tile+1
    sta.z __19+1
    // [1099] printf_ulong::uvalue#6 = show_memory_map::$19[show_memory_map::$15] -- vduz1=pduz2_derefidx_vbuyy 
    lda (__19),y
    sta.z printf_ulong.uvalue
    iny
    lda (__19),y
    sta.z printf_ulong.uvalue+1
    iny
    lda (__19),y
    sta.z printf_ulong.uvalue+2
    iny
    lda (__19),y
    sta.z printf_ulong.uvalue+3
    // [1100] call printf_ulong 
    // [351] phi from show_memory_map::@9 to printf_ulong [phi:show_memory_map::@9->printf_ulong]
    // [351] phi printf_ulong::uvalue#10 = printf_ulong::uvalue#6 [phi:show_memory_map::@9->printf_ulong#0] -- register_copy 
    jsr printf_ulong
    // [1101] phi from show_memory_map::@9 to show_memory_map::@23 [phi:show_memory_map::@9->show_memory_map::@23]
    // show_memory_map::@23
    // printf("%x ", Tile->VRAM_Addresses[j])
    // [1102] call cputs 
    // [343] phi from show_memory_map::@23 to cputs [phi:show_memory_map::@23->cputs]
    // [343] phi cputs::s#26 = show_memory_map::s3 [phi:show_memory_map::@23->cputs#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // show_memory_map::@24
    // for(byte j=0;j<4;j++)
    // [1103] show_memory_map::j1#1 = ++ show_memory_map::j1#2 -- vbuz1=_inc_vbuz1 
    inc.z j1
    // [1094] phi from show_memory_map::@24 to show_memory_map::@8 [phi:show_memory_map::@24->show_memory_map::@8]
    // [1094] phi show_memory_map::j1#2 = show_memory_map::j1#1 [phi:show_memory_map::@24->show_memory_map::@8#0] -- register_copy 
    jmp __b8
    // show_memory_map::@2
  __b2:
    // Sprite = SpriteDB[i]
    // [1104] show_memory_map::$12 = show_memory_map::i#10 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z i
    asl
    // [1105] show_memory_map::Sprite#0 = SpriteDB[show_memory_map::$12] -- pssz1=qssc1_derefidx_vbuaa 
    tay
    lda SpriteDB,y
    sta.z Sprite
    lda SpriteDB+1,y
    sta.z Sprite+1
    // gotoxy(0, 1+i)
    // [1106] gotoxy::y#5 = 1 + show_memory_map::i#10 -- vbuxx=vbuc1_plus_vbuz1 
    lda #1
    clc
    adc.z i
    tax
    // [1107] call gotoxy 
    // [330] phi from show_memory_map::@2 to gotoxy [phi:show_memory_map::@2->gotoxy]
    // [330] phi gotoxy::y#7 = gotoxy::y#5 [phi:show_memory_map::@2->gotoxy#0] -- register_copy 
    jsr gotoxy
    // [1108] phi from show_memory_map::@2 to show_memory_map::@11 [phi:show_memory_map::@2->show_memory_map::@11]
    // show_memory_map::@11
    // printf("s:%u bram:%x, vram:", i, Sprite->BRAM_Address)
    // [1109] call cputs 
    // [343] phi from show_memory_map::@11 to cputs [phi:show_memory_map::@11->cputs]
    // [343] phi cputs::s#26 = show_memory_map::s [phi:show_memory_map::@11->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // show_memory_map::@12
    // printf("s:%u bram:%x, vram:", i, Sprite->BRAM_Address)
    // [1110] printf_uchar::uvalue#0 = show_memory_map::i#10 -- vbuxx=vbuz1 
    ldx.z i
    // [1111] call printf_uchar 
    // [596] phi from show_memory_map::@12 to printf_uchar [phi:show_memory_map::@12->printf_uchar]
    // [596] phi printf_uchar::format_radix#5 = DECIMAL [phi:show_memory_map::@12->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #DECIMAL
    // [596] phi printf_uchar::uvalue#5 = printf_uchar::uvalue#0 [phi:show_memory_map::@12->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [1112] phi from show_memory_map::@12 to show_memory_map::@13 [phi:show_memory_map::@12->show_memory_map::@13]
    // show_memory_map::@13
    // printf("s:%u bram:%x, vram:", i, Sprite->BRAM_Address)
    // [1113] call cputs 
    // [343] phi from show_memory_map::@13 to cputs [phi:show_memory_map::@13->cputs]
    // [343] phi cputs::s#26 = show_memory_map::s1 [phi:show_memory_map::@13->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // show_memory_map::@14
    // printf("s:%u bram:%x, vram:", i, Sprite->BRAM_Address)
    // [1114] printf_ulong::uvalue#3 = ((dword*)show_memory_map::Sprite#0)[OFFSET_STRUCT_SPRITE_BRAM_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_BRAM_ADDRESS
    lda (Sprite),y
    sta.z printf_ulong.uvalue
    iny
    lda (Sprite),y
    sta.z printf_ulong.uvalue+1
    iny
    lda (Sprite),y
    sta.z printf_ulong.uvalue+2
    iny
    lda (Sprite),y
    sta.z printf_ulong.uvalue+3
    // [1115] call printf_ulong 
    // [351] phi from show_memory_map::@14 to printf_ulong [phi:show_memory_map::@14->printf_ulong]
    // [351] phi printf_ulong::uvalue#10 = printf_ulong::uvalue#3 [phi:show_memory_map::@14->printf_ulong#0] -- register_copy 
    jsr printf_ulong
    // [1116] phi from show_memory_map::@14 to show_memory_map::@15 [phi:show_memory_map::@14->show_memory_map::@15]
    // show_memory_map::@15
    // printf("s:%u bram:%x, vram:", i, Sprite->BRAM_Address)
    // [1117] call cputs 
    // [343] phi from show_memory_map::@15 to cputs [phi:show_memory_map::@15->cputs]
    // [343] phi cputs::s#26 = show_memory_map::s2 [phi:show_memory_map::@15->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // [1118] phi from show_memory_map::@15 to show_memory_map::@3 [phi:show_memory_map::@15->show_memory_map::@3]
    // [1118] phi show_memory_map::j#2 = 0 [phi:show_memory_map::@15->show_memory_map::@3#0] -- vbuz1=vbuc1 
    lda #0
    sta.z j
    // show_memory_map::@3
  __b3:
    // for(byte j=0;j<12;j++)
    // [1119] if(show_memory_map::j#2<$c) goto show_memory_map::@4 -- vbuz1_lt_vbuc1_then_la1 
    lda.z j
    cmp #$c
    bcc __b4
    // show_memory_map::@5
    // for(byte i=0;i<2;i++)
    // [1120] show_memory_map::i#1 = ++ show_memory_map::i#10 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [1075] phi from show_memory_map::@5 to show_memory_map::@1 [phi:show_memory_map::@5->show_memory_map::@1]
    // [1075] phi show_memory_map::i#10 = show_memory_map::i#1 [phi:show_memory_map::@5->show_memory_map::@1#0] -- register_copy 
    jmp __b1
    // show_memory_map::@4
  __b4:
    // printf("%x ", Sprite->VRAM_Addresses[j])
    // [1121] show_memory_map::$13 = show_memory_map::j#2 << 2 -- vbuyy=vbuz1_rol_2 
    lda.z j
    asl
    asl
    tay
    // [1122] show_memory_map::$17 = (dword*)show_memory_map::Sprite#0 + OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES -- pduz1=pduz2_plus_vbuc1 
    lda #OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES
    clc
    adc.z Sprite
    sta.z __17
    lda #0
    adc.z Sprite+1
    sta.z __17+1
    // [1123] printf_ulong::uvalue#4 = show_memory_map::$17[show_memory_map::$13] -- vduz1=pduz2_derefidx_vbuyy 
    lda (__17),y
    sta.z printf_ulong.uvalue
    iny
    lda (__17),y
    sta.z printf_ulong.uvalue+1
    iny
    lda (__17),y
    sta.z printf_ulong.uvalue+2
    iny
    lda (__17),y
    sta.z printf_ulong.uvalue+3
    // [1124] call printf_ulong 
    // [351] phi from show_memory_map::@4 to printf_ulong [phi:show_memory_map::@4->printf_ulong]
    // [351] phi printf_ulong::uvalue#10 = printf_ulong::uvalue#4 [phi:show_memory_map::@4->printf_ulong#0] -- register_copy 
    jsr printf_ulong
    // [1125] phi from show_memory_map::@4 to show_memory_map::@16 [phi:show_memory_map::@4->show_memory_map::@16]
    // show_memory_map::@16
    // printf("%x ", Sprite->VRAM_Addresses[j])
    // [1126] call cputs 
    // [343] phi from show_memory_map::@16 to cputs [phi:show_memory_map::@16->cputs]
    // [343] phi cputs::s#26 = show_memory_map::s3 [phi:show_memory_map::@16->cputs#0] -- pbuz1=pbuc1 
    lda #<s3
    sta.z cputs.s
    lda #>s3
    sta.z cputs.s+1
    jsr cputs
    // show_memory_map::@17
    // for(byte j=0;j<12;j++)
    // [1127] show_memory_map::j#1 = ++ show_memory_map::j#2 -- vbuz1=_inc_vbuz1 
    inc.z j
    // [1118] phi from show_memory_map::@17 to show_memory_map::@3 [phi:show_memory_map::@17->show_memory_map::@3]
    // [1118] phi show_memory_map::j#2 = show_memory_map::j#1 [phi:show_memory_map::@17->show_memory_map::@3#0] -- register_copy 
    jmp __b3
  .segment Data
    s: .text "s:"
    .byte 0
    s1: .text " bram:"
    .byte 0
    s2: .text ", vram:"
    .byte 0
    s3: .text " "
    .byte 0
    s4: .text "t:"
    .byte 0
}
.segment Code
  // kbhit
// Return true if there's a key waiting, return false if not
kbhit: {
    .label chptr = ch
    .label IN_DEV = $28a
    // Current input device number
    .label GETIN = $ffe4
    .label ch = $b1
    // ch = 0
    // [1128] kbhit::ch = 0 -- vbuz1=vbuc1 
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
    // [1130] kbhit::return#0 = kbhit::ch -- vbuaa=vbuz1 
    // kbhit::@return
    // }
    // [1131] kbhit::return#1 = kbhit::return#0
    // [1132] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($d) c)
cputc: {
    .label __16 = $b2
    .label conio_screen_text = $b2
    .label conio_map_width = $b4
    .label conio_addr = $b2
    .label c = $d
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1134] vera_layer_get_color::layer#0 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [1135] call vera_layer_get_color 
    // [1554] phi from cputc to vera_layer_get_color [phi:cputc->vera_layer_get_color]
    // [1554] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#0 [phi:cputc->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1136] vera_layer_get_color::return#3 = vera_layer_get_color::return#2
    // cputc::@7
    // color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1137] cputc::color#0 = vera_layer_get_color::return#3 -- vbuxx=vbuaa 
    tax
    // conio_screen_text = cx16_conio.conio_screen_text
    // [1138] cputc::conio_screen_text#0 = *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- pbuz1=_deref_qbuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z conio_screen_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z conio_screen_text+1
    // conio_map_width = cx16_conio.conio_map_width
    // [1139] cputc::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [1140] cputc::$15 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // conio_addr = conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [1141] cputc::conio_addr#0 = cputc::conio_screen_text#0 + conio_line_text[cputc::$15] -- pbuz1=pbuz1_plus_pwuc1_derefidx_vbuaa 
    tay
    clc
    lda.z conio_addr
    adc conio_line_text,y
    sta.z conio_addr
    lda.z conio_addr+1
    adc conio_line_text+1,y
    sta.z conio_addr+1
    // conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [1142] cputc::$2 = conio_cursor_x[*((byte*)&cx16_conio)] << 1 -- vbuaa=pbuc1_derefidx_(_deref_pbuc2)_rol_1 
    ldy cx16_conio
    lda conio_cursor_x,y
    asl
    // conio_addr += conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [1143] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$2 -- pbuz1=pbuz1_plus_vbuaa 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [1144] if(cputc::c#3==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1145] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <conio_addr
    // [1146] cputc::$4 = < cputc::conio_addr#1 -- vbuaa=_lo_pbuz1 
    lda.z conio_addr
    // *VERA_ADDRX_L = <conio_addr
    // [1147] *VERA_ADDRX_L = cputc::$4 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >conio_addr
    // [1148] cputc::$5 = > cputc::conio_addr#1 -- vbuaa=_hi_pbuz1 
    lda.z conio_addr+1
    // *VERA_ADDRX_M = >conio_addr
    // [1149] *VERA_ADDRX_M = cputc::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [1150] cputc::$6 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [1151] *VERA_ADDRX_H = cputc::$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [1152] *VERA_DATA0 = cputc::c#3 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [1153] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // conio_cursor_x[cx16_conio.conio_screen_layer]++;
    // [1154] conio_cursor_x[*((byte*)&cx16_conio)] = ++ conio_cursor_x[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    ldy cx16_conio
    lda conio_cursor_x,x
    inc
    sta conio_cursor_x,y
    // scroll_enable = conio_scroll_enable[cx16_conio.conio_screen_layer]
    // [1155] cputc::scroll_enable#0 = conio_scroll_enable[*((byte*)&cx16_conio)] -- vbuaa=pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_scroll_enable,y
    // if(scroll_enable)
    // [1156] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b5
    // cputc::@3
    // (unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width
    // [1157] cputc::$16 = (word)conio_cursor_x[*((byte*)&cx16_conio)] -- vwuz1=_word_pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_cursor_x,y
    sta.z __16
    lda #0
    sta.z __16+1
    // if((unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width)
    // [1158] if(cputc::$16!=cputc::conio_map_width#0) goto cputc::@return -- vwuz1_neq_vwuz2_then_la1 
    cmp.z conio_map_width+1
    bne __breturn
    lda.z __16
    cmp.z conio_map_width
    bne __breturn
    // [1159] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [1160] call cputln 
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [1161] return 
    rts
    // cputc::@5
  __b5:
    // if(conio_cursor_x[cx16_conio.conio_screen_layer] == cx16_conio.conio_screen_width)
    // [1162] if(conio_cursor_x[*((byte*)&cx16_conio)]!=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto cputc::@return -- pbuc1_derefidx_(_deref_pbuc2)_neq__deref_pbuc3_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    ldy cx16_conio
    cmp conio_cursor_x,y
    bne __breturn
    // [1163] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [1164] call cputln 
    jsr cputln
    rts
    // [1165] phi from cputc::@7 to cputc::@1 [phi:cputc::@7->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [1166] call cputln 
    jsr cputln
    rts
}
  // ultoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// ultoa(dword zp(5) value, byte* zp($20) buffer)
ultoa: {
    .label digit_value = $b6
    .label buffer = $20
    .label digit = $1f
    .label value = 5
    // [1168] phi from ultoa to ultoa::@1 [phi:ultoa->ultoa::@1]
    // [1168] phi ultoa::buffer#11 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:ultoa->ultoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [1168] phi ultoa::started#2 = 0 [phi:ultoa->ultoa::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [1168] phi ultoa::value#2 = ultoa::value#1 [phi:ultoa->ultoa::@1#2] -- register_copy 
    // [1168] phi ultoa::digit#2 = 0 [phi:ultoa->ultoa::@1#3] -- vbuz1=vbuc1 
    txa
    sta.z digit
    // ultoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1169] if(ultoa::digit#2<8-1) goto ultoa::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z digit
    cmp #8-1
    bcc __b2
    // ultoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [1170] ultoa::$11 = (byte)ultoa::value#2 -- vbuaa=_byte_vduz1 
    lda.z value
    // [1171] *ultoa::buffer#11 = DIGITS[ultoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbuaa 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1172] ultoa::buffer#3 = ++ ultoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1173] *ultoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // ultoa::@return
    // }
    // [1174] return 
    rts
    // ultoa::@2
  __b2:
    // digit_value = digit_values[digit]
    // [1175] ultoa::$10 = ultoa::digit#2 << 2 -- vbuaa=vbuz1_rol_2 
    lda.z digit
    asl
    asl
    // [1176] ultoa::digit_value#0 = RADIX_HEXADECIMAL_VALUES_LONG[ultoa::$10] -- vduz1=pduc1_derefidx_vbuaa 
    tay
    lda RADIX_HEXADECIMAL_VALUES_LONG,y
    sta.z digit_value
    lda RADIX_HEXADECIMAL_VALUES_LONG+1,y
    sta.z digit_value+1
    lda RADIX_HEXADECIMAL_VALUES_LONG+2,y
    sta.z digit_value+2
    lda RADIX_HEXADECIMAL_VALUES_LONG+3,y
    sta.z digit_value+3
    // if (started || value >= digit_value)
    // [1177] if(0!=ultoa::started#2) goto ultoa::@5 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b5
    // ultoa::@7
    // [1178] if(ultoa::value#2>=ultoa::digit_value#0) goto ultoa::@5 -- vduz1_ge_vduz2_then_la1 
    lda.z value+3
    cmp.z digit_value+3
    bcc !+
    bne __b5
    lda.z value+2
    cmp.z digit_value+2
    bcc !+
    bne __b5
    lda.z value+1
    cmp.z digit_value+1
    bcc !+
    bne __b5
    lda.z value
    cmp.z digit_value
    bcs __b5
  !:
    // [1179] phi from ultoa::@7 to ultoa::@4 [phi:ultoa::@7->ultoa::@4]
    // [1179] phi ultoa::buffer#14 = ultoa::buffer#11 [phi:ultoa::@7->ultoa::@4#0] -- register_copy 
    // [1179] phi ultoa::started#4 = ultoa::started#2 [phi:ultoa::@7->ultoa::@4#1] -- register_copy 
    // [1179] phi ultoa::value#6 = ultoa::value#2 [phi:ultoa::@7->ultoa::@4#2] -- register_copy 
    // ultoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1180] ultoa::digit#1 = ++ ultoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [1168] phi from ultoa::@4 to ultoa::@1 [phi:ultoa::@4->ultoa::@1]
    // [1168] phi ultoa::buffer#11 = ultoa::buffer#14 [phi:ultoa::@4->ultoa::@1#0] -- register_copy 
    // [1168] phi ultoa::started#2 = ultoa::started#4 [phi:ultoa::@4->ultoa::@1#1] -- register_copy 
    // [1168] phi ultoa::value#2 = ultoa::value#6 [phi:ultoa::@4->ultoa::@1#2] -- register_copy 
    // [1168] phi ultoa::digit#2 = ultoa::digit#1 [phi:ultoa::@4->ultoa::@1#3] -- register_copy 
    jmp __b1
    // ultoa::@5
  __b5:
    // ultoa_append(buffer++, value, digit_value)
    // [1181] ultoa_append::buffer#0 = ultoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z ultoa_append.buffer
    lda.z buffer+1
    sta.z ultoa_append.buffer+1
    // [1182] ultoa_append::value#0 = ultoa::value#2
    // [1183] ultoa_append::sub#0 = ultoa::digit_value#0
    // [1184] call ultoa_append 
    // [1573] phi from ultoa::@5 to ultoa_append [phi:ultoa::@5->ultoa_append]
    jsr ultoa_append
    // ultoa_append(buffer++, value, digit_value)
    // [1185] ultoa_append::return#0 = ultoa_append::value#2
    // ultoa::@6
    // value = ultoa_append(buffer++, value, digit_value)
    // [1186] ultoa::value#0 = ultoa_append::return#0
    // value = ultoa_append(buffer++, value, digit_value);
    // [1187] ultoa::buffer#4 = ++ ultoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1179] phi from ultoa::@6 to ultoa::@4 [phi:ultoa::@6->ultoa::@4]
    // [1179] phi ultoa::buffer#14 = ultoa::buffer#4 [phi:ultoa::@6->ultoa::@4#0] -- register_copy 
    // [1179] phi ultoa::started#4 = 1 [phi:ultoa::@6->ultoa::@4#1] -- vbuxx=vbuc1 
    ldx #1
    // [1179] phi ultoa::value#6 = ultoa::value#0 [phi:ultoa::@6->ultoa::@4#2] -- register_copy 
    jmp __b4
}
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte register(A) buffer_sign)
printf_number_buffer: {
    // printf_number_buffer::@1
    // if(buffer.sign)
    // [1189] if(0==printf_number_buffer::buffer_sign#10) goto printf_number_buffer::@2 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b2
    // printf_number_buffer::@3
    // cputc(buffer.sign)
    // [1190] cputc::c#2 = printf_number_buffer::buffer_sign#10 -- vbuz1=vbuaa 
    sta.z cputc.c
    // [1191] call cputc 
    // [1133] phi from printf_number_buffer::@3 to cputc [phi:printf_number_buffer::@3->cputc]
    // [1133] phi cputc::c#3 = cputc::c#2 [phi:printf_number_buffer::@3->cputc#0] -- register_copy 
    jsr cputc
    // [1192] phi from printf_number_buffer::@1 printf_number_buffer::@3 to printf_number_buffer::@2 [phi:printf_number_buffer::@1/printf_number_buffer::@3->printf_number_buffer::@2]
    // printf_number_buffer::@2
  __b2:
    // cputs(buffer.digits)
    // [1193] call cputs 
    // [343] phi from printf_number_buffer::@2 to cputs [phi:printf_number_buffer::@2->cputs]
    // [343] phi cputs::s#26 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:printf_number_buffer::@2->cputs#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s+1
    jsr cputs
    // printf_number_buffer::@return
    // }
    // [1194] return 
    rts
}
  // utoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp($34) value, byte* zp($3a) buffer)
utoa: {
    .label digit_value = $ba
    .label buffer = $3a
    .label digit = 3
    .label value = $34
    // [1196] phi from utoa to utoa::@1 [phi:utoa->utoa::@1]
    // [1196] phi utoa::buffer#11 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:utoa->utoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [1196] phi utoa::started#2 = 0 [phi:utoa->utoa::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [1196] phi utoa::value#2 = utoa::value#1 [phi:utoa->utoa::@1#2] -- register_copy 
    // [1196] phi utoa::digit#2 = 0 [phi:utoa->utoa::@1#3] -- vbuz1=vbuc1 
    txa
    sta.z digit
    // utoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1197] if(utoa::digit#2<5-1) goto utoa::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z digit
    cmp #5-1
    bcc __b2
    // utoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [1198] utoa::$11 = (byte)utoa::value#2 -- vbuaa=_byte_vwuz1 
    lda.z value
    // [1199] *utoa::buffer#11 = DIGITS[utoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbuaa 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1200] utoa::buffer#3 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1201] *utoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // utoa::@return
    // }
    // [1202] return 
    rts
    // utoa::@2
  __b2:
    // digit_value = digit_values[digit]
    // [1203] utoa::$10 = utoa::digit#2 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z digit
    asl
    // [1204] utoa::digit_value#0 = RADIX_DECIMAL_VALUES[utoa::$10] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    // [1205] if(0!=utoa::started#2) goto utoa::@5 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b5
    // utoa::@7
    // [1206] if(utoa::value#2>=utoa::digit_value#0) goto utoa::@5 -- vwuz1_ge_vwuz2_then_la1 
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b5
  !:
    bcc __b5
    // [1207] phi from utoa::@7 to utoa::@4 [phi:utoa::@7->utoa::@4]
    // [1207] phi utoa::buffer#14 = utoa::buffer#11 [phi:utoa::@7->utoa::@4#0] -- register_copy 
    // [1207] phi utoa::started#4 = utoa::started#2 [phi:utoa::@7->utoa::@4#1] -- register_copy 
    // [1207] phi utoa::value#6 = utoa::value#2 [phi:utoa::@7->utoa::@4#2] -- register_copy 
    // utoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1208] utoa::digit#1 = ++ utoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [1196] phi from utoa::@4 to utoa::@1 [phi:utoa::@4->utoa::@1]
    // [1196] phi utoa::buffer#11 = utoa::buffer#14 [phi:utoa::@4->utoa::@1#0] -- register_copy 
    // [1196] phi utoa::started#2 = utoa::started#4 [phi:utoa::@4->utoa::@1#1] -- register_copy 
    // [1196] phi utoa::value#2 = utoa::value#6 [phi:utoa::@4->utoa::@1#2] -- register_copy 
    // [1196] phi utoa::digit#2 = utoa::digit#1 [phi:utoa::@4->utoa::@1#3] -- register_copy 
    jmp __b1
    // utoa::@5
  __b5:
    // utoa_append(buffer++, value, digit_value)
    // [1209] utoa_append::buffer#0 = utoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z utoa_append.buffer
    lda.z buffer+1
    sta.z utoa_append.buffer+1
    // [1210] utoa_append::value#0 = utoa::value#2
    // [1211] utoa_append::sub#0 = utoa::digit_value#0
    // [1212] call utoa_append 
    // [1580] phi from utoa::@5 to utoa_append [phi:utoa::@5->utoa_append]
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // [1213] utoa_append::return#0 = utoa_append::value#2
    // utoa::@6
    // value = utoa_append(buffer++, value, digit_value)
    // [1214] utoa::value#0 = utoa_append::return#0
    // value = utoa_append(buffer++, value, digit_value);
    // [1215] utoa::buffer#4 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1207] phi from utoa::@6 to utoa::@4 [phi:utoa::@6->utoa::@4]
    // [1207] phi utoa::buffer#14 = utoa::buffer#4 [phi:utoa::@6->utoa::@4#0] -- register_copy 
    // [1207] phi utoa::started#4 = 1 [phi:utoa::@6->utoa::@4#1] -- vbuxx=vbuc1 
    ldx #1
    // [1207] phi utoa::value#6 = utoa::value#0 [phi:utoa::@6->utoa::@4#2] -- register_copy 
    jmp __b4
}
  // divr16u
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp($20) dividend, word zp($22) rem)
divr16u: {
    .const divisor = 3
    .label rem = $22
    .label dividend = $20
    .label quotient = $b2
    .label return = $b2
    // [1217] phi from divr16u to divr16u::@1 [phi:divr16u->divr16u::@1]
    // [1217] phi divr16u::i#2 = 0 [phi:divr16u->divr16u::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [1217] phi divr16u::quotient#3 = 0 [phi:divr16u->divr16u::@1#1] -- vwuz1=vwuc1 
    txa
    sta.z quotient
    sta.z quotient+1
    // [1217] phi divr16u::dividend#2 = divr16u::dividend#1 [phi:divr16u->divr16u::@1#2] -- register_copy 
    // [1217] phi divr16u::rem#4 = 0 [phi:divr16u->divr16u::@1#3] -- vwuz1=vbuc1 
    sta.z rem
    sta.z rem+1
    // [1217] phi from divr16u::@3 to divr16u::@1 [phi:divr16u::@3->divr16u::@1]
    // [1217] phi divr16u::i#2 = divr16u::i#1 [phi:divr16u::@3->divr16u::@1#0] -- register_copy 
    // [1217] phi divr16u::quotient#3 = divr16u::return#0 [phi:divr16u::@3->divr16u::@1#1] -- register_copy 
    // [1217] phi divr16u::dividend#2 = divr16u::dividend#0 [phi:divr16u::@3->divr16u::@1#2] -- register_copy 
    // [1217] phi divr16u::rem#4 = divr16u::rem#10 [phi:divr16u::@3->divr16u::@1#3] -- register_copy 
    // divr16u::@1
  __b1:
    // rem = rem << 1
    // [1218] divr16u::rem#0 = divr16u::rem#4 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z rem
    rol.z rem+1
    // >dividend
    // [1219] divr16u::$1 = > divr16u::dividend#2 -- vbuaa=_hi_vwuz1 
    lda.z dividend+1
    // >dividend & $80
    // [1220] divr16u::$2 = divr16u::$1 & $80 -- vbuaa=vbuaa_band_vbuc1 
    and #$80
    // if( (>dividend & $80) != 0 )
    // [1221] if(divr16u::$2==0) goto divr16u::@2 -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b2
    // divr16u::@4
    // rem = rem | 1
    // [1222] divr16u::rem#1 = divr16u::rem#0 | 1 -- vwuz1=vwuz1_bor_vbuc1 
    lda #1
    ora.z rem
    sta.z rem
    // [1223] phi from divr16u::@1 divr16u::@4 to divr16u::@2 [phi:divr16u::@1/divr16u::@4->divr16u::@2]
    // [1223] phi divr16u::rem#5 = divr16u::rem#0 [phi:divr16u::@1/divr16u::@4->divr16u::@2#0] -- register_copy 
    // divr16u::@2
  __b2:
    // dividend = dividend << 1
    // [1224] divr16u::dividend#0 = divr16u::dividend#2 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z dividend
    rol.z dividend+1
    // quotient = quotient << 1
    // [1225] divr16u::quotient#1 = divr16u::quotient#3 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z quotient
    rol.z quotient+1
    // if(rem>=divisor)
    // [1226] if(divr16u::rem#5<divr16u::divisor#0) goto divr16u::@3 -- vwuz1_lt_vwuc1_then_la1 
    lda.z rem+1
    cmp #>divisor
    bcc __b3
    bne !+
    lda.z rem
    cmp #<divisor
    bcc __b3
  !:
    // divr16u::@5
    // quotient++;
    // [1227] divr16u::quotient#2 = ++ divr16u::quotient#1 -- vwuz1=_inc_vwuz1 
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    // rem = rem - divisor
    // [1228] divr16u::rem#2 = divr16u::rem#5 - divr16u::divisor#0 -- vwuz1=vwuz1_minus_vwuc1 
    lda.z rem
    sec
    sbc #<divisor
    sta.z rem
    lda.z rem+1
    sbc #>divisor
    sta.z rem+1
    // [1229] phi from divr16u::@2 divr16u::@5 to divr16u::@3 [phi:divr16u::@2/divr16u::@5->divr16u::@3]
    // [1229] phi divr16u::return#0 = divr16u::quotient#1 [phi:divr16u::@2/divr16u::@5->divr16u::@3#0] -- register_copy 
    // [1229] phi divr16u::rem#10 = divr16u::rem#5 [phi:divr16u::@2/divr16u::@5->divr16u::@3#1] -- register_copy 
    // divr16u::@3
  __b3:
    // for( char i : 0..15)
    // [1230] divr16u::i#1 = ++ divr16u::i#2 -- vbuxx=_inc_vbuxx 
    inx
    // [1231] if(divr16u::i#1!=$10) goto divr16u::@1 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$10
    bne __b1
    // divr16u::@return
    // }
    // [1232] return 
    rts
}
  // vera_layer_set_text_color_mode
// Set the configuration of the layer text color mode.
// - layer: Value of 0 or 1.
// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
vera_layer_set_text_color_mode: {
    .label addr = $4f
    // addr = vera_layer_config[layer]
    // [1233] vera_layer_set_text_color_mode::addr#0 = *(vera_layer_config+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr &= ~VERA_LAYER_CONFIG_256C
    // [1234] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 & ~VERA_LAYER_CONFIG_256C -- _deref_pbuz1=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C^$ff
    ldy #0
    and (addr),y
    sta (addr),y
    // *addr |= color_mode
    // [1235] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 -- _deref_pbuz1=_deref_pbuz1 
    lda (addr),y
    sta (addr),y
    // vera_layer_set_text_color_mode::@return
    // }
    // [1236] return 
    rts
}
  // vera_layer_get_mapbase_bank
// Get the map base bank of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Bank in vera vram.
vera_layer_get_mapbase_bank: {
    .const layer = 1
    // return vera_mapbase_bank[layer];
    // [1237] vera_layer_get_mapbase_bank::return#0 = *(vera_mapbase_bank+vera_layer_get_mapbase_bank::layer#0) -- vbuaa=_deref_pbuc1 
    lda vera_mapbase_bank+layer
    // vera_layer_get_mapbase_bank::@return
    // }
    // [1238] return 
    rts
}
  // vera_layer_get_mapbase_offset
// Get the map base lower 16-bit address (offset) of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Offset in vera vram of the specified bank.
vera_layer_get_mapbase_offset: {
    .const layer = 1
    .label return = $4f
    // return vera_mapbase_offset[layer];
    // [1239] vera_layer_get_mapbase_offset::return#0 = *(vera_mapbase_offset+vera_layer_get_mapbase_offset::layer#0<<1) -- vwuz1=_deref_pwuc1 
    lda vera_mapbase_offset+(layer<<1)
    sta.z return
    lda vera_mapbase_offset+(layer<<1)+1
    sta.z return+1
    // vera_layer_get_mapbase_offset::@return
    // }
    // [1240] return 
    rts
}
  // vera_layer_get_rowshift
// Get the bit shift value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
vera_layer_get_rowshift: {
    .const layer = 1
    // return vera_layer_rowshift[layer];
    // [1241] vera_layer_get_rowshift::return#0 = *(vera_layer_rowshift+vera_layer_get_rowshift::layer#0) -- vbuaa=_deref_pbuc1 
    lda vera_layer_rowshift+layer
    // vera_layer_get_rowshift::@return
    // }
    // [1242] return 
    rts
}
  // vera_layer_get_rowskip
// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
vera_layer_get_rowskip: {
    .const layer = 1
    .label return = $4f
    // return vera_layer_rowskip[layer];
    // [1243] vera_layer_get_rowskip::return#0 = *(vera_layer_rowskip+vera_layer_get_rowskip::layer#0<<1) -- vwuz1=_deref_pwuc1 
    lda vera_layer_rowskip+(layer<<1)
    sta.z return
    lda vera_layer_rowskip+(layer<<1)+1
    sta.z return+1
    // vera_layer_get_rowskip::@return
    // }
    // [1244] return 
    rts
}
  // printf_string
// Print a string value using a specific format
// Handles justification and min length 
// printf_string(byte* zp($c2) str)
printf_string: {
    .label str = $c2
    // printf_string::@1
    // cputs(str)
    // [1246] cputs::s#2 = printf_string::str#2 -- pbuz1=pbuz2 
    lda.z str
    sta.z cputs.s
    lda.z str+1
    sta.z cputs.s+1
    // [1247] call cputs 
    // [343] phi from printf_string::@1 to cputs [phi:printf_string::@1->cputs]
    // [343] phi cputs::s#26 = cputs::s#2 [phi:printf_string::@1->cputs#0] -- register_copy 
    jsr cputs
    // printf_string::@return
    // }
    // [1248] return 
    rts
}
  // cx16_ram_bank
// Configure the bank of a banked ram on the X16.
// cx16_ram_bank(byte register(X) bank)
cx16_ram_bank: {
    // current_bank = VIA1->PORT_A
    // [1250] cx16_ram_bank::return#0 = *((byte*)VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A) -- vbuaa=_deref_pbuc1 
    lda VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    // VIA1->PORT_A = bank
    // [1251] *((byte*)VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A) = cx16_ram_bank::bank#11 -- _deref_pbuc1=vbuxx 
    stx VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    // cx16_ram_bank::@return
    // }
    // [1252] return 
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
// cbm_k_setnam(byte* zp($54) filename)
cbm_k_setnam: {
    .label filename = $54
    .label filename_len = $bc
    .label __0 = $af
    // strlen(filename)
    // [1253] strlen::str#1 = cbm_k_setnam::filename -- pbuz1=pbuz2 
    lda.z filename
    sta.z strlen.str
    lda.z filename+1
    sta.z strlen.str+1
    // [1254] call strlen 
    // [1587] phi from cbm_k_setnam to strlen [phi:cbm_k_setnam->strlen]
    jsr strlen
    // strlen(filename)
    // [1255] strlen::return#2 = strlen::len#2
    // cbm_k_setnam::@1
    // [1256] cbm_k_setnam::$0 = strlen::return#2
    // filename_len = (char)strlen(filename)
    // [1257] cbm_k_setnam::filename_len = (byte)cbm_k_setnam::$0 -- vbuz1=_byte_vwuz2 
    lda.z __0
    sta.z filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx filename
    ldy filename+1
    jsr CBM_SETNAM
    // cbm_k_setnam::@return
    // }
    // [1259] return 
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
// cbm_k_setlfs(byte zp($56) channel, byte zp($57) device, byte zp($58) secondary)
cbm_k_setlfs: {
    .label channel = $56
    .label device = $57
    .label secondary = $58
    // asm
    // asm { ldxdevice ldachannel ldysecondary jsrCBM_SETLFS  }
    ldx device
    lda channel
    ldy secondary
    jsr CBM_SETLFS
    // cbm_k_setlfs::@return
    // }
    // [1261] return 
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
    .label status = $bd
    // status
    // [1262] cbm_k_open::status = 0 -- vbuz1=vbuc1 
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
    // [1264] cbm_k_open::return#0 = cbm_k_open::status -- vbuaa=vbuz1 
    // cbm_k_open::@return
    // }
    // [1265] cbm_k_open::return#1 = cbm_k_open::return#0
    // [1266] return 
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
// cbm_k_chkin(byte zp($59) channel)
cbm_k_chkin: {
    .label channel = $59
    .label status = $be
    // status
    // [1267] cbm_k_chkin::status = 0 -- vbuz1=vbuc1 
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
    // [1269] cbm_k_chkin::return#0 = cbm_k_chkin::status -- vbuaa=vbuz1 
    // cbm_k_chkin::@return
    // }
    // [1270] cbm_k_chkin::return#1 = cbm_k_chkin::return#0
    // [1271] return 
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
    .label value = $bf
    // value
    // [1272] cbm_k_chrin::value = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z value
    // asm
    // asm { jsrCBM_CHRIN stavalue  }
    jsr CBM_CHRIN
    sta value
    // return value;
    // [1274] cbm_k_chrin::return#0 = cbm_k_chrin::value -- vbuaa=vbuz1 
    // cbm_k_chrin::@return
    // }
    // [1275] cbm_k_chrin::return#1 = cbm_k_chrin::return#0
    // [1276] return 
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
    .label status = $c0
    // status
    // [1277] cbm_k_readst::status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta status
    // return status;
    // [1279] cbm_k_readst::return#0 = cbm_k_readst::status -- vbuaa=vbuz1 
    // cbm_k_readst::@return
    // }
    // [1280] cbm_k_readst::return#1 = cbm_k_readst::return#0
    // [1281] return 
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
// cbm_k_close(byte zp($5a) channel)
cbm_k_close: {
    .label channel = $5a
    .label status = $c1
    // status
    // [1282] cbm_k_close::status = 0 -- vbuz1=vbuc1 
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
    // [1284] cbm_k_close::return#0 = cbm_k_close::status -- vbuaa=vbuz1 
    // cbm_k_close::@return
    // }
    // [1285] cbm_k_close::return#1 = cbm_k_close::return#0
    // [1286] return 
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
    // [1288] return 
    rts
}
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp($cc) buffer, byte register(Y) radix)
uctoa: {
    .label buffer = $cc
    .label digit = $53
    .label started = $6d
    .label max_digits = $3c
    .label digit_values = $65
    // if(radix==DECIMAL)
    // [1289] if(uctoa::radix#0==DECIMAL) goto uctoa::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #DECIMAL
    beq __b2
    // uctoa::@2
    // if(radix==HEXADECIMAL)
    // [1290] if(uctoa::radix#0==HEXADECIMAL) goto uctoa::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #HEXADECIMAL
    beq __b3
    // uctoa::@3
    // if(radix==OCTAL)
    // [1291] if(uctoa::radix#0==OCTAL) goto uctoa::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #OCTAL
    beq __b4
    // uctoa::@4
    // if(radix==BINARY)
    // [1292] if(uctoa::radix#0==BINARY) goto uctoa::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #BINARY
    beq __b5
    // uctoa::@5
    // *buffer++ = 'e'
    // [1293] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS) = 'e' -- _deref_pbuc1=vbuc2 
    // Unknown radix
    lda #'e'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    // [1294] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1) = 'r' -- _deref_pbuc1=vbuc2 
    lda #'r'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    // [1295] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2) = 'r' -- _deref_pbuc1=vbuc2 
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    // [1296] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // uctoa::@return
    // }
    // [1297] return 
    rts
    // [1298] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
  __b2:
    // [1298] phi uctoa::digit_values#8 = RADIX_DECIMAL_VALUES_CHAR [phi:uctoa->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values+1
    // [1298] phi uctoa::max_digits#7 = 3 [phi:uctoa->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #3
    sta.z max_digits
    jmp __b1
    // [1298] phi from uctoa::@2 to uctoa::@1 [phi:uctoa::@2->uctoa::@1]
  __b3:
    // [1298] phi uctoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES_CHAR [phi:uctoa::@2->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values+1
    // [1298] phi uctoa::max_digits#7 = 2 [phi:uctoa::@2->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #2
    sta.z max_digits
    jmp __b1
    // [1298] phi from uctoa::@3 to uctoa::@1 [phi:uctoa::@3->uctoa::@1]
  __b4:
    // [1298] phi uctoa::digit_values#8 = RADIX_OCTAL_VALUES_CHAR [phi:uctoa::@3->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values+1
    // [1298] phi uctoa::max_digits#7 = 3 [phi:uctoa::@3->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #3
    sta.z max_digits
    jmp __b1
    // [1298] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
  __b5:
    // [1298] phi uctoa::digit_values#8 = RADIX_BINARY_VALUES_CHAR [phi:uctoa::@4->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_BINARY_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES_CHAR
    sta.z digit_values+1
    // [1298] phi uctoa::max_digits#7 = 8 [phi:uctoa::@4->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #8
    sta.z max_digits
    // uctoa::@1
  __b1:
    // [1299] phi from uctoa::@1 to uctoa::@6 [phi:uctoa::@1->uctoa::@6]
    // [1299] phi uctoa::buffer#11 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:uctoa::@1->uctoa::@6#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [1299] phi uctoa::started#2 = 0 [phi:uctoa::@1->uctoa::@6#1] -- vbuz1=vbuc1 
    lda #0
    sta.z started
    // [1299] phi uctoa::value#2 = uctoa::value#1 [phi:uctoa::@1->uctoa::@6#2] -- register_copy 
    // [1299] phi uctoa::digit#2 = 0 [phi:uctoa::@1->uctoa::@6#3] -- vbuz1=vbuc1 
    sta.z digit
    // uctoa::@6
  __b6:
    // max_digits-1
    // [1300] uctoa::$4 = uctoa::max_digits#7 - 1 -- vbuaa=vbuz1_minus_1 
    lda.z max_digits
    sec
    sbc #1
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1301] if(uctoa::digit#2<uctoa::$4) goto uctoa::@7 -- vbuz1_lt_vbuaa_then_la1 
    cmp.z digit
    beq !+
    bcs __b7
  !:
    // uctoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [1302] *uctoa::buffer#11 = DIGITS[uctoa::value#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1303] uctoa::buffer#3 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1304] *uctoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    rts
    // uctoa::@7
  __b7:
    // digit_value = digit_values[digit]
    // [1305] uctoa::digit_value#0 = uctoa::digit_values#8[uctoa::digit#2] -- vbuyy=pbuz1_derefidx_vbuz2 
    ldy.z digit
    lda (digit_values),y
    tay
    // if (started || value >= digit_value)
    // [1306] if(0!=uctoa::started#2) goto uctoa::@10 -- 0_neq_vbuz1_then_la1 
    lda.z started
    bne __b10
    // uctoa::@12
    // [1307] if(uctoa::value#2>=uctoa::digit_value#0) goto uctoa::@10 -- vbuxx_ge_vbuyy_then_la1 
    sty.z $ff
    cpx.z $ff
    bcs __b10
    // [1308] phi from uctoa::@12 to uctoa::@9 [phi:uctoa::@12->uctoa::@9]
    // [1308] phi uctoa::buffer#14 = uctoa::buffer#11 [phi:uctoa::@12->uctoa::@9#0] -- register_copy 
    // [1308] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@12->uctoa::@9#1] -- register_copy 
    // [1308] phi uctoa::value#6 = uctoa::value#2 [phi:uctoa::@12->uctoa::@9#2] -- register_copy 
    // uctoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1309] uctoa::digit#1 = ++ uctoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [1299] phi from uctoa::@9 to uctoa::@6 [phi:uctoa::@9->uctoa::@6]
    // [1299] phi uctoa::buffer#11 = uctoa::buffer#14 [phi:uctoa::@9->uctoa::@6#0] -- register_copy 
    // [1299] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@9->uctoa::@6#1] -- register_copy 
    // [1299] phi uctoa::value#2 = uctoa::value#6 [phi:uctoa::@9->uctoa::@6#2] -- register_copy 
    // [1299] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@9->uctoa::@6#3] -- register_copy 
    jmp __b6
    // uctoa::@10
  __b10:
    // uctoa_append(buffer++, value, digit_value)
    // [1310] uctoa_append::buffer#0 = uctoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z uctoa_append.buffer
    lda.z buffer+1
    sta.z uctoa_append.buffer+1
    // [1311] uctoa_append::value#0 = uctoa::value#2
    // [1312] uctoa_append::sub#0 = uctoa::digit_value#0 -- vbuz1=vbuyy 
    sty.z uctoa_append.sub
    // [1313] call uctoa_append 
    // [1593] phi from uctoa::@10 to uctoa_append [phi:uctoa::@10->uctoa_append]
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // [1314] uctoa_append::return#0 = uctoa_append::value#2
    // uctoa::@11
    // value = uctoa_append(buffer++, value, digit_value)
    // [1315] uctoa::value#0 = uctoa_append::return#0
    // value = uctoa_append(buffer++, value, digit_value);
    // [1316] uctoa::buffer#4 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1308] phi from uctoa::@11 to uctoa::@9 [phi:uctoa::@11->uctoa::@9]
    // [1308] phi uctoa::buffer#14 = uctoa::buffer#4 [phi:uctoa::@11->uctoa::@9#0] -- register_copy 
    // [1308] phi uctoa::started#4 = 1 [phi:uctoa::@11->uctoa::@9#1] -- vbuz1=vbuc1 
    lda #1
    sta.z started
    // [1308] phi uctoa::value#6 = uctoa::value#0 [phi:uctoa::@11->uctoa::@9#2] -- register_copy 
    jmp __b9
}
  // vera_heap_block_free_find
// vera_heap_block_free_find(struct vera_heap_segment* zp($72) segment, dword zp($5f) size)
vera_heap_block_free_find: {
    .label __0 = $67
    .label __2 = $c8
    .label block = $72
    .label return = $72
    .label segment = $72
    .label size = $5f
    // block = segment->head_block
    // [1317] vera_heap_block_free_find::block#0 = ((struct vera_heap**)vera_heap_block_free_find::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK] -- pssz1=qssz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK
    lda (block),y
    pha
    iny
    lda (block),y
    sta.z block+1
    pla
    sta.z block
    // [1318] phi from vera_heap_block_free_find vera_heap_block_free_find::@3 to vera_heap_block_free_find::@1 [phi:vera_heap_block_free_find/vera_heap_block_free_find::@3->vera_heap_block_free_find::@1]
    // [1318] phi vera_heap_block_free_find::block#2 = vera_heap_block_free_find::block#0 [phi:vera_heap_block_free_find/vera_heap_block_free_find::@3->vera_heap_block_free_find::@1#0] -- register_copy 
    // vera_heap_block_free_find::@1
  __b1:
    // while(block)
    // [1319] if((struct vera_heap*)0!=vera_heap_block_free_find::block#2) goto vera_heap_block_free_find::@2 -- pssc1_neq_pssz1_then_la1 
    lda.z block+1
    cmp #>0
    bne __b2
    lda.z block
    cmp #<0
    bne __b2
    // [1320] phi from vera_heap_block_free_find::@1 to vera_heap_block_free_find::@return [phi:vera_heap_block_free_find::@1->vera_heap_block_free_find::@return]
    // [1320] phi vera_heap_block_free_find::return#2 = (struct vera_heap*) 0 [phi:vera_heap_block_free_find::@1->vera_heap_block_free_find::@return#0] -- pssz1=pssc1 
    lda #<0
    sta.z return
    sta.z return+1
    // vera_heap_block_free_find::@return
    // }
    // [1321] return 
    rts
    // vera_heap_block_free_find::@2
  __b2:
    // vera_heap_block_is_empty(block)
    // [1322] vera_heap_block_is_empty::block#0 = vera_heap_block_free_find::block#2
    // [1323] call vera_heap_block_is_empty 
    jsr vera_heap_block_is_empty
    // [1324] vera_heap_block_is_empty::return#2 = vera_heap_block_is_empty::return#0
    // vera_heap_block_free_find::@5
    // [1325] vera_heap_block_free_find::$0 = vera_heap_block_is_empty::return#2
    // if(vera_heap_block_is_empty(block))
    // [1326] if(0==vera_heap_block_free_find::$0) goto vera_heap_block_free_find::@3 -- 0_eq_vwuz1_then_la1 
    lda.z __0
    ora.z __0+1
    beq __b3
    // vera_heap_block_free_find::@4
    // vera_heap_block_size_get(block)
    // [1327] vera_heap_block_size_get::block#0 = vera_heap_block_free_find::block#2 -- pssz1=pssz2 
    lda.z block
    sta.z vera_heap_block_size_get.block
    lda.z block+1
    sta.z vera_heap_block_size_get.block+1
    // [1328] call vera_heap_block_size_get 
    jsr vera_heap_block_size_get
    // [1329] vera_heap_block_size_get::return#2 = vera_heap_block_size_get::return#0
    // vera_heap_block_free_find::@6
    // [1330] vera_heap_block_free_find::$2 = vera_heap_block_size_get::return#2
    // if(size==vera_heap_block_size_get(block))
    // [1331] if(vera_heap_block_free_find::size#0!=vera_heap_block_free_find::$2) goto vera_heap_block_free_find::@3 -- vduz1_neq_vduz2_then_la1 
    lda.z size+3
    cmp.z __2+3
    bne __b3
    lda.z size+2
    cmp.z __2+2
    bne __b3
    lda.z size+1
    cmp.z __2+1
    bne __b3
    lda.z size
    cmp.z __2
    bne __b3
    // [1320] phi from vera_heap_block_free_find::@6 to vera_heap_block_free_find::@return [phi:vera_heap_block_free_find::@6->vera_heap_block_free_find::@return]
    // [1320] phi vera_heap_block_free_find::return#2 = vera_heap_block_free_find::block#2 [phi:vera_heap_block_free_find::@6->vera_heap_block_free_find::@return#0] -- register_copy 
    rts
    // vera_heap_block_free_find::@3
  __b3:
    // block = block->next
    // [1332] vera_heap_block_free_find::block#1 = ((struct vera_heap**)vera_heap_block_free_find::block#2)[OFFSET_STRUCT_VERA_HEAP_NEXT] -- pssz1=qssz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_NEXT
    lda (block),y
    pha
    iny
    lda (block),y
    sta.z block+1
    pla
    sta.z block
    jmp __b1
}
  // vera_heap_block_empty_set
// vera_heap_block_empty_set(struct vera_heap* zp($67) block)
vera_heap_block_empty_set: {
    .label __1 = $74
    .label __4 = $af
    .label block = $67
    // (block->size & ~VERA_HEAP_EMPTY) | empty
    // [1334] vera_heap_block_empty_set::$1 = ((word*)vera_heap_block_empty_set::block#2)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_EMPTY -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_EMPTY^$ffff
    sta.z __1
    iny
    lda (block),y
    and #>VERA_HEAP_EMPTY^$ffff
    sta.z __1+1
    // (block->size & ~VERA_HEAP_EMPTY) | empty?VERA_HEAP_EMPTY:0
    // [1335] if(0!=vera_heap_block_empty_set::$1) goto vera_heap_block_empty_set::@1 -- 0_neq_vwuz1_then_la1 
    lda.z __1
    ora.z __1+1
    bne __b1
    // [1337] phi from vera_heap_block_empty_set to vera_heap_block_empty_set::@2 [phi:vera_heap_block_empty_set->vera_heap_block_empty_set::@2]
    // [1337] phi vera_heap_block_empty_set::$4 = 0 [phi:vera_heap_block_empty_set->vera_heap_block_empty_set::@2#0] -- vwuz1=vbuc1 
    lda #<0
    sta.z __4
    sta.z __4+1
    jmp __b2
    // [1336] phi from vera_heap_block_empty_set to vera_heap_block_empty_set::@1 [phi:vera_heap_block_empty_set->vera_heap_block_empty_set::@1]
    // vera_heap_block_empty_set::@1
  __b1:
    // (block->size & ~VERA_HEAP_EMPTY) | empty?VERA_HEAP_EMPTY:0
    // [1337] phi from vera_heap_block_empty_set::@1 to vera_heap_block_empty_set::@2 [phi:vera_heap_block_empty_set::@1->vera_heap_block_empty_set::@2]
    // [1337] phi vera_heap_block_empty_set::$4 = VERA_HEAP_EMPTY [phi:vera_heap_block_empty_set::@1->vera_heap_block_empty_set::@2#0] -- vwuz1=vwuc1 
    lda #<VERA_HEAP_EMPTY
    sta.z __4
    lda #>VERA_HEAP_EMPTY
    sta.z __4+1
    // vera_heap_block_empty_set::@2
  __b2:
    // block->size = (block->size & ~VERA_HEAP_EMPTY) | empty?VERA_HEAP_EMPTY:0
    // [1338] ((word*)vera_heap_block_empty_set::block#2)[OFFSET_STRUCT_VERA_HEAP_SIZE] = vera_heap_block_empty_set::$4 -- pwuz1_derefidx_vbuc1=vwuz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda.z __4
    sta (block),y
    iny
    lda.z __4+1
    sta (block),y
    // vera_heap_block_empty_set::@return
    // }
    // [1339] return 
    rts
}
  // vera_heap_block_address_get
// vera_heap_block_address_get(struct vera_heap* zp($72) block)
vera_heap_block_address_get: {
    .label __0 = $67
    .label __9 = $c4
    .label return = $e
    .label block = $72
    .label __11 = $e
    // block->size & VERA_HEAP_ADDRESS_16
    // [1340] vera_heap_block_address_get::$0 = ((word*)vera_heap_block_address_get::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & VERA_HEAP_ADDRESS_16 -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_ADDRESS_16
    sta.z __0
    iny
    lda (block),y
    and #>VERA_HEAP_ADDRESS_16
    sta.z __0+1
    // (block->size & VERA_HEAP_ADDRESS_16)?0x10000:0x00000
    // [1341] if(0!=vera_heap_block_address_get::$0) goto vera_heap_block_address_get::@1 -- 0_neq_vwuz1_then_la1 
    lda.z __0
    ora.z __0+1
    bne __b1
    // [1343] phi from vera_heap_block_address_get to vera_heap_block_address_get::@2 [phi:vera_heap_block_address_get->vera_heap_block_address_get::@2]
    // [1343] phi vera_heap_block_address_get::$11 = 0 [phi:vera_heap_block_address_get->vera_heap_block_address_get::@2#0] -- vduz1=vbuc1 
    lda #0
    sta.z __11
    sta.z __11+1
    sta.z __11+2
    sta.z __11+3
    jmp __b2
    // [1342] phi from vera_heap_block_address_get to vera_heap_block_address_get::@1 [phi:vera_heap_block_address_get->vera_heap_block_address_get::@1]
    // vera_heap_block_address_get::@1
  __b1:
    // (block->size & VERA_HEAP_ADDRESS_16)?0x10000:0x00000
    // [1343] phi from vera_heap_block_address_get::@1 to vera_heap_block_address_get::@2 [phi:vera_heap_block_address_get::@1->vera_heap_block_address_get::@2]
    // [1343] phi vera_heap_block_address_get::$11 = $10000 [phi:vera_heap_block_address_get::@1->vera_heap_block_address_get::@2#0] -- vduz1=vduc1 
    lda #<$10000
    sta.z __11
    lda #>$10000
    sta.z __11+1
    lda #<$10000>>$10
    sta.z __11+2
    lda #>$10000>>$10
    sta.z __11+3
    // vera_heap_block_address_get::@2
  __b2:
    // (dword)block->address | ((block->size & VERA_HEAP_ADDRESS_16)?0x10000:0x00000)
    // [1344] vera_heap_block_address_get::$9 = (dword)*((word*)vera_heap_block_address_get::block#0) -- vduz1=_dword__deref_pwuz2 
    ldy #0
    sty.z __9+2
    sty.z __9+3
    lda (block),y
    sta.z __9
    iny
    lda (block),y
    sta.z __9+1
    // [1345] vera_heap_block_address_get::return#0 = vera_heap_block_address_get::$9 | vera_heap_block_address_get::$11 -- vduz1=vduz2_bor_vduz1 
    lda.z __9
    ora.z return
    sta.z return
    lda.z __9+1
    ora.z return+1
    sta.z return+1
    lda.z __9+2
    ora.z return+2
    sta.z return+2
    lda.z __9+3
    ora.z return+3
    sta.z return+3
    // vera_heap_block_address_get::@return
    // }
    // [1346] return 
    rts
}
  // vera_heap_address
// vera_heap_address(struct vera_heap_segment* zp($72) segment, dword zp($6e) size)
vera_heap_address: {
    .label last_address = $24
    .label next_address = $6e
    .label ceil_address = $c4
    .label return = $24
    .label segment = $72
    .label size = $6e
    // last_address = segment->next_address
    // [1347] vera_heap_address::last_address#0 = ((dword*)vera_heap_address::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
    // TODO: handle out of memory (return 0).
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS
    lda (segment),y
    sta.z last_address
    iny
    lda (segment),y
    sta.z last_address+1
    iny
    lda (segment),y
    sta.z last_address+2
    iny
    lda (segment),y
    sta.z last_address+3
    // next_address = last_address + size
    // [1348] vera_heap_address::next_address#0 = vera_heap_address::last_address#0 + vera_heap_address::size#0 -- vduz1=vduz2_plus_vduz1 
    lda.z next_address
    clc
    adc.z last_address
    sta.z next_address
    lda.z next_address+1
    adc.z last_address+1
    sta.z next_address+1
    lda.z next_address+2
    adc.z last_address+2
    sta.z next_address+2
    lda.z next_address+3
    adc.z last_address+3
    sta.z next_address+3
    // ceil_address = segment->ceil_address
    // [1349] vera_heap_address::ceil_address#0 = ((dword*)vera_heap_address::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
    // if (next_address > segment->ceil_address) // TODO: fragment
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS
    lda (segment),y
    sta.z ceil_address
    iny
    lda (segment),y
    sta.z ceil_address+1
    iny
    lda (segment),y
    sta.z ceil_address+2
    iny
    lda (segment),y
    sta.z ceil_address+3
    // if (next_address > ceil_address)
    // [1350] if(vera_heap_address::next_address#0<=vera_heap_address::ceil_address#0) goto vera_heap_address::@1 -- vduz1_le_vduz2_then_la1 
    cmp.z next_address+3
    bcc !+
    bne __b1
    lda.z ceil_address+2
    cmp.z next_address+2
    bcc !+
    bne __b1
    lda.z ceil_address+1
    cmp.z next_address+1
    bcc !+
    bne __b1
    lda.z ceil_address
    cmp.z next_address
    bcs __b1
  !:
    // [1352] phi from vera_heap_address to vera_heap_address::@return [phi:vera_heap_address->vera_heap_address::@return]
    // [1352] phi vera_heap_address::return#2 = 0 [phi:vera_heap_address->vera_heap_address::@return#0] -- vduz1=vbuc1 
    lda #0
    sta.z return
    sta.z return+1
    sta.z return+2
    sta.z return+3
    rts
    // vera_heap_address::@1
  __b1:
    // segment->next_address = next_address
    // [1351] ((dword*)vera_heap_address::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS] = vera_heap_address::next_address#0 -- pduz1_derefidx_vbuc1=vduz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS
    lda.z next_address
    sta (segment),y
    iny
    lda.z next_address+1
    sta (segment),y
    iny
    lda.z next_address+2
    sta (segment),y
    iny
    lda.z next_address+3
    sta (segment),y
    // [1352] phi from vera_heap_address::@1 to vera_heap_address::@return [phi:vera_heap_address::@1->vera_heap_address::@return]
    // [1352] phi vera_heap_address::return#2 = vera_heap_address::last_address#0 [phi:vera_heap_address::@1->vera_heap_address::@return#0] -- register_copy 
    // vera_heap_address::@return
    // }
    // [1353] return 
    rts
}
  // vera_heap_block_address_set
// vera_heap_block_address_set(struct vera_heap* zp($c2) block)
vera_heap_block_address_set: {
    .label address = vera_heap_malloc.address
    .label __2 = $72
    .label __3 = $74
    .label __6 = $7b
    .label addr = $c8
    .label ad_lo = $72
    .label ad_hi = $74
    .label block = $c2
    // addr = *address
    // [1354] vera_heap_block_address_set::addr#0 = *vera_heap_block_address_set::address#0 -- vduz1=_deref_pduc1 
    lda.z address
    sta.z addr
    lda.z address+1
    sta.z addr+1
    lda.z address+2
    sta.z addr+2
    lda.z address+3
    sta.z addr+3
    // ad_lo = <(addr)
    // [1355] vera_heap_block_address_set::ad_lo#0 = < vera_heap_block_address_set::addr#0 -- vwuz1=_lo_vduz2 
    lda.z addr
    sta.z ad_lo
    lda.z addr+1
    sta.z ad_lo+1
    // ad_hi = >(addr)
    // [1356] vera_heap_block_address_set::ad_hi#0 = > vera_heap_block_address_set::addr#0 -- vwuz1=_hi_vduz2 
    lda.z addr+2
    sta.z ad_hi
    lda.z addr+3
    sta.z ad_hi+1
    // block->address = ad_lo
    // [1357] *((word*)vera_heap_block_address_set::block#0) = vera_heap_block_address_set::ad_lo#0 -- _deref_pwuz1=vwuz2 
    ldy #0
    lda.z ad_lo
    sta (block),y
    iny
    lda.z ad_lo+1
    sta (block),y
    // block->size & ~VERA_HEAP_ADDRESS_16
    // [1358] vera_heap_block_address_set::$2 = ((word*)vera_heap_block_address_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_ADDRESS_16 -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_ADDRESS_16^$ffff
    sta.z __2
    iny
    lda (block),y
    and #>VERA_HEAP_ADDRESS_16^$ffff
    sta.z __2+1
    // (block->size & ~VERA_HEAP_ADDRESS_16) | ad_hi
    // [1359] vera_heap_block_address_set::$3 = vera_heap_block_address_set::$2 | vera_heap_block_address_set::ad_hi#0 -- vwuz1=vwuz2_bor_vwuz1 
    lda.z __3
    ora.z __2
    sta.z __3
    lda.z __3+1
    ora.z __2+1
    sta.z __3+1
    // (block->size & ~VERA_HEAP_ADDRESS_16) | ad_hi?VERA_HEAP_ADDRESS_16:0
    // [1360] if(0!=vera_heap_block_address_set::$3) goto vera_heap_block_address_set::@1 -- 0_neq_vwuz1_then_la1 
    lda.z __3
    ora.z __3+1
    bne __b1
    // [1362] phi from vera_heap_block_address_set to vera_heap_block_address_set::@2 [phi:vera_heap_block_address_set->vera_heap_block_address_set::@2]
    // [1362] phi vera_heap_block_address_set::$6 = 0 [phi:vera_heap_block_address_set->vera_heap_block_address_set::@2#0] -- vwuz1=vbuc1 
    lda #<0
    sta.z __6
    sta.z __6+1
    jmp __b2
    // [1361] phi from vera_heap_block_address_set to vera_heap_block_address_set::@1 [phi:vera_heap_block_address_set->vera_heap_block_address_set::@1]
    // vera_heap_block_address_set::@1
  __b1:
    // (block->size & ~VERA_HEAP_ADDRESS_16) | ad_hi?VERA_HEAP_ADDRESS_16:0
    // [1362] phi from vera_heap_block_address_set::@1 to vera_heap_block_address_set::@2 [phi:vera_heap_block_address_set::@1->vera_heap_block_address_set::@2]
    // [1362] phi vera_heap_block_address_set::$6 = VERA_HEAP_ADDRESS_16 [phi:vera_heap_block_address_set::@1->vera_heap_block_address_set::@2#0] -- vwuz1=vwuc1 
    lda #<VERA_HEAP_ADDRESS_16
    sta.z __6
    lda #>VERA_HEAP_ADDRESS_16
    sta.z __6+1
    // vera_heap_block_address_set::@2
  __b2:
    // block->size = (block->size & ~VERA_HEAP_ADDRESS_16) | ad_hi?VERA_HEAP_ADDRESS_16:0
    // [1363] ((word*)vera_heap_block_address_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] = vera_heap_block_address_set::$6 -- pwuz1_derefidx_vbuc1=vwuz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda.z __6
    sta (block),y
    iny
    lda.z __6+1
    sta (block),y
    // vera_heap_block_address_set::@return
    // }
    // [1364] return 
    rts
}
  // vera_heap_block_size_set
// vera_heap_block_size_set(struct vera_heap* zp($c2) block)
vera_heap_block_size_set: {
    .label size = vera_heap_malloc.size
    .label __2 = $7b
    .label __3 = $74
    .label __4 = $7b
    .label __5 = $74
    .label __6 = $72
    .label __9 = $7b
    .label sz = $c8
    .label sz_lo = $74
    .label sz_hi = $72
    .label block = $c2
    // sz = *size
    // [1365] vera_heap_block_size_set::sz#0 = *vera_heap_block_size_set::size#0 -- vduz1=_deref_pduc1 
    lda.z size
    sta.z sz
    lda.z size+1
    sta.z sz+1
    lda.z size+2
    sta.z sz+2
    lda.z size+3
    sta.z sz+3
    // sz_lo = <sz
    // [1366] vera_heap_block_size_set::sz_lo#0 = < vera_heap_block_size_set::sz#0 -- vwuz1=_lo_vduz2 
    lda.z sz
    sta.z sz_lo
    lda.z sz+1
    sta.z sz_lo+1
    // sz_hi = >sz
    // [1367] vera_heap_block_size_set::sz_hi#0 = > vera_heap_block_size_set::sz#0 -- vwuz1=_hi_vduz2 
    lda.z sz+2
    sta.z sz_hi
    lda.z sz+3
    sta.z sz_hi+1
    // block->size & ~VERA_HEAP_SIZE_MASK
    // [1368] vera_heap_block_size_set::$2 = ((word*)vera_heap_block_size_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_SIZE_MASK -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_SIZE_MASK^$ffff
    sta.z __2
    iny
    lda (block),y
    and #>VERA_HEAP_SIZE_MASK^$ffff
    sta.z __2+1
    // sz_lo & VERA_HEAP_SIZE_MASK
    // [1369] vera_heap_block_size_set::$3 = vera_heap_block_size_set::sz_lo#0 & VERA_HEAP_SIZE_MASK -- vwuz1=vwuz1_band_vwuc1 
    lda.z __3
    and #<VERA_HEAP_SIZE_MASK
    sta.z __3
    lda.z __3+1
    and #>VERA_HEAP_SIZE_MASK
    sta.z __3+1
    // (block->size & ~VERA_HEAP_SIZE_MASK) | sz_lo & VERA_HEAP_SIZE_MASK
    // [1370] vera_heap_block_size_set::$4 = vera_heap_block_size_set::$2 | vera_heap_block_size_set::$3 -- vwuz1=vwuz1_bor_vwuz2 
    lda.z __4
    ora.z __3
    sta.z __4
    lda.z __4+1
    ora.z __3+1
    sta.z __4+1
    // block->size = (block->size & ~VERA_HEAP_SIZE_MASK) | sz_lo & VERA_HEAP_SIZE_MASK
    // [1371] ((word*)vera_heap_block_size_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] = vera_heap_block_size_set::$4 -- pwuz1_derefidx_vbuc1=vwuz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda.z __4
    sta (block),y
    iny
    lda.z __4+1
    sta (block),y
    // block->size & ~VERA_HEAP_SIZE_16
    // [1372] vera_heap_block_size_set::$5 = ((word*)vera_heap_block_size_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_SIZE_16 -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_SIZE_16^$ffff
    sta.z __5
    iny
    lda (block),y
    and #>VERA_HEAP_SIZE_16^$ffff
    sta.z __5+1
    // (block->size & ~VERA_HEAP_SIZE_16) | sz_hi
    // [1373] vera_heap_block_size_set::$6 = vera_heap_block_size_set::$5 | vera_heap_block_size_set::sz_hi#0 -- vwuz1=vwuz2_bor_vwuz1 
    lda.z __6
    ora.z __5
    sta.z __6
    lda.z __6+1
    ora.z __5+1
    sta.z __6+1
    // (block->size & ~VERA_HEAP_SIZE_16) | sz_hi?VERA_HEAP_SIZE_16:0
    // [1374] if(0!=vera_heap_block_size_set::$6) goto vera_heap_block_size_set::@1 -- 0_neq_vwuz1_then_la1 
    lda.z __6
    ora.z __6+1
    bne __b1
    // [1376] phi from vera_heap_block_size_set to vera_heap_block_size_set::@2 [phi:vera_heap_block_size_set->vera_heap_block_size_set::@2]
    // [1376] phi vera_heap_block_size_set::$9 = 0 [phi:vera_heap_block_size_set->vera_heap_block_size_set::@2#0] -- vwuz1=vbuc1 
    lda #<0
    sta.z __9
    sta.z __9+1
    jmp __b2
    // [1375] phi from vera_heap_block_size_set to vera_heap_block_size_set::@1 [phi:vera_heap_block_size_set->vera_heap_block_size_set::@1]
    // vera_heap_block_size_set::@1
  __b1:
    // (block->size & ~VERA_HEAP_SIZE_16) | sz_hi?VERA_HEAP_SIZE_16:0
    // [1376] phi from vera_heap_block_size_set::@1 to vera_heap_block_size_set::@2 [phi:vera_heap_block_size_set::@1->vera_heap_block_size_set::@2]
    // [1376] phi vera_heap_block_size_set::$9 = VERA_HEAP_SIZE_16 [phi:vera_heap_block_size_set::@1->vera_heap_block_size_set::@2#0] -- vwuz1=vwuc1 
    lda #<VERA_HEAP_SIZE_16
    sta.z __9
    lda #>VERA_HEAP_SIZE_16
    sta.z __9+1
    // vera_heap_block_size_set::@2
  __b2:
    // block->size = (block->size & ~VERA_HEAP_SIZE_16) | sz_hi?VERA_HEAP_SIZE_16:0
    // [1377] ((word*)vera_heap_block_size_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] = vera_heap_block_size_set::$9 -- pwuz1_derefidx_vbuc1=vwuz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda.z __9
    sta (block),y
    iny
    lda.z __9+1
    sta (block),y
    // vera_heap_block_size_set::@return
    // }
    // [1378] return 
    rts
}
  // vera_layer_set_config
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
// vera_layer_set_config(byte register(A) layer, byte register(X) config)
vera_layer_set_config: {
    .label addr = $4f
    // addr = vera_layer_config[layer]
    // [1379] vera_layer_set_config::$0 = vera_layer_set_config::layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [1380] vera_layer_set_config::addr#0 = vera_layer_config[vera_layer_set_config::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr = config
    // [1381] *vera_layer_set_config::addr#0 = vera_layer_set_config::config#0 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_config::@return
    // }
    // [1382] return 
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
    .label addr = $4f
    // addr = vera_layer_tilebase[layer]
    // [1383] vera_layer_set_tilebase::$0 = vera_layer_set_tilebase::layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [1384] vera_layer_set_tilebase::addr#0 = vera_layer_tilebase[vera_layer_set_tilebase::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_tilebase,y
    sta.z addr
    lda vera_layer_tilebase+1,y
    sta.z addr+1
    // *addr = tilebase
    // [1385] *vera_layer_set_tilebase::addr#0 = vera_layer_set_tilebase::tilebase#0 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_tilebase::@return
    // }
    // [1386] return 
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
    // [1387] vera_layer_get_backcolor::return#0 = vera_layer_backcolor[vera_layer_get_backcolor::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_backcolor,x
    // vera_layer_get_backcolor::@return
    // }
    // [1388] return 
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
    // [1389] vera_layer_get_textcolor::return#0 = vera_layer_textcolor[vera_layer_get_textcolor::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_textcolor,x
    // vera_layer_get_textcolor::@return
    // }
    // [1390] return 
    rts
}
  // mul16u
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// mul16u(word zp($af) a, word zp($72) b)
mul16u: {
    .label mb = $5f
    .label a = $af
    .label res = $3f
    .label b = $72
    .label return = $3f
    // mb = b
    // [1392] mul16u::mb#0 = (dword)mul16u::b#2 -- vduz1=_dword_vwuz2 
    lda.z b
    sta.z mb
    lda.z b+1
    sta.z mb+1
    lda #0
    sta.z mb+2
    sta.z mb+3
    // [1393] phi from mul16u to mul16u::@1 [phi:mul16u->mul16u::@1]
    // [1393] phi mul16u::mb#2 = mul16u::mb#0 [phi:mul16u->mul16u::@1#0] -- register_copy 
    // [1393] phi mul16u::res#2 = 0 [phi:mul16u->mul16u::@1#1] -- vduz1=vduc1 
    sta.z res
    sta.z res+1
    lda #<0>>$10
    sta.z res+2
    lda #>0>>$10
    sta.z res+3
    // [1393] phi mul16u::a#3 = mul16u::a#6 [phi:mul16u->mul16u::@1#2] -- register_copy 
    // mul16u::@1
  __b1:
    // while(a!=0)
    // [1394] if(mul16u::a#3!=0) goto mul16u::@2 -- vwuz1_neq_0_then_la1 
    lda.z a
    ora.z a+1
    bne __b2
    // mul16u::@return
    // }
    // [1395] return 
    rts
    // mul16u::@2
  __b2:
    // a&1
    // [1396] mul16u::$1 = mul16u::a#3 & 1 -- vbuaa=vwuz1_band_vbuc1 
    lda #1
    and.z a
    // if( (a&1) != 0)
    // [1397] if(mul16u::$1==0) goto mul16u::@3 -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b3
    // mul16u::@4
    // res = res + mb
    // [1398] mul16u::res#1 = mul16u::res#2 + mul16u::mb#2 -- vduz1=vduz1_plus_vduz2 
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
    lda.z res+2
    adc.z mb+2
    sta.z res+2
    lda.z res+3
    adc.z mb+3
    sta.z res+3
    // [1399] phi from mul16u::@2 mul16u::@4 to mul16u::@3 [phi:mul16u::@2/mul16u::@4->mul16u::@3]
    // [1399] phi mul16u::res#6 = mul16u::res#2 [phi:mul16u::@2/mul16u::@4->mul16u::@3#0] -- register_copy 
    // mul16u::@3
  __b3:
    // a = a>>1
    // [1400] mul16u::a#0 = mul16u::a#3 >> 1 -- vwuz1=vwuz1_ror_1 
    lsr.z a+1
    ror.z a
    // mb = mb<<1
    // [1401] mul16u::mb#1 = mul16u::mb#2 << 1 -- vduz1=vduz1_rol_1 
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    // [1393] phi from mul16u::@3 to mul16u::@1 [phi:mul16u::@3->mul16u::@1]
    // [1393] phi mul16u::mb#2 = mul16u::mb#1 [phi:mul16u::@3->mul16u::@1#0] -- register_copy 
    // [1393] phi mul16u::res#2 = mul16u::res#6 [phi:mul16u::@3->mul16u::@1#1] -- register_copy 
    // [1393] phi mul16u::a#3 = mul16u::a#0 [phi:mul16u::@3->mul16u::@1#2] -- register_copy 
    jmp __b1
}
  // vera_sprite_width
// vera_sprite_width(byte zp($7d) sprite, byte register(A) width)
vera_sprite_width: {
    .label vera_sprite_width_81___4 = $67
    .label vera_sprite_width_81___8 = $67
    .label vera_sprite_width_161___4 = $cc
    .label vera_sprite_width_161___8 = $cc
    .label vera_sprite_width_321___4 = $74
    .label vera_sprite_width_321___8 = $74
    .label vera_sprite_width_641___4 = $7b
    .label vera_sprite_width_641___8 = $7b
    .label vera_sprite_width_81_sprite_offset = $67
    .label vera_sprite_width_161_sprite_offset = $cc
    .label vera_sprite_width_321_sprite_offset = $74
    .label vera_sprite_width_641_sprite_offset = $7b
    .label sprite = $7d
    // case 8:
    //             vera_sprite_width_8(sprite);
    //             break;
    // [1402] if(vera_sprite_width::width#0==8) goto vera_sprite_width::vera_sprite_width_81 -- vbuaa_eq_vbuc1_then_la1 
    cmp #8
    bne !vera_sprite_width_81+
    jmp vera_sprite_width_81
  !vera_sprite_width_81:
    // vera_sprite_width::@1
    // case 16:
    //             vera_sprite_width_16(sprite);
    //             break;
    // [1403] if(vera_sprite_width::width#0==$10) goto vera_sprite_width::vera_sprite_width_161 -- vbuaa_eq_vbuc1_then_la1 
    cmp #$10
    bne !vera_sprite_width_161+
    jmp vera_sprite_width_161
  !vera_sprite_width_161:
    // vera_sprite_width::@2
    // case 32:
    //             vera_sprite_width_32(sprite);
    //             break;
    // [1404] if(vera_sprite_width::width#0==$20) goto vera_sprite_width::vera_sprite_width_321 -- vbuaa_eq_vbuc1_then_la1 
    cmp #$20
    beq vera_sprite_width_321
    // vera_sprite_width::@3
    // case 64:
    //             vera_sprite_width_64(sprite);
    //             break;
    // [1405] if(vera_sprite_width::width#0==$40) goto vera_sprite_width::vera_sprite_width_641 -- vbuaa_eq_vbuc1_then_la1 
    cmp #$40
    beq vera_sprite_width_641
    rts
    // vera_sprite_width::vera_sprite_width_641
  vera_sprite_width_641:
    // (word)sprite << 3
    // [1406] vera_sprite_width::vera_sprite_width_641_$8 = (word)vera_sprite_width::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_width_641___8
    lda #0
    sta.z vera_sprite_width_641___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1407] vera_sprite_width::vera_sprite_width_641_sprite_offset#0 = vera_sprite_width::vera_sprite_width_641_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_width_641_sprite_offset
    rol.z vera_sprite_width_641_sprite_offset+1
    asl.z vera_sprite_width_641_sprite_offset
    rol.z vera_sprite_width_641_sprite_offset+1
    asl.z vera_sprite_width_641_sprite_offset
    rol.z vera_sprite_width_641_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1408] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1409] vera_sprite_width::vera_sprite_width_641_$4 = vera_sprite_width::vera_sprite_width_641_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_width_641___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_641___4
    lda.z vera_sprite_width_641___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_641___4+1
    // <sprite_offset+7
    // [1410] vera_sprite_width::vera_sprite_width_641_$3 = < vera_sprite_width::vera_sprite_width_641_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_width_641___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1411] *VERA_ADDRX_L = vera_sprite_width::vera_sprite_width_641_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1412] vera_sprite_width::vera_sprite_width_641_$5 = > vera_sprite_width::vera_sprite_width_641_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_width_641___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1413] *VERA_ADDRX_M = vera_sprite_width::vera_sprite_width_641_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1414] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [1415] vera_sprite_width::vera_sprite_width_641_$6 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_WIDTH_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_64
    // [1416] vera_sprite_width::vera_sprite_width_641_$7 = vera_sprite_width::vera_sprite_width_641_$6 | VERA_SPRITE_WIDTH_64 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_WIDTH_64
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_64
    // [1417] *VERA_DATA0 = vera_sprite_width::vera_sprite_width_641_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // vera_sprite_width::@return
    // }
    // [1418] return 
    rts
    // vera_sprite_width::vera_sprite_width_321
  vera_sprite_width_321:
    // (word)sprite << 3
    // [1419] vera_sprite_width::vera_sprite_width_321_$8 = (word)vera_sprite_width::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_width_321___8
    lda #0
    sta.z vera_sprite_width_321___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1420] vera_sprite_width::vera_sprite_width_321_sprite_offset#0 = vera_sprite_width::vera_sprite_width_321_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_width_321_sprite_offset
    rol.z vera_sprite_width_321_sprite_offset+1
    asl.z vera_sprite_width_321_sprite_offset
    rol.z vera_sprite_width_321_sprite_offset+1
    asl.z vera_sprite_width_321_sprite_offset
    rol.z vera_sprite_width_321_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1421] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1422] vera_sprite_width::vera_sprite_width_321_$4 = vera_sprite_width::vera_sprite_width_321_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_width_321___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_321___4
    lda.z vera_sprite_width_321___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_321___4+1
    // <sprite_offset+7
    // [1423] vera_sprite_width::vera_sprite_width_321_$3 = < vera_sprite_width::vera_sprite_width_321_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_width_321___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1424] *VERA_ADDRX_L = vera_sprite_width::vera_sprite_width_321_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1425] vera_sprite_width::vera_sprite_width_321_$5 = > vera_sprite_width::vera_sprite_width_321_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_width_321___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1426] *VERA_ADDRX_M = vera_sprite_width::vera_sprite_width_321_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1427] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [1428] vera_sprite_width::vera_sprite_width_321_$6 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_WIDTH_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_32
    // [1429] vera_sprite_width::vera_sprite_width_321_$7 = vera_sprite_width::vera_sprite_width_321_$6 | VERA_SPRITE_WIDTH_32 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_WIDTH_32
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_32
    // [1430] *VERA_DATA0 = vera_sprite_width::vera_sprite_width_321_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    rts
    // vera_sprite_width::vera_sprite_width_161
  vera_sprite_width_161:
    // (word)sprite << 3
    // [1431] vera_sprite_width::vera_sprite_width_161_$8 = (word)vera_sprite_width::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_width_161___8
    lda #0
    sta.z vera_sprite_width_161___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1432] vera_sprite_width::vera_sprite_width_161_sprite_offset#0 = vera_sprite_width::vera_sprite_width_161_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_width_161_sprite_offset
    rol.z vera_sprite_width_161_sprite_offset+1
    asl.z vera_sprite_width_161_sprite_offset
    rol.z vera_sprite_width_161_sprite_offset+1
    asl.z vera_sprite_width_161_sprite_offset
    rol.z vera_sprite_width_161_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1433] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1434] vera_sprite_width::vera_sprite_width_161_$4 = vera_sprite_width::vera_sprite_width_161_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_width_161___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_161___4
    lda.z vera_sprite_width_161___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_161___4+1
    // <sprite_offset+7
    // [1435] vera_sprite_width::vera_sprite_width_161_$3 = < vera_sprite_width::vera_sprite_width_161_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_width_161___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1436] *VERA_ADDRX_L = vera_sprite_width::vera_sprite_width_161_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1437] vera_sprite_width::vera_sprite_width_161_$5 = > vera_sprite_width::vera_sprite_width_161_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_width_161___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1438] *VERA_ADDRX_M = vera_sprite_width::vera_sprite_width_161_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1439] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [1440] vera_sprite_width::vera_sprite_width_161_$6 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_WIDTH_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_16
    // [1441] vera_sprite_width::vera_sprite_width_161_$7 = vera_sprite_width::vera_sprite_width_161_$6 | VERA_SPRITE_WIDTH_16 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_WIDTH_16
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_16
    // [1442] *VERA_DATA0 = vera_sprite_width::vera_sprite_width_161_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    rts
    // vera_sprite_width::vera_sprite_width_81
  vera_sprite_width_81:
    // (word)sprite << 3
    // [1443] vera_sprite_width::vera_sprite_width_81_$8 = (word)vera_sprite_width::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_width_81___8
    lda #0
    sta.z vera_sprite_width_81___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1444] vera_sprite_width::vera_sprite_width_81_sprite_offset#0 = vera_sprite_width::vera_sprite_width_81_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_width_81_sprite_offset
    rol.z vera_sprite_width_81_sprite_offset+1
    asl.z vera_sprite_width_81_sprite_offset
    rol.z vera_sprite_width_81_sprite_offset+1
    asl.z vera_sprite_width_81_sprite_offset
    rol.z vera_sprite_width_81_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1445] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1446] vera_sprite_width::vera_sprite_width_81_$4 = vera_sprite_width::vera_sprite_width_81_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_width_81___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_81___4
    lda.z vera_sprite_width_81___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_81___4+1
    // <sprite_offset+7
    // [1447] vera_sprite_width::vera_sprite_width_81_$3 = < vera_sprite_width::vera_sprite_width_81_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_width_81___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1448] *VERA_ADDRX_L = vera_sprite_width::vera_sprite_width_81_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1449] vera_sprite_width::vera_sprite_width_81_$5 = > vera_sprite_width::vera_sprite_width_81_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_width_81___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1450] *VERA_ADDRX_M = vera_sprite_width::vera_sprite_width_81_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1451] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_8
    // [1452] vera_sprite_width::vera_sprite_width_81_$7 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_WIDTH_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_8
    // [1453] *VERA_DATA0 = vera_sprite_width::vera_sprite_width_81_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    rts
}
  // vera_sprite_zdepth
// vera_sprite_zdepth(byte zp($7d) sprite, byte register(A) zdepth)
vera_sprite_zdepth: {
    .label vera_sprite_zdepth_in_front1___4 = $74
    .label vera_sprite_zdepth_in_front1___8 = $74
    .label vera_sprite_zdepth_between_layer0_and_layer11___4 = $7b
    .label vera_sprite_zdepth_between_layer0_and_layer11___8 = $7b
    .label vera_sprite_zdepth_between_background_and_layer01___4 = $67
    .label vera_sprite_zdepth_between_background_and_layer01___8 = $67
    .label vera_sprite_zdepth_disable1___4 = $cc
    .label vera_sprite_zdepth_disable1___7 = $cc
    .label vera_sprite_zdepth_in_front1_sprite_offset = $74
    .label vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset = $7b
    .label vera_sprite_zdepth_between_background_and_layer01_sprite_offset = $67
    .label vera_sprite_zdepth_disable1_sprite_offset = $cc
    .label sprite = $7d
    // case 3:
    //             vera_sprite_zdepth_in_front(sprite);
    //             break;
    // [1454] if(vera_sprite_zdepth::zdepth#0==3) goto vera_sprite_zdepth::vera_sprite_zdepth_in_front1 -- vbuaa_eq_vbuc1_then_la1 
    cmp #3
    bne !vera_sprite_zdepth_in_front1+
    jmp vera_sprite_zdepth_in_front1
  !vera_sprite_zdepth_in_front1:
    // vera_sprite_zdepth::@1
    // case 2:
    //             vera_sprite_zdepth_between_layer0_and_layer1(sprite);
    //             break;
    // [1455] if(vera_sprite_zdepth::zdepth#0==2) goto vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11 -- vbuaa_eq_vbuc1_then_la1 
    cmp #2
    bne !vera_sprite_zdepth_between_layer0_and_layer11+
    jmp vera_sprite_zdepth_between_layer0_and_layer11
  !vera_sprite_zdepth_between_layer0_and_layer11:
    // vera_sprite_zdepth::@2
    // case 1:
    //             vera_sprite_zdepth_between_background_and_layer0(sprite);
    //             break;
    // [1456] if(vera_sprite_zdepth::zdepth#0==1) goto vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01 -- vbuaa_eq_vbuc1_then_la1 
    cmp #1
    beq vera_sprite_zdepth_between_background_and_layer01
    // vera_sprite_zdepth::@3
    // case 0:
    //             vera_sprite_zdepth_disable(sprite);
    //             break;
    // [1457] if(vera_sprite_zdepth::zdepth#0==0) goto vera_sprite_zdepth::vera_sprite_zdepth_disable1 -- vbuaa_eq_0_then_la1 
    cmp #0
    beq vera_sprite_zdepth_disable1
    rts
    // vera_sprite_zdepth::vera_sprite_zdepth_disable1
  vera_sprite_zdepth_disable1:
    // (word)sprite << 3
    // [1458] vera_sprite_zdepth::vera_sprite_zdepth_disable1_$7 = (word)vera_sprite_zdepth::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_zdepth_disable1___7
    lda #0
    sta.z vera_sprite_zdepth_disable1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1459] vera_sprite_zdepth::vera_sprite_zdepth_disable1_sprite_offset#0 = vera_sprite_zdepth::vera_sprite_zdepth_disable1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_zdepth_disable1_sprite_offset
    rol.z vera_sprite_zdepth_disable1_sprite_offset+1
    asl.z vera_sprite_zdepth_disable1_sprite_offset
    rol.z vera_sprite_zdepth_disable1_sprite_offset+1
    asl.z vera_sprite_zdepth_disable1_sprite_offset
    rol.z vera_sprite_zdepth_disable1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1460] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1461] vera_sprite_zdepth::vera_sprite_zdepth_disable1_$4 = vera_sprite_zdepth::vera_sprite_zdepth_disable1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_zdepth_disable1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_disable1___4
    lda.z vera_sprite_zdepth_disable1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_disable1___4+1
    // <sprite_offset+6
    // [1462] vera_sprite_zdepth::vera_sprite_zdepth_disable1_$3 = < vera_sprite_zdepth::vera_sprite_zdepth_disable1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_zdepth_disable1___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1463] *VERA_ADDRX_L = vera_sprite_zdepth::vera_sprite_zdepth_disable1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1464] vera_sprite_zdepth::vera_sprite_zdepth_disable1_$5 = > vera_sprite_zdepth::vera_sprite_zdepth_disable1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_zdepth_disable1___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1465] *VERA_ADDRX_M = vera_sprite_zdepth::vera_sprite_zdepth_disable1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1466] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [1467] vera_sprite_zdepth::vera_sprite_zdepth_disable1_$6 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_ZDEPTH_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [1468] *VERA_DATA0 = vera_sprite_zdepth::vera_sprite_zdepth_disable1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // vera_sprite_zdepth::@return
    // }
    // [1469] return 
    rts
    // vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01
  vera_sprite_zdepth_between_background_and_layer01:
    // (word)sprite << 3
    // [1470] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$8 = (word)vera_sprite_zdepth::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_zdepth_between_background_and_layer01___8
    lda #0
    sta.z vera_sprite_zdepth_between_background_and_layer01___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1471] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_sprite_offset#0 = vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_zdepth_between_background_and_layer01_sprite_offset
    rol.z vera_sprite_zdepth_between_background_and_layer01_sprite_offset+1
    asl.z vera_sprite_zdepth_between_background_and_layer01_sprite_offset
    rol.z vera_sprite_zdepth_between_background_and_layer01_sprite_offset+1
    asl.z vera_sprite_zdepth_between_background_and_layer01_sprite_offset
    rol.z vera_sprite_zdepth_between_background_and_layer01_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1472] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1473] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$4 = vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_zdepth_between_background_and_layer01___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_between_background_and_layer01___4
    lda.z vera_sprite_zdepth_between_background_and_layer01___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_between_background_and_layer01___4+1
    // <sprite_offset+6
    // [1474] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$3 = < vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_zdepth_between_background_and_layer01___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1475] *VERA_ADDRX_L = vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1476] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$5 = > vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_zdepth_between_background_and_layer01___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1477] *VERA_ADDRX_M = vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1478] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [1479] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$6 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_ZDEPTH_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0
    // [1480] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$7 = vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$6 | VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0
    // [1481] *VERA_DATA0 = vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    rts
    // vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11
  vera_sprite_zdepth_between_layer0_and_layer11:
    // (word)sprite << 3
    // [1482] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$8 = (word)vera_sprite_zdepth::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_zdepth_between_layer0_and_layer11___8
    lda #0
    sta.z vera_sprite_zdepth_between_layer0_and_layer11___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1483] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset#0 = vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset
    rol.z vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset+1
    asl.z vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset
    rol.z vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset+1
    asl.z vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset
    rol.z vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1484] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1485] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$4 = vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_zdepth_between_layer0_and_layer11___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_between_layer0_and_layer11___4
    lda.z vera_sprite_zdepth_between_layer0_and_layer11___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_between_layer0_and_layer11___4+1
    // <sprite_offset+6
    // [1486] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$3 = < vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_zdepth_between_layer0_and_layer11___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1487] *VERA_ADDRX_L = vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1488] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$5 = > vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_zdepth_between_layer0_and_layer11___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1489] *VERA_ADDRX_M = vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1490] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [1491] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$6 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_ZDEPTH_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1
    // [1492] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$7 = vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$6 | VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1
    // [1493] *VERA_DATA0 = vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    rts
    // vera_sprite_zdepth::vera_sprite_zdepth_in_front1
  vera_sprite_zdepth_in_front1:
    // (word)sprite << 3
    // [1494] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$8 = (word)vera_sprite_zdepth::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_zdepth_in_front1___8
    lda #0
    sta.z vera_sprite_zdepth_in_front1___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1495] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_sprite_offset#0 = vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_zdepth_in_front1_sprite_offset
    rol.z vera_sprite_zdepth_in_front1_sprite_offset+1
    asl.z vera_sprite_zdepth_in_front1_sprite_offset
    rol.z vera_sprite_zdepth_in_front1_sprite_offset+1
    asl.z vera_sprite_zdepth_in_front1_sprite_offset
    rol.z vera_sprite_zdepth_in_front1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1496] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1497] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$4 = vera_sprite_zdepth::vera_sprite_zdepth_in_front1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_zdepth_in_front1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_in_front1___4
    lda.z vera_sprite_zdepth_in_front1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_in_front1___4+1
    // <sprite_offset+6
    // [1498] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$3 = < vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_zdepth_in_front1___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1499] *VERA_ADDRX_L = vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1500] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$5 = > vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_zdepth_in_front1___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1501] *VERA_ADDRX_M = vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1502] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [1503] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$6 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_ZDEPTH_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_IN_FRONT
    // [1504] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$7 = vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$6 | VERA_SPRITE_ZDEPTH_IN_FRONT -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_ZDEPTH_IN_FRONT
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_IN_FRONT
    // [1505] *VERA_DATA0 = vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    rts
}
  // vera_sprite_hflip
// vera_sprite_hflip(byte zp($7e) sprite, byte register(A) hflip)
vera_sprite_hflip: {
    .label vera_sprite_hflip_on1___4 = $74
    .label vera_sprite_hflip_on1___7 = $74
    .label vera_sprite_hflip_off1___4 = $7b
    .label vera_sprite_hflip_off1___7 = $7b
    .label vera_sprite_hflip_on1_sprite_offset = $74
    .label vera_sprite_hflip_off1_sprite_offset = $7b
    .label sprite = $7e
    // if(hflip)
    // [1506] if(0!=vera_sprite_hflip::hflip#0) goto vera_sprite_hflip::vera_sprite_hflip_on1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne vera_sprite_hflip_on1
    // vera_sprite_hflip::vera_sprite_hflip_off1
    // (word)sprite << 3
    // [1507] vera_sprite_hflip::vera_sprite_hflip_off1_$7 = (word)vera_sprite_hflip::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_hflip_off1___7
    lda #0
    sta.z vera_sprite_hflip_off1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1508] vera_sprite_hflip::vera_sprite_hflip_off1_sprite_offset#0 = vera_sprite_hflip::vera_sprite_hflip_off1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_hflip_off1_sprite_offset
    rol.z vera_sprite_hflip_off1_sprite_offset+1
    asl.z vera_sprite_hflip_off1_sprite_offset
    rol.z vera_sprite_hflip_off1_sprite_offset+1
    asl.z vera_sprite_hflip_off1_sprite_offset
    rol.z vera_sprite_hflip_off1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1509] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1510] vera_sprite_hflip::vera_sprite_hflip_off1_$4 = vera_sprite_hflip::vera_sprite_hflip_off1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_hflip_off1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_hflip_off1___4
    lda.z vera_sprite_hflip_off1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_hflip_off1___4+1
    // <sprite_offset+6
    // [1511] vera_sprite_hflip::vera_sprite_hflip_off1_$3 = < vera_sprite_hflip::vera_sprite_hflip_off1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_hflip_off1___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1512] *VERA_ADDRX_L = vera_sprite_hflip::vera_sprite_hflip_off1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1513] vera_sprite_hflip::vera_sprite_hflip_off1_$5 = > vera_sprite_hflip::vera_sprite_hflip_off1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_hflip_off1___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1514] *VERA_ADDRX_M = vera_sprite_hflip::vera_sprite_hflip_off1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1515] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HFLIP
    // [1516] vera_sprite_hflip::vera_sprite_hflip_off1_$6 = *VERA_DATA0 & ~VERA_SPRITE_HFLIP -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HFLIP^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HFLIP
    // [1517] *VERA_DATA0 = vera_sprite_hflip::vera_sprite_hflip_off1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // vera_sprite_hflip::@return
    // }
    // [1518] return 
    rts
    // vera_sprite_hflip::vera_sprite_hflip_on1
  vera_sprite_hflip_on1:
    // (word)sprite << 3
    // [1519] vera_sprite_hflip::vera_sprite_hflip_on1_$7 = (word)vera_sprite_hflip::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_hflip_on1___7
    lda #0
    sta.z vera_sprite_hflip_on1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1520] vera_sprite_hflip::vera_sprite_hflip_on1_sprite_offset#0 = vera_sprite_hflip::vera_sprite_hflip_on1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_hflip_on1_sprite_offset
    rol.z vera_sprite_hflip_on1_sprite_offset+1
    asl.z vera_sprite_hflip_on1_sprite_offset
    rol.z vera_sprite_hflip_on1_sprite_offset+1
    asl.z vera_sprite_hflip_on1_sprite_offset
    rol.z vera_sprite_hflip_on1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1521] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1522] vera_sprite_hflip::vera_sprite_hflip_on1_$4 = vera_sprite_hflip::vera_sprite_hflip_on1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_hflip_on1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_hflip_on1___4
    lda.z vera_sprite_hflip_on1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_hflip_on1___4+1
    // <sprite_offset+6
    // [1523] vera_sprite_hflip::vera_sprite_hflip_on1_$3 = < vera_sprite_hflip::vera_sprite_hflip_on1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_hflip_on1___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1524] *VERA_ADDRX_L = vera_sprite_hflip::vera_sprite_hflip_on1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1525] vera_sprite_hflip::vera_sprite_hflip_on1_$5 = > vera_sprite_hflip::vera_sprite_hflip_on1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_hflip_on1___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1526] *VERA_ADDRX_M = vera_sprite_hflip::vera_sprite_hflip_on1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1527] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 | VERA_SPRITE_HFLIP
    // [1528] vera_sprite_hflip::vera_sprite_hflip_on1_$6 = *VERA_DATA0 | VERA_SPRITE_HFLIP -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITE_HFLIP
    ora VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 | VERA_SPRITE_HFLIP
    // [1529] *VERA_DATA0 = vera_sprite_hflip::vera_sprite_hflip_on1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    rts
}
  // vera_sprite_vflip
// vera_sprite_vflip(byte zp($7e) sprite, byte register(A) vflip)
vera_sprite_vflip: {
    .label vera_sprite_vflip_on1___4 = $cc
    .label vera_sprite_vflip_on1___7 = $cc
    .label vera_sprite_vflip_off1___4 = $67
    .label vera_sprite_vflip_off1___7 = $67
    .label vera_sprite_vflip_on1_sprite_offset = $cc
    .label vera_sprite_vflip_off1_sprite_offset = $67
    .label sprite = $7e
    // if(vflip)
    // [1530] if(0!=vera_sprite_vflip::vflip#0) goto vera_sprite_vflip::vera_sprite_vflip_on1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne vera_sprite_vflip_on1
    // vera_sprite_vflip::vera_sprite_vflip_off1
    // (word)sprite << 3
    // [1531] vera_sprite_vflip::vera_sprite_vflip_off1_$7 = (word)vera_sprite_vflip::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_vflip_off1___7
    lda #0
    sta.z vera_sprite_vflip_off1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1532] vera_sprite_vflip::vera_sprite_vflip_off1_sprite_offset#0 = vera_sprite_vflip::vera_sprite_vflip_off1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_vflip_off1_sprite_offset
    rol.z vera_sprite_vflip_off1_sprite_offset+1
    asl.z vera_sprite_vflip_off1_sprite_offset
    rol.z vera_sprite_vflip_off1_sprite_offset+1
    asl.z vera_sprite_vflip_off1_sprite_offset
    rol.z vera_sprite_vflip_off1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1533] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1534] vera_sprite_vflip::vera_sprite_vflip_off1_$4 = vera_sprite_vflip::vera_sprite_vflip_off1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_vflip_off1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_vflip_off1___4
    lda.z vera_sprite_vflip_off1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_vflip_off1___4+1
    // <sprite_offset+6
    // [1535] vera_sprite_vflip::vera_sprite_vflip_off1_$3 = < vera_sprite_vflip::vera_sprite_vflip_off1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_vflip_off1___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1536] *VERA_ADDRX_L = vera_sprite_vflip::vera_sprite_vflip_off1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1537] vera_sprite_vflip::vera_sprite_vflip_off1_$5 = > vera_sprite_vflip::vera_sprite_vflip_off1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_vflip_off1___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1538] *VERA_ADDRX_M = vera_sprite_vflip::vera_sprite_vflip_off1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1539] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_VFLIP
    // [1540] vera_sprite_vflip::vera_sprite_vflip_off1_$6 = *VERA_DATA0 & ~VERA_SPRITE_VFLIP -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_VFLIP^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_VFLIP
    // [1541] *VERA_DATA0 = vera_sprite_vflip::vera_sprite_vflip_off1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // vera_sprite_vflip::@return
    // }
    // [1542] return 
    rts
    // vera_sprite_vflip::vera_sprite_vflip_on1
  vera_sprite_vflip_on1:
    // (word)sprite << 3
    // [1543] vera_sprite_vflip::vera_sprite_vflip_on1_$7 = (word)vera_sprite_vflip::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_vflip_on1___7
    lda #0
    sta.z vera_sprite_vflip_on1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1544] vera_sprite_vflip::vera_sprite_vflip_on1_sprite_offset#0 = vera_sprite_vflip::vera_sprite_vflip_on1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_vflip_on1_sprite_offset
    rol.z vera_sprite_vflip_on1_sprite_offset+1
    asl.z vera_sprite_vflip_on1_sprite_offset
    rol.z vera_sprite_vflip_on1_sprite_offset+1
    asl.z vera_sprite_vflip_on1_sprite_offset
    rol.z vera_sprite_vflip_on1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1545] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1546] vera_sprite_vflip::vera_sprite_vflip_on1_$4 = vera_sprite_vflip::vera_sprite_vflip_on1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_vflip_on1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_vflip_on1___4
    lda.z vera_sprite_vflip_on1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_vflip_on1___4+1
    // <sprite_offset+6
    // [1547] vera_sprite_vflip::vera_sprite_vflip_on1_$3 = < vera_sprite_vflip::vera_sprite_vflip_on1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_vflip_on1___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1548] *VERA_ADDRX_L = vera_sprite_vflip::vera_sprite_vflip_on1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1549] vera_sprite_vflip::vera_sprite_vflip_on1_$5 = > vera_sprite_vflip::vera_sprite_vflip_on1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_vflip_on1___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1550] *VERA_ADDRX_M = vera_sprite_vflip::vera_sprite_vflip_on1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1551] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 | VERA_SPRITE_VFLIP
    // [1552] vera_sprite_vflip::vera_sprite_vflip_on1_$6 = *VERA_DATA0 | VERA_SPRITE_VFLIP -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITE_VFLIP
    ora VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 | VERA_SPRITE_VFLIP
    // [1553] *VERA_DATA0 = vera_sprite_vflip::vera_sprite_vflip_on1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
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
    .label addr = $d2
    // addr = vera_layer_config[layer]
    // [1555] vera_layer_get_color::$3 = vera_layer_get_color::layer#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [1556] vera_layer_get_color::addr#0 = vera_layer_config[vera_layer_get_color::$3] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr & VERA_LAYER_CONFIG_256C
    // [1557] vera_layer_get_color::$0 = *vera_layer_get_color::addr#0 & VERA_LAYER_CONFIG_256C -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C
    ldy #0
    and (addr),y
    // if( *addr & VERA_LAYER_CONFIG_256C )
    // [1558] if(0!=vera_layer_get_color::$0) goto vera_layer_get_color::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // vera_layer_get_color::@2
    // vera_layer_backcolor[layer] << 4
    // [1559] vera_layer_get_color::$1 = vera_layer_backcolor[vera_layer_get_color::layer#2] << 4 -- vbuaa=pbuc1_derefidx_vbuxx_rol_4 
    lda vera_layer_backcolor,x
    asl
    asl
    asl
    asl
    // return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
    // [1560] vera_layer_get_color::return#1 = vera_layer_get_color::$1 | vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuaa=vbuaa_bor_pbuc1_derefidx_vbuxx 
    ora vera_layer_textcolor,x
    // [1561] phi from vera_layer_get_color::@1 vera_layer_get_color::@2 to vera_layer_get_color::@return [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return]
    // [1561] phi vera_layer_get_color::return#2 = vera_layer_get_color::return#0 [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return#0] -- register_copy 
    // vera_layer_get_color::@return
    // }
    // [1562] return 
    rts
    // vera_layer_get_color::@1
  __b1:
    // return (vera_layer_textcolor[layer]);
    // [1563] vera_layer_get_color::return#0 = vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_textcolor,x
    rts
}
  // cputln
// Print a newline
cputln: {
    .label temp = $ce
    // temp = conio_line_text[cx16_conio.conio_screen_layer]
    // [1564] cputln::$2 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // [1565] cputln::temp#0 = conio_line_text[cputln::$2] -- vwuz1=pwuc1_derefidx_vbuaa 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda conio_line_text,y
    sta.z temp
    lda conio_line_text+1,y
    sta.z temp+1
    // temp += cx16_conio.conio_rowskip
    // [1566] cputln::temp#1 = cputln::temp#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z temp
    sta.z temp
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z temp+1
    sta.z temp+1
    // conio_line_text[cx16_conio.conio_screen_layer] = temp
    // [1567] cputln::$3 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // [1568] conio_line_text[cputln::$3] = cputln::temp#1 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z temp
    sta conio_line_text,y
    lda.z temp+1
    sta conio_line_text+1,y
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [1569] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer]++;
    // [1570] conio_cursor_y[*((byte*)&cx16_conio)] = ++ conio_cursor_y[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    lda conio_cursor_y,x
    inc
    sta conio_cursor_y,y
    // cscroll()
    // [1571] call cscroll 
    jsr cscroll
    // cputln::@return
    // }
    // [1572] return 
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
// ultoa_append(byte* zp($d2) buffer, dword zp(5) value, dword zp($b6) sub)
ultoa_append: {
    .label buffer = $d2
    .label value = 5
    .label sub = $b6
    .label return = 5
    // [1574] phi from ultoa_append to ultoa_append::@1 [phi:ultoa_append->ultoa_append::@1]
    // [1574] phi ultoa_append::digit#2 = 0 [phi:ultoa_append->ultoa_append::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [1574] phi ultoa_append::value#2 = ultoa_append::value#0 [phi:ultoa_append->ultoa_append::@1#1] -- register_copy 
    // ultoa_append::@1
  __b1:
    // while (value >= sub)
    // [1575] if(ultoa_append::value#2>=ultoa_append::sub#0) goto ultoa_append::@2 -- vduz1_ge_vduz2_then_la1 
    lda.z value+3
    cmp.z sub+3
    bcc !+
    bne __b2
    lda.z value+2
    cmp.z sub+2
    bcc !+
    bne __b2
    lda.z value+1
    cmp.z sub+1
    bcc !+
    bne __b2
    lda.z value
    cmp.z sub
    bcs __b2
  !:
    // ultoa_append::@3
    // *buffer = DIGITS[digit]
    // [1576] *ultoa_append::buffer#0 = DIGITS[ultoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // ultoa_append::@return
    // }
    // [1577] return 
    rts
    // ultoa_append::@2
  __b2:
    // digit++;
    // [1578] ultoa_append::digit#1 = ++ ultoa_append::digit#2 -- vbuxx=_inc_vbuxx 
    inx
    // value -= sub
    // [1579] ultoa_append::value#1 = ultoa_append::value#2 - ultoa_append::sub#0 -- vduz1=vduz1_minus_vduz2 
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    lda.z value+2
    sbc.z sub+2
    sta.z value+2
    lda.z value+3
    sbc.z sub+3
    sta.z value+3
    // [1574] phi from ultoa_append::@2 to ultoa_append::@1 [phi:ultoa_append::@2->ultoa_append::@1]
    // [1574] phi ultoa_append::digit#2 = ultoa_append::digit#1 [phi:ultoa_append::@2->ultoa_append::@1#0] -- register_copy 
    // [1574] phi ultoa_append::value#2 = ultoa_append::value#1 [phi:ultoa_append::@2->ultoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // utoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// utoa_append(byte* zp($45) buffer, word zp($34) value, word zp($ba) sub)
utoa_append: {
    .label buffer = $45
    .label value = $34
    .label sub = $ba
    .label return = $34
    // [1581] phi from utoa_append to utoa_append::@1 [phi:utoa_append->utoa_append::@1]
    // [1581] phi utoa_append::digit#2 = 0 [phi:utoa_append->utoa_append::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [1581] phi utoa_append::value#2 = utoa_append::value#0 [phi:utoa_append->utoa_append::@1#1] -- register_copy 
    // utoa_append::@1
  __b1:
    // while (value >= sub)
    // [1582] if(utoa_append::value#2>=utoa_append::sub#0) goto utoa_append::@2 -- vwuz1_ge_vwuz2_then_la1 
    lda.z sub+1
    cmp.z value+1
    bne !+
    lda.z sub
    cmp.z value
    beq __b2
  !:
    bcc __b2
    // utoa_append::@3
    // *buffer = DIGITS[digit]
    // [1583] *utoa_append::buffer#0 = DIGITS[utoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // utoa_append::@return
    // }
    // [1584] return 
    rts
    // utoa_append::@2
  __b2:
    // digit++;
    // [1585] utoa_append::digit#1 = ++ utoa_append::digit#2 -- vbuxx=_inc_vbuxx 
    inx
    // value -= sub
    // [1586] utoa_append::value#1 = utoa_append::value#2 - utoa_append::sub#0 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    // [1581] phi from utoa_append::@2 to utoa_append::@1 [phi:utoa_append::@2->utoa_append::@1]
    // [1581] phi utoa_append::digit#2 = utoa_append::digit#1 [phi:utoa_append::@2->utoa_append::@1#0] -- register_copy 
    // [1581] phi utoa_append::value#2 = utoa_append::value#1 [phi:utoa_append::@2->utoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($a9) str)
strlen: {
    .label len = $af
    .label str = $a9
    .label return = $af
    // [1588] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [1588] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z len
    sta.z len+1
    // [1588] phi strlen::str#4 = strlen::str#1 [phi:strlen->strlen::@1#1] -- register_copy 
    // strlen::@1
  __b1:
    // while(*str)
    // [1589] if(0!=*strlen::str#4) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [1590] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [1591] strlen::len#1 = ++ strlen::len#2 -- vwuz1=_inc_vwuz1 
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    // [1592] strlen::str#0 = ++ strlen::str#4 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [1588] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [1588] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [1588] phi strlen::str#4 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
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
// uctoa_append(byte* zp($c2) buffer, byte register(X) value, byte zp($6d) sub)
uctoa_append: {
    .label buffer = $c2
    .label sub = $6d
    // [1594] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [1594] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbuyy=vbuc1 
    ldy #0
    // [1594] phi uctoa_append::value#2 = uctoa_append::value#0 [phi:uctoa_append->uctoa_append::@1#1] -- register_copy 
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [1595] if(uctoa_append::value#2>=uctoa_append::sub#0) goto uctoa_append::@2 -- vbuxx_ge_vbuz1_then_la1 
    cpx.z sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [1596] *uctoa_append::buffer#0 = DIGITS[uctoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuyy 
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // uctoa_append::@return
    // }
    // [1597] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [1598] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbuyy=_inc_vbuyy 
    iny
    // value -= sub
    // [1599] uctoa_append::value#1 = uctoa_append::value#2 - uctoa_append::sub#0 -- vbuxx=vbuxx_minus_vbuz1 
    txa
    sec
    sbc.z sub
    tax
    // [1594] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [1594] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    // [1594] phi uctoa_append::value#2 = uctoa_append::value#1 [phi:uctoa_append::@2->uctoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // vera_heap_block_is_empty
// vera_heap_block_is_empty(struct vera_heap* zp($72) block)
vera_heap_block_is_empty: {
    .label sz = $67
    .label return = $67
    .label block = $72
    // sz = block->size
    // [1600] vera_heap_block_is_empty::sz#0 = ((word*)vera_heap_block_is_empty::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] -- vwuz1=pwuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    sta.z sz
    iny
    lda (block),y
    sta.z sz+1
    // sz & ~VERA_HEAP_EMPTY
    // [1601] vera_heap_block_is_empty::return#0 = vera_heap_block_is_empty::sz#0 & ~VERA_HEAP_EMPTY -- vwuz1=vwuz1_band_vwuc1 
    lda.z return
    and #<VERA_HEAP_EMPTY^$ffff
    sta.z return
    lda.z return+1
    and #>VERA_HEAP_EMPTY^$ffff
    sta.z return+1
    // vera_heap_block_is_empty::@return
    // }
    // [1602] return 
    rts
}
  // vera_heap_block_size_get
// vera_heap_block_size_get(struct vera_heap* zp($65) block)
vera_heap_block_size_get: {
    .label __0 = $67
    .label __2 = $65
    .label return = $c8
    .label block = $65
    // block->size & ~VERA_HEAP_SIZE_16
    // [1603] vera_heap_block_size_get::$0 = ((word*)vera_heap_block_size_get::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_SIZE_16 -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_SIZE_16^$ffff
    sta.z __0
    iny
    lda (block),y
    and #>VERA_HEAP_SIZE_16^$ffff
    sta.z __0+1
    // (block->size & ~VERA_HEAP_SIZE_16)?0x10000:0x00000 | block->size
    // [1604] if(0!=vera_heap_block_size_get::$0) goto vera_heap_block_size_get::@2 -- 0_neq_vwuz1_then_la1 
    lda.z __0
    ora.z __0+1
    bne __b1
    // vera_heap_block_size_get::@1
    // [1605] vera_heap_block_size_get::$2 = ((word*)vera_heap_block_size_get::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] -- vwuz1=pwuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (__2),y
    pha
    iny
    lda (__2),y
    sta.z __2+1
    pla
    sta.z __2
    // [1606] phi from vera_heap_block_size_get::@1 to vera_heap_block_size_get::@2 [phi:vera_heap_block_size_get::@1->vera_heap_block_size_get::@2]
    // [1606] phi vera_heap_block_size_get::return#0 = vera_heap_block_size_get::$2 [phi:vera_heap_block_size_get::@1->vera_heap_block_size_get::@2#0] -- vduz1=vwuz2 
    sta.z return
    lda.z __2+1
    sta.z return+1
    lda #0
    sta.z return+2
    sta.z return+3
    rts
    // [1606] phi from vera_heap_block_size_get to vera_heap_block_size_get::@2 [phi:vera_heap_block_size_get->vera_heap_block_size_get::@2]
  __b1:
    // [1606] phi vera_heap_block_size_get::return#0 = $10000 [phi:vera_heap_block_size_get->vera_heap_block_size_get::@2#0] -- vduz1=vduc1 
    lda #<$10000
    sta.z return
    lda #>$10000
    sta.z return+1
    lda #<$10000>>$10
    sta.z return+2
    lda #>$10000>>$10
    sta.z return+3
    // vera_heap_block_size_get::@2
    // vera_heap_block_size_get::@return
    // }
    // [1607] return 
    rts
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [1608] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    ldy cx16_conio
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b3
    // cscroll::@1
    // if(conio_scroll_enable[cx16_conio.conio_screen_layer])
    // [1609] if(0!=conio_scroll_enable[*((byte*)&cx16_conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    lda conio_scroll_enable,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [1610] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    // [1611] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
  __b3:
    // cscroll::@return
    // }
    // [1612] return 
    rts
    // [1613] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [1614] call insertup 
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, cx16_conio.conio_screen_height-1)
    // [1615] gotoxy::y#2 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuxx=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    // [1616] call gotoxy 
    // [330] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [330] phi gotoxy::y#7 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    jsr gotoxy
    rts
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label cy = $d0
    .label width = $d1
    .label line = $b2
    .label start = $b2
    // cy = conio_cursor_y[cx16_conio.conio_screen_layer]
    // [1617] insertup::cy#0 = conio_cursor_y[*((byte*)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy cx16_conio
    lda conio_cursor_y,y
    sta.z cy
    // width = cx16_conio.conio_screen_width * 2
    // [1618] insertup::width#0 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    asl
    sta.z width
    // [1619] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [1619] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuxx=vbuc1 
    ldx #1
    // insertup::@1
  __b1:
    // for(unsigned byte i=1; i<=cy; i++)
    // [1620] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuxx_le_vbuz1_then_la1 
    lda.z cy
    stx.z $ff
    cmp.z $ff
    bcs __b2
    // [1621] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [1622] call clearline 
    jsr clearline
    // insertup::@return
    // }
    // [1623] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [1624] insertup::$3 = insertup::i#2 - 1 -- vbuaa=vbuxx_minus_1 
    txa
    sec
    sbc #1
    // line = (i-1) << cx16_conio.conio_rowshift
    // [1625] insertup::line#0 = insertup::$3 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vbuaa_rol__deref_pbuc1 
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
    // start = cx16_conio.conio_screen_text + line
    // [1626] insertup::start#0 = *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) + insertup::line#0 -- pbuz1=_deref_qbuc1_plus_vwuz1 
    clc
    lda.z start
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z start
    lda.z start+1
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z start+1
    // start+cx16_conio.conio_rowskip
    // [1627] memcpy_in_vram::src#0 = insertup::start#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- pbuz1=pbuz2_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z start
    sta.z memcpy_in_vram.src
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z start+1
    sta.z memcpy_in_vram.src+1
    // memcpy_in_vram(0, start, VERA_INC_1,  0, start+cx16_conio.conio_rowskip, VERA_INC_1, width)
    // [1628] memcpy_in_vram::dest#0 = (void*)insertup::start#0
    // [1629] memcpy_in_vram::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z memcpy_in_vram.num
    lda #0
    sta.z memcpy_in_vram.num+1
    // [1630] call memcpy_in_vram 
    jsr memcpy_in_vram
    // insertup::@4
    // for(unsigned byte i=1; i<=cy; i++)
    // [1631] insertup::i#1 = ++ insertup::i#2 -- vbuxx=_inc_vbuxx 
    inx
    // [1619] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [1619] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
}
  // clearline
clearline: {
    .label conio_line = $b4
    .label addr = $b4
    .label c = $b2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1632] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // conio_line = conio_line_text[cx16_conio.conio_screen_layer]
    // [1633] clearline::$5 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // [1634] clearline::conio_line#0 = conio_line_text[clearline::$5] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda conio_line_text,y
    sta.z conio_line
    lda conio_line_text+1,y
    sta.z conio_line+1
    // conio_screen_text + conio_line
    // [1635] clearline::addr#0 = (word)*((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) + clearline::conio_line#0 -- vwuz1=_deref_pwuc1_plus_vwuz1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    adc.z addr
    sta.z addr
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    adc.z addr+1
    sta.z addr+1
    // <addr
    // [1636] clearline::$1 = < (byte*)clearline::addr#0 -- vbuaa=_lo_pbuz1 
    lda.z addr
    // *VERA_ADDRX_L = <addr
    // [1637] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >addr
    // [1638] clearline::$2 = > (byte*)clearline::addr#0 -- vbuaa=_hi_pbuz1 
    lda.z addr+1
    // *VERA_ADDRX_M = >addr
    // [1639] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [1640] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1641] vera_layer_get_color::layer#1 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [1642] call vera_layer_get_color 
    // [1554] phi from clearline to vera_layer_get_color [phi:clearline->vera_layer_get_color]
    // [1554] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#1 [phi:clearline->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1643] vera_layer_get_color::return#4 = vera_layer_get_color::return#2
    // clearline::@4
    // color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1644] clearline::color#0 = vera_layer_get_color::return#4 -- vbuxx=vbuaa 
    tax
    // [1645] phi from clearline::@4 to clearline::@1 [phi:clearline::@4->clearline::@1]
    // [1645] phi clearline::c#2 = 0 [phi:clearline::@4->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [1646] if(clearline::c#2<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto clearline::@2 -- vwuz1_lt__deref_pbuc1_then_la1 
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
    // [1647] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // clearline::@return
    // }
    // [1648] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [1649] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [1650] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [1651] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [1645] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [1645] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
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
// memcpy_in_vram(void* zp($b2) dest, byte* zp($b4) src, word zp($d2) num)
memcpy_in_vram: {
    .label i = $b2
    .label dest = $b2
    .label src = $b4
    .label num = $d2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1652] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <src
    // [1653] memcpy_in_vram::$0 = < (void*)memcpy_in_vram::src#0 -- vbuaa=_lo_pvoz1 
    lda.z src
    // *VERA_ADDRX_L = <src
    // [1654] *VERA_ADDRX_L = memcpy_in_vram::$0 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >src
    // [1655] memcpy_in_vram::$1 = > (void*)memcpy_in_vram::src#0 -- vbuaa=_hi_pvoz1 
    lda.z src+1
    // *VERA_ADDRX_M = >src
    // [1656] *VERA_ADDRX_M = memcpy_in_vram::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = src_increment | src_bank
    // [1657] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [1658] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    // Select DATA1
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // <dest
    // [1659] memcpy_in_vram::$3 = < memcpy_in_vram::dest#0 -- vbuaa=_lo_pvoz1 
    lda.z dest
    // *VERA_ADDRX_L = <dest
    // [1660] *VERA_ADDRX_L = memcpy_in_vram::$3 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >dest
    // [1661] memcpy_in_vram::$4 = > memcpy_in_vram::dest#0 -- vbuaa=_hi_pvoz1 
    lda.z dest+1
    // *VERA_ADDRX_M = >dest
    // [1662] *VERA_ADDRX_M = memcpy_in_vram::$4 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = dest_increment | dest_bank
    // [1663] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // [1664] phi from memcpy_in_vram to memcpy_in_vram::@1 [phi:memcpy_in_vram->memcpy_in_vram::@1]
    // [1664] phi memcpy_in_vram::i#2 = 0 [phi:memcpy_in_vram->memcpy_in_vram::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // memcpy_in_vram::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [1665] if(memcpy_in_vram::i#2<memcpy_in_vram::num#0) goto memcpy_in_vram::@2 -- vwuz1_lt_vwuz2_then_la1 
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
    // [1666] return 
    rts
    // memcpy_in_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [1667] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [1668] memcpy_in_vram::i#1 = ++ memcpy_in_vram::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [1664] phi from memcpy_in_vram::@2 to memcpy_in_vram::@1 [phi:memcpy_in_vram::@2->memcpy_in_vram::@1]
    // [1664] phi memcpy_in_vram::i#2 = memcpy_in_vram::i#1 [phi:memcpy_in_vram::@2->memcpy_in_vram::@1#0] -- register_copy 
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
  vera_layer_enable: .byte VERA_LAYER0_ENABLE, VERA_LAYER1_ENABLE
  vera_layer_mapbase: .word VERA_L0_MAPBASE, VERA_L1_MAPBASE
  vera_layer_tilebase: .word VERA_L0_TILEBASE, VERA_L1_TILEBASE
  vera_layer_vscroll_l: .word VERA_L0_VSCROLL_L, VERA_L1_VSCROLL_L
  vera_layer_vscroll_h: .word VERA_L0_VSCROLL_H, VERA_L1_VSCROLL_H
  vera_layer_textcolor: .byte WHITE, WHITE
  vera_layer_backcolor: .byte BLUE, BLUE
  // Upper ram bank of CX16 512K system.
  vera_heap_segments: .fill $16*$10, 0
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
  // Values of binary digits
  RADIX_BINARY_VALUES_CHAR: .byte $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES_CHAR: .byte $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_LONG: .dword $10000000, $1000000, $100000, $10000, $1000, $100, $10
  SpriteDB: .fill 2*2, 0
  // TODO: BUG! This is not compiling correctly! __mem struct Tile *TileDB[3] = {&SquareMetal, &TileMetal, &SquareRaster};
  TileDB: .fill 2*3, 0
  FILE_PALETTES: .text "PALETTES"
  .byte 0
  s: .text "error file "
  .byte 0
  s1: .text ": "
  .byte 0
  s2: .text @"\n"
  .byte 0
  cx16_conio: .fill SIZEOF_STRUCT_CX16_CONIO, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
  SpritesPlayer: .text "PLAYER"
  .byte 0
  .fill 9, 0
  .byte 0, $c
  .word $20*$20*$c/2, $200
  .byte $20, $20, 0, 1, 3, 4, 1
  .dword 0, 0
  .fill 4*$b, 0
  SpritesEnemy2: .text "ENEMY2"
  .byte 0
  .fill 9, 0
  .byte $c, $c
  .word $20*$20*$c/2, $200
  .byte $20, $20, 0, 0, 3, 4, 2
  .dword 0, 0
  .fill 4*$b, 0
  SquareMetal: .text "SQUAREMETAL"
  .byte 0
  .fill 4, 0
  .word 0
  .byte 4
  .word $40*$40*4/2, $800
  .byte $40, $10, 4, 4, 4
  .dword 0, 0
  .fill 4*$b, 0
  TileMetal: .text "TILEMETAL"
  .byte 0
  .fill 6, 0
  .word $40
  .byte 4
  .word $40*$40*4/2, $800
  .byte $40, $10, 4, 4, 5
  .dword 0, 0
  .fill 4*$b, 0
  SquareRaster: .text "SQUARERASTER"
  .byte 0
  .fill 3, 0
  .word $80
  .byte 4
  .word $40*$40*4/2, $800
  .byte $40, $10, 4, 4, 6
  .dword 0, 0
  .fill 4*$b, 0
  i: .byte 0
  j: .byte 0
  a: .byte 4
  row: .word 5
  vscroll: .word $80*5
  scroll_action: .word 2
  bram_sprites_ceil: .dword 0
  .label bram_tiles_ceil = bram_sprites_ceil
  .label bram_palette = bram_sprites_ceil
