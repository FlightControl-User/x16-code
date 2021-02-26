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
  .const VERA_SPRITE_VFLIP = 2
  .const VERA_SPRITE_ZDEPTH_IN_FRONT = $c
  .const VERA_SPRITE_ZDEPTH_MASK = $c
  .const VERA_SPRITE_WIDTH_32 = $20
  .const VERA_SPRITE_WIDTH_MASK = $30
  .const VERA_SPRITE_HEIGHT_32 = $80
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
  .const HEAP_SPRITES = 0
  .const HEAP_FLOOR_MAP = 1
  .const HEAP_FLOOR_TILE = 2
  .const HEAP_PETSCII = 3
  // Addressed used for graphics in main banked memory.
  .const BRAM_PLAYER = $2000
  .const BRAM_ENEMY2 = $4000
  .const BANK_TILES_SMALL = $14000
  .const BANK_SQUAREMETAL = $16000
  .const BANK_TILEMETAL = $22000
  .const BANK_SQUARERASTER = $28000
  .const BANK_PALETTE = $34000
  // Addresses used to store graphics in VERA VRAM.
  .const VRAM_BASE = 0
  .const VRAM_PETSCII_TILE = $1f000
  .const VRAM_ENEMY2 = $1800
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
  .const OFFSET_STRUCT_TILE_OFFSET = 2
  .const OFFSET_STRUCT_TILE_TOTAL = 4
  .const OFFSET_STRUCT_TILE_COUNT = 5
  .const OFFSET_STRUCT_TILE_COLUMNS = 7
  .const OFFSET_STRUCT_TILE_PALETTE = 8
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
  .label i = $3a
  .label j = $3b
  .label a = $3c
  .label vscroll = $3d
  .label scroll_action = $3f
  // The random state variable
  .label rand_state = $2a
  .label vram_floor_map = 3
  .label vram_floor_tile = $58
  // Remainder after unsigned 16-bit division
  .label rem16u = $2c
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
    .label __2 = $41
    .label __12 = $43
    .label __15 = $45
    .label __17 = $47
    .label __23 = $41
    .label vera_layer_set_vertical_scroll1_scroll = $49
    .label c = 8
    .label r = 7
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
    // rotate_sprites(0, i,NUM_PLAYER,PlayerSprites,40,100)
    // [14] rotate_sprites::rotate#0 = i -- vwuz1=vbuz2 
    lda.z i
    sta.z rotate_sprites.rotate
    lda #0
    sta.z rotate_sprites.rotate+1
    // [15] call rotate_sprites 
    // [242] phi from irq_vsync::@3 to rotate_sprites [phi:irq_vsync::@3->rotate_sprites]
    // [242] phi rotate_sprites::basex#8 = $28 [phi:irq_vsync::@3->rotate_sprites#0] -- vwuz1=vbuc1 
    lda #<$28
    sta.z rotate_sprites.basex
    lda #>$28
    sta.z rotate_sprites.basex+1
    // [242] phi rotate_sprites::spriteaddresses#6 = PlayerSprites [phi:irq_vsync::@3->rotate_sprites#1] -- pduz1=pduc1 
    lda #<PlayerSprites
    sta.z rotate_sprites.spriteaddresses
    lda #>PlayerSprites
    sta.z rotate_sprites.spriteaddresses+1
    // [242] phi rotate_sprites::base#8 = 0 [phi:irq_vsync::@3->rotate_sprites#2] -- vbuz1=vbuc1 
    lda #0
    sta.z rotate_sprites.base
    // [242] phi rotate_sprites::rotate#4 = rotate_sprites::rotate#0 [phi:irq_vsync::@3->rotate_sprites#3] -- register_copy 
    // [242] phi rotate_sprites::max#5 = NUM_PLAYER [phi:irq_vsync::@3->rotate_sprites#4] -- vwuz1=vbuc1 
    lda #<NUM_PLAYER
    sta.z rotate_sprites.max
    lda #>NUM_PLAYER
    sta.z rotate_sprites.max+1
    jsr rotate_sprites
    // irq_vsync::@15
    // rotate_sprites(12, j,NUM_ENEMY2,Enemy2Sprites,340,100)
    // [16] rotate_sprites::rotate#1 = j -- vwuz1=vbuz2 
    lda.z j
    sta.z rotate_sprites.rotate
    lda #0
    sta.z rotate_sprites.rotate+1
    // [17] call rotate_sprites 
    // [242] phi from irq_vsync::@15 to rotate_sprites [phi:irq_vsync::@15->rotate_sprites]
    // [242] phi rotate_sprites::basex#8 = $154 [phi:irq_vsync::@15->rotate_sprites#0] -- vwuz1=vwuc1 
    lda #<$154
    sta.z rotate_sprites.basex
    lda #>$154
    sta.z rotate_sprites.basex+1
    // [242] phi rotate_sprites::spriteaddresses#6 = Enemy2Sprites [phi:irq_vsync::@15->rotate_sprites#1] -- pduz1=pduc1 
    lda #<Enemy2Sprites
    sta.z rotate_sprites.spriteaddresses
    lda #>Enemy2Sprites
    sta.z rotate_sprites.spriteaddresses+1
    // [242] phi rotate_sprites::base#8 = $c [phi:irq_vsync::@15->rotate_sprites#2] -- vbuz1=vbuc1 
    lda #$c
    sta.z rotate_sprites.base
    // [242] phi rotate_sprites::rotate#4 = rotate_sprites::rotate#1 [phi:irq_vsync::@15->rotate_sprites#3] -- register_copy 
    // [242] phi rotate_sprites::max#5 = NUM_ENEMY2 [phi:irq_vsync::@15->rotate_sprites#4] -- vwuz1=vbuc1 
    lda #<NUM_ENEMY2
    sta.z rotate_sprites.max
    lda #>NUM_ENEMY2
    sta.z rotate_sprites.max+1
    jsr rotate_sprites
    // irq_vsync::@16
    // i++;
    // [18] i = ++ i -- vbuz1=_inc_vbuz1 
    inc.z i
    // if(i>=NUM_PLAYER)
    // [19] if(i<NUM_PLAYER) goto irq_vsync::@7 -- vbuz1_lt_vbuc1_then_la1 
    lda.z i
    cmp #NUM_PLAYER
    bcc __b7
    // irq_vsync::@4
    // i=0
    // [20] i = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // irq_vsync::@7
  __b7:
    // j++;
    // [21] j = ++ j -- vbuz1=_inc_vbuz1 
    inc.z j
    // if(j>=NUM_ENEMY2)
    // [22] if(j<NUM_ENEMY2) goto irq_vsync::@1 -- vbuz1_lt_vbuc1_then_la1 
    lda.z j
    cmp #NUM_ENEMY2
    bcc __b1
    // irq_vsync::@8
    // j=0
    // [23] j = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z j
    // irq_vsync::@1
  __b1:
    // if(scroll_action--)
    // [24] irq_vsync::$2 = scroll_action -- vwuz1=vwuz2 
    lda.z scroll_action
    sta.z __2
    lda.z scroll_action+1
    sta.z __2+1
    // [25] scroll_action = -- scroll_action -- vwuz1=_dec_vwuz1 
    lda.z scroll_action
    bne !+
    dec.z scroll_action+1
  !:
    dec.z scroll_action
    // [26] if(0==irq_vsync::$2) goto irq_vsync::@2 -- 0_eq_vwuz1_then_la1 
    lda.z __2
    ora.z __2+1
    bne !__b2+
    jmp __b2
  !__b2:
    // irq_vsync::@5
    // scroll_action = 2
    // [27] scroll_action = 2 -- vwuz1=vbuc1 
    lda #<2
    sta.z scroll_action
    lda #>2
    sta.z scroll_action+1
    // vscroll++;
    // [28] vscroll = ++ vscroll -- vwuz1=_inc_vwuz1 
    inc.z vscroll
    bne !+
    inc.z vscroll+1
  !:
    // if(vscroll>(64)*2-1)
    // [29] if(vscroll<$40*2-1+1) goto irq_vsync::@9 -- vwuz1_lt_vbuc1_then_la1 
    lda.z vscroll+1
    bne !+
    lda.z vscroll
    cmp #$40*2-1+1
    bcc __b9
  !:
    // irq_vsync::@6
    // >vram_floor_map
    // [30] irq_vsync::$12 = > vram_floor_map#10 -- vwuz1=_hi_vduz2 
    lda.z vram_floor_map+2
    sta.z __12
    lda.z vram_floor_map+3
    sta.z __12+1
    // memcpy_in_vram(<(>vram_floor_map), <vram_floor_map, VERA_INC_1, <(>vram_floor_map), (<vram_floor_map)+64*16, VERA_INC_1, 64*16*4)
    // [31] memcpy_in_vram::dest_bank#1 = < irq_vsync::$12 -- vbuz1=_lo_vwuz2 
    lda.z __12
    sta.z memcpy_in_vram.dest_bank
    // <vram_floor_map
    // [32] memcpy_in_vram::dest#1 = < vram_floor_map#10 -- vwuz1=_lo_vduz2 
    lda.z vram_floor_map
    sta.z memcpy_in_vram.dest
    lda.z vram_floor_map+1
    sta.z memcpy_in_vram.dest+1
    // >vram_floor_map
    // [33] irq_vsync::$15 = > vram_floor_map#10 -- vwuz1=_hi_vduz2 
    lda.z vram_floor_map+2
    sta.z __15
    lda.z vram_floor_map+3
    sta.z __15+1
    // memcpy_in_vram(<(>vram_floor_map), <vram_floor_map, VERA_INC_1, <(>vram_floor_map), (<vram_floor_map)+64*16, VERA_INC_1, 64*16*4)
    // [34] memcpy_in_vram::src_bank#1 = < irq_vsync::$15 -- vbuyy=_lo_vwuz1 
    ldy.z __15
    // <vram_floor_map
    // [35] irq_vsync::$17 = < vram_floor_map#10 -- vwuz1=_lo_vduz2 
    lda.z vram_floor_map
    sta.z __17
    lda.z vram_floor_map+1
    sta.z __17+1
    // (<vram_floor_map)+64*16
    // [36] memcpy_in_vram::src#1 = irq_vsync::$17 + (word)$40*$10 -- vwuz1=vwuz2_plus_vwuc1 
    clc
    lda.z __17
    adc #<$40*$10
    sta.z memcpy_in_vram.src
    lda.z __17+1
    adc #>$40*$10
    sta.z memcpy_in_vram.src+1
    // [37] memcpy_in_vram::src#4 = (void*)memcpy_in_vram::src#1
    // [38] memcpy_in_vram::dest#4 = (void*)memcpy_in_vram::dest#1
    // memcpy_in_vram(<(>vram_floor_map), <vram_floor_map, VERA_INC_1, <(>vram_floor_map), (<vram_floor_map)+64*16, VERA_INC_1, 64*16*4)
    // [39] call memcpy_in_vram 
    // [301] phi from irq_vsync::@6 to memcpy_in_vram [phi:irq_vsync::@6->memcpy_in_vram]
    // [301] phi memcpy_in_vram::num#3 = (word)$40*$10*4 [phi:irq_vsync::@6->memcpy_in_vram#0] -- vwuz1=vwuc1 
    lda #<$40*$10*4
    sta.z memcpy_in_vram.num
    lda #>$40*$10*4
    sta.z memcpy_in_vram.num+1
    // [301] phi memcpy_in_vram::dest_bank#2 = memcpy_in_vram::dest_bank#1 [phi:irq_vsync::@6->memcpy_in_vram#1] -- register_copy 
    // [301] phi memcpy_in_vram::dest#2 = memcpy_in_vram::dest#4 [phi:irq_vsync::@6->memcpy_in_vram#2] -- register_copy 
    // [301] phi memcpy_in_vram::src_bank#2 = memcpy_in_vram::src_bank#1 [phi:irq_vsync::@6->memcpy_in_vram#3] -- register_copy 
    // [301] phi memcpy_in_vram::src#2 = memcpy_in_vram::src#4 [phi:irq_vsync::@6->memcpy_in_vram#4] -- register_copy 
    jsr memcpy_in_vram
    // [40] phi from irq_vsync::@6 to irq_vsync::@10 [phi:irq_vsync::@6->irq_vsync::@10]
    // [40] phi rem16u#51 = rem16u#32 [phi:irq_vsync::@6->irq_vsync::@10#0] -- register_copy 
    // [40] phi rand_state#43 = rand_state#30 [phi:irq_vsync::@6->irq_vsync::@10#1] -- register_copy 
    // [40] phi irq_vsync::r#2 = 4 [phi:irq_vsync::@6->irq_vsync::@10#2] -- vbuz1=vbuc1 
    lda #4
    sta.z r
    // irq_vsync::@10
  __b10:
    // for(byte r=4;r<5;r+=1)
    // [41] if(irq_vsync::r#2<5) goto irq_vsync::@12 -- vbuz1_lt_vbuc1_then_la1 
    lda.z r
    cmp #5
    bcc __b3
    // irq_vsync::@11
    // vscroll=0
    // [42] vscroll = 0 -- vwuz1=vbuc1 
    lda #<0
    sta.z vscroll
    sta.z vscroll+1
    // irq_vsync::@9
  __b9:
    // vera_layer_set_vertical_scroll(0,vscroll)
    // [43] irq_vsync::vera_layer_set_vertical_scroll1_scroll#0 = vscroll -- vwuz1=vwuz2 
    lda.z vscroll
    sta.z vera_layer_set_vertical_scroll1_scroll
    lda.z vscroll+1
    sta.z vera_layer_set_vertical_scroll1_scroll+1
    // irq_vsync::vera_layer_set_vertical_scroll1
    // <scroll
    // [44] irq_vsync::vera_layer_set_vertical_scroll1_$0 = < irq_vsync::vera_layer_set_vertical_scroll1_scroll#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_layer_set_vertical_scroll1_scroll
    // *vera_layer_vscroll_l[layer] = <scroll
    // [45] *(*vera_layer_vscroll_l) = irq_vsync::vera_layer_set_vertical_scroll1_$0 -- _deref_(_deref_qbuc1)=vbuaa 
    ldy vera_layer_vscroll_l
    sty.z $fe
    ldy vera_layer_vscroll_l+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // >scroll
    // [46] irq_vsync::vera_layer_set_vertical_scroll1_$1 = > irq_vsync::vera_layer_set_vertical_scroll1_scroll#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_layer_set_vertical_scroll1_scroll+1
    // *vera_layer_vscroll_h[layer] = >scroll
    // [47] *(*vera_layer_vscroll_h) = irq_vsync::vera_layer_set_vertical_scroll1_$1 -- _deref_(_deref_qbuc1)=vbuaa 
    ldy vera_layer_vscroll_h
    sty.z $fe
    ldy vera_layer_vscroll_h+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // irq_vsync::@2
  __b2:
    // *VERA_ISR = VERA_VSYNC
    // [48] *VERA_ISR = VERA_VSYNC -- _deref_pbuc1=vbuc2 
    // Reset the VSYNC interrupt
    lda #VERA_VSYNC
    sta VERA_ISR
    // irq_vsync::@return
    // }
    // [49] return 
    // interrupt(isr_rom_sys_cx16_exit) -- isr_rom_sys_cx16_exit 
    jmp $e034
    // [50] phi from irq_vsync::@10 to irq_vsync::@12 [phi:irq_vsync::@10->irq_vsync::@12]
  __b3:
    // [50] phi rem16u#25 = rem16u#51 [phi:irq_vsync::@10->irq_vsync::@12#0] -- register_copy 
    // [50] phi rand_state#23 = rand_state#43 [phi:irq_vsync::@10->irq_vsync::@12#1] -- register_copy 
    // [50] phi irq_vsync::c#2 = 0 [phi:irq_vsync::@10->irq_vsync::@12#2] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // irq_vsync::@12
  __b12:
    // for(byte c=0;c<5;c+=1)
    // [51] if(irq_vsync::c#2<5) goto irq_vsync::@13 -- vbuz1_lt_vbuc1_then_la1 
    lda.z c
    cmp #5
    bcc __b13
    // irq_vsync::@14
    // r+=1
    // [52] irq_vsync::r#1 = irq_vsync::r#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z r
    // [40] phi from irq_vsync::@14 to irq_vsync::@10 [phi:irq_vsync::@14->irq_vsync::@10]
    // [40] phi rem16u#51 = rem16u#25 [phi:irq_vsync::@14->irq_vsync::@10#0] -- register_copy 
    // [40] phi rand_state#43 = rand_state#23 [phi:irq_vsync::@14->irq_vsync::@10#1] -- register_copy 
    // [40] phi irq_vsync::r#2 = irq_vsync::r#1 [phi:irq_vsync::@14->irq_vsync::@10#2] -- register_copy 
    jmp __b10
    // [53] phi from irq_vsync::@12 to irq_vsync::@13 [phi:irq_vsync::@12->irq_vsync::@13]
    // irq_vsync::@13
  __b13:
    // rand()
    // [54] call rand 
    // [321] phi from irq_vsync::@13 to rand [phi:irq_vsync::@13->rand]
    // [321] phi rand_state#13 = rand_state#23 [phi:irq_vsync::@13->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [55] rand::return#2 = rand::return#0
    // irq_vsync::@17
    // modr16u(rand(),3,0)
    // [56] modr16u::dividend#0 = rand::return#2
    // [57] call modr16u 
    // [330] phi from irq_vsync::@17 to modr16u [phi:irq_vsync::@17->modr16u]
    // [330] phi modr16u::dividend#2 = modr16u::dividend#0 [phi:irq_vsync::@17->modr16u#0] -- register_copy 
    jsr modr16u
    // modr16u(rand(),3,0)
    // [58] modr16u::return#2 = modr16u::return#0
    // irq_vsync::@18
    // [59] irq_vsync::$23 = modr16u::return#2 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z __23
    lda.z modr16u.return+1
    sta.z __23+1
    // rnd = (byte)modr16u(rand(),3,0)
    // [60] irq_vsync::rnd#0 = (byte)irq_vsync::$23 -- vbuaa=_byte_vwuz1 
    lda.z __23
    // vera_tile_element( 0, c, r, 3, TileDB[rnd])
    // [61] irq_vsync::$26 = irq_vsync::rnd#0 << 1 -- vbuxx=vbuaa_rol_1 
    asl
    tax
    // [62] vera_tile_element::x#1 = irq_vsync::c#2 -- vbuz1=vbuz2 
    lda.z c
    sta.z vera_tile_element.x
    // [63] vera_tile_element::y#1 = irq_vsync::r#2 -- vbuz1=vbuz2 
    lda.z r
    sta.z vera_tile_element.y
    // [64] vera_tile_element::Tile#0 = TileDB[irq_vsync::$26] -- pssz1=qssc1_derefidx_vbuxx 
    lda TileDB,x
    sta.z vera_tile_element.Tile
    lda TileDB+1,x
    sta.z vera_tile_element.Tile+1
    // [65] call vera_tile_element 
    // [335] phi from irq_vsync::@18 to vera_tile_element [phi:irq_vsync::@18->vera_tile_element]
    // [335] phi vera_tile_element::y#3 = vera_tile_element::y#1 [phi:irq_vsync::@18->vera_tile_element#0] -- register_copy 
    // [335] phi vera_tile_element::x#3 = vera_tile_element::x#1 [phi:irq_vsync::@18->vera_tile_element#1] -- register_copy 
    // [335] phi vera_tile_element::Tile#2 = vera_tile_element::Tile#0 [phi:irq_vsync::@18->vera_tile_element#2] -- register_copy 
    jsr vera_tile_element
    // irq_vsync::@19
    // c+=1
    // [66] irq_vsync::c#1 = irq_vsync::c#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z c
    // [50] phi from irq_vsync::@19 to irq_vsync::@12 [phi:irq_vsync::@19->irq_vsync::@12]
    // [50] phi rem16u#25 = divr16u::rem#10 [phi:irq_vsync::@19->irq_vsync::@12#0] -- register_copy 
    // [50] phi rand_state#23 = rand_state#14 [phi:irq_vsync::@19->irq_vsync::@12#1] -- register_copy 
    // [50] phi irq_vsync::c#2 = irq_vsync::c#1 [phi:irq_vsync::@19->irq_vsync::@12#2] -- register_copy 
    jmp __b12
}
  // conio_x16_init
// Set initial cursor position
conio_x16_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label line = 9
    // line = *BASIC_CURSOR_LINE
    // [67] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda BASIC_CURSOR_LINE
    sta.z line
    // vera_layer_mode_text(1,(dword)0x00000,(dword)0x0F800,128,64,8,8,16)
    // [68] call vera_layer_mode_text 
    // [393] phi from conio_x16_init to vera_layer_mode_text [phi:conio_x16_init->vera_layer_mode_text]
    jsr vera_layer_mode_text
    // [69] phi from conio_x16_init to conio_x16_init::@3 [phi:conio_x16_init->conio_x16_init::@3]
    // conio_x16_init::@3
    // screensize(&cx16_conio.conio_screen_width, &cx16_conio.conio_screen_height)
    // [70] call screensize 
    jsr screensize
    // [71] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // screenlayer(1)
    // [72] call screenlayer 
    jsr screenlayer
    // [73] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // vera_layer_set_textcolor(1, WHITE)
    // [74] call vera_layer_set_textcolor 
    // [435] phi from conio_x16_init::@5 to vera_layer_set_textcolor [phi:conio_x16_init::@5->vera_layer_set_textcolor]
    // [435] phi vera_layer_set_textcolor::layer#2 = 1 [phi:conio_x16_init::@5->vera_layer_set_textcolor#0] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_set_textcolor
    // [75] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // vera_layer_set_backcolor(1, BLUE)
    // [76] call vera_layer_set_backcolor 
    // [438] phi from conio_x16_init::@6 to vera_layer_set_backcolor [phi:conio_x16_init::@6->vera_layer_set_backcolor]
    // [438] phi vera_layer_set_backcolor::color#2 = BLUE [phi:conio_x16_init::@6->vera_layer_set_backcolor#0] -- vbuaa=vbuc1 
    lda #BLUE
    // [438] phi vera_layer_set_backcolor::layer#2 = 1 [phi:conio_x16_init::@6->vera_layer_set_backcolor#1] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_set_backcolor
    // [77] phi from conio_x16_init::@6 to conio_x16_init::@7 [phi:conio_x16_init::@6->conio_x16_init::@7]
    // conio_x16_init::@7
    // vera_layer_set_mapbase(0,0x20)
    // [78] call vera_layer_set_mapbase 
    // [441] phi from conio_x16_init::@7 to vera_layer_set_mapbase [phi:conio_x16_init::@7->vera_layer_set_mapbase]
    // [441] phi vera_layer_set_mapbase::mapbase#3 = $20 [phi:conio_x16_init::@7->vera_layer_set_mapbase#0] -- vbuxx=vbuc1 
    ldx #$20
    // [441] phi vera_layer_set_mapbase::layer#3 = 0 [phi:conio_x16_init::@7->vera_layer_set_mapbase#1] -- vbuaa=vbuc1 
    lda #0
    jsr vera_layer_set_mapbase
    // [79] phi from conio_x16_init::@7 to conio_x16_init::@8 [phi:conio_x16_init::@7->conio_x16_init::@8]
    // conio_x16_init::@8
    // vera_layer_set_mapbase(1,0x00)
    // [80] call vera_layer_set_mapbase 
    // [441] phi from conio_x16_init::@8 to vera_layer_set_mapbase [phi:conio_x16_init::@8->vera_layer_set_mapbase]
    // [441] phi vera_layer_set_mapbase::mapbase#3 = 0 [phi:conio_x16_init::@8->vera_layer_set_mapbase#0] -- vbuxx=vbuc1 
    ldx #0
    // [441] phi vera_layer_set_mapbase::layer#3 = 1 [phi:conio_x16_init::@8->vera_layer_set_mapbase#1] -- vbuaa=vbuc1 
    lda #1
    jsr vera_layer_set_mapbase
    // [81] phi from conio_x16_init::@8 to conio_x16_init::@9 [phi:conio_x16_init::@8->conio_x16_init::@9]
    // conio_x16_init::@9
    // cursor(0)
    // [82] call cursor 
    jsr cursor
    // conio_x16_init::@10
    // if(line>=cx16_conio.conio_screen_height)
    // [83] if(conio_x16_init::line#0<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto conio_x16_init::@1 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z line
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b1
    // conio_x16_init::@2
    // line=cx16_conio.conio_screen_height-1
    // [84] conio_x16_init::line#1 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    stx.z line
    // [85] phi from conio_x16_init::@10 conio_x16_init::@2 to conio_x16_init::@1 [phi:conio_x16_init::@10/conio_x16_init::@2->conio_x16_init::@1]
    // [85] phi conio_x16_init::line#3 = conio_x16_init::line#0 [phi:conio_x16_init::@10/conio_x16_init::@2->conio_x16_init::@1#0] -- register_copy 
    // conio_x16_init::@1
  __b1:
    // gotoxy(0, line)
    // [86] gotoxy::y#0 = conio_x16_init::line#3 -- vbuxx=vbuz1 
    ldx.z line
    // [87] call gotoxy 
    // [448] phi from conio_x16_init::@1 to gotoxy [phi:conio_x16_init::@1->gotoxy]
    // [448] phi gotoxy::y#3 = gotoxy::y#0 [phi:conio_x16_init::@1->gotoxy#0] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [88] return 
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
    .label status = $4b
    .label status_1 = $4c
    .label vram_petscii_map = $54
    .label vram_petscii_tile = $17
    .label vram_address = $13
    .label status_2 = $4e
    .label status_3 = $4f
    .label status_4 = $50
    .label status_5 = $51
    .label status_6 = $4d
    // TileDB[0] = &SquareMetal
    // [89] *TileDB = &SquareMetal -- _deref_qssc1=pssc2 
    lda #<SquareMetal
    sta TileDB
    lda #>SquareMetal
    sta TileDB+1
    // TileDB[1] = &TileMetal
    // [90] *(TileDB+1*SIZEOF_POINTER) = &TileMetal -- _deref_qssc1=pssc2 
    lda #<TileMetal
    sta TileDB+1*SIZEOF_POINTER
    lda #>TileMetal
    sta TileDB+1*SIZEOF_POINTER+1
    // TileDB[2] = &SquareRaster
    // [91] *(TileDB+2*SIZEOF_POINTER) = &SquareRaster -- _deref_qssc1=pssc2 
    lda #<SquareRaster
    sta TileDB+2*SIZEOF_POINTER
    lda #>SquareRaster
    sta TileDB+2*SIZEOF_POINTER+1
    // cx16_load_ram_banked(1, 8, 0, FILE_SPRITES, (dword)BRAM_PLAYER)
    // [92] call cx16_load_ram_banked 
    // [461] phi from main to cx16_load_ram_banked [phi:main->cx16_load_ram_banked]
    // [461] phi cx16_load_ram_banked::filename#7 = FILE_SPRITES [phi:main->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_SPRITES
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_SPRITES
    sta.z cx16_load_ram_banked.filename+1
    // [461] phi cx16_load_ram_banked::address#7 = BRAM_PLAYER [phi:main->cx16_load_ram_banked#1] -- vduz1=vduc1 
    lda #<BRAM_PLAYER
    sta.z cx16_load_ram_banked.address
    lda #>BRAM_PLAYER
    sta.z cx16_load_ram_banked.address+1
    lda #<BRAM_PLAYER>>$10
    sta.z cx16_load_ram_banked.address+2
    lda #>BRAM_PLAYER>>$10
    sta.z cx16_load_ram_banked.address+3
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, FILE_SPRITES, (dword)BRAM_PLAYER)
    // [93] cx16_load_ram_banked::return#12 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@20
    // status = cx16_load_ram_banked(1, 8, 0, FILE_SPRITES, (dword)BRAM_PLAYER)
    // [94] main::status#0 = cx16_load_ram_banked::return#12 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$ff)
    // [95] if(main::status#0==$ff) goto main::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [96] phi from main::@20 to main::@8 [phi:main::@20->main::@8]
    // main::@8
    // printf("error file_sprites: %x\n",status)
    // [97] call cputs 
    // [528] phi from main::@8 to cputs [phi:main::@8->cputs]
    // [528] phi cputs::s#19 = main::s [phi:main::@8->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@22
    // printf("error file_sprites: %x\n",status)
    // [98] printf_uchar::uvalue#0 = main::status#0 -- vbuxx=vbuz1 
    ldx.z status
    // [99] call printf_uchar 
    // [536] phi from main::@22 to printf_uchar [phi:main::@22->printf_uchar]
    // [536] phi printf_uchar::format_radix#10 = HEXADECIMAL [phi:main::@22->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [536] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#0 [phi:main::@22->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [100] phi from main::@22 to main::@23 [phi:main::@22->main::@23]
    // main::@23
    // printf("error file_sprites: %x\n",status)
    // [101] call cputs 
    // [528] phi from main::@23 to cputs [phi:main::@23->cputs]
    // [528] phi cputs::s#19 = s1 [phi:main::@23->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [102] phi from main::@20 main::@23 to main::@1 [phi:main::@20/main::@23->main::@1]
    // main::@1
  __b1:
    // cx16_load_ram_banked(1, 8, 0, FILE_ENEMY2, (dword)BRAM_ENEMY2)
    // [103] call cx16_load_ram_banked 
    // [461] phi from main::@1 to cx16_load_ram_banked [phi:main::@1->cx16_load_ram_banked]
    // [461] phi cx16_load_ram_banked::filename#7 = FILE_ENEMY2 [phi:main::@1->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_ENEMY2
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_ENEMY2
    sta.z cx16_load_ram_banked.filename+1
    // [461] phi cx16_load_ram_banked::address#7 = BRAM_ENEMY2 [phi:main::@1->cx16_load_ram_banked#1] -- vduz1=vduc1 
    lda #<BRAM_ENEMY2
    sta.z cx16_load_ram_banked.address
    lda #>BRAM_ENEMY2
    sta.z cx16_load_ram_banked.address+1
    lda #<BRAM_ENEMY2>>$10
    sta.z cx16_load_ram_banked.address+2
    lda #>BRAM_ENEMY2>>$10
    sta.z cx16_load_ram_banked.address+3
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, FILE_ENEMY2, (dword)BRAM_ENEMY2)
    // [104] cx16_load_ram_banked::return#13 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@21
    // status = cx16_load_ram_banked(1, 8, 0, FILE_ENEMY2, (dword)BRAM_ENEMY2)
    // [105] main::status#1 = cx16_load_ram_banked::return#13 -- vbuz1=vbuaa 
    sta.z status_1
    // if(status!=$ff)
    // [106] if(main::status#1==$ff) goto main::@2 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status_1
    beq __b2
    // [107] phi from main::@21 to main::@9 [phi:main::@21->main::@9]
    // main::@9
    // printf("error file_enemy2 = %x\n",status)
    // [108] call cputs 
    // [528] phi from main::@9 to cputs [phi:main::@9->cputs]
    // [528] phi cputs::s#19 = main::s2 [phi:main::@9->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@25
    // printf("error file_enemy2 = %x\n",status)
    // [109] printf_uchar::uvalue#1 = main::status#1 -- vbuxx=vbuz1 
    ldx.z status_1
    // [110] call printf_uchar 
    // [536] phi from main::@25 to printf_uchar [phi:main::@25->printf_uchar]
    // [536] phi printf_uchar::format_radix#10 = HEXADECIMAL [phi:main::@25->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [536] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#1 [phi:main::@25->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [111] phi from main::@25 to main::@26 [phi:main::@25->main::@26]
    // main::@26
    // printf("error file_enemy2 = %x\n",status)
    // [112] call cputs 
    // [528] phi from main::@26 to cputs [phi:main::@26->cputs]
    // [528] phi cputs::s#19 = s1 [phi:main::@26->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [113] phi from main::@21 main::@26 to main::@2 [phi:main::@21/main::@26->main::@2]
    // main::@2
  __b2:
    // cx16_load_ram_banked(1, 8, 0, FILE_TILES, (dword)BANK_TILES_SMALL)
    // [114] call cx16_load_ram_banked 
    // [461] phi from main::@2 to cx16_load_ram_banked [phi:main::@2->cx16_load_ram_banked]
    // [461] phi cx16_load_ram_banked::filename#7 = FILE_TILES [phi:main::@2->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_TILES
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_TILES
    sta.z cx16_load_ram_banked.filename+1
    // [461] phi cx16_load_ram_banked::address#7 = BANK_TILES_SMALL [phi:main::@2->cx16_load_ram_banked#1] -- vduz1=vduc1 
    lda #<BANK_TILES_SMALL
    sta.z cx16_load_ram_banked.address
    lda #>BANK_TILES_SMALL
    sta.z cx16_load_ram_banked.address+1
    lda #<BANK_TILES_SMALL>>$10
    sta.z cx16_load_ram_banked.address+2
    lda #>BANK_TILES_SMALL>>$10
    sta.z cx16_load_ram_banked.address+3
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, FILE_TILES, (dword)BANK_TILES_SMALL)
    // [115] cx16_load_ram_banked::return#14 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@24
    // status = cx16_load_ram_banked(1, 8, 0, FILE_TILES, (dword)BANK_TILES_SMALL)
    // [116] main::status#16 = cx16_load_ram_banked::return#14 -- vbuz1=vbuaa 
    sta.z status_6
    // if(status!=$ff)
    // [117] if(main::status#16==$ff) goto main::@3 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status_6
    beq __b3
    // [118] phi from main::@24 to main::@10 [phi:main::@24->main::@10]
    // main::@10
    // printf("error file_tiles = %x\n",status)
    // [119] call cputs 
    // [528] phi from main::@10 to cputs [phi:main::@10->cputs]
    // [528] phi cputs::s#19 = main::s4 [phi:main::@10->cputs#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // main::@28
    // printf("error file_tiles = %x\n",status)
    // [120] printf_uchar::uvalue#2 = main::status#16 -- vbuxx=vbuz1 
    ldx.z status_6
    // [121] call printf_uchar 
    // [536] phi from main::@28 to printf_uchar [phi:main::@28->printf_uchar]
    // [536] phi printf_uchar::format_radix#10 = HEXADECIMAL [phi:main::@28->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [536] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#2 [phi:main::@28->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [122] phi from main::@28 to main::@29 [phi:main::@28->main::@29]
    // main::@29
    // printf("error file_tiles = %x\n",status)
    // [123] call cputs 
    // [528] phi from main::@29 to cputs [phi:main::@29->cputs]
    // [528] phi cputs::s#19 = s1 [phi:main::@29->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [124] phi from main::@24 main::@29 to main::@3 [phi:main::@24/main::@29->main::@3]
    // main::@3
  __b3:
    // cx16_load_ram_banked(1, 8, 0, FILE_SQUAREMETAL, (dword)BANK_SQUAREMETAL)
    // [125] call cx16_load_ram_banked 
    // [461] phi from main::@3 to cx16_load_ram_banked [phi:main::@3->cx16_load_ram_banked]
    // [461] phi cx16_load_ram_banked::filename#7 = FILE_SQUAREMETAL [phi:main::@3->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_SQUAREMETAL
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_SQUAREMETAL
    sta.z cx16_load_ram_banked.filename+1
    // [461] phi cx16_load_ram_banked::address#7 = BANK_SQUAREMETAL [phi:main::@3->cx16_load_ram_banked#1] -- vduz1=vduc1 
    lda #<BANK_SQUAREMETAL
    sta.z cx16_load_ram_banked.address
    lda #>BANK_SQUAREMETAL
    sta.z cx16_load_ram_banked.address+1
    lda #<BANK_SQUAREMETAL>>$10
    sta.z cx16_load_ram_banked.address+2
    lda #>BANK_SQUAREMETAL>>$10
    sta.z cx16_load_ram_banked.address+3
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, FILE_SQUAREMETAL, (dword)BANK_SQUAREMETAL)
    // [126] cx16_load_ram_banked::return#15 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@27
    // status = cx16_load_ram_banked(1, 8, 0, FILE_SQUAREMETAL, (dword)BANK_SQUAREMETAL)
    // [127] main::status#10 = cx16_load_ram_banked::return#15 -- vbuz1=vbuaa 
    sta.z status_2
    // if(status!=$ff)
    // [128] if(main::status#10==$ff) goto main::@4 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status_2
    beq __b4
    // [129] phi from main::@27 to main::@11 [phi:main::@27->main::@11]
    // main::@11
    // printf("error file_squaremetal = %x\n",status)
    // [130] call cputs 
    // [528] phi from main::@11 to cputs [phi:main::@11->cputs]
    // [528] phi cputs::s#19 = main::s6 [phi:main::@11->cputs#0] -- pbuz1=pbuc1 
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
    // main::@31
    // printf("error file_squaremetal = %x\n",status)
    // [131] printf_uchar::uvalue#3 = main::status#10 -- vbuxx=vbuz1 
    ldx.z status_2
    // [132] call printf_uchar 
    // [536] phi from main::@31 to printf_uchar [phi:main::@31->printf_uchar]
    // [536] phi printf_uchar::format_radix#10 = HEXADECIMAL [phi:main::@31->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [536] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#3 [phi:main::@31->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [133] phi from main::@31 to main::@32 [phi:main::@31->main::@32]
    // main::@32
    // printf("error file_squaremetal = %x\n",status)
    // [134] call cputs 
    // [528] phi from main::@32 to cputs [phi:main::@32->cputs]
    // [528] phi cputs::s#19 = s1 [phi:main::@32->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [135] phi from main::@27 main::@32 to main::@4 [phi:main::@27/main::@32->main::@4]
    // main::@4
  __b4:
    // cx16_load_ram_banked(1, 8, 0, FILE_TILEMETAL, (dword)BANK_TILEMETAL)
    // [136] call cx16_load_ram_banked 
    // [461] phi from main::@4 to cx16_load_ram_banked [phi:main::@4->cx16_load_ram_banked]
    // [461] phi cx16_load_ram_banked::filename#7 = FILE_TILEMETAL [phi:main::@4->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_TILEMETAL
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_TILEMETAL
    sta.z cx16_load_ram_banked.filename+1
    // [461] phi cx16_load_ram_banked::address#7 = BANK_TILEMETAL [phi:main::@4->cx16_load_ram_banked#1] -- vduz1=vduc1 
    lda #<BANK_TILEMETAL
    sta.z cx16_load_ram_banked.address
    lda #>BANK_TILEMETAL
    sta.z cx16_load_ram_banked.address+1
    lda #<BANK_TILEMETAL>>$10
    sta.z cx16_load_ram_banked.address+2
    lda #>BANK_TILEMETAL>>$10
    sta.z cx16_load_ram_banked.address+3
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, FILE_TILEMETAL, (dword)BANK_TILEMETAL)
    // [137] cx16_load_ram_banked::return#16 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@30
    // status = cx16_load_ram_banked(1, 8, 0, FILE_TILEMETAL, (dword)BANK_TILEMETAL)
    // [138] main::status#11 = cx16_load_ram_banked::return#16 -- vbuz1=vbuaa 
    sta.z status_3
    // if(status!=$ff)
    // [139] if(main::status#11==$ff) goto main::@5 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status_3
    beq __b5
    // [140] phi from main::@30 to main::@12 [phi:main::@30->main::@12]
    // main::@12
    // printf("error file_tilemetal = %x\n",status)
    // [141] call cputs 
    // [528] phi from main::@12 to cputs [phi:main::@12->cputs]
    // [528] phi cputs::s#19 = main::s8 [phi:main::@12->cputs#0] -- pbuz1=pbuc1 
    lda #<s8
    sta.z cputs.s
    lda #>s8
    sta.z cputs.s+1
    jsr cputs
    // main::@34
    // printf("error file_tilemetal = %x\n",status)
    // [142] printf_uchar::uvalue#4 = main::status#11 -- vbuxx=vbuz1 
    ldx.z status_3
    // [143] call printf_uchar 
    // [536] phi from main::@34 to printf_uchar [phi:main::@34->printf_uchar]
    // [536] phi printf_uchar::format_radix#10 = HEXADECIMAL [phi:main::@34->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [536] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#4 [phi:main::@34->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [144] phi from main::@34 to main::@35 [phi:main::@34->main::@35]
    // main::@35
    // printf("error file_tilemetal = %x\n",status)
    // [145] call cputs 
    // [528] phi from main::@35 to cputs [phi:main::@35->cputs]
    // [528] phi cputs::s#19 = s1 [phi:main::@35->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [146] phi from main::@30 main::@35 to main::@5 [phi:main::@30/main::@35->main::@5]
    // main::@5
  __b5:
    // cx16_load_ram_banked(1, 8, 0, FILE_SQUARERASTER, (dword)BANK_SQUARERASTER)
    // [147] call cx16_load_ram_banked 
    // [461] phi from main::@5 to cx16_load_ram_banked [phi:main::@5->cx16_load_ram_banked]
    // [461] phi cx16_load_ram_banked::filename#7 = FILE_SQUARERASTER [phi:main::@5->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_SQUARERASTER
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_SQUARERASTER
    sta.z cx16_load_ram_banked.filename+1
    // [461] phi cx16_load_ram_banked::address#7 = BANK_SQUARERASTER [phi:main::@5->cx16_load_ram_banked#1] -- vduz1=vduc1 
    lda #<BANK_SQUARERASTER
    sta.z cx16_load_ram_banked.address
    lda #>BANK_SQUARERASTER
    sta.z cx16_load_ram_banked.address+1
    lda #<BANK_SQUARERASTER>>$10
    sta.z cx16_load_ram_banked.address+2
    lda #>BANK_SQUARERASTER>>$10
    sta.z cx16_load_ram_banked.address+3
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, FILE_SQUARERASTER, (dword)BANK_SQUARERASTER)
    // [148] cx16_load_ram_banked::return#17 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@33
    // status = cx16_load_ram_banked(1, 8, 0, FILE_SQUARERASTER, (dword)BANK_SQUARERASTER)
    // [149] main::status#12 = cx16_load_ram_banked::return#17 -- vbuz1=vbuaa 
    sta.z status_4
    // if(status!=$ff)
    // [150] if(main::status#12==$ff) goto main::@6 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status_4
    beq __b6
    // [151] phi from main::@33 to main::@13 [phi:main::@33->main::@13]
    // main::@13
    // printf("error file_squareraster = %x\n",status)
    // [152] call cputs 
    // [528] phi from main::@13 to cputs [phi:main::@13->cputs]
    // [528] phi cputs::s#19 = main::s10 [phi:main::@13->cputs#0] -- pbuz1=pbuc1 
    lda #<s10
    sta.z cputs.s
    lda #>s10
    sta.z cputs.s+1
    jsr cputs
    // main::@37
    // printf("error file_squareraster = %x\n",status)
    // [153] printf_uchar::uvalue#5 = main::status#12 -- vbuxx=vbuz1 
    ldx.z status_4
    // [154] call printf_uchar 
    // [536] phi from main::@37 to printf_uchar [phi:main::@37->printf_uchar]
    // [536] phi printf_uchar::format_radix#10 = HEXADECIMAL [phi:main::@37->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [536] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#5 [phi:main::@37->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [155] phi from main::@37 to main::@38 [phi:main::@37->main::@38]
    // main::@38
    // printf("error file_squareraster = %x\n",status)
    // [156] call cputs 
    // [528] phi from main::@38 to cputs [phi:main::@38->cputs]
    // [528] phi cputs::s#19 = s1 [phi:main::@38->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [157] phi from main::@33 main::@38 to main::@6 [phi:main::@33/main::@38->main::@6]
    // main::@6
  __b6:
    // cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, (dword)BANK_PALETTE)
    // [158] call cx16_load_ram_banked 
    // [461] phi from main::@6 to cx16_load_ram_banked [phi:main::@6->cx16_load_ram_banked]
    // [461] phi cx16_load_ram_banked::filename#7 = FILE_PALETTES [phi:main::@6->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_PALETTES
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_PALETTES
    sta.z cx16_load_ram_banked.filename+1
    // [461] phi cx16_load_ram_banked::address#7 = BANK_PALETTE [phi:main::@6->cx16_load_ram_banked#1] -- vduz1=vduc1 
    lda #<BANK_PALETTE
    sta.z cx16_load_ram_banked.address
    lda #>BANK_PALETTE
    sta.z cx16_load_ram_banked.address+1
    lda #<BANK_PALETTE>>$10
    sta.z cx16_load_ram_banked.address+2
    lda #>BANK_PALETTE>>$10
    sta.z cx16_load_ram_banked.address+3
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, (dword)BANK_PALETTE)
    // [159] cx16_load_ram_banked::return#10 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@36
    // status = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, (dword)BANK_PALETTE)
    // [160] main::status#13 = cx16_load_ram_banked::return#10 -- vbuz1=vbuaa 
    sta.z status_5
    // if(status!=$ff)
    // [161] if(main::status#13==$ff) goto main::@7 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status_5
    beq __b7
    // [162] phi from main::@36 to main::@14 [phi:main::@36->main::@14]
    // main::@14
    // printf("error file_palettes = %u",status)
    // [163] call cputs 
    // [528] phi from main::@14 to cputs [phi:main::@14->cputs]
    // [528] phi cputs::s#19 = main::s12 [phi:main::@14->cputs#0] -- pbuz1=pbuc1 
    lda #<s12
    sta.z cputs.s
    lda #>s12
    sta.z cputs.s+1
    jsr cputs
    // main::@58
    // printf("error file_palettes = %u",status)
    // [164] printf_uchar::uvalue#6 = main::status#13 -- vbuxx=vbuz1 
    ldx.z status_5
    // [165] call printf_uchar 
    // [536] phi from main::@58 to printf_uchar [phi:main::@58->printf_uchar]
    // [536] phi printf_uchar::format_radix#10 = DECIMAL [phi:main::@58->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #DECIMAL
    // [536] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#6 [phi:main::@58->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [166] phi from main::@36 main::@58 to main::@7 [phi:main::@36/main::@58->main::@7]
    // main::@7
  __b7:
    // cx16_rom_bank(0)
    // [167] call cx16_rom_bank 
  // We are going to use only the kernal on the X16.
    // [544] phi from main::@7 to cx16_rom_bank [phi:main::@7->cx16_rom_bank]
    // [544] phi cx16_rom_bank::bank#2 = 0 [phi:main::@7->cx16_rom_bank#0] -- vbuaa=vbuc1 
    lda #0
    jsr cx16_rom_bank
    // [168] phi from main::@7 to main::@39 [phi:main::@7->main::@39]
    // main::@39
    // vera_heap_segment_init(HEAP_PETSCII, 0x1B000, VRAM_PETSCII_MAP_SIZE + VERA_PETSCII_TILE_SIZE)
    // [169] call vera_heap_segment_init 
    // [547] phi from main::@39 to vera_heap_segment_init [phi:main::@39->vera_heap_segment_init]
    // [547] phi vera_heap_segment_init::base#4 = $1b000 [phi:main::@39->vera_heap_segment_init#0] -- vduz1=vduc1 
    lda #<$1b000
    sta.z vera_heap_segment_init.base
    lda #>$1b000
    sta.z vera_heap_segment_init.base+1
    lda #<$1b000>>$10
    sta.z vera_heap_segment_init.base+2
    lda #>$1b000>>$10
    sta.z vera_heap_segment_init.base+3
    // [547] phi vera_heap_segment_init::size#4 = main::VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE [phi:main::@39->vera_heap_segment_init#1] -- vduz1=vduc1 
    lda #<VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE
    sta.z vera_heap_segment_init.size
    lda #>VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE
    sta.z vera_heap_segment_init.size+1
    lda #<VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+2
    lda #>VRAM_PETSCII_MAP_SIZE+VERA_PETSCII_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+3
    // [547] phi vera_heap_segment_init::segmentid#4 = HEAP_PETSCII [phi:main::@39->vera_heap_segment_init#2] -- vbuxx=vbuc1 
    ldx #HEAP_PETSCII
    jsr vera_heap_segment_init
    // main::@40
    // vera_heap_malloc(HEAP_PETSCII, VRAM_PETSCII_MAP_SIZE)
    // [170] vera_heap_malloc::size = main::VRAM_PETSCII_MAP_SIZE -- vwuz1=vwuc1 
    lda #<VRAM_PETSCII_MAP_SIZE
    sta.z vera_heap_malloc.size
    lda #>VRAM_PETSCII_MAP_SIZE
    sta.z vera_heap_malloc.size+1
    // [171] call vera_heap_malloc 
    // [563] phi from main::@40 to vera_heap_malloc [phi:main::@40->vera_heap_malloc]
    // [563] phi vera_heap_malloc::segmentid#4 = HEAP_PETSCII [phi:main::@40->vera_heap_malloc#0] -- vbuxx=vbuc1 
    ldx #HEAP_PETSCII
    jsr vera_heap_malloc
    // vera_heap_malloc(HEAP_PETSCII, VRAM_PETSCII_MAP_SIZE)
    // [172] vera_heap_malloc::return#12 = vera_heap_malloc::return#1
    // main::@41
    // vram_petscii_map = vera_heap_malloc(HEAP_PETSCII, VRAM_PETSCII_MAP_SIZE)
    // [173] main::vram_petscii_map#0 = vera_heap_malloc::return#12 -- vduz1=vduz2 
    lda.z vera_heap_malloc.return
    sta.z vram_petscii_map
    lda.z vera_heap_malloc.return+1
    sta.z vram_petscii_map+1
    lda.z vera_heap_malloc.return+2
    sta.z vram_petscii_map+2
    lda.z vera_heap_malloc.return+3
    sta.z vram_petscii_map+3
    // vera_heap_malloc(HEAP_PETSCII, VERA_PETSCII_TILE_SIZE)
    // [174] vera_heap_malloc::size = VERA_PETSCII_TILE_SIZE -- vwuz1=vwuc1 
    lda #<VERA_PETSCII_TILE_SIZE
    sta.z vera_heap_malloc.size
    lda #>VERA_PETSCII_TILE_SIZE
    sta.z vera_heap_malloc.size+1
    // [175] call vera_heap_malloc 
    // [563] phi from main::@41 to vera_heap_malloc [phi:main::@41->vera_heap_malloc]
    // [563] phi vera_heap_malloc::segmentid#4 = HEAP_PETSCII [phi:main::@41->vera_heap_malloc#0] -- vbuxx=vbuc1 
    ldx #HEAP_PETSCII
    jsr vera_heap_malloc
    // vera_heap_malloc(HEAP_PETSCII, VERA_PETSCII_TILE_SIZE)
    // [176] vera_heap_malloc::return#13 = vera_heap_malloc::return#1
    // main::@42
    // vram_petscii_tile = vera_heap_malloc(HEAP_PETSCII, VERA_PETSCII_TILE_SIZE)
    // [177] main::vram_petscii_tile#0 = vera_heap_malloc::return#13
    // vera_cpy_vram_vram(VERA_PETSCII_TILE, VRAM_PETSCII_TILE, VERA_PETSCII_TILE_SIZE)
    // [178] call vera_cpy_vram_vram 
    jsr vera_cpy_vram_vram
    // main::@43
    // vera_layer_mode_tile(1, vram_petscii_map, vram_petscii_tile, 128, 64, 8, 8, 1)
    // [179] vera_layer_mode_tile::mapbase_address#2 = main::vram_petscii_map#0 -- vduz1=vduz2 
    lda.z vram_petscii_map
    sta.z vera_layer_mode_tile.mapbase_address
    lda.z vram_petscii_map+1
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda.z vram_petscii_map+2
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda.z vram_petscii_map+3
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [180] vera_layer_mode_tile::tilebase_address#2 = main::vram_petscii_tile#0 -- vduz1=vduz2 
    lda.z vram_petscii_tile
    sta.z vera_layer_mode_tile.tilebase_address
    lda.z vram_petscii_tile+1
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda.z vram_petscii_tile+2
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda.z vram_petscii_tile+3
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [181] call vera_layer_mode_tile 
    // [644] phi from main::@43 to vera_layer_mode_tile [phi:main::@43->vera_layer_mode_tile]
    // [644] phi vera_layer_mode_tile::tileheight#10 = 8 [phi:main::@43->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [644] phi vera_layer_mode_tile::tilewidth#10 = 8 [phi:main::@43->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [644] phi vera_layer_mode_tile::tilebase_address#10 = vera_layer_mode_tile::tilebase_address#2 [phi:main::@43->vera_layer_mode_tile#2] -- register_copy 
    // [644] phi vera_layer_mode_tile::mapbase_address#10 = vera_layer_mode_tile::mapbase_address#2 [phi:main::@43->vera_layer_mode_tile#3] -- register_copy 
    // [644] phi vera_layer_mode_tile::mapheight#10 = $40 [phi:main::@43->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [644] phi vera_layer_mode_tile::layer#10 = 1 [phi:main::@43->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.layer
    // [644] phi vera_layer_mode_tile::mapwidth#10 = $80 [phi:main::@43->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [644] phi vera_layer_mode_tile::color_depth#3 = 1 [phi:main::@43->vera_layer_mode_tile#7] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_mode_tile
    // [182] phi from main::@43 to main::@44 [phi:main::@43->main::@44]
    // main::@44
    // screenlayer(1)
    // [183] call screenlayer 
    jsr screenlayer
    // main::textcolor1
    // vera_layer_set_textcolor(cx16_conio.conio_screen_layer, color)
    // [184] vera_layer_set_textcolor::layer#1 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [185] call vera_layer_set_textcolor 
    // [435] phi from main::textcolor1 to vera_layer_set_textcolor [phi:main::textcolor1->vera_layer_set_textcolor]
    // [435] phi vera_layer_set_textcolor::layer#2 = vera_layer_set_textcolor::layer#1 [phi:main::textcolor1->vera_layer_set_textcolor#0] -- register_copy 
    jsr vera_layer_set_textcolor
    // main::bgcolor1
    // vera_layer_set_backcolor(cx16_conio.conio_screen_layer, color)
    // [186] vera_layer_set_backcolor::layer#1 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [187] call vera_layer_set_backcolor 
    // [438] phi from main::bgcolor1 to vera_layer_set_backcolor [phi:main::bgcolor1->vera_layer_set_backcolor]
    // [438] phi vera_layer_set_backcolor::color#2 = BLACK [phi:main::bgcolor1->vera_layer_set_backcolor#0] -- vbuaa=vbuc1 
    lda #BLACK
    // [438] phi vera_layer_set_backcolor::layer#2 = vera_layer_set_backcolor::layer#1 [phi:main::bgcolor1->vera_layer_set_backcolor#1] -- register_copy 
    jsr vera_layer_set_backcolor
    // [188] phi from main::bgcolor1 to main::@17 [phi:main::bgcolor1->main::@17]
    // main::@17
    // clrscr()
    // [189] call clrscr 
    jsr clrscr
    // [190] phi from main::@17 to main::@45 [phi:main::@17->main::@45]
    // main::@45
    // vera_heap_segment_init(HEAP_SPRITES, VRAM_BASE, VRAM_SPRITES_SIZE)
    // [191] call vera_heap_segment_init 
    // [547] phi from main::@45 to vera_heap_segment_init [phi:main::@45->vera_heap_segment_init]
    // [547] phi vera_heap_segment_init::base#4 = VRAM_BASE [phi:main::@45->vera_heap_segment_init#0] -- vduz1=vduc1 
    lda #<VRAM_BASE
    sta.z vera_heap_segment_init.base
    lda #>VRAM_BASE
    sta.z vera_heap_segment_init.base+1
    lda #<VRAM_BASE>>$10
    sta.z vera_heap_segment_init.base+2
    lda #>VRAM_BASE>>$10
    sta.z vera_heap_segment_init.base+3
    // [547] phi vera_heap_segment_init::size#4 = main::VRAM_SPRITES_SIZE [phi:main::@45->vera_heap_segment_init#1] -- vduz1=vduc1 
    lda #<VRAM_SPRITES_SIZE
    sta.z vera_heap_segment_init.size
    lda #>VRAM_SPRITES_SIZE
    sta.z vera_heap_segment_init.size+1
    lda #<VRAM_SPRITES_SIZE>>$10
    sta.z vera_heap_segment_init.size+2
    lda #>VRAM_SPRITES_SIZE>>$10
    sta.z vera_heap_segment_init.size+3
    // [547] phi vera_heap_segment_init::segmentid#4 = HEAP_SPRITES [phi:main::@45->vera_heap_segment_init#2] -- vbuxx=vbuc1 
    ldx #HEAP_SPRITES
    jsr vera_heap_segment_init
    // vera_heap_segment_init(HEAP_SPRITES, VRAM_BASE, VRAM_SPRITES_SIZE)
    // [192] vera_heap_segment_init::return#3 = vera_heap_segment_init::return#0
    // main::@46
    // vram_address = vera_heap_segment_init(HEAP_SPRITES, VRAM_BASE, VRAM_SPRITES_SIZE)
    // [193] main::vram_address#0 = vera_heap_segment_init::return#3
    // vera_heap_segment_init(HEAP_FLOOR_MAP, vram_address, VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [194] vera_heap_segment_init::base#2 = main::vram_address#0
    // [195] call vera_heap_segment_init 
    // [547] phi from main::@46 to vera_heap_segment_init [phi:main::@46->vera_heap_segment_init]
    // [547] phi vera_heap_segment_init::base#4 = vera_heap_segment_init::base#2 [phi:main::@46->vera_heap_segment_init#0] -- register_copy 
    // [547] phi vera_heap_segment_init::size#4 = main::VRAM_FLOOR_MAP_SIZE+main::VRAM_FLOOR_TILE_SIZE [phi:main::@46->vera_heap_segment_init#1] -- vduz1=vduc1 
    lda #<VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE
    sta.z vera_heap_segment_init.size
    lda #>VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE
    sta.z vera_heap_segment_init.size+1
    lda #<VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+2
    lda #>VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+3
    // [547] phi vera_heap_segment_init::segmentid#4 = HEAP_FLOOR_MAP [phi:main::@46->vera_heap_segment_init#2] -- vbuxx=vbuc1 
    ldx #HEAP_FLOOR_MAP
    jsr vera_heap_segment_init
    // vera_heap_segment_init(HEAP_FLOOR_MAP, vram_address, VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [196] vera_heap_segment_init::return#4 = vera_heap_segment_init::return#0
    // main::@47
    // vram_address = vera_heap_segment_init(HEAP_FLOOR_MAP, vram_address, VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [197] main::vram_address#1 = vera_heap_segment_init::return#4
    // vera_heap_malloc(HEAP_FLOOR_MAP, VRAM_FLOOR_MAP_SIZE)
    // [198] vera_heap_malloc::size = main::VRAM_FLOOR_MAP_SIZE -- vwuz1=vwuc1 
    lda #<VRAM_FLOOR_MAP_SIZE
    sta.z vera_heap_malloc.size
    lda #>VRAM_FLOOR_MAP_SIZE
    sta.z vera_heap_malloc.size+1
    // [199] call vera_heap_malloc 
    // [563] phi from main::@47 to vera_heap_malloc [phi:main::@47->vera_heap_malloc]
    // [563] phi vera_heap_malloc::segmentid#4 = HEAP_FLOOR_MAP [phi:main::@47->vera_heap_malloc#0] -- vbuxx=vbuc1 
    ldx #HEAP_FLOOR_MAP
    jsr vera_heap_malloc
    // vera_heap_malloc(HEAP_FLOOR_MAP, VRAM_FLOOR_MAP_SIZE)
    // [200] vera_heap_malloc::return#14 = vera_heap_malloc::return#1
    // main::@48
    // vram_floor_map = vera_heap_malloc(HEAP_FLOOR_MAP, VRAM_FLOOR_MAP_SIZE)
    // [201] vram_floor_map#0 = vera_heap_malloc::return#14 -- vduz1=vduz2 
    lda.z vera_heap_malloc.return
    sta.z vram_floor_map
    lda.z vera_heap_malloc.return+1
    sta.z vram_floor_map+1
    lda.z vera_heap_malloc.return+2
    sta.z vram_floor_map+2
    lda.z vera_heap_malloc.return+3
    sta.z vram_floor_map+3
    // vera_heap_segment_init(HEAP_FLOOR_TILE, vram_address, VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE)
    // [202] vera_heap_segment_init::base#3 = main::vram_address#1
    // [203] call vera_heap_segment_init 
    // [547] phi from main::@48 to vera_heap_segment_init [phi:main::@48->vera_heap_segment_init]
    // [547] phi vera_heap_segment_init::base#4 = vera_heap_segment_init::base#3 [phi:main::@48->vera_heap_segment_init#0] -- register_copy 
    // [547] phi vera_heap_segment_init::size#4 = main::VRAM_FLOOR_MAP_SIZE+main::VRAM_FLOOR_TILE_SIZE [phi:main::@48->vera_heap_segment_init#1] -- vduz1=vduc1 
    lda #<VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE
    sta.z vera_heap_segment_init.size
    lda #>VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE
    sta.z vera_heap_segment_init.size+1
    lda #<VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+2
    lda #>VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE>>$10
    sta.z vera_heap_segment_init.size+3
    // [547] phi vera_heap_segment_init::segmentid#4 = HEAP_FLOOR_TILE [phi:main::@48->vera_heap_segment_init#2] -- vbuxx=vbuc1 
    ldx #HEAP_FLOOR_TILE
    jsr vera_heap_segment_init
    // [204] phi from main::@48 to main::@49 [phi:main::@48->main::@49]
    // main::@49
    // cpy_graphics(HEAP_SPRITES, BRAM_PLAYER, PlayerSprites, NUM_PLAYER, 512)
    // [205] call cpy_graphics 
  // Now we activate the tile mode.
    // [750] phi from main::@49 to cpy_graphics [phi:main::@49->cpy_graphics]
    // [750] phi cpy_graphics::array#12 = PlayerSprites [phi:main::@49->cpy_graphics#0] -- pduz1=pduc1 
    lda #<PlayerSprites
    sta.z cpy_graphics.array
    lda #>PlayerSprites
    sta.z cpy_graphics.array+1
    // [750] phi cpy_graphics::bsrc#11 = BRAM_PLAYER [phi:main::@49->cpy_graphics#1] -- vduz1=vduc1 
    lda #<BRAM_PLAYER
    sta.z cpy_graphics.bsrc
    lda #>BRAM_PLAYER
    sta.z cpy_graphics.bsrc+1
    lda #<BRAM_PLAYER>>$10
    sta.z cpy_graphics.bsrc+2
    lda #>BRAM_PLAYER>>$10
    sta.z cpy_graphics.bsrc+3
    // [750] phi cpy_graphics::size#10 = $200 [phi:main::@49->cpy_graphics#2] -- vwuz1=vwuc1 
    lda #<$200
    sta.z cpy_graphics.size
    lda #>$200
    sta.z cpy_graphics.size+1
    // [750] phi cpy_graphics::segmentid#7 = HEAP_SPRITES [phi:main::@49->cpy_graphics#3] -- vbuz1=vbuc1 
    lda #HEAP_SPRITES
    sta.z cpy_graphics.segmentid
    // [750] phi cpy_graphics::num#6 = NUM_PLAYER [phi:main::@49->cpy_graphics#4] -- vbuz1=vbuc1 
    lda #NUM_PLAYER
    sta.z cpy_graphics.num
    jsr cpy_graphics
    // [206] phi from main::@49 to main::@50 [phi:main::@49->main::@50]
    // main::@50
    // cpy_graphics(HEAP_SPRITES, BRAM_ENEMY2, Enemy2Sprites, NUM_ENEMY2, 512)
    // [207] call cpy_graphics 
    // [750] phi from main::@50 to cpy_graphics [phi:main::@50->cpy_graphics]
    // [750] phi cpy_graphics::array#12 = Enemy2Sprites [phi:main::@50->cpy_graphics#0] -- pduz1=pduc1 
    lda #<Enemy2Sprites
    sta.z cpy_graphics.array
    lda #>Enemy2Sprites
    sta.z cpy_graphics.array+1
    // [750] phi cpy_graphics::bsrc#11 = BRAM_ENEMY2 [phi:main::@50->cpy_graphics#1] -- vduz1=vduc1 
    lda #<BRAM_ENEMY2
    sta.z cpy_graphics.bsrc
    lda #>BRAM_ENEMY2
    sta.z cpy_graphics.bsrc+1
    lda #<BRAM_ENEMY2>>$10
    sta.z cpy_graphics.bsrc+2
    lda #>BRAM_ENEMY2>>$10
    sta.z cpy_graphics.bsrc+3
    // [750] phi cpy_graphics::size#10 = $200 [phi:main::@50->cpy_graphics#2] -- vwuz1=vwuc1 
    lda #<$200
    sta.z cpy_graphics.size
    lda #>$200
    sta.z cpy_graphics.size+1
    // [750] phi cpy_graphics::segmentid#7 = HEAP_SPRITES [phi:main::@50->cpy_graphics#3] -- vbuz1=vbuc1 
    lda #HEAP_SPRITES
    sta.z cpy_graphics.segmentid
    // [750] phi cpy_graphics::num#6 = NUM_ENEMY2 [phi:main::@50->cpy_graphics#4] -- vbuz1=vbuc1 
    lda #NUM_ENEMY2
    sta.z cpy_graphics.num
    jsr cpy_graphics
    // [208] phi from main::@50 to main::@51 [phi:main::@50->main::@51]
    // main::@51
    // cpy_graphics(HEAP_FLOOR_TILE, BANK_SQUAREMETAL, SquareMetalTiles, NUM_SQUAREMETAL, 2048)
    // [209] call cpy_graphics 
    // [750] phi from main::@51 to cpy_graphics [phi:main::@51->cpy_graphics]
    // [750] phi cpy_graphics::array#12 = SquareMetalTiles [phi:main::@51->cpy_graphics#0] -- pduz1=pduc1 
    lda #<SquareMetalTiles
    sta.z cpy_graphics.array
    lda #>SquareMetalTiles
    sta.z cpy_graphics.array+1
    // [750] phi cpy_graphics::bsrc#11 = BANK_SQUAREMETAL [phi:main::@51->cpy_graphics#1] -- vduz1=vduc1 
    lda #<BANK_SQUAREMETAL
    sta.z cpy_graphics.bsrc
    lda #>BANK_SQUAREMETAL
    sta.z cpy_graphics.bsrc+1
    lda #<BANK_SQUAREMETAL>>$10
    sta.z cpy_graphics.bsrc+2
    lda #>BANK_SQUAREMETAL>>$10
    sta.z cpy_graphics.bsrc+3
    // [750] phi cpy_graphics::size#10 = $800 [phi:main::@51->cpy_graphics#2] -- vwuz1=vwuc1 
    lda #<$800
    sta.z cpy_graphics.size
    lda #>$800
    sta.z cpy_graphics.size+1
    // [750] phi cpy_graphics::segmentid#7 = HEAP_FLOOR_TILE [phi:main::@51->cpy_graphics#3] -- vbuz1=vbuc1 
    lda #HEAP_FLOOR_TILE
    sta.z cpy_graphics.segmentid
    // [750] phi cpy_graphics::num#6 = NUM_SQUAREMETAL [phi:main::@51->cpy_graphics#4] -- vbuz1=vbuc1 
    lda #NUM_SQUAREMETAL
    sta.z cpy_graphics.num
    jsr cpy_graphics
    // [210] phi from main::@51 to main::@52 [phi:main::@51->main::@52]
    // main::@52
    // cpy_graphics(HEAP_FLOOR_TILE, BANK_TILEMETAL, TileMetalTiles, NUM_TILEMETAL, 2048)
    // [211] call cpy_graphics 
    // [750] phi from main::@52 to cpy_graphics [phi:main::@52->cpy_graphics]
    // [750] phi cpy_graphics::array#12 = TileMetalTiles [phi:main::@52->cpy_graphics#0] -- pduz1=pduc1 
    lda #<TileMetalTiles
    sta.z cpy_graphics.array
    lda #>TileMetalTiles
    sta.z cpy_graphics.array+1
    // [750] phi cpy_graphics::bsrc#11 = BANK_TILEMETAL [phi:main::@52->cpy_graphics#1] -- vduz1=vduc1 
    lda #<BANK_TILEMETAL
    sta.z cpy_graphics.bsrc
    lda #>BANK_TILEMETAL
    sta.z cpy_graphics.bsrc+1
    lda #<BANK_TILEMETAL>>$10
    sta.z cpy_graphics.bsrc+2
    lda #>BANK_TILEMETAL>>$10
    sta.z cpy_graphics.bsrc+3
    // [750] phi cpy_graphics::size#10 = $800 [phi:main::@52->cpy_graphics#2] -- vwuz1=vwuc1 
    lda #<$800
    sta.z cpy_graphics.size
    lda #>$800
    sta.z cpy_graphics.size+1
    // [750] phi cpy_graphics::segmentid#7 = HEAP_FLOOR_TILE [phi:main::@52->cpy_graphics#3] -- vbuz1=vbuc1 
    lda #HEAP_FLOOR_TILE
    sta.z cpy_graphics.segmentid
    // [750] phi cpy_graphics::num#6 = NUM_TILEMETAL [phi:main::@52->cpy_graphics#4] -- vbuz1=vbuc1 
    lda #NUM_TILEMETAL
    sta.z cpy_graphics.num
    jsr cpy_graphics
    // [212] phi from main::@52 to main::@53 [phi:main::@52->main::@53]
    // main::@53
    // cpy_graphics(HEAP_FLOOR_TILE, BANK_SQUARERASTER, SquareRasterTiles, NUM_SQUARERASTER, 2048)
    // [213] call cpy_graphics 
    // [750] phi from main::@53 to cpy_graphics [phi:main::@53->cpy_graphics]
    // [750] phi cpy_graphics::array#12 = SquareRasterTiles [phi:main::@53->cpy_graphics#0] -- pduz1=pduc1 
    lda #<SquareRasterTiles
    sta.z cpy_graphics.array
    lda #>SquareRasterTiles
    sta.z cpy_graphics.array+1
    // [750] phi cpy_graphics::bsrc#11 = BANK_SQUARERASTER [phi:main::@53->cpy_graphics#1] -- vduz1=vduc1 
    lda #<BANK_SQUARERASTER
    sta.z cpy_graphics.bsrc
    lda #>BANK_SQUARERASTER
    sta.z cpy_graphics.bsrc+1
    lda #<BANK_SQUARERASTER>>$10
    sta.z cpy_graphics.bsrc+2
    lda #>BANK_SQUARERASTER>>$10
    sta.z cpy_graphics.bsrc+3
    // [750] phi cpy_graphics::size#10 = $800 [phi:main::@53->cpy_graphics#2] -- vwuz1=vwuc1 
    lda #<$800
    sta.z cpy_graphics.size
    lda #>$800
    sta.z cpy_graphics.size+1
    // [750] phi cpy_graphics::segmentid#7 = HEAP_FLOOR_TILE [phi:main::@53->cpy_graphics#3] -- vbuz1=vbuc1 
    lda #HEAP_FLOOR_TILE
    sta.z cpy_graphics.segmentid
    // [750] phi cpy_graphics::num#6 = NUM_SQUARERASTER [phi:main::@53->cpy_graphics#4] -- vbuz1=vbuc1 
    lda #NUM_SQUARERASTER
    sta.z cpy_graphics.num
    jsr cpy_graphics
    // main::@54
    // vram_floor_tile = SquareMetalTiles[0]
    // [214] vram_floor_tile#0 = *SquareMetalTiles -- vduz1=_deref_pduc1 
    lda SquareMetalTiles
    sta.z vram_floor_tile
    lda SquareMetalTiles+1
    sta.z vram_floor_tile+1
    lda SquareMetalTiles+2
    sta.z vram_floor_tile+2
    lda SquareMetalTiles+3
    sta.z vram_floor_tile+3
    // vera_layer_mode_tile(0, vram_floor_map, vram_floor_tile, 64, 64, 16, 16, 4)
    // [215] vera_layer_mode_tile::mapbase_address#3 = vram_floor_map#0 -- vduz1=vduz2 
    lda.z vram_floor_map
    sta.z vera_layer_mode_tile.mapbase_address
    lda.z vram_floor_map+1
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda.z vram_floor_map+2
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda.z vram_floor_map+3
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [216] vera_layer_mode_tile::tilebase_address#3 = vram_floor_tile#0 -- vduz1=vduz2 
    lda.z vram_floor_tile
    sta.z vera_layer_mode_tile.tilebase_address
    lda.z vram_floor_tile+1
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda.z vram_floor_tile+2
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda.z vram_floor_tile+3
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [217] call vera_layer_mode_tile 
    // [644] phi from main::@54 to vera_layer_mode_tile [phi:main::@54->vera_layer_mode_tile]
    // [644] phi vera_layer_mode_tile::tileheight#10 = $10 [phi:main::@54->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #$10
    sta.z vera_layer_mode_tile.tileheight
    // [644] phi vera_layer_mode_tile::tilewidth#10 = $10 [phi:main::@54->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [644] phi vera_layer_mode_tile::tilebase_address#10 = vera_layer_mode_tile::tilebase_address#3 [phi:main::@54->vera_layer_mode_tile#2] -- register_copy 
    // [644] phi vera_layer_mode_tile::mapbase_address#10 = vera_layer_mode_tile::mapbase_address#3 [phi:main::@54->vera_layer_mode_tile#3] -- register_copy 
    // [644] phi vera_layer_mode_tile::mapheight#10 = $40 [phi:main::@54->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [644] phi vera_layer_mode_tile::layer#10 = 0 [phi:main::@54->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.layer
    // [644] phi vera_layer_mode_tile::mapwidth#10 = $40 [phi:main::@54->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$40
    sta.z vera_layer_mode_tile.mapwidth+1
    // [644] phi vera_layer_mode_tile::color_depth#3 = 4 [phi:main::@54->vera_layer_mode_tile#7] -- vbuxx=vbuc1 
    ldx #4
    jsr vera_layer_mode_tile
    // [218] phi from main::@54 to main::@55 [phi:main::@54->main::@55]
    // main::@55
    // vera_cpy_bank_vram(BANK_PALETTE, VERA_PALETTE+32, (dword)32*6)
    // [219] call vera_cpy_bank_vram 
  // Load the palette in VERA palette registers, but keep the first 16 colors untouched.
    // [776] phi from main::@55 to vera_cpy_bank_vram [phi:main::@55->vera_cpy_bank_vram]
    // [776] phi vera_cpy_bank_vram::num#4 = $20*6 [phi:main::@55->vera_cpy_bank_vram#0] -- vduz1=vduc1 
    lda #<$20*6
    sta.z vera_cpy_bank_vram.num
    lda #>$20*6
    sta.z vera_cpy_bank_vram.num+1
    lda #<$20*6>>$10
    sta.z vera_cpy_bank_vram.num+2
    lda #>$20*6>>$10
    sta.z vera_cpy_bank_vram.num+3
    // [776] phi vera_cpy_bank_vram::bsrc#2 = BANK_PALETTE [phi:main::@55->vera_cpy_bank_vram#1] -- vduz1=vduc1 
    lda #<BANK_PALETTE
    sta.z vera_cpy_bank_vram.bsrc
    lda #>BANK_PALETTE
    sta.z vera_cpy_bank_vram.bsrc+1
    lda #<BANK_PALETTE>>$10
    sta.z vera_cpy_bank_vram.bsrc+2
    lda #>BANK_PALETTE>>$10
    sta.z vera_cpy_bank_vram.bsrc+3
    // [776] phi vera_cpy_bank_vram::vdest#2 = VERA_PALETTE+$20 [phi:main::@55->vera_cpy_bank_vram#2] -- vduz1=vduc1 
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
    // [220] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [221] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [222] phi from main::vera_layer_show1 to main::@18 [phi:main::vera_layer_show1->main::@18]
    // main::@18
    // tile_background()
    // [223] call tile_background 
    // [818] phi from main::@18 to tile_background [phi:main::@18->tile_background]
    jsr tile_background
    // [224] phi from main::@18 to main::@56 [phi:main::@18->main::@56]
    // main::@56
    // create_sprites_player()
    // [225] call create_sprites_player 
    // [839] phi from main::@56 to create_sprites_player [phi:main::@56->create_sprites_player]
    jsr create_sprites_player
    // [226] phi from main::@56 to main::@57 [phi:main::@56->main::@57]
    // main::@57
    // create_sprites_enemy2()
    // [227] call create_sprites_enemy2 
    // [973] phi from main::@57 to create_sprites_enemy2 [phi:main::@57->create_sprites_enemy2]
    jsr create_sprites_enemy2
    // main::vera_sprite_on1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [228] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE
    // [229] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_SPRITES_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITES_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // main::SEI1
    // asm
    // asm { sei  }
    sei
    // main::@19
    // *KERNEL_IRQ = &irq_vsync
    // [231] *KERNEL_IRQ = &irq_vsync -- _deref_qprc1=pprc2 
    lda #<irq_vsync
    sta KERNEL_IRQ
    lda #>irq_vsync
    sta KERNEL_IRQ+1
    // *VERA_IEN = VERA_VSYNC
    // [232] *VERA_IEN = VERA_VSYNC -- _deref_pbuc1=vbuc2 
    lda #VERA_VSYNC
    sta VERA_IEN
    // main::CLI1
    // asm
    // asm { cli  }
    cli
    // [234] phi from main::@59 main::CLI1 to main::@15 [phi:main::@59/main::CLI1->main::@15]
    // main::@15
  __b15:
    // kbhit()
    // [235] call kbhit 
    jsr kbhit
    // [236] kbhit::return#2 = kbhit::return#1
    // main::@59
    // [237] main::$57 = kbhit::return#2
    // while(!kbhit())
    // [238] if(0==main::$57) goto main::@15 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b15
    // [239] phi from main::@59 to main::@16 [phi:main::@59->main::@16]
    // main::@16
    // cx16_rom_bank(4)
    // [240] call cx16_rom_bank 
  // Back to basic.
    // [544] phi from main::@16 to cx16_rom_bank [phi:main::@16->cx16_rom_bank]
    // [544] phi cx16_rom_bank::bank#2 = 4 [phi:main::@16->cx16_rom_bank#0] -- vbuaa=vbuc1 
    lda #4
    jsr cx16_rom_bank
    // main::@return
    // }
    // [241] return 
    rts
  .segment Data
    s: .text "error file_sprites: "
    .byte 0
    s2: .text "error file_enemy2 = "
    .byte 0
    s4: .text "error file_tiles = "
    .byte 0
    s6: .text "error file_squaremetal = "
    .byte 0
    s8: .text "error file_tilemetal = "
    .byte 0
    s10: .text "error file_squareraster = "
    .byte 0
    s12: .text "error file_palettes = "
    .byte 0
}
.segment Code
  // rotate_sprites
// rotate_sprites(byte zp(7) base, word zp($43) rotate, word zp($41) max, dword* zp($45) spriteaddresses, word zp($47) basex)
rotate_sprites: {
    .label __8 = $49
    .label __11 = $61
    .label __14 = $49
    .label __15 = $49
    .label __16 = $61
    .label vera_sprite_address1___0 = $49
    .label vera_sprite_address1___4 = $49
    .label vera_sprite_address1___5 = $49
    .label vera_sprite_address1___7 = $49
    .label vera_sprite_address1___9 = $60
    .label vera_sprite_address1___10 = $49
    .label vera_sprite_address1___14 = $49
    .label vera_sprite_xy1___4 = $63
    .label vera_sprite_xy1___10 = $63
    .label i = $49
    .label vera_sprite_address1_address = $5c
    .label vera_sprite_address1_sprite_offset = $49
    .label vera_sprite_xy1_sprite = 8
    .label vera_sprite_xy1_x = $49
    .label vera_sprite_xy1_y = $61
    .label vera_sprite_xy1_sprite_offset = $63
    .label rotate = $43
    .label max = $41
    .label base = 7
    .label spriteaddresses = $45
    .label basex = $47
    .label __17 = $49
    // [243] phi from rotate_sprites to rotate_sprites::@1 [phi:rotate_sprites->rotate_sprites::@1]
    // [243] phi rotate_sprites::s#2 = 0 [phi:rotate_sprites->rotate_sprites::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // rotate_sprites::@1
  __b1:
    // for(byte s=0;s<max;s++)
    // [244] if(rotate_sprites::s#2<rotate_sprites::max#5) goto rotate_sprites::@2 -- vbuxx_lt_vwuz1_then_la1 
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
    // [247] if(rotate_sprites::i#0<rotate_sprites::max#5) goto rotate_sprites::@3 -- vwuz1_lt_vwuz2_then_la1 
    cmp.z max+1
    bcc __b3
    bne !+
    lda.z i
    cmp.z max
    bcc __b3
  !:
    // rotate_sprites::@4
    // i-=max
    // [248] rotate_sprites::i#1 = rotate_sprites::i#0 - rotate_sprites::max#5 -- vwuz1=vwuz1_minus_vwuz2 
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
    // vera_sprite_address(s+base, spriteaddresses[i])
    // [250] rotate_sprites::vera_sprite_xy1_sprite#0 = rotate_sprites::s#2 + rotate_sprites::base#8 -- vbuz1=vbuxx_plus_vbuz2 
    txa
    clc
    adc.z base
    sta.z vera_sprite_xy1_sprite
    // [251] rotate_sprites::$14 = rotate_sprites::i#2 << 2 -- vwuz1=vwuz1_rol_2 
    asl.z __14
    rol.z __14+1
    asl.z __14
    rol.z __14+1
    // [252] rotate_sprites::$17 = rotate_sprites::spriteaddresses#6 + rotate_sprites::$14 -- pduz1=pduz2_plus_vwuz1 
    lda.z __17
    clc
    adc.z spriteaddresses
    sta.z __17
    lda.z __17+1
    adc.z spriteaddresses+1
    sta.z __17+1
    // [253] rotate_sprites::vera_sprite_address1_address#0 = *rotate_sprites::$17 -- vduz1=_deref_pduz2 
    ldy #0
    lda (__17),y
    sta.z vera_sprite_address1_address
    iny
    lda (__17),y
    sta.z vera_sprite_address1_address+1
    iny
    lda (__17),y
    sta.z vera_sprite_address1_address+2
    iny
    lda (__17),y
    sta.z vera_sprite_address1_address+3
    // rotate_sprites::vera_sprite_address1
    // (word)sprite << 3
    // [254] rotate_sprites::vera_sprite_address1_$14 = (word)rotate_sprites::vera_sprite_xy1_sprite#0 -- vwuz1=_word_vbuz2 
    lda.z vera_sprite_xy1_sprite
    sta.z vera_sprite_address1___14
    lda #0
    sta.z vera_sprite_address1___14+1
    // [255] rotate_sprites::vera_sprite_address1_$0 = rotate_sprites::vera_sprite_address1_$14 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [256] rotate_sprites::vera_sprite_address1_sprite_offset#0 = <VERA_SPRITE_ATTR + rotate_sprites::vera_sprite_address1_$0 -- vwuz1=vwuc1_plus_vwuz1 
    clc
    lda.z vera_sprite_address1_sprite_offset
    adc #<VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset
    lda.z vera_sprite_address1_sprite_offset+1
    adc #>VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [257] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <sprite_offset
    // [258] rotate_sprites::vera_sprite_address1_$2 = < rotate_sprites::vera_sprite_address1_sprite_offset#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1_sprite_offset
    // *VERA_ADDRX_L = <sprite_offset
    // [259] *VERA_ADDRX_L = rotate_sprites::vera_sprite_address1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset
    // [260] rotate_sprites::vera_sprite_address1_$3 = > rotate_sprites::vera_sprite_address1_sprite_offset#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_address1_sprite_offset+1
    // *VERA_ADDRX_M = >sprite_offset
    // [261] *VERA_ADDRX_M = rotate_sprites::vera_sprite_address1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [262] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <address
    // [263] rotate_sprites::vera_sprite_address1_$4 = < rotate_sprites::vera_sprite_address1_address#0 -- vwuz1=_lo_vduz2 
    lda.z vera_sprite_address1_address
    sta.z vera_sprite_address1___4
    lda.z vera_sprite_address1_address+1
    sta.z vera_sprite_address1___4+1
    // (<address)>>5
    // [264] rotate_sprites::vera_sprite_address1_$5 = rotate_sprites::vera_sprite_address1_$4 >> 5 -- vwuz1=vwuz1_ror_5 
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
    // [265] rotate_sprites::vera_sprite_address1_$6 = < rotate_sprites::vera_sprite_address1_$5 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1___5
    // *VERA_DATA0 = <((<address)>>5)
    // [266] *VERA_DATA0 = rotate_sprites::vera_sprite_address1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // <address
    // [267] rotate_sprites::vera_sprite_address1_$7 = < rotate_sprites::vera_sprite_address1_address#0 -- vwuz1=_lo_vduz2 
    lda.z vera_sprite_address1_address
    sta.z vera_sprite_address1___7
    lda.z vera_sprite_address1_address+1
    sta.z vera_sprite_address1___7+1
    // >(<address)
    // [268] rotate_sprites::vera_sprite_address1_$8 = > rotate_sprites::vera_sprite_address1_$7 -- vbuaa=_hi_vwuz1 
    // (>(<address))>>5
    // [269] rotate_sprites::vera_sprite_address1_$9 = rotate_sprites::vera_sprite_address1_$8 >> 5 -- vbuz1=vbuaa_ror_5 
    lsr
    lsr
    lsr
    lsr
    lsr
    sta.z vera_sprite_address1___9
    // >address
    // [270] rotate_sprites::vera_sprite_address1_$10 = > rotate_sprites::vera_sprite_address1_address#0 -- vwuz1=_hi_vduz2 
    lda.z vera_sprite_address1_address+2
    sta.z vera_sprite_address1___10
    lda.z vera_sprite_address1_address+3
    sta.z vera_sprite_address1___10+1
    // <(>address)
    // [271] rotate_sprites::vera_sprite_address1_$11 = < rotate_sprites::vera_sprite_address1_$10 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1___10
    // (<(>address))<<3
    // [272] rotate_sprites::vera_sprite_address1_$12 = rotate_sprites::vera_sprite_address1_$11 << 3 -- vbuaa=vbuaa_rol_3 
    asl
    asl
    asl
    // ((>(<address))>>5)|((<(>address))<<3)
    // [273] rotate_sprites::vera_sprite_address1_$13 = rotate_sprites::vera_sprite_address1_$9 | rotate_sprites::vera_sprite_address1_$12 -- vbuaa=vbuz1_bor_vbuaa 
    ora.z vera_sprite_address1___9
    // *VERA_DATA0 = ((>(<address))>>5)|((<(>address))<<3)
    // [274] *VERA_DATA0 = rotate_sprites::vera_sprite_address1_$13 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // rotate_sprites::@5
    // s&03
    // [275] rotate_sprites::$7 = rotate_sprites::s#2 & 3 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #3
    // (word)(s&03)<<6
    // [276] rotate_sprites::$15 = (word)rotate_sprites::$7 -- vwuz1=_word_vbuaa 
    sta.z __15
    lda #0
    sta.z __15+1
    // [277] rotate_sprites::$8 = rotate_sprites::$15 << 6 -- vwuz1=vwuz1_rol_6 
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
    // vera_sprite_xy(s+base, basex+((word)(s&03)<<6), basey+((word)(s>>2)<<6))
    // [278] rotate_sprites::vera_sprite_xy1_x#0 = rotate_sprites::basex#8 + rotate_sprites::$8 -- vwuz1=vwuz2_plus_vwuz1 
    lda.z vera_sprite_xy1_x
    clc
    adc.z basex
    sta.z vera_sprite_xy1_x
    lda.z vera_sprite_xy1_x+1
    adc.z basex+1
    sta.z vera_sprite_xy1_x+1
    // s>>2
    // [279] rotate_sprites::$10 = rotate_sprites::s#2 >> 2 -- vbuaa=vbuxx_ror_2 
    txa
    lsr
    lsr
    // (word)(s>>2)<<6
    // [280] rotate_sprites::$16 = (word)rotate_sprites::$10 -- vwuz1=_word_vbuaa 
    sta.z __16
    lda #0
    sta.z __16+1
    // [281] rotate_sprites::$11 = rotate_sprites::$16 << 6 -- vwuz1=vwuz1_rol_6 
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
    // vera_sprite_xy(s+base, basex+((word)(s&03)<<6), basey+((word)(s>>2)<<6))
    // [282] rotate_sprites::vera_sprite_xy1_y#0 = $64 + rotate_sprites::$11 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$64
    clc
    adc.z vera_sprite_xy1_y
    sta.z vera_sprite_xy1_y
    bcc !+
    inc.z vera_sprite_xy1_y+1
  !:
    // rotate_sprites::vera_sprite_xy1
    // (word)sprite << 3
    // [283] rotate_sprites::vera_sprite_xy1_$10 = (word)rotate_sprites::vera_sprite_xy1_sprite#0 -- vwuz1=_word_vbuz2 
    lda.z vera_sprite_xy1_sprite
    sta.z vera_sprite_xy1___10
    lda #0
    sta.z vera_sprite_xy1___10+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [284] rotate_sprites::vera_sprite_xy1_sprite_offset#0 = rotate_sprites::vera_sprite_xy1_$10 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [285] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+2
    // [286] rotate_sprites::vera_sprite_xy1_$4 = rotate_sprites::vera_sprite_xy1_sprite_offset#0 + <VERA_SPRITE_ATTR+2 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_xy1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4
    lda.z vera_sprite_xy1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4+1
    // <sprite_offset+2
    // [287] rotate_sprites::vera_sprite_xy1_$3 = < rotate_sprites::vera_sprite_xy1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1___4
    // *VERA_ADDRX_L = <sprite_offset+2
    // [288] *VERA_ADDRX_L = rotate_sprites::vera_sprite_xy1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+2
    // [289] rotate_sprites::vera_sprite_xy1_$5 = > rotate_sprites::vera_sprite_xy1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1___4+1
    // *VERA_ADDRX_M = >sprite_offset+2
    // [290] *VERA_ADDRX_M = rotate_sprites::vera_sprite_xy1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [291] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <x
    // [292] rotate_sprites::vera_sprite_xy1_$6 = < rotate_sprites::vera_sprite_xy1_x#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1_x
    // *VERA_DATA0 = <x
    // [293] *VERA_DATA0 = rotate_sprites::vera_sprite_xy1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // >x
    // [294] rotate_sprites::vera_sprite_xy1_$7 = > rotate_sprites::vera_sprite_xy1_x#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1_x+1
    // *VERA_DATA0 = >x
    // [295] *VERA_DATA0 = rotate_sprites::vera_sprite_xy1_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // <y
    // [296] rotate_sprites::vera_sprite_xy1_$8 = < rotate_sprites::vera_sprite_xy1_y#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1_y
    // *VERA_DATA0 = <y
    // [297] *VERA_DATA0 = rotate_sprites::vera_sprite_xy1_$8 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // >y
    // [298] rotate_sprites::vera_sprite_xy1_$9 = > rotate_sprites::vera_sprite_xy1_y#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1_y+1
    // *VERA_DATA0 = >y
    // [299] *VERA_DATA0 = rotate_sprites::vera_sprite_xy1_$9 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // rotate_sprites::@6
    // for(byte s=0;s<max;s++)
    // [300] rotate_sprites::s#1 = ++ rotate_sprites::s#2 -- vbuxx=_inc_vbuxx 
    inx
    // [243] phi from rotate_sprites::@6 to rotate_sprites::@1 [phi:rotate_sprites::@6->rotate_sprites::@1]
    // [243] phi rotate_sprites::s#2 = rotate_sprites::s#1 [phi:rotate_sprites::@6->rotate_sprites::@1#0] -- register_copy 
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
// memcpy_in_vram(byte zp($e) dest_bank, void* zp($a) dest, byte register(Y) src_bank, byte* zp($6e) src, word zp($70) num)
memcpy_in_vram: {
    .label i = $a
    .label dest = $a
    .label src = $6e
    .label num = $70
    .label dest_bank = $e
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [302] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <src
    // [303] memcpy_in_vram::$0 = < memcpy_in_vram::src#2 -- vbuaa=_lo_pvoz1 
    lda.z src
    // *VERA_ADDRX_L = <src
    // [304] *VERA_ADDRX_L = memcpy_in_vram::$0 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >src
    // [305] memcpy_in_vram::$1 = > memcpy_in_vram::src#2 -- vbuaa=_hi_pvoz1 
    lda.z src+1
    // *VERA_ADDRX_M = >src
    // [306] *VERA_ADDRX_M = memcpy_in_vram::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // src_increment | src_bank
    // [307] memcpy_in_vram::$2 = VERA_INC_1 | memcpy_in_vram::src_bank#2 -- vbuaa=vbuc1_bor_vbuyy 
    tya
    ora #VERA_INC_1
    // *VERA_ADDRX_H = src_increment | src_bank
    // [308] *VERA_ADDRX_H = memcpy_in_vram::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [309] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    // Select DATA1
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // <dest
    // [310] memcpy_in_vram::$3 = < memcpy_in_vram::dest#2 -- vbuaa=_lo_pvoz1 
    lda.z dest
    // *VERA_ADDRX_L = <dest
    // [311] *VERA_ADDRX_L = memcpy_in_vram::$3 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >dest
    // [312] memcpy_in_vram::$4 = > memcpy_in_vram::dest#2 -- vbuaa=_hi_pvoz1 
    lda.z dest+1
    // *VERA_ADDRX_M = >dest
    // [313] *VERA_ADDRX_M = memcpy_in_vram::$4 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // dest_increment | dest_bank
    // [314] memcpy_in_vram::$5 = VERA_INC_1 | memcpy_in_vram::dest_bank#2 -- vbuaa=vbuc1_bor_vbuz1 
    lda #VERA_INC_1
    ora.z dest_bank
    // *VERA_ADDRX_H = dest_increment | dest_bank
    // [315] *VERA_ADDRX_H = memcpy_in_vram::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [316] phi from memcpy_in_vram to memcpy_in_vram::@1 [phi:memcpy_in_vram->memcpy_in_vram::@1]
    // [316] phi memcpy_in_vram::i#2 = 0 [phi:memcpy_in_vram->memcpy_in_vram::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // memcpy_in_vram::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [317] if(memcpy_in_vram::i#2<memcpy_in_vram::num#3) goto memcpy_in_vram::@2 -- vwuz1_lt_vwuz2_then_la1 
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
    // [318] return 
    rts
    // memcpy_in_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [319] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [320] memcpy_in_vram::i#1 = ++ memcpy_in_vram::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [316] phi from memcpy_in_vram::@2 to memcpy_in_vram::@1 [phi:memcpy_in_vram::@2->memcpy_in_vram::@1]
    // [316] phi memcpy_in_vram::i#2 = memcpy_in_vram::i#1 [phi:memcpy_in_vram::@2->memcpy_in_vram::@1#0] -- register_copy 
    jmp __b1
}
  // rand
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
rand: {
    .label __0 = $6e
    .label __1 = $65
    .label __2 = $a
    .label return = $6e
    // rand_state << 7
    // [322] rand::$0 = rand_state#13 << 7 -- vwuz1=vwuz2_rol_7 
    lda.z rand_state+1
    lsr
    lda.z rand_state
    ror
    sta.z __0+1
    lda #0
    ror
    sta.z __0
    // rand_state ^= rand_state << 7
    // [323] rand_state#0 = rand_state#13 ^ rand::$0 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __0
    sta.z rand_state
    lda.z rand_state+1
    eor.z __0+1
    sta.z rand_state+1
    // rand_state >> 9
    // [324] rand::$1 = rand_state#0 >> 9 -- vwuz1=vwuz2_ror_9 
    lsr
    sta.z __1
    lda #0
    sta.z __1+1
    // rand_state ^= rand_state >> 9
    // [325] rand_state#1 = rand_state#0 ^ rand::$1 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __1
    sta.z rand_state
    lda.z rand_state+1
    eor.z __1+1
    sta.z rand_state+1
    // rand_state << 8
    // [326] rand::$2 = rand_state#1 << 8 -- vwuz1=vwuz2_rol_8 
    lda.z rand_state
    sta.z __2+1
    lda #0
    sta.z __2
    // rand_state ^= rand_state << 8
    // [327] rand_state#14 = rand_state#1 ^ rand::$2 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __2
    sta.z rand_state
    lda.z rand_state+1
    eor.z __2+1
    sta.z rand_state+1
    // return rand_state;
    // [328] rand::return#0 = rand_state#14 -- vwuz1=vwuz2 
    lda.z rand_state
    sta.z return
    lda.z rand_state+1
    sta.z return+1
    // rand::@return
    // }
    // [329] return 
    rts
}
  // modr16u
// Performs modulo on two 16 bit unsigned ints and an initial remainder
// Returns the remainder.
// Implemented using simple binary division
// modr16u(word zp($6e) dividend)
modr16u: {
    .label return = $70
    .label dividend = $6e
    // divr16u(dividend, divisor, rem)
    // [331] divr16u::dividend#1 = modr16u::dividend#2
    // [332] call divr16u 
    // [1122] phi from modr16u to divr16u [phi:modr16u->divr16u]
    jsr divr16u
    // modr16u::@1
    // return rem16u;
    // [333] modr16u::return#0 = divr16u::rem#10 -- vwuz1=vwuz2 
    lda.z divr16u.rem
    sta.z return
    lda.z divr16u.rem+1
    sta.z return+1
    // modr16u::@return
    // }
    // [334] return 
    rts
}
  // vera_tile_element
// vera_tile_element(byte register(X) x, byte zp($d) y, struct Tile* zp($a) Tile)
vera_tile_element: {
    .label __4 = $6c
    .label __17 = $72
    .label __34 = $6c
    .label vera_vram_address01___0 = $6e
    .label vera_vram_address01___2 = $6e
    .label vera_vram_address01___4 = $70
    .label TileOffset = $65
    .label TileTotal = $67
    .label TileCount = $68
    .label TileColumns = $69
    .label PaletteOffset = $6a
    .label y = $d
    .label mapbase = $f
    .label shift = $6b
    .label rowskip = $a
    .label j = $e
    .label i = $c
    .label r = $d
    .label x = $c
    .label Tile = $a
    // TileOffset = Tile->Offset
    // [336] vera_tile_element::TileOffset#0 = ((word*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_OFFSET] -- vwuz1=pwuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_OFFSET
    lda (Tile),y
    sta.z TileOffset
    iny
    lda (Tile),y
    sta.z TileOffset+1
    // TileTotal = Tile->Total
    // [337] vera_tile_element::TileTotal#0 = ((byte*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_TOTAL] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_TOTAL
    lda (Tile),y
    sta.z TileTotal
    // TileCount = Tile->Count
    // [338] vera_tile_element::TileCount#0 = ((byte*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_COUNT] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_COUNT
    lda (Tile),y
    sta.z TileCount
    // TileColumns = Tile->Columns
    // [339] vera_tile_element::TileColumns#0 = ((byte*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_COLUMNS] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_COLUMNS
    lda (Tile),y
    sta.z TileColumns
    // PaletteOffset = Tile->Palette
    // [340] vera_tile_element::PaletteOffset#0 = ((byte*)vera_tile_element::Tile#2)[OFFSET_STRUCT_TILE_PALETTE] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_TILE_PALETTE
    lda (Tile),y
    sta.z PaletteOffset
    // printf("offset = %x\n",TileOffset)
    // [341] call cputs 
    // [528] phi from vera_tile_element to cputs [phi:vera_tile_element->cputs]
    // [528] phi cputs::s#19 = vera_tile_element::s [phi:vera_tile_element->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // vera_tile_element::@9
    // printf("offset = %x\n",TileOffset)
    // [342] printf_uint::uvalue#0 = vera_tile_element::TileOffset#0 -- vwuz1=vwuz2 
    lda.z TileOffset
    sta.z printf_uint.uvalue
    lda.z TileOffset+1
    sta.z printf_uint.uvalue+1
    // [343] call printf_uint 
    // [1139] phi from vera_tile_element::@9 to printf_uint [phi:vera_tile_element::@9->printf_uint]
    jsr printf_uint
    // [344] phi from vera_tile_element::@9 to vera_tile_element::@10 [phi:vera_tile_element::@9->vera_tile_element::@10]
    // vera_tile_element::@10
    // printf("offset = %x\n",TileOffset)
    // [345] call cputs 
    // [528] phi from vera_tile_element::@10 to cputs [phi:vera_tile_element::@10->cputs]
    // [528] phi cputs::s#19 = s1 [phi:vera_tile_element::@10->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // vera_tile_element::@11
    // x = x << resolution
    // [346] vera_tile_element::x#0 = vera_tile_element::x#3 << 3 -- vbuxx=vbuz1_rol_3 
    lda.z x
    asl
    asl
    asl
    tax
    // y = y << resolution
    // [347] vera_tile_element::y#0 = vera_tile_element::y#3 << 3 -- vbuz1=vbuz1_rol_3 
    lda.z y
    asl
    asl
    asl
    sta.z y
    // mapbase = vera_mapbase_address[layer]
    // [348] vera_tile_element::mapbase#0 = *vera_mapbase_address -- vduz1=_deref_pduc1 
    lda vera_mapbase_address
    sta.z mapbase
    lda vera_mapbase_address+1
    sta.z mapbase+1
    lda vera_mapbase_address+2
    sta.z mapbase+2
    lda vera_mapbase_address+3
    sta.z mapbase+3
    // shift = vera_layer_rowshift[layer]
    // [349] vera_tile_element::shift#0 = *vera_layer_rowshift -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift
    sta.z shift
    // rowskip = (word)1 << shift
    // [350] vera_tile_element::rowskip#0 = 1 << vera_tile_element::shift#0 -- vwuz1=vwuc1_rol_vbuz2 
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
    // [351] vera_tile_element::$34 = (word)vera_tile_element::y#0 -- vwuz1=_word_vbuz2 
    lda.z y
    sta.z __34
    lda #0
    sta.z __34+1
    // [352] vera_tile_element::$4 = vera_tile_element::$34 << vera_tile_element::shift#0 -- vwuz1=vwuz1_rol_vbuz2 
    ldy.z shift
    beq !e+
  !:
    asl.z __4
    rol.z __4+1
    dey
    bne !-
  !e:
    // mapbase += ((word)y << shift)
    // [353] vera_tile_element::mapbase#1 = vera_tile_element::mapbase#0 + vera_tile_element::$4 -- vduz1=vduz1_plus_vwuz2 
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
    // [354] vera_tile_element::$5 = vera_tile_element::x#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // mapbase += (x << 1)
    // [355] vera_tile_element::mapbase#2 = vera_tile_element::mapbase#1 + vera_tile_element::$5 -- vduz1=vduz1_plus_vbuaa 
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
    // [356] phi from vera_tile_element::@11 to vera_tile_element::@1 [phi:vera_tile_element::@11->vera_tile_element::@1]
    // [356] phi vera_tile_element::mapbase#11 = vera_tile_element::mapbase#2 [phi:vera_tile_element::@11->vera_tile_element::@1#0] -- register_copy 
    // [356] phi vera_tile_element::j#2 = 0 [phi:vera_tile_element::@11->vera_tile_element::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z j
    // vera_tile_element::@1
  __b1:
    // for(byte j=0;j<TileTotal;j+=(TileTotal>>1))
    // [357] if(vera_tile_element::j#2<vera_tile_element::TileTotal#0) goto vera_tile_element::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z j
    cmp.z TileTotal
    bcc __b3
    // vera_tile_element::@return
    // }
    // [358] return 
    rts
    // [359] phi from vera_tile_element::@1 to vera_tile_element::@2 [phi:vera_tile_element::@1->vera_tile_element::@2]
  __b3:
    // [359] phi vera_tile_element::mapbase#10 = vera_tile_element::mapbase#11 [phi:vera_tile_element::@1->vera_tile_element::@2#0] -- register_copy 
    // [359] phi vera_tile_element::i#10 = 0 [phi:vera_tile_element::@1->vera_tile_element::@2#1] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // vera_tile_element::@2
  __b2:
    // for(byte i=0;i<TileCount;i+=(TileColumns))
    // [360] if(vera_tile_element::i#10<vera_tile_element::TileCount#0) goto vera_tile_element::vera_vram_address01 -- vbuz1_lt_vbuz2_then_la1 
    lda.z i
    cmp.z TileCount
    bcc vera_vram_address01
    // vera_tile_element::@3
    // TileTotal>>1
    // [361] vera_tile_element::$20 = vera_tile_element::TileTotal#0 >> 1 -- vbuaa=vbuz1_ror_1 
    lda.z TileTotal
    lsr
    // j+=(TileTotal>>1)
    // [362] vera_tile_element::j#1 = vera_tile_element::j#2 + vera_tile_element::$20 -- vbuz1=vbuz1_plus_vbuaa 
    clc
    adc.z j
    sta.z j
    // [356] phi from vera_tile_element::@3 to vera_tile_element::@1 [phi:vera_tile_element::@3->vera_tile_element::@1]
    // [356] phi vera_tile_element::mapbase#11 = vera_tile_element::mapbase#10 [phi:vera_tile_element::@3->vera_tile_element::@1#0] -- register_copy 
    // [356] phi vera_tile_element::j#2 = vera_tile_element::j#1 [phi:vera_tile_element::@3->vera_tile_element::@1#1] -- register_copy 
    jmp __b1
    // vera_tile_element::vera_vram_address01
  vera_vram_address01:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [363] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <bankaddr
    // [364] vera_tile_element::vera_vram_address01_$0 = < vera_tile_element::mapbase#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase
    sta.z vera_vram_address01___0
    lda.z mapbase+1
    sta.z vera_vram_address01___0+1
    // <(<bankaddr)
    // [365] vera_tile_element::vera_vram_address01_$1 = < vera_tile_element::vera_vram_address01_$0 -- vbuaa=_lo_vwuz1 
    lda.z vera_vram_address01___0
    // *VERA_ADDRX_L = <(<bankaddr)
    // [366] *VERA_ADDRX_L = vera_tile_element::vera_vram_address01_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // <bankaddr
    // [367] vera_tile_element::vera_vram_address01_$2 = < vera_tile_element::mapbase#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase
    sta.z vera_vram_address01___2
    lda.z mapbase+1
    sta.z vera_vram_address01___2+1
    // >(<bankaddr)
    // [368] vera_tile_element::vera_vram_address01_$3 = > vera_tile_element::vera_vram_address01_$2 -- vbuaa=_hi_vwuz1 
    // *VERA_ADDRX_M = >(<bankaddr)
    // [369] *VERA_ADDRX_M = vera_tile_element::vera_vram_address01_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // >bankaddr
    // [370] vera_tile_element::vera_vram_address01_$4 = > vera_tile_element::mapbase#10 -- vwuz1=_hi_vduz2 
    lda.z mapbase+2
    sta.z vera_vram_address01___4
    lda.z mapbase+3
    sta.z vera_vram_address01___4+1
    // <(>bankaddr)
    // [371] vera_tile_element::vera_vram_address01_$5 = < vera_tile_element::vera_vram_address01_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_vram_address01___4
    // <(>bankaddr) | incr
    // [372] vera_tile_element::vera_vram_address01_$6 = vera_tile_element::vera_vram_address01_$5 | VERA_INC_1 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_INC_1
    // *VERA_ADDRX_H = <(>bankaddr) | incr
    // [373] *VERA_ADDRX_H = vera_tile_element::vera_vram_address01_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [374] phi from vera_tile_element::vera_vram_address01 to vera_tile_element::@4 [phi:vera_tile_element::vera_vram_address01->vera_tile_element::@4]
    // [374] phi vera_tile_element::r#2 = 0 [phi:vera_tile_element::vera_vram_address01->vera_tile_element::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // vera_tile_element::@4
  __b4:
    // TileTotal>>1
    // [375] vera_tile_element::$9 = vera_tile_element::TileTotal#0 >> 1 -- vbuaa=vbuz1_ror_1 
    lda.z TileTotal
    lsr
    // for(byte r=0;r<(TileTotal>>1);r+=TileCount)
    // [376] if(vera_tile_element::r#2<vera_tile_element::$9) goto vera_tile_element::@6 -- vbuz1_lt_vbuaa_then_la1 
    cmp.z r
    beq !+
    bcs __b5
  !:
    // vera_tile_element::@5
    // mapbase += rowskip
    // [377] vera_tile_element::mapbase#3 = vera_tile_element::mapbase#10 + vera_tile_element::rowskip#0 -- vduz1=vduz1_plus_vwuz2 
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
    // [378] vera_tile_element::i#1 = vera_tile_element::i#10 + vera_tile_element::TileColumns#0 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z i
    clc
    adc.z TileColumns
    sta.z i
    // [359] phi from vera_tile_element::@5 to vera_tile_element::@2 [phi:vera_tile_element::@5->vera_tile_element::@2]
    // [359] phi vera_tile_element::mapbase#10 = vera_tile_element::mapbase#3 [phi:vera_tile_element::@5->vera_tile_element::@2#0] -- register_copy 
    // [359] phi vera_tile_element::i#10 = vera_tile_element::i#1 [phi:vera_tile_element::@5->vera_tile_element::@2#1] -- register_copy 
    jmp __b2
    // [379] phi from vera_tile_element::@4 to vera_tile_element::@6 [phi:vera_tile_element::@4->vera_tile_element::@6]
  __b5:
    // [379] phi vera_tile_element::c#2 = 0 [phi:vera_tile_element::@4->vera_tile_element::@6#0] -- vbuxx=vbuc1 
    ldx #0
    // vera_tile_element::@6
  __b6:
    // for(byte c=0;c<TileColumns;c+=1)
    // [380] if(vera_tile_element::c#2<vera_tile_element::TileColumns#0) goto vera_tile_element::@7 -- vbuxx_lt_vbuz1_then_la1 
    cpx.z TileColumns
    bcc __b7
    // vera_tile_element::@8
    // r+=TileCount
    // [381] vera_tile_element::r#1 = vera_tile_element::r#2 + vera_tile_element::TileCount#0 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z r
    clc
    adc.z TileCount
    sta.z r
    // [374] phi from vera_tile_element::@8 to vera_tile_element::@4 [phi:vera_tile_element::@8->vera_tile_element::@4]
    // [374] phi vera_tile_element::r#2 = vera_tile_element::r#1 [phi:vera_tile_element::@8->vera_tile_element::@4#0] -- register_copy 
    jmp __b4
    // vera_tile_element::@7
  __b7:
    // <TileOffset
    // [382] vera_tile_element::$12 = < vera_tile_element::TileOffset#0 -- vbuaa=_lo_vwuz1 
    lda.z TileOffset
    // (<TileOffset)+c
    // [383] vera_tile_element::$13 = vera_tile_element::$12 + vera_tile_element::c#2 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // (<TileOffset)+c+r
    // [384] vera_tile_element::$14 = vera_tile_element::$13 + vera_tile_element::r#2 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z r
    // (<TileOffset)+c+r+i
    // [385] vera_tile_element::$15 = vera_tile_element::$14 + vera_tile_element::i#10 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z i
    // (<TileOffset)+c+r+i+j
    // [386] vera_tile_element::$16 = vera_tile_element::$15 + vera_tile_element::j#2 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z j
    // *VERA_DATA0 = (<TileOffset)+c+r+i+j
    // [387] *VERA_DATA0 = vera_tile_element::$16 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // PaletteOffset << 4
    // [388] vera_tile_element::$17 = vera_tile_element::PaletteOffset#0 << 4 -- vbuz1=vbuz2_rol_4 
    lda.z PaletteOffset
    asl
    asl
    asl
    asl
    sta.z __17
    // >TileOffset
    // [389] vera_tile_element::$18 = > vera_tile_element::TileOffset#0 -- vbuaa=_hi_vwuz1 
    lda.z TileOffset+1
    // PaletteOffset << 4 | (>TileOffset)
    // [390] vera_tile_element::$19 = vera_tile_element::$17 | vera_tile_element::$18 -- vbuaa=vbuz1_bor_vbuaa 
    ora.z __17
    // *VERA_DATA0 = PaletteOffset << 4 | (>TileOffset)
    // [391] *VERA_DATA0 = vera_tile_element::$19 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // c+=1
    // [392] vera_tile_element::c#1 = vera_tile_element::c#2 + 1 -- vbuxx=vbuxx_plus_1 
    inx
    // [379] phi from vera_tile_element::@7 to vera_tile_element::@6 [phi:vera_tile_element::@7->vera_tile_element::@6]
    // [379] phi vera_tile_element::c#2 = vera_tile_element::c#1 [phi:vera_tile_element::@7->vera_tile_element::@6#0] -- register_copy 
    jmp __b6
  .segment Data
    s: .text "offset = "
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
    // [394] call vera_layer_mode_tile 
    // [644] phi from vera_layer_mode_text to vera_layer_mode_tile [phi:vera_layer_mode_text->vera_layer_mode_tile]
    // [644] phi vera_layer_mode_tile::tileheight#10 = vera_layer_mode_text::tileheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #tileheight
    sta.z vera_layer_mode_tile.tileheight
    // [644] phi vera_layer_mode_tile::tilewidth#10 = vera_layer_mode_text::tilewidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    lda #tilewidth
    sta.z vera_layer_mode_tile.tilewidth
    // [644] phi vera_layer_mode_tile::tilebase_address#10 = vera_layer_mode_text::tilebase_address#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<tilebase_address>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>tilebase_address>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [644] phi vera_layer_mode_tile::mapbase_address#10 = vera_layer_mode_text::mapbase_address#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<mapbase_address>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>mapbase_address>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [644] phi vera_layer_mode_tile::mapheight#10 = vera_layer_mode_text::mapheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#4] -- vwuz1=vwuc1 
    lda #<mapheight
    sta.z vera_layer_mode_tile.mapheight
    lda #>mapheight
    sta.z vera_layer_mode_tile.mapheight+1
    // [644] phi vera_layer_mode_tile::layer#10 = vera_layer_mode_text::layer#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #layer
    sta.z vera_layer_mode_tile.layer
    // [644] phi vera_layer_mode_tile::mapwidth#10 = vera_layer_mode_text::mapwidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#6] -- vwuz1=vwuc1 
    lda #<mapwidth
    sta.z vera_layer_mode_tile.mapwidth
    lda #>mapwidth
    sta.z vera_layer_mode_tile.mapwidth+1
    // [644] phi vera_layer_mode_tile::color_depth#3 = 1 [phi:vera_layer_mode_text->vera_layer_mode_tile#7] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_mode_tile
    // [395] phi from vera_layer_mode_text to vera_layer_mode_text::@1 [phi:vera_layer_mode_text->vera_layer_mode_text::@1]
    // vera_layer_mode_text::@1
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C )
    // [396] call vera_layer_set_text_color_mode 
    jsr vera_layer_set_text_color_mode
    // vera_layer_mode_text::@return
    // }
    // [397] return 
    rts
}
  // screensize
// Return the current screen size.
screensize: {
    .label x = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    .label y = cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    // hscale = (*VERA_DC_HSCALE) >> 7
    // [398] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuaa=_deref_pbuc1_ror_7 
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    // 40 << hscale
    // [399] screensize::$1 = $28 << screensize::hscale#0 -- vbuaa=vbuc1_rol_vbuaa 
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
    // [400] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbuaa 
    sta x
    // vscale = (*VERA_DC_VSCALE) >> 7
    // [401] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuaa=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    // 30 << vscale
    // [402] screensize::$3 = $1e << screensize::vscale#0 -- vbuaa=vbuc1_rol_vbuaa 
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
    // [403] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbuaa 
    sta y
    // screensize::@return
    // }
    // [404] return 
    rts
}
  // screenlayer
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer: {
    .label __1 = $73
    .label __5 = $73
    .label vera_layer_get_width1_config = $75
    .label vera_layer_get_width1_return = $73
    .label vera_layer_get_height1_config = $73
    .label vera_layer_get_height1_return = $73
    // cx16_conio.conio_screen_layer = layer
    // [405] *((byte*)&cx16_conio) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta cx16_conio
    // vera_layer_get_mapbase_bank(layer)
    // [406] call vera_layer_get_mapbase_bank 
    jsr vera_layer_get_mapbase_bank
    // [407] vera_layer_get_mapbase_bank::return#2 = vera_layer_get_mapbase_bank::return#0
    // screenlayer::@3
    // [408] screenlayer::$0 = vera_layer_get_mapbase_bank::return#2
    // cx16_conio.conio_screen_bank = vera_layer_get_mapbase_bank(layer)
    // [409] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) = screenlayer::$0 -- _deref_pbuc1=vbuaa 
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // vera_layer_get_mapbase_offset(layer)
    // [410] call vera_layer_get_mapbase_offset 
    jsr vera_layer_get_mapbase_offset
    // [411] vera_layer_get_mapbase_offset::return#2 = vera_layer_get_mapbase_offset::return#0
    // screenlayer::@4
    // [412] screenlayer::$1 = vera_layer_get_mapbase_offset::return#2
    // cx16_conio.conio_screen_text = vera_layer_get_mapbase_offset(layer)
    // [413] *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) = (byte*)screenlayer::$1 -- _deref_qbuc1=pbuz1 
    lda.z __1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    lda.z __1+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    // screenlayer::vera_layer_get_width1
    // config = vera_layer_config[layer]
    // [414] screenlayer::vera_layer_get_width1_config#0 = *(vera_layer_config+1<<1) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+(1<<1)
    sta.z vera_layer_get_width1_config
    lda vera_layer_config+(1<<1)+1
    sta.z vera_layer_get_width1_config+1
    // *config & VERA_LAYER_WIDTH_MASK
    // [415] screenlayer::vera_layer_get_width1_$0 = *screenlayer::vera_layer_get_width1_config#0 & VERA_LAYER_WIDTH_MASK -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    ldy #0
    and (vera_layer_get_width1_config),y
    // (*config & VERA_LAYER_WIDTH_MASK) >> 4
    // [416] screenlayer::vera_layer_get_width1_$1 = screenlayer::vera_layer_get_width1_$0 >> 4 -- vbuaa=vbuaa_ror_4 
    lsr
    lsr
    lsr
    lsr
    // return VERA_LAYER_WIDTH[ (*config & VERA_LAYER_WIDTH_MASK) >> 4];
    // [417] screenlayer::vera_layer_get_width1_$3 = screenlayer::vera_layer_get_width1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [418] screenlayer::vera_layer_get_width1_return#0 = VERA_LAYER_WIDTH[screenlayer::vera_layer_get_width1_$3] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda VERA_LAYER_WIDTH,y
    sta.z vera_layer_get_width1_return
    lda VERA_LAYER_WIDTH+1,y
    sta.z vera_layer_get_width1_return+1
    // screenlayer::@1
    // cx16_conio.conio_map_width = vera_layer_get_width(layer)
    // [419] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) = screenlayer::vera_layer_get_width1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_width1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    lda.z vera_layer_get_width1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    // screenlayer::vera_layer_get_height1
    // config = vera_layer_config[layer]
    // [420] screenlayer::vera_layer_get_height1_config#0 = *(vera_layer_config+1<<1) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+(1<<1)
    sta.z vera_layer_get_height1_config
    lda vera_layer_config+(1<<1)+1
    sta.z vera_layer_get_height1_config+1
    // *config & VERA_LAYER_HEIGHT_MASK
    // [421] screenlayer::vera_layer_get_height1_$0 = *screenlayer::vera_layer_get_height1_config#0 & VERA_LAYER_HEIGHT_MASK -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    ldy #0
    and (vera_layer_get_height1_config),y
    // (*config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [422] screenlayer::vera_layer_get_height1_$1 = screenlayer::vera_layer_get_height1_$0 >> 6 -- vbuaa=vbuaa_ror_6 
    rol
    rol
    rol
    and #3
    // return VERA_LAYER_HEIGHT[ (*config & VERA_LAYER_HEIGHT_MASK) >> 6];
    // [423] screenlayer::vera_layer_get_height1_$3 = screenlayer::vera_layer_get_height1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [424] screenlayer::vera_layer_get_height1_return#0 = VERA_LAYER_HEIGHT[screenlayer::vera_layer_get_height1_$3] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda VERA_LAYER_HEIGHT,y
    sta.z vera_layer_get_height1_return
    lda VERA_LAYER_HEIGHT+1,y
    sta.z vera_layer_get_height1_return+1
    // screenlayer::@2
    // cx16_conio.conio_map_height = vera_layer_get_height(layer)
    // [425] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) = screenlayer::vera_layer_get_height1_return#0 -- _deref_pwuc1=vwuz1 
    lda.z vera_layer_get_height1_return
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    lda.z vera_layer_get_height1_return+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    // vera_layer_get_rowshift(layer)
    // [426] call vera_layer_get_rowshift 
    jsr vera_layer_get_rowshift
    // [427] vera_layer_get_rowshift::return#2 = vera_layer_get_rowshift::return#0
    // screenlayer::@5
    // [428] screenlayer::$4 = vera_layer_get_rowshift::return#2
    // cx16_conio.conio_rowshift = vera_layer_get_rowshift(layer)
    // [429] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) = screenlayer::$4 -- _deref_pbuc1=vbuaa 
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT
    // vera_layer_get_rowskip(layer)
    // [430] call vera_layer_get_rowskip 
    jsr vera_layer_get_rowskip
    // [431] vera_layer_get_rowskip::return#2 = vera_layer_get_rowskip::return#0
    // screenlayer::@6
    // [432] screenlayer::$5 = vera_layer_get_rowskip::return#2
    // cx16_conio.conio_rowskip = vera_layer_get_rowskip(layer)
    // [433] *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) = screenlayer::$5 -- _deref_pwuc1=vwuz1 
    lda.z __5
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    lda.z __5+1
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    // screenlayer::@return
    // }
    // [434] return 
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
    // [436] vera_layer_textcolor[vera_layer_set_textcolor::layer#2] = WHITE -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #WHITE
    sta vera_layer_textcolor,x
    // vera_layer_set_textcolor::@return
    // }
    // [437] return 
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
    // [439] vera_layer_backcolor[vera_layer_set_backcolor::layer#2] = vera_layer_set_backcolor::color#2 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta vera_layer_backcolor,x
    // vera_layer_set_backcolor::@return
    // }
    // [440] return 
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
    .label addr = $73
    // addr = vera_layer_mapbase[layer]
    // [442] vera_layer_set_mapbase::$0 = vera_layer_set_mapbase::layer#3 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [443] vera_layer_set_mapbase::addr#0 = vera_layer_mapbase[vera_layer_set_mapbase::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_mapbase,y
    sta.z addr
    lda vera_layer_mapbase+1,y
    sta.z addr+1
    // *addr = mapbase
    // [444] *vera_layer_set_mapbase::addr#0 = vera_layer_set_mapbase::mapbase#3 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_mapbase::@return
    // }
    // [445] return 
    rts
}
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
cursor: {
    .const onoff = 0
    // cx16_conio.conio_display_cursor = onoff
    // [446] *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_DISPLAY_CURSOR
    // cursor::@return
    // }
    // [447] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .label __6 = $77
    .label line_offset = $77
    // if(y>cx16_conio.conio_screen_height)
    // [449] if(gotoxy::y#3<=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto gotoxy::@4 -- vbuxx_le__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    stx.z $ff
    cmp.z $ff
    bcs __b1
    // [451] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [451] phi gotoxy::y#4 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [450] phi from gotoxy to gotoxy::@4 [phi:gotoxy->gotoxy::@4]
    // gotoxy::@4
    // [451] phi from gotoxy::@4 to gotoxy::@1 [phi:gotoxy::@4->gotoxy::@1]
    // [451] phi gotoxy::y#4 = gotoxy::y#3 [phi:gotoxy::@4->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=cx16_conio.conio_screen_width)
    // [452] if(0<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto gotoxy::@2 -- 0_lt__deref_pbuc1_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    cmp #0
    // [453] phi from gotoxy::@1 to gotoxy::@3 [phi:gotoxy::@1->gotoxy::@3]
    // gotoxy::@3
    // gotoxy::@2
    // conio_cursor_x[cx16_conio.conio_screen_layer] = x
    // [454] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = y
    // [455] conio_cursor_y[*((byte*)&cx16_conio)] = gotoxy::y#4 -- pbuc1_derefidx_(_deref_pbuc2)=vbuxx 
    txa
    sta conio_cursor_y,y
    // (unsigned int)y << cx16_conio.conio_rowshift
    // [456] gotoxy::$6 = (word)gotoxy::y#4 -- vwuz1=_word_vbuxx 
    txa
    sta.z __6
    lda #0
    sta.z __6+1
    // line_offset = (unsigned int)y << cx16_conio.conio_rowshift
    // [457] gotoxy::line_offset#0 = gotoxy::$6 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vwuz1_rol__deref_pbuc1 
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
    // [458] gotoxy::$5 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // [459] conio_line_text[gotoxy::$5] = gotoxy::line_offset#0 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z line_offset
    sta conio_line_text,y
    lda.z line_offset+1
    sta conio_line_text+1,y
    // gotoxy::@return
    // }
    // [460] return 
    rts
}
  // cx16_load_ram_banked
// Load a file to cx16 banked RAM at address A000-BFFF.
// Returns a status:
// - 0xff: Success
// - other: Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
// cx16_load_ram_banked(byte* zp($bb) filename, dword zp($17) address)
cx16_load_ram_banked: {
    .label __0 = $b9
    .label __1 = $b9
    .label __3 = $b2
    .label __5 = $b0
    .label __6 = $b0
    .label __7 = $c5
    .label __8 = $c5
    .label __10 = $b0
    .label __11 = $b4
    .label __33 = $b0
    .label __34 = $b4
    .label bank = $4b
    // select the bank
    .label addr = $b4
    .label status = $b8
    .label return = $b8
    .label ch = $c4
    .label address = $17
    .label filename = $bb
    // >address
    // [462] cx16_load_ram_banked::$0 = > cx16_load_ram_banked::address#7 -- vwuz1=_hi_vduz2 
    lda.z address+2
    sta.z __0
    lda.z address+3
    sta.z __0+1
    // (>address)<<8
    // [463] cx16_load_ram_banked::$1 = cx16_load_ram_banked::$0 << 8 -- vwuz1=vwuz1_rol_8 
    lda.z __1
    sta.z __1+1
    lda #0
    sta.z __1
    // <(>address)<<8
    // [464] cx16_load_ram_banked::$2 = < cx16_load_ram_banked::$1 -- vbuxx=_lo_vwuz1 
    tax
    // <address
    // [465] cx16_load_ram_banked::$3 = < cx16_load_ram_banked::address#7 -- vwuz1=_lo_vduz2 
    lda.z address
    sta.z __3
    lda.z address+1
    sta.z __3+1
    // >(<address)
    // [466] cx16_load_ram_banked::$4 = > cx16_load_ram_banked::$3 -- vbuyy=_hi_vwuz1 
    tay
    // ((word)<(>address)<<8)|>(<address)
    // [467] cx16_load_ram_banked::$33 = (word)cx16_load_ram_banked::$2 -- vwuz1=_word_vbuxx 
    txa
    sta.z __33
    sta.z __33+1
    // [468] cx16_load_ram_banked::$5 = cx16_load_ram_banked::$33 | cx16_load_ram_banked::$4 -- vwuz1=vwuz1_bor_vbuyy 
    tya
    ora.z __5
    sta.z __5
    // (((word)<(>address)<<8)|>(<address))>>5
    // [469] cx16_load_ram_banked::$6 = cx16_load_ram_banked::$5 >> 5 -- vwuz1=vwuz1_ror_5 
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
    // [470] cx16_load_ram_banked::$7 = > cx16_load_ram_banked::address#7 -- vwuz1=_hi_vduz2 
    lda.z address+2
    sta.z __7
    lda.z address+3
    sta.z __7+1
    // (>address)<<3
    // [471] cx16_load_ram_banked::$8 = cx16_load_ram_banked::$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    // <(>address)<<3
    // [472] cx16_load_ram_banked::$9 = < cx16_load_ram_banked::$8 -- vbuaa=_lo_vwuz1 
    lda.z __8
    // ((((word)<(>address)<<8)|>(<address))>>5)+((word)<(>address)<<3)
    // [473] cx16_load_ram_banked::$34 = (word)cx16_load_ram_banked::$9 -- vwuz1=_word_vbuaa 
    sta.z __34
    txa
    sta.z __34+1
    // [474] cx16_load_ram_banked::$10 = cx16_load_ram_banked::$6 + cx16_load_ram_banked::$34 -- vwuz1=vwuz1_plus_vwuz2 
    lda.z __10
    clc
    adc.z __34
    sta.z __10
    lda.z __10+1
    adc.z __34+1
    sta.z __10+1
    // bank = (byte)(((((word)<(>address)<<8)|>(<address))>>5)+((word)<(>address)<<3))
    // [475] cx16_load_ram_banked::bank#0 = (byte)cx16_load_ram_banked::$10 -- vbuz1=_byte_vwuz2 
    lda.z __10
    sta.z bank
    // <address
    // [476] cx16_load_ram_banked::$11 = < cx16_load_ram_banked::address#7 -- vwuz1=_lo_vduz2 
    lda.z address
    sta.z __11
    lda.z address+1
    sta.z __11+1
    // (<address)&0x1FFF
    // [477] cx16_load_ram_banked::addr#0 = cx16_load_ram_banked::$11 & $1fff -- vwuz1=vwuz1_band_vwuc1 
    lda.z addr
    and #<$1fff
    sta.z addr
    lda.z addr+1
    and #>$1fff
    sta.z addr+1
    // addr += 0xA000
    // [478] cx16_load_ram_banked::addr#1 = (byte*)cx16_load_ram_banked::addr#0 + $a000 -- pbuz1=pbuz1_plus_vwuc1 
    // stip off the top 3 bits, which are representing the bank of the word!
    clc
    lda.z addr
    adc #<$a000
    sta.z addr
    lda.z addr+1
    adc #>$a000
    sta.z addr+1
    // cx16_ram_bank(bank)
    // [479] cx16_ram_bank::bank#0 = cx16_load_ram_banked::bank#0 -- vbuxx=vbuz1 
    ldx.z bank
    // [480] call cx16_ram_bank 
    // [1158] phi from cx16_load_ram_banked to cx16_ram_bank [phi:cx16_load_ram_banked->cx16_ram_bank]
    // [1158] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#0 [phi:cx16_load_ram_banked->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // cx16_load_ram_banked::@8
    // cbm_k_setnam(filename)
    // [481] cbm_k_setnam::filename = cx16_load_ram_banked::filename#7 -- pbuz1=pbuz2 
    lda.z filename
    sta.z cbm_k_setnam.filename
    lda.z filename+1
    sta.z cbm_k_setnam.filename+1
    // [482] call cbm_k_setnam 
    jsr cbm_k_setnam
    // cx16_load_ram_banked::@9
    // cbm_k_setlfs(channel, device, secondary)
    // [483] cbm_k_setlfs::channel = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cbm_k_setlfs.channel
    // [484] cbm_k_setlfs::device = 8 -- vbuz1=vbuc1 
    lda #8
    sta.z cbm_k_setlfs.device
    // [485] cbm_k_setlfs::secondary = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_setlfs.secondary
    // [486] call cbm_k_setlfs 
    jsr cbm_k_setlfs
    // [487] phi from cx16_load_ram_banked::@9 to cx16_load_ram_banked::@10 [phi:cx16_load_ram_banked::@9->cx16_load_ram_banked::@10]
    // cx16_load_ram_banked::@10
    // cbm_k_open()
    // [488] call cbm_k_open 
    jsr cbm_k_open
    // [489] cbm_k_open::return#2 = cbm_k_open::return#1
    // cx16_load_ram_banked::@11
    // [490] cx16_load_ram_banked::status#1 = cbm_k_open::return#2 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$FF)
    // [491] if(cx16_load_ram_banked::status#1==$ff) goto cx16_load_ram_banked::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [492] phi from cx16_load_ram_banked::@11 cx16_load_ram_banked::@12 cx16_load_ram_banked::@16 to cx16_load_ram_banked::@return [phi:cx16_load_ram_banked::@11/cx16_load_ram_banked::@12/cx16_load_ram_banked::@16->cx16_load_ram_banked::@return]
    // [492] phi cx16_load_ram_banked::return#1 = cx16_load_ram_banked::status#1 [phi:cx16_load_ram_banked::@11/cx16_load_ram_banked::@12/cx16_load_ram_banked::@16->cx16_load_ram_banked::@return#0] -- register_copy 
    // cx16_load_ram_banked::@return
    // }
    // [493] return 
    rts
    // cx16_load_ram_banked::@1
  __b1:
    // cbm_k_chkin(channel)
    // [494] cbm_k_chkin::channel = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cbm_k_chkin.channel
    // [495] call cbm_k_chkin 
    jsr cbm_k_chkin
    // [496] cbm_k_chkin::return#2 = cbm_k_chkin::return#1
    // cx16_load_ram_banked::@12
    // [497] cx16_load_ram_banked::status#2 = cbm_k_chkin::return#2 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$FF)
    // [498] if(cx16_load_ram_banked::status#2==$ff) goto cx16_load_ram_banked::@2 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b2
    rts
    // [499] phi from cx16_load_ram_banked::@12 to cx16_load_ram_banked::@2 [phi:cx16_load_ram_banked::@12->cx16_load_ram_banked::@2]
    // cx16_load_ram_banked::@2
  __b2:
    // cbm_k_chrin()
    // [500] call cbm_k_chrin 
    jsr cbm_k_chrin
    // [501] cbm_k_chrin::return#2 = cbm_k_chrin::return#1
    // cx16_load_ram_banked::@13
    // ch = cbm_k_chrin()
    // [502] cx16_load_ram_banked::ch#1 = cbm_k_chrin::return#2 -- vbuz1=vbuaa 
    sta.z ch
    // cbm_k_readst()
    // [503] call cbm_k_readst 
    jsr cbm_k_readst
    // [504] cbm_k_readst::return#2 = cbm_k_readst::return#1
    // cx16_load_ram_banked::@14
    // status = cbm_k_readst()
    // [505] cx16_load_ram_banked::status#3 = cbm_k_readst::return#2
    // [506] phi from cx16_load_ram_banked::@14 cx16_load_ram_banked::@18 to cx16_load_ram_banked::@3 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3]
    // [506] phi cx16_load_ram_banked::bank#2 = cx16_load_ram_banked::bank#0 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#0] -- register_copy 
    // [506] phi cx16_load_ram_banked::ch#3 = cx16_load_ram_banked::ch#1 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#1] -- register_copy 
    // [506] phi cx16_load_ram_banked::addr#4 = cx16_load_ram_banked::addr#1 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#2] -- register_copy 
    // [506] phi cx16_load_ram_banked::status#8 = cx16_load_ram_banked::status#3 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#3] -- register_copy 
    // cx16_load_ram_banked::@3
  __b3:
    // while (!status)
    // [507] if(0==cx16_load_ram_banked::status#8) goto cx16_load_ram_banked::@4 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b4
    // cx16_load_ram_banked::@5
    // cbm_k_close(channel)
    // [508] cbm_k_close::channel = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cbm_k_close.channel
    // [509] call cbm_k_close 
    jsr cbm_k_close
    // [510] cbm_k_close::return#2 = cbm_k_close::return#1
    // cx16_load_ram_banked::@15
    // [511] cx16_load_ram_banked::status#10 = cbm_k_close::return#2 -- vbuz1=vbuaa 
    sta.z status
    // cbm_k_clrchn()
    // [512] call cbm_k_clrchn 
    jsr cbm_k_clrchn
    // [513] phi from cx16_load_ram_banked::@15 to cx16_load_ram_banked::@16 [phi:cx16_load_ram_banked::@15->cx16_load_ram_banked::@16]
    // cx16_load_ram_banked::@16
    // cx16_ram_bank(1)
    // [514] call cx16_ram_bank 
    // [1158] phi from cx16_load_ram_banked::@16 to cx16_ram_bank [phi:cx16_load_ram_banked::@16->cx16_ram_bank]
    // [1158] phi cx16_ram_bank::bank#11 = 1 [phi:cx16_load_ram_banked::@16->cx16_ram_bank#0] -- vbuxx=vbuc1 
    ldx #1
    jsr cx16_ram_bank
    rts
    // cx16_load_ram_banked::@4
  __b4:
    // if(addr == 0xC000)
    // [515] if(cx16_load_ram_banked::addr#4!=$c000) goto cx16_load_ram_banked::@6 -- pbuz1_neq_vwuc1_then_la1 
    lda.z addr+1
    cmp #>$c000
    bne __b6
    lda.z addr
    cmp #<$c000
    bne __b6
    // cx16_load_ram_banked::@7
    // bank++;
    // [516] cx16_load_ram_banked::bank#1 = ++ cx16_load_ram_banked::bank#2 -- vbuz1=_inc_vbuz1 
    inc.z bank
    // cx16_ram_bank(bank)
    // [517] cx16_ram_bank::bank#2 = cx16_load_ram_banked::bank#1 -- vbuxx=vbuz1 
    ldx.z bank
    // [518] call cx16_ram_bank 
  //printf(", %u", (word)bank);
    // [1158] phi from cx16_load_ram_banked::@7 to cx16_ram_bank [phi:cx16_load_ram_banked::@7->cx16_ram_bank]
    // [1158] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#2 [phi:cx16_load_ram_banked::@7->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [519] phi from cx16_load_ram_banked::@7 to cx16_load_ram_banked::@6 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@6]
    // [519] phi cx16_load_ram_banked::bank#10 = cx16_load_ram_banked::bank#1 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@6#0] -- register_copy 
    // [519] phi cx16_load_ram_banked::addr#5 = (byte*) 40960 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@6#1] -- pbuz1=pbuc1 
    lda #<$a000
    sta.z addr
    lda #>$a000
    sta.z addr+1
    // [519] phi from cx16_load_ram_banked::@4 to cx16_load_ram_banked::@6 [phi:cx16_load_ram_banked::@4->cx16_load_ram_banked::@6]
    // [519] phi cx16_load_ram_banked::bank#10 = cx16_load_ram_banked::bank#2 [phi:cx16_load_ram_banked::@4->cx16_load_ram_banked::@6#0] -- register_copy 
    // [519] phi cx16_load_ram_banked::addr#5 = cx16_load_ram_banked::addr#4 [phi:cx16_load_ram_banked::@4->cx16_load_ram_banked::@6#1] -- register_copy 
    // cx16_load_ram_banked::@6
  __b6:
    // *addr = ch
    // [520] *cx16_load_ram_banked::addr#5 = cx16_load_ram_banked::ch#3 -- _deref_pbuz1=vbuz2 
    lda.z ch
    ldy #0
    sta (addr),y
    // addr++;
    // [521] cx16_load_ram_banked::addr#10 = ++ cx16_load_ram_banked::addr#5 -- pbuz1=_inc_pbuz1 
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    // cbm_k_chrin()
    // [522] call cbm_k_chrin 
    jsr cbm_k_chrin
    // [523] cbm_k_chrin::return#3 = cbm_k_chrin::return#1
    // cx16_load_ram_banked::@17
    // ch = cbm_k_chrin()
    // [524] cx16_load_ram_banked::ch#2 = cbm_k_chrin::return#3 -- vbuz1=vbuaa 
    sta.z ch
    // cbm_k_readst()
    // [525] call cbm_k_readst 
    jsr cbm_k_readst
    // [526] cbm_k_readst::return#3 = cbm_k_readst::return#1
    // cx16_load_ram_banked::@18
    // status = cbm_k_readst()
    // [527] cx16_load_ram_banked::status#5 = cbm_k_readst::return#3
    jmp __b3
}
  // cputs
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp($6c) s)
cputs: {
    .label s = $6c
    // [529] phi from cputs cputs::@2 to cputs::@1 [phi:cputs/cputs::@2->cputs::@1]
    // [529] phi cputs::s#18 = cputs::s#19 [phi:cputs/cputs::@2->cputs::@1#0] -- register_copy 
    // cputs::@1
  __b1:
    // while(c=*s++)
    // [530] cputs::c#1 = *cputs::s#18 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (s),y
    // [531] cputs::s#0 = ++ cputs::s#18 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [532] if(0!=cputs::c#1) goto cputs::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // cputs::@return
    // }
    // [533] return 
    rts
    // cputs::@2
  __b2:
    // cputc(c)
    // [534] cputc::c#0 = cputs::c#1 -- vbuz1=vbuaa 
    sta.z cputc.c
    // [535] call cputc 
    // [1198] phi from cputs::@2 to cputc [phi:cputs::@2->cputc]
    // [1198] phi cputc::c#3 = cputc::c#0 [phi:cputs::@2->cputc#0] -- register_copy 
    jsr cputc
    jmp __b1
}
  // printf_uchar
// Print an unsigned char using a specific format
// printf_uchar(byte register(X) uvalue, byte register(Y) format_radix)
printf_uchar: {
    // printf_uchar::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [537] *((byte*)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    // [538] uctoa::value#1 = printf_uchar::uvalue#10
    // [539] uctoa::radix#0 = printf_uchar::format_radix#10
    // [540] call uctoa 
    // Format number into buffer
    jsr uctoa
    // printf_uchar::@2
    // printf_number_buffer(printf_buffer, format)
    // [541] printf_number_buffer::buffer_sign#2 = *((byte*)&printf_buffer) -- vbuz1=_deref_pbuc1 
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
    // [542] call printf_number_buffer 
  // Print using format
    // [1260] phi from printf_uchar::@2 to printf_number_buffer [phi:printf_uchar::@2->printf_number_buffer]
    // [1260] phi printf_number_buffer::format_upper_case#10 = 0 [phi:printf_uchar::@2->printf_number_buffer#0] -- vbuz1=vbuc1 
    lda #0
    sta.z printf_number_buffer.format_upper_case
    // [1260] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#2 [phi:printf_uchar::@2->printf_number_buffer#1] -- register_copy 
    // [1260] phi printf_number_buffer::format_zero_padding#10 = 0 [phi:printf_uchar::@2->printf_number_buffer#2] -- vbuz1=vbuc1 
    sta.z printf_number_buffer.format_zero_padding
    // [1260] phi printf_number_buffer::format_justify_left#10 = 0 [phi:printf_uchar::@2->printf_number_buffer#3] -- vbuz1=vbuc1 
    sta.z printf_number_buffer.format_justify_left
    // [1260] phi printf_number_buffer::format_min_length#3 = 0 [phi:printf_uchar::@2->printf_number_buffer#4] -- vbuxx=vbuc1 
    tax
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [543] return 
    rts
}
  // cx16_rom_bank
// Configure the bank of a banked rom on the X16.
// cx16_rom_bank(byte register(A) bank)
cx16_rom_bank: {
    // VIA1->PORT_B = bank
    // [545] *((byte*)VIA1) = cx16_rom_bank::bank#2 -- _deref_pbuc1=vbuaa 
    sta VIA1
    // cx16_rom_bank::@return
    // }
    // [546] return 
    rts
}
  // vera_heap_segment_init
// vera heap
// vera_heap_segment_init(byte register(X) segmentid, dword zp($13) base, dword zp($17) size)
vera_heap_segment_init: {
    .label __1 = $17
    .label segment = $b9
    .label return = $13
    .label base = $13
    .label size = $17
    // &vera_heap_segments[segmentid]
    // [548] vera_heap_segment_init::$17 = vera_heap_segment_init::segmentid#4 << 2 -- vbuaa=vbuxx_rol_2 
    txa
    asl
    asl
    // [549] vera_heap_segment_init::$18 = vera_heap_segment_init::$17 + vera_heap_segment_init::segmentid#4 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [550] vera_heap_segment_init::$19 = vera_heap_segment_init::$18 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [551] vera_heap_segment_init::$20 = vera_heap_segment_init::$19 + vera_heap_segment_init::segmentid#4 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [552] vera_heap_segment_init::$2 = vera_heap_segment_init::$20 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // segment = &vera_heap_segments[segmentid]
    // [553] vera_heap_segment_init::segment#0 = vera_heap_segments + vera_heap_segment_init::$2 -- pssz1=pssc1_plus_vbuaa 
    clc
    adc #<vera_heap_segments
    sta.z segment
    lda #>vera_heap_segments
    adc #0
    sta.z segment+1
    // segment->size = size
    // [554] *((dword*)vera_heap_segment_init::segment#0) = vera_heap_segment_init::size#4 -- _deref_pduz1=vduz2 
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
    // [555] ((dword*)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_BASE_ADDRESS] = vera_heap_segment_init::base#4 -- pduz1_derefidx_vbuc1=vduz2 
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
    // [556] vera_heap_segment_init::$1 = vera_heap_segment_init::base#4 + vera_heap_segment_init::size#4 -- vduz1=vduz2_plus_vduz1 
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
    // [557] ((dword*)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS] = vera_heap_segment_init::$1 -- pduz1_derefidx_vbuc1=vduz2 
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
    // [558] ((dword*)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS] = vera_heap_segment_init::base#4 -- pduz1_derefidx_vbuc1=vduz2 
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
    // [559] ((struct vera_heap**)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK] = (struct vera_heap*) 0 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK
    lda #<0
    sta (segment),y
    iny
    sta (segment),y
    // segment->tail_block = 0x0000
    // [560] ((struct vera_heap**)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] = (struct vera_heap*) 0 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    sta (segment),y
    iny
    sta (segment),y
    // return segment->ceil_address;
    // [561] vera_heap_segment_init::return#0 = ((dword*)vera_heap_segment_init::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
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
    // vera_heap_segment_init::@return
    // }
    // [562] return 
    rts
}
  // vera_heap_malloc
// vera_heap_malloc(byte register(X) segmentid, word zp($52) size)
vera_heap_malloc: {
    .label size = $52
    .label address = $a9
    .label __8 = $33
    .label segment = $b2
    .label size_test = $b0
    .label return = $17
    .label block = $b0
    .label head_block = $b4
    .label block_1 = $bb
    .label tail_block = $b0
    // address
    // [564] vera_heap_malloc::address = 0 -- vduz1=vduc1 
    lda #<0
    sta.z address
    sta.z address+1
    lda #<0>>$10
    sta.z address+2
    lda #>0>>$10
    sta.z address+3
    // &(vera_heap_segments[segmentid])
    // [565] vera_heap_malloc::$48 = vera_heap_malloc::segmentid#4 << 2 -- vbuaa=vbuxx_rol_2 
    txa
    asl
    asl
    // [566] vera_heap_malloc::$49 = vera_heap_malloc::$48 + vera_heap_malloc::segmentid#4 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [567] vera_heap_malloc::$50 = vera_heap_malloc::$49 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [568] vera_heap_malloc::$51 = vera_heap_malloc::$50 + vera_heap_malloc::segmentid#4 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [569] vera_heap_malloc::$23 = vera_heap_malloc::$51 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // segment = &(vera_heap_segments[segmentid])
    // [570] vera_heap_malloc::segment#0 = vera_heap_segments + vera_heap_malloc::$23 -- pssz1=pssc1_plus_vbuaa 
    clc
    adc #<vera_heap_segments
    sta.z segment
    lda #>vera_heap_segments
    adc #0
    sta.z segment+1
    // cx16_ram_bank(vera_heap_ram_bank)
    // [571] call cx16_ram_bank 
    // [1158] phi from vera_heap_malloc to cx16_ram_bank [phi:vera_heap_malloc->cx16_ram_bank]
    // [1158] phi cx16_ram_bank::bank#11 = vera_heap_ram_bank#0 [phi:vera_heap_malloc->cx16_ram_bank#0] -- vbuxx=vbuc1 
    ldx #vera_heap_ram_bank
    jsr cx16_ram_bank
    // cx16_ram_bank(vera_heap_ram_bank)
    // [572] cx16_ram_bank::return#14 = cx16_ram_bank::return#0
    // vera_heap_malloc::@12
    // cx16_ram_bank_current = cx16_ram_bank(vera_heap_ram_bank)
    // [573] vera_heap_malloc::cx16_ram_bank_current#0 = cx16_ram_bank::return#14 -- vbuxx=vbuaa 
    tax
    // if (!size)
    // [574] if(0!=vera_heap_malloc::size) goto vera_heap_malloc::@1 -- 0_neq_vwuz1_then_la1 
    lda.z size
    ora.z size+1
    bne __b1
    // vera_heap_malloc::@7
    // cx16_ram_bank(cx16_ram_bank_current)
    // [575] cx16_ram_bank::bank#4 = vera_heap_malloc::cx16_ram_bank_current#0
    // [576] call cx16_ram_bank 
    // [1158] phi from vera_heap_malloc::@7 to cx16_ram_bank [phi:vera_heap_malloc::@7->cx16_ram_bank]
    // [1158] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#4 [phi:vera_heap_malloc::@7->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [577] phi from vera_heap_malloc::@10 vera_heap_malloc::@7 vera_heap_malloc::@8 to vera_heap_malloc::@return [phi:vera_heap_malloc::@10/vera_heap_malloc::@7/vera_heap_malloc::@8->vera_heap_malloc::@return]
  __b7:
    // [577] phi vera_heap_malloc::return#1 = 0 [phi:vera_heap_malloc::@10/vera_heap_malloc::@7/vera_heap_malloc::@8->vera_heap_malloc::@return#0] -- vduz1=vbuc1 
    lda #0
    sta.z return
    sta.z return+1
    sta.z return+2
    sta.z return+3
    // vera_heap_malloc::@return
    // }
    // [578] return 
    rts
    // vera_heap_malloc::@1
  __b1:
    // size_test = size
    // [579] vera_heap_malloc::size_test#0 = vera_heap_malloc::size -- vwuz1=vwuz2 
    // Validate if size is a multiple of 32!
    lda.z size
    sta.z size_test
    lda.z size+1
    sta.z size_test+1
    // size_test >>=5
    // [580] vera_heap_malloc::size_test#1 = vera_heap_malloc::size_test#0 >> 5 -- vwuz1=vwuz1_ror_5 
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
    // [581] vera_heap_malloc::size_test#2 = vera_heap_malloc::size_test#1 << 5 -- vwuz1=vwuz1_rol_5 
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
    // [582] if(vera_heap_malloc::size==vera_heap_malloc::size_test#2) goto vera_heap_malloc::@2 -- vwuz1_eq_vwuz2_then_la1 
    lda.z size
    cmp.z size_test
    bne !+
    lda.z size+1
    cmp.z size_test+1
    beq __b2
  !:
    // vera_heap_malloc::@8
    // cx16_ram_bank(cx16_ram_bank_current)
    // [583] cx16_ram_bank::bank#5 = vera_heap_malloc::cx16_ram_bank_current#0
    // [584] call cx16_ram_bank 
    // [1158] phi from vera_heap_malloc::@8 to cx16_ram_bank [phi:vera_heap_malloc::@8->cx16_ram_bank]
    // [1158] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#5 [phi:vera_heap_malloc::@8->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    jmp __b7
    // vera_heap_malloc::@2
  __b2:
    // vera_heap_block_free_find(segment, size)
    // [585] vera_heap_block_free_find::segment#0 = vera_heap_malloc::segment#0 -- pssz1=pssz2 
    lda.z segment
    sta.z vera_heap_block_free_find.segment
    lda.z segment+1
    sta.z vera_heap_block_free_find.segment+1
    // [586] vera_heap_block_free_find::size#0 = vera_heap_malloc::size -- vduz1=vwuz2 
    lda.z size
    sta.z vera_heap_block_free_find.size
    lda.z size+1
    sta.z vera_heap_block_free_find.size+1
    lda #0
    sta.z vera_heap_block_free_find.size+2
    sta.z vera_heap_block_free_find.size+3
    // [587] call vera_heap_block_free_find 
    jsr vera_heap_block_free_find
    // [588] vera_heap_block_free_find::return#3 = vera_heap_block_free_find::return#2
    // vera_heap_malloc::@13
    // block = vera_heap_block_free_find(segment, size)
    // [589] vera_heap_malloc::block#1 = vera_heap_block_free_find::return#3
    // if (block)
    // [590] if((struct vera_heap*)0==vera_heap_malloc::block#1) goto vera_heap_malloc::@3 -- pssc1_eq_pssz1_then_la1 
    lda.z block
    cmp #<0
    bne !+
    lda.z block+1
    cmp #>0
    beq __b3
  !:
    // vera_heap_malloc::@9
    // vera_heap_block_empty_set(block, 0)
    // [591] vera_heap_block_empty_set::block#0 = vera_heap_malloc::block#1 -- pssz1=pssz2 
    lda.z block
    sta.z vera_heap_block_empty_set.block
    lda.z block+1
    sta.z vera_heap_block_empty_set.block+1
    // [592] call vera_heap_block_empty_set 
    // [1313] phi from vera_heap_malloc::@9 to vera_heap_block_empty_set [phi:vera_heap_malloc::@9->vera_heap_block_empty_set]
    // [1313] phi vera_heap_block_empty_set::block#2 = vera_heap_block_empty_set::block#0 [phi:vera_heap_malloc::@9->vera_heap_block_empty_set#0] -- register_copy 
    jsr vera_heap_block_empty_set
    // vera_heap_malloc::@15
    // cx16_ram_bank(cx16_ram_bank_current)
    // [593] cx16_ram_bank::bank#6 = vera_heap_malloc::cx16_ram_bank_current#0
    // [594] call cx16_ram_bank 
    // [1158] phi from vera_heap_malloc::@15 to cx16_ram_bank [phi:vera_heap_malloc::@15->cx16_ram_bank]
    // [1158] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#6 [phi:vera_heap_malloc::@15->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // vera_heap_malloc::@16
    // vera_heap_block_address_get(block)
    // [595] vera_heap_block_address_get::block#0 = vera_heap_malloc::block#1
    // [596] call vera_heap_block_address_get 
    jsr vera_heap_block_address_get
    // [597] vera_heap_block_address_get::return#2 = vera_heap_block_address_get::return#0
    // vera_heap_malloc::@17
    // return (vera_heap_block_address_get(block));
    // [598] vera_heap_malloc::return#3 = vera_heap_block_address_get::return#2
    // [577] phi from vera_heap_malloc::@17 vera_heap_malloc::@21 to vera_heap_malloc::@return [phi:vera_heap_malloc::@17/vera_heap_malloc::@21->vera_heap_malloc::@return]
    // [577] phi vera_heap_malloc::return#1 = vera_heap_malloc::return#3 [phi:vera_heap_malloc::@17/vera_heap_malloc::@21->vera_heap_malloc::@return#0] -- register_copy 
    rts
    // vera_heap_malloc::@3
  __b3:
    // vera_heap_address(segment, size)
    // [599] vera_heap_address::segment#0 = vera_heap_malloc::segment#0 -- pssz1=pssz2 
    lda.z segment
    sta.z vera_heap_address.segment
    lda.z segment+1
    sta.z vera_heap_address.segment+1
    // [600] vera_heap_address::size#0 = vera_heap_malloc::size -- vduz1=vwuz2 
    lda.z size
    sta.z vera_heap_address.size
    lda.z size+1
    sta.z vera_heap_address.size+1
    lda #0
    sta.z vera_heap_address.size+2
    sta.z vera_heap_address.size+3
    // [601] call vera_heap_address 
    jsr vera_heap_address
    // [602] vera_heap_address::return#3 = vera_heap_address::return#2
    // vera_heap_malloc::@14
    // [603] vera_heap_malloc::$8 = vera_heap_address::return#3
    // address = vera_heap_address(segment, size)
    // [604] vera_heap_malloc::address = vera_heap_malloc::$8 -- vduz1=vduz2 
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
    // [605] if(vera_heap_malloc::address!=0) goto vera_heap_malloc::@4 -- vduz1_neq_0_then_la1 
    lda.z address
    ora.z address+1
    bne __b4
    ora.z address+2
    bne __b4
    ora.z address+3
    bne __b4
    // vera_heap_malloc::@10
    // cx16_ram_bank(cx16_ram_bank_current)
    // [606] cx16_ram_bank::bank#7 = vera_heap_malloc::cx16_ram_bank_current#0
    // [607] call cx16_ram_bank 
    // [1158] phi from vera_heap_malloc::@10 to cx16_ram_bank [phi:vera_heap_malloc::@10->cx16_ram_bank]
    // [1158] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#7 [phi:vera_heap_malloc::@10->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    jmp __b7
    // vera_heap_malloc::@4
  __b4:
    // head_block = segment->head_block
    // [608] vera_heap_malloc::head_block#0 = ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK
    lda (segment),y
    sta.z head_block
    iny
    lda (segment),y
    sta.z head_block+1
    // if (head_block==0x0000)
    // [609] if(vera_heap_malloc::head_block#0==0) goto vera_heap_malloc::@5 -- pssz1_eq_0_then_la1 
    // If the first block ever, en setup the head and start from A000.
    lda.z head_block
    ora.z head_block+1
    beq __b5
    // vera_heap_malloc::@11
    // block = segment->tail_block
    // [610] vera_heap_malloc::block#3 = ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] -- pssz1=qssz2_derefidx_vbuc1 
    // Increase the heap size (increase vera_heap_tail_block).
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    lda (segment),y
    sta.z block_1
    iny
    lda (segment),y
    sta.z block_1+1
    // block += sizeof(struct vera_heap)
    // [611] vera_heap_malloc::block#4 = vera_heap_malloc::block#3 + SIZEOF_STRUCT_VERA_HEAP*SIZEOF_STRUCT_VERA_HEAP -- pssz1=pssz1_plus_vbuc1 
    // TODO: fragment
    lda #SIZEOF_STRUCT_VERA_HEAP*SIZEOF_STRUCT_VERA_HEAP
    clc
    adc.z block_1
    sta.z block_1
    bcc !+
    inc.z block_1+1
  !:
    // tail_block = segment->tail_block
    // [612] vera_heap_malloc::tail_block#0 = ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] -- pssz1=qssz2_derefidx_vbuc1 
    // TODO: fragment
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    lda (segment),y
    sta.z tail_block
    iny
    lda (segment),y
    sta.z tail_block+1
    // block->prev = tail_block
    // [613] ((struct vera_heap**)vera_heap_malloc::block#4)[OFFSET_STRUCT_VERA_HEAP_PREV] = vera_heap_malloc::tail_block#0 -- qssz1_derefidx_vbuc1=pssz2 
    //TODO: error or fragment
    ldy #OFFSET_STRUCT_VERA_HEAP_PREV
    lda.z tail_block
    sta (block_1),y
    iny
    lda.z tail_block+1
    sta (block_1),y
    // tail_block->next = block
    // [614] ((struct vera_heap**)vera_heap_malloc::tail_block#0)[OFFSET_STRUCT_VERA_HEAP_NEXT] = vera_heap_malloc::block#4 -- qssz1_derefidx_vbuc1=pssz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_NEXT
    lda.z block_1
    sta (tail_block),y
    iny
    lda.z block_1+1
    sta (tail_block),y
    // segment->tail_block = block
    // [615] ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] = vera_heap_malloc::block#4 -- qssz1_derefidx_vbuc1=pssz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    lda.z block_1
    sta (segment),y
    iny
    lda.z block_1+1
    sta (segment),y
    // block->next = 0x0000
    // [616] ((struct vera_heap**)vera_heap_malloc::block#4)[OFFSET_STRUCT_VERA_HEAP_NEXT] = (struct vera_heap*) 0 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_NEXT
    lda #<0
    sta (block_1),y
    iny
    sta (block_1),y
    // [617] phi from vera_heap_malloc::@11 to vera_heap_malloc::@6 [phi:vera_heap_malloc::@11->vera_heap_malloc::@6]
    // [617] phi vera_heap_malloc::block#7 = vera_heap_malloc::block#4 [phi:vera_heap_malloc::@11->vera_heap_malloc::@6#0] -- register_copy 
    // vera_heap_malloc::@6
  __b6:
    // vera_heap_block_address_set(block, &address)
    // [618] vera_heap_block_address_set::block#0 = vera_heap_malloc::block#7 -- pssz1=pssz2 
    lda.z block_1
    sta.z vera_heap_block_address_set.block
    lda.z block_1+1
    sta.z vera_heap_block_address_set.block+1
    // [619] call vera_heap_block_address_set 
    jsr vera_heap_block_address_set
    // vera_heap_malloc::@18
    // vera_heap_block_size_set(block, &size)
    // [620] vera_heap_block_size_set::block#0 = vera_heap_malloc::block#7 -- pssz1=pssz2 
    lda.z block_1
    sta.z vera_heap_block_size_set.block
    lda.z block_1+1
    sta.z vera_heap_block_size_set.block+1
    // [621] call vera_heap_block_size_set 
    jsr vera_heap_block_size_set
    // vera_heap_malloc::@19
    // vera_heap_block_empty_set(block, 0)
    // [622] vera_heap_block_empty_set::block#1 = vera_heap_malloc::block#7
    // [623] call vera_heap_block_empty_set 
    // [1313] phi from vera_heap_malloc::@19 to vera_heap_block_empty_set [phi:vera_heap_malloc::@19->vera_heap_block_empty_set]
    // [1313] phi vera_heap_block_empty_set::block#2 = vera_heap_block_empty_set::block#1 [phi:vera_heap_malloc::@19->vera_heap_block_empty_set#0] -- register_copy 
    jsr vera_heap_block_empty_set
    // vera_heap_malloc::@20
    // cx16_ram_bank(cx16_ram_bank_current)
    // [624] cx16_ram_bank::bank#8 = vera_heap_malloc::cx16_ram_bank_current#0
    // [625] call cx16_ram_bank 
    // [1158] phi from vera_heap_malloc::@20 to cx16_ram_bank [phi:vera_heap_malloc::@20->cx16_ram_bank]
    // [1158] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#8 [phi:vera_heap_malloc::@20->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // vera_heap_malloc::@21
    // return address;
    // [626] vera_heap_malloc::return#5 = vera_heap_malloc::address -- vduz1=vduz2 
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
    // [627] ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK] = (struct vera_heap*) 40960 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK
    lda #<$a000
    sta (segment),y
    iny
    lda #>$a000
    sta (segment),y
    // segment->tail_block = 0xA000
    // [628] ((struct vera_heap**)vera_heap_malloc::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK] = (struct vera_heap*) 40960 -- qssz1_derefidx_vbuc1=pssc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_TAIL_BLOCK
    lda #<$a000
    sta (segment),y
    iny
    lda #>$a000
    sta (segment),y
    // block->next = 0x0000
    // [629] *((struct vera_heap**)(struct vera_heap*) 40960+OFFSET_STRUCT_VERA_HEAP_NEXT) = (struct vera_heap*) 0 -- _deref_qssc1=pssc2 
    lda #<0
    sta $a000+OFFSET_STRUCT_VERA_HEAP_NEXT
    sta $a000+OFFSET_STRUCT_VERA_HEAP_NEXT+1
    // block->prev = 0x0000
    // [630] *((struct vera_heap**)(struct vera_heap*) 40960+OFFSET_STRUCT_VERA_HEAP_PREV) = (struct vera_heap*) 0 -- _deref_qssc1=pssc2 
    sta $a000+OFFSET_STRUCT_VERA_HEAP_PREV
    sta $a000+OFFSET_STRUCT_VERA_HEAP_PREV+1
    // [617] phi from vera_heap_malloc::@5 to vera_heap_malloc::@6 [phi:vera_heap_malloc::@5->vera_heap_malloc::@6]
    // [617] phi vera_heap_malloc::block#7 = (struct vera_heap*) 40960 [phi:vera_heap_malloc::@5->vera_heap_malloc::@6#0] -- pssz1=pssc1 
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
    .label i = $26
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [631] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_L = <(<vsrc)
    // [632] *VERA_ADDRX_L = 0 -- _deref_pbuc1=vbuc2 
    // Set address
    lda #0
    sta VERA_ADDRX_L
    // *VERA_ADDRX_M = >(<vsrc)
    // [633] *VERA_ADDRX_M = ><VERA_PETSCII_TILE -- _deref_pbuc1=vbuc2 
    lda #>VERA_PETSCII_TILE&$ffff
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>vsrc)
    // [634] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [635] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    // Select DATA1
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_L = <(<vdest)
    // [636] *VERA_ADDRX_L = 0 -- _deref_pbuc1=vbuc2 
    // Set address
    lda #0
    sta VERA_ADDRX_L
    // *VERA_ADDRX_M = >(<vdest)
    // [637] *VERA_ADDRX_M = ><VRAM_PETSCII_TILE -- _deref_pbuc1=vbuc2 
    lda #>VRAM_PETSCII_TILE&$ffff
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>vdest)
    // [638] *VERA_ADDRX_H = VERA_INC_1|<>VRAM_PETSCII_TILE -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VRAM_PETSCII_TILE>>$10))
    sta VERA_ADDRX_H
    // [639] phi from vera_cpy_vram_vram to vera_cpy_vram_vram::@1 [phi:vera_cpy_vram_vram->vera_cpy_vram_vram::@1]
    // [639] phi vera_cpy_vram_vram::i#2 = 0 [phi:vera_cpy_vram_vram->vera_cpy_vram_vram::@1#0] -- vduz1=vduc1 
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
    // [640] if(vera_cpy_vram_vram::i#2<VERA_PETSCII_TILE_SIZE) goto vera_cpy_vram_vram::@2 -- vduz1_lt_vduc1_then_la1 
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
    // [641] return 
    rts
    // vera_cpy_vram_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [642] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(dword i=0; i<num; i++)
    // [643] vera_cpy_vram_vram::i#1 = ++ vera_cpy_vram_vram::i#2 -- vduz1=_inc_vduz1 
    inc.z i
    bne !+
    inc.z i+1
    bne !+
    inc.z i+2
    bne !+
    inc.z i+3
  !:
    // [639] phi from vera_cpy_vram_vram::@2 to vera_cpy_vram_vram::@1 [phi:vera_cpy_vram_vram::@2->vera_cpy_vram_vram::@1]
    // [639] phi vera_cpy_vram_vram::i#2 = vera_cpy_vram_vram::i#1 [phi:vera_cpy_vram_vram::@2->vera_cpy_vram_vram::@1#0] -- register_copy 
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
// vera_layer_mode_tile(byte zp($1b) layer, dword zp($1c) mapbase_address, dword zp($20) tilebase_address, word zp($73) mapwidth, word zp($75) mapheight, byte zp($24) tilewidth, byte zp($25) tileheight, byte register(X) color_depth)
vera_layer_mode_tile: {
    .label __1 = $73
    .label __2 = $73
    .label __4 = $73
    .label __7 = $73
    .label __8 = $73
    .label __10 = $73
    .label __19 = $ad
    .label __20 = $ae
    .label mapbase_address = $1c
    .label tilebase_address = $20
    .label layer = $1b
    .label mapwidth = $73
    .label mapheight = $75
    .label tilewidth = $24
    .label tileheight = $25
    // case 1:
    //             config |= VERA_LAYER_COLOR_DEPTH_1BPP;
    //             break;
    // [645] if(vera_layer_mode_tile::color_depth#3==1) goto vera_layer_mode_tile::@5 -- vbuxx_eq_vbuc1_then_la1 
    cpx #1
    beq __b1
    // vera_layer_mode_tile::@1
    // case 2:
    //             config |= VERA_LAYER_COLOR_DEPTH_2BPP;
    //             break;
    // [646] if(vera_layer_mode_tile::color_depth#3==2) goto vera_layer_mode_tile::@5 -- vbuxx_eq_vbuc1_then_la1 
    cpx #2
    beq __b2
    // vera_layer_mode_tile::@2
    // case 4:
    //             config |= VERA_LAYER_COLOR_DEPTH_4BPP;
    //             break;
    // [647] if(vera_layer_mode_tile::color_depth#3==4) goto vera_layer_mode_tile::@5 -- vbuxx_eq_vbuc1_then_la1 
    cpx #4
    beq __b3
    // vera_layer_mode_tile::@3
    // case 8:
    //             config |= VERA_LAYER_COLOR_DEPTH_8BPP;
    //             break;
    // [648] if(vera_layer_mode_tile::color_depth#3!=8) goto vera_layer_mode_tile::@5 -- vbuxx_neq_vbuc1_then_la1 
    cpx #8
    bne __b4
    // [649] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@4 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@4]
    // vera_layer_mode_tile::@4
    // [650] phi from vera_layer_mode_tile::@4 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5]
    // [650] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_8BPP [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_8BPP
    jmp __b5
    // [650] phi from vera_layer_mode_tile to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5]
  __b1:
    // [650] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_1BPP [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_1BPP
    jmp __b5
    // [650] phi from vera_layer_mode_tile::@1 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5]
  __b2:
    // [650] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_2BPP [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_2BPP
    jmp __b5
    // [650] phi from vera_layer_mode_tile::@2 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5]
  __b3:
    // [650] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_4BPP [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_4BPP
    jmp __b5
    // [650] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5]
  __b4:
    // [650] phi vera_layer_mode_tile::config#17 = 0 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #0
    // vera_layer_mode_tile::@5
  __b5:
    // case 32:
    //             config |= VERA_LAYER_WIDTH_32;
    //             vera_layer_rowshift[layer] = 6;
    //             vera_layer_rowskip[layer] = 64;
    //             break;
    // [651] if(vera_layer_mode_tile::mapwidth#10==$20) goto vera_layer_mode_tile::@9 -- vwuz1_eq_vbuc1_then_la1 
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
    // [652] if(vera_layer_mode_tile::mapwidth#10==$40) goto vera_layer_mode_tile::@10 -- vwuz1_eq_vbuc1_then_la1 
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
    // [653] if(vera_layer_mode_tile::mapwidth#10==$80) goto vera_layer_mode_tile::@11 -- vwuz1_eq_vbuc1_then_la1 
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
    // [654] if(vera_layer_mode_tile::mapwidth#10!=$100) goto vera_layer_mode_tile::@13 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapwidth+1
    cmp #>$100
    bne __b13
    lda.z mapwidth
    cmp #<$100
    bne __b13
    // vera_layer_mode_tile::@12
    // config |= VERA_LAYER_WIDTH_256
    // [655] vera_layer_mode_tile::config#8 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_256 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_WIDTH_256
    tax
    // vera_layer_rowshift[layer] = 9
    // [656] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 9 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #9
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 512
    // [657] vera_layer_mode_tile::$16 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [658] vera_layer_rowskip[vera_layer_mode_tile::$16] = $200 -- pwuc1_derefidx_vbuaa=vwuc2 
    tay
    lda #<$200
    sta vera_layer_rowskip,y
    lda #>$200
    sta vera_layer_rowskip+1,y
    // [659] phi from vera_layer_mode_tile::@10 vera_layer_mode_tile::@11 vera_layer_mode_tile::@12 vera_layer_mode_tile::@8 vera_layer_mode_tile::@9 to vera_layer_mode_tile::@13 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13]
    // [659] phi vera_layer_mode_tile::config#21 = vera_layer_mode_tile::config#6 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13#0] -- register_copy 
    // vera_layer_mode_tile::@13
  __b13:
    // case 32:
    //             config |= VERA_LAYER_HEIGHT_32;
    //             break;
    // [660] if(vera_layer_mode_tile::mapheight#10==$20) goto vera_layer_mode_tile::@20 -- vwuz1_eq_vbuc1_then_la1 
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
    // [661] if(vera_layer_mode_tile::mapheight#10==$40) goto vera_layer_mode_tile::@17 -- vwuz1_eq_vbuc1_then_la1 
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
    // [662] if(vera_layer_mode_tile::mapheight#10==$80) goto vera_layer_mode_tile::@18 -- vwuz1_eq_vbuc1_then_la1 
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
    // [663] if(vera_layer_mode_tile::mapheight#10!=$100) goto vera_layer_mode_tile::@20 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapheight+1
    cmp #>$100
    bne __b20
    lda.z mapheight
    cmp #<$100
    bne __b20
    // vera_layer_mode_tile::@19
    // config |= VERA_LAYER_HEIGHT_256
    // [664] vera_layer_mode_tile::config#12 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_256 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_HEIGHT_256
    tax
    // [665] phi from vera_layer_mode_tile::@13 vera_layer_mode_tile::@16 vera_layer_mode_tile::@17 vera_layer_mode_tile::@18 vera_layer_mode_tile::@19 to vera_layer_mode_tile::@20 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20]
    // [665] phi vera_layer_mode_tile::config#25 = vera_layer_mode_tile::config#21 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20#0] -- register_copy 
    // vera_layer_mode_tile::@20
  __b20:
    // vera_layer_set_config(layer, config)
    // [666] vera_layer_set_config::layer#0 = vera_layer_mode_tile::layer#10 -- vbuaa=vbuz1 
    lda.z layer
    // [667] vera_layer_set_config::config#0 = vera_layer_mode_tile::config#25
    // [668] call vera_layer_set_config 
    jsr vera_layer_set_config
    // vera_layer_mode_tile::@27
    // <mapbase_address
    // [669] vera_layer_mode_tile::$1 = < vera_layer_mode_tile::mapbase_address#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase_address
    sta.z __1
    lda.z mapbase_address+1
    sta.z __1+1
    // vera_mapbase_offset[layer] = <mapbase_address
    // [670] vera_layer_mode_tile::$19 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z layer
    asl
    sta.z __19
    // [671] vera_mapbase_offset[vera_layer_mode_tile::$19] = vera_layer_mode_tile::$1 -- pwuc1_derefidx_vbuz1=vwuz2 
    // mapbase
    tay
    lda.z __1
    sta vera_mapbase_offset,y
    lda.z __1+1
    sta vera_mapbase_offset+1,y
    // >mapbase_address
    // [672] vera_layer_mode_tile::$2 = > vera_layer_mode_tile::mapbase_address#10 -- vwuz1=_hi_vduz2 
    lda.z mapbase_address+2
    sta.z __2
    lda.z mapbase_address+3
    sta.z __2+1
    // vera_mapbase_bank[layer] = (byte)(>mapbase_address)
    // [673] vera_mapbase_bank[vera_layer_mode_tile::layer#10] = (byte)vera_layer_mode_tile::$2 -- pbuc1_derefidx_vbuz1=_byte_vwuz2 
    ldy.z layer
    lda.z __2
    sta vera_mapbase_bank,y
    // vera_mapbase_address[layer] = mapbase_address
    // [674] vera_layer_mode_tile::$20 = vera_layer_mode_tile::layer#10 << 2 -- vbuz1=vbuz2_rol_2 
    tya
    asl
    asl
    sta.z __20
    // [675] vera_mapbase_address[vera_layer_mode_tile::$20] = vera_layer_mode_tile::mapbase_address#10 -- pduc1_derefidx_vbuz1=vduz2 
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
    // [676] vera_layer_mode_tile::mapbase_address#0 = vera_layer_mode_tile::mapbase_address#10 >> 1 -- vduz1=vduz1_ror_1 
    lsr.z mapbase_address+3
    ror.z mapbase_address+2
    ror.z mapbase_address+1
    ror.z mapbase_address
    // <mapbase_address
    // [677] vera_layer_mode_tile::$4 = < vera_layer_mode_tile::mapbase_address#0 -- vwuz1=_lo_vduz2 
    lda.z mapbase_address
    sta.z __4
    lda.z mapbase_address+1
    sta.z __4+1
    // mapbase = >(<mapbase_address)
    // [678] vera_layer_mode_tile::mapbase#0 = > vera_layer_mode_tile::$4 -- vbuxx=_hi_vwuz1 
    tax
    // vera_layer_set_mapbase(layer,mapbase)
    // [679] vera_layer_set_mapbase::layer#0 = vera_layer_mode_tile::layer#10 -- vbuaa=vbuz1 
    lda.z layer
    // [680] vera_layer_set_mapbase::mapbase#0 = vera_layer_mode_tile::mapbase#0
    // [681] call vera_layer_set_mapbase 
    // [441] phi from vera_layer_mode_tile::@27 to vera_layer_set_mapbase [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase]
    // [441] phi vera_layer_set_mapbase::mapbase#3 = vera_layer_set_mapbase::mapbase#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#0] -- register_copy 
    // [441] phi vera_layer_set_mapbase::layer#3 = vera_layer_set_mapbase::layer#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#1] -- register_copy 
    jsr vera_layer_set_mapbase
    // vera_layer_mode_tile::@28
    // <tilebase_address
    // [682] vera_layer_mode_tile::$7 = < vera_layer_mode_tile::tilebase_address#10 -- vwuz1=_lo_vduz2 
    lda.z tilebase_address
    sta.z __7
    lda.z tilebase_address+1
    sta.z __7+1
    // vera_tilebase_offset[layer] = <tilebase_address
    // [683] vera_tilebase_offset[vera_layer_mode_tile::$19] = vera_layer_mode_tile::$7 -- pwuc1_derefidx_vbuz1=vwuz2 
    // tilebase
    ldy.z __19
    lda.z __7
    sta vera_tilebase_offset,y
    lda.z __7+1
    sta vera_tilebase_offset+1,y
    // >tilebase_address
    // [684] vera_layer_mode_tile::$8 = > vera_layer_mode_tile::tilebase_address#10 -- vwuz1=_hi_vduz2 
    lda.z tilebase_address+2
    sta.z __8
    lda.z tilebase_address+3
    sta.z __8+1
    // vera_tilebase_bank[layer] = (byte)>tilebase_address
    // [685] vera_tilebase_bank[vera_layer_mode_tile::layer#10] = (byte)vera_layer_mode_tile::$8 -- pbuc1_derefidx_vbuz1=_byte_vwuz2 
    ldy.z layer
    lda.z __8
    sta vera_tilebase_bank,y
    // vera_tilebase_address[layer] = tilebase_address
    // [686] vera_tilebase_address[vera_layer_mode_tile::$20] = vera_layer_mode_tile::tilebase_address#10 -- pduc1_derefidx_vbuz1=vduz2 
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
    // [687] vera_layer_mode_tile::tilebase_address#0 = vera_layer_mode_tile::tilebase_address#10 >> 1 -- vduz1=vduz1_ror_1 
    lsr.z tilebase_address+3
    ror.z tilebase_address+2
    ror.z tilebase_address+1
    ror.z tilebase_address
    // <tilebase_address
    // [688] vera_layer_mode_tile::$10 = < vera_layer_mode_tile::tilebase_address#0 -- vwuz1=_lo_vduz2 
    lda.z tilebase_address
    sta.z __10
    lda.z tilebase_address+1
    sta.z __10+1
    // tilebase = >(<tilebase_address)
    // [689] vera_layer_mode_tile::tilebase#0 = > vera_layer_mode_tile::$10 -- vbuaa=_hi_vwuz1 
    // tilebase &= VERA_LAYER_TILEBASE_MASK
    // [690] vera_layer_mode_tile::tilebase#1 = vera_layer_mode_tile::tilebase#0 & VERA_LAYER_TILEBASE_MASK -- vbuxx=vbuaa_band_vbuc1 
    and #VERA_LAYER_TILEBASE_MASK
    tax
    // case 8:
    //             tilebase |= VERA_TILEBASE_WIDTH_8;
    //             break;
    // [691] if(vera_layer_mode_tile::tilewidth#10==8) goto vera_layer_mode_tile::@23 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tilewidth
    beq __b23
    // vera_layer_mode_tile::@21
    // case 16:
    //             tilebase |= VERA_TILEBASE_WIDTH_16;
    //             break;
    // [692] if(vera_layer_mode_tile::tilewidth#10!=$10) goto vera_layer_mode_tile::@23 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tilewidth
    bne __b23
    // vera_layer_mode_tile::@22
    // tilebase |= VERA_TILEBASE_WIDTH_16
    // [693] vera_layer_mode_tile::tilebase#3 = vera_layer_mode_tile::tilebase#1 | VERA_TILEBASE_WIDTH_16 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_TILEBASE_WIDTH_16
    tax
    // [694] phi from vera_layer_mode_tile::@21 vera_layer_mode_tile::@22 vera_layer_mode_tile::@28 to vera_layer_mode_tile::@23 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23]
    // [694] phi vera_layer_mode_tile::tilebase#12 = vera_layer_mode_tile::tilebase#1 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23#0] -- register_copy 
    // vera_layer_mode_tile::@23
  __b23:
    // case 8:
    //             tilebase |= VERA_TILEBASE_HEIGHT_8;
    //             break;
    // [695] if(vera_layer_mode_tile::tileheight#10==8) goto vera_layer_mode_tile::@26 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tileheight
    beq __b26
    // vera_layer_mode_tile::@24
    // case 16:
    //             tilebase |= VERA_TILEBASE_HEIGHT_16;
    //             break;
    // [696] if(vera_layer_mode_tile::tileheight#10!=$10) goto vera_layer_mode_tile::@26 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tileheight
    bne __b26
    // vera_layer_mode_tile::@25
    // tilebase |= VERA_TILEBASE_HEIGHT_16
    // [697] vera_layer_mode_tile::tilebase#5 = vera_layer_mode_tile::tilebase#12 | VERA_TILEBASE_HEIGHT_16 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_TILEBASE_HEIGHT_16
    tax
    // [698] phi from vera_layer_mode_tile::@23 vera_layer_mode_tile::@24 vera_layer_mode_tile::@25 to vera_layer_mode_tile::@26 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26]
    // [698] phi vera_layer_mode_tile::tilebase#10 = vera_layer_mode_tile::tilebase#12 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26#0] -- register_copy 
    // vera_layer_mode_tile::@26
  __b26:
    // vera_layer_set_tilebase(layer,tilebase)
    // [699] vera_layer_set_tilebase::layer#0 = vera_layer_mode_tile::layer#10 -- vbuaa=vbuz1 
    lda.z layer
    // [700] vera_layer_set_tilebase::tilebase#0 = vera_layer_mode_tile::tilebase#10
    // [701] call vera_layer_set_tilebase 
    jsr vera_layer_set_tilebase
    // vera_layer_mode_tile::@return
    // }
    // [702] return 
    rts
    // vera_layer_mode_tile::@18
  __b18:
    // config |= VERA_LAYER_HEIGHT_128
    // [703] vera_layer_mode_tile::config#11 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_128 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_HEIGHT_128
    tax
    jmp __b20
    // vera_layer_mode_tile::@17
  __b17:
    // config |= VERA_LAYER_HEIGHT_64
    // [704] vera_layer_mode_tile::config#10 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_64 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_HEIGHT_64
    tax
    jmp __b20
    // vera_layer_mode_tile::@11
  __b11:
    // config |= VERA_LAYER_WIDTH_128
    // [705] vera_layer_mode_tile::config#7 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_128 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_WIDTH_128
    tax
    // vera_layer_rowshift[layer] = 8
    // [706] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 8 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #8
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 256
    // [707] vera_layer_mode_tile::$15 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [708] vera_layer_rowskip[vera_layer_mode_tile::$15] = $100 -- pwuc1_derefidx_vbuaa=vwuc2 
    tay
    lda #<$100
    sta vera_layer_rowskip,y
    lda #>$100
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@10
  __b10:
    // config |= VERA_LAYER_WIDTH_64
    // [709] vera_layer_mode_tile::config#6 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_64 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_WIDTH_64
    tax
    // vera_layer_rowshift[layer] = 7
    // [710] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 7 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #7
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 128
    // [711] vera_layer_mode_tile::$14 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [712] vera_layer_rowskip[vera_layer_mode_tile::$14] = $80 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #$80
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@9
  __b9:
    // vera_layer_rowshift[layer] = 6
    // [713] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 6 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #6
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 64
    // [714] vera_layer_mode_tile::$13 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [715] vera_layer_rowskip[vera_layer_mode_tile::$13] = $40 -- pwuc1_derefidx_vbuaa=vbuc2 
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
    .label __1 = $af
    .label line_text = $b4
    .label color = $af
    .label conio_map_height = $b0
    .label conio_map_width = $bb
    // line_text = cx16_conio.conio_screen_text
    // [716] clrscr::line_text#0 = *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- pbuz1=_deref_qbuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z line_text+1
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer)
    // [717] vera_layer_get_backcolor::layer#0 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [718] call vera_layer_get_backcolor 
    jsr vera_layer_get_backcolor
    // [719] vera_layer_get_backcolor::return#2 = vera_layer_get_backcolor::return#0
    // clrscr::@7
    // [720] clrscr::$0 = vera_layer_get_backcolor::return#2
    // vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4
    // [721] clrscr::$1 = clrscr::$0 << 4 -- vbuz1=vbuaa_rol_4 
    asl
    asl
    asl
    asl
    sta.z __1
    // vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [722] vera_layer_get_textcolor::layer#0 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [723] call vera_layer_get_textcolor 
    jsr vera_layer_get_textcolor
    // [724] vera_layer_get_textcolor::return#2 = vera_layer_get_textcolor::return#0
    // clrscr::@8
    // [725] clrscr::$2 = vera_layer_get_textcolor::return#2
    // color = ( vera_layer_get_backcolor(cx16_conio.conio_screen_layer) << 4 ) | vera_layer_get_textcolor(cx16_conio.conio_screen_layer)
    // [726] clrscr::color#0 = clrscr::$1 | clrscr::$2 -- vbuz1=vbuz1_bor_vbuaa 
    ora.z color
    sta.z color
    // conio_map_height = cx16_conio.conio_map_height
    // [727] clrscr::conio_map_height#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT
    sta.z conio_map_height
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_HEIGHT+1
    sta.z conio_map_height+1
    // conio_map_width = cx16_conio.conio_map_width
    // [728] clrscr::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // [729] phi from clrscr::@8 to clrscr::@1 [phi:clrscr::@8->clrscr::@1]
    // [729] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr::@8->clrscr::@1#0] -- register_copy 
    // [729] phi clrscr::l#2 = 0 [phi:clrscr::@8->clrscr::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // clrscr::@1
  __b1:
    // for( char l=0;l<conio_map_height; l++ )
    // [730] if(clrscr::l#2<clrscr::conio_map_height#0) goto clrscr::@2 -- vbuxx_lt_vwuz1_then_la1 
    lda.z conio_map_height+1
    bne __b2
    cpx.z conio_map_height
    bcc __b2
    // clrscr::@3
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [731] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer] = 0
    // [732] conio_cursor_y[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    sta conio_cursor_y,y
    // conio_line_text[cx16_conio.conio_screen_layer] = 0
    // [733] clrscr::$9 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    tya
    asl
    // [734] conio_line_text[clrscr::$9] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta conio_line_text,y
    sta conio_line_text+1,y
    // clrscr::@return
    // }
    // [735] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [736] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <ch
    // [737] clrscr::$5 = < clrscr::line_text#2 -- vbuaa=_lo_pbuz1 
    lda.z line_text
    // *VERA_ADDRX_L = <ch
    // [738] *VERA_ADDRX_L = clrscr::$5 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >ch
    // [739] clrscr::$6 = > clrscr::line_text#2 -- vbuaa=_hi_pbuz1 
    lda.z line_text+1
    // *VERA_ADDRX_M = >ch
    // [740] *VERA_ADDRX_M = clrscr::$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [741] clrscr::$7 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [742] *VERA_ADDRX_H = clrscr::$7 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [743] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [743] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuyy=vbuc1 
    ldy #0
    // clrscr::@4
  __b4:
    // for( char c=0;c<conio_map_width; c++ )
    // [744] if(clrscr::c#2<clrscr::conio_map_width#0) goto clrscr::@5 -- vbuyy_lt_vwuz1_then_la1 
    lda.z conio_map_width+1
    bne __b5
    cpy.z conio_map_width
    bcc __b5
    // clrscr::@6
    // line_text += cx16_conio.conio_rowskip
    // [745] clrscr::line_text#1 = clrscr::line_text#2 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- pbuz1=pbuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z line_text
    sta.z line_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z line_text+1
    sta.z line_text+1
    // for( char l=0;l<conio_map_height; l++ )
    // [746] clrscr::l#1 = ++ clrscr::l#2 -- vbuxx=_inc_vbuxx 
    inx
    // [729] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [729] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [729] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [747] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [748] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<conio_map_width; c++ )
    // [749] clrscr::c#1 = ++ clrscr::c#2 -- vbuyy=_inc_vbuyy 
    iny
    // [743] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [743] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
}
  // cpy_graphics
// cpy_graphics(byte zp($2f) segmentid, dword zp($26) bsrc, dword* zp($b6) array, byte zp($2e) num, word zp($b9) size)
cpy_graphics: {
    .label __3 = $54
    .label vaddr = $17
    .label baddr = $54
    .label s = $af
    .label num = $2e
    .label segmentid = $2f
    .label size = $b9
    .label bsrc = $26
    .label array = $b6
    // [751] phi from cpy_graphics to cpy_graphics::@1 [phi:cpy_graphics->cpy_graphics::@1]
    // [751] phi cpy_graphics::s#2 = 0 [phi:cpy_graphics->cpy_graphics::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z s
  // Copy graphics to the VERA VRAM.
    // cpy_graphics::@1
  __b1:
    // for(byte s=0;s<num;s++)
    // [752] if(cpy_graphics::s#2<cpy_graphics::num#6) goto cpy_graphics::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z s
    cmp.z num
    bcc __b2
    // cpy_graphics::@return
    // }
    // [753] return 
    rts
    // cpy_graphics::@2
  __b2:
    // vera_heap_malloc(segmentid, size)
    // [754] vera_heap_malloc::segmentid#0 = cpy_graphics::segmentid#7 -- vbuxx=vbuz1 
    ldx.z segmentid
    // [755] vera_heap_malloc::size = cpy_graphics::size#10 -- vwuz1=vwuz2 
    lda.z size
    sta.z vera_heap_malloc.size
    lda.z size+1
    sta.z vera_heap_malloc.size+1
    // [756] call vera_heap_malloc 
    // [563] phi from cpy_graphics::@2 to vera_heap_malloc [phi:cpy_graphics::@2->vera_heap_malloc]
    // [563] phi vera_heap_malloc::segmentid#4 = vera_heap_malloc::segmentid#0 [phi:cpy_graphics::@2->vera_heap_malloc#0] -- register_copy 
    jsr vera_heap_malloc
    // vera_heap_malloc(segmentid, size)
    // [757] vera_heap_malloc::return#11 = vera_heap_malloc::return#1
    // cpy_graphics::@3
    // vaddr = vera_heap_malloc(segmentid, size)
    // [758] cpy_graphics::vaddr#0 = vera_heap_malloc::return#11
    // printf("%x\n", vaddr)
    // [759] printf_ulong::uvalue#0 = cpy_graphics::vaddr#0 -- vduz1=vduz2 
    lda.z vaddr
    sta.z printf_ulong.uvalue
    lda.z vaddr+1
    sta.z printf_ulong.uvalue+1
    lda.z vaddr+2
    sta.z printf_ulong.uvalue+2
    lda.z vaddr+3
    sta.z printf_ulong.uvalue+3
    // [760] call printf_ulong 
    // [1371] phi from cpy_graphics::@3 to printf_ulong [phi:cpy_graphics::@3->printf_ulong]
    jsr printf_ulong
    // [761] phi from cpy_graphics::@3 to cpy_graphics::@4 [phi:cpy_graphics::@3->cpy_graphics::@4]
    // cpy_graphics::@4
    // printf("%x\n", vaddr)
    // [762] call cputs 
    // [528] phi from cpy_graphics::@4 to cputs [phi:cpy_graphics::@4->cputs]
    // [528] phi cputs::s#19 = s1 [phi:cpy_graphics::@4->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // cpy_graphics::@5
    // mul16u((word)s,size)
    // [763] mul16u::a#1 = (word)cpy_graphics::s#2 -- vwuz1=_word_vbuz2 
    lda.z s
    sta.z mul16u.a
    lda #0
    sta.z mul16u.a+1
    // [764] mul16u::b#0 = cpy_graphics::size#10
    // [765] call mul16u 
    jsr mul16u
    // [766] mul16u::return#2 = mul16u::res#2
    // cpy_graphics::@6
    // [767] cpy_graphics::$3 = mul16u::return#2
    // baddr = bsrc+mul16u((word)s,size)
    // [768] cpy_graphics::baddr#0 = cpy_graphics::bsrc#11 + cpy_graphics::$3 -- vduz1=vduz2_plus_vduz1 
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
    // [769] vera_cpy_bank_vram::bsrc#0 = cpy_graphics::baddr#0
    // [770] vera_cpy_bank_vram::vdest#0 = cpy_graphics::vaddr#0 -- vduz1=vduz2 
    lda.z vaddr
    sta.z vera_cpy_bank_vram.vdest
    lda.z vaddr+1
    sta.z vera_cpy_bank_vram.vdest+1
    lda.z vaddr+2
    sta.z vera_cpy_bank_vram.vdest+2
    lda.z vaddr+3
    sta.z vera_cpy_bank_vram.vdest+3
    // [771] vera_cpy_bank_vram::num#0 = cpy_graphics::size#10 -- vduz1=vwuz2 
    lda.z size
    sta.z vera_cpy_bank_vram.num
    lda.z size+1
    sta.z vera_cpy_bank_vram.num+1
    lda #0
    sta.z vera_cpy_bank_vram.num+2
    sta.z vera_cpy_bank_vram.num+3
    // [772] call vera_cpy_bank_vram 
    // [776] phi from cpy_graphics::@6 to vera_cpy_bank_vram [phi:cpy_graphics::@6->vera_cpy_bank_vram]
    // [776] phi vera_cpy_bank_vram::num#4 = vera_cpy_bank_vram::num#0 [phi:cpy_graphics::@6->vera_cpy_bank_vram#0] -- register_copy 
    // [776] phi vera_cpy_bank_vram::bsrc#2 = vera_cpy_bank_vram::bsrc#0 [phi:cpy_graphics::@6->vera_cpy_bank_vram#1] -- register_copy 
    // [776] phi vera_cpy_bank_vram::vdest#2 = vera_cpy_bank_vram::vdest#0 [phi:cpy_graphics::@6->vera_cpy_bank_vram#2] -- register_copy 
    jsr vera_cpy_bank_vram
    // cpy_graphics::@7
    // array[s] = vaddr
    // [773] cpy_graphics::$6 = cpy_graphics::s#2 << 2 -- vbuaa=vbuz1_rol_2 
    lda.z s
    asl
    asl
    // [774] cpy_graphics::array#12[cpy_graphics::$6] = cpy_graphics::vaddr#0 -- pduz1_derefidx_vbuaa=vduz2 
    tay
    lda.z vaddr
    sta (array),y
    iny
    lda.z vaddr+1
    sta (array),y
    iny
    lda.z vaddr+2
    sta (array),y
    iny
    lda.z vaddr+3
    sta (array),y
    // for(byte s=0;s<num;s++)
    // [775] cpy_graphics::s#1 = ++ cpy_graphics::s#2 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [751] phi from cpy_graphics::@7 to cpy_graphics::@1 [phi:cpy_graphics::@7->cpy_graphics::@1]
    // [751] phi cpy_graphics::s#2 = cpy_graphics::s#1 [phi:cpy_graphics::@7->cpy_graphics::@1#0] -- register_copy 
    jmp __b1
}
  // vera_cpy_bank_vram
// Copy block of banked internal memory (256 banks at A000-BFFF) to VERA VRAM.
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vdest: absolute address in VERA VRAM
// - bsrc: absolute address in the banked RAM of the CX16
// - num: dword of the number of bytes to copy
// Note: This function can switch RAM bank during copying to copy data from multiple RAM banks.
// vera_cpy_bank_vram(dword zp($54) bsrc, dword zp($c7) vdest, dword zp($33) num)
vera_cpy_bank_vram: {
    .label __0 = $bb
    .label __2 = $b0
    .label __4 = $b2
    .label __6 = $b0
    .label __7 = $b0
    .label __9 = $b4
    .label __11 = $b0
    .label __12 = $b0
    .label __13 = $b2
    .label __14 = $b2
    .label __16 = $b0
    .label __17 = $c5
    .label __24 = $b0
    .label __25 = $b2
    .label bank = $4c
    // select the bank
    .label addr = $c5
    .label i = $cd
    .label bsrc = $54
    .label vdest = $c7
    .label num = $33
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [777] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <vdest
    // [778] vera_cpy_bank_vram::$0 = < vera_cpy_bank_vram::vdest#2 -- vwuz1=_lo_vduz2 
    lda.z vdest
    sta.z __0
    lda.z vdest+1
    sta.z __0+1
    // <(<vdest)
    // [779] vera_cpy_bank_vram::$1 = < vera_cpy_bank_vram::$0 -- vbuaa=_lo_vwuz1 
    lda.z __0
    // *VERA_ADDRX_L = <(<vdest)
    // [780] *VERA_ADDRX_L = vera_cpy_bank_vram::$1 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // <vdest
    // [781] vera_cpy_bank_vram::$2 = < vera_cpy_bank_vram::vdest#2 -- vwuz1=_lo_vduz2 
    lda.z vdest
    sta.z __2
    lda.z vdest+1
    sta.z __2+1
    // >(<vdest)
    // [782] vera_cpy_bank_vram::$3 = > vera_cpy_bank_vram::$2 -- vbuaa=_hi_vwuz1 
    // *VERA_ADDRX_M = >(<vdest)
    // [783] *VERA_ADDRX_M = vera_cpy_bank_vram::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // >vdest
    // [784] vera_cpy_bank_vram::$4 = > vera_cpy_bank_vram::vdest#2 -- vwuz1=_hi_vduz2 
    lda.z vdest+2
    sta.z __4
    lda.z vdest+3
    sta.z __4+1
    // <(>vdest)
    // [785] vera_cpy_bank_vram::$5 = < vera_cpy_bank_vram::$4 -- vbuaa=_lo_vwuz1 
    lda.z __4
    // *VERA_ADDRX_H = <(>vdest)
    // [786] *VERA_ADDRX_H = vera_cpy_bank_vram::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_ADDRX_H |= VERA_INC_1
    // [787] *VERA_ADDRX_H = *VERA_ADDRX_H | VERA_INC_1 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora VERA_ADDRX_H
    sta VERA_ADDRX_H
    // >bsrc
    // [788] vera_cpy_bank_vram::$6 = > vera_cpy_bank_vram::bsrc#2 -- vwuz1=_hi_vduz2 
    lda.z bsrc+2
    sta.z __6
    lda.z bsrc+3
    sta.z __6+1
    // (>bsrc)<<8
    // [789] vera_cpy_bank_vram::$7 = vera_cpy_bank_vram::$6 << 8 -- vwuz1=vwuz1_rol_8 
    lda.z __7
    sta.z __7+1
    lda #0
    sta.z __7
    // <(>bsrc)<<8
    // [790] vera_cpy_bank_vram::$8 = < vera_cpy_bank_vram::$7 -- vbuyy=_lo_vwuz1 
    tay
    // <bsrc
    // [791] vera_cpy_bank_vram::$9 = < vera_cpy_bank_vram::bsrc#2 -- vwuz1=_lo_vduz2 
    lda.z bsrc
    sta.z __9
    lda.z bsrc+1
    sta.z __9+1
    // >(<bsrc)
    // [792] vera_cpy_bank_vram::$10 = > vera_cpy_bank_vram::$9 -- vbuxx=_hi_vwuz1 
    tax
    // ((word)<(>bsrc)<<8)|>(<bsrc)
    // [793] vera_cpy_bank_vram::$24 = (word)vera_cpy_bank_vram::$8 -- vwuz1=_word_vbuyy 
    tya
    sta.z __24
    sta.z __24+1
    // [794] vera_cpy_bank_vram::$11 = vera_cpy_bank_vram::$24 | vera_cpy_bank_vram::$10 -- vwuz1=vwuz1_bor_vbuxx 
    txa
    ora.z __11
    sta.z __11
    // (((word)<(>bsrc)<<8)|>(<bsrc))>>5
    // [795] vera_cpy_bank_vram::$12 = vera_cpy_bank_vram::$11 >> 5 -- vwuz1=vwuz1_ror_5 
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
    // [796] vera_cpy_bank_vram::$13 = > vera_cpy_bank_vram::bsrc#2 -- vwuz1=_hi_vduz2 
    lda.z bsrc+2
    sta.z __13
    lda.z bsrc+3
    sta.z __13+1
    // (>bsrc)<<3
    // [797] vera_cpy_bank_vram::$14 = vera_cpy_bank_vram::$13 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z __14
    rol.z __14+1
    asl.z __14
    rol.z __14+1
    asl.z __14
    rol.z __14+1
    // <(>bsrc)<<3
    // [798] vera_cpy_bank_vram::$15 = < vera_cpy_bank_vram::$14 -- vbuaa=_lo_vwuz1 
    lda.z __14
    // ((((word)<(>bsrc)<<8)|>(<bsrc))>>5)+((word)<(>bsrc)<<3)
    // [799] vera_cpy_bank_vram::$25 = (word)vera_cpy_bank_vram::$15 -- vwuz1=_word_vbuaa 
    sta.z __25
    tya
    sta.z __25+1
    // [800] vera_cpy_bank_vram::$16 = vera_cpy_bank_vram::$12 + vera_cpy_bank_vram::$25 -- vwuz1=vwuz1_plus_vwuz2 
    lda.z __16
    clc
    adc.z __25
    sta.z __16
    lda.z __16+1
    adc.z __25+1
    sta.z __16+1
    // bank = (byte)(((((word)<(>bsrc)<<8)|>(<bsrc))>>5)+((word)<(>bsrc)<<3))
    // [801] vera_cpy_bank_vram::bank#0 = (byte)vera_cpy_bank_vram::$16 -- vbuz1=_byte_vwuz2 
    lda.z __16
    sta.z bank
    // <bsrc
    // [802] vera_cpy_bank_vram::$17 = < vera_cpy_bank_vram::bsrc#2 -- vwuz1=_lo_vduz2 
    lda.z bsrc
    sta.z __17
    lda.z bsrc+1
    sta.z __17+1
    // (<bsrc)&0x1FFF
    // [803] vera_cpy_bank_vram::addr#0 = vera_cpy_bank_vram::$17 & $1fff -- vwuz1=vwuz1_band_vwuc1 
    lda.z addr
    and #<$1fff
    sta.z addr
    lda.z addr+1
    and #>$1fff
    sta.z addr+1
    // addr += 0xA000
    // [804] vera_cpy_bank_vram::addr#1 = (byte*)vera_cpy_bank_vram::addr#0 + $a000 -- pbuz1=pbuz1_plus_vwuc1 
    // strip off the top 3 bits, which are representing the bank of the word!
    clc
    lda.z addr
    adc #<$a000
    sta.z addr
    lda.z addr+1
    adc #>$a000
    sta.z addr+1
    // cx16_ram_bank(bank)
    // [805] cx16_ram_bank::bank#9 = vera_cpy_bank_vram::bank#0 -- vbuxx=vbuz1 
    ldx.z bank
    // [806] call cx16_ram_bank 
    // [1158] phi from vera_cpy_bank_vram to cx16_ram_bank [phi:vera_cpy_bank_vram->cx16_ram_bank]
    // [1158] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#9 [phi:vera_cpy_bank_vram->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [807] phi from vera_cpy_bank_vram to vera_cpy_bank_vram::@1 [phi:vera_cpy_bank_vram->vera_cpy_bank_vram::@1]
    // [807] phi vera_cpy_bank_vram::bank#2 = vera_cpy_bank_vram::bank#0 [phi:vera_cpy_bank_vram->vera_cpy_bank_vram::@1#0] -- register_copy 
    // [807] phi vera_cpy_bank_vram::addr#4 = vera_cpy_bank_vram::addr#1 [phi:vera_cpy_bank_vram->vera_cpy_bank_vram::@1#1] -- register_copy 
    // [807] phi vera_cpy_bank_vram::i#2 = 0 [phi:vera_cpy_bank_vram->vera_cpy_bank_vram::@1#2] -- vduz1=vduc1 
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
    // [808] if(vera_cpy_bank_vram::i#2<vera_cpy_bank_vram::num#4) goto vera_cpy_bank_vram::@2 -- vduz1_lt_vduz2_then_la1 
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
    // [809] return 
    rts
    // vera_cpy_bank_vram::@2
  __b2:
    // if(addr == 0xC000)
    // [810] if(vera_cpy_bank_vram::addr#4!=$c000) goto vera_cpy_bank_vram::@3 -- pbuz1_neq_vwuc1_then_la1 
    lda.z addr+1
    cmp #>$c000
    bne __b3
    lda.z addr
    cmp #<$c000
    bne __b3
    // vera_cpy_bank_vram::@4
    // bank++;
    // [811] vera_cpy_bank_vram::bank#1 = ++ vera_cpy_bank_vram::bank#2 -- vbuz1=_inc_vbuz1 
    inc.z bank
    // cx16_ram_bank(bank)
    // [812] cx16_ram_bank::bank#10 = vera_cpy_bank_vram::bank#1 -- vbuxx=vbuz1 
    ldx.z bank
    // [813] call cx16_ram_bank 
    // [1158] phi from vera_cpy_bank_vram::@4 to cx16_ram_bank [phi:vera_cpy_bank_vram::@4->cx16_ram_bank]
    // [1158] phi cx16_ram_bank::bank#11 = cx16_ram_bank::bank#10 [phi:vera_cpy_bank_vram::@4->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [814] phi from vera_cpy_bank_vram::@4 to vera_cpy_bank_vram::@3 [phi:vera_cpy_bank_vram::@4->vera_cpy_bank_vram::@3]
    // [814] phi vera_cpy_bank_vram::bank#5 = vera_cpy_bank_vram::bank#1 [phi:vera_cpy_bank_vram::@4->vera_cpy_bank_vram::@3#0] -- register_copy 
    // [814] phi vera_cpy_bank_vram::addr#5 = (byte*) 40960 [phi:vera_cpy_bank_vram::@4->vera_cpy_bank_vram::@3#1] -- pbuz1=pbuc1 
    lda #<$a000
    sta.z addr
    lda #>$a000
    sta.z addr+1
    // [814] phi from vera_cpy_bank_vram::@2 to vera_cpy_bank_vram::@3 [phi:vera_cpy_bank_vram::@2->vera_cpy_bank_vram::@3]
    // [814] phi vera_cpy_bank_vram::bank#5 = vera_cpy_bank_vram::bank#2 [phi:vera_cpy_bank_vram::@2->vera_cpy_bank_vram::@3#0] -- register_copy 
    // [814] phi vera_cpy_bank_vram::addr#5 = vera_cpy_bank_vram::addr#4 [phi:vera_cpy_bank_vram::@2->vera_cpy_bank_vram::@3#1] -- register_copy 
    // vera_cpy_bank_vram::@3
  __b3:
    // *VERA_DATA0 = *addr
    // [815] *VERA_DATA0 = *vera_cpy_bank_vram::addr#5 -- _deref_pbuc1=_deref_pbuz1 
    ldy #0
    lda (addr),y
    sta VERA_DATA0
    // addr++;
    // [816] vera_cpy_bank_vram::addr#2 = ++ vera_cpy_bank_vram::addr#5 -- pbuz1=_inc_pbuz1 
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    // for(dword i=0; i<num; i++)
    // [817] vera_cpy_bank_vram::i#1 = ++ vera_cpy_bank_vram::i#2 -- vduz1=_inc_vduz1 
    inc.z i
    bne !+
    inc.z i+1
    bne !+
    inc.z i+2
    bne !+
    inc.z i+3
  !:
    // [807] phi from vera_cpy_bank_vram::@3 to vera_cpy_bank_vram::@1 [phi:vera_cpy_bank_vram::@3->vera_cpy_bank_vram::@1]
    // [807] phi vera_cpy_bank_vram::bank#2 = vera_cpy_bank_vram::bank#5 [phi:vera_cpy_bank_vram::@3->vera_cpy_bank_vram::@1#0] -- register_copy 
    // [807] phi vera_cpy_bank_vram::addr#4 = vera_cpy_bank_vram::addr#2 [phi:vera_cpy_bank_vram::@3->vera_cpy_bank_vram::@1#1] -- register_copy 
    // [807] phi vera_cpy_bank_vram::i#2 = vera_cpy_bank_vram::i#1 [phi:vera_cpy_bank_vram::@3->vera_cpy_bank_vram::@1#2] -- register_copy 
    jmp __b1
}
  // tile_background
tile_background: {
    .label __3 = $b0
    .label c = $c4
    .label r = $b8
    // [819] phi from tile_background to tile_background::@1 [phi:tile_background->tile_background::@1]
    // [819] phi rem16u#19 = 0 [phi:tile_background->tile_background::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z rem16u
    sta.z rem16u+1
    // [819] phi rand_state#18 = 1 [phi:tile_background->tile_background::@1#1] -- vwuz1=vwuc1 
    lda #<1
    sta.z rand_state
    lda #>1
    sta.z rand_state+1
    // [819] phi tile_background::r#2 = 0 [phi:tile_background->tile_background::@1#2] -- vbuz1=vbuc1 
    sta.z r
    // tile_background::@1
  __b1:
    // for(byte r=0;r<6;r+=1)
    // [820] if(tile_background::r#2<6) goto tile_background::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z r
    cmp #6
    bcc __b4
    // tile_background::@return
    // }
    // [821] return 
    rts
    // [822] phi from tile_background::@1 to tile_background::@2 [phi:tile_background::@1->tile_background::@2]
  __b4:
    // [822] phi rem16u#27 = rem16u#19 [phi:tile_background::@1->tile_background::@2#0] -- register_copy 
    // [822] phi rand_state#24 = rand_state#18 [phi:tile_background::@1->tile_background::@2#1] -- register_copy 
    // [822] phi tile_background::c#2 = 0 [phi:tile_background::@1->tile_background::@2#2] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // tile_background::@2
  __b2:
    // for(byte c=0;c<5;c+=1)
    // [823] if(tile_background::c#2<5) goto tile_background::@3 -- vbuz1_lt_vbuc1_then_la1 
    lda.z c
    cmp #5
    bcc __b3
    // tile_background::@4
    // r+=1
    // [824] tile_background::r#1 = tile_background::r#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z r
    // [819] phi from tile_background::@4 to tile_background::@1 [phi:tile_background::@4->tile_background::@1]
    // [819] phi rem16u#19 = rem16u#27 [phi:tile_background::@4->tile_background::@1#0] -- register_copy 
    // [819] phi rand_state#18 = rand_state#24 [phi:tile_background::@4->tile_background::@1#1] -- register_copy 
    // [819] phi tile_background::r#2 = tile_background::r#1 [phi:tile_background::@4->tile_background::@1#2] -- register_copy 
    jmp __b1
    // [825] phi from tile_background::@2 to tile_background::@3 [phi:tile_background::@2->tile_background::@3]
    // tile_background::@3
  __b3:
    // rand()
    // [826] call rand 
    // [321] phi from tile_background::@3 to rand [phi:tile_background::@3->rand]
    // [321] phi rand_state#13 = rand_state#24 [phi:tile_background::@3->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [827] rand::return#3 = rand::return#0
    // tile_background::@5
    // modr16u(rand(),3,0)
    // [828] modr16u::dividend#1 = rand::return#3
    // [829] call modr16u 
    // [330] phi from tile_background::@5 to modr16u [phi:tile_background::@5->modr16u]
    // [330] phi modr16u::dividend#2 = modr16u::dividend#1 [phi:tile_background::@5->modr16u#0] -- register_copy 
    jsr modr16u
    // modr16u(rand(),3,0)
    // [830] modr16u::return#3 = modr16u::return#0
    // tile_background::@6
    // [831] tile_background::$3 = modr16u::return#3 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z __3
    lda.z modr16u.return+1
    sta.z __3+1
    // rnd = (byte)modr16u(rand(),3,0)
    // [832] tile_background::rnd#0 = (byte)tile_background::$3 -- vbuaa=_byte_vwuz1 
    lda.z __3
    // vera_tile_element( 0, c, r, 3, TileDB[rnd])
    // [833] tile_background::$5 = tile_background::rnd#0 << 1 -- vbuxx=vbuaa_rol_1 
    asl
    tax
    // [834] vera_tile_element::x#2 = tile_background::c#2 -- vbuz1=vbuz2 
    lda.z c
    sta.z vera_tile_element.x
    // [835] vera_tile_element::y#2 = tile_background::r#2 -- vbuz1=vbuz2 
    lda.z r
    sta.z vera_tile_element.y
    // [836] vera_tile_element::Tile#1 = TileDB[tile_background::$5] -- pssz1=qssc1_derefidx_vbuxx 
    lda TileDB,x
    sta.z vera_tile_element.Tile
    lda TileDB+1,x
    sta.z vera_tile_element.Tile+1
    // [837] call vera_tile_element 
    // [335] phi from tile_background::@6 to vera_tile_element [phi:tile_background::@6->vera_tile_element]
    // [335] phi vera_tile_element::y#3 = vera_tile_element::y#2 [phi:tile_background::@6->vera_tile_element#0] -- register_copy 
    // [335] phi vera_tile_element::x#3 = vera_tile_element::x#2 [phi:tile_background::@6->vera_tile_element#1] -- register_copy 
    // [335] phi vera_tile_element::Tile#2 = vera_tile_element::Tile#1 [phi:tile_background::@6->vera_tile_element#2] -- register_copy 
    jsr vera_tile_element
    // tile_background::@7
    // c+=1
    // [838] tile_background::c#1 = tile_background::c#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z c
    // [822] phi from tile_background::@7 to tile_background::@2 [phi:tile_background::@7->tile_background::@2]
    // [822] phi rem16u#27 = divr16u::rem#10 [phi:tile_background::@7->tile_background::@2#0] -- register_copy 
    // [822] phi rand_state#24 = rand_state#14 [phi:tile_background::@7->tile_background::@2#1] -- register_copy 
    // [822] phi tile_background::c#2 = tile_background::c#1 [phi:tile_background::@7->tile_background::@2#2] -- register_copy 
    jmp __b2
}
  // create_sprites_player
create_sprites_player: {
    .const vera_sprite_palette_offset1_palette_offset = 1
    .label __4 = $b2
    .label __7 = $b6
    .label __17 = $b2
    .label __18 = $b6
    .label vera_sprite_4bpp1___4 = $b2
    .label vera_sprite_4bpp1___7 = $b2
    .label vera_sprite_address1___0 = $b0
    .label vera_sprite_address1___4 = $b4
    .label vera_sprite_address1___5 = $b4
    .label vera_sprite_address1___7 = $b0
    .label vera_sprite_address1___9 = $b8
    .label vera_sprite_address1___10 = $b2
    .label vera_sprite_address1___14 = $b0
    .label vera_sprite_xy1___4 = $b4
    .label vera_sprite_xy1___10 = $b4
    .label vera_sprite_height_321___4 = $b0
    .label vera_sprite_height_321___8 = $b0
    .label vera_sprite_width_321___4 = $cb
    .label vera_sprite_width_321___8 = $cb
    .label vera_sprite_zdepth_in_front1___4 = $b2
    .label vera_sprite_zdepth_in_front1___8 = $b2
    .label vera_sprite_VFlip_off1___4 = $b4
    .label vera_sprite_VFlip_off1___7 = $b4
    .label vera_sprite_HFlip_off1___4 = $b9
    .label vera_sprite_HFlip_off1___7 = $b9
    .label vera_sprite_palette_offset1___4 = $bb
    .label vera_sprite_palette_offset1___8 = $bb
    .label vera_sprite_4bpp1_sprite_offset = $b2
    .label vera_sprite_address1_address = $c7
    .label vera_sprite_address1_sprite_offset = $b0
    .label vera_sprite_xy1_x = $b2
    .label vera_sprite_xy1_y = $b6
    .label vera_sprite_xy1_sprite_offset = $b4
    .label vera_sprite_height_321_sprite_offset = $b0
    .label vera_sprite_width_321_sprite_offset = $cb
    .label vera_sprite_zdepth_in_front1_sprite_offset = $b2
    .label vera_sprite_VFlip_off1_sprite_offset = $b4
    .label vera_sprite_HFlip_off1_sprite_offset = $b9
    .label vera_sprite_palette_offset1_sprite_offset = $bb
    // [840] phi from create_sprites_player to create_sprites_player::@1 [phi:create_sprites_player->create_sprites_player::@1]
    // [840] phi create_sprites_player::s#10 = 0 [phi:create_sprites_player->create_sprites_player::@1#0] -- vbuxx=vbuc1 
    ldx #0
  // Copy sprite palette to VRAM
  // Copy 8* sprite attributes to VRAM    
    // create_sprites_player::@1
  __b1:
    // for(byte s=0;s<NUM_PLAYER;s++)
    // [841] if(create_sprites_player::s#10<NUM_PLAYER) goto create_sprites_player::vera_sprite_4bpp1 -- vbuxx_lt_vbuc1_then_la1 
    cpx #NUM_PLAYER
    bcc vera_sprite_4bpp1
    // create_sprites_player::@return
    // }
    // [842] return 
    rts
    // create_sprites_player::vera_sprite_4bpp1
  vera_sprite_4bpp1:
    // (word)sprite << 3
    // [843] create_sprites_player::vera_sprite_4bpp1_$7 = (word)create_sprites_player::s#10 -- vwuz1=_word_vbuxx 
    txa
    sta.z vera_sprite_4bpp1___7
    lda #0
    sta.z vera_sprite_4bpp1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [844] create_sprites_player::vera_sprite_4bpp1_sprite_offset#0 = create_sprites_player::vera_sprite_4bpp1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_4bpp1_sprite_offset
    rol.z vera_sprite_4bpp1_sprite_offset+1
    asl.z vera_sprite_4bpp1_sprite_offset
    rol.z vera_sprite_4bpp1_sprite_offset+1
    asl.z vera_sprite_4bpp1_sprite_offset
    rol.z vera_sprite_4bpp1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [845] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+1
    // [846] create_sprites_player::vera_sprite_4bpp1_$4 = create_sprites_player::vera_sprite_4bpp1_sprite_offset#0 + <VERA_SPRITE_ATTR+1 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_4bpp1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+1
    sta.z vera_sprite_4bpp1___4
    lda.z vera_sprite_4bpp1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+1
    sta.z vera_sprite_4bpp1___4+1
    // <sprite_offset+1
    // [847] create_sprites_player::vera_sprite_4bpp1_$3 = < create_sprites_player::vera_sprite_4bpp1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_4bpp1___4
    // *VERA_ADDRX_L = <sprite_offset+1
    // [848] *VERA_ADDRX_L = create_sprites_player::vera_sprite_4bpp1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+1
    // [849] create_sprites_player::vera_sprite_4bpp1_$5 = > create_sprites_player::vera_sprite_4bpp1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_4bpp1___4+1
    // *VERA_ADDRX_M = >sprite_offset+1
    // [850] *VERA_ADDRX_M = create_sprites_player::vera_sprite_4bpp1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [851] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~>VERA_SPRITE_8BPP
    // [852] create_sprites_player::vera_sprite_4bpp1_$6 = *VERA_DATA0 & ~>VERA_SPRITE_8BPP -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #(>VERA_SPRITE_8BPP)^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~>VERA_SPRITE_8BPP
    // [853] *VERA_DATA0 = create_sprites_player::vera_sprite_4bpp1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_player::@2
    // vera_sprite_address(s, PlayerSprites[s])
    // [854] create_sprites_player::$16 = create_sprites_player::s#10 << 2 -- vbuaa=vbuxx_rol_2 
    txa
    asl
    asl
    // [855] create_sprites_player::vera_sprite_address1_address#0 = PlayerSprites[create_sprites_player::$16] -- vduz1=pduc1_derefidx_vbuaa 
    tay
    lda PlayerSprites,y
    sta.z vera_sprite_address1_address
    lda PlayerSprites+1,y
    sta.z vera_sprite_address1_address+1
    lda PlayerSprites+2,y
    sta.z vera_sprite_address1_address+2
    lda PlayerSprites+3,y
    sta.z vera_sprite_address1_address+3
    // create_sprites_player::vera_sprite_address1
    // (word)sprite << 3
    // [856] create_sprites_player::vera_sprite_address1_$14 = (word)create_sprites_player::s#10 -- vwuz1=_word_vbuxx 
    txa
    sta.z vera_sprite_address1___14
    lda #0
    sta.z vera_sprite_address1___14+1
    // [857] create_sprites_player::vera_sprite_address1_$0 = create_sprites_player::vera_sprite_address1_$14 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [858] create_sprites_player::vera_sprite_address1_sprite_offset#0 = <VERA_SPRITE_ATTR + create_sprites_player::vera_sprite_address1_$0 -- vwuz1=vwuc1_plus_vwuz1 
    clc
    lda.z vera_sprite_address1_sprite_offset
    adc #<VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset
    lda.z vera_sprite_address1_sprite_offset+1
    adc #>VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [859] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <sprite_offset
    // [860] create_sprites_player::vera_sprite_address1_$2 = < create_sprites_player::vera_sprite_address1_sprite_offset#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1_sprite_offset
    // *VERA_ADDRX_L = <sprite_offset
    // [861] *VERA_ADDRX_L = create_sprites_player::vera_sprite_address1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset
    // [862] create_sprites_player::vera_sprite_address1_$3 = > create_sprites_player::vera_sprite_address1_sprite_offset#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_address1_sprite_offset+1
    // *VERA_ADDRX_M = >sprite_offset
    // [863] *VERA_ADDRX_M = create_sprites_player::vera_sprite_address1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [864] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <address
    // [865] create_sprites_player::vera_sprite_address1_$4 = < create_sprites_player::vera_sprite_address1_address#0 -- vwuz1=_lo_vduz2 
    lda.z vera_sprite_address1_address
    sta.z vera_sprite_address1___4
    lda.z vera_sprite_address1_address+1
    sta.z vera_sprite_address1___4+1
    // (<address)>>5
    // [866] create_sprites_player::vera_sprite_address1_$5 = create_sprites_player::vera_sprite_address1_$4 >> 5 -- vwuz1=vwuz1_ror_5 
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
    // [867] create_sprites_player::vera_sprite_address1_$6 = < create_sprites_player::vera_sprite_address1_$5 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1___5
    // *VERA_DATA0 = <((<address)>>5)
    // [868] *VERA_DATA0 = create_sprites_player::vera_sprite_address1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // <address
    // [869] create_sprites_player::vera_sprite_address1_$7 = < create_sprites_player::vera_sprite_address1_address#0 -- vwuz1=_lo_vduz2 
    lda.z vera_sprite_address1_address
    sta.z vera_sprite_address1___7
    lda.z vera_sprite_address1_address+1
    sta.z vera_sprite_address1___7+1
    // >(<address)
    // [870] create_sprites_player::vera_sprite_address1_$8 = > create_sprites_player::vera_sprite_address1_$7 -- vbuaa=_hi_vwuz1 
    // (>(<address))>>5
    // [871] create_sprites_player::vera_sprite_address1_$9 = create_sprites_player::vera_sprite_address1_$8 >> 5 -- vbuz1=vbuaa_ror_5 
    lsr
    lsr
    lsr
    lsr
    lsr
    sta.z vera_sprite_address1___9
    // >address
    // [872] create_sprites_player::vera_sprite_address1_$10 = > create_sprites_player::vera_sprite_address1_address#0 -- vwuz1=_hi_vduz2 
    lda.z vera_sprite_address1_address+2
    sta.z vera_sprite_address1___10
    lda.z vera_sprite_address1_address+3
    sta.z vera_sprite_address1___10+1
    // <(>address)
    // [873] create_sprites_player::vera_sprite_address1_$11 = < create_sprites_player::vera_sprite_address1_$10 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1___10
    // (<(>address))<<3
    // [874] create_sprites_player::vera_sprite_address1_$12 = create_sprites_player::vera_sprite_address1_$11 << 3 -- vbuaa=vbuaa_rol_3 
    asl
    asl
    asl
    // ((>(<address))>>5)|((<(>address))<<3)
    // [875] create_sprites_player::vera_sprite_address1_$13 = create_sprites_player::vera_sprite_address1_$9 | create_sprites_player::vera_sprite_address1_$12 -- vbuaa=vbuz1_bor_vbuaa 
    ora.z vera_sprite_address1___9
    // *VERA_DATA0 = ((>(<address))>>5)|((<(>address))<<3)
    // [876] *VERA_DATA0 = create_sprites_player::vera_sprite_address1_$13 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_player::@3
    // s&03
    // [877] create_sprites_player::$3 = create_sprites_player::s#10 & 3 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #3
    // (word)(s&03)<<6
    // [878] create_sprites_player::$17 = (word)create_sprites_player::$3 -- vwuz1=_word_vbuaa 
    sta.z __17
    lda #0
    sta.z __17+1
    // [879] create_sprites_player::$4 = create_sprites_player::$17 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z __4+1
    lsr
    sta.z $ff
    lda.z __4
    ror
    sta.z __4+1
    lda #0
    ror
    sta.z __4
    lsr.z $ff
    ror.z __4+1
    ror.z __4
    // vera_sprite_xy(s, 40+((word)(s&03)<<6), 100+((word)(s>>2)<<6))
    // [880] create_sprites_player::vera_sprite_xy1_x#0 = $28 + create_sprites_player::$4 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$28
    clc
    adc.z vera_sprite_xy1_x
    sta.z vera_sprite_xy1_x
    bcc !+
    inc.z vera_sprite_xy1_x+1
  !:
    // s>>2
    // [881] create_sprites_player::$6 = create_sprites_player::s#10 >> 2 -- vbuaa=vbuxx_ror_2 
    txa
    lsr
    lsr
    // (word)(s>>2)<<6
    // [882] create_sprites_player::$18 = (word)create_sprites_player::$6 -- vwuz1=_word_vbuaa 
    sta.z __18
    lda #0
    sta.z __18+1
    // [883] create_sprites_player::$7 = create_sprites_player::$18 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z __7+1
    lsr
    sta.z $ff
    lda.z __7
    ror
    sta.z __7+1
    lda #0
    ror
    sta.z __7
    lsr.z $ff
    ror.z __7+1
    ror.z __7
    // vera_sprite_xy(s, 40+((word)(s&03)<<6), 100+((word)(s>>2)<<6))
    // [884] create_sprites_player::vera_sprite_xy1_y#0 = $64 + create_sprites_player::$7 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$64
    clc
    adc.z vera_sprite_xy1_y
    sta.z vera_sprite_xy1_y
    bcc !+
    inc.z vera_sprite_xy1_y+1
  !:
    // create_sprites_player::vera_sprite_xy1
    // (word)sprite << 3
    // [885] create_sprites_player::vera_sprite_xy1_$10 = (word)create_sprites_player::s#10 -- vwuz1=_word_vbuxx 
    txa
    sta.z vera_sprite_xy1___10
    lda #0
    sta.z vera_sprite_xy1___10+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [886] create_sprites_player::vera_sprite_xy1_sprite_offset#0 = create_sprites_player::vera_sprite_xy1_$10 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [887] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+2
    // [888] create_sprites_player::vera_sprite_xy1_$4 = create_sprites_player::vera_sprite_xy1_sprite_offset#0 + <VERA_SPRITE_ATTR+2 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_xy1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4
    lda.z vera_sprite_xy1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4+1
    // <sprite_offset+2
    // [889] create_sprites_player::vera_sprite_xy1_$3 = < create_sprites_player::vera_sprite_xy1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1___4
    // *VERA_ADDRX_L = <sprite_offset+2
    // [890] *VERA_ADDRX_L = create_sprites_player::vera_sprite_xy1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+2
    // [891] create_sprites_player::vera_sprite_xy1_$5 = > create_sprites_player::vera_sprite_xy1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1___4+1
    // *VERA_ADDRX_M = >sprite_offset+2
    // [892] *VERA_ADDRX_M = create_sprites_player::vera_sprite_xy1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [893] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <x
    // [894] create_sprites_player::vera_sprite_xy1_$6 = < create_sprites_player::vera_sprite_xy1_x#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1_x
    // *VERA_DATA0 = <x
    // [895] *VERA_DATA0 = create_sprites_player::vera_sprite_xy1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // >x
    // [896] create_sprites_player::vera_sprite_xy1_$7 = > create_sprites_player::vera_sprite_xy1_x#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1_x+1
    // *VERA_DATA0 = >x
    // [897] *VERA_DATA0 = create_sprites_player::vera_sprite_xy1_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // <y
    // [898] create_sprites_player::vera_sprite_xy1_$8 = < create_sprites_player::vera_sprite_xy1_y#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1_y
    // *VERA_DATA0 = <y
    // [899] *VERA_DATA0 = create_sprites_player::vera_sprite_xy1_$8 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // >y
    // [900] create_sprites_player::vera_sprite_xy1_$9 = > create_sprites_player::vera_sprite_xy1_y#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1_y+1
    // *VERA_DATA0 = >y
    // [901] *VERA_DATA0 = create_sprites_player::vera_sprite_xy1_$9 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_player::vera_sprite_height_321
    // (word)sprite << 3
    // [902] create_sprites_player::vera_sprite_height_321_$8 = (word)create_sprites_player::s#10 -- vwuz1=_word_vbuxx 
    txa
    sta.z vera_sprite_height_321___8
    lda #0
    sta.z vera_sprite_height_321___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [903] create_sprites_player::vera_sprite_height_321_sprite_offset#0 = create_sprites_player::vera_sprite_height_321_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_height_321_sprite_offset
    rol.z vera_sprite_height_321_sprite_offset+1
    asl.z vera_sprite_height_321_sprite_offset
    rol.z vera_sprite_height_321_sprite_offset+1
    asl.z vera_sprite_height_321_sprite_offset
    rol.z vera_sprite_height_321_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [904] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [905] create_sprites_player::vera_sprite_height_321_$4 = create_sprites_player::vera_sprite_height_321_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_height_321___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height_321___4
    lda.z vera_sprite_height_321___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height_321___4+1
    // <sprite_offset+7
    // [906] create_sprites_player::vera_sprite_height_321_$3 = < create_sprites_player::vera_sprite_height_321_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_height_321___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [907] *VERA_ADDRX_L = create_sprites_player::vera_sprite_height_321_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [908] create_sprites_player::vera_sprite_height_321_$5 = > create_sprites_player::vera_sprite_height_321_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_height_321___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [909] *VERA_ADDRX_M = create_sprites_player::vera_sprite_height_321_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [910] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [911] create_sprites_player::vera_sprite_height_321_$6 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HEIGHT_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_32
    // [912] create_sprites_player::vera_sprite_height_321_$7 = create_sprites_player::vera_sprite_height_321_$6 | VERA_SPRITE_HEIGHT_32 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_HEIGHT_32
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_32
    // [913] *VERA_DATA0 = create_sprites_player::vera_sprite_height_321_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_player::vera_sprite_width_321
    // (word)sprite << 3
    // [914] create_sprites_player::vera_sprite_width_321_$8 = (word)create_sprites_player::s#10 -- vwuz1=_word_vbuxx 
    txa
    sta.z vera_sprite_width_321___8
    lda #0
    sta.z vera_sprite_width_321___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [915] create_sprites_player::vera_sprite_width_321_sprite_offset#0 = create_sprites_player::vera_sprite_width_321_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_width_321_sprite_offset
    rol.z vera_sprite_width_321_sprite_offset+1
    asl.z vera_sprite_width_321_sprite_offset
    rol.z vera_sprite_width_321_sprite_offset+1
    asl.z vera_sprite_width_321_sprite_offset
    rol.z vera_sprite_width_321_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [916] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [917] create_sprites_player::vera_sprite_width_321_$4 = create_sprites_player::vera_sprite_width_321_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_width_321___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_321___4
    lda.z vera_sprite_width_321___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_321___4+1
    // <sprite_offset+7
    // [918] create_sprites_player::vera_sprite_width_321_$3 = < create_sprites_player::vera_sprite_width_321_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_width_321___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [919] *VERA_ADDRX_L = create_sprites_player::vera_sprite_width_321_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [920] create_sprites_player::vera_sprite_width_321_$5 = > create_sprites_player::vera_sprite_width_321_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_width_321___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [921] *VERA_ADDRX_M = create_sprites_player::vera_sprite_width_321_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [922] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [923] create_sprites_player::vera_sprite_width_321_$6 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_WIDTH_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_32
    // [924] create_sprites_player::vera_sprite_width_321_$7 = create_sprites_player::vera_sprite_width_321_$6 | VERA_SPRITE_WIDTH_32 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_WIDTH_32
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_32
    // [925] *VERA_DATA0 = create_sprites_player::vera_sprite_width_321_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_player::vera_sprite_zdepth_in_front1
    // (word)sprite << 3
    // [926] create_sprites_player::vera_sprite_zdepth_in_front1_$8 = (word)create_sprites_player::s#10 -- vwuz1=_word_vbuxx 
    txa
    sta.z vera_sprite_zdepth_in_front1___8
    lda #0
    sta.z vera_sprite_zdepth_in_front1___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [927] create_sprites_player::vera_sprite_zdepth_in_front1_sprite_offset#0 = create_sprites_player::vera_sprite_zdepth_in_front1_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_zdepth_in_front1_sprite_offset
    rol.z vera_sprite_zdepth_in_front1_sprite_offset+1
    asl.z vera_sprite_zdepth_in_front1_sprite_offset
    rol.z vera_sprite_zdepth_in_front1_sprite_offset+1
    asl.z vera_sprite_zdepth_in_front1_sprite_offset
    rol.z vera_sprite_zdepth_in_front1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [928] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [929] create_sprites_player::vera_sprite_zdepth_in_front1_$4 = create_sprites_player::vera_sprite_zdepth_in_front1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_zdepth_in_front1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_in_front1___4
    lda.z vera_sprite_zdepth_in_front1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_in_front1___4+1
    // <sprite_offset+6
    // [930] create_sprites_player::vera_sprite_zdepth_in_front1_$3 = < create_sprites_player::vera_sprite_zdepth_in_front1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_zdepth_in_front1___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [931] *VERA_ADDRX_L = create_sprites_player::vera_sprite_zdepth_in_front1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [932] create_sprites_player::vera_sprite_zdepth_in_front1_$5 = > create_sprites_player::vera_sprite_zdepth_in_front1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_zdepth_in_front1___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [933] *VERA_ADDRX_M = create_sprites_player::vera_sprite_zdepth_in_front1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [934] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [935] create_sprites_player::vera_sprite_zdepth_in_front1_$6 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_ZDEPTH_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_IN_FRONT
    // [936] create_sprites_player::vera_sprite_zdepth_in_front1_$7 = create_sprites_player::vera_sprite_zdepth_in_front1_$6 | VERA_SPRITE_ZDEPTH_IN_FRONT -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_ZDEPTH_IN_FRONT
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_IN_FRONT
    // [937] *VERA_DATA0 = create_sprites_player::vera_sprite_zdepth_in_front1_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_player::vera_sprite_VFlip_off1
    // (word)sprite << 3
    // [938] create_sprites_player::vera_sprite_VFlip_off1_$7 = (word)create_sprites_player::s#10 -- vwuz1=_word_vbuxx 
    txa
    sta.z vera_sprite_VFlip_off1___7
    lda #0
    sta.z vera_sprite_VFlip_off1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [939] create_sprites_player::vera_sprite_VFlip_off1_sprite_offset#0 = create_sprites_player::vera_sprite_VFlip_off1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_VFlip_off1_sprite_offset
    rol.z vera_sprite_VFlip_off1_sprite_offset+1
    asl.z vera_sprite_VFlip_off1_sprite_offset
    rol.z vera_sprite_VFlip_off1_sprite_offset+1
    asl.z vera_sprite_VFlip_off1_sprite_offset
    rol.z vera_sprite_VFlip_off1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [940] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [941] create_sprites_player::vera_sprite_VFlip_off1_$4 = create_sprites_player::vera_sprite_VFlip_off1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_VFlip_off1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_VFlip_off1___4
    lda.z vera_sprite_VFlip_off1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_VFlip_off1___4+1
    // <sprite_offset+6
    // [942] create_sprites_player::vera_sprite_VFlip_off1_$3 = < create_sprites_player::vera_sprite_VFlip_off1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_VFlip_off1___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [943] *VERA_ADDRX_L = create_sprites_player::vera_sprite_VFlip_off1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [944] create_sprites_player::vera_sprite_VFlip_off1_$5 = > create_sprites_player::vera_sprite_VFlip_off1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_VFlip_off1___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [945] *VERA_ADDRX_M = create_sprites_player::vera_sprite_VFlip_off1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [946] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_VFLIP
    // [947] create_sprites_player::vera_sprite_VFlip_off1_$6 = *VERA_DATA0 & ~VERA_SPRITE_VFLIP -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_VFLIP^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_VFLIP
    // [948] *VERA_DATA0 = create_sprites_player::vera_sprite_VFlip_off1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_player::vera_sprite_HFlip_off1
    // (word)sprite << 3
    // [949] create_sprites_player::vera_sprite_HFlip_off1_$7 = (word)create_sprites_player::s#10 -- vwuz1=_word_vbuxx 
    txa
    sta.z vera_sprite_HFlip_off1___7
    lda #0
    sta.z vera_sprite_HFlip_off1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [950] create_sprites_player::vera_sprite_HFlip_off1_sprite_offset#0 = create_sprites_player::vera_sprite_HFlip_off1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_HFlip_off1_sprite_offset
    rol.z vera_sprite_HFlip_off1_sprite_offset+1
    asl.z vera_sprite_HFlip_off1_sprite_offset
    rol.z vera_sprite_HFlip_off1_sprite_offset+1
    asl.z vera_sprite_HFlip_off1_sprite_offset
    rol.z vera_sprite_HFlip_off1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [951] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [952] create_sprites_player::vera_sprite_HFlip_off1_$4 = create_sprites_player::vera_sprite_HFlip_off1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_HFlip_off1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_HFlip_off1___4
    lda.z vera_sprite_HFlip_off1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_HFlip_off1___4+1
    // <sprite_offset+6
    // [953] create_sprites_player::vera_sprite_HFlip_off1_$3 = < create_sprites_player::vera_sprite_HFlip_off1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_HFlip_off1___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [954] *VERA_ADDRX_L = create_sprites_player::vera_sprite_HFlip_off1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [955] create_sprites_player::vera_sprite_HFlip_off1_$5 = > create_sprites_player::vera_sprite_HFlip_off1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_HFlip_off1___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [956] *VERA_ADDRX_M = create_sprites_player::vera_sprite_HFlip_off1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [957] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HFLIP
    // [958] create_sprites_player::vera_sprite_HFlip_off1_$6 = *VERA_DATA0 & ~VERA_SPRITE_HFLIP -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HFLIP^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HFLIP
    // [959] *VERA_DATA0 = create_sprites_player::vera_sprite_HFlip_off1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_player::vera_sprite_palette_offset1
    // (word)sprite << 3
    // [960] create_sprites_player::vera_sprite_palette_offset1_$8 = (word)create_sprites_player::s#10 -- vwuz1=_word_vbuxx 
    txa
    sta.z vera_sprite_palette_offset1___8
    lda #0
    sta.z vera_sprite_palette_offset1___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [961] create_sprites_player::vera_sprite_palette_offset1_sprite_offset#0 = create_sprites_player::vera_sprite_palette_offset1_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_palette_offset1_sprite_offset
    rol.z vera_sprite_palette_offset1_sprite_offset+1
    asl.z vera_sprite_palette_offset1_sprite_offset
    rol.z vera_sprite_palette_offset1_sprite_offset+1
    asl.z vera_sprite_palette_offset1_sprite_offset
    rol.z vera_sprite_palette_offset1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [962] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [963] create_sprites_player::vera_sprite_palette_offset1_$4 = create_sprites_player::vera_sprite_palette_offset1_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_palette_offset1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_palette_offset1___4
    lda.z vera_sprite_palette_offset1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_palette_offset1___4+1
    // <sprite_offset+7
    // [964] create_sprites_player::vera_sprite_palette_offset1_$3 = < create_sprites_player::vera_sprite_palette_offset1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_palette_offset1___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [965] *VERA_ADDRX_L = create_sprites_player::vera_sprite_palette_offset1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [966] create_sprites_player::vera_sprite_palette_offset1_$5 = > create_sprites_player::vera_sprite_palette_offset1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_palette_offset1___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [967] *VERA_ADDRX_M = create_sprites_player::vera_sprite_palette_offset1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [968] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK
    // [969] create_sprites_player::vera_sprite_palette_offset1_$6 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_PALETTE_OFFSET_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK | palette_offset
    // [970] create_sprites_player::vera_sprite_palette_offset1_$7 = create_sprites_player::vera_sprite_palette_offset1_$6 | create_sprites_player::vera_sprite_palette_offset1_palette_offset#0 -- vbuaa=vbuaa_bor_vbuc1 
    ora #vera_sprite_palette_offset1_palette_offset
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK | palette_offset
    // [971] *VERA_DATA0 = create_sprites_player::vera_sprite_palette_offset1_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_player::@4
    // for(byte s=0;s<NUM_PLAYER;s++)
    // [972] create_sprites_player::s#1 = ++ create_sprites_player::s#10 -- vbuxx=_inc_vbuxx 
    inx
    // [840] phi from create_sprites_player::@4 to create_sprites_player::@1 [phi:create_sprites_player::@4->create_sprites_player::@1]
    // [840] phi create_sprites_player::s#10 = create_sprites_player::s#1 [phi:create_sprites_player::@4->create_sprites_player::@1#0] -- register_copy 
    jmp __b1
}
  // create_sprites_enemy2
create_sprites_enemy2: {
    .const base = $c
    .const vera_sprite_palette_offset1_palette_offset = 2
    .label __7 = $b4
    .label __10 = $b9
    .label __26 = $b4
    .label __27 = $b9
    .label vera_sprite_4bpp1___4 = $b6
    .label vera_sprite_4bpp1___7 = $b6
    .label vera_sprite_address1___0 = $b4
    .label vera_sprite_address1___4 = $b0
    .label vera_sprite_address1___5 = $b0
    .label vera_sprite_address1___7 = $cb
    .label vera_sprite_address1___9 = $b8
    .label vera_sprite_address1___10 = $b2
    .label vera_sprite_address1___14 = $b4
    .label vera_sprite_xy1___4 = $bb
    .label vera_sprite_xy1___10 = $bb
    .label vera_sprite_height_321___4 = $b2
    .label vera_sprite_height_321___8 = $b2
    .label vera_sprite_width_321___4 = $b2
    .label vera_sprite_width_321___8 = $b2
    .label vera_sprite_zdepth_in_front1___4 = $c5
    .label vera_sprite_zdepth_in_front1___8 = $c5
    .label vera_sprite_VFlip_off1___4 = $b2
    .label vera_sprite_VFlip_off1___7 = $b2
    .label vera_sprite_HFlip_off1___4 = $b2
    .label vera_sprite_HFlip_off1___7 = $b2
    .label vera_sprite_palette_offset1___4 = $b0
    .label vera_sprite_palette_offset1___8 = $b0
    .label vera_sprite_4bpp1_sprite_offset = $b6
    .label vera_sprite_address1_sprite_offset = $b4
    .label vera_sprite_xy1_x = $b4
    .label vera_sprite_xy1_y = $b9
    .label vera_sprite_xy1_sprite_offset = $bb
    .label vera_sprite_height_321_sprite_offset = $b2
    .label vera_sprite_width_321_sprite_offset = $b2
    .label vera_sprite_zdepth_in_front1_sprite_offset = $c5
    .label vera_sprite_VFlip_off1_sprite_offset = $b2
    .label vera_sprite_HFlip_off1_sprite_offset = $b2
    .label vera_sprite_palette_offset1_sprite_offset = $b0
    .label enemy2_sprite_address = $c7
    // [974] phi from create_sprites_enemy2 to create_sprites_enemy2::@1 [phi:create_sprites_enemy2->create_sprites_enemy2::@1]
    // [974] phi create_sprites_enemy2::enemy2_sprite_address#10 = VRAM_ENEMY2 [phi:create_sprites_enemy2->create_sprites_enemy2::@1#0] -- vduz1=vduc1 
    lda #<VRAM_ENEMY2
    sta.z enemy2_sprite_address
    lda #>VRAM_ENEMY2
    sta.z enemy2_sprite_address+1
    lda #<VRAM_ENEMY2>>$10
    sta.z enemy2_sprite_address+2
    lda #>VRAM_ENEMY2>>$10
    sta.z enemy2_sprite_address+3
    // [974] phi create_sprites_enemy2::s#10 = 0 [phi:create_sprites_enemy2->create_sprites_enemy2::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // create_sprites_enemy2::@1
  __b1:
    // for(byte s=0;s<NUM_ENEMY2;s++)
    // [975] if(create_sprites_enemy2::s#10<NUM_ENEMY2) goto create_sprites_enemy2::@2 -- vbuxx_lt_vbuc1_then_la1 
    cpx #NUM_ENEMY2
    bcc __b2
    // create_sprites_enemy2::@return
    // }
    // [976] return 
    rts
    // create_sprites_enemy2::@2
  __b2:
    // vera_sprite_4bpp(s+base)
    // [977] create_sprites_enemy2::vera_sprite_4bpp1_sprite#0 = create_sprites_enemy2::s#10 + create_sprites_enemy2::base -- vbuaa=vbuxx_plus_vbuc1 
    txa
    clc
    adc #base
    // create_sprites_enemy2::vera_sprite_4bpp1
    // (word)sprite << 3
    // [978] create_sprites_enemy2::vera_sprite_4bpp1_$7 = (word)create_sprites_enemy2::vera_sprite_4bpp1_sprite#0 -- vwuz1=_word_vbuaa 
    sta.z vera_sprite_4bpp1___7
    lda #0
    sta.z vera_sprite_4bpp1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [979] create_sprites_enemy2::vera_sprite_4bpp1_sprite_offset#0 = create_sprites_enemy2::vera_sprite_4bpp1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_4bpp1_sprite_offset
    rol.z vera_sprite_4bpp1_sprite_offset+1
    asl.z vera_sprite_4bpp1_sprite_offset
    rol.z vera_sprite_4bpp1_sprite_offset+1
    asl.z vera_sprite_4bpp1_sprite_offset
    rol.z vera_sprite_4bpp1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [980] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+1
    // [981] create_sprites_enemy2::vera_sprite_4bpp1_$4 = create_sprites_enemy2::vera_sprite_4bpp1_sprite_offset#0 + <VERA_SPRITE_ATTR+1 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_4bpp1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+1
    sta.z vera_sprite_4bpp1___4
    lda.z vera_sprite_4bpp1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+1
    sta.z vera_sprite_4bpp1___4+1
    // <sprite_offset+1
    // [982] create_sprites_enemy2::vera_sprite_4bpp1_$3 = < create_sprites_enemy2::vera_sprite_4bpp1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_4bpp1___4
    // *VERA_ADDRX_L = <sprite_offset+1
    // [983] *VERA_ADDRX_L = create_sprites_enemy2::vera_sprite_4bpp1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+1
    // [984] create_sprites_enemy2::vera_sprite_4bpp1_$5 = > create_sprites_enemy2::vera_sprite_4bpp1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_4bpp1___4+1
    // *VERA_ADDRX_M = >sprite_offset+1
    // [985] *VERA_ADDRX_M = create_sprites_enemy2::vera_sprite_4bpp1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [986] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~>VERA_SPRITE_8BPP
    // [987] create_sprites_enemy2::vera_sprite_4bpp1_$6 = *VERA_DATA0 & ~>VERA_SPRITE_8BPP -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #(>VERA_SPRITE_8BPP)^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~>VERA_SPRITE_8BPP
    // [988] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_4bpp1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_enemy2::@3
    // Enemy2Sprites[s] = enemy2_sprite_address
    // [989] create_sprites_enemy2::$25 = create_sprites_enemy2::s#10 << 2 -- vbuaa=vbuxx_rol_2 
    txa
    asl
    asl
    // [990] Enemy2Sprites[create_sprites_enemy2::$25] = create_sprites_enemy2::enemy2_sprite_address#10 -- pduc1_derefidx_vbuaa=vduz1 
    tay
    lda.z enemy2_sprite_address
    sta Enemy2Sprites,y
    lda.z enemy2_sprite_address+1
    sta Enemy2Sprites+1,y
    lda.z enemy2_sprite_address+2
    sta Enemy2Sprites+2,y
    lda.z enemy2_sprite_address+3
    sta Enemy2Sprites+3,y
    // vera_sprite_address(s+base, enemy2_sprite_address)
    // [991] create_sprites_enemy2::vera_sprite_address1_sprite#0 = create_sprites_enemy2::s#10 + create_sprites_enemy2::base -- vbuaa=vbuxx_plus_vbuc1 
    txa
    clc
    adc #base
    // create_sprites_enemy2::vera_sprite_address1
    // (word)sprite << 3
    // [992] create_sprites_enemy2::vera_sprite_address1_$14 = (word)create_sprites_enemy2::vera_sprite_address1_sprite#0 -- vwuz1=_word_vbuaa 
    sta.z vera_sprite_address1___14
    lda #0
    sta.z vera_sprite_address1___14+1
    // [993] create_sprites_enemy2::vera_sprite_address1_$0 = create_sprites_enemy2::vera_sprite_address1_$14 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    asl.z vera_sprite_address1___0
    rol.z vera_sprite_address1___0+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [994] create_sprites_enemy2::vera_sprite_address1_sprite_offset#0 = <VERA_SPRITE_ATTR + create_sprites_enemy2::vera_sprite_address1_$0 -- vwuz1=vwuc1_plus_vwuz1 
    clc
    lda.z vera_sprite_address1_sprite_offset
    adc #<VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset
    lda.z vera_sprite_address1_sprite_offset+1
    adc #>VERA_SPRITE_ATTR&$ffff
    sta.z vera_sprite_address1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [995] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <sprite_offset
    // [996] create_sprites_enemy2::vera_sprite_address1_$2 = < create_sprites_enemy2::vera_sprite_address1_sprite_offset#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1_sprite_offset
    // *VERA_ADDRX_L = <sprite_offset
    // [997] *VERA_ADDRX_L = create_sprites_enemy2::vera_sprite_address1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset
    // [998] create_sprites_enemy2::vera_sprite_address1_$3 = > create_sprites_enemy2::vera_sprite_address1_sprite_offset#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_address1_sprite_offset+1
    // *VERA_ADDRX_M = >sprite_offset
    // [999] *VERA_ADDRX_M = create_sprites_enemy2::vera_sprite_address1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [1000] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <address
    // [1001] create_sprites_enemy2::vera_sprite_address1_$4 = < create_sprites_enemy2::enemy2_sprite_address#10 -- vwuz1=_lo_vduz2 
    lda.z enemy2_sprite_address
    sta.z vera_sprite_address1___4
    lda.z enemy2_sprite_address+1
    sta.z vera_sprite_address1___4+1
    // (<address)>>5
    // [1002] create_sprites_enemy2::vera_sprite_address1_$5 = create_sprites_enemy2::vera_sprite_address1_$4 >> 5 -- vwuz1=vwuz1_ror_5 
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
    // [1003] create_sprites_enemy2::vera_sprite_address1_$6 = < create_sprites_enemy2::vera_sprite_address1_$5 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1___5
    // *VERA_DATA0 = <((<address)>>5)
    // [1004] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_address1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // <address
    // [1005] create_sprites_enemy2::vera_sprite_address1_$7 = < create_sprites_enemy2::enemy2_sprite_address#10 -- vwuz1=_lo_vduz2 
    lda.z enemy2_sprite_address
    sta.z vera_sprite_address1___7
    lda.z enemy2_sprite_address+1
    sta.z vera_sprite_address1___7+1
    // >(<address)
    // [1006] create_sprites_enemy2::vera_sprite_address1_$8 = > create_sprites_enemy2::vera_sprite_address1_$7 -- vbuaa=_hi_vwuz1 
    // (>(<address))>>5
    // [1007] create_sprites_enemy2::vera_sprite_address1_$9 = create_sprites_enemy2::vera_sprite_address1_$8 >> 5 -- vbuz1=vbuaa_ror_5 
    lsr
    lsr
    lsr
    lsr
    lsr
    sta.z vera_sprite_address1___9
    // >address
    // [1008] create_sprites_enemy2::vera_sprite_address1_$10 = > create_sprites_enemy2::enemy2_sprite_address#10 -- vwuz1=_hi_vduz2 
    lda.z enemy2_sprite_address+2
    sta.z vera_sprite_address1___10
    lda.z enemy2_sprite_address+3
    sta.z vera_sprite_address1___10+1
    // <(>address)
    // [1009] create_sprites_enemy2::vera_sprite_address1_$11 = < create_sprites_enemy2::vera_sprite_address1_$10 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_address1___10
    // (<(>address))<<3
    // [1010] create_sprites_enemy2::vera_sprite_address1_$12 = create_sprites_enemy2::vera_sprite_address1_$11 << 3 -- vbuaa=vbuaa_rol_3 
    asl
    asl
    asl
    // ((>(<address))>>5)|((<(>address))<<3)
    // [1011] create_sprites_enemy2::vera_sprite_address1_$13 = create_sprites_enemy2::vera_sprite_address1_$9 | create_sprites_enemy2::vera_sprite_address1_$12 -- vbuaa=vbuz1_bor_vbuaa 
    ora.z vera_sprite_address1___9
    // *VERA_DATA0 = ((>(<address))>>5)|((<(>address))<<3)
    // [1012] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_address1_$13 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_enemy2::@4
    // vera_sprite_xy(s+base, 40+((word)(s&03)<<6), 340+((word)(s>>2)<<6))
    // [1013] create_sprites_enemy2::vera_sprite_xy1_sprite#0 = create_sprites_enemy2::s#10 + create_sprites_enemy2::base -- vbuyy=vbuxx_plus_vbuc1 
    txa
    clc
    adc #base
    tay
    // s&03
    // [1014] create_sprites_enemy2::$6 = create_sprites_enemy2::s#10 & 3 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #3
    // (word)(s&03)<<6
    // [1015] create_sprites_enemy2::$26 = (word)create_sprites_enemy2::$6 -- vwuz1=_word_vbuaa 
    sta.z __26
    lda #0
    sta.z __26+1
    // [1016] create_sprites_enemy2::$7 = create_sprites_enemy2::$26 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z __7+1
    lsr
    sta.z $ff
    lda.z __7
    ror
    sta.z __7+1
    lda #0
    ror
    sta.z __7
    lsr.z $ff
    ror.z __7+1
    ror.z __7
    // vera_sprite_xy(s+base, 40+((word)(s&03)<<6), 340+((word)(s>>2)<<6))
    // [1017] create_sprites_enemy2::vera_sprite_xy1_x#0 = $28 + create_sprites_enemy2::$7 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$28
    clc
    adc.z vera_sprite_xy1_x
    sta.z vera_sprite_xy1_x
    bcc !+
    inc.z vera_sprite_xy1_x+1
  !:
    // s>>2
    // [1018] create_sprites_enemy2::$9 = create_sprites_enemy2::s#10 >> 2 -- vbuaa=vbuxx_ror_2 
    txa
    lsr
    lsr
    // (word)(s>>2)<<6
    // [1019] create_sprites_enemy2::$27 = (word)create_sprites_enemy2::$9 -- vwuz1=_word_vbuaa 
    sta.z __27
    lda #0
    sta.z __27+1
    // [1020] create_sprites_enemy2::$10 = create_sprites_enemy2::$27 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z __10+1
    lsr
    sta.z $ff
    lda.z __10
    ror
    sta.z __10+1
    lda #0
    ror
    sta.z __10
    lsr.z $ff
    ror.z __10+1
    ror.z __10
    // vera_sprite_xy(s+base, 40+((word)(s&03)<<6), 340+((word)(s>>2)<<6))
    // [1021] create_sprites_enemy2::vera_sprite_xy1_y#0 = $154 + create_sprites_enemy2::$10 -- vwuz1=vwuc1_plus_vwuz1 
    clc
    lda.z vera_sprite_xy1_y
    adc #<$154
    sta.z vera_sprite_xy1_y
    lda.z vera_sprite_xy1_y+1
    adc #>$154
    sta.z vera_sprite_xy1_y+1
    // create_sprites_enemy2::vera_sprite_xy1
    // (word)sprite << 3
    // [1022] create_sprites_enemy2::vera_sprite_xy1_$10 = (word)create_sprites_enemy2::vera_sprite_xy1_sprite#0 -- vwuz1=_word_vbuyy 
    tya
    sta.z vera_sprite_xy1___10
    lda #0
    sta.z vera_sprite_xy1___10+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1023] create_sprites_enemy2::vera_sprite_xy1_sprite_offset#0 = create_sprites_enemy2::vera_sprite_xy1_$10 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    asl.z vera_sprite_xy1_sprite_offset
    rol.z vera_sprite_xy1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1024] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+2
    // [1025] create_sprites_enemy2::vera_sprite_xy1_$4 = create_sprites_enemy2::vera_sprite_xy1_sprite_offset#0 + <VERA_SPRITE_ATTR+2 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_xy1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4
    lda.z vera_sprite_xy1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+2
    sta.z vera_sprite_xy1___4+1
    // <sprite_offset+2
    // [1026] create_sprites_enemy2::vera_sprite_xy1_$3 = < create_sprites_enemy2::vera_sprite_xy1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1___4
    // *VERA_ADDRX_L = <sprite_offset+2
    // [1027] *VERA_ADDRX_L = create_sprites_enemy2::vera_sprite_xy1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+2
    // [1028] create_sprites_enemy2::vera_sprite_xy1_$5 = > create_sprites_enemy2::vera_sprite_xy1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1___4+1
    // *VERA_ADDRX_M = >sprite_offset+2
    // [1029] *VERA_ADDRX_M = create_sprites_enemy2::vera_sprite_xy1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | <(>VERA_SPRITE_ATTR)
    // [1030] *VERA_ADDRX_H = VERA_INC_1|<>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|(<(VERA_SPRITE_ATTR>>$10))
    sta VERA_ADDRX_H
    // <x
    // [1031] create_sprites_enemy2::vera_sprite_xy1_$6 = < create_sprites_enemy2::vera_sprite_xy1_x#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1_x
    // *VERA_DATA0 = <x
    // [1032] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_xy1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // >x
    // [1033] create_sprites_enemy2::vera_sprite_xy1_$7 = > create_sprites_enemy2::vera_sprite_xy1_x#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1_x+1
    // *VERA_DATA0 = >x
    // [1034] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_xy1_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // <y
    // [1035] create_sprites_enemy2::vera_sprite_xy1_$8 = < create_sprites_enemy2::vera_sprite_xy1_y#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_xy1_y
    // *VERA_DATA0 = <y
    // [1036] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_xy1_$8 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // >y
    // [1037] create_sprites_enemy2::vera_sprite_xy1_$9 = > create_sprites_enemy2::vera_sprite_xy1_y#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_xy1_y+1
    // *VERA_DATA0 = >y
    // [1038] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_xy1_$9 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_enemy2::@5
    // vera_sprite_height_32(s+base)
    // [1039] create_sprites_enemy2::vera_sprite_height_321_sprite#0 = create_sprites_enemy2::s#10 + create_sprites_enemy2::base -- vbuaa=vbuxx_plus_vbuc1 
    txa
    clc
    adc #base
    // create_sprites_enemy2::vera_sprite_height_321
    // (word)sprite << 3
    // [1040] create_sprites_enemy2::vera_sprite_height_321_$8 = (word)create_sprites_enemy2::vera_sprite_height_321_sprite#0 -- vwuz1=_word_vbuaa 
    sta.z vera_sprite_height_321___8
    lda #0
    sta.z vera_sprite_height_321___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1041] create_sprites_enemy2::vera_sprite_height_321_sprite_offset#0 = create_sprites_enemy2::vera_sprite_height_321_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_height_321_sprite_offset
    rol.z vera_sprite_height_321_sprite_offset+1
    asl.z vera_sprite_height_321_sprite_offset
    rol.z vera_sprite_height_321_sprite_offset+1
    asl.z vera_sprite_height_321_sprite_offset
    rol.z vera_sprite_height_321_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1042] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1043] create_sprites_enemy2::vera_sprite_height_321_$4 = create_sprites_enemy2::vera_sprite_height_321_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_height_321___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height_321___4
    lda.z vera_sprite_height_321___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_height_321___4+1
    // <sprite_offset+7
    // [1044] create_sprites_enemy2::vera_sprite_height_321_$3 = < create_sprites_enemy2::vera_sprite_height_321_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_height_321___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1045] *VERA_ADDRX_L = create_sprites_enemy2::vera_sprite_height_321_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1046] create_sprites_enemy2::vera_sprite_height_321_$5 = > create_sprites_enemy2::vera_sprite_height_321_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_height_321___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1047] *VERA_ADDRX_M = create_sprites_enemy2::vera_sprite_height_321_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1048] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [1049] create_sprites_enemy2::vera_sprite_height_321_$6 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HEIGHT_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_32
    // [1050] create_sprites_enemy2::vera_sprite_height_321_$7 = create_sprites_enemy2::vera_sprite_height_321_$6 | VERA_SPRITE_HEIGHT_32 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_HEIGHT_32
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK | VERA_SPRITE_HEIGHT_32
    // [1051] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_height_321_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_enemy2::@6
    // vera_sprite_width_32(s+base)
    // [1052] create_sprites_enemy2::vera_sprite_width_321_sprite#0 = create_sprites_enemy2::s#10 + create_sprites_enemy2::base -- vbuaa=vbuxx_plus_vbuc1 
    txa
    clc
    adc #base
    // create_sprites_enemy2::vera_sprite_width_321
    // (word)sprite << 3
    // [1053] create_sprites_enemy2::vera_sprite_width_321_$8 = (word)create_sprites_enemy2::vera_sprite_width_321_sprite#0 -- vwuz1=_word_vbuaa 
    sta.z vera_sprite_width_321___8
    lda #0
    sta.z vera_sprite_width_321___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1054] create_sprites_enemy2::vera_sprite_width_321_sprite_offset#0 = create_sprites_enemy2::vera_sprite_width_321_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_width_321_sprite_offset
    rol.z vera_sprite_width_321_sprite_offset+1
    asl.z vera_sprite_width_321_sprite_offset
    rol.z vera_sprite_width_321_sprite_offset+1
    asl.z vera_sprite_width_321_sprite_offset
    rol.z vera_sprite_width_321_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1055] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1056] create_sprites_enemy2::vera_sprite_width_321_$4 = create_sprites_enemy2::vera_sprite_width_321_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_width_321___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_321___4
    lda.z vera_sprite_width_321___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_width_321___4+1
    // <sprite_offset+7
    // [1057] create_sprites_enemy2::vera_sprite_width_321_$3 = < create_sprites_enemy2::vera_sprite_width_321_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_width_321___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1058] *VERA_ADDRX_L = create_sprites_enemy2::vera_sprite_width_321_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1059] create_sprites_enemy2::vera_sprite_width_321_$5 = > create_sprites_enemy2::vera_sprite_width_321_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_width_321___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1060] *VERA_ADDRX_M = create_sprites_enemy2::vera_sprite_width_321_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1061] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [1062] create_sprites_enemy2::vera_sprite_width_321_$6 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_WIDTH_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_32
    // [1063] create_sprites_enemy2::vera_sprite_width_321_$7 = create_sprites_enemy2::vera_sprite_width_321_$6 | VERA_SPRITE_WIDTH_32 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_WIDTH_32
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK | VERA_SPRITE_WIDTH_32
    // [1064] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_width_321_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_enemy2::@7
    // vera_sprite_zdepth_in_front(s+base)
    // [1065] create_sprites_enemy2::vera_sprite_zdepth_in_front1_sprite#0 = create_sprites_enemy2::s#10 + create_sprites_enemy2::base -- vbuaa=vbuxx_plus_vbuc1 
    txa
    clc
    adc #base
    // create_sprites_enemy2::vera_sprite_zdepth_in_front1
    // (word)sprite << 3
    // [1066] create_sprites_enemy2::vera_sprite_zdepth_in_front1_$8 = (word)create_sprites_enemy2::vera_sprite_zdepth_in_front1_sprite#0 -- vwuz1=_word_vbuaa 
    sta.z vera_sprite_zdepth_in_front1___8
    lda #0
    sta.z vera_sprite_zdepth_in_front1___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1067] create_sprites_enemy2::vera_sprite_zdepth_in_front1_sprite_offset#0 = create_sprites_enemy2::vera_sprite_zdepth_in_front1_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_zdepth_in_front1_sprite_offset
    rol.z vera_sprite_zdepth_in_front1_sprite_offset+1
    asl.z vera_sprite_zdepth_in_front1_sprite_offset
    rol.z vera_sprite_zdepth_in_front1_sprite_offset+1
    asl.z vera_sprite_zdepth_in_front1_sprite_offset
    rol.z vera_sprite_zdepth_in_front1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1068] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1069] create_sprites_enemy2::vera_sprite_zdepth_in_front1_$4 = create_sprites_enemy2::vera_sprite_zdepth_in_front1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_zdepth_in_front1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_in_front1___4
    lda.z vera_sprite_zdepth_in_front1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_zdepth_in_front1___4+1
    // <sprite_offset+6
    // [1070] create_sprites_enemy2::vera_sprite_zdepth_in_front1_$3 = < create_sprites_enemy2::vera_sprite_zdepth_in_front1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_zdepth_in_front1___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1071] *VERA_ADDRX_L = create_sprites_enemy2::vera_sprite_zdepth_in_front1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1072] create_sprites_enemy2::vera_sprite_zdepth_in_front1_$5 = > create_sprites_enemy2::vera_sprite_zdepth_in_front1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_zdepth_in_front1___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1073] *VERA_ADDRX_M = create_sprites_enemy2::vera_sprite_zdepth_in_front1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1074] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [1075] create_sprites_enemy2::vera_sprite_zdepth_in_front1_$6 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_ZDEPTH_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_IN_FRONT
    // [1076] create_sprites_enemy2::vera_sprite_zdepth_in_front1_$7 = create_sprites_enemy2::vera_sprite_zdepth_in_front1_$6 | VERA_SPRITE_ZDEPTH_IN_FRONT -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_SPRITE_ZDEPTH_IN_FRONT
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | VERA_SPRITE_ZDEPTH_IN_FRONT
    // [1077] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_zdepth_in_front1_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_enemy2::@8
    // vera_sprite_VFlip_off(s+base)
    // [1078] create_sprites_enemy2::vera_sprite_VFlip_off1_sprite#0 = create_sprites_enemy2::s#10 + create_sprites_enemy2::base -- vbuaa=vbuxx_plus_vbuc1 
    txa
    clc
    adc #base
    // create_sprites_enemy2::vera_sprite_VFlip_off1
    // (word)sprite << 3
    // [1079] create_sprites_enemy2::vera_sprite_VFlip_off1_$7 = (word)create_sprites_enemy2::vera_sprite_VFlip_off1_sprite#0 -- vwuz1=_word_vbuaa 
    sta.z vera_sprite_VFlip_off1___7
    lda #0
    sta.z vera_sprite_VFlip_off1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1080] create_sprites_enemy2::vera_sprite_VFlip_off1_sprite_offset#0 = create_sprites_enemy2::vera_sprite_VFlip_off1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_VFlip_off1_sprite_offset
    rol.z vera_sprite_VFlip_off1_sprite_offset+1
    asl.z vera_sprite_VFlip_off1_sprite_offset
    rol.z vera_sprite_VFlip_off1_sprite_offset+1
    asl.z vera_sprite_VFlip_off1_sprite_offset
    rol.z vera_sprite_VFlip_off1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1081] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1082] create_sprites_enemy2::vera_sprite_VFlip_off1_$4 = create_sprites_enemy2::vera_sprite_VFlip_off1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_VFlip_off1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_VFlip_off1___4
    lda.z vera_sprite_VFlip_off1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_VFlip_off1___4+1
    // <sprite_offset+6
    // [1083] create_sprites_enemy2::vera_sprite_VFlip_off1_$3 = < create_sprites_enemy2::vera_sprite_VFlip_off1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_VFlip_off1___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1084] *VERA_ADDRX_L = create_sprites_enemy2::vera_sprite_VFlip_off1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1085] create_sprites_enemy2::vera_sprite_VFlip_off1_$5 = > create_sprites_enemy2::vera_sprite_VFlip_off1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_VFlip_off1___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1086] *VERA_ADDRX_M = create_sprites_enemy2::vera_sprite_VFlip_off1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1087] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_VFLIP
    // [1088] create_sprites_enemy2::vera_sprite_VFlip_off1_$6 = *VERA_DATA0 & ~VERA_SPRITE_VFLIP -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_VFLIP^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_VFLIP
    // [1089] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_VFlip_off1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_enemy2::@9
    // vera_sprite_HFlip_off(s+base)
    // [1090] create_sprites_enemy2::vera_sprite_HFlip_off1_sprite#0 = create_sprites_enemy2::s#10 + create_sprites_enemy2::base -- vbuaa=vbuxx_plus_vbuc1 
    txa
    clc
    adc #base
    // create_sprites_enemy2::vera_sprite_HFlip_off1
    // (word)sprite << 3
    // [1091] create_sprites_enemy2::vera_sprite_HFlip_off1_$7 = (word)create_sprites_enemy2::vera_sprite_HFlip_off1_sprite#0 -- vwuz1=_word_vbuaa 
    sta.z vera_sprite_HFlip_off1___7
    lda #0
    sta.z vera_sprite_HFlip_off1___7+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1092] create_sprites_enemy2::vera_sprite_HFlip_off1_sprite_offset#0 = create_sprites_enemy2::vera_sprite_HFlip_off1_$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_HFlip_off1_sprite_offset
    rol.z vera_sprite_HFlip_off1_sprite_offset+1
    asl.z vera_sprite_HFlip_off1_sprite_offset
    rol.z vera_sprite_HFlip_off1_sprite_offset+1
    asl.z vera_sprite_HFlip_off1_sprite_offset
    rol.z vera_sprite_HFlip_off1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1093] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+6
    // [1094] create_sprites_enemy2::vera_sprite_HFlip_off1_$4 = create_sprites_enemy2::vera_sprite_HFlip_off1_sprite_offset#0 + <VERA_SPRITE_ATTR+6 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_HFlip_off1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_HFlip_off1___4
    lda.z vera_sprite_HFlip_off1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+6
    sta.z vera_sprite_HFlip_off1___4+1
    // <sprite_offset+6
    // [1095] create_sprites_enemy2::vera_sprite_HFlip_off1_$3 = < create_sprites_enemy2::vera_sprite_HFlip_off1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_HFlip_off1___4
    // *VERA_ADDRX_L = <sprite_offset+6
    // [1096] *VERA_ADDRX_L = create_sprites_enemy2::vera_sprite_HFlip_off1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+6
    // [1097] create_sprites_enemy2::vera_sprite_HFlip_off1_$5 = > create_sprites_enemy2::vera_sprite_HFlip_off1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_HFlip_off1___4+1
    // *VERA_ADDRX_M = >sprite_offset+6
    // [1098] *VERA_ADDRX_M = create_sprites_enemy2::vera_sprite_HFlip_off1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1099] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_HFLIP
    // [1100] create_sprites_enemy2::vera_sprite_HFlip_off1_$6 = *VERA_DATA0 & ~VERA_SPRITE_HFLIP -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_HFLIP^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HFLIP
    // [1101] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_HFlip_off1_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_enemy2::@10
    // vera_sprite_palette_offset(s+base,2)
    // [1102] create_sprites_enemy2::vera_sprite_palette_offset1_sprite#0 = create_sprites_enemy2::s#10 + create_sprites_enemy2::base -- vbuaa=vbuxx_plus_vbuc1 
    txa
    clc
    adc #base
    // create_sprites_enemy2::vera_sprite_palette_offset1
    // (word)sprite << 3
    // [1103] create_sprites_enemy2::vera_sprite_palette_offset1_$8 = (word)create_sprites_enemy2::vera_sprite_palette_offset1_sprite#0 -- vwuz1=_word_vbuaa 
    sta.z vera_sprite_palette_offset1___8
    lda #0
    sta.z vera_sprite_palette_offset1___8+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [1104] create_sprites_enemy2::vera_sprite_palette_offset1_sprite_offset#0 = create_sprites_enemy2::vera_sprite_palette_offset1_$8 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z vera_sprite_palette_offset1_sprite_offset
    rol.z vera_sprite_palette_offset1_sprite_offset+1
    asl.z vera_sprite_palette_offset1_sprite_offset
    rol.z vera_sprite_palette_offset1_sprite_offset+1
    asl.z vera_sprite_palette_offset1_sprite_offset
    rol.z vera_sprite_palette_offset1_sprite_offset+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1105] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // sprite_offset+7
    // [1106] create_sprites_enemy2::vera_sprite_palette_offset1_$4 = create_sprites_enemy2::vera_sprite_palette_offset1_sprite_offset#0 + <VERA_SPRITE_ATTR+7 -- vwuz1=vwuz1_plus_vwuc1 
    clc
    lda.z vera_sprite_palette_offset1___4
    adc #<((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_palette_offset1___4
    lda.z vera_sprite_palette_offset1___4+1
    adc #>((VERA_SPRITE_ATTR&$ffff))+7
    sta.z vera_sprite_palette_offset1___4+1
    // <sprite_offset+7
    // [1107] create_sprites_enemy2::vera_sprite_palette_offset1_$3 = < create_sprites_enemy2::vera_sprite_palette_offset1_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_sprite_palette_offset1___4
    // *VERA_ADDRX_L = <sprite_offset+7
    // [1108] *VERA_ADDRX_L = create_sprites_enemy2::vera_sprite_palette_offset1_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >sprite_offset+7
    // [1109] create_sprites_enemy2::vera_sprite_palette_offset1_$5 = > create_sprites_enemy2::vera_sprite_palette_offset1_$4 -- vbuaa=_hi_vwuz1 
    lda.z vera_sprite_palette_offset1___4+1
    // *VERA_ADDRX_M = >sprite_offset+7
    // [1110] *VERA_ADDRX_M = create_sprites_enemy2::vera_sprite_palette_offset1_$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_0 | <(>VERA_SPRITE_ATTR)
    // [1111] *VERA_ADDRX_H = <>VERA_SPRITE_ATTR -- _deref_pbuc1=vbuc2 
    lda #<VERA_SPRITE_ATTR>>$10
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK
    // [1112] create_sprites_enemy2::vera_sprite_palette_offset1_$6 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_PALETTE_OFFSET_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK | palette_offset
    // [1113] create_sprites_enemy2::vera_sprite_palette_offset1_$7 = create_sprites_enemy2::vera_sprite_palette_offset1_$6 | create_sprites_enemy2::vera_sprite_palette_offset1_palette_offset#0 -- vbuaa=vbuaa_bor_vbuc1 
    ora #vera_sprite_palette_offset1_palette_offset
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK | palette_offset
    // [1114] *VERA_DATA0 = create_sprites_enemy2::vera_sprite_palette_offset1_$7 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // create_sprites_enemy2::@11
    // enemy2_sprite_address += 32*32/2
    // [1115] create_sprites_enemy2::enemy2_sprite_address#1 = create_sprites_enemy2::enemy2_sprite_address#10 + (word)$20*$20/2 -- vduz1=vduz1_plus_vwuc1 
    lda.z enemy2_sprite_address
    clc
    adc #<$20*$20/2
    sta.z enemy2_sprite_address
    lda.z enemy2_sprite_address+1
    adc #>$20*$20/2
    sta.z enemy2_sprite_address+1
    lda.z enemy2_sprite_address+2
    adc #0
    sta.z enemy2_sprite_address+2
    lda.z enemy2_sprite_address+3
    adc #0
    sta.z enemy2_sprite_address+3
    // for(byte s=0;s<NUM_ENEMY2;s++)
    // [1116] create_sprites_enemy2::s#1 = ++ create_sprites_enemy2::s#10 -- vbuxx=_inc_vbuxx 
    inx
    // [974] phi from create_sprites_enemy2::@11 to create_sprites_enemy2::@1 [phi:create_sprites_enemy2::@11->create_sprites_enemy2::@1]
    // [974] phi create_sprites_enemy2::enemy2_sprite_address#10 = create_sprites_enemy2::enemy2_sprite_address#1 [phi:create_sprites_enemy2::@11->create_sprites_enemy2::@1#0] -- register_copy 
    // [974] phi create_sprites_enemy2::s#10 = create_sprites_enemy2::s#1 [phi:create_sprites_enemy2::@11->create_sprites_enemy2::@1#1] -- register_copy 
    jmp __b1
}
  // kbhit
// Return true if there's a key waiting, return false if not
kbhit: {
    .label chptr = ch
    .label IN_DEV = $28a
    // Current input device number
    .label GETIN = $ffe4
    .label ch = $bd
    // ch = 0
    // [1117] kbhit::ch = 0 -- vbuz1=vbuc1 
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
    // [1119] kbhit::return#0 = kbhit::ch -- vbuaa=vbuz1 
    // kbhit::@return
    // }
    // [1120] kbhit::return#1 = kbhit::return#0
    // [1121] return 
    rts
}
  // divr16u
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp($6e) dividend, word zp($2c) rem)
divr16u: {
    .const divisor = 3
    .label rem = $2c
    .label dividend = $6e
    .label quotient = $70
    .label return = $70
    // [1123] phi from divr16u to divr16u::@1 [phi:divr16u->divr16u::@1]
    // [1123] phi divr16u::i#2 = 0 [phi:divr16u->divr16u::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [1123] phi divr16u::quotient#3 = 0 [phi:divr16u->divr16u::@1#1] -- vwuz1=vwuc1 
    txa
    sta.z quotient
    sta.z quotient+1
    // [1123] phi divr16u::dividend#2 = divr16u::dividend#1 [phi:divr16u->divr16u::@1#2] -- register_copy 
    // [1123] phi divr16u::rem#4 = 0 [phi:divr16u->divr16u::@1#3] -- vwuz1=vbuc1 
    sta.z rem
    sta.z rem+1
    // [1123] phi from divr16u::@3 to divr16u::@1 [phi:divr16u::@3->divr16u::@1]
    // [1123] phi divr16u::i#2 = divr16u::i#1 [phi:divr16u::@3->divr16u::@1#0] -- register_copy 
    // [1123] phi divr16u::quotient#3 = divr16u::return#0 [phi:divr16u::@3->divr16u::@1#1] -- register_copy 
    // [1123] phi divr16u::dividend#2 = divr16u::dividend#0 [phi:divr16u::@3->divr16u::@1#2] -- register_copy 
    // [1123] phi divr16u::rem#4 = divr16u::rem#10 [phi:divr16u::@3->divr16u::@1#3] -- register_copy 
    // divr16u::@1
  __b1:
    // rem = rem << 1
    // [1124] divr16u::rem#0 = divr16u::rem#4 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z rem
    rol.z rem+1
    // >dividend
    // [1125] divr16u::$1 = > divr16u::dividend#2 -- vbuaa=_hi_vwuz1 
    lda.z dividend+1
    // >dividend & $80
    // [1126] divr16u::$2 = divr16u::$1 & $80 -- vbuaa=vbuaa_band_vbuc1 
    and #$80
    // if( (>dividend & $80) != 0 )
    // [1127] if(divr16u::$2==0) goto divr16u::@2 -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b2
    // divr16u::@4
    // rem = rem | 1
    // [1128] divr16u::rem#1 = divr16u::rem#0 | 1 -- vwuz1=vwuz1_bor_vbuc1 
    lda #1
    ora.z rem
    sta.z rem
    // [1129] phi from divr16u::@1 divr16u::@4 to divr16u::@2 [phi:divr16u::@1/divr16u::@4->divr16u::@2]
    // [1129] phi divr16u::rem#5 = divr16u::rem#0 [phi:divr16u::@1/divr16u::@4->divr16u::@2#0] -- register_copy 
    // divr16u::@2
  __b2:
    // dividend = dividend << 1
    // [1130] divr16u::dividend#0 = divr16u::dividend#2 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z dividend
    rol.z dividend+1
    // quotient = quotient << 1
    // [1131] divr16u::quotient#1 = divr16u::quotient#3 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z quotient
    rol.z quotient+1
    // if(rem>=divisor)
    // [1132] if(divr16u::rem#5<divr16u::divisor#0) goto divr16u::@3 -- vwuz1_lt_vwuc1_then_la1 
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
    // [1133] divr16u::quotient#2 = ++ divr16u::quotient#1 -- vwuz1=_inc_vwuz1 
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    // rem = rem - divisor
    // [1134] divr16u::rem#2 = divr16u::rem#5 - divr16u::divisor#0 -- vwuz1=vwuz1_minus_vwuc1 
    lda.z rem
    sec
    sbc #<divisor
    sta.z rem
    lda.z rem+1
    sbc #>divisor
    sta.z rem+1
    // [1135] phi from divr16u::@2 divr16u::@5 to divr16u::@3 [phi:divr16u::@2/divr16u::@5->divr16u::@3]
    // [1135] phi divr16u::return#0 = divr16u::quotient#1 [phi:divr16u::@2/divr16u::@5->divr16u::@3#0] -- register_copy 
    // [1135] phi divr16u::rem#10 = divr16u::rem#5 [phi:divr16u::@2/divr16u::@5->divr16u::@3#1] -- register_copy 
    // divr16u::@3
  __b3:
    // for( char i : 0..15)
    // [1136] divr16u::i#1 = ++ divr16u::i#2 -- vbuxx=_inc_vbuxx 
    inx
    // [1137] if(divr16u::i#1!=$10) goto divr16u::@1 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$10
    bne __b1
    // divr16u::@return
    // }
    // [1138] return 
    rts
}
  // printf_uint
// Print an unsigned int using a specific format
// printf_uint(word zp($a) uvalue)
printf_uint: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
    .label uvalue = $a
    // printf_uint::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [1140] *((byte*)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
    // [1141] utoa::value#1 = printf_uint::uvalue#0
    // [1142] call utoa 
  // Format number into buffer
    // [1388] phi from printf_uint::@1 to utoa [phi:printf_uint::@1->utoa]
    jsr utoa
    // printf_uint::@2
    // printf_number_buffer(printf_buffer, format)
    // [1143] printf_number_buffer::buffer_sign#1 = *((byte*)&printf_buffer) -- vbuz1=_deref_pbuc1 
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
    // [1144] call printf_number_buffer 
  // Print using format
    // [1260] phi from printf_uint::@2 to printf_number_buffer [phi:printf_uint::@2->printf_number_buffer]
    // [1260] phi printf_number_buffer::format_upper_case#10 = printf_uint::format_upper_case#0 [phi:printf_uint::@2->printf_number_buffer#0] -- vbuz1=vbuc1 
    lda #format_upper_case
    sta.z printf_number_buffer.format_upper_case
    // [1260] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#1 [phi:printf_uint::@2->printf_number_buffer#1] -- register_copy 
    // [1260] phi printf_number_buffer::format_zero_padding#10 = printf_uint::format_zero_padding#0 [phi:printf_uint::@2->printf_number_buffer#2] -- vbuz1=vbuc1 
    lda #format_zero_padding
    sta.z printf_number_buffer.format_zero_padding
    // [1260] phi printf_number_buffer::format_justify_left#10 = printf_uint::format_justify_left#0 [phi:printf_uint::@2->printf_number_buffer#3] -- vbuz1=vbuc1 
    lda #format_justify_left
    sta.z printf_number_buffer.format_justify_left
    // [1260] phi printf_number_buffer::format_min_length#3 = printf_uint::format_min_length#0 [phi:printf_uint::@2->printf_number_buffer#4] -- vbuxx=vbuc1 
    ldx #format_min_length
    jsr printf_number_buffer
    // printf_uint::@return
    // }
    // [1145] return 
    rts
}
  // vera_layer_set_text_color_mode
// Set the configuration of the layer text color mode.
// - layer: Value of 0 or 1.
// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
vera_layer_set_text_color_mode: {
    .label addr = $73
    // addr = vera_layer_config[layer]
    // [1146] vera_layer_set_text_color_mode::addr#0 = *(vera_layer_config+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr &= ~VERA_LAYER_CONFIG_256C
    // [1147] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 & ~VERA_LAYER_CONFIG_256C -- _deref_pbuz1=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C^$ff
    ldy #0
    and (addr),y
    sta (addr),y
    // *addr |= color_mode
    // [1148] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 -- _deref_pbuz1=_deref_pbuz1 
    lda (addr),y
    sta (addr),y
    // vera_layer_set_text_color_mode::@return
    // }
    // [1149] return 
    rts
}
  // vera_layer_get_mapbase_bank
// Get the map base bank of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Bank in vera vram.
vera_layer_get_mapbase_bank: {
    .const layer = 1
    // return vera_mapbase_bank[layer];
    // [1150] vera_layer_get_mapbase_bank::return#0 = *(vera_mapbase_bank+vera_layer_get_mapbase_bank::layer#0) -- vbuaa=_deref_pbuc1 
    lda vera_mapbase_bank+layer
    // vera_layer_get_mapbase_bank::@return
    // }
    // [1151] return 
    rts
}
  // vera_layer_get_mapbase_offset
// Get the map base lower 16-bit address (offset) of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Offset in vera vram of the specified bank.
vera_layer_get_mapbase_offset: {
    .const layer = 1
    .label return = $73
    // return vera_mapbase_offset[layer];
    // [1152] vera_layer_get_mapbase_offset::return#0 = *(vera_mapbase_offset+vera_layer_get_mapbase_offset::layer#0<<1) -- vwuz1=_deref_pwuc1 
    lda vera_mapbase_offset+(layer<<1)
    sta.z return
    lda vera_mapbase_offset+(layer<<1)+1
    sta.z return+1
    // vera_layer_get_mapbase_offset::@return
    // }
    // [1153] return 
    rts
}
  // vera_layer_get_rowshift
// Get the bit shift value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
vera_layer_get_rowshift: {
    .const layer = 1
    // return vera_layer_rowshift[layer];
    // [1154] vera_layer_get_rowshift::return#0 = *(vera_layer_rowshift+vera_layer_get_rowshift::layer#0) -- vbuaa=_deref_pbuc1 
    lda vera_layer_rowshift+layer
    // vera_layer_get_rowshift::@return
    // }
    // [1155] return 
    rts
}
  // vera_layer_get_rowskip
// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
vera_layer_get_rowskip: {
    .const layer = 1
    .label return = $73
    // return vera_layer_rowskip[layer];
    // [1156] vera_layer_get_rowskip::return#0 = *(vera_layer_rowskip+vera_layer_get_rowskip::layer#0<<1) -- vwuz1=_deref_pwuc1 
    lda vera_layer_rowskip+(layer<<1)
    sta.z return
    lda vera_layer_rowskip+(layer<<1)+1
    sta.z return+1
    // vera_layer_get_rowskip::@return
    // }
    // [1157] return 
    rts
}
  // cx16_ram_bank
// Configure the bank of a banked ram on the X16.
// cx16_ram_bank(byte register(X) bank)
cx16_ram_bank: {
    // current_bank = VIA1->PORT_A
    // [1159] cx16_ram_bank::return#0 = *((byte*)VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A) -- vbuaa=_deref_pbuc1 
    lda VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    // VIA1->PORT_A = bank
    // [1160] *((byte*)VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A) = cx16_ram_bank::bank#11 -- _deref_pbuc1=vbuxx 
    stx VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    // cx16_ram_bank::@return
    // }
    // [1161] return 
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
// cbm_k_setnam(byte* zp($79) filename)
cbm_k_setnam: {
    .label filename = $79
    .label filename_len = $be
    .label __0 = $b2
    // strlen(filename)
    // [1162] strlen::str#1 = cbm_k_setnam::filename -- pbuz1=pbuz2 
    lda.z filename
    sta.z strlen.str
    lda.z filename+1
    sta.z strlen.str+1
    // [1163] call strlen 
    // [1409] phi from cbm_k_setnam to strlen [phi:cbm_k_setnam->strlen]
    // [1409] phi strlen::str#5 = strlen::str#1 [phi:cbm_k_setnam->strlen#0] -- register_copy 
    jsr strlen
    // strlen(filename)
    // [1164] strlen::return#2 = strlen::len#2
    // cbm_k_setnam::@1
    // [1165] cbm_k_setnam::$0 = strlen::return#2 -- vwuz1=vwuz2 
    lda.z strlen.return
    sta.z __0
    lda.z strlen.return+1
    sta.z __0+1
    // filename_len = (char)strlen(filename)
    // [1166] cbm_k_setnam::filename_len = (byte)cbm_k_setnam::$0 -- vbuz1=_byte_vwuz2 
    lda.z __0
    sta.z filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx filename
    ldy filename+1
    jsr CBM_SETNAM
    // cbm_k_setnam::@return
    // }
    // [1168] return 
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
// cbm_k_setlfs(byte zp($7b) channel, byte zp($7c) device, byte zp($7d) secondary)
cbm_k_setlfs: {
    .label channel = $7b
    .label device = $7c
    .label secondary = $7d
    // asm
    // asm { ldxdevice ldachannel ldysecondary jsrCBM_SETLFS  }
    ldx device
    lda channel
    ldy secondary
    jsr CBM_SETLFS
    // cbm_k_setlfs::@return
    // }
    // [1170] return 
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
    .label status = $bf
    // status
    // [1171] cbm_k_open::status = 0 -- vbuz1=vbuc1 
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
    // [1173] cbm_k_open::return#0 = cbm_k_open::status -- vbuaa=vbuz1 
    // cbm_k_open::@return
    // }
    // [1174] cbm_k_open::return#1 = cbm_k_open::return#0
    // [1175] return 
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
// cbm_k_chkin(byte zp($7e) channel)
cbm_k_chkin: {
    .label channel = $7e
    .label status = $c0
    // status
    // [1176] cbm_k_chkin::status = 0 -- vbuz1=vbuc1 
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
    // [1178] cbm_k_chkin::return#0 = cbm_k_chkin::status -- vbuaa=vbuz1 
    // cbm_k_chkin::@return
    // }
    // [1179] cbm_k_chkin::return#1 = cbm_k_chkin::return#0
    // [1180] return 
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
    .label value = $c1
    // value
    // [1181] cbm_k_chrin::value = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z value
    // asm
    // asm { jsrCBM_CHRIN stavalue  }
    jsr CBM_CHRIN
    sta value
    // return value;
    // [1183] cbm_k_chrin::return#0 = cbm_k_chrin::value -- vbuaa=vbuz1 
    // cbm_k_chrin::@return
    // }
    // [1184] cbm_k_chrin::return#1 = cbm_k_chrin::return#0
    // [1185] return 
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
    .label status = $c2
    // status
    // [1186] cbm_k_readst::status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta status
    // return status;
    // [1188] cbm_k_readst::return#0 = cbm_k_readst::status -- vbuaa=vbuz1 
    // cbm_k_readst::@return
    // }
    // [1189] cbm_k_readst::return#1 = cbm_k_readst::return#0
    // [1190] return 
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
// cbm_k_close(byte zp($7f) channel)
cbm_k_close: {
    .label channel = $7f
    .label status = $c3
    // status
    // [1191] cbm_k_close::status = 0 -- vbuz1=vbuc1 
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
    // [1193] cbm_k_close::return#0 = cbm_k_close::status -- vbuaa=vbuz1 
    // cbm_k_close::@return
    // }
    // [1194] cbm_k_close::return#1 = cbm_k_close::return#0
    // [1195] return 
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
    // [1197] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($e) c)
cputc: {
    .label __16 = $a
    .label conio_screen_text = $6e
    .label conio_map_width = $70
    .label conio_addr = $6e
    .label c = $e
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1199] vera_layer_get_color::layer#0 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [1200] call vera_layer_get_color 
    // [1415] phi from cputc to vera_layer_get_color [phi:cputc->vera_layer_get_color]
    // [1415] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#0 [phi:cputc->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1201] vera_layer_get_color::return#3 = vera_layer_get_color::return#2
    // cputc::@7
    // color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1202] cputc::color#0 = vera_layer_get_color::return#3 -- vbuxx=vbuaa 
    tax
    // conio_screen_text = cx16_conio.conio_screen_text
    // [1203] cputc::conio_screen_text#0 = *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) -- pbuz1=_deref_qbuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z conio_screen_text
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z conio_screen_text+1
    // conio_map_width = cx16_conio.conio_map_width
    // [1204] cputc::conio_map_width#0 = *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH) -- vwuz1=_deref_pwuc1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH
    sta.z conio_map_width
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_MAP_WIDTH+1
    sta.z conio_map_width+1
    // conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [1205] cputc::$15 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // conio_addr = conio_screen_text + conio_line_text[cx16_conio.conio_screen_layer]
    // [1206] cputc::conio_addr#0 = cputc::conio_screen_text#0 + conio_line_text[cputc::$15] -- pbuz1=pbuz1_plus_pwuc1_derefidx_vbuaa 
    tay
    clc
    lda.z conio_addr
    adc conio_line_text,y
    sta.z conio_addr
    lda.z conio_addr+1
    adc conio_line_text+1,y
    sta.z conio_addr+1
    // conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [1207] cputc::$2 = conio_cursor_x[*((byte*)&cx16_conio)] << 1 -- vbuaa=pbuc1_derefidx_(_deref_pbuc2)_rol_1 
    ldy cx16_conio
    lda conio_cursor_x,y
    asl
    // conio_addr += conio_cursor_x[cx16_conio.conio_screen_layer] << 1
    // [1208] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$2 -- pbuz1=pbuz1_plus_vbuaa 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [1209] if(cputc::c#3==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1210] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <conio_addr
    // [1211] cputc::$4 = < cputc::conio_addr#1 -- vbuaa=_lo_pbuz1 
    lda.z conio_addr
    // *VERA_ADDRX_L = <conio_addr
    // [1212] *VERA_ADDRX_L = cputc::$4 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >conio_addr
    // [1213] cputc::$5 = > cputc::conio_addr#1 -- vbuaa=_hi_pbuz1 
    lda.z conio_addr+1
    // *VERA_ADDRX_M = >conio_addr
    // [1214] *VERA_ADDRX_M = cputc::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // cx16_conio.conio_screen_bank | VERA_INC_1
    // [1215] cputc::$6 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_BANK
    // *VERA_ADDRX_H = cx16_conio.conio_screen_bank | VERA_INC_1
    // [1216] *VERA_ADDRX_H = cputc::$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [1217] *VERA_DATA0 = cputc::c#3 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [1218] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // conio_cursor_x[cx16_conio.conio_screen_layer]++;
    // [1219] conio_cursor_x[*((byte*)&cx16_conio)] = ++ conio_cursor_x[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    ldy cx16_conio
    lda conio_cursor_x,x
    inc
    sta conio_cursor_x,y
    // scroll_enable = conio_scroll_enable[cx16_conio.conio_screen_layer]
    // [1220] cputc::scroll_enable#0 = conio_scroll_enable[*((byte*)&cx16_conio)] -- vbuaa=pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_scroll_enable,y
    // if(scroll_enable)
    // [1221] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b5
    // cputc::@3
    // (unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width
    // [1222] cputc::$16 = (word)conio_cursor_x[*((byte*)&cx16_conio)] -- vwuz1=_word_pbuc1_derefidx_(_deref_pbuc2) 
    lda conio_cursor_x,y
    sta.z __16
    lda #0
    sta.z __16+1
    // if((unsigned int)conio_cursor_x[cx16_conio.conio_screen_layer] == conio_map_width)
    // [1223] if(cputc::$16!=cputc::conio_map_width#0) goto cputc::@return -- vwuz1_neq_vwuz2_then_la1 
    cmp.z conio_map_width+1
    bne __breturn
    lda.z __16
    cmp.z conio_map_width
    bne __breturn
    // [1224] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [1225] call cputln 
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [1226] return 
    rts
    // cputc::@5
  __b5:
    // if(conio_cursor_x[cx16_conio.conio_screen_layer] == cx16_conio.conio_screen_width)
    // [1227] if(conio_cursor_x[*((byte*)&cx16_conio)]!=*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto cputc::@return -- pbuc1_derefidx_(_deref_pbuc2)_neq__deref_pbuc3_then_la1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    ldy cx16_conio
    cmp conio_cursor_x,y
    bne __breturn
    // [1228] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [1229] call cputln 
    jsr cputln
    rts
    // [1230] phi from cputc::@7 to cputc::@1 [phi:cputc::@7->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [1231] call cputln 
    jsr cputln
    rts
}
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp($b6) buffer, byte register(Y) radix)
uctoa: {
    .label buffer = $b6
    .label digit = $2e
    .label started = $2f
    .label max_digits = $4b
    .label digit_values = $b9
    // if(radix==DECIMAL)
    // [1232] if(uctoa::radix#0==DECIMAL) goto uctoa::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #DECIMAL
    beq __b2
    // uctoa::@2
    // if(radix==HEXADECIMAL)
    // [1233] if(uctoa::radix#0==HEXADECIMAL) goto uctoa::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #HEXADECIMAL
    beq __b3
    // uctoa::@3
    // if(radix==OCTAL)
    // [1234] if(uctoa::radix#0==OCTAL) goto uctoa::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #OCTAL
    beq __b4
    // uctoa::@4
    // if(radix==BINARY)
    // [1235] if(uctoa::radix#0==BINARY) goto uctoa::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #BINARY
    beq __b5
    // uctoa::@5
    // *buffer++ = 'e'
    // [1236] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS) = 'e' -- _deref_pbuc1=vbuc2 
    // Unknown radix
    lda #'e'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    // [1237] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1) = 'r' -- _deref_pbuc1=vbuc2 
    lda #'r'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    // [1238] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2) = 'r' -- _deref_pbuc1=vbuc2 
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    // [1239] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // uctoa::@return
    // }
    // [1240] return 
    rts
    // [1241] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
  __b2:
    // [1241] phi uctoa::digit_values#8 = RADIX_DECIMAL_VALUES_CHAR [phi:uctoa->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values+1
    // [1241] phi uctoa::max_digits#7 = 3 [phi:uctoa->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #3
    sta.z max_digits
    jmp __b1
    // [1241] phi from uctoa::@2 to uctoa::@1 [phi:uctoa::@2->uctoa::@1]
  __b3:
    // [1241] phi uctoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES_CHAR [phi:uctoa::@2->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values+1
    // [1241] phi uctoa::max_digits#7 = 2 [phi:uctoa::@2->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #2
    sta.z max_digits
    jmp __b1
    // [1241] phi from uctoa::@3 to uctoa::@1 [phi:uctoa::@3->uctoa::@1]
  __b4:
    // [1241] phi uctoa::digit_values#8 = RADIX_OCTAL_VALUES_CHAR [phi:uctoa::@3->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values+1
    // [1241] phi uctoa::max_digits#7 = 3 [phi:uctoa::@3->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #3
    sta.z max_digits
    jmp __b1
    // [1241] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
  __b5:
    // [1241] phi uctoa::digit_values#8 = RADIX_BINARY_VALUES_CHAR [phi:uctoa::@4->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_BINARY_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES_CHAR
    sta.z digit_values+1
    // [1241] phi uctoa::max_digits#7 = 8 [phi:uctoa::@4->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #8
    sta.z max_digits
    // uctoa::@1
  __b1:
    // [1242] phi from uctoa::@1 to uctoa::@6 [phi:uctoa::@1->uctoa::@6]
    // [1242] phi uctoa::buffer#11 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:uctoa::@1->uctoa::@6#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [1242] phi uctoa::started#2 = 0 [phi:uctoa::@1->uctoa::@6#1] -- vbuz1=vbuc1 
    lda #0
    sta.z started
    // [1242] phi uctoa::value#2 = uctoa::value#1 [phi:uctoa::@1->uctoa::@6#2] -- register_copy 
    // [1242] phi uctoa::digit#2 = 0 [phi:uctoa::@1->uctoa::@6#3] -- vbuz1=vbuc1 
    sta.z digit
    // uctoa::@6
  __b6:
    // max_digits-1
    // [1243] uctoa::$4 = uctoa::max_digits#7 - 1 -- vbuaa=vbuz1_minus_1 
    lda.z max_digits
    sec
    sbc #1
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1244] if(uctoa::digit#2<uctoa::$4) goto uctoa::@7 -- vbuz1_lt_vbuaa_then_la1 
    cmp.z digit
    beq !+
    bcs __b7
  !:
    // uctoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [1245] *uctoa::buffer#11 = DIGITS[uctoa::value#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1246] uctoa::buffer#3 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1247] *uctoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    rts
    // uctoa::@7
  __b7:
    // digit_value = digit_values[digit]
    // [1248] uctoa::digit_value#0 = uctoa::digit_values#8[uctoa::digit#2] -- vbuyy=pbuz1_derefidx_vbuz2 
    ldy.z digit
    lda (digit_values),y
    tay
    // if (started || value >= digit_value)
    // [1249] if(0!=uctoa::started#2) goto uctoa::@10 -- 0_neq_vbuz1_then_la1 
    lda.z started
    cmp #0
    bne __b10
    // uctoa::@12
    // [1250] if(uctoa::value#2>=uctoa::digit_value#0) goto uctoa::@10 -- vbuxx_ge_vbuyy_then_la1 
    sty.z $ff
    cpx.z $ff
    bcs __b10
    // [1251] phi from uctoa::@12 to uctoa::@9 [phi:uctoa::@12->uctoa::@9]
    // [1251] phi uctoa::buffer#14 = uctoa::buffer#11 [phi:uctoa::@12->uctoa::@9#0] -- register_copy 
    // [1251] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@12->uctoa::@9#1] -- register_copy 
    // [1251] phi uctoa::value#6 = uctoa::value#2 [phi:uctoa::@12->uctoa::@9#2] -- register_copy 
    // uctoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1252] uctoa::digit#1 = ++ uctoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [1242] phi from uctoa::@9 to uctoa::@6 [phi:uctoa::@9->uctoa::@6]
    // [1242] phi uctoa::buffer#11 = uctoa::buffer#14 [phi:uctoa::@9->uctoa::@6#0] -- register_copy 
    // [1242] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@9->uctoa::@6#1] -- register_copy 
    // [1242] phi uctoa::value#2 = uctoa::value#6 [phi:uctoa::@9->uctoa::@6#2] -- register_copy 
    // [1242] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@9->uctoa::@6#3] -- register_copy 
    jmp __b6
    // uctoa::@10
  __b10:
    // uctoa_append(buffer++, value, digit_value)
    // [1253] uctoa_append::buffer#0 = uctoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z uctoa_append.buffer
    lda.z buffer+1
    sta.z uctoa_append.buffer+1
    // [1254] uctoa_append::value#0 = uctoa::value#2
    // [1255] uctoa_append::sub#0 = uctoa::digit_value#0 -- vbuz1=vbuyy 
    sty.z uctoa_append.sub
    // [1256] call uctoa_append 
    // [1434] phi from uctoa::@10 to uctoa_append [phi:uctoa::@10->uctoa_append]
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // [1257] uctoa_append::return#0 = uctoa_append::value#2
    // uctoa::@11
    // value = uctoa_append(buffer++, value, digit_value)
    // [1258] uctoa::value#0 = uctoa_append::return#0
    // value = uctoa_append(buffer++, value, digit_value);
    // [1259] uctoa::buffer#4 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1251] phi from uctoa::@11 to uctoa::@9 [phi:uctoa::@11->uctoa::@9]
    // [1251] phi uctoa::buffer#14 = uctoa::buffer#4 [phi:uctoa::@11->uctoa::@9#0] -- register_copy 
    // [1251] phi uctoa::started#4 = 1 [phi:uctoa::@11->uctoa::@9#1] -- vbuz1=vbuc1 
    lda #1
    sta.z started
    // [1251] phi uctoa::value#6 = uctoa::value#0 [phi:uctoa::@11->uctoa::@9#2] -- register_copy 
    jmp __b9
}
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte zp($30) buffer_sign, byte register(X) format_min_length, byte zp($6b) format_justify_left, byte zp($72) format_zero_padding, byte zp($31) format_upper_case)
printf_number_buffer: {
    .label __19 = $70
    .label buffer_sign = $30
    .label padding = $32
    .label format_zero_padding = $72
    .label format_justify_left = $6b
    .label format_upper_case = $31
    // if(format.min_length)
    // [1261] if(0==printf_number_buffer::format_min_length#3) goto printf_number_buffer::@1 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq __b6
    // [1262] phi from printf_number_buffer to printf_number_buffer::@6 [phi:printf_number_buffer->printf_number_buffer::@6]
    // printf_number_buffer::@6
    // strlen(buffer.digits)
    // [1263] call strlen 
    // [1409] phi from printf_number_buffer::@6 to strlen [phi:printf_number_buffer::@6->strlen]
    // [1409] phi strlen::str#5 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:printf_number_buffer::@6->strlen#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z strlen.str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z strlen.str+1
    jsr strlen
    // strlen(buffer.digits)
    // [1264] strlen::return#3 = strlen::len#2
    // printf_number_buffer::@14
    // [1265] printf_number_buffer::$19 = strlen::return#3
    // len = (signed char)strlen(buffer.digits)
    // [1266] printf_number_buffer::len#0 = (signed byte)printf_number_buffer::$19 -- vbsyy=_sbyte_vwuz1 
    // There is a minimum length - work out the padding
    ldy.z __19
    // if(buffer.sign)
    // [1267] if(0==printf_number_buffer::buffer_sign#10) goto printf_number_buffer::@13 -- 0_eq_vbuz1_then_la1 
    lda.z buffer_sign
    cmp #0
    beq __b13
    // printf_number_buffer::@7
    // len++;
    // [1268] printf_number_buffer::len#1 = ++ printf_number_buffer::len#0 -- vbsyy=_inc_vbsyy 
    iny
    // [1269] phi from printf_number_buffer::@14 printf_number_buffer::@7 to printf_number_buffer::@13 [phi:printf_number_buffer::@14/printf_number_buffer::@7->printf_number_buffer::@13]
    // [1269] phi printf_number_buffer::len#2 = printf_number_buffer::len#0 [phi:printf_number_buffer::@14/printf_number_buffer::@7->printf_number_buffer::@13#0] -- register_copy 
    // printf_number_buffer::@13
  __b13:
    // padding = (signed char)format.min_length - len
    // [1270] printf_number_buffer::padding#1 = (signed byte)printf_number_buffer::format_min_length#3 - printf_number_buffer::len#2 -- vbsz1=vbsxx_minus_vbsyy 
    txa
    sty.z $ff
    sec
    sbc.z $ff
    sta.z padding
    // if(padding<0)
    // [1271] if(printf_number_buffer::padding#1>=0) goto printf_number_buffer::@21 -- vbsz1_ge_0_then_la1 
    cmp #0
    bpl __b1
    // [1273] phi from printf_number_buffer printf_number_buffer::@13 to printf_number_buffer::@1 [phi:printf_number_buffer/printf_number_buffer::@13->printf_number_buffer::@1]
  __b6:
    // [1273] phi printf_number_buffer::padding#10 = 0 [phi:printf_number_buffer/printf_number_buffer::@13->printf_number_buffer::@1#0] -- vbsz1=vbsc1 
    lda #0
    sta.z padding
    // [1272] phi from printf_number_buffer::@13 to printf_number_buffer::@21 [phi:printf_number_buffer::@13->printf_number_buffer::@21]
    // printf_number_buffer::@21
    // [1273] phi from printf_number_buffer::@21 to printf_number_buffer::@1 [phi:printf_number_buffer::@21->printf_number_buffer::@1]
    // [1273] phi printf_number_buffer::padding#10 = printf_number_buffer::padding#1 [phi:printf_number_buffer::@21->printf_number_buffer::@1#0] -- register_copy 
    // printf_number_buffer::@1
  __b1:
    // if(!format.justify_left && !format.zero_padding && padding)
    // [1274] if(0!=printf_number_buffer::format_justify_left#10) goto printf_number_buffer::@2 -- 0_neq_vbuz1_then_la1 
    lda.z format_justify_left
    cmp #0
    bne __b2
    // printf_number_buffer::@17
    // [1275] if(0!=printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@2 -- 0_neq_vbuz1_then_la1 
    lda.z format_zero_padding
    cmp #0
    bne __b2
    // printf_number_buffer::@16
    // [1276] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@8 -- 0_neq_vbsz1_then_la1 
    lda.z padding
    cmp #0
    bne __b8
    jmp __b2
    // printf_number_buffer::@8
  __b8:
    // printf_padding(' ',(char)padding)
    // [1277] printf_padding::length#0 = (byte)printf_number_buffer::padding#10 -- vbuz1=vbuz2 
    lda.z padding
    sta.z printf_padding.length
    // [1278] call printf_padding 
    // [1441] phi from printf_number_buffer::@8 to printf_padding [phi:printf_number_buffer::@8->printf_padding]
    // [1441] phi printf_padding::pad#5 = ' ' [phi:printf_number_buffer::@8->printf_padding#0] -- vbuz1=vbuc1 
    lda #' '
    sta.z printf_padding.pad
    // [1441] phi printf_padding::length#4 = printf_padding::length#0 [phi:printf_number_buffer::@8->printf_padding#1] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@2
  __b2:
    // if(buffer.sign)
    // [1279] if(0==printf_number_buffer::buffer_sign#10) goto printf_number_buffer::@3 -- 0_eq_vbuz1_then_la1 
    lda.z buffer_sign
    cmp #0
    beq __b3
    // printf_number_buffer::@9
    // cputc(buffer.sign)
    // [1280] cputc::c#2 = printf_number_buffer::buffer_sign#10 -- vbuz1=vbuz2 
    sta.z cputc.c
    // [1281] call cputc 
    // [1198] phi from printf_number_buffer::@9 to cputc [phi:printf_number_buffer::@9->cputc]
    // [1198] phi cputc::c#3 = cputc::c#2 [phi:printf_number_buffer::@9->cputc#0] -- register_copy 
    jsr cputc
    // printf_number_buffer::@3
  __b3:
    // if(format.zero_padding && padding)
    // [1282] if(0==printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@4 -- 0_eq_vbuz1_then_la1 
    lda.z format_zero_padding
    cmp #0
    beq __b4
    // printf_number_buffer::@18
    // [1283] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@10 -- 0_neq_vbsz1_then_la1 
    lda.z padding
    cmp #0
    bne __b10
    jmp __b4
    // printf_number_buffer::@10
  __b10:
    // printf_padding('0',(char)padding)
    // [1284] printf_padding::length#1 = (byte)printf_number_buffer::padding#10 -- vbuz1=vbuz2 
    lda.z padding
    sta.z printf_padding.length
    // [1285] call printf_padding 
    // [1441] phi from printf_number_buffer::@10 to printf_padding [phi:printf_number_buffer::@10->printf_padding]
    // [1441] phi printf_padding::pad#5 = '0' [phi:printf_number_buffer::@10->printf_padding#0] -- vbuz1=vbuc1 
    lda #'0'
    sta.z printf_padding.pad
    // [1441] phi printf_padding::length#4 = printf_padding::length#1 [phi:printf_number_buffer::@10->printf_padding#1] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@4
  __b4:
    // if(format.upper_case)
    // [1286] if(0==printf_number_buffer::format_upper_case#10) goto printf_number_buffer::@5 -- 0_eq_vbuz1_then_la1 
    lda.z format_upper_case
    cmp #0
    beq __b5
    // [1287] phi from printf_number_buffer::@4 to printf_number_buffer::@11 [phi:printf_number_buffer::@4->printf_number_buffer::@11]
    // printf_number_buffer::@11
    // strupr(buffer.digits)
    // [1288] call strupr 
    // [1448] phi from printf_number_buffer::@11 to strupr [phi:printf_number_buffer::@11->strupr]
    jsr strupr
    // [1289] phi from printf_number_buffer::@11 printf_number_buffer::@4 to printf_number_buffer::@5 [phi:printf_number_buffer::@11/printf_number_buffer::@4->printf_number_buffer::@5]
    // printf_number_buffer::@5
  __b5:
    // cputs(buffer.digits)
    // [1290] call cputs 
    // [528] phi from printf_number_buffer::@5 to cputs [phi:printf_number_buffer::@5->cputs]
    // [528] phi cputs::s#19 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:printf_number_buffer::@5->cputs#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z cputs.s+1
    jsr cputs
    // printf_number_buffer::@15
    // if(format.justify_left && !format.zero_padding && padding)
    // [1291] if(0==printf_number_buffer::format_justify_left#10) goto printf_number_buffer::@return -- 0_eq_vbuz1_then_la1 
    lda.z format_justify_left
    cmp #0
    beq __breturn
    // printf_number_buffer::@20
    // [1292] if(0!=printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@return -- 0_neq_vbuz1_then_la1 
    lda.z format_zero_padding
    cmp #0
    bne __breturn
    // printf_number_buffer::@19
    // [1293] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@12 -- 0_neq_vbsz1_then_la1 
    lda.z padding
    cmp #0
    bne __b12
    rts
    // printf_number_buffer::@12
  __b12:
    // printf_padding(' ',(char)padding)
    // [1294] printf_padding::length#2 = (byte)printf_number_buffer::padding#10 -- vbuz1=vbuz2 
    lda.z padding
    sta.z printf_padding.length
    // [1295] call printf_padding 
    // [1441] phi from printf_number_buffer::@12 to printf_padding [phi:printf_number_buffer::@12->printf_padding]
    // [1441] phi printf_padding::pad#5 = ' ' [phi:printf_number_buffer::@12->printf_padding#0] -- vbuz1=vbuc1 
    lda #' '
    sta.z printf_padding.pad
    // [1441] phi printf_padding::length#4 = printf_padding::length#2 [phi:printf_number_buffer::@12->printf_padding#1] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@return
  __breturn:
    // }
    // [1296] return 
    rts
}
  // vera_heap_block_free_find
// vera_heap_block_free_find(struct vera_heap_segment* zp($b0) segment, dword zp($cd) size)
vera_heap_block_free_find: {
    .label __0 = $c5
    .label __2 = $c7
    .label block = $b0
    .label return = $b0
    .label segment = $b0
    .label size = $cd
    // block = segment->head_block
    // [1297] vera_heap_block_free_find::block#0 = ((struct vera_heap**)vera_heap_block_free_find::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK] -- pssz1=qssz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SEGMENT_HEAD_BLOCK
    lda (block),y
    pha
    iny
    lda (block),y
    sta.z block+1
    pla
    sta.z block
    // [1298] phi from vera_heap_block_free_find vera_heap_block_free_find::@3 to vera_heap_block_free_find::@1 [phi:vera_heap_block_free_find/vera_heap_block_free_find::@3->vera_heap_block_free_find::@1]
    // [1298] phi vera_heap_block_free_find::block#2 = vera_heap_block_free_find::block#0 [phi:vera_heap_block_free_find/vera_heap_block_free_find::@3->vera_heap_block_free_find::@1#0] -- register_copy 
    // vera_heap_block_free_find::@1
  __b1:
    // while(block)
    // [1299] if((struct vera_heap*)0!=vera_heap_block_free_find::block#2) goto vera_heap_block_free_find::@2 -- pssc1_neq_pssz1_then_la1 
    lda.z block+1
    cmp #>0
    bne __b2
    lda.z block
    cmp #<0
    bne __b2
    // [1300] phi from vera_heap_block_free_find::@1 to vera_heap_block_free_find::@return [phi:vera_heap_block_free_find::@1->vera_heap_block_free_find::@return]
    // [1300] phi vera_heap_block_free_find::return#2 = (struct vera_heap*) 0 [phi:vera_heap_block_free_find::@1->vera_heap_block_free_find::@return#0] -- pssz1=pssc1 
    lda #<0
    sta.z return
    sta.z return+1
    // vera_heap_block_free_find::@return
    // }
    // [1301] return 
    rts
    // vera_heap_block_free_find::@2
  __b2:
    // vera_heap_block_is_empty(block)
    // [1302] vera_heap_block_is_empty::block#0 = vera_heap_block_free_find::block#2
    // [1303] call vera_heap_block_is_empty 
    jsr vera_heap_block_is_empty
    // [1304] vera_heap_block_is_empty::return#2 = vera_heap_block_is_empty::return#0
    // vera_heap_block_free_find::@5
    // [1305] vera_heap_block_free_find::$0 = vera_heap_block_is_empty::return#2
    // if(vera_heap_block_is_empty(block))
    // [1306] if(0==vera_heap_block_free_find::$0) goto vera_heap_block_free_find::@3 -- 0_eq_vwuz1_then_la1 
    lda.z __0
    ora.z __0+1
    beq __b3
    // vera_heap_block_free_find::@4
    // vera_heap_block_size_get(block)
    // [1307] vera_heap_block_size_get::block#0 = vera_heap_block_free_find::block#2 -- pssz1=pssz2 
    lda.z block
    sta.z vera_heap_block_size_get.block
    lda.z block+1
    sta.z vera_heap_block_size_get.block+1
    // [1308] call vera_heap_block_size_get 
    jsr vera_heap_block_size_get
    // [1309] vera_heap_block_size_get::return#2 = vera_heap_block_size_get::return#0
    // vera_heap_block_free_find::@6
    // [1310] vera_heap_block_free_find::$2 = vera_heap_block_size_get::return#2
    // if(size==vera_heap_block_size_get(block))
    // [1311] if(vera_heap_block_free_find::size#0!=vera_heap_block_free_find::$2) goto vera_heap_block_free_find::@3 -- vduz1_neq_vduz2_then_la1 
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
    // [1300] phi from vera_heap_block_free_find::@6 to vera_heap_block_free_find::@return [phi:vera_heap_block_free_find::@6->vera_heap_block_free_find::@return]
    // [1300] phi vera_heap_block_free_find::return#2 = vera_heap_block_free_find::block#2 [phi:vera_heap_block_free_find::@6->vera_heap_block_free_find::@return#0] -- register_copy 
    rts
    // vera_heap_block_free_find::@3
  __b3:
    // block = block->next
    // [1312] vera_heap_block_free_find::block#1 = ((struct vera_heap**)vera_heap_block_free_find::block#2)[OFFSET_STRUCT_VERA_HEAP_NEXT] -- pssz1=qssz1_derefidx_vbuc1 
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
// vera_heap_block_empty_set(struct vera_heap* zp($bb) block)
vera_heap_block_empty_set: {
    .label __1 = $b2
    .label __4 = $c5
    .label block = $bb
    // (block->size & ~VERA_HEAP_EMPTY) | empty
    // [1314] vera_heap_block_empty_set::$1 = ((word*)vera_heap_block_empty_set::block#2)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_EMPTY -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_EMPTY^$ffff
    sta.z __1
    iny
    lda (block),y
    and #>VERA_HEAP_EMPTY^$ffff
    sta.z __1+1
    // (block->size & ~VERA_HEAP_EMPTY) | empty?VERA_HEAP_EMPTY:0
    // [1315] if(0!=vera_heap_block_empty_set::$1) goto vera_heap_block_empty_set::@1 -- 0_neq_vwuz1_then_la1 
    lda.z __1
    ora.z __1+1
    bne __b1
    // [1317] phi from vera_heap_block_empty_set to vera_heap_block_empty_set::@2 [phi:vera_heap_block_empty_set->vera_heap_block_empty_set::@2]
    // [1317] phi vera_heap_block_empty_set::$4 = 0 [phi:vera_heap_block_empty_set->vera_heap_block_empty_set::@2#0] -- vwuz1=vbuc1 
    lda #<0
    sta.z __4
    sta.z __4+1
    jmp __b2
    // [1316] phi from vera_heap_block_empty_set to vera_heap_block_empty_set::@1 [phi:vera_heap_block_empty_set->vera_heap_block_empty_set::@1]
    // vera_heap_block_empty_set::@1
  __b1:
    // (block->size & ~VERA_HEAP_EMPTY) | empty?VERA_HEAP_EMPTY:0
    // [1317] phi from vera_heap_block_empty_set::@1 to vera_heap_block_empty_set::@2 [phi:vera_heap_block_empty_set::@1->vera_heap_block_empty_set::@2]
    // [1317] phi vera_heap_block_empty_set::$4 = VERA_HEAP_EMPTY [phi:vera_heap_block_empty_set::@1->vera_heap_block_empty_set::@2#0] -- vwuz1=vwuc1 
    lda #<VERA_HEAP_EMPTY
    sta.z __4
    lda #>VERA_HEAP_EMPTY
    sta.z __4+1
    // vera_heap_block_empty_set::@2
  __b2:
    // block->size = (block->size & ~VERA_HEAP_EMPTY) | empty?VERA_HEAP_EMPTY:0
    // [1318] ((word*)vera_heap_block_empty_set::block#2)[OFFSET_STRUCT_VERA_HEAP_SIZE] = vera_heap_block_empty_set::$4 -- pwuz1_derefidx_vbuc1=vwuz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda.z __4
    sta (block),y
    iny
    lda.z __4+1
    sta (block),y
    // vera_heap_block_empty_set::@return
    // }
    // [1319] return 
    rts
}
  // vera_heap_block_address_get
// vera_heap_block_address_get(struct vera_heap* zp($b0) block)
vera_heap_block_address_get: {
    .label __0 = $b2
    .label __9 = $c7
    .label return = $17
    .label block = $b0
    .label __11 = $17
    // block->size & VERA_HEAP_ADDRESS_16
    // [1320] vera_heap_block_address_get::$0 = ((word*)vera_heap_block_address_get::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & VERA_HEAP_ADDRESS_16 -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_ADDRESS_16
    sta.z __0
    iny
    lda (block),y
    and #>VERA_HEAP_ADDRESS_16
    sta.z __0+1
    // (block->size & VERA_HEAP_ADDRESS_16)?0x10000:0x00000
    // [1321] if(0!=vera_heap_block_address_get::$0) goto vera_heap_block_address_get::@1 -- 0_neq_vwuz1_then_la1 
    lda.z __0
    ora.z __0+1
    bne __b1
    // [1323] phi from vera_heap_block_address_get to vera_heap_block_address_get::@2 [phi:vera_heap_block_address_get->vera_heap_block_address_get::@2]
    // [1323] phi vera_heap_block_address_get::$11 = 0 [phi:vera_heap_block_address_get->vera_heap_block_address_get::@2#0] -- vduz1=vbuc1 
    lda #0
    sta.z __11
    sta.z __11+1
    sta.z __11+2
    sta.z __11+3
    jmp __b2
    // [1322] phi from vera_heap_block_address_get to vera_heap_block_address_get::@1 [phi:vera_heap_block_address_get->vera_heap_block_address_get::@1]
    // vera_heap_block_address_get::@1
  __b1:
    // (block->size & VERA_HEAP_ADDRESS_16)?0x10000:0x00000
    // [1323] phi from vera_heap_block_address_get::@1 to vera_heap_block_address_get::@2 [phi:vera_heap_block_address_get::@1->vera_heap_block_address_get::@2]
    // [1323] phi vera_heap_block_address_get::$11 = $10000 [phi:vera_heap_block_address_get::@1->vera_heap_block_address_get::@2#0] -- vduz1=vduc1 
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
    // [1324] vera_heap_block_address_get::$9 = (dword)*((word*)vera_heap_block_address_get::block#0) -- vduz1=_dword__deref_pwuz2 
    ldy #0
    sty.z __9+2
    sty.z __9+3
    lda (block),y
    sta.z __9
    iny
    lda (block),y
    sta.z __9+1
    // [1325] vera_heap_block_address_get::return#0 = vera_heap_block_address_get::$9 | vera_heap_block_address_get::$11 -- vduz1=vduz2_bor_vduz1 
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
    // [1326] return 
    rts
}
  // vera_heap_address
// vera_heap_address(struct vera_heap_segment* zp($c5) segment, dword zp($cd) size)
vera_heap_address: {
    .label last_address = $33
    .label next_address = $cd
    .label ceil_address = $c7
    .label return = $33
    .label segment = $c5
    .label size = $cd
    // last_address = segment->next_address
    // [1327] vera_heap_address::last_address#0 = ((dword*)vera_heap_address::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
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
    // [1328] vera_heap_address::next_address#0 = vera_heap_address::last_address#0 + vera_heap_address::size#0 -- vduz1=vduz2_plus_vduz1 
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
    // [1329] vera_heap_address::ceil_address#0 = ((dword*)vera_heap_address::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_CEIL_ADDRESS] -- vduz1=pduz2_derefidx_vbuc1 
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
    // [1330] if(vera_heap_address::next_address#0<=vera_heap_address::ceil_address#0) goto vera_heap_address::@1 -- vduz1_le_vduz2_then_la1 
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
    // [1332] phi from vera_heap_address to vera_heap_address::@return [phi:vera_heap_address->vera_heap_address::@return]
    // [1332] phi vera_heap_address::return#2 = 0 [phi:vera_heap_address->vera_heap_address::@return#0] -- vduz1=vbuc1 
    lda #0
    sta.z return
    sta.z return+1
    sta.z return+2
    sta.z return+3
    rts
    // vera_heap_address::@1
  __b1:
    // segment->next_address = next_address
    // [1331] ((dword*)vera_heap_address::segment#0)[OFFSET_STRUCT_VERA_HEAP_SEGMENT_NEXT_ADDRESS] = vera_heap_address::next_address#0 -- pduz1_derefidx_vbuc1=vduz2 
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
    // [1332] phi from vera_heap_address::@1 to vera_heap_address::@return [phi:vera_heap_address::@1->vera_heap_address::@return]
    // [1332] phi vera_heap_address::return#2 = vera_heap_address::last_address#0 [phi:vera_heap_address::@1->vera_heap_address::@return#0] -- register_copy 
    // vera_heap_address::@return
    // }
    // [1333] return 
    rts
}
  // vera_heap_block_address_set
// vera_heap_block_address_set(struct vera_heap* zp($c5) block)
vera_heap_block_address_set: {
    .label address = vera_heap_malloc.address
    .label __2 = $b0
    .label __3 = $b4
    .label __6 = $b4
    .label addr = $c7
    .label ad_lo = $b0
    .label ad_hi = $b4
    .label block = $c5
    // addr = *address
    // [1334] vera_heap_block_address_set::addr#0 = *vera_heap_block_address_set::address#0 -- vduz1=_deref_pduc1 
    lda.z address
    sta.z addr
    lda.z address+1
    sta.z addr+1
    lda.z address+2
    sta.z addr+2
    lda.z address+3
    sta.z addr+3
    // ad_lo = <(addr)
    // [1335] vera_heap_block_address_set::ad_lo#0 = < vera_heap_block_address_set::addr#0 -- vwuz1=_lo_vduz2 
    lda.z addr
    sta.z ad_lo
    lda.z addr+1
    sta.z ad_lo+1
    // ad_hi = >(addr)
    // [1336] vera_heap_block_address_set::ad_hi#0 = > vera_heap_block_address_set::addr#0 -- vwuz1=_hi_vduz2 
    lda.z addr+2
    sta.z ad_hi
    lda.z addr+3
    sta.z ad_hi+1
    // block->address = ad_lo
    // [1337] *((word*)vera_heap_block_address_set::block#0) = vera_heap_block_address_set::ad_lo#0 -- _deref_pwuz1=vwuz2 
    ldy #0
    lda.z ad_lo
    sta (block),y
    iny
    lda.z ad_lo+1
    sta (block),y
    // block->size & ~VERA_HEAP_ADDRESS_16
    // [1338] vera_heap_block_address_set::$2 = ((word*)vera_heap_block_address_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_ADDRESS_16 -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_ADDRESS_16^$ffff
    sta.z __2
    iny
    lda (block),y
    and #>VERA_HEAP_ADDRESS_16^$ffff
    sta.z __2+1
    // (block->size & ~VERA_HEAP_ADDRESS_16) | ad_hi
    // [1339] vera_heap_block_address_set::$3 = vera_heap_block_address_set::$2 | vera_heap_block_address_set::ad_hi#0 -- vwuz1=vwuz2_bor_vwuz1 
    lda.z __3
    ora.z __2
    sta.z __3
    lda.z __3+1
    ora.z __2+1
    sta.z __3+1
    // (block->size & ~VERA_HEAP_ADDRESS_16) | ad_hi?VERA_HEAP_ADDRESS_16:0
    // [1340] if(0!=vera_heap_block_address_set::$3) goto vera_heap_block_address_set::@1 -- 0_neq_vwuz1_then_la1 
    lda.z __3
    ora.z __3+1
    bne __b1
    // [1342] phi from vera_heap_block_address_set to vera_heap_block_address_set::@2 [phi:vera_heap_block_address_set->vera_heap_block_address_set::@2]
    // [1342] phi vera_heap_block_address_set::$6 = 0 [phi:vera_heap_block_address_set->vera_heap_block_address_set::@2#0] -- vwuz1=vbuc1 
    lda #<0
    sta.z __6
    sta.z __6+1
    jmp __b2
    // [1341] phi from vera_heap_block_address_set to vera_heap_block_address_set::@1 [phi:vera_heap_block_address_set->vera_heap_block_address_set::@1]
    // vera_heap_block_address_set::@1
  __b1:
    // (block->size & ~VERA_HEAP_ADDRESS_16) | ad_hi?VERA_HEAP_ADDRESS_16:0
    // [1342] phi from vera_heap_block_address_set::@1 to vera_heap_block_address_set::@2 [phi:vera_heap_block_address_set::@1->vera_heap_block_address_set::@2]
    // [1342] phi vera_heap_block_address_set::$6 = VERA_HEAP_ADDRESS_16 [phi:vera_heap_block_address_set::@1->vera_heap_block_address_set::@2#0] -- vwuz1=vwuc1 
    lda #<VERA_HEAP_ADDRESS_16
    sta.z __6
    lda #>VERA_HEAP_ADDRESS_16
    sta.z __6+1
    // vera_heap_block_address_set::@2
  __b2:
    // block->size = (block->size & ~VERA_HEAP_ADDRESS_16) | ad_hi?VERA_HEAP_ADDRESS_16:0
    // [1343] ((word*)vera_heap_block_address_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] = vera_heap_block_address_set::$6 -- pwuz1_derefidx_vbuc1=vwuz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda.z __6
    sta (block),y
    iny
    lda.z __6+1
    sta (block),y
    // vera_heap_block_address_set::@return
    // }
    // [1344] return 
    rts
}
  // vera_heap_block_size_set
// vera_heap_block_size_set(struct vera_heap* zp($c5) block)
vera_heap_block_size_set: {
    .label size = vera_heap_malloc.size
    .label __2 = $cb
    .label __3 = $b4
    .label __4 = $cb
    .label __5 = $b2
    .label __6 = $b0
    .label __9 = $b4
    .label sz = $cd
    .label sz_lo = $b4
    .label sz_hi = $b0
    .label block = $c5
    // sz = *size
    // [1345] vera_heap_block_size_set::sz#0 = *vera_heap_block_size_set::size#0 -- vduz1=_deref_pduc1 
    lda.z size
    sta.z sz
    lda.z size+1
    sta.z sz+1
    lda.z size+2
    sta.z sz+2
    lda.z size+3
    sta.z sz+3
    // sz_lo = <sz
    // [1346] vera_heap_block_size_set::sz_lo#0 = < vera_heap_block_size_set::sz#0 -- vwuz1=_lo_vduz2 
    lda.z sz
    sta.z sz_lo
    lda.z sz+1
    sta.z sz_lo+1
    // sz_hi = >sz
    // [1347] vera_heap_block_size_set::sz_hi#0 = > vera_heap_block_size_set::sz#0 -- vwuz1=_hi_vduz2 
    lda.z sz+2
    sta.z sz_hi
    lda.z sz+3
    sta.z sz_hi+1
    // block->size & ~VERA_HEAP_SIZE_MASK
    // [1348] vera_heap_block_size_set::$2 = ((word*)vera_heap_block_size_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_SIZE_MASK -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_SIZE_MASK^$ffff
    sta.z __2
    iny
    lda (block),y
    and #>VERA_HEAP_SIZE_MASK^$ffff
    sta.z __2+1
    // sz_lo & VERA_HEAP_SIZE_MASK
    // [1349] vera_heap_block_size_set::$3 = vera_heap_block_size_set::sz_lo#0 & VERA_HEAP_SIZE_MASK -- vwuz1=vwuz1_band_vwuc1 
    lda.z __3
    and #<VERA_HEAP_SIZE_MASK
    sta.z __3
    lda.z __3+1
    and #>VERA_HEAP_SIZE_MASK
    sta.z __3+1
    // (block->size & ~VERA_HEAP_SIZE_MASK) | sz_lo & VERA_HEAP_SIZE_MASK
    // [1350] vera_heap_block_size_set::$4 = vera_heap_block_size_set::$2 | vera_heap_block_size_set::$3 -- vwuz1=vwuz1_bor_vwuz2 
    lda.z __4
    ora.z __3
    sta.z __4
    lda.z __4+1
    ora.z __3+1
    sta.z __4+1
    // block->size = (block->size & ~VERA_HEAP_SIZE_MASK) | sz_lo & VERA_HEAP_SIZE_MASK
    // [1351] ((word*)vera_heap_block_size_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] = vera_heap_block_size_set::$4 -- pwuz1_derefidx_vbuc1=vwuz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda.z __4
    sta (block),y
    iny
    lda.z __4+1
    sta (block),y
    // block->size & ~VERA_HEAP_SIZE_16
    // [1352] vera_heap_block_size_set::$5 = ((word*)vera_heap_block_size_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_SIZE_16 -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_SIZE_16^$ffff
    sta.z __5
    iny
    lda (block),y
    and #>VERA_HEAP_SIZE_16^$ffff
    sta.z __5+1
    // (block->size & ~VERA_HEAP_SIZE_16) | sz_hi
    // [1353] vera_heap_block_size_set::$6 = vera_heap_block_size_set::$5 | vera_heap_block_size_set::sz_hi#0 -- vwuz1=vwuz2_bor_vwuz1 
    lda.z __6
    ora.z __5
    sta.z __6
    lda.z __6+1
    ora.z __5+1
    sta.z __6+1
    // (block->size & ~VERA_HEAP_SIZE_16) | sz_hi?VERA_HEAP_SIZE_16:0
    // [1354] if(0!=vera_heap_block_size_set::$6) goto vera_heap_block_size_set::@1 -- 0_neq_vwuz1_then_la1 
    lda.z __6
    ora.z __6+1
    bne __b1
    // [1356] phi from vera_heap_block_size_set to vera_heap_block_size_set::@2 [phi:vera_heap_block_size_set->vera_heap_block_size_set::@2]
    // [1356] phi vera_heap_block_size_set::$9 = 0 [phi:vera_heap_block_size_set->vera_heap_block_size_set::@2#0] -- vwuz1=vbuc1 
    lda #<0
    sta.z __9
    sta.z __9+1
    jmp __b2
    // [1355] phi from vera_heap_block_size_set to vera_heap_block_size_set::@1 [phi:vera_heap_block_size_set->vera_heap_block_size_set::@1]
    // vera_heap_block_size_set::@1
  __b1:
    // (block->size & ~VERA_HEAP_SIZE_16) | sz_hi?VERA_HEAP_SIZE_16:0
    // [1356] phi from vera_heap_block_size_set::@1 to vera_heap_block_size_set::@2 [phi:vera_heap_block_size_set::@1->vera_heap_block_size_set::@2]
    // [1356] phi vera_heap_block_size_set::$9 = VERA_HEAP_SIZE_16 [phi:vera_heap_block_size_set::@1->vera_heap_block_size_set::@2#0] -- vwuz1=vwuc1 
    lda #<VERA_HEAP_SIZE_16
    sta.z __9
    lda #>VERA_HEAP_SIZE_16
    sta.z __9+1
    // vera_heap_block_size_set::@2
  __b2:
    // block->size = (block->size & ~VERA_HEAP_SIZE_16) | sz_hi?VERA_HEAP_SIZE_16:0
    // [1357] ((word*)vera_heap_block_size_set::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] = vera_heap_block_size_set::$9 -- pwuz1_derefidx_vbuc1=vwuz2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda.z __9
    sta (block),y
    iny
    lda.z __9+1
    sta (block),y
    // vera_heap_block_size_set::@return
    // }
    // [1358] return 
    rts
}
  // vera_layer_set_config
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
// vera_layer_set_config(byte register(A) layer, byte register(X) config)
vera_layer_set_config: {
    .label addr = $73
    // addr = vera_layer_config[layer]
    // [1359] vera_layer_set_config::$0 = vera_layer_set_config::layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [1360] vera_layer_set_config::addr#0 = vera_layer_config[vera_layer_set_config::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr = config
    // [1361] *vera_layer_set_config::addr#0 = vera_layer_set_config::config#0 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_config::@return
    // }
    // [1362] return 
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
    .label addr = $73
    // addr = vera_layer_tilebase[layer]
    // [1363] vera_layer_set_tilebase::$0 = vera_layer_set_tilebase::layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [1364] vera_layer_set_tilebase::addr#0 = vera_layer_tilebase[vera_layer_set_tilebase::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_tilebase,y
    sta.z addr
    lda vera_layer_tilebase+1,y
    sta.z addr+1
    // *addr = tilebase
    // [1365] *vera_layer_set_tilebase::addr#0 = vera_layer_set_tilebase::tilebase#0 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_tilebase::@return
    // }
    // [1366] return 
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
    // [1367] vera_layer_get_backcolor::return#0 = vera_layer_backcolor[vera_layer_get_backcolor::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_backcolor,x
    // vera_layer_get_backcolor::@return
    // }
    // [1368] return 
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
    // [1369] vera_layer_get_textcolor::return#0 = vera_layer_textcolor[vera_layer_get_textcolor::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_textcolor,x
    // vera_layer_get_textcolor::@return
    // }
    // [1370] return 
    rts
}
  // printf_ulong
// Print an unsigned int using a specific format
// printf_ulong(dword zp($c7) uvalue)
printf_ulong: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
    .label uvalue = $c7
    // printf_ulong::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [1372] *((byte*)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // ultoa(uvalue, printf_buffer.digits, format.radix)
    // [1373] ultoa::value#1 = printf_ulong::uvalue#0
    // [1374] call ultoa 
  // Format number into buffer
    // [1466] phi from printf_ulong::@1 to ultoa [phi:printf_ulong::@1->ultoa]
    jsr ultoa
    // printf_ulong::@2
    // printf_number_buffer(printf_buffer, format)
    // [1375] printf_number_buffer::buffer_sign#0 = *((byte*)&printf_buffer) -- vbuz1=_deref_pbuc1 
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
    // [1376] call printf_number_buffer 
  // Print using format
    // [1260] phi from printf_ulong::@2 to printf_number_buffer [phi:printf_ulong::@2->printf_number_buffer]
    // [1260] phi printf_number_buffer::format_upper_case#10 = printf_ulong::format_upper_case#0 [phi:printf_ulong::@2->printf_number_buffer#0] -- vbuz1=vbuc1 
    lda #format_upper_case
    sta.z printf_number_buffer.format_upper_case
    // [1260] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#0 [phi:printf_ulong::@2->printf_number_buffer#1] -- register_copy 
    // [1260] phi printf_number_buffer::format_zero_padding#10 = printf_ulong::format_zero_padding#0 [phi:printf_ulong::@2->printf_number_buffer#2] -- vbuz1=vbuc1 
    lda #format_zero_padding
    sta.z printf_number_buffer.format_zero_padding
    // [1260] phi printf_number_buffer::format_justify_left#10 = printf_ulong::format_justify_left#0 [phi:printf_ulong::@2->printf_number_buffer#3] -- vbuz1=vbuc1 
    lda #format_justify_left
    sta.z printf_number_buffer.format_justify_left
    // [1260] phi printf_number_buffer::format_min_length#3 = printf_ulong::format_min_length#0 [phi:printf_ulong::@2->printf_number_buffer#4] -- vbuxx=vbuc1 
    ldx #format_min_length
    jsr printf_number_buffer
    // printf_ulong::@return
    // }
    // [1377] return 
    rts
}
  // mul16u
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// mul16u(word zp($b0) a, word zp($b9) b)
mul16u: {
    .label mb = $cd
    .label a = $b0
    .label res = $54
    .label b = $b9
    .label return = $54
    // mb = b
    // [1378] mul16u::mb#0 = (dword)mul16u::b#0 -- vduz1=_dword_vwuz2 
    lda.z b
    sta.z mb
    lda.z b+1
    sta.z mb+1
    lda #0
    sta.z mb+2
    sta.z mb+3
    // [1379] phi from mul16u to mul16u::@1 [phi:mul16u->mul16u::@1]
    // [1379] phi mul16u::mb#2 = mul16u::mb#0 [phi:mul16u->mul16u::@1#0] -- register_copy 
    // [1379] phi mul16u::res#2 = 0 [phi:mul16u->mul16u::@1#1] -- vduz1=vduc1 
    sta.z res
    sta.z res+1
    lda #<0>>$10
    sta.z res+2
    lda #>0>>$10
    sta.z res+3
    // [1379] phi mul16u::a#2 = mul16u::a#1 [phi:mul16u->mul16u::@1#2] -- register_copy 
    // mul16u::@1
  __b1:
    // while(a!=0)
    // [1380] if(mul16u::a#2!=0) goto mul16u::@2 -- vwuz1_neq_0_then_la1 
    lda.z a
    ora.z a+1
    bne __b2
    // mul16u::@return
    // }
    // [1381] return 
    rts
    // mul16u::@2
  __b2:
    // a&1
    // [1382] mul16u::$1 = mul16u::a#2 & 1 -- vbuaa=vwuz1_band_vbuc1 
    lda #1
    and.z a
    // if( (a&1) != 0)
    // [1383] if(mul16u::$1==0) goto mul16u::@3 -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b3
    // mul16u::@4
    // res = res + mb
    // [1384] mul16u::res#1 = mul16u::res#2 + mul16u::mb#2 -- vduz1=vduz1_plus_vduz2 
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
    // [1385] phi from mul16u::@2 mul16u::@4 to mul16u::@3 [phi:mul16u::@2/mul16u::@4->mul16u::@3]
    // [1385] phi mul16u::res#6 = mul16u::res#2 [phi:mul16u::@2/mul16u::@4->mul16u::@3#0] -- register_copy 
    // mul16u::@3
  __b3:
    // a = a>>1
    // [1386] mul16u::a#0 = mul16u::a#2 >> 1 -- vwuz1=vwuz1_ror_1 
    lsr.z a+1
    ror.z a
    // mb = mb<<1
    // [1387] mul16u::mb#1 = mul16u::mb#2 << 1 -- vduz1=vduz1_rol_1 
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    // [1379] phi from mul16u::@3 to mul16u::@1 [phi:mul16u::@3->mul16u::@1]
    // [1379] phi mul16u::mb#2 = mul16u::mb#1 [phi:mul16u::@3->mul16u::@1#0] -- register_copy 
    // [1379] phi mul16u::res#2 = mul16u::res#6 [phi:mul16u::@3->mul16u::@1#1] -- register_copy 
    // [1379] phi mul16u::a#2 = mul16u::a#0 [phi:mul16u::@3->mul16u::@1#2] -- register_copy 
    jmp __b1
}
  // utoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// utoa(word zp($a) value, byte* zp($6c) buffer)
utoa: {
    .const max_digits = 4
    .label digit_value = $6e
    .label buffer = $6c
    .label digit = $e
    .label value = $a
    // [1389] phi from utoa to utoa::@1 [phi:utoa->utoa::@1]
    // [1389] phi utoa::buffer#11 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:utoa->utoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [1389] phi utoa::started#2 = 0 [phi:utoa->utoa::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [1389] phi utoa::value#2 = utoa::value#1 [phi:utoa->utoa::@1#2] -- register_copy 
    // [1389] phi utoa::digit#2 = 0 [phi:utoa->utoa::@1#3] -- vbuz1=vbuc1 
    txa
    sta.z digit
    // utoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1390] if(utoa::digit#2<utoa::max_digits#2-1) goto utoa::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // utoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [1391] utoa::$11 = (byte)utoa::value#2 -- vbuaa=_byte_vwuz1 
    lda.z value
    // [1392] *utoa::buffer#11 = DIGITS[utoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbuaa 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1393] utoa::buffer#3 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1394] *utoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // utoa::@return
    // }
    // [1395] return 
    rts
    // utoa::@2
  __b2:
    // digit_value = digit_values[digit]
    // [1396] utoa::$10 = utoa::digit#2 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z digit
    asl
    // [1397] utoa::digit_value#0 = RADIX_HEXADECIMAL_VALUES[utoa::$10] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda RADIX_HEXADECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_HEXADECIMAL_VALUES+1,y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    // [1398] if(0!=utoa::started#2) goto utoa::@5 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b5
    // utoa::@7
    // [1399] if(utoa::value#2>=utoa::digit_value#0) goto utoa::@5 -- vwuz1_ge_vwuz2_then_la1 
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b5
  !:
    bcc __b5
    // [1400] phi from utoa::@7 to utoa::@4 [phi:utoa::@7->utoa::@4]
    // [1400] phi utoa::buffer#14 = utoa::buffer#11 [phi:utoa::@7->utoa::@4#0] -- register_copy 
    // [1400] phi utoa::started#4 = utoa::started#2 [phi:utoa::@7->utoa::@4#1] -- register_copy 
    // [1400] phi utoa::value#6 = utoa::value#2 [phi:utoa::@7->utoa::@4#2] -- register_copy 
    // utoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1401] utoa::digit#1 = ++ utoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [1389] phi from utoa::@4 to utoa::@1 [phi:utoa::@4->utoa::@1]
    // [1389] phi utoa::buffer#11 = utoa::buffer#14 [phi:utoa::@4->utoa::@1#0] -- register_copy 
    // [1389] phi utoa::started#2 = utoa::started#4 [phi:utoa::@4->utoa::@1#1] -- register_copy 
    // [1389] phi utoa::value#2 = utoa::value#6 [phi:utoa::@4->utoa::@1#2] -- register_copy 
    // [1389] phi utoa::digit#2 = utoa::digit#1 [phi:utoa::@4->utoa::@1#3] -- register_copy 
    jmp __b1
    // utoa::@5
  __b5:
    // utoa_append(buffer++, value, digit_value)
    // [1402] utoa_append::buffer#0 = utoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z utoa_append.buffer
    lda.z buffer+1
    sta.z utoa_append.buffer+1
    // [1403] utoa_append::value#0 = utoa::value#2
    // [1404] utoa_append::sub#0 = utoa::digit_value#0
    // [1405] call utoa_append 
    // [1487] phi from utoa::@5 to utoa_append [phi:utoa::@5->utoa_append]
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // [1406] utoa_append::return#0 = utoa_append::value#2
    // utoa::@6
    // value = utoa_append(buffer++, value, digit_value)
    // [1407] utoa::value#0 = utoa_append::return#0
    // value = utoa_append(buffer++, value, digit_value);
    // [1408] utoa::buffer#4 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1400] phi from utoa::@6 to utoa::@4 [phi:utoa::@6->utoa::@4]
    // [1400] phi utoa::buffer#14 = utoa::buffer#4 [phi:utoa::@6->utoa::@4#0] -- register_copy 
    // [1400] phi utoa::started#4 = 1 [phi:utoa::@6->utoa::@4#1] -- vbuxx=vbuc1 
    ldx #1
    // [1400] phi utoa::value#6 = utoa::value#0 [phi:utoa::@6->utoa::@4#2] -- register_copy 
    jmp __b4
}
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($6e) str)
strlen: {
    .label len = $70
    .label str = $6e
    .label return = $70
    // [1410] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [1410] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z len
    sta.z len+1
    // [1410] phi strlen::str#3 = strlen::str#5 [phi:strlen->strlen::@1#1] -- register_copy 
    // strlen::@1
  __b1:
    // while(*str)
    // [1411] if(0!=*strlen::str#3) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [1412] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [1413] strlen::len#1 = ++ strlen::len#2 -- vwuz1=_inc_vwuz1 
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    // [1414] strlen::str#0 = ++ strlen::str#3 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [1410] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [1410] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [1410] phi strlen::str#3 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
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
    .label addr = $a
    // addr = vera_layer_config[layer]
    // [1416] vera_layer_get_color::$3 = vera_layer_get_color::layer#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [1417] vera_layer_get_color::addr#0 = vera_layer_config[vera_layer_get_color::$3] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr & VERA_LAYER_CONFIG_256C
    // [1418] vera_layer_get_color::$0 = *vera_layer_get_color::addr#0 & VERA_LAYER_CONFIG_256C -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C
    ldy #0
    and (addr),y
    // if( *addr & VERA_LAYER_CONFIG_256C )
    // [1419] if(0!=vera_layer_get_color::$0) goto vera_layer_get_color::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // vera_layer_get_color::@2
    // vera_layer_backcolor[layer] << 4
    // [1420] vera_layer_get_color::$1 = vera_layer_backcolor[vera_layer_get_color::layer#2] << 4 -- vbuaa=pbuc1_derefidx_vbuxx_rol_4 
    lda vera_layer_backcolor,x
    asl
    asl
    asl
    asl
    // return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
    // [1421] vera_layer_get_color::return#1 = vera_layer_get_color::$1 | vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuaa=vbuaa_bor_pbuc1_derefidx_vbuxx 
    ora vera_layer_textcolor,x
    // [1422] phi from vera_layer_get_color::@1 vera_layer_get_color::@2 to vera_layer_get_color::@return [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return]
    // [1422] phi vera_layer_get_color::return#2 = vera_layer_get_color::return#0 [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return#0] -- register_copy 
    // vera_layer_get_color::@return
    // }
    // [1423] return 
    rts
    // vera_layer_get_color::@1
  __b1:
    // return (vera_layer_textcolor[layer]);
    // [1424] vera_layer_get_color::return#0 = vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_textcolor,x
    rts
}
  // cputln
// Print a newline
cputln: {
    .label temp = $a
    // temp = conio_line_text[cx16_conio.conio_screen_layer]
    // [1425] cputln::$2 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // [1426] cputln::temp#0 = conio_line_text[cputln::$2] -- vwuz1=pwuc1_derefidx_vbuaa 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda conio_line_text,y
    sta.z temp
    lda conio_line_text+1,y
    sta.z temp+1
    // temp += cx16_conio.conio_rowskip
    // [1427] cputln::temp#1 = cputln::temp#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z temp
    sta.z temp
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z temp+1
    sta.z temp+1
    // conio_line_text[cx16_conio.conio_screen_layer] = temp
    // [1428] cputln::$3 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // [1429] conio_line_text[cputln::$3] = cputln::temp#1 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z temp
    sta conio_line_text,y
    lda.z temp+1
    sta conio_line_text+1,y
    // conio_cursor_x[cx16_conio.conio_screen_layer] = 0
    // [1430] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // conio_cursor_y[cx16_conio.conio_screen_layer]++;
    // [1431] conio_cursor_y[*((byte*)&cx16_conio)] = ++ conio_cursor_y[*((byte*)&cx16_conio)] -- pbuc1_derefidx_(_deref_pbuc2)=_inc_pbuc1_derefidx_(_deref_pbuc2) 
    ldx cx16_conio
    lda conio_cursor_y,x
    inc
    sta conio_cursor_y,y
    // cscroll()
    // [1432] call cscroll 
    jsr cscroll
    // cputln::@return
    // }
    // [1433] return 
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
// uctoa_append(byte* zp($b2) buffer, byte register(X) value, byte zp($c4) sub)
uctoa_append: {
    .label buffer = $b2
    .label sub = $c4
    // [1435] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [1435] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbuyy=vbuc1 
    ldy #0
    // [1435] phi uctoa_append::value#2 = uctoa_append::value#0 [phi:uctoa_append->uctoa_append::@1#1] -- register_copy 
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [1436] if(uctoa_append::value#2>=uctoa_append::sub#0) goto uctoa_append::@2 -- vbuxx_ge_vbuz1_then_la1 
    cpx.z sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [1437] *uctoa_append::buffer#0 = DIGITS[uctoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuyy 
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // uctoa_append::@return
    // }
    // [1438] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [1439] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbuyy=_inc_vbuyy 
    iny
    // value -= sub
    // [1440] uctoa_append::value#1 = uctoa_append::value#2 - uctoa_append::sub#0 -- vbuxx=vbuxx_minus_vbuz1 
    txa
    sec
    sbc.z sub
    tax
    // [1435] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [1435] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    // [1435] phi uctoa_append::value#2 = uctoa_append::value#1 [phi:uctoa_append::@2->uctoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // printf_padding
// Print a padding char a number of times
// printf_padding(byte zp($38) pad, byte zp($37) length)
printf_padding: {
    .label i = $39
    .label length = $37
    .label pad = $38
    // [1442] phi from printf_padding to printf_padding::@1 [phi:printf_padding->printf_padding::@1]
    // [1442] phi printf_padding::i#2 = 0 [phi:printf_padding->printf_padding::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // printf_padding::@1
  __b1:
    // for(char i=0;i<length; i++)
    // [1443] if(printf_padding::i#2<printf_padding::length#4) goto printf_padding::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z i
    cmp.z length
    bcc __b2
    // printf_padding::@return
    // }
    // [1444] return 
    rts
    // printf_padding::@2
  __b2:
    // cputc(pad)
    // [1445] cputc::c#1 = printf_padding::pad#5 -- vbuz1=vbuz2 
    lda.z pad
    sta.z cputc.c
    // [1446] call cputc 
    // [1198] phi from printf_padding::@2 to cputc [phi:printf_padding::@2->cputc]
    // [1198] phi cputc::c#3 = cputc::c#1 [phi:printf_padding::@2->cputc#0] -- register_copy 
    jsr cputc
    // printf_padding::@3
    // for(char i=0;i<length; i++)
    // [1447] printf_padding::i#1 = ++ printf_padding::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [1442] phi from printf_padding::@3 to printf_padding::@1 [phi:printf_padding::@3->printf_padding::@1]
    // [1442] phi printf_padding::i#2 = printf_padding::i#1 [phi:printf_padding::@3->printf_padding::@1#0] -- register_copy 
    jmp __b1
}
  // strupr
// Converts a string to uppercase.
strupr: {
    .label str = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label src = $6e
    // [1449] phi from strupr to strupr::@1 [phi:strupr->strupr::@1]
    // [1449] phi strupr::src#2 = strupr::str#0 [phi:strupr->strupr::@1#0] -- pbuz1=pbuc1 
    lda #<str
    sta.z src
    lda #>str
    sta.z src+1
    // strupr::@1
  __b1:
    // while(*src)
    // [1450] if(0!=*strupr::src#2) goto strupr::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strupr::@return
    // }
    // [1451] return 
    rts
    // strupr::@2
  __b2:
    // toupper(*src)
    // [1452] toupper::ch#0 = *strupr::src#2 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (src),y
    // [1453] call toupper 
    jsr toupper
    // [1454] toupper::return#3 = toupper::return#2
    // strupr::@3
    // [1455] strupr::$0 = toupper::return#3
    // *src = toupper(*src)
    // [1456] *strupr::src#2 = strupr::$0 -- _deref_pbuz1=vbuaa 
    ldy #0
    sta (src),y
    // src++;
    // [1457] strupr::src#1 = ++ strupr::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [1449] phi from strupr::@3 to strupr::@1 [phi:strupr::@3->strupr::@1]
    // [1449] phi strupr::src#2 = strupr::src#1 [phi:strupr::@3->strupr::@1#0] -- register_copy 
    jmp __b1
}
  // vera_heap_block_is_empty
// vera_heap_block_is_empty(struct vera_heap* zp($b0) block)
vera_heap_block_is_empty: {
    .label sz = $c5
    .label return = $c5
    .label block = $b0
    // sz = block->size
    // [1458] vera_heap_block_is_empty::sz#0 = ((word*)vera_heap_block_is_empty::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] -- vwuz1=pwuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    sta.z sz
    iny
    lda (block),y
    sta.z sz+1
    // sz & ~VERA_HEAP_EMPTY
    // [1459] vera_heap_block_is_empty::return#0 = vera_heap_block_is_empty::sz#0 & ~VERA_HEAP_EMPTY -- vwuz1=vwuz1_band_vwuc1 
    lda.z return
    and #<VERA_HEAP_EMPTY^$ffff
    sta.z return
    lda.z return+1
    and #>VERA_HEAP_EMPTY^$ffff
    sta.z return+1
    // vera_heap_block_is_empty::@return
    // }
    // [1460] return 
    rts
}
  // vera_heap_block_size_get
// vera_heap_block_size_get(struct vera_heap* zp($c5) block)
vera_heap_block_size_get: {
    .label __0 = $cb
    .label __2 = $c5
    .label return = $c7
    .label block = $c5
    // block->size & ~VERA_HEAP_SIZE_16
    // [1461] vera_heap_block_size_get::$0 = ((word*)vera_heap_block_size_get::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] & ~VERA_HEAP_SIZE_16 -- vwuz1=pwuz2_derefidx_vbuc1_band_vwuc2 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (block),y
    and #<VERA_HEAP_SIZE_16^$ffff
    sta.z __0
    iny
    lda (block),y
    and #>VERA_HEAP_SIZE_16^$ffff
    sta.z __0+1
    // (block->size & ~VERA_HEAP_SIZE_16)?0x10000:0x00000 | block->size
    // [1462] if(0!=vera_heap_block_size_get::$0) goto vera_heap_block_size_get::@2 -- 0_neq_vwuz1_then_la1 
    lda.z __0
    ora.z __0+1
    bne __b1
    // vera_heap_block_size_get::@1
    // [1463] vera_heap_block_size_get::$2 = ((word*)vera_heap_block_size_get::block#0)[OFFSET_STRUCT_VERA_HEAP_SIZE] -- vwuz1=pwuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_VERA_HEAP_SIZE
    lda (__2),y
    pha
    iny
    lda (__2),y
    sta.z __2+1
    pla
    sta.z __2
    // [1464] phi from vera_heap_block_size_get::@1 to vera_heap_block_size_get::@2 [phi:vera_heap_block_size_get::@1->vera_heap_block_size_get::@2]
    // [1464] phi vera_heap_block_size_get::return#0 = vera_heap_block_size_get::$2 [phi:vera_heap_block_size_get::@1->vera_heap_block_size_get::@2#0] -- vduz1=vwuz2 
    sta.z return
    lda.z __2+1
    sta.z return+1
    lda #0
    sta.z return+2
    sta.z return+3
    rts
    // [1464] phi from vera_heap_block_size_get to vera_heap_block_size_get::@2 [phi:vera_heap_block_size_get->vera_heap_block_size_get::@2]
  __b1:
    // [1464] phi vera_heap_block_size_get::return#0 = $10000 [phi:vera_heap_block_size_get->vera_heap_block_size_get::@2#0] -- vduz1=vduc1 
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
    // [1465] return 
    rts
}
  // ultoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// ultoa(dword zp($c7) value, byte* zp($c5) buffer)
ultoa: {
    .const max_digits = 8
    .label digit_value = $cd
    .label buffer = $c5
    .label digit = $4c
    .label value = $c7
    // [1467] phi from ultoa to ultoa::@1 [phi:ultoa->ultoa::@1]
    // [1467] phi ultoa::buffer#11 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:ultoa->ultoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [1467] phi ultoa::started#2 = 0 [phi:ultoa->ultoa::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // [1467] phi ultoa::value#2 = ultoa::value#1 [phi:ultoa->ultoa::@1#2] -- register_copy 
    // [1467] phi ultoa::digit#2 = 0 [phi:ultoa->ultoa::@1#3] -- vbuz1=vbuc1 
    txa
    sta.z digit
    // ultoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1468] if(ultoa::digit#2<ultoa::max_digits#2-1) goto ultoa::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // ultoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [1469] ultoa::$11 = (byte)ultoa::value#2 -- vbuaa=_byte_vduz1 
    lda.z value
    // [1470] *ultoa::buffer#11 = DIGITS[ultoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbuaa 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1471] ultoa::buffer#3 = ++ ultoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1472] *ultoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // ultoa::@return
    // }
    // [1473] return 
    rts
    // ultoa::@2
  __b2:
    // digit_value = digit_values[digit]
    // [1474] ultoa::$10 = ultoa::digit#2 << 2 -- vbuaa=vbuz1_rol_2 
    lda.z digit
    asl
    asl
    // [1475] ultoa::digit_value#0 = RADIX_HEXADECIMAL_VALUES_LONG[ultoa::$10] -- vduz1=pduc1_derefidx_vbuaa 
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
    // [1476] if(0!=ultoa::started#2) goto ultoa::@5 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b5
    // ultoa::@7
    // [1477] if(ultoa::value#2>=ultoa::digit_value#0) goto ultoa::@5 -- vduz1_ge_vduz2_then_la1 
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
    // [1478] phi from ultoa::@7 to ultoa::@4 [phi:ultoa::@7->ultoa::@4]
    // [1478] phi ultoa::buffer#14 = ultoa::buffer#11 [phi:ultoa::@7->ultoa::@4#0] -- register_copy 
    // [1478] phi ultoa::started#4 = ultoa::started#2 [phi:ultoa::@7->ultoa::@4#1] -- register_copy 
    // [1478] phi ultoa::value#6 = ultoa::value#2 [phi:ultoa::@7->ultoa::@4#2] -- register_copy 
    // ultoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1479] ultoa::digit#1 = ++ ultoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [1467] phi from ultoa::@4 to ultoa::@1 [phi:ultoa::@4->ultoa::@1]
    // [1467] phi ultoa::buffer#11 = ultoa::buffer#14 [phi:ultoa::@4->ultoa::@1#0] -- register_copy 
    // [1467] phi ultoa::started#2 = ultoa::started#4 [phi:ultoa::@4->ultoa::@1#1] -- register_copy 
    // [1467] phi ultoa::value#2 = ultoa::value#6 [phi:ultoa::@4->ultoa::@1#2] -- register_copy 
    // [1467] phi ultoa::digit#2 = ultoa::digit#1 [phi:ultoa::@4->ultoa::@1#3] -- register_copy 
    jmp __b1
    // ultoa::@5
  __b5:
    // ultoa_append(buffer++, value, digit_value)
    // [1480] ultoa_append::buffer#0 = ultoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z ultoa_append.buffer
    lda.z buffer+1
    sta.z ultoa_append.buffer+1
    // [1481] ultoa_append::value#0 = ultoa::value#2
    // [1482] ultoa_append::sub#0 = ultoa::digit_value#0
    // [1483] call ultoa_append 
    // [1508] phi from ultoa::@5 to ultoa_append [phi:ultoa::@5->ultoa_append]
    jsr ultoa_append
    // ultoa_append(buffer++, value, digit_value)
    // [1484] ultoa_append::return#0 = ultoa_append::value#2
    // ultoa::@6
    // value = ultoa_append(buffer++, value, digit_value)
    // [1485] ultoa::value#0 = ultoa_append::return#0
    // value = ultoa_append(buffer++, value, digit_value);
    // [1486] ultoa::buffer#4 = ++ ultoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1478] phi from ultoa::@6 to ultoa::@4 [phi:ultoa::@6->ultoa::@4]
    // [1478] phi ultoa::buffer#14 = ultoa::buffer#4 [phi:ultoa::@6->ultoa::@4#0] -- register_copy 
    // [1478] phi ultoa::started#4 = 1 [phi:ultoa::@6->ultoa::@4#1] -- vbuxx=vbuc1 
    ldx #1
    // [1478] phi ultoa::value#6 = ultoa::value#0 [phi:ultoa::@6->ultoa::@4#2] -- register_copy 
    jmp __b4
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
// utoa_append(byte* zp($70) buffer, word zp($a) value, word zp($6e) sub)
utoa_append: {
    .label buffer = $70
    .label value = $a
    .label sub = $6e
    .label return = $a
    // [1488] phi from utoa_append to utoa_append::@1 [phi:utoa_append->utoa_append::@1]
    // [1488] phi utoa_append::digit#2 = 0 [phi:utoa_append->utoa_append::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [1488] phi utoa_append::value#2 = utoa_append::value#0 [phi:utoa_append->utoa_append::@1#1] -- register_copy 
    // utoa_append::@1
  __b1:
    // while (value >= sub)
    // [1489] if(utoa_append::value#2>=utoa_append::sub#0) goto utoa_append::@2 -- vwuz1_ge_vwuz2_then_la1 
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
    // [1490] *utoa_append::buffer#0 = DIGITS[utoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // utoa_append::@return
    // }
    // [1491] return 
    rts
    // utoa_append::@2
  __b2:
    // digit++;
    // [1492] utoa_append::digit#1 = ++ utoa_append::digit#2 -- vbuxx=_inc_vbuxx 
    inx
    // value -= sub
    // [1493] utoa_append::value#1 = utoa_append::value#2 - utoa_append::sub#0 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    // [1488] phi from utoa_append::@2 to utoa_append::@1 [phi:utoa_append::@2->utoa_append::@1]
    // [1488] phi utoa_append::digit#2 = utoa_append::digit#1 [phi:utoa_append::@2->utoa_append::@1#0] -- register_copy 
    // [1488] phi utoa_append::value#2 = utoa_append::value#1 [phi:utoa_append::@2->utoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [1494] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    ldy cx16_conio
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    bcc __b3
    // cscroll::@1
    // if(conio_scroll_enable[cx16_conio.conio_screen_layer])
    // [1495] if(0!=conio_scroll_enable[*((byte*)&cx16_conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    lda conio_scroll_enable,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(conio_cursor_y[cx16_conio.conio_screen_layer]>=cx16_conio.conio_screen_height)
    // [1496] if(conio_cursor_y[*((byte*)&cx16_conio)]<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT)) goto cscroll::@return -- pbuc1_derefidx_(_deref_pbuc2)_lt__deref_pbuc3_then_la1 
    lda conio_cursor_y,y
    cmp cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    // [1497] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
  __b3:
    // cscroll::@return
    // }
    // [1498] return 
    rts
    // [1499] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [1500] call insertup 
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, cx16_conio.conio_screen_height-1)
    // [1501] gotoxy::y#2 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT) - 1 -- vbuxx=_deref_pbuc1_minus_1 
    ldx cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_HEIGHT
    dex
    // [1502] call gotoxy 
    // [448] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [448] phi gotoxy::y#3 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    jsr gotoxy
    rts
}
  // toupper
// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
// toupper(byte register(A) ch)
toupper: {
    // if(ch>='a' && ch<='z')
    // [1503] if(toupper::ch#0<'a') goto toupper::@return -- vbuaa_lt_vbuc1_then_la1 
    cmp #'a'
    bcc __breturn
    // toupper::@2
    // [1504] if(toupper::ch#0<='z') goto toupper::@1 -- vbuaa_le_vbuc1_then_la1 
    cmp #'z'
    bcc __b1
    beq __b1
    // [1506] phi from toupper toupper::@1 toupper::@2 to toupper::@return [phi:toupper/toupper::@1/toupper::@2->toupper::@return]
    // [1506] phi toupper::return#2 = toupper::ch#0 [phi:toupper/toupper::@1/toupper::@2->toupper::@return#0] -- register_copy 
    rts
    // toupper::@1
  __b1:
    // return ch + ('A'-'a');
    // [1505] toupper::return#0 = toupper::ch#0 + 'A'-'a' -- vbuaa=vbuaa_plus_vbuc1 
    clc
    adc #'A'-'a'
    // toupper::@return
  __breturn:
    // }
    // [1507] return 
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
// ultoa_append(byte* zp($b2) buffer, dword zp($c7) value, dword zp($cd) sub)
ultoa_append: {
    .label buffer = $b2
    .label value = $c7
    .label sub = $cd
    .label return = $c7
    // [1509] phi from ultoa_append to ultoa_append::@1 [phi:ultoa_append->ultoa_append::@1]
    // [1509] phi ultoa_append::digit#2 = 0 [phi:ultoa_append->ultoa_append::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [1509] phi ultoa_append::value#2 = ultoa_append::value#0 [phi:ultoa_append->ultoa_append::@1#1] -- register_copy 
    // ultoa_append::@1
  __b1:
    // while (value >= sub)
    // [1510] if(ultoa_append::value#2>=ultoa_append::sub#0) goto ultoa_append::@2 -- vduz1_ge_vduz2_then_la1 
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
    // [1511] *ultoa_append::buffer#0 = DIGITS[ultoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // ultoa_append::@return
    // }
    // [1512] return 
    rts
    // ultoa_append::@2
  __b2:
    // digit++;
    // [1513] ultoa_append::digit#1 = ++ ultoa_append::digit#2 -- vbuxx=_inc_vbuxx 
    inx
    // value -= sub
    // [1514] ultoa_append::value#1 = ultoa_append::value#2 - ultoa_append::sub#0 -- vduz1=vduz1_minus_vduz2 
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
    // [1509] phi from ultoa_append::@2 to ultoa_append::@1 [phi:ultoa_append::@2->ultoa_append::@1]
    // [1509] phi ultoa_append::digit#2 = ultoa_append::digit#1 [phi:ultoa_append::@2->ultoa_append::@1#0] -- register_copy 
    // [1509] phi ultoa_append::value#2 = ultoa_append::value#1 [phi:ultoa_append::@2->ultoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label cy = $d1
    .label width = $d2
    .label line = $a
    .label start = $a
    // cy = conio_cursor_y[cx16_conio.conio_screen_layer]
    // [1515] insertup::cy#0 = conio_cursor_y[*((byte*)&cx16_conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy cx16_conio
    lda conio_cursor_y,y
    sta.z cy
    // width = cx16_conio.conio_screen_width * 2
    // [1516] insertup::width#0 = *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH
    asl
    sta.z width
    // [1517] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [1517] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuxx=vbuc1 
    ldx #1
    // insertup::@1
  __b1:
    // for(unsigned byte i=1; i<=cy; i++)
    // [1518] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuxx_le_vbuz1_then_la1 
    lda.z cy
    stx.z $ff
    cmp.z $ff
    bcs __b2
    // [1519] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [1520] call clearline 
    jsr clearline
    // insertup::@return
    // }
    // [1521] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [1522] insertup::$3 = insertup::i#2 - 1 -- vbuaa=vbuxx_minus_1 
    txa
    sec
    sbc #1
    // line = (i-1) << cx16_conio.conio_rowshift
    // [1523] insertup::line#0 = insertup::$3 << *((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSHIFT) -- vwuz1=vbuaa_rol__deref_pbuc1 
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
    // [1524] insertup::start#0 = *((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) + insertup::line#0 -- pbuz1=_deref_qbuc1_plus_vwuz1 
    clc
    lda.z start
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    sta.z start
    lda.z start+1
    adc cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    sta.z start+1
    // start+cx16_conio.conio_rowskip
    // [1525] memcpy_in_vram::src#0 = insertup::start#0 + *((word*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP) -- pbuz1=pbuz2_plus__deref_pwuc1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP
    adc.z start
    sta.z memcpy_in_vram.src
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_ROWSKIP+1
    adc.z start+1
    sta.z memcpy_in_vram.src+1
    // memcpy_in_vram(0, start, VERA_INC_1,  0, start+cx16_conio.conio_rowskip, VERA_INC_1, width)
    // [1526] memcpy_in_vram::dest#0 = (void*)insertup::start#0
    // [1527] memcpy_in_vram::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z memcpy_in_vram.num
    lda #0
    sta.z memcpy_in_vram.num+1
    // [1528] memcpy_in_vram::src#3 = (void*)memcpy_in_vram::src#0
    // memcpy_in_vram(0, start, VERA_INC_1,  0, start+cx16_conio.conio_rowskip, VERA_INC_1, width)
    // [1529] call memcpy_in_vram 
    // [301] phi from insertup::@2 to memcpy_in_vram [phi:insertup::@2->memcpy_in_vram]
    // [301] phi memcpy_in_vram::num#3 = memcpy_in_vram::num#0 [phi:insertup::@2->memcpy_in_vram#0] -- register_copy 
    // [301] phi memcpy_in_vram::dest_bank#2 = 0 [phi:insertup::@2->memcpy_in_vram#1] -- vbuz1=vbuc1 
    sta.z memcpy_in_vram.dest_bank
    // [301] phi memcpy_in_vram::dest#2 = memcpy_in_vram::dest#0 [phi:insertup::@2->memcpy_in_vram#2] -- register_copy 
    // [301] phi memcpy_in_vram::src_bank#2 = 0 [phi:insertup::@2->memcpy_in_vram#3] -- vbuyy=vbuc1 
    tay
    // [301] phi memcpy_in_vram::src#2 = memcpy_in_vram::src#3 [phi:insertup::@2->memcpy_in_vram#4] -- register_copy 
    jsr memcpy_in_vram
    // insertup::@4
    // for(unsigned byte i=1; i<=cy; i++)
    // [1530] insertup::i#1 = ++ insertup::i#2 -- vbuxx=_inc_vbuxx 
    inx
    // [1517] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [1517] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
}
  // clearline
clearline: {
    .label conio_line = $a
    .label addr = $a
    .label c = $6e
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1531] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // conio_line = conio_line_text[cx16_conio.conio_screen_layer]
    // [1532] clearline::$5 = *((byte*)&cx16_conio) << 1 -- vbuaa=_deref_pbuc1_rol_1 
    lda cx16_conio
    asl
    // [1533] clearline::conio_line#0 = conio_line_text[clearline::$5] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda conio_line_text,y
    sta.z conio_line
    lda conio_line_text+1,y
    sta.z conio_line+1
    // conio_screen_text + conio_line
    // [1534] clearline::addr#0 = (word)*((byte**)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT) + clearline::conio_line#0 -- vwuz1=_deref_pwuc1_plus_vwuz1 
    clc
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT
    adc.z addr
    sta.z addr
    lda cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_TEXT+1
    adc.z addr+1
    sta.z addr+1
    // <addr
    // [1535] clearline::$1 = < (byte*)clearline::addr#0 -- vbuaa=_lo_pbuz1 
    lda.z addr
    // *VERA_ADDRX_L = <addr
    // [1536] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >addr
    // [1537] clearline::$2 = > (byte*)clearline::addr#0 -- vbuaa=_hi_pbuz1 
    lda.z addr+1
    // *VERA_ADDRX_M = >addr
    // [1538] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [1539] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1540] vera_layer_get_color::layer#1 = *((byte*)&cx16_conio) -- vbuxx=_deref_pbuc1 
    ldx cx16_conio
    // [1541] call vera_layer_get_color 
    // [1415] phi from clearline to vera_layer_get_color [phi:clearline->vera_layer_get_color]
    // [1415] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#1 [phi:clearline->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1542] vera_layer_get_color::return#4 = vera_layer_get_color::return#2
    // clearline::@4
    // color = vera_layer_get_color(cx16_conio.conio_screen_layer)
    // [1543] clearline::color#0 = vera_layer_get_color::return#4 -- vbuxx=vbuaa 
    tax
    // [1544] phi from clearline::@4 to clearline::@1 [phi:clearline::@4->clearline::@1]
    // [1544] phi clearline::c#2 = 0 [phi:clearline::@4->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [1545] if(clearline::c#2<*((byte*)&cx16_conio+OFFSET_STRUCT_CX16_CONIO_CONIO_SCREEN_WIDTH)) goto clearline::@2 -- vwuz1_lt__deref_pbuc1_then_la1 
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
    // [1546] conio_cursor_x[*((byte*)&cx16_conio)] = 0 -- pbuc1_derefidx_(_deref_pbuc2)=vbuc3 
    lda #0
    ldy cx16_conio
    sta conio_cursor_x,y
    // clearline::@return
    // }
    // [1547] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [1548] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [1549] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // for( unsigned int c=0;c<cx16_conio.conio_screen_width; c++ )
    // [1550] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [1544] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [1544] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
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
  RADIX_HEXADECIMAL_VALUES: .word $1000, $100, $10
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_LONG: .dword $10000000, $1000000, $100000, $10000, $1000, $100, $10
  PlayerSprites: .fill 4*NUM_PLAYER, 0
  Enemy2Sprites: .fill 4*NUM_ENEMY2, 0
  SquareMetalTiles: .fill 4*NUM_SQUAREMETAL, 0
  TileMetalTiles: .fill 4*NUM_TILEMETAL, 0
  SquareRasterTiles: .fill 4*NUM_SQUARERASTER, 0
  // TODO: BBUG! This is not compiling correctly! __mem struct Tile *TileDB[3] = {&SquareMetal, &TileMetal, &SquareRaster};
  TileDB: .fill 2*3, 0
  FILE_SPRITES: .text "PLAYER"
  .byte 0
  FILE_ENEMY2: .text "ENEMY2"
  .byte 0
  FILE_TILES: .text "TILES"
  .byte 0
  FILE_TILEMETAL: .text "TILEMETAL"
  .byte 0
  FILE_SQUARERASTER: .text "SQUARERASTER"
  .byte 0
  FILE_SQUAREMETAL: .text "SQUAREMETAL"
  .byte 0
  FILE_PALETTES: .text "PALETTES"
  .byte 0
  s1: .text @"\n"
  .byte 0
  cx16_conio: .fill SIZEOF_STRUCT_CX16_CONIO, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
  SquareMetal: .word SquareMetalTiles, 0
  .byte $40, $10, 4, 4, 4
  TileMetal: .word TileMetalTiles, $40
  .byte $40, $10, 4, 4, 5
  SquareRaster: .word SquareRasterTiles, $80
  .byte $40, $10, 4, 4, 6
