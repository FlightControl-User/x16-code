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
  .const VERA_SPRITE_WIDTH_32 = $20
  .const VERA_SPRITE_HEIGHT_32 = $80
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
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  .const NUM_PLAYER = $c
  .const NUM_ENEMY2 = $c
  .const NUM_TILES_SMALL = 4
  .const NUM_SQUAREMETAL = 4
  .const NUM_TILEMETAL = 4
  .const NUM_SQUARERASTER = 4
  // Addressed used for graphics in main banked memory.
  .const BANK_PLAYER = $2000
  .const BANK_ENEMY2 = $4000
  .const BANK_TILES_SMALL = $14000
  .const BANK_SQUAREMETAL = $16000
  .const BANK_TILEMETAL = $22000
  .const BANK_SQUARERASTER = $28000
  .const BANK_PALETTE = $34000
  // Addresses used to store graphics in VERA VRAM.
  .const VRAM_PLAYER = 0
  .const VRAM_ENEMY2 = $1800
  .const VRAM_TILES_SMALL = $3000
  .const VRAM_SQUAREMETAL = $3800
  .const VRAM_TILEMETAL = $5800
  .const VRAM_SQUARERASTER = $7800
  .const VRAM_TILEMAP = $10000
  .const SIZEOF_POINTER = 2
  .const SIZEOF_STRUCT_VERA_SPRITE = 8
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const OFFSET_STRUCT_MOS6522_VIA_PORT_A = 1
  .const OFFSET_STRUCT_VERA_SPRITE_X = 2
  .const OFFSET_STRUCT_VERA_SPRITE_Y = 4
  .const OFFSET_STRUCT_VERA_SPRITE_CTRL2 = 7
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
  // to POKE the address space.
  // The VIA#1: ROM/RAM Bank Control
  // Port A Bits 0-7 RAM bank
  // Port B Bits 0-2 ROM bank
  // Port B Bits 3-7 [TBD]
  .label VIA1 = $9f60
  // $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .label GETIN = $ffe4
  // Variable holding the screen width;
  .label conio_screen_width = $30
  // Variable holding the screen height;
  .label conio_screen_height = $31
  // Variable holding the screen layer on the VERA card with which conio interacts;
  .label conio_screen_layer = $32
  // Variables holding the current map width and map height of the layer.
  .label conio_width = $33
  .label conio_height = $35
  .label conio_rowshift = $37
  .label conio_rowskip = $38
  .label i = $3a
  .label j = $3b
  .label a = $3c
  .label vscroll = $3d
  .label scroll_action = $3f
  // The random state variable
  .label rand_state = $2b
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
  .label CONIO_SCREEN_TEXT = $58
  .label CONIO_SCREEN_BANK = $57
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
    // i = 0
    // [8] i = 0 -- vbuz1=vbuc1 
    sta.z i
    // j = 0
    // [9] j = 0 -- vbuz1=vbuc1 
    sta.z j
    // a = 4
    // [10] a = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z a
    // vscroll = 0
    // [11] vscroll = 0 -- vwuz1=vwuc1 
    lda #<0
    sta.z vscroll
    sta.z vscroll+1
    // scroll_action = 2
    // [12] scroll_action = 2 -- vwuz1=vwuc1 
    lda #<2
    sta.z scroll_action
    lda #>2
    sta.z scroll_action+1
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [13] call conio_x16_init 
    jsr conio_x16_init
    // [14] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [15] call main 
    jsr main
    // __start::@return
    // [16] return 
    rts
}
  // irq_vsync
//VSYNC Interrupt Routine
irq_vsync: {
    .label __2 = $41
    .label __16 = $45
    .label vera_layer_set_vertical_scroll1_scroll = $43
    .label c = 3
    .label r = 2
    // interrupt(isr_rom_sys_cx16_entry) -- isr_rom_sys_cx16_entry 
    // a--;
    // [18] a = -- a -- vbuz1=_dec_vbuz1 
    dec.z a
    // if(a==0)
    // [19] if(a!=0) goto irq_vsync::@1 -- vbuz1_neq_0_then_la1 
    lda.z a
    cmp #0
    bne __b1
    // irq_vsync::@3
    // a=4
    // [20] a = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z a
    // rotate_sprites(0, i,NUM_PLAYER,PlayerSprites,40,100)
    // [21] rotate_sprites::rotate#0 = i -- vwuz1=vbuz2 
    lda.z i
    sta.z rotate_sprites.rotate
    lda #0
    sta.z rotate_sprites.rotate+1
    // [22] call rotate_sprites 
    // [210] phi from irq_vsync::@3 to rotate_sprites [phi:irq_vsync::@3->rotate_sprites]
    // [210] phi rotate_sprites::base#6 = 0 [phi:irq_vsync::@3->rotate_sprites#0] -- vwuz1=vbuc1 
    sta.z rotate_sprites.base
    sta.z rotate_sprites.base+1
    // [210] phi rotate_sprites::basex#6 = $28 [phi:irq_vsync::@3->rotate_sprites#1] -- vwuz1=vbuc1 
    lda #<$28
    sta.z rotate_sprites.basex
    lda #>$28
    sta.z rotate_sprites.basex+1
    // [210] phi rotate_sprites::spriteaddresses#6 = PlayerSprites [phi:irq_vsync::@3->rotate_sprites#2] -- pwuz1=pwuc1 
    lda #<PlayerSprites
    sta.z rotate_sprites.spriteaddresses
    lda #>PlayerSprites
    sta.z rotate_sprites.spriteaddresses+1
    // [210] phi rotate_sprites::rotate#4 = rotate_sprites::rotate#0 [phi:irq_vsync::@3->rotate_sprites#3] -- register_copy 
    // [210] phi rotate_sprites::max#5 = NUM_PLAYER [phi:irq_vsync::@3->rotate_sprites#4] -- vwuz1=vbuc1 
    lda #<NUM_PLAYER
    sta.z rotate_sprites.max
    lda #>NUM_PLAYER
    sta.z rotate_sprites.max+1
    jsr rotate_sprites
    // irq_vsync::@15
    // rotate_sprites(16, j,NUM_ENEMY2,Enemy2Sprites,340,100)
    // [23] rotate_sprites::rotate#1 = j -- vwuz1=vbuz2 
    lda.z j
    sta.z rotate_sprites.rotate
    lda #0
    sta.z rotate_sprites.rotate+1
    // [24] call rotate_sprites 
    // [210] phi from irq_vsync::@15 to rotate_sprites [phi:irq_vsync::@15->rotate_sprites]
    // [210] phi rotate_sprites::base#6 = $10 [phi:irq_vsync::@15->rotate_sprites#0] -- vwuz1=vbuc1 
    lda #<$10
    sta.z rotate_sprites.base
    lda #>$10
    sta.z rotate_sprites.base+1
    // [210] phi rotate_sprites::basex#6 = $154 [phi:irq_vsync::@15->rotate_sprites#1] -- vwuz1=vwuc1 
    lda #<$154
    sta.z rotate_sprites.basex
    lda #>$154
    sta.z rotate_sprites.basex+1
    // [210] phi rotate_sprites::spriteaddresses#6 = Enemy2Sprites [phi:irq_vsync::@15->rotate_sprites#2] -- pwuz1=pwuc1 
    lda #<Enemy2Sprites
    sta.z rotate_sprites.spriteaddresses
    lda #>Enemy2Sprites
    sta.z rotate_sprites.spriteaddresses+1
    // [210] phi rotate_sprites::rotate#4 = rotate_sprites::rotate#1 [phi:irq_vsync::@15->rotate_sprites#3] -- register_copy 
    // [210] phi rotate_sprites::max#5 = NUM_ENEMY2 [phi:irq_vsync::@15->rotate_sprites#4] -- vwuz1=vbuc1 
    lda #<NUM_ENEMY2
    sta.z rotate_sprites.max
    lda #>NUM_ENEMY2
    sta.z rotate_sprites.max+1
    jsr rotate_sprites
    // irq_vsync::@16
    // i++;
    // [25] i = ++ i -- vbuz1=_inc_vbuz1 
    inc.z i
    // if(i>=NUM_PLAYER)
    // [26] if(i<NUM_PLAYER) goto irq_vsync::@7 -- vbuz1_lt_vbuc1_then_la1 
    lda.z i
    cmp #NUM_PLAYER
    bcc __b7
    // irq_vsync::@4
    // i=0
    // [27] i = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // irq_vsync::@7
  __b7:
    // j++;
    // [28] j = ++ j -- vbuz1=_inc_vbuz1 
    inc.z j
    // if(j>=NUM_ENEMY2)
    // [29] if(j<NUM_ENEMY2) goto irq_vsync::@1 -- vbuz1_lt_vbuc1_then_la1 
    lda.z j
    cmp #NUM_ENEMY2
    bcc __b1
    // irq_vsync::@8
    // j=0
    // [30] j = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z j
    // irq_vsync::@1
  __b1:
    // if(scroll_action--)
    // [31] irq_vsync::$2 = scroll_action -- vwuz1=vwuz2 
    lda.z scroll_action
    sta.z __2
    lda.z scroll_action+1
    sta.z __2+1
    // [32] scroll_action = -- scroll_action -- vwuz1=_dec_vwuz1 
    lda.z scroll_action
    bne !+
    dec.z scroll_action+1
  !:
    dec.z scroll_action
    // [33] if(0==irq_vsync::$2) goto irq_vsync::@2 -- 0_eq_vwuz1_then_la1 
    lda.z __2
    ora.z __2+1
    beq __b2
    // irq_vsync::@5
    // scroll_action = 2
    // [34] scroll_action = 2 -- vwuz1=vbuc1 
    lda #<2
    sta.z scroll_action
    lda #>2
    sta.z scroll_action+1
    // vscroll++;
    // [35] vscroll = ++ vscroll -- vwuz1=_inc_vwuz1 
    inc.z vscroll
    bne !+
    inc.z vscroll+1
  !:
    // if(vscroll>(64)*2-1)
    // [36] if(vscroll<$40*2-1+1) goto irq_vsync::@9 -- vwuz1_lt_vbuc1_then_la1 
    lda.z vscroll+1
    bne !+
    lda.z vscroll
    cmp #$40*2-1+1
    bcc __b9
  !:
    // [37] phi from irq_vsync::@5 to irq_vsync::@6 [phi:irq_vsync::@5->irq_vsync::@6]
    // irq_vsync::@6
    // memcpy_in_vram(1, <VRAM_TILEMAP, VERA_INC_1, 1, (<VRAM_TILEMAP)+64*16, VERA_INC_1, 64*16*4)
    // [38] call memcpy_in_vram 
    // [236] phi from irq_vsync::@6 to memcpy_in_vram [phi:irq_vsync::@6->memcpy_in_vram]
    // [236] phi memcpy_in_vram::num#4 = (word)$40*$10*4 [phi:irq_vsync::@6->memcpy_in_vram#0] -- vwuz1=vwuc1 
    lda #<$40*$10*4
    sta.z memcpy_in_vram.num
    lda #>$40*$10*4
    sta.z memcpy_in_vram.num+1
    // [236] phi memcpy_in_vram::dest_bank#3 = 1 [phi:irq_vsync::@6->memcpy_in_vram#1] -- vbuz1=vbuc1 
    lda #1
    sta.z memcpy_in_vram.dest_bank
    // [236] phi memcpy_in_vram::dest#3 = (void*)0 [phi:irq_vsync::@6->memcpy_in_vram#2] -- pvoz1=pvoc1 
    lda #<0
    sta.z memcpy_in_vram.dest
    sta.z memcpy_in_vram.dest+1
    // [236] phi memcpy_in_vram::src_bank#3 = 1 [phi:irq_vsync::@6->memcpy_in_vram#3] -- vbuyy=vbuc1 
    ldy #1
    // [236] phi memcpy_in_vram::src#3 = (void*)(word)$40*$10 [phi:irq_vsync::@6->memcpy_in_vram#4] -- pvoz1=pvoc1 
    lda #<$40*$10
    sta.z memcpy_in_vram.src
    lda #>$40*$10
    sta.z memcpy_in_vram.src+1
    jsr memcpy_in_vram
    // [39] phi from irq_vsync::@6 to irq_vsync::@10 [phi:irq_vsync::@6->irq_vsync::@10]
    // [39] phi rand_state#43 = rand_state#30 [phi:irq_vsync::@6->irq_vsync::@10#0] -- register_copy 
    // [39] phi irq_vsync::r#2 = 4 [phi:irq_vsync::@6->irq_vsync::@10#1] -- vbuz1=vbuc1 
    lda #4
    sta.z r
    // irq_vsync::@10
  __b10:
    // for(byte r=4;r<5;r+=1)
    // [40] if(irq_vsync::r#2<5) goto irq_vsync::@12 -- vbuz1_lt_vbuc1_then_la1 
    lda.z r
    cmp #5
    bcc __b3
    // irq_vsync::@11
    // vscroll=0
    // [41] vscroll = 0 -- vwuz1=vbuc1 
    lda #<0
    sta.z vscroll
    sta.z vscroll+1
    // irq_vsync::@9
  __b9:
    // vera_layer_set_vertical_scroll(0,vscroll)
    // [42] irq_vsync::vera_layer_set_vertical_scroll1_scroll#0 = vscroll -- vwuz1=vwuz2 
    lda.z vscroll
    sta.z vera_layer_set_vertical_scroll1_scroll
    lda.z vscroll+1
    sta.z vera_layer_set_vertical_scroll1_scroll+1
    // irq_vsync::vera_layer_set_vertical_scroll1
    // <scroll
    // [43] irq_vsync::vera_layer_set_vertical_scroll1_$0 = < irq_vsync::vera_layer_set_vertical_scroll1_scroll#0 -- vbuaa=_lo_vwuz1 
    lda.z vera_layer_set_vertical_scroll1_scroll
    // *vera_layer_vscroll_l[layer] = <scroll
    // [44] *(*vera_layer_vscroll_l) = irq_vsync::vera_layer_set_vertical_scroll1_$0 -- _deref_(_deref_qbuc1)=vbuaa 
    ldy vera_layer_vscroll_l
    sty.z $fe
    ldy vera_layer_vscroll_l+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // >scroll
    // [45] irq_vsync::vera_layer_set_vertical_scroll1_$1 = > irq_vsync::vera_layer_set_vertical_scroll1_scroll#0 -- vbuaa=_hi_vwuz1 
    lda.z vera_layer_set_vertical_scroll1_scroll+1
    // *vera_layer_vscroll_h[layer] = >scroll
    // [46] *(*vera_layer_vscroll_h) = irq_vsync::vera_layer_set_vertical_scroll1_$1 -- _deref_(_deref_qbuc1)=vbuaa 
    ldy vera_layer_vscroll_h
    sty.z $fe
    ldy vera_layer_vscroll_h+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // irq_vsync::@2
  __b2:
    // *VERA_ISR = VERA_VSYNC
    // [47] *VERA_ISR = VERA_VSYNC -- _deref_pbuc1=vbuc2 
    // Reset the VSYNC interrupt
    lda #VERA_VSYNC
    sta VERA_ISR
    // irq_vsync::@return
    // }
    // [48] return 
    // interrupt(isr_rom_sys_cx16_exit) -- isr_rom_sys_cx16_exit 
    jmp $e034
    // [49] phi from irq_vsync::@10 to irq_vsync::@12 [phi:irq_vsync::@10->irq_vsync::@12]
  __b3:
    // [49] phi rand_state#23 = rand_state#43 [phi:irq_vsync::@10->irq_vsync::@12#0] -- register_copy 
    // [49] phi irq_vsync::c#2 = 0 [phi:irq_vsync::@10->irq_vsync::@12#1] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // irq_vsync::@12
  __b12:
    // for(byte c=0;c<5;c+=1)
    // [50] if(irq_vsync::c#2<5) goto irq_vsync::@13 -- vbuz1_lt_vbuc1_then_la1 
    lda.z c
    cmp #5
    bcc __b13
    // irq_vsync::@14
    // r+=1
    // [51] irq_vsync::r#1 = irq_vsync::r#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z r
    // [39] phi from irq_vsync::@14 to irq_vsync::@10 [phi:irq_vsync::@14->irq_vsync::@10]
    // [39] phi rand_state#43 = rand_state#23 [phi:irq_vsync::@14->irq_vsync::@10#0] -- register_copy 
    // [39] phi irq_vsync::r#2 = irq_vsync::r#1 [phi:irq_vsync::@14->irq_vsync::@10#1] -- register_copy 
    jmp __b10
    // [52] phi from irq_vsync::@12 to irq_vsync::@13 [phi:irq_vsync::@12->irq_vsync::@13]
    // irq_vsync::@13
  __b13:
    // rand()
    // [53] call rand 
    // [256] phi from irq_vsync::@13 to rand [phi:irq_vsync::@13->rand]
    // [256] phi rand_state#13 = rand_state#23 [phi:irq_vsync::@13->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [54] rand::return#2 = rand::return#0
    // irq_vsync::@17
    // modr16u(rand(),3,0)
    // [55] modr16u::dividend#1 = rand::return#2
    // [56] call modr16u 
    // [265] phi from irq_vsync::@17 to modr16u [phi:irq_vsync::@17->modr16u]
    // [265] phi modr16u::dividend#5 = modr16u::dividend#1 [phi:irq_vsync::@17->modr16u#0] -- register_copy 
    jsr modr16u
    // modr16u(rand(),3,0)
    // [57] modr16u::return#2 = modr16u::return#0
    // irq_vsync::@18
    // [58] irq_vsync::$16 = modr16u::return#2 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z __16
    lda.z modr16u.return+1
    sta.z __16+1
    // rnd = (byte)modr16u(rand(),3,0)
    // [59] irq_vsync::rnd#0 = (byte)irq_vsync::$16 -- vbuaa=_byte_vwuz1 
    lda.z __16
    // vera_tile_element( 0, c, r, 3, TileDB[rnd])
    // [60] irq_vsync::$19 = irq_vsync::rnd#0 << 1 -- vbuxx=vbuaa_rol_1 
    asl
    tax
    // [61] vera_tile_element::x#1 = irq_vsync::c#2 -- vbuz1=vbuz2 
    lda.z c
    sta.z vera_tile_element.x
    // [62] vera_tile_element::y#1 = irq_vsync::r#2 -- vbuz1=vbuz2 
    lda.z r
    sta.z vera_tile_element.y
    // [63] vera_tile_element::Tile#0 = TileDB[irq_vsync::$19] -- pbuz1=qbuc1_derefidx_vbuxx 
    lda TileDB,x
    sta.z vera_tile_element.Tile
    lda TileDB+1,x
    sta.z vera_tile_element.Tile+1
    // [64] call vera_tile_element 
    // [282] phi from irq_vsync::@18 to vera_tile_element [phi:irq_vsync::@18->vera_tile_element]
    // [282] phi vera_tile_element::y#3 = vera_tile_element::y#1 [phi:irq_vsync::@18->vera_tile_element#0] -- register_copy 
    // [282] phi vera_tile_element::x#3 = vera_tile_element::x#1 [phi:irq_vsync::@18->vera_tile_element#1] -- register_copy 
    // [282] phi vera_tile_element::Tile#2 = vera_tile_element::Tile#0 [phi:irq_vsync::@18->vera_tile_element#2] -- register_copy 
    jsr vera_tile_element
    // irq_vsync::@19
    // c+=1
    // [65] irq_vsync::c#1 = irq_vsync::c#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z c
    // [49] phi from irq_vsync::@19 to irq_vsync::@12 [phi:irq_vsync::@19->irq_vsync::@12]
    // [49] phi rand_state#23 = rand_state#14 [phi:irq_vsync::@19->irq_vsync::@12#0] -- register_copy 
    // [49] phi irq_vsync::c#2 = irq_vsync::c#1 [phi:irq_vsync::@19->irq_vsync::@12#1] -- register_copy 
    jmp __b12
}
  // conio_x16_init
// Set initial cursor position
conio_x16_init: {
    // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label line = 4
    // line = *BASIC_CURSOR_LINE
    // [66] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda BASIC_CURSOR_LINE
    sta.z line
    // vera_layer_mode_text(1,(dword)0x00000,(dword)0x0F800,128,64,8,8,16)
    // [67] call vera_layer_mode_text 
    // [332] phi from conio_x16_init to vera_layer_mode_text [phi:conio_x16_init->vera_layer_mode_text]
    jsr vera_layer_mode_text
    // [68] phi from conio_x16_init to conio_x16_init::@3 [phi:conio_x16_init->conio_x16_init::@3]
    // conio_x16_init::@3
    // screensize(&conio_screen_width, &conio_screen_height)
    // [69] call screensize 
    jsr screensize
    // [70] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // screenlayer(1)
    // [71] call screenlayer 
    jsr screenlayer
    // [72] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // vera_layer_set_textcolor(1, WHITE)
    // [73] call vera_layer_set_textcolor 
    // [384] phi from conio_x16_init::@5 to vera_layer_set_textcolor [phi:conio_x16_init::@5->vera_layer_set_textcolor]
    // [384] phi vera_layer_set_textcolor::layer#2 = 1 [phi:conio_x16_init::@5->vera_layer_set_textcolor#0] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_set_textcolor
    // [74] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // vera_layer_set_backcolor(1, BLUE)
    // [75] call vera_layer_set_backcolor 
    // [387] phi from conio_x16_init::@6 to vera_layer_set_backcolor [phi:conio_x16_init::@6->vera_layer_set_backcolor]
    // [387] phi vera_layer_set_backcolor::color#2 = BLUE [phi:conio_x16_init::@6->vera_layer_set_backcolor#0] -- vbuaa=vbuc1 
    lda #BLUE
    // [387] phi vera_layer_set_backcolor::layer#2 = 1 [phi:conio_x16_init::@6->vera_layer_set_backcolor#1] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_set_backcolor
    // [76] phi from conio_x16_init::@6 to conio_x16_init::@7 [phi:conio_x16_init::@6->conio_x16_init::@7]
    // conio_x16_init::@7
    // vera_layer_set_mapbase(0,0x20)
    // [77] call vera_layer_set_mapbase 
    // [390] phi from conio_x16_init::@7 to vera_layer_set_mapbase [phi:conio_x16_init::@7->vera_layer_set_mapbase]
    // [390] phi vera_layer_set_mapbase::mapbase#3 = $20 [phi:conio_x16_init::@7->vera_layer_set_mapbase#0] -- vbuxx=vbuc1 
    ldx #$20
    // [390] phi vera_layer_set_mapbase::layer#3 = 0 [phi:conio_x16_init::@7->vera_layer_set_mapbase#1] -- vbuaa=vbuc1 
    lda #0
    jsr vera_layer_set_mapbase
    // [78] phi from conio_x16_init::@7 to conio_x16_init::@8 [phi:conio_x16_init::@7->conio_x16_init::@8]
    // conio_x16_init::@8
    // vera_layer_set_mapbase(1,0x00)
    // [79] call vera_layer_set_mapbase 
    // [390] phi from conio_x16_init::@8 to vera_layer_set_mapbase [phi:conio_x16_init::@8->vera_layer_set_mapbase]
    // [390] phi vera_layer_set_mapbase::mapbase#3 = 0 [phi:conio_x16_init::@8->vera_layer_set_mapbase#0] -- vbuxx=vbuc1 
    ldx #0
    // [390] phi vera_layer_set_mapbase::layer#3 = 1 [phi:conio_x16_init::@8->vera_layer_set_mapbase#1] -- vbuaa=vbuc1 
    lda #1
    jsr vera_layer_set_mapbase
    // conio_x16_init::@9
    // if(line>=CONIO_HEIGHT)
    // [80] if(conio_x16_init::line#0<conio_screen_height) goto conio_x16_init::@1 -- vbuz1_lt_vbuz2_then_la1 
    lda.z line
    cmp.z conio_screen_height
    bcc __b1
    // conio_x16_init::@2
    // line=CONIO_HEIGHT-1
    // [81] conio_x16_init::line#1 = conio_screen_height - 1 -- vbuz1=vbuz2_minus_1 
    ldx.z conio_screen_height
    dex
    stx.z line
    // [82] phi from conio_x16_init::@2 conio_x16_init::@9 to conio_x16_init::@1 [phi:conio_x16_init::@2/conio_x16_init::@9->conio_x16_init::@1]
    // [82] phi conio_x16_init::line#3 = conio_x16_init::line#1 [phi:conio_x16_init::@2/conio_x16_init::@9->conio_x16_init::@1#0] -- register_copy 
    // conio_x16_init::@1
  __b1:
    // gotoxy(0, line)
    // [83] gotoxy::y#0 = conio_x16_init::line#3 -- vbuxx=vbuz1 
    ldx.z line
    // [84] call gotoxy 
    // [395] phi from conio_x16_init::@1 to gotoxy [phi:conio_x16_init::@1->gotoxy]
    // [395] phi gotoxy::y#3 = gotoxy::y#0 [phi:conio_x16_init::@1->gotoxy#0] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [85] return 
    rts
}
  // main
