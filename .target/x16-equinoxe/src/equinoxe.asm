  // File Comments
// Space flight engine for a space game written in kickc for the Commander X16.
  // Upstart
.cpu _65c02
  .file                               [name="equinoxe.prg", type="prg", segments="Program"]
.file                               [name="STAGES.BIN",         type="bin", segments="CodeEngineStages, BramEngineStages"]
.file                               [name="PLAYERS.BIN",        type="bin", segments="CodeEnginePlayers"]
.file                               [name="BULLETS.BIN",        type="bin", segments="CodeEngineBullets"]
.file                               [name="ENEMIES.BIN",        type="bin", segments="CodeEngineEnemies"]
.file                               [name="TOWERS.BIN",         type="bin", segments="CodeEngineTowers"]
.file                               [name="BRAMFLIGHT1.BIN",    type="bin", segments="BramEngineFlight"]
.file                               [name="BRAMFLOOR1.BIN",     type="bin", segments="BramEngineFloor"]
.segmentdef Program                 [segments="Basic, Code, Data" + 
                                     ", CodeBramHeap" +
                                     ", CodeVeraHeap" +
                                     ", CodeLruCache" + 
                                     ", CodeEngineFloor" +
                                     ", CodeEngineAnimate" +
                                     ", CodeEngineFlight" +
                                     ", CodeEnginePalette" +
                                     ", DataBramHeap" +
                                     ", DataVeraHeap" +
                                     ", DataEngineFloor" +
                                     ", DataEngineAnimate" +
                                     ", DataEngineStages" +
                                     ", DataEngineBullets" +
                                     ", DataEnginePlayers" +
                                     ", DataEngineEnemies" +
                                     ", DataEngineFlight" +
                                     ", DataEnginePalette" +
//                                     ", BramEngineFloor" +
                                     ", DataSpriteCache"
                                     ]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=$80d]
.segmentdef CodeBramHeap            [startAfter="Code"] 
.segmentdef CodeVeraHeap            [startAfter="CodeBramHeap"] 
.segmentdef CodeLruCache            [startAfter="CodeVeraHeap"] 
.segmentdef CodeEngineFlight        [startAfter="CodeLruCache"] 
.segmentdef CodeEngineFloor         [startAfter="CodeEngineFlight"] 
.segmentdef CodeEngineAnimate       [startAfter="CodeEngineFloor"] 
.segmentdef CodeEnginePalette       [startAfter="CodeEngineAnimate"] 

.segmentdef Data                    [startAfter="CodeEnginePalette", align=$100]
.segmentdef DataBramHeap            [startAfter="Data"] 
.segmentdef DataVeraHeap            [startAfter="DataBramHeap"] 
.segmentdef DataEngineAnimate       [startAfter="DataVeraHeap"] 
.segmentdef DataEnginePalette       [startAfter="DataEngineAnimate"] 
.segmentdef DataEngineFloor         [startAfter="DataEnginePalette"] 
.segmentdef DataEngineStages        [startAfter="DataEngineFloor"]
.segmentdef DataEngineBullets       [startAfter="DataEngineStages"]
.segmentdef DataEnginePlayers       [startAfter="DataEngineBullets"]
.segmentdef DataEngineEnemies       [startAfter="DataEnginePlayers"]
.segmentdef DataEngineTowers        [startAfter="DataEngineEnemies"]
.segmentdef DataEngineFlight        [startAfter="DataEngineTowers", align=$100] 
.segmentdef DataSpriteCache         [startAfter="DataEngineFlight", align=$100]


//.segmentdef BramEngineFloor       [startAfter=""] 


.segmentdef Hash                    [start=$0400, min=$0400, max=$06FF, align=$100]

.segmentdef Debug                   [startAfter="Hash", align=$100]

.segmentdef BramBramHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef BramVeraHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]

//.segmentdef CodeVeraHeap            [startAfter="BramVeraHeap", min=$A000, max=$BFFF, align=$100] 
//.segmentdef DataVeraHeap            [startAfter="CodeVeraHeap", min=$A000, max=$BFFF, align=$100] 

.segmentdef CodeEngineStages        [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef BramEngineStages        [startAfter="CodeEngineStages", min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEnginePlayers       [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineBullets       [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineEnemies       [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineTowers        [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef BramEngineFloor         [start=$A000, min=$A000, max=$BF00, align=$100]
.segmentdef BramEngineFlight        [start=$A000, min=$A000, max=$BF00, align=$100]
.segmentdef BramEnginePalette       [start=$A000, min=$A000, max=$BFFF, align=$100]

//.segmentdef CodeEngineFloor         [start=$A000, min=$A000, max=$BF00, align=$100]
//.segmentdef CodeEngineFlight        [start=$A000, min=$A000, max=$BFFF, align=$100]


.segment Basic
:BasicUpstart(__start)
.segment Code
.segment CodeEngineFloor
.segment CodeEngineFlight
.segment CodeEngineStages
.segment CodeEngineBullets
.segment CodeEngineEnemies
.segment CodeEnginePlayers
.segment Data
.segment Code


  // Global Constants & labels
  .const CX16_ROM_KERNAL = 0
  .const CX16_ROM_BASIC = 4
  /// The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const RED = 2
  .const BLUE = 6
  .const YELLOW = 7
  .const GREY = $c
  .const LIGHT_BLUE = $e
  /**
 * @file kernal.h
 * @author your name (you@domain.com)
 * @brief Most common CBM Kernal calls with it's dialects in the different CBM kernal family platforms.
 * Please refer to http://sta.c64.org/cbm64krnfunc.html for the list of standard CBM C64 kernal functions.
 *
 * @version 1.0
 * @date 2023-03-22
 *
 * @copyright Copyright (c) 2023
 *
 */
  .const CBM_SETNAM = $ffbd
  ///< Set the name of a file.
  .const CBM_SETLFS = $ffba
  ///< Set the logical file.
  .const CBM_OPEN = $ffc0
  ///< Open the file for the current logical file.
  .const CBM_CHKIN = $ffc6
  ///< Set the logical channel for input.
  .const CBM_READST = $ffb7
  ///< Check I/O errors.
  .const CBM_CHRIN = $ffcf
  ///< Read a character from the current channel for input.
  .const CBM_GETIN = $ffe4
  ///< Scan a character from the keyboard.
  .const CBM_CLOSE = $ffc3
  ///< Close a logical file.
  .const CBM_CLRCHN = $ffcc
  ///< Load a logical file.
  .const CBM_PLOT = $fff0
  ///< CX16 Set/Get screen mode.
  .const CX16_SCREEN_SET_CHARSET = $ff62
  ///< CX16 Set character set.
  .const CX16_MACPTR = $ff44
  .const VERA_INC_1 = $10
  .const VERA_DCSEL = 2
  .const VERA_ADDRSEL = 1
  .const VERA_VSYNC = 1
  .const VERA_SPRITES_ENABLE = $40
  .const VERA_LAYER1_ENABLE = $20
  .const VERA_LAYER0_ENABLE = $10
  .const VERA_LAYER_WIDTH_128 = $20
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_64 = $40
  .const VERA_LAYER_HEIGHT_MASK = $c0
  .const VERA_LAYER_COLOR_DEPTH_MASK = 3
  .const VERA_TILEBASE_WIDTH_MASK = 1
  .const VERA_TILEBASE_HEIGHT_MASK = 2
  .const VERA_LAYER_TILEBASE_MASK = $fc
  /// Sprite Attributes address in VERA VRAM $1FC00 - $1FFFF
  .const VERA_SPRITE_ATTR = $1fc00
  // xBPP sprite modes
  // Sprite flip
  // Sprite ZDepth
  // Sprite width
  // Sprite height
  .const VERA_SPRITE_PALETTE_OFFSET_MASK = $f
  // CX16 CBM Mouse Routines
  .const CX16_MOUSE_CONFIG = $ff68
  // ISR routine to scan the mouse state.
  .const CX16_MOUSE_GET = $ff6b
  .const STAGE_ACTION_MOVE = 2
  .const STAGE_ACTION_TURN = 3
  .const STAGE_ACTION_END = $ff
  .const FE_CACHE = $10
  .const SIZEOF_STRUCT___19 = $10
  .const SIZEOF_STRUCT___42 = $10
  .const SIZEOF_STRUCT___1 = $8f
  .const SIZEOF_STRUCT___2 = $90
  .const SIZEOF_STRUCT___3 = 9
  .const SIZEOF_STRUCT___17 = 4
  .const SIZEOF_STRUCT___24 = 5
  .const SIZEOF_STRUCT___28 = $c
  .const SIZEOF_STRUCT___20 = $250
  .const SIZEOF_STRUCT___48 = $ad6
  .const SIZEOF_STRUCT___4 = $200
  .const SIZEOF_STRUCT___57 = $100
  .const SIZEOF_STRUCT___49 = $a8
  .const SIZEOF_STRUCT___50 = $38
  /// $9F20 VRAM Address (7:0)
  .label VERA_ADDRX_L = $9f20
  /// $9F21 VRAM Address (15:8)
  .label VERA_ADDRX_M = $9f21
  /// $9F22 VRAM Address (7:0)
  /// Bit 4-7: Address Increment  The following is the amount incremented per value value:increment
  ///                             0:0, 1:1, 2:2, 3:4, 4:8, 5:16, 6:32, 7:64, 8:128, 9:256, 10:512, 11:40, 12:80, 13:160, 14:320, 15:640
  /// Bit 3: DECR Setting the DECR bit, will decrement instead of increment by the value set by the 'Address Increment' field.
  /// Bit 0: VRAM Address (16)
  .label VERA_ADDRX_H = $9f22
  /// $9F23	DATA0	VRAM Data port 0
  .label VERA_DATA0 = $9f23
  /// $9F25	CTRL Control
  /// Bit 7: Reset
  /// Bit 1: DCSEL
  /// Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  /// $9F26	IEN		Interrupt Enable
  /// Bit 7: IRQ line (8)
  /// Bit 3: AFLOW
  /// Bit 2: SPRCOL
  /// Bit 1: LINE
  /// Bit 0: VSYNC
  .label VERA_IEN = $9f26
  /// $9F27	ISR     Interrupt Status
  /// Interrupts will be generated for the interrupt sources set in the lower 4 bits of IEN. ISR will indicate the interrupts that have occurred.
  /// Writing a 1 to one of the lower 3 bits in ISR will clear that interrupt status. AFLOW can only be cleared by filling the audio FIFO for at least 1/4.
  /// Bit 4-7: Sprite Collisions. This field indicates which groups of sprites have collided.
  /// Bit 3: AFLOW
  /// Bit 2: SPRCOL
  /// Bit 1: LINE
  /// Bit 0: VSYNC
  .label VERA_ISR = $9f27
  /// $9F28	IRQLINE_L	IRQ line (7:0)
  /// IRQ_LINE specifies at which line the LINE interrupt will be generated.
  /// Note that bit 8 of this value is present in the IEN register.
  /// For interlaced modes the interrupt will be generated each field and the bit 0 of IRQ_LINE is ignored.
  .label VERA_IRQLINE_L = $9f28
  /// $9F29	DC_VIDEO (DCSEL=0)
  /// Bit 7: Current Field     Read-only bit which reflects the active interlaced field in composite and RGB modes. (0: even, 1: odd)
  /// Bit 6: Sprites Enable	Enable output from the Sprites renderer
  /// Bit 5: Layer1 Enable	    Enable output from the Layer1 renderer
  /// Bit 4: Layer0 Enable	    Enable output from the Layer0 renderer
  /// Bit 2: Chroma Disable    Setting 'Chroma Disable' disables output of chroma in NTSC composite mode and will give a better picture on a monochrome display. (Setting this bit will also disable the chroma output on the S-video output.)
  /// Bit 0-1: Output Mode     0: Video disabled, 1: VGA output, 2: NTSC composite, 3: RGB interlaced, composite sync (via VGA connector)
  .label VERA_DC_VIDEO = $9f29
  /// $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
  .label VERA_DC_HSCALE = $9f2a
  /// $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
  .label VERA_DC_VSCALE = $9f2b
  /// $9F2C	DC_BORDER (DCSEL=0)	Border Color
  .label VERA_DC_BORDER = $9f2c
  /// $9F29	DC_HSTART (DCSEL=1)	Active Display H-Start (9:2)
  .label VERA_DC_HSTART = $9f29
  /// $9F2A	DC_HSTOP (DCSEL=1)	Active Display H-Stop (9:2)
  .label VERA_DC_HSTOP = $9f2a
  /// $9F2B	DC_VSTART (DCSEL=1)	Active Display V-Start (8:1)
  .label VERA_DC_VSTART = $9f2b
  /// $9F2C	DC_VSTOP (DCSEL=1)	Active Display V-Stop (8:1)
  .label VERA_DC_VSTOP = $9f2c
  /// $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  /// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  /// $9F36	L1_TILEBASE	    Layer 1 Tile Base
  /// Bit 2-7: Tile Base Address (16:11)
  /// Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
  /// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
  .label VERA_L1_TILEBASE = $9f36
  /// $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  /// $0316	(RAM) BRK vector - The vector used when the KERNAL serves IRQ caused by a BRK
  .label KERNEL_BRK = $316
  .label BRAM = 0
  .label BROM = 1
.segment Code
  // __start
// void __start()
__start: {
    // __start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // #pragma constructor_for(cx16_irq_reset, cx16_irq_relay, cx16_nmi_reset, cx16_nmi_relay, cx16_brk_reset, cx16_brk_relay)
    // [3] call cx16_irq_reset
    jsr cx16_irq_reset
    // [4] phi from __start::__init1 to __start::@2 [phi:__start::__init1->__start::@2]
    // __start::@2
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [5] call conio_x16_init
    // [106] phi from __start::@2 to conio_x16_init [phi:__start::@2->conio_x16_init]
    jsr conio_x16_init
    // [6] phi from __start::@2 to __start::@1 [phi:__start::@2->__start::@1]
    // __start::@1
    // [7] call __lib_lru_cache_start
    // [135] phi from __start::@1 to __lib_lru_cache_start [phi:__start::@1->__lib_lru_cache_start]
    jsr lib_lru_cache.__lib_lru_cache_start
    // [8] phi from __start::@1 to __start::@3 [phi:__start::@1->__start::@3]
    // __start::@3
    // [9] call __lib_bramheap_start
    // [137] phi from __start::@3 to __lib_bramheap_start [phi:__start::@3->__lib_bramheap_start]
    jsr lib_bramheap.__lib_bramheap_start
    // [10] phi from __start::@3 to __start::@4 [phi:__start::@3->__start::@4]
    // __start::@4
    // [11] call __lib_veraheap_start
    // [139] phi from __start::@4 to __lib_veraheap_start [phi:__start::@4->__lib_veraheap_start]
    jsr lib_veraheap.__lib_veraheap_start
    // [12] phi from __start::@4 to __start::@5 [phi:__start::@4->__start::@5]
    // __start::@5
    // [13] call __lib_palette_start
    // [141] phi from __start::@5 to __lib_palette_start [phi:__start::@5->__lib_palette_start]
    jsr lib_palette.__lib_palette_start
    // [14] phi from __start::@5 to __start::@6 [phi:__start::@5->__start::@6]
    // __start::@6
    // [15] call __lib_animate_start
    // [143] phi from __start::@6 to __lib_animate_start [phi:__start::@6->__lib_animate_start]
    jsr lib_animate.__lib_animate_start
    // [16] phi from __start::@6 to __start::@7 [phi:__start::@6->__start::@7]
    // __start::@7
    // [17] call main
    // [145] phi from __start::@7 to main [phi:__start::@7->main]
    jsr main
    // __start::@return
    // [18] return 
    rts
}
  // irq_vsync
//VSYNC Interrupt Routine
// void irq_vsync()
irq_vsync: {
    .const bank_set_brom1_bank = 0
    .const bank_push_set_bram1_bank = $ff
    // interrupt(isr_rom_sys_cx16_entry) -- isr_rom_sys_cx16_entry 
    // irq_vsync::bank_set_brom1
    // BROM = bank
    // [20] BROM = irq_vsync::bank_set_brom1_bank#0 -- vbuz1=vbuc1 
    lda #bank_set_brom1_bank
    sta.z BROM
    // irq_vsync::vera_display_set_border_color1
    // *VERA_CTRL &= 0b10000001
    // [21] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [22] *VERA_DC_BORDER = YELLOW -- _deref_pbuc1=vbuc2 
    lda #YELLOW
    sta VERA_DC_BORDER
    // irq_vsync::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [24] BRAM = irq_vsync::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // irq_vsync::vera_display_set_border_color2
    // *VERA_CTRL &= 0b10000001
    // [25] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [26] *VERA_DC_BORDER = BLUE -- _deref_pbuc1=vbuc2 
    lda #BLUE
    sta VERA_DC_BORDER
    // [27] phi from irq_vsync::vera_display_set_border_color2 to irq_vsync::@1 [phi:irq_vsync::vera_display_set_border_color2->irq_vsync::@1]
    // irq_vsync::@1
    // collision_init()
    // [28] call collision_init
    // [240] phi from irq_vsync::@1 to collision_init [phi:irq_vsync::@1->collision_init]
    jsr collision_init
    // [29] phi from irq_vsync::@1 to irq_vsync::@4 [phi:irq_vsync::@1->irq_vsync::@4]
    // irq_vsync::@4
    // cx16_mouse_get()
    // [30] call cx16_mouse_get
    // cx16_mouse_scan(); 
    jsr cx16_mouse_get
    // irq_vsync::vera_display_set_border_color3
    // *VERA_CTRL &= 0b10000001
    // [31] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [32] *VERA_DC_BORDER = LIGHT_BLUE -- _deref_pbuc1=vbuc2 
    lda #LIGHT_BLUE
    sta VERA_DC_BORDER
    // [33] phi from irq_vsync::vera_display_set_border_color3 to irq_vsync::@2 [phi:irq_vsync::vera_display_set_border_color3->irq_vsync::@2]
    // irq_vsync::@2
    // player_logic()
    // [34] call player_logic
    // [258] phi from irq_vsync::@2 to player_logic [phi:irq_vsync::@2->player_logic] -- call_phi_close_cx16_ram 
    sta.z $ff
    lda.z 0
    pha
    lda #9
    sta.z 0
    lda.z $ff
    jsr player_logic
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // irq_vsync::vera_display_set_border_color4
    // *VERA_CTRL &= 0b10000001
    // [35] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [36] *VERA_DC_BORDER = GREY -- _deref_pbuc1=vbuc2 
    lda #GREY
    sta VERA_DC_BORDER
    // [37] phi from irq_vsync::vera_display_set_border_color4 to irq_vsync::@3 [phi:irq_vsync::vera_display_set_border_color4->irq_vsync::@3]
    // irq_vsync::@3
    // flight_draw()
    // [38] call flight_draw
    // [297] phi from irq_vsync::@3 to flight_draw [phi:irq_vsync::@3->flight_draw]
    jsr flight_draw
    // irq_vsync::@5
    // *VERA_ISR = 1
    // [39] *VERA_ISR = 1 -- _deref_pbuc1=vbuc2 
    // Reset the VSYNC interrupt
    lda #1
    sta VERA_ISR
    // irq_vsync::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // irq_vsync::vera_display_set_border_color5
    // *VERA_CTRL &= 0b10000001
    // [41] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [42] *VERA_DC_BORDER = BLACK -- _deref_pbuc1=vbuc2 
    lda #BLACK
    sta VERA_DC_BORDER
    // irq_vsync::@return
    // }
    // [43] return 
    // interrupt(isr_rom_sys_cx16_exit) -- isr_rom_sys_cx16_exit 
    jmp (isr_vsync)
}
  // conio_x16_init
/// Set initial screen values.
// void conio_x16_init()
conio_x16_init: {
    // screenlayer1()
    // [107] call screenlayer1
    jsr screenlayer1
    // [108] phi from conio_x16_init to conio_x16_init::@1 [phi:conio_x16_init->conio_x16_init::@1]
    // conio_x16_init::@1
    // textcolor(CONIO_TEXTCOLOR_DEFAULT)
    // [109] call textcolor
    jsr textcolor
    // [110] phi from conio_x16_init::@1 to conio_x16_init::@2 [phi:conio_x16_init::@1->conio_x16_init::@2]
    // conio_x16_init::@2
    // bgcolor(CONIO_BACKCOLOR_DEFAULT)
    // [111] call bgcolor
    // [360] phi from conio_x16_init::@2 to bgcolor [phi:conio_x16_init::@2->bgcolor]
    // [360] phi bgcolor::color#3 = BLUE [phi:conio_x16_init::@2->bgcolor#0] -- vbuxx=vbuc1 
    ldx #BLUE
    jsr bgcolor
    // [112] phi from conio_x16_init::@2 to conio_x16_init::@3 [phi:conio_x16_init::@2->conio_x16_init::@3]
    // conio_x16_init::@3
    // cursor(0)
    // [113] call cursor
    jsr cursor
    // [114] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // cbm_k_plot_get()
    // [115] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [116] cbm_k_plot_get::return#2 = cbm_k_plot_get::return#0
    // conio_x16_init::@5
    // [117] conio_x16_init::$4 = cbm_k_plot_get::return#2
    // BYTE1(cbm_k_plot_get())
    // [118] conio_x16_init::$5 = byte1  conio_x16_init::$4 -- vbuaa=_byte1_vwum1 
    lda conio_x16_init__4+1
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [119] *((char *)&__conio) = conio_x16_init::$5 -- _deref_pbuc1=vbuaa 
    sta __conio
    // cbm_k_plot_get()
    // [120] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [121] cbm_k_plot_get::return#3 = cbm_k_plot_get::return#0
    // conio_x16_init::@6
    // [122] conio_x16_init::$6 = cbm_k_plot_get::return#3
    // BYTE0(cbm_k_plot_get())
    // [123] conio_x16_init::$7 = byte0  conio_x16_init::$6 -- vbuaa=_byte0_vwum1 
    lda conio_x16_init__6
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [124] *((char *)&__conio+1) = conio_x16_init::$7 -- _deref_pbuc1=vbuaa 
    sta __conio+1
    // gotoxy(__conio.cursor_x, __conio.cursor_y)
    // [125] gotoxy::x#0 = *((char *)&__conio) -- vbuxx=_deref_pbuc1 
    ldx __conio
    // [126] gotoxy::y#0 = *((char *)&__conio+1) -- vbuyy=_deref_pbuc1 
    tay
    // [127] call gotoxy
    jsr gotoxy
    // conio_x16_init::@7
    // __conio.scroll[0] = 1
    // [128] *((char *)&__conio+$f) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta __conio+$f
    // __conio.scroll[1] = 1
    // [129] *((char *)&__conio+$f+1) = 1 -- _deref_pbuc1=vbuc2 
    sta __conio+$f+1
    // conio_x16_init::@return
    // }
    // [130] return 
    rts
  .segment Data
    .label conio_x16_init__4 = screenlayer.mapbase_offset
    .label conio_x16_init__6 = screenlayer.mapbase_offset
}
.segment Code
  // cx16_brk_debugger
// void cx16_brk_debugger()
cx16_brk_debugger: {
    // asm
    // asm { .byte$db  }
    .byte $db
    // cx16_brk_debugger::@return
    // }
    // [132] return 
    rts
}
  // cx16_irq_reset
// void cx16_irq_reset()
cx16_irq_reset: {
    // isr_vsync = *(IRQ_TYPE*)0x0314
    // [133] isr_vsync = *((void (**)()) 788) -- pprm1=_deref_qprc1 
    lda $314
    sta isr_vsync
    lda $314+1
    sta isr_vsync+1
    // cx16_irq_reset::@return
    // }
    // [134] return 
    rts
}
  // main
/// @brief game startup
// void main()
main: {
    .const vera_display_set_hstart1_start = 1
    .const vera_display_set_hstop1_stop = $9f
    .const vera_display_set_vstart1_start = 0
    .const vera_display_set_vstop1_stop = $ee
    .label cx16_k_screen_set_charset1_offset = $5f
    // cx16_brk_debug()
    // [146] call cx16_brk_debug
    // [387] phi from main to cx16_brk_debug [phi:main->cx16_brk_debug]
    jsr cx16_brk_debug
    // main::@9
    // cx16_k_screen_set_charset(3, (char *)0)
    // [147] main::cx16_k_screen_set_charset1_charset = 3 -- vbum1=vbuc1 
    lda #3
    sta cx16_k_screen_set_charset1_charset
    // [148] main::cx16_k_screen_set_charset1_offset = (char *) 0 -- pbuz1=pbuc1 
    lda #<0
    sta.z cx16_k_screen_set_charset1_offset
    sta.z cx16_k_screen_set_charset1_offset+1
    // main::cx16_k_screen_set_charset1
    // asm
    // asm { ldacharset ldx<offset ldy>offset jsrCX16_SCREEN_SET_CHARSET  }
    lda cx16_k_screen_set_charset1_charset
    ldx.z <cx16_k_screen_set_charset1_offset
    ldy.z >cx16_k_screen_set_charset1_offset
    jsr CX16_SCREEN_SET_CHARSET
    // main::bank_set_brom1
    // BROM = bank
    // [150] BROM = CX16_ROM_KERNAL -- vbuz1=vbuc1 
    lda #CX16_ROM_KERNAL
    sta.z BROM
    // main::vera_layer0_hide1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [151] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER0_ENABLE
    // [152] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER0_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER0_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [153] phi from main::vera_layer0_hide1 to main::@4 [phi:main::vera_layer0_hide1->main::@4]
    // main::@4
    // vera_layer1_hide()
    // [154] call vera_layer1_hide
    jsr vera_layer1_hide
    // [155] phi from main::@4 to main::@10 [phi:main::@4->main::@10]
    // main::@10
    // petscii()
    // [156] call petscii
    // [393] phi from main::@10 to petscii [phi:main::@10->petscii]
    jsr petscii
    // [157] phi from main::@10 to main::@11 [phi:main::@10->main::@11]
    // main::@11
    // scroll(1)
    // [158] call scroll
    // [410] phi from main::@11 to scroll [phi:main::@11->scroll]
    // [410] phi scroll::onoff#3 = 1 [phi:main::@11->scroll#0] -- vbuaa=vbuc1 
    lda #1
    jsr scroll
    // [159] phi from main::@11 to main::@12 [phi:main::@11->main::@12]
    // main::@12
    // textcolor(WHITE)
    // [160] call textcolor
    jsr textcolor
    // [161] phi from main::@12 to main::@13 [phi:main::@12->main::@13]
    // main::@13
    // bgcolor(BLACK)
    // [162] call bgcolor
    // [360] phi from main::@13 to bgcolor [phi:main::@13->bgcolor]
    // [360] phi bgcolor::color#3 = BLACK [phi:main::@13->bgcolor#0] -- vbuxx=vbuc1 
    ldx #BLACK
    jsr bgcolor
    // [163] phi from main::@13 to main::@14 [phi:main::@13->main::@14]
    // main::@14
    // clrscr()
    // [164] call clrscr
    jsr clrscr
    // [165] phi from main::@14 to main::@15 [phi:main::@14->main::@15]
    // main::@15
    // equinoxe_init()
    // [166] call equinoxe_init
  // music = fopen("music.bin","r");
    // [436] phi from main::@15 to equinoxe_init [phi:main::@15->equinoxe_init]
    jsr equinoxe_init
    // main::@16
    // bram_heap_bram_bank_init(BANK_HEAP_BRAM)
    // [167] bram_heap_bram_bank_init::bram_bank = $f -- vbuz1=vbuc1 
    // We initialize the Commander X16 BRAM heap manager. This manages dynamically the memory space in banked ram as a real heap.
    lda #$f
    sta.z lib_bramheap.bram_heap_bram_bank_init.bram_bank
    // [168] callexecute bram_heap_bram_bank_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_bram_bank_init
    // bram_heap_segment_init(0, 0x10, (bram_ptr_t)0xA000, 0x3C, (bram_ptr_t)0xA000)
    // [169] bram_heap_segment_init::s = 0 -- vbuz1=vbuc1 
    // BREAKPOINT
    lda #0
    sta.z lib_bramheap.bram_heap_segment_init.s
    // [170] bram_heap_segment_init::bram_bank_floor = $10 -- vbuz1=vbuc1 
    lda #$10
    sta.z lib_bramheap.bram_heap_segment_init.bram_bank_floor
    // [171] bram_heap_segment_init::bram_ptr_floor = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor+1
    // [172] bram_heap_segment_init::bram_bank_ceil = $3c -- vbuz1=vbuc1 
    lda #$3c
    sta.z lib_bramheap.bram_heap_segment_init.bram_bank_ceil
    // [173] bram_heap_segment_init::bram_ptr_ceil = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil+1
    // [174] callexecute bram_heap_segment_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_segment_init
    // bram_heap_segment_init(1, 0x3C, (bram_ptr_t)0xA000, 0x3F, (bram_ptr_t)0xA000)
    // [175] bram_heap_segment_init::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_bramheap.bram_heap_segment_init.s
    // [176] bram_heap_segment_init::bram_bank_floor = $3c -- vbuz1=vbuc1 
    lda #$3c
    sta.z lib_bramheap.bram_heap_segment_init.bram_bank_floor
    // [177] bram_heap_segment_init::bram_ptr_floor = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor+1
    // [178] bram_heap_segment_init::bram_bank_ceil = $3f -- vbuz1=vbuc1 
    lda #$3f
    sta.z lib_bramheap.bram_heap_segment_init.bram_bank_ceil
    // [179] bram_heap_segment_init::bram_ptr_ceil = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil+1
    // [180] callexecute bram_heap_segment_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_segment_init
    // vera_heap_bram_bank_init(BANK_VERA_HEAP)
    // [181] vera_heap_bram_bank_init::bram_bank = 1 -- vbuz1=vbuc1 
    // We intialize the Commander X16 VERA heap manager. This manages dynamically the memory space in vera ram as a real heap.
    lda #1
    sta.z lib_veraheap.vera_heap_bram_bank_init.bram_bank
    // [182] callexecute vera_heap_bram_bank_init  -- call_var_near 
    jsr lib_veraheap.vera_heap_bram_bank_init
    // vera_heap_segment_init(VERA_HEAP_SEGMENT_TILES, FLOOR_TILE_BANK_VRAM, FLOOR_TILE_OFFSET_VRAM, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM)
    // [183] vera_heap_segment_init::s = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_veraheap.vera_heap_segment_init.s
    // [184] vera_heap_segment_init::vram_bank_floor = 0 -- vbuz1=vbuc1 
    sta.z lib_veraheap.vera_heap_segment_init.vram_bank_floor
    // [185] vera_heap_segment_init::vram_offset_floor = 0 -- vwuz1=vbuc1 
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_floor
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_floor+1
    // [186] vera_heap_segment_init::vram_bank_ceil = 0 -- vbuz1=vbuc1 
    sta.z lib_veraheap.vera_heap_segment_init.vram_bank_ceil
    // [187] vera_heap_segment_init::vram_offset_ceil = $5000 -- vwuz1=vwuc1 
    lda #<$5000
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_ceil
    lda #>$5000
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_ceil+1
    // [188] callexecute vera_heap_segment_init  -- call_var_near 
    jsr lib_veraheap.vera_heap_segment_init
    // vera_heap_segment_init(VERA_HEAP_SEGMENT_SPRITES, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM, FLOOR_MAP1_BANK_VRAM, FLOOR_MAP1_OFFSET_VRAM)
    // [189] vera_heap_segment_init::s = 1 -- vbuz1=vbuc1 
    // FLOOR_TILE segment for tiles of various sizes and types
    lda #1
    sta.z lib_veraheap.vera_heap_segment_init.s
    // [190] vera_heap_segment_init::vram_bank_floor = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_veraheap.vera_heap_segment_init.vram_bank_floor
    // [191] vera_heap_segment_init::vram_offset_floor = $5000 -- vwuz1=vwuc1 
    lda #<$5000
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_floor
    lda #>$5000
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_floor+1
    // [192] vera_heap_segment_init::vram_bank_ceil = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_segment_init.vram_bank_ceil
    // [193] vera_heap_segment_init::vram_offset_ceil = $d000 -- vwuz1=vwuc1 
    lda #<$d000
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_ceil
    lda #>$d000
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_ceil+1
    // [194] callexecute vera_heap_segment_init  -- call_var_near 
    jsr lib_veraheap.vera_heap_segment_init
    // stage_reset()
    // [195] call stage_reset -- call_phi_close_cx16_ram 
    // SPRITES segment for sprites of various sizes
    sta.z $ff
    lda.z 0
    pha
    lda #3
    sta.z 0
    lda.z $ff
    jsr stage_reset
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // main::vera_display_set_hstart1
    // *VERA_CTRL |= VERA_DCSEL
    // [196] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_HSTART = start
    // [197] *VERA_DC_HSTART = main::vera_display_set_hstart1_start#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_hstart1_start
    sta VERA_DC_HSTART
    // main::vera_display_set_hstop1
    // *VERA_CTRL |= VERA_DCSEL
    // [198] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_HSTOP = stop
    // [199] *VERA_DC_HSTOP = main::vera_display_set_hstop1_stop#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_hstop1_stop
    sta VERA_DC_HSTOP
    // main::vera_display_set_vstart1
    // *VERA_CTRL |= VERA_DCSEL
    // [200] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VSTART = start
    // [201] *VERA_DC_VSTART = main::vera_display_set_vstart1_start#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_vstart1_start
    sta VERA_DC_VSTART
    // main::vera_display_set_vstop1
    // *VERA_CTRL |= VERA_DCSEL
    // [202] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VSTOP = stop
    // [203] *VERA_DC_VSTOP = main::vera_display_set_vstop1_stop#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_vstop1_stop
    sta VERA_DC_VSTOP
    // [204] phi from main::vera_display_set_vstop1 to main::@5 [phi:main::vera_display_set_vstop1->main::@5]
    // main::@5
    // stage_logic()
    // [205] call stage_logic -- call_phi_close_cx16_ram 
    sta.z $ff
    lda.z 0
    pha
    lda #3
    sta.z 0
    lda.z $ff
    jsr stage_logic
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // [206] phi from main::@5 to main::@17 [phi:main::@5->main::@17]
    // main::@17
    // scroll(0)
    // [207] call scroll
    // [410] phi from main::@17 to scroll [phi:main::@17->scroll]
    // [410] phi scroll::onoff#3 = 0 [phi:main::@17->scroll#0] -- vbuaa=vbuc1 
    lda #0
    jsr scroll
    // main::cbm_k_clrchn1
    // asm
    // asm { jsrCBM_CLRCHN  }
    jsr CBM_CLRCHN
    // [209] phi from main::@18 main::cbm_k_clrchn1 to main::@1 [phi:main::@18/main::cbm_k_clrchn1->main::@1]
    // main::@1
  __b1:
    // kbhit()
    // [210] call kbhit
    // [536] phi from main::@1 to kbhit [phi:main::@1->kbhit]
    jsr kbhit
    // kbhit()
    // [211] kbhit::return#2 = kbhit::return#0
    // main::@18
    // [212] main::$33 = kbhit::return#2
    // while(!kbhit())
    // [213] if(0==main::$33) goto main::@1 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b1
    // main::SEI1
    // asm
    // asm { sei  }
    sei
    // [215] phi from main::SEI1 to main::@6 [phi:main::SEI1->main::@6]
    // main::@6
    // cx16_irq_relay(&irq_vsync)
    // [216] call cx16_irq_relay
    jsr cx16_irq_relay
    // main::@19
    // *VERA_IEN = VERA_VSYNC | 0x80
    // [217] *VERA_IEN = VERA_VSYNC|$80 -- _deref_pbuc1=vbuc2 
    // *KERNEL_IRQ = &irq_vsync;
    lda #VERA_VSYNC|$80
    sta VERA_IEN
    // *VERA_IRQLINE_L = 0xFF
    // [218] *VERA_IRQLINE_L = $ff -- _deref_pbuc1=vbuc2 
    lda #$ff
    sta VERA_IRQLINE_L
    // main::CLI1
    // asm
    // asm { cli  }
    cli
    // main::@7
    // cx16_mouse_config(0xFF, 80, 60)
    // [220] cx16_mouse_config::visible = $ff -- vbum1=vbuc1 
    sta cx16_mouse_config.visible
    // [221] cx16_mouse_config::scalex = $50 -- vbum1=vbuc1 
    lda #$50
    sta cx16_mouse_config.scalex
    // [222] cx16_mouse_config::scaley = $3c -- vbum1=vbuc1 
    lda #$3c
    sta cx16_mouse_config.scaley
    // [223] call cx16_mouse_config
    jsr cx16_mouse_config
    // [224] phi from main::@7 to main::@20 [phi:main::@7->main::@20]
    // main::@20
    // cx16_mouse_get()
    // [225] call cx16_mouse_get
    jsr cx16_mouse_get
    // main::vera_sprites_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [226] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE
    // [227] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_SPRITES_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITES_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [228] phi from main::vera_sprites_show1 to main::@8 [phi:main::vera_sprites_show1->main::@8]
    // main::@8
    // volatile unsigned char ch = kbhit()
    // [229] call kbhit
    // [536] phi from main::@8 to kbhit [phi:main::@8->kbhit]
    jsr kbhit
    // volatile unsigned char ch = kbhit()
    // [230] kbhit::return#3 = kbhit::return#0
    // main::@21
    // [231] main::ch = kbhit::return#3 -- vbum1=vbuaa 
    sta ch
    // main::@2
  __b2:
    // while (ch != 'x')
    // [232] if(main::ch!='x'pm) goto main::@3 -- vbum1_neq_vbuc1_then_la1 
  .encoding "petscii_mixed"
    lda #'x'
    cmp ch
    bne __b3
    // main::bank_set_brom2
    // BROM = bank
    // [233] BROM = CX16_ROM_BASIC -- vbuz1=vbuc1 
    lda #CX16_ROM_BASIC
    sta.z BROM
    // main::@return
    // }
    // [234] return 
    rts
    // [235] phi from main::@2 to main::@3 [phi:main::@2->main::@3]
    // main::@3
  __b3:
    // kbhit()
    // [236] call kbhit
    // [536] phi from main::@3 to kbhit [phi:main::@3->kbhit]
    jsr kbhit
    // kbhit()
    // [237] kbhit::return#4 = kbhit::return#0
    // main::@22
    // [238] main::$36 = kbhit::return#4
    // ch=kbhit()
    // [239] main::ch = main::$36 -- vbum1=vbuaa 
    // #ifdef __DEBUG_STAGE
    //     SEI();
    //     stage_display();
    //     CLI();
    // #endif
    sta ch
    jmp __b2
  .segment Data
    ch: .byte 0
    cx16_k_screen_set_charset1_charset: .byte 0
}
.segment Code
  // collision_init
// void collision_init()
collision_init: {
    .const memset_fast1_c = 0
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast1_destination = collision_quadrant
    // ht_init(&collision_hash)
    // [241] call ht_init
    // [547] phi from collision_init to ht_init [phi:collision_init->ht_init]
    jsr ht_init
    // [242] phi from collision_init to collision_init::memset_fast1 [phi:collision_init->collision_init::memset_fast1]
    // collision_init::memset_fast1
    // [243] phi from collision_init::memset_fast1 to collision_init::memset_fast1_@1 [phi:collision_init::memset_fast1->collision_init::memset_fast1_@1]
    // [243] phi collision_init::memset_fast1_num#2 = 0 [phi:collision_init::memset_fast1->collision_init::memset_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [243] phi from collision_init::memset_fast1_@1 to collision_init::memset_fast1_@1 [phi:collision_init::memset_fast1_@1->collision_init::memset_fast1_@1]
    // [243] phi collision_init::memset_fast1_num#2 = collision_init::memset_fast1_num#1 [phi:collision_init::memset_fast1_@1->collision_init::memset_fast1_@1#0] -- register_copy 
    // collision_init::memset_fast1_@1
  memset_fast1___b1:
    // *(destination+num) = c
    // [244] collision_init::memset_fast1_destination#0[collision_init::memset_fast1_num#2] = collision_init::memset_fast1_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast1_c
    sta memset_fast1_destination,x
    // num--;
    // [245] collision_init::memset_fast1_num#1 = -- collision_init::memset_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [246] if(0!=collision_init::memset_fast1_num#1) goto collision_init::memset_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast1___b1
    // collision_init::@return
    // }
    // [247] return 
    rts
}
  // cx16_mouse_get
/**
 * @brief Retrieves the status of the mouse pointer and will fill the mouse position in the defined mouse registers.
 * 
 * @return char Current mouse status.
 * 
 * The pre-defined variables cx16_mousex and cx16_mousey contain the position of the mouse pointer.
 * 
 *     volatile int cx16_mousex = 0;
 *     volatile int cx16_mousey = 0;
 * 
 * The state of the mouse buttons is returned:
 * 
 *   |Bit|Description|
 *   |---|-----------|
 *   |0|Left Button|
 *   |1|Right Button|
 *   |2|Middle Button|
 * 
 *   If a button is pressed, the corresponding bit is set.
 */
// char cx16_mouse_get()
cx16_mouse_get: {
    .label x = $fc
    .label y = $fe
    // __mem char status
    // [248] cx16_mouse_get::status = 0 -- vbum1=vbuc1 
    lda #0
    sta status
    // __address(0xfc) int x
    // [249] cx16_mouse_get::x = 0 -- vwsz1=vwsc1 
    sta.z x
    sta.z x+1
    // __address(0xfe) int y
    // [250] cx16_mouse_get::y = 0 -- vwsz1=vwsc1 
    sta.z y
    sta.z y+1
    // cx16_mouse.px = cx16_mouse.x
    // [251] *((int *)&cx16_mouse+4) = *((int *)&cx16_mouse) -- _deref_pwsc1=_deref_pwsc2 
    lda cx16_mouse
    sta cx16_mouse+4
    lda cx16_mouse+1
    sta cx16_mouse+4+1
    // cx16_mouse.py = cx16_mouse.y
    // [252] *((int *)&cx16_mouse+6) = *((int *)&cx16_mouse+2) -- _deref_pwsc1=_deref_pwsc2 
    lda cx16_mouse+2
    sta cx16_mouse+6
    lda cx16_mouse+2+1
    sta cx16_mouse+6+1
    // asm
    // asm { ldx#$fc jsrCX16_MOUSE_GET stastatus  }
    ldx #$fc
    jsr CX16_MOUSE_GET
    sta status
    // cx16_mouse.x = x
    // [254] *((int *)&cx16_mouse) = cx16_mouse_get::x -- _deref_pwsc1=vwsz1 
    lda.z x
    sta cx16_mouse
    lda.z x+1
    sta cx16_mouse+1
    // cx16_mouse.y = y
    // [255] *((int *)&cx16_mouse+2) = cx16_mouse_get::y -- _deref_pwsc1=vwsz1 
    lda.z y
    sta cx16_mouse+2
    lda.z y+1
    sta cx16_mouse+2+1
    // cx16_mouse.status = status
    // [256] *((char *)&cx16_mouse+8) = cx16_mouse_get::status -- _deref_pbuc1=vbum1 
    lda status
    sta cx16_mouse+8
    // cx16_mouse_get::@return
    // }
    // [257] return 
    rts
  .segment Data
    status: .byte 0
}
.segment CodeEnginePlayers
  // player_logic
// void player_logic()
// __bank(cx16_ram, 9) 
player_logic: {
    // flight_index_t p = flight_root(FLIGHT_PLAYER)
    // [259] call flight_root
    jsr flight_root
    // [260] flight_root::return#2 = flight_root::return#0
    // player_logic::@11
    // [261] player_logic::p#0 = flight_root::return#2
    // [262] phi from player_logic::@11 player_logic::@3 to player_logic::@1 [phi:player_logic::@11/player_logic::@3->player_logic::@1]
    // [262] phi player_logic::p#10 = player_logic::p#0 [phi:player_logic::@11/player_logic::@3->player_logic::@1#0] -- register_copy 
    // player_logic::@1
  __b1:
    // while(p)
    // [263] if(0!=player_logic::p#10) goto player_logic::@2 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b2
    // player_logic::@return
    // }
    // [264] return 
    rts
    // player_logic::@2
  __b2:
    // flight_index_t pn = flight_next(p)
    // [265] flight_next::i#0 = player_logic::p#10
    // [266] call flight_next
    jsr flight_next
    // [267] flight_next::return#2 = flight_next::return#0
    // player_logic::@12
    // [268] player_logic::p#1 = flight_next::return#2 -- vbum1=vbuaa 
    sta p
    // if (flight.type[p] == FLIGHT_PLAYER && flight.used[p])
    // [269] if(((char *)&flight+$180)[player_logic::p#10]!=0) goto player_logic::@3 -- pbuc1_derefidx_vbuxx_neq_0_then_la1 
    lda flight+$180,x
    cmp #0
    bne __b3
    // player_logic::@13
    // [270] if(0!=((char *)&flight+$c0)[player_logic::p#10]) goto player_logic::@9 -- 0_neq_pbuc1_derefidx_vbuxx_then_la1 
    lda flight+$c0,x
    cmp #0
    bne __b9
    // player_logic::@3
  __b3:
    // [271] player_logic::p#13 = player_logic::p#1 -- vbuxx=vbum1 
    ldx p
    jmp __b1
    // player_logic::@9
  __b9:
    // if (flight.reload[p] > 0)
    // [272] if(((char *)&flight+$740)[player_logic::p#10]<=0) goto player_logic::@4 -- pbuc1_derefidx_vbuxx_le_0_then_la1 
    lda flight+$740,x
    cmp #0
    beq __b4
    // player_logic::@10
    // flight.reload[p]--;
    // [273] ((char *)&flight+$740)[player_logic::p#10] = -- ((char *)&flight+$740)[player_logic::p#10] -- pbuc1_derefidx_vbuxx=_dec_pbuc1_derefidx_vbuxx 
    dec flight+$740,x
    // player_logic::@4
  __b4:
    // flight.xi[p] = (unsigned int)cx16_mouse.x
    // [274] player_logic::$17 = player_logic::p#10 << 1 -- vbum1=vbuxx_rol_1 
    txa
    asl
    sta player_logic__17
    // [275] ((unsigned int *)&flight+$300)[player_logic::$17] = (unsigned int)*((int *)&cx16_mouse) -- pwuc1_derefidx_vbum1=_deref_pwuc2 
    tay
    lda cx16_mouse
    sta flight+$300,y
    lda cx16_mouse+1
    sta flight+$300+1,y
    // flight.yi[p] = (unsigned int)cx16_mouse.y
    // [276] ((unsigned int *)&flight+$380)[player_logic::$17] = (unsigned int)*((int *)&cx16_mouse+2) -- pwuc1_derefidx_vbum1=_deref_pwuc2 
    lda cx16_mouse+2
    sta flight+$380,y
    lda cx16_mouse+2+1
    sta flight+$380+1,y
    // flight_index_t n = flight.engine[p]
    // [277] player_logic::n#0 = ((char *)&flight+$6c0)[player_logic::p#10] -- vbum1=pbuc1_derefidx_vbuxx 
    lda flight+$6c0,x
    sta n
    // flight.xi[p]+8
    // [278] player_logic::$8 = ((unsigned int *)&flight+$300)[player_logic::$17] + 8 -- vwum1=pwuc1_derefidx_vbum2_plus_vbuc2 
    lda #8
    clc
    adc flight+$300,y
    sta player_logic__8
    lda flight+$300+1,y
    adc #0
    sta player_logic__8+1
    // flight.xi[n] = flight.xi[p]+8
    // [279] player_logic::$21 = player_logic::n#0 << 1 -- vbum1=vbum2_rol_1 
    lda n
    asl
    sta player_logic__21
    // [280] ((unsigned int *)&flight+$300)[player_logic::$21] = player_logic::$8 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda player_logic__8
    sta flight+$300,y
    lda player_logic__8+1
    sta flight+$300+1,y
    // flight.yi[p]+32
    // [281] player_logic::$9 = ((unsigned int *)&flight+$380)[player_logic::$17] + $20 -- vwum1=pwuc1_derefidx_vbum2_plus_vbuc2 
    lda #$20
    ldy player_logic__17
    clc
    adc flight+$380,y
    sta player_logic__9
    lda flight+$380+1,y
    adc #0
    sta player_logic__9+1
    // flight.yi[n] = flight.yi[p]+32
    // [282] ((unsigned int *)&flight+$380)[player_logic::$21] = player_logic::$9 -- pwuc1_derefidx_vbum1=vwum2 
    ldy player_logic__21
    lda player_logic__9
    sta flight+$380,y
    lda player_logic__9+1
    sta flight+$380+1,y
    // unsigned int x = flight.xi[p]
    // [283] player_logic::x#0 = ((unsigned int *)&flight+$300)[player_logic::$17] -- vwum1=pwuc1_derefidx_vbum2 
    ldy player_logic__17
    lda flight+$300,y
    sta x
    lda flight+$300+1,y
    sta x+1
    // unsigned int y = flight.yi[p]
    // [284] player_logic::y#0 = ((unsigned int *)&flight+$380)[player_logic::$17] -- vwum1=pwuc1_derefidx_vbum2 
    lda flight+$380,y
    sta y
    lda flight+$380+1,y
    sta y+1
    // if (x > 640 - 32)
    // [285] if(player_logic::x#0<=$280-$20) goto player_logic::@5 -- vwum1_le_vwuc1_then_la1 
    lda x+1
    cmp #>$280-$20
    bne !+
    lda x
    cmp #<$280-$20
  !:
    // [286] phi from player_logic::@4 to player_logic::@7 [phi:player_logic::@4->player_logic::@7]
    // player_logic::@7
    // player_logic::@5
    // if (y > 480 - 32)
    // [287] if(player_logic::y#0<=$1e0-$20) goto player_logic::@6 -- vwum1_le_vwuc1_then_la1 
    lda y+1
    cmp #>$1e0-$20
    bne !+
    lda y
    cmp #<$1e0-$20
  !:
    // [288] phi from player_logic::@5 to player_logic::@8 [phi:player_logic::@5->player_logic::@8]
    // player_logic::@8
    // player_logic::@6
    // unsigned char ap = flight.animate[p]
    // [289] player_logic::ap#0 = ((char *)&flight+$900)[player_logic::p#10] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda flight+$900,x
    // animate_player(ap, (signed int)cx16_mouse.x, (signed int)cx16_mouse.px)
    // [290] animate_player::a = player_logic::ap#0 -- vbuz1=vbuaa 
    sta.z lib_animate.animate_player.a
    // [291] animate_player::x = *((int *)&cx16_mouse) -- vwsz1=_deref_pwsc1 
    lda cx16_mouse
    sta.z lib_animate.animate_player.x
    lda cx16_mouse+1
    sta.z lib_animate.animate_player.x+1
    // [292] animate_player::px = *((int *)&cx16_mouse+4) -- vwsz1=_deref_pwsc1 
    lda cx16_mouse+4
    sta.z lib_animate.animate_player.px
    lda cx16_mouse+4+1
    sta.z lib_animate.animate_player.px+1
    // [293] callexecute animate_player  -- call_var_near 
    jsr lib_animate.animate_player
    // unsigned char an = flight.animate[n]
    // [294] player_logic::an#0 = ((char *)&flight+$900)[player_logic::n#0] -- vbuaa=pbuc1_derefidx_vbum1 
    ldy n
    lda flight+$900,y
    // animate_logic(an)
    // [295] animate_logic::a = player_logic::an#0 -- vbuz1=vbuaa 
    sta.z lib_animate.animate_logic.a
    // [296] callexecute animate_logic  -- call_var_near 
    jsr lib_animate.animate_logic
    jmp __b3
  .segment DataEnginePlayers
    player_logic__8: .word 0
    .label player_logic__9 = player_logic__8
    player_logic__17: .byte 0
    player_logic__21: .byte 0
    p: .byte 0
    n: .byte 0
    .label x = player_logic__8
    y: .word 0
}
.segment CodeEngineFlight
  // flight_draw
// void flight_draw()
flight_draw: {
    // [298] phi from flight_draw to flight_draw::@1 [phi:flight_draw->flight_draw::@1]
    // [298] phi flight_draw::f#10 = 0 [phi:flight_draw->flight_draw::@1#0] -- vbum1=vbuc1 
    lda #0
    sta f
  // BREAKPOINT
    // flight_draw::@1
  __b1:
    // for (unsigned char f = 0; f < FLIGHT_OBJECTS; f++)
    // [299] if(flight_draw::f#10<$40) goto flight_draw::@2 -- vbum1_lt_vbuc1_then_la1 
    lda f
    cmp #$40
    bcc __b2
    // flight_draw::@return
    // }
    // [300] return 
    rts
    // flight_draw::@2
  __b2:
    // if (flight.used[f])
    // [301] if(0==((char *)&flight+$c0)[flight_draw::f#10]) goto flight_draw::@3 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy f
    lda flight+$c0,y
    cmp #0
    bne !__b3+
    jmp __b3
  !__b3:
    // flight_draw::@7
    // unsigned int x = flight.xi[f]
    // [302] flight_draw::$22 = flight_draw::f#10 << 1 -- vbuxx=vbum1_rol_1 
    tya
    asl
    tax
    // [303] flight_draw::x#0 = ((unsigned int *)&flight+$300)[flight_draw::$22] -- vwum1=pwuc1_derefidx_vbuxx 
    lda flight+$300,x
    sta x
    lda flight+$300+1,x
    sta x+1
    // unsigned int y = flight.yi[f]
    // [304] flight_draw::y#0 = ((unsigned int *)&flight+$380)[flight_draw::$22] -- vwum1=pwuc1_derefidx_vbuxx 
    lda flight+$380,x
    sta y
    lda flight+$380+1,x
    sta y+1
    // vera_sprite_offset sprite_offset = flight.sprite_offset[f]
    // [305] flight_draw::sprite_offset#0 = ((unsigned int *)&flight+$40)[flight_draw::$22] -- vwum1=pwuc1_derefidx_vbuxx 
    lda flight+$40,x
    sta sprite_offset
    lda flight+$40+1,x
    sta sprite_offset+1
    // unsigned char a = flight.animate[f]
    // [306] flight_draw::a#0 = ((char *)&flight+$900)[flight_draw::f#10] -- vbum1=pbuc1_derefidx_vbum2 
    // if( x<640+68 && y<480+68 && (signed int)x>-68 && (signed int)y>-68 ) {
    lda flight+$900,y
    sta a
    // unsigned char s = animate_get_image(a)
    // [307] animate_get_image::a = flight_draw::a#0 -- vbuz1=vbum2 
    sta.z lib_animate.animate_get_image.a
    // [308] callexecute animate_get_image  -- call_var_near 
    jsr lib_animate.animate_get_image
    // [309] flight_draw::s#0 = animate_get_image::return -- vbum1=vbuz2 
    lda.z lib_animate.animate_get_image.return
    sta s
    // volatile unsigned char i = flight.cache[f]
    // [310] flight_draw::i = ((char *)&flight)[flight_draw::f#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy f
    lda flight,y
    sta i
    // animate_is_waiting(a)
    // [311] animate_is_waiting::a = flight_draw::a#0 -- vbuz1=vbum2 
    lda a
    sta.z lib_animate.animate_is_waiting.a
    // [312] callexecute animate_is_waiting  -- call_var_near 
    jsr lib_animate.animate_is_waiting
    // [313] flight_draw::$3 = animate_is_waiting::return -- vbuaa=vbuz1 
    lda.z lib_animate.animate_is_waiting.return
    // if (animate_is_waiting(a))
    // [314] if(0!=flight_draw::$3) goto flight_draw::@4 -- 0_neq_vbuaa_then_la1 
    // This variable needs to be volatile or the kickc optimizer kills it.
    cmp #0
    bne __b4
    // flight_draw::@8
    // vera_sprite_image_offset sprite_image_offset = sprite_image_cache_vram(i, s)
    // [315] sprite_image_cache_vram::sprite_cache_index#0 = flight_draw::i -- vbuxx=vbum1 
    ldx i
    // [316] sprite_image_cache_vram::fe_sprite_image_index#0 = flight_draw::s#0 -- vbuyy=vbum1 
    ldy s
    // [317] call sprite_image_cache_vram
    jsr sprite_image_cache_vram
    // [318] sprite_image_cache_vram::return#2 = sprite_image_cache_vram::return#0
    // flight_draw::@10
    // [319] flight_draw::sprite_image_offset#0 = sprite_image_cache_vram::return#2
    // if(sprite_image_offset==0x0)
    // [320] if(flight_draw::sprite_image_offset#0!=0) goto flight_draw::@5 -- vwum1_neq_0_then_la1 
    lda sprite_image_offset
    ora sprite_image_offset+1
    bne __b5
    // flight_draw::@9
    // BREAKPOINT
    // asm { .byte$db  }
    .byte $db
    // flight_draw::@5
  __b5:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [322] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // gotoxy(0,0);
    // printf("%02x %04x, ", f, sprite_image_offset);
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_H = 1 | VERA_INC_1
    // [323] *VERA_ADDRX_H = 1|VERA_INC_1 -- _deref_pbuc1=vbuc2 
    // Select DATA0
    lda #1|VERA_INC_1
    sta VERA_ADDRX_H
    // BYTE1(sprite_offset)
    // [324] flight_draw::$7 = byte1  flight_draw::sprite_offset#0 -- vbuaa=_byte1_vwum1 
    lda sprite_offset+1
    // *VERA_ADDRX_M = BYTE1(sprite_offset)
    // [325] *VERA_ADDRX_M = flight_draw::$7 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // BYTE0(sprite_offset)
    // [326] flight_draw::$8 = byte0  flight_draw::sprite_offset#0 -- vbuaa=_byte0_vwum1 
    lda sprite_offset
    // *VERA_ADDRX_L = BYTE0(sprite_offset)
    // [327] *VERA_ADDRX_L = flight_draw::$8 -- _deref_pbuc1=vbuaa 
    // Normally the +2 should not be an issue.
    sta VERA_ADDRX_L
    // BYTE0(sprite_image_offset)
    // [328] flight_draw::$9 = byte0  flight_draw::sprite_image_offset#0 -- vbuaa=_byte0_vwum1 
    lda sprite_image_offset
    // *VERA_DATA0 = BYTE0(sprite_image_offset)
    // [329] *VERA_DATA0 = flight_draw::$9 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // BYTE1(sprite_image_offset)
    // [330] flight_draw::$10 = byte1  flight_draw::sprite_image_offset#0 -- vbuaa=_byte1_vwum1 
    lda sprite_image_offset+1
    // *VERA_DATA0 = BYTE1(sprite_image_offset)
    // [331] *VERA_DATA0 = flight_draw::$10 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // flight_draw::@6
  __b6:
    // BYTE0(x)
    // [332] flight_draw::$15 = byte0  flight_draw::x#0 -- vbuaa=_byte0_vwum1 
    lda x
    // *VERA_DATA0 = BYTE0(x)
    // [333] *VERA_DATA0 = flight_draw::$15 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // BYTE1(x)
    // [334] flight_draw::$16 = byte1  flight_draw::x#0 -- vbuaa=_byte1_vwum1 
    lda x+1
    // *VERA_DATA0 = BYTE1(x)
    // [335] *VERA_DATA0 = flight_draw::$16 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // BYTE0(y)
    // [336] flight_draw::$17 = byte0  flight_draw::y#0 -- vbuaa=_byte0_vwum1 
    lda y
    // *VERA_DATA0 = BYTE0(y)
    // [337] *VERA_DATA0 = flight_draw::$17 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // BYTE1(y)
    // [338] flight_draw::$18 = byte1  flight_draw::y#0 -- vbuaa=_byte1_vwum1 
    lda y+1
    // *VERA_DATA0 = BYTE1(y)
    // [339] *VERA_DATA0 = flight_draw::$18 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_ADDRX_H = 1 | VERA_INC_0
    // [340] *VERA_ADDRX_H = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [341] flight_draw::$19 = *VERA_DATA0 & ~$c -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$c^$ff
    and VERA_DATA0
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | sprite_cache.zdepth[flight.cache[f]]
    // [342] flight_draw::$20 = flight_draw::$19 | ((char *)&sprite_cache+$70)[((char *)&flight)[flight_draw::f#10]] -- vbuaa=vbuaa_bor_pbuc1_derefidx_(pbuc2_derefidx_vbum1) 
    ldx f
    ldy flight,x
    ora sprite_cache+$70,y
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | sprite_cache.zdepth[flight.cache[f]]
    // [343] *VERA_DATA0 = flight_draw::$20 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // flight_draw::@3
  __b3:
    // for (unsigned char f = 0; f < FLIGHT_OBJECTS; f++)
    // [344] flight_draw::f#1 = ++ flight_draw::f#10 -- vbum1=_inc_vbum1 
    inc f
    // [298] phi from flight_draw::@3 to flight_draw::@1 [phi:flight_draw::@3->flight_draw::@1]
    // [298] phi flight_draw::f#10 = flight_draw::f#1 [phi:flight_draw::@3->flight_draw::@1#0] -- register_copy 
    jmp __b1
    // flight_draw::@4
  __b4:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [345] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_H = 1 | VERA_INC_1
    // [346] *VERA_ADDRX_H = 1|VERA_INC_1 -- _deref_pbuc1=vbuc2 
    // Select DATA0
    lda #1|VERA_INC_1
    sta VERA_ADDRX_H
    // sprite_offset + 2
    // [347] flight_draw::$13 = flight_draw::sprite_offset#0 + 2 -- vwum1=vwum1_plus_vbuc1 
    lda #2
    clc
    adc flight_draw__13
    sta flight_draw__13
    bcc !+
    inc flight_draw__13+1
  !:
    // BYTE1(sprite_offset + 2)
    // [348] flight_draw::$12 = byte1  flight_draw::$13 -- vbuaa=_byte1_vwum1 
    lda flight_draw__13+1
    // *VERA_ADDRX_M = BYTE1(sprite_offset + 2)
    // [349] *VERA_ADDRX_M = flight_draw::$12 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // BYTE0(sprite_offset + 2)
    // [350] flight_draw::$14 = byte0  flight_draw::$13 -- vbuaa=_byte0_vwum1 
    lda flight_draw__13
    // *VERA_ADDRX_L = BYTE0(sprite_offset + 2)
    // [351] *VERA_ADDRX_L = flight_draw::$14 -- _deref_pbuc1=vbuaa 
    // Normally the +2 should not be an issue.
    sta VERA_ADDRX_L
    jmp __b6
  .segment DataEngineFlight
    i: .byte 0
    .label flight_draw__13 = sprite_offset
    f: .byte 0
    x: .word 0
    y: .word 0
    sprite_offset: .word 0
    .label a = sprite_image_cache_vram.vram_has_free
    s: .byte 0
    .label sprite_image_offset = sprite_image_cache_vram.return
}
.segment Code
  // screenlayer1
// Set the layer with which the conio will interact.
// void screenlayer1()
screenlayer1: {
    // screenlayer(1, *VERA_L1_MAPBASE, *VERA_L1_CONFIG)
    // [352] screenlayer::mapbase#0 = *VERA_L1_MAPBASE -- vbuxx=_deref_pbuc1 
    ldx VERA_L1_MAPBASE
    // [353] screenlayer::config#0 = *VERA_L1_CONFIG -- vbum1=_deref_pbuc1 
    lda VERA_L1_CONFIG
    sta screenlayer.config
    // [354] call screenlayer
    jsr screenlayer
    // screenlayer1::@return
    // }
    // [355] return 
    rts
}
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char textcolor(char color)
textcolor: {
    // __conio.color & 0xF0
    // [356] textcolor::$0 = *((char *)&__conio+$d) & $f0 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and __conio+$d
    // __conio.color & 0xF0 | color
    // [357] textcolor::$1 = textcolor::$0 | WHITE -- vbuaa=vbuaa_bor_vbuc1 
    ora #WHITE
    // __conio.color = __conio.color & 0xF0 | color
    // [358] *((char *)&__conio+$d) = textcolor::$1 -- _deref_pbuc1=vbuaa 
    sta __conio+$d
    // textcolor::@return
    // }
    // [359] return 
    rts
}
  // bgcolor
// Set the back color for text output.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor(__register(X) char color)
bgcolor: {
    // __conio.color & 0x0F
    // [361] bgcolor::$0 = *((char *)&__conio+$d) & $f -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$f
    and __conio+$d
    sta bgcolor__0
    // color << 4
    // [362] bgcolor::$1 = bgcolor::color#3 << 4 -- vbuaa=vbuxx_rol_4 
    txa
    asl
    asl
    asl
    asl
    // __conio.color & 0x0F | color << 4
    // [363] bgcolor::$2 = bgcolor::$0 | bgcolor::$1 -- vbuaa=vbum1_bor_vbuaa 
    ora bgcolor__0
    // __conio.color = __conio.color & 0x0F | color << 4
    // [364] *((char *)&__conio+$d) = bgcolor::$2 -- _deref_pbuc1=vbuaa 
    sta __conio+$d
    // bgcolor::@return
    // }
    // [365] return 
    rts
  .segment Data
    .label bgcolor__0 = screenlayer.config
}
.segment Code
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
// char cursor(char onoff)
cursor: {
    .const onoff = 0
    // __conio.cursor = onoff
    // [366] *((char *)&__conio+$c) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta __conio+$c
    // cursor::@return
    // }
    // [367] return 
    rts
}
  // cbm_k_plot_get
/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
// __mem() unsigned int cbm_k_plot_get()
cbm_k_plot_get: {
    // __mem unsigned char x
    // [368] cbm_k_plot_get::x = 0 -- vbum1=vbuc1 
    lda #0
    sta x
    // __mem unsigned char y
    // [369] cbm_k_plot_get::y = 0 -- vbum1=vbuc1 
    sta y
    // kickasm
    // kickasm( uses cbm_k_plot_get::x uses cbm_k_plot_get::y uses CBM_PLOT) {{ sec         jsr CBM_PLOT         stx y         sty x      }}
    sec
        jsr CBM_PLOT
        stx y
        sty x
    
    // MAKEWORD(x,y)
    // [371] cbm_k_plot_get::return#0 = cbm_k_plot_get::x w= cbm_k_plot_get::y -- vwum1=vbum2_word_vbum3 
    lda x
    sta return+1
    lda y
    sta return
    // cbm_k_plot_get::@return
    // }
    // [372] return 
    rts
  .segment Data
    x: .byte 0
    y: .byte 0
    .label return = screenlayer.mapbase_offset
}
.segment Code
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__register(X) char x, __register(Y) char y)
gotoxy: {
    // (x>=__conio.width)?__conio.width:x
    // [373] if(gotoxy::x#0>=*((char *)&__conio+6)) goto gotoxy::@1 -- vbuxx_ge__deref_pbuc1_then_la1 
    cpx __conio+6
    bcs __b1
    // [375] phi from gotoxy gotoxy::@1 to gotoxy::@2 [phi:gotoxy/gotoxy::@1->gotoxy::@2]
    // [375] phi gotoxy::$3 = gotoxy::x#0 [phi:gotoxy/gotoxy::@1->gotoxy::@2#0] -- register_copy 
    jmp __b2
    // gotoxy::@1
  __b1:
    // [374] gotoxy::$2 = *((char *)&__conio+6) -- vbuxx=_deref_pbuc1 
    ldx __conio+6
    // gotoxy::@2
  __b2:
    // __conio.cursor_x = (x>=__conio.width)?__conio.width:x
    // [376] *((char *)&__conio) = gotoxy::$3 -- _deref_pbuc1=vbuxx 
    stx __conio
    // (y>=__conio.height)?__conio.height:y
    // [377] if(gotoxy::y#0>=*((char *)&__conio+7)) goto gotoxy::@3 -- vbuyy_ge__deref_pbuc1_then_la1 
    cpy __conio+7
    bcs __b3
    // gotoxy::@4
    // [378] gotoxy::$14 = gotoxy::y#0 -- vbuaa=vbuyy 
    tya
    // [379] phi from gotoxy::@3 gotoxy::@4 to gotoxy::@5 [phi:gotoxy::@3/gotoxy::@4->gotoxy::@5]
    // [379] phi gotoxy::$7 = gotoxy::$6 [phi:gotoxy::@3/gotoxy::@4->gotoxy::@5#0] -- register_copy 
    // gotoxy::@5
  __b5:
    // __conio.cursor_y = (y>=__conio.height)?__conio.height:y
    // [380] *((char *)&__conio+1) = gotoxy::$7 -- _deref_pbuc1=vbuaa 
    sta __conio+1
    // __conio.cursor_x << 1
    // [381] gotoxy::$8 = *((char *)&__conio) << 1 -- vbuxx=_deref_pbuc1_rol_1 
    lda __conio
    asl
    tax
    // __conio.offsets[y] + __conio.cursor_x << 1
    // [382] gotoxy::$10 = gotoxy::y#0 << 1 -- vbuaa=vbuyy_rol_1 
    tya
    asl
    // [383] gotoxy::$9 = ((unsigned int *)&__conio+$15)[gotoxy::$10] + gotoxy::$8 -- vwum1=pwuc1_derefidx_vbuaa_plus_vbuxx 
    tay
    txa
    clc
    adc __conio+$15,y
    sta gotoxy__9
    lda __conio+$15+1,y
    adc #0
    sta gotoxy__9+1
    // __conio.offset = __conio.offsets[y] + __conio.cursor_x << 1
    // [384] *((unsigned int *)&__conio+$13) = gotoxy::$9 -- _deref_pwuc1=vwum1 
    lda gotoxy__9
    sta __conio+$13
    lda gotoxy__9+1
    sta __conio+$13+1
    // gotoxy::@return
    // }
    // [385] return 
    rts
    // gotoxy::@3
  __b3:
    // (y>=__conio.height)?__conio.height:y
    // [386] gotoxy::$6 = *((char *)&__conio+7) -- vbuaa=_deref_pbuc1 
    lda __conio+7
    jmp __b5
  .segment Data
    .label gotoxy__9 = screenlayer.mapbase_offset
}
.segment Code
  // cx16_brk_debug
// void cx16_brk_debug()
cx16_brk_debug: {
    // cx16_brk_relay(&cx16_brk_debugger)
    // [388] call cx16_brk_relay
    jsr cx16_brk_relay
    // cx16_brk_debug::@return
    // }
    // [389] return 
    rts
}
  // vera_layer1_hide
/**
 * @brief Hide the layer 1 to be displayed from the screen.
 */
// void vera_layer1_hide()
vera_layer1_hide: {
    // *VERA_CTRL &= ~VERA_DCSEL
    // [390] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER1_ENABLE
    // [391] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER1_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER1_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_layer1_hide::@return
    // }
    // [392] return 
    rts
}
  // petscii
// volatile extern char buffer[256];
// void petscii()
petscii: {
    // vera_layer1_mode_tile(
    //         // Maps must be aligned to 512 bytes, so allocate the map second.
    //         1, (vram_offset_t)0xB000, 
    //         // Tiles must be aligned to 2048 bytes, to allocate the tile map first. Note that the size parameter does the actual alignment to 2048 bytes.
    //         1, (vram_offset_t)0xF000, 
    //         VERA_LAYER_WIDTH_128, VERA_LAYER_HEIGHT_64, 
    //         VERA_TILEBASE_WIDTH_8, VERA_TILEBASE_HEIGHT_8, 
    //         VERA_LAYER_COLOR_DEPTH_1BPP
    //     )
    // [394] call vera_layer1_mode_tile
    // [700] phi from petscii to vera_layer1_mode_tile [phi:petscii->vera_layer1_mode_tile]
    jsr vera_layer1_mode_tile
    // [395] phi from petscii to petscii::@2 [phi:petscii->petscii::@2]
    // petscii::@2
    // screenlayer1()
    // [396] call screenlayer1
    jsr screenlayer1
    // [397] phi from petscii::@2 to petscii::@3 [phi:petscii::@2->petscii::@3]
    // petscii::@3
    // textcolor(WHITE)
    // [398] call textcolor
    jsr textcolor
    // [399] phi from petscii::@3 to petscii::@4 [phi:petscii::@3->petscii::@4]
    // petscii::@4
    // bgcolor(BLACK)
    // [400] call bgcolor
    // [360] phi from petscii::@4 to bgcolor [phi:petscii::@4->bgcolor]
    // [360] phi bgcolor::color#3 = BLACK [phi:petscii::@4->bgcolor#0] -- vbuxx=vbuc1 
    ldx #BLACK
    jsr bgcolor
    // [401] phi from petscii::@4 to petscii::@5 [phi:petscii::@4->petscii::@5]
    // petscii::@5
    // clrscr()
    // [402] call clrscr
    jsr clrscr
    // petscii::vera_layer1_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [403] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_LAYER1_ENABLE
    // [404] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_LAYER1_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER1_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // petscii::vera_layer0_hide1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [405] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER0_ENABLE
    // [406] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER0_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER0_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [407] phi from petscii::vera_layer0_hide1 to petscii::@1 [phi:petscii::vera_layer0_hide1->petscii::@1]
    // petscii::@1
    // scroll(0)
    // [408] call scroll
    // [410] phi from petscii::@1 to scroll [phi:petscii::@1->scroll]
    // [410] phi scroll::onoff#3 = 0 [phi:petscii::@1->scroll#0] -- vbuaa=vbuc1 
    lda #0
    jsr scroll
    // petscii::@return
    // }
    // [409] return 
    rts
}
  // scroll
// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 0, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
// char scroll(__register(A) char onoff)
scroll: {
    // __conio.scroll[__conio.layer] = onoff
    // [411] ((char *)&__conio+$f)[*((char *)&__conio+2)] = scroll::onoff#3 -- pbuc1_derefidx_(_deref_pbuc2)=vbuaa 
    ldy __conio+2
    sta __conio+$f,y
    // scroll::@return
    // }
    // [412] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
// void clrscr()
clrscr: {
    // unsigned int line_text = __conio.mapbase_offset
    // [413] clrscr::line_text#0 = *((unsigned int *)&__conio+3) -- vwum1=_deref_pwuc1 
    lda __conio+3
    sta line_text
    lda __conio+3+1
    sta line_text+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [414] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // __conio.mapbase_bank | VERA_INC_1
    // [415] clrscr::$0 = *((char *)&__conio+5) | VERA_INC_1 -- vbuaa=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [416] *VERA_ADDRX_H = clrscr::$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // unsigned char l = __conio.mapheight
    // [417] clrscr::l#0 = *((char *)&__conio+9) -- vbuxx=_deref_pbuc1 
    ldx __conio+9
    // [418] phi from clrscr clrscr::@3 to clrscr::@1 [phi:clrscr/clrscr::@3->clrscr::@1]
    // [418] phi clrscr::l#4 = clrscr::l#0 [phi:clrscr/clrscr::@3->clrscr::@1#0] -- register_copy 
    // [418] phi clrscr::ch#0 = clrscr::line_text#0 [phi:clrscr/clrscr::@3->clrscr::@1#1] -- register_copy 
    // clrscr::@1
  __b1:
    // BYTE0(ch)
    // [419] clrscr::$1 = byte0  clrscr::ch#0 -- vbuaa=_byte0_vwum1 
    lda ch
    // *VERA_ADDRX_L = BYTE0(ch)
    // [420] *VERA_ADDRX_L = clrscr::$1 -- _deref_pbuc1=vbuaa 
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(ch)
    // [421] clrscr::$2 = byte1  clrscr::ch#0 -- vbuaa=_byte1_vwum1 
    lda ch+1
    // *VERA_ADDRX_M = BYTE1(ch)
    // [422] *VERA_ADDRX_M = clrscr::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // unsigned char c = __conio.mapwidth
    // [423] clrscr::c#0 = *((char *)&__conio+8) -- vbuyy=_deref_pbuc1 
    ldy __conio+8
    // [424] phi from clrscr::@1 clrscr::@2 to clrscr::@2 [phi:clrscr::@1/clrscr::@2->clrscr::@2]
    // [424] phi clrscr::c#2 = clrscr::c#0 [phi:clrscr::@1/clrscr::@2->clrscr::@2#0] -- register_copy 
    // clrscr::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [425] *VERA_DATA0 = ' 'pm -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [426] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // c--;
    // [427] clrscr::c#1 = -- clrscr::c#2 -- vbuyy=_dec_vbuyy 
    dey
    // while(c)
    // [428] if(0!=clrscr::c#1) goto clrscr::@2 -- 0_neq_vbuyy_then_la1 
    cpy #0
    bne __b2
    // clrscr::@3
    // line_text += __conio.rowskip
    // [429] clrscr::line_text#1 = clrscr::ch#0 + *((unsigned int *)&__conio+$a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda line_text
    adc __conio+$a
    sta line_text
    lda line_text+1
    adc __conio+$a+1
    sta line_text+1
    // l--;
    // [430] clrscr::l#1 = -- clrscr::l#4 -- vbuxx=_dec_vbuxx 
    dex
    // while(l)
    // [431] if(0!=clrscr::l#1) goto clrscr::@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne __b1
    // clrscr::@4
    // __conio.cursor_x = 0
    // [432] *((char *)&__conio) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio
    // __conio.cursor_y = 0
    // [433] *((char *)&__conio+1) = 0 -- _deref_pbuc1=vbuc2 
    sta __conio+1
    // __conio.offset = __conio.mapbase_offset
    // [434] *((unsigned int *)&__conio+$13) = *((unsigned int *)&__conio+3) -- _deref_pwuc1=_deref_pwuc2 
    lda __conio+3
    sta __conio+$13
    lda __conio+3+1
    sta __conio+$13+1
    // clrscr::@return
    // }
    // [435] return 
    rts
  .segment Data
    .label line_text = ch
    ch: .word 0
}
.segment Code
  // equinoxe_init
// __mem FILE* music;
// unsigned char music_buffer[1024];
// void equinoxe_init()
equinoxe_init: {
    // fload_bram("stages.bin", BANK_ENGINE_STAGES, (bram_ptr_t)0xA000)
    // [437] call fload_bram
    // [715] phi from equinoxe_init to fload_bram [phi:equinoxe_init->fload_bram]
    // [715] phi __errno#101 = 0 [phi:equinoxe_init->fload_bram#0] -- vwsm1=vwsc1 
    lda #<0
    sta __errno
    sta __errno+1
    // [715] phi fload_bram::filename#10 = equinoxe_init::filename [phi:equinoxe_init->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename
    sta.z fload_bram.filename
    lda #>filename
    sta.z fload_bram.filename+1
    // [715] phi fload_bram::dbank#5 = 3 [phi:equinoxe_init->fload_bram#2] -- vbuxx=vbuc1 
    ldx #3
    jsr fload_bram
    // [438] phi from equinoxe_init to equinoxe_init::@1 [phi:equinoxe_init->equinoxe_init::@1]
    // equinoxe_init::@1
    // fload_bram("bramflight1.bin", BANK_ENGINE_SPRITES, (bram_ptr_t)0xA000)
    // [439] call fload_bram
    // [715] phi from equinoxe_init::@1 to fload_bram [phi:equinoxe_init::@1->fload_bram]
    // [715] phi __errno#101 = __errno#100 [phi:equinoxe_init::@1->fload_bram#0] -- register_copy 
    // [715] phi fload_bram::filename#10 = equinoxe_init::filename1 [phi:equinoxe_init::@1->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename1
    sta.z fload_bram.filename
    lda #>filename1
    sta.z fload_bram.filename+1
    // [715] phi fload_bram::dbank#5 = 4 [phi:equinoxe_init::@1->fload_bram#2] -- vbuxx=vbuc1 
    ldx #4
    jsr fload_bram
    // [440] phi from equinoxe_init::@1 to equinoxe_init::@2 [phi:equinoxe_init::@1->equinoxe_init::@2]
    // equinoxe_init::@2
    // fload_bram("bramfloor1.bin", BANK_ENGINE_FLOOR, (bram_ptr_t)0xA000)
    // [441] call fload_bram
    // [715] phi from equinoxe_init::@2 to fload_bram [phi:equinoxe_init::@2->fload_bram]
    // [715] phi __errno#101 = __errno#100 [phi:equinoxe_init::@2->fload_bram#0] -- register_copy 
    // [715] phi fload_bram::filename#10 = equinoxe_init::filename2 [phi:equinoxe_init::@2->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename2
    sta.z fload_bram.filename
    lda #>filename2
    sta.z fload_bram.filename+1
    // [715] phi fload_bram::dbank#5 = 5 [phi:equinoxe_init::@2->fload_bram#2] -- vbuxx=vbuc1 
    ldx #5
    jsr fload_bram
    // [442] phi from equinoxe_init::@2 to equinoxe_init::@3 [phi:equinoxe_init::@2->equinoxe_init::@3]
    // equinoxe_init::@3
    // fload_bram("veraheap.bin", BANK_VERA_HEAP, (bram_ptr_t)0xA000)
    // [443] call fload_bram
    // [715] phi from equinoxe_init::@3 to fload_bram [phi:equinoxe_init::@3->fload_bram]
    // [715] phi __errno#101 = __errno#100 [phi:equinoxe_init::@3->fload_bram#0] -- register_copy 
    // [715] phi fload_bram::filename#10 = equinoxe_init::filename3 [phi:equinoxe_init::@3->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename3
    sta.z fload_bram.filename
    lda #>filename3
    sta.z fload_bram.filename+1
    // [715] phi fload_bram::dbank#5 = 1 [phi:equinoxe_init::@3->fload_bram#2] -- vbuxx=vbuc1 
    ldx #1
    jsr fload_bram
    // [444] phi from equinoxe_init::@3 to equinoxe_init::@4 [phi:equinoxe_init::@3->equinoxe_init::@4]
    // equinoxe_init::@4
    // flight_init()
    // [445] call flight_init
    // [734] phi from equinoxe_init::@4 to flight_init [phi:equinoxe_init::@4->flight_init]
    jsr flight_init
    // [446] phi from equinoxe_init::@4 to equinoxe_init::@5 [phi:equinoxe_init::@4->equinoxe_init::@5]
    // equinoxe_init::@5
    // fload_bram("players.bin", BANK_ENGINE_PLAYERS, (bram_ptr_t)0xA000)
    // [447] call fload_bram
    // [715] phi from equinoxe_init::@5 to fload_bram [phi:equinoxe_init::@5->fload_bram]
    // [715] phi __errno#101 = __errno#100 [phi:equinoxe_init::@5->fload_bram#0] -- register_copy 
    // [715] phi fload_bram::filename#10 = equinoxe_init::filename4 [phi:equinoxe_init::@5->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename4
    sta.z fload_bram.filename
    lda #>filename4
    sta.z fload_bram.filename+1
    // [715] phi fload_bram::dbank#5 = 9 [phi:equinoxe_init::@5->fload_bram#2] -- vbuxx=vbuc1 
    ldx #9
    jsr fload_bram
    // [448] phi from equinoxe_init::@5 to equinoxe_init::@6 [phi:equinoxe_init::@5->equinoxe_init::@6]
    // equinoxe_init::@6
    // animate_init()
    // [449] callexecute animate_init  -- call_var_near 
    jsr lib_animate.animate_init
    // memset(&stage, 0, sizeof(stage_t))
    // [450] call memset
    // [752] phi from equinoxe_init::@6 to memset [phi:equinoxe_init::@6->memset]
    jsr memset
    // [451] phi from equinoxe_init::@6 to equinoxe_init::@7 [phi:equinoxe_init::@6->equinoxe_init::@7]
    // equinoxe_init::@7
    // lru_cache_init()
    // [452] callexecute lru_cache_init  -- call_var_near 
    // Initialize the cache in vram for the sprite animations.
    jsr lib_lru_cache.lru_cache_init
    // equinoxe_init::@return
    // }
    // [453] return 
    rts
  .segment Data
    filename: .text "stages.bin"
    .byte 0
    filename1: .text "bramflight1.bin"
    .byte 0
    filename2: .text "bramfloor1.bin"
    .byte 0
    filename3: .text "veraheap.bin"
    .byte 0
    filename4: .text "players.bin"
    .byte 0
}
.segment CodeEngineStages
  // stage_reset
// void stage_reset()
// __bank(cx16_ram, 3) 
stage_reset: {
    .label stage_player = $53
    .label stage_engine = $5d
    // palette_init(BANK_ENGINE_PALETTE)
    // [454] palette_init::bram_bank = 6 -- vbuz1=vbuc1 
    lda #6
    sta.z lib_palette.palette_init.bram_bank
    // [455] callexecute palette_init  -- call_var_near 
    jsr lib_palette.palette_init
    // [456] phi from stage_reset to stage_reset::@1 [phi:stage_reset->stage_reset::@1]
    // stage_reset::@1
    // memset(&stage, 0, sizeof(stage_t))
    // [457] call memset
    // [752] phi from stage_reset::@1 to memset [phi:stage_reset::@1->memset]
    jsr memset
    // stage_reset::@2
    // stage.script_b.playbook_total_b = 1
    // [458] *((char *)(struct $47 *)&stage+$15) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta stage+$15
    // stage.script_b.playbooks_b = stage_playbooks_b
    // [459] *((struct $46 **)(struct $47 *)&stage+$15+1) = stage_playbooks_b -- _deref_qssc1=pssc2 
    lda #<stage_playbooks_b
    sta stage+$15+1
    lda #>stage_playbooks_b
    sta stage+$15+1+1
    // &stage_playbooks_b[stage.playbook_current]
    // [460] stage_reset::$15 = *((unsigned int *)&stage+$1a) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+$1a
    asl
    sta stage_reset__15
    lda stage+$1a+1
    rol
    sta stage_reset__15+1
    asl stage_reset__15
    rol stage_reset__15+1
    // [461] stage_reset::$16 = stage_reset::$15 + *((unsigned int *)&stage+$1a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_reset__16
    adc stage+$1a
    sta stage_reset__16
    lda stage_reset__16+1
    adc stage+$1a+1
    sta stage_reset__16+1
    // [462] stage_reset::$8 = stage_reset::$16 << 1 -- vwum1=vwum1_rol_1 
    asl stage_reset__8
    rol stage_reset__8+1
    // [463] memcpy::source#0 = stage_playbooks_b + stage_reset::$8 -- pssz1=pssc1_plus_vwum2 
    lda stage_reset__8
    clc
    adc #<stage_playbooks_b
    sta.z memcpy.source
    lda stage_reset__8+1
    adc #>stage_playbooks_b
    sta.z memcpy.source+1
    // memcpy(&stage.current_playbook, &stage_playbooks_b[stage.playbook_current], sizeof(stage_playbook_t))
    // [464] call memcpy
    // stage.current_playbook = stage_playbook[stage.playbook];
    jsr memcpy
    // stage_reset::@3
    // stage.lives = 10
    // [465] *((char *)&stage+$34) = $a -- _deref_pbuc1=vbuc2 
    lda #$a
    sta stage+$34
    // stage.scenario_total = stage.current_playbook.scenario_total_b
    // [466] *((unsigned int *)&stage+$1e) = *((char *)(struct $46 *)&stage) -- _deref_pwuc1=_deref_pbuc2 
    lda stage
    sta stage+$1e
    lda #0
    sta stage+$1e+1
    // stage_load()
    // [467] call stage_load
    // bug?
    jsr stage_load
    // stage_reset::@4
    // stage_copy(stage.ew, stage.scenario_current)
    // [468] stage_copy::ew#0 = *((unsigned int *)&stage+$18) -- vbum1=_deref_pwuc1 
    lda stage+$18
    sta stage_copy.ew
    // [469] stage_copy::scenario#0 = *((unsigned int *)&stage+$1c) -- vwum1=_deref_pwuc1 
    lda stage+$1c
    sta stage_copy.scenario
    lda stage+$1c+1
    sta stage_copy.scenario+1
    // [470] call stage_copy
  // Load the artefacts of the stage.
    // [774] phi from stage_reset::@4 to stage_copy [phi:stage_reset::@4->stage_copy]
    // [774] phi stage_copy::ew#2 = stage_copy::ew#0 [phi:stage_reset::@4->stage_copy#0] -- register_copy 
    // [774] phi stage_copy::scenario#2 = stage_copy::scenario#0 [phi:stage_reset::@4->stage_copy#1] -- register_copy 
    jsr stage_copy
    // stage_reset::@5
    // stage_player_t* stage_player = stage_playbooks_b->stage_player
    // [471] stage_reset::stage_player#0 = *((struct $35 **)stage_playbooks_b+3) -- pssz1=_deref_qssc1 
    // Add the player to the stage.
    lda stage_playbooks_b+3
    sta.z stage_player
    lda stage_playbooks_b+3+1
    sta.z stage_player+1
    // stage_engine_t* stage_engine = stage_player->stage_engine
    // [472] stage_reset::stage_engine#0 = ((struct $33 **)stage_reset::stage_player#0)[1] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #1
    lda (stage_player),y
    sta.z stage_engine
    iny
    lda (stage_player),y
    sta.z stage_engine+1
    // player_add(stage_player->player_sprite, stage_engine->engine_sprite)
    // [473] player_add::sprite_player#0 = *((char *)stage_reset::stage_player#0) -- vbuxx=_deref_pbuz1 
    ldy #0
    lda (stage_player),y
    tax
    // [474] player_add::sprite_engine#0 = *((char *)stage_reset::stage_engine#0) -- vbum1=_deref_pbuz2 
    lda (stage_engine),y
    sta player_add.sprite_engine
    // [475] call player_add
    // [803] phi from stage_reset::@5 to player_add [phi:stage_reset::@5->player_add]
    // [803] phi player_add::sprite_engine#2 = player_add::sprite_engine#0 [phi:stage_reset::@5->player_add#0] -- register_copy 
    // [803] phi player_add::sprite_player#2 = player_add::sprite_player#0 [phi:stage_reset::@5->player_add#1] -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <player_add
    .byte >player_add
    .byte 9
    // stage_reset::@return
    // }
    // [476] return 
    rts
  .segment DataEngineStages
    .label stage_reset__8 = stage_logic.new_scenario
    .label stage_reset__15 = stage_logic.new_scenario
    .label stage_reset__16 = stage_logic.new_scenario
}
.segment CodeEngineStages
  // stage_logic
// void stage_logic()
// __bank(cx16_ram, 3) 
stage_logic: {
    .label stage_playbook_ptr1_stage_playbooks_b = $53
    .label stage_playbook_ptr1_return = $59
    .label stage_scenario_ptr1_stage_scenarios_b = $53
    .label stage_scenario_ptr1_return = $31
    .label stage_playbook_ptr2_stage_playbooks_b = $53
    .label stage_playbook_ptr2_return = $22
    .label stage_player_ptr_b = $5d
    .label stage_engine_ptr_b = $53
    // if(stage.playbook_current < stage.script_b.playbook_total_b)
    // [477] if(*((unsigned int *)&stage+$1a)>=*((char *)(struct $47 *)&stage+$15)) goto stage_logic::@1 -- _deref_pwuc1_ge__deref_pbuc2_then_la1 
    lda stage+$1a+1
    bne __b1
    lda stage+$1a
    cmp stage+$15
    bcs __b1
  !:
    // stage_logic::@2
    // game.tickstage & 0x03
    // [478] stage_logic::$3 = *((char *)&game+2) & 3 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #3
    and game+2
    // if(!(game.tickstage & 0x03))
    // [479] if(0!=stage_logic::$3) goto stage_logic::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // [480] phi from stage_logic::@2 to stage_logic::@4 [phi:stage_logic::@2->stage_logic::@4]
    // [480] phi stage_logic::w#10 = 0 [phi:stage_logic::@2->stage_logic::@4#0] -- vbuxx=vbuc1 
    ldx #0
  // BREAKPOINT
    // stage_logic::@4
  __b4:
    // for(__mem unsigned char w=0; w<8; w++)
    // [481] if(stage_logic::w#10<8) goto stage_logic::@5 -- vbuxx_lt_vbuc1_then_la1 
    cpx #8
    bcs !__b5+
    jmp __b5
  !__b5:
    // [482] phi from stage_logic::@4 to stage_logic::@14 [phi:stage_logic::@4->stage_logic::@14]
    // [482] phi stage_logic::w1#2 = 0 [phi:stage_logic::@4->stage_logic::@14#0] -- vbum1=vbuc1 
    lda #0
    sta w1
    // stage_logic::@14
  __b14:
    // for(unsigned char w=0; w<8; w++)
    // [483] if(stage_logic::w1#2<8) goto stage_logic::@15 -- vbum1_lt_vbuc1_then_la1 
    lda w1
    cmp #8
    bcs !__b15+
    jmp __b15
  !__b15:
    // stage_logic::@16
    // if(stage.scenario_current >= stage.scenario_total)
    // [484] if(*((unsigned int *)&stage+$1c)<*((unsigned int *)&stage+$1e)) goto stage_logic::@1 -- _deref_pwuc1_lt__deref_pwuc2_then_la1 
    lda stage+$1c+1
    cmp stage+$1e+1
    bcc __b1
    bne !+
    lda stage+$1c
    cmp stage+$1e
    bcc __b1
  !:
    // stage_logic::@23
    // if(stage.playbook_current < stage.script_b.playbook_total_b)
    // [485] if(*((unsigned int *)&stage+$1a)>=*((char *)(struct $47 *)&stage+$15)) goto stage_logic::@1 -- _deref_pwuc1_ge__deref_pbuc2_then_la1 
    lda stage+$1a+1
    bne __b1
    lda stage+$1a
    cmp stage+$15
    bcs __b1
  !:
    // stage_logic::@24
    // stage.scenario_current = 0
    // [486] *((unsigned int *)&stage+$1c) = 0 -- _deref_pwuc1=vbuc2 
    // stage.playbook_current++;
    // stage_playbook_t* stage_playbook = stage.script_b.playbooks_b;
    // stage.current_playbook = stage_playbook[stage.playbook_current];
    // stage.scenario_total = stage.current_playbook.scenario_total_b;
    lda #<0
    sta stage+$1c
    sta stage+$1c+1
    // stage_logic::@1
  __b1:
    // if(stage.player_respawn)
    // [487] if(0==*((char *)&stage+$35)) goto stage_logic::@return -- 0_eq__deref_pbuc1_then_la1 
    lda stage+$35
    beq __breturn
    // stage_logic::@3
    // stage.player_respawn--;
    // [488] *((char *)&stage+$35) = -- *((char *)&stage+$35) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec stage+$35
    // if(!stage.player_respawn)
    // [489] if(0!=*((char *)&stage+$35)) goto stage_logic::@return -- 0_neq__deref_pbuc1_then_la1 
    lda stage+$35
    bne __breturn
    // stage_logic::stage_playbook_ptr2
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [490] stage_logic::stage_playbook_ptr2_stage_playbooks_b#0 = *((struct $46 **)(struct $47 *)&stage+$15+1) -- pssz1=_deref_qssc1 
    lda stage+$15+1
    sta.z stage_playbook_ptr2_stage_playbooks_b
    lda stage+$15+1+1
    sta.z stage_playbook_ptr2_stage_playbooks_b+1
    // &stage_playbooks_b[stage.playbook_current]
    // [491] stage_logic::$56 = *((unsigned int *)&stage+$1a) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+$1a
    asl
    sta stage_logic__56
    lda stage+$1a+1
    rol
    sta stage_logic__56+1
    asl stage_logic__56
    rol stage_logic__56+1
    // [492] stage_logic::$57 = stage_logic::$56 + *((unsigned int *)&stage+$1a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_logic__57
    adc stage+$1a
    sta stage_logic__57
    lda stage_logic__57+1
    adc stage+$1a+1
    sta stage_logic__57+1
    // [493] stage_logic::stage_playbook_ptr2_$1 = stage_logic::$57 << 1 -- vwum1=vwum1_rol_1 
    asl stage_playbook_ptr2_stage_logic__1
    rol stage_playbook_ptr2_stage_logic__1+1
    // [494] stage_logic::stage_playbook_ptr2_return#0 = stage_logic::stage_playbook_ptr2_stage_playbooks_b#0 + stage_logic::stage_playbook_ptr2_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_playbook_ptr2_stage_logic__1
    clc
    adc.z stage_playbook_ptr2_stage_playbooks_b
    sta.z stage_playbook_ptr2_return
    lda stage_playbook_ptr2_stage_logic__1+1
    adc.z stage_playbook_ptr2_stage_playbooks_b+1
    sta.z stage_playbook_ptr2_return+1
    // stage_logic::@26
    // stage_player_t* stage_player_ptr_b = stage_playbook_ptr_b->stage_player
    // [495] stage_logic::stage_player_ptr_b#0 = ((struct $35 **)stage_logic::stage_playbook_ptr2_return#0)[3] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #3
    lda (stage_playbook_ptr2_return),y
    sta.z stage_player_ptr_b
    iny
    lda (stage_playbook_ptr2_return),y
    sta.z stage_player_ptr_b+1
    // stage_engine_t* stage_engine_ptr_b = stage_player_ptr_b->stage_engine
    // [496] stage_logic::stage_engine_ptr_b#0 = ((struct $33 **)stage_logic::stage_player_ptr_b#0)[1] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #1
    lda (stage_player_ptr_b),y
    sta.z stage_engine_ptr_b
    iny
    lda (stage_player_ptr_b),y
    sta.z stage_engine_ptr_b+1
    // player_add(stage_player_ptr_b->player_sprite, stage_engine_ptr_b->engine_sprite)
    // [497] player_add::sprite_player#1 = *((char *)stage_logic::stage_player_ptr_b#0) -- vbuxx=_deref_pbuz1 
    ldy #0
    lda (stage_player_ptr_b),y
    tax
    // [498] player_add::sprite_engine#1 = *((char *)stage_logic::stage_engine_ptr_b#0) -- vbum1=_deref_pbuz2 
    lda (stage_engine_ptr_b),y
    sta player_add.sprite_engine
    // [499] call player_add
    // [803] phi from stage_logic::@26 to player_add [phi:stage_logic::@26->player_add]
    // [803] phi player_add::sprite_engine#2 = player_add::sprite_engine#1 [phi:stage_logic::@26->player_add#0] -- register_copy 
    // [803] phi player_add::sprite_player#2 = player_add::sprite_player#1 [phi:stage_logic::@26->player_add#1] -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <player_add
    .byte >player_add
    .byte 9
    // stage_logic::@return
  __breturn:
    // }
    // [500] return 
    rts
    // stage_logic::@15
  __b15:
    // if(wave.finished[w])
    // [501] if(0==((char *)&wave+$80)[stage_logic::w1#2]) goto stage_logic::@17 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy w1
    lda wave+$80,y
    cmp #0
    beq __b17
    // stage_logic::@22
    // __mem stage_scenario_index_t new_scenario = wave.scenario[w]
    // [502] stage_logic::$33 = stage_logic::w1#2 << 1 -- vbuxx=vbum1_rol_1 
    tya
    asl
    tax
    // [503] stage_logic::new_scenario#0 = ((unsigned int *)&wave+$88)[stage_logic::$33] -- vwum1=pwuc1_derefidx_vbuxx 
    // If there are more scenarios, create new waves based on the scenarios dependent on the finished wave.
    lda wave+$88,x
    sta new_scenario
    lda wave+$88+1,x
    sta new_scenario+1
    // __mem unsigned int wave_scenario = wave.scenario[w]
    // [504] stage_logic::wave_scenario#0 = ((unsigned int *)&wave+$88)[stage_logic::$33] -- vwum1=pwuc1_derefidx_vbuxx 
    lda wave+$88,x
    sta wave_scenario
    lda wave+$88+1,x
    sta wave_scenario+1
    // [505] phi from stage_logic::@20 stage_logic::@22 to stage_logic::@18 [phi:stage_logic::@20/stage_logic::@22->stage_logic::@18]
  __b2:
    // [505] phi stage_logic::new_scenario#10 = stage_logic::new_scenario#1 [phi:stage_logic::@20/stage_logic::@22->stage_logic::@18#0] -- register_copy 
  // TODO find solution for this loop, maybe with pointers?
    // stage_logic::@18
    // while(new_scenario < stage.scenario_total)
    // [506] if(stage_logic::new_scenario#10<*((unsigned int *)&stage+$1e)) goto stage_logic::stage_playbook_ptr1 -- vwum1_lt__deref_pwuc1_then_la1 
    lda new_scenario+1
    cmp stage+$1e+1
    bcc stage_playbook_ptr1
    bne !+
    lda new_scenario
    cmp stage+$1e
    bcc stage_playbook_ptr1
  !:
    // stage_logic::@19
    // wave.finished[w] = 0
    // [507] ((char *)&wave+$80)[stage_logic::w1#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy w1
    sta wave+$80,y
    // stage_logic::@17
  __b17:
    // for(unsigned char w=0; w<8; w++)
    // [508] stage_logic::w1#1 = ++ stage_logic::w1#2 -- vbum1=_inc_vbum1 
    inc w1
    // [482] phi from stage_logic::@17 to stage_logic::@14 [phi:stage_logic::@17->stage_logic::@14]
    // [482] phi stage_logic::w1#2 = stage_logic::w1#1 [phi:stage_logic::@17->stage_logic::@14#0] -- register_copy 
    jmp __b14
    // stage_logic::stage_playbook_ptr1
  stage_playbook_ptr1:
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [509] stage_logic::stage_playbook_ptr1_stage_playbooks_b#0 = *((struct $46 **)(struct $47 *)&stage+$15+1) -- pssz1=_deref_qssc1 
    lda stage+$15+1
    sta.z stage_playbook_ptr1_stage_playbooks_b
    lda stage+$15+1+1
    sta.z stage_playbook_ptr1_stage_playbooks_b+1
    // &stage_playbooks_b[stage.playbook_current]
    // [510] stage_logic::$53 = *((unsigned int *)&stage+$1a) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+$1a
    asl
    sta stage_logic__53
    lda stage+$1a+1
    rol
    sta stage_logic__53+1
    asl stage_logic__53
    rol stage_logic__53+1
    // [511] stage_logic::$54 = stage_logic::$53 + *((unsigned int *)&stage+$1a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_logic__54
    adc stage+$1a
    sta stage_logic__54
    lda stage_logic__54+1
    adc stage+$1a+1
    sta stage_logic__54+1
    // [512] stage_logic::stage_playbook_ptr1_$1 = stage_logic::$54 << 1 -- vwum1=vwum1_rol_1 
    asl stage_playbook_ptr1_stage_logic__1
    rol stage_playbook_ptr1_stage_logic__1+1
    // [513] stage_logic::stage_playbook_ptr1_return#0 = stage_logic::stage_playbook_ptr1_stage_playbooks_b#0 + stage_logic::stage_playbook_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_playbook_ptr1_stage_logic__1
    clc
    adc.z stage_playbook_ptr1_stage_playbooks_b
    sta.z stage_playbook_ptr1_return
    lda stage_playbook_ptr1_stage_logic__1+1
    adc.z stage_playbook_ptr1_stage_playbooks_b+1
    sta.z stage_playbook_ptr1_return+1
    // stage_logic::stage_scenario_ptr1
    // stage_scenario_t* stage_scenarios_b = stage_playbook_ptr_b->scenarios_b
    // [514] stage_logic::stage_scenario_ptr1_stage_scenarios_b#0 = ((struct $42 **)stage_logic::stage_playbook_ptr1_return#0)[1] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #1
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b
    iny
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b+1
    // &stage_scenarios_b[scenario]
    // [515] stage_logic::stage_scenario_ptr1_$1 = stage_logic::new_scenario#10 << 4 -- vwum1=vwum2_rol_4 
    lda new_scenario
    asl
    sta stage_scenario_ptr1_stage_logic__1
    lda new_scenario+1
    rol
    sta stage_scenario_ptr1_stage_logic__1+1
    asl stage_scenario_ptr1_stage_logic__1
    rol stage_scenario_ptr1_stage_logic__1+1
    asl stage_scenario_ptr1_stage_logic__1
    rol stage_scenario_ptr1_stage_logic__1+1
    asl stage_scenario_ptr1_stage_logic__1
    rol stage_scenario_ptr1_stage_logic__1+1
    // [516] stage_logic::stage_scenario_ptr1_return#0 = stage_logic::stage_scenario_ptr1_stage_scenarios_b#0 + stage_logic::stage_scenario_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_scenario_ptr1_stage_logic__1
    clc
    adc.z stage_scenario_ptr1_stage_scenarios_b
    sta.z stage_scenario_ptr1_return
    lda stage_scenario_ptr1_stage_logic__1+1
    adc.z stage_scenario_ptr1_stage_scenarios_b+1
    sta.z stage_scenario_ptr1_return+1
    // stage_logic::@25
    // unsigned int prev = stage_scenario_ptr_b->prev
    // [517] stage_logic::prev#0 = (unsigned int)((char *)stage_logic::stage_scenario_ptr1_return#0)[$e] -- vwum1=_word_pbuz2_derefidx_vbuc1 
    ldy #$e
    lda (stage_scenario_ptr1_return),y
    sta prev
    lda #0
    sta prev+1
    // if(prev == wave_scenario)
    // [518] if(stage_logic::prev#0!=stage_logic::wave_scenario#0) goto stage_logic::@20 -- vwum1_neq_vwum2_then_la1 
    cmp wave_scenario+1
    bne __b20
    lda prev
    cmp wave_scenario
    bne __b20
    // stage_logic::@21
    // stage.ew+1
    // [519] stage_logic::$20 = *((unsigned int *)&stage+$18) + 1 -- vwum1=_deref_pwuc1_plus_1 
    clc
    lda stage+$18
    adc #1
    sta stage_logic__20
    lda stage+$18+1
    adc #0
    sta stage_logic__20+1
    // (stage.ew+1) & 0x07
    // [520] stage_logic::$21 = stage_logic::$20 & 7 -- vbuaa=vwum1_band_vbuc1 
    lda #7
    and stage_logic__20
    // stage.ew = (stage.ew+1) & 0x07
    // [521] *((unsigned int *)&stage+$18) = stage_logic::$21 -- _deref_pwuc1=vbuaa 
    // We create new waves from the scenarios that are dependent on the finished one.
    // There must always be at least one that equals scenario of the previous scenario.
    sta stage+$18
    lda #0
    sta stage+$18+1
    // stage_copy(stage.ew, new_scenario)
    // [522] stage_copy::ew#1 = *((unsigned int *)&stage+$18) -- vbum1=_deref_pwuc1 
    lda stage+$18
    sta stage_copy.ew
    // [523] stage_copy::scenario#1 = stage_logic::new_scenario#10 -- vwum1=vwum2 
    lda new_scenario
    sta stage_copy.scenario
    lda new_scenario+1
    sta stage_copy.scenario+1
    // [524] call stage_copy
    // [774] phi from stage_logic::@21 to stage_copy [phi:stage_logic::@21->stage_copy]
    // [774] phi stage_copy::ew#2 = stage_copy::ew#1 [phi:stage_logic::@21->stage_copy#0] -- register_copy 
    // [774] phi stage_copy::scenario#2 = stage_copy::scenario#1 [phi:stage_logic::@21->stage_copy#1] -- register_copy 
    jsr stage_copy
    // stage_logic::@20
  __b20:
    // new_scenario++;
    // [525] stage_logic::new_scenario#1 = ++ stage_logic::new_scenario#10 -- vwum1=_inc_vwum1 
    inc new_scenario
    bne !+
    inc new_scenario+1
  !:
    jmp __b2
    // stage_logic::@5
  __b5:
    // if(wave.used[w])
    // [526] if(0==((char *)&wave+$78)[stage_logic::w#10]) goto stage_logic::@6 -- 0_eq_pbuc1_derefidx_vbuxx_then_la1 
    lda wave+$78,x
    cmp #0
    beq __b6
    // stage_logic::@12
    // if(!wave.wait[w])
    // [527] if(0==((char *)&wave+$68)[stage_logic::w#10]) goto stage_logic::@7 -- 0_eq_pbuc1_derefidx_vbuxx_then_la1 
    lda wave+$68,x
    cmp #0
    beq __b7
    // stage_logic::@13
    // wave.wait[w]--;
    // [528] ((char *)&wave+$68)[stage_logic::w#10] = -- ((char *)&wave+$68)[stage_logic::w#10] -- pbuc1_derefidx_vbuxx=_dec_pbuc1_derefidx_vbuxx 
    dec wave+$68,x
    // stage_logic::@6
  __b6:
    // for(__mem unsigned char w=0; w<8; w++)
    // [529] stage_logic::w#1 = ++ stage_logic::w#10 -- vbuxx=_inc_vbuxx 
    inx
    // [480] phi from stage_logic::@6 to stage_logic::@4 [phi:stage_logic::@6->stage_logic::@4]
    // [480] phi stage_logic::w#10 = stage_logic::w#1 [phi:stage_logic::@6->stage_logic::@4#0] -- register_copy 
    jmp __b4
    // stage_logic::@7
  __b7:
    // if(wave.enemy_count[w])
    // [530] if(0!=((char *)&wave)[stage_logic::w#10]) goto stage_logic::@8 -- 0_neq_pbuc1_derefidx_vbuxx_then_la1 
    lda wave,x
    cmp #0
    bne __b8
    // stage_logic::@10
    // if(!wave.enemy_alive[w])
    // [531] if(0!=((char *)&wave+$28)[stage_logic::w#10]) goto stage_logic::@6 -- 0_neq_pbuc1_derefidx_vbuxx_then_la1 
    lda wave+$28,x
    cmp #0
    bne __b6
    // stage_logic::@11
    // wave.used[w] = 0
    // [532] ((char *)&wave+$78)[stage_logic::w#10] = 0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #0
    sta wave+$78,x
    // wave.finished[w] = 1
    // [533] ((char *)&wave+$80)[stage_logic::w#10] = 1 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #1
    sta wave+$80,x
    jmp __b6
    // stage_logic::@8
  __b8:
    // if(wave.enemy_spawn[w])
    // [534] if(0==((char *)&wave+8)[stage_logic::w#10]) goto stage_logic::@6 -- 0_eq_pbuc1_derefidx_vbuxx_then_la1 
    lda wave+8,x
    cmp #0
    beq __b6
    // [535] phi from stage_logic::@8 to stage_logic::@9 [phi:stage_logic::@8->stage_logic::@9]
    // stage_logic::@9
    jmp __b6
  .segment DataEngineStages
    .label stage_logic__20 = stage_logic__53
    .label stage_playbook_ptr1_stage_logic__1 = stage_logic__53
    .label stage_scenario_ptr1_stage_logic__1 = stage_logic__53
    .label stage_playbook_ptr2_stage_logic__1 = new_scenario
    w1: .byte 0
    new_scenario: .word 0
    wave_scenario: .word 0
    .label prev = stage_logic__53
    stage_logic__53: .word 0
    .label stage_logic__54 = stage_logic__53
    .label stage_logic__56 = new_scenario
    .label stage_logic__57 = new_scenario
}
.segment Code
  // kbhit
// Returns a value if a key is pressed.
// __register(A) char kbhit()
kbhit: {
    // kbhit::cbm_k_clrchn1
    // asm
    // asm { jsrCBM_CLRCHN  }
    jsr CBM_CLRCHN
    // [538] phi from kbhit::cbm_k_clrchn1 to kbhit::@1 [phi:kbhit::cbm_k_clrchn1->kbhit::@1]
    // kbhit::@1
    // cbm_k_getin()
    // [539] call cbm_k_getin
    jsr cbm_k_getin
    // [540] cbm_k_getin::return#2 = cbm_k_getin::return#1
    // kbhit::@2
    // [541] kbhit::return#0 = cbm_k_getin::return#2
    // kbhit::@return
    // }
    // [542] return 
    rts
}
  // cx16_irq_relay
// void cx16_irq_relay(void (*irq)())
cx16_irq_relay: {
    .label irq = irq_vsync
    // *KERNEL_IRQ = irq
    // [543] *KERNEL_IRQ = cx16_irq_relay::irq#0 -- _deref_qprc1=pprc2 
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    // cx16_irq_relay::@return
    // }
    // [544] return 
    rts
}
  // cx16_mouse_config
/**
 * @brief Configures the mouse pointer.
 * 
 * 
 * @param visible Turn the mouse pointer on or off. Provide a value of 0xFF to set your own mouse pointer graphic (sprite 0).
 * @param scalex Specify x axis screen resolution in 8 pixel increments.
 * @param scaley Specify y axis screen resolution in 8 pixel increments.
 * 
 */
// void cx16_mouse_config(__mem() volatile char visible, __mem() volatile char scalex, __mem() volatile char scaley)
cx16_mouse_config: {
    // asm
    // asm { ldavisible ldxscalex ldyscaley jsrCX16_MOUSE_CONFIG  }
    lda visible
    ldx scalex
    ldy scaley
    jsr CX16_MOUSE_CONFIG
    // cx16_mouse_config::@return
    // }
    // [546] return 
    rts
  .segment Data
    visible: .byte 0
    scalex: .byte 0
    scaley: .byte 0
}
.segment Code
  // ht_init
// void ht_init(struct $4 *ht)
ht_init: {
    .const memset_fast1_c = 0
    .const memset_fast2_c = 0
    .label ht = collision_hash
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast1_destination = ht
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast2_destination = ht+$100
    // [548] phi from ht_init to ht_init::memset_fast1 [phi:ht_init->ht_init::memset_fast1]
    // ht_init::memset_fast1
    // [549] phi from ht_init::memset_fast1 to ht_init::memset_fast1_@1 [phi:ht_init::memset_fast1->ht_init::memset_fast1_@1]
    // [549] phi ht_init::memset_fast1_num#2 = 0 [phi:ht_init::memset_fast1->ht_init::memset_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [549] phi from ht_init::memset_fast1_@1 to ht_init::memset_fast1_@1 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast1_@1]
    // [549] phi ht_init::memset_fast1_num#2 = ht_init::memset_fast1_num#1 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast1_@1#0] -- register_copy 
    // ht_init::memset_fast1_@1
  memset_fast1___b1:
    // *(destination+num) = c
    // [550] ht_init::memset_fast1_destination#0[ht_init::memset_fast1_num#2] = ht_init::memset_fast1_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast1_c
    sta memset_fast1_destination,x
    // num--;
    // [551] ht_init::memset_fast1_num#1 = -- ht_init::memset_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [552] if(0!=ht_init::memset_fast1_num#1) goto ht_init::memset_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast1___b1
    // [553] phi from ht_init::memset_fast1_@1 to ht_init::memset_fast2 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast2]
    // ht_init::memset_fast2
    // [554] phi from ht_init::memset_fast2 to ht_init::memset_fast2_@1 [phi:ht_init::memset_fast2->ht_init::memset_fast2_@1]
    // [554] phi ht_init::memset_fast2_num#2 = 0 [phi:ht_init::memset_fast2->ht_init::memset_fast2_@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [554] phi from ht_init::memset_fast2_@1 to ht_init::memset_fast2_@1 [phi:ht_init::memset_fast2_@1->ht_init::memset_fast2_@1]
    // [554] phi ht_init::memset_fast2_num#2 = ht_init::memset_fast2_num#1 [phi:ht_init::memset_fast2_@1->ht_init::memset_fast2_@1#0] -- register_copy 
    // ht_init::memset_fast2_@1
  memset_fast2___b1:
    // *(destination+num) = c
    // [555] ht_init::memset_fast2_destination#0[ht_init::memset_fast2_num#2] = ht_init::memset_fast2_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast2_c
    sta memset_fast2_destination,x
    // num--;
    // [556] ht_init::memset_fast2_num#1 = -- ht_init::memset_fast2_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [557] if(0!=ht_init::memset_fast2_num#1) goto ht_init::memset_fast2_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast2___b1
    // ht_init::@return
    // }
    // [558] return 
    rts
}
.segment CodeEngineFlight
  // flight_root
// __register(X) char flight_root(char type)
flight_root: {
    // return flight.root[type];
    // [559] flight_root::return#0 = *((char *)&flight+$ac1) -- vbuxx=_deref_pbuc1 
    ldx flight+$ac1
    // flight_root::@return
    // }
    // [560] return 
    rts
}
  // flight_next
// __register(A) char flight_next(__register(X) char i)
flight_next: {
    // return flight.next[i];
    // [561] flight_next::return#0 = ((char *)&flight+$a41)[flight_next::i#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda flight+$a41,x
    // flight_next::@return
    // }
    // [562] return 
    rts
}
  // sprite_image_cache_vram
// __mem() unsigned int sprite_image_cache_vram(__register(X) char sprite_cache_index, __register(Y) char fe_sprite_image_index)
sprite_image_cache_vram: {
    .const bank_push_set_bram1_bank = 4
    .label sprite_ptr = $5b
    .label sprite_image_cache_vram__40 = $5b
    // unsigned int image_index = sprite_cache.offset[sprite_cache_index] + fe_sprite_image_index
    // [563] sprite_image_cache_vram::$37 = sprite_image_cache_vram::sprite_cache_index#0 << 1 -- vbum1=vbuxx_rol_1 
    txa
    asl
    sta sprite_image_cache_vram__37
    // [564] sprite_image_cache_vram::image_index#0 = ((unsigned int *)&sprite_cache+$30)[sprite_image_cache_vram::$37] + sprite_image_cache_vram::fe_sprite_image_index#0 -- vwum1=pwuc1_derefidx_vbum2_plus_vbuyy 
    // check if the image in vram is in use where the fe_sprite_vram_image_index is pointing to.
    // if this vram_image_used is false, that means that the image in vram is not in use anymore (not displayed or destroyed).
    tya
    ldy sprite_image_cache_vram__37
    clc
    adc sprite_cache+$30,y
    sta image_index
    lda sprite_cache+$30+1,y
    adc #0
    sta image_index+1
    // lru_cache_index_t vram_index = lru_cache_index(image_index)
    // [565] lru_cache_index::key = sprite_image_cache_vram::image_index#0 -- vwuz1=vwum2 
    // We check if there is a cache hit?
    lda image_index
    sta.z lib_lru_cache.lru_cache_index.key
    lda image_index+1
    sta.z lib_lru_cache.lru_cache_index.key+1
    // [566] callexecute lru_cache_index  -- call_var_near 
    jsr lib_lru_cache.lru_cache_index
    // [567] sprite_image_cache_vram::vram_index#0 = lru_cache_index::return -- vbuaa=vbuz1 
    lda.z lib_lru_cache.lru_cache_index.return
    // if (vram_index != 0xFF)
    // [568] if(sprite_image_cache_vram::vram_index#0!=$ff) goto sprite_image_cache_vram::@1 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$ff
    beq !__b1+
    jmp __b1
  !__b1:
    // sprite_image_cache_vram::vera_display_set_border_color1
    // *VERA_CTRL &= 0b10000001
    // [569] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [570] *VERA_DC_BORDER = RED -- _deref_pbuc1=vbuc2 
    lda #RED
    sta VERA_DC_BORDER
    // sprite_image_cache_vram::@8
    // vera_heap_size_int_t vram_size_required = sprite_cache.size[sprite_cache_index]
    // [571] sprite_image_cache_vram::vram_size_required#0 = ((unsigned int *)&sprite_cache+$50)[sprite_image_cache_vram::$37] -- vwum1=pwuc1_derefidx_vbum2 
    // The idea of this section is to free up lru_cache and/or vram memory until there is sufficient space available.
    // The size requested contains the required size to be allocated on vram.
    ldy sprite_image_cache_vram__37
    lda sprite_cache+$50,y
    sta vram_size_required
    lda sprite_cache+$50+1,y
    sta vram_size_required+1
    // bool vram_has_free = vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required)
    // [572] vera_heap_has_free::s = 1 -- vbuz1=vbuc1 
    // We check if the vram heap has sufficient memory available for the size requested.
    // We also check if the lru cache has sufficient elements left to contain the new sprite image.
    lda #1
    sta.z lib_veraheap.vera_heap_has_free.s
    // [573] vera_heap_has_free::size_requested = sprite_image_cache_vram::vram_size_required#0 -- vwuz1=vwum2 
    lda vram_size_required
    sta.z lib_veraheap.vera_heap_has_free.size_requested
    lda vram_size_required+1
    sta.z lib_veraheap.vera_heap_has_free.size_requested+1
    // [574] callexecute vera_heap_has_free  -- call_var_near 
    jsr lib_veraheap.vera_heap_has_free
    // [575] sprite_image_cache_vram::vram_has_free#0 = vera_heap_has_free::return -- vbom1=vboz2 
    lda.z lib_veraheap.vera_heap_has_free.return
    sta vram_has_free
    // bool lru_cache_max = lru_cache_is_max()
    // [576] callexecute lru_cache_is_max  -- call_var_near 
    jsr lib_lru_cache.lru_cache_is_max
    // [577] sprite_image_cache_vram::lru_cache_max#0 = lru_cache_is_max::return -- vboaa=vboz1 
    lda.z lib_lru_cache.lru_cache_is_max.return
    // [578] phi from sprite_image_cache_vram::@6 sprite_image_cache_vram::@8 to sprite_image_cache_vram::@3 [phi:sprite_image_cache_vram::@6/sprite_image_cache_vram::@8->sprite_image_cache_vram::@3]
  __b3:
    // [578] phi sprite_image_cache_vram::lru_cache_max#2 = sprite_image_cache_vram::lru_cache_max#1 [phi:sprite_image_cache_vram::@6/sprite_image_cache_vram::@8->sprite_image_cache_vram::@3#0] -- register_copy 
    // [578] phi sprite_image_cache_vram::vram_has_free#2 = sprite_image_cache_vram::vram_has_free#1 [phi:sprite_image_cache_vram::@6/sprite_image_cache_vram::@8->sprite_image_cache_vram::@3#1] -- register_copy 
  // Free up the lru_cache and vram memory until the requested size is available!
  // This ensures that vram has sufficient place to allocate the new sprite image.
    // sprite_image_cache_vram::@3
    // while (lru_cache_max || !vram_has_free)
    // [579] if(sprite_image_cache_vram::lru_cache_max#2) goto sprite_image_cache_vram::@4 -- vboaa_then_la1 
    cmp #0
    bne __b4
    // sprite_image_cache_vram::@12
    // [580] if(sprite_image_cache_vram::vram_has_free#2) goto sprite_image_cache_vram::@5 -- vbom1_then_la1 
    lda vram_has_free
    cmp #0
    bne __b5
    // [581] phi from sprite_image_cache_vram::@12 sprite_image_cache_vram::@3 to sprite_image_cache_vram::@4 [phi:sprite_image_cache_vram::@12/sprite_image_cache_vram::@3->sprite_image_cache_vram::@4]
    // sprite_image_cache_vram::@4
  __b4:
    // lru_cache_key_t vram_last = lru_cache_find_last()
    // [582] callexecute lru_cache_find_last  -- call_var_near 
    jsr lib_lru_cache.lru_cache_find_last
    // [583] sprite_image_cache_vram::vram_last#0 = lru_cache_find_last::return -- vwum1=vwuz2 
    lda.z lib_lru_cache.lru_cache_find_last.return
    sta vram_last
    lda.z lib_lru_cache.lru_cache_find_last.return+1
    sta vram_last+1
    // lru_cache_data_t vram_handle = lru_cache_delete(vram_last)
    // [584] lru_cache_delete::key = sprite_image_cache_vram::vram_last#0 -- vwuz1=vwum2 
    // We delete the least used image from the vram cache, and this function returns the stored vram handle obtained by the vram heap manager.
    lda vram_last
    sta.z lib_lru_cache.lru_cache_delete.key
    lda vram_last+1
    sta.z lib_lru_cache.lru_cache_delete.key+1
    // [585] callexecute lru_cache_delete  -- call_var_near 
    jsr lib_lru_cache.lru_cache_delete
    // [586] sprite_image_cache_vram::vram_handle#0 = lru_cache_delete::return -- vwum1=vwuz2 
    lda.z lib_lru_cache.lru_cache_delete.return
    sta vram_handle
    lda.z lib_lru_cache.lru_cache_delete.return+1
    sta vram_handle+1
    // if (vram_handle == 0xFFFF)
    // [587] if(sprite_image_cache_vram::vram_handle#0!=$ffff) goto sprite_image_cache_vram::@6 -- vwum1_neq_vwuc1_then_la1 
    cmp #>$ffff
    bne __b6
    lda vram_handle
    cmp #<$ffff
    // [588] phi from sprite_image_cache_vram::@4 to sprite_image_cache_vram::@7 [phi:sprite_image_cache_vram::@4->sprite_image_cache_vram::@7]
    // sprite_image_cache_vram::@7
    // sprite_image_cache_vram::@6
  __b6:
    // BYTE0(vram_handle)
    // [589] sprite_image_cache_vram::$12 = byte0  sprite_image_cache_vram::vram_handle#0 -- vbuxx=_byte0_vwum1 
    ldx vram_handle
    // vera_heap_free(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [590] vera_heap_free::s = 1 -- vbuz1=vbuc1 
    // And we free the vram heap with the vram handle that we received.
    // But before we can free the heap, we must first convert back from the sprite offset to the vram address.
    // And then to a valid vram handle :-).
    lda #1
    sta.z lib_veraheap.vera_heap_free.s
    // [591] vera_heap_free::free_index = sprite_image_cache_vram::$12 -- vbuz1=vbuxx 
    stx.z lib_veraheap.vera_heap_free.free_index
    // [592] callexecute vera_heap_free  -- call_var_near 
    jsr lib_veraheap.vera_heap_free
    // vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required)
    // [593] vera_heap_has_free::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_has_free.s
    // [594] vera_heap_has_free::size_requested = sprite_image_cache_vram::vram_size_required#0 -- vwuz1=vwum2 
    lda vram_size_required
    sta.z lib_veraheap.vera_heap_has_free.size_requested
    lda vram_size_required+1
    sta.z lib_veraheap.vera_heap_has_free.size_requested+1
    // [595] callexecute vera_heap_has_free  -- call_var_near 
    jsr lib_veraheap.vera_heap_has_free
    // vram_has_free = vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required)
    // [596] sprite_image_cache_vram::vram_has_free#1 = vera_heap_has_free::return -- vbom1=vboz2 
    lda.z lib_veraheap.vera_heap_has_free.return
    sta vram_has_free
    // lru_cache_is_max()
    // [597] callexecute lru_cache_is_max  -- call_var_near 
    jsr lib_lru_cache.lru_cache_is_max
    // lru_cache_max = lru_cache_is_max()
    // [598] sprite_image_cache_vram::lru_cache_max#1 = lru_cache_is_max::return -- vboaa=vboz1 
    lda.z lib_lru_cache.lru_cache_is_max.return
    jmp __b3
    // sprite_image_cache_vram::@5
  __b5:
    // vera_heap_index_t vram_handle = vera_heap_alloc(VERA_HEAP_SEGMENT_SPRITES, (unsigned long)sprite_cache.size[sprite_cache_index])
    // [599] vera_heap_alloc::s = 1 -- vbuz1=vbuc1 
    // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
    // Dynamic allocation of sprites in vera vram.
    lda #1
    sta.z lib_veraheap.vera_heap_alloc.s
    // [600] vera_heap_alloc::size = (unsigned long)((unsigned int *)&sprite_cache+$50)[sprite_image_cache_vram::$37] -- vduz1=_dword_pwuc1_derefidx_vbum2 
    ldy sprite_image_cache_vram__37
    lda sprite_cache+$50,y
    sta.z lib_veraheap.vera_heap_alloc.size
    iny
    lda sprite_cache+$50,y
    sta.z lib_veraheap.vera_heap_alloc.size+1
    lda #0
    sta.z lib_veraheap.vera_heap_alloc.size+2
    sta.z lib_veraheap.vera_heap_alloc.size+3
    // [601] callexecute vera_heap_alloc  -- call_var_near 
    jsr lib_veraheap.vera_heap_alloc
    // [602] sprite_image_cache_vram::vram_handle1#0 = vera_heap_alloc::return -- vbum1=vbuz2 
    lda.z lib_veraheap.vera_heap_alloc.return
    sta vram_handle1
    // BYTE0(vram_handle)
    // [603] sprite_image_cache_vram::$17 = byte0  sprite_image_cache_vram::vram_handle1#0 -- vbuxx=_byte0_vbum1 
    tax
    // vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [604] vera_heap_data_get_bank::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_data_get_bank.s
    // [605] vera_heap_data_get_bank::index = sprite_image_cache_vram::$17 -- vbuz1=vbuxx 
    stx.z lib_veraheap.vera_heap_data_get_bank.index
    // [606] callexecute vera_heap_data_get_bank  -- call_var_near 
    jsr lib_veraheap.vera_heap_data_get_bank
    // [607] sprite_image_cache_vram::vram_bank#0 = vera_heap_data_get_bank::return -- vbum1=vbuz2 
    lda.z lib_veraheap.vera_heap_data_get_bank.return
    sta vram_bank
    // BYTE0(vram_handle)
    // [608] sprite_image_cache_vram::$19 = byte0  sprite_image_cache_vram::vram_handle1#0 -- vbuxx=_byte0_vbum1 
    lda vram_handle1
    tax
    // vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [609] vera_heap_data_get_offset::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_data_get_offset.s
    // [610] vera_heap_data_get_offset::index = sprite_image_cache_vram::$19 -- vbuz1=vbuxx 
    stx.z lib_veraheap.vera_heap_data_get_offset.index
    // [611] callexecute vera_heap_data_get_offset  -- call_var_near 
    jsr lib_veraheap.vera_heap_data_get_offset
    // [612] sprite_image_cache_vram::vram_offset#0 = vera_heap_data_get_offset::return -- vwum1=vwuz2 
    lda.z lib_veraheap.vera_heap_data_get_offset.return
    sta vram_offset
    lda.z lib_veraheap.vera_heap_data_get_offset.return+1
    sta vram_offset+1
    // sprite_image_cache_vram::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [614] BRAM = sprite_image_cache_vram::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // sprite_image_cache_vram::@9
    // sprite_bram_handles_t handle_bram = sprite_bram_handles[image_index]
    // [615] sprite_image_cache_vram::$40 = sprite_bram_handles + sprite_image_cache_vram::image_index#0 -- pbuz1=pbuc1_plus_vwum2 
    lda image_index
    clc
    adc #<sprite_bram_handles
    sta.z sprite_image_cache_vram__40
    lda image_index+1
    adc #>sprite_bram_handles
    sta.z sprite_image_cache_vram__40+1
    // [616] sprite_image_cache_vram::handle_bram#0 = *sprite_image_cache_vram::$40 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (sprite_image_cache_vram__40),y
    sta handle_bram
    // sprite_image_cache_vram::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // sprite_image_cache_vram::@10
    // bram_bank_t sprite_bank = bram_heap_data_get_bank(0, handle_bram)
    // [618] bram_heap_data_get_bank::s = 0 -- vbuz1=vbuc1 
    tya
    sta.z lib_bramheap.bram_heap_data_get_bank.s
    // [619] bram_heap_data_get_bank::index = sprite_image_cache_vram::handle_bram#0 -- vbuz1=vbum2 
    lda handle_bram
    sta.z lib_bramheap.bram_heap_data_get_bank.index
    // [620] callexecute bram_heap_data_get_bank  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_bank
    // [621] sprite_image_cache_vram::sprite_bank#0 = bram_heap_data_get_bank::return -- vbum1=vbuz2 
    lda.z lib_bramheap.bram_heap_data_get_bank.return
    sta sprite_bank
    // bram_ptr_t sprite_ptr = bram_heap_data_get_offset(0, handle_bram)
    // [622] bram_heap_data_get_offset::s = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_bramheap.bram_heap_data_get_offset.s
    // [623] bram_heap_data_get_offset::index = sprite_image_cache_vram::handle_bram#0 -- vbuz1=vbum2 
    lda handle_bram
    sta.z lib_bramheap.bram_heap_data_get_offset.index
    // [624] callexecute bram_heap_data_get_offset  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_offset
    // [625] sprite_image_cache_vram::sprite_ptr#0 = bram_heap_data_get_offset::return -- pbuz1=pbuz2 
    lda.z lib_bramheap.bram_heap_data_get_offset.return
    sta.z sprite_ptr
    lda.z lib_bramheap.bram_heap_data_get_offset.return+1
    sta.z sprite_ptr+1
    // unsigned int sprite_size = sprite_cache.size[sprite_cache_index]
    // [626] sprite_image_cache_vram::sprite_size#0 = ((unsigned int *)&sprite_cache+$50)[sprite_image_cache_vram::$37] -- vwum1=pwuc1_derefidx_vbum2 
    ldy sprite_image_cache_vram__37
    lda sprite_cache+$50,y
    sta sprite_size
    lda sprite_cache+$50+1,y
    sta sprite_size+1
    // memcpy_vram_bram(vram_bank, vram_offset, sprite_bank, sprite_ptr, sprite_size)
    // [627] memcpy_vram_bram::dbank_vram#0 = sprite_image_cache_vram::vram_bank#0 -- vbuxx=vbum1 
    ldx vram_bank
    // [628] memcpy_vram_bram::doffset_vram#0 = sprite_image_cache_vram::vram_offset#0 -- vwum1=vwum2 
    lda vram_offset
    sta memcpy_vram_bram.doffset_vram
    lda vram_offset+1
    sta memcpy_vram_bram.doffset_vram+1
    // [629] memcpy_vram_bram::sbank_bram#2 = sprite_image_cache_vram::sprite_bank#0 -- vbum1=vbum2 
    lda sprite_bank
    sta memcpy_vram_bram.sbank_bram
    // [630] memcpy_vram_bram::sptr_bram#0 = sprite_image_cache_vram::sprite_ptr#0 -- pbuz1=pbuz2 
    lda.z sprite_ptr
    sta.z memcpy_vram_bram.sptr_bram
    lda.z sprite_ptr+1
    sta.z memcpy_vram_bram.sptr_bram+1
    // [631] memcpy_vram_bram::num = sprite_image_cache_vram::sprite_size#0 -- vwum1=vwum2 
    lda sprite_size
    sta memcpy_vram_bram.num
    lda sprite_size+1
    sta memcpy_vram_bram.num+1
    // [632] call memcpy_vram_bram
    // [850] phi from sprite_image_cache_vram::@10 to memcpy_vram_bram [phi:sprite_image_cache_vram::@10->memcpy_vram_bram]
    jsr memcpy_vram_bram
    // sprite_image_cache_vram::vera_sprite_get_image_offset1
    // vera_sprite_image_offset sprite_image_offset = offset >> 5
    // [633] sprite_image_cache_vram::vera_sprite_get_image_offset1_sprite_image_offset#0 = sprite_image_cache_vram::vram_offset#0 >> 5 -- vwum1=vwum2_ror_5 
    lda vram_offset+1
    lsr
    sta vera_sprite_get_image_offset1_sprite_image_offset+1
    lda vram_offset
    ror
    sta vera_sprite_get_image_offset1_sprite_image_offset
    lsr vera_sprite_get_image_offset1_sprite_image_offset+1
    ror vera_sprite_get_image_offset1_sprite_image_offset
    lsr vera_sprite_get_image_offset1_sprite_image_offset+1
    ror vera_sprite_get_image_offset1_sprite_image_offset
    lsr vera_sprite_get_image_offset1_sprite_image_offset+1
    ror vera_sprite_get_image_offset1_sprite_image_offset
    lsr vera_sprite_get_image_offset1_sprite_image_offset+1
    ror vera_sprite_get_image_offset1_sprite_image_offset
    // (unsigned int)bank << 11
    // [634] sprite_image_cache_vram::vera_sprite_get_image_offset1_$2 = (unsigned int)sprite_image_cache_vram::vram_bank#0 -- vwum1=_word_vbum2 
    lda vram_bank
    sta vera_sprite_get_image_offset1_sprite_image_cache_vram__2
    lda #0
    sta vera_sprite_get_image_offset1_sprite_image_cache_vram__2+1
    // [635] sprite_image_cache_vram::vera_sprite_get_image_offset1_$1 = sprite_image_cache_vram::vera_sprite_get_image_offset1_$2 << $b -- vwum1=vwum1_rol_vbuc1 
    ldy #$b
    cpy #0
    beq !e+
  !:
    asl vera_sprite_get_image_offset1_sprite_image_cache_vram__1
    rol vera_sprite_get_image_offset1_sprite_image_cache_vram__1+1
    dey
    bne !-
  !e:
    // sprite_image_offset |= ((unsigned int)bank << 11)
    // [636] sprite_image_cache_vram::vera_sprite_get_image_offset1_return#0 = sprite_image_cache_vram::vera_sprite_get_image_offset1_sprite_image_offset#0 | sprite_image_cache_vram::vera_sprite_get_image_offset1_$1 -- vwum1=vwum2_bor_vwum3 
    lda vera_sprite_get_image_offset1_sprite_image_offset
    ora vera_sprite_get_image_offset1_sprite_image_cache_vram__1
    sta vera_sprite_get_image_offset1_return
    lda vera_sprite_get_image_offset1_sprite_image_offset+1
    ora vera_sprite_get_image_offset1_sprite_image_cache_vram__1+1
    sta vera_sprite_get_image_offset1_return+1
    // sprite_image_cache_vram::@11
    // vera_heap_set_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle, sprite_offset)
    // [637] vera_heap_set_image::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_set_image.s
    // [638] vera_heap_set_image::index = sprite_image_cache_vram::vram_handle1#0 -- vbuz1=vbum2 
    lda vram_handle1
    sta.z lib_veraheap.vera_heap_set_image.index
    // [639] vera_heap_set_image::image = sprite_image_cache_vram::vera_sprite_get_image_offset1_return#0 -- vwuz1=vwum2 
    lda vera_sprite_get_image_offset1_return
    sta.z lib_veraheap.vera_heap_set_image.image
    lda vera_sprite_get_image_offset1_return+1
    sta.z lib_veraheap.vera_heap_set_image.image+1
    // [640] callexecute vera_heap_set_image  -- call_var_near 
    jsr lib_veraheap.vera_heap_set_image
    // lru_cache_insert(image_index, (lru_cache_data_t)vram_handle)
    // [641] lru_cache_insert::key = sprite_image_cache_vram::image_index#0 -- vwuz1=vwum2 
    lda image_index
    sta.z lib_lru_cache.lru_cache_insert.key
    lda image_index+1
    sta.z lib_lru_cache.lru_cache_insert.key+1
    // [642] lru_cache_insert::data = (unsigned int)sprite_image_cache_vram::vram_handle1#0 -- vwuz1=_word_vbum2 
    lda vram_handle1
    sta.z lib_lru_cache.lru_cache_insert.data
    lda #0
    sta.z lib_lru_cache.lru_cache_insert.data+1
    // [643] callexecute lru_cache_insert  -- call_var_near 
    jsr lib_lru_cache.lru_cache_insert
    // sprite_image_cache_vram::vera_display_set_border_color2
    // *VERA_CTRL &= 0b10000001
    // [644] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [645] *VERA_DC_BORDER = BLACK -- _deref_pbuc1=vbuc2 
    lda #BLACK
    sta VERA_DC_BORDER
    // [646] phi from sprite_image_cache_vram::@1 sprite_image_cache_vram::vera_display_set_border_color2 to sprite_image_cache_vram::@2 [phi:sprite_image_cache_vram::@1/sprite_image_cache_vram::vera_display_set_border_color2->sprite_image_cache_vram::@2]
    // [646] phi sprite_image_cache_vram::return#0 = sprite_image_cache_vram::sprite_offset#1 [phi:sprite_image_cache_vram::@1/sprite_image_cache_vram::vera_display_set_border_color2->sprite_image_cache_vram::@2#0] -- register_copy 
    // sprite_image_cache_vram::@2
    // sprite_image_cache_vram::@return
    // }
    // [647] return 
    rts
    // sprite_image_cache_vram::@1
  __b1:
    // lru_cache_get(vram_index)
    // [648] lru_cache_get::index = sprite_image_cache_vram::vram_index#0 -- vbuz1=vbuaa 
    sta.z lib_lru_cache.lru_cache_get.index
    // [649] callexecute lru_cache_get  -- call_var_near 
    jsr lib_lru_cache.lru_cache_get
    // [650] sprite_image_cache_vram::$30 = lru_cache_get::return -- vwum1=vwuz2 
    lda.z lib_lru_cache.lru_cache_get.return
    sta sprite_image_cache_vram__30
    lda.z lib_lru_cache.lru_cache_get.return+1
    sta sprite_image_cache_vram__30+1
    // vera_heap_index_t vram_handle = (vera_heap_index_t)lru_cache_get(vram_index)
    // [651] sprite_image_cache_vram::vram_handle2#0 = (char)sprite_image_cache_vram::$30 -- vbum1=_byte_vwum2 
    // So we have a cache hit, so we can re-use the same image from the cache and we win time!
    lda sprite_image_cache_vram__30
    sta vram_handle2
    // BYTE0(vram_handle)
    // [652] sprite_image_cache_vram::$31 = byte0  sprite_image_cache_vram::vram_handle2#0 -- vbuxx=_byte0_vbum1 
    tax
    // vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [653] vera_heap_data_get_bank::s = 1 -- vbuz1=vbuc1 
    // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
    // Dynamic allocation of sprites in vera vram.
    lda #1
    sta.z lib_veraheap.vera_heap_data_get_bank.s
    // [654] vera_heap_data_get_bank::index = sprite_image_cache_vram::$31 -- vbuz1=vbuxx 
    stx.z lib_veraheap.vera_heap_data_get_bank.index
    // [655] callexecute vera_heap_data_get_bank  -- call_var_near 
    jsr lib_veraheap.vera_heap_data_get_bank
    // BYTE0(vram_handle)
    // [656] sprite_image_cache_vram::$33 = byte0  sprite_image_cache_vram::vram_handle2#0 -- vbuxx=_byte0_vbum1 
    lda vram_handle2
    tax
    // vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [657] vera_heap_data_get_offset::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_data_get_offset.s
    // [658] vera_heap_data_get_offset::index = sprite_image_cache_vram::$33 -- vbuz1=vbuxx 
    stx.z lib_veraheap.vera_heap_data_get_offset.index
    // [659] callexecute vera_heap_data_get_offset  -- call_var_near 
    jsr lib_veraheap.vera_heap_data_get_offset
    // vera_heap_get_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle)
    // [660] vera_heap_get_image::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_get_image.s
    // [661] vera_heap_get_image::index = sprite_image_cache_vram::vram_handle2#0 -- vbuz1=vbum2 
    lda vram_handle2
    sta.z lib_veraheap.vera_heap_get_image.index
    // [662] callexecute vera_heap_get_image  -- call_var_near 
    jsr lib_veraheap.vera_heap_get_image
    // sprite_offset = vera_heap_get_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle)
    // [663] sprite_image_cache_vram::sprite_offset#1 = vera_heap_get_image::return -- vwum1=vwuz2 
    lda.z lib_veraheap.vera_heap_get_image.return
    sta sprite_offset
    lda.z lib_veraheap.vera_heap_get_image.return+1
    sta sprite_offset+1
    rts
  .segment DataEngineFlight
    .label sprite_image_cache_vram__30 = return
    .label sprite_image_cache_vram__37 = flight_draw.s
  .segment Data
    .label vera_sprite_get_image_offset1_sprite_image_cache_vram__1 = vera_sprite_get_image_offset1_sprite_image_cache_vram__2
    vera_sprite_get_image_offset1_sprite_image_cache_vram__2: .word 0
  .segment DataEngineFlight
    image_index: .word 0
    .label vram_handle2 = handle_bram
    // lru_cache_data_t lru_cache_data;
    .label sprite_offset = return
    .label vram_size_required = return
    vram_has_free: .byte 0
    vram_last: .word 0
    .label vram_handle = vram_last
    .label vram_handle1 = vram_has_free
    vram_bank: .byte 0
    .label vram_offset = return
    handle_bram: .byte 0
    sprite_bank: .byte 0
    .label sprite_size = vram_last
  .segment Data
    .label vera_sprite_get_image_offset1_sprite_image_offset = memcpy_vram_bram.doffset_vram
    .label vera_sprite_get_image_offset1_return = return
  .segment DataEngineFlight
    return: .word 0
}
.segment Code
  // screenlayer
// --- layer management in VERA ---
// void screenlayer(char layer, __register(X) char mapbase, __mem() char config)
screenlayer: {
    // __mem char vera_dc_hscale_temp = *VERA_DC_HSCALE
    // [664] screenlayer::vera_dc_hscale_temp#0 = *VERA_DC_HSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_HSCALE
    sta vera_dc_hscale_temp
    // __mem char vera_dc_vscale_temp = *VERA_DC_VSCALE
    // [665] screenlayer::vera_dc_vscale_temp#0 = *VERA_DC_VSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_VSCALE
    sta vera_dc_vscale_temp
    // __conio.layer = 0
    // [666] *((char *)&__conio+2) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+2
    // mapbase >> 7
    // [667] screenlayer::$0 = screenlayer::mapbase#0 >> 7 -- vbuaa=vbuxx_ror_7 
    txa
    rol
    rol
    and #1
    // __conio.mapbase_bank = mapbase >> 7
    // [668] *((char *)&__conio+5) = screenlayer::$0 -- _deref_pbuc1=vbuaa 
    sta __conio+5
    // (mapbase)<<1
    // [669] screenlayer::$1 = screenlayer::mapbase#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // MAKEWORD((mapbase)<<1,0)
    // [670] screenlayer::$2 = screenlayer::$1 w= 0 -- vwum1=vbuaa_word_vbuc1 
    ldy #0
    sta screenlayer__2+1
    sty screenlayer__2
    // __conio.mapbase_offset = MAKEWORD((mapbase)<<1,0)
    // [671] *((unsigned int *)&__conio+3) = screenlayer::$2 -- _deref_pwuc1=vwum1 
    tya
    sta __conio+3
    lda screenlayer__2+1
    sta __conio+3+1
    // config & VERA_LAYER_WIDTH_MASK
    // [672] screenlayer::$7 = screenlayer::config#0 & VERA_LAYER_WIDTH_MASK -- vbuaa=vbum1_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    and config
    // (config & VERA_LAYER_WIDTH_MASK) >> 4
    // [673] screenlayer::$8 = screenlayer::$7 >> 4 -- vbuxx=vbuaa_ror_4 
    lsr
    lsr
    lsr
    lsr
    tax
    // __conio.mapwidth = VERA_LAYER_DIM[ (config & VERA_LAYER_WIDTH_MASK) >> 4]
    // [674] *((char *)&__conio+8) = screenlayer::VERA_LAYER_DIM[screenlayer::$8] -- _deref_pbuc1=pbuc2_derefidx_vbuxx 
    lda VERA_LAYER_DIM,x
    sta __conio+8
    // config & VERA_LAYER_HEIGHT_MASK
    // [675] screenlayer::$5 = screenlayer::config#0 & VERA_LAYER_HEIGHT_MASK -- vbuaa=vbum1_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    and config
    // (config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [676] screenlayer::$6 = screenlayer::$5 >> 6 -- vbuaa=vbuaa_ror_6 
    rol
    rol
    rol
    and #3
    // __conio.mapheight = VERA_LAYER_DIM[ (config & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [677] *((char *)&__conio+9) = screenlayer::VERA_LAYER_DIM[screenlayer::$6] -- _deref_pbuc1=pbuc2_derefidx_vbuaa 
    tay
    lda VERA_LAYER_DIM,y
    sta __conio+9
    // __conio.rowskip = VERA_LAYER_SKIP[(config & VERA_LAYER_WIDTH_MASK)>>4]
    // [678] screenlayer::$16 = screenlayer::$8 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [679] *((unsigned int *)&__conio+$a) = screenlayer::VERA_LAYER_SKIP[screenlayer::$16] -- _deref_pwuc1=pwuc2_derefidx_vbuaa 
    // __conio.rowshift = ((config & VERA_LAYER_WIDTH_MASK)>>4)+6;
    tay
    lda VERA_LAYER_SKIP,y
    sta __conio+$a
    lda VERA_LAYER_SKIP+1,y
    sta __conio+$a+1
    // vera_dc_hscale_temp == 0x80
    // [680] screenlayer::$9 = screenlayer::vera_dc_hscale_temp#0 == $80 -- vboaa=vbum1_eq_vbuc1 
    lda vera_dc_hscale_temp
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // 40 << (char)(vera_dc_hscale_temp == 0x80)
    // [681] screenlayer::$18 = (char)screenlayer::$9 -- vbuxx=vbuaa 
    tax
    // [682] screenlayer::$10 = $28 << screenlayer::$18 -- vbuaa=vbuc1_rol_vbuxx 
    lda #$28
    cpx #0
    beq !e+
  !:
    asl
    dex
    bne !-
  !e:
    // (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [683] screenlayer::$11 = screenlayer::$10 - 1 -- vbuaa=vbuaa_minus_1 
    sec
    sbc #1
    // __conio.width = (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [684] *((char *)&__conio+6) = screenlayer::$11 -- _deref_pbuc1=vbuaa 
    sta __conio+6
    // vera_dc_vscale_temp == 0x80
    // [685] screenlayer::$12 = screenlayer::vera_dc_vscale_temp#0 == $80 -- vboaa=vbum1_eq_vbuc1 
    lda vera_dc_vscale_temp
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    // 30 << (char)(vera_dc_vscale_temp == 0x80)
    // [686] screenlayer::$19 = (char)screenlayer::$12 -- vbuxx=vbuaa 
    tax
    // [687] screenlayer::$13 = $1e << screenlayer::$19 -- vbuaa=vbuc1_rol_vbuxx 
    lda #$1e
    cpx #0
    beq !e+
  !:
    asl
    dex
    bne !-
  !e:
    // (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [688] screenlayer::$14 = screenlayer::$13 - 1 -- vbuaa=vbuaa_minus_1 
    sec
    sbc #1
    // __conio.height = (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [689] *((char *)&__conio+7) = screenlayer::$14 -- _deref_pbuc1=vbuaa 
    sta __conio+7
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [690] screenlayer::mapbase_offset#0 = *((unsigned int *)&__conio+3) -- vwum1=_deref_pwuc1 
    lda __conio+3
    sta mapbase_offset
    lda __conio+3+1
    sta mapbase_offset+1
    // [691] phi from screenlayer to screenlayer::@1 [phi:screenlayer->screenlayer::@1]
    // [691] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#0 [phi:screenlayer->screenlayer::@1#0] -- register_copy 
    // [691] phi screenlayer::y#2 = 0 [phi:screenlayer->screenlayer::@1#1] -- vbuxx=vbuc1 
    ldx #0
    // screenlayer::@1
  __b1:
    // for(register char y=0; y<=__conio.height; y++)
    // [692] if(screenlayer::y#2<=*((char *)&__conio+7)) goto screenlayer::@2 -- vbuxx_le__deref_pbuc1_then_la1 
    lda __conio+7
    stx.z $ff
    cmp.z $ff
    bcs __b2
    // screenlayer::@return
    // }
    // [693] return 
    rts
    // screenlayer::@2
  __b2:
    // __conio.offsets[y] = mapbase_offset
    // [694] screenlayer::$17 = screenlayer::y#2 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [695] ((unsigned int *)&__conio+$15)[screenlayer::$17] = screenlayer::mapbase_offset#2 -- pwuc1_derefidx_vbuaa=vwum1 
    tay
    lda mapbase_offset
    sta __conio+$15,y
    lda mapbase_offset+1
    sta __conio+$15+1,y
    // mapbase_offset += __conio.rowskip
    // [696] screenlayer::mapbase_offset#1 = screenlayer::mapbase_offset#2 + *((unsigned int *)&__conio+$a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda mapbase_offset
    adc __conio+$a
    sta mapbase_offset
    lda mapbase_offset+1
    adc __conio+$a+1
    sta mapbase_offset+1
    // for(register char y=0; y<=__conio.height; y++)
    // [697] screenlayer::y#1 = ++ screenlayer::y#2 -- vbuxx=_inc_vbuxx 
    inx
    // [691] phi from screenlayer::@2 to screenlayer::@1 [phi:screenlayer::@2->screenlayer::@1]
    // [691] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#1 [phi:screenlayer::@2->screenlayer::@1#0] -- register_copy 
    // [691] phi screenlayer::y#2 = screenlayer::y#1 [phi:screenlayer::@2->screenlayer::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    VERA_LAYER_DIM: .byte $1f, $3f, $7f, $ff
    VERA_LAYER_SKIP: .word $40, $80, $100, $200
    .label screenlayer__2 = mapbase_offset
    config: .byte 0
    vera_dc_hscale_temp: .byte 0
    vera_dc_vscale_temp: .byte 0
    mapbase_offset: .word 0
}
.segment Code
  // cx16_brk_relay
// void cx16_brk_relay(void (*brk)())
cx16_brk_relay: {
    .label brk = cx16_brk_debugger
    // *KERNEL_BRK = brk
    // [698] *KERNEL_BRK = cx16_brk_relay::brk#0 -- _deref_qprc1=pprc2 
    lda #<brk
    sta KERNEL_BRK
    lda #>brk
    sta KERNEL_BRK+1
    // cx16_brk_relay::@return
    // }
    // [699] return 
    rts
}
  // vera_layer1_mode_tile
// void vera_layer1_mode_tile(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char bpp)
vera_layer1_mode_tile: {
    .const mapbase_bank = 1
    .const mapbase_offset = $b000
    .const tilebase_bank = 1
    .const tilebase_offset = $f000
    // vera_layer1_mode_tile::vera_layer1_set_color_depth1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_COLOR_DEPTH_MASK
    // [701] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_COLOR_DEPTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= bpp
    // [702] *VERA_L1_CONFIG = *VERA_L1_CONFIG -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_width1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_WIDTH_MASK
    // [703] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= mapwidth
    // [704] *VERA_L1_CONFIG = *VERA_L1_CONFIG | VERA_LAYER_WIDTH_128 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_WIDTH_128
    ora VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_height1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_HEIGHT_MASK
    // [705] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= mapheight
    // [706] *VERA_L1_CONFIG = *VERA_L1_CONFIG | VERA_LAYER_HEIGHT_64 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_HEIGHT_64
    ora VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_mapbase1
    // *VERA_L1_MAPBASE = (mapbase_bank<<7) | (BYTE1(mapbase_offset)>>1)
    // [707] *VERA_L1_MAPBASE = vera_layer1_mode_tile::mapbase_bank#0<<7|byte1 vera_layer1_mode_tile::mapbase_offset#0>>1 -- _deref_pbuc1=vbuc2 
    lda #mapbase_bank<<7|(>mapbase_offset)>>1
    sta VERA_L1_MAPBASE
    // vera_layer1_mode_tile::vera_layer1_set_tilebase1
    // *VERA_L1_TILEBASE &= ~VERA_LAYER_TILEBASE_MASK
    // [708] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_LAYER_TILEBASE_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_TILEBASE_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= ((tilebase_bank << 7) | BYTE1(tilebase_offset)>>1)
    // [709] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE | vera_layer1_mode_tile::tilebase_bank#0<<7|byte1 vera_layer1_mode_tile::tilebase_offset#0>>1 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #tilebase_bank<<7|(>tilebase_offset)>>1
    ora VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::vera_layer1_set_tile_width1
    // *VERA_L1_TILEBASE &= ~VERA_TILEBASE_WIDTH_MASK
    // [710] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_TILEBASE_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_WIDTH_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= tilewidth
    // [711] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::vera_layer1_set_tile_height1
    // *VERA_L1_TILEBASE &= ~VERA_TILEBASE_HEIGHT_MASK
    // [712] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_TILEBASE_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_HEIGHT_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= tileheight
    // [713] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::@return
    // }
    // [714] return 
    rts
}
  // fload_bram
/**
 * @brief Load a file to banked ram located between address 0xA000 and 0xBFFF incrementing the banks.
 *
 * @param channel Input channel.
 * @param device Input device.
 * @param secondary Secondary channel.
 * @param filename Name of the file to be loaded.
 * @param bank The bank in banked ram to where the data of the file needs to be loaded.
 * @param sptr The pointer between 0xA000 and 0xBFFF in banked ram.
 * @return bram_ptr_t
 *  - 0x0000: Something is wrong! Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
 *  - other: OK! The last pointer between 0xA000 and 0xBFFF is returned. Note that the last pointer is indicating the first free byte.
 */
// unsigned int fload_bram(__zp($22) char *filename, __register(X) char dbank, char *dptr)
fload_bram: {
    .label fp = $3d
    .label filename = $22
    // fload_bram::bank_get_bram1
    // return BRAM;
    // [716] fload_bram::bank_set_bram2_bank#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_set_bram2_bank
    // fload_bram::bank_set_bram1
    // BRAM = bank
    // [717] BRAM = fload_bram::dbank#5 -- vbuz1=vbuxx 
    stx.z BRAM
    // fload_bram::@4
    // FILE* fp = fopen(filename,"r")
    // [718] fopen::path#2 = fload_bram::filename#10
    // [719] call fopen
    // [897] phi from fload_bram::@4 to fopen [phi:fload_bram::@4->fopen]
    // [897] phi __errno#201 = __errno#101 [phi:fload_bram::@4->fopen#0] -- register_copy 
    // [897] phi fopen::pathtoken#0 = fopen::path#2 [phi:fload_bram::@4->fopen#1] -- register_copy 
    jsr fopen
    // FILE* fp = fopen(filename,"r")
    // [720] fopen::return#3 = fopen::return#2
    // fload_bram::@5
    // [721] fload_bram::fp#0 = fopen::return#3
    // if(fp)
    // [722] if((struct $2 *)0==fload_bram::fp#0) goto fload_bram::bank_set_bram2 -- pssc1_eq_pssz1_then_la1 
    lda.z fp
    cmp #<0
    bne !+
    lda.z fp+1
    cmp #>0
    beq bank_set_bram2
  !:
    // fload_bram::@1
    // fgets(dptr, 0, fp)
    // [723] fgets::stream#0 = fload_bram::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fgets.stream
    lda.z fp+1
    sta.z fgets.stream+1
    // [724] call fgets
    // [978] phi from fload_bram::@1 to fgets [phi:fload_bram::@1->fgets]
    // [978] phi fgets::ptr#14 = (char *) 40960 [phi:fload_bram::@1->fgets#0] -- pbuz1=pbuc1 
    lda #<$a000
    sta.z fgets.ptr
    lda #>$a000
    sta.z fgets.ptr+1
    // [978] phi fgets::size#10 = 0 [phi:fload_bram::@1->fgets#1] -- vwum1=vbuc1 
    lda #<0
    sta fgets.size
    sta fgets.size+1
    // [978] phi fgets::stream#4 = fgets::stream#0 [phi:fload_bram::@1->fgets#2] -- register_copy 
    jsr fgets
    // fgets(dptr, 0, fp)
    // [725] fgets::return#10 = fgets::return#1
    // fload_bram::@6
    // read = fgets(dptr, 0, fp)
    // [726] fload_bram::read#1 = fgets::return#10
    // if(read)
    // [727] if(0!=fload_bram::read#1) goto fload_bram::@3 -- 0_neq_vwum1_then_la1 
    lda read
    ora read+1
    bne __b3
    // fload_bram::@2
    // fclose(fp)
    // [728] fclose::stream#1 = fload_bram::fp#0
    // [729] call fclose
    // [1032] phi from fload_bram::@2 to fclose [phi:fload_bram::@2->fclose]
    // [1032] phi fclose::stream#3 = fclose::stream#1 [phi:fload_bram::@2->fclose#0] -- register_copy 
    jsr fclose
    // fload_bram::bank_set_bram2
  bank_set_bram2:
    // BRAM = bank
    // [730] BRAM = fload_bram::bank_set_bram2_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram2_bank
    sta.z BRAM
    // fload_bram::@return
    // }
    // [731] return 
    rts
    // fload_bram::@3
  __b3:
    // fclose(fp)
    // [732] fclose::stream#0 = fload_bram::fp#0
    // [733] call fclose
    // [1032] phi from fload_bram::@3 to fclose [phi:fload_bram::@3->fclose]
    // [1032] phi fclose::stream#3 = fclose::stream#0 [phi:fload_bram::@3->fclose#0] -- register_copy 
    jsr fclose
    jmp bank_set_bram2
  .segment Data
    bank_set_bram2_bank: .byte 0
    .label read = fgets.read
}
.segment CodeEngineFlight
  // flight_init
// void flight_init()
flight_init: {
    .const memset_fast1_c = $ff
    .const memset_fast2_c = 0
    .const memset_fast3_c = 0
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast1_destination = sprite_cache+$10
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast2_destination = flight+$ac1
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast3_destination = flight+$acb
    // [735] phi from flight_init to flight_init::memset_fast1 [phi:flight_init->flight_init::memset_fast1]
    // flight_init::memset_fast1
    // [736] phi from flight_init::memset_fast1 to flight_init::memset_fast1_@1 [phi:flight_init::memset_fast1->flight_init::memset_fast1_@1]
    // [736] phi flight_init::memset_fast1_num#2 = $10 [phi:flight_init::memset_fast1->flight_init::memset_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #$10
    // [736] phi from flight_init::memset_fast1_@1 to flight_init::memset_fast1_@1 [phi:flight_init::memset_fast1_@1->flight_init::memset_fast1_@1]
    // [736] phi flight_init::memset_fast1_num#2 = flight_init::memset_fast1_num#1 [phi:flight_init::memset_fast1_@1->flight_init::memset_fast1_@1#0] -- register_copy 
    // flight_init::memset_fast1_@1
  memset_fast1___b1:
    // *(destination+num) = c
    // [737] flight_init::memset_fast1_destination#0[flight_init::memset_fast1_num#2] = flight_init::memset_fast1_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast1_c
    sta memset_fast1_destination,x
    // num--;
    // [738] flight_init::memset_fast1_num#1 = -- flight_init::memset_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [739] if(0!=flight_init::memset_fast1_num#1) goto flight_init::memset_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast1___b1
    // flight_init::@1
    // flight_sprite_offset_pool = 1
    // [740] flight_sprite_offset_pool = 1 -- vbum1=vbuc1 
    lda #1
    sta flight_sprite_offset_pool
    // [741] phi from flight_init::@1 to flight_init::memset_fast2 [phi:flight_init::@1->flight_init::memset_fast2]
    // flight_init::memset_fast2
    // [742] phi from flight_init::memset_fast2 to flight_init::memset_fast2_@1 [phi:flight_init::memset_fast2->flight_init::memset_fast2_@1]
    // [742] phi flight_init::memset_fast2_num#2 = $a [phi:flight_init::memset_fast2->flight_init::memset_fast2_@1#0] -- vbuxx=vbuc1 
    ldx #$a
    // [742] phi from flight_init::memset_fast2_@1 to flight_init::memset_fast2_@1 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast2_@1]
    // [742] phi flight_init::memset_fast2_num#2 = flight_init::memset_fast2_num#1 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast2_@1#0] -- register_copy 
    // flight_init::memset_fast2_@1
  memset_fast2___b1:
    // *(destination+num) = c
    // [743] flight_init::memset_fast2_destination#0[flight_init::memset_fast2_num#2] = flight_init::memset_fast2_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast2_c
    sta memset_fast2_destination,x
    // num--;
    // [744] flight_init::memset_fast2_num#1 = -- flight_init::memset_fast2_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [745] if(0!=flight_init::memset_fast2_num#1) goto flight_init::memset_fast2_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast2___b1
    // [746] phi from flight_init::memset_fast2_@1 to flight_init::memset_fast3 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast3]
    // flight_init::memset_fast3
    // [747] phi from flight_init::memset_fast3 to flight_init::memset_fast3_@1 [phi:flight_init::memset_fast3->flight_init::memset_fast3_@1]
    // [747] phi flight_init::memset_fast3_num#2 = $a [phi:flight_init::memset_fast3->flight_init::memset_fast3_@1#0] -- vbuxx=vbuc1 
    ldx #$a
    // [747] phi from flight_init::memset_fast3_@1 to flight_init::memset_fast3_@1 [phi:flight_init::memset_fast3_@1->flight_init::memset_fast3_@1]
    // [747] phi flight_init::memset_fast3_num#2 = flight_init::memset_fast3_num#1 [phi:flight_init::memset_fast3_@1->flight_init::memset_fast3_@1#0] -- register_copy 
    // flight_init::memset_fast3_@1
  memset_fast3___b1:
    // *(destination+num) = c
    // [748] flight_init::memset_fast3_destination#0[flight_init::memset_fast3_num#2] = flight_init::memset_fast3_c#0 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #memset_fast3_c
    sta memset_fast3_destination,x
    // num--;
    // [749] flight_init::memset_fast3_num#1 = -- flight_init::memset_fast3_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [750] if(0!=flight_init::memset_fast3_num#1) goto flight_init::memset_fast3_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast3___b1
    // flight_init::@return
    // }
    // [751] return 
    rts
}
.segment Code
  // memset
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .label end = stage+$38
    .label dst = $22
    // [753] phi from memset to memset::@1 [phi:memset->memset::@1]
    // [753] phi memset::dst#2 = (char *)(void *)&stage [phi:memset->memset::@1#0] -- pbuz1=pbuc1 
    lda #<stage
    sta.z dst
    lda #>stage
    sta.z dst+1
    // memset::@1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    // [754] if(memset::dst#2!=memset::end#0) goto memset::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // memset::@return
    // }
    // [755] return 
    rts
    // memset::@2
  __b2:
    // *dst = c
    // [756] *memset::dst#2 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    // [757] memset::dst#1 = ++ memset::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [753] phi from memset::@2 to memset::@1 [phi:memset::@2->memset::@1]
    // [753] phi memset::dst#2 = memset::dst#1 [phi:memset::@2->memset::@1#0] -- register_copy 
    jmp __b1
}
  // memcpy
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(void *destination, __zp($26) volatile struct $46 *source, unsigned int num)
memcpy: {
    .const num = $a
    .label destination = stage
    .label src_end = $22
    .label dst = $3d
    .label src = $26
    .label source = $26
    // char* src_end = (char*)source+num
    // [758] memcpy::src_end#0 = (char *)(void *)memcpy::source#0 + memcpy::num#0 -- pbuz1=pbuz2_plus_vwuc1 
    lda.z source
    clc
    adc #<num
    sta.z src_end
    lda.z source+1
    adc #>num
    sta.z src_end+1
    // [759] memcpy::src#4 = (char *)(void *)memcpy::source#0
    // [760] phi from memcpy to memcpy::@1 [phi:memcpy->memcpy::@1]
    // [760] phi memcpy::dst#2 = (char *)memcpy::destination#0 [phi:memcpy->memcpy::@1#0] -- pbuz1=pbuc1 
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    // [760] phi memcpy::src#2 = memcpy::src#4 [phi:memcpy->memcpy::@1#1] -- register_copy 
    // memcpy::@1
  __b1:
    // while(src!=src_end)
    // [761] if(memcpy::src#2!=memcpy::src_end#0) goto memcpy::@2 -- pbuz1_neq_pbuz2_then_la1 
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
    bne __b2
    // memcpy::@return
    // }
    // [762] return 
    rts
    // memcpy::@2
  __b2:
    // *dst++ = *src++
    // [763] *memcpy::dst#2 = *memcpy::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [764] memcpy::dst#1 = ++ memcpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [765] memcpy::src#1 = ++ memcpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [760] phi from memcpy::@2 to memcpy::@1 [phi:memcpy::@2->memcpy::@1]
    // [760] phi memcpy::dst#2 = memcpy::dst#1 [phi:memcpy::@2->memcpy::@1#0] -- register_copy 
    // [760] phi memcpy::src#2 = memcpy::src#1 [phi:memcpy::@2->memcpy::@1#1] -- register_copy 
    jmp __b1
}
.segment CodeEngineStages
  // stage_load
// void stage_load()
// __bank(cx16_ram, 3) 
stage_load: {
    .label stage_playbooks_b = $53
    .label stage_playbook_b = $53
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [766] stage_load::stage_playbooks_b#0 = *((struct $46 **)(struct $47 *)&stage+$15+1) -- pssz1=_deref_qssc1 
    lda stage+$15+1
    sta.z stage_playbooks_b
    lda stage+$15+1+1
    sta.z stage_playbooks_b+1
    // stage_playbook_t* stage_playbook_b = &stage_playbooks_b[stage.playbook_current]
    // [767] stage_load::$9 = *((unsigned int *)&stage+$1a) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+$1a
    asl
    sta stage_load__9
    lda stage+$1a+1
    rol
    sta stage_load__9+1
    asl stage_load__9
    rol stage_load__9+1
    // [768] stage_load::$10 = stage_load::$9 + *((unsigned int *)&stage+$1a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_load__10
    adc stage+$1a
    sta stage_load__10
    lda stage_load__10+1
    adc stage+$1a+1
    sta stage_load__10+1
    // [769] stage_load::$2 = stage_load::$10 << 1 -- vwum1=vwum1_rol_1 
    asl stage_load__2
    rol stage_load__2+1
    // [770] stage_load::stage_playbook_b#0 = stage_load::stage_playbooks_b#0 + stage_load::$2 -- pssz1=pssz1_plus_vwum2 
    clc
    lda.z stage_playbook_b
    adc stage_load__2
    sta.z stage_playbook_b
    lda.z stage_playbook_b+1
    adc stage_load__2+1
    sta.z stage_playbook_b+1
    // stage_load_player(stage_playbook_b->stage_player)
    // [771] stage_load_player::stage_player#0 = ((struct $35 **)stage_load::stage_playbook_b#0)[3] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #3
    lda (stage_playbook_b),y
    sta.z stage_load_player.stage_player
    iny
    lda (stage_playbook_b),y
    sta.z stage_load_player.stage_player+1
    // [772] call stage_load_player
    jsr stage_load_player
    // stage_load::@return
    // }
    // [773] return 
    rts
  .segment DataEngineStages
    .label stage_load__2 = stage_logic.new_scenario
    .label stage_load__9 = stage_logic.new_scenario
    .label stage_load__10 = stage_logic.new_scenario
}
.segment CodeEngineStages
  // stage_copy
// void stage_copy(__mem() char ew, __mem() unsigned int scenario)
// __bank(cx16_ram, 3) 
stage_copy: {
    .label stage_playbook_ptr1_stage_playbooks_b = $53
    .label stage_playbook_ptr1_return = $22
    .label stage_scenario_ptr1_stage_scenarios_b = $53
    .label stage_scenario_ptr1_return = $31
    .label stage_enemy = $53
    // stage_copy::stage_playbook_ptr1
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [775] stage_copy::stage_playbook_ptr1_stage_playbooks_b#0 = *((struct $46 **)(struct $47 *)&stage+$15+1) -- pssz1=_deref_qssc1 
    lda stage+$15+1
    sta.z stage_playbook_ptr1_stage_playbooks_b
    lda stage+$15+1+1
    sta.z stage_playbook_ptr1_stage_playbooks_b+1
    // &stage_playbooks_b[stage.playbook_current]
    // [776] stage_copy::$34 = *((unsigned int *)&stage+$1a) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+$1a
    asl
    sta stage_copy__34
    lda stage+$1a+1
    rol
    sta stage_copy__34+1
    asl stage_copy__34
    rol stage_copy__34+1
    // [777] stage_copy::$35 = stage_copy::$34 + *((unsigned int *)&stage+$1a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_copy__35
    adc stage+$1a
    sta stage_copy__35
    lda stage_copy__35+1
    adc stage+$1a+1
    sta stage_copy__35+1
    // [778] stage_copy::stage_playbook_ptr1_$1 = stage_copy::$35 << 1 -- vwum1=vwum1_rol_1 
    asl stage_playbook_ptr1_stage_copy__1
    rol stage_playbook_ptr1_stage_copy__1+1
    // [779] stage_copy::stage_playbook_ptr1_return#0 = stage_copy::stage_playbook_ptr1_stage_playbooks_b#0 + stage_copy::stage_playbook_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_playbook_ptr1_stage_copy__1
    clc
    adc.z stage_playbook_ptr1_stage_playbooks_b
    sta.z stage_playbook_ptr1_return
    lda stage_playbook_ptr1_stage_copy__1+1
    adc.z stage_playbook_ptr1_stage_playbooks_b+1
    sta.z stage_playbook_ptr1_return+1
    // stage_copy::stage_scenario_ptr1
    // stage_scenario_t* stage_scenarios_b = stage_playbook_ptr_b->scenarios_b
    // [780] stage_copy::stage_scenario_ptr1_stage_scenarios_b#0 = ((struct $42 **)stage_copy::stage_playbook_ptr1_return#0)[1] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #1
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b
    iny
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b+1
    // &stage_scenarios_b[scenario]
    // [781] stage_copy::stage_scenario_ptr1_$1 = stage_copy::scenario#2 << 4 -- vwum1=vwum2_rol_4 
    lda scenario
    asl
    sta stage_scenario_ptr1_stage_copy__1
    lda scenario+1
    rol
    sta stage_scenario_ptr1_stage_copy__1+1
    asl stage_scenario_ptr1_stage_copy__1
    rol stage_scenario_ptr1_stage_copy__1+1
    asl stage_scenario_ptr1_stage_copy__1
    rol stage_scenario_ptr1_stage_copy__1+1
    asl stage_scenario_ptr1_stage_copy__1
    rol stage_scenario_ptr1_stage_copy__1+1
    // [782] stage_copy::stage_scenario_ptr1_return#0 = stage_copy::stage_scenario_ptr1_stage_scenarios_b#0 + stage_copy::stage_scenario_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_scenario_ptr1_stage_copy__1
    clc
    adc.z stage_scenario_ptr1_stage_scenarios_b
    sta.z stage_scenario_ptr1_return
    lda stage_scenario_ptr1_stage_copy__1+1
    adc.z stage_scenario_ptr1_stage_scenarios_b+1
    sta.z stage_scenario_ptr1_return+1
    // stage_copy::@1
    // wave.x[ew] = stage_scenario_ptr_b->x
    // [783] stage_copy::$4 = stage_copy::ew#2 << 1 -- vbum1=vbum2_rol_1 
    lda ew
    asl
    sta stage_copy__4
    // [784] ((int *)&wave+$30)[stage_copy::$4] = ((int *)stage_copy::stage_scenario_ptr1_return#0)[6] -- pwsc1_derefidx_vbum1=pwsz2_derefidx_vbuc2 
    tax
    ldy #6
    lda (stage_scenario_ptr1_return),y
    sta wave+$30,x
    iny
    lda (stage_scenario_ptr1_return),y
    sta wave+$30+1,x
    // wave.y[ew] = stage_scenario_ptr_b->y
    // [785] ((int *)&wave+$40)[stage_copy::$4] = ((int *)stage_copy::stage_scenario_ptr1_return#0)[8] -- pwsc1_derefidx_vbum1=pwsz2_derefidx_vbuc2 
    ldy #8
    lda (stage_scenario_ptr1_return),y
    sta wave+$40,x
    iny
    lda (stage_scenario_ptr1_return),y
    sta wave+$40+1,x
    // wave.enemy_count[ew] = stage_scenario_ptr_b->enemy_count
    // [786] ((char *)&wave)[stage_copy::ew#2] = *((char *)stage_copy::stage_scenario_ptr1_return#0) -- pbuc1_derefidx_vbum1=_deref_pbuz2 
    ldy #0
    lda (stage_scenario_ptr1_return),y
    ldy ew
    sta wave,y
    // wave.dx[ew] = stage_scenario_ptr_b->dx
    // [787] ((signed char *)&wave+$50)[stage_copy::ew#2] = ((signed char *)stage_copy::stage_scenario_ptr1_return#0)[$a] -- pbsc1_derefidx_vbum1=pbsz2_derefidx_vbuc2 
    ldx ew
    ldy #$a
    lda (stage_scenario_ptr1_return),y
    sta wave+$50,x
    // wave.dy[ew] = stage_scenario_ptr_b->dy
    // [788] ((signed char *)&wave+$58)[stage_copy::ew#2] = ((signed char *)stage_copy::stage_scenario_ptr1_return#0)[$b] -- pbsc1_derefidx_vbum1=pbsz2_derefidx_vbuc2 
    ldy #$b
    lda (stage_scenario_ptr1_return),y
    sta wave+$58,x
    // wave.enemy_flightpath[ew] = stage_scenario_ptr_b->enemy_flightpath
    // [789] ((struct $41 **)&wave+$18)[stage_copy::$4] = ((struct $41 **)stage_copy::stage_scenario_ptr1_return#0)[4] -- qssc1_derefidx_vbum1=qssz2_derefidx_vbuc2 
    ldx stage_copy__4
    ldy #4
    lda (stage_scenario_ptr1_return),y
    sta wave+$18,x
    iny
    lda (stage_scenario_ptr1_return),y
    sta wave+$18+1,x
    // wave.enemy_spawn[ew] = stage_scenario_ptr_b->enemy_spawn
    // [790] ((char *)&wave+8)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[1] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldx ew
    ldy #1
    lda (stage_scenario_ptr1_return),y
    sta wave+8,x
    // stage_enemy_t* stage_enemy = stage_scenario_ptr_b->stage_enemy
    // [791] stage_copy::stage_enemy#0 = ((struct $36 **)stage_copy::stage_scenario_ptr1_return#0)[2] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #2
    lda (stage_scenario_ptr1_return),y
    sta.z stage_enemy
    iny
    lda (stage_scenario_ptr1_return),y
    sta.z stage_enemy+1
    // wave.animation_speed[ew] = stage_enemy->animation_speed
    // [792] ((char *)&wave+$98)[stage_copy::ew#2] = ((char *)stage_copy::stage_enemy#0)[4] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #4
    lda (stage_enemy),y
    sta wave+$98,x
    // wave.animation_reverse[ew] = stage_enemy->animation_reverse
    // [793] ((char *)&wave+$a0)[stage_copy::ew#2] = ((char *)stage_copy::stage_enemy#0)[5] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #5
    lda (stage_enemy),y
    sta wave+$a0,x
    // wave.enemy_sprite[ew] = stage_enemy->enemy_sprite_flight
    // [794] ((char *)&wave+$10)[stage_copy::ew#2] = *((char *)stage_copy::stage_enemy#0) -- pbuc1_derefidx_vbum1=_deref_pbuz2 
    ldy #0
    lda (stage_enemy),y
    ldy ew
    sta wave+$10,y
    // wave.interval[ew] = stage_scenario_ptr_b->interval
    // [795] ((char *)&wave+$60)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[$c] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #$c
    lda (stage_scenario_ptr1_return),y
    sta wave+$60,x
    // wave.prev[ew] = stage_scenario_ptr_b->prev
    // [796] ((char *)&wave+$70)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[$e] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #$e
    lda (stage_scenario_ptr1_return),y
    sta wave+$70,x
    // wave.wait[ew] = stage_scenario_ptr_b->wait
    // [797] ((char *)&wave+$68)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[$d] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #$d
    lda (stage_scenario_ptr1_return),y
    sta wave+$68,x
    // wave.used[ew] = 1
    // [798] ((char *)&wave+$78)[stage_copy::ew#2] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    ldy ew
    sta wave+$78,y
    // wave.finished[ew] = 0
    // [799] ((char *)&wave+$80)[stage_copy::ew#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta wave+$80,y
    // wave.scenario[ew] = scenario
    // [800] ((unsigned int *)&wave+$88)[stage_copy::$4] = stage_copy::scenario#2 -- pwuc1_derefidx_vbum1=vwum2 
    ldy stage_copy__4
    lda scenario
    sta wave+$88,y
    lda scenario+1
    sta wave+$88+1,y
    // wave.enemy_alive[ew] = 0
    // [801] ((char *)&wave+$28)[stage_copy::ew#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy ew
    sta wave+$28,y
    // stage_copy::@return
    // }
    // [802] return 
    rts
  .segment DataEngineStages
    stage_copy__4: .byte 0
    .label stage_playbook_ptr1_stage_copy__1 = stage_logic.stage_logic__53
    .label stage_scenario_ptr1_stage_copy__1 = stage_logic.stage_logic__53
  .segment Data
    ew: .byte 0
    .label scenario = clrscr.ch
  .segment DataEngineStages
    .label stage_copy__34 = stage_logic.stage_logic__53
    .label stage_copy__35 = stage_logic.stage_logic__53
}
.segment CodeEnginePlayers
  // player_add
// void player_add(__register(X) char sprite_player, __mem() char sprite_engine)
// __bank(cx16_ram, 9) 
player_add: {
    // unsigned char p = flight_add(FLIGHT_PLAYER, SIDE_PLAYER, sprite_player)
    // [804] flight_add::sprite#0 = player_add::sprite_player#2 -- vbum1=vbuxx 
    stx flight_add.sprite
    // [805] call flight_add
    // [1085] phi from player_add to flight_add [phi:player_add->flight_add]
    // [1085] phi flight_add::sprite#6 = flight_add::sprite#0 [phi:player_add->flight_add#0] -- register_copy 
    // [1085] phi flight_add::type#6 = 0 [phi:player_add->flight_add#1] -- vbuxx=vbuc1 
    ldx #0
    jsr flight_add
    // unsigned char p = flight_add(FLIGHT_PLAYER, SIDE_PLAYER, sprite_player)
    // [806] flight_add::return#2 = flight_add::f#2 -- vbuaa=vbum1 
    lda flight_add.f
    // player_add::@1
    // [807] player_add::p#0 = flight_add::return#2 -- vbum1=vbuaa 
    sta p
    // flight.moved[p] = 2
    // [808] ((char *)&flight+$5c0)[player_add::p#0] = 2 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #2
    ldy p
    sta flight+$5c0,y
    // flight.firegun[p] = 0
    // [809] ((char *)&flight+$700)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta flight+$700,y
    // flight.reload[p] = 0
    // [810] ((char *)&flight+$740)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$740,y
    // flight.health[p] = 100
    // [811] ((signed char *)&flight+$880)[player_add::p#0] = $64 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #$64
    sta flight+$880,y
    // flight.impact[p] = -100
    // [812] ((signed char *)&flight+$8c0)[player_add::p#0] = -$64 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #-$64
    sta flight+$8c0,y
    // animate_add(6,3,3,10,1,0)
    // [813] animate_add::count = 6 -- vbuz1=vbuc1 
    lda #6
    sta.z lib_animate.animate_add.count
    // [814] animate_add::state = 3 -- vbuz1=vbuc1 
    lda #3
    sta.z lib_animate.animate_add.state
    // [815] animate_add::loop = 3 -- vbuz1=vbuc1 
    sta.z lib_animate.animate_add.loop
    // [816] animate_add::speed = $a -- vbuz1=vbuc1 
    lda #$a
    sta.z lib_animate.animate_add.speed
    // [817] animate_add::direction = 1 -- vbsz1=vbsc1 
    lda #1
    sta.z lib_animate.animate_add.direction
    // [818] animate_add::reverse = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_animate.animate_add.reverse
    // [819] callexecute animate_add  -- call_var_near 
    jsr lib_animate.animate_add
    // [820] player_add::$1 = animate_add::return -- vbuaa=vbuz1 
    lda.z lib_animate.animate_add.return
    // flight.animate[p] = animate_add(6,3,3,10,1,0)
    // [821] ((char *)&flight+$900)[player_add::p#0] = player_add::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy p
    sta flight+$900,y
    // flight.xf[p] = 0
    // [822] ((char *)&flight+$280)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta flight+$280,y
    // flight.yf[p] = 0
    // [823] ((char *)&flight+$2c0)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$2c0,y
    // flight.xi[p] = 320
    // [824] player_add::$5 = player_add::p#0 << 1 -- vbuxx=vbum1_rol_1 
    tya
    asl
    tax
    // [825] ((unsigned int *)&flight+$300)[player_add::$5] = $140 -- pwuc1_derefidx_vbuxx=vwuc2 
    lda #<$140
    sta flight+$300,x
    lda #>$140
    sta flight+$300+1,x
    // flight.yi[p] = 200
    // [826] ((unsigned int *)&flight+$380)[player_add::$5] = $c8 -- pwuc1_derefidx_vbuxx=vbuc2 
    lda #$c8
    sta flight+$380,x
    lda #0
    sta flight+$380+1,x
    // flight.xd[p] = 0
    // [827] ((unsigned int *)&flight+$400)[player_add::$5] = 0 -- pwuc1_derefidx_vbuxx=vbuc2 
    sta flight+$400,x
    sta flight+$400+1,x
    // flight.yd[p] = 0
    // [828] ((unsigned int *)&flight+$480)[player_add::$5] = 0 -- pwuc1_derefidx_vbuxx=vbuc2 
    sta flight+$480,x
    sta flight+$480+1,x
    // unsigned char n = flight_add(FLIGHT_ENGINE, SIDE_PLAYER, sprite_engine)
    // [829] flight_add::sprite#1 = player_add::sprite_engine#2 -- vbum1=vbum2 
    lda sprite_engine
    sta flight_add.sprite
    // [830] call flight_add
    // [1085] phi from player_add::@1 to flight_add [phi:player_add::@1->flight_add]
    // [1085] phi flight_add::sprite#6 = flight_add::sprite#1 [phi:player_add::@1->flight_add#0] -- register_copy 
    // [1085] phi flight_add::type#6 = 4 [phi:player_add::@1->flight_add#1] -- vbuxx=vbuc1 
    ldx #4
    jsr flight_add
    // unsigned char n = flight_add(FLIGHT_ENGINE, SIDE_PLAYER, sprite_engine)
    // [831] flight_add::return#3 = flight_add::f#2 -- vbuaa=vbum1 
    lda flight_add.f
    // player_add::@2
    // [832] player_add::n#0 = flight_add::return#3 -- vbum1=vbuaa 
    sta n
    // flight.engine[p] = n
    // [833] ((char *)&flight+$6c0)[player_add::p#0] = player_add::n#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy p
    sta flight+$6c0,y
    // animate_add(16,0,0,2,1,0)
    // [834] animate_add::count = $10 -- vbuz1=vbuc1 
    lda #$10
    sta.z lib_animate.animate_add.count
    // [835] animate_add::state = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_animate.animate_add.state
    // [836] animate_add::loop = 0 -- vbuz1=vbuc1 
    sta.z lib_animate.animate_add.loop
    // [837] animate_add::speed = 2 -- vbuz1=vbuc1 
    lda #2
    sta.z lib_animate.animate_add.speed
    // [838] animate_add::direction = 1 -- vbsz1=vbsc1 
    lda #1
    sta.z lib_animate.animate_add.direction
    // [839] animate_add::reverse = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_animate.animate_add.reverse
    // [840] callexecute animate_add  -- call_var_near 
    jsr lib_animate.animate_add
    // [841] player_add::$3 = animate_add::return -- vbuaa=vbuz1 
    lda.z lib_animate.animate_add.return
    // flight.animate[n] = animate_add(16,0,0,2,1,0)
    // [842] ((char *)&flight+$900)[player_add::n#0] = player_add::$3 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy n
    sta flight+$900,y
    // stage.player = p
    // [843] *((char *)&stage+$10) = player_add::p#0 -- _deref_pbuc1=vbum1 
    lda p
    sta stage+$10
    // player_add::@return
    // }
    // [844] return 
    rts
  .segment DataEnginePlayers
    p: .byte 0
    n: .byte 0
  .segment Data
    .label sprite_engine = stage_copy.ew
}
.segment Code
  // cbm_k_getin
/**
 * @brief Scan a character from keyboard without pressing enter.
 * 
 * @return char The character read.
 */
// __register(A) char cbm_k_getin()
cbm_k_getin: {
    // __mem unsigned char ch
    // [845] cbm_k_getin::ch = 0 -- vbum1=vbuc1 
    lda #0
    sta ch
    // asm
    // asm { jsrCBM_GETIN stach  }
    jsr CBM_GETIN
    sta ch
    // return ch;
    // [847] cbm_k_getin::return#0 = cbm_k_getin::ch -- vbuaa=vbum1 
    // cbm_k_getin::@return
    // }
    // [848] cbm_k_getin::return#1 = cbm_k_getin::return#0
    // [849] return 
    rts
  .segment Data
    ch: .byte 0
}
.segment Code
  // memcpy_vram_bram
/**
 * @brief Copy block of memory from bram to vram.
 * Copies num bytes from the source bram bank/pointer to the destination vram bank/offset.
 *
 * @param dbank_vram Destination vram bank between 0 and 1.
 * @param doffset_vram Destination vram offset between 0x0000 and 0xFFFF.
 * @param sbank_vram Source bram bank between 0 and 255 (Depending on banked ram availability, maxima can be 63, 127, 191 or 255).
 * @param sptr_bram Source bram pointer between 0xA000 and 0xBFFF.
 * @param num Amount of bytes to copy.
 */
// void memcpy_vram_bram(__register(X) char dbank_vram, __mem() unsigned int doffset_vram, __mem() char sbank_bram, __zp($44) char *sptr_bram, __mem() volatile unsigned int num)
memcpy_vram_bram: {
    .label pagemask = $ff00
    .label ptr = $55
    .label sptr_bram = $44
    // memcpy_vram_bram::bank_get_bram1
    // return BRAM;
    // [851] memcpy_vram_bram::bank#10 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank
    // memcpy_vram_bram::bank_set_bram1
    // BRAM = bank
    // [852] BRAM = memcpy_vram_bram::sbank_bram#2 -- vbuz1=vbum2 
    lda sbank_bram
    sta.z BRAM
    // memcpy_vram_bram::@12
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [853] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [854] memcpy_vram_bram::$2 = byte0  memcpy_vram_bram::doffset_vram#0 -- vbuaa=_byte0_vwum1 
    lda doffset_vram
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [855] *VERA_ADDRX_L = memcpy_vram_bram::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [856] memcpy_vram_bram::$3 = byte1  memcpy_vram_bram::doffset_vram#0 -- vbuaa=_byte1_vwum1 
    lda doffset_vram+1
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [857] *VERA_ADDRX_M = memcpy_vram_bram::$3 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // dbank_vram | VERA_INC_1
    // [858] memcpy_vram_bram::$4 = memcpy_vram_bram::dbank_vram#0 | VERA_INC_1 -- vbuaa=vbuxx_bor_vbuc1 
    txa
    ora #VERA_INC_1
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [859] *VERA_ADDRX_H = memcpy_vram_bram::$4 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_H
    // (unsigned int)sptr_bram & (unsigned int)pagemask
    // [860] memcpy_vram_bram::$5 = (unsigned int)memcpy_vram_bram::sptr_bram#0 & (unsigned int)memcpy_vram_bram::pagemask -- vwum1=vwuz2_band_vwuc1 
    lda.z sptr_bram
    and #<pagemask
    sta memcpy_vram_bram__5
    lda.z sptr_bram+1
    and #>pagemask
    sta memcpy_vram_bram__5+1
    // bram_ptr_t ptr = (bram_ptr_t)((unsigned int)sptr_bram & (unsigned int)pagemask)
    // [861] memcpy_vram_bram::ptr = (char *)memcpy_vram_bram::$5 -- pbuz1=pbum2 
    // Set the page boundary.
    lda memcpy_vram_bram__5
    sta.z ptr
    lda memcpy_vram_bram__5+1
    sta.z ptr+1
    // unsigned char pos = BYTE0(sptr_bram)
    // [862] memcpy_vram_bram::pos = byte0  memcpy_vram_bram::sptr_bram#0 -- vbum1=_byte0_pbuz2 
    lda.z sptr_bram
    sta pos
    // BYTE0(sptr_bram)
    // [863] memcpy_vram_bram::$7 = byte0  memcpy_vram_bram::sptr_bram#0 -- vbuaa=_byte0_pbuz1 
    lda.z sptr_bram
    // unsigned char len = -BYTE0(sptr_bram)
    // [864] memcpy_vram_bram::len = - memcpy_vram_bram::$7 -- vbum1=_neg_vbuaa 
    eor #$ff
    clc
    adc #1
    sta len
    // num <= (unsigned int)len
    // [865] memcpy_vram_bram::$27 = (unsigned int)memcpy_vram_bram::len -- vwum1=_word_vbum2 
    sta memcpy_vram_bram__27
    lda #0
    sta memcpy_vram_bram__27+1
    // if (num <= (unsigned int)len)
    // [866] if(memcpy_vram_bram::num>memcpy_vram_bram::$27) goto memcpy_vram_bram::@1 -- vwum1_gt_vwum2_then_la1 
    cmp num+1
    bcc __b1
    bne !+
    lda memcpy_vram_bram__27
    cmp num
    bcc __b1
  !:
    // memcpy_vram_bram::@5
    // BYTE0(num)
    // [867] memcpy_vram_bram::$11 = byte0  memcpy_vram_bram::num -- vbuaa=_byte0_vwum1 
    lda num
    // len = BYTE0(num)
    // [868] memcpy_vram_bram::len = memcpy_vram_bram::$11 -- vbum1=vbuaa 
    sta len
    // memcpy_vram_bram::@1
  __b1:
    // if (len)
    // [869] if(0==memcpy_vram_bram::len) goto memcpy_vram_bram::@2 -- 0_eq_vbum1_then_la1 
    lda len
    beq __b2
    // memcpy_vram_bram::@6
    // asm
    // asm { ldypos ldxlen inx ldaptr sta!ptr++1 ldaptr+1 sta!ptr++2 !ptr: lda$ffff,y staVERA_DATA0 iny dex bne!ptr-  }
    ldy pos
    tax
    inx
    lda ptr
    sta !ptr+ +1
    lda ptr+1
    sta !ptr+ +2
  !ptr:
    lda $ffff,y
    sta VERA_DATA0
    iny
    dex
    bne !ptr-
    // ptr += 0x100
    // [871] memcpy_vram_bram::ptr = memcpy_vram_bram::ptr + $100 -- pbuz1=pbuz1_plus_vwuc1 
    // do {
    //     // *VERA_DATA0 = ptr[y];
    //     asm {
    //         !ptr: lda $ffff,y
    //         sta VERA_DATA0
    //     }
    //     y++;
    //     // ptr++;
    // } while(y<x);
    lda.z ptr
    clc
    adc #<$100
    sta.z ptr
    lda.z ptr+1
    adc #>$100
    sta.z ptr+1
    // num -= len
    // [872] memcpy_vram_bram::num = memcpy_vram_bram::num - memcpy_vram_bram::len -- vwum1=vwum1_minus_vbum2 
    sec
    lda num
    sbc len
    sta num
    bcs !+
    dec num+1
  !:
    // memcpy_vram_bram::@2
  __b2:
    // BYTE1(ptr)
    // [873] memcpy_vram_bram::$13 = byte1  memcpy_vram_bram::ptr -- vbuaa=_byte1_pbuz1 
    lda.z ptr+1
    // if (BYTE1(ptr) == 0xC0)
    // [874] if(memcpy_vram_bram::$13!=$c0) goto memcpy_vram_bram::@3 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$c0
    bne __b3
    // memcpy_vram_bram::@7
    // ptr = (unsigned char *)0xA000
    // [875] memcpy_vram_bram::ptr = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z ptr
    lda #>$a000
    sta.z ptr+1
    // bank_set_bram(++sbank_bram);
    // [876] memcpy_vram_bram::bank_set_bram2_bank#0 = ++ memcpy_vram_bram::sbank_bram#2 -- vbum1=_inc_vbum1 
    inc bank_set_bram2_bank
    // memcpy_vram_bram::bank_set_bram2
    // BRAM = bank
    // [877] BRAM = memcpy_vram_bram::bank_set_bram2_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram2_bank
    sta.z BRAM
    // [878] phi from memcpy_vram_bram::@2 memcpy_vram_bram::bank_set_bram2 to memcpy_vram_bram::@3 [phi:memcpy_vram_bram::@2/memcpy_vram_bram::bank_set_bram2->memcpy_vram_bram::@3]
    // [878] phi memcpy_vram_bram::sbank_bram#13 = memcpy_vram_bram::sbank_bram#2 [phi:memcpy_vram_bram::@2/memcpy_vram_bram::bank_set_bram2->memcpy_vram_bram::@3#0] -- register_copy 
    // memcpy_vram_bram::@3
  __b3:
    // BYTE1(num)
    // [879] memcpy_vram_bram::$16 = byte1  memcpy_vram_bram::num -- vbuaa=_byte1_vwum1 
    lda num+1
    // if (BYTE1(num))
    // [880] if(0==memcpy_vram_bram::$16) goto memcpy_vram_bram::@4 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b4
    // [881] phi from memcpy_vram_bram::@10 memcpy_vram_bram::@3 to memcpy_vram_bram::@9 [phi:memcpy_vram_bram::@10/memcpy_vram_bram::@3->memcpy_vram_bram::@9]
    // [881] phi memcpy_vram_bram::sbank_bram#5 = memcpy_vram_bram::sbank_bram#12 [phi:memcpy_vram_bram::@10/memcpy_vram_bram::@3->memcpy_vram_bram::@9#0] -- register_copy 
    // memcpy_vram_bram::@9
  __b9:
    // asm
    // asm { ldy#0 ldaptr sta!ptr++1 ldaptr+1 sta!ptr++2 !: !ptr: lda$ffff,y staVERA_DATA0 iny bne!-  }
    // register unsigned char y = 0;
    ldy #0
    lda ptr
    sta !ptr+ +1
    lda ptr+1
    sta !ptr+ +2
  !:
  !ptr:
    lda $ffff,y
    sta VERA_DATA0
    iny
    bne !-
    // ptr += 0x100
    // [883] memcpy_vram_bram::ptr = memcpy_vram_bram::ptr + $100 -- pbuz1=pbuz1_plus_vwuc1 
    // do {
    //     // *VERA_DATA0 = ptr[y];
    //     asm {
    //         !ptr: lda $ffff,y
    //         sta VERA_DATA0
    //     }
    //     y++;
    //     // ptr++;
    // } while(y);
    lda.z ptr
    clc
    adc #<$100
    sta.z ptr
    lda.z ptr+1
    adc #>$100
    sta.z ptr+1
    // BYTE1(ptr)
    // [884] memcpy_vram_bram::$21 = byte1  memcpy_vram_bram::ptr -- vbuaa=_byte1_pbuz1 
    // if (BYTE1(ptr) == 0xC0)
    // [885] if(memcpy_vram_bram::$21!=$c0) goto memcpy_vram_bram::@10 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$c0
    bne __b10
    // memcpy_vram_bram::@11
    // ptr = (unsigned char *)0xA000
    // [886] memcpy_vram_bram::ptr = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z ptr
    lda #>$a000
    sta.z ptr+1
    // bank_set_bram(++sbank_bram);
    // [887] memcpy_vram_bram::bank_set_bram3_bank#0 = ++ memcpy_vram_bram::sbank_bram#5 -- vbum1=_inc_vbum1 
    inc bank_set_bram3_bank
    // memcpy_vram_bram::bank_set_bram3
    // BRAM = bank
    // [888] BRAM = memcpy_vram_bram::bank_set_bram3_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram3_bank
    sta.z BRAM
    // [889] phi from memcpy_vram_bram::@9 memcpy_vram_bram::bank_set_bram3 to memcpy_vram_bram::@10 [phi:memcpy_vram_bram::@9/memcpy_vram_bram::bank_set_bram3->memcpy_vram_bram::@10]
    // [889] phi memcpy_vram_bram::sbank_bram#12 = memcpy_vram_bram::sbank_bram#5 [phi:memcpy_vram_bram::@9/memcpy_vram_bram::bank_set_bram3->memcpy_vram_bram::@10#0] -- register_copy 
    // memcpy_vram_bram::@10
  __b10:
    // num -= 256
    // [890] memcpy_vram_bram::num = memcpy_vram_bram::num - $100 -- vwum1=vwum1_minus_vwuc1 
    lda num
    sec
    sbc #<$100
    sta num
    lda num+1
    sbc #>$100
    sta num+1
    // BYTE1(num)
    // [891] memcpy_vram_bram::$25 = byte1  memcpy_vram_bram::num -- vbuaa=_byte1_vwum1 
    // while (BYTE1(num))
    // [892] if(0!=memcpy_vram_bram::$25) goto memcpy_vram_bram::@9 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b9
    // memcpy_vram_bram::@4
  __b4:
    // if (num)
    // [893] if(0==memcpy_vram_bram::num) goto memcpy_vram_bram::bank_set_bram4 -- 0_eq_vwum1_then_la1 
    lda num
    ora num+1
    beq bank_set_bram4
    // memcpy_vram_bram::@8
    // asm
    // asm { ldy#0 ldxnum inx ldaptr sta!ptr++1 ldaptr+1 sta!ptr++2 !ptr: lda$ffff,y staVERA_DATA0 iny dex bne!ptr-  }
    ldy #0
    ldx num
    inx
    lda ptr
    sta !ptr+ +1
    lda ptr+1
    sta !ptr+ +2
  !ptr:
    lda $ffff,y
    sta VERA_DATA0
    iny
    dex
    bne !ptr-
    // memcpy_vram_bram::bank_set_bram4
  bank_set_bram4:
    // BRAM = bank
    // [895] BRAM = memcpy_vram_bram::bank#10 -- vbuz1=vbum2 
    lda bank
    sta.z BRAM
    // memcpy_vram_bram::@return
    // }
    // [896] return 
    rts
  .segment Data
    num: .word 0
    .label memcpy_vram_bram__5 = doffset_vram
    pos: .byte 0
    len: .byte 0
    .label memcpy_vram_bram__27 = doffset_vram
    .label bank_set_bram2_bank = sbank_bram
    .label bank_set_bram3_bank = sbank_bram
    doffset_vram: .word 0
    sbank_bram: .byte 0
    bank: .byte 0
}
.segment Code
  // fopen
/**
 * @brief Load a file to banked ram located between address 0xA000 and 0xBFFF incrementing the banks.
 *
 * @param channel Input channel.
 * @param device Input device.
 * @param secondary Secondary channel.
 * @param filename Name of the file to be loaded.
 * @return
 *  - 0x0000: Something is wrong! Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
 *  - other: OK! The last pointer between 0xA000 and 0xBFFF is returned. Note that the last pointer is indicating the first free byte.
 */
// __zp($3d) struct $2 * fopen(__zp($22) const char *path, const char *mode)
fopen: {
    .label fopen__11 = $22
    .label fopen__28 = $31
    .label cbm_k_setnam1_filename = $4a
    .label stream = $3d
    .label pathtoken = $22
    .label pathtoken_1 = $26
    .label path = $22
    .label return = $3d
    // unsigned char sp = __stdio_filecount
    // [898] fopen::sp#0 = __stdio_filecount -- vbum1=vbum2 
    lda __stdio_filecount
    sta sp
    // (unsigned int)sp | 0x8000
    // [899] fopen::$30 = (unsigned int)fopen::sp#0 -- vwum1=_word_vbum2 
    sta fopen__30
    lda #0
    sta fopen__30+1
    // [900] fopen::stream#0 = fopen::$30 | $8000 -- vwuz1=vwum2_bor_vwuc1 
    lda fopen__30
    ora #<$8000
    sta.z stream
    lda fopen__30+1
    ora #>$8000
    sta.z stream+1
    // char pathpos = sp * __STDIO_FILECOUNT
    // [901] fopen::pathpos#0 = fopen::sp#0 << 2 -- vbum1=vbum2_rol_2 
    lda sp
    asl
    asl
    sta pathpos
    // __logical = 0
    // [902] ((char *)&__stdio_file+$80)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy sp
    sta __stdio_file+$80,y
    // __device = 0
    // [903] ((char *)&__stdio_file+$84)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+$84,y
    // __channel = 0
    // [904] ((char *)&__stdio_file+$88)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+$88,y
    // [905] fopen::pathtoken#22 = fopen::pathtoken#0 -- pbuz1=pbuz2 
    lda.z pathtoken
    sta.z pathtoken_1
    lda.z pathtoken+1
    sta.z pathtoken_1+1
    // [906] fopen::pathpos#21 = fopen::pathpos#0 -- vbum1=vbum2 
    lda pathpos
    sta pathpos_1
    // [907] phi from fopen to fopen::@8 [phi:fopen->fopen::@8]
    // [907] phi fopen::num#10 = 0 [phi:fopen->fopen::@8#0] -- vbuxx=vbuc1 
    ldx #0
    // [907] phi fopen::pathpos#10 = fopen::pathpos#21 [phi:fopen->fopen::@8#1] -- register_copy 
    // [907] phi fopen::path#10 = fopen::pathtoken#0 [phi:fopen->fopen::@8#2] -- register_copy 
    // [907] phi fopen::pathstep#10 = 0 [phi:fopen->fopen::@8#3] -- vbum1=vbuc1 
    txa
    sta pathstep
    // [907] phi fopen::pathtoken#10 = fopen::pathtoken#22 [phi:fopen->fopen::@8#4] -- register_copy 
  // Iterate while path is not \0.
    // [907] phi from fopen::@22 to fopen::@8 [phi:fopen::@22->fopen::@8]
    // [907] phi fopen::num#10 = fopen::num#13 [phi:fopen::@22->fopen::@8#0] -- register_copy 
    // [907] phi fopen::pathpos#10 = fopen::pathpos#7 [phi:fopen::@22->fopen::@8#1] -- register_copy 
    // [907] phi fopen::path#10 = fopen::path#11 [phi:fopen::@22->fopen::@8#2] -- register_copy 
    // [907] phi fopen::pathstep#10 = fopen::pathstep#11 [phi:fopen::@22->fopen::@8#3] -- register_copy 
    // [907] phi fopen::pathtoken#10 = fopen::pathtoken#1 [phi:fopen::@22->fopen::@8#4] -- register_copy 
    // fopen::@8
  __b8:
    // if (*pathtoken == ',' || *pathtoken == '\0')
    // [908] if(*fopen::pathtoken#10==','pm) goto fopen::@9 -- _deref_pbuz1_eq_vbuc1_then_la1 
    lda #','
    ldy #0
    cmp (pathtoken_1),y
    bne !__b9+
    jmp __b9
  !__b9:
    // fopen::@33
    // [909] if(*fopen::pathtoken#10=='?'pm) goto fopen::@9 -- _deref_pbuz1_eq_vbuc1_then_la1 
    lda #'\$00'
    cmp (pathtoken_1),y
    bne !__b9+
    jmp __b9
  !__b9:
    // fopen::@23
    // if (pathstep == 0)
    // [910] if(fopen::pathstep#10!=0) goto fopen::@10 -- vbum1_neq_0_then_la1 
    lda pathstep
    bne __b10
    // fopen::@24
    // __stdio_file.filename[pathpos] = *pathtoken
    // [911] ((char *)&__stdio_file)[fopen::pathpos#10] = *fopen::pathtoken#10 -- pbuc1_derefidx_vbum1=_deref_pbuz2 
    lda (pathtoken_1),y
    ldy pathpos_1
    sta __stdio_file,y
    // pathpos++;
    // [912] fopen::pathpos#1 = ++ fopen::pathpos#10 -- vbum1=_inc_vbum1 
    inc pathpos_1
    // [913] phi from fopen::@12 fopen::@23 fopen::@24 to fopen::@10 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10]
    // [913] phi fopen::num#13 = fopen::num#15 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#0] -- register_copy 
    // [913] phi fopen::pathpos#7 = fopen::pathpos#10 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#1] -- register_copy 
    // [913] phi fopen::path#11 = fopen::path#13 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#2] -- register_copy 
    // [913] phi fopen::pathstep#11 = fopen::pathstep#1 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#3] -- register_copy 
    // fopen::@10
  __b10:
    // pathtoken++;
    // [914] fopen::pathtoken#1 = ++ fopen::pathtoken#10 -- pbuz1=_inc_pbuz1 
    inc.z pathtoken_1
    bne !+
    inc.z pathtoken_1+1
  !:
    // fopen::@22
    // pathtoken - 1
    // [915] fopen::$28 = fopen::pathtoken#1 - 1 -- pbuz1=pbuz2_minus_1 
    lda.z pathtoken_1
    sec
    sbc #1
    sta.z fopen__28
    lda.z pathtoken_1+1
    sbc #0
    sta.z fopen__28+1
    // while (*(pathtoken - 1))
    // [916] if(0!=*fopen::$28) goto fopen::@8 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (fopen__28),y
    cmp #0
    bne __b8
    // fopen::@26
    // __status = 0
    // [917] ((char *)&__stdio_file+$8c)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    tya
    ldy sp
    sta __stdio_file+$8c,y
    // if(!__logical)
    // [918] if(0!=((char *)&__stdio_file+$80)[fopen::sp#0]) goto fopen::@1 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+$80,y
    cmp #0
    bne __b1
    // fopen::@27
    // __stdio_filecount+1
    // [919] fopen::$4 = __stdio_filecount + 1 -- vbuaa=vbum1_plus_1 
    lda __stdio_filecount
    inc
    // __logical = __stdio_filecount+1
    // [920] ((char *)&__stdio_file+$80)[fopen::sp#0] = fopen::$4 -- pbuc1_derefidx_vbum1=vbuaa 
    sta __stdio_file+$80,y
    // fopen::@1
  __b1:
    // if(!__device)
    // [921] if(0!=((char *)&__stdio_file+$84)[fopen::sp#0]) goto fopen::@2 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sp
    lda __stdio_file+$84,y
    cmp #0
    bne __b2
    // fopen::@5
    // __device = 8
    // [922] ((char *)&__stdio_file+$84)[fopen::sp#0] = 8 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #8
    sta __stdio_file+$84,y
    // fopen::@2
  __b2:
    // if(!__channel)
    // [923] if(0!=((char *)&__stdio_file+$88)[fopen::sp#0]) goto fopen::@3 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sp
    lda __stdio_file+$88,y
    cmp #0
    bne __b3
    // fopen::@6
    // __stdio_filecount+2
    // [924] fopen::$9 = __stdio_filecount + 2 -- vbuaa=vbum1_plus_2 
    lda __stdio_filecount
    clc
    adc #2
    // __channel = __stdio_filecount+2
    // [925] ((char *)&__stdio_file+$88)[fopen::sp#0] = fopen::$9 -- pbuc1_derefidx_vbum1=vbuaa 
    sta __stdio_file+$88,y
    // fopen::@3
  __b3:
    // __filename
    // [926] fopen::$11 = (char *)&__stdio_file + fopen::pathpos#0 -- pbuz1=pbuc1_plus_vbum2 
    lda pathpos
    clc
    adc #<__stdio_file
    sta.z fopen__11
    lda #>__stdio_file
    adc #0
    sta.z fopen__11+1
    // cbm_k_setnam(__filename)
    // [927] fopen::cbm_k_setnam1_filename = fopen::$11 -- pbuz1=pbuz2 
    lda.z fopen__11
    sta.z cbm_k_setnam1_filename
    lda.z fopen__11+1
    sta.z cbm_k_setnam1_filename+1
    // fopen::cbm_k_setnam1
    // strlen(filename)
    // [928] strlen::str#2 = fopen::cbm_k_setnam1_filename -- pbuz1=pbuz2 
    lda.z cbm_k_setnam1_filename
    sta.z strlen.str
    lda.z cbm_k_setnam1_filename+1
    sta.z strlen.str+1
    // [929] call strlen
    // [1128] phi from fopen::cbm_k_setnam1 to strlen [phi:fopen::cbm_k_setnam1->strlen]
    // [1128] phi strlen::str#6 = strlen::str#2 [phi:fopen::cbm_k_setnam1->strlen#0] -- register_copy 
    jsr strlen
    // strlen(filename)
    // [930] strlen::return#3 = strlen::len#2
    // fopen::@31
    // [931] fopen::cbm_k_setnam1_$0 = strlen::return#3
    // char filename_len = (char)strlen(filename)
    // [932] fopen::cbm_k_setnam1_filename_len = (char)fopen::cbm_k_setnam1_$0 -- vbum1=_byte_vwum2 
    lda cbm_k_setnam1_fopen__0
    sta cbm_k_setnam1_filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx cbm_k_setnam1_filename
    ldy cbm_k_setnam1_filename+1
    jsr CBM_SETNAM
    // fopen::@28
    // cbm_k_setlfs(__logical, __device, __channel)
    // [934] cbm_k_setlfs::channel = ((char *)&__stdio_file+$80)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+$80,y
    sta cbm_k_setlfs.channel
    // [935] cbm_k_setlfs::device = ((char *)&__stdio_file+$84)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda __stdio_file+$84,y
    sta cbm_k_setlfs.device
    // [936] cbm_k_setlfs::command = ((char *)&__stdio_file+$88)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda __stdio_file+$88,y
    sta cbm_k_setlfs.command
    // [937] call cbm_k_setlfs
    jsr cbm_k_setlfs
    // fopen::cbm_k_open1
    // asm
    // asm { jsrCBM_OPEN  }
    jsr CBM_OPEN
    // fopen::cbm_k_readst1
    // char status
    // [939] fopen::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [941] fopen::cbm_k_readst1_return#0 = fopen::cbm_k_readst1_status -- vbuaa=vbum1 
    // fopen::cbm_k_readst1_@return
    // }
    // [942] fopen::cbm_k_readst1_return#1 = fopen::cbm_k_readst1_return#0
    // fopen::@29
    // cbm_k_readst()
    // [943] fopen::$15 = fopen::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [944] ((char *)&__stdio_file+$8c)[fopen::sp#0] = fopen::$15 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+$8c,y
    // ferror(stream)
    // [945] ferror::stream#0 = (struct $2 *)fopen::stream#0
    // [946] call ferror
    jsr ferror
    // [947] ferror::return#0 = ferror::return#1
    // fopen::@32
    // [948] fopen::$16 = ferror::return#0
    // if (ferror(stream))
    // [949] if(0==fopen::$16) goto fopen::@4 -- 0_eq_vwsm1_then_la1 
    lda fopen__16
    ora fopen__16+1
    beq __b4
    // fopen::@7
    // cbm_k_close(__logical)
    // [950] fopen::cbm_k_close1_channel = ((char *)&__stdio_file+$80)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+$80,y
    sta cbm_k_close1_channel
    // fopen::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // [952] phi from fopen::cbm_k_close1 to fopen::@return [phi:fopen::cbm_k_close1->fopen::@return]
    // [952] phi fopen::return#2 = 0 [phi:fopen::cbm_k_close1->fopen::@return#0] -- pssz1=vbuc1 
    lda #<0
    sta.z return
    sta.z return+1
    // fopen::@return
    // }
    // [953] return 
    rts
    // fopen::@4
  __b4:
    // __stdio_filecount++;
    // [954] __stdio_filecount = ++ __stdio_filecount -- vbum1=_inc_vbum1 
    inc __stdio_filecount
    // [955] fopen::return#8 = (struct $2 *)fopen::stream#0
    // [952] phi from fopen::@4 to fopen::@return [phi:fopen::@4->fopen::@return]
    // [952] phi fopen::return#2 = fopen::return#8 [phi:fopen::@4->fopen::@return#0] -- register_copy 
    rts
    // fopen::@9
  __b9:
    // if (pathstep > 0)
    // [956] if(fopen::pathstep#10>0) goto fopen::@11 -- vbum1_gt_0_then_la1 
    lda pathstep
    bne __b11
    // fopen::@25
    // __stdio_file.filename[pathpos] = '\0'
    // [957] ((char *)&__stdio_file)[fopen::pathpos#10] = '?'pm -- pbuc1_derefidx_vbum1=vbuc2 
    lda #'\$00'
    ldy pathpos_1
    sta __stdio_file,y
    // path = pathtoken + 1
    // [958] fopen::path#0 = fopen::pathtoken#10 + 1 -- pbuz1=pbuz2_plus_1 
    clc
    lda.z pathtoken_1
    adc #1
    sta.z path
    lda.z pathtoken_1+1
    adc #0
    sta.z path+1
    // [959] phi from fopen::@16 fopen::@17 fopen::@18 fopen::@19 fopen::@25 to fopen::@12 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12]
    // [959] phi fopen::num#15 = fopen::num#2 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12#0] -- register_copy 
    // [959] phi fopen::path#13 = fopen::path#16 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12#1] -- register_copy 
    // fopen::@12
  __b12:
    // pathstep++;
    // [960] fopen::pathstep#1 = ++ fopen::pathstep#10 -- vbum1=_inc_vbum1 
    inc pathstep
    jmp __b10
    // fopen::@11
  __b11:
    // char pathcmp = *path
    // [961] fopen::pathcmp#0 = *fopen::path#10 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (path),y
    sta pathcmp
    // case 'D':
    // [962] if(fopen::pathcmp#0=='D'pm) goto fopen::@13 -- vbum1_eq_vbuc1_then_la1 
    lda #'D'
    cmp pathcmp
    beq __b13
    // fopen::@20
    // case 'L':
    // [963] if(fopen::pathcmp#0=='L'pm) goto fopen::@13 -- vbum1_eq_vbuc1_then_la1 
    lda #'L'
    cmp pathcmp
    beq __b13
    // fopen::@21
    // case 'C':
    //                     num = (char)atoi(path + 1);
    //                     path = pathtoken + 1;
    // [964] if(fopen::pathcmp#0=='C'pm) goto fopen::@13 -- vbum1_eq_vbuc1_then_la1 
    lda #'C'
    cmp pathcmp
    beq __b13
    // [965] phi from fopen::@21 fopen::@30 to fopen::@14 [phi:fopen::@21/fopen::@30->fopen::@14]
    // [965] phi fopen::path#16 = fopen::path#10 [phi:fopen::@21/fopen::@30->fopen::@14#0] -- register_copy 
    // [965] phi fopen::num#2 = fopen::num#10 [phi:fopen::@21/fopen::@30->fopen::@14#1] -- register_copy 
    // fopen::@14
  __b14:
    // case 'L':
    //                     __logical = num;
    //                     break;
    // [966] if(fopen::pathcmp#0=='L'pm) goto fopen::@17 -- vbum1_eq_vbuc1_then_la1 
    lda #'L'
    cmp pathcmp
    beq __b17
    // fopen::@15
    // case 'D':
    //                     __device = num;
    //                     break;
    // [967] if(fopen::pathcmp#0=='D'pm) goto fopen::@18 -- vbum1_eq_vbuc1_then_la1 
    lda #'D'
    cmp pathcmp
    beq __b18
    // fopen::@16
    // case 'C':
    //                     __channel = num;
    //                     break;
    // [968] if(fopen::pathcmp#0!='C'pm) goto fopen::@12 -- vbum1_neq_vbuc1_then_la1 
    lda #'C'
    cmp pathcmp
    bne __b12
    // fopen::@19
    // __channel = num
    // [969] ((char *)&__stdio_file+$88)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy sp
    txa
    sta __stdio_file+$88,y
    jmp __b12
    // fopen::@18
  __b18:
    // __device = num
    // [970] ((char *)&__stdio_file+$84)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy sp
    txa
    sta __stdio_file+$84,y
    jmp __b12
    // fopen::@17
  __b17:
    // __logical = num
    // [971] ((char *)&__stdio_file+$80)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy sp
    txa
    sta __stdio_file+$80,y
    jmp __b12
    // fopen::@13
  __b13:
    // atoi(path + 1)
    // [972] atoi::str#0 = fopen::path#10 + 1 -- pbuz1=pbuz1_plus_1 
    inc.z atoi.str
    bne !+
    inc.z atoi.str+1
  !:
    // [973] call atoi
    // [1188] phi from fopen::@13 to atoi [phi:fopen::@13->atoi]
    // [1188] phi atoi::str#2 = atoi::str#0 [phi:fopen::@13->atoi#0] -- register_copy 
    jsr atoi
    // atoi(path + 1)
    // [974] atoi::return#3 = atoi::return#2
    // fopen::@30
    // [975] fopen::$26 = atoi::return#3
    // num = (char)atoi(path + 1)
    // [976] fopen::num#1 = (char)fopen::$26 -- vbuxx=_byte_vwsm1 
    lda fopen__26
    tax
    // path = pathtoken + 1
    // [977] fopen::path#1 = fopen::pathtoken#10 + 1 -- pbuz1=pbuz2_plus_1 
    clc
    lda.z pathtoken_1
    adc #1
    sta.z path
    lda.z pathtoken_1+1
    adc #0
    sta.z path+1
    jmp __b14
  .segment Data
    .label fopen__16 = clrscr.ch
    .label fopen__26 = clrscr.ch
    .label fopen__30 = clrscr.ch
    cbm_k_setnam1_filename_len: .byte 0
    .label cbm_k_setnam1_fopen__0 = clrscr.ch
    cbm_k_readst1_status: .byte 0
    cbm_k_close1_channel: .byte 0
    sp: .byte 0
    pathpos: .byte 0
    pathpos_1: .byte 0
    pathcmp: .byte 0
    // Parse path
    .label pathstep = stage_copy.ew
}
.segment Code
  // fgets
/**
 * @brief Load a file to ram or (banked ram located between address 0xA000 and 0xBFFF), incrementing the banks.
 * This function uses the new CX16 macptr kernal API at address $FF44.
 *
 * @param sptr The pointer between 0xA000 and 0xBFFF in banked ram.
 * @param size The amount of bytes to be read.
 * @param filename Name of the file to be loaded.
 * @return ptr the pointer advanced to the point where the stream ends.
 */
// __mem() unsigned int fgets(__zp($22) char *ptr, __mem() unsigned int size, __zp($26) struct $2 *stream)
fgets: {
    .label ptr = $22
    .label stream = $26
    // unsigned char sp = (unsigned char)stream
    // [979] fgets::sp#0 = (char)fgets::stream#4 -- vbum1=_byte_pssz2 
    lda.z stream
    sta sp
    // cbm_k_chkin(__logical)
    // [980] fgets::cbm_k_chkin1_channel = ((char *)&__stdio_file+$80)[fgets::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    tay
    lda __stdio_file+$80,y
    sta cbm_k_chkin1_channel
    // fgets::cbm_k_chkin1
    // char status
    // [981] fgets::cbm_k_chkin1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // fgets::cbm_k_readst1
    // char status
    // [983] fgets::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [985] fgets::cbm_k_readst1_return#0 = fgets::cbm_k_readst1_status -- vbuaa=vbum1 
    // fgets::cbm_k_readst1_@return
    // }
    // [986] fgets::cbm_k_readst1_return#1 = fgets::cbm_k_readst1_return#0
    // fgets::@11
    // cbm_k_readst()
    // [987] fgets::$1 = fgets::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [988] ((char *)&__stdio_file+$8c)[fgets::sp#0] = fgets::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+$8c,y
    // if (__status)
    // [989] if(0==((char *)&__stdio_file+$8c)[fgets::sp#0]) goto fgets::@1 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+$8c,y
    cmp #0
    beq __b1
    // [990] phi from fgets::@11 fgets::@12 fgets::@5 to fgets::@return [phi:fgets::@11/fgets::@12/fgets::@5->fgets::@return]
  __b8:
    // [990] phi fgets::return#1 = 0 [phi:fgets::@11/fgets::@12/fgets::@5->fgets::@return#0] -- vwum1=vbuc1 
    lda #<0
    sta return
    sta return+1
    // fgets::@return
    // }
    // [991] return 
    rts
    // fgets::@1
  __b1:
    // [992] fgets::remaining#22 = fgets::size#10 -- vwum1=vwum2 
    lda size
    sta remaining
    lda size+1
    sta remaining+1
    // [993] phi from fgets::@1 to fgets::@2 [phi:fgets::@1->fgets::@2]
    // [993] phi fgets::read#10 = 0 [phi:fgets::@1->fgets::@2#0] -- vwum1=vwuc1 
    lda #<0
    sta read
    sta read+1
    // [993] phi fgets::remaining#11 = fgets::remaining#22 [phi:fgets::@1->fgets::@2#1] -- register_copy 
    // [993] phi fgets::ptr#11 = fgets::ptr#14 [phi:fgets::@1->fgets::@2#2] -- register_copy 
    // [993] phi from fgets::@17 fgets::@18 to fgets::@2 [phi:fgets::@17/fgets::@18->fgets::@2]
    // [993] phi fgets::read#10 = fgets::read#1 [phi:fgets::@17/fgets::@18->fgets::@2#0] -- register_copy 
    // [993] phi fgets::remaining#11 = fgets::remaining#1 [phi:fgets::@17/fgets::@18->fgets::@2#1] -- register_copy 
    // [993] phi fgets::ptr#11 = fgets::ptr#15 [phi:fgets::@17/fgets::@18->fgets::@2#2] -- register_copy 
    // fgets::@2
  __b2:
    // if (!size)
    // [994] if(0==fgets::size#10) goto fgets::@3 -- 0_eq_vwum1_then_la1 
    lda size
    ora size+1
    bne !__b3+
    jmp __b3
  !__b3:
    // fgets::@8
    // if (remaining >= 128)
    // [995] if(fgets::remaining#11>=$80) goto fgets::@4 -- vwum1_ge_vbuc1_then_la1 
    lda remaining+1
    beq !__b4+
    jmp __b4
  !__b4:
    lda remaining
    cmp #$80
    bcc !__b4+
    jmp __b4
  !__b4:
  !:
    // fgets::@9
    // cx16_k_macptr(remaining, ptr)
    // [996] cx16_k_macptr::bytes = fgets::remaining#11 -- vbum1=vwum2 
    lda remaining
    sta cx16_k_macptr.bytes
    // [997] cx16_k_macptr::buffer = (void *)fgets::ptr#11 -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [998] call cx16_k_macptr
    jsr cx16_k_macptr
    // [999] cx16_k_macptr::return#4 = cx16_k_macptr::return#1
    // fgets::@15
  __b15:
    // bytes = cx16_k_macptr(remaining, ptr)
    // [1000] fgets::bytes#3 = cx16_k_macptr::return#4
    // [1001] phi from fgets::@13 fgets::@14 fgets::@15 to fgets::cbm_k_readst2 [phi:fgets::@13/fgets::@14/fgets::@15->fgets::cbm_k_readst2]
    // [1001] phi fgets::bytes#10 = fgets::bytes#1 [phi:fgets::@13/fgets::@14/fgets::@15->fgets::cbm_k_readst2#0] -- register_copy 
    // fgets::cbm_k_readst2
    // char status
    // [1002] fgets::cbm_k_readst2_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst2_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst2_status
    // return status;
    // [1004] fgets::cbm_k_readst2_return#0 = fgets::cbm_k_readst2_status -- vbuaa=vbum1 
    // fgets::cbm_k_readst2_@return
    // }
    // [1005] fgets::cbm_k_readst2_return#1 = fgets::cbm_k_readst2_return#0
    // fgets::@12
    // cbm_k_readst()
    // [1006] fgets::$8 = fgets::cbm_k_readst2_return#1
    // __status = cbm_k_readst()
    // [1007] ((char *)&__stdio_file+$8c)[fgets::sp#0] = fgets::$8 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+$8c,y
    // __status & 0xBF
    // [1008] fgets::$9 = ((char *)&__stdio_file+$8c)[fgets::sp#0] & $bf -- vbuaa=pbuc1_derefidx_vbum1_band_vbuc2 
    lda #$bf
    and __stdio_file+$8c,y
    // if (__status & 0xBF)
    // [1009] if(0==fgets::$9) goto fgets::@5 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b5
    jmp __b8
    // fgets::@5
  __b5:
    // if (bytes == 0xFFFF)
    // [1010] if(fgets::bytes#10!=$ffff) goto fgets::@6 -- vwum1_neq_vwuc1_then_la1 
    lda bytes+1
    cmp #>$ffff
    bne __b6
    lda bytes
    cmp #<$ffff
    bne __b6
    jmp __b8
    // fgets::@6
  __b6:
    // read += bytes
    // [1011] fgets::read#1 = fgets::read#10 + fgets::bytes#10 -- vwum1=vwum1_plus_vwum2 
    clc
    lda read
    adc bytes
    sta read
    lda read+1
    adc bytes+1
    sta read+1
    // ptr += bytes
    // [1012] fgets::ptr#0 = fgets::ptr#11 + fgets::bytes#10 -- pbuz1=pbuz1_plus_vwum2 
    clc
    lda.z ptr
    adc bytes
    sta.z ptr
    lda.z ptr+1
    adc bytes+1
    sta.z ptr+1
    // BYTE1(ptr)
    // [1013] fgets::$13 = byte1  fgets::ptr#0 -- vbuaa=_byte1_pbuz1 
    // if (BYTE1(ptr) == 0xC0)
    // [1014] if(fgets::$13!=$c0) goto fgets::@7 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$c0
    bne __b7
    // fgets::@10
    // ptr -= 0x2000
    // [1015] fgets::ptr#1 = fgets::ptr#0 - $2000 -- pbuz1=pbuz1_minus_vwuc1 
    lda.z ptr
    sec
    sbc #<$2000
    sta.z ptr
    lda.z ptr+1
    sbc #>$2000
    sta.z ptr+1
    // [1016] phi from fgets::@10 fgets::@6 to fgets::@7 [phi:fgets::@10/fgets::@6->fgets::@7]
    // [1016] phi fgets::ptr#15 = fgets::ptr#1 [phi:fgets::@10/fgets::@6->fgets::@7#0] -- register_copy 
    // fgets::@7
  __b7:
    // remaining -= bytes
    // [1017] fgets::remaining#1 = fgets::remaining#11 - fgets::bytes#10 -- vwum1=vwum1_minus_vwum2 
    lda remaining
    sec
    sbc bytes
    sta remaining
    lda remaining+1
    sbc bytes+1
    sta remaining+1
    // while ((__status == 0) && ((size && remaining) || !size))
    // [1018] if(((char *)&__stdio_file+$8c)[fgets::sp#0]==0) goto fgets::@16 -- pbuc1_derefidx_vbum1_eq_0_then_la1 
    ldy sp
    lda __stdio_file+$8c,y
    cmp #0
    beq __b16
    // [990] phi from fgets::@17 fgets::@7 to fgets::@return [phi:fgets::@17/fgets::@7->fgets::@return]
    // [990] phi fgets::return#1 = fgets::read#1 [phi:fgets::@17/fgets::@7->fgets::@return#0] -- register_copy 
    rts
    // fgets::@16
  __b16:
    // while ((__status == 0) && ((size && remaining) || !size))
    // [1019] if(0==fgets::size#10) goto fgets::@17 -- 0_eq_vwum1_then_la1 
    lda size
    ora size+1
    beq __b17
    // fgets::@18
    // [1020] if(0!=fgets::remaining#1) goto fgets::@2 -- 0_neq_vwum1_then_la1 
    lda remaining
    ora remaining+1
    beq !__b2+
    jmp __b2
  !__b2:
    // fgets::@17
  __b17:
    // [1021] if(0==fgets::size#10) goto fgets::@2 -- 0_eq_vwum1_then_la1 
    lda size
    ora size+1
    bne !__b2+
    jmp __b2
  !__b2:
    rts
    // fgets::@4
  __b4:
    // cx16_k_macptr(128, ptr)
    // [1022] cx16_k_macptr::bytes = $80 -- vbum1=vbuc1 
    lda #$80
    sta cx16_k_macptr.bytes
    // [1023] cx16_k_macptr::buffer = (void *)fgets::ptr#11 -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [1024] call cx16_k_macptr
    jsr cx16_k_macptr
    // [1025] cx16_k_macptr::return#3 = cx16_k_macptr::return#1
    // fgets::@14
    // bytes = cx16_k_macptr(128, ptr)
    // [1026] fgets::bytes#2 = cx16_k_macptr::return#3
    jmp __b15
    // fgets::@3
  __b3:
    // cx16_k_macptr(0, ptr)
    // [1027] cx16_k_macptr::bytes = 0 -- vbum1=vbuc1 
    lda #0
    sta cx16_k_macptr.bytes
    // [1028] cx16_k_macptr::buffer = (void *)fgets::ptr#11 -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [1029] call cx16_k_macptr
    jsr cx16_k_macptr
    // [1030] cx16_k_macptr::return#2 = cx16_k_macptr::return#1
    // fgets::@13
    // bytes = cx16_k_macptr(0, ptr)
    // [1031] fgets::bytes#1 = cx16_k_macptr::return#2
    jmp __b15
  .segment Data
    cbm_k_chkin1_channel: .byte 0
    cbm_k_chkin1_status: .byte 0
    cbm_k_readst1_status: .byte 0
    cbm_k_readst2_status: .byte 0
    .label sp = stage_copy.ew
    .label return = read
    bytes: .word 0
    read: .word 0
    remaining: .word 0
    .label size = clrscr.ch
}
.segment Code
  // fclose
/**
 * @brief Close a file.
 *
 * @param fp The FILE pointer.
 * @return
 *  - 0x0000: Something is wrong! Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
 *  - other: OK! The last pointer between 0xA000 and 0xBFFF is returned. Note that the last pointer is indicating the first free byte.
 */
// __mem() int fclose(__zp($3d) struct $2 *stream)
fclose: {
    .label stream = $3d
    // unsigned char sp = (unsigned char)stream
    // [1033] fclose::sp#0 = (char)fclose::stream#3 -- vbum1=_byte_pssz2 
    lda.z stream
    sta sp
    // cbm_k_chkin(__logical)
    // [1034] fclose::cbm_k_chkin1_channel = ((char *)&__stdio_file+$80)[fclose::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    tay
    lda __stdio_file+$80,y
    sta cbm_k_chkin1_channel
    // fclose::cbm_k_chkin1
    // char status
    // [1035] fclose::cbm_k_chkin1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // fclose::cbm_k_readst1
    // char status
    // [1037] fclose::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [1039] fclose::cbm_k_readst1_return#0 = fclose::cbm_k_readst1_status -- vbuaa=vbum1 
    // fclose::cbm_k_readst1_@return
    // }
    // [1040] fclose::cbm_k_readst1_return#1 = fclose::cbm_k_readst1_return#0
    // fclose::@3
    // cbm_k_readst()
    // [1041] fclose::$1 = fclose::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [1042] ((char *)&__stdio_file+$8c)[fclose::sp#0] = fclose::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+$8c,y
    // if (__status)
    // [1043] if(0==((char *)&__stdio_file+$8c)[fclose::sp#0]) goto fclose::@1 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+$8c,y
    cmp #0
    beq __b1
    // [1044] phi from fclose::@2 fclose::@3 to fclose::@return [phi:fclose::@2/fclose::@3->fclose::@return]
  __b3:
    // [1044] phi fclose::return#1 = 0 [phi:fclose::@2/fclose::@3->fclose::@return#0] -- vwsm1=vbsc1 
    lda #<0
    sta return
    sta return+1
    // fclose::@return
    // }
    // [1045] return 
    rts
    // fclose::@1
  __b1:
    // cbm_k_close(__logical)
    // [1046] fclose::cbm_k_close1_channel = ((char *)&__stdio_file+$80)[fclose::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+$80,y
    sta cbm_k_close1_channel
    // fclose::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // fclose::cbm_k_readst2
    // char status
    // [1048] fclose::cbm_k_readst2_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst2_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst2_status
    // return status;
    // [1050] fclose::cbm_k_readst2_return#0 = fclose::cbm_k_readst2_status -- vbuaa=vbum1 
    // fclose::cbm_k_readst2_@return
    // }
    // [1051] fclose::cbm_k_readst2_return#1 = fclose::cbm_k_readst2_return#0
    // fclose::@4
    // cbm_k_readst()
    // [1052] fclose::$4 = fclose::cbm_k_readst2_return#1
    // __status = cbm_k_readst()
    // [1053] ((char *)&__stdio_file+$8c)[fclose::sp#0] = fclose::$4 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+$8c,y
    // if (__status)
    // [1054] if(0==((char *)&__stdio_file+$8c)[fclose::sp#0]) goto fclose::@2 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+$8c,y
    cmp #0
    beq __b2
    // [1044] phi from fclose::@4 to fclose::@return [phi:fclose::@4->fclose::@return]
    // [1044] phi fclose::return#1 = -1 [phi:fclose::@4->fclose::@return#0] -- vwsm1=vbsc1 
    lda #<-1
    sta return
    sta return+1
    rts
    // fclose::@2
  __b2:
    // __logical = 0
    // [1055] ((char *)&__stdio_file+$80)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy sp
    sta __stdio_file+$80,y
    // __device = 0
    // [1056] ((char *)&__stdio_file+$84)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+$84,y
    // __channel = 0
    // [1057] ((char *)&__stdio_file+$88)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+$88,y
    // __filename
    // [1058] fclose::$6 = fclose::sp#0 << 2 -- vbuaa=vbum1_rol_2 
    tya
    asl
    asl
    // *__filename = '\0'
    // [1059] ((char *)&__stdio_file)[fclose::$6] = '?'pm -- pbuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #'\$00'
    sta __stdio_file,y
    // __stdio_filecount--;
    // [1060] __stdio_filecount = -- __stdio_filecount -- vbum1=_dec_vbum1 
    dec __stdio_filecount
    jmp __b3
  .segment Data
    cbm_k_chkin1_channel: .byte 0
    cbm_k_chkin1_status: .byte 0
    cbm_k_readst1_status: .byte 0
    cbm_k_close1_channel: .byte 0
    cbm_k_readst2_status: .byte 0
    .label sp = stage_copy.ew
    .label return = clrscr.ch
}
.segment CodeEngineStages
  // stage_load_player
// void stage_load_player(__zp($59) struct $35 *stage_player)
// __bank(cx16_ram, 3) 
stage_load_player: {
    .label stage_engine = $53
    .label stage_bullet = $53
    .label stage_player = $59
    // sprite_index_t player_sprite = stage_player->player_sprite
    // [1061] stage_load_player::player_sprite#0 = *((char *)stage_load_player::stage_player#0) -- vbuaa=_deref_pbuz1 
    // Loading the player sprites in bram.
    ldy #0
    lda (stage_player),y
    // fe_sprite_bram_load(player_sprite, stage.sprite_offset)
    // [1062] fe_sprite_bram_load::sprite_index#0 = stage_load_player::player_sprite#0 -- vbum1=vbuaa 
    sta fe_sprite_bram_load.sprite_index
    // [1063] fe_sprite_bram_load::sprite_offset#1 = *((unsigned int *)&stage+$25) -- vwum1=_deref_pwuc1 
    lda stage+$25
    sta fe_sprite_bram_load.sprite_offset
    lda stage+$25+1
    sta fe_sprite_bram_load.sprite_offset+1
    // [1064] call fe_sprite_bram_load
    // [1209] phi from stage_load_player to fe_sprite_bram_load [phi:stage_load_player->fe_sprite_bram_load]
    // [1209] phi __errno#104 = __errno#100 [phi:stage_load_player->fe_sprite_bram_load#0] -- register_copy 
    // [1209] phi fe_sprite_bram_load::sprite_offset#10 = fe_sprite_bram_load::sprite_offset#1 [phi:stage_load_player->fe_sprite_bram_load#1] -- register_copy 
    // [1209] phi fe_sprite_bram_load::sprite_index#10 = fe_sprite_bram_load::sprite_index#0 [phi:stage_load_player->fe_sprite_bram_load#2] -- register_copy 
    jsr fe_sprite_bram_load
    // fe_sprite_bram_load(player_sprite, stage.sprite_offset)
    // [1065] fe_sprite_bram_load::return#2 = fe_sprite_bram_load::return#0
    // stage_load_player::@1
    // [1066] stage_load_player::$0 = fe_sprite_bram_load::return#2 -- vwum1=vwum2 
    lda fe_sprite_bram_load.return
    sta stage_load_player__0
    lda fe_sprite_bram_load.return+1
    sta stage_load_player__0+1
    // stage.sprite_offset = fe_sprite_bram_load(player_sprite, stage.sprite_offset)
    // [1067] *((unsigned int *)&stage+$25) = stage_load_player::$0 -- _deref_pwuc1=vwum1 
    lda stage_load_player__0
    sta stage+$25
    lda stage_load_player__0+1
    sta stage+$25+1
    // stage_engine_t* stage_engine = stage_player->stage_engine
    // [1068] stage_load_player::stage_engine#0 = ((struct $33 **)stage_load_player::stage_player#0)[1] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #1
    lda (stage_player),y
    sta.z stage_engine
    iny
    lda (stage_player),y
    sta.z stage_engine+1
    // sprite_index_t engine_sprite = stage_engine->engine_sprite
    // [1069] stage_load_player::engine_sprite#0 = *((char *)stage_load_player::stage_engine#0) -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (stage_engine),y
    // fe_sprite_bram_load(engine_sprite, stage.sprite_offset)
    // [1070] fe_sprite_bram_load::sprite_index#1 = stage_load_player::engine_sprite#0 -- vbum1=vbuaa 
    sta fe_sprite_bram_load.sprite_index
    // [1071] fe_sprite_bram_load::sprite_offset#2 = *((unsigned int *)&stage+$25) -- vwum1=_deref_pwuc1 
    lda stage+$25
    sta fe_sprite_bram_load.sprite_offset
    lda stage+$25+1
    sta fe_sprite_bram_load.sprite_offset+1
    // [1072] call fe_sprite_bram_load
    // [1209] phi from stage_load_player::@1 to fe_sprite_bram_load [phi:stage_load_player::@1->fe_sprite_bram_load]
    // [1209] phi __errno#104 = __errno#35 [phi:stage_load_player::@1->fe_sprite_bram_load#0] -- register_copy 
    // [1209] phi fe_sprite_bram_load::sprite_offset#10 = fe_sprite_bram_load::sprite_offset#2 [phi:stage_load_player::@1->fe_sprite_bram_load#1] -- register_copy 
    // [1209] phi fe_sprite_bram_load::sprite_index#10 = fe_sprite_bram_load::sprite_index#1 [phi:stage_load_player::@1->fe_sprite_bram_load#2] -- register_copy 
    jsr fe_sprite_bram_load
    // fe_sprite_bram_load(engine_sprite, stage.sprite_offset)
    // [1073] fe_sprite_bram_load::return#3 = fe_sprite_bram_load::return#0
    // stage_load_player::@2
    // [1074] stage_load_player::$1 = fe_sprite_bram_load::return#3 -- vwum1=vwum2 
    lda fe_sprite_bram_load.return
    sta stage_load_player__1
    lda fe_sprite_bram_load.return+1
    sta stage_load_player__1+1
    // stage.sprite_offset = fe_sprite_bram_load(engine_sprite, stage.sprite_offset)
    // [1075] *((unsigned int *)&stage+$25) = stage_load_player::$1 -- _deref_pwuc1=vwum1 
    lda stage_load_player__1
    sta stage+$25
    lda stage_load_player__1+1
    sta stage+$25+1
    // stage_bullet_t* stage_bullet = stage_player->stage_bullet
    // [1076] stage_load_player::stage_bullet#0 = ((struct $34 **)stage_load_player::stage_player#0)[3] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #3
    lda (stage_player),y
    sta.z stage_bullet
    iny
    lda (stage_player),y
    sta.z stage_bullet+1
    // sprite_index_t bullet_sprite = stage_bullet->bullet_sprite
    // [1077] stage_load_player::bullet_sprite#0 = *((char *)stage_load_player::stage_bullet#0) -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (stage_bullet),y
    // fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [1078] fe_sprite_bram_load::sprite_index#2 = stage_load_player::bullet_sprite#0 -- vbum1=vbuaa 
    sta fe_sprite_bram_load.sprite_index
    // [1079] fe_sprite_bram_load::sprite_offset#3 = *((unsigned int *)&stage+$25) -- vwum1=_deref_pwuc1 
    lda stage+$25
    sta fe_sprite_bram_load.sprite_offset
    lda stage+$25+1
    sta fe_sprite_bram_load.sprite_offset+1
    // [1080] call fe_sprite_bram_load
    // [1209] phi from stage_load_player::@2 to fe_sprite_bram_load [phi:stage_load_player::@2->fe_sprite_bram_load]
    // [1209] phi __errno#104 = __errno#35 [phi:stage_load_player::@2->fe_sprite_bram_load#0] -- register_copy 
    // [1209] phi fe_sprite_bram_load::sprite_offset#10 = fe_sprite_bram_load::sprite_offset#3 [phi:stage_load_player::@2->fe_sprite_bram_load#1] -- register_copy 
    // [1209] phi fe_sprite_bram_load::sprite_index#10 = fe_sprite_bram_load::sprite_index#2 [phi:stage_load_player::@2->fe_sprite_bram_load#2] -- register_copy 
    jsr fe_sprite_bram_load
    // fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [1081] fe_sprite_bram_load::return#4 = fe_sprite_bram_load::return#0
    // stage_load_player::@3
    // [1082] stage_load_player::$2 = fe_sprite_bram_load::return#4 -- vwum1=vwum2 
    lda fe_sprite_bram_load.return
    sta stage_load_player__2
    lda fe_sprite_bram_load.return+1
    sta stage_load_player__2+1
    // stage.sprite_offset = fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [1083] *((unsigned int *)&stage+$25) = stage_load_player::$2 -- _deref_pwuc1=vwum1 
    lda stage_load_player__2
    sta stage+$25
    lda stage_load_player__2+1
    sta stage+$25+1
    // stage_load_player::@return
    // }
    // [1084] return 
    rts
  .segment DataEngineStages
    .label stage_load_player__0 = stage_logic.new_scenario
    .label stage_load_player__1 = stage_logic.new_scenario
    .label stage_load_player__2 = stage_logic.new_scenario
}
.segment CodeEngineFlight
  // flight_add
// __register(A) char flight_add(__register(X) char type, char side, __mem() char sprite)
flight_add: {
    // unsigned char f = flight.index % FLIGHT_OBJECTS
    // [1086] flight_add::f#0 = *((char *)&flight+$ad5) & $40-1 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$40-1
    and flight+$ad5
    sta f
    // [1087] phi from flight_add flight_add::@3 to flight_add::@2 [phi:flight_add/flight_add::@3->flight_add::@2]
    // [1087] phi flight_add::f#2 = flight_add::f#0 [phi:flight_add/flight_add::@3->flight_add::@2#0] -- register_copy 
    // flight_add::@2
  __b2:
    // while (!f || flight.used[f])
    // [1088] if(0==flight_add::f#2) goto flight_add::@3 -- 0_eq_vbum1_then_la1 
    lda f
    bne !__b3+
    jmp __b3
  !__b3:
    // flight_add::@8
    // [1089] if(0!=((char *)&flight+$c0)[flight_add::f#2]) goto flight_add::@3 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    tay
    lda flight+$c0,y
    cmp #0
    beq !__b3+
    jmp __b3
  !__b3:
    // flight_add::@4
    // flight.index = f
    // [1090] *((char *)&flight+$ad5) = flight_add::f#2 -- _deref_pbuc1=vbum1 
    tya
    sta flight+$ad5
    // flight_index_t r = flight.root[type]
    // [1091] flight_add::r#0 = ((char *)&flight+$ac1)[flight_add::type#6] -- vbum1=pbuc1_derefidx_vbuxx 
    // p.r = 3 => f[3].n = 2, f[2].n = 1, f[1].n = -
    //         => f[3].p = -, f[2].p = 3, f[1].p = 2
    // Add 4
    // p.r = 4 => f[4].n = 3, f[3].n = 2, f[2].n = 1, f[1].n = -
    // p.r = 4 => f[4].p = -, f[3].p = 4, f[2].p = 3, f[1].p = 2
    lda flight+$ac1,x
    sta r
    // flight.next[f] = r
    // [1092] ((char *)&flight+$a41)[flight_add::f#2] = flight_add::r#0 -- pbuc1_derefidx_vbum1=vbum2 
    sta flight+$a41,y
    // flight.prev[f] = NULL
    // [1093] ((char *)&flight+$a81)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta flight+$a81,y
    // if (r)
    // [1094] if(0==flight_add::r#0) goto flight_add::@1 -- 0_eq_vbum1_then_la1 
    lda r
    beq __b1
    // flight_add::@5
    // flight.prev[r] = f
    // [1095] ((char *)&flight+$a81)[flight_add::r#0] = flight_add::f#2 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy r
    sta flight+$a81,y
    // flight_add::@1
  __b1:
    // flight.root[type] = f
    // [1096] ((char *)&flight+$ac1)[flight_add::type#6] = flight_add::f#2 -- pbuc1_derefidx_vbuxx=vbum1 
    lda f
    sta flight+$ac1,x
    // flight.count[type]++;
    // [1097] ((char *)&flight+$acb)[flight_add::type#6] = ++ ((char *)&flight+$acb)[flight_add::type#6] -- pbuc1_derefidx_vbuxx=_inc_pbuc1_derefidx_vbuxx 
    inc flight+$acb,x
    // flight.type[f] = type
    // [1098] ((char *)&flight+$180)[flight_add::f#2] = flight_add::type#6 -- pbuc1_derefidx_vbum1=vbuxx 
    tay
    txa
    sta flight+$180,y
    // flight.side[f] = side
    // [1099] ((char *)&flight+$1c0)[flight_add::f#2] = 2 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #2
    sta flight+$1c0,y
    // flight.used[f] = 1
    // [1100] ((char *)&flight+$c0)[flight_add::f#2] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    sta flight+$c0,y
    // flight.enabled[f] = 0
    // [1101] ((char *)&flight+$100)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta flight+$100,y
    // flight.move[f] = 0
    // [1102] ((char *)&flight+$580)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$580,y
    // flight.moved[f] = 0
    // [1103] ((char *)&flight+$5c0)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$5c0,y
    // flight.moving[f] = 0
    // [1104] flight_add::$12 = flight_add::f#2 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta flight_add__12
    // [1105] ((unsigned int *)&flight+$600)[flight_add::$12] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy flight_add__12
    sta flight+$600,y
    sta flight+$600+1,y
    // flight.angle[f] = 0
    // [1106] ((char *)&flight+$780)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    ldy f
    sta flight+$780,y
    // flight.speed[f] = 0
    // [1107] ((char *)&flight+$7c0)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$7c0,y
    // flight.action[f] = 0
    // [1108] ((char *)&flight+$940)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$940,y
    // flight.turn[f] = 0
    // [1109] ((char *)&flight+$800)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$800,y
    // flight.radius[f] = 0
    // [1110] ((char *)&flight+$840)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$840,y
    // flight.reload[f] = 0
    // [1111] ((char *)&flight+$740)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$740,y
    // flight.delay[f] = 0
    // [1112] ((char *)&flight+$680)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$680,y
    // unsigned char s = fe_sprite_cache_copy(sprite)
    // [1113] fe_sprite_cache_copy::sprite_index#0 = flight_add::sprite#6
    // [1114] call fe_sprite_cache_copy
    // [1284] phi from flight_add::@1 to fe_sprite_cache_copy [phi:flight_add::@1->fe_sprite_cache_copy]
    jsr fe_sprite_cache_copy
    // unsigned char s = fe_sprite_cache_copy(sprite)
    // [1115] fe_sprite_cache_copy::return#0 = fe_sprite_cache_copy::c#2 -- vbuaa=vbum1 
    lda fe_sprite_cache_copy.c
    // flight_add::@6
    // [1116] flight_add::s#0 = fe_sprite_cache_copy::return#0 -- vbum1=vbuaa 
    sta s
    // flight.cache[f] = s
    // [1117] ((char *)&flight)[flight_add::f#2] = flight_add::s#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy f
    sta flight,y
    // flight_sprite_next_offset()
    // [1118] call flight_sprite_next_offset
    // [1330] phi from flight_add::@6 to flight_sprite_next_offset [phi:flight_add::@6->flight_sprite_next_offset]
    jsr flight_sprite_next_offset
    // flight_sprite_next_offset()
    // [1119] flight_sprite_next_offset::return#0 = flight_sprite_next_offset::vera_sprite_get_offset1_return#0 -- vwum1=vwum2 
    lda flight_sprite_next_offset.vera_sprite_get_offset1_return
    sta flight_sprite_next_offset.return
    lda flight_sprite_next_offset.vera_sprite_get_offset1_return+1
    sta flight_sprite_next_offset.return+1
    // flight_add::@7
    // [1120] flight_add::$4 = flight_sprite_next_offset::return#0
    // flight.sprite_offset[f] = flight_sprite_next_offset()
    // [1121] ((unsigned int *)&flight+$40)[flight_add::$12] = flight_add::$4 -- pwuc1_derefidx_vbum1=vwum2 
    ldy flight_add__12
    lda flight_add__4
    sta flight+$40,y
    lda flight_add__4+1
    sta flight+$40+1,y
    // fe_sprite_configure(flight.sprite_offset[f], s)
    // [1122] fe_sprite_configure::sprite_offset#0 = ((unsigned int *)&flight+$40)[flight_add::$12] -- vwum1=pwuc1_derefidx_vbum2 
    lda flight+$40,y
    sta fe_sprite_configure.sprite_offset
    lda flight+$40+1,y
    sta fe_sprite_configure.sprite_offset+1
    // [1123] fe_sprite_configure::s#0 = flight_add::s#0 -- vbuyy=vbum1 
    ldy s
    // [1124] call fe_sprite_configure
    jsr fe_sprite_configure
    // flight_add::@return
    // }
    // [1125] return 
    rts
    // flight_add::@3
  __b3:
    // f + 1
    // [1126] flight_add::$8 = flight_add::f#2 + 1 -- vbuaa=vbum1_plus_1 
    lda f
    inc
    // f = (f + 1) % FLIGHT_OBJECTS
    // [1127] flight_add::f#1 = flight_add::$8 & $40-1 -- vbum1=vbuaa_band_vbuc1 
    and #$40-1
    sta f
    jmp __b2
  .segment DataEngineFlight
    .label flight_add__4 = fe_sprite_bram_load.return
    flight_add__12: .byte 0
    f: .byte 0
    .label r = fe_sprite_bram_load.sprite_index
    .label s = sprite
    sprite: .byte 0
}
.segment Code
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __mem() unsigned int strlen(__zp($26) char *str)
strlen: {
    .label str = $26
    // [1129] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [1129] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta len
    sta len+1
    // [1129] phi strlen::str#4 = strlen::str#6 [phi:strlen->strlen::@1#1] -- register_copy 
    // strlen::@1
  __b1:
    // while(*str)
    // [1130] if(0!=*strlen::str#4) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [1131] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [1132] strlen::len#1 = ++ strlen::len#2 -- vwum1=_inc_vwum1 
    inc len
    bne !+
    inc len+1
  !:
    // str++;
    // [1133] strlen::str#1 = ++ strlen::str#4 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [1129] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [1129] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [1129] phi strlen::str#4 = strlen::str#1 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label return = clrscr.ch
    .label len = clrscr.ch
}
.segment Code
  // cbm_k_setlfs
/**
 * @brief Sets the logical file channel.
 *
 * @param channel the logical file number.
 * @param device the device number.
 * @param command the command.
 */
// void cbm_k_setlfs(__mem() volatile char channel, __mem() volatile char device, __mem() volatile char command)
cbm_k_setlfs: {
    // asm
    // asm { ldxdevice ldachannel ldycommand jsrCBM_SETLFS  }
    ldx device
    lda channel
    ldy command
    jsr CBM_SETLFS
    // cbm_k_setlfs::@return
    // }
    // [1135] return 
    rts
  .segment Data
    channel: .byte 0
    device: .byte 0
    command: .byte 0
}
.segment Code
  // ferror
/**
 * @brief POSIX equivalent of ferror for the CBM C language.
 * This routine reads from secondary 15 the error message from the device!
 * The result is an error string, including the error code, message, track, sector.
 * The error string can be a maximum of 32 characters.
 *
 * @param stream FILE* stream.
 * @return int Contains a non-zero value if there is an error.
 */
// __mem() int ferror(__zp($3d) struct $2 *stream)
ferror: {
    .label cbm_k_setnam1_filename = $33
    .label stream = $3d
    .label errno_len = $46
    // unsigned char sp = (unsigned char)stream
    // [1136] ferror::sp#0 = (char)ferror::stream#0 -- vbum1=_byte_pssz2 
    lda.z stream
    sta sp
    // cbm_k_setlfs(15, 8, 15)
    // [1137] cbm_k_setlfs::channel = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_setlfs.channel
    // [1138] cbm_k_setlfs::device = 8 -- vbum1=vbuc1 
    lda #8
    sta cbm_k_setlfs.device
    // [1139] cbm_k_setlfs::command = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_setlfs.command
    // [1140] call cbm_k_setlfs
    jsr cbm_k_setlfs
    // ferror::@11
    // cbm_k_setnam("")
    // [1141] ferror::cbm_k_setnam1_filename = ferror::$18 -- pbuz1=pbuc1 
    lda #<ferror__18
    sta.z cbm_k_setnam1_filename
    lda #>ferror__18
    sta.z cbm_k_setnam1_filename+1
    // ferror::cbm_k_setnam1
    // strlen(filename)
    // [1142] strlen::str#3 = ferror::cbm_k_setnam1_filename -- pbuz1=pbuz2 
    lda.z cbm_k_setnam1_filename
    sta.z strlen.str
    lda.z cbm_k_setnam1_filename+1
    sta.z strlen.str+1
    // [1143] call strlen
    // [1128] phi from ferror::cbm_k_setnam1 to strlen [phi:ferror::cbm_k_setnam1->strlen]
    // [1128] phi strlen::str#6 = strlen::str#3 [phi:ferror::cbm_k_setnam1->strlen#0] -- register_copy 
    jsr strlen
    // strlen(filename)
    // [1144] strlen::return#4 = strlen::len#2
    // ferror::@12
    // [1145] ferror::cbm_k_setnam1_$0 = strlen::return#4
    // char filename_len = (char)strlen(filename)
    // [1146] ferror::cbm_k_setnam1_filename_len = (char)ferror::cbm_k_setnam1_$0 -- vbum1=_byte_vwum2 
    lda cbm_k_setnam1_ferror__0
    sta cbm_k_setnam1_filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx cbm_k_setnam1_filename
    ldy cbm_k_setnam1_filename+1
    jsr CBM_SETNAM
    // ferror::cbm_k_open1
    // asm { jsrCBM_OPEN  }
    jsr CBM_OPEN
    // ferror::@6
    // cbm_k_chkin(15)
    // [1149] ferror::cbm_k_chkin1_channel = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_chkin1_channel
    // ferror::cbm_k_chkin1
    // char status
    // [1150] ferror::cbm_k_chkin1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // ferror::cbm_k_chrin1
    // char ch
    // [1152] ferror::cbm_k_chrin1_ch = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chrin1_ch
    // asm
    // asm { jsrCBM_CHRIN stach  }
    jsr CBM_CHRIN
    sta cbm_k_chrin1_ch
    // return ch;
    // [1154] ferror::cbm_k_chrin1_return#0 = ferror::cbm_k_chrin1_ch -- vbuaa=vbum1 
    // ferror::cbm_k_chrin1_@return
    // }
    // [1155] ferror::cbm_k_chrin1_return#1 = ferror::cbm_k_chrin1_return#0
    // ferror::@7
    // char ch = cbm_k_chrin()
    // [1156] ferror::ch#0 = ferror::cbm_k_chrin1_return#1 -- vbum1=vbuaa 
    sta ch
    // [1157] phi from ferror::@7 to ferror::cbm_k_readst1 [phi:ferror::@7->ferror::cbm_k_readst1]
    // [1157] phi __errno#100 = __errno#201 [phi:ferror::@7->ferror::cbm_k_readst1#0] -- register_copy 
    // [1157] phi ferror::errno_len#10 = 0 [phi:ferror::@7->ferror::cbm_k_readst1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z errno_len
    // [1157] phi ferror::ch#10 = ferror::ch#0 [phi:ferror::@7->ferror::cbm_k_readst1#2] -- register_copy 
    // [1157] phi ferror::errno_parsed#2 = 0 [phi:ferror::@7->ferror::cbm_k_readst1#3] -- vbum1=vbuc1 
    sta errno_parsed
    // ferror::cbm_k_readst1
  cbm_k_readst1:
    // char status
    // [1158] ferror::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [1160] ferror::cbm_k_readst1_return#0 = ferror::cbm_k_readst1_status -- vbuaa=vbum1 
    // ferror::cbm_k_readst1_@return
    // }
    // [1161] ferror::cbm_k_readst1_return#1 = ferror::cbm_k_readst1_return#0
    // ferror::@8
    // cbm_k_readst()
    // [1162] ferror::$6 = ferror::cbm_k_readst1_return#1
    // st = cbm_k_readst()
    // [1163] ferror::st#1 = ferror::$6
    // while (!(st = cbm_k_readst()))
    // [1164] if(0==ferror::st#1) goto ferror::@1 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b1
    // ferror::@2
    // __status = st
    // [1165] ((char *)&__stdio_file+$8c)[ferror::sp#0] = ferror::st#1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+$8c,y
    // cbm_k_close(15)
    // [1166] ferror::cbm_k_close1_channel = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_close1_channel
    // ferror::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // ferror::@9
    // return __errno;
    // [1168] ferror::return#1 = __errno#100 -- vwsm1=vwsm2 
    lda __errno
    sta return
    lda __errno+1
    sta return+1
    // ferror::@return
    // }
    // [1169] return 
    rts
    // ferror::@1
  __b1:
    // if (!errno_parsed)
    // [1170] if(0!=ferror::errno_parsed#2) goto ferror::@3 -- 0_neq_vbum1_then_la1 
    lda errno_parsed
    bne __b3
    // ferror::@4
    // if (ch == ',')
    // [1171] if(ferror::ch#10!=','pm) goto ferror::@3 -- vbum1_neq_vbuc1_then_la1 
    lda #','
    cmp ch
    bne __b3
    // ferror::@5
    // errno_parsed++;
    // [1172] ferror::errno_parsed#1 = ++ ferror::errno_parsed#2 -- vbum1=_inc_vbum1 
    inc errno_parsed
    // strncpy(temp, __errno_error, errno_len+1)
    // [1173] strncpy::n#0 = ferror::errno_len#10 + 1 -- vwum1=vbuz2_plus_1 
    lda.z errno_len
    clc
    adc #1
    sta strncpy.n
    lda #0
    adc #0
    sta strncpy.n+1
    // [1174] call strncpy
    // [1382] phi from ferror::@5 to strncpy [phi:ferror::@5->strncpy]
    jsr strncpy
    // [1175] phi from ferror::@5 to ferror::@13 [phi:ferror::@5->ferror::@13]
    // ferror::@13
    // atoi(temp)
    // [1176] call atoi
    // [1188] phi from ferror::@13 to atoi [phi:ferror::@13->atoi]
    // [1188] phi atoi::str#2 = ferror::temp [phi:ferror::@13->atoi#0] -- pbuz1=pbuc1 
    lda #<temp
    sta.z atoi.str
    lda #>temp
    sta.z atoi.str+1
    jsr atoi
    // atoi(temp)
    // [1177] atoi::return#4 = atoi::return#2
    // ferror::@14
    // __errno = atoi(temp)
    // [1178] __errno#2 = atoi::return#4 -- vwsm1=vwsm2 
    lda atoi.return
    sta __errno
    lda atoi.return+1
    sta __errno+1
    // [1179] phi from ferror::@1 ferror::@14 ferror::@4 to ferror::@3 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3]
    // [1179] phi __errno#124 = __errno#100 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3#0] -- register_copy 
    // [1179] phi ferror::errno_parsed#11 = ferror::errno_parsed#2 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3#1] -- register_copy 
    // ferror::@3
  __b3:
    // __errno_error[errno_len] = ch
    // [1180] __errno_error[ferror::errno_len#10] = ferror::ch#10 -- pbuc1_derefidx_vbuz1=vbum2 
    lda ch
    ldy.z errno_len
    sta __errno_error,y
    // errno_len++;
    // [1181] ferror::errno_len#1 = ++ ferror::errno_len#10 -- vbuz1=_inc_vbuz1 
    inc.z errno_len
    // ferror::cbm_k_chrin2
    // char ch
    // [1182] ferror::cbm_k_chrin2_ch = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chrin2_ch
    // asm
    // asm { jsrCBM_CHRIN stach  }
    jsr CBM_CHRIN
    sta cbm_k_chrin2_ch
    // return ch;
    // [1184] ferror::cbm_k_chrin2_return#0 = ferror::cbm_k_chrin2_ch -- vbuaa=vbum1 
    // ferror::cbm_k_chrin2_@return
    // }
    // [1185] ferror::cbm_k_chrin2_return#1 = ferror::cbm_k_chrin2_return#0
    // ferror::@10
    // cbm_k_chrin()
    // [1186] ferror::$15 = ferror::cbm_k_chrin2_return#1
    // ch = cbm_k_chrin()
    // [1187] ferror::ch#1 = ferror::$15 -- vbum1=vbuaa 
    sta ch
    // [1157] phi from ferror::@10 to ferror::cbm_k_readst1 [phi:ferror::@10->ferror::cbm_k_readst1]
    // [1157] phi __errno#100 = __errno#124 [phi:ferror::@10->ferror::cbm_k_readst1#0] -- register_copy 
    // [1157] phi ferror::errno_len#10 = ferror::errno_len#1 [phi:ferror::@10->ferror::cbm_k_readst1#1] -- register_copy 
    // [1157] phi ferror::ch#10 = ferror::ch#1 [phi:ferror::@10->ferror::cbm_k_readst1#2] -- register_copy 
    // [1157] phi ferror::errno_parsed#2 = ferror::errno_parsed#11 [phi:ferror::@10->ferror::cbm_k_readst1#3] -- register_copy 
    jmp cbm_k_readst1
  .segment Data
    temp: .fill 4, 0
    ferror__18: .text ""
    .byte 0
    cbm_k_setnam1_filename_len: .byte 0
    .label cbm_k_setnam1_ferror__0 = clrscr.ch
    cbm_k_chkin1_channel: .byte 0
    cbm_k_chkin1_status: .byte 0
    cbm_k_chrin1_ch: .byte 0
    cbm_k_readst1_status: .byte 0
    cbm_k_close1_channel: .byte 0
    cbm_k_chrin2_ch: .byte 0
    .label return = clrscr.ch
    sp: .byte 0
    ch: .byte 0
    errno_parsed: .byte 0
}
.segment Code
  // atoi
// Converts the string argument str to an integer.
// __mem() int atoi(__zp($22) const char *str)
atoi: {
    .label str = $22
    // if (str[i] == '-')
    // [1189] if(*atoi::str#2!='-'pm) goto atoi::@3 -- _deref_pbuz1_neq_vbuc1_then_la1 
    ldy #0
    lda (str),y
    cmp #'-'
    bne __b2
    // [1190] phi from atoi to atoi::@2 [phi:atoi->atoi::@2]
    // atoi::@2
    // [1191] phi from atoi::@2 to atoi::@3 [phi:atoi::@2->atoi::@3]
    // [1191] phi atoi::negative#2 = 1 [phi:atoi::@2->atoi::@3#0] -- vbuxx=vbuc1 
    ldx #1
    // [1191] phi atoi::res#2 = 0 [phi:atoi::@2->atoi::@3#1] -- vwsm1=vwsc1 
    tya
    sta res
    sta res+1
    // [1191] phi atoi::i#4 = 1 [phi:atoi::@2->atoi::@3#2] -- vbuyy=vbuc1 
    ldy #1
    jmp __b3
  // Iterate through all digits and update the result
    // [1191] phi from atoi to atoi::@3 [phi:atoi->atoi::@3]
  __b2:
    // [1191] phi atoi::negative#2 = 0 [phi:atoi->atoi::@3#0] -- vbuxx=vbuc1 
    ldx #0
    // [1191] phi atoi::res#2 = 0 [phi:atoi->atoi::@3#1] -- vwsm1=vwsc1 
    txa
    sta res
    sta res+1
    // [1191] phi atoi::i#4 = 0 [phi:atoi->atoi::@3#2] -- vbuyy=vbuc1 
    tay
    // atoi::@3
  __b3:
    // for (; str[i]>='0' && str[i]<='9'; ++i)
    // [1192] if(atoi::str#2[atoi::i#4]<'0'pm) goto atoi::@5 -- pbuz1_derefidx_vbuyy_lt_vbuc1_then_la1 
    lda (str),y
    cmp #'0'
    bcc __b5
    // atoi::@6
    // [1193] if(atoi::str#2[atoi::i#4]<='9'pm) goto atoi::@4 -- pbuz1_derefidx_vbuyy_le_vbuc1_then_la1 
    lda (str),y
    cmp #'9'
    bcc __b4
    beq __b4
    // atoi::@5
  __b5:
    // if(negative)
    // [1194] if(0!=atoi::negative#2) goto atoi::@1 -- 0_neq_vbuxx_then_la1 
    // Return result with sign
    cpx #0
    bne __b1
    // [1196] phi from atoi::@1 atoi::@5 to atoi::@return [phi:atoi::@1/atoi::@5->atoi::@return]
    // [1196] phi atoi::return#2 = atoi::return#0 [phi:atoi::@1/atoi::@5->atoi::@return#0] -- register_copy 
    rts
    // atoi::@1
  __b1:
    // return -res;
    // [1195] atoi::return#0 = - atoi::res#2 -- vwsm1=_neg_vwsm1 
    lda #0
    sec
    sbc return
    sta return
    lda #0
    sbc return+1
    sta return+1
    // atoi::@return
    // }
    // [1197] return 
    rts
    // atoi::@4
  __b4:
    // res * 10
    // [1198] atoi::$10 = atoi::res#2 << 2 -- vwsm1=vwsm2_rol_2 
    lda res
    asl
    sta atoi__10
    lda res+1
    rol
    sta atoi__10+1
    asl atoi__10
    rol atoi__10+1
    // [1199] atoi::$11 = atoi::$10 + atoi::res#2 -- vwsm1=vwsm2_plus_vwsm1 
    clc
    lda atoi__11
    adc atoi__10
    sta atoi__11
    lda atoi__11+1
    adc atoi__10+1
    sta atoi__11+1
    // [1200] atoi::$6 = atoi::$11 << 1 -- vwsm1=vwsm1_rol_1 
    asl atoi__6
    rol atoi__6+1
    // res * 10 + str[i]
    // [1201] atoi::$7 = atoi::$6 + atoi::str#2[atoi::i#4] -- vwsm1=vwsm1_plus_pbuz2_derefidx_vbuyy 
    lda atoi__7
    clc
    adc (str),y
    sta atoi__7
    bcc !+
    inc atoi__7+1
  !:
    // res = res * 10 + str[i] - '0'
    // [1202] atoi::res#1 = atoi::$7 - '0'pm -- vwsm1=vwsm1_minus_vbuc1 
    lda res
    sec
    sbc #'0'
    sta res
    bcs !+
    dec res+1
  !:
    // for (; str[i]>='0' && str[i]<='9'; ++i)
    // [1203] atoi::i#2 = ++ atoi::i#4 -- vbuyy=_inc_vbuyy 
    iny
    // [1191] phi from atoi::@4 to atoi::@3 [phi:atoi::@4->atoi::@3]
    // [1191] phi atoi::negative#2 = atoi::negative#2 [phi:atoi::@4->atoi::@3#0] -- register_copy 
    // [1191] phi atoi::res#2 = atoi::res#1 [phi:atoi::@4->atoi::@3#1] -- register_copy 
    // [1191] phi atoi::i#4 = atoi::i#2 [phi:atoi::@4->atoi::@3#2] -- register_copy 
    jmp __b3
  .segment Data
    .label atoi__6 = clrscr.ch
    .label atoi__7 = clrscr.ch
    .label res = clrscr.ch
    .label return = clrscr.ch
    .label atoi__10 = fgets.remaining
    .label atoi__11 = clrscr.ch
}
.segment Code
  // cx16_k_macptr
/**
 * @brief Read a number of bytes from the sdcard using kernal macptr call.
 * BRAM bank needs to be set properly before the load between adressed A000 and BFFF.
 *
 * @return x the size of bytes read
 * @return y the size of bytes read
 * @return if carry is set there is an error
 */
// __mem() unsigned int cx16_k_macptr(__mem() volatile char bytes, __zp($24) void * volatile buffer)
cx16_k_macptr: {
    .label buffer = $24
    // unsigned int bytes_read
    // [1204] cx16_k_macptr::bytes_read = 0 -- vwum1=vwuc1 
    lda #<0
    sta bytes_read
    sta bytes_read+1
    // asm
    // asm { ldabytes ldxbuffer ldybuffer+1 clc jsrCX16_MACPTR stxbytes_read stybytes_read+1 bcc!+ lda#$FF stabytes_read stabytes_read+1 !:  }
    lda bytes
    ldx buffer
    ldy buffer+1
    clc
    jsr CX16_MACPTR
    stx bytes_read
    sty bytes_read+1
    bcc !+
    lda #$ff
    sta bytes_read
    sta bytes_read+1
  !:
    // return bytes_read;
    // [1206] cx16_k_macptr::return#0 = cx16_k_macptr::bytes_read -- vwum1=vwum2 
    lda bytes_read
    sta return
    lda bytes_read+1
    sta return+1
    // cx16_k_macptr::@return
    // }
    // [1207] cx16_k_macptr::return#1 = cx16_k_macptr::return#0
    // [1208] return 
    rts
  .segment Data
    bytes: .byte 0
    bytes_read: .word 0
    .label return = fgets.bytes
}
.segment CodeEngineFlight
  // fe_sprite_bram_load
// Load the sprite into bram using the new cx16 heap manager.
// __mem() unsigned int fe_sprite_bram_load(__mem() char sprite_index, __mem() unsigned int sprite_offset)
fe_sprite_bram_load: {
    .const bank_push_set_bram1_bank = 4
    .const bank_push_set_bram2_bank = 6
    .label fp = $57
    .label palette_ptr = $39
    .label sprite_ptr = $39
    .label fe_sprite_bram_load__34 = $39
    // fe_sprite_bram_load::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [1211] BRAM = fe_sprite_bram_load::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // fe_sprite_bram_load::@10
    // if (!sprites.loaded[sprite_index])
    // [1212] if(0!=((char *)&sprites+$40)[fe_sprite_bram_load::sprite_index#10]) goto fe_sprite_bram_load::bank_pull_bram1 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sprite_index
    lda sprites+$40,y
    cmp #0
    beq !bank_pull_bram1+
    jmp bank_pull_bram1
  !bank_pull_bram1:
    // fe_sprite_bram_load::@1
    // strcpy(filename, sprites.file[sprite_index])
    // [1213] fe_sprite_bram_load::$27 = fe_sprite_bram_load::sprite_index#10 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta fe_sprite_bram_load__27
    // [1214] strcpy::source#1 = ((char **)&sprites)[fe_sprite_bram_load::$27] -- pbuz1=qbuc1_derefidx_vbum2 
    tay
    lda sprites,y
    sta.z strcpy.source
    lda sprites+1,y
    sta.z strcpy.source+1
    // [1215] call strcpy
    // [1393] phi from fe_sprite_bram_load::@1 to strcpy [phi:fe_sprite_bram_load::@1->strcpy]
    // [1393] phi strcpy::dst#0 = fe_sprite_bram_load::filename [phi:fe_sprite_bram_load::@1->strcpy#0] -- pbuz1=pbuc1 
    lda #<filename
    sta.z strcpy.dst
    lda #>filename
    sta.z strcpy.dst+1
    // [1393] phi strcpy::src#0 = strcpy::source#1 [phi:fe_sprite_bram_load::@1->strcpy#1] -- register_copy 
    jsr strcpy
    // [1216] phi from fe_sprite_bram_load::@1 to fe_sprite_bram_load::@15 [phi:fe_sprite_bram_load::@1->fe_sprite_bram_load::@15]
    // fe_sprite_bram_load::@15
    // strcat(filename, ".bin")
    // [1217] call strcat
    // [1401] phi from fe_sprite_bram_load::@15 to strcat [phi:fe_sprite_bram_load::@15->strcat]
    jsr strcat
    // [1218] phi from fe_sprite_bram_load::@15 to fe_sprite_bram_load::@16 [phi:fe_sprite_bram_load::@15->fe_sprite_bram_load::@16]
    // fe_sprite_bram_load::@16
    // FILE *fp = fopen(filename, "r")
    // [1219] call fopen
    // [897] phi from fe_sprite_bram_load::@16 to fopen [phi:fe_sprite_bram_load::@16->fopen]
    // [897] phi __errno#201 = __errno#104 [phi:fe_sprite_bram_load::@16->fopen#0] -- register_copy 
    // [897] phi fopen::pathtoken#0 = fe_sprite_bram_load::filename [phi:fe_sprite_bram_load::@16->fopen#1] -- pbuz1=pbuc1 
    lda #<filename
    sta.z fopen.pathtoken
    lda #>filename
    sta.z fopen.pathtoken+1
    jsr fopen
    // FILE *fp = fopen(filename, "r")
    // [1220] fopen::return#4 = fopen::return#2
    // fe_sprite_bram_load::@17
    // [1221] fe_sprite_bram_load::fp#0 = fopen::return#4 -- pssz1=pssz2 
    lda.z fopen.return
    sta.z fp
    lda.z fopen.return+1
    sta.z fp+1
    // if (!fp)
    // [1222] if((struct $2 *)0==fe_sprite_bram_load::fp#0) goto fe_sprite_bram_load::bank_pull_bram1 -- pssc1_eq_pssz1_then_la1 
    lda.z fp
    cmp #<0
    bne !+
    lda.z fp+1
    cmp #>0
    bne !bank_pull_bram1+
    jmp bank_pull_bram1
  !bank_pull_bram1:
  !:
    // fe_sprite_bram_load::@2
    // sprite_file_header_t sprite_file_header
    // [1223] *(&fe_sprite_bram_load::sprite_file_header) = memset(struct $19, SIZEOF_STRUCT_$19) -- _deref_pssc1=_memset_vbuc2 
    ldy #SIZEOF_STRUCT___19
    lda #0
  !:
    dey
    sta sprite_file_header,y
    bne !-
    // unsigned int read = fgets((char *)&sprite_file_header, sizeof(sprite_file_header_t), fp)
    // [1224] fgets::stream#1 = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fgets.stream
    lda.z fp+1
    sta.z fgets.stream+1
    // [1225] call fgets
  // Read the header of the file into the sprite_file_header structure.
    // [978] phi from fe_sprite_bram_load::@2 to fgets [phi:fe_sprite_bram_load::@2->fgets]
    // [978] phi fgets::ptr#14 = (char *)&fe_sprite_bram_load::sprite_file_header [phi:fe_sprite_bram_load::@2->fgets#0] -- pbuz1=pbuc1 
    lda #<sprite_file_header
    sta.z fgets.ptr
    lda #>sprite_file_header
    sta.z fgets.ptr+1
    // [978] phi fgets::size#10 = $10 [phi:fe_sprite_bram_load::@2->fgets#1] -- vwum1=vbuc1 
    lda #<$10
    sta fgets.size
    lda #>$10
    sta fgets.size+1
    // [978] phi fgets::stream#4 = fgets::stream#1 [phi:fe_sprite_bram_load::@2->fgets#2] -- register_copy 
    jsr fgets
    // unsigned int read = fgets((char *)&sprite_file_header, sizeof(sprite_file_header_t), fp)
    // [1226] fgets::return#11 = fgets::return#1
    // fe_sprite_bram_load::@18
    // [1227] fe_sprite_bram_load::read#0 = fgets::return#11 -- vwum1=vwum2 
    lda fgets.return
    sta read
    lda fgets.return+1
    sta read+1
    // if (!read)
    // [1228] if(0==fe_sprite_bram_load::read#0) goto fe_sprite_bram_load::bank_pull_bram1 -- 0_eq_vwum1_then_la1 
    lda read
    ora read+1
    bne !bank_pull_bram1+
    jmp bank_pull_bram1
  !bank_pull_bram1:
    // fe_sprite_bram_load::@3
    // sprite_map_header(&sprite_file_header, sprite_index)
    // [1229] sprite_map_header::sprite#0 = fe_sprite_bram_load::sprite_index#10 -- vbum1=vbum2 
    lda sprite_index
    sta sprite_map_header.sprite
    // [1230] call sprite_map_header
    jsr sprite_map_header
    // [1231] phi from fe_sprite_bram_load::@3 to fe_sprite_bram_load::@19 [phi:fe_sprite_bram_load::@3->fe_sprite_bram_load::@19]
    // fe_sprite_bram_load::@19
    // palette_index_t palette_index = palette_alloc_bram()
    // [1232] callexecute palette_alloc_bram  -- call_var_near 
    jsr lib_palette.palette_alloc_bram
    // [1233] fe_sprite_bram_load::palette_index#0 = palette_alloc_bram::return -- vbum1=vbuz2 
    lda.z lib_palette.palette_alloc_bram.return
    sta palette_index
    // palette_ptr_t palette_ptr = palette_ptr_bram(palette_index)
    // [1234] palette_ptr_bram::palette_index = fe_sprite_bram_load::palette_index#0 -- vbuz1=vbum2 
    sta.z lib_palette.palette_ptr_bram.palette_index
    // [1235] callexecute palette_ptr_bram  -- call_var_near 
    jsr lib_palette.palette_ptr_bram
    // [1236] fe_sprite_bram_load::palette_ptr#0 = palette_ptr_bram::return -- pssz1=pssz2 
    lda.z lib_palette.palette_ptr_bram.return
    sta.z palette_ptr
    lda.z lib_palette.palette_ptr_bram.return+1
    sta.z palette_ptr+1
    // fe_sprite_bram_load::bank_push_set_bram2
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [1238] BRAM = fe_sprite_bram_load::bank_push_set_bram2_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram2_bank
    sta.z BRAM
    // fe_sprite_bram_load::@11
    // fgets((char *)palette_ptr, 32, fp)
    // [1239] fgets::ptr#4 = (char *)fe_sprite_bram_load::palette_ptr#0 -- pbuz1=pbuz2 
    lda.z palette_ptr
    sta.z fgets.ptr
    lda.z palette_ptr+1
    sta.z fgets.ptr+1
    // [1240] fgets::stream#2 = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fgets.stream
    lda.z fp+1
    sta.z fgets.stream+1
    // [1241] call fgets
    // [978] phi from fe_sprite_bram_load::@11 to fgets [phi:fe_sprite_bram_load::@11->fgets]
    // [978] phi fgets::ptr#14 = fgets::ptr#4 [phi:fe_sprite_bram_load::@11->fgets#0] -- register_copy 
    // [978] phi fgets::size#10 = $20 [phi:fe_sprite_bram_load::@11->fgets#1] -- vwum1=vbuc1 
    lda #<$20
    sta fgets.size
    lda #>$20
    sta fgets.size+1
    // [978] phi fgets::stream#4 = fgets::stream#2 [phi:fe_sprite_bram_load::@11->fgets#2] -- register_copy 
    jsr fgets
    // fe_sprite_bram_load::bank_pull_bram2
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_bram_load::@12
    // sprites.PaletteOffset[sprite_index] = palette_index
    // [1243] ((char *)&sprites+$180)[fe_sprite_bram_load::sprite_index#10] = fe_sprite_bram_load::palette_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda palette_index
    ldy sprite_index
    sta sprites+$180,y
    // sprites.offset[sprite_index] = sprite_offset
    // [1244] ((unsigned int *)&sprites+$240)[fe_sprite_bram_load::$27] = fe_sprite_bram_load::sprite_offset#10 -- pwuc1_derefidx_vbum1=vwum2 
    ldy fe_sprite_bram_load__27
    lda sprite_offset
    sta sprites+$240,y
    lda sprite_offset+1
    sta sprites+$240+1,y
    // unsigned int sprite_size = sprites.SpriteSize[sprite_index]
    // [1245] fe_sprite_bram_load::sprite_size#0 = ((unsigned int *)&sprites+$80)[fe_sprite_bram_load::$27] -- vwum1=pwuc1_derefidx_vbum2 
    lda sprites+$80,y
    sta sprite_size
    lda sprites+$80+1,y
    sta sprite_size+1
    // [1246] phi from fe_sprite_bram_load::@12 to fe_sprite_bram_load::@4 [phi:fe_sprite_bram_load::@12->fe_sprite_bram_load::@4]
    // [1246] phi fe_sprite_bram_load::sprite_offset#13 = fe_sprite_bram_load::sprite_offset#10 [phi:fe_sprite_bram_load::@12->fe_sprite_bram_load::@4#0] -- register_copy 
    // [1246] phi fe_sprite_bram_load::s#10 = 0 [phi:fe_sprite_bram_load::@12->fe_sprite_bram_load::@4#1] -- vbum1=vbuc1 
    lda #0
    sta s
    // fe_sprite_bram_load::@4
  __b4:
    // for (unsigned char s = 0; s < sprites.count[sprite_index]; s++)
    // [1247] if(fe_sprite_bram_load::s#10<((char *)&sprites+$60)[fe_sprite_bram_load::sprite_index#10]) goto fe_sprite_bram_load::@5 -- vbum1_lt_pbuc1_derefidx_vbum2_then_la1 
    lda s
    ldy sprite_index
    cmp sprites+$60,y
    bcc __b5
    // fe_sprite_bram_load::@6
    // fclose(fp)
    // [1248] fclose::stream#2 = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fclose.stream
    lda.z fp+1
    sta.z fclose.stream+1
    // [1249] call fclose
    // [1032] phi from fe_sprite_bram_load::@6 to fclose [phi:fe_sprite_bram_load::@6->fclose]
    // [1032] phi fclose::stream#3 = fclose::stream#2 [phi:fe_sprite_bram_load::@6->fclose#0] -- register_copy 
    jsr fclose
    // fclose(fp)
    // [1250] fclose::return#6 = fclose::return#1
    // fe_sprite_bram_load::@21
    // [1251] fe_sprite_bram_load::$24 = fclose::return#6 -- vwsm1=vwsm2 
    lda fclose.return
    sta fe_sprite_bram_load__24
    lda fclose.return+1
    sta fe_sprite_bram_load__24+1
    // if (fclose(fp))
    // [1252] if(0!=fe_sprite_bram_load::$24) goto fe_sprite_bram_load::bank_pull_bram1 -- 0_neq_vwsm1_then_la1 
    // Now we have read everything and we close the file.
    ora fe_sprite_bram_load__24
    bne bank_pull_bram1
    // fe_sprite_bram_load::@9
    // sprites.loaded[sprite_index] = 1
    // [1253] ((char *)&sprites+$40)[fe_sprite_bram_load::sprite_index#10] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    ldy sprite_index
    sta sprites+$40,y
    // [1254] phi from fe_sprite_bram_load::@10 fe_sprite_bram_load::@17 fe_sprite_bram_load::@18 fe_sprite_bram_load::@21 fe_sprite_bram_load::@9 to fe_sprite_bram_load::bank_pull_bram1 [phi:fe_sprite_bram_load::@10/fe_sprite_bram_load::@17/fe_sprite_bram_load::@18/fe_sprite_bram_load::@21/fe_sprite_bram_load::@9->fe_sprite_bram_load::bank_pull_bram1]
    // [1254] phi __errno#35 = __errno#104 [phi:fe_sprite_bram_load::@10/fe_sprite_bram_load::@17/fe_sprite_bram_load::@18/fe_sprite_bram_load::@21/fe_sprite_bram_load::@9->fe_sprite_bram_load::bank_pull_bram1#0] -- register_copy 
    // [1254] phi fe_sprite_bram_load::return#0 = fe_sprite_bram_load::sprite_offset#10 [phi:fe_sprite_bram_load::@10/fe_sprite_bram_load::@17/fe_sprite_bram_load::@18/fe_sprite_bram_load::@21/fe_sprite_bram_load::@9->fe_sprite_bram_load::bank_pull_bram1#1] -- register_copy 
    // fe_sprite_bram_load::bank_pull_bram1
  bank_pull_bram1:
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_bram_load::@return
    // }
    // [1256] return 
    rts
    // fe_sprite_bram_load::@5
  __b5:
    // bram_heap_handle_t handle_bram = bram_heap_alloc(0, sprite_size)
    // [1257] bram_heap_alloc::s = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_bramheap.bram_heap_alloc.s
    // [1258] bram_heap_alloc::size = fe_sprite_bram_load::sprite_size#0 -- vduz1=vwum2 
    lda sprite_size
    sta.z lib_bramheap.bram_heap_alloc.size
    lda sprite_size+1
    sta.z lib_bramheap.bram_heap_alloc.size+1
    lda #0
    sta.z lib_bramheap.bram_heap_alloc.size+2
    sta.z lib_bramheap.bram_heap_alloc.size+3
    // [1259] callexecute bram_heap_alloc  -- call_var_near 
    jsr lib_bramheap.bram_heap_alloc
    // [1260] fe_sprite_bram_load::handle_bram#0 = bram_heap_alloc::return -- vbum1=vbuz2 
    lda.z lib_bramheap.bram_heap_alloc.return
    sta handle_bram
    // bram_bank_t sprite_bank = bram_heap_data_get_bank(0, handle_bram)
    // [1261] bram_heap_data_get_bank::s = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_bramheap.bram_heap_data_get_bank.s
    // [1262] bram_heap_data_get_bank::index = fe_sprite_bram_load::handle_bram#0 -- vbuz1=vbum2 
    lda handle_bram
    sta.z lib_bramheap.bram_heap_data_get_bank.index
    // [1263] callexecute bram_heap_data_get_bank  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_bank
    // [1264] fe_sprite_bram_load::bank_push_set_bram3_bank#0 = bram_heap_data_get_bank::return -- vbum1=vbuz2 
    lda.z lib_bramheap.bram_heap_data_get_bank.return
    sta bank_push_set_bram3_bank
    // bram_ptr_t sprite_ptr = bram_heap_data_get_offset(0, handle_bram)
    // [1265] bram_heap_data_get_offset::s = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_bramheap.bram_heap_data_get_offset.s
    // [1266] bram_heap_data_get_offset::index = fe_sprite_bram_load::handle_bram#0 -- vbuz1=vbum2 
    lda handle_bram
    sta.z lib_bramheap.bram_heap_data_get_offset.index
    // [1267] callexecute bram_heap_data_get_offset  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_offset
    // [1268] fe_sprite_bram_load::sprite_ptr#0 = bram_heap_data_get_offset::return -- pbuz1=pbuz2 
    lda.z lib_bramheap.bram_heap_data_get_offset.return
    sta.z sprite_ptr
    lda.z lib_bramheap.bram_heap_data_get_offset.return+1
    sta.z sprite_ptr+1
    // fe_sprite_bram_load::bank_push_set_bram3
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [1270] BRAM = fe_sprite_bram_load::bank_push_set_bram3_bank#0 -- vbuz1=vbum2 
    lda bank_push_set_bram3_bank
    sta.z BRAM
    // fe_sprite_bram_load::@13
    // unsigned int read = fgets(sprite_ptr, sprite_size, fp)
    // [1271] fgets::ptr#5 = fe_sprite_bram_load::sprite_ptr#0 -- pbuz1=pbuz2 
    lda.z sprite_ptr
    sta.z fgets.ptr
    lda.z sprite_ptr+1
    sta.z fgets.ptr+1
    // [1272] fgets::size#3 = fe_sprite_bram_load::sprite_size#0 -- vwum1=vwum2 
    lda sprite_size
    sta fgets.size
    lda sprite_size+1
    sta fgets.size+1
    // [1273] fgets::stream#3 = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fgets.stream
    lda.z fp+1
    sta.z fgets.stream+1
    // [1274] call fgets
    // [978] phi from fe_sprite_bram_load::@13 to fgets [phi:fe_sprite_bram_load::@13->fgets]
    // [978] phi fgets::ptr#14 = fgets::ptr#5 [phi:fe_sprite_bram_load::@13->fgets#0] -- register_copy 
    // [978] phi fgets::size#10 = fgets::size#3 [phi:fe_sprite_bram_load::@13->fgets#1] -- register_copy 
    // [978] phi fgets::stream#4 = fgets::stream#3 [phi:fe_sprite_bram_load::@13->fgets#2] -- register_copy 
    jsr fgets
    // unsigned int read = fgets(sprite_ptr, sprite_size, fp)
    // [1275] fgets::return#13 = fgets::return#1
    // fe_sprite_bram_load::@20
    // [1276] fe_sprite_bram_load::read1#0 = fgets::return#13 -- vwum1=vwum2 
    lda fgets.return
    sta read1
    lda fgets.return+1
    sta read1+1
    // fe_sprite_bram_load::bank_pull_bram3
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_bram_load::@14
    // if (!read)
    // [1278] if(0==fe_sprite_bram_load::read1#0) goto fe_sprite_bram_load::@7 -- 0_eq_vwum1_then_la1 
    lda read1
    ora read1+1
    beq __b7
    // fe_sprite_bram_load::@8
    // sprite_bram_handles[sprite_offset] = handle_bram
    // [1279] fe_sprite_bram_load::$34 = sprite_bram_handles + fe_sprite_bram_load::sprite_offset#13 -- pbuz1=pbuc1_plus_vwum2 
    lda sprite_offset
    clc
    adc #<sprite_bram_handles
    sta.z fe_sprite_bram_load__34
    lda sprite_offset+1
    adc #>sprite_bram_handles
    sta.z fe_sprite_bram_load__34+1
    // [1280] *fe_sprite_bram_load::$34 = fe_sprite_bram_load::handle_bram#0 -- _deref_pbuz1=vbum2 
    lda handle_bram
    ldy #0
    sta (fe_sprite_bram_load__34),y
    // sprite_offset++;
    // [1281] fe_sprite_bram_load::sprite_offset#0 = ++ fe_sprite_bram_load::sprite_offset#13 -- vwum1=_inc_vwum1 
    inc sprite_offset
    bne !+
    inc sprite_offset+1
  !:
    // [1282] phi from fe_sprite_bram_load::@14 fe_sprite_bram_load::@8 to fe_sprite_bram_load::@7 [phi:fe_sprite_bram_load::@14/fe_sprite_bram_load::@8->fe_sprite_bram_load::@7]
    // [1282] phi fe_sprite_bram_load::sprite_offset#30 = fe_sprite_bram_load::sprite_offset#13 [phi:fe_sprite_bram_load::@14/fe_sprite_bram_load::@8->fe_sprite_bram_load::@7#0] -- register_copy 
    // fe_sprite_bram_load::@7
  __b7:
    // for (unsigned char s = 0; s < sprites.count[sprite_index]; s++)
    // [1283] fe_sprite_bram_load::s#1 = ++ fe_sprite_bram_load::s#10 -- vbum1=_inc_vbum1 
    inc s
    // [1246] phi from fe_sprite_bram_load::@7 to fe_sprite_bram_load::@4 [phi:fe_sprite_bram_load::@7->fe_sprite_bram_load::@4]
    // [1246] phi fe_sprite_bram_load::sprite_offset#13 = fe_sprite_bram_load::sprite_offset#30 [phi:fe_sprite_bram_load::@7->fe_sprite_bram_load::@4#0] -- register_copy 
    // [1246] phi fe_sprite_bram_load::s#10 = fe_sprite_bram_load::s#1 [phi:fe_sprite_bram_load::@7->fe_sprite_bram_load::@4#1] -- register_copy 
    jmp __b4
  .segment DataEngineFlight
    filename: .fill $10, 0
    source: .text ".bin"
    .byte 0
    sprite_file_header: .fill SIZEOF_STRUCT___19, 0
    .label fe_sprite_bram_load__24 = read
    fe_sprite_bram_load__27: .byte 0
    return: .word 0
    read: .word 0
    .label palette_index = flight_add.f
    .label sprite_size = read
    .label handle_bram = fe_sprite_cache_copy.c
  .segment Data
    .label bank_push_set_bram3_bank = stage_copy.ew
  .segment DataEngineFlight
    read1: .word 0
    .label sprite_offset = return
    .label s = flight_add.sprite
    sprite_index: .byte 0
}
.segment CodeEngineFlight
  // fe_sprite_cache_copy
// todo, need to detach vram allocation from cache management.
// __register(A) char fe_sprite_cache_copy(__mem() char sprite_index)
fe_sprite_cache_copy: {
    .const bank_push_set_bram1_bank = 4
    // fe_sprite_cache_copy::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [1286] BRAM = fe_sprite_cache_copy::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // fe_sprite_cache_copy::@7
    // unsigned char c = sprites.sprite_cache[sprite_index]
    // [1287] fe_sprite_cache_copy::c#0 = ((char *)&sprites+$2a0)[fe_sprite_cache_copy::sprite_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$2a0,y
    sta c
    // sprite_index_t cache_bram = (sprite_index_t)sprite_cache.sprite_bram[c]
    // [1288] fe_sprite_cache_copy::cache_bram#0 = ((char *)&sprite_cache+$10)[fe_sprite_cache_copy::c#0] -- vbuaa=pbuc1_derefidx_vbum1 
    tay
    lda sprite_cache+$10,y
    // if (cache_bram != sprite_index)
    // [1289] if(fe_sprite_cache_copy::cache_bram#0==fe_sprite_cache_copy::sprite_index#0) goto fe_sprite_cache_copy::@1 -- vbuaa_eq_vbum1_then_la1 
    cmp sprite_index
    bne !__b1+
    jmp __b1
  !__b1:
    // fe_sprite_cache_copy::@2
    // if (sprite_cache.used[c])
    // [1290] if(0==((char *)&sprite_cache)[fe_sprite_cache_copy::c#0]) goto fe_sprite_cache_copy::@3 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda sprite_cache,y
    cmp #0
    beq __b3
    // fe_sprite_cache_copy::@4
  __b4:
    // while (sprite_cache.used[sprite_cache_pool])
    // [1291] if(0!=((char *)&sprite_cache)[sprite_cache_pool]) goto fe_sprite_cache_copy::@5 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sprite_cache_pool
    lda sprite_cache,y
    cmp #0
    beq !__b5+
    jmp __b5
  !__b5:
    // fe_sprite_cache_copy::@6
    // c = sprite_cache_pool
    // [1292] fe_sprite_cache_copy::c#1 = sprite_cache_pool -- vbum1=vbum2 
    tya
    sta c
    // [1293] phi from fe_sprite_cache_copy::@2 fe_sprite_cache_copy::@6 to fe_sprite_cache_copy::@3 [phi:fe_sprite_cache_copy::@2/fe_sprite_cache_copy::@6->fe_sprite_cache_copy::@3]
    // [1293] phi fe_sprite_cache_copy::c#5 = fe_sprite_cache_copy::c#0 [phi:fe_sprite_cache_copy::@2/fe_sprite_cache_copy::@6->fe_sprite_cache_copy::@3#0] -- register_copy 
    // fe_sprite_cache_copy::@3
  __b3:
    // unsigned char co = c * FE_CACHE
    // [1294] fe_sprite_cache_copy::co#0 = fe_sprite_cache_copy::c#5 << 4 -- vbum1=vbum2_rol_4 
    lda c
    asl
    asl
    asl
    asl
    sta co
    // sprites.sprite_cache[sprite_index] = c
    // [1295] ((char *)&sprites+$2a0)[fe_sprite_cache_copy::sprite_index#0] = fe_sprite_cache_copy::c#5 -- pbuc1_derefidx_vbum1=vbum2 
    lda c
    ldy sprite_index
    sta sprites+$2a0,y
    // sprite_cache.sprite_bram[c] = sprite_index
    // [1296] ((char *)&sprite_cache+$10)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::sprite_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy c
    sta sprite_cache+$10,y
    // sprite_cache.count[c] = sprites.count[sprite_index]
    // [1297] ((char *)&sprite_cache+$20)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$60)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    tay
    lda sprites+$60,y
    ldy c
    sta sprite_cache+$20,y
    // sprite_cache.offset[c] = sprites.offset[sprite_index]
    // [1298] fe_sprite_cache_copy::$19 = fe_sprite_cache_copy::sprite_index#0 << 1 -- vbum1=vbum2_rol_1 
    lda sprite_index
    asl
    sta fe_sprite_cache_copy__19
    // [1299] fe_sprite_cache_copy::$18 = fe_sprite_cache_copy::c#5 << 1 -- vbuxx=vbum1_rol_1 
    tya
    asl
    tax
    // [1300] ((unsigned int *)&sprite_cache+$30)[fe_sprite_cache_copy::$18] = ((unsigned int *)&sprites+$240)[fe_sprite_cache_copy::$19] -- pwuc1_derefidx_vbuxx=pwuc2_derefidx_vbum1 
    ldy fe_sprite_cache_copy__19
    lda sprites+$240,y
    sta sprite_cache+$30,x
    lda sprites+$240+1,y
    sta sprite_cache+$30+1,x
    // sprite_cache.size[c] = sprites.SpriteSize[sprite_index]
    // [1301] ((unsigned int *)&sprite_cache+$50)[fe_sprite_cache_copy::$18] = ((unsigned int *)&sprites+$80)[fe_sprite_cache_copy::$19] -- pwuc1_derefidx_vbuxx=pwuc2_derefidx_vbum1 
    lda sprites+$80,y
    sta sprite_cache+$50,x
    lda sprites+$80+1,y
    sta sprite_cache+$50+1,x
    // sprite_cache.zdepth[c] = sprites.Zdepth[sprite_index]
    // [1302] ((char *)&sprite_cache+$70)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$100)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$100,y
    ldy c
    sta sprite_cache+$70,y
    // sprite_cache.bpp[c] = sprites.BPP[sprite_index]
    // [1303] ((char *)&sprite_cache+$80)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$160)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$160,y
    ldy c
    sta sprite_cache+$80,y
    // sprite_cache.height[c] = sprites.Height[sprite_index]
    // [1304] ((char *)&sprite_cache+$a0)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$c0)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$c0,y
    ldy c
    sta sprite_cache+$a0,y
    // sprite_cache.width[c] = sprites.Width[sprite_index]
    // [1305] ((char *)&sprite_cache+$90)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$e0)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$e0,y
    ldy c
    sta sprite_cache+$90,y
    // sprite_cache.hflip[c] = sprites.Hflip[sprite_index]
    // [1306] ((char *)&sprite_cache+$b0)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$120)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$120,y
    ldy c
    sta sprite_cache+$b0,y
    // sprite_cache.vflip[c] = sprites.Vflip[sprite_index]
    // [1307] ((char *)&sprite_cache+$c0)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$140)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$140,y
    ldy c
    sta sprite_cache+$c0,y
    // sprite_cache.reverse[c] = sprites.reverse[sprite_index]
    // [1308] ((char *)&sprite_cache+$d0)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$1a0)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$1a0,y
    ldy c
    sta sprite_cache+$d0,y
    // sprite_cache.palette_offset[c] = sprites.PaletteOffset[sprite_index]
    // [1309] ((char *)&sprite_cache+$100)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$180)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$180,y
    ldy c
    sta sprite_cache+$100,y
    // sprite_cache.loop[c] = sprites.loop[sprite_index]
    // [1310] ((char *)&sprite_cache+$f0)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$280)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$280,y
    ldy c
    sta sprite_cache+$f0,y
    // strcpy(&sprite_cache.file[co], sprites.file[sprite_index])
    // [1311] strcpy::destination#0 = (char *)&sprite_cache+$110 + fe_sprite_cache_copy::co#0 -- pbuz1=pbuc1_plus_vbum2 
    lda co
    clc
    adc #<sprite_cache+$110
    sta.z strcpy.destination
    lda #>sprite_cache+$110
    adc #0
    sta.z strcpy.destination+1
    // [1312] strcpy::source#0 = ((char **)&sprites)[fe_sprite_cache_copy::$19] -- pbuz1=qbuc1_derefidx_vbum2 
    ldy fe_sprite_cache_copy__19
    lda sprites,y
    sta.z strcpy.source
    lda sprites+1,y
    sta.z strcpy.source+1
    // [1313] call strcpy
    // [1393] phi from fe_sprite_cache_copy::@3 to strcpy [phi:fe_sprite_cache_copy::@3->strcpy]
    // [1393] phi strcpy::dst#0 = strcpy::destination#0 [phi:fe_sprite_cache_copy::@3->strcpy#0] -- register_copy 
    // [1393] phi strcpy::src#0 = strcpy::source#0 [phi:fe_sprite_cache_copy::@3->strcpy#1] -- register_copy 
    jsr strcpy
    // fe_sprite_cache_copy::@8
    // sprites.aabb[sprite_index].xmin >> 2
    // [1314] fe_sprite_cache_copy::$21 = fe_sprite_cache_copy::sprite_index#0 << 2 -- vbuxx=vbum1_rol_2 
    lda sprite_index
    asl
    asl
    tax
    // [1315] fe_sprite_cache_copy::$11 = ((char *)(struct $17 *)&sprites+$1c0)[fe_sprite_cache_copy::$21] >> 2 -- vbuaa=pbuc1_derefidx_vbuxx_ror_2 
    lda sprites+$1c0,x
    lsr
    lsr
    // sprite_cache.xmin[c] = sprites.aabb[sprite_index].xmin >> 2
    // [1316] ((char *)&sprite_cache+$210)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$11 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy c
    sta sprite_cache+$210,y
    // sprites.aabb[sprite_index].ymin >> 2
    // [1317] fe_sprite_cache_copy::$12 = ((char *)(struct $17 *)&sprites+$1c0+1)[fe_sprite_cache_copy::$21] >> 2 -- vbuaa=pbuc1_derefidx_vbuxx_ror_2 
    lda sprites+$1c0+1,x
    lsr
    lsr
    // sprite_cache.ymin[c] = sprites.aabb[sprite_index].ymin >> 2
    // [1318] ((char *)&sprite_cache+$220)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$12 -- pbuc1_derefidx_vbum1=vbuaa 
    sta sprite_cache+$220,y
    // sprites.aabb[sprite_index].xmax >> 2
    // [1319] fe_sprite_cache_copy::$13 = ((char *)(struct $17 *)&sprites+$1c0+2)[fe_sprite_cache_copy::$21] >> 2 -- vbuaa=pbuc1_derefidx_vbuxx_ror_2 
    lda sprites+$1c0+2,x
    lsr
    lsr
    // sprite_cache.xmax[c] = sprites.aabb[sprite_index].xmax >> 2
    // [1320] ((char *)&sprite_cache+$230)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$13 -- pbuc1_derefidx_vbum1=vbuaa 
    sta sprite_cache+$230,y
    // sprites.aabb[sprite_index].ymax >> 2
    // [1321] fe_sprite_cache_copy::$14 = ((char *)(struct $17 *)&sprites+$1c0+3)[fe_sprite_cache_copy::$21] >> 2 -- vbuaa=pbuc1_derefidx_vbuxx_ror_2 
    lda sprites+$1c0+3,x
    lsr
    lsr
    // sprite_cache.ymax[c] = sprites.aabb[sprite_index].ymax >> 2
    // [1322] ((char *)&sprite_cache+$240)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$14 -- pbuc1_derefidx_vbum1=vbuaa 
    sta sprite_cache+$240,y
    // [1323] phi from fe_sprite_cache_copy::@7 fe_sprite_cache_copy::@8 to fe_sprite_cache_copy::@1 [phi:fe_sprite_cache_copy::@7/fe_sprite_cache_copy::@8->fe_sprite_cache_copy::@1]
    // [1323] phi fe_sprite_cache_copy::c#2 = fe_sprite_cache_copy::c#0 [phi:fe_sprite_cache_copy::@7/fe_sprite_cache_copy::@8->fe_sprite_cache_copy::@1#0] -- register_copy 
    // fe_sprite_cache_copy::@1
  __b1:
    // sprite_cache.used[c]++;
    // [1324] ((char *)&sprite_cache)[fe_sprite_cache_copy::c#2] = ++ ((char *)&sprite_cache)[fe_sprite_cache_copy::c#2] -- pbuc1_derefidx_vbum1=_inc_pbuc1_derefidx_vbum1 
    ldx c
    inc sprite_cache,x
    // fe_sprite_cache_copy::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_cache_copy::@return
    // }
    // [1326] return 
    rts
    // fe_sprite_cache_copy::@5
  __b5:
    // sprite_cache_pool + 1
    // [1327] fe_sprite_cache_copy::$6 = sprite_cache_pool + 1 -- vbuaa=vbum1_plus_1 
    lda sprite_cache_pool
    inc
    // (sprite_cache_pool + 1) % FE_CACHE
    // [1328] fe_sprite_cache_copy::$7 = fe_sprite_cache_copy::$6 & FE_CACHE-1 -- vbuaa=vbuaa_band_vbuc1 
    and #FE_CACHE-1
    // sprite_cache_pool = (sprite_cache_pool + 1) % FE_CACHE
    // [1329] sprite_cache_pool = fe_sprite_cache_copy::$7 -- vbum1=vbuaa 
    sta sprite_cache_pool
    jmp __b4
  .segment DataEngineFlight
    .label fe_sprite_cache_copy__19 = fe_sprite_bram_load.fe_sprite_bram_load__27
    .label sprite_index = flight_add.sprite
    c: .byte 0
    .label co = fe_sprite_bram_load.sprite_index
}
.segment CodeEngineFlight
  // flight_sprite_next_offset
//     char x =  (i / 32) * 16;
//     char y = i % 32;
//     gotoxy(x, y);
//     printf("i:%02x n:%02x p:%02x t:%01x", i, flight.next[i], flight.prev[i], flight.type[i]);
// }
// __mem() unsigned int flight_sprite_next_offset()
flight_sprite_next_offset: {
    // flight_sprite_next_offset::@1
  __b1:
    // !flight_sprite_offset_pool || flight_sprite_offsets[flight_sprite_offset_pool]
    // [1331] flight_sprite_next_offset::$6 = flight_sprite_offset_pool << 1 -- vbuxx=vbum1_rol_1 
    lda flight_sprite_offset_pool
    asl
    tax
    // while (!flight_sprite_offset_pool || flight_sprite_offsets[flight_sprite_offset_pool])
    // [1332] if(0==flight_sprite_offset_pool) goto flight_sprite_next_offset::@2 -- 0_eq_vbum1_then_la1 
    lda flight_sprite_offset_pool
    beq __b2
    // flight_sprite_next_offset::@5
    // [1333] if(0!=flight_sprite_offsets[flight_sprite_next_offset::$6]) goto flight_sprite_next_offset::@2 -- 0_neq_pwuc1_derefidx_vbuxx_then_la1 
    lda flight_sprite_offsets+1,x
    ora flight_sprite_offsets,x
    bne __b2
    // flight_sprite_next_offset::@3
    // stage.sprite_count++;
    // [1334] *((char *)&stage+$f) = ++ *((char *)&stage+$f) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc stage+$f
    // vera_sprite_offset sprite_offset = vera_sprite_get_offset(flight_sprite_offset_pool)
    // [1335] flight_sprite_next_offset::vera_sprite_get_offset1_sprite_id#0 = flight_sprite_offset_pool -- vbuaa=vbum1 
    lda flight_sprite_offset_pool
    // flight_sprite_next_offset::vera_sprite_get_offset1
    // ((unsigned int)sprite_id) << 3
    // [1336] flight_sprite_next_offset::vera_sprite_get_offset1_$2 = (unsigned int)flight_sprite_next_offset::vera_sprite_get_offset1_sprite_id#0 -- vwum1=_word_vbuaa 
    sta vera_sprite_get_offset1_flight_sprite_next_offset__2
    lda #0
    sta vera_sprite_get_offset1_flight_sprite_next_offset__2+1
    // [1337] flight_sprite_next_offset::vera_sprite_get_offset1_$0 = flight_sprite_next_offset::vera_sprite_get_offset1_$2 << 3 -- vwum1=vwum1_rol_3 
    asl vera_sprite_get_offset1_flight_sprite_next_offset__0
    rol vera_sprite_get_offset1_flight_sprite_next_offset__0+1
    asl vera_sprite_get_offset1_flight_sprite_next_offset__0
    rol vera_sprite_get_offset1_flight_sprite_next_offset__0+1
    asl vera_sprite_get_offset1_flight_sprite_next_offset__0
    rol vera_sprite_get_offset1_flight_sprite_next_offset__0+1
    // WORD0(VERA_SPRITE_ATTR)+(((unsigned int)sprite_id) << 3)
    // [1338] flight_sprite_next_offset::vera_sprite_get_offset1_return#0 = word0 VERA_SPRITE_ATTR + flight_sprite_next_offset::vera_sprite_get_offset1_$0 -- vwum1=vwuc1_plus_vwum1 
    lda vera_sprite_get_offset1_return
    clc
    adc #<VERA_SPRITE_ATTR&$ffff
    sta vera_sprite_get_offset1_return
    lda vera_sprite_get_offset1_return+1
    adc #>VERA_SPRITE_ATTR&$ffff
    sta vera_sprite_get_offset1_return+1
    // flight_sprite_next_offset::@4
    // flight_sprite_offsets[flight_sprite_offset_pool] = sprite_offset
    // [1339] flight_sprite_next_offset::$7 = flight_sprite_offset_pool << 1 -- vbuaa=vbum1_rol_1 
    lda flight_sprite_offset_pool
    asl
    // [1340] flight_sprite_offsets[flight_sprite_next_offset::$7] = flight_sprite_next_offset::vera_sprite_get_offset1_return#0 -- pwuc1_derefidx_vbuaa=vwum1 
    tay
    lda vera_sprite_get_offset1_return
    sta flight_sprite_offsets,y
    lda vera_sprite_get_offset1_return+1
    sta flight_sprite_offsets+1,y
    // flight_sprite_next_offset::@return
    // }
    // [1341] return 
    rts
    // flight_sprite_next_offset::@2
  __b2:
    // flight_sprite_offset_pool + 1
    // [1342] flight_sprite_next_offset::$4 = flight_sprite_offset_pool + 1 -- vbuaa=vbum1_plus_1 
    lda flight_sprite_offset_pool
    inc
    // (flight_sprite_offset_pool + 1) % 128
    // [1343] flight_sprite_next_offset::$5 = flight_sprite_next_offset::$4 & $80-1 -- vbuaa=vbuaa_band_vbuc1 
    and #$80-1
    // flight_sprite_offset_pool = (flight_sprite_offset_pool + 1) % 128
    // [1344] flight_sprite_offset_pool = flight_sprite_next_offset::$5 -- vbum1=vbuaa 
    sta flight_sprite_offset_pool
    jmp __b1
  .segment Data
    .label vera_sprite_get_offset1_flight_sprite_next_offset__0 = clrscr.ch
    .label vera_sprite_get_offset1_flight_sprite_next_offset__2 = clrscr.ch
  .segment DataEngineFlight
    .label return = fe_sprite_bram_load.return
  .segment Data
    .label vera_sprite_get_offset1_return = clrscr.ch
}
.segment CodeEngineFlight
  // fe_sprite_configure
// void fe_sprite_configure(__mem() unsigned int sprite_offset, __register(Y) char s)
fe_sprite_configure: {
    .const vera_sprite_bpp1_vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    .const vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_sprite_bpp(sprite_offset, sprite_cache.bpp[s])
    // [1345] fe_sprite_configure::vera_sprite_bpp1_bpp#0 = ((char *)&sprite_cache+$80)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx sprite_cache+$80,y
    // fe_sprite_configure::vera_sprite_bpp1
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+1, vera_inc_0)
    // [1346] fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset#0 = fe_sprite_configure::sprite_offset#0 + 1 -- vwum1=vwum2_plus_1 
    clc
    lda sprite_offset
    adc #1
    sta vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset
    lda sprite_offset+1
    adc #0
    sta vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset+1
    // fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1347] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1348] fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$0 = byte0  fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1349] *VERA_ADDRX_L = fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1350] fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$1 = byte1  fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1351] *VERA_ADDRX_M = fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [1352] *VERA_ADDRX_H = fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_sprite_bpp1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // fe_sprite_configure::vera_sprite_bpp1_@1
    // *VERA_DATA0 & ~VERA_SPRITE_8BPP
    // [1353] fe_sprite_configure::vera_sprite_bpp1_$2 = *VERA_DATA0 & ~$80 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$80^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_8BPP
    // [1354] *VERA_DATA0 = fe_sprite_configure::vera_sprite_bpp1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= bpp
    // [1355] *VERA_DATA0 = *VERA_DATA0 | fe_sprite_configure::vera_sprite_bpp1_bpp#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // fe_sprite_configure::@1
    // vera_sprite_height(sprite_offset, sprite_cache.height[s])
    // [1356] vera_sprite_height::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta vera_sprite_height.sprite_offset
    lda sprite_offset+1
    sta vera_sprite_height.sprite_offset+1
    // [1357] vera_sprite_height::height#0 = ((char *)&sprite_cache+$a0)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx sprite_cache+$a0,y
    // [1358] call vera_sprite_height
    jsr vera_sprite_height
    // fe_sprite_configure::@2
    // vera_sprite_width(sprite_offset, sprite_cache.width[s])
    // [1359] vera_sprite_width::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta vera_sprite_width.sprite_offset
    lda sprite_offset+1
    sta vera_sprite_width.sprite_offset+1
    // [1360] vera_sprite_width::width#0 = ((char *)&sprite_cache+$90)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx sprite_cache+$90,y
    // [1361] call vera_sprite_width
    jsr vera_sprite_width
    // fe_sprite_configure::@3
    // vera_sprite_hflip(sprite_offset, sprite_cache.hflip[s])
    // [1362] vera_sprite_hflip::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta vera_sprite_hflip.sprite_offset
    lda sprite_offset+1
    sta vera_sprite_hflip.sprite_offset+1
    // [1363] vera_sprite_hflip::hflip#0 = ((char *)&sprite_cache+$b0)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx sprite_cache+$b0,y
    // [1364] call vera_sprite_hflip
    jsr vera_sprite_hflip
    // fe_sprite_configure::@4
    // vera_sprite_vflip(sprite_offset, sprite_cache.vflip[s])
    // [1365] vera_sprite_vflip::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta vera_sprite_vflip.sprite_offset
    lda sprite_offset+1
    sta vera_sprite_vflip.sprite_offset+1
    // [1366] vera_sprite_vflip::vflip#0 = ((char *)&sprite_cache+$c0)[fe_sprite_configure::s#0] -- vbuxx=pbuc1_derefidx_vbuyy 
    ldx sprite_cache+$c0,y
    // [1367] call vera_sprite_vflip
    jsr vera_sprite_vflip
    // fe_sprite_configure::@5
    // palette_use_vram(sprite_cache.palette_offset[s])
    // [1368] palette_use_vram::palette_index = ((char *)&sprite_cache+$100)[fe_sprite_configure::s#0] -- vbuz1=pbuc1_derefidx_vbuyy 
    lda sprite_cache+$100,y
    sta.z lib_palette.palette_use_vram.palette_index
    // [1369] callexecute palette_use_vram  -- call_var_near 
    jsr lib_palette.palette_use_vram
    // vera_sprite_palette_offset(sprite_offset, palette_use_vram(sprite_cache.palette_offset[s]))
    // [1370] fe_sprite_configure::vera_sprite_palette_offset1_palette_offset#0 = palette_use_vram::return -- vbuxx=vbuz1 
    ldx.z lib_palette.palette_use_vram.return
    // fe_sprite_configure::vera_sprite_palette_offset1
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0)
    // [1371] fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset#0 = fe_sprite_configure::sprite_offset#0 + 7 -- vwum1=vwum2_plus_vbuc1 
    lda #7
    clc
    adc sprite_offset
    sta vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset
    lda #0
    adc sprite_offset+1
    sta vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset+1
    // fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1372] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1373] fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$0 = byte0  fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1374] *VERA_ADDRX_L = fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1375] fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$1 = byte1  fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1376] *VERA_ADDRX_M = fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [1377] *VERA_ADDRX_H = fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // fe_sprite_configure::vera_sprite_palette_offset1_@1
    // *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK
    // [1378] fe_sprite_configure::vera_sprite_palette_offset1_$2 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_PALETTE_OFFSET_MASK^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK
    // [1379] *VERA_DATA0 = fe_sprite_configure::vera_sprite_palette_offset1_$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= palette_offset
    // [1380] *VERA_DATA0 = *VERA_DATA0 | fe_sprite_configure::vera_sprite_palette_offset1_palette_offset#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // fe_sprite_configure::@return
    // }
    // [1381] return 
    rts
  .segment DataEngineFlight
    .label sprite_offset = fe_sprite_bram_load.return
  .segment Data
    .label vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset = clrscr.ch
    .label vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset = clrscr.ch
}
.segment Code
  // strncpy
/// Copies up to n characters from the string pointed to, by src to dst.
/// In a case where the length of src is less than that of n, the remainder of dst will be padded with null bytes.
/// @param dst ? This is the pointer to the destination array where the content is to be copied.
/// @param src ? This is the string to be copied.
/// @param n ? The number of characters to be copied from source.
/// @return The destination
// char * strncpy(__zp($26) char *dst, __zp($22) const char *src, __mem() unsigned int n)
strncpy: {
    .label dst = $26
    .label src = $22
    // [1383] phi from strncpy to strncpy::@1 [phi:strncpy->strncpy::@1]
    // [1383] phi strncpy::dst#2 = ferror::temp [phi:strncpy->strncpy::@1#0] -- pbuz1=pbuc1 
    lda #<ferror.temp
    sta.z dst
    lda #>ferror.temp
    sta.z dst+1
    // [1383] phi strncpy::src#2 = __errno_error [phi:strncpy->strncpy::@1#1] -- pbuz1=pbuc1 
    lda #<__errno_error
    sta.z src
    lda #>__errno_error
    sta.z src+1
    // [1383] phi strncpy::i#2 = 0 [phi:strncpy->strncpy::@1#2] -- vwum1=vwuc1 
    lda #<0
    sta i
    sta i+1
    // strncpy::@1
  __b1:
    // for(size_t i = 0;i<n;i++)
    // [1384] if(strncpy::i#2<strncpy::n#0) goto strncpy::@2 -- vwum1_lt_vwum2_then_la1 
    lda i+1
    cmp n+1
    bcc __b2
    bne !+
    lda i
    cmp n
    bcc __b2
  !:
    // strncpy::@return
    // }
    // [1385] return 
    rts
    // strncpy::@2
  __b2:
    // char c = *src
    // [1386] strncpy::c#0 = *strncpy::src#2 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (src),y
    // if(c)
    // [1387] if(0==strncpy::c#0) goto strncpy::@3 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b3
    // strncpy::@4
    // src++;
    // [1388] strncpy::src#0 = ++ strncpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [1389] phi from strncpy::@2 strncpy::@4 to strncpy::@3 [phi:strncpy::@2/strncpy::@4->strncpy::@3]
    // [1389] phi strncpy::src#6 = strncpy::src#2 [phi:strncpy::@2/strncpy::@4->strncpy::@3#0] -- register_copy 
    // strncpy::@3
  __b3:
    // *dst++ = c
    // [1390] *strncpy::dst#2 = strncpy::c#0 -- _deref_pbuz1=vbuaa 
    ldy #0
    sta (dst),y
    // *dst++ = c;
    // [1391] strncpy::dst#0 = ++ strncpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // for(size_t i = 0;i<n;i++)
    // [1392] strncpy::i#1 = ++ strncpy::i#2 -- vwum1=_inc_vwum1 
    inc i
    bne !+
    inc i+1
  !:
    // [1383] phi from strncpy::@3 to strncpy::@1 [phi:strncpy::@3->strncpy::@1]
    // [1383] phi strncpy::dst#2 = strncpy::dst#0 [phi:strncpy::@3->strncpy::@1#0] -- register_copy 
    // [1383] phi strncpy::src#2 = strncpy::src#6 [phi:strncpy::@3->strncpy::@1#1] -- register_copy 
    // [1383] phi strncpy::i#2 = strncpy::i#1 [phi:strncpy::@3->strncpy::@1#2] -- register_copy 
    jmp __b1
  .segment Data
    .label i = clrscr.ch
    .label n = fgets.remaining
}
.segment Code
  // strcpy
// Copies the C string pointed by source into the array pointed by destination, including the terminating null character (and stopping at that point).
// char * strcpy(__zp($22) char *destination, __zp($26) char *source)
strcpy: {
    .label src = $26
    .label dst = $22
    .label destination = $22
    .label source = $26
    // [1394] phi from strcpy strcpy::@2 to strcpy::@1 [phi:strcpy/strcpy::@2->strcpy::@1]
    // [1394] phi strcpy::dst#2 = strcpy::dst#0 [phi:strcpy/strcpy::@2->strcpy::@1#0] -- register_copy 
    // [1394] phi strcpy::src#2 = strcpy::src#0 [phi:strcpy/strcpy::@2->strcpy::@1#1] -- register_copy 
    // strcpy::@1
  __b1:
    // while(*src)
    // [1395] if(0!=*strcpy::src#2) goto strcpy::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strcpy::@3
    // *dst = 0
    // [1396] *strcpy::dst#2 = 0 -- _deref_pbuz1=vbuc1 
    tya
    tay
    sta (dst),y
    // strcpy::@return
    // }
    // [1397] return 
    rts
    // strcpy::@2
  __b2:
    // *dst++ = *src++
    // [1398] *strcpy::dst#2 = *strcpy::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [1399] strcpy::dst#1 = ++ strcpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [1400] strcpy::src#1 = ++ strcpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
  // strcat
// Concatenates the C string pointed by source into the array pointed by destination, including the terminating null character (and stopping at that point).
// char * strcat(char *destination, char *source)
strcat: {
    .label dst = $26
    .label src = $22
    // strlen(destination)
    // [1402] call strlen
    // [1128] phi from strcat to strlen [phi:strcat->strlen]
    // [1128] phi strlen::str#6 = fe_sprite_bram_load::filename [phi:strcat->strlen#0] -- pbuz1=pbuc1 
    lda #<fe_sprite_bram_load.filename
    sta.z strlen.str
    lda #>fe_sprite_bram_load.filename
    sta.z strlen.str+1
    jsr strlen
    // strlen(destination)
    // [1403] strlen::return#0 = strlen::len#2
    // strcat::@4
    // [1404] strcat::$0 = strlen::return#0
    // char* dst = destination + strlen(destination)
    // [1405] strcat::dst#0 = fe_sprite_bram_load::filename + strcat::$0 -- pbuz1=pbuc1_plus_vwum2 
    lda strcat__0
    clc
    adc #<fe_sprite_bram_load.filename
    sta.z dst
    lda strcat__0+1
    adc #>fe_sprite_bram_load.filename
    sta.z dst+1
    // [1406] phi from strcat::@4 to strcat::@1 [phi:strcat::@4->strcat::@1]
    // [1406] phi strcat::dst#2 = strcat::dst#0 [phi:strcat::@4->strcat::@1#0] -- register_copy 
    // [1406] phi strcat::src#2 = fe_sprite_bram_load::source [phi:strcat::@4->strcat::@1#1] -- pbuz1=pbuc1 
    lda #<fe_sprite_bram_load.source
    sta.z src
    lda #>fe_sprite_bram_load.source
    sta.z src+1
    // strcat::@1
  __b1:
    // while(*src)
    // [1407] if(0!=*strcat::src#2) goto strcat::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strcat::@3
    // *dst = 0
    // [1408] *strcat::dst#2 = 0 -- _deref_pbuz1=vbuc1 
    tya
    tay
    sta (dst),y
    // strcat::@return
    // }
    // [1409] return 
    rts
    // strcat::@2
  __b2:
    // *dst++ = *src++
    // [1410] *strcat::dst#2 = *strcat::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [1411] strcat::dst#1 = ++ strcat::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [1412] strcat::src#1 = ++ strcat::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [1406] phi from strcat::@2 to strcat::@1 [phi:strcat::@2->strcat::@1]
    // [1406] phi strcat::dst#2 = strcat::dst#1 [phi:strcat::@2->strcat::@1#0] -- register_copy 
    // [1406] phi strcat::src#2 = strcat::src#1 [phi:strcat::@2->strcat::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label strcat__0 = clrscr.ch
}
.segment CodeEngineFlight
  // sprite_map_header
// void sprite_map_header(struct $19 *sprite_file_header, __mem() char sprite)
sprite_map_header: {
    .label sprite_file_header = fe_sprite_bram_load.sprite_file_header
    // sprites.count[sprite] = sprite_file_header->count
    // [1413] ((char *)&sprites+$60)[sprite_map_header::sprite#0] = *((char *)sprite_map_header::sprite_file_header#0) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    lda sprite_file_header
    ldy sprite
    sta sprites+$60,y
    // sprites.SpriteSize[sprite] = sprite_file_header->size
    // [1414] sprite_map_header::$8 = sprite_map_header::sprite#0 << 1 -- vbuaa=vbum1_rol_1 
    tya
    asl
    // [1415] ((unsigned int *)&sprites+$80)[sprite_map_header::$8] = *((unsigned int *)sprite_map_header::sprite_file_header#0+1) -- pwuc1_derefidx_vbuaa=_deref_pwuc2 
    tay
    lda sprite_file_header+1
    sta sprites+$80,y
    lda sprite_file_header+1+1
    sta sprites+$80+1,y
    // vera_sprite_width_get_bitmap(sprite_file_header->width)
    // [1416] sprite_map_header::vera_sprite_width_get_bitmap1_width#0 = *((char *)sprite_map_header::sprite_file_header#0+3) -- vbuaa=_deref_pbuc1 
    lda sprite_file_header+3
    // sprite_map_header::vera_sprite_width_get_bitmap1
    // case 8:
    //             return VERA_SPRITE_WIDTH_8;
    // [1417] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==8) goto sprite_map_header::vera_sprite_width_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #8
    beq __b5
    // sprite_map_header::vera_sprite_width_get_bitmap1_@1
    // case 16:
    //             return VERA_SPRITE_WIDTH_16;
    // [1418] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==$10) goto sprite_map_header::vera_sprite_width_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #$10
    beq __b6
    // sprite_map_header::vera_sprite_width_get_bitmap1_@2
    // case 32:
    //             return VERA_SPRITE_WIDTH_32;
    // [1419] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==$20) goto sprite_map_header::vera_sprite_width_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #$20
    beq __b7
    // sprite_map_header::vera_sprite_width_get_bitmap1_@3
    // case 64:
    //             return VERA_SPRITE_WIDTH_64;
    //         other:
    // [1420] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==$40) goto sprite_map_header::vera_sprite_width_get_bitmap1_@9 -- vbuaa_eq_vbuc1_then_la1 
    cmp #$40
    beq vera_sprite_width_get_bitmap1___b9
    // [1422] phi from sprite_map_header::vera_sprite_width_get_bitmap1 sprite_map_header::vera_sprite_width_get_bitmap1_@3 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1/sprite_map_header::vera_sprite_width_get_bitmap1_@3->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
  __b5:
    // [1422] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = 0 [phi:sprite_map_header::vera_sprite_width_get_bitmap1/sprite_map_header::vera_sprite_width_get_bitmap1_@3->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b1
    // [1421] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@3 to sprite_map_header::vera_sprite_width_get_bitmap1_@9 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@3->sprite_map_header::vera_sprite_width_get_bitmap1_@9]
    // sprite_map_header::vera_sprite_width_get_bitmap1_@9
  vera_sprite_width_get_bitmap1___b9:
    // [1422] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@9 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@9->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
    // [1422] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = $30 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@9->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$30
    jmp __b1
    // [1422] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@1 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@1->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
  __b6:
    // [1422] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = $10 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@1->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$10
    jmp __b1
    // [1422] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@2 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@2->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
  __b7:
    // [1422] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = $20 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@2->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$20
    // sprite_map_header::vera_sprite_width_get_bitmap1_@return
    // sprite_map_header::@1
  __b1:
    // sprites.Width[sprite] = vera_sprite_width_get_bitmap(sprite_file_header->width)
    // [1423] ((char *)&sprites+$e0)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_width_get_bitmap1_return#5 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sprite
    sta sprites+$e0,y
    // vera_sprite_height_get_bitmap(sprite_file_header->height)
    // [1424] sprite_map_header::vera_sprite_height_get_bitmap1_height#0 = *((char *)sprite_map_header::sprite_file_header#0+4) -- vbuaa=_deref_pbuc1 
    lda sprite_file_header+4
    // sprite_map_header::vera_sprite_height_get_bitmap1
    // case 8:
    //             return VERA_SPRITE_HEIGHT_8;
    // [1425] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==8) goto sprite_map_header::vera_sprite_height_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #8
    beq __b8
    // sprite_map_header::vera_sprite_height_get_bitmap1_@1
    // case 16:
    //             return VERA_SPRITE_HEIGHT_16;
    // [1426] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==$10) goto sprite_map_header::vera_sprite_height_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #$10
    beq __b9
    // sprite_map_header::vera_sprite_height_get_bitmap1_@2
    // case 32:
    //             return VERA_SPRITE_HEIGHT_32;
    // [1427] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==$20) goto sprite_map_header::vera_sprite_height_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #$20
    beq __b10
    // sprite_map_header::vera_sprite_height_get_bitmap1_@3
    // case 64:
    //             return VERA_SPRITE_HEIGHT_64;
    //         other:
    // [1428] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==$40) goto sprite_map_header::vera_sprite_height_get_bitmap1_@9 -- vbuaa_eq_vbuc1_then_la1 
    cmp #$40
    beq vera_sprite_height_get_bitmap1___b9
    // [1430] phi from sprite_map_header::vera_sprite_height_get_bitmap1 sprite_map_header::vera_sprite_height_get_bitmap1_@3 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1/sprite_map_header::vera_sprite_height_get_bitmap1_@3->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
  __b8:
    // [1430] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = 0 [phi:sprite_map_header::vera_sprite_height_get_bitmap1/sprite_map_header::vera_sprite_height_get_bitmap1_@3->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b2
    // [1429] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@3 to sprite_map_header::vera_sprite_height_get_bitmap1_@9 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@3->sprite_map_header::vera_sprite_height_get_bitmap1_@9]
    // sprite_map_header::vera_sprite_height_get_bitmap1_@9
  vera_sprite_height_get_bitmap1___b9:
    // [1430] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@9 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@9->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
    // [1430] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = $c0 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@9->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$c0
    jmp __b2
    // [1430] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@1 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@1->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
  __b9:
    // [1430] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = $40 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@1->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$40
    jmp __b2
    // [1430] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@2 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@2->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
  __b10:
    // [1430] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = $80 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@2->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$80
    // sprite_map_header::vera_sprite_height_get_bitmap1_@return
    // sprite_map_header::@2
  __b2:
    // sprites.Height[sprite] = vera_sprite_height_get_bitmap(sprite_file_header->height)
    // [1431] ((char *)&sprites+$c0)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_height_get_bitmap1_return#5 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sprite
    sta sprites+$c0,y
    // vera_sprite_zdepth_get_bitmap(sprite_file_header->zdepth)
    // [1432] sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0 = *((char *)sprite_map_header::sprite_file_header#0+5) -- vbuaa=_deref_pbuc1 
    lda sprite_file_header+5
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1
    // case 0:
    //             return VERA_SPRITE_ZDEPTH_DISABLED;
    // [1433] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==0) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b11
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1
    // case 1:
    //             return VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0;
    // [1434] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==1) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #1
    beq __b12
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2
    // case 2:
    //             return VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1;
    // [1435] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==2) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #2
    beq __b13
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3
    // case 3:
    //             return VERA_SPRITE_ZDEPTH_IN_FRONT;
    //         other:
    // [1436] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==3) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9 -- vbuaa_eq_vbuc1_then_la1 
    cmp #3
    beq vera_sprite_zdepth_get_bitmap1___b9
    // [1438] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1 sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1/sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
  __b11:
    // [1438] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = 0 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1/sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b3
    // [1437] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9]
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9
  vera_sprite_zdepth_get_bitmap1___b9:
    // [1438] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
    // [1438] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = $c [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #$c
    jmp __b3
    // [1438] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
  __b12:
    // [1438] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = 4 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #4
    jmp __b3
    // [1438] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
  __b13:
    // [1438] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = 8 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #8
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return
    // sprite_map_header::@3
  __b3:
    // sprites.Zdepth[sprite] = vera_sprite_zdepth_get_bitmap(sprite_file_header->zdepth)
    // [1439] ((char *)&sprites+$100)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sprite
    sta sprites+$100,y
    // vera_sprite_hflip_get_bitmap(sprite_file_header->hflip)
    // [1440] sprite_map_header::vera_sprite_hflip_get_bitmap1_hflip#0 = *((char *)sprite_map_header::sprite_file_header#0+6) -- vbuaa=_deref_pbuc1 
    lda sprite_file_header+6
    // sprite_map_header::vera_sprite_hflip_get_bitmap1
    // case 0:
    //             return VERA_SPRITE_NFLIP;
    // [1441] if(sprite_map_header::vera_sprite_hflip_get_bitmap1_hflip#0==0) goto sprite_map_header::vera_sprite_hflip_get_bitmap1_@return -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b14
    // sprite_map_header::vera_sprite_hflip_get_bitmap1_@1
    // case 1:
    //             return VERA_SPRITE_HFLIP;
    //         other:
    // [1442] if(sprite_map_header::vera_sprite_hflip_get_bitmap1_hflip#0==1) goto sprite_map_header::vera_sprite_hflip_get_bitmap1_@5 -- vbuaa_eq_vbuc1_then_la1 
    cmp #1
    beq vera_sprite_hflip_get_bitmap1___b5
    // [1444] phi from sprite_map_header::vera_sprite_hflip_get_bitmap1 sprite_map_header::vera_sprite_hflip_get_bitmap1_@1 to sprite_map_header::vera_sprite_hflip_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1/sprite_map_header::vera_sprite_hflip_get_bitmap1_@1->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return]
  __b14:
    // [1444] phi sprite_map_header::vera_sprite_hflip_get_bitmap1_return#3 = 0 [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1/sprite_map_header::vera_sprite_hflip_get_bitmap1_@1->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #0
    jmp __b4
    // [1443] phi from sprite_map_header::vera_sprite_hflip_get_bitmap1_@1 to sprite_map_header::vera_sprite_hflip_get_bitmap1_@5 [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1_@1->sprite_map_header::vera_sprite_hflip_get_bitmap1_@5]
    // sprite_map_header::vera_sprite_hflip_get_bitmap1_@5
  vera_sprite_hflip_get_bitmap1___b5:
    // [1444] phi from sprite_map_header::vera_sprite_hflip_get_bitmap1_@5 to sprite_map_header::vera_sprite_hflip_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1_@5->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return]
    // [1444] phi sprite_map_header::vera_sprite_hflip_get_bitmap1_return#3 = 1 [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1_@5->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return#0] -- vbuaa=vbuc1 
    lda #1
    // sprite_map_header::vera_sprite_hflip_get_bitmap1_@return
    // sprite_map_header::@4
  __b4:
    // sprites.Hflip[sprite] = vera_sprite_hflip_get_bitmap(sprite_file_header->hflip)
    // [1445] ((char *)&sprites+$120)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_hflip_get_bitmap1_return#3 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sprite
    sta sprites+$120,y
    // vera_sprite_vflip_get_bitmap(sprite_file_header->vflip)
    // [1446] vera_sprite_vflip_get_bitmap::vflip#0 = *((char *)sprite_map_header::sprite_file_header#0+7) -- vbuaa=_deref_pbuc1 
    lda sprite_file_header+7
    // [1447] call vera_sprite_vflip_get_bitmap
    jsr vera_sprite_vflip_get_bitmap
    // [1448] vera_sprite_vflip_get_bitmap::return#4 = vera_sprite_vflip_get_bitmap::return#3
    // sprite_map_header::@5
    // [1449] sprite_map_header::$4 = vera_sprite_vflip_get_bitmap::return#4
    // sprites.Vflip[sprite] = vera_sprite_vflip_get_bitmap(sprite_file_header->vflip)
    // [1450] ((char *)&sprites+$140)[sprite_map_header::sprite#0] = sprite_map_header::$4 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sprite
    sta sprites+$140,y
    // vera_sprite_bpp_get_bitmap(sprite_file_header->bpp)
    // [1451] vera_sprite_bpp_get_bitmap::bpp#0 = *((char *)sprite_map_header::sprite_file_header#0+8) -- vbuaa=_deref_pbuc1 
    lda sprite_file_header+8
    // [1452] call vera_sprite_bpp_get_bitmap
    jsr vera_sprite_bpp_get_bitmap
    // [1453] vera_sprite_bpp_get_bitmap::return#4 = vera_sprite_bpp_get_bitmap::return#3
    // sprite_map_header::@6
    // [1454] sprite_map_header::$5 = vera_sprite_bpp_get_bitmap::return#4
    // sprites.BPP[sprite] = vera_sprite_bpp_get_bitmap(sprite_file_header->bpp)
    // [1455] ((char *)&sprites+$160)[sprite_map_header::sprite#0] = sprite_map_header::$5 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sprite
    sta sprites+$160,y
    // sprites.reverse[sprite] = sprite_file_header->reverse
    // [1456] ((char *)&sprites+$1a0)[sprite_map_header::sprite#0] = *((char *)sprite_map_header::sprite_file_header#0+$a) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    lda sprite_file_header+$a
    sta sprites+$1a0,y
    // sprites.aabb[sprite].xmin = sprite_file_header->collision
    // [1457] sprite_map_header::$10 = sprite_map_header::sprite#0 << 2 -- vbuxx=vbum1_rol_2 
    tya
    asl
    asl
    tax
    // [1458] ((char *)(struct $17 *)&sprites+$1c0)[sprite_map_header::$10] = *((char *)sprite_map_header::sprite_file_header#0+9) -- pbuc1_derefidx_vbuxx=_deref_pbuc2 
    lda sprite_file_header+9
    sta sprites+$1c0,x
    // sprites.aabb[sprite].ymin = sprite_file_header->collision
    // [1459] ((char *)(struct $17 *)&sprites+$1c0+1)[sprite_map_header::$10] = *((char *)sprite_map_header::sprite_file_header#0+9) -- pbuc1_derefidx_vbuxx=_deref_pbuc2 
    sta sprites+$1c0+1,x
    // sprite_file_header->width - sprite_file_header->collision
    // [1460] sprite_map_header::$6 = *((char *)sprite_map_header::sprite_file_header#0+3) - *((char *)sprite_map_header::sprite_file_header#0+9) -- vbuaa=_deref_pbuc1_minus__deref_pbuc2 
    lda sprite_file_header+3
    sec
    sbc sprite_file_header+9
    // sprites.aabb[sprite].xmax = sprite_file_header->width - sprite_file_header->collision
    // [1461] ((char *)(struct $17 *)&sprites+$1c0+2)[sprite_map_header::$10] = sprite_map_header::$6 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta sprites+$1c0+2,x
    // sprite_file_header->height - sprite_file_header->collision
    // [1462] sprite_map_header::$7 = *((char *)sprite_map_header::sprite_file_header#0+4) - *((char *)sprite_map_header::sprite_file_header#0+9) -- vbuaa=_deref_pbuc1_minus__deref_pbuc2 
    lda sprite_file_header+4
    sec
    sbc sprite_file_header+9
    // sprites.aabb[sprite].ymax = sprite_file_header->height - sprite_file_header->collision
    // [1463] ((char *)(struct $17 *)&sprites+$1c0+3)[sprite_map_header::$10] = sprite_map_header::$7 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta sprites+$1c0+3,x
    // sprites.PaletteOffset[sprite] = 0
    // [1464] ((char *)&sprites+$180)[sprite_map_header::sprite#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta sprites+$180,y
    // sprites.loop[sprite] = sprite_file_header->loop
    // [1465] ((char *)&sprites+$280)[sprite_map_header::sprite#0] = *((char *)sprite_map_header::sprite_file_header#0+$b) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    lda sprite_file_header+$b
    sta sprites+$280,y
    // sprites.sprite_cache[sprite] = 0
    // [1466] ((char *)&sprites+$2a0)[sprite_map_header::sprite#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta sprites+$2a0,y
    // sprite_map_header::@return
    // }
    // [1467] return 
    rts
  .segment DataEngineFlight
    .label sprite = flight_add.sprite
}
.segment Code
  // vera_sprite_height
// void vera_sprite_height(__mem() unsigned int sprite_offset, __register(X) char height)
vera_sprite_height: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0)
    // [1468] vera_sprite_height::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_height::sprite_offset#0 + 7 -- vwum1=vwum1_plus_vbuc1 
    lda #7
    clc
    adc vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_offset
    bcc !+
    inc vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_height::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1469] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1470] vera_sprite_height::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_height::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1471] *VERA_ADDRX_L = vera_sprite_height::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1472] vera_sprite_height::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_height::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1473] *VERA_ADDRX_M = vera_sprite_height::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [1474] *VERA_ADDRX_H = vera_sprite_height::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_height::@1
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [1475] vera_sprite_height::$2 = *VERA_DATA0 & ~$c0 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$c0^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [1476] *VERA_DATA0 = vera_sprite_height::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= height
    // [1477] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_height::height#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // vera_sprite_height::@return
    // }
    // [1478] return 
    rts
  .segment Data
    .label vera_vram_data0_bank_offset1_offset = clrscr.ch
    .label sprite_offset = clrscr.ch
}
.segment Code
  // vera_sprite_width
// void vera_sprite_width(__mem() unsigned int sprite_offset, __register(X) char width)
vera_sprite_width: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0)
    // [1479] vera_sprite_width::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_width::sprite_offset#0 + 7 -- vwum1=vwum1_plus_vbuc1 
    lda #7
    clc
    adc vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_offset
    bcc !+
    inc vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_width::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1480] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1481] vera_sprite_width::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_width::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1482] *VERA_ADDRX_L = vera_sprite_width::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1483] vera_sprite_width::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_width::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1484] *VERA_ADDRX_M = vera_sprite_width::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [1485] *VERA_ADDRX_H = vera_sprite_width::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_width::@1
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [1486] vera_sprite_width::$2 = *VERA_DATA0 & ~$30 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #$30^$ff
    and VERA_DATA0
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [1487] *VERA_DATA0 = vera_sprite_width::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= width
    // [1488] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_width::width#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // vera_sprite_width::@return
    // }
    // [1489] return 
    rts
  .segment Data
    .label vera_vram_data0_bank_offset1_offset = clrscr.ch
    .label sprite_offset = clrscr.ch
}
.segment Code
  // vera_sprite_hflip
// void vera_sprite_hflip(__mem() unsigned int sprite_offset, __register(X) char hflip)
vera_sprite_hflip: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0)
    // [1490] vera_sprite_hflip::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_hflip::sprite_offset#0 + 6 -- vwum1=vwum1_plus_vbuc1 
    lda #6
    clc
    adc vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_offset
    bcc !+
    inc vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_hflip::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1491] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1492] vera_sprite_hflip::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_hflip::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1493] *VERA_ADDRX_L = vera_sprite_hflip::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1494] vera_sprite_hflip::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_hflip::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1495] *VERA_ADDRX_M = vera_sprite_hflip::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [1496] *VERA_ADDRX_H = vera_sprite_hflip::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_hflip::@1
    // *VERA_DATA0 & ~VERA_SPRITE_HFLIP
    // [1497] vera_sprite_hflip::$2 = *VERA_DATA0 & ~1 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #1^$ff
    and VERA_DATA0
    // *VERA_DATA0 = (*VERA_DATA0 & ~VERA_SPRITE_HFLIP)
    // [1498] *VERA_DATA0 = vera_sprite_hflip::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= hflip
    // [1499] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_hflip::hflip#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // vera_sprite_hflip::@return
    // }
    // [1500] return 
    rts
  .segment Data
    .label vera_vram_data0_bank_offset1_offset = clrscr.ch
    .label sprite_offset = clrscr.ch
}
.segment Code
  // vera_sprite_vflip
// void vera_sprite_vflip(__mem() unsigned int sprite_offset, __register(X) char vflip)
vera_sprite_vflip: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0)
    // [1501] vera_sprite_vflip::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_vflip::sprite_offset#0 + 6 -- vwum1=vwum1_plus_vbuc1 
    lda #6
    clc
    adc vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_offset
    bcc !+
    inc vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_vflip::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1502] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1503] vera_sprite_vflip::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_vflip::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte0_vwum1 
    lda vera_vram_data0_bank_offset1_offset
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1504] *VERA_ADDRX_L = vera_sprite_vflip::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1505] vera_sprite_vflip::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_vflip::vera_vram_data0_bank_offset1_offset#0 -- vbuaa=_byte1_vwum1 
    lda vera_vram_data0_bank_offset1_offset+1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1506] *VERA_ADDRX_M = vera_sprite_vflip::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuaa 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [1507] *VERA_ADDRX_H = vera_sprite_vflip::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_vflip::@1
    // *VERA_DATA0 & ~VERA_SPRITE_VFLIP
    // [1508] vera_sprite_vflip::$2 = *VERA_DATA0 & ~2 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #2^$ff
    and VERA_DATA0
    // *VERA_DATA0 = (*VERA_DATA0 & ~VERA_SPRITE_VFLIP)
    // [1509] *VERA_DATA0 = vera_sprite_vflip::$2 -- _deref_pbuc1=vbuaa 
    sta VERA_DATA0
    // *VERA_DATA0 |= vflip
    // [1510] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_vflip::vflip#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbuxx 
    txa
    ora VERA_DATA0
    sta VERA_DATA0
    // vera_sprite_vflip::@return
    // }
    // [1511] return 
    rts
  .segment Data
    .label vera_vram_data0_bank_offset1_offset = clrscr.ch
    .label sprite_offset = clrscr.ch
}
.segment Code
  // vera_sprite_vflip_get_bitmap
// __register(A) char vera_sprite_vflip_get_bitmap(__register(A) char vflip)
vera_sprite_vflip_get_bitmap: {
    // case 0:
    //             return VERA_SPRITE_NFLIP;
    // [1512] if(vera_sprite_vflip_get_bitmap::vflip#0==0) goto vera_sprite_vflip_get_bitmap::@return -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b1
    // vera_sprite_vflip_get_bitmap::@1
    // case 1:
    //             return VERA_SPRITE_VFLIP;
    //         other:
    // [1513] if(vera_sprite_vflip_get_bitmap::vflip#0==1) goto vera_sprite_vflip_get_bitmap::@2 -- vbuaa_eq_vbuc1_then_la1 
    cmp #1
    beq __b2
    // [1515] phi from vera_sprite_vflip_get_bitmap vera_sprite_vflip_get_bitmap::@1 to vera_sprite_vflip_get_bitmap::@return [phi:vera_sprite_vflip_get_bitmap/vera_sprite_vflip_get_bitmap::@1->vera_sprite_vflip_get_bitmap::@return]
  __b1:
    // [1515] phi vera_sprite_vflip_get_bitmap::return#3 = 0 [phi:vera_sprite_vflip_get_bitmap/vera_sprite_vflip_get_bitmap::@1->vera_sprite_vflip_get_bitmap::@return#0] -- vbuaa=vbuc1 
    lda #0
    rts
    // [1514] phi from vera_sprite_vflip_get_bitmap::@1 to vera_sprite_vflip_get_bitmap::@2 [phi:vera_sprite_vflip_get_bitmap::@1->vera_sprite_vflip_get_bitmap::@2]
    // vera_sprite_vflip_get_bitmap::@2
  __b2:
    // [1515] phi from vera_sprite_vflip_get_bitmap::@2 to vera_sprite_vflip_get_bitmap::@return [phi:vera_sprite_vflip_get_bitmap::@2->vera_sprite_vflip_get_bitmap::@return]
    // [1515] phi vera_sprite_vflip_get_bitmap::return#3 = 2 [phi:vera_sprite_vflip_get_bitmap::@2->vera_sprite_vflip_get_bitmap::@return#0] -- vbuaa=vbuc1 
    lda #2
    // vera_sprite_vflip_get_bitmap::@return
    // }
    // [1516] return 
    rts
}
  // vera_sprite_bpp_get_bitmap
// __register(A) char vera_sprite_bpp_get_bitmap(__register(A) char bpp)
vera_sprite_bpp_get_bitmap: {
    // case 4:
    //             return VERA_SPRITE_4BPP;
    // [1517] if(vera_sprite_bpp_get_bitmap::bpp#0==4) goto vera_sprite_bpp_get_bitmap::@return -- vbuaa_eq_vbuc1_then_la1 
    cmp #4
    beq __b1
    // vera_sprite_bpp_get_bitmap::@1
    // case 8:
    //             return VERA_SPRITE_8BPP;
    //         other:
    // [1518] if(vera_sprite_bpp_get_bitmap::bpp#0==8) goto vera_sprite_bpp_get_bitmap::@2 -- vbuaa_eq_vbuc1_then_la1 
    cmp #8
    beq __b2
    // [1520] phi from vera_sprite_bpp_get_bitmap vera_sprite_bpp_get_bitmap::@1 to vera_sprite_bpp_get_bitmap::@return [phi:vera_sprite_bpp_get_bitmap/vera_sprite_bpp_get_bitmap::@1->vera_sprite_bpp_get_bitmap::@return]
  __b1:
    // [1520] phi vera_sprite_bpp_get_bitmap::return#3 = 0 [phi:vera_sprite_bpp_get_bitmap/vera_sprite_bpp_get_bitmap::@1->vera_sprite_bpp_get_bitmap::@return#0] -- vbuaa=vbuc1 
    lda #0
    rts
    // [1519] phi from vera_sprite_bpp_get_bitmap::@1 to vera_sprite_bpp_get_bitmap::@2 [phi:vera_sprite_bpp_get_bitmap::@1->vera_sprite_bpp_get_bitmap::@2]
    // vera_sprite_bpp_get_bitmap::@2
  __b2:
    // [1520] phi from vera_sprite_bpp_get_bitmap::@2 to vera_sprite_bpp_get_bitmap::@return [phi:vera_sprite_bpp_get_bitmap::@2->vera_sprite_bpp_get_bitmap::@return]
    // [1520] phi vera_sprite_bpp_get_bitmap::return#3 = $80 [phi:vera_sprite_bpp_get_bitmap::@2->vera_sprite_bpp_get_bitmap::@return#0] -- vbuaa=vbuc1 
    lda #$80
    // vera_sprite_bpp_get_bitmap::@return
    // }
    // [1521] return 
    rts
}
  // File Data
.segment Data
  /**
 * @file errno.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Contains the POSIX implementation of errno, which contains the last error detected.
 * @version 0.1
 * @date 2023-03-18
 * 
 * @copyright Copyright (c) 2023
 * 
 */
  __errno_error: .fill $20, 0
.segment BramEngineStages
  // const stage_action_end_t      action_end                      = { 0 };
  action_flightpath_000: .word $140
  .byte $10, 0, STAGE_ACTION_MOVE, 0
  action_flightpath_left_circle_002: .word $140+$a0
  .byte $20, 3, STAGE_ACTION_MOVE, 1, -$18, 4, 3
  .fill 1, 0
  .byte STAGE_ACTION_TURN, 2
  .word $50
  .byte 0, 3, STAGE_ACTION_MOVE, 1
  action_flightpath_right_circle_003: .word $140+$a0
  .byte 0, 3, STAGE_ACTION_MOVE, 1, $18, 4, 3
  .fill 1, 0
  .byte STAGE_ACTION_TURN, 2
  .word $50
  .byte 0, 3, STAGE_ACTION_MOVE, 1
  action_flightpath_005: .word $300
  .byte $20, 2, STAGE_ACTION_MOVE, 1, 0
  .fill 3, 0
  .byte STAGE_ACTION_END, 0
  action_flightpath_006: .word $300
  .byte 0, 2, STAGE_ACTION_MOVE, 1, 0
  .fill 3, 0
  .byte STAGE_ACTION_END, 0
  stage_scenario_01_b: .byte 1, 1
  .word stage_enemy_e0401, action_flightpath_000, $140, $a0
  .byte 0, 0, 4, $a, $ff, 0, 1, 1
  .word stage_enemy_e0701, action_flightpath_000, $a0, $a0
  .byte 0, 0, 4, $14, 0, 0, 1, 1
  .word stage_enemy_e0702, action_flightpath_000, $1e0, $a0
  .byte 0, 0, 4, $1e, 0, 0, $10, $10
  .word stage_enemy_e0201, action_flightpath_005, $2c0, $20
  .byte 0, 0, $e, $14, 2, 0, $10, $10
  .word stage_enemy_e0201, action_flightpath_006, -$40, $60
  .byte 0, 0, $10, $14, 2, 0, $10, $10
  .word stage_enemy_e0201, action_flightpath_005, $2c0, $a0
  .byte 0, 0, $12, $14, 2, 0, 8, 8
  .word stage_enemy_e0401, action_flightpath_006, -$40, $20
  .byte 0, 0, 8, $14, 5, 0, 8, 8
  .word stage_enemy_e0401, action_flightpath_005, $2c0, $60
  .byte 0, 0, 8, $14, 5, 0, 8, 8
  .word stage_enemy_e0301, action_flightpath_006, -$40, $a0
  .byte 0, 0, 8, $14, 5, 0, 8, 8
  .word stage_enemy_e0302, action_flightpath_005, $2c0, $e0
  .byte 0, 0, 8, $14, 8, 0, 8, 8
  .word stage_enemy_e0401, action_flightpath_006, -$40, $20
  .byte 0, $20, 4, $14, 8, 0, 8, 8
  .word stage_enemy_e0501, action_flightpath_005, $2c0, $20
  .byte 0, $20, 2, $14, $a, 0, 8, 8
  .word stage_enemy_e0601, action_flightpath_006, -$40, $20
  .byte 0, $20, 2, $14, $a, 0, 8, 8
  .word stage_enemy_e0701, action_flightpath_005, $2c0, $20
  .byte 0, $20, 6, $14, $c, 0, 8, 8
  .word stage_enemy_e0702, action_flightpath_006, -$40, $20
  .byte 0, $20, 8, $14, $c, 0, 8, 8
  .word stage_enemy_e0703, action_flightpath_005, $2c0, $20
  .byte 0, $20, $a, $14, $c, 0, 8, 8
  .word stage_enemy_e0101, action_flightpath_left_circle_002, $2c0, $20
  .byte 0, $20, 6, $14, $f, 0, 8, 8
  .word stage_enemy_e0202, action_flightpath_right_circle_003, -$40, $20
  .byte 0, $20, 8, $14, $f, 0, 8, 8
  .word stage_enemy_e0401, action_flightpath_right_circle_003, $2c0, $20
  .byte 0, $20, $a, $14, $11, 0, 8, 8
  .word stage_enemy_e0401, action_flightpath_left_circle_002, $2c0, $20
  .byte 0, $20, $a, $14, $11, 0
  .fill SIZEOF_STRUCT___42, 0
  .fill SIZEOF_STRUCT___42, 0
  .fill SIZEOF_STRUCT___42, 0
  .fill SIZEOF_STRUCT___42, 0
  .fill SIZEOF_STRUCT___42, 0
  .fill SIZEOF_STRUCT___42, 0
  .fill SIZEOF_STRUCT___42, 0
  .fill SIZEOF_STRUCT___42, 0
  .fill SIZEOF_STRUCT___42, 0
  .fill SIZEOF_STRUCT___42, 0
  .fill SIZEOF_STRUCT___42, 0
  .fill SIZEOF_STRUCT___42, 0
  stage_floor_bram_tiles_01: .word mars_land_bram, mars_sand_bram, mars_sea_bram, metal_yellow_bram, metal_red_bram, metal_grey_bram
  stage_tower_bram_tiles_01: .word tower_bram, mars_sea_bram
  // This models the playbook of all the different levels in the game.
  // The embedded level field in the playbook is a pointer to a level composition.
  stage_playbooks_b: .byte $13
  .word stage_scenario_01_b, stage_player, stage_floor_01
  .byte 1
  .word stage_towers_01
.segment DataEngineFlight
  // Flight engine control.
  flight_sprite_offsets: .word 0
  .fill 2*$7e, 0
  sprite_bram_handles: .fill $100, 0
.segment Data
  __59: .text "t001"
  .byte 0
  __60: .text "p001"
  .byte 0
  __61: .text "n001"
  .byte 0
  __62: .text "e0701"
  .byte 0
  __63: .text "e0102"
  .byte 0
  __64: .text "e0201"
  .byte 0
  __65: .text "e0202"
  .byte 0
  __66: .text "e0301"
  .byte 0
  __67: .text "e0302"
  .byte 0
  __68: .text "e0401"
  .byte 0
  __69: .text "e0501"
  .byte 0
  __70: .text "e0502"
  .byte 0
  __71: .text "e0601"
  .byte 0
  __72: .text "e0602"
  .byte 0
  __73: .text "e0101"
  .byte 0
  __74: .text "e0702"
  .byte 0
  __75: .text "e0703"
  .byte 0
  __76: .text "b001"
  .byte 0
  __77: .text "b002"
  .byte 0
  __78: .text "b003"
  .byte 0
  __79: .text "b004"
  .byte 0
  nmi_relay: .word 0
  brk_relay: .word 0
  isr_vsync: .word 0
  __conio: .fill SIZEOF_STRUCT___1, 0
  __stdio_file: .fill SIZEOF_STRUCT___2, 0
  __stdio_filecount: .byte 0
  // The mouse work area.
  cx16_mouse: .fill SIZEOF_STRUCT___3, 0
.segment BramEngineFlight
  // __export volatile sprite_bram_t sprite_t001 = { "t001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_p001 = { "p001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_n001 = { "n001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0101 = { "e0101", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0102 = { "e0102", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0201 = { "e0201", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0202 = { "e0202", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0301 = { "e0301", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0302 = { "e0302", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0401 = { "e0401", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0501 = { "e0501", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0502 = { "e0502", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0601 = { "e0601", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0602 = { "e0602", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0701 = { "e0701", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0702 = { "e0702", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_e0703 = { "e0703", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_b001 = { "b001", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_b002 = { "b002", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_b003 = { "b003", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  // __export volatile sprite_bram_t sprite_b004 = { "b004", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0, 0, 0, 0 }, 0, 0, 0 };
  sprites: .word __59, __60, __61, __62, __63, __64, __65, __66, __67, __68, __69, __70, __71, __72, __73, __74, __75, __76, __77, __78, __79
  .fill 2*$b, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .word 0
  .fill 2*$1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .fill SIZEOF_STRUCT___17, 0
  .word 0
  .fill 2*$1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
.segment BramEngineFloor
  // FLOOR
  mars_land_bram: .byte 0
  .text "marsland"
  .byte 0
  .fill 7, 0
  .byte $5e
  .word $10*$10*$5e, $80, 0
  mars_sand_bram: .byte 0
  .text "marssand"
  .byte 0
  .fill 7, 0
  .byte 4
  .word $10*$10*4, $80, 0
  mars_sea_bram: .byte 0
  .text "marssea"
  .byte 0
  .fill 8, 0
  .byte $10
  .word $10*$10*$10, $80, 0
  metal_yellow_bram: .byte 0
  .text "metalyellow"
  .byte 0
  .fill 4, 0
  .byte $2a
  .word $10*$10*$2d, $80, 0
  metal_red_bram: .byte 0
  .text "metalred"
  .byte 0
  .fill 7, 0
  .byte 1
  .word $10*$10*1, $80, 0
  metal_grey_bram: .byte 0
  .text "metalgrey"
  .byte 0
  .fill 6, 0
  .byte 1
  .word $10*$10*1, $80, 0
  mars_parts: .word 0
  .fill 2*$9f, 0
  .word 0
  .fill 2*$9f, 0
  .byte 0
  .fill $9f, 0
  .byte 0
  .fill $9f, 0
  .byte 0
  .fill $9f, 0
  mars_land: .byte 0, $23, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, 1, 0, $1a, 8, $1b, 1, $54, 0, $55, $56, 2, 0, 0, $1c, 0, 3, 0, 0, $16, $17, 3, 0, 0, $2c, $2d, 3, 0, 0, $4e, $4f, 3, $52, $53, $50, $51, 4, 0, $20, 0, 0, 4, 0, $2e, 0, 0, 5, $48, $46, $49, $47, 5, $2a, $2b, $2f, $30, 5, $b, $c, $e, $f, 5, $4a, $4b, $4c, $4d, 6, $27, $22, $28, $29, 7, $12, $13, $18, $19, 7, $57, $58, $59, $5a, 8, $21, 0, 0, 0, 8, $31, 0, 0, 0, 9, $23, $24, $25, $26, $a, $a, 0, $d, 0, $a, $32, 0, $33, 0, $a, $5b, 0, $5c, 0, $a, $5d, 0, $5e, 0, $b, $10, $11, $14, $15, $c, 3, 4, 0, 0, $c, $34, $35, 0, 0, $d, 5, 6, 8, 9, $d, 5, 6, 0, $39, $e, 1, 2, 7, 0, $e, 1, $36, $3a, $3b, $f, $1d, $1e, $1f, $1d, $f, $37, $38, $3c, $3d, $f, $3e, $3f, $40, $41, $f, $45, $42, $43, $44
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  mars_sand: .byte $5e, 2, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, $f, 1, 2, 3, 4
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  mars_sea: .byte $62, 5, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, $f, 1, 2, 5, 1, $f, 3, 4, 7, 8, $f, 9, $a, $d, $e, $f, $b, $c, $f, $10
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  metal_yellow: .byte $72, $20, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, 1, $1d, $2a, $2a, $29, 2, $29, $16, $2a, $29, 3, $19, $1a, $2a, $29, 4, $29, $2a, $b, $29, 5, $11, $2a, $13, $29, 6, $25, $22, $23, $28, 7, $2a, $e, 7, $25, 8, $29, $2a, $2a, 4, 9, $29, $e, $2a, $10, $a, $d, $e, $f, $10, $b, $11, $29, $26, 8, $c, $2a, $29, 7, 8, $d, $19, $27, $29, $10, $e, $28, $1a, $13, $2a, $f, $29, $2a, $2a, $29, $10, 0, 0, 0, 0, $11, $29, $1e, $1f, $20, $12, $15, $2a, $17, $18, $13, $29, $2a, $1b, $1c, $14, 9, $a, $2a, $c, $15, $29, $12, $2a, $14, $16, $25, $22, $23, $28, $17, $21, $2a, $2a, $29, $18, 1, 2, 3, $29, $19, $d, $2a, $f, $29, $1a, $d, $2a, $f, $29, $1b, $2a, $22, $2a, $29, $1c, 5, 6, $2a, $29, $1d, $29, $2a, $23, $29, $1e, $29, $2a, $2a, $24, $1f, $29, $2a, $2a, $29
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  metal_red: .byte $86, 2, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, $f, 1, 1, 1, 1
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  mars: .word mars_parts, mars_land, mars_sea, mars_sand, metal_yellow, metal_red
  .fill 2*5, 0
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 0, 0, 0, 0
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 1, 3, 5, $f
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 3, 2, $f, $a
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 3, 3, $f, $f
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 5, $f, 4, $c
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 5, $f, 5, $f
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 7, $f, $f, $e
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 7, $f, $f, $f
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $a, $c, 8
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $b, $d, $f
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $a, $f, $a
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $b, $f, $f
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $f, $c, $c
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $f, $d, $f
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $f, $f, $e
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $f, $f, $f
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 0, 0, 0, 0
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 1, 3, 5, $f
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 3, 2, $f, $a
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 3, 3, $f, $f
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 5, $f, 4, $c
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 5, $f, 5, $f
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 7, $f, $f, $e
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 7, $f, $f, $f
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $a, $c, 8
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $b, $d, $f
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $a, $f, $a
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $b, $f, $f
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $f, $c, $c
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $f, $d, $f
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $f, $f, $e
  .word mars_sand
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $f, $f, $f
  .word metal_yellow
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 0, 0, 0, 0
  .word metal_yellow
  .byte $1e, $13, $15, $e
  .word mars_land
  .byte 0, 0, 0, 1
  .word metal_yellow
  .byte $13, $1b, $d, $1a
  .word mars_land
  .byte 0, 0, 2, 0
  .word metal_yellow
  .byte $13, $13, 3, 3
  .word mars_land
  .byte 0, 0, 3, 3
  .word metal_yellow
  .byte $15, $b, $1b, $1c
  .word mars_land
  .byte 0, 4, 0, 0
  .word metal_yellow
  .byte $15, 5, $15, 5
  .word mars_land
  .byte 0, 5, 0, 5
  .word metal_yellow
  .byte $11, $b, $d, $18
  .word mars_land
  .byte 0, 4, 2, 0
  .word metal_yellow
  .byte $11, 5, 3, 1
  .word mars_land
  .byte 0, 5, 3, 7
  .word metal_yellow
  .byte 7, $1a, $1c, $17
  .word mars_land
  .byte 8, 0, 0, 0
  .word metal_yellow
  .byte 7, $12, $14, $e
  .word mars_land
  .byte 8, 0, 0, 1
  .word metal_yellow
  .byte $a, $1a, $a, $1a
  .word mars_land
  .byte $a, 0, $a, 0
  .word metal_yellow
  .byte $a, $12, 2, 3
  .word mars_land
  .byte $a, 0, $b, 3
  .word metal_yellow
  .byte $c, $c, $1c, $1c
  .word mars_land
  .byte $c, $c, 0, 0
  .word metal_yellow
  .byte $c, 4, $14, 5
  .word mars_land
  .byte $c, $d, 0, 5
  .word metal_yellow
  .byte 8, $c, $a, $18
  .word mars_land
  .byte $e, $c, $a, 0
  .word metal_yellow
  .byte $f, $f, $f, $f
  .word mars_land
  .byte $f, $f, $f, $f
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .byte 0
  // TOWER
  tower_bram: .byte 0
  .text "tower01"
  .byte 0
  .fill 8, 0
  .byte $10
  .word $10*$10*$10, $80, 0
  tower_parts_01: .word 0
  .fill 2*$9f, 0
  .word 0
  .fill 2*$9f, 0
  .byte 0
  .fill $9f, 0
  .byte 0
  .fill $9f, 0
  .byte 0
  .fill $9f, 0
  tower: .byte 0, 5, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, 1, 1, 2, 5, 6, 2, 3, 4, 7, 8, 3, 9, $a, $d, $e, 4, $b, $c, $f, $10
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  .fill SIZEOF_STRUCT___24, 0
  tower_01: .word tower_parts_01, mars_sea, mars_land
  .fill 2*8, 0
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 0, 0, 0, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .fill SIZEOF_STRUCT___28, 0
  .byte 0
.segment BramEngineStages
  stage_bullet_fireball: .byte $12
  stage_bullet_vertical_laser: .byte $13
  stage_enemy_e0101: .byte 3, 3
  .word stage_bullet_fireball
  .byte 8, 0
  stage_enemy_e0102: .byte 4, 4
  .word stage_bullet_fireball
  .byte 8, 0
  stage_enemy_e0201: .byte 5, 5
  .word stage_bullet_fireball
  .byte 8, 0
  stage_enemy_e0202: .byte 6, 6
  .word stage_bullet_fireball
  .byte 8, 0
  stage_enemy_e0301: .byte 7, 7
  .word stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0302: .byte 8, 8
  .word stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0401: .byte 9, 9
  .word stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0501: .byte $a, $a
  .word stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0502: .byte $b, $b
  .word stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0601: .byte $c, $c
  .word stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0602: .byte $d, $d
  .word stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0701: .byte 3, 3
  .word stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0702: .byte $f, $f
  .word stage_bullet_fireball
  .byte 8, 1
  stage_enemy_e0703: .byte $10, $10
  .word stage_bullet_fireball
  .byte 8, 1
  stage_player_engine: .byte 2
  stage_player_bullet: .byte $11
  stage_player: .byte 1
  .word stage_player_engine, stage_player_bullet
  stage_floor_01: .byte 6
  .word stage_floor_bram_tiles_01, mars
  stage_towers_01: .byte 2
  .word stage_tower_bram_tiles_01, tower_01
  .byte 0, $10, $10, 8, 8
  .word stage_bullet_vertical_laser
  stage_script_b: .byte 1
  .word stage_playbooks_b
.segment DataSpriteCache
  // Cache to manage sprite control data fast, unbanked as making this banked will make things very, very complicated.
  sprite_cache: .fill SIZEOF_STRUCT___20, 0
.segment DataEngineFlight
  flight: .fill SIZEOF_STRUCT___48, 0
  sprite_cache_pool: .byte 0
  flight_sprite_offset_pool: .byte 1
.segment Hash
  collision_hash: .fill SIZEOF_STRUCT___4, 0
  collision_quadrant: .fill SIZEOF_STRUCT___57, 0
.segment DataEngineStages
  wave: .fill SIZEOF_STRUCT___49, 0
  stage: .fill SIZEOF_STRUCT___50, 0
.segment Data
  game: .byte 1, 0, 0
  .word 0
  .byte 0, $7f, $40, 1, 2, $a, $f, $f, 1, -1
  __errno: .word 0
  //Asm library lib-lru-cache:
  #define __asm_import__
  #import "lib-lru-cache.asm"
  //Asm library lib-bramheap:
  #define __asm_import__
  #import "lib-bramheap.asm"
  //Asm library lib-veraheap:
  #define __asm_import__
  #import "lib-veraheap.asm"
  //Asm library lib-palette:
  #define __asm_import__
  #import "lib-palette.asm"
  //Asm library lib-animate:
  #define __asm_import__
  #import "lib-animate.asm"
