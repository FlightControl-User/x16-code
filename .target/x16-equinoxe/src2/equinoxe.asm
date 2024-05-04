  //
#importonce
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

.segmentdef BramEngineFloor         [start=$A000, min=$A000, align=$100]
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
  .label CX16_ROM_KERNAL = 0
  .label CX16_ROM_BASIC = 4
  /// The colors of the C64
  .label BLACK = 0
  .label WHITE = 1
  .label RED = 2
  .label BLUE = 6
  .label YELLOW = 7
  .label GREY = $c
  .label LIGHT_BLUE = $e
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
  .label CBM_SETNAM = $ffbd
  ///< Set the name of a file.
  .label CBM_SETLFS = $ffba
  ///< Set the logical file.
  .label CBM_OPEN = $ffc0
  ///< Open the file for the current logical file.
  .label CBM_CHKIN = $ffc6
  ///< Set the logical channel for input.
  .label CBM_READST = $ffb7
  ///< Check I/O errors.
  .label CBM_CHRIN = $ffcf
  ///< Scan a character from the keyboard.
  .label CBM_CLOSE = $ffc3
  ///< Close a logical file.
  .label CBM_CLRCHN = $ffcc
  ///< CX16 Set character set.
  .label CX16_MACPTR = $ff44
  .label VERA_DCSEL = 2
  .label VERA_VSYNC = 1
  .label VERA_SPRITES_ENABLE = $40
  // CX16 CBM Mouse Routines
  .label CX16_MOUSE_CONFIG = $ff68
  // ISR routine to scan the mouse state.
  .label CX16_MOUSE_GET = $ff6b
  .label OFFSET_STRUCT_FILE_CHANNEL = $80
  .label OFFSET_STRUCT_FILE_DEVICE = $84
  .label OFFSET_STRUCT_FILE_SECONDARY = $88
  .label OFFSET_STRUCT_FILE_STATUS = $8c
  .label OFFSET_STRUCT_CX16_MOUSE_T_WAIT = 9
  .label OFFSET_STRUCT_CX16_MOUSE_T_Y = 2
  .label OFFSET_STRUCT_CX16_MOUSE_T_STATUS = 8
  .label OFFSET_STRUCT_CX16_MOUSE_T_PX = 4
  .label OFFSET_STRUCT_CX16_MOUSE_T_PY = 6
  .label OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE = 1
  .label OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_BULLET = 3
  .label OFFSET_STRUCT_FLIGHT_T_MOVED = $5c0
  .label OFFSET_STRUCT_FLIGHT_T_FIREGUN = $700
  .label OFFSET_STRUCT_FLIGHT_T_RELOAD = $740
  .label OFFSET_STRUCT_FLIGHT_T_HEALTH = $880
  .label OFFSET_STRUCT_FLIGHT_T_IMPACT = $8c0
  .label OFFSET_STRUCT_FLIGHT_T_ANIMATE = $900
  .label OFFSET_STRUCT_FLIGHT_T_XF = $280
  .label OFFSET_STRUCT_FLIGHT_T_YF = $2c0
  .label OFFSET_STRUCT_FLIGHT_T_XI = $300
  .label OFFSET_STRUCT_FLIGHT_T_YI = $380
  .label OFFSET_STRUCT_FLIGHT_T_XD = $400
  .label OFFSET_STRUCT_FLIGHT_T_YD = $480
  .label OFFSET_STRUCT_FLIGHT_T_ENGINE = $6c0
  .label OFFSET_STRUCT_FLIGHT_T_USED = $c0
  .label OFFSET_STRUCT_FLIGHT_T_TYPE = $180
  .label SIZEOF_STRUCT_FILE = $90
  .label SIZEOF_STRUCT_CX16_MOUSE_T = $a
  .label SIZEOF_STRUCT_AABB_T = 4
  .label SIZEOF_STRUCT_FLOOR_SEGMENT_T = 5
  .label SIZEOF_STRUCT_FLOOR_COMPOSITION_T = $c
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
  /// $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
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
    // [4] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [5] call __lib_conio_start
    // [98] phi from __start::@1 to __lib_conio_start [phi:__start::@1->__lib_conio_start]
    jsr lib_conio.__lib_conio_start
    // [6] phi from __start::@1 to __start::@2 [phi:__start::@1->__start::@2]
    // __start::@2
    // [7] call __lib_lru_cache_start
    // [100] phi from __start::@2 to __lib_lru_cache_start [phi:__start::@2->__lib_lru_cache_start]
    jsr lib_lru_cache.__lib_lru_cache_start
    // [8] phi from __start::@2 to __start::@3 [phi:__start::@2->__start::@3]
    // __start::@3
    // [9] call __lib_bramheap_start
    // [102] phi from __start::@3 to __lib_bramheap_start [phi:__start::@3->__lib_bramheap_start]
    jsr lib_bramheap.__lib_bramheap_start
    // [10] phi from __start::@3 to __start::@4 [phi:__start::@3->__start::@4]
    // __start::@4
    // [11] call __lib_veraheap_start
    // [104] phi from __start::@4 to __lib_veraheap_start [phi:__start::@4->__lib_veraheap_start]
    jsr lib_veraheap.__lib_veraheap_start
    // [12] phi from __start::@4 to __start::@5 [phi:__start::@4->__start::@5]
    // __start::@5
    // [13] call __cx16_file_start
    // [106] phi from __start::@5 to __cx16_file_start [phi:__start::@5->__cx16_file_start]
    jsr cx16_file.__cx16_file_start
    // [14] phi from __start::@5 to __start::@6 [phi:__start::@5->__start::@6]
    // __start::@6
    // [15] call __equinoxe_layers_start
    // [108] phi from __start::@6 to __equinoxe_layers_start [phi:__start::@6->__equinoxe_layers_start]
    jsr equinoxe_layers.__equinoxe_layers_start
    // [16] phi from __start::@6 to __start::@7 [phi:__start::@6->__start::@7]
    // __start::@7
    // [17] call __equinoxe_animate_start
    // [110] phi from __start::@7 to __equinoxe_animate_start [phi:__start::@7->__equinoxe_animate_start]
    jsr equinoxe_animate.__equinoxe_animate_start
    // [18] phi from __start::@7 to __start::@8 [phi:__start::@7->__start::@8]
    // __start::@8
    // [19] call __equinoxe_palette_start
    // [112] phi from __start::@8 to __equinoxe_palette_start [phi:__start::@8->__equinoxe_palette_start]
    jsr equinoxe_palette.__equinoxe_palette_start
    // [20] phi from __start::@8 to __start::@9 [phi:__start::@8->__start::@9]
    // __start::@9
    // [21] call __equinoxe_flightengine_start
    // [114] phi from __start::@9 to __equinoxe_flightengine_start [phi:__start::@9->__equinoxe_flightengine_start]
    jsr equinoxe_flightengine.__equinoxe_flightengine_start
    // [22] phi from __start::@9 to __start::@10 [phi:__start::@9->__start::@10]
    // __start::@10
    // [23] call main
    // [116] phi from __start::@10 to main [phi:__start::@10->main]
    jsr main
    // __start::@return
    // [24] return 
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
    // [26] BROM = irq_vsync::bank_set_brom1_bank#0 -- vbuz1=vbuc1 
    lda #bank_set_brom1_bank
    sta.z BROM
    // irq_vsync::vera_display_set_border_color1
    // *VERA_CTRL &= 0b10000001
    // [27] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [28] *VERA_DC_BORDER = YELLOW -- _deref_pbuc1=vbuc2 
    lda #YELLOW
    sta VERA_DC_BORDER
    // irq_vsync::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [30] BRAM = irq_vsync::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // irq_vsync::vera_display_set_border_color2
    // *VERA_CTRL &= 0b10000001
    // [31] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [32] *VERA_DC_BORDER = BLUE -- _deref_pbuc1=vbuc2 
    lda #BLUE
    sta VERA_DC_BORDER
    // [33] phi from irq_vsync::vera_display_set_border_color2 to irq_vsync::@1 [phi:irq_vsync::vera_display_set_border_color2->irq_vsync::@1]
    // irq_vsync::@1
    // cx16_mouse_get()
    // [34] call cx16_mouse_get
    // cx16_mouse_scan(); 
    jsr cx16_mouse_get
    // irq_vsync::vera_display_set_border_color3
    // *VERA_CTRL &= 0b10000001
    // [35] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [36] *VERA_DC_BORDER = LIGHT_BLUE -- _deref_pbuc1=vbuc2 
    lda #LIGHT_BLUE
    sta VERA_DC_BORDER
    // [37] phi from irq_vsync::vera_display_set_border_color3 to irq_vsync::@2 [phi:irq_vsync::vera_display_set_border_color3->irq_vsync::@2]
    // irq_vsync::@2
    // player_logic()
    // [38] call player_logic -- call_phi_close_cx16_ram 
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
    // [39] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [40] *VERA_DC_BORDER = GREY -- _deref_pbuc1=vbuc2 
    lda #GREY
    sta VERA_DC_BORDER
    // [41] phi from irq_vsync::vera_display_set_border_color4 to irq_vsync::@3 [phi:irq_vsync::vera_display_set_border_color4->irq_vsync::@3]
    // irq_vsync::@3
    // flight_draw()
    // [42] callexecute flight_draw  -- call_var_near 
    jsr equinoxe_flightengine.flight_draw
    // *VERA_ISR = 1
    // [43] *VERA_ISR = 1 -- _deref_pbuc1=vbuc2 
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
    // [45] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [46] *VERA_DC_BORDER = BLACK -- _deref_pbuc1=vbuc2 
    lda #BLACK
    sta VERA_DC_BORDER
    // irq_vsync::@return
    // }
    // [47] return 
    // interrupt(isr_rom_sys_cx16_exit) -- isr_rom_sys_cx16_exit 
    jmp (isr_vsync)
}
  // cx16_irq_reset