main: {
    .label status = $47
    .label status_1 = $48
    .label status_2 = $4a
    .label status_3 = $4b
    .label status_4 = $4c
    .label status_5 = $4d
    .label status_6 = $49
    // VIA1->PORT_B = 0
    // [86] *((byte*)VIA1) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta VIA1
    // memcpy_in_vram(1, 0xF000, VERA_INC_1, 0, 0xF800, VERA_INC_1, 256*8)
    // [87] call memcpy_in_vram 
    // [236] phi from main to memcpy_in_vram [phi:main->memcpy_in_vram]
    // [236] phi memcpy_in_vram::num#4 = $100*8 [phi:main->memcpy_in_vram#0] -- vwuz1=vwuc1 
    lda #<$100*8
    sta.z memcpy_in_vram.num
    lda #>$100*8
    sta.z memcpy_in_vram.num+1
    // [236] phi memcpy_in_vram::dest_bank#3 = 1 [phi:main->memcpy_in_vram#1] -- vbuz1=vbuc1 
    lda #1
    sta.z memcpy_in_vram.dest_bank
    // [236] phi memcpy_in_vram::dest#3 = (void*) 61440 [phi:main->memcpy_in_vram#2] -- pvoz1=pvoc1 
    lda #<$f000
    sta.z memcpy_in_vram.dest
    lda #>$f000
    sta.z memcpy_in_vram.dest+1
    // [236] phi memcpy_in_vram::src_bank#3 = 0 [phi:main->memcpy_in_vram#3] -- vbuyy=vbuc1 
    ldy #0
    // [236] phi memcpy_in_vram::src#3 = (void*) 63488 [phi:main->memcpy_in_vram#4] -- pvoz1=pvoc1 
    lda #<$f800
    sta.z memcpy_in_vram.src
    lda #>$f800
    sta.z memcpy_in_vram.src+1
    jsr memcpy_in_vram
    // [88] phi from main to main::@20 [phi:main->main::@20]
    // main::@20
    // vera_layer_mode_tile(1, (dword)0x1A000, (dword)0x1F000, 128, 64, 8, 8, 1)
    // [89] call vera_layer_mode_tile 
  // We copy the 128 character set of 8 bytes each.
    // [408] phi from main::@20 to vera_layer_mode_tile [phi:main::@20->vera_layer_mode_tile]
    // [408] phi vera_layer_mode_tile::tileheight#10 = 8 [phi:main::@20->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #8
    sta.z vera_layer_mode_tile.tileheight
    // [408] phi vera_layer_mode_tile::tilewidth#10 = 8 [phi:main::@20->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [408] phi vera_layer_mode_tile::tilebase_address#10 = $1f000 [phi:main::@20->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<$1f000
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>$1f000
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>$1f000>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [408] phi vera_layer_mode_tile::mapbase_address#10 = $1a000 [phi:main::@20->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<$1a000
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>$1a000
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<$1a000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>$1a000>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [408] phi vera_layer_mode_tile::mapheight#10 = $40 [phi:main::@20->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [408] phi vera_layer_mode_tile::layer#10 = 1 [phi:main::@20->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #1
    sta.z vera_layer_mode_tile.layer
    // [408] phi vera_layer_mode_tile::mapwidth#10 = $80 [phi:main::@20->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$80
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$80
    sta.z vera_layer_mode_tile.mapwidth+1
    // [408] phi vera_layer_mode_tile::color_depth#3 = 1 [phi:main::@20->vera_layer_mode_tile#7] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_mode_tile
    // [90] phi from main::@20 to main::@21 [phi:main::@20->main::@21]
    // main::@21
    // screenlayer(1)
    // [91] call screenlayer 
    jsr screenlayer
    // main::textcolor1
    // vera_layer_set_textcolor(conio_screen_layer, color)
    // [92] vera_layer_set_textcolor::layer#1 = conio_screen_layer -- vbuxx=vbuz1 
    ldx.z conio_screen_layer
    // [93] call vera_layer_set_textcolor 
    // [384] phi from main::textcolor1 to vera_layer_set_textcolor [phi:main::textcolor1->vera_layer_set_textcolor]
    // [384] phi vera_layer_set_textcolor::layer#2 = vera_layer_set_textcolor::layer#1 [phi:main::textcolor1->vera_layer_set_textcolor#0] -- register_copy 
    jsr vera_layer_set_textcolor
    // main::bgcolor1
    // vera_layer_set_backcolor(conio_screen_layer, color)
    // [94] vera_layer_set_backcolor::layer#1 = conio_screen_layer -- vbuxx=vbuz1 
    ldx.z conio_screen_layer
    // [95] call vera_layer_set_backcolor 
    // [387] phi from main::bgcolor1 to vera_layer_set_backcolor [phi:main::bgcolor1->vera_layer_set_backcolor]
    // [387] phi vera_layer_set_backcolor::color#2 = BLACK [phi:main::bgcolor1->vera_layer_set_backcolor#0] -- vbuaa=vbuc1 
    lda #BLACK
    // [387] phi vera_layer_set_backcolor::layer#2 = vera_layer_set_backcolor::layer#1 [phi:main::bgcolor1->vera_layer_set_backcolor#1] -- register_copy 
    jsr vera_layer_set_backcolor
    // [96] phi from main::bgcolor1 to main::@17 [phi:main::bgcolor1->main::@17]
    // main::@17
    // clrscr()
    // [97] call clrscr 
    jsr clrscr
    // [98] phi from main::@17 to main::@22 [phi:main::@17->main::@22]
    // main::@22
    // vera_layer_mode_tile(0, (dword)VRAM_TILEMAP, VRAM_TILES_SMALL, 64, 64, 16, 16, 4)
    // [99] call vera_layer_mode_tile 
  // Now we activate the tile mode.
    // [408] phi from main::@22 to vera_layer_mode_tile [phi:main::@22->vera_layer_mode_tile]
    // [408] phi vera_layer_mode_tile::tileheight#10 = $10 [phi:main::@22->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #$10
    sta.z vera_layer_mode_tile.tileheight
    // [408] phi vera_layer_mode_tile::tilewidth#10 = $10 [phi:main::@22->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    sta.z vera_layer_mode_tile.tilewidth
    // [408] phi vera_layer_mode_tile::tilebase_address#10 = VRAM_TILES_SMALL [phi:main::@22->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<VRAM_TILES_SMALL
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>VRAM_TILES_SMALL
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<VRAM_TILES_SMALL>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>VRAM_TILES_SMALL>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [408] phi vera_layer_mode_tile::mapbase_address#10 = VRAM_TILEMAP [phi:main::@22->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<VRAM_TILEMAP
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>VRAM_TILEMAP
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<VRAM_TILEMAP>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>VRAM_TILEMAP>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [408] phi vera_layer_mode_tile::mapheight#10 = $40 [phi:main::@22->vera_layer_mode_tile#4] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapheight
    lda #>$40
    sta.z vera_layer_mode_tile.mapheight+1
    // [408] phi vera_layer_mode_tile::layer#10 = 0 [phi:main::@22->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #0
    sta.z vera_layer_mode_tile.layer
    // [408] phi vera_layer_mode_tile::mapwidth#10 = $40 [phi:main::@22->vera_layer_mode_tile#6] -- vwuz1=vbuc1 
    lda #<$40
    sta.z vera_layer_mode_tile.mapwidth
    lda #>$40
    sta.z vera_layer_mode_tile.mapwidth+1
    // [408] phi vera_layer_mode_tile::color_depth#3 = 4 [phi:main::@22->vera_layer_mode_tile#7] -- vbuxx=vbuc1 
    ldx #4
    jsr vera_layer_mode_tile
    // [100] phi from main::@22 to main::@23 [phi:main::@22->main::@23]
    // main::@23
    // cx16_load_ram_banked(1, 8, 0, FILE_SPRITES, (dword)BANK_PLAYER)
    // [101] call cx16_load_ram_banked 
    // [512] phi from main::@23 to cx16_load_ram_banked [phi:main::@23->cx16_load_ram_banked]
    // [512] phi cx16_load_ram_banked::filename#7 = FILE_SPRITES [phi:main::@23->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_SPRITES
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_SPRITES
    sta.z cx16_load_ram_banked.filename+1
    // [512] phi cx16_load_ram_banked::address#7 = BANK_PLAYER [phi:main::@23->cx16_load_ram_banked#1] -- vduz1=vduc1 
    lda #<BANK_PLAYER
    sta.z cx16_load_ram_banked.address
    lda #>BANK_PLAYER
    sta.z cx16_load_ram_banked.address+1
    lda #<BANK_PLAYER>>$10
    sta.z cx16_load_ram_banked.address+2
    lda #>BANK_PLAYER>>$10
    sta.z cx16_load_ram_banked.address+3
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, FILE_SPRITES, (dword)BANK_PLAYER)
    // [102] cx16_load_ram_banked::return#12 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@24
    // status = cx16_load_ram_banked(1, 8, 0, FILE_SPRITES, (dword)BANK_PLAYER)
    // [103] main::status#0 = cx16_load_ram_banked::return#12 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$ff)
    // [104] if(main::status#0==$ff) goto main::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [105] phi from main::@24 to main::@8 [phi:main::@24->main::@8]
    // main::@8
    // printf("error file_sprites: %x\n",status)
    // [106] call cputs 
    // [579] phi from main::@8 to cputs [phi:main::@8->cputs]
    // [579] phi cputs::s#16 = main::s [phi:main::@8->cputs#0] -- pbuz1=pbuc1 
    lda #<s
    sta.z cputs.s
    lda #>s
    sta.z cputs.s+1
    jsr cputs
    // main::@26
    // printf("error file_sprites: %x\n",status)
    // [107] printf_uchar::uvalue#0 = main::status#0 -- vbuxx=vbuz1 
    ldx.z status
    // [108] call printf_uchar 
    // [587] phi from main::@26 to printf_uchar [phi:main::@26->printf_uchar]
    // [587] phi printf_uchar::format_radix#10 = HEXADECIMAL [phi:main::@26->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [587] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#0 [phi:main::@26->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [109] phi from main::@26 to main::@27 [phi:main::@26->main::@27]
    // main::@27
    // printf("error file_sprites: %x\n",status)
    // [110] call cputs 
    // [579] phi from main::@27 to cputs [phi:main::@27->cputs]
    // [579] phi cputs::s#16 = main::s1 [phi:main::@27->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [111] phi from main::@24 main::@27 to main::@1 [phi:main::@24/main::@27->main::@1]
    // main::@1
  __b1:
    // cx16_load_ram_banked(1, 8, 0, FILE_ENEMY2, (dword)BANK_ENEMY2)
    // [112] call cx16_load_ram_banked 
    // [512] phi from main::@1 to cx16_load_ram_banked [phi:main::@1->cx16_load_ram_banked]
    // [512] phi cx16_load_ram_banked::filename#7 = FILE_ENEMY2 [phi:main::@1->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_ENEMY2
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_ENEMY2
    sta.z cx16_load_ram_banked.filename+1
    // [512] phi cx16_load_ram_banked::address#7 = BANK_ENEMY2 [phi:main::@1->cx16_load_ram_banked#1] -- vduz1=vduc1 
    lda #<BANK_ENEMY2
    sta.z cx16_load_ram_banked.address
    lda #>BANK_ENEMY2
    sta.z cx16_load_ram_banked.address+1
    lda #<BANK_ENEMY2>>$10
    sta.z cx16_load_ram_banked.address+2
    lda #>BANK_ENEMY2>>$10
    sta.z cx16_load_ram_banked.address+3
    jsr cx16_load_ram_banked
    // cx16_load_ram_banked(1, 8, 0, FILE_ENEMY2, (dword)BANK_ENEMY2)
    // [113] cx16_load_ram_banked::return#13 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@25
    // status = cx16_load_ram_banked(1, 8, 0, FILE_ENEMY2, (dword)BANK_ENEMY2)
    // [114] main::status#1 = cx16_load_ram_banked::return#13 -- vbuz1=vbuaa 
    sta.z status_1
    // if(status!=$ff)
    // [115] if(main::status#1==$ff) goto main::@2 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status_1
    beq __b2
    // [116] phi from main::@25 to main::@9 [phi:main::@25->main::@9]
    // main::@9
    // printf("error file_enemy2 = %x\n",status)
    // [117] call cputs 
    // [579] phi from main::@9 to cputs [phi:main::@9->cputs]
    // [579] phi cputs::s#16 = main::s2 [phi:main::@9->cputs#0] -- pbuz1=pbuc1 
    lda #<s2
    sta.z cputs.s
    lda #>s2
    sta.z cputs.s+1
    jsr cputs
    // main::@29
    // printf("error file_enemy2 = %x\n",status)
    // [118] printf_uchar::uvalue#1 = main::status#1 -- vbuxx=vbuz1 
    ldx.z status_1
    // [119] call printf_uchar 
    // [587] phi from main::@29 to printf_uchar [phi:main::@29->printf_uchar]
    // [587] phi printf_uchar::format_radix#10 = HEXADECIMAL [phi:main::@29->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [587] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#1 [phi:main::@29->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [120] phi from main::@29 to main::@30 [phi:main::@29->main::@30]
    // main::@30
    // printf("error file_enemy2 = %x\n",status)
    // [121] call cputs 
    // [579] phi from main::@30 to cputs [phi:main::@30->cputs]
    // [579] phi cputs::s#16 = main::s1 [phi:main::@30->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [122] phi from main::@25 main::@30 to main::@2 [phi:main::@25/main::@30->main::@2]
    // main::@2
  __b2:
    // cx16_load_ram_banked(1, 8, 0, FILE_TILES, (dword)BANK_TILES_SMALL)
    // [123] call cx16_load_ram_banked 
    // [512] phi from main::@2 to cx16_load_ram_banked [phi:main::@2->cx16_load_ram_banked]
    // [512] phi cx16_load_ram_banked::filename#7 = FILE_TILES [phi:main::@2->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_TILES
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_TILES
    sta.z cx16_load_ram_banked.filename+1
    // [512] phi cx16_load_ram_banked::address#7 = BANK_TILES_SMALL [phi:main::@2->cx16_load_ram_banked#1] -- vduz1=vduc1 
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
    // [124] cx16_load_ram_banked::return#14 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@28
    // status = cx16_load_ram_banked(1, 8, 0, FILE_TILES, (dword)BANK_TILES_SMALL)
    // [125] main::status#16 = cx16_load_ram_banked::return#14 -- vbuz1=vbuaa 
    sta.z status_6
    // if(status!=$ff)
    // [126] if(main::status#16==$ff) goto main::@3 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status_6
    beq __b3
    // [127] phi from main::@28 to main::@10 [phi:main::@28->main::@10]
    // main::@10
    // printf("error file_tiles = %x\n",status)
    // [128] call cputs 
    // [579] phi from main::@10 to cputs [phi:main::@10->cputs]
    // [579] phi cputs::s#16 = main::s4 [phi:main::@10->cputs#0] -- pbuz1=pbuc1 
    lda #<s4
    sta.z cputs.s
    lda #>s4
    sta.z cputs.s+1
    jsr cputs
    // main::@32
    // printf("error file_tiles = %x\n",status)
    // [129] printf_uchar::uvalue#2 = main::status#16 -- vbuxx=vbuz1 
    ldx.z status_6
    // [130] call printf_uchar 
    // [587] phi from main::@32 to printf_uchar [phi:main::@32->printf_uchar]
    // [587] phi printf_uchar::format_radix#10 = HEXADECIMAL [phi:main::@32->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [587] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#2 [phi:main::@32->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [131] phi from main::@32 to main::@33 [phi:main::@32->main::@33]
    // main::@33
    // printf("error file_tiles = %x\n",status)
    // [132] call cputs 
    // [579] phi from main::@33 to cputs [phi:main::@33->cputs]
    // [579] phi cputs::s#16 = main::s1 [phi:main::@33->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [133] phi from main::@28 main::@33 to main::@3 [phi:main::@28/main::@33->main::@3]
    // main::@3
  __b3:
    // cx16_load_ram_banked(1, 8, 0, FILE_SQUAREMETAL, (dword)BANK_SQUAREMETAL)
    // [134] call cx16_load_ram_banked 
    // [512] phi from main::@3 to cx16_load_ram_banked [phi:main::@3->cx16_load_ram_banked]
    // [512] phi cx16_load_ram_banked::filename#7 = FILE_SQUAREMETAL [phi:main::@3->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_SQUAREMETAL
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_SQUAREMETAL
    sta.z cx16_load_ram_banked.filename+1
    // [512] phi cx16_load_ram_banked::address#7 = BANK_SQUAREMETAL [phi:main::@3->cx16_load_ram_banked#1] -- vduz1=vduc1 
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
    // [135] cx16_load_ram_banked::return#15 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@31
    // status = cx16_load_ram_banked(1, 8, 0, FILE_SQUAREMETAL, (dword)BANK_SQUAREMETAL)
    // [136] main::status#10 = cx16_load_ram_banked::return#15 -- vbuz1=vbuaa 
    sta.z status_2
    // if(status!=$ff)
    // [137] if(main::status#10==$ff) goto main::@4 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status_2
    beq __b4
    // [138] phi from main::@31 to main::@11 [phi:main::@31->main::@11]
    // main::@11
    // printf("error file_squaremetal = %x\n",status)
    // [139] call cputs 
    // [579] phi from main::@11 to cputs [phi:main::@11->cputs]
    // [579] phi cputs::s#16 = main::s6 [phi:main::@11->cputs#0] -- pbuz1=pbuc1 
    lda #<s6
    sta.z cputs.s
    lda #>s6
    sta.z cputs.s+1
    jsr cputs
    // main::@35
    // printf("error file_squaremetal = %x\n",status)
    // [140] printf_uchar::uvalue#3 = main::status#10 -- vbuxx=vbuz1 
    ldx.z status_2
    // [141] call printf_uchar 
    // [587] phi from main::@35 to printf_uchar [phi:main::@35->printf_uchar]
    // [587] phi printf_uchar::format_radix#10 = HEXADECIMAL [phi:main::@35->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [587] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#3 [phi:main::@35->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [142] phi from main::@35 to main::@36 [phi:main::@35->main::@36]
    // main::@36
    // printf("error file_squaremetal = %x\n",status)
    // [143] call cputs 
    // [579] phi from main::@36 to cputs [phi:main::@36->cputs]
    // [579] phi cputs::s#16 = main::s1 [phi:main::@36->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [144] phi from main::@31 main::@36 to main::@4 [phi:main::@31/main::@36->main::@4]
    // main::@4
  __b4:
    // cx16_load_ram_banked(1, 8, 0, FILE_TILEMETAL, (dword)BANK_TILEMETAL)
    // [145] call cx16_load_ram_banked 
    // [512] phi from main::@4 to cx16_load_ram_banked [phi:main::@4->cx16_load_ram_banked]
    // [512] phi cx16_load_ram_banked::filename#7 = FILE_TILEMETAL [phi:main::@4->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_TILEMETAL
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_TILEMETAL
    sta.z cx16_load_ram_banked.filename+1
    // [512] phi cx16_load_ram_banked::address#7 = BANK_TILEMETAL [phi:main::@4->cx16_load_ram_banked#1] -- vduz1=vduc1 
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
    // [146] cx16_load_ram_banked::return#16 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@34
    // status = cx16_load_ram_banked(1, 8, 0, FILE_TILEMETAL, (dword)BANK_TILEMETAL)
    // [147] main::status#11 = cx16_load_ram_banked::return#16 -- vbuz1=vbuaa 
    sta.z status_3
    // if(status!=$ff)
    // [148] if(main::status#11==$ff) goto main::@5 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status_3
    beq __b5
    // [149] phi from main::@34 to main::@12 [phi:main::@34->main::@12]
    // main::@12
    // printf("error file_tilemetal = %x\n",status)
    // [150] call cputs 
    // [579] phi from main::@12 to cputs [phi:main::@12->cputs]
    // [579] phi cputs::s#16 = main::s8 [phi:main::@12->cputs#0] -- pbuz1=pbuc1 
    lda #<s8
    sta.z cputs.s
    lda #>s8
    sta.z cputs.s+1
    jsr cputs
    // main::@38
    // printf("error file_tilemetal = %x\n",status)
    // [151] printf_uchar::uvalue#4 = main::status#11 -- vbuxx=vbuz1 
    ldx.z status_3
    // [152] call printf_uchar 
    // [587] phi from main::@38 to printf_uchar [phi:main::@38->printf_uchar]
    // [587] phi printf_uchar::format_radix#10 = HEXADECIMAL [phi:main::@38->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [587] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#4 [phi:main::@38->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [153] phi from main::@38 to main::@39 [phi:main::@38->main::@39]
    // main::@39
    // printf("error file_tilemetal = %x\n",status)
    // [154] call cputs 
    // [579] phi from main::@39 to cputs [phi:main::@39->cputs]
    // [579] phi cputs::s#16 = main::s1 [phi:main::@39->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [155] phi from main::@34 main::@39 to main::@5 [phi:main::@34/main::@39->main::@5]
    // main::@5
  __b5:
    // cx16_load_ram_banked(1, 8, 0, FILE_SQUARERASTER, (dword)BANK_SQUARERASTER)
    // [156] call cx16_load_ram_banked 
    // [512] phi from main::@5 to cx16_load_ram_banked [phi:main::@5->cx16_load_ram_banked]
    // [512] phi cx16_load_ram_banked::filename#7 = FILE_SQUARERASTER [phi:main::@5->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_SQUARERASTER
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_SQUARERASTER
    sta.z cx16_load_ram_banked.filename+1
    // [512] phi cx16_load_ram_banked::address#7 = BANK_SQUARERASTER [phi:main::@5->cx16_load_ram_banked#1] -- vduz1=vduc1 
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
    // [157] cx16_load_ram_banked::return#17 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@37
    // status = cx16_load_ram_banked(1, 8, 0, FILE_SQUARERASTER, (dword)BANK_SQUARERASTER)
    // [158] main::status#12 = cx16_load_ram_banked::return#17 -- vbuz1=vbuaa 
    sta.z status_4
    // if(status!=$ff)
    // [159] if(main::status#12==$ff) goto main::@6 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status_4
    beq __b6
    // [160] phi from main::@37 to main::@13 [phi:main::@37->main::@13]
    // main::@13
    // printf("error file_squareraster = %x\n",status)
    // [161] call cputs 
    // [579] phi from main::@13 to cputs [phi:main::@13->cputs]
    // [579] phi cputs::s#16 = main::s10 [phi:main::@13->cputs#0] -- pbuz1=pbuc1 
    lda #<s10
    sta.z cputs.s
    lda #>s10
    sta.z cputs.s+1
    jsr cputs
    // main::@41
    // printf("error file_squareraster = %x\n",status)
    // [162] printf_uchar::uvalue#5 = main::status#12 -- vbuxx=vbuz1 
    ldx.z status_4
    // [163] call printf_uchar 
    // [587] phi from main::@41 to printf_uchar [phi:main::@41->printf_uchar]
    // [587] phi printf_uchar::format_radix#10 = HEXADECIMAL [phi:main::@41->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #HEXADECIMAL
    // [587] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#5 [phi:main::@41->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [164] phi from main::@41 to main::@42 [phi:main::@41->main::@42]
    // main::@42
    // printf("error file_squareraster = %x\n",status)
    // [165] call cputs 
    // [579] phi from main::@42 to cputs [phi:main::@42->cputs]
    // [579] phi cputs::s#16 = main::s1 [phi:main::@42->cputs#0] -- pbuz1=pbuc1 
    lda #<s1
    sta.z cputs.s
    lda #>s1
    sta.z cputs.s+1
    jsr cputs
    // [166] phi from main::@37 main::@42 to main::@6 [phi:main::@37/main::@42->main::@6]
    // main::@6
  __b6:
    // cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, (dword)BANK_PALETTE)
    // [167] call cx16_load_ram_banked 
    // [512] phi from main::@6 to cx16_load_ram_banked [phi:main::@6->cx16_load_ram_banked]
    // [512] phi cx16_load_ram_banked::filename#7 = FILE_PALETTES [phi:main::@6->cx16_load_ram_banked#0] -- pbuz1=pbuc1 
    lda #<FILE_PALETTES
    sta.z cx16_load_ram_banked.filename
    lda #>FILE_PALETTES
    sta.z cx16_load_ram_banked.filename+1
    // [512] phi cx16_load_ram_banked::address#7 = BANK_PALETTE [phi:main::@6->cx16_load_ram_banked#1] -- vduz1=vduc1 
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
    // [168] cx16_load_ram_banked::return#10 = cx16_load_ram_banked::return#1 -- vbuaa=vbuz1 
    lda.z cx16_load_ram_banked.return
    // main::@40
    // status = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, (dword)BANK_PALETTE)
    // [169] main::status#13 = cx16_load_ram_banked::return#10 -- vbuz1=vbuaa 
    sta.z status_5
    // if(status!=$ff)
    // [170] if(main::status#13==$ff) goto main::@7 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status_5
    beq __b7
    // [171] phi from main::@40 to main::@14 [phi:main::@40->main::@14]
    // main::@14
    // printf("error file_palettes = %u",status)
    // [172] call cputs 
    // [579] phi from main::@14 to cputs [phi:main::@14->cputs]
    // [579] phi cputs::s#16 = main::s12 [phi:main::@14->cputs#0] -- pbuz1=pbuc1 
    lda #<s12
    sta.z cputs.s
    lda #>s12
    sta.z cputs.s+1
    jsr cputs
    // main::@52
    // printf("error file_palettes = %u",status)
    // [173] printf_uchar::uvalue#6 = main::status#13 -- vbuxx=vbuz1 
    ldx.z status_5
    // [174] call printf_uchar 
    // [587] phi from main::@52 to printf_uchar [phi:main::@52->printf_uchar]
    // [587] phi printf_uchar::format_radix#10 = DECIMAL [phi:main::@52->printf_uchar#0] -- vbuyy=vbuc1 
    ldy #DECIMAL
    // [587] phi printf_uchar::uvalue#10 = printf_uchar::uvalue#6 [phi:main::@52->printf_uchar#1] -- register_copy 
    jsr printf_uchar
    // [175] phi from main::@40 main::@52 to main::@7 [phi:main::@40/main::@52->main::@7]
    // main::@7
  __b7:
    // bnkcpy_vram_address(VRAM_PLAYER, BANK_PLAYER, (dword)32*32*NUM_PLAYER/2)
    // [176] call bnkcpy_vram_address 
  // Copy graphics to the VERA VRAM.
    // [595] phi from main::@7 to bnkcpy_vram_address [phi:main::@7->bnkcpy_vram_address]
    // [595] phi bnkcpy_vram_address::num#7 = $20*$20*NUM_PLAYER/2 [phi:main::@7->bnkcpy_vram_address#0] -- vduz1=vduc1 
    lda #<$20*$20*NUM_PLAYER/2
    sta.z bnkcpy_vram_address.num
    lda #>$20*$20*NUM_PLAYER/2
    sta.z bnkcpy_vram_address.num+1
    lda #<$20*$20*NUM_PLAYER/2>>$10
    sta.z bnkcpy_vram_address.num+2
    lda #>$20*$20*NUM_PLAYER/2>>$10
    sta.z bnkcpy_vram_address.num+3
    // [595] phi bnkcpy_vram_address::beg#0 = BANK_PLAYER [phi:main::@7->bnkcpy_vram_address#1] -- vduz1=vduc1 
    lda #<BANK_PLAYER
    sta.z bnkcpy_vram_address.beg
    lda #>BANK_PLAYER
    sta.z bnkcpy_vram_address.beg+1
    lda #<BANK_PLAYER>>$10
    sta.z bnkcpy_vram_address.beg+2
    lda #>BANK_PLAYER>>$10
    sta.z bnkcpy_vram_address.beg+3
    // [595] phi bnkcpy_vram_address::vdest#7 = VRAM_PLAYER [phi:main::@7->bnkcpy_vram_address#2] -- vduz1=vduc1 
    lda #<VRAM_PLAYER
    sta.z bnkcpy_vram_address.vdest
    lda #>VRAM_PLAYER
    sta.z bnkcpy_vram_address.vdest+1
    lda #<VRAM_PLAYER>>$10
    sta.z bnkcpy_vram_address.vdest+2
    lda #>VRAM_PLAYER>>$10
    sta.z bnkcpy_vram_address.vdest+3
    jsr bnkcpy_vram_address
    // [177] phi from main::@7 to main::@43 [phi:main::@7->main::@43]
    // main::@43
    // bnkcpy_vram_address(VRAM_ENEMY2, BANK_ENEMY2, (dword)32*32*NUM_ENEMY2/2)
    // [178] call bnkcpy_vram_address 
    // [595] phi from main::@43 to bnkcpy_vram_address [phi:main::@43->bnkcpy_vram_address]
    // [595] phi bnkcpy_vram_address::num#7 = $20*$20*NUM_ENEMY2/2 [phi:main::@43->bnkcpy_vram_address#0] -- vduz1=vduc1 
    lda #<$20*$20*NUM_ENEMY2/2
    sta.z bnkcpy_vram_address.num
    lda #>$20*$20*NUM_ENEMY2/2
    sta.z bnkcpy_vram_address.num+1
    lda #<$20*$20*NUM_ENEMY2/2>>$10
    sta.z bnkcpy_vram_address.num+2
    lda #>$20*$20*NUM_ENEMY2/2>>$10
    sta.z bnkcpy_vram_address.num+3
    // [595] phi bnkcpy_vram_address::beg#0 = BANK_ENEMY2 [phi:main::@43->bnkcpy_vram_address#1] -- vduz1=vduc1 
    lda #<BANK_ENEMY2
    sta.z bnkcpy_vram_address.beg
    lda #>BANK_ENEMY2
    sta.z bnkcpy_vram_address.beg+1
    lda #<BANK_ENEMY2>>$10
    sta.z bnkcpy_vram_address.beg+2
    lda #>BANK_ENEMY2>>$10
    sta.z bnkcpy_vram_address.beg+3
    // [595] phi bnkcpy_vram_address::vdest#7 = VRAM_ENEMY2 [phi:main::@43->bnkcpy_vram_address#2] -- vduz1=vduc1 
    lda #<VRAM_ENEMY2
    sta.z bnkcpy_vram_address.vdest
    lda #>VRAM_ENEMY2
    sta.z bnkcpy_vram_address.vdest+1
    lda #<VRAM_ENEMY2>>$10
    sta.z bnkcpy_vram_address.vdest+2
    lda #>VRAM_ENEMY2>>$10
    sta.z bnkcpy_vram_address.vdest+3
    jsr bnkcpy_vram_address
    // [179] phi from main::@43 to main::@44 [phi:main::@43->main::@44]
    // main::@44
    // bnkcpy_vram_address(VRAM_TILES_SMALL, BANK_TILES_SMALL, (dword)32*32*(NUM_TILES_SMALL)/2)
    // [180] call bnkcpy_vram_address 
    // [595] phi from main::@44 to bnkcpy_vram_address [phi:main::@44->bnkcpy_vram_address]
    // [595] phi bnkcpy_vram_address::num#7 = $20*$20*NUM_TILES_SMALL/2 [phi:main::@44->bnkcpy_vram_address#0] -- vduz1=vduc1 
    lda #<$20*$20*NUM_TILES_SMALL/2
    sta.z bnkcpy_vram_address.num
    lda #>$20*$20*NUM_TILES_SMALL/2
    sta.z bnkcpy_vram_address.num+1
    lda #<$20*$20*NUM_TILES_SMALL/2>>$10
    sta.z bnkcpy_vram_address.num+2
    lda #>$20*$20*NUM_TILES_SMALL/2>>$10
    sta.z bnkcpy_vram_address.num+3
    // [595] phi bnkcpy_vram_address::beg#0 = BANK_TILES_SMALL [phi:main::@44->bnkcpy_vram_address#1] -- vduz1=vduc1 
    lda #<BANK_TILES_SMALL
    sta.z bnkcpy_vram_address.beg
    lda #>BANK_TILES_SMALL
    sta.z bnkcpy_vram_address.beg+1
    lda #<BANK_TILES_SMALL>>$10
    sta.z bnkcpy_vram_address.beg+2
    lda #>BANK_TILES_SMALL>>$10
    sta.z bnkcpy_vram_address.beg+3
    // [595] phi bnkcpy_vram_address::vdest#7 = VRAM_TILES_SMALL [phi:main::@44->bnkcpy_vram_address#2] -- vduz1=vduc1 
    lda #<VRAM_TILES_SMALL
    sta.z bnkcpy_vram_address.vdest
    lda #>VRAM_TILES_SMALL
    sta.z bnkcpy_vram_address.vdest+1
    lda #<VRAM_TILES_SMALL>>$10
    sta.z bnkcpy_vram_address.vdest+2
    lda #>VRAM_TILES_SMALL>>$10
    sta.z bnkcpy_vram_address.vdest+3
    jsr bnkcpy_vram_address
    // [181] phi from main::@44 to main::@45 [phi:main::@44->main::@45]
    // main::@45
    // bnkcpy_vram_address(VRAM_SQUAREMETAL, BANK_SQUAREMETAL, (dword)64*64*(NUM_SQUAREMETAL)/2)
    // [182] call bnkcpy_vram_address 
    // [595] phi from main::@45 to bnkcpy_vram_address [phi:main::@45->bnkcpy_vram_address]
    // [595] phi bnkcpy_vram_address::num#7 = $40*$40*NUM_SQUAREMETAL/2 [phi:main::@45->bnkcpy_vram_address#0] -- vduz1=vduc1 
    lda #<$40*$40*NUM_SQUAREMETAL/2
    sta.z bnkcpy_vram_address.num
    lda #>$40*$40*NUM_SQUAREMETAL/2
    sta.z bnkcpy_vram_address.num+1
    lda #<$40*$40*NUM_SQUAREMETAL/2>>$10
    sta.z bnkcpy_vram_address.num+2
    lda #>$40*$40*NUM_SQUAREMETAL/2>>$10
    sta.z bnkcpy_vram_address.num+3
    // [595] phi bnkcpy_vram_address::beg#0 = BANK_SQUAREMETAL [phi:main::@45->bnkcpy_vram_address#1] -- vduz1=vduc1 
    lda #<BANK_SQUAREMETAL
    sta.z bnkcpy_vram_address.beg
    lda #>BANK_SQUAREMETAL
    sta.z bnkcpy_vram_address.beg+1
    lda #<BANK_SQUAREMETAL>>$10
    sta.z bnkcpy_vram_address.beg+2
    lda #>BANK_SQUAREMETAL>>$10
    sta.z bnkcpy_vram_address.beg+3
    // [595] phi bnkcpy_vram_address::vdest#7 = VRAM_SQUAREMETAL [phi:main::@45->bnkcpy_vram_address#2] -- vduz1=vduc1 
    lda #<VRAM_SQUAREMETAL
    sta.z bnkcpy_vram_address.vdest
    lda #>VRAM_SQUAREMETAL
    sta.z bnkcpy_vram_address.vdest+1
    lda #<VRAM_SQUAREMETAL>>$10
    sta.z bnkcpy_vram_address.vdest+2
    lda #>VRAM_SQUAREMETAL>>$10
    sta.z bnkcpy_vram_address.vdest+3
    jsr bnkcpy_vram_address
    // [183] phi from main::@45 to main::@46 [phi:main::@45->main::@46]
    // main::@46
    // bnkcpy_vram_address(VRAM_TILEMETAL, BANK_TILEMETAL, (dword)64*64*(NUM_TILEMETAL)/2)
    // [184] call bnkcpy_vram_address 
    // [595] phi from main::@46 to bnkcpy_vram_address [phi:main::@46->bnkcpy_vram_address]
    // [595] phi bnkcpy_vram_address::num#7 = $40*$40*NUM_TILEMETAL/2 [phi:main::@46->bnkcpy_vram_address#0] -- vduz1=vduc1 
    lda #<$40*$40*NUM_TILEMETAL/2
    sta.z bnkcpy_vram_address.num
    lda #>$40*$40*NUM_TILEMETAL/2
    sta.z bnkcpy_vram_address.num+1
    lda #<$40*$40*NUM_TILEMETAL/2>>$10
    sta.z bnkcpy_vram_address.num+2
    lda #>$40*$40*NUM_TILEMETAL/2>>$10
    sta.z bnkcpy_vram_address.num+3
    // [595] phi bnkcpy_vram_address::beg#0 = BANK_TILEMETAL [phi:main::@46->bnkcpy_vram_address#1] -- vduz1=vduc1 
    lda #<BANK_TILEMETAL
    sta.z bnkcpy_vram_address.beg
    lda #>BANK_TILEMETAL
    sta.z bnkcpy_vram_address.beg+1
    lda #<BANK_TILEMETAL>>$10
    sta.z bnkcpy_vram_address.beg+2
    lda #>BANK_TILEMETAL>>$10
    sta.z bnkcpy_vram_address.beg+3
    // [595] phi bnkcpy_vram_address::vdest#7 = VRAM_TILEMETAL [phi:main::@46->bnkcpy_vram_address#2] -- vduz1=vduc1 
    lda #<VRAM_TILEMETAL
    sta.z bnkcpy_vram_address.vdest
    lda #>VRAM_TILEMETAL
    sta.z bnkcpy_vram_address.vdest+1
    lda #<VRAM_TILEMETAL>>$10
    sta.z bnkcpy_vram_address.vdest+2
    lda #>VRAM_TILEMETAL>>$10
    sta.z bnkcpy_vram_address.vdest+3
    jsr bnkcpy_vram_address
    // [185] phi from main::@46 to main::@47 [phi:main::@46->main::@47]
    // main::@47
    // bnkcpy_vram_address(VRAM_SQUARERASTER, BANK_SQUARERASTER, (dword)64*64*(NUM_SQUARERASTER)/2)
    // [186] call bnkcpy_vram_address 
    // [595] phi from main::@47 to bnkcpy_vram_address [phi:main::@47->bnkcpy_vram_address]
    // [595] phi bnkcpy_vram_address::num#7 = $40*$40*NUM_SQUARERASTER/2 [phi:main::@47->bnkcpy_vram_address#0] -- vduz1=vduc1 
    lda #<$40*$40*NUM_SQUARERASTER/2
    sta.z bnkcpy_vram_address.num
    lda #>$40*$40*NUM_SQUARERASTER/2
    sta.z bnkcpy_vram_address.num+1
    lda #<$40*$40*NUM_SQUARERASTER/2>>$10
    sta.z bnkcpy_vram_address.num+2
    lda #>$40*$40*NUM_SQUARERASTER/2>>$10
    sta.z bnkcpy_vram_address.num+3
    // [595] phi bnkcpy_vram_address::beg#0 = BANK_SQUARERASTER [phi:main::@47->bnkcpy_vram_address#1] -- vduz1=vduc1 
    lda #<BANK_SQUARERASTER
    sta.z bnkcpy_vram_address.beg
    lda #>BANK_SQUARERASTER
    sta.z bnkcpy_vram_address.beg+1
    lda #<BANK_SQUARERASTER>>$10
    sta.z bnkcpy_vram_address.beg+2
    lda #>BANK_SQUARERASTER>>$10
    sta.z bnkcpy_vram_address.beg+3
    // [595] phi bnkcpy_vram_address::vdest#7 = VRAM_SQUARERASTER [phi:main::@47->bnkcpy_vram_address#2] -- vduz1=vduc1 
    lda #<VRAM_SQUARERASTER
    sta.z bnkcpy_vram_address.vdest
    lda #>VRAM_SQUARERASTER
    sta.z bnkcpy_vram_address.vdest+1
    lda #<VRAM_SQUARERASTER>>$10
    sta.z bnkcpy_vram_address.vdest+2
    lda #>VRAM_SQUARERASTER>>$10
    sta.z bnkcpy_vram_address.vdest+3
    jsr bnkcpy_vram_address
    // [187] phi from main::@47 to main::@48 [phi:main::@47->main::@48]
    // main::@48
    // bnkcpy_vram_address(VERA_PALETTE+32, BANK_PALETTE, (dword)32*6)
    // [188] call bnkcpy_vram_address 
  // Load the palette in VERA palette registers, but keep the first 16 colors untouched.
    // [595] phi from main::@48 to bnkcpy_vram_address [phi:main::@48->bnkcpy_vram_address]
    // [595] phi bnkcpy_vram_address::num#7 = $20*6 [phi:main::@48->bnkcpy_vram_address#0] -- vduz1=vduc1 
    lda #<$20*6
    sta.z bnkcpy_vram_address.num
    lda #>$20*6
    sta.z bnkcpy_vram_address.num+1
    lda #<$20*6>>$10
    sta.z bnkcpy_vram_address.num+2
    lda #>$20*6>>$10
    sta.z bnkcpy_vram_address.num+3
    // [595] phi bnkcpy_vram_address::beg#0 = BANK_PALETTE [phi:main::@48->bnkcpy_vram_address#1] -- vduz1=vduc1 
    lda #<BANK_PALETTE
    sta.z bnkcpy_vram_address.beg
    lda #>BANK_PALETTE
    sta.z bnkcpy_vram_address.beg+1
    lda #<BANK_PALETTE>>$10
    sta.z bnkcpy_vram_address.beg+2
    lda #>BANK_PALETTE>>$10
    sta.z bnkcpy_vram_address.beg+3
    // [595] phi bnkcpy_vram_address::vdest#7 = VERA_PALETTE+$20 [phi:main::@48->bnkcpy_vram_address#2] -- vduz1=vduc1 
    lda #<VERA_PALETTE+$20
    sta.z bnkcpy_vram_address.vdest
    lda #>VERA_PALETTE+$20
    sta.z bnkcpy_vram_address.vdest+1
    lda #<VERA_PALETTE+$20>>$10
    sta.z bnkcpy_vram_address.vdest+2
    lda #>VERA_PALETTE+$20>>$10
    sta.z bnkcpy_vram_address.vdest+3
    jsr bnkcpy_vram_address
    // main::vera_layer_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [189] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= vera_layer_enable[layer]
    // [190] *VERA_DC_VIDEO = *VERA_DC_VIDEO | *vera_layer_enable -- _deref_pbuc1=_deref_pbuc1_bor__deref_pbuc2 
    lda VERA_DC_VIDEO
    ora vera_layer_enable
    sta VERA_DC_VIDEO
    // [191] phi from main::vera_layer_show1 to main::@18 [phi:main::vera_layer_show1->main::@18]
    // main::@18
    // tile_background()
    // [192] call tile_background 
    // [638] phi from main::@18 to tile_background [phi:main::@18->tile_background]
    jsr tile_background
    // [193] phi from main::@18 to main::@49 [phi:main::@18->main::@49]
    // main::@49
    // create_sprites_player()
    // [194] call create_sprites_player 
    // [659] phi from main::@49 to create_sprites_player [phi:main::@49->create_sprites_player]
    jsr create_sprites_player
    // [195] phi from main::@49 to main::@50 [phi:main::@49->main::@50]
    // main::@50
    // create_sprites_enemy2()
    // [196] call create_sprites_enemy2 
    // [682] phi from main::@50 to create_sprites_enemy2 [phi:main::@50->create_sprites_enemy2]
    jsr create_sprites_enemy2
    // main::@51
    // *VERA_CTRL &= ~VERA_DCSEL
    // [197] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Enable sprites
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE
    // [198] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_SPRITES_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITES_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // main::SEI1
    // asm
    // asm { sei  }
    sei
    // main::@19
    // *KERNEL_IRQ = &irq_vsync
    // [200] *KERNEL_IRQ = &irq_vsync -- _deref_qprc1=pprc2 
    lda #<irq_vsync
    sta KERNEL_IRQ
    lda #>irq_vsync
    sta KERNEL_IRQ+1
    // *VERA_IEN = VERA_VSYNC
    // [201] *VERA_IEN = VERA_VSYNC -- _deref_pbuc1=vbuc2 
    lda #VERA_VSYNC
    sta VERA_IEN
    // main::CLI1
    // asm
    // asm { cli  }
    cli
    // [203] phi from main::@53 main::CLI1 to main::@15 [phi:main::@53/main::CLI1->main::@15]
    // main::@15
  __b15:
    // fgetc()
    // [204] call fgetc 
    jsr fgetc
    // [205] fgetc::return#2 = fgetc::return#1
    // main::@53
    // [206] main::$48 = fgetc::return#2
    // while(!fgetc())
    // [207] if(0==main::$48) goto main::@15 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b15
    // main::@16
    // VIA1->PORT_B = 4
    // [208] *((byte*)VIA1) = 4 -- _deref_pbuc1=vbuc2 
    lda #4
    sta VIA1
    // main::@return
    // }
    // [209] return 
    rts
  .segment Data
    s: .text "error file_sprites: "
    .byte 0
    s1: .text @"\n"
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
// rotate_sprites(word zp(7) base, word zp($43) rotate, word zp($41) max, word* zp($45) spriteaddresses, word zp(5) basex)
rotate_sprites: {
    .label __5 = 9
    .label __6 = 9
    .label __8 = 9
    .label __9 = 9
    .label __10 = 9
    .label __12 = 9
    .label __13 = 9
    .label __14 = 9
    .label i = 9
    .label s = 2
    .label rotate = $43
    .label max = $41
    .label spriteaddresses = $45
    .label basex = 5
    .label base = 7
    .label __15 = 9
    // [211] phi from rotate_sprites to rotate_sprites::@1 [phi:rotate_sprites->rotate_sprites::@1]
    // [211] phi rotate_sprites::s#2 = 0 [phi:rotate_sprites->rotate_sprites::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z s
    // rotate_sprites::@1
  __b1:
    // for(byte s=0;s<max;s++)
    // [212] if(rotate_sprites::s#2<rotate_sprites::max#5) goto rotate_sprites::@2 -- vbuz1_lt_vwuz2_then_la1 
    lda.z max+1
    bne __b2
    lda.z s
    cmp.z max
    bcc __b2
    // rotate_sprites::@return
    // }
    // [213] return 
    rts
    // rotate_sprites::@2
  __b2:
    // i = s+rotate
    // [214] rotate_sprites::i#0 = rotate_sprites::s#2 + rotate_sprites::rotate#4 -- vwuz1=vbuz2_plus_vwuz3 
    lda.z s
    clc
    adc.z rotate
    sta.z i
    lda #0
    adc.z rotate+1
    sta.z i+1
    // if(i>=max)
    // [215] if(rotate_sprites::i#0<rotate_sprites::max#5) goto rotate_sprites::@3 -- vwuz1_lt_vwuz2_then_la1 
    cmp.z max+1
    bcc __b3
    bne !+
    lda.z i
    cmp.z max
    bcc __b3
  !:
    // rotate_sprites::@4
    // i-=max
    // [216] rotate_sprites::i#1 = rotate_sprites::i#0 - rotate_sprites::max#5 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z i
    sec
    sbc.z max
    sta.z i
    lda.z i+1
    sbc.z max+1
    sta.z i+1
    // [217] phi from rotate_sprites::@2 rotate_sprites::@4 to rotate_sprites::@3 [phi:rotate_sprites::@2/rotate_sprites::@4->rotate_sprites::@3]
    // [217] phi rotate_sprites::i#2 = rotate_sprites::i#0 [phi:rotate_sprites::@2/rotate_sprites::@4->rotate_sprites::@3#0] -- register_copy 
    // rotate_sprites::@3
  __b3:
    // SPRITE_ATTR.ADDR = spriteaddresses[i]
    // [218] rotate_sprites::$12 = rotate_sprites::i#2 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z __12
    rol.z __12+1
    // [219] rotate_sprites::$15 = rotate_sprites::spriteaddresses#6 + rotate_sprites::$12 -- pwuz1=pwuz2_plus_vwuz1 
    lda.z __15
    clc
    adc.z spriteaddresses
    sta.z __15
    lda.z __15+1
    adc.z spriteaddresses+1
    sta.z __15+1
    // [220] *((word*)&SPRITE_ATTR) = *rotate_sprites::$15 -- _deref_pwuc1=_deref_pwuz1 
    ldy #0
    lda (__15),y
    sta SPRITE_ATTR
    iny
    lda (__15),y
    sta SPRITE_ATTR+1
    // s&03
    // [221] rotate_sprites::$4 = rotate_sprites::s#2 & 3 -- vbuaa=vbuz1_band_vbuc1 
    lda #3
    and.z s
    // (word)(s&03)<<6
    // [222] rotate_sprites::$13 = (word)rotate_sprites::$4 -- vwuz1=_word_vbuaa 
    sta.z __13
    lda #0
    sta.z __13+1
    // [223] rotate_sprites::$5 = rotate_sprites::$13 << 6 -- vwuz1=vwuz1_rol_6 
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
    // basex+((word)(s&03)<<6)
    // [224] rotate_sprites::$6 = rotate_sprites::basex#6 + rotate_sprites::$5 -- vwuz1=vwuz2_plus_vwuz1 
    lda.z __6
    clc
    adc.z basex
    sta.z __6
    lda.z __6+1
    adc.z basex+1
    sta.z __6+1
    // SPRITE_ATTR.X = basex+((word)(s&03)<<6)
    // [225] *((word*)&SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X) = rotate_sprites::$6 -- _deref_pwuc1=vwuz1 
    lda.z __6
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X
    lda.z __6+1
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X+1
    // s>>2
    // [226] rotate_sprites::$7 = rotate_sprites::s#2 >> 2 -- vbuaa=vbuz1_ror_2 
    lda.z s
    lsr
    lsr
    // (word)(s>>2)<<6
    // [227] rotate_sprites::$14 = (word)rotate_sprites::$7 -- vwuz1=_word_vbuaa 
    sta.z __14
    lda #0
    sta.z __14+1
    // [228] rotate_sprites::$8 = rotate_sprites::$14 << 6 -- vwuz1=vwuz1_rol_6 
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
    // basey+((word)(s>>2)<<6)
    // [229] rotate_sprites::$9 = $64 + rotate_sprites::$8 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$64
    clc
    adc.z __9
    sta.z __9
    bcc !+
    inc.z __9+1
  !:
    // SPRITE_ATTR.Y = basey+((word)(s>>2)<<6)
    // [230] *((word*)&SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y) = rotate_sprites::$9 -- _deref_pwuc1=vwuz1 
    lda.z __9
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y
    lda.z __9+1
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y+1
    // s+base
    // [231] rotate_sprites::$10 = rotate_sprites::s#2 + rotate_sprites::base#6 -- vwuz1=vbuz2_plus_vwuz3 
    lda.z s
    clc
    adc.z base
    sta.z __10
    lda #0
    adc.z base+1
    sta.z __10+1
    // vera_sprite_attributes_set((byte)(s+base),SPRITE_ATTR)
    // [232] vera_sprite_attributes_set::sprite#0 = (byte)rotate_sprites::$10 -- vbuxx=_byte_vwuz1 
    lda.z __10
    tax
    // [233] *(&vera_sprite_attributes_set::sprite_attr) = memcpy(*(&SPRITE_ATTR), struct VERA_SPRITE, SIZEOF_STRUCT_VERA_SPRITE) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_VERA_SPRITE
  !:
    lda SPRITE_ATTR-1,y
    sta vera_sprite_attributes_set.sprite_attr-1,y
    dey
    bne !-
    // [234] call vera_sprite_attributes_set 
  // Copy sprite positions to VRAM (the 4 relevant bytes in VERA_SPRITE_ATTR)
    // [710] phi from rotate_sprites::@3 to vera_sprite_attributes_set [phi:rotate_sprites::@3->vera_sprite_attributes_set]
    // [710] phi vera_sprite_attributes_set::sprite#3 = vera_sprite_attributes_set::sprite#0 [phi:rotate_sprites::@3->vera_sprite_attributes_set#0] -- register_copy 
    jsr vera_sprite_attributes_set
    // rotate_sprites::@5
    // for(byte s=0;s<max;s++)
    // [235] rotate_sprites::s#1 = ++ rotate_sprites::s#2 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [211] phi from rotate_sprites::@5 to rotate_sprites::@1 [phi:rotate_sprites::@5->rotate_sprites::@1]
    // [211] phi rotate_sprites::s#2 = rotate_sprites::s#1 [phi:rotate_sprites::@5->rotate_sprites::@1#0] -- register_copy 
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
// memcpy_in_vram(byte zp($d) dest_bank, void* zp($b) dest, byte register(Y) src_bank, byte* zp($55) src, word zp($53) num)
memcpy_in_vram: {
    .label i = $b
    .label dest = $b
    .label src = $55
    .label num = $53
    .label dest_bank = $d
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [237] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <src
    // [238] memcpy_in_vram::$0 = < memcpy_in_vram::src#3 -- vbuaa=_lo_pvoz1 
    lda.z src
    // *VERA_ADDRX_L = <src
    // [239] *VERA_ADDRX_L = memcpy_in_vram::$0 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >src
    // [240] memcpy_in_vram::$1 = > memcpy_in_vram::src#3 -- vbuaa=_hi_pvoz1 
    lda.z src+1
    // *VERA_ADDRX_M = >src
    // [241] *VERA_ADDRX_M = memcpy_in_vram::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // src_increment | src_bank
    // [242] memcpy_in_vram::$2 = VERA_INC_1 | memcpy_in_vram::src_bank#3 -- vbuaa=vbuc1_bor_vbuyy 
    tya
    ora #VERA_INC_1
    // *VERA_ADDRX_H = src_increment | src_bank
    // [243] *VERA_ADDRX_H = memcpy_in_vram::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [244] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    // Select DATA1
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // <dest
    // [245] memcpy_in_vram::$3 = < memcpy_in_vram::dest#3 -- vbuaa=_lo_pvoz1 
    lda.z dest
    // *VERA_ADDRX_L = <dest
    // [246] *VERA_ADDRX_L = memcpy_in_vram::$3 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >dest
    // [247] memcpy_in_vram::$4 = > memcpy_in_vram::dest#3 -- vbuaa=_hi_pvoz1 
    lda.z dest+1
    // *VERA_ADDRX_M = >dest
    // [248] *VERA_ADDRX_M = memcpy_in_vram::$4 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // dest_increment | dest_bank
    // [249] memcpy_in_vram::$5 = VERA_INC_1 | memcpy_in_vram::dest_bank#3 -- vbuaa=vbuc1_bor_vbuz1 
    lda #VERA_INC_1
    ora.z dest_bank
    // *VERA_ADDRX_H = dest_increment | dest_bank
    // [250] *VERA_ADDRX_H = memcpy_in_vram::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [251] phi from memcpy_in_vram to memcpy_in_vram::@1 [phi:memcpy_in_vram->memcpy_in_vram::@1]
    // [251] phi memcpy_in_vram::i#2 = 0 [phi:memcpy_in_vram->memcpy_in_vram::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // memcpy_in_vram::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [252] if(memcpy_in_vram::i#2<memcpy_in_vram::num#4) goto memcpy_in_vram::@2 -- vwuz1_lt_vwuz2_then_la1 
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
    // [253] return 
    rts
    // memcpy_in_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [254] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [255] memcpy_in_vram::i#1 = ++ memcpy_in_vram::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [251] phi from memcpy_in_vram::@2 to memcpy_in_vram::@1 [phi:memcpy_in_vram::@2->memcpy_in_vram::@1]
    // [251] phi memcpy_in_vram::i#2 = memcpy_in_vram::i#1 [phi:memcpy_in_vram::@2->memcpy_in_vram::@1#0] -- register_copy 
    jmp __b1
}
  // rand
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
rand: {
    .label __0 = $55
    .label __1 = $53
    .label __2 = $b
    .label return = $b
    // rand_state << 7
    // [257] rand::$0 = rand_state#13 << 7 -- vwuz1=vwuz2_rol_7 
    lda.z rand_state+1
    lsr
    lda.z rand_state
    ror
    sta.z __0+1
    lda #0
    ror
    sta.z __0
    // rand_state ^= rand_state << 7
    // [258] rand_state#0 = rand_state#13 ^ rand::$0 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __0
    sta.z rand_state
    lda.z rand_state+1
    eor.z __0+1
    sta.z rand_state+1
    // rand_state >> 9
    // [259] rand::$1 = rand_state#0 >> 9 -- vwuz1=vwuz2_ror_9 
    lsr
    sta.z __1
    lda #0
    sta.z __1+1
    // rand_state ^= rand_state >> 9
    // [260] rand_state#1 = rand_state#0 ^ rand::$1 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __1
    sta.z rand_state
    lda.z rand_state+1
    eor.z __1+1
    sta.z rand_state+1
    // rand_state << 8
    // [261] rand::$2 = rand_state#1 << 8 -- vwuz1=vwuz2_rol_8 
    lda.z rand_state
    sta.z __2+1
    lda #0
    sta.z __2
    // rand_state ^= rand_state << 8
    // [262] rand_state#14 = rand_state#1 ^ rand::$2 -- vwuz1=vwuz1_bxor_vwuz2 
    lda.z rand_state
    eor.z __2
    sta.z rand_state
    lda.z rand_state+1
    eor.z __2+1
    sta.z rand_state+1
    // return rand_state;
    // [263] rand::return#0 = rand_state#14 -- vwuz1=vwuz2 
    lda.z rand_state
    sta.z return
    lda.z rand_state+1
    sta.z return+1
    // rand::@return
    // }
    // [264] return 
    rts
}
  // modr16u
// Performs modulo on two 16 bit unsigned ints and an initial remainder
// Returns the remainder.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// modr16u(word zp($b) dividend, word zp($55) rem)
modr16u: {
    .label rem = $55
    .label dividend = $b
    .label quotient = $53
    .label return = $55
    // [266] phi from modr16u to modr16u::@1 [phi:modr16u->modr16u::@1]
    // [266] phi modr16u::i#2 = 0 [phi:modr16u->modr16u::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [266] phi modr16u::quotient#3 = 0 [phi:modr16u->modr16u::@1#1] -- vwuz1=vwuc1 
    txa
    sta.z quotient
    sta.z quotient+1
    // [266] phi modr16u::dividend#3 = modr16u::dividend#5 [phi:modr16u->modr16u::@1#2] -- register_copy 
    // [266] phi modr16u::rem#5 = 0 [phi:modr16u->modr16u::@1#3] -- vwuz1=vbuc1 
    sta.z rem
    sta.z rem+1
    // [266] phi from modr16u::@3 to modr16u::@1 [phi:modr16u::@3->modr16u::@1]
    // [266] phi modr16u::i#2 = modr16u::i#1 [phi:modr16u::@3->modr16u::@1#0] -- register_copy 
    // [266] phi modr16u::quotient#3 = modr16u::quotient#7 [phi:modr16u::@3->modr16u::@1#1] -- register_copy 
    // [266] phi modr16u::dividend#3 = modr16u::dividend#0 [phi:modr16u::@3->modr16u::@1#2] -- register_copy 
    // [266] phi modr16u::rem#5 = modr16u::return#0 [phi:modr16u::@3->modr16u::@1#3] -- register_copy 
    // modr16u::@1
  __b1:
    // rem = rem << 1
    // [267] modr16u::rem#0 = modr16u::rem#5 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z rem
    rol.z rem+1
    // >dividend
    // [268] modr16u::$1 = > modr16u::dividend#3 -- vbuaa=_hi_vwuz1 
    lda.z dividend+1
    // >dividend & $80
    // [269] modr16u::$2 = modr16u::$1 & $80 -- vbuaa=vbuaa_band_vbuc1 
    and #$80
    // if( (>dividend & $80) != 0 )
    // [270] if(modr16u::$2==0) goto modr16u::@2 -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b2
    // modr16u::@4
    // rem = rem | 1
    // [271] modr16u::rem#1 = modr16u::rem#0 | 1 -- vwuz1=vwuz1_bor_vbuc1 
    lda #1
    ora.z rem
    sta.z rem
    // [272] phi from modr16u::@1 modr16u::@4 to modr16u::@2 [phi:modr16u::@1/modr16u::@4->modr16u::@2]
    // [272] phi modr16u::rem#6 = modr16u::rem#0 [phi:modr16u::@1/modr16u::@4->modr16u::@2#0] -- register_copy 
    // modr16u::@2
  __b2:
    // dividend = dividend << 1
    // [273] modr16u::dividend#0 = modr16u::dividend#3 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z dividend
    rol.z dividend+1
    // quotient = quotient << 1
    // [274] modr16u::quotient#1 = modr16u::quotient#3 << 1 -- vwuz1=vwuz1_rol_1 
    asl.z quotient
    rol.z quotient+1
    // if(rem>=divisor)
    // [275] if(modr16u::rem#6<3) goto modr16u::@3 -- vwuz1_lt_vbuc1_then_la1 
    lda.z rem+1
    bne !+
    lda.z rem
    cmp #3
    bcc __b3
  !:
    // modr16u::@5
    // quotient++;
    // [276] modr16u::quotient#2 = ++ modr16u::quotient#1 -- vwuz1=_inc_vwuz1 
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    // rem = rem - divisor
    // [277] modr16u::rem#2 = modr16u::rem#6 - 3 -- vwuz1=vwuz1_minus_vbuc1 
    sec
    lda.z rem
    sbc #3
    sta.z rem
    lda.z rem+1
    sbc #0
    sta.z rem+1
    // [278] phi from modr16u::@2 modr16u::@5 to modr16u::@3 [phi:modr16u::@2/modr16u::@5->modr16u::@3]
    // [278] phi modr16u::quotient#7 = modr16u::quotient#1 [phi:modr16u::@2/modr16u::@5->modr16u::@3#0] -- register_copy 
    // [278] phi modr16u::return#0 = modr16u::rem#6 [phi:modr16u::@2/modr16u::@5->modr16u::@3#1] -- register_copy 
    // modr16u::@3
  __b3:
    // for( char i : 0..15)
    // [279] modr16u::i#1 = ++ modr16u::i#2 -- vbuxx=_inc_vbuxx 
    inx
    // [280] if(modr16u::i#1!=$10) goto modr16u::@1 -- vbuxx_neq_vbuc1_then_la1 
    cpx #$10
    bne __b1
    // modr16u::@return
    // }
    // [281] return 
    rts
}
  // vera_tile_element
// vera_tile_element(byte register(X) x, byte zp($e) y, byte* zp($b) Tile)
vera_tile_element: {
    .label __3 = $b
    .label __18 = $b
    .label vera_vram_address01___0 = $b
    .label vera_vram_address01___2 = $b
    .label vera_vram_address01___4 = $55
    .label TileOffset = $4e
    .label TileTotal = $4f
    .label TileCount = $50
    .label TileColumns = $51
    .label PaletteOffset = $52
    .label y = $e
    .label mapbase = $f
    .label shift = $d
    .label rowskip = $53
    .label j = $d
    .label i = $e
    .label r = $13
    .label x = $d
    .label Tile = $b
    // TileOffset = Tile[0]
    // [283] vera_tile_element::TileOffset#0 = *vera_tile_element::Tile#2 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (Tile),y
    sta.z TileOffset
    // TileTotal = Tile[1]
    // [284] vera_tile_element::TileTotal#0 = vera_tile_element::Tile#2[1] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #1
    lda (Tile),y
    sta.z TileTotal
    // TileCount = Tile[2]
    // [285] vera_tile_element::TileCount#0 = vera_tile_element::Tile#2[2] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #2
    lda (Tile),y
    sta.z TileCount
    // TileColumns = Tile[4]
    // [286] vera_tile_element::TileColumns#0 = vera_tile_element::Tile#2[4] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #4
    lda (Tile),y
    sta.z TileColumns
    // PaletteOffset = Tile[5]
    // [287] vera_tile_element::PaletteOffset#0 = vera_tile_element::Tile#2[5] -- vbuz1=pbuz2_derefidx_vbuc1 
    ldy #5
    lda (Tile),y
    sta.z PaletteOffset
    // x = x << resolution
    // [288] vera_tile_element::x#0 = vera_tile_element::x#3 << 3 -- vbuxx=vbuz1_rol_3 
    lda.z x
    asl
    asl
    asl
    tax
    // y = y << resolution
    // [289] vera_tile_element::y#0 = vera_tile_element::y#3 << 3 -- vbuz1=vbuz1_rol_3 
    lda.z y
    asl
    asl
    asl
    sta.z y
    // mapbase = vera_mapbase_address[layer]
    // [290] vera_tile_element::mapbase#0 = *vera_mapbase_address -- vduz1=_deref_pduc1 
    lda vera_mapbase_address
    sta.z mapbase
    lda vera_mapbase_address+1
    sta.z mapbase+1
    lda vera_mapbase_address+2
    sta.z mapbase+2
    lda vera_mapbase_address+3
    sta.z mapbase+3
    // shift = vera_layer_rowshift[layer]
    // [291] vera_tile_element::shift#0 = *vera_layer_rowshift -- vbuz1=_deref_pbuc1 
    lda vera_layer_rowshift
    sta.z shift
    // rowskip = (word)1 << shift
    // [292] vera_tile_element::rowskip#0 = 1 << vera_tile_element::shift#0 -- vwuz1=vwuc1_rol_vbuz2 
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
    // [293] vera_tile_element::$18 = (word)vera_tile_element::y#0 -- vwuz1=_word_vbuz2 
    lda.z y
    sta.z __18
    lda #0
    sta.z __18+1
    // [294] vera_tile_element::$3 = vera_tile_element::$18 << vera_tile_element::shift#0 -- vwuz1=vwuz1_rol_vbuz2 
    ldy.z shift
    beq !e+
  !:
    asl.z __3
    rol.z __3+1
    dey
    bne !-
  !e:
    // mapbase += ((word)y << shift)
    // [295] vera_tile_element::mapbase#1 = vera_tile_element::mapbase#0 + vera_tile_element::$3 -- vduz1=vduz1_plus_vwuz2 
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
    // [296] vera_tile_element::$4 = vera_tile_element::x#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // mapbase += (x << 1)
    // [297] vera_tile_element::mapbase#2 = vera_tile_element::mapbase#1 + vera_tile_element::$4 -- vduz1=vduz1_plus_vbuaa 
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
    // [298] phi from vera_tile_element to vera_tile_element::@1 [phi:vera_tile_element->vera_tile_element::@1]
    // [298] phi vera_tile_element::mapbase#11 = vera_tile_element::mapbase#2 [phi:vera_tile_element->vera_tile_element::@1#0] -- register_copy 
    // [298] phi vera_tile_element::j#2 = 0 [phi:vera_tile_element->vera_tile_element::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z j
    // vera_tile_element::@1
  __b1:
    // for(byte j=0;j<TileTotal;j+=(TileTotal>>1))
    // [299] if(vera_tile_element::j#2<vera_tile_element::TileTotal#0) goto vera_tile_element::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z j
    cmp.z TileTotal
    bcc __b3
    // vera_tile_element::@return
    // }
    // [300] return 
    rts
    // [301] phi from vera_tile_element::@1 to vera_tile_element::@2 [phi:vera_tile_element::@1->vera_tile_element::@2]
  __b3:
    // [301] phi vera_tile_element::mapbase#10 = vera_tile_element::mapbase#11 [phi:vera_tile_element::@1->vera_tile_element::@2#0] -- register_copy 
    // [301] phi vera_tile_element::i#10 = 0 [phi:vera_tile_element::@1->vera_tile_element::@2#1] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // vera_tile_element::@2
  __b2:
    // for(byte i=0;i<TileCount;i+=(TileColumns))
    // [302] if(vera_tile_element::i#10<vera_tile_element::TileCount#0) goto vera_tile_element::vera_vram_address01 -- vbuz1_lt_vbuz2_then_la1 
    lda.z i
    cmp.z TileCount
    bcc vera_vram_address01
    // vera_tile_element::@3
    // TileTotal>>1
    // [303] vera_tile_element::$16 = vera_tile_element::TileTotal#0 >> 1 -- vbuaa=vbuz1_ror_1 
    lda.z TileTotal
    lsr
    // j+=(TileTotal>>1)
    // [304] vera_tile_element::j#1 = vera_tile_element::j#2 + vera_tile_element::$16 -- vbuz1=vbuz1_plus_vbuaa 
    clc
    adc.z j
    sta.z j
    // [298] phi from vera_tile_element::@3 to vera_tile_element::@1 [phi:vera_tile_element::@3->vera_tile_element::@1]
    // [298] phi vera_tile_element::mapbase#11 = vera_tile_element::mapbase#10 [phi:vera_tile_element::@3->vera_tile_element::@1#0] -- register_copy 
    // [298] phi vera_tile_element::j#2 = vera_tile_element::j#1 [phi:vera_tile_element::@3->vera_tile_element::@1#1] -- register_copy 
    jmp __b1
    // vera_tile_element::vera_vram_address01
  vera_vram_address01:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [305] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <bankaddr
    // [306] vera_tile_element::vera_vram_address01_$0 = < vera_tile_element::mapbase#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase
    sta.z vera_vram_address01___0
    lda.z mapbase+1
    sta.z vera_vram_address01___0+1
    // <(<bankaddr)
    // [307] vera_tile_element::vera_vram_address01_$1 = < vera_tile_element::vera_vram_address01_$0 -- vbuaa=_lo_vwuz1 
    lda.z vera_vram_address01___0
    // *VERA_ADDRX_L = <(<bankaddr)
    // [308] *VERA_ADDRX_L = vera_tile_element::vera_vram_address01_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // <bankaddr
    // [309] vera_tile_element::vera_vram_address01_$2 = < vera_tile_element::mapbase#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase
    sta.z vera_vram_address01___2
    lda.z mapbase+1
    sta.z vera_vram_address01___2+1
    // >(<bankaddr)
    // [310] vera_tile_element::vera_vram_address01_$3 = > vera_tile_element::vera_vram_address01_$2 -- vbuaa=_hi_vwuz1 
    // *VERA_ADDRX_M = >(<bankaddr)
    // [311] *VERA_ADDRX_M = vera_tile_element::vera_vram_address01_$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // >bankaddr
    // [312] vera_tile_element::vera_vram_address01_$4 = > vera_tile_element::mapbase#10 -- vwuz1=_hi_vduz2 
    lda.z mapbase+2
    sta.z vera_vram_address01___4
    lda.z mapbase+3
    sta.z vera_vram_address01___4+1
    // <(>bankaddr)
    // [313] vera_tile_element::vera_vram_address01_$5 = < vera_tile_element::vera_vram_address01_$4 -- vbuaa=_lo_vwuz1 
    lda.z vera_vram_address01___4
    // <(>bankaddr) | incr
    // [314] vera_tile_element::vera_vram_address01_$6 = vera_tile_element::vera_vram_address01_$5 | VERA_INC_1 -- vbuaa=vbuaa_bor_vbuc1 
    ora #VERA_INC_1
    // *VERA_ADDRX_H = <(>bankaddr) | incr
    // [315] *VERA_ADDRX_H = vera_tile_element::vera_vram_address01_$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [316] phi from vera_tile_element::vera_vram_address01 to vera_tile_element::@4 [phi:vera_tile_element::vera_vram_address01->vera_tile_element::@4]
    // [316] phi vera_tile_element::r#2 = 0 [phi:vera_tile_element::vera_vram_address01->vera_tile_element::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z r
    // vera_tile_element::@4
  __b4:
    // TileTotal>>1
    // [317] vera_tile_element::$8 = vera_tile_element::TileTotal#0 >> 1 -- vbuaa=vbuz1_ror_1 
    lda.z TileTotal
    lsr
    // for(byte r=0;r<(TileTotal>>1);r+=TileCount)
    // [318] if(vera_tile_element::r#2<vera_tile_element::$8) goto vera_tile_element::@6 -- vbuz1_lt_vbuaa_then_la1 
    cmp.z r
    beq !+
    bcs __b5
  !:
    // vera_tile_element::@5
    // mapbase += rowskip
    // [319] vera_tile_element::mapbase#3 = vera_tile_element::mapbase#10 + vera_tile_element::rowskip#0 -- vduz1=vduz1_plus_vwuz2 
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
    // [320] vera_tile_element::i#1 = vera_tile_element::i#10 + vera_tile_element::TileColumns#0 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z i
    clc
    adc.z TileColumns
    sta.z i
    // [301] phi from vera_tile_element::@5 to vera_tile_element::@2 [phi:vera_tile_element::@5->vera_tile_element::@2]
    // [301] phi vera_tile_element::mapbase#10 = vera_tile_element::mapbase#3 [phi:vera_tile_element::@5->vera_tile_element::@2#0] -- register_copy 
    // [301] phi vera_tile_element::i#10 = vera_tile_element::i#1 [phi:vera_tile_element::@5->vera_tile_element::@2#1] -- register_copy 
    jmp __b2
    // [321] phi from vera_tile_element::@4 to vera_tile_element::@6 [phi:vera_tile_element::@4->vera_tile_element::@6]
  __b5:
    // [321] phi vera_tile_element::c#2 = 0 [phi:vera_tile_element::@4->vera_tile_element::@6#0] -- vbuxx=vbuc1 
    ldx #0
    // vera_tile_element::@6
  __b6:
    // for(byte c=0;c<TileColumns;c+=1)
    // [322] if(vera_tile_element::c#2<vera_tile_element::TileColumns#0) goto vera_tile_element::@7 -- vbuxx_lt_vbuz1_then_la1 
    cpx.z TileColumns
    bcc __b7
    // vera_tile_element::@8
    // r+=TileCount
    // [323] vera_tile_element::r#1 = vera_tile_element::r#2 + vera_tile_element::TileCount#0 -- vbuz1=vbuz1_plus_vbuz2 
    lda.z r
    clc
    adc.z TileCount
    sta.z r
    // [316] phi from vera_tile_element::@8 to vera_tile_element::@4 [phi:vera_tile_element::@8->vera_tile_element::@4]
    // [316] phi vera_tile_element::r#2 = vera_tile_element::r#1 [phi:vera_tile_element::@8->vera_tile_element::@4#0] -- register_copy 
    jmp __b4
    // vera_tile_element::@7
  __b7:
    // TileOffset+c
    // [324] vera_tile_element::$11 = vera_tile_element::TileOffset#0 + vera_tile_element::c#2 -- vbuaa=vbuz1_plus_vbuxx 
    txa
    clc
    adc.z TileOffset
    // TileOffset+c+r
    // [325] vera_tile_element::$12 = vera_tile_element::$11 + vera_tile_element::r#2 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z r
    // TileOffset+c+r+i
    // [326] vera_tile_element::$13 = vera_tile_element::$12 + vera_tile_element::i#10 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z i
    // TileOffset+c+r+i+j
    // [327] vera_tile_element::$14 = vera_tile_element::$13 + vera_tile_element::j#2 -- vbuaa=vbuaa_plus_vbuz1 
    clc
    adc.z j
    // *VERA_DATA0 = TileOffset+c+r+i+j
    // [328] *VERA_DATA0 = vera_tile_element::$14 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // PaletteOffset << 4
    // [329] vera_tile_element::$15 = vera_tile_element::PaletteOffset#0 << 4 -- vbuaa=vbuz1_rol_4 
    lda.z PaletteOffset
    asl
    asl
    asl
    asl
    // *VERA_DATA0 = PaletteOffset << 4
    // [330] *VERA_DATA0 = vera_tile_element::$15 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // c+=1
    // [331] vera_tile_element::c#1 = vera_tile_element::c#2 + 1 -- vbuxx=vbuxx_plus_1 
    inx
    // [321] phi from vera_tile_element::@7 to vera_tile_element::@6 [phi:vera_tile_element::@7->vera_tile_element::@6]
    // [321] phi vera_tile_element::c#2 = vera_tile_element::c#1 [phi:vera_tile_element::@7->vera_tile_element::@6#0] -- register_copy 
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
    // [333] call vera_layer_mode_tile 
    // [408] phi from vera_layer_mode_text to vera_layer_mode_tile [phi:vera_layer_mode_text->vera_layer_mode_tile]
    // [408] phi vera_layer_mode_tile::tileheight#10 = vera_layer_mode_text::tileheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#0] -- vbuz1=vbuc1 
    lda #tileheight
    sta.z vera_layer_mode_tile.tileheight
    // [408] phi vera_layer_mode_tile::tilewidth#10 = vera_layer_mode_text::tilewidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#1] -- vbuz1=vbuc1 
    lda #tilewidth
    sta.z vera_layer_mode_tile.tilewidth
    // [408] phi vera_layer_mode_tile::tilebase_address#10 = vera_layer_mode_text::tilebase_address#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#2] -- vduz1=vduc1 
    lda #<tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address
    lda #>tilebase_address
    sta.z vera_layer_mode_tile.tilebase_address+1
    lda #<tilebase_address>>$10
    sta.z vera_layer_mode_tile.tilebase_address+2
    lda #>tilebase_address>>$10
    sta.z vera_layer_mode_tile.tilebase_address+3
    // [408] phi vera_layer_mode_tile::mapbase_address#10 = vera_layer_mode_text::mapbase_address#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#3] -- vduz1=vduc1 
    lda #<mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address
    lda #>mapbase_address
    sta.z vera_layer_mode_tile.mapbase_address+1
    lda #<mapbase_address>>$10
    sta.z vera_layer_mode_tile.mapbase_address+2
    lda #>mapbase_address>>$10
    sta.z vera_layer_mode_tile.mapbase_address+3
    // [408] phi vera_layer_mode_tile::mapheight#10 = vera_layer_mode_text::mapheight#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#4] -- vwuz1=vwuc1 
    lda #<mapheight
    sta.z vera_layer_mode_tile.mapheight
    lda #>mapheight
    sta.z vera_layer_mode_tile.mapheight+1
    // [408] phi vera_layer_mode_tile::layer#10 = vera_layer_mode_text::layer#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#5] -- vbuz1=vbuc1 
    lda #layer
    sta.z vera_layer_mode_tile.layer
    // [408] phi vera_layer_mode_tile::mapwidth#10 = vera_layer_mode_text::mapwidth#0 [phi:vera_layer_mode_text->vera_layer_mode_tile#6] -- vwuz1=vwuc1 
    lda #<mapwidth
    sta.z vera_layer_mode_tile.mapwidth
    lda #>mapwidth
    sta.z vera_layer_mode_tile.mapwidth+1
    // [408] phi vera_layer_mode_tile::color_depth#3 = 1 [phi:vera_layer_mode_text->vera_layer_mode_tile#7] -- vbuxx=vbuc1 
    ldx #1
    jsr vera_layer_mode_tile
    // [334] phi from vera_layer_mode_text to vera_layer_mode_text::@1 [phi:vera_layer_mode_text->vera_layer_mode_text::@1]
    // vera_layer_mode_text::@1
    // vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C )
    // [335] call vera_layer_set_text_color_mode 
    jsr vera_layer_set_text_color_mode
    // vera_layer_mode_text::@return
    // }
    // [336] return 
    rts
}
  // screensize
// Return the current screen size.
screensize: {
    .label x = conio_screen_width
    .label y = conio_screen_height
    // hscale = (*VERA_DC_HSCALE) >> 7
    // [337] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuaa=_deref_pbuc1_ror_7 
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    // 40 << hscale
    // [338] screensize::$1 = $28 << screensize::hscale#0 -- vbuaa=vbuc1_rol_vbuaa 
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
    // [339] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbuaa 
    sta.z x
    // vscale = (*VERA_DC_VSCALE) >> 7
    // [340] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuaa=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    // 30 << vscale
    // [341] screensize::$3 = $1e << screensize::vscale#0 -- vbuaa=vbuc1_rol_vbuaa 
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
    // [342] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbuaa 
    sta.z y
    // screensize::@return
    // }
    // [343] return 
    rts
}
  // screenlayer
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer: {
    .label __2 = $5a
    .label __4 = $5c
    .label __5 = $5a
    .label vera_layer_get_width1_config = $5a
    .label vera_layer_get_width1_return = $5a
    .label vera_layer_get_height1_config = $5a
    .label vera_layer_get_height1_return = $5a
    // conio_screen_layer = layer
    // [344] conio_screen_layer = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z conio_screen_layer
    // vera_layer_get_mapbase_bank(conio_screen_layer)
    // [345] vera_layer_get_mapbase_bank::layer#0 = conio_screen_layer -- vbuxx=vbuz1 
    tax
    // [346] call vera_layer_get_mapbase_bank 
    jsr vera_layer_get_mapbase_bank
    // [347] vera_layer_get_mapbase_bank::return#2 = vera_layer_get_mapbase_bank::return#0
    // screenlayer::@3
    // [348] CONIO_SCREEN_BANK#112 = vera_layer_get_mapbase_bank::return#2 -- vbuz1=vbuaa 
    sta.z CONIO_SCREEN_BANK
    // vera_layer_get_mapbase_offset(conio_screen_layer)
    // [349] vera_layer_get_mapbase_offset::layer#0 = conio_screen_layer -- vbuaa=vbuz1 
    lda.z conio_screen_layer
    // [350] call vera_layer_get_mapbase_offset 
    jsr vera_layer_get_mapbase_offset
    // [351] vera_layer_get_mapbase_offset::return#2 = vera_layer_get_mapbase_offset::return#0
    // screenlayer::@4
    // [352] CONIO_SCREEN_TEXT#118 = vera_layer_get_mapbase_offset::return#2 -- vwuz1=vwuz2 
    lda.z vera_layer_get_mapbase_offset.return
    sta.z CONIO_SCREEN_TEXT
    lda.z vera_layer_get_mapbase_offset.return+1
    sta.z CONIO_SCREEN_TEXT+1
    // vera_layer_get_width(conio_screen_layer)
    // [353] screenlayer::vera_layer_get_width1_layer#0 = conio_screen_layer -- vbuaa=vbuz1 
    lda.z conio_screen_layer
    // screenlayer::vera_layer_get_width1
    // config = vera_layer_config[layer]
    // [354] screenlayer::vera_layer_get_width1_$2 = screenlayer::vera_layer_get_width1_layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [355] screenlayer::vera_layer_get_width1_config#0 = vera_layer_config[screenlayer::vera_layer_get_width1_$2] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z vera_layer_get_width1_config
    lda vera_layer_config+1,y
    sta.z vera_layer_get_width1_config+1
    // *config & VERA_LAYER_WIDTH_MASK
    // [356] screenlayer::vera_layer_get_width1_$0 = *screenlayer::vera_layer_get_width1_config#0 & VERA_LAYER_WIDTH_MASK -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    ldy #0
    and (vera_layer_get_width1_config),y
    // (*config & VERA_LAYER_WIDTH_MASK) >> 4
    // [357] screenlayer::vera_layer_get_width1_$1 = screenlayer::vera_layer_get_width1_$0 >> 4 -- vbuaa=vbuaa_ror_4 
    lsr
    lsr
    lsr
    lsr
    // return VERA_LAYER_WIDTH[ (*config & VERA_LAYER_WIDTH_MASK) >> 4];
    // [358] screenlayer::vera_layer_get_width1_$3 = screenlayer::vera_layer_get_width1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [359] screenlayer::vera_layer_get_width1_return#0 = VERA_LAYER_WIDTH[screenlayer::vera_layer_get_width1_$3] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda VERA_LAYER_WIDTH,y
    sta.z vera_layer_get_width1_return
    lda VERA_LAYER_WIDTH+1,y
    sta.z vera_layer_get_width1_return+1
    // screenlayer::vera_layer_get_width1_@return
    // }
    // [360] screenlayer::vera_layer_get_width1_return#1 = screenlayer::vera_layer_get_width1_return#0
    // screenlayer::@1
    // vera_layer_get_width(conio_screen_layer)
    // [361] screenlayer::$2 = screenlayer::vera_layer_get_width1_return#1
    // conio_width = vera_layer_get_width(conio_screen_layer)
    // [362] conio_width = screenlayer::$2 -- vwuz1=vwuz2 
    lda.z __2
    sta.z conio_width
    lda.z __2+1
    sta.z conio_width+1
    // vera_layer_get_rowshift(conio_screen_layer)
    // [363] vera_layer_get_rowshift::layer#0 = conio_screen_layer -- vbuxx=vbuz1 
    ldx.z conio_screen_layer
    // [364] call vera_layer_get_rowshift 
    jsr vera_layer_get_rowshift
    // [365] vera_layer_get_rowshift::return#2 = vera_layer_get_rowshift::return#0
    // screenlayer::@5
    // [366] screenlayer::$3 = vera_layer_get_rowshift::return#2
    // conio_rowshift = vera_layer_get_rowshift(conio_screen_layer)
    // [367] conio_rowshift = screenlayer::$3 -- vbuz1=vbuaa 
    sta.z conio_rowshift
    // vera_layer_get_rowskip(conio_screen_layer)
    // [368] vera_layer_get_rowskip::layer#0 = conio_screen_layer -- vbuaa=vbuz1 
    lda.z conio_screen_layer
    // [369] call vera_layer_get_rowskip 
    jsr vera_layer_get_rowskip
    // [370] vera_layer_get_rowskip::return#2 = vera_layer_get_rowskip::return#0
    // screenlayer::@6
    // [371] screenlayer::$4 = vera_layer_get_rowskip::return#2
    // conio_rowskip = vera_layer_get_rowskip(conio_screen_layer)
    // [372] conio_rowskip = screenlayer::$4 -- vwuz1=vwuz2 
    lda.z __4
    sta.z conio_rowskip
    lda.z __4+1
    sta.z conio_rowskip+1
    // vera_layer_get_height(conio_screen_layer)
    // [373] screenlayer::vera_layer_get_height1_layer#0 = conio_screen_layer -- vbuaa=vbuz1 
    lda.z conio_screen_layer
    // screenlayer::vera_layer_get_height1
    // config = vera_layer_config[layer]
    // [374] screenlayer::vera_layer_get_height1_$2 = screenlayer::vera_layer_get_height1_layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [375] screenlayer::vera_layer_get_height1_config#0 = vera_layer_config[screenlayer::vera_layer_get_height1_$2] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z vera_layer_get_height1_config
    lda vera_layer_config+1,y
    sta.z vera_layer_get_height1_config+1
    // *config & VERA_LAYER_HEIGHT_MASK
    // [376] screenlayer::vera_layer_get_height1_$0 = *screenlayer::vera_layer_get_height1_config#0 & VERA_LAYER_HEIGHT_MASK -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    ldy #0
    and (vera_layer_get_height1_config),y
    // (*config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [377] screenlayer::vera_layer_get_height1_$1 = screenlayer::vera_layer_get_height1_$0 >> 6 -- vbuaa=vbuaa_ror_6 
    rol
    rol
    rol
    and #3
    // return VERA_LAYER_HEIGHT[ (*config & VERA_LAYER_HEIGHT_MASK) >> 6];
    // [378] screenlayer::vera_layer_get_height1_$3 = screenlayer::vera_layer_get_height1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [379] screenlayer::vera_layer_get_height1_return#0 = VERA_LAYER_HEIGHT[screenlayer::vera_layer_get_height1_$3] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda VERA_LAYER_HEIGHT,y
    sta.z vera_layer_get_height1_return
    lda VERA_LAYER_HEIGHT+1,y
    sta.z vera_layer_get_height1_return+1
    // screenlayer::vera_layer_get_height1_@return
    // }
    // [380] screenlayer::vera_layer_get_height1_return#1 = screenlayer::vera_layer_get_height1_return#0
    // screenlayer::@2
    // vera_layer_get_height(conio_screen_layer)
    // [381] screenlayer::$5 = screenlayer::vera_layer_get_height1_return#1
    // conio_height = vera_layer_get_height(conio_screen_layer)
    // [382] conio_height = screenlayer::$5 -- vwuz1=vwuz2 
    lda.z __5
    sta.z conio_height
    lda.z __5+1
    sta.z conio_height+1
    // screenlayer::@return
    // }
    // [383] return 
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
    // [385] vera_layer_textcolor[vera_layer_set_textcolor::layer#2] = WHITE -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #WHITE
    sta vera_layer_textcolor,x
    // vera_layer_set_textcolor::@return
    // }
    // [386] return 
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
    // [388] vera_layer_backcolor[vera_layer_set_backcolor::layer#2] = vera_layer_set_backcolor::color#2 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta vera_layer_backcolor,x
    // vera_layer_set_backcolor::@return
    // }
    // [389] return 
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
    .label addr = $5a
    // addr = vera_layer_mapbase[layer]
    // [391] vera_layer_set_mapbase::$0 = vera_layer_set_mapbase::layer#3 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [392] vera_layer_set_mapbase::addr#0 = vera_layer_mapbase[vera_layer_set_mapbase::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_mapbase,y
    sta.z addr
    lda vera_layer_mapbase+1,y
    sta.z addr+1
    // *addr = mapbase
    // [393] *vera_layer_set_mapbase::addr#0 = vera_layer_set_mapbase::mapbase#3 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_mapbase::@return
    // }
    // [394] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// gotoxy(byte register(X) y)
gotoxy: {
    .label __6 = $5c
    .label line_offset = $5c
    // if(y>CONIO_HEIGHT)
    // [396] if(gotoxy::y#3<=conio_screen_height) goto gotoxy::@4 -- vbuxx_le_vbuz1_then_la1 
    lda.z conio_screen_height
    stx.z $ff
    cmp.z $ff
    bcs __b1
    // [398] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [398] phi gotoxy::y#4 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [397] phi from gotoxy to gotoxy::@4 [phi:gotoxy->gotoxy::@4]
    // gotoxy::@4
    // [398] phi from gotoxy::@4 to gotoxy::@1 [phi:gotoxy::@4->gotoxy::@1]
    // [398] phi gotoxy::y#4 = gotoxy::y#3 [phi:gotoxy::@4->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=CONIO_WIDTH)
    // [399] if(0<conio_screen_width) goto gotoxy::@2 -- 0_lt_vbuz1_then_la1 
    lda.z conio_screen_width
    // [400] phi from gotoxy::@1 to gotoxy::@3 [phi:gotoxy::@1->gotoxy::@3]
    // gotoxy::@3
    // gotoxy::@2
    // conio_cursor_x[conio_screen_layer] = x
    // [401] conio_cursor_x[conio_screen_layer] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z conio_screen_layer
    sta conio_cursor_x,y
    // conio_cursor_y[conio_screen_layer] = y
    // [402] conio_cursor_y[conio_screen_layer] = gotoxy::y#4 -- pbuc1_derefidx_vbuz1=vbuxx 
    txa
    sta conio_cursor_y,y
    // (unsigned int)y << conio_rowshift
    // [403] gotoxy::$6 = (word)gotoxy::y#4 -- vwuz1=_word_vbuxx 
    txa
    sta.z __6
    lda #0
    sta.z __6+1
    // line_offset = (unsigned int)y << conio_rowshift
    // [404] gotoxy::line_offset#0 = gotoxy::$6 << conio_rowshift -- vwuz1=vwuz1_rol_vbuz2 
    ldy.z conio_rowshift
    beq !e+
  !:
    asl.z line_offset
    rol.z line_offset+1
    dey
    bne !-
  !e:
    // conio_line_text[conio_screen_layer] = line_offset
    // [405] gotoxy::$5 = conio_screen_layer << 1 -- vbuaa=vbuz1_rol_1 
    lda.z conio_screen_layer
    asl
    // [406] conio_line_text[gotoxy::$5] = gotoxy::line_offset#0 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z line_offset
    sta conio_line_text,y
    lda.z line_offset+1
    sta conio_line_text+1,y
    // gotoxy::@return
    // }
    // [407] return 
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
// vera_layer_mode_tile(byte zp($14) layer, dword zp($15) mapbase_address, dword zp($19) tilebase_address, word zp($5c) mapwidth, word zp($5a) mapheight, byte zp($1d) tilewidth, byte zp($1e) tileheight, byte register(X) color_depth)
vera_layer_mode_tile: {
    .label __1 = $5a
    .label __2 = $5a
    .label __4 = $5a
    .label __7 = $5a
    .label __8 = $5a
    .label __10 = $5a
    .label __19 = $5e
    .label __20 = $5f
    .label mapbase_address = $15
    .label tilebase_address = $19
    .label layer = $14
    .label mapwidth = $5c
    .label mapheight = $5a
    .label tilewidth = $1d
    .label tileheight = $1e
    // case 1:
    //             config |= VERA_LAYER_COLOR_DEPTH_1BPP;
    //             break;
    // [409] if(vera_layer_mode_tile::color_depth#3==1) goto vera_layer_mode_tile::@5 -- vbuxx_eq_vbuc1_then_la1 
    cpx #1
    beq __b1
    // vera_layer_mode_tile::@1
    // case 2:
    //             config |= VERA_LAYER_COLOR_DEPTH_2BPP;
    //             break;
    // [410] if(vera_layer_mode_tile::color_depth#3==2) goto vera_layer_mode_tile::@5 -- vbuxx_eq_vbuc1_then_la1 
    cpx #2
    beq __b2
    // vera_layer_mode_tile::@2
    // case 4:
    //             config |= VERA_LAYER_COLOR_DEPTH_4BPP;
    //             break;
    // [411] if(vera_layer_mode_tile::color_depth#3==4) goto vera_layer_mode_tile::@5 -- vbuxx_eq_vbuc1_then_la1 
    cpx #4
    beq __b3
    // vera_layer_mode_tile::@3
    // case 8:
    //             config |= VERA_LAYER_COLOR_DEPTH_8BPP;
    //             break;
    // [412] if(vera_layer_mode_tile::color_depth#3!=8) goto vera_layer_mode_tile::@5 -- vbuxx_neq_vbuc1_then_la1 
    cpx #8
    bne __b4
    // [413] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@4 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@4]
    // vera_layer_mode_tile::@4
    // [414] phi from vera_layer_mode_tile::@4 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5]
    // [414] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_8BPP [phi:vera_layer_mode_tile::@4->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_8BPP
    jmp __b5
    // [414] phi from vera_layer_mode_tile to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5]
  __b1:
    // [414] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_1BPP [phi:vera_layer_mode_tile->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_1BPP
    jmp __b5
    // [414] phi from vera_layer_mode_tile::@1 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5]
  __b2:
    // [414] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_2BPP [phi:vera_layer_mode_tile::@1->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_2BPP
    jmp __b5
    // [414] phi from vera_layer_mode_tile::@2 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5]
  __b3:
    // [414] phi vera_layer_mode_tile::config#17 = VERA_LAYER_COLOR_DEPTH_4BPP [phi:vera_layer_mode_tile::@2->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #VERA_LAYER_COLOR_DEPTH_4BPP
    jmp __b5
    // [414] phi from vera_layer_mode_tile::@3 to vera_layer_mode_tile::@5 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5]
  __b4:
    // [414] phi vera_layer_mode_tile::config#17 = 0 [phi:vera_layer_mode_tile::@3->vera_layer_mode_tile::@5#0] -- vbuxx=vbuc1 
    ldx #0
    // vera_layer_mode_tile::@5
  __b5:
    // case 32:
    //             config |= VERA_LAYER_WIDTH_32;
    //             vera_layer_rowshift[layer] = 6;
    //             vera_layer_rowskip[layer] = 64;
    //             break;
    // [415] if(vera_layer_mode_tile::mapwidth#10==$20) goto vera_layer_mode_tile::@9 -- vwuz1_eq_vbuc1_then_la1 
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
    // [416] if(vera_layer_mode_tile::mapwidth#10==$40) goto vera_layer_mode_tile::@10 -- vwuz1_eq_vbuc1_then_la1 
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
    // [417] if(vera_layer_mode_tile::mapwidth#10==$80) goto vera_layer_mode_tile::@11 -- vwuz1_eq_vbuc1_then_la1 
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
    // [418] if(vera_layer_mode_tile::mapwidth#10!=$100) goto vera_layer_mode_tile::@13 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapwidth+1
    cmp #>$100
    bne __b13
    lda.z mapwidth
    cmp #<$100
    bne __b13
    // vera_layer_mode_tile::@12
    // config |= VERA_LAYER_WIDTH_256
    // [419] vera_layer_mode_tile::config#8 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_256 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_WIDTH_256
    tax
    // vera_layer_rowshift[layer] = 9
    // [420] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 9 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #9
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 512
    // [421] vera_layer_mode_tile::$16 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [422] vera_layer_rowskip[vera_layer_mode_tile::$16] = $200 -- pwuc1_derefidx_vbuaa=vwuc2 
    tay
    lda #<$200
    sta vera_layer_rowskip,y
    lda #>$200
    sta vera_layer_rowskip+1,y
    // [423] phi from vera_layer_mode_tile::@10 vera_layer_mode_tile::@11 vera_layer_mode_tile::@12 vera_layer_mode_tile::@8 vera_layer_mode_tile::@9 to vera_layer_mode_tile::@13 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13]
    // [423] phi vera_layer_mode_tile::config#21 = vera_layer_mode_tile::config#6 [phi:vera_layer_mode_tile::@10/vera_layer_mode_tile::@11/vera_layer_mode_tile::@12/vera_layer_mode_tile::@8/vera_layer_mode_tile::@9->vera_layer_mode_tile::@13#0] -- register_copy 
    // vera_layer_mode_tile::@13
  __b13:
    // case 32:
    //             config |= VERA_LAYER_HEIGHT_32;
    //             break;
    // [424] if(vera_layer_mode_tile::mapheight#10==$20) goto vera_layer_mode_tile::@20 -- vwuz1_eq_vbuc1_then_la1 
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
    // [425] if(vera_layer_mode_tile::mapheight#10==$40) goto vera_layer_mode_tile::@17 -- vwuz1_eq_vbuc1_then_la1 
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
    // [426] if(vera_layer_mode_tile::mapheight#10==$80) goto vera_layer_mode_tile::@18 -- vwuz1_eq_vbuc1_then_la1 
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
    // [427] if(vera_layer_mode_tile::mapheight#10!=$100) goto vera_layer_mode_tile::@20 -- vwuz1_neq_vwuc1_then_la1 
    lda.z mapheight+1
    cmp #>$100
    bne __b20
    lda.z mapheight
    cmp #<$100
    bne __b20
    // vera_layer_mode_tile::@19
    // config |= VERA_LAYER_HEIGHT_256
    // [428] vera_layer_mode_tile::config#12 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_256 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_HEIGHT_256
    tax
    // [429] phi from vera_layer_mode_tile::@13 vera_layer_mode_tile::@16 vera_layer_mode_tile::@17 vera_layer_mode_tile::@18 vera_layer_mode_tile::@19 to vera_layer_mode_tile::@20 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20]
    // [429] phi vera_layer_mode_tile::config#25 = vera_layer_mode_tile::config#21 [phi:vera_layer_mode_tile::@13/vera_layer_mode_tile::@16/vera_layer_mode_tile::@17/vera_layer_mode_tile::@18/vera_layer_mode_tile::@19->vera_layer_mode_tile::@20#0] -- register_copy 
    // vera_layer_mode_tile::@20
  __b20:
    // vera_layer_set_config(layer, config)
    // [430] vera_layer_set_config::layer#0 = vera_layer_mode_tile::layer#10 -- vbuaa=vbuz1 
    lda.z layer
    // [431] vera_layer_set_config::config#0 = vera_layer_mode_tile::config#25
    // [432] call vera_layer_set_config 
    jsr vera_layer_set_config
    // vera_layer_mode_tile::@27
    // <mapbase_address
    // [433] vera_layer_mode_tile::$1 = < vera_layer_mode_tile::mapbase_address#10 -- vwuz1=_lo_vduz2 
    lda.z mapbase_address
    sta.z __1
    lda.z mapbase_address+1
    sta.z __1+1
    // vera_mapbase_offset[layer] = <mapbase_address
    // [434] vera_layer_mode_tile::$19 = vera_layer_mode_tile::layer#10 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z layer
    asl
    sta.z __19
    // [435] vera_mapbase_offset[vera_layer_mode_tile::$19] = vera_layer_mode_tile::$1 -- pwuc1_derefidx_vbuz1=vwuz2 
    // mapbase
    tay
    lda.z __1
    sta vera_mapbase_offset,y
    lda.z __1+1
    sta vera_mapbase_offset+1,y
    // >mapbase_address
    // [436] vera_layer_mode_tile::$2 = > vera_layer_mode_tile::mapbase_address#10 -- vwuz1=_hi_vduz2 
    lda.z mapbase_address+2
    sta.z __2
    lda.z mapbase_address+3
    sta.z __2+1
    // vera_mapbase_bank[layer] = (byte)(>mapbase_address)
    // [437] vera_mapbase_bank[vera_layer_mode_tile::layer#10] = (byte)vera_layer_mode_tile::$2 -- pbuc1_derefidx_vbuz1=_byte_vwuz2 
    ldy.z layer
    lda.z __2
    sta vera_mapbase_bank,y
    // vera_mapbase_address[layer] = mapbase_address
    // [438] vera_layer_mode_tile::$20 = vera_layer_mode_tile::layer#10 << 2 -- vbuz1=vbuz2_rol_2 
    tya
    asl
    asl
    sta.z __20
    // [439] vera_mapbase_address[vera_layer_mode_tile::$20] = vera_layer_mode_tile::mapbase_address#10 -- pduc1_derefidx_vbuz1=vduz2 
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
    // [440] vera_layer_mode_tile::mapbase_address#0 = vera_layer_mode_tile::mapbase_address#10 >> 1 -- vduz1=vduz1_ror_1 
    lsr.z mapbase_address+3
    ror.z mapbase_address+2
    ror.z mapbase_address+1
    ror.z mapbase_address
    // <mapbase_address
    // [441] vera_layer_mode_tile::$4 = < vera_layer_mode_tile::mapbase_address#0 -- vwuz1=_lo_vduz2 
    lda.z mapbase_address
    sta.z __4
    lda.z mapbase_address+1
    sta.z __4+1
    // mapbase = >(<mapbase_address)
    // [442] vera_layer_mode_tile::mapbase#0 = > vera_layer_mode_tile::$4 -- vbuxx=_hi_vwuz1 
    tax
    // vera_layer_set_mapbase(layer,mapbase)
    // [443] vera_layer_set_mapbase::layer#0 = vera_layer_mode_tile::layer#10 -- vbuaa=vbuz1 
    lda.z layer
    // [444] vera_layer_set_mapbase::mapbase#0 = vera_layer_mode_tile::mapbase#0
    // [445] call vera_layer_set_mapbase 
    // [390] phi from vera_layer_mode_tile::@27 to vera_layer_set_mapbase [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase]
    // [390] phi vera_layer_set_mapbase::mapbase#3 = vera_layer_set_mapbase::mapbase#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#0] -- register_copy 
    // [390] phi vera_layer_set_mapbase::layer#3 = vera_layer_set_mapbase::layer#0 [phi:vera_layer_mode_tile::@27->vera_layer_set_mapbase#1] -- register_copy 
    jsr vera_layer_set_mapbase
    // vera_layer_mode_tile::@28
    // <tilebase_address
    // [446] vera_layer_mode_tile::$7 = < vera_layer_mode_tile::tilebase_address#10 -- vwuz1=_lo_vduz2 
    lda.z tilebase_address
    sta.z __7
    lda.z tilebase_address+1
    sta.z __7+1
    // vera_tilebase_offset[layer] = <tilebase_address
    // [447] vera_tilebase_offset[vera_layer_mode_tile::$19] = vera_layer_mode_tile::$7 -- pwuc1_derefidx_vbuz1=vwuz2 
    // tilebase
    ldy.z __19
    lda.z __7
    sta vera_tilebase_offset,y
    lda.z __7+1
    sta vera_tilebase_offset+1,y
    // >tilebase_address
    // [448] vera_layer_mode_tile::$8 = > vera_layer_mode_tile::tilebase_address#10 -- vwuz1=_hi_vduz2 
    lda.z tilebase_address+2
    sta.z __8
    lda.z tilebase_address+3
    sta.z __8+1
    // vera_tilebase_bank[layer] = (byte)>tilebase_address
    // [449] vera_tilebase_bank[vera_layer_mode_tile::layer#10] = (byte)vera_layer_mode_tile::$8 -- pbuc1_derefidx_vbuz1=_byte_vwuz2 
    ldy.z layer
    lda.z __8
    sta vera_tilebase_bank,y
    // vera_tilebase_address[layer] = tilebase_address
    // [450] vera_tilebase_address[vera_layer_mode_tile::$20] = vera_layer_mode_tile::tilebase_address#10 -- pduc1_derefidx_vbuz1=vduz2 
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
    // [451] vera_layer_mode_tile::tilebase_address#0 = vera_layer_mode_tile::tilebase_address#10 >> 1 -- vduz1=vduz1_ror_1 
    lsr.z tilebase_address+3
    ror.z tilebase_address+2
    ror.z tilebase_address+1
    ror.z tilebase_address
    // <tilebase_address
    // [452] vera_layer_mode_tile::$10 = < vera_layer_mode_tile::tilebase_address#0 -- vwuz1=_lo_vduz2 
    lda.z tilebase_address
    sta.z __10
    lda.z tilebase_address+1
    sta.z __10+1
    // tilebase = >(<tilebase_address)
    // [453] vera_layer_mode_tile::tilebase#0 = > vera_layer_mode_tile::$10 -- vbuaa=_hi_vwuz1 
    // tilebase &= VERA_LAYER_TILEBASE_MASK
    // [454] vera_layer_mode_tile::tilebase#1 = vera_layer_mode_tile::tilebase#0 & VERA_LAYER_TILEBASE_MASK -- vbuxx=vbuaa_band_vbuc1 
    and #VERA_LAYER_TILEBASE_MASK
    tax
    // case 8:
    //             tilebase |= VERA_TILEBASE_WIDTH_8;
    //             break;
    // [455] if(vera_layer_mode_tile::tilewidth#10==8) goto vera_layer_mode_tile::@23 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tilewidth
    beq __b23
    // vera_layer_mode_tile::@21
    // case 16:
    //             tilebase |= VERA_TILEBASE_WIDTH_16;
    //             break;
    // [456] if(vera_layer_mode_tile::tilewidth#10!=$10) goto vera_layer_mode_tile::@23 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tilewidth
    bne __b23
    // vera_layer_mode_tile::@22
    // tilebase |= VERA_TILEBASE_WIDTH_16
    // [457] vera_layer_mode_tile::tilebase#3 = vera_layer_mode_tile::tilebase#1 | VERA_TILEBASE_WIDTH_16 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_TILEBASE_WIDTH_16
    tax
    // [458] phi from vera_layer_mode_tile::@21 vera_layer_mode_tile::@22 vera_layer_mode_tile::@28 to vera_layer_mode_tile::@23 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23]
    // [458] phi vera_layer_mode_tile::tilebase#12 = vera_layer_mode_tile::tilebase#1 [phi:vera_layer_mode_tile::@21/vera_layer_mode_tile::@22/vera_layer_mode_tile::@28->vera_layer_mode_tile::@23#0] -- register_copy 
    // vera_layer_mode_tile::@23
  __b23:
    // case 8:
    //             tilebase |= VERA_TILEBASE_HEIGHT_8;
    //             break;
    // [459] if(vera_layer_mode_tile::tileheight#10==8) goto vera_layer_mode_tile::@26 -- vbuz1_eq_vbuc1_then_la1 
    lda #8
    cmp.z tileheight
    beq __b26
    // vera_layer_mode_tile::@24
    // case 16:
    //             tilebase |= VERA_TILEBASE_HEIGHT_16;
    //             break;
    // [460] if(vera_layer_mode_tile::tileheight#10!=$10) goto vera_layer_mode_tile::@26 -- vbuz1_neq_vbuc1_then_la1 
    lda #$10
    cmp.z tileheight
    bne __b26
    // vera_layer_mode_tile::@25
    // tilebase |= VERA_TILEBASE_HEIGHT_16
    // [461] vera_layer_mode_tile::tilebase#5 = vera_layer_mode_tile::tilebase#12 | VERA_TILEBASE_HEIGHT_16 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_TILEBASE_HEIGHT_16
    tax
    // [462] phi from vera_layer_mode_tile::@23 vera_layer_mode_tile::@24 vera_layer_mode_tile::@25 to vera_layer_mode_tile::@26 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26]
    // [462] phi vera_layer_mode_tile::tilebase#10 = vera_layer_mode_tile::tilebase#12 [phi:vera_layer_mode_tile::@23/vera_layer_mode_tile::@24/vera_layer_mode_tile::@25->vera_layer_mode_tile::@26#0] -- register_copy 
    // vera_layer_mode_tile::@26
  __b26:
    // vera_layer_set_tilebase(layer,tilebase)
    // [463] vera_layer_set_tilebase::layer#0 = vera_layer_mode_tile::layer#10 -- vbuaa=vbuz1 
    lda.z layer
    // [464] vera_layer_set_tilebase::tilebase#0 = vera_layer_mode_tile::tilebase#10
    // [465] call vera_layer_set_tilebase 
    jsr vera_layer_set_tilebase
    // vera_layer_mode_tile::@return
    // }
    // [466] return 
    rts
    // vera_layer_mode_tile::@18
  __b18:
    // config |= VERA_LAYER_HEIGHT_128
    // [467] vera_layer_mode_tile::config#11 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_128 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_HEIGHT_128
    tax
    jmp __b20
    // vera_layer_mode_tile::@17
  __b17:
    // config |= VERA_LAYER_HEIGHT_64
    // [468] vera_layer_mode_tile::config#10 = vera_layer_mode_tile::config#21 | VERA_LAYER_HEIGHT_64 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_HEIGHT_64
    tax
    jmp __b20
    // vera_layer_mode_tile::@11
  __b11:
    // config |= VERA_LAYER_WIDTH_128
    // [469] vera_layer_mode_tile::config#7 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_128 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_WIDTH_128
    tax
    // vera_layer_rowshift[layer] = 8
    // [470] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 8 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #8
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 256
    // [471] vera_layer_mode_tile::$15 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [472] vera_layer_rowskip[vera_layer_mode_tile::$15] = $100 -- pwuc1_derefidx_vbuaa=vwuc2 
    tay
    lda #<$100
    sta vera_layer_rowskip,y
    lda #>$100
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@10
  __b10:
    // config |= VERA_LAYER_WIDTH_64
    // [473] vera_layer_mode_tile::config#6 = vera_layer_mode_tile::config#17 | VERA_LAYER_WIDTH_64 -- vbuxx=vbuxx_bor_vbuc1 
    txa
    ora #VERA_LAYER_WIDTH_64
    tax
    // vera_layer_rowshift[layer] = 7
    // [474] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 7 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #7
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 128
    // [475] vera_layer_mode_tile::$14 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [476] vera_layer_rowskip[vera_layer_mode_tile::$14] = $80 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #$80
    sta vera_layer_rowskip,y
    lda #0
    sta vera_layer_rowskip+1,y
    jmp __b13
    // vera_layer_mode_tile::@9
  __b9:
    // vera_layer_rowshift[layer] = 6
    // [477] vera_layer_rowshift[vera_layer_mode_tile::layer#10] = 6 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #6
    ldy.z layer
    sta vera_layer_rowshift,y
    // vera_layer_rowskip[layer] = 64
    // [478] vera_layer_mode_tile::$13 = vera_layer_mode_tile::layer#10 << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [479] vera_layer_rowskip[vera_layer_mode_tile::$13] = $40 -- pwuc1_derefidx_vbuaa=vbuc2 
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
    .label __1 = $2d
    .label line_text = $75
    .label color = $2d
    // line_text = CONIO_SCREEN_TEXT
    // [480] clrscr::line_text#0 = (byte*)CONIO_SCREEN_TEXT#118 -- pbuz1=pbuz2 
    lda.z CONIO_SCREEN_TEXT
    sta.z line_text
    lda.z CONIO_SCREEN_TEXT+1
    sta.z line_text+1
    // vera_layer_get_backcolor(conio_screen_layer)
    // [481] vera_layer_get_backcolor::layer#0 = conio_screen_layer -- vbuxx=vbuz1 
    ldx.z conio_screen_layer
    // [482] call vera_layer_get_backcolor 
    jsr vera_layer_get_backcolor
    // [483] vera_layer_get_backcolor::return#2 = vera_layer_get_backcolor::return#0
    // clrscr::@7
    // [484] clrscr::$0 = vera_layer_get_backcolor::return#2
    // vera_layer_get_backcolor(conio_screen_layer) << 4
    // [485] clrscr::$1 = clrscr::$0 << 4 -- vbuz1=vbuaa_rol_4 
    asl
    asl
    asl
    asl
    sta.z __1
    // vera_layer_get_textcolor(conio_screen_layer)
    // [486] vera_layer_get_textcolor::layer#0 = conio_screen_layer -- vbuxx=vbuz1 
    ldx.z conio_screen_layer
    // [487] call vera_layer_get_textcolor 
    jsr vera_layer_get_textcolor
    // [488] vera_layer_get_textcolor::return#2 = vera_layer_get_textcolor::return#0
    // clrscr::@8
    // [489] clrscr::$2 = vera_layer_get_textcolor::return#2
    // color = ( vera_layer_get_backcolor(conio_screen_layer) << 4 ) | vera_layer_get_textcolor(conio_screen_layer)
    // [490] clrscr::color#0 = clrscr::$1 | clrscr::$2 -- vbuz1=vbuz1_bor_vbuaa 
    ora.z color
    sta.z color
    // [491] phi from clrscr::@8 to clrscr::@1 [phi:clrscr::@8->clrscr::@1]
    // [491] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr::@8->clrscr::@1#0] -- register_copy 
    // [491] phi clrscr::l#2 = 0 [phi:clrscr::@8->clrscr::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // clrscr::@1
  __b1:
    // for( char l=0;l<conio_height; l++ )
    // [492] if(clrscr::l#2<conio_height) goto clrscr::@2 -- vbuxx_lt_vwuz1_then_la1 
    lda.z conio_height+1
    bne __b2
    cpx.z conio_height
    bcc __b2
    // clrscr::@3
    // conio_cursor_x[conio_screen_layer] = 0
    // [493] conio_cursor_x[conio_screen_layer] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z conio_screen_layer
    sta conio_cursor_x,y
    // conio_cursor_y[conio_screen_layer] = 0
    // [494] conio_cursor_y[conio_screen_layer] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    sta conio_cursor_y,y
    // conio_line_text[conio_screen_layer] = 0
    // [495] clrscr::$9 = conio_screen_layer << 1 -- vbuaa=vbuz1_rol_1 
    tya
    asl
    // [496] conio_line_text[clrscr::$9] = 0 -- pwuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #0
    sta conio_line_text,y
    sta conio_line_text+1,y
    // clrscr::@return
    // }
    // [497] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [498] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <ch
    // [499] clrscr::$5 = < clrscr::line_text#2 -- vbuaa=_lo_pbuz1 
    lda.z line_text
    // *VERA_ADDRX_L = <ch
    // [500] *VERA_ADDRX_L = clrscr::$5 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >ch
    // [501] clrscr::$6 = > clrscr::line_text#2 -- vbuaa=_hi_pbuz1 
    lda.z line_text+1
    // *VERA_ADDRX_M = >ch
    // [502] *VERA_ADDRX_M = clrscr::$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // CONIO_SCREEN_BANK | VERA_INC_1
    // [503] clrscr::$7 = CONIO_SCREEN_BANK#112 | VERA_INC_1 -- vbuaa=vbuz1_bor_vbuc1 
    lda #VERA_INC_1
    ora.z CONIO_SCREEN_BANK
    // *VERA_ADDRX_H = CONIO_SCREEN_BANK | VERA_INC_1
    // [504] *VERA_ADDRX_H = clrscr::$7 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // [505] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [505] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuyy=vbuc1 
    ldy #0
    // clrscr::@4
  __b4:
    // for( char c=0;c<conio_width; c++ )
    // [506] if(clrscr::c#2<conio_width) goto clrscr::@5 -- vbuyy_lt_vwuz1_then_la1 
    lda.z conio_width+1
    bne __b5
    cpy.z conio_width
    bcc __b5
    // clrscr::@6
    // line_text += conio_rowskip
    // [507] clrscr::line_text#1 = clrscr::line_text#2 + conio_rowskip -- pbuz1=pbuz1_plus_vwuz2 
    lda.z line_text
    clc
    adc.z conio_rowskip
    sta.z line_text
    lda.z line_text+1
    adc.z conio_rowskip+1
    sta.z line_text+1
    // for( char l=0;l<conio_height; l++ )
    // [508] clrscr::l#1 = ++ clrscr::l#2 -- vbuxx=_inc_vbuxx 
    inx
    // [491] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [491] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [491] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [509] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [510] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<conio_width; c++ )
    // [511] clrscr::c#1 = ++ clrscr::c#2 -- vbuyy=_inc_vbuyy 
    iny
    // [505] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [505] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
}
  // cx16_load_ram_banked
// Load a file to cx16 banked RAM at address A000-BFFF.
// Returns a status:
// - 0xff: Success
// - other: Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
// cx16_load_ram_banked(byte* zp($75) filename, dword zp($1f) address)
cx16_load_ram_banked: {
    .label __0 = $67
    .label __1 = $67
    .label __3 = $2e
    .label __5 = $67
    .label __6 = $67
    .label __7 = $72
    .label __8 = $72
    .label __10 = $67
    .label __11 = $69
    .label __33 = $67
    .label __34 = $2e
    .label bank = $48
    // select the bank
    .label addr = $69
    .label status = $2d
    .label return = $2d
    .label ch = $47
    .label address = $1f
    .label filename = $75
    // >address
    // [513] cx16_load_ram_banked::$0 = > cx16_load_ram_banked::address#7 -- vwuz1=_hi_vduz2 
    lda.z address+2
    sta.z __0
    lda.z address+3
    sta.z __0+1
    // (>address)<<8
    // [514] cx16_load_ram_banked::$1 = cx16_load_ram_banked::$0 << 8 -- vwuz1=vwuz1_rol_8 
    lda.z __1
    sta.z __1+1
    lda #0
    sta.z __1
    // <(>address)<<8
    // [515] cx16_load_ram_banked::$2 = < cx16_load_ram_banked::$1 -- vbuxx=_lo_vwuz1 
    tax
    // <address
    // [516] cx16_load_ram_banked::$3 = < cx16_load_ram_banked::address#7 -- vwuz1=_lo_vduz2 
    lda.z address
    sta.z __3
    lda.z address+1
    sta.z __3+1
    // >(<address)
    // [517] cx16_load_ram_banked::$4 = > cx16_load_ram_banked::$3 -- vbuyy=_hi_vwuz1 
    tay
    // ((word)<(>address)<<8)|>(<address)
    // [518] cx16_load_ram_banked::$33 = (word)cx16_load_ram_banked::$2 -- vwuz1=_word_vbuxx 
    txa
    sta.z __33
    sta.z __33+1
    // [519] cx16_load_ram_banked::$5 = cx16_load_ram_banked::$33 | cx16_load_ram_banked::$4 -- vwuz1=vwuz1_bor_vbuyy 
    tya
    ora.z __5
    sta.z __5
    // (((word)<(>address)<<8)|>(<address))>>5
    // [520] cx16_load_ram_banked::$6 = cx16_load_ram_banked::$5 >> 5 -- vwuz1=vwuz1_ror_5 
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
    // [521] cx16_load_ram_banked::$7 = > cx16_load_ram_banked::address#7 -- vwuz1=_hi_vduz2 
    lda.z address+2
    sta.z __7
    lda.z address+3
    sta.z __7+1
    // (>address)<<3
    // [522] cx16_load_ram_banked::$8 = cx16_load_ram_banked::$7 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    // <(>address)<<3
    // [523] cx16_load_ram_banked::$9 = < cx16_load_ram_banked::$8 -- vbuaa=_lo_vwuz1 
    lda.z __8
    // ((((word)<(>address)<<8)|>(<address))>>5)+((word)<(>address)<<3)
    // [524] cx16_load_ram_banked::$34 = (word)cx16_load_ram_banked::$9 -- vwuz1=_word_vbuaa 
    sta.z __34
    txa
    sta.z __34+1
    // [525] cx16_load_ram_banked::$10 = cx16_load_ram_banked::$6 + cx16_load_ram_banked::$34 -- vwuz1=vwuz1_plus_vwuz2 
    lda.z __10
    clc
    adc.z __34
    sta.z __10
    lda.z __10+1
    adc.z __34+1
    sta.z __10+1
    // bank = (byte)(((((word)<(>address)<<8)|>(<address))>>5)+((word)<(>address)<<3))
    // [526] cx16_load_ram_banked::bank#0 = (byte)cx16_load_ram_banked::$10 -- vbuz1=_byte_vwuz2 
    lda.z __10
    sta.z bank
    // <address
    // [527] cx16_load_ram_banked::$11 = < cx16_load_ram_banked::address#7 -- vwuz1=_lo_vduz2 
    lda.z address
    sta.z __11
    lda.z address+1
    sta.z __11+1
    // (<address)&0x1FFF
    // [528] cx16_load_ram_banked::addr#0 = cx16_load_ram_banked::$11 & $1fff -- vwuz1=vwuz1_band_vwuc1 
    lda.z addr
    and #<$1fff
    sta.z addr
    lda.z addr+1
    and #>$1fff
    sta.z addr+1
    // addr += 0xA000
    // [529] cx16_load_ram_banked::addr#1 = (byte*)cx16_load_ram_banked::addr#0 + $a000 -- pbuz1=pbuz1_plus_vwuc1 
    // stip off the top 3 bits, which are representing the bank of the word!
    clc
    lda.z addr
    adc #<$a000
    sta.z addr
    lda.z addr+1
    adc #>$a000
    sta.z addr+1
    // cx16_ram_bank(bank)
    // [530] cx16_ram_bank::bank#0 = cx16_load_ram_banked::bank#0 -- vbuaa=vbuz1 
    lda.z bank
    // [531] call cx16_ram_bank 
    // [743] phi from cx16_load_ram_banked to cx16_ram_bank [phi:cx16_load_ram_banked->cx16_ram_bank]
    // [743] phi cx16_ram_bank::bank#5 = cx16_ram_bank::bank#0 [phi:cx16_load_ram_banked->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // cx16_load_ram_banked::@8
    // cbm_k_setnam(filename)
    // [532] cbm_k_setnam::filename = cx16_load_ram_banked::filename#7 -- pbuz1=pbuz2 
    lda.z filename
    sta.z cbm_k_setnam.filename
    lda.z filename+1
    sta.z cbm_k_setnam.filename+1
    // [533] call cbm_k_setnam 
    jsr cbm_k_setnam
    // cx16_load_ram_banked::@9
    // cbm_k_setlfs(channel, device, secondary)
    // [534] cbm_k_setlfs::channel = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cbm_k_setlfs.channel
    // [535] cbm_k_setlfs::device = 8 -- vbuz1=vbuc1 
    lda #8
    sta.z cbm_k_setlfs.device
    // [536] cbm_k_setlfs::secondary = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z cbm_k_setlfs.secondary
    // [537] call cbm_k_setlfs 
    jsr cbm_k_setlfs
    // [538] phi from cx16_load_ram_banked::@9 to cx16_load_ram_banked::@10 [phi:cx16_load_ram_banked::@9->cx16_load_ram_banked::@10]
    // cx16_load_ram_banked::@10
    // cbm_k_open()
    // [539] call cbm_k_open 
    jsr cbm_k_open
    // [540] cbm_k_open::return#2 = cbm_k_open::return#1
    // cx16_load_ram_banked::@11
    // [541] cx16_load_ram_banked::status#1 = cbm_k_open::return#2 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$FF)
    // [542] if(cx16_load_ram_banked::status#1==$ff) goto cx16_load_ram_banked::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b1
    // [543] phi from cx16_load_ram_banked::@11 cx16_load_ram_banked::@12 cx16_load_ram_banked::@16 to cx16_load_ram_banked::@return [phi:cx16_load_ram_banked::@11/cx16_load_ram_banked::@12/cx16_load_ram_banked::@16->cx16_load_ram_banked::@return]
    // [543] phi cx16_load_ram_banked::return#1 = cx16_load_ram_banked::status#1 [phi:cx16_load_ram_banked::@11/cx16_load_ram_banked::@12/cx16_load_ram_banked::@16->cx16_load_ram_banked::@return#0] -- register_copy 
    // cx16_load_ram_banked::@return
    // }
    // [544] return 
    rts
    // cx16_load_ram_banked::@1
  __b1:
    // cbm_k_chkin(channel)
    // [545] cbm_k_chkin::channel = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cbm_k_chkin.channel
    // [546] call cbm_k_chkin 
    jsr cbm_k_chkin
    // [547] cbm_k_chkin::return#2 = cbm_k_chkin::return#1
    // cx16_load_ram_banked::@12
    // [548] cx16_load_ram_banked::status#2 = cbm_k_chkin::return#2 -- vbuz1=vbuaa 
    sta.z status
    // if(status!=$FF)
    // [549] if(cx16_load_ram_banked::status#2==$ff) goto cx16_load_ram_banked::@2 -- vbuz1_eq_vbuc1_then_la1 
    lda #$ff
    cmp.z status
    beq __b2
    rts
    // [550] phi from cx16_load_ram_banked::@12 to cx16_load_ram_banked::@2 [phi:cx16_load_ram_banked::@12->cx16_load_ram_banked::@2]
    // cx16_load_ram_banked::@2
  __b2:
    // cbm_k_chrin()
    // [551] call cbm_k_chrin 
    jsr cbm_k_chrin
    // [552] cbm_k_chrin::return#2 = cbm_k_chrin::return#1
    // cx16_load_ram_banked::@13
    // ch = cbm_k_chrin()
    // [553] cx16_load_ram_banked::ch#1 = cbm_k_chrin::return#2 -- vbuz1=vbuaa 
    sta.z ch
    // cbm_k_readst()
    // [554] call cbm_k_readst 
    jsr cbm_k_readst
    // [555] cbm_k_readst::return#2 = cbm_k_readst::return#1
    // cx16_load_ram_banked::@14
    // status = cbm_k_readst()
    // [556] cx16_load_ram_banked::status#3 = cbm_k_readst::return#2
    // [557] phi from cx16_load_ram_banked::@14 cx16_load_ram_banked::@18 to cx16_load_ram_banked::@3 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3]
    // [557] phi cx16_load_ram_banked::bank#2 = cx16_load_ram_banked::bank#0 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#0] -- register_copy 
    // [557] phi cx16_load_ram_banked::ch#3 = cx16_load_ram_banked::ch#1 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#1] -- register_copy 
    // [557] phi cx16_load_ram_banked::addr#4 = cx16_load_ram_banked::addr#1 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#2] -- register_copy 
    // [557] phi cx16_load_ram_banked::status#8 = cx16_load_ram_banked::status#3 [phi:cx16_load_ram_banked::@14/cx16_load_ram_banked::@18->cx16_load_ram_banked::@3#3] -- register_copy 
    // cx16_load_ram_banked::@3
  __b3:
    // while (!status)
    // [558] if(0==cx16_load_ram_banked::status#8) goto cx16_load_ram_banked::@4 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b4
    // cx16_load_ram_banked::@5
    // cbm_k_close(channel)
    // [559] cbm_k_close::channel = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cbm_k_close.channel
    // [560] call cbm_k_close 
    jsr cbm_k_close
    // [561] cbm_k_close::return#2 = cbm_k_close::return#1
    // cx16_load_ram_banked::@15
    // [562] cx16_load_ram_banked::status#10 = cbm_k_close::return#2 -- vbuz1=vbuaa 
    sta.z status
    // cbm_k_clrchn()
    // [563] call cbm_k_clrchn 
    jsr cbm_k_clrchn
    // [564] phi from cx16_load_ram_banked::@15 to cx16_load_ram_banked::@16 [phi:cx16_load_ram_banked::@15->cx16_load_ram_banked::@16]
    // cx16_load_ram_banked::@16
    // cx16_ram_bank(1)
    // [565] call cx16_ram_bank 
    // [743] phi from cx16_load_ram_banked::@16 to cx16_ram_bank [phi:cx16_load_ram_banked::@16->cx16_ram_bank]
    // [743] phi cx16_ram_bank::bank#5 = 1 [phi:cx16_load_ram_banked::@16->cx16_ram_bank#0] -- vbuaa=vbuc1 
    lda #1
    jsr cx16_ram_bank
    rts
    // cx16_load_ram_banked::@4
  __b4:
    // if(addr == 0xC000)
    // [566] if(cx16_load_ram_banked::addr#4!=$c000) goto cx16_load_ram_banked::@6 -- pbuz1_neq_vwuc1_then_la1 
    lda.z addr+1
    cmp #>$c000
    bne __b6
    lda.z addr
    cmp #<$c000
    bne __b6
    // cx16_load_ram_banked::@7
    // bank++;
    // [567] cx16_load_ram_banked::bank#1 = ++ cx16_load_ram_banked::bank#2 -- vbuz1=_inc_vbuz1 
    inc.z bank
    // cx16_ram_bank(bank)
    // [568] cx16_ram_bank::bank#2 = cx16_load_ram_banked::bank#1 -- vbuaa=vbuz1 
    lda.z bank
    // [569] call cx16_ram_bank 
  //printf(", %u", (word)bank);
    // [743] phi from cx16_load_ram_banked::@7 to cx16_ram_bank [phi:cx16_load_ram_banked::@7->cx16_ram_bank]
    // [743] phi cx16_ram_bank::bank#5 = cx16_ram_bank::bank#2 [phi:cx16_load_ram_banked::@7->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [570] phi from cx16_load_ram_banked::@7 to cx16_load_ram_banked::@6 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@6]
    // [570] phi cx16_load_ram_banked::bank#10 = cx16_load_ram_banked::bank#1 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@6#0] -- register_copy 
    // [570] phi cx16_load_ram_banked::addr#5 = (byte*) 40960 [phi:cx16_load_ram_banked::@7->cx16_load_ram_banked::@6#1] -- pbuz1=pbuc1 
    lda #<$a000
    sta.z addr
    lda #>$a000
    sta.z addr+1
    // [570] phi from cx16_load_ram_banked::@4 to cx16_load_ram_banked::@6 [phi:cx16_load_ram_banked::@4->cx16_load_ram_banked::@6]
    // [570] phi cx16_load_ram_banked::bank#10 = cx16_load_ram_banked::bank#2 [phi:cx16_load_ram_banked::@4->cx16_load_ram_banked::@6#0] -- register_copy 
    // [570] phi cx16_load_ram_banked::addr#5 = cx16_load_ram_banked::addr#4 [phi:cx16_load_ram_banked::@4->cx16_load_ram_banked::@6#1] -- register_copy 
    // cx16_load_ram_banked::@6
  __b6:
    // *addr = ch
    // [571] *cx16_load_ram_banked::addr#5 = cx16_load_ram_banked::ch#3 -- _deref_pbuz1=vbuz2 
    lda.z ch
    ldy #0
    sta (addr),y
    // addr++;
    // [572] cx16_load_ram_banked::addr#10 = ++ cx16_load_ram_banked::addr#5 -- pbuz1=_inc_pbuz1 
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    // cbm_k_chrin()
    // [573] call cbm_k_chrin 
    jsr cbm_k_chrin
    // [574] cbm_k_chrin::return#3 = cbm_k_chrin::return#1
    // cx16_load_ram_banked::@17
    // ch = cbm_k_chrin()
    // [575] cx16_load_ram_banked::ch#2 = cbm_k_chrin::return#3 -- vbuz1=vbuaa 
    sta.z ch
    // cbm_k_readst()
    // [576] call cbm_k_readst 
    jsr cbm_k_readst
    // [577] cbm_k_readst::return#3 = cbm_k_readst::return#1
    // cx16_load_ram_banked::@18
    // status = cbm_k_readst()
    // [578] cx16_load_ram_banked::status#5 = cbm_k_readst::return#3
    jmp __b3
}
  // cputs
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp($69) s)
cputs: {
    .label s = $69
    // [580] phi from cputs cputs::@2 to cputs::@1 [phi:cputs/cputs::@2->cputs::@1]
    // [580] phi cputs::s#15 = cputs::s#16 [phi:cputs/cputs::@2->cputs::@1#0] -- register_copy 
    // cputs::@1
  __b1:
    // while(c=*s++)
    // [581] cputs::c#1 = *cputs::s#15 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (s),y
    // [582] cputs::s#0 = ++ cputs::s#15 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [583] if(0!=cputs::c#1) goto cputs::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // cputs::@return
    // }
    // [584] return 
    rts
    // cputs::@2
  __b2:
    // cputc(c)
    // [585] cputc::c#0 = cputs::c#1 -- vbuz1=vbuaa 
    sta.z cputc.c
    // [586] call cputc 
    // [782] phi from cputs::@2 to cputc [phi:cputs::@2->cputc]
    // [782] phi cputc::c#3 = cputc::c#0 [phi:cputs::@2->cputc#0] -- register_copy 
    jsr cputc
    jmp __b1
}
  // printf_uchar
// Print an unsigned char using a specific format
// printf_uchar(byte register(X) uvalue, byte register(Y) format_radix)
printf_uchar: {
    // printf_uchar::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [588] *((byte*)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format.radix)
    // [589] uctoa::value#1 = printf_uchar::uvalue#10
    // [590] uctoa::radix#0 = printf_uchar::format_radix#10
    // [591] call uctoa 
    // Format number into buffer
    jsr uctoa
    // printf_uchar::@2
    // printf_number_buffer(printf_buffer, format)
    // [592] printf_number_buffer::buffer_sign#0 = *((byte*)&printf_buffer) -- vbuaa=_deref_pbuc1 
    lda printf_buffer
    // [593] call printf_number_buffer 
  // Print using format
    // [842] phi from printf_uchar::@2 to printf_number_buffer [phi:printf_uchar::@2->printf_number_buffer]
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [594] return 
    rts
}
  // bnkcpy_vram_address
// Copy block of banked internal memory (256 banks at A000-BFFF) to VERA VRAM.
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vdest: dword of the destination address in VRAM
// - src: dword of source banked address in RAM. This address is a linair project of the banked memory of 512K to 2048K.
// - num: dword of the number of bytes to copy
// bnkcpy_vram_address(dword zp($1f) vdest, dword zp($23) num)
bnkcpy_vram_address: {
    .label __0 = $67
    .label __2 = $2e
    .label __4 = $67
    .label __7 = $72
    .label __8 = $72
    .label __10 = $2e
    .label __12 = $69
    .label __13 = $69
    .label __14 = $75
    .label __15 = $75
    .label __17 = $69
    .label __18 = $2e
    .label __25 = $69
    .label __26 = $67
    .label beg = $27
    .label end = $23
    // select the bank
    .label addr = $2e
    .label pos = $27
    .label vdest = $1f
    .label num = $23
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [596] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <vdest
    // [597] bnkcpy_vram_address::$0 = < bnkcpy_vram_address::vdest#7 -- vwuz1=_lo_vduz2 
    lda.z vdest
    sta.z __0
    lda.z vdest+1
    sta.z __0+1
    // <(<vdest)
    // [598] bnkcpy_vram_address::$1 = < bnkcpy_vram_address::$0 -- vbuaa=_lo_vwuz1 
    lda.z __0
    // *VERA_ADDRX_L = <(<vdest)
    // [599] *VERA_ADDRX_L = bnkcpy_vram_address::$1 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // <vdest
    // [600] bnkcpy_vram_address::$2 = < bnkcpy_vram_address::vdest#7 -- vwuz1=_lo_vduz2 
    lda.z vdest
    sta.z __2
    lda.z vdest+1
    sta.z __2+1
    // >(<vdest)
    // [601] bnkcpy_vram_address::$3 = > bnkcpy_vram_address::$2 -- vbuaa=_hi_vwuz1 
    // *VERA_ADDRX_M = >(<vdest)
    // [602] *VERA_ADDRX_M = bnkcpy_vram_address::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // >vdest
    // [603] bnkcpy_vram_address::$4 = > bnkcpy_vram_address::vdest#7 -- vwuz1=_hi_vduz2 
    lda.z vdest+2
    sta.z __4
    lda.z vdest+3
    sta.z __4+1
    // <(>vdest)
    // [604] bnkcpy_vram_address::$5 = < bnkcpy_vram_address::$4 -- vbuaa=_lo_vwuz1 
    lda.z __4
    // *VERA_ADDRX_H = <(>vdest)
    // [605] *VERA_ADDRX_H = bnkcpy_vram_address::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_ADDRX_H |= VERA_INC_1
    // [606] *VERA_ADDRX_H = *VERA_ADDRX_H | VERA_INC_1 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora VERA_ADDRX_H
    sta VERA_ADDRX_H
    // end = src+num
    // [607] bnkcpy_vram_address::end#0 = bnkcpy_vram_address::beg#0 + bnkcpy_vram_address::num#7 -- vduz1=vduz2_plus_vduz1 
    lda.z end
    clc
    adc.z beg
    sta.z end
    lda.z end+1
    adc.z beg+1
    sta.z end+1
    lda.z end+2
    adc.z beg+2
    sta.z end+2
    lda.z end+3
    adc.z beg+3
    sta.z end+3
    // >beg
    // [608] bnkcpy_vram_address::$7 = > bnkcpy_vram_address::beg#0 -- vwuz1=_hi_vduz2 
    lda.z beg+2
    sta.z __7
    lda.z beg+3
    sta.z __7+1
    // (>beg)<<8
    // [609] bnkcpy_vram_address::$8 = bnkcpy_vram_address::$7 << 8 -- vwuz1=vwuz1_rol_8 
    lda.z __8
    sta.z __8+1
    lda #0
    sta.z __8
    // <(>beg)<<8
    // [610] bnkcpy_vram_address::$9 = < bnkcpy_vram_address::$8 -- vbuyy=_lo_vwuz1 
    tay
    // <beg
    // [611] bnkcpy_vram_address::$10 = < bnkcpy_vram_address::beg#0 -- vwuz1=_lo_vduz2 
    lda.z beg
    sta.z __10
    lda.z beg+1
    sta.z __10+1
    // >(<beg)
    // [612] bnkcpy_vram_address::$11 = > bnkcpy_vram_address::$10 -- vbuxx=_hi_vwuz1 
    tax
    // ((word)<(>beg)<<8)|>(<beg)
    // [613] bnkcpy_vram_address::$25 = (word)bnkcpy_vram_address::$9 -- vwuz1=_word_vbuyy 
    tya
    sta.z __25
    sta.z __25+1
    // [614] bnkcpy_vram_address::$12 = bnkcpy_vram_address::$25 | bnkcpy_vram_address::$11 -- vwuz1=vwuz1_bor_vbuxx 
    txa
    ora.z __12
    sta.z __12
    // (((word)<(>beg)<<8)|>(<beg))>>5
    // [615] bnkcpy_vram_address::$13 = bnkcpy_vram_address::$12 >> 5 -- vwuz1=vwuz1_ror_5 
    lsr.z __13+1
    ror.z __13
    lsr.z __13+1
    ror.z __13
    lsr.z __13+1
    ror.z __13
    lsr.z __13+1
    ror.z __13
    lsr.z __13+1
    ror.z __13
    // >beg
    // [616] bnkcpy_vram_address::$14 = > bnkcpy_vram_address::beg#0 -- vwuz1=_hi_vduz2 
    lda.z beg+2
    sta.z __14
    lda.z beg+3
    sta.z __14+1
    // (>beg)<<3
    // [617] bnkcpy_vram_address::$15 = bnkcpy_vram_address::$14 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z __15
    rol.z __15+1
    asl.z __15
    rol.z __15+1
    asl.z __15
    rol.z __15+1
    // <(>beg)<<3
    // [618] bnkcpy_vram_address::$16 = < bnkcpy_vram_address::$15 -- vbuaa=_lo_vwuz1 
    lda.z __15
    // ((((word)<(>beg)<<8)|>(<beg))>>5)+((word)<(>beg)<<3)
    // [619] bnkcpy_vram_address::$26 = (word)bnkcpy_vram_address::$16 -- vwuz1=_word_vbuaa 
    sta.z __26
    tya
    sta.z __26+1
    // [620] bnkcpy_vram_address::$17 = bnkcpy_vram_address::$13 + bnkcpy_vram_address::$26 -- vwuz1=vwuz1_plus_vwuz2 
    lda.z __17
    clc
    adc.z __26
    sta.z __17
    lda.z __17+1
    adc.z __26+1
    sta.z __17+1
    // bank = (byte)(((((word)<(>beg)<<8)|>(<beg))>>5)+((word)<(>beg)<<3))
    // [621] bnkcpy_vram_address::bank#0 = (byte)bnkcpy_vram_address::$17 -- vbuxx=_byte_vwuz1 
    lda.z __17
    tax
    // <beg
    // [622] bnkcpy_vram_address::$18 = < bnkcpy_vram_address::beg#0 -- vwuz1=_lo_vduz2 
    lda.z beg
    sta.z __18
    lda.z beg+1
    sta.z __18+1
    // (<beg)&0x1FFF
    // [623] bnkcpy_vram_address::addr#0 = bnkcpy_vram_address::$18 & $1fff -- vwuz1=vwuz1_band_vwuc1 
    lda.z addr
    and #<$1fff
    sta.z addr
    lda.z addr+1
    and #>$1fff
    sta.z addr+1
    // addr += 0xA000
    // [624] bnkcpy_vram_address::addr#1 = (byte*)bnkcpy_vram_address::addr#0 + $a000 -- pbuz1=pbuz1_plus_vwuc1 
    // strip off the top 3 bits, which are representing the bank of the word!
    clc
    lda.z addr
    adc #<$a000
    sta.z addr
    lda.z addr+1
    adc #>$a000
    sta.z addr+1
    // cx16_ram_bank(bank)
    // [625] cx16_ram_bank::bank#3 = bnkcpy_vram_address::bank#0 -- vbuaa=vbuxx 
    txa
    // [626] call cx16_ram_bank 
  //printf("bank = %u\n", (word)bank);
    // [743] phi from bnkcpy_vram_address to cx16_ram_bank [phi:bnkcpy_vram_address->cx16_ram_bank]
    // [743] phi cx16_ram_bank::bank#5 = cx16_ram_bank::bank#3 [phi:bnkcpy_vram_address->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [627] phi from bnkcpy_vram_address bnkcpy_vram_address::@3 to bnkcpy_vram_address::@1 [phi:bnkcpy_vram_address/bnkcpy_vram_address::@3->bnkcpy_vram_address::@1]
  __b1:
    // [627] phi bnkcpy_vram_address::bank#2 = bnkcpy_vram_address::bank#0 [phi:bnkcpy_vram_address/bnkcpy_vram_address::@3->bnkcpy_vram_address::@1#0] -- register_copy 
    // [627] phi bnkcpy_vram_address::addr#4 = bnkcpy_vram_address::addr#1 [phi:bnkcpy_vram_address/bnkcpy_vram_address::@3->bnkcpy_vram_address::@1#1] -- register_copy 
    // [627] phi bnkcpy_vram_address::pos#2 = bnkcpy_vram_address::beg#0 [phi:bnkcpy_vram_address/bnkcpy_vram_address::@3->bnkcpy_vram_address::@1#2] -- register_copy 
  // select the bank
    // bnkcpy_vram_address::@1
    // for(dword pos=beg; pos<end; pos++)
    // [628] if(bnkcpy_vram_address::pos#2<bnkcpy_vram_address::end#0) goto bnkcpy_vram_address::@2 -- vduz1_lt_vduz2_then_la1 
    lda.z pos+3
    cmp.z end+3
    bcc __b2
    bne !+
    lda.z pos+2
    cmp.z end+2
    bcc __b2
    bne !+
    lda.z pos+1
    cmp.z end+1
    bcc __b2
    bne !+
    lda.z pos
    cmp.z end
    bcc __b2
  !:
    // bnkcpy_vram_address::@return
    // }
    // [629] return 
    rts
    // bnkcpy_vram_address::@2
  __b2:
    // if(addr == 0xC000)
    // [630] if(bnkcpy_vram_address::addr#4!=$c000) goto bnkcpy_vram_address::@3 -- pbuz1_neq_vwuc1_then_la1 
    lda.z addr+1
    cmp #>$c000
    bne __b3
    lda.z addr
    cmp #<$c000
    bne __b3
    // bnkcpy_vram_address::@4
    // cx16_ram_bank(++bank);
    // [631] bnkcpy_vram_address::bank#1 = ++ bnkcpy_vram_address::bank#2 -- vbuxx=_inc_vbuxx 
    inx
    // cx16_ram_bank(++bank)
    // [632] cx16_ram_bank::bank#4 = bnkcpy_vram_address::bank#1 -- vbuaa=vbuxx 
    txa
    // [633] call cx16_ram_bank 
    // [743] phi from bnkcpy_vram_address::@4 to cx16_ram_bank [phi:bnkcpy_vram_address::@4->cx16_ram_bank]
    // [743] phi cx16_ram_bank::bank#5 = cx16_ram_bank::bank#4 [phi:bnkcpy_vram_address::@4->cx16_ram_bank#0] -- register_copy 
    jsr cx16_ram_bank
    // [634] phi from bnkcpy_vram_address::@4 to bnkcpy_vram_address::@3 [phi:bnkcpy_vram_address::@4->bnkcpy_vram_address::@3]
    // [634] phi bnkcpy_vram_address::bank#5 = bnkcpy_vram_address::bank#1 [phi:bnkcpy_vram_address::@4->bnkcpy_vram_address::@3#0] -- register_copy 
    // [634] phi bnkcpy_vram_address::addr#5 = (byte*) 40960 [phi:bnkcpy_vram_address::@4->bnkcpy_vram_address::@3#1] -- pbuz1=pbuc1 
    lda #<$a000
    sta.z addr
    lda #>$a000
    sta.z addr+1
    // [634] phi from bnkcpy_vram_address::@2 to bnkcpy_vram_address::@3 [phi:bnkcpy_vram_address::@2->bnkcpy_vram_address::@3]
    // [634] phi bnkcpy_vram_address::bank#5 = bnkcpy_vram_address::bank#2 [phi:bnkcpy_vram_address::@2->bnkcpy_vram_address::@3#0] -- register_copy 
    // [634] phi bnkcpy_vram_address::addr#5 = bnkcpy_vram_address::addr#4 [phi:bnkcpy_vram_address::@2->bnkcpy_vram_address::@3#1] -- register_copy 
    // bnkcpy_vram_address::@3
  __b3:
    // *VERA_DATA0 = *addr
    // [635] *VERA_DATA0 = *bnkcpy_vram_address::addr#5 -- _deref_pbuc1=_deref_pbuz1 
    ldy #0
    lda (addr),y
    sta VERA_DATA0
    // addr++;
    // [636] bnkcpy_vram_address::addr#2 = ++ bnkcpy_vram_address::addr#5 -- pbuz1=_inc_pbuz1 
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    // for(dword pos=beg; pos<end; pos++)
    // [637] bnkcpy_vram_address::pos#1 = ++ bnkcpy_vram_address::pos#2 -- vduz1=_inc_vduz1 
    inc.z pos
    bne !+
    inc.z pos+1
    bne !+
    inc.z pos+2
    bne !+
    inc.z pos+3
  !:
    jmp __b1
}
  // tile_background
tile_background: {
    .label __3 = $69
    .label c = $47
    .label r = $2d
    // [639] phi from tile_background to tile_background::@1 [phi:tile_background->tile_background::@1]
    // [639] phi rand_state#18 = 1 [phi:tile_background->tile_background::@1#0] -- vwuz1=vwuc1 
    lda #<1
    sta.z rand_state
    lda #>1
    sta.z rand_state+1
    // [639] phi tile_background::r#2 = 0 [phi:tile_background->tile_background::@1#1] -- vbuz1=vbuc1 
    sta.z r
    // tile_background::@1
  __b1:
    // for(byte r=0;r<6;r+=1)
    // [640] if(tile_background::r#2<6) goto tile_background::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z r
    cmp #6
    bcc __b4
    // tile_background::@return
    // }
    // [641] return 
    rts
    // [642] phi from tile_background::@1 to tile_background::@2 [phi:tile_background::@1->tile_background::@2]
  __b4:
    // [642] phi rand_state#24 = rand_state#18 [phi:tile_background::@1->tile_background::@2#0] -- register_copy 
    // [642] phi tile_background::c#2 = 0 [phi:tile_background::@1->tile_background::@2#1] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // tile_background::@2
  __b2:
    // for(byte c=0;c<5;c+=1)
    // [643] if(tile_background::c#2<5) goto tile_background::@3 -- vbuz1_lt_vbuc1_then_la1 
    lda.z c
    cmp #5
    bcc __b3
    // tile_background::@4
    // r+=1
    // [644] tile_background::r#1 = tile_background::r#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z r
    // [639] phi from tile_background::@4 to tile_background::@1 [phi:tile_background::@4->tile_background::@1]
    // [639] phi rand_state#18 = rand_state#24 [phi:tile_background::@4->tile_background::@1#0] -- register_copy 
    // [639] phi tile_background::r#2 = tile_background::r#1 [phi:tile_background::@4->tile_background::@1#1] -- register_copy 
    jmp __b1
    // [645] phi from tile_background::@2 to tile_background::@3 [phi:tile_background::@2->tile_background::@3]
    // tile_background::@3
  __b3:
    // rand()
    // [646] call rand 
    // [256] phi from tile_background::@3 to rand [phi:tile_background::@3->rand]
    // [256] phi rand_state#13 = rand_state#24 [phi:tile_background::@3->rand#0] -- register_copy 
    jsr rand
    // rand()
    // [647] rand::return#3 = rand::return#0
    // tile_background::@5
    // modr16u(rand(),3,0)
    // [648] modr16u::dividend#2 = rand::return#3
    // [649] call modr16u 
    // [265] phi from tile_background::@5 to modr16u [phi:tile_background::@5->modr16u]
    // [265] phi modr16u::dividend#5 = modr16u::dividend#2 [phi:tile_background::@5->modr16u#0] -- register_copy 
    jsr modr16u
    // modr16u(rand(),3,0)
    // [650] modr16u::return#3 = modr16u::return#0
    // tile_background::@6
    // [651] tile_background::$3 = modr16u::return#3 -- vwuz1=vwuz2 
    lda.z modr16u.return
    sta.z __3
    lda.z modr16u.return+1
    sta.z __3+1
    // rnd = (byte)modr16u(rand(),3,0)
    // [652] tile_background::rnd#0 = (byte)tile_background::$3 -- vbuaa=_byte_vwuz1 
    lda.z __3
    // vera_tile_element( 0, c, r, 3, TileDB[rnd])
    // [653] tile_background::$5 = tile_background::rnd#0 << 1 -- vbuxx=vbuaa_rol_1 
    asl
    tax
    // [654] vera_tile_element::x#2 = tile_background::c#2 -- vbuz1=vbuz2 
    lda.z c
    sta.z vera_tile_element.x
    // [655] vera_tile_element::y#2 = tile_background::r#2 -- vbuz1=vbuz2 
    lda.z r
    sta.z vera_tile_element.y
    // [656] vera_tile_element::Tile#1 = TileDB[tile_background::$5] -- pbuz1=qbuc1_derefidx_vbuxx 
    lda TileDB,x
    sta.z vera_tile_element.Tile
    lda TileDB+1,x
    sta.z vera_tile_element.Tile+1
    // [657] call vera_tile_element 
    // [282] phi from tile_background::@6 to vera_tile_element [phi:tile_background::@6->vera_tile_element]
    // [282] phi vera_tile_element::y#3 = vera_tile_element::y#2 [phi:tile_background::@6->vera_tile_element#0] -- register_copy 
    // [282] phi vera_tile_element::x#3 = vera_tile_element::x#2 [phi:tile_background::@6->vera_tile_element#1] -- register_copy 
    // [282] phi vera_tile_element::Tile#2 = vera_tile_element::Tile#1 [phi:tile_background::@6->vera_tile_element#2] -- register_copy 
    jsr vera_tile_element
    // tile_background::@7
    // c+=1
    // [658] tile_background::c#1 = tile_background::c#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z c
    // [642] phi from tile_background::@7 to tile_background::@2 [phi:tile_background::@7->tile_background::@2]
    // [642] phi rand_state#24 = rand_state#14 [phi:tile_background::@7->tile_background::@2#0] -- register_copy 
    // [642] phi tile_background::c#2 = tile_background::c#1 [phi:tile_background::@7->tile_background::@2#1] -- register_copy 
    jmp __b2
}
  // create_sprites_player
create_sprites_player: {
    .label __5 = $75
    .label __6 = $67
    .label __9 = $75
    .label __10 = $67
    .label x = $75
    .label y = $67
    // Copy sprite palette to VRAM
    // Copy 8* sprite attributes to VRAM    
    .label PLAYER_SPRITE_OFFSET = $2e
    .label s = $48
    // [660] phi from create_sprites_player to create_sprites_player::@1 [phi:create_sprites_player->create_sprites_player::@1]
    // [660] phi create_sprites_player::PLAYER_SPRITE_OFFSET#2 = 0 [phi:create_sprites_player->create_sprites_player::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z PLAYER_SPRITE_OFFSET
    sta.z PLAYER_SPRITE_OFFSET+1
    // [660] phi create_sprites_player::s#2 = 0 [phi:create_sprites_player->create_sprites_player::@1#1] -- vbuz1=vbuc1 
    sta.z s
    // create_sprites_player::@1
  __b1:
    // for(char s=0;s<NUM_PLAYER;s++)
    // [661] if(create_sprites_player::s#2<NUM_PLAYER) goto create_sprites_player::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z s
    cmp #NUM_PLAYER
    bcc __b2
    // create_sprites_player::@return
    // }
    // [662] return 
    rts
    // create_sprites_player::@2
  __b2:
    // s&03
    // [663] create_sprites_player::$1 = create_sprites_player::s#2 & 3 -- vbuaa=vbuz1_band_vbuc1 
    lda #3
    and.z s
    // (word)(s&03)<<6
    // [664] create_sprites_player::$9 = (word)create_sprites_player::$1 -- vwuz1=_word_vbuaa 
    sta.z __9
    lda #0
    sta.z __9+1
    // x = ((word)(s&03)<<6)
    // [665] create_sprites_player::x#0 = create_sprites_player::$9 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z x+1
    lsr
    sta.z $ff
    lda.z x
    ror
    sta.z x+1
    lda #0
    ror
    sta.z x
    lsr.z $ff
    ror.z x+1
    ror.z x
    // s>>2
    // [666] create_sprites_player::$3 = create_sprites_player::s#2 >> 2 -- vbuaa=vbuz1_ror_2 
    lda.z s
    lsr
    lsr
    // (word)(s>>2)<<6
    // [667] create_sprites_player::$10 = (word)create_sprites_player::$3 -- vwuz1=_word_vbuaa 
    sta.z __10
    lda #0
    sta.z __10+1
    // y = ((word)(s>>2)<<6)
    // [668] create_sprites_player::y#0 = create_sprites_player::$10 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z y+1
    lsr
    sta.z $ff
    lda.z y
    ror
    sta.z y+1
    lda #0
    ror
    sta.z y
    lsr.z $ff
    ror.z y+1
    ror.z y
    // PlayerSprites[s] = PLAYER_SPRITE_OFFSET
    // [669] create_sprites_player::$8 = create_sprites_player::s#2 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [670] PlayerSprites[create_sprites_player::$8] = create_sprites_player::PLAYER_SPRITE_OFFSET#2 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z PLAYER_SPRITE_OFFSET
    sta PlayerSprites,y
    lda.z PLAYER_SPRITE_OFFSET+1
    sta PlayerSprites+1,y
    // SPRITE_ATTR.ADDR = PLAYER_SPRITE_OFFSET
    // [671] *((word*)&SPRITE_ATTR) = create_sprites_player::PLAYER_SPRITE_OFFSET#2 -- _deref_pwuc1=vwuz1 
    lda.z PLAYER_SPRITE_OFFSET
    sta SPRITE_ATTR
    lda.z PLAYER_SPRITE_OFFSET+1
    sta SPRITE_ATTR+1
    // 40+x
    // [672] create_sprites_player::$5 = $28 + create_sprites_player::x#0 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$28
    clc
    adc.z __5
    sta.z __5
    bcc !+
    inc.z __5+1
  !:
    // SPRITE_ATTR.X = 40+x
    // [673] *((word*)&SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X) = create_sprites_player::$5 -- _deref_pwuc1=vwuz1 
    lda.z __5
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X
    lda.z __5+1
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X+1
    // 100+y
    // [674] create_sprites_player::$6 = $64 + create_sprites_player::y#0 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$64
    clc
    adc.z __6
    sta.z __6
    bcc !+
    inc.z __6+1
  !:
    // SPRITE_ATTR.Y = 100+y
    // [675] *((word*)&SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y) = create_sprites_player::$6 -- _deref_pwuc1=vwuz1 
    lda.z __6
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y
    lda.z __6+1
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y+1
    // SPRITE_ATTR.CTRL2 = VERA_SPRITE_WIDTH_32 | VERA_SPRITE_HEIGHT_32 | 0x1
    // [676] *((byte*)&SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_CTRL2) = VERA_SPRITE_WIDTH_32|VERA_SPRITE_HEIGHT_32|1 -- _deref_pbuc1=vbuc2 
    lda #VERA_SPRITE_WIDTH_32|VERA_SPRITE_HEIGHT_32|1
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_CTRL2
    // vera_sprite_attributes_set(s,SPRITE_ATTR)
    // [677] vera_sprite_attributes_set::sprite#1 = create_sprites_player::s#2 -- vbuxx=vbuz1 
    ldx.z s
    // [678] *(&vera_sprite_attributes_set::sprite_attr) = memcpy(*(&SPRITE_ATTR), struct VERA_SPRITE, SIZEOF_STRUCT_VERA_SPRITE) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_VERA_SPRITE
  !:
    lda SPRITE_ATTR-1,y
    sta vera_sprite_attributes_set.sprite_attr-1,y
    dey
    bne !-
    // [679] call vera_sprite_attributes_set 
    // [710] phi from create_sprites_player::@2 to vera_sprite_attributes_set [phi:create_sprites_player::@2->vera_sprite_attributes_set]
    // [710] phi vera_sprite_attributes_set::sprite#3 = vera_sprite_attributes_set::sprite#1 [phi:create_sprites_player::@2->vera_sprite_attributes_set#0] -- register_copy 
    jsr vera_sprite_attributes_set
    // create_sprites_player::@3
    // PLAYER_SPRITE_OFFSET += 16
    // [680] create_sprites_player::PLAYER_SPRITE_OFFSET#1 = create_sprites_player::PLAYER_SPRITE_OFFSET#2 + $10 -- vwuz1=vwuz1_plus_vbuc1 
    lda #$10
    clc
    adc.z PLAYER_SPRITE_OFFSET
    sta.z PLAYER_SPRITE_OFFSET
    bcc !+
    inc.z PLAYER_SPRITE_OFFSET+1
  !:
    // for(char s=0;s<NUM_PLAYER;s++)
    // [681] create_sprites_player::s#1 = ++ create_sprites_player::s#2 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [660] phi from create_sprites_player::@3 to create_sprites_player::@1 [phi:create_sprites_player::@3->create_sprites_player::@1]
    // [660] phi create_sprites_player::PLAYER_SPRITE_OFFSET#2 = create_sprites_player::PLAYER_SPRITE_OFFSET#1 [phi:create_sprites_player::@3->create_sprites_player::@1#0] -- register_copy 
    // [660] phi create_sprites_player::s#2 = create_sprites_player::s#1 [phi:create_sprites_player::@3->create_sprites_player::@1#1] -- register_copy 
    jmp __b1
}
  // create_sprites_enemy2
create_sprites_enemy2: {
    .label __5 = $2e
    .label __6 = $67
    .label __10 = $2e
    .label __11 = $67
    .label x = $2e
    .label y = $67
    .label ENEMY2_SPRITE_OFFSET = $75
    .label s = $2d
    // [683] phi from create_sprites_enemy2 to create_sprites_enemy2::@1 [phi:create_sprites_enemy2->create_sprites_enemy2::@1]
    // [683] phi create_sprites_enemy2::ENEMY2_SPRITE_OFFSET#2 = <VRAM_ENEMY2/$20 [phi:create_sprites_enemy2->create_sprites_enemy2::@1#0] -- vwuz1=vwuc1 
    lda #<VRAM_ENEMY2/$20&$ffff
    sta.z ENEMY2_SPRITE_OFFSET
    lda #>VRAM_ENEMY2/$20&$ffff
    sta.z ENEMY2_SPRITE_OFFSET+1
    // [683] phi create_sprites_enemy2::s#2 = 0 [phi:create_sprites_enemy2->create_sprites_enemy2::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z s
    // create_sprites_enemy2::@1
  __b1:
    // for(char s=0;s<NUM_ENEMY2;s++)
    // [684] if(create_sprites_enemy2::s#2<NUM_ENEMY2) goto create_sprites_enemy2::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z s
    cmp #NUM_ENEMY2
    bcc __b2
    // create_sprites_enemy2::@return
    // }
    // [685] return 
    rts
    // create_sprites_enemy2::@2
  __b2:
    // s&03
    // [686] create_sprites_enemy2::$1 = create_sprites_enemy2::s#2 & 3 -- vbuaa=vbuz1_band_vbuc1 
    lda #3
    and.z s
    // (word)(s&03)<<6
    // [687] create_sprites_enemy2::$10 = (word)create_sprites_enemy2::$1 -- vwuz1=_word_vbuaa 
    sta.z __10
    lda #0
    sta.z __10+1
    // x = ((word)(s&03)<<6)
    // [688] create_sprites_enemy2::x#0 = create_sprites_enemy2::$10 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z x+1
    lsr
    sta.z $ff
    lda.z x
    ror
    sta.z x+1
    lda #0
    ror
    sta.z x
    lsr.z $ff
    ror.z x+1
    ror.z x
    // s>>2
    // [689] create_sprites_enemy2::$3 = create_sprites_enemy2::s#2 >> 2 -- vbuaa=vbuz1_ror_2 
    lda.z s
    lsr
    lsr
    // (word)(s>>2)<<6
    // [690] create_sprites_enemy2::$11 = (word)create_sprites_enemy2::$3 -- vwuz1=_word_vbuaa 
    sta.z __11
    lda #0
    sta.z __11+1
    // y = ((word)(s>>2)<<6)
    // [691] create_sprites_enemy2::y#0 = create_sprites_enemy2::$11 << 6 -- vwuz1=vwuz1_rol_6 
    lda.z y+1
    lsr
    sta.z $ff
    lda.z y
    ror
    sta.z y+1
    lda #0
    ror
    sta.z y
    lsr.z $ff
    ror.z y+1
    ror.z y
    // Enemy2Sprites[s] = ENEMY2_SPRITE_OFFSET
    // [692] create_sprites_enemy2::$9 = create_sprites_enemy2::s#2 << 1 -- vbuaa=vbuz1_rol_1 
    lda.z s
    asl
    // [693] Enemy2Sprites[create_sprites_enemy2::$9] = create_sprites_enemy2::ENEMY2_SPRITE_OFFSET#2 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z ENEMY2_SPRITE_OFFSET
    sta Enemy2Sprites,y
    lda.z ENEMY2_SPRITE_OFFSET+1
    sta Enemy2Sprites+1,y
    // SPRITE_ATTR.ADDR = ENEMY2_SPRITE_OFFSET
    // [694] *((word*)&SPRITE_ATTR) = create_sprites_enemy2::ENEMY2_SPRITE_OFFSET#2 -- _deref_pwuc1=vwuz1 
    lda.z ENEMY2_SPRITE_OFFSET
    sta SPRITE_ATTR
    lda.z ENEMY2_SPRITE_OFFSET+1
    sta SPRITE_ATTR+1
    // 340+x
    // [695] create_sprites_enemy2::$5 = $154 + create_sprites_enemy2::x#0 -- vwuz1=vwuc1_plus_vwuz1 
    clc
    lda.z __5
    adc #<$154
    sta.z __5
    lda.z __5+1
    adc #>$154
    sta.z __5+1
    // SPRITE_ATTR.X = 340+x
    // [696] *((word*)&SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X) = create_sprites_enemy2::$5 -- _deref_pwuc1=vwuz1 
    lda.z __5
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X
    lda.z __5+1
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X+1
    // 100+y
    // [697] create_sprites_enemy2::$6 = $64 + create_sprites_enemy2::y#0 -- vwuz1=vbuc1_plus_vwuz1 
    lda #$64
    clc
    adc.z __6
    sta.z __6
    bcc !+
    inc.z __6+1
  !:
    // SPRITE_ATTR.Y = 100+y
    // [698] *((word*)&SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y) = create_sprites_enemy2::$6 -- _deref_pwuc1=vwuz1 
    lda.z __6
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y
    lda.z __6+1
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y+1
    // SPRITE_ATTR.CTRL2 = VERA_SPRITE_WIDTH_32 | VERA_SPRITE_HEIGHT_32 | 0x2
    // [699] *((byte*)&SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_CTRL2) = VERA_SPRITE_WIDTH_32|VERA_SPRITE_HEIGHT_32|2 -- _deref_pbuc1=vbuc2 
    lda #VERA_SPRITE_WIDTH_32|VERA_SPRITE_HEIGHT_32|2
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_CTRL2
    // vera_sprite_attributes_set(s+16,SPRITE_ATTR)
    // [700] vera_sprite_attributes_set::sprite#2 = create_sprites_enemy2::s#2 + $10 -- vbuxx=vbuz1_plus_vbuc1 
    lda #$10
    clc
    adc.z s
    tax
    // [701] *(&vera_sprite_attributes_set::sprite_attr) = memcpy(*(&SPRITE_ATTR), struct VERA_SPRITE, SIZEOF_STRUCT_VERA_SPRITE) -- _deref_pssc1=_deref_pssc2_memcpy_vbuc3 
    ldy #SIZEOF_STRUCT_VERA_SPRITE
  !:
    lda SPRITE_ATTR-1,y
    sta vera_sprite_attributes_set.sprite_attr-1,y
    dey
    bne !-
    // [702] call vera_sprite_attributes_set 
    // [710] phi from create_sprites_enemy2::@2 to vera_sprite_attributes_set [phi:create_sprites_enemy2::@2->vera_sprite_attributes_set]
    // [710] phi vera_sprite_attributes_set::sprite#3 = vera_sprite_attributes_set::sprite#2 [phi:create_sprites_enemy2::@2->vera_sprite_attributes_set#0] -- register_copy 
    jsr vera_sprite_attributes_set
    // create_sprites_enemy2::@3
    // ENEMY2_SPRITE_OFFSET += 16
    // [703] create_sprites_enemy2::ENEMY2_SPRITE_OFFSET#1 = create_sprites_enemy2::ENEMY2_SPRITE_OFFSET#2 + $10 -- vwuz1=vwuz1_plus_vbuc1 
    lda #$10
    clc
    adc.z ENEMY2_SPRITE_OFFSET
    sta.z ENEMY2_SPRITE_OFFSET
    bcc !+
    inc.z ENEMY2_SPRITE_OFFSET+1
  !:
    // for(char s=0;s<NUM_ENEMY2;s++)
    // [704] create_sprites_enemy2::s#1 = ++ create_sprites_enemy2::s#2 -- vbuz1=_inc_vbuz1 
    inc.z s
    // [683] phi from create_sprites_enemy2::@3 to create_sprites_enemy2::@1 [phi:create_sprites_enemy2::@3->create_sprites_enemy2::@1]
    // [683] phi create_sprites_enemy2::ENEMY2_SPRITE_OFFSET#2 = create_sprites_enemy2::ENEMY2_SPRITE_OFFSET#1 [phi:create_sprites_enemy2::@3->create_sprites_enemy2::@1#0] -- register_copy 
    // [683] phi create_sprites_enemy2::s#2 = create_sprites_enemy2::s#1 [phi:create_sprites_enemy2::@3->create_sprites_enemy2::@1#1] -- register_copy 
    jmp __b1
}
  // fgetc
fgetc: {
    .label ch = $6b
    // ch
    // [705] fgetc::ch = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z ch
    // asm
    // asm { jsrGETIN stach  }
    jsr GETIN
    sta ch
    // return ch;
    // [707] fgetc::return#0 = fgetc::ch -- vbuaa=vbuz1 
    // fgetc::@return
    // }
    // [708] fgetc::return#1 = fgetc::return#0
    // [709] return 
    rts
}
  // vera_sprite_attributes_set
// vera_sprite_attributes_set(byte register(X) sprite, struct VERA_SPRITE zp($77) sprite_attr)
vera_sprite_attributes_set: {
    .label sprite_attr = $77
    .label __0 = $b
    .label __4 = $b
    .label sprite_offset = $b
    // (word)sprite << 3
    // [711] vera_sprite_attributes_set::$4 = (word)vera_sprite_attributes_set::sprite#3 -- vwuz1=_word_vbuxx 
    txa
    sta.z __4
    lda #0
    sta.z __4+1
    // [712] vera_sprite_attributes_set::$0 = vera_sprite_attributes_set::$4 << 3 -- vwuz1=vwuz1_rol_3 
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    // sprite_offset = (<VERA_SPRITE_ATTR)+(word)sprite << 3
    // [713] vera_sprite_attributes_set::sprite_offset#0 = <VERA_SPRITE_ATTR + vera_sprite_attributes_set::$0 -- vwuz1=vwuc1_plus_vwuz1 
    clc
    lda.z sprite_offset
    adc #<VERA_SPRITE_ATTR&$ffff
    sta.z sprite_offset
    lda.z sprite_offset+1
    adc #>VERA_SPRITE_ATTR&$ffff
    sta.z sprite_offset+1
    // memcpy_to_vram(1, sprite_offset, &sprite_attr, sizeof(sprite_attr))
    // [714] memcpy_to_vram::vdest#0 = (void*)vera_sprite_attributes_set::sprite_offset#0
    // [715] call memcpy_to_vram 
    // The sprite structure is 8 bytes line, so we multiply by 8 to get the offset of the sprite control.
    jsr memcpy_to_vram
    // vera_sprite_attributes_set::@return
    // }
    // [716] return 
    rts
}
  // vera_layer_set_text_color_mode
// Set the configuration of the layer text color mode.
// - layer: Value of 0 or 1.
// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
vera_layer_set_text_color_mode: {
    .label addr = $5a
    // addr = vera_layer_config[layer]
    // [717] vera_layer_set_text_color_mode::addr#0 = *(vera_layer_config+vera_layer_mode_text::layer#0*SIZEOF_POINTER) -- pbuz1=_deref_qbuc1 
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER
    sta.z addr
    lda vera_layer_config+vera_layer_mode_text.layer*SIZEOF_POINTER+1
    sta.z addr+1
    // *addr &= ~VERA_LAYER_CONFIG_256C
    // [718] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 & ~VERA_LAYER_CONFIG_256C -- _deref_pbuz1=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C^$ff
    ldy #0
    and (addr),y
    sta (addr),y
    // *addr |= color_mode
    // [719] *vera_layer_set_text_color_mode::addr#0 = *vera_layer_set_text_color_mode::addr#0 -- _deref_pbuz1=_deref_pbuz1 
    lda (addr),y
    sta (addr),y
    // vera_layer_set_text_color_mode::@return
    // }
    // [720] return 
    rts
}
  // vera_layer_get_mapbase_bank
// Get the map base bank of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Bank in vera vram.
// vera_layer_get_mapbase_bank(byte register(X) layer)
vera_layer_get_mapbase_bank: {
    // return vera_mapbase_bank[layer];
    // [721] vera_layer_get_mapbase_bank::return#0 = vera_mapbase_bank[vera_layer_get_mapbase_bank::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_mapbase_bank,x
    // vera_layer_get_mapbase_bank::@return
    // }
    // [722] return 
    rts
}
  // vera_layer_get_mapbase_offset
// Get the map base lower 16-bit address (offset) of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Offset in vera vram of the specified bank.
// vera_layer_get_mapbase_offset(byte register(A) layer)
vera_layer_get_mapbase_offset: {
    .label return = $5c
    // return vera_mapbase_offset[layer];
    // [723] vera_layer_get_mapbase_offset::$0 = vera_layer_get_mapbase_offset::layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [724] vera_layer_get_mapbase_offset::return#0 = vera_mapbase_offset[vera_layer_get_mapbase_offset::$0] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda vera_mapbase_offset,y
    sta.z return
    lda vera_mapbase_offset+1,y
    sta.z return+1
    // vera_layer_get_mapbase_offset::@return
    // }
    // [725] return 
    rts
}
  // vera_layer_get_rowshift
// Get the bit shift value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
// vera_layer_get_rowshift(byte register(X) layer)
vera_layer_get_rowshift: {
    // return vera_layer_rowshift[layer];
    // [726] vera_layer_get_rowshift::return#0 = vera_layer_rowshift[vera_layer_get_rowshift::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_rowshift,x
    // vera_layer_get_rowshift::@return
    // }
    // [727] return 
    rts
}
  // vera_layer_get_rowskip
// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
// vera_layer_get_rowskip(byte register(A) layer)
vera_layer_get_rowskip: {
    .label return = $5c
    // return vera_layer_rowskip[layer];
    // [728] vera_layer_get_rowskip::$0 = vera_layer_get_rowskip::layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [729] vera_layer_get_rowskip::return#0 = vera_layer_rowskip[vera_layer_get_rowskip::$0] -- vwuz1=pwuc1_derefidx_vbuaa 
    tay
    lda vera_layer_rowskip,y
    sta.z return
    lda vera_layer_rowskip+1,y
    sta.z return+1
    // vera_layer_get_rowskip::@return
    // }
    // [730] return 
    rts
}
  // vera_layer_set_config
// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
// vera_layer_set_config(byte register(A) layer, byte register(X) config)
vera_layer_set_config: {
    .label addr = $5a
    // addr = vera_layer_config[layer]
    // [731] vera_layer_set_config::$0 = vera_layer_set_config::layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [732] vera_layer_set_config::addr#0 = vera_layer_config[vera_layer_set_config::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr = config
    // [733] *vera_layer_set_config::addr#0 = vera_layer_set_config::config#0 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_config::@return
    // }
    // [734] return 
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
    .label addr = $5a
    // addr = vera_layer_tilebase[layer]
    // [735] vera_layer_set_tilebase::$0 = vera_layer_set_tilebase::layer#0 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [736] vera_layer_set_tilebase::addr#0 = vera_layer_tilebase[vera_layer_set_tilebase::$0] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_tilebase,y
    sta.z addr
    lda vera_layer_tilebase+1,y
    sta.z addr+1
    // *addr = tilebase
    // [737] *vera_layer_set_tilebase::addr#0 = vera_layer_set_tilebase::tilebase#0 -- _deref_pbuz1=vbuxx 
    txa
    ldy #0
    sta (addr),y
    // vera_layer_set_tilebase::@return
    // }
    // [738] return 
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
    // [739] vera_layer_get_backcolor::return#0 = vera_layer_backcolor[vera_layer_get_backcolor::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_backcolor,x
    // vera_layer_get_backcolor::@return
    // }
    // [740] return 
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
    // [741] vera_layer_get_textcolor::return#0 = vera_layer_textcolor[vera_layer_get_textcolor::layer#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_textcolor,x
    // vera_layer_get_textcolor::@return
    // }
    // [742] return 
    rts
}
  // cx16_ram_bank
// Configure the bank of a banked ram.
// cx16_ram_bank(byte register(A) bank)
cx16_ram_bank: {
    // VIA1->PORT_A = bank
    // [744] *((byte*)VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A) = cx16_ram_bank::bank#5 -- _deref_pbuc1=vbuaa 
    sta VIA1+OFFSET_STRUCT_MOS6522_VIA_PORT_A
    // cx16_ram_bank::@return
    // }
    // [745] return 
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
    .label filename_len = $6c
    .label __0 = $67
    // strlen(filename)
    // [746] strlen::str#1 = cbm_k_setnam::filename -- pbuz1=pbuz2 
    lda.z filename
    sta.z strlen.str
    lda.z filename+1
    sta.z strlen.str+1
    // [747] call strlen 
    // [860] phi from cbm_k_setnam to strlen [phi:cbm_k_setnam->strlen]
    jsr strlen
    // strlen(filename)
    // [748] strlen::return#2 = strlen::len#2
    // cbm_k_setnam::@1
    // [749] cbm_k_setnam::$0 = strlen::return#2
    // filename_len = (char)strlen(filename)
    // [750] cbm_k_setnam::filename_len = (byte)cbm_k_setnam::$0 -- vbuz1=_byte_vwuz2 
    lda.z __0
    sta.z filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx filename
    ldy filename+1
    jsr CBM_SETNAM
    // cbm_k_setnam::@return
    // }
    // [752] return 
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
    // [754] return 
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
    .label status = $6d
    // status
    // [755] cbm_k_open::status = 0 -- vbuz1=vbuc1 
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
    // [757] cbm_k_open::return#0 = cbm_k_open::status -- vbuaa=vbuz1 
    // cbm_k_open::@return
    // }
    // [758] cbm_k_open::return#1 = cbm_k_open::return#0
    // [759] return 
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
    .label status = $6e
    // status
    // [760] cbm_k_chkin::status = 0 -- vbuz1=vbuc1 
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
    // [762] cbm_k_chkin::return#0 = cbm_k_chkin::status -- vbuaa=vbuz1 
    // cbm_k_chkin::@return
    // }
    // [763] cbm_k_chkin::return#1 = cbm_k_chkin::return#0
    // [764] return 
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
    .label value = $6f
    // value
    // [765] cbm_k_chrin::value = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z value
    // asm
    // asm { jsrCBM_CHRIN stavalue  }
    jsr CBM_CHRIN
    sta value
    // return value;
    // [767] cbm_k_chrin::return#0 = cbm_k_chrin::value -- vbuaa=vbuz1 
    // cbm_k_chrin::@return
    // }
    // [768] cbm_k_chrin::return#1 = cbm_k_chrin::return#0
    // [769] return 
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
    .label status = $70
    // status
    // [770] cbm_k_readst::status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta status
    // return status;
    // [772] cbm_k_readst::return#0 = cbm_k_readst::status -- vbuaa=vbuz1 
    // cbm_k_readst::@return
    // }
    // [773] cbm_k_readst::return#1 = cbm_k_readst::return#0
    // [774] return 
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
    .label status = $71
    // status
    // [775] cbm_k_close::status = 0 -- vbuz1=vbuc1 
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
    // [777] cbm_k_close::return#0 = cbm_k_close::status -- vbuaa=vbuz1 
    // cbm_k_close::@return
    // }
    // [778] cbm_k_close::return#1 = cbm_k_close::return#0
    // [779] return 
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
    // [781] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte zp($2d) c)
cputc: {
    .label __16 = $67
    .label conio_addr = $2e
    .label c = $2d
    // vera_layer_get_color( conio_screen_layer)
    // [783] vera_layer_get_color::layer#0 = conio_screen_layer -- vbuxx=vbuz1 
    ldx.z conio_screen_layer
    // [784] call vera_layer_get_color 
    // [866] phi from cputc to vera_layer_get_color [phi:cputc->vera_layer_get_color]
    // [866] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#0 [phi:cputc->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color( conio_screen_layer)
    // [785] vera_layer_get_color::return#3 = vera_layer_get_color::return#2
    // cputc::@7
    // color = vera_layer_get_color( conio_screen_layer)
    // [786] cputc::color#0 = vera_layer_get_color::return#3 -- vbuxx=vbuaa 
    tax
    // CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    // [787] cputc::$15 = conio_screen_layer << 1 -- vbuaa=vbuz1_rol_1 
    lda.z conio_screen_layer
    asl
    // conio_addr = CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    // [788] cputc::conio_addr#0 = (byte*)CONIO_SCREEN_TEXT#118 + conio_line_text[cputc::$15] -- pbuz1=pbuz2_plus_pwuc1_derefidx_vbuaa 
    tay
    clc
    lda.z CONIO_SCREEN_TEXT
    adc conio_line_text,y
    sta.z conio_addr
    lda.z CONIO_SCREEN_TEXT+1
    adc conio_line_text+1,y
    sta.z conio_addr+1
    // conio_cursor_x[conio_screen_layer] << 1
    // [789] cputc::$2 = conio_cursor_x[conio_screen_layer] << 1 -- vbuaa=pbuc1_derefidx_vbuz1_rol_1 
    ldy.z conio_screen_layer
    lda conio_cursor_x,y
    asl
    // conio_addr += conio_cursor_x[conio_screen_layer] << 1
    // [790] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$2 -- pbuz1=pbuz1_plus_vbuaa 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [791] if(cputc::c#3==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [792] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <conio_addr
    // [793] cputc::$4 = < cputc::conio_addr#1 -- vbuaa=_lo_pbuz1 
    lda.z conio_addr
    // *VERA_ADDRX_L = <conio_addr
    // [794] *VERA_ADDRX_L = cputc::$4 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >conio_addr
    // [795] cputc::$5 = > cputc::conio_addr#1 -- vbuaa=_hi_pbuz1 
    lda.z conio_addr+1
    // *VERA_ADDRX_M = >conio_addr
    // [796] *VERA_ADDRX_M = cputc::$5 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // CONIO_SCREEN_BANK | VERA_INC_1
    // [797] cputc::$6 = CONIO_SCREEN_BANK#112 | VERA_INC_1 -- vbuaa=vbuz1_bor_vbuc1 
    lda #VERA_INC_1
    ora.z CONIO_SCREEN_BANK
    // *VERA_ADDRX_H = CONIO_SCREEN_BANK | VERA_INC_1
    // [798] *VERA_ADDRX_H = cputc::$6 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [799] *VERA_DATA0 = cputc::c#3 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [800] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // conio_cursor_x[conio_screen_layer]++;
    // [801] conio_cursor_x[conio_screen_layer] = ++ conio_cursor_x[conio_screen_layer] -- pbuc1_derefidx_vbuz1=_inc_pbuc1_derefidx_vbuz1 
    ldx.z conio_screen_layer
    inc conio_cursor_x,x
    // scroll_enable = conio_scroll_enable[conio_screen_layer]
    // [802] cputc::scroll_enable#0 = conio_scroll_enable[conio_screen_layer] -- vbuaa=pbuc1_derefidx_vbuz1 
    ldy.z conio_screen_layer
    lda conio_scroll_enable,y
    // if(scroll_enable)
    // [803] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b5
    // cputc::@3
    // (unsigned int)conio_cursor_x[conio_screen_layer] == conio_width
    // [804] cputc::$16 = (word)conio_cursor_x[conio_screen_layer] -- vwuz1=_word_pbuc1_derefidx_vbuz2 
    lda conio_cursor_x,y
    sta.z __16
    lda #0
    sta.z __16+1
    // if((unsigned int)conio_cursor_x[conio_screen_layer] == conio_width)
    // [805] if(cputc::$16!=conio_width) goto cputc::@return -- vwuz1_neq_vwuz2_then_la1 
    cmp.z conio_width+1
    bne __breturn
    lda.z __16
    cmp.z conio_width
    bne __breturn
    // [806] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [807] call cputln 
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [808] return 
    rts
    // cputc::@5
  __b5:
    // if(conio_cursor_x[conio_screen_layer] == CONIO_WIDTH)
    // [809] if(conio_cursor_x[conio_screen_layer]!=conio_screen_width) goto cputc::@return -- pbuc1_derefidx_vbuz1_neq_vbuz2_then_la1 
    lda.z conio_screen_width
    ldy.z conio_screen_layer
    cmp conio_cursor_x,y
    bne __breturn
    // [810] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [811] call cputln 
    jsr cputln
    rts
    // [812] phi from cputc::@7 to cputc::@1 [phi:cputc::@7->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [813] call cputln 
    jsr cputln
    rts
}
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp($2e) buffer, byte register(Y) radix)
uctoa: {
    .label buffer = $2e
    .label digit = $48
    .label started = $49
    .label max_digits = $47
    .label digit_values = $75
    // if(radix==DECIMAL)
    // [814] if(uctoa::radix#0==DECIMAL) goto uctoa::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #DECIMAL
    beq __b2
    // uctoa::@2
    // if(radix==HEXADECIMAL)
    // [815] if(uctoa::radix#0==HEXADECIMAL) goto uctoa::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #HEXADECIMAL
    beq __b3
    // uctoa::@3
    // if(radix==OCTAL)
    // [816] if(uctoa::radix#0==OCTAL) goto uctoa::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #OCTAL
    beq __b4
    // uctoa::@4
    // if(radix==BINARY)
    // [817] if(uctoa::radix#0==BINARY) goto uctoa::@1 -- vbuyy_eq_vbuc1_then_la1 
    cpy #BINARY
    beq __b5
    // uctoa::@5
    // *buffer++ = 'e'
    // [818] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS) = 'e' -- _deref_pbuc1=vbuc2 
    // Unknown radix
    lda #'e'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    // [819] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1) = 'r' -- _deref_pbuc1=vbuc2 
    lda #'r'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    // [820] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2) = 'r' -- _deref_pbuc1=vbuc2 
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    // [821] *((byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // uctoa::@return
    // }
    // [822] return 
    rts
    // [823] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
  __b2:
    // [823] phi uctoa::digit_values#8 = RADIX_DECIMAL_VALUES_CHAR [phi:uctoa->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES_CHAR
    sta.z digit_values+1
    // [823] phi uctoa::max_digits#7 = 3 [phi:uctoa->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #3
    sta.z max_digits
    jmp __b1
    // [823] phi from uctoa::@2 to uctoa::@1 [phi:uctoa::@2->uctoa::@1]
  __b3:
    // [823] phi uctoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES_CHAR [phi:uctoa::@2->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES_CHAR
    sta.z digit_values+1
    // [823] phi uctoa::max_digits#7 = 2 [phi:uctoa::@2->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #2
    sta.z max_digits
    jmp __b1
    // [823] phi from uctoa::@3 to uctoa::@1 [phi:uctoa::@3->uctoa::@1]
  __b4:
    // [823] phi uctoa::digit_values#8 = RADIX_OCTAL_VALUES_CHAR [phi:uctoa::@3->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES_CHAR
    sta.z digit_values+1
    // [823] phi uctoa::max_digits#7 = 3 [phi:uctoa::@3->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #3
    sta.z max_digits
    jmp __b1
    // [823] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
  __b5:
    // [823] phi uctoa::digit_values#8 = RADIX_BINARY_VALUES_CHAR [phi:uctoa::@4->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<RADIX_BINARY_VALUES_CHAR
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES_CHAR
    sta.z digit_values+1
    // [823] phi uctoa::max_digits#7 = 8 [phi:uctoa::@4->uctoa::@1#1] -- vbuz1=vbuc1 
    lda #8
    sta.z max_digits
    // uctoa::@1
  __b1:
    // [824] phi from uctoa::@1 to uctoa::@6 [phi:uctoa::@1->uctoa::@6]
    // [824] phi uctoa::buffer#11 = (byte*)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:uctoa::@1->uctoa::@6#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [824] phi uctoa::started#2 = 0 [phi:uctoa::@1->uctoa::@6#1] -- vbuz1=vbuc1 
    lda #0
    sta.z started
    // [824] phi uctoa::value#2 = uctoa::value#1 [phi:uctoa::@1->uctoa::@6#2] -- register_copy 
    // [824] phi uctoa::digit#2 = 0 [phi:uctoa::@1->uctoa::@6#3] -- vbuz1=vbuc1 
    sta.z digit
    // uctoa::@6
  __b6:
    // max_digits-1
    // [825] uctoa::$4 = uctoa::max_digits#7 - 1 -- vbuaa=vbuz1_minus_1 
    lda.z max_digits
    sec
    sbc #1
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [826] if(uctoa::digit#2<uctoa::$4) goto uctoa::@7 -- vbuz1_lt_vbuaa_then_la1 
    cmp.z digit
    beq !+
    bcs __b7
  !:
    // uctoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [827] *uctoa::buffer#11 = DIGITS[uctoa::value#2] -- _deref_pbuz1=pbuc1_derefidx_vbuxx 
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [828] uctoa::buffer#3 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [829] *uctoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    rts
    // uctoa::@7
  __b7:
    // digit_value = digit_values[digit]
    // [830] uctoa::digit_value#0 = uctoa::digit_values#8[uctoa::digit#2] -- vbuyy=pbuz1_derefidx_vbuz2 
    ldy.z digit
    lda (digit_values),y
    tay
    // if (started || value >= digit_value)
    // [831] if(0!=uctoa::started#2) goto uctoa::@10 -- 0_neq_vbuz1_then_la1 
    lda.z started
    cmp #0
    bne __b10
    // uctoa::@12
    // [832] if(uctoa::value#2>=uctoa::digit_value#0) goto uctoa::@10 -- vbuxx_ge_vbuyy_then_la1 
    sty.z $ff
    cpx.z $ff
    bcs __b10
    // [833] phi from uctoa::@12 to uctoa::@9 [phi:uctoa::@12->uctoa::@9]
    // [833] phi uctoa::buffer#14 = uctoa::buffer#11 [phi:uctoa::@12->uctoa::@9#0] -- register_copy 
    // [833] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@12->uctoa::@9#1] -- register_copy 
    // [833] phi uctoa::value#6 = uctoa::value#2 [phi:uctoa::@12->uctoa::@9#2] -- register_copy 
    // uctoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [834] uctoa::digit#1 = ++ uctoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [824] phi from uctoa::@9 to uctoa::@6 [phi:uctoa::@9->uctoa::@6]
    // [824] phi uctoa::buffer#11 = uctoa::buffer#14 [phi:uctoa::@9->uctoa::@6#0] -- register_copy 
    // [824] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@9->uctoa::@6#1] -- register_copy 
    // [824] phi uctoa::value#2 = uctoa::value#6 [phi:uctoa::@9->uctoa::@6#2] -- register_copy 
    // [824] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@9->uctoa::@6#3] -- register_copy 
    jmp __b6
    // uctoa::@10
  __b10:
    // uctoa_append(buffer++, value, digit_value)
    // [835] uctoa_append::buffer#0 = uctoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z uctoa_append.buffer
    lda.z buffer+1
    sta.z uctoa_append.buffer+1
    // [836] uctoa_append::value#0 = uctoa::value#2
    // [837] uctoa_append::sub#0 = uctoa::digit_value#0 -- vbuz1=vbuyy 
    sty.z uctoa_append.sub
    // [838] call uctoa_append 
    // [885] phi from uctoa::@10 to uctoa_append [phi:uctoa::@10->uctoa_append]
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // [839] uctoa_append::return#0 = uctoa_append::value#2
    // uctoa::@11
    // value = uctoa_append(buffer++, value, digit_value)
    // [840] uctoa::value#0 = uctoa_append::return#0
    // value = uctoa_append(buffer++, value, digit_value);
    // [841] uctoa::buffer#4 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [833] phi from uctoa::@11 to uctoa::@9 [phi:uctoa::@11->uctoa::@9]
    // [833] phi uctoa::buffer#14 = uctoa::buffer#4 [phi:uctoa::@11->uctoa::@9#0] -- register_copy 
    // [833] phi uctoa::started#4 = 1 [phi:uctoa::@11->uctoa::@9#1] -- vbuz1=vbuc1 
    lda #1
    sta.z started
    // [833] phi uctoa::value#6 = uctoa::value#0 [phi:uctoa::@11->uctoa::@9#2] -- register_copy 
    jmp __b9
}
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// printf_number_buffer(byte register(A) buffer_sign)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // printf_number_buffer::@1
    // if(buffer.sign)
    // [843] if(0==printf_number_buffer::buffer_sign#0) goto printf_number_buffer::@2 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b2
    // printf_number_buffer::@3
    // cputc(buffer.sign)
    // [844] cputc::c#2 = printf_number_buffer::buffer_sign#0 -- vbuz1=vbuaa 
    sta.z cputc.c
    // [845] call cputc 
    // [782] phi from printf_number_buffer::@3 to cputc [phi:printf_number_buffer::@3->cputc]
    // [782] phi cputc::c#3 = cputc::c#2 [phi:printf_number_buffer::@3->cputc#0] -- register_copy 
    jsr cputc
    // [846] phi from printf_number_buffer::@1 printf_number_buffer::@3 to printf_number_buffer::@2 [phi:printf_number_buffer::@1/printf_number_buffer::@3->printf_number_buffer::@2]
    // printf_number_buffer::@2
  __b2:
    // cputs(buffer.digits)
    // [847] call cputs 
    // [579] phi from printf_number_buffer::@2 to cputs [phi:printf_number_buffer::@2->cputs]
    // [579] phi cputs::s#16 = printf_number_buffer::buffer_digits#0 [phi:printf_number_buffer::@2->cputs#0] -- pbuz1=pbuc1 
    lda #<buffer_digits
    sta.z cputs.s
    lda #>buffer_digits
    sta.z cputs.s+1
    jsr cputs
    // printf_number_buffer::@return
    // }
    // [848] return 
    rts
}
  // memcpy_to_vram
// Copy block of memory (from RAM to VRAM)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - src: The source address in RAM
// - num: The number of bytes to copy
// memcpy_to_vram(void* zp($b) vdest)
memcpy_to_vram: {
    .const vbank = 1
    .label src = vera_sprite_attributes_set.sprite_attr
    .label end = src+SIZEOF_STRUCT_VERA_SPRITE
    .label s = $55
    .label vdest = $b
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [849] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <vdest
    // [850] memcpy_to_vram::$0 = < memcpy_to_vram::vdest#0 -- vbuaa=_lo_pvoz1 
    lda.z vdest
    // *VERA_ADDRX_L = <vdest
    // [851] *VERA_ADDRX_L = memcpy_to_vram::$0 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // >vdest
    // [852] memcpy_to_vram::$1 = > memcpy_to_vram::vdest#0 -- vbuaa=_hi_pvoz1 
    lda.z vdest+1
    // *VERA_ADDRX_M = >vdest
    // [853] *VERA_ADDRX_M = memcpy_to_vram::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1 | vbank
    // [854] *VERA_ADDRX_H = VERA_INC_1|memcpy_to_vram::vbank#0 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1|vbank
    sta VERA_ADDRX_H
    // [855] phi from memcpy_to_vram to memcpy_to_vram::@1 [phi:memcpy_to_vram->memcpy_to_vram::@1]
    // [855] phi memcpy_to_vram::s#2 = (byte*)memcpy_to_vram::src#0 [phi:memcpy_to_vram->memcpy_to_vram::@1#0] -- pbuz1=pbuc1 
    lda #<src
    sta.z s
    lda #>src
    sta.z s+1
    // memcpy_to_vram::@1
  __b1:
    // for(char *s = src; s!=end; s++)
    // [856] if(memcpy_to_vram::s#2!=memcpy_to_vram::end#0) goto memcpy_to_vram::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z s+1
    cmp #>end
    bne __b2
    lda.z s
    cmp #<end
    bne __b2
    // memcpy_to_vram::@return
    // }
    // [857] return 
    rts
    // memcpy_to_vram::@2
  __b2:
    // *VERA_DATA0 = *s
    // [858] *VERA_DATA0 = *memcpy_to_vram::s#2 -- _deref_pbuc1=_deref_pbuz1 
    ldy #0
    lda (s),y
    sta VERA_DATA0
    // for(char *s = src; s!=end; s++)
    // [859] memcpy_to_vram::s#1 = ++ memcpy_to_vram::s#2 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [855] phi from memcpy_to_vram::@2 to memcpy_to_vram::@1 [phi:memcpy_to_vram::@2->memcpy_to_vram::@1]
    // [855] phi memcpy_to_vram::s#2 = memcpy_to_vram::s#1 [phi:memcpy_to_vram::@2->memcpy_to_vram::@1#0] -- register_copy 
    jmp __b1
}
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp($2e) str)
strlen: {
    .label len = $67
    .label str = $2e
    .label return = $67
    // [861] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [861] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z len
    sta.z len+1
    // [861] phi strlen::str#3 = strlen::str#1 [phi:strlen->strlen::@1#1] -- register_copy 
    // strlen::@1
  __b1:
    // while(*str)
    // [862] if(0!=*strlen::str#3) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [863] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [864] strlen::len#1 = ++ strlen::len#2 -- vwuz1=_inc_vwuz1 
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    // [865] strlen::str#0 = ++ strlen::str#3 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [861] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [861] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [861] phi strlen::str#3 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
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
    .label addr = $72
    // addr = vera_layer_config[layer]
    // [867] vera_layer_get_color::$3 = vera_layer_get_color::layer#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [868] vera_layer_get_color::addr#0 = vera_layer_config[vera_layer_get_color::$3] -- pbuz1=qbuc1_derefidx_vbuaa 
    tay
    lda vera_layer_config,y
    sta.z addr
    lda vera_layer_config+1,y
    sta.z addr+1
    // *addr & VERA_LAYER_CONFIG_256C
    // [869] vera_layer_get_color::$0 = *vera_layer_get_color::addr#0 & VERA_LAYER_CONFIG_256C -- vbuaa=_deref_pbuz1_band_vbuc1 
    lda #VERA_LAYER_CONFIG_256C
    ldy #0
    and (addr),y
    // if( *addr & VERA_LAYER_CONFIG_256C )
    // [870] if(0!=vera_layer_get_color::$0) goto vera_layer_get_color::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // vera_layer_get_color::@2
    // vera_layer_backcolor[layer] << 4
    // [871] vera_layer_get_color::$1 = vera_layer_backcolor[vera_layer_get_color::layer#2] << 4 -- vbuaa=pbuc1_derefidx_vbuxx_rol_4 
    lda vera_layer_backcolor,x
    asl
    asl
    asl
    asl
    // return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
    // [872] vera_layer_get_color::return#1 = vera_layer_get_color::$1 | vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuaa=vbuaa_bor_pbuc1_derefidx_vbuxx 
    ora vera_layer_textcolor,x
    // [873] phi from vera_layer_get_color::@1 vera_layer_get_color::@2 to vera_layer_get_color::@return [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return]
    // [873] phi vera_layer_get_color::return#2 = vera_layer_get_color::return#0 [phi:vera_layer_get_color::@1/vera_layer_get_color::@2->vera_layer_get_color::@return#0] -- register_copy 
    // vera_layer_get_color::@return
    // }
    // [874] return 
    rts
    // vera_layer_get_color::@1
  __b1:
    // return (vera_layer_textcolor[layer]);
    // [875] vera_layer_get_color::return#0 = vera_layer_textcolor[vera_layer_get_color::layer#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda vera_layer_textcolor,x
    rts
}
  // cputln
// Print a newline
cputln: {
    .label temp = $2e
    // temp = conio_line_text[conio_screen_layer]
    // [876] cputln::$2 = conio_screen_layer << 1 -- vbuaa=vbuz1_rol_1 
    lda.z conio_screen_layer
    asl
    // [877] cputln::temp#0 = conio_line_text[cputln::$2] -- vwuz1=pwuc1_derefidx_vbuaa 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    tay
    lda conio_line_text,y
    sta.z temp
    lda conio_line_text+1,y
    sta.z temp+1
    // temp += conio_rowskip
    // [878] cputln::temp#1 = cputln::temp#0 + conio_rowskip -- vwuz1=vwuz1_plus_vwuz2 
    lda.z temp
    clc
    adc.z conio_rowskip
    sta.z temp
    lda.z temp+1
    adc.z conio_rowskip+1
    sta.z temp+1
    // conio_line_text[conio_screen_layer] = temp
    // [879] cputln::$3 = conio_screen_layer << 1 -- vbuaa=vbuz1_rol_1 
    lda.z conio_screen_layer
    asl
    // [880] conio_line_text[cputln::$3] = cputln::temp#1 -- pwuc1_derefidx_vbuaa=vwuz1 
    tay
    lda.z temp
    sta conio_line_text,y
    lda.z temp+1
    sta conio_line_text+1,y
    // conio_cursor_x[conio_screen_layer] = 0
    // [881] conio_cursor_x[conio_screen_layer] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z conio_screen_layer
    sta conio_cursor_x,y
    // conio_cursor_y[conio_screen_layer]++;
    // [882] conio_cursor_y[conio_screen_layer] = ++ conio_cursor_y[conio_screen_layer] -- pbuc1_derefidx_vbuz1=_inc_pbuc1_derefidx_vbuz1 
    ldx.z conio_screen_layer
    inc conio_cursor_y,x
    // cscroll()
    // [883] call cscroll 
    jsr cscroll
    // cputln::@return
    // }
    // [884] return 
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
// uctoa_append(byte* zp($72) buffer, byte register(X) value, byte zp($2d) sub)
uctoa_append: {
    .label buffer = $72
    .label sub = $2d
    // [886] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [886] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbuyy=vbuc1 
    ldy #0
    // [886] phi uctoa_append::value#2 = uctoa_append::value#0 [phi:uctoa_append->uctoa_append::@1#1] -- register_copy 
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [887] if(uctoa_append::value#2>=uctoa_append::sub#0) goto uctoa_append::@2 -- vbuxx_ge_vbuz1_then_la1 
    cpx.z sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [888] *uctoa_append::buffer#0 = DIGITS[uctoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuyy 
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // uctoa_append::@return
    // }
    // [889] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [890] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbuyy=_inc_vbuyy 
    iny
    // value -= sub
    // [891] uctoa_append::value#1 = uctoa_append::value#2 - uctoa_append::sub#0 -- vbuxx=vbuxx_minus_vbuz1 
    txa
    sec
    sbc.z sub
    tax
    // [886] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [886] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    // [886] phi uctoa_append::value#2 = uctoa_append::value#1 [phi:uctoa_append::@2->uctoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y[conio_screen_layer]>=CONIO_HEIGHT)
    // [892] if(conio_cursor_y[conio_screen_layer]<conio_screen_height) goto cscroll::@return -- pbuc1_derefidx_vbuz1_lt_vbuz2_then_la1 
    ldy.z conio_screen_layer
    lda conio_cursor_y,y
    cmp.z conio_screen_height
    bcc __b3
    // cscroll::@1
    // if(conio_scroll_enable[conio_screen_layer])
    // [893] if(0!=conio_scroll_enable[conio_screen_layer]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_vbuz1_then_la1 
    lda conio_scroll_enable,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(conio_cursor_y[conio_screen_layer]>=conio_height)
    // [894] if(conio_cursor_y[conio_screen_layer]<conio_height) goto cscroll::@return -- pbuc1_derefidx_vbuz1_lt_vwuz2_then_la1 
    lda conio_cursor_y,y
    ldy.z conio_height+1
    bne __b3
    cmp.z conio_height
    // [895] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
  __b3:
    // cscroll::@return
    // }
    // [896] return 
    rts
    // [897] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [898] call insertup 
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, CONIO_HEIGHT-1)
    // [899] gotoxy::y#2 = conio_screen_height - 1 -- vbuxx=vbuz1_minus_1 
    ldx.z conio_screen_height
    dex
    // [900] call gotoxy 
    // [395] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [395] phi gotoxy::y#3 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    jsr gotoxy
    rts
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label cy = $2d
    .label width = $74
    .label line = $75
    .label start = $75
    // cy = conio_cursor_y[conio_screen_layer]
    // [901] insertup::cy#0 = conio_cursor_y[conio_screen_layer] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z conio_screen_layer
    lda conio_cursor_y,y
    sta.z cy
    // width = CONIO_WIDTH * 2
    // [902] insertup::width#0 = conio_screen_width << 1 -- vbuz1=vbuz2_rol_1 
    lda.z conio_screen_width
    asl
    sta.z width
    // [903] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [903] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuxx=vbuc1 
    ldx #1
    // insertup::@1
  __b1:
    // for(unsigned byte i=1; i<=cy; i++)
    // [904] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuxx_le_vbuz1_then_la1 
    lda.z cy
    stx.z $ff
    cmp.z $ff
    bcs __b2
    // [905] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [906] call clearline 
    jsr clearline
    // insertup::@return
    // }
    // [907] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [908] insertup::$3 = insertup::i#2 - 1 -- vbuaa=vbuxx_minus_1 
    txa
    sec
    sbc #1
    // line = (i-1) << conio_rowshift
    // [909] insertup::line#0 = insertup::$3 << conio_rowshift -- vwuz1=vbuaa_rol_vbuz2 
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
    // [910] insertup::start#0 = (byte*)CONIO_SCREEN_TEXT#118 + insertup::line#0 -- pbuz1=pbuz2_plus_vwuz1 
    lda.z start
    clc
    adc.z CONIO_SCREEN_TEXT
    sta.z start
    lda.z start+1
    adc.z CONIO_SCREEN_TEXT+1
    sta.z start+1
    // start+conio_rowskip
    // [911] memcpy_in_vram::src#0 = insertup::start#0 + conio_rowskip -- pbuz1=pbuz2_plus_vwuz3 
    lda.z start
    clc
    adc.z conio_rowskip
    sta.z memcpy_in_vram.src
    lda.z start+1
    adc.z conio_rowskip+1
    sta.z memcpy_in_vram.src+1
    // memcpy_in_vram(0, start, VERA_INC_1,  0, start+conio_rowskip, VERA_INC_1, width)
    // [912] memcpy_in_vram::dest#0 = (void*)insertup::start#0 -- pvoz1=pvoz2 
    lda.z start
    sta.z memcpy_in_vram.dest
    lda.z start+1
    sta.z memcpy_in_vram.dest+1
    // [913] memcpy_in_vram::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z memcpy_in_vram.num
    lda #0
    sta.z memcpy_in_vram.num+1
    // [914] memcpy_in_vram::src#4 = (void*)memcpy_in_vram::src#0
    // memcpy_in_vram(0, start, VERA_INC_1,  0, start+conio_rowskip, VERA_INC_1, width)
    // [915] call memcpy_in_vram 
    // [236] phi from insertup::@2 to memcpy_in_vram [phi:insertup::@2->memcpy_in_vram]
    // [236] phi memcpy_in_vram::num#4 = memcpy_in_vram::num#0 [phi:insertup::@2->memcpy_in_vram#0] -- register_copy 
    // [236] phi memcpy_in_vram::dest_bank#3 = 0 [phi:insertup::@2->memcpy_in_vram#1] -- vbuz1=vbuc1 
    sta.z memcpy_in_vram.dest_bank
    // [236] phi memcpy_in_vram::dest#3 = memcpy_in_vram::dest#0 [phi:insertup::@2->memcpy_in_vram#2] -- register_copy 
    // [236] phi memcpy_in_vram::src_bank#3 = 0 [phi:insertup::@2->memcpy_in_vram#3] -- vbuyy=vbuc1 
    tay
    // [236] phi memcpy_in_vram::src#3 = memcpy_in_vram::src#4 [phi:insertup::@2->memcpy_in_vram#4] -- register_copy 
    jsr memcpy_in_vram
    // insertup::@4
    // for(unsigned byte i=1; i<=cy; i++)
    // [916] insertup::i#1 = ++ insertup::i#2 -- vbuxx=_inc_vbuxx 
    inx
    // [903] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [903] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
}
  // clearline
clearline: {
    .label addr = $67
    .label c = $67
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [917] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    // [918] clearline::$5 = conio_screen_layer << 1 -- vbuaa=vbuz1_rol_1 
    lda.z conio_screen_layer
    asl
    // addr = CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer]
    // [919] clearline::addr#0 = (byte*)CONIO_SCREEN_TEXT#118 + conio_line_text[clearline::$5] -- pbuz1=pbuz2_plus_pwuc1_derefidx_vbuaa 
    tay
    clc
    lda.z CONIO_SCREEN_TEXT
    adc conio_line_text,y
    sta.z addr
    lda.z CONIO_SCREEN_TEXT+1
    adc conio_line_text+1,y
    sta.z addr+1
    // <addr
    // [920] clearline::$1 = < clearline::addr#0 -- vbuaa=_lo_pbuz1 
    lda.z addr
    // *VERA_ADDRX_L = <addr
    // [921] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // >addr
    // [922] clearline::$2 = > clearline::addr#0 -- vbuaa=_hi_pbuz1 
    lda.z addr+1
    // *VERA_ADDRX_M = >addr
    // [923] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [924] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // vera_layer_get_color( conio_screen_layer)
    // [925] vera_layer_get_color::layer#1 = conio_screen_layer -- vbuxx=vbuz1 
    ldx.z conio_screen_layer
    // [926] call vera_layer_get_color 
    // [866] phi from clearline to vera_layer_get_color [phi:clearline->vera_layer_get_color]
    // [866] phi vera_layer_get_color::layer#2 = vera_layer_get_color::layer#1 [phi:clearline->vera_layer_get_color#0] -- register_copy 
    jsr vera_layer_get_color
    // vera_layer_get_color( conio_screen_layer)
    // [927] vera_layer_get_color::return#4 = vera_layer_get_color::return#2
    // clearline::@4
    // color = vera_layer_get_color( conio_screen_layer)
    // [928] clearline::color#0 = vera_layer_get_color::return#4 -- vbuxx=vbuaa 
    tax
    // [929] phi from clearline::@4 to clearline::@1 [phi:clearline::@4->clearline::@1]
    // [929] phi clearline::c#2 = 0 [phi:clearline::@4->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<CONIO_WIDTH; c++ )
    // [930] if(clearline::c#2<conio_screen_width) goto clearline::@2 -- vwuz1_lt_vbuz2_then_la1 
    lda.z c+1
    bne !+
    lda.z c
    cmp.z conio_screen_width
    bcc __b2
  !:
    // clearline::@3
    // conio_cursor_x[conio_screen_layer] = 0
    // [931] conio_cursor_x[conio_screen_layer] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    ldy.z conio_screen_layer
    sta conio_cursor_x,y
    // clearline::@return
    // }
    // [932] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [933] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [934] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuxx 
    stx VERA_DATA0
    // for( unsigned int c=0;c<CONIO_WIDTH; c++ )
    // [935] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [929] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [929] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
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
  // Values of binary digits
  RADIX_BINARY_VALUES_CHAR: .byte $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES_CHAR: .byte $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
  SquareMetal: .byte $10, $40, $10, 4, 4, 4
  TileMetal: .byte $10+$40, $40, $10, 4, 4, 5
  SquareRaster: .byte $10+$40+$40, $40, $10, 4, 4, 6
  TileDB: .word SquareMetal, TileMetal, SquareRaster
  PlayerSprites: .fill 2*NUM_PLAYER, 0
  Enemy2Sprites: .fill 2*NUM_ENEMY2, 0
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
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
  // Sprite attributes: 4bpp, in front, 32x32, address SPRITE_PIXELS_VRAM
  SPRITE_ATTR: .word 0, $140-$20, $f0-$20
  .byte $c, VERA_SPRITE_WIDTH_32|VERA_SPRITE_HEIGHT_32|1
