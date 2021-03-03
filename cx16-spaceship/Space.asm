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
  .const NUM_PLAYER = $c
  .const NUM_ENEMY2 = $c
  .const NUM_SQUAREMETAL = 4
  .const NUM_TILEMETAL = 4
  .const NUM_SQUARERASTER = 4
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
  .const OFFSET_STRUCT_TILE_TOTAL = $14
  .const OFFSET_STRUCT_TILE_COUNT = $15
  .const OFFSET_STRUCT_TILE_COLUMNS = $17
  .const OFFSET_STRUCT_TILE_PALETTE = $18
  .const OFFSET_STRUCT_SPRITE_OFFSET = $10
  .const OFFSET_STRUCT_SPRITE_COUNT = $12
  .const OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES = $1e
  .const OFFSET_STRUCT_SPRITE_BPP = $18
  .const OFFSET_STRUCT_SPRITE_HEIGHT = $14
  .const OFFSET_STRUCT_SPRITE_WIDTH = $13
  .const OFFSET_STRUCT_SPRITE_ZDEPTH = $17
  .const OFFSET_STRUCT_SPRITE_HFLIP = $15
  .const OFFSET_STRUCT_SPRITE_VFLIP = $16
  .const OFFSET_STRUCT_SPRITE_PALETTE = $19
  .const OFFSET_STRUCT_SPRITE_BRAM_ADDRESS = $1a
  .const OFFSET_STRUCT_TILE_BRAM_ADDRESS = $19
  .const OFFSET_STRUCT_TILE_VRAM_ADDRESSES = $1d
  .const OFFSET_STRUCT_SPRITE_SIZE = $11
  .const OFFSET_STRUCT_TILE_SIZE = $12
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
  .label i = $2a
  .label j = $2b
  .label a = $2c
  .label vscroll = $2d
  .label scroll_action = $2f
  // The random state variable
  .label rand_state = $1c
  // Remainder after unsigned 16-bit division
  .label rem16u = $1e
.segment Code
  // __start
__start: {
    // __start::__init1
    // i = 0
    // [1] i = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // j = 0
    // [2] j = 0 -- vbuz1=vbuc1 
    sta.z j
    // a = 4
    // [3] a = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z a
    // vscroll = 0
    // [4] vscroll = 0 -- vwuz1=vwuc1 
    lda #<0
    sta.z vscroll
    sta.z vscroll+1
    // scroll_action = 2
    // [5] scroll_action = 2 -- vwuz1=vwuc1 
    lda #<2
    sta.z scroll_action
    lda #>2
    sta.z scroll_action+1
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [6] call conio_x16_init 
    jsr conio_x16_init
    // [7] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [8] call main 
    jsr main
    // __start::@return
    // [9] return 
    rts
}
  // irq_vsync
//VSYNC Interrupt Routine
irq_vsync: {
    .label __2 = $31
    .label __12 = $33
    .label __15 = $35
    .label __17 = $37
    .label __23 = $31
    .label __28 = $39
    .label vera_layer_set_vertical_scroll1___0 = 3
    .label vera_layer_set_vertical_scroll1___1 = 3
    .label vera_layer_set_vertical_scroll1_scroll = $31
    .label rnd = $39
    .label c = 4
    .label r = 3
    // interrupt(isr_rom_sys_cx16_entry) -- isr_rom_sys_cx16_entry 
    // a--;
    // [11] a = -- a -- vbuz1=_dec_vbuz1 
    dec.z a
    // if(a==0)
    // [12] if(a!=0) goto irq_vsync::@1 -- vbuz1_neq_0_then_la1 
    lda.z a
    cmp #0
    bne __b1
    // irq_vsync::@3
    // a=4
    // [13] a = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z a
    // rotate_sprites(i,  SpriteDB[SPRITE_PLAYER], 40, 100)
    // [14] rotate_sprites::rotate#0 = i -- vwuz1=vbuz2 
    lda.z i
    sta.z rotate_sprites.rotate
    lda #0
    sta.z rotate_sprites.rotate+1
    // [15] rotate_sprites::Sprite#0 = *SpriteDB -- pssz1=_deref_qssc1 
    lda SpriteDB
    sta.z rotate_sprites.Sprite
    lda SpriteDB+1
    sta.z rotate_sprites.Sprite+1
    // [16] call rotate_sprites 
    // [202] phi from irq_vsync::@3 to rotate_sprites [phi:irq_vsync::@3->rotate_sprites]
    // [202] phi rotate_sprites::basex#8 = $28 [phi:irq_vsync::@3->rotate_sprites#0] -- vwuz1=vbuc1 
    lda #<$28
    sta.z rotate_sprites.basex
    lda #>$28
    sta.z rotate_sprites.basex+1
    // [202] phi rotate_sprites::rotate#4 = rotate_sprites::rotate#0 [phi:irq_vsync::@3->rotate_sprites#1] -- register_copy 
    // [202] phi rotate_sprites::Sprite#2 = rotate_sprites::Sprite#0 [phi:irq_vsync::@3->rotate_sprites#2] -- register_copy 
    jsr rotate_sprites
    // irq_vsync::@15
    // rotate_sprites(j, SpriteDB[SPRITE_ENEMY2], 340, 100)
    // [17] rotate_sprites::rotate#1 = j -- vwuz1=vbuz2 
    lda.z j
    sta.z rotate_sprites.rotate
    lda #0
    sta.z rotate_sprites.rotate+1
    // [18] rotate_sprites::Sprite#1 = *(SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER
    sta.z rotate_sprites.Sprite
    lda SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER+1
    sta.z rotate_sprites.Sprite+1
    // [19] call rotate_sprites 
    // [202] phi from irq_vsync::@15 to rotate_sprites [phi:irq_vsync::@15->rotate_sprites]
    // [202] phi rotate_sprites::basex#8 = $154 [phi:irq_vsync::@15->rotate_sprites#0] -- vwuz1=vwuc1 
    lda #<$154
    sta.z rotate_sprites.basex
    lda #>$154
    sta.z rotate_sprites.basex+1
    // [202] phi rotate_sprites::rotate#4 = rotate_sprites::rotate#1 [phi:irq_vsync::@15->rotate_sprites#1] -- register_copy 
    // [202] phi rotate_sprites::Sprite#2 = rotate_sprites::Sprite#1 [phi:irq_vsync::@15->rotate_sprites#2] -- register_copy 
    jsr rotate_sprites
    // irq_vsync::@16
    // i++;
    // [20] i = ++ i -- vbuz1=_inc_vbuz1 
    inc.z i
    // if(i>=NUM_PLAYER)
    // [21] if(i<NUM_PLAYER) goto irq_vsync::@7 -- vbuz1_lt_vbuc1_then_la1 
    lda.z i
    cmp #NUM_PLAYER
    bcc __b7
    // irq_vsync::@4
    // i=0
    // [22] i = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // irq_vsync::@7
  __b7:
    // j++;
    // [23] j = ++ j -- vbuz1=_inc_vbuz1 
    inc.z j
    // if(j>=NUM_ENEMY2)
    // [24] if(j<NUM_ENEMY2) goto irq_vsync::@1 -- vbuz1_lt_vbuc1_then_la1 
    lda.z j
    cmp #NUM_ENEMY2
    bcc __b1
    // irq_vsync::@8
    // j=0
    // [25] j = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z j
    // irq_vsync::@1
  __b1:
    // if(scroll_action--)
    // [26] irq_vsync::$2 = scroll_action -- vwuz1=vwuz2 
    lda.z scroll_action
    sta.z __2
    lda.z scroll_action+1
    sta.z __2+1
    // [27] scroll_action = -- scroll_action -- vwuz1=_dec_vwuz1 
    lda.z scroll_action
    bne !+
    dec.z scroll_action+1
  !:
    dec.z scroll_action
    // [28] if(0==irq_vsync::$2) goto irq_vsync::@2 -- 0_eq_vwuz1_then_la1 
    lda.z __2
    ora.z __2+1
    bne !__b2+
    jmp __b2
  !__b2:
    // irq_vsync::@5
    // scroll_action = 2
    // [29] scroll_action = 2 -- vwuz1=vbuc1 
    lda #<2
    sta.z scroll_action
    lda #>2
    sta.z scroll_action+1
    // vscroll++;
    // [30] vscroll = ++ vscroll -- vwuz1=_inc_vwuz1 
    inc.z vscroll
    bne !+
    inc.z vscroll+1
  !:
    // if(vscroll>(64)*2-1)
    // [31] if(vscroll<$40*2-1+1) goto irq_vsync::@9 -- vwuz1_lt_vbuc1_then_la1 
    lda.z vscroll+1
    bne !+
    lda.z vscroll
    cmp #$40*2-1+1
    bcc __b9
  !:
    // irq_vsync::@6
    // >vram_floor_map
    // [32] irq_vsync::$12 = > vram_floor_map#12 -- vwuz1=_hi_vdum2 
    lda vram_floor_map+2
    sta.z __12
    lda vram_floor_map+3
    sta.z __12+1
    // memcpy_in_vram(<(>vram_floor_map), <vram_floor_map, VERA_INC_1, <(>vram_floor_map), (<vram_floor_map)+64*16, VERA_INC_1, 64*16*4)
    // [33] memcpy_in_vram::dest_bank#1 = < irq_vsync::$12 -- vbuz1=_lo_vwuz2 
    lda.z __12
    sta.z memcpy_in_vram.dest_bank
    // <vram_floor_map
    // [34] memcpy_in_vram::dest#1 = < vram_floor_map#12 -- vwuz1=_lo_vdum2 
    lda vram_floor_map
    sta.z memcpy_in_vram.dest
    lda vram_floor_map+1
    sta.z memcpy_in_vram.dest+1
    // >vram_floor_map
    // [35] irq_vsync::$15 = > vram_floor_map#12 -- vwuz1=_hi_vdum2 
    lda vram_floor_map+2
    sta.z __15
    lda vram_floor_map+3
    sta.z __15+1
    // memcpy_in_vram(<(>vram_floor_map), <vram_floor_map, VERA_INC_1, <(>vram_floor_map), (<vram_floor_map)+64*16, VERA_INC_1, 64*16*4)
    // [36] memcpy_in_vram::src_bank#1 = < irq_vsync::$15 -- vbuz1=_lo_vwuz2 
    lda.z __15
    sta.z memcpy_in_vram.src_bank
    // <vram_floor_map
    // [37] irq_vsync::$17 = < vram_floor_map#12 -- vwuz1=_lo_vdum2 
    lda vram_floor_map
    sta.z __17
    lda vram_floor_map+1
    sta.z __17+1
    // (<vram_floor_map)+64*16
    // [38] memcpy_in_vram::src#1 = irq_vsync::$17 + (word)$40*$10 -- vwuz1=vwuz2_plus_vwuc1 
    clc
    lda.z __17
    adc #<$40*$10
    sta.z memcpy_in_vram.src
    lda.z __17+1
    adc #>$40*$10
    sta.z memcpy_in_vram.src+1
    // [39] memcpy_in_vram::src#4 = (void*)memcpy_in_vram::src#1
    // [40] memcpy_in_vram::dest#4 = (void*)memcpy_in_vram::dest#1
    // memcpy_in_vram(<(>vram_floor_map), <vram_floor_map, VERA_INC_1, <(>vram_floor_map), (<vram_floor_map)+64*16, VERA_INC_1, 64*16*4)
    // [41] call memcpy_in_vram 
    // [264] phi from irq_vsync::@6 to memcpy_in_vram [phi:irq_vsync::@6->memcpy_in_vram]
    // [264] phi memcpy_in_vram::num#3 = (word)$40*$10*4 [phi:irq_vsync::@6->memcpy_in_vram#0] -- vwuz1=vwuc1 
    lda #<$40*$10*4
    sta.z memcpy_in_vram.num
    lda #>$40*$10*4
    sta.z memcpy_in_vram.num+1
    // [264] phi memcpy_in_vram::dest_bank#2 = memcpy_in_vram::dest_bank#1 [phi:irq_vsync::@6->memcpy_in_vram#1] -- register_copy 
    // [264] phi memcpy_in_vram::dest#2 = memcpy_in_vram::dest#4 [phi:irq_vsync::@6->memcpy_in_vram#2] -- register_copy 
    // [264] phi memcpy_in_vram::src_bank#2 = memcpy_in_vram::src_bank#1 [phi:irq_vsync::@6->memcpy_in_vram#3] -- register_copy 
    // [264] phi memcpy_in_vram::src#2 = memcpy_in_vram::src#4 [phi:irq_vsync::@6->memcpy_in_vram#4] -- register_copy 
    jsr memcpy_in_vram
    // [42] phi from irq_vsync::@6 to irq_vsync::@10 [phi:irq_vsync::@6->irq_vsync::@10]
    // [42] phi rem16u#51 = rem16u#32 [phi:irq_vsync::@6->irq_vsync::@10#0] -- register_copy 
    // [42] phi rand_state#43 = rand_state#30 [phi:irq_vsync::@6->irq_vsync::@10#1] -- register_copy 
    // [42] phi irq_vsync::r#2 = 4 [phi:irq_vsync::@6->irq_vsync::@10#2] -- vbuz1=vbuc1 
    lda #4
    sta.z r
    // irq_vsync::@10
  __b10:
    // for(byte r=4;r<5;r+=1)
    // [43] if(irq_vsync::r#2<5) goto irq_vsync::@12 -- vbuz1_lt_vbuc1_then_la1 
    lda.z r
    cmp #5
    bcc __b3
    // irq_vsync::@11
    // vscroll=0
    // [44] vscroll = 0 -- vwuz1=vbuc1 
    lda #<0
    sta.z vscroll
    sta.z vscroll+1
    // irq_vsync::@9
  __b9:
    // vera_layer_set_vertical_scroll(0,vscroll)
    // [45] irq_vsync::vera_layer_set_vertical_scroll1_scroll#0 = vscroll -- vwuz1=vwuz2 
    lda.z vscroll
    sta.z vera_layer_set_vertical_scroll1_scroll
    lda.z vscroll+1
    sta.z vera_layer_set_vertical_scroll1_scroll+1
    // irq_vsync::vera_layer_set_vertical_scroll1
    // <scroll
    // [46] irq_vsync::vera_layer_set_vertical_scroll1_$0 = < irq_vsync::vera_layer_set_vertical_scroll1_scroll#0 -- vbuz1=_lo_vwuz2 
    lda.z vera_layer_set_vertical_scroll1_scroll
    sta.z vera_layer_set_vertical_scroll1___0
    // *vera_layer_vscroll_l[layer] = <scroll
    // [47] *(*vera_layer_vscroll_l) = irq_vsync::vera_layer_set_vertical_scroll1_$0 -- _deref_(_deref_qbuc1)=vbuz1 
    ldy vera_layer_vscroll_l
    sty.z $fe
    ldy vera_layer_vscroll_l+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // >scroll
    // [48] irq_vsync::vera_layer_set_vertical_scroll1_$1 = > irq_vsync::vera_layer_set_vertical_scroll1_scroll#0 -- vbuz1=_hi_vwuz2 
    lda.z vera_layer_set_vertical_scroll1_scroll+1
    sta.z vera_layer_set_vertical_scroll1___1
    // *vera_layer_vscroll_h[layer] = >scroll
    // [49] *(*vera_layer_vscroll_h) = irq_vsync::vera_layer_set_vertical_scroll1_$1 -- _deref_(_deref_qbuc1)=vbuz1 
    ldy vera_layer_vscroll_h
    sty.z $fe
    ldy vera_layer_vscroll_h+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // irq_vsync::@2
  __b2:
    // *VERA_ISR = VERA_VSYNC
    // [50] *VERA_ISR = VERA_VSYNC -- _deref_pbuc1=vbuc2 
    // Reset the VSYNC interrupt
    lda #VERA_VSYNC
    sta VERA_ISR
    // irq_vsync::@return
    // }
    // [51] return 
    // interrupt(isr_rom_sys_cx16_exit) -- isr_rom_sys_cx16_exit 
    jmp $e034
    // [52] phi from irq_vsync::@10 to irq_vsync::@12 [phi:irq_vsync::@10->irq_vsync::@12]
  __b3:
    // [52] phi rem16u#25 = rem16u#51 [phi:irq_vsync::@10->irq_vsync::@12#0] -- register_copy 
    // [52] phi rand_state#23 = rand_state#43 [phi:irq_vsync::@10->irq_vsync::@12#1] -- register_copy 
    // [52] phi irq_vsync::c#2 = 0 [phi:irq_vsync::@10->irq_vsync::@12#2] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // irq_vsync::@12
  __b12:
    // for(byte c=0;c<5;c+=1)
    // [53] if(irq_vsync::c#2<5) goto irq_vsync::@13 -- vbuz1_lt_vbuc1_then_la1 
    lda.z c
    cmp #5
    bcc __b13
    // irq_vsync::@14
    // r+=1
    // [54] irq_vsync::r#1 = irq_vsync::r#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z r
    // [42] phi from irq_vsync::@14 to irq_vsync::@10 [phi:irq_vsync::@14->irq_vsync::@10]
    // [42] phi rem16u#51 = rem16u#25 [phi:irq_vsync::@14->irq_vsync::@10#0] -- register_copy 
    // [42] phi rand_state#43 = rand_state#23 [phi:irq_vsync::@14->irq_vsync::@10#1] -- register_copy 
    // [42] phi irq_vsync::r#2 = irq_vsync::r#1 [phi:irq_vsync::@14->irq_vsync::@10#2] -- register_copy 
    jmp __b10
    // [55] phi from irq_vsync::@12 to irq_vsync::@13 [phi:irq_vsync::@12->irq_vsync::@13]
    // irq_vsync::@13
  __b13:
    // rand()
    // [56] call rand 
    // [284] phi from irq_vsync::@13 to rand [phi:irq_vsync::@13->rand]
    // [284] phi rand_state#13 = rand_state#23 [phi:irq_vsync::@13->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [57] rand::return#2 = rand::return#0
    // irq_vsync::@17
    // modr16u(rand(),3,0)
    // [58] modr16u::dividend#0 = rand::return#2
    // [59] call modr16u 
    // [293] phi from irq_vsync::@17 to modr16u [phi:irq_vsync::@17->modr16u]
    // [293] phi modr16u::dividend#2 = modr16u::dividend#0 [phi:irq_vsync::@17->modr16u#0] -- register_copy 
    jsr modr16u
    // modr16u(rand(),3,0)
    // [60] modr16u::return#2 = modr16u::return#0
    // irq_vsync::@18
    // [61] irq_vsync::$23 = modr16u::return#2 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z __23
    lda.z modr16u.return+1
    sta.z __23+1
    // rnd = (byte)modr16u(rand(),3,0)
    // [62] irq_vsync::rnd#0 = (byte)irq_vsync::$23 -- vbuz1=_byte_vwuz2 
    lda.z __23
    sta.z rnd
    // vera_tile_element( 0, c, r, 3, TileDB[rnd])
    // [63] irq_vsync::$28 = irq_vsync::rnd#0 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __28
    // [64] vera_tile_element::x#1 = irq_vsync::c#2 -- vbuz1=vbuz2 
    lda.z c
    sta.z vera_tile_element.x
    // [65] vera_tile_element::y#1 = irq_vsync::r#2 -- vbuz1=vbuz2 
    lda.z r
    sta.z vera_tile_element.y
    // [66] vera_tile_element::Tile#0 = TileDB[irq_vsync::$28] -- pssz1=qssc1_derefidx_vbuz2 
    ldy.z __28
    lda TileDB,y
    sta.z vera_tile_element.Tile
    lda TileDB+1,y
    sta.z vera_tile_element.Tile+1
    // [67] call vera_tile_element 
    // [298] phi from irq_vsync::@18 to vera_tile_element [phi:irq_vsync::@18->vera_tile_element]
    // [298] phi vera_tile_element::y#3 = vera_tile_element::y#1 [phi:irq_vsync::@18->vera_tile_element#0] -- register_copy 
    // [298] phi vera_tile_element::x#3 = vera_tile_element::x#1 [phi:irq_vsync::@18->vera_tile_element#1] -- register_copy 
    // [298] phi vera_tile_element::Tile#2 = vera_tile_element::Tile#0 [phi:irq_vsync::@18->vera_tile_element#2] -- register_copy 
    jsr vera_tile_element
    // irq_vsync::@19
    // c+=1
    // [68] irq_vsync::c#1 = irq_vsync::c#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z c
    // [52] phi from irq_vsync::@19 to irq_vsync::@12 [phi:irq_vsync::@19->irq_vsync::@12]
    // [52] phi rem16u#25 = divr16u::rem#10 [phi:irq_vsync::@19->irq_vsync::@12#0] -- register_copy 
    // [52] phi rand_state#23 = rand_state#14 [phi:irq_vsync::@19->irq_vsync::@12#1] -- register_copy 
    // [52] phi irq_vsync::c#2 = irq_vsync::c#1 [phi:irq_vsync::@19->irq_vsync::@12#2] -- register_copy 
    jmp __b12
}
  // conio_x16_init
// Set initial cursor position
conio_x16_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label line = 5
    // line = *BASIC_CURSOR_LINE
    // [69] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda BASIC_CURSOR_LINE
    sta.z line
    // vera_layer_mode_text(1,(dword)0x00000,(dword)0x0F800,128,64,8,8,16)
    // [70] call vera_layer_mode_text 
    // [351] phi from conio_x16_init to vera_layer_mode_text [phi:conio_x16_init->vera_layer_mode_text]
    jsr vera_layer_mode_text
    // [71] phi from conio_x16_init to conio_x16_init::@3 [phi:conio_x16_init->conio_x16_init::@3]
    // conio_x16_init::@3
    // screensize(&cx16_conio.conio_screen_width, &cx16_conio.conio_screen_height)
    // [72] call screensize 
    jsr screensize
    // [73] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // screenlayer(1)
    // [74] call screenlayer 
    jsr screenlayer
    // [75] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // vera_layer_set_textcolor(1, WHITE)
    // [76] call vera_layer_set_textcolor 
    // [393] phi from conio_x16_init::@5 to vera_layer_set_textcolor [phi:conio_x16_init::@5->vera_layer_set_textcolor]
    // [393] phi vera_layer_set_textcolor::layer#2 = 1 [phi:conio_x16_init::@5->vera_layer_set_textcolor#0] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_set_textcolor.layer
    jsr vera_layer_set_textcolor
    // [77] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // vera_layer_set_backcolor(1, BLUE)
    // [78] call vera_layer_set_backcolor 
    // [396] phi from conio_x16_init::@6 to vera_layer_set_backcolor [phi:conio_x16_init::@6->vera_layer_set_backcolor]
    // [396] phi vera_layer_set_backcolor::color#2 = BLUE [phi:conio_x16_init::@6->vera_layer_set_backcolor#0] -- vbuz1=vbuc1 
    lda #BLUE
    sta.z vera_layer_set_backcolor.color
    // [396] phi vera_layer_set_backcolor::layer#2 = 1 [phi:conio_x16_init::@6->vera_layer_set_backcolor#1] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_set_backcolor.layer
    jsr vera_layer_set_backcolor
    // [79] phi from conio_x16_init::@6 to conio_x16_init::@7 [phi:conio_x16_init::@6->conio_x16_init::@7]
    // conio_x16_init::@7
    // vera_layer_set_mapbase(0,0x20)
    // [80] call vera_layer_set_mapbase 
    // [399] phi from conio_x16_init::@7 to vera_layer_set_mapbase [phi:conio_x16_init::@7->vera_layer_set_mapbase]
    // [399] phi vera_layer_set_mapbase::mapbase#3 = $20 [phi:conio_x16_init::@7->vera_layer_set_mapbase#0] -- vbuz1=vbuc1 
    lda #$20
    sta.z vera_layer_set_mapbase.mapbase
    // [399] phi vera_layer_set_mapbase::layer#3 = 0 [phi:conio_x16_init::@7->vera_layer_set_mapbase#1] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_set_mapbase.layer
    jsr vera_layer_set_mapbase
    // [81] phi from conio_x16_init::@7 to conio_x16_init::@8 [phi:conio_x16_init::@7->conio_x16_init::@8]
    // conio_x16_init::@8
    // vera_layer_set_mapbase(1,0x00)
    // [82] call vera_layer_set_mapbase 
    // [399] phi from conio_x16_init::@8 to vera_layer_set_mapbase [phi:conio_x16_init::@8->vera_layer_set_mapbase]
    // [399] phi vera_layer_set_mapbase::mapbase#3 = 0 [phi:conio_x16_init::@8->vera_layer_set_mapbase#0] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_set_mapbase.mapbase
    // [399] phi vera_layer_set_mapbase::layer#3 = 1 [phi:conio_x16_init::@8->vera_layer_set_mapbase#1] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_set_mapbase.layer
    jsr vera_layer_set_mapbase
    // [83] phi from conio_x16_init::@8 to conio_x16_init::@9 [phi:conio_x16_init::@8->conio_x16_init::@9]
    // conio_x16_init::@9
    // cursor(0)
    // [84] call cursor 
    jsr cursor
    // conio_x16_init::@10
    // if(line>=cx16_conio.conio_screen_height)
    // [85] if(conio_x16_init::line#0<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto conio_x16_init::@1 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z line
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b1
    // conio_x16_init::@2
    // line=cx16_conio.conio_screen_height-1
    // [86] conio_x16_init::line#1 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    stx.z line
    // [87] phi from conio_x16_init::@10 conio_x16_init::@2 to conio_x16_init::@1 [phi:conio_x16_init::@10/conio_x16_init::@2->conio_x16_init::@1]
    // [87] phi conio_x16_init::line#3 = conio_x16_init::line#0 [phi:conio_x16_init::@10/conio_x16_init::@2->conio_x16_init::@1#0] -- register_copy 
    // conio_x16_init::@1
  __b1:
    // gotoxy(0, line)
    // [88] gotoxy::y#0 = conio_x16_init::line#3
    // [89] call gotoxy 
    // [406] phi from conio_x16_init::@1 to gotoxy [phi:conio_x16_init::@1->gotoxy]
    // [406] phi gotoxy::x#4 = 0 [phi:conio_x16_init::@1->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [406] phi gotoxy::y#4 = gotoxy::y#0 [phi:conio_x16_init::@1->gotoxy#1] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [90] return 
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
    .label __38 = $40
    .label status = $f
    .label vram_petscii_map = $3c
    .label vram_petscii_tile = $10
    // TileDB[TILE_SQUAREMETAL] = &SquareMetal
    // [91] *TileDB = &SquareMetal -- _deref_qssc1=pssc2 
    lda #<SquareMetal
    sta TileDB
    lda #>SquareMetal
    sta TileDB+1
    // TileDB[TILE_TILEMETAL] = &TileMetal
    // [92] *(TileDB+TILE_TILEMETAL*SIZEOF_POINTER) = &TileMetal -- _deref_qssc1=pssc2 
    lda #<TileMetal
    sta TileDB+TILE_TILEMETAL*SIZEOF_POINTER
    lda #>TileMetal
    sta TileDB+TILE_TILEMETAL*SIZEOF_POINTER+1
    // TileDB[TILE_SQUARERASTER] = &SquareRaster
    // [93] *(TileDB+TILE_SQUARERASTER*SIZEOF_POINTER) = &SquareRaster -- _deref_qssc1=pssc2 
    lda #<SquareRaster
    sta TileDB+TILE_SQUARERASTER*SIZEOF_POINTER
    lda #>SquareRaster
    sta TileDB+TILE_SQUARERASTER*SIZEOF_POINTER+1
    // SpriteDB[SPRITE_PLAYER] = &SpritesPlayer
    // [94] *SpriteDB = &SpritesPlayer -- _deref_qssc1=pssc2 
    lda #<SpritesPlayer
    sta SpriteDB
    lda #>SpritesPlayer
    sta SpriteDB+1
    // SpriteDB[SPRITE_ENEMY2] = &SpritesEnemy2
    // [95] *(SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER) = &SpritesEnemy2 -- _deref_qssc1=pssc2 
    lda #<SpritesEnemy2
    sta SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER
    lda #>SpritesEnemy2
    sta SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER+1
    // [96] phi from main to main::cx16_get_bram_base1 [phi:main->main::cx16_get_bram_base1]
    // main::cx16_get_bram_base1
    // main::@5
    // load_sprite(SpriteDB[SPRITE_PLAYER], bram_sprites_ceil)
    // [97] load_sprite::Sprite#0 = *SpriteDB -- pssz1=_deref_qssc1 
    lda SpriteDB
    sta.z load_sprite.Sprite
    lda SpriteDB+1
    sta.z load_sprite.Sprite+1
    // [98] call load_sprite 
    // [420] phi from main::@5 to load_sprite [phi:main::@5->load_sprite]
    // [420] phi load_sprite::bram_address#10 = main::cx16_get_bram_base1_return#0 [phi:main::@5->load_sprite#0] -- vduz1=vduc1 
    lda #<cx16_get_bram_base1_return
    sta.z load_sprite.bram_address
    lda #>cx16_get_bram_base1_return
    sta.z load_sprite.bram_address+1
    lda #<cx16_get_bram_base1_return>>$10
    sta.z load_sprite.bram_address+2
    lda #>cx16_get_bram_base1_return>>$10
    sta.z load_sprite.bram_address+3
    // [420] phi load_sprite::Sprite#10 = load_sprite::Sprite#0 [phi:main::@5->load_sprite#1] -- register_copy 
    jsr load_sprite
    // load_sprite(SpriteDB[SPRITE_PLAYER], bram_sprites_ceil)
    // [99] load_sprite::return#2 = load_sprite::return#0
    // main::@8
    // bram_sprites_ceil = load_sprite(SpriteDB[SPRITE_PLAYER], bram_sprites_ceil)
    // [100] bram_sprites_ceil#1 = load_sprite::return#2 -- vdum1=vduz2 
    lda.z load_sprite.return
    sta bram_sprites_ceil
    lda.z load_sprite.return+1
    sta bram_sprites_ceil+1
    lda.z load_sprite.return+2
    sta bram_sprites_ceil+2
    lda.z load_sprite.return+3
    sta bram_sprites_ceil+3
    // load_sprite(SpriteDB[SPRITE_ENEMY2], bram_sprites_ceil)
    // [101] load_sprite::Sprite#1 = *(SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER
    sta.z load_sprite.Sprite
    lda SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER+1
    sta.z load_sprite.Sprite+1
    // [102] load_sprite::bram_address#1 = bram_sprites_ceil#1 -- vduz1=vdum2 
    lda bram_sprites_ceil
    sta.z load_sprite.bram_address
    lda bram_sprites_ceil+1
    sta.z load_sprite.bram_address+1
    lda bram_sprites_ceil+2
    sta.z load_sprite.bram_address+2
    lda bram_sprites_ceil+3
    sta.z load_sprite.bram_address+3
    // [103] call load_sprite 
    // [420] phi from main::@8 to load_sprite [phi:main::@8->load_sprite]
    // [420] phi load_sprite::bram_address#10 = load_sprite::bram_address#1 [phi:main::@8->load_sprite#0] -- register_copy 
    // [420] phi load_sprite::Sprite#10 = load_sprite::Sprite#1 [phi:main::@8->load_sprite#1] -- register_copy 
    jsr load_sprite
    // load_sprite(SpriteDB[SPRITE_ENEMY2], bram_sprites_ceil)
    // [104] load_sprite::return#3 = load_sprite::return#0
    // main::@9
    // [105] bram_sprites_ceil#16 = load_sprite::return#3 -- vdum1=vduz2 
    lda.z load_sprite.return
    sta bram_sprites_ceil
    lda.z load_sprite.return+1
    sta bram_sprites_ceil+1
    lda.z load_sprite.return+2
    sta bram_sprites_ceil+2
    lda.z load_sprite.return+3
    sta bram_sprites_ceil+3
    // load_tile(TileDB[TILE_SQUAREMETAL], bram_tiles_ceil)
    // [106] load_tile::Tile#0 = *TileDB -- pssz1=_deref_qssc1 
    lda TileDB
    sta.z load_tile.Tile
    lda TileDB+1
    sta.z load_tile.Tile+1
    // [107] load_tile::bram_address#0 = bram_sprites_ceil#16 -- vduz1=vdum2 
    lda bram_sprites_ceil
    sta.z load_tile.bram_address
    lda bram_sprites_ceil+1
    sta.z load_tile.bram_address+1
    lda bram_sprites_ceil+2
    sta.z load_tile.bram_address+2
    lda bram_sprites_ceil+3
    sta.z load_tile.bram_address+3
    // [108] call load_tile 
    // [441] phi from main::@9 to load_tile [phi:main::@9->load_tile]
    // [441] phi load_tile::bram_address#10 = load_tile::bram_address#0 [phi:main::@9->load_tile#0] -- register_copy 
    // [441] phi load_tile::Tile#10 = load_tile::Tile#0 [phi:main::@9->load_tile#1] -- register_copy 
    jsr load_tile
    // load_tile(TileDB[TILE_SQUAREMETAL], bram_tiles_ceil)
    // [109] load_tile::return#2 = load_tile::return#0
    // main::@10
    // bram_tiles_ceil = load_tile(TileDB[TILE_SQUAREMETAL], bram_tiles_ceil)
    // [110] bram_tiles_ceil#1 = load_tile::return#2 -- vdum1=vduz2 
    lda.z load_tile.return
    sta bram_tiles_ceil
    lda.z load_tile.return+1
    sta bram_tiles_ceil+1
    lda.z load_tile.return+2
    sta bram_tiles_ceil+2
    lda.z load_tile.return+3
    sta bram_tiles_ceil+3
    // load_tile(TileDB[TILE_TILEMETAL], bram_tiles_ceil)
    // [111] load_tile::Tile#1 = *(TileDB+TILE_TILEMETAL*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda TileDB+TILE_TILEMETAL*SIZEOF_POINTER
    sta.z load_tile.Tile
    lda TileDB+TILE_TILEMETAL*SIZEOF_POINTER+1
    sta.z load_tile.Tile+1
    // [112] load_tile::bram_address#1 = bram_tiles_ceil#1 -- vduz1=vdum2 
    lda bram_tiles_ceil
    sta.z load_tile.bram_address
    lda bram_tiles_ceil+1
    sta.z load_tile.bram_address+1
    lda bram_tiles_ceil+2
    sta.z load_tile.bram_address+2
    lda bram_tiles_ceil+3
    sta.z load_tile.bram_address+3
    // [113] call load_tile 
    // [441] phi from main::@10 to load_tile [phi:main::@10->load_tile]
    // [441] phi load_tile::bram_address#10 = load_tile::bram_address#1 [phi:main::@10->load_tile#0] -- register_copy 
    // [441] phi load_tile::Tile#10 = load_tile::Tile#1 [phi:main::@10->load_tile#1] -- register_copy 
    jsr load_tile
    // load_tile(TileDB[TILE_TILEMETAL], bram_tiles_ceil)
    // [114] load_tile::return#3 = load_tile::return#0
    // main::@11
    // bram_tiles_ceil = load_tile(TileDB[TILE_TILEMETAL], bram_tiles_ceil)
    // [115] bram_tiles_ceil#2 = load_tile::return#3 -- vdum1=vduz2 
    lda.z load_tile.return
    sta bram_tiles_ceil
    lda.z load_tile.return+1
    sta bram_tiles_ceil+1
    lda.z load_tile.return+2
    sta bram_tiles_ceil+2
    lda.z load_tile.return+3
    sta bram_tiles_ceil+3
    // load_tile(TileDB[TILE_SQUARERASTER], bram_tiles_ceil)
    // [116] load_tile::Tile#2 = *(TileDB+TILE_SQUARERASTER*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda TileDB+TILE_SQUARERASTER*SIZEOF_POINTER
    sta.z load_tile.Tile
    lda TileDB+TILE_SQUARERASTER*SIZEOF_POINTER+1
    sta.z load_tile.Tile+1
    // [117] load_tile::bram_address#2 = bram_tiles_ceil#2 -- vduz1=vdum2 
    lda bram_tiles_ceil
    sta.z load_tile.bram_address
    lda bram_tiles_ceil+1
    sta.z load_tile.bram_address+1
    lda bram_tiles_ceil+2
    sta.z load_tile.bram_address+2
    lda bram_tiles_ceil+3
    sta.z load_tile.bram_address+3
    // [118] call load_tile 
    // [441] phi from main::@11 to load_tile [phi:main::@11->load_tile]
    // [441] phi load_tile::bram_address#10 = load_tile::bram_address#2 [phi:main::@11->load_tile#0] -- register_copy 
    // [441] phi load_tile::Tile#10 = load_tile::Tile#2 [phi:main::@11->load_tile#1] -- register_copy 
    jsr load_tile
    // load_tile(TileDB[TILE_SQUARERASTER], bram_tiles_ceil)
    // [119] load_tile::return#4 = load_tile::return#0
    // main::@12
    // [120] bram_palette#0 = load_tile::return#4 -- vdum1=vduz2 
    lda.z load_tile.return
    sta bram_palette
    lda.z load_tile.return+1
    sta bram_palette+1
    lda.z load_tile.return+2
    sta bram_palette+2
    lda.z load_tile.return+3
    sta bram_palette+3
    // cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, bram_palette)
    // [121] cx16_load_ram_banked::address#2 = bram_palette#0 -- vduz1=vdum2 
    lda bram_palette
    sta.z cx16_load_ram_banked.address
    lda bram_palette+1
    sta.z cx16_load_ram_banked.address+1
    lda bram_palette+2
    sta.z cx16_load_ram_banked.address+2
    lda bram_palette+3
    sta.z cx16_load_ram_banked.address+3
    // [122] call cx16_load_ram_banked 
    // [462] phi from main::@12 to cx16_load_ram_banked [phi:main::@12->cx16_load_ram_banked]
    // [462] phi cx16_load_ram_banked::filename#3 = FILE_PALETTES [phi:main::@12->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_PALETTES
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_PALETTES
    sta.z cx16_load_ram_banked.filename+1
    // [462] phi cx16_load_ram_banked::address#3 = cx16_load_ram_banked::address#2 [phi:main::@12->cx16_load_ram_banked#1] -- register_copy 
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, bram_palette)
    // [123] cx16_load_ram_banked::return#10 = cx16_load_ram_banked::return#1
    // main::@13
    // status = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, bram_palette)
    // [124] main::status#0 = cx16_load_ram_banked::return#10
    // if(status!=$ff)
    // [125] if(main::status#0==$ff) goto main::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [126] phi from main::@13 to main::@2 [phi:main::@13->main::@2]
    // main::@2
    // printf("error file_palettes = %u",status)
    // [127] call cputs 
    // [529] phi from main::@2 to cputs [phi:main::@2->cputs]
    // [529] phi cputs::s#13 = main::s [phi:main::@2->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@34
    // printf("error file_palettes = %u",status)
    // [128] printf_uchar::uvalue#3 = main::status#0
    // [129] call printf_uchar 
    // [537] phi from main::@34 to printf_uchar [phi:main::@34->printf_uchar]
    // [537] phi printf_uchar::format_radix#4 = DECIMAL [phi:main::@34->printf_uchar#0] -- vbuz1=vbuc1 
    lda #DECIMAL
    sta.z printf_uchar.format_radix
    // [537] phi printf_uchar::uvalue#4 = printf_uchar::uvalue#3 [phi:main::@34->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [130] phi from main::@13 main::@34 to main::@1 [phi:main::@13/main::@34->main::@1]
    // main::@1
  __b1:
    // cx16_rom_bank(0)
    // [131] call cx16_rom_bank 
  // We are going to use only the kernal on the X16.
    // [545] phi from main::@1 to cx16_rom_bank [phi:main::@1->cx16_rom_bank]
    // [545] phi cx16_rom_bank::bank#2 = 0 [phi:main::@1->cx16_rom_bank#0] -- vbuz1=vbuc1 
    lda #0
    sta.z cx16_rom_bank.bank
    jsr cx16_rom_bank
    // [132] phi from main::@1 to main::@14 [phi:main::@1->main::@14]
    // main::@14
    // vera_heap_segment_init(HEAP_PETSCII, 0x1B000, VRAM_PETSCII_MAP_SIZE + VERA_PETSCII_TILE_SIZE)
    // [133] call vera_heap_segment_init 
    // [548] phi from main::@14 to vera_heap_segment_init [phi:main::@14->vera_heap_segment_init]
    // [548] phi vera_heap_segment_init::base#4 = $1b000 [phi:main::@14->vera_heap_segment_init#0] -- vduz1=vduc1 
    lda #<$1b000
    sta.z vera_heap_segment_init.base
    lda #>$1b000
    sta.z vera_heap_segment_init.base+1
    lda #<$1b000>>$10
    sta.z vera_heap_segment_init.base+2
    lda #>$1b000>>$10
    sta.z vera_heap_segment_init.base+3
    // [548] phi vera_heap_segment_init::size#4 = main::VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE [phi:main::@14->vera_heap_segment_init#1] -- vduz1=vduc1 
    lda #<VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE
    sta.z vera_heap_segment_init.size
    lda #>VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE
    sta.z vera_heap_segment_init.size+1
    lda #<VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+2
    lda #>VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+3
    // [548] phi vera_heap_segment_init::segmentid#4 = HEAP_PETSCII [phi:main::@14->vera_heap_segment_init#2] -- vbuz1=vbuc1 
    lda #HEAP_PETSCII
    sta.z vera_heap_segment_init.segmentid
    jsr vera_heap_segment_init
    // main::@15
    // vera_heap_malloc(HEAP_PETSCII, VRAM_PETSCII_MAP_SIZE)
    // [134] vera_heap_malloc::size = main::VRAM_PETSCII_MAP_SIZE -- vwuz1=vwuc1 
    lda #<VRAM_PETSCII_MAP_SIZE
    sta.z vera_heap_malloc.size
    lda #>VRAM_PETSCII_MAP_SIZE
    sta.z vera_heap_malloc.size+1
    // [135] call vera_heap_malloc 
    // [564] phi from main::@15 to vera_heap_malloc [phi:main::@15->vera_heap_malloc]
    // [564] phi vera_heap_malloc::segmentid#4 = HEAP_PETSCII [phi:main::@15->vera_heap_malloc#0] -- vbuz1=vbuc1 
    lda #HEAP_PETSCII
    sta.z vera_heap_malloc.segmentid
    jsr vera_heap_malloc
    // vera_heap_malloc(HEAP_PETSCII, VRAM_PETSCII_MAP_SIZE)
    // [136] vera_heap_malloc::return#13 = vera_heap_malloc::return#1
    // main::@16
    // vram_petscii_map = vera_heap_malloc(HEAP_PETSCII, VRAM_PETSCII_MAP_SIZE)
    // [137] main::vram_petscii_map#0 = vera_heap_malloc::return#13 -- vduz1=vduz2 
    lda.z vera_heap_malloc.return
    sta.z vram_petscii_map
    lda.z vera_heap_malloc.return+1
    sta.z vram_petscii_map+1
    lda.z vera_heap_malloc.return+2
    sta.z vram_petscii_map+2
    lda.z vera_heap_malloc.return+3
    sta.z vram_petscii_map+3
    // vera_heap_malloc(HEAP_PETSCII, VERA_PETSCII_TILE_SIZE)
    // [138] vera_heap_malloc::size = VERA_PETSCII_TILE_SIZE -- vwuz1=vwuc1 
    lda #<VERA_PETSCII_TILE_SIZE
    sta.z vera_heap_malloc.size
    lda #>VERA_PETSCII_TILE_SIZE
    sta.z vera_heap_malloc.size+1
    // [139] call vera_heap_malloc 
    // [564] phi from main::@16 to vera_heap_malloc [phi:main::@16->vera_heap_malloc]
    // [564] phi vera_heap_malloc::segmentid#4 = HEAP_PETSCII [phi:main::@16->vera_heap_malloc#0] -- vbuz1=vbuc1 
    lda #HEAP_PETSCII
    sta.z vera_heap_malloc.segmentid
    jsr vera_heap_malloc
    // vera_heap_malloc(HEAP_PETSCII, VERA_PETSCII_TILE_SIZE)
    // [140] vera_heap_malloc::return#14 = vera_heap_malloc::return#1
    // main::@17
    // vram_petscii_tile = vera_heap_malloc(HEAP_PETSCII, VERA_PETSCII_TILE_SIZE)
    // [141] main::vram_petscii_tile#0 = vera_heap_malloc::return#14
    // vera_cpy_vram_vram(VERA_PETSCII_TILE, VRAM_PETSCII_TILE, VERA_PETSCII_TILE_SIZE)
    // [142] call vera_cpy_vram_vram 
    jsr vera_cpy_vram_vram
    // main::@18
    // vera_layer_mode_tile(1, vram_petscii_map, vram_petscii_tile, 128, 64, 8, 8, 1)
    // [143] vera_layer_mode_tile::mapbase_address#2 = main::vram_petscii_map#0 -- vduz1=vduz2 
    lda.z vram_petscii_map
    sta.z vera_layer_mode_tile.mapbase_address
    lda.z vram_petscii_map+1
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda.z vram_petscii_map+2
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda.z vram_petscii_map+3
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [144] vera_layer_mode_tile::tilebase_address#2 = main::vram_petscii_tile#0 -- vduz1=vduz2 
    lda.z vram_petscii_tile
    sta.z vera_layer_mode_tile.tilebase_address
    lda.z vram_petscii_tile+1
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda.z vram_petscii_tile+2
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda.z vram_petscii_tile+3
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [145] call vera_layer_mode_tile 
    // [643] phi from main::@18 to vera_layer_mode_tile [phi:main::@18->vera_layer_mode_tile]
    // [643] phi vera_layer_mode_tile::tileheight#10 = 8 [phi:main::@18->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [643] phi vera_layer_mode_tile::tilewidth#10 = 8 [phi:main::@18->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [643] phi vera_layer_mode_tile::tilebase_address#10 = vera_layer_mode_tile::tilebase_address#2 [phi:main::@18->vera_layer_mode_tile#2] -- register_copy 
    // [643] phi vera_layer_mode_tile::mapbase_address#10 = vera_layer_mode_tile::mapbase_address#2 [phi:main::@18->vera_layer_mode_tile#3] -- register_copy 
    // [643] phi vera_layer_mode_tile::mapheight#10 = $40 [phi:main::@18->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [643] phi vera_layer_mode_tile::layer#10 = 1 [phi:main::@18->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.layer
    // [643] phi vera_layer_mode_tile::mapwidth#10 = $80 [phi:main::@18->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [643] phi vera_layer_mode_tile::color_depth#3 = 1 [phi:main::@18->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // [146] phi from main::@18 to main::@19 [phi:main::@18->main::@19]
    // main::@19
    // screenlayer(1)
    // [147] call screenlayer 
    jsr screenlayer
    // main::textcolor1
    // vera_layer_set_textcolor(cx16_conio.conio_screen_layer, color)
    // [148] vera_layer_set_textcolor::layer#1 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_set_textcolor.layer
    // [149] call vera_layer_set_textcolor 
    // [393] phi from main::textcolor1 to vera_layer_set_textcolor [phi:main::textcolor1->vera_layer_set_textcolor]
    // [393] phi vera_layer_set_textcolor::layer#2 = vera_layer_set_textcolor::layer#1 [phi:main::textcolor1->vera_layer_set_textcolor#0] -- register_copy 
    jsr vera_layer_set_textcolor
    // main::bgcolor1
    // vera_layer_set_backcolor(cx16_conio.conio_screen_layer, color)
    // [150] vera_layer_set_backcolor::layer#1 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_set_backcolor.layer
    // [151] call vera_layer_set_backcolor 
    // [396] phi from main::bgcolor1 to vera_layer_set_backcolor [phi:main::bgcolor1->vera_layer_set_backcolor]
    // [396] phi vera_layer_set_backcolor::color#2 = BLACK [phi:main::bgcolor1->vera_layer_set_backcolor#0] -- vbuz1=vbuc1 
    lda #BLACK
    sta.z vera_layer_set_backcolor.color
    // [396] phi vera_layer_set_backcolor::layer#2 = vera_layer_set_backcolor::layer#1 [phi:main::bgcolor1->vera_layer_set_backcolor#1] -- register_copy 
    jsr vera_layer_set_backcolor
    // [152] phi from main::bgcolor1 to main::@6 [phi:main::bgcolor1->main::@6]
    // main::@6
    // clrscr()
    // [153] call clrscr 
    jsr clrscr
    // [154] phi from main::@6 to main::@20 [phi:main::@6->main::@20]
    // main::@20
    // vera_heap_segment_init(HEAP_SPRITES, 0x00000, VRAM_SPRITES_SIZE)
    // [155] call vera_heap_segment_init 
    // [548] phi from main::@20 to vera_heap_segment_init [phi:main::@20->vera_heap_segment_init]
    // [548] phi vera_heap_segment_init::base#4 = 0 [phi:main::@20->vera_heap_segment_init#0] -- vduz1=vbuc1 
    lda #0
    sta.z vera_heap_segment_init.base
    sta.z vera_heap_segment_init.base+1
    sta.z vera_heap_segment_init.base+2
    sta.z vera_heap_segment_init.base+3
    // [548] phi vera_heap_segment_init::size#4 = main::VRAM_SPRITES_SIZE [phi:main::@20->vera_heap_segment_init#1] -- vduz1=vduc1 
    lda #<VRAM_SPRITES_SIZE
    sta.z vera_heap_segment_init.size
    lda #>VRAM_SPRITES_SIZE
    sta.z vera_heap_segment_init.size+1
    lda #<VRAM_SPRITES_SIZE>>$10
    sta.z vera_heap_segment_init.size+2
    lda #>VRAM_SPRITES_SIZE>>$10
    sta.z vera_heap_segment_init.size+3
    // [548] phi vera_heap_segment_init::segmentid#4 = HEAP_SPRITES [phi:main::@20->vera_heap_segment_init#2] -- vbuz1=vbuc1 
    lda #HEAP_SPRITES
    sta.z vera_heap_segment_init.segmentid
    jsr vera_heap_segment_init
    // [156] phi from main::@20 to main::@21 [phi:main::@20->main::@21]
    // main::@21
    // vera_heap_segment_ceiling(HEAP_SPRITES)
    // [157] call vera_heap_segment_ceiling 
    // [749] phi from main::@21 to vera_heap_segment_ceiling [phi:main::@21->vera_heap_segment_ceiling]
    // [749] phi vera_heap_segment_ceiling::segmentid#2 = HEAP_SPRITES [phi:main::@21->vera_heap_segment_ceiling#0] -- vbuz1=vbuc1 
    lda #HEAP_SPRITES
    sta.z vera_heap_segment_ceiling.segmentid
    jsr vera_heap_segment_ceiling
    // vera_heap_segment_ceiling(HEAP_SPRITES)
    // [158] vera_heap_segment_ceiling::return#2 = vera_heap_segment_ceiling::return#0
    // main::@22
    // vera_heap_segment_init(HEAP_FLOOR_MAP, vera_heap_segment_ceiling(HEAP_SPRITES), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [159] vera_heap_segment_init::base#2 = vera_heap_segment_ceiling::return#2
    // [160] call vera_heap_segment_init 
    // [548] phi from main::@22 to vera_heap_segment_init [phi:main::@22->vera_heap_segment_init]
    // [548] phi vera_heap_segment_init::base#4 = vera_heap_segment_init::base#2 [phi:main::@22->vera_heap_segment_init#0] -- register_copy 
    // [548] phi vera_heap_segment_init::size#4 = main::VRAM_FLOOR_MAP_SIZE+main::VRAM_FLOOR_TILE_SIZE [phi:main::@22->vera_heap_segment_init#1] -- vduz1=vduc1 
    lda #<VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE
    sta.z vera_heap_segment_init.size
    lda #>VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE
    sta.z vera_heap_segment_init.size+1
    lda #<VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+2
    lda #>VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+3
    // [548] phi vera_heap_segment_init::segmentid#4 = HEAP_FLOOR_MAP [phi:main::@22->vera_heap_segment_init#2] -- vbuz1=vbuc1 
    lda #HEAP_FLOOR_MAP
    sta.z vera_heap_segment_init.segmentid
    jsr vera_heap_segment_init
    // vera_heap_segment_init(HEAP_FLOOR_MAP, vera_heap_segment_ceiling(HEAP_SPRITES), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [161] vera_heap_segment_init::return#4 = vera_heap_segment_init::return#0
    // main::@23
    // vram_segment_floor_map = vera_heap_segment_init(HEAP_FLOOR_MAP, vera_heap_segment_ceiling(HEAP_SPRITES), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [162] main::vram_segment_floor_map#0 = vera_heap_segment_init::return#4 -- vdum1=vduz2 
    lda.z vera_heap_segment_init.return
    sta vram_segment_floor_map
    lda.z vera_heap_segment_init.return+1
    sta vram_segment_floor_map+1
    lda.z vera_heap_segment_init.return+2
    sta vram_segment_floor_map+2
    lda.z vera_heap_segment_init.return+3
    sta vram_segment_floor_map+3
    // vera_heap_segment_ceiling(HEAP_FLOOR_MAP)
    // [163] call vera_heap_segment_ceiling 
    // [749] phi from main::@23 to vera_heap_segment_ceiling [phi:main::@23->vera_heap_segment_ceiling]
    // [749] phi vera_heap_segment_ceiling::segmentid#2 = HEAP_FLOOR_MAP [phi:main::@23->vera_heap_segment_ceiling#0] -- vbuz1=vbuc1 
    lda #HEAP_FLOOR_MAP
    sta.z vera_heap_segment_ceiling.segmentid
    jsr vera_heap_segment_ceiling
    // vera_heap_segment_ceiling(HEAP_FLOOR_MAP)
    // [164] vera_heap_segment_ceiling::return#3 = vera_heap_segment_ceiling::return#0
    // main::@24
    // vera_heap_segment_init(HEAP_FLOOR_TILE, vera_heap_segment_ceiling(HEAP_FLOOR_MAP), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [165] vera_heap_segment_init::base#3 = vera_heap_segment_ceiling::return#3
    // [166] call vera_heap_segment_init 
    // [548] phi from main::@24 to vera_heap_segment_init [phi:main::@24->vera_heap_segment_init]
    // [548] phi vera_heap_segment_init::base#4 = vera_heap_segment_init::base#3 [phi:main::@24->vera_heap_segment_init#0] -- register_copy 
    // [548] phi vera_heap_segment_init::size#4 = main::VRAM_FLOOR_MAP_SIZE+main::VRAM_FLOOR_TILE_SIZE [phi:main::@24->vera_heap_segment_init#1] -- vduz1=vduc1 
    lda #<VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE
    sta.z vera_heap_segment_init.size
    lda #>VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE
    sta.z vera_heap_segment_init.size+1
    lda #<VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+2
    lda #>VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+3
    // [548] phi vera_heap_segment_init::segmentid#4 = HEAP_FLOOR_TILE [phi:main::@24->vera_heap_segment_init#2] -- vbuz1=vbuc1 
    lda #HEAP_FLOOR_TILE
    sta.z vera_heap_segment_init.segmentid
    jsr vera_heap_segment_init
    // vera_heap_segment_init(HEAP_FLOOR_TILE, vera_heap_segment_ceiling(HEAP_FLOOR_MAP), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [167] vera_heap_segment_init::return#5 = vera_heap_segment_init::return#0
    // main::@25
    // vram_segment_floor_tile = vera_heap_segment_init(HEAP_FLOOR_TILE, vera_heap_segment_ceiling(HEAP_FLOOR_MAP), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [168] main::vram_segment_floor_tile#0 = vera_heap_segment_init::return#5 -- vdum1=vduz2 
    lda.z vera_heap_segment_init.return
    sta vram_segment_floor_tile
    lda.z vera_heap_segment_init.return+1
    sta vram_segment_floor_tile+1
    lda.z vera_heap_segment_init.return+2
    sta vram_segment_floor_tile+2
    lda.z vera_heap_segment_init.return+3
    sta vram_segment_floor_tile+3
    // sprite_cpy_vram(HEAP_SPRITES, SpriteDB[SPRITE_PLAYER], NUM_PLAYER, 512)
    // [169] sprite_cpy_vram::Sprite#0 = *SpriteDB -- pssz1=_deref_qssc1 
    lda SpriteDB
    sta.z sprite_cpy_vram.Sprite
    lda SpriteDB+1
    sta.z sprite_cpy_vram.Sprite+1
    // [170] call sprite_cpy_vram 
  // Now we activate the tile mode.
    // [758] phi from main::@25 to sprite_cpy_vram [phi:main::@25->sprite_cpy_vram]
    // [758] phi sprite_cpy_vram::num#3 = NUM_PLAYER [phi:main::@25->sprite_cpy_vram#0] -- vbuz1=vbuc1 
    lda #NUM_PLAYER
    sta.z sprite_cpy_vram.num
    // [758] phi sprite_cpy_vram::Sprite#2 = sprite_cpy_vram::Sprite#0 [phi:main::@25->sprite_cpy_vram#1] -- register_copy 
    jsr sprite_cpy_vram
    // main::@26
    // sprite_cpy_vram(HEAP_SPRITES, SpriteDB[SPRITE_ENEMY2], NUM_ENEMY2, 512)
    // [171] sprite_cpy_vram::Sprite#1 = *(SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER
    sta.z sprite_cpy_vram.Sprite
    lda SpriteDB+SPRITE_ENEMY2*SIZEOF_POINTER+1
    sta.z sprite_cpy_vram.Sprite+1
    // [172] call sprite_cpy_vram 
    // [758] phi from main::@26 to sprite_cpy_vram [phi:main::@26->sprite_cpy_vram]
    // [758] phi sprite_cpy_vram::num#3 = NUM_ENEMY2 [phi:main::@26->sprite_cpy_vram#0] -- vbuz1=vbuc1 
    lda #NUM_ENEMY2
    sta.z sprite_cpy_vram.num
    // [758] phi sprite_cpy_vram::Sprite#2 = sprite_cpy_vram::Sprite#1 [phi:main::@26->sprite_cpy_vram#1] -- register_copy 
    jsr sprite_cpy_vram
    // main::@27
    // tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_SQUAREMETAL], NUM_SQUAREMETAL, 2048)
    // [173] tile_cpy_vram::Tile#0 = *TileDB -- pssz1=_deref_qssc1 
    lda TileDB
    sta.z tile_cpy_vram.Tile
    lda TileDB+1
    sta.z tile_cpy_vram.Tile+1
    // [174] call tile_cpy_vram 
    // [789] phi from main::@27 to tile_cpy_vram [phi:main::@27->tile_cpy_vram]
    // [789] phi tile_cpy_vram::num#4 = NUM_SQUAREMETAL [phi:main::@27->tile_cpy_vram#0] -- vbuz1=vbuc1 
    lda #NUM_SQUAREMETAL
    sta.z tile_cpy_vram.num
    // [789] phi tile_cpy_vram::Tile#3 = tile_cpy_vram::Tile#0 [phi:main::@27->tile_cpy_vram#1] -- register_copy 
    jsr tile_cpy_vram
    // main::@28
    // tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_TILEMETAL], NUM_TILEMETAL, 2048)
    // [175] tile_cpy_vram::Tile#1 = *(TileDB+TILE_TILEMETAL*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda TileDB+TILE_TILEMETAL*SIZEOF_POINTER
    sta.z tile_cpy_vram.Tile
    lda TileDB+TILE_TILEMETAL*SIZEOF_POINTER+1
    sta.z tile_cpy_vram.Tile+1
    // [176] call tile_cpy_vram 
    // [789] phi from main::@28 to tile_cpy_vram [phi:main::@28->tile_cpy_vram]
    // [789] phi tile_cpy_vram::num#4 = NUM_TILEMETAL [phi:main::@28->tile_cpy_vram#0] -- vbuz1=vbuc1 
    lda #NUM_TILEMETAL
    sta.z tile_cpy_vram.num
    // [789] phi tile_cpy_vram::Tile#3 = tile_cpy_vram::Tile#1 [phi:main::@28->tile_cpy_vram#1] -- register_copy 
    jsr tile_cpy_vram
    // main::@29
    // tile_cpy_vram(HEAP_FLOOR_TILE, TileDB[TILE_SQUARERASTER], NUM_SQUARERASTER, 2048)
    // [177] tile_cpy_vram::Tile#2 = *(TileDB+TILE_SQUARERASTER*SIZEOF_POINTER) -- pssz1=_deref_qssc1 
    lda TileDB+TILE_SQUARERASTER*SIZEOF_POINTER
    sta.z tile_cpy_vram.Tile
    lda TileDB+TILE_SQUARERASTER*SIZEOF_POINTER+1
    sta.z tile_cpy_vram.Tile+1
    // [178] call tile_cpy_vram 
    // [789] phi from main::@29 to tile_cpy_vram [phi:main::@29->tile_cpy_vram]
    // [789] phi tile_cpy_vram::num#4 = NUM_SQUARERASTER [phi:main::@29->tile_cpy_vram#0] -- vbuz1=vbuc1 
    lda #NUM_SQUARERASTER
    sta.z tile_cpy_vram.num
    // [789] phi tile_cpy_vram::Tile#3 = tile_cpy_vram::Tile#2 [phi:main::@29->tile_cpy_vram#1] -- register_copy 
    jsr tile_cpy_vram
    // main::@30
    // vera_layer_mode_tile(0, vram_segment_floor_map, vram_segment_floor_tile, 64, 64, 16, 16, 4)
    // [179] vera_layer_mode_tile::mapbase_address#3 = main::vram_segment_floor_map#0 -- vduz1=vdum2 
    lda vram_segment_floor_map
    sta.z vera_layer_mode_tile.mapbase_address
    lda vram_segment_floor_map+1
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda vram_segment_floor_map+2
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda vram_segment_floor_map+3
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [180] vera_layer_mode_tile::tilebase_address#3 = main::vram_segment_floor_tile#0 -- vduz1=vdum2 
    lda vram_segment_floor_tile
    sta.z vera_layer_mode_tile.tilebase_address
    lda vram_segment_floor_tile+1
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda vram_segment_floor_tile+2
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda vram_segment_floor_tile+3
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [181] call vera_layer_mode_tile 
    // [643] phi from main::@30 to vera_layer_mode_tile [phi:main::@30->vera_layer_mode_tile]
    // [643] phi vera_layer_mode_tile::tileheight#10 = $10 [phi:main::@30->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #$10
    sta.z vera_layer_mode_tile.tileheight
    // [643] phi vera_layer_mode_tile::tilewidth#10 = $10 [phi:main::@30->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [643] phi vera_layer_mode_tile::tilebase_address#10 = vera_layer_mode_tile::tilebase_address#3 [phi:main::@30->vera_layer_mode_tile#2] -- register_copy 
    // [643] phi vera_layer_mode_tile::mapbase_address#10 = vera_layer_mode_tile::mapbase_address#3 [phi:main::@30->vera_layer_mode_tile#3] -- register_copy 
    // [643] phi vera_layer_mode_tile::mapheight#10 = $40 [phi:main::@30->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [643] phi vera_layer_mode_tile::layer#10 = 0 [phi:main::@30->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.layer
    // [643] phi vera_layer_mode_tile::mapwidth#10 = $40 [phi:main::@30->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$40
    sta.z vera_layer_mode_tile.mapwidth+1
    // [643] phi vera_layer_mode_tile::color_depth#3 = 4 [phi:main::@30->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #4
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // main::@31
    // vera_cpy_bank_vram(bram_palette, VERA_PALETTE+32, (dword)32*6)
    // [182] vera_cpy_bank_vram::bsrc#2 = bram_palette#0 -- vduz1=vdum2 
    lda bram_palette
    sta.z vera_cpy_bank_vram.bsrc
    lda bram_palette+1
    sta.z vera_cpy_bank_vram.bsrc+1
    lda bram_palette+2
    sta.z vera_cpy_bank_vram.bsrc+2
    lda bram_palette+3
    sta.z vera_cpy_bank_vram.bsrc+3
    // [183] call vera_cpy_bank_vram 
  // Load the palette in VERA palette registers, but keep the first 16 colors untouched.
    // [810] phi from main::@31 to vera_cpy_bank_vram [phi:main::@31->vera_cpy_bank_vram]
    // [810] phi vera_cpy_bank_vram::num#5 = $20*6 [phi:main::@31->vera_cpy_bank_vram#0] -- vduz1=vduc1 
    lda #<$20*6
    sta.z vera_cpy_bank_vram.num
    lda #>$20*6
    sta.z vera_cpy_bank_vram.num+1
    lda #<$20*6>>$10
    sta.z vera_cpy_bank_vram.num+2
    lda #>$20*6>>$10
    sta.z vera_cpy_bank_vram.num+3
    // [810] phi vera_cpy_bank_vram::bsrc#3 = vera_cpy_bank_vram::bsrc#2 [phi:main::@31->vera_cpy_bank_vram#1] -- register_copy 
    // [810] phi vera_cpy_bank_vram::vdest#3 = VERA_PALETTE+$20 [phi:main::@31->vera_cpy_bank_vram#2] -- vduz1=vduc1 
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
    // [184] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [185] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [186] phi from main::vera_layer_show1 to main::@7 [phi:main::vera_layer_show1->main::@7]
    // main::@7
    // tile_background()
    // [187] call tile_background 
    // [852] phi from main::@7 to tile_background [phi:main::@7->tile_background]
    jsr tile_background
    // [188] phi from main::@7 to main::@32 [phi:main::@7->main::@32]
    // main::@32
    // create_sprite(SPRITE_PLAYER)
    // [189] call create_sprite 
    // [873] phi from main::@32 to create_sprite [phi:main::@32->create_sprite]
    // [873] phi create_sprite::sprite#2 = SPRITE_PLAYER [phi:main::@32->create_sprite#0] -- vbuz1=vbuc1 
    lda #SPRITE_PLAYER
    sta.z create_sprite.sprite
    jsr create_sprite
    // [190] phi from main::@32 to main::@33 [phi:main::@32->main::@33]
    // main::@33
    // create_sprite(SPRITE_ENEMY2)
    // [191] call create_sprite 
    // [873] phi from main::@33 to create_sprite [phi:main::@33->create_sprite]
    // [873] phi create_sprite::sprite#2 = SPRITE_ENEMY2 [phi:main::@33->create_sprite#0] -- vbuz1=vbuc1 
    lda #SPRITE_ENEMY2
    sta.z create_sprite.sprite
    jsr create_sprite
    // main::vera_sprite_on1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [192] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE
    // [193] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_SPRITES_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITES_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [194] phi from main::@35 main::vera_sprite_on1 to main::@3 [phi:main::@35/main::vera_sprite_on1->main::@3]
  __b2:
  // Enable VSYNC IRQ (also set line bit 8 to 0)
  // SEI();
  // *KERNEL_IRQ = &irq_vsync;
  // *VERA_IEN = VERA_VSYNC; 
  // CLI();
    // main::@3
    // kbhit()
    // [195] call kbhit 
    jsr kbhit
    // [196] kbhit::return#2 = kbhit::return#1
    // main::@35
    // [197] main::$38 = kbhit::return#2
    // while(!kbhit())
    // [198] if(0==main::$38) goto main::@3 -- 0_eq_vbuz1_then_la1 
    lda.z __38
    cmp #0
    beq __b2
    // [199] phi from main::@35 to main::@4 [phi:main::@35->main::@4]
    // main::@4
    // cx16_rom_bank(4)
    // [200] call cx16_rom_bank 
  // Back to basic.
    // [545] phi from main::@4 to cx16_rom_bank [phi:main::@4->cx16_rom_bank]
    // [545] phi cx16_rom_bank::bank#2 = 4 [phi:main::@4->cx16_rom_bank#0] -- vbuz1=vbuc1 
    lda #4
    sta.z cx16_rom_bank.bank
    jsr cx16_rom_bank
    // main::@return
    // }
    // [201] return 
    rts
  .segment Data
    s: .text "error file_palettes = "
    .byte 0
    vram_segment_floor_map: .dword 0
    vram_segment_floor_tile: .dword 0
}
.segment Code
  // rotate_sprites
// rotate_sprites(word zp($33) rotate, struct Sprite* zp($31) Sprite, word zp($35) basex)
rotate_sprites: {
    .label __7 = $49
    .label __8 = $37
    .label __10 = $49
    .label __11 = $43
    .label __14 = $37
    .label __17 = $43
    .label __21 = $37
    .label __22 = $43
    .label vera_sprite_address1___0 = $37
    .label vera_sprite_address1___2 = $49
    .label vera_sprite_address1___3 = $49
    .label vera_sprite_address1___4 = $37
    .label vera_sprite_address1___5 = $37
    .label vera_sprite_address1___6 = $49
    .label vera_sprite_address1___7 = $37
    .label vera_sprite_address1___8 = $49
    .label vera_sprite_address1___9 = $49
    .label vera_sprite_address1___10 = $37
    .label vera_sprite_address1___11 = $4a
    .label vera_sprite_address1___12 = $4a
    .label vera_sprite_address1___13 = $49
    .label vera_sprite_address1___14 = $37
    .label vera_sprite_xy1___3 = $39
    .label vera_sprite_xy1___4 = $4b
    .label vera_sprite_xy1___5 = $39
    .label vera_sprite_xy1___6 = $39
    .label vera_sprite_xy1___7 = $39
    .label vera_sprite_xy1___8 = $39
    .label vera_sprite_xy1___9 = $39
    .label vera_sprite_xy1___10 = $4b
    .label offset = 4
    .label max = $41
    .label i = $37
    .label vera_sprite_address1_address = $45
    .label vera_sprite_address1_sprite_offset = $37
    .label vera_sprite_xy1_sprite = $39
    .label vera_sprite_xy1_x = $37
    .label vera_sprite_xy1_y = $43
    .label vera_sprite_xy1_sprite_offset = $4b
    .label s = 3
    .label rotate = $33
    .label Sprite = $31
    .label basex = $35
    .label __23 = $43
    // offset = Sprite->Offset
    // [203] rotate_sprites::offset#0 = ((byte*)rotate_sprites::Sprite#2)[OFFSET_STRUCT_SPRITE_OFFSET] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_OFFSET
    lda (Sprite),y
    sta.z offset
    // max = Sprite->Count
    // [204] rotate_sprites::max#0 = (word)((byte*)rotate_sprites::Sprite#2)[OFFSET_STRUCT_SPRITE_COUNT] -- vwuz1=_word_pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_COUNT
    lda (Sprite),y
    sta.z max
    lda #0
    sta.z max+1
    // [205] phi from rotate_sprites to rotate_sprites::@1 [phi:rotate_sprites->rotate_sprites::@1]
    // [205] phi rotate_sprites::s#2 = 0 [phi:rotate_sprites->rotate_sprites::@1#0] -- vbuz1=vbuc1 
    sta.z s
    // rotate_sprites::@1
  __b1:
    // for(byte s=0;s<max;s++)
    // [206] if(rotate_sprites::s#2<rotate_sprites::max#0) goto rotate_sprites::@2 -- vbuz1_lt_vwuz2_then_la1 
    lda.z max+1
    bne __b2
    lda.z s
    cmp.z max
    bcc __b2
    // rotate_sprites::@return
    // }
    // [207] return 
    rts
    // rotate_sprites::@2
  __b2:
    // i = s+rotate
    // [208] rotate_sprites::i#0 = rotate_sprites::s#2 + rotate_sprites::rotate#4 -- vwuz1=vbuz2_plus_vwuz3 
    lda.z s
    clc
    adc.z rotate
    sta.z i
    lda #0
    adc.z rotate+1
    sta.z i+1
    // if(i>=max)
    // [209] if(rotate_sprites::i#0<rotate_sprites::max#0) goto rotate_sprites::@3 -- vwuz1_lt_vwuz2_then_la1 
    cmp.z max+1
    bcc __b3
    bne !+
    lda.z i
    cmp.z max
    bcc __b3
  !:
    // rotate_sprites::@4
    // i-=max
    // [210] rotate_sprites::i#1 = rotate_sprites::i#0 - rotate_sprites::max#0 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z i
    sec
    sbc.z max
    sta.z i
    lda.z i+1
    sbc.z max+1
    sta.z i+1
    // [211] phi from rotate_sprites::@2 rotate_sprites::@4 to rotate_sprites::@3 [phi:rotate_sprites::@2/rotate_sprites::@4->rotate_sprites::@3]
    // [211] phi rotate_sprites::i#2 = rotate_sprites::i#0 [phi:rotate_sprites::@2/rotate_sprites::@4->rotate_sprites::@3#0] -- register_copy 
    // rotate_sprites::@3
  __b3:
    // vera_sprite_address(s+offset, Sprite->VRAM_Addresses[i])
    // [212] rotate_sprites::vera_sprite_xy1_sprite#0 = rotate_sprites::s#2 + rotate_sprites::offset#0 -- vbuz1=vbuz2_plus_vbuz3 
    lda.z s
    clc
    adc.z offset
    sta.z vera_sprite_xy1_sprite
    // [213] rotate_sprites::$14 = rotate_sprites::i#2 << 2 -- vwuz1=vwuz1_rol_2 
    asl.z __14
    rol.z __14+1
    asl.z __14
    rol.z __14+1
    // [214] rotate_sprites::$17 = (dword*)rotate_sprites::Sprite#2 + OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES -- pduz1=pduz2_plus_vbuc1 
    lda #OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES
    clc
    adc.z Sprite
    sta.z __17
    lda #0
    adc.z Sprite+1
    sta.z __17+1
    // [215] rotate_sprites::$23 = rotate_sprites::$17 + rotate_sprites::$14 -- pduz1=pduz1_plus_vwuz2 
    lda.z __23
    clc
    adc.z __14
    sta.z __23
    lda.z __23+1
    adc.z __14+1
    sta.z __23+1
    // [216] rotate_sprites::vera_sprite_address1_address#0 = *rotate_sprites::$23 -- vduz1=_deref_pduz2 
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
    // [217] rotate_sprites::vera_sprite_address1_$14 = (word)rotate_sprites::vera_sprite_xy1_sprite#0 -- vwuz1=_word_vbuz2 
    lda.z vera_sprite_xy1_sprite
    sta.z vera_sprite_address1___14
    lda #0
    sta.z vera_sprite_address1___14+1
    // [218] rotate_sprites::vera_sprite_address1_$0 = rotate_sprites::vera_sprite_address1_$14 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [219] rotate_sprites::vera_sprite_address1_sprite_offset#0 = <VERA_SPRITE_ATTR + rotate_sprites::vera_sprite_address1_$0 -- vwuz1=vwuc1_plus_vwuz1 
    clc
    lda.z vera_sprite_address1_sprite_offset
    adc #<VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset
    lda.z vera_sprite_address1_sprite_offset+1
    adc #>VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [220] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <sprite_offset
    // [221] rotate_sprites::vera_sprite_address1_$2 = < rotate_sprites::vera_sprite_address1_sprite_offset#0 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_address1_sprite_offset
    sta.z vera_sprite_address1___2
    // *VERA_ADDRX_L = <sprite_offset
    // [222] *VERA_ADDRX_L = rotate_sprites::vera_sprite_address1_$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset
    // [223] rotate_sprites::vera_sprite_address1_$3 = > rotate_sprites::vera_sprite_address1_sprite_offset#0 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_address1_sprite_offset+1
    sta.z vera_sprite_address1___3
    // *VERA_ADDRX_M = >sprite_offset
    // [224] *VERA_ADDRX_M = rotate_sprites::vera_sprite_address1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [225] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <address
    // [226] rotate_sprites::vera_sprite_address1_$4 = < rotate_sprites::vera_sprite_address1_address#0 -- vwuz1=_lo_vduz2 
    lda.z vera_sprite_address1_address
    sta.z vera_sprite_address1___4
    lda.z vera_sprite_address1_address+1
    sta.z vera_sprite_address1___4+1
    // (<address)>>5
    // [227] rotate_sprites::vera_sprite_address1_$5 = rotate_sprites::vera_sprite_address1_$4 >> 5 -- vwuz1=vwuz1_ror_5 
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
    // [228] rotate_sprites::vera_sprite_address1_$6 = < rotate_sprites::vera_sprite_address1_$5 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_address1___5
    sta.z vera_sprite_address1___6
    // *VERA_DATA0 = <((<address)>>5)
    // [229] *VERA_DATA0 = rotate_sprites::vera_sprite_address1_$6 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // <address
    // [230] rotate_sprites::vera_sprite_address1_$7 = < rotate_sprites::vera_sprite_address1_address#0 -- vwuz1=_lo_vduz2 
    lda.z vera_sprite_address1_address
    sta.z vera_sprite_address1___7
    lda.z vera_sprite_address1_address+1
    sta.z vera_sprite_address1___7+1
    // >(<address)
    // [231] rotate_sprites::vera_sprite_address1_$8 = > rotate_sprites::vera_sprite_address1_$7 -- vbuz1=_hi_vwuz2 
    sta.z vera_sprite_address1___8
    // (>(<address))>>5
    // [232] rotate_sprites::vera_sprite_address1_$9 = rotate_sprites::vera_sprite_address1_$8 >> 5 -- vbuz1=vbuz1_ror_5 
    lda.z vera_sprite_address1___9
    lsr
    lsr
    lsr
    lsr
    lsr
    sta.z vera_sprite_address1___9
    // >address
    // [233] rotate_sprites::vera_sprite_address1_$10 = > rotate_sprites::vera_sprite_address1_address#0 -- vwuz1=_hi_vduz2 
    lda.z vera_sprite_address1_address+2
    sta.z vera_sprite_address1___10
    lda.z vera_sprite_address1_address+3
    sta.z vera_sprite_address1___10+1
    // <(>address)
    // [234] rotate_sprites::vera_sprite_address1_$11 = < rotate_sprites::vera_sprite_address1_$10 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_address1___10
    sta.z vera_sprite_address1___11
    // (<(>address))<<3
    // [235] rotate_sprites::vera_sprite_address1_$12 = rotate_sprites::vera_sprite_address1_$11 << 3 -- vbuz1=vbuz1_rol_3 
    lda.z vera_sprite_address1___12
    asl
    asl
    asl
    sta.z vera_sprite_address1___12
    // ((>(<address))>>5)|((<(>address))<<3)
    // [236] rotate_sprites::vera_sprite_address1_$13 = rotate_sprites::vera_sprite_address1_$9 | rotate_sprites::vera_sprite_address1_$12 -- vbuz1=vbuz1_bor_vbuz2 
    lda.z vera_sprite_address1___13
    ora.z vera_sprite_address1___12
    sta.z vera_sprite_address1___13
    // *VERA_DATA0 = ((>(<address))>>5)|((<(>address))<<3)
    // [237] *VERA_DATA0 = rotate_sprites::vera_sprite_address1_$13 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // rotate_sprites::@5
    // s&03
    // [238] rotate_sprites::$7 = rotate_sprites::s#2 & 3 -- vbuz1=vbuz2_band_vbuc1 
    lda #3
    and.z s
    sta.z __7
    // (word)(s&03)<<6
    // [239] rotate_sprites::$21 = (word)rotate_sprites::$7 -- vwuz1=_word_vbuz2 
    sta.z __21
    lda #0
    sta.z __21+1
    // [240] rotate_sprites::$8 = rotate_sprites::$21 << 6 -- vwuz1=vwuz1_rol_6 
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
    // [241] rotate_sprites::vera_sprite_xy1_x#0 = rotate_sprites::basex#8 + rotate_sprites::$8 -- vwuz1=vwuz2_plus_vwuz1 
    lda.z vera_sprite_xy1_x
    clc
    adc.z basex
    sta.z vera_sprite_xy1_x
    lda.z vera_sprite_xy1_x+1
    adc.z basex+1
    sta.z vera_sprite_xy1_x+1
    // s>>2
    // [242] rotate_sprites::$10 = rotate_sprites::s#2 >> 2 -- vbuz1=vbuz2_ror_2 
    lda.z s
    lsr
    lsr
    sta.z __10
    // (word)(s>>2)<<6
    // [243] rotate_sprites::$22 = (word)rotate_sprites::$10 -- vwuz1=_word_vbuz2 
    sta.z __22
    lda #0
    sta.z __22+1
    // [244] rotate_sprites::$11 = rotate_sprites::$22 << 6 -- vwuz1=vwuz1_rol_6 
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
    // [245] rotate_sprites::vera_sprite_xy1_y#0 = $64 + rotate_sprites::$11 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$64
    clc
    adc.z vera_sprite_xy1_y
    sta.z vera_sprite_xy1_y
    bcc !+
    inc.z vera_sprite_xy1_y+1
  !:
    // rotate_sprites::vera_sprite_xy1
    // (word)sprite << 3
    // [246] rotate_sprites::vera_sprite_xy1_$10 = (word)rotate_sprites::vera_sprite_xy1_sprite#0 -- vwuz1=_word_vbuz2 
    lda.z vera_sprite_xy1_sprite
    sta.z vera_sprite_xy1___10
    lda #0
    sta.z vera_sprite_xy1___10+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [247] rotate_sprites::vera_sprite_xy1_sprite_offset#0 = rotate_sprites::vera_sprite_xy1_$10 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [248] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+2
    // [249] rotate_sprites::vera_sprite_xy1_$4 = rotate_sprites::vera_sprite_xy1_sprite_offset#0 + <VERA_SPRITE_ATTR+2 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_xy1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4
    lda.z vera_sprite_xy1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4+1
    // <sprite_offset+2
    // [250] rotate_sprites::vera_sprite_xy1_$3 = < rotate_sprites::vera_sprite_xy1_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_xy1___4
    sta.z vera_sprite_xy1___3
    // *VERA_ADDRX_L = <sprite_offset+2
    // [251] *VERA_ADDRX_L = rotate_sprites::vera_sprite_xy1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+2
    // [252] rotate_sprites::vera_sprite_xy1_$5 = > rotate_sprites::vera_sprite_xy1_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_xy1___4+1
    sta.z vera_sprite_xy1___5
    // *VERA_ADDRX_M = >sprite_offset+2
    // [253] *VERA_ADDRX_M = rotate_sprites::vera_sprite_xy1_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [254] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <x
    // [255] rotate_sprites::vera_sprite_xy1_$6 = < rotate_sprites::vera_sprite_xy1_x#0 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_xy1_x
    sta.z vera_sprite_xy1___6
    // *VERA_DATA0 = <x
    // [256] *VERA_DATA0 = rotate_sprites::vera_sprite_xy1_$6 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // >x
    // [257] rotate_sprites::vera_sprite_xy1_$7 = > rotate_sprites::vera_sprite_xy1_x#0 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_xy1_x+1
    sta.z vera_sprite_xy1___7
    // *VERA_DATA0 = >x
    // [258] *VERA_DATA0 = rotate_sprites::vera_sprite_xy1_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // <y
    // [259] rotate_sprites::vera_sprite_xy1_$8 = < rotate_sprites::vera_sprite_xy1_y#0 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_xy1_y
    sta.z vera_sprite_xy1___8
    // *VERA_DATA0 = <y
    // [260] *VERA_DATA0 = rotate_sprites::vera_sprite_xy1_$8 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // >y
    // [261] rotate_sprites::vera_sprite_xy1_$9 = > rotate_sprites::vera_sprite_xy1_y#0 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_xy1_y+1
    sta.z vera_sprite_xy1___9
    // *VERA_DATA0 = >y
    // [262] *VERA_DATA0 = rotate_sprites::vera_sprite_xy1_$9 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // rotate_sprites::@6
    // for(byte s=0;s<max;s++)
    // [263] rotate_sprites::s#1 = ++ rotate_sprites::s#2 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [205] phi from rotate_sprites::@6 to rotate_sprites::@1 [phi:rotate_sprites::@6->rotate_sprites::@1]
    // [205] phi rotate_sprites::s#2 = rotate_sprites::s#1 [phi:rotate_sprites::@6->rotate_sprites::@1#0] -- register_copy 
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
// memcpy_in_vram(byte zp(9) dest_bank, void* zp(6) dest, byte zp(8) src_bank, byte* zp($55) src, word zp($50) num)
memcpy_in_vram: {
    .label __0 = $4d
    .label __1 = $4e
    .label __2 = 8
    .label __3 = $4f
    .label __4 = $52
    .label __5 = 9
    .label i = 6
    .label dest = 6
    .label src = $55
    .label num = $50
    .label dest_bank = 9
    .label src_bank = 8
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [265] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <src
    // [266] memcpy_in_vram::$0 = < memcpy_in_vram::src#2 -- vbuz1=_lo_pvoz2 
    lda.z src
    sta.z __0
    // *VERA_ADDRX_L = <src
    // [267] *VERA_ADDRX_L = memcpy_in_vram::$0 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // >src
    // [268] memcpy_in_vram::$1 = > memcpy_in_vram::src#2 -- vbuz1=_hi_pvoz2 
    lda.z src+1
    sta.z __1
    // *VERA_ADDRX_M = >src
    // [269] *VERA_ADDRX_M = memcpy_in_vram::$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // src_increment | src_bank
    // [270] memcpy_in_vram::$2 = VERA_INC_1 | memcpy_in_vram::src_bank#2 -- vbuz1=vbuc1_bor_vbuz1 
    lda #VERA_INC_1
    ora.z __2
    sta.z __2
    // *VERA_ADDRX_H = src_increment | src_bank
    // [271] *VERA_ADDRX_H = memcpy_in_vram::$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [272] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    // Select DATA1
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // <dest
    // [273] memcpy_in_vram::$3 = < memcpy_in_vram::dest#2 -- vbuz1=_lo_pvoz2 
    lda.z dest
    sta.z __3
    // *VERA_ADDRX_L = <dest
    // [274] *VERA_ADDRX_L = memcpy_in_vram::$3 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // >dest
    // [275] memcpy_in_vram::$4 = > memcpy_in_vram::dest#2 -- vbuz1=_hi_pvoz2 
    lda.z dest+1
    sta.z __4
    // *VERA_ADDRX_M = >dest
    // [276] *VERA_ADDRX_M = memcpy_in_vram::$4 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // dest_increment | dest_bank
    // [277] memcpy_in_vram::$5 = VERA_INC_1 | memcpy_in_vram::dest_bank#2 -- vbuz1=vbuc1_bor_vbuz1 
    lda #VERA_INC_1
    ora.z __5
    sta.z __5
    // *VERA_ADDRX_H = dest_increment | dest_bank
    // [278] *VERA_ADDRX_H = memcpy_in_vram::$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [279] phi from memcpy_in_vram to memcpy_in_vram::@1 [phi:memcpy_in_vram->memcpy_in_vram::@1]
    // [279] phi memcpy_in_vram::i#2 = 0 [phi:memcpy_in_vram->memcpy_in_vram::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // memcpy_in_vram::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [280] if(memcpy_in_vram::i#2<memcpy_in_vram::num#3) goto memcpy_in_vram::@2 -- vwuz1_lt_vwuz2_then_la1 
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
    // [281] return 
    rts
    // memcpy_in_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [282] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [283] memcpy_in_vram::i#1 = ++ memcpy_in_vram::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [279] phi from memcpy_in_vram::@2 to memcpy_in_vram::@1 [phi:memcpy_in_vram::@2->memcpy_in_vram::@1]
    // [279] phi memcpy_in_vram::i#2 = memcpy_in_vram::i#1 [phi:memcpy_in_vram::@2->memcpy_in_vram::@1#0] -- register_copy 
    jmp __b1
}
  // rand
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
rand: {
    .label __0 = $50
    .label __1 = 6
    .label __2 = $55
    .label return = $55
    // rand_state << 7
    // [285] rand::$0 = rand_state#13 << 7 -- vwuz1=vwuz2_rol_7 
    lda.z rand_state+1
    lsr
    lda.z rand_state
    ror
    sta.z __0+1
    lda #0
    ror
    sta.z __0
    // rand_state ^= rand_state << 7
    // [286] rand_state#0 = rand_state#13 ^ rand::$0 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __0
    sta.z rand_state
    lda.z rand_state+1
    eor.z __0+1
    sta.z rand_state+1
    // rand_state >> 9
    // [287] rand::$1 = rand_state#0 >> 9 -- vwuz1=vwuz2_ror_9 
    lsr
    sta.z __1
    lda #0
    sta.z __1+1
    // rand_state ^= rand_state >> 9
    // [288] rand_state#1 = rand_state#0 ^ rand::$1 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __1
    sta.z rand_state
    lda.z rand_state+1
    eor.z __1+1
    sta.z rand_state+1
    // rand_state << 8
    // [289] rand::$2 = rand_state#1 << 8 -- vwuz1=vwuz2_rol_8 
    lda.z rand_state
    sta.z __2+1
    lda #0
    sta.z __2
    // rand_state ^= rand_state << 8
    // [290] rand_state#14 = rand_state#1 ^ rand::$2 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __2
    sta.z rand_state
    lda.z rand_state+1
    eor.z __2+1
    sta.z rand_state+1
    // return rand_state;
    // [291] rand::return#0 = rand_state#14 -- vwuz1=vwuz2 
    lda.z rand_state
    sta.z return
    lda.z rand_state+1
    sta.z return+1
    // rand::@return
    // }
    // [292] return 
    rts
}
  // modr16u
// Performs modulo on two 16 bit unsigned ints and an initial remainder
// Returns the remainder.
// Implemented using simple binary division
// modr16u(word zp($55) dividend)
modr16u: {
    .label return = 6
    .label dividend = $55
    // divr16u(dividend, divisor, rem)
    // [294] divr16u::dividend#1 = modr16u::dividend#2
    // [295] call divr16u 
    // [1036] phi from modr16u to divr16u [phi:modr16u->divr16u]
    jsr divr16u
    // modr16u::@1
    // return rem16u;
    // [296] modr16u::return#0 = divr16u::rem#10 -- vwuz1=vwuz2 
    lda.z divr16u.rem
    sta.z return
    lda.z divr16u.rem+1
    sta.z return+1
    // modr16u::@return
    // }
    // [297] return 
    rts
}
  // vera_tile_element
// vera_tile_element(byte zp(8) x, byte zp(9) y, struct Tile* zp(6) Tile)
vera_tile_element: {
    .label __3 = $55
    .label __4 = 8
    .label __8 = 9
    .label __11 = 9
    .label __12 = 9
    .label __13 = 9
    .label __14 = 9
    .label __15 = 9
    .label __16 = 9
    .label __17 = $57
    .label __18 = 9
    .label __19 = 9
    .label __33 = $55
    .label vera_vram_address01___0 = $55
    .label vera_vram_address01___1 = 9
    .label vera_vram_address01___2 = $55
    .label vera_vram_address01___3 = 9
    .label vera_vram_address01___4 = $55
    .label vera_vram_address01___5 = 9
    .label vera_vram_address01___6 = 9
    .label TileOffset = $50
    .label TileTotal = $52
    .label TileCount = $bc
    .label TileColumns = $53
    .label PaletteOffset = $54
    .label x = 8
    .label y = 9
    .label mapbase = $a
    .label shift = $4d
    .label rowskip = 6
    .label j = 8
    .label i = $4d
    .label c = $4f
    .label r = $4e
    .label Tile = 6
    // TileOffset = Tile->Offset
    // [299] vera_tile_element::TileOffset#0 = ((word*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_OFFSET] -- vwuz1=pwuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_OFFSET
    lda (Tile),y
    sta.z TileOffset
    iny
    lda (Tile),y
    sta.z TileOffset+1
    // TileTotal = Tile->Total
    // [300] vera_tile_element::TileTotal#0 = ((byte*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_TOTAL] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_TOTAL
    lda (Tile),y
    sta.z TileTotal
    // TileCount = Tile->Count
    // [301] vera_tile_element::TileCount#0 = ((byte*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_COUNT] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_COUNT
    lda (Tile),y
    sta.z TileCount
    // TileColumns = Tile->Columns
    // [302] vera_tile_element::TileColumns#0 = ((byte*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_COLUMNS] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_COLUMNS
    lda (Tile),y
    sta.z TileColumns
    // PaletteOffset = Tile->Palette
    // [303] vera_tile_element::PaletteOffset#0 = ((byte*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_PALETTE] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_PALETTE
    lda (Tile),y
    sta.z PaletteOffset
    // x = x << resolution
    // [304] vera_tile_element::x#0 = vera_tile_element::x#3 << 3 -- vbuz1=vbuz1_rol_3 
    lda.z x
    asl
    asl
    asl
    sta.z x
    // y = y << resolution
    // [305] vera_tile_element::y#0 = vera_tile_element::y#3 << 3 -- vbuz1=vbuz1_rol_3 
    lda.z y
    asl
    asl
    asl
    sta.z y
    // mapbase = vera_mapbase_address[layer]
    // [306] vera_tile_element::mapbase#0 = *vera_mapbase_address -- vduz1=_deref_pduc1 
    lda vera_mapbase_address
    sta.z mapbase
    lda vera_mapbase_address+1
    sta.z mapbase+1
    lda vera_mapbase_address+2
    sta.z mapbase+2
    lda vera_mapbase_address+3
    sta.z mapbase+3
    // shift = vera_layer_rowshift[layer]
    // [307] vera_tile_element::shift#0 = *vera_layer_rowshift -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift
    sta.z shift
    // rowskip = (word)1 << shift
    // [308] vera_tile_element::rowskip#0 = 1 << vera_tile_element::shift#0 -- vwuz1=vwuc1_rol_vbuz2 
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
    // [309] vera_tile_element::$33 = (word)vera_tile_element::y#0 -- vwuz1=_word_vbuz2 
    lda.z y
    sta.z __33
    lda #0
    sta.z __33+1
    // [310] vera_tile_element::$3 = vera_tile_element::$33 << vera_tile_element::shift#0 -- vwuz1=vwuz1_rol_vbuz2 
    ldy.z shift
    beq !e+
  !:
    asl.z __3
    rol.z __3+1
    dey
    bne !-
  !e:
    // mapbase += ((word)y << shift)
    // [311] vera_tile_element::mapbase#1 = vera_tile_element::mapbase#0 + vera_tile_element::$3 -- vduz1=vduz1_plus_vwuz2 
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
    // [312] vera_tile_element::$4 = vera_tile_element::x#0 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __4
    // mapbase += (x << 1)
    // [313] vera_tile_element::mapbase#2 = vera_tile_element::mapbase#1 + vera_tile_element::$4 -- vduz1=vduz1_plus_vbuz2 
    lda.z __4
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
    // [314] phi from vera_tile_element to vera_tile_element::@1 [phi:vera_tile_element->vera_tile_element::@1]
    // [314] phi vera_tile_element::mapbase#11 = vera_tile_element::mapbase#2 [phi:vera_tile_element->vera_tile_element::@1#0] -- register_copy 
    // [314] phi vera_tile_element::j#2 = 0 [phi:vera_tile_element->vera_tile_element::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z j
    // vera_tile_element::@1
  __b1:
    // for(byte j=0;j<TileTotal;j+=(TileTotal>>1))
    // [315] if(vera_tile_element::j#2<vera_tile_element::TileTotal#0) goto vera_tile_element::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z j
    cmp.z TileTotal
    bcc __b3
    // vera_tile_element::@return
    // }
    // [316] return 
    rts
    // [317] phi from vera_tile_element::@1 to vera_tile_element::@2 [phi:vera_tile_element::@1->vera_tile_element::@2]
  __b3:
    // [317] phi vera_tile_element::mapbase#10 = vera_tile_element::mapbase#11 [phi:vera_tile_element::@1->vera_tile_element::@2#0] -- register_copy 
    // [317] phi vera_tile_element::i#10 = 0 [phi:vera_tile_element::@1->vera_tile_element::@2#1] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // vera_tile_element::@2
  __b2:
    // for(byte i=0;i<TileCount;i+=(TileColumns))
    // [318] if(vera_tile_element::i#10<vera_tile_element::TileCount#0) goto vera_tile_element::vera_vram_address01 -- vbuz1_lt_vbuz2_then_la1 
    lda.z i
    cmp.z TileCount
    bcc vera_vram_address01
    // vera_tile_element::@3
    // TileTotal>>1
    // [319] vera_tile_element::$19 = vera_tile_element::TileTotal#0 >> 1 -- vbuz1=vbuz2_ror_1 
    lda.z TileTotal
    lsr
    sta.z __19
    // j+=(TileTotal>>1)
    // [320] vera_tile_element::j#1 = vera_tile_element::j#2 + vera_tile_element::$19 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z j
    clc
    adc.z __19
    sta.z j
    // [314] phi from vera_tile_element::@3 to vera_tile_element::@1 [phi:vera_tile_element::@3->vera_tile_element::@1]
    // [314] phi vera_tile_element::mapbase#11 = vera_tile_element::mapbase#10 [phi:vera_tile_element::@3->vera_tile_element::@1#0] -- register_copy 
    // [314] phi vera_tile_element::j#2 = vera_tile_element::j#1 [phi:vera_tile_element::@3->vera_tile_element::@1#1] -- register_copy 
    jmp __b1
    // vera_tile_element::vera_vram_address01
  vera_vram_address01:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [321] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <bankaddr
    // [322] vera_tile_element::vera_vram_address01_$0 = < vera_tile_element::mapbase#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase
    sta.z vera_vram_address01___0
    lda.z mapbase+1
    sta.z vera_vram_address01___0+1
    // <(<bankaddr)
    // [323] vera_tile_element::vera_vram_address01_$1 = < vera_tile_element::vera_vram_address01_$0 -- vbuz1=_lo_vwuz2 
    lda.z vera_vram_address01___0
    sta.z vera_vram_address01___1
    // *VERA_ADDRX_L = <(<bankaddr)
    // [324] *VERA_ADDRX_L = vera_tile_element::vera_vram_address01_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // <bankaddr
    // [325] vera_tile_element::vera_vram_address01_$2 = < vera_tile_element::mapbase#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase
    sta.z vera_vram_address01___2
    lda.z mapbase+1
    sta.z vera_vram_address01___2+1
    // >(<bankaddr)
    // [326] vera_tile_element::vera_vram_address01_$3 = > vera_tile_element::vera_vram_address01_$2 -- vbuz1=_hi_vwuz2 
    sta.z vera_vram_address01___3
    // *VERA_ADDRX_M = >(<bankaddr)
    // [327] *VERA_ADDRX_M = vera_tile_element::vera_vram_address01_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // >bankaddr
    // [328] vera_tile_element::vera_vram_address01_$4 = > vera_tile_element::mapbase#10 -- vwuz1=_hi_vduz2 
    lda.z mapbase+2
    sta.z vera_vram_address01___4
    lda.z mapbase+3
    sta.z vera_vram_address01___4+1
    // <(>bankaddr)
    // [329] vera_tile_element::vera_vram_address01_$5 = < vera_tile_element::vera_vram_address01_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_vram_address01___4
    sta.z vera_vram_address01___5
    // <(>bankaddr) | incr
    // [330] vera_tile_element::vera_vram_address01_$6 = vera_tile_element::vera_vram_address01_$5 | VERA_INC_1 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_INC_1
    ora.z vera_vram_address01___6
    sta.z vera_vram_address01___6
    // *VERA_ADDRX_H = <(>bankaddr) | incr
    // [331] *VERA_ADDRX_H = vera_tile_element::vera_vram_address01_$6 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [332] phi from vera_tile_element::vera_vram_address01 to vera_tile_element::@4 [phi:vera_tile_element::vera_vram_address01->vera_tile_element::@4]
    // [332] phi vera_tile_element::r#2 = 0 [phi:vera_tile_element::vera_vram_address01->vera_tile_element::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // vera_tile_element::@4
  __b4:
    // TileTotal>>1
    // [333] vera_tile_element::$8 = vera_tile_element::TileTotal#0 >> 1 -- vbuz1=vbuz2_ror_1 
    lda.z TileTotal
    lsr
    sta.z __8
    // for(byte r=0;r<(TileTotal>>1);r+=TileCount)
    // [334] if(vera_tile_element::r#2<vera_tile_element::$8) goto vera_tile_element::@6 -- vbuz1_lt_vbuz2_then_la1 
    lda.z r
    cmp.z __8
    bcc __b5
    // vera_tile_element::@5
    // mapbase += rowskip
    // [335] vera_tile_element::mapbase#3 = vera_tile_element::mapbase#10 + vera_tile_element::rowskip#0 -- vduz1=vduz1_plus_vwuz2 
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
    // [336] vera_tile_element::i#1 = vera_tile_element::i#10 + vera_tile_element::TileColumns#0 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z i
    clc
    adc.z TileColumns
    sta.z i
    // [317] phi from vera_tile_element::@5 to vera_tile_element::@2 [phi:vera_tile_element::@5->vera_tile_element::@2]
    // [317] phi vera_tile_element::mapbase#10 = vera_tile_element::mapbase#3 [phi:vera_tile_element::@5->vera_tile_element::@2#0] -- register_copy 
    // [317] phi vera_tile_element::i#10 = vera_tile_element::i#1 [phi:vera_tile_element::@5->vera_tile_element::@2#1] -- register_copy 
    jmp __b2
    // [337] phi from vera_tile_element::@4 to vera_tile_element::@6 [phi:vera_tile_element::@4->vera_tile_element::@6]
  __b5:
    // [337] phi vera_tile_element::c#2 = 0 [phi:vera_tile_element::@4->vera_tile_element::@6#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // vera_tile_element::@6
  __b6:
    // for(byte c=0;c<TileColumns;c+=1)
    // [338] if(vera_tile_element::c#2<vera_tile_element::TileColumns#0) goto vera_tile_element::@7 -- vbuz1_lt_vbuz2_then_la1 
    lda.z c
    cmp.z TileColumns
    bcc __b7
    // vera_tile_element::@8
    // r+=TileCount
    // [339] vera_tile_element::r#1 = vera_tile_element::r#2 + vera_tile_element::TileCount#0 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z r
    clc
    adc.z TileCount
    sta.z r
    // [332] phi from vera_tile_element::@8 to vera_tile_element::@4 [phi:vera_tile_element::@8->vera_tile_element::@4]
    // [332] phi vera_tile_element::r#2 = vera_tile_element::r#1 [phi:vera_tile_element::@8->vera_tile_element::@4#0] -- register_copy 
    jmp __b4
    // vera_tile_element::@7
  __b7:
    // <TileOffset
    // [340] vera_tile_element::$11 = < vera_tile_element::TileOffset#0 -- vbuz1=_lo_vwuz2 
    lda.z TileOffset
    sta.z __11
    // (<TileOffset)+c
    // [341] vera_tile_element::$12 = vera_tile_element::$11 + vera_tile_element::c#2 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z __12
    clc
    adc.z c
    sta.z __12
    // (<TileOffset)+c+r
    // [342] vera_tile_element::$13 = vera_tile_element::$12 + vera_tile_element::r#2 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z __13
    clc
    adc.z r
    sta.z __13
    // (<TileOffset)+c+r+i
    // [343] vera_tile_element::$14 = vera_tile_element::$13 + vera_tile_element::i#10 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z __14
    clc
    adc.z i
    sta.z __14
    // (<TileOffset)+c+r+i+j
    // [344] vera_tile_element::$15 = vera_tile_element::$14 + vera_tile_element::j#2 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z __15
    clc
    adc.z j
    sta.z __15
    // *VERA_DATA0 = (<TileOffset)+c+r+i+j
    // [345] *VERA_DATA0 = vera_tile_element::$15 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // PaletteOffset << 4
    // [346] vera_tile_element::$16 = vera_tile_element::PaletteOffset#0 << 4 -- vbuz1=vbuz2_rol_4 
    lda.z PaletteOffset
    asl
    asl
    asl
    asl
    sta.z __16
    // >TileOffset
    // [347] vera_tile_element::$17 = > vera_tile_element::TileOffset#0 -- vbuz1=_hi_vwuz2 
    lda.z TileOffset+1
    sta.z __17
    // PaletteOffset << 4 | (>TileOffset)
    // [348] vera_tile_element::$18 = vera_tile_element::$16 | vera_tile_element::$17 -- vbuz1=vbuz1_bor_vbuz2 
    lda.z __18
    ora.z __17
    sta.z __18
    // *VERA_DATA0 = PaletteOffset << 4 | (>TileOffset)
    // [349] *VERA_DATA0 = vera_tile_element::$18 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // c+=1
    // [350] vera_tile_element::c#1 = vera_tile_element::c#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z c
    // [337] phi from vera_tile_element::@7 to vera_tile_element::@6 [phi:vera_tile_element::@7->vera_tile_element::@6]
    // [337] phi vera_tile_element::c#2 = vera_tile_element::c#1 [phi:vera_tile_element::@7->vera_tile_element::@6#0] -- register_copy 
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
    // [352] call vera_layer_mode_tile 
    // [643] phi from vera_layer_mode_text to vera_layer_mode_tile [phi:vera_layer_mode_text->vera_layer_mode_tile]
    // [643] phi vera_layer_mode_tile::tileheight#10 = vera_layer_mode_text::tileheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #tileheight
    sta.z vera_layer_mode_tile.tileheight
    // [643] phi vera_layer_mode_tile::tilewidth#10 = vera_layer_mode_text::tilewidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    lda #tilewidth
    sta.z vera_layer_mode_tile.tilewidth
    // [643] phi vera_layer_mode_tile::tilebase_address#10 = vera_layer_mode_text::tilebase_address#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<tilebase_address>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>tilebase_address>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [643] phi vera_layer_mode_tile::mapbase_address#10 = vera_layer_mode_text::mapbase_address#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<mapbase_address>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>mapbase_address>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [643] phi vera_layer_mode_tile::mapheight#10 = vera_layer_mode_text::mapheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#4] -- vwuz1=vwuc1 
    lda #<mapheight
    sta.z vera_layer_mode_tile.mapheight
    lda #>mapheight
    sta.z vera_layer_mode_tile.mapheight+1
    // [643] phi vera_layer_mode_tile::layer#10 = vera_layer_mode_text::layer#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #layer
    sta.z vera_layer_mode_tile.layer
    // [643] phi vera_layer_mode_tile::mapwidth#10 = vera_layer_mode_text::mapwidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#6] -- vwuz1=vwuc1 
    lda #<mapwidth
    sta.z vera_layer_mode_tile.mapwidth
    lda #>mapwidth
    sta.z vera_layer_mode_tile.mapwidth+1
    // [643] phi vera_layer_mode_tile::color_depth#3 = 1 [phi:vera_layer_mode_text->vera_layer_mode_tile#7] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.color_depth
    jsr vera_layer_mode_tile
    // [353] phi from vera_layer_mode_text to vera_layer_mode_text::@1 [phi:vera_layer_mode_text->vera_layer_mode_text::@1]
    // vera_layer_mode_text::@1
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C )
    // [354] call vera_layer_set_text_color_mode 
    jsr vera_layer_set_text_color_mode
    // vera_layer_mode_text::@return
    // }
    // [355] return 
    rts
}
  // screensize
// Return the current screen size.
screensize: {
    .label x = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    .label y = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    .label __1 = $58
    .label __3 = $59
    .label hscale = $58
    .label vscale = $59
    // hscale = (*VERA_DC_HSCALE) >> 7
    // [356] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    sta.z hscale
    // 40 << hscale
    // [357] screensize::$1 = $28 << screensize::hscale#0 -- vbuz1=vbuc1_rol_vbuz1 
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
    // [358] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbuz1 
    sta x
    // vscale = (*VERA_DC_VSCALE) >> 7
    // [359] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    sta.z vscale
    // 30 << vscale
    // [360] screensize::$3 = $1e << screensize::vscale#0 -- vbuz1=vbuc1_rol_vbuz1 
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
    // [361] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbuz1 
    sta y
    // screensize::@return
    // }
    // [362] return 
    rts
}
  // screenlayer
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer: {
    .label __0 = $5a
    .label __1 = $5b
    .label __4 = $e
    .label __5 = $5b
    .label vera_layer_get_width1___0 = $5f
    .label vera_layer_get_width1___1 = $5f
    .label vera_layer_get_width1___3 = $5f
    .label vera_layer_get_height1___0 = $e
    .label vera_layer_get_height1___1 = $e
    .label vera_layer_get_height1___3 = $e
    .label vera_layer_get_width1_config = $5d
    .label vera_layer_get_width1_return = $5b
    .label vera_layer_get_height1_config = $5b
    .label vera_layer_get_height1_return = $5b
    // cx16_conio.conio_screen_layer = layer
    // [363] *((byte*)&cx16_conio) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta cx16_conio
    // vera_layer_get_mapbase_bank(layer)
    // [364] call vera_layer_get_mapbase_bank 
    jsr vera_layer_get_mapbase_bank
    // [365] vera_layer_get_mapbase_bank::return#2 = vera_layer_get_mapbase_bank::return#0
    // screenlayer::@3
    // [366] screenlayer::$0 = vera_layer_get_mapbase_bank::return#2
    // cx16_conio.conio_screen_bank = vera_layer_get_mapbase_bank(layer)
    // [367] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) = screenlayer::$0 -- _deref_pbuc1=vbuz1 
    lda.z __0
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // vera_layer_get_mapbase_offset(layer)
    // [368] call vera_layer_get_mapbase_offset 
    jsr vera_layer_get_mapbase_offset
    // [369] vera_layer_get_mapbase_offset::return#2 = vera_layer_get_mapbase_offset::return#0
    // screenlayer::@4
    // [370] screenlayer::$1 = vera_layer_get_mapbase_offset::return#2
    // cx16_conio.conio_screen_text = vera_layer_get_mapbase_offset(layer)
    // [371] *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) = (byte*)screenlayer::$1 -- _deref_qbuc1=pbuz1 
    lda.z __1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    lda.z __1+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    // screenlayer::vera_layer_get_width1
    // config = vera_layer_config[layer]
    // [372] screenlayer::vera_layer_get_width1_config#0 = *(vera_layer_config+1<<1) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+(1<<1)
    sta.z vera_layer_get_width1_config
    lda vera_layer_config+(1<<1)+1
    sta.z vera_layer_get_width1_config+1
    // *config & VERA_LAYER_WIDTH_MASK
    // [373] screenlayer::vera_layer_get_width1_$0 = *screenlayer::vera_layer_get_width1_config#0 & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    ldy #0
    and (vera_layer_get_width1_config),y
    sta.z vera_layer_get_width1___0
    // (*config & VERA_LAYER_WIDTH_MASK) >> 4
    // [374] screenlayer::vera_layer_get_width1_$1 = screenlayer::vera_layer_get_width1_$0 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z vera_layer_get_width1___1
    lsr
    lsr
    lsr
    lsr
    sta.z vera_layer_get_width1___1
    // return VERA_LAYER_WIDTH[ (*config & VERA_LAYER_WIDTH_MASK) >> 4];
    // [375] screenlayer::vera_layer_get_width1_$3 = screenlayer::vera_layer_get_width1_$1 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z vera_layer_get_width1___3
    // [376] screenlayer::vera_layer_get_width1_return#0 = VERA_LAYER_WIDTH[screenlayer::vera_layer_get_width1_$3] -- vwuz1=pwuc1_derefidx_vbuz2 
    ldy.z vera_layer_get_width1___3
    lda VERA_LAYER_WIDTH,y
    sta.z vera_layer_get_width1_return
    lda VERA_LAYER_WIDTH+1,y
    sta.z vera_layer_get_width1_return+1
    // screenlayer::@1
    // cx16_conio.conio_map_width = vera_layer_get_width(layer)
    // [377] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) = screenlayer::vera_layer_get_width1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_width1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    lda.z vera_layer_get_width1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    // screenlayer::vera_layer_get_height1
    // config = vera_layer_config[layer]
    // [378] screenlayer::vera_layer_get_height1_config#0 = *(vera_layer_config+1<<1) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+(1<<1)
    sta.z vera_layer_get_height1_config
    lda vera_layer_config+(1<<1)+1
    sta.z vera_layer_get_height1_config+1
    // *config & VERA_LAYER_HEIGHT_MASK
    // [379] screenlayer::vera_layer_get_height1_$0 = *screenlayer::vera_layer_get_height1_config#0 & VERA_LAYER_HEIGHT_MASK -- vbuz1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    ldy #0
    and (vera_layer_get_height1_config),y
    sta.z vera_layer_get_height1___0
    // (*config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [380] screenlayer::vera_layer_get_height1_$1 = screenlayer::vera_layer_get_height1_$0 >> 6 -- vbuz1=vbuz1_ror_6 
    lda.z vera_layer_get_height1___1
    rol
    rol
    rol
    and #3
    sta.z vera_layer_get_height1___1
    // return VERA_LAYER_HEIGHT[ (*config & VERA_LAYER_HEIGHT_MASK) >> 6];
    // [381] screenlayer::vera_layer_get_height1_$3 = screenlayer::vera_layer_get_height1_$1 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z vera_layer_get_height1___3
    // [382] screenlayer::vera_layer_get_height1_return#0 = VERA_LAYER_HEIGHT[screenlayer::vera_layer_get_height1_$3] -- vwuz1=pwuc1_derefidx_vbuz2 
    ldy.z vera_layer_get_height1___3
    lda VERA_LAYER_HEIGHT,y
    sta.z vera_layer_get_height1_return
    lda VERA_LAYER_HEIGHT+1,y
    sta.z vera_layer_get_height1_return+1
    // screenlayer::@2
    // cx16_conio.conio_map_height = vera_layer_get_height(layer)
    // [383] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) = screenlayer::vera_layer_get_height1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_height1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    lda.z vera_layer_get_height1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    // vera_layer_get_rowshift(layer)
    // [384] call vera_layer_get_rowshift 
    jsr vera_layer_get_rowshift
    // [385] vera_layer_get_rowshift::return#2 = vera_layer_get_rowshift::return#0
    // screenlayer::@5
    // [386] screenlayer::$4 = vera_layer_get_rowshift::return#2
    // cx16_conio.conio_rowshift = vera_layer_get_rowshift(layer)
    // [387] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) = screenlayer::$4 -- _deref_pbuc1=vbuz1 
    lda.z __4
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
    // vera_layer_get_rowskip(layer)
    // [388] call vera_layer_get_rowskip 
    jsr vera_layer_get_rowskip
    // [389] vera_layer_get_rowskip::return#2 = vera_layer_get_rowskip::return#0
    // screenlayer::@6
    // [390] screenlayer::$5 = vera_layer_get_rowskip::return#2
    // cx16_conio.conio_rowskip = vera_layer_get_rowskip(layer)
    // [391] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) = screenlayer::$5 -- _deref_pwuc1=vwuz1 
    lda.z __5
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    lda.z __5+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    // screenlayer::@return
    // }
    // [392] return 
    rts
}
  // vera_layer_set_textcolor
// Set the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15) when the VERA works in 16x16 color text mode.
//   An 8 bit value (decimal between 0 and 255) when the VERA works in 256 text mode.
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_set_textcolor(byte zp($e) layer)
vera_layer_set_textcolor: {
    .label layer = $e
    // vera_layer_textcolor[layer] = color
    // [394] vera_layer_textcolor[vera_layer_set_textcolor::layer#2] = WHITE -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #WHITE
    ldy.z layer
    sta vera_layer_textcolor,y
    // vera_layer_set_textcolor::@return
    // }
    // [395] return 
    rts
}
  // vera_layer_set_backcolor
// Set the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_set_backcolor(byte zp($e) layer, byte zp($58) color)
vera_layer_set_backcolor: {
    .label layer = $e
    .label color = $58
    // vera_layer_backcolor[layer] = color
    // [397] vera_layer_backcolor[vera_layer_set_backcolor::layer#2] = vera_layer_set_backcolor::color#2 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z color
    ldy.z layer
    sta vera_layer_backcolor,y
    // vera_layer_set_backcolor::@return
    // }
    // [398] return 
    rts
}
  // vera_layer_set_mapbase
// Set the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - mapbase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// vera_layer_set_mapbase(byte zp($58) layer, byte zp($e) mapbase)
vera_layer_set_mapbase: {
    .label __0 = $58
    .label addr = $5b
    .label layer = $58
    .label mapbase = $e
    // addr = vera_layer_mapbase[layer]
    // [400] vera_layer_set_mapbase::$0 = vera_layer_set_mapbase::layer#3 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __0
    // [401] vera_layer_set_mapbase::addr#0 = vera_layer_mapbase[vera_layer_set_mapbase::$0] -- pbuz1=qbuc1_derefidx_vbuz2 
    ldy.z __0
    lda vera_layer_mapbase,y
    sta.z addr
    lda vera_layer_mapbase+1,y
    sta.z addr+1
    // *addr = mapbase
    // [402] *vera_layer_set_mapbase::addr#0 = vera_layer_set_mapbase::mapbase#3 -- _deref_pbuz1=vbuz2 
    lda.z mapbase
    ldy #0
    sta (addr),y
    // vera_layer_set_mapbase::@return
    // }
    // [403] return 
    rts
}
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
cursor: {
    .const onoff = 0
    // cx16_conio.conio_display_cursor = onoff
    // [404] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR
    // cursor::@return
    // }
    // [405] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// gotoxy(byte zp($e) x, byte zp(5) y)
gotoxy: {
    .label __5 = $58
    .label __6 = $5b
    .label y = 5
    .label line_offset = $5b
    .label x = $e
    // if(y>cx16_conio.conio_screen_height)
    // [407] if(gotoxy::y#4<=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto gotoxy::@3 -- vbuz1_le__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    cmp.z y
    bcs __b1
    // [409] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [409] phi gotoxy::y#5 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z y
    // [408] phi from gotoxy to gotoxy::@3 [phi:gotoxy->gotoxy::@3]
    // gotoxy::@3
    // [409] phi from gotoxy::@3 to gotoxy::@1 [phi:gotoxy::@3->gotoxy::@1]
    // [409] phi gotoxy::y#5 = gotoxy::y#4 [phi:gotoxy::@3->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=cx16_conio.conio_screen_width)
    // [410] if(gotoxy::x#4<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto gotoxy::@4 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z x
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    bcc __b2
    // [412] phi from gotoxy::@1 to gotoxy::@2 [phi:gotoxy::@1->gotoxy::@2]
    // [412] phi gotoxy::x#5 = 0 [phi:gotoxy::@1->gotoxy::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z x
    // [411] phi from gotoxy::@1 to gotoxy::@4 [phi:gotoxy::@1->gotoxy::@4]
    // gotoxy::@4
    // [412] phi from gotoxy::@4 to gotoxy::@2 [phi:gotoxy::@4->gotoxy::@2]
    // [412] phi gotoxy::x#5 = gotoxy::x#4 [phi:gotoxy::@4->gotoxy::@2#0] -- register_copy 
    // gotoxy::@2
  __b2:
    // conio_cursor_x[cx16_conio.conio_screen_layer] = x
    // [413] conio_cursor_x[*((byte*)&cx16_conio)] = gotoxy::x#5 -- pbuc1_derefidx_(_deref_pbuc2)=vbuz1 
    lda.z x
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = y
    // [414] conio_cursor_y[*((byte*)&cx16_conio)] = gotoxy::y#5 -- pbuc1_derefidx_(_deref_pbuc2)=vbuz1 
    lda.z y
    sta conio_cursor_y,y
    // (unsigned int)y << cx16_conio.conio_rowshift
    // [415] gotoxy::$6 = (word)gotoxy::y#5 -- vwuz1=_word_vbuz2 
    sta.z __6
    lda #0
    sta.z __6+1
    // line_offset = (unsigned int)y << cx16_conio.conio_rowshift
    // [416] gotoxy::line_offset#0 = gotoxy::$6 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vwuz1_rol__deref_pbuc1 
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
    // [417] gotoxy::$5 = *((byte*)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __5
    // [418] conio_line_text[gotoxy::$5] = gotoxy::line_offset#0 -- pwuc1_derefidx_vbuz1=vwuz2 
    tay
    lda.z line_offset
    sta conio_line_text,y
    lda.z line_offset+1
    sta conio_line_text+1,y
    // gotoxy::@return
    // }
    // [419] return 
    rts
}
  // load_sprite
// load_sprite(struct Sprite* zp($73) Sprite, dword zp($ca) bram_address)
load_sprite: {
    .label status = $7f
    .label size = $73
    .label return = $ca
    .label Sprite = $73
    .label bram_address = $ca
    // cx16_load_ram_banked(1, 8, 0, Sprite->File, bram_address)
    // [421] cx16_load_ram_banked::filename#0 = (byte*)load_sprite::Sprite#10 -- pbuz1=pbuz2 
    lda.z Sprite
    sta.z cx16_load_ram_banked.filename
    lda.z Sprite+1
    sta.z cx16_load_ram_banked.filename+1
    // [422] cx16_load_ram_banked::address#0 = load_sprite::bram_address#10 -- vduz1=vduz2 
    lda.z bram_address
    sta.z cx16_load_ram_banked.address
    lda.z bram_address+1
    sta.z cx16_load_ram_banked.address+1
    lda.z bram_address+2
    sta.z cx16_load_ram_banked.address+2
    lda.z bram_address+3
    sta.z cx16_load_ram_banked.address+3
    // [423] call cx16_load_ram_banked 
    // [462] phi from load_sprite to cx16_load_ram_banked [phi:load_sprite->cx16_load_ram_banked]
    // [462] phi cx16_load_ram_banked::filename#3 = cx16_load_ram_banked::filename#0 [phi:load_sprite->cx16_load_ram_banked#0] -- register_copy 
    // [462] phi cx16_load_ram_banked::address#3 = cx16_load_ram_banked::address#0 [phi:load_sprite->cx16_load_ram_banked#1] -- register_copy 
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, Sprite->File, bram_address)
    // [424] cx16_load_ram_banked::return#4 = cx16_load_ram_banked::return#1
    // load_sprite::@3
    // status = cx16_load_ram_banked(1, 8, 0, Sprite->File, bram_address)
    // [425] load_sprite::status#0 = cx16_load_ram_banked::return#4 -- vbuz1=vbuz2 
    lda.z cx16_load_ram_banked.return
    sta.z status
    // if(status!=$ff)
    // [426] if(load_sprite::status#0==$ff) goto load_sprite::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [427] phi from load_sprite::@3 to load_sprite::@2 [phi:load_sprite::@3->load_sprite::@2]
    // load_sprite::@2
    // printf("error file %s: %x\n", Sprite->File, status)
    // [428] call cputs 
    // [529] phi from load_sprite::@2 to cputs [phi:load_sprite::@2->cputs]
    // [529] phi cputs::s#13 = s [phi:load_sprite::@2->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // load_sprite::@4
    // printf("error file %s: %x\n", Sprite->File, status)
    // [429] printf_string::str#0 = (byte*)load_sprite::Sprite#10 -- pbuz1=pbuz2 
    lda.z Sprite
    sta.z printf_string.str
    lda.z Sprite+1
    sta.z printf_string.str+1
    // [430] call printf_string 
    // [1065] phi from load_sprite::@4 to printf_string [phi:load_sprite::@4->printf_string]
    // [1065] phi printf_string::str#2 = printf_string::str#0 [phi:load_sprite::@4->printf_string#0] -- register_copy 
    jsr printf_string
    // [431] phi from load_sprite::@4 to load_sprite::@5 [phi:load_sprite::@4->load_sprite::@5]
    // load_sprite::@5
    // printf("error file %s: %x\n", Sprite->File, status)
    // [432] call cputs 
    // [529] phi from load_sprite::@5 to cputs [phi:load_sprite::@5->cputs]
    // [529] phi cputs::s#13 = s1 [phi:load_sprite::@5->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // load_sprite::@6
    // printf("error file %s: %x\n", Sprite->File, status)
    // [433] printf_uchar::uvalue#1 = load_sprite::status#0 -- vbuz1=vbuz2 
    lda.z status
    sta.z printf_uchar.uvalue
    // [434] call printf_uchar 
    // [537] phi from load_sprite::@6 to printf_uchar [phi:load_sprite::@6->printf_uchar]
    // [537] phi printf_uchar::format_radix#4 = HEXADECIMAL [phi:load_sprite::@6->printf_uchar#0] -- vbuz1=vbuc1 
    lda #HEXADECIMAL
    sta.z printf_uchar.format_radix
    // [537] phi printf_uchar::uvalue#4 = printf_uchar::uvalue#1 [phi:load_sprite::@6->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [435] phi from load_sprite::@6 to load_sprite::@7 [phi:load_sprite::@6->load_sprite::@7]
    // load_sprite::@7
    // printf("error file %s: %x\n", Sprite->File, status)
    // [436] call cputs 
    // [529] phi from load_sprite::@7 to cputs [phi:load_sprite::@7->cputs]
    // [529] phi cputs::s#13 = s2 [phi:load_sprite::@7->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // load_sprite::@1
  __b1:
    // Sprite->BRAM_Address = bram_address
    // [437] ((dword*)load_sprite::Sprite#10)[OFFSET_STRUCT_SPRITE_BRAM_ADDRESS] = load_sprite::bram_address#10 -- pduz1_derefidx_vbuc1=vduz2 
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
    // size = Sprite->Size
    // [438] load_sprite::size#0 = (word)((byte*)load_sprite::Sprite#10)[OFFSET_STRUCT_SPRITE_SIZE] -- vwuz1=_word_pbuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_SIZE
    lda (size),y
    sta.z size
    lda #0
    sta.z size+1
    // bram_address + size
    // [439] load_sprite::return#0 = load_sprite::bram_address#10 + load_sprite::size#0 -- vduz1=vduz1_plus_vwuz2 
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
    // [440] return 
    rts
}
  // load_tile
// load_tile(struct Tile* zp($6f) Tile, dword zp($26) bram_address)
load_tile: {
    .label status = $a9
    .label size = $6f
    .label return = $26
    .label Tile = $6f
    .label bram_address = $26
    // cx16_load_ram_banked(1, 8, 0, Tile->File, bram_address)
    // [442] cx16_load_ram_banked::filename#1 = (byte*)load_tile::Tile#10 -- pbuz1=pbuz2 
    lda.z Tile
    sta.z cx16_load_ram_banked.filename
    lda.z Tile+1
    sta.z cx16_load_ram_banked.filename+1
    // [443] cx16_load_ram_banked::address#1 = load_tile::bram_address#10 -- vduz1=vduz2 
    lda.z bram_address
    sta.z cx16_load_ram_banked.address
    lda.z bram_address+1
    sta.z cx16_load_ram_banked.address+1
    lda.z bram_address+2
    sta.z cx16_load_ram_banked.address+2
    lda.z bram_address+3
    sta.z cx16_load_ram_banked.address+3
    // [444] call cx16_load_ram_banked 
    // [462] phi from load_tile to cx16_load_ram_banked [phi:load_tile->cx16_load_ram_banked]
    // [462] phi cx16_load_ram_banked::filename#3 = cx16_load_ram_banked::filename#1 [phi:load_tile->cx16_load_ram_banked#0] -- register_copy 
    // [462] phi cx16_load_ram_banked::address#3 = cx16_load_ram_banked::address#1 [phi:load_tile->cx16_load_ram_banked#1] -- register_copy 
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, Tile->File, bram_address)
    // [445] cx16_load_ram_banked::return#5 = cx16_load_ram_banked::return#1
    // load_tile::@3
    // status = cx16_load_ram_banked(1, 8, 0, Tile->File, bram_address)
    // [446] load_tile::status#0 = cx16_load_ram_banked::return#5 -- vbuz1=vbuz2 
    lda.z cx16_load_ram_banked.return
    sta.z status
    // if(status!=$ff)
    // [447] if(load_tile::status#0==$ff) goto load_tile::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [448] phi from load_tile::@3 to load_tile::@2 [phi:load_tile::@3->load_tile::@2]
    // load_tile::@2
    // printf("error file %s: %x\n", Tile->File, status)
    // [449] call cputs 
    // [529] phi from load_tile::@2 to cputs [phi:load_tile::@2->cputs]
    // [529] phi cputs::s#13 = s [phi:load_tile::@2->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // load_tile::@4
    // printf("error file %s: %x\n", Tile->File, status)
    // [450] printf_string::str#1 = (byte*)load_tile::Tile#10 -- pbuz1=pbuz2 
    lda.z Tile
    sta.z printf_string.str
    lda.z Tile+1
    sta.z printf_string.str+1
    // [451] call printf_string 
    // [1065] phi from load_tile::@4 to printf_string [phi:load_tile::@4->printf_string]
    // [1065] phi printf_string::str#2 = printf_string::str#1 [phi:load_tile::@4->printf_string#0] -- register_copy 
    jsr printf_string
    // [452] phi from load_tile::@4 to load_tile::@5 [phi:load_tile::@4->load_tile::@5]
    // load_tile::@5
    // printf("error file %s: %x\n", Tile->File, status)
    // [453] call cputs 
    // [529] phi from load_tile::@5 to cputs [phi:load_tile::@5->cputs]
    // [529] phi cputs::s#13 = s1 [phi:load_tile::@5->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // load_tile::@6
    // printf("error file %s: %x\n", Tile->File, status)
    // [454] printf_uchar::uvalue#2 = load_tile::status#0 -- vbuz1=vbuz2 
    lda.z status
    sta.z printf_uchar.uvalue
    // [455] call printf_uchar 
    // [537] phi from load_tile::@6 to printf_uchar [phi:load_tile::@6->printf_uchar]
    // [537] phi printf_uchar::format_radix#4 = HEXADECIMAL [phi:load_tile::@6->printf_uchar#0] -- vbuz1=vbuc1 
    lda #HEXADECIMAL
    sta.z printf_uchar.format_radix
    // [537] phi printf_uchar::uvalue#4 = printf_uchar::uvalue#2 [phi:load_tile::@6->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [456] phi from load_tile::@6 to load_tile::@7 [phi:load_tile::@6->load_tile::@7]
    // load_tile::@7
    // printf("error file %s: %x\n", Tile->File, status)
    // [457] call cputs 
    // [529] phi from load_tile::@7 to cputs [phi:load_tile::@7->cputs]
    // [529] phi cputs::s#13 = s2 [phi:load_tile::@7->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // load_tile::@1
  __b1:
    // Tile->BRAM_Address = bram_address
    // [458] ((dword*)load_tile::Tile#10)[OFFSET_STRUCT_TILE_BRAM_ADDRESS] = load_tile::bram_address#10 -- pduz1_derefidx_vbuc1=vduz2 
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
    // size = Tile->Size
    // [459] load_tile::size#0 = ((word*)load_tile::Tile#10)[OFFSET_STRUCT_TILE_SIZE] -- vwuz1=pwuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_SIZE
    lda (size),y
    pha
    iny
    lda (size),y
    sta.z size+1
    pla
    sta.z size
    // bram_address + size
    // [460] load_tile::return#0 = load_tile::bram_address#10 + load_tile::size#0 -- vduz1=vduz1_plus_vwuz2 
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
    // [461] return 
    rts
}
  // cx16_load_ram_banked
// Load a file to cx16 banked RAM at address A000-BFFF.
// Returns a status:
// - 0xff: Success
// - other: Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
// cx16_load_ram_banked(byte* zp($af) filename, dword zp($10) address)
cx16_load_ram_banked: {
    .label __0 = $7b
    .label __1 = $7b
    .label __2 = $b7
    .label __3 = $c5
    .label __4 = $b8
    .label __5 = $b1
    .label __6 = $b1
    .label __7 = $75
    .label __8 = $75
    .label __9 = $b9
    .label __10 = $b1
    .label __11 = $7d
    .label __33 = $b1
    .label __34 = $c8
    .label bank = $b9
    // select the bank
    .label addr = $7d
    .label status = $f
    .label return = $f
    .label ch = $40
    .label status_1 = $7f
    .label filename = $af
    .label address = $10
    // >address
    // [463] cx16_load_ram_banked::$0 = > cx16_load_ram_banked::address#3 -- vwuz1=_hi_vduz2 
    lda.z address+2
    sta.z __0
    lda.z address+3
    sta.z __0+1
    // (>address)<<8
    // [464] cx16_load_ram_banked::$1 = cx16_load_ram_banked::$0 << 8 -- vwuz1=vwuz1_rol_8 
    lda.z __1
    sta.z __1+1
    lda #0
    sta.z __1
    // <(>address)<<8
    // [465] cx16_load_ram_banked::$2 = < cx16_load_ram_banked::$1 -- vbuz1=_lo_vwuz2 
    sta.z __2
    // <address
    // [466] cx16_load_ram_banked::$3 = < cx16_load_ram_banked::address#3 -- vwuz1=_lo_vduz2 
    lda.z address
    sta.z __3
    lda.z address+1
    sta.z __3+1
    // >(<address)
    // [467] cx16_load_ram_banked::$4 = > cx16_load_ram_banked::$3 -- vbuz1=_hi_vwuz2 
    sta.z __4
    // ((word)<(>address)<<8)|>(<address)
    // [468] cx16_load_ram_banked::$33 = (word)cx16_load_ram_banked::$2 -- vwuz1=_word_vbuz2 
    lda.z __2
    sta.z __33
    lda #0
    sta.z __33+1
    // [469] cx16_load_ram_banked::$5 = cx16_load_ram_banked::$33 | cx16_load_ram_banked::$4 -- vwuz1=vwuz1_bor_vbuz2 
    lda.z __4
    ora.z __5
    sta.z __5
    // (((word)<(>address)<<8)|>(<address))>>5
    // [470] cx16_load_ram_banked::$6 = cx16_load_ram_banked::$5 >> 5 -- vwuz1=vwuz1_ror_5 
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
    // [471] cx16_load_ram_banked::$7 = > cx16_load_ram_banked::address#3 -- vwuz1=_hi_vduz2 
    lda.z address+2
    sta.z __7
    lda.z address+3
    sta.z __7+1
    // (>address)<<3
    // [472] cx16_load_ram_banked::$8 = cx16_load_ram_banked::$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    // <(>address)<<3
    // [473] cx16_load_ram_banked::$9 = < cx16_load_ram_banked::$8 -- vbuz1=_lo_vwuz2 
    lda.z __8
    sta.z __9
    // ((((word)<(>address)<<8)|>(<address))>>5)+((word)<(>address)<<3)
    // [474] cx16_load_ram_banked::$34 = (word)cx16_load_ram_banked::$9 -- vwuz1=_word_vbuz2 
    sta.z __34
    lda #0
    sta.z __34+1
    // [475] cx16_load_ram_banked::$10 = cx16_load_ram_banked::$6 + cx16_load_ram_banked::$34 -- vwuz1=vwuz1_plus_vwuz2 
    lda.z __10
    clc
    adc.z __34
    sta.z __10
    lda.z __10+1
    adc.z __34+1
    sta.z __10+1
    // bank = (byte)(((((word)<(>address)<<8)|>(<address))>>5)+((word)<(>address)<<3))
    // [476] cx16_load_ram_banked::bank#0 = (byte)cx16_load_ram_banked::$10 -- vbuz1=_byte_vwuz2 
    lda.z __10
    sta.z bank
    // <address
    // [477] cx16_load_ram_banked::$11 = < cx16_load_ram_banked::address#3 -- vwuz1=_lo_vduz2 
    lda.z address
    sta.z __11
    lda.z address+1
    sta.z __11+1
    // (<address)&0x1FFF
    // [478] cx16_load_ram_banked::addr#0 = cx16_load_ram_banked::$11 & $1fff -- vwuz1=vwuz1_band_vwuc1 
    lda.z addr
    and #<$1fff
    sta.z addr
    lda.z addr+1
    and #>$1fff
    sta.z addr+1
    // addr += 0xA000
    // [479] cx16_load_ram_banked::addr#1 = (byte*)cx16_load_ram_banked::addr#0 + $a000 -- pbuz1=pbuz1_plus_vwuc1 
    // stip off the top 3 bits, which are representing the bank of the word!
    clc
    lda.z addr
    adc #<$a000
    sta.z addr
    lda.z addr+1
    adc #>$a000
    sta.z addr+1
    // cx16_ram_bank(bank)
    // [480] cx16_ram_bank::bank#0 = cx16_load_ram_banked::bank#0 -- vbuz1=vbuz2 
    lda.z bank
    sta.z cx16_ram_bank.bank
    // [481] call cx16_ram_bank 
    // [1069] phi from cx16_load_ram_banked to cx16_ram_bank [phi:cx16_load_ram_banked->cx16_ram_bank]
    // [1069] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#0 [phi:cx16_load_ram_banked->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // cx16_load_ram_banked::@8
    // cbm_k_setnam(filename)
    // [482] cbm_k_setnam::filename = cx16_load_ram_banked::filename#3 -- pbuz1=pbuz2 
    lda.z filename
    sta.z cbm_k_setnam.filename
    lda.z filename+1
    sta.z cbm_k_setnam.filename+1
    // [483] call cbm_k_setnam 
    jsr cbm_k_setnam
    // cx16_load_ram_banked::@9
    // cbm_k_setlfs(channel, device, secondary)
    // [484] cbm_k_setlfs::channel = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cbm_k_setlfs.channel
    // [485] cbm_k_setlfs::device = 8 -- vbuz1=vbuc1 
    lda #8
    sta.z cbm_k_setlfs.device
    // [486] cbm_k_setlfs::secondary = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_setlfs.secondary
    // [487] call cbm_k_setlfs 
    jsr cbm_k_setlfs
    // [488] phi from cx16_load_ram_banked::@9 to cx16_load_ram_banked::@10 [phi:cx16_load_ram_banked::@9->cx16_load_ram_banked::@10]
    // cx16_load_ram_banked::@10
    // cbm_k_open()
    // [489] call cbm_k_open 
    jsr cbm_k_open
    // [490] cbm_k_open::return#2 = cbm_k_open::return#1
    // cx16_load_ram_banked::@11
    // [491] cx16_load_ram_banked::status#1 = cbm_k_open::return#2
    // if(status!=$FF)
    // [492] if(cx16_load_ram_banked::status#1==$ff) goto cx16_load_ram_banked::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [493] phi from cx16_load_ram_banked::@11 cx16_load_ram_banked::@12 cx16_load_ram_banked::@16 to cx16_load_ram_banked::@return [phi:cx16_load_ram_banked::@11/cx16_load_ram_banked::@12/cx16_load_ram_banked::@16->cx16_load_ram_banked::@return]
    // [493] phi cx16_load_ram_banked::return#1 = cx16_load_ram_banked::status#1 [phi:cx16_load_ram_banked::@11/cx16_load_ram_banked::@12/cx16_load_ram_banked::@16->cx16_load_ram_banked::@return#0] -- register_copy 
    // cx16_load_ram_banked::@return
    // }
    // [494] return 
    rts
    // cx16_load_ram_banked::@1
  __b1:
    // cbm_k_chkin(channel)
    // [495] cbm_k_chkin::channel = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cbm_k_chkin.channel
    // [496] call cbm_k_chkin 
    jsr cbm_k_chkin
    // [497] cbm_k_chkin::return#2 = cbm_k_chkin::return#1
    // cx16_load_ram_banked::@12
    // [498] cx16_load_ram_banked::status#2 = cbm_k_chkin::return#2
    // if(status!=$FF)
    // [499] if(cx16_load_ram_banked::status#2==$ff) goto cx16_load_ram_banked::@2 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b2
    rts
    // [500] phi from cx16_load_ram_banked::@12 to cx16_load_ram_banked::@2 [phi:cx16_load_ram_banked::@12->cx16_load_ram_banked::@2]
    // cx16_load_ram_banked::@2
  __b2:
    // cbm_k_chrin()
    // [501] call cbm_k_chrin 
    jsr cbm_k_chrin
    // [502] cbm_k_chrin::return#2 = cbm_k_chrin::return#1
    // cx16_load_ram_banked::@13
    // ch = cbm_k_chrin()
    // [503] cx16_load_ram_banked::ch#1 = cbm_k_chrin::return#2
    // cbm_k_readst()
    // [504] call cbm_k_readst 
    jsr cbm_k_readst
    // [505] cbm_k_readst::return#2 = cbm_k_readst::return#1
    // cx16_load_ram_banked::@14
    // status = cbm_k_readst()
    // [506] cx16_load_ram_banked::status#3 = cbm_k_readst::return#2
    // [507] phi from cx16_load_ram_banked::@14 cx16_load_ram_banked::@18 to cx16_load_ram_banked::@3 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3]
    // [507] phi cx16_load_ram_banked::bank#2 = cx16_load_ram_banked::bank#0 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#0] -- register_copy 
    // [507] phi cx16_load_ram_banked::ch#3 = cx16_load_ram_banked::ch#1 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#1] -- register_copy 
    // [507] phi cx16_load_ram_banked::addr#4 = cx16_load_ram_banked::addr#1 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#2] -- register_copy 
    // [507] phi cx16_load_ram_banked::status#8 = cx16_load_ram_banked::status#3 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#3] -- register_copy 
    // cx16_load_ram_banked::@3
  __b3:
    // while (!status)
    // [508] if(0==cx16_load_ram_banked::status#8) goto cx16_load_ram_banked::@4 -- 0_eq_vbuz1_then_la1 
    lda.z status_1
    cmp #0
    beq __b4
    // cx16_load_ram_banked::@5
    // cbm_k_close(channel)
    // [509] cbm_k_close::channel = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cbm_k_close.channel
    // [510] call cbm_k_close 
    jsr cbm_k_close
    // [511] cbm_k_close::return#2 = cbm_k_close::return#1
    // cx16_load_ram_banked::@15
    // [512] cx16_load_ram_banked::status#10 = cbm_k_close::return#2
    // cbm_k_clrchn()
    // [513] call cbm_k_clrchn 
    jsr cbm_k_clrchn
    // [514] phi from cx16_load_ram_banked::@15 to cx16_load_ram_banked::@16 [phi:cx16_load_ram_banked::@15->cx16_load_ram_banked::@16]
    // cx16_load_ram_banked::@16
    // cx16_ram_bank(1)
    // [515] call cx16_ram_bank 
    // [1069] phi from cx16_load_ram_banked::@16 to cx16_ram_bank [phi:cx16_load_ram_banked::@16->cx16_ram_bank]
    // [1069] phi cx16_ram_bank::bank#11 = 1 [phi:cx16_load_ram_banked::@16->cx16_ram_bank#0] -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_ram_bank.bank
    jsr cx16_ram_bank
    rts
    // cx16_load_ram_banked::@4
  __b4:
    // if(addr == 0xC000)
    // [516] if(cx16_load_ram_banked::addr#4!=$c000) goto cx16_load_ram_banked::@6 -- pbuz1_neq_vwuc1_then_la1 
    lda.z addr+1
    cmp #>$c000
    bne __b6
    lda.z addr
    cmp #<$c000
    bne __b6
    // cx16_load_ram_banked::@7
    // bank++;
    // [517] cx16_load_ram_banked::bank#1 = ++ cx16_load_ram_banked::bank#2 -- vbuz1=_inc_vbuz1 
    inc.z bank
    // cx16_ram_bank(bank)
    // [518] cx16_ram_bank::bank#2 = cx16_load_ram_banked::bank#1 -- vbuz1=vbuz2 
    lda.z bank
    sta.z cx16_ram_bank.bank
    // [519] call cx16_ram_bank 
  //printf(", %u", (word)bank);
    // [1069] phi from cx16_load_ram_banked::@7 to cx16_ram_bank [phi:cx16_load_ram_banked::@7->cx16_ram_bank]
    // [1069] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#2 [phi:cx16_load_ram_banked::@7->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [520] phi from cx16_load_ram_banked::@7 to cx16_load_ram_banked::@6 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@6]
    // [520] phi cx16_load_ram_banked::bank#10 = cx16_load_ram_banked::bank#1 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@6#0] -- register_copy 
    // [520] phi cx16_load_ram_banked::addr#5 = (byte*) 40960 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@6#1] -- pbuz1=pbuc1 
    lda #<$a000
    sta.z addr
    lda #>$a000
    sta.z addr+1
    // [520] phi from cx16_load_ram_banked::@4 to cx16_load_ram_banked::@6 [phi:cx16_load_ram_banked::@4->cx16_load_ram_banked::@6]
    // [520] phi cx16_load_ram_banked::bank#10 = cx16_load_ram_banked::bank#2 [phi:cx16_load_ram_banked::@4->cx16_load_ram_banked::@6#0] -- register_copy 
    // [520] phi cx16_load_ram_banked::addr#5 = cx16_load_ram_banked::addr#4 [phi:cx16_load_ram_banked::@4->cx16_load_ram_banked::@6#1] -- register_copy 
    // cx16_load_ram_banked::@6
  __b6:
    // *addr = ch
    // [521] *cx16_load_ram_banked::addr#5 = cx16_load_ram_banked::ch#3 -- _deref_pbuz1=vbuz2 
    lda.z ch
    ldy #0
    sta (addr),y
    // addr++;
    // [522] cx16_load_ram_banked::addr#10 = ++ cx16_load_ram_banked::addr#5 -- pbuz1=_inc_pbuz1 
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    // cbm_k_chrin()
    // [523] call cbm_k_chrin 
    jsr cbm_k_chrin
    // [524] cbm_k_chrin::return#3 = cbm_k_chrin::return#1
    // cx16_load_ram_banked::@17
    // ch = cbm_k_chrin()
    // [525] cx16_load_ram_banked::ch#2 = cbm_k_chrin::return#3
    // cbm_k_readst()
    // [526] call cbm_k_readst 
    jsr cbm_k_readst
    // [527] cbm_k_readst::return#3 = cbm_k_readst::return#1
    // cx16_load_ram_banked::@18
    // status = cbm_k_readst()
    // [528] cx16_load_ram_banked::status#5 = cbm_k_readst::return#3
    jmp __b3
}
  // cputs
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp($af) s)
cputs: {
    .label c = $ba
    .label s = $af
    // [530] phi from cputs cputs::@2 to cputs::@1 [phi:cputs/cputs::@2->cputs::@1]
    // [530] phi cputs::s#12 = cputs::s#13 [phi:cputs/cputs::@2->cputs::@1#0] -- register_copy 
    // cputs::@1
  __b1:
    // while(c=*s++)
    // [531] cputs::c#1 = *cputs::s#12 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta.z c
    // [532] cputs::s#0 = ++ cputs::s#12 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [533] if(0!=cputs::c#1) goto cputs::@2 -- 0_neq_vbuz1_then_la1 
    lda.z c
    cmp #0
    bne __b2
    // cputs::@return
    // }
    // [534] return 
    rts
    // cputs::@2
  __b2:
    // cputc(c)
    // [535] cputc::c#0 = cputs::c#1
    // [536] call cputc 
    // [1109] phi from cputs::@2 to cputc [phi:cputs::@2->cputc]
    // [1109] phi cputc::c#3 = cputc::c#0 [phi:cputs::@2->cputc#0] -- register_copy 
    jsr cputc
    jmp __b1
}
  // printf_uchar
// Print an unsigned char using a specific format
// printf_uchar(byte zp($f) uvalue, byte zp($7f) format_radix)
printf_uchar: {
    .label uvalue = $f
    .label format_radix = $7f
    // printf_uchar::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [538] *((byte*)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    // [539] uctoa::value#1 = printf_uchar::uvalue#4
    // [540] uctoa::radix#0 = printf_uchar::format_radix#4
    // [541] call uctoa 
    // Format number into buffer
    jsr uctoa
    // printf_uchar::@2
    // printf_number_buffer(printf_buffer, format)
    // [542] printf_number_buffer::buffer_sign#1 = *((byte*)&printf_buffer) -- vbuz1=_deref_pbuc1 
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
    // [543] call printf_number_buffer 
  // Print using format
    // [1171] phi from printf_uchar::@2 to printf_number_buffer [phi:printf_uchar::@2->printf_number_buffer]
    // [1171] phi printf_number_buffer::format_upper_case#10 = 0 [phi:printf_uchar::@2->printf_number_buffer#0] -- vbuz1=vbuc1 
    lda #0
    sta.z printf_number_buffer.format_upper_case
    // [1171] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#1 [phi:printf_uchar::@2->printf_number_buffer#1] -- register_copy 
    // [1171] phi printf_number_buffer::format_zero_padding#10 = 0 [phi:printf_uchar::@2->printf_number_buffer#2] -- vbuz1=vbuc1 
    sta.z printf_number_buffer.format_zero_padding
    // [1171] phi printf_number_buffer::format_justify_left#10 = 0 [phi:printf_uchar::@2->printf_number_buffer#3] -- vbuz1=vbuc1 
    sta.z printf_number_buffer.format_justify_left
    // [1171] phi printf_number_buffer::format_min_length#2 = 0 [phi:printf_uchar::@2->printf_number_buffer#4] -- vbuz1=vbuc1 
    sta.z printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [544] return 
    rts
}
  // cx16_rom_bank
// Configure the bank of a banked rom on the X16.
// cx16_rom_bank(byte zp($40) bank)
cx16_rom_bank: {
    .label bank = $40
    // VIA1->PORT_B = bank
    // [546] *((byte*)VIA1) = cx16_rom_bank::bank#2 -- _deref_pbuc1=vbuz1 
    lda.z bank
    sta VIA1
    // cx16_rom_bank::@return
    // }
    // [547] return 
    rts
}
  // vera_heap_segment_init
// vera heap
// vera_heap_segment_init(byte zp($b9) segmentid, dword zp($26) base, dword zp($ca) size)
vera_heap_segment_init: {
    .label __1 = $ca
    .label __2 = $b9
    .label segment = $b1
    .label return = $6b
    .label base = $26
    .label segmentid = $b9
    .label size = $ca
    .label __17 = $7f
    .label __18 = $7f
    .label __19 = $7f
    .label __20 = $b9
    // &vera_heap_segments[segmentid]
    // [549] vera_heap_segment_init::$17 = vera_heap_segment_init::segmentid#4 << 2 -- vbuz1=vbuz2_rol_2 
    lda.z segmentid
    asl
    asl
    sta.z __17
    // [550] vera_heap_segment_init::$18 = vera_heap_segment_init::$17 + vera_heap_segment_init::segmentid#4 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z __18
    clc
    adc.z segmentid
    sta.z __18
    // [551] vera_heap_segment_init::$19 = vera_heap_segment_init::$18 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __19
    // [552] vera_heap_segment_init::$20 = vera_heap_segment_init::$19 + vera_heap_segment_init::segmentid#4 -- vbuz1=vbuz2_plus_vbuz1 
    lda.z __20
    clc
    adc.z __19
    sta.z __20
    // [553] vera_heap_segment_init::$2 = vera_heap_segment_init::$20 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __2
    // segment = &vera_heap_segments[segmentid]
    // [554] vera_heap_segment_init::segment#0 = vera_heap_segments + vera_heap_segment_init::$2 -- pssz1=pssc1_plus_vbuz2 
    lda.z __2
    clc
    adc #<vera_heap_segments
    sta.z segment
    lda #>vera_heap_segments
    adc #0
    sta.z segment+1
    // segment->size = size
    // [555] *((dword*)vera_heap_segment_init::segment#0) = vera_heap_segment_init::size#4 -- _deref_pduz1=vduz2 
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
    // [556] ((dword*)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_BASE_ADDRESS] = vera_heap_segment_init::base#4 -- pduz1_derefidx_vbuc1=vduz2 
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
    // [557] vera_heap_segment_init::$1 = vera_heap_segment_init::base#4 + vera_heap_segment_init::size#4 -- vduz1=vduz2_plus_vduz1 
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
    // [558] ((dword*)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS] = vera_heap_segment_init::$1 -- pduz1_derefidx_vbuc1=vduz2 
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
    // [559] ((dword*)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS] = vera_heap_segment_init::base#4 -- pduz1_derefidx_vbuc1=vduz2 
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
    // [560] ((struct vera_heap**)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK] = (struct vera_heap*) 0 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK
    lda #<0
    sta (segment),y
    iny
    sta (segment),y
    // segment->tail_block = 0x0000
    // [561] ((struct vera_heap**)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] = (struct vera_heap*) 0 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    sta (segment),y
    iny
    sta (segment),y
    // return segment->base_address;
    // [562] vera_heap_segment_init::return#0 = ((dword*)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_BASE_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
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
    // [563] return 
    rts
}
  // vera_heap_malloc
// vera_heap_malloc(byte zp($7f) segmentid, word zp($3a) size)
vera_heap_malloc: {
    .label size = $3a
    .label address = $67
    .label __8 = $22
    .label __24 = $7f
    .label segment = $75
    .label cx16_ram_bank_current = $aa
    .label size_test = $c8
    .label return = $10
    .label block = $b1
    .label block_1 = $73
    .label tail_block = $6f
    .label segmentid = $7f
    .label __49 = $a9
    .label __50 = $a9
    .label __51 = $a9
    .label __52 = $7f
    // address
    // [565] vera_heap_malloc::address = 0 -- vduz1=vduc1 
    lda #<0
    sta.z address
    sta.z address+1
    lda #<0>>$10
    sta.z address+2
    lda #>0>>$10
    sta.z address+3
    // &(vera_heap_segments[segmentid])
    // [566] vera_heap_malloc::$49 = vera_heap_malloc::segmentid#4 << 2 -- vbuz1=vbuz2_rol_2 
    lda.z segmentid
    asl
    asl
    sta.z __49
    // [567] vera_heap_malloc::$50 = vera_heap_malloc::$49 + vera_heap_malloc::segmentid#4 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z __50
    clc
    adc.z segmentid
    sta.z __50
    // [568] vera_heap_malloc::$51 = vera_heap_malloc::$50 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __51
    // [569] vera_heap_malloc::$52 = vera_heap_malloc::$51 + vera_heap_malloc::segmentid#4 -- vbuz1=vbuz2_plus_vbuz1 
    lda.z __52
    clc
    adc.z __51
    sta.z __52
    // [570] vera_heap_malloc::$24 = vera_heap_malloc::$52 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __24
    // segment = &(vera_heap_segments[segmentid])
    // [571] vera_heap_malloc::segment#0 = vera_heap_segments + vera_heap_malloc::$24 -- pssz1=pssc1_plus_vbuz2 
    lda.z __24
    clc
    adc #<vera_heap_segments
    sta.z segment
    lda #>vera_heap_segments
    adc #0
    sta.z segment+1
    // cx16_ram_bank(vera_heap_ram_bank)
    // [572] call cx16_ram_bank 
    // [1069] phi from vera_heap_malloc to cx16_ram_bank [phi:vera_heap_malloc->cx16_ram_bank]
    // [1069] phi cx16_ram_bank::bank#11 = vera_heap_ram_bank#0 [phi:vera_heap_malloc->cx16_ram_bank#0] -- vbuz1=vbuc1 
    lda #vera_heap_ram_bank
    sta.z cx16_ram_bank.bank
    jsr cx16_ram_bank
    // cx16_ram_bank(vera_heap_ram_bank)
    // [573] cx16_ram_bank::return#14 = cx16_ram_bank::return#0
    // vera_heap_malloc::@12
    // cx16_ram_bank_current = cx16_ram_bank(vera_heap_ram_bank)
    // [574] vera_heap_malloc::cx16_ram_bank_current#0 = cx16_ram_bank::return#14 -- vbuz1=vbuz2 
    lda.z cx16_ram_bank.return
    sta.z cx16_ram_bank_current
    // if (!size)
    // [575] if(0!=vera_heap_malloc::size) goto vera_heap_malloc::@1 -- 0_neq_vwuz1_then_la1 
    lda.z size
    ora.z size+1
    bne __b1
    // vera_heap_malloc::@7
    // cx16_ram_bank(cx16_ram_bank_current)
    // [576] cx16_ram_bank::bank#6 = vera_heap_malloc::cx16_ram_bank_current#0
    // [577] call cx16_ram_bank 
    // [1069] phi from vera_heap_malloc::@7 to cx16_ram_bank [phi:vera_heap_malloc::@7->cx16_ram_bank]
    // [1069] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#6 [phi:vera_heap_malloc::@7->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [578] phi from vera_heap_malloc::@10 vera_heap_malloc::@7 vera_heap_malloc::@8 to vera_heap_malloc::@return [phi:vera_heap_malloc::@10/vera_heap_malloc::@7/vera_heap_malloc::@8->vera_heap_malloc::@return]
  __b7:
    // [578] phi vera_heap_malloc::return#1 = 0 [phi:vera_heap_malloc::@10/vera_heap_malloc::@7/vera_heap_malloc::@8->vera_heap_malloc::@return#0] -- vduz1=vbuc1 
    lda #0
    sta.z return
    sta.z return+1
    sta.z return+2
    sta.z return+3
    // vera_heap_malloc::@return
    // }
    // [579] return 
    rts
    // vera_heap_malloc::@1
  __b1:
    // size_test = size
    // [580] vera_heap_malloc::size_test#0 = vera_heap_malloc::size -- vwuz1=vwuz2 
    // Validate if size is a multiple of 32!
    lda.z size
    sta.z size_test
    lda.z size+1
    sta.z size_test+1
    // size_test >>=5
    // [581] vera_heap_malloc::size_test#1 = vera_heap_malloc::size_test#0 >> 5 -- vwuz1=vwuz1_ror_5 
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
    // [582] vera_heap_malloc::size_test#2 = vera_heap_malloc::size_test#1 << 5 -- vwuz1=vwuz1_rol_5 
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
    // [583] if(vera_heap_malloc::size==vera_heap_malloc::size_test#2) goto vera_heap_malloc::@2 -- vwuz1_eq_vwuz2_then_la1 
    lda.z size
    cmp.z size_test
    bne !+
    lda.z size+1
    cmp.z size_test+1
    beq __b2
  !:
    // vera_heap_malloc::@8
    // cx16_ram_bank(cx16_ram_bank_current)
    // [584] cx16_ram_bank::bank#7 = vera_heap_malloc::cx16_ram_bank_current#0
    // [585] call cx16_ram_bank 
    // [1069] phi from vera_heap_malloc::@8 to cx16_ram_bank [phi:vera_heap_malloc::@8->cx16_ram_bank]
    // [1069] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#7 [phi:vera_heap_malloc::@8->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    jmp __b7
    // vera_heap_malloc::@2
  __b2:
    // vera_heap_block_free_find(segment, size)
    // [586] vera_heap_block_free_find::segment#0 = vera_heap_malloc::segment#0 -- pssz1=pssz2 
    lda.z segment
    sta.z vera_heap_block_free_find.segment
    lda.z segment+1
    sta.z vera_heap_block_free_find.segment+1
    // [587] vera_heap_block_free_find::size#0 = vera_heap_malloc::size -- vduz1=vwuz2 
    lda.z size
    sta.z vera_heap_block_free_find.size
    lda.z size+1
    sta.z vera_heap_block_free_find.size+1
    lda #0
    sta.z vera_heap_block_free_find.size+2
    sta.z vera_heap_block_free_find.size+3
    // [588] call vera_heap_block_free_find 
    jsr vera_heap_block_free_find
    // [589] vera_heap_block_free_find::return#3 = vera_heap_block_free_find::return#2
    // vera_heap_malloc::@13
    // block = vera_heap_block_free_find(segment, size)
    // [590] vera_heap_malloc::block#1 = vera_heap_block_free_find::return#3
    // if (block)
    // [591] if((struct vera_heap*)0==vera_heap_malloc::block#1) goto vera_heap_malloc::@3 -- pssc1_eq_pssz1_then_la1 
    lda.z block
    cmp #<0
    bne !+
    lda.z block+1
    cmp #>0
    beq __b3
  !:
    // vera_heap_malloc::@9
    // vera_heap_block_empty_set(block, 0)
    // [592] vera_heap_block_empty_set::block#0 = vera_heap_malloc::block#1 -- pssz1=pssz2 
    lda.z block
    sta.z vera_heap_block_empty_set.block
    lda.z block+1
    sta.z vera_heap_block_empty_set.block+1
    // [593] call vera_heap_block_empty_set 
    // [1224] phi from vera_heap_malloc::@9 to vera_heap_block_empty_set [phi:vera_heap_malloc::@9->vera_heap_block_empty_set]
    // [1224] phi vera_heap_block_empty_set::block#2 = vera_heap_block_empty_set::block#0 [phi:vera_heap_malloc::@9->vera_heap_block_empty_set#0] -- register_copy 
    jsr vera_heap_block_empty_set
    // vera_heap_malloc::@15
    // cx16_ram_bank(cx16_ram_bank_current)
    // [594] cx16_ram_bank::bank#8 = vera_heap_malloc::cx16_ram_bank_current#0
    // [595] call cx16_ram_bank 
    // [1069] phi from vera_heap_malloc::@15 to cx16_ram_bank [phi:vera_heap_malloc::@15->cx16_ram_bank]
    // [1069] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#8 [phi:vera_heap_malloc::@15->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // vera_heap_malloc::@16
    // vera_heap_block_address_get(block)
    // [596] vera_heap_block_address_get::block#0 = vera_heap_malloc::block#1
    // [597] call vera_heap_block_address_get 
    jsr vera_heap_block_address_get
    // [598] vera_heap_block_address_get::return#2 = vera_heap_block_address_get::return#0
    // vera_heap_malloc::@17
    // return (vera_heap_block_address_get(block));
    // [599] vera_heap_malloc::return#3 = vera_heap_block_address_get::return#2
    // [578] phi from vera_heap_malloc::@17 vera_heap_malloc::@21 to vera_heap_malloc::@return [phi:vera_heap_malloc::@17/vera_heap_malloc::@21->vera_heap_malloc::@return]
    // [578] phi vera_heap_malloc::return#1 = vera_heap_malloc::return#3 [phi:vera_heap_malloc::@17/vera_heap_malloc::@21->vera_heap_malloc::@return#0] -- register_copy 
    rts
    // vera_heap_malloc::@3
  __b3:
    // vera_heap_address(segment, size)
    // [600] vera_heap_address::segment#0 = vera_heap_malloc::segment#0 -- pssz1=pssz2 
    lda.z segment
    sta.z vera_heap_address.segment
    lda.z segment+1
    sta.z vera_heap_address.segment+1
    // [601] vera_heap_address::size#0 = vera_heap_malloc::size -- vduz1=vwuz2 
    lda.z size
    sta.z vera_heap_address.size
    lda.z size+1
    sta.z vera_heap_address.size+1
    lda #0
    sta.z vera_heap_address.size+2
    sta.z vera_heap_address.size+3
    // [602] call vera_heap_address 
    jsr vera_heap_address
    // [603] vera_heap_address::return#3 = vera_heap_address::return#2
    // vera_heap_malloc::@14
    // [604] vera_heap_malloc::$8 = vera_heap_address::return#3
    // address = vera_heap_address(segment, size)
    // [605] vera_heap_malloc::address = vera_heap_malloc::$8 -- vduz1=vduz2 
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
    // [606] if(vera_heap_malloc::address!=0) goto vera_heap_malloc::@4 -- vduz1_neq_0_then_la1 
    lda.z address
    ora.z address+1
    bne __b4
    ora.z address+2
    bne __b4
    ora.z address+3
    bne __b4
    // vera_heap_malloc::@10
    // cx16_ram_bank(cx16_ram_bank_current)
    // [607] cx16_ram_bank::bank#9 = vera_heap_malloc::cx16_ram_bank_current#0
    // [608] call cx16_ram_bank 
    // [1069] phi from vera_heap_malloc::@10 to cx16_ram_bank [phi:vera_heap_malloc::@10->cx16_ram_bank]
    // [1069] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#9 [phi:vera_heap_malloc::@10->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    jmp __b7
    // vera_heap_malloc::@4
  __b4:
    // if (segment->head_block==0x0000)
    // [609] if(((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK]==0) goto vera_heap_malloc::@5 -- qssz1_derefidx_vbuc1_eq_0_then_la1 
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
    // [610] vera_heap_malloc::block#3 = ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] + SIZEOF_STRUCT_VERA_HEAP*SIZEOF_STRUCT_VERA_HEAP -- pssz1=qssz2_derefidx_vbuc1_plus_vbuc2 
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
    // [611] vera_heap_malloc::tail_block#0 = ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    lda (segment),y
    sta.z tail_block
    iny
    lda (segment),y
    sta.z tail_block+1
    // block->prev = tail_block
    // [612] ((struct vera_heap**)vera_heap_malloc::block#3)[OFFSET_STRUCT_VERA_HEAP_PREV] = vera_heap_malloc::tail_block#0 -- qssz1_derefidx_vbuc1=pssz2 
    //TODO: error or fragment
    ldy #OFFSET_STRUCT_VERA_HEAP_PREV
    lda.z tail_block
    sta (block_1),y
    iny
    lda.z tail_block+1
    sta (block_1),y
    // tail_block->next = block
    // [613] ((struct vera_heap**)vera_heap_malloc::tail_block#0)[OFFSET_STRUCT_VERA_HEAP_NEXT] = vera_heap_malloc::block#3 -- qssz1_derefidx_vbuc1=pssz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_NEXT
    lda.z block_1
    sta (tail_block),y
    iny
    lda.z block_1+1
    sta (tail_block),y
    // segment->tail_block = block
    // [614] ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] = vera_heap_malloc::block#3 -- qssz1_derefidx_vbuc1=pssz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    lda.z block_1
    sta (segment),y
    iny
    lda.z block_1+1
    sta (segment),y
    // block->next = 0x0000
    // [615] ((struct vera_heap**)vera_heap_malloc::block#3)[OFFSET_STRUCT_VERA_HEAP_NEXT] = (struct vera_heap*) 0 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_NEXT
    lda #<0
    sta (block_1),y
    iny
    sta (block_1),y
    // [616] phi from vera_heap_malloc::@11 to vera_heap_malloc::@6 [phi:vera_heap_malloc::@11->vera_heap_malloc::@6]
    // [616] phi vera_heap_malloc::block#6 = vera_heap_malloc::block#3 [phi:vera_heap_malloc::@11->vera_heap_malloc::@6#0] -- register_copy 
    // vera_heap_malloc::@6
  __b6:
    // vera_heap_block_address_set(block, &address)
    // [617] vera_heap_block_address_set::block#0 = vera_heap_malloc::block#6 -- pssz1=pssz2 
    lda.z block_1
    sta.z vera_heap_block_address_set.block
    lda.z block_1+1
    sta.z vera_heap_block_address_set.block+1
    // [618] call vera_heap_block_address_set 
    jsr vera_heap_block_address_set
    // vera_heap_malloc::@18
    // vera_heap_block_size_set(block, &size)
    // [619] vera_heap_block_size_set::block#0 = vera_heap_malloc::block#6 -- pssz1=pssz2 
    lda.z block_1
    sta.z vera_heap_block_size_set.block
    lda.z block_1+1
    sta.z vera_heap_block_size_set.block+1
    // [620] call vera_heap_block_size_set 
    jsr vera_heap_block_size_set
    // vera_heap_malloc::@19
    // vera_heap_block_empty_set(block, 0)
    // [621] vera_heap_block_empty_set::block#1 = vera_heap_malloc::block#6
    // [622] call vera_heap_block_empty_set 
    // [1224] phi from vera_heap_malloc::@19 to vera_heap_block_empty_set [phi:vera_heap_malloc::@19->vera_heap_block_empty_set]
    // [1224] phi vera_heap_block_empty_set::block#2 = vera_heap_block_empty_set::block#1 [phi:vera_heap_malloc::@19->vera_heap_block_empty_set#0] -- register_copy 
    jsr vera_heap_block_empty_set
    // vera_heap_malloc::@20
    // cx16_ram_bank(cx16_ram_bank_current)
    // [623] cx16_ram_bank::bank#10 = vera_heap_malloc::cx16_ram_bank_current#0
    // [624] call cx16_ram_bank 
    // [1069] phi from vera_heap_malloc::@20 to cx16_ram_bank [phi:vera_heap_malloc::@20->cx16_ram_bank]
    // [1069] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#10 [phi:vera_heap_malloc::@20->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // vera_heap_malloc::@21
    // return address;
    // [625] vera_heap_malloc::return#5 = vera_heap_malloc::address -- vduz1=vduz2 
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
    // [626] ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK] = (struct vera_heap*) 40960 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK
    lda #<$a000
    sta (segment),y
    iny
    lda #>$a000
    sta (segment),y
    // segment->tail_block = 0xA000
    // [627] ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] = (struct vera_heap*) 40960 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    lda #<$a000
    sta (segment),y
    iny
    lda #>$a000
    sta (segment),y
    // block->next = 0x0000
    // [628] *((struct vera_heap**)(struct vera_heap*) 40960+OFFSET_STRUCT_VERA_HEAP_NEXT) = (struct vera_heap*) 0 -- _deref_qssc1=pssc2 
    lda #<0
    sta $a000+OFFSET_STRUCT_VERA_HEAP_NEXT
    sta $a000+OFFSET_STRUCT_VERA_HEAP_NEXT+1
    // block->prev = 0x0000
    // [629] *((struct vera_heap**)(struct vera_heap*) 40960+OFFSET_STRUCT_VERA_HEAP_PREV) = (struct vera_heap*) 0 -- _deref_qssc1=pssc2 
    sta $a000+OFFSET_STRUCT_VERA_HEAP_PREV
    sta $a000+OFFSET_STRUCT_VERA_HEAP_PREV+1
    // [616] phi from vera_heap_malloc::@5 to vera_heap_malloc::@6 [phi:vera_heap_malloc::@5->vera_heap_malloc::@6]
    // [616] phi vera_heap_malloc::block#6 = (struct vera_heap*) 40960 [phi:vera_heap_malloc::@5->vera_heap_malloc::@6#0] -- pssz1=pssc1 
    lda #<$a000
    sta.z block_1
    lda #>$a000
    sta.z block_1+1
    jmp __b6
}
  // vera_cpy_vram_vram
// Copy block of memory (from VRAM to VRAM)
// Copies the values from the location pointed by src to the location pointed by dest.
// The method uses the VERA access ports 0 and 1 to copy data from and to in VRAM.
// - vdest: pointer to the location to copy to. Note that the address is a dword value!
// - vsrc: pointer to the location to copy from. Note that the address is a dword value!
// - num: The number of bytes to copy
vera_cpy_vram_vram: {
    .label i = $ca
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [630] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_L = <(<vsrc)
    // [631] *VERA_ADDRX_L = 0 -- _deref_pbuc1=vbuc2 
    // Set address
    lda #0
    sta VERA_ADDRX_L
    // *VERA_ADDRX_M = >(<vsrc)
    // [632] *VERA_ADDRX_M = ><VERA_PETSCII_TILE -- _deref_pbuc1=vbuc2 
    lda #>VERA_PETSCII_TILE&$ffff
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>vsrc)
    // [633] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [634] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    // Select DATA1
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_L = <(<vdest)
    // [635] *VERA_ADDRX_L = 0 -- _deref_pbuc1=vbuc2 
    // Set address
    lda #0
    sta VERA_ADDRX_L
    // *VERA_ADDRX_M = >(<vdest)
    // [636] *VERA_ADDRX_M = ><VRAM_PETSCII_TILE -- _deref_pbuc1=vbuc2 
    lda #>VRAM_PETSCII_TILE&$ffff
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>vdest)
    // [637] *VERA_ADDRX_H = VERA_INC_1|<>VRAM_PETSCII_TILE -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VRAM_PETSCII_TILE>>$10))
    sta VERA_ADDRX_H
    // [638] phi from vera_cpy_vram_vram to vera_cpy_vram_vram::@1 [phi:vera_cpy_vram_vram->vera_cpy_vram_vram::@1]
    // [638] phi vera_cpy_vram_vram::i#2 = 0 [phi:vera_cpy_vram_vram->vera_cpy_vram_vram::@1#0] -- vduz1=vduc1 
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
    // [639] if(vera_cpy_vram_vram::i#2<VERA_PETSCII_TILE_SIZE) goto vera_cpy_vram_vram::@2 -- vduz1_lt_vduc1_then_la1 
    lda.z i+3
    cmp #>VERA_PETSCII_TILE_SIZE>>$10
    bcc __b2
    bne !+
    lda.z i+2
    cmp #<VERA_PETSCII_TILE_SIZE>>$10
    bcc __b2
    bne !+
    lda.z i+1
    cmp #>VERA_PETSCII_TILE_SIZE
    bcc __b2
    bne !+
    lda.z i
    cmp #<VERA_PETSCII_TILE_SIZE
    bcc __b2
  !:
    // vera_cpy_vram_vram::@return
    // }
    // [640] return 
    rts
    // vera_cpy_vram_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [641] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(dword i=0; i<num; i++)
    // [642] vera_cpy_vram_vram::i#1 = ++ vera_cpy_vram_vram::i#2 -- vduz1=_inc_vduz1 
    inc.z i
    bne !+
    inc.z i+1
    bne !+
    inc.z i+2
    bne !+
    inc.z i+3
  !:
    // [638] phi from vera_cpy_vram_vram::@2 to vera_cpy_vram_vram::@1 [phi:vera_cpy_vram_vram::@2->vera_cpy_vram_vram::@1]
    // [638] phi vera_cpy_vram_vram::i#2 = vera_cpy_vram_vram::i#1 [phi:vera_cpy_vram_vram::@2->vera_cpy_vram_vram::@1#0] -- register_copy 
    jmp __b1
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
// vera_layer_mode_tile(byte zp($59) layer, dword zp($14) mapbase_address, dword zp($18) tilebase_address, word zp($5b) mapwidth, word zp($5d) mapheight, byte zp($5a) tilewidth, byte zp($5f) tileheight, byte zp($58) color_depth)
vera_layer_mode_tile: {
    .label __1 = $5b
    .label __2 = $5b
    .label __4 = $5b
    .label __7 = $5b
    .label __8 = $5b
    .label __10 = $5b
    .label __13 = $58
    .label __14 = $58
    .label __15 = $58
    .label __16 = $58
    .label __19 = $71
    .label __20 = $72
    // config
    .label config = $e
    .label mapbase_address = $14
    .label mapbase = $e
    .label tilebase_address = $18
    .label tilebase = $e
    .label color_depth = $58
    .label layer = $59
    .label mapwidth = $5b
    .label mapheight = $5d
    .label tilewidth = $5a
    .label tileheight = $5f
    // case 1:
    //             config |= VERA_LAYER_COLOR_DEPTH_1BPP;
    //             break;
    // [644] if(vera_layer_mode_tile::color_depth#3==1) goto vera_layer_mode_tile::@5 -- vbuz1_eq_vbuc1_then_la1 
    lda #1
    cmp.z color_depth
    beq __b1
    // vera_layer_mode_tile::@1
    // case 2:
    //             config |= VERA_LAYER_COLOR_DEPTH_2BPP;
    //             break;
    // [645] if(vera_layer_mode_tile::color_depth#3==2) goto vera_layer_mode_tile::@5 -- vbuz1_eq_vbuc1_then_la1 
    lda #2
    cmp.z color_depth
    beq __b2
    // vera_layer_mode_tile::@2
    // case 4:
    //             config |= VERA_LAYER_COLOR_DEPTH_4BPP;
    //             break;
    // [646] if(vera_layer_mode_tile::color_depth#3==4) goto vera_layer_mode_tile::@5 -- vbuz1_eq_vbuc1_then_la1 
    lda #4
    cmp.z color_depth
    beq __b3
    // vera_layer_mode_tile::@3
    // case 8:
    //             config |= VERA_LAYER_COLOR_DEPTH_8BPP;
    //             break;
    // [647] if(vera_layer_mode_tile::color_depth#3!=8) goto vera_layer_mode_tile::@5 -- vbuz1_neq_vbuc1_then_la1 
    lda #8
    cmp.z color_depth
    bne __b4
    // [648] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@4 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@4]
    // vera_layer_mode_tile::@4
    // [649] phi from vera_layer_mode_tile::@4 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5]
    // [649] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_8BPP [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_8BPP
    sta.z config
    jmp __b5
    // [649] phi from vera_layer_mode_tile to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5]
  __b1:
    // [649] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_1BPP [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_1BPP
    sta.z config
    jmp __b5
    // [649] phi from vera_layer_mode_tile::@1 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5]
  __b2:
    // [649] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_2BPP [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_2BPP
    sta.z config
    jmp __b5
    // [649] phi from vera_layer_mode_tile::@2 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5]
  __b3:
    // [649] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_4BPP [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #VERA_LAYER_COLOR_DEPTH_4BPP
    sta.z config
    jmp __b5
    // [649] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5]
  __b4:
    // [649] phi vera_layer_mode_tile::config#17 = 0 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5#0] -- vbuz1=vbuc1 
    lda #0
    sta.z config
    // vera_layer_mode_tile::@5
  __b5:
    // case 32:
    //             config |= VERA_LAYER_WIDTH_32;
    //             vera_layer_rowshift[layer] = 6;
    //             vera_layer_rowskip[layer] = 64;
    //             break;
    // [650] if(vera_layer_mode_tile::mapwidth#10==$20) goto vera_layer_mode_tile::@9 -- vwuz1_eq_vbuc1_then_la1 
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
    // [651] if(vera_layer_mode_tile::mapwidth#10==$40) goto vera_layer_mode_tile::@10 -- vwuz1_eq_vbuc1_then_la1 
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
    // [652] if(vera_layer_mode_tile::mapwidth#10==$80) goto vera_layer_mode_tile::@11 -- vwuz1_eq_vbuc1_then_la1 
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
    // [653] if(vera_layer_mode_tile::mapwidth#10!=$100) goto vera_layer_mode_tile::@13 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapwidth+1
    cmp #>$100
    bne __b13
    lda.z mapwidth
    cmp #<$100
    bne __b13
    // vera_layer_mode_tile::@12
    // config |= VERA_LAYER_WIDTH_256
    // [654] vera_layer_mode_tile::config#8 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_256 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_WIDTH_256
    ora.z config
    sta.z config
    // vera_layer_rowshift[layer] = 9
    // [655] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 9 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #9
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 512
    // [656] vera_layer_mode_tile::$16 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z __16
    // [657] vera_layer_rowskip[vera_layer_mode_tile::$16] = $200 -- pwuc1_derefidx_vbuz1=vwuc2 
    tay
    lda #<$200
    sta vera_layer_rowskip,y
    lda #>$200
    sta vera_layer_rowskip+1,y
    // [658] phi from vera_layer_mode_tile::@10 vera_layer_mode_tile::@11 vera_layer_mode_tile::@12 vera_layer_mode_tile::@8 vera_layer_mode_tile::@9 to vera_layer_mode_tile::@13 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13]
    // [658] phi vera_layer_mode_tile::config#21 = vera_layer_mode_tile::config#6 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13#0] -- register_copy 
    // vera_layer_mode_tile::@13
  __b13:
    // case 32:
    //             config |= VERA_LAYER_HEIGHT_32;
    //             break;
    // [659] if(vera_layer_mode_tile::mapheight#10==$20) goto vera_layer_mode_tile::@20 -- vwuz1_eq_vbuc1_then_la1 
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
    // [660] if(vera_layer_mode_tile::mapheight#10==$40) goto vera_layer_mode_tile::@17 -- vwuz1_eq_vbuc1_then_la1 
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
    // [661] if(vera_layer_mode_tile::mapheight#10==$80) goto vera_layer_mode_tile::@18 -- vwuz1_eq_vbuc1_then_la1 
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
    // [662] if(vera_layer_mode_tile::mapheight#10!=$100) goto vera_layer_mode_tile::@20 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapheight+1
    cmp #>$100
    bne __b20
    lda.z mapheight
    cmp #<$100
    bne __b20
    // vera_layer_mode_tile::@19
    // config |= VERA_LAYER_HEIGHT_256
    // [663] vera_layer_mode_tile::config#12 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_256 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_HEIGHT_256
    ora.z config
    sta.z config
    // [664] phi from vera_layer_mode_tile::@13 vera_layer_mode_tile::@16 vera_layer_mode_tile::@17 vera_layer_mode_tile::@18 vera_layer_mode_tile::@19 to vera_layer_mode_tile::@20 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20]
    // [664] phi vera_layer_mode_tile::config#25 = vera_layer_mode_tile::config#21 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20#0] -- register_copy 
    // vera_layer_mode_tile::@20
  __b20:
    // vera_layer_set_config(layer, config)
    // [665] vera_layer_set_config::layer#0 = vera_layer_mode_tile::layer#10
    // [666] vera_layer_set_config::config#0 = vera_layer_mode_tile::config#25
    // [667] call vera_layer_set_config 
    jsr vera_layer_set_config
    // vera_layer_mode_tile::@27
    // <mapbase_address
    // [668] vera_layer_mode_tile::$1 = < vera_layer_mode_tile::mapbase_address#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase_address
    sta.z __1
    lda.z mapbase_address+1
    sta.z __1+1
    // vera_mapbase_offset[layer] = <mapbase_address
    // [669] vera_layer_mode_tile::$19 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z layer
    asl
    sta.z __19
    // [670] vera_mapbase_offset[vera_layer_mode_tile::$19] = vera_layer_mode_tile::$1 -- pwuc1_derefidx_vbuz1=vwuz2 
    // mapbase
    tay
    lda.z __1
    sta vera_mapbase_offset,y
    lda.z __1+1
    sta vera_mapbase_offset+1,y
    // >mapbase_address
    // [671] vera_layer_mode_tile::$2 = > vera_layer_mode_tile::mapbase_address#10 -- vwuz1=_hi_vduz2 
    lda.z mapbase_address+2
    sta.z __2
    lda.z mapbase_address+3
    sta.z __2+1
    // vera_mapbase_bank[layer] = (byte)(>mapbase_address)
    // [672] vera_mapbase_bank[vera_layer_mode_tile::layer#10] = (byte)vera_layer_mode_tile::$2 -- pbuc1_derefidx_vbuz1=_byte_vwuz2 
    ldy.z layer
    lda.z __2
    sta vera_mapbase_bank,y
    // vera_mapbase_address[layer] = mapbase_address
    // [673] vera_layer_mode_tile::$20 = vera_layer_mode_tile::layer#10 << 2 -- vbuz1=vbuz2_rol_2 
    tya
    asl
    asl
    sta.z __20
    // [674] vera_mapbase_address[vera_layer_mode_tile::$20] = vera_layer_mode_tile::mapbase_address#10 -- pduc1_derefidx_vbuz1=vduz2 
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
    // [675] vera_layer_mode_tile::mapbase_address#0 = vera_layer_mode_tile::mapbase_address#10 >> 1 -- vduz1=vduz1_ror_1 
    lsr.z mapbase_address+3
    ror.z mapbase_address+2
    ror.z mapbase_address+1
    ror.z mapbase_address
    // <mapbase_address
    // [676] vera_layer_mode_tile::$4 = < vera_layer_mode_tile::mapbase_address#0 -- vwuz1=_lo_vduz2 
    lda.z mapbase_address
    sta.z __4
    lda.z mapbase_address+1
    sta.z __4+1
    // mapbase = >(<mapbase_address)
    // [677] vera_layer_mode_tile::mapbase#0 = > vera_layer_mode_tile::$4 -- vbuz1=_hi_vwuz2 
    sta.z mapbase
    // vera_layer_set_mapbase(layer,mapbase)
    // [678] vera_layer_set_mapbase::layer#0 = vera_layer_mode_tile::layer#10 -- vbuz1=vbuz2 
    lda.z layer
    sta.z vera_layer_set_mapbase.layer
    // [679] vera_layer_set_mapbase::mapbase#0 = vera_layer_mode_tile::mapbase#0
    // [680] call vera_layer_set_mapbase 
    // [399] phi from vera_layer_mode_tile::@27 to vera_layer_set_mapbase [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase]
    // [399] phi vera_layer_set_mapbase::mapbase#3 = vera_layer_set_mapbase::mapbase#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#0] -- register_copy 
    // [399] phi vera_layer_set_mapbase::layer#3 = vera_layer_set_mapbase::layer#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#1] -- register_copy 
    jsr vera_layer_set_mapbase
    // vera_layer_mode_tile::@28
    // <tilebase_address
    // [681] vera_layer_mode_tile::$7 = < vera_layer_mode_tile::tilebase_address#10 -- vwuz1=_lo_vduz2 
    lda.z tilebase_address
    sta.z __7
    lda.z tilebase_address+1
    sta.z __7+1
    // vera_tilebase_offset[layer] = <tilebase_address
    // [682] vera_tilebase_offset[vera_layer_mode_tile::$19] = vera_layer_mode_tile::$7 -- pwuc1_derefidx_vbuz1=vwuz2 
    // tilebase
    ldy.z __19
    lda.z __7
    sta vera_tilebase_offset,y
    lda.z __7+1
    sta vera_tilebase_offset+1,y
    // >tilebase_address
    // [683] vera_layer_mode_tile::$8 = > vera_layer_mode_tile::tilebase_address#10 -- vwuz1=_hi_vduz2 
    lda.z tilebase_address+2
    sta.z __8
    lda.z tilebase_address+3
    sta.z __8+1
    // vera_tilebase_bank[layer] = (byte)>tilebase_address
    // [684] vera_tilebase_bank[vera_layer_mode_tile::layer#10] = (byte)vera_layer_mode_tile::$8 -- pbuc1_derefidx_vbuz1=_byte_vwuz2 
    ldy.z layer
    lda.z __8
    sta vera_tilebase_bank,y
    // vera_tilebase_address[layer] = tilebase_address
    // [685] vera_tilebase_address[vera_layer_mode_tile::$20] = vera_layer_mode_tile::tilebase_address#10 -- pduc1_derefidx_vbuz1=vduz2 
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
    // [686] vera_layer_mode_tile::tilebase_address#0 = vera_layer_mode_tile::tilebase_address#10 >> 1 -- vduz1=vduz1_ror_1 
    lsr.z tilebase_address+3
    ror.z tilebase_address+2
    ror.z tilebase_address+1
    ror.z tilebase_address
    // <tilebase_address
    // [687] vera_layer_mode_tile::$10 = < vera_layer_mode_tile::tilebase_address#0 -- vwuz1=_lo_vduz2 
    lda.z tilebase_address
    sta.z __10
    lda.z tilebase_address+1
    sta.z __10+1
    // tilebase = >(<tilebase_address)
    // [688] vera_layer_mode_tile::tilebase#0 = > vera_layer_mode_tile::$10 -- vbuz1=_hi_vwuz2 
    sta.z tilebase
    // tilebase &= VERA_LAYER_TILEBASE_MASK
    // [689] vera_layer_mode_tile::tilebase#1 = vera_layer_mode_tile::tilebase#0 & VERA_LAYER_TILEBASE_MASK -- vbuz1=vbuz1_band_vbuc1 
    lda #VERA_LAYER_TILEBASE_MASK
    and.z tilebase
    sta.z tilebase
    // case 8:
    //             tilebase |= VERA_TILEBASE_WIDTH_8;
    //             break;
    // [690] if(vera_layer_mode_tile::tilewidth#10==8) goto vera_layer_mode_tile::@23 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tilewidth
    beq __b23
    // vera_layer_mode_tile::@21
    // case 16:
    //             tilebase |= VERA_TILEBASE_WIDTH_16;
    //             break;
    // [691] if(vera_layer_mode_tile::tilewidth#10!=$10) goto vera_layer_mode_tile::@23 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tilewidth
    bne __b23
    // vera_layer_mode_tile::@22
    // tilebase |= VERA_TILEBASE_WIDTH_16
    // [692] vera_layer_mode_tile::tilebase#3 = vera_layer_mode_tile::tilebase#1 | VERA_TILEBASE_WIDTH_16 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_TILEBASE_WIDTH_16
    ora.z tilebase
    sta.z tilebase
    // [693] phi from vera_layer_mode_tile::@21 vera_layer_mode_tile::@22 vera_layer_mode_tile::@28 to vera_layer_mode_tile::@23 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23]
    // [693] phi vera_layer_mode_tile::tilebase#12 = vera_layer_mode_tile::tilebase#1 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23#0] -- register_copy 
    // vera_layer_mode_tile::@23
  __b23:
    // case 8:
    //             tilebase |= VERA_TILEBASE_HEIGHT_8;
    //             break;
    // [694] if(vera_layer_mode_tile::tileheight#10==8) goto vera_layer_mode_tile::@26 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tileheight
    beq __b26
    // vera_layer_mode_tile::@24
    // case 16:
    //             tilebase |= VERA_TILEBASE_HEIGHT_16;
    //             break;
    // [695] if(vera_layer_mode_tile::tileheight#10!=$10) goto vera_layer_mode_tile::@26 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tileheight
    bne __b26
    // vera_layer_mode_tile::@25
    // tilebase |= VERA_TILEBASE_HEIGHT_16
    // [696] vera_layer_mode_tile::tilebase#5 = vera_layer_mode_tile::tilebase#12 | VERA_TILEBASE_HEIGHT_16 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_TILEBASE_HEIGHT_16
    ora.z tilebase
    sta.z tilebase
    // [697] phi from vera_layer_mode_tile::@23 vera_layer_mode_tile::@24 vera_layer_mode_tile::@25 to vera_layer_mode_tile::@26 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26]
    // [697] phi vera_layer_mode_tile::tilebase#10 = vera_layer_mode_tile::tilebase#12 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26#0] -- register_copy 
    // vera_layer_mode_tile::@26
  __b26:
    // vera_layer_set_tilebase(layer,tilebase)
    // [698] vera_layer_set_tilebase::layer#0 = vera_layer_mode_tile::layer#10
    // [699] vera_layer_set_tilebase::tilebase#0 = vera_layer_mode_tile::tilebase#10
    // [700] call vera_layer_set_tilebase 
    jsr vera_layer_set_tilebase
    // vera_layer_mode_tile::@return
    // }
    // [701] return 
    rts
    // vera_layer_mode_tile::@18
  __b18:
    // config |= VERA_LAYER_HEIGHT_128
    // [702] vera_layer_mode_tile::config#11 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_128 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_HEIGHT_128
    ora.z config
    sta.z config
    jmp __b20
    // vera_layer_mode_tile::@17
  __b17:
    // config |= VERA_LAYER_HEIGHT_64
    // [703] vera_layer_mode_tile::config#10 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_64 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_HEIGHT_64
    ora.z config
    sta.z config
    jmp __b20
    // vera_layer_mode_tile::@11
  __b11:
    // config |= VERA_LAYER_WIDTH_128
    // [704] vera_layer_mode_tile::config#7 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_128 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_WIDTH_128
    ora.z config
    sta.z config
    // vera_layer_rowshift[layer] = 8
    // [705] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 8 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #8
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 256
    // [706] vera_layer_mode_tile::$15 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z __15
    // [707] vera_layer_rowskip[vera_layer_mode_tile::$15] = $100 -- pwuc1_derefidx_vbuz1=vwuc2 
    tay
    lda #<$100
    sta vera_layer_rowskip,y
    lda #>$100
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@10
  __b10:
    // config |= VERA_LAYER_WIDTH_64
    // [708] vera_layer_mode_tile::config#6 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_64 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_LAYER_WIDTH_64
    ora.z config
    sta.z config
    // vera_layer_rowshift[layer] = 7
    // [709] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 7 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #7
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 128
    // [710] vera_layer_mode_tile::$14 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z __14
    // [711] vera_layer_rowskip[vera_layer_mode_tile::$14] = $80 -- pwuc1_derefidx_vbuz1=vbuc2 
    lda #$80
    ldy.z __14
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@9
  __b9:
    // vera_layer_rowshift[layer] = 6
    // [712] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 6 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #6
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 64
    // [713] vera_layer_mode_tile::$13 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    tya
    asl
    sta.z __13
    // [714] vera_layer_rowskip[vera_layer_mode_tile::$13] = $40 -- pwuc1_derefidx_vbuz1=vbuc2 
    lda #$40
    ldy.z __13
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b13
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __0 = $b3
    .label __1 = $b3
    .label __2 = $b4
    .label __5 = $b6
    .label __6 = $b7
    .label __7 = $b8
    .label __9 = $b5
    .label line_text = $6f
    .label color = $b3
    .label conio_map_height = $73
    .label conio_map_width = $75
    .label c = $40
    .label l = $7f
    // line_text = cx16_conio.conio_screen_text
    // [715] clrscr::line_text#0 = *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- pbuz1=_deref_qbuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z line_text+1
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer)
    // [716] vera_layer_get_backcolor::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_backcolor.layer
    // [717] call vera_layer_get_backcolor 
    jsr vera_layer_get_backcolor
    // [718] vera_layer_get_backcolor::return#2 = vera_layer_get_backcolor::return#0
    // clrscr::@7
    // [719] clrscr::$0 = vera_layer_get_backcolor::return#2
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4
    // [720] clrscr::$1 = clrscr::$0 << 4 -- vbuz1=vbuz1_rol_4 
    lda.z __1
    asl
    asl
    asl
    asl
    sta.z __1
    // vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [721] vera_layer_get_textcolor::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_textcolor.layer
    // [722] call vera_layer_get_textcolor 
    jsr vera_layer_get_textcolor
    // [723] vera_layer_get_textcolor::return#2 = vera_layer_get_textcolor::return#0
    // clrscr::@8
    // [724] clrscr::$2 = vera_layer_get_textcolor::return#2
    // color = ( vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4 ) | vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [725] clrscr::color#0 = clrscr::$1 | clrscr::$2 -- vbuz1=vbuz1_bor_vbuz2 
    lda.z color
    ora.z __2
    sta.z color
    // conio_map_height = cx16_conio.conio_map_height
    // [726] clrscr::conio_map_height#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    sta.z conio_map_height
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    sta.z conio_map_height+1
    // conio_map_width = cx16_conio.conio_map_width
    // [727] clrscr::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // [728] phi from clrscr::@8 to clrscr::@1 [phi:clrscr::@8->clrscr::@1]
    // [728] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr::@8->clrscr::@1#0] -- register_copy 
    // [728] phi clrscr::l#2 = 0 [phi:clrscr::@8->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<conio_map_height; l++ )
    // [729] if(clrscr::l#2<clrscr::conio_map_height#0) goto clrscr::@2 -- vbuz1_lt_vwuz2_then_la1 
    lda.z conio_map_height+1
    bne __b2
    lda.z l
    cmp.z conio_map_height
    bcc __b2
    // clrscr::@3
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [730] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = 0
    // [731] conio_cursor_y[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    sta conio_cursor_y,y
    // conio_line_text[cx16_conio.conio_screen_layer] = 0
    // [732] clrscr::$9 = *((byte*)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    tya
    asl
    sta.z __9
    // [733] conio_line_text[clrscr::$9] = 0 -- pwuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z __9
    sta conio_line_text,y
    sta conio_line_text+1,y
    // clrscr::@return
    // }
    // [734] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [735] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <ch
    // [736] clrscr::$5 = < clrscr::line_text#2 -- vbuz1=_lo_pbuz2 
    lda.z line_text
    sta.z __5
    // *VERA_ADDRX_L = <ch
    // [737] *VERA_ADDRX_L = clrscr::$5 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // >ch
    // [738] clrscr::$6 = > clrscr::line_text#2 -- vbuz1=_hi_pbuz2 
    lda.z line_text+1
    sta.z __6
    // *VERA_ADDRX_M = >ch
    // [739] *VERA_ADDRX_M = clrscr::$6 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [740] clrscr::$7 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    sta.z __7
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [741] *VERA_ADDRX_H = clrscr::$7 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [742] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [742] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@4
  __b4:
    // for( char c=0;c<conio_map_width; c++ )
    // [743] if(clrscr::c#2<clrscr::conio_map_width#0) goto clrscr::@5 -- vbuz1_lt_vwuz2_then_la1 
    lda.z conio_map_width+1
    bne __b5
    lda.z c
    cmp.z conio_map_width
    bcc __b5
    // clrscr::@6
    // line_text += cx16_conio.conio_rowskip
    // [744] clrscr::line_text#1 = clrscr::line_text#2 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- pbuz1=pbuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z line_text
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z line_text+1
    sta.z line_text+1
    // for( char l=0;l<conio_map_height; l++ )
    // [745] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [728] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [728] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [728] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [746] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [747] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<conio_map_width; c++ )
    // [748] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [742] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [742] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
}
  // vera_heap_segment_ceiling
// vera_heap_segment_ceiling(byte zp($40) segmentid)
vera_heap_segment_ceiling: {
    .label __1 = $40
    .label segment = $73
    .label return = $26
    .label segmentid = $40
    .label __4 = $b4
    .label __5 = $b4
    .label __6 = $b4
    .label __7 = $40
    // &vera_heap_segments[segmentid]
    // [750] vera_heap_segment_ceiling::$4 = vera_heap_segment_ceiling::segmentid#2 << 2 -- vbuz1=vbuz2_rol_2 
    lda.z segmentid
    asl
    asl
    sta.z __4
    // [751] vera_heap_segment_ceiling::$5 = vera_heap_segment_ceiling::$4 + vera_heap_segment_ceiling::segmentid#2 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z __5
    clc
    adc.z segmentid
    sta.z __5
    // [752] vera_heap_segment_ceiling::$6 = vera_heap_segment_ceiling::$5 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __6
    // [753] vera_heap_segment_ceiling::$7 = vera_heap_segment_ceiling::$6 + vera_heap_segment_ceiling::segmentid#2 -- vbuz1=vbuz2_plus_vbuz1 
    lda.z __7
    clc
    adc.z __6
    sta.z __7
    // [754] vera_heap_segment_ceiling::$1 = vera_heap_segment_ceiling::$7 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __1
    // segment = &vera_heap_segments[segmentid]
    // [755] vera_heap_segment_ceiling::segment#0 = vera_heap_segments + vera_heap_segment_ceiling::$1 -- pssz1=pssc1_plus_vbuz2 
    lda.z __1
    clc
    adc #<vera_heap_segments
    sta.z segment
    lda #>vera_heap_segments
    adc #0
    sta.z segment+1
    // return segment->ceil_address;
    // [756] vera_heap_segment_ceiling::return#0 = ((dword*)vera_heap_segment_ceiling::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
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
    // [757] return 
    rts
}
  // sprite_cpy_vram
// sprite_cpy_vram(struct Sprite* zp($7b) Sprite, byte zp($b4) num)
sprite_cpy_vram: {
    .label __5 = $3c
    .label __8 = $b5
    .label __10 = $75
    .label bsrc = $ab
    .label vaddr = $10
    .label baddr = $3c
    .label s = $b6
    .label Sprite = $7b
    .label num = $b4
    // bsrc = Sprite->BRAM_Address
    // [759] sprite_cpy_vram::bsrc#0 = ((dword*)sprite_cpy_vram::Sprite#2)[OFFSET_STRUCT_SPRITE_BRAM_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
    // Copy graphics to the VERA VRAM.
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
    // [760] phi from sprite_cpy_vram to sprite_cpy_vram::@1 [phi:sprite_cpy_vram->sprite_cpy_vram::@1]
    // [760] phi sprite_cpy_vram::s#10 = 0 [phi:sprite_cpy_vram->sprite_cpy_vram::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z s
    // sprite_cpy_vram::@1
  __b1:
    // for(byte s=0;s<num;s++)
    // [761] if(sprite_cpy_vram::s#10<sprite_cpy_vram::num#3) goto sprite_cpy_vram::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z s
    cmp.z num
    bcc __b2
    // sprite_cpy_vram::@return
    // }
    // [762] return 
    rts
    // sprite_cpy_vram::@2
  __b2:
    // vera_heap_malloc(segmentid, size)
    // [763] vera_heap_malloc::size = $200 -- vwuz1=vwuc1 
    lda #<$200
    sta.z vera_heap_malloc.size
    lda #>$200
    sta.z vera_heap_malloc.size+1
    // [764] call vera_heap_malloc 
    // [564] phi from sprite_cpy_vram::@2 to vera_heap_malloc [phi:sprite_cpy_vram::@2->vera_heap_malloc]
    // [564] phi vera_heap_malloc::segmentid#4 = HEAP_SPRITES [phi:sprite_cpy_vram::@2->vera_heap_malloc#0] -- vbuz1=vbuc1 
    lda #HEAP_SPRITES
    sta.z vera_heap_malloc.segmentid
    jsr vera_heap_malloc
    // vera_heap_malloc(segmentid, size)
    // [765] vera_heap_malloc::return#11 = vera_heap_malloc::return#1
    // sprite_cpy_vram::@3
    // vaddr = vera_heap_malloc(segmentid, size)
    // [766] sprite_cpy_vram::vaddr#0 = vera_heap_malloc::return#11
    // gotoxy(10, 10+s)
    // [767] gotoxy::y#3 = $a + sprite_cpy_vram::s#10 -- vbuz1=vbuc1_plus_vbuz2 
    lda #$a
    clc
    adc.z s
    sta.z gotoxy.y
    // [768] call gotoxy 
    // [406] phi from sprite_cpy_vram::@3 to gotoxy [phi:sprite_cpy_vram::@3->gotoxy]
    // [406] phi gotoxy::x#4 = $a [phi:sprite_cpy_vram::@3->gotoxy#0] -- vbuz1=vbuc1 
    lda #$a
    sta.z gotoxy.x
    // [406] phi gotoxy::y#4 = gotoxy::y#3 [phi:sprite_cpy_vram::@3->gotoxy#1] -- register_copy 
    jsr gotoxy
    // [769] phi from sprite_cpy_vram::@3 to sprite_cpy_vram::@4 [phi:sprite_cpy_vram::@3->sprite_cpy_vram::@4]
    // sprite_cpy_vram::@4
    // printf("vram sprite %u = %x", s, vaddr)
    // [770] call cputs 
    // [529] phi from sprite_cpy_vram::@4 to cputs [phi:sprite_cpy_vram::@4->cputs]
    // [529] phi cputs::s#13 = sprite_cpy_vram::s1 [phi:sprite_cpy_vram::@4->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // sprite_cpy_vram::@5
    // printf("vram sprite %u = %x", s, vaddr)
    // [771] printf_uchar::uvalue#0 = sprite_cpy_vram::s#10 -- vbuz1=vbuz2 
    lda.z s
    sta.z printf_uchar.uvalue
    // [772] call printf_uchar 
    // [537] phi from sprite_cpy_vram::@5 to printf_uchar [phi:sprite_cpy_vram::@5->printf_uchar]
    // [537] phi printf_uchar::format_radix#4 = DECIMAL [phi:sprite_cpy_vram::@5->printf_uchar#0] -- vbuz1=vbuc1 
    lda #DECIMAL
    sta.z printf_uchar.format_radix
    // [537] phi printf_uchar::uvalue#4 = printf_uchar::uvalue#0 [phi:sprite_cpy_vram::@5->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [773] phi from sprite_cpy_vram::@5 to sprite_cpy_vram::@6 [phi:sprite_cpy_vram::@5->sprite_cpy_vram::@6]
    // sprite_cpy_vram::@6
    // printf("vram sprite %u = %x", s, vaddr)
    // [774] call cputs 
    // [529] phi from sprite_cpy_vram::@6 to cputs [phi:sprite_cpy_vram::@6->cputs]
    // [529] phi cputs::s#13 = sprite_cpy_vram::s2 [phi:sprite_cpy_vram::@6->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // sprite_cpy_vram::@7
    // printf("vram sprite %u = %x", s, vaddr)
    // [775] printf_ulong::uvalue#0 = sprite_cpy_vram::vaddr#0 -- vduz1=vduz2 
    lda.z vaddr
    sta.z printf_ulong.uvalue
    lda.z vaddr+1
    sta.z printf_ulong.uvalue+1
    lda.z vaddr+2
    sta.z printf_ulong.uvalue+2
    lda.z vaddr+3
    sta.z printf_ulong.uvalue+3
    // [776] call printf_ulong 
    // [1282] phi from sprite_cpy_vram::@7 to printf_ulong [phi:sprite_cpy_vram::@7->printf_ulong]
    jsr printf_ulong
    // sprite_cpy_vram::@8
    // mul16u((word)s,size)
    // [777] mul16u::a#1 = (word)sprite_cpy_vram::s#10 -- vwuz1=_word_vbuz2 
    lda.z s
    sta.z mul16u.a
    lda #0
    sta.z mul16u.a+1
    // [778] call mul16u 
    // [1289] phi from sprite_cpy_vram::@8 to mul16u [phi:sprite_cpy_vram::@8->mul16u]
    // [1289] phi mul16u::a#6 = mul16u::a#1 [phi:sprite_cpy_vram::@8->mul16u#0] -- register_copy 
    // [1289] phi mul16u::b#2 = $200 [phi:sprite_cpy_vram::@8->mul16u#1] -- vwuz1=vwuc1 
    lda #<$200
    sta.z mul16u.b
    lda #>$200
    sta.z mul16u.b+1
    jsr mul16u
    // mul16u((word)s,size)
    // [779] mul16u::return#2 = mul16u::res#2
    // sprite_cpy_vram::@9
    // [780] sprite_cpy_vram::$5 = mul16u::return#2
    // baddr = bsrc+mul16u((word)s,size)
    // [781] sprite_cpy_vram::baddr#0 = sprite_cpy_vram::bsrc#0 + sprite_cpy_vram::$5 -- vduz1=vduz2_plus_vduz1 
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
    // [782] vera_cpy_bank_vram::bsrc#0 = sprite_cpy_vram::baddr#0
    // [783] vera_cpy_bank_vram::vdest#0 = sprite_cpy_vram::vaddr#0 -- vduz1=vduz2 
    lda.z vaddr
    sta.z vera_cpy_bank_vram.vdest
    lda.z vaddr+1
    sta.z vera_cpy_bank_vram.vdest+1
    lda.z vaddr+2
    sta.z vera_cpy_bank_vram.vdest+2
    lda.z vaddr+3
    sta.z vera_cpy_bank_vram.vdest+3
    // [784] call vera_cpy_bank_vram 
    // [810] phi from sprite_cpy_vram::@9 to vera_cpy_bank_vram [phi:sprite_cpy_vram::@9->vera_cpy_bank_vram]
    // [810] phi vera_cpy_bank_vram::num#5 = $200 [phi:sprite_cpy_vram::@9->vera_cpy_bank_vram#0] -- vduz1=vduc1 
    lda #<$200
    sta.z vera_cpy_bank_vram.num
    lda #>$200
    sta.z vera_cpy_bank_vram.num+1
    lda #<$200>>$10
    sta.z vera_cpy_bank_vram.num+2
    lda #>$200>>$10
    sta.z vera_cpy_bank_vram.num+3
    // [810] phi vera_cpy_bank_vram::bsrc#3 = vera_cpy_bank_vram::bsrc#0 [phi:sprite_cpy_vram::@9->vera_cpy_bank_vram#1] -- register_copy 
    // [810] phi vera_cpy_bank_vram::vdest#3 = vera_cpy_bank_vram::vdest#0 [phi:sprite_cpy_vram::@9->vera_cpy_bank_vram#2] -- register_copy 
    jsr vera_cpy_bank_vram
    // sprite_cpy_vram::@10
    // Sprite->VRAM_Addresses[s] = vaddr
    // [785] sprite_cpy_vram::$8 = sprite_cpy_vram::s#10 << 2 -- vbuz1=vbuz2_rol_2 
    lda.z s
    asl
    asl
    sta.z __8
    // [786] sprite_cpy_vram::$10 = (dword*)sprite_cpy_vram::Sprite#2 + OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES -- pduz1=pduz2_plus_vbuc1 
    lda #OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES
    clc
    adc.z Sprite
    sta.z __10
    lda #0
    adc.z Sprite+1
    sta.z __10+1
    // [787] sprite_cpy_vram::$10[sprite_cpy_vram::$8] = sprite_cpy_vram::vaddr#0 -- pduz1_derefidx_vbuz2=vduz3 
    ldy.z __8
    lda.z vaddr
    sta (__10),y
    iny
    lda.z vaddr+1
    sta (__10),y
    iny
    lda.z vaddr+2
    sta (__10),y
    iny
    lda.z vaddr+3
    sta (__10),y
    // for(byte s=0;s<num;s++)
    // [788] sprite_cpy_vram::s#1 = ++ sprite_cpy_vram::s#10 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [760] phi from sprite_cpy_vram::@10 to sprite_cpy_vram::@1 [phi:sprite_cpy_vram::@10->sprite_cpy_vram::@1]
    // [760] phi sprite_cpy_vram::s#10 = sprite_cpy_vram::s#1 [phi:sprite_cpy_vram::@10->sprite_cpy_vram::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    s1: .text "vram sprite "
    .byte 0
    s2: .text " = "
    .byte 0
}
.segment Code
  // tile_cpy_vram
// tile_cpy_vram(struct Tile* zp($c5) Tile, byte zp($20) num)
tile_cpy_vram: {
    .label __2 = $3c
    .label __5 = $b6
    .label __7 = $7b
    .label bsrc = $ce
    .label vaddr = $77
    .label baddr = $3c
    .label s = $21
    .label Tile = $c5
    .label num = $20
    // bsrc = Tile->BRAM_Address
    // [790] tile_cpy_vram::bsrc#0 = ((dword*)tile_cpy_vram::Tile#3)[OFFSET_STRUCT_TILE_BRAM_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
    // Copy graphics to the VERA VRAM.
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
    // [791] phi from tile_cpy_vram to tile_cpy_vram::@1 [phi:tile_cpy_vram->tile_cpy_vram::@1]
    // [791] phi tile_cpy_vram::s#2 = 0 [phi:tile_cpy_vram->tile_cpy_vram::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z s
    // tile_cpy_vram::@1
  __b1:
    // for(byte s=0;s<num;s++)
    // [792] if(tile_cpy_vram::s#2<tile_cpy_vram::num#4) goto tile_cpy_vram::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z s
    cmp.z num
    bcc __b2
    // tile_cpy_vram::@return
    // }
    // [793] return 
    rts
    // tile_cpy_vram::@2
  __b2:
    // vera_heap_malloc(segmentid, size)
    // [794] vera_heap_malloc::size = $800 -- vwuz1=vwuc1 
    lda #<$800
    sta.z vera_heap_malloc.size
    lda #>$800
    sta.z vera_heap_malloc.size+1
    // [795] call vera_heap_malloc 
    // [564] phi from tile_cpy_vram::@2 to vera_heap_malloc [phi:tile_cpy_vram::@2->vera_heap_malloc]
    // [564] phi vera_heap_malloc::segmentid#4 = HEAP_FLOOR_TILE [phi:tile_cpy_vram::@2->vera_heap_malloc#0] -- vbuz1=vbuc1 
    lda #HEAP_FLOOR_TILE
    sta.z vera_heap_malloc.segmentid
    jsr vera_heap_malloc
    // vera_heap_malloc(segmentid, size)
    // [796] vera_heap_malloc::return#12 = vera_heap_malloc::return#1
    // tile_cpy_vram::@3
    // vaddr = vera_heap_malloc(segmentid, size)
    // [797] tile_cpy_vram::vaddr#0 = vera_heap_malloc::return#12 -- vduz1=vduz2 
    lda.z vera_heap_malloc.return
    sta.z vaddr
    lda.z vera_heap_malloc.return+1
    sta.z vaddr+1
    lda.z vera_heap_malloc.return+2
    sta.z vaddr+2
    lda.z vera_heap_malloc.return+3
    sta.z vaddr+3
    // mul16u((word)s,size)
    // [798] mul16u::a#2 = (word)tile_cpy_vram::s#2 -- vwuz1=_word_vbuz2 
    lda.z s
    sta.z mul16u.a
    lda #0
    sta.z mul16u.a+1
    // [799] call mul16u 
    // [1289] phi from tile_cpy_vram::@3 to mul16u [phi:tile_cpy_vram::@3->mul16u]
    // [1289] phi mul16u::a#6 = mul16u::a#2 [phi:tile_cpy_vram::@3->mul16u#0] -- register_copy 
    // [1289] phi mul16u::b#2 = $800 [phi:tile_cpy_vram::@3->mul16u#1] -- vwuz1=vwuc1 
    lda #<$800
    sta.z mul16u.b
    lda #>$800
    sta.z mul16u.b+1
    jsr mul16u
    // mul16u((word)s,size)
    // [800] mul16u::return#3 = mul16u::res#2
    // tile_cpy_vram::@4
    // [801] tile_cpy_vram::$2 = mul16u::return#3
    // baddr = bsrc+mul16u((word)s,size)
    // [802] tile_cpy_vram::baddr#0 = tile_cpy_vram::bsrc#0 + tile_cpy_vram::$2 -- vduz1=vduz2_plus_vduz1 
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
    // [803] vera_cpy_bank_vram::bsrc#1 = tile_cpy_vram::baddr#0
    // [804] vera_cpy_bank_vram::vdest#1 = tile_cpy_vram::vaddr#0 -- vduz1=vduz2 
    lda.z vaddr
    sta.z vera_cpy_bank_vram.vdest
    lda.z vaddr+1
    sta.z vera_cpy_bank_vram.vdest+1
    lda.z vaddr+2
    sta.z vera_cpy_bank_vram.vdest+2
    lda.z vaddr+3
    sta.z vera_cpy_bank_vram.vdest+3
    // [805] call vera_cpy_bank_vram 
    // [810] phi from tile_cpy_vram::@4 to vera_cpy_bank_vram [phi:tile_cpy_vram::@4->vera_cpy_bank_vram]
    // [810] phi vera_cpy_bank_vram::num#5 = $800 [phi:tile_cpy_vram::@4->vera_cpy_bank_vram#0] -- vduz1=vduc1 
    lda #<$800
    sta.z vera_cpy_bank_vram.num
    lda #>$800
    sta.z vera_cpy_bank_vram.num+1
    lda #<$800>>$10
    sta.z vera_cpy_bank_vram.num+2
    lda #>$800>>$10
    sta.z vera_cpy_bank_vram.num+3
    // [810] phi vera_cpy_bank_vram::bsrc#3 = vera_cpy_bank_vram::bsrc#1 [phi:tile_cpy_vram::@4->vera_cpy_bank_vram#1] -- register_copy 
    // [810] phi vera_cpy_bank_vram::vdest#3 = vera_cpy_bank_vram::vdest#1 [phi:tile_cpy_vram::@4->vera_cpy_bank_vram#2] -- register_copy 
    jsr vera_cpy_bank_vram
    // tile_cpy_vram::@5
    // Tile->VRAM_Addresses[s] = vaddr
    // [806] tile_cpy_vram::$5 = tile_cpy_vram::s#2 << 2 -- vbuz1=vbuz2_rol_2 
    lda.z s
    asl
    asl
    sta.z __5
    // [807] tile_cpy_vram::$7 = (dword*)tile_cpy_vram::Tile#3 + OFFSET_STRUCT_TILE_VRAM_ADDRESSES -- pduz1=pduz2_plus_vbuc1 
    lda #OFFSET_STRUCT_TILE_VRAM_ADDRESSES
    clc
    adc.z Tile
    sta.z __7
    lda #0
    adc.z Tile+1
    sta.z __7+1
    // [808] tile_cpy_vram::$7[tile_cpy_vram::$5] = tile_cpy_vram::vaddr#0 -- pduz1_derefidx_vbuz2=vduz3 
    ldy.z __5
    lda.z vaddr
    sta (__7),y
    iny
    lda.z vaddr+1
    sta (__7),y
    iny
    lda.z vaddr+2
    sta (__7),y
    iny
    lda.z vaddr+3
    sta (__7),y
    // for(byte s=0;s<num;s++)
    // [809] tile_cpy_vram::s#1 = ++ tile_cpy_vram::s#2 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [791] phi from tile_cpy_vram::@5 to tile_cpy_vram::@1 [phi:tile_cpy_vram::@5->tile_cpy_vram::@1]
    // [791] phi tile_cpy_vram::s#2 = tile_cpy_vram::s#1 [phi:tile_cpy_vram::@5->tile_cpy_vram::@1#0] -- register_copy 
    jmp __b1
}
  // vera_cpy_bank_vram
// Copy block of banked internal memory (256 banks at A000-BFFF) to VERA VRAM.
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vdest: absolute address in VERA VRAM
// - bsrc: absolute address in the banked RAM of the CX16
// - num: dword of the number of bytes to copy
// Note: This function can switch RAM bank during copying to copy data from multiple RAM banks.
// vera_cpy_bank_vram(dword zp($3c) bsrc, dword zp($ca) vdest, dword zp($22) num)
vera_cpy_bank_vram: {
    .label __0 = $7d
    .label __1 = $b7
    .label __2 = $75
    .label __3 = $b8
    .label __4 = $6f
    .label __5 = $b9
    .label __6 = $af
    .label __7 = $af
    .label __8 = $7f
    .label __9 = $75
    .label __10 = $a9
    .label __11 = $75
    .label __12 = $75
    .label __13 = $af
    .label __14 = $af
    .label __15 = $aa
    .label __16 = $75
    .label __17 = $c3
    .label __24 = $75
    .label __25 = $b1
    .label bank = $ba
    // select the bank
    .label addr = $c3
    .label i = $6b
    .label bsrc = $3c
    .label vdest = $ca
    .label num = $22
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [811] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <vdest
    // [812] vera_cpy_bank_vram::$0 = < vera_cpy_bank_vram::vdest#3 -- vwuz1=_lo_vduz2 
    lda.z vdest
    sta.z __0
    lda.z vdest+1
    sta.z __0+1
    // <(<vdest)
    // [813] vera_cpy_bank_vram::$1 = < vera_cpy_bank_vram::$0 -- vbuz1=_lo_vwuz2 
    lda.z __0
    sta.z __1
    // *VERA_ADDRX_L = <(<vdest)
    // [814] *VERA_ADDRX_L = vera_cpy_bank_vram::$1 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // <vdest
    // [815] vera_cpy_bank_vram::$2 = < vera_cpy_bank_vram::vdest#3 -- vwuz1=_lo_vduz2 
    lda.z vdest
    sta.z __2
    lda.z vdest+1
    sta.z __2+1
    // >(<vdest)
    // [816] vera_cpy_bank_vram::$3 = > vera_cpy_bank_vram::$2 -- vbuz1=_hi_vwuz2 
    sta.z __3
    // *VERA_ADDRX_M = >(<vdest)
    // [817] *VERA_ADDRX_M = vera_cpy_bank_vram::$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // >vdest
    // [818] vera_cpy_bank_vram::$4 = > vera_cpy_bank_vram::vdest#3 -- vwuz1=_hi_vduz2 
    lda.z vdest+2
    sta.z __4
    lda.z vdest+3
    sta.z __4+1
    // <(>vdest)
    // [819] vera_cpy_bank_vram::$5 = < vera_cpy_bank_vram::$4 -- vbuz1=_lo_vwuz2 
    lda.z __4
    sta.z __5
    // *VERA_ADDRX_H = <(>vdest)
    // [820] *VERA_ADDRX_H = vera_cpy_bank_vram::$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // *VERA_ADDRX_H |= VERA_INC_1
    // [821] *VERA_ADDRX_H = *VERA_ADDRX_H | VERA_INC_1 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora VERA_ADDRX_H
    sta VERA_ADDRX_H
    // >bsrc
    // [822] vera_cpy_bank_vram::$6 = > vera_cpy_bank_vram::bsrc#3 -- vwuz1=_hi_vduz2 
    lda.z bsrc+2
    sta.z __6
    lda.z bsrc+3
    sta.z __6+1
    // (>bsrc)<<8
    // [823] vera_cpy_bank_vram::$7 = vera_cpy_bank_vram::$6 << 8 -- vwuz1=vwuz1_rol_8 
    lda.z __7
    sta.z __7+1
    lda #0
    sta.z __7
    // <(>bsrc)<<8
    // [824] vera_cpy_bank_vram::$8 = < vera_cpy_bank_vram::$7 -- vbuz1=_lo_vwuz2 
    sta.z __8
    // <bsrc
    // [825] vera_cpy_bank_vram::$9 = < vera_cpy_bank_vram::bsrc#3 -- vwuz1=_lo_vduz2 
    lda.z bsrc
    sta.z __9
    lda.z bsrc+1
    sta.z __9+1
    // >(<bsrc)
    // [826] vera_cpy_bank_vram::$10 = > vera_cpy_bank_vram::$9 -- vbuz1=_hi_vwuz2 
    sta.z __10
    // ((word)<(>bsrc)<<8)|>(<bsrc)
    // [827] vera_cpy_bank_vram::$24 = (word)vera_cpy_bank_vram::$8 -- vwuz1=_word_vbuz2 
    lda.z __8
    sta.z __24
    lda #0
    sta.z __24+1
    // [828] vera_cpy_bank_vram::$11 = vera_cpy_bank_vram::$24 | vera_cpy_bank_vram::$10 -- vwuz1=vwuz1_bor_vbuz2 
    lda.z __10
    ora.z __11
    sta.z __11
    // (((word)<(>bsrc)<<8)|>(<bsrc))>>5
    // [829] vera_cpy_bank_vram::$12 = vera_cpy_bank_vram::$11 >> 5 -- vwuz1=vwuz1_ror_5 
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
    // [830] vera_cpy_bank_vram::$13 = > vera_cpy_bank_vram::bsrc#3 -- vwuz1=_hi_vduz2 
    lda.z bsrc+2
    sta.z __13
    lda.z bsrc+3
    sta.z __13+1
    // (>bsrc)<<3
    // [831] vera_cpy_bank_vram::$14 = vera_cpy_bank_vram::$13 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z __14
    rol.z __14+1
    asl.z __14
    rol.z __14+1
    asl.z __14
    rol.z __14+1
    // <(>bsrc)<<3
    // [832] vera_cpy_bank_vram::$15 = < vera_cpy_bank_vram::$14 -- vbuz1=_lo_vwuz2 
    lda.z __14
    sta.z __15
    // ((((word)<(>bsrc)<<8)|>(<bsrc))>>5)+((word)<(>bsrc)<<3)
    // [833] vera_cpy_bank_vram::$25 = (word)vera_cpy_bank_vram::$15 -- vwuz1=_word_vbuz2 
    sta.z __25
    lda #0
    sta.z __25+1
    // [834] vera_cpy_bank_vram::$16 = vera_cpy_bank_vram::$12 + vera_cpy_bank_vram::$25 -- vwuz1=vwuz1_plus_vwuz2 
    lda.z __16
    clc
    adc.z __25
    sta.z __16
    lda.z __16+1
    adc.z __25+1
    sta.z __16+1
    // bank = (byte)(((((word)<(>bsrc)<<8)|>(<bsrc))>>5)+((word)<(>bsrc)<<3))
    // [835] vera_cpy_bank_vram::bank#0 = (byte)vera_cpy_bank_vram::$16 -- vbuz1=_byte_vwuz2 
    lda.z __16
    sta.z bank
    // <bsrc
    // [836] vera_cpy_bank_vram::$17 = < vera_cpy_bank_vram::bsrc#3 -- vwuz1=_lo_vduz2 
    lda.z bsrc
    sta.z __17
    lda.z bsrc+1
    sta.z __17+1
    // (<bsrc)&0x1FFF
    // [837] vera_cpy_bank_vram::addr#0 = vera_cpy_bank_vram::$17 & $1fff -- vwuz1=vwuz1_band_vwuc1 
    lda.z addr
    and #<$1fff
    sta.z addr
    lda.z addr+1
    and #>$1fff
    sta.z addr+1
    // addr += 0xA000
    // [838] vera_cpy_bank_vram::addr#1 = (byte*)vera_cpy_bank_vram::addr#0 + $a000 -- pbuz1=pbuz1_plus_vwuc1 
    // strip off the top 3 bits, which are representing the bank of the word!
    clc
    lda.z addr
    adc #<$a000
    sta.z addr
    lda.z addr+1
    adc #>$a000
    sta.z addr+1
    // cx16_ram_bank(bank)
    // [839] cx16_ram_bank::bank#3 = vera_cpy_bank_vram::bank#0 -- vbuz1=vbuz2 
    lda.z bank
    sta.z cx16_ram_bank.bank
    // [840] call cx16_ram_bank 
    // [1069] phi from vera_cpy_bank_vram to cx16_ram_bank [phi:vera_cpy_bank_vram->cx16_ram_bank]
    // [1069] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#3 [phi:vera_cpy_bank_vram->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [841] phi from vera_cpy_bank_vram to vera_cpy_bank_vram::@1 [phi:vera_cpy_bank_vram->vera_cpy_bank_vram::@1]
    // [841] phi vera_cpy_bank_vram::bank#2 = vera_cpy_bank_vram::bank#0 [phi:vera_cpy_bank_vram->vera_cpy_bank_vram::@1#0] -- register_copy 
    // [841] phi vera_cpy_bank_vram::addr#4 = vera_cpy_bank_vram::addr#1 [phi:vera_cpy_bank_vram->vera_cpy_bank_vram::@1#1] -- register_copy 
    // [841] phi vera_cpy_bank_vram::i#2 = 0 [phi:vera_cpy_bank_vram->vera_cpy_bank_vram::@1#2] -- vduz1=vduc1 
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
    // [842] if(vera_cpy_bank_vram::i#2<vera_cpy_bank_vram::num#5) goto vera_cpy_bank_vram::@2 -- vduz1_lt_vduz2_then_la1 
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
    // [843] return 
    rts
    // vera_cpy_bank_vram::@2
  __b2:
    // if(addr == 0xC000)
    // [844] if(vera_cpy_bank_vram::addr#4!=$c000) goto vera_cpy_bank_vram::@3 -- pbuz1_neq_vwuc1_then_la1 
    lda.z addr+1
    cmp #>$c000
    bne __b3
    lda.z addr
    cmp #<$c000
    bne __b3
    // vera_cpy_bank_vram::@4
    // bank++;
    // [845] vera_cpy_bank_vram::bank#1 = ++ vera_cpy_bank_vram::bank#2 -- vbuz1=_inc_vbuz1 
    inc.z bank
    // cx16_ram_bank(bank)
    // [846] cx16_ram_bank::bank#4 = vera_cpy_bank_vram::bank#1 -- vbuz1=vbuz2 
    lda.z bank
    sta.z cx16_ram_bank.bank
    // [847] call cx16_ram_bank 
    // [1069] phi from vera_cpy_bank_vram::@4 to cx16_ram_bank [phi:vera_cpy_bank_vram::@4->cx16_ram_bank]
    // [1069] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#4 [phi:vera_cpy_bank_vram::@4->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [848] phi from vera_cpy_bank_vram::@4 to vera_cpy_bank_vram::@3 [phi:vera_cpy_bank_vram::@4->vera_cpy_bank_vram::@3]
    // [848] phi vera_cpy_bank_vram::bank#5 = vera_cpy_bank_vram::bank#1 [phi:vera_cpy_bank_vram::@4->vera_cpy_bank_vram::@3#0] -- register_copy 
    // [848] phi vera_cpy_bank_vram::addr#5 = (byte*) 40960 [phi:vera_cpy_bank_vram::@4->vera_cpy_bank_vram::@3#1] -- pbuz1=pbuc1 
    lda #<$a000
    sta.z addr
    lda #>$a000
    sta.z addr+1
    // [848] phi from vera_cpy_bank_vram::@2 to vera_cpy_bank_vram::@3 [phi:vera_cpy_bank_vram::@2->vera_cpy_bank_vram::@3]
    // [848] phi vera_cpy_bank_vram::bank#5 = vera_cpy_bank_vram::bank#2 [phi:vera_cpy_bank_vram::@2->vera_cpy_bank_vram::@3#0] -- register_copy 
    // [848] phi vera_cpy_bank_vram::addr#5 = vera_cpy_bank_vram::addr#4 [phi:vera_cpy_bank_vram::@2->vera_cpy_bank_vram::@3#1] -- register_copy 
    // vera_cpy_bank_vram::@3
  __b3:
    // *VERA_DATA0 = *addr
    // [849] *VERA_DATA0 = *vera_cpy_bank_vram::addr#5 -- _deref_pbuc1=_deref_pbuz1 
    ldy #0
    lda (addr),y
    sta VERA_DATA0
    // addr++;
    // [850] vera_cpy_bank_vram::addr#2 = ++ vera_cpy_bank_vram::addr#5 -- pbuz1=_inc_pbuz1 
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    // for(dword i=0; i<num; i++)
    // [851] vera_cpy_bank_vram::i#1 = ++ vera_cpy_bank_vram::i#2 -- vduz1=_inc_vduz1 
    inc.z i
    bne !+
    inc.z i+1
    bne !+
    inc.z i+2
    bne !+
    inc.z i+3
  !:
    // [841] phi from vera_cpy_bank_vram::@3 to vera_cpy_bank_vram::@1 [phi:vera_cpy_bank_vram::@3->vera_cpy_bank_vram::@1]
    // [841] phi vera_cpy_bank_vram::bank#2 = vera_cpy_bank_vram::bank#5 [phi:vera_cpy_bank_vram::@3->vera_cpy_bank_vram::@1#0] -- register_copy 
    // [841] phi vera_cpy_bank_vram::addr#4 = vera_cpy_bank_vram::addr#2 [phi:vera_cpy_bank_vram::@3->vera_cpy_bank_vram::@1#1] -- register_copy 
    // [841] phi vera_cpy_bank_vram::i#2 = vera_cpy_bank_vram::i#1 [phi:vera_cpy_bank_vram::@3->vera_cpy_bank_vram::@1#2] -- register_copy 
    jmp __b1
}
  // tile_background
tile_background: {
    .label __3 = $7b
    .label __5 = $b9
    .label rnd = $b9
    .label c = $b6
    .label r = $b4
    // [853] phi from tile_background to tile_background::@1 [phi:tile_background->tile_background::@1]
    // [853] phi rem16u#19 = 0 [phi:tile_background->tile_background::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z rem16u
    sta.z rem16u+1
    // [853] phi rand_state#18 = 1 [phi:tile_background->tile_background::@1#1] -- vwuz1=vwuc1 
    lda #<1
    sta.z rand_state
    lda #>1
    sta.z rand_state+1
    // [853] phi tile_background::r#2 = 0 [phi:tile_background->tile_background::@1#2] -- vbuz1=vbuc1 
    sta.z r
    // tile_background::@1
  __b1:
    // for(byte r=0;r<6;r+=1)
    // [854] if(tile_background::r#2<6) goto tile_background::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z r
    cmp #6
    bcc __b4
    // tile_background::@return
    // }
    // [855] return 
    rts
    // [856] phi from tile_background::@1 to tile_background::@2 [phi:tile_background::@1->tile_background::@2]
  __b4:
    // [856] phi rem16u#27 = rem16u#19 [phi:tile_background::@1->tile_background::@2#0] -- register_copy 
    // [856] phi rand_state#24 = rand_state#18 [phi:tile_background::@1->tile_background::@2#1] -- register_copy 
    // [856] phi tile_background::c#2 = 0 [phi:tile_background::@1->tile_background::@2#2] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // tile_background::@2
  __b2:
    // for(byte c=0;c<5;c+=1)
    // [857] if(tile_background::c#2<5) goto tile_background::@3 -- vbuz1_lt_vbuc1_then_la1 
    lda.z c
    cmp #5
    bcc __b3
    // tile_background::@4
    // r+=1
    // [858] tile_background::r#1 = tile_background::r#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z r
    // [853] phi from tile_background::@4 to tile_background::@1 [phi:tile_background::@4->tile_background::@1]
    // [853] phi rem16u#19 = rem16u#27 [phi:tile_background::@4->tile_background::@1#0] -- register_copy 
    // [853] phi rand_state#18 = rand_state#24 [phi:tile_background::@4->tile_background::@1#1] -- register_copy 
    // [853] phi tile_background::r#2 = tile_background::r#1 [phi:tile_background::@4->tile_background::@1#2] -- register_copy 
    jmp __b1
    // [859] phi from tile_background::@2 to tile_background::@3 [phi:tile_background::@2->tile_background::@3]
    // tile_background::@3
  __b3:
    // rand()
    // [860] call rand 
    // [284] phi from tile_background::@3 to rand [phi:tile_background::@3->rand]
    // [284] phi rand_state#13 = rand_state#24 [phi:tile_background::@3->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [861] rand::return#3 = rand::return#0
    // tile_background::@5
    // modr16u(rand(),3,0)
    // [862] modr16u::dividend#1 = rand::return#3
    // [863] call modr16u 
    // [293] phi from tile_background::@5 to modr16u [phi:tile_background::@5->modr16u]
    // [293] phi modr16u::dividend#2 = modr16u::dividend#1 [phi:tile_background::@5->modr16u#0] -- register_copy 
    jsr modr16u
    // modr16u(rand(),3,0)
    // [864] modr16u::return#3 = modr16u::return#0
    // tile_background::@6
    // [865] tile_background::$3 = modr16u::return#3 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z __3
    lda.z modr16u.return+1
    sta.z __3+1
    // rnd = (byte)modr16u(rand(),3,0)
    // [866] tile_background::rnd#0 = (byte)tile_background::$3 -- vbuz1=_byte_vwuz2 
    lda.z __3
    sta.z rnd
    // vera_tile_element( 0, c, r, 3, TileDB[rnd])
    // [867] tile_background::$5 = tile_background::rnd#0 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __5
    // [868] vera_tile_element::x#2 = tile_background::c#2 -- vbuz1=vbuz2 
    lda.z c
    sta.z vera_tile_element.x
    // [869] vera_tile_element::y#2 = tile_background::r#2 -- vbuz1=vbuz2 
    lda.z r
    sta.z vera_tile_element.y
    // [870] vera_tile_element::Tile#1 = TileDB[tile_background::$5] -- pssz1=qssc1_derefidx_vbuz2 
    ldy.z __5
    lda TileDB,y
    sta.z vera_tile_element.Tile
    lda TileDB+1,y
    sta.z vera_tile_element.Tile+1
    // [871] call vera_tile_element 
    // [298] phi from tile_background::@6 to vera_tile_element [phi:tile_background::@6->vera_tile_element]
    // [298] phi vera_tile_element::y#3 = vera_tile_element::y#2 [phi:tile_background::@6->vera_tile_element#0] -- register_copy 
    // [298] phi vera_tile_element::x#3 = vera_tile_element::x#2 [phi:tile_background::@6->vera_tile_element#1] -- register_copy 
    // [298] phi vera_tile_element::Tile#2 = vera_tile_element::Tile#1 [phi:tile_background::@6->vera_tile_element#2] -- register_copy 
    jsr vera_tile_element
    // tile_background::@7
    // c+=1
    // [872] tile_background::c#1 = tile_background::c#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z c
    // [856] phi from tile_background::@7 to tile_background::@2 [phi:tile_background::@7->tile_background::@2]
    // [856] phi rem16u#27 = divr16u::rem#10 [phi:tile_background::@7->tile_background::@2#0] -- register_copy 
    // [856] phi rand_state#24 = rand_state#14 [phi:tile_background::@7->tile_background::@2#1] -- register_copy 
    // [856] phi tile_background::c#2 = tile_background::c#1 [phi:tile_background::@7->tile_background::@2#2] -- register_copy 
    jmp __b2
}
  // create_sprite
// create_sprite(byte zp($20) sprite)
create_sprite: {
    .label __4 = $f
    .label __5 = $b1
    .label __7 = $c7
    .label __8 = $c3
    .label __17 = $20
    .label __18 = $c7
    .label __22 = $6f
    .label __33 = $b1
    .label __34 = $c3
    .label vera_sprite_bpp1_vera_sprite_4bpp1___3 = $f
    .label vera_sprite_bpp1_vera_sprite_4bpp1___4 = $6f
    .label vera_sprite_bpp1_vera_sprite_4bpp1___5 = $f
    .label vera_sprite_bpp1_vera_sprite_4bpp1___6 = $f
    .label vera_sprite_bpp1_vera_sprite_4bpp1___7 = $6f
    .label vera_sprite_bpp1_vera_sprite_8bpp1___3 = $aa
    .label vera_sprite_bpp1_vera_sprite_8bpp1___4 = $75
    .label vera_sprite_bpp1_vera_sprite_8bpp1___5 = $c7
    .label vera_sprite_bpp1_vera_sprite_8bpp1___6 = $c7
    .label vera_sprite_bpp1_vera_sprite_8bpp1___7 = $75
    .label vera_sprite_address1___0 = $af
    .label vera_sprite_address1___2 = $c7
    .label vera_sprite_address1___3 = $c7
    .label vera_sprite_address1___4 = $75
    .label vera_sprite_address1___5 = $75
    .label vera_sprite_address1___6 = $b9
    .label vera_sprite_address1___7 = $75
    .label vera_sprite_address1___8 = $40
    .label vera_sprite_address1___9 = $40
    .label vera_sprite_address1___10 = $af
    .label vera_sprite_address1___11 = $a9
    .label vera_sprite_address1___12 = $a9
    .label vera_sprite_address1___13 = $40
    .label vera_sprite_address1___14 = $af
    .label vera_sprite_xy1___3 = $c7
    .label vera_sprite_xy1___4 = $c5
    .label vera_sprite_xy1___5 = $c7
    .label vera_sprite_xy1___6 = $b9
    .label vera_sprite_xy1___7 = $b9
    .label vera_sprite_xy1___8 = $f
    .label vera_sprite_xy1___9 = $f
    .label vera_sprite_xy1___10 = $c5
    .label vera_sprite_height1_vera_sprite_height_81___3 = $ba
    .label vera_sprite_height1_vera_sprite_height_81___4 = $6f
    .label vera_sprite_height1_vera_sprite_height_81___5 = $f
    .label vera_sprite_height1_vera_sprite_height_81___7 = $f
    .label vera_sprite_height1_vera_sprite_height_81___8 = $6f
    .label vera_sprite_height1_vera_sprite_height_161___3 = $b8
    .label vera_sprite_height1_vera_sprite_height_161___4 = $6f
    .label vera_sprite_height1_vera_sprite_height_161___5 = $b9
    .label vera_sprite_height1_vera_sprite_height_161___6 = $b9
    .label vera_sprite_height1_vera_sprite_height_161___7 = $b9
    .label vera_sprite_height1_vera_sprite_height_161___8 = $6f
    .label vera_sprite_height1_vera_sprite_height_321___3 = $b5
    .label vera_sprite_height1_vera_sprite_height_321___4 = $6f
    .label vera_sprite_height1_vera_sprite_height_321___5 = $b6
    .label vera_sprite_height1_vera_sprite_height_321___6 = $b7
    .label vera_sprite_height1_vera_sprite_height_321___7 = $b7
    .label vera_sprite_height1_vera_sprite_height_321___8 = $6f
    .label vera_sprite_height1_vera_sprite_height_641___3 = $c7
    .label vera_sprite_height1_vera_sprite_height_641___4 = $75
    .label vera_sprite_height1_vera_sprite_height_641___5 = $d2
    .label vera_sprite_height1_vera_sprite_height_641___6 = $b9
    .label vera_sprite_height1_vera_sprite_height_641___7 = $b9
    .label vera_sprite_height1_vera_sprite_height_641___8 = $75
    .label vera_sprite_palette_offset1___3 = $ba
    .label vera_sprite_palette_offset1___4 = $c8
    .label vera_sprite_palette_offset1___5 = $b3
    .label vera_sprite_palette_offset1___6 = $b4
    .label vera_sprite_palette_offset1___7 = $b9
    .label vera_sprite_palette_offset1___8 = $c8
    .label Sprite = $7d
    .label Offset = $7f
    .label vera_sprite_bpp1_bpp = $a9
    .label vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset = $6f
    .label vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset = $75
    .label vera_sprite_address1_address = $ab
    .label vera_sprite_address1_sprite_offset = $af
    .label vera_sprite_xy1_x = $b1
    .label vera_sprite_xy1_y = $c3
    .label vera_sprite_xy1_sprite_offset = $c5
    .label vera_sprite_height1_height = $ba
    .label vera_sprite_height1_vera_sprite_height_81_sprite_offset = $6f
    .label vera_sprite_height1_vera_sprite_height_161_sprite_offset = $6f
    .label vera_sprite_height1_vera_sprite_height_321_sprite_offset = $6f
    .label vera_sprite_height1_vera_sprite_height_641_sprite_offset = $75
    .label vera_sprite_palette_offset1_palette_offset = $b9
    .label vera_sprite_palette_offset1_sprite_offset = $c8
    .label s = $21
    .label sprite = $20
    // Sprite = SpriteDB[sprite]
    // [874] create_sprite::$17 = create_sprite::sprite#2 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __17
    // [875] create_sprite::Sprite#0 = SpriteDB[create_sprite::$17] -- pssz1=qssc1_derefidx_vbuz2 
    // Copy sprite palette to VRAM
    // Copy 8* sprite attributes to VRAM
    ldy.z __17
    lda SpriteDB,y
    sta.z Sprite
    lda SpriteDB+1,y
    sta.z Sprite+1
    // [876] phi from create_sprite to create_sprite::@1 [phi:create_sprite->create_sprite::@1]
    // [876] phi create_sprite::s#10 = 0 [phi:create_sprite->create_sprite::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z s
    // create_sprite::@1
  __b1:
    // for(byte s=0;s<Sprite->Count;s++)
    // [877] if(create_sprite::s#10<((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_COUNT]) goto create_sprite::@2 -- vbuz1_lt_pbuz2_derefidx_vbuc1_then_la1 
    ldy #OFFSET_STRUCT_SPRITE_COUNT
    lda (Sprite),y
    cmp.z s
    beq !+
    bcs __b2
  !:
    // create_sprite::@return
    // }
    // [878] return 
    rts
    // create_sprite::@2
  __b2:
    // Sprite->Offset+s
    // [879] create_sprite::Offset#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_OFFSET] + create_sprite::s#10 -- vbuz1=pbuz2_derefidx_vbuc1_plus_vbuz3 
    lda.z s
    ldy #OFFSET_STRUCT_SPRITE_OFFSET
    clc
    adc (Sprite),y
    sta.z Offset
    // vera_sprite_bpp(Offset, Sprite->BPP)
    // [880] create_sprite::vera_sprite_bpp1_bpp#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_BPP] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_BPP
    lda (Sprite),y
    sta.z vera_sprite_bpp1_bpp
    // create_sprite::vera_sprite_bpp1
    // if(bpp==4)
    // [881] if(create_sprite::vera_sprite_bpp1_bpp#0==4) goto create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1 -- vbuz1_eq_vbuc1_then_la1 
    lda #4
    cmp.z vera_sprite_bpp1_bpp
    bne !vera_sprite_bpp1_vera_sprite_4bpp1+
    jmp vera_sprite_bpp1_vera_sprite_4bpp1
  !vera_sprite_bpp1_vera_sprite_4bpp1:
    // create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1
    // (word)sprite << 3
    // [882] create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$7 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_bpp1_vera_sprite_8bpp1___7
    lda #0
    sta.z vera_sprite_bpp1_vera_sprite_8bpp1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [883] create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset#0 = create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset
    rol.z vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset+1
    asl.z vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset
    rol.z vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset+1
    asl.z vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset
    rol.z vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [884] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+1
    // [885] create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$4 = create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_sprite_offset#0 + <VERA_SPRITE_ATTR+1 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_bpp1_vera_sprite_8bpp1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+1
    sta.z vera_sprite_bpp1_vera_sprite_8bpp1___4
    lda.z vera_sprite_bpp1_vera_sprite_8bpp1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+1
    sta.z vera_sprite_bpp1_vera_sprite_8bpp1___4+1
    // <sprite_offset+1
    // [886] create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$3 = < create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_bpp1_vera_sprite_8bpp1___4
    sta.z vera_sprite_bpp1_vera_sprite_8bpp1___3
    // *VERA_ADDRX_L = <sprite_offset+1
    // [887] *VERA_ADDRX_L = create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+1
    // [888] create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$5 = > create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_bpp1_vera_sprite_8bpp1___4+1
    sta.z vera_sprite_bpp1_vera_sprite_8bpp1___5
    // *VERA_ADDRX_M = >sprite_offset+1
    // [889] *VERA_ADDRX_M = create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [890] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 | >VERA_SPRITE_8BPP
    // [891] create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$6 = *VERA_DATA0 | >VERA_SPRITE_8BPP -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #>VERA_SPRITE_8BPP
    ora VERA_DATA0
    sta.z vera_sprite_bpp1_vera_sprite_8bpp1___6
    // *VERA_DATA0 = *VERA_DATA0 | >VERA_SPRITE_8BPP
    // [892] *VERA_DATA0 = create_sprite::vera_sprite_bpp1_vera_sprite_8bpp1_$6 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // create_sprite::@3
  __b3:
    // vera_sprite_address(Offset, Sprite->VRAM_Addresses[s])
    // [893] create_sprite::$18 = create_sprite::s#10 << 2 -- vbuz1=vbuz2_rol_2 
    lda.z s
    asl
    asl
    sta.z __18
    // [894] create_sprite::$22 = (dword*)create_sprite::Sprite#0 + OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES -- pduz1=pduz2_plus_vbuc1 
    lda #OFFSET_STRUCT_SPRITE_VRAM_ADDRESSES
    clc
    adc.z Sprite
    sta.z __22
    lda #0
    adc.z Sprite+1
    sta.z __22+1
    // [895] create_sprite::vera_sprite_address1_address#0 = create_sprite::$22[create_sprite::$18] -- vduz1=pduz2_derefidx_vbuz3 
    ldy.z __18
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
    // [896] create_sprite::vera_sprite_address1_$14 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_address1___14
    lda #0
    sta.z vera_sprite_address1___14+1
    // [897] create_sprite::vera_sprite_address1_$0 = create_sprite::vera_sprite_address1_$14 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [898] create_sprite::vera_sprite_address1_sprite_offset#0 = <VERA_SPRITE_ATTR + create_sprite::vera_sprite_address1_$0 -- vwuz1=vwuc1_plus_vwuz1 
    clc
    lda.z vera_sprite_address1_sprite_offset
    adc #<VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset
    lda.z vera_sprite_address1_sprite_offset+1
    adc #>VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [899] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <sprite_offset
    // [900] create_sprite::vera_sprite_address1_$2 = < create_sprite::vera_sprite_address1_sprite_offset#0 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_address1_sprite_offset
    sta.z vera_sprite_address1___2
    // *VERA_ADDRX_L = <sprite_offset
    // [901] *VERA_ADDRX_L = create_sprite::vera_sprite_address1_$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset
    // [902] create_sprite::vera_sprite_address1_$3 = > create_sprite::vera_sprite_address1_sprite_offset#0 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_address1_sprite_offset+1
    sta.z vera_sprite_address1___3
    // *VERA_ADDRX_M = >sprite_offset
    // [903] *VERA_ADDRX_M = create_sprite::vera_sprite_address1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [904] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <address
    // [905] create_sprite::vera_sprite_address1_$4 = < create_sprite::vera_sprite_address1_address#0 -- vwuz1=_lo_vduz2 
    lda.z vera_sprite_address1_address
    sta.z vera_sprite_address1___4
    lda.z vera_sprite_address1_address+1
    sta.z vera_sprite_address1___4+1
    // (<address)>>5
    // [906] create_sprite::vera_sprite_address1_$5 = create_sprite::vera_sprite_address1_$4 >> 5 -- vwuz1=vwuz1_ror_5 
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
    // [907] create_sprite::vera_sprite_address1_$6 = < create_sprite::vera_sprite_address1_$5 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_address1___5
    sta.z vera_sprite_address1___6
    // *VERA_DATA0 = <((<address)>>5)
    // [908] *VERA_DATA0 = create_sprite::vera_sprite_address1_$6 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // <address
    // [909] create_sprite::vera_sprite_address1_$7 = < create_sprite::vera_sprite_address1_address#0 -- vwuz1=_lo_vduz2 
    lda.z vera_sprite_address1_address
    sta.z vera_sprite_address1___7
    lda.z vera_sprite_address1_address+1
    sta.z vera_sprite_address1___7+1
    // >(<address)
    // [910] create_sprite::vera_sprite_address1_$8 = > create_sprite::vera_sprite_address1_$7 -- vbuz1=_hi_vwuz2 
    sta.z vera_sprite_address1___8
    // (>(<address))>>5
    // [911] create_sprite::vera_sprite_address1_$9 = create_sprite::vera_sprite_address1_$8 >> 5 -- vbuz1=vbuz1_ror_5 
    lda.z vera_sprite_address1___9
    lsr
    lsr
    lsr
    lsr
    lsr
    sta.z vera_sprite_address1___9
    // >address
    // [912] create_sprite::vera_sprite_address1_$10 = > create_sprite::vera_sprite_address1_address#0 -- vwuz1=_hi_vduz2 
    lda.z vera_sprite_address1_address+2
    sta.z vera_sprite_address1___10
    lda.z vera_sprite_address1_address+3
    sta.z vera_sprite_address1___10+1
    // <(>address)
    // [913] create_sprite::vera_sprite_address1_$11 = < create_sprite::vera_sprite_address1_$10 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_address1___10
    sta.z vera_sprite_address1___11
    // (<(>address))<<3
    // [914] create_sprite::vera_sprite_address1_$12 = create_sprite::vera_sprite_address1_$11 << 3 -- vbuz1=vbuz1_rol_3 
    lda.z vera_sprite_address1___12
    asl
    asl
    asl
    sta.z vera_sprite_address1___12
    // ((>(<address))>>5)|((<(>address))<<3)
    // [915] create_sprite::vera_sprite_address1_$13 = create_sprite::vera_sprite_address1_$9 | create_sprite::vera_sprite_address1_$12 -- vbuz1=vbuz1_bor_vbuz2 
    lda.z vera_sprite_address1___13
    ora.z vera_sprite_address1___12
    sta.z vera_sprite_address1___13
    // *VERA_DATA0 = ((>(<address))>>5)|((<(>address))<<3)
    // [916] *VERA_DATA0 = create_sprite::vera_sprite_address1_$13 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // create_sprite::@4
    // s&03
    // [917] create_sprite::$4 = create_sprite::s#10 & 3 -- vbuz1=vbuz2_band_vbuc1 
    lda #3
    and.z s
    sta.z __4
    // (word)(s&03)<<6
    // [918] create_sprite::$33 = (word)create_sprite::$4 -- vwuz1=_word_vbuz2 
    sta.z __33
    lda #0
    sta.z __33+1
    // [919] create_sprite::$5 = create_sprite::$33 << 6 -- vwuz1=vwuz1_rol_6 
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
    // [920] create_sprite::vera_sprite_xy1_x#0 = $28 + create_sprite::$5 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$28
    clc
    adc.z vera_sprite_xy1_x
    sta.z vera_sprite_xy1_x
    bcc !+
    inc.z vera_sprite_xy1_x+1
  !:
    // s>>2
    // [921] create_sprite::$7 = create_sprite::s#10 >> 2 -- vbuz1=vbuz2_ror_2 
    lda.z s
    lsr
    lsr
    sta.z __7
    // (word)(s>>2)<<6
    // [922] create_sprite::$34 = (word)create_sprite::$7 -- vwuz1=_word_vbuz2 
    sta.z __34
    lda #0
    sta.z __34+1
    // [923] create_sprite::$8 = create_sprite::$34 << 6 -- vwuz1=vwuz1_rol_6 
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
    // [924] create_sprite::vera_sprite_xy1_y#0 = $64 + create_sprite::$8 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$64
    clc
    adc.z vera_sprite_xy1_y
    sta.z vera_sprite_xy1_y
    bcc !+
    inc.z vera_sprite_xy1_y+1
  !:
    // create_sprite::vera_sprite_xy1
    // (word)sprite << 3
    // [925] create_sprite::vera_sprite_xy1_$10 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_xy1___10
    lda #0
    sta.z vera_sprite_xy1___10+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [926] create_sprite::vera_sprite_xy1_sprite_offset#0 = create_sprite::vera_sprite_xy1_$10 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [927] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+2
    // [928] create_sprite::vera_sprite_xy1_$4 = create_sprite::vera_sprite_xy1_sprite_offset#0 + <VERA_SPRITE_ATTR+2 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_xy1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4
    lda.z vera_sprite_xy1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4+1
    // <sprite_offset+2
    // [929] create_sprite::vera_sprite_xy1_$3 = < create_sprite::vera_sprite_xy1_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_xy1___4
    sta.z vera_sprite_xy1___3
    // *VERA_ADDRX_L = <sprite_offset+2
    // [930] *VERA_ADDRX_L = create_sprite::vera_sprite_xy1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+2
    // [931] create_sprite::vera_sprite_xy1_$5 = > create_sprite::vera_sprite_xy1_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_xy1___4+1
    sta.z vera_sprite_xy1___5
    // *VERA_ADDRX_M = >sprite_offset+2
    // [932] *VERA_ADDRX_M = create_sprite::vera_sprite_xy1_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [933] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <x
    // [934] create_sprite::vera_sprite_xy1_$6 = < create_sprite::vera_sprite_xy1_x#0 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_xy1_x
    sta.z vera_sprite_xy1___6
    // *VERA_DATA0 = <x
    // [935] *VERA_DATA0 = create_sprite::vera_sprite_xy1_$6 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // >x
    // [936] create_sprite::vera_sprite_xy1_$7 = > create_sprite::vera_sprite_xy1_x#0 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_xy1_x+1
    sta.z vera_sprite_xy1___7
    // *VERA_DATA0 = >x
    // [937] *VERA_DATA0 = create_sprite::vera_sprite_xy1_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // <y
    // [938] create_sprite::vera_sprite_xy1_$8 = < create_sprite::vera_sprite_xy1_y#0 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_xy1_y
    sta.z vera_sprite_xy1___8
    // *VERA_DATA0 = <y
    // [939] *VERA_DATA0 = create_sprite::vera_sprite_xy1_$8 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // >y
    // [940] create_sprite::vera_sprite_xy1_$9 = > create_sprite::vera_sprite_xy1_y#0 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_xy1_y+1
    sta.z vera_sprite_xy1___9
    // *VERA_DATA0 = >y
    // [941] *VERA_DATA0 = create_sprite::vera_sprite_xy1_$9 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // create_sprite::@5
    // vera_sprite_height(Offset, Sprite->Height)
    // [942] create_sprite::vera_sprite_height1_height#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_HEIGHT] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_HEIGHT
    lda (Sprite),y
    sta.z vera_sprite_height1_height
    // create_sprite::vera_sprite_height1
    // case 8:
    //             vera_sprite_height_8(sprite);
    //             break;
    // [943] if(create_sprite::vera_sprite_height1_height#0==8) goto create_sprite::vera_sprite_height1_vera_sprite_height_81 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z vera_sprite_height1_height
    bne !vera_sprite_height1_vera_sprite_height_81+
    jmp vera_sprite_height1_vera_sprite_height_81
  !vera_sprite_height1_vera_sprite_height_81:
    // create_sprite::vera_sprite_height1_@1
    // case 16:
    //             vera_sprite_height_16(sprite);
    //             break;
    // [944] if(create_sprite::vera_sprite_height1_height#0==$10) goto create_sprite::vera_sprite_height1_vera_sprite_height_161 -- vbuz1_eq_vbuc1_then_la1 
    lda #$10
    cmp.z vera_sprite_height1_height
    bne !vera_sprite_height1_vera_sprite_height_161+
    jmp vera_sprite_height1_vera_sprite_height_161
  !vera_sprite_height1_vera_sprite_height_161:
    // create_sprite::vera_sprite_height1_@2
    // case 32:
    //             vera_sprite_height_32(sprite);
    //             break;
    // [945] if(create_sprite::vera_sprite_height1_height#0==$20) goto create_sprite::vera_sprite_height1_vera_sprite_height_321 -- vbuz1_eq_vbuc1_then_la1 
    lda #$20
    cmp.z vera_sprite_height1_height
    bne !vera_sprite_height1_vera_sprite_height_321+
    jmp vera_sprite_height1_vera_sprite_height_321
  !vera_sprite_height1_vera_sprite_height_321:
    // create_sprite::vera_sprite_height1_@3
    // case 64:
    //             vera_sprite_height_64(sprite);
    //             break;
    // [946] if(create_sprite::vera_sprite_height1_height#0==$40) goto create_sprite::vera_sprite_height1_vera_sprite_height_641 -- vbuz1_eq_vbuc1_then_la1 
    lda #$40
    cmp.z vera_sprite_height1_height
    beq vera_sprite_height1_vera_sprite_height_641
    jmp __b6
    // create_sprite::vera_sprite_height1_vera_sprite_height_641
  vera_sprite_height1_vera_sprite_height_641:
    // (word)sprite << 3
    // [947] create_sprite::vera_sprite_height1_vera_sprite_height_641_$8 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_height1_vera_sprite_height_641___8
    lda #0
    sta.z vera_sprite_height1_vera_sprite_height_641___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [948] create_sprite::vera_sprite_height1_vera_sprite_height_641_sprite_offset#0 = create_sprite::vera_sprite_height1_vera_sprite_height_641_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_height1_vera_sprite_height_641_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_641_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_641_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_641_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_641_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_641_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [949] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [950] create_sprite::vera_sprite_height1_vera_sprite_height_641_$4 = create_sprite::vera_sprite_height1_vera_sprite_height_641_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_height1_vera_sprite_height_641___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_641___4
    lda.z vera_sprite_height1_vera_sprite_height_641___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_641___4+1
    // <sprite_offset+7
    // [951] create_sprite::vera_sprite_height1_vera_sprite_height_641_$3 = < create_sprite::vera_sprite_height1_vera_sprite_height_641_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_height1_vera_sprite_height_641___4
    sta.z vera_sprite_height1_vera_sprite_height_641___3
    // *VERA_ADDRX_L = <sprite_offset+7
    // [952] *VERA_ADDRX_L = create_sprite::vera_sprite_height1_vera_sprite_height_641_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [953] create_sprite::vera_sprite_height1_vera_sprite_height_641_$5 = > create_sprite::vera_sprite_height1_vera_sprite_height_641_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_height1_vera_sprite_height_641___4+1
    sta.z vera_sprite_height1_vera_sprite_height_641___5
    // *VERA_ADDRX_M = >sprite_offset+7
    // [954] *VERA_ADDRX_M = create_sprite::vera_sprite_height1_vera_sprite_height_641_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [955] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [956] create_sprite::vera_sprite_height1_vera_sprite_height_641_$6 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HEIGHT_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_height1_vera_sprite_height_641___6
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_64
    // [957] create_sprite::vera_sprite_height1_vera_sprite_height_641_$7 = create_sprite::vera_sprite_height1_vera_sprite_height_641_$6 | VERA_SPRITE_HEIGHT_64 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_SPRITE_HEIGHT_64
    ora.z vera_sprite_height1_vera_sprite_height_641___7
    sta.z vera_sprite_height1_vera_sprite_height_641___7
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_64
    // [958] *VERA_DATA0 = create_sprite::vera_sprite_height1_vera_sprite_height_641_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // create_sprite::@6
  __b6:
    // vera_sprite_width(Offset, Sprite->Width)
    // [959] vera_sprite_width::sprite#0 = create_sprite::Offset#0 -- vbuz1=vbuz2 
    lda.z Offset
    sta.z vera_sprite_width.sprite
    // [960] vera_sprite_width::width#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_WIDTH] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_WIDTH
    lda (Sprite),y
    sta.z vera_sprite_width.width
    // [961] call vera_sprite_width 
    jsr vera_sprite_width
    // create_sprite::@8
    // vera_sprite_zdepth(Offset, Sprite->Zdepth)
    // [962] vera_sprite_zdepth::sprite#0 = create_sprite::Offset#0 -- vbuz1=vbuz2 
    lda.z Offset
    sta.z vera_sprite_zdepth.sprite
    // [963] vera_sprite_zdepth::zdepth#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_ZDEPTH] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_ZDEPTH
    lda (Sprite),y
    sta.z vera_sprite_zdepth.zdepth
    // [964] call vera_sprite_zdepth 
    jsr vera_sprite_zdepth
    // create_sprite::@9
    // vera_sprite_hflip(Offset, Sprite->Hflip)
    // [965] vera_sprite_hflip::sprite#0 = create_sprite::Offset#0 -- vbuz1=vbuz2 
    lda.z Offset
    sta.z vera_sprite_hflip.sprite
    // [966] vera_sprite_hflip::hflip#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_HFLIP] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_HFLIP
    lda (Sprite),y
    sta.z vera_sprite_hflip.hflip
    // [967] call vera_sprite_hflip 
    jsr vera_sprite_hflip
    // create_sprite::@10
    // vera_sprite_vflip(Offset, Sprite->Vflip)
    // [968] vera_sprite_vflip::sprite#0 = create_sprite::Offset#0 -- vbuz1=vbuz2 
    lda.z Offset
    sta.z vera_sprite_vflip.sprite
    // [969] vera_sprite_vflip::vflip#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_VFLIP] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_VFLIP
    lda (Sprite),y
    sta.z vera_sprite_vflip.vflip
    // [970] call vera_sprite_vflip 
    jsr vera_sprite_vflip
    // create_sprite::@11
    // vera_sprite_palette_offset(Offset, Sprite->Palette)
    // [971] create_sprite::vera_sprite_palette_offset1_palette_offset#0 = ((byte*)create_sprite::Sprite#0)[OFFSET_STRUCT_SPRITE_PALETTE] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_SPRITE_PALETTE
    lda (Sprite),y
    sta.z vera_sprite_palette_offset1_palette_offset
    // create_sprite::vera_sprite_palette_offset1
    // (word)sprite << 3
    // [972] create_sprite::vera_sprite_palette_offset1_$8 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_palette_offset1___8
    lda #0
    sta.z vera_sprite_palette_offset1___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [973] create_sprite::vera_sprite_palette_offset1_sprite_offset#0 = create_sprite::vera_sprite_palette_offset1_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_palette_offset1_sprite_offset
    rol.z vera_sprite_palette_offset1_sprite_offset+1
    asl.z vera_sprite_palette_offset1_sprite_offset
    rol.z vera_sprite_palette_offset1_sprite_offset+1
    asl.z vera_sprite_palette_offset1_sprite_offset
    rol.z vera_sprite_palette_offset1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [974] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [975] create_sprite::vera_sprite_palette_offset1_$4 = create_sprite::vera_sprite_palette_offset1_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_palette_offset1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_palette_offset1___4
    lda.z vera_sprite_palette_offset1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_palette_offset1___4+1
    // <sprite_offset+7
    // [976] create_sprite::vera_sprite_palette_offset1_$3 = < create_sprite::vera_sprite_palette_offset1_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_palette_offset1___4
    sta.z vera_sprite_palette_offset1___3
    // *VERA_ADDRX_L = <sprite_offset+7
    // [977] *VERA_ADDRX_L = create_sprite::vera_sprite_palette_offset1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [978] create_sprite::vera_sprite_palette_offset1_$5 = > create_sprite::vera_sprite_palette_offset1_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_palette_offset1___4+1
    sta.z vera_sprite_palette_offset1___5
    // *VERA_ADDRX_M = >sprite_offset+7
    // [979] *VERA_ADDRX_M = create_sprite::vera_sprite_palette_offset1_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [980] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK
    // [981] create_sprite::vera_sprite_palette_offset1_$6 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_PALETTE_OFFSET_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_palette_offset1___6
    // *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK | palette_offset
    // [982] create_sprite::vera_sprite_palette_offset1_$7 = create_sprite::vera_sprite_palette_offset1_$6 | create_sprite::vera_sprite_palette_offset1_palette_offset#0 -- vbuz1=vbuz2_bor_vbuz1 
    lda.z vera_sprite_palette_offset1___7
    ora.z vera_sprite_palette_offset1___6
    sta.z vera_sprite_palette_offset1___7
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK | palette_offset
    // [983] *VERA_DATA0 = create_sprite::vera_sprite_palette_offset1_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // create_sprite::@7
    // for(byte s=0;s<Sprite->Count;s++)
    // [984] create_sprite::s#1 = ++ create_sprite::s#10 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [876] phi from create_sprite::@7 to create_sprite::@1 [phi:create_sprite::@7->create_sprite::@1]
    // [876] phi create_sprite::s#10 = create_sprite::s#1 [phi:create_sprite::@7->create_sprite::@1#0] -- register_copy 
    jmp __b1
    // create_sprite::vera_sprite_height1_vera_sprite_height_321
  vera_sprite_height1_vera_sprite_height_321:
    // (word)sprite << 3
    // [985] create_sprite::vera_sprite_height1_vera_sprite_height_321_$8 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_height1_vera_sprite_height_321___8
    lda #0
    sta.z vera_sprite_height1_vera_sprite_height_321___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [986] create_sprite::vera_sprite_height1_vera_sprite_height_321_sprite_offset#0 = create_sprite::vera_sprite_height1_vera_sprite_height_321_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_height1_vera_sprite_height_321_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_321_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_321_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_321_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_321_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_321_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [987] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [988] create_sprite::vera_sprite_height1_vera_sprite_height_321_$4 = create_sprite::vera_sprite_height1_vera_sprite_height_321_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_height1_vera_sprite_height_321___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_321___4
    lda.z vera_sprite_height1_vera_sprite_height_321___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_321___4+1
    // <sprite_offset+7
    // [989] create_sprite::vera_sprite_height1_vera_sprite_height_321_$3 = < create_sprite::vera_sprite_height1_vera_sprite_height_321_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_height1_vera_sprite_height_321___4
    sta.z vera_sprite_height1_vera_sprite_height_321___3
    // *VERA_ADDRX_L = <sprite_offset+7
    // [990] *VERA_ADDRX_L = create_sprite::vera_sprite_height1_vera_sprite_height_321_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [991] create_sprite::vera_sprite_height1_vera_sprite_height_321_$5 = > create_sprite::vera_sprite_height1_vera_sprite_height_321_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_height1_vera_sprite_height_321___4+1
    sta.z vera_sprite_height1_vera_sprite_height_321___5
    // *VERA_ADDRX_M = >sprite_offset+7
    // [992] *VERA_ADDRX_M = create_sprite::vera_sprite_height1_vera_sprite_height_321_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [993] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [994] create_sprite::vera_sprite_height1_vera_sprite_height_321_$6 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HEIGHT_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_height1_vera_sprite_height_321___6
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_32
    // [995] create_sprite::vera_sprite_height1_vera_sprite_height_321_$7 = create_sprite::vera_sprite_height1_vera_sprite_height_321_$6 | VERA_SPRITE_HEIGHT_32 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_SPRITE_HEIGHT_32
    ora.z vera_sprite_height1_vera_sprite_height_321___7
    sta.z vera_sprite_height1_vera_sprite_height_321___7
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_32
    // [996] *VERA_DATA0 = create_sprite::vera_sprite_height1_vera_sprite_height_321_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    jmp __b6
    // create_sprite::vera_sprite_height1_vera_sprite_height_161
  vera_sprite_height1_vera_sprite_height_161:
    // (word)sprite << 3
    // [997] create_sprite::vera_sprite_height1_vera_sprite_height_161_$8 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_height1_vera_sprite_height_161___8
    lda #0
    sta.z vera_sprite_height1_vera_sprite_height_161___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [998] create_sprite::vera_sprite_height1_vera_sprite_height_161_sprite_offset#0 = create_sprite::vera_sprite_height1_vera_sprite_height_161_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_height1_vera_sprite_height_161_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_161_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_161_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_161_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_161_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_161_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [999] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1000] create_sprite::vera_sprite_height1_vera_sprite_height_161_$4 = create_sprite::vera_sprite_height1_vera_sprite_height_161_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_height1_vera_sprite_height_161___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_161___4
    lda.z vera_sprite_height1_vera_sprite_height_161___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_161___4+1
    // <sprite_offset+7
    // [1001] create_sprite::vera_sprite_height1_vera_sprite_height_161_$3 = < create_sprite::vera_sprite_height1_vera_sprite_height_161_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_height1_vera_sprite_height_161___4
    sta.z vera_sprite_height1_vera_sprite_height_161___3
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1002] *VERA_ADDRX_L = create_sprite::vera_sprite_height1_vera_sprite_height_161_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1003] create_sprite::vera_sprite_height1_vera_sprite_height_161_$5 = > create_sprite::vera_sprite_height1_vera_sprite_height_161_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_height1_vera_sprite_height_161___4+1
    sta.z vera_sprite_height1_vera_sprite_height_161___5
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1004] *VERA_ADDRX_M = create_sprite::vera_sprite_height1_vera_sprite_height_161_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1005] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [1006] create_sprite::vera_sprite_height1_vera_sprite_height_161_$6 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HEIGHT_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_height1_vera_sprite_height_161___6
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_16
    // [1007] create_sprite::vera_sprite_height1_vera_sprite_height_161_$7 = create_sprite::vera_sprite_height1_vera_sprite_height_161_$6 | VERA_SPRITE_HEIGHT_16 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_SPRITE_HEIGHT_16
    ora.z vera_sprite_height1_vera_sprite_height_161___7
    sta.z vera_sprite_height1_vera_sprite_height_161___7
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_16
    // [1008] *VERA_DATA0 = create_sprite::vera_sprite_height1_vera_sprite_height_161_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    jmp __b6
    // create_sprite::vera_sprite_height1_vera_sprite_height_81
  vera_sprite_height1_vera_sprite_height_81:
    // (word)sprite << 3
    // [1009] create_sprite::vera_sprite_height1_vera_sprite_height_81_$8 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_height1_vera_sprite_height_81___8
    lda #0
    sta.z vera_sprite_height1_vera_sprite_height_81___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1010] create_sprite::vera_sprite_height1_vera_sprite_height_81_sprite_offset#0 = create_sprite::vera_sprite_height1_vera_sprite_height_81_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_height1_vera_sprite_height_81_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_81_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_81_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_81_sprite_offset+1
    asl.z vera_sprite_height1_vera_sprite_height_81_sprite_offset
    rol.z vera_sprite_height1_vera_sprite_height_81_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1011] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1012] create_sprite::vera_sprite_height1_vera_sprite_height_81_$4 = create_sprite::vera_sprite_height1_vera_sprite_height_81_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_height1_vera_sprite_height_81___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_81___4
    lda.z vera_sprite_height1_vera_sprite_height_81___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height1_vera_sprite_height_81___4+1
    // <sprite_offset+7
    // [1013] create_sprite::vera_sprite_height1_vera_sprite_height_81_$3 = < create_sprite::vera_sprite_height1_vera_sprite_height_81_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_height1_vera_sprite_height_81___4
    sta.z vera_sprite_height1_vera_sprite_height_81___3
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1014] *VERA_ADDRX_L = create_sprite::vera_sprite_height1_vera_sprite_height_81_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1015] create_sprite::vera_sprite_height1_vera_sprite_height_81_$5 = > create_sprite::vera_sprite_height1_vera_sprite_height_81_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_height1_vera_sprite_height_81___4+1
    sta.z vera_sprite_height1_vera_sprite_height_81___5
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1016] *VERA_ADDRX_M = create_sprite::vera_sprite_height1_vera_sprite_height_81_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1017] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_8
    // [1018] create_sprite::vera_sprite_height1_vera_sprite_height_81_$7 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HEIGHT_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_height1_vera_sprite_height_81___7
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_8
    // [1019] *VERA_DATA0 = create_sprite::vera_sprite_height1_vera_sprite_height_81_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    jmp __b6
    // create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1
  vera_sprite_bpp1_vera_sprite_4bpp1:
    // (word)sprite << 3
    // [1020] create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$7 = (word)create_sprite::Offset#0 -- vwuz1=_word_vbuz2 
    lda.z Offset
    sta.z vera_sprite_bpp1_vera_sprite_4bpp1___7
    lda #0
    sta.z vera_sprite_bpp1_vera_sprite_4bpp1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1021] create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset#0 = create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset
    rol.z vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset+1
    asl.z vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset
    rol.z vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset+1
    asl.z vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset
    rol.z vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1022] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+1
    // [1023] create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$4 = create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_sprite_offset#0 + <VERA_SPRITE_ATTR+1 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_bpp1_vera_sprite_4bpp1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+1
    sta.z vera_sprite_bpp1_vera_sprite_4bpp1___4
    lda.z vera_sprite_bpp1_vera_sprite_4bpp1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+1
    sta.z vera_sprite_bpp1_vera_sprite_4bpp1___4+1
    // <sprite_offset+1
    // [1024] create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$3 = < create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_bpp1_vera_sprite_4bpp1___4
    sta.z vera_sprite_bpp1_vera_sprite_4bpp1___3
    // *VERA_ADDRX_L = <sprite_offset+1
    // [1025] *VERA_ADDRX_L = create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+1
    // [1026] create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$5 = > create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_bpp1_vera_sprite_4bpp1___4+1
    sta.z vera_sprite_bpp1_vera_sprite_4bpp1___5
    // *VERA_ADDRX_M = >sprite_offset+1
    // [1027] *VERA_ADDRX_M = create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1028] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~>VERA_SPRITE_8BPP
    // [1029] create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$6 = *VERA_DATA0 & ~>VERA_SPRITE_8BPP -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #(>VERA_SPRITE_8BPP)^$ff
    and VERA_DATA0
    sta.z vera_sprite_bpp1_vera_sprite_4bpp1___6
    // *VERA_DATA0 = *VERA_DATA0 & ~>VERA_SPRITE_8BPP
    // [1030] *VERA_DATA0 = create_sprite::vera_sprite_bpp1_vera_sprite_4bpp1_$6 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    jmp __b3
}
  // kbhit
// Return true if there's a key waiting, return false if not
kbhit: {
    .label chptr = ch
    .label IN_DEV = $28a
    // Current input device number
    .label GETIN = $ffe4
    .label ch = $bb
    .label return = $40
    // ch = 0
    // [1031] kbhit::ch = 0 -- vbuz1=vbuc1 
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
    // [1033] kbhit::return#0 = kbhit::ch -- vbuz1=vbuz2 
    sta.z return
    // kbhit::@return
    // }
    // [1034] kbhit::return#1 = kbhit::return#0
    // [1035] return 
    rts
}
  // divr16u
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp($55) dividend, word zp($1e) rem)
divr16u: {
    .const divisor = 3
    .label __1 = $bc
    .label __2 = $bc
    .label rem = $1e
    .label dividend = $55
    .label quotient = $50
    .label i = 8
    .label return = $50
    // [1037] phi from divr16u to divr16u::@1 [phi:divr16u->divr16u::@1]
    // [1037] phi divr16u::i#2 = 0 [phi:divr16u->divr16u::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // [1037] phi divr16u::quotient#3 = 0 [phi:divr16u->divr16u::@1#1] -- vwuz1=vwuc1 
    sta.z quotient
    sta.z quotient+1
    // [1037] phi divr16u::dividend#2 = divr16u::dividend#1 [phi:divr16u->divr16u::@1#2] -- register_copy 
    // [1037] phi divr16u::rem#4 = 0 [phi:divr16u->divr16u::@1#3] -- vwuz1=vbuc1 
    sta.z rem
    sta.z rem+1
    // [1037] phi from divr16u::@3 to divr16u::@1 [phi:divr16u::@3->divr16u::@1]
    // [1037] phi divr16u::i#2 = divr16u::i#1 [phi:divr16u::@3->divr16u::@1#0] -- register_copy 
    // [1037] phi divr16u::quotient#3 = divr16u::return#0 [phi:divr16u::@3->divr16u::@1#1] -- register_copy 
    // [1037] phi divr16u::dividend#2 = divr16u::dividend#0 [phi:divr16u::@3->divr16u::@1#2] -- register_copy 
    // [1037] phi divr16u::rem#4 = divr16u::rem#10 [phi:divr16u::@3->divr16u::@1#3] -- register_copy 
    // divr16u::@1
  __b1:
    // rem = rem << 1
    // [1038] divr16u::rem#0 = divr16u::rem#4 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z rem
    rol.z rem+1
    // >dividend
    // [1039] divr16u::$1 = > divr16u::dividend#2 -- vbuz1=_hi_vwuz2 
    lda.z dividend+1
    sta.z __1
    // >dividend & $80
    // [1040] divr16u::$2 = divr16u::$1 & $80 -- vbuz1=vbuz1_band_vbuc1 
    lda #$80
    and.z __2
    sta.z __2
    // if( (>dividend & $80) != 0 )
    // [1041] if(divr16u::$2==0) goto divr16u::@2 -- vbuz1_eq_0_then_la1 
    cmp #0
    beq __b2
    // divr16u::@4
    // rem = rem | 1
    // [1042] divr16u::rem#1 = divr16u::rem#0 | 1 -- vwuz1=vwuz1_bor_vbuc1 
    lda #1
    ora.z rem
    sta.z rem
    // [1043] phi from divr16u::@1 divr16u::@4 to divr16u::@2 [phi:divr16u::@1/divr16u::@4->divr16u::@2]
    // [1043] phi divr16u::rem#5 = divr16u::rem#0 [phi:divr16u::@1/divr16u::@4->divr16u::@2#0] -- register_copy 
    // divr16u::@2
  __b2:
    // dividend = dividend << 1
    // [1044] divr16u::dividend#0 = divr16u::dividend#2 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z dividend
    rol.z dividend+1
    // quotient = quotient << 1
    // [1045] divr16u::quotient#1 = divr16u::quotient#3 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z quotient
    rol.z quotient+1
    // if(rem>=divisor)
    // [1046] if(divr16u::rem#5<divr16u::divisor#0) goto divr16u::@3 -- vwuz1_lt_vwuc1_then_la1 
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
    // [1047] divr16u::quotient#2 = ++ divr16u::quotient#1 -- vwuz1=_inc_vwuz1 
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    // rem = rem - divisor
    // [1048] divr16u::rem#2 = divr16u::rem#5 - divr16u::divisor#0 -- vwuz1=vwuz1_minus_vwuc1 
    lda.z rem
    sec
    sbc #<divisor
    sta.z rem
    lda.z rem+1
    sbc #>divisor
    sta.z rem+1
    // [1049] phi from divr16u::@2 divr16u::@5 to divr16u::@3 [phi:divr16u::@2/divr16u::@5->divr16u::@3]
    // [1049] phi divr16u::return#0 = divr16u::quotient#1 [phi:divr16u::@2/divr16u::@5->divr16u::@3#0] -- register_copy 
    // [1049] phi divr16u::rem#10 = divr16u::rem#5 [phi:divr16u::@2/divr16u::@5->divr16u::@3#1] -- register_copy 
    // divr16u::@3
  __b3:
    // for( char i : 0..15)
    // [1050] divr16u::i#1 = ++ divr16u::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [1051] if(divr16u::i#1!=$10) goto divr16u::@1 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z i
    bne __b1
    // divr16u::@return
    // }
    // [1052] return 
    rts
}
  // vera_layer_set_text_color_mode
// Set the configuration of the layer text color mode.
// - layer: Value of 0 or 1.
// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
vera_layer_set_text_color_mode: {
    .label addr = $5b
    // addr = vera_layer_config[layer]
    // [1053] vera_layer_set_text_color_mode::addr#0 = *(vera_layer_config+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr &= ~VERA_LAYER_CONFIG_256C
    // [1054] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 & ~VERA_LAYER_CONFIG_256C -- _deref_pbuz1=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C^$ff
    ldy #0
    and (addr),y
    sta (addr),y
    // *addr |= color_mode
    // [1055] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 -- _deref_pbuz1=_deref_pbuz1 
    lda (addr),y
    sta (addr),y
    // vera_layer_set_text_color_mode::@return
    // }
    // [1056] return 
    rts
}
  // vera_layer_get_mapbase_bank
// Get the map base bank of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Bank in vera vram.
vera_layer_get_mapbase_bank: {
    .const layer = 1
    .label return = $5a
    // return vera_mapbase_bank[layer];
    // [1057] vera_layer_get_mapbase_bank::return#0 = *(vera_mapbase_bank+vera_layer_get_mapbase_bank::layer#0) -- vbuz1=_deref_pbuc1 
    lda vera_mapbase_bank+layer
    sta.z return
    // vera_layer_get_mapbase_bank::@return
    // }
    // [1058] return 
    rts
}
  // vera_layer_get_mapbase_offset
// Get the map base lower 16-bit address (offset) of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Offset in vera vram of the specified bank.
vera_layer_get_mapbase_offset: {
    .const layer = 1
    .label return = $5b
    // return vera_mapbase_offset[layer];
    // [1059] vera_layer_get_mapbase_offset::return#0 = *(vera_mapbase_offset+vera_layer_get_mapbase_offset::layer#0<<1) -- vwuz1=_deref_pwuc1 
    lda vera_mapbase_offset+(layer<<1)
    sta.z return
    lda vera_mapbase_offset+(layer<<1)+1
    sta.z return+1
    // vera_layer_get_mapbase_offset::@return
    // }
    // [1060] return 
    rts
}
  // vera_layer_get_rowshift
// Get the bit shift value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
vera_layer_get_rowshift: {
    .const layer = 1
    .label return = $e
    // return vera_layer_rowshift[layer];
    // [1061] vera_layer_get_rowshift::return#0 = *(vera_layer_rowshift+vera_layer_get_rowshift::layer#0) -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift+layer
    sta.z return
    // vera_layer_get_rowshift::@return
    // }
    // [1062] return 
    rts
}
  // vera_layer_get_rowskip
// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
vera_layer_get_rowskip: {
    .const layer = 1
    .label return = $5b
    // return vera_layer_rowskip[layer];
    // [1063] vera_layer_get_rowskip::return#0 = *(vera_layer_rowskip+vera_layer_get_rowskip::layer#0<<1) -- vwuz1=_deref_pwuc1 
    lda vera_layer_rowskip+(layer<<1)
    sta.z return
    lda vera_layer_rowskip+(layer<<1)+1
    sta.z return+1
    // vera_layer_get_rowskip::@return
    // }
    // [1064] return 
    rts
}
  // printf_string
// Print a string value using a specific format
// Handles justification and min length 
// printf_string(byte* zp($af) str)
printf_string: {
    .label str = $af
    // printf_string::@1
    // cputs(str)
    // [1066] cputs::s#2 = printf_string::str#2
    // [1067] call cputs 
    // [529] phi from printf_string::@1 to cputs [phi:printf_string::@1->cputs]
    // [529] phi cputs::s#13 = cputs::s#2 [phi:printf_string::@1->cputs#0] -- register_copy 
    jsr cputs
    // printf_string::@return
    // }
    // [1068] return 
    rts
}
  // cx16_ram_bank
// Configure the bank of a banked ram on the X16.
// cx16_ram_bank(byte zp($aa) bank)
cx16_ram_bank: {
    .label return = $b3
    .label bank = $aa
    // current_bank = VIA1->PORT_A
    // [1070] cx16_ram_bank::return#0 = *((byte*)VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A) -- vbuz1=_deref_pbuc1 
    lda VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    sta.z return
    // VIA1->PORT_A = bank
    // [1071] *((byte*)VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A) = cx16_ram_bank::bank#11 -- _deref_pbuc1=vbuz1 
    lda.z bank
    sta VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    // cx16_ram_bank::@return
    // }
    // [1072] return 
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
// cbm_k_setnam(byte* zp($60) filename)
cbm_k_setnam: {
    .label filename = $60
    .label filename_len = $bd
    .label __0 = $c8
    // strlen(filename)
    // [1073] strlen::str#1 = cbm_k_setnam::filename -- pbuz1=pbuz2 
    lda.z filename
    sta.z strlen.str
    lda.z filename+1
    sta.z strlen.str+1
    // [1074] call strlen 
    // [1452] phi from cbm_k_setnam to strlen [phi:cbm_k_setnam->strlen]
    // [1452] phi strlen::str#6 = strlen::str#1 [phi:cbm_k_setnam->strlen#0] -- register_copy 
    jsr strlen
    // strlen(filename)
    // [1075] strlen::return#2 = strlen::len#2
    // cbm_k_setnam::@1
    // [1076] cbm_k_setnam::$0 = strlen::return#2
    // filename_len = (char)strlen(filename)
    // [1077] cbm_k_setnam::filename_len = (byte)cbm_k_setnam::$0 -- vbuz1=_byte_vwuz2 
    lda.z __0
    sta.z filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx filename
    ldy filename+1
    jsr CBM_SETNAM
    // cbm_k_setnam::@return
    // }
    // [1079] return 
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
// cbm_k_setlfs(byte zp($62) channel, byte zp($63) device, byte zp($64) secondary)
cbm_k_setlfs: {
    .label channel = $62
    .label device = $63
    .label secondary = $64
    // asm
    // asm { ldxdevice ldachannel ldysecondary jsrCBM_SETLFS  }
    ldx device
    lda channel
    ldy secondary
    jsr CBM_SETLFS
    // cbm_k_setlfs::@return
    // }
    // [1081] return 
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
    .label status = $be
    .label return = $f
    // status
    // [1082] cbm_k_open::status = 0 -- vbuz1=vbuc1 
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
    // [1084] cbm_k_open::return#0 = cbm_k_open::status -- vbuz1=vbuz2 
    sta.z return
    // cbm_k_open::@return
    // }
    // [1085] cbm_k_open::return#1 = cbm_k_open::return#0
    // [1086] return 
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
// cbm_k_chkin(byte zp($65) channel)
cbm_k_chkin: {
    .label channel = $65
    .label status = $bf
    .label return = $f
    // status
    // [1087] cbm_k_chkin::status = 0 -- vbuz1=vbuc1 
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
    // [1089] cbm_k_chkin::return#0 = cbm_k_chkin::status -- vbuz1=vbuz2 
    sta.z return
    // cbm_k_chkin::@return
    // }
    // [1090] cbm_k_chkin::return#1 = cbm_k_chkin::return#0
    // [1091] return 
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
    .label value = $c0
    .label return = $40
    // value
    // [1092] cbm_k_chrin::value = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z value
    // asm
    // asm { jsrCBM_CHRIN stavalue  }
    jsr CBM_CHRIN
    sta value
    // return value;
    // [1094] cbm_k_chrin::return#0 = cbm_k_chrin::value -- vbuz1=vbuz2 
    sta.z return
    // cbm_k_chrin::@return
    // }
    // [1095] cbm_k_chrin::return#1 = cbm_k_chrin::return#0
    // [1096] return 
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
    .label status = $c1
    .label return = $7f
    // status
    // [1097] cbm_k_readst::status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta status
    // return status;
    // [1099] cbm_k_readst::return#0 = cbm_k_readst::status -- vbuz1=vbuz2 
    sta.z return
    // cbm_k_readst::@return
    // }
    // [1100] cbm_k_readst::return#1 = cbm_k_readst::return#0
    // [1101] return 
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
// cbm_k_close(byte zp($66) channel)
cbm_k_close: {
    .label channel = $66
    .label status = $c2
    .label return = $f
    // status
    // [1102] cbm_k_close::status = 0 -- vbuz1=vbuc1 
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
    // [1104] cbm_k_close::return#0 = cbm_k_close::status -- vbuz1=vbuz2 
    sta.z return
    // cbm_k_close::@return
    // }
    // [1105] cbm_k_close::return#1 = cbm_k_close::return#0
    // [1106] return 
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
    // [1108] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($ba) c)
cputc: {
    .label __2 = $c7
    .label __4 = $c7
    .label __5 = $c7
    .label __6 = $c7
    .label __15 = $c7
    .label __16 = $75
    .label color = $b9
    .label conio_screen_text = $c3
    .label conio_map_width = $c5
    .label conio_addr = $c3
    .label scroll_enable = $b9
    .label c = $ba
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1110] vera_layer_get_color::layer#0 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_color.layer
    // [1111] call vera_layer_get_color 
    // [1458] phi from cputc to vera_layer_get_color [phi:cputc->vera_layer_get_color]
    // [1458] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#0 [phi:cputc->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1112] vera_layer_get_color::return#3 = vera_layer_get_color::return#2
    // cputc::@7
    // color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1113] cputc::color#0 = vera_layer_get_color::return#3
    // conio_screen_text = cx16_conio.conio_screen_text
    // [1114] cputc::conio_screen_text#0 = *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- pbuz1=_deref_qbuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z conio_screen_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z conio_screen_text+1
    // conio_map_width = cx16_conio.conio_map_width
    // [1115] cputc::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [1116] cputc::$15 = *((byte*)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __15
    // conio_addr = conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [1117] cputc::conio_addr#0 = cputc::conio_screen_text#0 + conio_line_text[cputc::$15] -- pbuz1=pbuz1_plus_pwuc1_derefidx_vbuz2 
    tay
    clc
    lda.z conio_addr
    adc conio_line_text,y
    sta.z conio_addr
    lda.z conio_addr+1
    adc conio_line_text+1,y
    sta.z conio_addr+1
    // conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [1118] cputc::$2 = conio_cursor_x[*((byte*)&cx16_conio)] << 1 -- vbuz1=pbuc1_derefidx_(_deref_pbuc2)_rol_1 
    ldy cx16_conio
    lda conio_cursor_x,y
    asl
    sta.z __2
    // conio_addr += conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [1119] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$2 -- pbuz1=pbuz1_plus_vbuz2 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [1120] if(cputc::c#3==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1121] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <conio_addr
    // [1122] cputc::$4 = < cputc::conio_addr#1 -- vbuz1=_lo_pbuz2 
    lda.z conio_addr
    sta.z __4
    // *VERA_ADDRX_L = <conio_addr
    // [1123] *VERA_ADDRX_L = cputc::$4 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // >conio_addr
    // [1124] cputc::$5 = > cputc::conio_addr#1 -- vbuz1=_hi_pbuz2 
    lda.z conio_addr+1
    sta.z __5
    // *VERA_ADDRX_M = >conio_addr
    // [1125] *VERA_ADDRX_M = cputc::$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [1126] cputc::$6 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    sta.z __6
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [1127] *VERA_ADDRX_H = cputc::$6 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [1128] *VERA_DATA0 = cputc::c#3 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [1129] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // conio_cursor_x[cx16_conio.conio_screen_layer]++;
    // [1130] conio_cursor_x[*((byte*)&cx16_conio)] = ++ conio_cursor_x[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    ldy cx16_conio
    lda conio_cursor_x,x
    inc
    sta conio_cursor_x,y
    // scroll_enable = conio_scroll_enable[cx16_conio.conio_screen_layer]
    // [1131] cputc::scroll_enable#0 = conio_scroll_enable[*((byte*)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_scroll_enable,y
    sta.z scroll_enable
    // if(scroll_enable)
    // [1132] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuz1_then_la1 
    cmp #0
    bne __b5
    // cputc::@3
    // (unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width
    // [1133] cputc::$16 = (word)conio_cursor_x[*((byte*)&cx16_conio)] -- vwuz1=_word_pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_cursor_x,y
    sta.z __16
    lda #0
    sta.z __16+1
    // if((unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width)
    // [1134] if(cputc::$16!=cputc::conio_map_width#0) goto cputc::@return -- vwuz1_neq_vwuz2_then_la1 
    cmp.z conio_map_width+1
    bne __breturn
    lda.z __16
    cmp.z conio_map_width
    bne __breturn
    // [1135] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [1136] call cputln 
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [1137] return 
    rts
    // cputc::@5
  __b5:
    // if(conio_cursor_x[cx16_conio.conio_screen_layer] == cx16_conio.conio_screen_width)
    // [1138] if(conio_cursor_x[*((byte*)&cx16_conio)]!=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto cputc::@return -- pbuc1_derefidx_(_deref_pbuc2)_neq__deref_pbuc3_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    ldy cx16_conio
    cmp conio_cursor_x,y
    bne __breturn
    // [1139] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [1140] call cputln 
    jsr cputln
    rts
    // [1141] phi from cputc::@7 to cputc::@1 [phi:cputc::@7->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [1142] call cputln 
    jsr cputln
    rts
}
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte zp($f) value, byte* zp($c5) buffer, byte zp($7f) radix)
uctoa: {
    .label __4 = $40
    .label digit_value = $a9
    .label buffer = $c5
    .label digit = $20
    .label value = $f
    .label radix = $7f
    .label started = $21
    .label max_digits = $aa
    .label digit_values = $7d
    // if(radix==DECIMAL)
    // [1143] if(uctoa::radix#0==DECIMAL) goto uctoa::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #DECIMAL
    cmp.z radix
    beq __b2
    // uctoa::@2
    // if(radix==HEXADECIMAL)
    // [1144] if(uctoa::radix#0==HEXADECIMAL) goto uctoa::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #HEXADECIMAL
    cmp.z radix
    beq __b3
    // uctoa::@3
    // if(radix==OCTAL)
    // [1145] if(uctoa::radix#0==OCTAL) goto uctoa::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #OCTAL
    cmp.z radix
    beq __b4
    // uctoa::@4
    // if(radix==BINARY)
    // [1146] if(uctoa::radix#0==BINARY) goto uctoa::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #BINARY
    cmp.z radix
    beq __b5
    // uctoa::@5
    // *buffer++ = 'e'
    // [1147] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS) = 'e' -- _deref_pbuc1=vbuc2 
    // Unknown radix
    lda #'e'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    // [1148] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1) = 'r' -- _deref_pbuc1=vbuc2 
    lda #'r'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    // [1149] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2) = 'r' -- _deref_pbuc1=vbuc2 
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    // [1150] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // uctoa::@return
    // }
    // [1151] return 
    rts
    // [1152] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
  __b2:
    // [1152] phi uctoa::digit_values#8 = RADIX_DECIMAL_VALUES_CHAR [phi:uctoa->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values+1
    // [1152] phi uctoa::max_digits#7 = 3 [phi:uctoa->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #3
    sta.z max_digits
    jmp __b1
    // [1152] phi from uctoa::@2 to uctoa::@1 [phi:uctoa::@2->uctoa::@1]
  __b3:
    // [1152] phi uctoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES_CHAR [phi:uctoa::@2->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values+1
    // [1152] phi uctoa::max_digits#7 = 2 [phi:uctoa::@2->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #2
    sta.z max_digits
    jmp __b1
    // [1152] phi from uctoa::@3 to uctoa::@1 [phi:uctoa::@3->uctoa::@1]
  __b4:
    // [1152] phi uctoa::digit_values#8 = RADIX_OCTAL_VALUES_CHAR [phi:uctoa::@3->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values+1
    // [1152] phi uctoa::max_digits#7 = 3 [phi:uctoa::@3->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #3
    sta.z max_digits
    jmp __b1
    // [1152] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
  __b5:
    // [1152] phi uctoa::digit_values#8 = RADIX_BINARY_VALUES_CHAR [phi:uctoa::@4->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_BINARY_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES_CHAR
    sta.z digit_values+1
    // [1152] phi uctoa::max_digits#7 = 8 [phi:uctoa::@4->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #8
    sta.z max_digits
    // uctoa::@1
  __b1:
    // [1153] phi from uctoa::@1 to uctoa::@6 [phi:uctoa::@1->uctoa::@6]
    // [1153] phi uctoa::buffer#11 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:uctoa::@1->uctoa::@6#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [1153] phi uctoa::started#2 = 0 [phi:uctoa::@1->uctoa::@6#1] -- vbuz1=vbuc1 
    lda #0
    sta.z started
    // [1153] phi uctoa::value#2 = uctoa::value#1 [phi:uctoa::@1->uctoa::@6#2] -- register_copy 
    // [1153] phi uctoa::digit#2 = 0 [phi:uctoa::@1->uctoa::@6#3] -- vbuz1=vbuc1 
    sta.z digit
    // uctoa::@6
  __b6:
    // max_digits-1
    // [1154] uctoa::$4 = uctoa::max_digits#7 - 1 -- vbuz1=vbuz2_minus_1 
    ldx.z max_digits
    dex
    stx.z __4
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1155] if(uctoa::digit#2<uctoa::$4) goto uctoa::@7 -- vbuz1_lt_vbuz2_then_la1 
    lda.z digit
    cmp.z __4
    bcc __b7
    // uctoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [1156] *uctoa::buffer#11 = DIGITS[uctoa::value#2] -- _deref_pbuz1=pbuc1_derefidx_vbuz2 
    ldy.z value
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1157] uctoa::buffer#3 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1158] *uctoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    rts
    // uctoa::@7
  __b7:
    // digit_value = digit_values[digit]
    // [1159] uctoa::digit_value#0 = uctoa::digit_values#8[uctoa::digit#2] -- vbuz1=pbuz2_derefidx_vbuz3 
    ldy.z digit
    lda (digit_values),y
    sta.z digit_value
    // if (started || value >= digit_value)
    // [1160] if(0!=uctoa::started#2) goto uctoa::@10 -- 0_neq_vbuz1_then_la1 
    lda.z started
    cmp #0
    bne __b10
    // uctoa::@12
    // [1161] if(uctoa::value#2>=uctoa::digit_value#0) goto uctoa::@10 -- vbuz1_ge_vbuz2_then_la1 
    lda.z value
    cmp.z digit_value
    bcs __b10
    // [1162] phi from uctoa::@12 to uctoa::@9 [phi:uctoa::@12->uctoa::@9]
    // [1162] phi uctoa::buffer#14 = uctoa::buffer#11 [phi:uctoa::@12->uctoa::@9#0] -- register_copy 
    // [1162] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@12->uctoa::@9#1] -- register_copy 
    // [1162] phi uctoa::value#6 = uctoa::value#2 [phi:uctoa::@12->uctoa::@9#2] -- register_copy 
    // uctoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1163] uctoa::digit#1 = ++ uctoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [1153] phi from uctoa::@9 to uctoa::@6 [phi:uctoa::@9->uctoa::@6]
    // [1153] phi uctoa::buffer#11 = uctoa::buffer#14 [phi:uctoa::@9->uctoa::@6#0] -- register_copy 
    // [1153] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@9->uctoa::@6#1] -- register_copy 
    // [1153] phi uctoa::value#2 = uctoa::value#6 [phi:uctoa::@9->uctoa::@6#2] -- register_copy 
    // [1153] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@9->uctoa::@6#3] -- register_copy 
    jmp __b6
    // uctoa::@10
  __b10:
    // uctoa_append(buffer++, value, digit_value)
    // [1164] uctoa_append::buffer#0 = uctoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z uctoa_append.buffer
    lda.z buffer+1
    sta.z uctoa_append.buffer+1
    // [1165] uctoa_append::value#0 = uctoa::value#2
    // [1166] uctoa_append::sub#0 = uctoa::digit_value#0
    // [1167] call uctoa_append 
    // [1477] phi from uctoa::@10 to uctoa_append [phi:uctoa::@10->uctoa_append]
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // [1168] uctoa_append::return#0 = uctoa_append::value#2
    // uctoa::@11
    // value = uctoa_append(buffer++, value, digit_value)
    // [1169] uctoa::value#0 = uctoa_append::return#0
    // value = uctoa_append(buffer++, value, digit_value);
    // [1170] uctoa::buffer#4 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1162] phi from uctoa::@11 to uctoa::@9 [phi:uctoa::@11->uctoa::@9]
    // [1162] phi uctoa::buffer#14 = uctoa::buffer#4 [phi:uctoa::@11->uctoa::@9#0] -- register_copy 
    // [1162] phi uctoa::started#4 = 1 [phi:uctoa::@11->uctoa::@9#1] -- vbuz1=vbuc1 
    lda #1
    sta.z started
    // [1162] phi uctoa::value#6 = uctoa::value#0 [phi:uctoa::@11->uctoa::@9#2] -- register_copy 
    jmp __b9
}
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp($aa) buffer_sign, byte zp($20) format_min_length, byte zp($21) format_justify_left, byte zp($b3) format_zero_padding, byte zp($b5) format_upper_case)
printf_number_buffer: {
    .label __19 = $c8
    .label buffer_sign = $aa
    .label len = $ba
    .label padding = $20
    .label format_min_length = $20
    .label format_zero_padding = $b3
    .label format_justify_left = $21
    .label format_upper_case = $b5
    // if(format.min_length)
    // [1172] if(0==printf_number_buffer::format_min_length#2) goto printf_number_buffer::@1 -- 0_eq_vbuz1_then_la1 
    lda.z format_min_length
    cmp #0
    beq __b6
    // [1173] phi from printf_number_buffer to printf_number_buffer::@6 [phi:printf_number_buffer->printf_number_buffer::@6]
    // printf_number_buffer::@6
    // strlen(buffer.digits)
    // [1174] call strlen 
    // [1452] phi from printf_number_buffer::@6 to strlen [phi:printf_number_buffer::@6->strlen]
    // [1452] phi strlen::str#6 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:printf_number_buffer::@6->strlen#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z strlen.str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z strlen.str+1
    jsr strlen
    // strlen(buffer.digits)
    // [1175] strlen::return#3 = strlen::len#2
    // printf_number_buffer::@14
    // [1176] printf_number_buffer::$19 = strlen::return#3
    // len = (signed char)strlen(buffer.digits)
    // [1177] printf_number_buffer::len#0 = (signed byte)printf_number_buffer::$19 -- vbsz1=_sbyte_vwuz2 
    // There is a minimum length - work out the padding
    lda.z __19
    sta.z len
    // if(buffer.sign)
    // [1178] if(0==printf_number_buffer::buffer_sign#10) goto printf_number_buffer::@13 -- 0_eq_vbuz1_then_la1 
    lda.z buffer_sign
    cmp #0
    beq __b13
    // printf_number_buffer::@7
    // len++;
    // [1179] printf_number_buffer::len#1 = ++ printf_number_buffer::len#0 -- vbsz1=_inc_vbsz1 
    inc.z len
    // [1180] phi from printf_number_buffer::@14 printf_number_buffer::@7 to printf_number_buffer::@13 [phi:printf_number_buffer::@14/printf_number_buffer::@7->printf_number_buffer::@13]
    // [1180] phi printf_number_buffer::len#2 = printf_number_buffer::len#0 [phi:printf_number_buffer::@14/printf_number_buffer::@7->printf_number_buffer::@13#0] -- register_copy 
    // printf_number_buffer::@13
  __b13:
    // padding = (signed char)format.min_length - len
    // [1181] printf_number_buffer::padding#1 = (signed byte)printf_number_buffer::format_min_length#2 - printf_number_buffer::len#2 -- vbsz1=vbsz1_minus_vbsz2 
    lda.z padding
    sec
    sbc.z len
    sta.z padding
    // if(padding<0)
    // [1182] if(printf_number_buffer::padding#1>=0) goto printf_number_buffer::@21 -- vbsz1_ge_0_then_la1 
    cmp #0
    bpl __b1
    // [1184] phi from printf_number_buffer printf_number_buffer::@13 to printf_number_buffer::@1 [phi:printf_number_buffer/printf_number_buffer::@13->printf_number_buffer::@1]
  __b6:
    // [1184] phi printf_number_buffer::padding#10 = 0 [phi:printf_number_buffer/printf_number_buffer::@13->printf_number_buffer::@1#0] -- vbsz1=vbsc1 
    lda #0
    sta.z padding
    // [1183] phi from printf_number_buffer::@13 to printf_number_buffer::@21 [phi:printf_number_buffer::@13->printf_number_buffer::@21]
    // printf_number_buffer::@21
    // [1184] phi from printf_number_buffer::@21 to printf_number_buffer::@1 [phi:printf_number_buffer::@21->printf_number_buffer::@1]
    // [1184] phi printf_number_buffer::padding#10 = printf_number_buffer::padding#1 [phi:printf_number_buffer::@21->printf_number_buffer::@1#0] -- register_copy 
    // printf_number_buffer::@1
  __b1:
    // if(!format.justify_left && !format.zero_padding && padding)
    // [1185] if(0!=printf_number_buffer::format_justify_left#10) goto printf_number_buffer::@2 -- 0_neq_vbuz1_then_la1 
    lda.z format_justify_left
    cmp #0
    bne __b2
    // printf_number_buffer::@17
    // [1186] if(0!=printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@2 -- 0_neq_vbuz1_then_la1 
    lda.z format_zero_padding
    cmp #0
    bne __b2
    // printf_number_buffer::@16
    // [1187] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@8 -- 0_neq_vbsz1_then_la1 
    lda.z padding
    cmp #0
    bne __b8
    jmp __b2
    // printf_number_buffer::@8
  __b8:
    // printf_padding(' ',(char)padding)
    // [1188] printf_padding::length#0 = (byte)printf_number_buffer::padding#10 -- vbuz1=vbuz2 
    lda.z padding
    sta.z printf_padding.length
    // [1189] call printf_padding 
    // [1484] phi from printf_number_buffer::@8 to printf_padding [phi:printf_number_buffer::@8->printf_padding]
    // [1484] phi printf_padding::pad#7 = ' ' [phi:printf_number_buffer::@8->printf_padding#0] -- vbuz1=vbuc1 
    lda #' '
    sta.z printf_padding.pad
    // [1484] phi printf_padding::length#6 = printf_padding::length#0 [phi:printf_number_buffer::@8->printf_padding#1] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@2
  __b2:
    // if(buffer.sign)
    // [1190] if(0==printf_number_buffer::buffer_sign#10) goto printf_number_buffer::@3 -- 0_eq_vbuz1_then_la1 
    lda.z buffer_sign
    cmp #0
    beq __b3
    // printf_number_buffer::@9
    // cputc(buffer.sign)
    // [1191] cputc::c#2 = printf_number_buffer::buffer_sign#10 -- vbuz1=vbuz2 
    sta.z cputc.c
    // [1192] call cputc 
    // [1109] phi from printf_number_buffer::@9 to cputc [phi:printf_number_buffer::@9->cputc]
    // [1109] phi cputc::c#3 = cputc::c#2 [phi:printf_number_buffer::@9->cputc#0] -- register_copy 
    jsr cputc
    // printf_number_buffer::@3
  __b3:
    // if(format.zero_padding && padding)
    // [1193] if(0==printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@4 -- 0_eq_vbuz1_then_la1 
    lda.z format_zero_padding
    cmp #0
    beq __b4
    // printf_number_buffer::@18
    // [1194] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@10 -- 0_neq_vbsz1_then_la1 
    lda.z padding
    cmp #0
    bne __b10
    jmp __b4
    // printf_number_buffer::@10
  __b10:
    // printf_padding('0',(char)padding)
    // [1195] printf_padding::length#1 = (byte)printf_number_buffer::padding#10 -- vbuz1=vbuz2 
    lda.z padding
    sta.z printf_padding.length
    // [1196] call printf_padding 
    // [1484] phi from printf_number_buffer::@10 to printf_padding [phi:printf_number_buffer::@10->printf_padding]
    // [1484] phi printf_padding::pad#7 = '0' [phi:printf_number_buffer::@10->printf_padding#0] -- vbuz1=vbuc1 
    lda #'0'
    sta.z printf_padding.pad
    // [1484] phi printf_padding::length#6 = printf_padding::length#1 [phi:printf_number_buffer::@10->printf_padding#1] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@4
  __b4:
    // if(format.upper_case)
    // [1197] if(0==printf_number_buffer::format_upper_case#10) goto printf_number_buffer::@5 -- 0_eq_vbuz1_then_la1 
    lda.z format_upper_case
    cmp #0
    beq __b5
    // [1198] phi from printf_number_buffer::@4 to printf_number_buffer::@11 [phi:printf_number_buffer::@4->printf_number_buffer::@11]
    // printf_number_buffer::@11
    // strupr(buffer.digits)
    // [1199] call strupr 
    // [1491] phi from printf_number_buffer::@11 to strupr [phi:printf_number_buffer::@11->strupr]
    jsr strupr
    // [1200] phi from printf_number_buffer::@11 printf_number_buffer::@4 to printf_number_buffer::@5 [phi:printf_number_buffer::@11/printf_number_buffer::@4->printf_number_buffer::@5]
    // printf_number_buffer::@5
  __b5:
    // cputs(buffer.digits)
    // [1201] call cputs 
    // [529] phi from printf_number_buffer::@5 to cputs [phi:printf_number_buffer::@5->cputs]
    // [529] phi cputs::s#13 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:printf_number_buffer::@5->cputs#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s+1
    jsr cputs
    // printf_number_buffer::@15
    // if(format.justify_left && !format.zero_padding && padding)
    // [1202] if(0==printf_number_buffer::format_justify_left#10) goto printf_number_buffer::@return -- 0_eq_vbuz1_then_la1 
    lda.z format_justify_left
    cmp #0
    beq __breturn
    // printf_number_buffer::@20
    // [1203] if(0!=printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@return -- 0_neq_vbuz1_then_la1 
    lda.z format_zero_padding
    cmp #0
    bne __breturn
    // printf_number_buffer::@19
    // [1204] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@12 -- 0_neq_vbsz1_then_la1 
    lda.z padding
    cmp #0
    bne __b12
    rts
    // printf_number_buffer::@12
  __b12:
    // printf_padding(' ',(char)padding)
    // [1205] printf_padding::length#2 = (byte)printf_number_buffer::padding#10 -- vbuz1=vbuz2 
    lda.z padding
    sta.z printf_padding.length
    // [1206] call printf_padding 
    // [1484] phi from printf_number_buffer::@12 to printf_padding [phi:printf_number_buffer::@12->printf_padding]
    // [1484] phi printf_padding::pad#7 = ' ' [phi:printf_number_buffer::@12->printf_padding#0] -- vbuz1=vbuc1 
    lda #' '
    sta.z printf_padding.pad
    // [1484] phi printf_padding::length#6 = printf_padding::length#2 [phi:printf_number_buffer::@12->printf_padding#1] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@return
  __breturn:
    // }
    // [1207] return 
    rts
}
  // vera_heap_block_free_find
// vera_heap_block_free_find(struct vera_heap_segment* zp($b1) segment, dword zp($6b) size)
vera_heap_block_free_find: {
    .label __0 = $6f
    .label __2 = $26
    .label block = $b1
    .label return = $b1
    .label segment = $b1
    .label size = $6b
    // block = segment->head_block
    // [1208] vera_heap_block_free_find::block#0 = ((struct vera_heap**)vera_heap_block_free_find::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK] -- pssz1=qssz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK
    lda (block),y
    pha
    iny
    lda (block),y
    sta.z block+1
    pla
    sta.z block
    // [1209] phi from vera_heap_block_free_find vera_heap_block_free_find::@3 to vera_heap_block_free_find::@1 [phi:vera_heap_block_free_find/vera_heap_block_free_find::@3->vera_heap_block_free_find::@1]
    // [1209] phi vera_heap_block_free_find::block#2 = vera_heap_block_free_find::block#0 [phi:vera_heap_block_free_find/vera_heap_block_free_find::@3->vera_heap_block_free_find::@1#0] -- register_copy 
    // vera_heap_block_free_find::@1
  __b1:
    // while(block)
    // [1210] if((struct vera_heap*)0!=vera_heap_block_free_find::block#2) goto vera_heap_block_free_find::@2 -- pssc1_neq_pssz1_then_la1 
    lda.z block+1
    cmp #>0
    bne __b2
    lda.z block
    cmp #<0
    bne __b2
    // [1211] phi from vera_heap_block_free_find::@1 to vera_heap_block_free_find::@return [phi:vera_heap_block_free_find::@1->vera_heap_block_free_find::@return]
    // [1211] phi vera_heap_block_free_find::return#2 = (struct vera_heap*) 0 [phi:vera_heap_block_free_find::@1->vera_heap_block_free_find::@return#0] -- pssz1=pssc1 
    lda #<0
    sta.z return
    sta.z return+1
    // vera_heap_block_free_find::@return
    // }
    // [1212] return 
    rts
    // vera_heap_block_free_find::@2
  __b2:
    // vera_heap_block_is_empty(block)
    // [1213] vera_heap_block_is_empty::block#0 = vera_heap_block_free_find::block#2
    // [1214] call vera_heap_block_is_empty 
    jsr vera_heap_block_is_empty
    // [1215] vera_heap_block_is_empty::return#2 = vera_heap_block_is_empty::return#0
    // vera_heap_block_free_find::@5
    // [1216] vera_heap_block_free_find::$0 = vera_heap_block_is_empty::return#2
    // if(vera_heap_block_is_empty(block))
    // [1217] if(0==vera_heap_block_free_find::$0) goto vera_heap_block_free_find::@3 -- 0_eq_vwuz1_then_la1 
    lda.z __0
    ora.z __0+1
    beq __b3
    // vera_heap_block_free_find::@4
    // vera_heap_block_size_get(block)
    // [1218] vera_heap_block_size_get::block#0 = vera_heap_block_free_find::block#2 -- pssz1=pssz2 
    lda.z block
    sta.z vera_heap_block_size_get.block
    lda.z block+1
    sta.z vera_heap_block_size_get.block+1
    // [1219] call vera_heap_block_size_get 
    jsr vera_heap_block_size_get
    // [1220] vera_heap_block_size_get::return#2 = vera_heap_block_size_get::return#0
    // vera_heap_block_free_find::@6
    // [1221] vera_heap_block_free_find::$2 = vera_heap_block_size_get::return#2
    // if(size==vera_heap_block_size_get(block))
    // [1222] if(vera_heap_block_free_find::size#0!=vera_heap_block_free_find::$2) goto vera_heap_block_free_find::@3 -- vduz1_neq_vduz2_then_la1 
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
    // [1211] phi from vera_heap_block_free_find::@6 to vera_heap_block_free_find::@return [phi:vera_heap_block_free_find::@6->vera_heap_block_free_find::@return]
    // [1211] phi vera_heap_block_free_find::return#2 = vera_heap_block_free_find::block#2 [phi:vera_heap_block_free_find::@6->vera_heap_block_free_find::@return#0] -- register_copy 
    rts
    // vera_heap_block_free_find::@3
  __b3:
    // block = block->next
    // [1223] vera_heap_block_free_find::block#1 = ((struct vera_heap**)vera_heap_block_free_find::block#2)[OFFSET_STRUCT_VERA_HEAP_NEXT] -- pssz1=qssz1_derefidx_vbuc1 
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
// vera_heap_block_empty_set(struct vera_heap* zp($73) block)
vera_heap_block_empty_set: {
    .label __1 = $6f
    .label __4 = $c3
    .label block = $73
    // (block->size & ~VERA_HEAP_EMPTY) | empty
    // [1225] vera_heap_block_empty_set::$1 = ((word*)vera_heap_block_empty_set::block#2)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_EMPTY -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_EMPTY^$ffff
    sta.z __1
    iny
    lda (block),y
    and #>VERA_HEAP_EMPTY^$ffff
    sta.z __1+1
    // (block->size & ~VERA_HEAP_EMPTY) | empty?VERA_HEAP_EMPTY:0
    // [1226] if(0!=vera_heap_block_empty_set::$1) goto vera_heap_block_empty_set::@1 -- 0_neq_vwuz1_then_la1 
    lda.z __1
    ora.z __1+1
    bne __b1
    // [1228] phi from vera_heap_block_empty_set to vera_heap_block_empty_set::@2 [phi:vera_heap_block_empty_set->vera_heap_block_empty_set::@2]
    // [1228] phi vera_heap_block_empty_set::$4 = 0 [phi:vera_heap_block_empty_set->vera_heap_block_empty_set::@2#0] -- vwuz1=vbuc1 
    lda #<0
    sta.z __4
    sta.z __4+1
    jmp __b2
    // [1227] phi from vera_heap_block_empty_set to vera_heap_block_empty_set::@1 [phi:vera_heap_block_empty_set->vera_heap_block_empty_set::@1]
    // vera_heap_block_empty_set::@1
  __b1:
    // (block->size & ~VERA_HEAP_EMPTY) | empty?VERA_HEAP_EMPTY:0
    // [1228] phi from vera_heap_block_empty_set::@1 to vera_heap_block_empty_set::@2 [phi:vera_heap_block_empty_set::@1->vera_heap_block_empty_set::@2]
    // [1228] phi vera_heap_block_empty_set::$4 = VERA_HEAP_EMPTY [phi:vera_heap_block_empty_set::@1->vera_heap_block_empty_set::@2#0] -- vwuz1=vwuc1 
    lda #<VERA_HEAP_EMPTY
    sta.z __4
    lda #>VERA_HEAP_EMPTY
    sta.z __4+1
    // vera_heap_block_empty_set::@2
  __b2:
    // block->size = (block->size & ~VERA_HEAP_EMPTY) | empty?VERA_HEAP_EMPTY:0
    // [1229] ((word*)vera_heap_block_empty_set::block#2)[OFFSET_STRUCT_VERA_HEAP_SIZE] = vera_heap_block_empty_set::$4 -- pwuz1_derefidx_vbuc1=vwuz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda.z __4
    sta (block),y
    iny
    lda.z __4+1
    sta (block),y
    // vera_heap_block_empty_set::@return
    // }
    // [1230] return 
    rts
}
  // vera_heap_block_address_get
// vera_heap_block_address_get(struct vera_heap* zp($b1) block)
vera_heap_block_address_get: {
    .label __0 = $6f
    .label __9 = $ca
    .label return = $10
    .label block = $b1
    .label __11 = $10
    // block->size & VERA_HEAP_ADDRESS_16
    // [1231] vera_heap_block_address_get::$0 = ((word*)vera_heap_block_address_get::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & VERA_HEAP_ADDRESS_16 -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_ADDRESS_16
    sta.z __0
    iny
    lda (block),y
    and #>VERA_HEAP_ADDRESS_16
    sta.z __0+1
    // (block->size & VERA_HEAP_ADDRESS_16)?0x10000:0x00000
    // [1232] if(0!=vera_heap_block_address_get::$0) goto vera_heap_block_address_get::@1 -- 0_neq_vwuz1_then_la1 
    lda.z __0
    ora.z __0+1
    bne __b1
    // [1234] phi from vera_heap_block_address_get to vera_heap_block_address_get::@2 [phi:vera_heap_block_address_get->vera_heap_block_address_get::@2]
    // [1234] phi vera_heap_block_address_get::$11 = 0 [phi:vera_heap_block_address_get->vera_heap_block_address_get::@2#0] -- vduz1=vbuc1 
    lda #0
    sta.z __11
    sta.z __11+1
    sta.z __11+2
    sta.z __11+3
    jmp __b2
    // [1233] phi from vera_heap_block_address_get to vera_heap_block_address_get::@1 [phi:vera_heap_block_address_get->vera_heap_block_address_get::@1]
    // vera_heap_block_address_get::@1
  __b1:
    // (block->size & VERA_HEAP_ADDRESS_16)?0x10000:0x00000
    // [1234] phi from vera_heap_block_address_get::@1 to vera_heap_block_address_get::@2 [phi:vera_heap_block_address_get::@1->vera_heap_block_address_get::@2]
    // [1234] phi vera_heap_block_address_get::$11 = $10000 [phi:vera_heap_block_address_get::@1->vera_heap_block_address_get::@2#0] -- vduz1=vduc1 
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
    // [1235] vera_heap_block_address_get::$9 = (dword)*((word*)vera_heap_block_address_get::block#0) -- vduz1=_dword__deref_pwuz2 
    ldy #0
    sty.z __9+2
    sty.z __9+3
    lda (block),y
    sta.z __9
    iny
    lda (block),y
    sta.z __9+1
    // [1236] vera_heap_block_address_get::return#0 = vera_heap_block_address_get::$9 | vera_heap_block_address_get::$11 -- vduz1=vduz2_bor_vduz1 
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
    // [1237] return 
    rts
}
  // vera_heap_address
// vera_heap_address(struct vera_heap_segment* zp($6f) segment, dword zp($77) size)
vera_heap_address: {
    .label last_address = $22
    .label next_address = $77
    .label ceil_address = $ca
    .label return = $22
    .label segment = $6f
    .label size = $77
    // last_address = segment->next_address
    // [1238] vera_heap_address::last_address#0 = ((dword*)vera_heap_address::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
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
    // [1239] vera_heap_address::next_address#0 = vera_heap_address::last_address#0 + vera_heap_address::size#0 -- vduz1=vduz2_plus_vduz1 
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
    // [1240] vera_heap_address::ceil_address#0 = ((dword*)vera_heap_address::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
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
    // [1241] if(vera_heap_address::next_address#0<=vera_heap_address::ceil_address#0) goto vera_heap_address::@1 -- vduz1_le_vduz2_then_la1 
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
    // [1243] phi from vera_heap_address to vera_heap_address::@return [phi:vera_heap_address->vera_heap_address::@return]
    // [1243] phi vera_heap_address::return#2 = 0 [phi:vera_heap_address->vera_heap_address::@return#0] -- vduz1=vbuc1 
    lda #0
    sta.z return
    sta.z return+1
    sta.z return+2
    sta.z return+3
    rts
    // vera_heap_address::@1
  __b1:
    // segment->next_address = next_address
    // [1242] ((dword*)vera_heap_address::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS] = vera_heap_address::next_address#0 -- pduz1_derefidx_vbuc1=vduz2 
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
    // [1243] phi from vera_heap_address::@1 to vera_heap_address::@return [phi:vera_heap_address::@1->vera_heap_address::@return]
    // [1243] phi vera_heap_address::return#2 = vera_heap_address::last_address#0 [phi:vera_heap_address::@1->vera_heap_address::@return#0] -- register_copy 
    // vera_heap_address::@return
    // }
    // [1244] return 
    rts
}
  // vera_heap_block_address_set
// vera_heap_block_address_set(struct vera_heap* zp($7d) block)
vera_heap_block_address_set: {
    .label address = vera_heap_malloc.address
    .label __2 = $6f
    .label __3 = $75
    .label __6 = $af
    .label addr = $ca
    .label ad_lo = $6f
    .label ad_hi = $75
    .label block = $7d
    // addr = *address
    // [1245] vera_heap_block_address_set::addr#0 = *vera_heap_block_address_set::address#0 -- vduz1=_deref_pduc1 
    lda.z address
    sta.z addr
    lda.z address+1
    sta.z addr+1
    lda.z address+2
    sta.z addr+2
    lda.z address+3
    sta.z addr+3
    // ad_lo = <(addr)
    // [1246] vera_heap_block_address_set::ad_lo#0 = < vera_heap_block_address_set::addr#0 -- vwuz1=_lo_vduz2 
    lda.z addr
    sta.z ad_lo
    lda.z addr+1
    sta.z ad_lo+1
    // ad_hi = >(addr)
    // [1247] vera_heap_block_address_set::ad_hi#0 = > vera_heap_block_address_set::addr#0 -- vwuz1=_hi_vduz2 
    lda.z addr+2
    sta.z ad_hi
    lda.z addr+3
    sta.z ad_hi+1
    // block->address = ad_lo
    // [1248] *((word*)vera_heap_block_address_set::block#0) = vera_heap_block_address_set::ad_lo#0 -- _deref_pwuz1=vwuz2 
    ldy #0
    lda.z ad_lo
    sta (block),y
    iny
    lda.z ad_lo+1
    sta (block),y
    // block->size & ~VERA_HEAP_ADDRESS_16
    // [1249] vera_heap_block_address_set::$2 = ((word*)vera_heap_block_address_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_ADDRESS_16 -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_ADDRESS_16^$ffff
    sta.z __2
    iny
    lda (block),y
    and #>VERA_HEAP_ADDRESS_16^$ffff
    sta.z __2+1
    // (block->size & ~VERA_HEAP_ADDRESS_16) | ad_hi
    // [1250] vera_heap_block_address_set::$3 = vera_heap_block_address_set::$2 | vera_heap_block_address_set::ad_hi#0 -- vwuz1=vwuz2_bor_vwuz1 
    lda.z __3
    ora.z __2
    sta.z __3
    lda.z __3+1
    ora.z __2+1
    sta.z __3+1
    // (block->size & ~VERA_HEAP_ADDRESS_16) | ad_hi?VERA_HEAP_ADDRESS_16:0
    // [1251] if(0!=vera_heap_block_address_set::$3) goto vera_heap_block_address_set::@1 -- 0_neq_vwuz1_then_la1 
    lda.z __3
    ora.z __3+1
    bne __b1
    // [1253] phi from vera_heap_block_address_set to vera_heap_block_address_set::@2 [phi:vera_heap_block_address_set->vera_heap_block_address_set::@2]
    // [1253] phi vera_heap_block_address_set::$6 = 0 [phi:vera_heap_block_address_set->vera_heap_block_address_set::@2#0] -- vwuz1=vbuc1 
    lda #<0
    sta.z __6
    sta.z __6+1
    jmp __b2
    // [1252] phi from vera_heap_block_address_set to vera_heap_block_address_set::@1 [phi:vera_heap_block_address_set->vera_heap_block_address_set::@1]
    // vera_heap_block_address_set::@1
  __b1:
    // (block->size & ~VERA_HEAP_ADDRESS_16) | ad_hi?VERA_HEAP_ADDRESS_16:0
    // [1253] phi from vera_heap_block_address_set::@1 to vera_heap_block_address_set::@2 [phi:vera_heap_block_address_set::@1->vera_heap_block_address_set::@2]
    // [1253] phi vera_heap_block_address_set::$6 = VERA_HEAP_ADDRESS_16 [phi:vera_heap_block_address_set::@1->vera_heap_block_address_set::@2#0] -- vwuz1=vwuc1 
    lda #<VERA_HEAP_ADDRESS_16
    sta.z __6
    lda #>VERA_HEAP_ADDRESS_16
    sta.z __6+1
    // vera_heap_block_address_set::@2
  __b2:
    // block->size = (block->size & ~VERA_HEAP_ADDRESS_16) | ad_hi?VERA_HEAP_ADDRESS_16:0
    // [1254] ((word*)vera_heap_block_address_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] = vera_heap_block_address_set::$6 -- pwuz1_derefidx_vbuc1=vwuz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda.z __6
    sta (block),y
    iny
    lda.z __6+1
    sta (block),y
    // vera_heap_block_address_set::@return
    // }
    // [1255] return 
    rts
}
  // vera_heap_block_size_set
// vera_heap_block_size_set(struct vera_heap* zp($7d) block)
vera_heap_block_size_set: {
    .label size = vera_heap_malloc.size
    .label __2 = $af
    .label __3 = $75
    .label __4 = $af
    .label __5 = $75
    .label __6 = $6f
    .label __9 = $af
    .label sz = $ca
    .label sz_lo = $75
    .label sz_hi = $6f
    .label block = $7d
    // sz = *size
    // [1256] vera_heap_block_size_set::sz#0 = *vera_heap_block_size_set::size#0 -- vduz1=_deref_pduc1 
    lda.z size
    sta.z sz
    lda.z size+1
    sta.z sz+1
    lda.z size+2
    sta.z sz+2
    lda.z size+3
    sta.z sz+3
    // sz_lo = <sz
    // [1257] vera_heap_block_size_set::sz_lo#0 = < vera_heap_block_size_set::sz#0 -- vwuz1=_lo_vduz2 
    lda.z sz
    sta.z sz_lo
    lda.z sz+1
    sta.z sz_lo+1
    // sz_hi = >sz
    // [1258] vera_heap_block_size_set::sz_hi#0 = > vera_heap_block_size_set::sz#0 -- vwuz1=_hi_vduz2 
    lda.z sz+2
    sta.z sz_hi
    lda.z sz+3
    sta.z sz_hi+1
    // block->size & ~VERA_HEAP_SIZE_MASK
    // [1259] vera_heap_block_size_set::$2 = ((word*)vera_heap_block_size_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_SIZE_MASK -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_SIZE_MASK^$ffff
    sta.z __2
    iny
    lda (block),y
    and #>VERA_HEAP_SIZE_MASK^$ffff
    sta.z __2+1
    // sz_lo & VERA_HEAP_SIZE_MASK
    // [1260] vera_heap_block_size_set::$3 = vera_heap_block_size_set::sz_lo#0 & VERA_HEAP_SIZE_MASK -- vwuz1=vwuz1_band_vwuc1 
    lda.z __3
    and #<VERA_HEAP_SIZE_MASK
    sta.z __3
    lda.z __3+1
    and #>VERA_HEAP_SIZE_MASK
    sta.z __3+1
    // (block->size & ~VERA_HEAP_SIZE_MASK) | sz_lo & VERA_HEAP_SIZE_MASK
    // [1261] vera_heap_block_size_set::$4 = vera_heap_block_size_set::$2 | vera_heap_block_size_set::$3 -- vwuz1=vwuz1_bor_vwuz2 
    lda.z __4
    ora.z __3
    sta.z __4
    lda.z __4+1
    ora.z __3+1
    sta.z __4+1
    // block->size = (block->size & ~VERA_HEAP_SIZE_MASK) | sz_lo & VERA_HEAP_SIZE_MASK
    // [1262] ((word*)vera_heap_block_size_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] = vera_heap_block_size_set::$4 -- pwuz1_derefidx_vbuc1=vwuz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda.z __4
    sta (block),y
    iny
    lda.z __4+1
    sta (block),y
    // block->size & ~VERA_HEAP_SIZE_16
    // [1263] vera_heap_block_size_set::$5 = ((word*)vera_heap_block_size_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_SIZE_16 -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_SIZE_16^$ffff
    sta.z __5
    iny
    lda (block),y
    and #>VERA_HEAP_SIZE_16^$ffff
    sta.z __5+1
    // (block->size & ~VERA_HEAP_SIZE_16) | sz_hi
    // [1264] vera_heap_block_size_set::$6 = vera_heap_block_size_set::$5 | vera_heap_block_size_set::sz_hi#0 -- vwuz1=vwuz2_bor_vwuz1 
    lda.z __6
    ora.z __5
    sta.z __6
    lda.z __6+1
    ora.z __5+1
    sta.z __6+1
    // (block->size & ~VERA_HEAP_SIZE_16) | sz_hi?VERA_HEAP_SIZE_16:0
    // [1265] if(0!=vera_heap_block_size_set::$6) goto vera_heap_block_size_set::@1 -- 0_neq_vwuz1_then_la1 
    lda.z __6
    ora.z __6+1
    bne __b1
    // [1267] phi from vera_heap_block_size_set to vera_heap_block_size_set::@2 [phi:vera_heap_block_size_set->vera_heap_block_size_set::@2]
    // [1267] phi vera_heap_block_size_set::$9 = 0 [phi:vera_heap_block_size_set->vera_heap_block_size_set::@2#0] -- vwuz1=vbuc1 
    lda #<0
    sta.z __9
    sta.z __9+1
    jmp __b2
    // [1266] phi from vera_heap_block_size_set to vera_heap_block_size_set::@1 [phi:vera_heap_block_size_set->vera_heap_block_size_set::@1]
    // vera_heap_block_size_set::@1
  __b1:
    // (block->size & ~VERA_HEAP_SIZE_16) | sz_hi?VERA_HEAP_SIZE_16:0
    // [1267] phi from vera_heap_block_size_set::@1 to vera_heap_block_size_set::@2 [phi:vera_heap_block_size_set::@1->vera_heap_block_size_set::@2]
    // [1267] phi vera_heap_block_size_set::$9 = VERA_HEAP_SIZE_16 [phi:vera_heap_block_size_set::@1->vera_heap_block_size_set::@2#0] -- vwuz1=vwuc1 
    lda #<VERA_HEAP_SIZE_16
    sta.z __9
    lda #>VERA_HEAP_SIZE_16
    sta.z __9+1
    // vera_heap_block_size_set::@2
  __b2:
    // block->size = (block->size & ~VERA_HEAP_SIZE_16) | sz_hi?VERA_HEAP_SIZE_16:0
    // [1268] ((word*)vera_heap_block_size_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] = vera_heap_block_size_set::$9 -- pwuz1_derefidx_vbuc1=vwuz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda.z __9
    sta (block),y
    iny
    lda.z __9+1
    sta (block),y
    // vera_heap_block_size_set::@return
    // }
    // [1269] return 
    rts
}
  // vera_layer_set_config
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
// vera_layer_set_config(byte zp($59) layer, byte zp($e) config)
vera_layer_set_config: {
    .label __0 = $58
    .label addr = $5b
    .label layer = $59
    .label config = $e
    // addr = vera_layer_config[layer]
    // [1270] vera_layer_set_config::$0 = vera_layer_set_config::layer#0 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z layer
    asl
    sta.z __0
    // [1271] vera_layer_set_config::addr#0 = vera_layer_config[vera_layer_set_config::$0] -- pbuz1=qbuc1_derefidx_vbuz2 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr = config
    // [1272] *vera_layer_set_config::addr#0 = vera_layer_set_config::config#0 -- _deref_pbuz1=vbuz2 
    lda.z config
    ldy #0
    sta (addr),y
    // vera_layer_set_config::@return
    // }
    // [1273] return 
    rts
}
  // vera_layer_set_tilebase
// Set the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - tilebase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// vera_layer_set_tilebase(byte zp($59) layer, byte zp($e) tilebase)
vera_layer_set_tilebase: {
    .label __0 = $59
    .label addr = $5b
    .label layer = $59
    .label tilebase = $e
    // addr = vera_layer_tilebase[layer]
    // [1274] vera_layer_set_tilebase::$0 = vera_layer_set_tilebase::layer#0 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __0
    // [1275] vera_layer_set_tilebase::addr#0 = vera_layer_tilebase[vera_layer_set_tilebase::$0] -- pbuz1=qbuc1_derefidx_vbuz2 
    ldy.z __0
    lda vera_layer_tilebase,y
    sta.z addr
    lda vera_layer_tilebase+1,y
    sta.z addr+1
    // *addr = tilebase
    // [1276] *vera_layer_set_tilebase::addr#0 = vera_layer_set_tilebase::tilebase#0 -- _deref_pbuz1=vbuz2 
    lda.z tilebase
    ldy #0
    sta (addr),y
    // vera_layer_set_tilebase::@return
    // }
    // [1277] return 
    rts
}
  // vera_layer_get_backcolor
// Get the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_get_backcolor(byte zp($b3) layer)
vera_layer_get_backcolor: {
    .label return = $b3
    .label layer = $b3
    // return vera_layer_backcolor[layer];
    // [1278] vera_layer_get_backcolor::return#0 = vera_layer_backcolor[vera_layer_get_backcolor::layer#0] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_backcolor,y
    sta.z return
    // vera_layer_get_backcolor::@return
    // }
    // [1279] return 
    rts
}
  // vera_layer_get_textcolor
// Get the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_get_textcolor(byte zp($b4) layer)
vera_layer_get_textcolor: {
    .label return = $b4
    .label layer = $b4
    // return vera_layer_textcolor[layer];
    // [1280] vera_layer_get_textcolor::return#0 = vera_layer_textcolor[vera_layer_get_textcolor::layer#0] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_textcolor,y
    sta.z return
    // vera_layer_get_textcolor::@return
    // }
    // [1281] return 
    rts
}
  // printf_ulong
// Print an unsigned int using a specific format
// printf_ulong(dword zp($26) uvalue)
printf_ulong: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
    .label uvalue = $26
    // printf_ulong::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [1283] *((byte*)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format.radix)
    // [1284] ultoa::value#1 = printf_ulong::uvalue#0
    // [1285] call ultoa 
  // Format number into buffer
    // [1509] phi from printf_ulong::@1 to ultoa [phi:printf_ulong::@1->ultoa]
    jsr ultoa
    // printf_ulong::@2
    // printf_number_buffer(printf_buffer, format)
    // [1286] printf_number_buffer::buffer_sign#0 = *((byte*)&printf_buffer) -- vbuz1=_deref_pbuc1 
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
    // [1287] call printf_number_buffer 
  // Print using format
    // [1171] phi from printf_ulong::@2 to printf_number_buffer [phi:printf_ulong::@2->printf_number_buffer]
    // [1171] phi printf_number_buffer::format_upper_case#10 = printf_ulong::format_upper_case#0 [phi:printf_ulong::@2->printf_number_buffer#0] -- vbuz1=vbuc1 
    lda #format_upper_case
    sta.z printf_number_buffer.format_upper_case
    // [1171] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#0 [phi:printf_ulong::@2->printf_number_buffer#1] -- register_copy 
    // [1171] phi printf_number_buffer::format_zero_padding#10 = printf_ulong::format_zero_padding#0 [phi:printf_ulong::@2->printf_number_buffer#2] -- vbuz1=vbuc1 
    lda #format_zero_padding
    sta.z printf_number_buffer.format_zero_padding
    // [1171] phi printf_number_buffer::format_justify_left#10 = printf_ulong::format_justify_left#0 [phi:printf_ulong::@2->printf_number_buffer#3] -- vbuz1=vbuc1 
    lda #format_justify_left
    sta.z printf_number_buffer.format_justify_left
    // [1171] phi printf_number_buffer::format_min_length#2 = printf_ulong::format_min_length#0 [phi:printf_ulong::@2->printf_number_buffer#4] -- vbuz1=vbuc1 
    lda #format_min_length
    sta.z printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // printf_ulong::@return
    // }
    // [1288] return 
    rts
}
  // mul16u
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// mul16u(word zp($c3) a, word zp($b1) b)
mul16u: {
    .label __1 = $f
    .label mb = $6b
    .label a = $c3
    .label res = $3c
    .label return = $3c
    .label b = $b1
    // mb = b
    // [1290] mul16u::mb#0 = (dword)mul16u::b#2 -- vduz1=_dword_vwuz2 
    lda.z b
    sta.z mb
    lda.z b+1
    sta.z mb+1
    lda #0
    sta.z mb+2
    sta.z mb+3
    // [1291] phi from mul16u to mul16u::@1 [phi:mul16u->mul16u::@1]
    // [1291] phi mul16u::mb#2 = mul16u::mb#0 [phi:mul16u->mul16u::@1#0] -- register_copy 
    // [1291] phi mul16u::res#2 = 0 [phi:mul16u->mul16u::@1#1] -- vduz1=vduc1 
    sta.z res
    sta.z res+1
    lda #<0>>$10
    sta.z res+2
    lda #>0>>$10
    sta.z res+3
    // [1291] phi mul16u::a#3 = mul16u::a#6 [phi:mul16u->mul16u::@1#2] -- register_copy 
    // mul16u::@1
  __b1:
    // while(a!=0)
    // [1292] if(mul16u::a#3!=0) goto mul16u::@2 -- vwuz1_neq_0_then_la1 
    lda.z a
    ora.z a+1
    bne __b2
    // mul16u::@return
    // }
    // [1293] return 
    rts
    // mul16u::@2
  __b2:
    // a&1
    // [1294] mul16u::$1 = mul16u::a#3 & 1 -- vbuz1=vwuz2_band_vbuc1 
    lda #1
    and.z a
    sta.z __1
    // if( (a&1) != 0)
    // [1295] if(mul16u::$1==0) goto mul16u::@3 -- vbuz1_eq_0_then_la1 
    cmp #0
    beq __b3
    // mul16u::@4
    // res = res + mb
    // [1296] mul16u::res#1 = mul16u::res#2 + mul16u::mb#2 -- vduz1=vduz1_plus_vduz2 
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
    // [1297] phi from mul16u::@2 mul16u::@4 to mul16u::@3 [phi:mul16u::@2/mul16u::@4->mul16u::@3]
    // [1297] phi mul16u::res#6 = mul16u::res#2 [phi:mul16u::@2/mul16u::@4->mul16u::@3#0] -- register_copy 
    // mul16u::@3
  __b3:
    // a = a>>1
    // [1298] mul16u::a#0 = mul16u::a#3 >> 1 -- vwuz1=vwuz1_ror_1 
    lsr.z a+1
    ror.z a
    // mb = mb<<1
    // [1299] mul16u::mb#1 = mul16u::mb#2 << 1 -- vduz1=vduz1_rol_1 
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    // [1291] phi from mul16u::@3 to mul16u::@1 [phi:mul16u::@3->mul16u::@1]
    // [1291] phi mul16u::mb#2 = mul16u::mb#1 [phi:mul16u::@3->mul16u::@1#0] -- register_copy 
    // [1291] phi mul16u::res#2 = mul16u::res#6 [phi:mul16u::@3->mul16u::@1#1] -- register_copy 
    // [1291] phi mul16u::a#3 = mul16u::a#0 [phi:mul16u::@3->mul16u::@1#2] -- register_copy 
    jmp __b1
}
  // vera_sprite_width
// vera_sprite_width(byte zp($b9) sprite, byte zp($ba) width)
vera_sprite_width: {
    .label vera_sprite_width_81___3 = $b9
    .label vera_sprite_width_81___4 = $75
    .label vera_sprite_width_81___5 = $b9
    .label vera_sprite_width_81___7 = $f
    .label vera_sprite_width_81___8 = $75
    .label vera_sprite_width_161___3 = $c7
    .label vera_sprite_width_161___4 = $75
    .label vera_sprite_width_161___5 = $c7
    .label vera_sprite_width_161___6 = $c7
    .label vera_sprite_width_161___7 = $c7
    .label vera_sprite_width_161___8 = $75
    .label vera_sprite_width_321___3 = $d2
    .label vera_sprite_width_321___4 = $75
    .label vera_sprite_width_321___5 = $b9
    .label vera_sprite_width_321___6 = $b9
    .label vera_sprite_width_321___7 = $b9
    .label vera_sprite_width_321___8 = $75
    .label vera_sprite_width_641___3 = $f
    .label vera_sprite_width_641___4 = $af
    .label vera_sprite_width_641___5 = $ba
    .label vera_sprite_width_641___6 = $c7
    .label vera_sprite_width_641___7 = $c7
    .label vera_sprite_width_641___8 = $af
    .label vera_sprite_width_81_sprite_offset = $75
    .label vera_sprite_width_161_sprite_offset = $75
    .label vera_sprite_width_321_sprite_offset = $75
    .label vera_sprite_width_641_sprite_offset = $af
    .label sprite = $b9
    .label width = $ba
    // case 8:
    //             vera_sprite_width_8(sprite);
    //             break;
    // [1300] if(vera_sprite_width::width#0==8) goto vera_sprite_width::vera_sprite_width_81 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z width
    bne !vera_sprite_width_81+
    jmp vera_sprite_width_81
  !vera_sprite_width_81:
    // vera_sprite_width::@1
    // case 16:
    //             vera_sprite_width_16(sprite);
    //             break;
    // [1301] if(vera_sprite_width::width#0==$10) goto vera_sprite_width::vera_sprite_width_161 -- vbuz1_eq_vbuc1_then_la1 
    lda #$10
    cmp.z width
    bne !vera_sprite_width_161+
    jmp vera_sprite_width_161
  !vera_sprite_width_161:
    // vera_sprite_width::@2
    // case 32:
    //             vera_sprite_width_32(sprite);
    //             break;
    // [1302] if(vera_sprite_width::width#0==$20) goto vera_sprite_width::vera_sprite_width_321 -- vbuz1_eq_vbuc1_then_la1 
    lda #$20
    cmp.z width
    beq vera_sprite_width_321
    // vera_sprite_width::@3
    // case 64:
    //             vera_sprite_width_64(sprite);
    //             break;
    // [1303] if(vera_sprite_width::width#0==$40) goto vera_sprite_width::vera_sprite_width_641 -- vbuz1_eq_vbuc1_then_la1 
    lda #$40
    cmp.z width
    beq vera_sprite_width_641
    rts
    // vera_sprite_width::vera_sprite_width_641
  vera_sprite_width_641:
    // (word)sprite << 3
    // [1304] vera_sprite_width::vera_sprite_width_641_$8 = (word)vera_sprite_width::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_width_641___8
    lda #0
    sta.z vera_sprite_width_641___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1305] vera_sprite_width::vera_sprite_width_641_sprite_offset#0 = vera_sprite_width::vera_sprite_width_641_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_width_641_sprite_offset
    rol.z vera_sprite_width_641_sprite_offset+1
    asl.z vera_sprite_width_641_sprite_offset
    rol.z vera_sprite_width_641_sprite_offset+1
    asl.z vera_sprite_width_641_sprite_offset
    rol.z vera_sprite_width_641_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1306] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1307] vera_sprite_width::vera_sprite_width_641_$4 = vera_sprite_width::vera_sprite_width_641_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_width_641___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_641___4
    lda.z vera_sprite_width_641___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_641___4+1
    // <sprite_offset+7
    // [1308] vera_sprite_width::vera_sprite_width_641_$3 = < vera_sprite_width::vera_sprite_width_641_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_width_641___4
    sta.z vera_sprite_width_641___3
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1309] *VERA_ADDRX_L = vera_sprite_width::vera_sprite_width_641_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1310] vera_sprite_width::vera_sprite_width_641_$5 = > vera_sprite_width::vera_sprite_width_641_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_width_641___4+1
    sta.z vera_sprite_width_641___5
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1311] *VERA_ADDRX_M = vera_sprite_width::vera_sprite_width_641_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1312] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [1313] vera_sprite_width::vera_sprite_width_641_$6 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_WIDTH_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_width_641___6
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_64
    // [1314] vera_sprite_width::vera_sprite_width_641_$7 = vera_sprite_width::vera_sprite_width_641_$6 | VERA_SPRITE_WIDTH_64 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_SPRITE_WIDTH_64
    ora.z vera_sprite_width_641___7
    sta.z vera_sprite_width_641___7
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_64
    // [1315] *VERA_DATA0 = vera_sprite_width::vera_sprite_width_641_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // vera_sprite_width::@return
    // }
    // [1316] return 
    rts
    // vera_sprite_width::vera_sprite_width_321
  vera_sprite_width_321:
    // (word)sprite << 3
    // [1317] vera_sprite_width::vera_sprite_width_321_$8 = (word)vera_sprite_width::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_width_321___8
    lda #0
    sta.z vera_sprite_width_321___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1318] vera_sprite_width::vera_sprite_width_321_sprite_offset#0 = vera_sprite_width::vera_sprite_width_321_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_width_321_sprite_offset
    rol.z vera_sprite_width_321_sprite_offset+1
    asl.z vera_sprite_width_321_sprite_offset
    rol.z vera_sprite_width_321_sprite_offset+1
    asl.z vera_sprite_width_321_sprite_offset
    rol.z vera_sprite_width_321_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1319] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1320] vera_sprite_width::vera_sprite_width_321_$4 = vera_sprite_width::vera_sprite_width_321_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_width_321___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_321___4
    lda.z vera_sprite_width_321___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_321___4+1
    // <sprite_offset+7
    // [1321] vera_sprite_width::vera_sprite_width_321_$3 = < vera_sprite_width::vera_sprite_width_321_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_width_321___4
    sta.z vera_sprite_width_321___3
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1322] *VERA_ADDRX_L = vera_sprite_width::vera_sprite_width_321_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1323] vera_sprite_width::vera_sprite_width_321_$5 = > vera_sprite_width::vera_sprite_width_321_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_width_321___4+1
    sta.z vera_sprite_width_321___5
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1324] *VERA_ADDRX_M = vera_sprite_width::vera_sprite_width_321_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1325] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [1326] vera_sprite_width::vera_sprite_width_321_$6 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_WIDTH_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_width_321___6
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_32
    // [1327] vera_sprite_width::vera_sprite_width_321_$7 = vera_sprite_width::vera_sprite_width_321_$6 | VERA_SPRITE_WIDTH_32 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_SPRITE_WIDTH_32
    ora.z vera_sprite_width_321___7
    sta.z vera_sprite_width_321___7
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_32
    // [1328] *VERA_DATA0 = vera_sprite_width::vera_sprite_width_321_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    rts
    // vera_sprite_width::vera_sprite_width_161
  vera_sprite_width_161:
    // (word)sprite << 3
    // [1329] vera_sprite_width::vera_sprite_width_161_$8 = (word)vera_sprite_width::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_width_161___8
    lda #0
    sta.z vera_sprite_width_161___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1330] vera_sprite_width::vera_sprite_width_161_sprite_offset#0 = vera_sprite_width::vera_sprite_width_161_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_width_161_sprite_offset
    rol.z vera_sprite_width_161_sprite_offset+1
    asl.z vera_sprite_width_161_sprite_offset
    rol.z vera_sprite_width_161_sprite_offset+1
    asl.z vera_sprite_width_161_sprite_offset
    rol.z vera_sprite_width_161_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1331] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1332] vera_sprite_width::vera_sprite_width_161_$4 = vera_sprite_width::vera_sprite_width_161_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_width_161___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_161___4
    lda.z vera_sprite_width_161___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_161___4+1
    // <sprite_offset+7
    // [1333] vera_sprite_width::vera_sprite_width_161_$3 = < vera_sprite_width::vera_sprite_width_161_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_width_161___4
    sta.z vera_sprite_width_161___3
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1334] *VERA_ADDRX_L = vera_sprite_width::vera_sprite_width_161_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1335] vera_sprite_width::vera_sprite_width_161_$5 = > vera_sprite_width::vera_sprite_width_161_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_width_161___4+1
    sta.z vera_sprite_width_161___5
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1336] *VERA_ADDRX_M = vera_sprite_width::vera_sprite_width_161_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1337] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [1338] vera_sprite_width::vera_sprite_width_161_$6 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_WIDTH_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_width_161___6
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_16
    // [1339] vera_sprite_width::vera_sprite_width_161_$7 = vera_sprite_width::vera_sprite_width_161_$6 | VERA_SPRITE_WIDTH_16 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_SPRITE_WIDTH_16
    ora.z vera_sprite_width_161___7
    sta.z vera_sprite_width_161___7
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_16
    // [1340] *VERA_DATA0 = vera_sprite_width::vera_sprite_width_161_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    rts
    // vera_sprite_width::vera_sprite_width_81
  vera_sprite_width_81:
    // (word)sprite << 3
    // [1341] vera_sprite_width::vera_sprite_width_81_$8 = (word)vera_sprite_width::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_width_81___8
    lda #0
    sta.z vera_sprite_width_81___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1342] vera_sprite_width::vera_sprite_width_81_sprite_offset#0 = vera_sprite_width::vera_sprite_width_81_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_width_81_sprite_offset
    rol.z vera_sprite_width_81_sprite_offset+1
    asl.z vera_sprite_width_81_sprite_offset
    rol.z vera_sprite_width_81_sprite_offset+1
    asl.z vera_sprite_width_81_sprite_offset
    rol.z vera_sprite_width_81_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1343] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1344] vera_sprite_width::vera_sprite_width_81_$4 = vera_sprite_width::vera_sprite_width_81_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_width_81___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_81___4
    lda.z vera_sprite_width_81___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_81___4+1
    // <sprite_offset+7
    // [1345] vera_sprite_width::vera_sprite_width_81_$3 = < vera_sprite_width::vera_sprite_width_81_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_width_81___4
    sta.z vera_sprite_width_81___3
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1346] *VERA_ADDRX_L = vera_sprite_width::vera_sprite_width_81_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1347] vera_sprite_width::vera_sprite_width_81_$5 = > vera_sprite_width::vera_sprite_width_81_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_width_81___4+1
    sta.z vera_sprite_width_81___5
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1348] *VERA_ADDRX_M = vera_sprite_width::vera_sprite_width_81_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1349] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_8
    // [1350] vera_sprite_width::vera_sprite_width_81_$7 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_WIDTH_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_width_81___7
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_8
    // [1351] *VERA_DATA0 = vera_sprite_width::vera_sprite_width_81_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    rts
}
  // vera_sprite_zdepth
// vera_sprite_zdepth(byte zp($b9) sprite, byte zp($ba) zdepth)
vera_sprite_zdepth: {
    .label vera_sprite_zdepth_in_front1___3 = $b9
    .label vera_sprite_zdepth_in_front1___4 = $75
    .label vera_sprite_zdepth_in_front1___5 = $b9
    .label vera_sprite_zdepth_in_front1___6 = $f
    .label vera_sprite_zdepth_in_front1___7 = $f
    .label vera_sprite_zdepth_in_front1___8 = $75
    .label vera_sprite_zdepth_between_layer0_and_layer11___3 = $c7
    .label vera_sprite_zdepth_between_layer0_and_layer11___4 = $af
    .label vera_sprite_zdepth_between_layer0_and_layer11___5 = $c7
    .label vera_sprite_zdepth_between_layer0_and_layer11___6 = $c7
    .label vera_sprite_zdepth_between_layer0_and_layer11___7 = $c7
    .label vera_sprite_zdepth_between_layer0_and_layer11___8 = $af
    .label vera_sprite_zdepth_between_background_and_layer01___3 = $d2
    .label vera_sprite_zdepth_between_background_and_layer01___4 = $75
    .label vera_sprite_zdepth_between_background_and_layer01___5 = $b9
    .label vera_sprite_zdepth_between_background_and_layer01___6 = $b9
    .label vera_sprite_zdepth_between_background_and_layer01___7 = $b9
    .label vera_sprite_zdepth_between_background_and_layer01___8 = $75
    .label vera_sprite_zdepth_disable1___3 = $f
    .label vera_sprite_zdepth_disable1___4 = $75
    .label vera_sprite_zdepth_disable1___5 = $ba
    .label vera_sprite_zdepth_disable1___6 = $c7
    .label vera_sprite_zdepth_disable1___7 = $75
    .label vera_sprite_zdepth_in_front1_sprite_offset = $75
    .label vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset = $af
    .label vera_sprite_zdepth_between_background_and_layer01_sprite_offset = $75
    .label vera_sprite_zdepth_disable1_sprite_offset = $75
    .label sprite = $b9
    .label zdepth = $ba
    // case 3:
    //             vera_sprite_zdepth_in_front(sprite);
    //             break;
    // [1352] if(vera_sprite_zdepth::zdepth#0==3) goto vera_sprite_zdepth::vera_sprite_zdepth_in_front1 -- vbuz1_eq_vbuc1_then_la1 
    lda #3
    cmp.z zdepth
    bne !vera_sprite_zdepth_in_front1+
    jmp vera_sprite_zdepth_in_front1
  !vera_sprite_zdepth_in_front1:
    // vera_sprite_zdepth::@1
    // case 2:
    //             vera_sprite_zdepth_between_layer0_and_layer1(sprite);
    //             break;
    // [1353] if(vera_sprite_zdepth::zdepth#0==2) goto vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11 -- vbuz1_eq_vbuc1_then_la1 
    lda #2
    cmp.z zdepth
    bne !vera_sprite_zdepth_between_layer0_and_layer11+
    jmp vera_sprite_zdepth_between_layer0_and_layer11
  !vera_sprite_zdepth_between_layer0_and_layer11:
    // vera_sprite_zdepth::@2
    // case 1:
    //             vera_sprite_zdepth_between_background_and_layer0(sprite);
    //             break;
    // [1354] if(vera_sprite_zdepth::zdepth#0==1) goto vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01 -- vbuz1_eq_vbuc1_then_la1 
    lda #1
    cmp.z zdepth
    beq vera_sprite_zdepth_between_background_and_layer01
    // vera_sprite_zdepth::@3
    // case 0:
    //             vera_sprite_zdepth_disable(sprite);
    //             break;
    // [1355] if(vera_sprite_zdepth::zdepth#0==0) goto vera_sprite_zdepth::vera_sprite_zdepth_disable1 -- vbuz1_eq_0_then_la1 
    lda.z zdepth
    cmp #0
    beq vera_sprite_zdepth_disable1
    rts
    // vera_sprite_zdepth::vera_sprite_zdepth_disable1
  vera_sprite_zdepth_disable1:
    // (word)sprite << 3
    // [1356] vera_sprite_zdepth::vera_sprite_zdepth_disable1_$7 = (word)vera_sprite_zdepth::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_zdepth_disable1___7
    lda #0
    sta.z vera_sprite_zdepth_disable1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1357] vera_sprite_zdepth::vera_sprite_zdepth_disable1_sprite_offset#0 = vera_sprite_zdepth::vera_sprite_zdepth_disable1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_zdepth_disable1_sprite_offset
    rol.z vera_sprite_zdepth_disable1_sprite_offset+1
    asl.z vera_sprite_zdepth_disable1_sprite_offset
    rol.z vera_sprite_zdepth_disable1_sprite_offset+1
    asl.z vera_sprite_zdepth_disable1_sprite_offset
    rol.z vera_sprite_zdepth_disable1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1358] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1359] vera_sprite_zdepth::vera_sprite_zdepth_disable1_$4 = vera_sprite_zdepth::vera_sprite_zdepth_disable1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_zdepth_disable1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_disable1___4
    lda.z vera_sprite_zdepth_disable1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_disable1___4+1
    // <sprite_offset+6
    // [1360] vera_sprite_zdepth::vera_sprite_zdepth_disable1_$3 = < vera_sprite_zdepth::vera_sprite_zdepth_disable1_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_zdepth_disable1___4
    sta.z vera_sprite_zdepth_disable1___3
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1361] *VERA_ADDRX_L = vera_sprite_zdepth::vera_sprite_zdepth_disable1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1362] vera_sprite_zdepth::vera_sprite_zdepth_disable1_$5 = > vera_sprite_zdepth::vera_sprite_zdepth_disable1_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_zdepth_disable1___4+1
    sta.z vera_sprite_zdepth_disable1___5
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1363] *VERA_ADDRX_M = vera_sprite_zdepth::vera_sprite_zdepth_disable1_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1364] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [1365] vera_sprite_zdepth::vera_sprite_zdepth_disable1_$6 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_ZDEPTH_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_zdepth_disable1___6
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [1366] *VERA_DATA0 = vera_sprite_zdepth::vera_sprite_zdepth_disable1_$6 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // vera_sprite_zdepth::@return
    // }
    // [1367] return 
    rts
    // vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01
  vera_sprite_zdepth_between_background_and_layer01:
    // (word)sprite << 3
    // [1368] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$8 = (word)vera_sprite_zdepth::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_zdepth_between_background_and_layer01___8
    lda #0
    sta.z vera_sprite_zdepth_between_background_and_layer01___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1369] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_sprite_offset#0 = vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_zdepth_between_background_and_layer01_sprite_offset
    rol.z vera_sprite_zdepth_between_background_and_layer01_sprite_offset+1
    asl.z vera_sprite_zdepth_between_background_and_layer01_sprite_offset
    rol.z vera_sprite_zdepth_between_background_and_layer01_sprite_offset+1
    asl.z vera_sprite_zdepth_between_background_and_layer01_sprite_offset
    rol.z vera_sprite_zdepth_between_background_and_layer01_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1370] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1371] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$4 = vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_zdepth_between_background_and_layer01___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_between_background_and_layer01___4
    lda.z vera_sprite_zdepth_between_background_and_layer01___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_between_background_and_layer01___4+1
    // <sprite_offset+6
    // [1372] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$3 = < vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_zdepth_between_background_and_layer01___4
    sta.z vera_sprite_zdepth_between_background_and_layer01___3
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1373] *VERA_ADDRX_L = vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1374] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$5 = > vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_zdepth_between_background_and_layer01___4+1
    sta.z vera_sprite_zdepth_between_background_and_layer01___5
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1375] *VERA_ADDRX_M = vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1376] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [1377] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$6 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_ZDEPTH_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_zdepth_between_background_and_layer01___6
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0
    // [1378] vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$7 = vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$6 | VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0
    ora.z vera_sprite_zdepth_between_background_and_layer01___7
    sta.z vera_sprite_zdepth_between_background_and_layer01___7
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0
    // [1379] *VERA_DATA0 = vera_sprite_zdepth::vera_sprite_zdepth_between_background_and_layer01_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    rts
    // vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11
  vera_sprite_zdepth_between_layer0_and_layer11:
    // (word)sprite << 3
    // [1380] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$8 = (word)vera_sprite_zdepth::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_zdepth_between_layer0_and_layer11___8
    lda #0
    sta.z vera_sprite_zdepth_between_layer0_and_layer11___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1381] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset#0 = vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset
    rol.z vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset+1
    asl.z vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset
    rol.z vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset+1
    asl.z vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset
    rol.z vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1382] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1383] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$4 = vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_zdepth_between_layer0_and_layer11___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_between_layer0_and_layer11___4
    lda.z vera_sprite_zdepth_between_layer0_and_layer11___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_between_layer0_and_layer11___4+1
    // <sprite_offset+6
    // [1384] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$3 = < vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_zdepth_between_layer0_and_layer11___4
    sta.z vera_sprite_zdepth_between_layer0_and_layer11___3
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1385] *VERA_ADDRX_L = vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1386] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$5 = > vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_zdepth_between_layer0_and_layer11___4+1
    sta.z vera_sprite_zdepth_between_layer0_and_layer11___5
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1387] *VERA_ADDRX_M = vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1388] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [1389] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$6 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_ZDEPTH_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_zdepth_between_layer0_and_layer11___6
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1
    // [1390] vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$7 = vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$6 | VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1 -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1
    ora.z vera_sprite_zdepth_between_layer0_and_layer11___7
    sta.z vera_sprite_zdepth_between_layer0_and_layer11___7
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1
    // [1391] *VERA_DATA0 = vera_sprite_zdepth::vera_sprite_zdepth_between_layer0_and_layer11_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    rts
    // vera_sprite_zdepth::vera_sprite_zdepth_in_front1
  vera_sprite_zdepth_in_front1:
    // (word)sprite << 3
    // [1392] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$8 = (word)vera_sprite_zdepth::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_zdepth_in_front1___8
    lda #0
    sta.z vera_sprite_zdepth_in_front1___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1393] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_sprite_offset#0 = vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_zdepth_in_front1_sprite_offset
    rol.z vera_sprite_zdepth_in_front1_sprite_offset+1
    asl.z vera_sprite_zdepth_in_front1_sprite_offset
    rol.z vera_sprite_zdepth_in_front1_sprite_offset+1
    asl.z vera_sprite_zdepth_in_front1_sprite_offset
    rol.z vera_sprite_zdepth_in_front1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1394] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1395] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$4 = vera_sprite_zdepth::vera_sprite_zdepth_in_front1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_zdepth_in_front1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_in_front1___4
    lda.z vera_sprite_zdepth_in_front1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_in_front1___4+1
    // <sprite_offset+6
    // [1396] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$3 = < vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_zdepth_in_front1___4
    sta.z vera_sprite_zdepth_in_front1___3
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1397] *VERA_ADDRX_L = vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1398] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$5 = > vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_zdepth_in_front1___4+1
    sta.z vera_sprite_zdepth_in_front1___5
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1399] *VERA_ADDRX_M = vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1400] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [1401] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$6 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_ZDEPTH_MASK^$ff
    and VERA_DATA0
    sta.z vera_sprite_zdepth_in_front1___6
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_IN_FRONT
    // [1402] vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$7 = vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$6 | VERA_SPRITE_ZDEPTH_IN_FRONT -- vbuz1=vbuz1_bor_vbuc1 
    lda #VERA_SPRITE_ZDEPTH_IN_FRONT
    ora.z vera_sprite_zdepth_in_front1___7
    sta.z vera_sprite_zdepth_in_front1___7
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_IN_FRONT
    // [1403] *VERA_DATA0 = vera_sprite_zdepth::vera_sprite_zdepth_in_front1_$7 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    rts
}
  // vera_sprite_hflip
// vera_sprite_hflip(byte zp($b9) sprite, byte zp($ba) hflip)
vera_sprite_hflip: {
    .label vera_sprite_hflip_on1___3 = $d2
    .label vera_sprite_hflip_on1___4 = $75
    .label vera_sprite_hflip_on1___5 = $b9
    .label vera_sprite_hflip_on1___6 = $b9
    .label vera_sprite_hflip_on1___7 = $75
    .label vera_sprite_hflip_off1___3 = $f
    .label vera_sprite_hflip_off1___4 = $af
    .label vera_sprite_hflip_off1___5 = $ba
    .label vera_sprite_hflip_off1___6 = $c7
    .label vera_sprite_hflip_off1___7 = $af
    .label vera_sprite_hflip_on1_sprite_offset = $75
    .label vera_sprite_hflip_off1_sprite_offset = $af
    .label sprite = $b9
    .label hflip = $ba
    // if(hflip)
    // [1404] if(0!=vera_sprite_hflip::hflip#0) goto vera_sprite_hflip::vera_sprite_hflip_on1 -- 0_neq_vbuz1_then_la1 
    lda.z hflip
    cmp #0
    bne vera_sprite_hflip_on1
    // vera_sprite_hflip::vera_sprite_hflip_off1
    // (word)sprite << 3
    // [1405] vera_sprite_hflip::vera_sprite_hflip_off1_$7 = (word)vera_sprite_hflip::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_hflip_off1___7
    lda #0
    sta.z vera_sprite_hflip_off1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1406] vera_sprite_hflip::vera_sprite_hflip_off1_sprite_offset#0 = vera_sprite_hflip::vera_sprite_hflip_off1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_hflip_off1_sprite_offset
    rol.z vera_sprite_hflip_off1_sprite_offset+1
    asl.z vera_sprite_hflip_off1_sprite_offset
    rol.z vera_sprite_hflip_off1_sprite_offset+1
    asl.z vera_sprite_hflip_off1_sprite_offset
    rol.z vera_sprite_hflip_off1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1407] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1408] vera_sprite_hflip::vera_sprite_hflip_off1_$4 = vera_sprite_hflip::vera_sprite_hflip_off1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_hflip_off1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_hflip_off1___4
    lda.z vera_sprite_hflip_off1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_hflip_off1___4+1
    // <sprite_offset+6
    // [1409] vera_sprite_hflip::vera_sprite_hflip_off1_$3 = < vera_sprite_hflip::vera_sprite_hflip_off1_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_hflip_off1___4
    sta.z vera_sprite_hflip_off1___3
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1410] *VERA_ADDRX_L = vera_sprite_hflip::vera_sprite_hflip_off1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1411] vera_sprite_hflip::vera_sprite_hflip_off1_$5 = > vera_sprite_hflip::vera_sprite_hflip_off1_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_hflip_off1___4+1
    sta.z vera_sprite_hflip_off1___5
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1412] *VERA_ADDRX_M = vera_sprite_hflip::vera_sprite_hflip_off1_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1413] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HFLIP
    // [1414] vera_sprite_hflip::vera_sprite_hflip_off1_$6 = *VERA_DATA0 & ~VERA_SPRITE_HFLIP -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HFLIP^$ff
    and VERA_DATA0
    sta.z vera_sprite_hflip_off1___6
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HFLIP
    // [1415] *VERA_DATA0 = vera_sprite_hflip::vera_sprite_hflip_off1_$6 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // vera_sprite_hflip::@return
    // }
    // [1416] return 
    rts
    // vera_sprite_hflip::vera_sprite_hflip_on1
  vera_sprite_hflip_on1:
    // (word)sprite << 3
    // [1417] vera_sprite_hflip::vera_sprite_hflip_on1_$7 = (word)vera_sprite_hflip::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_hflip_on1___7
    lda #0
    sta.z vera_sprite_hflip_on1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1418] vera_sprite_hflip::vera_sprite_hflip_on1_sprite_offset#0 = vera_sprite_hflip::vera_sprite_hflip_on1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_hflip_on1_sprite_offset
    rol.z vera_sprite_hflip_on1_sprite_offset+1
    asl.z vera_sprite_hflip_on1_sprite_offset
    rol.z vera_sprite_hflip_on1_sprite_offset+1
    asl.z vera_sprite_hflip_on1_sprite_offset
    rol.z vera_sprite_hflip_on1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1419] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1420] vera_sprite_hflip::vera_sprite_hflip_on1_$4 = vera_sprite_hflip::vera_sprite_hflip_on1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_hflip_on1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_hflip_on1___4
    lda.z vera_sprite_hflip_on1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_hflip_on1___4+1
    // <sprite_offset+6
    // [1421] vera_sprite_hflip::vera_sprite_hflip_on1_$3 = < vera_sprite_hflip::vera_sprite_hflip_on1_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_hflip_on1___4
    sta.z vera_sprite_hflip_on1___3
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1422] *VERA_ADDRX_L = vera_sprite_hflip::vera_sprite_hflip_on1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1423] vera_sprite_hflip::vera_sprite_hflip_on1_$5 = > vera_sprite_hflip::vera_sprite_hflip_on1_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_hflip_on1___4+1
    sta.z vera_sprite_hflip_on1___5
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1424] *VERA_ADDRX_M = vera_sprite_hflip::vera_sprite_hflip_on1_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1425] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 | VERA_SPRITE_HFLIP
    // [1426] vera_sprite_hflip::vera_sprite_hflip_on1_$6 = *VERA_DATA0 | VERA_SPRITE_HFLIP -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITE_HFLIP
    ora VERA_DATA0
    sta.z vera_sprite_hflip_on1___6
    // *VERA_DATA0 = *VERA_DATA0 | VERA_SPRITE_HFLIP
    // [1427] *VERA_DATA0 = vera_sprite_hflip::vera_sprite_hflip_on1_$6 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    rts
}
  // vera_sprite_vflip
// vera_sprite_vflip(byte zp($b9) sprite, byte zp($ba) vflip)
vera_sprite_vflip: {
    .label vera_sprite_vflip_on1___3 = $d2
    .label vera_sprite_vflip_on1___4 = $75
    .label vera_sprite_vflip_on1___5 = $b9
    .label vera_sprite_vflip_on1___6 = $b9
    .label vera_sprite_vflip_on1___7 = $75
    .label vera_sprite_vflip_off1___3 = $f
    .label vera_sprite_vflip_off1___4 = $75
    .label vera_sprite_vflip_off1___5 = $ba
    .label vera_sprite_vflip_off1___6 = $c7
    .label vera_sprite_vflip_off1___7 = $75
    .label vera_sprite_vflip_on1_sprite_offset = $75
    .label vera_sprite_vflip_off1_sprite_offset = $75
    .label sprite = $b9
    .label vflip = $ba
    // if(vflip)
    // [1428] if(0!=vera_sprite_vflip::vflip#0) goto vera_sprite_vflip::vera_sprite_vflip_on1 -- 0_neq_vbuz1_then_la1 
    lda.z vflip
    cmp #0
    bne vera_sprite_vflip_on1
    // vera_sprite_vflip::vera_sprite_vflip_off1
    // (word)sprite << 3
    // [1429] vera_sprite_vflip::vera_sprite_vflip_off1_$7 = (word)vera_sprite_vflip::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_vflip_off1___7
    lda #0
    sta.z vera_sprite_vflip_off1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1430] vera_sprite_vflip::vera_sprite_vflip_off1_sprite_offset#0 = vera_sprite_vflip::vera_sprite_vflip_off1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_vflip_off1_sprite_offset
    rol.z vera_sprite_vflip_off1_sprite_offset+1
    asl.z vera_sprite_vflip_off1_sprite_offset
    rol.z vera_sprite_vflip_off1_sprite_offset+1
    asl.z vera_sprite_vflip_off1_sprite_offset
    rol.z vera_sprite_vflip_off1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1431] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1432] vera_sprite_vflip::vera_sprite_vflip_off1_$4 = vera_sprite_vflip::vera_sprite_vflip_off1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_vflip_off1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_vflip_off1___4
    lda.z vera_sprite_vflip_off1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_vflip_off1___4+1
    // <sprite_offset+6
    // [1433] vera_sprite_vflip::vera_sprite_vflip_off1_$3 = < vera_sprite_vflip::vera_sprite_vflip_off1_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_vflip_off1___4
    sta.z vera_sprite_vflip_off1___3
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1434] *VERA_ADDRX_L = vera_sprite_vflip::vera_sprite_vflip_off1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1435] vera_sprite_vflip::vera_sprite_vflip_off1_$5 = > vera_sprite_vflip::vera_sprite_vflip_off1_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_vflip_off1___4+1
    sta.z vera_sprite_vflip_off1___5
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1436] *VERA_ADDRX_M = vera_sprite_vflip::vera_sprite_vflip_off1_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1437] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_VFLIP
    // [1438] vera_sprite_vflip::vera_sprite_vflip_off1_$6 = *VERA_DATA0 & ~VERA_SPRITE_VFLIP -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_VFLIP^$ff
    and VERA_DATA0
    sta.z vera_sprite_vflip_off1___6
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_VFLIP
    // [1439] *VERA_DATA0 = vera_sprite_vflip::vera_sprite_vflip_off1_$6 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    // vera_sprite_vflip::@return
    // }
    // [1440] return 
    rts
    // vera_sprite_vflip::vera_sprite_vflip_on1
  vera_sprite_vflip_on1:
    // (word)sprite << 3
    // [1441] vera_sprite_vflip::vera_sprite_vflip_on1_$7 = (word)vera_sprite_vflip::sprite#0 -- vwuz1=_word_vbuz2 
    lda.z sprite
    sta.z vera_sprite_vflip_on1___7
    lda #0
    sta.z vera_sprite_vflip_on1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1442] vera_sprite_vflip::vera_sprite_vflip_on1_sprite_offset#0 = vera_sprite_vflip::vera_sprite_vflip_on1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_vflip_on1_sprite_offset
    rol.z vera_sprite_vflip_on1_sprite_offset+1
    asl.z vera_sprite_vflip_on1_sprite_offset
    rol.z vera_sprite_vflip_on1_sprite_offset+1
    asl.z vera_sprite_vflip_on1_sprite_offset
    rol.z vera_sprite_vflip_on1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1443] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1444] vera_sprite_vflip::vera_sprite_vflip_on1_$4 = vera_sprite_vflip::vera_sprite_vflip_on1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_vflip_on1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_vflip_on1___4
    lda.z vera_sprite_vflip_on1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_vflip_on1___4+1
    // <sprite_offset+6
    // [1445] vera_sprite_vflip::vera_sprite_vflip_on1_$3 = < vera_sprite_vflip::vera_sprite_vflip_on1_$4 -- vbuz1=_lo_vwuz2 
    lda.z vera_sprite_vflip_on1___4
    sta.z vera_sprite_vflip_on1___3
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1446] *VERA_ADDRX_L = vera_sprite_vflip::vera_sprite_vflip_on1_$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1447] vera_sprite_vflip::vera_sprite_vflip_on1_$5 = > vera_sprite_vflip::vera_sprite_vflip_on1_$4 -- vbuz1=_hi_vwuz2 
    lda.z vera_sprite_vflip_on1___4+1
    sta.z vera_sprite_vflip_on1___5
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1448] *VERA_ADDRX_M = vera_sprite_vflip::vera_sprite_vflip_on1_$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1449] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 | VERA_SPRITE_VFLIP
    // [1450] vera_sprite_vflip::vera_sprite_vflip_on1_$6 = *VERA_DATA0 | VERA_SPRITE_VFLIP -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITE_VFLIP
    ora VERA_DATA0
    sta.z vera_sprite_vflip_on1___6
    // *VERA_DATA0 = *VERA_DATA0 | VERA_SPRITE_VFLIP
    // [1451] *VERA_DATA0 = vera_sprite_vflip::vera_sprite_vflip_on1_$6 -- _deref_pbuc1=vbuz1 
    sta VERA_DATA0
    rts
}
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($c3) str)
strlen: {
    .label len = $c8
    .label str = $c3
    .label return = $c8
    // [1453] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [1453] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z len
    sta.z len+1
    // [1453] phi strlen::str#4 = strlen::str#6 [phi:strlen->strlen::@1#1] -- register_copy 
    // strlen::@1
  __b1:
    // while(*str)
    // [1454] if(0!=*strlen::str#4) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [1455] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [1456] strlen::len#1 = ++ strlen::len#2 -- vwuz1=_inc_vwuz1 
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    // [1457] strlen::str#0 = ++ strlen::str#4 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [1453] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [1453] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [1453] phi strlen::str#4 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
}
  // vera_layer_get_color
// Get the text and back color for text output in 16 color mode.
// - layer: Value of 0 or 1.
// - return: an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// vera_layer_get_color(byte zp($b9) layer)
vera_layer_get_color: {
    .label __0 = $c7
    .label __1 = $c7
    .label __3 = $c7
    .label addr = $75
    .label return = $b9
    .label layer = $b9
    // addr = vera_layer_config[layer]
    // [1459] vera_layer_get_color::$3 = vera_layer_get_color::layer#2 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z layer
    asl
    sta.z __3
    // [1460] vera_layer_get_color::addr#0 = vera_layer_config[vera_layer_get_color::$3] -- pbuz1=qbuc1_derefidx_vbuz2 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr & VERA_LAYER_CONFIG_256C
    // [1461] vera_layer_get_color::$0 = *vera_layer_get_color::addr#0 & VERA_LAYER_CONFIG_256C -- vbuz1=_deref_pbuz2_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C
    ldy #0
    and (addr),y
    sta.z __0
    // if( *addr & VERA_LAYER_CONFIG_256C )
    // [1462] if(0!=vera_layer_get_color::$0) goto vera_layer_get_color::@1 -- 0_neq_vbuz1_then_la1 
    cmp #0
    bne __b1
    // vera_layer_get_color::@2
    // vera_layer_backcolor[layer] << 4
    // [1463] vera_layer_get_color::$1 = vera_layer_backcolor[vera_layer_get_color::layer#2] << 4 -- vbuz1=pbuc1_derefidx_vbuz2_rol_4 
    ldy.z layer
    lda vera_layer_backcolor,y
    asl
    asl
    asl
    asl
    sta.z __1
    // return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
    // [1464] vera_layer_get_color::return#1 = vera_layer_get_color::$1 | vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuz1=vbuz2_bor_pbuc1_derefidx_vbuz1 
    ldy.z return
    ora vera_layer_textcolor,y
    sta.z return
    // [1465] phi from vera_layer_get_color::@1 vera_layer_get_color::@2 to vera_layer_get_color::@return [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return]
    // [1465] phi vera_layer_get_color::return#2 = vera_layer_get_color::return#0 [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return#0] -- register_copy 
    // vera_layer_get_color::@return
    // }
    // [1466] return 
    rts
    // vera_layer_get_color::@1
  __b1:
    // return (vera_layer_textcolor[layer]);
    // [1467] vera_layer_get_color::return#0 = vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z return
    lda vera_layer_textcolor,y
    sta.z return
    rts
}
  // cputln
// Print a newline
cputln: {
    .label __2 = $b9
    .label __3 = $b9
    .label temp = $75
    // temp = conio_line_text[cx16_conio.conio_screen_layer]
    // [1468] cputln::$2 = *((byte*)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __2
    // [1469] cputln::temp#0 = conio_line_text[cputln::$2] -- vwuz1=pwuc1_derefidx_vbuz2 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda conio_line_text,y
    sta.z temp
    lda conio_line_text+1,y
    sta.z temp+1
    // temp += cx16_conio.conio_rowskip
    // [1470] cputln::temp#1 = cputln::temp#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z temp
    sta.z temp
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z temp+1
    sta.z temp+1
    // conio_line_text[cx16_conio.conio_screen_layer] = temp
    // [1471] cputln::$3 = *((byte*)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __3
    // [1472] conio_line_text[cputln::$3] = cputln::temp#1 -- pwuc1_derefidx_vbuz1=vwuz2 
    tay
    lda.z temp
    sta conio_line_text,y
    lda.z temp+1
    sta conio_line_text+1,y
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [1473] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer]++;
    // [1474] conio_cursor_y[*((byte*)&cx16_conio)] = ++ conio_cursor_y[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    lda conio_cursor_y,x
    inc
    sta conio_cursor_y,y
    // cscroll()
    // [1475] call cscroll 
    jsr cscroll
    // cputln::@return
    // }
    // [1476] return 
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
// uctoa_append(byte* zp($c8) buffer, byte zp($f) value, byte zp($a9) sub)
uctoa_append: {
    .label buffer = $c8
    .label value = $f
    .label sub = $a9
    .label return = $f
    .label digit = $b3
    // [1478] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [1478] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z digit
    // [1478] phi uctoa_append::value#2 = uctoa_append::value#0 [phi:uctoa_append->uctoa_append::@1#1] -- register_copy 
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [1479] if(uctoa_append::value#2>=uctoa_append::sub#0) goto uctoa_append::@2 -- vbuz1_ge_vbuz2_then_la1 
    lda.z value
    cmp.z sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [1480] *uctoa_append::buffer#0 = DIGITS[uctoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuz2 
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // uctoa_append::@return
    // }
    // [1481] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [1482] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // value -= sub
    // [1483] uctoa_append::value#1 = uctoa_append::value#2 - uctoa_append::sub#0 -- vbuz1=vbuz1_minus_vbuz2 
    lda.z value
    sec
    sbc.z sub
    sta.z value
    // [1478] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [1478] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    // [1478] phi uctoa_append::value#2 = uctoa_append::value#1 [phi:uctoa_append::@2->uctoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // printf_padding
// Print a padding char a number of times
// printf_padding(byte zp($b7) pad, byte zp($40) length)
printf_padding: {
    .label i = $b8
    .label length = $40
    .label pad = $b7
    // [1485] phi from printf_padding to printf_padding::@1 [phi:printf_padding->printf_padding::@1]
    // [1485] phi printf_padding::i#2 = 0 [phi:printf_padding->printf_padding::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // printf_padding::@1
  __b1:
    // for(char i=0;i<length; i++)
    // [1486] if(printf_padding::i#2<printf_padding::length#6) goto printf_padding::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z i
    cmp.z length
    bcc __b2
    // printf_padding::@return
    // }
    // [1487] return 
    rts
    // printf_padding::@2
  __b2:
    // cputc(pad)
    // [1488] cputc::c#1 = printf_padding::pad#7 -- vbuz1=vbuz2 
    lda.z pad
    sta.z cputc.c
    // [1489] call cputc 
    // [1109] phi from printf_padding::@2 to cputc [phi:printf_padding::@2->cputc]
    // [1109] phi cputc::c#3 = cputc::c#1 [phi:printf_padding::@2->cputc#0] -- register_copy 
    jsr cputc
    // printf_padding::@3
    // for(char i=0;i<length; i++)
    // [1490] printf_padding::i#1 = ++ printf_padding::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [1485] phi from printf_padding::@3 to printf_padding::@1 [phi:printf_padding::@3->printf_padding::@1]
    // [1485] phi printf_padding::i#2 = printf_padding::i#1 [phi:printf_padding::@3->printf_padding::@1#0] -- register_copy 
    jmp __b1
}
  // strupr
// Converts a string to uppercase.
strupr: {
    .label str = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label __0 = $b9
    .label src = $7d
    // [1492] phi from strupr to strupr::@1 [phi:strupr->strupr::@1]
    // [1492] phi strupr::src#2 = strupr::str#0 [phi:strupr->strupr::@1#0] -- pbuz1=pbuc1 
    lda #<str
    sta.z src
    lda #>str
    sta.z src+1
    // strupr::@1
  __b1:
    // while(*src)
    // [1493] if(0!=*strupr::src#2) goto strupr::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strupr::@return
    // }
    // [1494] return 
    rts
    // strupr::@2
  __b2:
    // toupper(*src)
    // [1495] toupper::ch#0 = *strupr::src#2 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta.z toupper.ch
    // [1496] call toupper 
    jsr toupper
    // [1497] toupper::return#3 = toupper::return#2
    // strupr::@3
    // [1498] strupr::$0 = toupper::return#3
    // *src = toupper(*src)
    // [1499] *strupr::src#2 = strupr::$0 -- _deref_pbuz1=vbuz2 
    lda.z __0
    ldy #0
    sta (src),y
    // src++;
    // [1500] strupr::src#1 = ++ strupr::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [1492] phi from strupr::@3 to strupr::@1 [phi:strupr::@3->strupr::@1]
    // [1492] phi strupr::src#2 = strupr::src#1 [phi:strupr::@3->strupr::@1#0] -- register_copy 
    jmp __b1
}
  // vera_heap_block_is_empty
// vera_heap_block_is_empty(struct vera_heap* zp($b1) block)
vera_heap_block_is_empty: {
    .label sz = $6f
    .label return = $6f
    .label block = $b1
    // sz = block->size
    // [1501] vera_heap_block_is_empty::sz#0 = ((word*)vera_heap_block_is_empty::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] -- vwuz1=pwuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    sta.z sz
    iny
    lda (block),y
    sta.z sz+1
    // sz & ~VERA_HEAP_EMPTY
    // [1502] vera_heap_block_is_empty::return#0 = vera_heap_block_is_empty::sz#0 & ~VERA_HEAP_EMPTY -- vwuz1=vwuz1_band_vwuc1 
    lda.z return
    and #<VERA_HEAP_EMPTY^$ffff
    sta.z return
    lda.z return+1
    and #>VERA_HEAP_EMPTY^$ffff
    sta.z return+1
    // vera_heap_block_is_empty::@return
    // }
    // [1503] return 
    rts
}
  // vera_heap_block_size_get
// vera_heap_block_size_get(struct vera_heap* zp($c8) block)
vera_heap_block_size_get: {
    .label __0 = $af
    .label __2 = $c8
    .label return = $26
    .label block = $c8
    // block->size & ~VERA_HEAP_SIZE_16
    // [1504] vera_heap_block_size_get::$0 = ((word*)vera_heap_block_size_get::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_SIZE_16 -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_SIZE_16^$ffff
    sta.z __0
    iny
    lda (block),y
    and #>VERA_HEAP_SIZE_16^$ffff
    sta.z __0+1
    // (block->size & ~VERA_HEAP_SIZE_16)?0x10000:0x00000 | block->size
    // [1505] if(0!=vera_heap_block_size_get::$0) goto vera_heap_block_size_get::@2 -- 0_neq_vwuz1_then_la1 
    lda.z __0
    ora.z __0+1
    bne __b1
    // vera_heap_block_size_get::@1
    // [1506] vera_heap_block_size_get::$2 = ((word*)vera_heap_block_size_get::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] -- vwuz1=pwuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (__2),y
    pha
    iny
    lda (__2),y
    sta.z __2+1
    pla
    sta.z __2
    // [1507] phi from vera_heap_block_size_get::@1 to vera_heap_block_size_get::@2 [phi:vera_heap_block_size_get::@1->vera_heap_block_size_get::@2]
    // [1507] phi vera_heap_block_size_get::return#0 = vera_heap_block_size_get::$2 [phi:vera_heap_block_size_get::@1->vera_heap_block_size_get::@2#0] -- vduz1=vwuz2 
    sta.z return
    lda.z __2+1
    sta.z return+1
    lda #0
    sta.z return+2
    sta.z return+3
    rts
    // [1507] phi from vera_heap_block_size_get to vera_heap_block_size_get::@2 [phi:vera_heap_block_size_get->vera_heap_block_size_get::@2]
  __b1:
    // [1507] phi vera_heap_block_size_get::return#0 = $10000 [phi:vera_heap_block_size_get->vera_heap_block_size_get::@2#0] -- vduz1=vduc1 
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
    // [1508] return 
    rts
}
  // ultoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// ultoa(dword zp($26) value, byte* zp($7d) buffer)
ultoa: {
    .const max_digits = 8
    .label __10 = $f
    .label __11 = $f
    .label digit_value = $ce
    .label buffer = $7d
    .label digit = $aa
    .label value = $26
    .label started = $b5
    // [1510] phi from ultoa to ultoa::@1 [phi:ultoa->ultoa::@1]
    // [1510] phi ultoa::buffer#11 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:ultoa->ultoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [1510] phi ultoa::started#2 = 0 [phi:ultoa->ultoa::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z started
    // [1510] phi ultoa::value#2 = ultoa::value#1 [phi:ultoa->ultoa::@1#2] -- register_copy 
    // [1510] phi ultoa::digit#2 = 0 [phi:ultoa->ultoa::@1#3] -- vbuz1=vbuc1 
    sta.z digit
    // ultoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1511] if(ultoa::digit#2<ultoa::max_digits#2-1) goto ultoa::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // ultoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [1512] ultoa::$11 = (byte)ultoa::value#2 -- vbuz1=_byte_vduz2 
    lda.z value
    sta.z __11
    // [1513] *ultoa::buffer#11 = DIGITS[ultoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbuz2 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1514] ultoa::buffer#3 = ++ ultoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1515] *ultoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // ultoa::@return
    // }
    // [1516] return 
    rts
    // ultoa::@2
  __b2:
    // digit_value = digit_values[digit]
    // [1517] ultoa::$10 = ultoa::digit#2 << 2 -- vbuz1=vbuz2_rol_2 
    lda.z digit
    asl
    asl
    sta.z __10
    // [1518] ultoa::digit_value#0 = RADIX_HEXADECIMAL_VALUES_LONG[ultoa::$10] -- vduz1=pduc1_derefidx_vbuz2 
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
    // [1519] if(0!=ultoa::started#2) goto ultoa::@5 -- 0_neq_vbuz1_then_la1 
    lda.z started
    cmp #0
    bne __b5
    // ultoa::@7
    // [1520] if(ultoa::value#2>=ultoa::digit_value#0) goto ultoa::@5 -- vduz1_ge_vduz2_then_la1 
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
    // [1521] phi from ultoa::@7 to ultoa::@4 [phi:ultoa::@7->ultoa::@4]
    // [1521] phi ultoa::buffer#14 = ultoa::buffer#11 [phi:ultoa::@7->ultoa::@4#0] -- register_copy 
    // [1521] phi ultoa::started#4 = ultoa::started#2 [phi:ultoa::@7->ultoa::@4#1] -- register_copy 
    // [1521] phi ultoa::value#6 = ultoa::value#2 [phi:ultoa::@7->ultoa::@4#2] -- register_copy 
    // ultoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1522] ultoa::digit#1 = ++ ultoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [1510] phi from ultoa::@4 to ultoa::@1 [phi:ultoa::@4->ultoa::@1]
    // [1510] phi ultoa::buffer#11 = ultoa::buffer#14 [phi:ultoa::@4->ultoa::@1#0] -- register_copy 
    // [1510] phi ultoa::started#2 = ultoa::started#4 [phi:ultoa::@4->ultoa::@1#1] -- register_copy 
    // [1510] phi ultoa::value#2 = ultoa::value#6 [phi:ultoa::@4->ultoa::@1#2] -- register_copy 
    // [1510] phi ultoa::digit#2 = ultoa::digit#1 [phi:ultoa::@4->ultoa::@1#3] -- register_copy 
    jmp __b1
    // ultoa::@5
  __b5:
    // ultoa_append(buffer++, value, digit_value)
    // [1523] ultoa_append::buffer#0 = ultoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z ultoa_append.buffer
    lda.z buffer+1
    sta.z ultoa_append.buffer+1
    // [1524] ultoa_append::value#0 = ultoa::value#2
    // [1525] ultoa_append::sub#0 = ultoa::digit_value#0
    // [1526] call ultoa_append 
    // [1544] phi from ultoa::@5 to ultoa_append [phi:ultoa::@5->ultoa_append]
    jsr ultoa_append
    // ultoa_append(buffer++, value, digit_value)
    // [1527] ultoa_append::return#0 = ultoa_append::value#2
    // ultoa::@6
    // value = ultoa_append(buffer++, value, digit_value)
    // [1528] ultoa::value#0 = ultoa_append::return#0
    // value = ultoa_append(buffer++, value, digit_value);
    // [1529] ultoa::buffer#4 = ++ ultoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1521] phi from ultoa::@6 to ultoa::@4 [phi:ultoa::@6->ultoa::@4]
    // [1521] phi ultoa::buffer#14 = ultoa::buffer#4 [phi:ultoa::@6->ultoa::@4#0] -- register_copy 
    // [1521] phi ultoa::started#4 = 1 [phi:ultoa::@6->ultoa::@4#1] -- vbuz1=vbuc1 
    lda #1
    sta.z started
    // [1521] phi ultoa::value#6 = ultoa::value#0 [phi:ultoa::@6->ultoa::@4#2] -- register_copy 
    jmp __b4
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [1530] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    ldy cx16_conio
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b3
    // cscroll::@1
    // if(conio_scroll_enable[cx16_conio.conio_screen_layer])
    // [1531] if(0!=conio_scroll_enable[*((byte*)&cx16_conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    lda conio_scroll_enable,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [1532] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    // [1533] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
  __b3:
    // cscroll::@return
    // }
    // [1534] return 
    rts
    // [1535] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [1536] call insertup 
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, cx16_conio.conio_screen_height-1)
    // [1537] gotoxy::y#2 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    stx.z gotoxy.y
    // [1538] call gotoxy 
    // [406] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [406] phi gotoxy::x#4 = 0 [phi:cscroll::@5->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [406] phi gotoxy::y#4 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#1] -- register_copy 
    jsr gotoxy
    rts
}
  // toupper
// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
// toupper(byte zp($b9) ch)
toupper: {
    .label return = $b9
    .label ch = $b9
    // if(ch>='a' && ch<='z')
    // [1539] if(toupper::ch#0<'a') goto toupper::@return -- vbuz1_lt_vbuc1_then_la1 
    lda.z ch
    cmp #'a'
    bcc __breturn
    // toupper::@2
    // [1540] if(toupper::ch#0<='z') goto toupper::@1 -- vbuz1_le_vbuc1_then_la1 
    lda #'z'
    cmp.z ch
    bcs __b1
    // [1542] phi from toupper toupper::@1 toupper::@2 to toupper::@return [phi:toupper/toupper::@1/toupper::@2->toupper::@return]
    // [1542] phi toupper::return#2 = toupper::ch#0 [phi:toupper/toupper::@1/toupper::@2->toupper::@return#0] -- register_copy 
    rts
    // toupper::@1
  __b1:
    // return ch + ('A'-'a');
    // [1541] toupper::return#0 = toupper::ch#0 + 'A'-'a' -- vbuz1=vbuz1_plus_vbuc1 
    lda #'A'-'a'
    clc
    adc.z return
    sta.z return
    // toupper::@return
  __breturn:
    // }
    // [1543] return 
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
// ultoa_append(byte* zp($af) buffer, dword zp($26) value, dword zp($ce) sub)
ultoa_append: {
    .label buffer = $af
    .label value = $26
    .label sub = $ce
    .label return = $26
    .label digit = $ba
    // [1545] phi from ultoa_append to ultoa_append::@1 [phi:ultoa_append->ultoa_append::@1]
    // [1545] phi ultoa_append::digit#2 = 0 [phi:ultoa_append->ultoa_append::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z digit
    // [1545] phi ultoa_append::value#2 = ultoa_append::value#0 [phi:ultoa_append->ultoa_append::@1#1] -- register_copy 
    // ultoa_append::@1
  __b1:
    // while (value >= sub)
    // [1546] if(ultoa_append::value#2>=ultoa_append::sub#0) goto ultoa_append::@2 -- vduz1_ge_vduz2_then_la1 
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
    // [1547] *ultoa_append::buffer#0 = DIGITS[ultoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuz2 
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // ultoa_append::@return
    // }
    // [1548] return 
    rts
    // ultoa_append::@2
  __b2:
    // digit++;
    // [1549] ultoa_append::digit#1 = ++ ultoa_append::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // value -= sub
    // [1550] ultoa_append::value#1 = ultoa_append::value#2 - ultoa_append::sub#0 -- vduz1=vduz1_minus_vduz2 
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
    // [1545] phi from ultoa_append::@2 to ultoa_append::@1 [phi:ultoa_append::@2->ultoa_append::@1]
    // [1545] phi ultoa_append::digit#2 = ultoa_append::digit#1 [phi:ultoa_append::@2->ultoa_append::@1#0] -- register_copy 
    // [1545] phi ultoa_append::value#2 = ultoa_append::value#1 [phi:ultoa_append::@2->ultoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label __3 = $d2
    .label cy = $ba
    .label width = $c7
    .label line = $75
    .label start = $75
    .label i = $b9
    // cy = conio_cursor_y[cx16_conio.conio_screen_layer]
    // [1551] insertup::cy#0 = conio_cursor_y[*((byte*)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy cx16_conio
    lda conio_cursor_y,y
    sta.z cy
    // width = cx16_conio.conio_screen_width * 2
    // [1552] insertup::width#0 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    asl
    sta.z width
    // [1553] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [1553] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z i
    // insertup::@1
  __b1:
    // for(unsigned byte i=1; i<=cy; i++)
    // [1554] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuz1_le_vbuz2_then_la1 
    lda.z cy
    cmp.z i
    bcs __b2
    // [1555] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [1556] call clearline 
    jsr clearline
    // insertup::@return
    // }
    // [1557] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [1558] insertup::$3 = insertup::i#2 - 1 -- vbuz1=vbuz2_minus_1 
    ldx.z i
    dex
    stx.z __3
    // line = (i-1) << cx16_conio.conio_rowshift
    // [1559] insertup::line#0 = insertup::$3 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vbuz2_rol__deref_pbuc1 
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
    // start = cx16_conio.conio_screen_text + line
    // [1560] insertup::start#0 = *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) + insertup::line#0 -- pbuz1=_deref_qbuc1_plus_vwuz1 
    clc
    lda.z start
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z start
    lda.z start+1
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z start+1
    // start+cx16_conio.conio_rowskip
    // [1561] memcpy_in_vram::src#0 = insertup::start#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- pbuz1=pbuz2_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z start
    sta.z memcpy_in_vram.src
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z start+1
    sta.z memcpy_in_vram.src+1
    // memcpy_in_vram(0, start, VERA_INC_1,  0, start+cx16_conio.conio_rowskip, VERA_INC_1, width)
    // [1562] memcpy_in_vram::dest#0 = (void*)insertup::start#0 -- pvoz1=pvoz2 
    lda.z start
    sta.z memcpy_in_vram.dest
    lda.z start+1
    sta.z memcpy_in_vram.dest+1
    // [1563] memcpy_in_vram::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z memcpy_in_vram.num
    lda #0
    sta.z memcpy_in_vram.num+1
    // [1564] memcpy_in_vram::src#3 = (void*)memcpy_in_vram::src#0
    // memcpy_in_vram(0, start, VERA_INC_1,  0, start+cx16_conio.conio_rowskip, VERA_INC_1, width)
    // [1565] call memcpy_in_vram 
    // [264] phi from insertup::@2 to memcpy_in_vram [phi:insertup::@2->memcpy_in_vram]
    // [264] phi memcpy_in_vram::num#3 = memcpy_in_vram::num#0 [phi:insertup::@2->memcpy_in_vram#0] -- register_copy 
    // [264] phi memcpy_in_vram::dest_bank#2 = 0 [phi:insertup::@2->memcpy_in_vram#1] -- vbuz1=vbuc1 
    sta.z memcpy_in_vram.dest_bank
    // [264] phi memcpy_in_vram::dest#2 = memcpy_in_vram::dest#0 [phi:insertup::@2->memcpy_in_vram#2] -- register_copy 
    // [264] phi memcpy_in_vram::src_bank#2 = 0 [phi:insertup::@2->memcpy_in_vram#3] -- vbuz1=vbuc1 
    sta.z memcpy_in_vram.src_bank
    // [264] phi memcpy_in_vram::src#2 = memcpy_in_vram::src#3 [phi:insertup::@2->memcpy_in_vram#4] -- register_copy 
    jsr memcpy_in_vram
    // insertup::@4
    // for(unsigned byte i=1; i<=cy; i++)
    // [1566] insertup::i#1 = ++ insertup::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [1553] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [1553] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
}
  // clearline
clearline: {
    .label __1 = $b9
    .label __2 = $ba
    .label __5 = $b9
    .label conio_line = $75
    .label addr = $75
    .label color = $b9
    .label c = $c5
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1567] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // conio_line = conio_line_text[cx16_conio.conio_screen_layer]
    // [1568] clearline::$5 = *((byte*)&cx16_conio) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    sta.z __5
    // [1569] clearline::conio_line#0 = conio_line_text[clearline::$5] -- vwuz1=pwuc1_derefidx_vbuz2 
    tay
    lda conio_line_text,y
    sta.z conio_line
    lda conio_line_text+1,y
    sta.z conio_line+1
    // conio_screen_text + conio_line
    // [1570] clearline::addr#0 = (word)*((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) + clearline::conio_line#0 -- vwuz1=_deref_pwuc1_plus_vwuz1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    adc.z addr
    sta.z addr
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    adc.z addr+1
    sta.z addr+1
    // <addr
    // [1571] clearline::$1 = < (byte*)clearline::addr#0 -- vbuz1=_lo_pbuz2 
    lda.z addr
    sta.z __1
    // *VERA_ADDRX_L = <addr
    // [1572] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // >addr
    // [1573] clearline::$2 = > (byte*)clearline::addr#0 -- vbuz1=_hi_pbuz2 
    lda.z addr+1
    sta.z __2
    // *VERA_ADDRX_M = >addr
    // [1574] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [1575] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1576] vera_layer_get_color::layer#1 = *((byte*)&cx16_conio) -- vbuz1=_deref_pbuc1 
    lda cx16_conio
    sta.z vera_layer_get_color.layer
    // [1577] call vera_layer_get_color 
    // [1458] phi from clearline to vera_layer_get_color [phi:clearline->vera_layer_get_color]
    // [1458] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#1 [phi:clearline->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1578] vera_layer_get_color::return#4 = vera_layer_get_color::return#2
    // clearline::@4
    // color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1579] clearline::color#0 = vera_layer_get_color::return#4
    // [1580] phi from clearline::@4 to clearline::@1 [phi:clearline::@4->clearline::@1]
    // [1580] phi clearline::c#2 = 0 [phi:clearline::@4->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [1581] if(clearline::c#2<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto clearline::@2 -- vwuz1_lt__deref_pbuc1_then_la1 
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
    // [1582] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // clearline::@return
    // }
    // [1583] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [1584] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [1585] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [1586] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [1580] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [1580] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
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
  .byte 0, 0, $c, $20, $20, 0, 1, 3, 4, 1
  .dword 0, 0
  .fill 4*$b, 0
  SpritesEnemy2: .text "ENEMY2"
  .byte 0
  .fill 9, 0
  .byte 0, $c, $c, $20, $20, 0, 0, 3, 4, 2
  .dword 0, 0
  .fill 4*$b, 0
  SquareMetal: .text "SQUAREMETAL"
  .byte 0
  .fill 4, 0
  .word 0, $40*$40*4/2
  .byte $40, $10, 4, 4, 4
  .dword 0, 0
  .fill 4*$b, 0
  TileMetal: .text "TILEMETAL"
  .byte 0
  .fill 6, 0
  .word $40, $40*$40*4/2
  .byte $40, $10, 4, 4, 5
  .dword 0, 0
  .fill 4*$b, 0
  SquareRaster: .text "SQUARERASTER"
  .byte 0
  .fill 3, 0
  .word $80, $40*$40*4/2
  .byte $40, $10, 4, 4, 6
  .dword 0, 0
  .fill 4*$b, 0
  .label bram_sprites_ceil = vram_floor_map
  .label bram_tiles_ceil = vram_floor_map
  .label bram_palette = vram_floor_map
  vram_floor_map: .dword 0