// void cx16_irq_reset()
cx16_irq_reset: {
    // isr_vsync = *(IRQ_TYPE*)0x0314
    // [86] isr_vsync = *((void (**)()) 788) -- pprm1=_deref_qprc1 
    lda $314
    sta isr_vsync
    lda $314+1
    sta isr_vsync+1
    // cx16_irq_reset::@return
    // }
    // [87] return 
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
    // main::vera_display_set_hstart1
    // *VERA_CTRL |= VERA_DCSEL
    // [117] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_HSTART = start
    // [118] *VERA_DC_HSTART = main::vera_display_set_hstart1_start#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_hstart1_start
    sta VERA_DC_HSTART
    // main::vera_display_set_hstop1
    // *VERA_CTRL |= VERA_DCSEL
    // [119] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_HSTOP = stop
    // [120] *VERA_DC_HSTOP = main::vera_display_set_hstop1_stop#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_hstop1_stop
    sta VERA_DC_HSTOP
    // main::vera_display_set_vstart1
    // *VERA_CTRL |= VERA_DCSEL
    // [121] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VSTART = start
    // [122] *VERA_DC_VSTART = main::vera_display_set_vstart1_start#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_vstart1_start
    sta VERA_DC_VSTART
    // main::vera_display_set_vstop1
    // *VERA_CTRL |= VERA_DCSEL
    // [123] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VSTOP = stop
    // [124] *VERA_DC_VSTOP = main::vera_display_set_vstop1_stop#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_vstop1_stop
    sta VERA_DC_VSTOP
    // main::vera_display_set_border_color1
    // *VERA_CTRL &= 0b10000001
    // [125] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [126] *VERA_DC_BORDER = RED -- _deref_pbuc1=vbuc2 
    lda #RED
    sta VERA_DC_BORDER
    // main::bank_set_brom1
    // BROM = bank
    // [127] BROM = CX16_ROM_KERNAL -- vbuz1=vbuc1 
    lda #CX16_ROM_KERNAL
    sta.z BROM
    // [128] phi from main::bank_set_brom1 to main::@4 [phi:main::bank_set_brom1->main::@4]
    // main::@4
    // vera_floor_layer0_hide()
    // [129] callexecute vera_floor_layer0_hide  -- call_var_near 
    jsr equinoxe_layers.vera_floor_layer0_hide
    // vera_floor_layer1_hide()
    // [130] callexecute vera_floor_layer1_hide  -- call_var_near 
    jsr equinoxe_layers.vera_floor_layer1_hide
    // vera_petscii_init()
    // [131] callexecute vera_petscii_init  -- call_var_near 
    jsr equinoxe_layers.vera_petscii_init
    // scroll(1)
    // [132] scroll::onoff = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_conio.scroll.onoff
    // [133] callexecute scroll  -- call_var_near 
    jsr lib_conio.scroll
    // textcolor(WHITE)
    // [134] textcolor::color = WHITE -- vbum1=vbuc1 
    lda #WHITE
    sta lib_conio.textcolor.color
    // [135] callexecute textcolor  -- call_var_near 
    jsr lib_conio.textcolor
    // bgcolor(BLACK)
    // [136] bgcolor::color = BLACK -- vbum1=vbuc1 
    lda #BLACK
    sta lib_conio.bgcolor.color
    // [137] callexecute bgcolor  -- call_var_near 
    jsr lib_conio.bgcolor
    // clrscr()
    // [138] callexecute clrscr  -- call_var_near 
    jsr lib_conio.clrscr
    // equinoxe_init()
    // [139] call equinoxe_init
  // music = fopen("music.bin","r");
    // [256] phi from main::@4 to equinoxe_init [phi:main::@4->equinoxe_init]
    jsr equinoxe_init
    // main::@8
    // bram_heap_bram_bank_init(BANK_HEAP_BRAM)
    // [140] bram_heap_bram_bank_init::bram_bank = $f -- vbuz1=vbuc1 
    // We initialize the Commander X16 BRAM heap manager. This manages dynamically the memory space in banked ram as a real heap.
    lda #$f
    sta.z lib_bramheap.bram_heap_bram_bank_init.bram_bank
    // [141] callexecute bram_heap_bram_bank_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_bram_bank_init
    // bram_heap_segment_init(0, 0x10, (bram_ptr_t)0xA000, 0x3C, (bram_ptr_t)0xA000)
    // [142] bram_heap_segment_init::s = 0 -- vbuz1=vbuc1 
    // BREAKPOINT
    lda #0
    sta.z lib_bramheap.bram_heap_segment_init.s
    // [143] bram_heap_segment_init::bram_bank_floor = $10 -- vbuz1=vbuc1 
    lda #$10
    sta.z lib_bramheap.bram_heap_segment_init.bram_bank_floor
    // [144] bram_heap_segment_init::bram_ptr_floor = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor+1
    // [145] bram_heap_segment_init::bram_bank_ceil = $3c -- vbuz1=vbuc1 
    lda #$3c
    sta.z lib_bramheap.bram_heap_segment_init.bram_bank_ceil
    // [146] bram_heap_segment_init::bram_ptr_ceil = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil+1
    // [147] callexecute bram_heap_segment_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_segment_init
    // bram_heap_segment_init(1, 0x3C, (bram_ptr_t)0xA000, 0x3F, (bram_ptr_t)0xA000)
    // [148] bram_heap_segment_init::s = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_bramheap.bram_heap_segment_init.s
    // [149] bram_heap_segment_init::bram_bank_floor = $3c -- vbuz1=vbuc1 
    lda #$3c
    sta.z lib_bramheap.bram_heap_segment_init.bram_bank_floor
    // [150] bram_heap_segment_init::bram_ptr_floor = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor+1
    // [151] bram_heap_segment_init::bram_bank_ceil = $3f -- vbuz1=vbuc1 
    lda #$3f
    sta.z lib_bramheap.bram_heap_segment_init.bram_bank_ceil
    // [152] bram_heap_segment_init::bram_ptr_ceil = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil+1
    // [153] callexecute bram_heap_segment_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_segment_init
    // vera_heap_bram_bank_init(BANK_VERA_HEAP)
    // [154] vera_heap_bram_bank_init::bram_bank = 1 -- vbuz1=vbuc1 
    // We intialize the Commander X16 VERA heap manager. This manages dynamically the memory space in vera ram as a real heap.
    lda #1
    sta.z lib_veraheap.vera_heap_bram_bank_init.bram_bank
    // [155] callexecute vera_heap_bram_bank_init  -- call_var_near 
    jsr lib_veraheap.vera_heap_bram_bank_init
    // vera_heap_segment_init(VERA_HEAP_SEGMENT_TILES, FLOOR_TILE_BANK_VRAM, FLOOR_TILE_OFFSET_VRAM, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM)
    // [156] vera_heap_segment_init::s = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_veraheap.vera_heap_segment_init.s
    // [157] vera_heap_segment_init::vram_bank_floor = 0 -- vbuz1=vbuc1 
    sta.z lib_veraheap.vera_heap_segment_init.vram_bank_floor
    // [158] vera_heap_segment_init::vram_offset_floor = 0 -- vwuz1=vbuc1 
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_floor
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_floor+1
    // [159] vera_heap_segment_init::vram_bank_ceil = 0 -- vbuz1=vbuc1 
    sta.z lib_veraheap.vera_heap_segment_init.vram_bank_ceil
    // [160] vera_heap_segment_init::vram_offset_ceil = $5000 -- vwuz1=vwuc1 
    lda #<$5000
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_ceil
    lda #>$5000
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_ceil+1
    // [161] callexecute vera_heap_segment_init  -- call_var_near 
    jsr lib_veraheap.vera_heap_segment_init
    // vera_heap_segment_init(VERA_HEAP_SEGMENT_SPRITES, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM, FLOOR_MAP1_BANK_VRAM, FLOOR_MAP1_OFFSET_VRAM)
    // [162] vera_heap_segment_init::s = 1 -- vbuz1=vbuc1 
    // FLOOR_TILE segment for tiles of various sizes and types
    lda #1
    sta.z lib_veraheap.vera_heap_segment_init.s
    // [163] vera_heap_segment_init::vram_bank_floor = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z lib_veraheap.vera_heap_segment_init.vram_bank_floor
    // [164] vera_heap_segment_init::vram_offset_floor = $5000 -- vwuz1=vwuc1 
    lda #<$5000
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_floor
    lda #>$5000
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_floor+1
    // [165] vera_heap_segment_init::vram_bank_ceil = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z lib_veraheap.vera_heap_segment_init.vram_bank_ceil
    // [166] vera_heap_segment_init::vram_offset_ceil = $d000 -- vwuz1=vwuc1 
    lda #<$d000
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_ceil
    lda #>$d000
    sta.z lib_veraheap.vera_heap_segment_init.vram_offset_ceil+1
    // [167] callexecute vera_heap_segment_init  -- call_var_near 
    jsr lib_veraheap.vera_heap_segment_init
    // palette_init(BANK_ENGINE_PALETTE)
    // [168] palette_init::bram_bank = 6 -- vbuz1=vbuc1 
    // SPRITES segment for sprites of various sizes
    lda #6
    sta.z equinoxe_palette.palette_init.bram_bank
    // [169] callexecute palette_init  -- call_var_near 
    jsr equinoxe_palette.palette_init
    // load_player(&stage_player)
    // [170] call load_player -- call_phi_close_cx16_ram 
    sta.z $ff
    lda.z 0
    pha
    lda #3
    sta.z 0
    lda.z $ff
    jsr load_player
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // [171] phi from main::@8 to main::@9 [phi:main::@8->main::@9]
    // main::@9
    // player_add(1,2)
    // [172] call player_add -- call_phi_close_cx16_ram 
    sta.z $ff
    lda.z 0
    pha
    lda #9
    sta.z 0
    lda.z $ff
    jsr player_add
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // main::@10
    // scroll(0)
    // [173] scroll::onoff = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_conio.scroll.onoff
    // [174] callexecute scroll  -- call_var_near 
    jsr lib_conio.scroll
    // main::vera_display_set_border_color2
    // *VERA_CTRL &= 0b10000001
    // [175] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [176] *VERA_DC_BORDER = BLACK -- _deref_pbuc1=vbuc2 
    lda #BLACK
    sta VERA_DC_BORDER
    // main::cbm_k_clrchn1
    // asm
    // asm { jsrCBM_CLRCHN  }
    jsr CBM_CLRCHN
    // [178] phi from main::@1 main::cbm_k_clrchn1 to main::@1 [phi:main::@1/main::cbm_k_clrchn1->main::@1]
    // main::@1
  __b1:
    // kbhit()
    // [179] callexecute kbhit  -- call_var_near 
    jsr lib_conio.kbhit
    // [180] main::$34 = kbhit::return -- vbuaa=vbum1 
    lda lib_conio.kbhit.return
    // while(!kbhit())
    // [181] if(0==main::$34) goto main::@1 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b1
    // main::SEI1
    // asm
    // asm { sei  }
    sei
    // [183] phi from main::SEI1 to main::@5 [phi:main::SEI1->main::@5]
    // main::@5
    // cx16_irq_relay(&irq_vsync)
    // [184] call cx16_irq_relay
    jsr cx16_irq_relay
    // main::@11
    // *VERA_IEN = VERA_VSYNC | 0x80
    // [185] *VERA_IEN = VERA_VSYNC|$80 -- _deref_pbuc1=vbuc2 
    // *KERNEL_IRQ = &irq_vsync;
    lda #VERA_VSYNC|$80
    sta VERA_IEN
    // *VERA_IRQLINE_L = 0xFF
    // [186] *VERA_IRQLINE_L = $ff -- _deref_pbuc1=vbuc2 
    lda #$ff
    sta VERA_IRQLINE_L
    // main::CLI1
    // asm
    // asm { cli  }
    cli
    // main::@6
    // cx16_mouse_config(0xFF, 80, 60)
    // [188] cx16_mouse_config::visible = $ff -- vbum1=vbuc1 
    sta cx16_mouse_config.visible
    // [189] cx16_mouse_config::scalex = $50 -- vbum1=vbuc1 
    lda #$50
    sta cx16_mouse_config.scalex
    // [190] cx16_mouse_config::scaley = $3c -- vbum1=vbuc1 
    lda #$3c
    sta cx16_mouse_config.scaley
    // [191] call cx16_mouse_config
    jsr cx16_mouse_config
    // [192] phi from main::@6 to main::@12 [phi:main::@6->main::@12]
    // main::@12
    // cx16_mouse_get()
    // [193] call cx16_mouse_get
    jsr cx16_mouse_get
    // main::vera_sprites_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [194] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE
    // [195] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_SPRITES_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITES_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [196] phi from main::vera_sprites_show1 to main::@7 [phi:main::vera_sprites_show1->main::@7]
    // main::@7
    // volatile unsigned char ch = kbhit()
    // [197] callexecute kbhit  -- call_var_near 
    jsr lib_conio.kbhit
    // [198] main::ch = kbhit::return -- vbum1=vbum2 
    lda lib_conio.kbhit.return
    sta ch
    // main::@2
  __b2:
    // while (ch != 'x')
    // [199] if(main::ch!='x'pm) goto main::@3 -- vbum1_neq_vbuc1_then_la1 
  .encoding "petscii_mixed"
    lda #'x'
    cmp ch
    bne __b3
    // main::bank_set_brom2
    // BROM = bank
    // [200] BROM = CX16_ROM_BASIC -- vbuz1=vbuc1 
    lda #CX16_ROM_BASIC
    sta.z BROM
    // main::@return
    // }
    // [201] return 
    rts
    // [202] phi from main::@2 to main::@3 [phi:main::@2->main::@3]
    // main::@3
  __b3:
    // kbhit()
    // [203] callexecute kbhit  -- call_var_near 
    jsr lib_conio.kbhit
    // [204] main::$37 = kbhit::return -- vbuaa=vbum1 
    lda lib_conio.kbhit.return
    // ch=kbhit()
    // [205] main::ch = main::$37 -- vbum1=vbuaa 
    sta ch
    jmp __b2
  .segment Data
    ch: .byte 0
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
 *
 * The mouse logic administers a previous x and y positions,
 * which have an update rate of every 4 enquiries.
 */
// char cx16_mouse_get()
cx16_mouse_get: {
    .label x = $fc
    .label y = $fe
    // __mem char status
    // [206] cx16_mouse_get::status = 0 -- vbum1=vbuc1 
    lda #0
    sta status
    // __address(0xfc) unsigned int x
    // [207] cx16_mouse_get::x = 0 -- vwuz1=vwuc1 
    sta.z x
    sta.z x+1
    // __address(0xfe) unsigned int y
    // [208] cx16_mouse_get::y = 0 -- vwuz1=vwuc1 
    sta.z y
    sta.z y+1
    // if(!cx16_mouse.wait)
    // [209] if(0!=*((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT)) goto cx16_mouse_get::@1 -- 0_neq__deref_pbuc1_then_la1 
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT
    bne __b1
    // cx16_mouse_get::@2
    // cx16_mouse.px = cx16_mouse.x
    // [210] *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX) = *((unsigned int *)&cx16_mouse) -- _deref_pwuc1=_deref_pwuc2 
    lda cx16_mouse
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX
    lda cx16_mouse+1
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX+1
    // cx16_mouse.py = cx16_mouse.y
    // [211] *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PY) = *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y) -- _deref_pwuc1=_deref_pwuc2 
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PY
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y+1
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PY+1
    // cx16_mouse.wait = 4
    // [212] *((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT) = 4 -- _deref_pbuc1=vbuc2 
    lda #4
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT
    // cx16_mouse_get::@1
  __b1:
    // cx16_mouse.wait--;
    // [213] *((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT) = -- *((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT
    // asm
    // asm { ldx#$fc jsrCX16_MOUSE_GET stastatus  }
    ldx #$fc
    jsr CX16_MOUSE_GET
    sta status
    // cx16_mouse.x = x
    // [215] *((unsigned int *)&cx16_mouse) = cx16_mouse_get::x -- _deref_pwuc1=vwuz1 
    lda.z x
    sta cx16_mouse
    lda.z x+1
    sta cx16_mouse+1
    // cx16_mouse.y = y
    // [216] *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y) = cx16_mouse_get::y -- _deref_pwuc1=vwuz1 
    lda.z y
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y
    lda.z y+1
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y+1
    // cx16_mouse.status = status
    // [217] *((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_STATUS) = cx16_mouse_get::status -- _deref_pbuc1=vbum1 
    lda status
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_STATUS
    // cx16_mouse_get::@return
    // }
    // [218] return 
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
    // [219] flight_root::type = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z equinoxe_flightengine.flight_root.type
    // [220] callexecute flight_root  -- call_var_near 
    jsr equinoxe_flightengine.flight_root
    // [221] player_logic::p#0 = flight_root::return -- vbum1=vbuz2 
    lda.z equinoxe_flightengine.flight_root.return
    sta p
    // [222] phi from player_logic player_logic::@3 to player_logic::@1 [phi:player_logic/player_logic::@3->player_logic::@1]
    // [222] phi player_logic::p#10 = player_logic::p#0 [phi:player_logic/player_logic::@3->player_logic::@1#0] -- register_copy 
    // player_logic::@1
  __b1:
    // while(p)
    // [223] if(0!=player_logic::p#10) goto player_logic::@2 -- 0_neq_vbum1_then_la1 
    lda p
    bne __b2
    // player_logic::@return
    // }
    // [224] return 
    rts
    // player_logic::@2
  __b2:
    // flight_index_t pn = flight_next(p)
    // [225] flight_next::i = player_logic::p#10 -- vbuz1=vbum2 
    lda p
    sta.z equinoxe_flightengine.flight_next.i
    // [226] callexecute flight_next  -- call_var_near 
    jsr equinoxe_flightengine.flight_next
    // [227] player_logic::p#1 = flight_next::return -- vbum1=vbuz2 
    lda.z equinoxe_flightengine.flight_next.return
    sta p_1
    // if (flight.type[p] == FLIGHT_PLAYER && flight.used[p])
    // [228] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[player_logic::p#10]!=0) goto player_logic::@3 -- pbuc1_derefidx_vbum1_neq_0_then_la1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    cmp #0
    bne __b3
    // player_logic::@11
    // [229] if(0!=((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[player_logic::p#10]) goto player_logic::@9 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    bne __b9
    // player_logic::@3
  __b3:
    // [230] player_logic::p#12 = player_logic::p#1 -- vbum1=vbum2 
    lda p_1
    sta p
    jmp __b1
    // player_logic::@9
  __b9:
    // if (flight.reload[p] > 0)
    // [231] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10]<=0) goto player_logic::@4 -- pbuc1_derefidx_vbum1_le_0_then_la1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    cmp #0
    beq __b4
    // player_logic::@10
    // flight.reload[p]--;
    // [232] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10] = -- ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx p
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,x
    // player_logic::@4
  __b4:
    // flight.xi[p] = (unsigned int)cx16_mouse.x
    // [233] player_logic::$17 = player_logic::p#10 << 1 -- vbuxx=vbum1_rol_1 
    lda p
    asl
    tax
    // [234] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$17] = *((unsigned int *)&cx16_mouse) -- pwuc1_derefidx_vbuxx=_deref_pwuc2 
    lda cx16_mouse
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    lda cx16_mouse+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    // flight.yi[p] = (unsigned int)cx16_mouse.y
    // [235] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$17] = *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y) -- pwuc1_derefidx_vbuxx=_deref_pwuc2 
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    // flight_index_t n = flight.engine[p]
    // [236] player_logic::n#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ENGINE)[player_logic::p#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ENGINE,y
    sta n
    // flight.xi[p]+8
    // [237] player_logic::$8 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$17] + 8 -- vwum1=pwuc1_derefidx_vbuxx_plus_vbuc2 
    lda #8
    clc
    adc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    sta player_logic__8
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    adc #0
    sta player_logic__8+1
    // flight.xi[n] = flight.xi[p]+8
    // [238] player_logic::$21 = player_logic::n#0 << 1 -- vbuyy=vbum1_rol_1 
    lda n
    asl
    tay
    // [239] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$21] = player_logic::$8 -- pwuc1_derefidx_vbuyy=vwum1 
    lda player_logic__8
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,y
    lda player_logic__8+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,y
    // flight.yi[p]+32
    // [240] player_logic::$9 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$17] + $20 -- vwum1=pwuc1_derefidx_vbuxx_plus_vbuc2 
    lda #$20
    clc
    adc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    sta player_logic__9
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    adc #0
    sta player_logic__9+1
    // flight.yi[n] = flight.yi[p]+32
    // [241] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$21] = player_logic::$9 -- pwuc1_derefidx_vbuyy=vwum1 
    lda player_logic__9
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,y
    lda player_logic__9+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,y
    // unsigned int x = flight.xi[p]
    // [242] player_logic::x#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$17] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    sta x
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    sta x+1
    // unsigned int y = flight.yi[p]
    // [243] player_logic::y#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$17] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    sta y
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    sta y+1
    // if (x > 640 - 32)
    // [244] if(player_logic::x#0<=$280-$20) goto player_logic::@5 -- vwum1_le_vwuc1_then_la1 
    lda x+1
    cmp #>$280-$20
    bne !+
    lda x
    cmp #<$280-$20
  !:
    // [245] phi from player_logic::@4 to player_logic::@7 [phi:player_logic::@4->player_logic::@7]
    // player_logic::@7
    // player_logic::@5
    // if (y > 480 - 32)
    // [246] if(player_logic::y#0<=$1e0-$20) goto player_logic::@6 -- vwum1_le_vwuc1_then_la1 
    lda y+1
    cmp #>$1e0-$20
    bne !+
    lda y
    cmp #<$1e0-$20
  !:
    // [247] phi from player_logic::@5 to player_logic::@8 [phi:player_logic::@5->player_logic::@8]
    // player_logic::@8
    // player_logic::@6
    // unsigned char ap = flight.animate[p]
    // [248] player_logic::ap#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_logic::p#10] -- vbuaa=pbuc1_derefidx_vbum1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // animate_player(ap, (signed int)cx16_mouse.x, (signed int)cx16_mouse.px)
    // [249] animate_player::a = player_logic::ap#0 -- vbuz1=vbuaa 
    sta.z equinoxe_animate.animate_player.a
    // [250] animate_player::x = (int)*((unsigned int *)&cx16_mouse) -- vwsz1=_deref_pwsc1 
    lda cx16_mouse
    sta.z equinoxe_animate.animate_player.x
    lda cx16_mouse+1
    sta.z equinoxe_animate.animate_player.x+1
    // [251] animate_player::px = (int)*((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX) -- vwsz1=_deref_pwsc1 
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX
    sta.z equinoxe_animate.animate_player.px
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX+1
    sta.z equinoxe_animate.animate_player.px+1
    // [252] callexecute animate_player  -- call_var_near 
    jsr equinoxe_animate.animate_player
    // unsigned char an = flight.animate[n]
    // [253] player_logic::an#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_logic::n#0] -- vbuaa=pbuc1_derefidx_vbum1 
    ldy n
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // animate_logic(an)
    // [254] animate_logic::a = player_logic::an#0 -- vbuz1=vbuaa 
    sta.z equinoxe_animate.animate_logic.a
    // [255] callexecute animate_logic  -- call_var_near 
    jsr equinoxe_animate.animate_logic
    jmp __b3
  .segment DataEnginePlayers
    player_logic__8: .word 0
    .label player_logic__9 = player_logic__8
    p: .byte 0
    p_1: .byte 0
    n: .byte 0
    .label x = player_logic__8
    y: .word 0
}
.segment Code
  // equinoxe_init
// void equinoxe_init()
equinoxe_init: {
    // fload_bram("stages.bin", BANK_ENGINE_STAGES, (bram_ptr_t)0xA000)
    // [257] call fload_bram
    // [338] phi from equinoxe_init to fload_bram [phi:equinoxe_init->fload_bram]
    // [338] phi __errno#37 = 0 [phi:equinoxe_init->fload_bram#0] -- vwsm1=vwsc1 
    lda #<0
    sta __errno
    sta __errno+1
    // [338] phi fload_bram::filename#10 = equinoxe_init::filename [phi:equinoxe_init->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename
    sta.z fload_bram.filename
    lda #>filename
    sta.z fload_bram.filename+1
    // [338] phi fload_bram::dbank#5 = 3 [phi:equinoxe_init->fload_bram#2] -- vbuxx=vbuc1 
    ldx #3
    jsr fload_bram
    // [258] phi from equinoxe_init to equinoxe_init::@1 [phi:equinoxe_init->equinoxe_init::@1]
    // equinoxe_init::@1
    // fload_bram("bramflight1.bin", BANK_ENGINE_SPRITES, (bram_ptr_t)0xA000)
    // [259] call fload_bram
    // [338] phi from equinoxe_init::@1 to fload_bram [phi:equinoxe_init::@1->fload_bram]
    // [338] phi __errno#37 = __errno#106 [phi:equinoxe_init::@1->fload_bram#0] -- register_copy 
    // [338] phi fload_bram::filename#10 = equinoxe_init::filename1 [phi:equinoxe_init::@1->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename1
    sta.z fload_bram.filename
    lda #>filename1
    sta.z fload_bram.filename+1
    // [338] phi fload_bram::dbank#5 = 4 [phi:equinoxe_init::@1->fload_bram#2] -- vbuxx=vbuc1 
    ldx #4
    jsr fload_bram
    // [260] phi from equinoxe_init::@1 to equinoxe_init::@2 [phi:equinoxe_init::@1->equinoxe_init::@2]
    // equinoxe_init::@2
    // fload_bram("bramfloor1.bin", BANK_ENGINE_FLOOR, (bram_ptr_t)0xA000)
    // [261] call fload_bram
    // [338] phi from equinoxe_init::@2 to fload_bram [phi:equinoxe_init::@2->fload_bram]
    // [338] phi __errno#37 = __errno#106 [phi:equinoxe_init::@2->fload_bram#0] -- register_copy 
    // [338] phi fload_bram::filename#10 = equinoxe_init::filename2 [phi:equinoxe_init::@2->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename2
    sta.z fload_bram.filename
    lda #>filename2
    sta.z fload_bram.filename+1
    // [338] phi fload_bram::dbank#5 = 5 [phi:equinoxe_init::@2->fload_bram#2] -- vbuxx=vbuc1 
    ldx #5
    jsr fload_bram
    // [262] phi from equinoxe_init::@2 to equinoxe_init::@3 [phi:equinoxe_init::@2->equinoxe_init::@3]
    // equinoxe_init::@3
    // fload_bram("veraheap.bin", BANK_VERA_HEAP, (bram_ptr_t)0xA000)
    // [263] call fload_bram
    // [338] phi from equinoxe_init::@3 to fload_bram [phi:equinoxe_init::@3->fload_bram]
    // [338] phi __errno#37 = __errno#106 [phi:equinoxe_init::@3->fload_bram#0] -- register_copy 
    // [338] phi fload_bram::filename#10 = equinoxe_init::filename3 [phi:equinoxe_init::@3->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename3
    sta.z fload_bram.filename
    lda #>filename3
    sta.z fload_bram.filename+1
    // [338] phi fload_bram::dbank#5 = 1 [phi:equinoxe_init::@3->fload_bram#2] -- vbuxx=vbuc1 
    ldx #1
    jsr fload_bram
    // [264] phi from equinoxe_init::@3 to equinoxe_init::@4 [phi:equinoxe_init::@3->equinoxe_init::@4]
    // equinoxe_init::@4
    // flight_init()
    // [265] callexecute flight_init  -- call_var_near 
    jsr equinoxe_flightengine.flight_init
    // fload_bram("players.bin", BANK_ENGINE_PLAYERS, (bram_ptr_t)0xA000)
    // [266] call fload_bram
    // [338] phi from equinoxe_init::@4 to fload_bram [phi:equinoxe_init::@4->fload_bram]
    // [338] phi __errno#37 = __errno#106 [phi:equinoxe_init::@4->fload_bram#0] -- register_copy 
    // [338] phi fload_bram::filename#10 = equinoxe_init::filename4 [phi:equinoxe_init::@4->fload_bram#1] -- pbuz1=pbuc1 
    lda #<filename4
    sta.z fload_bram.filename
    lda #>filename4
    sta.z fload_bram.filename+1
    // [338] phi fload_bram::dbank#5 = 9 [phi:equinoxe_init::@4->fload_bram#2] -- vbuxx=vbuc1 
    ldx #9
    jsr fload_bram
    // [267] phi from equinoxe_init::@4 to equinoxe_init::@5 [phi:equinoxe_init::@4->equinoxe_init::@5]
    // equinoxe_init::@5
    // animate_init()
    // [268] callexecute animate_init  -- call_var_near 
    jsr equinoxe_animate.animate_init
    // lru_cache_init()
    // [269] callexecute lru_cache_init  -- call_var_near 
    // Initialize the cache in vram for the sprite animations.
    jsr lib_lru_cache.lru_cache_init
    // equinoxe_init::@return
    // }
    // [270] return 
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
  // load_player
// void load_player(stage_player_t *stage_player)
// __bank(cx16_ram, 3) 
load_player: {
    .label stage_player = @stage_player
    .label stage_engine = $fa
    .label stage_bullet = $fa
    // sprite_index_t player_sprite = stage_player->player_sprite
    // [271] load_player::player_sprite#0 = *((char *)load_player::stage_player#0) -- vbuaa=_deref_pbuc1 
    // Loading the player sprites in bram.
    lda stage_player
    // fe_sprite_bram_load(player_sprite, sprite_offset)
    // [272] fe_sprite_bram_load::sprite_index = load_player::player_sprite#0 -- vbuz1=vbuaa 
    sta.z equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [273] fe_sprite_bram_load::sprite_offset = sprite_offset -- vwuz1=vbum2 
    lda sprite_offset
    sta.z equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    lda #0
    sta.z equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [274] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [275] load_player::$0 = fe_sprite_bram_load::return -- vwum1=vwuz2 
    lda.z equinoxe_flightengine.fe_sprite_bram_load.return
    sta load_player__0
    lda.z equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta load_player__0+1
    // sprite_offset = fe_sprite_bram_load(player_sprite, sprite_offset)
    // [276] sprite_offset = load_player::$0 -- vbum1=vwum2 
    lda load_player__0
    sta sprite_offset
    // stage_engine_t* stage_engine = stage_player->stage_engine
    // [277] load_player::stage_engine#0 = *((stage_engine_t **)load_player::stage_player#0+OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE) -- pssz1=_deref_qssc1 
    lda stage_player+OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE
    sta.z stage_engine
    lda stage_player+OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE+1
    sta.z stage_engine+1
    // sprite_index_t engine_sprite = stage_engine->engine_sprite
    // [278] load_player::engine_sprite#0 = *((char *)load_player::stage_engine#0) -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (stage_engine),y
    // fe_sprite_bram_load(engine_sprite, sprite_offset)
    // [279] fe_sprite_bram_load::sprite_index = load_player::engine_sprite#0 -- vbuz1=vbuaa 
    sta.z equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [280] fe_sprite_bram_load::sprite_offset = sprite_offset -- vwuz1=vbum2 
    lda sprite_offset
    sta.z equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    tya
    sta.z equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [281] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [282] load_player::$1 = fe_sprite_bram_load::return -- vwum1=vwuz2 
    lda.z equinoxe_flightengine.fe_sprite_bram_load.return
    sta load_player__1
    lda.z equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta load_player__1+1
    // sprite_offset = fe_sprite_bram_load(engine_sprite, sprite_offset)
    // [283] sprite_offset = load_player::$1 -- vbum1=vwum2 
    lda load_player__1
    sta sprite_offset
    // stage_bullet_t* stage_bullet = stage_player->stage_bullet
    // [284] load_player::stage_bullet#0 = *((stage_bullet_t **)load_player::stage_player#0+OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_BULLET) -- pssz1=_deref_qssc1 
    lda stage_player+OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_BULLET
    sta.z stage_bullet
    lda stage_player+OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_BULLET+1
    sta.z stage_bullet+1
    // sprite_index_t bullet_sprite = stage_bullet->bullet_sprite
    // [285] load_player::bullet_sprite#0 = *((char *)load_player::stage_bullet#0) -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (stage_bullet),y
    // fe_sprite_bram_load(bullet_sprite, sprite_offset)
    // [286] fe_sprite_bram_load::sprite_index = load_player::bullet_sprite#0 -- vbuz1=vbuaa 
    sta.z equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [287] fe_sprite_bram_load::sprite_offset = sprite_offset -- vwuz1=vbum2 
    lda sprite_offset
    sta.z equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    tya
    sta.z equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [288] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [289] load_player::$2 = fe_sprite_bram_load::return -- vwum1=vwuz2 
    lda.z equinoxe_flightengine.fe_sprite_bram_load.return
    sta load_player__2
    lda.z equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta load_player__2+1
    // sprite_offset = fe_sprite_bram_load(bullet_sprite, sprite_offset)
    // [290] sprite_offset = load_player::$2 -- vbum1=vwum2 
    lda load_player__2
    sta sprite_offset
    // load_player::@return
    // }
    // [291] return 
    rts
  .segment DataEngineStages
    load_player__0: .word 0
    .label load_player__1 = load_player__0
    .label load_player__2 = load_player__0
}
.segment CodeEnginePlayers
  // player_add
// void player_add(char sprite_player, char sprite_engine)
// __bank(cx16_ram, 9) 
player_add: {
    .const sprite_player = 1
    .const sprite_engine = 2
    // unsigned char p = flight_add(FLIGHT_PLAYER, SIDE_PLAYER, sprite_player)
    // [292] flight_add::type = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z equinoxe_flightengine.flight_add.type
    // [293] flight_add::side = 2 -- vbuz1=vbuc1 
    lda #2
    sta.z equinoxe_flightengine.flight_add.side
    // [294] flight_add::sprite = player_add::sprite_player#0 -- vbuz1=vbuc1 
    lda #sprite_player
    sta.z equinoxe_flightengine.flight_add.sprite
    // [295] callexecute flight_add  -- call_var_near 
    jsr equinoxe_flightengine.flight_add
    // [296] player_add::p#0 = flight_add::return -- vbum1=vbuz2 
    lda.z equinoxe_flightengine.flight_add.return
    sta p
    // flight.moved[p] = 2
    // [297] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVED)[player_add::p#0] = 2 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #2
    ldy p
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVED,y
    // flight.firegun[p] = 0
    // [298] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN,y
    // flight.reload[p] = 0
    // [299] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    // flight.health[p] = 100
    // [300] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[player_add::p#0] = $64 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #$64
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    // flight.impact[p] = -100
    // [301] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_IMPACT)[player_add::p#0] = -$64 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #-$64
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_IMPACT,y
    // animate_add(6,3,3,10,1,0)
    // [302] animate_add::count = 6 -- vbuz1=vbuc1 
    lda #6
    sta.z equinoxe_animate.animate_add.count
    // [303] animate_add::state = 3 -- vbuz1=vbuc1 
    lda #3
    sta.z equinoxe_animate.animate_add.state
    // [304] animate_add::loop = 3 -- vbuz1=vbuc1 
    sta.z equinoxe_animate.animate_add.loop
    // [305] animate_add::speed = $a -- vbuz1=vbuc1 
    lda #$a
    sta.z equinoxe_animate.animate_add.speed
    // [306] animate_add::direction = 1 -- vbsz1=vbsc1 
    lda #1
    sta.z equinoxe_animate.animate_add.direction
    // [307] animate_add::reverse = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z equinoxe_animate.animate_add.reverse
    // [308] callexecute animate_add  -- call_var_near 
    jsr equinoxe_animate.animate_add
    // [309] player_add::$1 = animate_add::return -- vbuaa=vbuz1 
    lda.z equinoxe_animate.animate_add.return
    // flight.animate[p] = animate_add(6,3,3,10,1,0)
    // [310] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_add::p#0] = player_add::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy p
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // flight.xf[p] = 0
    // [311] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_XF)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XF,y
    // flight.yf[p] = 0
    // [312] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_YF)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YF,y
    // flight.xi[p] = 320
    // [313] player_add::$5 = player_add::p#0 << 1 -- vbuxx=vbum1_rol_1 
    tya
    asl
    tax
    // [314] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_add::$5] = $140 -- pwuc1_derefidx_vbuxx=vwuc2 
    lda #<$140
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    lda #>$140
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    // flight.yi[p] = 200
    // [315] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_add::$5] = $c8 -- pwuc1_derefidx_vbuxx=vbuc2 
    lda #$c8
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    // flight.xd[p] = 0
    // [316] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XD)[player_add::$5] = 0 -- pwuc1_derefidx_vbuxx=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD,x
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD+1,x
    // flight.yd[p] = 0
    // [317] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YD)[player_add::$5] = 0 -- pwuc1_derefidx_vbuxx=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD,x
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD+1,x
    // unsigned char n = flight_add(FLIGHT_ENGINE, SIDE_PLAYER, sprite_engine)
    // [318] flight_add::type = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z equinoxe_flightengine.flight_add.type
    // [319] flight_add::side = 2 -- vbuz1=vbuc1 
    lda #2
    sta.z equinoxe_flightengine.flight_add.side
    // [320] flight_add::sprite = player_add::sprite_engine#0 -- vbuz1=vbuc1 
    lda #sprite_engine
    sta.z equinoxe_flightengine.flight_add.sprite
    // [321] callexecute flight_add  -- call_var_near 
    jsr equinoxe_flightengine.flight_add
    // [322] player_add::n#0 = flight_add::return -- vbum1=vbuz2 
    lda.z equinoxe_flightengine.flight_add.return
    sta n
    // flight.engine[p] = n
    // [323] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ENGINE)[player_add::p#0] = player_add::n#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy p
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ENGINE,y
    // animate_add(16,0,0,2,1,0)
    // [324] animate_add::count = $10 -- vbuz1=vbuc1 
    lda #$10
    sta.z equinoxe_animate.animate_add.count
    // [325] animate_add::state = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z equinoxe_animate.animate_add.state
    // [326] animate_add::loop = 0 -- vbuz1=vbuc1 
    sta.z equinoxe_animate.animate_add.loop
    // [327] animate_add::speed = 2 -- vbuz1=vbuc1 
    lda #2
    sta.z equinoxe_animate.animate_add.speed
    // [328] animate_add::direction = 1 -- vbsz1=vbsc1 
    lda #1
    sta.z equinoxe_animate.animate_add.direction
    // [329] animate_add::reverse = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z equinoxe_animate.animate_add.reverse
    // [330] callexecute animate_add  -- call_var_near 
    jsr equinoxe_animate.animate_add
    // [331] player_add::$3 = animate_add::return -- vbuaa=vbuz1 
    lda.z equinoxe_animate.animate_add.return
    // flight.animate[n] = animate_add(16,0,0,2,1,0)
    // [332] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_add::n#0] = player_add::$3 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy n
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // player_add::@return
    // }
    // [333] return 
    rts
  .segment DataEnginePlayers
    p: .byte 0
    n: .byte 0
}
.segment Code
  // cx16_irq_relay
// void cx16_irq_relay(void (*irq)())
cx16_irq_relay: {
    .label irq = irq_vsync
    // *KERNEL_IRQ = irq
    // [334] *KERNEL_IRQ = cx16_irq_relay::irq#0 -- _deref_qprc1=pprc2 
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    // cx16_irq_relay::@return
    // }
    // [335] return 
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
    // [337] return 
    rts
  .segment Data
    visible: .byte 0
    scalex: .byte 0
    scaley: .byte 0
}
.segment Code
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
// unsigned int fload_bram(__zp($32) char *filename, __register(X) char dbank, char *dptr)
fload_bram: {
    .label fp = $d4
    .label filename = $32
    // fload_bram::bank_get_bram1
    // return BRAM;
    // [339] fload_bram::bank_set_bram2_bank#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_set_bram2_bank
    // fload_bram::bank_set_bram1
    // BRAM = bank
    // [340] BRAM = fload_bram::dbank#5 -- vbuz1=vbuxx 
    stx.z BRAM
    // fload_bram::@4
    // FILE* fp = fopen(filename,"r")
    // [341] fopen::path#2 = fload_bram::filename#10
    // [342] call fopen
    jsr fopen
    // [343] fopen::return#3 = fopen::return#2
    // fload_bram::@5
    // [344] fload_bram::fp#0 = fopen::return#3
    // if(fp)
    // [345] if((FILE *)0==fload_bram::fp#0) goto fload_bram::bank_set_bram2 -- pssc1_eq_pssz1_then_la1 
    lda.z fp
    cmp #<0
    bne !+
    lda.z fp+1
    cmp #>0
    beq bank_set_bram2
  !:
    // fload_bram::@1
    // fgets(dptr, 0, fp)
    // [346] fgets::stream#0 = fload_bram::fp#0
    // [347] call fgets
    jsr fgets
    // [348] fgets::return#5 = fgets::return#1
    // fload_bram::@6
    // read = fgets(dptr, 0, fp)
    // [349] fload_bram::read#1 = fgets::return#5
    // if(read)
    // [350] if(0!=fload_bram::read#1) goto fload_bram::@3 -- 0_neq_vwum1_then_la1 
    lda read
    ora read+1
    bne __b3
    // fload_bram::@2
    // fclose(fp)
    // [351] fclose::stream#1 = fload_bram::fp#0
    // [352] call fclose
    // [473] phi from fload_bram::@2 to fclose [phi:fload_bram::@2->fclose]
    // [473] phi fclose::stream#2 = fclose::stream#1 [phi:fload_bram::@2->fclose#0] -- register_copy 
    jsr fclose
    // fload_bram::bank_set_bram2
  bank_set_bram2:
    // BRAM = bank
    // [353] BRAM = fload_bram::bank_set_bram2_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram2_bank
    sta.z BRAM
    // fload_bram::@return
    // }
    // [354] return 
    rts
    // fload_bram::@3
  __b3:
    // fclose(fp)
    // [355] fclose::stream#0 = fload_bram::fp#0
    // [356] call fclose
    // [473] phi from fload_bram::@3 to fclose [phi:fload_bram::@3->fclose]
    // [473] phi fclose::stream#2 = fclose::stream#0 [phi:fload_bram::@3->fclose#0] -- register_copy 
    jsr fclose
    jmp bank_set_bram2
  .segment Data
    bank_set_bram2_bank: .byte 0
    .label read = fgets.read
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
// __zp($d4) FILE * fopen(__zp($32) const char *path, const char *mode)
fopen: {
    .label fopen__11 = $32
    .label fopen__28 = $42
    .label cbm_k_setnam1_filename = $f8
    .label stream = $d4
    .label pathtoken = $52
    .label path = $32
    .label return = $d4
    // unsigned char sp = __stdio_filecount
    // [357] fopen::sp#0 = __stdio_filecount -- vbum1=vbum2 
    lda __stdio_filecount
    sta sp
    // (unsigned int)sp | 0x8000
    // [358] fopen::$30 = (unsigned int)fopen::sp#0 -- vwum1=_word_vbum2 
    sta fopen__30
    lda #0
    sta fopen__30+1
    // [359] fopen::stream#0 = fopen::$30 | $8000 -- vwuz1=vwum2_bor_vwuc1 
    lda fopen__30
    ora #<$8000
    sta.z stream
    lda fopen__30+1
    ora #>$8000
    sta.z stream+1
    // char pathpos = sp * __STDIO_FILECOUNT
    // [360] fopen::pathpos#0 = fopen::sp#0 << 2 -- vbum1=vbum2_rol_2 
    lda sp
    asl
    asl
    sta pathpos
    // __logical = 0
    // [361] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    // __device = 0
    // [362] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    // __channel = 0
    // [363] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    // [364] fopen::pathtoken#21 = fopen::path#2 -- pbuz1=pbuz2 
    lda.z path
    sta.z pathtoken
    lda.z path+1
    sta.z pathtoken+1
    // [365] fopen::pathpos#21 = fopen::pathpos#0 -- vbum1=vbum2 
    lda pathpos
    sta pathpos_1
    // [366] phi from fopen to fopen::@8 [phi:fopen->fopen::@8]
    // [366] phi fopen::num#10 = 0 [phi:fopen->fopen::@8#0] -- vbuxx=vbuc1 
    ldx #0
    // [366] phi fopen::pathpos#10 = fopen::pathpos#21 [phi:fopen->fopen::@8#1] -- register_copy 
    // [366] phi fopen::path#13 = fopen::path#2 [phi:fopen->fopen::@8#2] -- register_copy 
    // [366] phi fopen::pathstep#10 = 0 [phi:fopen->fopen::@8#3] -- vbum1=vbuc1 
    txa
    sta pathstep
    // [366] phi fopen::pathtoken#10 = fopen::pathtoken#21 [phi:fopen->fopen::@8#4] -- register_copy 
  // Iterate while path is not \0.
    // [366] phi from fopen::@22 to fopen::@8 [phi:fopen::@22->fopen::@8]
    // [366] phi fopen::num#10 = fopen::num#13 [phi:fopen::@22->fopen::@8#0] -- register_copy 
    // [366] phi fopen::pathpos#10 = fopen::pathpos#7 [phi:fopen::@22->fopen::@8#1] -- register_copy 
    // [366] phi fopen::path#13 = fopen::path#10 [phi:fopen::@22->fopen::@8#2] -- register_copy 
    // [366] phi fopen::pathstep#10 = fopen::pathstep#11 [phi:fopen::@22->fopen::@8#3] -- register_copy 
    // [366] phi fopen::pathtoken#10 = fopen::pathtoken#1 [phi:fopen::@22->fopen::@8#4] -- register_copy 
    // fopen::@8
  __b8:
    // if (*pathtoken == ',' || *pathtoken == '\0')
    // [367] if(*fopen::pathtoken#10==','pm) goto fopen::@9 -- _deref_pbuz1_eq_vbuc1_then_la1 
    lda #','
    ldy #0
    cmp (pathtoken),y
    bne !__b9+
    jmp __b9
  !__b9:
    // fopen::@33
    // [368] if(*fopen::pathtoken#10=='?'pm) goto fopen::@9 -- _deref_pbuz1_eq_vbuc1_then_la1 
    lda #'\$00'
    cmp (pathtoken),y
    bne !__b9+
    jmp __b9
  !__b9:
    // fopen::@23
    // if (pathstep == 0)
    // [369] if(fopen::pathstep#10!=0) goto fopen::@10 -- vbum1_neq_0_then_la1 
    lda pathstep
    bne __b10
    // fopen::@24
    // __stdio_file.filename[pathpos] = *pathtoken
    // [370] ((char *)&__stdio_file)[fopen::pathpos#10] = *fopen::pathtoken#10 -- pbuc1_derefidx_vbum1=_deref_pbuz2 
    lda (pathtoken),y
    ldy pathpos_1
    sta __stdio_file,y
    // pathpos++;
    // [371] fopen::pathpos#1 = ++ fopen::pathpos#10 -- vbum1=_inc_vbum1 
    inc pathpos_1
    // [372] phi from fopen::@12 fopen::@23 fopen::@24 to fopen::@10 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10]
    // [372] phi fopen::num#13 = fopen::num#15 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#0] -- register_copy 
    // [372] phi fopen::pathpos#7 = fopen::pathpos#10 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#1] -- register_copy 
    // [372] phi fopen::path#10 = fopen::path#12 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#2] -- register_copy 
    // [372] phi fopen::pathstep#11 = fopen::pathstep#1 [phi:fopen::@12/fopen::@23/fopen::@24->fopen::@10#3] -- register_copy 
    // fopen::@10
  __b10:
    // pathtoken++;
    // [373] fopen::pathtoken#1 = ++ fopen::pathtoken#10 -- pbuz1=_inc_pbuz1 
    inc.z pathtoken
    bne !+
    inc.z pathtoken+1
  !:
    // fopen::@22
    // pathtoken - 1
    // [374] fopen::$28 = fopen::pathtoken#1 - 1 -- pbuz1=pbuz2_minus_1 
    lda.z pathtoken
    sec
    sbc #1
    sta.z fopen__28
    lda.z pathtoken+1
    sbc #0
    sta.z fopen__28+1
    // while (*(pathtoken - 1))
    // [375] if(0!=*fopen::$28) goto fopen::@8 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (fopen__28),y
    cmp #0
    bne __b8
    // fopen::@26
    // __status = 0
    // [376] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fopen::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    tya
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if(!__logical)
    // [377] if(0!=((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0]) goto fopen::@1 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    cmp #0
    bne __b1
    // fopen::@27
    // __stdio_filecount+1
    // [378] fopen::$4 = __stdio_filecount + 1 -- vbuaa=vbum1_plus_1 
    lda __stdio_filecount
    inc
    // __logical = __stdio_filecount+1
    // [379] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] = fopen::$4 -- pbuc1_derefidx_vbum1=vbuaa 
    sta __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    // fopen::@1
  __b1:
    // if(!__device)
    // [380] if(0!=((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0]) goto fopen::@2 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    cmp #0
    bne __b2
    // fopen::@5
    // __device = 8
    // [381] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0] = 8 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #8
    sta __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    // fopen::@2
  __b2:
    // if(!__channel)
    // [382] if(0!=((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0]) goto fopen::@3 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    cmp #0
    bne __b3
    // fopen::@6
    // __stdio_filecount+2
    // [383] fopen::$9 = __stdio_filecount + 2 -- vbuaa=vbum1_plus_2 
    lda __stdio_filecount
    clc
    adc #2
    // __channel = __stdio_filecount+2
    // [384] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0] = fopen::$9 -- pbuc1_derefidx_vbum1=vbuaa 
    sta __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    // fopen::@3
  __b3:
    // __filename
    // [385] fopen::$11 = (char *)&__stdio_file + fopen::pathpos#0 -- pbuz1=pbuc1_plus_vbum2 
    lda pathpos
    clc
    adc #<__stdio_file
    sta.z fopen__11
    lda #>__stdio_file
    adc #0
    sta.z fopen__11+1
    // cbm_k_setnam(__filename)
    // [386] fopen::cbm_k_setnam1_filename = fopen::$11 -- pbuz1=pbuz2 
    lda.z fopen__11
    sta.z cbm_k_setnam1_filename
    lda.z fopen__11+1
    sta.z cbm_k_setnam1_filename+1
    // fopen::cbm_k_setnam1
    // strlen(filename)
    // [387] strlen::str#1 = fopen::cbm_k_setnam1_filename -- pbuz1=pbuz2 
    lda.z cbm_k_setnam1_filename
    sta.z strlen.str
    lda.z cbm_k_setnam1_filename+1
    sta.z strlen.str+1
    // [388] call strlen
    // [501] phi from fopen::cbm_k_setnam1 to strlen [phi:fopen::cbm_k_setnam1->strlen]
    // [501] phi strlen::str#5 = strlen::str#1 [phi:fopen::cbm_k_setnam1->strlen#0] -- register_copy 
    jsr strlen
    // strlen(filename)
    // [389] strlen::return#2 = strlen::len#2
    // fopen::@31
    // [390] fopen::cbm_k_setnam1_$0 = strlen::return#2
    // char filename_len = (char)strlen(filename)
    // [391] fopen::cbm_k_setnam1_filename_len = (char)fopen::cbm_k_setnam1_$0 -- vbum1=_byte_vwum2 
    lda cbm_k_setnam1_fopen__0
    sta cbm_k_setnam1_filename_len
    // asm
    // asm { ldafilename_len ldxfilename ldyfilename+1 jsrCBM_SETNAM  }
    ldx cbm_k_setnam1_filename
    ldy cbm_k_setnam1_filename+1
    jsr CBM_SETNAM
    // fopen::@28
    // cbm_k_setlfs(__logical, __device, __channel)
    // [393] cbm_k_setlfs::channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta cbm_k_setlfs.channel
    // [394] cbm_k_setlfs::device = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    sta cbm_k_setlfs.device
    // [395] cbm_k_setlfs::command = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    sta cbm_k_setlfs.command
    // [396] call cbm_k_setlfs
    jsr cbm_k_setlfs
    // fopen::cbm_k_open1
    // asm
    // asm { jsrCBM_OPEN  }
    jsr CBM_OPEN
    // fopen::cbm_k_readst1
    // char status
    // [398] fopen::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [400] fopen::cbm_k_readst1_return#0 = fopen::cbm_k_readst1_status -- vbuaa=vbum1 
    // fopen::cbm_k_readst1_@return
    // }
    // [401] fopen::cbm_k_readst1_return#1 = fopen::cbm_k_readst1_return#0
    // fopen::@29
    // cbm_k_readst()
    // [402] fopen::$15 = fopen::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [403] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fopen::sp#0] = fopen::$15 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // ferror(stream)
    // [404] ferror::stream#0 = (FILE *)fopen::stream#0
    // [405] call ferror
    jsr ferror
    // [406] ferror::return#0 = ferror::return#1
    // fopen::@32
    // [407] fopen::$16 = ferror::return#0
    // if (ferror(stream))
    // [408] if(0==fopen::$16) goto fopen::@4 -- 0_eq_vwsm1_then_la1 
    lda fopen__16
    ora fopen__16+1
    beq __b4
    // fopen::@7
    // cbm_k_close(__logical)
    // [409] fopen::cbm_k_close1_channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta cbm_k_close1_channel
    // fopen::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // [411] phi from fopen::cbm_k_close1 to fopen::@return [phi:fopen::cbm_k_close1->fopen::@return]
    // [411] phi fopen::return#2 = 0 [phi:fopen::cbm_k_close1->fopen::@return#0] -- pssz1=vbuc1 
    lda #<0
    sta.z return
    sta.z return+1
    // fopen::@return
    // }
    // [412] return 
    rts
    // fopen::@4
  __b4:
    // __stdio_filecount++;
    // [413] __stdio_filecount = ++ __stdio_filecount -- vbum1=_inc_vbum1 
    inc __stdio_filecount
    // [414] fopen::return#6 = (FILE *)fopen::stream#0
    // [411] phi from fopen::@4 to fopen::@return [phi:fopen::@4->fopen::@return]
    // [411] phi fopen::return#2 = fopen::return#6 [phi:fopen::@4->fopen::@return#0] -- register_copy 
    rts
    // fopen::@9
  __b9:
    // if (pathstep > 0)
    // [415] if(fopen::pathstep#10>0) goto fopen::@11 -- vbum1_gt_0_then_la1 
    lda pathstep
    bne __b11
    // fopen::@25
    // __stdio_file.filename[pathpos] = '\0'
    // [416] ((char *)&__stdio_file)[fopen::pathpos#10] = '?'pm -- pbuc1_derefidx_vbum1=vbuc2 
    lda #'\$00'
    ldy pathpos_1
    sta __stdio_file,y
    // path = pathtoken + 1
    // [417] fopen::path#0 = fopen::pathtoken#10 + 1 -- pbuz1=pbuz2_plus_1 
    clc
    lda.z pathtoken
    adc #1
    sta.z path
    lda.z pathtoken+1
    adc #0
    sta.z path+1
    // [418] phi from fopen::@16 fopen::@17 fopen::@18 fopen::@19 fopen::@25 to fopen::@12 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12]
    // [418] phi fopen::num#15 = fopen::num#2 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12#0] -- register_copy 
    // [418] phi fopen::path#12 = fopen::path#15 [phi:fopen::@16/fopen::@17/fopen::@18/fopen::@19/fopen::@25->fopen::@12#1] -- register_copy 
    // fopen::@12
  __b12:
    // pathstep++;
    // [419] fopen::pathstep#1 = ++ fopen::pathstep#10 -- vbum1=_inc_vbum1 
    inc pathstep
    jmp __b10
    // fopen::@11
  __b11:
    // char pathcmp = *path
    // [420] fopen::pathcmp#0 = *fopen::path#13 -- vbum1=_deref_pbuz2 
    ldy #0
    lda (path),y
    sta pathcmp
    // case 'D':
    // [421] if(fopen::pathcmp#0=='D'pm) goto fopen::@13 -- vbum1_eq_vbuc1_then_la1 
    lda #'D'
    cmp pathcmp
    beq __b13
    // fopen::@20
    // case 'L':
    // [422] if(fopen::pathcmp#0=='L'pm) goto fopen::@13 -- vbum1_eq_vbuc1_then_la1 
    lda #'L'
    cmp pathcmp
    beq __b13
    // fopen::@21
    // case 'C':
    //                     num = (char)atoi(path + 1);
    //                     path = pathtoken + 1;
    // [423] if(fopen::pathcmp#0=='C'pm) goto fopen::@13 -- vbum1_eq_vbuc1_then_la1 
    lda #'C'
    cmp pathcmp
    beq __b13
    // [424] phi from fopen::@21 fopen::@30 to fopen::@14 [phi:fopen::@21/fopen::@30->fopen::@14]
    // [424] phi fopen::path#15 = fopen::path#13 [phi:fopen::@21/fopen::@30->fopen::@14#0] -- register_copy 
    // [424] phi fopen::num#2 = fopen::num#10 [phi:fopen::@21/fopen::@30->fopen::@14#1] -- register_copy 
    // fopen::@14
  __b14:
    // case 'L':
    //                     __logical = num;
    //                     break;
    // [425] if(fopen::pathcmp#0=='L'pm) goto fopen::@17 -- vbum1_eq_vbuc1_then_la1 
    lda #'L'
    cmp pathcmp
    beq __b17
    // fopen::@15
    // case 'D':
    //                     __device = num;
    //                     break;
    // [426] if(fopen::pathcmp#0=='D'pm) goto fopen::@18 -- vbum1_eq_vbuc1_then_la1 
    lda #'D'
    cmp pathcmp
    beq __b18
    // fopen::@16
    // case 'C':
    //                     __channel = num;
    //                     break;
    // [427] if(fopen::pathcmp#0!='C'pm) goto fopen::@12 -- vbum1_neq_vbuc1_then_la1 
    lda #'C'
    cmp pathcmp
    bne __b12
    // fopen::@19
    // __channel = num
    // [428] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy sp
    txa
    sta __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    jmp __b12
    // fopen::@18
  __b18:
    // __device = num
    // [429] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy sp
    txa
    sta __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    jmp __b12
    // fopen::@17
  __b17:
    // __logical = num
    // [430] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fopen::sp#0] = fopen::num#2 -- pbuc1_derefidx_vbum1=vbuxx 
    ldy sp
    txa
    sta __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    jmp __b12
    // fopen::@13
  __b13:
    // atoi(path + 1)
    // [431] atoi::str#0 = fopen::path#13 + 1 -- pbuz1=pbuz1_plus_1 
    inc.z atoi.str
    bne !+
    inc.z atoi.str+1
  !:
    // [432] call atoi
    // [561] phi from fopen::@13 to atoi [phi:fopen::@13->atoi]
    // [561] phi atoi::str#2 = atoi::str#0 [phi:fopen::@13->atoi#0] -- register_copy 
    jsr atoi
    // atoi(path + 1)
    // [433] atoi::return#3 = atoi::return#2
    // fopen::@30
    // [434] fopen::$26 = atoi::return#3
    // num = (char)atoi(path + 1)
    // [435] fopen::num#1 = (char)fopen::$26 -- vbuxx=_byte_vwsm1 
    lda fopen__26
    tax
    // path = pathtoken + 1
    // [436] fopen::path#1 = fopen::pathtoken#10 + 1 -- pbuz1=pbuz2_plus_1 
    clc
    lda.z pathtoken
    adc #1
    sta.z path
    lda.z pathtoken+1
    adc #0
    sta.z path+1
    jmp __b14
  .segment Data
    .label fopen__16 = fgets.remaining
    .label fopen__26 = fgets.remaining
    .label fopen__30 = fgets.remaining
    cbm_k_setnam1_filename_len: .byte 0
    .label cbm_k_setnam1_fopen__0 = fgets.remaining
    cbm_k_readst1_status: .byte 0
    cbm_k_close1_channel: .byte 0
    sp: .byte 0
    pathpos: .byte 0
    pathpos_1: .byte 0
    pathcmp: .byte 0
    // Parse path
    pathstep: .byte 0
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
// __mem() unsigned int fgets(__zp($52) char *ptr, unsigned int size, __zp($d4) FILE *stream)
fgets: {
    .const size = 0
    .label ptr = $52
    .label stream = $d4
    // unsigned char sp = (unsigned char)stream
    // [437] fgets::sp#0 = (char)fgets::stream#0 -- vbum1=_byte_pssz2 
    lda.z stream
    sta sp
    // cbm_k_chkin(__logical)
    // [438] fgets::cbm_k_chkin1_channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fgets::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    tay
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta cbm_k_chkin1_channel
    // fgets::cbm_k_chkin1
    // char status
    // [439] fgets::cbm_k_chkin1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // fgets::cbm_k_readst1
    // char status
    // [441] fgets::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [443] fgets::cbm_k_readst1_return#0 = fgets::cbm_k_readst1_status -- vbuaa=vbum1 
    // fgets::cbm_k_readst1_@return
    // }
    // [444] fgets::cbm_k_readst1_return#1 = fgets::cbm_k_readst1_return#0
    // fgets::@7
    // cbm_k_readst()
    // [445] fgets::$1 = fgets::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [446] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0] = fgets::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if (__status)
    // [447] if(0==((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0]) goto fgets::@1 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    cmp #0
    beq __b7
    // [448] phi from fgets::@3 fgets::@7 fgets::@8 to fgets::@return [phi:fgets::@3/fgets::@7/fgets::@8->fgets::@return]
  __b1:
    // [448] phi fgets::return#1 = 0 [phi:fgets::@3/fgets::@7/fgets::@8->fgets::@return#0] -- vwum1=vbuc1 
    lda #<0
    sta return
    sta return+1
    // fgets::@return
    // }
    // [449] return 
    rts
    // [450] phi from fgets::@5 to fgets::@1 [phi:fgets::@5->fgets::@1]
    // [450] phi fgets::read#10 = fgets::read#1 [phi:fgets::@5->fgets::@1#0] -- register_copy 
    // [450] phi fgets::remaining#11 = fgets::remaining#1 [phi:fgets::@5->fgets::@1#1] -- register_copy 
    // [450] phi fgets::ptr#10 = fgets::ptr#12 [phi:fgets::@5->fgets::@1#2] -- register_copy 
    // [450] phi from fgets::@7 to fgets::@1 [phi:fgets::@7->fgets::@1]
  __b7:
    // [450] phi fgets::read#10 = 0 [phi:fgets::@7->fgets::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta read
    sta read+1
    // [450] phi fgets::remaining#11 = fgets::size#0 [phi:fgets::@7->fgets::@1#1] -- vwum1=vwuc1 
    lda #<size
    sta remaining
    lda #>size
    sta remaining+1
    // [450] phi fgets::ptr#10 = (char *) 40960 [phi:fgets::@7->fgets::@1#2] -- pbuz1=pbuc1 
    lda #<$a000
    sta.z ptr
    lda #>$a000
    sta.z ptr+1
    // fgets::@1
    // fgets::@2
  __b2:
    // cx16_k_macptr(0, ptr)
    // [451] cx16_k_macptr::bytes = 0 -- vbum1=vbuc1 
    lda #0
    sta cx16_k_macptr.bytes
    // [452] cx16_k_macptr::buffer = (void *)fgets::ptr#10 -- pvoz1=pvoz2 
    lda.z ptr
    sta.z cx16_k_macptr.buffer
    lda.z ptr+1
    sta.z cx16_k_macptr.buffer+1
    // [453] call cx16_k_macptr
    jsr cx16_k_macptr
    // [454] cx16_k_macptr::return#2 = cx16_k_macptr::return#1
    // fgets::@9
    // bytes = cx16_k_macptr(0, ptr)
    // [455] fgets::bytes#1 = cx16_k_macptr::return#2
    // fgets::cbm_k_readst2
    // char status
    // [456] fgets::cbm_k_readst2_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst2_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst2_status
    // return status;
    // [458] fgets::cbm_k_readst2_return#0 = fgets::cbm_k_readst2_status -- vbuaa=vbum1 
    // fgets::cbm_k_readst2_@return
    // }
    // [459] fgets::cbm_k_readst2_return#1 = fgets::cbm_k_readst2_return#0
    // fgets::@8
    // cbm_k_readst()
    // [460] fgets::$8 = fgets::cbm_k_readst2_return#1
    // __status = cbm_k_readst()
    // [461] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0] = fgets::$8 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // __status & 0xBF
    // [462] fgets::$9 = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0] & $bf -- vbuaa=pbuc1_derefidx_vbum1_band_vbuc2 
    lda #$bf
    and __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if (__status & 0xBF)
    // [463] if(0==fgets::$9) goto fgets::@3 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b3
    jmp __b1
    // fgets::@3
  __b3:
    // if (bytes == 0xFFFF)
    // [464] if(fgets::bytes#1!=$ffff) goto fgets::@4 -- vwum1_neq_vwuc1_then_la1 
    lda bytes+1
    cmp #>$ffff
    bne __b4
    lda bytes
    cmp #<$ffff
    bne __b4
    jmp __b1
    // fgets::@4
  __b4:
    // read += bytes
    // [465] fgets::read#1 = fgets::read#10 + fgets::bytes#1 -- vwum1=vwum1_plus_vwum2 
    clc
    lda read
    adc bytes
    sta read
    lda read+1
    adc bytes+1
    sta read+1
    // ptr += bytes
    // [466] fgets::ptr#0 = fgets::ptr#10 + fgets::bytes#1 -- pbuz1=pbuz1_plus_vwum2 
    clc
    lda.z ptr
    adc bytes
    sta.z ptr
    lda.z ptr+1
    adc bytes+1
    sta.z ptr+1
    // BYTE1(ptr)
    // [467] fgets::$13 = byte1  fgets::ptr#0 -- vbuaa=_byte1_pbuz1 
    // if (BYTE1(ptr) == 0xC0)
    // [468] if(fgets::$13!=$c0) goto fgets::@5 -- vbuaa_neq_vbuc1_then_la1 
    cmp #$c0
    bne __b5
    // fgets::@6
    // ptr -= 0x2000
    // [469] fgets::ptr#1 = fgets::ptr#0 - $2000 -- pbuz1=pbuz1_minus_vwuc1 
    lda.z ptr
    sec
    sbc #<$2000
    sta.z ptr
    lda.z ptr+1
    sbc #>$2000
    sta.z ptr+1
    // [470] phi from fgets::@4 fgets::@6 to fgets::@5 [phi:fgets::@4/fgets::@6->fgets::@5]
    // [470] phi fgets::ptr#12 = fgets::ptr#0 [phi:fgets::@4/fgets::@6->fgets::@5#0] -- register_copy 
    // fgets::@5
  __b5:
    // remaining -= bytes
    // [471] fgets::remaining#1 = fgets::remaining#11 - fgets::bytes#1 -- vwum1=vwum1_minus_vwum2 
    lda remaining
    sec
    sbc bytes
    sta remaining
    lda remaining+1
    sbc bytes+1
    sta remaining+1
    // while ((__status == 0) && ((size && remaining) || !size))
    // [472] if(((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fgets::sp#0]==0) goto fgets::@1 -- pbuc1_derefidx_vbum1_eq_0_then_la1 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    cmp #0
    bne !__b2+
    jmp __b2
  !__b2:
    // [448] phi from fgets::@5 to fgets::@return [phi:fgets::@5->fgets::@return]
    // [448] phi fgets::return#1 = fgets::read#1 [phi:fgets::@5->fgets::@return#0] -- register_copy 
    rts
  .segment Data
    cbm_k_chkin1_channel: .byte 0
    cbm_k_chkin1_status: .byte 0
    cbm_k_readst1_status: .byte 0
    cbm_k_readst2_status: .byte 0
    .label sp = fopen.pathstep
    .label return = read
    .label bytes = cx16_k_macptr.return
    read: .word 0
    remaining: .word 0
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
// int fclose(__zp($d4) FILE *stream)
fclose: {
    .label stream = $d4
    // unsigned char sp = (unsigned char)stream
    // [474] fclose::sp#0 = (char)fclose::stream#2 -- vbum1=_byte_pssz2 
    lda.z stream
    sta sp
    // cbm_k_chkin(__logical)
    // [475] fclose::cbm_k_chkin1_channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fclose::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    tay
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta cbm_k_chkin1_channel
    // fclose::cbm_k_chkin1
    // char status
    // [476] fclose::cbm_k_chkin1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // fclose::cbm_k_readst1
    // char status
    // [478] fclose::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [480] fclose::cbm_k_readst1_return#0 = fclose::cbm_k_readst1_status -- vbuaa=vbum1 
    // fclose::cbm_k_readst1_@return
    // }
    // [481] fclose::cbm_k_readst1_return#1 = fclose::cbm_k_readst1_return#0
    // fclose::@3
    // cbm_k_readst()
    // [482] fclose::$1 = fclose::cbm_k_readst1_return#1
    // __status = cbm_k_readst()
    // [483] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fclose::sp#0] = fclose::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if (__status)
    // [484] if(0==((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fclose::sp#0]) goto fclose::@1 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    cmp #0
    beq __b1
    // fclose::@return
    // }
    // [485] return 
    rts
    // fclose::@1
  __b1:
    // cbm_k_close(__logical)
    // [486] fclose::cbm_k_close1_channel = ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fclose::sp#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy sp
    lda __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    sta cbm_k_close1_channel
    // fclose::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // fclose::cbm_k_readst2
    // char status
    // [488] fclose::cbm_k_readst2_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst2_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst2_status
    // return status;
    // [490] fclose::cbm_k_readst2_return#0 = fclose::cbm_k_readst2_status -- vbuaa=vbum1 
    // fclose::cbm_k_readst2_@return
    // }
    // [491] fclose::cbm_k_readst2_return#1 = fclose::cbm_k_readst2_return#0
    // fclose::@4
    // cbm_k_readst()
    // [492] fclose::$4 = fclose::cbm_k_readst2_return#1
    // __status = cbm_k_readst()
    // [493] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fclose::sp#0] = fclose::$4 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // if (__status)
    // [494] if(0==((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[fclose::sp#0]) goto fclose::@2 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    cmp #0
    beq __b2
    rts
    // fclose::@2
  __b2:
    // __logical = 0
    // [495] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_CHANNEL)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_CHANNEL,y
    // __device = 0
    // [496] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_DEVICE)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+OFFSET_STRUCT_FILE_DEVICE,y
    // __channel = 0
    // [497] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_SECONDARY)[fclose::sp#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta __stdio_file+OFFSET_STRUCT_FILE_SECONDARY,y
    // __filename
    // [498] fclose::$6 = fclose::sp#0 << 2 -- vbuaa=vbum1_rol_2 
    tya
    asl
    asl
    // *__filename = '\0'
    // [499] ((char *)&__stdio_file)[fclose::$6] = '?'pm -- pbuc1_derefidx_vbuaa=vbuc2 
    tay
    lda #'\$00'
    sta __stdio_file,y
    // __stdio_filecount--;
    // [500] __stdio_filecount = -- __stdio_filecount -- vbum1=_dec_vbum1 
    dec __stdio_filecount
    rts
  .segment Data
    cbm_k_chkin1_channel: .byte 0
    cbm_k_chkin1_status: .byte 0
    cbm_k_readst1_status: .byte 0
    cbm_k_close1_channel: .byte 0
    cbm_k_readst2_status: .byte 0
    .label sp = fopen.pathstep
}
.segment Code
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __mem() unsigned int strlen(__zp($32) char *str)
strlen: {
    .label str = $32
    // [502] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [502] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta len
    sta len+1
    // [502] phi strlen::str#3 = strlen::str#5 [phi:strlen->strlen::@1#1] -- register_copy 
    // strlen::@1
  __b1:
    // while(*str)
    // [503] if(0!=*strlen::str#3) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [504] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [505] strlen::len#1 = ++ strlen::len#2 -- vwum1=_inc_vwum1 
    inc len
    bne !+
    inc len+1
  !:
    // str++;
    // [506] strlen::str#0 = ++ strlen::str#3 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [502] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [502] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [502] phi strlen::str#3 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
  .segment Data
    .label len = fgets.remaining
    .label return = fgets.remaining
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
    // [508] return 
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
// __mem() int ferror(__zp($d4) FILE *stream)
ferror: {
    .label cbm_k_setnam1_filename = $f6
    .label stream = $d4
    .label errno_len = $54
    // unsigned char sp = (unsigned char)stream
    // [509] ferror::sp#0 = (char)ferror::stream#0 -- vbum1=_byte_pssz2 
    lda.z stream
    sta sp
    // cbm_k_setlfs(15, 8, 15)
    // [510] cbm_k_setlfs::channel = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_setlfs.channel
    // [511] cbm_k_setlfs::device = 8 -- vbum1=vbuc1 
    lda #8
    sta cbm_k_setlfs.device
    // [512] cbm_k_setlfs::command = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_setlfs.command
    // [513] call cbm_k_setlfs
    jsr cbm_k_setlfs
    // ferror::@11
    // cbm_k_setnam("")
    // [514] ferror::cbm_k_setnam1_filename = ferror::$18 -- pbuz1=pbuc1 
    lda #<ferror__18
    sta.z cbm_k_setnam1_filename
    lda #>ferror__18
    sta.z cbm_k_setnam1_filename+1
    // ferror::cbm_k_setnam1
    // strlen(filename)
    // [515] strlen::str#2 = ferror::cbm_k_setnam1_filename -- pbuz1=pbuz2 
    lda.z cbm_k_setnam1_filename
    sta.z strlen.str
    lda.z cbm_k_setnam1_filename+1
    sta.z strlen.str+1
    // [516] call strlen
    // [501] phi from ferror::cbm_k_setnam1 to strlen [phi:ferror::cbm_k_setnam1->strlen]
    // [501] phi strlen::str#5 = strlen::str#2 [phi:ferror::cbm_k_setnam1->strlen#0] -- register_copy 
    jsr strlen
    // strlen(filename)
    // [517] strlen::return#3 = strlen::len#2
    // ferror::@12
    // [518] ferror::cbm_k_setnam1_$0 = strlen::return#3
    // char filename_len = (char)strlen(filename)
    // [519] ferror::cbm_k_setnam1_filename_len = (char)ferror::cbm_k_setnam1_$0 -- vbum1=_byte_vwum2 
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
    // [522] ferror::cbm_k_chkin1_channel = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_chkin1_channel
    // ferror::cbm_k_chkin1
    // char status
    // [523] ferror::cbm_k_chkin1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chkin1_status
    // asm
    // asm { ldxchannel jsrCBM_CHKIN stastatus  }
    ldx cbm_k_chkin1_channel
    jsr CBM_CHKIN
    sta cbm_k_chkin1_status
    // ferror::cbm_k_chrin1
    // char ch
    // [525] ferror::cbm_k_chrin1_ch = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chrin1_ch
    // asm
    // asm { jsrCBM_CHRIN stach  }
    jsr CBM_CHRIN
    sta cbm_k_chrin1_ch
    // return ch;
    // [527] ferror::cbm_k_chrin1_return#0 = ferror::cbm_k_chrin1_ch -- vbuaa=vbum1 
    // ferror::cbm_k_chrin1_@return
    // }
    // [528] ferror::cbm_k_chrin1_return#1 = ferror::cbm_k_chrin1_return#0
    // ferror::@7
    // char ch = cbm_k_chrin()
    // [529] ferror::ch#0 = ferror::cbm_k_chrin1_return#1 -- vbum1=vbuaa 
    sta ch
    // [530] phi from ferror::@7 to ferror::cbm_k_readst1 [phi:ferror::@7->ferror::cbm_k_readst1]
    // [530] phi __errno#106 = __errno#37 [phi:ferror::@7->ferror::cbm_k_readst1#0] -- register_copy 
    // [530] phi ferror::errno_len#10 = 0 [phi:ferror::@7->ferror::cbm_k_readst1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z errno_len
    // [530] phi ferror::ch#10 = ferror::ch#0 [phi:ferror::@7->ferror::cbm_k_readst1#2] -- register_copy 
    // [530] phi ferror::errno_parsed#2 = 0 [phi:ferror::@7->ferror::cbm_k_readst1#3] -- vbum1=vbuc1 
    sta errno_parsed
    // ferror::cbm_k_readst1
  cbm_k_readst1:
    // char status
    // [531] ferror::cbm_k_readst1_status = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_readst1_status
    // asm
    // asm { jsrCBM_READST stastatus  }
    jsr CBM_READST
    sta cbm_k_readst1_status
    // return status;
    // [533] ferror::cbm_k_readst1_return#0 = ferror::cbm_k_readst1_status -- vbuaa=vbum1 
    // ferror::cbm_k_readst1_@return
    // }
    // [534] ferror::cbm_k_readst1_return#1 = ferror::cbm_k_readst1_return#0
    // ferror::@8
    // cbm_k_readst()
    // [535] ferror::$6 = ferror::cbm_k_readst1_return#1
    // st = cbm_k_readst()
    // [536] ferror::st#1 = ferror::$6
    // while (!(st = cbm_k_readst()))
    // [537] if(0==ferror::st#1) goto ferror::@1 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b1
    // ferror::@2
    // __status = st
    // [538] ((char *)&__stdio_file+OFFSET_STRUCT_FILE_STATUS)[ferror::sp#0] = ferror::st#1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy sp
    sta __stdio_file+OFFSET_STRUCT_FILE_STATUS,y
    // cbm_k_close(15)
    // [539] ferror::cbm_k_close1_channel = $f -- vbum1=vbuc1 
    lda #$f
    sta cbm_k_close1_channel
    // ferror::cbm_k_close1
    // asm
    // asm { ldachannel jsrCBM_CLOSE  }
    jsr CBM_CLOSE
    // ferror::@9
    // return __errno;
    // [541] ferror::return#1 = __errno#106 -- vwsm1=vwsm2 
    lda __errno
    sta return
    lda __errno+1
    sta return+1
    // ferror::@return
    // }
    // [542] return 
    rts
    // ferror::@1
  __b1:
    // if (!errno_parsed)
    // [543] if(0!=ferror::errno_parsed#2) goto ferror::@3 -- 0_neq_vbum1_then_la1 
    lda errno_parsed
    bne __b3
    // ferror::@4
    // if (ch == ',')
    // [544] if(ferror::ch#10!=','pm) goto ferror::@3 -- vbum1_neq_vbuc1_then_la1 
    lda #','
    cmp ch
    bne __b3
    // ferror::@5
    // errno_parsed++;
    // [545] ferror::errno_parsed#1 = ++ ferror::errno_parsed#2 -- vbum1=_inc_vbum1 
    inc errno_parsed
    // strncpy(temp, __errno_error, errno_len+1)
    // [546] strncpy::n#0 = ferror::errno_len#10 + 1 -- vwum1=vbuz2_plus_1 
    lda.z errno_len
    clc
    adc #1
    sta strncpy.n
    lda #0
    adc #0
    sta strncpy.n+1
    // [547] call strncpy
    // [582] phi from ferror::@5 to strncpy [phi:ferror::@5->strncpy]
    jsr strncpy
    // [548] phi from ferror::@5 to ferror::@13 [phi:ferror::@5->ferror::@13]
    // ferror::@13
    // atoi(temp)
    // [549] call atoi
    // [561] phi from ferror::@13 to atoi [phi:ferror::@13->atoi]
    // [561] phi atoi::str#2 = ferror::temp [phi:ferror::@13->atoi#0] -- pbuz1=pbuc1 
    lda #<temp
    sta.z atoi.str
    lda #>temp
    sta.z atoi.str+1
    jsr atoi
    // atoi(temp)
    // [550] atoi::return#4 = atoi::return#2
    // ferror::@14
    // __errno = atoi(temp)
    // [551] __errno#2 = atoi::return#4 -- vwsm1=vwsm2 
    lda atoi.return
    sta __errno
    lda atoi.return+1
    sta __errno+1
    // [552] phi from ferror::@1 ferror::@14 ferror::@4 to ferror::@3 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3]
    // [552] phi __errno#77 = __errno#106 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3#0] -- register_copy 
    // [552] phi ferror::errno_parsed#11 = ferror::errno_parsed#2 [phi:ferror::@1/ferror::@14/ferror::@4->ferror::@3#1] -- register_copy 
    // ferror::@3
  __b3:
    // __errno_error[errno_len] = ch
    // [553] __errno_error[ferror::errno_len#10] = ferror::ch#10 -- pbuc1_derefidx_vbuz1=vbum2 
    lda ch
    ldy.z errno_len
    sta __errno_error,y
    // errno_len++;
    // [554] ferror::errno_len#1 = ++ ferror::errno_len#10 -- vbuz1=_inc_vbuz1 
    inc.z errno_len
    // ferror::cbm_k_chrin2
    // char ch
    // [555] ferror::cbm_k_chrin2_ch = 0 -- vbum1=vbuc1 
    lda #0
    sta cbm_k_chrin2_ch
    // asm
    // asm { jsrCBM_CHRIN stach  }
    jsr CBM_CHRIN
    sta cbm_k_chrin2_ch
    // return ch;
    // [557] ferror::cbm_k_chrin2_return#0 = ferror::cbm_k_chrin2_ch -- vbuaa=vbum1 
    // ferror::cbm_k_chrin2_@return
    // }
    // [558] ferror::cbm_k_chrin2_return#1 = ferror::cbm_k_chrin2_return#0
    // ferror::@10
    // cbm_k_chrin()
    // [559] ferror::$15 = ferror::cbm_k_chrin2_return#1
    // ch = cbm_k_chrin()
    // [560] ferror::ch#1 = ferror::$15 -- vbum1=vbuaa 
    sta ch
    // [530] phi from ferror::@10 to ferror::cbm_k_readst1 [phi:ferror::@10->ferror::cbm_k_readst1]
    // [530] phi __errno#106 = __errno#77 [phi:ferror::@10->ferror::cbm_k_readst1#0] -- register_copy 
    // [530] phi ferror::errno_len#10 = ferror::errno_len#1 [phi:ferror::@10->ferror::cbm_k_readst1#1] -- register_copy 
    // [530] phi ferror::ch#10 = ferror::ch#1 [phi:ferror::@10->ferror::cbm_k_readst1#2] -- register_copy 
    // [530] phi ferror::errno_parsed#2 = ferror::errno_parsed#11 [phi:ferror::@10->ferror::cbm_k_readst1#3] -- register_copy 
    jmp cbm_k_readst1
  .segment Data
    temp: .fill 4, 0
    ferror__18: .text ""
    .byte 0
    cbm_k_setnam1_filename_len: .byte 0
    .label cbm_k_setnam1_ferror__0 = fgets.remaining
    cbm_k_chkin1_channel: .byte 0
    cbm_k_chkin1_status: .byte 0
    cbm_k_chrin1_ch: .byte 0
    cbm_k_readst1_status: .byte 0
    cbm_k_close1_channel: .byte 0
    cbm_k_chrin2_ch: .byte 0
    .label return = fgets.remaining
    sp: .byte 0
    ch: .byte 0
    errno_parsed: .byte 0
}
.segment Code
  // atoi
// Converts the string argument str to an integer.
// __mem() int atoi(__zp($32) const char *str)
atoi: {
    .label str = $32
    // if (str[i] == '-')
    // [562] if(*atoi::str#2!='-'pm) goto atoi::@3 -- _deref_pbuz1_neq_vbuc1_then_la1 
    ldy #0
    lda (str),y
    cmp #'-'
    bne __b2
    // [563] phi from atoi to atoi::@2 [phi:atoi->atoi::@2]
    // atoi::@2
    // [564] phi from atoi::@2 to atoi::@3 [phi:atoi::@2->atoi::@3]
    // [564] phi atoi::negative#2 = 1 [phi:atoi::@2->atoi::@3#0] -- vbuxx=vbuc1 
    ldx #1
    // [564] phi atoi::res#2 = 0 [phi:atoi::@2->atoi::@3#1] -- vwsm1=vwsc1 
    tya
    sta res
    sta res+1
    // [564] phi atoi::i#4 = 1 [phi:atoi::@2->atoi::@3#2] -- vbuyy=vbuc1 
    ldy #1
    jmp __b3
  // Iterate through all digits and update the result
    // [564] phi from atoi to atoi::@3 [phi:atoi->atoi::@3]
  __b2:
    // [564] phi atoi::negative#2 = 0 [phi:atoi->atoi::@3#0] -- vbuxx=vbuc1 
    ldx #0
    // [564] phi atoi::res#2 = 0 [phi:atoi->atoi::@3#1] -- vwsm1=vwsc1 
    txa
    sta res
    sta res+1
    // [564] phi atoi::i#4 = 0 [phi:atoi->atoi::@3#2] -- vbuyy=vbuc1 
    tay
    // atoi::@3
  __b3:
    // for (; str[i]>='0' && str[i]<='9'; ++i)
    // [565] if(atoi::str#2[atoi::i#4]<'0'pm) goto atoi::@5 -- pbuz1_derefidx_vbuyy_lt_vbuc1_then_la1 
    lda (str),y
    cmp #'0'
    bcc __b5
    // atoi::@6
    // [566] if(atoi::str#2[atoi::i#4]<='9'pm) goto atoi::@4 -- pbuz1_derefidx_vbuyy_le_vbuc1_then_la1 
    lda (str),y
    cmp #'9'
    bcc __b4
    beq __b4
    // atoi::@5
  __b5:
    // if(negative)
    // [567] if(0!=atoi::negative#2) goto atoi::@1 -- 0_neq_vbuxx_then_la1 
    // Return result with sign
    cpx #0
    bne __b1
    // [569] phi from atoi::@1 atoi::@5 to atoi::@return [phi:atoi::@1/atoi::@5->atoi::@return]
    // [569] phi atoi::return#2 = atoi::return#0 [phi:atoi::@1/atoi::@5->atoi::@return#0] -- register_copy 
    rts
    // atoi::@1
  __b1:
    // return -res;
    // [568] atoi::return#0 = - atoi::res#2 -- vwsm1=_neg_vwsm1 
    lda #0
    sec
    sbc return
    sta return
    lda #0
    sbc return+1
    sta return+1
    // atoi::@return
    // }
    // [570] return 
    rts
    // atoi::@4
  __b4:
    // res * 10
    // [571] atoi::$10 = atoi::res#2 << 2 -- vwsm1=vwsm2_rol_2 
    lda res
    asl
    sta atoi__10
    lda res+1
    rol
    sta atoi__10+1
    asl atoi__10
    rol atoi__10+1
    // [572] atoi::$11 = atoi::$10 + atoi::res#2 -- vwsm1=vwsm2_plus_vwsm1 
    clc
    lda atoi__11
    adc atoi__10
    sta atoi__11
    lda atoi__11+1
    adc atoi__10+1
    sta atoi__11+1
    // [573] atoi::$6 = atoi::$11 << 1 -- vwsm1=vwsm1_rol_1 
    asl atoi__6
    rol atoi__6+1
    // res * 10 + str[i]
    // [574] atoi::$7 = atoi::$6 + atoi::str#2[atoi::i#4] -- vwsm1=vwsm1_plus_pbuz2_derefidx_vbuyy 
    lda atoi__7
    clc
    adc (str),y
    sta atoi__7
    bcc !+
    inc atoi__7+1
  !:
    // res = res * 10 + str[i] - '0'
    // [575] atoi::res#1 = atoi::$7 - '0'pm -- vwsm1=vwsm1_minus_vbuc1 
    lda res
    sec
    sbc #'0'
    sta res
    bcs !+
    dec res+1
  !:
    // for (; str[i]>='0' && str[i]<='9'; ++i)
    // [576] atoi::i#2 = ++ atoi::i#4 -- vbuyy=_inc_vbuyy 
    iny
    // [564] phi from atoi::@4 to atoi::@3 [phi:atoi::@4->atoi::@3]
    // [564] phi atoi::negative#2 = atoi::negative#2 [phi:atoi::@4->atoi::@3#0] -- register_copy 
    // [564] phi atoi::res#2 = atoi::res#1 [phi:atoi::@4->atoi::@3#1] -- register_copy 
    // [564] phi atoi::i#4 = atoi::i#2 [phi:atoi::@4->atoi::@3#2] -- register_copy 
    jmp __b3
  .segment Data
    .label atoi__6 = fgets.remaining
    .label atoi__7 = fgets.remaining
    .label res = fgets.remaining
    .label return = fgets.remaining
    .label atoi__10 = fgets.read
    .label atoi__11 = fgets.remaining
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
// __mem() unsigned int cx16_k_macptr(__mem() volatile char bytes, __zp($59) void * volatile buffer)
cx16_k_macptr: {
    .label buffer = $59
    // unsigned int bytes_read
    // [577] cx16_k_macptr::bytes_read = 0 -- vwum1=vwuc1 
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
    // [579] cx16_k_macptr::return#0 = cx16_k_macptr::bytes_read -- vwum1=vwum2 
    lda bytes_read
    sta return
    lda bytes_read+1
    sta return+1
    // cx16_k_macptr::@return
    // }
    // [580] cx16_k_macptr::return#1 = cx16_k_macptr::return#0
    // [581] return 
    rts
  .segment Data
    bytes: .byte 0
    bytes_read: .word 0
    return: .word 0
}
.segment Code
  // strncpy
/// Copies up to n characters from the string pointed to, by src to dst.
/// In a case where the length of src is less than that of n, the remainder of dst will be padded with null bytes.
/// @param dst ? This is the pointer to the destination array where the content is to be copied.
/// @param src ? This is the string to be copied.
/// @param n ? The number of characters to be copied from source.
/// @return The destination
// char * strncpy(__zp($42) char *dst, __zp($32) const char *src, __mem() unsigned int n)
strncpy: {
    .label dst = $42
    .label src = $32
    // [583] phi from strncpy to strncpy::@1 [phi:strncpy->strncpy::@1]
    // [583] phi strncpy::dst#2 = ferror::temp [phi:strncpy->strncpy::@1#0] -- pbuz1=pbuc1 
    lda #<ferror.temp
    sta.z dst
    lda #>ferror.temp
    sta.z dst+1
    // [583] phi strncpy::src#2 = __errno_error [phi:strncpy->strncpy::@1#1] -- pbuz1=pbuc1 
    lda #<__errno_error
    sta.z src
    lda #>__errno_error
    sta.z src+1
    // [583] phi strncpy::i#2 = 0 [phi:strncpy->strncpy::@1#2] -- vwum1=vwuc1 
    lda #<0
    sta i
    sta i+1
    // strncpy::@1
  __b1:
    // for(size_t i = 0;i<n;i++)
    // [584] if(strncpy::i#2<strncpy::n#0) goto strncpy::@2 -- vwum1_lt_vwum2_then_la1 
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
    // [585] return 
    rts
    // strncpy::@2
  __b2:
    // char c = *src
    // [586] strncpy::c#0 = *strncpy::src#2 -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (src),y
    // if(c)
    // [587] if(0==strncpy::c#0) goto strncpy::@3 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b3
    // strncpy::@4
    // src++;
    // [588] strncpy::src#0 = ++ strncpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [589] phi from strncpy::@2 strncpy::@4 to strncpy::@3 [phi:strncpy::@2/strncpy::@4->strncpy::@3]
    // [589] phi strncpy::src#6 = strncpy::src#2 [phi:strncpy::@2/strncpy::@4->strncpy::@3#0] -- register_copy 
    // strncpy::@3
  __b3:
    // *dst++ = c
    // [590] *strncpy::dst#2 = strncpy::c#0 -- _deref_pbuz1=vbuaa 
    ldy #0
    sta (dst),y
    // *dst++ = c;
    // [591] strncpy::dst#0 = ++ strncpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // for(size_t i = 0;i<n;i++)
    // [592] strncpy::i#1 = ++ strncpy::i#2 -- vwum1=_inc_vwum1 
    inc i
    bne !+
    inc i+1
  !:
    // [583] phi from strncpy::@3 to strncpy::@1 [phi:strncpy::@3->strncpy::@1]
    // [583] phi strncpy::dst#2 = strncpy::dst#0 [phi:strncpy::@3->strncpy::@1#0] -- register_copy 
    // [583] phi strncpy::src#2 = strncpy::src#6 [phi:strncpy::@3->strncpy::@1#1] -- register_copy 
    // [583] phi strncpy::i#2 = strncpy::i#1 [phi:strncpy::@3->strncpy::@1#2] -- register_copy 
    jmp __b1
  .segment Data
    .label i = fgets.remaining
    .label n = fgets.read
}
  // File Data Internal or Ignore
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
.segment BramEngineFlight
  __46: .text "t001"
  .byte 0
  __47: .text "p001"
  .byte 0
  __48: .text "n001"
  .byte 0
  __49: .text "e0701"
  .byte 0
  __50: .text "e0102"
  .byte 0
  __51: .text "e0201"
  .byte 0
  __52: .text "e0202"
  .byte 0
  __53: .text "e0301"
  .byte 0
  __54: .text "e0302"
  .byte 0
  __55: .text "e0401"
  .byte 0
  __56: .text "e0501"
  .byte 0
  __57: .text "e0502"
  .byte 0
  __58: .text "e0601"
  .byte 0
  __59: .text "e0602"
  .byte 0
  __60: .text "e0101"
  .byte 0
  __61: .text "e0702"
  .byte 0
  __62: .text "e0703"
  .byte 0
  __63: .text "b001"
  .byte 0
  __64: .text "b002"
  .byte 0
  __65: .text "b003"
  .byte 0
  __66: .text "b004"
  .byte 0
.segment Data
  nmi_relay: .word 0
  brk_relay: .word 0
  isr_vsync: .word 0
  __stdio_file: .fill SIZEOF_STRUCT_FILE, 0
  __stdio_filecount: .byte 0
  // The mouse work area.
  cx16_mouse: .fill SIZEOF_STRUCT_CX16_MOUSE_T, 0
.segment BramEngineFlight
  sprites: .word __46, __47, __48, __49, __50, __51, __52, __53, __54, __55, __56, __57, __58, __59, __60, __61, __62, __63, __64, __65, __66
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
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
  .fill SIZEOF_STRUCT_AABB_T, 0
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
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  mars_sand: .byte $5e, 2, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, $f, 1, 2, 3, 4
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  mars_sea: .byte $62, 5, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, $f, 1, 2, 5, 1, $f, 3, 4, 7, 8, $f, 9, $a, $d, $e, $f, $b, $c, $f, $10
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  metal_yellow: .byte $72, $20, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, 1, $1d, $2a, $2a, $29, 2, $29, $16, $2a, $29, 3, $19, $1a, $2a, $29, 4, $29, $2a, $b, $29, 5, $11, $2a, $13, $29, 6, $25, $22, $23, $28, 7, $2a, $e, 7, $25, 8, $29, $2a, $2a, 4, 9, $29, $e, $2a, $10, $a, $d, $e, $f, $10, $b, $11, $29, $26, 8, $c, $2a, $29, 7, 8, $d, $19, $27, $29, $10, $e, $28, $1a, $13, $2a, $f, $29, $2a, $2a, $29, $10, 0, 0, 0, 0, $11, $29, $1e, $1f, $20, $12, $15, $2a, $17, $18, $13, $29, $2a, $1b, $1c, $14, 9, $a, $2a, $c, $15, $29, $12, $2a, $14, $16, $25, $22, $23, $28, $17, $21, $2a, $2a, $29, $18, 1, 2, 3, $29, $19, $d, $2a, $f, $29, $1a, $d, $2a, $f, $29, $1b, $2a, $22, $2a, $29, $1c, 5, 6, $2a, $29, $1d, $29, $2a, $23, $29, $1e, $29, $2a, $2a, $24, $1f, $29, $2a, $2a, $29
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  metal_red: .byte $86, 2, 0
  .fill $1f, 0
  .byte 0
  .fill $1f, 0
  .byte 0, 0, 0, 0, 0, $f, 1, 1, 1, 1
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
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
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
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
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  .fill SIZEOF_STRUCT_FLOOR_SEGMENT_T, 0
  tower_01: .word tower_parts_01, mars_sea, mars_land
  .fill 2*8, 0
  .word mars_sea
  .byte $f, $f, $f, $f
  .word mars_land
  .byte 0, 0, 0, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .fill SIZEOF_STRUCT_FLOOR_COMPOSITION_T, 0
  .byte 0
.segment BramEngineStages
  stage_player: .byte 1
  .word stage_player_engine, stage_player_bullet
  stage_player_engine: .byte 2
  stage_player_bullet: .byte $11
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
.segment Data
  // __mem FILE* music;
  // unsigned char music_buffer[1024];
  sprite_offset: .byte 0
  __errno: .word 0
 // Asm import library lib_conio:
#define __asm_import__lib_conio__
#import "lib_conio.asm"

 // Asm import library lib_lru_cache:
#define __asm_import__lib_lru_cache__
#import "lib_lru_cache.asm"

 // Asm import library lib_bramheap:
#define __asm_import__lib_bramheap__
#import "lib_bramheap.asm"

 // Asm import library lib_veraheap:
#define __asm_import__lib_veraheap__
#import "lib_veraheap.asm"

 // Asm import library cx16_file:
#define __asm_import__cx16_file__
#import "cx16_file.asm"

 // Asm import library equinoxe-layers:
#define __asm_import__equinoxe_layers__
#import "equinoxe-layers.asm"

 // Asm import library equinoxe-animate:
#define __asm_import__equinoxe_animate__
#import "equinoxe-animate.asm"

 // Asm import library equinoxe-palette:
#define __asm_import__equinoxe_palette__
#import "equinoxe-palette.asm"

 // Asm import library equinoxe-flightengine:
#define __asm_import__equinoxe_flightengine__
#import "equinoxe-flightengine.asm"

