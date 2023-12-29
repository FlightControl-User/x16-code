  // File Comments
  // Upstart
.cpu _65c02
  .file                               [name="equinoxe-flightengine.prg", type="prg", segments="Program"]
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
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT___42 = $10
  .const SIZEOF_STRUCT___1 = $8f
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  .const SIZEOF_STRUCT___2 = $90
  .const SIZEOF_STRUCT___3 = 9
  .const SIZEOF_STRUCT___17 = 4
  .const SIZEOF_STRUCT___24 = 5
  .const SIZEOF_STRUCT___28 = $c
  .const SIZEOF_STRUCT___4 = $200
  .const SIZEOF_STRUCT___57 = $100
  .const SIZEOF_STRUCT___49 = $a8
  .const SIZEOF_STRUCT___50 = $38
  .const SIZEOF_STRUCT___20 = $250
  .const SIZEOF_STRUCT___48 = $ad6
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
  /// $9F24	DATA1	VRAM Data port 1
  .label VERA_DATA1 = $9f24
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
  .label isr_vsync = 0
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
    // [3] phi from __start::__init1 to __start::@2 [phi:__start::__init1->__start::@2]
    // __start::@2
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [4] call conio_x16_init
    // [96] phi from __start::@2 to conio_x16_init [phi:__start::@2->conio_x16_init]
    jsr conio_x16_init
    // [5] phi from __start::@2 to __start::@1 [phi:__start::@2->__start::@1]
    // __start::@1
    // [6] call __lib_lru_cache_start
    // [148] phi from __start::@1 to __lib_lru_cache_start [phi:__start::@1->__lib_lru_cache_start]
    jsr lib_lru_cache.__lib_lru_cache_start
    // [7] phi from __start::@1 to __start::@3 [phi:__start::@1->__start::@3]
    // __start::@3
    // [8] call __lib_bramheap_start
    // [150] phi from __start::@3 to __lib_bramheap_start [phi:__start::@3->__lib_bramheap_start]
    jsr lib_bramheap.__lib_bramheap_start
    // [9] phi from __start::@3 to __start::@4 [phi:__start::@3->__start::@4]
    // __start::@4
    // [10] call __lib_veraheap_start
    // [152] phi from __start::@4 to __lib_veraheap_start [phi:__start::@4->__lib_veraheap_start]
    jsr lib_veraheap.__lib_veraheap_start
    // [11] phi from __start::@4 to __start::@5 [phi:__start::@4->__start::@5]
    // __start::@5
    // [12] call main
    jsr main
    // __start::@return
    // [13] return 
    rts
}
  // conio_x16_init
/// Set initial screen values.
// void conio_x16_init()
conio_x16_init: {
    // screenlayer1()
    // [97] call screenlayer1
    jsr screenlayer1
    // [98] phi from conio_x16_init to conio_x16_init::@1 [phi:conio_x16_init->conio_x16_init::@1]
    // conio_x16_init::@1
    // textcolor(CONIO_TEXTCOLOR_DEFAULT)
    // [99] call textcolor
    jsr textcolor
    // [100] phi from conio_x16_init::@1 to conio_x16_init::@2 [phi:conio_x16_init::@1->conio_x16_init::@2]
    // conio_x16_init::@2
    // bgcolor(CONIO_BACKCOLOR_DEFAULT)
    // [101] call bgcolor
    // [275] phi from conio_x16_init::@2 to bgcolor [phi:conio_x16_init::@2->bgcolor]
    // [275] phi bgcolor::color#3 = BLUE [phi:conio_x16_init::@2->bgcolor#0] -- vbum1=vbuc1 
    lda #BLUE
    sta bgcolor.color
    jsr bgcolor
    // [102] phi from conio_x16_init::@2 to conio_x16_init::@3 [phi:conio_x16_init::@2->conio_x16_init::@3]
    // conio_x16_init::@3
    // cursor(0)
    // [103] call cursor
    jsr cursor
    // [104] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // cbm_k_plot_get()
    // [105] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [106] cbm_k_plot_get::return#2 = cbm_k_plot_get::return#0
    // conio_x16_init::@5
    // [107] conio_x16_init::$4 = cbm_k_plot_get::return#2
    // BYTE1(cbm_k_plot_get())
    // [108] conio_x16_init::$5 = byte1  conio_x16_init::$4 -- vbum1=_byte1_vwum2 
    lda conio_x16_init__4+1
    sta conio_x16_init__5
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [109] *((char *)&__conio) = conio_x16_init::$5 -- _deref_pbuc1=vbum1 
    sta __conio
    // cbm_k_plot_get()
    // [110] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [111] cbm_k_plot_get::return#3 = cbm_k_plot_get::return#0
    // conio_x16_init::@6
    // [112] conio_x16_init::$6 = cbm_k_plot_get::return#3
    // BYTE0(cbm_k_plot_get())
    // [113] conio_x16_init::$7 = byte0  conio_x16_init::$6 -- vbum1=_byte0_vwum2 
    lda conio_x16_init__6
    sta conio_x16_init__7
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [114] *((char *)&__conio+1) = conio_x16_init::$7 -- _deref_pbuc1=vbum1 
    sta __conio+1
    // gotoxy(__conio.cursor_x, __conio.cursor_y)
    // [115] gotoxy::x#0 = *((char *)&__conio) -- vbum1=_deref_pbuc1 
    lda __conio
    sta gotoxy.x
    // [116] gotoxy::y#0 = *((char *)&__conio+1) -- vbum1=_deref_pbuc1 
    lda __conio+1
    sta gotoxy.y
    // [117] call gotoxy
    // [288] phi from conio_x16_init::@6 to gotoxy [phi:conio_x16_init::@6->gotoxy]
    // [288] phi gotoxy::y#10 = gotoxy::y#0 [phi:conio_x16_init::@6->gotoxy#0] -- register_copy 
    // [288] phi gotoxy::x#6 = gotoxy::x#0 [phi:conio_x16_init::@6->gotoxy#1] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@7
    // __conio.scroll[0] = 1
    // [118] *((char *)&__conio+$f) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta __conio+$f
    // __conio.scroll[1] = 1
    // [119] *((char *)&__conio+$f+1) = 1 -- _deref_pbuc1=vbuc2 
    sta __conio+$f+1
    // conio_x16_init::@return
    // }
    // [120] return 
    rts
  .segment Data
    .label conio_x16_init__4 = cbm_k_plot_get.return
    conio_x16_init__5: .byte 0
    .label conio_x16_init__6 = cbm_k_plot_get.return
    conio_x16_init__7: .byte 0
}
.segment Code
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__mem() char c)
cputc: {
    .const OFFSET_STACK_C = 0
    // [121] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbum1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta c
    // if(c=='\n')
    // [122] if(cputc::c#0==' ') goto cputc::@1 -- vbum1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [123] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(__conio.offset)
    // [124] cputc::$1 = byte0  *((unsigned int *)&__conio+$13) -- vbum1=_byte0__deref_pwuc1 
    lda __conio+$13
    sta cputc__1
    // *VERA_ADDRX_L = BYTE0(__conio.offset)
    // [125] *VERA_ADDRX_L = cputc::$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(__conio.offset)
    // [126] cputc::$2 = byte1  *((unsigned int *)&__conio+$13) -- vbum1=_byte1__deref_pwuc1 
    lda __conio+$13+1
    sta cputc__2
    // *VERA_ADDRX_M = BYTE1(__conio.offset)
    // [127] *VERA_ADDRX_M = cputc::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [128] cputc::$3 = *((char *)&__conio+5) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    sta cputc__3
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [129] *VERA_ADDRX_H = cputc::$3 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [130] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbum1 
    lda c
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [131] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // if(!__conio.hscroll[__conio.layer])
    // [132] if(0==((char *)&__conio+$11)[*((char *)&__conio+2)]) goto cputc::@5 -- 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$11,y
    cmp #0
    beq __b5
    // cputc::@3
    // if(__conio.cursor_x >= __conio.mapwidth)
    // [133] if(*((char *)&__conio)>=*((char *)&__conio+8)) goto cputc::@6 -- _deref_pbuc1_ge__deref_pbuc2_then_la1 
    lda __conio
    cmp __conio+8
    bcs __b6
    // cputc::@4
    // __conio.cursor_x++;
    // [134] *((char *)&__conio) = ++ *((char *)&__conio) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio
    // cputc::@7
  __b7:
    // __conio.offset++;
    // [135] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // [136] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // cputc::@return
    // }
    // [137] return 
    rts
    // [138] phi from cputc::@3 to cputc::@6 [phi:cputc::@3->cputc::@6]
    // cputc::@6
  __b6:
    // cputln()
    // [139] call cputln
    jsr cputln
    jmp __b7
    // cputc::@5
  __b5:
    // if(__conio.cursor_x >= __conio.width)
    // [140] if(*((char *)&__conio)>=*((char *)&__conio+6)) goto cputc::@8 -- _deref_pbuc1_ge__deref_pbuc2_then_la1 
    lda __conio
    cmp __conio+6
    bcs __b8
    // cputc::@9
    // __conio.cursor_x++;
    // [141] *((char *)&__conio) = ++ *((char *)&__conio) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio
    // __conio.offset++;
    // [142] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    // [143] *((unsigned int *)&__conio+$13) = ++ *((unsigned int *)&__conio+$13) -- _deref_pwuc1=_inc__deref_pwuc1 
    inc __conio+$13
    bne !+
    inc __conio+$13+1
  !:
    rts
    // [144] phi from cputc::@5 to cputc::@8 [phi:cputc::@5->cputc::@8]
    // cputc::@8
  __b8:
    // cputln()
    // [145] call cputln
    jsr cputln
    rts
    // [146] phi from cputc to cputc::@1 [phi:cputc->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [147] call cputln
    jsr cputln
    rts
  .segment Data
    cputc__1: .byte 0
    cputc__2: .byte 0
    cputc__3: .byte 0
    c: .byte 0
}
.segment Code
  // main
/// @brief game startup
// void main()
main: {
    .const vera_display_set_hstart1_start = 1
    .const vera_display_set_hstop1_stop = $9f
    .const vera_display_set_vstart1_start = 0
    .const vera_display_set_vstop1_stop = $ee
    .label cx16_k_screen_set_charset1_offset = $50
    // cx16_k_screen_set_charset(3, (char *)0)
    // [154] main::cx16_k_screen_set_charset1_charset = 3 -- vbum1=vbuc1 
    lda #3
    sta cx16_k_screen_set_charset1_charset
    // [155] main::cx16_k_screen_set_charset1_offset = (char *) 0 -- pbuz1=pbuc1 
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
    // [157] BROM = CX16_ROM_KERNAL -- vbuz1=vbuc1 
    lda #CX16_ROM_KERNAL
    sta.z BROM
    // main::vera_layer0_hide1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [158] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER0_ENABLE
    // [159] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER0_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER0_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [160] phi from main::vera_layer0_hide1 to main::@9 [phi:main::vera_layer0_hide1->main::@9]
    // main::@9
    // vera_layer1_hide()
    // [161] call vera_layer1_hide
    jsr vera_layer1_hide
    // [162] phi from main::@9 to main::@13 [phi:main::@9->main::@13]
    // main::@13
    // petscii()
    // [163] call petscii
    // [314] phi from main::@13 to petscii [phi:main::@13->petscii]
    jsr petscii
    // [164] phi from main::@13 to main::@14 [phi:main::@13->main::@14]
    // main::@14
    // scroll(1)
    // [165] call scroll
    // [331] phi from main::@14 to scroll [phi:main::@14->scroll]
    // [331] phi scroll::onoff#3 = 1 [phi:main::@14->scroll#0] -- vbum1=vbuc1 
    lda #1
    sta scroll.onoff
    jsr scroll
    // [166] phi from main::@14 to main::@15 [phi:main::@14->main::@15]
    // main::@15
    // textcolor(WHITE)
    // [167] call textcolor
    jsr textcolor
    // [168] phi from main::@15 to main::@16 [phi:main::@15->main::@16]
    // main::@16
    // bgcolor(BLACK)
    // [169] call bgcolor
    // [275] phi from main::@16 to bgcolor [phi:main::@16->bgcolor]
    // [275] phi bgcolor::color#3 = BLACK [phi:main::@16->bgcolor#0] -- vbum1=vbuc1 
    lda #BLACK
    sta bgcolor.color
    jsr bgcolor
    // [170] phi from main::@16 to main::@17 [phi:main::@16->main::@17]
    // main::@17
    // clrscr()
    // [171] call clrscr
    jsr clrscr
    // [172] phi from main::@17 to main::@18 [phi:main::@17->main::@18]
    // main::@18
    // equinoxe_init()
    // [173] call equinoxe_init
  // music = fopen("music.bin","r");
    // [357] phi from main::@18 to equinoxe_init [phi:main::@18->equinoxe_init]
    jsr equinoxe_init
    // main::@19
    // bram_heap_bram_bank_init(BANK_HEAP_BRAM)
    // [174] bram_heap_bram_bank_init::bram_bank = $f -- vbum1=vbuc1 
    // We initialize the Commander X16 BRAM heap manager. This manages dynamically the memory space in banked ram as a real heap.
    lda #$f
    sta lib_bramheap.bram_heap_bram_bank_init.bram_bank
    // [175] callexecute bram_heap_bram_bank_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_bram_bank_init
    // bram_heap_segment_init(0, 0x10, (bram_ptr_t)0xA000, 0x3C, (bram_ptr_t)0xA000)
    // [176] bram_heap_segment_init::s = 0 -- vbum1=vbuc1 
    // BREAKPOINT
    lda #0
    sta lib_bramheap.bram_heap_segment_init.s
    // [177] bram_heap_segment_init::bram_bank_floor = $10 -- vbum1=vbuc1 
    lda #$10
    sta lib_bramheap.bram_heap_segment_init.bram_bank_floor
    // [178] bram_heap_segment_init::bram_ptr_floor = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor+1
    // [179] bram_heap_segment_init::bram_bank_ceil = $3c -- vbum1=vbuc1 
    lda #$3c
    sta lib_bramheap.bram_heap_segment_init.bram_bank_ceil
    // [180] bram_heap_segment_init::bram_ptr_ceil = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil+1
    // [181] callexecute bram_heap_segment_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_segment_init
    // bram_heap_segment_init(1, 0x3C, (bram_ptr_t)0xA000, 0x3F, (bram_ptr_t)0xA000)
    // [182] bram_heap_segment_init::s = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_bramheap.bram_heap_segment_init.s
    // [183] bram_heap_segment_init::bram_bank_floor = $3c -- vbum1=vbuc1 
    lda #$3c
    sta lib_bramheap.bram_heap_segment_init.bram_bank_floor
    // [184] bram_heap_segment_init::bram_ptr_floor = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor+1
    // [185] bram_heap_segment_init::bram_bank_ceil = $3f -- vbum1=vbuc1 
    lda #$3f
    sta lib_bramheap.bram_heap_segment_init.bram_bank_ceil
    // [186] bram_heap_segment_init::bram_ptr_ceil = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil+1
    // [187] callexecute bram_heap_segment_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_segment_init
    // vera_heap_bram_bank_init(BANK_VERA_HEAP)
    // [188] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    // We intialize the Commander X16 VERA heap manager. This manages dynamically the memory space in vera ram as a real heap.
    lda #1
    pha
    // [189] callexecute vera_heap_bram_bank_init  -- call_stack_near 
    jsr lib_veraheap.vera_heap_bram_bank_init
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // vera_heap_segment_init(VERA_HEAP_SEGMENT_TILES, FLOOR_TILE_BANK_VRAM, FLOOR_TILE_OFFSET_VRAM, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM)
    // [191] stackpush(char) = 0 -- _stackpushbyte_=vbuc1 
    lda #0
    pha
    // [192] stackpush(char) = 0 -- _stackpushbyte_=vbuc1 
    pha
    // [193] stackpush(unsigned int) = 0 -- _stackpushword_=vbuc1 
    pha
    pha
    // [194] stackpush(char) = 0 -- _stackpushbyte_=vbuc1 
    pha
    // [195] stackpush(unsigned int) = $5000 -- _stackpushword_=vwuc1 
    lda #>$5000
    pha
    lda #<$5000
    pha
    // [196] callexecute vera_heap_segment_init  -- call_stack_near 
    jsr lib_veraheap.vera_heap_segment_init
    // sideeffect stackpullpadding(7) -- _stackpullpadding_7 
    pla
    pla
    pla
    pla
    pla
    pla
    pla
    // vera_heap_segment_init(VERA_HEAP_SEGMENT_SPRITES, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM, FLOOR_MAP1_BANK_VRAM, FLOOR_MAP1_OFFSET_VRAM)
    // [198] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    // FLOOR_TILE segment for tiles of various sizes and types
    lda #1
    pha
    // [199] stackpush(char) = 0 -- _stackpushbyte_=vbuc1 
    lda #0
    pha
    // [200] stackpush(unsigned int) = $5000 -- _stackpushword_=vwuc1 
    lda #>$5000
    pha
    lda #<$5000
    pha
    // [201] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    lda #1
    pha
    // [202] stackpush(unsigned int) = $d000 -- _stackpushword_=vwuc1 
    lda #>$d000
    pha
    lda #<$d000
    pha
    // [203] callexecute vera_heap_segment_init  -- call_stack_near 
    jsr lib_veraheap.vera_heap_segment_init
    // sideeffect stackpullpadding(7) -- _stackpullpadding_7 
    pla
    pla
    pla
    pla
    pla
    pla
    pla
    // bram_heap_dump(0,0,0)
    // [205] bram_heap_dump::s = 0 -- vbum1=vbuc1 
    // SPRITES segment for sprites of various sizes
    lda #0
    sta lib_bramheap.bram_heap_dump.s
    // [206] bram_heap_dump::x = 0 -- vbum1=vbuc1 
    sta lib_bramheap.bram_heap_dump.x
    // [207] bram_heap_dump::y = 0 -- vbum1=vbuc1 
    sta lib_bramheap.bram_heap_dump.y
    // [208] callexecute bram_heap_dump  -- call_var_near 
    jsr lib_bramheap.bram_heap_dump
    // [209] phi from main::@19 main::@20 to main::@1 [phi:main::@19/main::@20->main::@1]
    // main::@1
  __b1:
    // kbhit()
    // [210] call kbhit
    // [375] phi from main::@1 to kbhit [phi:main::@1->kbhit]
    jsr kbhit
    // kbhit()
    // [211] kbhit::return#10 = kbhit::return#0
    // main::@20
    // [212] main::$31 = kbhit::return#10
    // while(!kbhit())
    // [213] if(0==main::$31) goto main::@1 -- 0_eq_vbum1_then_la1 
    lda main__31
    beq __b1
    // [214] phi from main::@20 to main::@2 [phi:main::@20->main::@2]
    // main::@2
    // stage_reset()
    // [215] call stage_reset -- call_phi_close_cx16_ram 
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
    // [216] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_HSTART = start
    // [217] *VERA_DC_HSTART = main::vera_display_set_hstart1_start#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_hstart1_start
    sta VERA_DC_HSTART
    // main::vera_display_set_hstop1
    // *VERA_CTRL |= VERA_DCSEL
    // [218] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_HSTOP = stop
    // [219] *VERA_DC_HSTOP = main::vera_display_set_hstop1_stop#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_hstop1_stop
    sta VERA_DC_HSTOP
    // main::vera_display_set_vstart1
    // *VERA_CTRL |= VERA_DCSEL
    // [220] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VSTART = start
    // [221] *VERA_DC_VSTART = main::vera_display_set_vstart1_start#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_vstart1_start
    sta VERA_DC_VSTART
    // main::vera_display_set_vstop1
    // *VERA_CTRL |= VERA_DCSEL
    // [222] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VSTOP = stop
    // [223] *VERA_DC_VSTOP = main::vera_display_set_vstop1_stop#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_vstop1_stop
    sta VERA_DC_VSTOP
    // main::@10
    // bram_heap_dump(0,0,0)
    // [224] bram_heap_dump::s = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_bramheap.bram_heap_dump.s
    // [225] bram_heap_dump::x = 0 -- vbum1=vbuc1 
    sta lib_bramheap.bram_heap_dump.x
    // [226] bram_heap_dump::y = 0 -- vbum1=vbuc1 
    sta lib_bramheap.bram_heap_dump.y
    // [227] callexecute bram_heap_dump  -- call_var_near 
    jsr lib_bramheap.bram_heap_dump
    // [228] phi from main::@10 main::@21 to main::@3 [phi:main::@10/main::@21->main::@3]
    // main::@3
  __b3:
    // kbhit()
    // [229] call kbhit
    // [375] phi from main::@3 to kbhit [phi:main::@3->kbhit]
    jsr kbhit
    // kbhit()
    // [230] kbhit::return#11 = kbhit::return#0
    // main::@21
    // [231] main::$33 = kbhit::return#11
    // while(!kbhit())
    // [232] if(0==main::$33) goto main::@3 -- 0_eq_vbum1_then_la1 
    lda main__33
    beq __b3
    // [233] phi from main::@21 to main::@4 [phi:main::@21->main::@4]
    // main::@4
    // stage_logic()
    // [234] call stage_logic -- call_phi_close_cx16_ram 
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
    // [235] phi from main::@4 to main::@22 [phi:main::@4->main::@22]
    // main::@22
    // scroll(0)
    // [236] call scroll
    // [331] phi from main::@22 to scroll [phi:main::@22->scroll]
    // [331] phi scroll::onoff#3 = 0 [phi:main::@22->scroll#0] -- vbum1=vbuc1 
    lda #0
    sta scroll.onoff
    jsr scroll
    // main::cbm_k_clrchn1
    // asm
    // asm { jsrCBM_CLRCHN  }
    jsr CBM_CLRCHN
    // [238] phi from main::@23 main::cbm_k_clrchn1 to main::@5 [phi:main::@23/main::cbm_k_clrchn1->main::@5]
    // main::@5
  __b5:
    // kbhit()
    // [239] call kbhit
    // [375] phi from main::@5 to kbhit [phi:main::@5->kbhit]
    jsr kbhit
    // kbhit()
    // [240] kbhit::return#12 = kbhit::return#0
    // main::@23
    // [241] main::$35 = kbhit::return#12
    // while(!kbhit())
    // [242] if(0==main::$35) goto main::@5 -- 0_eq_vbum1_then_la1 
    lda main__35
    beq __b5
    // main::@6
    // cx16_mouse_config(0xFF, 80, 60)
    // [243] cx16_mouse_config::visible = $ff -- vbum1=vbuc1 
    lda #$ff
    sta cx16_mouse_config.visible
    // [244] cx16_mouse_config::scalex = $50 -- vbum1=vbuc1 
    lda #$50
    sta cx16_mouse_config.scalex
    // [245] cx16_mouse_config::scaley = $3c -- vbum1=vbuc1 
    lda #$3c
    sta cx16_mouse_config.scaley
    // [246] call cx16_mouse_config
    jsr cx16_mouse_config
    // [247] phi from main::@6 to main::@24 [phi:main::@6->main::@24]
    // main::@24
    // cx16_mouse_get()
    // [248] call cx16_mouse_get
    jsr cx16_mouse_get
    // main::vera_sprites_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [249] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE
    // [250] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_SPRITES_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITES_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [251] phi from main::vera_sprites_show1 to main::@11 [phi:main::vera_sprites_show1->main::@11]
    // main::@11
    // volatile unsigned char ch = kbhit()
    // [252] call kbhit
    // [375] phi from main::@11 to kbhit [phi:main::@11->kbhit]
    jsr kbhit
    // volatile unsigned char ch = kbhit()
    // [253] kbhit::return#13 = kbhit::return#0
    // main::@25
    // [254] main::ch = kbhit::return#13 -- vbum1=vbum2 
    lda kbhit.return
    sta ch
    // main::@7
  __b7:
    // while (ch != 'x')
    // [255] if(main::ch!='x'pm) goto main::@8 -- vbum1_neq_vbuc1_then_la1 
  .encoding "petscii_mixed"
    lda #'x'
    cmp ch
    bne __b8
    // main::bank_set_brom2
    // BROM = bank
    // [256] BROM = CX16_ROM_BASIC -- vbuz1=vbuc1 
    lda #CX16_ROM_BASIC
    sta.z BROM
    // main::@return
    // }
    // [257] return 
    rts
    // [258] phi from main::@7 to main::@8 [phi:main::@7->main::@8]
    // main::@8
  __b8:
    // irq_vsync()
    // [259] call irq_vsync
    // [477] phi from main::@8 to irq_vsync [phi:main::@8->irq_vsync]
    jsr irq_vsync
    // main::SEI1
    // asm
    // asm { sei  }
    sei
    // [261] phi from main::SEI1 to main::@12 [phi:main::SEI1->main::@12]
    // main::@12
    // kbhit()
    // [262] call kbhit
    // [375] phi from main::@12 to kbhit [phi:main::@12->kbhit]
    jsr kbhit
    // kbhit()
    // [263] kbhit::return#14 = kbhit::return#0
    // main::@26
    // [264] main::$40 = kbhit::return#14
    // ch=kbhit()
    // [265] main::ch = main::$40 -- vbum1=vbum2 
    lda main__40
    sta ch
    // main::CLI1
    // asm
    // asm { cli  }
    cli
    jmp __b7
  .segment Data
    ch: .byte 0
    .label main__31 = kbhit.return
    .label main__33 = kbhit.return
    .label main__35 = kbhit.return
    .label main__40 = kbhit.return
    cx16_k_screen_set_charset1_charset: .byte 0
}
.segment Code
  // screenlayer1
// Set the layer with which the conio will interact.
// void screenlayer1()
screenlayer1: {
    // screenlayer(1, *VERA_L1_MAPBASE, *VERA_L1_CONFIG)
    // [267] screenlayer::mapbase#0 = *VERA_L1_MAPBASE -- vbum1=_deref_pbuc1 
    lda VERA_L1_MAPBASE
    sta screenlayer.mapbase
    // [268] screenlayer::config#0 = *VERA_L1_CONFIG -- vbum1=_deref_pbuc1 
    lda VERA_L1_CONFIG
    sta screenlayer.config
    // [269] call screenlayer
    jsr screenlayer
    // screenlayer1::@return
    // }
    // [270] return 
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
    // [271] textcolor::$0 = *((char *)&__conio+$d) & $f0 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and __conio+$d
    sta textcolor__0
    // __conio.color & 0xF0 | color
    // [272] textcolor::$1 = textcolor::$0 | WHITE -- vbum1=vbum1_bor_vbuc1 
    lda #WHITE
    ora textcolor__1
    sta textcolor__1
    // __conio.color = __conio.color & 0xF0 | color
    // [273] *((char *)&__conio+$d) = textcolor::$1 -- _deref_pbuc1=vbum1 
    sta __conio+$d
    // textcolor::@return
    // }
    // [274] return 
    rts
  .segment Data
    textcolor__0: .byte 0
    .label textcolor__1 = textcolor__0
}
.segment Code
  // bgcolor
// Set the back color for text output.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor(__mem() char color)
bgcolor: {
    // __conio.color & 0x0F
    // [276] bgcolor::$0 = *((char *)&__conio+$d) & $f -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$f
    and __conio+$d
    sta bgcolor__0
    // color << 4
    // [277] bgcolor::$1 = bgcolor::color#3 << 4 -- vbum1=vbum1_rol_4 
    lda bgcolor__1
    asl
    asl
    asl
    asl
    sta bgcolor__1
    // __conio.color & 0x0F | color << 4
    // [278] bgcolor::$2 = bgcolor::$0 | bgcolor::$1 -- vbum1=vbum1_bor_vbum2 
    lda bgcolor__2
    ora bgcolor__1
    sta bgcolor__2
    // __conio.color = __conio.color & 0x0F | color << 4
    // [279] *((char *)&__conio+$d) = bgcolor::$2 -- _deref_pbuc1=vbum1 
    sta __conio+$d
    // bgcolor::@return
    // }
    // [280] return 
    rts
  .segment Data
    bgcolor__0: .byte 0
    .label bgcolor__1 = color
    .label bgcolor__2 = bgcolor__0
    color: .byte 0
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
    // [281] *((char *)&__conio+$c) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta __conio+$c
    // cursor::@return
    // }
    // [282] return 
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
    // [283] cbm_k_plot_get::x = 0 -- vbum1=vbuc1 
    lda #0
    sta x
    // __mem unsigned char y
    // [284] cbm_k_plot_get::y = 0 -- vbum1=vbuc1 
    sta y
    // kickasm
    // kickasm( uses cbm_k_plot_get::x uses cbm_k_plot_get::y uses CBM_PLOT) {{ sec         jsr CBM_PLOT         stx y         sty x      }}
    sec
        jsr CBM_PLOT
        stx y
        sty x
    
    // MAKEWORD(x,y)
    // [286] cbm_k_plot_get::return#0 = cbm_k_plot_get::x w= cbm_k_plot_get::y -- vwum1=vbum2_word_vbum3 
    lda x
    sta return+1
    lda y
    sta return
    // cbm_k_plot_get::@return
    // }
    // [287] return 
    rts
  .segment Data
    x: .byte 0
    y: .byte 0
    return: .word 0
}
.segment Code
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__mem() char x, __mem() char y)
gotoxy: {
    // (x>=__conio.width)?__conio.width:x
    // [289] if(gotoxy::x#6>=*((char *)&__conio+6)) goto gotoxy::@1 -- vbum1_ge__deref_pbuc1_then_la1 
    lda x
    cmp __conio+6
    bcs __b1
    // [291] phi from gotoxy gotoxy::@1 to gotoxy::@2 [phi:gotoxy/gotoxy::@1->gotoxy::@2]
    // [291] phi gotoxy::$3 = gotoxy::x#6 [phi:gotoxy/gotoxy::@1->gotoxy::@2#0] -- register_copy 
    jmp __b2
    // gotoxy::@1
  __b1:
    // [290] gotoxy::$2 = *((char *)&__conio+6) -- vbum1=_deref_pbuc1 
    lda __conio+6
    sta gotoxy__2
    // gotoxy::@2
  __b2:
    // __conio.cursor_x = (x>=__conio.width)?__conio.width:x
    // [292] *((char *)&__conio) = gotoxy::$3 -- _deref_pbuc1=vbum1 
    lda gotoxy__3
    sta __conio
    // (y>=__conio.height)?__conio.height:y
    // [293] if(gotoxy::y#10>=*((char *)&__conio+7)) goto gotoxy::@3 -- vbum1_ge__deref_pbuc1_then_la1 
    lda y
    cmp __conio+7
    bcs __b3
    // gotoxy::@4
    // [294] gotoxy::$14 = gotoxy::y#10 -- vbum1=vbum2 
    sta gotoxy__14
    // [295] phi from gotoxy::@3 gotoxy::@4 to gotoxy::@5 [phi:gotoxy::@3/gotoxy::@4->gotoxy::@5]
    // [295] phi gotoxy::$7 = gotoxy::$6 [phi:gotoxy::@3/gotoxy::@4->gotoxy::@5#0] -- register_copy 
    // gotoxy::@5
  __b5:
    // __conio.cursor_y = (y>=__conio.height)?__conio.height:y
    // [296] *((char *)&__conio+1) = gotoxy::$7 -- _deref_pbuc1=vbum1 
    lda gotoxy__7
    sta __conio+1
    // __conio.cursor_x << 1
    // [297] gotoxy::$8 = *((char *)&__conio) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda __conio
    asl
    sta gotoxy__8
    // __conio.offsets[y] + __conio.cursor_x << 1
    // [298] gotoxy::$10 = gotoxy::y#10 << 1 -- vbum1=vbum1_rol_1 
    asl gotoxy__10
    // [299] gotoxy::$9 = ((unsigned int *)&__conio+$15)[gotoxy::$10] + gotoxy::$8 -- vwum1=pwuc1_derefidx_vbum2_plus_vbum3 
    ldy gotoxy__10
    clc
    adc __conio+$15,y
    sta gotoxy__9
    lda __conio+$15+1,y
    adc #0
    sta gotoxy__9+1
    // __conio.offset = __conio.offsets[y] + __conio.cursor_x << 1
    // [300] *((unsigned int *)&__conio+$13) = gotoxy::$9 -- _deref_pwuc1=vwum1 
    lda gotoxy__9
    sta __conio+$13
    lda gotoxy__9+1
    sta __conio+$13+1
    // gotoxy::@return
    // }
    // [301] return 
    rts
    // gotoxy::@3
  __b3:
    // (y>=__conio.height)?__conio.height:y
    // [302] gotoxy::$6 = *((char *)&__conio+7) -- vbum1=_deref_pbuc1 
    lda __conio+7
    sta gotoxy__6
    jmp __b5
  .segment Data
    .label gotoxy__2 = gotoxy__3
    gotoxy__3: .byte 0
    .label gotoxy__6 = gotoxy__7
    gotoxy__7: .byte 0
    gotoxy__8: .byte 0
    gotoxy__9: .word 0
    .label gotoxy__10 = y
    .label x = gotoxy__3
    y: .byte 0
    .label gotoxy__14 = gotoxy__7
}
.segment Code
  // cputln
// Print a newline
// void cputln()
cputln: {
    // __conio.cursor_x = 0
    // [303] *((char *)&__conio) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio
    // __conio.cursor_y++;
    // [304] *((char *)&__conio+1) = ++ *((char *)&__conio+1) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+1
    // __conio.offset = __conio.offsets[__conio.cursor_y]
    // [305] cputln::$3 = *((char *)&__conio+1) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda __conio+1
    asl
    sta cputln__3
    // [306] *((unsigned int *)&__conio+$13) = ((unsigned int *)&__conio+$15)[cputln::$3] -- _deref_pwuc1=pwuc2_derefidx_vbum1 
    tay
    lda __conio+$15,y
    sta __conio+$13
    lda __conio+$15+1,y
    sta __conio+$13+1
    // if(__conio.scroll[__conio.layer])
    // [307] if(0==((char *)&__conio+$f)[*((char *)&__conio+2)]) goto cputln::@return -- 0_eq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$f,y
    cmp #0
    beq __breturn
    // [308] phi from cputln to cputln::@1 [phi:cputln->cputln::@1]
    // cputln::@1
    // cscroll()
    // [309] call cscroll
    jsr cscroll
    // cputln::@return
  __breturn:
    // }
    // [310] return 
    rts
  .segment Data
    cputln__3: .byte 0
}
.segment Code
  // vera_layer1_hide
/**
 * @brief Hide the layer 1 to be displayed from the screen.
 */
// void vera_layer1_hide()
vera_layer1_hide: {
    // *VERA_CTRL &= ~VERA_DCSEL
    // [311] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER1_ENABLE
    // [312] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER1_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER1_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_layer1_hide::@return
    // }
    // [313] return 
    rts
}
  // petscii
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
    // [315] call vera_layer1_mode_tile
    // [547] phi from petscii to vera_layer1_mode_tile [phi:petscii->vera_layer1_mode_tile]
    jsr vera_layer1_mode_tile
    // [316] phi from petscii to petscii::@2 [phi:petscii->petscii::@2]
    // petscii::@2
    // screenlayer1()
    // [317] call screenlayer1
    jsr screenlayer1
    // [318] phi from petscii::@2 to petscii::@3 [phi:petscii::@2->petscii::@3]
    // petscii::@3
    // textcolor(WHITE)
    // [319] call textcolor
    jsr textcolor
    // [320] phi from petscii::@3 to petscii::@4 [phi:petscii::@3->petscii::@4]
    // petscii::@4
    // bgcolor(BLACK)
    // [321] call bgcolor
    // [275] phi from petscii::@4 to bgcolor [phi:petscii::@4->bgcolor]
    // [275] phi bgcolor::color#3 = BLACK [phi:petscii::@4->bgcolor#0] -- vbum1=vbuc1 
    lda #BLACK
    sta bgcolor.color
    jsr bgcolor
    // [322] phi from petscii::@4 to petscii::@5 [phi:petscii::@4->petscii::@5]
    // petscii::@5
    // clrscr()
    // [323] call clrscr
    jsr clrscr
    // petscii::vera_layer1_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [324] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_LAYER1_ENABLE
    // [325] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_LAYER1_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER1_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // petscii::vera_layer0_hide1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [326] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER0_ENABLE
    // [327] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER0_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER0_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [328] phi from petscii::vera_layer0_hide1 to petscii::@1 [phi:petscii::vera_layer0_hide1->petscii::@1]
    // petscii::@1
    // scroll(0)
    // [329] call scroll
    // [331] phi from petscii::@1 to scroll [phi:petscii::@1->scroll]
    // [331] phi scroll::onoff#3 = 0 [phi:petscii::@1->scroll#0] -- vbum1=vbuc1 
    lda #0
    sta scroll.onoff
    jsr scroll
    // petscii::@return
    // }
    // [330] return 
    rts
}
  // scroll
// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 0, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
// char scroll(__mem() char onoff)
scroll: {
    // __conio.scroll[__conio.layer] = onoff
    // [332] ((char *)&__conio+$f)[*((char *)&__conio+2)] = scroll::onoff#3 -- pbuc1_derefidx_(_deref_pbuc2)=vbum1 
    lda onoff
    ldy __conio+2
    sta __conio+$f,y
    // scroll::@return
    // }
    // [333] return 
    rts
  .segment Data
    onoff: .byte 0
}
.segment Code
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
// void clrscr()
clrscr: {
    // unsigned int line_text = __conio.mapbase_offset
    // [334] clrscr::line_text#0 = *((unsigned int *)&__conio+3) -- vwum1=_deref_pwuc1 
    lda __conio+3
    sta line_text
    lda __conio+3+1
    sta line_text+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [335] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // __conio.mapbase_bank | VERA_INC_1
    // [336] clrscr::$0 = *((char *)&__conio+5) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    sta clrscr__0
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [337] *VERA_ADDRX_H = clrscr::$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // unsigned char l = __conio.mapheight
    // [338] clrscr::l#0 = *((char *)&__conio+9) -- vbum1=_deref_pbuc1 
    lda __conio+9
    sta l
    // [339] phi from clrscr clrscr::@3 to clrscr::@1 [phi:clrscr/clrscr::@3->clrscr::@1]
    // [339] phi clrscr::l#4 = clrscr::l#0 [phi:clrscr/clrscr::@3->clrscr::@1#0] -- register_copy 
    // [339] phi clrscr::ch#0 = clrscr::line_text#0 [phi:clrscr/clrscr::@3->clrscr::@1#1] -- register_copy 
    // clrscr::@1
  __b1:
    // BYTE0(ch)
    // [340] clrscr::$1 = byte0  clrscr::ch#0 -- vbum1=_byte0_vwum2 
    lda ch
    sta clrscr__1
    // *VERA_ADDRX_L = BYTE0(ch)
    // [341] *VERA_ADDRX_L = clrscr::$1 -- _deref_pbuc1=vbum1 
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(ch)
    // [342] clrscr::$2 = byte1  clrscr::ch#0 -- vbum1=_byte1_vwum2 
    lda ch+1
    sta clrscr__2
    // *VERA_ADDRX_M = BYTE1(ch)
    // [343] *VERA_ADDRX_M = clrscr::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // unsigned char c = __conio.mapwidth
    // [344] clrscr::c#0 = *((char *)&__conio+8) -- vbum1=_deref_pbuc1 
    lda __conio+8
    sta c
    // [345] phi from clrscr::@1 clrscr::@2 to clrscr::@2 [phi:clrscr::@1/clrscr::@2->clrscr::@2]
    // [345] phi clrscr::c#2 = clrscr::c#0 [phi:clrscr::@1/clrscr::@2->clrscr::@2#0] -- register_copy 
    // clrscr::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [346] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
  .encoding "screencode_mixed"
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [347] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // c--;
    // [348] clrscr::c#1 = -- clrscr::c#2 -- vbum1=_dec_vbum1 
    dec c
    // while(c)
    // [349] if(0!=clrscr::c#1) goto clrscr::@2 -- 0_neq_vbum1_then_la1 
    lda c
    bne __b2
    // clrscr::@3
    // line_text += __conio.rowskip
    // [350] clrscr::line_text#1 = clrscr::ch#0 + *((unsigned int *)&__conio+$a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda line_text
    adc __conio+$a
    sta line_text
    lda line_text+1
    adc __conio+$a+1
    sta line_text+1
    // l--;
    // [351] clrscr::l#1 = -- clrscr::l#4 -- vbum1=_dec_vbum1 
    dec l
    // while(l)
    // [352] if(0!=clrscr::l#1) goto clrscr::@1 -- 0_neq_vbum1_then_la1 
    lda l
    bne __b1
    // clrscr::@4
    // __conio.cursor_x = 0
    // [353] *((char *)&__conio) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio
    // __conio.cursor_y = 0
    // [354] *((char *)&__conio+1) = 0 -- _deref_pbuc1=vbuc2 
    sta __conio+1
    // __conio.offset = __conio.mapbase_offset
    // [355] *((unsigned int *)&__conio+$13) = *((unsigned int *)&__conio+3) -- _deref_pwuc1=_deref_pwuc2 
    lda __conio+3
    sta __conio+$13
    lda __conio+3+1
    sta __conio+$13+1
    // clrscr::@return
    // }
    // [356] return 
    rts
  .segment Data
    clrscr__0: .byte 0
    clrscr__1: .byte 0
    clrscr__2: .byte 0
    .label line_text = ch
    l: .byte 0
    ch: .word 0
    c: .byte 0
}
.segment Code
  // equinoxe_init
// __mem FILE* music;
// unsigned char music_buffer[1024];
// void equinoxe_init()
equinoxe_init: {
    // fload_bram("stages.bin", BANK_ENGINE_STAGES, (bram_ptr_t)0xA000)
    // [358] call fload_bram
    // [562] phi from equinoxe_init to fload_bram [phi:equinoxe_init->fload_bram]
    // [562] phi __errno#104 = 0 [phi:equinoxe_init->fload_bram#0] -- vwsm1=vwsc1 
    lda #<0
    sta __errno
    sta __errno+1
    // [562] phi fload_bram::filename#10 = equinoxe_init::filename [phi:equinoxe_init->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename
    sta.z fload_bram.filename
    lda #>filename
    sta.z fload_bram.filename+1
    // [562] phi fload_bram::dbank#5 = 3 [phi:equinoxe_init->fload_bram#2] -- vbum1=vbuc1 
    lda #3
    sta fload_bram.dbank
    jsr fload_bram
    // [359] phi from equinoxe_init to equinoxe_init::@1 [phi:equinoxe_init->equinoxe_init::@1]
    // equinoxe_init::@1
    // fload_bram("bramflight1.bin", BANK_ENGINE_SPRITES, (bram_ptr_t)0xA000)
    // [360] call fload_bram
    // [562] phi from equinoxe_init::@1 to fload_bram [phi:equinoxe_init::@1->fload_bram]
    // [562] phi __errno#104 = __errno#103 [phi:equinoxe_init::@1->fload_bram#0] -- register_copy 
    // [562] phi fload_bram::filename#10 = equinoxe_init::filename1 [phi:equinoxe_init::@1->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename1
    sta.z fload_bram.filename
    lda #>filename1
    sta.z fload_bram.filename+1
    // [562] phi fload_bram::dbank#5 = 4 [phi:equinoxe_init::@1->fload_bram#2] -- vbum1=vbuc1 
    lda #4
    sta fload_bram.dbank
    jsr fload_bram
    // [361] phi from equinoxe_init::@1 to equinoxe_init::@2 [phi:equinoxe_init::@1->equinoxe_init::@2]
    // equinoxe_init::@2
    // fload_bram("bramfloor1.bin", BANK_ENGINE_FLOOR, (bram_ptr_t)0xA000)
    // [362] call fload_bram
    // [562] phi from equinoxe_init::@2 to fload_bram [phi:equinoxe_init::@2->fload_bram]
    // [562] phi __errno#104 = __errno#103 [phi:equinoxe_init::@2->fload_bram#0] -- register_copy 
    // [562] phi fload_bram::filename#10 = equinoxe_init::filename2 [phi:equinoxe_init::@2->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename2
    sta.z fload_bram.filename
    lda #>filename2
    sta.z fload_bram.filename+1
    // [562] phi fload_bram::dbank#5 = 5 [phi:equinoxe_init::@2->fload_bram#2] -- vbum1=vbuc1 
    lda #5
    sta fload_bram.dbank
    jsr fload_bram
    // [363] phi from equinoxe_init::@2 to equinoxe_init::@3 [phi:equinoxe_init::@2->equinoxe_init::@3]
    // equinoxe_init::@3
    // fload_bram("veraheap.bin", BANK_VERA_HEAP, (bram_ptr_t)0xA000)
    // [364] call fload_bram
    // [562] phi from equinoxe_init::@3 to fload_bram [phi:equinoxe_init::@3->fload_bram]
    // [562] phi __errno#104 = __errno#103 [phi:equinoxe_init::@3->fload_bram#0] -- register_copy 
    // [562] phi fload_bram::filename#10 = equinoxe_init::filename3 [phi:equinoxe_init::@3->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename3
    sta.z fload_bram.filename
    lda #>filename3
    sta.z fload_bram.filename+1
    // [562] phi fload_bram::dbank#5 = 1 [phi:equinoxe_init::@3->fload_bram#2] -- vbum1=vbuc1 
    lda #1
    sta fload_bram.dbank
    jsr fload_bram
    // [365] phi from equinoxe_init::@3 to equinoxe_init::@4 [phi:equinoxe_init::@3->equinoxe_init::@4]
    // equinoxe_init::@4
    // flight_init()
    // [366] call flight_init
    // [581] phi from equinoxe_init::@4 to flight_init [phi:equinoxe_init::@4->flight_init]
    jsr flight_init
    // [367] phi from equinoxe_init::@4 to equinoxe_init::@5 [phi:equinoxe_init::@4->equinoxe_init::@5]
    // equinoxe_init::@5
    // fload_bram("players.bin", BANK_ENGINE_PLAYERS, (bram_ptr_t)0xA000)
    // [368] call fload_bram
    // [562] phi from equinoxe_init::@5 to fload_bram [phi:equinoxe_init::@5->fload_bram]
    // [562] phi __errno#104 = __errno#103 [phi:equinoxe_init::@5->fload_bram#0] -- register_copy 
    // [562] phi fload_bram::filename#10 = equinoxe_init::filename4 [phi:equinoxe_init::@5->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename4
    sta.z fload_bram.filename
    lda #>filename4
    sta.z fload_bram.filename+1
    // [562] phi fload_bram::dbank#5 = 9 [phi:equinoxe_init::@5->fload_bram#2] -- vbum1=vbuc1 
    lda #9
    sta fload_bram.dbank
    jsr fload_bram
    // [369] phi from equinoxe_init::@5 to equinoxe_init::@6 [phi:equinoxe_init::@5->equinoxe_init::@6]
    // equinoxe_init::@6
    // animate_init()
    // [370] callexecute animate_init  -- call_stack_near 
    jsr lib_animate.animate_init
    // memset(&stage, 0, sizeof(stage_t))
    // [371] call memset
    // [599] phi from equinoxe_init::@6 to memset [phi:equinoxe_init::@6->memset]
    jsr memset
    // [372] phi from equinoxe_init::@6 to equinoxe_init::@7 [phi:equinoxe_init::@6->equinoxe_init::@7]
    // equinoxe_init::@7
    // lru_cache_init()
    // [373] callexecute lru_cache_init  -- call_stack_near 
    // Initialize the cache in vram for the sprite animations.
    jsr lib_lru_cache.lru_cache_init
    // equinoxe_init::@return
    // }
    // [374] return 
    rts
  .segment Data
  .encoding "petscii_mixed"
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
.segment Code
  // kbhit
// Returns a value if a key is pressed.
// __mem() char kbhit()
kbhit: {
    // kbhit::cbm_k_clrchn1
    // asm
    // asm { jsrCBM_CLRCHN  }
    jsr CBM_CLRCHN
    // [377] phi from kbhit::cbm_k_clrchn1 to kbhit::@1 [phi:kbhit::cbm_k_clrchn1->kbhit::@1]
    // kbhit::@1
    // cbm_k_getin()
    // [378] call cbm_k_getin
    jsr cbm_k_getin
    // [379] cbm_k_getin::return#2 = cbm_k_getin::return#1
    // kbhit::@2
    // [380] kbhit::return#0 = cbm_k_getin::return#2
    // kbhit::@return
    // }
    // [381] return 
    rts
  .segment Data
    return: .byte 0
}
.segment CodeEngineStages
  // stage_reset
// void stage_reset()
// __bank(cx16_ram, 3) 
stage_reset: {
    .label stage_player = $4c
    .label stage_engine = $4e
    // palette_init(BANK_ENGINE_PALETTE)
    // [382] stackpush(char) = 6 -- _stackpushbyte_=vbuc1 
    lda #6
    pha
    // [383] callexecute palette_init  -- call_stack_near 
    jsr lib_palette.palette_init
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // [385] phi from stage_reset to stage_reset::@1 [phi:stage_reset->stage_reset::@1]
    // stage_reset::@1
    // memset(&stage, 0, sizeof(stage_t))
    // [386] call memset
    // [599] phi from stage_reset::@1 to memset [phi:stage_reset::@1->memset]
    jsr memset
    // stage_reset::@2
    // stage.script_b.playbook_total_b = 1
    // [387] *((char *)(struct $47 *)&stage+$15) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta stage+$15
    // stage.script_b.playbooks_b = stage_playbooks_b
    // [388] *((struct $46 **)(struct $47 *)&stage+$15+1) = stage_playbooks_b -- _deref_qssc1=pssc2 
    lda #<stage_playbooks_b
    sta stage+$15+1
    lda #>stage_playbooks_b
    sta stage+$15+1+1
    // &stage_playbooks_b[stage.playbook_current]
    // [389] stage_reset::$15 = *((unsigned int *)&stage+$1a) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+$1a
    asl
    sta stage_reset__15
    lda stage+$1a+1
    rol
    sta stage_reset__15+1
    asl stage_reset__15
    rol stage_reset__15+1
    // [390] stage_reset::$16 = stage_reset::$15 + *((unsigned int *)&stage+$1a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_reset__16
    adc stage+$1a
    sta stage_reset__16
    lda stage_reset__16+1
    adc stage+$1a+1
    sta stage_reset__16+1
    // [391] stage_reset::$8 = stage_reset::$16 << 1 -- vwum1=vwum1_rol_1 
    asl stage_reset__8
    rol stage_reset__8+1
    // [392] memcpy::source#0 = stage_playbooks_b + stage_reset::$8 -- pssz1=pssc1_plus_vwum2 
    lda stage_reset__8
    clc
    adc #<stage_playbooks_b
    sta.z memcpy.source
    lda stage_reset__8+1
    adc #>stage_playbooks_b
    sta.z memcpy.source+1
    // memcpy(&stage.current_playbook, &stage_playbooks_b[stage.playbook_current], sizeof(stage_playbook_t))
    // [393] call memcpy
    // stage.current_playbook = stage_playbook[stage.playbook];
    jsr memcpy
    // stage_reset::@3
    // stage.lives = 10
    // [394] *((char *)&stage+$34) = $a -- _deref_pbuc1=vbuc2 
    lda #$a
    sta stage+$34
    // stage.scenario_total = stage.current_playbook.scenario_total_b
    // [395] *((unsigned int *)&stage+$1e) = *((char *)(struct $46 *)&stage) -- _deref_pwuc1=_deref_pbuc2 
    lda stage
    sta stage+$1e
    lda #0
    sta stage+$1e+1
    // stage_load()
    // [396] call stage_load
    // bug?
    jsr stage_load
    // stage_reset::@4
    // stage_copy(stage.ew, stage.scenario_current)
    // [397] stage_copy::ew#0 = *((unsigned int *)&stage+$18) -- vbum1=_deref_pwuc1 
    lda stage+$18
    sta stage_copy.ew
    // [398] stage_copy::scenario#0 = *((unsigned int *)&stage+$1c) -- vwum1=_deref_pwuc1 
    lda stage+$1c
    sta stage_copy.scenario
    lda stage+$1c+1
    sta stage_copy.scenario+1
    // [399] call stage_copy
  // Load the artefacts of the stage.
    // [626] phi from stage_reset::@4 to stage_copy [phi:stage_reset::@4->stage_copy]
    // [626] phi stage_copy::ew#2 = stage_copy::ew#0 [phi:stage_reset::@4->stage_copy#0] -- register_copy 
    // [626] phi stage_copy::scenario#2 = stage_copy::scenario#0 [phi:stage_reset::@4->stage_copy#1] -- register_copy 
    jsr stage_copy
    // stage_reset::@5
    // stage_player_t* stage_player = stage_playbooks_b->stage_player
    // [400] stage_reset::stage_player#0 = *((struct $35 **)stage_playbooks_b+3) -- pssz1=_deref_qssc1 
    // Add the player to the stage.
    lda stage_playbooks_b+3
    sta.z stage_player
    lda stage_playbooks_b+3+1
    sta.z stage_player+1
    // stage_engine_t* stage_engine = stage_player->stage_engine
    // [401] stage_reset::stage_engine#0 = ((struct $33 **)stage_reset::stage_player#0)[1] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #1
    lda (stage_player),y
    sta.z stage_engine
    iny
    lda (stage_player),y
    sta.z stage_engine+1
    // player_add(stage_player->player_sprite, stage_engine->engine_sprite)
    // [402] player_add::sprite_player#0 = *((char *)stage_reset::stage_player#0) -- vbum1=_deref_pbuz2 
    ldy #0
    lda (stage_player),y
    sta player_add.sprite_player
    // [403] player_add::sprite_engine#0 = *((char *)stage_reset::stage_engine#0) -- vbum1=_deref_pbuz2 
    lda (stage_engine),y
    sta player_add.sprite_engine
    // [404] call player_add
    // [655] phi from stage_reset::@5 to player_add [phi:stage_reset::@5->player_add]
    // [655] phi player_add::sprite_engine#2 = player_add::sprite_engine#0 [phi:stage_reset::@5->player_add#0] -- register_copy 
    // [655] phi player_add::sprite_player#2 = player_add::sprite_player#0 [phi:stage_reset::@5->player_add#1] -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <player_add
    .byte >player_add
    .byte 9
    // stage_reset::@return
    // }
    // [405] return 
    rts
  .segment DataEngineStages
    .label stage_reset__8 = stage_reset__15
    stage_reset__15: .word 0
    .label stage_reset__16 = stage_reset__15
}
.segment CodeEngineStages
  // stage_logic
// void stage_logic()
// __bank(cx16_ram, 3) 
stage_logic: {
    .label stage_playbook_ptr1_stage_playbooks_b = $44
    .label stage_playbook_ptr1_return = $48
    .label stage_scenario_ptr1_stage_scenarios_b = $40
    .label stage_scenario_ptr1_return = $24
    .label stage_playbook_ptr2_stage_playbooks_b = $4c
    .label stage_playbook_ptr2_return = $26
    .label stage_player_ptr_b = $4e
    .label stage_engine_ptr_b = $4a
    // if(stage.playbook_current < stage.script_b.playbook_total_b)
    // [406] if(*((unsigned int *)&stage+$1a)>=*((char *)(struct $47 *)&stage+$15)) goto stage_logic::@1 -- _deref_pwuc1_ge__deref_pbuc2_then_la1 
    lda stage+$1a+1
    bne __b1
    lda stage+$1a
    cmp stage+$15
    bcs __b1
  !:
    // stage_logic::@2
    // game.tickstage & 0x03
    // [407] stage_logic::$3 = *((char *)&game+2) & 3 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #3
    and game+2
    sta stage_logic__3
    // if(!(game.tickstage & 0x03))
    // [408] if(0!=stage_logic::$3) goto stage_logic::@1 -- 0_neq_vbum1_then_la1 
    bne __b1
    // [409] phi from stage_logic::@2 to stage_logic::@4 [phi:stage_logic::@2->stage_logic::@4]
    // [409] phi stage_logic::w#10 = 0 [phi:stage_logic::@2->stage_logic::@4#0] -- vbum1=vbuc1 
    lda #0
    sta w
  // BREAKPOINT
    // stage_logic::@4
  __b4:
    // for(__mem unsigned char w=0; w<8; w++)
    // [410] if(stage_logic::w#10<8) goto stage_logic::@5 -- vbum1_lt_vbuc1_then_la1 
    lda w
    cmp #8
    bcs !__b5+
    jmp __b5
  !__b5:
    // [411] phi from stage_logic::@4 to stage_logic::@14 [phi:stage_logic::@4->stage_logic::@14]
    // [411] phi stage_logic::w1#2 = 0 [phi:stage_logic::@4->stage_logic::@14#0] -- vbum1=vbuc1 
    lda #0
    sta w1
    // stage_logic::@14
  __b14:
    // for(unsigned char w=0; w<8; w++)
    // [412] if(stage_logic::w1#2<8) goto stage_logic::@15 -- vbum1_lt_vbuc1_then_la1 
    lda w1
    cmp #8
    bcs !__b15+
    jmp __b15
  !__b15:
    // stage_logic::@16
    // if(stage.scenario_current >= stage.scenario_total)
    // [413] if(*((unsigned int *)&stage+$1c)<*((unsigned int *)&stage+$1e)) goto stage_logic::@1 -- _deref_pwuc1_lt__deref_pwuc2_then_la1 
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
    // [414] if(*((unsigned int *)&stage+$1a)>=*((char *)(struct $47 *)&stage+$15)) goto stage_logic::@1 -- _deref_pwuc1_ge__deref_pbuc2_then_la1 
    lda stage+$1a+1
    bne __b1
    lda stage+$1a
    cmp stage+$15
    bcs __b1
  !:
    // stage_logic::@24
    // stage.scenario_current = 0
    // [415] *((unsigned int *)&stage+$1c) = 0 -- _deref_pwuc1=vbuc2 
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
    // [416] if(0==*((char *)&stage+$35)) goto stage_logic::@return -- 0_eq__deref_pbuc1_then_la1 
    lda stage+$35
    beq __breturn
    // stage_logic::@3
    // stage.player_respawn--;
    // [417] *((char *)&stage+$35) = -- *((char *)&stage+$35) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec stage+$35
    // if(!stage.player_respawn)
    // [418] if(0!=*((char *)&stage+$35)) goto stage_logic::@return -- 0_neq__deref_pbuc1_then_la1 
    lda stage+$35
    bne __breturn
    // stage_logic::stage_playbook_ptr2
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [419] stage_logic::stage_playbook_ptr2_stage_playbooks_b#0 = *((struct $46 **)(struct $47 *)&stage+$15+1) -- pssz1=_deref_qssc1 
    lda stage+$15+1
    sta.z stage_playbook_ptr2_stage_playbooks_b
    lda stage+$15+1+1
    sta.z stage_playbook_ptr2_stage_playbooks_b+1
    // &stage_playbooks_b[stage.playbook_current]
    // [420] stage_logic::$56 = *((unsigned int *)&stage+$1a) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+$1a
    asl
    sta stage_logic__56
    lda stage+$1a+1
    rol
    sta stage_logic__56+1
    asl stage_logic__56
    rol stage_logic__56+1
    // [421] stage_logic::$57 = stage_logic::$56 + *((unsigned int *)&stage+$1a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_logic__57
    adc stage+$1a
    sta stage_logic__57
    lda stage_logic__57+1
    adc stage+$1a+1
    sta stage_logic__57+1
    // [422] stage_logic::stage_playbook_ptr2_$1 = stage_logic::$57 << 1 -- vwum1=vwum1_rol_1 
    asl stage_playbook_ptr2_stage_logic__1
    rol stage_playbook_ptr2_stage_logic__1+1
    // [423] stage_logic::stage_playbook_ptr2_return#0 = stage_logic::stage_playbook_ptr2_stage_playbooks_b#0 + stage_logic::stage_playbook_ptr2_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_playbook_ptr2_stage_logic__1
    clc
    adc.z stage_playbook_ptr2_stage_playbooks_b
    sta.z stage_playbook_ptr2_return
    lda stage_playbook_ptr2_stage_logic__1+1
    adc.z stage_playbook_ptr2_stage_playbooks_b+1
    sta.z stage_playbook_ptr2_return+1
    // stage_logic::@26
    // stage_player_t* stage_player_ptr_b = stage_playbook_ptr_b->stage_player
    // [424] stage_logic::stage_player_ptr_b#0 = ((struct $35 **)stage_logic::stage_playbook_ptr2_return#0)[3] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #3
    lda (stage_playbook_ptr2_return),y
    sta.z stage_player_ptr_b
    iny
    lda (stage_playbook_ptr2_return),y
    sta.z stage_player_ptr_b+1
    // stage_engine_t* stage_engine_ptr_b = stage_player_ptr_b->stage_engine
    // [425] stage_logic::stage_engine_ptr_b#0 = ((struct $33 **)stage_logic::stage_player_ptr_b#0)[1] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #1
    lda (stage_player_ptr_b),y
    sta.z stage_engine_ptr_b
    iny
    lda (stage_player_ptr_b),y
    sta.z stage_engine_ptr_b+1
    // player_add(stage_player_ptr_b->player_sprite, stage_engine_ptr_b->engine_sprite)
    // [426] player_add::sprite_player#1 = *((char *)stage_logic::stage_player_ptr_b#0) -- vbum1=_deref_pbuz2 
    ldy #0
    lda (stage_player_ptr_b),y
    sta player_add.sprite_player
    // [427] player_add::sprite_engine#1 = *((char *)stage_logic::stage_engine_ptr_b#0) -- vbum1=_deref_pbuz2 
    lda (stage_engine_ptr_b),y
    sta player_add.sprite_engine
    // [428] call player_add
    // [655] phi from stage_logic::@26 to player_add [phi:stage_logic::@26->player_add]
    // [655] phi player_add::sprite_engine#2 = player_add::sprite_engine#1 [phi:stage_logic::@26->player_add#0] -- register_copy 
    // [655] phi player_add::sprite_player#2 = player_add::sprite_player#1 [phi:stage_logic::@26->player_add#1] -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <player_add
    .byte >player_add
    .byte 9
    // stage_logic::@return
  __breturn:
    // }
    // [429] return 
    rts
    // stage_logic::@15
  __b15:
    // if(wave.finished[w])
    // [430] if(0==((char *)&wave+$80)[stage_logic::w1#2]) goto stage_logic::@17 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy w1
    lda wave+$80,y
    cmp #0
    beq __b17
    // stage_logic::@22
    // __mem stage_scenario_index_t new_scenario = wave.scenario[w]
    // [431] stage_logic::$33 = stage_logic::w1#2 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta stage_logic__33
    // [432] stage_logic::new_scenario#0 = ((unsigned int *)&wave+$88)[stage_logic::$33] -- vwum1=pwuc1_derefidx_vbum2 
    // If there are more scenarios, create new waves based on the scenarios dependent on the finished wave.
    tay
    lda wave+$88,y
    sta new_scenario
    lda wave+$88+1,y
    sta new_scenario+1
    // __mem unsigned int wave_scenario = wave.scenario[w]
    // [433] stage_logic::wave_scenario#0 = ((unsigned int *)&wave+$88)[stage_logic::$33] -- vwum1=pwuc1_derefidx_vbum2 
    lda wave+$88,y
    sta wave_scenario
    lda wave+$88+1,y
    sta wave_scenario+1
    // [434] phi from stage_logic::@20 stage_logic::@22 to stage_logic::@18 [phi:stage_logic::@20/stage_logic::@22->stage_logic::@18]
  __b2:
    // [434] phi stage_logic::new_scenario#10 = stage_logic::new_scenario#1 [phi:stage_logic::@20/stage_logic::@22->stage_logic::@18#0] -- register_copy 
  // TODO find solution for this loop, maybe with pointers?
    // stage_logic::@18
    // while(new_scenario < stage.scenario_total)
    // [435] if(stage_logic::new_scenario#10<*((unsigned int *)&stage+$1e)) goto stage_logic::stage_playbook_ptr1 -- vwum1_lt__deref_pwuc1_then_la1 
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
    // [436] ((char *)&wave+$80)[stage_logic::w1#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy w1
    sta wave+$80,y
    // stage_logic::@17
  __b17:
    // for(unsigned char w=0; w<8; w++)
    // [437] stage_logic::w1#1 = ++ stage_logic::w1#2 -- vbum1=_inc_vbum1 
    inc w1
    // [411] phi from stage_logic::@17 to stage_logic::@14 [phi:stage_logic::@17->stage_logic::@14]
    // [411] phi stage_logic::w1#2 = stage_logic::w1#1 [phi:stage_logic::@17->stage_logic::@14#0] -- register_copy 
    jmp __b14
    // stage_logic::stage_playbook_ptr1
  stage_playbook_ptr1:
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [438] stage_logic::stage_playbook_ptr1_stage_playbooks_b#0 = *((struct $46 **)(struct $47 *)&stage+$15+1) -- pssz1=_deref_qssc1 
    lda stage+$15+1
    sta.z stage_playbook_ptr1_stage_playbooks_b
    lda stage+$15+1+1
    sta.z stage_playbook_ptr1_stage_playbooks_b+1
    // &stage_playbooks_b[stage.playbook_current]
    // [439] stage_logic::$53 = *((unsigned int *)&stage+$1a) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+$1a
    asl
    sta stage_logic__53
    lda stage+$1a+1
    rol
    sta stage_logic__53+1
    asl stage_logic__53
    rol stage_logic__53+1
    // [440] stage_logic::$54 = stage_logic::$53 + *((unsigned int *)&stage+$1a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_logic__54
    adc stage+$1a
    sta stage_logic__54
    lda stage_logic__54+1
    adc stage+$1a+1
    sta stage_logic__54+1
    // [441] stage_logic::stage_playbook_ptr1_$1 = stage_logic::$54 << 1 -- vwum1=vwum1_rol_1 
    asl stage_playbook_ptr1_stage_logic__1
    rol stage_playbook_ptr1_stage_logic__1+1
    // [442] stage_logic::stage_playbook_ptr1_return#0 = stage_logic::stage_playbook_ptr1_stage_playbooks_b#0 + stage_logic::stage_playbook_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_playbook_ptr1_stage_logic__1
    clc
    adc.z stage_playbook_ptr1_stage_playbooks_b
    sta.z stage_playbook_ptr1_return
    lda stage_playbook_ptr1_stage_logic__1+1
    adc.z stage_playbook_ptr1_stage_playbooks_b+1
    sta.z stage_playbook_ptr1_return+1
    // stage_logic::stage_scenario_ptr1
    // stage_scenario_t* stage_scenarios_b = stage_playbook_ptr_b->scenarios_b
    // [443] stage_logic::stage_scenario_ptr1_stage_scenarios_b#0 = ((struct $42 **)stage_logic::stage_playbook_ptr1_return#0)[1] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #1
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b
    iny
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b+1
    // &stage_scenarios_b[scenario]
    // [444] stage_logic::stage_scenario_ptr1_$1 = stage_logic::new_scenario#10 << 4 -- vwum1=vwum2_rol_4 
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
    // [445] stage_logic::stage_scenario_ptr1_return#0 = stage_logic::stage_scenario_ptr1_stage_scenarios_b#0 + stage_logic::stage_scenario_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_scenario_ptr1_stage_logic__1
    clc
    adc.z stage_scenario_ptr1_stage_scenarios_b
    sta.z stage_scenario_ptr1_return
    lda stage_scenario_ptr1_stage_logic__1+1
    adc.z stage_scenario_ptr1_stage_scenarios_b+1
    sta.z stage_scenario_ptr1_return+1
    // stage_logic::@25
    // unsigned int prev = stage_scenario_ptr_b->prev
    // [446] stage_logic::prev#0 = (unsigned int)((char *)stage_logic::stage_scenario_ptr1_return#0)[$e] -- vwum1=_word_pbuz2_derefidx_vbuc1 
    ldy #$e
    lda (stage_scenario_ptr1_return),y
    sta prev
    lda #0
    sta prev+1
    // if(prev == wave_scenario)
    // [447] if(stage_logic::prev#0!=stage_logic::wave_scenario#0) goto stage_logic::@20 -- vwum1_neq_vwum2_then_la1 
    cmp wave_scenario+1
    bne __b20
    lda prev
    cmp wave_scenario
    bne __b20
    // stage_logic::@21
    // stage.ew+1
    // [448] stage_logic::$20 = *((unsigned int *)&stage+$18) + 1 -- vwum1=_deref_pwuc1_plus_1 
    clc
    lda stage+$18
    adc #1
    sta stage_logic__20
    lda stage+$18+1
    adc #0
    sta stage_logic__20+1
    // (stage.ew+1) & 0x07
    // [449] stage_logic::$21 = stage_logic::$20 & 7 -- vbum1=vwum2_band_vbuc1 
    lda #7
    and stage_logic__20
    sta stage_logic__21
    // stage.ew = (stage.ew+1) & 0x07
    // [450] *((unsigned int *)&stage+$18) = stage_logic::$21 -- _deref_pwuc1=vbum1 
    // We create new waves from the scenarios that are dependent on the finished one.
    // There must always be at least one that equals scenario of the previous scenario.
    sta stage+$18
    lda #0
    sta stage+$18+1
    // stage_copy(stage.ew, new_scenario)
    // [451] stage_copy::ew#1 = *((unsigned int *)&stage+$18) -- vbum1=_deref_pwuc1 
    lda stage+$18
    sta stage_copy.ew
    // [452] stage_copy::scenario#1 = stage_logic::new_scenario#10 -- vwum1=vwum2 
    lda new_scenario
    sta stage_copy.scenario
    lda new_scenario+1
    sta stage_copy.scenario+1
    // [453] call stage_copy
    // [626] phi from stage_logic::@21 to stage_copy [phi:stage_logic::@21->stage_copy]
    // [626] phi stage_copy::ew#2 = stage_copy::ew#1 [phi:stage_logic::@21->stage_copy#0] -- register_copy 
    // [626] phi stage_copy::scenario#2 = stage_copy::scenario#1 [phi:stage_logic::@21->stage_copy#1] -- register_copy 
    jsr stage_copy
    // stage_logic::@20
  __b20:
    // new_scenario++;
    // [454] stage_logic::new_scenario#1 = ++ stage_logic::new_scenario#10 -- vwum1=_inc_vwum1 
    inc new_scenario
    bne !+
    inc new_scenario+1
  !:
    jmp __b2
    // stage_logic::@5
  __b5:
    // if(wave.used[w])
    // [455] if(0==((char *)&wave+$78)[stage_logic::w#10]) goto stage_logic::@6 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy w
    lda wave+$78,y
    cmp #0
    beq __b6
    // stage_logic::@12
    // if(!wave.wait[w])
    // [456] if(0==((char *)&wave+$68)[stage_logic::w#10]) goto stage_logic::@7 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda wave+$68,y
    cmp #0
    beq __b7
    // stage_logic::@13
    // wave.wait[w]--;
    // [457] ((char *)&wave+$68)[stage_logic::w#10] = -- ((char *)&wave+$68)[stage_logic::w#10] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx w
    dec wave+$68,x
    // stage_logic::@6
  __b6:
    // for(__mem unsigned char w=0; w<8; w++)
    // [458] stage_logic::w#1 = ++ stage_logic::w#10 -- vbum1=_inc_vbum1 
    inc w
    // [409] phi from stage_logic::@6 to stage_logic::@4 [phi:stage_logic::@6->stage_logic::@4]
    // [409] phi stage_logic::w#10 = stage_logic::w#1 [phi:stage_logic::@6->stage_logic::@4#0] -- register_copy 
    jmp __b4
    // stage_logic::@7
  __b7:
    // if(wave.enemy_count[w])
    // [459] if(0!=((char *)&wave)[stage_logic::w#10]) goto stage_logic::@8 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy w
    lda wave,y
    cmp #0
    bne __b8
    // stage_logic::@10
    // if(!wave.enemy_alive[w])
    // [460] if(0!=((char *)&wave+$28)[stage_logic::w#10]) goto stage_logic::@6 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda wave+$28,y
    cmp #0
    bne __b6
    // stage_logic::@11
    // wave.used[w] = 0
    // [461] ((char *)&wave+$78)[stage_logic::w#10] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta wave+$78,y
    // wave.finished[w] = 1
    // [462] ((char *)&wave+$80)[stage_logic::w#10] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    sta wave+$80,y
    jmp __b6
    // stage_logic::@8
  __b8:
    // if(wave.enemy_spawn[w])
    // [463] if(0==((char *)&wave+8)[stage_logic::w#10]) goto stage_logic::@6 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy w
    lda wave+8,y
    cmp #0
    beq __b6
    // [464] phi from stage_logic::@8 to stage_logic::@9 [phi:stage_logic::@8->stage_logic::@9]
    // stage_logic::@9
    jmp __b6
  .segment DataEngineStages
    stage_logic__3: .byte 0
    stage_logic__20: .word 0
    stage_logic__21: .byte 0
    stage_logic__33: .byte 0
    .label stage_playbook_ptr1_stage_logic__1 = stage_logic__53
    stage_scenario_ptr1_stage_logic__1: .word 0
    .label stage_playbook_ptr2_stage_logic__1 = stage_logic__56
    w: .byte 0
    w1: .byte 0
    new_scenario: .word 0
    wave_scenario: .word 0
    prev: .word 0
    stage_logic__53: .word 0
    .label stage_logic__54 = stage_logic__53
    stage_logic__56: .word 0
    .label stage_logic__57 = stage_logic__56
}
.segment Code
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
    // [466] return 
    rts
  .segment Data
    visible: .byte 0
    scalex: .byte 0
    scaley: .byte 0
}
.segment Code
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
    // [467] cx16_mouse_get::status = 0 -- vbum1=vbuc1 
    lda #0
    sta status
    // __address(0xfc) int x
    // [468] cx16_mouse_get::x = 0 -- vwsz1=vwsc1 
    sta.z x
    sta.z x+1
    // __address(0xfe) int y
    // [469] cx16_mouse_get::y = 0 -- vwsz1=vwsc1 
    sta.z y
    sta.z y+1
    // cx16_mouse.px = cx16_mouse.x
    // [470] *((int *)&cx16_mouse+4) = *((int *)&cx16_mouse) -- _deref_pwsc1=_deref_pwsc2 
    lda cx16_mouse
    sta cx16_mouse+4
    lda cx16_mouse+1
    sta cx16_mouse+4+1
    // cx16_mouse.py = cx16_mouse.y
    // [471] *((int *)&cx16_mouse+6) = *((int *)&cx16_mouse+2) -- _deref_pwsc1=_deref_pwsc2 
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
    // [473] *((int *)&cx16_mouse) = cx16_mouse_get::x -- _deref_pwsc1=vwsz1 
    lda.z x
    sta cx16_mouse
    lda.z x+1
    sta cx16_mouse+1
    // cx16_mouse.y = y
    // [474] *((int *)&cx16_mouse+2) = cx16_mouse_get::y -- _deref_pwsc1=vwsz1 
    lda.z y
    sta cx16_mouse+2
    lda.z y+1
    sta cx16_mouse+2+1
    // cx16_mouse.status = status
    // [475] *((char *)&cx16_mouse+8) = cx16_mouse_get::status -- _deref_pbuc1=vbum1 
    lda status
    sta cx16_mouse+8
    // cx16_mouse_get::@return
    // }
    // [476] return 
    rts
  .segment Data
    status: .byte 0
}
.segment Code
  // irq_vsync
//VSYNC Interrupt Routine
// void irq_vsync()
irq_vsync: {
    .const bank_set_brom1_bank = 0
    .const bank_push_set_bram1_bank = $ff
    // irq_vsync::bank_set_brom1
    // BROM = bank
    // [478] BROM = irq_vsync::bank_set_brom1_bank#0 -- vbuz1=vbuc1 
    lda #bank_set_brom1_bank
    sta.z BROM
    // irq_vsync::vera_display_set_border_color1
    // *VERA_CTRL &= 0b10000001
    // [479] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [480] *VERA_DC_BORDER = YELLOW -- _deref_pbuc1=vbuc2 
    lda #YELLOW
    sta VERA_DC_BORDER
    // irq_vsync::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [482] BRAM = irq_vsync::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // irq_vsync::vera_display_set_border_color2
    // *VERA_CTRL &= 0b10000001
    // [483] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [484] *VERA_DC_BORDER = BLUE -- _deref_pbuc1=vbuc2 
    lda #BLUE
    sta VERA_DC_BORDER
    // [485] phi from irq_vsync::vera_display_set_border_color2 to irq_vsync::@1 [phi:irq_vsync::vera_display_set_border_color2->irq_vsync::@1]
    // irq_vsync::@1
    // collision_init()
    // [486] call collision_init
    // [699] phi from irq_vsync::@1 to collision_init [phi:irq_vsync::@1->collision_init]
    jsr collision_init
    // [487] phi from irq_vsync::@1 to irq_vsync::@4 [phi:irq_vsync::@1->irq_vsync::@4]
    // irq_vsync::@4
    // cx16_mouse_get()
    // [488] call cx16_mouse_get
    // cx16_mouse_scan(); 
    jsr cx16_mouse_get
    // irq_vsync::vera_display_set_border_color3
    // *VERA_CTRL &= 0b10000001
    // [489] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [490] *VERA_DC_BORDER = LIGHT_BLUE -- _deref_pbuc1=vbuc2 
    lda #LIGHT_BLUE
    sta VERA_DC_BORDER
    // [491] phi from irq_vsync::vera_display_set_border_color3 to irq_vsync::@2 [phi:irq_vsync::vera_display_set_border_color3->irq_vsync::@2]
    // irq_vsync::@2
    // player_logic()
    // [492] call player_logic
    // [707] phi from irq_vsync::@2 to player_logic [phi:irq_vsync::@2->player_logic] -- call_phi_close_cx16_ram 
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
    // [493] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [494] *VERA_DC_BORDER = GREY -- _deref_pbuc1=vbuc2 
    lda #GREY
    sta VERA_DC_BORDER
    // [495] phi from irq_vsync::vera_display_set_border_color4 to irq_vsync::@3 [phi:irq_vsync::vera_display_set_border_color4->irq_vsync::@3]
    // irq_vsync::@3
    // flight_draw()
    // [496] call flight_draw
    // [748] phi from irq_vsync::@3 to flight_draw [phi:irq_vsync::@3->flight_draw]
    jsr flight_draw
    // irq_vsync::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // irq_vsync::vera_display_set_border_color5
    // *VERA_CTRL &= 0b10000001
    // [498] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [499] *VERA_DC_BORDER = BLACK -- _deref_pbuc1=vbuc2 
    lda #BLACK
    sta VERA_DC_BORDER
    // irq_vsync::@return
    // }
    // [500] return 
    rts
}
  // screenlayer
// --- layer management in VERA ---
// void screenlayer(char layer, __mem() char mapbase, __mem() char config)
screenlayer: {
    .label y = $3e
    // __mem char vera_dc_hscale_temp = *VERA_DC_HSCALE
    // [501] screenlayer::vera_dc_hscale_temp#0 = *VERA_DC_HSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_HSCALE
    sta vera_dc_hscale_temp
    // __mem char vera_dc_vscale_temp = *VERA_DC_VSCALE
    // [502] screenlayer::vera_dc_vscale_temp#0 = *VERA_DC_VSCALE -- vbum1=_deref_pbuc1 
    lda VERA_DC_VSCALE
    sta vera_dc_vscale_temp
    // __conio.layer = 0
    // [503] *((char *)&__conio+2) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+2
    // mapbase >> 7
    // [504] screenlayer::$0 = screenlayer::mapbase#0 >> 7 -- vbum1=vbum2_ror_7 
    lda mapbase
    rol
    rol
    and #1
    sta screenlayer__0
    // __conio.mapbase_bank = mapbase >> 7
    // [505] *((char *)&__conio+5) = screenlayer::$0 -- _deref_pbuc1=vbum1 
    sta __conio+5
    // (mapbase)<<1
    // [506] screenlayer::$1 = screenlayer::mapbase#0 << 1 -- vbum1=vbum1_rol_1 
    asl screenlayer__1
    // MAKEWORD((mapbase)<<1,0)
    // [507] screenlayer::$2 = screenlayer::$1 w= 0 -- vwum1=vbum2_word_vbuc1 
    lda #0
    ldy screenlayer__1
    sty screenlayer__2+1
    sta screenlayer__2
    // __conio.mapbase_offset = MAKEWORD((mapbase)<<1,0)
    // [508] *((unsigned int *)&__conio+3) = screenlayer::$2 -- _deref_pwuc1=vwum1 
    sta __conio+3
    tya
    sta __conio+3+1
    // config & VERA_LAYER_WIDTH_MASK
    // [509] screenlayer::$7 = screenlayer::config#0 & VERA_LAYER_WIDTH_MASK -- vbum1=vbum2_band_vbuc1 
    lda #VERA_LAYER_WIDTH_MASK
    and config
    sta screenlayer__7
    // (config & VERA_LAYER_WIDTH_MASK) >> 4
    // [510] screenlayer::$8 = screenlayer::$7 >> 4 -- vbum1=vbum1_ror_4 
    lda screenlayer__8
    lsr
    lsr
    lsr
    lsr
    sta screenlayer__8
    // __conio.mapwidth = VERA_LAYER_DIM[ (config & VERA_LAYER_WIDTH_MASK) >> 4]
    // [511] *((char *)&__conio+8) = screenlayer::VERA_LAYER_DIM[screenlayer::$8] -- _deref_pbuc1=pbuc2_derefidx_vbum1 
    tay
    lda VERA_LAYER_DIM,y
    sta __conio+8
    // config & VERA_LAYER_HEIGHT_MASK
    // [512] screenlayer::$5 = screenlayer::config#0 & VERA_LAYER_HEIGHT_MASK -- vbum1=vbum1_band_vbuc1 
    lda #VERA_LAYER_HEIGHT_MASK
    and screenlayer__5
    sta screenlayer__5
    // (config & VERA_LAYER_HEIGHT_MASK) >> 6
    // [513] screenlayer::$6 = screenlayer::$5 >> 6 -- vbum1=vbum1_ror_6 
    lda screenlayer__6
    rol
    rol
    rol
    and #3
    sta screenlayer__6
    // __conio.mapheight = VERA_LAYER_DIM[ (config & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [514] *((char *)&__conio+9) = screenlayer::VERA_LAYER_DIM[screenlayer::$6] -- _deref_pbuc1=pbuc2_derefidx_vbum1 
    tay
    lda VERA_LAYER_DIM,y
    sta __conio+9
    // __conio.rowskip = VERA_LAYER_SKIP[(config & VERA_LAYER_WIDTH_MASK)>>4]
    // [515] screenlayer::$16 = screenlayer::$8 << 1 -- vbum1=vbum1_rol_1 
    asl screenlayer__16
    // [516] *((unsigned int *)&__conio+$a) = screenlayer::VERA_LAYER_SKIP[screenlayer::$16] -- _deref_pwuc1=pwuc2_derefidx_vbum1 
    // __conio.rowshift = ((config & VERA_LAYER_WIDTH_MASK)>>4)+6;
    ldy screenlayer__16
    lda VERA_LAYER_SKIP,y
    sta __conio+$a
    lda VERA_LAYER_SKIP+1,y
    sta __conio+$a+1
    // vera_dc_hscale_temp == 0x80
    // [517] screenlayer::$9 = screenlayer::vera_dc_hscale_temp#0 == $80 -- vbom1=vbum1_eq_vbuc1 
    lda screenlayer__9
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    sta screenlayer__9
    // 40 << (char)(vera_dc_hscale_temp == 0x80)
    // [518] screenlayer::$18 = (char)screenlayer::$9
    // [519] screenlayer::$10 = $28 << screenlayer::$18 -- vbum1=vbuc1_rol_vbum1 
    lda #$28
    ldy screenlayer__10
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta screenlayer__10
    // (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [520] screenlayer::$11 = screenlayer::$10 - 1 -- vbum1=vbum1_minus_1 
    dec screenlayer__11
    // __conio.width = (40 << (char)(vera_dc_hscale_temp == 0x80))-1
    // [521] *((char *)&__conio+6) = screenlayer::$11 -- _deref_pbuc1=vbum1 
    lda screenlayer__11
    sta __conio+6
    // vera_dc_vscale_temp == 0x80
    // [522] screenlayer::$12 = screenlayer::vera_dc_vscale_temp#0 == $80 -- vbom1=vbum1_eq_vbuc1 
    lda screenlayer__12
    eor #$80
    beq !+
    lda #1
  !:
    eor #1
    sta screenlayer__12
    // 30 << (char)(vera_dc_vscale_temp == 0x80)
    // [523] screenlayer::$19 = (char)screenlayer::$12
    // [524] screenlayer::$13 = $1e << screenlayer::$19 -- vbum1=vbuc1_rol_vbum1 
    lda #$1e
    ldy screenlayer__13
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta screenlayer__13
    // (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [525] screenlayer::$14 = screenlayer::$13 - 1 -- vbum1=vbum1_minus_1 
    dec screenlayer__14
    // __conio.height = (30 << (char)(vera_dc_vscale_temp == 0x80))-1
    // [526] *((char *)&__conio+7) = screenlayer::$14 -- _deref_pbuc1=vbum1 
    lda screenlayer__14
    sta __conio+7
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [527] screenlayer::mapbase_offset#0 = *((unsigned int *)&__conio+3) -- vwum1=_deref_pwuc1 
    lda __conio+3
    sta mapbase_offset
    lda __conio+3+1
    sta mapbase_offset+1
    // [528] phi from screenlayer to screenlayer::@1 [phi:screenlayer->screenlayer::@1]
    // [528] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#0 [phi:screenlayer->screenlayer::@1#0] -- register_copy 
    // [528] phi screenlayer::y#2 = 0 [phi:screenlayer->screenlayer::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z y
    // screenlayer::@1
  __b1:
    // for(register char y=0; y<=__conio.height; y++)
    // [529] if(screenlayer::y#2<=*((char *)&__conio+7)) goto screenlayer::@2 -- vbuz1_le__deref_pbuc1_then_la1 
    lda __conio+7
    cmp.z y
    bcs __b2
    // screenlayer::@return
    // }
    // [530] return 
    rts
    // screenlayer::@2
  __b2:
    // __conio.offsets[y] = mapbase_offset
    // [531] screenlayer::$17 = screenlayer::y#2 << 1 -- vbum1=vbuz2_rol_1 
    lda.z y
    asl
    sta screenlayer__17
    // [532] ((unsigned int *)&__conio+$15)[screenlayer::$17] = screenlayer::mapbase_offset#2 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda mapbase_offset
    sta __conio+$15,y
    lda mapbase_offset+1
    sta __conio+$15+1,y
    // mapbase_offset += __conio.rowskip
    // [533] screenlayer::mapbase_offset#1 = screenlayer::mapbase_offset#2 + *((unsigned int *)&__conio+$a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda mapbase_offset
    adc __conio+$a
    sta mapbase_offset
    lda mapbase_offset+1
    adc __conio+$a+1
    sta mapbase_offset+1
    // for(register char y=0; y<=__conio.height; y++)
    // [534] screenlayer::y#1 = ++ screenlayer::y#2 -- vbuz1=_inc_vbuz1 
    inc.z y
    // [528] phi from screenlayer::@2 to screenlayer::@1 [phi:screenlayer::@2->screenlayer::@1]
    // [528] phi screenlayer::mapbase_offset#2 = screenlayer::mapbase_offset#1 [phi:screenlayer::@2->screenlayer::@1#0] -- register_copy 
    // [528] phi screenlayer::y#2 = screenlayer::y#1 [phi:screenlayer::@2->screenlayer::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    VERA_LAYER_DIM: .byte $1f, $3f, $7f, $ff
    VERA_LAYER_SKIP: .word $40, $80, $100, $200
    screenlayer__0: .byte 0
    .label screenlayer__1 = mapbase
    screenlayer__2: .word 0
    .label screenlayer__5 = config
    .label screenlayer__6 = config
    screenlayer__7: .byte 0
    .label screenlayer__8 = screenlayer__7
    .label screenlayer__9 = vera_dc_hscale_temp
    .label screenlayer__10 = vera_dc_hscale_temp
    .label screenlayer__11 = vera_dc_hscale_temp
    .label screenlayer__12 = vera_dc_vscale_temp
    .label screenlayer__13 = vera_dc_vscale_temp
    .label screenlayer__14 = vera_dc_vscale_temp
    .label screenlayer__16 = screenlayer__7
    screenlayer__17: .byte 0
    .label screenlayer__18 = vera_dc_hscale_temp
    .label screenlayer__19 = vera_dc_vscale_temp
    mapbase: .byte 0
    config: .byte 0
    vera_dc_hscale_temp: .byte 0
    vera_dc_vscale_temp: .byte 0
    mapbase_offset: .word 0
}
.segment Code
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
// void cscroll()
cscroll: {
    // if(__conio.cursor_y>__conio.height)
    // [535] if(*((char *)&__conio+1)<=*((char *)&__conio+7)) goto cscroll::@return -- _deref_pbuc1_le__deref_pbuc2_then_la1 
    lda __conio+7
    cmp __conio+1
    bcs __breturn
    // cscroll::@1
    // if(__conio.scroll[__conio.layer])
    // [536] if(0!=((char *)&__conio+$f)[*((char *)&__conio+2)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio+2
    lda __conio+$f,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(__conio.cursor_y>__conio.height)
    // [537] if(*((char *)&__conio+1)<=*((char *)&__conio+7)) goto cscroll::@return -- _deref_pbuc1_le__deref_pbuc2_then_la1 
    lda __conio+7
    cmp __conio+1
    bcs __breturn
    // [538] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
    // gotoxy(0,0)
    // [539] call gotoxy
    // [288] phi from cscroll::@3 to gotoxy [phi:cscroll::@3->gotoxy]
    // [288] phi gotoxy::y#10 = 0 [phi:cscroll::@3->gotoxy#0] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.y
    // [288] phi gotoxy::x#6 = 0 [phi:cscroll::@3->gotoxy#1] -- vbum1=vbuc1 
    sta gotoxy.x
    jsr gotoxy
    // cscroll::@return
  __breturn:
    // }
    // [540] return 
    rts
    // [541] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup(1)
    // [542] call insertup
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, __conio.height)
    // [543] gotoxy::y#1 = *((char *)&__conio+7) -- vbum1=_deref_pbuc1 
    lda __conio+7
    sta gotoxy.y
    // [544] call gotoxy
    // [288] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [288] phi gotoxy::y#10 = gotoxy::y#1 [phi:cscroll::@5->gotoxy#0] -- register_copy 
    // [288] phi gotoxy::x#6 = 0 [phi:cscroll::@5->gotoxy#1] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.x
    jsr gotoxy
    // [545] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [546] call clearline
    jsr clearline
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
    // [548] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_COLOR_DEPTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_COLOR_DEPTH_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= bpp
    // [549] *VERA_L1_CONFIG = *VERA_L1_CONFIG -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_width1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_WIDTH_MASK
    // [550] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= mapwidth
    // [551] *VERA_L1_CONFIG = *VERA_L1_CONFIG | VERA_LAYER_WIDTH_128 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_WIDTH_128
    ora VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_height1
    // *VERA_L1_CONFIG &= ~VERA_LAYER_HEIGHT_MASK
    // [552] *VERA_L1_CONFIG = *VERA_L1_CONFIG & ~VERA_LAYER_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK^$ff
    and VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // *VERA_L1_CONFIG |= mapheight
    // [553] *VERA_L1_CONFIG = *VERA_L1_CONFIG | VERA_LAYER_HEIGHT_64 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_LAYER_HEIGHT_64
    ora VERA_L1_CONFIG
    sta VERA_L1_CONFIG
    // vera_layer1_mode_tile::vera_layer1_set_mapbase1
    // *VERA_L1_MAPBASE = (mapbase_bank<<7) | (BYTE1(mapbase_offset)>>1)
    // [554] *VERA_L1_MAPBASE = vera_layer1_mode_tile::mapbase_bank#0<<7|byte1 vera_layer1_mode_tile::mapbase_offset#0>>1 -- _deref_pbuc1=vbuc2 
    lda #mapbase_bank<<7|(>mapbase_offset)>>1
    sta VERA_L1_MAPBASE
    // vera_layer1_mode_tile::vera_layer1_set_tilebase1
    // *VERA_L1_TILEBASE &= ~VERA_LAYER_TILEBASE_MASK
    // [555] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_LAYER_TILEBASE_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_TILEBASE_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= ((tilebase_bank << 7) | BYTE1(tilebase_offset)>>1)
    // [556] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE | vera_layer1_mode_tile::tilebase_bank#0<<7|byte1 vera_layer1_mode_tile::tilebase_offset#0>>1 -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #tilebase_bank<<7|(>tilebase_offset)>>1
    ora VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::vera_layer1_set_tile_width1
    // *VERA_L1_TILEBASE &= ~VERA_TILEBASE_WIDTH_MASK
    // [557] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_TILEBASE_WIDTH_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_WIDTH_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= tilewidth
    // [558] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::vera_layer1_set_tile_height1
    // *VERA_L1_TILEBASE &= ~VERA_TILEBASE_HEIGHT_MASK
    // [559] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE & ~VERA_TILEBASE_HEIGHT_MASK -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_TILEBASE_HEIGHT_MASK^$ff
    and VERA_L1_TILEBASE
    sta VERA_L1_TILEBASE
    // *VERA_L1_TILEBASE |= tileheight
    // [560] *VERA_L1_TILEBASE = *VERA_L1_TILEBASE -- _deref_pbuc1=_deref_pbuc1 
    sta VERA_L1_TILEBASE
    // vera_layer1_mode_tile::@return
    // }
    // [561] return 
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
// unsigned int fload_bram(__zp($26) char *filename, __mem() char dbank, char *dptr)
fload_bram: {
    .label fp = $2d
    .label filename = $26
    // fload_bram::bank_get_bram1
    // return BRAM;
    // [563] fload_bram::bank_set_bram2_bank#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_set_bram2_bank
    // fload_bram::bank_set_bram1
    // BRAM = bank
    // [564] BRAM = fload_bram::dbank#5 -- vbuz1=vbum2 
    lda dbank
    sta.z BRAM
    // fload_bram::@4
    // FILE* fp = fopen(filename,"r")
    // [565] fopen::path#2 = fload_bram::filename#10
    // [566] call fopen
    // [836] phi from fload_bram::@4 to fopen [phi:fload_bram::@4->fopen]
    // [836] phi __errno#209 = __errno#104 [phi:fload_bram::@4->fopen#0] -- register_copy 
    // [836] phi fopen::pathtoken#0 = fopen::path#2 [phi:fload_bram::@4->fopen#1] -- register_copy 
    jsr fopen
    // FILE* fp = fopen(filename,"r")
    // [567] fopen::return#3 = fopen::return#2
    // fload_bram::@5
    // [568] fload_bram::fp#0 = fopen::return#3
    // if(fp)
    // [569] if((struct $2 *)0==fload_bram::fp#0) goto fload_bram::bank_set_bram2 -- pssc1_eq_pssz1_then_la1 
    lda.z fp
    cmp #<0
    bne !+
    lda.z fp+1
    cmp #>0
    beq bank_set_bram2
  !:
    // fload_bram::@1
    // fgets(dptr, 0, fp)
    // [570] fgets::stream#0 = fload_bram::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fgets.stream
    lda.z fp+1
    sta.z fgets.stream+1
    // [571] call fgets
    // [917] phi from fload_bram::@1 to fgets [phi:fload_bram::@1->fgets]
    // [917] phi fgets::ptr#14 = (char *) 40960 [phi:fload_bram::@1->fgets#0] -- pbuz1=pbuc1 
    lda #<$a000
    sta.z fgets.ptr
    lda #>$a000
    sta.z fgets.ptr+1
    // [917] phi fgets::size#10 = 0 [phi:fload_bram::@1->fgets#1] -- vwum1=vbuc1 
    lda #<0
    sta fgets.size
    sta fgets.size+1
    // [917] phi fgets::stream#4 = fgets::stream#0 [phi:fload_bram::@1->fgets#2] -- register_copy 
    jsr fgets
    // fgets(dptr, 0, fp)
    // [572] fgets::return#10 = fgets::return#1
    // fload_bram::@6
    // read = fgets(dptr, 0, fp)
    // [573] fload_bram::read#1 = fgets::return#10
    // if(read)
    // [574] if(0!=fload_bram::read#1) goto fload_bram::@3 -- 0_neq_vwum1_then_la1 
    lda read
    ora read+1
    bne __b3
    // fload_bram::@2
    // fclose(fp)
    // [575] fclose::stream#1 = fload_bram::fp#0
    // [576] call fclose
    // [971] phi from fload_bram::@2 to fclose [phi:fload_bram::@2->fclose]
    // [971] phi fclose::stream#3 = fclose::stream#1 [phi:fload_bram::@2->fclose#0] -- register_copy 
    jsr fclose
    // fload_bram::bank_set_bram2
  bank_set_bram2:
    // BRAM = bank
    // [577] BRAM = fload_bram::bank_set_bram2_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram2_bank
    sta.z BRAM
    // fload_bram::@return
    // }
    // [578] return 
    rts
    // fload_bram::@3
  __b3:
    // fclose(fp)
    // [579] fclose::stream#0 = fload_bram::fp#0
    // [580] call fclose
    // [971] phi from fload_bram::@3 to fclose [phi:fload_bram::@3->fclose]
    // [971] phi fclose::stream#3 = fclose::stream#0 [phi:fload_bram::@3->fclose#0] -- register_copy 
    jsr fclose
    jmp bank_set_bram2
  .segment Data
    bank_set_bram2_bank: .byte 0
    .label read = fgets.read
    dbank: .byte 0
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
    // [582] phi from flight_init to flight_init::memset_fast1 [phi:flight_init->flight_init::memset_fast1]
    // flight_init::memset_fast1
    // [583] phi from flight_init::memset_fast1 to flight_init::memset_fast1_@1 [phi:flight_init::memset_fast1->flight_init::memset_fast1_@1]
    // [583] phi flight_init::memset_fast1_num#2 = $10 [phi:flight_init::memset_fast1->flight_init::memset_fast1_@1#0] -- vbum1=vbuc1 
    lda #$10
    sta memset_fast1_num
    // [583] phi from flight_init::memset_fast1_@1 to flight_init::memset_fast1_@1 [phi:flight_init::memset_fast1_@1->flight_init::memset_fast1_@1]
    // [583] phi flight_init::memset_fast1_num#2 = flight_init::memset_fast1_num#1 [phi:flight_init::memset_fast1_@1->flight_init::memset_fast1_@1#0] -- register_copy 
    // flight_init::memset_fast1_@1
  memset_fast1___b1:
    // *(destination+num) = c
    // [584] flight_init::memset_fast1_destination#0[flight_init::memset_fast1_num#2] = flight_init::memset_fast1_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast1_c
    ldy memset_fast1_num
    sta memset_fast1_destination,y
    // num--;
    // [585] flight_init::memset_fast1_num#1 = -- flight_init::memset_fast1_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast1_num
    // while(num)
    // [586] if(0!=flight_init::memset_fast1_num#1) goto flight_init::memset_fast1_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast1_num
    bne memset_fast1___b1
    // flight_init::@1
    // flight_sprite_offset_pool = 1
    // [587] flight_sprite_offset_pool = 1 -- vbum1=vbuc1 
    lda #1
    sta flight_sprite_offset_pool
    // [588] phi from flight_init::@1 to flight_init::memset_fast2 [phi:flight_init::@1->flight_init::memset_fast2]
    // flight_init::memset_fast2
    // [589] phi from flight_init::memset_fast2 to flight_init::memset_fast2_@1 [phi:flight_init::memset_fast2->flight_init::memset_fast2_@1]
    // [589] phi flight_init::memset_fast2_num#2 = $a [phi:flight_init::memset_fast2->flight_init::memset_fast2_@1#0] -- vbum1=vbuc1 
    lda #$a
    sta memset_fast2_num
    // [589] phi from flight_init::memset_fast2_@1 to flight_init::memset_fast2_@1 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast2_@1]
    // [589] phi flight_init::memset_fast2_num#2 = flight_init::memset_fast2_num#1 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast2_@1#0] -- register_copy 
    // flight_init::memset_fast2_@1
  memset_fast2___b1:
    // *(destination+num) = c
    // [590] flight_init::memset_fast2_destination#0[flight_init::memset_fast2_num#2] = flight_init::memset_fast2_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast2_c
    ldy memset_fast2_num
    sta memset_fast2_destination,y
    // num--;
    // [591] flight_init::memset_fast2_num#1 = -- flight_init::memset_fast2_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast2_num
    // while(num)
    // [592] if(0!=flight_init::memset_fast2_num#1) goto flight_init::memset_fast2_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast2_num
    bne memset_fast2___b1
    // [593] phi from flight_init::memset_fast2_@1 to flight_init::memset_fast3 [phi:flight_init::memset_fast2_@1->flight_init::memset_fast3]
    // flight_init::memset_fast3
    // [594] phi from flight_init::memset_fast3 to flight_init::memset_fast3_@1 [phi:flight_init::memset_fast3->flight_init::memset_fast3_@1]
    // [594] phi flight_init::memset_fast3_num#2 = $a [phi:flight_init::memset_fast3->flight_init::memset_fast3_@1#0] -- vbum1=vbuc1 
    lda #$a
    sta memset_fast3_num
    // [594] phi from flight_init::memset_fast3_@1 to flight_init::memset_fast3_@1 [phi:flight_init::memset_fast3_@1->flight_init::memset_fast3_@1]
    // [594] phi flight_init::memset_fast3_num#2 = flight_init::memset_fast3_num#1 [phi:flight_init::memset_fast3_@1->flight_init::memset_fast3_@1#0] -- register_copy 
    // flight_init::memset_fast3_@1
  memset_fast3___b1:
    // *(destination+num) = c
    // [595] flight_init::memset_fast3_destination#0[flight_init::memset_fast3_num#2] = flight_init::memset_fast3_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast3_c
    ldy memset_fast3_num
    sta memset_fast3_destination,y
    // num--;
    // [596] flight_init::memset_fast3_num#1 = -- flight_init::memset_fast3_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast3_num
    // while(num)
    // [597] if(0!=flight_init::memset_fast3_num#1) goto flight_init::memset_fast3_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast3_num
    bne memset_fast3___b1
    // flight_init::@return
    // }
    // [598] return 
    rts
  .segment Data
    memset_fast1_num: .byte 0
    memset_fast2_num: .byte 0
    memset_fast3_num: .byte 0
}
.segment Code
  // memset
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .label end = stage+$38
    .label dst = $26
    // [600] phi from memset to memset::@1 [phi:memset->memset::@1]
    // [600] phi memset::dst#2 = (char *)(void *)&stage [phi:memset->memset::@1#0] -- pbuz1=pbuc1 
    lda #<stage
    sta.z dst
    lda #>stage
    sta.z dst+1
    // memset::@1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    // [601] if(memset::dst#2!=memset::end#0) goto memset::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // memset::@return
    // }
    // [602] return 
    rts
    // memset::@2
  __b2:
    // *dst = c
    // [603] *memset::dst#2 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    // [604] memset::dst#1 = ++ memset::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [600] phi from memset::@2 to memset::@1 [phi:memset::@2->memset::@1]
    // [600] phi memset::dst#2 = memset::dst#1 [phi:memset::@2->memset::@1#0] -- register_copy 
    jmp __b1
}
  // cbm_k_getin
/**
 * @brief Scan a character from keyboard without pressing enter.
 * 
 * @return char The character read.
 */
// __mem() char cbm_k_getin()
cbm_k_getin: {
    // __mem unsigned char ch
    // [605] cbm_k_getin::ch = 0 -- vbum1=vbuc1 
    lda #0
    sta ch
    // asm
    // asm { jsrCBM_GETIN stach  }
    jsr CBM_GETIN
    sta ch
    // return ch;
    // [607] cbm_k_getin::return#0 = cbm_k_getin::ch -- vbum1=vbum2 
    sta return
    // cbm_k_getin::@return
    // }
    // [608] cbm_k_getin::return#1 = cbm_k_getin::return#0
    // [609] return 
    rts
  .segment Data
    ch: .byte 0
    .label return = kbhit.return
}
.segment Code
  // memcpy
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(void *destination, __zp($31) volatile struct $46 *source, unsigned int num)
memcpy: {
    .const num = $a
    .label destination = stage
    .label src_end = $26
    .label dst = $2d
    .label src = $31
    .label source = $31
    // char* src_end = (char*)source+num
    // [610] memcpy::src_end#0 = (char *)(void *)memcpy::source#0 + memcpy::num#0 -- pbuz1=pbuz2_plus_vwuc1 
    lda.z source
    clc
    adc #<num
    sta.z src_end
    lda.z source+1
    adc #>num
    sta.z src_end+1
    // [611] memcpy::src#4 = (char *)(void *)memcpy::source#0
    // [612] phi from memcpy to memcpy::@1 [phi:memcpy->memcpy::@1]
    // [612] phi memcpy::dst#2 = (char *)memcpy::destination#0 [phi:memcpy->memcpy::@1#0] -- pbuz1=pbuc1 
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    // [612] phi memcpy::src#2 = memcpy::src#4 [phi:memcpy->memcpy::@1#1] -- register_copy 
    // memcpy::@1
  __b1:
    // while(src!=src_end)
    // [613] if(memcpy::src#2!=memcpy::src_end#0) goto memcpy::@2 -- pbuz1_neq_pbuz2_then_la1 
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
    bne __b2
    // memcpy::@return
    // }
    // [614] return 
    rts
    // memcpy::@2
  __b2:
    // *dst++ = *src++
    // [615] *memcpy::dst#2 = *memcpy::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [616] memcpy::dst#1 = ++ memcpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [617] memcpy::src#1 = ++ memcpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [612] phi from memcpy::@2 to memcpy::@1 [phi:memcpy::@2->memcpy::@1]
    // [612] phi memcpy::dst#2 = memcpy::dst#1 [phi:memcpy::@2->memcpy::@1#0] -- register_copy 
    // [612] phi memcpy::src#2 = memcpy::src#1 [phi:memcpy::@2->memcpy::@1#1] -- register_copy 
    jmp __b1
}
.segment CodeEngineStages
  // stage_load
// void stage_load()
// __bank(cx16_ram, 3) 
stage_load: {
    .label stage_playbooks_b = $4a
    .label stage_playbook_b = $4a
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [618] stage_load::stage_playbooks_b#0 = *((struct $46 **)(struct $47 *)&stage+$15+1) -- pssz1=_deref_qssc1 
    lda stage+$15+1
    sta.z stage_playbooks_b
    lda stage+$15+1+1
    sta.z stage_playbooks_b+1
    // stage_playbook_t* stage_playbook_b = &stage_playbooks_b[stage.playbook_current]
    // [619] stage_load::$9 = *((unsigned int *)&stage+$1a) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+$1a
    asl
    sta stage_load__9
    lda stage+$1a+1
    rol
    sta stage_load__9+1
    asl stage_load__9
    rol stage_load__9+1
    // [620] stage_load::$10 = stage_load::$9 + *((unsigned int *)&stage+$1a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_load__10
    adc stage+$1a
    sta stage_load__10
    lda stage_load__10+1
    adc stage+$1a+1
    sta stage_load__10+1
    // [621] stage_load::$2 = stage_load::$10 << 1 -- vwum1=vwum1_rol_1 
    asl stage_load__2
    rol stage_load__2+1
    // [622] stage_load::stage_playbook_b#0 = stage_load::stage_playbooks_b#0 + stage_load::$2 -- pssz1=pssz1_plus_vwum2 
    clc
    lda.z stage_playbook_b
    adc stage_load__2
    sta.z stage_playbook_b
    lda.z stage_playbook_b+1
    adc stage_load__2+1
    sta.z stage_playbook_b+1
    // stage_load_player(stage_playbook_b->stage_player)
    // [623] stage_load_player::stage_player#0 = ((struct $35 **)stage_load::stage_playbook_b#0)[3] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #3
    lda (stage_playbook_b),y
    sta.z stage_load_player.stage_player
    iny
    lda (stage_playbook_b),y
    sta.z stage_load_player.stage_player+1
    // [624] call stage_load_player
    jsr stage_load_player
    // stage_load::@return
    // }
    // [625] return 
    rts
  .segment DataEngineStages
    .label stage_load__2 = stage_load__9
    stage_load__9: .word 0
    .label stage_load__10 = stage_load__9
}
.segment CodeEngineStages
  // stage_copy
// void stage_copy(__mem() char ew, __mem() unsigned int scenario)
// __bank(cx16_ram, 3) 
stage_copy: {
    .label stage_playbook_ptr1_stage_playbooks_b = $44
    .label stage_playbook_ptr1_return = $29
    .label stage_scenario_ptr1_stage_scenarios_b = $40
    .label stage_scenario_ptr1_return = $31
    .label stage_enemy = $46
    // stage_copy::stage_playbook_ptr1
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [627] stage_copy::stage_playbook_ptr1_stage_playbooks_b#0 = *((struct $46 **)(struct $47 *)&stage+$15+1) -- pssz1=_deref_qssc1 
    lda stage+$15+1
    sta.z stage_playbook_ptr1_stage_playbooks_b
    lda stage+$15+1+1
    sta.z stage_playbook_ptr1_stage_playbooks_b+1
    // &stage_playbooks_b[stage.playbook_current]
    // [628] stage_copy::$34 = *((unsigned int *)&stage+$1a) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+$1a
    asl
    sta stage_copy__34
    lda stage+$1a+1
    rol
    sta stage_copy__34+1
    asl stage_copy__34
    rol stage_copy__34+1
    // [629] stage_copy::$35 = stage_copy::$34 + *((unsigned int *)&stage+$1a) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_copy__35
    adc stage+$1a
    sta stage_copy__35
    lda stage_copy__35+1
    adc stage+$1a+1
    sta stage_copy__35+1
    // [630] stage_copy::stage_playbook_ptr1_$1 = stage_copy::$35 << 1 -- vwum1=vwum1_rol_1 
    asl stage_playbook_ptr1_stage_copy__1
    rol stage_playbook_ptr1_stage_copy__1+1
    // [631] stage_copy::stage_playbook_ptr1_return#0 = stage_copy::stage_playbook_ptr1_stage_playbooks_b#0 + stage_copy::stage_playbook_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_playbook_ptr1_stage_copy__1
    clc
    adc.z stage_playbook_ptr1_stage_playbooks_b
    sta.z stage_playbook_ptr1_return
    lda stage_playbook_ptr1_stage_copy__1+1
    adc.z stage_playbook_ptr1_stage_playbooks_b+1
    sta.z stage_playbook_ptr1_return+1
    // stage_copy::stage_scenario_ptr1
    // stage_scenario_t* stage_scenarios_b = stage_playbook_ptr_b->scenarios_b
    // [632] stage_copy::stage_scenario_ptr1_stage_scenarios_b#0 = ((struct $42 **)stage_copy::stage_playbook_ptr1_return#0)[1] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #1
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b
    iny
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b+1
    // &stage_scenarios_b[scenario]
    // [633] stage_copy::stage_scenario_ptr1_$1 = stage_copy::scenario#2 << 4 -- vwum1=vwum2_rol_4 
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
    // [634] stage_copy::stage_scenario_ptr1_return#0 = stage_copy::stage_scenario_ptr1_stage_scenarios_b#0 + stage_copy::stage_scenario_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_scenario_ptr1_stage_copy__1
    clc
    adc.z stage_scenario_ptr1_stage_scenarios_b
    sta.z stage_scenario_ptr1_return
    lda stage_scenario_ptr1_stage_copy__1+1
    adc.z stage_scenario_ptr1_stage_scenarios_b+1
    sta.z stage_scenario_ptr1_return+1
    // stage_copy::@1
    // wave.x[ew] = stage_scenario_ptr_b->x
    // [635] stage_copy::$4 = stage_copy::ew#2 << 1 -- vbum1=vbum2_rol_1 
    lda ew
    asl
    sta stage_copy__4
    // [636] ((int *)&wave+$30)[stage_copy::$4] = ((int *)stage_copy::stage_scenario_ptr1_return#0)[6] -- pwsc1_derefidx_vbum1=pwsz2_derefidx_vbuc2 
    tax
    ldy #6
    lda (stage_scenario_ptr1_return),y
    sta wave+$30,x
    iny
    lda (stage_scenario_ptr1_return),y
    sta wave+$30+1,x
    // wave.y[ew] = stage_scenario_ptr_b->y
    // [637] ((int *)&wave+$40)[stage_copy::$4] = ((int *)stage_copy::stage_scenario_ptr1_return#0)[8] -- pwsc1_derefidx_vbum1=pwsz2_derefidx_vbuc2 
    ldy #8
    lda (stage_scenario_ptr1_return),y
    sta wave+$40,x
    iny
    lda (stage_scenario_ptr1_return),y
    sta wave+$40+1,x
    // wave.enemy_count[ew] = stage_scenario_ptr_b->enemy_count
    // [638] ((char *)&wave)[stage_copy::ew#2] = *((char *)stage_copy::stage_scenario_ptr1_return#0) -- pbuc1_derefidx_vbum1=_deref_pbuz2 
    ldy #0
    lda (stage_scenario_ptr1_return),y
    ldy ew
    sta wave,y
    // wave.dx[ew] = stage_scenario_ptr_b->dx
    // [639] ((signed char *)&wave+$50)[stage_copy::ew#2] = ((signed char *)stage_copy::stage_scenario_ptr1_return#0)[$a] -- pbsc1_derefidx_vbum1=pbsz2_derefidx_vbuc2 
    ldx ew
    ldy #$a
    lda (stage_scenario_ptr1_return),y
    sta wave+$50,x
    // wave.dy[ew] = stage_scenario_ptr_b->dy
    // [640] ((signed char *)&wave+$58)[stage_copy::ew#2] = ((signed char *)stage_copy::stage_scenario_ptr1_return#0)[$b] -- pbsc1_derefidx_vbum1=pbsz2_derefidx_vbuc2 
    ldy #$b
    lda (stage_scenario_ptr1_return),y
    sta wave+$58,x
    // wave.enemy_flightpath[ew] = stage_scenario_ptr_b->enemy_flightpath
    // [641] ((struct $41 **)&wave+$18)[stage_copy::$4] = ((struct $41 **)stage_copy::stage_scenario_ptr1_return#0)[4] -- qssc1_derefidx_vbum1=qssz2_derefidx_vbuc2 
    ldx stage_copy__4
    ldy #4
    lda (stage_scenario_ptr1_return),y
    sta wave+$18,x
    iny
    lda (stage_scenario_ptr1_return),y
    sta wave+$18+1,x
    // wave.enemy_spawn[ew] = stage_scenario_ptr_b->enemy_spawn
    // [642] ((char *)&wave+8)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[1] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldx ew
    ldy #1
    lda (stage_scenario_ptr1_return),y
    sta wave+8,x
    // stage_enemy_t* stage_enemy = stage_scenario_ptr_b->stage_enemy
    // [643] stage_copy::stage_enemy#0 = ((struct $36 **)stage_copy::stage_scenario_ptr1_return#0)[2] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #2
    lda (stage_scenario_ptr1_return),y
    sta.z stage_enemy
    iny
    lda (stage_scenario_ptr1_return),y
    sta.z stage_enemy+1
    // wave.animation_speed[ew] = stage_enemy->animation_speed
    // [644] ((char *)&wave+$98)[stage_copy::ew#2] = ((char *)stage_copy::stage_enemy#0)[4] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #4
    lda (stage_enemy),y
    sta wave+$98,x
    // wave.animation_reverse[ew] = stage_enemy->animation_reverse
    // [645] ((char *)&wave+$a0)[stage_copy::ew#2] = ((char *)stage_copy::stage_enemy#0)[5] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #5
    lda (stage_enemy),y
    sta wave+$a0,x
    // wave.enemy_sprite[ew] = stage_enemy->enemy_sprite_flight
    // [646] ((char *)&wave+$10)[stage_copy::ew#2] = *((char *)stage_copy::stage_enemy#0) -- pbuc1_derefidx_vbum1=_deref_pbuz2 
    ldy #0
    lda (stage_enemy),y
    ldy ew
    sta wave+$10,y
    // wave.interval[ew] = stage_scenario_ptr_b->interval
    // [647] ((char *)&wave+$60)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[$c] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #$c
    lda (stage_scenario_ptr1_return),y
    sta wave+$60,x
    // wave.prev[ew] = stage_scenario_ptr_b->prev
    // [648] ((char *)&wave+$70)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[$e] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #$e
    lda (stage_scenario_ptr1_return),y
    sta wave+$70,x
    // wave.wait[ew] = stage_scenario_ptr_b->wait
    // [649] ((char *)&wave+$68)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[$d] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #$d
    lda (stage_scenario_ptr1_return),y
    sta wave+$68,x
    // wave.used[ew] = 1
    // [650] ((char *)&wave+$78)[stage_copy::ew#2] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    ldy ew
    sta wave+$78,y
    // wave.finished[ew] = 0
    // [651] ((char *)&wave+$80)[stage_copy::ew#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta wave+$80,y
    // wave.scenario[ew] = scenario
    // [652] ((unsigned int *)&wave+$88)[stage_copy::$4] = stage_copy::scenario#2 -- pwuc1_derefidx_vbum1=vwum2 
    ldy stage_copy__4
    lda scenario
    sta wave+$88,y
    lda scenario+1
    sta wave+$88+1,y
    // wave.enemy_alive[ew] = 0
    // [653] ((char *)&wave+$28)[stage_copy::ew#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy ew
    sta wave+$28,y
    // stage_copy::@return
    // }
    // [654] return 
    rts
  .segment DataEngineStages
    stage_copy__4: .byte 0
    .label stage_playbook_ptr1_stage_copy__1 = stage_copy__34
    stage_scenario_ptr1_stage_copy__1: .word 0
  .segment Data
    ew: .byte 0
    scenario: .word 0
  .segment DataEngineStages
    stage_copy__34: .word 0
    .label stage_copy__35 = stage_copy__34
}
.segment CodeEnginePlayers
  // player_add
// void player_add(__mem() char sprite_player, __mem() char sprite_engine)
// __bank(cx16_ram, 9) 
player_add: {
    // unsigned char p = flight_add(FLIGHT_PLAYER, SIDE_PLAYER, sprite_player)
    // [656] flight_add::sprite#0 = player_add::sprite_player#2 -- vbum1=vbum2 
    lda sprite_player
    sta flight_add.sprite
    // [657] call flight_add
    // [1024] phi from player_add to flight_add [phi:player_add->flight_add]
    // [1024] phi flight_add::sprite#6 = flight_add::sprite#0 [phi:player_add->flight_add#0] -- register_copy 
    // [1024] phi flight_add::type#6 = 0 [phi:player_add->flight_add#1] -- vbum1=vbuc1 
    lda #0
    sta flight_add.type
    jsr flight_add
    // unsigned char p = flight_add(FLIGHT_PLAYER, SIDE_PLAYER, sprite_player)
    // [658] flight_add::return#2 = flight_add::f#2
    // player_add::@1
    // [659] player_add::p#0 = flight_add::return#2 -- vbum1=vbum2 
    lda flight_add.return
    sta p
    // flight.moved[p] = 2
    // [660] ((char *)&flight+$5c0)[player_add::p#0] = 2 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #2
    ldy p
    sta flight+$5c0,y
    // flight.firegun[p] = 0
    // [661] ((char *)&flight+$700)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta flight+$700,y
    // flight.reload[p] = 0
    // [662] ((char *)&flight+$740)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$740,y
    // flight.health[p] = 100
    // [663] ((signed char *)&flight+$880)[player_add::p#0] = $64 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #$64
    sta flight+$880,y
    // flight.impact[p] = -100
    // [664] ((signed char *)&flight+$8c0)[player_add::p#0] = -$64 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #-$64
    sta flight+$8c0,y
    // animate_add(6,3,3,10,1,0)
    // [665] stackpush(char) = 6 -- _stackpushbyte_=vbuc1 
    lda #6
    pha
    // [666] stackpush(char) = 3 -- _stackpushbyte_=vbuc1 
    lda #3
    pha
    // [667] stackpush(char) = 3 -- _stackpushbyte_=vbuc1 
    pha
    // [668] stackpush(char) = $a -- _stackpushbyte_=vbuc1 
    lda #$a
    pha
    // [669] stackpush(signed char) = 1 -- _stackpushsbyte_=vbsc1 
    lda #1
    pha
    // [670] stackpush(char) = 0 -- _stackpushbyte_=vbuc1 
    lda #0
    pha
    // [671] callexecute animate_add  -- call_stack_near 
    jsr lib_animate.animate_add
    // sideeffect stackpullpadding(5) -- _stackpullpadding_5 
    pla
    pla
    pla
    pla
    pla
    // [673] player_add::$1 = stackpull(char) -- vbum1=_stackpullbyte_ 
    pla
    sta player_add__1
    // flight.animate[p] = animate_add(6,3,3,10,1,0)
    // [674] ((char *)&flight+$900)[player_add::p#0] = player_add::$1 -- pbuc1_derefidx_vbum1=vbum2 
    ldy p
    sta flight+$900,y
    // flight.xf[p] = 0
    // [675] ((char *)&flight+$280)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta flight+$280,y
    // flight.yf[p] = 0
    // [676] ((char *)&flight+$2c0)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$2c0,y
    // flight.xi[p] = 320
    // [677] player_add::$5 = player_add::p#0 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta player_add__5
    // [678] ((unsigned int *)&flight+$300)[player_add::$5] = $140 -- pwuc1_derefidx_vbum1=vwuc2 
    tay
    lda #<$140
    sta flight+$300,y
    lda #>$140
    sta flight+$300+1,y
    // flight.yi[p] = 200
    // [679] ((unsigned int *)&flight+$380)[player_add::$5] = $c8 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #$c8
    sta flight+$380,y
    lda #0
    sta flight+$380+1,y
    // flight.xd[p] = 0
    // [680] ((unsigned int *)&flight+$400)[player_add::$5] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    sta flight+$400,y
    sta flight+$400+1,y
    // flight.yd[p] = 0
    // [681] ((unsigned int *)&flight+$480)[player_add::$5] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    sta flight+$480,y
    sta flight+$480+1,y
    // unsigned char n = flight_add(FLIGHT_ENGINE, SIDE_PLAYER, sprite_engine)
    // [682] flight_add::sprite#1 = player_add::sprite_engine#2 -- vbum1=vbum2 
    lda sprite_engine
    sta flight_add.sprite
    // [683] call flight_add
    // [1024] phi from player_add::@1 to flight_add [phi:player_add::@1->flight_add]
    // [1024] phi flight_add::sprite#6 = flight_add::sprite#1 [phi:player_add::@1->flight_add#0] -- register_copy 
    // [1024] phi flight_add::type#6 = 4 [phi:player_add::@1->flight_add#1] -- vbum1=vbuc1 
    lda #4
    sta flight_add.type
    jsr flight_add
    // unsigned char n = flight_add(FLIGHT_ENGINE, SIDE_PLAYER, sprite_engine)
    // [684] flight_add::return#3 = flight_add::f#2
    // player_add::@2
    // [685] player_add::n#0 = flight_add::return#3 -- vbum1=vbum2 
    lda flight_add.return
    sta n
    // flight.engine[p] = n
    // [686] ((char *)&flight+$6c0)[player_add::p#0] = player_add::n#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy p
    sta flight+$6c0,y
    // animate_add(16,0,0,2,1,0)
    // [687] stackpush(char) = $10 -- _stackpushbyte_=vbuc1 
    lda #$10
    pha
    // [688] stackpush(char) = 0 -- _stackpushbyte_=vbuc1 
    lda #0
    pha
    // [689] stackpush(char) = 0 -- _stackpushbyte_=vbuc1 
    pha
    // [690] stackpush(char) = 2 -- _stackpushbyte_=vbuc1 
    lda #2
    pha
    // [691] stackpush(signed char) = 1 -- _stackpushsbyte_=vbsc1 
    lda #1
    pha
    // [692] stackpush(char) = 0 -- _stackpushbyte_=vbuc1 
    lda #0
    pha
    // [693] callexecute animate_add  -- call_stack_near 
    jsr lib_animate.animate_add
    // sideeffect stackpullpadding(5) -- _stackpullpadding_5 
    pla
    pla
    pla
    pla
    pla
    // [695] player_add::$3 = stackpull(char) -- vbum1=_stackpullbyte_ 
    pla
    sta player_add__3
    // flight.animate[n] = animate_add(16,0,0,2,1,0)
    // [696] ((char *)&flight+$900)[player_add::n#0] = player_add::$3 -- pbuc1_derefidx_vbum1=vbum2 
    ldy n
    sta flight+$900,y
    // stage.player = p
    // [697] *((char *)&stage+$10) = player_add::p#0 -- _deref_pbuc1=vbum1 
    lda p
    sta stage+$10
    // player_add::@return
    // }
    // [698] return 
    rts
  .segment DataEnginePlayers
    player_add__1: .byte 0
    player_add__3: .byte 0
    player_add__5: .byte 0
    p: .byte 0
    n: .byte 0
  .segment Data
    sprite_player: .byte 0
    sprite_engine: .byte 0
}
.segment Code
  // collision_init
// void collision_init()
collision_init: {
    .const memset_fast1_c = 0
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast1_destination = collision_quadrant
    // ht_init(&collision_hash)
    // [700] call ht_init
    // [1067] phi from collision_init to ht_init [phi:collision_init->ht_init]
    jsr ht_init
    // [701] phi from collision_init to collision_init::memset_fast1 [phi:collision_init->collision_init::memset_fast1]
    // collision_init::memset_fast1
    // [702] phi from collision_init::memset_fast1 to collision_init::memset_fast1_@1 [phi:collision_init::memset_fast1->collision_init::memset_fast1_@1]
    // [702] phi collision_init::memset_fast1_num#2 = 0 [phi:collision_init::memset_fast1->collision_init::memset_fast1_@1#0] -- vbum1=vbuc1 
    lda #0
    sta memset_fast1_num
    // [702] phi from collision_init::memset_fast1_@1 to collision_init::memset_fast1_@1 [phi:collision_init::memset_fast1_@1->collision_init::memset_fast1_@1]
    // [702] phi collision_init::memset_fast1_num#2 = collision_init::memset_fast1_num#1 [phi:collision_init::memset_fast1_@1->collision_init::memset_fast1_@1#0] -- register_copy 
    // collision_init::memset_fast1_@1
  memset_fast1___b1:
    // *(destination+num) = c
    // [703] collision_init::memset_fast1_destination#0[collision_init::memset_fast1_num#2] = collision_init::memset_fast1_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast1_c
    ldy memset_fast1_num
    sta memset_fast1_destination,y
    // num--;
    // [704] collision_init::memset_fast1_num#1 = -- collision_init::memset_fast1_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast1_num
    // while(num)
    // [705] if(0!=collision_init::memset_fast1_num#1) goto collision_init::memset_fast1_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast1_num
    bne memset_fast1___b1
    // collision_init::@return
    // }
    // [706] return 
    rts
  .segment Data
    memset_fast1_num: .byte 0
}
.segment CodeEnginePlayers
  // player_logic
// void player_logic()
// __bank(cx16_ram, 9) 
player_logic: {
    // flight_index_t p = flight_root(FLIGHT_PLAYER)
    // [708] call flight_root
    jsr flight_root
    // [709] flight_root::return#2 = flight_root::return#0
    // player_logic::@11
    // [710] player_logic::p#0 = flight_root::return#2 -- vbum1=vbum2 
    lda flight_root.return
    sta p
    // [711] phi from player_logic::@11 player_logic::@3 to player_logic::@1 [phi:player_logic::@11/player_logic::@3->player_logic::@1]
    // [711] phi player_logic::p#10 = player_logic::p#0 [phi:player_logic::@11/player_logic::@3->player_logic::@1#0] -- register_copy 
    // player_logic::@1
  __b1:
    // while(p)
    // [712] if(0!=player_logic::p#10) goto player_logic::@2 -- 0_neq_vbum1_then_la1 
    lda p
    bne __b2
    // player_logic::@return
    // }
    // [713] return 
    rts
    // player_logic::@2
  __b2:
    // flight_index_t pn = flight_next(p)
    // [714] flight_next::i#0 = player_logic::p#10 -- vbum1=vbum2 
    lda p
    sta flight_next.i
    // [715] call flight_next
    jsr flight_next
    // [716] flight_next::return#2 = flight_next::return#0
    // player_logic::@12
    // [717] player_logic::p#1 = flight_next::return#2 -- vbum1=vbum2 
    lda flight_next.return
    sta p_1
    // if (flight.type[p] == FLIGHT_PLAYER && flight.used[p])
    // [718] if(((char *)&flight+$180)[player_logic::p#10]!=0) goto player_logic::@3 -- pbuc1_derefidx_vbum1_neq_0_then_la1 
    ldy p
    lda flight+$180,y
    cmp #0
    bne __b3
    // player_logic::@13
    // [719] if(0!=((char *)&flight+$c0)[player_logic::p#10]) goto player_logic::@9 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda flight+$c0,y
    cmp #0
    bne __b9
    // player_logic::@3
  __b3:
    // [720] player_logic::p#13 = player_logic::p#1 -- vbum1=vbum2 
    lda p_1
    sta p
    jmp __b1
    // player_logic::@9
  __b9:
    // if (flight.reload[p] > 0)
    // [721] if(((char *)&flight+$740)[player_logic::p#10]<=0) goto player_logic::@4 -- pbuc1_derefidx_vbum1_le_0_then_la1 
    ldy p
    lda flight+$740,y
    cmp #0
    beq __b4
    // player_logic::@10
    // flight.reload[p]--;
    // [722] ((char *)&flight+$740)[player_logic::p#10] = -- ((char *)&flight+$740)[player_logic::p#10] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx p
    dec flight+$740,x
    // player_logic::@4
  __b4:
    // flight.xi[p] = (unsigned int)cx16_mouse.x
    // [723] player_logic::$17 = player_logic::p#10 << 1 -- vbum1=vbum2_rol_1 
    lda p
    asl
    sta player_logic__17
    // [724] ((unsigned int *)&flight+$300)[player_logic::$17] = (unsigned int)*((int *)&cx16_mouse) -- pwuc1_derefidx_vbum1=_deref_pwuc2 
    tay
    lda cx16_mouse
    sta flight+$300,y
    lda cx16_mouse+1
    sta flight+$300+1,y
    // flight.yi[p] = (unsigned int)cx16_mouse.y
    // [725] ((unsigned int *)&flight+$380)[player_logic::$17] = (unsigned int)*((int *)&cx16_mouse+2) -- pwuc1_derefidx_vbum1=_deref_pwuc2 
    lda cx16_mouse+2
    sta flight+$380,y
    lda cx16_mouse+2+1
    sta flight+$380+1,y
    // flight_index_t n = flight.engine[p]
    // [726] player_logic::n#0 = ((char *)&flight+$6c0)[player_logic::p#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy p
    lda flight+$6c0,y
    sta n
    // flight.xi[p]+8
    // [727] player_logic::$8 = ((unsigned int *)&flight+$300)[player_logic::$17] + 8 -- vwum1=pwuc1_derefidx_vbum2_plus_vbuc2 
    lda #8
    ldy player_logic__17
    clc
    adc flight+$300,y
    sta player_logic__8
    lda flight+$300+1,y
    adc #0
    sta player_logic__8+1
    // flight.xi[n] = flight.xi[p]+8
    // [728] player_logic::$21 = player_logic::n#0 << 1 -- vbum1=vbum2_rol_1 
    lda n
    asl
    sta player_logic__21
    // [729] ((unsigned int *)&flight+$300)[player_logic::$21] = player_logic::$8 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda player_logic__8
    sta flight+$300,y
    lda player_logic__8+1
    sta flight+$300+1,y
    // flight.yi[p]+32
    // [730] player_logic::$9 = ((unsigned int *)&flight+$380)[player_logic::$17] + $20 -- vwum1=pwuc1_derefidx_vbum2_plus_vbuc2 
    lda #$20
    ldy player_logic__17
    clc
    adc flight+$380,y
    sta player_logic__9
    lda flight+$380+1,y
    adc #0
    sta player_logic__9+1
    // flight.yi[n] = flight.yi[p]+32
    // [731] ((unsigned int *)&flight+$380)[player_logic::$21] = player_logic::$9 -- pwuc1_derefidx_vbum1=vwum2 
    ldy player_logic__21
    lda player_logic__9
    sta flight+$380,y
    lda player_logic__9+1
    sta flight+$380+1,y
    // unsigned int x = flight.xi[p]
    // [732] player_logic::x#0 = ((unsigned int *)&flight+$300)[player_logic::$17] -- vwum1=pwuc1_derefidx_vbum2 
    ldy player_logic__17
    lda flight+$300,y
    sta x
    lda flight+$300+1,y
    sta x+1
    // unsigned int y = flight.yi[p]
    // [733] player_logic::y#0 = ((unsigned int *)&flight+$380)[player_logic::$17] -- vwum1=pwuc1_derefidx_vbum2 
    lda flight+$380,y
    sta y
    lda flight+$380+1,y
    sta y+1
    // if (x > 640 - 32)
    // [734] if(player_logic::x#0<=$280-$20) goto player_logic::@5 -- vwum1_le_vwuc1_then_la1 
    lda x+1
    cmp #>$280-$20
    bne !+
    lda x
    cmp #<$280-$20
  !:
    // [735] phi from player_logic::@4 to player_logic::@7 [phi:player_logic::@4->player_logic::@7]
    // player_logic::@7
    // player_logic::@5
    // if (y > 480 - 32)
    // [736] if(player_logic::y#0<=$1e0-$20) goto player_logic::@6 -- vwum1_le_vwuc1_then_la1 
    lda y+1
    cmp #>$1e0-$20
    bne !+
    lda y
    cmp #<$1e0-$20
  !:
    // [737] phi from player_logic::@5 to player_logic::@8 [phi:player_logic::@5->player_logic::@8]
    // player_logic::@8
    // player_logic::@6
    // unsigned char ap = flight.animate[p]
    // [738] player_logic::ap#0 = ((char *)&flight+$900)[player_logic::p#10] -- vbum1=pbuc1_derefidx_vbum1 
    ldy ap
    lda flight+$900,y
    sta ap
    // animate_player(ap, (signed int)cx16_mouse.x, (signed int)cx16_mouse.px)
    // [739] stackpush(char) = player_logic::ap#0 -- _stackpushbyte_=vbum1 
    pha
    // [740] stackpush(int) = *((int *)&cx16_mouse) -- _stackpushsword_=_deref_pwsc1 
    lda cx16_mouse+1
    pha
    lda cx16_mouse
    pha
    // [741] stackpush(int) = *((int *)&cx16_mouse+4) -- _stackpushsword_=_deref_pwsc1 
    lda cx16_mouse+4+1
    pha
    lda cx16_mouse+4
    pha
    // [742] callexecute animate_player  -- call_stack_near 
    jsr lib_animate.animate_player
    // sideeffect stackpullpadding(5) -- _stackpullpadding_5 
    pla
    pla
    pla
    pla
    pla
    // unsigned char an = flight.animate[n]
    // [744] player_logic::an#0 = ((char *)&flight+$900)[player_logic::n#0] -- vbum1=pbuc1_derefidx_vbum1 
    ldy an
    lda flight+$900,y
    sta an
    // animate_logic(an)
    // [745] stackpush(char) = player_logic::an#0 -- _stackpushbyte_=vbum1 
    pha
    // [746] callexecute animate_logic  -- call_stack_near 
    jsr lib_animate.animate_logic
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b3
  .segment DataEnginePlayers
    player_logic__8: .word 0
    player_logic__9: .word 0
    player_logic__17: .byte 0
    player_logic__21: .byte 0
    p: .byte 0
    p_1: .byte 0
    n: .byte 0
    x: .word 0
    y: .word 0
    .label ap = p
    .label an = n
}
.segment CodeEngineFlight
  // flight_draw
// void flight_draw()
flight_draw: {
    // [749] phi from flight_draw to flight_draw::@1 [phi:flight_draw->flight_draw::@1]
    // [749] phi flight_draw::f#10 = 0 [phi:flight_draw->flight_draw::@1#0] -- vbum1=vbuc1 
    lda #0
    sta f
  // BREAKPOINT
    // flight_draw::@1
  __b1:
    // for (unsigned char f = 0; f < FLIGHT_OBJECTS; f++)
    // [750] if(flight_draw::f#10<$40) goto flight_draw::@2 -- vbum1_lt_vbuc1_then_la1 
    lda f
    cmp #$40
    bcc __b2
    // flight_draw::@return
    // }
    // [751] return 
    rts
    // flight_draw::@2
  __b2:
    // if (flight.used[f])
    // [752] if(0==((char *)&flight+$c0)[flight_draw::f#10]) goto flight_draw::@3 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy f
    lda flight+$c0,y
    cmp #0
    bne !__b3+
    jmp __b3
  !__b3:
    // flight_draw::@7
    // unsigned int x = flight.xi[f]
    // [753] flight_draw::$22 = flight_draw::f#10 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta flight_draw__22
    // [754] flight_draw::x#0 = ((unsigned int *)&flight+$300)[flight_draw::$22] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda flight+$300,y
    sta x
    lda flight+$300+1,y
    sta x+1
    // unsigned int y = flight.yi[f]
    // [755] flight_draw::y#0 = ((unsigned int *)&flight+$380)[flight_draw::$22] -- vwum1=pwuc1_derefidx_vbum2 
    lda flight+$380,y
    sta y
    lda flight+$380+1,y
    sta y+1
    // vera_sprite_offset sprite_offset = flight.sprite_offset[f]
    // [756] flight_draw::sprite_offset#0 = ((unsigned int *)&flight+$40)[flight_draw::$22] -- vwum1=pwuc1_derefidx_vbum2 
    lda flight+$40,y
    sta sprite_offset
    lda flight+$40+1,y
    sta sprite_offset+1
    // unsigned char a = flight.animate[f]
    // [757] flight_draw::a#0 = ((char *)&flight+$900)[flight_draw::f#10] -- vbum1=pbuc1_derefidx_vbum2 
    // if( x<640+68 && y<480+68 && (signed int)x>-68 && (signed int)y>-68 ) {
    ldy f
    lda flight+$900,y
    sta a
    // unsigned char s = animate_get_image(a)
    // [758] stackpush(char) = flight_draw::a#0 -- _stackpushbyte_=vbum1 
    pha
    // [759] callexecute animate_get_image  -- call_stack_near 
    jsr lib_animate.animate_get_image
    // [760] flight_draw::s#0 = stackpull(char) -- vbum1=_stackpullbyte_ 
    pla
    sta s
    // volatile unsigned char i = flight.cache[f]
    // [761] flight_draw::i = ((char *)&flight)[flight_draw::f#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy f
    lda flight,y
    sta i
    // animate_is_waiting(a)
    // [762] stackpush(char) = flight_draw::a#0 -- _stackpushbyte_=vbum1 
    lda a
    pha
    // [763] callexecute animate_is_waiting  -- call_stack_near 
    jsr lib_animate.animate_is_waiting
    // [764] flight_draw::$3 = stackpull(char) -- vbum1=_stackpullbyte_ 
    pla
    sta flight_draw__3
    // if (animate_is_waiting(a))
    // [765] if(0!=flight_draw::$3) goto flight_draw::@4 -- 0_neq_vbum1_then_la1 
    // This variable needs to be volatile or the kickc optimizer kills it.
    beq !__b4+
    jmp __b4
  !__b4:
    // flight_draw::@8
    // vera_sprite_image_offset sprite_image_offset = sprite_image_cache_vram(i, s)
    // [766] sprite_image_cache_vram::sprite_cache_index#0 = flight_draw::i -- vbum1=vbum2 
    lda i
    sta sprite_image_cache_vram.sprite_cache_index
    // [767] sprite_image_cache_vram::fe_sprite_image_index#0 = flight_draw::s#0
    // [768] call sprite_image_cache_vram
    jsr sprite_image_cache_vram
    // [769] sprite_image_cache_vram::return#2 = sprite_image_cache_vram::return#0
    // flight_draw::@10
    // [770] flight_draw::sprite_image_offset#0 = sprite_image_cache_vram::return#2
    // if(sprite_image_offset==0x0)
    // [771] if(flight_draw::sprite_image_offset#0!=0) goto flight_draw::@5 -- vwum1_neq_0_then_la1 
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
    // [773] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // gotoxy(0,0);
    // printf("%02x %04x, ", f, sprite_image_offset);
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_H = 1 | VERA_INC_1
    // [774] *VERA_ADDRX_H = 1|VERA_INC_1 -- _deref_pbuc1=vbuc2 
    // Select DATA0
    lda #1|VERA_INC_1
    sta VERA_ADDRX_H
    // BYTE1(sprite_offset)
    // [775] flight_draw::$7 = byte1  flight_draw::sprite_offset#0 -- vbum1=_byte1_vwum2 
    lda sprite_offset+1
    sta flight_draw__7
    // *VERA_ADDRX_M = BYTE1(sprite_offset)
    // [776] *VERA_ADDRX_M = flight_draw::$7 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // BYTE0(sprite_offset)
    // [777] flight_draw::$8 = byte0  flight_draw::sprite_offset#0 -- vbum1=_byte0_vwum2 
    lda sprite_offset
    sta flight_draw__8
    // *VERA_ADDRX_L = BYTE0(sprite_offset)
    // [778] *VERA_ADDRX_L = flight_draw::$8 -- _deref_pbuc1=vbum1 
    // Normally the +2 should not be an issue.
    sta VERA_ADDRX_L
    // BYTE0(sprite_image_offset)
    // [779] flight_draw::$9 = byte0  flight_draw::sprite_image_offset#0 -- vbum1=_byte0_vwum2 
    lda sprite_image_offset
    sta flight_draw__9
    // *VERA_DATA0 = BYTE0(sprite_image_offset)
    // [780] *VERA_DATA0 = flight_draw::$9 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // BYTE1(sprite_image_offset)
    // [781] flight_draw::$10 = byte1  flight_draw::sprite_image_offset#0 -- vbum1=_byte1_vwum2 
    lda sprite_image_offset+1
    sta flight_draw__10
    // *VERA_DATA0 = BYTE1(sprite_image_offset)
    // [782] *VERA_DATA0 = flight_draw::$10 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // flight_draw::@6
  __b6:
    // BYTE0(x)
    // [783] flight_draw::$15 = byte0  flight_draw::x#0 -- vbum1=_byte0_vwum2 
    lda x
    sta flight_draw__15
    // *VERA_DATA0 = BYTE0(x)
    // [784] *VERA_DATA0 = flight_draw::$15 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // BYTE1(x)
    // [785] flight_draw::$16 = byte1  flight_draw::x#0 -- vbum1=_byte1_vwum2 
    lda x+1
    sta flight_draw__16
    // *VERA_DATA0 = BYTE1(x)
    // [786] *VERA_DATA0 = flight_draw::$16 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // BYTE0(y)
    // [787] flight_draw::$17 = byte0  flight_draw::y#0 -- vbum1=_byte0_vwum2 
    lda y
    sta flight_draw__17
    // *VERA_DATA0 = BYTE0(y)
    // [788] *VERA_DATA0 = flight_draw::$17 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // BYTE1(y)
    // [789] flight_draw::$18 = byte1  flight_draw::y#0 -- vbum1=_byte1_vwum2 
    lda y+1
    sta flight_draw__18
    // *VERA_DATA0 = BYTE1(y)
    // [790] *VERA_DATA0 = flight_draw::$18 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // *VERA_ADDRX_H = 1 | VERA_INC_0
    // [791] *VERA_ADDRX_H = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta VERA_ADDRX_H
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK
    // [792] flight_draw::$19 = *VERA_DATA0 & ~$c -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$c^$ff
    and VERA_DATA0
    sta flight_draw__19
    // *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | sprite_cache.zdepth[flight.cache[f]]
    // [793] flight_draw::$20 = flight_draw::$19 | ((char *)&sprite_cache+$70)[((char *)&flight)[flight_draw::f#10]] -- vbum1=vbum1_bor_pbuc1_derefidx_(pbuc2_derefidx_vbum2) 
    lda flight_draw__20
    ldx f
    ldy flight,x
    ora sprite_cache+$70,y
    sta flight_draw__20
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_ZDEPTH_MASK | sprite_cache.zdepth[flight.cache[f]]
    // [794] *VERA_DATA0 = flight_draw::$20 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // flight_draw::@3
  __b3:
    // for (unsigned char f = 0; f < FLIGHT_OBJECTS; f++)
    // [795] flight_draw::f#1 = ++ flight_draw::f#10 -- vbum1=_inc_vbum1 
    inc f
    // [749] phi from flight_draw::@3 to flight_draw::@1 [phi:flight_draw::@3->flight_draw::@1]
    // [749] phi flight_draw::f#10 = flight_draw::f#1 [phi:flight_draw::@3->flight_draw::@1#0] -- register_copy 
    jmp __b1
    // flight_draw::@4
  __b4:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [796] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_ADDRX_H = 1 | VERA_INC_1
    // [797] *VERA_ADDRX_H = 1|VERA_INC_1 -- _deref_pbuc1=vbuc2 
    // Select DATA0
    lda #1|VERA_INC_1
    sta VERA_ADDRX_H
    // sprite_offset + 2
    // [798] flight_draw::$13 = flight_draw::sprite_offset#0 + 2 -- vwum1=vwum1_plus_vbuc1 
    lda #2
    clc
    adc flight_draw__13
    sta flight_draw__13
    bcc !+
    inc flight_draw__13+1
  !:
    // BYTE1(sprite_offset + 2)
    // [799] flight_draw::$12 = byte1  flight_draw::$13 -- vbum1=_byte1_vwum2 
    lda flight_draw__13+1
    sta flight_draw__12
    // *VERA_ADDRX_M = BYTE1(sprite_offset + 2)
    // [800] *VERA_ADDRX_M = flight_draw::$12 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // BYTE0(sprite_offset + 2)
    // [801] flight_draw::$14 = byte0  flight_draw::$13 -- vbum1=_byte0_vwum2 
    lda flight_draw__13
    sta flight_draw__14
    // *VERA_ADDRX_L = BYTE0(sprite_offset + 2)
    // [802] *VERA_ADDRX_L = flight_draw::$14 -- _deref_pbuc1=vbum1 
    // Normally the +2 should not be an issue.
    sta VERA_ADDRX_L
    jmp __b6
  .segment DataEngineFlight
    i: .byte 0
    flight_draw__3: .byte 0
    flight_draw__7: .byte 0
    flight_draw__8: .byte 0
    flight_draw__9: .byte 0
    flight_draw__10: .byte 0
    flight_draw__12: .byte 0
    .label flight_draw__13 = sprite_offset
    flight_draw__14: .byte 0
    flight_draw__15: .byte 0
    flight_draw__16: .byte 0
    flight_draw__17: .byte 0
    flight_draw__18: .byte 0
    flight_draw__19: .byte 0
    .label flight_draw__20 = flight_draw__19
    flight_draw__22: .byte 0
    f: .byte 0
    x: .word 0
    y: .word 0
    sprite_offset: .word 0
    a: .byte 0
    s: .byte 0
    .label sprite_image_offset = sprite_image_cache_vram.return
}
.segment Code
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
// void insertup(char rows)
insertup: {
    // __conio.width+1
    // [803] insertup::$0 = *((char *)&__conio+6) + 1 -- vbum1=_deref_pbuc1_plus_1 
    lda __conio+6
    inc
    sta insertup__0
    // unsigned char width = (__conio.width+1) * 2
    // [804] insertup::width#0 = insertup::$0 << 1 -- vbum1=vbum1_rol_1 
    // {asm{.byte $db}}
    asl width
    // [805] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [805] phi insertup::y#2 = 0 [phi:insertup->insertup::@1#0] -- vbum1=vbuc1 
    lda #0
    sta y
    // insertup::@1
  __b1:
    // for(unsigned char y=0; y<__conio.cursor_y; y++)
    // [806] if(insertup::y#2<*((char *)&__conio+1)) goto insertup::@2 -- vbum1_lt__deref_pbuc1_then_la1 
    lda y
    cmp __conio+1
    bcc __b2
    // [807] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [808] call clearline
    jsr clearline
    // insertup::@return
    // }
    // [809] return 
    rts
    // insertup::@2
  __b2:
    // y+1
    // [810] insertup::$4 = insertup::y#2 + 1 -- vbum1=vbum2_plus_1 
    lda y
    inc
    sta insertup__4
    // memcpy8_vram_vram(__conio.mapbase_bank, __conio.offsets[y], __conio.mapbase_bank, __conio.offsets[y+1], width)
    // [811] insertup::$6 = insertup::y#2 << 1 -- vbum1=vbum2_rol_1 
    lda y
    asl
    sta insertup__6
    // [812] insertup::$7 = insertup::$4 << 1 -- vbum1=vbum1_rol_1 
    asl insertup__7
    // [813] memcpy8_vram_vram::dbank_vram#0 = *((char *)&__conio+5) -- vbum1=_deref_pbuc1 
    lda __conio+5
    sta memcpy8_vram_vram.dbank_vram
    // [814] memcpy8_vram_vram::doffset_vram#0 = ((unsigned int *)&__conio+$15)[insertup::$6] -- vwum1=pwuc1_derefidx_vbum2 
    ldy insertup__6
    lda __conio+$15,y
    sta memcpy8_vram_vram.doffset_vram
    lda __conio+$15+1,y
    sta memcpy8_vram_vram.doffset_vram+1
    // [815] memcpy8_vram_vram::sbank_vram#0 = *((char *)&__conio+5) -- vbum1=_deref_pbuc1 
    lda __conio+5
    sta memcpy8_vram_vram.sbank_vram
    // [816] memcpy8_vram_vram::soffset_vram#0 = ((unsigned int *)&__conio+$15)[insertup::$7] -- vwum1=pwuc1_derefidx_vbum2 
    ldy insertup__7
    lda __conio+$15,y
    sta memcpy8_vram_vram.soffset_vram
    lda __conio+$15+1,y
    sta memcpy8_vram_vram.soffset_vram+1
    // [817] memcpy8_vram_vram::num8#1 = insertup::width#0 -- vbum1=vbum2 
    lda width
    sta memcpy8_vram_vram.num8_1
    // [818] call memcpy8_vram_vram
    jsr memcpy8_vram_vram
    // insertup::@4
    // for(unsigned char y=0; y<__conio.cursor_y; y++)
    // [819] insertup::y#1 = ++ insertup::y#2 -- vbum1=_inc_vbum1 
    inc y
    // [805] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [805] phi insertup::y#2 = insertup::y#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    insertup__0: .byte 0
    insertup__4: .byte 0
    insertup__6: .byte 0
    .label insertup__7 = insertup__4
    .label width = insertup__0
    y: .byte 0
}
.segment Code
  // clearline
// void clearline()
clearline: {
    .label c = $3f
    // unsigned int addr = __conio.offsets[__conio.cursor_y]
    // [820] clearline::$3 = *((char *)&__conio+1) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda __conio+1
    asl
    sta clearline__3
    // [821] clearline::addr#0 = ((unsigned int *)&__conio+$15)[clearline::$3] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda __conio+$15,y
    sta addr
    lda __conio+$15+1,y
    sta addr+1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [822] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(addr)
    // [823] clearline::$0 = byte0  clearline::addr#0 -- vbum1=_byte0_vwum2 
    lda addr
    sta clearline__0
    // *VERA_ADDRX_L = BYTE0(addr)
    // [824] *VERA_ADDRX_L = clearline::$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(addr)
    // [825] clearline::$1 = byte1  clearline::addr#0 -- vbum1=_byte1_vwum2 
    lda addr+1
    sta clearline__1
    // *VERA_ADDRX_M = BYTE1(addr)
    // [826] *VERA_ADDRX_M = clearline::$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [827] clearline::$2 = *((char *)&__conio+5) | VERA_INC_1 -- vbum1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+5
    sta clearline__2
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [828] *VERA_ADDRX_H = clearline::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // register unsigned char c=__conio.width
    // [829] clearline::c#0 = *((char *)&__conio+6) -- vbuz1=_deref_pbuc1 
    lda __conio+6
    sta.z c
    // [830] phi from clearline clearline::@1 to clearline::@1 [phi:clearline/clearline::@1->clearline::@1]
    // [830] phi clearline::c#2 = clearline::c#0 [phi:clearline/clearline::@1->clearline::@1#0] -- register_copy 
    // clearline::@1
  __b1:
    // *VERA_DATA0 = ' '
    // [831] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
  .encoding "screencode_mixed"
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = __conio.color
    // [832] *VERA_DATA0 = *((char *)&__conio+$d) -- _deref_pbuc1=_deref_pbuc2 
    lda __conio+$d
    sta VERA_DATA0
    // c--;
    // [833] clearline::c#1 = -- clearline::c#2 -- vbuz1=_dec_vbuz1 
    dec.z c
    // while(c)
    // [834] if(0!=clearline::c#1) goto clearline::@1 -- 0_neq_vbuz1_then_la1 
    lda.z c
    bne __b1
    // clearline::@return
    // }
    // [835] return 
    rts
  .segment Data
    clearline__0: .byte 0
    clearline__1: .byte 0
    clearline__2: .byte 0
    clearline__3: .byte 0
    addr: .word 0
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
// __zp($2d) struct $2 * fopen(__zp($26) const char *path, const char *mode)
fopen: {
    .label fopen__11 = $29
    .label fopen__28 = $24
    .label cbm_k_setnam1_filename = $3c
    .label stream = $2d
    .label pathtoken = $26
    .label pathtoken_1 = $31
    .label path = $26
    .label return = $2d
    // unsigned char sp = __stdio_filecount
    // [837] fopen::sp#0 = __stdio_filecount -- vbum1=vbum2 
    lda __stdio_filecount
    sta sp
    // (unsigned int)sp | 0x8000
    // [838] fopen::$30 = (unsigned int)fopen::sp#0 -- vwum1=_word_vbum2 
    sta fopen__30
    lda #0
    sta fopen__30+1
    // [839] fopen::stream#0 = fopen::$30 | $8000 -- vwuz1=vwum2_bor_vwuc1 
    lda fopen__30
    ora #<$8000
    sta.z stream
    lda fopen__30+1
    ora #>$8000
    sta.z stream+1
    // char pathpos = sp * __STDIO_FILECOUNT
    // [840] fopen::pathpos#0 = fopen::sp#0 << 2 -- vbum1=vbum2_rol_2 
    lda sp
    asl
    asl
    sta pathpos
    // __logical = 0
    // [841] ((char *)&__stdio_file+$80)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy sp
    sta __stdio_file+$80,y
    // __device = 0
    // [842] ((char *)&__stdio_file+$84)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+$84,y
    // __channel = 0
    // [843] ((char *)&__stdio_file+$88)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+$88,y
    // [844] fopen::pathtoken#22 = fopen::pathtoken#0 -- pbuz1=pbuz2 
    lda.z pathtoken
    sta.z pathtoken_1
    lda.z pathtoken+1
    sta.z pathtoken_1+1
    // [845] fopen::pathpos#21 = fopen::pathpos#0 -- vbum1=vbum2 
    lda pathpos
    sta pathpos_1
    // [846] phi from fopen to fopen::@8 [phi:fopen->fopen::@8]
    // [846] phi fopen::num#10 = 0 [phi:fopen->fopen::@8#0] -- vbum1=vbuc1 
    lda #0
    sta num
    // [846] phi fopen::pathpos#10 = fopen::pathpos#21 [phi:fopen->fopen::@8#1] -- register_copy 
    // [846] phi fopen::path#10 = fopen::pathtoken#0 [phi:fopen->fopen::@8#2] -- register_copy 
    // [846] phi fopen::pathstep#10 = 0 [phi:fopen->fopen::@8#3] -- vbum1=vbuc1 
    sta pathstep
    // [846] phi fopen::pathtoken#10 = fopen::pathtoken#22 [phi:fopen->fopen::@8#4] -- register_copy 
  // Iterate while path is not \0.
    // [846] phi from fopen::@22 to fopen::@8 [phi:fopen::@22->fopen::@8]
    // [846] phi fopen::num#10 = fopen::num#13 [phi:fopen::@22->fopen::@8#0] -- register_copy 
    // [846] phi fopen::pathpos#10 = fopen::pathpos#7 [phi:fopen::@22->fopen::@8#1] -- register_copy 
    // [846] phi fopen::path#10 = fopen::path#11 [phi:fopen::@22->fopen::@8#2] -- register_copy 
    // [846] phi fopen::pathstep#10 = fopen::pathstep#11 [phi:fopen::@22->fopen::@8#3] -- register_copy 
    // [846] phi fopen::pathtoken#10 = fopen::pathtoken#1 [phi:fopen::@22->fopen::@8#4] -- register_copy 
    // fopen::@8
  __b8:
    // if (*pathtoken == ',' || *pathtoken == '\0')
    // [847] if(*fopen::pathtoken#10==',') goto fopen::@9 -- _deref_pbuz1_eq_vbuc1_then_la1 
    lda #','
    ldy #0
    cmp (pathtoken_1),y
    bne !__b9+
    jmp __b9
  !__b9:
    // fopen::@33
    // [848] if(*fopen::pathtoken#10=='@') goto fopen::@9 -- _deref_pbuz1_eq_vbuc1_then_la1 
    lda #'@'
    cmp (pathtoken_1),y
    bne !__b9+
    jmp __b9
  !__b9:
    // fopen::@23
    // if (pathstep == 0)
    // [849] if(fopen::pathstep#10!=0) goto fopen::@10 -- vbum1_neq_0_then_la1 
    lda pathstep
    bne __b10
    // fopen::@24
    // __stdio_file.filename[pathpos] = *pathtoken
    // [850] ((char *)&__stdio_file)[fopen::pathpos#10] = *fopen::pathtoken#10 -- pbuc1_derefidx_vbum1=_deref_pbuz2 
    lda (pathtoken_1),y
    ldy pathpos_1
    sta __stdio_file,y
    // pathpos++;
    // [851] fopen::pathpos#1 = ++ fopen::pathpos#10 -- vbum1=_inc_vbum1 
    inc pathpos_1
    // [852] phi from fopen::@12 fopen::@23 fopen::@24 to fopen::@10 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10]
    // [852] phi fopen::num#13 = fopen::num#15 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#0] -- register_copy 
    // [852] phi fopen::pathpos#7 = fopen::pathpos#10 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#1] -- register_copy 
    // [852] phi fopen::path#11 = fopen::path#13 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#2] -- register_copy 
    // [852] phi fopen::pathstep#11 = fopen::pathstep#1 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#3] -- register_copy 
    // fopen::@10
  __b10:
    // pathtoken++;
    // [853] fopen::pathtoken#1 = ++ fopen::pathtoken#10 -- pbuz1=_inc_pbuz1 
    inc.z pathtoken_1
    bne !+
    inc.z pathtoken_1+1
  !:
    // fopen::@22
    // pathtoken - 1
    // [854] fopen::$28 = fopen::pathtoken#1 - 1 -- pbuz1=pbuz2_minus_1 
    lda.z pathtoken_1
    sec
    sbc #1
    sta.z fopen__28
    lda.z pathtoken_1+1
    sbc #0
    sta.z fopen__28+1
    // while (*(pathtoken - 1))
    // [855] if(0!=*fopen::$28) goto fopen::@8 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (fopen__28),y
    cmp #0
    bne __b8
    // fopen::@26
    // __status = 0
    // [856] ((char *)&__stdio_file+$8c)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    tya
    ldy sp
    sta __stdio_file+$8c,y
    // if(!__logical)
    // [857] if(0!=((char *)&__stdio_file+$80)[fopen::sp#0]) goto fopen::@1 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+$80,y
    cmp #0
    bne __b1
    // fopen::@27
    // __stdio_filecount+1
    // [858] fopen::$4 = __stdio_filecount + 1 -- vbum1=vbum2_plus_1 
    lda __stdio_filecount
    inc
    sta fopen__4
    // __logical = __stdio_filecount+1
    // [859] ((char *)&__stdio_file+$80)[fopen::sp#0] = fopen::$4 -- pbuc1_derefidx_vbum1=vbum2 
    sta __stdio_file+$80,y
    // fopen::@1
  __b1:
    // if(!__device)
    // [860] if(0!=((char *)&__stdio_file+$84)[fopen::sp#0]) goto fopen::@2 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sp
    lda __stdio_file+$84,y
    cmp #0
    bne __b2
    // fopen::@5
    // __device = 8
    // [861] ((char *)&__stdio_file+$84)[fopen::sp#0] = 8 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #8
    sta __stdio_file+$84,y
    // fopen::@2
  __b2:
    // if(!__channel)
    // [862] if(0!=((char *)&__stdio_file+$88)[fopen::sp#0]) goto fopen::@3 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sp
    lda __stdio_file+$88,y
    cmp #0
    bne __b3
    // fopen::@6
    // __stdio_filecount+2
    // [863] fopen::$9 = __stdio_filecount + 2 -- vbum1=vbum2_plus_2 
    lda __stdio_filecount
    clc
    adc #2
    sta fopen__9
    // __channel = __stdio_filecount+2
    // [864] ((char *)&__stdio_file+$88)[fopen::sp#0] = fopen::$9 -- pbuc1_derefidx_vbum1=vbum2 
    sta __stdio_file+$88,y
    // fopen::@3
  __b3:
    // __filename
    // [865] fopen::$11 = (char *)&__stdio_file + fopen::pathpos#0 -- pbuz1=pbuc1_plus_vbum2 
    lda pathpos
    clc
    adc #<__stdio_file
    sta.z fopen__11
    lda #>__stdio_file
    adc #0
    sta.z fopen__11+1
    // cbm_k_setnam(__filename)
    // [866] fopen::cbm_k_setnam1_filename = fopen::$11 -- pbuz1=pbuz2 
    lda.z fopen__11
    sta.z cbm_k_setnam1_filename
    lda.z fopen__11+1
    sta.z cbm_k_setnam1_filename+1
    // fopen::cbm_k_setnam1
    // strlen(filename)
    // [867] strlen::str#3 = fopen::cbm_k_setnam1_filename -- pbuz1=pbuz2 
    lda.z cbm_k_setnam1_filename
    sta.z strlen.str
    lda.z cbm_k_setnam1_filename+1
    sta.z strlen.str+1
    // [868] call strlen
    // [1217] phi from fopen::cbm_k_setnam1 to strlen [phi:fopen::cbm_k_setnam1->strlen]
    // [1217] phi strlen::str#7 = strlen::str#3 [phi:fopen::cbm_k_setnam1->strlen#0] -- register_copy 
    jsr strlen
    // strlen(filename)
    // [869] strlen::return#4 = strlen::len#2
    // fopen::@31
    // [870] fopen::cbm_k_setnam1_$0 = strlen::return#4
    // char filename_len = (char)strlen(filename)
    // [871] fopen::cbm_k_setnam1_filename_len = (char)fopen::cbm_k_setnam1_$0 -- vbum1=_byte_vwum2 
    lda cbm_k_setnam1_fopen__0
    sta cbm_k_setnam1_filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx cbm_k_setnam1_filename
    ldy cbm_k_setnam1_filename+1
    jsr CBM_SETNAM
    // fopen::@28
    // cbm_k_setlfs(__logical, __device, __channel)
    // [873] cbm_k_setlfs::channel = ((char *)&__stdio_file+$80)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+$80,y
    sta cbm_k_setlfs.channel
    // [874] cbm_k_setlfs::device = ((char *)&__stdio_file+$84)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda __stdio_file+$84,y
    sta cbm_k_setlfs.device
    // [875] cbm_k_setlfs::command = ((char *)&__stdio_file+$88)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda __stdio_file+$88,y
    sta cbm_k_setlfs.command
    // [876] call cbm_k_setlfs
    jsr cbm_k_setlfs
    // fopen::cbm_k_open1
    // asm
    // asm { jsrCBM_OPEN  }
    jsr CBM_OPEN
    // fopen::cbm_k_readst1
    // char status
    // [878] fopen::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [880] fopen::cbm_k_readst1_return#0 = fopen::cbm_k_readst1_status -- vbum1=vbum2 
    sta cbm_k_readst1_return
    // fopen::cbm_k_readst1_@return
    // }
    // [881] fopen::cbm_k_readst1_return#1 = fopen::cbm_k_readst1_return#0
    // fopen::@29
    // cbm_k_readst()
    // [882] fopen::$15 = fopen::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [883] ((char *)&__stdio_file+$8c)[fopen::sp#0] = fopen::$15 -- pbuc1_derefidx_vbum1=vbum2 
    lda fopen__15
    ldy sp
    sta __stdio_file+$8c,y
    // ferror(stream)
    // [884] ferror::stream#0 = (struct $2 *)fopen::stream#0
    // [885] call ferror
    jsr ferror
    // [886] ferror::return#0 = ferror::return#1
    // fopen::@32
    // [887] fopen::$16 = ferror::return#0
    // if (ferror(stream))
    // [888] if(0==fopen::$16) goto fopen::@4 -- 0_eq_vwsm1_then_la1 
    lda fopen__16
    ora fopen__16+1
    beq __b4
    // fopen::@7
    // cbm_k_close(__logical)
    // [889] fopen::cbm_k_close1_channel = ((char *)&__stdio_file+$80)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+$80,y
    sta cbm_k_close1_channel
    // fopen::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // [891] phi from fopen::cbm_k_close1 to fopen::@return [phi:fopen::cbm_k_close1->fopen::@return]
    // [891] phi fopen::return#2 = 0 [phi:fopen::cbm_k_close1->fopen::@return#0] -- pssz1=vbuc1 
    lda #<0
    sta.z return
    sta.z return+1
    // fopen::@return
    // }
    // [892] return 
    rts
    // fopen::@4
  __b4:
    // __stdio_filecount++;
    // [893] __stdio_filecount = ++ __stdio_filecount -- vbum1=_inc_vbum1 
    inc __stdio_filecount
    // [894] fopen::return#8 = (struct $2 *)fopen::stream#0
    // [891] phi from fopen::@4 to fopen::@return [phi:fopen::@4->fopen::@return]
    // [891] phi fopen::return#2 = fopen::return#8 [phi:fopen::@4->fopen::@return#0] -- register_copy 
    rts
    // fopen::@9
  __b9:
    // if (pathstep > 0)
    // [895] if(fopen::pathstep#10>0) goto fopen::@11 -- vbum1_gt_0_then_la1 
    lda pathstep
    bne __b11
    // fopen::@25
    // __stdio_file.filename[pathpos] = '\0'
    // [896] ((char *)&__stdio_file)[fopen::pathpos#10] = '@' -- pbuc1_derefidx_vbum1=vbuc2 
    lda #'@'
    ldy pathpos_1
    sta __stdio_file,y
    // path = pathtoken + 1
    // [897] fopen::path#0 = fopen::pathtoken#10 + 1 -- pbuz1=pbuz2_plus_1 
    clc
    lda.z pathtoken_1
    adc #1
    sta.z path
    lda.z pathtoken_1+1
    adc #0
    sta.z path+1
    // [898] phi from fopen::@16 fopen::@17 fopen::@18 fopen::@19 fopen::@25 to fopen::@12 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12]
    // [898] phi fopen::num#15 = fopen::num#2 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12#0] -- register_copy 
    // [898] phi fopen::path#13 = fopen::path#16 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12#1] -- register_copy 
    // fopen::@12
  __b12:
    // pathstep++;
    // [899] fopen::pathstep#1 = ++ fopen::pathstep#10 -- vbum1=_inc_vbum1 
    inc pathstep
    jmp __b10
    // fopen::@11
  __b11:
    // char pathcmp = *path
    // [900] fopen::pathcmp#0 = *fopen::path#10 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (path),y
    sta pathcmp
    // case 'D':
    // [901] if(fopen::pathcmp#0=='D') goto fopen::@13 -- vbum1_eq_vbuc1_then_la1 
    lda #'D'
    cmp pathcmp
    beq __b13
    // fopen::@20
    // case 'L':
    // [902] if(fopen::pathcmp#0=='L') goto fopen::@13 -- vbum1_eq_vbuc1_then_la1 
    lda #'L'
    cmp pathcmp
    beq __b13
    // fopen::@21
    // case 'C':
    //                     num = (char)atoi(path + 1);
    //                     path = pathtoken + 1;
    // [903] if(fopen::pathcmp#0=='C') goto fopen::@13 -- vbum1_eq_vbuc1_then_la1 
    lda #'C'
    cmp pathcmp
    beq __b13
    // [904] phi from fopen::@21 fopen::@30 to fopen::@14 [phi:fopen::@21/fopen::@30->fopen::@14]
    // [904] phi fopen::path#16 = fopen::path#10 [phi:fopen::@21/fopen::@30->fopen::@14#0] -- register_copy 
    // [904] phi fopen::num#2 = fopen::num#10 [phi:fopen::@21/fopen::@30->fopen::@14#1] -- register_copy 
    // fopen::@14
  __b14:
    // case 'L':
    //                     __logical = num;
    //                     break;
    // [905] if(fopen::pathcmp#0=='L') goto fopen::@17 -- vbum1_eq_vbuc1_then_la1 
    lda #'L'
    cmp pathcmp
    beq __b17
    // fopen::@15
    // case 'D':
    //                     __device = num;
    //                     break;
    // [906] if(fopen::pathcmp#0=='D') goto fopen::@18 -- vbum1_eq_vbuc1_then_la1 
    lda #'D'
    cmp pathcmp
    beq __b18
    // fopen::@16
    // case 'C':
    //                     __channel = num;
    //                     break;
    // [907] if(fopen::pathcmp#0!='C') goto fopen::@12 -- vbum1_neq_vbuc1_then_la1 
    lda #'C'
    cmp pathcmp
    bne __b12
    // fopen::@19
    // __channel = num
    // [908] ((char *)&__stdio_file+$88)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbum1=vbum2 
    lda num
    ldy sp
    sta __stdio_file+$88,y
    jmp __b12
    // fopen::@18
  __b18:
    // __device = num
    // [909] ((char *)&__stdio_file+$84)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbum1=vbum2 
    lda num
    ldy sp
    sta __stdio_file+$84,y
    jmp __b12
    // fopen::@17
  __b17:
    // __logical = num
    // [910] ((char *)&__stdio_file+$80)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbum1=vbum2 
    lda num
    ldy sp
    sta __stdio_file+$80,y
    jmp __b12
    // fopen::@13
  __b13:
    // atoi(path + 1)
    // [911] atoi::str#0 = fopen::path#10 + 1 -- pbuz1=pbuz1_plus_1 
    inc.z atoi.str
    bne !+
    inc.z atoi.str+1
  !:
    // [912] call atoi
    // [1277] phi from fopen::@13 to atoi [phi:fopen::@13->atoi]
    // [1277] phi atoi::str#2 = atoi::str#0 [phi:fopen::@13->atoi#0] -- register_copy 
    jsr atoi
    // atoi(path + 1)
    // [913] atoi::return#3 = atoi::return#2
    // fopen::@30
    // [914] fopen::$26 = atoi::return#3
    // num = (char)atoi(path + 1)
    // [915] fopen::num#1 = (char)fopen::$26 -- vbum1=_byte_vwsm2 
    lda fopen__26
    sta num
    // path = pathtoken + 1
    // [916] fopen::path#1 = fopen::pathtoken#10 + 1 -- pbuz1=pbuz2_plus_1 
    clc
    lda.z pathtoken_1
    adc #1
    sta.z path
    lda.z pathtoken_1+1
    adc #0
    sta.z path+1
    jmp __b14
  .segment Data
    fopen__4: .byte 0
    fopen__9: .byte 0
    .label fopen__15 = cbm_k_readst1_return
    .label fopen__16 = ferror.return
    .label fopen__26 = atoi.return
    fopen__30: .word 0
    cbm_k_setnam1_filename_len: .byte 0
    .label cbm_k_setnam1_fopen__0 = strlen.len
    cbm_k_readst1_status: .byte 0
    cbm_k_close1_channel: .byte 0
    sp: .byte 0
    pathpos: .byte 0
    pathpos_1: .byte 0
    pathcmp: .byte 0
    // Parse path
    pathstep: .byte 0
    num: .byte 0
    cbm_k_readst1_return: .byte 0
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
// __mem() unsigned int fgets(__zp($22) char *ptr, __mem() unsigned int size, __zp($24) struct $2 *stream)
fgets: {
    .label ptr = $22
    .label stream = $24
    // unsigned char sp = (unsigned char)stream
    // [918] fgets::sp#0 = (char)fgets::stream#4 -- vbum1=_byte_pssz2 
    lda.z stream
    sta sp
    // cbm_k_chkin(__logical)
    // [919] fgets::cbm_k_chkin1_channel = ((char *)&__stdio_file+$80)[fgets::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    tay
    lda __stdio_file+$80,y
    sta cbm_k_chkin1_channel
    // fgets::cbm_k_chkin1
    // char status
    // [920] fgets::cbm_k_chkin1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // fgets::cbm_k_readst1
    // char status
    // [922] fgets::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [924] fgets::cbm_k_readst1_return#0 = fgets::cbm_k_readst1_status -- vbum1=vbum2 
    sta cbm_k_readst1_return
    // fgets::cbm_k_readst1_@return
    // }
    // [925] fgets::cbm_k_readst1_return#1 = fgets::cbm_k_readst1_return#0
    // fgets::@11
    // cbm_k_readst()
    // [926] fgets::$1 = fgets::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [927] ((char *)&__stdio_file+$8c)[fgets::sp#0] = fgets::$1 -- pbuc1_derefidx_vbum1=vbum2 
    lda fgets__1
    ldy sp
    sta __stdio_file+$8c,y
    // if (__status)
    // [928] if(0==((char *)&__stdio_file+$8c)[fgets::sp#0]) goto fgets::@1 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+$8c,y
    cmp #0
    beq __b1
    // [929] phi from fgets::@11 fgets::@12 fgets::@5 to fgets::@return [phi:fgets::@11/fgets::@12/fgets::@5->fgets::@return]
  __b8:
    // [929] phi fgets::return#1 = 0 [phi:fgets::@11/fgets::@12/fgets::@5->fgets::@return#0] -- vwum1=vbuc1 
    lda #<0
    sta return
    sta return+1
    // fgets::@return
    // }
    // [930] return 
    rts
    // fgets::@1
  __b1:
    // [931] fgets::remaining#22 = fgets::size#10 -- vwum1=vwum2 
    lda size
    sta remaining
    lda size+1
    sta remaining+1
    // [932] phi from fgets::@1 to fgets::@2 [phi:fgets::@1->fgets::@2]
    // [932] phi fgets::read#10 = 0 [phi:fgets::@1->fgets::@2#0] -- vwum1=vwuc1 
    lda #<0
    sta read
    sta read+1
    // [932] phi fgets::remaining#11 = fgets::remaining#22 [phi:fgets::@1->fgets::@2#1] -- register_copy 
    // [932] phi fgets::ptr#11 = fgets::ptr#14 [phi:fgets::@1->fgets::@2#2] -- register_copy 
    // [932] phi from fgets::@17 fgets::@18 to fgets::@2 [phi:fgets::@17/fgets::@18->fgets::@2]
    // [932] phi fgets::read#10 = fgets::read#1 [phi:fgets::@17/fgets::@18->fgets::@2#0] -- register_copy 
    // [932] phi fgets::remaining#11 = fgets::remaining#1 [phi:fgets::@17/fgets::@18->fgets::@2#1] -- register_copy 
    // [932] phi fgets::ptr#11 = fgets::ptr#15 [phi:fgets::@17/fgets::@18->fgets::@2#2] -- register_copy 
    // fgets::@2
  __b2:
    // if (!size)
    // [933] if(0==fgets::size#10) goto fgets::@3 -- 0_eq_vwum1_then_la1 
    lda size
    ora size+1
    bne !__b3+
    jmp __b3
  !__b3:
    // fgets::@8
    // if (remaining >= 128)
    // [934] if(fgets::remaining#11>=$80) goto fgets::@4 -- vwum1_ge_vbuc1_then_la1 
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
    // [935] cx16_k_macptr::bytes = fgets::remaining#11 -- vbum1=vwum2 
    lda remaining
    sta cx16_k_macptr.bytes
    // [936] cx16_k_macptr::buffer = (void *)fgets::ptr#11 -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [937] call cx16_k_macptr
    jsr cx16_k_macptr
    // [938] cx16_k_macptr::return#4 = cx16_k_macptr::return#1
    // fgets::@15
  __b15:
    // bytes = cx16_k_macptr(remaining, ptr)
    // [939] fgets::bytes#3 = cx16_k_macptr::return#4
    // [940] phi from fgets::@13 fgets::@14 fgets::@15 to fgets::cbm_k_readst2 [phi:fgets::@13/fgets::@14/fgets::@15->fgets::cbm_k_readst2]
    // [940] phi fgets::bytes#10 = fgets::bytes#1 [phi:fgets::@13/fgets::@14/fgets::@15->fgets::cbm_k_readst2#0] -- register_copy 
    // fgets::cbm_k_readst2
    // char status
    // [941] fgets::cbm_k_readst2_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst2_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst2_status
    // return status;
    // [943] fgets::cbm_k_readst2_return#0 = fgets::cbm_k_readst2_status -- vbum1=vbum2 
    sta cbm_k_readst2_return
    // fgets::cbm_k_readst2_@return
    // }
    // [944] fgets::cbm_k_readst2_return#1 = fgets::cbm_k_readst2_return#0
    // fgets::@12
    // cbm_k_readst()
    // [945] fgets::$8 = fgets::cbm_k_readst2_return#1
    // __status = cbm_k_readst()
    // [946] ((char *)&__stdio_file+$8c)[fgets::sp#0] = fgets::$8 -- pbuc1_derefidx_vbum1=vbum2 
    lda fgets__8
    ldy sp
    sta __stdio_file+$8c,y
    // __status & 0xBF
    // [947] fgets::$9 = ((char *)&__stdio_file+$8c)[fgets::sp#0] & $bf -- vbum1=pbuc1_derefidx_vbum2_band_vbuc2 
    lda #$bf
    and __stdio_file+$8c,y
    sta fgets__9
    // if (__status & 0xBF)
    // [948] if(0==fgets::$9) goto fgets::@5 -- 0_eq_vbum1_then_la1 
    beq __b5
    jmp __b8
    // fgets::@5
  __b5:
    // if (bytes == 0xFFFF)
    // [949] if(fgets::bytes#10!=$ffff) goto fgets::@6 -- vwum1_neq_vwuc1_then_la1 
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
    // [950] fgets::read#1 = fgets::read#10 + fgets::bytes#10 -- vwum1=vwum1_plus_vwum2 
    clc
    lda read
    adc bytes
    sta read
    lda read+1
    adc bytes+1
    sta read+1
    // ptr += bytes
    // [951] fgets::ptr#0 = fgets::ptr#11 + fgets::bytes#10 -- pbuz1=pbuz1_plus_vwum2 
    clc
    lda.z ptr
    adc bytes
    sta.z ptr
    lda.z ptr+1
    adc bytes+1
    sta.z ptr+1
    // BYTE1(ptr)
    // [952] fgets::$13 = byte1  fgets::ptr#0 -- vbum1=_byte1_pbuz2 
    sta fgets__13
    // if (BYTE1(ptr) == 0xC0)
    // [953] if(fgets::$13!=$c0) goto fgets::@7 -- vbum1_neq_vbuc1_then_la1 
    lda #$c0
    cmp fgets__13
    bne __b7
    // fgets::@10
    // ptr -= 0x2000
    // [954] fgets::ptr#1 = fgets::ptr#0 - $2000 -- pbuz1=pbuz1_minus_vwuc1 
    lda.z ptr
    sec
    sbc #<$2000
    sta.z ptr
    lda.z ptr+1
    sbc #>$2000
    sta.z ptr+1
    // [955] phi from fgets::@10 fgets::@6 to fgets::@7 [phi:fgets::@10/fgets::@6->fgets::@7]
    // [955] phi fgets::ptr#15 = fgets::ptr#1 [phi:fgets::@10/fgets::@6->fgets::@7#0] -- register_copy 
    // fgets::@7
  __b7:
    // remaining -= bytes
    // [956] fgets::remaining#1 = fgets::remaining#11 - fgets::bytes#10 -- vwum1=vwum1_minus_vwum2 
    lda remaining
    sec
    sbc bytes
    sta remaining
    lda remaining+1
    sbc bytes+1
    sta remaining+1
    // while ((__status == 0) && ((size && remaining) || !size))
    // [957] if(((char *)&__stdio_file+$8c)[fgets::sp#0]==0) goto fgets::@16 -- pbuc1_derefidx_vbum1_eq_0_then_la1 
    ldy sp
    lda __stdio_file+$8c,y
    cmp #0
    beq __b16
    // [929] phi from fgets::@17 fgets::@7 to fgets::@return [phi:fgets::@17/fgets::@7->fgets::@return]
    // [929] phi fgets::return#1 = fgets::read#1 [phi:fgets::@17/fgets::@7->fgets::@return#0] -- register_copy 
    rts
    // fgets::@16
  __b16:
    // while ((__status == 0) && ((size && remaining) || !size))
    // [958] if(0==fgets::size#10) goto fgets::@17 -- 0_eq_vwum1_then_la1 
    lda size
    ora size+1
    beq __b17
    // fgets::@18
    // [959] if(0!=fgets::remaining#1) goto fgets::@2 -- 0_neq_vwum1_then_la1 
    lda remaining
    ora remaining+1
    beq !__b2+
    jmp __b2
  !__b2:
    // fgets::@17
  __b17:
    // [960] if(0==fgets::size#10) goto fgets::@2 -- 0_eq_vwum1_then_la1 
    lda size
    ora size+1
    bne !__b2+
    jmp __b2
  !__b2:
    rts
    // fgets::@4
  __b4:
    // cx16_k_macptr(128, ptr)
    // [961] cx16_k_macptr::bytes = $80 -- vbum1=vbuc1 
    lda #$80
    sta cx16_k_macptr.bytes
    // [962] cx16_k_macptr::buffer = (void *)fgets::ptr#11 -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [963] call cx16_k_macptr
    jsr cx16_k_macptr
    // [964] cx16_k_macptr::return#3 = cx16_k_macptr::return#1
    // fgets::@14
    // bytes = cx16_k_macptr(128, ptr)
    // [965] fgets::bytes#2 = cx16_k_macptr::return#3
    jmp __b15
    // fgets::@3
  __b3:
    // cx16_k_macptr(0, ptr)
    // [966] cx16_k_macptr::bytes = 0 -- vbum1=vbuc1 
    lda #0
    sta cx16_k_macptr.bytes
    // [967] cx16_k_macptr::buffer = (void *)fgets::ptr#11 -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [968] call cx16_k_macptr
    jsr cx16_k_macptr
    // [969] cx16_k_macptr::return#2 = cx16_k_macptr::return#1
    // fgets::@13
    // bytes = cx16_k_macptr(0, ptr)
    // [970] fgets::bytes#1 = cx16_k_macptr::return#2
    jmp __b15
  .segment Data
    .label fgets__1 = cbm_k_readst1_return
    .label fgets__8 = cbm_k_readst2_return
    fgets__9: .byte 0
    fgets__13: .byte 0
    cbm_k_chkin1_channel: .byte 0
    cbm_k_chkin1_status: .byte 0
    cbm_k_readst1_status: .byte 0
    cbm_k_readst2_status: .byte 0
    sp: .byte 0
    cbm_k_readst1_return: .byte 0
    .label return = read
    bytes: .word 0
    cbm_k_readst2_return: .byte 0
    read: .word 0
    remaining: .word 0
    size: .word 0
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
// __mem() int fclose(__zp($2d) struct $2 *stream)
fclose: {
    .label stream = $2d
    // unsigned char sp = (unsigned char)stream
    // [972] fclose::sp#0 = (char)fclose::stream#3 -- vbum1=_byte_pssz2 
    lda.z stream
    sta sp
    // cbm_k_chkin(__logical)
    // [973] fclose::cbm_k_chkin1_channel = ((char *)&__stdio_file+$80)[fclose::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    tay
    lda __stdio_file+$80,y
    sta cbm_k_chkin1_channel
    // fclose::cbm_k_chkin1
    // char status
    // [974] fclose::cbm_k_chkin1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // fclose::cbm_k_readst1
    // char status
    // [976] fclose::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [978] fclose::cbm_k_readst1_return#0 = fclose::cbm_k_readst1_status -- vbum1=vbum2 
    sta cbm_k_readst1_return
    // fclose::cbm_k_readst1_@return
    // }
    // [979] fclose::cbm_k_readst1_return#1 = fclose::cbm_k_readst1_return#0
    // fclose::@3
    // cbm_k_readst()
    // [980] fclose::$1 = fclose::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [981] ((char *)&__stdio_file+$8c)[fclose::sp#0] = fclose::$1 -- pbuc1_derefidx_vbum1=vbum2 
    lda fclose__1
    ldy sp
    sta __stdio_file+$8c,y
    // if (__status)
    // [982] if(0==((char *)&__stdio_file+$8c)[fclose::sp#0]) goto fclose::@1 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+$8c,y
    cmp #0
    beq __b1
    // [983] phi from fclose::@2 fclose::@3 to fclose::@return [phi:fclose::@2/fclose::@3->fclose::@return]
  __b3:
    // [983] phi fclose::return#1 = 0 [phi:fclose::@2/fclose::@3->fclose::@return#0] -- vwsm1=vbsc1 
    lda #<0
    sta return
    sta return+1
    // fclose::@return
    // }
    // [984] return 
    rts
    // fclose::@1
  __b1:
    // cbm_k_close(__logical)
    // [985] fclose::cbm_k_close1_channel = ((char *)&__stdio_file+$80)[fclose::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+$80,y
    sta cbm_k_close1_channel
    // fclose::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // fclose::cbm_k_readst2
    // char status
    // [987] fclose::cbm_k_readst2_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst2_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst2_status
    // return status;
    // [989] fclose::cbm_k_readst2_return#0 = fclose::cbm_k_readst2_status -- vbum1=vbum2 
    sta cbm_k_readst2_return
    // fclose::cbm_k_readst2_@return
    // }
    // [990] fclose::cbm_k_readst2_return#1 = fclose::cbm_k_readst2_return#0
    // fclose::@4
    // cbm_k_readst()
    // [991] fclose::$4 = fclose::cbm_k_readst2_return#1
    // __status = cbm_k_readst()
    // [992] ((char *)&__stdio_file+$8c)[fclose::sp#0] = fclose::$4 -- pbuc1_derefidx_vbum1=vbum2 
    lda fclose__4
    ldy sp
    sta __stdio_file+$8c,y
    // if (__status)
    // [993] if(0==((char *)&__stdio_file+$8c)[fclose::sp#0]) goto fclose::@2 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+$8c,y
    cmp #0
    beq __b2
    // [983] phi from fclose::@4 to fclose::@return [phi:fclose::@4->fclose::@return]
    // [983] phi fclose::return#1 = -1 [phi:fclose::@4->fclose::@return#0] -- vwsm1=vbsc1 
    lda #<-1
    sta return
    sta return+1
    rts
    // fclose::@2
  __b2:
    // __logical = 0
    // [994] ((char *)&__stdio_file+$80)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy sp
    sta __stdio_file+$80,y
    // __device = 0
    // [995] ((char *)&__stdio_file+$84)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+$84,y
    // __channel = 0
    // [996] ((char *)&__stdio_file+$88)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+$88,y
    // __filename
    // [997] fclose::$6 = fclose::sp#0 << 2 -- vbum1=vbum1_rol_2 
    lda fclose__6
    asl
    asl
    sta fclose__6
    // *__filename = '\0'
    // [998] ((char *)&__stdio_file)[fclose::$6] = '@' -- pbuc1_derefidx_vbum1=vbuc2 
    lda #'@'
    ldy fclose__6
    sta __stdio_file,y
    // __stdio_filecount--;
    // [999] __stdio_filecount = -- __stdio_filecount -- vbum1=_dec_vbum1 
    dec __stdio_filecount
    jmp __b3
  .segment Data
    .label fclose__1 = cbm_k_readst1_return
    .label fclose__4 = cbm_k_readst2_return
    .label fclose__6 = sp
    cbm_k_chkin1_channel: .byte 0
    cbm_k_chkin1_status: .byte 0
    cbm_k_readst1_status: .byte 0
    cbm_k_close1_channel: .byte 0
    cbm_k_readst2_status: .byte 0
    sp: .byte 0
    cbm_k_readst1_return: .byte 0
    cbm_k_readst2_return: .byte 0
    return: .word 0
}
.segment CodeEngineStages
  // stage_load_player
// void stage_load_player(__zp($48) struct $35 *stage_player)
// __bank(cx16_ram, 3) 
stage_load_player: {
    .label stage_engine = $44
    .label stage_bullet = $40
    .label stage_player = $48
    // sprite_index_t player_sprite = stage_player->player_sprite
    // [1000] stage_load_player::player_sprite#0 = *((char *)stage_load_player::stage_player#0) -- vbum1=_deref_pbuz2 
    // Loading the player sprites in bram.
    ldy #0
    lda (stage_player),y
    sta player_sprite
    // fe_sprite_bram_load(player_sprite, stage.sprite_offset)
    // [1001] fe_sprite_bram_load::sprite_index#0 = stage_load_player::player_sprite#0 -- vbum1=vbum2 
    sta fe_sprite_bram_load.sprite_index
    // [1002] fe_sprite_bram_load::sprite_offset#1 = *((unsigned int *)&stage+$25) -- vwum1=_deref_pwuc1 
    lda stage+$25
    sta fe_sprite_bram_load.sprite_offset
    lda stage+$25+1
    sta fe_sprite_bram_load.sprite_offset+1
    // [1003] call fe_sprite_bram_load
    // [1298] phi from stage_load_player to fe_sprite_bram_load [phi:stage_load_player->fe_sprite_bram_load]
    // [1298] phi __errno#107 = __errno#103 [phi:stage_load_player->fe_sprite_bram_load#0] -- register_copy 
    // [1298] phi fe_sprite_bram_load::sprite_offset#11 = fe_sprite_bram_load::sprite_offset#1 [phi:stage_load_player->fe_sprite_bram_load#1] -- register_copy 
    // [1298] phi fe_sprite_bram_load::sprite_index#10 = fe_sprite_bram_load::sprite_index#0 [phi:stage_load_player->fe_sprite_bram_load#2] -- register_copy 
    jsr fe_sprite_bram_load
    // fe_sprite_bram_load(player_sprite, stage.sprite_offset)
    // [1004] fe_sprite_bram_load::return#2 = fe_sprite_bram_load::return#0
    // stage_load_player::@1
    // [1005] stage_load_player::$0 = fe_sprite_bram_load::return#2 -- vwum1=vwum2 
    lda fe_sprite_bram_load.return
    sta stage_load_player__0
    lda fe_sprite_bram_load.return+1
    sta stage_load_player__0+1
    // stage.sprite_offset = fe_sprite_bram_load(player_sprite, stage.sprite_offset)
    // [1006] *((unsigned int *)&stage+$25) = stage_load_player::$0 -- _deref_pwuc1=vwum1 
    lda stage_load_player__0
    sta stage+$25
    lda stage_load_player__0+1
    sta stage+$25+1
    // stage_engine_t* stage_engine = stage_player->stage_engine
    // [1007] stage_load_player::stage_engine#0 = ((struct $33 **)stage_load_player::stage_player#0)[1] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #1
    lda (stage_player),y
    sta.z stage_engine
    iny
    lda (stage_player),y
    sta.z stage_engine+1
    // sprite_index_t engine_sprite = stage_engine->engine_sprite
    // [1008] stage_load_player::engine_sprite#0 = *((char *)stage_load_player::stage_engine#0) -- vbum1=_deref_pbuz2 
    ldy #0
    lda (stage_engine),y
    sta engine_sprite
    // fe_sprite_bram_load(engine_sprite, stage.sprite_offset)
    // [1009] fe_sprite_bram_load::sprite_index#1 = stage_load_player::engine_sprite#0 -- vbum1=vbum2 
    sta fe_sprite_bram_load.sprite_index
    // [1010] fe_sprite_bram_load::sprite_offset#2 = *((unsigned int *)&stage+$25) -- vwum1=_deref_pwuc1 
    lda stage+$25
    sta fe_sprite_bram_load.sprite_offset
    lda stage+$25+1
    sta fe_sprite_bram_load.sprite_offset+1
    // [1011] call fe_sprite_bram_load
    // [1298] phi from stage_load_player::@1 to fe_sprite_bram_load [phi:stage_load_player::@1->fe_sprite_bram_load]
    // [1298] phi __errno#107 = __errno#35 [phi:stage_load_player::@1->fe_sprite_bram_load#0] -- register_copy 
    // [1298] phi fe_sprite_bram_load::sprite_offset#11 = fe_sprite_bram_load::sprite_offset#2 [phi:stage_load_player::@1->fe_sprite_bram_load#1] -- register_copy 
    // [1298] phi fe_sprite_bram_load::sprite_index#10 = fe_sprite_bram_load::sprite_index#1 [phi:stage_load_player::@1->fe_sprite_bram_load#2] -- register_copy 
    jsr fe_sprite_bram_load
    // fe_sprite_bram_load(engine_sprite, stage.sprite_offset)
    // [1012] fe_sprite_bram_load::return#3 = fe_sprite_bram_load::return#0
    // stage_load_player::@2
    // [1013] stage_load_player::$1 = fe_sprite_bram_load::return#3 -- vwum1=vwum2 
    lda fe_sprite_bram_load.return
    sta stage_load_player__1
    lda fe_sprite_bram_load.return+1
    sta stage_load_player__1+1
    // stage.sprite_offset = fe_sprite_bram_load(engine_sprite, stage.sprite_offset)
    // [1014] *((unsigned int *)&stage+$25) = stage_load_player::$1 -- _deref_pwuc1=vwum1 
    lda stage_load_player__1
    sta stage+$25
    lda stage_load_player__1+1
    sta stage+$25+1
    // stage_bullet_t* stage_bullet = stage_player->stage_bullet
    // [1015] stage_load_player::stage_bullet#0 = ((struct $34 **)stage_load_player::stage_player#0)[3] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #3
    lda (stage_player),y
    sta.z stage_bullet
    iny
    lda (stage_player),y
    sta.z stage_bullet+1
    // sprite_index_t bullet_sprite = stage_bullet->bullet_sprite
    // [1016] stage_load_player::bullet_sprite#0 = *((char *)stage_load_player::stage_bullet#0) -- vbum1=_deref_pbuz2 
    ldy #0
    lda (stage_bullet),y
    sta bullet_sprite
    // fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [1017] fe_sprite_bram_load::sprite_index#2 = stage_load_player::bullet_sprite#0 -- vbum1=vbum2 
    sta fe_sprite_bram_load.sprite_index
    // [1018] fe_sprite_bram_load::sprite_offset#3 = *((unsigned int *)&stage+$25) -- vwum1=_deref_pwuc1 
    lda stage+$25
    sta fe_sprite_bram_load.sprite_offset
    lda stage+$25+1
    sta fe_sprite_bram_load.sprite_offset+1
    // [1019] call fe_sprite_bram_load
    // [1298] phi from stage_load_player::@2 to fe_sprite_bram_load [phi:stage_load_player::@2->fe_sprite_bram_load]
    // [1298] phi __errno#107 = __errno#35 [phi:stage_load_player::@2->fe_sprite_bram_load#0] -- register_copy 
    // [1298] phi fe_sprite_bram_load::sprite_offset#11 = fe_sprite_bram_load::sprite_offset#3 [phi:stage_load_player::@2->fe_sprite_bram_load#1] -- register_copy 
    // [1298] phi fe_sprite_bram_load::sprite_index#10 = fe_sprite_bram_load::sprite_index#2 [phi:stage_load_player::@2->fe_sprite_bram_load#2] -- register_copy 
    jsr fe_sprite_bram_load
    // fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [1020] fe_sprite_bram_load::return#4 = fe_sprite_bram_load::return#0
    // stage_load_player::@3
    // [1021] stage_load_player::$2 = fe_sprite_bram_load::return#4 -- vwum1=vwum2 
    lda fe_sprite_bram_load.return
    sta stage_load_player__2
    lda fe_sprite_bram_load.return+1
    sta stage_load_player__2+1
    // stage.sprite_offset = fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [1022] *((unsigned int *)&stage+$25) = stage_load_player::$2 -- _deref_pwuc1=vwum1 
    lda stage_load_player__2
    sta stage+$25
    lda stage_load_player__2+1
    sta stage+$25+1
    // stage_load_player::@return
    // }
    // [1023] return 
    rts
  .segment DataEngineStages
    stage_load_player__0: .word 0
    stage_load_player__1: .word 0
    stage_load_player__2: .word 0
    player_sprite: .byte 0
    engine_sprite: .byte 0
    bullet_sprite: .byte 0
}
.segment CodeEngineFlight
  // flight_add
// __mem() char flight_add(__mem() char type, char side, __mem() char sprite)
flight_add: {
    // unsigned char f = flight.index % FLIGHT_OBJECTS
    // [1025] flight_add::f#0 = *((char *)&flight+$ad5) & $40-1 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$40-1
    and flight+$ad5
    sta f
    // [1026] phi from flight_add flight_add::@3 to flight_add::@2 [phi:flight_add/flight_add::@3->flight_add::@2]
    // [1026] phi flight_add::f#2 = flight_add::f#0 [phi:flight_add/flight_add::@3->flight_add::@2#0] -- register_copy 
    // flight_add::@2
  __b2:
    // while (!f || flight.used[f])
    // [1027] if(0==flight_add::f#2) goto flight_add::@3 -- 0_eq_vbum1_then_la1 
    lda f
    bne !__b3+
    jmp __b3
  !__b3:
    // flight_add::@8
    // [1028] if(0!=((char *)&flight+$c0)[flight_add::f#2]) goto flight_add::@3 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    tay
    lda flight+$c0,y
    cmp #0
    beq !__b3+
    jmp __b3
  !__b3:
    // flight_add::@4
    // flight.index = f
    // [1029] *((char *)&flight+$ad5) = flight_add::f#2 -- _deref_pbuc1=vbum1 
    tya
    sta flight+$ad5
    // flight_index_t r = flight.root[type]
    // [1030] flight_add::r#0 = ((char *)&flight+$ac1)[flight_add::type#6] -- vbum1=pbuc1_derefidx_vbum2 
    // p.r = 3 => f[3].n = 2, f[2].n = 1, f[1].n = -
    //         => f[3].p = -, f[2].p = 3, f[1].p = 2
    // Add 4
    // p.r = 4 => f[4].n = 3, f[3].n = 2, f[2].n = 1, f[1].n = -
    // p.r = 4 => f[4].p = -, f[3].p = 4, f[2].p = 3, f[1].p = 2
    ldy type
    lda flight+$ac1,y
    sta r
    // flight.next[f] = r
    // [1031] ((char *)&flight+$a41)[flight_add::f#2] = flight_add::r#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy f
    sta flight+$a41,y
    // flight.prev[f] = NULL
    // [1032] ((char *)&flight+$a81)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta flight+$a81,y
    // if (r)
    // [1033] if(0==flight_add::r#0) goto flight_add::@1 -- 0_eq_vbum1_then_la1 
    lda r
    beq __b1
    // flight_add::@5
    // flight.prev[r] = f
    // [1034] ((char *)&flight+$a81)[flight_add::r#0] = flight_add::f#2 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy r
    sta flight+$a81,y
    // flight_add::@1
  __b1:
    // flight.root[type] = f
    // [1035] ((char *)&flight+$ac1)[flight_add::type#6] = flight_add::f#2 -- pbuc1_derefidx_vbum1=vbum2 
    lda f
    ldy type
    sta flight+$ac1,y
    // flight.count[type]++;
    // [1036] ((char *)&flight+$acb)[flight_add::type#6] = ++ ((char *)&flight+$acb)[flight_add::type#6] -- pbuc1_derefidx_vbum1=_inc_pbuc1_derefidx_vbum1 
    ldx type
    inc flight+$acb,x
    // flight.type[f] = type
    // [1037] ((char *)&flight+$180)[flight_add::f#2] = flight_add::type#6 -- pbuc1_derefidx_vbum1=vbum2 
    txa
    ldy f
    sta flight+$180,y
    // flight.side[f] = side
    // [1038] ((char *)&flight+$1c0)[flight_add::f#2] = 2 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #2
    sta flight+$1c0,y
    // flight.used[f] = 1
    // [1039] ((char *)&flight+$c0)[flight_add::f#2] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    sta flight+$c0,y
    // flight.enabled[f] = 0
    // [1040] ((char *)&flight+$100)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta flight+$100,y
    // flight.move[f] = 0
    // [1041] ((char *)&flight+$580)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$580,y
    // flight.moved[f] = 0
    // [1042] ((char *)&flight+$5c0)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$5c0,y
    // flight.moving[f] = 0
    // [1043] flight_add::$12 = flight_add::f#2 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta flight_add__12
    // [1044] ((unsigned int *)&flight+$600)[flight_add::$12] = 0 -- pwuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy flight_add__12
    sta flight+$600,y
    sta flight+$600+1,y
    // flight.angle[f] = 0
    // [1045] ((char *)&flight+$780)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    ldy f
    sta flight+$780,y
    // flight.speed[f] = 0
    // [1046] ((char *)&flight+$7c0)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$7c0,y
    // flight.action[f] = 0
    // [1047] ((char *)&flight+$940)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$940,y
    // flight.turn[f] = 0
    // [1048] ((char *)&flight+$800)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$800,y
    // flight.radius[f] = 0
    // [1049] ((char *)&flight+$840)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$840,y
    // flight.reload[f] = 0
    // [1050] ((char *)&flight+$740)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$740,y
    // flight.delay[f] = 0
    // [1051] ((char *)&flight+$680)[flight_add::f#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta flight+$680,y
    // unsigned char s = fe_sprite_cache_copy(sprite)
    // [1052] fe_sprite_cache_copy::sprite_index#0 = flight_add::sprite#6
    // [1053] call fe_sprite_cache_copy
    // [1404] phi from flight_add::@1 to fe_sprite_cache_copy [phi:flight_add::@1->fe_sprite_cache_copy]
    jsr fe_sprite_cache_copy
    // unsigned char s = fe_sprite_cache_copy(sprite)
    // [1054] fe_sprite_cache_copy::return#0 = fe_sprite_cache_copy::c#2
    // flight_add::@6
    // [1055] flight_add::s#0 = fe_sprite_cache_copy::return#0
    // flight.cache[f] = s
    // [1056] ((char *)&flight)[flight_add::f#2] = flight_add::s#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda s
    ldy f
    sta flight,y
    // flight_sprite_next_offset()
    // [1057] call flight_sprite_next_offset
    // [1450] phi from flight_add::@6 to flight_sprite_next_offset [phi:flight_add::@6->flight_sprite_next_offset]
    jsr flight_sprite_next_offset
    // flight_sprite_next_offset()
    // [1058] flight_sprite_next_offset::return#0 = flight_sprite_next_offset::vera_sprite_get_offset1_return#0 -- vwum1=vwum2 
    lda flight_sprite_next_offset.vera_sprite_get_offset1_return
    sta flight_sprite_next_offset.return
    lda flight_sprite_next_offset.vera_sprite_get_offset1_return+1
    sta flight_sprite_next_offset.return+1
    // flight_add::@7
    // [1059] flight_add::$4 = flight_sprite_next_offset::return#0
    // flight.sprite_offset[f] = flight_sprite_next_offset()
    // [1060] ((unsigned int *)&flight+$40)[flight_add::$12] = flight_add::$4 -- pwuc1_derefidx_vbum1=vwum2 
    ldy flight_add__12
    lda flight_add__4
    sta flight+$40,y
    lda flight_add__4+1
    sta flight+$40+1,y
    // fe_sprite_configure(flight.sprite_offset[f], s)
    // [1061] fe_sprite_configure::sprite_offset#0 = ((unsigned int *)&flight+$40)[flight_add::$12] -- vwum1=pwuc1_derefidx_vbum2 
    lda flight+$40,y
    sta fe_sprite_configure.sprite_offset
    lda flight+$40+1,y
    sta fe_sprite_configure.sprite_offset+1
    // [1062] fe_sprite_configure::s#0 = flight_add::s#0
    // [1063] call fe_sprite_configure
    jsr fe_sprite_configure
    // flight_add::@return
    // }
    // [1064] return 
    rts
    // flight_add::@3
  __b3:
    // f + 1
    // [1065] flight_add::$8 = flight_add::f#2 + 1 -- vbum1=vbum1_plus_1 
    inc flight_add__8
    // f = (f + 1) % FLIGHT_OBJECTS
    // [1066] flight_add::f#1 = flight_add::$8 & $40-1 -- vbum1=vbum1_band_vbuc1 
    lda #$40-1
    and f
    sta f
    jmp __b2
  .segment DataEngineFlight
    .label flight_add__4 = flight_sprite_next_offset.return
    .label flight_add__8 = f
    flight_add__12: .byte 0
    f: .byte 0
    r: .byte 0
    .label s = fe_sprite_cache_copy.c
    sprite: .byte 0
    .label return = f
    type: .byte 0
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
    // [1068] phi from ht_init to ht_init::memset_fast1 [phi:ht_init->ht_init::memset_fast1]
    // ht_init::memset_fast1
    // [1069] phi from ht_init::memset_fast1 to ht_init::memset_fast1_@1 [phi:ht_init::memset_fast1->ht_init::memset_fast1_@1]
    // [1069] phi ht_init::memset_fast1_num#2 = 0 [phi:ht_init::memset_fast1->ht_init::memset_fast1_@1#0] -- vbum1=vbuc1 
    lda #0
    sta memset_fast1_num
    // [1069] phi from ht_init::memset_fast1_@1 to ht_init::memset_fast1_@1 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast1_@1]
    // [1069] phi ht_init::memset_fast1_num#2 = ht_init::memset_fast1_num#1 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast1_@1#0] -- register_copy 
    // ht_init::memset_fast1_@1
  memset_fast1___b1:
    // *(destination+num) = c
    // [1070] ht_init::memset_fast1_destination#0[ht_init::memset_fast1_num#2] = ht_init::memset_fast1_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast1_c
    ldy memset_fast1_num
    sta memset_fast1_destination,y
    // num--;
    // [1071] ht_init::memset_fast1_num#1 = -- ht_init::memset_fast1_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast1_num
    // while(num)
    // [1072] if(0!=ht_init::memset_fast1_num#1) goto ht_init::memset_fast1_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast1_num
    bne memset_fast1___b1
    // [1073] phi from ht_init::memset_fast1_@1 to ht_init::memset_fast2 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast2]
    // ht_init::memset_fast2
    // [1074] phi from ht_init::memset_fast2 to ht_init::memset_fast2_@1 [phi:ht_init::memset_fast2->ht_init::memset_fast2_@1]
    // [1074] phi ht_init::memset_fast2_num#2 = 0 [phi:ht_init::memset_fast2->ht_init::memset_fast2_@1#0] -- vbum1=vbuc1 
    lda #0
    sta memset_fast2_num
    // [1074] phi from ht_init::memset_fast2_@1 to ht_init::memset_fast2_@1 [phi:ht_init::memset_fast2_@1->ht_init::memset_fast2_@1]
    // [1074] phi ht_init::memset_fast2_num#2 = ht_init::memset_fast2_num#1 [phi:ht_init::memset_fast2_@1->ht_init::memset_fast2_@1#0] -- register_copy 
    // ht_init::memset_fast2_@1
  memset_fast2___b1:
    // *(destination+num) = c
    // [1075] ht_init::memset_fast2_destination#0[ht_init::memset_fast2_num#2] = ht_init::memset_fast2_c#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #memset_fast2_c
    ldy memset_fast2_num
    sta memset_fast2_destination,y
    // num--;
    // [1076] ht_init::memset_fast2_num#1 = -- ht_init::memset_fast2_num#2 -- vbum1=_dec_vbum1 
    dec memset_fast2_num
    // while(num)
    // [1077] if(0!=ht_init::memset_fast2_num#1) goto ht_init::memset_fast2_@1 -- 0_neq_vbum1_then_la1 
    lda memset_fast2_num
    bne memset_fast2___b1
    // ht_init::@return
    // }
    // [1078] return 
    rts
  .segment Data
    memset_fast1_num: .byte 0
    memset_fast2_num: .byte 0
}
.segment CodeEngineFlight
  // flight_root
// __mem() char flight_root(char type)
flight_root: {
    // return flight.root[type];
    // [1079] flight_root::return#0 = *((char *)&flight+$ac1) -- vbum1=_deref_pbuc1 
    lda flight+$ac1
    sta return
    // flight_root::@return
    // }
    // [1080] return 
    rts
  .segment DataEngineFlight
    return: .byte 0
}
.segment CodeEngineFlight
  // flight_next
// __mem() char flight_next(__mem() char i)
flight_next: {
    // return flight.next[i];
    // [1081] flight_next::return#0 = ((char *)&flight+$a41)[flight_next::i#0] -- vbum1=pbuc1_derefidx_vbum1 
    ldy return
    lda flight+$a41,y
    sta return
    // flight_next::@return
    // }
    // [1082] return 
    rts
  .segment DataEngineFlight
    .label return = i
    i: .byte 0
}
.segment CodeEngineFlight
  // sprite_image_cache_vram
// __mem() unsigned int sprite_image_cache_vram(__mem() char sprite_cache_index, __mem() char fe_sprite_image_index)
sprite_image_cache_vram: {
    .const bank_push_set_bram1_bank = 4
    .label sprite_ptr = $36
    .label sprite_image_cache_vram__40 = $34
    // unsigned int image_index = sprite_cache.offset[sprite_cache_index] + fe_sprite_image_index
    // [1083] sprite_image_cache_vram::$37 = sprite_image_cache_vram::sprite_cache_index#0 << 1 -- vbum1=vbum1_rol_1 
    asl sprite_image_cache_vram__37
    // [1084] sprite_image_cache_vram::image_index#0 = ((unsigned int *)&sprite_cache+$30)[sprite_image_cache_vram::$37] + sprite_image_cache_vram::fe_sprite_image_index#0 -- vwum1=pwuc1_derefidx_vbum2_plus_vbum3 
    // check if the image in vram is in use where the fe_sprite_vram_image_index is pointing to.
    // if this vram_image_used is false, that means that the image in vram is not in use anymore (not displayed or destroyed).
    lda fe_sprite_image_index
    ldy sprite_image_cache_vram__37
    clc
    adc sprite_cache+$30,y
    sta image_index
    lda sprite_cache+$30+1,y
    adc #0
    sta image_index+1
    // lru_cache_index_t vram_index = lru_cache_index(image_index)
    // [1085] stackpush(unsigned int) = sprite_image_cache_vram::image_index#0 -- _stackpushword_=vwum1 
    // We check if there is a cache hit?
    pha
    lda image_index
    pha
    // [1086] callexecute lru_cache_index  -- call_stack_near 
    jsr lib_lru_cache.lru_cache_index
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // [1088] sprite_image_cache_vram::vram_index#0 = stackpull(char) -- vbum1=_stackpullbyte_ 
    pla
    sta vram_index
    // if (vram_index != 0xFF)
    // [1089] if(sprite_image_cache_vram::vram_index#0!=$ff) goto sprite_image_cache_vram::@1 -- vbum1_neq_vbuc1_then_la1 
    lda #$ff
    cmp vram_index
    beq !__b1+
    jmp __b1
  !__b1:
    // sprite_image_cache_vram::vera_display_set_border_color1
    // *VERA_CTRL &= 0b10000001
    // [1090] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [1091] *VERA_DC_BORDER = RED -- _deref_pbuc1=vbuc2 
    lda #RED
    sta VERA_DC_BORDER
    // sprite_image_cache_vram::@8
    // vera_heap_size_int_t vram_size_required = sprite_cache.size[sprite_cache_index]
    // [1092] sprite_image_cache_vram::vram_size_required#0 = ((unsigned int *)&sprite_cache+$50)[sprite_image_cache_vram::$37] -- vwum1=pwuc1_derefidx_vbum2 
    // The idea of this section is to free up lru_cache and/or vram memory until there is sufficient space available.
    // The size requested contains the required size to be allocated on vram.
    ldy sprite_image_cache_vram__37
    lda sprite_cache+$50,y
    sta vram_size_required
    lda sprite_cache+$50+1,y
    sta vram_size_required+1
    // bool vram_has_free = vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required)
    // [1093] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    // We check if the vram heap has sufficient memory available for the size requested.
    // We also check if the lru cache has sufficient elements left to contain the new sprite image.
    lda #1
    pha
    // [1094] stackpush(unsigned int) = sprite_image_cache_vram::vram_size_required#0 -- _stackpushword_=vwum1 
    lda vram_size_required+1
    pha
    lda vram_size_required
    pha
    // [1095] callexecute vera_heap_has_free  -- call_stack_near 
    jsr lib_veraheap.vera_heap_has_free
    // sideeffect stackpullpadding(2) -- _stackpullpadding_2 
    pla
    pla
    // [1097] sprite_image_cache_vram::vram_has_free#0 = stackpull(bool) -- vbom1=_stackpullbool_ 
    pla
    sta vram_has_free
    // bool lru_cache_max = lru_cache_is_max()
    // sideeffect stackpushpadding(1) -- _stackpushpadding_1 
    pha
    // [1099] callexecute lru_cache_is_max  -- call_stack_near 
    jsr lib_lru_cache.lru_cache_is_max
    // [1100] sprite_image_cache_vram::lru_cache_max#0 = stackpull(bool) -- vbom1=_stackpullbool_ 
    pla
    sta lru_cache_max
    // [1101] phi from sprite_image_cache_vram::@6 sprite_image_cache_vram::@8 to sprite_image_cache_vram::@3 [phi:sprite_image_cache_vram::@6/sprite_image_cache_vram::@8->sprite_image_cache_vram::@3]
  __b3:
    // [1101] phi sprite_image_cache_vram::lru_cache_max#2 = sprite_image_cache_vram::lru_cache_max#1 [phi:sprite_image_cache_vram::@6/sprite_image_cache_vram::@8->sprite_image_cache_vram::@3#0] -- register_copy 
    // [1101] phi sprite_image_cache_vram::vram_has_free#2 = sprite_image_cache_vram::vram_has_free#1 [phi:sprite_image_cache_vram::@6/sprite_image_cache_vram::@8->sprite_image_cache_vram::@3#1] -- register_copy 
  // Free up the lru_cache and vram memory until the requested size is available!
  // This ensures that vram has sufficient place to allocate the new sprite image.
    // sprite_image_cache_vram::@3
    // while (lru_cache_max || !vram_has_free)
    // [1102] if(sprite_image_cache_vram::lru_cache_max#2) goto sprite_image_cache_vram::@4 -- vbom1_then_la1 
    lda lru_cache_max
    cmp #0
    bne __b4
    // sprite_image_cache_vram::@12
    // [1103] if(sprite_image_cache_vram::vram_has_free#2) goto sprite_image_cache_vram::@5 -- vbom1_then_la1 
    lda vram_has_free
    cmp #0
    bne __b5
    // sprite_image_cache_vram::@4
  __b4:
    // lru_cache_key_t vram_last = lru_cache_find_last()
    // sideeffect stackpushpadding(2) -- _stackpushpadding_2 
    // If the cache is at it's maximum, before we can add a new element, we must remove the least used image.
    // We search for the least used image in vram.
    pha
    pha
    // [1105] callexecute lru_cache_find_last  -- call_stack_near 
    jsr lib_lru_cache.lru_cache_find_last
    // [1106] sprite_image_cache_vram::vram_last#0 = stackpull(unsigned int) -- vwum1=_stackpullword_ 
    pla
    sta vram_last
    pla
    sta vram_last+1
    // lru_cache_data_t vram_handle = lru_cache_delete(vram_last)
    // [1107] stackpush(unsigned int) = sprite_image_cache_vram::vram_last#0 -- _stackpushword_=vwum1 
    // We delete the least used image from the vram cache, and this function returns the stored vram handle obtained by the vram heap manager.
    pha
    lda vram_last
    pha
    // [1108] callexecute lru_cache_delete  -- call_stack_near 
    jsr lib_lru_cache.lru_cache_delete
    // [1109] sprite_image_cache_vram::vram_handle#0 = stackpull(unsigned int) -- vwum1=_stackpullword_ 
    pla
    sta vram_handle
    pla
    sta vram_handle+1
    // if (vram_handle == 0xFFFF)
    // [1110] if(sprite_image_cache_vram::vram_handle#0!=$ffff) goto sprite_image_cache_vram::@6 -- vwum1_neq_vwuc1_then_la1 
    cmp #>$ffff
    bne __b6
    lda vram_handle
    cmp #<$ffff
    // [1111] phi from sprite_image_cache_vram::@4 to sprite_image_cache_vram::@7 [phi:sprite_image_cache_vram::@4->sprite_image_cache_vram::@7]
    // sprite_image_cache_vram::@7
    // sprite_image_cache_vram::@6
  __b6:
    // BYTE0(vram_handle)
    // [1112] sprite_image_cache_vram::$12 = byte0  sprite_image_cache_vram::vram_handle#0 -- vbum1=_byte0_vwum2 
    lda vram_handle
    sta sprite_image_cache_vram__12
    // vera_heap_free(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [1113] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    // And we free the vram heap with the vram handle that we received.
    // But before we can free the heap, we must first convert back from the sprite offset to the vram address.
    // And then to a valid vram handle :-).
    lda #1
    pha
    // [1114] stackpush(char) = sprite_image_cache_vram::$12 -- _stackpushbyte_=vbum1 
    lda sprite_image_cache_vram__12
    pha
    // [1115] callexecute vera_heap_free  -- call_stack_near 
    jsr lib_veraheap.vera_heap_free
    // sideeffect stackpullpadding(2) -- _stackpullpadding_2 
    pla
    pla
    // vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required)
    // [1117] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    lda #1
    pha
    // [1118] stackpush(unsigned int) = sprite_image_cache_vram::vram_size_required#0 -- _stackpushword_=vwum1 
    lda vram_size_required+1
    pha
    lda vram_size_required
    pha
    // [1119] callexecute vera_heap_has_free  -- call_stack_near 
    jsr lib_veraheap.vera_heap_has_free
    // sideeffect stackpullpadding(2) -- _stackpullpadding_2 
    pla
    pla
    // vram_has_free = vera_heap_has_free(VERA_HEAP_SEGMENT_SPRITES, vram_size_required)
    // [1121] sprite_image_cache_vram::vram_has_free#1 = stackpull(bool) -- vbom1=_stackpullbool_ 
    pla
    sta vram_has_free
    // lru_cache_is_max()
    // sideeffect stackpushpadding(1) -- _stackpushpadding_1 
    pha
    // [1123] callexecute lru_cache_is_max  -- call_stack_near 
    jsr lib_lru_cache.lru_cache_is_max
    // lru_cache_max = lru_cache_is_max()
    // [1124] sprite_image_cache_vram::lru_cache_max#1 = stackpull(bool) -- vbom1=_stackpullbool_ 
    pla
    sta lru_cache_max
    jmp __b3
    // sprite_image_cache_vram::@5
  __b5:
    // vera_heap_index_t vram_handle = vera_heap_alloc(VERA_HEAP_SEGMENT_SPRITES, (unsigned long)sprite_cache.size[sprite_cache_index])
    // [1125] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
    // Dynamic allocation of sprites in vera vram.
    lda #1
    pha
    // [1126] stackpush(unsigned long) = (unsigned long)((unsigned int *)&sprite_cache+$50)[sprite_image_cache_vram::$37] -- _stackpushdword_=_dword_pwuc1_derefidx_vbum1 
    ldy sprite_image_cache_vram__37
    lda sprite_cache+$50+3,y
    pha
    lda sprite_cache+$50+2,y
    pha
    lda sprite_cache+$50+1,y
    pha
    lda sprite_cache+$50,y
    pha
    // [1127] callexecute vera_heap_alloc  -- call_stack_near 
    jsr lib_veraheap.vera_heap_alloc
    // sideeffect stackpullpadding(4) -- _stackpullpadding_4 
    pla
    pla
    pla
    pla
    // [1129] sprite_image_cache_vram::vram_handle1#0 = stackpull(char) -- vbum1=_stackpullbyte_ 
    pla
    sta vram_handle1
    // BYTE0(vram_handle)
    // [1130] sprite_image_cache_vram::$17 = byte0  sprite_image_cache_vram::vram_handle1#0 -- vbum1=_byte0_vbum2 
    sta sprite_image_cache_vram__17
    // vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [1131] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    lda #1
    pha
    // [1132] stackpush(char) = sprite_image_cache_vram::$17 -- _stackpushbyte_=vbum1 
    lda sprite_image_cache_vram__17
    pha
    // [1133] callexecute vera_heap_data_get_bank  -- call_stack_near 
    jsr lib_veraheap.vera_heap_data_get_bank
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // [1135] sprite_image_cache_vram::vram_bank#0 = stackpull(char) -- vbum1=_stackpullbyte_ 
    pla
    sta vram_bank
    // BYTE0(vram_handle)
    // [1136] sprite_image_cache_vram::$19 = byte0  sprite_image_cache_vram::vram_handle1#0 -- vbum1=_byte0_vbum2 
    lda vram_handle1
    sta sprite_image_cache_vram__19
    // vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [1137] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    lda #1
    pha
    // [1138] stackpush(char) = sprite_image_cache_vram::$19 -- _stackpushbyte_=vbum1 
    lda sprite_image_cache_vram__19
    pha
    // [1139] callexecute vera_heap_data_get_offset  -- call_stack_near 
    jsr lib_veraheap.vera_heap_data_get_offset
    // [1140] sprite_image_cache_vram::vram_offset#0 = stackpull(unsigned int) -- vwum1=_stackpullword_ 
    pla
    sta vram_offset
    pla
    sta vram_offset+1
    // sprite_image_cache_vram::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [1142] BRAM = sprite_image_cache_vram::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // sprite_image_cache_vram::@9
    // sprite_bram_handles_t handle_bram = sprite_bram_handles[image_index]
    // [1143] sprite_image_cache_vram::$40 = sprite_bram_handles + sprite_image_cache_vram::image_index#0 -- pbuz1=pbuc1_plus_vwum2 
    lda image_index
    clc
    adc #<sprite_bram_handles
    sta.z sprite_image_cache_vram__40
    lda image_index+1
    adc #>sprite_bram_handles
    sta.z sprite_image_cache_vram__40+1
    // [1144] sprite_image_cache_vram::handle_bram#0 = *sprite_image_cache_vram::$40 -- vbum1=_deref_pbuz2 
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
    // [1146] bram_heap_data_get_bank::s = 0 -- vbum1=vbuc1 
    tya
    sta lib_bramheap.bram_heap_data_get_bank.s
    // [1147] bram_heap_data_get_bank::index = sprite_image_cache_vram::handle_bram#0 -- vbum1=vbum2 
    lda handle_bram
    sta lib_bramheap.bram_heap_data_get_bank.index
    // [1148] callexecute bram_heap_data_get_bank  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_bank
    // [1149] sprite_image_cache_vram::sprite_bank#0 = bram_heap_data_get_bank::return -- vbum1=vbum2 
    lda lib_bramheap.bram_heap_data_get_bank.return
    sta sprite_bank
    // bram_ptr_t sprite_ptr = bram_heap_data_get_offset(0, handle_bram)
    // [1150] bram_heap_data_get_offset::s = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_bramheap.bram_heap_data_get_offset.s
    // [1151] bram_heap_data_get_offset::index = sprite_image_cache_vram::handle_bram#0 -- vbum1=vbum2 
    lda handle_bram
    sta lib_bramheap.bram_heap_data_get_offset.index
    // [1152] callexecute bram_heap_data_get_offset  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_offset
    // [1153] sprite_image_cache_vram::sprite_ptr#0 = bram_heap_data_get_offset::return -- pbuz1=pbuz2 
    lda.z lib_bramheap.bram_heap_data_get_offset.return
    sta.z sprite_ptr
    lda.z lib_bramheap.bram_heap_data_get_offset.return+1
    sta.z sprite_ptr+1
    // unsigned int sprite_size = sprite_cache.size[sprite_cache_index]
    // [1154] sprite_image_cache_vram::sprite_size#0 = ((unsigned int *)&sprite_cache+$50)[sprite_image_cache_vram::$37] -- vwum1=pwuc1_derefidx_vbum2 
    ldy sprite_image_cache_vram__37
    lda sprite_cache+$50,y
    sta sprite_size
    lda sprite_cache+$50+1,y
    sta sprite_size+1
    // memcpy_vram_bram(vram_bank, vram_offset, sprite_bank, sprite_ptr, sprite_size)
    // [1155] memcpy_vram_bram::dbank_vram#0 = sprite_image_cache_vram::vram_bank#0 -- vbum1=vbum2 
    lda vram_bank
    sta memcpy_vram_bram.dbank_vram
    // [1156] memcpy_vram_bram::doffset_vram#0 = sprite_image_cache_vram::vram_offset#0 -- vwum1=vwum2 
    lda vram_offset
    sta memcpy_vram_bram.doffset_vram
    lda vram_offset+1
    sta memcpy_vram_bram.doffset_vram+1
    // [1157] memcpy_vram_bram::sbank_bram#2 = sprite_image_cache_vram::sprite_bank#0 -- vbum1=vbum2 
    lda sprite_bank
    sta memcpy_vram_bram.sbank_bram
    // [1158] memcpy_vram_bram::sptr_bram#0 = sprite_image_cache_vram::sprite_ptr#0 -- pbuz1=pbuz2 
    lda.z sprite_ptr
    sta.z memcpy_vram_bram.sptr_bram
    lda.z sprite_ptr+1
    sta.z memcpy_vram_bram.sptr_bram+1
    // [1159] memcpy_vram_bram::num = sprite_image_cache_vram::sprite_size#0 -- vwum1=vwum2 
    lda sprite_size
    sta memcpy_vram_bram.num
    lda sprite_size+1
    sta memcpy_vram_bram.num+1
    // [1160] call memcpy_vram_bram
    // [1502] phi from sprite_image_cache_vram::@10 to memcpy_vram_bram [phi:sprite_image_cache_vram::@10->memcpy_vram_bram]
    jsr memcpy_vram_bram
    // sprite_image_cache_vram::vera_sprite_get_image_offset1
    // vera_sprite_image_offset sprite_image_offset = offset >> 5
    // [1161] sprite_image_cache_vram::vera_sprite_get_image_offset1_sprite_image_offset#0 = sprite_image_cache_vram::vram_offset#0 >> 5 -- vwum1=vwum2_ror_5 
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
    // [1162] sprite_image_cache_vram::vera_sprite_get_image_offset1_$2 = (unsigned int)sprite_image_cache_vram::vram_bank#0 -- vwum1=_word_vbum2 
    lda vram_bank
    sta vera_sprite_get_image_offset1_sprite_image_cache_vram__2
    lda #0
    sta vera_sprite_get_image_offset1_sprite_image_cache_vram__2+1
    // [1163] sprite_image_cache_vram::vera_sprite_get_image_offset1_$1 = sprite_image_cache_vram::vera_sprite_get_image_offset1_$2 << $b -- vwum1=vwum1_rol_vbuc1 
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
    // [1164] sprite_image_cache_vram::vera_sprite_get_image_offset1_return#0 = sprite_image_cache_vram::vera_sprite_get_image_offset1_sprite_image_offset#0 | sprite_image_cache_vram::vera_sprite_get_image_offset1_$1 -- vwum1=vwum2_bor_vwum3 
    lda vera_sprite_get_image_offset1_sprite_image_offset
    ora vera_sprite_get_image_offset1_sprite_image_cache_vram__1
    sta vera_sprite_get_image_offset1_return
    lda vera_sprite_get_image_offset1_sprite_image_offset+1
    ora vera_sprite_get_image_offset1_sprite_image_cache_vram__1+1
    sta vera_sprite_get_image_offset1_return+1
    // sprite_image_cache_vram::@11
    // vera_heap_set_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle, sprite_offset)
    // [1165] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    lda #1
    pha
    // [1166] stackpush(char) = sprite_image_cache_vram::vram_handle1#0 -- _stackpushbyte_=vbum1 
    lda vram_handle1
    pha
    // [1167] stackpush(unsigned int) = sprite_image_cache_vram::vera_sprite_get_image_offset1_return#0 -- _stackpushword_=vwum1 
    lda vera_sprite_get_image_offset1_return+1
    pha
    lda vera_sprite_get_image_offset1_return
    pha
    // [1168] callexecute vera_heap_set_image  -- call_stack_near 
    jsr lib_veraheap.vera_heap_set_image
    // sideeffect stackpullpadding(4) -- _stackpullpadding_4 
    pla
    pla
    pla
    pla
    // lru_cache_insert(image_index, (lru_cache_data_t)vram_handle)
    // [1170] stackpush(unsigned int) = sprite_image_cache_vram::image_index#0 -- _stackpushword_=vwum1 
    lda image_index+1
    pha
    lda image_index
    pha
    // [1171] stackpush(unsigned int) = (unsigned int)sprite_image_cache_vram::vram_handle1#0 -- _stackpushword_=_word_vbum1 
    lda #0
    pha
    lda vram_handle1
    pha
    // [1172] callexecute lru_cache_insert  -- call_stack_near 
    jsr lib_lru_cache.lru_cache_insert
    // sideeffect stackpullpadding(4) -- _stackpullpadding_4 
    pla
    pla
    pla
    pla
    // sprite_image_cache_vram::vera_display_set_border_color2
    // *VERA_CTRL &= 0b10000001
    // [1174] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [1175] *VERA_DC_BORDER = BLACK -- _deref_pbuc1=vbuc2 
    lda #BLACK
    sta VERA_DC_BORDER
    // [1176] phi from sprite_image_cache_vram::@1 sprite_image_cache_vram::vera_display_set_border_color2 to sprite_image_cache_vram::@2 [phi:sprite_image_cache_vram::@1/sprite_image_cache_vram::vera_display_set_border_color2->sprite_image_cache_vram::@2]
    // [1176] phi sprite_image_cache_vram::return#0 = sprite_image_cache_vram::sprite_offset#1 [phi:sprite_image_cache_vram::@1/sprite_image_cache_vram::vera_display_set_border_color2->sprite_image_cache_vram::@2#0] -- register_copy 
    // sprite_image_cache_vram::@2
    // sprite_image_cache_vram::@return
    // }
    // [1177] return 
    rts
    // sprite_image_cache_vram::@1
  __b1:
    // lru_cache_get(vram_index)
    // sideeffect stackpushpadding(1) -- _stackpushpadding_1 
    pha
    // [1179] stackpush(char) = sprite_image_cache_vram::vram_index#0 -- _stackpushbyte_=vbum1 
    lda vram_index
    pha
    // [1180] callexecute lru_cache_get  -- call_stack_near 
    jsr lib_lru_cache.lru_cache_get
    // [1181] sprite_image_cache_vram::$30 = stackpull(unsigned int) -- vwum1=_stackpullword_ 
    pla
    sta sprite_image_cache_vram__30
    pla
    sta sprite_image_cache_vram__30+1
    // vera_heap_index_t vram_handle = (vera_heap_index_t)lru_cache_get(vram_index)
    // [1182] sprite_image_cache_vram::vram_handle2#0 = (char)sprite_image_cache_vram::$30 -- vbum1=_byte_vwum2 
    // So we have a cache hit, so we can re-use the same image from the cache and we win time!
    lda sprite_image_cache_vram__30
    sta vram_handle2
    // BYTE0(vram_handle)
    // [1183] sprite_image_cache_vram::$31 = byte0  sprite_image_cache_vram::vram_handle2#0 -- vbum1=_byte0_vbum2 
    sta sprite_image_cache_vram__31
    // vram_bank_t vram_bank = vera_heap_data_get_bank(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [1184] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    // Now that we are sure that there is sufficient space in vram and on the cache, we allocate a new element.
    // Dynamic allocation of sprites in vera vram.
    lda #1
    pha
    // [1185] stackpush(char) = sprite_image_cache_vram::$31 -- _stackpushbyte_=vbum1 
    lda sprite_image_cache_vram__31
    pha
    // [1186] callexecute vera_heap_data_get_bank  -- call_stack_near 
    jsr lib_veraheap.vera_heap_data_get_bank
    // sideeffect stackpullpadding(2) -- _stackpullpadding_2 
    pla
    pla
    // BYTE0(vram_handle)
    // [1188] sprite_image_cache_vram::$33 = byte0  sprite_image_cache_vram::vram_handle2#0 -- vbum1=_byte0_vbum2 
    lda vram_handle2
    sta sprite_image_cache_vram__33
    // vram_offset_t vram_offset = vera_heap_data_get_offset(VERA_HEAP_SEGMENT_SPRITES, (vera_heap_index_t)BYTE0(vram_handle))
    // [1189] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    lda #1
    pha
    // [1190] stackpush(char) = sprite_image_cache_vram::$33 -- _stackpushbyte_=vbum1 
    lda sprite_image_cache_vram__33
    pha
    // [1191] callexecute vera_heap_data_get_offset  -- call_stack_near 
    jsr lib_veraheap.vera_heap_data_get_offset
    // sideeffect stackpullpadding(2) -- _stackpullpadding_2 
    pla
    pla
    // vera_heap_get_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle)
    // [1193] stackpush(char) = 1 -- _stackpushbyte_=vbuc1 
    lda #1
    pha
    // [1194] stackpush(char) = sprite_image_cache_vram::vram_handle2#0 -- _stackpushbyte_=vbum1 
    lda vram_handle2
    pha
    // [1195] callexecute vera_heap_get_image  -- call_stack_near 
    jsr lib_veraheap.vera_heap_get_image
    // sprite_offset = vera_heap_get_image(VERA_HEAP_SEGMENT_SPRITES, vram_handle)
    // [1196] sprite_image_cache_vram::sprite_offset#1 = stackpull(unsigned int) -- vwum1=_stackpullword_ 
    pla
    sta sprite_offset
    pla
    sta sprite_offset+1
    rts
  .segment DataEngineFlight
    sprite_image_cache_vram__12: .byte 0
    sprite_image_cache_vram__17: .byte 0
    sprite_image_cache_vram__19: .byte 0
    sprite_image_cache_vram__30: .word 0
    sprite_image_cache_vram__31: .byte 0
    sprite_image_cache_vram__33: .byte 0
    .label sprite_image_cache_vram__37 = sprite_cache_index
  .segment Data
    .label vera_sprite_get_image_offset1_sprite_image_cache_vram__1 = vera_sprite_get_image_offset1_sprite_image_cache_vram__2
    vera_sprite_get_image_offset1_sprite_image_cache_vram__2: .word 0
  .segment DataEngineFlight
    image_index: .word 0
    vram_index: .byte 0
    vram_handle2: .byte 0
    // lru_cache_data_t lru_cache_data;
    .label sprite_offset = return
    vram_size_required: .word 0
    vram_has_free: .byte 0
    lru_cache_max: .byte 0
    vram_last: .word 0
    vram_handle: .word 0
    vram_handle1: .byte 0
    vram_bank: .byte 0
    vram_offset: .word 0
    handle_bram: .byte 0
    sprite_bank: .byte 0
    sprite_size: .word 0
  .segment Data
    vera_sprite_get_image_offset1_sprite_image_offset: .word 0
    .label vera_sprite_get_image_offset1_return = return
  .segment DataEngineFlight
    return: .word 0
    sprite_cache_index: .byte 0
    .label fe_sprite_image_index = flight_draw.s
}
.segment Code
  // memcpy8_vram_vram
/**
 * @brief Copy a block of memory in VRAM from a source to a target destination.
 * This function is designed to copy maximum 255 bytes of memory in one step.
 * If more than 255 bytes need to be copied, use the memcpy_vram_vram function.
 *
 * @see memcpy_vram_vram
 *
 * @param dbank_vram Bank of the destination location in vram.
 * @param doffset_vram Offset of the destination location in vram.
 * @param sbank_vram Bank of the source location in vram.
 * @param soffset_vram Offset of the source location in vram.
 * @param num16 Specified the amount of bytes to be copied.
 */
// void memcpy8_vram_vram(__mem() char dbank_vram, __mem() unsigned int doffset_vram, __mem() char sbank_vram, __mem() unsigned int soffset_vram, __mem() char num8)
memcpy8_vram_vram: {
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1197] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(soffset_vram)
    // [1198] memcpy8_vram_vram::$0 = byte0  memcpy8_vram_vram::soffset_vram#0 -- vbum1=_byte0_vwum2 
    lda soffset_vram
    sta memcpy8_vram_vram__0
    // *VERA_ADDRX_L = BYTE0(soffset_vram)
    // [1199] *VERA_ADDRX_L = memcpy8_vram_vram::$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(soffset_vram)
    // [1200] memcpy8_vram_vram::$1 = byte1  memcpy8_vram_vram::soffset_vram#0 -- vbum1=_byte1_vwum2 
    lda soffset_vram+1
    sta memcpy8_vram_vram__1
    // *VERA_ADDRX_M = BYTE1(soffset_vram)
    // [1201] *VERA_ADDRX_M = memcpy8_vram_vram::$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // sbank_vram | VERA_INC_1
    // [1202] memcpy8_vram_vram::$2 = memcpy8_vram_vram::sbank_vram#0 | VERA_INC_1 -- vbum1=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora memcpy8_vram_vram__2
    sta memcpy8_vram_vram__2
    // *VERA_ADDRX_H = sbank_vram | VERA_INC_1
    // [1203] *VERA_ADDRX_H = memcpy8_vram_vram::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // *VERA_CTRL |= VERA_ADDRSEL
    // [1204] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [1205] memcpy8_vram_vram::$3 = byte0  memcpy8_vram_vram::doffset_vram#0 -- vbum1=_byte0_vwum2 
    lda doffset_vram
    sta memcpy8_vram_vram__3
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [1206] *VERA_ADDRX_L = memcpy8_vram_vram::$3 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [1207] memcpy8_vram_vram::$4 = byte1  memcpy8_vram_vram::doffset_vram#0 -- vbum1=_byte1_vwum2 
    lda doffset_vram+1
    sta memcpy8_vram_vram__4
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [1208] *VERA_ADDRX_M = memcpy8_vram_vram::$4 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // dbank_vram | VERA_INC_1
    // [1209] memcpy8_vram_vram::$5 = memcpy8_vram_vram::dbank_vram#0 | VERA_INC_1 -- vbum1=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora memcpy8_vram_vram__5
    sta memcpy8_vram_vram__5
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [1210] *VERA_ADDRX_H = memcpy8_vram_vram::$5 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // [1211] phi from memcpy8_vram_vram memcpy8_vram_vram::@2 to memcpy8_vram_vram::@1 [phi:memcpy8_vram_vram/memcpy8_vram_vram::@2->memcpy8_vram_vram::@1]
  __b1:
    // [1211] phi memcpy8_vram_vram::num8#2 = memcpy8_vram_vram::num8#1 [phi:memcpy8_vram_vram/memcpy8_vram_vram::@2->memcpy8_vram_vram::@1#0] -- register_copy 
  // the size is only a byte, this is the fastest loop!
    // memcpy8_vram_vram::@1
    // while (num8--)
    // [1212] memcpy8_vram_vram::num8#0 = -- memcpy8_vram_vram::num8#2 -- vbum1=_dec_vbum2 
    ldy num8_1
    dey
    sty num8
    // [1213] if(0!=memcpy8_vram_vram::num8#2) goto memcpy8_vram_vram::@2 -- 0_neq_vbum1_then_la1 
    lda num8_1
    bne __b2
    // memcpy8_vram_vram::@return
    // }
    // [1214] return 
    rts
    // memcpy8_vram_vram::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [1215] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // [1216] memcpy8_vram_vram::num8#6 = memcpy8_vram_vram::num8#0 -- vbum1=vbum2 
    lda num8
    sta num8_1
    jmp __b1
  .segment Data
    memcpy8_vram_vram__0: .byte 0
    memcpy8_vram_vram__1: .byte 0
    .label memcpy8_vram_vram__2 = sbank_vram
    memcpy8_vram_vram__3: .byte 0
    memcpy8_vram_vram__4: .byte 0
    .label memcpy8_vram_vram__5 = dbank_vram
    num8: .byte 0
    dbank_vram: .byte 0
    doffset_vram: .word 0
    sbank_vram: .byte 0
    soffset_vram: .word 0
    num8_1: .byte 0
}
.segment Code
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __mem() unsigned int strlen(__zp($24) char *str)
strlen: {
    .label str = $24
    // [1218] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [1218] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta len
    sta len+1
    // [1218] phi strlen::str#5 = strlen::str#7 [phi:strlen->strlen::@1#1] -- register_copy 
    // strlen::@1
  __b1:
    // while(*str)
    // [1219] if(0!=*strlen::str#5) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [1220] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [1221] strlen::len#1 = ++ strlen::len#2 -- vwum1=_inc_vwum1 
    inc len
    bne !+
    inc len+1
  !:
    // str++;
    // [1222] strlen::str#1 = ++ strlen::str#5 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [1218] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [1218] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [1218] phi strlen::str#5 = strlen::str#1 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label return = len
    len: .word 0
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
    // [1224] return 
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
// __mem() int ferror(__zp($2d) struct $2 *stream)
ferror: {
    .label cbm_k_setnam1_filename = $38
    .label stream = $2d
    .label errno_len = $33
    // unsigned char sp = (unsigned char)stream
    // [1225] ferror::sp#0 = (char)ferror::stream#0 -- vbum1=_byte_pssz2 
    lda.z stream
    sta sp
    // cbm_k_setlfs(15, 8, 15)
    // [1226] cbm_k_setlfs::channel = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_setlfs.channel
    // [1227] cbm_k_setlfs::device = 8 -- vbum1=vbuc1 
    lda #8
    sta cbm_k_setlfs.device
    // [1228] cbm_k_setlfs::command = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_setlfs.command
    // [1229] call cbm_k_setlfs
    jsr cbm_k_setlfs
    // ferror::@11
    // cbm_k_setnam("")
    // [1230] ferror::cbm_k_setnam1_filename = ferror::$18 -- pbuz1=pbuc1 
    lda #<ferror__18
    sta.z cbm_k_setnam1_filename
    lda #>ferror__18
    sta.z cbm_k_setnam1_filename+1
    // ferror::cbm_k_setnam1
    // strlen(filename)
    // [1231] strlen::str#4 = ferror::cbm_k_setnam1_filename -- pbuz1=pbuz2 
    lda.z cbm_k_setnam1_filename
    sta.z strlen.str
    lda.z cbm_k_setnam1_filename+1
    sta.z strlen.str+1
    // [1232] call strlen
    // [1217] phi from ferror::cbm_k_setnam1 to strlen [phi:ferror::cbm_k_setnam1->strlen]
    // [1217] phi strlen::str#7 = strlen::str#4 [phi:ferror::cbm_k_setnam1->strlen#0] -- register_copy 
    jsr strlen
    // strlen(filename)
    // [1233] strlen::return#10 = strlen::len#2
    // ferror::@12
    // [1234] ferror::cbm_k_setnam1_$0 = strlen::return#10
    // char filename_len = (char)strlen(filename)
    // [1235] ferror::cbm_k_setnam1_filename_len = (char)ferror::cbm_k_setnam1_$0 -- vbum1=_byte_vwum2 
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
    // [1238] ferror::cbm_k_chkin1_channel = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_chkin1_channel
    // ferror::cbm_k_chkin1
    // char status
    // [1239] ferror::cbm_k_chkin1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // ferror::cbm_k_chrin1
    // char ch
    // [1241] ferror::cbm_k_chrin1_ch = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chrin1_ch
    // asm
    // asm { jsrCBM_CHRIN stach  }
    jsr CBM_CHRIN
    sta cbm_k_chrin1_ch
    // return ch;
    // [1243] ferror::cbm_k_chrin1_return#0 = ferror::cbm_k_chrin1_ch -- vbum1=vbum2 
    sta cbm_k_chrin1_return
    // ferror::cbm_k_chrin1_@return
    // }
    // [1244] ferror::cbm_k_chrin1_return#1 = ferror::cbm_k_chrin1_return#0
    // ferror::@7
    // char ch = cbm_k_chrin()
    // [1245] ferror::ch#0 = ferror::cbm_k_chrin1_return#1
    // [1246] phi from ferror::@7 to ferror::cbm_k_readst1 [phi:ferror::@7->ferror::cbm_k_readst1]
    // [1246] phi __errno#103 = __errno#209 [phi:ferror::@7->ferror::cbm_k_readst1#0] -- register_copy 
    // [1246] phi ferror::errno_len#10 = 0 [phi:ferror::@7->ferror::cbm_k_readst1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z errno_len
    // [1246] phi ferror::ch#10 = ferror::ch#0 [phi:ferror::@7->ferror::cbm_k_readst1#2] -- register_copy 
    // [1246] phi ferror::errno_parsed#2 = 0 [phi:ferror::@7->ferror::cbm_k_readst1#3] -- vbum1=vbuc1 
    sta errno_parsed
    // ferror::cbm_k_readst1
  cbm_k_readst1:
    // char status
    // [1247] ferror::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [1249] ferror::cbm_k_readst1_return#0 = ferror::cbm_k_readst1_status -- vbum1=vbum2 
    sta cbm_k_readst1_return
    // ferror::cbm_k_readst1_@return
    // }
    // [1250] ferror::cbm_k_readst1_return#1 = ferror::cbm_k_readst1_return#0
    // ferror::@8
    // cbm_k_readst()
    // [1251] ferror::$6 = ferror::cbm_k_readst1_return#1
    // st = cbm_k_readst()
    // [1252] ferror::st#1 = ferror::$6
    // while (!(st = cbm_k_readst()))
    // [1253] if(0==ferror::st#1) goto ferror::@1 -- 0_eq_vbum1_then_la1 
    lda st
    beq __b1
    // ferror::@2
    // __status = st
    // [1254] ((char *)&__stdio_file+$8c)[ferror::sp#0] = ferror::st#1 -- pbuc1_derefidx_vbum1=vbum2 
    ldy sp
    sta __stdio_file+$8c,y
    // cbm_k_close(15)
    // [1255] ferror::cbm_k_close1_channel = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_close1_channel
    // ferror::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // ferror::@9
    // return __errno;
    // [1257] ferror::return#1 = __errno#103 -- vwsm1=vwsm2 
    lda __errno
    sta return
    lda __errno+1
    sta return+1
    // ferror::@return
    // }
    // [1258] return 
    rts
    // ferror::@1
  __b1:
    // if (!errno_parsed)
    // [1259] if(0!=ferror::errno_parsed#2) goto ferror::@3 -- 0_neq_vbum1_then_la1 
    lda errno_parsed
    bne __b3
    // ferror::@4
    // if (ch == ',')
    // [1260] if(ferror::ch#10!=',') goto ferror::@3 -- vbum1_neq_vbuc1_then_la1 
    lda #','
    cmp ch
    bne __b3
    // ferror::@5
    // errno_parsed++;
    // [1261] ferror::errno_parsed#1 = ++ ferror::errno_parsed#2 -- vbum1=_inc_vbum1 
    inc errno_parsed
    // strncpy(temp, __errno_error, errno_len+1)
    // [1262] strncpy::n#0 = ferror::errno_len#10 + 1 -- vwum1=vbuz2_plus_1 
    lda.z errno_len
    clc
    adc #1
    sta strncpy.n
    lda #0
    adc #0
    sta strncpy.n+1
    // [1263] call strncpy
    // [1549] phi from ferror::@5 to strncpy [phi:ferror::@5->strncpy]
    jsr strncpy
    // [1264] phi from ferror::@5 to ferror::@13 [phi:ferror::@5->ferror::@13]
    // ferror::@13
    // atoi(temp)
    // [1265] call atoi
    // [1277] phi from ferror::@13 to atoi [phi:ferror::@13->atoi]
    // [1277] phi atoi::str#2 = ferror::temp [phi:ferror::@13->atoi#0] -- pbuz1=pbuc1 
    lda #<temp
    sta.z atoi.str
    lda #>temp
    sta.z atoi.str+1
    jsr atoi
    // atoi(temp)
    // [1266] atoi::return#4 = atoi::return#2
    // ferror::@14
    // __errno = atoi(temp)
    // [1267] __errno#2 = atoi::return#4 -- vwsm1=vwsm2 
    lda atoi.return
    sta __errno
    lda atoi.return+1
    sta __errno+1
    // [1268] phi from ferror::@1 ferror::@14 ferror::@4 to ferror::@3 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3]
    // [1268] phi __errno#127 = __errno#103 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3#0] -- register_copy 
    // [1268] phi ferror::errno_parsed#11 = ferror::errno_parsed#2 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3#1] -- register_copy 
    // ferror::@3
  __b3:
    // __errno_error[errno_len] = ch
    // [1269] __errno_error[ferror::errno_len#10] = ferror::ch#10 -- pbuc1_derefidx_vbuz1=vbum2 
    lda ch
    ldy.z errno_len
    sta __errno_error,y
    // errno_len++;
    // [1270] ferror::errno_len#1 = ++ ferror::errno_len#10 -- vbuz1=_inc_vbuz1 
    inc.z errno_len
    // ferror::cbm_k_chrin2
    // char ch
    // [1271] ferror::cbm_k_chrin2_ch = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chrin2_ch
    // asm
    // asm { jsrCBM_CHRIN stach  }
    jsr CBM_CHRIN
    sta cbm_k_chrin2_ch
    // return ch;
    // [1273] ferror::cbm_k_chrin2_return#0 = ferror::cbm_k_chrin2_ch -- vbum1=vbum2 
    sta cbm_k_chrin2_return
    // ferror::cbm_k_chrin2_@return
    // }
    // [1274] ferror::cbm_k_chrin2_return#1 = ferror::cbm_k_chrin2_return#0
    // ferror::@10
    // cbm_k_chrin()
    // [1275] ferror::$15 = ferror::cbm_k_chrin2_return#1
    // ch = cbm_k_chrin()
    // [1276] ferror::ch#1 = ferror::$15
    // [1246] phi from ferror::@10 to ferror::cbm_k_readst1 [phi:ferror::@10->ferror::cbm_k_readst1]
    // [1246] phi __errno#103 = __errno#127 [phi:ferror::@10->ferror::cbm_k_readst1#0] -- register_copy 
    // [1246] phi ferror::errno_len#10 = ferror::errno_len#1 [phi:ferror::@10->ferror::cbm_k_readst1#1] -- register_copy 
    // [1246] phi ferror::ch#10 = ferror::ch#1 [phi:ferror::@10->ferror::cbm_k_readst1#2] -- register_copy 
    // [1246] phi ferror::errno_parsed#2 = ferror::errno_parsed#11 [phi:ferror::@10->ferror::cbm_k_readst1#3] -- register_copy 
    jmp cbm_k_readst1
  .segment Data
    temp: .fill 4, 0
    ferror__18: .text ""
    .byte 0
    .label ferror__6 = cbm_k_readst1_return
    .label ferror__15 = ch
    cbm_k_setnam1_filename_len: .byte 0
    .label cbm_k_setnam1_ferror__0 = strlen.len
    cbm_k_chkin1_channel: .byte 0
    cbm_k_chkin1_status: .byte 0
    cbm_k_chrin1_ch: .byte 0
    cbm_k_readst1_status: .byte 0
    cbm_k_close1_channel: .byte 0
    cbm_k_chrin2_ch: .byte 0
    return: .word 0
    sp: .byte 0
    .label cbm_k_chrin1_return = ch
    ch: .byte 0
    cbm_k_readst1_return: .byte 0
    .label st = cbm_k_readst1_return
    .label cbm_k_chrin2_return = ch
    errno_parsed: .byte 0
}
.segment Code
  // atoi
// Converts the string argument str to an integer.
// __mem() int atoi(__zp($26) const char *str)
atoi: {
    .label str = $26
    // if (str[i] == '-')
    // [1278] if(*atoi::str#2!='-') goto atoi::@3 -- _deref_pbuz1_neq_vbuc1_then_la1 
    ldy #0
    lda (str),y
    cmp #'-'
    bne __b2
    // [1279] phi from atoi to atoi::@2 [phi:atoi->atoi::@2]
    // atoi::@2
    // [1280] phi from atoi::@2 to atoi::@3 [phi:atoi::@2->atoi::@3]
    // [1280] phi atoi::negative#2 = 1 [phi:atoi::@2->atoi::@3#0] -- vbum1=vbuc1 
    lda #1
    sta negative
    // [1280] phi atoi::res#2 = 0 [phi:atoi::@2->atoi::@3#1] -- vwsm1=vwsc1 
    tya
    sta res
    sta res+1
    // [1280] phi atoi::i#4 = 1 [phi:atoi::@2->atoi::@3#2] -- vbum1=vbuc1 
    lda #1
    sta i
    jmp __b3
  // Iterate through all digits and update the result
    // [1280] phi from atoi to atoi::@3 [phi:atoi->atoi::@3]
  __b2:
    // [1280] phi atoi::negative#2 = 0 [phi:atoi->atoi::@3#0] -- vbum1=vbuc1 
    lda #0
    sta negative
    // [1280] phi atoi::res#2 = 0 [phi:atoi->atoi::@3#1] -- vwsm1=vwsc1 
    sta res
    sta res+1
    // [1280] phi atoi::i#4 = 0 [phi:atoi->atoi::@3#2] -- vbum1=vbuc1 
    sta i
    // atoi::@3
  __b3:
    // for (; str[i]>='0' && str[i]<='9'; ++i)
    // [1281] if(atoi::str#2[atoi::i#4]<'0') goto atoi::@5 -- pbuz1_derefidx_vbum2_lt_vbuc1_then_la1 
    ldy i
    lda (str),y
    cmp #'0'
    bcc __b5
    // atoi::@6
    // [1282] if(atoi::str#2[atoi::i#4]<='9') goto atoi::@4 -- pbuz1_derefidx_vbum2_le_vbuc1_then_la1 
    lda (str),y
    cmp #'9'
    bcc __b4
    beq __b4
    // atoi::@5
  __b5:
    // if(negative)
    // [1283] if(0!=atoi::negative#2) goto atoi::@1 -- 0_neq_vbum1_then_la1 
    // Return result with sign
    lda negative
    bne __b1
    // [1285] phi from atoi::@1 atoi::@5 to atoi::@return [phi:atoi::@1/atoi::@5->atoi::@return]
    // [1285] phi atoi::return#2 = atoi::return#0 [phi:atoi::@1/atoi::@5->atoi::@return#0] -- register_copy 
    rts
    // atoi::@1
  __b1:
    // return -res;
    // [1284] atoi::return#0 = - atoi::res#2 -- vwsm1=_neg_vwsm1 
    lda #0
    sec
    sbc return
    sta return
    lda #0
    sbc return+1
    sta return+1
    // atoi::@return
    // }
    // [1286] return 
    rts
    // atoi::@4
  __b4:
    // res * 10
    // [1287] atoi::$10 = atoi::res#2 << 2 -- vwsm1=vwsm2_rol_2 
    lda res
    asl
    sta atoi__10
    lda res+1
    rol
    sta atoi__10+1
    asl atoi__10
    rol atoi__10+1
    // [1288] atoi::$11 = atoi::$10 + atoi::res#2 -- vwsm1=vwsm2_plus_vwsm1 
    clc
    lda atoi__11
    adc atoi__10
    sta atoi__11
    lda atoi__11+1
    adc atoi__10+1
    sta atoi__11+1
    // [1289] atoi::$6 = atoi::$11 << 1 -- vwsm1=vwsm1_rol_1 
    asl atoi__6
    rol atoi__6+1
    // res * 10 + str[i]
    // [1290] atoi::$7 = atoi::$6 + atoi::str#2[atoi::i#4] -- vwsm1=vwsm1_plus_pbuz2_derefidx_vbum3 
    ldy i
    lda atoi__7
    clc
    adc (str),y
    sta atoi__7
    bcc !+
    inc atoi__7+1
  !:
    // res = res * 10 + str[i] - '0'
    // [1291] atoi::res#1 = atoi::$7 - '0' -- vwsm1=vwsm1_minus_vbuc1 
    lda res
    sec
    sbc #'0'
    sta res
    bcs !+
    dec res+1
  !:
    // for (; str[i]>='0' && str[i]<='9'; ++i)
    // [1292] atoi::i#2 = ++ atoi::i#4 -- vbum1=_inc_vbum1 
    inc i
    // [1280] phi from atoi::@4 to atoi::@3 [phi:atoi::@4->atoi::@3]
    // [1280] phi atoi::negative#2 = atoi::negative#2 [phi:atoi::@4->atoi::@3#0] -- register_copy 
    // [1280] phi atoi::res#2 = atoi::res#1 [phi:atoi::@4->atoi::@3#1] -- register_copy 
    // [1280] phi atoi::i#4 = atoi::i#2 [phi:atoi::@4->atoi::@3#2] -- register_copy 
    jmp __b3
  .segment Data
    .label atoi__6 = return
    .label atoi__7 = return
    .label res = return
    // Initialize sign as positive
    i: .byte 0
    return: .word 0
    // Initialize result
    negative: .byte 0
    atoi__10: .word 0
    .label atoi__11 = return
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
// __mem() unsigned int cx16_k_macptr(__mem() volatile char bytes, __zp($2f) void * volatile buffer)
cx16_k_macptr: {
    .label buffer = $2f
    // unsigned int bytes_read
    // [1293] cx16_k_macptr::bytes_read = 0 -- vwum1=vwuc1 
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
    // [1295] cx16_k_macptr::return#0 = cx16_k_macptr::bytes_read -- vwum1=vwum2 
    lda bytes_read
    sta return
    lda bytes_read+1
    sta return+1
    // cx16_k_macptr::@return
    // }
    // [1296] cx16_k_macptr::return#1 = cx16_k_macptr::return#0
    // [1297] return 
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
    .label fp = $34
    .label palette_ptr = $36
    .label sprite_ptr = $42
    .label fe_sprite_bram_load__44 = $3a
    // fe_sprite_bram_load::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [1300] BRAM = fe_sprite_bram_load::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // fe_sprite_bram_load::@11
    // if (!sprites.loaded[sprite_index])
    // [1301] if(0!=((char *)&sprites+$40)[fe_sprite_bram_load::sprite_index#10]) goto fe_sprite_bram_load::bank_pull_bram1 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sprite_index
    lda sprites+$40,y
    cmp #0
    beq !bank_pull_bram1+
    jmp bank_pull_bram1
  !bank_pull_bram1:
    // fe_sprite_bram_load::@1
    // strcpy(filename, sprites.file[sprite_index])
    // [1302] fe_sprite_bram_load::$36 = fe_sprite_bram_load::sprite_index#10 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta fe_sprite_bram_load__36
    // [1303] strcpy::source#1 = ((char **)&sprites)[fe_sprite_bram_load::$36] -- pbuz1=qbuc1_derefidx_vbum2 
    tay
    lda sprites,y
    sta.z strcpy.source
    lda sprites+1,y
    sta.z strcpy.source+1
    // [1304] call strcpy
    // [1560] phi from fe_sprite_bram_load::@1 to strcpy [phi:fe_sprite_bram_load::@1->strcpy]
    // [1560] phi strcpy::dst#0 = fe_sprite_bram_load::filename [phi:fe_sprite_bram_load::@1->strcpy#0] -- pbuz1=pbuc1 
    lda #<filename
    sta.z strcpy.dst
    lda #>filename
    sta.z strcpy.dst+1
    // [1560] phi strcpy::src#0 = strcpy::source#1 [phi:fe_sprite_bram_load::@1->strcpy#1] -- register_copy 
    jsr strcpy
    // [1305] phi from fe_sprite_bram_load::@1 to fe_sprite_bram_load::@16 [phi:fe_sprite_bram_load::@1->fe_sprite_bram_load::@16]
    // fe_sprite_bram_load::@16
    // strcat(filename, ".bin")
    // [1306] call strcat
    // [1568] phi from fe_sprite_bram_load::@16 to strcat [phi:fe_sprite_bram_load::@16->strcat]
    jsr strcat
    // [1307] phi from fe_sprite_bram_load::@16 to fe_sprite_bram_load::@17 [phi:fe_sprite_bram_load::@16->fe_sprite_bram_load::@17]
    // fe_sprite_bram_load::@17
    // FILE *fp = fopen(filename, "r")
    // [1308] call fopen
    // [836] phi from fe_sprite_bram_load::@17 to fopen [phi:fe_sprite_bram_load::@17->fopen]
    // [836] phi __errno#209 = __errno#107 [phi:fe_sprite_bram_load::@17->fopen#0] -- register_copy 
    // [836] phi fopen::pathtoken#0 = fe_sprite_bram_load::filename [phi:fe_sprite_bram_load::@17->fopen#1] -- pbuz1=pbuc1 
    lda #<filename
    sta.z fopen.pathtoken
    lda #>filename
    sta.z fopen.pathtoken+1
    jsr fopen
    // FILE *fp = fopen(filename, "r")
    // [1309] fopen::return#4 = fopen::return#2
    // fe_sprite_bram_load::@18
    // [1310] fe_sprite_bram_load::fp#0 = fopen::return#4 -- pssz1=pssz2 
    lda.z fopen.return
    sta.z fp
    lda.z fopen.return+1
    sta.z fp+1
    // if (!fp)
    // [1311] if((struct $2 *)0==fe_sprite_bram_load::fp#0) goto fe_sprite_bram_load::bank_pull_bram1 -- pssc1_eq_pssz1_then_la1 
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
    // [1312] *(&fe_sprite_bram_load::sprite_file_header) = memset(struct $19, SIZEOF_STRUCT_$19) -- _deref_pssc1=_memset_vbuc2 
    ldy #SIZEOF_STRUCT___19
    lda #0
  !:
    dey
    sta sprite_file_header,y
    bne !-
    // unsigned int read = fgets((char *)&sprite_file_header, sizeof(sprite_file_header_t), fp)
    // [1313] fgets::stream#1 = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fgets.stream
    lda.z fp+1
    sta.z fgets.stream+1
    // [1314] call fgets
  // Read the header of the file into the sprite_file_header structure.
    // [917] phi from fe_sprite_bram_load::@2 to fgets [phi:fe_sprite_bram_load::@2->fgets]
    // [917] phi fgets::ptr#14 = (char *)&fe_sprite_bram_load::sprite_file_header [phi:fe_sprite_bram_load::@2->fgets#0] -- pbuz1=pbuc1 
    lda #<sprite_file_header
    sta.z fgets.ptr
    lda #>sprite_file_header
    sta.z fgets.ptr+1
    // [917] phi fgets::size#10 = $10 [phi:fe_sprite_bram_load::@2->fgets#1] -- vwum1=vbuc1 
    lda #<$10
    sta fgets.size
    lda #>$10
    sta fgets.size+1
    // [917] phi fgets::stream#4 = fgets::stream#1 [phi:fe_sprite_bram_load::@2->fgets#2] -- register_copy 
    jsr fgets
    // unsigned int read = fgets((char *)&sprite_file_header, sizeof(sprite_file_header_t), fp)
    // [1315] fgets::return#11 = fgets::return#1
    // fe_sprite_bram_load::@19
    // [1316] fe_sprite_bram_load::read#0 = fgets::return#11 -- vwum1=vwum2 
    lda fgets.return
    sta read
    lda fgets.return+1
    sta read+1
    // if (!read)
    // [1317] if(0==fe_sprite_bram_load::read#0) goto fe_sprite_bram_load::bank_pull_bram1 -- 0_eq_vwum1_then_la1 
    lda read
    ora read+1
    bne !bank_pull_bram1+
    jmp bank_pull_bram1
  !bank_pull_bram1:
    // fe_sprite_bram_load::@3
    // sprite_map_header(&sprite_file_header, sprite_index)
    // [1318] sprite_map_header::sprite#0 = fe_sprite_bram_load::sprite_index#10 -- vbum1=vbum2 
    lda sprite_index
    sta sprite_map_header.sprite
    // [1319] call sprite_map_header
    jsr sprite_map_header
    // fe_sprite_bram_load::@20
    // palette_index_t palette_index = palette_alloc_bram()
    // sideeffect stackpushpadding(1) -- _stackpushpadding_1 
    // BREAKPOINT
    // The palette data, which we load and index using the palette library.
    pha
    // [1321] callexecute palette_alloc_bram  -- call_stack_near 
    jsr lib_palette.palette_alloc_bram
    // [1322] fe_sprite_bram_load::palette_index#0 = stackpull(char) -- vbum1=_stackpullbyte_ 
    pla
    sta palette_index
    // palette_ptr_t palette_ptr = palette_ptr_bram(palette_index)
    // sideeffect stackpushpadding(1) -- _stackpushpadding_1 
    pha
    // [1324] stackpush(char) = fe_sprite_bram_load::palette_index#0 -- _stackpushbyte_=vbum1 
    pha
    // [1325] callexecute palette_ptr_bram  -- call_stack_near 
    jsr lib_palette.palette_ptr_bram
    // [1326] fe_sprite_bram_load::palette_ptr#0 = stackpull(struct $9 *) -- pssz1=_stackpullptr_ 
    pla
    sta.z palette_ptr
    pla
    sta.z palette_ptr+1
    // fe_sprite_bram_load::bank_push_set_bram2
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [1328] BRAM = fe_sprite_bram_load::bank_push_set_bram2_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram2_bank
    sta.z BRAM
    // fe_sprite_bram_load::@12
    // fgets((char *)palette_ptr, 32, fp)
    // [1329] fgets::ptr#4 = (char *)fe_sprite_bram_load::palette_ptr#0 -- pbuz1=pbuz2 
    lda.z palette_ptr
    sta.z fgets.ptr
    lda.z palette_ptr+1
    sta.z fgets.ptr+1
    // [1330] fgets::stream#2 = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fgets.stream
    lda.z fp+1
    sta.z fgets.stream+1
    // [1331] call fgets
    // [917] phi from fe_sprite_bram_load::@12 to fgets [phi:fe_sprite_bram_load::@12->fgets]
    // [917] phi fgets::ptr#14 = fgets::ptr#4 [phi:fe_sprite_bram_load::@12->fgets#0] -- register_copy 
    // [917] phi fgets::size#10 = $20 [phi:fe_sprite_bram_load::@12->fgets#1] -- vwum1=vbuc1 
    lda #<$20
    sta fgets.size
    lda #>$20
    sta fgets.size+1
    // [917] phi fgets::stream#4 = fgets::stream#2 [phi:fe_sprite_bram_load::@12->fgets#2] -- register_copy 
    jsr fgets
    // fe_sprite_bram_load::bank_pull_bram2
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_bram_load::@13
    // sprites.PaletteOffset[sprite_index] = palette_index
    // [1333] ((char *)&sprites+$180)[fe_sprite_bram_load::sprite_index#10] = fe_sprite_bram_load::palette_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda palette_index
    ldy sprite_index
    sta sprites+$180,y
    // sprites.offset[sprite_index] = sprite_offset
    // [1334] ((unsigned int *)&sprites+$240)[fe_sprite_bram_load::$36] = fe_sprite_bram_load::sprite_offset#11 -- pwuc1_derefidx_vbum1=vwum2 
    ldy fe_sprite_bram_load__36
    lda sprite_offset
    sta sprites+$240,y
    lda sprite_offset+1
    sta sprites+$240+1,y
    // unsigned int sprite_size = sprites.SpriteSize[sprite_index]
    // [1335] fe_sprite_bram_load::sprite_size#0 = ((unsigned int *)&sprites+$80)[fe_sprite_bram_load::$36] -- vwum1=pwuc1_derefidx_vbum2 
    lda sprites+$80,y
    sta sprite_size
    lda sprites+$80+1,y
    sta sprite_size+1
    // [1336] phi from fe_sprite_bram_load::@13 to fe_sprite_bram_load::@4 [phi:fe_sprite_bram_load::@13->fe_sprite_bram_load::@4]
    // [1336] phi fe_sprite_bram_load::sprite_offset#10 = fe_sprite_bram_load::sprite_offset#11 [phi:fe_sprite_bram_load::@13->fe_sprite_bram_load::@4#0] -- register_copy 
    // [1336] phi fe_sprite_bram_load::s#13 = 0 [phi:fe_sprite_bram_load::@13->fe_sprite_bram_load::@4#1] -- vbum1=vbuc1 
    lda #0
    sta s
    // fe_sprite_bram_load::@4
  __b4:
    // for (unsigned char s = 0; s < sprites.count[sprite_index]; s++)
    // [1337] if(fe_sprite_bram_load::s#13<((char *)&sprites+$60)[fe_sprite_bram_load::sprite_index#10]) goto fe_sprite_bram_load::@5 -- vbum1_lt_pbuc1_derefidx_vbum2_then_la1 
    lda s
    ldy sprite_index
    cmp sprites+$60,y
    bcc __b5
    // fe_sprite_bram_load::@6
    // fclose(fp)
    // [1338] fclose::stream#2 = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fclose.stream
    lda.z fp+1
    sta.z fclose.stream+1
    // [1339] call fclose
    // [971] phi from fe_sprite_bram_load::@6 to fclose [phi:fe_sprite_bram_load::@6->fclose]
    // [971] phi fclose::stream#3 = fclose::stream#2 [phi:fe_sprite_bram_load::@6->fclose#0] -- register_copy 
    jsr fclose
    // fclose(fp)
    // [1340] fclose::return#6 = fclose::return#1
    // fe_sprite_bram_load::@33
    // [1341] fe_sprite_bram_load::$33 = fclose::return#6 -- vwsm1=vwsm2 
    lda fclose.return
    sta fe_sprite_bram_load__33
    lda fclose.return+1
    sta fe_sprite_bram_load__33+1
    // if (fclose(fp))
    // [1342] if(0!=fe_sprite_bram_load::$33) goto fe_sprite_bram_load::bank_pull_bram1 -- 0_neq_vwsm1_then_la1 
    // Now we have read everything and we close the file.
    ora fe_sprite_bram_load__33
    bne bank_pull_bram1
    // fe_sprite_bram_load::@10
    // sprites.loaded[sprite_index] = 1
    // [1343] ((char *)&sprites+$40)[fe_sprite_bram_load::sprite_index#10] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    ldy sprite_index
    sta sprites+$40,y
    // [1344] phi from fe_sprite_bram_load::@10 fe_sprite_bram_load::@11 fe_sprite_bram_load::@18 fe_sprite_bram_load::@19 fe_sprite_bram_load::@33 to fe_sprite_bram_load::bank_pull_bram1 [phi:fe_sprite_bram_load::@10/fe_sprite_bram_load::@11/fe_sprite_bram_load::@18/fe_sprite_bram_load::@19/fe_sprite_bram_load::@33->fe_sprite_bram_load::bank_pull_bram1]
    // [1344] phi __errno#35 = __errno#103 [phi:fe_sprite_bram_load::@10/fe_sprite_bram_load::@11/fe_sprite_bram_load::@18/fe_sprite_bram_load::@19/fe_sprite_bram_load::@33->fe_sprite_bram_load::bank_pull_bram1#0] -- register_copy 
    // [1344] phi fe_sprite_bram_load::return#0 = fe_sprite_bram_load::sprite_offset#10 [phi:fe_sprite_bram_load::@10/fe_sprite_bram_load::@11/fe_sprite_bram_load::@18/fe_sprite_bram_load::@19/fe_sprite_bram_load::@33->fe_sprite_bram_load::bank_pull_bram1#1] -- register_copy 
    // fe_sprite_bram_load::bank_pull_bram1
  bank_pull_bram1:
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_bram_load::@return
    // }
    // [1346] return 
    rts
    // fe_sprite_bram_load::@5
  __b5:
    // bram_heap_handle_t handle_bram = bram_heap_alloc(0, sprite_size)
    // [1347] bram_heap_alloc::s = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_bramheap.bram_heap_alloc.s
    // [1348] bram_heap_alloc::size = fe_sprite_bram_load::sprite_size#0 -- vdum1=vwum2 
    lda sprite_size
    sta lib_bramheap.bram_heap_alloc.size
    lda sprite_size+1
    sta lib_bramheap.bram_heap_alloc.size+1
    lda #0
    sta lib_bramheap.bram_heap_alloc.size+2
    sta lib_bramheap.bram_heap_alloc.size+3
    // [1349] callexecute bram_heap_alloc  -- call_var_near 
    jsr lib_bramheap.bram_heap_alloc
    // [1350] fe_sprite_bram_load::handle_bram#0 = bram_heap_alloc::return -- vbum1=vbum2 
    lda lib_bramheap.bram_heap_alloc.return
    sta handle_bram
    // gotoxy(40,0)
    // [1351] call gotoxy
    // [288] phi from fe_sprite_bram_load::@5 to gotoxy [phi:fe_sprite_bram_load::@5->gotoxy]
    // [288] phi gotoxy::y#10 = 0 [phi:fe_sprite_bram_load::@5->gotoxy#0] -- vbum1=vbuc1 
    lda #0
    sta gotoxy.y
    // [288] phi gotoxy::x#6 = $28 [phi:fe_sprite_bram_load::@5->gotoxy#1] -- vbum1=vbuc1 
    lda #$28
    sta gotoxy.x
    jsr gotoxy
    // [1352] phi from fe_sprite_bram_load::@5 to fe_sprite_bram_load::@21 [phi:fe_sprite_bram_load::@5->fe_sprite_bram_load::@21]
    // fe_sprite_bram_load::@21
    // printf("handle_bram = %u\n", handle_bram)
    // [1353] call printf_str
    // [1635] phi from fe_sprite_bram_load::@21 to printf_str [phi:fe_sprite_bram_load::@21->printf_str]
    // [1635] phi printf_str::putc#9 = &cputc [phi:fe_sprite_bram_load::@21->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [1635] phi printf_str::s#9 = fe_sprite_bram_load::s1 [phi:fe_sprite_bram_load::@21->printf_str#1] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // fe_sprite_bram_load::@22
    // printf("handle_bram = %u\n", handle_bram)
    // [1354] printf_uchar::uvalue#0 = fe_sprite_bram_load::handle_bram#0 -- vbum1=vbum2 
    lda handle_bram
    sta printf_uchar.uvalue
    // [1355] call printf_uchar
    // [1644] phi from fe_sprite_bram_load::@22 to printf_uchar [phi:fe_sprite_bram_load::@22->printf_uchar]
    // [1644] phi printf_uchar::uvalue#2 = printf_uchar::uvalue#0 [phi:fe_sprite_bram_load::@22->printf_uchar#0] -- register_copy 
    jsr printf_uchar
    // [1356] phi from fe_sprite_bram_load::@22 to fe_sprite_bram_load::@23 [phi:fe_sprite_bram_load::@22->fe_sprite_bram_load::@23]
    // fe_sprite_bram_load::@23
    // printf("handle_bram = %u\n", handle_bram)
    // [1357] call printf_str
    // [1635] phi from fe_sprite_bram_load::@23 to printf_str [phi:fe_sprite_bram_load::@23->printf_str]
    // [1635] phi printf_str::putc#9 = &cputc [phi:fe_sprite_bram_load::@23->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [1635] phi printf_str::s#9 = fe_sprite_bram_load::s2 [phi:fe_sprite_bram_load::@23->printf_str#1] -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // fe_sprite_bram_load::@24
    // bram_bank_t sprite_bank = bram_heap_data_get_bank(0, handle_bram)
    // [1358] bram_heap_data_get_bank::s = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_bramheap.bram_heap_data_get_bank.s
    // [1359] bram_heap_data_get_bank::index = fe_sprite_bram_load::handle_bram#0 -- vbum1=vbum2 
    lda handle_bram
    sta lib_bramheap.bram_heap_data_get_bank.index
    // [1360] callexecute bram_heap_data_get_bank  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_bank
    // [1361] fe_sprite_bram_load::sprite_bank#0 = bram_heap_data_get_bank::return -- vbum1=vbum2 
    lda lib_bramheap.bram_heap_data_get_bank.return
    sta sprite_bank
    // gotoxy(40,1)
    // [1362] call gotoxy
    // [288] phi from fe_sprite_bram_load::@24 to gotoxy [phi:fe_sprite_bram_load::@24->gotoxy]
    // [288] phi gotoxy::y#10 = 1 [phi:fe_sprite_bram_load::@24->gotoxy#0] -- vbum1=vbuc1 
    lda #1
    sta gotoxy.y
    // [288] phi gotoxy::x#6 = $28 [phi:fe_sprite_bram_load::@24->gotoxy#1] -- vbum1=vbuc1 
    lda #$28
    sta gotoxy.x
    jsr gotoxy
    // [1363] phi from fe_sprite_bram_load::@24 to fe_sprite_bram_load::@25 [phi:fe_sprite_bram_load::@24->fe_sprite_bram_load::@25]
    // fe_sprite_bram_load::@25
    // printf("sprite_bank = %u\n", sprite_bank)
    // [1364] call printf_str
    // [1635] phi from fe_sprite_bram_load::@25 to printf_str [phi:fe_sprite_bram_load::@25->printf_str]
    // [1635] phi printf_str::putc#9 = &cputc [phi:fe_sprite_bram_load::@25->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [1635] phi printf_str::s#9 = fe_sprite_bram_load::s3 [phi:fe_sprite_bram_load::@25->printf_str#1] -- pbuz1=pbuc1 
    lda #<s3
    sta.z printf_str.s
    lda #>s3
    sta.z printf_str.s+1
    jsr printf_str
    // fe_sprite_bram_load::@26
    // printf("sprite_bank = %u\n", sprite_bank)
    // [1365] printf_uchar::uvalue#1 = fe_sprite_bram_load::sprite_bank#0 -- vbum1=vbum2 
    lda sprite_bank
    sta printf_uchar.uvalue
    // [1366] call printf_uchar
    // [1644] phi from fe_sprite_bram_load::@26 to printf_uchar [phi:fe_sprite_bram_load::@26->printf_uchar]
    // [1644] phi printf_uchar::uvalue#2 = printf_uchar::uvalue#1 [phi:fe_sprite_bram_load::@26->printf_uchar#0] -- register_copy 
    jsr printf_uchar
    // [1367] phi from fe_sprite_bram_load::@26 to fe_sprite_bram_load::@27 [phi:fe_sprite_bram_load::@26->fe_sprite_bram_load::@27]
    // fe_sprite_bram_load::@27
    // printf("sprite_bank = %u\n", sprite_bank)
    // [1368] call printf_str
    // [1635] phi from fe_sprite_bram_load::@27 to printf_str [phi:fe_sprite_bram_load::@27->printf_str]
    // [1635] phi printf_str::putc#9 = &cputc [phi:fe_sprite_bram_load::@27->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [1635] phi printf_str::s#9 = fe_sprite_bram_load::s2 [phi:fe_sprite_bram_load::@27->printf_str#1] -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // fe_sprite_bram_load::@28
    // bram_ptr_t sprite_ptr = bram_heap_data_get_offset(0, handle_bram)
    // [1369] bram_heap_data_get_offset::s = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_bramheap.bram_heap_data_get_offset.s
    // [1370] bram_heap_data_get_offset::index = fe_sprite_bram_load::handle_bram#0 -- vbum1=vbum2 
    lda handle_bram
    sta lib_bramheap.bram_heap_data_get_offset.index
    // [1371] callexecute bram_heap_data_get_offset  -- call_var_near 
    jsr lib_bramheap.bram_heap_data_get_offset
    // [1372] fe_sprite_bram_load::sprite_ptr#0 = bram_heap_data_get_offset::return -- pbuz1=pbuz2 
    lda.z lib_bramheap.bram_heap_data_get_offset.return
    sta.z sprite_ptr
    lda.z lib_bramheap.bram_heap_data_get_offset.return+1
    sta.z sprite_ptr+1
    // gotoxy(40,2)
    // [1373] call gotoxy
    // [288] phi from fe_sprite_bram_load::@28 to gotoxy [phi:fe_sprite_bram_load::@28->gotoxy]
    // [288] phi gotoxy::y#10 = 2 [phi:fe_sprite_bram_load::@28->gotoxy#0] -- vbum1=vbuc1 
    lda #2
    sta gotoxy.y
    // [288] phi gotoxy::x#6 = $28 [phi:fe_sprite_bram_load::@28->gotoxy#1] -- vbum1=vbuc1 
    lda #$28
    sta gotoxy.x
    jsr gotoxy
    // [1374] phi from fe_sprite_bram_load::@28 to fe_sprite_bram_load::@29 [phi:fe_sprite_bram_load::@28->fe_sprite_bram_load::@29]
    // fe_sprite_bram_load::@29
    // printf("sprite_ptr = %p\n", sprite_ptr)
    // [1375] call printf_str
    // [1635] phi from fe_sprite_bram_load::@29 to printf_str [phi:fe_sprite_bram_load::@29->printf_str]
    // [1635] phi printf_str::putc#9 = &cputc [phi:fe_sprite_bram_load::@29->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [1635] phi printf_str::s#9 = fe_sprite_bram_load::s5 [phi:fe_sprite_bram_load::@29->printf_str#1] -- pbuz1=pbuc1 
    lda #<s5
    sta.z printf_str.s
    lda #>s5
    sta.z printf_str.s+1
    jsr printf_str
    // fe_sprite_bram_load::@30
    // printf("sprite_ptr = %p\n", sprite_ptr)
    // [1376] printf_uint::uvalue#0 = (unsigned int)fe_sprite_bram_load::sprite_ptr#0 -- vwum1=vwuz2 
    lda.z sprite_ptr
    sta printf_uint.uvalue
    lda.z sprite_ptr+1
    sta printf_uint.uvalue+1
    // [1377] call printf_uint
    // [1651] phi from fe_sprite_bram_load::@30 to printf_uint [phi:fe_sprite_bram_load::@30->printf_uint]
    jsr printf_uint
    // [1378] phi from fe_sprite_bram_load::@30 to fe_sprite_bram_load::@31 [phi:fe_sprite_bram_load::@30->fe_sprite_bram_load::@31]
    // fe_sprite_bram_load::@31
    // printf("sprite_ptr = %p\n", sprite_ptr)
    // [1379] call printf_str
    // [1635] phi from fe_sprite_bram_load::@31 to printf_str [phi:fe_sprite_bram_load::@31->printf_str]
    // [1635] phi printf_str::putc#9 = &cputc [phi:fe_sprite_bram_load::@31->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [1635] phi printf_str::s#9 = fe_sprite_bram_load::s2 [phi:fe_sprite_bram_load::@31->printf_str#1] -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // fe_sprite_bram_load::@32
    // bram_heap_dump(0,0,2)
    // [1380] bram_heap_dump::s = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_bramheap.bram_heap_dump.s
    // [1381] bram_heap_dump::x = 0 -- vbum1=vbuc1 
    sta lib_bramheap.bram_heap_dump.x
    // [1382] bram_heap_dump::y = 2 -- vbum1=vbuc1 
    lda #2
    sta lib_bramheap.bram_heap_dump.y
    // [1383] callexecute bram_heap_dump  -- call_var_near 
    jsr lib_bramheap.bram_heap_dump
    // [1384] phi from fe_sprite_bram_load::@32 fe_sprite_bram_load::@34 to fe_sprite_bram_load::@7 [phi:fe_sprite_bram_load::@32/fe_sprite_bram_load::@34->fe_sprite_bram_load::@7]
  __b1:
  // bram_heap_dump_stats(0);
    // fe_sprite_bram_load::@7
    // kbhit()
    // [1385] call kbhit
    // [375] phi from fe_sprite_bram_load::@7 to kbhit [phi:fe_sprite_bram_load::@7->kbhit]
    jsr kbhit
    // kbhit()
    // [1386] kbhit::return#2 = kbhit::return#0
    // fe_sprite_bram_load::@34
    // [1387] fe_sprite_bram_load::$27 = kbhit::return#2 -- vbum1=vbum2 
    lda kbhit.return
    sta fe_sprite_bram_load__27
    // while(!kbhit())
    // [1388] if(0==fe_sprite_bram_load::$27) goto fe_sprite_bram_load::@7 -- 0_eq_vbum1_then_la1 
    beq __b1
    // fe_sprite_bram_load::bank_push_set_bram3
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [1390] BRAM = fe_sprite_bram_load::sprite_bank#0 -- vbuz1=vbum2 
    lda sprite_bank
    sta.z BRAM
    // fe_sprite_bram_load::@14
    // unsigned int read = fgets(sprite_ptr, sprite_size, fp)
    // [1391] fgets::ptr#5 = fe_sprite_bram_load::sprite_ptr#0 -- pbuz1=pbuz2 
    lda.z sprite_ptr
    sta.z fgets.ptr
    lda.z sprite_ptr+1
    sta.z fgets.ptr+1
    // [1392] fgets::size#3 = fe_sprite_bram_load::sprite_size#0 -- vwum1=vwum2 
    lda sprite_size
    sta fgets.size
    lda sprite_size+1
    sta fgets.size+1
    // [1393] fgets::stream#3 = fe_sprite_bram_load::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z fgets.stream
    lda.z fp+1
    sta.z fgets.stream+1
    // [1394] call fgets
    // [917] phi from fe_sprite_bram_load::@14 to fgets [phi:fe_sprite_bram_load::@14->fgets]
    // [917] phi fgets::ptr#14 = fgets::ptr#5 [phi:fe_sprite_bram_load::@14->fgets#0] -- register_copy 
    // [917] phi fgets::size#10 = fgets::size#3 [phi:fe_sprite_bram_load::@14->fgets#1] -- register_copy 
    // [917] phi fgets::stream#4 = fgets::stream#3 [phi:fe_sprite_bram_load::@14->fgets#2] -- register_copy 
    jsr fgets
    // unsigned int read = fgets(sprite_ptr, sprite_size, fp)
    // [1395] fgets::return#13 = fgets::return#1
    // fe_sprite_bram_load::@35
    // [1396] fe_sprite_bram_load::read1#0 = fgets::return#13 -- vwum1=vwum2 
    lda fgets.return
    sta read1
    lda fgets.return+1
    sta read1+1
    // fe_sprite_bram_load::bank_pull_bram3
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_bram_load::@15
    // if (!read)
    // [1398] if(0==fe_sprite_bram_load::read1#0) goto fe_sprite_bram_load::@9 -- 0_eq_vwum1_then_la1 
    lda read1
    ora read1+1
    beq __b9
    // fe_sprite_bram_load::@8
    // sprite_bram_handles[sprite_offset] = handle_bram
    // [1399] fe_sprite_bram_load::$44 = sprite_bram_handles + fe_sprite_bram_load::sprite_offset#10 -- pbuz1=pbuc1_plus_vwum2 
    lda sprite_offset
    clc
    adc #<sprite_bram_handles
    sta.z fe_sprite_bram_load__44
    lda sprite_offset+1
    adc #>sprite_bram_handles
    sta.z fe_sprite_bram_load__44+1
    // [1400] *fe_sprite_bram_load::$44 = fe_sprite_bram_load::handle_bram#0 -- _deref_pbuz1=vbum2 
    lda handle_bram
    ldy #0
    sta (fe_sprite_bram_load__44),y
    // sprite_offset++;
    // [1401] fe_sprite_bram_load::sprite_offset#0 = ++ fe_sprite_bram_load::sprite_offset#10 -- vwum1=_inc_vwum1 
    inc sprite_offset
    bne !+
    inc sprite_offset+1
  !:
    // [1402] phi from fe_sprite_bram_load::@15 fe_sprite_bram_load::@8 to fe_sprite_bram_load::@9 [phi:fe_sprite_bram_load::@15/fe_sprite_bram_load::@8->fe_sprite_bram_load::@9]
    // [1402] phi fe_sprite_bram_load::sprite_offset#30 = fe_sprite_bram_load::sprite_offset#10 [phi:fe_sprite_bram_load::@15/fe_sprite_bram_load::@8->fe_sprite_bram_load::@9#0] -- register_copy 
    // fe_sprite_bram_load::@9
  __b9:
    // for (unsigned char s = 0; s < sprites.count[sprite_index]; s++)
    // [1403] fe_sprite_bram_load::s#1 = ++ fe_sprite_bram_load::s#13 -- vbum1=_inc_vbum1 
    inc s
    // [1336] phi from fe_sprite_bram_load::@9 to fe_sprite_bram_load::@4 [phi:fe_sprite_bram_load::@9->fe_sprite_bram_load::@4]
    // [1336] phi fe_sprite_bram_load::sprite_offset#10 = fe_sprite_bram_load::sprite_offset#30 [phi:fe_sprite_bram_load::@9->fe_sprite_bram_load::@4#0] -- register_copy 
    // [1336] phi fe_sprite_bram_load::s#13 = fe_sprite_bram_load::s#1 [phi:fe_sprite_bram_load::@9->fe_sprite_bram_load::@4#1] -- register_copy 
    jmp __b4
  .segment DataEngineFlight
    filename: .fill $10, 0
  .encoding "petscii_mixed"
    source: .text ".bin"
    .byte 0
    s1: .text "handle_bram = "
    .byte 0
    s2: .text @"\n"
    .byte 0
    s3: .text "sprite_bank = "
    .byte 0
    s5: .text "sprite_ptr = "
    .byte 0
    sprite_file_header: .fill SIZEOF_STRUCT___19, 0
    fe_sprite_bram_load__27: .byte 0
    fe_sprite_bram_load__33: .word 0
    fe_sprite_bram_load__36: .byte 0
    return: .word 0
    read: .word 0
    palette_index: .byte 0
    sprite_size: .word 0
    handle_bram: .byte 0
    sprite_bank: .byte 0
    read1: .word 0
    .label sprite_offset = return
    s: .byte 0
    sprite_index: .byte 0
}
.segment CodeEngineFlight
  // fe_sprite_cache_copy
// todo, need to detach vram allocation from cache management.
// __mem() char fe_sprite_cache_copy(__mem() char sprite_index)
fe_sprite_cache_copy: {
    .const bank_push_set_bram1_bank = 4
    // fe_sprite_cache_copy::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [1406] BRAM = fe_sprite_cache_copy::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // fe_sprite_cache_copy::@7
    // unsigned char c = sprites.sprite_cache[sprite_index]
    // [1407] fe_sprite_cache_copy::c#0 = ((char *)&sprites+$2a0)[fe_sprite_cache_copy::sprite_index#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$2a0,y
    sta c
    // sprite_index_t cache_bram = (sprite_index_t)sprite_cache.sprite_bram[c]
    // [1408] fe_sprite_cache_copy::cache_bram#0 = ((char *)&sprite_cache+$10)[fe_sprite_cache_copy::c#0] -- vbum1=pbuc1_derefidx_vbum2 
    tay
    lda sprite_cache+$10,y
    sta cache_bram
    // if (cache_bram != sprite_index)
    // [1409] if(fe_sprite_cache_copy::cache_bram#0==fe_sprite_cache_copy::sprite_index#0) goto fe_sprite_cache_copy::@1 -- vbum1_eq_vbum2_then_la1 
    cmp sprite_index
    bne !__b1+
    jmp __b1
  !__b1:
    // fe_sprite_cache_copy::@2
    // if (sprite_cache.used[c])
    // [1410] if(0==((char *)&sprite_cache)[fe_sprite_cache_copy::c#0]) goto fe_sprite_cache_copy::@3 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda sprite_cache,y
    cmp #0
    beq __b3
    // fe_sprite_cache_copy::@4
  __b4:
    // while (sprite_cache.used[sprite_cache_pool])
    // [1411] if(0!=((char *)&sprite_cache)[sprite_cache_pool]) goto fe_sprite_cache_copy::@5 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sprite_cache_pool
    lda sprite_cache,y
    cmp #0
    beq !__b5+
    jmp __b5
  !__b5:
    // fe_sprite_cache_copy::@6
    // c = sprite_cache_pool
    // [1412] fe_sprite_cache_copy::c#1 = sprite_cache_pool -- vbum1=vbum2 
    tya
    sta c
    // [1413] phi from fe_sprite_cache_copy::@2 fe_sprite_cache_copy::@6 to fe_sprite_cache_copy::@3 [phi:fe_sprite_cache_copy::@2/fe_sprite_cache_copy::@6->fe_sprite_cache_copy::@3]
    // [1413] phi fe_sprite_cache_copy::c#5 = fe_sprite_cache_copy::c#0 [phi:fe_sprite_cache_copy::@2/fe_sprite_cache_copy::@6->fe_sprite_cache_copy::@3#0] -- register_copy 
    // fe_sprite_cache_copy::@3
  __b3:
    // unsigned char co = c * FE_CACHE
    // [1414] fe_sprite_cache_copy::co#0 = fe_sprite_cache_copy::c#5 << 4 -- vbum1=vbum2_rol_4 
    lda c
    asl
    asl
    asl
    asl
    sta co
    // sprites.sprite_cache[sprite_index] = c
    // [1415] ((char *)&sprites+$2a0)[fe_sprite_cache_copy::sprite_index#0] = fe_sprite_cache_copy::c#5 -- pbuc1_derefidx_vbum1=vbum2 
    lda c
    ldy sprite_index
    sta sprites+$2a0,y
    // sprite_cache.sprite_bram[c] = sprite_index
    // [1416] ((char *)&sprite_cache+$10)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::sprite_index#0 -- pbuc1_derefidx_vbum1=vbum2 
    tya
    ldy c
    sta sprite_cache+$10,y
    // sprite_cache.count[c] = sprites.count[sprite_index]
    // [1417] ((char *)&sprite_cache+$20)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$60)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    tay
    lda sprites+$60,y
    ldy c
    sta sprite_cache+$20,y
    // sprite_cache.offset[c] = sprites.offset[sprite_index]
    // [1418] fe_sprite_cache_copy::$19 = fe_sprite_cache_copy::sprite_index#0 << 1 -- vbum1=vbum2_rol_1 
    lda sprite_index
    asl
    sta fe_sprite_cache_copy__19
    // [1419] fe_sprite_cache_copy::$18 = fe_sprite_cache_copy::c#5 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta fe_sprite_cache_copy__18
    // [1420] ((unsigned int *)&sprite_cache+$30)[fe_sprite_cache_copy::$18] = ((unsigned int *)&sprites+$240)[fe_sprite_cache_copy::$19] -- pwuc1_derefidx_vbum1=pwuc2_derefidx_vbum2 
    tax
    ldy fe_sprite_cache_copy__19
    lda sprites+$240,y
    sta sprite_cache+$30,x
    lda sprites+$240+1,y
    sta sprite_cache+$30+1,x
    // sprite_cache.size[c] = sprites.SpriteSize[sprite_index]
    // [1421] ((unsigned int *)&sprite_cache+$50)[fe_sprite_cache_copy::$18] = ((unsigned int *)&sprites+$80)[fe_sprite_cache_copy::$19] -- pwuc1_derefidx_vbum1=pwuc2_derefidx_vbum2 
    lda sprites+$80,y
    sta sprite_cache+$50,x
    lda sprites+$80+1,y
    sta sprite_cache+$50+1,x
    // sprite_cache.zdepth[c] = sprites.Zdepth[sprite_index]
    // [1422] ((char *)&sprite_cache+$70)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$100)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$100,y
    ldy c
    sta sprite_cache+$70,y
    // sprite_cache.bpp[c] = sprites.BPP[sprite_index]
    // [1423] ((char *)&sprite_cache+$80)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$160)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$160,y
    ldy c
    sta sprite_cache+$80,y
    // sprite_cache.height[c] = sprites.Height[sprite_index]
    // [1424] ((char *)&sprite_cache+$a0)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$c0)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$c0,y
    ldy c
    sta sprite_cache+$a0,y
    // sprite_cache.width[c] = sprites.Width[sprite_index]
    // [1425] ((char *)&sprite_cache+$90)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$e0)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$e0,y
    ldy c
    sta sprite_cache+$90,y
    // sprite_cache.hflip[c] = sprites.Hflip[sprite_index]
    // [1426] ((char *)&sprite_cache+$b0)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$120)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$120,y
    ldy c
    sta sprite_cache+$b0,y
    // sprite_cache.vflip[c] = sprites.Vflip[sprite_index]
    // [1427] ((char *)&sprite_cache+$c0)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$140)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$140,y
    ldy c
    sta sprite_cache+$c0,y
    // sprite_cache.reverse[c] = sprites.reverse[sprite_index]
    // [1428] ((char *)&sprite_cache+$d0)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$1a0)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$1a0,y
    ldy c
    sta sprite_cache+$d0,y
    // sprite_cache.palette_offset[c] = sprites.PaletteOffset[sprite_index]
    // [1429] ((char *)&sprite_cache+$100)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$180)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$180,y
    ldy c
    sta sprite_cache+$100,y
    // sprite_cache.loop[c] = sprites.loop[sprite_index]
    // [1430] ((char *)&sprite_cache+$f0)[fe_sprite_cache_copy::c#5] = ((char *)&sprites+$280)[fe_sprite_cache_copy::sprite_index#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum2 
    ldy sprite_index
    lda sprites+$280,y
    ldy c
    sta sprite_cache+$f0,y
    // strcpy(&sprite_cache.file[co], sprites.file[sprite_index])
    // [1431] strcpy::destination#0 = (char *)&sprite_cache+$110 + fe_sprite_cache_copy::co#0 -- pbuz1=pbuc1_plus_vbum2 
    lda co
    clc
    adc #<sprite_cache+$110
    sta.z strcpy.destination
    lda #>sprite_cache+$110
    adc #0
    sta.z strcpy.destination+1
    // [1432] strcpy::source#0 = ((char **)&sprites)[fe_sprite_cache_copy::$19] -- pbuz1=qbuc1_derefidx_vbum2 
    ldy fe_sprite_cache_copy__19
    lda sprites,y
    sta.z strcpy.source
    lda sprites+1,y
    sta.z strcpy.source+1
    // [1433] call strcpy
    // [1560] phi from fe_sprite_cache_copy::@3 to strcpy [phi:fe_sprite_cache_copy::@3->strcpy]
    // [1560] phi strcpy::dst#0 = strcpy::destination#0 [phi:fe_sprite_cache_copy::@3->strcpy#0] -- register_copy 
    // [1560] phi strcpy::src#0 = strcpy::source#0 [phi:fe_sprite_cache_copy::@3->strcpy#1] -- register_copy 
    jsr strcpy
    // fe_sprite_cache_copy::@8
    // sprites.aabb[sprite_index].xmin >> 2
    // [1434] fe_sprite_cache_copy::$21 = fe_sprite_cache_copy::sprite_index#0 << 2 -- vbum1=vbum1_rol_2 
    lda fe_sprite_cache_copy__21
    asl
    asl
    sta fe_sprite_cache_copy__21
    // [1435] fe_sprite_cache_copy::$11 = ((char *)(struct $17 *)&sprites+$1c0)[fe_sprite_cache_copy::$21] >> 2 -- vbum1=pbuc1_derefidx_vbum2_ror_2 
    tay
    lda sprites+$1c0,y
    lsr
    lsr
    sta fe_sprite_cache_copy__11
    // sprite_cache.xmin[c] = sprites.aabb[sprite_index].xmin >> 2
    // [1436] ((char *)&sprite_cache+$210)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$11 -- pbuc1_derefidx_vbum1=vbum2 
    ldy c
    sta sprite_cache+$210,y
    // sprites.aabb[sprite_index].ymin >> 2
    // [1437] fe_sprite_cache_copy::$12 = ((char *)(struct $17 *)&sprites+$1c0+1)[fe_sprite_cache_copy::$21] >> 2 -- vbum1=pbuc1_derefidx_vbum2_ror_2 
    ldy fe_sprite_cache_copy__21
    lda sprites+$1c0+1,y
    lsr
    lsr
    sta fe_sprite_cache_copy__12
    // sprite_cache.ymin[c] = sprites.aabb[sprite_index].ymin >> 2
    // [1438] ((char *)&sprite_cache+$220)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$12 -- pbuc1_derefidx_vbum1=vbum2 
    ldy c
    sta sprite_cache+$220,y
    // sprites.aabb[sprite_index].xmax >> 2
    // [1439] fe_sprite_cache_copy::$13 = ((char *)(struct $17 *)&sprites+$1c0+2)[fe_sprite_cache_copy::$21] >> 2 -- vbum1=pbuc1_derefidx_vbum2_ror_2 
    ldy fe_sprite_cache_copy__21
    lda sprites+$1c0+2,y
    lsr
    lsr
    sta fe_sprite_cache_copy__13
    // sprite_cache.xmax[c] = sprites.aabb[sprite_index].xmax >> 2
    // [1440] ((char *)&sprite_cache+$230)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$13 -- pbuc1_derefidx_vbum1=vbum2 
    ldy c
    sta sprite_cache+$230,y
    // sprites.aabb[sprite_index].ymax >> 2
    // [1441] fe_sprite_cache_copy::$14 = ((char *)(struct $17 *)&sprites+$1c0+3)[fe_sprite_cache_copy::$21] >> 2 -- vbum1=pbuc1_derefidx_vbum1_ror_2 
    ldy fe_sprite_cache_copy__14
    lda sprites+$1c0+3,y
    lsr
    lsr
    sta fe_sprite_cache_copy__14
    // sprite_cache.ymax[c] = sprites.aabb[sprite_index].ymax >> 2
    // [1442] ((char *)&sprite_cache+$240)[fe_sprite_cache_copy::c#5] = fe_sprite_cache_copy::$14 -- pbuc1_derefidx_vbum1=vbum2 
    ldy c
    sta sprite_cache+$240,y
    // [1443] phi from fe_sprite_cache_copy::@7 fe_sprite_cache_copy::@8 to fe_sprite_cache_copy::@1 [phi:fe_sprite_cache_copy::@7/fe_sprite_cache_copy::@8->fe_sprite_cache_copy::@1]
    // [1443] phi fe_sprite_cache_copy::c#2 = fe_sprite_cache_copy::c#0 [phi:fe_sprite_cache_copy::@7/fe_sprite_cache_copy::@8->fe_sprite_cache_copy::@1#0] -- register_copy 
    // fe_sprite_cache_copy::@1
  __b1:
    // sprite_cache.used[c]++;
    // [1444] ((char *)&sprite_cache)[fe_sprite_cache_copy::c#2] = ++ ((char *)&sprite_cache)[fe_sprite_cache_copy::c#2] -- pbuc1_derefidx_vbum1=_inc_pbuc1_derefidx_vbum1 
    ldx c
    inc sprite_cache,x
    // fe_sprite_cache_copy::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // fe_sprite_cache_copy::@return
    // }
    // [1446] return 
    rts
    // fe_sprite_cache_copy::@5
  __b5:
    // sprite_cache_pool + 1
    // [1447] fe_sprite_cache_copy::$6 = sprite_cache_pool + 1 -- vbum1=vbum2_plus_1 
    lda sprite_cache_pool
    inc
    sta fe_sprite_cache_copy__6
    // (sprite_cache_pool + 1) % FE_CACHE
    // [1448] fe_sprite_cache_copy::$7 = fe_sprite_cache_copy::$6 & FE_CACHE-1 -- vbum1=vbum1_band_vbuc1 
    lda #FE_CACHE-1
    and fe_sprite_cache_copy__7
    sta fe_sprite_cache_copy__7
    // sprite_cache_pool = (sprite_cache_pool + 1) % FE_CACHE
    // [1449] sprite_cache_pool = fe_sprite_cache_copy::$7 -- vbum1=vbum2 
    sta sprite_cache_pool
    jmp __b4
  .segment DataEngineFlight
    fe_sprite_cache_copy__6: .byte 0
    .label fe_sprite_cache_copy__7 = fe_sprite_cache_copy__6
    fe_sprite_cache_copy__11: .byte 0
    fe_sprite_cache_copy__12: .byte 0
    fe_sprite_cache_copy__13: .byte 0
    .label fe_sprite_cache_copy__14 = flight_add.sprite
    fe_sprite_cache_copy__18: .byte 0
    fe_sprite_cache_copy__19: .byte 0
    .label fe_sprite_cache_copy__21 = flight_add.sprite
    .label sprite_index = flight_add.sprite
    .label return = c
    c: .byte 0
    cache_bram: .byte 0
    co: .byte 0
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
    // [1451] flight_sprite_next_offset::$6 = flight_sprite_offset_pool << 1 -- vbum1=vbum2_rol_1 
    lda flight_sprite_offset_pool
    asl
    sta flight_sprite_next_offset__6
    // while (!flight_sprite_offset_pool || flight_sprite_offsets[flight_sprite_offset_pool])
    // [1452] if(0==flight_sprite_offset_pool) goto flight_sprite_next_offset::@2 -- 0_eq_vbum1_then_la1 
    lda flight_sprite_offset_pool
    beq __b2
    // flight_sprite_next_offset::@5
    // [1453] if(0!=flight_sprite_offsets[flight_sprite_next_offset::$6]) goto flight_sprite_next_offset::@2 -- 0_neq_pwuc1_derefidx_vbum1_then_la1 
    ldy flight_sprite_next_offset__6
    lda flight_sprite_offsets+1,y
    ora flight_sprite_offsets,y
    bne __b2
    // flight_sprite_next_offset::@3
    // stage.sprite_count++;
    // [1454] *((char *)&stage+$f) = ++ *((char *)&stage+$f) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc stage+$f
    // vera_sprite_offset sprite_offset = vera_sprite_get_offset(flight_sprite_offset_pool)
    // [1455] flight_sprite_next_offset::vera_sprite_get_offset1_sprite_id#0 = flight_sprite_offset_pool -- vbum1=vbum2 
    lda flight_sprite_offset_pool
    sta vera_sprite_get_offset1_sprite_id
    // flight_sprite_next_offset::vera_sprite_get_offset1
    // ((unsigned int)sprite_id) << 3
    // [1456] flight_sprite_next_offset::vera_sprite_get_offset1_$2 = (unsigned int)flight_sprite_next_offset::vera_sprite_get_offset1_sprite_id#0 -- vwum1=_word_vbum2 
    sta vera_sprite_get_offset1_flight_sprite_next_offset__2
    lda #0
    sta vera_sprite_get_offset1_flight_sprite_next_offset__2+1
    // [1457] flight_sprite_next_offset::vera_sprite_get_offset1_$0 = flight_sprite_next_offset::vera_sprite_get_offset1_$2 << 3 -- vwum1=vwum1_rol_3 
    asl vera_sprite_get_offset1_flight_sprite_next_offset__0
    rol vera_sprite_get_offset1_flight_sprite_next_offset__0+1
    asl vera_sprite_get_offset1_flight_sprite_next_offset__0
    rol vera_sprite_get_offset1_flight_sprite_next_offset__0+1
    asl vera_sprite_get_offset1_flight_sprite_next_offset__0
    rol vera_sprite_get_offset1_flight_sprite_next_offset__0+1
    // WORD0(VERA_SPRITE_ATTR)+(((unsigned int)sprite_id) << 3)
    // [1458] flight_sprite_next_offset::vera_sprite_get_offset1_return#0 = word0 VERA_SPRITE_ATTR + flight_sprite_next_offset::vera_sprite_get_offset1_$0 -- vwum1=vwuc1_plus_vwum1 
    lda vera_sprite_get_offset1_return
    clc
    adc #<VERA_SPRITE_ATTR&$ffff
    sta vera_sprite_get_offset1_return
    lda vera_sprite_get_offset1_return+1
    adc #>VERA_SPRITE_ATTR&$ffff
    sta vera_sprite_get_offset1_return+1
    // flight_sprite_next_offset::@4
    // flight_sprite_offsets[flight_sprite_offset_pool] = sprite_offset
    // [1459] flight_sprite_next_offset::$7 = flight_sprite_offset_pool << 1 -- vbum1=vbum2_rol_1 
    lda flight_sprite_offset_pool
    asl
    sta flight_sprite_next_offset__7
    // [1460] flight_sprite_offsets[flight_sprite_next_offset::$7] = flight_sprite_next_offset::vera_sprite_get_offset1_return#0 -- pwuc1_derefidx_vbum1=vwum2 
    tay
    lda vera_sprite_get_offset1_return
    sta flight_sprite_offsets,y
    lda vera_sprite_get_offset1_return+1
    sta flight_sprite_offsets+1,y
    // flight_sprite_next_offset::@return
    // }
    // [1461] return 
    rts
    // flight_sprite_next_offset::@2
  __b2:
    // flight_sprite_offset_pool + 1
    // [1462] flight_sprite_next_offset::$4 = flight_sprite_offset_pool + 1 -- vbum1=vbum2_plus_1 
    lda flight_sprite_offset_pool
    inc
    sta flight_sprite_next_offset__4
    // (flight_sprite_offset_pool + 1) % 128
    // [1463] flight_sprite_next_offset::$5 = flight_sprite_next_offset::$4 & $80-1 -- vbum1=vbum1_band_vbuc1 
    lda #$80-1
    and flight_sprite_next_offset__5
    sta flight_sprite_next_offset__5
    // flight_sprite_offset_pool = (flight_sprite_offset_pool + 1) % 128
    // [1464] flight_sprite_offset_pool = flight_sprite_next_offset::$5 -- vbum1=vbum2 
    sta flight_sprite_offset_pool
    jmp __b1
  .segment DataEngineFlight
    flight_sprite_next_offset__4: .byte 0
    .label flight_sprite_next_offset__5 = flight_sprite_next_offset__4
    flight_sprite_next_offset__6: .byte 0
    flight_sprite_next_offset__7: .byte 0
  .segment Data
    .label vera_sprite_get_offset1_flight_sprite_next_offset__0 = vera_sprite_get_offset1_flight_sprite_next_offset__2
    vera_sprite_get_offset1_flight_sprite_next_offset__2: .word 0
  .segment DataEngineFlight
    return: .word 0
  .segment Data
    vera_sprite_get_offset1_sprite_id: .byte 0
    .label vera_sprite_get_offset1_return = vera_sprite_get_offset1_flight_sprite_next_offset__2
}
.segment CodeEngineFlight
  // fe_sprite_configure
// void fe_sprite_configure(__mem() unsigned int sprite_offset, __mem() char s)
fe_sprite_configure: {
    .const vera_sprite_bpp1_vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    .const vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_sprite_bpp(sprite_offset, sprite_cache.bpp[s])
    // [1465] fe_sprite_configure::vera_sprite_bpp1_bpp#0 = ((char *)&sprite_cache+$80)[fe_sprite_configure::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda sprite_cache+$80,y
    sta vera_sprite_bpp1_bpp
    // fe_sprite_configure::vera_sprite_bpp1
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+1, vera_inc_0)
    // [1466] fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset#0 = fe_sprite_configure::sprite_offset#0 + 1 -- vwum1=vwum2_plus_1 
    clc
    lda sprite_offset
    adc #1
    sta vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset
    lda sprite_offset+1
    adc #0
    sta vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset+1
    // fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1467] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1468] fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$0 = byte0  fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte0_vwum2 
    lda vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset
    sta vera_sprite_bpp1_vera_vram_data0_bank_offset1_fe_sprite_configure__0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1469] *VERA_ADDRX_L = fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1470] fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$1 = byte1  fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte1_vwum2 
    lda vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset+1
    sta vera_sprite_bpp1_vera_vram_data0_bank_offset1_fe_sprite_configure__1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1471] *VERA_ADDRX_M = fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [1472] *VERA_ADDRX_H = fe_sprite_configure::vera_sprite_bpp1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_sprite_bpp1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // fe_sprite_configure::vera_sprite_bpp1_@1
    // *VERA_DATA0 & ~VERA_SPRITE_8BPP
    // [1473] fe_sprite_configure::vera_sprite_bpp1_$2 = *VERA_DATA0 & ~$80 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$80^$ff
    and VERA_DATA0
    sta vera_sprite_bpp1_fe_sprite_configure__2
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_8BPP
    // [1474] *VERA_DATA0 = fe_sprite_configure::vera_sprite_bpp1_$2 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // *VERA_DATA0 |= bpp
    // [1475] *VERA_DATA0 = *VERA_DATA0 | fe_sprite_configure::vera_sprite_bpp1_bpp#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbum1 
    ora vera_sprite_bpp1_bpp
    sta VERA_DATA0
    // fe_sprite_configure::@1
    // vera_sprite_height(sprite_offset, sprite_cache.height[s])
    // [1476] vera_sprite_height::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta vera_sprite_height.sprite_offset
    lda sprite_offset+1
    sta vera_sprite_height.sprite_offset+1
    // [1477] vera_sprite_height::height#0 = ((char *)&sprite_cache+$a0)[fe_sprite_configure::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda sprite_cache+$a0,y
    sta vera_sprite_height.height
    // [1478] call vera_sprite_height
    jsr vera_sprite_height
    // fe_sprite_configure::@2
    // vera_sprite_width(sprite_offset, sprite_cache.width[s])
    // [1479] vera_sprite_width::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta vera_sprite_width.sprite_offset
    lda sprite_offset+1
    sta vera_sprite_width.sprite_offset+1
    // [1480] vera_sprite_width::width#0 = ((char *)&sprite_cache+$90)[fe_sprite_configure::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda sprite_cache+$90,y
    sta vera_sprite_width.width
    // [1481] call vera_sprite_width
    jsr vera_sprite_width
    // fe_sprite_configure::@3
    // vera_sprite_hflip(sprite_offset, sprite_cache.hflip[s])
    // [1482] vera_sprite_hflip::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta vera_sprite_hflip.sprite_offset
    lda sprite_offset+1
    sta vera_sprite_hflip.sprite_offset+1
    // [1483] vera_sprite_hflip::hflip#0 = ((char *)&sprite_cache+$b0)[fe_sprite_configure::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda sprite_cache+$b0,y
    sta vera_sprite_hflip.hflip
    // [1484] call vera_sprite_hflip
    jsr vera_sprite_hflip
    // fe_sprite_configure::@4
    // vera_sprite_vflip(sprite_offset, sprite_cache.vflip[s])
    // [1485] vera_sprite_vflip::sprite_offset#0 = fe_sprite_configure::sprite_offset#0 -- vwum1=vwum2 
    lda sprite_offset
    sta vera_sprite_vflip.sprite_offset
    lda sprite_offset+1
    sta vera_sprite_vflip.sprite_offset+1
    // [1486] vera_sprite_vflip::vflip#0 = ((char *)&sprite_cache+$c0)[fe_sprite_configure::s#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy s
    lda sprite_cache+$c0,y
    sta vera_sprite_vflip.vflip
    // [1487] call vera_sprite_vflip
    jsr vera_sprite_vflip
    // fe_sprite_configure::@5
    // palette_use_vram(sprite_cache.palette_offset[s])
    // [1488] stackpush(char) = ((char *)&sprite_cache+$100)[fe_sprite_configure::s#0] -- _stackpushbyte_=pbuc1_derefidx_vbum1 
    ldy s
    lda sprite_cache+$100,y
    pha
    // [1489] callexecute palette_use_vram  -- call_stack_near 
    jsr lib_palette.palette_use_vram
    // vera_sprite_palette_offset(sprite_offset, palette_use_vram(sprite_cache.palette_offset[s]))
    // [1490] fe_sprite_configure::vera_sprite_palette_offset1_palette_offset#0 = stackpull(char) -- vbum1=_stackpullbyte_ 
    pla
    sta vera_sprite_palette_offset1_palette_offset
    // fe_sprite_configure::vera_sprite_palette_offset1
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0)
    // [1491] fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset#0 = fe_sprite_configure::sprite_offset#0 + 7 -- vwum1=vwum2_plus_vbuc1 
    lda #7
    clc
    adc sprite_offset
    sta vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset
    lda #0
    adc sprite_offset+1
    sta vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset+1
    // fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1492] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1493] fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$0 = byte0  fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte0_vwum2 
    lda vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset
    sta vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_fe_sprite_configure__0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1494] *VERA_ADDRX_L = fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1495] fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$1 = byte1  fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte1_vwum2 
    lda vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset+1
    sta vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_fe_sprite_configure__1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1496] *VERA_ADDRX_M = fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [1497] *VERA_ADDRX_H = fe_sprite_configure::vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // fe_sprite_configure::vera_sprite_palette_offset1_@1
    // *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK
    // [1498] fe_sprite_configure::vera_sprite_palette_offset1_$2 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #VERA_SPRITE_PALETTE_OFFSET_MASK^$ff
    and VERA_DATA0
    sta vera_sprite_palette_offset1_fe_sprite_configure__2
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_PALETTE_OFFSET_MASK
    // [1499] *VERA_DATA0 = fe_sprite_configure::vera_sprite_palette_offset1_$2 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // *VERA_DATA0 |= palette_offset
    // [1500] *VERA_DATA0 = *VERA_DATA0 | fe_sprite_configure::vera_sprite_palette_offset1_palette_offset#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbum1 
    ora vera_sprite_palette_offset1_palette_offset
    sta VERA_DATA0
    // fe_sprite_configure::@return
    // }
    // [1501] return 
    rts
  .segment Data
    vera_sprite_bpp1_fe_sprite_configure__2: .byte 0
    vera_sprite_bpp1_vera_vram_data0_bank_offset1_fe_sprite_configure__0: .byte 0
    vera_sprite_bpp1_vera_vram_data0_bank_offset1_fe_sprite_configure__1: .byte 0
    vera_sprite_palette_offset1_fe_sprite_configure__2: .byte 0
    vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_fe_sprite_configure__0: .byte 0
    vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_fe_sprite_configure__1: .byte 0
  .segment DataEngineFlight
    sprite_offset: .word 0
    .label s = fe_sprite_cache_copy.c
  .segment Data
    vera_sprite_bpp1_bpp: .byte 0
    vera_sprite_bpp1_vera_vram_data0_bank_offset1_offset: .word 0
    vera_sprite_palette_offset1_palette_offset: .byte 0
    vera_sprite_palette_offset1_vera_vram_data0_bank_offset1_offset: .word 0
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
// void memcpy_vram_bram(__mem() char dbank_vram, __mem() unsigned int doffset_vram, __mem() char sbank_bram, __zp($31) char *sptr_bram, __mem() volatile unsigned int num)
memcpy_vram_bram: {
    .label pagemask = $ff00
    .label ptr = $2b
    .label sptr_bram = $31
    // memcpy_vram_bram::bank_get_bram1
    // return BRAM;
    // [1503] memcpy_vram_bram::bank#10 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank
    // memcpy_vram_bram::bank_set_bram1
    // BRAM = bank
    // [1504] BRAM = memcpy_vram_bram::sbank_bram#2 -- vbuz1=vbum2 
    lda sbank_bram
    sta.z BRAM
    // memcpy_vram_bram::@12
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1505] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(doffset_vram)
    // [1506] memcpy_vram_bram::$2 = byte0  memcpy_vram_bram::doffset_vram#0 -- vbum1=_byte0_vwum2 
    lda doffset_vram
    sta memcpy_vram_bram__2
    // *VERA_ADDRX_L = BYTE0(doffset_vram)
    // [1507] *VERA_ADDRX_L = memcpy_vram_bram::$2 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(doffset_vram)
    // [1508] memcpy_vram_bram::$3 = byte1  memcpy_vram_bram::doffset_vram#0 -- vbum1=_byte1_vwum2 
    lda doffset_vram+1
    sta memcpy_vram_bram__3
    // *VERA_ADDRX_M = BYTE1(doffset_vram)
    // [1509] *VERA_ADDRX_M = memcpy_vram_bram::$3 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // dbank_vram | VERA_INC_1
    // [1510] memcpy_vram_bram::$4 = memcpy_vram_bram::dbank_vram#0 | VERA_INC_1 -- vbum1=vbum1_bor_vbuc1 
    lda #VERA_INC_1
    ora memcpy_vram_bram__4
    sta memcpy_vram_bram__4
    // *VERA_ADDRX_H = dbank_vram | VERA_INC_1
    // [1511] *VERA_ADDRX_H = memcpy_vram_bram::$4 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_H
    // (unsigned int)sptr_bram & (unsigned int)pagemask
    // [1512] memcpy_vram_bram::$5 = (unsigned int)memcpy_vram_bram::sptr_bram#0 & (unsigned int)memcpy_vram_bram::pagemask -- vwum1=vwuz2_band_vwuc1 
    lda.z sptr_bram
    and #<pagemask
    sta memcpy_vram_bram__5
    lda.z sptr_bram+1
    and #>pagemask
    sta memcpy_vram_bram__5+1
    // bram_ptr_t ptr = (bram_ptr_t)((unsigned int)sptr_bram & (unsigned int)pagemask)
    // [1513] memcpy_vram_bram::ptr = (char *)memcpy_vram_bram::$5 -- pbuz1=pbum2 
    // Set the page boundary.
    lda memcpy_vram_bram__5
    sta.z ptr
    lda memcpy_vram_bram__5+1
    sta.z ptr+1
    // unsigned char pos = BYTE0(sptr_bram)
    // [1514] memcpy_vram_bram::pos = byte0  memcpy_vram_bram::sptr_bram#0 -- vbum1=_byte0_pbuz2 
    lda.z sptr_bram
    sta pos
    // BYTE0(sptr_bram)
    // [1515] memcpy_vram_bram::$7 = byte0  memcpy_vram_bram::sptr_bram#0 -- vbum1=_byte0_pbuz2 
    lda.z sptr_bram
    sta memcpy_vram_bram__7
    // unsigned char len = -BYTE0(sptr_bram)
    // [1516] memcpy_vram_bram::len = - memcpy_vram_bram::$7 -- vbum1=_neg_vbum2 
    eor #$ff
    clc
    adc #1
    sta len
    // num <= (unsigned int)len
    // [1517] memcpy_vram_bram::$27 = (unsigned int)memcpy_vram_bram::len -- vwum1=_word_vbum2 
    sta memcpy_vram_bram__27
    lda #0
    sta memcpy_vram_bram__27+1
    // if (num <= (unsigned int)len)
    // [1518] if(memcpy_vram_bram::num>memcpy_vram_bram::$27) goto memcpy_vram_bram::@1 -- vwum1_gt_vwum2_then_la1 
    cmp num+1
    bcc __b1
    bne !+
    lda memcpy_vram_bram__27
    cmp num
    bcc __b1
  !:
    // memcpy_vram_bram::@5
    // BYTE0(num)
    // [1519] memcpy_vram_bram::$11 = byte0  memcpy_vram_bram::num -- vbum1=_byte0_vwum2 
    lda num
    sta memcpy_vram_bram__11
    // len = BYTE0(num)
    // [1520] memcpy_vram_bram::len = memcpy_vram_bram::$11 -- vbum1=vbum2 
    sta len
    // memcpy_vram_bram::@1
  __b1:
    // if (len)
    // [1521] if(0==memcpy_vram_bram::len) goto memcpy_vram_bram::@2 -- 0_eq_vbum1_then_la1 
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
    // [1523] memcpy_vram_bram::ptr = memcpy_vram_bram::ptr + $100 -- pbuz1=pbuz1_plus_vwuc1 
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
    // [1524] memcpy_vram_bram::num = memcpy_vram_bram::num - memcpy_vram_bram::len -- vwum1=vwum1_minus_vbum2 
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
    // [1525] memcpy_vram_bram::$13 = byte1  memcpy_vram_bram::ptr -- vbum1=_byte1_pbuz2 
    lda.z ptr+1
    sta memcpy_vram_bram__13
    // if (BYTE1(ptr) == 0xC0)
    // [1526] if(memcpy_vram_bram::$13!=$c0) goto memcpy_vram_bram::@3 -- vbum1_neq_vbuc1_then_la1 
    lda #$c0
    cmp memcpy_vram_bram__13
    bne __b3
    // memcpy_vram_bram::@7
    // ptr = (unsigned char *)0xA000
    // [1527] memcpy_vram_bram::ptr = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z ptr
    lda #>$a000
    sta.z ptr+1
    // bank_set_bram(++sbank_bram);
    // [1528] memcpy_vram_bram::bank_set_bram2_bank#0 = ++ memcpy_vram_bram::sbank_bram#2 -- vbum1=_inc_vbum1 
    inc bank_set_bram2_bank
    // memcpy_vram_bram::bank_set_bram2
    // BRAM = bank
    // [1529] BRAM = memcpy_vram_bram::bank_set_bram2_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram2_bank
    sta.z BRAM
    // [1530] phi from memcpy_vram_bram::@2 memcpy_vram_bram::bank_set_bram2 to memcpy_vram_bram::@3 [phi:memcpy_vram_bram::@2/memcpy_vram_bram::bank_set_bram2->memcpy_vram_bram::@3]
    // [1530] phi memcpy_vram_bram::sbank_bram#13 = memcpy_vram_bram::sbank_bram#2 [phi:memcpy_vram_bram::@2/memcpy_vram_bram::bank_set_bram2->memcpy_vram_bram::@3#0] -- register_copy 
    // memcpy_vram_bram::@3
  __b3:
    // BYTE1(num)
    // [1531] memcpy_vram_bram::$16 = byte1  memcpy_vram_bram::num -- vbum1=_byte1_vwum2 
    lda num+1
    sta memcpy_vram_bram__16
    // if (BYTE1(num))
    // [1532] if(0==memcpy_vram_bram::$16) goto memcpy_vram_bram::@4 -- 0_eq_vbum1_then_la1 
    beq __b4
    // [1533] phi from memcpy_vram_bram::@10 memcpy_vram_bram::@3 to memcpy_vram_bram::@9 [phi:memcpy_vram_bram::@10/memcpy_vram_bram::@3->memcpy_vram_bram::@9]
    // [1533] phi memcpy_vram_bram::sbank_bram#5 = memcpy_vram_bram::sbank_bram#12 [phi:memcpy_vram_bram::@10/memcpy_vram_bram::@3->memcpy_vram_bram::@9#0] -- register_copy 
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
    // [1535] memcpy_vram_bram::ptr = memcpy_vram_bram::ptr + $100 -- pbuz1=pbuz1_plus_vwuc1 
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
    // [1536] memcpy_vram_bram::$21 = byte1  memcpy_vram_bram::ptr -- vbum1=_byte1_pbuz2 
    sta memcpy_vram_bram__21
    // if (BYTE1(ptr) == 0xC0)
    // [1537] if(memcpy_vram_bram::$21!=$c0) goto memcpy_vram_bram::@10 -- vbum1_neq_vbuc1_then_la1 
    lda #$c0
    cmp memcpy_vram_bram__21
    bne __b10
    // memcpy_vram_bram::@11
    // ptr = (unsigned char *)0xA000
    // [1538] memcpy_vram_bram::ptr = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z ptr
    lda #>$a000
    sta.z ptr+1
    // bank_set_bram(++sbank_bram);
    // [1539] memcpy_vram_bram::bank_set_bram3_bank#0 = ++ memcpy_vram_bram::sbank_bram#5 -- vbum1=_inc_vbum1 
    inc bank_set_bram3_bank
    // memcpy_vram_bram::bank_set_bram3
    // BRAM = bank
    // [1540] BRAM = memcpy_vram_bram::bank_set_bram3_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram3_bank
    sta.z BRAM
    // [1541] phi from memcpy_vram_bram::@9 memcpy_vram_bram::bank_set_bram3 to memcpy_vram_bram::@10 [phi:memcpy_vram_bram::@9/memcpy_vram_bram::bank_set_bram3->memcpy_vram_bram::@10]
    // [1541] phi memcpy_vram_bram::sbank_bram#12 = memcpy_vram_bram::sbank_bram#5 [phi:memcpy_vram_bram::@9/memcpy_vram_bram::bank_set_bram3->memcpy_vram_bram::@10#0] -- register_copy 
    // memcpy_vram_bram::@10
  __b10:
    // num -= 256
    // [1542] memcpy_vram_bram::num = memcpy_vram_bram::num - $100 -- vwum1=vwum1_minus_vwuc1 
    lda num
    sec
    sbc #<$100
    sta num
    lda num+1
    sbc #>$100
    sta num+1
    // BYTE1(num)
    // [1543] memcpy_vram_bram::$25 = byte1  memcpy_vram_bram::num -- vbum1=_byte1_vwum2 
    sta memcpy_vram_bram__25
    // while (BYTE1(num))
    // [1544] if(0!=memcpy_vram_bram::$25) goto memcpy_vram_bram::@9 -- 0_neq_vbum1_then_la1 
    bne __b9
    // memcpy_vram_bram::@4
  __b4:
    // if (num)
    // [1545] if(0==memcpy_vram_bram::num) goto memcpy_vram_bram::bank_set_bram4 -- 0_eq_vwum1_then_la1 
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
    // [1547] BRAM = memcpy_vram_bram::bank#10 -- vbuz1=vbum2 
    lda bank
    sta.z BRAM
    // memcpy_vram_bram::@return
    // }
    // [1548] return 
    rts
  .segment Data
    num: .word 0
    memcpy_vram_bram__2: .byte 0
    memcpy_vram_bram__3: .byte 0
    .label memcpy_vram_bram__4 = dbank_vram
    memcpy_vram_bram__5: .word 0
    pos: .byte 0
    len: .byte 0
    memcpy_vram_bram__7: .byte 0
    memcpy_vram_bram__11: .byte 0
    memcpy_vram_bram__13: .byte 0
    memcpy_vram_bram__16: .byte 0
    memcpy_vram_bram__21: .byte 0
    memcpy_vram_bram__25: .byte 0
    memcpy_vram_bram__27: .word 0
    .label bank_set_bram2_bank = sbank_bram
    .label bank_set_bram3_bank = sbank_bram
    dbank_vram: .byte 0
    doffset_vram: .word 0
    sbank_bram: .byte 0
    bank: .byte 0
}
.segment Code
  // strncpy
/// Copies up to n characters from the string pointed to, by src to dst.
/// In a case where the length of src is less than that of n, the remainder of dst will be padded with null bytes.
/// @param dst ? This is the pointer to the destination array where the content is to be copied.
/// @param src ? This is the string to be copied.
/// @param n ? The number of characters to be copied from source.
/// @return The destination
// char * strncpy(__zp($24) char *dst, __zp($22) const char *src, __mem() unsigned int n)
strncpy: {
    .label dst = $24
    .label src = $22
    // [1550] phi from strncpy to strncpy::@1 [phi:strncpy->strncpy::@1]
    // [1550] phi strncpy::dst#2 = ferror::temp [phi:strncpy->strncpy::@1#0] -- pbuz1=pbuc1 
    lda #<ferror.temp
    sta.z dst
    lda #>ferror.temp
    sta.z dst+1
    // [1550] phi strncpy::src#2 = __errno_error [phi:strncpy->strncpy::@1#1] -- pbuz1=pbuc1 
    lda #<__errno_error
    sta.z src
    lda #>__errno_error
    sta.z src+1
    // [1550] phi strncpy::i#2 = 0 [phi:strncpy->strncpy::@1#2] -- vwum1=vwuc1 
    lda #<0
    sta i
    sta i+1
    // strncpy::@1
  __b1:
    // for(size_t i = 0;i<n;i++)
    // [1551] if(strncpy::i#2<strncpy::n#0) goto strncpy::@2 -- vwum1_lt_vwum2_then_la1 
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
    // [1552] return 
    rts
    // strncpy::@2
  __b2:
    // char c = *src
    // [1553] strncpy::c#0 = *strncpy::src#2 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta c
    // if(c)
    // [1554] if(0==strncpy::c#0) goto strncpy::@3 -- 0_eq_vbum1_then_la1 
    beq __b3
    // strncpy::@4
    // src++;
    // [1555] strncpy::src#0 = ++ strncpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [1556] phi from strncpy::@2 strncpy::@4 to strncpy::@3 [phi:strncpy::@2/strncpy::@4->strncpy::@3]
    // [1556] phi strncpy::src#6 = strncpy::src#2 [phi:strncpy::@2/strncpy::@4->strncpy::@3#0] -- register_copy 
    // strncpy::@3
  __b3:
    // *dst++ = c
    // [1557] *strncpy::dst#2 = strncpy::c#0 -- _deref_pbuz1=vbum2 
    lda c
    ldy #0
    sta (dst),y
    // *dst++ = c;
    // [1558] strncpy::dst#0 = ++ strncpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // for(size_t i = 0;i<n;i++)
    // [1559] strncpy::i#1 = ++ strncpy::i#2 -- vwum1=_inc_vwum1 
    inc i
    bne !+
    inc i+1
  !:
    // [1550] phi from strncpy::@3 to strncpy::@1 [phi:strncpy::@3->strncpy::@1]
    // [1550] phi strncpy::dst#2 = strncpy::dst#0 [phi:strncpy::@3->strncpy::@1#0] -- register_copy 
    // [1550] phi strncpy::src#2 = strncpy::src#6 [phi:strncpy::@3->strncpy::@1#1] -- register_copy 
    // [1550] phi strncpy::i#2 = strncpy::i#1 [phi:strncpy::@3->strncpy::@1#2] -- register_copy 
    jmp __b1
  .segment Data
    c: .byte 0
    i: .word 0
    n: .word 0
}
.segment Code
  // strcpy
// Copies the C string pointed by source into the array pointed by destination, including the terminating null character (and stopping at that point).
// char * strcpy(__zp($31) char *destination, __zp($24) char *source)
strcpy: {
    .label src = $24
    .label dst = $31
    .label destination = $31
    .label source = $24
    // [1561] phi from strcpy strcpy::@2 to strcpy::@1 [phi:strcpy/strcpy::@2->strcpy::@1]
    // [1561] phi strcpy::dst#2 = strcpy::dst#0 [phi:strcpy/strcpy::@2->strcpy::@1#0] -- register_copy 
    // [1561] phi strcpy::src#2 = strcpy::src#0 [phi:strcpy/strcpy::@2->strcpy::@1#1] -- register_copy 
    // strcpy::@1
  __b1:
    // while(*src)
    // [1562] if(0!=*strcpy::src#2) goto strcpy::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strcpy::@3
    // *dst = 0
    // [1563] *strcpy::dst#2 = 0 -- _deref_pbuz1=vbuc1 
    tya
    tay
    sta (dst),y
    // strcpy::@return
    // }
    // [1564] return 
    rts
    // strcpy::@2
  __b2:
    // *dst++ = *src++
    // [1565] *strcpy::dst#2 = *strcpy::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [1566] strcpy::dst#1 = ++ strcpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [1567] strcpy::src#1 = ++ strcpy::src#2 -- pbuz1=_inc_pbuz1 
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
    .label dst = $2d
    .label src = $31
    // strlen(destination)
    // [1569] call strlen
    // [1217] phi from strcat to strlen [phi:strcat->strlen]
    // [1217] phi strlen::str#7 = fe_sprite_bram_load::filename [phi:strcat->strlen#0] -- pbuz1=pbuc1 
    lda #<fe_sprite_bram_load.filename
    sta.z strlen.str
    lda #>fe_sprite_bram_load.filename
    sta.z strlen.str+1
    jsr strlen
    // strlen(destination)
    // [1570] strlen::return#0 = strlen::len#2
    // strcat::@4
    // [1571] strcat::$0 = strlen::return#0
    // char* dst = destination + strlen(destination)
    // [1572] strcat::dst#0 = fe_sprite_bram_load::filename + strcat::$0 -- pbuz1=pbuc1_plus_vwum2 
    lda strcat__0
    clc
    adc #<fe_sprite_bram_load.filename
    sta.z dst
    lda strcat__0+1
    adc #>fe_sprite_bram_load.filename
    sta.z dst+1
    // [1573] phi from strcat::@4 to strcat::@1 [phi:strcat::@4->strcat::@1]
    // [1573] phi strcat::dst#2 = strcat::dst#0 [phi:strcat::@4->strcat::@1#0] -- register_copy 
    // [1573] phi strcat::src#2 = fe_sprite_bram_load::source [phi:strcat::@4->strcat::@1#1] -- pbuz1=pbuc1 
    lda #<fe_sprite_bram_load.source
    sta.z src
    lda #>fe_sprite_bram_load.source
    sta.z src+1
    // strcat::@1
  __b1:
    // while(*src)
    // [1574] if(0!=*strcat::src#2) goto strcat::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strcat::@3
    // *dst = 0
    // [1575] *strcat::dst#2 = 0 -- _deref_pbuz1=vbuc1 
    tya
    tay
    sta (dst),y
    // strcat::@return
    // }
    // [1576] return 
    rts
    // strcat::@2
  __b2:
    // *dst++ = *src++
    // [1577] *strcat::dst#2 = *strcat::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [1578] strcat::dst#1 = ++ strcat::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [1579] strcat::src#1 = ++ strcat::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [1573] phi from strcat::@2 to strcat::@1 [phi:strcat::@2->strcat::@1]
    // [1573] phi strcat::dst#2 = strcat::dst#1 [phi:strcat::@2->strcat::@1#0] -- register_copy 
    // [1573] phi strcat::src#2 = strcat::src#1 [phi:strcat::@2->strcat::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label strcat__0 = strlen.len
}
.segment CodeEngineFlight
  // sprite_map_header
// void sprite_map_header(struct $19 *sprite_file_header, __mem() char sprite)
sprite_map_header: {
    .label sprite_file_header = fe_sprite_bram_load.sprite_file_header
    // sprites.count[sprite] = sprite_file_header->count
    // [1580] ((char *)&sprites+$60)[sprite_map_header::sprite#0] = *((char *)sprite_map_header::sprite_file_header#0) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    lda sprite_file_header
    ldy sprite
    sta sprites+$60,y
    // sprites.SpriteSize[sprite] = sprite_file_header->size
    // [1581] sprite_map_header::$8 = sprite_map_header::sprite#0 << 1 -- vbum1=vbum2_rol_1 
    tya
    asl
    sta sprite_map_header__8
    // [1582] ((unsigned int *)&sprites+$80)[sprite_map_header::$8] = *((unsigned int *)sprite_map_header::sprite_file_header#0+1) -- pwuc1_derefidx_vbum1=_deref_pwuc2 
    tay
    lda sprite_file_header+1
    sta sprites+$80,y
    lda sprite_file_header+1+1
    sta sprites+$80+1,y
    // vera_sprite_width_get_bitmap(sprite_file_header->width)
    // [1583] sprite_map_header::vera_sprite_width_get_bitmap1_width#0 = *((char *)sprite_map_header::sprite_file_header#0+3) -- vbum1=_deref_pbuc1 
    lda sprite_file_header+3
    sta vera_sprite_width_get_bitmap1_width
    // sprite_map_header::vera_sprite_width_get_bitmap1
    // case 8:
    //             return VERA_SPRITE_WIDTH_8;
    // [1584] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==8) goto sprite_map_header::vera_sprite_width_get_bitmap1_@return -- vbum1_eq_vbuc1_then_la1 
    lda #8
    cmp vera_sprite_width_get_bitmap1_width
    beq __b5
    // sprite_map_header::vera_sprite_width_get_bitmap1_@1
    // case 16:
    //             return VERA_SPRITE_WIDTH_16;
    // [1585] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==$10) goto sprite_map_header::vera_sprite_width_get_bitmap1_@return -- vbum1_eq_vbuc1_then_la1 
    lda #$10
    cmp vera_sprite_width_get_bitmap1_width
    beq __b6
    // sprite_map_header::vera_sprite_width_get_bitmap1_@2
    // case 32:
    //             return VERA_SPRITE_WIDTH_32;
    // [1586] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==$20) goto sprite_map_header::vera_sprite_width_get_bitmap1_@return -- vbum1_eq_vbuc1_then_la1 
    lda #$20
    cmp vera_sprite_width_get_bitmap1_width
    beq __b7
    // sprite_map_header::vera_sprite_width_get_bitmap1_@3
    // case 64:
    //             return VERA_SPRITE_WIDTH_64;
    //         other:
    // [1587] if(sprite_map_header::vera_sprite_width_get_bitmap1_width#0==$40) goto sprite_map_header::vera_sprite_width_get_bitmap1_@9 -- vbum1_eq_vbuc1_then_la1 
    lda #$40
    cmp vera_sprite_width_get_bitmap1_width
    beq vera_sprite_width_get_bitmap1___b9
    // [1589] phi from sprite_map_header::vera_sprite_width_get_bitmap1 sprite_map_header::vera_sprite_width_get_bitmap1_@3 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1/sprite_map_header::vera_sprite_width_get_bitmap1_@3->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
  __b5:
    // [1589] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = 0 [phi:sprite_map_header::vera_sprite_width_get_bitmap1/sprite_map_header::vera_sprite_width_get_bitmap1_@3->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #0
    sta vera_sprite_width_get_bitmap1_return
    jmp __b1
    // [1588] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@3 to sprite_map_header::vera_sprite_width_get_bitmap1_@9 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@3->sprite_map_header::vera_sprite_width_get_bitmap1_@9]
    // sprite_map_header::vera_sprite_width_get_bitmap1_@9
  vera_sprite_width_get_bitmap1___b9:
    // [1589] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@9 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@9->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
    // [1589] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = $30 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@9->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #$30
    sta vera_sprite_width_get_bitmap1_return
    jmp __b1
    // [1589] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@1 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@1->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
  __b6:
    // [1589] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = $10 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@1->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #$10
    sta vera_sprite_width_get_bitmap1_return
    jmp __b1
    // [1589] phi from sprite_map_header::vera_sprite_width_get_bitmap1_@2 to sprite_map_header::vera_sprite_width_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@2->sprite_map_header::vera_sprite_width_get_bitmap1_@return]
  __b7:
    // [1589] phi sprite_map_header::vera_sprite_width_get_bitmap1_return#5 = $20 [phi:sprite_map_header::vera_sprite_width_get_bitmap1_@2->sprite_map_header::vera_sprite_width_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #$20
    sta vera_sprite_width_get_bitmap1_return
    // sprite_map_header::vera_sprite_width_get_bitmap1_@return
    // sprite_map_header::@1
  __b1:
    // sprites.Width[sprite] = vera_sprite_width_get_bitmap(sprite_file_header->width)
    // [1590] ((char *)&sprites+$e0)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_width_get_bitmap1_return#5 -- pbuc1_derefidx_vbum1=vbum2 
    lda vera_sprite_width_get_bitmap1_return
    ldy sprite
    sta sprites+$e0,y
    // vera_sprite_height_get_bitmap(sprite_file_header->height)
    // [1591] sprite_map_header::vera_sprite_height_get_bitmap1_height#0 = *((char *)sprite_map_header::sprite_file_header#0+4) -- vbum1=_deref_pbuc1 
    lda sprite_file_header+4
    sta vera_sprite_height_get_bitmap1_height
    // sprite_map_header::vera_sprite_height_get_bitmap1
    // case 8:
    //             return VERA_SPRITE_HEIGHT_8;
    // [1592] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==8) goto sprite_map_header::vera_sprite_height_get_bitmap1_@return -- vbum1_eq_vbuc1_then_la1 
    lda #8
    cmp vera_sprite_height_get_bitmap1_height
    beq __b8
    // sprite_map_header::vera_sprite_height_get_bitmap1_@1
    // case 16:
    //             return VERA_SPRITE_HEIGHT_16;
    // [1593] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==$10) goto sprite_map_header::vera_sprite_height_get_bitmap1_@return -- vbum1_eq_vbuc1_then_la1 
    lda #$10
    cmp vera_sprite_height_get_bitmap1_height
    beq __b9
    // sprite_map_header::vera_sprite_height_get_bitmap1_@2
    // case 32:
    //             return VERA_SPRITE_HEIGHT_32;
    // [1594] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==$20) goto sprite_map_header::vera_sprite_height_get_bitmap1_@return -- vbum1_eq_vbuc1_then_la1 
    lda #$20
    cmp vera_sprite_height_get_bitmap1_height
    beq __b10
    // sprite_map_header::vera_sprite_height_get_bitmap1_@3
    // case 64:
    //             return VERA_SPRITE_HEIGHT_64;
    //         other:
    // [1595] if(sprite_map_header::vera_sprite_height_get_bitmap1_height#0==$40) goto sprite_map_header::vera_sprite_height_get_bitmap1_@9 -- vbum1_eq_vbuc1_then_la1 
    lda #$40
    cmp vera_sprite_height_get_bitmap1_height
    beq vera_sprite_height_get_bitmap1___b9
    // [1597] phi from sprite_map_header::vera_sprite_height_get_bitmap1 sprite_map_header::vera_sprite_height_get_bitmap1_@3 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1/sprite_map_header::vera_sprite_height_get_bitmap1_@3->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
  __b8:
    // [1597] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = 0 [phi:sprite_map_header::vera_sprite_height_get_bitmap1/sprite_map_header::vera_sprite_height_get_bitmap1_@3->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #0
    sta vera_sprite_height_get_bitmap1_return
    jmp __b2
    // [1596] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@3 to sprite_map_header::vera_sprite_height_get_bitmap1_@9 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@3->sprite_map_header::vera_sprite_height_get_bitmap1_@9]
    // sprite_map_header::vera_sprite_height_get_bitmap1_@9
  vera_sprite_height_get_bitmap1___b9:
    // [1597] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@9 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@9->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
    // [1597] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = $c0 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@9->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #$c0
    sta vera_sprite_height_get_bitmap1_return
    jmp __b2
    // [1597] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@1 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@1->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
  __b9:
    // [1597] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = $40 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@1->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #$40
    sta vera_sprite_height_get_bitmap1_return
    jmp __b2
    // [1597] phi from sprite_map_header::vera_sprite_height_get_bitmap1_@2 to sprite_map_header::vera_sprite_height_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@2->sprite_map_header::vera_sprite_height_get_bitmap1_@return]
  __b10:
    // [1597] phi sprite_map_header::vera_sprite_height_get_bitmap1_return#5 = $80 [phi:sprite_map_header::vera_sprite_height_get_bitmap1_@2->sprite_map_header::vera_sprite_height_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #$80
    sta vera_sprite_height_get_bitmap1_return
    // sprite_map_header::vera_sprite_height_get_bitmap1_@return
    // sprite_map_header::@2
  __b2:
    // sprites.Height[sprite] = vera_sprite_height_get_bitmap(sprite_file_header->height)
    // [1598] ((char *)&sprites+$c0)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_height_get_bitmap1_return#5 -- pbuc1_derefidx_vbum1=vbum2 
    lda vera_sprite_height_get_bitmap1_return
    ldy sprite
    sta sprites+$c0,y
    // vera_sprite_zdepth_get_bitmap(sprite_file_header->zdepth)
    // [1599] sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0 = *((char *)sprite_map_header::sprite_file_header#0+5) -- vbum1=_deref_pbuc1 
    lda sprite_file_header+5
    sta vera_sprite_zdepth_get_bitmap1_zdepth
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1
    // case 0:
    //             return VERA_SPRITE_ZDEPTH_DISABLED;
    // [1600] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==0) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return -- vbum1_eq_0_then_la1 
    beq __b11
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1
    // case 1:
    //             return VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0;
    // [1601] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==1) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return -- vbum1_eq_vbuc1_then_la1 
    lda #1
    cmp vera_sprite_zdepth_get_bitmap1_zdepth
    beq __b12
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2
    // case 2:
    //             return VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1;
    // [1602] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==2) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return -- vbum1_eq_vbuc1_then_la1 
    lda #2
    cmp vera_sprite_zdepth_get_bitmap1_zdepth
    beq __b13
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3
    // case 3:
    //             return VERA_SPRITE_ZDEPTH_IN_FRONT;
    //         other:
    // [1603] if(sprite_map_header::vera_sprite_zdepth_get_bitmap1_zdepth#0==3) goto sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9 -- vbum1_eq_vbuc1_then_la1 
    lda #3
    cmp vera_sprite_zdepth_get_bitmap1_zdepth
    beq vera_sprite_zdepth_get_bitmap1___b9
    // [1605] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1 sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1/sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
  __b11:
    // [1605] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = 0 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1/sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #0
    sta vera_sprite_zdepth_get_bitmap1_return
    jmp __b3
    // [1604] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@3->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9]
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9
  vera_sprite_zdepth_get_bitmap1___b9:
    // [1605] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
    // [1605] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = $c [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@9->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #$c
    sta vera_sprite_zdepth_get_bitmap1_return
    jmp __b3
    // [1605] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
  __b12:
    // [1605] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = 4 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@1->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #4
    sta vera_sprite_zdepth_get_bitmap1_return
    jmp __b3
    // [1605] phi from sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2 to sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return]
  __b13:
    // [1605] phi sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 = 8 [phi:sprite_map_header::vera_sprite_zdepth_get_bitmap1_@2->sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #8
    sta vera_sprite_zdepth_get_bitmap1_return
    // sprite_map_header::vera_sprite_zdepth_get_bitmap1_@return
    // sprite_map_header::@3
  __b3:
    // sprites.Zdepth[sprite] = vera_sprite_zdepth_get_bitmap(sprite_file_header->zdepth)
    // [1606] ((char *)&sprites+$100)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_zdepth_get_bitmap1_return#5 -- pbuc1_derefidx_vbum1=vbum2 
    lda vera_sprite_zdepth_get_bitmap1_return
    ldy sprite
    sta sprites+$100,y
    // vera_sprite_hflip_get_bitmap(sprite_file_header->hflip)
    // [1607] sprite_map_header::vera_sprite_hflip_get_bitmap1_hflip#0 = *((char *)sprite_map_header::sprite_file_header#0+6) -- vbum1=_deref_pbuc1 
    lda sprite_file_header+6
    sta vera_sprite_hflip_get_bitmap1_hflip
    // sprite_map_header::vera_sprite_hflip_get_bitmap1
    // case 0:
    //             return VERA_SPRITE_NFLIP;
    // [1608] if(sprite_map_header::vera_sprite_hflip_get_bitmap1_hflip#0==0) goto sprite_map_header::vera_sprite_hflip_get_bitmap1_@return -- vbum1_eq_0_then_la1 
    beq __b14
    // sprite_map_header::vera_sprite_hflip_get_bitmap1_@1
    // case 1:
    //             return VERA_SPRITE_HFLIP;
    //         other:
    // [1609] if(sprite_map_header::vera_sprite_hflip_get_bitmap1_hflip#0==1) goto sprite_map_header::vera_sprite_hflip_get_bitmap1_@5 -- vbum1_eq_vbuc1_then_la1 
    lda #1
    cmp vera_sprite_hflip_get_bitmap1_hflip
    beq vera_sprite_hflip_get_bitmap1___b5
    // [1611] phi from sprite_map_header::vera_sprite_hflip_get_bitmap1 sprite_map_header::vera_sprite_hflip_get_bitmap1_@1 to sprite_map_header::vera_sprite_hflip_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1/sprite_map_header::vera_sprite_hflip_get_bitmap1_@1->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return]
  __b14:
    // [1611] phi sprite_map_header::vera_sprite_hflip_get_bitmap1_return#3 = 0 [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1/sprite_map_header::vera_sprite_hflip_get_bitmap1_@1->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #0
    sta vera_sprite_hflip_get_bitmap1_return
    jmp __b4
    // [1610] phi from sprite_map_header::vera_sprite_hflip_get_bitmap1_@1 to sprite_map_header::vera_sprite_hflip_get_bitmap1_@5 [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1_@1->sprite_map_header::vera_sprite_hflip_get_bitmap1_@5]
    // sprite_map_header::vera_sprite_hflip_get_bitmap1_@5
  vera_sprite_hflip_get_bitmap1___b5:
    // [1611] phi from sprite_map_header::vera_sprite_hflip_get_bitmap1_@5 to sprite_map_header::vera_sprite_hflip_get_bitmap1_@return [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1_@5->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return]
    // [1611] phi sprite_map_header::vera_sprite_hflip_get_bitmap1_return#3 = 1 [phi:sprite_map_header::vera_sprite_hflip_get_bitmap1_@5->sprite_map_header::vera_sprite_hflip_get_bitmap1_@return#0] -- vbum1=vbuc1 
    lda #1
    sta vera_sprite_hflip_get_bitmap1_return
    // sprite_map_header::vera_sprite_hflip_get_bitmap1_@return
    // sprite_map_header::@4
  __b4:
    // sprites.Hflip[sprite] = vera_sprite_hflip_get_bitmap(sprite_file_header->hflip)
    // [1612] ((char *)&sprites+$120)[sprite_map_header::sprite#0] = sprite_map_header::vera_sprite_hflip_get_bitmap1_return#3 -- pbuc1_derefidx_vbum1=vbum2 
    lda vera_sprite_hflip_get_bitmap1_return
    ldy sprite
    sta sprites+$120,y
    // vera_sprite_vflip_get_bitmap(sprite_file_header->vflip)
    // [1613] vera_sprite_vflip_get_bitmap::vflip#0 = *((char *)sprite_map_header::sprite_file_header#0+7) -- vbum1=_deref_pbuc1 
    lda sprite_file_header+7
    sta vera_sprite_vflip_get_bitmap.vflip
    // [1614] call vera_sprite_vflip_get_bitmap
    jsr vera_sprite_vflip_get_bitmap
    // [1615] vera_sprite_vflip_get_bitmap::return#4 = vera_sprite_vflip_get_bitmap::return#3
    // sprite_map_header::@5
    // [1616] sprite_map_header::$4 = vera_sprite_vflip_get_bitmap::return#4 -- vbum1=vbum2 
    lda vera_sprite_vflip_get_bitmap.return
    sta sprite_map_header__4
    // sprites.Vflip[sprite] = vera_sprite_vflip_get_bitmap(sprite_file_header->vflip)
    // [1617] ((char *)&sprites+$140)[sprite_map_header::sprite#0] = sprite_map_header::$4 -- pbuc1_derefidx_vbum1=vbum2 
    ldy sprite
    sta sprites+$140,y
    // vera_sprite_bpp_get_bitmap(sprite_file_header->bpp)
    // [1618] vera_sprite_bpp_get_bitmap::bpp#0 = *((char *)sprite_map_header::sprite_file_header#0+8) -- vbum1=_deref_pbuc1 
    lda sprite_file_header+8
    sta vera_sprite_bpp_get_bitmap.bpp
    // [1619] call vera_sprite_bpp_get_bitmap
    jsr vera_sprite_bpp_get_bitmap
    // [1620] vera_sprite_bpp_get_bitmap::return#4 = vera_sprite_bpp_get_bitmap::return#3
    // sprite_map_header::@6
    // [1621] sprite_map_header::$5 = vera_sprite_bpp_get_bitmap::return#4 -- vbum1=vbum2 
    lda vera_sprite_bpp_get_bitmap.return
    sta sprite_map_header__5
    // sprites.BPP[sprite] = vera_sprite_bpp_get_bitmap(sprite_file_header->bpp)
    // [1622] ((char *)&sprites+$160)[sprite_map_header::sprite#0] = sprite_map_header::$5 -- pbuc1_derefidx_vbum1=vbum2 
    ldy sprite
    sta sprites+$160,y
    // sprites.reverse[sprite] = sprite_file_header->reverse
    // [1623] ((char *)&sprites+$1a0)[sprite_map_header::sprite#0] = *((char *)sprite_map_header::sprite_file_header#0+$a) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    lda sprite_file_header+$a
    sta sprites+$1a0,y
    // sprites.aabb[sprite].xmin = sprite_file_header->collision
    // [1624] sprite_map_header::$10 = sprite_map_header::sprite#0 << 2 -- vbum1=vbum2_rol_2 
    tya
    asl
    asl
    sta sprite_map_header__10
    // [1625] ((char *)(struct $17 *)&sprites+$1c0)[sprite_map_header::$10] = *((char *)sprite_map_header::sprite_file_header#0+9) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    lda sprite_file_header+9
    ldy sprite_map_header__10
    sta sprites+$1c0,y
    // sprites.aabb[sprite].ymin = sprite_file_header->collision
    // [1626] ((char *)(struct $17 *)&sprites+$1c0+1)[sprite_map_header::$10] = *((char *)sprite_map_header::sprite_file_header#0+9) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    sta sprites+$1c0+1,y
    // sprite_file_header->width - sprite_file_header->collision
    // [1627] sprite_map_header::$6 = *((char *)sprite_map_header::sprite_file_header#0+3) - *((char *)sprite_map_header::sprite_file_header#0+9) -- vbum1=_deref_pbuc1_minus__deref_pbuc2 
    lda sprite_file_header+3
    sec
    sbc sprite_file_header+9
    sta sprite_map_header__6
    // sprites.aabb[sprite].xmax = sprite_file_header->width - sprite_file_header->collision
    // [1628] ((char *)(struct $17 *)&sprites+$1c0+2)[sprite_map_header::$10] = sprite_map_header::$6 -- pbuc1_derefidx_vbum1=vbum2 
    sta sprites+$1c0+2,y
    // sprite_file_header->height - sprite_file_header->collision
    // [1629] sprite_map_header::$7 = *((char *)sprite_map_header::sprite_file_header#0+4) - *((char *)sprite_map_header::sprite_file_header#0+9) -- vbum1=_deref_pbuc1_minus__deref_pbuc2 
    lda sprite_file_header+4
    sec
    sbc sprite_file_header+9
    sta sprite_map_header__7
    // sprites.aabb[sprite].ymax = sprite_file_header->height - sprite_file_header->collision
    // [1630] ((char *)(struct $17 *)&sprites+$1c0+3)[sprite_map_header::$10] = sprite_map_header::$7 -- pbuc1_derefidx_vbum1=vbum2 
    sta sprites+$1c0+3,y
    // sprites.PaletteOffset[sprite] = 0
    // [1631] ((char *)&sprites+$180)[sprite_map_header::sprite#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy sprite
    sta sprites+$180,y
    // sprites.loop[sprite] = sprite_file_header->loop
    // [1632] ((char *)&sprites+$280)[sprite_map_header::sprite#0] = *((char *)sprite_map_header::sprite_file_header#0+$b) -- pbuc1_derefidx_vbum1=_deref_pbuc2 
    lda sprite_file_header+$b
    sta sprites+$280,y
    // sprites.sprite_cache[sprite] = 0
    // [1633] ((char *)&sprites+$2a0)[sprite_map_header::sprite#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta sprites+$2a0,y
    // sprite_map_header::@return
    // }
    // [1634] return 
    rts
  .segment DataEngineFlight
    sprite_map_header__4: .byte 0
    sprite_map_header__5: .byte 0
    sprite_map_header__6: .byte 0
    sprite_map_header__7: .byte 0
    sprite_map_header__8: .byte 0
    sprite_map_header__10: .byte 0
    sprite: .byte 0
  .segment Data
    vera_sprite_width_get_bitmap1_width: .byte 0
    vera_sprite_width_get_bitmap1_return: .byte 0
    vera_sprite_height_get_bitmap1_height: .byte 0
    vera_sprite_height_get_bitmap1_return: .byte 0
    vera_sprite_zdepth_get_bitmap1_zdepth: .byte 0
    vera_sprite_zdepth_get_bitmap1_return: .byte 0
    vera_sprite_hflip_get_bitmap1_hflip: .byte 0
    vera_sprite_hflip_get_bitmap1_return: .byte 0
}
.segment Code
  // printf_str
/// Print a NUL-terminated string
// void printf_str(__zp($2d) void (*putc)(char), __zp($22) const char *s)
printf_str: {
    .label s = $22
    .label putc = $2d
    // [1636] phi from printf_str printf_str::@2 to printf_str::@1 [phi:printf_str/printf_str::@2->printf_str::@1]
    // [1636] phi printf_str::s#8 = printf_str::s#9 [phi:printf_str/printf_str::@2->printf_str::@1#0] -- register_copy 
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [1637] printf_str::c#1 = *printf_str::s#8 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta c
    // [1638] printf_str::s#0 = ++ printf_str::s#8 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [1639] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbum1_then_la1 
    lda c
    bne __b2
    // printf_str::@return
    // }
    // [1640] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [1641] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbum1 
    lda c
    pha
    // [1642] callexecute *printf_str::putc#9  -- call__deref_pprz1 
    jsr icall1
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
    // Outside Flow
  icall1:
    jmp (putc)
  .segment Data
    c: .byte 0
}
.segment Code
  // printf_uchar
// Print an unsigned char using a specific format
// void printf_uchar(void (*putc)(char), __mem() char uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_uchar: {
    // printf_uchar::@1
    // printf_buffer.sign = format_sign_always?'+':0
    // [1645] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // uctoa(uvalue, printf_buffer.digits, format_radix)
    // [1646] uctoa::value#1 = printf_uchar::uvalue#2
    // [1647] call uctoa
  // Format number into buffer
    // [1712] phi from printf_uchar::@1 to uctoa [phi:printf_uchar::@1->uctoa]
    jsr uctoa
    // printf_uchar::@2
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [1648] printf_number_buffer::buffer_sign#1 = *((char *)&printf_buffer) -- vbum1=_deref_pbuc1 
    lda printf_buffer
    sta printf_number_buffer.buffer_sign
    // [1649] call printf_number_buffer
  // Print using format
    // [1731] phi from printf_uchar::@2 to printf_number_buffer [phi:printf_uchar::@2->printf_number_buffer]
    // [1731] phi printf_number_buffer::format_upper_case#10 = 0 [phi:printf_uchar::@2->printf_number_buffer#0] -- vbum1=vbuc1 
    lda #0
    sta printf_number_buffer.format_upper_case
    // [1731] phi printf_number_buffer::putc#10 = &cputc [phi:printf_uchar::@2->printf_number_buffer#1] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_number_buffer.putc
    lda #>cputc
    sta.z printf_number_buffer.putc+1
    // [1731] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#1 [phi:printf_uchar::@2->printf_number_buffer#2] -- register_copy 
    // [1731] phi printf_number_buffer::format_zero_padding#10 = 0 [phi:printf_uchar::@2->printf_number_buffer#3] -- vbum1=vbuc1 
    lda #0
    sta printf_number_buffer.format_zero_padding
    // [1731] phi printf_number_buffer::format_justify_left#10 = 0 [phi:printf_uchar::@2->printf_number_buffer#4] -- vbum1=vbuc1 
    sta printf_number_buffer.format_justify_left
    // [1731] phi printf_number_buffer::format_min_length#2 = 0 [phi:printf_uchar::@2->printf_number_buffer#5] -- vbum1=vbuc1 
    sta printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // printf_uchar::@return
    // }
    // [1650] return 
    rts
  .segment Data
    uvalue: .byte 0
}
.segment Code
  // printf_uint
// Print an unsigned int using a specific format
// void printf_uint(void (*putc)(char), __mem() unsigned int uvalue, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_uint: {
    .const format_min_length = 0
    .const format_justify_left = 0
    .const format_zero_padding = 0
    .const format_upper_case = 0
    .label putc = cputc
    // printf_uint::@1
    // printf_buffer.sign = format_sign_always?'+':0
    // [1652] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // void printf_uint(void (*putc)(char), unsigned int uvalue, struct printf_format_number format) {
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format_radix)
    // [1653] utoa::value#1 = printf_uint::uvalue#0
    // [1654] call utoa
  // Format number into buffer
    // [1772] phi from printf_uint::@1 to utoa [phi:printf_uint::@1->utoa]
    jsr utoa
    // printf_uint::@2
    // printf_number_buffer(putc, printf_buffer, format_min_length, format_justify_left, format_sign_always, format_zero_padding, format_upper_case, format_radix)
    // [1655] printf_number_buffer::buffer_sign#0 = *((char *)&printf_buffer) -- vbum1=_deref_pbuc1 
    lda printf_buffer
    sta printf_number_buffer.buffer_sign
    // [1656] call printf_number_buffer
  // Print using format
    // [1731] phi from printf_uint::@2 to printf_number_buffer [phi:printf_uint::@2->printf_number_buffer]
    // [1731] phi printf_number_buffer::format_upper_case#10 = printf_uint::format_upper_case#0 [phi:printf_uint::@2->printf_number_buffer#0] -- vbum1=vbuc1 
    lda #format_upper_case
    sta printf_number_buffer.format_upper_case
    // [1731] phi printf_number_buffer::putc#10 = printf_uint::putc#0 [phi:printf_uint::@2->printf_number_buffer#1] -- pprz1=pprc1 
    lda #<putc
    sta.z printf_number_buffer.putc
    lda #>putc
    sta.z printf_number_buffer.putc+1
    // [1731] phi printf_number_buffer::buffer_sign#10 = printf_number_buffer::buffer_sign#0 [phi:printf_uint::@2->printf_number_buffer#2] -- register_copy 
    // [1731] phi printf_number_buffer::format_zero_padding#10 = printf_uint::format_zero_padding#0 [phi:printf_uint::@2->printf_number_buffer#3] -- vbum1=vbuc1 
    lda #format_zero_padding
    sta printf_number_buffer.format_zero_padding
    // [1731] phi printf_number_buffer::format_justify_left#10 = printf_uint::format_justify_left#0 [phi:printf_uint::@2->printf_number_buffer#4] -- vbum1=vbuc1 
    lda #format_justify_left
    sta printf_number_buffer.format_justify_left
    // [1731] phi printf_number_buffer::format_min_length#2 = printf_uint::format_min_length#0 [phi:printf_uint::@2->printf_number_buffer#5] -- vbum1=vbuc1 
    lda #format_min_length
    sta printf_number_buffer.format_min_length
    jsr printf_number_buffer
    // printf_uint::@return
    // }
    // [1657] return 
    rts
  .segment Data
    .label uvalue = utoa.value
}
.segment Code
  // vera_sprite_height
// void vera_sprite_height(__mem() unsigned int sprite_offset, __mem() char height)
vera_sprite_height: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0)
    // [1658] vera_sprite_height::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_height::sprite_offset#0 + 7 -- vwum1=vwum1_plus_vbuc1 
    lda #7
    clc
    adc vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_offset
    bcc !+
    inc vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_height::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1659] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1660] vera_sprite_height::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_height::vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte0_vwum2 
    lda vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_vera_sprite_height__0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1661] *VERA_ADDRX_L = vera_sprite_height::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1662] vera_sprite_height::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_height::vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte1_vwum2 
    lda vera_vram_data0_bank_offset1_offset+1
    sta vera_vram_data0_bank_offset1_vera_sprite_height__1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1663] *VERA_ADDRX_M = vera_sprite_height::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [1664] *VERA_ADDRX_H = vera_sprite_height::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_height::@1
    // *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [1665] vera_sprite_height::$2 = *VERA_DATA0 & ~$c0 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$c0^$ff
    and VERA_DATA0
    sta vera_sprite_height__2
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_HEIGHT_MASK
    // [1666] *VERA_DATA0 = vera_sprite_height::$2 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // *VERA_DATA0 |= height
    // [1667] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_height::height#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbum1 
    ora height
    sta VERA_DATA0
    // vera_sprite_height::@return
    // }
    // [1668] return 
    rts
  .segment Data
    vera_sprite_height__2: .byte 0
    vera_vram_data0_bank_offset1_vera_sprite_height__0: .byte 0
    vera_vram_data0_bank_offset1_vera_sprite_height__1: .byte 0
    .label vera_vram_data0_bank_offset1_offset = sprite_offset
    sprite_offset: .word 0
    height: .byte 0
}
.segment Code
  // vera_sprite_width
// void vera_sprite_width(__mem() unsigned int sprite_offset, __mem() char width)
vera_sprite_width: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+7, vera_inc_0)
    // [1669] vera_sprite_width::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_width::sprite_offset#0 + 7 -- vwum1=vwum1_plus_vbuc1 
    lda #7
    clc
    adc vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_offset
    bcc !+
    inc vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_width::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1670] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1671] vera_sprite_width::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_width::vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte0_vwum2 
    lda vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_vera_sprite_width__0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1672] *VERA_ADDRX_L = vera_sprite_width::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1673] vera_sprite_width::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_width::vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte1_vwum2 
    lda vera_vram_data0_bank_offset1_offset+1
    sta vera_vram_data0_bank_offset1_vera_sprite_width__1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1674] *VERA_ADDRX_M = vera_sprite_width::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [1675] *VERA_ADDRX_H = vera_sprite_width::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_width::@1
    // *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [1676] vera_sprite_width::$2 = *VERA_DATA0 & ~$30 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #$30^$ff
    and VERA_DATA0
    sta vera_sprite_width__2
    // *VERA_DATA0 = *VERA_DATA0 & ~VERA_SPRITE_WIDTH_MASK
    // [1677] *VERA_DATA0 = vera_sprite_width::$2 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // *VERA_DATA0 |= width
    // [1678] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_width::width#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbum1 
    ora width
    sta VERA_DATA0
    // vera_sprite_width::@return
    // }
    // [1679] return 
    rts
  .segment Data
    vera_sprite_width__2: .byte 0
    vera_vram_data0_bank_offset1_vera_sprite_width__0: .byte 0
    vera_vram_data0_bank_offset1_vera_sprite_width__1: .byte 0
    .label vera_vram_data0_bank_offset1_offset = sprite_offset
    sprite_offset: .word 0
    width: .byte 0
}
.segment Code
  // vera_sprite_hflip
// void vera_sprite_hflip(__mem() unsigned int sprite_offset, __mem() char hflip)
vera_sprite_hflip: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0)
    // [1680] vera_sprite_hflip::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_hflip::sprite_offset#0 + 6 -- vwum1=vwum1_plus_vbuc1 
    lda #6
    clc
    adc vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_offset
    bcc !+
    inc vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_hflip::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1681] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1682] vera_sprite_hflip::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_hflip::vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte0_vwum2 
    lda vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_vera_sprite_hflip__0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1683] *VERA_ADDRX_L = vera_sprite_hflip::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1684] vera_sprite_hflip::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_hflip::vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte1_vwum2 
    lda vera_vram_data0_bank_offset1_offset+1
    sta vera_vram_data0_bank_offset1_vera_sprite_hflip__1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1685] *VERA_ADDRX_M = vera_sprite_hflip::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [1686] *VERA_ADDRX_H = vera_sprite_hflip::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_hflip::@1
    // *VERA_DATA0 & ~VERA_SPRITE_HFLIP
    // [1687] vera_sprite_hflip::$2 = *VERA_DATA0 & ~1 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #1^$ff
    and VERA_DATA0
    sta vera_sprite_hflip__2
    // *VERA_DATA0 = (*VERA_DATA0 & ~VERA_SPRITE_HFLIP)
    // [1688] *VERA_DATA0 = vera_sprite_hflip::$2 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // *VERA_DATA0 |= hflip
    // [1689] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_hflip::hflip#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbum1 
    ora hflip
    sta VERA_DATA0
    // vera_sprite_hflip::@return
    // }
    // [1690] return 
    rts
  .segment Data
    vera_sprite_hflip__2: .byte 0
    vera_vram_data0_bank_offset1_vera_sprite_hflip__0: .byte 0
    vera_vram_data0_bank_offset1_vera_sprite_hflip__1: .byte 0
    .label vera_vram_data0_bank_offset1_offset = sprite_offset
    sprite_offset: .word 0
    hflip: .byte 0
}
.segment Code
  // vera_sprite_vflip
// void vera_sprite_vflip(__mem() unsigned int sprite_offset, __mem() char vflip)
vera_sprite_vflip: {
    .const vera_vram_data0_bank_offset1_bank = <VERA_SPRITE_ATTR>>$10
    // vera_vram_data0_bank_offset(BYTE2(VERA_SPRITE_ATTR), sprite_offset+6, vera_inc_0)
    // [1691] vera_sprite_vflip::vera_vram_data0_bank_offset1_offset#0 = vera_sprite_vflip::sprite_offset#0 + 6 -- vwum1=vwum1_plus_vbuc1 
    lda #6
    clc
    adc vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_offset
    bcc !+
    inc vera_vram_data0_bank_offset1_offset+1
  !:
    // vera_sprite_vflip::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [1692] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [1693] vera_sprite_vflip::vera_vram_data0_bank_offset1_$0 = byte0  vera_sprite_vflip::vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte0_vwum2 
    lda vera_vram_data0_bank_offset1_offset
    sta vera_vram_data0_bank_offset1_vera_sprite_vflip__0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [1694] *VERA_ADDRX_L = vera_sprite_vflip::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [1695] vera_sprite_vflip::vera_vram_data0_bank_offset1_$1 = byte1  vera_sprite_vflip::vera_vram_data0_bank_offset1_offset#0 -- vbum1=_byte1_vwum2 
    lda vera_vram_data0_bank_offset1_offset+1
    sta vera_vram_data0_bank_offset1_vera_sprite_vflip__1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [1696] *VERA_ADDRX_M = vera_sprite_vflip::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbum1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [1697] *VERA_ADDRX_H = vera_sprite_vflip::vera_vram_data0_bank_offset1_bank#0 -- _deref_pbuc1=vbuc2 
    lda #vera_vram_data0_bank_offset1_bank
    sta VERA_ADDRX_H
    // vera_sprite_vflip::@1
    // *VERA_DATA0 & ~VERA_SPRITE_VFLIP
    // [1698] vera_sprite_vflip::$2 = *VERA_DATA0 & ~2 -- vbum1=_deref_pbuc1_band_vbuc2 
    lda #2^$ff
    and VERA_DATA0
    sta vera_sprite_vflip__2
    // *VERA_DATA0 = (*VERA_DATA0 & ~VERA_SPRITE_VFLIP)
    // [1699] *VERA_DATA0 = vera_sprite_vflip::$2 -- _deref_pbuc1=vbum1 
    sta VERA_DATA0
    // *VERA_DATA0 |= vflip
    // [1700] *VERA_DATA0 = *VERA_DATA0 | vera_sprite_vflip::vflip#0 -- _deref_pbuc1=_deref_pbuc1_bor_vbum1 
    ora vflip
    sta VERA_DATA0
    // vera_sprite_vflip::@return
    // }
    // [1701] return 
    rts
  .segment Data
    vera_sprite_vflip__2: .byte 0
    vera_vram_data0_bank_offset1_vera_sprite_vflip__0: .byte 0
    vera_vram_data0_bank_offset1_vera_sprite_vflip__1: .byte 0
    .label vera_vram_data0_bank_offset1_offset = sprite_offset
    sprite_offset: .word 0
    vflip: .byte 0
}
.segment Code
  // vera_sprite_vflip_get_bitmap
// __mem() char vera_sprite_vflip_get_bitmap(__mem() char vflip)
vera_sprite_vflip_get_bitmap: {
    // case 0:
    //             return VERA_SPRITE_NFLIP;
    // [1702] if(vera_sprite_vflip_get_bitmap::vflip#0==0) goto vera_sprite_vflip_get_bitmap::@return -- vbum1_eq_0_then_la1 
    lda vflip
    beq __b1
    // vera_sprite_vflip_get_bitmap::@1
    // case 1:
    //             return VERA_SPRITE_VFLIP;
    //         other:
    // [1703] if(vera_sprite_vflip_get_bitmap::vflip#0==1) goto vera_sprite_vflip_get_bitmap::@2 -- vbum1_eq_vbuc1_then_la1 
    lda #1
    cmp vflip
    beq __b2
    // [1705] phi from vera_sprite_vflip_get_bitmap vera_sprite_vflip_get_bitmap::@1 to vera_sprite_vflip_get_bitmap::@return [phi:vera_sprite_vflip_get_bitmap/vera_sprite_vflip_get_bitmap::@1->vera_sprite_vflip_get_bitmap::@return]
  __b1:
    // [1705] phi vera_sprite_vflip_get_bitmap::return#3 = 0 [phi:vera_sprite_vflip_get_bitmap/vera_sprite_vflip_get_bitmap::@1->vera_sprite_vflip_get_bitmap::@return#0] -- vbum1=vbuc1 
    lda #0
    sta return
    rts
    // [1704] phi from vera_sprite_vflip_get_bitmap::@1 to vera_sprite_vflip_get_bitmap::@2 [phi:vera_sprite_vflip_get_bitmap::@1->vera_sprite_vflip_get_bitmap::@2]
    // vera_sprite_vflip_get_bitmap::@2
  __b2:
    // [1705] phi from vera_sprite_vflip_get_bitmap::@2 to vera_sprite_vflip_get_bitmap::@return [phi:vera_sprite_vflip_get_bitmap::@2->vera_sprite_vflip_get_bitmap::@return]
    // [1705] phi vera_sprite_vflip_get_bitmap::return#3 = 2 [phi:vera_sprite_vflip_get_bitmap::@2->vera_sprite_vflip_get_bitmap::@return#0] -- vbum1=vbuc1 
    lda #2
    sta return
    // vera_sprite_vflip_get_bitmap::@return
    // }
    // [1706] return 
    rts
  .segment Data
    return: .byte 0
    vflip: .byte 0
}
.segment Code
  // vera_sprite_bpp_get_bitmap
// __mem() char vera_sprite_bpp_get_bitmap(__mem() char bpp)
vera_sprite_bpp_get_bitmap: {
    // case 4:
    //             return VERA_SPRITE_4BPP;
    // [1707] if(vera_sprite_bpp_get_bitmap::bpp#0==4) goto vera_sprite_bpp_get_bitmap::@return -- vbum1_eq_vbuc1_then_la1 
    lda #4
    cmp bpp
    beq __b1
    // vera_sprite_bpp_get_bitmap::@1
    // case 8:
    //             return VERA_SPRITE_8BPP;
    //         other:
    // [1708] if(vera_sprite_bpp_get_bitmap::bpp#0==8) goto vera_sprite_bpp_get_bitmap::@2 -- vbum1_eq_vbuc1_then_la1 
    lda #8
    cmp bpp
    beq __b2
    // [1710] phi from vera_sprite_bpp_get_bitmap vera_sprite_bpp_get_bitmap::@1 to vera_sprite_bpp_get_bitmap::@return [phi:vera_sprite_bpp_get_bitmap/vera_sprite_bpp_get_bitmap::@1->vera_sprite_bpp_get_bitmap::@return]
  __b1:
    // [1710] phi vera_sprite_bpp_get_bitmap::return#3 = 0 [phi:vera_sprite_bpp_get_bitmap/vera_sprite_bpp_get_bitmap::@1->vera_sprite_bpp_get_bitmap::@return#0] -- vbum1=vbuc1 
    lda #0
    sta return
    rts
    // [1709] phi from vera_sprite_bpp_get_bitmap::@1 to vera_sprite_bpp_get_bitmap::@2 [phi:vera_sprite_bpp_get_bitmap::@1->vera_sprite_bpp_get_bitmap::@2]
    // vera_sprite_bpp_get_bitmap::@2
  __b2:
    // [1710] phi from vera_sprite_bpp_get_bitmap::@2 to vera_sprite_bpp_get_bitmap::@return [phi:vera_sprite_bpp_get_bitmap::@2->vera_sprite_bpp_get_bitmap::@return]
    // [1710] phi vera_sprite_bpp_get_bitmap::return#3 = $80 [phi:vera_sprite_bpp_get_bitmap::@2->vera_sprite_bpp_get_bitmap::@return#0] -- vbum1=vbuc1 
    lda #$80
    sta return
    // vera_sprite_bpp_get_bitmap::@return
    // }
    // [1711] return 
    rts
  .segment Data
    return: .byte 0
    bpp: .byte 0
}
.segment Code
  // uctoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void uctoa(__mem() char value, __zp($22) char *buffer, char radix)
uctoa: {
    .label buffer = $22
    // [1713] phi from uctoa to uctoa::@1 [phi:uctoa->uctoa::@1]
    // [1713] phi uctoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:uctoa->uctoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [1713] phi uctoa::started#2 = 0 [phi:uctoa->uctoa::@1#1] -- vbum1=vbuc1 
    lda #0
    sta started
    // [1713] phi uctoa::value#2 = uctoa::value#1 [phi:uctoa->uctoa::@1#2] -- register_copy 
    // [1713] phi uctoa::digit#2 = 0 [phi:uctoa->uctoa::@1#3] -- vbum1=vbuc1 
    sta digit
    // uctoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1714] if(uctoa::digit#2<3-1) goto uctoa::@2 -- vbum1_lt_vbuc1_then_la1 
    lda digit
    cmp #3-1
    bcc __b2
    // uctoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [1715] *uctoa::buffer#11 = DIGITS[uctoa::value#2] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    ldy value
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1716] uctoa::buffer#3 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1717] *uctoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // uctoa::@return
    // }
    // [1718] return 
    rts
    // uctoa::@2
  __b2:
    // unsigned char digit_value = digit_values[digit]
    // [1719] uctoa::digit_value#0 = RADIX_DECIMAL_VALUES_CHAR[uctoa::digit#2] -- vbum1=pbuc1_derefidx_vbum2 
    ldy digit
    lda RADIX_DECIMAL_VALUES_CHAR,y
    sta digit_value
    // if (started || value >= digit_value)
    // [1720] if(0!=uctoa::started#2) goto uctoa::@5 -- 0_neq_vbum1_then_la1 
    lda started
    bne __b5
    // uctoa::@7
    // [1721] if(uctoa::value#2>=uctoa::digit_value#0) goto uctoa::@5 -- vbum1_ge_vbum2_then_la1 
    lda value
    cmp digit_value
    bcs __b5
    // [1722] phi from uctoa::@7 to uctoa::@4 [phi:uctoa::@7->uctoa::@4]
    // [1722] phi uctoa::buffer#14 = uctoa::buffer#11 [phi:uctoa::@7->uctoa::@4#0] -- register_copy 
    // [1722] phi uctoa::started#4 = uctoa::started#2 [phi:uctoa::@7->uctoa::@4#1] -- register_copy 
    // [1722] phi uctoa::value#6 = uctoa::value#2 [phi:uctoa::@7->uctoa::@4#2] -- register_copy 
    // uctoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1723] uctoa::digit#1 = ++ uctoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [1713] phi from uctoa::@4 to uctoa::@1 [phi:uctoa::@4->uctoa::@1]
    // [1713] phi uctoa::buffer#11 = uctoa::buffer#14 [phi:uctoa::@4->uctoa::@1#0] -- register_copy 
    // [1713] phi uctoa::started#2 = uctoa::started#4 [phi:uctoa::@4->uctoa::@1#1] -- register_copy 
    // [1713] phi uctoa::value#2 = uctoa::value#6 [phi:uctoa::@4->uctoa::@1#2] -- register_copy 
    // [1713] phi uctoa::digit#2 = uctoa::digit#1 [phi:uctoa::@4->uctoa::@1#3] -- register_copy 
    jmp __b1
    // uctoa::@5
  __b5:
    // uctoa_append(buffer++, value, digit_value)
    // [1724] uctoa_append::buffer#0 = uctoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z uctoa_append.buffer
    lda.z buffer+1
    sta.z uctoa_append.buffer+1
    // [1725] uctoa_append::value#0 = uctoa::value#2
    // [1726] uctoa_append::sub#0 = uctoa::digit_value#0
    // [1727] call uctoa_append
    // [1793] phi from uctoa::@5 to uctoa_append [phi:uctoa::@5->uctoa_append]
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // [1728] uctoa_append::return#0 = uctoa_append::value#2
    // uctoa::@6
    // value = uctoa_append(buffer++, value, digit_value)
    // [1729] uctoa::value#0 = uctoa_append::return#0
    // value = uctoa_append(buffer++, value, digit_value);
    // [1730] uctoa::buffer#4 = ++ uctoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1722] phi from uctoa::@6 to uctoa::@4 [phi:uctoa::@6->uctoa::@4]
    // [1722] phi uctoa::buffer#14 = uctoa::buffer#4 [phi:uctoa::@6->uctoa::@4#0] -- register_copy 
    // [1722] phi uctoa::started#4 = 1 [phi:uctoa::@6->uctoa::@4#1] -- vbum1=vbuc1 
    lda #1
    sta started
    // [1722] phi uctoa::value#6 = uctoa::value#0 [phi:uctoa::@6->uctoa::@4#2] -- register_copy 
    jmp __b4
  .segment Data
    digit_value: .byte 0
    digit: .byte 0
    .label value = printf_uchar.uvalue
    started: .byte 0
}
.segment Code
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(__zp($26) void (*putc)(char), __mem() char buffer_sign, char *buffer_digits, __mem() char format_min_length, __mem() char format_justify_left, char format_sign_always, __mem() char format_zero_padding, __mem() char format_upper_case, char format_radix)
printf_number_buffer: {
    .label putc = $26
    // if(format_min_length)
    // [1732] if(0==printf_number_buffer::format_min_length#2) goto printf_number_buffer::@1 -- 0_eq_vbum1_then_la1 
    lda format_min_length
    beq __b6
    // [1733] phi from printf_number_buffer to printf_number_buffer::@6 [phi:printf_number_buffer->printf_number_buffer::@6]
    // printf_number_buffer::@6
    // strlen(buffer.digits)
    // [1734] call strlen
    // [1217] phi from printf_number_buffer::@6 to strlen [phi:printf_number_buffer::@6->strlen]
    // [1217] phi strlen::str#7 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:printf_number_buffer::@6->strlen#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z strlen.str
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z strlen.str+1
    jsr strlen
    // strlen(buffer.digits)
    // [1735] strlen::return#3 = strlen::len#2
    // printf_number_buffer::@14
    // [1736] printf_number_buffer::$19 = strlen::return#3
    // signed char len = (signed char)strlen(buffer.digits)
    // [1737] printf_number_buffer::len#0 = (signed char)printf_number_buffer::$19 -- vbsm1=_sbyte_vwum2 
    // There is a minimum length - work out the padding
    lda printf_number_buffer__19
    sta len
    // if(buffer.sign)
    // [1738] if(0==printf_number_buffer::buffer_sign#10) goto printf_number_buffer::@13 -- 0_eq_vbum1_then_la1 
    lda buffer_sign
    beq __b13
    // printf_number_buffer::@7
    // len++;
    // [1739] printf_number_buffer::len#1 = ++ printf_number_buffer::len#0 -- vbsm1=_inc_vbsm1 
    inc len
    // [1740] phi from printf_number_buffer::@14 printf_number_buffer::@7 to printf_number_buffer::@13 [phi:printf_number_buffer::@14/printf_number_buffer::@7->printf_number_buffer::@13]
    // [1740] phi printf_number_buffer::len#2 = printf_number_buffer::len#0 [phi:printf_number_buffer::@14/printf_number_buffer::@7->printf_number_buffer::@13#0] -- register_copy 
    // printf_number_buffer::@13
  __b13:
    // padding = (signed char)format_min_length - len
    // [1741] printf_number_buffer::padding#1 = (signed char)printf_number_buffer::format_min_length#2 - printf_number_buffer::len#2 -- vbsm1=vbsm1_minus_vbsm2 
    lda padding
    sec
    sbc len
    sta padding
    // if(padding<0)
    // [1742] if(printf_number_buffer::padding#1>=0) goto printf_number_buffer::@21 -- vbsm1_ge_0_then_la1 
    cmp #0
    bpl __b1
    // [1744] phi from printf_number_buffer printf_number_buffer::@13 to printf_number_buffer::@1 [phi:printf_number_buffer/printf_number_buffer::@13->printf_number_buffer::@1]
  __b6:
    // [1744] phi printf_number_buffer::padding#10 = 0 [phi:printf_number_buffer/printf_number_buffer::@13->printf_number_buffer::@1#0] -- vbsm1=vbsc1 
    lda #0
    sta padding
    // [1743] phi from printf_number_buffer::@13 to printf_number_buffer::@21 [phi:printf_number_buffer::@13->printf_number_buffer::@21]
    // printf_number_buffer::@21
    // [1744] phi from printf_number_buffer::@21 to printf_number_buffer::@1 [phi:printf_number_buffer::@21->printf_number_buffer::@1]
    // [1744] phi printf_number_buffer::padding#10 = printf_number_buffer::padding#1 [phi:printf_number_buffer::@21->printf_number_buffer::@1#0] -- register_copy 
    // printf_number_buffer::@1
  __b1:
    // if(!format_justify_left && !format_zero_padding && padding)
    // [1745] if(0!=printf_number_buffer::format_justify_left#10) goto printf_number_buffer::@2 -- 0_neq_vbum1_then_la1 
    lda format_justify_left
    bne __b2
    // printf_number_buffer::@17
    // [1746] if(0!=printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@2 -- 0_neq_vbum1_then_la1 
    lda format_zero_padding
    bne __b2
    // printf_number_buffer::@16
    // [1747] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@8 -- 0_neq_vbsm1_then_la1 
    lda padding
    cmp #0
    bne __b8
    jmp __b2
    // printf_number_buffer::@8
  __b8:
    // printf_padding(putc, ' ',(char)padding)
    // [1748] printf_padding::putc#0 = printf_number_buffer::putc#10 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [1749] printf_padding::length#0 = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [1750] call printf_padding
    // [1800] phi from printf_number_buffer::@8 to printf_padding [phi:printf_number_buffer::@8->printf_padding]
    // [1800] phi printf_padding::putc#5 = printf_padding::putc#0 [phi:printf_number_buffer::@8->printf_padding#0] -- register_copy 
    // [1800] phi printf_padding::pad#5 = ' ' [phi:printf_number_buffer::@8->printf_padding#1] -- vbum1=vbuc1 
  .encoding "screencode_mixed"
    lda #' '
    sta printf_padding.pad
    // [1800] phi printf_padding::length#4 = printf_padding::length#0 [phi:printf_number_buffer::@8->printf_padding#2] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@2
  __b2:
    // if(buffer.sign)
    // [1751] if(0==printf_number_buffer::buffer_sign#10) goto printf_number_buffer::@3 -- 0_eq_vbum1_then_la1 
    lda buffer_sign
    beq __b3
    // printf_number_buffer::@9
    // putc(buffer.sign)
    // [1752] stackpush(char) = printf_number_buffer::buffer_sign#10 -- _stackpushbyte_=vbum1 
    pha
    // [1753] callexecute *printf_number_buffer::putc#10  -- call__deref_pprz1 
    jsr icall2
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_number_buffer::@3
  __b3:
    // if(format_zero_padding && padding)
    // [1755] if(0==printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@4 -- 0_eq_vbum1_then_la1 
    lda format_zero_padding
    beq __b4
    // printf_number_buffer::@18
    // [1756] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@10 -- 0_neq_vbsm1_then_la1 
    lda padding
    cmp #0
    bne __b10
    jmp __b4
    // printf_number_buffer::@10
  __b10:
    // printf_padding(putc, '0',(char)padding)
    // [1757] printf_padding::putc#1 = printf_number_buffer::putc#10 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [1758] printf_padding::length#1 = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [1759] call printf_padding
    // [1800] phi from printf_number_buffer::@10 to printf_padding [phi:printf_number_buffer::@10->printf_padding]
    // [1800] phi printf_padding::putc#5 = printf_padding::putc#1 [phi:printf_number_buffer::@10->printf_padding#0] -- register_copy 
    // [1800] phi printf_padding::pad#5 = '0' [phi:printf_number_buffer::@10->printf_padding#1] -- vbum1=vbuc1 
    lda #'0'
    sta printf_padding.pad
    // [1800] phi printf_padding::length#4 = printf_padding::length#1 [phi:printf_number_buffer::@10->printf_padding#2] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@4
  __b4:
    // if(format_upper_case)
    // [1760] if(0==printf_number_buffer::format_upper_case#10) goto printf_number_buffer::@5 -- 0_eq_vbum1_then_la1 
    lda format_upper_case
    beq __b5
    // [1761] phi from printf_number_buffer::@4 to printf_number_buffer::@11 [phi:printf_number_buffer::@4->printf_number_buffer::@11]
    // printf_number_buffer::@11
    // strupr(buffer.digits)
    // [1762] call strupr
    // [1808] phi from printf_number_buffer::@11 to strupr [phi:printf_number_buffer::@11->strupr]
    jsr strupr
    // printf_number_buffer::@5
  __b5:
    // printf_str(putc, buffer.digits)
    // [1763] printf_str::putc#0 = printf_number_buffer::putc#10 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_str.putc
    lda.z putc+1
    sta.z printf_str.putc+1
    // [1764] call printf_str
    // [1635] phi from printf_number_buffer::@5 to printf_str [phi:printf_number_buffer::@5->printf_str]
    // [1635] phi printf_str::putc#9 = printf_str::putc#0 [phi:printf_number_buffer::@5->printf_str#0] -- register_copy 
    // [1635] phi printf_str::s#9 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:printf_number_buffer::@5->printf_str#1] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.s
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z printf_str.s+1
    jsr printf_str
    // printf_number_buffer::@15
    // if(format_justify_left && !format_zero_padding && padding)
    // [1765] if(0==printf_number_buffer::format_justify_left#10) goto printf_number_buffer::@return -- 0_eq_vbum1_then_la1 
    lda format_justify_left
    beq __breturn
    // printf_number_buffer::@20
    // [1766] if(0!=printf_number_buffer::format_zero_padding#10) goto printf_number_buffer::@return -- 0_neq_vbum1_then_la1 
    lda format_zero_padding
    bne __breturn
    // printf_number_buffer::@19
    // [1767] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@12 -- 0_neq_vbsm1_then_la1 
    lda padding
    cmp #0
    bne __b12
    rts
    // printf_number_buffer::@12
  __b12:
    // printf_padding(putc, ' ',(char)padding)
    // [1768] printf_padding::putc#2 = printf_number_buffer::putc#10 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [1769] printf_padding::length#2 = (char)printf_number_buffer::padding#10 -- vbum1=vbum2 
    lda padding
    sta printf_padding.length
    // [1770] call printf_padding
    // [1800] phi from printf_number_buffer::@12 to printf_padding [phi:printf_number_buffer::@12->printf_padding]
    // [1800] phi printf_padding::putc#5 = printf_padding::putc#2 [phi:printf_number_buffer::@12->printf_padding#0] -- register_copy 
    // [1800] phi printf_padding::pad#5 = ' ' [phi:printf_number_buffer::@12->printf_padding#1] -- vbum1=vbuc1 
    lda #' '
    sta printf_padding.pad
    // [1800] phi printf_padding::length#4 = printf_padding::length#2 [phi:printf_number_buffer::@12->printf_padding#2] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@return
  __breturn:
    // }
    // [1771] return 
    rts
    // Outside Flow
  icall2:
    jmp (putc)
  .segment Data
    .label printf_number_buffer__19 = strlen.len
    buffer_sign: .byte 0
    len: .byte 0
    .label padding = format_min_length
    format_min_length: .byte 0
    format_zero_padding: .byte 0
    format_justify_left: .byte 0
    format_upper_case: .byte 0
}
.segment Code
  // utoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__mem() unsigned int value, __zp($26) char *buffer, char radix)
utoa: {
    .const max_digits = 4
    .label buffer = $26
    // [1773] phi from utoa to utoa::@1 [phi:utoa->utoa::@1]
    // [1773] phi utoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:utoa->utoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [1773] phi utoa::started#2 = 0 [phi:utoa->utoa::@1#1] -- vbum1=vbuc1 
    lda #0
    sta started
    // [1773] phi utoa::value#2 = utoa::value#1 [phi:utoa->utoa::@1#2] -- register_copy 
    // [1773] phi utoa::digit#2 = 0 [phi:utoa->utoa::@1#3] -- vbum1=vbuc1 
    sta digit
    // utoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1774] if(utoa::digit#2<utoa::max_digits#2-1) goto utoa::@2 -- vbum1_lt_vbuc1_then_la1 
    lda digit
    cmp #max_digits-1
    bcc __b2
    // utoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [1775] utoa::$11 = (char)utoa::value#2 -- vbum1=_byte_vwum2 
    lda value
    sta utoa__11
    // [1776] *utoa::buffer#11 = DIGITS[utoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [1777] utoa::buffer#3 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [1778] *utoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // utoa::@return
    // }
    // [1779] return 
    rts
    // utoa::@2
  __b2:
    // unsigned int digit_value = digit_values[digit]
    // [1780] utoa::$10 = utoa::digit#2 << 1 -- vbum1=vbum2_rol_1 
    lda digit
    asl
    sta utoa__10
    // [1781] utoa::digit_value#0 = RADIX_HEXADECIMAL_VALUES[utoa::$10] -- vwum1=pwuc1_derefidx_vbum2 
    tay
    lda RADIX_HEXADECIMAL_VALUES,y
    sta digit_value
    lda RADIX_HEXADECIMAL_VALUES+1,y
    sta digit_value+1
    // if (started || value >= digit_value)
    // [1782] if(0!=utoa::started#2) goto utoa::@5 -- 0_neq_vbum1_then_la1 
    lda started
    bne __b5
    // utoa::@7
    // [1783] if(utoa::value#2>=utoa::digit_value#0) goto utoa::@5 -- vwum1_ge_vwum2_then_la1 
    lda digit_value+1
    cmp value+1
    bne !+
    lda digit_value
    cmp value
    beq __b5
  !:
    bcc __b5
    // [1784] phi from utoa::@7 to utoa::@4 [phi:utoa::@7->utoa::@4]
    // [1784] phi utoa::buffer#14 = utoa::buffer#11 [phi:utoa::@7->utoa::@4#0] -- register_copy 
    // [1784] phi utoa::started#4 = utoa::started#2 [phi:utoa::@7->utoa::@4#1] -- register_copy 
    // [1784] phi utoa::value#6 = utoa::value#2 [phi:utoa::@7->utoa::@4#2] -- register_copy 
    // utoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [1785] utoa::digit#1 = ++ utoa::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // [1773] phi from utoa::@4 to utoa::@1 [phi:utoa::@4->utoa::@1]
    // [1773] phi utoa::buffer#11 = utoa::buffer#14 [phi:utoa::@4->utoa::@1#0] -- register_copy 
    // [1773] phi utoa::started#2 = utoa::started#4 [phi:utoa::@4->utoa::@1#1] -- register_copy 
    // [1773] phi utoa::value#2 = utoa::value#6 [phi:utoa::@4->utoa::@1#2] -- register_copy 
    // [1773] phi utoa::digit#2 = utoa::digit#1 [phi:utoa::@4->utoa::@1#3] -- register_copy 
    jmp __b1
    // utoa::@5
  __b5:
    // utoa_append(buffer++, value, digit_value)
    // [1786] utoa_append::buffer#0 = utoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z utoa_append.buffer
    lda.z buffer+1
    sta.z utoa_append.buffer+1
    // [1787] utoa_append::value#0 = utoa::value#2
    // [1788] utoa_append::sub#0 = utoa::digit_value#0
    // [1789] call utoa_append
    // [1818] phi from utoa::@5 to utoa_append [phi:utoa::@5->utoa_append]
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // [1790] utoa_append::return#0 = utoa_append::value#2
    // utoa::@6
    // value = utoa_append(buffer++, value, digit_value)
    // [1791] utoa::value#0 = utoa_append::return#0
    // value = utoa_append(buffer++, value, digit_value);
    // [1792] utoa::buffer#4 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [1784] phi from utoa::@6 to utoa::@4 [phi:utoa::@6->utoa::@4]
    // [1784] phi utoa::buffer#14 = utoa::buffer#4 [phi:utoa::@6->utoa::@4#0] -- register_copy 
    // [1784] phi utoa::started#4 = 1 [phi:utoa::@6->utoa::@4#1] -- vbum1=vbuc1 
    lda #1
    sta started
    // [1784] phi utoa::value#6 = utoa::value#0 [phi:utoa::@6->utoa::@4#2] -- register_copy 
    jmp __b4
  .segment Data
    utoa__10: .byte 0
    utoa__11: .byte 0
    digit_value: .word 0
    digit: .byte 0
    value: .word 0
    started: .byte 0
}
.segment Code
  // uctoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __mem() char uctoa_append(__zp($29) char *buffer, __mem() char value, __mem() char sub)
uctoa_append: {
    .label buffer = $29
    // [1794] phi from uctoa_append to uctoa_append::@1 [phi:uctoa_append->uctoa_append::@1]
    // [1794] phi uctoa_append::digit#2 = 0 [phi:uctoa_append->uctoa_append::@1#0] -- vbum1=vbuc1 
    lda #0
    sta digit
    // [1794] phi uctoa_append::value#2 = uctoa_append::value#0 [phi:uctoa_append->uctoa_append::@1#1] -- register_copy 
    // uctoa_append::@1
  __b1:
    // while (value >= sub)
    // [1795] if(uctoa_append::value#2>=uctoa_append::sub#0) goto uctoa_append::@2 -- vbum1_ge_vbum2_then_la1 
    lda value
    cmp sub
    bcs __b2
    // uctoa_append::@3
    // *buffer = DIGITS[digit]
    // [1796] *uctoa_append::buffer#0 = DIGITS[uctoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    ldy digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // uctoa_append::@return
    // }
    // [1797] return 
    rts
    // uctoa_append::@2
  __b2:
    // digit++;
    // [1798] uctoa_append::digit#1 = ++ uctoa_append::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // value -= sub
    // [1799] uctoa_append::value#1 = uctoa_append::value#2 - uctoa_append::sub#0 -- vbum1=vbum1_minus_vbum2 
    lda value
    sec
    sbc sub
    sta value
    // [1794] phi from uctoa_append::@2 to uctoa_append::@1 [phi:uctoa_append::@2->uctoa_append::@1]
    // [1794] phi uctoa_append::digit#2 = uctoa_append::digit#1 [phi:uctoa_append::@2->uctoa_append::@1#0] -- register_copy 
    // [1794] phi uctoa_append::value#2 = uctoa_append::value#1 [phi:uctoa_append::@2->uctoa_append::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label value = printf_uchar.uvalue
    .label sub = uctoa.digit_value
    .label return = printf_uchar.uvalue
    digit: .byte 0
}
.segment Code
  // printf_padding
// Print a padding char a number of times
// void printf_padding(__zp($24) void (*putc)(char), __mem() char pad, __mem() char length)
printf_padding: {
    .label putc = $24
    // [1801] phi from printf_padding to printf_padding::@1 [phi:printf_padding->printf_padding::@1]
    // [1801] phi printf_padding::i#2 = 0 [phi:printf_padding->printf_padding::@1#0] -- vbum1=vbuc1 
    lda #0
    sta i
    // printf_padding::@1
  __b1:
    // for(char i=0;i<length; i++)
    // [1802] if(printf_padding::i#2<printf_padding::length#4) goto printf_padding::@2 -- vbum1_lt_vbum2_then_la1 
    lda i
    cmp length
    bcc __b2
    // printf_padding::@return
    // }
    // [1803] return 
    rts
    // printf_padding::@2
  __b2:
    // putc(pad)
    // [1804] stackpush(char) = printf_padding::pad#5 -- _stackpushbyte_=vbum1 
    lda pad
    pha
    // [1805] callexecute *printf_padding::putc#5  -- call__deref_pprz1 
    jsr icall3
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_padding::@3
    // for(char i=0;i<length; i++)
    // [1807] printf_padding::i#1 = ++ printf_padding::i#2 -- vbum1=_inc_vbum1 
    inc i
    // [1801] phi from printf_padding::@3 to printf_padding::@1 [phi:printf_padding::@3->printf_padding::@1]
    // [1801] phi printf_padding::i#2 = printf_padding::i#1 [phi:printf_padding::@3->printf_padding::@1#0] -- register_copy 
    jmp __b1
    // Outside Flow
  icall3:
    jmp (putc)
  .segment Data
    i: .byte 0
    length: .byte 0
    pad: .byte 0
}
.segment Code
  // strupr
// Converts a string to uppercase.
// char * strupr(char *str)
strupr: {
    .label str = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label src = $24
    // [1809] phi from strupr to strupr::@1 [phi:strupr->strupr::@1]
    // [1809] phi strupr::src#2 = strupr::str#0 [phi:strupr->strupr::@1#0] -- pbuz1=pbuc1 
    lda #<str
    sta.z src
    lda #>str
    sta.z src+1
    // strupr::@1
  __b1:
    // while(*src)
    // [1810] if(0!=*strupr::src#2) goto strupr::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (src),y
    cmp #0
    bne __b2
    // strupr::@return
    // }
    // [1811] return 
    rts
    // strupr::@2
  __b2:
    // toupper(*src)
    // [1812] toupper::ch#0 = *strupr::src#2 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta toupper.ch
    // [1813] call toupper
    jsr toupper
    // [1814] toupper::return#3 = toupper::return#2
    // strupr::@3
    // [1815] strupr::$0 = toupper::return#3
    // *src = toupper(*src)
    // [1816] *strupr::src#2 = strupr::$0 -- _deref_pbuz1=vbum2 
    lda strupr__0
    ldy #0
    sta (src),y
    // src++;
    // [1817] strupr::src#1 = ++ strupr::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [1809] phi from strupr::@3 to strupr::@1 [phi:strupr::@3->strupr::@1]
    // [1809] phi strupr::src#2 = strupr::src#1 [phi:strupr::@3->strupr::@1#0] -- register_copy 
    jmp __b1
  .segment Data
    .label strupr__0 = toupper.return
}
.segment Code
  // utoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __mem() unsigned int utoa_append(__zp($29) char *buffer, __mem() unsigned int value, __mem() unsigned int sub)
utoa_append: {
    .label buffer = $29
    // [1819] phi from utoa_append to utoa_append::@1 [phi:utoa_append->utoa_append::@1]
    // [1819] phi utoa_append::digit#2 = 0 [phi:utoa_append->utoa_append::@1#0] -- vbum1=vbuc1 
    lda #0
    sta digit
    // [1819] phi utoa_append::value#2 = utoa_append::value#0 [phi:utoa_append->utoa_append::@1#1] -- register_copy 
    // utoa_append::@1
  __b1:
    // while (value >= sub)
    // [1820] if(utoa_append::value#2>=utoa_append::sub#0) goto utoa_append::@2 -- vwum1_ge_vwum2_then_la1 
    lda sub+1
    cmp value+1
    bne !+
    lda sub
    cmp value
    beq __b2
  !:
    bcc __b2
    // utoa_append::@3
    // *buffer = DIGITS[digit]
    // [1821] *utoa_append::buffer#0 = DIGITS[utoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbum2 
    ldy digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // utoa_append::@return
    // }
    // [1822] return 
    rts
    // utoa_append::@2
  __b2:
    // digit++;
    // [1823] utoa_append::digit#1 = ++ utoa_append::digit#2 -- vbum1=_inc_vbum1 
    inc digit
    // value -= sub
    // [1824] utoa_append::value#1 = utoa_append::value#2 - utoa_append::sub#0 -- vwum1=vwum1_minus_vwum2 
    lda value
    sec
    sbc sub
    sta value
    lda value+1
    sbc sub+1
    sta value+1
    // [1819] phi from utoa_append::@2 to utoa_append::@1 [phi:utoa_append::@2->utoa_append::@1]
    // [1819] phi utoa_append::digit#2 = utoa_append::digit#1 [phi:utoa_append::@2->utoa_append::@1#0] -- register_copy 
    // [1819] phi utoa_append::value#2 = utoa_append::value#1 [phi:utoa_append::@2->utoa_append::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label value = utoa.value
    .label sub = utoa.digit_value
    .label return = utoa.value
    digit: .byte 0
}
.segment Code
  // toupper
// Convert lowercase alphabet to uppercase
// Returns uppercase equivalent to c, if such value exists, else c remains unchanged
// __mem() char toupper(__mem() char ch)
toupper: {
    // if(ch>='a' && ch<='z')
    // [1825] if(toupper::ch#0<'a') goto toupper::@return -- vbum1_lt_vbuc1_then_la1 
    lda ch
    cmp #'a'
    bcc __breturn
    // toupper::@2
    // [1826] if(toupper::ch#0<='z') goto toupper::@1 -- vbum1_le_vbuc1_then_la1 
    lda #'z'
    cmp ch
    bcs __b1
    // [1828] phi from toupper toupper::@1 toupper::@2 to toupper::@return [phi:toupper/toupper::@1/toupper::@2->toupper::@return]
    // [1828] phi toupper::return#2 = toupper::ch#0 [phi:toupper/toupper::@1/toupper::@2->toupper::@return#0] -- register_copy 
    rts
    // toupper::@1
  __b1:
    // return ch + ('A'-'a');
    // [1827] toupper::return#0 = toupper::ch#0 + 'A'-'a' -- vbum1=vbum1_plus_vbuc1 
    lda #'A'-'a'
    clc
    adc return
    sta return
    // toupper::@return
  __breturn:
    // }
    // [1829] return 
    rts
  .segment Data
    return: .byte 0
    .label ch = return
}
  // File Data
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
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES_CHAR: .byte $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES: .word $1000, $100, $10
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
  __conio: .fill SIZEOF_STRUCT___1, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0
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
.segment DataSpriteCache
  // Cache to manage sprite control data fast, unbanked as making this banked will make things very, very complicated.
  sprite_cache: .fill SIZEOF_STRUCT___20, 0
.segment DataEngineFlight
  flight: .fill SIZEOF_STRUCT___48, 0
  sprite_cache_pool: .byte 0
  flight_sprite_offset_pool: .byte 1
.segment Data
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
